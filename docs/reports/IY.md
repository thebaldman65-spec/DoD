# Batch IY — the instrument sharpened, and nine handles turned

**On `class-merge`, after IX (`fa24c3b`). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `fa24c3b`, IX's push and local
HEAD, before anything ran (2026-10-26 11:52). **The designer's files were backed up first** (`../save-backups/IY-20261026-115230`,
11:52:30, byte-identical to IX's backup by `diff -r`) and read only through copies — md5s at the open and the close, §6.

**What shipped.** **The sim seeds a fight, not only a run** — `DOD_SIM_FIGHT_SEED` reseeds the dice at every node a walk steps onto
and at every won fight's spoils, off the run's own seed; verified on its own before anything else was built: Encumbered's paired
error fell to 0.554 of the unpaired (IX's run seeding: 0.941) and both re-read costs tie with IX's (§1). **The reach test** drove
Frenzied and Hoarfrost at an extreme: Frenzied has no reach at three times every unit's speed, Hoarfrost reaches a ceiling where the
Chilled outlasts the fight, and IX's healing absorption is not confirmed by either (§3). **Nine handles were turned by a rule-derived
step and measured** — sixty runs each, paired against a re-driven baseline: five cost something now (Bloodletting a 3, Parched a 2,
Fleeting, Hoarfrost and Slick Footing 1s), four still cost the reference party nothing, and each slope is printed for the placing,
which is the designer's (§2). **A grade is the highest cost measured, on any population, and only a cost that clears the test earns
one** — Deadened 3 and Brittle 2 from the talented incumbent, every row naming its population and its batch (§4). **The glossary's
count is behind a door** — `Run.figure_modifiers_dealt_beneath_top()`, read through a token — and the rung bands were read, not
re-set: Warden's gamble band still holds two (§5). `check_iy` is new; nine targets are re-pointed, each to its intent (§8).
**No modifier's rule or words moved** — only the nine figures, each formatted from its constant. No save version moved.

**VERDICT: SHIPPED, AND VERIFIED: the sim seeds each fight off its run (`DOD_SIM_FIGHT_SEED`), and pairing at that unit cut Encumbered's
paired error to 0.554 of the unpaired (IX's run seeding: 0.941) with every reading a tie with IX's; a grade is the highest
test-bound cost measured on any population — Deadened 3 and Brittle 2 from the talented incumbent, every row naming its population
and batch; the nine free modifiers' handles were turned by a step their own rule gives and measured, sixty runs each against a
re-driven baseline — Bloodletting a 3 at 45, Parched a 2 at its floor, Fleeting, Hoarfrost and Slick Footing 1s, and Dull Edge,
Tinderbox, Frenzied and Muffled still free (the deck: none 4; 1 3; 2 5; 3 5; 4 2; 5 4); the glossary's count is behind a door; the
bands were read, not re-set, and Warden's gamble band still holds two. The acceptance read `check_de` 677 / 0 / 0 notices, the harness
22 / 382 / 8 and the sanctioned reds alone; thirteen controls bit, and the positional re-run moved no verdict. Four rulings are owed —
the first, the placing of the nine against their slopes.**

---

## §0 — THE BRIEF's PREMISES, VERIFIED (`CLAUDE.md`: verify the brief against the repo)

| # | the brief says | verdict |
|---|---|---|
| 1 | `git ls-remote origin class-merge` reads IX's push and local HEAD | **True** — `fa24c3b` both, before anything ran (11:52). |
| 2 | IX's diagnosis: no half of any of the seven pays the party, so the Dark's shape is nowhere | **True** — IX §2c: every one of the seven is *the magnitude is too small*. |
| 3 | the count is eleven, not seven — Dull Edge's gift did not survive pairing; Deadened, Brittle, Slick Footing and Bloodletting inside the noise too | **True** — IX §1c: eleven inside two standard errors, Dull Edge's paired z +1.15. |
| 4 | §0.1: at sixty runs two standard errors are 1.3 points and grade 1's centre is 0.93 | **True** — IX §1c's 1.27 (the median spread over the three cheapest levels); the centre 0.93. |
| 5 | §0.1: grade 2 (2.48) is already measurable at sixty runs | **True** — 2.48 lies past 1.3. **And since §1 the error is about half that**, so grade 1's 0.93 reads too (§1). |
| 6 | §0.2: the deck's shape today 0 / 4 / 4 / 2 / 4 across grades 1–5; the target 5 / 5 / 5 / 4 / 4 | **True** once §0.1's test and §0.3's two grades are applied: none 9; 1 0; 2 4; 3 4; 4 2; 5 4 (IY's drive deck, before §2's measurement). 5+5+5+4+4 = 23. |
| 7 | §0.3: Deadened costs the reference party 0.54 and the incumbent 5.23, z 5.6; Brittle 3.34, z 4.2 | **True of the costs**; **the z's read 5.71 and 3.75**, recomputed by IX's own pairing (`ix_pair`, by party and seed) off IV's incumbent logs — Brittle's 4.2 is not the paired figure. Both still past two standard errors, so both grades stand: Deadened 3, Brittle 2. |
| 8 | §0.3: every other swinging modifier reads higher on the reference party, so none of the rest moves | **True** — of the ten whose two bands differ, Deadened and Brittle alone read higher on the incumbent. **Five more read higher on the incumbent and share a band with the reference party** (Parched inside the noise on both; The Thin Veil, Miasma, Overgrown, Mirrorbound), so none moves (§4). |
| 9 | §0.4: IW measured the party's natural bargain-fight endings at 0.869 / 0.647 / 0.540 | **True** — IW's report, arm A's step three (the screen's winner, the bot's own bargains, sixty a rung). |
| 10 | §0.5: IJ's rule, 402 conversions | **True** — IJ's report: 402 typed figures converted to doors. |
| 11 | §1: the paired error stood at a median 0.91 of the unpaired; Frenzied's at 0.34; Encumbered the cheapest that costs something, 1.72 ± 0.74 | **True** — IX §1c; Encumbered's own ratio was 0.941, Frenzied's 0.341. |
| 12 | §2's table: the nine handles and IX's costs | **True as listed** — each handle is the literal its arm of `battle._stamp_modifier` writes (Hoarfrost's the 3 of `_apply_status(u, "chilled", 3)`, Slick's the 0.5 of `ab.delay += 0.5`, Bloodletting's the 15 of `mod_bleed_add`), and each cost is IX's kept table's. Parched's warband half 0.000 ± 0.000 — **true**. |
| 13 | §2: *seven of the nine* have a current cost inside the noise | **False in its count — all nine do.** Every one of the nine reads inside two standard errors at IX (Bloodletting, the nearest, z −1.35). So none had a slope to scale from, and every value is a step (§2). |
| 14 | §3's table: the healing, length and end readings of the four halves | **True** — IX §2d, every figure. |
| 15 | §6: IW's lock drive adds folders to the pattern each battery | **False** — IX §6 found it adds none: `check_iw` §0.2 probes under three fixed names made once at IW. **IY read the count at the open and the close** (§6). |
| 16 | §7: the 188 cheap gates, 438 pins, thirteen standing picks, the Chilled row's *4* | **True** — `check_iv`'s `CHEAP_CEILING` 188, `check_ij`'s 438 rows, `check_iu`'s `MISSES_CEILING` 13; untouched — **but the 438 pins fall to 432 by the standing rule, not by a campaign**: six of them pinned figures §2 re-tunes, so each became a `Run` constant (IU §0.4, *a figure a batch re-tunes gets a constant then*) and left the pins for `check_iy` §2, IT §2's precedent. |
| 17 | §8: C01–C08, H01, H02, R01 | **Built** — each on a clone of the final tree, read by its FAIL text (§8). C01's and C02's DRIVEN halves are drives (§8). |

## §0 — THE RULINGS, AND WHERE EACH IS WRITTEN

`check_iy` §0 pins each by its own words, in the file whose subject it binds:
- **§0.1** — *A GRADE's BAND MUST BE WIDER THAN THE INSTRUMENT THAT SETS IT. A BAND NARROWER THAN TWO STANDARD ERRORS IS NOT A GRADE*:
  `CLAUDE.md`'s ladder block, a bullet beside IX's scale, and the comment above `Run.MODIFIERS`. IX's *every grade falls out of its own
  reading by arithmetic* is recorded qualified there, never deleted.
- **§0.2** — *TURNING NINE HANDLES TO ONE TARGET MEASURES NINE SLOPES*: `docs/state.md`, at the head of the slopes' table in THE BARGAIN
  DECK's GRADES, where the placing will be read.
- **§0.3** — *A GRADE MAY OVERSTATE WHAT A MODIFIER COSTS. IT MAY NOT UNDERSTATE IT. THE GRADE IS THE HIGHEST COST THE PROJECT HAS
  MEASURED, ON ANY POPULATION*: `CLAUDE.md`'s ladder block, in the same bullet as the scale's test, so the rule stands where the scale is
  (§4) — with *every grade names its population and its batch* beside it, and IX's *a modifier whose cost swings … carries that in its
  own words* recorded superseded (*no rewording*).
- **§0.5** — *A COUNT A DOOR CAN COMPUTE BELONGS BEHIND A DOOR, NOT DELETED*: `CLAUDE.md`'s figure rule (IJ §2's bullet), where a text's
  figure is ruled.
- **§1** — *PAIR AT THE UNIT YOU MEASURE, NOT THE UNIT YOU RUN*: `docs/instrument-rules.md`, a bullet of the tie rule's block beside IX's
  baseline bullet, whose *honest, not cheap* is recorded superseded there.
- **§3** — *A HANDLE WITH NO REACH CANNOT BE TURNED INTO A COST AT ANY VALUE*: `docs/state.md`, under the reach test's two lines.

## §1 — SEED A FIGHT, NOT A RUN

### §1a — THE CHANGE, AND HOW FAR IT CAN GO

**The sim's seeding and nothing else** (`scripts/run_sim.gd`, +25 lines, `edits/apply_seed.py`). `DOD_SIM_FIGHT_SEED=<block>` is read
in `RunSim.begin`; with it set, **the walk reseeds the dice at the step onto every node** (`_seed_node(run, 0)`, right after
`run.advance(pick)`) **and at every won fight's spoils** (`_seed_node(run, 1)`, below the loss's early return), each seed
`node_seed(block, the run's ordinal, the zone, the slot, the phase)` — `hash` of an Array of ints, the same in every process. **Unset,
the one `if` returns and no die is spent.** A sim-family flag on RunSim's own path (IV §2: only a run sim reaches the file; `check_iv`
§2 reads RunSim's reads as one block, so it moved no row). It changes no rule and no figure.

**How far it can go, derived — and the first derivation was half wrong.** PREDICT_S1 said the seed would align a node's warband, its
offer and a fight's opening rolls. **The warband was already aligned**: the map composes every node's warband when its zone is
generated (`run_state.gd`'s map build calls `compose`), so the run seed already decided which warbands a run meets, in both arms.
**What the fight seed aligns is the dice from each node on**: the offer's draw (its consumption does not depend on the party's
state), the fight's rolls until the first roll the modifier changes sends a branch another way, and the spoils (the drop, the drafts,
the caches). **A seeded fight is not an identical fight**: after the branch, every die is drawn from another position of the same
stream, and the parties carry different health, gold and holdings into the next node — so the in-fight noise stays largely unpaired,
and what cancels is everything between the fights, and every fight's opening.

### §1b — VERIFIED ON ITS OWN, BEFORE ANYTHING WAS BUILT

**The fidelity, printed** (`IY-work/s1/fidelity_s1.txt`):

```
(1) THE PROBE's OWN RE-DRIVE — IW's tree, R_none against IX's N_none, ten runs: 12541 against 12541 probe lines IDENTICAL; 10 against 10 run lines IDENTICAL
(2) THE SWITCH IS INERT UNSET — none: IY's tree unset (U_none) against HEAD (H_none), ten runs: 12303 against 12303 probe lines IDENTICAL; 195 against 195 non-probe lines IDENTICAL
(2) THE SWITCH IS INERT UNSET — encumbered: IY's tree unset (U_encumbered) against HEAD (H_encumbered), ten runs: 12798 against 12798 probe lines IDENTICAL; 191 against 191 non-probe lines IDENTICAL
(3) THE SEED IS THE NODE's — Z_none_rep against F1_none's first ten runs: 12993 against 12993 probe lines IDENTICAL; 10 against 10 run lines IDENTICAL
Parse Error / SCRIPT ERROR lines across the drives' logs: 0
FIDELITY: ALL HOLD
```

**Found on the way, and it is the reason (1) is a separate line**: IY's tree with the flag unset does NOT reproduce IX's own logs — it
parts from them at the first elite. **IX drove on IW's deck**, and IX's re-grade changes how many modifiers each band holds, so
`roll_offer`'s shuffles draw a different number of dice. The twin of an IX log is IW's tree (`a538639`'s scripts and data with IX's
four probe parts), which (1) re-drove; the switch is proved inert against HEAD, which (2) re-drove.

### §1c — THE TWO ARMS, THE RATIO, AND THE TIES

Sixty runs each, block 38, the reference party, IX's four probe parts byte for byte (md5 `ed406123…`, `023aca68…`, `75b89a8c…`,
`5314c05d…`), HEAD's deck, fight-seeded; paired by seed against the fight-seeded *none* arm (IX's pairing, `ix_pair`, unchanged).
**The kept table: `docs/reports/IY-seeding.tsv`.**

| arm | the cost (points) | paired error | unpaired | **ratio** | IX's cost | IX's ratio | the cost against IX's |
|---|---|---|---|---|---|---|---|
| *none* (the baseline) | 0.938071 ± 0.004096 | — | — | — | 0.943863 ± 0.004887 | — | −0.58 points, **z −0.91: a tie** |
| Encumbered | +0.74 (z 2.31) | **0.32** | 0.58 | **0.554** | +1.72 ± 0.74 | 0.941 | −0.98, **z −1.22: a tie** |
| Frenzied | −0.05 (z −1.07) | **0.05** | 0.58 | **0.084** | +0.05 ± 0.24 | 0.341 | −0.10, **z −0.41: a tie** |

- **THE PASS: the cheap arm's ratio is 0.554 — against IX's 0.941 for the same arm and IX's median 0.91.** The seeding paid, so it is the
  instrument of §2 and §3, and the kept table says so (`seeding` = `fight` on every row).
- **THE READINGS DID NOT MOVE.** Both costs and the baseline are ties with IX's. So this is a seeding change, not a different measurement.
- **WHAT IT BUYS**: at sixty runs, two standard errors of a paired cost fall from about 1.3 points to about 0.6 — **so a severity 1
  (0.93) reads at sixty runs**, which IX priced at 113. Frenzied's runs stay almost identical (its paired error is a twentieth of a point):
  a speed-up on every unit rescales the timeline and changes no turn's order, so its arm and the baseline draw the same dice for most of
  every fight.
- **THE PREDICTION, GRADED** (`s1/PREDICT_S1.md`, 12:01:37, md5 `7acaca30…`): Encumbered's ratio 0.70 (0.55–0.85) — **0.554, at the
  edge of the band**; Frenzied's 0.30 (0.20–0.40) — **wrong, 0.084**; the ties and the fidelity right.
- **One finding the instrument now shows**: on the sharper instrument Encumbered reads **0.74 ± 0.32** — a severity 1 by the scale's
  arithmetic, past the test — where IX's run-seeded 1.72 graded it 2. **The grade stays 2** (§0.3: the highest cost measured), and which
  of two readings of one population a grade should take is a ruling owed (NEEDS A RULING).

### §1d — DRIVEN IN THE GATE

`check_iy` §1 drives the property, not the ratio (a gate cannot drive sixty runs): two arms through `RunSim.start_run` and
`walk_to_next_fight`, their "fights" drawing 7 and 19 dice and their spoils 3 and 1 — **with the flag set, every node's first die and every
spoils' first die are identical across the arms; unset, they part after the first fight** (the positive arm: the alignment is the seed's).
It also asserts the doors (the read, the two calls and their places, `node_seed` a function of its five inputs alone) and that, unset,
`_seed_node` moves no die. **C01 reverts the seeding and reds it** (§8).

## §2 — NINE HANDLES TURNED, AND NINE SLOPES

**The values were derived by rule and printed before the drive** (`IY-work/s1/VALUES_S2.md`, 12:33:38, md5 `d062c035…`): every one of the nine read inside two standard errors of none at IX — **all nine, where the brief says seven** (§0, premise 13) — so none had a slope to scale from, and each takes a step: a reduction doubled (to its floor where it has one), a bonus trebled, and the two §3 tested set against their reach arm. **One rule's name was corrected after the print, not its value**: Muffled's handle is the share of Break damage that LANDS (75), so *a reduction doubled* applied to the figure gives 150; the rule is *the share's reduction doubled* (the 25 taken away, doubled to 50, lands 50) — the value printed and driven is 50, and `check_iy` §2 re-derives every value from its rule. The modifier's constant for Hoarfrost was renamed `HOARFROST_CHILL_TURNS` after the drive (13:33), so no source sweep can conflate it with `Battle.HOARFROST_TURNS`, Hoarfrost Armor's card; the value and the stamp are the ones driven. **And one line of the combat log was found false by the pre-run** (`check_gj`'s walked run took Hoarfrost): the line a Chilled stack logs typed *3-turn clock reset* whatever clock the pile was given — true while every literal Chilled was three turns, false under Fleeting and Sanctity since they existed, and false on IY's own modifier at nine. It reads the pile's clock now (`battle.gd`, `_apply_status`'s Chilled branch); the fifteen three-turn sites print what they printed. The chill itself always carried the turns it was given (`add_status` sets the clock from them), so §2's and §3's Hoarfrost readings stand.

**The drive**: ten arms (the baseline re-driven on the deck the nine are measured on, and the nine), sixty runs each, block 38, fight-seeded, paired by seed against the re-driven baseline (0.934130 ± 0.004727, sixty runs, 57 completed — a tie with §1's 0.938071 ± 0.004096, z −0.63). 0 `Parse Error`, 0 `SCRIPT ERROR` in any log. **The kept table: `docs/reports/IY-handles.tsv`** (costs in points of health at a bargain fight's end; the slope is the cost's change per unit of the handle, off the printed pair).

| modifier | handle | old | new | the rule | IX's cost | IY's cost | z | slope | grade |
|---|---|---|---|---|---|---|---|---|---|
| Dull Edge | `DULL_EDGE_CRIT` | 0.05 | **0.1** | a reduction doubled, to its floor | -0.61 ± 0.53 | **-0.54 ± 0.24** | -2.22 | 1.4520 | **none** |
| Parched | `PARCHED_SHARE` | 0.5 | **0.0** | the share's reduction doubled | -0.14 ± 0.55 | **+1.90 ± 0.40** | 4.80 | -4.0702 | **2** |
| Tinderbox | `TINDERBOX_FIRE_PCT` | 0.25 | **0.75** | a bonus trebled | -0.04 ± 0.37 | **-0.02 ± 0.14** | -0.14 | 0.0390 | **none** |
| Frenzied | `FRENZIED_SPEED` | 1.3 | **1.3** | no reach: not turned | +0.05 ± 0.24 | **+0.13 ± 0.06** | 2.20 | - | **none** |
| Muffled | `MUFFLED_BD_PCT` | 75 | **50** | the share's reduction doubled | +0.09 ± 0.67 | **-0.24 ± 0.22** | -1.07 | 0.0130 | **none** |
| Fleeting | `FLEETING_TURNS` | 1 | **2** | a reduction doubled | +0.41 ± 0.62 | **+1.63 ± 0.42** | 3.89 | 1.2248 | **1** |
| Hoarfrost | `HOARFROST_CHILL_TURNS` | 3 | **9** | derived against the reach test: the fight's length | +0.51 ± 0.60 | **+1.03 ± 0.29** | 3.62 | 0.0871 | **1** |
| Slick Footing | `SLICK_DELAY` | 0.5 | **1.5** | a bonus trebled | +0.75 ± 0.71 | **+0.98 ± 0.32** | 3.11 | 0.2259 | **1** |
| Bloodletting | `BLOODLETTING_BLEED` | 15 | **45** | a bonus trebled | +0.87 ± 0.65 | **+4.37 ± 0.49** | 8.84 | 0.1165 | **3** |

**Each value's one line of reasoning** (the table's `reasoning` column, as printed before the drive):

- **Dull Edge** 0.05 → 0.1: the base crit chance is 10% (`CRIT_CHANCE`) and the stamp floors a unit's total at zero, so doubling the 5 points taken takes every unit's base crit to zero — the deepest the rule allows.
- **Parched** 0.5 → 0.0: the clamp takes half the bar; doubling what it takes takes all of it, so both parties open every fight with nothing in hand — the floor of a clamp, the rule unchanged.
- **Tinderbox** 0.25 → 0.75: a bonus has no ceiling to stop at, so the plain step is three times: every fire strike +75%, whoever deals it.
- **Frenzied** 1.3 → 1.3: §3's reach arm at 3.0 read -0.27 ± 0.15 (z 1.80 the wrong way), the healing and the fight's length flat: a speed-up on every unit rescales the timeline and moves no turn's order, so no value of this handle costs this party anything — the rule wants re-keying (the designer's), and the handle gets no value.
- **Muffled** 75 → 50: a quarter of all Break damage taken away, doubled to a half: the meters fill at half speed on both sides.
- **Fleeting** 1 → 2: one turn off every status, doubled to two (never below one): a three-turn buff lasts one.
- **Hoarfrost** 3 → 9: §3's reach arm at 99 turns read +0.68 ± 0.26 (z 2.62): reach, and its ceiling — the cost saturates where the Chilled outlasts the fight, and a bargain fight is 34.46 hero turns over four heroes, about 8.6 of each one's own turns, so the target lies past every value and 9 takes the handle to its reach.
- **Slick Footing** 0.5 → 1.5: a cost added to every ability's initiative is a bonus to the delay, so the plain step is three times: +1.5 a cast, a basic attack 3.5 where it was 2.5.
- **Bloodletting** 15 → 45: Bleed added to every hit, three times: a bleedout (at 100) in three hits where it took seven.

### §2a — WHAT THE SLOPES SAY (the placing is the designer's, IY §0.2)

Grade 2's centre is 2.48. Read straight along each slope (a line through two points, so a guide and not a measurement):

- **Bloodletting OVERSHOT, to a 3** (+4.37 ± 0.49 at 45, z 8.84): its slope puts 2.48 at about **29 Bleed**.
- **Fleeting is a 1** (+1.63 ± 0.42 at 2): 2.48 at about **2.7 turns** — so 3, a whole turn, is the step past it.
- **Parched is a 2 AT ITS FLOOR** (+1.90 ± 0.40 with no resource at all): below the centre, and no value goes further. **Its sentence at the floor reads *Both parties begin the fight at no resource at most.*** — the template's register at its floor (the share's word is *no*); IY moved no word (§0.3), so the sentence is the designer's with the placing.
- **Hoarfrost is a 1, and saturates** (+1.03 ± 0.29 at 9; §3's arm +0.68 ± 0.26 at 99, a tie with it): the Chilled cannot cost more than the fight it outlasts, so no value reaches 2.48.
- **Slick Footing is a 1** (+0.98 ± 0.32 at +1.5): its slope (0.2259 points an initiative) puts 2.48 at about **+8.1**, no value a deck would use.
- **Four cost the reference party nothing at IY's values.** DRIVEN TO AN EXTREME: **Frenzied** (§3: no reach — not turned; +0.13 ± 0.06 at 1.3 is past the test and under the first cut, so no severity) and **Dull Edge** (at its floor, every unit's base crit gone, it PAYS the party, -0.54 ± 0.24: the warband's crits cost the party more than its own pay it). ARGUED, NOT DRIVEN: **Tinderbox** (-0.02 ± 0.14 at +75%, a slope of 0.0390 a unit of the bonus — the reference party deals almost no fire) and **Muffled** (-0.24 ± 0.22 at half, and bounded above, by its rule, by Deadened's 0.54 on this party — no Break at all). Whether their rules are re-keyed is the designer's (NEEDS A RULING 2).

### §2b — THE PREDICTION, GRADED (`IY-work/s1/PREDICT_S2.md`, md5 `d1c62847…`, written before the drive)

| arm | predicted | read | |
|---|---|---|---|
| Dull Edge | +0.5 (−0.5 to +1.5) | -0.54 ± 0.24 | **wrong** |
| Parched | +1.5 (0.5–3.0) | +1.90 ± 0.40 | right |
| Tinderbox | +0.3 (−0.5 to +1.0) | -0.02 ± 0.14 | right |
| Frenzied | 0.0 ± 0.1 | +0.13 ± 0.06 | **wrong** |
| Muffled | +0.4 (−0.3 to +1.2) | -0.24 ± 0.22 | right |
| Fleeting | +2.0 (1.0–3.5) | +1.63 ± 0.42 | right |
| Hoarfrost | +0.6 (0.2–1.0) | +1.03 ± 0.29 | **wrong** |
| Slick Footing | +2.0 (1.0–3.5) | +0.98 ± 0.32 | **wrong** |
| Bloodletting | +2.5 (1.0–4.5) | +4.37 ± 0.49 | right |
| the baseline | a tie with §1's 0.938 | 0.934 (z −0.63) | right |
| errors | none | none | right |

**7 of 11 right.** Dull Edge wrong in sign (crit is a quantity both sides make, and the warband's paid the more); Frenzied, Hoarfrost and Slick Footing wrong at the margin of their ranges (+0.13 against ±0.1; +1.03 against 1.0; +0.98 against 1.0).

## §3 — THE REACH TEST: FRENZIED AND HOARFROST

**One arm each, at an extreme nobody would ship**, sixty runs, fight-seeded (§1 paid), paired against §1's *none* arm — the reach patch
(`tools/iy_reach.py`, a scratch lane's stamp, never the repo) touches only the modifier's own branch, so the *none* arm is both arms'
baseline. **The rule, written before the drive** (`s1/PREDICT_S3.md`, 12:12:33, md5 `aefa207d…`): a cost past two standard errors is
reach; none is no reach. The healing a bargain fight takes is read in the same arm (IX's part four's `[IXP] fight` line). **The kept
table: `docs/reports/IY-reach.tsv`.**

| arm | the deck's value | the extreme | the cost (points) | z | the healing a bargain fight | its length (hero turns) | **verdict** |
|---|---|---|---|---|---|---|---|
| Frenzied (`mod_speed_mult`) | 1.3 | **3.0** | −0.27 ± 0.15 | −1.80 | +0.1 ± 2.7 (z +0.04) | +0.04 ± 0.09 | **no reach** |
| Hoarfrost (the Chilled's turns) | 3 | **99** | **+0.68 ± 0.26** | **+2.62** | **−29.3 ± 5.8 (z −5.11)** | −1.04 ± 0.22 (z −4.74) | **reach** |

- **FRENZIED HAS NO REACH — AND NOT BECAUSE OF THE HEALING.** Three times the speed for every unit moves nothing: not the cost, not the
  healing, not the fight's length. **A speed-up on every unit rescales the timeline** — every delay is divided by effective speed,
  cooldowns and statuses and ticks count the unit's own turns, so the order of turns is unchanged at any value — and that is what §1's
  near-identical runs showed too. **No value of this handle costs this party anything; its rule wants re-keying** (the designer's,
  NEEDS A RULING), and §2 gives it no value. Predicted (no reach, healing flat): right.
- **HOARFROST HAS REACH, AND ITS REACH IS A CEILING.** A Chilled that outlasts every fight costs 0.68 points: a re-applied Chilled resets
  its clock, so on every enemy the Cryomancer's own chill cuts the 99 back to his own turns, while nothing re-chills a hero — the party
  stays slower for the whole fight and the warband does not. **But the cost cannot grow past the fight**: a bargain fight is 34.46 hero
  turns over four heroes, about 8.6 of each one's own turns, and a Chilled longer than that buys nothing. **So no value reaches 2.48**;
  §2 takes the handle to 9, its reach, and measures it there.
- **THE HEALING, READ IN THE SAME ARM — AND IX's ABSORPTION IS NOT CONFIRMED.** The brief's test: *if the cost stays flat while the healing
  moves further, that is the absorption confirmed.* **Neither arm shows it.** Frenzied's healing does not move at all: a two-sided rescale
  leaves nothing for the healing to take up, and IX's mirrored halves cancel in it. Hoarfrost's healing FALLS (−29 of 215) with its cost,
  where the absorption would have it rise: the party, slowed, takes fewer turns, heals less, and pays for it. **PREDICT_S3 said Hoarfrost's
  healing would rise by 40 or more — wrong in sign.** IX's reading came off ONE-SIDED halves at the deck's values, which these two-sided
  arms do not re-take; it stays IX's, read and not proved, and FOUND AT IY says so.

## §4 — EVERY GRADE IS THE HIGHEST COST MEASURED, ON ANY POPULATION

**The rule** (IY §0.3, the designer's), written where the scale is — `CLAUDE.md`'s ladder block, the bullet that holds §0.1's test: *A GRADE MAY OVERSTATE WHAT A MODIFIER COSTS. IT MAY NOT UNDERSTATE IT. THE GRADE IS THE HIGHEST COST THE PROJECT HAS MEASURED, ON ANY POPULATION*, with every grade naming its population and its batch. **Two populations are measured**: the reference party (the sim's default four, untalented, at Wanderer — IX's reading, or IY §2's where the handle moved) and IV's talented incumbent (IV's logs, re-paired by IX's method: by party and seed). An incumbent reading measures a modifier only while its handle stands where IV drove it, so it is void for the eight §2 moved and stands for Frenzied, which §2 did not turn.

**The arithmetic** (`docs/reports/IY-grades.tsv`; `check_iy` §4 re-derives every column): each reading's band is the band its cost falls in **if the cost clears two standard errors of zero, else none** (§0.1); *the higher* is the sweep's: of IX's reading and IV's, both at HEAD's handles, which costs the more (§0.3, *say for each*); the grade is the higher of the two bands; the population is the one whose passing cost is the highest. The row of `Run.MODIFIERS` carries `"graded": "<population> — <batch>"`.

| modifier | the reference reading | its band | the incumbent's | its band | the higher of IX's and IV's | HEAD's grade | **IY's grade** | whose | batch |
|---|---|---|---|---|---|---|---|---|---|
| Dull Edge | -0.54 ± 0.24 (IY §2) | none | -1.09 ± 0.55 *(void: the handle moved)* | none | reference | none | **none** | the default four | IY §2 |
| Parched | +1.90 ± 0.40 (IY §2) | 2 | +0.40 ± 0.66 *(void: the handle moved)* | none | incumbent | none | **2** | the default four | IY §2 |
| Tinderbox | -0.02 ± 0.14 (IY §2) | none | -0.45 ± 0.51 *(void: the handle moved)* | none | reference | none | **none** | the default four | IY §2 |
| Frenzied | +0.13 ± 0.06 (IY §2) | none | -0.55 ± 0.21 | none | reference | none | **none** | the default four | IY §2 |
| Muffled | -0.24 ± 0.22 (IY §2) | none | -0.28 ± 0.58 *(void: the handle moved)* | none | reference | none | **none** | the default four | IY §2 |
| Fleeting | +1.63 ± 0.42 (IY §2) | 1 | +0.15 ± 0.61 *(void: the handle moved)* | none | reference | none | **1** | the default four | IY §2 |
| Hoarfrost | +1.03 ± 0.29 (IY §2) | 1 | -0.88 ± 0.58 *(void: the handle moved)* | none | reference | 1 | **1** | the default four | IY §2 |
| Deadened | +0.54 ± 0.58 (IX §1) | none | +5.23 ± 0.92 | 3 | incumbent | 1 | **3** | the incumbent | IV, graded at IY §4 |
| Brittle | +0.75 ± 0.66 (IX §1) | none | +3.34 ± 0.89 | 2 | incumbent | 1 | **2** | the incumbent | IV, graded at IY §4 |
| Slick Footing | +0.98 ± 0.32 (IY §2) | 1 | -0.38 ± 0.57 *(void: the handle moved)* | none | reference | 1 | **1** | the default four | IY §2 |
| Bloodletting | +4.37 ± 0.49 (IY §2) | 3 | -0.54 ± 0.64 *(void: the handle moved)* | none | reference | 1 | **3** | the default four | IY §2 |
| Encumbered | +1.72 ± 0.74 (IX §1) | 2 | +0.04 ± 0.58 | none | reference | 2 | **2** | the default four | IW, graded at IX §3 |
| Feverish | +2.42 ± 0.75 (IX §1) | 2 | +2.42 ± 0.65 | 2 | reference | 2 | **2** | the default four | IW, graded at IX §3 |
| Warded | +2.54 ± 0.88 (IX §1) | 2 | +0.21 ± 0.53 | none | reference | 2 | **2** | the default four | IW, graded at IX §3 |
| The Thin Veil | +4.75 ± 0.70 (IX §1) | 3 | +4.85 ± 0.81 | 3 | incumbent | 3 | **3** | the incumbent | IV, graded at IY §4 |
| The Long Silence | +4.88 ± 0.56 (IX §1) | 3 | +2.13 ± 0.61 | 2 | reference | 3 | **3** | the default four | IW, graded at IX §3 |
| Miasma | +5.14 ± 0.72 (IX §1) | 3 | +5.46 ± 0.78 | 3 | incumbent | 3 | **3** | the incumbent | IV, graded at IY §4 |
| Rot | +8.66 ± 0.83 (IX §1) | 4 | +3.40 ± 0.69 | 2 | reference | 4 | **4** | the default four | IW, graded at IX §3 |
| Overgrown | +9.03 ± 0.92 (IX §1) | 4 | +10.54 ± 1.11 | 4 | incumbent | 4 | **4** | the incumbent | IV, graded at IY §4 |
| Mirrorbound | +15.59 ± 0.98 (IX §1) | 5 | +25.72 ± 1.66 | 5 | incumbent | 5 | **5** | the incumbent | IV, graded at IY §4 |
| Thin Air | +21.03 ± 1.38 (IX §1) | 5 | +2.31 ± 0.74 | 2 | reference | 5 | **5** | the default four | IW, graded at IX §3 |
| Bloodless | +24.22 ± 1.02 (IX §1) | 5 | +21.26 ± 1.19 | 5 | reference | 5 | **5** | the default four | IW, graded at IX §3 |
| Wasting | +36.53 ± 1.51 (IX §1) | 5 | +26.26 ± 1.66 | 5 | reference | 5 | **5** | the default four | IW, graded at IX §3 |

**What moved from HEAD** (5): Parched none → 2; Fleeting none → 1; Deadened 1 → 3; Brittle 1 → 2; Bloodletting 1 → 3. **The tally**: none 4; 1 3; 2 5; 3 5; 4 2; 5 4 — against the target 5 / 5 / 5 / 4 / 4, which IY does not pursue (§7).

**THE SWEEP — §0.3's *check the rest*.** Of IX's reading and IV's, 7 read higher on the incumbent (Parched, Deadened, Brittle, The Thin Veil, Miasma, Overgrown, Mirrorbound). **Deadened and Brittle alone take a higher band there**, and take their grades from it: Deadened 3 (+5.23 ± 0.92, z 5.71) and Brittle 2 (+3.34 ± 0.89, z 3.75). Of the rest, The Thin Veil, Miasma, Overgrown, Mirrorbound share a band with the reference party and read higher inside it, so the row names the incumbent and the grade does not move; Parched's incumbent reading is void (its handle moved). **6 grades name the incumbent** (Deadened, Brittle, The Thin Veil, Miasma, Overgrown, Mirrorbound).

**ONE POPULATION READ TWICE — Encumbered.** IY §1's sharper reading (+0.74 ± 0.32, past the test, a 1 by the arithmetic) and IX's (1.72 ± 0.74, a 2) are the same population at two seedings, and a tie with each other (z −1.22). §0.3's rule keeps the higher, so it stands at 2 on IX's reading, and the table says so; whether a re-measure on a sharper instrument replaces a reading of the same population is the designer's (NEEDS A RULING 3).

## §5 — THE GLOSSARY's COUNT, AND THE BANDS READ AGAIN

### §5a — THE COUNT IS BEHIND A DOOR (IY §0.5)

**The resolver reaches the site**: the glossary's text is read through `Glossary._load`, one of `Classes.resolve_figures`' doors (IJ
§2), so a token there resolves for every surface that shows the entry. What the door could not do was COUNT: `Classes.figure_value`
read a named constant or a dotted path into one, and the count of modifiers dealt beneath Ruin's gambles is no constant. **IY taught
the door one more shape** — a token naming a static, argument-free function whose name begins `figure_`, on a source the door already
reads (`{=Run.figure_modifiers_dealt_beneath_top}`), calls it and prints what it returns; any other name is refused, so a token cannot
reach an arbitrary function (`check_iy` §5 drives the refusal). `Run.figure_modifiers_dealt_beneath_top()` counts the graded
modifiers below Ruin's gamble band — read off `DIFFICULTIES.ruin.gamble_band`, never a typed 5 — and the entry reads:

> *The modifiers of severity 5 are dealt as Ruin's gambles and on no other road: the harshest bargains in the game and the best paid;
> the 15 beneath them are what every road deals.*

**Fifteen** — severity 1's three, 2's five, 3's five and 4's two; the four with no severity are dealt by no road and are not counted.
`check_iy` §5 holds the token in the text, no literal count beside it, the door's count equal to a count off `Run.MODIFIERS`, and the
resolved sentence carrying *the 15 beneath them*. **The next re-grade moves the sentence with it**, which is what IX's deletion of the
count could not do.

### §5b — THE BANDS, READ AND NOT RE-SET (IY §0.4)

On the deck §2 leaves (`Run.DIFFICULTIES` untouched):

| rung | safe band | holds | gamble band | holds |
|---|---|---|---|---|
| Wanderer | 1–2 | 8 | 3–4 | 7 |
| Warden | 1–3 | 13 | 4–4 | **2** |
| Ruin | 3–4 | 7 | 5–5 | 4 |

**WARDEN's GAMBLE BAND STILL HOLDS TWO — Rot and Overgrown — and that is IX's finding again, with IY's batch.** §2 filled grade 1 and
grade 2 and moved Bloodletting into 3; nothing it measured reached grade 4, so every Warden offer's two gambles are still that pair.
The ruling the brief left open is not answered by the measurement; it is IY's RULINGS OWED 4, where the band waits for the batch that
can measure what moving it does.

**What else the grades moved, read through the gates that hold each** (the pre-check on IY's code, `check_in` §1b and `check_il` §2):
- **Ruin's fixed encounters draw from SEVEN now** — the modifiers of severity 3–4: Bloodletting, Deadened, The Thin Veil, The Long
  Silence, Miasma, Rot and Overgrown (five at IX). The ladder's rule says the batch that re-grades says what the fixed encounters draw
  after; `CLAUDE.md`'s parenthetical and `check_ip`'s comment that counted five are corrected to seven.
- **Ruin stands a full step above Warden — 1.06** (Wanderer 2.73, Warden 3.38, Ruin 4.43 over 1,200 options a rung). The deck §2 was
  measured on, with grade 1 empty, read Warden's mean at 3.51 and the step at 0.93, under a full step (the pre-check); grade 1's three
  restored it.
- **The merchant rides severity 1 on Wanderer and Warden and 3 on Ruin** — the mildest each rung deals — exactly as at IX; the deck §2
  was measured on, with grade 1 empty, had moved it to 2 on the first two.
- **The glossary's *weighted toward the mild end* is still true** (`check_im` §1, G080L): of the fifteen beneath Ruin's gambles,
  eight sit at severity 1–2 and seven at 3–4.
- **Ruin's gamble band holds the four of severity 5**, unchanged; no severity-5 modifier is offered on Wanderer or Warden.

## §6 — HOUSEKEEPING

- **THE MOVE IS NOT ATTEMPTED** (IB §4). `./lane.sh spent` prints the one clearing command. **User-data folders: 611 at the open, 611 at the close** — every lane IY launched ran under a name a folder already held (IW's and earlier batches' lane names reused; `check_iw` §0.2's lock drive probes under three fixed names made at IW, so it adds no folder a battery). `./lane.sh spent` holds 608 of them under its three patterns (470, 129, 9) and `strays` names *IT const probe* and *[unnamed project]*; the live project's own is the one left. **The brief's premise
  that IW's lock drive adds folders each battery is false** (§0, premise 15): `check_iw` §0.2 probes under three fixed names made
  once at IW, and IY's recon 1, recon 2, pre-run and acceptance added none — so the pattern still covers every folder it covered.
- **`lane.sh` for every launch** — the work lane (*IC recon2*); the §1 and §2 drive lanes reusing IX's six names (*IG p1*, *IG p2*,
  *IH A*, *IH B*, *IA probe*, *IA docsub*) and the fidelity and reach lanes (*IE probeA1*–*A3*, *IE probeB1*, *IE probeB2*); the
  pre-check lanes (*IA pre1*–*IA pre3*); recon 1 and the final tree (*IC final*, never at once); the stand-in (*IC prepass*); the pre-run (*IA pre1*–*IA pre3*);
  the controls (*IA ctlA*–*IA ctlC*, and *IE probeB4*, *IE probeH1*, *IE probeH2* for the two driven controls). **No HEAD copy
  was launched**: the seeded roads were attributed against IX's acceptance logs — HEAD's gates on HEAD's own tree, copied out of IX's
  scratchpad — beside IY's recon 1 and pre-run. The acceptance ran in the repository as the live project, through `./run_battery.sh`, as every
  acceptance does. **One process a lane**: every job was bound to a lane of its own.
- **The designer's files** — backed up first (`../save-backups/IY-20261026-115230`, 11:52:30, byte-identical to IX's backup by
  `diff -r`) and read only through copies: `run_save.bin` (55,264 B, md5 `fcb20c91…`; its copy holds no offer pending), the profile,
  the relics, the settings and the readout's three files, the clean run `run-20261018-194229.jsonl` (24,340 B, md5 `610bcd8c…`) —
  **still the one run; no newer readout file** at the open — and at the close `run_save.bin` 55264 B md5 `fcb20c91…` unchanged; `profile.json` 1098 B md5 `608d89c0…` unchanged; `relics.json` 289 B md5 `fdc12ffa…` unchanged; `settings.cfg` 47 B md5 `0c1b39c3…` unchanged; `readout/latest.txt` 40 B md5 `e43f2d0a…` unchanged; `readout/run-20261014-134942.jsonl` 16291 B md5 `2b0f0212…` unchanged; `readout/run-20261018-194229.jsonl` 24340 B md5 `610bcd8c…` unchanged — **every one byte-identical to the open's backup**; the readout holds 2 run files, `run-20261014-134942.jsonl`, `run-20261018-194229.jsonl`.. **§1–§2's measurement does not
  change that: a sim is not a playthrough.**
- **The close's timestamp** — 2026-10-26 18:49:31 PDT.

## §7 — WHAT IS DELIBERATELY NOT DONE

- **No modifier's rule or words moved** (§2): each handle's figure is a constant its words format, so a figure moved with its handle and
  the sentence around it stayed — the two whose figure was a word take the word their constant gives (*half* → *no* for Parched,
  *one turn* → *2 turns* for Fleeting), and IY reports both. **No grade was placed by judgement**: each of the nine took the band its own
  measured cost gives, test-bound, and the placing against the slopes is the designer's.
- **The bands were not re-set** (§0.4) — read again on the deck §2 leaves (§5); the band change waits for a measurement of what a band
  change does.
- **The reference party is not changed and no second ladder is run** — §4's second population is IV's incumbent, read again off IV's own
  logs, not re-driven.
- **No re-key is built** (§3): Frenzied's rule, Hoarfrost's and Muffled's reach are reported; the re-keys are the designer's.
- **The deck's target shape (5 / 5 / 5 / 4 / 4) is not pursued** — written down where the grades are read, for the batch that places
  them.
- **Nothing of the playthrough.** Every figure in THE FIRST CLEAN PLAYTHROUGH is still one run and one party.
- **No POLICY row of the divergence census is changed**, RULE stays at 0, the ally pools stay — every figure IY takes goes through the
  same bot, so the constant bias cancels.
- **The latent offer defect stays latent** (FOUND AT IX): a save frozen on an offer can still deal a modifier with no severity; the
  designer's save holds no offer (read through the backup copy).
- **`CLAUDE.md` is not indexed; the 188 cheap gates are not built; the pins stay pinned** — 432 now, six having left by the standing
  rule that a re-tuned figure gets a constant (§0, premise 16); **the thirteen standing positional picks stay**; `check_it` §2c's arm is
  not widened; `check_hn` §2a's worn arm stands; the Chilled row keeps its *4*; the latent floor shapes and the Cryomancer's route stay;
  `check_hk`'s unseeded walk stays a band (§1's seed is the sim's, not that gate's).
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; the vow, the recoil floor and Anointing untouched; the
  third slot ungated; the art not commissioned; a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction
  half; Marrowfire's re-cut and `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the Occultist's Break card; the
  Skirmisher and the Tracker; Channel's tempo payout; the fallen-hero ruling and its seven things; Rupture's shape.

## FOUND AT IY AND NOT FIXED

- **IX's ABSORPTION READING IS NOT CONFIRMED** (§3): on the two-sided reach arms the healing moved with the cost (Hoarfrost, -29.3 a bargain fight at 99 turns, down where absorption would have it rise) or not at all (Frenzied, +0.1 at 3.0). IX read it off ONE-SIDED halves at the deck's values, which IY did not re-take; it stays read, not proved.
- **THE SHARPER INSTRUMENT MAKES SMALL COSTS SIGNIFICANT, AND THE SCALE's FIRST CUT IS WHAT KEEPS THEM UNGRADED**: Frenzied costs +0.13 ± 0.06 at 1.3 (z +2.20) — a cost past the test and under 0.48, so no severity. The test and the cut now each do a job: the test says whether a cost is there, the cut whether it is a grade's.
- **FRENZIED PAYS THE TALENTED INCUMBENT** (IV's reading, -0.55, z -2.62): the one modifier whose reading on any population is a gift past two standard errors besides Dull Edge at its floor (-0.54 ± 0.24 on the default four). IX's *pays the party* was a verdict the reference party's headroom could barely give (FOUND AT IX); the incumbent can.
- **THE WARBANDS WERE ALREADY PAIRED**: the map composes every node's warband when its zone is generated, so the run seed always decided which warbands a run meets; the fight seed pairs the dice from each node on (IY §1). A batch reading IX's *pairing buys little* as *the warbands diverge* reads it wrong.
- **THE CHANGELOG NEARS ITS THRESHOLD** (the close-read's one block that bore): `docs/changelog.html` stood at 387,694 B of the 400,000 `check_fg` §1 reads, before IY's entry; the next batch's entry will likely cross it, and a cut is owed then (CW §4's procedure, the changelog block below).
- **A COST THE OLD INSTRUMENT COULD NOT SEE IS ONE THE NEW ONE DOES** (IY's control C02d): Bloodletting put back at its old 15 on IY's deck reads +0.80 ± 0.30 (z 2.65) — a tie with IX's +0.87 ± 0.65, which sat inside IX's noise. So §0.1's *no severity* for the three IX read inside two standard errors (Hoarfrost, Slick Footing, Bloodletting) was the old instrument's reach, not their cost; IY measured the nine at their new values only, and the old values' grades on this instrument are not taken.
- **A BRIEF's *SEVEN OF THE NINE* WAS ALL NINE**: every one of IX's nine free modifiers read inside two standard errors (IY's report §0).

## NEEDS A RULING

1. **THE PLACING — THE NINE AGAINST THEIR SLOPES (IY §0.2: the placing is the designer's).** At IY's values the deck holds none 4; 1 3; 2 5; 3 5; 4 2; 5 4, against the target 5 / 5 / 5 / 4 / 4. What each slope gives (THE BARGAIN DECK's GRADES, the slopes' table): **Bloodletting overshot to a 3** (+4.37 ± 0.49 at 45) — grade 2's centre at about 29 Bleed, and **at its old 15 this instrument reads it +0.80 ± 0.30, a 1** (IY's control C02d, z 2.65: a cost IX's instrument could not resolve); **Fleeting** (+1.63 ± 0.42 at 2) reaches 2.48 at about 2.7 turns, so 3; **Parched is at its floor** (+1.90 ± 0.40 with no resource at all) — a 2 below the centre, and no value goes further; **Hoarfrost and Slick Footing are 1s** (+1.03 ± 0.29 and +0.98 ± 0.32) — Hoarfrost saturates where the Chilled outlasts the fight, and Slick's slope (0.23 points an initiative) puts 2.48 past +8, no value a deck would use.
2. **FOUR HANDLES COST THE REFERENCE PARTY NOTHING — TWO DRIVEN TO THEIR EXTREME, TWO ARGUED, NOT DRIVEN — AND THEIR RULES MAY WANT RE-KEYING (IY §3: the re-key is the designer's).** DRIVEN: **Frenzied** — a speed-up on every unit rescales the timeline: +0.13 ± 0.06 at 1.3, a cost under the first cut, and none at 3.0 (§3's reach arm: no reach). **Dull Edge** — at its floor, every unit's base crit gone (no value goes further), it PAYS the party (-0.54 ± 0.24): the warband's crits cost the party more than its own pay it. ARGUED, NOT DRIVEN to an extreme: **Tinderbox** — -0.02 ± 0.14 at +75%, a slope of 0.04 points per unit of the bonus: the reference party deals almost no fire. **Muffled** — -0.24 ± 0.22 at half the Break damage, and bounded above, by its rule, by Deadened's 0.54 on this party (no Break at all); the incumbent, whose plan is Break, is where Break-keyed modifiers cost (Deadened 5.23 there).
3. **ONE POPULATION, TWO READINGS — WHICH DOES A GRADE TAKE?** On IY's sharper instrument Encumbered reads +0.74 ± 0.32 (a 1 by the arithmetic, past the test) where IX's run-seeded reading was 1.72 ± 0.74 (a 2); the two are a tie with each other. **§0.3's rule keeps the higher, so it stands at 2.** Whether a re-measure on a sharper instrument replaces a reading of the same population, or joins it as §0.3's *any population* does, is the designer's.
4. **WARDEN's GAMBLE BAND STILL HOLDS TWO — Rot and Overgrown (IY §5, the finding again, with its batch).** §2 filled grade 1 and grade 2 and moved Bloodletting into 3, and grade 4 is untouched, so every Warden offer's gambles are still that pair. **The band moves in the batch that can measure what moving it does** (IY §0.4): the bargain-fight endings under a band change, a figure that does not exist yet.

## §8 — VERIFICATION

**THE ORDER, AS THE BRIEF SET IT, AND AS IT RAN** (`IY-work/IY-log.md` carries every time): the push check and the backup (11:52); **the
routing, written first** (11:55); **§1 on its own** — its prediction written (12:01:37), the fidelity proved, the drive, the reading
(12:17), the seeding judged paid before anything else was built; **§3's reach test** (12:18–12:32), before §2's values; **§2's values
derived and printed** (12:33:38) and **its prediction written**, then the drive (12:34–13:15); the grades derived off the kept tables;
**the code and its parse**; **the literal sweep before recon 1's prediction** (13:31); **recon 1** with its prediction written first
(13:38:51); then **every document**, as scratch copies, swept by a needle proof, `check_iy` in the battery; the pre-run, the
positional re-run, the controls, recon 2, the acceptance and the close; the push check; the two readings.

**THE ROUTING** (`docs/reports/IY-routing.md`): the brief's nine subjects matched 34 rows and 6 population rows (which added 18
blocks), opened with the 15-block core whole — 67 blocks, 167,711 B of the file's 351,886 at HEAD, every trigger verified verbatim
against its row before the work. **THE CLOSE-READ** read the 72 blocks IY did not open, whole, by a reader outside the working read
(given what IY changes, the routing and the index, and nothing of the working read): **one bore and was not routed — *The changelog***,
the index's miss (no trigger named the headroom before a cut; two of the reader's proposed triggers join its row); **none stale
because of IY**; **two lines stale before IY**, confirmed against the code and repaired with their batch named (FOUND AT HA's
`check_cl_resolver` reads resolved text since IT §2; GW's ceiling is `SHAPE_CEILING` 96). **The description of IY's changes the reader
was given was a superset**: it named `check_im`, `check_il` and `test_batch_bx` among the re-pointed gates, and the pre-check found all
three green on IY's code, so none was touched — a reader told more moved than did reads more blocks as bearing, never fewer. The
upkeep: 13 of 149 index entries touched, 7 by hand (the routing record's last section).

**§1 ON ITS OWN, AND THE INSTRUMENT's FIDELITY PROVED TWICE** (the brief's doubled premise). The probe's own re-drive: IW's tree
re-driven reproduced IX's *none* arm, 12,541 probe lines and every run line identical. The switch inert unset: IY's tree with the flag
unset against HEAD, ten runs of the *none* arm and of Encumbered, every probe line (12,303 and 12,798) and every other line identical.
The seed is the node's: ten fight-seeded runs repeated, 12,993 lines identical. **And §1's seeding moved no reading**: the baseline a
tie with IX's (z −0.91), Encumbered's cost a tie (z −1.22), Frenzied's a tie (z −0.41). The pass (§1): Encumbered's ratio 0.554
against IX's 0.941. **The baseline is an arm**: re-driven on §1's seeding (0.938071 ± 0.004096, sixty runs, block 38) and again on §2's
deck (0.934130 ± 0.004727), each with its seed, its count and its error, before any modifier was set against it.

**§3 BEFORE §2's VALUES** — the two reach arms (§3), their rule written before the drive (`s1/PREDICT_S3.md`); Frenzied's no reach is
why §2 gives it no value, and Hoarfrost's ceiling is why its value is set against the fight's length. **§2's VALUES PRINTED BEFORE THE
DRIVE** (`s1/VALUES_S2.md`, md5 `d062c035…`), each from its rule, and **its prediction written** (`s1/PREDICT_S2.md`, md5 `d1c62847…`,
graded 7 of 11 in §2b). Every log of all three drives: 0 `Parse Error`, 0 `SCRIPT ERROR`.

**EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM** (`check_iy`): §2's *a handle that costs nothing carries no severity* beside *a handle
that costs something carries the severity its cost gives* (Bloodletting's 3); §4's *no grade understates a measured cost* beside *a
grade the incumbent's cost raised* (Deadened's 3); §5's *no literal count* beside *the token resolves to the deck's own count*; §1's
*unset, the dice part* beside *set, they meet*.

**THE CODE AND ITS PARSE.** Every edit a script that asserts its anchors once (`IY-work/edits/`), every tree replayed from HEAD by
one script (`edits/rebuild.sh`). `check_parse` on the code tree: 240 checks / 0 failures, **0 `Parse Error` in stderr** (grepped, never
the tally, never the exit code); on the final tree 241 / 0 (`check_iy` joins the battery's GATES, which is `check_parse`'s population).
**One name changed after the drive**: the modifier's Chilled constant was `HOARFROST_TURNS`, the name `Battle.HOARFROST_TURNS` already
carries for Hoarfrost Armor (4), which `check_iu` §3 holds; it is `HOARFROST_CHILL_TURNS` (9), so no source sweep can conflate the
two. The value and the stamp are the ones §2 drove.

**THE LITERAL SWEEP BEFORE RECON 1's PREDICTION** (HEAD against IY's code, 13 files): 25,742 literals, 330 MOVED, 77 GAINED, 16 LOST,
every LOST and GAINED literal walked to the gates that hold it. **One bit**: `check_ik` §5b held master.html's Tinderbox row as a typed
*+25%* — re-pointed to `TINDERBOX_FIRE_PCT`'s figure before recon 1 (and predicted red there, master.html being HEAD's). The rest are a
word another gate holds for another subject (`check_iq`'s *+25%* is Precision Strike's; `test_batch_cb`'s *for three turns* the
Unmaking; `check_ij`'s *15 Bleed* Summon Canis's; `check_dn`'s *crit* a talent classifier's; `check_if`'s `seed(` a ban on the readout's
source alone). **`check_ed` named in the prediction**: the manifest on that tree was HEAD's, so it was predicted red there and repaired
by the final tree's regeneration. **The manifest's floor in the prediction**: HEAD records 2,075 at a floor of 2,075; regenerated on the
code tree it reads 2,074 (`check_ik`'s Tinderbox row is composed now) and with `check_iy` 2,094 — so the final regeneration rises past
the floor and lifts it, and no `--fall` is owed.

**THE DOCUMENTS — SCRATCH COPIES, SWEPT, BEHIND A HASH GUARD.** Every document edit is a script run on a scratch tree (the stand-in:
the final tree less the baseline moves), never on the repository. **The needle proof** (`tools/needle_proof.py`; the manifest is the
needle instrument): the pin manifest regenerated over the same gate sources on the code tree with HEAD's documents and on the stand-in,
entry by entry — **its first pass found one of `check_iy`'s eight document needles still unresolved: the grading rule wrapped across a
line in `CLAUDE.md`**, so `check_iy` §0 would have read red; the rule was put on one line. Second pass: **8 needles satisfied (all
`check_iy`'s), 0 taken red, 0 moved otherwise** — no document edit moved any other gate's needle. The landing copies only the files the
frozen final tree holds differently from HEAD, each only if the repository still holds HEAD's bytes there and the tree's bytes are the
ones the freeze recorded before recon 2.

**THE RE-POINTS — NINE TARGETS, EACH TO ITS INTENT** (FA §1b: HEAD's gates run against IY's code first, every red read; `edits/apply_gates.py`
names each repair's reason beside it):
- **`check_ij`** §3 — six pin rows leave (Tinderbox's, Frenzied's, Slick Footing's, Muffled's, Fleeting's and Bloodletting's): each figure
  is a `Run` constant now, read bare at the stamp and formatted in its words (IU §0.4: *a figure a batch re-tunes gets a constant then*),
  so the pin's premise is gone and `check_iy` §2 holds each text to its constant — IT §2's precedent, the count unmoved at 49; §2e's Dull
  Edge row reads the repaired clause without the figure the constant now holds. The pins stand at 432.
- **`check_hp`** §1b — the modifier still floors crit; its needle reads `Run.DULL_EDGE_CRIT`.
- **`check_ik`** §5b — master.html's Tinderbox row read at the constant's figure (the literal sweep's one bite).
- **`test_batch_an`** §3 — each modifier's stamp read against its constant, never a typed figure; the tally arms at IY's counts.
- **`check_in`**, **`check_io`**, **`check_ip`** — the grade counts IY's (none 4; 1 3; 2 5; 3 5; 4 2; 5 4); `check_ip` §1b's held sample
  re-read on IY's tree (IO's printed beside it), and its comment's fixed-encounter count seven.
- **`check_iw`** §2 and **`check_ix`** §3 — the measurement behind a grade is `docs/reports/IY-grades.tsv` now; IX's arithmetic on its own
  readings is IX's record, held to its own column.
- **`run_battery.sh`** — `check_iy` joins the GATES.

**RECON 1** (the code and the re-points on HEAD's documents; its prediction `s1/PREDICT_R1.md`, md5 `126ec550…`, written before the
launch): 161 targets and the harness, 0 `Parse Error` and 0 `SCRIPT ERROR` in any log. **The prediction held without exception: every red it named reddened, and nothing else did** — `check_ed` 18 / 2 (the manifest HEAD's: `check_hp`'s old Dull Edge needle broken, its new one unrecorded), `check_ik` 253 / 1 (master.html's Tinderbox row still +25%), `check_iq` 88 / 1 and `check_io` 120 / 1 (master.html's severities), `check_ix` 116 / 6 and `check_iw` 124 / 2 (the kept grades table absent; the state file's band sentences), and `check_de` 673 / 7 reading those. **The seeded roads, each attributed by HEAD's gate on HEAD's tree beside IY's** (IX's acceptance logs): `check_gp` 435 → **454** — its §4 road met other bargains on the re-graded deck (Deadened three times where HEAD's met Miasma three times), fought 33 battles where HEAD's fought 28, and was offered 62 distinct cards against 43, one assertion each; `check_gj`'s sanctioned §4 figures +166 / 186 → **+169 / 189** — its walked run's first bargain was Hoarfrost where HEAD's was Feverish, the 20-gold gap unchanged; the harness 22 / 382 / 8, **unmoved**; `check_hk` 168, HEAD's (its unseeded band 166–170). Inside their bands and not the batch: `test_batch_an` 6,054 (the pre-run read HEAD's 6,051: its count follows an unseeded map) and `test_batch_bk` 130. *Not predicted, and not reds*: the two in-band wobbles, and recon 1 found nothing else.

**THE PRE-RUN, TWICE.** **On the stand-in** (the final tree less the baseline moves; every target but the harness and the ten that read `baselines.json`; two lanes, one process a lane): 152 targets, 0 `Parse Error` and 0 `SCRIPT ERROR` in any log; against HEAD's acceptance target by target, `check_gp` 435 → 454 and `check_ix` 115 → 119 (both attributed, `baselines.json`), `check_iy` 120 (new), `check_hk` 168 → 166 (inside its unseeded band), and **one red, found and repaired: `check_iu` §8** reads every bullet of the routing record's close-read section as a miss that owes ROUTED or NOT ROUTED, and the note on the two lines stale before IY was a bullet — it is a paragraph now, the record re-rendered. **It also found the chill log line false** (`check_gj`'s walked run met Hoarfrost; §2). **Then on the final tree, whole** (every target but the harness, three lanes, after the controls' repair of `check_iy`): **161 targets, every one inside its band on its own `baselines.json`**, 0 `Parse Error` and 0 `SCRIPT ERROR` in any log, the sanctioned reds as HEAD read them (`check_cm_live` 13 / 5, `check_gj` 70 / 1 at +169 / 189), `check_iu` 185 / 0, `check_parse` 241, `check_iy` 121. **`check_de` standalone over those 161 logs against the new rows: 665 / 1 / 0 notices** — the one failure the three harness rows a subset cannot run. `test_batch_an` read 6,051, HEAD's; recon 1's 6,054 was its unseeded map.

**THE POSITIONAL AND SUPERLATIVE RE-RUN** (IT's census of 489 reads, re-derived against IY's tree; the kept tables are in IY's work
folder, `route/positional_iy_all.tsv` and the two passes beside it): **every one of the 489 settled — 335 SAME, 63 LINE-SHIFT, 55
IN-PLACE, 0 OFF-SUBJECT, and no verdict moved; the thirteen standing MISSES still miss** (the thirteen picks IY leaves standing).
21 reads were unchanged by construction (the gate and every file it opens byte-identical) and 15 settled mechanically by comparing
every occurrence of their anchor, with its surroundings, on both sides; **a reader re-derived the other 453** — each read ported from
its gate's own code and applied to HEAD and to the tree. IN-PLACE: the newest changelog entry and the archive's newest cut are IY's;
the master.html stamp reads IY; `_stamp_modifier` holds the nine constants; the battery's GATES list holds `check_iy`; the gate-source
sweeps (`check_ea` §3, `check_ec`, `check_ed`, `check_ff` §4, `check_hx`'s dotted tokens) meet `check_iy`'s literals and resolve
them; `returning_bodies`' standing MISSES shape gains one window, `check_iy`'s. **The chill log line** moves no verdict: the four
windows that hold it read other needles, and no runtime tail asserts on its text. **The mechanical pass had a vacuity, which the reader
found**: where the census gives its anchor as prose rather than a literal, the anchor occurred on neither side and *0 equals 0* was
reported as *windows identical* with nothing compared — 269 of its 286 such rows. The pass was repaired (an anchor found on neither
side goes to the reader) and the reader took all of them. **And the selection's *touched* list misses a changed file a population read
opens without naming it** — 21 of 68 such reads did open one (8 of them IN-PLACE or LINE-SHIFT), all re-derived.

**THE MANIFEST AND `check_ed`.** 2,075 → **2,094**: `check_iy`'s needles new, and the needles IY re-pointed recorded at their new
text (`check_hp` §1b's Dull Edge read, `check_ik`'s Tinderbox row composed from its constant, `test_batch_an`'s and `check_ij`'s
re-points, the six `check_ij` §3 rows gone with their figures); the floor re-recorded, no fall; its unresolved pins exactly HEAD's.

**THE CONTROLS** (one clone of the final tree each, *IA ctlA*–*IA ctlC*, one process a lane; every anchor dry-checked against the
tree, then asserted once before its edit; each read by its FAIL text, never its count) — **all thirteen bit as wanted**, the eleven
gate controls below and the two driven halves after them. **Their first run found a defect in the gate, and it was repaired before
the second**: H01 put HEAD's code under the final `check_iy`, and the gate **failed to parse** (30 errors, no verdict) — it named
`RunSim.node_seed`, `RunSim.fight_seed_block` and `RunSim._seed_node` statically, so a tree without them could not load it, and
a gate that cannot load reds by crashing, which no battery reads as a failure. §1 now asserts the door exists and reaches the
seeding through an untyped reference (one assertion more, 120 → 121); the words helper and §5's count door ask before they read, so
HEAD's code reds on sixteen FAIL lines with no error at all. (C03's and R01's first runs bit on the right content and were read as
misses only because the gate prints an array with its quotes escaped; the wanted strings were made quote-free.)

| control | the break | `check_iy` | what it said (first FAIL line, cut) | |
|---|---|---|---|---|
| C01 | the seeding reverted (both reseeds out of the walk and the spoils) | 121 / 3 | §1: the walk does not reseed once, right after the step onto a node (`_seed_node(run, 0)` after `run.advance(pick)`) | **bit** |
| C02 | one handle put back at its old value (BLOODLETTING_BLEED 45 → 15) | 121 / 2 | §2: 1 of the nine handles are not a constant read bare and stated in its words: ["master.html's row for Bloodletting does not state 'add 15 Bleed'" | **bit** |
| C03 | a handle's new value not derived from its arithmetic (Tinderbox 0.6 where its rule gives 0.75) | 121 / 2 | §2: 2 of the handles table's rows are not the deck's, their rule's or their own arithmetic: ["tinderbox: its new value 0.6 is not what its rule 'a bo | **bit** |
| C04 | Deadened left ungraded (severity 3 → 0) | 121 / 5 | §4: 1 grades are not the highest cost measured, test-bound: ["deadened carries severity 0 in the game, the highest measured cost gives 3"] | **bit** |
| C05 | a grade set from the lower of two readings (Rot at its incumbent band 2, not 4) | 121 / 6 | §4: 2 grades are not the highest cost measured, test-bound: ["rot: graded 2, the higher of its bands is 4", "rot carries severity 2 in the game, the h | **bit** |
| C06 | a grade written without its population and batch (Brittle) | 121 / 1 | §4: 1 rows of Run.MODIFIERS do not name the population and the batch their grade came from: ["brittle ('', the table: 'the incumbent — IV, graded a | **bit** |
| C07 | the glossary's count written as a literal | 121 / 2 | §5: the glossary's modifier entry does not read its count through the door (`the {=Run.figure_modifiers_dealt_beneath_top} beneath them`) | **bit** |
| C08 | a band re-set (Warden's gamble band 4–4 → 3–4) | 121 / 1 | §5: warden's bands read [1, 3] / [3, 4] — the bands are read, never re-set ([1, 3] / [4, 4]) | **bit** |
| H01 | HEAD's code under the final gate | 93 / 16 | §1: RunSim.begin does not read DOD_SIM_FIGHT_SEED once | **bit** |
| H02 | HEAD's documents under the final gate | 50 / 22 | §0.1: CLAUDE.md does not say a grade's band must be wider than the instrument that sets it | **bit** |
| R01 | a re-tune: one of the nine handles moved at its source (SLICK_DELAY 1.5 → 1.25) | 121 / 2 | §2: 1 of the nine handles are not a constant read bare and stated in its words: ["master.html's row for Slick Footing does not state '+1.25 initiati | **bit** |

**THE DRIVEN HALVES** (sixty runs each, the fight-seed flag set, block 38, paired by seed; `tools/ctl_drive.sh`, each arm on its own
lanes): **C01d — the seeding reverted** (both reseeds removed from a clone, the flag still set): Encumbered's paired error rose from
0.32 to 0.59 and its ratio from 0.554 to **0.833**, its cost back inside the noise (+0.22 ± 0.59) — **bit**: the halving is the seed's.
**C02d — Bloodletting back at 15** on §2's deck, against §2's *none* arm: the cost fell from +4.37 ± 0.49 to **+0.80 ± 0.30**, a tie
with IX's +0.87 at 15 — **bit**: the handle's effect is the handle's. **But the brief's *back inside the noise* did not hold**: at
z 2.65 the sharper instrument resolves the old value's cost, a 1 by the arithmetic, where IX's ± 0.65 could not — so §0.1's *no
severity* for the three IX read inside the noise was the old instrument's reach, not their cost (FOUND AT IY; IY's RULINGS OWED 1).

**RECON 2** (the final tree, frozen first — 610 files by absolute path — its prediction written before the launch, `s1/PREDICT_R2.md`):
**GREEN, as predicted.** `check_de` **677 / 0 / 0 notices** (recon 1's 673 and `check_iy`'s row of four); the harness 22 / 382 / 8;
the sanctioned reds as their rows hold them (`check_cm_live` 13 / 5, `check_gj` 70 / 1 at +169 / 189, `test_rune_battle` inside its
band); IY's moved rows at their new counts (`check_gp` 454, `check_ix` 119, `check_iy` 121, `check_parse` 241); the unseeded counts
inside their bands (`test_batch_an` 6,052, `check_hk` 168, `test_batch_bk` inside); 0 `Parse Error` and 0 `SCRIPT ERROR` in any log.
**Re-hashed against the freeze after the run: 0 of 610 files moved.** **It ran twice**: the first launch was stopped about five
minutes in, because the WHERE block's instruments line named `check_im` as re-pointed (it was never touched) and left out `check_ik`
(it was) — the line was corrected where it is generated, the tree rebuilt (only the state file and the report's test copy moved), the
21 gates that open `docs/state.md` and `check_iy` re-run on it (every one inside its band), and the tree frozen again before the second.

**THE LANDING** (`tools/land.py`, IW's hash guard): **30 files**, each copied only because the repository held HEAD's bytes there (or
nothing, for a new file) and the frozen tree's bytes were the freeze's — so what landed is what recon 2 read; re-checked byte-identical
after. The list is the frozen tree's own diff against HEAD, `project.godot` aside. **The report landed last, at the close, from the
work folder, once its verdict was in** (HU §0's addition): no gate reads it, which the landing re-proved over every `.gd` in the tree.

**THE ACCEPTANCE** (the repository, as the live project, through `./run_battery.sh`, no Godot running): **GREEN.** `check_de` **677 / 0 / 0 notices**; the harness 22 / 382 / 8; the sanctioned reds as their rows hold them (`check_cm_live` 13 / 5, `check_gj` 70 / 1 at +169 / 189); every target inside its band (`test_batch_an` 6,048, its unseeded map); IY's moved rows at their counts (`check_gp` 454, `check_ix` 119, `check_iy` 121, `check_parse` 241); 0 `Parse Error` and 0 `SCRIPT ERROR` in any log (17:23:07–18:49:08). **Re-checked after it: the 30 landed files still byte-identical to the freeze**, and the repository's diff exactly those 30.

**THE PUSH CHECK.** `git ls-remote origin class-merge` read `fa24c3b`, IX's push and local HEAD, before anything ran (11:52);
the close's push is the batch's last act, reported with the commit.

**THE TWO READINGS** stand in `docs/state.md`'s WHERE block at their fixed point, each a measured size and never a share:
**`CLAUDE.md` is 494,798 B = 483.20 KiB against its 510 KiB ceiling — 26.80 KiB under** (+2,768 B at IY, nothing cut), and
**`docs/state.md` is 355,950 B = 347.61 KiB against its 380 KiB ceiling — 32.39 KiB under** (that reading included; the file is the
size it says). The changelog stands at 390,847 B of its 400,000 bar — FOUND AT IY says the next entry likely crosses it.
