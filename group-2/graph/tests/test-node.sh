#!/bin/sh
# Test of the node (graph/NODE.md): sh graph/tests/test-node.sh
# Builds a throwaway group folder and runs graph/node.sh there against graph/tests/fake-agent.sh.
# No model is called.
set -u
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)
. "$root/graph/lib.sh"

g=$(mktemp -d "${TMPDIR:-/tmp}/node-test.XXXXXX")
side=$(mktemp -d "${TMPDIR:-/tmp}/node-test-side.XXXXXX")
trap 'rm -rf "$g" "$side"' EXIT

mkdir -p "$g/graph/tests" "$g/graph/runs/t" "$g/app" "$g/tickets"
cp "$root/graph/node.sh" "$root/graph/lib.sh" "$root/graph/REPORT.md" "$g/graph/"
cp "$here/fake-agent.sh" "$g/graph/tests/"
for n in good fail slow outside no-report bad-report block pass; do
  printf '# %s\n' "$n" > "$g/tickets/$n.md"
done
(cd "$g" && git init -q . && git add -A >/dev/null 2>&1 && git -c user.name=t -c user.email=t@t commit -q -m base >/dev/null 2>&1)

failed=0
ok() { printf '  ok   %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; failed=1; }
# check <case> <command...>: ok when the command succeeds
check() { c=$1; shift; if "$@" >/dev/null 2>&1; then ok "$c"; else bad "$c"; fi; }

has() { grep -q -- "$2" "$1" 2>/dev/null; }

# run_job <name> <json>: writes the job and runs the node; sets step, code, out, why, status
run_job() {
  step="$g/graph/runs/t/$1"
  rm -rf "$step"
  mkdir -p "$step"
  printf '%s\n' "$2" > "$step/input.json"
  out=$(cd "$g" && sh graph/node.sh "graph/runs/t/$1" 2>&1)
  code=$?
  why=$(json_get "$step/output.json" why)
  status=$(json_get "$step/output.json" status)
}

agent_job() { printf '{"kind":"agent","dir":"app","agent":"graph/tests/fake-agent.sh","ticket":"tickets/%s.md"%s}' "$1" "${2:-}"; }

# 1. Commands that pass
run_job pass '{"kind":"commands","dir":"app","run":"echo HELLO"}'
check "commands that pass: green, exit 0" test "$code" = 0 -a "$status" = green
check "commands that pass: report.md has the output" has "$step/report.md" HELLO
check "commands that pass: output.json is valid with started and ended" \
  sh -c ". '$root/graph/lib.sh'; json_valid '$step/output.json' && [ -n \"\$(json_get '$step/output.json' started)\" ] && [ -n \"\$(json_get '$step/output.json' ended)\" ]"
case $out in green:*) ok "commands that pass: the node says green" ;; *) bad "commands that pass: the node says green" ;; esac

# 2. Commands that fail
run_job cfail '{"kind":"commands","dir":"app","run":"echo boom; exit 3"}'
check "commands that fail: red, exit 1" test "$code" = 1 -a "$status" = red
check "commands that fail: the why names report.md" sh -c "printf '%s' '$why' | grep -q report.md"
case $out in red:*) ok "commands that fail: the node says red" ;; *) bad "commands that fail: the node says red" ;; esac

# 3. The agent finishes
run_job agent-good "$(agent_job good)"
check "agent finishes: green, exit 0" test "$code" = 0 -a "$status" = green
check "agent finishes: the why says report.md written" test "$why" = "agent finished, report.md written"
check "agent finishes: agent.log is in the step folder" test -f "$step/agent.log"
check "agent finishes: the agent's work is in app/" test -f "$g/app/fake-good.txt"

# 4. The agent fails, runs too long, leaves no report, a bad report
run_job agent-fail "$(agent_job fail)"
check "agent fails: red, why says agent failed" sh -c "[ $code = 1 ] && [ '$status' = red ] && printf '%s' '$why' | grep -q 'agent failed'"
run_job agent-slow "$(agent_job slow ',"limit":2')"
check "agent too slow: red, why says cut after 2 s" sh -c "[ $code = 1 ] && printf '%s' '$why' | grep -q 'agent cut after 2 s'"
run_job agent-noreport "$(agent_job no-report)"
check "agent without report: red, why says no report" sh -c "[ $code = 1 ] && printf '%s' '$why' | grep -q 'agent left no report'"
run_job agent-badreport "$(agent_job bad-report)"
check "report without headings: red, why names ## Checked" sh -c "[ $code = 1 ] && printf '%s' '$why' | grep -q 'report.md lacks ## Checked'"

# 5. The agent writes outside dir
run_job agent-outside "$(agent_job outside)"
check "agent writes outside dir: red" test "$code" = 1 -a "$status" = red
check "agent writes outside dir: the why names the path" sh -c "printf '%s' '$why' | grep -q 'tickets/outside.txt'"
check "agent writes outside dir: the node leaves the file (never reverts)" test -f "$g/tickets/outside.txt"

# 6. A malformed job: red, nothing run, nothing written but output.json and report.md
bad_job() { # <name> <json>
  rm -rf "$g/app" && mkdir -p "$g/app"
  rm -f "$g/tickets/outside.txt"
  rm -rf "$g/graph/runs/t/$1"
  mkdir -p "$g/graph/runs/t/$1"
  (cd "$g" && find . -path ./.git -prune -o -path "./graph/runs/t/$1" -prune -o -print | sort) > "$side/before"
  run_job "$1" "$2"
  (cd "$g" && find . -path ./.git -prune -o -path "./graph/runs/t/$1" -prune -o -print | sort) > "$side/after"
  (cd "$step" && ls | sort) > "$side/step-files"
  check "malformed ($1): red, exit 1" test "$code" = 1 -a "$status" = red
  check "malformed ($1): nothing outside the step folder written" cmp -s "$side/before" "$side/after"
  check "malformed ($1): the step folder holds only input.json, output.json, report.md" \
    sh -c "[ \"\$(cat '$side/step-files' | tr '\n' ' ')\" = 'input.json output.json report.md ' ]"
  check "malformed ($1): report.md says why" test -s "$step/report.md"
}
bad_job two-kind '{"kind":"commands","kind":"agent","dir":"app","run":"touch app/ran"}'
check "malformed (two-kind): nothing ran" test ! -e "$g/app/ran"
bad_job three-ticket '{"kind":"agent","dir":"app","agent":"graph/tests/fake-agent.sh","ticket":"tickets/good.md","ticket":"tickets/pass.md","ticket":"tickets/block.md"}'
check "malformed (three-ticket): the agent did not run" test ! -e "$g/app/fake-good.txt"
bad_job no-dir '{"kind":"commands","run":"touch app/ran"}'
check "malformed (no-dir): nothing ran" test ! -e "$g/app/ran"
bad_job unknown-kind '{"kind":"wizard","dir":"app","run":"touch app/ran"}'
check "malformed (unknown-kind): nothing ran" test ! -e "$g/app/ran"
bad_job missing-dir '{"kind":"commands","dir":"nowhere","run":"touch app/ran"}'
check "malformed (dir does not exist): nothing ran" test ! -e "$g/app/ran"

# 7. The reviewer's verdict, and what the plug receives
run_job verdict-block "$(agent_job block)"
check "Verdict: block is red" test "$code" = 1 -a "$status" = red
check "Verdict: block: the why says reviewer blocked and the reason" \
  sh -c "printf '%s' '$why' | grep -q 'reviewer blocked' && printf '%s' '$why' | grep -q 'zero price'"
run_job verdict-pass "$(agent_job pass)"
check "Verdict: pass is green" test "$code" = 0 -a "$status" = green
run_job skill-model "$(agent_job good ',"skill":"worker","model":"m1","last":"graph/runs/t/prev"')"
check "skill and model reach the plug" sh -c "grep -q 'Skill: worker' '$step/report.md' && grep -q 'Model: m1' '$step/report.md'"

[ "$failed" = 0 ]
