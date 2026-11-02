# 000 · The node

Signed: group 2, 22:31

## GOAL

One program, `graph/node.sh`, runs any step of the graph from a job written in a folder:
commands (grey) or an agent with a ticket (blue). It always answers green or red with the
reason, so nobody has to read a log to know what happened.

## SCOPE

May write: `graph/node.sh` and `graph/tests/test-node.sh`.
May not write: `graph/lib.sh`, `graph/copilot.sh`, `graph/tests/fake-agent.sh`,
`graph/REPORT.md`, `graph/NODE.md`, `app/`, `tickets/`, `openspec/`.

## CONTEXT

The contract is `graph/NODE.md`, and the OpenSpec change `openspec/changes/generic-node/`.
Proof it is missing: `sh graph/node.sh graph/runs/try/step-1` prints
`node.sh: not written yet, see graph/NODE.md` and exits 2, and there is no
`graph/tests/test-node.sh`. Given and ready: `graph/lib.sh` (`json_get`, `json_valid`,
`json_escape`, `run_limited`), `graph/tests/fake-agent.sh` (the agent of the tests) and
`graph/REPORT.md` (the four headings of an agent's report). Decisions of group 2
(`notes/decisions.tsv`, 2 November): the agent runs at most five minutes; it may touch
`app/` only; an agent that ends without a report is red.

## ACCEPTANCE

1. Commands that pass: green, exit 0, and `report.md` has their output.
2. Commands that fail: red, exit 1, and the why names `report.md`.
3. The agent finishes with a four-heading report: green, and `agent.log` is in the step folder.
4. The agent fails, runs past its `limit` (`"limit":2`, ticket `slow.md`), or ends without a report (ticket `no-report.md`): red, and the why says which. When `limit` is absent the node uses 300 seconds (five minutes, decided by the group).
5. The agent writes outside `dir` (the group decided `dir` is `app` only; the step folder under `graph/runs/` stays allowed): red, and the why names the path.
6. A malformed job (two `kind`, three `ticket`, no `dir`, an unknown `kind`): red, nothing run, nothing written but `output.json` and `report.md`. The test checks this from a clean `app/`: what earlier cases left there is cleared first (in the throwaway folder only), so "nothing written" is about this job alone. The node never deletes or reverts an agent's work. Any listing the test makes to compare before and after is kept outside the folder it lists, so the test never counts its own files as written by the node.
7. `Verdict: block` in the report is red; `Verdict: pass` is green.

## VERIFY

`sh graph/tests/test-node.sh`: one `  ok` line per check, no `  FAIL`, exit 0. It builds a
throwaway group folder and uses `graph/tests/fake-agent.sh`: no model is called.

## FORBIDDEN

Calling a real model from the test. Editing `fake-agent.sh` or `lib.sh` to make a case
pass. A node file per step, or a second program for agents: one node.

## REPORT

Done or blocked, the files you changed, and the full output of `sh graph/tests/test-node.sh`.
