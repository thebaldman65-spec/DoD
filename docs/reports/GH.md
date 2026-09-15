# Batch GH — A quit fight restarts, but the party's losses do not

*Branch `class-merge`, from `9158474` (GG); `git ls-remote origin class-merge` read `9158474` before the push. `main`
is untouched.*

## NEEDS A RULING

1. **RAGE RESETS, WHERE THE RULING LISTED IT AS CARRYING.** The ruling carried *"Resources — Mana, Rage, and whatever a
   class spends"* and reset every meter because *"carrying them would REWARD the quit."* It also gave the rule for
   everything else: *does it persist between fights today?* Mana does — it is a member field a won fight writes, and a
   fight spends it down. Rage does not: every fight opens it at 0, plus First Blood's and Bottled Storm's floors, and a
   fight builds it up. Carried, a Warrior who quit at 90 Rage would open the restart at 90 where every fight opens him at
   0, which is the reward the ruling's own reason forbids. **So it resets, and carrying it instead is one member key and
   one spawn line.** Mana carries as ruled.
2. **A QUIT STILL BUYS TWO THINGS (§4b, driven).**
   - **A quit before anything is lost costs nothing and rolls the opening again**: the turn order and every enemy's
     declared first action. Driven on both builds with nobody having acted: the opening came back different on each.
   - **Cooldowns, once-a-fight refusals and the party's statuses clear with the warband's**, because they are per-fight
     by the ruling's own rule.

   Both are per-fight by construction, and closing them needs the fight itself captured — GG's A or B, a project.
   **Whether a quit should cost more than this is the designer's.**

## THE SHORT VERSION

- **§1 — BUILT AS RULED, AND THE LOSSES REACH THE SAVE AS THEY LAND.** A fight quit before it is won restarts from its
  opening against the warband at full strength, and the party comes back as it stood at the quit: health, Mana, every
  item used, a hero who fell still down, a companion standing back at its health. The rule for every field the ruling
  does not name is the one it offered — *does it outlive a fight today* — and only health, Mana and the pouch do; every
  one of GG's 130 fields is sorted by it (§1b). **The save is written at the doors that book a loss, not only between
  turns**, because a quit can land inside an enemy's swing, and between-turn saves would hand the swing back — the death
  with it.
- **§2 — THE LAST-HERO EXPLOIT IS CLOSED.** Defeat is decided in `_check_end`; the last fall now reaches the save inside
  the hit that deals it, so a quit before the defeat screen resumes into a battle with no hero standing, and the battle
  decides that defeat as it opens. **Four dead heroes were not a softlock even without that**: the first enemy turn's end
  check calls the wipe (driven, with the opening check switched off).
- **§3 — NO SAVE VERSION.** Every value written is a v13 field, plus one member key that rides the party dict.
- **§4 — THE INVERSE AND THE ESCAPE, DRIVEN AS REAL QUITS.** A second quit deducts nothing twice and re-spends nothing.
  What a quitter still gets is in NEEDS A RULING, item 2.
- **The drives found one hole in the first build and it is closed**: a companion killed by the blow the quit landed on
  came back at 1 health — the bear-scum itself (§1d).
- **The reconnaissance battery found one red the pre-check had predicted**: `test_batch_bx` §4 reads the word *beast* in
  the new member key's string. The key is `companions_standing` now (§1c).

## §0 — THE BRIEF'S PREMISES

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD `9158474` (GG), and `origin/class-merge` read the same |
| 2 | *"GG costed the full resume and stopped"* | **HELD** | GG §1 |
| 3 | *"only one point in a fight can be resumed from"* | **HELD** | GG §1e: the top of `_run_battle`'s turn loop |
| 4 | *"each unit carries about 130 things a fight changes"* | **HELD** | GG §1c: 130 fields written by something that runs during a fight |
| 5 | *"Godot's shared RNG cannot be read back — so a resumed turn rolls fresh whatever is captured"* | **HELD, WITH GG'S QUALIFIER** | GG §1e.2: a seed stored at every boundary would replay a turn's rolls, provided everything after it rolls in the same order |
| 6 | *"Even the three-batch option does not fully close save-scumming."* | **NOT AS STATED** | GG §2d puts A, *"a project, three batches or more"*, at *"nothing"* left to retry; its third batch is the seed-and-replay that closes the retry (GG §1f item 5). B, two batches or more, is the one that leaves an action |
| 7 | *"Ruled: Option C … the party's losses carry through."* | **HELD AS A RULING, BUILT AT A FINER GRAIN** | GG's C wrote health, Mana and the pouch at the top of the turn loop. Built at every door that books a loss as well (§1c says why) |
| 8 | *"One batch, no save format change"* | **HELD** | §3 |
| 9 | *"GG found four of my premises wrong — Blood Frenzy does store `rage_spent`, no unit carries a `delay`, Loyalty belongs to the hunter, and GF's commit was 19 files."* | **HELD FOR THE FOUR NAMED** | GG §0 rows 8, 7, 10 and 16; `git show --stat bc6e258` reads 19 files. GG's table qualified three more: row 3 (*"wider than stated"*), row 9 (Ruin, Burn and Chilled are statuses) and row 14 (*"stale"*, not *"wrong"*) |
| 10 | *"Health, as it stood at the quit."* | **HELD AS BUILT** | A loss reaches the save as it lands; a gain at the next door (§1c) |
| 11 | *"Resources — Mana, Rage, and whatever a class spends."* | **NOT AS STATED FOR RAGE** | NEEDS A RULING, item 1. Every hero's `resource_name` is Rage (the Warrior) or Mana (the other three); `_player_turn`'s Focus drip reaches no unit (FW) |
| 12 | *"Items used. They are spent and they do not come back."* | **HELD AS BUILT** | §1d, the Bomb drive |
| 13 | *"A fallen hero stays down."* | **HELD AS BUILT** | §1d |
| 14 | *"A dead companion stays dead; a living one returns as it was … a Beastmaster quitting to un-kill his bear is the exact scum this closes."* | **HELD, WITH A QUALIFIER** | Within one fight a fallen companion can already be called again — `_do_summon` clears the corpse on the next call — so what GG's restart handed back was the summon's Mana and the rest of the fight, not the death. And the first build here left the scum open at a finer grain, closed before the battery (§1d) |
| 15 | *"The warband — full health, no statuses, as GF already does."* | **HELD** | §1d |
| 16 | *"Every meter … reset, as they do at the start of any fight."* | **HELD, WITH TWO NOTES** | Ruin, Burn and Chilled are statuses (GG row 9) and reset with them. Blood Frenzy's health half is read off health, which carries, so a wounded Berserker restarts with that half filled: his health, not a meter. FK's two between-fight banks open the restart as they opened the fight (§1b) |
| 17 | *"Statuses on the party … Cooldowns."* | **HELD** | Reset; §1d |
| 18 | *"GG found about 130 things a unit carries; this ruling names perhaps a dozen."* | **HELD** | §1b sorts all 130 |
| 19 | *"quitting after the final hero falls but before the defeat screen restarts a fight the player had already lost"* | **HELD, AND NOW DRIVEN** | GG read it in the code. Driven on GG's code: four heroes dead at the quit came back alive at the step's health (§2) |
| 20 | *"the restart begins with four dead heroes … A restart into an unwinnable board is a softlock"* | **NOT AS STATED** | Driven with the opening check switched off: the first enemy turn's end check calls the wipe (§2c). The run was over either way; the check makes it immediate |
| 21 | *"GF took it to v13 and this batch should need no version."* | **HELD** | §3 |
| 22 | *"The party's health, resources and inventory are already saved; what changes is that the restart stops overwriting them."* | **NOT AS STATED** | Nothing overwrote them. A fight wrote nothing until it ended, so the save held the step's values and the restart read those back. What changes is that the fight writes them as it goes. Only a Mana user's `mana` is a member field; Rage is saved nowhere |
| 23 | *"GG's table says Option C leaves a quitter 'nothing worth having.'"* | **NOT AS QUOTED** | GG §2d's words are *"nothing worth taking"*. What a quitter does get is §4b |
| 24 | *"the way GF drove nineteen quit points and GG drove its costing"* | **HALF** | GF drove nineteen (GF §1a). GG's costing was read in the code: its §1h table's second column was *"nothing in this batch was built to drive"*, and its §2c window was *"read in the code and not driven"* |
| 25 | *"`check_gf` … its 98 checks are the thing most likely to move"* | **HELD** | Unmodified against the new code: 98 / 1, the §3 health arm, in the reconnaissance battery. Re-pointed to 104 (§VERIFICATION) |
| 26 | *"Melted Armor and Caught Fast stay … The end boss is the next batch … The Peddler and the forge stay lost on a quit … No merge work"* | **HELD** | Untouched (§5) |

## §1 — WHAT CARRIES AND WHAT RESETS

### 1a. The rule, stated and applied

The ruling names a dozen things and GG counted 130 on each unit. Its suggested rule for the rest — **does it persist
between fights today?** — is the rule, and it sorts every field without a case-by-case call:

- **Everything a `BattleUnit` holds is rebuilt at the spawn**, and so is everything on the battle. Nothing on either
  outlives a fight except what a won fight writes back onto the run.
- **A won fight writes back** a member's `hp`, its `max_hp` with the one-fight gains taken off, a Mana user's `mana`,
  FK's two meter banks (`fk_resonance_carry`, `fk_mercy_carry`), and the pouch into `Run.items` (`_check_end`,
  `BattleUnit.sync_victory_state`).
- **So what carries through a quit is health, Mana and the pouch**, plus the ruling's two additions: a hero who fell and
  a companion standing. Everything else opens as it does at the start of any fight.

### 1b. GG's 130 fields, sorted

- **CARRIED:** `hp`, with `dead` written as health 0; `resource` on a Mana user, as the member's `mana`.
- **RESET, AS THE RULING NAMES:** every meter and ledger — `second_resource` (Focus, Mercy, Resonance), `faith_stacks`,
  `faith_peak`, `loyalty`, `momentum` and its four ledgers, `mana_spent`, `rage_spent`, `frenzy_floor`,
  `plating_bonus`, `winters_depth`, `weight_of_ruin`; `statuses` and every clock on one (`burn_*`, `hold_turns`,
  `chill_uncapped`); `cooldowns`.
- **RESET BY THE RULE, AND LISTED BECAUSE A PLAYER MEETS THEM:**
  - the one-a-fight flags, among them `second_wind_used`, `ashes_used`, `undying_rage_used`, `backblast_used` and
    `answering_pack_spent`: **a quitter gets each back** (§4b). `watchtower_used` and `poise_pivot_used` are one-a-turn
    and reset every turn anyway;
  - every card's bank — Deadfall's charges, Feint's guards, `banked_guards`, `berserk_strikes`, `iron_bank`, `keg_bank`;
  - the turn order (`next_time`), Break (`pressure`, `broken`, `broken_pending`, `broken_extra_turns`), the declared
    action (`intent`), `stance`.
- **NEITHER CLEARLY ONE NOR THE OTHER — WHERE EACH WENT, AND WHY:**
  - **Rage** (`resource` on a Rage user) — **reset**. The rule puts it there and the ruling's reason agrees; the
    ruling's list does not. NEEDS A RULING, item 1.
  - **`max_hp`** — a fight moves it (Conviction's lent health, Tenacity, Fortified Spirit, a companion's Bestial Wrath
    and Vigor, Rot's loss). **Reset**: the restart's maximum is the spawn's, and the carried health is clamped under it,
    so no lent health survives a quit.
  - **FK's two banks** — a meter carried between fights, consumed by the spawn. **The restart opens with them**, because
    the start of this fight did: `_bank_party_losses` puts them back onto the copy it saves, and only there, so in
    memory the member keeps the consumed shape and a won fight banks afresh.
  - **Blood Frenzy's health half** — not a field; it is read off health, which carries.
  - **A companion's Loyalty** — the hunter's meter, so it **resets**; a returned companion's maximum health reads it
    (Ursus) and the carried health is clamped under that.
  - **`kinds_summoned` and `beast_committed`** — **reset**, and a returned companion sets them again, because it is
    fielded.
  - **The battle's `item_used`** — per turn, **reset**.
- **ON THE BATTLE**, every one of GG's forty or so fields resets but the pouch, which carries.
- **Five of the 130 are nameplate state** a spawn rebuilds (`_base_tint`, `_float_stack`, `_plate_active`,
  `_plate_hover`, `_plate_root`).

### 1c. How it is built

- **`battle._bank_party_losses()`** writes every hero's health (0 for one who fell), every Mana user's Mana, every
  standing companion's kind and health, and the battle's pouch onto the run, and saves. **Absolute values**, never
  deltas. It writes nothing once `battle_over` is set, outside a live run, in a sim, or from a battle no longer in the
  tree.
- **It is called from every door that books a loss:**
  - BL's one damage door, `_on_damage_taken`, which every hit and tick passes below every death refusal, so a hero at
    zero there has fallen;
  - `_book_self_cost`, the direct costs' door (Phoenix Rebirth, Dark Pact, Blood Offering, Blood Price, Shared Grief);
  - the spend line every cast pays at, in `_resolve`;
  - `_use_item` as the item is spent and again once it has acted, and `_refund_item`;
  - `_do_summon`, once a called companion is on the field.
- **And from the top of the turn loop and the battle's *Exit to Main Menu***, which take whatever else moved: a heal, a
  drip of Mana.
- **Why at the doors and not only between turns, as GG proposed.** Nothing hooks a closed window, so whatever the save
  holds when the process goes is what comes back. Between-turn saves would let a quit inside an enemy's swing take the
  swing back, and the death it dealt: a turn's worth of free retry. Writing a handful of fields is safe at any moment;
  only capturing the fight is not.
- **The spawn.** A member at health 0 spawns with the floor of 1 for the opening, so every stamp reads him as the
  fight's first opening did, and falls once the field is built (`_lay_down_the_fallen`, `_die()`), with nothing of a
  death fired. A standing companion is fielded by `_return_standing_beasts` through `_do_summon`'s new `returning`
  path: the same body through the same door, without the call — no announcement, no arrival gain, no Shared Devotion, no
  arrival effect — and at its carried health.
- **The member key is `companions_standing`.** It was `beasts_standing` until the reconnaissance battery read
  `test_batch_bx` §4, which forbids *beast* in a string literal in `battle.gd` — the pre-check reproduced that red before
  the battery did.
- **A won fight erases the key**: the next fight's Beastmaster calls his own.

### 1d. Driven as real quits

A scratch driver, not in the tree, is GF's `drive_gf.gd` cut to plain fights: it plays a new run through the real
screens — main menu, draft, awakening, map — onto the first plain fight, fights it with the bot, and at the quit point
prints the live battle and the save, and kills its own process. **No game code hooks a window close, so a killed
process is a closed window.** A fresh process presses Continue on the real main menu and prints the battle **as
spawned**, before any turn. Each ran in an isolated copy whose `config/name` was renamed (*GH new*, *GH head*), on seed 7
(11 for the hero down). The party: Berserker, Cryomancer, Devout, Sharpshooter; Beastmaster for the two companion drives.

| Quit point | At the quit (disk) | Continue opened, as spawned | GG's code, the same quit |
|---|---|---|---|
| Full health, every enemy declared, nobody acted | 175/135/175/140, Mana 100/100/100 | the same, and the opening rolled again: turn order 0.41/0.54/0.45 → 0.46/0.51/0.98, the whelp's declared Frenzied Nip → Reckless Lunge | the same reroll |
| Low health, turn 8 | 170/129/160/127, Mana 75/75/77, Rage 35, Focus 40, seven statuses across the four, four cooldowns | 170/129/160/127, Mana 75/75/77; Rage 0, Focus 0, no status, no cooldown; the warband at full | 175/135/175/140, Mana 100 — **the fight's losses refunded** |
| …then fought four more turns and quit again | 170/121/160/127, Mana 72/75/74 | 170/121/160/127, Mana 72/75/74 — **nothing deducted twice** | — |
| A hero down (the Cryomancer set to 1 health in the fight, then killed) | Cryomancer 0 | **Cryomancer down**, the other three as they stood | Cryomancer back at 135/135 |
| A companion down (Canis set to 1 health, then killed) | no companion standing; the Beastmaster's Mana 80 | **no companion**; Mana 80 — the call's cost stays spent | Mana back at 100 |
| A companion standing (Canis set to 60% health) | Canis 48/80 standing | **Canis on the field at 48/80**, Elusive, no Loyalty | — |
| The Bomb used, then quit | bomb 0 | **bomb 0**, the slot kept at zero | bomb back at 1 |
| …then fought on and quit again | bomb 0 | **bomb 0** — not re-spent | — |
| The last hero falls (every hero set to 1 health before the step) | all four at 0 | the battle **opens decided**: THE HEROES HAVE FALLEN, the run summary, `Run.active` false, the save cleared; the main menu's Continue greyed | the four **alive at 1 health**, the fight restarted — lost again only because 1 health cannot survive it |

**The one hole, found by the companion-down drive and closed before the battery.** The first build brought Canis back at
**1 health** after it was killed on the quitting blow: the damage door reports below every refusal but **above**
`_die()`, so the killing blow saved Canis as standing at 0, and the spawn's floor lifted it to 1. That is the scum the
ruling names, at the grain of one blow. **A companion at zero is falling, not standing**: the bank skips it, and the
return refuses a record at 0. Re-driven: no companion.

## §2 — THE LAST-HERO EXPLOIT

### 2a. Where defeat is decided

**`battle._check_end`**, as `heroes.all(func(h): return h.dead)`, reached from six sites at HEAD: the end of every
unit's turn (the loop's last line), a unit killed by its own turn-start damage, a Ruin detonation killing its bearer, the
Bomb, the debug kill, and the sims' stalemate guard. **GH adds a seventh, the battle's opening (§2b).** **Nothing
revives a hero on its own** — `BattleUnit.revive` has two callers, the Revive Potion and Resurrection, both actions a
living hero takes — so the last fall is final the moment it lands.

### 2b. The window, and why a quit cannot land in it now

The last hero falls inside `_resolve` or a turn-start tick, and `_check_end` runs only once that turn is over. **The
fall now reaches the save inside the hit that deals it**: `take_hit` sets health to 0, runs the refusals, reports to BL's
door — which writes the save — and only then calls `_die()`. No frame passes between the fall and the write, so a quit
anywhere after the last fall leaves every hero at 0 on disk. **A resume then opens a battle with no hero standing, and
`_run_battle`'s first lines send it down the one path a wipe takes**: the profile books the wipe, the summary shows, the
save is cleared. Driven (§1d, the last row).

### 2c. Four dead heroes without that check

The brief asked what a restart into four dead heroes does. **Driven in a third copy with the opening check switched
off**: the battle opened with all four down, the first enemy took its turn, the loop's own `_check_end` called the wipe,
and the run ended on the same summary with the save cleared and Continue greyed. **Not a softlock.** The check is kept
because it decides the defeat before any enemy acts against a side with nobody on it.

## §3 — THE SAVE FORMAT DOES NOT MOVE

**No version.** What a fight writes is a member's `hp` (0 for a hero who fell), a Mana user's `mana` and `items` — all
v13 fields — and one member key, `companions_standing`, which rides the party dict the way `bm_equipped` and FK's two
banks do. `load_run` is untouched and the refusal threshold stays at 10. **A GF-era build reading such a save** clamps a
fallen hero to 1 health and fields no companion: a softer restart, not a misreading.

## §4 — THE INVERSE AND THE ESCAPE

### 4a. A second quit

Quit, resume, fight on, quit again, resume: **the second resume reads the second quit's health and pouch, and nothing is
deducted or spent twice** (§1d, both *"again"* rows). Every value is written absolute, so there is no delta to apply
twice. `check_gf` §2 asserts the same through the real screens — once through the ☰ and once as a closed window, each
quit carrying a loss of its own.

### 4b. What a quitter actually gets

- **From a quit before anything is lost: a free reroll of the opening.** Nothing carried because nothing was lost, and
  the turn order and the enemies' first declarations came back different — on GG's code and on this one alike.
- **From a quit on a losing fight:** the warband's losses reset against him; his own health, Mana, items, fallen hero and
  companion's health stay as they stood; and **his cooldowns, once-a-fight refusals and statuses clear**, with Rage and
  every meter back at nothing.

That is the finding the brief asked for: **the free retry of the whole fight is gone, and a retry of the opening
remains**. NEEDS A RULING, item 2.

### 4c. The win's inverse

GF's proof stands: `claim_reward` marks the encounter resolved before any victory's first save, and the bank writes
nothing once `battle_over` is set, so a victory's save — written after its heal — is never overwritten. The re-pointed
`check_gf` §4 reads it through the real screens.

## §5 — NOT DONE, AS RULED

- **Melted Armor and Caught Fast** stay in the glossary.
- **The end boss** is the next batch, with zone 1 drawing the Hollow Crown.
- **The Peddler and the forge** stay lost on a quit.
- **No merge work**, and no node, rune, magnitude or engine moved: `data/`, `scripts/talents.gd`, `scripts/classes.gd`
  and `scripts/unit.gd` are unchanged.

## FOUND AND NOT FIXED

- **An item is spent the moment it is pressed**, so a quit inside the target picker loses it; cancelling hands it back.
- **A loss reaches the save at once and a gain at the next door**, so a heal that lands after a turn's last loss is lost
  to a closed-window quit before the next turn boundary. The ☰ writes everything.
- **Two health losses at a turn's start pass no door** — Fortified Spirit's loan running out, and a companion's Bestial
  Wrath or Vigor fading. The next door writes them, and the restart's spawn clamps under a maximum without the loan, so
  neither can be refunded. A new turn-start loss without that clamp would owe a door.
- **A hero who fell plays the death animation as the restarted fight opens.**
- **`check_gf`'s health arms read the party at the instant `load_run` returns**, because the resumed fight writes the
  live member as it goes.

## VERIFICATION

### The saves

Backed up before anything ran, at `save-backups/GH-20260914-175644/` (not committed), and verified by hash. All four read
the same as GG's:

| file | md5 |
|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

All four read the same as the backup before each battery's launch and after its run — both batteries' freezes hash them
with the tree — and the acceptance battery's after-freeze reads the four hashes above.

### The parse floor

`check_parse` read **183 checks / 0 failures** after the first code edits, again after the companion fix, and again over
the final tree after the key rename, with every gate and document in place. Each time its stream carried no `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load`
line — read off the stream, never off the tally or the exit code. The count does not move: no file joined or left the
population it walks, and the drivers live outside the tree.

### The drives

Three isolated copies, each with its `config/name` renamed so its `user://` was never the player's: **GH new** (this
batch's code), **GH head** (GG's two scripts put back by `git show HEAD:`) and **GH ctl** (this batch's code with the
opening defeat check switched off). The driver and its runners are in the scratchpad, not the tree. Every pair was two
processes — the one that plays to the quit and kills itself, and a fresh one that presses Continue — and **no line of
either carried an error**. The readings are §1d's table, §2c's control and §4. The companion drives were re-run after
the key rename, with the same result under the new name.

### The gates, unmodified against the new code, and then re-pointed

- **Predicted before the reconnaissance battery ran**, from the unmodified gates read against the new code: `check_gf`
  red on its health-at-the-step arms; `check_dr` §1 red on `_do_summon`'s count of 3; `test_batch_bx` §4 red on the new
  key's string (the pre-check below reproduced it); `check_cm_live` at its sanctioned 13 / 4; `check_de` red on those
  three rows and nothing else.
- **The reconnaissance reading: the unmodified gates against the new code**, before any gate or document moved and before
  the key rename. It ran 109 targets, 18:13:54 → 19:00:40 (46 m 46 s), and `.ran` is one sequence of 109 names with no
  duplicate. **Five reds, every one predicted:**
  - `check_gf` 98 / 1 — *"§3: the fight did not restart from the party's health at the step"*;
  - `check_dr` 80 / 1 — *"`_do_summon` has 4 mentions in code, not 3 (its def, the `summon` special, Call the Wilds)"*;
  - `test_batch_bx` 156 / 1 — *"§4: no player-facing string still reads 'beast' (1: battle.gd: beasts_standing)"*;
  - `check_cm_live` 13 / 4, its four FAIL lines identical to GG's acceptance log byte for byte, and to the HEAD control;
  - `check_de` 453 checks / 3 failures / 0 notices — those three rows going redder, and nothing else.

  **`check_gf` read only one of its three health arms red, and that is why the re-point needed a precondition**: in
  §2's plain fight GF's two turns hurt nobody, so both of §2's arms passed under the carry and would have passed under
  the restart. Everything else read at its row: `test_batch_an` 6,054 and `test_batch_bk` 130 inside their bands,
  `check_fx` 496 / 0, `check_fh` 163 / 0, `check_parse` 183 / 0, `check_ct_map` 83 / 0, and the harness 22 / 382 / 8
  with no throws. No log carries a `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line. The tree and
  the four saves hashed identical before the launch and after the run (511 lines), and no Godot or battery process was in
  `ps` after it.
- **`check_gf` — re-pointed, 98 → 104.** Its three health arms after a mid-fight quit asked for the health at the step,
  which is the free retry the ruling closes. Each now asks for the health the quit left on disk, read the instant
  `load_run` returns, and gains its pair: the precondition that a loss reached the save before the quit
  (`_fight_until_hurt` fights until a hero is hurt, so the arm cannot pass on a quit with nothing lost) and the negative
  anchor that the step's health did not come back. `_clobber` sets the party's health to −7 before Continue, so only the
  disk can answer.
  - **Two drafts failed on the instrument, not the code, and both are recorded.** The first read the party after
    `_continue()`'s frames and read the resumed fight instead (104 / 2); the second stopped on a loss read off the disk,
    so on GG's code, which never writes one, it fought on to a win and cascaded (104 / 21).
  - **THE TWO-ARMED CONTROL, over the final gate in the isolated copies:** **104 / 0 on this batch's code**, and **104 /
    6 on GG's**, exactly the six new arms, at each of the three quits — *"no loss had reached the save"* and *"the quit
    handed back the health the fight took"*, with the step's `[175, 135, 175, 140]` coming back. Nothing else moved.
- **`check_dr` §1 — re-pointed, count 3 → 4, and its check count does not move (80).** The fourth mention is
  `_return_standing_beasts`, which fields again, at a restart, a body only a summon put on the field, so the axis the
  gate guards is still the Beastmaster's alone. 80 / 0 in the copy.
- **`test_batch_bx` — not edited.** Its §4 red was this batch's word, not a stale pin: the key was renamed and the suite
  reads 156 / 0 over the renamed code in the copy.
- **`check_cm_live` — the sanctioned red, with a HEAD control.** This batch changed the damage door that gate's driven
  blow passes, so its baseline row alone could not clear it. In the GH head copy it read **13 / 4, its four FAIL lines
  identical to GG's acceptance log byte for byte**; that log was copied out of GG's scratchpad and confirmed as GG's by
  its `check_de` 453 / 0 / 0 before it was compared.

### The retired-word pre-check

`test_batch_bx` §4 (*beast*) and §4b (*party*) were reproduced — string literals only, the same identifier strips, and
`master.html` read whole — over the thirteen scripts they read and the new `master.html`. **Before the battery it found
the one stray the battery then found**, `battle.gd: beasts_standing`. Over the landed tree — 17,306 string literals in the
thirteen scripts, and `master.html` whole — it finds neither word.

### The literal sweep

Every string literal of four or more characters in the 113 root `.gd` files — 13,262 distinct — was checked raw, lowered
and whitespace-flattened against HEAD's copy and the new copy of each edited file.

Run twice: over the code and the five documents as scratch copies during the reconnaissance battery, and over the
landed tree with the re-pointed gates' own needles in the population (13,266 distinct).

| Edited files | LOST | GAINED |
|---|---|---|
| `scripts/battle.gd`, `scripts/run_state.gd` | 0 | 3 |
| `check_gf.gd`, `check_dr.gd` | 0 | 16 |
| The five documents | 3 | 9 |

**Every holder was read, and none is a pin on the file that moved.**
- **The three LOST** are all `docs/state.md`'s, from GG's WHERE block and the retired queue item: *Builds with*
  (`test_batch_bt`, `bv`, `bw` assert it against `docs/master.html`, which still carries it), *Leave* (`check_fh`'s
  button prefix) and `_check_end` (a method three suites call).
- **The GAINED** are check_gf's own new messages and labels, method and property names (`_die`, `_beasts`,
  `companions`, `member`), node types (*fight*, *rest*, in a comment of `check_dr`), button labels (*Carry*), and words
  whose holders read the runes file, the logs or ability text (*LOST:*, *PASS*, *FREE*, *turn order*). *beast* gained in
  `run_state.gd` sits in a comment, which `test_batch_bx` §4 skips.
- **Sixteen gates walk every `.gd` in the tree** and so read the two re-pointed gates' source; the ones that inspect
  gate source are in the pre-pass below.

### The pin manifest

`build_pin_manifest.py --check` read the manifest **current, 1,464 pins**, with the code edits in and the documents not
yet moved, and **current again, 1,464 pins**, over the landed tree. `pin-manifest.json` is unchanged: `check_gf`'s new
arms are runtime checks rather than source pins, and `check_dr`'s moved figure is an integer the manifest cannot see.

### The pre-pass, and the batteries

- **The reconnaissance battery** is above, with the gates it read.
- **A pre-pass over the landed tree, before the acceptance battery**: every target that opens one of the five edited
  documents and does more than hold a needle in it, every gate that walks the tree's `.gd` files and inspects gate
  source, the two re-pointed gates and `test_batch_bx` — nineteen targets, each run alone in the real tree. **All
  nineteen read exactly at their `baselines.json` rows**, `check_gf` at its new 104 / 0, with no error line in any log:
  `check_dr` 80 / 0, `test_batch_bx` 156 / 0, `check_es` 57 / 0 (the one gate that reads `docs/state.md`'s content),
  `check_fs` 33, `check_el` 23, `check_fg` 22, `check_ec` 23, `check_ff` 55, `check_fr` 25, `check_eh` 175, `check_dv`
  83, `check_ed` 18, `check_ea` 86, `check_da` 43, `check_ek` 46, `check_fi` 27, `test_batch_ce` 1,114 and
  `test_batch_cd` 99, every one at 0 failures.
- **Acceptance: every target through `run_battery.sh` in the real tree**, over the finished tree with every document in
  place and nothing edited during it.
  - **Predicted before it ran:** every row at its `baselines.json` row, `check_gf` at its new 104 / 0, `check_de` 453 / 0
    / 0, and `check_cm_live` 13 / 4 with GG's four FAIL lines.
  - **The reading.** It ran 109 targets, 19:08:27 → 19:55:06 (46 m 39 s). `.ran` is one sequence of 109 names with no
    duplicate, in the reconnaissance battery's order. **`check_de` read 453 checks / 0 failures / 0 notices — the
    prediction, row for row**, `check_gf`'s new row among them.
  - **The rows quoted.** `check_gf` 104 / 0, `check_dr` 80 / 0, `test_batch_bx` 156 / 0, `check_es` 57 / 0,
    `check_parse` 183 / 0, `check_fx` 496 / 0, `check_fh` 163 / 0, `check_ct_map` 83 / 0 and `test_batch_ce` 1,114 / 0.
    `test_batch_an` read 6,050 and `test_batch_bk` 129, each inside its band, and the harness 22 / 382 / 8 with no
    throws.
  - **`check_cm_live` read 13 / 4, the sanctioned red, and its four FAIL lines are identical to GG's acceptance log byte
    for byte.**
  - **No error lines.** No `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line appears in any of the
    109 logs, nor in the reconnaissance battery's 109.
  - **The freeze.** Every file in the repo but `.git` and the `.godot` build cache — tracked, untracked and ignored — and
    the four player saves were hashed before the launch and after the run: **512 lines, identical byte for byte**. No
    Godot or battery process was in `ps` before the launch or after the run.
  - **One file was written after the run: this report.** Its acceptance figures went in after the after-freeze was
    taken, and no gate or suite reads `docs/reports/`.

### `CLAUDE.md`

**326,968 B (319.30 KiB)**, +3,613 B this batch, against the 340 KiB ceiling — 21,192 B under it. The changelog is
**327,899 B**, 72,101 B under its 400,000 B bar. `check_fg` read both in the acceptance battery, and puts `CLAUDE.md`
21,192 B (20.70 KiB) under its ceiling.

### The push

To `class-merge`, once this report's figures were in. `git ls-remote origin class-merge` is read against local HEAD after
the push and reported with the batch, because a commit cannot carry its own hash.

## THE FOLDERS THIS BATCH LEFT

Three scratch `user://` folders under `~/Library/Application Support/Godot/app_userdata/`: *Dawn of Decay GH new*, *GH
head* and *GH ctl*, one for each isolated copy the drives ran in. Nothing in the game reads them, and they are safe to
delete. The backup is at `save-backups/GH-20260914-175644/`, untracked like its predecessors.
