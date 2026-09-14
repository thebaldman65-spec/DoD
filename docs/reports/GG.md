# Batch GG — A mid-fight save is a project, and two glossary entries retire

*Branch `class-merge`, from `bc6e258` (GF); `git ls-remote origin class-merge` read `bc6e258` before the push.
`main` (`3b80fbe`) takes one documentation commit (§4) and nothing else.*

## NEEDS A RULING

1. **A QUIT FIGHT THAT RESUMES WHERE IT WAS IS A PROJECT, NOT A BATCH, SO NONE OF IT IS BUILT.** The brief said to cost it
   first and stop if it was large. It is large. A battle can only be resumed from the top of `_run_battle`'s turn loop,
   because everywhere else a suspended function is holding the fight's state. The loop has to be re-entered past a
   one-time opening it must not repeat. A fight changes **130 fields on each unit and about forty on the battle**. The
   dice can't be put back: every roll goes through Godot's global generator, whose state the game cannot read. A skill
   check that is open is open inside one of those suspended functions (§1). **Four options are priced in §2d**:
   - **A.** The full capture, with nothing left to retry.
   - **B.** A resume at the turn boundary that leaves one action to re-roll.
   - **C.** **The recommended middle**: the fight still restarts, but the heroes' health, Mana and spent items as they
     stood at the last turn boundary ride the save, so a quit can only cost. It is one batch, it moves no save version,
     and it owes three answers the designer has to give.
   - **D.** Leave the restart.

   **Whichever is taken, one hole goes with it (§2c):** today a quit after the last hero falls, and before the defeat
   screen, restarts a fight that was already lost.
2. **THE RULING'S REASON COVERS TWO MORE GLOSSARY ENTRIES THAN ITS LIST.** *"A glossary entry saying 'this exists but
   nothing produces it' is worse than no entry"* is, word for word, what Melted Armor's and Caught Fast's entries say of
   themselves. Nothing applies either: each applier reads a field that nothing in `scripts/` or `data/` writes
   (`melt_ranks`, `caught_fast`). **Both are left as they are, because the ruling names two.** Taking them is one
   `retired` string each. The one catch is that Melted Armor's entry is the precedent `CLAUDE.md`'s *kept, and said to
   be kept* rule is named after (§3d).

## THE SHORT VERSION

- **§1 — WHAT A MID-FIGHT SAVE HAS TO HOLD, ENUMERATED BEFORE ANYTHING WAS WRITTEN.** Nothing in the brief's list is
  saved today. A handful are derivable. Everything else is new state, and the brief's list reaches about twenty of the
  130 fields a fight writes on each unit. Four things are uncapturable as the code stands: a suspended turn, the global dice, an open bar, and the battle's
  opening, which must not run twice.
- **§2 — THE SAVE, THE INVERSE AND THE ESCAPE.** Nothing moved, so the run save stays **v13** and GF's proof that a won
  fight is never fought or paid twice stands unchanged. **Today a quit on a losing fight is a free retry of the whole
  fight**: the warband comes back fresh and the heroes at the health they stepped on with. Every item used comes back
  to the pouch, and the opening turn order and every roll come back new.
- **§3 — DECAY AND ELEMENTAL WEAKNESS LEAVE THE GLOSSARY AND KEEP THEIR IDS.** Nothing applies either, which was
  confirmed at every applier and swept across all 29 status entries. Each entry carries a `retired` string. The panel
  neither lists nor links a retired entry, and `data/glossary.json` still holds all 98. `docs/master.html`'s two copies
  of Decay as a live status are corrected.
- **§4 — `main` GETS ONE LINE**, naming both of its defects, in a documentation-only commit.
- **§5 — NOT DONE, AS RULED.**

## §0 — THE BRIEF'S PREMISES

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD `bc6e258` (GF), and `origin/class-merge` read the same |
| 2 | *"GF made a quit fight restart against the same warband at entry health"* | **HELD** | `resume_scene` sends an unresolved encounter back to `battle.tscn`, and `_spawn_units` reads each hero's `Run.party[i]["hp"]` as the step saved it (`battle.gd:1449`) |
| 3 | *"the only way in the game to retry a losing fight"* | **HELD, AND WIDER THAN STATED** | It is the only player route: Restart Run abandons the run and a forfeit ends it. But the retry also refunds every item the abandoned fight used and re-rolls the opening turn order. **The window also runs past the loss itself**: a quit after the fatal blow, before the defeat screen, restarts a fight already lost (§2c) |
| 4 | *"GF moved the run save to v13 and older saves still load"* | **HELD** | v13 is tolerant; below v10 is still refused and cleared (`run_state.gd` `load_run`) |
| 5 | *"GF proved a won fight can never be fought or paid twice"* | **HELD** | GF §2c; `claim_reward` marks the encounter resolved before any victory's first save. The reconnaissance battery re-read `check_gf` at 98 / 0 |
| 6 | *"statuses and their durations, cooldowns, every meter, the initiative timeline's positions, Break and stability, companions and their Loyalty, the bar's own state, the log"* | **HELD, AND IT REACHES ABOUT TWENTY OF 130** | A fight writes 130 fields on each unit and about forty on the battle (§1c); the list's items map to about twenty of the unit's |
| 7 | *"the initiative timeline's positions and each unit's `delay`"* | **NOT AS STATED** | No unit carries a delay. The position is `next_time`; a delay belongs to the ability and is paid at the cast |
| 8 | *"CZ's Blood Frenzy is health-missing plus Rage-spent and stores neither"* | **HALF** | The health half is derived from `hp` and `max_hp`. **Rage spent is a stored ledger**: `rage_spent` (`unit.gd:392`), written only by `note_resource_spent`, and `CLAUDE.md`'s CZ §1 block says so (*"THE LEDGER BOOKS WHAT LEFT THE BAR"*). A capture saves it |
| 9 | *"every meter (… Ruin, Burn, Chilled …, the three new spines)"* | **HELD, WITH TWO CORRECTIONS** | Ruin, Burn and Chilled are statuses, carried as stacks and turns inside `statuses`, not meters. The three spines are machinery on nobody, but their ledgers are written anyway: `note_momentum_turn` runs for every unit on every turn |
| 10 | *"companions, their Loyalty and their health"* | **NOT AS STATED** | Loyalty is the hunter's, keyed by beast (`unit.gd:178`); the chip on the companion is stamped from it. The companion's health is its own |
| 11 | *"GB worked it out from the code and GF is the first batch to drive it"* | **HELD** | GF §0 row 2 |
| 12 | *"`check_gf` … its 98 checks"* | **HELD** | `baselines.json` `check_gf` 98 / 0 |
| 13 | *"Decay and Elemental Weakness cannot be applied by anything"* | **HELD** | §3a |
| 14 | *"GF read all 745 glossary claims and found 95 wrong across 46 entries"* | **HELD FOR THE TOTALS, NOT THE WORD** | GF §3d: 95 **stale** in 46 entries, of which **57** were *wrong*; the other 38 were gone, moved or a figure |
| 15 | *"Retired, kept and SAID to be kept in the data, the Melted Armor contract"* | **HELD** | `CLAUDE.md`, EO §3. Its precedent is Melted Armor's own glossary entry, which annotates — the shape this ruling retires (NEEDS A RULING, item 2) |
| 16 | *"GF's repair is 12 files"* | **NOT AS COUNTED** | GF's commit touched **19** files. **Thirteen** are not documents: six game scripts, `data/glossary.json`, four gate and suite files, `baselines.json` and `pin-manifest.json`. The resume itself is five scripts and `check_gf`. It changes nothing here: §4 is a note, not the repair |
| 17 | *"both are `main`'s and neither is recorded there"* | **HELD** | `main`'s `docs/state.md` is FS's and names neither the quit nor the end boss |
| 18 | *"The end boss is the next batch and needs a node label and tooltip from the designer"* | **HELD** | `docs/state.md`, first in the queue |
| 19 | *"Zone 1 drawing the Hollow Crown while naming a different boss"* | **HELD** | `docs/state.md`, GF's findings |
| 20 | *"The Peddler and the forge stay lost on a quit, per GF"* and *"The mini-boss awarding an upgrade the forge already applied stays queued"* | **HELD** | Both are in `docs/state.md` and untouched |

## §1 — WHAT A MID-FIGHT SAVE HAS TO HOLD

### 1a. How it was read

Every file the fight runs in was read before anything was written: `battle.gd` (27,146 lines), `unit.gd` (4,151),
`run_state.gd`'s save, load and resume, and `main_menu.gd`'s Continue. **The field census is static, and it is a
floor.**

- It took every `var` a `BattleUnit` declares.
- It found every place in `scripts/` that writes each one, after stripping comments and string contents:
  - assignments, including `+=` and its kind;
  - subscript writes (`cooldowns[name] = …`);
  - container methods (`statuses.append(…)`);
  - bare writes inside `unit.gd` itself.
- It filed each write under the function holding it.

It cannot see a write through a local alias, or one made through `set()` with a computed name. The spawn's own
`set(key, config[key])` loop (`unit.gd:2164`) is the only such loop and runs once, before the fight. **The live
population a build would face is at least this.**

### 1b. The brief's list, item by item

| Item | Where it lives | Saved today? | Derivable? | What a capture needs |
|---|---|---|---|---|
| Statuses and durations | `BattleUnit.statuses`: an array of dictionaries — id, turns, power, stacks, tick, `full_turns`, and per-status extras such as `src` (a name), Frostbind's `partner` (a name), Poison's `fresh` | no | the chips are | every unit's array. It holds names, never objects |
| Cooldowns | `cooldowns`, card name → turns | no | no | every unit's dictionary |
| Rage and Mana | `resource` | Mana carries between fights on the member (`unit.gd:1044`); Rage does not | no | the live value |
| Focus, Mercy, Resonance | `second_resource`, one field under three names | only the two rune carries between fights | no | the live value |
| Loyalty | `loyalty` on the **hunter**, beast kind → stacks | no | the chip is | the hunter's dictionary |
| Faith | `faith_stacks`, `faith_peak` | no | no | both |
| Ruin, Burn, Chilled | inside `statuses` (stacks, turns, power), plus Burn's clock fields | no | no | inside the arrays |
| Frenzy | health half from `hp`/`max_hp`; Rage half from `rage_spent` | no | **half** | `rage_spent` |
| Plating | `plating_bonus` | no | no | the field |
| The three spines | `mana_spent`; `momentum` and its four ledgers; Sanctity's three **static** fields (`unit.gd:2035-2037`) | no | the steps are | the ledgers and the statics |
| The timeline | `next_time` on each unit — **the opening one is rolled at spawn** (`battle.gd:1710`) — and `_clock` on the battle | no | whose turn it is (`_next_unit`) | both |
| Break and stability | `pressure`, `broken`, `broken_pending`, `broken_extra_turns`; `stability` comes from the config and no fight writes it | no | stability is | the four |
| Companions | their own `BattleUnit`s in `companions`, built mid-fight by `_do_summon` (`battle.gd:22213`), each pointing at its hunter through `pack_master` | no | no | each one, **rebuilt without `_do_summon`'s arrival, Loyalty gain and log lines** |
| Items used this fight | the battle's own copy, `items`, plus `item_used` (one a character a turn); `_init_items` copies the pouch in (`1028`) and `_check_end` writes it back (`25063`) | the pouch as it stood at the step | no | the battle's copy |
| The turn number, whose turn | `_turns_taken`; whose turn is derived | no | whose turn is | `_turns_taken` |
| The bar, if open | `sc_active`, `sc_pos`, `sc_dir`, `sc_profile`, `sc_sequence`, and the suspended cast around them | no | no | **not capturable mid-press** (§1e) |
| The combat log | the `history` label, appended to by `_log` (`2460`) | no | no | its text |

### 1c. What the list does not name

**On each unit: 130 fields a fight writes.** The census files `BattleUnit`'s 662 declarations four ways. **130** are
written by something that runs during a fight. **55** are written only at the spawn. **254** are reached only through a
config or payload key. **223** are written by nothing — the dormant fields FX left, or defaults that never move. Five
of the 130 are nameplate state a respawn rebuilds. The rest are game state:

- **Health and more.** `hp` and `dead`, and `max_hp`, `attack`, `armor` and `crit_bonus`, which the fight moves too:
  lent health, Conviction, the bonuses a companion arrives with.
- **Each enemy's declared action.** `intent` holds an `Ability` object and a target unit.
- **The Swordmaster's guard.** `stance`.
- **Every card's bank.** Deadfall's charges, Feint's guards, Berserk's strikes, the banked guards, Rampage's chains.
- **The one-a-fight flags.** For example `second_wind_used`, `ashes_used`, `undying_rage_used`.

The whole list is at the foot of this report.

**On the battle: about forty fields.** Some are about the battle as a whole:

- The three unit arrays, the battle's pouch and `item_used`.
- `battle_over`, the acting unit, and the enemies held in a prison (`_holds`).
- `_clock` and `_turns_taken`.
- `empower_armed`, `_swapped_free` and `_forfeit_nudged`.
- The stalemate flag, `_cy_turns` and `_cy_peak`.
- The recap's eight ledgers (`_b_slice`, `_b_bd_slice`, `_b_sig`, `_run_slice`, `_run_dealt`, `_run_taken`,
  `_run_taken_total`, `_run_kills`).
- The log.

Others are about a turn in progress: the bar's five fields, and the second and third targets and Called Shot's mode.
Eleven more are echo and re-entry guards, which are false between turns. Everything else on the battle is interface or
sim bookkeeping.

**Object references that cross a turn:** `intent`'s ability and target, `pack_master`, `last_attack_target`, `_holds`,
and the unit arrays themselves. **All of them can be re-pointed by position when loaded.** Status entries store names,
not objects. Frostbind's `partner` is a `unit_name`, so a board with two units of one name would need unique names
before a capture could re-point it.

### 1d. Derivable rather than stored

- **Whose turn it is.** The lowest `next_time` among the living, which `_next_unit` computes every pass.
- **Every meter's payout.** Channel's steps, Momentum's steps, Sanctity's steps, Focus's crit split and Loyalty's
  conversion are each computed from a ledger. The ledgers are stored; the payouts need no saving.
- **Blood Frenzy's health half** from `hp` and `max_hp`. Its Rage half is `rage_spent` and is stored (§0 row 8).
- **Stability, speed and resists** come from the config at the spawn and are not written by a fight. A respawn
  reproduces them.
- **The chips, the turn bar and the intent plates** are drawn from `statuses`, `next_time` and `intent`.

**The pattern is the useful half.** The spawn builds roughly three hundred fields a capture need not carry, provided
the resume can re-run the spawn without its side effects (§1f).

### 1e. What is uncapturable

**Four things decide whether this is buildable at all, and it is — at one point only.**

1. **A turn in progress.** The fight is one chain of suspended functions. There are **138 `await` lines in 26
   functions**, and `_resolve` alone runs from line 8019 to 12522 with 39 of them, between the damage it deals and the
   animations it waits on. GDScript cannot save a suspended function. **The only point where nothing but the loop itself
   is suspended is the top of `_run_battle`'s `while not battle_over:` (`2597`)** — between one unit's turn and the
   next. So a resume re-enters there, and a quit anywhere inside a turn comes back at the start of it.
2. **The dice.** `battle.gd` has 104 lines that roll Godot's global generator (`randf` and its kind, `pick_random`,
   `shuffle`); `unit.gd` has three. Nothing in either file owns a generator whose state can be saved, and the global
   one can be re-seeded but not read back. **As the code stands, a resumed turn rolls again.** Storing a seed at every
   turn boundary would make a turn replay the same rolls, **provided everything after it rolls in the same order**.
   That includes each sound's pitch (`_sfx`, `27112`) and the player's own choice. A different card rolls different
   dice.
3. **An open bar.** `_run_skill_check` has two callers: the hero's cast (`4109`, inside `_player_turn`) and the
   defensive bar (`24895`, inside `_defensive_brace`, which `_resolve` waits on at `8036` in the middle of an enemy's
   strike). The sweep's position is two numbers. What the press is *for* lives in those suspended functions: the cast,
   its targets, the gated or defensive mode, and the Sharpshooter's sequence so far.
4. **The opening.** Before its loop, `_run_battle` runs once: the Faith meters open, the Binding Oath is sworn, every
   enemy declares, and the warband's theme and each rune are logged. The spawn rolls the opening turn order, stamps the
   battle's modifier and books the opening statuses into Sanctity's ledger. **None of it may run twice**, and a resume
   has to rebuild the units without it.

### 1f. What a build would take

1. **A snapshot of every unit and of the battle.** It has to be a walk over the script's own member list, not a list of
   names. A list of 130 rots at the next card: every new clause adds a field, and three lists that must agree are this
   project's oldest defect. Object references are re-pointed by position.
2. **A resume path into `_run_battle`** that skips the opening and enters the loop at a turn boundary.
3. **A respawn with no side effects.** `_spawn_units` has to build the nodes, sprites and plates and then be
   overwritten from the snapshot, without logging, stamping, booking or rolling. Companions are rebuilt the same way,
   without `_do_summon`.
4. **A save at every turn boundary**, heroes' and enemies' alike. `save_run` writes the whole run, and would carry the
   snapshot beside it.
5. **The dice and the choice**, if no retry at all is wanted:
   - a seed stored at every boundary;
   - the committed action recorded when it is committed — the card, the targets, the mode, and the grade once it is
     pressed;
   - on resume, the recorded turn replayed rather than re-chosen.
6. **The save format**, v14 (§2a).
7. **The inverse and the escape** kept closed (§2b, §2c).
8. **A gate that proves the round trip** — every field of every unit equal before the quit and after the resume, at
   every boundary of a real fight — and the brief's five quit points driven from a cold start.

**That is a project.** Items 1 to 3 rebuild how `_run_battle` and `_spawn_units` start, and every gate that spawns a
battle runs through both. GF's resume, for comparison, was one batch of nineteen files for **four keys and one resume
decision**, and this is the same decision with a battle behind it. By that measure it is at least three batches:

- the snapshot, the respawn and the round-trip gate;
- the resume entry, the save cadence, the version, and the inverse and escape drives;
- the seed and the replay, if the retry is to close entirely.

### 1g. The bar, and what it should do

**Today, a quit with a bar open restarts the fight.** Nothing of the cast was paid, because nothing is consumed until
after the grade (`CLAUDE.md`, CN §2).

**Under a capture, refusing the snapshot while a bar is open is the right answer**, as the brief expected. It needs no
code beyond the rule that a snapshot is taken only at a turn boundary, where no bar can be open. Its cost is a retry,
and the report states it:

- **A hero's cast bar.** A quit mid-press comes back at the start of that hero's turn, and the card can be chosen again.
  That is a retry of the choice, never of a press that landed, because the grade is not paid until after the press.
- **A defensive bar.** A quit mid-press comes back at the start of the enemy's turn, and the enemy's action and every
  roll in it replay.

**Capturing it is item 5's replay.** The cast would be recorded when the bar opens, and a fresh bar opened on resume.
The sweep's position is not worth saving: a press that has not happened has told the player nothing.

### 1h. The five quit points the brief names

| Quit point | Today (GF's restart) | Under a turn-boundary capture |
|---|---|---|
| Before any action | the same fight from its opening, the opening turn order rolled again | the same |
| Mid-turn, an action resolving | the fight restarts | that turn replays from its start; its rolls come back new unless seeded |
| A status about to expire | the fight restarts clean | the status is in the snapshot at its remaining turns, and expires at its bearer's next turn start, as it would have |
| A companion out | gone; the Beastmaster summons again | rebuilt from the snapshot without its arrival |
| A bar open | the fight restarts, the cast unpaid | the start of that turn (§1g) |

*The first column is GF's drive and the code; nothing in this batch was built to drive the second.*

## §2 — THE SAVE, THE INVERSE AND THE ESCAPE

### 2a. The version

**Nothing was built, so the run save stays v13** and `load_run` is untouched.

- **Option A or B would move it to v14**, for a snapshot key beside the step. It would be tolerant, like v11, v12 and
  v13. **The refusal threshold stays at 10** by `CLAUDE.md`'s VERSIONS rule (*"DO NOT RAISE THE THRESHOLD TO MATCH THE
  VERSION"*), and `load_run`'s existing path — refuse and clear below 10 — is the one it follows. A v13 build reading a
  v14 save would ignore the key and restart the fight, which is what it does now.
- **Option C moves no version at all.** Health, Mana and the pouch are saved fields already; it writes them more often.

### 2b. The inverse

**GF's proof stands because nothing it rests on moved.**

- `claim_reward` marks the encounter `resolved` before any victory's first save.
- `resume_scene` never re-enters a resolved encounter.
- A wipe or a forfeit clears the save.

The reconnaissance battery read the unmodified `check_gf` against this tree at 98 / 0.

**What a capture would owe the inverse:**

- the snapshot must be unreadable once the encounter is resolved;
- it must be keyed to its encounter, so that a snapshot from one fight can never be laid over the next;
- it must be cleared with the save on a wipe or a forfeit.

Left undone, *resume, win, quit, resume* would replay the won fight's last turn.

**Option C leaves the inverse exactly where GF put it:** the fight still pays only through `claim_reward`.

### 2c. The escape

**Today, a player who quits a losing fight gets a free retry of all of it:**

- the warband comes back fresh and the heroes at the health they stepped on with;
- every item used in the abandoned fight is back in the pouch, because the battle writes the pouch back only in
  `_check_end` (`25063`);
- the opening turn order is rolled again (`1710`), and every other roll with it.

The bargain stays frozen (GF) and nothing is paid. The battle's own *Exit to Main Menu* (`2240-2243`) writes nothing
and leads to the same place.

**And the window runs past the loss.** The last hero falls inside `_resolve`, which always goes on to wait on its
animations (its final `await _wait(0.45)`, `12414`, is unconditional). The wipe's `Run.clear_save()` is in
`_check_end`, which `_run_battle` calls only once the acting unit's turn is over (`3397`). **So a quit after the fatal
blow and before the defeat screen restarts a fight that was already lost.** This was read in the code and not driven.

**Under each option:**

- **A** closes it, by replaying the fatal turn with the same dice and the same choice.
- **B** and **C** leave the fatal turn replayable. Under C the heroes would come back at their health before that turn.
  So both need the wipe's clear moved to the moment the last hero falls.
- **D** is today.

### 2d. The options

| | What a quit mid-fight does | What a player can still retry | Save version | Size |
|---|---|---|---|---|
| **A. The full capture** | resumes at the last turn boundary, with the committed action and the dice replayed | nothing | v14 | a project, three batches or more |
| **B. A turn-boundary resume** | resumes at the start of the turn in progress | one action: its dice, and a hero's choice of card | v14 | a project, two batches or more |
| **C. The losses ride the save** *(recommended)* | restarts the warband against the heroes as they stood at the last turn boundary — health, Mana and the pouch — with nothing paid | nothing worth taking: the warband's losses reset and the heroes' do not | none | one batch |
| **D. Leave the restart** | restarts from the step | the whole fight, items refunded | none | nothing |

**Option C, in detail.** At the top of the turn loop it writes each hero's health and Mana and the battle's pouch back
onto the run, then saves. It stays out of every suspended function, because it writes only where nothing is suspended.

**It owes the designer three answers:**

- **A hero who has fallen.** The spawn clamps a hero's health to at least 1 (`1449`), so without a change a fallen hero
  would come back standing. The choices are: at 1, at the victory rule's 20%, or down.
- **The meters that are not saved today.** Focus, Faith, Resonance, Loyalty and the rest would reset, which costs the
  player.
- **Companions.** They would be gone, and the Beastmaster summons again.

**And C also needs the wipe to clear the save the moment the last hero falls** (above).

## §3 — TWO GLOSSARY STATUSES RETIRE

### 3a. Nothing applies either, confirmed before either was removed

- **Decay has two appliers, and both are talent riders whose fields nothing writes.**
  - Empowered Hex on Hex of Ruin (`battle.gd:10983`) is guarded by `attacker.emp_hex_ranks > 0`.
  - Lingering Torment, as a madness ends (`_on_status_expired`, `15711`), returns early on `occ.torment_ranks == 0`.

  Both fields are declared (`unit.gd:1389`, `:1416`) and read at those lines, and **written nowhere in `scripts/` or
  `data/`**. The last code that wrote either was the talent trees FX replaced: `git log -S` finds both leaving
  `talents.gd` at `59491e3`.
- **Elemental Weakness has one applier.** It is a Crushing Blow rider (`11132`) guarded by
  `attacker.elem_weak_ranks > 0`. That field (`unit.gd:455`) is written nowhere, and its writer, the Warden node
  `wd_elem_weak` that `test_batch_al`'s table still names, left at the same commit.
- **No data names either id.** There is no `applies_status` or status `id` for either in `classes.gd`,
  `data/enemies.json`, `data/runes.json`, the events, the relics or the run's modifiers.
- **No computed status id can draw one.** Every `_apply_status` or `add_status` whose id is not a literal was read:
  - the data-driven card rider (`10933`, `10939`), which no card points at either;
  - Lunge's `exposed` or `cripple`;
  - the Second Barb's and the Stalking Horse's `STALKING_HORSE_STATUSES`, which holds neither;
  - Downwind's copy (`13200`), which copies a status already standing and so cannot create one;
  - chips stamped with literal ids.

  No list literal in `scripts/` holds either id.

### 3b. The same question over every status entry

All 29 status entries in the glossary were asked the question, not just the two named. For each applier, the chain of
conditions above it — walked up by indentation — was read against the 223 fields nothing writes, plus `caught_fast`,
which a rune coercion list names without writing.

**Four entries have no live applier: Decay, Elemental Weakness, Melted Armor and Caught Fast.** The walk misses an early
return and a continuation line, which are the two Decay and Elemental Weakness sites it reported live; both were read by
hand and are dead. The other 25 each have an applier outside a dormant guard, or apply some other way:

- through a card's data — Psychosis through Mind Flay, which is in both the Occultist's draft pool and his boss pool;
- or by a mechanism of their own:
  - Bleed is a meter;
  - Broken is `take_hit`'s;
  - Bound is the Frostbind status, applied by a Cryomancer draft card;
  - Glacial Hold is `_hold_freeze`'s.

The walk does not prove that the cards behind the other 25 are reachable. GF's census read every claim in the same
entries against the code, and these four are the ones it flagged.

### 3c. What moved

- **`data/glossary.json`.** The two entries each gain a `retired` string, naming the batch, why nothing applies the
  status, what is lost and what is kept. Their text is byte-unchanged and the file still holds 98 entries.
- **`scripts/glossary.gd`.** `in_category`, the one door the panel lists through, skips a retired entry. `is_retired`
  answers the question for the panel's links. `entries()`, `entry()` and `status_short()` still resolve a retired id,
  the way `Runes.config` resolves a retired rune.
- **`scripts/glossary_panel.gd`.** The see-also loop skips a link to a retired entry. It is the one place a live entry
  pointed at one: Resists & Vulnerabilities linked Elemental Weakness.
- **`docs/master.html`.**
  - The status table's Decay row said *"(3 turns)"*, as though it could be applied. It now says what the Elemental
    Weakness row beside it already says: nothing in the game applies it at present.
  - Penance's *Builds with* line no longer offers Decay as something to build with.
  - §11a says an entry for something nothing produces is retired rather than annotated.

### 3d. What was kept, and said to be kept

- **The ids stay in the file**, so `test_batch_ce`'s equality of 98 counts decisions, not the panel, as its own comment
  says it should.
- **The statuses stay in `STATUS_INFO` and `DEBUFF_IDS`.**
- **Decay's turn-start tick (`2808`) and Elemental Weakness's resistance read (`10325`) stand.**
- **Melted Armor's and Caught Fast's entries still annotate themselves** (NEEDS A RULING, item 2). Melted Armor's is the
  precedent `CLAUDE.md`'s *A RETIRED PIECE OF CONTENT IS KEPT* rule names, and `docs/master.html` quotes
  `docs/text-audit.html` calling it *"the most honest string in the game"*. Under this ruling it is the shape that
  retires, and that tension is recorded in the rule rather than resolved by this batch.

## §4 — `main` GETS A NOTE, NOT THE FIX

One commit on `main`: `docs/state.md` only, as the first item of its open queue. It names the quit defect, says it is
fixed on `class-merge` at GF (`bc6e258`), and names the end boss's missing button beside it, which is found on both
branches and fixed on neither. `ways-of-working.md`'s merge table takes the branch's `state.md` wholesale at the merge,
so the note is `main`'s alone and is not carried across; this branch's `state.md` already records both defects.
**Nothing else crosses.** The ref is in VERIFICATION.

## §5 — NOT DONE, AS RULED

- **The end boss** (next batch), and zone 1 drawing the Hollow Crown with it.
- **The Peddler and the forge** stay lost on a quit.
- **The mini-boss's doubled upgrade** stays queued.
- **No merge work.** Engines-to-runes follows the end boss.
- **No node, rune, magnitude or engine moved.** `data/runes.json`, `data/enemies.json`, `scripts/talents.gd`,
  `scripts/classes.gd`, `scripts/battle.gd`, `scripts/unit.gd` and `scripts/run_state.gd` are unchanged.

## FOUND AND NOT FIXED

- **A quit after the fatal blow restarts a lost fight** (§2c). Read in the code; it goes with whichever option is taken.
- **`classes.gd`'s SYNERGY comment above Penance still says *"DECAY and ENTROPY grind the same enemy's clock"*.** Both
  are dormant: `entropy_ranks` is on the list of fields nothing writes too. It is a comment, not player-facing, and
  `docs/master.html`'s copy of it is corrected.
- **Frostbind's `partner` is stored as a `unit_name`.** Two units sharing a name would make `_frostbind_partner`
  ambiguous. Nothing has shown that happening; it matters to any capture that re-points by name.
- **Nothing asserts the glossary's retirement.** `check_et` §1 asserts every retired rune carries a string; no gate
  reads a glossary entry's `retired` key. This batch was IMPLEMENT ONLY, so its proof is a scratch probe (VERIFICATION),
  and a gate is owed to a test batch.

## VERIFICATION

### The saves

Backed up before anything ran, at `save-backups/GG-20260914-104612/` (not committed), and verified by hash. All four
read the same as GF's:

| file | md5 |
|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

All four read the same as the backup before each battery's launch and after its run.

### The parse floor

After the last code edit, `check_parse` read **183 checks / 0 failures**. Its stderr carries no `Parse Error`,
`Compile Error`, `SCRIPT ERROR` or `Failed to load` line; that was read off the stream, never off the tally or the exit
code. The count is unchanged from GF, because no file joined or left the population it walks.

### The panel, driven — a scratch probe, not in the tree

A probe outside the repo opened the real `GlossaryPanel` headless and asked the accessors. It read **28 checks / 0
failures** and no error line, with every negative arm paired with a positive one:

- **The data layer.** `entries()` still holds 98; `entry()` and `status_short()` still resolve both retired ids;
  `is_retired` is true for the two and false for Burn, Melted Armor, Caught Fast, Resists & Vulnerabilities, Pressure &
  Break and an unknown id.
- **The list.** `in_category("statuses")` omits the two and still lists Burn, Melted Armor and Caught Fast — 27 of 29,
  and 96 of 98 across all seven categories.
- **The panel.** Its tree holds 96 rows with neither retired entry, and still holds Burn, Resists & Vulnerabilities and
  Melted Armor. Resists & Vulnerabilities no longer links Elemental Weakness and still links Damage Schools; Snared
  still links Caught Fast.
- **THE CONTROL.** The two `retired` strings were stripped in memory, never on disk, and a fresh panel then listed all
  98 and relinked Elemental Weakness. **The string is the only switch**, and *"deleting this string brings the entry
  back"* is true as written.

### The batteries

- **Reconnaissance: the unmodified gates against the new code, before the documents moved.** It ran 109 targets,
  10:52:06 → 11:38:54 (46 m 48 s), and `.ran` is one sequence with no duplicate name.
  - **`check_de` read 453 checks / 0 failures / 0 notices**, so every row sits at its `baselines.json` row.
  - **`check_gf` read 98 / 0.** GF's proof that a won fight is never fought or paid twice holds, unmodified, against
    this tree.
  - `test_batch_ce` read 1,114 / 0, with its 98-entry equality green. `test_batch_ax` read 218 / 0, `check_parse`
    183 / 0, `check_fx` 496 / 0 and `check_ct_map` 83 / 0, and the harness 22 / 382 / 8 with no throws.
  - No log carries a `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line.
  - The tree and the four saves hashed identical before and after (506 lines), and no Godot or battery process was in
    `ps` before the launch or after the run.

  The one red is the sanctioned one:
  **`check_cm_live` read 13 / 4, the sanctioned red, and its four FAIL lines are identical to GF's acceptance log byte
  for byte.** That log came out of GF's own scratchpad (`acc_out/`, written at 01:58 inside GF's stated run window). It
  is confirmed as GF's by its `check_de` 453 / 0 / 0, `check_gf` 98 / 0 and `check_parse` 183 / 0, and it was copied
  here before it was compared.
- **Acceptance: every target through `run_battery.sh` in the real tree**, over the finished tree with every document in
  place and nothing edited during it.
  - **Predicted before it ran:** every row at its current `baselines.json` row, `check_de` 453 / 0 / 0, and
    `check_cm_live` 13 / 4 with GF's four FAIL lines.
  - **`baselines.json` is unchanged**, because this batch added no gate and moved no count.

  - **The reading.** It ran 109 targets, 11:42:13 → 12:28:56 (46 m 43 s). `.ran` is one sequence with no duplicate
    name, in the reconnaissance battery's order. **`check_de` read 453 checks / 0 failures / 0 notices — the
    prediction, row for row.**
  - **The rows quoted.** `check_gf` 98 / 0, `test_batch_ce` 1,114 / 0, `test_batch_ax` 218 / 0, `test_batch_bx`
    156 / 0, `check_dk` 60 / 0, `check_dm` 93 / 0, `check_parse` 183 / 0, `check_fx` 496 / 0 and `check_ct_map` 83 / 0.
    `test_batch_an` read 6,049 and `test_batch_bk` 130, each inside its band, and the harness 22 / 382 / 8 with no
    throws. Every suite that reads `data/glossary.json` directly is among the green.
  - **`check_cm_live` read 13 / 4, the sanctioned red, and its four FAIL lines are identical to GF's acceptance log
    byte for byte.**
  - **No error lines.** No `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line appears in any of
    the 109 logs, nor in the reconnaissance battery's 109.
  - **The freeze.** Every file in the repo but `.git` and the `.godot` build cache — tracked, untracked and ignored —
    and the four player saves were hashed before the launch and after the run: **507 lines, identical byte for byte**.
    No Godot or battery process was in `ps` before the launch or after the run.
  - **One file was written after the run: this report.** Its acceptance figures went in after the after-freeze was
    taken, and no gate or suite reads `docs/reports/`.

### The literal sweep

Every string literal of four or more characters in the 113 root `.gd` files — 13,262 distinct — was checked raw,
lowered and whitespace-flattened against HEAD's copy and the final copy of each edited file. That covers the three code
and data files, and the five documents before they went in.

| Edited files | LOST | GAINED |
|---|---|---|
| The three code and data files | 0 | 14 |
| The five documents | 12 | 19 |

**Every holder was read.** Most of the moved needles sit in files that never open the file that moved them. **Eight
holders do both, and none is a pin on what moved:**

- `check_ek`'s three lost `state.md` paths are file lists it opens (`TAG_DEFINERS`, `NO_TAG_FILES`, the two display
  screens).
- `test_batch_bd`'s *Caught Fast* is a retired node's name in a table.
- `test_batch_bt`, `bv` and `bw` assert *Builds with* against `docs/master.html`, which still carries it.

On the code side, the only holder that reads the glossary is `test_batch_ax`. Its two gained names, *Empowered Hex* and
*Lingering Torment*, are labels on pins against `battle.gd`'s source.

### The pin manifest

`build_pin_manifest.py --check` read the manifest **current, 1,464 pins**, against the tree with the code edits in and
the documents not yet moved, and **current again, 1,464 pins**, once they had landed. `pin-manifest.json` is unchanged.

### `CLAUDE.md`

**323,355 B (315.78 KiB)**, +1,330 B this batch, against the 340 KiB ceiling. The changelog is **325,497 B**, 74,503 B
under its 400,000 B bar. `check_fg` read both in the acceptance battery, and puts `CLAUDE.md` 24,805 B (24.22 KiB)
under its ceiling.

### The push

- **To `class-merge`, once this report's figures were in.** `git ls-remote origin class-merge` is read against local
  HEAD after the push and reported with the batch, because a commit cannot carry its own hash.
- **The `main` note is its own documentation commit on `main`**, made in a separate worktree after the `class-merge`
  push. `git ls-remote origin main` is read against local `main` the same way.

## THE FOLDERS THIS BATCH LEFT

None under `~/Library/Application Support/Godot/app_userdata/`. Every run used the real tree, and nothing wrote to
`user://`: the probe touched no save, and the batteries' saves are redirected by FI's rule. The backup is at
`save-backups/GG-20260914-104612/`, untracked like its predecessors.

## THE 130 FIELDS A FIGHT WRITES ON EACH UNIT

Static census over `scripts/` (§1a). Five are nameplate state a respawn rebuilds (`_base_tint`, `_float_stack`,
`_plate_active`, `_plate_hover`, `_plate_root`).

```
_base_tint _float_stack _plate_active _plate_hover _plate_root _soul_guard aegis_bonus answering_pack_spent armor
ashes_return ashes_used attack backblast_used banked_guards battle_turn beast_committed beasts berserk_strikes
bestial_armor_bonus bestial_hp_bonus bleed_buildup bleedouts_this_battle bloodbond_cb broken broken_extra_turns
broken_pending burn_at_death burn_clock_held burn_tick_at_death chill_uncapped companion_kind companion_power
constitution conviction_base_hp conviction_hp_gained cooldowns crit_bonus crit_streak damaged_since_turn dead
deadfall_armed deadfall_dormant debuffs_applied discipline_turns dmg_by_turn ember_consumed endurance_stacks
enraged_stacks enraged_timer faith_peak faith_stacks feint_guards formless_pending free_ability free_action_taken
free_summons freezing_adv_mark frenzy_floor frigid_bonus glass_hold grace_echo_pct heal_by_turn healed_externally
hold_turns hp icy_veins_charge immovable_noted improvised_used intent iron_bank is_companion keg_bank kinds_summoned
last_attack_target last_howl last_howl_dmg last_overheal last_word_armed loyalty mana_spent martyrdom_guard max_hp
melted mindfulness_counter momentum momentum_dealt momentum_exchanges momentum_met momentum_taken next_time no_heals
overcharge_mult overcharge_uses overtone_casts pack_master plating_bonus poise_pivot_used prep_pending pressure
rage_spent rampage_chains reacquire_bank res_cast_this_turn resource ruin_shared_in same_target_turns
second_barb_next second_resource second_wind_used seeding_consumed shared_scent_bank snap_used soul_bond
stalking_next stance statuses stored_overheal sunder_shot tenacity_hp_gained trance_taken trap_rearm
undying_rage_used unrelenting_cd vengeance_kind vengeful_ready vigor_hp_bonus watchtower_used weight_of_ruin
whetstone_turns winters_depth
```
