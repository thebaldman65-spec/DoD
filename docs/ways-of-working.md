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

## A BATCH IS MOSTLY TRANSCRIPTION

> **What is genuinely the batch's own work is finding read sites, deriving payload fields, sweeping
> for collisions, driving it live, and reporting what cannot be expressed in data.**

**The authoring is not the batch's, and the verification is not the designer's.** A batch that
believes it is authoring has taken a decision nobody gave it; a batch that hands its verification
to the designer has handed over the half only it can do.
