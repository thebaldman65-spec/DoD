# Batch IU — the claims, and what the ruling needs

**On `class-merge`, after IT (`36b2556`). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `36b2556`, IT's push and local
HEAD, before anything ran (10:08). **The designer's files were backed up first** (`../save-backups/IU-20261024-101003`, 10:10:03,
byte-identical to IT's backup) and read only through copies: `run_save.bin` (55,264 B, md5 `fcb20c91…`) and the clean readout
`run-20261018-194229.jsonl` (24,340 B, md5 `610bcd8c…`) at the open — **the readout still the one run; no newer file has appeared** —
and the same md5s at the close — `run_save.bin` `fcb20c91…`, the profile, the relics and the settings, and all three readout files (the clean run `610bcd8c…`, IH's first, `latest.txt`), each equal to the open's backup; **no newer readout file** at the close (2026-10-24 17:43:34, §9).

**What shipped.** Every one of the 193 claims IU's census read left with a disposition — 169 repaired, 16 true, 3 superseded, 5
standing on a ruling each names — kept as a ledger of record, and two ceilings hold what is left (§1). Every standing rule in
`CLAUDE.md` read against the gate that holds it, one row a rule, kept: 817 rows, HELD 299 / PARTLY 229 / NONE 284 (§2). The nine
constants one under their card hold the card's figure, every `+ 1` at their applies gone, **no magnitude moved** (§3). The bot pays the
player's swap price through one builder, the recorded figures that could depend on it driven and all tied, and every place the bot's
rules differ is a row of a census of record (§4). The two material picks repaired, and five more on targets IU touched, under a
ceiling that does not rise (§5); the manifest's count is a floor (§6); `lane.sh` makes a bare probe (§7); and the routing is a step with
a written output — the pilot's third report (§8). **No player-facing word moved**: 1,324 texts read through their doors are
byte-identical before and after. No save version moved.

**VERDICT: GREEN**

---

## §0 — THE BRIEF's PREMISES, VERIFIED (CLAUDE.md: verify the brief against the repo)

| # | the brief says | verdict |
|---|---|---|
| 1 | `git ls-remote origin class-merge` reads IT's push and local HEAD | **True** — `36b2556` both (10:08, before anything ran). |
| 2 | §0.1: nine constants hold one less than their card, the `+ 1` at the apply | **True** — IT's nine (FOUND AT IT), each read at its apply with `+ 1` (`SLOW_BURN_TURNS` … `MANTLE_HOPS`; §3's table). |
| 3 | §0.2: the player swaps at 10 Mana and 1.0; the bot pays the card's 20 at 3.0 | **True** — `SUMMON_SWAP_COST` 10, `SUMMON_SWAP_DELAY` 1.0; Summon Companion's own `cost` 20, `delay` 3.0; the bot cast `_summon_choice`'s call. |
| 4 | §0.3: 78 MISSES at IT, 20 after its repairs; two material | **True** of IT — and the ceiling IU sets is **13, not 20**: IU repaired seven (the two, and five on targets it touched), §5. |
| 5 | §0.4: the 438 pins are green; the catalogue's 173 had no instrument on one side | **True** — `check_ij` §3 green at HEAD (49 / 0); IT §2's 173. |
| 6 | §0.5: IT read two windows and a grep — 23 blocks whole, 108 not at all, six core blocks outside both; the ad-hoc read missed nine, six routable | **True** (`docs/reports/IT.md` §5). |
| 7 | §1: the population is 113 — HX's 87, IQ's two, IT's 24, plus IS §1's notes | **Mis-added**: IR's *87 stand* already counts IQ's two (HX's 87, less IA §5's and HY §4's two repairs, plus IQ's two — the roadmap's own sum), so 87 + 24 = **111** plus IS's notes. **Derived instead** (§1): 193. |
| 8 | §1a: eleven MEASUREMENT rows (IR03, IR04, IR14–IR20, IR58, IR62) | **True** — all eleven, and eight more of the same shape the recheck found (IR07, IR08, IR10, IR11, IR13, IR22, IR52, IR53, IR57 — nineteen in all). |
| 9 | §1a: two copies outside the references (`baselines.json`'s `check_cm_live` note, IR41; `check_fg.gd`'s header, IR05) | **True** — X41 and X05, both repaired with their originals; a third copy of IR41 stood in `docs/state.md`'s THE REST and is repaired too. |
| 10 | §1a: CR04 — four of its six named banks are display chips since IG §1 | **True** (only `mirror` and `arrows` go through the door); CR04 repaired by population. |
| 11 | §1a: CR12 — five sites store Burn's power since IE §3b | **True**; repaired with its count and reason. |
| 12 | §1a: the Mirror Image bullet — since IR §1g a chosen three spends no image | **True** (XMI); completed. |
| 13 | §1b: `check_hx` already tracks this family | **True** — §1d(a)'s *LIVE CLAIM IN A DEAD NAME*, for the two references. |
| 14 | §2: HO §0 was NONE; `check_it` §2c makes it PARTLY (its arm missed 53 of IT's 162) | **True** — IU's census rows HO §0's rule PARTLY to `check_it` §2c, and found one standing breach no arm sees (`battle.gd`'s Faith comment, FOUND AT IU). |
| 15 | §6: IT's manifest fell 1,924 → 1,881 and came back at 1,947 | **True** (IT's report; 1,947 at HEAD). |
| 16 | §7: IT ran Godot directly and made *IT const probe* | **True** — the one folder outside every spent pattern bar *[unnamed project]* (2026-07-02). |
| 17 | §8: IT's upkeep was fourteen of 134 | **True** (`docs/state.md`'s WHERE at IT). |
| 18 | §10: the Chilled row keeps its *4* (a `BattleUnit` constant under the cycle) | **True** — kept; `check_it` §2 pins it. |

## §0 — THE RULINGS, AND WHERE EACH IS WRITTEN

`check_iu` §0 pins each by its own words, never its provenance, in the file whose subject it binds:
- **§0.1** — *A CONSTANT A TEXT READS HOLDS THE FIGURE THE TEXT STATES*; *every `+ 1` between a constant and its text is a second copy
  of one rule*: `CLAUDE.md`, beside IT §2a's naming rule in the text standard.
- **§0.2** — *THE BOT MAY PLAY WORSE THAN A PLAYER. IT MAY NOT PLAY BY DIFFERENT RULES*: `CLAUDE.md`, in IL §3's block, after IN §3's
  price-at-the-door sentence.
- **§0.3** — *the census's MISSES count is a ceiling that does not rise*, and *a batch that touches a target carrying a MISSES row
  repairs that row*: `docs/instrument-rules.md`, under `check_gw`'s ceiling rule (GW §2's block), the same instrument.
- **§0.4** — *a figure a batch re-tunes gets a constant then*: `CLAUDE.md`, on IJ §2's own bullet.
- **§0.5** — *the index does not bound the read; it makes the bounding correct*, and *the routing is a step with a written output*:
  `docs/state.md`'s index section, where a batch meets the routing.
- **§1b, §6, §7** — the claims ratchet (HY §6's count block), the manifest's floor (FH §2's manifest block), the bare probe (IQ §7's
  lane block): `docs/instrument-rules.md`.

## §1 — THE CLAIMS: EVERY ONE GETS A DISPOSITION

**THE POPULATION, DERIVED** (the ledger of record, docs/reports/IU-claims.tsv, one row a claim, its population named):

| population | rows |
|---|---|
| IR's recount of HX's standing claims — the instrument file (IR01–IR70, IR74) | 71 |
| the same — the combat file (CR01–CR20) | 20 |
| IQ's two (the starter-rung block, the relic block's read sites) | 2 |
| IT's 24 — the strike's 22 SUPERSEDED and DONE items, and items 6 and 10 | 24 |
| IS §1's readers' notes on `CLAUDE.md`'s stale claims (ISN01–25) | 25 |
| FOUND AT IS's list of the same (ISF01–13) | 13 |
| the census's own, found reading every claim in `CLAUDE.md` (S1–S4) | 34 |
| copies and completions outside the references (X05, X41, X864, XMI) | 4 |
| **total** | **193** |

IR's 91 rows are HX's 87 and four intent rows of HX's census outside its count; two of the 91 were repaired before IU (IR06 by
IA §5, CR01 by the tree at HY §4) and were read again like every other row.

**THE DISPOSITIONS**: **REPAIRED 169** — 152 by the census's exact edit, three by the lead's own (IT72, IT73, IT77, below), three made
true by the instrument (S1-C02 and S1-C03, `check_cs`'s Long Draw section labelled §7; S4-C03, `suite_fixture.gd`'s Mage floors raised
to the reading), and eleven that were one sentence with another row's and repaired by its edit. **TRUE 16** — eight found true at the code,
X864 true by its scope, IR06 and CR01 repaired earlier, ISN13 struck at IT, and four the lead kept as records (IT22, GC's supersession
record; IT31 and IT32, DO's ruling below its head note; S3-C09 with them). **SUPERSEDED 3** — S2-C01 by IQ2, IQ1 by S2-C05, ISF04 by
IR33. **STANDS 5** — each on a ruling (IU's RULINGS OWED, 1): ISN04 and ISF12 (GK's spine-rune names), IR01, IR09 and IR50.

**By §1a's kinds**, the repairs: FALSE 84, MEASUREMENT 34 (the past tense with its batch named — `check_iu` §1a asserts a batch is
cited in the repair or the sentences just before it), GONE-SUBJECT 23 (the sentence goes, or — where FX's list keeps a deleted
node's collision as its citation — the past tense: IT72, IT73, IT77, the one deliberate departure from §1a's *the sentence goes*),
COUNT-GREW 9, INCOMPLETE 8, POPULATION 5, COPY 3, DECISION 3 (S4-C03's taken by the instrument; S1-C02/C03's).

**THE LEAD's DECISIONS OVER THE CENSUS's REPAIRS** (each in the ledger's `note`): S1-C02/C03 made true by labelling the gate, not by
editing four citations of it; S2-C01 taken through IQ2's repair (a population, no count to go stale); IQ1 through S2-C05's (it names
rung 1 the practical door with EN's measurement); ISF04 through IR33's; IT22, IT31, IT32 and S3-C09 kept as the records their
blocks keep them as; and **ISF02 taken after all** — the Faith heading's rule text is a row of `check_hx` §1c's known blocks, and the
census had it wait on the batch that re-points that row; IU touched `check_hx` for §1b, so the row was re-pointed in it.

**THE CHECK AGAINST THE CODE, NOT AGAINST A READER's CALL** (§1a's last paragraph): IT's 24 were each read against the code — 15
repaired, 9 true (seven at the code, two kept as the record their block keeps) — and none was struck on a neighbouring finding.

**WHAT THE CENSUS's REPAIRS MET THAT THE MANIFEST COULD NOT** — the census checked every repair against the manifest's needles and
the gates' literals and found one pinned (ISF02). The pre-run found a second: `check_it` §1 holds IT's strike seam at item 17 by
the starter-rung blockquote's last words, a needle in a gate's table, which the manifest cannot see. S2-C06's repair is the true
sentence, so the seam's needle follows it.

**OUTSIDE THE POPULATION, AND NAMED** — seven stale claims on record in `docs/state.md`'s FOUND AT items that no census row carried,
met at IU's routing and its close-read: FOUND AT HV's two `CLAUDE.md` lines, HY's *HD §2's four*, GA's EU reading, GF's Resonance half,
FW's *four death-refusals* and GR's ways-of-working header. Each stays where it is recorded (FOUND AT IU names them together). **And
the copies IU's repairs left in comments** — `check_ec.gd`'s header, `check_ea.gd`'s, `run_battery.sh`'s `check_de` comment,
`gate_fixture.gd`'s window note, `test_batch_bi.gd`'s, `check_fo.gd`'s Overkill note, `check_gs.gd`'s *PROPOSED at HL §1*, three
`battle.gd` comments — each an asserted surface, repaired with its subject.

### §1b — THE RATCHET: WHAT IT COST AND WHAT IT CAN HOLD

**TWO CEILINGS.** `check_iu` §1 holds the ledger: a repaired claim's false words do not stand again in their file (C01), a measurement
does not return to the present tense (C02), every standing claim names its ruling, and the claims left standing are a ceiling of 5.
**`check_hx` §1d reads every backticked name in all four rule files** — the two references since HX, `CLAUDE.md` (1,061 names) and
the ways of working (18) since IU — and every name that lives only in a gate's string or resolves nowhere carries a line with its
reading and **its mention count**, so a known dead name written into a new sentence is a new claim nobody has read. §1d(c) counts the
mentions that stand unread or read as a live claim against **a ceiling of zero**: IU repaired the last one (`wd_tank_spank`'s
sentence, CR19). A sentence whose claim is an ABSENCE (`DOD_SIM_MAP` … *`scripts/` names none of them*) reds the day the name appears.

**COST**: one reading of the 60 dead names in the four files (52 in `CLAUDE.md`; 75 mentions), check_hx's run 32 s, and **a line in
`check_hx` for each dead name a later sentence writes** — paid at once, by IU's own instrument-rules text (`iu_disposition`, read as
a KEY). **WHAT IT CAN HOLD**: the dead-name shape alone. A false count, a wrong figure, a false sentence about a live name, or a dead
name in plain prose is not mechanically visible, and stays HY §6's re-read's to find; and a reading is a judgement the gate records,
never one it checks. **And touching `check_hx` bound IU to §0.3's rule**: its three MISSES rows were repaired in the same edit (§5).

## §2 — EVERY STANDING RULE IN `CLAUDE.md` AGAINST THE GATE THAT HOLDS IT

**One row a rule, kept as the census of record** (docs/reports/IU-rules-census.tsv, every row its tree — HEAD `36b2556`; two re-read
at IU): **817 rules over `CLAUDE.md`'s 120 blocks** — each block named by `check_hx` §1c's own key, so the population is that gate's,
not a second list.

| verdict | rules | of them a gate could cheaply hold |
|---|---|---|
| HELD | 299 | — |
| PARTLY | 229 | 112 |
| NONE | 284 | 76 |
| not a rule (a struck heading, a pointer) | 5 | — |

**THE MODEL ROW** — HO §0's *comments do not name a magnitude a constant holds* reads PARTLY to `check_it` §2c, as the brief says, and
the census found its next breach standing where no arm looks (`battle.gd`'s comment over Faith's mitigation speaks the threshold as
five; FOUND AT IU).

**WHAT THE CENSUS DECIDES**: *a rule with a gate is a reference and can be routed around; a rule with none must be read, so its block
is core.* **112 of the 120 blocks hold at least one NONE or PARTLY rule; 8 are wholly HELD.** By the census's own rule nearly the whole
of `CLAUDE.md` is core — which is the answer to whether it is indexed at all, and the ruling is the designer's after the pilot's
fourth report (IU's RULINGS OWED, 2). **Nothing was struck.**

**THE LIST TO WORK THROUGH**: 188 rules no gate fully holds that a gate could cheaply hold — each row's `cheap` column says how (one
`contains`, a sweep, a driven arm). **Two rows were re-read at IU**: S1-019, whose gate IU widened (its needle follows `check_hx`'s new
wording), and S4-171, HELD → PARTLY — the close-read found FOUND AT GL's Quick Shot advertising a Perfect only a Lethal Aim holder
reaches, which `test_batch_bo` §5 passes because it asks `runs_skill_check()` where the cast path grades slot 0.

**WHAT THE READERS FOUND, IN PASSING** (FOUND AT IU): a rule and its own gate that contradict (the strike-loop rule and `check_ft` §6c —
IU's RULINGS OWED, 4); rules the code breaks at HEAD (*do not write `12 * 8` again*, *the ledger books what left the bar*, HO §0's
Faith comment, and a possible breach of the contagion reservation); and gates that hold less than their rule cites them for
(`check_cs` §5's own bot roll, `check_cz` §3's 14 of 18 heals, `check_cl_width` reporting only, `check_co`'s `MUST_NOT_GATE`,
`check_if` §1b on the free clock, and five more).

## §3 — THE NINE CONSTANTS

**EACH CHECKED FOR A SECOND READER FIRST**, on the comment-stripped game scripts: every read is the handler's apply, its recast
table's row where it has one, and the card's door — and every one wants the card's figure. **So all nine were re-valued and none
renamed.**

| constant | card | HEAD → IU | reads (apply, recast row, door) |
|---|---|---|---|
| `SLOW_BURN_TURNS` | Slow Burn | 3 → 4 | handler, recast row, card |
| `HOARFROST_TURNS` | Hoarfrost Armor | 3 → 4 | handler, recast row, card |
| `FROSTBIND_TURNS` | Frostbind | 3 → 4 | handler, card |
| `RESONANT_FIELD_TURNS` | Resonant Field | 3 → 4 | handler, recast row, card |
| `EMBERKEEP_TURNS` | Emberkeep | 3 → 4 | handler, recast row, card |
| `PRECISION_GRANT_TURNS` | Precision Strike (Good) | 3 → 4 | handler, card (two rows) |
| `PRECISION_PERFECT_GRANT_TURNS` | Precision Strike (Perfect) | 4 → 5 | handler, card |
| `BERSERK_STRIKES` | Berserk | 3 → 4 | handler, card |
| `MANTLE_HOPS` | Mantle | 2 → 3 | handler, the recast rider (its card says *three times*, a word) |

Every `+ 1` at an apply, a recast row and the Mantle rider is gone; the eight cards that state a number read it through
`{=Battle.X}`; `check_iq` §2f's eight doors read the constant bare; each declaration comment names its card, never its figure
(`check_it` §2c). **NO MAGNITUDE MOVED, MEASURED**: every player-facing text dumped through its door on both trees — **1,324 texts,
byte-identical** — and `check_iu` §3 drives each cast on a fresh board and reads the applied figure against the constant (9 of 9).
**The text proof's population is every reader**: no game script reads a raw description dictionary; the width gates read the resolved
Ability text. **R01** re-tuned `SLOW_BURN_TURNS` 4 → 5 in a clone and dumped every text again: **one of 1,324 moved — Slow Burn's own card**, and nothing else.

## §4 — THE BOT's SWAP PRICE

**THE FIX**: `battle._swap_choice(u, call)` is the one builder of a swap — `SUMMON_SWAP_COST` at `SUMMON_SWAP_DELAY`, no cooldown of
its own (the shared one `_do_summon` sets) — and the player's picker and the bot at capacity both build through it. A companion that
cannot be called cannot be swapped in either.

**1. WHAT COULD DEPEND ON IT, DERIVED.** A swap happens only where a Hunter fields a companion at capacity: on HEAD the default party's
talented Beastmaster swapped 0 times in rung-1 runs, a Survivalist 23.4 a run (untalented 19.4, Ruin 21.8), an untalented Beastmaster
2.8–7. **So the recorded figures that could move** are those taken from runs with a swapping Hunter: IE's and IF's dry shares (THE
CLERIC's MANA RATE: per class, its lineages pooled, untalented, with the Hourglass, and on the default build), the Hourglass's Hunter
(TO WATCH IN PLAY: 36.0% → 20.9%), the Sanctity figures (SANCTITY's STEP), and completion. The bargain grades were taken on the
default build, where the swap path barely fires; read anyway.

**2. DRIVEN AGAINST THE UNCHANGED TREE** (HEAD with a probe, against HEAD with the fix and the same probe; a run the unit, paired by
seed). **Pooled per build over the twelve lineages — the population the records were taken over — 60 runs a side each: every figure
a tie.**

| build | dry Hunter | dry Cleric | dry Mage | completed |
|---|---|---|---|---|
| untalented | 39.69 → 39.33 (0.17) | 32.84 → 33.32 (0.20) | 21.38 → 22.84 (0.37) | 51.7 → 60.0 (0.91) |
| untalented, Hourglass held | 22.79 → 21.76 (0.55) | 14.36 → 16.06 (1.25) | 12.99 → 15.23 (0.63) | 76.7 → 78.3 (0.22) |
| default build | 5.40 → 5.52 (0.12) | 4.07 → 4.00 (0.09) | 3.67 → 3.45 (0.20) | 100 → 100 |

(|d|/se in brackets.) Per party, 100 comparisons of which 70 are live (the Sharpshooter parties dismiss the pet, so their arms are
identical by construction): two cross 2 SE — one party's Hourglass Cleric dry share (2.51) and the default party's swaps on Ruin
(2.21) — about the three chance alone gives at 70, and neither is a recorded figure's population. The first drive's targeted parties
(a Survivalist untalented: swaps, dry Hunter and Cleric, fights each moved; on the default build only Sanctity's steps, 2.14) are a
party chosen for its swaps, not a record's. **3. SO NOTHING IS RE-TAKEN** — the derivation and the drive are the report. *The levels
are HEAD's: IE's 26.8 / 18.3 / 33.8 were taken on IE's tree and carry their batch.*

**AND IT MOVES ONE LIVE WALK**: `check_gp`'s seeded road is the same line for line through the Hunter's first swap, which costs 1.0
since IU, so he acts sooner and the walk takes another road — 439 → 440, attributed by HEAD's run beside IU's.

**THE DIVERGENCE CENSUS, KEPT** (docs/reports/IU-bot-divergence.tsv, one row a place the bot's game differs): **33 rows — RULE 12,
POLICY 14, MODEL 5, CLOSED 2.** Two RULE rows are this batch's (DV01 the price, DV02 the cooldown and the Long Silence key — both
closed by the one builder); **ten are defects, owed** (FOUND AT IU: DV05, DV06, DV07, DV11, DV24, DV25, DV26, DV27, DV29, DV32). Every
POLICY carries its reason — DV13's, Called Shot's spot, was written nowhere and the census row holds it now; the ally pools are
POLICY (DV03, IS §4's reason). The close-read added `DOD_SIM_GRANT_ALL` to DV32 (an experiment arm read with no `sim_run` gate, like
`DOD_SIM_RUNES`), and the census's line references into `docs/state.md` name their blocks now. `check_iu` §4b holds the census: every
RULE repaired or owed and named in `docs/state.md`, every POLICY its reason.

## §5 — THE TWO MATERIAL PICKS, AND THE RATCHET

**The two, repaired and verified by breaking their subject** (IT's C06b): `test_batch_be` §4 cuts the Break arm by its own block and
asserts it read that arm alone; `test_batch_bv` §3 picks the Lethal Aim block by its own head (the strike's Focus block) and asks
*outside* of its extent. C07 broke each subject under the repaired suite and under HEAD's (§11).

**FIVE MORE, BECAUSE IU TOUCHED THEIR TARGETS** — the rule IU writes, applied to IU: `test_batch_bv` §1's and `test_batch_ce` §1's
tranche reads (each cut at the next tranche's banner and asserted found), and `check_hx`'s three — §1b's shingles keyed to every index
rather than the first (the combat-scope run read whole: 32 words, not 26 + 13), §1b's provenance cut to the parenthesis alone (DM §3's
*RULE ON CLAUSES, NOT ON ABILITIES* compared at last), and §1d's `.txt` a path with assets found by name (`OFL.txt` read as a file).

**THE CEILING IS 13, NOT THE BRIEF's 20**: 20 reported at IT, 7 repaired here. Each standing row carries `STANDING #` and the first
six hex of its target's md5, so the batch that touches the file finds its own row, and `check_iu` §5 reds a touched target whose row
still stands; a repaired row's target names `IU §5` in its source. Written under `check_gw`'s ceiling rule.

## §6 — THE MANIFEST's PIN COUNT IS A FLOOR

`build_pin_manifest.py` writes the count it built as the manifest's `floor`; a rise re-records it, **a fall keeps the floor** and is
recorded only with `--fall "<code>: <why>"` (its batch and its reason in `falls`). `check_iu` §6 reds a count below the floor and a fall
with no batch or reason (C08). **1,947 at IT → 1,987 at IU**: `test_batch_be` +3, `test_batch_bv` +1, `check_iu` +36. **And the
discipline under it**: `check_iu`'s helper takes the full `res://` path at each call, so the builder binds every holder where it is
declared — its 36 pins are in the manifest because of it.

## §7 — `lane.sh` LEARNS A BARE PROBE

`./lane.sh probe <dir> <name> [<file>...]` builds a scratch project holding no file of the game's — a file that lives in the
repository is refused, and so is a copy of a tracked one, by content (`git hash-object` against the index) — names it `DoD probe
<name>`, inside the clearing command's `DoD *` pattern, and records what it made in `.lane`. `./lane.sh spent` prints the one clearing
command off the driver's pattern list; `./lane.sh strays` lists the folders no pattern holds. `check_iu` §7 drives the three answers
and reds on a stray nobody named (C09). **One probe was launched this way** (*DoD probe IU smoke*, 10:54), and the rule's own words are
unchanged.

## §8 — THE PILOT's THIRD REPORT, AND THE ROUTING IS A STEP

**The routing of record is docs/reports/IU-routing.md — written before the work**: the brief's thirteen subjects, the 34 rows whose
triggers named them (each trigger verbatim), and the 15-block core; that list and the core opened whole (49 blocks, 133,491 B of the
file's 327,579).

- **OPENED**: the 49, and outside the list four blocks, each with what led there — three cited by IU's census readers (FOUND AT IN for
  DV30, THE SUITE REDS for IR09, GK's RULINGS OWED through its row for ISN04) and one the lead opened off its row's trigger (FOUND AT
  GE, *check_cs 7*). **Data, not failures.**
- **NEEDED**: the core blocks the work changed or read figures from, the fourteen FOUND AT blocks the claims closed items in, THE
  REST, the bot-census sources, and two instrument blocks (the record lists each with why).
- **FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED — 30 of the 85**, read whole by a reader outside the working read:
  **8 strong, 22 weak; 21 ROUTED, 5 NOT ROUTED, 4 SPLIT.** Every NOT ROUTED row and each split's unrouted half got the trigger that
  would have routed it. **Why most read ROUTED**: the brief's *the claims* and *every rule* are populations, not subjects, and no
  trigger list names a population by word — the routing met that, not a missing trigger. Three of the strong were IU's own to act on,
  and it did: FOUND AT GR's first item and GF's Ruin half were closed by IU's ledger and archived; LIVE COUNTS' *`EMBERKEEP_TURNS + 1`*
  was falsified by IU §3 and repaired; S4-171 moved to PARTLY.
- **THE UPKEEP**: **30 of the index's 135 entries touched — 27 by hand** (one written, the core's RULINGS OWED re-pointed, fourteen
  mended because IU changed their blocks, eleven given the trigger the close-read found missing) **and three re-stamped only. IT's was
  14 of 134.** Two figures make a rate, and IU's is larger for a reason IT's did not have: a claims batch touches FOUND AT items across
  the file by construction, and this one paid its close-read's misses in rows.

**FROM HERE THE ROUTING IS A STEP**: the index section says so, and `check_iu` §8 holds the last batch's record to its shape — the
subjects, a matched list whose length its heading states, the core, the three lists with ROUTED or NOT ROUTED on every miss, and the
upkeep as a rate. **THE KNOWN LIMIT, RESTATED**: every batch of this pilot is read by a reader that already carries the project's
practices, so a reader who does not know a practice has no instance, and more batches of the same reader will not make one.

## §9 — HOUSEKEEPING

- **THE MOVE IS NOT ATTEMPTED** (IB §4). **IP's one command, its patterns read at the close**: 604 user-data folders, 271,288 KiB (603 and 261,776 KiB at the open — IU kept one new folder, *DoD probe IU smoke*, inside `DoD *`, and moved C09's to the Trash). The three spent patterns match 470, 125 and 6, so none is dropped from the paste; *IT const probe* is carried by name; *[unnamed project]* (2026-07-02) is left. `./lane.sh spent` prints the patterns' half; the whole command, for the designer to run at will:

  ```
  mkdir -p "$HOME/.Trash/DoD spent user-data folders" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv Dawn\ of\ Decay\ [F-H]?\ * Dawn\ of\ Decay\ I[A-J]\ * DoD\ * "IT const probe" "$HOME/.Trash/DoD spent user-data folders/"
  ```
- **`lane.sh` for every launch** — every lane, probe, recon and control ran through it, but one: C09, which launches around the driver
  on purpose to prove §7's arm sees it, and whose folder was moved to the Trash by name at once.
- **The designer's files**, backed up first and read only through copies; the same md5s at the close — `run_save.bin` `fcb20c91…`, the profile, the relics and the settings, and all three readout files (the clean run `610bcd8c…`, IH's first, `latest.txt`), each equal to the open's backup; **no newer readout file**.
- **THE MACHINE REBOOTED MID-BATCH** (~11:10) and `/private/tmp` was emptied — the scratchpad, every lane, four census tables, the swap
  A/B's first logs and IT's old tools. The repository was untouched. From there every edit lived as a replayable script outside the
  repository (`../save-backups/IU-work/edits/`), and the final tree is rebuilt from HEAD by one script; the first A/B was re-run
  (§4), and the lost tools were rebuilt (the literal sweep, the text dump).
- **The close's own timestamp: 2026-10-24 17:43:34.**

## §10 — WHAT IS DELIBERATELY NOT DONE

As the brief's §10: no ceiling restated; the index neither extended nor reverted; `CLAUDE.md` not indexed and nothing struck; the 438
pinned; the thirteen standing picks not repaired (the ceiling holds them); `check_it` §2c's arm not widened (the Faith comment it
misses is FOUND AT IU, the third note's pattern); the Chilled row's *4*; `check_hn` §2a's worn arm; the latent floor shapes and the
Cryomancer's route; the ally pools (POLICY, DV03); nothing of the playthrough or the deck's middle, and no grade, count or band moved —
§4's drive showed nothing beyond its noise; and the standing list unchanged. **And the ten bot RULE defects are recorded, not fixed** —
the census was asked to find and sort them.

## FOUND AT IU AND NOT FIXED

In `docs/state.md`: the ten RULE defects (§4); the rules the code breaks and the gates that hold less (§2); the seven stale claims
outside the population and the comment copies of repaired ones (§1).

## NEEDS A RULING

In `docs/state.md`, IU's RULINGS OWED: **1.** the five standing claims; **2.** the index ruling, with §2's derivation; **3.** the ten bot
defects — a batch, or each as its code is touched; **4.** the strike-loop rule against `check_ft` §6c.

## §11 — VERIFICATION

**THE PUSH CHECK.** `git ls-remote origin class-merge` read `36b2556` — IT's push — equal to local HEAD, at 10:08, before anything ran.

**THE PARSE FLOOR.** Every `check_parse` run was read off stderr — `Parse Error` grepped, never a tally and never the exit code — and
every log was grepped for `Parse Error` and `SCRIPT ERROR`. **It caught one, IU's own**: the pre-run's first `check_iu` read
`Parse Error: There is already a variable named "at" declared in this scope` (§8); renamed before any battery. Recon 1, recon 2, every
control and the acceptance read none.

**WHAT WENT IN BEFORE WHICH RUN.** **§8's routing, written, first** (10:2x: the 34 matched rows and the core, before any edit); **§1's
and §2's reads, read-only and together** (10:5x: six readers on a HEAD snapshot — four slices of `CLAUDE.md` for rules and claims, the
references' claims, the bot's divergence); then the code — §3's nine, §4's builder, §5's picks, §6's floor, §7's probe — and its parse,
in lanes; **§4's drive against the unchanged tree, on its own** (10:3x and 11:20–11:47); **the literal sweep over the code before recon
1's prediction**; **recon 1**; then every document, built as scratch copies by script and landed behind a hash guard; `check_iu` into
the battery, the baselines rows, the manifest regenerated; **the pre-run, the document sweep, recon 2, the positional re-run, the
controls, the `ok()` traces, the acceptance.** **THE MACHINE REBOOTED at ~11:10** and emptied `/private/tmp`: from there every edit
was a script in `../save-backups/IU-work/edits/`, and the final tree is one replay from HEAD (`rebuild_final.sh`).

**THE TEXT PROOF, EVERY READER.** Every player-facing text read through the door a surface reads it by (`it_dump_texts.gd`: every
card's words and Perfect, every rune, glossary entry, core rune's rule, passive, talent, relic, status row and run table), HEAD's tree
against IU's final one: **1,324 texts, 0 differ.** No game script reads a raw description; the width gates read the resolved text.
**R01** — `SLOW_BURN_TURNS` re-tuned 4 → 5 in a clone, every text dumped again: **one of 1,324 moved, `card|Slow Burn|desc` (*for 4
turns* → *for 5 turns*) — that card's own, and nothing else.**

**THE LITERAL SWEEPS** (rebuilt at IU: every string literal the instruments hold, ≥ 4 characters, counted raw and flattened in each
edited file on both trees). **Over the code, before recon 1's prediction**: four LOST — `ps_turns + 1` (`check_iu`'s own absence),
*holds 5 turns* and *4 STRIKES* (`check_ij` and `check_iq` read the resolved card and the catalogue, both byte-identical), `substr(` in
`test_batch_be` (`check_ec`'s document-holder test) — none a red. **It could not see a pin scoped to a function**, and recon 1 found
two (below). **Over the documents, before recon 2**: 43 LOST, 114 GAINED (self-hits and `check_iu`'s own excluded) — common words,
table entries and deleted node names in sentences IU repaired; more than 40 holders read those files, so recon 2 was their pre-run.

**RECON 1 — the battery on IU's code with HEAD's documents** (12:05:31 → 13:31:44, 160 targets). **The prediction, written before the
launch**: `check_hx` 39 → 42 with three reds from HEAD's `CLAUDE.md` under the widened walk (one unresolved name IU's S3-C02 removes, two
unread dead names, the ceiling); four rising counts (`be` 28, `bv` 531, `ce` 932, `check_parse` 237); `check_ed` 18 / 0 and the
manifest 1,987; the gates of gates silent on `check_iu`. **Read**: every predicted line, and three the prediction missed — **`check_ec`
§2** (10 reds: the manifest's DOCUMENT half reading `check_iu`'s nine needles against HEAD's documents — the prediction named
`check_ed`, which reads source pins only; cleared when the documents landed), and **`check_ij` §3 and `check_it` §2** (one and two:
a pin scoped to a function — the swap's *+1 Loyalty* and its price line named `_open_summon_picker`, and IU built them in
`_swap_choice`; re-pointed). `check_gp` rose 439 → 440 with no red — attributed by HEAD's run beside IU's: the roads are line for line
the same through the Hunter's first swap, which costs 1.0 since IU, so the walk takes another road. Sanctioned reds as HEAD's.

**THE PRE-RUN** (the final tree, rebuilt from HEAD by script): it found four reds, all IU's own, each repaired before recon 2 —
`check_iu` §8's duplicate name and its heading pattern stopping at a heading's own backtick; X41's baselines note not yet applied
(`check_iu` §1 caught the false words — the arm working); `check_hx` §1d(a) on `iu_disposition`, backticked in IU's own
instrument-rules text (**the ratchet firing on its author** — read as a KEY); and `check_it` §1 at IT's strike seam for item 17,
whose join S2-C06's repair rewrote (a needle in a gate's table, invisible to the manifest; re-pointed to the true sentence).

**RECON 2 — the final tree, frozen** (14:41:50 → 16:07:53, 160 targets): **exactly as predicted.** The only reds are the two
sanctioned (`check_cm_live` 13 / 5, inside its 4–5 band; `check_gj` 70 / 1); `check_iu` 185 / 0; `check_de` 661 / 0 with no notices;
the harness 22 / 382 / 8. The tree's md5s the same after as before.

**THE POSITIONAL AND SUPERLATIVE RE-RUN, BEFORE RECON 2's VERDICT** (IT's census re-derived on IU's final tree by a reader; the kept
table is in IU's work folder): 489 reads — **123 unchanged by construction** (the gate and every file it reads byte-identical), **366
re-derived: 184 SAME, 175 LINE-SHIFT, 7 ELSEWHERE. 0 went from ASKS to MISSES**; the 7 that went from MISSES to ASKS are exactly IU's
seven repairs, each landing on its subject on both readings, and the other 13 MISSES stand where they stood. One window grew without
moving: IJ §2's figure-rule window now also spans IU's §0.4 lines, written inside that bullet — its arm checks door names, which the
added lines do not name. **IU's text repairs moved no read off its subject.**

**THE MANIFEST AND `check_ed`.** 1,947 → **1,987** (`test_batch_be` +3, `test_batch_bv` +1, `check_iu` +36 — `check_iu`'s holders bound
by their paths, §6's discipline); the floor recorded at 1,987, no fall. `check_ed` 18 / 0.

**THE CONTROLS** — one fresh clone of the final tree each, the anchor asserted once before the edit, read by its FAIL text:

| | the break | the arm that red, in its own words |
|---|---|---|
| C01 | CR14's false words put back in the combat file | `check_iu` §1: *1 repaired claims' false words stand in their file again — [CR14]* |
| C02 | IR03's measurement back in the present tense | §1a: *1 measurements stand in the present tense again — [IR03]* |
| C03 | a new sentence about the deleted `Talents.can_learn` in `CLAUDE.md` | `check_hx` §1d(c): *1 mention(s) of a dead name stand as a live claim … over the ceiling of 0 — CLAUDE.md::can_learn ×1* |
| C04 | S1-003 (README's rule, NONE) given `check_hx` §2 | §2: *1 rows say a gate holds the rule and that gate's source does not hold the row's needle — [S1-003 → check_hx.gd]* |
| C05 | Slow Burn's apply given its `+ 1` back | §3, **the drive**: *Slow Burn's cast applied 5 where SLOW_BURN_TURNS holds 4 — a magnitude the constant does not hold*; and the `+ 1` arm |
| C06 | the bot casting the call again at capacity | §4: *the bot at capacity does not swap through `_swap_choice` — it is casting a call at the card's price*; and the drive |
| C07a | the Break arm's own `return` deleted | `test_batch_be` §4: *Break points removed are banked to faith_break_cut and go no further* — **and HEAD's suite on the same break: 27 / 0, the miss** |
| C07b | the Crossfire arm moved inside the real Lethal Aim block | `test_batch_bv` §3: *and it is outside that block rather than merely before it* — **HEAD's suite: green, the miss** |
| C08 | one pin dropped from the manifest, its own total kept consistent | §6: *THE PIN COUNT FELL — 1986 pins against its floor of 1987, and no fall names its batch and its reason* |
| C09 | a project launched with Godot directly, around `lane.sh` | §7: *a user-data folder no spent pattern holds and nobody named — a launch went around lane.sh: [IU C09 stray]* (its 4 KiB folder moved to the Trash by name) |
| C10 | the routed list deleted from the routing record | §8: *the matched list holds 0 rows against the 34 its heading states — the routed list is the batch's first output* |
| H01 | HEAD's code under the final gate | 183 / 52 — §3 (34, the first *Slow Burn's card text does not read SLOW_BURN_TURNS through its door*), §4 (6), §7 (6), §2 (3: HEAD's `check_hx`, its known blocks and its wording), §6 (2), §5 (1) |
| H02 | HEAD's documents under the final gate | 143 / 25 — §0's eleven rulings (the first *CLAUDE.md does not carry the nine's ruling*), the ledger, the census and the divergence table not in the tree (§1, §2, §4b), §5 (no `iu_disposition`), §8 (no routing record) |
| R01 | a re-tune at one of the nine, every text dumped | one text moved: Slow Burn's own card |
| Rhx1 | `check_hx`'s known line for the combat-scope run deleted | red on the run read whole, *(32 words)*; HEAD's gate on the same edit: *(26 words)* — the split |
| Rhx2 | the ways of working given a heading *RULE ON CLAUSES, NOT ON ABILITIES* | red: the shared statement; HEAD's gate silent on it — the cut that dropped the clause |
| Rhx3 | `assets/fonts/OFL.txt` removed | red: *`OFL.txt` resolves nowhere*; HEAD's gate silent on it — read by its extension |

**THE `ok()` TRACES** (every assertion printed, HEAD's tree against IU's): `check_hx` 39 → 42 = §1d's three new arms (the ceiling, the
walk's floor, the ABSENCE arm), four messages reworded *references* → *rule files*; `test_batch_be` +1, `bv` +2, `ce` +1 = each repaired
read's *the slice read is its subject* arm; `check_parse` +1 = `check_iu.gd`; `check_gp` +1 = its road (above). **No other count moved**
(recon 2's `check_de`: no notice).

**THE TWO READINGS, BOTH FILES** (IQ's method — the net, anything cut to the archive, fenced structure stated apart):
- **`CLAUDE.md`** 484,879 → **486,160 B, +1,281** = the claims' repairs −662 and IU's three rulings +1,943; **nothing cut**, no fence.
  474.77 KiB against its 510 KiB ceiling, 35.23 KiB under.
- **`docs/state.md`** 327,579 → **326,275 B, −1,304 net**; **15,227 B cut to the archive** (the closed items word for word, with the
  cut's heading), so **IU wrote +13,923 B** — of it **+1,751 inside the index fence** (`INDEX (IS §5)`: the routing paragraph and the
  row mends; structure) and **+12,172 outside** (WHERE, IU's RULINGS OWED, FOUND AT IU, the live halves of cut items). The record stays
  ES's. 318.63 KiB against 380, 61.37 KiB under.
- The references: `docs/instrument-rules.md` +5,388 B (the claims' repairs and four rulings), `docs/combat-rules.md` +1,146 B.

**THE ACCEPTANCE** — `./run_battery.sh` in the repository, as the live project (16:17:23 → 17:43:09): **160 targets, exactly as recon 2.** The only reds are the two sanctioned (`check_cm_live` 13 / 5, inside its band; `check_gj` 70 / 1); `check_iu` 185 / 0, `check_hx` 42 / 0, `check_parse` 237 / 0, `check_gp` 440 / 0; `check_de` 661 / 0 with no notices; the harness 22 / 382 / 8. No `Parse Error`, no `SCRIPT ERROR`. **The repository's md5s the same after the run as before it** (532 files), and the player's files equal to the open's backup before it and after.

**THE CLOSE** (2026-10-24 17:43:34): the player's four files and the three readout files md5-identical to the open's backup, and no newer readout file; 604 user-data folders (§9); **this report is the one file written after the run** — read by no gate — and nothing else moved after it.
