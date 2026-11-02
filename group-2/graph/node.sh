#!/bin/sh
# The node: one program for every step of the path. sh graph/node.sh <step-folder>
# The contract is graph/NODE.md. Run it from the group folder.
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/lib.sh"

if [ $# -ne 1 ] || [ ! -d "$1" ]; then
  printf 'usage: sh graph/node.sh <step-folder>\n' >&2
  exit 2
fi
step=$(cd "$1" && pwd)
input="$step/input.json"
started=$(date +%H:%M:%S)

# finish <green|red> <why>: writes output.json, prints the answer, exits with the colour.
finish() {
  printf '{"status":"%s","why":"%s","started":"%s","ended":"%s"}\n' \
    "$1" "$(json_escape "$2")" "$started" "$(date +%H:%M:%S)" > "$step/output.json"
  printf '%s: %s\n' "$1" "$2"
  [ "$1" = green ]
  exit $?
}

# refuse <why>: a bad job is red, nothing ran, report.md says why.
refuse() {
  printf 'The job was refused: %s\n' "$1" > "$step/report.md"
  finish red "$1"
}

# count <key>: how many times the key appears in the raw line.
count() { grep -o "\"$1\"[[:space:]]*:" "$input" 2> /dev/null | wc -l | tr -d ' '; }

[ -f "$input" ] || refuse "input.json is missing"
json_valid "$input" || refuse "input.json is not valid JSON"

kind=$(json_get "$input" kind)
[ "$(count kind)" = 1 ] || refuse "kind must appear exactly once"
dir=$(json_get "$input" dir)
[ "$(count dir)" = 1 ] || refuse "dir must appear exactly once"
[ -n "$dir" ] || refuse "dir is empty"
[ -d "$dir" ] || refuse "dir does not exist: $dir"
dir=${dir%/}

case $kind in
  commands)
    [ "$(count run)" = 1 ] || refuse "a commands job needs exactly one run"
    run=$(json_get "$input" run)
    [ -n "$run" ] || refuse "run is empty"
    ;;
  agent)
    [ "$(count ticket)" = 1 ] || refuse "an agent job needs exactly one ticket"
    ticket=$(json_get "$input" ticket)
    [ -f "$ticket" ] || refuse "ticket does not exist: $ticket"
    ;;
  *) refuse "kind must be commands or agent, not '$kind'" ;;
esac

if [ "$kind" = commands ]; then
  code=0
  sh -c "$run" > "$step/report.md" 2>&1 < /dev/null || code=$?
  if [ "$code" = 0 ]; then finish green "commands passed"; fi
  finish red "commands failed with exit $code, output in $step/report.md"
fi

agent=$(json_get "$input" agent)
[ -n "$agent" ] || agent=graph/copilot.sh
limit=$(json_get "$input" limit)
[ -n "$limit" ] || limit=300
SKILL=$(json_get "$input" skill)
MODEL=$(json_get "$input" model)
LAST=$(json_get "$input" last)
export SKILL MODEL LAST
export N_AGENT="$agent" N_TICKET="$ticket" N_DIR="$dir" N_REPORT="$step/report.md"

# changes: paths git sees changed, one per line.
changes() { git status --porcelain -uall 2> /dev/null | sort; }
before=$(changes)
rm -f "$step/report.md"
: > "$step/agent.log"

code=0
run_limited "$limit" "$(pwd)" "$step/agent.log" 'sh "$N_AGENT" "$N_TICKET" "$N_DIR" "$N_REPORT"' || code=$?

[ "$code" = 124 ] && finish red "agent cut after $limit s"
[ "$code" = 0 ] || finish red "agent failed with exit $code, see $step/agent.log"
[ -s "$step/report.md" ] || finish red "agent left no report"
for h in "Ticket" "Changed" "Checked" "Not done"; do
  grep -q "^## $h" "$step/report.md" || finish red "report.md lacks ## $h"
done

# allowed <path>: true for a path under dir/ or graph/runs/.
allowed() {
  case $1 in
    "$dir"/* | graph/runs/*) return 0 ;;
  esac
  return 1
}
after=$(changes)
prefix=$(git rev-parse --show-prefix 2> /dev/null)
outside=$(printf '%s\n' "$after" | while IFS= read -r line; do
  [ -n "$line" ] || continue
  printf '%s\n' "$before" | grep -qxF -- "$line" && continue
  p=${line#???}
  p=${p##* -> }
  p=${p#"$prefix"}
  allowed "$p" || printf '%s ' "$p"
done)
[ -z "$outside" ] || finish red "agent touched outside $dir: ${outside% }"

if grep -q '^Verdict: block' "$step/report.md"; then
  reason=$(awk '/^Verdict: block/ { getline; print; exit }' "$step/report.md")
  finish red "reviewer blocked: $reason"
fi
finish green "agent finished, report.md written"
