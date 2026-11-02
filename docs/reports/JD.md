# Batch JD — the fall repaired, the seven disposed

**On `class-merge`, after JC (`8a2a41a`, JC's commit, no follow-up). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `8a2a41a2`, JC's push and local HEAD, before anything ran (2026-11-01 10:35). **The designer's files were backed up first** (`../save-backups/JD-20261101-103548`, byte-identical to JC's backup by `diff -r`) and read only through copies — md5s at the open and the close, §6.

**What shipped.** **A fall stays inside its fight, and a hero who falls walks out at the floor**: the clearing heal passes him by, and so does every relic that adds to it. **All seven things the question priced are disposed**: the Cairn can be drawn after a fight that left a hero down, making each such hero whole; Cairnmoss Poultice back, lifting him; Martyr's Knucklebone's dead hook gone; the map's Revive Potion path gone; and the three crest runes handed to JE with the question named. **`_die()` runs once a body.** **No grade moved**: Ambushed at 8 ties JB's reading on both populations. The word's boundary stands beside its clause, and the divisor is a prior.

**Two findings matter most.** **The floor breeds falls, on a small scale**: on the same seeds with no modifier, falls rose 40 → 53 and 17 → 26, +0.18 ± 0.08 a run, the same hero falling again in the next fight more often, and three finishes in 120 were lost, each to a wipe in the fight after a hero was carried in, none gained (§5). *It is not a spiral* does not hold, the ruling stands, and that figure is the first ruling owed. **And the second call to `_die()` was not harmless to stop**: the blow on a corpse can Break it, the second pass was sweeping that Break, and `revive` does not clear `broken`, so a bare `if dead: return` would have raised a hero Broken (§3).

**Of §0's twenty rows, thirteen record a premise that did not hold as written, or a consequence it left out.** **Three bear on the ruling itself**: *which the readout already books* cannot be the Cairn's door; *a fall has a trace at last* is true of fewer falls than it sounds, and false past zone 1's and zone 2's bosses; and *it is not a spiral*. **Two of those I got wrong myself first**: my own draft said no zone boss leaves a trace, and that the table could not tell a spiral, and a reader outside the working read found both (§8). Each is changed the way I would recommend and said so; nothing was asked of the designer.

**Five things go beyond the brief**, each in §0 and FOUND AT JD: the words of three relics (*every standing hero*) and the framing card (*every hero standing*), because *every hero heals* went false; the Hourglass's Mana clause, rewritten with its heal so the card names whose percentage; the Cairn's *Lay your dead*, because nobody on the map is dead; the victory card's added sentence; and the map's Revive Potion joining `MAP_REFUSAL`, because deleting its path left a button that did nothing.

**THE VERDICT**: **SHIPPED, AND VERIFIED ON THE ACCEPTANCE. A fall stays inside its fight, a hero who falls walks out at the floor, the seven are disposed, and no grade moved.** The acceptance reads 170 targets, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout and `check_de` 697 / 0 / 0, with only the two carried reds, `check_gj`'s sanctioned §4 and `check_cm_live`'s 5 inside its band. All nineteen controls bit on the tree that lands. **Five rulings wait on you**, NEEDS A RULING below; each is already taken, and none holds anything up.

## §0 — THE BRIEF's PREMISES, VERIFIED (`CLAUDE.md`: verify the brief against the repo)

Read against `docs/state.md`, `docs/reports/JC.md`, the three tables and the code, before any edit. **Under the standing word nothing here went to the designer.**

| # | the brief says | verdict |
|---|---|---|
| 1 | §0.1: *one condition on one line* | **The line could not hold it.** By the time `heal_party` runs the floor has written his health, so the condition needs a fact nothing carried. It took a member key, its writer, a door both victory branches call (`heal_party` is also the debug menu's full heal, which must reach him) and the floor named as a constant. |
| 2 | §0.1: *a fall has a trace at last — he goes into the next fight at a fifth* | **True of a minority of falls where falls are common.** A fall in a lost fight has no next fight; a hero raised has none; `Run.advance_zone` runs only while `has_next_zone()` holds, so zone 1's and zone 2's bosses restore every hero (1 of 28, 11 of 118 and 13 of 118 heroes down at a won end on the reference four, 1 of 13 on the incumbent at Ruin); the third zone's boss has no descent, and carries him onto the end boss at the floor. Of all the reference four's falls, 68%, 32% and 30% reach a next fight at the floor at Wanderer, Warden and Ruin. **The Cairn had to follow**: read bare, the mark would deal it on a hero a zone had made whole, so the restore takes the mark. NEEDS A RULING 4. |
| 3 | §0.1: *his companions go in at 35% or better* | **False two ways, and a hair out in a third.** A companion is a Hunter's beast, which carries nothing between fights: the word that cost §0.5 its *kills* row, again. A third of the heroes down share the fight with another hero down, also at a fifth. And floor plus heal truncates to 34.55–35.0% at a spec's opening maximum: exactly 35 for the Warden, the Beastmaster and the Sharpshooter, under it for the other nine. |
| 3b | §0.1: *15% of one hero's maximum behind* | **The smallest case.** Each relic on the hook widens it: three carried, a hero who fell stands 45% behind a hero who ended at 1 health. |
| 3c | §0.1: *It is not a spiral* | **On a small scale it is** (§5). NEEDS A RULING 1. |
| 3d | §0.1: *a fall stays inside its fight* | **The name of the ruling, kept; the words are not what the ruling does.** Before JD a fall stayed inside its fight, which was the complaint. What stays inside now is the body at 0 health, and the health it cost outlasts the fight until a heal closes it. `CLAUDE.md`'s block opens by saying so. |
| 4 | §0.1: *nothing of the save, the events, the map screens or the death animation changes* | **One member key does**, on a hero left down, riding the party dict as `companions_standing` does: no save version moved. The brief itself asked for a key if none could do. The victory card gains a sentence, the framing card a word, the potion's map button a refusal, and a second death no longer replays the animation. |
| 5 | §0.2: *a hero fell in the last fight, which the readout already books* | **False as a door.** The readout is a read (`CLAUDE.md`, IF §1): off in every sim and harness, and on no save. It also counts a hero raised. **So the key is the door, and it means a hero still down when the fight ended.** NEEDS A RULING 3. |
| 6 | §0.2: *every relic that adds to it* and §4: *one lifts the hero who fell, the others lift everyone but him* | **True, and it made three cards false**: *Every hero heals* on the Chalice of Dawn, the Cracked Hourglass and the Knucklebone. Each reads *every standing hero* now, and the framing card *every hero standing*. The victory card adds *A hero left down does not.* |
| 7 | §0.2: the map potion's branch deleted | **True, and deleting it left a button.** With no branch the map could only answer *No one to use the Revive Potion on*. It joins `MAP_REFUSAL`, the Bomb's shape, so its button says why on hover. |
| 8 | §3: *Guard it* | **A bare guard is a defect.** §3. |
| 9 | §3: *two fights at Warden* | **True, and reproduced to the hero**: the Cryomancer and the Devout, on the same line, in 60 runs of the same road. |
| 10 | §3: *passes the Oathkeeper's bond* | **Not twice**: the first pass nulls `covenant_with`, so the second returns before the bond. |
| 11 | §4: *Weight 8 was set when the event could never be drawn* | **Weight 8 came with the event at Batch 38.** I did not read further; nothing turns on it. |
| 12 | §4's Cairn: its words | **One line did not survive the re-cut**: *Lay your dead upon the stones*, with nobody dead on the map. It reads *Lay your fallen*. The rest stand. |
| 13 | §7: *the 438 pins stay pinned* | **437.** The floor's pin held the bare literal, and R01 wants it behind a constant, so the one pin went with the literal. |
| 14 | §6: 18.02 KiB under, 33.86 under; +5,233 B; 8,776 B against 6,712 B | **True to the digit.** `CLAUDE.md` read 18.02 KiB of room at the open, so the under-15 clause did not fire there; it fires at the close, §6. |
| 15 | §0.1, §0.2, §0.4, §5: the figures | **True to the digit**: 0.023, 0.31, 0.55, 8 and 1 of 60; 287 of 290; 0 of 3,957; ×1.5 to ×3.8, ×2.3 to ×2.8, ×1.64; 6.71, 10.01, 14.21 against 6.67, 9.03, 15.47; 3.86 against 2.09; +6.67 ± 0.67 (0.6750 in the table). |
| 16 | the push check | **True**: `8a2a41a2`, JC's commit, no follow-up taken. |
| 17 | §7: the grades row at 399 B | **True**: JD touches the block and not the row. |

## THE RULINGS, AND WHERE EACH IS WRITTEN

- **§0.1 — A FALL STAYS INSIDE ITS FIGHT**: a block of its own in `CLAUDE.md`, beside the quit's, holding the ruling, the reasons in the order that decided it, what the map can ask and where the trace stops.
- **§0.2 — THE SEVEN**: §2, §3 and §4 build them; THE CREST POOL names JE's question.
- **§0.3 — THE WORD REMOVES THE QUESTION, NOT THE RULING**: `CLAUDE.md`'s *Working agreement*, directly under the clause. **No word of the clause moved.** Its note says JC's NEEDS A RULING *asks*; the paragraph under it is the answer, and the note stands as the record.
- **§0.4 — THE DIVISOR IS A PRIOR**: `CLAUDE.md`'s ladder block, directly after the sentence it corrects, and `docs/state.md`'s census block.
- **§0.5 — THE *KILLS* ROW**: `docs/reports/JA-shares.tsv` and the state's copy of the row, nothing else of the census.

## §1 — THE DOCUMENTS

**`master.html` stops being wrong rather than starting to be, as the brief expected.** Every living statement of the figure, read:

| where | says | |
|---|---|---|
| `docs/master.html`, *Fallen heroes return after a won battle at 20% max HP* | the floor | **already right**, and now true |
| `docs/master.html`, the hero's draft, *returns the fallen at 20% of maximum* | the floor | **already right** |
| `data/glossary.json`, `fallen` | *at least 20%* | **already right**; now reads the constant, and says the heal passes them by |
| `docs/state.md`, THE CREST POOL, *the fifth every victory writes* | the floor | right, and the block is rewritten |
| `docs/state.md`, JC's ruling and FOUND AT JC, *35%* | what the code did | archived with what closed them |
| `docs/master.html`, *heals every hero 15%*, twice | **wrong in the other direction** once §2 lands | **repaired**, and the first of the two was FR's *the every hero* |
| the three relics and the framing card, *every hero heals* | **the same** | **repaired**, and each relic now names whose percentage; the framing card does not, being a character over its widest already, and the LOOK-LIST says so |
| `CLAUDE.md`'s HP bullet, *still open* | a ruling owed | **repaired** |

**And one count moved with the reads**: `master.html`'s *22 in all, and three of the hooks* reads 24 and four, and its *at all 22 read sites* no longer carries a count. **`check_jd` §1 holds the sweep**: twelve living files and no sentence holding *35%* with a verb of a fall, beside the arms that read the floor stated; C04 and H02 redden it from both sides. **It is a regex on that figure**, so *a third* or *above the floor* would pass it, and the changelog and the notes are outside it. **`master.html`'s *every equipped relic reaches every hero* went false with §2 and is repaired**; the glossary's *effects that pay every hero* is the layer's shape and stands.

## §2 — THE REPAIR

**THE DOOR, AND WHY.** Five doors were read. **His health** cannot: the floor has already written it. **The battle's bodies** could, but both victory branches would each carry the loop, and BJ §1 made the return one implementation for exactly that reason. **The readout** cannot (premise 5). **Running the heal before the floor** would leave `hp > 0` true to its word, and it splits the one return in two, at two callers, and the Cairn would still have nothing to read on the map. **So a member key, `BattleUnit.FELL_LAST_FIGHT`**: written in `sync_victory_state`, the one line both victory branches pass through; gone rather than false, so a fight nobody fell in leaves a member's keys as they were; riding the party dict, so no save version moved; sorted in `check_is` §2; read by `Run.clearing_heal` and the Cairn. **Its name is looser than what it means**: `fell_last_fight` is true of a hero down when the fight ended, and a hero raised inside it fell and carries no key. It names no batch, which is half of §0.1's order; a rename would touch the save key and two gates, so it stands, and FOUND AT JD says so.

**`Run.clearing_heal` is the door both branches call**, and it reads `victory_heal_pct` itself, so they cannot pass it different figures. `heal_party(pct)` with no second argument is unchanged: the debug menu's *Full Heal Standing Heroes* reaches him, and it should.

**THE ARMS, ON A REAL BOARD** (`check_jd` §2): a real fight, the Mage down through the damage door, the Cleric at 1 health, the other two at half, won through `_check_end`.

| arm | reads |
|---|---|
| a hero who fell | the floor |
| a hero at 1 health | the floor plus the clearing heal |
| the other two | their health plus the heal, which is what makes *it did not reach him* a reading |
| every relic on `victory_heal_pct`, derived off the pool, and all three at once | the second hero and not the first |
| Cairnmoss, alone and beside the Chalice | the hero who fell takes what everyone takes |
| a hero raised inside the fight by the potion | the heal reaches him, no mark |
| the mark | through the save, off at the next fight he stands through |
| the descent, through the victory card's own button | zone 1's restores him and takes the mark; the third zone's does neither |
| the next fight's spawn | opens him at the floor: [114, 27, 52, 104] on the board |

**The prediction**: **none was written as a file before §2's first `check_jd` run**, which §8 asks for. The gate's arms say what each expects, and the drive read as they wrote, but an assertion written to pass is not a prediction. The step was not taken.

## §3 — `_die()`'s MISSING GUARD

**THE ROAD** (read off a backtrace on JC's own road, a read-only probe, 60 runs, `JD-work/s1/PREDICT_DEATHS.md`, md5 `bf6fb3e2…`). A Sacred Resolve splits a blow across the souls. A hero's share under the Oathkeeper's bond passes half on to the partner, and when the partner is the struck hero that half arrives as a tick and fells him mid-strike. The strike then lands on the corpse with its own share. So `take_hit` meets a body at 0 and calls `_die()` again. **Both of JC's are this road**: the Cryomancer and the Devout.

**WHAT THE SECOND CALL HAD BEEN DOING, LINE BY LINE:**

| line of `_die()` | on the second pass |
|---|---|
| `dead`, Broken's three fields | **it was sweeping.** The blow on the corpse had just Broken it (*!! Cryomancer BREAKS*, +99 BD, `statuses=1`), and this cleared `broken`, `broken_pending` and the chip. **Load-bearing, and on no record.** |
| Unrelenting's Constitution, the Burn snapshot | nothing: the statuses went on the first pass |
| `died_cb` → `_on_unit_died` | a hero: **a second `fell` in the player's readout**, which is what JC's table dropped; `_reread_live` read the same who-stands and logged nothing; the bond returned at its null. **An enemy: a second kill for the Reaver**, had one ever died twice; none did in 60 runs, nor in §5's 240 |
| the compositions, the clears, the plate | idempotent |
| `play_anim("death")` | the animation again |

**So it was harmless to the hero's rules and harmful to the readout, and it was hiding a defect.** `revive` clears `pressure` and not `broken`, so with a bare guard the corpse keeps the Break, and a raise brings him back Broken with a turn owed. **`take_hit`'s Break block reads `and not dead` now**, which is the second half of the guard. C05b is that line alone.

**What the strike books did not move, and that is deliberate**: `take_hit` still returns `died: dead`, so the strike's own *† dies* and `hero_deaths` still fire. On this road that is the only booking the death gets, because `_on_covenant_share` books none (FOUND AT JD).

**Two predictions of mine were wrong** (`PREDICT_DEATHS`): I bet 2 in 3 the second door was the tick and it was the blow, and 2 in 3 on enemies dying twice, at least five, and none did.

## §4 — THE FOUR DISPOSITIONS

**THE CAIRN.** `requires: {fell_last_fight: true}`; its boon is `heal_pct` at 1.0 on a new target selector, `fell`, every hero the last fight left down and no other. Weight 8 stands.

**ITS SECOND CHOICE, *CARRY THEM ONWARD*: IT COSTS NOTHING.** `effects: []`, a plain decline, and it was strictly the worse choice before the re-cut too. The re-cut does not make it incoherent, so it stands.

**THE POOL, WITH THE CAIRN DRAWABLE.** The kind is drawn first, at 60 / 25 / 15, and the weight inside the kind picks the entry, so the Cairn competes only with the boons.

| boons eligible | total weight | the Cairn among boons | the Cairn of a draw | at weight 12 |
|---|---|---|---|---|
| zone 2, no `mystic` in the party (6) | 60 | 13.3% | **3.33%** | 4.69% |
| zones 1 and 3, no `mystic` (7) | 70 | 11.4% | **2.86%** | 4.05% |
| zone 2, a `mystic` (7) | 68 | 11.8% | **2.94%** | 4.17% |
| zones 1 and 3, a `mystic` (8) | 78 | 10.3% | **2.56%** | 3.66% |

*(Every boon: Waystone Cache 12, Abandoned Wagon 12, Forest Spring 10 in zones 1 and 3, Deserters' Stash 10, Mushroom Ring 10, the Old Trapper 8 with a Survivalist, the Arcane Obelisk 8 with a Mage's three, the Cairn 8.)*

**Read off the sim: it was drawn 3 times in §5's 240 runs, all 3 on the reference four under Ambushed** (177 fights won with a hero down), none on the incumbent under Ambushed, which won 204 such fights, and not once on any *none* arm: three on one arm is the small count, not a rate. A run sees about 4.1 to 5 events. **So 8 is a very rare beat at the rates a run finishes on**; the weight is yours (NEEDS A RULING 5). The event is first-choice for the bot, so it heals in a sim.

**CAIRNMOSS POULTICE AND THE KNUCKLEBONE NOW DO DIFFERENT THINGS.** Cairnmoss lifts the hero left down and nobody else; it adds no figure. The Knucklebone, the Chalice and the Hourglass lift everyone but him. `Relics.is_suspended` stands with nothing in it (FOUND AT JD), and the player's unlock of Cairnmoss was kept all along, so it is on the designer's shelf again.

**THE KNUCKLEBONE's `rest_heal_add`** is deleted from the two entries that held it and the header; nothing read it. **THE MAP's REVIVE POTION**: `wants_dead` and the `"revive"` arm are gone, and the battle's is untouched, driven in `check_jd` §4c at its 50%.

## §5 — DOES ANY GRADE MOVE?

**NO. A TIE ON BOTH POPULATIONS** (`docs/reports/JD-arm.tsv`; prediction `s1/PREDICT_S5.md`, md5 `e0fc4acb…`; each arm paired by seed against this tree's own re-driven *none*, IX's pairing and IW's reading unchanged; 0 Parse Error or SCRIPT ERROR).

| population | *none* | Ambushed at 8 | JB's | the difference | |
|---|---|---|---|---|---|
| the reference four, Wanderer, 60 runs | 0.939106 ± 0.004538, 55 finish | **+7.23 ± 0.77**, z 9.37, 46 finish | +6.67 ± 0.67, 50 finish | +0.56 ± 1.03 | **tie** |
| the incumbent, Ruin, 60 runs | 0.951564 ± 0.004585, 58 finish | **+12.34 ± 1.46**, z 8.47, 32 finish | +12.02 ± 1.20, 36 finish | +0.32 ± 1.89 | **tie** |

**Both rise, by about half an error of the difference on the reference and a sixth on the incumbent.** Both *none* arms are a tie with JB's too (0.939501, 0.953368). **So the grades stand. That tie cannot see the rest of this section**: it reads Ambushed against a *none* on the same tree, so it subtracts what the floor does to both.

**One thing the brief wants named**: the incumbent's reading prints **0.12 over the 12.22 cut to 5**. It sat 0.20 under it. The move is well inside the test, so nothing changed, and no grade moved; but a tie at a cut can land either side, and this one has now landed on both. NEEDS A RULING 2.

**THE SECOND READ: THE FLOOR BREEDS FALLS, ON A SMALL SCALE** (`JD-work/tools/jd_spiral.py`, the fight-by-fight `[JCF]` lines of JC's logs and JD's, the same seeds, no modifier; the first reader found it and I reproduced every figure below independently).

| | the reference four, Wanderer | the incumbent, Ruin |
|---|---|---|
| falls, HEAD → JD | 40 → **53** | 17 → **26** |
| the same hero falls again in the next fight | 10 of 27 → **15 of 30** | 1 of 12 → **7 of 17** |
| runs finished | 57 → **55** | 59 → **58** |

**Paired over the 120 runs: +0.18 ± 0.08 falls a run, z 2.26, up in 11 and down in 1.** **All three lost finishes are the same story**: a won fight leaves a hero down, and on JD's tree the next fight is a wipe, where on HEAD's it was won (3800147 and 3800156 on the reference, 2100076 on the incumbent). None went the other way. **Completions fell on every arm of §5**, 202 to 191 of 240. **The caveats are real**: it is the bot, which never drinks on the map, where a Health Potion answers most of this; the counts are small; three runs in 120 is no collapse. **But *not a spiral* is a claim of absence, and this is a small spiral with its mechanism in view: a floor, a fall, no heal, a wipe.** The brief's third reason against a lasting fall was that falls would breed falls, and the one-fight version measures the same shape, so the reason separates the two rulings in degree and not in kind. **The ruling stands as written.** NEEDS A RULING 1.

**THE THIRD BOSS.** On JD's tree, a hero carried from the third zone's boss into the end boss: 3 of 55 on the reference four, 3 of 58 on the incumbent, no loss; under Ambushed 4 of 46 and **18 of 37 on the incumbent, where all five end-boss losses are among those 18** (0 of 19 clean), a small count on parties the third boss had already marked.

**The drive's tree** was this tree's rule, with the floor still the bare literal and the comments earlier; `RETURN_FLOOR_PCT` is that literal renamed. **The first job was handed a clone** (§6); the clone is the tree, by `diff`.

**The prediction**: every line right. The 2-in-5 that the incumbent would print over the cut landed. **What it left out is the finding**: *a hero entering 15% short falls a little more* is all I wrote of the floor's cost, and the spiral came from a reader.

## §6 — HOUSEKEEPING

- **THE MOVE WAS NOT ATTEMPTED** (IB §4). `./lane.sh spent` prints the one clearing command, and **it does not hold the eight folders below**.
- **USER-DATA FOLDERS: 611 AT THE OPEN, 619 AT THE CLOSE. JC ADDED NONE AND JD ADDED EIGHT, MY FAULT.** I took JC's lane names from its report's prose, which drops the project's prefix (*IC work* for *Dawn of Decay IC work*), and read past the `LANE NOTE` `lane.sh make` printed. *IA pre1, IC work, IE probeA1, IE probeA1 2, IE probeA2, IE probeA3, IG p1, IG p2* hold nothing of yours; every launch went through `lane.sh`, so the fault is the names and not a launch around it. They stand outside the spent patterns, and recon 1 found `check_iu` §7 red on them, as it should be. **They are named in `KNOWN_STRAYS`, each with how it came, IT's precedent. A wider pattern (`I[A-J] *`) would have been one line and would have silenced that alarm for the next bare launch.** Every later lane carries the prefix, and the count did not move again. To clear them:

```bash
cd "$HOME/Library/Application Support/Godot/app_userdata" && mkdir -p "$HOME/.Trash/DoD JD folders" && mv "IA pre1" "IC work" "IE probeA1" "IE probeA1 2" "IE probeA2" "IE probeA3" "IG p1" "IG p2" "$HOME/.Trash/DoD JD folders/"
```

  `check_iu` then prints a notice for each one gone, and a later batch deletes its row.
- **`lane.sh` for every launch, one process a lane, every drive job on a lane of its own: held but once.** I `rm -rf`ed `lanes/d1` while a log pass still ran in it, so §5's first job was handed a clone (`d1-2`); the clone is the tree by `diff`, the reading stands, and the stray was killed wrapper first.
- **MY WAIT ON RECON 1 COST SIX HOURS.** Recon 1 ended at 12:45. The watcher's condition held `pgrep -f "run_battery.sh"`, which matches its own command line, so it could never exit, and I read nothing until you said so at 18:59. That pattern has been banned in my own notes since FT. **No reading depended on it**: the run was complete and its logs were read whole. Every wait after it reads the runner's DONE line and carries a time bound.
- **The designer's files were backed up first and read only through copies.** **All seven md5s at the open**: `run_save.bin` fcb20c91…, `profile.json` 608d89c0…, `relics.json` fdc12ffa…, `settings.cfg` 0c1b39c3…, `latest.txt` e43f2d0a…, and the two readout files, `run-20261014` 2b0f0212… and `run-20261018` 610bcd8c…. **All seven read the same at the close**, through a fresh copy at 22:51, and `readout/` holds the same three files. **Still the one run, still 18 October, and it is the oldest row on the LOOK-LIST.**
- **`DOD_SUITE_TIMEOUT=480` stays an override**, the 240 s default retained. No timeout at either recon or the acceptance, and at the acceptance the slowest line under that bound read 135 s, `test_batch_bk`, by the logs' timestamps. The four lines with bounds of their own read inside them: `check_gv` 596 s of 1,200, `check_fx` 365 of 720, `check_map` 241 of 600, `check_gp` 235 of 480.
- **BOTH CEILINGS, AND `CLAUDE.md` IS THE NEARER.** `CLAUDE.md` 503,783 → 507,328 B (+3,545 B, nothing cut): 495.44 of 510 KiB, **14.56 KiB under**, 2.8 batches at JC's +5,233 B and 1.8 at EZ's record of 8,293 B. `docs/state.md` 354,446 → 354,543 B (+97 B net): 346.23 of 380 KiB, **33.77 KiB under**. The archive took 7,506 B and JD wrote 7,603 B, 46 B inside the index's fence and **7,557 B outside it, over the 6,712 B of IT's honest rate**. The room is 5.2 batches at that rate and 3.9 at JC's 8,776 B.
- **`CLAUDE.md` READ 18.02 KiB OF ROOM AT THE OPEN, SO THE BRIEF's CLAUSE DID NOT FIRE THERE. IT CLOSES UNDER 15, SO I NAME WHAT IN IT IS CLOSED, AND CUT NOTHING.** `## HERO AND ALLY ARE THE ONLY TWO WORDS`, closed at DM §3 (6,051 B); `## THE ALLY/HERO THREAD IS CLOSED` (896 B); and four struck lines already reduced to a pointer (721 B together). Those two blocks are the nearest whole blocks II §4's rule could move, and the first of them is live card law, so it would want a reference that keeps it read.
- **The close's own timestamp: 2026-11-01 22:58 PST.**

## §7 — WHAT IS DELIBERATELY NOT DONE

The three crest runes not re-priced and not touched, JE's; no modifier authored, removed, re-keyed or re-valued, no grade moved, the deck closed at twenty-five; nothing puts a hero on the map at 0 health, `_lay_down_the_fallen` and the resumed fight stand as JC found them, and so does the death animation, but for the replay §3's guard ended; the readout unchanged; `master.html`'s *at 20%* not rewritten; the census not re-taken, its *kills* row's words alone; the divisor not driven and Porous's fifth unexplained; `OUTPACED_SPAN` not driven, Watchtower given no writer, `check_io` §5 thin; IX's absorption reading read, not proved; `check_hk`'s band; the latent offer defect; the CX item naming enemy cooldowns; `check_ht` §2's 45 bodies; `CLAUDE.md` not indexed, the 188 cheap gates, the thirteen picks, `check_it` §2c, `check_hn` §2a, the Chilled row's *4*, the latent floor shapes and the Cryomancer's route; nothing of the playthrough; the standing list. **The one in that list that moved is the pins, 438 → 437** (premise 13).

## FOUND AT JD AND NOT FIXED

- **`revive_pct` AND `fallen_hero` HAVE NO USER LEFT** (§4): the Cairn was the only event that named either, and §0.1 means neither can ever fire. §7 leaves the events as they stood, so both stand; the recommended next step is deleting both, on §0.2's own *delete dead code rather than prop up a feature to justify it*.
- **`Relics.is_suspended` STANDS WITH NOTHING IN IT** (§4): the door and its four readers stay for the next relic that loses its hook. `POOL` is a `const`, so `check_ik` §6 can no longer drive a suspended relic; it holds Cairnmoss in where it held it out.
- **A STRIKE LANDS ON A CORPSE ITS OWN BOND FELLED** (§3): no Break and no second callback now, but the log prints its damage line on a hero already down. `battle._resolve` could stop there; not asked.
- **AN OATH DEATH IS BOOKED ONLY BY THE BLOW THAT FOLLOWS IT** (§3): `_on_covenant_share` books no `hero_deaths`, so a hero the oath fells outside a strike is on no tally. The sim's stat, not a grade.
- **THE MARK AND THE READOUT's `fell` ARE TWO COUNTS UNDER ONE WORD** (§2): a hero down at the end, and a hero who went down, 3 of 290 apart in JC's table. The key's own name is as loose: `fell_last_fight` is false of a hero who fell and was raised.
- **`FOUND AT IJ`'s *the potions on the map* COULD NOT BE SETTLED**: IJ's report names no row for it, and JD rewrote that passage of `master.html`, so it may be closed. Nothing turns on it.
- **WHAT WENT BEYOND THE BRIEF, AND THE SMALLER DEPARTURES** (§0): the five above, and two rows that made no difference: the bond is not passed twice, and weight 8 came with the event.
- **EIGHT USER-DATA FOLDERS OF MINE** (§6).

## NEEDS A RULING

1. **THE FLOOR BREEDS FALLS, ON A SMALL SCALE (§5).** +0.18 ± 0.08 falls a run on the same seeds, the same hero falling again more often, three finishes in 120 lost, each to a wipe in the fight after a hero was carried in, and none gained. **Taken**: the ruling stands as written; the tie says the grades stand and cannot see this. **The alternative**: a floor nearer the clearing heal, or the bot taught to drink on the map so the figure reads what a player does. **Reversing it** is `RETURN_FLOOR_PCT`, one constant.
2. **AMBUSHED's INCUMBENT READING PRINTS OVER THE CUT TO 5, INSIDE THE TEST (§5).** +12.34 ± 1.46, a tie with JB's +12.02 and 0.12 over 12.22. **Taken**: no grade moved, as the brief orders; a tie at a cut is named, not resolved upward. **The alternative**: read a floor that lasts one fight as moving the deck, and re-grade. **Reversing it** is one sharper arm on the incumbent and the arithmetic.
3. **A HERO RAISED INSIDE THE FIGHT TAKES THE CLEARING HEAL, AND THE CAIRN IS NOT DRAWN FOR HIM (§2).** **Taken**: the mark names a hero down when the fight ended, because *a hero who falls walks out at the floor* cannot be true of one who stood up at 50%, and a raise is the answer to a fall. The brief's *which the readout already books* counts him. **The alternative**: mark any fall, at `_die()`. **Reversing it** is one line there, and a second reading in `heal_party` if the heal should pass him by too.
4. **TWO ZONE BOSSES LEAVE NO TRACE, AND THE THIRD CARRIES HIM ONTO THE END BOSS AT THE FLOOR (§0, premise 2).** **Taken**: each stands as the code has it, and the mark goes with the wound. Nobody ruled on the third; it is the fight where the penalty is largest. **The alternative**: a restore at the third boss, or none at the first two. **Reversing either** is one condition.
5. **WHETHER THE CAIRN's WEIGHT OF 8 IS RIGHT (§4).** **Taken**: unchanged, as ordered. 2.6% to 3.3% of a draw, drawn 3 times in 240 runs, and only under Ambushed. **Reversing it** is one number in `data/events.json`.

## §8 — VERIFICATION

**THE ORDER, AND WHERE IT LEFT §8's.** The routing first (10:36), before any edit; §2's door before the code, and of §4's two read-outs the Cairn's second choice (read at 10:36: `effects: []`); the code and its parse; **the pool's weights I printed only at 11:13, after the code**: they are `data/events.json`'s and the code moved none, but §8 put that read first; §5's drive with its prediction; the literal sweep before recon 1's prediction; recon 1 alone (11:19 to 12:45). **The documents as scratch copies, the close-read and the first outside reader came during recon 1, and the close-read before the pre-run**, as JC's did: I wanted a reader on my new text before spending a pre-run on it, and that reader changed what the ruling's block says. Then the pre-runs, recon 2, the controls and the acceptance in §8's order. **The positional re-run was taken on the tree of pre-run 1 and re-derived on the tree that lands**, so it did not wait for recon 2's end. **§2's drive had no prediction written as a file before it**, which §8 asks for; below.

**THE PREDICTIONS, GRADED.**

| | written before | right | wrong |
|---|---|---|---|
| §3's second death, `s1/PREDICT_DEATHS.md`, md5 `bf6fb3e2…` | the 60 runs | it reappears, on heroes | **The road and the bodies**: I bet on a tick's own door and on enemies. It is a strike on a body its bond felled, and no enemy in 60 runs |
| §2's repair | **nothing** | | **No file preceded §2's first `check_jd` run.** The arms state what each expects, and the drive read as they wrote, but an assertion written to pass is not a prediction. A step of the brief not taken |
| §5, `s1/PREDICT_S5.md`, md5 `e0fc4acb…` | the drive | every line, the 2-in-5 that the incumbent would print over the cut among them | **What it left out**: *a hero entering 15% short falls a little more* is all it says of the floor's cost. The spiral came from a reader |
| recon 1, `s1/PREDICT_R1.md`, md5 `cf8e3c09…` | the launch | 169 targets, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout, `check_gj` 70 / 1 (+155 / 175), `check_cm_live` 13 / 5, `check_ik` 241, `check_jc` 70 / 0, `check_is` 96 / 0, the five bets on a drive unspent, 86 minutes | **Three reds not named, and `check_de`'s four with them**: `check_ed` ×2 (a needle I re-pointed and a manifest owed), `check_hx` ×2 (`rest_heal_add` still in HEAD's `CLAUDE.md`, the tree's documents being HEAD's), `check_iu` ×1 (my eight folders). And `check_ij` 49, where I wrote 50 |
| pre-run 1, `s1/PREDICT_PRE.md`, md5 `da4d8249…` | the launch | `check_jd`, `check_ik`, `check_ed`, `check_it`, `check_jc`, `check_fg`, `check_parse`, 0 errors | **Five reds not named**, each in text written after recon 1: below |
| pre-run 2, `s1/PREDICT_PRE2.md` | the launch | every row; the 1-in-6 went unspent | none |
| recon 2, `s1/PREDICT_R2.md`, md5 `0882825b…` | the launch | 170 targets, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout, the two carried reds, every row and band, `check_de`'s count of 697, 87 minutes | ***`check_de` green***: 697 / 1, `check_ik`'s row, which recon 1 had printed and I had graded past |
| pre-run 3, `s1/PREDICT_PRE3.md`, md5 `2a6db76a…` | the launch | every row, and the standalone `check_de` 697 / 0 / 0; both bets went unspent | none |
| the controls, `s1/PREDICT_CTL.md`, md5 `7fda1943…` | the launch | every wanted line bit, every must-hold line held, 0 throws; every bet on a line not biting went unspent | **The time**: I wrote 50 minutes and it took two |
| the acceptance, `s1/PREDICT_ACC.md`, md5 `7f1cf897…` | the launch | every row and every band, `test_batch_bk` 131 and `check_hk` 168 at the tops of theirs; the two carried reds and no third, the 1-in-12 unspent; 87 minutes; the seven md5s; 619 folders | none |
| the report's landing, `s1/PREDICT_REP.md`, md5 `a791a405…` | the launch | each of the thirteen at the acceptance's count, 0 reds; 162 codes on both, *CW to JD*; the 1-in-12 unspent | none |

**HEAD's gates on the new code** (FA §1b), before any re-point: `check_ij` 1, `check_ik` 6, `check_jc` 2, `check_is` 0: nine reds, each an arm the ruling reverses (`logs/hg`).

**THE LITERAL SWEEPS.** **Before recon 1's prediction**, on the code: its LOST rows each walked (`logs/litsweep_r1.tsv`). **On the finished tree**: 28 LOST at first, each walked to its holder. **One was real, and it took a sweep to see it**: `check_it` row 45 ends its window at *BREAK IS*, and my block now stands between; the row is re-pointed, its question unmoved, and the sweep then read 26,721 literals, 31 files, 27 LOST, 1,144 GAINED, 1,119 MOVED. Of the 27, 13 are absence needles of my own in `check_jd` or words `check_jc` and `check_ij` read in other files (the sentence `check_jc` §4 wants is in the archive, by `grep`), and 14 are common words other gates hold about other files, or a lane's name. GAINED is `check_jd` joining.

**THE DOCUMENTS, SCRATCH COPIES BEHIND A HASH GUARD.** Every edit is a script replayed from clean HEAD (`JD-work/edits/rebuild.sh`, each anchor asserted once), never run on the repository.

**PRE-RUN 1** (the final tree, 43 targets, 19:09 to 19:22: the gates that open `docs/state.md`, JC's list and the gate-source readers a new gate meets; the tree unmoved). **Five reds, all in words I wrote after recon 1, and none named in the prediction:**

- `check_hx` §1d, twice: `CLAUDE.md` backticked `docs/reports/JD.md`, which lands after the acceptance. It reads *JD's report* now.
- `check_ij` §2e: a repair of a false relic sentence is held by its ending, *every victory.*, and my rewording for the reader dropped it. Both relics read *Every standing hero heals N% of maximum health after every victory.*
- `check_is` §5: closing FR's master half left its index row two triggers, under the floor of three. It takes a third.
- `check_iu` §2: a new block in `CLAUDE.md` has no census row, so its rules were never read against a gate. Six rows, `JD-001` to `JD-006`, five HELD by `check_jd` and one NONE, the 188 cheap gates unmoved.
- `check_iu` §8: one bullet of my close-read list said neither ROUTED nor NOT ROUTED.

**PRE-RUN 2** (the repaired tree, the same 43, 19:25 to 19:38): all green, the tree unmoved, `check_de` left to the recon, as a pre-run cannot read it.

**THE CLOSE-READ** (the routing record's third list): 65 unrouted blocks, 168,393 B, read whole by a reader outside the working read, and 71 of the 80 routed. **Sixty bear on nothing; five bore**: four routed, one not, whose row took triggers. **It found ten statements of `docs/state.md` false or stale after my edits**, the heaviest the grades block's silence about what the ruling did to its population; each was repaired before the tree was frozen.

**THE FIRST OUTSIDE READER, ON MY OWN TEXT** (`report/reader1_findings.md`, read-only, given the tree and the logs): fourteen findings, each checked at source. **Two changed the batch.** It read my claim that a zone boss leaves no trace against `advance_zone` and found the third zone's boss has no descent, and it read *it is not a spiral* against JD's own per-fight lines and found the same hero falling again more often. I reproduced both with a tool of my own (`tools/jd_spiral.py`) to the digit before writing either. **`check_jd` had called `advance_zone()` directly, so it could not see the gate in front of it**; it presses the card's own `_next_zone` now. The rest were clauses of the designer's sentence, figures of mine (*10–12%*, *4 of 13*), and words like *him alone* and *is drawn*; §0's table carries them.

**THE POSITIONAL AND SUPERLATIVE RE-RUN** (IT's census of 489 reads, re-derived against the tree that lands; JC's tools, one new): **every one of the 489 settled: 327 SAME, 38 LINE-SHIFT, 32 IN-PLACE, 0 OFF-SUBJECT, 0 UNPORTED, and 92 unchanged by construction. No verdict moved, and the thirteen standing MISSES still miss.** 251 reads left the hunk and strict passes, most of them one common word on a line I changed (*heroes* on the victory card's line, 123 reads, and it stands on that line at HEAD too). **So I added a pass, `tools/pos_seq.py`: a find lands on an occurrence, and edits that keep lines in order keep occurrences in order, so a read whose flagged needles occur the same number of times on both sides, with no occurrence on a line added or removed outright, cannot have moved.** It cleared 152 and never clears a read of a newest or stamped place. **It is a new instrument and it has had no control of its own**; what stands behind it is that the 99 it left are the ones a reader would pick. The reader (a subagent outside the working read, `JD-work/route/positional_jd.tsv`, 99 rows) settled 37 SAME, 32 IN-PLACE and 30 LINE-SHIFT, emulating each selection on both trees and matching the live logs where it could; eight runtime rows it cleared from their writers, each marked. It read the tree of pre-run 1; the repairs touched words, and the passes on the tree that lands sent the same 99 and no other, so I did not send them back.

**RECON 2** (the tree of pre-run 2, alone, 19:38 to 21:05, 87 minutes; `s1/PREDICT_R2.md`, md5 `0882825b…`; the tree frozen by md5 of all 644 files and unmoved at the end): 170 lines, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout, `check_de` 697 checks. `check_jd` 130 / 0, `check_ik` 241 / 0, `check_jc` 70 / 0, `check_is` 96 / 0, `check_iu` 185 / 0, `check_ij` 49 / 0, `check_hx` 42 / 0, `check_ed` 18 / 0, `check_fg` 39 / 0, `check_parse` 246 / 0, `test_batch_an` 6,023, `test_batch_bk` 130, `check_hk` 166, `check_ez` 135, `check_gp` 451. **The two carried reds, `check_gj`'s sanctioned §4 (+155 / 175) and `check_cm_live` 13 / 5 inside its band, and `check_de`'s one**, `check_ik`'s row, which the fresh reader had already named while the battery ran. **This recon did not read the tree that lands**: it ran beside that reader, whose repairs are words, one gate arm and two baseline rows. **Pre-run 3 and a standalone `check_de` read those, and the acceptance reads the whole.** I chose that over a third recon of 87 minutes for changes that move no die.

**THE FRESH READER, ON THE ASSEMBLED REPORT** (`report/reader2_findings.md`; read-only, during recon 2, given the brief, this report, the tree and the logs, and told to walk the brief line by line and to recompute what it could): **no defect in the game**, and §5's readings, the falls and the three lost finishes recomputed to the digit by its own scripts, and the spiral's table by mine, run read-only. **Two unmet orders, eleven false claims, six stale, ten soft, every one checked at source and repaired.**

- **`check_ik`'s baseline row was never moved.** Recon 1 printed *FELL to 241, recorded 242*; I graded *241* as predicted and never traced `check_de`'s fourth red to a row, and a pre-run cannot read `check_de`. It would have reddened the acceptance. **Why it fell**: §6 walks what is suspended, one `ok()` a relic, and Cairnmoss was the one. The row moved, 242 → 241, with that reason.
- **The Hourglass read *recovers 30% of it*, which reads as 30% of the Mana held and pays 30% of maximum.** I rewrote that clause on the first reader's word and reported it nowhere. It reads *of maximum Mana* now, and it is the fifth thing beyond the brief.
- **Claims of mine it broke**: *no hero reaches 35* (three specs read exactly 35.0% at their opening maximum, one of them the reference four's Beastmaster; I had adopted class base, where no hero fights); *where the fights a hero fell in are most common* (the incumbent under Ambushed won more, and drew no Cairn); *it is named for what it is* (a hero raised fell and carries no key); *null after a quit*; the victory card and the framing card misquoted; two pointers at the wrong ruling in `docs/state.md`; *each in §0 and FOUND AT JD*, which they were not; the sentence on what the LOST rows are; and which read-outs came before the code.
- **Two sentences of the living documents §1's sweep missed**: `master.html`'s *every equipped relic reaches every hero*, and `CLAUDE.md`'s `revive_pct` *is a third channel*. Both are repaired, and both are why a sweep on one figure is no proof of the mechanism.
- **The rule's own *20% FLOOR* was held by no arm**, so R01's *every text follows the constant* was wider than the gate. `check_jd` §1 holds it now, 131 checks, and R01 wants it.

**PRE-RUN 3** (the tree that lands, the same 43, 21:06 to 21:19; `s1/PREDICT_PRE3.md`): all green, `check_jd` 131 / 0, the tree unmoved. What it added to pre-run 2 is every repair the fresh reader asked for: the words, `check_jd`'s one arm and the two baseline rows. **The standalone `check_de`**, on recon 2's logs with these 43 laid over, read 697 / 0 / 0, which is how `check_ik`'s row was proved before the acceptance needed it.

**THE CONTROLS — NINETEEN, ALL BIT** (`JD-work/tools/ctl_jd.py`, on the tree that lands: one clone each, the break's anchor dry-checked on the final tree and asserted once in the clone, the gate run through `lane.sh`, read by its FAIL text, never its count; `s1/PREDICT_CTL.md`, md5 `7fda1943…`). **0 throws, no must-hold line reddened, the tree unmoved, every negative anchor paired with the positive arm beside it.** My bets on a line not biting went unspent, and I wrote 50 minutes for what took two. **Two wants of H01's were mine and wrong before they ran**: *the glossary does not read the floor through its door* holds on HEAD's text, whose literal 20% is what that arm reads, and *§2c: the victory card* holds where no exception exists. I replaced them with what H01 can bite and said so in the prediction.

| | the break | what reddened (FAIL text) |
|---|---|---|
| C01 | the clearing heal let through to the hero who fell | §2a *the hero who fell walks out at 47, and the floor is 27*; §2b, each relic on the hook *reached the hero who fell* |
| C02 | the floor applied to a hero who ended at 1 health | §2a *walks out at 30, not the floor plus the clearing heal (52)*; *the survivor lost the clearing heal*; §2b *did not reach the hero at 1 health* |
| C03 | a `victory_heal_pct` relic made to reach the hero who fell | §2b *reached the hero who fell*, on each of the three: 40, 33 and 47, the floor 27 |
| C04 | a living document left saying he walks out above the floor | §1 *1 living statements put a hero who fell above the floor* |
| C05 | `_die()`'s guard removed | §3a *a blow on the corpse ran the death callback again*, *a second call*, *a body raised cannot fall again*, *an enemy's death ran the callback 3 times*; §3b *DRIVEN — the strike ran the death callback 2 times on one body* |
| C05b | the bare guard, with the Break left open on a corpse | §3a *a blow on the corpse laid a Break*; *the raised body rose wrong: dead false, broken true*; §3b *the strike Broke the corpse* |
| C06 | the Cairn's requirement left on `fallen_hero` | §4a *still asks for a member at 0 health*; *DRIVEN — the event is never drawn after a real fall* |
| C07 | the Cairn's boon made to heal the heroes | §4a *the boon reached seat 0*, 2 and 3 |
| C08 | Cairnmoss Poultice left suspended | §4b *Cairnmoss Poultice is still suspended* |
| C08b | Cairnmoss reading the old hook | §2c *with it the hero who fell walks out at 27, wanted 47*; §4b *reads the wrong hook*; *the dead hook stands in* |
| C09 | `rest_heal_add` put back with no reader | §4b *the dead hook stands in `scripts/relics.gd`, with no reader*; the Knucklebone's 15% held |
| C10 | the map potion's fallen branch put back | §4c *the map's fallen branch is back*; the potion in a fight held |
| C11 | §5's arm's reading written from JB's figure | §5 *the reading is JB's figure (6.6736), not this tree's*; *the difference is not its two readings'* |
| C12 | a twenty-sixth card dealt into the closed deck | §7 *the deck holds 26, and it is closed at 25* |
| C13 | a new zone leaves the mark on a hero it restored | §2e *a new zone left a mark*; §4a *left the Cairn drawable on a hero it restored* |
| C14 | the third zone's boss made to restore him | §2e *the third zone's boss restored him: 135, the floor 27*; *took the mark* |
| H01 | HEAD's code under the final gate | 34 lines, the constant, the door, the note, the mark, the Cairn, Cairnmoss, the dead hook, the map's branch and both §3 roads among them |
| H02 | HEAD's documents under the final gate | 13 lines, §0's rulings and §1's statements |
| R01 | a re-tune: the floor moved at its source to 25% | §1 *`master.html` does not state the floor the code holds (25%)*, its second statement, and the rule's own headline; **the glossary's token followed the constant and stayed green**, which is the door working |

**`check_de`'s row, proved before the battery that needed it**: the standalone `check_de`, on recon 2's logs with pre-run 3's 43 laid over, read 697 / 0 / 0.

**THE ACCEPTANCE** (the repository, 30 files landed behind the hash guard, 27 changed and 3 new, each `cmp`-equal to the tree pre-run 3 and the controls read; `s1/PREDICT_ACC.md`, md5 `7f1cf897…`; 21:22 to 22:50 PST, 87 minutes alone; the repository unmoved by md5 of its 644 files, `git status` unmoved): 170 targets, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout, **`check_de` 697 / 0 / 0**. `check_jd` 131 / 0, `check_ik` 241 / 0, `check_jc` 70 / 0, `check_is` 96 / 0, `check_iu` 185 / 0, `check_ij` 49 / 0, `check_it` 42 / 0, `check_jb` 97 / 0, `check_ed` 18 / 0, `check_hx` 42 / 0, `check_fg` 39 / 0, `check_fr` 25 / 0, `check_parse` 246 / 0, `test_batch_an` 6,023, `test_batch_bk` 131, `check_hk` 168, `check_ez` 135, `check_gp` 451. **The two carried reds and no other**: `check_gj`'s sanctioned §4 (70 / 1, *the card says +155 gold and the purse moved 175*) and `check_cm_live` 13 / 5, inside its band.

**THIS REPORT IS THE ONE FILE IN THE COMMIT WHOSE BYTES THE ACCEPTANCE DID NOT READ.** `check_is` §6 and `check_jc` §3 list `docs/reports` and take each report's file name as a code, so landing it moves both populations, which is what JC found at its own close. **So the landing was run before the commit, not assumed**: thirteen gates alone on a clone of the tree that lands with this report's draft at `docs/reports/JD.md` (`s1/PREDICT_REP.md`, md5 `a791a405…`; 22:52 to 22:56; lane *Dawn of Decay IC ctlA*, no new folder): `check_is` 96 / 0, `check_jc` 70 / 0, `check_jd` 131 / 0, `check_hx` 42 / 0, `check_iu` 185 / 0, `check_it` 42 / 0, `check_iv` 119 / 0, `check_fr` 25 / 0, `check_parse` 246 / 0, `check_fi` 27 / 0, `check_ek` 47 / 0, `check_ft` 147 / 0, `check_hn` 75 / 0, each at the acceptance's own count, 0 `Parse Error`, 0 `SCRIPT ERROR`. `check_is` and `check_jc` print 162 codes where the acceptance's printed 161, and `check_jc` reads *CW to JD*. **I ran it twice**: on the draft, and again on these words, because a third reader and this paragraph came after the draft. Both read as above.

**A THIRD READER, ON THE CLOSE's OWN SECTIONS** (read-only, after the acceptance, told to check each figure at its source): every figure of the acceptance, both recons, the sizes and the md5s held, and five findings. **Four are repaired, all mine**: the controls took two minutes, not three; the spiral's table was recomputed by my tool, not by the fresh reader's scripts; C03's *40* was one relic's; and a sentence said the push had happened before it had. **One did not stand**: it read `check_gv` at 597 s off whole-second stamps, and the same stamps to the fraction read 596.48.

**THE PUSH CHECK AND THE TWO READINGS.** **The push check**: before anything ran, `git ls-remote origin class-merge` read `8a2a41a2`, JC's push and local HEAD (2026-11-01 10:35), and it read the same at the close, before this commit (22:51). **This report travels inside the commit it describes, so it cannot read its own push**: the push to `class-merge` and the remote's read-back against local HEAD come after these words, and the close's message gives them. **The two readings** (IQ's method, each file against its own ceiling, at the open and the close): **`CLAUDE.md` 503,783 → 507,328 B (+3,545, nothing cut), 14.56 KiB under 510. `docs/state.md` 354,446 → 354,543 B (+97 net), 34,577 B under 380 KiB.**
