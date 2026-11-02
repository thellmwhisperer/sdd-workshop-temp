#!/bin/sh
# Test of the node when the group folder is a subfolder of the git repository:
# sh graph/tests/test-node-subfolder.sh. No model is called.
set -u
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)
. "$root/graph/lib.sh"

repo=$(mktemp -d "${TMPDIR:-/tmp}/node-sub-test.XXXXXX")
trap 'rm -rf "$repo"' EXIT
g="$repo/grp"

mkdir -p "$g/graph/tests" "$g/graph/runs/t" "$g/app" "$g/tickets"
cp "$root/graph/node.sh" "$root/graph/lib.sh" "$root/graph/REPORT.md" "$g/graph/"
cp "$here/fake-agent.sh" "$g/graph/tests/"
for n in good outside; do
  printf '# %s\n' "$n" > "$g/tickets/$n.md"
done
# An agent that writes only under the group's graph/runs/
cat > "$g/graph/tests/runs-agent.sh" <<'AGENT'
#!/bin/sh
set -eu
mkdir -p graph/runs/other
printf 'x\n' > graph/runs/other/note.txt
printf '## Ticket\n%s\n\n## Changed\n- graph/runs/other/note.txt\n\n## Checked\nnothing\n\n## Not done\nnothing\n' "$1" > "$3"
AGENT
printf '# runs\n' > "$g/tickets/runs.md"
(cd "$repo" && git init -q . && git add -A >/dev/null 2>&1 && git -c user.name=t -c user.email=t@t commit -q -m base >/dev/null 2>&1)

failed=0
ok() { printf '  ok   %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; failed=1; }

# run_job <name> <agent script> <ticket>: sets code, why, status
run_job() {
  step="$g/graph/runs/t/$1"
  rm -rf "$step"
  mkdir -p "$step"
  printf '{"kind":"agent","dir":"app","agent":"%s","ticket":"tickets/%s.md"}\n' "$2" "$3" > "$step/input.json"
  (cd "$g" && sh graph/node.sh "graph/runs/t/$1" >/dev/null 2>&1)
  code=$?
  why=$(json_get "$step/output.json" why)
  status=$(json_get "$step/output.json" status)
}

# 9.1 The agent writes only inside app/: green
run_job good graph/tests/fake-agent.sh good
if [ "$code" = 0 ] && [ "$status" = green ] && [ -f "$g/app/fake-good.txt" ]; then
  ok "9.1 subfolder: an agent writing inside app/ is green"
else bad "9.1 subfolder: an agent writing inside app/ is green (status=$status why=$why)"; fi

# 9.2 The agent writes outside app/: red, naming the file
run_job outside graph/tests/fake-agent.sh outside
if [ "$code" = 1 ] && [ "$status" = red ] \
  && printf '%s' "$why" | grep -q 'touched outside app' \
  && printf '%s' "$why" | grep -q 'tickets/outside.txt'; then
  ok "9.2 subfolder: an agent writing under tickets/ is red and the why names the file"
else bad "9.2 subfolder: an agent writing under tickets/ is red and the why names the file (status=$status why=$why)"; fi
rm -f "$g/tickets/outside.txt"

# 9.3 A change under the group's graph/runs/ is still allowed
run_job runs graph/tests/runs-agent.sh runs
if [ "$code" = 0 ] && [ "$status" = green ] && [ -f "$g/graph/runs/other/note.txt" ]; then
  ok "9.3 subfolder: a change under graph/runs/ is allowed"
else bad "9.3 subfolder: a change under graph/runs/ is allowed (status=$status why=$why)"; fi

exit $failed
