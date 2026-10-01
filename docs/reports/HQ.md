# BATCH HQ — ONE MAGNITUDE, ONE KEY, AND THE WORD THE TAXONOMY IS MISSING

**On `class-merge`, from `bf5611d` (HP). IMPLEMENT ONLY.** HP's five rulings are taken (§1). **Dead Air moves 50% → 75%**
and is measured there with HP's own probe; `heroes_hold_core` joins the keys read as the fight runs — which took the
engines the battle's re-read never carried, not the one line it was priced at; *Breaking Heals a Hero*'s words narrow to
its read site; the refused tail can reach a player and speaks a player's words. **The rune taxonomy gains CONDITIONAL**
(§2). **Two Peddler columns read the Peddler's door**, and a walk that counted what it touched claims what it proves (§3).
HP's twenty-eight copies are in the Trash (§4).

**VERDICT: IT SHIPS.** The acceptance run in the repository read `check_de` 541 / 0 / 0 over 131 targets, every target at
its row, the tree byte-identical after it and the player's four files byte-identical to the backup (§6e). Two rulings are owed, both words a player reads; neither blocks the batch.

## NEEDS A RULING — TWO, BOTH WORDS A PLAYER READS

1. **THE TALENT'S WORDS, PROPOSED (§1.4).** *Breaking Heals a Hero* reads **"An attack that lands Break heals the
   lowest-health hero for 20% of it."** where *"Every point of Break damage dealt heals the lowest-health hero for 20% of
   its value."* stood. Narrowed the way Tithe's were, to what the shared read site pays; the three exceptions stay
   invisible as Tithe's do — a card's Break inside its own handler, the Long Watch's carry, the floor of 1.
2. **THE REFUSED TAIL'S WORDS, PROPOSED (§1.5).** **"it cannot work as written, so it pays nothing this fight"** where
   *"its payload is refused, so it pays nothing this fight"* stood. The question was whether it can reach a player; it
   can, by two routes (§1.5), so it is reworded rather than left. The reason goes to `push_error`, which the developer
   reads.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | Dirge's three at 1.45 out-damage four; falls 0.74 → 0.67, depth 19.4 → 22.3 | **Held** — HP's party A (`hpm_logs` A_none against A2_dirge). Party B moved neither (1.05 → 1.02, 13.1 → 13.4). |
| 2 | Empty Pulpit's flag: 2% of a won fight's damage taken with the Cleric down | **Held** (HP §2a). |
| 3 | At 50% Dead Air was worth 0.26–0.49 of a bare 10% | **Held**, reproduced from HP's lane logs by HP's own analyser with HP's report formula (§1.1). |
| 4 | HP measured the Mage at 41–46% of the damage, full replacement at 69–85% | **Held as HP's figures** (HP §2b). Re-read off HP's no-crest lanes, the three deal 0.63 (A) and 0.51 (B) of the four's strike damage a round while no Mage stands — the Mage at 37% and 49%, either side of HP's band. |
| 5 | HP's arms were 12% and 50% | **Held.** |
| 6 | HP's brief wrote *confirm a save that did hold it loads without it*; 171 is the count | **Held**: HP §3 records the line; `data/runes.json` holds 171 entries (68 retired, 75 live for a class, 4 for the crest, 24 core). |
| 7 | `heroes_hold_core` joining `LIVE_KEYS` is one line | **Did not hold.** `battle._live_party` handed the re-read each hero's key and health and no engines, so the key read no engine on anybody at any re-read: with the one line alone a payload carrying it never pays (control Q02: `check_hp` §1f *paid on 0 of the four*, `check_hl` §6 *paid on 0 of 4 heroes*). Four lines more hand the unit's `engines` — the very list the spawn built off `Runes.held_engines` of the member. |
| 8 | `check_hp` §1f prints the key turning false with its holder down | **Held** (it printed `false` and asserted nothing about it). |
| 9 | Tithe's three exceptions; *Breaking Heals a Hero* says *every point of Break damage dealt* over the same site; a Long Watch Warden's party books 66.3 and the site reads 42.4 | **Held** (`talents.gd` `tn_break_heal`; `battle.gd` the one sum `attacker.blood_communion + attacker.rune_blood_communion`; HO's figures in `docs/state.md`). |
| 10 | `Runes._load` `push_error`s on a refused entry, *so a refused rune should never reach a player* | **The first half held; the second did not.** `_load` reports and KEEPS the entry, `eligible_ids` never asks `live_refusal`, and a worn rune's payload rides the save as it was built (§1.5). |
| 11 | HP's three are `STAT` with no secondary; the secondaries are TRADEOFF and two retired tag conditions | **Held** (`Runes.RUNE_SHAPES`, `RUNE_SECONDARIES`). |
| 12 | A conditional rune is *the only kind the crest holds that reads the party* | **Half.** Tithe reads the four too — it heals whichever of them is lowest — but at its read site, ungated. What is unique to the three is a payload GATED on the four, which is what CONDITIONAL names. |
| 13 | `check_he` §1 and `check_hf` §3 tally `Run.generate_rune`; the Peddler left it at HL §1 for `Run.peddler_rune` | **Held** (`check_he.gd:372`, `check_hf.gd:994`; `run_state.peddler_rune`). |
| 14 | `test_batch_ak`'s walk applies every payload under a party-less ctx with no assertion in the loop | **Held** (§7 `_no_rune_regression`). |
| 15 | HP's twenty-eight copies, *"Dawn of Decay HP …"*, 17,248 KiB; 461 older folders | **Held**: twenty-eight, **17,260 KiB** now (§4). |
| 16 | HO left `CLAUDE.md` at 403.74 KiB and HP's report does not give the figure | **Held, and the figure is in HP's `docs/state.md`**: 421,366 B = 411.49 KiB. |
| 17 | HP's backup `../save-backups/HP-20260930-193909`, byte-identical to HO's | **Held** (§6). |
| 18 | Expect `check_fn` §1b, `check_hp` §2 and §1f, and the two Peddler tallies to move | **Half**: `check_fn` §1b holds at 0.75 (the relation, not a figure); `check_hp` §2a, §1a, §1c and §1f red on HEAD's copy (§6a); the Peddler tallies do not move until the columns are re-pointed — HEAD's gates read HP's figures exactly. |
| 19 | HP read 131 targets in 74 min 56 s | Not taken as a runtime; measured (§6). |

## §1 — HP'S FIVE RULINGS

### §1.1 — THE THREE MAGNITUDES: DIRGE 45%, EMPTY PULPIT 50%, DEAD AIR 75%

> **Dead Air** — *While no Mage stands, every hero deals 75% more damage.* `dmg_bonus` 0.50 → **0.75**, its words with it.

**Dirge and Empty Pulpit are unchanged**, and the reasons the designer gave are recorded where a future session reads
them (`CLAUDE.md`'s crest block): a rune paid while a hero is missing is priced by what it replaces, and its worth over
a fight is the state's. **Dirge farms nothing** — a dead hero still cannot act, cannot heal, and lengthens the fight, and
in HP's party A falls went 0.74 → 0.67 and depth 19.4 → 22.3. **Empty Pulpit's 2%** is a property of the state (the
Cleric mostly falls in fights already going badly) and is a watch item in `docs/state.md`, not a defect. **The name stays
*Dead Air*** — the *Deadfall* near-miss is a recorded near-miss, `check_hp` §2f unchanged.

**THE MEASUREMENT AT 75%, ONE ARM, BOTH PARTIES, HP'S PROBE.** HP's `hpm_patch.py` applied unchanged to an isolated copy of
HQ's tree (its eight anchors all landed), HP's lane runner, rung 2, no talents, 6 × 25 runs a party, the crest worn from
the first fight: **A** = Berserker, Arcanist, Devout, Beastmaster; **B** = Swordmaster, Pyromancer, Holy, Sharpshooter (HP's
`DOD_SIM_SPECS` exactly). Normal fights only; ± a standard error over runs; HP's arms read from HP's own lane logs by the
same analyser, so the table reproduces HP's.

| arm | runs | normal fights | rounds | falls | turns with no Mage | strike dealt | of it with no Mage | the rune paid | worth vs a bare 10% | depth of 49 |
|---|---|---|---|---|---|---|---|---|---|---|
| A, none (HP) | 150 | 660 | 7.92 ±0.12 | 0.74 ±0.05 | 0.144 | 614 | 0.122 | — | — | 19.4 ±0.8 |
| A, 12% (HP) | 150 | 610 | 7.73 ±0.11 | 0.73 ±0.05 | 0.147 | 613 | 0.135 | 8.8 ±1.2 | 0.15 | 18.4 ±0.8 |
| A, 50% (HP) | 150 | 595 | 7.37 ±0.12 | 0.72 ±0.05 | 0.128 | 576 | 0.140 | 26.7 ±3.3 | 0.49 | 18.3 ±0.6 |
| **A, 75% (HQ)** | 150 | 657 | 7.54 ±0.11 | **0.73 ±0.05** | 0.115 | 616 | 0.134 | **35.4 ±4.6** | **0.61** | **19.4 ±0.7** |
| B, none (HP) | 150 | 404 | 6.33 ±0.12 | 1.05 ±0.07 | 0.080 | 510 | 0.055 | — | — | 13.1 ±0.5 |
| B, 12% (HP) | 150 | 376 | 6.22 ±0.25 | 1.08 ±0.08 | 0.107 | 498 | 0.076 | 4.1 ±1.2 | 0.08 | 12.7 ±0.5 |
| B, 50% (HP) | 150 | 398 | 6.18 ±0.10 | 1.02 ±0.07 | 0.074 | 519 | 0.077 | 13.3 ±2.3 | 0.26 | 13.1 ±0.5 |
| **B, 75% (HQ)** | 150 | 426 | 6.41 ±0.17 | **1.04 ±0.07** | 0.078 | 521 | 0.079 | **17.6 ±2.9** | **0.35** | **12.8 ±0.5** |

*Worth* is HP's report formula: what the live part paid over 10% of the damage dealt without it, `paid / (0.10 ×
(dealt − paid))` — it reproduces HP's 0.26–0.49 at 50% and 0.08–0.15 at 12%.

- **What it pays.** While it holds it multiplies the three standing heroes' strike damage by **exactly 1.75** (no-Mage
  damage over the same damage less its live part, both parties; 1.50 at 50%). Over a normal fight: **+35.4 (A), +17.6 (B)**.
- **What it is worth against the bare 10%: 0.61 (A), 0.35 (B)** — up from 0.49 and 0.26, and still the least of the three
  (Dirge 0.72–0.86, Empty Pulpit 0.77–0.81), because no Mage stands for 11.5% (A) and 7.8% (B) of hero turns.
- **Falls and depth: unmoved.** 0.73 and 1.04 falls a normal fight against 0.74 and 1.05 with no crest; depth 19.4 and
  12.8 against 19.4 and 13.1. Revives 0.003 and 0.009 a normal fight — the bot still all but never revives, so a switch
  off in a sim is the fight's end.
- **THE RULE IT WAS RULED ON — *the three who are left do the work of four*.** Off HP's no-crest lanes, while no Mage
  stands the three deal **0.63 (A) and 0.51 (B)** of the four's strike damage a round (0.66 and 0.49 counting every
  source); at 1.75 that is **1.10 and 0.89** of the four's work — party A over, party B under, about one between them,
  the gap being which Mage is lost. Read live inside the 75% lanes it is lower, **0.92 and 0.75**, because in those lanes
  the three deal less of the four's damage before the rune (0.53 and 0.43): a stronger rune ends the easy no-Mage
  stretches sooner, so the stretches left are the hard ones (in A the share falls 0.63 → 0.56 → 0.53 across none, 50% and
  75%; B's readings are too few to say).

**DOES 75% HOLD? YES, ON THE RULE IT WAS RULED ON**: the three standing do about the work of four while no Mage stands. Its
worth over a fight stays the lowest of the three and it moved no fall and no depth — **and that is how often its condition
holds, which is the state's property, the way Empty Pulpit's flag was ruled**. Raising the figure to close the gap would
pay the rune for the Mage staying alive. **Nothing is proposed.** The lanes, the analyser and every reading are in the
scratchpad of this session (`hqm_logs/`, `hqm_results.txt`).

### §1.2 — ET'S CONTRACT HOLDS; THE BRIEF'S LINE WAS THE ERROR

Nothing changes. `rune_field_medic`, its read site and its log name stay beside the retired entry, and **171** is the
count. **The record that HP's brief line was the error** is in `CLAUDE.md`'s crest block (the Fellowship bullet) and in
`docs/state.md`, so a later reader does not take it for a reversal; `check_hp` §5 holds the sentence.

### §1.3 — `heroes_hold_core` IS READ AS THE FIGHT RUNS

**The reason, recorded with the rule (`CLAUDE.md`, the live-door bullet):** four live keys beside one stale one is a trap
for the next author, and it was stale for the reason the others were — a hero fell. **Every key on who stands is live
now**, so the spawn's read-once half is a node or a card alone (`Talents.spawn_half`), and **a payload carrying the key
refuses a consumed field**, as every live key's does.

**IT WAS NOT ONE LINE.** `Talents.party_condition_met` answers the key off `Runes.held_engines(member)` — the member's
`engines` list — and `battle._live_party`, the party the re-read hands it, carried `{key, hp}` and nothing else. With the
key in `LIVE_KEYS` and nothing more, every re-read — the opening read included — found no engine on anybody, so a crest
carrying the key could never pay (control Q02 drives exactly that). **`_live_party` hands each hero's `engines` now**, in
the member's shape, off the unit's own `engines` — which the spawn built from `Runes.held_engines(Run.party[i])`, and which
nothing in the battle writes (GM §2, still swept) — so the opening read and every later one ask the spawn's question.

**DRIVEN AS A CYCLE (`check_hp` §1f), HP's PRINT NOW AN ASSERTION.** The key asked of a party whose only Pack Bond holder
stands reads **true**, and with him down **false**. Then a real fight on the Dragonbone Idol's base, the crest carrying
+0.25 damage dealt on `heroes_hold_core: "pack"`: it opens paying on all four (0.35, no tail in the roll call); **the
Hunter — the one holder — falls through the damage door and it stops on all four at 0.1 exactly** (`==`; a subtraction
would have left 0.09999999999999998), one OFF line; **he rises through the battle's own Revive Potion and it pays the same
bits it opened with**, one ON line. A fall that is not the holder's (the Mage, its own fight) switches nothing; a party
whose Hunter holds Lethal Aim opens with it not paying and the roll call saying it waits.

### §1.4 — TITHE'S WORDS STAND; THE TALENT'S ARE NARROWED

> **Breaking Heals a Hero** — *An attack that lands Break heals the lowest-health hero for 20% of it.* (PROPOSED)

The site is `_resolve`'s strike loop, on a hero's blow into an enemy that carries Break, paying the share of the Break
applied to the standing hero lowest by share of health — the node's `blood_communion` summed with Tithe's
`rune_blood_communion`. The words now say *an attack that lands Break*, as Tithe's do; its exceptions stay invisible. **The
read site is not widened** — that is the talent rebalance, still owed in `docs/state.md` with HO's figures. `master.html`'s
talent table carries the new words; `check_hp` §4 holds the sentence at the node's own figure and the old one gone from
the talent and from master.html's copy, as two arms.

### §1.5 — CAN A REFUSED PAYLOAD REACH A PLAYER? YES — SO THE TAIL IS REWORDED

**Two routes, both read in the code:**
1. **A hand-edited or modded data file.** `Runes._load` asks `Talents.live_refusal` of every entry and `push_error`s —
   and keeps the entry in the table. `Runes.eligible_ids` reads `retired`, the scope and the gates, never the refusal, so
   the entry rolls like any other: it can drop, be bought, be worn, and the spawn's roll call prints the tail.
   `check_hp` §1c asserts this route as it stands (a refused fixture in the loaded table is offered by the roll); control
   Q06 closes it and the arm reds.
2. **A save.** A rune instance carries the payload it was built with (`Runes.build` copies it), and a load refreshes a
   saved rune's NAME only (`Run._refresh_rune_names`). So a payload a later build's door refuses arrives with the save —
   **HQ's own ruling is the worked case**: a rune carrying `heroes_hold_core` on a consumed field was accepted at HP and is
   refused now. None was ever authored, and the player's save holds four core runes and nothing else (§6), so no save on
   disk carries one.

**A mod** is the first route. So the line reaches a player, and it says **"it cannot work as written, so it pays nothing
this fight"** — the roll call's own close, none of the door's words (`check_hp` §1c holds both, against a list of the
developer's: *payload*, *refused*, *consumed*, *field*, *live door*).

## §2 — THE WORD THE TAXONOMY IS MISSING: CONDITIONAL

> *A CONDITIONAL rune's payload is gated on a condition, so it pays only while that condition holds. FN's rule applies to
> it: it pays more than the bare equivalent.* — the brief's definition, taken as written.

**WHERE THE TAXONOMY IS STATED — FOUND, AND WHAT EACH CARRIES:**

| site | what it states | HQ |
|---|---|---|
| `scripts/runes.gd` — `RUNE_SHAPES`, `RUNE_TYPES`, `RUNE_SECONDARIES` and the EZ §0 / FN comment block above them, and the archetype-tag block's aside | the types and the secondaries, and that the label and the condition must agree | **defined** (a HQ §2 block), the word added, the three rows `["STAT", "CONDITIONAL"]`; the FN sub-header that said TRADEOFF was the only secondary corrected |
| `docs/master.html` — *EVERY RUNE CARRIES A PRIMARY TYPE AND AN OPTIONAL SECONDARY* and the paragraph after it | the types and secondaries — and **"NO RUNE IS CONDITIONAL. A RUNE INSTALLS AND IT IS ON."**, false since HP, with *no entry carries a condition of any kind* in the paragraph above | **rewritten to the present**: two secondaries, the three that carry CONDITIONAL, FN's relation, the 171-entry census |
| `CLAUDE.md` | no definition of the types; the FN block's retirement of THRESHOLD and BREADTH and HP §5's relation | **the rule added beside the relation** it binds: a condition of any kind earns the word, asserted both ways |
| `data/glossary.json` (the runes entry) | no labels; both secondaries in a player's words (*Some runes charge for their upside*; *Some crest runes pay only while the heroes stand a certain way*) | **one sentence**: such a rune pays more than one that always pays |
| `docs/spec-recon.html`, `docs/text-standard.html`, `docs/design-notes.md` | THRESHOLD, BREADTH and TRADEOFF as they stood (a recon; a note on FK/FN; rationale) | not edited — records of their day; a recon is regenerated, never hand-edited |

**THE POPULATION, DERIVED — NOT ASSUMED TO BE THREE.** Every one of the 171 entries, live and retired, walked for a
`condition` key at any depth of its payload (the top level, and inside every `also` and `upgrade`): **three** — Empty
Pulpit (`heroes_lack_class: cleric`), Dead Air (`heroes_lack_class: mage`), Dirge (`heroes_all_standing: false`). No entry
carries `has_node`, `owns_ability` or a retired tag key, and none carries a nested condition. **No other live rune should
carry it.** The 42 `Runes.ENGINE_READ` rows are a different shape and do not earn it: their gate is on the OFFER and the
seat (a rune that reads an engine is withheld from, and sits out on, a hero without it), never a condition in the payload,
and FN's relation does not price them.

**THE INSTRUMENT.** `check_fn` §1c asserts the word is in `RUNE_SECONDARIES`, that the rows carrying it are exactly the
entries whose payload carries a condition — both directions, every entry — and that no condition is nested (a shape the
word has not been ruled on). `check_hp` §2a holds the three at `[STAT, CONDITIONAL]`. Controls Q10–Q14 red each arm.

## §3 — TWO INSTRUMENTS THAT MEASURED THE WRONG DOOR

### §3a — THE PEDDLER COLUMNS

**Re-pointed to `Run.peddler_rune`**, and each now asserts what only that door does: per arm, the column stocks **no core
rune** while the cache beside it, on the same hero off the same seed, offers some (`check_he` +9, `check_hf` +4). **Every
cache and bargain figure is unchanged, count for count; 22 of the 23 Peddler figures that are not a withheld zero moved,
and the withheld zeros stayed zero.** The attribution is arithmetic: `Runes.generate` draws flat (`pick_random`) over the
hero's eligible pool, and the counter's door is the same pool less its core runes — so each rune's expected count rises from
400 / pool to 400 / (pool − core), and the laid seed's stream lands on other indices.

| gate | hero | rune | pool, core | HP's Peddler (generate) | expected | HQ's Peddler (peddler) | expected |
|---|---|---|---|---|---|---|---|
| he | Warrior, Blood Frenzy | Slaughterhouse | 16, 5 | 26 | 25.0 | 37 | 36.4 |
| he | Warrior, Heavy Plating | Bared Plate | 17, 5 | 35 | 23.5 | 32 | 33.3 |
| he | Warrior, the Stances | Mirror Guard | 18, 5 | 23 | 22.2 | 34 | 30.8 |
| he | Mage, Overburn | Long Fuse | 17, 5 | 20 | 23.5 | 36 | 33.3 |
| he | Mage, Permafrost | Killing Cold / Deep Cold | 17, 5 | 28 / 25 | 23.5 | 30 / 27 | 33.3 |
| he | Hunter, none | Long Poison | 17, 6 | 25 | 23.5 | 42 | 36.4 |
| he | Hunter, Trapper | Long Poison | 18, 5 | 21 | 22.2 | 34 | 30.8 |
| hf | Warrior, none | Goading Roar / Rending Blows / Grudge | 15, 6 | 26 / 27 / 27 | 26.7 | 48 / 51 / 40 | 44.4 |
| hf | Mage, none | Unravel / Seeking Missiles / Detonating Ward / Clarity / Profligate | 15, 6 | 30 / 23 / 26 / 27 / 27 | 26.7 | 52 / 40 / 48 / 51 / 40 | 44.4 |
| hf | Cleric, none | Abundance / Returned Burden / Burning Ground / Eleventh Hour / Vow of Silence | 15, 6 | 30 / 23 / 26 / 27 / 27 | 26.7 | 52 / 40 / 48 / 51 / 40 | 44.4 |
| hf | Hunter, none | Opportunist / Tusk and Bristle | 17, 6 | 25 / 21 | 23.5 | **25** / 37 | 36.4 |

Every reading sits within two and a half standard deviations of its door's expectation (a binomial standard deviation is
4.6–6.3 here); the two furthest out are HP's Bared Plate, 35 against 23.5 at the old door (+2.4), and **the one that did
not move, Opportunist, 25 at both doors** — 2.0 under its new expectation, by the stream alone. The Mage's and the Cleric's rows are identical figure for figure at both doors: the same seed over pools of the same
size and shape. HEAD's gates on HQ's tree printed HP's acceptance figures exactly (§6a), so nothing HQ changed in the game
moved them; the door is the whole of the movement. Controls: Q15 and Q16 put each column back on the shared door and every
arm reds; **Q17 breaks the game's own door** (the counter stops withholding core runes) — the re-pointed columns red
(the counter stocks 106–163 core runes an arm) and **HEAD's `check_he` reads 249 / 0**: the old column could not see the
counter's door at all.

### §3b — `test_batch_ak`'s WHOLE-POOL WALK: NARROWED, NOT GIVEN AN ASSERTION

**Narrowed, and why.** The walk is AK §7's: the shared applicator is unchanged for runes. Asking a payload what it PAYS
would take a party each condition holds for (the three crest runes apply nothing under the walk's party-less ctx — HL §6's
safe direction) and a model of every payload kind; the first is a weaker copy of `check_ez` §4's landing arm, and the second
is a second copy of `apply_payload` — *a helper copied between gates inherits its bugs*. **What the walk does prove** is that
the applicator takes every authored payload without a throw: one would abort the section, and show in the battery's throw
column and this suite's count. The message says that now, the loop prints how many payloads ask who stands (three) and pay
nothing there, and the comment names the real witnesses. Count unchanged, 338.

## §4 — HOUSEKEEPING

- **HP's TWENTY-EIGHT COPIES ARE IN THE TRASH**, selected by the *"Dawn of Decay HP "* prefix, under *"DoD spent user-data
  folders (Batch HP's twenty-eight, cleared at HQ 2026-10-01)"*: **28 folders, 17,260 KiB** (HP recorded 17,248). Godot's
  `app_userdata` went from **497 folders and 161,392 KiB to 469 and 144,152 KiB** — both readings with HQ's own seven
  isolated copies in them at the time; **490 → 462** counting only the folders that predate HQ. The 461 older folders, the
  live *Dawn of Decay* folder and `../save-backups/` were not touched.
- **`CLAUDE.md` IS 424,768 B = 414.81 KiB, WITH 55.19 KiB UNDER 470 KiB** (+3,402 B at HQ; HO 403.74 KiB, HP 411.49 KiB):
  **about 7.1 batches at HP's +7,935 B, 6.8 at the record (EZ's +8,293 B)**, 16.6 at HQ's own rate. Not split, the ceiling
  not moved; the shape recon stays queued.

## §5 — WHAT WAS DELIBERATELY NOT DONE

Whether a fallen hero stays down between fights (the Cairn, a map Revive Potion); Skirmisher and Tracker, ruled and unbuilt,
their names owed; Tithe's read site; any new rune; `heroes_class_count`'s one class; a card-granting crest rune; the crest
cap; Volley, Ambusher and Channel's tempo payout; the `CLAUDE.md` split. **And the refused entry is still offered** — the
route §1.5 found is recorded in `docs/state.md`, not closed: withholding it is a line, and whether a rune the game cannot
pay should be offered at all is the designer's.

## §6 — VERIFICATION

**THE ORDER.** The saves were backed up and verified by hash before anything else, and the whole tree copied before the
first edit (`head/`, the snapshot every sweep and HEAD arm reads). The game and data were changed first; **the Dead Air
lanes ran on that tree** (11:15–11:23); **HEAD's unmodified gates and documents were launched against it — the recon,
§6a — before any gate was edited**, the prediction stamped 11:18:01 and the run launched at 11:18:05; the gates were re-pointed
in the repository while it ran; the documents were written before the pre-pass (§6d) and the acceptance run (§6e).

**THE BACKUP.** `../save-backups/HQ-20261001-110254`: `profile.json` `2892470f…`, `relics.json` `fdc12ffa…`, `run_save.bin`
`fa85daa9…`, `settings.cfg` `0c1b39c3…` — each byte-identical to the live file and to HP's backup. The player's run save
is HP's, unchanged since 2026-09-28: four core runes, no crest, no bag.

### §6a — THE RECON: HEAD'S INSTRUMENTS AGAINST HQ'S GAME

HEAD's every root script, runner, baseline table, pin manifest **and every document**, against HQ's four edited game
files, in an isolated copy seeded from the backup — the documents held at HEAD's text on purpose, so that a red is the
game's and never a document's lag. **131 targets in 75 min 36 s (11:18:05 → 12:33:41); `check_de` 541 / 2 / 0 notices.**
No Parse Error, no SCRIPT ERROR, no TIMED OUT and no NO VERDICT.

| target | HEAD's instrument on HQ's game | against the prediction |
|---|---|---|
| `check_hp` | 145 / 8 | **exactly as predicted, line for line**: §1a ×3 (five live keys; the key not read once; a `heroes_hold_core` payload live), §1c ×1 (a payload carrying it on a consumed field refused), §1f ×1 (the max-health fixture paid on 0), §2a ×3 (the shape `[STAT, CONDITIONAL]`) |
| `check_fx` | 496 / 1 | **NOT predicted**: §1 holds every talent's text to the words its number sits in, and *for 20% of its value* is not in the narrowed talent. Re-pointed (§6b). |
| `check_cm_live`, `check_gj` | 13 / 4, 70 / 1 | sanctioned; their FAIL lines HP's acceptance character for character |
| `check_he`, `check_hf` | 249 / 0, 310 / 0 | **their printed tables HP's acceptance line for line** — nothing in HQ's game moves a rune roll |
| `test_batch_an` | 6051 | inside its band [6047, 6066] |
| every other target | HP's acceptance count | as predicted — `check_hl` among them, whose §6 moved its `heroes_hold_core` case onto the live door by itself and paid at the opening only because `_live_party` hands the engines |

### §6b — THE RE-POINTS, AND THE COUNTS THAT MOVED

**Six gates re-pointed, each to its intent, with its reason at the site**, and each row's reason in `baselines.json`:
`check_hp` (§1a, §1c, §1f, §2a, §2e, §4, §5: 145 → 168), `check_fn` §1c (82 → 85), `check_he` §1 (249 → 258), `check_hf` §3
(310 → 314), `check_fx` §1 (its phrase; 496 unchanged) and `test_batch_ak` §7 (its message; 338 unchanged); `check_hl`'s
comment. **Every count that moved is the arms a section gained**, counted per section in each row (`check_hp`: §1a +4,
§1c +3, §1f +7, §2a +3, §4 +3, §5 +3); no arm was removed, and the re-pointed arms each still ask one question. `check_ed`
read 18 / 1 against HEAD's manifest before the regeneration — every one of its 1,131 verified pins still resolving, and the
one failure naming exactly `check_hp`'s seven new pins as unrecorded — and 18 / 0 after it (1,644 → 1,657 pins: `check_hp`'s
fifteen new, two re-filed under §1f's new name; the unresolved set HEAD's, unchanged).

**The gates that walk gate files or read the documents**, standalone on the finished tree: `check_parse` 205, `check_da` 41,
`check_ea` 236, `check_ec` 24, `check_ed` 18, `check_ek` 47, `check_es` 57, `check_ff` 68, `check_fg` 22, `check_fr` 25,
`check_gw` 76, `check_dw` 35, `check_hi` 11, `test_batch_cd` 92 — all 0 failures and no throw.

**THE LITERAL SWEEP.** Every string literal of the 270 root scripts of HEAD and HQ (16,810 needles, floor four characters)
looked for in HEAD's copy and HQ's of each of the nineteen edited files: **25 lost, 457 gained** (313 of them the new report,
which nothing reads). Every lost needle read at its reader: twelve are the re-pointed gates' own retired messages and
phrases, lost from their own files; *Every point of Break damage dealt* is `check_hp` §4's absence needle, lost from the
talent and from `master.html` by design; the rest — *as the fight opens*, `has_node`, `owns_ability`, `generate_rune`, the
`heroes_…` keys — stood in prose of `master.html` and `docs/state.md` that no holder of them opens. Run against the pin
manifest as well, **no recorded pin into any edited file changed presence between HEAD and HQ**.

### §6c — THE CONTROLS

**Eighteen, one defect each, in a clone of the finished tree, read by FAIL text**; every injection asserts its anchor
lands exactly once and its needle is gone after it. **Every one reds with the line it names.** Seventeen ran first on the
tree as it stood at 11:36; **all eighteen ran again on the finished tree** (after `check_fx`'s re-point, which added Q18 and a
second witness to Q08, and a `check_hf` comment), the seventeen reading exactly as they had.

| | defect | reds |
|---|---|---|
| Q01 | `heroes_hold_core` out of `LIVE_KEYS` again | `check_hp` §1a ×5, §1c, §1f (the base not returned, no switch line) — **HEAD's `check_hp` reds only §2a's shape**: it cannot see the key |
| Q02 | **the brief's one line alone** — the re-read hands no engines | `check_hp` §1a (the source arm), §1f (*opened paying on 0 of the four*, no switch either way); `check_hl` §6 (*a core rune held by anyone … paid on 0 of 4 heroes*) |
| Q03 | the reversal adds a figure on and takes it off (HP's H03) | `check_hp` §1f's `==` (0.1 + 0.25 − 0.25), with §1d and §2c |
| Q04 | the key counts every hero, fallen or not | `check_hp` §1f (*true … and true with him down*; the base not returned) |
| Q05 | the refused tail back in the door's words | `check_hp` §1c (*"payload", "refus" are not a player's words*) |
| Q06 | a refused entry withheld at the roll | `check_hp` §1c (*a refused entry is not offered by the roll — the route … is gone*) |
| Q07 | Dead Air back at 50% | `check_hp` §2a (*the designer ruled 0.75*); `check_fn` stays green — it holds the relation, and 0.50 is beyond 0.10 |
| Q08 | the talent's old words | `check_hp` §4 ×2; `check_fx` §1 (the re-pointed phrase) |
| Q09 | `master.html`'s copy of the talent's old words | `check_hp` §4 (*master.html's copy*) alone |
| Q18 | the talent's text at 25% over a payload of 20 | `check_fx` §1 (*does not say `for 20% of it.`*), `check_hp` §4 |
| Q10 | Dead Air's row loses CONDITIONAL | `check_hp` §2a, `check_fn` §1c |
| Q11 | Tithe labelled CONDITIONAL, no condition | `check_fn` §1c |
| Q12 | CONDITIONAL out of the vocabulary | `check_fn` §1c |
| Q13 | a condition nested in an `also` | `check_fn` §1c |
| Q14 | a rune on a NODE's condition, no label | `check_fn` §1c — the population is any condition, `has_node` among them |
| Q15, Q16 | each Peddler column back on the shared door | `check_he` §1 ×9, `check_hf` §3 ×4 (*stocked 106–163 core runes*) |
| Q17 | **the game's Peddler door stops withholding core runes** | `check_he` §1 ×9 and `check_hf` §3 ×4 — **HEAD's copies read 249 / 0 and 310 / 0** |

**The reversed arm of every re-point is the recon**: HEAD's copy red on the clean tree where the re-pointed one is green.

### §6d — THE PRE-PASS

The finished tree in an isolated copy seeded from the backup, **proved equal to the repository by hash (500 files,
`project.godot` aside)**, the prediction stamped 12:42:41 and the run launched at 12:42:46. **131 targets in 75 min 06 s
(12:42:46 → 13:57:52); `check_de` 541 / 0 / 0 notices. Every target read its predicted row**: `check_hp` 168, `check_fn`
85, `check_he` 258, `check_hf` 314 (their Peddler tables the work copy's, line for line), `check_fx` 496, `test_batch_ak`
338, `check_hl` 169, `check_parse` 205, `check_ed` 18, `check_hk` 142 with the copy seeded, the two sanctioned reds at
their counts with HP's FAIL lines character for character (`check_cm_live` 13 / 4, `check_gj` 70 / 1), `test_batch_an`
6050 inside its band, the run harness's three gates PASS (22 / 382 / 8). **No Parse Error, no SCRIPT ERROR, no TIMED OUT
and no NO VERDICT line in any of the 131 logs.** `check_gp` and `check_gv` ran at HP's pace.

**AFTER THE PRE-PASS'S COPY**, four files moved: `CLAUDE.md` (one line re-wrapped and four words of one sentence, +4 B),
`docs/state.md` (the two byte figures for `CLAUDE.md` that the re-wrap moved), `docs/changelog.html` (one sentence on this
run) and this report. Swept against the copies the pre-pass read, all 16,810 needles: **lost 0, gained 0** in each of the
three that a gate opens. The acceptance run reads all four.

### §6e — THE ACCEPTANCE RUN

In the repository, the tree frozen — every file hashed by absolute path before the launch (500, untracked included,
`save-backups/` excluded) — and the player's four files hashed, the prediction stamped 13:59:13 and the run launched at
13:59:18. **131 targets in 75 min 05 s (13:59:18 → 15:14:23); `check_de` 541 / 0 / 0 notices. Every target read its row
and its pre-pass reading** but `test_batch_an`'s seeded count (6049 against 6050, inside its band): `check_hp` 168,
`check_fn` 85, `check_he` 258, `check_hf` 314, `check_fx` 496, `test_batch_ak` 338, `check_hl` 169, `check_parse` 205,
`check_ed` 18, `check_hk` 142, the two sanctioned reds at their counts with HP's FAIL lines (`check_cm_live` 13 / 4,
`check_gj` 70 / 1, the card +175 against a purse of +195), the run harness's three gates PASS (22 / 382 / 8). **No Parse
Error, no SCRIPT ERROR, no TIMED OUT and no NO VERDICT line in any of the 131 logs.** `check_gp` ran 228.7 s against its
480 and `check_gv` 615.8 s against its 1200.

**The tree was byte-identical after the run, 500 of 500 files, and the player's four files are byte-identical — hash,
size and mtime — and equal to the 11:02 backup.** What the run wrote in the player's folder was the gates' own scratch
files beside the four.

**AFTER THE RUN**, `docs/state.md`'s verification line and this report were written — nothing else moved. `docs/state.md`
is opened by two gates, `check_es` and `check_hp`; both were re-run on the final tree — **57 / 0 and 168 / 0** — and the
file, swept against the copy the run read (proved by its hash in the freeze), lost no needle and gained one, `ERROR`, which
`check_de` looks for in battery logs and never in this file.

## §7 — FOUND AND NOT FIXED

- **A REFUSED ENTRY IS STILL OFFERED** (§1.5, §5).
- **A STRONGER DEAD AIR SHORTENS THE STRETCHES IT PAYS IN** (§1.1): a live rune's worth over a fight reads under its moment.
- **`check_hl` §6's MAXIMUM-HEALTH BRANCH HAS NO CASE**: every key §6 drives is live, so `_fx_field`'s stamp branch is for a
  read-once condition no case drives. Kept, and said at the site.
- **`docs/spec-recon.html` AND `docs/talent-audit.html` describe the taxonomy and the talent as they were** — records of
  their day, not edited.
- **`check_fn` §1b DOES NOT PIN A RULED FIGURE** (control Q07: Dead Air back at 50% leaves it green — 0.50 is still beyond
  the bare 0.10). It asserts the relation; `check_hp` §2a holds the three at the ruling, which is where a ruled figure is
  pinned (`check_cn`'s shape).
- **On the machine**: HQ's own isolated copies, every one named *"Dawn of Decay HQ …"* — **eight folders, 1,924 KiB**:
  `work`, `head`, `recon`, `prepass`, `ctl1`, `ctl2` and the two measurement lanes (`lane A75_dead_air`, `lane
  B75_dead_air`). HR clears them by that prefix (HO §5's rule). Godot's `app_userdata` holds 470 folders, 144,416 KiB,
  the live *Dawn of Decay* among them.

## §8 — WHAT MOVED

- **The game**: `data/runes.json` (Dead Air 0.75 and its words), `scripts/talents.gd` (`heroes_hold_core` in `LIVE_KEYS`;
  *Breaking Heals a Hero*'s words; two comments), `scripts/battle.gd` (`_live_party` hands the engines; the refused tail),
  `scripts/runes.gd` (CONDITIONAL: the word, the three rows, the definition).
- **The data**: `data/glossary.json` (the runes entry's CONDITIONAL sentence).
- **The instruments**: `check_hp` (§1a, §1c, §1f, §2a, §2e, §4, §5), `check_fn` §1c, `check_he` §1, `check_hf` §3,
  `test_batch_ak` §7, `check_hl` (a comment); `pin-manifest.json` (1,644 → 1,657); `baselines.json` (four rows, two notes).
- **The documents**: `CLAUDE.md` (the crest block, the FN block, an index row), `docs/instrument-rules.md` (HP §1's block
  re-pointed; *A TALLY NAMED FOR A DOOR ROLLS THROUGH THAT DOOR*), `docs/master.html` and its stamp, `docs/state.md`,
  `docs/changelog.html`, `docs/design-notes.md`, and this report (**new**).
