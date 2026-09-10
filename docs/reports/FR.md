# BATCH FR — THE NUMBERS `master.html` STATES, AND A READER FOR THE RULE

**On `main`.** Nothing touched `class-merge`, no merge work was done, and **not one rune, card,
ability, talent, constant or magnitude moved.** No `.gd` under `scripts/` and no file under
`data/` was edited. This batch corrected documents toward the code and never the reverse.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| Premise | Verdict |
|---|---|
| `master.html` says the run save is v8 and refuses below v8 | **TRUE** |
| `run_state.gd` writes v12 and refuses below v10 | **TRUE** — `save_run` line 2292, `load_run` line 2320 |
| `docs/ways-of-working.md` has zero readers | **TRUE** — re-measured; the file was opened by nothing |
| The document has misled a brief FIVE times | **TRUE**, and the fifth is now six: this batch found fourteen more |
| *(from `docs/state.md`'s queue)* the run-save fix "**is a two-number edit**" | **FALSE** — see §1 |

**THE ONE FALSE PREMISE IS THE QUEUE'S, NOT THE BRIEF'S, AND IT IS THE INTERESTING ONE.** FQ routed
the run-save figures to the queue with the note *"THE PROSE AROUND THEM IS STILL RIGHT … It is the
two version numbers alone that moved."* The prose around them is **not** still right, and a batch
that trusted that line would have shipped a newly false sentence. §1 has the working.

---

## §1 — THE TWO KNOWN FALSE CLAIMS

### §1a — THE RUN SAVE, AND WHY IT WAS NOT TWO NUMBERS

`master.html` said the save is **format v8** and that a save **older than v8** is refused, giving as
the reason that such a save *"holds a flat 12-slot line and a single slot index, which has no honest
place on a lattice."*

- `save_run` writes **`"version": 12`**.
- `load_run` refuses **`save_version < 10`**.
- **THE REASON BELONGS TO A DIFFERENT THRESHOLD.** The flat-12-slot-line argument is **BK's**, and
  it is why **v8** refused **v7**. The live threshold is **BM's v10**, and its reason is in
  `run_state.gd`'s own version block: *the map gained a SEVENTEENTH slot in the final zone, so a v9
  save's final-zone map has no position to walk onto after its boss.* **A v9 save HAS the lattice.**

**SO CHANGING ONLY THE DIGITS WOULD HAVE MANUFACTURED A NEW FALSE CLAIM** — "a save older than v10
holds a flat 12-slot line" is false of v8 and v9 saves — and it would have read as freshly checked.
This is DR's Flash Freeze rule arriving through a repair rather than through a stale claim: **a
claim corrected to describe a dead mechanism is still a claim about a dead mechanism.**

**`CLAUDE.md` CARRIED THE CORRECT REASON THE WHOLE TIME** (*"a pre-v10 save is REFUSED and cleared
(the final zone gained a 17th slot; a v9 map has no position after its boss)"*), which is worth
recording: the two rule files did not drift together, and the one with an instrument reading it
stayed right.

**The paragraph now states v12, the v10 floor with BM's reason, keeps BK/AN/AI as the precedents
they are, and adds the half that was never written down: v10 is a FLOOR and not the format — v10
and v11 saves load tolerantly**, because everything added since is counters and slots rather than
structure.

### §1b — `docs/ways-of-working.md` HAS A READER: `check_fr.gd`, 25 CHECKS

FQ §2e measured it and said it plainly. Nothing in the tree opened that file, so the branch rule it
had just recorded — *the merge is developed on `class-merge`, `main` stays playable* — **was
enforced by nothing**, which is BN's run-save warning: documented, correct, and silently ignored.

**THE GATE SAYS IN ITS OWN HEADER WHAT IT CANNOT DO, AND THAT IS THE HALF THE BRIEF ASKED FOR.**
Six of that file's eight rule blocks are about how a batch comes to EXIST — design settled before a
brief, a recon read before authoring, findings routed to the queue, implementation calls belonging
to the batch, a batch being mostly transcription. **Not one of them leaves an artefact in the
tree.** There is no file whose contents differ according to whether a name was settled in
conversation first. **A check claiming to assert them would always pass, which is worse than none**
— it would make the file look instrumented while enforcing nothing, which is the exact fault the
gate exists to end.

**WHAT IT DOES ASSERT, AND IT IS THE TWO RULES WITH ARTEFACTS PLUS THE FILE'S OWN HOUSEKEEPING:**

| § | What it asserts | Why it is checkable |
|---|---|---|
| §1 | The branch rule: the branch NAME read out of the rule, that ref existing in `.git`, the branch not being `main`, the version guard present in `profile.gd`, `CLAUDE.md` pointing here, and `CLAUDE.md` NOT restating the branch name | a git ref and two string reads |
| §2 | No line of 60+ characters appears verbatim in `CLAUDE.md` or `instrument-rules.md` | the file's own no-second-copy rule, as written |
| §3 | Every repo path it names in backticks resolves | a pointer to a missing file is that rule failing |
| §4 | The conflict table still names all eight files FQ measured | a floor, never an equality — a ninth row is right to add |
| §5 | It stays the SMALLEST of the three rule files, and holds no batch block and no timestamp | the size bar is DERIVED from *it is a third file, not a third seam* — **no byte figure is pinned** |
| §6 | The four rule headings its own arms read, plus a liveness arm on both extractors | §2 and §3 pass by finding NOTHING, and a gate whose clean state is "no findings" reads like one that stopped looking |

**§1 IS TWO FACTS AND NOT THEIR CONJUNCTION, AND THE HEADER SAYS SO.** The rule says the branch is
*cut from the commit that carries the profile version guard, not from before it*. **A gate reads
refs and cannot walk ancestry**, so it asserts the branch EXISTS and the guard IS IN THE TREE,
separately. A branch cut from before the guard satisfies both. **That hole is named rather than
papered over**; closing it needs a `git merge-base`, which is a shell and not a gate.

**THE BRANCH NAME IS READ OUT OF THE RULE AND NEVER PINNED.** A literal in the gate would be the
second copy the file's own preamble forbids; the batch that renames the branch edits one file.

**EIGHT CONTROLS, EACH ON THE ARM IT AIMS AT**, with both touched files restored by md5 afterwards
and the hashes verified:

| Control | Reds | Arm |
|---|---|---|
| branch renamed to one that does not exist | 1 | §1 ref |
| `CLAUDE.md` made to restate the branch name | 1 | §1 second-copy |
| the pointer removed from `CLAUDE.md` | 1 | §1 pointer |
| a 60+ char line copied into `CLAUDE.md` | 1 | §2 |
| a pointer aimed at a file that does not exist | 1 | §3 |
| a file dropped out of the conflict table | **2** | §3 **and** §4 — correctly, it is both |
| a batch block appended | 1 | §5 |
| a rule heading deleted | 1 | §6 |

**AND WHAT IS STILL NOT INSTRUMENTED IS SAID IN THE FILE ITSELF**, not only here: the file now
carries a sentence naming its gate and stating that the rules above the branch section are about
people and are checked by nobody.

---

## §2 — THE SWEEP: THE FULL POPULATION

**Every numeric claim in `master.html` was read against the code.** The document holds **3,743
numeric tokens** across 16 sections, split almost exactly in half between tables (1,853) and prose
(1,890).

### §2a — THE FOURTEEN DEFECTS

| # | Site | Claim | Live value |
|---|---|---|---|
| **D1** | §2 | run save "format **v8**", refuses "older than **v8**", *and the reason* | **v12**; refuses below **v10**, for BM's 17th-slot reason |
| **D2** | §3b | verb vocabulary lists **`talent_points`**; omits **`ability_draft`**; worked example offers "health for talent points" and "gold for maximum health" | `talent_points` is in neither `Events.VERBS` nor `events.json`; `ability_draft` is live in both, used by 2 events; the live conversions are ability-for-gold/health and **maximum health FOR gold** |
| **D3** | §4.3 **and** §9 | enemy tier ladder "**1–11**" (two sites) | `clampi(slot_idx + 1, 1, SLOTS_PER_ZONE)` = **1–16**. The RATES (+2% / +2.5%) are right |
| **D4** | §6b | "**fifteen** at the cheapest spec" | **sixteen** — driven in the engine, not parsed |
| **D5** | §6b | table heading "**one hundred and forty-two** … one hundred and **eighteen** spec … **twenty-four** class-wide" | the table is **127 = 103 + 24**; the pools are **154 = 129 + 25** |
| **D6** | §6b | a "**the floor is still eight**" stratum (5 sentences) | the floor is **TEN**, which the same section says correctly 60 lines above |
| **D7** | §6b | *(coverage, not a number)* 27 pool entries have no table row | 23 are described in §6.1–§6.4; **four are described nowhere** |
| **D8** | §6c | cores meet a 2+ threshold on "**DEBUFF for seven**" | **five**. BREAK ten, MARK zero, TEMPO-reaches-1-on-one are all correct. **7 is the OFFENSE column** |
| **D9** | §7 | the capstone shelf "sits behind **difficulty 2**" | **difficulty 3** — driven; contradicts the row-gating table eight lines above |
| **D10** | §7 | **eight of twelve spec headings sit above the wrong tree's table** | re-paired |
| **D11** | §7 | Sharpshooter lane "**TEMPO**" | **Pace**. The document's own table header already said Pace |
| **D12** | §8 | rune file "**126 ENTRIES: 66 RETIRED**" | **127 / 67**. The same document says 127 fifty-four lines later |
| **D13** | §8 | an FF-era stratum: "**21 live runes**", "**66 retired** … 100 ×**42**", "21 runes across **four specs**", "the file has held **87 entries**" | **60** live across **twelve**; **67** retired, 100 ×**43**; **127** entries |
| **D14** | §9 | budget ramp "**3 + half the tiers already climbed**" and all five worked bands | `3 + floor((tier−1) × **5/14**)` over 16 tiers. The code's own comment names the change |

**FIVE OF THE FOURTEEN ARE THE DOCUMENT CONTRADICTING ITSELF** — D5 (80 lines), D6 (60), D9 (8),
D11 (71) and D12 (54). **Every one of those is checkable without reading a line of code.**

**AND THREE OF THEM ARE ONE ERA.** D1's reason, D3's range and D14's ramp are all pre-lattice —
from when a zone held twelve slots — and all three survived the batch that changed it.

### §2b — THE EIGHT MIS-PAIRED HEADINGS, WHICH ARE THE FINDING WORTH KEEPING

Each `<p><b>Spec</b> — LANE · LANE · LANE</p>` in §7 is followed within four lines by a table whose
`<th>` row names the lanes. **The tables are in canonical `SPEC_IDS` order and the headings were
not.** The Holy heading introduced the Pyromancer's tree, the Devout's the Cryomancer's, the
Sharpshooter's the Arcanist's, the Survivalist's the Holy's, the Beastmaster's the Devout's, the
Pyromancer's the Beastmaster's, the Cryomancer's the Sharpshooter's and the Arcanist's the
Survivalist's. **Only Berserker, Swordmaster, Warden — and, by coincidence, Occultist — lined up.**

**NOT ONE NUMBER IN §7 IS WRONG.** All 324 cells match the trees name for name and figure for
figure (§2c). **A document can be correct line by line and still tell a reader something false**,
and no check that compares values against code can see it.

**THE REPAIR IS A PURE PERMUTATION OF THE FILE'S OWN LINES AND IS ASSERTED AS ONE** — the script
requires `sorted(new.splitlines()) == sorted(old.splitlines())` before it writes — so no literal
could be lost or gained by it. One follow-on paragraph (the Venom lane's explanation) was orphaned
by the move and was carried to the Survivalist by a second permutation, asserted the same way.

### §2c — WHAT THE SWEEP FOUND CLEAN, MEASURED RATHER THAN ASSUMED

**This is the larger half and it is the evidence §3 rests on.** Three instruments were built, each
armed against a control before its reading was trusted.

| Instrument | Comparisons | Raw flags | True defects | Control |
|---|---|---|---|---|
| §7 talent tables vs `Talents.desc_for()` | **324** node names + **291** full number sequences | 0 | **0** | two-armed (one number, one name); both bit |
| §6.1–§6.4 ability stat lines vs the engine corpus | **296** fields (cost / Mercy / BD / cooldown / delay / damage) over 84 of 227 cards | 3 | **0** | the three are handler-side figures |
| §9 bestiary vs `data/enemies.json` | **156** fields (power, HP, roles, zones, BD, resists, soft-to, speed, Constitution) | 0 | **0** | five-armed, one per needle kind; all five bit |
| §6a/§6b pool tables vs the three pool constants | **198** names | 0 | **0** | engine-read |

**AND THE HAND-CHECKED REST READ EXACTLY**: all 12 constitution figures, the class stat table
(16 figures), `MODIFIERS` (20 entries, every severity and description), `REWARDS` (40/80/140/220),
`KIND_WEIGHTS` and all 20 events with their bane magnitudes, `ITEM_PRICES` (8), `BLACKSMITH_PRICES`,
`NODE_COPIES`, `ITEM_SLOTS_BY_ZONE`, `ABILITY_SLOTS_BY_BOSS`, `TIER_ROWS`, `PROTECTED_CORES` (all
12 slot counts and all 12 enabler lists), the archetype-tag corpus (227; BREAK primary **0**;
OFFENSE 70; the eight MARK leads and the two MARK seconds by name), the Resonance table's
triangular arithmetic, the Sharpshooter sequence's seven constants and its whole Focus table, every
status magnitude in §4.6, and the twelve `THEMES` with their exact node columns.

**THE THREE RAW FLAGS ARE ALL ONE SHAPE AND `battle.gd` NAMES IT**: *"those two fields are zero on
Feint, Guard Change and Kill Command, which hit hard from inside their handlers."* Guard Change's
15 BD is dealt at `battle.gd:20640`, Kill Command's 40 BD is **Ursus's maul** at `battle.gd:17348`,
and the third was Shadowrend's parenthetical caught by a window that started at "Smite".

### §2d — TWO SUITE NEEDLES MOVED, WHICH IS DO'S OWN PRECEDENT

`test_batch_cb` pinned **`"hundred and forty-two"`** and **`"All twelve specs draft from at least
eight"`** — the two figures D5 and D6 corrected. Its own comment records DO doing exactly this:
*"BATCH DO MOVED BOTH NEEDLES BECAUSE IT MOVED BOTH SENTENCES."*

**THE UNMODIFIED SUITE WAS RUN AGAINST THE NEW TREE FIRST** and read **1730 checks / 2 failures** —
exactly the two predicted, and nothing else. Both were re-pointed with their reason and the file
reads **1730 / 0** at the same check count, so no baseline row moves for it.

**THE COUNT PIN NOW NAMES THE DRAFT AND NOT THE TABLE.** `"hundred and fifty-four"` is the number
the pools decide, so a later batch that authors a card moves it and the arm says so. The table's own
127 is deliberately **not** pinned — it is a fact about how much of the draft §6b catalogues, and
`check_cb` has never asserted that.

### §2e — WHAT THE SWEEP CANNOT CHECK, WHICH IS THE MORE USEFUL HALF

1. **SIMULATION MEASUREMENTS — the largest class in the document by far.** Completion rates,
   rounds-to-resolution, every n= and σ, the node-walk averages (~39.7 nodes a zone, 6.25 fights
   walked, 2.23 columns of foreclosure, 19.0 real decisions), 23,500 distinct warbands, 63% → 25–28%
   unspent gold, 8.4 / 8.1 / 3.8 offers a run. **These are facts about a measurement, not about a
   constant.** Nothing in the tree can confirm or refute one, and re-running them is a batch each.
2. **HISTORICAL CLAIMS.** "Batch DY deleted a 61-entry container", "seven finished abilities",
   "65 of the retirements are ET's and EO's". The structures are gone; only git can answer — and
   `master.html` is not supposed to hold history at all.
3. **BEHAVIOUR CLAIMS.** "Paths never cross", "no bane may kill a hero", "the ghost locks in when
   the ability is chosen". §2 was numbers; these need a driven check.
4. **POPULATIONS THE DOCUMENT DEFINES FOR ITSELF.** §6b's *"30 of the **66** damaging abilities
   never state their damage in prose"* resolves against no population I can construct — the whole
   corpus gives **75** with `damage > 0` and the draft pools give **39**. The denominator is a past
   batch's own classification. **Reported and deliberately not corrected.**
5. **UI GEOMETRY STATED AS PROSE** — "empty from y=452 down", "heroes ~x350–430". Real constants
   exist; the mapping from prose to constant is a human read each time.
6. **BORDERLINE, LISTED FOR THE RECORD.** §10's *"bosses ×4.4"* is right for two of the three
   (`withered_warden` and `ash_tyrant`) and **The Hollow Crown is 4.6**. It is an art note, so
   approximate is defensible; it was not changed.

### §2f — A CASE WHERE THE CODE LOOKS WRONG, REPORTED AND NOT CHANGED

**`scripts/events.gd:8–12` carries the same false worked example** the document did — its comment
says the tradeoff kind offers *"Health for a rune, gold for maximum health, health for talent
points"*, and `talent_points` has never been a verb. **The brief forbids changing code and
`instrument-rules.md` records that a `.gd` comment is an asserted surface**, so it is reported here
and left alone. It is a two-line comment edit for whoever takes it.

### §2g — AND THE SECOND COPIES IN `CLAUDE.md` WERE SWEPT, WHICH THAT FILE'S OWN RULE REQUIRES

EH §2: *"when a claim of fact is corrected, sweep for every copy of it — the document is one surface
of three."* Three of these defects had a second copy in `CLAUDE.md` and all three were corrected:
**"DEBUFF for seven"** (D8), and the rune figures twice over (D12/D13 — *"the file is 86 entries:
65 retired and 21 live"*, *"all 21 live runes read 100g"*, *"The 66 retired … 100 ×42"*, *"the
retired 66 … 100g ×42"*, *"FC's retirement has since taken the total to 66"*).
**A literal sweep over all 63 readers of `CLAUDE.md` reads 0 LOST and 0 GAINED**, so not one
asserted literal moved.

**AND D8 HAD A THIRD SURFACE, FOUND BY SWEEPING `docs/state.md` FOR THE SAME FIGURES AFTER THE
RUN.** *"DEBUFF for seven"* stood in `master.html`, in `CLAUDE.md` **and in `state.md`'s own
archetype-tag section** — and that section's next sentence says *"`check_es` §4 prints the
per-spec table every battery run rather than this file carrying a second copy of it."* **It was
carrying one anyway.** All three are corrected. **A three-surface claim is the shape EH §2 named,
and the third surface is the one a two-file sweep does not reach.**

---

## §3 — CAN IT BE AN INSTRUMENT? PARTLY, AND THE ANSWER IS MOSTLY NO

**Reported. Ruled on nowhere.**

### §3a — THE RATIO, MEASURED RATHER THAN ESTIMATED

- **The document is 3,743 numeric tokens, 49.5% inside a table and 50.5% in prose.**
- **The tables that have a code counterpart were fully compared and are CLEAN**: 1,265 comparisons,
  **3 raw flags, 0 true defects** (§2c).
- **NONE OF THE FOURTEEN DEFECTS WAS FOUND BY ANY OF THOSE INSTRUMENTS. All fourteen were found by
  reading.** Eleven are in prose; three are structural (a heading, a lane name, a table's own
  heading) and none is a value in a cell.

**SO THE HEADLINE FINDING IS THE ONE THAT ARGUES AGAINST THE GATE: a check that every number the
document states matches the constant it names would have caught ZERO of the fourteen**, because
the part of the document that names constants is already right. **EB declined to gate the header
sweep at 118 rows for 16 defects. This would be roughly 1,265 rows for 0.**

### §3b — THE FALSE-ALARM RATE, WHICH IS THE OTHER HALF AND IS WORSE THAN IT LOOKS

**Hardened, the three instruments read 3 flags in 743 numeric field comparisons — 0.4%, all false.**
That looks tolerable. **The first drafts did not.**

- The ability comparison's **first version reported 20 flags of which 18 were its own faults**, at
  ten times the hardened rate. Three distinct causes: **name containment** ("Strike" matching
  inside "Pommel Strike", "Charge" inside "Shrapnel Charge"), a **fixed-width window running into
  the next ability's numbers**, and **reading the wrong field** (Mercy costs live in `faith_cost`).
- The bestiary comparison **read clean and was wrong**: its BD pattern required a closing
  parenthesis, so it silently skipped "38 BD — a Break specialist"; a curly apostrophe broke
  "Chieftain's Maul"; and "Speed\n125" across a line break was invisible until the cell text was
  whitespace-normalised. **All three were found only by the control, and all three failed toward
  FEWER findings.**

**A DOCUMENT GATE'S FAILURE MODE IS SILENCE, NOT NOISE, AND THAT IS WHAT MAKES IT A BAD BUY HERE.**
A gate people learn to ignore is worse than none; a gate that quietly stops asking is worse again,
and this shape produces the second one. **Every hole above printed a clean zero.**

### §3c — WHAT *IS* WORTH BUILDING, AND IT IS SMALL AND STRUCTURAL

**The cheap check nobody has built is not doc-vs-code. It is doc-vs-doc.**

- **A heading/table pairing check catches D10 (8 sites), D11 and D5 outright** — each is a
  comparison between two parts of the same document, needs no code at all, and is a handful of
  lines: *the spec a §7 heading names must be the spec whose lanes the table under it lists*, and
  *a count in a table's heading must equal the rows in that table.*
- **A same-document numeric-contradiction check would reach D12 and plausibly D6** — two figures
  in one document attached to the same noun ("entries", "the floor") that disagree.
- **Together those two shapes reach 5 of the 14 at a fraction of the cost of the value gate**, and
  their false-alarm mode is noise rather than silence, which is the right way round.

**AND ONE THING ALREADY MEASURED IS ASSERTED BY NOTHING.** `check_es` §4(2) **prints** the per-spec
core-kit tag census on every battery run and its own comment says *"It is a REPORT."* D8 is that
printed table's figure, copied into THREE documents — `master.html`, `CLAUDE.md` and
`docs/state.md` — and drifted in all three. **A single arm comparing the
document's sentence to the census the gate already computes would have caught it the day it moved**
— one line, against a number the battery is already producing.

### §3d — THE RECOMMENDATION

**Do not build the value gate.** It is large, its clean reading is uninformative (the tables are
already right), and its failure mode is the silent one. **Build the two structural checks in §3c if
anything**, and give `check_es`'s existing census the one arm it lacks. **The rest of this document
is prose about a game, and the thing that keeps it honest is a batch reading it — which is what
this one did, and it found fourteen.**

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No merge work, and nothing touched `class-merge`.**
- **No spine is built.**
- **No rune, card, ability, talent, constant or magnitude moved.** No `scripts/*.gd` and no
  `data/*.json` was edited.
- **NO STANDING RULE WAS WRITTEN INTO `CLAUDE.md`.** The rules this batch would have written
  already exist there: *the code's field is authoritative and master.html is corrected toward it*,
  *sweep for every copy of a corrected claim* (EH §2), and *a section being current is not evidence
  that the section above it is*. **What is new here is a recommendation, and §3 says to recommend
  and rule on nothing.**
- **THE FOUR UNDESCRIBED DRAFT CARDS ARE NOT AUTHORED.** `Arcane Surge`, `Divine Wrath`,
  `Mana Shield` and `Reality Fracture` are named in §6b's pools and described nowhere in the
  document. Writing their rows is authoring. **The gap is now stated in the document itself** and
  routed to the queue.
- **`events.gd`'s comment is not corrected** — see §2f.
- **ONE PROSE TYPO IS REPORTED AND NOT FIXED.** `master.html:108` reads *"clearing any encounter
  heals **the every hero** 15% of max HP"*. It is a one-word repair and it is out of §2's scope
  (a number sweep), **and by the time it was noticed the tree was frozen for the battery** — a
  post-run edit would have made the shipped tree differ from the tree that was verified, which is
  the fault DL discarded two runs for. It is routed to the queue.

---

## §5 — VERIFICATION

### §5a — TWO FAULTS THIS BATCH MADE, BOTH CAUGHT, BOTH WORTH THE SPACE

**(1) THE REPAIR INTRODUCED THE DEFECT IT WAS REPAIRING.** D2's edit anchored on a string that
began mid-sentence, and the preceding words sat on the previous line. The result read
*"Health for a rune, gold for maximum health for gold, gold or health for a new ability"* — a
garbled sentence, shipped by the edit that existed to fix a false one. **It was found by reading
every changed region as FLATTENED prose against HEAD**, which is the write-side of the rule that a
doc sweep needs unwrapped text: **an anchor is matched on the wrapped file and the sentence is read
on the unwrapped one, and only the second shows what the edit produced.** All 32 changed regions
were then read that way; the other 31 were correct.
**IT COST A BATTERY.** The tree was already frozen and 33 of ~149 targets in, so the run was killed
by PID (the wrapper AND the orphaned `test_batch_br` Godot on PPID 1, then the process table
checked and the lock removed by hand), the sentence repaired, the tree re-frozen and the battery
re-run. **Killing at 33 cost less than finishing a run against text that had to change.**

**(2) `--quit-after N` IS FRAMES, NOT SECONDS, AND A TRUNCATED TARGET PRINTS NO VERDICT.** The
pre-check ran every doc-reading gate with `--quit-after 900` as a hang guard. Three of them —
`check_cs`, `check_dk`, `check_dm` — printed **no summary line at all**, and the reading was very
nearly recorded as *"these three report no readable count"*, which is a real property of some
targets in this project. **They were being cut off mid-run.** Without the flag they read
**104 / 0, 64 / 0 and 93 / 0**. A truncated target and a target that prints nothing by design
produce byte-identical output. **The whole pre-check was re-run without the flag**; all sixteen
gates print real verdicts and all sixteen are clean. `run_battery.sh` does not use the flag — its
watchdog is wall-clock — so the battery was never affected, only the pre-check.

**THE DOCUMENTATION WAS WRITTEN BEFORE THE VERIFICATION RUN** — `master.html`, `CLAUDE.md`,
`docs/changelog.html`, `docs/ways-of-working.md`, `docs/design-notes.md`, `baselines.json` and the
stamp were all in the frozen tree. **`docs/state.md` and this file were written after**, and that
is stated rather than left as a gap in a "zero differ" claim: a fixed-string sweep (not a regex —
an unescaped `.` in `state.md` matches `state_md` and over-reports) finds **no runtime open of
either path**; every hit in the tree is prose inside a comment.

### §5b — THE NEEDLE SWEEP, ARMED BEFORE A BYTE MOVED

**37 readers of `master.html`, 9,661 distinct literals, 1,153 present.** Compared against HEAD's
copy with the SAME reader set, so the new gate joining the pool could not be mistaken for a
document change.

| | |
|---|---|
| **LOST** | `at least eight`, `talent_points` |
| **GAINED** | `All twelve specs draft from at least ten`, `hundred and fifty-four`, `ability_draft` |

**BOTH LOSSES WERE CHASED AND BOTH ARE OVER-REPORTS OF THE INSTRUMENT.** The sweep pools every
literal in a reader rather than only the ones aimed at the document, which over-reports and never
under-reports. `talent_points` is carried by `check_fq`, `profile.gd`, `run_state.gd` and four
suites **as a Profile key and an events-JSON key**; nothing asserts `master.contains("talent_
points")`. `at least eight` survives only inside `test_batch_bx`'s `ok()` MESSAGE for a
`warden_cards.size() >= 8` code assertion, and inside two comments — one of them the comment this
batch wrote. **The three GAINED are the three intended.**

**AND THE ZERO IS NOT VACUOUS — A TWO-ARMED CONTROL.** The needle
`Funeral Pyre, Firedraw, Pyre Wake, Emberkeep` — chosen **out of the needle list**, and one
`test_batch_cb` demonstrably asserts — was removed from the shipped document and, separately, from
HEAD's copy. **Arm A moved LOST from 2 to 3. Arm B moved GAINED from 3 to 4.** The sweep bites in
both directions.

**`CLAUDE.md` WAS SWEPT THE SAME WAY: 63 readers, 13,020 literals, 1,126 present, 0 LOST and
0 GAINED.** Three second copies of the corrected figures moved and not one asserted literal did.

### §5c — THE UNMODIFIED GATES WERE RUN AGAINST THE NEW TREE FIRST

**Sixteen targets, individually, before a single one was edited.** `test_batch_cb` read
**1730 / 2** — the two predicted needles and nothing else. Every other one was clean:
`check_cs` 104/0, `check_dk` 64/0, `check_dm` 93/0, `check_do` 131/0, `check_ec` 23/0,
`check_eh` 175/0, `check_el` 23/0, `check_et` 26/0, `check_fe` 78/0, `check_dv` 83/0,
`check_fg` 22/0, `check_ek` 45/0, `check_es` 47/0, `check_ed` 18/0, `check_parse` 179/0,
`check_fr` 25/0.

**`check_ed` WAS RUN AGAINST HEAD'S MANIFEST BEFORE IT WAS REGENERATED**, which is the standing
rule: it read **18 / 1**, naming exactly the six new pins (four in `check_fr.gd`, two re-pointed
in `test_batch_cb.gd`) and nothing else. Regenerated, it reads **18 / 0**.

### §5d — THE TREE WAS FROZEN, AND THE BATTERY

**371 files — tracked AND untracked — md5'd with ABSOLUTE paths** before launch and after exit,
so a moved working directory could not report the tree as drifted and a new untracked file could
not sit outside the population. **ZERO DIFFER.**

**105 targets. THE ONLY RED IS THE SANCTIONED ONE.**

- **`check_fr` — 25 checks / 0 failures**, matching the row written before the run.
- **`check_parse` — 179 / 0**, matching the row written before the run, with the battery manifest
  at **103 with 0 missing** and the RESIDUE down from 5 to 4 (`check_fr.gd` left it, which is the
  half that says it is actually wired in rather than merely present).
- **`test_batch_cb` — 1730 / 0**, at the same check count it had before, so no row moved for it.
- **`check_de` (the count differ) — 430 checks / 0 failures / 0 notices.** Every baseline matched,
  **including both rows this batch wrote.**
- **ZERO TARGETS THREW.** A suite that throws is not a suite that passed.
- **`check_cm_live` 13 / 4 — the one red that is on purpose**, and this batch can prove it did not
  move it rather than arguing the point: **that gate reaches `gate_fixture.gd` and `scripts/`, and
  this batch edited neither.** No `.gd` under `scripts/` and no file under `data/` was touched at
  all. Its four FAIL lines are the four its baseline note records.
- **AND THE DESIGNER'S SAVES SURVIVED IT.** All four files are byte-identical to the FR backup
  after 105 targets.

### §5e — THE FIRST BATTERY WAS KILLED AT 33 OF 149, AND WHY

See §5a(1). The tree was frozen and the run was a third of the way in when the garbled sentence
was found. **A run against text that has to change is not evidence of anything**, so it was killed
by PID — the wrapper first, then the orphaned `test_batch_br` Godot that survived on PPID 1, then
the process table checked and the lock directory removed by hand — the sentence repaired, every
one of the 32 changed regions re-read as flattened prose, the tree re-frozen and the battery
re-run from the start. **Killing at 33 cost about fifteen minutes; finishing would have cost
forty-five and proved nothing.**

---

## §6 — WHAT MOVED

`docs/master.html` (throughout), `CLAUDE.md` (three second copies of the same figures),
`check_fr.gd` (**NEW**), `test_batch_cb.gd` (two needles re-pointed), `run_battery.sh`,
`baselines.json` (two rows — its own, and `check_parse` 178→179), `pin-manifest.json`,
`docs/ways-of-working.md`, `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md`
(rewritten) and this file.

**NOTHING ELSE. No `.gd` under `scripts/`, no file under `data/`, no other gate and no other
baseline row.** Six probe scripts were written, run and deleted before the freeze.

**The designer's four save files were copied to `save-backups/FR-20260909-155944/` and md5-verified
against the originals before any other work**, and re-verified after.
