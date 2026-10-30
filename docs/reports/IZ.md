# Batch IZ — the placing, two re-keys, and a removal

**On `class-merge`, after IY (`5f22c19`). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `5f22c19e`, IY's push and local
HEAD, before anything ran (2026-10-26 22:28). **The designer's files were backed up first** (`../save-backups/IZ-20261026-222914`,
22:29:14, byte-identical to IY's backup by `diff -r`) and read only through copies — md5s at the open and the close, §8.

**What shipped.** **The sharper reading of one population replaces the blunter** (§0.1): the old values and the cheap end were
re-read on the fight-seeded instrument before anything was placed — Slick Footing at 0.5 (+0.71 ± 0.28) and Fleeting at 1
(+0.92 ± 0.26) were never free, Hoarfrost at 3 is (-0.45 ± 0.32), Encumbered is a 1 (+1.09), Feverish and Warded 2s — and **4 of the
11 IX called free were under the old instrument's reach**, the twenty-seventh note's price; the scale re-derived on the sharper
readings moved two cuts a little (1.70 → 1.78, 3.70 → 3.74) and no grade crossed one (§1). **The placing** reverted Bloodletting to
15 and Slick Footing and Fleeting with it, each a 1 at its old value (§2). **Dull Edge is removed, not disabled** — a handle worth 0.15
points per ten points of crit cannot carry a bargain (§3). **Frenzied adds** — a flat amount on every speed, floored at a tenth: the add
pays the party, the subtraction costs it (+0.60 ± 0.26 at -30, a 1), and -30 shipped (§4). **Muffled was read on the incumbent** (+1.66
± 0.34, a 1) and **Tinderbox on the fire party, where it cost nothing** (+0.24 ± 0.23), so it left the deck by the stop condition
(§5). **Warden's band stays**: Wanderer's bands on it read +5.78 ± 2.16 points kinder, materially milder, and the finding is priced
(§0.4). **The changelog was cut at HR/HS** by CW §4's procedure, ahead of the documents (§6). The deck holds 21 modifiers, every one
graded: none 0; 1 7; 2 4; 3 4; 4 2; 5 4. `check_iz` is new; sixteen targets are re-pointed, each to its intent, one of them an instrument defect IZ's own edit exposed (`check_iu` §7, §9). **No save
version moved.**

**VERDICT: SHIPPED, AND VERIFIED: the sharper reading of one population replaces the blunter, and on it the old values and the cheap
end were re-read before anything was placed — 4 of the 11 modifiers IX called free were under the old instrument's reach, the
twenty-seventh note's price — and the scale re-derived on the sharper readings moved two cuts a little and no grade; Bloodletting,
Slick Footing and Fleeting went back to their old values, each a 1; Dull Edge is removed, not disabled, on the reason the brief gave;
Frenzied adds a flat amount where it multiplied — the add pays the party and the subtraction costs it, so -30 shipped, a 1, its words
unmoved and now reading a slow-down as a negative speed-up; Muffled is a 1 on the talented incumbent, and Tinderbox, costing nothing
even on the party that deals the most fire, left the deck by the stop condition; Warden's band stays, materially milder moved and the
finding priced; the changelog was cut at HR/HS. The deck holds 21, every one graded: none 0; 1 7; 2 4; 3 4; 4 2; 5 4 — grade 4 the
hole. The acceptance read `check_de` 681 / 0 / 0 notices, the harness 22 / 382 / 8 and the sanctioned reds alone; twelve controls
bit; the positional re-run moved no verdict. Three rulings are owed — the first, Frenzied's words.**

---

## §0 — THE BRIEF's PREMISES, VERIFIED (`CLAUDE.md`: verify the brief against the repo)

Read against `docs/state.md`, `docs/reports/IY.md`, `IY-handles.tsv`, `IY-reach.tsv` and `IY-seeding.tsv` and the code before anything ran.

| # | the brief says | verdict |
|---|---|---|
| 1 | Bloodletting at its old value read +0.80 ± 0.30 on the new instrument (IY's control C02d), where IX read 0.87 ± 0.65 | **True** — `IY.md` §8's C02d and IY's FOUND item, word for figure. |
| 2 | *so three of the eleven were never free* | **Four, measured** (§1): Slick Footing, Fleeting, Bloodletting and Brittle on the reference party, each re-read at IX's own value; at the brief's writing only Bloodletting's had been read on this instrument, so *three* was a forecast. |
| 3 | four still cost nothing; two cannot be tuned at all, and two key on something only some builds do | **True at IY's values** (IY §2: Dull Edge, Tinderbox, Frenzied, Muffled); Tinderbox, though *keyed on what only some builds do*, cost nothing on its own population too (§5), so three left the free list by grading or re-key and two by removal. |
| 4 | *every grade resting on IX's run-seeded reading* owed the re-read | **Eight grades rested on one** (Encumbered, Feverish, Warded, the Long Silence, Rot, Thin Air, Bloodless, Wasting); §1 re-read the three the brief named (Encumbered, Feverish, Warded) and added the reference readings of Deadened and Brittle (graded by the incumbent, so their re-reads move no grade). The other five sit far from a cut (the nearest, the Long Silence, 1.14 points over the 3.74 cut at 2.0 standard errors) and are not re-read. |
| 5 | the changelog stands at 390,749 B | **390,847 B at IY's close**; 390,749 is IY's figure before its last sentence (+98 B). IZ's own entry (about 4 KB) **would not have crossed** 400,000: the cut is taken a batch early, by the brief's order. |
| 6 | *a removal owes the save a re-ask (IO's rule, carried at IP)* | **The rule is IQ §4's, and it says the opposite**: *a removal owes the save a GUARD, not a re-ask*; IP's own citation was FD §1 (an offer re-asked at its answer). The guard (`Run._drop_stale_offer_options`, in `load_run`) drops any option naming an id the deck does not hold, so it covered Dull Edge and Tinderbox by construction; only its comment's list of removals moved, and `check_iz` §3 drives it both ways. |
| 7 | crit would have to rise by 170 points for Dull Edge to cost a 2 | **2.48 / 1.452 is 171 points of slope** — and from the floor's own reading (-0.54) about 210; the floor is every unit's base crit gone, so no value reaches it either way (design-notes). |
| 8 | Muffled's population is *IV's: the talented default build at Ruin* | **IV's population is IG's three parties**, talented, all nodes, Ruin — the incumbent IY §4 graded Deadened and Brittle by; Muffled was read there (§5), its own *none* arm beside it. |
| 9 | *§6's band arms* | §0.4's — the band arms are §0.4's ruling; §6 is the changelog. |
| 10 | Warden's moved band would hold *seven gambles* | **Six** on IZ's deck (severity 3–4: Deadened, the Long Silence, the Thin Veil, Miasma, Rot, Overgrown) — seven was IY's deck, with Bloodletting a 3. |
| 11 | Tinderbox's population is *the Mage's fire lineage* | **Derived, not chosen** (§5): the default four with the Pyromancer for the Cryomancer carry 15.9% of their strike damage as fire, three times the reference party's 5.3% — the party whose strikes carry the most fire of the two the sim seats. |

## §0 — THE RULINGS, AND WHERE EACH IS WRITTEN

- **§0.1 — THE SHARPER READING OF ONE POPULATION REPLACES THE BLUNTER** (Encumbered a 1): `CLAUDE.md`'s ladder block, beside the scale
  (`check_iz` §0); the comment above `Run.MODIFIERS`; `docs/state.md`'s grades block.
- **§0.2 — THE PLACING WAITS ON §1; BLOODLETTING REVERTS TO 15; SLICK FOOTING THE CANDIDATE** — built (§2): Slick Footing and Fleeting
  reverted with it, §1 having found each a cost at its old value.
- **§0.3 — THREE PROBLEMS, NOT ONE**: Frenzied re-keyed (§4); Dull Edge removed (§3); Muffled and Tinderbox read on the populations
  their rules name (§5) — and the stop condition, *keyed on what every build does and still costs nothing leaves the deck*, written in
  `CLAUDE.md` beside the scale with the removal's reason, verbatim (`check_iz` §0).
- **§0.4 — WARDEN's BAND, TWO ARMS** — measured and kept (§0.4 below, the band section); the finding priced in `docs/state.md`'s
  grades block and IZ's RULINGS OWED 3.

## §1 — THE OLD VALUES AND THE CHEAP END ON THE SHARPER INSTRUMENT

**The instrument**: HEAD (`5f22c19`, IY's deck) with IX's four probe parts (md5s as IY's), the reference party — the Berserker, the
Cryomancer, the Devout and the Beastmaster — untalented, at Wanderer, seed block 38, sixty runs an arm, fight-seeded
(`DOD_SIM_FIGHT_SEED=38`), every bargain forced to the arm's modifier, paired by seed against a re-driven *none* arm (IX's pairing).
**Read-only**: each old value was a lane's constant, never the repository's. Ten lanes, one process a lane, bound job to lane.
**Fidelity first**: a ten-run repeat of the *none* arm on another lane read its first ten line for line (11,876 probe lines, 20 run
lines) — the seed is the node's, and the instrument deterministic across lanes.

**The *none* arm**: 0.934103 ± 0.005685 (60 runs, 52 completed) — a tie with IY §2's 0.934130 (z -0.00).

| modifier — the value read | the reading it replaces | IZ's reading (fight-seeded, paired) | z | ratio | the tie | band |
|---|---|---|---|---|---|---|
| Slick Footing — 0.5 | +0.75 ± 0.71 (IX §1, run-seeded) | **+0.71 ± 0.28** | +2.52 | 0.351 | z -0.06 | **1** |
| Fleeting — 1 | +0.41 ± 0.62 (IX §1, run-seeded) | **+0.92 ± 0.26** | +3.57 | 0.302 | z +0.76 | **1** |
| Hoarfrost — 3 | +0.51 ± 0.60 (IX §1, run-seeded) | **-0.45 ± 0.32** | -1.39 | 0.433 | z -1.41 | **—** |
| Encumbered — as it stands | +0.74 ± 0.32 (IY §1, fight-seeded) | **+1.09 ± 0.31** | +3.48 | 0.412 | z +0.79 | **1** |
| Feverish — as it stands | +2.42 ± 0.75 (IX §1, run-seeded) | **+3.15 ± 0.38** | +8.39 | 0.395 | z +0.88 | **2** |
| Warded — as it stands | +2.54 ± 0.88 (IX §1, run-seeded) | **+1.96 ± 0.31** | +6.36 | 0.336 | z -0.62 | **2** |
| Deadened — as it stands | +0.54 ± 0.58 (IX §1, run-seeded) | **+0.40 ± 0.29** | +1.38 | 0.373 | z -0.21 | **—** |
| Brittle — as it stands | +0.75 ± 0.66 (IX §1, run-seeded) | **+2.00 ± 0.35** | +5.75 | 0.380 | z +1.67 | **2** |

**The ratio** (paired error over unpaired) ran 0.30–0.43, median 0.38 — sharper than IY §1's 0.554 on Encumbered alone.

**§1a — THE TWENTY-SEVENTH NOTE's PRICE, SAID PLAINLY: 4 OF THE 11 MODIFIERS IX CALLED FREE WERE UNDER THE OLD INSTRUMENT's REACH,
NOT FREE.** Of the eleven (`IX-scale.tsv`, verdict *costs nothing*), seven could be re-read at IX's own values on this instrument:
**Slick Footing (+0.71 ± 0.28), Fleeting (+0.92 ± 0.26), Bloodletting (+0.80 ± 0.30, IY's control C02d) and Brittle on the reference
party (+2.00 ± 0.35) are costs** the run-seeded instrument could not resolve; **Hoarfrost (-0.45), Deadened (+0.40) and Frenzied at
1.3 (-0.05 ± 0.05, IY §1) are free** on it too. Four could not be re-read at IX's values: IY had moved their handles (Dull Edge,
Parched, Tinderbox, Muffled). Written where the eleven were recorded — `docs/state.md`'s grades block, where IX's block named them
(archived at IY) — and held there by `check_iz` §1, which derives the figure from `IX-scale.tsv` and `IZ-scale.tsv`.

**§1b — THE SCALE, RE-DERIVED.** IX §3's arithmetic re-run with the sharper readings replacing the blunter where one exists (§0.1): ten
of the levels' twenty-three readings — Frenzied (IY §1), Bloodletting (IY's C02d), and Slick Footing, Fleeting, Hoarfrost, Deadened,
Brittle, Encumbered, Feverish and Warded (§1). **Levels 1–3 cost -0.04 / 1.00 / 2.56** (IX: 0.04 / 0.93 / 2.48); **the cuts are 0.48 /
1.78 / 3.74 / 6.88 / 12.22** (IX: 0.48 / 1.70 / 3.70 / 6.88 / 12.22) — the cut between 1 and 2 moved +0.08, between 2 and 3 +0.04, the
rest 0.00 — and **no grade crosses a moved cut**. Printed: `docs/reports/IZ-scale.tsv`; re-derived by `check_iz` §1, which holds
`CLAUDE.md`, `docs/state.md` and the comment above `Run.MODIFIERS` to it (`check_ix` §3 re-pointed to the same table).

**§1c — THE PREDICTION, GRADED** (`IZ-work/s1/PREDICT_S1.md`, md5 `531ad1fd…`, written before the drive): **8 of 13 right** — the
*none* tie, Slick Footing, Encumbered, Warded, Deadened, the repeat, no errors, no cut moved past 0.2; **wrong**: Fleeting (+0.92, past
the +0.90 bound), Hoarfrost (-0.45, wrong in sign), Feverish (+3.15, past +3.0), Brittle (+2.00, past +1.3), and the ratio (0.38,
better than the 0.40–0.75 predicted).

## §2 — THE PLACING

**Every handle §1 found never free went back to its old value, the measurement kept** (§0.2): **Bloodletting 15** (+0.80 ± 0.30, a 1),
**Slick Footing 0.5** (+0.71 ± 0.28, a 1), **Fleeting 1** (+0.92 ± 0.26, a 1). **A handle still free at its old value kept IY's**:
Hoarfrost 9 (+1.03 ± 0.29 at 9, IY §2 — at 3 it costs nothing), Parched no resource (+1.90 ± 0.40, IY §2), Muffled half (§5).
Grades to 1–5 as evenly as the readings allow, and they allow this: **none 0; 1 7; 2 4; 3 4; 4 2; 5 4** against 5 / 5 / 5 / 4 / 4.
**Grade 4 is the hole** — Rot and Overgrown, the two gambles every Warden offer deals; its four empty slots are new modifiers, the
designer's to author (§7). The one measured lever between 1 and 2 not taken: **Fleeting at 3 reads +3.10 ± 0.32, a 2** (a slope
point; §1 placed it at 1).

| modifier | IW's reading | the default four's reading graded | the incumbent's | **grade** (IY's) | its population and batch |
|---|---|---|---|---|---|
| Parched | 0.945 | IY §2 +1.90 ± 0.40 (z +4.80) | +0.40 ± 0.66 (z +0.60), not the modifier as it stands | **2** (2) | the default four — IY §2 |
| Frenzied | 0.943 | IZ §4 +0.60 ± 0.26 (z +2.32) | -0.55 ± 0.21 (z -2.62), not the modifier as it stands | **1** (—) | the default four — IZ §4 |
| Muffled | 0.943 | IY §2 -0.24 ± 0.22 (z -1.07) | IZ §5 +1.66 ± 0.34 (z +4.84) | **1** (—) | the incumbent — IZ §5 |
| Fleeting | 0.940 | IZ §1 +0.92 ± 0.26 (z +3.57) | +0.15 ± 0.61 (z +0.24) | **1** (1) | the default four — IZ §1 |
| Hoarfrost | 0.939 | IY §2 +1.03 ± 0.29 (z +3.62) | -0.88 ± 0.58 (z -1.51), not the modifier as it stands | **1** (1) | the default four — IY §2 |
| Deadened | 0.938 | IZ §1 +0.40 ± 0.29 (z +1.38) | +5.23 ± 0.92 (z +5.71) | **3** (3) | the incumbent — IV, graded at IY §4 |
| Brittle | 0.936 | IZ §1 +2.00 ± 0.35 (z +5.75) | +3.34 ± 0.89 (z +3.75) | **2** (2) | the incumbent — IV, graded at IY §4 |
| Slick Footing | 0.936 | IZ §1 +0.71 ± 0.28 (z +2.52) | -0.38 ± 0.57 (z -0.66) | **1** (1) | the default four — IZ §1 |
| Bloodletting | 0.935 | IY's control C02d +0.80 ± 0.30 (z +2.65) | -0.54 ± 0.64 (z -0.84) | **1** (3) | the default four — IY's control C02d |
| Encumbered | 0.927 | IZ §1 +1.09 ± 0.31 (z +3.48) | +0.04 ± 0.58 (z +0.07) | **1** (2) | the default four — IZ §1 |
| Feverish | 0.920 | IZ §1 +3.15 ± 0.38 (z +8.39) | +2.42 ± 0.65 (z +3.72) | **2** (2) | the default four — IZ §1 |
| Warded | 0.918 | IZ §1 +1.96 ± 0.31 (z +6.36) | +0.21 ± 0.53 (z +0.40) | **2** (2) | the default four — IZ §1 |
| The Thin Veil | 0.896 | IX §1 +4.75 ± 0.70 (z +6.78) | +4.85 ± 0.81 (z +5.98) | **3** (3) | the incumbent — IV, graded at IY §4 |
| The Long Silence | 0.895 | IX §1 +4.88 ± 0.56 (z +8.76) | +2.13 ± 0.61 (z +3.51) | **3** (3) | the default four — IW, graded at IX §3 |
| Miasma | 0.892 | IX §1 +5.14 ± 0.72 (z +7.19) | +5.46 ± 0.78 (z +7.03) | **3** (3) | the incumbent — IV, graded at IY §4 |
| Rot | 0.857 | IX §1 +8.66 ± 0.83 (z +10.43) | +3.40 ± 0.69 (z +4.92) | **4** (4) | the default four — IW, graded at IX §3 |
| Overgrown | 0.854 | IX §1 +9.03 ± 0.92 (z +9.80) | +10.54 ± 1.11 (z +9.48) | **4** (4) | the incumbent — IV, graded at IY §4 |
| Mirrorbound | 0.788 | IX §1 +15.59 ± 0.98 (z +15.86) | +25.72 ± 1.66 (z +15.49) | **5** (5) | the incumbent — IV, graded at IY §4 |
| Thin Air | 0.734 | IX §1 +21.03 ± 1.38 (z +15.21) | +2.31 ± 0.74 (z +3.12) | **5** (5) | the default four — IW, graded at IX §3 |
| Bloodless | 0.702 | IX §1 +24.22 ± 1.02 (z +23.70) | +21.26 ± 1.19 (z +17.89) | **5** (5) | the default four — IW, graded at IX §3 |
| Wasting | 0.579 | IX §1 +36.53 ± 1.51 (z +24.14) | +26.26 ± 1.66 (z +15.78) | **5** (5) | the default four — IW, graded at IX §3 |

Every reading and the band each gives: `docs/reports/IZ-grades.tsv`, re-derived by `check_iz` §2 (each band under the test, the
higher of the two, the sharper reading where one exists, every row's `graded`, every severity in the game, the live constant against
the value read). `check_ix` and `check_iy` read the grades from it; IY's own grades table stays its record.

## §3 — DULL EDGE IS REMOVED, NOT DISABLED

**The reason, written**: *A HANDLE WORTH 0.15 POINTS PER TEN POINTS OF ITS QUANTITY CANNOT CARRY A BARGAIN, AND CRIT IS A QUANTITY EVERY
BUILD MAKES, SO NO POPULATION SAVES IT* — `CLAUDE.md`'s ladder block, beside the scale; its built shape and IY's readings in
`docs/design-notes.md`. **IP's Hungering Dark standard, every row, door and word**: its `Run.MODIFIERS` row; `DULL_EDGE_CRIT` and its
line in the handles' comment; its arm of `battle._stamp_modifier` — the stamp's one write of crit, so the `inherited` guard guards
Attack alone now and its comment says so; `_do_summon`'s comment (a companion's Attack carries Feverish or the Thin Veil); the reason
`talents.gd` gives for `crit_bonus` (*a battle modifier floors it at the spawn*, true of nothing now); IY's handle header (*nine …
seven since IZ removed Dull Edge and Tinderbox*). **The load door keeps reading a save that names it** — IQ §4's guard, unchanged but
for its comment's list — and `check_iz` §3 drives it: a save whose offer names both removed ids loads with those options dropped and
no die spent; a clean offer loads whole; `_active_modifier` asks the deck. **The deck after** (§3 and §5 together): **21 modifiers**;
Wanderer safe (1–2) 11, gamble (3–4) 6; Warden safe (1–3) 15, gamble (4–4) 2; Ruin safe (3–4) 6, gamble (5–5) 4; the fixed encounters
draw from 6; **the mildest severity each rung deals is unchanged — 1, 1 and 3** — so the merchant stands where it stood.

## §4 — FRENZIED ADDS

**A flat addition to every unit's effective speed in place of the multiplication, both sides**: `unit.gd`'s `mod_speed_add`, read in
`effective_speed()` as `maxf(speed + mod_speed_add, speed * MOD_SPEED_FLOOR)` — floored at a tenth of the unit's own speed, so nothing
stalls; the stamp writes `Run.FRENZIED_SPEED_ADD` once. **Inert unstamped**: ten runs of the re-keyed tree with no modifier read A_none's
first ten line for line (11,876 probe lines). **Driven, the sign read** (sixty runs each, paired against the §1 *none* arm):

| the arm | the amount on every speed | the cost | z | the verdict |
|---|---|---|---|---|
| the add | +30 | **+0.02 ± 0.28** | +0.08 | tie |
| the add at ten times, to read its sign past the noise | +300 | **-0.70 ± 0.29** | -2.46 | pays |
| the subtraction | -30 | **+0.60 ± 0.26** | +2.32 | costs |

**The add pays the party** (+300 past the test; +30 a tie), so **the subtraction was driven, and it costs**: -30 ships, a grade 1.
**The plain step**: thirty points — the old 30% stated at the average speed of 100, the same step as an amount. **No word of Frenzied's
moved**: its sentence formats the constant, so it reads *Everyone acts -30% faster. Cooldowns are unchanged.* — the sign flipped, and
the rewording is the designer's (NEEDS A RULING 1). `check_iz` §4 drives a real board through the real stamp: 23 of the first 48
turns change hands, where a factor on every speed moves none (C05). **The prediction** (`PREDICT_S2.md`, md5 `e60bb2ec…`) had the
add costing and the subtraction paying — **wrong in sign on all three Frenzied arms**.

## §5 — MUFFLED AND TINDERBOX ON THE POPULATIONS THEIR RULES NAME

**The fire party, derived** (probe part five, `tools/iz_probe5.py`, derivation only: the strike ledger's fire against all, ten runs each,
`docs/reports/IZ-fire.tsv`): the reference party lands **5.3%** of its strike damage as fire (15,071 of 285,611), the default four
with the Pyromancer for the Cryomancer **15.9%** (48,626 of 306,395) — three times — and the warband 3.6% and 4.5%.

| modifier | the population its rule names | its *none* arm | the cost | z | the verdict | in the deck |
|---|---|---|---|---|---|---|
| Muffled | the incumbent (talented, Ruin, 60 runs) | 0.953 ± 0.004 | **+1.66 ± 0.34** | +4.84 | reach | yes |
| Tinderbox | the fire party (untalented, Wanderer, 60 runs) | 0.935 ± 0.006 | **+0.24 ± 0.23** | +1.01 | no reach | no |

**Muffled** at 50 on the incumbent (IG's three parties, talented, all nodes, Ruin, block 21, fight-seeded, twenty a party): a cost, a
**grade 1** — its grade is the incumbent's, the default four reading it free. **Tinderbox** at +75% on the fire party: **no reach on the
population its own rule names — the stop condition — so it leaves the deck**, removed as Dull Edge was (its row, `TINDERBOX_FIRE_PCT`,
its stamp arm; `type_dmg_bonus` stays, the Emberheart relic's hook, and `_companion_hit`'s comment says what is true without it).
**Why it could not cost** (read after the verdict): the heroes dealt about twelve times the warband's fire on that party, so *+75%
fire, whoever deals it* fed them — IP §0.2's shape (FOUND AT IZ). **The prediction graded**: 9 of 13 right (wrong: the three
Frenzied arms, and the fire party's share under the 20–60% predicted).

## §0.4 — WARDEN's BAND, TWO ARMS

**The arms**: the reference party at Warden, natural, sixty runs each, block 38, fight-seeded, paired — the bands as they stand (safe
1–3, gamble 4–4) against Wanderer's (safe 1–2, gamble 3–4), each on IZ's final deck.

| the arm | Warden safe / gamble | holds | its reading (60 runs, bargain fights) | against *now* |
|---|---|---|---|---|
| the bands as they stand | 1–3 / 4–4 | 15 / 2 | 0.655 ± 0.019 (370) | — |
| Wanderer's bands | 1–2 / 3–4 | 11 / 6 | 0.713 ± 0.015 (372) | **+5.78 ± 2.16** (z +2.68): milder |

**MATERIALLY MILDER, SO THE BAND STAYS AND THE FINDING IS PRICED**: Warden's bargain fights end 5.8 points of health kinder under
Wanderer's bands (z 2.68). The gambles the bot took spread over six under them (Rot 100, Overgrown 97, Deadened 42, the Long Silence
38, Miasma 31, the Thin Veil 27; 372 fights) where now they are two (Rot 158, Overgrown 143; 370); one run of sixty completed in each
arm. **Moved, Warden's bands would equal Wanderer's**, and the rung's twist — the safe slot less mild — would be gone. `check_iz` §6
holds the band where the verdict puts it (C08). **The prediction** (`PREDICT_S3.md`, md5 `63100063…`): the verdict right, the figure
past its +1.5 to +5.0 range.

## §6 — THE CHANGELOG's CUT

**CW §4's procedure, before the documents**: the cut at **HR/HS** — the oldest 49 entries (Batch FT through Batch HR) to
`DoD-archive/changelog-archive.html`, newest first, the live header and the archive's header each carrying the cut (*Batch IZ at
HR/HS*; the archive's *NOR DID THE SIXTH*). **Sizes**: the live file 390,847 B → 142,566 B before IZ's entry, 146,569 B
with it; the archive 1,907,462 B → 2,155,950 B, 214 → 263 entries. **Verified by a second script sharing nothing with the splitter**
(`IZ-work/edits/verify_cut.py`: a line walk with a hash per entry, on frozen copies): every heading once, none invented or dropped,
order kept, **the two bodies rejoined byte-identical** (sha256 `35cd0ef8…`); **its proof proved** on scratch pairs — an entry dropped
→ 6 failures, an entry in both halves → 7, one word misspelt at the same length → 2, the byte arms alone. **The readers re-pointed**:
`check_dv` §4 (the live floor 34, the archive 263, the boundary literals, IZ's own entry, the header's cut) and, second-hand,
`check_ec` §2 (which reads `check_dv`'s needles); the pin manifest regenerated with the documents. Twenty files open the live
changelog — fifteen follow its header to the archive, five read the live file alone — and every one ran green on the cut tree in the
pre-check or a recon.

## §7 — WHAT IS DELIBERATELY NOT DONE

No new modifier authored — grade 4's four empty slots are the designer's; no modifier's words moved (Frenzied's now read a slow-down
as a negative speed-up: NEEDS A RULING 1); the reference party unchanged and no second ladder; no POLICY row changed, RULE stays 0, the
ally pools untouched; IX's absorption reading not proved (FOUND AT IY stands); the latent offer defect left latent (an offer saved
before a re-grade shows today's severity beside the reward rolled at its old one; the two removed ids are dropped at the door);
`check_hk`'s unseeded band; `CLAUDE.md` takes no index; the 188 cheap gates, the 438 pins, the 13 positional picks, `check_it` §2c,
`check_hn` §2a, the Chilled status row, the latent floor shapes and the Cryomancer's route — untouched; nothing of the playthrough; the
standing list.

## FOUND AT IZ AND NOT FIXED

- **TINDERBOX WAS A ONE-SIDED RULE IN TWO-SIDED WORDS** (IZ §5's derivation, read after the stop condition decided it): on the fire party the heroes dealt 48,626 fire against the warband's 4,173 over ten runs — about twelve to one — so *every fire strike +75%, whoever deals it* fed the heroes far more than it charged them, which is IP §0.2's shape (*a rule keyed on a quantity the two sides do not produce equally pays the side that produces more of it*), the Hungering Dark's. Recorded beside its built shape in `docs/design-notes.md`; a fire rule authored again names the two sides' shares first.
- **DEADENED's REFERENCE READING IS FREE AND ITS GRADE IS 3** (IZ §1): +0.40 ± 0.29 on the default four (z 1.38), +5.23 ± 0.92 on the incumbent — the widest swing on IZ's readings, from no severity to three; the grade is the incumbent's (IY §0.3), and the default four cannot feel what it takes because their plan is not Break.
- **THE BRIEF's PREMISES THAT DID NOT HOLD** (IZ's report §0): *three of the eleven were never free* is four (Brittle on the reference party the fourth); the changelog's *390,749 B* is IY's figure before its last sentence (390,847 at IY's close), and IZ's entry would not have crossed the bar — the cut was taken a batch early, by the brief's order; *a removal owes the save a re-ask* is IQ §4's rule the other way round (*a guard, not a re-ask*), and the guard already covered both removals by construction; *every grade resting on IX's run-seeded reading* is eight grades, of which §1 re-read three; *§6's band arms* are §0.4's; *seven gambles* on the moved band are six on IZ's deck.
- **`test_batch_cb`'s PYRE WAKE DEEP-STACK ARM READS WHERE A RANDOM SCATTER PUT ITS FIRES** (IZ's recon 2): red once — *the bank is
  emptied rather than skimmed (got 9)*, every one of the nine turns Pyre Wake consumed scattered back onto the deep body — on game
  code byte-identical to recon 1's, where it was green, and green three times of three re-run on that code. The suite seeds its dice
  and the run's timing still moves what the scatter deals: an arm that reads what the dice dealt is a coin flip (HR §6). Not IZ's to
  repair; the repair is to assert the bank before the scatter, or to count the scatter's landings.

## NEEDS A RULING

1. **FRENZIED's WORDS — THE SIGN FLIPPED (IZ §4: *if the sign flips, the rewording is mine*).** Added to every unit's speed, the amount pays the party (+300: -0.70 ± 0.29, z -2.46; +30 a tie), so the subtraction was driven, and it costs (-30: +0.60 ± 0.26, z 2.32, a 1): -30 shipped. **No word moved**, so the card reads *Everyone acts -30% faster. Cooldowns are unchanged.* — a slow-down stated as a negative speed-up, its figure read off `FRENZIED_SPEED_ADD` at the average speed of 100. The rewording is the designer's.
2. **GRADE 4 IS THE HOLE, AND GRADE 1 HOLDS SEVEN (IZ §2).** The deck holds none 0; 1 7; 2 4; 3 4; 4 2; 5 4, against 5 / 5 / 5 / 4 / 4: the readings allow no more. Grade 1's seven are the three reverted to values that cost a 1 (Slick Footing, Fleeting, Bloodletting), Hoarfrost (whose reach ends at a 1), Encumbered (re-read to a 1), Muffled (a 1 on its own population) and Frenzied (-30). **Grade 4's four empty slots are new modifiers, the designer's to author** (IZ §8). The one measured lever between: Fleeting at 3 reads +3.10 ± 0.32 (a 2) — a slope point, not placed, since §1 found its old value a cost.
3. **WARDEN's BAND STAYS, AND WHAT MOVING IT COSTS IS PRICED (IZ §0.4).** Wanderer's bands on Warden end its bargain fights +5.78 ± 2.16 points of health kinder (z 2.68: materially milder), so the band does not move, and **every Warden offer's gambles are still Rot and Overgrown**. Moved, Warden's bands would equal Wanderer's and its twist — the safe slot less mild — would be gone. A grade-4 modifier authored (ruling 2) is what the measurement leaves.

## §8 — HOUSEKEEPING

- **THE MOVE IS NOT ATTEMPTED** (IB §4). `./lane.sh spent` prints the one clearing command. **User-data folders: 611 at the open,
  611 at the close** — every lane IZ launched ran under a name a folder already held: `./lane.sh spent` holds 608 of
  them under its three patterns (470, 129, 9), and `strays` names *IT const probe* and *[unnamed project]*, IY's two.
- **`lane.sh` for every launch, one process a lane** — the §1 drive's work lane (*IC recon2*, HEAD with the probes) and its ten arm
  lanes reusing earlier names (*IG p1*, *IG p2*, *IH A*, *IH B*, *IA probe*, *IA docsub*, *IE probeA1*–*A3*, *IE probeB1*); stage B's
  twelve (*IE probeB2*–*B4*, *IE probeH*, *IE probeH1*–*H4*, *IE probeP4*, *IF mprobe1*–*3*); stage C's deck and two arms (*IF fprobe*,
  *IF fprobe2*, *IF mprobe1*); the pre-check's two (*IA pre1*, *IA pre2*); recon 1 (*IC final*); the stand-ins (*IC docsubA*, *IC
  docsubB*, *IC prepass*); the controls' clones (*IC ctlA*, *IC ctlB*, *IB ctlC*); the final tree the controls cloned (*IC recon1*) and
  the final tree recon 2 ran (*IC recon2*, never beside the drive lane of that name). **Every drive job was bound to a lane of its own**
  (`tools/launch_bound.sh`). **No HEAD copy was launched for a battery**: the seeded roads were attributed against IY's acceptance logs
  — HEAD's gates on HEAD's own tree, copied out of IY's scratchpad — beside recon 1; the ok() traces ran HEAD's gates in the work lane.
  The acceptance ran in the repository as the live project, through `./run_battery.sh`, as every acceptance does.
- **The designer's files** — backed up first (`../save-backups/IZ-20261026-222914`, 22:29:14, byte-identical to IY's backup by
  `diff -r`) and read only through copies: `run_save.bin` (55,264 B, md5 `fcb20c91…`; its copy holds no offer pending), the profile
  (`608d89c0…`), the relics (`fdc12ffa…`), the settings (`0c1b39c3…`) and the readout's three files, the clean run
  `run-20261018-194229.jsonl` (24,340 B, md5 `610bcd8c…`) — **still the one run; no newer readout file** at the open — and at the
  close `run_save.bin` 55,264 B md5 `fcb20c91…` unchanged; `profile.json` 1,098 B `608d89c0…` unchanged; `relics.json` 289 B `fdc12ffa…` unchanged; `settings.cfg` 47 B `0c1b39c3…` unchanged; `readout/latest.txt` 40 B `e43f2d0a…` unchanged; `readout/run-20261014-134942.jsonl` 16,291 B `2b0f0212…` unchanged; `readout/run-20261018-194229.jsonl` 24,340 B `610bcd8c…` unchanged — **every one byte-identical to the backup, and still no newer readout file: the one run.**
- **Nothing of the playthrough**: a sim is not a playthrough, and the second run with a different party stays on the LOOK-LIST.
- **The weekly limit stopped the batch mid-way** (2026-10-27, after recon 1 launched): the positional reader stopped with it and was
  resumed from its saved transcript on 2026-10-29; nothing in either tree changed across the pause.
- **The close's timestamp** — 2026-10-29 17:06:05 PDT.

## §9 — VERIFICATION

**IN THE BRIEF's ORDER (§9)**: the routing first (22:33, before any edit or measurement); §1's re-reads on their own, a re-driven
baseline beside them, and the cuts re-derived and printed before anything was placed; §4's three arms and §5's two populations, the
fire party paired against its own *none* arm; then the code (§2's reverts and placing, §3's removal, §4's re-key, §6's cut) and its
parse; the literal sweep before recon 1's prediction; recon 1 with its prediction written first; the documents as scratch copies, a
hash guard between them and the repository; `check_iz` into the battery after them; the stand-ins; the needle proof; the close-read;
the positional re-run; the controls; recon 2 with its prediction; the acceptance; the push check; the two readings. **A prediction
was written before every drive and both recons; each is graded beside its reading.** Every Godot process ran through `lane.sh`, one a
lane, every drive job bound to its lane; **0 `Parse Error` and 0 `SCRIPT ERROR` in every log** of every drive, pre-check, recon,
stand-in subset and control (grepped in stderr, never a tally).

**THE PREDICTIONS, GRADED** (IY got 7 of 11): §1 — **8 of 13** (wrong: Fleeting, Hoarfrost in sign, Feverish, Brittle, the ratio —
better than predicted); stage B — **9 of 13** (wrong: the three Frenzied arms, all in sign or verdict, and the fire party's share);
§0.4 — **the verdict right, the figure out of range** (+5.78 against +1.5 to +5.0); recon 1 — **every red it named reddened, and one
it did not name** (`check_iu` §7, below); recon 2 — **every figure it named held, and two reds it did not name** — `test_batch_bx` (a word of mine) and `test_batch_cb` (a coin flip), both below.

**THE PRE-CHECK (FA §1b: HEAD's gates against IZ's code, before re-pointing any)** — 66 targets over two lanes on the draft code
tree: the reds were exactly the arms IZ moves — `check_dv` §4 and `check_ec` (the cut's literals), `check_ew` §5, `check_hp` §1b and
`check_ij` (Dull Edge's needles), `check_ho` §4 (a throw: `mod_speed_mult`), `check_in`/`check_io`/`check_ip` (the counts; `check_ip`'s
held sample), `check_iq` (the documents), `check_iw`/`check_ix`/`check_iy` (the deck), `test_batch_an` and `test_batch_bb` (the deck's
size), `check_gj` (its sanctioned §4, figures moved) — each re-pointed to its intent, every re-point carrying `RE-POINTED AT IZ`.
**The census needles held** (`check_iu` §2: 33 HELD/PARTLY rows on 19 changed files, 0 lost). Two re-points were not mechanical:
**`check_ho` §4** — Frenzied's field is the flat `mod_speed_add` now, default zero, so it left the population of non-zero defaults the
replace-not-add trap reads, and §4's walk reads five fields on four heroes (19 reads, the floor written to that); **`check_ip` §1b**'s
held sample is IZ's, read off its own print (2.671 / 3.275 / 4.443, each within 0.01 of its bands' arithmetic).

**THE LITERAL SWEEP, BEFORE RECON 1's PREDICTION** (HEAD against IZ's code tree, 22 files): 25,938 literals — 2,263 MOVED, 281 GAINED,
578 LOST; 546 of the LOST are the changelog's cut, so the changelog's readers were enumerated rather than its literals (20 files: 15
follow its header to the archive, 5 read the live file alone; every one green on the cut in the pre-check or a recon). The other 32
LOST and the code-file GAINED were walked to their holders; **none bit** beyond the re-pointed gates. **`check_ed` named in the
prediction** (the tree carried HEAD's manifest). **The manifest's floor**: HEAD 2,094; regenerated on the code tree 2,095, on the final
tree 2,114 (with `check_iz`) — it rises, so no `--fall` is owed.

**RECON 1** (161 targets and the harness, the code tree with every gate re-point and HEAD's documents; `IZ-work/s1/PREDICT_R1.md`, md5
`169d9016…`): the reds it named — `check_ed` 18 / 2, `check_iy` 123 / 11, `check_ix` 117 / 11, `check_iw` 124 / 2, `check_io` 120 / 1,
`check_ik` 242 / 1, `check_iq` 88 / 2, `check_dv` 84 / 2, `check_ec` 26 / 3, `check_gj` 70 / 1 (*+159 / 179*), `check_de` 677 / 14 — and
**one it did not: `check_iu` 185 / 1, §7's copy arm**. **An instrument defect, found first on the stand-in and repaired**: the arm
copies `scripts/unit.gd` from the WORKING tree and requires `lane.sh` to refuse the copy as *a copy of a file the repository tracks* —
but `lane.sh` compares against the index's blobs, so on any tree carrying an uncommitted edit to `unit.gd` (IZ's re-key) the copy is a
copy of nothing tracked, and the arm reds; **the acceptance itself would have red**. Re-pointed: the copy is of the index blob (`git
show :scripts/unit.gd`). Two arms: HEAD's arm red on the stand-in, the re-pointed one green on the next. **The seeded roads, attributed
by HEAD's gate on HEAD's tree** (IY's acceptance logs) **beside recon 1**: `check_gp` 454 → **455**, its §4 no-engine road through IZ's
re-graded deck — 38 battles and 63 distinct cards offered against HEAD's 33 and 62, one assertion a card; `check_gj`'s sanctioned
figures +169 / 189 → **+159 / 179**, the same 20-gold gap; the harness 22 / 382 / 8 **unmoved**; `check_hk` 168, HEAD's; `test_batch_an`
6,022 and `test_batch_bk` 130, inside their bands.

**THE COUNTS, ATTRIBUTED BY AN ok() TRACE** (HEAD's gate on HEAD's tree beside IZ's on the stand-in, each `ok()` call site counted):
`test_batch_an` 6,052 → 6,022 — the two removed modifiers' five walk arms each (-10), Dull Edge's two crit arms and Tinderbox's fire arm
on the seven units of their board (-21), +1 the unseeded map; `check_ik` 253 → 242 — Tinderbox's text out of §5b's walk (-12), the
row's absence asserted (+1); `check_ix` 119 → 124 and `check_iy` 121 → 133 — one and two more reads of the kept grades table through
the `_tsv` door (its in-tree arm, its column arms, its rows arm), every other arm re-pointed one for one. Each row in `baselines.json`
carries its attribution.

**THE DOCUMENTS — SCRATCH COPIES, BEHIND A HASH GUARD.** Every document edit is a script run on a scratch tree (`IZ-work/edits/
apply_docs.py`, `apply_state.py`, `fill_tokens.py` — the two size lines a fixed point — and `render_routing.py`), never on the
repository. **The stand-in** (the final tree less the baseline moves) ran 29 document-reading gates: green but three — `check_is` §5
(the grades block's index row over 400 B: trimmed), `check_iu` §8 (the routing record not yet in the tree) and `check_iu` §7 (above) —
and `check_ed`, predicted. **The needle proof** (the manifest regenerated over the same gate sources on the code tree with HEAD's
documents and on the final tree, entry by entry): **2 needles satisfied** (`check_dv`'s IZ entry, `check_ik`'s Tinderbox absence), **0
taken red, 0 moved otherwise**; all 19 of `check_iz`'s pins resolve. **The close-read** (the routing record's third list) found nothing
IZ made false among the 71 unrouted blocks, three that bore, and — in the opened text — one item IZ had made stale and the working
read had passed (*Small, and still owed*'s kindling modifier, and its `CLAUDE.md` twin): both amended.

**THE POSITIONAL AND SUPERLATIVE RE-RUN** (IT's census of 489 reads, re-derived against IZ's tree; IY's tools, overlaid with IY's
verdicts): **every one of the 489 settled — 203 SAME, 179 LINE-SHIFT, 60 IN-PLACE, 0 OFF-SUBJECT, and 47 unchanged by construction (the gate and every file it opens byte-identical, and no population read among them); no verdict moved, and the thirteen standing MISSES still miss.** The mechanical pass (`IZ-work/tools/pos_select.py` and `pos_window.py`, IY's, overlaid with IY's verdicts) sent 372 reads to a reader — IZ's `battle.gd` edits sit inside the windows of most of them — and the reader (a subagent outside the working read; stopped by the weekly limit and resumed from its own transcript, nothing in either tree changed across the pause) re-derived those, the 68 population reads and the 20 window rows by hand: each read ported from its gate's code in both trees and applied to HEAD and to the tree (`IZ-work/route/positional_iz.tsv`, 442 rows). **Two standing MISSES gain an instance, no verdict**: 174's shape (a function's window running past its end) gains `start_cooldown`'s, because IZ's `MOD_SPEED_FLOOR` const stands between it and `effective_speed` in `unit.gd`; 304's (a returning body's window) gains `check_iz::_konst`'s. IN-PLACE where expected: the stamp, the newest changelog entry and the archive's newest cut are IZ's; `_stamp_modifier`'s windows hold the re-keyed write; `Run.MODIFIERS` reads 21 ids; the gate-source sweeps meet `check_iz`'s literals and resolve them. **15 population reads the mechanical pass marked unchanged did open a changed or new file** (the gates IZ edited, `check_iz.gd`, the four scripts); each settled IN-PLACE or SAME. No read takes `baselines.json` or `pin-manifest.json` as a positional haystack; `check_ed`'s and `check_de`'s two depend on them and read the final tree's.

**THE CONTROLS — TWELVE, ALL BIT** (`IZ-work/tools/ctl_iz.py`, IY's driver: one clone of the final tree each, the break's anchor
dry-checked on the final tree and asserted once in the clone, `check_iz` run through `lane.sh`, read by its FAIL text, never its count;
0 throws in any):

| | the break | what reddened (FAIL text) |
|---|---|---|
| C01 | Bloodletting left at 45 | §2 *bloodletting: its reading was taken at BLOODLETTING_BLEED 15 and the deck holds 45*; *Bloodletting's handle is 45 — IZ §0.2 reverts it to 15* |
| C02 | Encumbered graded off IX's run-seeded reading (its band unmoved) | §2 *encumbered: graded off a run-seeded reading where a fight-seeded one exists* |
| C03 | Dull Edge's row back in `Run.MODIFIERS` | §3 *files of the game still name a removed modifier*, *the deck holds [dulledge]*; §2 the table's ids against the deck's |
| C04 | the load door's guard off | §3 *a save whose offer names [dulledge, tinderbox] loaded …, not the one the deck holds* |
| C05 | Frenzied's multiplication back (a factor on every speed) | §4 *DRIVEN — under Frenzied the board's first 48 turns fell in the same order as with no modifier* (and the door's text) |
| C06 | Muffled graded off the reference party, table and code agreeing | §5 *muffled carries severity 0, under the band 1 its own population gives* |
| C07 | Tinderbox kept, with no reach on its own population | §5 *tinderbox: its verdict is 'no reach', and the deck holds it*; §3's words |
| C08 | Warden's band moved against its arms | §6 *Warden's bands read [1, 2] / [3, 4] — its two arms' verdict ('milder') puts them at [1, 3] / [4, 4]* |
| C09 | the changelog over its bar | §6 *docs/changelog.html is … B against its 400000 B bar — the cut is owed* |
| H01 | HEAD's code under the final gate | 14: the revert, the removal's words and deck, *Run carries no FRENZIED_SPEED_ADD*, Tinderbox's verdict |
| H02 | HEAD's documents under the final gate | 27: the rulings, the design notes, every kept table *not in the tree*, *the live header does not record the cut IZ made* |
| R01 | a re-tune at the source (SLICK_DELAY 0.5 → 0.75) | §2 *slick: its reading was taken at SLICK_DELAY 0.5 and the deck holds 0.75* |

C07 and H01 first read *missing* on the Tinderbox line: GDScript prints an array with its single quotes escaped, so the wanted string
did not match the line that had bitten; made quote-free and re-run, both BIT. **Writing H02 found a gate defect of IZ's own**: with
the scale table absent, `check_iz` §1 indexed an empty list of cuts — it is bounded now (fewer than five cuts reds and the section
stops), one arm more: 175 → 176.

**RECON 2** (the final tree, frozen by md5 of every file before launch; `IZ-work/s1/PREDICT_R2.md`, md5 `15e9dfad…`): 165 targets and the harness, 0 `Parse Error` / `SCRIPT ERROR` in any log, the tree's md5s unmoved across the run. **As predicted**: `check_iz` 176 / 0, `check_iu` 185 / 0 (§7's copy arm green, §8 reading IZ's routing), `check_ed` 18 / 0 (the regenerated manifest), `check_ec` 24, `check_iy` 133, `check_ix` 124, `check_ik` 242, `check_parse` 242, `check_gp` 455 (its road as recon 1's), the harness 22 / 382 / 8, `check_hk` 168, `test_batch_an` 6,021, `test_batch_bk` 131; sanctioned as at HEAD, `check_cm_live` 13 / 5 and `check_gj` 70 / 1 (*+159 gold and the purse moved 179*); **`check_de` 681 / 2, 0 notices**. **The two it did not name**: **`test_batch_bx` 164 / 1** — §4b, *master.html says hero or ally everywhere it is prose*: the sentence I wrote said *a talented party*, and the word is retired from player-facing text — fixed (*talented heroes*); and **`test_batch_cb` 2107 / 1** — *the bank is emptied rather than skimmed (got 9)*: its Pyre Wake arm reads where a random scatter put nine fires; the game code was byte-identical to recon 1's, where it was green, and three re-runs on that code read 2107 / 0 — a coin flip, recorded (FOUND AT IZ), not repaired. **The fix made a third final tree** (final3), differing from recon 2's in `docs/master.html` and `docs/state.md` alone: parse 242 / 0; the 24 gates that read either file green on it (`test_batch_bx` 164 / 0, `test_batch_cb` 2107 / 0 among them); a third needle pass moved no entry. **final3 landed** behind the hash guard (`IZ-work/tools/land_iz.py`: 40 files, each over HEAD's bytes in the repository, the tree's bytes those its freeze recorded). **The first acceptance was stopped minutes in**, when a last read of the landed WHERE block found its count of re-pointed targets wrong (*fifteen* — `check_iu` §7 is the sixteenth) and its baselines sentence unpunctuated: **final4** — final3 with `docs/state.md` regenerated from HEAD's text by the same scripts — differed in that file alone; the fifteen gates that read it were green on it and the manifest regenerated byte-identical; its `state.md` landed over final3's, guarded, and the acceptance ran on the repository holding final4's 40 files.

**THE ACCEPTANCE** (the repository, the game shut, `./run_battery.sh`, after the landing behind the hash guard): 166 targets and the harness, **0 `Parse Error` and 0 `SCRIPT ERROR`** in any log; **`check_de` 681 / 0 failures / 0 notices**, the harness 22 / 382 / 8, **the sanctioned reds alone** — `check_cm_live` 13 / 5 and `check_gj` 70 / 1 (*+159 gold and the purse moved 179*); `check_iz` 176, `check_parse` 242, `check_iu` 185, `check_ed` 18, `check_ec` 24, `check_gp` 455, `check_hk` 168, `test_batch_an` 6,020, `test_batch_bk` 131, `test_batch_bx` 164 / 0 and `test_batch_cb` 2107 / 0 — **every figure its prediction named** (`IZ-work/s1/PREDICT_ACCEPT.md`, md5 `eefc0e33…`, written before the first launch and standing for the restart: the stop changed `docs/state.md`'s words and no figure the prediction named).

**THE PUSH CHECK AND THE TWO READINGS.** **The push check**: before anything ran, `git ls-remote origin class-merge` read `5f22c19e`, IY's push and local HEAD (22:28); IZ's commit is pushed to `class-merge` and the remote read back against local HEAD after it. **The two readings** (IQ's method — each file against its own ceiling, at the open and the close): **`CLAUDE.md` 494,798 → 496,724 B** (+1,926, nothing cut — the ladder block's IZ bullet, the scale's two moved cuts and its centres, the two counts and the DU §2 twin; 485.08 KiB of its 510, 24.92 under); **`docs/state.md` 355,950 → 358,738 B** (+2,788 net, +446 of it inside the index's fence; the archive took 17,275 B, so IZ wrote 20,063 B; 350.33 KiB of its 380, 29.67 under). **The changelog's before and after its cut**: 390,847 B at IY's close → 142,566 B cut → **146,569 B** with IZ's entry; the archive 1,907,462 → 2,155,950 B, 214 → 263 entries.
