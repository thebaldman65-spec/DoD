# Dawn of Decay — WAYS OF WORKING

**THIS FILE IS ABOUT HOW A BATCH COMES TO EXIST. IT IS NOT A SEAM OF `CLAUDE.md`.**

`CLAUDE.md` and `docs/instrument-rules.md` bind what a batch DOES once it has a brief — what the
game may contain, and how the batch verifies itself. **This file binds what happens BEFORE the
brief: how design is settled, what is read first, and which decisions belong to whom.** It is a
different audience — the designer and the assistant in conversation, rather than the session
executing a brief — which is why it is a third file and not a third seam.

**IT HOLDS ONLY RULES THAT ARE NOT RECORDED ELSEWHERE.** Nothing here is a summary of a rule that
lives in `CLAUDE.md` or `docs/instrument-rules.md`; a second copy of a rule is the defect that let
`CLAUDE.md` contradict itself 1900 lines apart after CW's split. **Where a rule below has a
neighbour in another file, it POINTS at it and does not restate it.**

**KEEP IT SMALL AND KEEP IT STABLE.** It has no batch blocks, no measurements that go stale and no
history. What happened is `docs/changelog.html`'s; where the project is is `docs/state.md`'s.

**AND SOMETHING READS THIS FILE NOW: `check_fr.gd`, every battery (FR §1).** From FL to FQ nothing
in the tree opened it, so the branch rule below was enforced by nothing at all. **The gate asserts
what it can and says in its own header what it cannot** — the branch rule, the no-second-copy rule,
that every path named here resolves, that the conflict table still names the files it was measured
over, and that this file stays the smallest of the three. **The rules above the branch section are
about people and are checked by nobody**, which is stated there rather than left to be discovered.

---

## DESIGN IS SETTLED BEFORE A BRIEF EXISTS

> **The designer and the assistant author content — names, effects, constraints, magnitudes — in
> conversation, in full, before a brief is written. A BRIEF IS TRANSCRIPTION, NOT DIRECTION.**

**A brief that reads as *"here is a direction, work it out"* is a brief that will come back with
its premises corrected and a repair queue behind it.** The batch cannot settle design: it can only
discover, halfway through implementing, that the thing it was told to build is not the thing that
was wanted — and by then the discovery arrives as a report rather than as a conversation.

· **THIS IS THE COMPANION TO `CLAUDE.md`'s *VERIFY THE BRIEF AGAINST THE REPO BEFORE IMPLEMENTING
  IT*, AND THE TWO ARE NOT THE SAME RULE.** That one governs what a batch does with a brief it has
  been handed. This one governs how the brief came to be written. **A brief can pass every check in
  that rule and still be under-specified**, because verification catches a claim that is false and
  cannot catch a decision that was never made.

## RECON BEFORE AUTHORING

> **Before content is written for an area, a batch reads out what already exists there: the
> engine, the constants, what is already true, and what is structurally unavailable.**

**`docs/spec-recon.html` is the pattern.** It cost one batch (FJ) and made forty runes possible in
the next; **the four spec sets authored without it (EZ) spent that report's first section
correcting six premises, and five batches followed it — FA, FB, FC, FD, FE.**

· **A RECON IS NOT A DESIGN DOCUMENT AND MUST NOT PROPOSE CONTENT.** It reads out what is there.
  The moment it names a candidate it has started authoring, which is the next rule's territory and
  `CLAUDE.md`'s *RUNE CONTENT IS WRITTEN WITH THE DESIGNER, ONE RUNE AT A TIME*.
· **REGENERATE A RECON RATHER THAN HAND-EDITING IT**, and treat its findings the way a batch report
  is treated: they age, and the tree is the authority.

## THE ASSISTANT READS THE RECON BEFORE DRAFTING

> **If the assistant cannot state in one sentence what a thing CHANGES and what it READS, it does
> not go on the list.**

**This rule exists because it was broken twice in one session:** content was drafted for a spec
whose section of the recon had never been read, and part of it rested on mechanics that could not
be described when asked. **A recon nobody reads costs a batch and buys nothing** — it is the same
failure as a threshold with no instrument, one document over.

## A REPORT'S FINDINGS GO TO THE QUEUE, NOT TO THE DESIGNER

> **Only what is player-facing, or what blocks a decision already made, is surfaced. Everything
> else goes to `docs/state.md`'s open queue.**

**A report that produces three decisions produces a repair batch, and that is how a content batch
becomes five.** A batch finds more than it can act on — that is the batch working — but every
finding routed to the designer is a decision they did not ask for, and decisions are the scarce
resource.

· **THE TEST IS WHETHER THE ANSWER CHANGES WHAT THE PLAYER SEES OR UNBLOCKS SOMETHING ALREADY
  RULED.** If it does neither, it is a queue item with its measurement attached.

## IMPLEMENTATION CALLS BELONG TO CLAUDE CODE

> **Options-first governs CONTENT — names, effects, magnitudes, anything the player sees. It does
> not govern implementation.**

**Which fallback pool, warn or fail, where a guard lives, which of two equivalent shapes a check
takes: those were never content decisions, and routing them through the designer cost a batch
each.** Make the call, state it in the report, and move on.

· **THE SEAM IS WHETHER THE PLAYER CAN SEE THE DIFFERENCE.** If two implementations are
  indistinguishable in play, choosing between them is the batch's. If they are not, it is content
  and the content rules apply.
· **THIS DOES NOT WEAKEN `CLAUDE.md`'s AR §4 RULE.** That rule forbids *inventing a read site* and
  requires pricing options rather than guessing when a clause has no home — which is a question
  about what the game contains, on the content side of this seam.

## THE MERGE IS DEVELOPED ON ITS OWN BRANCH

> **The merge is developed on its own branch — `class-merge`. `main` stays playable. A merge batch
> commits and pushes to `class-merge`, and the push check reports THAT branch's remote against
> local HEAD rather than `main`'s.**

**The recon priced the merge at twelve to fourteen batches with the game BROKEN — not degraded —
through roughly eight of them**, because the engine move cannot be staged per spec: the unit is a
CLASS, and there is no state in which one spec of a class has merged and its siblings have not.
**A tree carrying fifty red targets has no differ**, so `main` is where the designer keeps playing
and the branch is where the game is taken apart.

· **`CLAUDE.md`'s push step POINTS HERE and is not restated there.** It reads `origin/main` because
  until now there was only one branch; a merge batch confirms the BRANCH's remote against local
  HEAD, by the same rule and with the same evidence.
· **THE BRANCH IS CUT FROM THE COMMIT THAT CARRIES THE PROFILE VERSION GUARD, NOT FROM BEFORE IT.**
  A branch cut earlier starts the merge without the one thing built to survive it.

### THE FILES EVERY BATCH WRITES, AND WHAT HAPPENS WHEN BOTH SIDES WRITE THEM

**Decided once, here, rather than resolved by hand at every merge point.** The list is longer than
the three anyone predicts, and the two hardest entries are not documents at all.

| File | Convention |
|---|---|
| `docs/state.md` | **Take the branch's wholesale.** It is rewritten every batch and has no reader. |
| `docs/changelog.html` | **Append-only at the top; BOTH sides' entries survive, ordered by batch code.** Neither side's history is a draft. |
| `docs/design-notes.md` | Append-only. Both sides survive. |
| `docs/reports/XX.md` | One new file per batch. Cannot conflict. |
| `run_battery.sh` | Both sides' `GATES` / `SUITES` entries survive — it is one array and a target is a name. |
| `pin-manifest.json` | **NEVER hand-merged. It is DERIVED.** Take either side and re-run `build_pin_manifest.py`; `check_ed` is what says the result is right. |
| `baselines.json` | Both sides' ROWS survive, but **a count is not a fact about a file, it is a fact about a GAME** — every engine-bound row measured on the branch is wrong for `main` and the reverse. Rows merge; numbers are re-measured. |
| `CLAUDE.md` | See below. |
| `docs/master.html` | **The hardest one, and it is not `CLAUDE.md`.** See below. |

· **`CLAUDE.md` RECONCILES BY WHAT A RULE IS ABOUT, NOT BY WHO WROTE IT.** A rule that names no
  spec, engine or node **is true on both sides** — instrument rules, working agreements, the
  verification floor — and **both sides' additions are kept**. A rule that NAMES one is a claim
  about a game only one side has, and at the merge point the branch's reading wins, because the
  branch's game is the one that ships. **THIS IS A TRIAGE AND NOT A DECISION PROCEDURE**: it says
  which rules need a human read, and roughly half of them do.
· **`master.html` IS HARDER BECAUSE IT IS THE ONE DOCUMENT THAT IS NOT ALLOWED TO HOLD HISTORY.**
  It shows only what is currently in the game (the designer's 07-20 rule), and during the merge the
  two sides describe **different games** — so their edits are not two versions of one sentence and
  no line-level convention can reconcile them. **The branch's `master.html` is RE-DERIVED at the
  merge point, not merged**, and `main`'s edits to it are read as a list of things to check rather
  than as text to keep.

## A BATCH IS MOSTLY TRANSCRIPTION

> **What is genuinely the batch's own work is finding read sites, deriving payload fields, sweeping
> for collisions, driving it live, and reporting what cannot be expressed in data.**

**The authoring is not the batch's, and the verification is not the designer's.** A batch that
believes it is authoring has taken a decision nobody gave it; a batch that hands its verification
to the designer has handed over the half only it can do.
