# BATCH IG — EVERY CHIP, AND SANCTITY

**On `class-merge`, from `fd83ae7` (IF). IMPLEMENT ONLY.** **Nothing has been played: `run_save.bin` is unmoved since 2026-10-08
09:23 — eleven batches now — and the designer's folder holds no `readout/`, so the readout has never run in his game.** The brief
hoped this had changed; it has not, and it moves one thing: **there is no file of his whose Sanctity lines are a *before*** — played
on IG's build, his file reads the step IG set, on a ledger with no chip in it, and is that step's confirmation (ruling 1).

**§1: every display chip is drawn, not laid as a status** — the nineteen of IE's census, nine a run reaches and ten dormant, in
`BattleUnit.display_chips`; nothing ticks, cleanses, dispels or counts one, none books a Sanctity event or floats a die, and every
`add_status` left in the game is the status door's or one of fifteen named effects (`check_ig` §1a). **§2: Sanctity's step is 13**
(16), measured on §1-only code before anything else moved: an untalented rung-1 normal fight now ends at 2.58 steps of 5. **§3: the
Kit panel's first section reads STARTING KIT** — the bare KIT was looked at on the real screen and not taken. **§4: the member
carries the bar's true maximum** — a +20 node's twenty points are kept between fights; a hero with no node reads 100 everywhere.
**The verification**: two recons of HEAD's battery — §1 alone (`check_de` 601 / 13: every red named but `check_ed`, the
manifest) and all of IG's code (601 / 14) — each predicted after its literal sweep; **no seeded count moved, though the dice moved
inside four roads**, put on the chips' floats by a stub that reads HEAD's logs; twenty controls and HEAD's code, each in its own
clone, every one biting (one found a hole in `check_ig` §4, repaired and proved two-armed); the document readers on the final
documents; the pre-pass and the acceptance, 147 targets, each closing **`check_de` 605 / 0 / 0 as predicted**.

**VERDICT: GREEN.** §1, §2, §3 and §4 are built, none dropped, in the brief's order: §2's step was measured on §1's code before §3
or §4 existed. Every moved row is moved with its cause (`check_if` +5, `check_ig` new, `check_parse` +1 — IG's own gates); the dice
that moved inside four seeded roads are the chips' floats, by stub; twenty controls and HEAD's code bite; the pre-pass and the
acceptance both closed `check_de` 605 / 0 / 0 as predicted, the tree byte-identical and the player's files untouched. **Two
rulings are owed, and the first is still the designer's play.**

**THE ONE LINE THAT MATTERS MOST: play one zone, then send the file.** It is
`~/Library/Application Support/Godot/app_userdata/Dawn of Decay/readout/run-<date>-<time>.jsonl` — the newest one is the run being
played. Nothing needs switching on. Five rulings come off it, and Sanctity's step is now one of the things it confirms.

## NEEDS A RULING

1. **PLAY ONE ZONE AND SEND THE FILE.** Still the one that matters. It answers Boil Over's rate, Rupture's number, the vow's worth,
   Sanctity's step (now set — ruling 2) and the Cleric's Mana. Played on IG's build, its Sanctity lines are the *after*: there is no
   *before* file, because nothing was played on IF's.
2. **SANCTITY's STEP AT 13 (§2).** The number is yours to confirm, and here is what it does: an untalented rung-1 normal fight ends
   at **2.58** steps (14 would read 2.38 — 13 is the nearer to 2.5); a boss fight reaches the cap in **42.8%** of fights at 13
   against 17.6% at 16 on the same honest count (20.3% at HEAD's 16). **A boss maxing the ladder is not new** — about one boss
   fight in five did at 16 — **it is more than twice as common.**

## THE BRIEF'S PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §7: IF's push hash; IF pushed twice (`661183d`, then a wording repair) | **Held**: `fd83ae7…` on the remote and at local HEAD, read before anything ran; `661183d` is its parent; the tree clean but the untracked `save-backups/` |
| 2 | §7: IF's backup `../save-backups/IF-20261013-152812`; `run_save.bin` unmoved since 2026-10-08 09:23 | **Held, and the hope did not come true**: the four player files md5-identical to IF's backup; backed up to `../save-backups/IG-20261013-211441`, verified by md5; `run_save.bin` 42,200 B, 2026-10-08 09:23; **no `readout/` folder** |
| 3 | §0.1: the file's Sanctity lines are the *before* | **Not held**: no file exists; played now, it is the *after* (ruling 1) |
| 4 | §0.2: untalented Cleric 11.5%, Mage 16.4%, Hunter 20.9%; dry one turn in nine, opens full 7.7% | **Held** (IF §0.1b's table; 11.5% is one in 8.7) |
| 5 | §0.2: the Hunter 36.0% → 20.9% untalented | **Held** (IF §0.1b) — recorded on the watch list, not tuned |
| 6 | §0.3: 10% of Attack, Break 8, Perfect 12%; Rupture 15.3% against 0%; `RUPTURE_BREAK_PER_TICK` 10 | **Held**, all unmoved |
| 7 | §0.4: CORE means a core rune on the rune panel, the hero sheet and the kit preview | **Held**, and **one more use of the word for the kit**: the Kit panel's note read *The protected core can never be benched*, and its empty line *No core card.* (§3) |
| 8 | §0.4: the Peddler is no draft source (FD §1) | **Held** |
| 9 | §0.5: a fixed 100 clips the +20 at every door between fights | **Held, and two of the doors CUT a bar, not only cap it**: a Mana Potion drunk on the map (`mini(mana + restore, max_mana)`) and an event's `mana_pct` (`clampi(…, 0, max_mana)`) took a bar carried at 110 down to 100; the Hourglass (`restore_mana`) has not lowered one since IF (§4a) |
| 10 | §0.5: the save carries it; an older build reads it and writes it back | **Held**: `max_mana` is a member key and the party is saved whole — the designer's own save carries it four times; an older build reads it as generously as this one and writes it back. **No version moves** |
| 11 | §0.5: the designer's profile buys no node | **Held**: `talent_cells` is empty (`talent_tier` 3, points banked and unspent) |
| 12 | §1: nine chips a run reaches, ten dormant, fifteen effects | **Held**: IE's sweep re-run on IF's tree — 35 `add_status` calls, 34 literal ids and the door's |
| 13 | §1: *Faith churns an event at every release on every shielded ally … the largest single contributor* | **Not held, twice.** A release REFRESHES the chip and never removes it (BI §1: the peak keeps paying, so the chip stays up at Fa0), so Faith books one landing a body a fight; and Faith is the Devout's, the ledger the Hierophant's, and a party holds one Cleric — Faith reaches his ledger only when he holds Conviction second. **Iron Will was the big one**: 4.00 events of the chips' 4.87 a default-build fight (Faith 0.25); untalented — the designer's build, no Iron Will — 1.04, Loyalty 0.55 and Faith 0.33 (§2a) |
| 14 | §1: a chip on a companion (Loyalty) and on an ally (Faith) is laid on a body that is not the holder | **Held, and kept there**: driven (`check_ig` §1c, §1d) |
| 15 | §7: *§1 removes nineteen `add_status` calls, so `check_hu` §2b and `check_di` will both move* | **Half**: nineteen removed (35 → 16); **neither gate moves** — `check_hu`'s `add_status` arm is §2a, and it asserts the variable-id calls (the door's alone), which §1 did not touch; `check_di` counts `_apply_status(` (221), which §1 does not call. Counted before the prediction (§8a) |
| 16 | §2b: IE read 2.61 steps inflated, 2.19 honest; a boss ran 66.4 events untalented | **Held** (IE §2b) |
| 17 | §5: IF used twenty-six folders; IF read 587 folders and 252,176 KiB at its close, spent 559 and 225,196 | **Held**: IG read 587 before its first folder; the spent prefixes FX–IF read 585 and 251,660 KiB today (IF's 26 at 26,464 KiB) |
| 18 | §6: `docs/state.md` +952 at ID, +3,917 at IE, +236 at IF — a mean of 1,702 B, about 21.8 batches; the worst case 6.3 | **Held** (IF §5) |
| 19 | §6: the claims stand at 86 | **Held** (not re-counted; IJ's) |
| 20 | §7: IF read 146 in 81 min 31 s | **Held** (IF §8g) |
| 21 | §7: §1 moves no pool depth — say so after checking | **Held, checked**: the diff touches no card, rune, shelf or pool definition, so `master.html`'s live draft count (179) and the family that pins it are unmoved |

## §0 — IF's FIVE RULINGS, ANSWERED

- **§0.1 — THE ASK IS MADE.** Nothing to build; it is IG's ruling 1, now the step's confirmation rather than its *before*.
- **§0.2 — THE RATE STAYS 12, CONFIRMED.** Recorded in `docs/state.md` beside the rate's figures; **the Hunter's fifteen points**
  (36.0% → 20.9% untalented, because the relic began reaching him) are on the watch list and nothing touches the relic. IE's and
  IF's dry fractions on the default build were taken while the member's maximum was a fixed 100 (§4 changes it for a node-holder;
  the untalented rows hold no node).
- **§0.3 — SMOULDER's THREE FIGURES STAND.** Nothing moved; Rupture's 10 is the readout's.
- **§0.4 — THE HEADS STAND BUT CORE, WHICH READS STARTING KIT** (§3), and the rule is asserted (`check_if` §3c).
- **§0.5 — THE MEMBER CARRIES THE TRUE MAXIMUM** (§4), measured first.

## §1 — EVERY DISPLAY CHIP IS DRAWN

### §1a — WHAT WAS BUILT

`BattleUnit.display_chips` holds them, beside IE's `engine_chips` and in the same shape (id, label, short, color, turns, desc,
power): **`set_display_chip`** lays or rewrites one and draws the row, **`display_chip`** / **`has_display_chip`** read one,
**`update_display_chip`** rewrites a standing chip's words (false when none stands — `update_status`'s contract, so a caller's
lay-on-a-miss reads as it did), **`remove_display_chip`** takes one off. The row draws the engine chips, then the display chips,
then the statuses. **What the writer does not do is the point**: no `note_status_event`, no `float_text` — the status door's two
acts for a status arriving — and a chip's `turns` is shown and never counted down (Enraged's chip shows its own field's timer).
`_die()` clears the display chips with the statuses, so a body that falls takes its chips, as it did while they were statuses.

**The nineteen sites, each converted where it stood**: Iron Will and Crushing Blows at the spawn; Melt Armor at a burn tick;
Endurance at a turn's start; Eagle Eyes, Crushing Blows' live figure, Scent of Blood, Deathwish, Refuse Death's *UNDYING*, Killing
Edge and Bracing in `_update_talent_chips`; Waiting Guard at the turn's start and at the parry roll; Loyalty and Aper's Rhythm on the
companion; the Holy Capacitor at a heal and its release; Feint's and Berserk's banks; Faith; Deadfall; Enraged in `unit.take_hit`
and its timer in `tick_cooldowns`. **Faith stays on the ally who holds it, Loyalty and Aper's Rhythm on the companion** — each is
laid on the body the old status stood on (`check_ig` §1c, §1d).

**THE SWEEP, RE-RUN AND KEPT, AND NOW ASSERTED** (IC's rule): IE's `chip_sweep.py`, comments stripped — **35 calls at IF's tree, 16
now: the status door's `add_status(id, …)` and fifteen effects** (`seeding`, `standard`, `rally_heal`, `crossfire`, `bear_brunt`,
`held_breath`, `instinct`, `charging`, `fortified`, `anointed`, `bloodbond`, `ghostpack`, `elusive`, `unrelenting`, `broken`), each
read back for its payout. `check_ig` §1a asserts exactly that — the variable-id calls the door's alone, the literal ids exactly the
fifteen, each with a reading line — so a literal call nobody sorted reds; §1b asserts each of the nineteen is laid by
`set_display_chip` and named by no status verb anywhere in the game.

### §1b — WHAT IT CHANGES, AND WHAT IT DOES NOT

**Sanctity**: no chip is an event (§2a measures the fall). **The dice**: every chip landing floated a label, and a float spends one
`randf_range`; those are gone (§8c attributes every moved road). **The counts**: a chip was a status to everything that walks a
body's list — but every such walker in the game filters `DEBUFF_IDS`, so the one chip any count could see was **Melt Armor**, the
one chip in that list, and it is dormant (no node writes `melt_ranks`). Its entry in `DEBUFF_IDS` is inert now — FOUND AT IG,
`spec_passive`'s twin. **The row's order**: the display chips draw together after the ★ engine chips, where each used to stand
wherever it landed among the statuses. **Enraged** (dormant): the status door gave it Fleeting's shorter clock and `tick_statuses`
ran it out a turn before its own field did; its chip now shows the field's timer.

## §2 — SANCTITY's STEP, MEASURED THEN SET

### §2a — THE MEASUREMENT, ON §1-ONLY CODE (§0.6)

Taken before §2, §3 or §4 existed: IE's probe (`probe_patch.py`, `probe_hiero_patch.py` — a Hierophant beside the default lineages,
the Cleric awakened with the Hierophant's rune) plus a per-status tally of the ledger at every fight's end (IG's
`probe_ids_patch.py`), in scratch copies of HEAD's code and of §1's alone (`treeA/`, the very scripts recon A ran). Rung 1, 20 runs
a party at HEAD, the untalented §1 arm 60.

| | IE's HEAD | IE (§2a) | **IG's HEAD** (IF's code) | **IG §1** |
|---|---|---|---|---|
| Events at a fight's end, default build (all / zone 1 / 2 / 3) | 49.3 / 41.5 / 50.4 / 55.5 | 42.6 / 36.5 / 43.4 / 47.6 | 43.7 / 36.6 / 44.2 / 49.6 | **38.5 / 31.4 / 39.7 / 43.9** |
| Steps at a fight's end, default (16 a step) | 2.60 | 2.18 | 2.25 | **1.94** |
| A normal fight / an elite / a boss, default | 49.2 / 44.5 / 63.9 | 42.1 / 39.1 / 56.7 | 43.2 / 39.5 / 59.1 | **39.3 / 34.1 / 51.0** |
| His first step, by his turn (fights reaching it), default | 1.12 (99.9%) | 1.90 (98.5%) | 1.86 (99.0%) | **2.47 (94.6%)** |
| His second step, default | 3.08 (83.5%) | 4.04 (67.1%) | 4.00 (70.4%) | **4.44 (55.6%)** |
| Untalented: events at a fight's end (all / zone 1 / 2 / 3) | 50.5 / 38.5 / 53.4 / 65.0 | 44.0 / 34.2 / 47.3 / 53.1 | 43.0 / 34.5 / 45.3 / 51.9 | **42.1 / 32.7 / 45.5 / 51.6** |
| Untalented: a normal fight / an elite / a boss | 50.5 / 42.8 / 71.9 | 42.7 / 38.0 / 66.4 | 42.3 / 36.7 / 63.8 | **41.0 / 36.1 / 64.5** |
| **Untalented: steps at a normal fight's end (16)** | 2.61 | 2.19 | 2.14 | **2.06** |
| Untalented: his first / second step (16) | 2.38 (95.5%) / 4.74 (71.3%) | 3.46 (91.1%) / 5.89 (62.6%) | 3.37 (90.7%) / 5.72 (57.9%) | **3.54 (88.2%) / 5.99 (55.3%)** |

Default build 1,658 fights at HEAD and 1,697 at §1; untalented 1,391 and 3,988. **IG's HEAD reads IE's §2a within the run's spread**
(IF's Smoulder and the Hourglass's reach are the only game changes between, and neither touches a Hierophant's party much).

**THE FALL, BY ID** — the ledger's own keys at HEAD, a fight: **default build 4.87 chip events of 43.65 (11.1%) — Iron Will 4.00,
Loyalty 0.42, Faith 0.25, Aper's Rhythm 0.12, Refuse Death 0.05, Deadfall 0.01**; the fall in the total is 5.16 (the rest is the
run's own spread). **Untalented 1.04 of 42.96 (2.4%) — Loyalty 0.55, Faith 0.33, Aper's Rhythm 0.09, Deadfall 0.03, Eagle Eyes 0.02,
Berserk 0.01**; the fall in the total is 0.90. **Faith's share of the fall: 5% on the default build, 32% untalented — the second
largest on the designer's build, after Loyalty; Iron Will is 82% on the default build and absent on his** (a node; he buys none).

### §2b — THE STEP, SET TO FV §3's OWN TARGET

On the untalented §1 population (60 runs a party, 1,834 normal fights), the mean steps at a normal fight's end for each step size:

| step | 10 | 11 | 12 | **13** | 14 | 15 | **16** | 17 | 18 |
|---|---|---|---|---|---|---|---|---|---|
| normal fight, mean steps | 3.24 | 2.99 | 2.79 | **2.58** | 2.38 | 2.22 | 2.06 | 1.92 | 1.79 |
| boss: mean steps / at the cap | 4.63 / 74% | 4.45 / 62% | 4.25 / 52% | **4.04 / 43%** | 3.78 / 32% | 3.56 / 23% | 3.37 / 18% | 3.18 / 14% | 3.00 / 11% |

**`SANCTITY_PER_STEP` 13**: 2.58 steps, the nearer to 2.5 (14: 2.38). The first 1,281 fights alone read 2.60 at 13 and 2.40 at 14
— a tie inside the noise — so the arm was run three times over before the number was set. **At 13 on the default build**: a normal
fight 2.51 steps, a boss 3.40 (18.3% at the cap). **Untalented, his first step comes at his turn 3.04 (92.5% of fights) and his
second at 5.13 (68.3%)** — a third to two thirds of a turn earlier than at HEAD's 16 (3.37 and 5.72). **A boss maxing the ladder is not new**: at HEAD's 16, 20.3%
of untalented boss fights reached the cap; at 13 on the honest count 42.8% do (ruling 2). Recorded in `docs/state.md` (SANCTITY's
STEP) as a tuning handle; `check_ig` §2 pins it in one place; **the readout carries his steps a fight, so the designer's play
confirms it.**

## §3 — STARTING KIT

**The Kit panel's first section reads *STARTING KIT — never benched*** — **STARTING KIT, not the bare KIT, and the screen is why**:
rendered beside the rune panel's own CORE section (a windowed probe in a renamed clone; three PNGs), the map card's button that opens
this panel reads **Kit 4/7**, counting the four starting cards *and* the carried one. A section called KIT inside it names the whole
and one part of it at once, and it sits directly above CARRIED's Bench buttons, so it reads as if the whole kit cannot be benched.
STARTING KIT says what the section holds — the cards he opened with, against the ones he earned.

**And two more lines on the panel called the kit *core*, which the brief did not name**: the note above the sections (*The
protected core can never be benched*) and the section's empty line (*No core card.*). Both are the same rot one line away, and the
rule the brief set cannot be asserted with them standing, so both moved — *The starting kit can never be benched* and *No card in
the starting kit.* — **against the brief's *nothing else in either panel moves***; reported here so it can be undone in one line each.
Every other *core* on the panel names a core rune (*ENABLERS — brought by a core rune*, *no slotted core rune brings a card*).

**THE RULE, ASSERTED** (`check_if` §3c, which already walked the three sectioned panels): each panel's section heads are read off
the real screen with the kind of thing its rows list — the rune panel and the crest's bag list runes, the Kit panel cards — and it
reds on **a head word over runes on one panel and cards on another**, on **CORE heading anything but the rune panel's core runes**
(the positive arm: the rune panel draws its CORE section), and on **a *core* the Kit panel prints that is not *core rune***. It reads
nine head words (CORE, WORN, HELD NOT WORN, STARTING KIT, ENABLERS, CARRIED, BENCHED, THE CREST, IN THE BAG) and three panels.

## §4 — THE MEMBER CARRIES THE BAR's TRUE MAXIMUM

### §4a — MEASURED FIRST (§0.5's three questions)

**Every reader of `member["max_mana"]`**, before IG:

| Site | What it did with the fixed 100 |
|---|---|
| `Run.new_run` | wrote it: 100 for every hero |
| `Run.restore_mana` (the Cracked Hourglass) | restored 30% of 100, capped at 100 — never lowering a bar since IF |
| `Run.advance_zone` | refilled the bar to 100 — a 120 bar carried in came out at 100 |
| `map_screen` — a Mana Potion used on the map | restored 40% of 100 and **cut** a bar carried above 100 down to it |
| `events.gd` — `mana_pct` | added a share of 100 and **cut** a bar above 100 down to it |
| `map_screen` — the hero card's bar | drew the bar as a share of 100 (a 110 bar drew past full) |

**The save carries it**: `max_mana` is a key of every member and `save_run` writes the party whole; the designer's own save holds it
four times. An older build reads the key as generously as this one and writes it back, so **no version moves** (ID §0.2's principle,
confirmed rather than assumed). **What else moves with it**: a new zone refills a node-holder to 120, the Hourglass restores 36 of
120, a map potion and an event read 120 — and **every dry fraction measured on the default build** (IE's and IF's tables, all 27
nodes worn) was taken under the old reading; the untalented rows hold no node and are untouched. Not re-run, by the brief.

### §4b — BUILT

`BattleUnit.sync_victory_state` — the one site a won fight writes back onto the member — writes `max_mana = max_resource` beside
`mana`, and the fight's in-flight bank (`_bank_party_losses`, GH) writes it beside the bar it banks. `max_resource` is built at the
spawn from the class, the nodes and the runes and nothing in a fight writes it, so it carries out whole. **What is not changed**: a
hero's FIRST fight of a run still opens at the class's 100 — the member learns the maximum at that fight's end (FOUND AT IG;
computing it before the first spawn is the sixty-line prologue CK §1 owes as one helper). **Driven both ways** (`check_ig` §4): a
Mage holding *A Bigger Resource Pool* carries a full 120 out of a won fight, the Hourglass takes 50 to 86 of 120, a quit's
in-flight bank writes 37 of 120, a new zone refills him to 120 and the save carries it back; a Mage with no node reads 100 through
every one of the same doors — the arm that proves nothing moved for the designer. `check_if` §4's Hourglass arm reads the true
maximum now (110 of 120 → 120; 70 of 120 → 106) and keeps *never a loss* on a bar a door carries past the maximum.

### §4c — WHAT IT DID TO THE DEFAULT BUILD's DRY FRACTIONS

One table, IF's probe re-pointed (not a re-run of IE's and IF's): the default build (27 nodes, *A Bigger Resource Pool* among them),
20 runs a lineage, rung 1, the rate 12, dry per-run mean ± SE — §1's code (the member at a fixed 100) against IG's final code:

| arm | Cleric | Mage | Hunter | opens full (C / M / H) |
|---|---|---|---|---|
| relic held, before §4 | 1.4 ± 0.3 | 2.1 ± 0.6 | 0.6 ± 0.1 | 24.1 / 36.5 / 15.4% |
| **relic held, §4** | **0.7 ± 0.2** | **2.9 ± 0.6** | **0.3 ± 0.1** | **39.2 / 42.5 / 35.6%** |
| no relic, before §4 | 3.5 ± 0.6 | 3.0 ± 0.8 | 3.7 ± 0.6 | 21.2 / 30.2 / 10.1% |
| no relic, §4 | 4.0 ± 0.7 | 3.6 ± 0.9 | 4.6 ± 0.7 | 23.4 / 31.0 / 13.7% |

**Read plainly**: the dry fractions move inside their error in every arm — the twenty points were reachable inside a fight already,
where a bar is spent — and **what moves is how often a hero opens a fight full**: with the Hourglass a node-holder now opens full on
35.6% of the Hunter's turns where he did on 15.4% (the Cleric 24.1% → 39.2%), because the relic restores against 120 and a zone
refills to 120. Without the relic the zone's refill is the only door the sim walks, and it barely shows. **The designer's own
profile holds no node, so none of this reaches him.**

## §5 — HOUSEKEEPING

**THE MOVE WAS NOT ATTEMPTED** (IB §4). **The folders, by IG's own rule — one a concurrent lane**: IG made **five** — *Dawn of Decay
IG A* and *IG B* (the two recons, run at once), *IG p1*, *p2*, *p3* (the probe's three parties, run at once; then the stubs, traces,
controls and the PNG probe, each a later lane reusing a folder no running lane held) — **five folders against five lanes running at once at the peak**: from 22:07 to 22:21 both recons and the dry-fraction probe's
three parties ran together, so five is the floor for this schedule — IF used twenty-six, and IF's estimate for a batch of IE's
shape was about five. The pre-pass reused *IG A* after recon A; the acceptance ran in the repository's own folder, as every
acceptance has. Lanes that ran one after another shared a folder safely (each gate points `Profile` and `Relics` at its own scratch
file and removes it); no two running lanes ever shared one. **Read at IG's start**
(before its first folder): **587 folders**, IF's close. **Read at the close**: **592 folders, 258,260 KiB** in all — IG's own five among them (**6,060 KiB**). The
spent prefixes — every *Dawn of Decay* copy from FX to IF and the five *DoD …* copies — are **585 folders, 251,660 KiB**: IF's
twenty-six (**26,464 KiB**, read today) and the 559 before them (225,196 KiB, IF's reading, unchanged). The live *Dawn of Decay*
folder holds 68 entries, 528 KiB, as at IF's close: no IG scratch file in it and **no readout folder** — nothing played.

**ONE command clears every spent prefix** — every *Dawn of Decay* copy from FX to IF (IF's twenty-six included) and the five *DoD …*
copies — leaving the live *Dawn of Decay* folder, IG's own five and `[unnamed project]`:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IF)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-F]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IF)/"
```

**IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the
paste first. IG's own five are named *Dawn of Decay IG …*, and the glob stops at IF, so it leaves them.

## §6 — WHAT IS DELIBERATELY NOT DONE

- **THE RULINGS THE READOUT ANSWERS ARE NOT TOUCHED** — Boil Over's rate, Rupture's number, the vow's worth, the Cleric's rate.
  Sanctity's step is the one exception, and §2 is why.
- **PYROBLAST IS NOT REPAIRED; SMOULDER's FIGURES ARE NOT MOVED. THE HOURGLASS IS NOT RE-PRICED** (the Hunter's fifteen points are
  on the watch list).
- **IC's REMAINDER IS IH's NOW, MOVED UP THE QUEUE** (the roadmap in `docs/state.md`): it is correctness — a vowed Cleric who drafts
  Blight the Well without the Old Gods engine is not silenced at all.
- **THE RE-MEASURE IS II's.** Its two readings at IG's close: **`CLAUDE.md` 467,620 B = 456.66 KiB, 53.34 KiB under 510** — 6.6 batches at
EZ's record (54,620 ÷ 8,293), 28.2 at IG's own +1,938; **`docs/state.md` 353,523 B = 345.24 KiB, 34.76 KiB under 380** — 6.1
batches at IA's +5,860 (35,597 ÷ 5,860), the worst case; **the honest rate**: ID +952, IE +3,917, IF +236, IG +1,540 — a mean of
1,661 B over the four, **21.4 batches at it. Plan the room against the honest rate**: it is what the archive practice has actually
produced for four batches running, and the worst case assumes every batch writes like IA, which none since has; the worst case
stays the alarm (a batch that writes like IA shows in the next reading, and `check_fg` §4 warns at the ceiling). `docs/state.md`
still binds first at every rate.
- **The claims stand at 86** and are IJ's. **The sim bot's fire is not taught.** No crest rune re-cut or authored; the crest cap
  stays at one; the vow not re-priced, the recoil floor not exempted, Anointing unchanged; the third slot not gated behind a rung.
- **`DEBUFF_IDS`' `melted` is not removed** (inert; FOUND AT IG). **A hero's first fight still opens at the class's 100** (FOUND AT
  IG).
- Standing and unchanged: a copied Frostbind's refusal **RULED, NOT BUILT**; **Mana stays**; a meter is not a conjunction half;
  Marrowfire becomes Sunder + Burn and Contagion and Reckoning owe re-cuts; the Occultist's Break card is CE §3's ask; the Skirmisher
  and the Tracker are ruled into ordinary runes and unbuilt, with Volley and Ambusher owed their core slots and both owed names;
  Channel's tempo payout is owed; whether a fallen hero stays down between fights is owed and prices three crest runes; Tithe's read
  site and its talent rebalance; a bomb's surface text; the block index.

## §7 — THE ONE LINE THAT MATTERS MOST

**Play one zone, then send the file.** It is written to `~/Library/Application Support/Godot/app_userdata/Dawn of Decay/readout/` — one
`run-<date>-<time>.jsonl` a run, the newest the run being played. Nothing needs switching on. Sanctity's step is set now, and his
file is what confirms it.

## §8 — THE VERIFICATION

### §8a — THE PUSH CHECK, THE SAVES, THE SWEEPS AND THE INTEGER PINS, BEFORE THE PREDICTIONS

`git ls-remote origin class-merge` read `fd83ae7…`, local HEAD the same, before anything ran (`661183d`, IF's first push, is its
parent). The four player files were md5-identical to IF's backup and were backed up to `../save-backups/IG-20261013-211441`,
verified by md5; **`run_save.bin` 42,200 B, 2026-10-08 09:23, and no `readout/` in the designer's folder** — nothing played.

**The literal sweep, game code** (IF's `litsweep_if.py`, **extended to single-quoted literals** — its first pass read double quotes
only and missed `test_batch_br`'s single-quoted needle; the extension found it): **on §1 alone** (recon A's two files) **2 lost** —
the Iron Will spawn line, pinned by `check_hp` §1b and `test_batch_br` §1 — 2 gained, neither an absence pin; **on all of IG's code**
(recon B's four) the same 2 lost, every gained needle IG's own gates' or a format string. **Not in the sweep and named by reading**:
HEAD's `check_if` §3a finds the Kit panel's heads by the prefix `CORE —`, which survives in `map_screen.gd` as the rune panel's head,
so the sweep sees nothing lost where the drive on the Kit panel finds no CORE. No `.count(` pin on these files moved (the count
moves the sweep printed are whole-file bracket counts and two `.count()` calls on other strings). **`run_state.gd`'s change is
comments only — proved by a comment-stripped diff: 0 code lines** (`map_screen.gd` 3, `unit.gd` 73, `battle.gd` 142).

**The integer pins, counted against the doors** (IE's third thing): `add_status(` 35 → 16 in the game's scripts (19 removed) —
`check_hu` §2a holds the VARIABLE-id calls to the door's alone and the `statuses.append(` / `.insert(` writes at 2 / 2, all
unmoved; **`check_di` counts `_apply_status(`, 224 raw in `battle.gd` before and after (its 221 call sites unmoved) — the brief's
*`check_hu` §2b and `check_di` will both move* does not hold** (§2b is `check_hu`'s cast census, not a count of `add_status`).
`Runes.shown_desc(` 10 → 10 on `map_screen.gd`, `func _toggle_loadout(` 1, `Run.unequip_earned_ability(` 2 — unmoved. **No pool
depth moves**: the diff touches no card, rune, shelf or pool, so `master.html`'s live draft count (179) and the family of suites that
pin it are untouched — checked by reading the diff, as the brief asked, not assumed.

**The documents' sweep** (`litsweep_docs.py`, raw and whitespace-collapsed, likewise extended to single quotes) over the six edited
documents: **11 lost, all in `docs/state.md`'s rewritten WHERE block and IF's archived rulings** (*CORE —*, *ENABLERS —*,
*user://readout* …), each a needle of `check_if`, `check_ia` or `check_cy` — **none of which opens `docs/state.md`** (the four that
do are `check_es` §4, `check_fg` §4, `check_hp` §5 and `check_hx` §2); **29 gained**, IG's own words; 5 short flips.

### §8b — THE RECON's SHAPE: TWO, BECAUSE THE BRIEF's ORDER FORCES THEM AND §1 REACHES THE DICE

**The blast radius was read first.** §1 takes nineteen `add_status` calls off the status door, and each was a Sanctity event and a
float that spends a `randf_range` — so §1 reaches every seeded die a chip's landing touched, and §2's measurement had to be taken on
§1's code alone. **Recon A: HEAD's whole battery on §1's two files** (the `treeA/` scripts the Sanctity probe also ran). **Recon B:
HEAD's whole battery on all of IG's game code.** Each in an isolated APFS clone, md5-frozen at launch (533 files), HEAD's gates and
documents (an untracked new gate removed from the clone, so the battery is HEAD's), its own user folder (*IG A*, *IG B*) seeded from
the backup, the two run at once. Each prediction was written after its literal sweep and before its launch (`RECON_A_PREDICTION.md`
21:24:09, launched 21:24:28, `RECON_B_PREDICTION.md` 21:48:41, launched 21:48:58).

**RECON A — §1 ALONE**, 21:24:28 to 22:46:31 (82 min), HEAD's 145 targets: **`check_de` 601 / 13 / 0 notices.**

| The prediction (written before the launch, after its literal sweep) | What HEAD's battery read on §1's code |
|---|---|
| **Red**: `check_hp` 1, `test_batch_br` 1, `check_hu` 2 (§4a, §4b), `test_batch_bw` ~4, `test_batch_bp` 1, `test_batch_bd` 2+, `bg` ~4, `bh` ~3, `bi` 1–2, `check_eu` 3+, `check_ev` 2+, `check_hf` 2+ | **All held**: 171 / 1, 1486 / 1, 105 / 2, 513 / 4, 431 / 1, 71 / 4, 41 / 6, 324 / 3, 88 / 1, 38 / 3, 54 / 4, 314 / 4 |
| **May move**: every seeded road and band (a chip's float spent a die); `check_gp` §2's snapshot | **Every count held**: `check_gp` 444, `check_gj` 70 / 1 (its sanctioned §4 line identical to IF's), `check_gv` 1057, `check_hk` 168, `check_fh`, `check_ib`, `check_he`, `check_id`, `test_batch_bk` 131, the harness 22 / 382 / 8, `check_cm_live` 13 / 5 (its five FAIL lines md5-identical to IF's), `test_batch_an` 6051 (its band 6044–6066). **The dice did move inside four roads** — `check_gp`, `check_gv`, `check_hk`, `check_fh` print combat logs that diverge from IF's (§8c) — and no assertion turned on them |
| **Green**, named: `check_parse` 222, `check_di` 221, `check_ie`, `check_if`, `check_ft`, `check_go`, `check_id`, `check_gt`, `test_rune_battle`, `test_batch_ar`, `check_co`, `check_cy` | **All green at IF's rows** |
| — | **MISSED, one**: `check_ed` 18 / 1 — *all code-anchored pins resolve … BROKEN: the Iron Will spawn needle, twice*. **The two LOST needles are pins in `pin-manifest.json`**, and the manifest reds on a pin its file no longer holds until it is rebuilt — which the final tree did (1,779 pins, the two needles and line numbers moved, no unresolved pin). The memory *the pin manifest is the needle instrument* named exactly this; the prediction counted the needles and not the instrument that holds them. |

**RECON B — ALL OF IG's GAME CODE**, 21:48:58 to 23:11:15 (82 min), run beside recon A: **`check_de` 601 / 14 / 0 notices.**

| The prediction | What HEAD's battery read on all of IG's code |
|---|---|
| **Red**: recon A's §1 reds; **§3**: `check_if` §3a, 2 or 3; **§4**: `check_if` §4's second case, 2 | **All held**: recon A's thirteen at the same rows, and **`check_if` 80 / 4** — §3a *the sections are not CORE, ENABLERS …* and *CORE holds []*; §4 *the relic cut a bar above the member's cap (110 -> 120)* and *a bar below the cap is raised to it (70 -> 106)* — the brief's §4 read through HEAD's assertion of the old cap |
| **May move**: §2's step on `check_gn` (it seeds the spines); §4's maximum on every default-build sim (the harness, `test_batch_an` / `bk`, `check_cm_live`) | **Nothing moved beyond §1**: recon B's logs read recon A's on `check_gp`, `check_hk`, `check_fh`, `check_cm_live`, `test_batch_bk`, the harness's three, `check_ib`, `check_he`, `check_id`, `check_ft`, `check_go` (0 lines apart); `check_gv` and `check_gj` differ by a runtime line and the last two lines of a fight still printing at quit; `test_batch_an` 6055 inside its band (6044–6066); `check_gn` 204 (its printed figures vary run to run on HEAD's code too — §8c) |
| **Green**, named: `check_parse` 222, `check_di` 221, `check_gs`, `check_id`, `check_gt`, `check_ia`, `check_hn`, `check_map_screen`, `check_ek`, `check_hx` | **All green at IF's rows** |
| — | **MISSED, the same one**: `check_ed` 18 / 1 (recon A's). |


### §8c — WHAT MOVED, ATTRIBUTED BY TRACE AND STUB

**No count in HEAD's battery moved for a cause outside the named reds** — every seeded road's count, band and the harness held in
both recons. **But the dice moved**, and a held count is not an unmoved road: four seeded gates print a combat log, and on §1's code
it diverges from IF's — `check_gp` from line 6016 (6,394 lines), `check_gv` (6,194), `check_hk` (8,701), `check_fh` (8,719) — with
no assertion turning on what moved. **Attributed by a stub, one cause put back**: three copies of HEAD's gates, each its own folder,
run at once — **HEAD's code** (*trH*), **§1's code** (*trA*, recon A's scripts) and **stS**, §1's code with the chips' status
landings PUT BACK (a display chip laid fresh books its Sanctity event and floats its label; one removed books its event — the status
door's two acts, nothing else). **stS reads HEAD's log on all four within two lines — an exit-time resource count and a timing
line — where §1's reads thousands apart**: the moved dice are the chips' floats and nothing else. HEAD's own `check_gp` log is
IF's acceptance log line for line (0), so the road is deterministic. **`check_gn`** prints damage figures that move between two runs
of HEAD's own code (6 lines), so its prints are not a road; its count holds at 204 everywhere. (`check_hk` reads 165 alone and 168
in the battery on every arm — HEAD's code too; the three are the battery's, not IG's.)

**The rising and falling counts are IG's own gates**: `check_if` 80 → 85 (§3c's four, §4's one), `check_ig` 51 (new),
`check_parse` 222 → 223 (`check_ig` joins the GATES). No suite's count moved — every re-point is one-for-one.

### §8d — EVERY RE-POINTED GATE, ALONE, AND THE DOCUMENT READERS, BEFORE THE RUN

On clones of the tree, stderr grepped for `Parse Error` and `SCRIPT ERROR` (none): `check_ig` **51** / 0 (new), `check_if` **85** / 0,
`check_hu` 105 / 0, `check_ie` 70 / 0, `check_hp` 171 / 0, `test_batch_br` 1486 / 0 (the control baseline, C00); `check_eu` 38 / 0,
`check_ev` 54 / 0, `check_hf` 314 / 0, `test_batch_bd` 71, `be` 27, `bf` 74, `bg` 41, `bh` 324, `bi` 88, `bp` 431, `bw` 513 — each 0
failures, **every count IF's**: each re-point reads the chip where it is drawn, one-for-one. **The gates that read other gates' source
or the documents**, on the repository: `check_ek` 47, `check_da` 41, `check_dw` 35, `check_ea` 396, `check_ff` 68, `check_gw` 76,
`check_parse` **223**, `check_hx` 39, `check_ed` 18, `check_ec` 24 — each 0 failures. **The pin manifest rebuilt**: 1,779 pins, the
two Iron Will needles re-pointed with their gates, no unresolved pin. **The document readers** — IF's list and every gate that opens `docs/state.md`, the manifest, `master.html`'s prose or
`design-notes.md`, 58 in all — on a clone proved equal to the tree (533 files, the project name aside), after the last document
edit: **57 green; `check_de` reds alone by design** (it is the battery's post-pass and reads the battery's own logs).

### §8e — TWENTY CONTROLS AND HEAD's CODE, EACH IN ITS OWN CLONE

One APFS clone of the tree per control, every patch count-asserted (all landed), two lanes sharing the probe lanes' folders (*IG p1*,
*IG p2* — no other lane ran in them while they did), every FAIL line kept; clones are never deleted. **Every planted defect reds at the
arm it aims at; the baseline is green; HEAD's game code under IG's gates (H01) reds `check_ig` (26 / 13, 10 throws on the doors HEAD
does not have), `check_if` (§3a and §4), `check_hp` and `test_batch_br`**, and reads the four re-pointed suites short with throws where
they call `display_chip` — IE's H01 shape.

**And one control found a hole, repaired and proved two-armed**: C15 — the victory no longer writing the member's maximum — read
`check_ig` 51 / 0, because the fight's in-flight bank (GH) writes the same key at every turn boundary, so the figure §4 read was the
bank's and never the victory's (a second mechanism masking the one asserted). `_won_with` now puts the member back at the old 100
with no frame between, so what it reads is the victory's own write; C15 reads 51 / 2 on the repaired gate in a fresh base, and the
baseline 51 / 0. **C04** (the row drawing no display chip) reads `check_ie` 70 / 0 as well as `check_ig` red: `check_ie` §2a's count
adds the display chips now, and its board seats no hero carrying one, so `check_ig` §1c is the arm that sees it.

| # | The defect planted | What read it |
|---|---|---|
| C00 | baseline: the final tree, no patch | `check_ig` 51 / 0<br>`check_if` 85 / 0<br>`check_hu` 105 / 0<br>`check_ie` 70 / 0<br>`check_hp` 171 / 0<br>`test_batch_br` 1486 / 0 |
| C01 | Faith's chip laid through the status door again | `check_ig` 51 / 10 — *§1a: the literal-id add_status calls lay ["anointed", "bear_brunt", "bloodbond", "broken", "charging", "crossfire", "elusive", "faith", "fortified", "…*<br>`test_batch_bg` 41 / 6 — *§2/BI: ...and the chip STAYS, because the peak keeps paying* |
| C02 | set_display_chip books a Sanctity event | `check_ig` 51 / 8 — *§1b: `set_display_chip` books a Sanctity event or floats a label* |
| C03 | set_display_chip floats its label | `check_ig` 51 / 3 — *§1b: `set_display_chip` books a Sanctity event or floats a label* |
| C04 | the row draws engine chips and statuses only | `check_ig` 51 / 1 — *§1c: the Berserker's row draws 2 for 1 engine chips, 2 display chips, 1 statuses*<br>`check_ie` 70 / 0 |
| C05 | a body that dies keeps its display chips | `check_ig` 51 / 1 — *§1c: a dead hero still carries display chips (2)* |
| C06 | Loyalty's chip drawn on the hunter, not the companion | `check_ig` 51 / 1 — *§1c: Loyalty is not a display chip on the companion's own body (comp {  }, hunter true)*<br>`check_eu` 38 / 3 — *§4: the chip names the point BELOW it — the player learns the phase before reaching it* |
| C07 | a Faith release takes the chip off (the old churn) | `check_ig` 51 / 1 — *§1d: 0 of three allies released and kept a Fa0 chip on their own body, the peak at 8* |
| C08 | a new literal add_status nobody sorted (a chip-like Iron Will twin) | `check_ig` 51 / 2 — *§1a: the literal-id add_status calls lay ["anointed", "bear_brunt", "bloodbond", "broken", "charging", "crossfire", "elusive", "fortified", "ghostpack…* |
| C09 | a display chip counted as a debuff | `check_ig` 51 / 2 — *§1e: a chip counted as a debuff (1) or in the breadth count (0)* |
| C10 | Enraged's chip stops following its timer | `check_ig` 51 / 1 — *§1e: the chip does not follow the timer ({ "id": "enraged", "label": "Enraged", "short": "+12%", "color": (0.9, 0.35, 0.3, 1.0), "turns": 5, "desc": "…* |
| C11 | Sanctity's step back at 16 | `check_ig` 51 / 1 — *§2: Sanctity's step reads 16 events and its cap 5 steps — want 13 and 5 (a re-tune moves this pin with it)*<br>`check_ft` 147 / 0 |
| C12 | the Kit panel's first head reads CORE again | `check_if` 85 / 5 — *§3a: the panel's sections are not STARTING KIT, ENABLERS, CARRIED and BENCHED in that order, each separated: ["CORE — never benched", "row:Magic Bolt/…* |
| C13 | the Kit panel's note calls the kit the protected core again | `check_if` 85 / 1 — *§3c: the Kit panel prints *core* for something that is not a core rune: ["Benching costs nothing and a benched card is KEPT for the rest of the "]* |
| C14 | the rune panel's WORN head reads CARRIED (a card word heading runes) | `check_if` 85 / 1 — *§3c: one head word names a rune on one panel and a card on another: ["CARRIED: [\"rune:_open_rune_panel\", \"card:_open_loadout_panel\"]"]* |
| C15 | a won fight writes no maximum onto the member | `check_ig` **51 / 0 on the gate before its repair** (lane 2 — the hole: the fight's in-flight bank writes the maximum at every turn boundary, so the victory's own write was never the one read); **51 / 2 after** — *§4 (with the node): a full 120 bar carried out of a won fight reads 120 of 100 on the member*<br>`check_if` 85 / 2 — *§4: a +20 bar at 110 did not rise to its own 120 (110 -> 110)* |
| C16 | the member's maximum is written twenty high for everyone | `check_ig` 51 / 4 — *§4 (with the node): a full 120 bar carried out of a won fight reads 120 of 140 on the member* |
| C17 | the in-flight bank writes no maximum | `check_ig` 51 / 3 — *§4 (with the node): the in-flight bank wrote 37 of 100 — want 37 of 120* |
| C18 | Faith's chip wears Feint's letters (Fg) — the tag walk reads the display-chip writers | `check_hu` 105 / 1 — *§4a: two statuses wear one tag: ["fg: [\"faith=Fg\", \"feint_guard=Fg\"]"]* |
| C19 | Iron Will's chip not laid at the spawn | `check_ig` 51 / 4 — *§1b: a display chip is not laid by `set_display_chip`: ["iron_will"]*<br>`check_hp` 171 / 1 — *§1b: the Iron Will chip is no longer laid at the spawn, or the field is live*<br>`test_batch_br` 1486 / 1 — *§1: the NODE's chip keeps the label and keeps the id `iron_will`*<br>`check_hu` 105 / 1 — *§4b: the Iron Will chip on a Broken Warden reads '', want '-0%'* |
| C20 | the Berserk bank's chip not drawn (the stamp lays nothing) | `check_ig` 51 / 3 — *§1b: a display chip is not laid by `set_display_chip`: ["berserk"]*<br>`test_batch_bw` 513 / 4 — *and the bank wears a chip, so the player can see what is owed* |
| H01 | HEAD's game code under IG's gates | `check_ig` 26 / 13 (10 throws) — *§1a: the literal-id add_status calls lay ["anointed", "aper_rhythm", "bear_brunt", "berserk", "bloodbond", "bracing", "broken", "capacitor", "charging…*<br>`check_if` 85 / 7 — *§3a: the panel's sections are not STARTING KIT, ENABLERS, CARRIED and BENCHED in that order, each separated: ["CORE — never benched", "row:Magic Bolt/…*<br>`check_hu` 100 / 0 (1 throws)<br>`check_ie` 61 / 0 (1 throws)<br>`check_hp` 171 / 1 — *§1b: the Iron Will chip is no longer laid at the spawn, or the field is live*<br>`test_batch_br` 1486 / 1 — *§1: the NODE's chip keeps the label and keeps the id `iron_will`*<br>`test_batch_bw` 504 / 0 (1 throws)<br>`check_eu` 33 / 0 (1 throws) |



### §8f — THE MEASUREMENTS

- **Sanctity** (§2): IE's probe in scratch copies of HEAD's code and of §1's alone — the default build and untalented, 20 runs a
  party at HEAD, 20 (default) and 60 (untalented) at §1 — each arm's three parties at once in the three probe folders.
- **The dry fractions** (§4c): IF's probe, §1's code against IG's final code, the default build, the relic held and not, 20 runs a
  lineage.
- **The panels rendered to PNG** (§3): a windowed probe in a renamed clone (a window flashed on the designer's screen for a few
  seconds) — the Kit panel with STARTING KIT, the same panel with the bare KIT, and the rune panel's CORE beside them.

**THE REFERENCE CLAIMS RE-READ (HY §6)** — every present-tense claim in the four references naming what IG touched:
`CLAUDE.md`'s chip bullet (*every other display chip still laid through the status door is IE's kept census … owed*) — **false
after §1, rewritten**: every display chip is drawn, every `add_status` is the door's or a named effect (`check_ig` §1a); the FT
spine block's *Sanctity's rate is set against half a payout* — **true, and amended** with IG §2's re-set on the honest count; the
HK block's *the map's Kit panel (CORE, ENABLERS, CARRIED, BENCHED)* — **false after §3, repaired**; the glyph rule's *the rule is
finished* — **true, and extended** with the one-word rule §3 asserts; the governor table's `sanctity_events` row names the constants
and not their values — **true, unchanged**; `docs/instrument-rules.md`'s ID-premise case (a display chip laid as a status) — a dated
record, **true as history**; `docs/combat-rules.md` and `docs/ways-of-working.md` name none of the four. **No reference names
`max_mana`.** The live counts IG wrote into `CLAUDE.md` — *the nineteen*, *nine a run reaches and ten dormant*, *fifteen named
EFFECTS* — each carries its batch (IG §1) or its instrument (`check_ig` §1a).

### §8g — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass**: an APFS clone proved equal to the tree (533 files, the project name aside), its own user folder
(*IG A*, recon A's, idle by then) seeded from the backup, 147 targets, 23:31:17 to 00:52:51 — **`check_de` 605 / 0 / 0**, its copy
byte-identical after. **The acceptance in the repository**: 147 targets, 23:31:17 to 00:52:53 — **81 min 36 s** — **`check_de`
605 / 0 / 0, as predicted** (`ACCEPT_PREDICTION.md`, written at 23:13, before either launch): `check_ig` 51 / 0, `check_if` 85 / 0,
`check_parse` 223 / 0, every re-pointed gate at IF's count with 0 failures (`check_hu` 105, `check_ie` 70, `check_hp` 171,
`check_eu` 38, `check_ev` 54, `check_hf` 314, `test_batch_br` 1486, `bw` 513, `bd` 71, `be` 27, `bf` 74, `bg` 41, `bh` 324,
`bi` 88, `bp` 431), `check_ed` 18 / 0 and `check_ec` 24 / 0 on the rebuilt manifest, `check_gp` 444, `check_gj` 70 / 1 (its
sanctioned §4 at *+168 / 188*), `check_gv` 1057, `check_hk` 168, `check_fh` 168, `check_gn` 204, `test_batch_bk` 131 (pre-pass 129,
its band 129–131), `test_batch_an` 6049 (pre-pass 6048, its band 6044–6066), `check_cm_live` 13 / 5 inside its band (its five FAIL
lines md5-identical to IF's), the harness 22 / 382 / 8. **Against IF's acceptance only four rows moved — `check_de`, `check_if`,
`check_ig`, `check_parse` — each IG's own.** **`ps` read by rows every 15 s**: 326 readings and 622 Godot rows across the two
batteries, **every one `--headless`** and no game window — 303 readings saw two, 16 saw one, 7 saw none (between targets). **The
tree was byte-identical before and after** (534 files, tracked and untracked), and **the player's four files were untouched**.

### §8h — THE CLOSE

**The post-run lines** — `docs/state.md`'s verification line and its two readings — were written after the run, at a
fixed point (the file states its own size: 353,523 B). **Their needle proof**: every gate literal, double- and single-quoted,
against the copy the battery read and the final file — **no presence flip among 21,758**. **The four gates that open
`docs/state.md` and the two manifest instruments, re-run on the final tree in an isolated copy** (*IG p1*): `check_es` 57 / 0,
`check_fg` 30 / 0, `check_hp` 171 / 0, `check_hx` 39 / 0, `check_ec` 24 / 0, `check_ed` 18 / 0 — each at its acceptance reading.
**The player's four files, re-read at the close**: byte-identical to `../save-backups/IG-20261013-211441` by md5, `run_save.bin`
42,200 B last written 2026-10-08 09:23, no `readout/` — **nothing has been played for eleven batches**. **This report was written
last**, out of the scratchpad, with no template token left. The push and its `ls-remote` check follow the commit that carries it.

