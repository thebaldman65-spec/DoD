# BATCH IE — THE RESOURCES, AND THE MAGE'S FIRE

**On `class-merge`, from `027de47` (ID). IMPLEMENT ONLY.** **§0: ID's four rulings are answered** — ✦ names a rune (built, §4), a
chip is not a status (the engine chips built, §2a; Sanctity re-measured, §2b), an offer that cannot refill is spent and one held back
stays owed (measured, then built, §5), the titles confirmed with a fourth noun, THE ABILITY (§5) — and §0.5's and §0.6's rules are
recorded. **§1: the Cleric's Mana was censused and measured, and the rate did not move**: his drip is the Hunter's, the sim shows him
dry about as often as the other two (more often than the Mage untalented), and only a HIGHER rate reaches the shape he was to be
tuned to — so the curve is the designer's. **§2: the engine chips are drawn as rune chips are**, and a Hierophant's steps now come
about one of his turns later; nothing authored. **§3: Stoke and Cinderfall lay Burn**, at figures the kit already uses; a draft of
readers with one applier now has Burn on most of its turns, one with none falls just short, and Pyroblast — the one fire card left —
is the designer's. **§4: ✦ off the hero sheet's worn row and the Empower toggle; two panels found.** **§5: a spent pick, and THE
ABILITY.** **The verification**: two recons of HEAD's battery — §2a alone, then all of IE's game code — each predicted after its literal sweep; every red named but four (two coin flips the spawn's dice turned over, `check_di`'s integer pin, `check_gp`'s road), each attributed by an ok() trace or a stub, the coin flip that was an arm repaired by construction and proved two-armed; twenty-three controls, each in its own clone; the 63 document readers on the final documents; the pre-pass and the acceptance, 145 targets, each closing `check_de` 597 / 0 / 0 as predicted.

**VERDICT: GREEN.** §0's four rulings are answered and its two rules recorded; §2a, §3b, §4 and §5 are built, none dropped; §1's rate and §2b's threshold were measured and left, as the brief asked, for the designer (rulings 1 and 2). Every row moved is moved with its cause — `check_gp` by Cinderfall, `test_batch_bw` and `check_cm_live` by the spawn's dice, `check_di` by the two lights; twenty-three controls bite; the pre-pass and the acceptance both closed `check_de` 597 / 0 / 0 as predicted, the tree byte-identical and the player's files untouched. Five rulings are owed (below).

## NEEDS A RULING

1. **THE CLERIC's MANA RATE DID NOT MOVE, BECAUSE THE SIM DOES NOT SHOW A CLERIC WHO NEVER RUNS DRY (§1).** His base drip is 12, the
   Hunter's (the Mage's is 22 with Evocation), and nothing a run reaches raises it. Dry — the card the bot would cast with a full
   bar costing more than he holds — on the sim's default build (rung 1, all 27 nodes): **Cleric 4.1%, Mage 4.5%, Hunter 3.9%** of
   their turns; untalented (the designer's own profile buys none): **26.8%, 18.3%, 33.8%**. **Lowering his rate moves him away from
   the shape** (*dry sometimes, and less than the Mage and the Hunter*): 10 reads 6.9%, 8 reads 11.6%. **Only 14 reaches it** (1.5%,
   under 2.3% and 3.9%). Two conditions of the designer's play the sim does not carry: the **Cracked Hourglass**, unlocked in his
   profile, refills the Mage and the Cleric 30% after every victory and the Hunter not at all — **with it in the party the shape
   already holds at 12** (Cleric 0.7%, Mage 1.7%, Hunter 4.1%) and the Cleric sits nearest full, which reads like the finding as
   play showed it; and no talents. Re-rule the rate, the shape, or the conditions it is measured under (the relic among them).
   The curve is §1c's table and `docs/state.md`'s.
2. **SANCTITY's STEPS NOW COME ABOUT ONE OF HIS TURNS LATER (§2b) — AUTHORED NOTHING.** Default build, a Hierophant Cleric, ~1,670
   fights an arm: a fight ended on **49.3 events at HEAD and 42.6 after §2a** (2.60 → 2.18 steps); his first step at his turn 1.12,
   now 1.90; his second at 3.08 in 83.5% of fights, now 4.04 in 67.1%. FV §3 set 16 a step against *about half the cap by a normal
   fight's end* on untalented rung-1 fights: untalented — that population — a normal fight now ends on **42.7 events (2.19 steps) where it ended on 50.5 (2.61)**:
   from just over half the cap to just under it. The threshold is the designer's.
3. **THE FIRE REPAIRS REACH THE SHAPE WITH ONE APPLIER HELD, AND FALL JUST SHORT WITH NONE (§3b).** On fixed drafts (a Cryomancer, no
   Overburn, 80 standalone fights each): **Fireball and four readers 27.2% → 62.9%** of his turns with Burn standing; **every reader
   and no applier 1.9% → 48.7%**; a control holding no repaired card 84.2% → 84.9%. **PYROBLAST is the third fire card that laid
   none, and it was left**: its ×1.5 reads the very Burn it would lay and its cooldown is 0, so its repair makes every repeat cast
   half again stronger — a damage change, not a supply repair (with it, the longest case reads 53.8%). Repair it, or let a new
   card carry the gap: **a card that lays Burn on a cold enemy without consuming it, on a short cooldown, on a shelf a Mage without
   Overburn draws** — one Fireball held is what moves a draft of readers from 27% to 63%.
4. **✦ ON TWO PANELS THAT ARE THE RUNE PANEL BEFORE IA (§4).** The **loadout panel** marks a carried CARD with ✦ and has no section
   head and no state column (its left column is the Bench/Carry button); the **crest panel** has heads, but its CREST section lists
   the worn crest rune and every bagged one together, so the ✦ there is the only mark of *worn*. Section them as IA sectioned the
   rune panel (and the marks go), or keep the marks. `check_id` §3a names both lines.
5. **THE OTHER DISPLAY CHIPS STILL LAID AS STATUSES (§2a, the kept census).** Twenty-odd literal-id `add_status` calls draw a chip for
   a value a field holds — Faith, Loyalty, Iron Will, the Capacitor, Deadfall, the Berserker's and the Feint's counters among them
   — and each books a Sanctity event when it lands (and one when it leaves). Convert each as the engine chips were, or rule which of
   them are statuses. The census is §2a's.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §8: ID's push hash is `git ls-remote origin class-merge` | **Held**: `027de47f…` on the remote and at local HEAD, read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | §8: ID's backup `../save-backups/ID-20261012-213521`; `run_save.bin` last written 2026-10-08 09:23 | **Held**: backed up to `../save-backups/IE-20261013-104148`, all four byte-identical to ID's by md5; `run_save.bin` 42,200 B, 2026-10-08 09:23. **Re-read at the close: all four byte-identical to it**, `run_save.bin` 42,200 B, 2026-10-08 09:23 (§8h). |
| 3 | Header: seven of ID's premises wrong — 25, 11, 10, 13, and 12, 15, 18 half | **Held**, as ID's report states them |
| 4 | §0.1: the sheet's state column says WORN, *the column ID renamed from ENGINE to CORE* | **Half**: it says WORN (and CORE, CREST, *held*); the ENGINE → CORE rename was **IA §4's**, not ID's |
| 5 | §0.1: report whether the loadout panel and the crest bag carry a section head or a state column | **Neither has a state column**; the loadout panel has no section head; the crest panel has heads, but its CREST section mixes the worn rune with the bagged ones — both are the rune panel before IA (ruling 4) |
| 6 | §0.1: report whether the nameplate's `✦ N` carries a tooltip | **It does**: *N rune(s) held, not worn. Click to equip it/them from the <hero>'s rune panel.* — nothing to build; the bag's `✦ N` carries one too |
| 7 | §0.2: four class-passive chips at every spawn and up to twelve engine chips, *as many as sixteen* free events | **Half**: ID deleted the class-passive chips, so at HEAD it was **up to twelve** — one an engine, three slots, four heroes; measured, a default-build fight ended on 6.7 fewer events after §2a |
| 8 | §0.3: ID already tells the held-back offer from the empty one, and only one is wrong | **Held**: the held-back offer said *Equip it and they return*; the empty one *Nothing further left to offer this run*; both *the pick stays owed* |
| 9 | §0.3: report whether an empty offer can refill, for a boss's ability and an upgrade | **Neither can (§5a, driven)**: the re-ask writes the empty list back and every later re-ask returns it without a top-up |
| 10 | §0.4: a zone boss's ability alone reads THE DRAFT; fifteen combinations | **Held** |
| 11 | §0.5: ID's prediction missed three reds the sweep listed | **Held** (ID §7b) |
| 12 | §0.6 / §8: §2a moves the spawn path | **Held, and it is the dice and Sanctity both**: each engine chip was one `note_status_event` and one `float_text` (`randf_range`) at every spawn |
| 13 | §1: the Mage and the Hunter run dry; only the Cleric is always full | **Not reproduced by the sim, on either build** (ruling 1): default build Cleric 4.1%, Mage 4.5%, Hunter 3.9% dry; untalented 26.8%, 18.3%, 33.8% |
| 14 | §1a: his base regen a turn, by lineage | **12 for every lineage** — `_mana_regen` is one base for every Mana hero; only the Mage's Evocation adds (10) |
| 15 | §1c: the lever is the regen, *a number* | **Half**: there is no Cleric-only number — the base is shared with the Hunter — and the measurement says only a higher one meets the shape |
| 16 | §1b: HZ measured Rage a turn over twenty runs a lineage | **Held** (HZ §2) — IE's probe took the same shape: twenty runs for each of the nine Mana lineages |
| 17 | §2a: ID's deletion moved `check_gp` 458 → 442, proved by a stub | **Held** (ID §7c) |
| 18 | §3: many Burn users, few causes | **Held, structurally**: eleven cards read or need Burn; without Overburn three lay it at the cast (Fireball, Firestorm, Ember Debt) — Flamewave only with the engine, Immolate only on a blow taken, Detonation only on a Perfect |
| 19 | §3a: Rupture may be unfeelable because the pool cannot lay Burn | **Held**: a Rupture stood at 0.7%–4.5% of a Mage's turns by lineage (sim, HEAD), and a draft of readers laid Burn on 2% of its turns |
| 20 | §6: ID read 526 folders / 175,188 KiB; spent 514 / 165,608 KiB; its own ten 9,080 KiB | **Held for the spent prefixes**: they read 524 folders / 174,604 KiB with ID's ten, which read **8,996 KiB** (84 less than ID wrote) |
| 21 | §7: ID closed at `CLAUDE.md` 449.00 KiB and `docs/state.md` 339.68 KiB | **Held**: 459,773 B and 347,830 B at HEAD |
| 22 | §7: the claims stand at 86 | **Held** |
| 23 | §7: nothing has been played for eight batches; IE makes nine | **Held**: the player's files last written 2026-10-08 09:23 |
| 24 | §8: ID read 144 in 80 min 57 s | **Held** (ID §7g) |
| 25 | §8: `check_gw` read 99 hand-sets against 96 at ID | **Held** (ID §7d); IE's gate hand-sets no rune field |

## §0 — ID's FOUR RULINGS, ANSWERED

- **§0.1 — ✦ NAMES A RUNE. BUILT (§4).** ✦ came off the hero sheet's worn row (its state column already says WORN) and the Empower
  toggle; it stays on the battle's rune chip and on the counts (the nameplate's, the bag's, the kit preview's prose). The loadout
  panel and the crest panel were measured and are the rune panel before IA — found, not built (ruling 4). The sweep is kept and
  asserts ✦ now (`check_id` §3a).
- **§0.2 — A CHIP IS NOT A STATUS. BUILT (§2a), AND SANCTITY RE-MEASURED (§2b).** ID's deletion of the class chip stands. The
  other display chips laid the same way are the kept census (ruling 5).
- **§0.3 — SPEND IT WHEN IT CANNOT REFILL. MEASURED, THEN BUILT (§5).** Neither the zone boss's nor the mini-boss's empty offer can
  refill, so both are spent; a held-back boss offer stays owed. The rule is `CLAUDE.md`'s, in the pick block.
- **§0.4 — CONFIRMED, WITH ONE NOUN ADDED. BUILT (§5).** THE ABILITY, joined by ID's joiner; all fifteen driven again.
- **§0.5 / §0.6 — RECORDED** in `docs/instrument-rules.md` with their rows in `CLAUDE.md`'s index: *a brief states what a batch
  intends to touch, never what it does not*, and *the literal sweep runs before the prediction*. Both bound this batch: the blast
  radius was confirmed before the recon's shape was set (two recons, §8b), and the sweep ran before each prediction.
- **§0.7 — THE ORDER**: §2a first (recon 1 launched on it alone), then §1's census and measurement, §3's census and repairs, §2's
  measurement, then §4 and §5 — all built; none dropped.

## §1 — THE CLERIC's MANA

### §1a — THE CENSUS (kept: rule, command, output)

*Rule*: every source of Mana a Cleric can have — base drip, nodes, runes, relics, bargains, cards, items, events, engine bonuses —
with its magnitude, its writer and whether a run played forward reaches it; everything that lowers what he spends; and every Mana
cost in his kit, his engines' enablers, his class's draft pool and his lineages' boss pools. *Command*: a read-only census of
`scripts/` and `data/` at HEAD (the cards resolved through `Classes.pool_ability` on a scratch copy), its notes in this batch's
scratchpad, `census_mana/`. *Output*:

| Source | Magnitude | Writer | Reached by a Cleric? |
|---|---|---|---|
| **The turn drip** | **12** (+ `mana_regen_bonus`, which no Cleric source writes) | `battle._mana_regen`, called in `_player_turn` | Every lineage, every turn; skipped under the Thin Air bargain |
| The Mage's Evocation (for comparison) | +10 → 22 | `battle._spawn_units`' class-passive arm | No — the Mage's |
| Mana carried between fights | the bar as it stood | `BattleUnit.sync_victory_state` → `member["mana"]` | Yes — health heals between fights, Mana does not |
| A new zone | refilled to `max_mana` (100) | `run_state.gd` at the zone's turn | Yes |
| **Recant** (Holy shelf, 25 Mana, cd 4) | +40% of a target's max; on himself, +15 net | `battle.gd`'s `recant` arm | Yes, any Cleric — no engine row |
| Blessing of the Faithful (20, cd 4) | 3% a Faith stack — at 8 stacks +4 net | `battle.gd` | The Devout (Conviction) only |
| A Conviction ally's release | 3 a release | `battle.gd`'s release arm | The Devout only |
| Divine Plea's / Dark Pact's Perfect | +10 / +5 | `battle.gd` | On a Perfect (the bot rolls 20%) |
| Node *Breaking an Enemy Refuels You* | +45 a Break of his own blow | `battle.gd`'s strike loop; `talents.gd` | The sim's full build; not the designer's |
| Node *A Bigger Resource Pool* | +20 max | `talents.gd` | The sim's full build; not the designer's |
| An ally's Rally / War Stomp / Rallying Shout | 15% / 10–20% / 30% | `battle.gd` | Drafted by the Warrior (the bot never casts Rallying Shout) |
| A Mana Potion | 40% of max | `battle.gd`, `map_screen.gd` | Yes (the sim never drinks one) |
| The Forest Spring event | 40% of max | `events.gd` | Yes |
| **The Cracked Hourglass** (relic) | **30% of max after every victory** | `battle.gd` → `Run.restore_mana` | **Yes — and it refills the Mage and the Cleric only**, though its card says *every hero* |
| The Bottled Storm (relic) | a floor of 35% at the spawn | `battle.gd` | Yes |
| **What lowers his spend** | — | — | — |
| Node *Your First Casts of a Fight Are Free* | the first two costed casts cost 0 | `battle._eff_cost`; `talents.gd` | The sim's full build |
| The Effortless upgrade | one card free for the run | `run_state.gd` | A mini-boss pick or the Blacksmith |
| Mercy-priced cards (Divine Plea, Hymn of Hope, Resurrection) | 0 Mana | `battle.faith_cost` | The Holy (Mercy) only |
| **What raises it** | the Warded bargain ×1.25; the Parched bargain halves the opening bar; node *Pay a Lethal Hit out of Your Resource Pool* takes 30% of every hit from Mana (the full build) | `battle.gd`, `unit.gd` | — |

**The spend side**: the kit — Smite 0, Ministration 20 (cd 2), Unburden 20 (cd 4), Consecration 25 (cd 5); the enablers — Divine
Shield 15 (cd 2, Conviction's), Hex of Ruin 20 (cd 2, the Old Gods'); the draft pool of 43 — costs 15 to 35, Mercy cards 0
(their full list is the census's). **How often the bot casts each, over sixty default-build runs** (the probe, §1b): Divine Shield
1,616, Hex of Ruin 1,293, Smite 1,229, Mind Flay 541, Ministration 375, Heal 374, Covenant of Ash 309, Consecrated Ground 281 —
a costed card on 45.7% of his turns, 10.0 Mana a turn against a drip of 12.

### §1b — THE FIGURE THAT SAYS *ALWAYS FULL*, MEASURED

**The instrument** (a scratch copy, never the repo; `tools/probe_patch.py` in this batch's scratchpad): on every hero turn of a sim
run, the bar before the drip, after it and at the turn's end; the card the bot would cast with a full bar, its cost, and what he held
when he chose. **DRY = that card costs more than he holds.** Twenty runs for each of the nine Mana lineages (three parties), the
default rung (1) and the default build (all 27 nodes), and the same untalented — the designer's profile buys none. Per-run mean ±
its standard error (a run is the independent unit):

| | Cleric | Mage | Hunter |
|---|---|---|---|
| **Dry, default build, all zones** | **4.1 ± 0.6%** | 4.5 ± 0.9% | 3.9 ± 0.5% |
| Dry, default build, zone 1 | 0.9 ± 0.4% | 2.5 ± 0.9% | 0.9 ± 0.3% |
| Opens his turn full, default build | 22.0% | 28.4% | 10.1% |
| Bar at a turn's start / max, default | 77.9 / 120 | 92.2 / 120 | 75.2 / 120 |
| **Dry, untalented, all zones** | **26.8 ± 1.7%** | 18.3 ± 2.8% | 33.8 ± 2.1% |
| Dry, untalented, zone 1 | 16.9 ± 1.7% | 9.0 ± 2.1% | 27.9 ± 2.0% |
| Bar at a turn's start / max, untalented | 33.0 / 100 | 49.4 / 100 | 21.6 / 100 |

By lineage (default build): Devout 6.8%, Holy 5.6%, Occultist 0.5% dry; Pyromancer 5.8%, Cryomancer 4.1%, Arcanist 4.1%;
Survivalist 5.9%, Beastmaster 3.4%, Sharpshooter 3.0%. **The Occultist is the one Cleric who sits near full** (he opens 33% of his
turns full); the Cleric as a class does not. Zone one is where the Cleric opens full most often (38.8% default) — and so does the
Mage (35.3%).

### §1c — THE RATE, AND WHY IT DID NOT MOVE

**The lever** would be a Cleric-only base: there is none — `_mana_regen` reads 12 for every Mana hero — and the census found nothing
else filling him that a cost would answer. **The response, measured** (the probe's copy with the Cleric's base replaced; default
build, all zones):

| His base | Cleric | Mage | Hunter |
|---|---|---|---|
| 8 | 11.6 ± 1.0% | 4.5 ± 1.0% | 2.9 ± 0.5% |
| 10 | 6.9 ± 0.9% | 3.3 ± 0.8% | 4.0 ± 0.6% |
| **12 (HEAD)** | **4.1 ± 0.6%** | 4.5 ± 0.9% | 3.9 ± 0.5% |
| 14 | 1.5 ± 0.3% | 2.3 ± 0.7% | 3.9 ± 0.5% |
| 8, untalented | 50.5 ± 1.5% | 14.9 ± 2.5% | 36.8 ± 1.8% |
| 12 (HEAD), untalented | 26.8 ± 1.7% | 18.3 ± 2.8% | 33.8 ± 2.1% |
| 14, untalented | 18.5 ± 1.3% | 21.6 ± 3.3% | 33.0 ± 1.9% |

**The shape — not zero, and below the Mage's and the Hunter's — holds at 14 on both builds (untalented, within the Mage's error)
and at no rate at or below 12.** The direction the finding
points (down) and the pass condition point opposite ways on this instrument, so **the rate stays 12** and is recorded as a tuning
handle in `docs/state.md` with these figures. **The Hourglass, measured** (the same runs with `DOD_SIM_RELICS=hourglass`, rate 12): Cleric 0.7 ± 0.2%, Mage 1.7 ± 0.5%,
Hunter 4.1 ± 0.7% dry on the default build, the Cleric's bar 93 of 120 at a turn's start; untalented 13.1 ± 1.0%, 14.5 ± 2.8%,
36.0 ± 1.6%. **With it in the party the shape already holds at 12, and the Cleric is the hero who sits nearest full** — the
relic refills the Mage and the Cleric 30% after every victory and never the Hunter, and the designer's profile has it
unlocked. That is the likeliest reading of what play showed. **What the sim cannot carry**: the designer's
hands — a player who casts fewer heals than the bot's *heal when hurt* would sit fuller than the bot does — and his relic draft.

## §2 — SANCTITY, AND THE CHIP THAT WAS A STATUS

### §2a — THE ENGINE CHIPS, DRAWN AS THE RUNE CHIPS ARE

`BattleUnit.engine_chips` holds them (`set_engine_chip` writes one, `engine_chip` reads it, `update_engine_chip` rewrites its words);
the plate's row draws them first, where they stood when the spawn laid them as the first statuses; the six live readers in
`refresh_bars` and Overburn's chip read the list. **Nothing ticks, dispels or counts one, and none books a Sanctity event or floats a
label** — the two things the status door does for a status arriving, and the die that float spent. Driven (`check_ie` §2a): five
chips across four heroes (one a second engine), each named for its noun, none in `statuses`, none found by `has_status`, none in the
Sanctity ledger's keys — beside a status that books its one event — and the live chips reading live.

**THE SWEEP, KEPT (§0.6's sibling rule).** *Rule*: every `add_status` call in the game's scripts, comments stripped, its id, its
turns, and every line that reads that id back (`has_status`, `get_status`, `status_power`, `status_stacks`, `remove_status`,
`update_status`, `_find_status`, `composition_of`, `.id ==`); a **chip** is one whose status nothing reads for its payout — the
payout is a unit field, and the status only draws it; an **effect** is one a reader pays off, or whose clock is the payout's.
*Command*: `python3 tools/chip_sweep.py <repo>` (this batch's scratchpad; `chipsweep/sweep_ie.out` holds the full reader list).
`check_ie` §2b prints the same population every battery. *Output*, IE's tree — 35 calls in two files:

| Status | Chip or effect | Its payout is read off | Reached in a run played forward? |
|---|---|---|---|
| `iron_will` | chip | `iron_will_ranks` × the debuff count | **Yes** — the node *Mitigation per Debuff You Carry* |
| `undying_rage` | chip | `undying_rage`, `undying_rage_used` | **Yes** — a node |
| `keen_eyes` | chip | Aguila's boon | **Yes** — Pack Bond's eagle |
| `loyalty` | chip (on the companion) | the hunter's `loyalty` dict | **Yes** — Pack Bond |
| `aper_rhythm` | chip | `aper_strikes` | **Yes** — Tusk and Bristle |
| `faith` | chip (on an ally) | `faith_stacks`, `faith_peak` | **Yes** — Conviction |
| `feint_guard` | chip | `feint_guards` | **Yes** — Feint |
| `berserk` | chip | `berserk_strikes` | **Yes** — its card |
| `deadfall` | chip | `deadfall_armed` | **Yes** — Deadfall |
| `crushing_blows`, `melted`, `endurance`, `scent`, `deathwish`, `killing_edge`, `bracing`, `waiting_guard`, `enraged`, `capacitor` | chip | each its own field | **No** — no writer since FX (`capacitor` only a retired rune's) |
| `seeding`, `standard`, `rally_heal`, `crossfire`, `bear_brunt`, `held_breath`, `instinct`, `charging`, `fortified`, `anointed`, `bloodbond`, `ghostpack`, `elusive`, `unrelenting`, `broken` | effect | the status itself (or its clock) | — |
| the status door's `add_status(id, …)` | effect (every status a card lays) | — | — |

**Nine chips a run reaches still book a Sanctity event when they land and one when they leave** — Faith churns one at every release
on every shielded ally — ruling 5.

### §2b — SANCTITY's REAL RATE, MEASURED

The probe's copies of HEAD and of §2a seat a **Hierophant** Cleric (a probe switch awakens the Cleric with the Hierophant's rune) beside
the default lineages, twenty runs a party, and read the ledger at every fight's end and at the start of each of his turns:

| | HEAD | §2a |
|---|---|---|
| Events at a fight's end, default build (all / zone 1 / 2 / 3) | 49.3 / 41.5 / 50.4 / 55.5 | 42.6 / 36.5 / 43.4 / 47.6 |
| Steps at a fight's end (16 a step, 5 the cap) | 2.60 | 2.18 |
| A normal fight / an elite / a boss | 49.2 / 44.5 / 63.9 events | 42.1 / 39.1 / 56.7 |
| His first step, by his turn (fights reaching it) | 1.12 (99.9%) | 1.90 (98.5%) |
| His second step | 3.08 (83.5%) | 4.04 (67.1%) |
| Untalented (the designer's build): events at a fight's end (all / zone 1 / 2 / 3) | 50.5 / 38.5 / 53.4 / 65.0 | 44.0 / 34.2 / 47.3 / 53.1 |
| Untalented: a normal fight / an elite / a boss | 50.5 / 42.8 / 71.9 events | 42.7 / 38.0 / 66.4 |
| Untalented: steps at a normal fight's end | 2.61 | 2.19 |
| Untalented: his first step / his second, by his turn (fights reaching it) | 2.38 (95.5%) / 4.74 (71.3%) | 3.46 (91.1%) / 5.89 (62.6%) |

Default build ~1,650 and ~1,690 fights an arm; untalented (`DOD_SIM_TIERS=0`) 1,325 and 1,372.

**What the threshold is tuned to**: `SANCTITY_PER_STEP` 16 and 5 steps, set at FV §3 to reach about half the cap — 40 events, 2.5
steps — by a normal fight's end, on driven untalented rung-1 fights. **On that population the normal fight moved from 2.61 steps to 2.19 — from just over half the cap to just under it.** **The fall is about 6.7 events a fight on the default build** — a
hero holds more engines as a run goes on, so zone three loses more (7.9) than zone one (5.0). His steps arrive about one of his turns
later. **Authored nothing** (ruling 2).

## §3 — THE MAGE's FIRE

### §3a — THE CENSUS (kept)

*Rule*: every card a Mage can hold — his basic, his kit, what his class's engines bring, his class's one draft pool and the three
lineages' boss pools, 59 cards — read at its handler, for whether it lays Burn (how much, for how long, at what chance), reads or
needs it (and what it does without), and every non-Mage source. *Command*: a read-only census at HEAD (notes in `census_burn/`),
and — kept as a gate — `check_ie` §3b, which casts every fire card on a cold board every battery. *Output*:

| Card | Lays Burn at the cast? | Reads or needs it |
|---|---|---|
| Fireball (15, cd 2) | **3 turns** on a landing hit | — |
| Firestorm (30, cd 4) | **2 a bolt**, 6–8 bolts | — |
| Ember Debt (20, cd 4) | **12** on one enemy | — |
| Flamewave (25, cd 2) | **2 on every enemy** (3 Perfect) | — (Overburn's enabler: only with the engine) |
| Immolate | on whoever strikes him, 3 | — |
| Detonation | 2, on a Perfect only, after it consumes | consumes the bank ×2.5 |
| Pyre Wake, Firedraw | move what stands | refused with nothing alight |
| Wildfire, Funeral Pyre, Backdraft | none | refused with nothing alight |
| **Stoke** (20, cd 3, 25% fire) | **none at HEAD** — *Nothing extra against an enemy that is not alight* | doubles what stands |
| **Cinderfall** (30, cd 3, 20% fire, area) | **none at HEAD** | skims 2 a burning enemy for double |
| **Pyroblast** (45, cd 0, 55% fire) | **none** | ×1.5 on a burning target |
| Slow Burn, Emberkeep | none | stop the clock / double what arrives |
| Phoenix Rebirth, Ashes of Al'ar | none (fire by name) | — |

**Eleven read or need Burn; without Overburn three lay it at the cast.** **Every fire card is offered to every Mage** — none of them
has an engine row. **Non-Mage sources**: the Hunter's Choking Smoke (2 on every enemy) and Downwind (copies a laid Burn to a second
enemy); Loaded Shot restores; a Cleric's Returned Burden only returns Burn an enemy laid on a hero. No rune, relic, bargain or node
lays Burn but the Overburn-gated Ember Leap.

**The measured half, and Rupture.** Over sixty default-build runs (the game's own bot): Burn stood on an enemy at the start of a
Pyromancer's turn 62.9% of the time, a Cryomancer's 20.1%, an Arcanist's 11.4% — **a Rupture at 2.6%, 4.5% and 0.7%**. **So the
conjunction could not have been felt whatever its figure**: the Mage who lays the chill reliably (the Cryomancer, Chilled on 32% of
his turns) had Burn on a fifth of them. **And the bot is a poor instrument for the fire**: it never casts a drafted Fireball (one of
GS's returned cards its drafted hook cannot see), it reaches the drafted hook only when Magic Burst and Magic Missiles are both
unavailable, and it cast Stoke or Cinderfall once in sixty runs (though `check_gp`'s seeded road meets a Cinderfall eight times, §8c) — so §3b's before and after are taken on fixed drafts with a
probe-only fire policy, never on the bot's draft (FOUND AT IE).

### §3b — THE REPAIRS, AND HOW FAR THEY REACH

**The cards that deal fire and lay nothing**: Stoke, Cinderfall, Pyroblast (and Detonation lays only on a Perfect). **Two were repaired,
at figures the kit already uses**: **Stoke** sets an enemy that is not alight Burning for **3 turns** (a Fireball's turns, the
single-target figure) and still doubles a fire that stands; **Cinderfall** sets every enemy it rakes that was not alight Burning for
**2 turns** (Flamewave's and Choking Smoke's area figure), skims what burns, and lights nothing it kills. Both lay it through the
status door (`_apply_status`), so Emberkeep doubles the light, Downwind carries it, and a chilled enemy lit becomes a Rupture —
driven (`check_ie` §3a). The constants are `battle.STOKE_LIGHT_TURNS` and `CINDERFALL_LIGHT_TURNS`; the cards' words say so.

**Pyroblast was left** (ruling 3): its ×1.5 reads the Burn it would lay and it has no cooldown, so lighting its own target makes every
repeat cast half again stronger — a damage change the supply question did not ask for.

**The shape — a Burn-leaning draft has Burn standing on most of its turns — measured on fixed drafts**: a Cryomancer (no Overburn, no
Flamewave) holding the draft, 80 standalone fights an arm; the probe policy plays his fire — while nothing burns, a card the arm's
own list says lays Burn; otherwise his bar's fire cards in order (*policy 2*; *policy 1* is bar order alone):

| Draft | HEAD | IE |
|---|---|---|
| **Every reader, no applier — the longest case** (policy 2) | 1.9% | **48.7%** |
| The same, policy 1 | 2.0% | 45.9% |
| **Fireball + Detonation, Wildfire, Stoke, Cinderfall, Pyroblast** (policy 2) | 27.2% | **62.9%** |
| Control: Firestorm + Detonation, Wildfire, Backdraft, Pyroblast — no repaired card | 84.2% | 84.9% |
| The longest case with Pyroblast also repaired (a scratch variant, policy 2 / 1) | — | 53.8% / 44.3% |

**With one applier held the repaired draft has Burn on most of its turns; with none it falls 1.3 points short (policy 2), 4.1 short
(policy 1).** In run sims under the same policy, Burn-leaning drafts went 44.4% → 48.0% (Cryomancer 35.2% → 45.0%, Arcanist 6.1% →
23.8%) — but a run sim's drafts are reshuffled by every die §2a moved, so those figures carry the draw as well as the repair; the
fixed drafts are the measurement. **What a new card would have to do** (ruling 3): lay Burn on a cold enemy without consuming it, on a
short cooldown, on a shelf a Mage without Overburn draws — one Fireball held is what moves a draft of readers from 27% to 63%.

## §4 — THE GLYPHS

**Built**: the hero sheet's worn row reads the rune's name and rule beside the state column (no ✦); the Empower toggle reads *Empower
(C)*. **Measured and reported** (ruling 4): the loadout panel — no section head, no state column (its left column is the Bench/Carry
button), a carried card marked ✦; the crest panel — heads (THE CREST, IN THE BAG), but THE CREST lists the worn crest rune and every
bagged one together, so ✦ is its only mark of *worn*. **The nameplate's `✦ N` already carries its tooltip** (*N rune(s) held, not
worn…*), and so does the bag's. **The sweep, extended** (`check_id` §3a): every ✦ in the game's code is a rune's mark (the rune
chip's `RUNE_CHIP_TAG`, the crest panel's worn rune) or a rune count (the nameplate, the bag, the kit preview), and the loadout
panel's two lines are named as the finding — seven lines, each met. **Each surface apart** (`check_ie` §4, beside `check_id` §3b's
↑/◆/✦ on the map): the sheet's worn row with no ✦ beside WORN and no label carrying two glyphs; `✦ 1` with its tooltip; the loadout
panel's carried card still ✦; the Empower toggle; the rune chip's ✦.

## §5 — TWO SMALL THINGS

- **THE UNANSWERABLE PICK.** *Measured first* (`check_ie` §5a): a Cleric owning every card of his pool but one his engines leave out,
  his stored triple three he owns — re-asked, nothing (and nothing held back); with the engine equipped the card enters the draw
  (`roll_draft_fallback_offer` holds Aegis Reversal) and **the offer stays empty**. A Warrior with every upgrade taken but Widened,
  which fits nothing he holds — re-asked, nothing; holding Rampage, Widened enters the draw and **the offer stays empty**. The cause
  is one line each: `ability_choice` and `upgrade_choice` top up only for a candidate they drop, and an empty stored list drops
  nothing. **So both are spent**, in FM §3's register: the section says *The zone boss's offer holds nothing this hero can take —
  every card it held is already this hero's, and none is left to draw. The pick is spent rather than held: nothing can arrive to fill
  it.* (the mini-boss's: *…every upgrade it held is taken, and none left fits a card this hero holds…*), a **Let it go** button stages
  the spend, the Confirm waits on it (*One choice still to make*, then *Confirm the ability*), and the toast reads *<Hero>: the zone
  boss had nothing left to offer. The pick is spent.* **A held-back offer stays owed** in ID's words. Driven (`check_ie` §5b–c): both
  spends, the pick and its ◆ gone from the card; the walkers' helper lets a spent pick go; a held-back offer offered no Let it go,
  its ◆ standing.
- **THE ABILITY.** The title is THE DRAFT while the draft is on the screen; otherwise the kinds joined by ID's joiner (one helper now,
  `map_screen._joined`, for the title and the owed line). `check_id` §2 drove all fifteen — eight titles — and `check_ie` §5d four.

## §6 — HOUSEKEEPING

**THE MOVE WAS NOT ATTEMPTED** (IB §4). **Read at the close**: 561 folders, 227,108 KiB in all — IE's own 35 among them (below). The spent prefixes — every *Dawn of Decay* copy from
FX to ID and the five *DoD …* copies — are **524 folders, 174,604 KiB**: ID's 514 (165,608 KiB, unchanged) and **ID's own ten, 8,996
KiB** (ID wrote 9,080). **ONE command clears every spent prefix**, ID's ten included, leaving the live *Dawn of Decay* folder, IE's
own and `[unnamed project]`:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to ID)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-D]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to ID)/"
```

**IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from
the paste first. **IE's own folders** are named *Dawn of Decay IE …* and stay for IF: **thirty-five, 52,004 KiB** — the probes (*probeA1–A3*, *probeB1–B4*, *probeH*, *probeH1–H4*, *probeP4*), the two recons, the traces and stubs (*trH*, *trN*, *trS*, *trS1*, *trS2*, *stS*), the Aegis arm's proofs (*bwR*, *bwH*, *bwF*, *bwF2*, *bwF3*, *bwH2*, *bwH3*, *bwC3*), the two control lanes, the two document-reader lanes, the pre-pass and the final re-run. The live *Dawn of Decay* folder,
`../save-backups/` and `[unnamed project]` are untouched.

**THE LIVE FOLDER DOES NOT GROW WITHOUT BOUND.** It held 68 entries, 472 KiB when IE began and 67, 488 KiB at its close: the player's four files, each gate's scratch profile and
relics file under a fixed name (rewritten every battery — so the count follows the number of gates that leave theirs, not the number
of batteries; `check_ie`, like `check_id`, removes its own), `run_save_harness.bin` (one file, rewritten), Godot's `logs/` (five
rotated logs, 20 KiB) and two retired probe tables from August and September. Changed nothing.

## §7 — WHAT IS DELIBERATELY NOT DONE

- **IC's REMAINDER IS IF's** — the tick's line, Blight the Well's line, credit and frame, the bleedout burst, Umbral Sigil's echo; a
  tick credited by name.
- **NO CARD AUTHORED** (§3b — two repaired, Pyroblast left); **NO THRESHOLD AUTHORED** (§2b); **the Cleric's rate not moved** (§1c,
  measured against the shape).
- **No crest rune re-cut or authored; the crest cap stays at one.** Boil Over's rate not re-ruled, its Perfect not authored, the
  rising-rate lever not built. The vow not re-priced, the recoil floor not exempted, Anointing unchanged. The third slot not gated.
- **No conjunction authored**: `RUPTURE_BREAK_PER_TICK` stays at 10 — and §3a says why it was never felt. **Nothing has been played
  for nine batches.**
- **The re-measure does not run; it is IG.** Its two readings at IE's close: `CLAUDE.md` 462,598 B = 451.76 KiB, **58.24 KiB under 510** — 7.2 batches at EZ's record (59,642 ÷ 8,293), 21.1 at IE's own +2,825; `docs/state.md` 351,747 B = 343.50 KiB, **36.50 KiB under 380** — 6.4 batches at IA's +5,860 (37,373 ÷ 5,860), 6.8 at HO–HW's +5,528 mean (+3,917 B at IE). **`docs/state.md` binds first**: 6.4 to 6.8 batches at its own rates against `CLAUDE.md`'s 7.2 at the record.
- **The claims stand at 86** and are IH's.
- **The sim bot's fire is not taught** (FOUND AT IE): a case for a drafted Fireball, Stoke and Cinderfall is the instrument's, and it
  would move every seeded road again.
- Standing and unchanged: a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire
  becomes Sunder + Burn and Contagion and Reckoning owe re-cuts; the Occultist's Break card is CE §3's ask; the Skirmisher and the
  Tracker ruled into ordinary runes and unbuilt, Volley and Ambusher owed their core slots and names; Channel's tempo payout; whether
  a fallen hero stays down between fights; Tithe's read site and its talent rebalance; a bomb's surface text; the block index.

## §8 — THE VERIFICATION

### §8a — THE PUSH CHECK AND THE SAVES, BEFORE ANYTHING

`git ls-remote origin class-merge` read `027de47f…`, local HEAD the same, before anything ran. The four player files were backed up to
`../save-backups/IE-20261013-104148` and verified by md5 against the live files and ID's backup — byte-identical, `run_save.bin`
42,200 B last written 2026-10-08 09:23. Re-read at the close (§8h).

### §8b — THE RECON's SHAPE: TWO, BECAUSE §2a MOVES THE SPAWN PATH (§0.6's rule, applied)

**The blast radius was read before the recon was set**: §2a's engine chip was laid through `add_status`, so each was one
`note_status_event` and one `float_text` — one `randf_range` — at every spawn, for every engine a hero held. That is a seeded die and a
shared door, so §0.6's rule gives two recons: **§2a alone, then all of IE's game code.** §3b, §4 and §5 were read the same way: §3b moves a
fight only where Stoke or Cinderfall is cast; §4 is two strings; §5 moves a screen only where an offer is empty. **Each recon is HEAD's
whole battery — every gate, suite, fixture, document, baselines row and the runner, unedited — in an isolated APFS clone, md5-frozen at
launch (528 files), with its own user folder seeded from the backup.** Recon 1's code is HEAD's with §2a's two files (`battle.gd`'s copy
proved to differ from the final only by §3b's two lights and §4's Empower string); recon 2's `scripts/` and `data/` are proved
byte-identical to the final tree's. **Each prediction was written before its launch, after its literal sweep** (§0.5's rule).

**RECON 1 — §2a ALONE**, from 10:46:21 to 12:10:50 (84 min 29 s), HEAD's 144 targets, its copy byte-identical before and after (528
files). **`check_de` 593 / 6 / 0.**

| The prediction (`RECON1_PREDICTION.md`, written before the launch) | What HEAD's battery read on §2a |
|---|---|
| **Cause 1, the chip off the status door**: `check_go` red (several), `test_rune_battle` red (2), `test_batch_ar` red (3–4), `check_hu` red (1, the sweep's LOST needle) | **All four red**: `check_go` 401 / 22 (every chip arm, §1–§12), `test_rune_battle` 97 / **3** (one more than named: *the chip does not state the surviving refund clause*, the same chip read a third way), `test_batch_ar` 513 / 4, `check_hu` 104 / 1 |
| **Cause 2, the dice**: `check_gp` MOVES from 442; `check_gj`'s sanctioned red stays 1 with its figures MOVED; the other seeded roads, `test_batch_an`/`bk` and the harness at their rows | **`check_gp` did NOT move (442 / 0) and `check_gj`'s figures did NOT move (*+179 / 199*)** — the prediction was wrong twice in this row: the traces and the stub (§8c) show the engine chips move nothing on those two roads. The other roads, both bands and the harness 22 / 382 / 8 held |
| **Cause 3, Sanctity**: `check_ft`, `check_hs`, `check_ht` at their rows; `check_id` §3c prints a spawn's events | **Held**: 147, 83, 77; `check_id` 209 / 0, printing *a spawn now books 0 Sanctity events* |
| **Predicted green**: everything else — `check_hz`, `check_el`, `test_batch_bq`, `check_parse` 219, `check_ed` 18, every document instrument | **All green but two**, and the two are the misses |
| — | **MISSED, two, and both are coin flips the spawn's dice turned over**: `check_cm_live` 13 / **5** against its sanctioned 4 (*a Perfect brace takes less damage than no brace* — two bot rolls compared, 924 against 911 where ID's dice read 911 against 926) and `test_batch_bw` 512 / **1** (*a hit that gets through pays nothing* — the Warden Blocked it on Heavy Plating's slice, which a field of zero leaves standing). **No literal sweep can list a coin flip**: each arm reads a value the dice dealt, and only a run turns it over. Both attributed by stub and answered in §8c |

**RECON 2 — ALL OF IE's GAME CODE**, from 11:28:30 to 12:51:35 (83 min 5 s), HEAD's 144 targets, its copy byte-identical before and
after (528 files). **`check_de` 593 / 11 / 1 notice.**

| The prediction (`RECON2_PREDICTION.md`, written before the launch, after its literal sweep) | What HEAD's battery read on all of IE's code |
|---|---|
| **§2a**: `check_go`, `test_rune_battle` (2), `test_batch_ar` (3–4), `check_hu` §2a (1) | **As recon 1**: 401 / 22, 97 / **3**, 513 / 4, 104 / 1 |
| **§3b**: `test_batch_bt` §6, 2 (the empty case, and the Perfect arm reading 21 where it wants 12); `test_batch_bo` §5 green | **Held**: 334 / 2, and 1140 / 0 |
| **§4**: `check_gx` §3's sheet arm, one FAIL per rune it drives | **Held**: 25 — each of twelve engines' runes in both arms and the summary — and the count FELL, 1295 against 1367, because each arm that cannot find the row skips what it would have read there |
| **§5**: `check_id` §1b's emptiest (1) and §2's four titles with the boss and no draft (4) | **Held**: 210 / 5, those five |
| **The dice**: `check_gp` and `check_gj` read recon 1's rows (*the bot casts neither Stoke nor Cinderfall*); the other roads, the bands and the harness at their rows | **`check_gp` ROSE to 469 — MISSED**: the bot's drafted hook does cast Cinderfall on that road (the trace's 8 casts), so §3b moves its dice (§8c). `check_gj` held at *+179 / 199*; `check_gv` 1057, `check_hk` 168, `check_fh` 168, `check_ib` 119, `test_batch_an` 6054, `test_batch_bk` 131, the harness 22 / 382 / 8 |
| **Predicted green**: everything else, `check_parse` 219, `check_ed` 18 | **All green but three**, and the three are the misses |
| — | **MISSED, three**: the two coin flips recon 1 found (`check_cm_live` 13 / 5, `test_batch_bw` 512 / 1), and **`check_di` 44 / 1** — *the call-site population is 221, not the 219 this gate was written against*: §3b's two lights are two calls through the status door, and **`check_di` pins their count as a number, which no literal sweep can list** (a needle, not an integer, is what the sweep reads). The pin moved in the gate with its reason (§8c) |

**What the misses teach, recorded rather than repeated**: a prediction written off the literal sweep and a function census still
misses three things neither can see — a value the dice dealt, an integer pin, and a gate's own road. The first is found only by
running, and HR §6's rule answers it (construct the state, or band an owed red's coin flip); the second by counting what the diff
adds against the doors a gate counts (`_apply_status` here) before the prediction; the third by reading the road, not a sample of
the sim — *the bot casts neither, 0 casts in 60 probe runs* was true of the probe's drafts and false of `check_gp`'s.

### §8c — WHAT MOVED THE COUNTS, ATTRIBUTED BY TRACE AND STUB

**Five readings moved, and each is put on one cause by a trace or a stub, never by reading the diff.**

- **`check_gp` 442 → 469 is §3b's Cinderfall.** Four traced copies (every `ok()` printed): HEAD **442**; all of IE's game code under
  HEAD's gate **469**, every difference §4's per-card lines — the party offered 78 cards where 51, its no-engine road 33 battles where
  30 and its two-engine road 32 where 28 — and its Mage casting Cinderfall (*N set Burning* on 8 casts); that copy with Cinderfall's
  light stubbed out **442, identical to HEAD line for line** (Stoke is never cast on this road); and that copy with the engine chips'
  status landings put back at the spawn — the Sanctity event and the float each chip spent — **442, identical**. So the chips, the
  glyphs and the spent pick move nothing on that road, and the row moves to 469 with this as its reason.
- **`check_gj`'s sanctioned §4 red holds at *+179 / 199*.** Traced on HEAD and on all of IE's code: identical, line for line.
- **`test_batch_bw` (512 / 1 on HEAD's gate) and `check_cm_live` (13 / 5 against its 4) are §2a's spawn dice.** Both read so in recon 1,
  on §2a alone; HEAD's two gates on the stub copy give HEAD's figures back exactly — 512 / 0, and 13 / 4 at *braced 911 / unbraced 926*.
  Each is an arm that read what the dice dealt (HR §6's rule): `test_batch_bw`'s Aegis Wall arm forced Block off with a field of zero,
  which leaves Heavy Plating's slice standing and the miss roll too, so whether *a hit that gets through* got through was the dice's —
  HEAD's landed it, IE's was Blocked and every ally gained the wall's 40; **repaired by construction**, the documented negative field
  (`check_cm_live`'s own lesson, `docs/instrument-rules.md`) and no miss for that blow, with the blow asserted to land (513, +1), proved
  two-armed (§8e). `check_cm_live`'s fifth arm compares two bot rolls — the bar cannot open under a gate, FH's *one fact* — and reads
  whichever the dice made smaller (ID's 0.984, IE's 1.014): **carried as a band, 4 to 5**, until the bar can be pressed.
- **`check_di` 219 → 221 call sites is §3b's two lights**, each through the status door and passing the Mage as its source (`with_src`
  115 → 117); the count and the stamped share read exactly as the two added lines predict.
- **Nothing else moved.** Both recons read `test_batch_an` and `test_batch_bk` inside their bands, the harness at 22 / 382 / 8, the
  three Sanctity readers (`check_ft`, `check_hs`, `check_ht`) and every other seeded road (`check_gv`, `check_hk`, `check_fh`,
  `check_ib`) at their rows. **The Hierophant's Sanctity is the cost the gates do not see**: §2b measures it.

### §8d — EVERY RE-POINTED GATE ALONE ON THE FINAL TREE

Each in the repository, alone, after the last edit to the game code (11:07) and to the gates (11:24), stderr grepped for
`Parse Error` and `SCRIPT ERROR` (none): `check_ie` **70** / 0 (new); `check_id` **210** / 0 (+1, §3a's ✦); `check_hu` **105** / 0 (+1,
the chip's own writer); `check_parse` **220** / 0 (one target more); `check_go` 401 / 0; `test_rune_battle` 97 / 0; `test_batch_ar` 513 / 0;
`test_batch_bt` 334 / 0; `test_batch_bo` 1140 / 0; `check_gx` 1367 / 0 — **every one at its row**. `test_batch_bt` read 334 / **1** on its
first run (*a PERFECT Stoke triples 4 to 12 (got 21)*): the light §3b adds still stood when the Perfect arm laid its four, and Burn adds
its turns — so the arm clears the board's Burn first now, and read 334 / 0. **And the walkers of the gate files and the document
gates, alone on the final tree** (11:53): `check_ed` 18 / 0 (the manifest rebuilt, 1,772 pins, its unresolved set HEAD's), `check_gw`
76 / 0 (`check_ie` hand-sets no rune field), `check_da` 41 / 0, `check_ea` 396 / 0, `check_ec` 24 / 0, `check_ek` 47 / 0, `check_es`
57 / 0, `check_ff` 68 / 0, `test_batch_cd` 92 / 0, `check_hx` 39 / 0, `check_fg` 30 / 0, `check_hp` 171 / 0, `check_fr` 25 / 0.
**Every negative is paired with a positive**: no engine chip in `statuses`, beside one drawn, named and live; no chip booking a Sanctity
event, beside a status that books one; no light on what Cinderfall kills, beside the light on what it rakes cold; no ✦ on the sheet's
worn row or the Empower toggle, beside the rune chip's and the counts'; no Let it go on a held-back offer, beside the one on an empty
offer; no THE DRAFT on a zone boss's pick alone, beside THE DRAFT wherever the draft is on the screen.

### §8e — TWENTY-THREE CONTROLS, EACH IN ITS OWN CLONE

One APFS clone of the tree per control, every patch count-asserted, two lanes with their own user folders (*Dawn of Decay IE
ctlA*, *ctlB*), every FAIL line kept. The base was the final tree at 11:59; it differs from the committed tree only in
`test_batch_bw.gd`, `baselines.json` and two documents (the repair and the records of §8c), none of which a controlled gate reads.
**Every planted defect reds at the arm it aims at; the baseline is green; HEAD's game code under IE's gates (H01) reds or reads short
every one of them** — short with throws where a gate calls a door HEAD does not have (`engine_chip`, `STOKE_LIGHT_TURNS`), which
`check_de` reads as a falling count; **HEAD's helper under `check_ie` (H02) reds the one arm it cannot answer.** And the repair §8c
made has its own: **C20** — a wall that pays on a hit that lands, planted under the repaired `test_batch_bw` — reads 513 / 2 (*the blow
lands on the Warden with no Block anywhere (100 -> 117)*, the heal masking the blow, and *AND A HIT THAT GETS THROUGH PAYS NOTHING*),
while the repaired gate reads 513 / 0 on IE's code and on HEAD's.

| # | The defect planted | What read it |
|---|---|---|
| C00 | baseline: the final tree, no patch | `check_ie` 70 / 0<br>`check_id` 210 / 0<br>`check_hu` 105 / 0 |
| C01 | the engine chips laid through the status door again | `check_ie` 70 / 17 — *§2a (warrior): 0 chips for 2 engines*<br>`check_hu` 105 / 2 — *§2a: the add_status calls with a variable id are ["id", "u.engine_chip_id(String(pid))"] — want the status door's alone* |
| C02 | the chip row draws the statuses alone | `check_ie` 70 / 4 — *§2a (warrior): the row draws 0 chips for 2 engine chips and 0 statuses* |
| C03 | an engine chip books a Sanctity event | `check_ie` 70 / 1 — *§2a: an engine's chip booked a Sanctity event: ["103112771887:spec_passive", "103112771887:spec_passive_2", "106719873188:spec_passive", "107927* |
| C04 | Stoke lights nothing on a cold enemy | `check_ie` 70 / 5 — *§3a: Stoke did not set a cold enemy Burning for its 3 turns (got 0)*<br>`test_batch_bt` 334 / 1 — *Stoke sets an enemy that is not alight Burning for its own 3 turns (got 0)* |
| C05 | Stoke lights around the status door | `check_ie` 70 / 2 — *§3a: Emberkeep did not double Stoke's light — it is laid around the status door (read 3)*<br>`check_hu` 105 / 3 — *§2a: 1 add_status calls write a Burn or a Chilled by name, around the status door* |
| C06 | Cinderfall sets a burning bank alight too | `check_ie` 70 / 1 — *§3a: Cinderfall did not skim two turns from the burning bank (6 → 6)* |
| C07 | Cinderfall lights nothing | `check_ie` 70 / 3 — *§3a: Cinderfall did not set a cold enemy Burning for its 2 turns (got 0)* |
| C08 | the hero sheet's worn row reads ✦ again | `check_ie` 70 / 1 — *§4: the sheet's worn row is not its name beside WORN, or a label on the sheet carries ✦ ([])*<br>`check_id` 210 / 1 — *§3a: ✦ is drawn for something that is not a rune's mark, a rune count or the named finding: ["party_screen.gd: rune_label.text = \"%s%s — %s\" %*<br>`check_gx` 1367 / 24 — *§3 ambush (engine out): the hero sheet does not draw the worn rune's row, its name first* |
| C09 | the Empower toggle reads ✦ again | `check_ie` 70 / 1 — *§4: the Empower toggle reads ["✦ Empower (C)"]*<br>`check_id` 210 / 1 — *§3a: ✦ is drawn for something that is not a rune's mark, a rune count or the named finding: ["battle.gd: emp_btn.text = \"✦ Empower (C)\""] (met* |
| C10 | a spent boss pick stays owed (no Let it go) | `check_ie` 70 / 5 — *§5b (boss): the screen does not say the pick is spent, in the cache's words (["THE ABILITY — Holy", "A new ability. Decide, then confirm.", "ABI* |
| C11 | a held-back boss offer is offered Let it go | `check_ie` 70 / 1 — *§5c: a held-back offer was offered Let it go, or does not say it stays owed (["THE ABILITY — Holy", "A new ability. Decide, then confirm.", "ABI*<br>`check_id` 210 / 6 — *§1a: the held-back offer does not say what it waits on and that the pick stays owed (["THE ABILITY — Holy", "A new ability. Decide, then confirm* |
| C12 | an empty upgrade offer stays owed (no Let it go) | `check_ie` 70 / 2 — *§5b (upgrade): let go, the Confirm reads 'Nothing to choose yet'*<br>`check_id` 210 / 1 — *§1b: the emptiest screen does not say its pick is spent and offer Let it go (["THE UPGRADE — Berserker", "An ability upgrade. Decide, then confi* |
| C13 | the boss's spend leaves the pick owed | `check_ie` 70 / 2 — *§5b (boss): the spent pick is still owed, still stored, or still marked ◆ on the card* |
| C14 | a zone boss's pick alone reads THE DRAFT again | `check_ie` 70 / 4 — *§5b (boss): let go, the Confirm reads 'Confirm the draft'*<br>`check_id` 210 / 4 — *§2 ["boss"]: the title reads 'THE DRAFT — Holy'* |
| C15 | the title joins with & rather than AND | `check_ie` 70 / 2 — *§5d ["boss", "rune"]: the title reads 'THE ABILITY & THE CACHE — Holy'*<br>`check_id` 210 / 5 — *§2 ["boss", "upgrade"]: the title reads 'THE ABILITY & THE UPGRADE — Holy'* |
| C16 | the walkers' helper presses no Let it go | `check_ie` 70 / 1 — *§5b: the walkers' helper did not let a spent boss pick go: { "hero": 2, "card": "", "bench": "", "declined": false, "boss": "", "boss_bench": ""* |
| C17 | an empty boss offer re-tops at the re-ask (it would refill) | `check_ie` 70 / 1 — *§5a: the boss's offer refilled, or the engine did not open the card to the draw (draw ["Aegis Reversal"], offer ["Aegis Reversal"])* |
| C18 | a new fire card that lays nothing (Kindled Mind dealt as fire) | `check_ie` 70 / 1 — *§3b: the fire population moved — unnamed ["Kindled Mind"], no longer held []* |
| C19 | the crest panel's mark moves to a fourth surface (the bag button names its count with ✦✦) | `check_id` 210 / 1 — *§3a: ✦ is drawn for something that is not a rune's mark, a rune count or the named finding: ["map_screen.gd: \"  ✦✦ %d\" % crest_waiting if cres* |
| H01 | HEAD's game code under IE's gates | `check_ie` 29 / 7 (3 throws) — *§3b: a fire card did not do on a cold board what its row says: ["Cinderfall: none, not lays", "Stoke: none, not lays"]*<br>`check_id` 210 / 6 — *§1b: the emptiest screen does not say its pick is spent and offer Let it go (["THE UPGRADE — Berserker", "An ability upgrade. Decide, then confi*<br>`check_hu` 105 / 2 — *§2a: the add_status calls with a variable id are ["id", "u.engine_chip_id(String(pid))"] — want the status door's alone*<br>`check_gx` 1367 / 24 — *§3 ambush (engine out): the hero sheet does not draw the worn rune's row, its name first*<br>`test_batch_bt` 331 / 0 (1 throw)<br>`test_rune_battle` 84 / 0 (1 throw)<br>`test_batch_ar` 505 / 0 (1 throw)<br>`check_go` 345 / 0 (19 throws) |
| H02 | HEAD's gate_fixture under check_ie (the helper without the spend) | `check_ie` 70 / 1 — *§5b: the walkers' helper did not let a spent boss pick go: { "hero": 2, "card": "", "bench": "", "declined": false, "boss": "", "boss_bench": ""* |
| C20 | the Aegis Wall pays on a hit that lands (under the repaired `test_batch_bw`) | `test_batch_bw` 513 / 2 — *the blow lands on the Warden with no Block anywhere (100 -> 117)* |

### §8f — THE SWEEPS, AND THE CLAIMS RE-READ

- **The literal sweep, game code, before each prediction** (`tools/litsweep_id.py`, §0.5's rule): every gate and suite literal of four
  or more characters present in HEAD's game files and gone from the new ones (or the reverse), and every shorter one by count. **On §2a
  alone** (recon 1's): 1 lost — `check_hu`'s `u.engine_chip_id(String(pid))` — 2 gained, neither read off the game's text (`check_ia`'s
  `row:` builds a label, `check_ic`'s `floats` is a key), 0 short flips. **On all of IE's code** (recon 2's, over the final gates' literals
  too): 3 lost — that needle, `check_ie`'s own negative (`add_status(u.engine_chip_id`), `check_id`'s `%s and %s` (its own format) — 19
  gained, each IE's own needle or a word a gate reads off another file (`check_gt`'s `_spent` a shop property, `check_hp`'s `STAT` a
  rune shape, the `static func` needles the gates' own), 0 short flips. **Both predictions carried the list.**
- **The literal sweep, documents** (`tools/litsweep_docs.py`, raw and whitespace-collapsed, every length), over the seven edited
  documents and run again after the last pre-run edit: **16 lost, 46 gained, 6 short flips** — the same lists both times. The lost are
  `docs/state.md`'s rewritten WHERE block (*the Blacksmith*, *UPGRADES*, *from the zone boss*, ID's titles, …) and one word of
  `CLAUDE.md`'s (*panels*, a key in `check_id`'s own measurement); none is a pin the four gates that open `docs/state.md` hold, and
  each is a needle its gate reads off another file. The six short flips: the ✦ that left `docs/master.html` (twice — the Empower
  toggle's two mentions), and four in `docs/state.md` and the archive (*px*, *ab.*, *-20*, a blank-line run) that no gate reads there.
- **The reference claims re-read (HY §6)** over every name IE's diff touches, in both references: 18 lines of
  `docs/instrument-rules.md` and 3 of `docs/combat-rules.md` carry one. **None was false**; one is IE's own (the walkers' helper presses
  *Let it go*), and the two rules §0.5 and §0.6 record are IE's.
- **The chip sweep (§2a's kept census)**: 35 `add_status` calls (32 in `battle.gd`, 3 in `unit.gd`, of the 29 scripts walked), each literal id with its readers — the rule, the command
  and the output are §2a's.
- **The glyph sweep** is `check_id` §3a's, extended: every ✦ in the game's code a rune's mark or a rune count, seven lines, the loadout
  panel's two named as IE's finding.

### §8g — THE PRE-PASS AND THE ACCEPTANCE RUN

**The 63 document readers first** — every target that opens a document, IE's derivation and ID's list together: on the final
documents in two isolated clones (*docsubA*, *docsubB*), each proved equal to the tree, every one at its row and none with an error —
but `check_de` alone, which reads the battery's manifest and reds by design where no battery ran. Two documents moved after those
copies were taken (`docs/state.md`'s instruments line and the changelog's checks paragraph — the records of §8c); every gate literal
against both, copy against tree, read **0 flips**. The gate-file walkers ran again after `check_di`'s and `test_batch_bw`'s edits, alone
on the final tree — twelve, each at its row. **Then the pre-pass and the acceptance, predicted before either launched**: `check_de`
597 / 0 / 0 — four checks a target at 145 — every target at its row.

**The pre-pass**: an APFS clone proved equal to the tree (529 files, the project name aside), its own user folder seeded from the
backup, 145 targets, 12:37:55 to 13:57:06 — **`check_de` 597 / 0 / 0**, its copy byte-identical after. **The acceptance in the
repository**: 145 targets, 12:51:56 to 14:11:14 — **79 min 18 s** — **`check_de` 597 / 0 / 0, as predicted**: `check_ie` 70 / 0,
`check_id` 210 / 0, `check_hu` 105 / 0, `check_parse` 220 / 0, `check_gp` 469 / 0, `check_di` 44 / 0, `test_batch_bw` 513 / 0,
`check_go` 401 / 0, `check_gx` 1367 / 0, `check_ed` 18 / 0, `check_gw` 76 / 0, `check_gj` 70 / 1 (its sanctioned §4 at *+179 / 199*),
`check_cm_live` 13 / 5 (inside its band), the harness 22 / 382 / 8, `test_batch_an` 6053 and `test_batch_bk` 131 inside their bands (the
pre-pass 6051 and 130), `check_map_screen` complete. **`ps` read by rows every 15 s**: 317 readings and 554 Godot rows across the two
batteries, every one `--headless` and no game window — 241 readings saw two, 72 saw one, 4 saw none (between targets). **The tree was
byte-identical before and after** (529 files, tracked and untracked), and **the player's four files were untouched**.

### §8h — THE CLOSE

**The post-run lines** — `docs/state.md`'s verification line, its two readings, and one correction queued while the tree was
frozen (*the sim's bot never casts a drafted Fireball, Stoke or Cinderfall* overstated it — `check_gp`'s road meets a Cinderfall eight
times — and reads *never a drafted Fireball, and Stoke and Cinderfall rarely*) — were written after the run, the second reading at a
fixed point (the file states its own size: 351,747 B). **Their needle proof**: every gate literal against the copy the battery read
(md5-identical to the frozen tree's) and the final file — one flip, `check_id`'s *RARE* tag gained by the word *RARELY* under
whitespace collapsing, a needle `check_id` reads off the relic screens and never off a document. **The four gates that open
`docs/state.md` and the two manifest instruments, re-run on the final tree in an isolated copy** (*Dawn of Decay IE final*):
`check_es` 57 / 0, `check_fg` 30 / 0, `check_hp` 171 / 0, `check_hx` 39 / 0, `check_ec` 24 / 0, `check_ed` 18 / 0 — each at its
acceptance reading. **The player's four files, re-read at the close**: byte-identical to `../save-backups/IE-20261013-104148` by md5,
`run_save.bin` 42,200 B last written 2026-10-08 09:23 — **nothing has been played for nine batches**. **This report was written
last**, out of the scratchpad, with no template token left. The push and its `ls-remote` check follow the commit that carries it.
