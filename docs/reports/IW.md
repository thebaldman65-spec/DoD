# Batch IW — the ladder with resolution, and the deck's middle

**On `class-merge`, after IV (`b462bc3`). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `b462bc3`, IV's push and local
HEAD, before anything ran (2026-10-25 09:59). **The designer's files were backed up first** (`../save-backups/IW-20261025-100215`,
10:02:15, byte-identical to IV's backup by `diff -r`) and read only through copies — md5s at the open and the close, §5.

**What shipped.** **A screen before a ladder**: nine candidate populations read on five modifiers each, the criterion and its floor
written before the first run, chose the sim's default party untalented at Wanderer (a spread of 20.1 of its own two standard errors,
the incumbent's 12.3); the instrument's fidelity was proved before any reading was used (IV's forced arm reproduced line for line; the
probe spends no die); and **the full ladder on the winner** — twenty-three modifiers at sixty runs — spreads the deck over 8 levels and
re-orders it, **but two of its four cuts fall inside a level, so §2 took arm B by the rule written before the ladder ran: no grade
moved, and the 19 grades the measurement does not support are listed with their handles for the designer** (§1–§2). **Every figure IV
marked is re-taken** — IV's twelve arms re-driven on IV's seeds reproduced its second arm line for line — and **the two IV could not read
are read**: Rupture stands at 1.7% of a Cryomancer's turns; a Warrior gains about 21 Rage a turn (§3). **GK's three names are
confirmed** and no claim stands (`check_iu`'s ceiling 2 → 0); **`lane.sh` refuses a lane in use by name and pid and hands out another**;
**`DOD_ZONE_ROTATION` is the sim's** (§4). `check_iw` is new. **No player-facing word on a card, rune or status moved**; a player's run
no longer reads the zone switch, and `docs/master.html` says so. No data file and no save version moved.

**VERDICT: IMPLEMENTED.** The screen and the ladder taken by rules written before each ran; arm B — no grade moved, no modifier authored, the nineteen and the party the designer's; the eleven re-taken and the two read; the names confirmed, the lock built and driven, the zone flag the sim's; recon 2 exactly as predicted, all thirteen controls bit, the acceptance green bar the two sanctioned reds.

---

## §0 — THE BRIEF's PREMISES, VERIFIED (CLAUDE.md: verify the brief against the repo)

| # | the brief says | verdict |
|---|---|---|
| 1 | `git ls-remote origin class-merge` reads IV's push and local HEAD | **True** — `b462bc3` both, before anything ran (09:59). |
| 2 | IV drove all 23 forced arms and every one tied | **True** — IV §1c: the 23 grade readings and the three rung means, 26 ties. |
| 3 | nineteen of the arms IV printed sit between 0.894 and 0.954 (a spread of 0.060 against 2se ≈ 0.010), Overgrown at 0.815 the first real step down | **True of IV's HEAD column** (IU's tree): Miasma 0.894 to Hoarfrost 0.954, 0.060; se 0.004–0.010, so 2se about 0.010–0.016; Overgrown 0.815. **On IV's own column — the tree HEAD is now — the nineteen sit 0.890–0.955 (0.065) and Overgrown at 0.839.** |
| 4 | the deck's hole was read off that instrument, and so was the 0.78–0.86 target | **True** — `docs/state.md`'s grades block: IP's figures, the target set at IQ §0.5. |
| 5 | §0.1: *a Hierophant* carries 84 of that spine's 92 record rows; *a Vanguard-taker*, *an Invoker-taker* are the kit recon's | **True** — IV §4's census (`docs/reports/IV-spines.tsv`). |
| 6 | §0.1: ISN04 and ISF12 become REPAIRED, **which empties the standing-claims ceiling of 5 down to 3**; §4: *the ceiling falls from 5 to 3* | **False in its numbers, true in its direction.** IV §4 already repaired three (IR01, IR09, IR50) and moved `check_iu`'s `CLAIMS_CEILING` 5 → 2 (IV's WHERE block says so). Repairing the last two takes it **2 → 0**. The direction is built — the ceiling falls; the arm is not loosened — and the magnitude is the code's, not the brief's (C02 below reads it at 0). |
| 7 | §0.1: what comes out — `CLAUDE.md`'s parenthetical, `docs/state.md`'s RULINGS OWED item, `docs/kit-recon.html:17` and its three rows, `docs/changelog.html:3130` | **True, with one line moved**: the changelog sentence stands at line 3154 (IV's entry above it moved it; IV's spine census recorded 3130 at `91ce490`). **And one more place the sweep found**: `docs/state.md`'s THE THREE SPINES block, *names proposed*. The derived population — every live text file, a spine name within a sentence of the word — is eight passages in four files; all eight are struck. |
| 8 | §0.2: `check_ho` read 179 / 2 beside three gates in one lane, 179 / 1 beside one, 179 / 0 alone | **True** — FOUND AT IV. |
| 9 | §0.3: gate it on `sim`, with the other five | **True in intent; the flag's door is `Run`'s, so its gate is `sim_run`** — the run sim's flag, which `runes_mode`, `rune_econ` and `rune_power` read beside it (`battle.gd`'s `sim` is the battle's). `RunSim.begin` sets it before the draw, so the sim's arm still arms (driven). |
| 10 | §0.3: *the day a slot pool holds two zones, the sim can force one for a measurement and the player gets the draw* | **False in today's code.** `Run.draw_zones` takes `pool.pick_random()` only while the rotation is enabled and `pool[0]` otherwise — so with the flag the sim's, **a player's run draws each pool's FIRST zone**, and a second zone in a pool is one no player can draw. Built as ruled; **the latent arm stays armed** (`check_iv` §2) with its reason re-pointed to this, and FOUND AT IW records it. |
| 11 | §0.3: the sweep derived five leaking flags where the brief named two | **True** — IV §2. |
| 12 | §1: IV's rebuilt arms read Hoarfrost 0.954 against IP's 0.963 and Overgrown 0.815 against IP's 0.857 | **True** (IV's HEAD column). |
| 13 | §1a: IG's Hierophant party untalented went 25% → 50% completed, depth +3.5, while every default-build arm tied | **True** — IV §1c. |
| 14 | §1: 60 a side gave se 0.005 | **True for the crowd** (0.004–0.007); the cliff's arms read 0.013–0.016. |
| 15 | §3: the eleven re-takes — six supply rows, EQ's 6.98 bought and 3.44 acquired, IG's Hierophant completion, Tinderbox's and Miasma's, the Hunter's bar | **True as eleven marks**: the six supply rows (EQ's 3.44 acquired is the supply mark's), EQ's 6.98 bought, the Hierophant completion, Tinderbox's and Miasma's completion, the bar. |
| 16 | §3: *most fall out of §1b's runs — the supply figures are read at a run's end and §1b runs 23 arms* | **False.** The supply figures, the shop line, the Hierophant completion and the bar are each a NATURAL run's figure — the bot's own bargains, no forced modifier — on IG's three parties at their own rung; §1b forces one modifier on every bargain of one population at one rung. **§1b reaches none of the eleven** (Tinderbox's and Miasma's completion are the incumbent's forced arms, and the winner is not the incumbent). **So the re-takes are a drive of their own**: IV's twelve arms re-driven on HEAD on IV's own seeds (§3). |
| 17 | §3: FOUND AT IF's Rupture rate (the probe books no cast) and BOIL OVER's HZ figures (the probe reads Mana bars only) could not be read by IV | **True** — IW's printing part carries both (§3). |
| 18 | §5: `./lane.sh spent` prints the one command | **True.** |
| 19 | §6: 438 pins, thirteen standing positional picks, 188 cheap gates (76 NONE) | **True** — `CLAUDE.md`'s pin line (438 at IT), `check_iu`'s `MISSES_CEILING` 13, `check_iv` §5's ceilings 188 / 76. |
| 20 | §7: §6's population rows are available to the routing now, which IV's were not | **True** — IV's routing said so; IW's is the first routed with them (`docs/reports/IW-routing.md`). |
| 21 | the two readings: `docs/state.md` 44.05 KiB under, where it had 61.37 before IV's population rows | **True** — IV's close: 344,016 B against 380 KiB. |

## §0 — THE RULINGS, AND WHERE EACH IS WRITTEN

`check_iw` §0 pins each by its own words, in the file whose subject it binds, every needle on one line:
- **§0.1** — *A NAME THE PROJECT's OWN PROSE TOOK UP AS THE THING's NOUN HAS ALREADY PASSED THE TEST A NEW NAME WOULD HAVE TO PASS*:
  `CLAUDE.md`, a bullet of the name-sweep block (*SWEEP A NAME AGAINST THE WHOLE ROSTER BEFORE AUTHORING IT*), with the census that
  made it (IV §4) and the engines each name fits.
- **§0.2** — *A REFUSAL WITH NO WAY FORWARD IS A RULE WEARING A LOCK's CLOTHES*: `docs/instrument-rules.md`, a bullet of IQ §7's lane
  block, beside IU §7's affordance rule it repeats the shape of; and `lane.sh`'s header, where a reader of the driver meets it.
- **§0.3** — *A FLAG THAT CHANGES WHAT A RUN CONTAINS IS THE SIM's, UNLESS THE PLAYER CHOOSES THAT CONTENT SOMEWHERE ELSE TOO*:
  `CLAUDE.md`'s debug table, beside IV §2's *a sim-family flag is read by a sim only*; `DOD_ZONE_ROTATION` moved from the non-sim
  list to it.
- **§1** — *RESOLUTION COMES FROM A POPULATION WHOSE SUBJECTS DIFFER MORE, NOT FROM MORE RUNS*: `docs/instrument-rules.md`, a bullet
  of the tie rule's block (IP §0.4), with the screen's procedure — the criterion and the floor written before it runs — and the
  fidelity proof beside it.

---

## §1 — THE LADDER, ON A POPULATION THAT CAN FEEL IT

### §1a — THE SCREEN, ITS CRITERION WRITTEN FIRST

**Written before the first job** (10:14:17, `IW-work/s1/PREREG.md`, md5 `96b0cb2b…`): the instrument (below), the five arms — **ranks 1, 7, 12, 17 and 23 of IV's own sort** (IV's B column, the tree HEAD is): Dull Edge, Muffled, the Long Silence, the Thin Veil, Wasting, spaced by rank so the crowd is read three times and the cliff once — thirty runs an arm, **R5** (the spread of the five readings over their mean 2se; it decides) and **R4** (the same over the four above the lowest — the crowd's own resolution, the quantity the brief's problem statement measures; a diagnostic that could only have asked for a second ladder), **the floor 4 on the best R5**, and the candidates with the ones considered and dropped. **The candidates, derived from what IV's drive shows moving**: the natural default build tied everywhere and the weakest population moved, so a population near the margin of failure is one where a modifier's cost shows — the incumbent, and IG's three parties, IG's Hierophant population and the sim's default party untalented, each on its own rung and the rung above, and one tier on Ruin. **Dropped**: the incumbent's higher rung (there is none), the default build on a lower rung (less movement), the Hierophant population and the default party untalented on Ruin (C4 measures untalented Ruin's attrition once), two tiers on Ruin (the question after C9), the natural arms (the bot takes the gamble, IN §1a), more runs on the incumbent (the brief's expensive answer).

| candidate | Dull Edge | Muffled | the Long Silence | the Thin Veil | Wasting | R5 | R4 |
|---|---|---|---|---|---|---|---|
| **the sim's default party, untalented, Wanderer** | 0.949 ± 0.005 | 0.940 ± 0.007 | 0.887 ± 0.007 | 0.891 ± 0.008 | 0.574 ± 0.020 | 20.06 | 4.52 |
| IG's Hierophant population, untalented, Wanderer | 0.872 ± 0.014 | 0.880 ± 0.011 | 0.792 ± 0.015 | 0.822 ± 0.016 | 0.454 ± 0.020 | 13.75 | 3.08 |
| IG's three parties, all 27 nodes, Ruin — **the incumbent** | 0.950 ± 0.006 | 0.948 ± 0.005 | 0.922 ± 0.008 | 0.890 ± 0.013 | 0.676 ± 0.023 | 12.29 | 3.70 |
| the sim's default party, untalented, Warden | 0.837 ± 0.015 | 0.828 ± 0.015 | 0.699 ± 0.018 | 0.712 ± 0.022 | 0.436 ± 0.019 | 11.26 | 3.96 |
| IG's three parties, untalented, Wanderer | 0.883 ± 0.017 | 0.896 ± 0.014 | 0.848 ± 0.016 | 0.820 ± 0.017 | 0.490 ± 0.029 | 10.98 | 2.39 |
| IG's three parties, one tier (nine nodes), Ruin | 0.847 ± 0.020 | 0.829 ± 0.023 | 0.774 ± 0.023 | 0.763 ± 0.025 | 0.468 ± 0.029 | 7.82 | 1.84 |
| IG's Hierophant population, untalented, Warden | 0.698 ± 0.029 | 0.737 ± 0.026 | 0.557 ± 0.029 | 0.562 ± 0.035 | 0.336 ± 0.022 | 7.06 | 3.01 |
| IG's three parties, untalented, Warden | 0.725 ± 0.034 | 0.729 ± 0.039 | 0.672 ± 0.023 | 0.613 ± 0.043 | 0.394 ± 0.033 | 4.88 | 1.68 |
| IG's three parties, untalented, Ruin | 0.626 ± 0.042 | 0.624 ± 0.046 | 0.496 ± 0.041 | 0.446 ± 0.037 | 0.286 ± 0.034 | 4.25 | 2.15 |

**The winner is the sim's default party untalented at Wanderer — R5 20.06, the floor cleared — and it is also the only candidate whose crowd clears 4 (R4 4.52)**, so the pre-registered disagreement rule did not fire and there is one ladder. **Two findings in the losers**: breadth costs resolution — IG's three parties under the same terms read 10.98, their party-to-party spread noise to a ladder (FOUND AT IW) — and the incumbent's R5 (12.29) is high only because its cliff is deep and its noise small: its crowd reads 3.70, under the floor. One tier on Ruin (C9) and every Warden and Ruin untalented population read lower: past the margin, runs end early and the noise grows faster than the spread.

### §1b — THE INSTRUMENT's FIDELITY, PROVED BEFORE ITS READINGS WERE USED

- **The seeds**: each run seeded `block × 100003 + i` (`i` its index in the job); one block a population, so its arms are paired by seed — the incumbent 21 (IO's, IV's), the winner 38. **The run count**: the screen thirty an arm; the ladder sixty (IO's), as one sixty-run job a modifier for the one party.
- **A bargain fight's end**: the party's health read at the top of `RunSim.on_battle_end`, before any victory heal — Σ living heroes' health over Σ maximum, a fallen hero 0, companions out, a lost fight 0. **A bargain fight** is an elite, and the mini-boss where the rung lets it offer a bargain (Wanderer, Warden; Ruin's arms a fixed modifier, IR §1a) — so on the winner's Wanderer it is both. Per run the mean of its bargain fights; per arm the mean over runs, ± sd/√n — the run is the unit. **The *none* arm** lays no modifier, so its bargain fights are read by node: IV's reader counted a bargain fight only where a modifier stood, and could not read its own *none* arm's.
- **The probe is IV's, byte for byte** (parts one and two, md5s in the pre-registration), with a third part that only prints (a Mage's turn: a Rupture on any living enemy; a Warrior's: his Rage, his spent ledger, the damage credited to him, his Attack).
- **THE PROOF, PRINTED**:

```
C1_dulledge_P0.log           6166 [IVP] lines  IDENTICAL to IV
  C1_dulledge_P1.log           6572 [IVP] lines  IDENTICAL to IV
  C1_dulledge_P2.log           5028 [IVP] lines  IDENTICAL to IV
  C1_long_silence_P0.log       6053 [IVP] lines  IDENTICAL to IV
  C1_long_silence_P1.log       6860 [IVP] lines  IDENTICAL to IV
  C1_long_silence_P2.log       6014 [IVP] lines  IDENTICAL to IV
  C1_muffled_P0.log            6496 [IVP] lines  IDENTICAL to IV
  C1_muffled_P1.log            6561 [IVP] lines  IDENTICAL to IV
  C1_muffled_P2.log            4975 [IVP] lines  IDENTICAL to IV
  C1_thin_veil_P0.log          4919 [IVP] lines  IDENTICAL to IV
  C1_thin_veil_P1.log          5875 [IVP] lines  IDENTICAL to IV
  C1_thin_veil_P2.log          4335 [IVP] lines  IDENTICAL to IV
  C1_wasting_P0.log            5276 [IVP] lines  IDENTICAL to IV
  C1_wasting_P1.log            4741 [IVP] lines  IDENTICAL to IV
  C1_wasting_P2.log            4226 [IVP] lines  IDENTICAL to IV
(1) REPRODUCTION: 15 of 15 C1 logs reproduce IV's B logs line for line over their first ten runs
(2) NO RANDOMNESS SPENT: run lines 10 vs 10, IDENTICAL; every non-probe line of the log (the sim's own output and report) 194 vs 194, IDENTICAL
```

So HEAD is IV's tree for every figure IW reads, the drive is deterministic, a job's first ten runs are its first ten whatever its length, and the probe — the turn hook that calls the rotation's pick a second time included — spends no die: the run lines and the sim's own report are the same with its reads switched off.

### §1c — THE LADDER, ON THE WINNER — AND IT REPLACES THE RECORD

**All twenty-three forced arms and the *none* arm, sixty runs each, the sim's default party (the Berserker, the Cryomancer, the Devout, the Beastmaster) untalented at Wanderer, block 38** (11:02 → 12:50; the kept table `docs/reports/IW-ladder.tsv`). **This measurement replaces the record rather than checking it: the new figures are the ladder's, IP's are superseded** — and IV's rebuilt arms were never the record's either (IV §1c). With no modifier the party's Wanderer bargain fights end at 0.944.

| modifier | IW's reading | runs completed | grade (as it stands) | IO's cut on IW's sort | level | supported |
|---|---|---|---|---|---|---|
| Dull Edge | 0.950 ± 0.004 | 58 of 60 | 1 | 1 | 1 | **no** |
| Parched | 0.945 ± 0.004 | 58 of 60 | 1 | 1 | 1 | **no** |
| Tinderbox | 0.944 ± 0.005 | 58 of 60 | 1 | 1 | 1 | **no** |
| Frenzied | 0.943 ± 0.005 | 51 of 60 | 1 | 1 | 1 | **no** |
| Muffled | 0.943 ± 0.004 | 58 of 60 | 2 | 1 | 1 | **no** |
| Fleeting | 0.940 ± 0.005 | 58 of 60 | 2 | 1 | 1 | **no** |
| Hoarfrost | 0.939 ± 0.005 | 53 of 60 | 1 | 2 | 1 | **no** |
| Deadened | 0.938 ± 0.004 | 55 of 60 | 3 | 2 | 2 | **no** |
| Brittle | 0.936 ± 0.005 | 53 of 60 | 2 | 2 | 2 | **no** |
| Slick Footing | 0.936 ± 0.006 | 58 of 60 | 2 | 2 | 2 | **no** |
| Bloodletting | 0.935 ± 0.005 | 57 of 60 | 2 | 2 | 2 | **no** |
| Encumbered | 0.927 ± 0.006 | 57 of 60 | 2 | 2 | 2 | **no** |
| Feverish | 0.920 ± 0.006 | 54 of 60 | 3 | 3 | 3 | **no** |
| Warded | 0.918 ± 0.008 | 55 of 60 | 1 | 3 | 3 | **no** |
| The Thin Veil | 0.896 ± 0.006 | 56 of 60 | 3 | 3 | 4 | **no** |
| The Long Silence | 0.895 ± 0.005 | 55 of 60 | 3 | 3 | 4 | **no** |
| Miasma | 0.892 ± 0.007 | 53 of 60 | 4 | 4 | 4 | **no** |
| Rot | 0.857 ± 0.008 | 43 of 60 | 4 | 4 | 5 | yes |
| Overgrown | 0.854 ± 0.009 | 54 of 60 | 4 | 4 | 5 | yes |
| Mirrorbound | 0.788 ± 0.009 | 52 of 60 | 5 | 4 | 6 | yes |
| Thin Air | 0.734 ± 0.014 | 26 of 60 | 4 | 5 | 7 | **no** |
| Bloodless | 0.702 ± 0.010 | 40 of 60 | 5 | 5 | 7 | **no** |
| Wasting | 0.579 ± 0.016 | 33 of 60 | 5 | 5 | 8 | yes |

**What moved against the incumbent** — the same rule on IV's re-driven incumbent reads six levels; this population reads 8, and its order is not the incumbent's (Spearman's ρ 0.775 against the incumbent on HEAD, 0.860 against IP's figures, where the incumbent and IP agree at 0.928): **Deadened** 18th → 8th, **Parched** 11th → 2nd, **Thin Air** 13th → 21st (twenty-six of sixty runs completed), **Bloodletting** 4th → 11th, **Brittle** 15th → 9th, **Hoarfrost** 2nd → 7th. An untalented party leans on what these take — its resource returning, its armour, a cheap Break — where a fully talented one has slack.

## §2 — THE BRANCH: ARM B

**THE ARM's RULE WAS WRITTEN BEFORE THE LADDER RAN** (10:31:48, `IW-work/s1/PREREG2.md`, md5 `df32fecb…` — written while the screen ran, with two candidates' screens already read and said so in the file): a LEVEL opens at the cheapest reading and holds every next one within two standard errors of the difference of its first (IP §0.4's tie rule); a CUT at IO's counts (6 / 6 / 4 / 4 / 3) is real when its two neighbours sit in different levels; **ARM A when the best R5 is 4 or more and every cut is real**, arm B otherwise. *The brief's arm A asks that the costs spread across the range and never says what that is; IV had shown why it must be said first — a cut inside a cluster moves on a second reading.*

| cut | the two either side | apart | in standard errors | |
|---|---|---|---|---|
| 1|2 | Fleeting \| Hoarfrost | 0.001 | 0.16 | **inside one level** |
| 2|3 | Encumbered \| Feverish | 0.007 | 0.83 | **real** |
| 3|4 | The Long Silence \| Miasma | 0.003 | 0.32 | **inside one level** |
| 4|5 | Mirrorbound \| Thin Air | 0.054 | 3.20 | **real** |

**ARM B.** Two of the four cuts fall inside a level, so on this population, as on the incumbent, the five grades are not five levels, and a re-cut would move modifiers across two boundaries by noise. **No grade is re-cut, none moves, and no modifier is authored.** *(§1b's "the grades are re-set from the measurement the way IO set them" is arm A's step one, read with §2's branch.)*

**THE BRIEF's ARM-B STATEMENT, READ AGAINST THE MEASUREMENT — HALF OF IT HOLDS.** *Nineteen modifiers cost a party the same amount on every population that can feel them*: **not quite** — on this population the nineteen spread over more levels than on the incumbent and re-order; **but the grades are labels where the cuts are**: the cheapest level holds seven modifiers of grades 1 and 2, and the fourth holds three of grades 3 and 4, so a player cannot feel the difference between a severity 1 and a 2 there. **Report, not re-cut** (the brief): **19 of the twenty-three carry a grade their cost does not support** — each with its handle, in `docs/state.md`'s IW's RULINGS OWED — and only Rot, Overgrown, Mirrorbound and Wasting are supported.

**AND THE LIST IS ONE READING FROM A SHORTER ONE.** The rule drew its narrowest boundary at **Deadened**, which opens its level by 0.000024 past a line 0.011477 wide (0.2% of it — the kept table carries six decimals so `check_iw` re-derives the level the rule gave; at four it rounds the other way). **Read the other side of that line, the arm is the same** (the same two cuts inside a level) **and 8 are supported, not 4** — Brittle, Slick Footing, Bloodletting, Encumbered, the grade-2 modifiers of the level it opens, joining. The list is the rule's, by a margin no re-run is promised to keep.

**The grade means and ranges, as IO printed them** (the grades as they stand, on IW's figures): grade 1 0.940 (range 0.031, 6 modifiers); grade 2 0.936 (range 0.016, 6 modifiers); grade 3 0.912 (range 0.043, 4 modifiers); grade 4 0.834 (range 0.159, 4 modifiers); grade 5 0.689 (range 0.210, 3 modifiers).

**THE GAP, MEASURED** (arm A's step two, printed on either arm): the largest interval between adjacent readings is Bloodless | Wasting, 0.123 wide (6.6 se), at the costly end; in the middle, Overgrown | Mirrorbound and Mirrorbound | Thin Air are both past two standard errors. **Warden's bargain fights on this population** (arm A's step three, read on arm B as data, not as a target): the party's natural runs — the bot's own bargains, sixty a rung — end a bargain fight at **0.869 at Wanderer, 0.647 at Warden, 0.540 at Ruin** (53, 1 and 0 of 60 completed). **My 0.78–0.86 has no standing here**, as the brief says; the interval a new modifier would have to land in depends on which party the deck is ranked by, which is the second ruling.

## §3 — THE ELEVEN RE-TAKES, AND THE TWO IV COULD NOT READ

**§1b reached none of the eleven** (premise 16): each is a natural run's figure — the bot's own bargains — on IG's three parties at its own rung, or the incumbent's forced arm, and §1b's ladder forced one modifier on one other party. **So the re-takes are a drive of their own: IV's twelve arms re-driven on HEAD on IV's own seeds** (the ten natural arms D1–D3, U1–U3, H1, H2, HS_D, HS_U and the incumbent's Tinderbox and Miasma arms, 20 runs a party; and the Cryomancer's party at sixty runs for Rupture's rate), through IV's probe and IW's printing part. **The reproduction**: 36 of 36 re-drive logs reproduced IV's B logs line for line (363,651 probe lines) — so every re-take below is IV's second arm's figure, measured again, and it is the record's now.

| the record (where it stood) | the re-take (± se, n) | |
|---|---|---|
| HR §1c's supply table — runes a hero holds at a run's end, default, Wanderer | 8.57 ± 0.11 (n=60) | re-taken |
| — at Warden | 8.64 ± 0.10 (n=60) | re-taken |
| — at Ruin | 8.34 ± 0.11 (n=60) | re-taken |
| — of them unworn, Wanderer | 2.92 ± 0.10 (n=60) | re-taken |
| — Warden | 2.88 ± 0.09 (n=60) | re-taken |
| — Ruin | 2.70 ± 0.09 (n=60) | re-taken |
| EQ's 6.98 runes bought a run (Carried from the code) | 3.36 ± 0.17 (n=30) | re-taken |
| EQ's 3.44 acquired per hero per run | 6.36 ± 0.38 (n=30) | re-taken |
| EQ's 4.57 merchants walked (not marked; one sentence) | 4.82 ± 0.27 (n=30) | re-taken |
| IO §3's untalented completion on IG's Hierophant population, 70 of 180 | 50.00 ± 6.51 (n=60) | re-taken |
| IP §1b's runs completed under Tinderbox, 59 of 60 | 100.00 ± 0.00 (n=60) | re-taken |
| — under Miasma, 51 of 60 | 100.00 ± 0.00 (n=60) | re-taken |
| IF §0.1b's bars at a turn's start with the relic, default — the Cleric 91 of 120 | 107.03 ± 1.28 (n=60) | re-taken |
| — the Mage 97 | 109.80 ± 1.39 (n=60) | re-taken |
| — the Hunter 95 (the marked one) | 105.91 ± 1.16 (n=60) | re-taken |

**THE TWO IV's DRIVE COULD NOT READ — READ, AND SAID SO.** IW's printing part carries both, and the drive that re-took the eleven carried it:
- **FOUND AT IF's Rupture rate** (3.2% of a Cryomancer's turns on IF's tree; the input to a ruling parked since HS): on IV's repaired bot — DV05's door re-ask in force — **a Rupture stands on a living enemy at the start of 1.7% of a Cryomancer's turns** (sixty default-build runs at Wanderer; per run 1.64 ± 0.47). *Read the same way IF read it: the share of his turns that open with a Rupture standing anywhere on the field.*
- **BOIL OVER's HZ figures**: a Warrior gains the Berserker 23.1 a turn (median 15, 2288 turns), the Warden 19.8 a turn (median 15, 2561 turns), the Swordmaster 21.4 a turn (median 15, 2100 turns); a bar of 100 fills in about 4.7 of his turns. **Holding 100 or more, what he dealt between two of his turns ran a median 43% (n=623) / 46% (n=444) / 57% (n=266) of his Attack** — a reading that also counts what his statuses dealt in the span, so it bounds the bot's damaging action from above, where HZ's instrumented copy read the action alone (35–54%).

**WHERE EACH IS WRITTEN**: `docs/state.md`'s new block THE SIM's FIGURES, RE-TAKEN AT IW (in the place of WHAT IV's DRIVE MOVED, which is archived whole — every mark taken), and a pointer at each place the file quoted a moved figure (THE CLERIC's MANA RATE's bars, Carried from the code's EQ sentence, FOUND AT IF's Rupture, BOIL OVER'S RATE's Rage). **No mark is left standing**: `check_iw` §3 holds every re-take written and every mark over one gone; `check_iv` §1c, re-pointed, holds the marks of anything not re-taken — none.

## §4 — THE THREE NAMES, THE LOCK, AND THE GATE

### §0.1 BUILT — THE NAMES CONFIRMED, AND THE CEILING AT ZERO

**Struck, every one the sweep found**: `CLAUDE.md`'s class-core block, *(names PROPOSED at GK)* → *(named at GK, confirmed at IW
§0.1, the designer's)*; `docs/state.md`'s IV's RULINGS OWED (archived whole, answered), GK's RULINGS OWED item 1 (archived, the section
stays with six), THE THREE SPINES' *names proposed* → *names confirmed at IW §0.1*; `docs/kit-recon.html`'s sentence and its three
rows; GK's changelog entry, whose sentence now says the names stood unconfirmed until IW confirmed them. **The derived population** —
every live text file (the rule files, the documents, the scripts, the data; the reports, the archive and the backups excepted, each
a record of what was true when written) with the word within a sentence of a spine name — read **eight passages in four files** at
HEAD and **none** after; `check_iw` §0.1 holds the sweep (220 files read) beside its positive arm, each name where a player reads it.
**The ledger**: ISN04 and ISF12 REPAIRED in place (`docs/reports/IU-claims.tsv`: disposition, the false words gone, the true words
present, the note, *repaired in place at IW*), and **`check_iu`'s `CLAIMS_CEILING` 2 → 0** — the brief's *5 → 3* was stale by IV's own
move (premise 6). `check_iv` §4, which held *only ISF12 and ISN04 standing*, re-pointed to *none standing*.

### §0.2 BUILT — ONE PROCESS A LANE, AND A LANE IN USE HANDS OUT ANOTHER

`lane.sh` gains `busy` (the pid of every Godot running in a lane: its `--path`, resolved against the process's own working directory —
the battery's `--path .` is read through `lsof`) and both launching doors, `godot` and `battery`, ask it first. **A lane in use is
refused by name and pid** — *LANE BUSY: <lane> already runs Godot (pid N)* — **and the launch runs in another**: the first idle
`<lane>-<k>` beside it that passes `check`, else a fresh clone of it named `<its name> <k>`, which stays inside the spent patterns
whenever its own name is. **Driven before it was gated** (a scratch clone, bare probes): an idle lane ran in place; a busy one — by an
absolute `--path` and by a battery's relative one — was refused by pid and its launch ran in `<lane>-2`. `check_iw` §0.2 drives the
same every battery, with a probe it makes in a scratch directory and removes after.

### §0.3 BUILT — `DOD_ZONE_ROTATION` IS THE SIM's

`Run.rotation_enabled` reads the flag behind `sim_run` (the run sim's flag, beside `runes_mode`, `rune_econ` and `rune_power`; set by
`RunSim.begin` before the draw). **Exported, a player's run does not read it; a sim does** — `check_iw` §0.3 drives both. `check_iv`
§2's row moves from NONSIM to GATED with its guard as the needle, and **its latent arm stays armed with its reason re-pointed**: with the
flag the sim's, a player's run draws each pool's first zone, so the day a pool holds two, its second is a zone no player can draw
(premise 10; FOUND AT IW). `docs/master.html` says so in its zones paragraph, and its stamp moved.

### THE GATE — `check_iw`

§0 the four rulings and the lane header; §0.1 the sweep, the names' positive arm and the ledger; §0.2 the lock, driven; §0.3 the flag,
driven; §1 the screen's and the ladder's tables, R5, R4, the levels and the cuts re-derived off the readings, the arm the tables give
written where the grades are read; §2 every grade against its row, every handle read at its source and printed; §3 every re-take
written and every mark over one gone. **Re-pointed beside it, each to its intent**: `check_iv` §1c (a re-taken figure is IW's), §2 (the
flag GATED), §4 (none standing); `check_iu` §1 (the ceiling at zero).

## §5 — HOUSEKEEPING

- **THE MOVE IS NOT ATTEMPTED** (IB §4). `./lane.sh spent` prints the one clearing command; 604 user-data folders at the open (272,376 KiB), **611 at the close** (288,340 KiB): +7, every one inside the spent patterns — the lock test's three (*DoD probe IW lock*, *… 2*, *… 2 2*; `check_iw` §0.2's drive reuses the first two every battery since), the test tree's *Dawn of Decay ID ftest* and the pre-run's three *Dawn of Decay IA pre1–3*; every other lane reused a name. The strays are the two known (`IT const probe`, `[unnamed project]`).
- **`lane.sh` for every launch** — the drive's six lanes and the seventh, the work lane, recon 1 and 2, the controls, the pre-run;
  the acceptance ran in the repository as the live project, through `./run_battery.sh`, as every acceptance does. **One process a
  lane, kept before it was built**: the drive dispatcher bound each job to a free lane of its own.
- **The designer's files** — backed up first (`../save-backups/IW-20261025-100215`, 10:02:15, byte-identical to IV's backup by
  `diff -r`) and read only through copies: `run_save.bin` (55,264 B, md5 `fcb20c91…`), the profile, the relics, the settings and the
  readout's three files, the clean run `run-20261018-194229.jsonl` (24,340 B, md5 `610bcd8c…`) — **still the one run; no newer readout
  file** at the open — and at the close (17:27:43, after the acceptance) all seven byte-identical to the backup by md5, and still no newer readout file. **§1's measurement does not change that: a sim is not a playthrough.**
- **The close's timestamp** — 2026-10-25 17:27:43, after the acceptance and before the commit.

## §6 — WHAT IS DELIBERATELY NOT DONE

- **No modifier is authored and no grade is changed** — arm B: the nineteen and the party are the designer's (§2).
- **No POLICY row of the divergence census is changed**, and the RULE count stays at 0. **The ally pools are not widened** — every
  figure IW took goes through the same bot, so a constant bias cancels.
- **`CLAUDE.md` is not indexed and nothing is struck from it** beyond the names' parenthetical, which the ruling took.
- **The 188 cheap gates are not built**; the 76 NONE rules among them stay a standing list.
- **The 438 pins stay pinned; the thirteen standing positional picks stay** under IU's ceiling; `check_it` §2c's arm is not widened;
  `check_hn` §2a's worn arm stands; the Chilled row keeps its *4*; the latent floor shapes and the Cryomancer's route stay;
  `DOD_ZONE_ROTATION`'s latent arm stays armed (its reason re-pointed, §0.3).
- **Nothing of the playthrough.** Every figure in THE FIRST CLEAN PLAYTHROUGH is still one run and one party, and no sim replaces it.
- **The player's zone draw is not made random** — today's code gives a player each pool's first zone, and changing that would move
  every run's dice; FOUND AT IW records it for the day a pool holds two.
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; the vow, the recoil floor and Anointing untouched;
  the third slot ungated; the art not commissioned; a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a
  conjunction half; Marrowfire's re-cut and `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the
  Occultist's Break card; the Skirmisher and the Tracker; Channel's tempo payout; the fallen-hero ruling and its seven things;
  Rupture's shape.

## FOUND AT IW AND NOT FIXED

- **A SLOT POOL's SECOND ZONE IS ONE NO PLAYER CAN DRAW.** With `DOD_ZONE_ROTATION` the sim's, `Run.draw_zones` gives a player each
  pool's first zone; inert while every pool holds one, and `check_iv` §2's latent arm reds the day one holds two — the draw a player
  gets is owed its door then.
- **RESOLUTION AND BREADTH PULLED APART.** The screen's winner is one party; IG's three parties under the same terms read about half
  its resolution. A ladder that speaks for every lineage at this resolution wants about three times the runs.
- **IV's READER COULD NOT READ ITS OWN *none* ARM's BARGAIN FIGHTS** (it counted a bargain fight only where a modifier stood): IW's
  reads them by node. A record of the instrument, not of the game.

## NEEDS A RULING

1. **THE NINETEEN GRADES THE MEASUREMENT DOES NOT SUPPORT** — each with its handle, `docs/state.md`'s IW's RULINGS OWED: which to
   re-cut, and by which handle.
2. **WHICH PARTY THE DECK IS RANKED BY** — the incumbent cannot tell nineteen apart; the party the screen chose re-orders them.
   One party, several, or each rung's own.

## §7 — THE ROUTING, A STEP WITH A WRITTEN OUTPUT

**Written first** (10:04, before any edit and before any measurement; `docs/reports/IW-routing.md`): the brief's ten subjects, the 38 rows
whose triggers name them and **the five population rows** (each trigger verbatim), the twelve blocks the population rows added, and the
15-block core — 65 blocks, 161,046 B of HEAD's 344,016, opened whole. **The brief's question — did the population rows route §1 and §3?**
*The sim's recorded figures* named both subjects in its own triggers and **every one of its ten members was also reached by a subject
trigger**: on §1 and §3 it routed nothing the triggers did not, so it was redundant here, not idle — it is the row that would have
routed them had the subject rows lacked their triggers. *The bot's divergences* added two blocks no subject trigger reached (FOUND AT GS,
FOUND AT GE); **FOUND AT GS bore**: its bot item — the sim bot casts a drafted card only where `Classes.draft_ability` resolves it, so the Cryomancer's *"Frostbolt the mark"* casts Magic Bolt — is a constant every figure IW took went through, the Rupture rate's most (IF's 3.2% went through it too), read as the bot's and not repaired (§6: no POLICY row changed); **FOUND AT GE did not** — its bot sentence (the sim's flat 85% roll) prices Long Draw's drain, which no figure here reads. **At the close** every block IW did not open was read whole by a reader outside the working read — 73 blocks, 129,075 B: **2 bore, none stale**; HW's RULINGS OWED was ROUTED (its glossary *Severity* entry holds on IW's ladder, and IW's ruling 2 now names it), FOUND AT GJ was NOT ROUTED — the sim figures GJ moved and nobody re-read, a re-take of §3's kind the brief did not ask for; its row given the re-take's triggers, and it joins *the sim's recorded figures*, the population row's own gap. **The index's upkeep**: 16 of 147 entries touched, 12 by hand (the routing file).

## §7 — VERIFICATION

**WHAT WENT IN BEFORE WHICH RUN.** **The routing, written, first** (10:04); **§1a's screen** (10:14 → 11:02) and **§1b's ladder** with
§3's re-take drive (11:02 → 13:28:16) — read-only against the tree, before any edit landed, each on its own lanes; **the code**
(§4's three) written into a scratch work lane during the drive, **and its parse** (`check_parse` 238 / 0 there over the `.gd` files, no `Parse Error` in
stderr; `lane.sh`, which `check_parse` reads no part of, clean under `zsh -n` and driven by `check_iw` §0.2; HEAD's `check_iv` and `check_iu` run against it first, as the rule asks: `check_iv` 115 / 1 — §4, the ledger — and `check_iu`
185 / 0); **the literal sweep over the code before recon 1's prediction** (`check_ed` named); **recon 1** with its written prediction;
**then every document**, built as scratch copies by script (`IW-work/edits/`, one replay from HEAD: `rebuild_final.sh`), swept, and
**landed behind a hash guard**; `check_iw` into the battery, the baselines rows, the manifest regenerated; **the pre-run, recon 2, the
positional re-run, the controls, the acceptance, the close-read.**

**THE PUSH CHECK.** `git ls-remote origin class-merge` read `b462bc3`, IV's push and local HEAD, before anything ran; the close's push is
the batch's last act, reported with the commit.

**THE MEASUREMENT's OWN FIDELITY** — §1b above: the seeds, the run count, how a bargain fight's end is read, what counts as the party's
health, and the probe's reads switched off reproducing its twin byte for byte, printed.

**THE SCREEN's CRITERION WAS WRITTEN BEFORE THE SCREEN RAN** (10:14:17; the first job 10:14:26), and **the arm's rule before the
ladder** (10:31:48; the first ladder job 11:02:44) — the second with two candidates' screens already read, said in its file.

**THE LITERAL SWEEPS** (IU's tool: every string literal the instruments hold, ≥ 4 characters, counted raw and flattened in each edited
file on both trees). **Over the code, before recon 1's prediction**: 25,509 literals over the four edited code files — 0 LOST, 21
GAINED, 90 MOVED; every GAINED literal walked to its holders, and the only holders that read an edited file are `check_iu` §7 and
`check_iq` §7 (`lane.sh`: presence needles, and its doors driven — the lock asks one question more before `godot`) and `check_iv` §2's own
new needle. `check_ed` named: no gate edit adds a literal-path needle. **Over the documents, before recon 2** (the final tree against HEAD, the seventeen files IW edited or wrote): 27 LOST, 906 GAINED, 992 MOVED. **Every LOST literal walked to its holders**: the tokens of the blocks IV wrote and IW archived (DV05, DV11, DV24, DV27, DV29, DV32, IR09, IR50, *SWITCH* — `check_iv`'s, re-pointed); the ledger's two repaired rows (*STANDS*, *OWED*, *'s RULINGS OWED* — `check_iu`, `check_iv`, `check_is`, `check_iw`); the spine names' flattened forms (`check_iv`, `check_iw`); and thirteen common words and phrases (*theme*, `DOD_ENEMIES_OFF`, *degree*, *drink*, *(core)*, *boss pick*, *one past* …) whose holders read them elsewhere — every holder run on the tree. **The list, run through its holders, found one the pre-run would have**: IT's strike join under item 74 (*…as a named set.* straight into *## STANDING RULE*, `check_it` §1), which IW's names bullet had split — the bullet moved up one place in its block. The GAINED ones are walked by the runs: no absence needle reds in the pre-run or recon 2.

**THE PREDICTION, AND RECON 1 — IW's code and the gate re-points on HEAD's documents** (`lanes/recon1`, beside the drive's six
processes). **Predicted** (in the working log, before its launch at 11:05:05): `check_parse` 238, `check_ed` 18 / 0 (the floor 2,040 holds), `check_ec` 24 / 0,
`check_fg` 39 / 0; `check_iv` 115 / 1 (§4: GK's two still stand in HEAD's ledger) and `check_iu` 185 / 1 (§1b: two against a ceiling of 0);
`check_iq` §7 and `check_iu` §7 green; the sanctioned reds as HEAD's; a timeout under the load the load's. **Read** (11:05:05 → 13:09:09, 156 targets): **as predicted, but for two timeouts under the drive's load** — `check_parse` 238 / 0 (no `Parse Error` in any log), `check_ed` 18 / 0, `check_ec` 24 / 0, `check_fg` 39 / 0; `check_iv` 115 / 1 (*§4: the claims left standing are ["ISF12", "ISN04"]*) and `check_iu` 185 / 1 (*§1b: 2 claims stand against a ceiling of 0*); `check_iq` 88 / 0; `check_gp` 440 / 0 and `check_gv` 1,057 / 0 inside their bounds; the sanctioned two as HEAD's (`check_cm_live` 13 / 5, `check_gj` 70 / 1); the harness 22 / 382 / 8; `check_de` 665 / 8 — the two predicted reds and **`test_batch_bk` (240 s) and `check_map` (600 s) timed out**, each re-run alone after the drive: in the pre-run, three lanes and no drive, `test_batch_bk` 131 / 0 in 136 s and `check_map` with no failure in 250 s — the load's.

**THE PRE-RUN** (the final tree rebuilt from HEAD by script; all 159 targets but the harness, on three clones of it, one process a lane, 13:43 → 14:17): every target at the final baselines but four, each read. `check_iw` 116 / 0, its new row (123 since the controls split three of its compound assertions, below). **`check_ec` 25 / 2 — a needle of `check_iw`'s that wraps in the raw `CLAUDE.md`** (*must be PRESENT in `CLAUDE.md` and is not*; the positional reader called it from the code before the run ended, and the manifest showed it as an eleventh unresolved pin): re-pointed to a phrase on one raw line, 24 / 0. `check_iu` 185 / 1 — *states no upkeep as rows touched of the total*: the routing's upkeep, which the close writes, and the test copy said so. `check_hk` 166 / 0 beside two other lanes — 168 / 0 alone on the final tree and on HEAD, an ok() trace showing every assertion the same: the load's, its row unmoved. **Found before it, by the literal sweep's holder runs, and repaired**: `check_it` §1 (the strike join, above) and `check_is` §5 — four index rows IW mended ran past 400 bytes, cut back (two keep HEAD's labels). **On the closed tree** the eleven gates those touch read their baselines: `check_iw` 116 (123 after the split), `check_ec` 24, `check_iu` 185, `check_iv` 119, `check_parse` 239, `check_is` 93, `check_it` 42, `check_ed` 18, `check_hx` 42, `check_ff` 68, `check_fg` 39, each with no failure.

**RECON 2 — the final tree, frozen** (14:32:46 → 15:59:16, 160 targets, alone but for the controls' one lane in its first minutes; relaunched once, above): **exactly as predicted.** The only reds are the two sanctioned (`check_cm_live` 13 / 5, `check_gj` 70 / 1); `check_iw` 123 / 0, `check_iv` 119 / 0, `check_iu` 185 / 0, `check_parse` 239 (no `Parse Error` in any log), `check_ec` 24 / 0, `check_ed` 18 / 0, `check_fg` 39 / 0, `check_is` 93 / 0, `check_it` 42 / 0, `check_hx` 42 / 0, `check_hk` 168 / 0, `check_gp` 440 and `check_gv` 1,057 inside their bounds, `test_batch_bk` 130 / 0 and `check_map` complete; **`check_de` 669 / 0 with 0 notices** (665 at recon 1, before `check_iw` was a target: its rows grow with the battery's); the harness 22 / 382 / 8. The md5 freeze of 597 files in the lane and 539 in the repository, the same after as before.

**THE POSITIONAL AND SUPERLATIVE RE-RUN** (IT's census re-derived on IW's final tree by a reader; the kept table is in IW's work folder, `route/positional_iw.tsv`): **489 reads — 337 unchanged by construction** (the gate and every file it reads byte-identical), **152 re-derived: 70 SAME, 55 LINE-SHIFT, and 27 in place** — the anchor and its role the same and the text IW's: the newest changelog entry, the archive's first cut, the index span, its triggers and `check_is` §6's stamp head, and twenty `docs/master.html` stamp windows that read *IW* where they read *IS* — **0 ELSEWHERE by IV's reading. 0 went from ASKS to MISSES**, and none from MISSES to ASKS: the two standing MISSES the subset holds (`returning_bodies`, `test_batch_at`'s *EXCLUSIVE talent pair*) still miss, the other eleven read files IW left alone, and IU's and IT's repairs still ask. Windows that grew onto IW's text without moving their verdict: `check_iq` §0.2's tie block (IW's two instrument-rules bullets), the battery's GATES capture (`check_iw`), `check_dv`'s heading walk (IW's entry), and four gate-corpus sweeps that gained `check_iw`. **IW's edits moved no read off its subject.**

**THE MANIFEST AND `check_ed`.** 2,040 → **2,062** (`check_iw`'s holders); the floor re-recorded, no fall; its ten unresolved pins exactly HEAD's ten — `check_iw`'s wrapped needle was an eleventh until it was re-pointed (the pre-run, above). `check_ed` 18 / 0.

**THE CONTROLS** — one fresh clone of the final tree each (`IW-work/tools/ctl_iw.py`: the anchor asserted once before the edit, three
lanes, one process a lane), read by their FAIL text, each on the subject its own predicate chose:

| | the break | the arm that red, in its own words |
|---|---|---|
| C01 | (proposed) put back in one file | `check_iw` 123 / 1 — *§0.1: 1 live passages still call a spine name proposed — the designer confirmed all three at IW §0.1: ["res://docs/kit-recon.html: …r, Pommel Strike</td></tr> <tr><td>Run…* |
| C02 | a STANDS row's words restored to the ledger | `check_iu` 185 / 2 — *§1: 1 standing claims are gone from their file — a batch repaired one: write its row's disposition: ["ISN04"]*; *§1b: 1 claims stand against a ceiling of 0 — a ceiling that does not rise: ["ISN04"]* |
| C03 | the lane lock removed (two launches into one lane, driven) | `check_iw` 123 / 5 — *§0.2: lane.sh's `godot` door launches without asking whether the lane is in use*; *§0.2: DRIVEN — a second launch ran in a lane already running Godot (pid 65560): two processes in one lane share its user:// and race the harness save*; *§0.2: DRIVEN — the refusal does not name the lane and the pid it found running there*; *§0.2: DRIVEN — a lane in use was refused with no way forward: no lane was handed out (a refusal with no way forward is a rule wearing a lock's clothes)*; *§0.2: DRIVEN — the launch did not run in the lane handed out:  lock', not the live 'Dawn of Decay'.* |
| C04 | the lock refusing with no second lane | `check_iw` 123 / 2 — *§0.2: DRIVEN — a lane in use was refused with no way forward: no lane was handed out (a refusal with no way forward is a rule wearing a lock's clothes)*; *§0.2: DRIVEN — the launch did not run in the lane handed out: ce the harness save (IW §0.2).* |
| C09 | the hand-out announced but the launch kept in the busy lane | `check_iw` 123 / 2 — *§0.2: DRIVEN — a second launch ran in a lane already running Godot (pid 66283): two processes in one lane share its user:// and race the harness save*; *§0.2: DRIVEN — the launch did not run in the lane handed out: , and this launch runs there instead.* |
| C05 | DOD_ZONE_ROTATION ungated | `check_iw` 123 / 2 — *§0.3: `Run.rotation_enabled` reads DOD_ZONE_ROTATION with no sim gate — a flag that changes what a run contains is the sim's*; *§0.3: DRIVEN — `DOD_ZONE_ROTATION=1` reached a player's run: it changes what a run contains with nothing to say so*<br>`check_iv` 119 / 1 — *§2: 1 sim-family reads stand behind no guard — a sim's arm leaks into a player's game: ["run_state.gd|rotation_enabled|DOD_ZONE_ROTATION — its guard `return sim_run and O…* |
| C06 | a grade changed with no reading behind it (Dull Edge 1 → 2) | `check_iw` 123 / 1 — *§2: 1 modifiers carry a grade no reading is behind — every grade carries its measurement: ["Dull Edge carries severity 2, its measurement reads grade 1"]* |
| C07 | a SUPERSEDED-PENDING mark left standing over its re-take | `check_iw` 123 / 1 — *§3: 1 SUPERSEDED-PENDING marks stand over a figure IW re-took — a mark that outlives its re-take is the stale claim it was invented to prevent: ["HS_U|completed"]* |
| C08 | a matched row naming a block neither file carries (the struck-heading reading still reds it) | `check_iu` 185 / 1 — *§8: 1 matched rows name a block neither the state file nor its archive carries: ["### WHAT IV\'s DRIVE MOVED ELSEWHERE"]* |
| H01 | HEAD's code under the final gate | `check_iw` 123 / 10 — 10 arms, among them *§0.2: lane.sh's header does not say why it refuses a lane in use and what it hands out*; *§0.2: lane.sh's `godot` door launches without asking whether the lane is in use*; *§0.2: lane.sh's `battery` door launches without asking whether the lane is in use* |
| H02 | HEAD's documents under the final gate | `check_iw` 75 / 23 — 23 arms, among them *§0.1: CLAUDE.md's name-sweep block does not carry the names' ruling — a name the prose took up as the noun has passed the test*; *§0.3: CLAUDE.md's debug table does not say whose a flag that changes what a run contains is*; *§0.2: the instrument rules' lane block does not carry the lock's ruling — a refusal with no way forward is a rule wearing a lock's clothes* |
| H03 | HEAD's key reading in check_iu §8 under the final tree (a struck archive heading not read as its block) | `check_iu` 185 / 1 — *§8: 2 matched rows name a block neither the state file nor its archive carries: ["### WHAT IV\'s DRIVE MOVED", "### FOUND AT IV AND NOT FIXED"]* |
| R01 | a re-tune: the Thin Veil's handle moved at its source (THIN_VEIL_PCT) | `check_iw` 123 / 0 — **no arm reds** (§1 and §2 silent), and the gate prints *The Thin Veil Run.THIN_VEIL_PCT = 0.6*: the handle is read at its source, so a re-tune moves the table's handle and stales nothing |

**THE CONTROLS FOUND A DEFECT OF THE GATE's OWN, AND RECON 2 WAS RESTARTED FOR IT.** H02's first reading printed *ISN04's false words must be gone from CLAUDE.md and its true ones present — false found: false, true found: true* — a compound assertion red on an empty `gone` column its message did not name. Recon 2 was seven minutes in; it was stopped (the runner, then its child), `check_iw` split that assertion in three and two more compound ones (REPAIRED / IW in the tree column; handed out / ran there), 116 → 123, C09 was added for the hand-out arm the split made, the tree rebuilt, frozen again and recon 2 relaunched; every control above is the second run's, on that tree.

**EVERY NEGATIVE ANCHOR PAIRED WITH A POSITIVE ARM.** §0.1's *no file says it* beside each name where it stands and the ledger's two
REPAIRED with their true words found; §0.2's *no lane holds two processes* beside an idle lane run in place and the busy one's launch run
in the lane handed out; §0.3's *no sim-family flag is ungated* beside the sim reaching the flag.

**THE ACCEPTANCE** (`./run_battery.sh` in the repository, the live project, 16:00:58 → 17:27:20, 160 targets, the landed tree frozen across it): **as recon 2, target for target** — the two sanctioned reds alone (`check_cm_live` 13 / 5, `check_gj` 70 / 1); `check_iw` 123 / 0, `check_iv` 119 / 0, `check_iu` 185 / 0, `check_parse` 239 (no `Parse Error` in any log), `check_ec` 24 / 0, `check_ed` 18 / 0, `check_hk` 168 / 0; `check_de` 669 / 0 with 0 notices; the harness 22 / 382 / 8; no timeout. The md5 freeze of the repository's 545 files the same after as before. **After it, the report alone moved**: its five close fields (the verdict, the folders, the designer's files, the timestamp and this paragraph) were written into `docs/reports/IW.md`, which no gate reads — `tools/land.py` re-proves it: no `.gd` in the tree holds its path outside a comment.

**THE TWO READINGS** (IQ's method on both files: the net, what was cut to the archive, fenced structure apart). `CLAUDE.md` **489,977 B = 478.49 KiB, 31.51 KiB under its 510** — +1,582 B, nothing cut: the names' ruling +925, the zone flag's ruling +388, the ladder's re-measure +239, the class-core parenthetical's *PROPOSED* made *confirmed* +30. `docs/state.md` **345,195 B = 337.10 KiB, 42.90 KiB under its 380** — +1,179 B net, **+375 B of it inside the index's fence** (three rows written, three gone with their blocks, six mended) **and +804 B outside it** (the growth record stays ES's +13,700 either way); the archive took 15,672 B, the closed blocks and items word for word under the cut's heading. Both readings are written in `docs/state.md`'s WHERE block at their fixed point (the line counts itself).
