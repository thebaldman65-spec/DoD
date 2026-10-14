# BATCH IF — THE READOUT, A CARD, AND TWO PANELS

**On `class-merge`, from `7c4f256` (IE). IMPLEMENT ONLY.** **§1: the game writes a playtest readout** — one JSON line a fight to
`user://readout/run-<date>-<time>.jsonl`, beside the save and never inside it — on in the designer's own game and off in every other
process; the same seeded zone played with it on and off reads byte for byte the same (the save after every step, 1,116 game lines,
every die). **§2: Smoulder**, the designer's card, joins the Mage's pool; the longest case — every Burn reader and Smoulder, no other
light — has Burn standing on 66% of a Cryomancer's turns. **§3: the Kit panel and the rune bag are sectioned**, IA's shape, and ✦ is
left on the four rune lines alone — no panel in the game states a row's state twice. **§0.1b: the Cracked Hourglass reaches the
Hunter** — the skip was a guard written while he ran on Focus — and never lowers a bar; the dry fractions re-read both ways. **The
verification**: two recons of HEAD's battery — the readout alone (`check_de` 597 / 0 / 1 notice: it moves no figure) and all of IF's game code (597 / 13 / 7: every red named, or one cause) — each predicted after its literal sweep; `check_gp`'s road (469 → 444) and `check_gj`'s sanctioned figures (*+168 / 188*) attributed to Smoulder by trace and stub, every rising count by stub; twenty-six controls and HEAD's code, each in its own clone, every one biting (one found a hole in `check_if`'s panel reader, repaired and proved two-armed); the 63 document readers on the final documents; the pre-pass and the acceptance, 146 targets, each closing `check_de` 601 / 0 / 0 as predicted.

**VERDICT: GREEN.** §1, §2, §3 and §0.1b are built, none dropped. **The pass condition holds**: the same seeded zone played with the readout on and off reads byte for byte the same — the save after every step, the combat log, the dice — and `check_if` keeps a fight's version of that comparison every battery. Every row moved is moved with its cause (`check_gp` and `check_gj`'s figures by Smoulder's dice, five suites by Smoulder's loops, `check_parse` by two files); twenty-six controls and HEAD's code bite; the pre-pass and the acceptance both closed `check_de` 601 / 0 / 0 as predicted, the tree byte-identical and the player's files untouched. Five rulings are owed (below), and the first is the designer's play.****

**THE ONE LINE THAT MATTERS MOST: play one zone, then send the file.** It is
`~/Library/Application Support/Godot/app_userdata/Dawn of Decay/readout/run-<date>-<time>.jsonl` — the newest one is the run being
played. Nothing needs switching on. Five rulings come off it.

## NEEDS A RULING

1. **PLAY ONE ZONE AND SEND THE FILE (§1).** It answers Boil Over's rate, Rupture's number, the vow's worth, Sanctity's threshold and the
   Cleric's Mana — the last ruled after the readout and the Hourglass, as the brief set it (§0.1b). Nothing needs switching on.
2. **THE CLERIC's MANA, WITH THE HOURGLASS REACHING EVERY MANA HERO (§0.1b).** Held, default build: **Cleric 1.6%, Mage 3.4%, Hunter
   0.9%** dry (IE's, the Hunter skipped: 0.7 / 1.7 / 4.1); untalented: **11.5%, 16.4%, 20.9%** (IE's: 13.1 / 14.5 / 36.0). The relic now
   makes the Hunter the least dry hero on the default build; untalented — the designer's own build — the Cleric is. The rate stays 12.
3. **SMOULDER's FIGURES THE BRIEF LEFT TO ME (§2).** Damage **10% of Attack** (Fireball 20%), set as asked; and two it did not name —
   **Break 8** (Stoke's) and the **Perfect, 12% of Attack** (the generic ×1.25, as every damage card's). **Its 10 Mana ties Blink** (also
   10): below every fire card (the census the brief cited), not below every costed card in the Mage's pool — and **nothing can go under
   10**: `check_ft` §5h holds every Mage price at or above Channel's floor (`CHANNEL_CAST_FLOOR`, 10).
4. **THE PANELS' HEADS (§3)** — **CORE — never benched**, **ENABLERS — brought by a core rune**, **CARRIED — n**, **BENCHED — n, kept for the
   run**; THE CREST and IN THE BAG keep their words. The Kit panel's empty line said *the draft comes from elites and the Peddler*; the
   Peddler is no draft source (FD §1), so it reads *a card is drafted after an elite or at an event* now — confirm the words.
5. **THE HOURGLASS's CAP (FOUND AT IF)** — it restores 30% of the member's `max_mana`, a fixed 100, and stops at 100: a hero carried to a
   120 bar by a node recovers 30 and is capped at 100 (and a new zone refills him to 100). IF made recovering never a loss; whether the
   member should carry the hero's true maximum is a magnitude, so it is yours. The designer's own profile buys no node, so his bars are
   100 and the cap never reaches him.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §6: IE's push hash is `git ls-remote origin class-merge` | **Held**: `7c4f256…` on the remote and at local HEAD, read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | §6: IE's backup `../save-backups/IE-20261013-104148`; `run_save.bin` last written 2026-10-08 09:23 | **Held**: the four player files md5-identical to it; backed up to `../save-backups/IF-20261013-152812`; `run_save.bin` 42,200 B, 2026-10-08 09:23 |
| 3 | §0.1: with the Hourglass the shape holds at 12 — Cleric 0.7%, Mage 1.7%, Hunter 4.1%, his bar 93 of 120 | **Held** (IE §1c) |
| 4 | §0.1: the relic's card says *every hero* and it refills the Mage and the Cleric only | **Held**: `Run.restore_mana` tested `key == "mage" or key == "cleric"` |
| 5 | §0.1b: the Hunter holds Mana (his bar 75.2 of 120) and no resource rule excludes him | **Held**: his class config is `resource_name: "Mana"`; **the skip is accidental** — the guard was written in `69961d5` (the Hunter class, on Focus), and `6fe2071` (*Batch 28 … Hunters on Mana*) never moved it |
| 6 | §0.2: 16 reached 2.61 steps on the inflated count and 2.19 on the honest one | **Held** (IE §2b) |
| 7 | §0.2/§0.5: nine chips a run reaches, ten dormant, fifteen effects | **Held** (IE §2a's census) |
| 8 | §0.4: the loadout panel marks a carried CARD with ✦; the crest panel's THE CREST mixes the worn rune with the bagged | **Held**, and one more: a bagged crest rune was listed twice — under THE CREST (*(in the bag)*) and again under IN THE BAG |
| 9 | §1: the bot never casts a drafted Fireball; Stoke or Cinderfall once in sixty runs | **Held** (IE §3a) |
| 10 | §1a: the sim read 22% *opens full* for the Cleric on the default build | **Held** (IE §1b, 22.0%); IF's no-relic re-read: 19.9% |
| 11 | §1a: Rupture at a guessed 10 Break a tick | **Held**: `RUPTURE_BREAK_PER_TICK` 10 |
| 12 | §2: a Cryomancer lays Chilled on 32% of his turns and Burn on 20% | **Held** (IE §3a: 32%, 20.1%) |
| 13 | §2: 10 Mana is below every costed card in the census | **Half**: below every fire card a Mage holds (Fireball and Frostbolt 15 the next); **Blink costs 10** too; nothing can go under 10 (ruling 3) |
| 14 | §2: report Fireball's own figure | **Fireball**: 20% of Attack, 15 Mana, cooldown 2, 15 Break, Burn 3 turns on a landing hit |
| 15 | §2: in the Mage's class draft pool, no `ENGINE_READ` row | **Built**, in the Mage's one pool (`Classes.draft_pool("mage")`) **on the Pyromancer's shelf**: the class-wide shelf's own authoring rule keeps a lineage's element off it (a fire card is the Pyromancer's), and since GP the shelf decides nothing about who draws it. No `ENGINE_READ` row; offered to a Mage holding no engine |
| 16 | §2: it lays through the status door, as Stoke and Cinderfall do | **Held, by the generic door**: `applies_status` — Fireball's path — calls `_apply_status` on a landing hit, so Emberkeep doubles it and Downwind carries it (driven, `check_if` §2) |
| 17 | §6: *`check_di` counts call sites as a number, and §2's card will add one through the status door* | **Not held**: the generic `applies_status` site already exists; the count stays **221** (§8a's integer-pin census) |
| 18 | §2: IE's repairs reached 48.7% and fell 1.3 short; IE read a Rupture at 4.5% of a Cryomancer's turns | **Held** (IE §3b, §3a) |
| 19 | §6: `data/abilities.json` for Smoulder | **Not held**: there is no such file; abilities are defined in `scripts/classes.gd` (`draft_ability`), and Smoulder is there |
| 20 | §3: the bag's `✦ N` is a rune count and keeps its tooltip | **Held**, untouched |
| 21 | §0.6: §3 moves two panels; both move draws where they are drawn | **Half**: Smoulder does (a longer Mage pool reshuffles every Mage roll, and the bot can cast it); **the panels spend no die** — building labels and buttons draws nothing (recon B, §8b) |
| 22 | §4: IE's own folders are thirty-five and 52,004 KiB; `app_userdata` reads 561 folders and 227,108 KiB | **Half**: thirty-five, **50,592 KiB** read today (IE's figure was taken at its close); 561 folders before IF's own (§4) |
| 23 | §5: IE closed at `CLAUDE.md` 451.76 KiB and `docs/state.md` 343.50 KiB | **Held**: 462,598 B and 351,747 B at `7c4f256` |
| 24 | §5: ID spent +952 B on `docs/state.md` and IE +3,917 | **Held**: 346,878 → 347,830 → 351,747 B at `db68ab7`, `027de47`, `7c4f256` |
| 25 | §5: the claims stand at 86 | **Held** |
| 26 | §6: IE read 145 in 79 min 18 s | **Held** (IE §8g) |
| 27 | §6: nothing has been played for nine batches | **Held, and IF makes ten**: the player's files last written 2026-10-08 09:23, at the start and at the close |

## §0 — IE's FIVE RULINGS, ANSWERED

- **§0.1 — THE RATE STAYS AT 12; IE's PASS CONDITION IS WITHDRAWN.** The cause the designer saw is the Hourglass, and the Hourglass was a
  defect: measured and repaired toward its card (§0.1b). The rate is ruled after the readout.
- **§0.2 — FV §3's INTENT STANDS; THE NUMBER IS IG's**, after the chips convert. Nothing authored.
- **§0.3 — PYROBLAST STAYS; SMOULDER IS AUTHORED** (§2), to IE's spec.
- **§0.4 — BOTH PANELS SECTIONED** (§3); the rule is finished and asserted.
- **§0.5 — EVERY DISPLAY CHIP CONVERTS — IG's.** Nothing here.
- **§0.6 — THE ORDER**: §1 first, then §2, then §3, then §0.1b — all built; none dropped.

## §1 — THE READOUT

### §1a — WHAT IT WRITES

**JSON Lines — one JSON object a line — and why.** A fight is appended as one line and nothing already written is ever re-read or
rewritten, so a quit, a crash or a forfeit keeps every finished fight whole, and any editor opens it. One JSON document would be read,
parsed and written whole at every fight's end — the read-modify-write that truncates when it fails half way.

**Where**: `user://readout/run-<date>-<time>.jsonl` — for the designer, `~/Library/Application Support/Godot/app_userdata/Dawn of
Decay/readout/`. **A run's file**: a new run opens a new file (`Run.readout`'s `fresh`, set by `new_run`); a resumed run appends to the
file `readout/latest.txt` names, with a `resume` line; a run that predates the readout — the designer's saved run from 2026-10-08 —
opens its own file, marked `resumed`. `Run.readout` is in memory only and `save_run` names no key of it.

**THE RUN HEADER, ONCE** (`kind: run`): the readout's version, when it was written, whether the run was resumed, the rung and difficulty,
every relic held (id and name), the crest's worn rune, and each hero's class, lineage, worn core runes, worn ordinary runes and the nodes
he wears — plus a legend naming each figure. **A FIGHT LINE** (`kind: fight`): its number, outcome (victory, defeat, stalemate, or
*forfeit: <reason>* — a forfeit never reaches `_check_end`, so its own door writes it), turns (every unit's), hero turns and rounds,
who fell; the frame — zone and zone number, slot and node, **`encounter`** (fight, elite, mini-boss, boss), theme, the enemies, the
bargain in effect; the loadout as it stands (lineage, core and ordinary runes); and:

- **EVERY HERO's RESOURCE**: the resource and its maximum; **turns**; **opened_full** — turns he opened at a full bar, read before the
  turn's drip, IE's *opens full*; **costed_turns** — turns his bar held a costed card at all; **hard_dry** — every costed card cost more
  than he held, read after the drip at the moment he chooses (`battle._eff_cost`, the price the button reads); **soft_dry** — at least
  one did (a hard-dry turn counts as soft); **low_water** — his lowest bar as a fraction of its maximum (read at the turn's opening, its
  choice and its close); his damage dealt, his **best_ordinary_turn** (most damage in one turn without a Boil Over); his bar's cards;
  fell and standing.
- **EVERY CONJUNCTION THAT FORMED**: its name, its degree, its two ingredients, the body and who made it, the turn it formed, the
  afflicted body's turns it stood, its ticks, the Break they ground out, whether it Broke the body, whether it stood at the end.
- **EVERY BOIL OVER**: the Rage poured, the damage the cast dealt (credited under its own frame), the whole turn's damage, whether the
  Berserker's core was on, and his best ordinary turn of that fight — the comparison its rate was set against.
- **THE VOW, IF WORN**: the healing its term added (of each heal through `_healing_done_mult`, the vow's share — its term over the whole
  multiplier) and the damage it refused (every blow and every door-call it silenced, and how many).
- **SANCTITY, IF A HIEROPHANT STANDS**: the ledger's events and his steps at the fight's end.

**Size**: the A/B road's zone one — eight fights, the zone boss among them — wrote **19,003 bytes** (a header of about 1.3 KB, about
2.2 KB a fight; a wider fight with a Rupture or a Boil Over is larger). A run is three zones and the end boss, so a whole run writes
about 60 KB. **The bound**: a run's file stops growing at **2 MiB** — the line that would cross it is replaced by one `full` line, once
(probed: 60 appends of a 50 KB line wrote 41 lines and one `full`, 2,051,165 bytes).

### §1b — WHAT IT IS NOT

Not a screen — no panel, no toast; the deliverable is the file. **It does not touch the save**: not a key, not a version, not a byte
(asserted, `check_if` §1e, and read byte for byte in §1d). Not a gate's instrument: off in every gate.

### §1c — ON OR OFF

**On by default in the designer's own game, harmless, and off in every other process.** The decision is `Readout.wanted(env, active,
player)` — FI's split, assertable both ways: the player's process is the one whose save path is the player's (`Run._init`'s redirect),
so every `--script` gate, every scene target, every sim and every probe reads *off*. **`DOD_READOUT=0` turns it off** in his game;
`DOD_READOUT=1` turns it on in a harness, which writes `user://readout_harness/`, never his folder (`check_if` removes its own).

### §1d — IT MOVES NOTHING — THE PASS CONDITION, DRIVEN

**How it is built so it cannot**: `battle.gd` holds one `_readout` (null unless wanted), and each of its sixteen hooks is one call under
`if _readout != null` — the unit's turn chosen, his turn's opening (before the drip), his choice, its close, `_stat`'s damage credit,
`_stat_heal`, Boil Over's pour, the vow's two refusals, a conjunction forming and ticking, a hero falling, `_check_end` and the forfeit.
The readout is a `RefCounted` that names no autoload and writes no field of a unit or the run; `check_if` §1e sweeps its source for any
die, status, float, log line or assignment, and holds every hook behind its null test.

**The batch's run**: a scratch driver (`probes/ab_road.gd`, never a gate) plays one seeded run through the real map, fights, drafts,
rewards and saves — a Berserker carrying Boil Over, a Pyromancer carrying Frostbolt and Smoulder, a vowed Hierophant Holy, a Survivalist,
enemies attacking — until zone one is cleared, printing the harness save's md5 after every one of its 49 steps, and at each fight's end
the next die and the battle log's md5; the combat log itself is echoed line for line. Two clones, the readout on and unset, **at a fixed
frame step** (`--fixed-fps 60`): **every line identical — 49 save hashes, 8 dice, 1,050 log lines, the party and the tally — 1,116 game
lines**; the readout's own two lines (its path and its size) are the only difference. Run again in fresh processes: identical to the first.

**What was found on the way, and why the step is fixed.** The first pair ran unfixed and differed at two of 49 save reads: each was
taken in the first frames of a fight while the fight's in-flight save (GH) was being written, and the log's order shows the read racing
the bot's first action — in one arm before Canis's summon, in the other after it. The steps before and after agreed. Fixed, they agree.
The exit-time *ObjectDB leaked* count also differed (16 and 4); run with `--verbose`, both arms leak the same four objects — the music
and the click still playing at quit — so the readout leaks nothing.

**And the gate keeps it**: `check_if` §1b fights one seeded fight three times — off, on, off — and compares the log, every unit, the run,
the save and the next die; the two off arms are the control that the harness repeats itself.

**What the zone's file held** (on, the same run): every hero's resource on every fight; **three Ruptures** in fight 4 (three ticks and
24 Break on the Orc Chief, two and 28 on each Whelp — one Broke); **four Boil Overs** (40 to 100 Rage, 42 to 92 damage, each beside his
best ordinary turn); the vow on every fight (2 to 5 blows refused, up to 130 damage, up to 109 healing added); Sanctity's events and
steps. **Two things the file taught**: the node's kind was dropped by the line's own `kind` key in the merge (renamed `encounter`, and
`check_if` §1c asserts it), and a heal reaches `heal_hero_` in the sim alone, so the vow's healing would have read 0 in the designer's
game — the hook sits on `_stat_heal`, the door every heal passes in both.

## §2 — SMOULDER

**As authored** (`Classes.draft_ability`, beside Stoke): **10 Mana · cooldown 2 · initiative 2.0 · one enemy · 10% of Attack in fire ·
Break 8 · Burn 4 turns on a landing hit (`applies_status`) · Perfect: 12% of Attack.** *A low fire that keeps: deals fire damage and
leaves the target Burning for 4 turns. It consumes nothing already alight; reapplying extends the Burn.* (five lines, the longest 36
characters.) Tags DEBUFF, BREAK (Fireball's). AXIS and SYNERGY lines above the definition; `master.html`'s Pyromancer table carries its
row and *Builds with* (a Cryomancer's chill — Rupture; Stoke; Detonation, Backdraft, Wildfire; Emberkeep; Downwind).

**The figures against Fireball's** (20% of Attack, 15 Mana, cooldown 2, 15 Break, Burn 3): half the damage, two thirds the price, the
same cooldown, a Burn one turn longer — so a recast every second turn never lets it lapse — and it buys the Burn, not the hit.
**Where**: the Pyromancer's shelf, the Mage's one pool (51 → 52; 39 of 52 with no engine), no `ENGINE_READ` row. The draft is **179**
(159 spec + 20 class-wide). A recast on a burning enemy adds its four turns (Burn's own rule) and consumes nothing.

**THE PASS CONDITION — IE §3b's shape, finished.** IE's instrument, re-pointed: a probed scratch copy, standalone fights (80 an arm), a
Cryomancer with no Overburn holding a fixed draft, IE's two policies (*1*: his bar's fire cards in order; *2*: while nothing burns, the
first card the arm's own list says lays Burn, then policy 1), Smoulder first in his draft as Fireball was in IE's:

| Draft | IE's HEAD | IE | **IF** |
|---|---|---|---|
| **Every reader and Smoulder, no other applier — the longest case** (policy 2) | — | — | **66.0%** |
| The same, policy 1 | — | — | **66.1%** |
| Every reader, no applier (policy 2) — IE's longest case, re-read on IF's tree | 1.9% | 48.7% | 50.7% |
| The same, policy 1 | 2.0% | 45.9% | 43.7% |

**Burn stands on most of the longest case's turns, by sixteen points with either policy.** (The re-read of IE's own arm on IF's tree —
50.7% and 43.7% against IE's 48.7% and 45.9% — is the arm's run-to-run spread; the fights are unseeded.) **Rupture on a Cryomancer's
turns**: the fixed drafts cannot answer it — a bar full of fire cards is cast first every turn and his chill is never reached (Chilled
0%) — so a separate arm: **a Cryomancer holding his kit and Smoulder, casting it whenever it is ready, his rotation otherwise: a Rupture
stands at the start of 15.3% of his turns** (Burn 61.8%, a lone Chilled 15.6%); the same Cryomancer without it, 0% (his kit lays no
Burn). **The sim's bot** — which reaches a drafted card only when Magic Burst and Magic Missiles are both unavailable — reads **3.2%** on
IF's tree over sixty default-build runs (IE read 4.5%): the bot is still the wrong instrument, and the readout is the right one.

**Through the status door, driven** (`check_if` §2): a cold enemy lit for its 4 turns; a burning one 3 → 7, nothing consumed; Emberkeep
doubles it to 8; Downwind carries it to a second enemy; a chilled enemy lit becomes a Rupture. **Re-pointed to the question each asked**:
`check_ie` §3b's fire census names Smoulder (*lays*); `check_gu` §2 sorts it *its point* — below both damage kit cards on price, and that
is the card (+4: its asking, its row, its why, its ground); `test_batch_cd`'s depth table (the Pyromancer 17, the spec half 159, the
draft 179).

## §3 — THE TWO PANELS

**THE KIT PANEL** (the map card's *Kit*, `map_screen._open_loadout_panel`): four sections, each separated, IA §3's shape. **Its states**:
a protected kit card (cannot be benched) → **CORE — never benched**; an enabler its core rune brings, outside the slot count →
**ENABLERS — brought by a core rune**; an earned card carried, Bench → **CARRIED — n**; carried and sitting out (its sentence in place of
its text, amber) → **CARRIED**; an earned card benched, Carry (disabled with its reason at the cap) → **BENCHED — n, kept for the run**;
nothing earned → CARRIED's line *Nothing earned yet. A card is drafted after an elite or at an event, and a zone boss pays a pick of
three.*, and BENCHED's *Nothing benched.* A kit row's state column (CORE / ENABLER) and a carried row's ✦ are gone — the head says each.
The tag census, the title and the note stand where they stood; rows are still `HBox(Button, Label)`, which every walker presses.

**THE RUNE BAG** (`_open_bag_panel`): **THE CREST — n of 1 filled** holds the one worn crest rune with Unequip, its slot drawn *— empty —*
when it is empty (IA's core slot), and *No crest rune held …* when no crest rune is anywhere; **IN THE BAG** holds every rune the bag
holds, once — a crest rune with Equip (Swap while the crest is filled) beside its Drop, a stray with Drop. The worn rune's ✦ and a
bagged rune's *(in the bag)* are gone, and **a bagged crest rune is no longer listed twice**. Each Equip still presses
`_toggle_party_rune` by its index in `Run.party_rune_rows()`; `Runes.shown_desc(` stays two calls on this panel (`check_gs` §4's 13).

**THE RULE, FINISHED, AND ASSERTED**: IA sectioned the rune panel, IE took the hero sheet's worn row, IF the last two — **no panel in the
game states a row's state twice**. `check_id` §3a holds ✦ to four lines (the battle's rune chip, the kit preview's count, the
nameplate's count, the bag's crest count) with no exception left; `check_if` §3c sweeps every row of the rune panel, the Kit panel and
the bag for a mark or a head word. **Each panel with its negative arm** (`check_if` §3a/§3b): the emptiest panel (every section drawn,
each empty one with its line and no row), and every row read for the state its head gives. Rendered to PNG and looked at.

## §0.1b — THE CRACKED HOURGLASS

**Which heroes hold Mana**: the Mage, the Cleric and the Hunter (`_class_config`: `resource_name: "Mana"`); the Warrior holds Rage
(`HERO_BASE` mana 0). **Why it skipped the Hunter: an accident.** `restore_mana`'s `key == "mage" or key == "cleric"` was written in
`69961d5`, the commit that added the Hunter — on Focus; `6fe2071` (*Batch 28 … Hunters on Mana*) moved him and never this line, and no
resource rule excludes him. **So the code moved and the card stays**: the relic refills every hero whose class holds Mana. **And it never
takes Mana away**: a bar carried past the member's fixed `max_mana` (100) by a +20 node — a sim build's 110 of 120 — was cut to 100 by
the old line; it is left where it stands now (`check_if` §4, through a real victory; the Warrior's member untouched).

**The three dry fractions, the relic held both ways** (IE's probe, 20 runs a lineage, rung 1, the rate 12; per-run mean ± SE):

| arm | build | Cleric | Mage | Hunter | opens full (C / M / H) |
|---|---|---|---|---|---|
| **relic held, IF (every Mana hero)** | default | **1.6 ± 0.3** | **3.4 ± 0.8** | **0.9 ± 0.2** | 20.0 / 32.4 / 16.0% |
| relic held, IE (the Hunter skipped) | default | 0.7 ± 0.2 | 1.7 ± 0.5 | 4.1 ± 0.7 | — |
| no relic, IF | default | 3.5 ± 0.5 | 4.1 ± 0.9 | 3.6 ± 0.5 | 19.9 / 29.3 / 10.1% |
| **relic held, IF** | untalented | **11.5 ± 1.1** | **16.4 ± 3.0** | **20.9 ± 1.4** | 7.7 / 10.9 / 3.7% |
| relic held, IE | untalented | 13.1 ± 1.0 | 14.5 ± 2.8 | 36.0 ± 1.6 | — |
| no relic, IF | untalented | 27.2 ± 1.4 | 17.9 ± 2.8 | 35.3 ± 1.6 | 4.6 / 6.1 / 1.6% |

**Read plainly**: with the relic reaching him the Hunter goes from the driest Mana hero to the least dry on the default build (4.1% →
0.9%) and loses 15 points untalented (36.0% → 20.9%); the no-relic arms match IE's within the error, as they must. With the relic, at a
turn's start the bars read 91 / 97 / 95 of 120 (default) — the Mage, not the Cleric, now sits nearest full. **The rate is not touched**
(§5); the designer rules it after the file (ruling 2).

## §4 — HOUSEKEEPING

**THE MOVE WAS NOT ATTEMPTED** (IB §4). **Read at IF's start** (before IF made a folder): **561 folders**, the brief's figure. **Read at the
close**: **587 folders, 252,176 KiB** in all — IF's own 26 among them. The spent prefixes — every *Dawn of Decay* copy from FX to IE and the five *DoD …* copies — are **559 folders, 225,196 KiB**: IE's thirty-five (**50,592 KiB**) and the 524 before them (174,604 KiB, IE's reading, unchanged). The live *Dawn of Decay* folder holds 68 entries, 528 KiB — one more than when IF began: the harness save (`run_save_harness.bin`), which a target rewrites or clears, was absent then and stands at the close; no IF scratch file and no readout folder is in it.

**ONE command clears every spent prefix** — every *Dawn of Decay* copy from FX to IE (IE's thirty-five included) and the five *DoD …*
copies — leaving the live *Dawn of Decay* folder, IF's own and `[unnamed project]`:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IE)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-E]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IE)/"
```

**IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the
paste first. **IF's own folders** are named *Dawn of Decay IF …* and stay for IG: **twenty-six, 26,440 KiB** — the smoke copy, the three recon pairs (the first two of each stopped unread), the Hourglass probes (*mprobe1–3*) and the fire probes (*fprobe*, *fprobe2*), the A/B road's two (*abON*, *abOFF*), the stubs and traces (*stS*, *stH*, *trI*, *trH*), the three control lanes, the gate and document-reader copies (*cur1*, *cur2*, *docsub*), the pre-pass and the final re-run. (The glob above stops at IE, so it leaves them.)

**Does a batch need thirty-five copies? No — most of them could share.** A folder is chosen by the clone's `config/name`, so it is a
per-lane decision. **Lanes that never run at once can share one folder safely**: every gate points `Profile` and `Relics` at its own
scratch file and removes it, the harness save is rewritten by whatever runs next, and each control re-seeds nothing it does not read. IE's
thirty-five were mostly sequential probes, traces and stubs, each with its own name. **Lanes that run at the same time cannot**: two
lanes in one folder share the harness save and the scratch profiles (HO's `check_hl` red, read from exactly that). So the count could
fall to one folder per *concurrent* lane — about five for a batch like IE (two recons, the pre-pass, the controls, the probes) — and the
growth follows the briefs' shape instead of their length. Not changed here.

**The live folder** was read and not changed; `../save-backups/` gained IF's backup only; `[unnamed project]` untouched.

## §5 — WHAT IS DELIBERATELY NOT DONE

- **THE CHIPS AND SANCTITY ARE IG's, IN THAT ORDER** — every display chip converted, then the rate measured, then the threshold set.
  Nothing here.
- **THE CLERIC's RATE IS NOT TOUCHED** (12); only the Hourglass's reach was measured and its code repaired. **PYROBLAST IS NOT REPAIRED.**
- **IC's REMAINDER IS STILL OWED, AND IT IS II's** — the tick's line, Blight the Well's line, credit and frame, the bleedout burst,
  Umbral Sigil's echo, a tick credited by name. **It has waited two batches and now waits a third.**
- **THE RE-MEASURE DOES NOT RUN; IT IS IH.** Its two readings at IF's close: `CLAUDE.md` 465,682 B = 454.77 KiB, **55.23 KiB under 510** — 6.8 batches at EZ's record (56,558 ÷ 8,293), 18.3 at IF's own +3,084; `docs/state.md` 351,983 B = 343.73 KiB, **36.27 KiB under 380** — 6.3 batches at IA's +5,860 (37,137 ÷ 5,860), 6.7 at HO–HW's +5,528 mean (+236 B at IF). **The honest rate, beside them**: ID +952, IE +3,917, IF +236 — a mean of 1,702 B, 21.8 batches at it, so the room is likely larger than the worst case says; `docs/state.md` still binds first at every rate the figure uses.
- **The claims stand at 86** and are IJ's.
- **The sim bot's fire is not taught** (IE's finding stands: the bot reaches a drafted Smoulder as it reaches a drafted Fireball, rarely).
- No crest rune re-cut or authored; the crest cap stays at one. Boil Over's rate not re-ruled, its Perfect not authored, the rising-rate
  lever not built. The vow not re-priced, the recoil floor not exempted, Anointing unchanged. The third slot not gated behind a rung.
- **No conjunction authored**: `RUPTURE_BREAK_PER_TICK` stays at 10 — §1 and §2 are what make it feelable.
- Standing and unchanged: a copied Frostbind's refusal **RULED, NOT BUILT**; **Mana stays**; a meter is not a conjunction half;
  Marrowfire becomes Sunder + Burn and Contagion and Reckoning owe re-cuts; the Occultist's Break card is CE §3's ask; the Skirmisher and
  the Tracker are ruled into ordinary runes and unbuilt, with Volley and Ambusher owed their core slots and both owed names; Channel's
  tempo payout is owed; whether a fallen hero stays down between fights is owed and prices three crest runes; Tithe's read site and its
  talent rebalance; a bomb's surface text; the block index.

## §7 — THE ONE LINE THAT MATTERS MOST

**Play one zone, then send the file.** It is written to `~/Library/Application Support/Godot/app_userdata/Dawn of Decay/readout/` — one
`run-<date>-<time>.jsonl` a run, the newest the run being played. Nothing needs switching on; a resumed run keeps writing to its file, and the
run saved on 2026-10-08 opens a file of its own, marked *resumed*. Five rulings come off it.

## §8 — THE VERIFICATION

### §8a — THE PUSH CHECK, THE SAVES, THE SWEEPS AND THE INTEGER PINS, BEFORE THE PREDICTIONS

`git ls-remote origin class-merge` read `7c4f256…`, local HEAD the same, before anything ran. The four player files were md5-identical to
IE's backup and were backed up to `../save-backups/IF-20261013-152812`, verified by md5; re-read at the close (§8h).

**The literal sweep, game code** (`tools/litsweep_if.py`, ID's and IE's, extended to every literal a gate reads with `.count(`): **on the
readout alone** (recon A's three files) **0 lost**, every gained needle and short flip in the new `readout.gd`; **on all of IF's code** (recon
B's) **4 lost**, all in `map_screen.gd`: `✦ %s — ` (`check_gt` §3's needle — named red), and three no gate reads off `map_screen.gd`
(`ALLY`, a substring of a deleted comment's *ACTUALLY*; `twelve`; `protected_names`, which `check_eh` reads with comments stripped, where it
never stood). No `.count(` pin on these files moved. Each sweep ran before its prediction; each was re-run on the final code before each of
the three launches (the first two pairs were stopped unread — §8b) and read the same lists.

**The integer pins, counted against the doors** (IE's third thing): the diff adds **0** calls to `_apply_status(` (`check_di` holds 221 —
Smoulder lays through the generic `applies_status` site Fireball uses; **the brief's *§2's card will add one* does not hold**), 0
`add_status(` (`check_hu` §2b), and keeps `Runes.shown_desc(` at 13 across the four screens (`check_gs` §4 — the crest panel keeps two
calls) and `Run.unequip_earned_ability(` at 2, `func _toggle_loadout(` at 1 (`test_batch_bo`).

**The documents' sweep** (`tools/litsweep_docs.py`, raw and whitespace-collapsed) over the six edited documents: **9 lost** — eight in
`docs/state.md`'s rewritten WHERE block (*Burning*, *Empower*, *the loadout panel* …), none a needle of the four gates that open that file,
and `one hundred and three` off `master.html`, which `check_fs` uses only to self-test its number reader — **60 gained**, IF's own needles
and words, 4 short flips in the archive.

### §8b — THE RECON's SHAPE: TWO, AND WHY (the brief's §6, applied)

**The blast radius was read first.** §1d says the readout moves nothing, and §1d is the premise ID's 25 got wrong — so §1 got a recon of
its own: **recon A, HEAD's whole battery on the readout alone** (`battle.gd`, `readout.gd`, and `run_state.gd`'s readout half — its
Hourglass line HEAD's). **Recon B, HEAD's whole battery on all of IF's game code.** Each in an isolated APFS clone, md5-frozen at launch
(531 files), its own user folder seeded from the backup; recon B's `scripts/` proved byte-identical to the final tree's. **Each was
launched twice and stopped unread before its third launch** — at 15:56 and 16:08 — because the readout gained one hook (`_stat_heal`: a
heal books `heal_hero_` in the sim alone, so the vow's healing read 0 in real play — `check_if` found it) and then one key (`encounter`:
the line's own `kind` dropped the node's kind in the merge — the A/B road's file showed it). Nothing in `scripts/` moved after the third
launch (16:15). The predictions were written first (15:55 / 15:56) and confirmed against each re-sweep before each relaunch.

**RECON A — THE READOUT ALONE**, 16:15:03 to 17:37:07 (82 min 4 s), HEAD's 145 targets: **`check_de` 597 / 0 / 1 notice — exactly as
predicted.** Target by target against IE's acceptance run, **one row differs: `check_parse` 221 against 220** (the new file). `check_gp`
469, `check_gj`'s sanctioned *+179 / 199*, `check_cm_live`'s five FAIL lines (md5-identical to IE's), every seeded road and band, the
harness 22 / 382 / 8 — all IE's. **§1 moves no figure in HEAD's battery.**

**RECON B — ALL OF IF's GAME CODE**, 16:15:08 to 17:37:23 (82 min 15 s): **`check_de` 597 / 13 / 7 notices.**

| The prediction (`RECON_B_PREDICTION.md`, written before the launch, after its literal sweep) | What HEAD's battery read on IF's code |
|---|---|
| **Red**: `check_ie` (§3b ×2, §4), `check_id` §3a (1), `check_gt` §3 (one per sitting-out and undone card), `test_batch_cd` (several), `check_do` (1), `test_batch_bw` (1), `check_gu` §2 (1) | **All held**: 70 / 3, 210 / 1, 6816 / **18** (17 sitting-out rows, 1 undone), 92 / 6, 112 / 1, 513 / 1, 318 / 1 |
| **Rising** (notices): `test_batch_ah` +4, `bo` +5, `cb` +1, `ce` +1, `check_gt` +3, `check_gu` +1, `check_parse` +1 | **All held**: 6189, 1145, 2107, 931, 6816, 318, 221 |
| **The dice**: `check_gp` moves (469 + 1 + the road's drift); `check_gj`'s figures may move; `check_hk`, `check_gv`, `check_fh`, `check_ib`, `check_he` may move | **`check_gp` 444** (−25) and **`check_gj` +168 / 188** — both moved and both Smoulder's (§8c); **`check_gv`, `check_hk`, `check_fh`, `check_ib`, `check_id`, `check_he` did not move** |
| **Green**, named: `check_ia`, `check_hk` §2h/§4e, `check_ho` §1f, `check_gs`, `check_fh`, `check_fn`, `check_map_screen`, `check_hr`, `check_ek`, `check_ft`, `check_hu`, `check_di` 221, `check_dv`, `check_hi`, `check_cn`, `test_batch_cp` | **All green** at their rows |
| — | **MISSED, five, one cause**: `test_batch_br`, `bu`, `bv`, `cb` (×2) and `ce` each pin **`master.html`'s live draft count** (179, *one hundred and seventy-nine*, *fifty-two for a Mage*) — the family the census named two of (`check_do`, `test_batch_bw`). They read HEAD's documents in the recon; IF's `master.html` carries the counts, and all seven read green on it (§8d). |

**What the miss teaches, recorded rather than repeated**: a count a document must state is pinned by every suite that ever moved it, so a
change to a pool's depth is read by a *family* of document pins, not by the two the census found — the population is every reader of
`master.html` that renders the live total, and a census by needle finds it where a census by gate name does not.

### §8c — WHAT MOVED THE COUNTS, ATTRIBUTED BY TRACE AND STUB

**Every moved count is put on one cause by a trace or a stub, never by reading the diff.** The stubs are recon B's tree (HEAD's gates, IF's
code) with one thing put back: **stS** — Smoulder off the Pyromancer's shelf; **stH** — HEAD's `restore_mana`.

- **`check_gp` 469 → 444 is Smoulder's.** Four traced copies of HEAD's gate (every `ok()` printed): HEAD's code **469**; IF's code **444**;
  stS **469, identical to HEAD's line for line**; stH **444, identical to IF's line for line**. The difference: +1, §2b asks Smoulder (no
  engine, offered); −26, §4's no-engine road was offered **52 cards where it was offered 78** — a Mage pool one card longer reshuffles every
  Mage roll the seeded road makes (`roll_draft_offer` shuffles the whole pool), and §4 prints a line a card. 33 battles either way; the
  two-engine road 33 where 32, shown 61 cards where 72.
- **`check_gj`'s sanctioned §4 red reads +168 / 188 where it read +179 / 199**, the count unmoved at 70 / 1: stS reads +179 / 199 exactly,
  stH +168 / 188 — Smoulder's again, the same reshuffle on that road.
- **The rising counts are Smoulder's loops**: on stS, HEAD's `test_batch_ah` reads 6185, `test_batch_bo` 1140, `test_batch_cb` 2106,
  `test_batch_ce` 930, `check_gu` 316 and `check_gt` 6813 — HEAD's every one (`check_gt` with only its 18 Kit-panel needles, §3's).
- **`check_parse` 220 → 222**: `readout.gd` and `check_if.gd`, two targets.
- **Nothing else moved** across 145 targets in either recon. **The Hourglass moves nothing in the battery** — stH reads IF's figures on both
  roads; no gate seats the relic.

### §8d — EVERY RE-POINTED GATE, ALONE, AND THE DOCUMENT READERS, BEFORE THE RUN

On a clone of the tree (proved equal), stderr grepped for `Parse Error` and `SCRIPT ERROR` (none): `check_if` **80** / 0 (new), `check_ie`
70 / 0, `check_id` 210 / 0, `check_gt` **6816** / 0, `check_gu` **321** / 0 (+5: the sweep resolves one card more and finds it below a kit
card, and its row is asked three things), `test_batch_cd` 92 / 0, `check_hx` 39 / 0 (after the readout's block was declared — it read 39 / 1
first: *a new block reds until its author says which file it belongs in*), `check_ek` 47 / 0 (`check_if` listed — it names `CARD_TAGS`),
`check_parse` **222** / 0; and the gates that read other gates' source — `check_da` 41, `check_dw` 35, `check_ea` 396, `check_ff` 68,
`check_gw` 76 (`check_if` hand-sets no rune field) — each 0 failures. **The 63 document readers** (IE's union and a derivation by `res://`
reads), on a clone proved equal to the tree (531 files): **all green but one — `test_batch_bx` 163 / 1, *master.html says hero or ally
everywhere it is prose***: the readout's paragraph said *the party's lineages*. Repaired (*each hero's lineage*), the master sweep re-run
(no needle moved), `test_batch_bx` 163 / 0. **The pin manifest rebuilt**: 1,779 pins, its unresolved set HEAD's eleven, seven gained (IF's
needles); rebuilt again after the last gate edit, unchanged.

### §8e — TWENTY-SIX CONTROLS, EACH IN ITS OWN CLONE

One APFS clone of the tree per control, every patch count-asserted (all landed), three lanes with their own user folders (*Dawn of Decay IF
ctlA*, *ctlB*, *ctlC*), every FAIL line kept; clones are never deleted (each control gets a fresh one). **Every planted defect reds at the arm
it aims at; the baseline is green; HEAD's game code under IF's gates (H01) reds every IF gate but `check_gt`**, whose re-pointed needle
asks whether the Kit panel says a card sits out — HEAD's panel says so too, with ✦ (C24 is the control that reds it).

**And one control found a hole, repaired and proved two-armed**: C16 — a kit row carrying its state word in a column of its own — read
`check_if` 80 / 0 on the first lane, because the panel reader took a row's LAST label as its text and the column was the first. The reader
reads every label in a row now (joined by ` ¦ `); C16 reads 80 / 3 on the repaired gate, and the baseline 80 / 0.

| # | The defect planted | What read it |
|---|---|---|
| C00 | baseline: the final tree, no patch | `check_if` 80 / 0<br>`check_ie` 70 / 0<br>`check_id` 210 / 0<br>`check_gu` 321 / 0 |
| C01 | the readout spends a die at every turn's opening | `check_if` 80 / 6 — *§1b: the readout ON moved log — it is not a read* |
| C02 | a hook stands behind a looser test than its null test | `check_if` 80 / 1 — *§1e: a readout hook in battle.gd does not stand behind its null test: ["_readout.turn_open(u)"] (16 calls)* |
| C03 | the readout is on in a harness that did not ask | `check_if` 80 / 3 — *§1a: the readout's decision is wrong for [["", true, false, false]] (env, active, player, wanted)* |
| C04 | the save carries the readout's state | `check_if` 80 / 2 — *§1b: the readout ON moved save — it is not a read* |
| C05 | a harness's readout writes the player's folder | `check_if` 80 / 2 — *§1b: the ON arm wrote no file in the harness's folder ('user://readout/run-20261013-162956.jsonl')* |
| C06 | a Rupture's tick is not recorded | `check_if` 80 / 1 — *§1d: the Rupture is not on the line by its name, degree, ingredients, its tick and the Break it ground out* |
| C07 | the vow's healing is read off the sim-only credit (the heal hook removed) | `check_if` 80 / 1 — *§1d: the vow is not on the line with the blow it refused and the healing it added: { "blows_refused": 1.0, "damage_refused": 20.0, "heal_added": 0.0 }* |
| C08 | Boil Over's pour is not recorded | `check_if` 80 / 1 — *§1d: the Boil Over is not on the line with its Rage, its damage, the core and the best ordinary turn* |
| C09 | the frame's node kind is keyed `kind` again (the merge drops it) | `check_if` 80 / 1 — *§1c: the fight line is not the fight's frame: { "bargain": "", "boil_over": [], "conjunctions": [], "enemies": ["raider", "raider", "archer"], "fell":* |
| C10 | the readout writes a unit's figure (turn_close tops his bar up) | `check_if` 80 / 4 — *§1b: the readout ON moved units — it is not a read* |
| C11 | Smoulder's Burn is no longer than Fireball's | `check_if` 80 / 1 — *§2: Smoulder is not a fire card laying a longer Burn than Fireball's, on Fireball's cooldown, for less damage*<br>`check_gu` 321 / 1 — *§2: Smoulder no longer buys a longer Burn than Fireball's for less damage — its point is gone* |
| C12 | Smoulder reads an engine (an ENGINE_READ row) | `check_if` 80 / 1 — *§2: Smoulder is not in the Mage's one pool, offered to a Mage holding no engine* |
| C13 | Smoulder leaves the Mage's pool | `check_if` 80 / 1 — *§2: Smoulder is not in the Mage's one pool, offered to a Mage holding no engine*<br>`check_ie` 70 / 1 — *§3b: the fire population moved — unnamed [], no longer held ["Smoulder"]*<br>`test_batch_cd` 92 / 5 — *pyromancer drafts 16 (want 17)* |
| C14 | a carried card's row leads with ✦ again | `check_if` 80 / 3 — *§3a: CARRIED holds ["✦ Cinderfall", "Winter\'s Toll"] and BENCHED ["Ember Debt"] — want [Cinderfall, Winter's Toll] and [Ember Debt]*<br>`check_id` 210 / 1 — *§3a: ✦ is drawn for something that is not a rune's mark or a rune count: ["map_screen.gd: lbl.text = \"%s%s%s\" % [\"✦ \" if is_on else \"\", aname, \*<br>`check_ie` 70 / 1 — *§4: the loadout panel's carried card is not its name, or a label on the panel carries ✦ — ✦ names a rune*<br>`check_gt` 6816 / 0 |
| C15 | the Kit panel's enablers sit under CORE (no ENABLERS head) | `check_if` 80 / 2 — *§3a: the panel's sections are not CORE, ENABLERS, CARRIED and BENCHED in that order, each separated: ["CORE — never benched", "row:Magic Bolt/", "row:* |
| C16 | a kit row carries its state word in a column again | `check_if` **80 / 0 on the gate before its repair** (lane A — the hole); **80 / 3 after** (lane B) — *§3a: CORE holds ["CORE ¦ Magic Bolt", "CORE ¦ Magic Burst", "CORE ¦ Nexus Ward", "CORE ¦ Magic Missiles"] and ENABLERS ["CORE ¦ Flamewave"] — want the* |
| C17 | the worn crest rune carries ✦ again | `check_if` 80 / 4 — *§3b: THE CREST does not hold its one worn rune with Unequip, and no empty slot: { "found": true, "rows": [["✦ Dead Air — While no Mage stands, every h*<br>`check_id` 210 / 1 — *§3a: ✦ is drawn for something that is not a rune's mark or a rune count: ["map_screen.gd: plbl.text = \"✦ %s — %s\" % [String(pr.get(\"name\", \"\")),* |
| C18 | a bagged crest rune is listed twice (under THE CREST too) | `check_if` 80 / 4 — *§3b: THE CREST does not hold its one worn rune with Unequip, and no empty slot: { "found": true, "rows": [["Dead Air — While no Mage stands, every her* |
| C19 | a bag row is marked (in the bag) | `check_if` 80 / 2 — *§3b: a rune is listed twice (1) or a row marks its state: ["row:Dirge  (for crest) — While a hero lies fallen, the rest deal\n45% more damage.   (in t* |
| C20 | an empty crest slot is not drawn | `check_if` 80 / 2 — *§3b: an empty crest does not draw its slot, or the bagged rune does not offer Equip beside Drop: ["THE CREST — 0 of 1 filled", "<sep>", "IN THE BAG", * |
| C21 | the Hourglass skips the Hunter again (Mage and Cleric only) | `check_if` 80 / 1 — *§4: the Hunter, who holds Mana, did not recover 30 (20) — the relic's card says every hero* |
| C22 | the Hourglass cuts a bar above the cap again | `check_if` 80 / 1 — *§4: the relic cut a bar above the member's cap (110 -> 100) — recovering is never a loss* |
| C23 | Smoulder priced above Magic Missiles (no longer below it) | `check_gu` 321 / 1 — *§2: Smoulder sits below ["Magic Burst"], where its row says ["Magic Burst", "Magic Missiles"]*<br>`check_if` 80 / 1 — *§2: a fire card costs no more than Smoulder: ["Ember Debt 20", "Slow Burn 15", "Stoke 20", "Emberkeep 20", "Fireball 15", "Wildfire 20"]* |
| C24 | the Kit panel no longer says a carried card sits out (its own text instead) | `check_gt` 6816 / 17 — *§3 permafrost: the Kit panel does not say Winter's Toll sits out, or which rune brings it back*<br>`check_if` 80 / 1 — *§3a: the card that sits out does not say so under CARRIED: [["Winter\'s Toll — Collect the interest: the HELD enemy\ntakes 8% of Attack for every turn* |
| C25 | the readout's CLAUDE.md block is renamed (an undeclared block) | `check_hx` 39 / 1 — *§1c: 1 block(s) in CLAUDE.md are not in the known population: STANDING RULE — THE READOUT IS A READ* |
| C26 | check_if is not on check_ek's list of tag-reading gates | `check_ek` 47 / 1 — *exactly the authored TARGETS check a tag — found [check_ek.gd, check_el.gd, check_es.gd, check_ez.gd, check_fd.gd, check_fe.gd, check_fh.gd, check_fk.* |
| H01 | HEAD's game code under IF's gates | `check_if` 40 / 20 — *§1b: the premise — each arm's fight ended inside 30000 frames (false false false)* (4 throws)<br>`check_ie` 70 / 2 — *§3b: the fire population moved — unnamed [], no longer held ["Smoulder"]*<br>`check_id` 210 / 1 — *§3a: ✦ is drawn for something that is not a rune's mark or a rune count: ["map_screen.gd: lbl.text = \"%s%s%s\" % [\"✦ \" if is_on else \"\", aname,",*<br>`check_gt` 6813 / 0<br>`check_gu` 318 / 1 — *§2: Smoulder sits below [], where its row says ["Magic Burst", "Magic Missiles"]* (1 throws)<br>`test_batch_cd` 92 / 6 — *...it carries the real target (179)* |


### §8f — THE PASS CONDITION's RUNS, AND THE MEASUREMENTS

- **The readout on and off** (§1d): the A/B road, final code, fixed frame step — 1,116 game lines identical; the gate's §1b on every run.
- **The probes** (scratch copies, never the repo; IE's instrument re-pointed): the Hourglass's four arms, 20 runs a lineage, three parties
  each (§0.1b's table); Smoulder's fixed drafts, 80 fights an arm, both policies, and the Cryomancer's Rupture arm (§2's table).
- **The panels rendered to PNG** in a windowed probe in a renamed clone (a window flashed on the designer's screen for a few seconds):
  the Kit panel full and bare, the bag full, empty and bag-only.

### §8g — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass**: an APFS clone proved equal to the tree (531 files, the project name aside), its own user folder seeded from the backup, 146 targets, 17:41:59 to 19:03:41 — **`check_de` 601 / 0 / 0**, its copy byte-identical after. **The acceptance in the repository**: 146 targets, 17:42:02 to 19:03:33 — **81 min 31 s** — **`check_de` 601 / 0 / 0, as predicted** (`ACCEPT_PREDICTION.md`, written at 17:39:01): `check_if` 80 / 0, `check_parse` 222 / 0, `check_gp` 444 / 0, `check_gj` 70 / 1 (its sanctioned §4 at *+168 / 188*), `check_gt` 6816 / 0, `check_gu` 321 / 0, `check_id` 210 / 0, `check_ie` 70 / 0, `check_di` 44 / 0, `check_hx` 39 / 0, `check_ek` 47 / 0, `check_ed` 18 / 0, `check_gw` 76 / 0, `test_batch_ah` 6189, `bo` 1145, `cb` 2107, `ce` 931, `cd` 92, `bw` 513, `check_do` 112 — each 0 failures; `check_cm_live` 13 / 5 (inside its band, its five FAIL lines IE's); the harness 22 / 382 / 8; `test_batch_an` 6049 and `test_batch_bk` 131 inside their bands (the pre-pass 6053 and 131) — **the prediction's parenthetical named the readings seen so far (6051–6054), not the row's band (6044–6066)**, a slip in the wording and not in the row; `check_map_screen` complete. **`ps` read by rows every 15 s**: 326 readings and 627 Godot rows across the two batteries, every one `--headless` and no game window — 304 readings saw two, 19 saw one, 3 saw none (between targets). **The tree was byte-identical before and after** (532 files, tracked and untracked), and **the player's four files were untouched**. The two runs agree target for target but `test_batch_an` (6053 / 6049), the band's own spread.

### §8h — THE CLOSE

**The post-run lines** — `docs/state.md`'s verification line and its two readings — were written after the run, the second at a fixed point (the file states its own size: 351,983 B). **Their needle proof**: every gate literal against the copy the battery read and the final file — **no flip** among 20,393. **The four gates that open `docs/state.md` and the two manifest instruments, re-run on the final tree in an isolated copy** (*Dawn of Decay IF final*): `check_es` 57 / 0, `check_fg` 30 / 0, `check_hp` 171 / 0, `check_hx` 39 / 0, `check_ec` 24 / 0, `check_ed` 18 / 0 — each at its acceptance reading. **The player's four files, re-read at the close**: byte-identical to `../save-backups/IF-20261013-152812` by md5, `run_save.bin` 42,200 B last written 2026-10-08 09:23 — **nothing has been played for ten batches**, so the readout has not yet run in the designer's game and their folder holds no readout. **This report was written last**, out of the scratchpad, with no template token left. The push and its `ls-remote` check follow the commit that carries it.
