# Batch GN — The four class kits

*Branch `class-merge`, from `1a5781b` (GM). `main` is untouched. **IMPLEMENT ONLY.** The ruling is the designer's
and is transcribed here: every class opens with three guaranteed abilities, inside the slot count. Three game scripts,
the glossary, one new gate, twenty-eight instruments moved with the code, one standing rule, and the documents.*

## NEEDS A RULING

**Only what a player meets, or what blocks the ruled work, is here** (`docs/ways-of-working.md`). The rest is in
`docs/state.md`'s queue.

1. **MAGIC BURST'S NUMBERS ARE PROPOSED, NOT RULED** (§1b). The ruling gave *40% of Attack in arcane, applies
   Elemental Weakness*. A card needs more than that, so these went in and are live until ruled: **25 Mana, cooldown 2,
   initiative 3.0, 15 Break damage, a Perfect of 46% (the ordinary x1.15, no bonus of its own), tags DEBUFF and
   BREAK**, and the card text *"Leaves the target with Elemental Weakness for 3 turns: 15% less resistance to every
   school but physical. A second cast refreshes it."* The Break damage is the one a reader might not expect: the
   ruling's line for Mocking Blow names no Break damage either, and Mocking Blow carries 15.
2. **ELEMENTAL WEAKNESS IS A RESISTANCE CUT, NOT A DAMAGE MULTIPLIER** (§2). The ruling says *+15% damage taken from
   all non-physical attacks*. The retired status cut the victim's resistance to every school but physical, and the
   brief said to take the retired definition's mechanism where it had one — so the cut was taken, at the ruled 15
   points and 3 turns. **The two readings agree on an enemy that resists nothing** (x1.148 to x1.150 measured, the
   spread is rounding) **and part where it resists or is weak**: at +30% resistance the cut pays x1.212 where a
   multiplier pays x1.15, and at −20% it pays x1.124. Which is meant is the designer's; the cut is one line to change.
3. **ITS COVERAGE IS THE STRIKE LOOP ALONE** (§2c). Like Exposed, it deepens an attack or ability that strikes through
   `_resolve`'s strike loop. **Seventeen other non-physical reads do not see it**: the poison and burn ticks, Arcane
   Arrows' splash, Arcane Echo's repeat, the Ruin detonation, a sprung trap, a shadow payout in the damage door, and
   the ten handlers that compute their own damage (Cinderfall, Winter's Toll, Killing Frost, Pyre Wake, Requiem,
   Cull, Harvest, Wildfire, Reprisal, Suffering). **Unmaking zeroes the victim's resistance** and so ignores it. The
   glossary entry says which kinds are not deepened.
4. **THE CLERIC'S CLASS POOL IS THREE CARDS** (§3). A Cleric who takes Sanctity drafts his whole run from Chastise,
   Exhortation and Undying Vigil. The brief expected four; the pool held six, not seven, before the picks.
5. **FOUR KIT CARDS WERE REWORDED, AND THE WORDS ARE THE BATCH'S** (§1c): Nexus Ward *"20% of the Mage's maximum
   health"*, Tripwire *"even those striking another ally"*, Consecration *"Bless the ground underfoot"*, Powershot
   *"allies break them"*. No number moved.
6. **NEXUS WARD CONTAINS THE `Ward` STATUS LABEL** (§6, the name sweep). A label collision ships and is flagged; the
   rename is one string if the designer wants it.

## THE SHORT VERSION

- **Every class opens with three guaranteed abilities after its basic attack**, whatever engine its hero takes,
  holds or drops, and they count against the slot cap. **Warrior:** Crushing Blow, Bloodlust, Mocking Blow.
  **Mage:** Magic Burst (new), Nexus Ward (Magic Barrier, renamed), Magic Missiles. **Cleric:** Ministration,
  Unburden, Consecration — **no damage card, by ruling**. **Hunter:** Powershot, Snare Trap, Tripwire.
- **All twelve were cast by a hero holding no engine**, and what each promises was read off the board (§1d).
- **A card a lineage already opens with is held once and counted once** — four lineages, six cards (§3b).
- **Elemental Weakness is filled**: Magic Burst lays it, the six non-physical schools land harder on it, physical does
  not, and the glossary entry is back (§2).
- **A spine-taker opens with four abilities, not one**, driven from class selection into his first battle (§1e).
- **What the picks cost**: the Mage pool 7 → 5, the Cleric's 6 → 3; the draft 154 → 149. Heroes open at 3 to 6 of 7
  slots (§3).
- **The bot has a class branch**, and a live autoplay stretch cast all twelve (§4).
- **New gate `check_gn`**, 170 checks, armed against HEAD and three injections before it was trusted.
- **Twenty-eight instruments moved with the code**, twenty-seven of them found by running them unmodified against it
  first and one by the pre-pass; `check_gj` §4 is red on
  purpose, because the arm is right and the game is wrong (FOUND AND NOT FIXED).

## §0 — THE BRIEF'S PREMISES

Each was checked against the code before anything was written.

| the brief says | the code says | verdict |
|---|---|---|
| a spine-taker opens with his basic alone | `opening_kit` for an empty lineage returned the class basic and nothing else | **held** |
| three guaranteed abilities, inside the slot count, "the same object" as a protected core | a protected core counts in `ability_slots_used` through `lineage_slots` | **held** — the kit is counted the same way (§3c) |
| all twelve card figures (§1 of the brief) | every figure matches the live definition: Crushing Blow 43% / 20 BD / Sunder 35% 3 turns / +10 Rage; Bloodlust 26% / 18 BD / 30% of missing health / +10; Mocking Blow free, cooldown 1, 27%, the target and one other for 4 turns, +10; Magic Barrier 20% of maximum for 3 turns; Magic Missiles 3 × 12% / 3 BD each; Ministration 20% of THEIR maximum; Unburden every harmful effect and 20% less damage for 3 turns; Consecration 5% of maximum a turn for 4; Powershot 20% / 20 BD / +2% a point of the Break meter; Snare Trap Stunned 1 and Poisoned 4, a boss resisting until Broken; Tripwire 6 turns, 75% of what it dealt | **held** |
| Tripwire: "every melee enemy that strikes **a hero**" | the retaliation block reads any blow an enemy lands on the heroes' side; measured, a blow on a Beastmaster's bear is answered for 75% | **narrower than the code** — the card's *ally* is the code's (§1c) |
| Mocking Blow carries no Break damage (the brief lists none) | it carries 15 | **the brief omits it**; the card is unchanged |
| GG retired Elemental Weakness; deleting its note brings it back | the `retired` string gates the glossary panel and the see-also link, and the status, chip and read site stood | **held** |
| the retired definition may describe "a multiplier and a damage set" | it describes a **resistance cut** on every school but physical, 3 turns, power 20 × `elem_weak_ranks` (a Crushing Blow rider on a talent field nothing writes since FX) | **a set, not a multiplier** (§2a) |
| Flamewave was rejected for laying Burn | not re-checked in code; it is the designer's reason, recorded as given | recorded |
| Warrior pool six, untouched | six | **held** |
| **Hunter pool seven, untouched** | **six** (Field Dressing, Camouflage, Aimed Volley, Bola, Hunter's Mark, Arcane Arrows) | **false** — untouched either way |
| Mage pool seven → five; Magic Burst authored, so two leave | seven → five | **held** |
| **Cleric pool seven → four** | **six → three** | **false** |
| a Berserker would hold Bloodlust twice, a Sharpshooter Powershot twice | both, **and two more lineages**: the Warden holds Mocking Blow and Crushing Blow, the Survivalist Tripwire and Snare Trap | **half the population** (§3b) |
| **"GL measured a Vanguard-taker at 3 of 7 and a Berserker at 6 of 7 before this batch"** | before GN a Vanguard-taker opened at **0** and a Berserker at **3**; GL's 3 and 6 were its projections for a kit of three with no overlap, and with the dedupe a Berserker opens at **5** | **false** (§3c) |
| the bot casts five candidates only in the Warrior's engine branches, and Powershot, Tripwire and Mana Shield never | confirmed | **held** |
| **"three of the twelve are in that list"** | **four**: Bloodlust and Mocking Blow (engine branches only), Powershot and Tripwire (never) | **false** (§4a) |
| Shieldwall's chip and Charge's Daze are not in the twelve | neither is | **held** — and each pick was checked for the queued kinds (§1c) |

## §1 — THE TWELVE

### 1a. What was built

- **`Classes.CLASS_KITS`** names three abilities a class. `class_kit_names`, `class_kit_holds` and `class_kit` read it;
  `class_kit` resolves each name through `pool_ability`, the one resolver.
- **`Classes.opening_kit`**, the one builder of what a hero opens with (the battle spawn, the hero sheet,
  `Runes.kit_names`, the class-selection card and `Run.opening_kit_names` all read it), appends the kit after the
  lineage's cards and before another engine's enablers, and **skips a card the lineage already holds**
  (`_kit_holds`).
- **`protected_names`** names the kit, once, so no kit card can be benched: `Run.unequip_earned_ability` refuses
  anything not earned, and `check_gn` §0 drives the refusal beside an earned card that benches.
- **`ability_corpus`** walks `class_kit` beside the class pools, so the corpus reads **228** — Magic Burst is the one
  card added, and the five that left their pools are reached through the kit.
- **No card has two definitions.** The six cores stay in their lineages' `spec_abilities`; the five class-wide cards
  stay in `draft_ability`; **Magic Burst** is defined in `class_kit_ability`, which `pool_ability` consults after the
  draft.

### 1b. Magic Burst

`class_kit_ability("Magic Burst")`: arcane, **40% of Attack** (ruled), 25 Mana, cooldown 2, initiative 3.0, 15 Break
damage, Perfect `{atk:46}` (proposed — NEEDS A RULING 1). A rider in the strike loop lays Elemental Weakness on
whatever it struck and did not kill (§2). Tagged DEBUFF and BREAK: BREAK is never a primary (FD §2), and the card is
for the weakness.

### 1c. The rename, and the wording each pick carried

- **Magic Barrier is Nexus Ward** everywhere a player reads it: the card, its tag row, the recast glossary entry, the
  class-wide glossary entry (which now names Mirror Image as its example) and the ward's log line, which reads
  `ab.display_name`. The handler id stays `magic_barrier`; nothing reads a name there.
- **The brief's rule: queued wording defects stay queued unless a kit card carries one.** Each of the twelve was read
  against GL's and GM's queued kinds and against the code:
  - **Every Perfect a kit card advertises is paid**: Crushing Blow's +5 Break damage, Bloodlust's 45%, Mocking
    Blow's fifth turn, Magic Missiles' fourth bolt (`perfect_extra_hit`, default on) and Ministration's 26%.
  - **A pronoun on a card is a queued kind** (GM queued Hold Breath's *"your"*), and three kit cards carried one:
    Nexus Ward *"your maximum health"*, Tripwire *"your allies"*, Consecration *"the ground you all stand on"*.
    **Powershot's flavour said *"the team"*** — a third word for the heroes' side, which `CLAUDE.md` rules out. All four
    were reworded, every line under 44 characters, no number moved; `master.html`'s copy of Powershot's text moved
    with it.
  - **Tripwire's *ally* was measured before it was kept**: a Beastmaster holds Tripwire since GN, and a melee blow on
    his summoned bear was answered for 75% (the bear lost 20, the enemy 15), as a blow on a hero was (22, 16).
  - **Found and left** (not queued kinds): Tripwire's card does not state its 75% (the chip does); Nexus Ward's
    *"It eats a share of EVERYTHING"* describes an ordinary barrier.

### 1d. The twelve, driven on heroes holding no engine

`check_gn` §1 seats four heroes with no lineage and empties their engines, then casts each card through
`battle._resolve` and reads the board:

| card | measured |
|---|---|
| Crushing Blow | 33 damage; Sunder for 3 turns, armour 0.150 → 0.098; Rage 50 → 40 |
| Bloodlust | 21 damage; healed 27 of 93 missing; Rage 50 → 35 |
| Mocking Blow | cost 0; 20 damage; two enemies held for 4 turns; Rage 0 → 10 |
| Nexus Ward | a 20-point ward (20% of 99) for 3 turns; a 128 blow reached him for 108 |
| Magic Missiles | 31 damage, 9 Break damage |
| Ministration | the Warrior regained 31 of his 154 |
| Unburden | two afflictions lifted; the same blow landed 100 unburdened and 125 without |
| Consecration | four heroes blessed for 4 turns; each tick 5% of the hero's own maximum |
| Powershot | 153 on an empty meter, 306 on a meter at 50 |
| Snare Trap | sprung on the enemy's turn: Stunned (the log's *"is stunned and loses their turn"*) and Poisoned |
| Tripwire | 6 turns; a melee blow of 27 answered with 20; a ranged blow passes |
| Magic Burst | 35 damage; Elemental Weakness 15 for 3 turns, stamped with the Mage (§2) |

### 1e. The spine-taker, from class selection into his first battle

`check_gn` §3 opens the real class-selection screen, takes Momentum, Channel and Sanctity for the three heroes who have
one, presses through to the map and into the first fight. **Each opens with four abilities**: the Warrior Strike,
Crushing Blow, Bloodlust, Mocking Blow; the Mage Magic Bolt, Magic Burst, Nexus Ward, Magic Missiles; the Cleric
Smite, Ministration, Unburden, Consecration.

## §2 — ELEMENTAL WEAKNESS IS FILLED, NOT CREATED

### 2a. The retired definition, read first

- **The status `elem_weak`** had its chip (`STATUS_INFO`: *"Elemental resistances reduced."*), a place in
  `DEBUFF_IDS`, and **one read site in the strike loop**: `if ab.dmg_type != "physical" and
  strike_target.has_status("elem_weak"): resist -= status_power / 100`.
- **Its only applier** was a Crushing Blow rider paying `20 × elem_weak_ranks` for 3 turns, and nothing has written
  `elem_weak_ranks` since FX. GG retired the glossary entry for that reason.
- **Against the ruling**: the damage SET matches (every school but physical); the DURATION matches (3 turns); the
  MECHANISM differs (a resistance cut, not *+15% damage taken*); the MAGNITUDE differs (20 a rank, not 15).
  **Taken: the set and the mechanism from the retired definition, 15 and 3 turns from the ruling.**

### 2b. What was built

- **One door, `battle._apply_elem_weak(target, pct, turns, src)`**: `_apply_status` with the power, then the chip
  rewritten only when the new power is at least the standing one (CP §0's clamp — `update_status` assigns), then
  `_note_debuff_applied`. **`ELEM_WEAK_PCT` = 15, `ELEM_WEAK_TURNS` = 3.**
- **Magic Burst's rider** calls it for whatever the strike hit and did not kill. **The dormant Crushing Blow rider**
  calls it too, unchanged in magnitude, and stays dormant.
- **Element-blind by construction**: the read asks whether the blow is physical and nothing else, and no kit card
  reads an engine.
- **The glossary entry is back**: the `retired` string is deleted and the text names Magic Burst, the 3 turns, the 15%,
  and what is not deepened.

### 2c. Driven — a non-physical hit pays and a physical one does not

`check_gn` §2, one seeded pair per school on a foe with its resistance set, the weakness laid by the real door:

| school | card | plain | weakened | ratio |
|---|---|---|---|---|
| arcane | Magic Bolt | 216 | 248 | x1.148 |
| fire | Fireball | 173 | 198 | x1.145 |
| frost | Frostbolt | 173 | 198 | x1.145 |
| shadow | Shadowrend | 216 | 248 | x1.148 |
| holy | Smite | 380 | 437 | x1.150 |
| nature | Loaded Shot | 173 | 198 | x1.145 |
| **physical** | **Strike** | **179** | **179** | **x1.000** |
| arcane at +30% resistance | | 151 | 183 | x1.212 (the cut predicts x1.214) |
| arcane at −20% resistance | | 259 | 291 | x1.124 (predicted x1.125) |

**The seed is laid after the weakness**, because laying a status draws from the global dice. The coverage (NEEDS A
RULING 3) is read off the source: the strike loop is the one read site, and the seventeen other non-physical
resistance reads are `_run_battle`'s poison and burn ticks, `_arcane_arrow_splash`, `_arcane_echo_repeat`,
`_detonate_ruin`, the `cinderfall`, `winters_toll`, `killing_frost`, `pyre_wake`, `requiem`, `cull`, `harvest`,
`wildfire`, `reprisal` and `suffering` handlers, `_spring_trap` and `_on_damage_taken`.

## §3 — WHAT A PICK COSTS

### 3a. The pools, derived

| class | before | after | left |
|---|---|---|---|
| Warrior | 6 | **6** | — |
| Mage | 7 | **5** | Nexus Ward (Magic Barrier), Magic Missiles |
| Cleric | 6 | **3** | Ministration, Unburden, Consecration |
| Hunter | 6 | **6** | — |

**The class-wide half is 20 and the draft 149 of 149** (129 spec + 20). No card was deleted: the five resolve and are
in the corpus through the kit, and no kit card is in a draft or boss pool (`check_gn` §0).

### 3b. The dedupe, and where

`opening_kit` skips a kit card the lineage already opened with, and `kit_slots` counts the kit less the lineage's own
cards. **The population was derived, not taken from the brief**, and `check_gn` §0 pins it:

| lineage | shares |
|---|---|
| Berserker | Bloodlust |
| Warden | Mocking Blow, Crushing Blow |
| Sharpshooter | Powershot |
| Survivalist | Tripwire, Snare Trap |

### 3c. What each hero opens at, of 7

`Run.ability_slots_used` = `lineage_slots(spec)` + `kit_slots(class, spec)` + the carried earned cards. Before GN is
HEAD's code, measured.

| hero | before GN | after GN |
|---|---|---|
| Berserker | 3 | **5** |
| Warden | 3 | **4** |
| Swordmaster | 2 | **5** |
| Momentum (no lineage) | 0 | **3** |
| Pyromancer | 2 | **5** |
| Cryomancer | 2 | **5** |
| Arcanist | 3 | **6** |
| Channel (no lineage) | 0 | **3** |
| Holy | 2 | **5** |
| Devout | 1 | **4** |
| Occultist | 2 | **5** |
| Sanctity (no lineage) | 0 | **3** |
| Beastmaster | 2 | **5** |
| Sharpshooter | 3 | **5** |
| Survivalist | 3 | **4** |

**An Arcanist has one slot to draft into at the first rung**, and a spine-taker four. The ladder adds one a zone boss.
**GL's figures were projections, and it said so** — *"lineage_slots + 3, no overlap"* (`docs/kit-recon.html`). Every
one of its fifteen holds but the four lineages that share a card: it had the Berserker, the Warden, the Sharpshooter
and the Survivalist at 6, and the dedupe opens them at 5, 4, 5 and 4.

## §4 — THE BOT

### 4a. What it did with each of the twelve before GN

| card | HEAD's bot |
|---|---|
| Crushing Blow | the Warden rotation, and the generic Warrior policy |
| Bloodlust | the Berserker rotation only |
| Mocking Blow | the Warden rotation only |
| Magic Burst | — (did not exist) |
| Nexus Ward, Magic Missiles | only as drafted filler (`_bot_drafted_pick`) |
| Ministration, Unburden, Consecration | only as drafted filler |
| Powershot, Tripwire | **never** |
| Snare Trap | keyed on the card, for any Hunter |

### 4b. The class branch

**`battle._bot_class_kit_pick(u)`** sits where the drafted hook sits and one step above it: it is consulted only when
the engine rotation came back with the basic attack, so no rotation was re-weighted. `_bot_drafted_pick` skips kit
cards, so the class branch is the one place the bot decides them. **`_bot_kit_card` asks `_ability_usable`**, the
player's door. Each card is cast when it has something to do:

| card | the bot casts it |
|---|---|
| Bloodlust | below half health, at the mark (a Broken enemy first, else the lowest) |
| Mocking Blow | when no enemy is already held to him |
| Crushing Blow | when the mark carries no Sunder |
| Nexus Ward | when he has no barrier and is under 60% or faces three or more |
| Magic Burst | at the healthiest enemy not already weakened |
| Magic Missiles | at the mark, otherwise |
| Ministration | on the lowest ally under half; later, on the lowest under 80% |
| Unburden | on the lowest ally carrying a cleansable affliction |
| Consecration | when two allies are under 80% and none is blessed |
| Tripwire | when none stands and a melee enemy does |
| Snare Trap | at the mark (a Lethal Aim holder's own mark) if it is not snared |
| Powershot | at that mark, otherwise |

### 4c. Driven

`check_gn` §4 builds a board for each card and asks the branch: **it names all twelve**, a Cleric with nobody hurt or
afflicted names nothing, and the drafted hook never names a kit card. **A live autoplay stretch** — the real turn loop,
the heroes held under half health and now and then Crippled — **cast all twelve in 123 frames.** With the branch
unwired (a control), the same stretch cast two of twelve (Crushing Blow and Snare Trap).

## §5 — NOT DONE, AS RULED

No engine rune authored, nothing for the Crown's Break and freeze resistance, no pool merge, talent node or rune
cost. **`data/runes.json` needed nothing**: no live rune names, grants or reads a card that moved, and the engine runes
carry no payload. The queued wording defects stay queued (§1c for the kit's own).

## FOUND AND NOT FIXED

- **PLAYER-FACING: THE VICTORY CARD LEAVES OUT THE TOLLKEEPER'S BELL.** Both victory cards print `Run.award_gold`'s
  figure, and the Bell's +20 is paid beside it (`Run.relic_add("victory_gold")`), so a party holding the Bell is told
  20 less than its purse gained. **`check_gj` §4 caught it this batch**: GN's code moved what the gate's seeded run
  draws, and the run now holds the Bell (a probe printed `active_relics=["tollbell"]`; HEAD's run held none) — card
  +178, purse +198. **HEAD's code with the Bell forced reds the same arm the same way** (card +157, purse +177), so it
  predates GN. The fix is one expression; it is outside the brief, so the red is sanctioned in `baselines.json`.
- **`check_fh` §3 counted the pouch alone**, and an elite cache can deal an engine rune, which takes an engine slot.
  GN's seed dealt one first and the arm read "no rune arrived". Repaired to count both; the gate prints which kind.
- **`check_ea` §1 prices a hero's earnable slots as `cap - core_slots`**, which no opening has read since GK; its floors
  are conservative and its verdict holds.
- **Mana Shield is still never cast by the bot** (GM's item); the class branch covers kit cards only. Wildstrikes,
  Shieldwall and Guard Change are not kit cards and stay engine-only.
- **An Occultist can no longer stack five draftable cards on any tag but DEBUFF** — the Cleric pool lost its three
  DEFENSE cards — so `check_fn` §4 builds his failing bar from two.
- **The kit hands the baseline role partly to class-wide cards** (GL's item 3): the Mage's two and all three of the
  Cleric's were authored as draft fallbacks, weaker than spec cards.
- **Crushing Blow shares its name with the Orc Chief's ability** (`docs/text-audit.html` §CK), and is on every Warrior
  now.

## §6 — INSTRUMENTS

### 6a. The new gate

**`check_gn.gd`, 170 checks** — §0 the kit read, §1 the twelve driven, §2 Elemental Weakness, §3 the spine-taker,
§4 the bot, §5 the player's three files byte for byte. **Every negative anchor has its positive arm**: the physical hit
beside the six that are raised, the moved cards in no pool beside each still resolving, a lineage holding its kit card
once beside holding it, the bench refusing a kit card beside benching an earned one, a melee blow answered beside a
ranged one passing.

**Armed before it was trusted**, in isolated copies:
- **HEAD's game code** carrying only stubs of the names it reads (nothing reads them there): **149 / 114**.
- **A kit card held twice** (the dedupe removed from `opening_kit`): **8 reds**, exactly the four lineages, engine
  held and dropped.
- **Elemental Weakness paying on a physical hit** (the school test removed): **1 red**, *"a physical hit (Strike) is
  not raised (179 and 208)"*.
- **The class branch unwired**: **1 red**, the live stretch naming ten cards never cast.

### 6b. Run unmodified first — the reconnaissance battery

HEAD's instruments over GN's code, before any was edited (10:13–11:02, frozen before and after at 452 stamps:
identical; the saves identical): **111 targets, 0 timeouts; `check_de` 461 / 38 / 5 notices.** Every red was read and
every count movement attributed before a line of an instrument moved (6c).

### 6c. What moved, and why

**Floors that followed the pools** — a floor catches a pool that EMPTIES, and the ruling left the Cleric's at three:
`test_batch_bt`, `bu`, `bv`, `bw`, `cb`, `ce` (six → three), `bo` §4, `bp` §5, `br` §0 (six → three, and the class-wide
half 24 → 20), `check_dr` (24 → 20), `test_batch_cd` (its authoritative tables: Mage 5, Cleric 3, class 20, draft 149,
floor 3).

**Slot fills that now leave room for the kit** — each re-derived off the live opening (`lineage_slots` +
`kit_slots`), so the question each asked is asked again: `test_batch_bo` §2 (a Pyromancer opens at 5; one earned card
takes him to 6, two fill him; the at-the-cap Sharpshooter fills with two), `bp` §7, `bx` §2, `check_eg` §1 and §2,
`check_ez` §3 (carries what fits, at most four), `check_gm` §2(d), `check_map_screen` (holds what fits beside the
Cryomancer's five), `test_batch_ah_battle` (the earned class card is Warcry, a card the pool holds; eight abilities with
Bloodlust once), `test_batch_ak` (a Swordmaster opens with seven).

**The rename and the moved cards** — `test_batch_bq` (Nexus Ward; each of the twelve in its pool or its kit, never
both; §6 asks whether every spec OPENS with the card; the refused-card arm stands on Mirror Image; the live drives
take kit cards off their grant lists; Blink's drafted card is Mirror Image; the archived BQ entry read through
`SHIPPED_AS`), `check_cv` (its name list, which prints only).

**Derived walks** — `check_cz` §0's set identity takes the class-kit cards no pool or lineage holds beside the four
overrides, derived off `CLASS_KITS`; `check_es` §4 reads the spawn's kit through `opening_kit` rather than a pre-GK
copy of it; `check_dv` §5 counts the new kit as a class kit (43 → 37 — the six lineage cores the kits name left the
population, and none of the six new kit cards joined it); `check_fd` §2 and `check_fe` §1 compare the tag table to
the corpus rather than to 227.

**Two pins moved with the code** — `check_dj` (the `is_companion`-over-`heroes` idiom 25 → 26: the class branch walks
`heroes` the way the drafted hook does) and `check_fn` §4 (`SHORT_BAR`: an Occultist's single-tag bar is two).

**Two gates repaired to their question** — `check_fh` §3 (a rune arrives in the pouch or an engine slot) and
`test_batch_cb` (master.html's draft count in words, *"a hundred and forty-nine"*).

**The documents' census figure** — `check_es` §4 reads *"DEBUFF for seven"* now in `master.html`, `CLAUDE.md` and
`state.md`: the kits put Crushing Blow and Mocking Blow on every Swordmaster and Snare Trap on every Beastmaster.

**Each repaired target was run against HEAD's code too** (the stubbed copy): the derived repairs pass there
(`check_eg`, `check_es`, `check_ez`, `check_fd`, `check_fe`, `check_fh`, `check_gm`, `check_map_screen`), and the
repairs that encode GN's change red there in its direction (`check_cz` 2, `check_dj` 1, `check_fn` 1, `bo` 8, `bp` 1,
`bq` 16 and the throw on `pool_ability("Nexus Ward")`, `cd` 8, `ah_battle` 1, `ak` 1, `check_gn` 114).

### 6d. Count movements, attributed

| target | moved | why |
|---|---|---|
| `test_batch_ah` | 5584 → 5554 | its curation walk asks six things of each class-pool card; five left |
| `test_batch_ak` | 339 → 334 | a resolve loop over the class pools |
| `test_batch_ar` | 512 → 510 | a resolve loop over the Mage pool |
| `test_batch_br` | 1590 → 1525 | 5 × 12 spec pools, and 5 in its reprice walk |
| `test_batch_cb`, `ce` | −5 each | a no-duplicates walk over the class pools |
| `test_batch_bq` | 883 → 823 | 5 × 12 spec pools; the repaired suite otherwise asks what it asked |
| `test_batch_ah_battle` | 67 → 69 | a hotkey per menu slot, and the Berserker's bar is two longer |
| `test_batch_az` | 450 → 452 | a Sharpshooter's bar walk: Snare Trap and Tripwire |
| `test_batch_ba` | 703 → 704 | a Survivalist's bar walk: Powershot |
| `check_fh` | 163 → 165 | the bench overlay's protected names: the Berserker's two new |
| `test_batch_an` | band +30 | three modifier arms × the ten kit cards its party gained |
| `check_parse` | 185 → 186 | `check_gn.gd` joined its population |
| `check_gn` | new | 170 |
| `check_de` | 461 → 465 | four assertions for the new target (no row) |

**The four rises and `test_batch_an` were attributed by a diff, not a subtraction**: `ok()` was instrumented to print
its message in isolated copies of HEAD's code and GN's, and the two message populations were diffed. `test_batch_an`
read 6053 on HEAD and 6083 on GN; the thirty added messages are exactly the ten cards under Warded, Slick Footing and
Encumbered, and its drift (22 map-budget and rest-slot lines each way) netted zero in that pair.

### 6e. The name sweep (BR §1)

**1,309 names in fifteen populations** — abilities (228), talent nodes (27), status ids (156) and labels (153),
items (16), relics (50), specs, classes and engines (38), tags (7), archetypes (9), runes with the retired (284),
rune lanes (36), enemies (21), enemy abilities (48), glossary terms (196), events (40):

- **Magic Burst**: 0 exact, 0 contained, 2 sharing a word — Magic Bolt, Magic Missiles.
- **Nexus Ward**: 0 exact, **2 contained** — the `ward` status id and its `Ward` label — and 3 sharing a word: the
  Ironbark Ward relic and the retired Triage Ward rune (id and name). NEEDS A RULING 6.

## VERIFICATION

### The saves

**Backed up before anything was written** — `save-backups/GN-20260917-100620/` — and verified by hash, each equal to
the live file and to GM's: `profile.json` `b05e329b…`, `relics.json` `fdc12ffa…`, `run_save.bin` `c44d45da…`,
`settings.cfg` `0c1b39c3…`. **Re-hashed after the reconnaissance battery: identical.** **Re-hashed after the pre-pass and the acceptance run: identical every time.** Every probe and
control ran in a copy whose `user://` was renamed away from the player's.

### The parse floor

- **`check_parse` over the finished tree: 186 / 0**, its stream carrying no `Parse Error`.
- **Across the reconnaissance battery's 111 logs**: 0 `Parse Error`, 0 `Compile Error`, 0 `Failed to load`; one
  `SCRIPT ERROR`, `test_batch_bq`'s `pool_ability("Magic Barrier")`, which the rename explains and the repair removes.
- **Across the pre-pass's and the acceptance run's 112 logs each**: 0 `Parse Error`, 0 `SCRIPT ERROR`, 0 `Compile
  Error`, 0 `Failed to load`, 0 `Invalid access`.
- **It runs:** the gates that walk whole runs through the real screens (`check_fh`, `check_gf`, `check_gj`) complete
  in every battery, and `check_gn` §3 walks class selection into a first battle.

### Before the documents and instruments landed

- **The literal sweep** (GM's: every string literal of four characters or more in every root and `scripts/` `.gd`,
  comments stripped; raw, lowered and flattened; **proved first** — deleting a needle `check_dv` holds read LOST 1 in
  all three forms, unchanged copies 0), each document against HEAD:
  - `CLAUDE.md`, `docs/changelog.html`, `docs/design-notes.md`: **LOST 0**.
  - `docs/master.html`: LOST `Magic Barrier` (read by no instrument against that file), the word reader's own
    self-test phrases in `check_fs`, and **`hundred and fifty-four`, which `test_batch_cb` reads there** — re-pointed
    to *"a hundred and forty-nine"* before the battery.
  - `docs/state.md`: LOST seven words GM's WHERE block carried, none read against that file.
  - `data/glossary.json`: LOST five, none read against that file.
  - **No gained needle sits in a negative check.**
- **`pin-manifest.json` regenerated**: 1,470 pins, the same residencies as HEAD's; `--check` current.
- **Standalone on GN's code before the battery**: `check_gn` 170 / 0 (and 170 / 0 again after its stretch was
  reordered to answer the parked turn before the bot takes over, which removed a fallback warning), `check_parse`
  186 / 0, `check_fn` 80 / 0, `test_batch_bq` 823 (its one red the copy's HEAD `master.html`), `check_ez` 106 / 0.

### The pre-pass — every target, with the new gate, the repairs and the documents in the tree

11:34–12:22, frozen before and after at 489 md5 stamps with absolute paths — every tracked and untracked file but
`.git` and `.godot` — and the four saves stamped beside them: **identical**.

| | read |
|---|---|
| targets | **112 / 112 unique / 0 timeouts / 0 incomplete** — 46 suites, 60 gates, the harness's three, both scenes and the differ |
| suites | **45 of 46 green**, every count at its row; `test_batch_an` **6,082**, inside its new band; **`test_batch_bx` 156 / 2** (below) |
| gates | **57 of 60 green** — `check_gn` **170 / 0**, `check_parse` **186 / 0**, `check_fh` **165 / 0** (its cache dealt *the Rune of the Invoker*, an engine rune, which took an engine slot), `check_fn` 80 / 0, `check_es` 57 / 0 (`state.md` 2 claim windows, 4 figures); **`check_ek` 47 / 1** (below); **`check_gj` 70 / 1**, its one FAIL line the Bell's; **`check_cm_live` 13 / 4**, its FAIL lines word for word GM's |
| harness, scenes | 22 / 382 / 8 PASS; `check_map_screen` **OK** (2 held, 1 carried; the census moved on the swap); `check_ct_map` 83 / 0 |
| `check_de` | **465 / 2 / 0** — the two reds below, and **every predicted row held**, `test_batch_an`'s band included |
| error lines across the 112 logs | **0** of each |

**Two reds, both the batch's, neither predicted:**
- **`test_batch_bx` §2 filled a SECOND capped hero off `lineage_slots` alone** — the party-draft screen's, sixty lines
  below the fill that was repaired — and the reconnaissance battery's third `bx` red had come from there, not from the
  first. **And §4b caught the retired word *party* in `master.html`**: the Cleric band of §6b said *"the party heal"*.
  **The retired-word pre-check was not run before the pre-pass**, which is the pre-check that exists to catch exactly
  this; the pre-pass did its job instead.
- **`check_ek` §3 lists the gates that name the tag surface by name, and `check_gn` §0 reads two tag rows** — the
  seventh batch running to meet this list by adding a gate.

### Between the two

- **`test_batch_bx` §2**'s second fill reads the live opening (`lineage_slots` + `kit_slots`).
- **`master.html`**: *"the plain heal, the heal for every hero and the cleanse are every Cleric's class kit"*.
- **`check_ek`**: `check_gn.gd` in `TAG_CHECKERS`, with its paragraph.
- **`check_map_screen`**'s capped hero is filled to the cap off the live opening; the old fill left him two over it,
  which read green because a full kit is `>=`.
- **`docs/state.md`**: the last measurements, and `check_gj`'s red beside `check_cm_live`'s under THE REST.
- **Swept against the copies the pre-pass read**: `master.html` LOST 0 and GAINED 0 in all three forms;
  `state.md` LOST 0, GAINED *"Tollkeeper's Bell"* (read against nothing) and, lowered only, a phrase
  `test_batch_bb` asserts absent from `battle.gd`'s tooltips.
- **Standalone on the tree**: `test_batch_bx` 156 / 0, `check_ek` 47 / 0, `check_es` 57 / 0, `check_fs` 33 / 0,
  `check_map_screen` OK; `pin-manifest.json` still current.
- **`baselines.json`**: the obs of the moved rows counted the readings they rest on; no band moved.

### The acceptance run

**Predicted in writing before its launch (12:29:30)** and run from 12:29:45 to 13:18:39, frozen before and after at
489 md5 stamps with absolute paths, the four saves stamped beside them.

| | read |
|---|---|
| what was in the tree | GN's code, instruments, `baselines.json` and `pin-manifest.json`, and the documents as landed, but for the one wording fix below |
| targets / timeouts / incomplete | **112 / 0 / 0** — 112 lines in `.ran`, 112 unique, 112 logs |
| suites | **46 of 46 green**, every one at its row; `test_batch_an` **6,083**, inside [6,076, 6,093]; `test_batch_bx` **156 / 0** |
| gates | **58 of 60 green**: `check_gn` **170 / 0**, `check_parse` **186 / 0**, `check_fh` **165 / 0** (the Invoker's rune again), `check_ek` **47 / 0**, `check_es` 57 / 0, `check_fn` 80 / 0; **`check_gj` 70 / 1**, its one FAIL line the Bell's (sanctioned); **`check_cm_live` 13 / 4**, its FAIL lines word for word GM's acceptance run |
| run harness (gates 1 / 2 / 3) | **22 / 382 / 8 PASS**, 0 throws |
| scene runs | both complete; `check_map_screen` **OK**; `check_ct_map` **83 / 0** |
| `check_de` | **465 checks / 0 failures / 0 notices** |
| error lines across the 112 logs | **0** `Parse Error`, **0** `SCRIPT ERROR`, **0** `Compile Error`, **0** `Failed to load`, **0** `Invalid access` |
| the documents, as the gates read them | `check_fg`: the changelog at **352,340 B**, under the 400,000 B bar; `CLAUDE.md` at **342,824 B = 334.79 KiB**, 5,336 B under its 340 KiB ceiling. `check_es`: `master.html` and `CLAUDE.md` 1 claim window each, `state.md` 2 — 8 figures, every one the census's |
| the freeze | **489 stamps before and after — identical**; the four saves `b05e329b` / `fdc12ffa` / `c44d45da` / `0c1b39c3` before and after |
| against the pre-pass | identical but the two repaired reds, `check_de` 465 / 2 → 465 / 0, and the two known drifters inside their bands (`test_batch_an` 6,082 → 6,083, `test_batch_bk` 129 → 130) |
| against GM's acceptance run | exactly the rows `baselines.json` moved: `ah`, `ah_battle`, `ak`, `an`, `ar`, `az`, `ba`, `bq`, `br`, `cb`, `ce`, `check_parse`, `check_fh`, `check_gj`'s one red, `check_gn` new, `check_de` 461 → 465 |

**Every prediction held.**

### After the run

**One wording fix, in two documents**: the changelog and `state.md` said *twenty-seven* instruments where the count is
twenty-eight (`check_ek`'s list moved between the runs). **Swept against the copies the acceptance run read: LOST 0
and GAINED 0 in all three forms, in both**; `check_fg` 22 / 0 (the changelog at 352,491 B), `check_es` 57 / 0 and
`check_dv` 83 / 0 standalone on the tree. This report was written after the run; no instrument reads it.

### The push

**Committed and pushed to `class-merge` only**; `main` is untouched. The post-push reading of
`git ls-remote origin class-merge` against local HEAD is reported with the delivery rather than here — written into
this file, it would change the commit it names.

---

## WHAT MOVED

- **Game code:** `scripts/classes.gd` (`CLASS_KITS` and its readers, `class_kit_ability` with Magic Burst,
  `kit_slots`, `opening_kit`, `protected_names`, `ability_corpus`, `pool_ability`, the two class pools, the rename, two
  tag rows, four card texts, three comments), `scripts/battle.gd` (`_apply_elem_weak` and its constants, Magic Burst's
  rider, the ward's log line, `_bot_class_kit_pick` and `_bot_kit_card`, the drafted hook's skip), `scripts/run_state.gd`
  (`ability_slots_used` adds `kit_slots`), `data/glossary.json` (Elemental Weakness back; Mocked, class-wide, slots,
  protected and recast entries).
- **Instruments:** `check_gn.gd` (**NEW**, 170); twenty-eight moved with the code (§6c, and `check_ek` and the second
  `test_batch_bx` fill between the runs); `check_cv.gd` (its printed
  name list); `run_battery.sh` (`check_gn` in `GATES`); `baselines.json` (fourteen rows moved and one added, a text
  edit); `pin-manifest.json` (regenerated).
- **Documents:** `CLAUDE.md` (a standing rule for the kit, and the sentences the kit made false: the draft count, the
  class floors, the slot sum, the census figure, the authoring example, the shield list, the tag-reach counts),
  `docs/master.html` (the class-kit table and paragraph, each class's kit line, Elemental Weakness's status row, the
  pools and draft counts, §6b's catalogue, Nexus Ward, the census figure, Powershot's text, the stamp),
  `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md` (rewritten: the WHERE block, GN's rulings and
  findings, the class kit and GL's bot item closed, GK's ruling 7, the running order, the census, the live counts, the
  last measurements), and this file (**NEW**).
- **Not moved:** `data/runes.json`, the save format and version, any talent, relic or rune.

## THE FOLDERS THIS BATCH LEFT

- **Three Godot `app_userdata` folders** — `Dawn of Decay GN new`, `Dawn of Decay GN head`, `Dawn of Decay GN ctl`
  (the isolated copies' `user://`, renamed so none could reach the player's). All can be deleted.
- **`save-backups/GN-20260917-100620/`**, untracked, beside every earlier batch's.
- **The copies, probes, traces, sweep scripts, staged documents and battery logs** are in this session's scratchpad,
  outside the repo.
