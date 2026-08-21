# BATCH CW — THE `CLAUDE.md` SPLIT, AND REPORTS MOVE INTO THE REPO

*2026-08-20. Documentation architecture only. No code changes, no magnitudes, no text, no save
version moves. Nothing the game does changed.*

**This is the first report written to `docs/reports/` rather than printed to a chat window and
hand-copied — which is §3 of this batch's own brief, applied to itself.**

---

## THE HEADLINE

| | before | after |
|---|---|---|
| `CLAUDE.md` | **883.5 KB**, 11,066 lines | **144.2 KB**, 1,796 lines |
| share of sync | **14.0%** | **2.58%** |
| knowledge sync | 6.15 MB / 124 files | **5.46 MB / 126 files** |

**An 83.7% cut to `CLAUDE.md` — 739 KB off that file, and a net 706 KB (11.2%) off the sync
once this batch's own new files are counted back in.** The §1 target —
under 3% of sync capacity — is met with room, and the file should now stay roughly flat, because
what was growing was the batch blocks and they are gone.

---

## §0 — WHERE THE BRIEF WAS WRONG, AND IT MATTERS IN ONE PLACE

Every measurable claim was re-derived against the repo before anything was edited. **Four came
back different, and one of them would have caused real damage if followed literally.**

1. **THE ONE THAT MATTERS — §5 SAYS THE TEST SUITES ARE "THE BULK OF THE `scripts` FOLDER'S
   36%". THEY ARE NOT IN `scripts/` AT ALL.** All 44 suites live at the **repo root**.
   `scripts/` measures 34.9% of the sync and contains **zero** test suites — it is `battle.gd`,
   `unit.gd`, `classes.gd`, `talents.gd`, `run_state.gd` and the screens, every one of which §5
   itself lists under "stays selected". **Deselecting "the scripts folder" would drop the game
   code and keep every suite — the exact inverse of the intent.** The suites are their own block:
   **1,700 KB, 27.0% of the sync.** The deselection list in §5 below is corrected accordingly.
2. **`CLAUDE.md` WAS NOT "LARGER THAN THE CHANGELOG, MASTER DOCUMENT AND DESIGN NOTES COMBINED".**
   It was 883.5 KB against their 1,073.1 KB. It *was* larger than any one of them, and larger
   than master + design-notes together (587 KB). The 15% figure was close — the measured number
   was 14.0%.
3. **THE SUITES ARE NOT "ONE PER BATCH SINCE BN".** There are 44, spanning `ah` to `cp` with
   gaps, and they start twenty batches earlier than BN. Recent batches have mostly written none,
   because CG's standing convention moved testing to periodic dedicated batches.
4. **THE FLAKE IS IN `bo`, NOT `br`.** §2 asks for "the flake in `br`" among the known-broken.
   `br`'s old flake was captured, diagnosed and did not reproduce; the live one is
   **`test_batch_bo`'s §5 NULL FIELD assertion**, roughly 1 failure in 13 runs. Recorded in
   `state.md` under its real name.

**And one thing the brief asked for that is already closed:** §2 lists "the four hanging suites"
under known-broken. **They were closed two batches running** — al, bp, br and bw all produce
counts, and the diagnosis that closed them has held. `state.md` records the deadlock as *real
but not currently biting*, which is the honest state, rather than as an open fault.

**The premise of the brief was right in the way that counts.** `CLAUDE.md` was doing two jobs
badly and the rules were buried — there were **60** batch blocks, not the ~40 estimated, and
they were **8,894 of the file's 11,066 lines**.

---

## §1 — `CLAUDE.md` IS STANDING RULES ONLY

**The file's real shape was not what the brief described, and finding that out changed the
work.** It was not forty short batch notes: it was one `## Current systems snapshot` section
holding **86% of the file** — 17 genuinely-standing subsections at the top, then **60 undelimited
`BATCH XX (date) —` narrative blocks** running 8,810 lines to the end.

**What was kept**, in the file's own voice, dateless and stated as instructions: the working
agreement, the skill check and its profile rule, the duration and hero/ally conventions, the
pouch, item effects, the clamped call sites, hard control, the recast refusal, the literal-digit
baseline, the text-standard rules, the seventeen standing subsections (promoted to top level),
the tooling reference in "Verify before shipping", and the architecture map.

**What was dropped:** every batch narrative, the "Older snapshot" section, two sections that were
already closed and still marked open (`FOUR SUITES HANG`, and CN's fold debt closed at CQ), and
the Batch S/T/U measurement narratives inside "Verify before shipping" — **the standing tuning
rule that was tangled into them was kept** ("tune against the curve, never one point").

### THE GATHER — RULES THAT WERE BURIED IN A NARRATIVE
A new section, **"THE TRAPS"**, collects the rules that would have been lost with their blocks.
The brief named five; all five are in, and the sweep found more. Grouped by the shape of the
mistake they prevent:

- **Names that look wrong and are right** — the Devout's pool key is `inquisitor` and a `devout`
  key **fails silently**; the Survivalist's spec id is `mystic` and moves the save format;
  `wild_communion_ranks` is the Beastmaster's and `communion_ranks` is the Devout's; a `_step`
  field is a float and must stay out of `STAT_INT_KEYS` or 1.5 silently becomes 1.
- **Gates that pass without asking their question** — a gate reports its count, not a verdict; a
  gate running zero checks must fail; **a count nobody diffs is a word**; verify a parse by
  grepping stderr because Godot hands back a non-null script for a failed parse; and a check that
  passes for a reason it is not testing is the same gap, findable only by negative control.
- **The master.html stamp gate** — see the correction below.
- **Suites and the harness** — never `preload` a script naming an autoload; autoloads do not
  resolve in a `--script` SceneTree; **the battery destroys the player's in-progress run**;
  `_nobody_can_press()` is the one place the press question is asked and a Profile flag is not a
  bot guard; `test_batch_bl` needs `--fixed-fps 12` and it is not the `sim.sh` flag.
- **The shell, the engine and the files** — zsh does not word-split unquoted expansions, so a
  battery script must hold flags in an **array**; `\n` in a GDScript string is two characters, so
  `\bword\b` silently fails on every hand-wrapped tooltip; `data/*.json` is tab-indented and
  `indent=2` rewrites the whole file; **a reference count of zero was wrong four ways in one
  audit**, every one of which would have broken the build.

### A CORRECTION FOUND WHILE WRITING THE STAMP RULE
**The first version of that rule was wrong and was rewritten before shipping.** A grep for batch
codes matched *comments*, not assertions, and reported seven suites. The real gate is in
**fourteen** (ah, bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, ce) — **and none of them is a
literal any more.** Each reads the two-letter code out of `(Batch XX)` and asserts it is no older
than its own batch code, so **no bump is ever owed on a re-stamp**. What carries forward is the
prohibition (never author another literal-stamp check) and a live caveat: **the comparison leans
on two-letter codes sorting lexically, and a three-letter batch code needs one more line in each
of the fourteen.**

### ONE DOCUMENTATION FAULT CORRECTED TOWARD THE CODE
**The Architecture section said the run save was `v7`. It is `v10`** (`run_state.gd:1752` refuses
anything below 10). Corrected in place, per the standing rule that documentation moves toward
code and never the reverse.

---

## §2 — `docs/state.md`

New, and **overwritten every batch rather than appended to**, so it cannot grow. Four sections:
where the project is, the open queue, live counts and constants, and known-broken. **9.6 KB.**

Everything in it that reads as "what happened" was deliberately left out. The battery counts, the
drift bands, the flake, the one red and the sync measurements moved here out of `CLAUDE.md`,
where they had been sitting among the rules.

**The open queue** carries the six items the brief named — enemy interference as a status, the
relic family and the party-wide-or-per-hero ruling, rune content, the enemy debuffs whose
duration exceeds their cooldown, the design review, and browser playtesting — plus the items that
were genuinely open inside the old "Known open threads" section: `Regalia`, the "Crushing Blow"
collision, the "beast" identifiers, spec-pool redundancy, and the two specs on the generic talent
fallback. **The closed items in that section were dropped rather than carried.**

---

## §3 — REPORTS GO INTO THE REPO

**This file is the change.** From CW, each batch writes `docs/reports/<CODE>.md` and commits it
with the batch. The rule is in `CLAUDE.md`, including the reason: **CL's overflow measurement was
written into `text-standard.html` §4.8 and then reported as missing**, and a report that says
something is absent when it is present is harder to catch than an absence — nobody goes looking
for a thing they have been told is not there.

**Nothing was retrofitted.** Past reports stay where they are.

---

## §4 — THE CHANGELOG ARCHIVE IS A RULE NOW

Written into `CLAUDE.md`. **Threshold 400 KB**, cut at a batch boundary, leaving the live file
around 150 KB — the size BZ's own cut produced, so the next cut is many batches away rather than
immediate. Archive means **move out of the repo** to `DoD-archive/`, never delete; the live file
never moves, which is why `build_docs.py` keeps working.

**The verification procedure is the part worth having as a rule:** extract every `<h2>` from the
original and both halves, assert the counts sum with zero overlap and order preserved, and assert
the two bodies rejoined are **byte-identical** to the original. **Never assert file sizes** —
sizes agreeing is consistent with a duplicated entry and a dropped one.

**CD's pattern is written in as binding on anything that reads the changelog:** anchor on the
`<h2>` heading and reach the archive by following the path out of the live file's own header,
never by hardcoding. A bare `contains("Batch BN")` is satisfied by a later entry naming that
batch in prose, so it **passes without its subject being in the file at all**.

**`docs/changelog.html` is 486 KB today — already over the new threshold.** It is NOT cut in this
batch: the brief scoped CW to writing the rule, and a cut is a content operation that wants its
own verification pass. **It is owed at CX**, and is the first item the next batch should take.

---

## §5 — WHAT TO DESELECT IN THE GITHUB CONNECTOR'S FILE PICKER

*Not a repo change. This is a list for the designer to apply by hand. Deselecting is not
deleting — every file stays in the repo and Claude Code goes on reading it off disk.*

**TAKE OUT — 1,702 KB, 30.4% of the current sync (1,777 KB / 31.8% with the audits):**

| what | size | why |
|---|---|---|
| **The 44 `test_batch_*.gd` suites** (repo **root**, not `scripts/`) | **1,700 KB** | Claude Code reads them off disk; the design instance never does. **They cannot be archived — they must be in the repo to run — but they need not be synced.** |
| **`docs/build_docs.py`** | **1.7 KB** | Generates the .docx exports and is never read. |
| **`docs/talent-audit.html`**, **`docs/text-audit.html`** | 33 KB + 43 KB | **Only once the designer confirms their findings are ruled on and applied** — CV applied the talent-audit rulings and carries a per-finding disposition table. |

**Already out of the sync:** the archived changelog. BZ moved `changelog-archive.html` **out of
the repo** to `DoD-archive/`, so it was never synced — §4's rule keeps it that way, and there is
nothing to deselect.

**KEEP SELECTED:** `CLAUDE.md`, **`docs/state.md`**, `docs/changelog.html`, `docs/master.html`,
`docs/design-notes.md`, `docs/text-standard.html`, **`docs/reports/`**, and the game scripts —
`battle.gd`, `unit.gd`, `classes.gd`, `talents.gd`, `run_state.gd` and the screens. **`scripts/`
stays selected in full.**

**Applying the list takes the sync to 3.80 MB** (3.73 MB if the audits come out too), from
6.15 MB before this batch — a cumulative **38.2%** reduction, none of it by deleting anything.

---

## VERIFIED

**The floor for this batch is that it parses and it runs, which is the point of doing it now —
nothing here can break the game.**

- **Parse: clean.** `check_parse.gd` headless, and **stderr grepped for `Parse Error|SCRIPT
  ERROR` — 0 matches**, which is the authority rather than the tally. The tally agreed at 0.
- **The game launches and runs.** `--quit-after 150` headless, **exit 0**, zero `Parse Error` /
  `SCRIPT ERROR` in the stream. Godot's usual two ObjectDB leak warnings appear at shutdown; they
  are pre-existing and cannot be this batch's doing, since no code file was touched.
- **No file under `scripts/`, `scenes/` or `data/` was touched.** `git diff --stat` for this batch
  is documentation only.

## NEEDS A RULING

1. **The relic family: party-wide or per-hero?** The rest of the family waits on it.
2. **`Regalia`** — wire it into the chooser, re-point it at itself, or retire it explicitly.
3. **"Crushing Blow" on both sides of the field** — rename either half, or accept the collision.
4. **The §5 deselection list** — the audit documents come out only if their findings are settled.
