---
name: fix-reported-bug
description: >
  Diagnose and fix application defects reported through bug reports,
  exceptions, logs, or reproducible incorrect behavior. Prove the fix with a
  regression test that fails for the reported reason before the fix and passes
  afterward; honor investigation-only or reproduction-only requests.
---

# Fix a reported bug

Treat the report as evidence, not proof of its proposed cause or fix. For
investigation-only work, deliver findings and a proposed next step; for
reproduction-only work, deliver the demonstrated test failure. Otherwise,
continue through the fix and verification.

## 1. Diagnose

Read repository instructions and relevant code and test conventions. Establish:

- Expected versus observed behavior and the failing operation or entry point.
- Exception and application frames, or incorrect output without an exception.
- Triggering data, relationships, flags, and execution branch.
- Environment and versions relevant to reproduction; recency and occurrences
  when available and useful for priority.

Separate facts from hypotheses. Group reports by shared cause only when traces,
inputs, or code support it; matching exception titles are insufficient.
Distinguish a current application defect from a corrected historical incident,
external-service failure, or local setup problem. An unresolved report alone
justifies no application change.

Before implementation, briefly explain the causal chain: trigger → operation →
failure → intended behavior. Investigate missing facts that could change the
implementation before making dependent changes. If evidence remains missing or
does not justify a fix, report the uncertainty, its effect on the diagnosis,
and the next diagnostic step; do not make speculative changes.

## 2. Establish a stable red test

Write a regression against the unfixed application, using the smallest scope
that retains the real failure. Use a request test when controller-to-component
integration matters; a component test may suffice for a self-contained failure.
Explicitly construct minimal fixtures or factories with the triggering
relationships and flags. Cover materially different affected paths as needed,
not one test per report ID.

Assert intended observable behavior independently of the proposed implementation:
for example, a successful response **and** its required link, or a job's
persisted effect. Do not assert internal helper calls for an output requirement
or make the test pass by expecting the reported exception. Do not stub the
failing method, suppress the exception, or mock away the affected integration.
Unrelated external dependencies may be mocked if the trigger and verified
behavior remain intact.

Before changing application code:

1. Validate setup, matchers, and assertions, including assertions hidden behind
   the initial failure. HTML matchers must receive supported parsed objects,
   not arbitrary response strings.
2. Finish required lint and formatting adjustments, including expectation
   grouping. This stabilizes the test before implementation; it is no reason
   for unrelated polish or cosmetic delays.
3. Prepare the configured runtime, test database, services, and compiled assets
   as needed.
4. Run the regression and inspect why it fails. **Red means the reported defect
   caused the failure.** Missing dependencies, invalid factories, broken
   matchers, or unrelated exceptions do not count. Resolve them and rerun;
   otherwise report the blocker without claiming reproduction.

Once valid, compliant, and red for the reported reason, keep the test's setup,
data, requests, and assertions unchanged throughout implementation and checks.
If correction becomes necessary, follow step 4 to establish a new baseline.

Retain the command, test case, exception or failed assertion, and relevant source
location as evidence; a nonzero exit alone proves nothing. Ordinary command
output suffices. Add no process logs or investigation documents to the repository
unless requested or required by its conventions.

## 3. Make the smallest justified fix

After establishing red, fix the supported root cause while preserving the test's
trigger and expected behavior. Use existing abstractions and conventions. Avoid
unrelated cleanup, blanket exception handling, dependency upgrades, or
compatibility layers unless needed for this defect. Do not replace a local
helper or rendering fix with global configuration changes without evidence.
Explain material tradeoffs between plausible fixes; prefer a localized change
that preserves unrelated behavior. Silently dropping required content does not
fix a rendering failure.

## 4. Prove the same test red and green

**The final regression must fail against the unfixed application for the
reported reason and pass against the fixed application, using the same trigger,
expected behavior, and equivalent relevant configuration and dependencies.**

Never obtain green by weakening assertions, skipping the defective branch
through changed fixtures or requests, removing the failing path, marking tests
pending, rescuing exceptions, or adding stubs that hide the defect.

Corrections to the test itself are allowed if they preserve its purpose:
formatting, expectation grouping, HTML parsing, or unrelated setup, for example.
Any edit after red invalidates the earlier red evidence for the revised test.
Prove the revised test red and green again:

1. Save the exact fix; temporarily remove only the application change under
   investigation, or use an equivalent isolated comparison. Preserve unrelated
   work; never use a destructive reset.
2. Run the final test against the unfixed application and confirm the reported
   failure.
3. Restore the fix and rerun the identical test. Confirm that all assertions,
   including those unreachable during red, work and pass.

If another test correction is needed, repeat both runs with that version.
Also use this comparison when green does not clearly exercise the changed code.
If the test passes without the fix or fails for another reason, investigate;
claim no regression proof until the comparison supports it. Behavioral integrity,
not absolute test-file immutability, is the requirement.

## 5. Verify the fix

Run the final regression with the fix and inspect required output or side
effects, not merely absence of the exception. Run relevant surrounding tests and
repository-required checks. Add coverage for risks introduced by the change,
including adjacent branches such as absent optional relationships or normal
records. Do not repeat passed checks without a reason.

Resolve local setup failures separately and rerun affected checks. Do not disable
checks or change unrelated application behavior for environmental convenience.
Review the final diff for a coherent fix and regression coverage; remove your
temporary experiments and unrelated changes.

## 6. Report accurately

Report cause, resulting behavior, and verification. Distinguish confirmed
reproduction from hypotheses, defect failures from setup/test failures, passed
checks from checks that could not run, and local verification from confirmed
deployed behavior. Local success does not establish a deployment change.

Disclose test corrections, why they preserved intent, and whether the final
version was proven red and green; do not claim an altered test passed unchanged.
For investigation-only or reproduction-only work, state what remains unproven.

## 7. Hand off blocked work

If a necessary fact, trigger, dependency, or viable fix remains unavailable after
focused investigation, report the blocker and evidence. Do not repeat unchanged
failed attempts or invent certainty. This attempt's failure does not prove the
defect unsolvable.

Give another engineer enough relevant context to resume:

- Expected/observed behavior and known triggering conditions.
- Confirmed findings, hypotheses, and open questions, clearly separated.
- Reproduction commands and failures; what any partial reproduction proves
  and leaves unproven.
- Tests and implementation experiments: locations, current state, and useful
  regression coverage versus incomplete experiments.
- Approaches investigated or ruled out and supporting evidence, not a command
  transcript.
- Exact blocker, information or capability needed, and next useful diagnostic
  step.

Include only relevant items. Preserve useful partial work, identify incomplete
work, and restore temporary application changes to a known state. Never present
partial reproduction or verification as a completed fix.
