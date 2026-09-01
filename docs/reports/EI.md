# BATCH EI — THE FLOOR THAT DID NOT COVER THE FLOOR

**Two items, both about the verification floor itself.** `check_parse.gd` walked two directories
and the things it has to protect live in a third place, so **the acceptance test every
implement-only batch has run since CG was blind to all 39 gates, all 47 suites and both fixtures.**
The walk is **41 files → 158**, and its population is DERIVED from `run_battery.sh` rather than
written as a list of directories — because a directory list is what went stale all three times this
gate has been found short. **§2 records that a brief's PRECEDENT is a claim and gets checked**, a
rule that exists because three errors in one lineage all propagated through briefs, which nothing
sweeps.

**No game code moved. No magnitude changed, no card was touched, no pool gained or lost an entry.**
The only non-instrument edits are four corrections of false prose toward the code, and they are
reported before anything else because one of them is a confirmation the brief asked for that
**did not confirm.**

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*Derive, do not recall.*

| the brief said | re-derived here | why |
|---|---|---|
| **`check_parse` walks `scripts/` and `scenes/` only** | **true** | and the repo root holds `gate_fixture.gd`, `suite_fixture.gd`, 39 gates and 47 suites, none of them reached |
| **23 gates could not load when `gate_fixture.gd` broke** | **true, and reproduced exactly** | the armed control reads **24 failures** — the fixture plus 23 gates |
| **third time this gate has been found short** (CP, DE, now the fixtures) | **true** | and all three have ONE cause, which the brief did not name: `for dir_path in [...]` |
| **`PROTECTED_CORES` names sixteen enablers across nine specs** | **true**, derived live | twelve rows, nine with entries, sixteen names; `check_eh` §3 already pins `enablers == 16` |
| **confirm no third section of `master.html` carries the same lag** | **IT DOES NOT CONFIRM** | **§10 says "There is no cap on how many abilities a hero holds"** — the same claim EH repaired in §6a, 1,450 lines away. Two more sites beside it |
| **§4: line 1511 is left standing** | **agreed and left standing** | 21 Hunter-reachable abilities carry Break damage, but "lever" may mean *amplifies*, and no instrument can settle which |

**AND ONE THING THE BRIEF GOT RIGHT THAT IS WORTH NAMING, BECAUSE IT IS WHAT FOUND THE WHOLE OF
§3.** *"Derive that set from what the battery actually runs, not from a list of directories;
directories are how it came to be short three times."* That sentence is the design. It is also why
the widened gate cannot go short again by omission: the population moves when the battery moves.

---

## §1 — THE PARSE FLOOR NOW COVERS EVERYTHING THAT HAS TO LOAD

### THE DEFECT IS ONE SENTENCE, AND IT HAS BEEN REPAIRED AROUND TWICE

```gdscript
for dir_path in ["res://scripts", "res://scenes"]:
```

**CP repaired the TALLY** after it returned zero on genuinely broken files — Godot hands back a
non-null `GDScript` for a file whose parse failed, so `load(path) != null` was answering a
different question than the one being asked. **DE found the walk did not cover the SUITES.** **EH
broke `gate_fixture.gd`** — a duplicate `var` in one scope — and the floor procedure this project
specifies, *grep stderr for `Parse Error`*, **came back clean while 23 gates could not load.**

Three findings, three batches, one cause. **A directory list is a hand-written claim about where
things that must load happen to live.** It goes stale the first time somebody puts one somewhere
else, and **nothing goes red when it does**: the gate keeps printing `0 failures`, which is exactly
what it prints when it is right.

### THE POPULATION IS DERIVED, IN FOUR LAYERS, AND NO LAYER IS A DIRECTORY

| layer | what it is | how it is derived | count |
|---|---|---|---|
| **A. BATTERY** | every target `run_battery.sh` spawns | its own `SUITES` and `GATES` arrays, every literal `--script X.gd`, every `run_one X`, every `res://X.tscn` scene run | **82** |
| **B. REACHED** | the transitive closure of A | `preload` / `load`, a scene's `ext_resource` paths, `change_scene_to_file`, seeded also by `project.godot`'s three autoloads and its main scene | **57** |
| **C. GAME TREE** | what is left in `scripts/` and `scenes/` | the old gate, kept for exactly the files it was right about — the twelve `class_name` globals and their neighbours, reached by IDENTIFIER, which no textual closure can follow | **11** |
| **D. DATA** | `res://data/*.json` | they reach the game through a `DATA_PATH` string constant, so no closure can find them | **4** |
| | | | **158** |

**A TARGET ADDED TO THE BATTERY IS COVERED THE SAME DAY, WITH NO EDIT TO THE GATE.** That is the
whole difference between this and a wider list of folders: the folder is a place, and the battery is
the question.

**LAYER B IS HOW THE FIXTURES ARRIVE, AND THAT IS THE POINT OF FOLLOWING EDGES AT ALL.** Nothing
in `run_battery.sh` names `gate_fixture.gd` or `suite_fixture.gd`; 60 files depend on them. **A
widening that covered the root directory would have covered them by accident** — this one covers
them because they are depended upon, which is the property that will still hold when somebody moves
them.

### THE RESIDUE IS NAMED IN THE OUTPUT EVERY RUN

```
check_parse: A battery 82 (0 missing) + B reached 57 + C game tree 11 + D data 4
check_parse: RESIDUE 4 — in the tree, spawned by nothing, reached by nothing: res://check_ck_width.gd,
             res://check_cu.gd, res://check_cv.gd, res://check_dn.gd
check_parse: OUTSIDE THIS GATE — .py instruments, .sh scripts, shaders/*.gdshader (the rendering
             server is a stub headless), and assets/ binaries no dependency edge reaches
check_parse: 158 checks / 0 failures
```

**The four residue files are the four `docs/state.md` already records as running nowhere.** They are
loaded like everything else — a broken one still reds — but they are reported as their OWN
population, so *covered* can never quietly come to mean *reachable*. **The fourth instance of this
defect will be a file sitting in that list**, and a floor that is nearly complete is the one that
gets trusted.

**WHAT IS STILL OUTSIDE, SAID PLAINLY BECAUSE THE BRIEF ASKED FOR IT:**

- **The two `.py` instruments** (`build_pin_manifest.py`, `claude_md_census.py`) and the two shell
  scripts (`run_battery.sh`, `sim.sh`). They are not GDScript and this gate is a GDScript loader.
  `run_battery.sh` is not unguarded, though: the gate FAILS if it cannot read it or cannot parse
  either array out of it.
- **`shaders/outline.gdshader`.** A shader compiles on the RENDERING server, which is a stub under
  `--headless`, so `load()` there would prove only that the file exists. Faking that as coverage
  would be worse than the gap.
- **`assets/` binaries no dependency edge reaches.** Sixteen of twenty sprite files are named
  nowhere in source because their paths are BUILT at runtime — CLAUDE.md already records that a
  reference count of zero is not evidence a file is dead, and nothing derivable reaches them.

**NOTHING THE BATTERY SPAWNS REMAINS OUTSIDE IT.** The gate asserts that directly: a name in
`run_battery.sh` with no file behind it is counted as MISSING and reported as its own class, and
the run reads `0 missing`.

### THE GATE PRELOADS NOTHING, AND THAT IS THE DESIGN

A floor that `preload`s `gate_fixture.gd` **cannot report that `gate_fixture.gd` is broken.** It
fails to compile itself, prints a Parse Error, runs not one line and **exits 0** — the fault DB
documented and the reason this project never reads an exit code. The instrument that checks the
fixtures must not be one of the files that depends on them, so `check_parse.gd` has no `preload`,
no `class_name` dependency and no fixture: it re-implements the two helpers it needs.

### A GATE THAT CAN ONLY PASS IS A GAP, SO THREE THINGS ARE HARD FAILURES

Each of these would otherwise shrink the population toward zero and print success.

| guard | armed how | result |
|---|---|---|
| `run_battery.sh` unreadable | the script moved out of the tree | **3 failures** — `BATTERY UNREADABLE`, and both arrays unparsed |
| an array parses to nothing | `SUITES=(` renamed to `SUITES_DISARMED=(` | **1 failure** — `BATTERY EMPTY: SUITES parsed to zero targets` |
| a battery name with no file | counted and reported as `(N missing)` | reads **0 missing** on the clean tree |

**AND COVERAGE DOES NOT SHRINK WHEN THE DERIVATION BREAKS, WHICH IS THE PROPERTY WORTH HAVING.**
All three armed runs still checked **159 files** (158 plus the control copy of HEAD's gate sitting
in the tree at the time). The residue layer catches whatever falls out of layer A — with `SUITES`
renamed, all 46 suites simply moved into the residue list and were still loaded. **Only the
LABELLING moves, and the guards say so out loud.**

### AND A MALFORMED DATA FILE WAS THE ONE THING THE FLOOR PROCEDURE COULD NOT SEE

Armed with an unterminated `data/runes.json`, the first version of this gate reddened its **tally**
and left the **stream clean** — `stderr Parse Error/SCRIPT ERROR hits=0`. That is a floor that is
correct only if you read it the way the standing rule says *not* to. The JSON failure is written to
stderr naming itself a `Parse Error` now, with the file, the line and the parser's own message, so
**one floor procedure covers the whole floor.** Re-armed: **1 failure / 1 stderr hit.**

### IT PRINTS A CHECK COUNT NOW, AND THAT MATTERS MORE THAN THE WIDENING

For its whole life this gate read `checks=?`. **The only number it published was a failure total,
and a failure total reads zero whether the walk covers 158 files or 41** — which is precisely how it
was found short three times without anything going red. *The measurement it published could not
express the defect it had.*

`baselines.json` pins the floor at **158**, written before the battery off **three identical
standalone readings** of `158 checks / 0 failures`, so `check_de` certifies on pass one. A walk that
quietly stops covering something is a **FALL** and reds; a batch that adds a suite is a **RISE** and
reads as a notice telling the next batch to record it. **Eight targets could not report a check
count; seven cannot now.**

### NEGATIVE CONTROLS — TEN ARMS, EVERY ONE OF THEM TWO-ARMED

**An arm that only reds the new gate proves that a broken file is broken. It does not prove the
widening.** So every injection was run against **HEAD's own copy of `check_parse.gd`**, restored
from a scratchpad backup rather than by `git checkout`, and the disarmed state was confirmed red-
free on both first: `0 failures | 0 stderr hits` on each.

| # | arm — a `func _ei_control_broken(:` appended (an unterminated object for the JSON) | NEW gate | HEAD's gate |
|---|---|---|---|
| 1 | **`gate_fixture.gd`** — the exact file EH broke | **24 failures / 74 hits** | **0 / 0** |
| 2 | **`suite_fixture.gd`** | **38 / 39** | **0 / 0** |
| 3 | a GATE — `check_dk.gd` | **1 / 1** | **0 / 0** |
| 4 | a SUITE — `test_batch_bf.gd` | **1 / 1** | **0 / 0** |
| 5 | the RUN HARNESS — `test_run_harness.gd` | **1 / 1** | **0 / 0** |
| 6 | a SCENE-RUN script — `check_map_screen.gd` (reached only through a root `.tscn`) | **1 / 1** | **0 / 0** |
| 7 | a RESIDUE file — `check_dn.gd` | **1 / 1** | **0 / 0** |
| 8 | DATA — `data/runes.json` | **1 / 1** | **0 / 0** |
| 9 | the battery script hidden / an array renamed | **3** and **1** | n/a |
| 10 | **POSITIVE CONTROL** — `scripts/talents.gd`, which the OLD gate already covered | **59 / 539** | **10 / 101** |

**ARM 1 IS THE ONE THAT SETTLES IT. The 24 failures are the fixture and the 23 gates EH counted** —
the number reproduced without being aimed at. And on HEAD's gate the same broken tree reads **`0
failures` with a clean stderr grep**, which is EH's report reproduced exactly: not a gate that
failed to shout, a gate that never looked.

**ARM 10 IS WHY THE WIDENING IS A SUPERSET RATHER THAN A REPLACEMENT.** `scripts/talents.gd` is in
the old gate's own territory, and both arms bite — the new one harder, because it also loads the
gates and suites that depend on it. **A widening that made an old arm go quiet would be a
narrowing wearing the wrong name.**

---

## §2 — A BRIEF'S PRECEDENT IS A CLAIM, AND CLAIMS GET CHECKED

Recorded in `CLAUDE.md`, under the section that already holds *verify the brief against the repo*:

> **When a brief cites a precedent — a prior ruling, a mechanism, an existing ladder or convention —
> the batch VERIFIES it against the code before building on it, and reports if it does not hold.**
> A wrong precedent is worse than a wrong number: a number gets re-derived, and a precedent gets
> INHERITED.

**THE GAP IT CLOSES IS REAL AND IS NOT THE ONE THE FIGURE RULES COVER.** The standing rules already
say to derive a figure from the file, and three instruments enforce it — the pin manifest,
`check_ed`, the literal sweeps. **A precedent is not a figure.** Nothing told a batch to check one,
and nothing could have: **documents get swept and briefs do not.** A false claim in `master.html` at
least sits in a file somebody can sweep; a false claim in a brief propagates by being *read*, into
the next brief, with no surface for an instrument to bite.

**THE LINEAGE IS THREE ERRORS DEEP AND EVERY ONE LIVED IN A BRIEF:**

1. **CT** was told to follow *"the rune equip-slot ladder — it grows 2→3→4 by zone"*. It was deleted
   at **AN §9** and `rune_slots()` has returned a flat 3 ever since. CT caught it and recorded it.
2. **Eleven batches later, EG's brief asserted the same ladder.** The correction was in a batch
   report, and briefs are not written from batch reports.
3. **EH's brief then diagnosed the source as `master.html`** — and that document has **never carried
   the claim**. It says "three flat slots", "no runes and three empty slots" and "three rune slots"
   in all four places it mentions them, and one of them says *flat*. The correction was aimed at a
   file that was right the whole time.

**IT IS WRITTEN DOWN BECAUSE IT IS ALREADY WHAT HAPPENS, WHICH IS THE ARGUMENT FOR RECORDING IT
RATHER THAN AGAINST IT.** EG caught CT's; EH caught EG's. **A practice nobody has stated survives
exactly as long as every session thinks to do it**, and the rule costs nothing in a session that
would have done it anyway.

**NO SWEEP OF PAST BRIEFS, AND NONE WAS RUN.** They are history, the changelog holds them, and the
reports already record every correction. The rule is forward-looking only, and it says so in
`CLAUDE.md`.

**AND IT WAS APPLIED TO THIS BRIEF, WHICH IS THE ONLY honest way to record a rule about briefs.**
Every precedent §1 and §3 rest on was re-derived here rather than accepted: the three prior findings
against `check_parse` (CP's tally, DE's suites, EH's fixtures), the 23-gate figure, the enabler
count, and the claim that EH's `master.html` sweep left no third section carrying the lag. **Five
held. The sixth did not**, and §3 is what that cost.

---

## §3 — THE TWO CONFIRMATIONS: ONE HOLDS, ONE DOES NOT

### (1) THE SECTION LAG — **IT DOES NOT CONFIRM. A THIRD SECTION CARRIES IT.**

**The method matters here, because the first attempt found nothing.** EH's twelve claims were
re-swept over the WHOLE document rather than over the sections EH named. A line-by-line sweep
returned one hit. **The same sweep over UNWRAPPED text returned the one that mattered** — the claim
spans a line break, and every line-based instrument in this project is blind to that shape. It is
the same species as the greedy-window and conjunction holes already on the record.

**FINDING A — §10 Battle Screen & Controls, line 2631. FALSE, and it is the same sentence.**

> *"There is no cap on how many abilities a hero holds, so slot 10 onward binds to Shift + the same
> key in the same order (10 = Shift+Q, 11 = Shift+W, … 18 = Shift+G)."*

**BO §2 gave earned abilities a cap and EG made it a LADDER** — `Run.ABILITY_SLOTS_BY_BOSS` is
`[7, 8, 9, 10]`, read only by `Run.ability_slot_cap()`. This is §6a's *"There is no cap and no swap
step"* standing **1,450 lines away in a different section**, which is EH's own §6a/§6b finding
repeating at four times the distance.

**AND THE PRECISE READING IS WORTH RECORDING, BECAUSE THE WORDS ARE HALF TRUE.** Under EG's
vocabulary the POOL (`bm_abilities`) genuinely is uncapped — nothing ever leaves it. The LOADOUT is
what the ladder binds. **The ability menu is built from `equipped_ability_names`, so it shows the
loadout**, and the sentence is false about the exact surface it exists to explain. *A claim that is
true of the neighbouring set is harder to catch than one that is simply wrong.*

**THE CONSEQUENCE WAS DERIVED RATHER THAN ASSERTED.** `_menu_entries` is one basic attack, plus the
summon family folded into a single group, plus the rest of the kit and the loadout. Driven over all
twelve specs at the ladder's top rung, **the widest menu any of them can raise is ELEVEN entries** —
eleven on every one of the twelve, which is itself worth noting. So §10's promised range of 10–18
reaches **⇧Q and ⇧W**, and ⇧E through ⇧G are headroom. The document now says so.

**AND TWO SOURCE COMMENTS CARRIED THE SAME CLAIM.** `battle.gd:131` (*"Batch AH: there is no cap on
how many abilities a hero holds"*) and `battle.gd:22547` (*"Batch AH: heroes hold as many abilities
as they earn"*), one screen apart from the code that contradicts them. **This is EH's `classes.gd`
stance-swap comment arriving in a second file**, and it is CLAUDE.md's own EB §2 rule: *a comment
naming code is a claim, and it goes stale silently.* Both corrected.
**Proved comment-only by a comment-stripped, blank-stripped diff against `HEAD`: `scripts/battle.gd`
14,143 code lines before and after, 0 differing; `check_de.gd` 253 and 253, 0 differing.**

**FINDING B — §6.4 Hunter, lines 2071–72. FALSE, and §13 says so 975 lines below.**

> *"Spec pool (earnable, §6a) — five of the designed eight (Blight, Smoke Bomb and Field Dressing
> land later)"*

**Two of those three names are spent**, verified against the live pools rather than read off the
document: **Field Dressing** is in `CLASS_DRAFT_POOLS` (written at BR as a Hunter class-wide draft
card) and **Smoke Bomb's function shipped at BO as Choking Smoke**, which is in `SPEC_DRAFT_POOLS`.
Neither name resolves to anything owed. **Only Blight is still owed.** §13 records exactly this —
*"Two entries were stale"* — because **DS swept §13 and not the section above it.** The §6a/§6b
shape, third instance.

**The Sharpshooter's list thirty lines above it names Disengage, Suppressing Fire and Piercing
Arrow, and all three really are still owed** — zero definitions, in no pool. Checked, not assumed,
because a sweep that only reports what it finds wrong is a sweep whose population nobody can size.

**FINDING C — §11b, line 2779. It describes a first-run card the game no longer shows.**

> *"The framing card … what a run is — climb the tiers, the unavoidable mini-boss halfway up, the
> two ability picks a zone pays out, kill the zone boss, three zones…"*

**The card's own text, in `map_screen.gd`, names no ability pick at all.** It teaches 49 encounters,
three zones of sixteen and the end boss; that a zone is a MAP and not a road; that stepping down a
row closes the corridor above; what an elite, the smith, the Peddler and ??? each are; the three
bargains; and that clearing anything heals 15% with no resting. **The summary omits four of those
and invents one.** Rewritten from the card, since the code's own string is authoritative.

**WHAT THE RE-SWEEP FOUND NOTHING ON, STATED SO THE POPULATION IS NOT READ AS ALL-DEFECT.** Nine of
EH's twelve claims return **zero hits** anywhere in the document — the `core + 3 + 2 = 6`
arithmetic, the seven-ability kit, the SPEC-pool-alone award, the fallback that cannot run out, the
end boss as zone 3's boss, the only stance swap, the only remover of Resonance, the Warrior helping
nobody else, and *exactly 3 spec abilities*. **EH's repair holds everywhere it reached.** And §8
Economy — nine hits, the largest concentration outside §6a/§6b — is fully current: it names the
three-tier chain, three picks a run, and the slot the zone boss grants.

### (2) THE ENABLER COUNT — **CONFIRMED. THE RECORD NAMES SIXTEEN.**

Derived live off `PROTECTED_CORES` rather than read from any document: **twelve rows, nine carrying
entries, sixteen names.**

| spec | enablers | | spec | enablers |
|---|---|---|---|---|
| swordmaster | Guard Change | | inquisitor | Divine Shield, Consecrated Ground |
| pyromancer | Fireball, Detonation | | occultist | Shadowrend, Hex of Ruin |
| cryomancer | Frostbolt, Ice Lance | | beastmaster | Summon Ursus, Summon Canis, Summon Aguila |
| arcanist | Arcane Explosion | | sharpshooter | Quick Shot |
| holy | Heal, Hymn of Hope | | *berserker, warden, mystic* | *none* |

**Every record that REASONS from the number says sixteen**, and one of them is mechanical:

- `CLAUDE.md`'s *A COUNT THAT IS LOW* bullet — *"7→16 at EH"*, with the EH instance written out as
  the one to remember.
- `docs/changelog.html`'s EH entry — *"`PROTECTED_CORES` names SIXTEEN, across nine specs."*
- `docs/state.md` — same, as EH's §3 finding.
- **`check_eh` §3 asserts `enablers == 16` LIVE, derived by walking every spec** — so a seventeenth
  enabler joins the audit by being authored, and the count cannot rot back into prose.

**THE ONE SURVIVING "SEVEN" IS EG'S OWN CHANGELOG ENTRY**, and it is left standing deliberately.
*"ALL SEVEN NAMED ENABLERS ARE PROTECTED, CONFIRMED RATHER THAN ASSUMED"* is an accurate record of
what EG did, the changelog is what-happened rather than what-is-true-now, and **the entry fifty
lines above it corrects it.** Rewriting it would be editing history to hide a finding the newer
entry exists to report.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **Line 1511's *"the only Break lever the Hunter class has anywhere"* is left standing**, as the
  brief instructs. 21 Hunter-reachable abilities carry Break damage, but *lever* may mean
  **amplifies** Break rather than **deals** it, and the code cannot settle which. **A claim no
  instrument can check is not repaired by asserting it harder.**
- **No rune work.** None was started and none is implied by anything here.
- **The four residue files are not adopted into the battery.** `check_ck_width`, `check_cu`,
  `check_cv` and `check_dn` are audit REPORTS rather than pass/fail gates — `docs/state.md` records
  why — and putting them in `GATES` is a ruling about what a failure there MEANS. They are
  parse-covered and named; that is the floor's job and the rest is the designer's.
- **`check_de.gd`'s stale figure was corrected and nothing else in it was touched.** Its comment
  said *"ten of nineteen gates cannot report a check count"* against thirty-two gates, and this
  batch was about to make it wronger. The live set is derived from `baselines.json`; the comment now
  says so instead of restating a number.
- **No new gate.** §1's ruling is embodied in `check_parse.gd` itself and ratcheted by its own
  baseline row; §2's rule is about how a brief is read, which no gate can ask; §3 is a measurement,
  and this project's convention is that a gate encodes a ruling.

---

## §5 — VERIFICATION

### THE ORDER, BECAUSE IT IS THE HALF THAT MAKES THE EVIDENCE MEAN ANYTHING

Every document a suite asserts against was written **before** the verification run:
`docs/changelog.html`, `CLAUDE.md`, `docs/master.html`, `docs/instrument-rules.md`,
`docs/design-notes.md`, `baselines.json`, both `battle.gd` comments and `check_de.gd`'s. Only
`docs/state.md` and this report were written after, and **nothing in the tree reads either** —
verified by grep rather than recalled: every mention of `state.md` and of `docs/reports/` in the
`.gd` and `.py` sources is prose inside a comment, and nothing globs that directory.

### THE NEEDLE PROOF, RUN TWICE OVER TWO INSTRUMENTS

**INSTRUMENT 1 — THE PIN MANIFEST, WHICH IS THE PROJECT'S OWN ANSWER TO THIS QUESTION.**
`check_ed` was run against **HEAD's manifest with the edited documents in place**, which is the
exact test: does any recorded pin stop resolving? **18 checks / 0 failures**, 944 of 1034 source
pins verified. And `build_pin_manifest.py --check` reports the manifest **current at 1335 pins** —
this batch's edits moved no pin at all, so the manifest is unchanged and needed no regeneration.

**INSTRUMENT 2 — A RAW LITERAL SWEEP, BEFORE AND AFTER.** Every string literal of four characters
or more in all 39 gates, 47 suites and both fixtures — **11,222 needles**, decoded with
`build_pin_manifest.py`'s own unescaper so the non-ASCII ones are not mangled (EH's extractor hole,
not re-dug) — counted present against each tracked document on HEAD's copy and on the edited copy.

| document | present before | after | LOST | GAINED |
|---|---|---|---|---|
| `CLAUDE.md` | 834 | 837 | **1** | 4 |
| `docs/instrument-rules.md` | 325 | 324 | **1** | 0 |
| `docs/master.html` | 1122 | 1122 | **0** | 0 |
| `docs/changelog.html` | 833 | 844 | **0** | 11 |
| `docs/design-notes.md` | 905 | 910 | **0** | 5 |
| `docs/state.md` | 580 | 580 | **0** | 0 |
| `docs/text-standard.html` | 239 | 239 | **0** | 0 |

**BOTH LOSSES WERE TRACED TO THEIR SITES RATHER THAN WAVED THROUGH**, and the lookup was proved to
bite first — the manifest holds 66 pins into `CLAUDE.md`, so a query returning zero is a real zero
rather than a wrong key name.

- **`"res://scenes"` left `CLAUDE.md`** with the sentence that named the old walk. Its only
  occurrence as a literal anywhere in the tree is a `DirAccess` path inside `check_parse.gd` itself.
  The manifest's one pin on that string has `scripts/map_screen.gd` as its haystack, not this file.
- **`"blacksmith"` left `docs/instrument-rules.md`** with a stale scene count (*"TWELVE scenes since
  Batch BK (blacksmith is new)"* — there are **thirteen** in `scenes/`, corrected in passing). Its
  two manifest pins both name `scripts/run_state.gd`.

**AND THE SOURCE EDITS WERE PROVED COMMENT-ONLY BY A COMMENT-STRIPPED, BLANK-STRIPPED DIFF AGAINST
`HEAD`** — blank-stripped because a stripped comment leaves an empty line, so adding comment lines
shifts every following line and a naive diff reports seven changes where there are none.
`scripts/battle.gd`: **14,143 code lines before, 14,143 after, 0 differing.** `check_de.gd`:
**253 and 253, 0 differing.**

**RETIRED WORDS WERE PRE-CHECKED BEFORE THE BATTERY, NOT DISCOVERED BY IT.** `test_batch_bx` §4
strips `Beastmaster`/`beastmaster` from `master.html` and forbids the rest of "beast"; §4b strips
five identifiers and forbids "party". The edited document reads **0 survivors of each**.

### PREDICTIONS, FROM WHAT EACH TARGET READS

| target | reads | predicted |
|---|---|---|
| `check_parse` | `run_battery.sh`, the closure, `scripts/`, `scenes/`, `data/` | **`checks: null` → 158**, off three identical standalone readings |
| `check_de` | the logs and `baselines.json` | **345 → 346**, the +1 being exactly the count `check_parse` gained |
| `check_ed` | the pin manifest | **unchanged at 18**; manifest unchanged at 1335 pins |
| `check_da` / `check_dw` | the walk fingerprints and the exemption tables | **unchanged at 41 and 35** — no function here returns a hand-rolled corpus, and `RETURN_WALK_EXEMPT` is untouched at one |
| `check_ec` | the instruments' own territories | **unchanged at 23** — nothing pins `check_parse`'s territory |
| every target reading a document | `contains` whose count is fixed | **unchanged** — 0 LOST needles that any assertion reads |
| everything else | — | **unchanged**: no ability, no magnitude, no pool, no constant a suite counts |

All seven were run standalone before the battery and all seven read as predicted.

### THE BATTERY

**TWO RUNS, BOTH FROZEN, BOTH CLEAN — AND THE FIRST FOUND NOTHING, WHICH IS THE UNUSUAL PART.**

| | **run 1** | **acceptance run** |
|---|---|---|
| targets run / named in the manifest | **84 / 84** | **84 / 84** |
| suite failures | **0** | **0** |
| `Parse Error` / `SCRIPT ERROR`, grepped from all 84 streams | **0** | **0** |
| `check_cm_live` (the recorded deliberate red) | 4 | 4 |
| check counts outside their band | **0** | **0** |
| `check_de` | **346 / 0 / 0 notices** | **346 / 0 / 0 notices** |
| `check_parse` | **158 / 0** | **158 / 0** |
| run harness | 22 / 166 / 8 | 22 / 166 / 8 |
| MD5 drift across 309 tracked files | **0** | **1 — `docs/state.md`** |

**`check_de` READ ZERO NOTICES ON BOTH RUNS**, so not one unpredicted count moved anywhere in the
tree — the +1 on its own total is `check_parse`'s new count arriving as something it can compare.
**Its 346 is not a baselined row**: `check_de` has none of its own, which is why its total moving
for a gate that gained a count is reported by nothing and is stated here instead.

**THE ONE FILE THAT DIFFERS FROM THE CERTIFIED TREE IS `docs/state.md`, AND THIS REPORT**, which
did not exist when the run started. **Both are read by nothing**, checked rather than recalled.

**AND THE FLOOR WAS RUN THE WAY THE BRIEF SPECIFIES, NOT THE WAY THE GATE REPORTS.** `0` matches of
`Parse Error|SCRIPT ERROR` across all 84 log files, grepped from the streams — never off a tally,
never off an exit code. The tally is now a ratchet on COVERAGE, which is a different question from
whether the tree parses, and this batch is the reason to keep asking both.

---

## WHAT A LATER BATCH SHOULD KNOW

- **`check_parse`'s count is a coverage number, not an assertion tally.** If it FALLS, the walk
  stopped covering something — do not "fix" it by re-baselining. If it RISES because a suite was
  added, record the new number.
- **The gate must never gain a `preload`.** It is the only file in the tree with that constraint and
  the reason is written at the top of it.
- **The four residue names are the early-warning list.** A file appearing there that should be
  spawned by the battery is the fourth instance of this defect, arriving early enough to be cheap.
- **`master.html` §6a's lag has now been found in three sections and the third was invisible to a
  line-based sweep.** Sweep that document on unwrapped text.
