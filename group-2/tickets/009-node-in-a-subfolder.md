# 009 · The node works when the group folder is inside a bigger repository

## GOAL

A blue step whose agent writes only inside its `dir` comes out green even when the group
folder is a subfolder of the git repository, as `group-2/` is in the workshop repository.
Today run 001 went red at step 2 with "agent touched outside app: group-2/app/stock.js
group-2/app/test/stock.test.html", though both files are inside `app/`.

## SCOPE

May write: `graph/node.sh` and `graph/tests/test-node-subfolder.sh` (new).
May not write: `graph/tests/test-node.sh`, `graph/tests/test-run.sh`,
`graph/tests/fake-agent.sh`, `graph/lib.sh`, `graph/run.sh`, `graph/copilot.sh`,
`graph/NODE.md`, `graph/path.jsonl`, `app/`, `tickets/`, `openspec/`, `.github/`.

## CONTEXT

`graph/node.sh`, lines 77 and 92–107: `changes()` is `git status --porcelain -uall`, which
prints paths from the repository root (`group-2/app/stock.js`), while `allowed()` compares
them with `"$dir"/*` and `graph/runs/*`, which are relative to the group folder. In
`test-node.sh` the throwaway group folder is itself the repository root, so the prefix is
empty and the bug never showed. `git rev-parse --show-prefix`, run from the group folder,
prints that prefix (`group-2/`), or nothing at the root.
Proof it is missing: `cat graph/runs/001-stock-per-variant/step-2-work/output.json`.
`graph/tests/fake-agent.sh` with a ticket named `good` writes a small file under `<dir>/`;
named `outside`, it writes a file under `tickets/`. See `test-node.sh` for how a throwaway
folder, an `input.json` and the node are put together; NODE.md is the contract.
Depends on: none.

## ACCEPTANCE

- 9.1 · A throwaway git repository with the group folder one level down (`<repo>/grp/`):
  a blue step with `dir` `app` and the fake agent's `good` ticket comes out green.
- 9.2 · Same repository: the fake agent's `outside` ticket comes out red, and its `why`
  says "touched outside app" and names the file under `tickets/`.
- 9.3 · Same repository: a change under the group's `graph/runs/` is still allowed.
- 9.4 · `sh graph/tests/test-node.sh` still passes unchanged (group folder at the root).

## VERIFY

From `group-2`: `sh graph/tests/test-node-subfolder.sh` prints one `ok` line per scenario
9.1 to 9.3 and exits 0; it fails before the change to `graph/node.sh` and passes after
it. Then `sh graph/tests/run-all.sh` is all PASS. No model is called.

## FORBIDDEN

- Changing, skipping or weakening `test-node.sh` or `test-run.sh`.
- Allowing every path, or dropping the outside check.
- Touching the run of 001 under `graph/runs/`.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh graph/tests/run-all.sh` output.
