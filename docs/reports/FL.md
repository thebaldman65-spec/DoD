# BATCH FL — THE WAYS OF WORKING, AND AN AUDIT OF WHAT IS ALREADY RECORDED

*2026-09-08. Full working. `docs/state.md` carries the summary; this file carries the evidence.*

**Documentation only. No code, no data file, no rune, no magnitude, no gate.** Two halves: §1
records rules that had never been written down anywhere, and §2 audits what already had been so
this batch did not create a second copy of anything.

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

**Twelve checkable claims. Eight held. Four did not, and one of the four changes what a later
batch has to do.**

| # | Premise | Verdict |
|---|---|---|
| 1 | `docs/spec-recon.html` cost one batch and made forty runes possible in one | **HELD** — FJ built it, FK authored 40 |
| 2 | The four specs authored without it spent their first section correcting six premises | **HELD** — `docs/reports/EZ.md` §0, *"Six do not"* |
| 3 | …and spawned five repair batches | **HELD** — FA, FB, FC, FD, FE, in an unbroken lineage from EZ |
| 4 | Runes are run-scoped, modify stats/resources and the mechanics and values of core, draft and passive abilities, and are disconnected from talents | **HELD, AND ALREADY RECORDED** — §2 |
| 5 | PRIMARY types ABILITY / PASSIVE / STAT, exactly one per rune | **HELD, AND ALREADY RECORDED** — §2 |
| 6 | THRESHOLD and BREADTH are retired **for the reasons FK states** | **HALF FALSE** — the retirement holds; **FK states no reason at all.** §2 |
| 7 | 100g flat, spec scope, no rarity, no Scarred label, cost clauses survive unlabelled | **HELD, AND ALREADY RECORDED — as four separate standing rules** — §2 |
| 8 | Rune content is co-authored one rune at a time; a batch never authors one | **HELD, AND ALREADY RECORDED** — §2 |
| 9 | `spec:devout` and `spec:survivalist` roll for nobody; the keys are `inquisitor` and `mystic` | **HELD, ALREADY RECORDED IN FOUR PLACES AND PINNED IN THREE HALVES** — §2 |
| 10 | **The SIX shipped gated runes** — Deepening Hex, Bracing Line, Heavy Bolts, Answering Pack and the four BREADTH ones | **FALSE — THERE ARE EIGHT**, and the brief's own enumeration is 4 + 4. §2a |
| 11 | Bracing Line pays on 8.98% of incoming hits **and its level of 32 was ruled on that basis** | **FALSE IN THE HALF THAT MATTERS** — 8.98% prices the LEVEL, with the condition assumed met. §2b |
| 12 | `Runes.grant_rune` returns a rune it does not fit, **listed separately from the five FH findings** | **FALSE TWICE** — it is `Run.grant_rune`, and it IS one of the five. §2d |

---

## §1 — `docs/ways-of-working.md`

**A new file at 98 lines and 5.7 KB.** Six rules, in the project's own voice — dateless,
batch-agnostic, stated as instructions, provenance in parentheses.

**IT IS NOT A THIRD SEAM OF THE RULE TREE, AND THE FILE SAYS SO IN ITS OWN HEAD.** `CLAUDE.md`
binds what the game may contain. `docs/instrument-rules.md` binds how a batch verifies itself.
**Both bind a batch that already HAS a brief.** This one binds the conversation upstream of one —
a different audience (the designer and the assistant in conversation) rather than a fourth
category of rule. **Nothing was moved into it**, which is what §3 of the brief required: FF took
the last seam-move of its kind, and this batch moved nothing.

**THE SIX RULES:**

| Rule | What it binds | Its neighbour, pointed at rather than restated |
|---|---|---|
| **DESIGN IS SETTLED BEFORE A BRIEF EXISTS** | a brief is transcription, not direction | `CLAUDE.md`'s *VERIFY THE BRIEF AGAINST THE REPO* — which governs what a batch does with a brief, not how one is written |
| **RECON BEFORE AUTHORING** | read out the engine, the constants, what is true and what is unavailable, first | `docs/spec-recon.html` is the pattern; FJ → FK is the evidence |
| **THE ASSISTANT READS THE RECON BEFORE DRAFTING** | one sentence for what a thing CHANGES and what it READS, or it is off the list | — |
| **A REPORT'S FINDINGS GO TO THE QUEUE, NOT TO THE DESIGNER** | only player-facing findings, or ones blocking a made decision, are surfaced | `docs/state.md`'s open queue |
| **IMPLEMENTATION CALLS BELONG TO CLAUDE CODE** | options-first governs CONTENT and not implementation | `CLAUDE.md`'s AR §4 rule, which is on the CONTENT side of the seam and is untouched |
| **A BATCH IS MOSTLY TRANSCRIPTION** | read sites, payload fields, collision sweeps, live drives, and what cannot be expressed in data | — |

**THE POINTERS ARE POINTERS AND NOT SUMMARIES**, which is `CLAUDE.md`'s own rule (*WHEN A NEW RULE
IS WRITTEN, IT GOES IN ONE FILE AND IS NOT SUMMARISED IN THE OTHER*). One bullet was added to
`CLAUDE.md`'s routing list; one paragraph to `docs/state.md`.

· **THE `state.md` POINTER IS IN THE PREAMBLE AND NOT IN THE WHERE BLOCK, ON PURPOSE.** That block
  is replaced every batch — a pointer inside it would last exactly one. **The same reasoning moved
  the rune layer's four owed items into a real queue section**: all four had been living in the
  WHERE block, surviving only by whichever batch happened to re-copy them. §2c.

---

## §2 — THE AUDIT: EVERY CHARTER BULLET WAS ALREADY RECORDED

**The brief asked, for each ruling, whether it is already in `CLAUDE.md`,
`docs/instrument-rules.md`, `master.html` or a source comment. All six are. This batch wrote none
of them again.**

| Charter bullet | Already recorded at | Shape |
|---|---|---|
| Run-scoped; modifies stats, resources and the mechanics/values of core, draft and passive abilities; **disconnected from talents** | **`CLAUDE.md` — *A RUNE IS DISCONNECTED FROM THE TALENT TREES* (EM)**, as a blockquote in the designer's own words, with the mechanical half and `check_em` under it. "Run-scoped" itself is in `CLAUDE.md`'s talent-charter block and in `docs/master.html` | **standing rule** |
| **PRIMARY: ABILITY / PASSIVE / STAT, exactly one** | **`docs/master.html`** (the rune section, *"EVERY RUNE CARRIES A PRIMARY TYPE AND AN OPTIONAL SECONDARY (Batch EZ §0)"*) and a **source comment above `Runes.RUNE_SHAPES`** | **document + source comment. NOT in `CLAUDE.md`** |
| **TRADEOFF is the only surviving SECONDARY; THRESHOLD and BREADTH retired** | **`docs/master.html`**, **the `RUNE_SHAPES` source comment**, and **`docs/changelog.html`**'s FK entry — all three carrying the same three reasons | **document + source comment + changelog** |
| **100g flat** | `CLAUDE.md` — *A RUNE IS 100g, FLAT* (EZ §0) | **standing rule** |
| **spec scope** | `CLAUDE.md` — *A RUNE'S SCOPE IS SPEC AND CLASS* (ES §2) | **standing rule** |
| **no rarity** | `CLAUDE.md` — *THERE ARE NO RUNE RARITY TIERS* (ES §1) | **standing rule** |
| **no Scarred label; cost clauses survive unlabelled** | `CLAUDE.md` — *A RUNE'S COST MAY BE BOUGHT BACK* (EP §4, relabelled ES §3): *"ES §3 retired the WORD, not the RULE… every cost clause is byte-unchanged"* | **standing rule** |
| **Rune content is co-authored, one rune at a time** | `CLAUDE.md` — *RUNE CONTENT IS WRITTEN WITH THE DESIGNER, ONE RUNE AT A TIME* (ES) | **standing rule** |
| **`spec:devout` / `spec:survivalist` roll for nobody** | `CLAUDE.md` (*THE DEVOUT'S POOL KEY IS `inquisitor`, NOT `devout`*), `docs/spec-recon.html` **twice**, `check_fk.NOT_KEYS`, and **pinned in three halves by `test_batch_ce` §0** | **standing rule + pin + recon** |

**AND THE ONE ABSENCE IS THE SEAM WORKING, NOT A GAP.** The PRIMARY / SECONDARY vocabulary is the
only bullet with no `CLAUDE.md` home — **and it should not have one.** It is a vocabulary for
DESCRIBING content, not a rule about what the game may contain, so `CLAUDE.md`'s own seam test puts
it in the document and beside the constant. **Verified in the data rather than read off the
document**: `data/runes.json` holds 126 entries across 60 live and 66 retired, with scope keys
`spec:inquisitor` ×8 and `spec:mystic` ×9 and **no `spec:devout` or `spec:survivalist` anywhere**.

### **THE ONE PREMISE THAT DID NOT HOLD: FK STATES NO REASON FOR THE RETIREMENT**

The brief says THRESHOLD and BREADTH are retired *"for the reasons FK states."* **`docs/reports/FK.md`
states the retirement four times and not one reason for it** — §9's line is *"No THRESHOLD and no
BREADTH is authored"* and stops there. **The reasons are FJ's**, and they are recorded in three
places, identically and in full:

> a gated rune at a flat price is **strictly worse than a bare one** — the price does not fall to
> pay for the condition — and FJ measured the constraints as unworkable besides: **BREAK can never
> carry a threshold anywhere in the game** (zero of the 227 tagged cards carry it as a PRIMARY),
> **the Devout can never satisfy a breadth** (his whole earnable pool holds two distinct primary
> tags), and **a condition can be live at one rung of the ladder and dead at the next** (the Holy's
> breadth is satisfiable at exactly six drafted cards; the Swordmaster's fails at exactly five).

**This matters because the brief instructed that FK be read before quoting anything.** A batch
following that instruction and looking for the reasons would have found none and might reasonably
have written them fresh — which is the duplication §2 exists to prevent. **They are already in
`docs/master.html`, in `scripts/runes.gd`'s `RUNE_SHAPES` comment and in the changelog.**

### **AND FK'S OWN REPORT DISAGREES WITH ITSELF ABOUT ITS PREMISE COUNT**

`docs/reports/FK.md` §0's prose reads *"fourteen checkable premises… Ten held. Four did not"*, and
**the table beneath it has sixteen rows and six FALSE verdicts.** `docs/state.md` and the changelog
both carry the sixteen/six figures, so the prose line is the stale one — written before rows 15
and 16 were added and not re-read. **Reported, not edited**: FK's report is closed, and the two
documents that quote it are already right.

## §2a — **THERE ARE EIGHT SHIPPED GATED RUNES, NOT SIX**

**The count is wrong in the brief, and in eleven lines across five files. It is right in the one
place that is asserted.**

| | THRESHOLD | BREADTH |
|---|---|---|
| **Occultist** | Deepening Hex | Wide Rite |
| **Warden** | Bracing Line | Long Watch |
| **Sharpshooter** | Heavy Bolts | Wide Watch |
| **Beastmaster** | Answering Pack | Shared Scent |

**Derived from `Runes.RUNE_SHAPES` cross-checked against `data/runes.json`, not from a list.** All
eight carry a secondary of `THRESHOLD` or `BREADTH`, all eight are live (no `retired` key), all
eight are 100g, and **`check_fk.STILL_GATED` holds all eight ids** and asserts each still carries
BOTH its payload condition and its label. **The gate is right.** `docs/spec-recon.html` agrees
independently: *"4 THRESHOLD, 4 BREADTH, 4 TRADEOFF"* across EZ's twenty-one.

**THE BRIEF'S OWN SENTENCE ENUMERATES EIGHT AND CALLS IT SIX** — *"Deepening Hex, Bracing Line,
Heavy Bolts, Answering Pack, and the four BREADTH ones."*

**THE ELEVEN LINES, FROM A CENSUS RATHER THAN A HAND-TALLY:**

| File | Lines | Note |
|---|---|---|
| `check_fk.gd` | **5** — 6, 8, 53, 134, 153 | the header, `STILL_GATED`'s own comment, and §2's two arms |
| `scripts/runes.gd` | **1** — 536 | *"THE SIX ALREADY-SHIPPED GATED RUNES ARE NOT REPAIRED HERE"* |
| `docs/master.html` | **3** — 2658–2660 | includes **"because six live runes still come through it"**, a claim about the machinery's live population |
| `docs/changelog.html` | **1** | the FK entry's *WHAT DID NOT MOVE* |
| `docs/reports/FK.md` | **1** — §9 | |

· **THE COUNT ITSELF WAS HAND-TALLIED WRONG FIRST, AND THAT IS RECORDED RATHER THAN TIDIED AWAY.**
  This report's first pass said **nine** sites and *"three comments in `check_fk.gd`"*; the census
  says **eleven** and **five**. The claim was corrected in `docs/state.md` and the changelog before
  either was committed. **A number about a population is derived from the population.**

· **ONLY `docs/state.md` IS CORRECTED, AND THAT IS DELIBERATE.** Five of the eleven are `.gd`
  comments and three are in `docs/master.html`; **the brief forbade moving code, a data file, a
  gate or a rule.** Fixing some of eleven leaves a document disagreeing with a gate comment that
  disagrees with the changelog. **It is ONE scoped repair and it is owed** — and because a `.gd`
  comment is an asserted surface in this project, that repair owes a literal sweep and a subset
  battery even though it moves no executable line.

## §2b — **THE 8.98% PRICES THE LEVEL, NOT THE CONDITION**

**This is the finding that changes what the repair batch has to do.** The brief lists Bracing Line
under *"Some were priced on being conditional"* and quotes *"pays on 8.98% of incoming hits and its
level of 32 was ruled on that basis."*

**BRACING LINE CARRIES TWO GATES, NOT ONE, AND THEY ARE IN DIFFERENT PLACES:**

| | Gate | Where it is evaluated | Retired? |
|---|---|---|---|
| **A** | `tag_threshold: DEFENSE` — at least half his drafted cards | **the SPAWN.** `Talents.condition_met` returns before `apply_payload` writes anything, so a failed threshold leaves `rune_bracing_line` at **0** | **YES** — this is the retired secondary |
| **B** | Heavy Plating standing at **+32%** (`BRACING_LINE_LEVEL`) | **the FIGHT.** `battle.gd`'s read site tests `passive_id == "heavy_plating"` and the live plating bonus, and **never sees the threshold** | **no** |

**`docs/reports/EZ.md` §2b(i) MEASURED GATE B, WITH GATE A ASSUMED MET** — 8.98% of incoming hits
with the Standing Wall absent, 11.91% with it held, n = 200,000 hits an arm, block rolls taken at
the Warden's own live block chance so the feedback loop is inside the measurement.

**SO 8.98% IS THE RATE THE RUNE WOULD PAY AT WITH THE SECONDARY REMOVED — NOT THE RATE IT PAYS AT
TODAY.** Today's rate is 8.98% × P(the DEFENSE threshold holds at spawn), and is strictly lower.
**Ungating it does not invalidate what 32 was ruled against; it makes that figure true.** EZ's own
line — *"32 was ruled and is built, and this is what 32 costs"* — is a statement about the level,
and the level is not what is being retired.

· **THE TRANSFERABLE SHAPE: A GATED RUNE CAN HAVE A SECOND GATE THAT IS NOT THE SECONDARY**, in a
  different file, evaluated at a different time, with its own constant and its own measurement.
  **Retiring the labelled one leaves the other standing.** Whoever repairs the eight should read
  each read site before assuming the label is the whole condition.

## §2c — TWO THINGS RECORDED IN ONE PLACE EACH, AND BOTH PLACES ARE CLOSED REPORTS

**(1) THE `.docx` EXPORTS — A STANDING RULE AND A DESIGNER'S RULING IN DIRECT CONTRADICTION.**

- `CLAUDE.md`'s *Working agreement* step (3): **every** design change rebuilds both docx via
  `python3 docs/build_docs.py`.
- The ruling that they stay stale: **`docs/reports/FH.md` §4, and nowhere else in the tree.**
- **The state on disk agrees with the ruling and not the rule**: both `.docx` are dated
  **2026-09-06** while `docs/master.html` and `docs/changelog.html` are **2026-09-08**.

**A closed batch report is the one file class no instrument reads and no sweep covers.** The
contradiction is live, it is invisible, and **reconciling it is a RULE EDIT** — either the Working
agreement gains the exception or the exports come back into the loop. **The brief forbade
rewriting a rule, so this is reported and queued rather than taken.**

**(2) THE GENERATED STAT FAMILY HAS TWO RECORDED TRIGGERS AND ONE OF THEM HAS FIRED.**

- **`docs/spec-recon.html`**: *"That comes out once the eight specs are authored."* **FK authored
  all eight.** By this wording it comes out now.
- **`docs/state.md` and `docs/reports/FK.md`**: *"once the pool is proven."* No stated test, and
  it has not fired.

**Both carry the same reason and the reason is unchanged and good** — removing the floor before the
pool exists leaves most parties with nothing. **What is owed is which trigger was meant.** Until
that is answered the family stays, and `Runes.TEMPLATE_PRICE` = 50 stays with it. **Neither
document knew about the other**, which is the shape a queue item exists to close.

## §2d — THE FIVE FH FINDINGS ARE ALL RECORDED, AND `grant_rune` IS ONE OF THEM

**Already in `docs/state.md`'s own *FIVE MORE THINGS FH FOUND* block and in
`docs/changelog.html`'s FH entry, both in full.** Nothing was rewritten.

**TWO CORRECTIONS TO THE BRIEF'S WORDING, BOTH SMALL AND BOTH WORTH FIXING BEFORE THEY PROPAGATE:**

- **It is `Run.grant_rune`, not `Runes.grant_rune`.** It lives on `scripts/run_state.gd` behind the
  `Run` autoload. `Runes` is a different script and has no such function — and a `Runes.` prefix on
  a `Run.` autoload call is a compile error in this project, not a synonym.
- **It is not a sixth item beside the five; it IS one of the five.** `check_fh` prints it as **(4)**
  of its own census and the changelog lists it as **(5)** of the FH findings. The brief listing it
  separately would have had a later batch counting six where there are five.

**AND THE DESIGNER HAS RANKED NONE OF THEM**, which is the half that is actually open. All five
remain reported and unfixed, exactly as FH left them.

---

## §3 — THE `master.html` STAMP WAS TWO BATCHES STALE, AND NOTHING COULD SEE IT

**The stamp read `Batch FI` while both FJ's and FK's edits were in the document** — confirmed
against the git history, which shows `docs/master.html` in FJ's and FK's commits with the stamp
line byte-unchanged through both.

**FOURTEEN SUITES READ IT AND ALL FOURTEEN ASK THE SAME DURABLE QUESTION**: that a `Last updated:`
line exists, and that its batch code sorts **no older than the reading suite's own**. That shape is
CN's and it is right — `test_batch_bu`'s own comment says the alternative, a hand-bumped literal,
*"will be red most batches"* and stops carrying information.

**THE COST IS THE SLACK.** The newest of the fourteen is `ce`, so **any stamp from CE forward
passes all fourteen** — roughly forty batches of headroom. FI's stamp was never in danger.

**BUMPED TO FL. NOT REPAIRED**, and the reason is in `docs/state.md`'s queue: the question a fix
has to ask is *did the stamp move when the FILE moved*, which needs git or an mtime and is a
different instrument from the fourteen. **A `--script` gate has neither today.**

---

## §4 — WHAT WAS DELIBERATELY NOT DONE

- **No rule was rewritten and no seam was moved.** Nothing was moved INTO `docs/ways-of-working.md`
  either — all six rules are new text for rules that had no home.
- **No rune was authored, repaired or retired.** The eight gated runes still carry both their
  condition and their label.
- **No code, data file, gate or magnitude moved.** `data/runes.json`, every `.gd` file and
  `baselines.json` are byte-unchanged, so `pin-manifest.json` and every baseline row are unmoved.
- **Nothing already recorded was restated.** §2 is what enforces that, and it found all six charter
  bullets already recorded.
- **The eleven `six`/`eight` sites outside `docs/state.md` were NOT edited**, per §3 of the brief.
- **The `.docx` contradiction was NOT reconciled** — it is a rule edit.
- **`docs/master.html` was NOT corrected**, its three wrong counts included. Only the stamp moved.

---

## §5 — VERIFICATION

The brief's floor: **it parses, it runs.**

- **`grep 'Parse Error'` over stderr: 0**, never a tally and never the exit code.
- **THE NEW FILE HAS NO READER THAT ASSUMED ITS ABSENCE, AND THIS WAS DERIVED RATHER THAN
  ASSERTED.** Every `res://docs/` reference in the tree names a **file**, never the directory:
  `master.html` ×29, `changelog.html` ×18, `instrument-rules.md` ×7, `text-standard.html` ×4,
  `design-notes.md` ×4, `talent-audit.html` ×1. **No gate walks `docs/`.** The two `DirAccess`
  walkers in the tree — `check_ec` and `check_ff` §4 — open `res://` and take **top-level `.gd`
  files only**, non-recursively. `build_pin_manifest.py`'s `DOCS` set names five files by hand.
  **A new file under `docs/` is invisible to all of them, so no baseline row can move.**
- **`check_ec` §3 TAKES THE FIRST LINE OF `CLAUDE.md` AS A LIVE CONTROL MEMBER** (`substr(0, 120)`
  then `split("\n")[0]`). **Line 1 is byte-unchanged**; the pointer was added 20 lines below it.
- **`check_ff` §4 FAILS ON ANY NEEDLE WHOSE ONLY OCCURRENCE IN `CLAUDE.md` IS INSIDE THE INDEX
  TABLE.** The pointer was added to the **routing list**, not to the index table, and it introduces
  no needle any suite asserts.
- **`check_dv` §4 PINS THE CHANGELOG BY BOUNDARY LITERALS AND A ZERO-OVERLAP WALK, NOT BY A COUNT** —
  checked before the entry was written, because a prior batch's gate pinning a growing count is how
  DV turned DW red mid-freeze. The FL heading is unique and appears in neither half of the archive.
- **THE LITERAL SWEEP, AND IT WAS ARMED BEFORE IT WAS BELIEVED.** Every string literal of 4+
  characters — **both quote kinds, escape-aware, on RAW source rather than comment-stripped, which
  fails toward MORE needles** — in every file naming each tracked document, against the copy at
  HEAD and the copy now:

  | Document | Readers | Needles | LOST | GAINED |
  |---|---|---|---|---|
  | `CLAUDE.md` | 58 | 12,637 | **0** | 0 |
  | `docs/master.html` | 26 | 5,086 | **0** | 0 |
  | `docs/changelog.html` | 18 | 3,702 | **0** | 0 |
  | `docs/state.md` | 9 | 2,493 | **0** | 0 |
  | `docs/instrument-rules.md` | 5 | 653 | **0** | 0 |
  | `docs/text-standard.html` | 5 | 1,588 | **0** | 0 |
  | `docs/design-notes.md` | 4 | 843 | **0** | 0 |
  | `docs/talent-audit.html` | 3 | 295 | **0** | 0 |
  | `docs/ways-of-working.md` | **0** | — | — | no HEAD copy; nothing can be lost |

  **A SWEEP THAT READS 0 ON A CHANGED FILE HAS PROVED NOTHING, SO IT WAS ARMED ON BOTH CHANGED
  FILES.** Two arms, each a **same-length** one-character edit to a needle the document holds
  exactly once — same length on purpose, because a drop or a duplication moves the file size and a
  weaker check would catch it:

  | Arm | Needle | Edit | Result |
  |---|---|---|---|
  | `docs/master.html` | `6c. ARCHETYPE TAGS` | → `6c. ARCHETYPE TAGZ` (18 chars both) | **0 → 1 LOST** |
  | `CLAUDE.md` | `1 an ally a turn` | → `1 an ally a turm` (16 chars both) | **0 → 1 LOST** |

  **BOTH CONTROLS WERE APPLIED TO IN-MEMORY COPIES AND NEVER TO THE TREE** — 26 targets read
  `master.html` and 58 read `CLAUDE.md`, and a battery target reading one mid-edit would go red for
  a reason that is not the tree's. `git status` was checked clean of the controls afterwards.
- **THE UNMODIFIED GATES WERE RUN AGAINST THE NEW TREE**, per the brief. **No gate was edited**, so
  there is no second pass to compare against — the full battery below IS the acceptance run.
- **`docs/state.md` AND `docs/reports/FL.md` WERE THE ONLY FILES EDITED DURING THE FREEZE**, and
  neither is opened by any `.gd` file.
- **`build_pin_manifest.py --check`: CURRENT AT 1,432 PINS**, the same figure FK left. No `.gd`
  file moved, so no pin could — the check is here to prove that, not to discover it.
- **THE TREE WAS FROZEN ACROSS THE BATTERY AND THE FREEZE HELD.** 360 paths — **`git ls-files`
  PLUS `git ls-files --others --exclude-standard`, so the new report and the new document are
  inside it**, md5'd by ABSOLUTE path so a moved cwd cannot report the tree as drifted. Re-stamped
  after the run: **0 differ, 0 missing.**
- **THE FULL BATTERY IS GREEN: 100 targets.** **`check_de` reports 410 checks / 0 failures /
  0 NOTICES**, so every baseline row matches its target *exactly* rather than merely not falling.
- **THE PARSE FLOOR, READ OFF STDERR AND NEVER OFF A TALLY OR AN EXIT CODE**: of the 100 logs,
  **0 contain `Parse Error` and 0 contain `SCRIPT ERROR`.** `check_parse` reads **174 / 0** —
  unchanged from FK, which is correct: this batch adds no battery target, and that gate's count IS
  its coverage.
- **THE ONE RED IS THE SANCTIONED ONE AND ITS FAIL LINES WERE COMPARED, NOT ITS COUNT.**
  `check_cm_live` reads **13 checks / 4 failures**, against a baseline pinned at exactly
  `checks: [13, 13], fails: [4, 4]` with the note *"THE ONE RED THAT IS ON PURPOSE… identical on
  unmodified HEAD… the only thing pressing the defensive bar."* The four lines are the defensive
  bar's:

  ```
  FAIL: the bar appeared on the enemy's attack
  FAIL: the bar's top line names the incoming blow (was: )
  FAIL: the brace lands near x0.85
  FAIL: the brace's Break half lands near x0.75
  ```

  **NO OUT-OF-REPO HEAD REBUILD WAS NEEDED OR MEANINGFUL HERE**, and that is worth stating rather
  than skipping in silence: FK had to rebuild HEAD because it had moved `_resolve`, two lines from
  where that bar lives. **This batch moved no `.gd` file and no data file at all**, so HEAD's code
  and the tested code are byte-identical and the comparison is an identity.
- **`check_fg` MEASURED BOTH CEILINGS THIS RUN**, so no figure here is hand-carried:
  `docs/changelog.html` at **192,130 B = 192.13 KB**, under CW §4's 400 KB bar with **207.87 KB**
  of headroom; `CLAUDE.md` at **278,836 B = 272.30 KiB** against EE's 290 KiB. **The pointer cost
  0.56 KiB.** `docs/ways-of-working.md` is **5,730 B = 5.60 KiB** and is under no ceiling — a
  ceiling is DERIVED and deriving one is a ruling.
- **A NOTE ON THE SWEEP'S OWN POPULATION, BECAUSE THE LOOSE READING WAS NOT CLEAN.** The table
  above counts a "reader" as any `.gd` file that NAMES the document — which is the over-broad,
  fail-loud direction. Under that reading `docs/state.md` showed **7 LOST** (`Radient Aegis`,
  `Resonant Core`, `capstone`, `formless`, `rune_seasoned_off_bonus`, `seasoned`,
  `seasoned_off_bonus`) when FK's WHERE block was replaced. **All seven are false positives, and
  it was PROVED rather than assumed**: all nine of those "readers" name `docs/state.md` only inside
  a COMMENT, **no `FileAccess` call anywhere in the tree reaches `state.md` or anything under
  `docs/reports/`**, and re-running with a STRICT reader definition — the file must actually open
  the document — gives **0 strict readers for `docs/state.md` and 0 LOST across every document in
  the tree**. The seven literals are assertions those suites make about the GAME that happened to
  share a word with FK's prose. **This independently re-confirms FJ §4's and FK §11's claim that
  `docs/state.md` has no reader**, which is why it and this report were the only files edited after
  the run.

