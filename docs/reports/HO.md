# BATCH HO — THE SUPPLY ROUTE, THE TRAP, AND THE FIRST CREST RUNES

**On `class-merge`, from `d9c4fb8` (HN). IMPLEMENT ONLY.** HN's three rulings are taken: `Forbearance` stays bare,
Elevation's card carries the ruled words and the standing rule that came with it is recorded, and **the
replace-not-add trap is closed** — a hero's config carries every starting value the unit declares, so an effect that
adds to a stat adds to it (§0). **Every roll in the game already offered a crest rune**, so no route was built; three
screens named a hero for one and now say it is for the crest (§1). `heroes_all_standing: false` inverts (§2). **Two
crest runes are authored — *Tithe* at 30% and *Fellowship* at 1, both proposed — and three are not**: *Empty Pulpit*,
*Cold Hearth* and *Gravesong* could not pay in any fight a run played forward opens (§3). `test_batch_bk` §3's flake
is repaired by construction (§4), and the policy for spent test copies is recorded, with HN's eighteen moved to the
Trash (§5). A new gate, `check_ho`, drives all of it.

**VERDICT:** **DONE, AND PUSHED. THREE OF THE FIVE CREST RUNES ARE NOT IN THE GAME — HELD BACK UNDER A STANDING RULE,
FOR A RULING.** HN's three rulings are taken: the trap is closed and driven both ways, and the magnitude it moves on a
saved run is measured on both trees — a heal of 40 lands 28 under the Vampiric Rune and 30 under the Rune of the
Killing Cold, where each landed 0. §1's stop clause did not bind: every roll already offered a crest rune, and what
was wrong was the words on three screens and the sim's counter. `heroes_all_standing: false` inverts. ***Tithe* (30%,
proposed, measured) and *Fellowship* (1) are authored**, offered and taken through the real route and worn through
real fights. ***Empty Pulpit*, *Cold Hearth* and *Gravesong* are specified, driven as fixtures, measured — and not
authored**, because no fight a run played forward opens can meet their conditions. The flake is repaired by
construction; the copies' policy is recorded and HN's eighteen folders are in the Trash. **HEAD's gates read twelve
targets red on the new game and eighteen instruments were re-pointed; fifty-seven controls, one defect each, printed
the line each was aimed at. The pre-pass read one red, and it was this batch's own — the new gate spelled the fight
scene's path — repaired before the acceptance run, which read `check_de` 537 / 0 / 0 over 130 targets in 74 min 12 s,
the prediction exactly.** The tree was byte-identical after it and the player's four files untouched. **Seven rulings
are owed.**

## NEEDS A RULING — SEVEN; THE FIRST THREE ARE PLAYER-VISIBLE AND THE FIRST DECIDES THREE RUNES

1. **THREE OF THE FIVE CREST RUNES WERE NOT AUTHORED (§3c).** *Empty Pulpit* (no Cleric among the four), *Cold Hearth*
   (no Mage) and *Gravesong* (enter a fight with a hero already fallen) each pay only in a state a run played forward
   never opens a fight in. **The draft seats exactly one of each class** — four picks from a roster of four, a hero
   pressed twice is unpicked — and **a hero who falls in a fight that is won stands again at a fifth of his health
   when it ends** (`BattleUnit.sync_victory_state`; the Master Document states it: *"Fallen heroes return after a won
   battle at 20% max HP"*); an event's health cost stops at 1. The one way in is GH's: a
   fight quit after a hero fell, resumed with him down. So as specified each would ship paying nothing to a player who
   plays on and something to one who quits — and a standing rule already answers a rune like that (FK §7: *do not ship
   it and do not re-aim it; report it, price the nearest alternatives, and let the designer choose*). **What would
   make them real, each a ruling:**
   - **Read the heroes as the fight runs** — the continuous half of HK's door 3, which the brief leaves unbuilt (§6).
     *While a hero lies fallen, the rest deal 25% more damage*; *while no Cleric stands, every hero takes 12% less*.
     All three write an additive stat, which is the one kind HL §6 found a reversible stamp well defined for. It is a
     batch of its own (a payload that can be taken back, re-read at a death, a revive and a resumed fight's opening,
     and a tell that it switched), and it changes what the three runes say: they become runes about losing someone
     mid-fight, not about who was recruited.
   - **Let the fallen stay down between fights.** One line (the 20% floor in `sync_victory_state`; control K11 removes
     it and the next fight opens with three of four standing), and a first-order change to how hard a run is: at rung
     2 with no talents heroes fall about 0.5 to 0.9 times a normal fight (§3a, §3b), and the map's screens are written
     for four heroes on their feet (the Master Document's elite draft says so). It makes *Gravesong* real as written
     and does nothing for the other two. **And it would wake two things the game already holds for that state, which
     cannot happen today either (§8)**: the event *The Cairn of the Fallen*, which asks for a fallen hero and raises
     him, and a Revive Potion used from the map.
   - **A roster that can leave a class out.** It makes *Empty Pulpit* and *Cold Hearth* real as written. It is not a
     batch: at least four standing rules rest on one hero a class (the card gate's holder, the Shared Mark's reach,
     the pet, the sim's fixed seats).
   - **Leave them unauthored.** `check_ho` §2 holds the two facts and goes red, saying the runes can be authored, the
     day either changes.
   What each would pay is measured all the same (§3c): 12% less damage taken is about a sixth of what a Cleric
   supplies.
2. **TITHE AT 30% IS A FIRST GUESS, AND ITS WORDS PROMISE A LITTLE MORE THAN ITS RULE PAYS (§3a).** At rung 2 with no
   talents it lands about 12 health a round on the lowest hero — 6% of that hero's bar — and heroes fall 0.38 times a
   normal fight in zone 1 against 0.54 without it. 20% could not be seen in deaths and 40% more than halved them.
   **The rule it pays through reads the Break an ordinary blow APPLIES**: about 41 a round of the 47 to 69 the heroes
   deal. The Long Watch's carry, a card's own Break, a trap and a companion pay nothing, and neither does a blow into
   an enemy already Broken — so *the Warrior's Break lane* adds nothing to it. The card says *every hero's Break
   damage*. Either the words narrow, or the read site widens — and the read site is the talent *Breaking Heals a
   Hero*'s too, so widening it moves a talent every class can buy.
3. **FELLOWSHIP AT 1 CLEARS NEARLY EVERYTHING (§3b).** 96% of every debuff that lands on a hero is cleared, 99% of
   those before its bearer acts. As power that is small — about 2% of damage taken in normal fights, and no outcome
   moved outside its error — and the brief says not to raise it; 1 is also the least it can be. **What it switches
   off is the thing to rule on**: the Cleric's Unburden falls from 0.45 casts a fight to 0.01 and the Returned Burden
   rune is starved with it; beside the talent *Cleanse Debuffs Each Turn* it fires zero times; and it would clear a
   hero-side stun before it cost a turn about nineteen times in twenty, the day an enemy is given one. It is also,
   mechanically, the shape HL §4 warns against — one stat stamped on four heroes — whose read site happens to walk
   the allies.
4. **A CONDITIONED CREST RUNE MEETS FN's RULING.** FN ruled that a gated rune at a flat price is strictly worse than a
   bare one, and that none may be authored; **three gates red on a `condition` key in a rune's payload** — `check_ez`
   §4, `check_fn` §1b and `check_fx` §5, which holds that nothing reads a node but the tree's own door (driven:
   controls K12 and K12x, §7c). HL built the five `heroes_…` keys past that ruling and nothing has reconciled
   the two. It is owed before a conditioned crest rune is authored, whatever ruling 1 decides.
5. **ELEVATION'S RULED WORDS NAME THE CARD'S OWN GRANT.** *Every ally gains 2 stacks* is `ELEVATION_STACKS`, a
   magnitude a constant holds, in the card the rule was ruled on. This batch reads the rule as binding a text that
   quotes ANOTHER rule's number — a cap, a threshold, a rate — and never a card's own payout, which the text standard
   has printed since CL; `CLAUDE.md` says so and says the reading is the designer's. `check_ho` §7 holds the card to
   exactly that one figure and to the constant.
6. **THE WORDS, ALL PROPOSED.** *(for the crest)* on the Peddler's row and on a cache's button; the event's line
   *RUNE: Tithe (the crest)*; the toast *"Tithe fills the crest — every hero wears it."*; and no marker on a crest
   rune's name (the brief's own proposal).
7. **THE NAMES' NEAR-MISSES (§3d).** None is an exact collision and none was renamed. *Tithe*: the relic *Tithing
   Scales*, whose id in the relics' table is `tithe`, and a combat-log line *Blood Tithe* that nothing can trigger.
   *Gravesong*: the enemy *Grave Totem* and the relics *Gravelight Lantern* and *Gravewrought Coin*. *Cold Hearth*:
   the card *Cold Iron* and the runes *Cold Snap*, *Deep Cold* and *Killing Cold*. *Fellowship* and *Empty Pulpit*
   meet nothing.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | `heroes_all_standing: false` does not invert | **Held** at HEAD (`check_hn` §3c); inverted at §2. |
| 2 | A hero can un-fall mid-fight: the Revive Potion and Resurrection both reach `BattleUnit.revive()` | **Held.** Two callers. |
| 3 | The rune has been `Fourth Stack` since FK, so HN's brief named a shape the game never held | **Held.** |
| 4 | Elevation's handler comment says *holding 3 reaches 5* | **Held, and there were three more copies**: the comment above the card's definition (*AN ALLY ALREADY HOLDING 3 OR MORE…*, *a party at three*) and the constant's (*an ally at three*). All four are fixed. |
| 5 | Vampiric and the Killing Cold leave 0% healing where they promise 70% | **Held, measured on HEAD**: a heal of 40 lands 0. The Killing Cold promises 75%, not 70%. |
| 6 | `unit.gd`'s comment *No reachable loadout gets there today* is false | **Held.** |
| 7 | Two retired runes begin paying what they say; none is on disk | **Held.** Four retired runes write the field; the Cleric's two already added to his 1.15 (§0c). The player's save holds four core runes and no other. |
| 8 | The population is HN's eight | **The list names nine, and the derivation finds eleven** uncarried of eighteen: the nine, and `frame_size` and `_base_scale` (§0c). |
| 9 | A crest rune has no class, so the drop, the Peddler, a cache and a bargain may not offer one | **Did not hold.** Every one offers it: the rolls ask `_scope_ok`, which passes the crest's scope for every hero (§1). |
| 10 | Tithe *needs no condition and no new code* | **No condition: held. No new code: did not hold** — EM's charter forbids a rune the node's own counter (§3a). |
| 11 | `blood_communion` is *read on every blow dealt* | **Partly.** On a hero's ordinary blow only, and on the Break applied (§3a). |
| 12 | A party *with the Warrior's Break lane* | **There is no such lane by lineage or by cards**, measured; the Long Watch rune is what doubles a Warrior's Break (§3a). |
| 13 | 1 cleanse is already four a round | **Held**: 4.00 available. |
| 14 | The Occultist's Madness lane and the Hunter's breadth engines should feel Fellowship | **Did not hold.** Both count debuffs on ENEMIES (§3b). |
| 15 | *Stunned, frozen and the like* on a hero | **None can reach a hero today**: 0 hero turns lost to either in 233,708 measured (§3b). |
| 16 | `heroes_lack_class` and `heroes_all_standing: false` are conditions a run meets | **Did not hold** for a run played forward (§3c). |
| 17 | HN drove `dmg_bonus` at +10% reading ×1.100 | **Held** (`docs/reports/HN.md` §3a). |
| 18 | *The shape that retired Skirmisher and Tracker* | **Not in the repo.** Both are live core runes; if they are ruled retired it is RULED, NOT BUILT. |
| 19 | `check_fd` §3 may not cover the `party` scope | **It covers it by construction** — it walks every id and reads no scope (driven: control K44, §7c). |
| 20 | HN's §2a sweep read 429 names | **Held**; the same four populations read 431 now, and the sweep was widened to 1,019 (§3d). |
| 21 | The flake is 1 in 54, reproduced under seeds 98 and 0 | **Held**, replayed on HEAD: 129 / 1 and 130 / 0. |
| 22 | There are 479 spent folders, about 139 MB | **479 held.** The 461 older ones are 138.9 MiB; all 479 were 140.3 MiB. |
| 23 | Record the policy *in `CLAUDE.md` beside the verification rules* | **The verification rules left `CLAUDE.md` at EF §2.** The policy is in `docs/instrument-rules.md`, with its index row in `CLAUDE.md` (§5). |
| 24 | HN's backup and HL's and HK's are byte-identical | **Held**, by hash, and this batch's is identical to them (§7). |

## §0 — HN'S THREE RULINGS

### §0a — FORBEARANCE SHIPS BARE, AND THE LONG SHAPE WAS NEVER AN OPTION

Nothing changed. **The record, so a later reader does not take it for a reversal**: HN's brief wrote *Rune of
Forbearance*; the game has never held that string — the rune was `Fourth Stack` from FK until HN renamed it — so the
bare name is not a decision against the long shape, and FK §2a's rule now says so in `CLAUDE.md`.

### §0b — ELEVATION'S CARD, AND THE RULE

The card reads, as the screen breaks it (33 / 16 / 35 / 37 / 21 characters, under the 44 ceiling):

> Raise them up: every ally gains 2
> stacks of Faith.
> An ally who reaches the cap with it
> RELEASES on the spot — and their peak
> does not fall for it.

Four comments spoke the old threshold and none does now: the handler's (*an ally the grant carries to the cap
(`FAITH_RELEASE`) pays out*), the two above the card's definition, and the one on `ELEVATION_STACKS`. `docs/master.html`'s
Elevation row says *An ally who reaches the cap with it RELEASES on the spot*.

**THE STANDING RULE IS IN `CLAUDE.md`**, under its own heading beside DF §1's: *card text and comments do not name a
magnitude a constant holds.* It is forward-looking. **Five comments still name Faith's threshold as five** — the census
the rule asks for, carried in `docs/state.md` for the batch that touches each: `unit.gd:988`, `battle.gd:17555`,
`:17571`, `:17967`, `:27524`.

### §0c — THE REPLACE-NOT-ADD TRAP IS CLOSED

**What was wrong.** `Talents.apply_payload` adds a payload's figure into the spawn's config under any key. Where the
config carried no key the add started from nothing, so a field whose declared default is not zero was REPLACED by the
payload's figure.

**What was built, as HN priced it.**
- **The config carries every numeric default that is not zero, before any payload.** `BattleUnit.hero_spawn_defaults()`
  reads them off the unit's own declarations — a probe unit's script variables whose value is a number other than zero
  — and `Classes.hero_config` hands each one over where the class's own config does not already set it. **No list was
  typed**, so a field declared later is carried by doing nothing, and every reader of a hero's config (the spawn, the
  hero sheet, the map) comes through that one function.
- **Holy Conduit adds its 0.15** to what the config carries, where it set 1.15.
- **The parry sentinel is carried as the baseline.** `parry_chance` defaults to −1, *use the role's baseline*, which is
  not a number a payload can add to; a hero's config carries `BattleUnit.HERO_PARRY_CHANCE` (0.05, the one constant
  the roll reads for a hero — `battle.PARRY_CHANCE` is now that constant), a lineage's own base still replaces it
  (the Swordmaster's 0.12), and the spawn floors the result at nothing: a price that took it below zero would have
  read as the sentinel at the roll and handed the baseline back. An enemy keeps the sentinel; nothing stamps a payload
  on one.
- **`unit.gd`'s comment beside the heal clamp** no longer says no loadout reaches it; it says what the sum starts from.

**THE POPULATION, DERIVED.** Eighteen numeric unit fields have a default that is not zero:

| carried before HO (7) | newly carried (11) |
|---|---|
| `armor`, `attack`, `constitution`, `max_hp`, `max_resource`, `speed`, `stability` | `healing_received_mult`, `parry_chance`, `second_max`, `mercy_threshold`, `overcharge_mult`, `mod_bd_mult`, `mod_cost_mult`, `mod_speed_mult`, `hp` — the brief's nine — and `frame_size`, `_base_scale` |

**A field the spawn re-derives after the payloads is still overwritten**, which is the census's row for it and not
the trap: a second resource's ceiling for the hero whose core rune installs one, health, and a battle modifier's
multiplier while one is armed.

**WHAT IT CHANGES ON A SAVED RUN — A MAGNITUDE THAT MOVED.** Every writer of the eleven was derived off
`data/runes.json`, the talent tree, the relics and the scripts: **four rune payloads write one, all four retired, all
four `healing_received_mult`**, and nothing else does. Measured on a save carrying each rune worn, a heal of 40 on a
hero at 1 health, on HEAD's tree and on HO's:

| rune, on | HEAD: multiplier, heal lands | HO: multiplier, heal lands | its words |
|---|---|---|---|
| Vampiric Rune, a Warrior | −0.30 → **0** | 0.70 → **28** | *heals received are 30% weaker* |
| Vampiric Rune, a Mage | −0.30 → **0** | 0.70 → **28** | |
| Vampiric Rune, a Hunter | −0.30 → **0** | 0.70 → **28** | |
| Vampiric Rune, a Cleric | 0.85 → 34 | 0.85 → 34 | |
| Rune of the Killing Cold, a Mage | −0.25 → **0** | 0.75 → **30** | *25% weaker* |
| Rune of the Hollow Chalice, a Cleric | 0.85 → 34 | 0.85 → 34 | *30% weaker* (of his 1.15) |
| Rune of the Martyr, a Cleric | 1.30 → 52 | 1.30 → 52 | *15% stronger* |

**So two runes move, as the brief said, and the arithmetic is 100% − 30% = 70% and 100% − 25% = 75%.** Nothing live
moved: `check_gp` walks two whole runs on the real screens, and its ok() trace on HO's tree with the two crest runes
stubbed out is message for message HEAD's (§7b).

## §1 — HOW A CREST RUNE REACHES THE PLAYER

**THE ANSWER: EVERY ROLL IN THE GAME OFFERS ONE, SO FZ'S STOP CLAUSE DID NOT BIND AND §3 PROCEEDED.** A crest rune
has no class; the rolls do not ask for a class. Each asks `Runes.eligible_ids(member, owned)`, which asks
`Runes._scope_ok(entry, member)`, and since HK §4 that passes the `party` scope for every hero. So a crest rune is in
every hero's pool, between his class's runes and his class's core runes.

**EVERY SITE, AND WHAT IT DOES WITH THE SCOPE.**

| site | what it does with a crest rune |
|---|---|
| `Runes._scope_ok` | passes it for every hero |
| `Runes.eligible_ids` | lists it for every hero: no `ENGINE_READ` row, no required card, no companion read |
| `Runes.offerable` / `Runes.sits_out` | never withhold it and never sit it out — it reads no engine |
| `Run.generate_rune` | rolls it; excludes everything the party holds (`party_rune_names`: the bag, the crest, a waiting drop, every hero's runes) |
| `Run.peddler_rune` → `shop_screen._roll_offers` | **the Peddler sells it.** His one exclusion is the core runes, by name. Each hero's roll is handed what is already on the counter, so it is on the counter once |
| `Run.roll_rune_candidates` | **an elite's cache and a bargain's rune reward hold it**: up to three draws without replacement from the hero's pool |
| `Run.rune_choice` | the queued cache's answer: repaired, topped up and filtered as any rune; a crest rune is never filtered out |
| `Run.grant_rune` | **the event verb grants it**: it picks among the hero's non-core runes |
| `Run.roll_fight_drop` | **the drop holds it**: the union of every hero's pool, one entry an id, one picked flat — so a crest rune is one entry, not one a hero |
| `Run.hold_rune` | puts it down: worn in the crest when that was asked for and the crest is free, otherwise the bag; never on a hero |
| `Run.buy_rune` | a purchase goes to the bag, whatever its kind |
| `map_screen._pick_rune` | asks for it to be worn (it asks for every kind but a core rune) |
| `RunSim._roll_rune_offers`, `_sim_take_drop`, `_pick_rune_candidate` | the sim's counter, drop and cache policies take one as the game does |

**WHAT WAS WRONG: FOUR PLACES TREATED A RUNE ROLLED AGAINST A HERO AS THAT HERO'S.** Every roll asks one hero, so a
crest rune arrives at a surface in somebody's name.

- **The Peddler's row** read *Tithe  (for Warrior 1)*. It reads *Tithe  (for the crest)*.
- **A cache's button** gave the bare name among the three of one hero's cache. It reads *Tithe  (for the crest)*.
- **The event's line** read *RUNE: Tithe (Berserker)*. It reads *RUNE: Tithe (the crest)*.
- **The sim's counter** re-rolled each hero without what was already on it, so one crest rune could be stocked for
  several heroes and the bot could buy it more than once; it passes the counter's names, as the real one has since HK.

Each asks `Run.rune_for_label`, the door the victory card, the full-bag panel and the Sell rows already asked. **And
a pick that every hero now wears is said**: a crest rune taken from a cache with the crest free is worn at once (the
pick asks for it), and the map toasts *"Tithe fills the crest — every hero wears it."* — HL §1's rule that one choice
is never two things with no announcement.

**DRIVEN, OFFERED AND TAKEN, THROUGH THE REAL ROUTE (`check_ho` §1).** The scope at every roll for all four heroes; a
real normal fight won on the real battle scene, whose drop is a crest rune, in the bag, named *for the crest* on the
victory card, and one entry in the pool (against one class rune it took about half of 400 drops; counted once a hero
it takes four in five — control K06 read 295 to 328 over seven runs, 2,204 of 2,800, its pool probed at four copies to
one); the Peddler's real counter, both crest runes once each, each row saying whose it is, bought through its own Buy
button into the bag; a real cache overlay on the map, both buttons saying *for the crest*, the first pick worn in the
crest and announced, the second sent to the bag and said; the event verb; the bag panel's own Equip button; the crest
through the save; and the sim's counter. Every negative has its positive arm beside it: a class rune's row still names
its hero, a class rune's event line still names its taker, the sim's counter still rolls one a hero.

## §2 — `heroes_all_standing: false` INVERTS

Two lines in `Talents.party_condition_met`, as HN priced it: the key's presence is asked apart from its value, and
whether every hero stands is compared with that value.

| the condition | all four standing | the Mage down at the opening |
|---|---|---|
| `heroes_all_standing: false` | pays on 0, and the roll call says its condition does not hold | pays on 4 |
| `heroes_all_standing: true` | pays on 4 | pays on 0, told |
| the key absent | pays on 4 | pays on 4 |

Driven with a fixture crest worth +9 maximum health, stamped at the real spawn (`check_ho` §3). `check_hn` §3c, which
asserted at HN that `false` is ignored, asserts the inverse. **It is read once, as the fight opens; a hero raised
mid-fight does not switch it**, which the brief accepts only because the rune's words say when. **`CLAUDE.md` carries
that rule, and `check_ho` §2d asks it of every rune that carries the key** — none does (§3c).

## §3 — THE CREST RUNES

### §3a — TITHE

> **Tithe** — *Every hero's Break damage heals whoever among the four is lowest, for 30% of its value.*
> `scope: party`, 150g, `{"stat": {"rune_blood_communion": 30}}`. **30 IS PROPOSED.**

**THE BRIEF'S *no new code* DID NOT HOLD.** The field it names, `blood_communion`, is the counter the talent
*Breaking Heals a Hero* writes, and EM's charter forbids a rune a node's own counter. So the rune writes
`rune_blood_communion`, a field of its own, summed with the node's at the node's one read site — guard and payout
both (a guard on the node's field alone pays a rune-only hero nothing, in silence: controls K19 and K20, and
`check_em` §2 catches both). It needed a declaration, a row in `Runes.STAT_INT_KEYS` (control K45) and the two sums.
A hero wearing the node and the crest pays both shares from the one site: 18 Break healed 9, which is 50% of it.

**WHAT THE RULE READS, WHICH IS LESS THAN THE WORDS.** The read site is a hero's ordinary blow in `_resolve`'s strike
loop. It pays on the Break the blow APPLIED — after the enemy's Constitution, and nothing into an enemy already
Broken — and at least 1 a paying blow. It does not see: a card whose work is done in its own handler, a trap, a
companion's bite, a talent's proc, or the Long Watch's carry onto a second enemy. The lowest hero is by share of
health, ties to seat order, so a party at full health pays the Warrior and wastes it; what would overfill is lost.

**THE MEASUREMENT (normal fights, rung 2, no talents; ± is a standard error over runs; n is fights / runs).** Taken in
isolated copies of HEAD with a probe that books Break at every site and at the read site, and an arm that puts the
share on every hero at the spawn — the rune's own route.

*"A party with no Break specialist"* and *"the Warrior's Break lane"* had to be defined by measurement. No lineage and
no drafted card makes a Break lane in the bot's hands (a Swordmaster holding Shatterpoint, Execute and Lunge read no
higher than a Berserker), and **every** Warrior lineage sits above the twelve lineages' midpoint. What does double a
Warrior's Break is the Long Watch rune, and Bared Plate adds about a quarter. So **party A** is the lowest lineage in
each seat (Berserker, Arcanist, Devout, Beastmaster) and **party B** is a Warden wearing the Long Watch and Bared
Plate from the first fight, with the same three beside him.

| party | zone | n | rounds a fight | Break a round, every site | Break a round, as Tithe reads it |
|---|---|---|---|---|---|
| A | 1 | 574 / 150 | 8.09 ±0.13 | 42.1 ±0.6 | 41.8 ±0.4 |
| A | 2 | 178 / 61 | 7.69 ±0.33 | 47.5 ±2.0 | 40.7 ±1.1 |
| B | 1 | 268 / 79 | 8.61 ±0.19 | 66.3 ±1.6 | 42.4 ±1.0 |
| B | 2 | 111 / 41 | 8.59 ±0.51 | 68.6 ±2.6 | 41.4 ±1.4 |

**The lane is invisible to Tithe**: B books 1.4 times A's Break and pays the same. Fully talented the gap is wider
(A 122.2 ±4.7 booked and 56.2 ±2.8 read, B 135.9 ±8.4 and 47.5 ±3.1), because the tree's own Break procs never reach
the site and a quarter to a third of blows land on a Broken enemy. A hero's health bar in zone 2 is about 200 with no
talents (Warrior 223, Mage 173, Cleric 209, Hunter 196) and about 234 with all of them.

**WHAT A ROUND PAYS, WITH THE RUNE REALLY ON (party A; zone 1 is every run, zone 2 only the runs that got there).**

| share | zone 1: health a round, of a bar | heroes fallen a fight | health at the end | zone 2: health a round, of a bar | run depth of 49 |
|---|---|---|---|---|---|
| none | — | 0.54 ±0.05 | 72.2% ±1.4 | — | 20.8 ±0.8 |
| 20% | 9.0 ±0.2, 4.95% | 0.50 ±0.07 | 76.2% ±1.9 | 8.8 ±0.4, 4.19% | 23.1 ±1.3 |
| **30%** | **12.2 ±0.2, 6.80%** | **0.38 ±0.07** | **82.8% ±1.7** | **12.4 ±0.5, 5.93%** | **23.7 ±1.2** |
| 40% | 15.8 ±0.4, 8.75% | 0.23 ±0.05 | 87.1% ±1.4 | 15.3 ±0.6, 7.24% | 25.7 ±1.5 |
| 75% | 23.6 ±0.6, 12.91% | 0.12 ±0.03 | 93.7% ±1.0 | 25.9 ±0.9, 12.16% | 30.8 ±1.4 |

(n: the control 574 fights in 150 runs; each share 245 to 277 fights in 75 runs. The 30% arm was run after the other
three, on the same frozen probe copy.)

- **Rounds to resolution do not move at any share** (7.78 to 8.33 against 8.09), so it is sustain and not tempo.
- **About half of what it lands is new healing**: at 30% all healing on the four rose 5.7 ±1.3 a round against the
  12.2 Tithe landed — the rest displaced the Cleric's and the potions'.
- **The brief's two ends.** *A tithe that heals 2* is about 12 to 13%: the Warrior's basic applies 18 Break, and any
  share from 9 to 13 heals exactly 2. *A third of a bar* a round is out of reach at any share — the site hands a
  fifth of a bar at 100%, and less of it lands as the share rises (99% at 20, 84% at 75). A third of a bar a FIGHT is
  about 20%.
- **WHY 30.** 20% is not visible in how often heroes fall (0.50 against 0.54, inside the error); 40% more than halves
  it; 30% moves it by about a third and is 6% of a bar a round — roughly 90 to 95 health a fight, a little under half
  a hero's bar spread over a whole fight.

**WHAT I DO NOT TRUST ABOUT IT, AND WHY IT IS FLAGGED RATHER THAN TUNED.**
- **Tithe was worn from the first fight of every run.** A real run finds it later, if at all, so every outcome
  figure flatters it.
- **The party had no talents.** Fully talented, all four heroes already hold the tree's 20% — every fully talented
  control is already a Tithe at 20 — and adding 20 more on top landed 10.7 → 16.4 health a round with no net healing
  gained (+0.4 ±3.7, 18 runs an arm) and one hero falling in the two arms together.
- **Zone 2's outcome columns are survivor samples**: 44% of control runs reach it and 60% at 30%, so the arms are not
  the same population there. Zone 1's are.
- **It is rung 2.** Nothing was measured on the player's own difficulty curve beyond it.

### §3b — FELLOWSHIP

> **Fellowship** — *At the start of each hero's turn, he clears one debuff from an ally.*
> `scope: party`, 150g, `{"stat": {"rune_field_medic": 1}}`. **1 IS THE BRIEF'S PROPOSAL, AND IT SHIPS AT 1.**

As with Tithe, the field is the rune's own (`rune_field_medic`), summed with the talent *Cleanse Debuffs Each Turn*'s
at its one site — one loop, no second tick, so a hero with both washes the two figures added. The combat log named
every such cleanse for the talent; it names the rune when the rune is what paid (`battle._crest_name_for`, which
reads the name off the run in hand so no copy of it sits in a log string).

**THE CENSUS: WHAT A HERO CAN BE CARRYING.** Enemy abilities lay exactly seven statuses on the hero side — Sunder,
Poison, Cripple, Slow, Exposed, Burn and Dazed — and two bargains lay two more (Chilled, and the Bleed warning chip).
No event lays one and no hero inflicts a listed debuff on himself. **No hard control can land on a hero today**: every
source of Stun and the one source of Freeze is aimed at an enemy (0 hero turns lost to either in 233,708 measured;
5,275 lost to Broken, which a cleanse cannot take).

**THE TWO LANES THE BRIEF NAMED READ ENEMIES.** The Occultist's Madness — Psychosis, Bewitch, Hysteria, the Ruin
marks — resolves on the acting enemy; the Hunter's breadth engines (Trapper and the rest) count statuses on the enemy
he strikes. The one hero-side call of `_status_count` in the game is Fellowship's own pool. **What does feel it**:

| who | what happens |
|---|---|
| the Cleric's **Unburden** (class kit; the bot casts it only when an ally is afflicted) | 0.452 ±0.053 casts a normal fight → 0.008 ±0.003. It had been removing 21.6% of landed debuffs |
| the **Returned Burden** rune | 0.035 ±0.012 effects returned a fight → 0.003 ±0.002 |
| the talent **Cleanse Debuffs Each Turn** | the rune beside it fired 0 times in 6,946 hero turns at rung 2 (and 0 in 6,875 at rung 1) |
| the talent **Mitigation per Debuff You Carry** | a cleanse costs him what he was being paid for; beside the cleanse talent it is already worth 0.7% of damage taken |
| the **Medic** core rune; Dispel, Field Dressing, Divine Plea, the Cleansing Draught | made redundant |
| the **Hierophant**'s Sanctity | fed by it, about 0.3 events a round |

**THE MEASUREMENT (rung 2, no talents, normal fights, 189 runs an arm; ± is a standard error over runs).**

| | Fellowship off | Fellowship on |
|---|---|---|
| debuffs landed on the heroes a round | 0.296 ±0.012 | — |
| cleanses performed a round, of the 4.00 available | — | 0.316 ±0.014 |
| share of landed debuffs the rune removed | — | **96.4% ±0.5** |
| …removed before the bearer's next turn began / before he acted | — | 70.8% / **98.8%** |
| damage taken a fight | 316.1 | 324.9 (+8.7, SE 17.6) |
| rounds a fight | 7.28 | 7.14 (−0.14, SE 0.29) |
| heroes fallen a fight | 0.852 | 0.758 (−0.095, SE 0.073) |
| run depth of 49 | 16.68 | 17.43 (+0.75, SE 1.00) |

- **Four cleanses a round against 0.30 debuffs a round is thirteen times the supply.** The 99th-percentile fight lands
  1.33 a round and the most any fight landed is 2.8 — never four.
- **What the deleted layer was worth**: 6.0 of 316 damage a normal fight (1.9%: the ticks, 13% of what was taken
  while Exposed and an estimated 6% of what was taken while Sundered) and 0.42 of 27.9 hero actions taken Crippled.
  By zone 1.4%, 2.6% and 4.4%.
- **Where it is worth something**: the zone-1 boss. 63.7 of 518 damage in those fights (12.3%) is the Withered
  Warden's area poison, and 2.40 hero actions a fight are taken Dazed; both go to almost nothing.
- **A hero-side stun, if one were authored** (constructed in a second copy: a raider's strike made to stun): turns
  lost to it fell from 0.695 ±0.053 a fight to 0.030 ±0.007, and 95% of stuns were removed by the cleanse.
- **What it cannot take, and one thing it takes that it should not**: Broken is not cleansable; and
  `dispel_one_debuff` takes the Bleed warning chip that `_cleansable_debuffs` refuses, so under the Bloodletting
  bargain 61% of its cleanses went on a chip that re-lands on the next hit. The talent does the same.

**IS 1 TOO STRONG? AS POWER, NO; AS COVERAGE IT IS TOTAL, AND THE NUMBER IS NOT THE LEVER.** Supply is thirteen times
demand and 1 is the floor of *each hero, each turn*. If it is to be less, it is the shape that changes — one hero a
round, or a chance — and that is the designer's.

### §3c — EMPTY PULPIT, COLD HEARTH AND GRAVESONG: SPECIFIED, MEASURED, NOT AUTHORED

| rune | its condition | its payload |
|---|---|---|
| Empty Pulpit | `heroes_lack_class: "cleric"` | `dmg_taken_bonus` −0.12 |
| Cold Hearth | `heroes_lack_class: "mage"` | `dmg_bonus` +0.12 |
| Gravesong | `heroes_all_standing: false` | `dmg_bonus` +0.25 |

**NONE OF THE THREE CONDITIONS HOLDS IN ANY FIGHT A RUN PLAYED FORWARD OPENS, AND `check_ho` §2 HOLDS BOTH REASONS AS
FACTS RATHER THAN AS PROSE.**

1. **The draft seats exactly one of each class.** `draft_screen.ROSTER` is the four classes, four are picked, a hero
   pressed twice is unpicked, and the run cannot begin on three. Driven on the real screen: the run it began seats
   `[warrior, mage, hunter, cleric]`.
2. **A hero who falls in a fight that is won stands again when it ends.** Driven: the Mage killed through the damage
   door in a real normal fight, the fight won by the three left, the member at 47 of 135 after it — the 20% floor and
   the healing every victory gives. It is the Master Document's own rule (*"Fallen heroes return after a won battle at
   20% max HP"*). An event's health cost stops at 1, and a lost fight ends the run.
3. **So four of HL's five keys are constants for a run played forward.** `heroes_include_class` and
   `heroes_all_standing: true` always hold; `heroes_lack_class`, `heroes_all_standing: false` and any
   `heroes_class_count` but one never do. `heroes_hold_core` is the only one a drafted party answers either way.
4. **The one state they hold in is GH's**: a fight quit after a hero fell is resumed with him down. Driven end to end —
   a fight opened `[175, 135, 150, 160]`, the Mage killed, the save loaded, the real resume — and the same fight
   reopened at `[184, 144, 159, 169]` with one down: the fixture paid on all four.

Driven as fixtures that never reach the file, each condition pays 0 of four with a drafted party standing (and the
roll call says so) and 4 of four with its hero down at the opening. **So each works, and each would pay a quitter and
nobody else.**

**WHAT EMPTY PULPIT WOULD BE WORTH (the brief's question, answered on parties that have a Cleric — the sim cannot
field one without).** Per normal fight at zone 2, rung 2, no talents (181 fights / 61 runs): the heroes take 385 ±18
damage and barriers absorb 108 ±12 more, so 12% returns 46 to 59 health. The Cleric supplies 218 ±20 of healing and
131 ±16 prevented. **12% mitigation is about a sixth of a Cleric.**

**WHY NO-WARRIOR AND NO-HUNTER WERE CUT (the designer's reasoning, recorded so they are not proposed again; it is in
`CLAUDE.md`'s crest block and in the design notes).** A missing Cleric can be paid in mitigation and a missing Mage
in damage: healing and burst are things a number can stand in for. A Warrior tanks by being targeted and a Hunter
works through marks, Focus and companions, so neither hole has a stat that substitutes for it, and a number standing
in for a mechanic is a rune that reads nothing.

### §3d — THE NAMES AND THE SHAPE

- **BARE-NAMED, AND `check_fd` §3 COVERS THE `party` SCOPE BY CONSTRUCTION.** It walks every id in the file and reads
  no scope: a live rune that is not a core rune and begins *Rune of* is red whatever it is scoped to. Driven: with
  Tithe renamed *Rune of the Tithe*, `check_fd` §3 reds (control K44). FK §2a's rule in `CLAUDE.md` says so.
- **NO MARKER (PROPOSED, as the brief proposed).** A core rune wears *(core)* because it sits in a list of ordinary
  runes. A crest rune is met in the slot the screen calls the Crest or in a row that says *for the crest*.
- **THE SWEEP, WITH A NEAR-MISS COUNTED AS A HIT.** The brief's population — every rune live and retired, the
  generated family, the ability corpus and the tree's nodes — is 431 names. It was widened to GB's ten populations and
  the two FK and FO added: **1,019 names in fourteen** (168 runes, 36 lanes, 6 generated, 230 abilities, 27 nodes, 21
  enemies, 48 enemy abilities, 98 glossary terms, 8 items, 25 relics and their 25 ids, 160 statuses and their 160
  ids, 7 tags). Two names are near when a word of four letters or more in one is a word of the other, sits inside
  it, or shares its stem.

| name | exact | near, in the brief's population | near, in the wider one |
|---|---|---|---|
| Tithe | its own entry | none | the relic *Tithing Scales*, and its id `tithe` |
| Fellowship | its own entry | none | none |
| Gravesong | none | none | the enemy *Grave Totem*; the relics *Gravelight Lantern*, *Gravewrought Coin* |
| Empty Pulpit | none | none | none |
| Cold Hearth | none | the card *Cold Iron*; the runes *Cold Snap*, *Deep Cold*, *Killing Cold*, *Rune of the Killing Cold* | the same five |

  And one string no population holds: the combat log can print *Blood Tithe*, the line of a talent that went with the
  twelve trees, whose field nothing writes. **The relic's id and the rune's id are the same word in two tables that
  nothing resolves through one another** (every relic lookup is keyed off a relic list). `check_ho` §5e holds each
  set as an equality, so a new near-miss reds.

## §4 — THE `test_batch_bk` §3 FLAKE IS REPAIRED

**THE ROUTE TAKEN: BUY A PAIRING WHOSE TYPE FITS ANOTHER CARD. NOT A SEED, AND THE ROW IS NOT WIDENED.** The arm
bought the blacksmith's first pairing and then asked 200 more rolls to offer the same upgrade type on a DIFFERENT
card. For the one type that fits a single card the four hold — Widened, on Magic Missiles — the question has no
answer. It now buys the first pairing on the counter whose type has another card to go on
(`suite_fixture.pairing_with_another_home`), and an arm of its own says so if the counter holds none.

**WHY NOT A SEED.** A seed pins one draw of a pool that moves with every card authored: the day the pool moved, the
same red would come back as a certainty rather than as one run in fifty-four, and until then the suite would never
again meet the counter that broke it. The construction asks the arm's question of every counter it is dealt.

**DRIVEN UNDER BOTH SEEDS, ON BOTH TREES.**

| | seed 98 — Widened on Magic Missiles first | seed 0 — Piercing on Pommel Strike first |
|---|---|---|
| HEAD's suite, HEAD's tree | 129 / **1** — *the same upgrade type is still offered on a DIFFERENT ability* | 130 / 0 |
| the repaired suite, HO's tree | 131 / 0 — it buys the second pairing | 130 / 0 — it buys the first, as before |

`check_ho` §6 builds both counters — the lone pairing first, and a many-homed one first — and reads the helper on
each; it also holds the suite to the line that uses the helper's answer (control K25: a suite that calls the helper
and buys `offer[0]` anyway reds). The suite's count is one higher for the new arm; its band moves [128, 130] →
[129, 131] and nothing else about the row does.

**AND §4 OF THE SAME SUITE WAS A SECOND COIN-FLIP THE CREST RUNES MADE.** Its *`rune_grant` delivers a rune to the
party* arm counted the heroes' own lists; a crest rune granted lands in the crest or the bag, so the arm would have
failed whenever the grant drew one — two of a Warrior's seven. It counts everything the party holds.

## §5 — THE SPENT COPIES: THE POLICY, AND HN's EIGHTEEN

**THE POLICY IS RECORDED IN `docs/instrument-rules.md`**, under its own heading, with its row in `CLAUDE.md`'s index of
that file: *a batch clears the PREVIOUS batch's isolated copies when it finishes; one batch's worth stays for
forensics; everything older goes.* The brief says *in `CLAUDE.md` beside the verification rules* — those rules moved to
`docs/instrument-rules.md` at EF §2, and a rule written in one file is not summarised in the other, so it went where
they are. It says what a copy is and why it leaves a folder (each renames `config/name`, and Godot keys `user://` on
that name), that the batch's own are named for its letters so the next batch finds exactly those, that cleared means
moved to the Trash, that a refused move is reported and not pursued another way, and that `../save-backups/` is never
touched. `check_ho` §8 pins it against the reference and not against the index row.

**HN's EIGHTEEN WERE MOVED, AND THE MOVE WAS NOT REFUSED.**

| | folders | size |
|---|---|---|
| before: spent copies beside the player's own folder | 479 | 143,644 KiB (140.3 MiB) |
| — the older ones | 461 | 142,224 KiB (138.9 MiB) |
| — HN's | 18 | 1,420 KiB (1.4 MiB) |
| moved to the Trash, in a folder that names them | 18 | 1,420 KiB |
| after: the older ones, untouched | 461 | 142,224 KiB |

**What is recovered is 1.4 MiB, and only once the Trash is emptied**, which this session may not do and did not. The
461 older folders are outside the policy — it clears the previous batch's, by their name — and were left for the
designer, as the brief says. The player's own folder and `../save-backups/` were not touched.

**THIS BATCH'S OWN, WHICH STAY FOR HP TO CLEAR**: **Fifteen folders under Godot's `app_userdata`, 41,304 KiB
(40.3 MiB)**, each named *"Dawn of Decay HO …"* for the copy it belongs to: `head` (HEAD's tree — the seeds and every
HEAD arm), `work` (the working copy), `mini` (the forty-one-target run), `m1` and `m1b` (Tithe's measurement), `m2`
and `m2b` (Fellowship's), `trA`, `trB` and `trC` (the three ok() traces), `recon`, `ctl1`, `ctl2` and `ctl3` (the
control lanes) and `prepass` (the pre-pass and the two passes after it). The engine's own logs of `m1`'s simulated
runs are 27,920 KiB of it. Every copy had `config/name` renamed in its `project.godot` before anything ran in it, so
none read or wrote the player's folder; the acceptance run is the one run made under the game's own name (§7d).

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **`heroes_class_count` still reads a named class**; *any* is not built.
- **No OR, and no list form for a repeated key.**
- **No card-granting crest rune.**
- **No Kinship rune.**
- **No *no Warrior* and no *no Hunter* crest** — cut in the brief, the reasoning recorded (§3c).
- **The continuous half of door 3 is not built**, nor HK's doors 1, 2 and 4 to 8. (It is what ruling 1's first option
  would build.)
- **The crest cap stays at one.**
- **`CLAUDE.md` is not split**; the shape recon stays queued.
- **Volley, Ambusher and Channel's tempo payout are not built.**
- **And, on the standing rule rather than the brief: three of the five crest runes are not authored** (§3c).

## §7 — VERIFICATION

**THE ORDER.** The saves were backed up and verified by hash before anything else. The documentation was written
before the verification run. **HEAD's unmodified instruments were run against the new game before any existing gate
was re-pointed** — forty-one of them at 11:47, from HEAD's own copies, and the first re-point was made at 12:16 — and
all 128 again, the same way, once the game and the documents were finished (§7a). The one suite edited before either
was `test_batch_bk` with its fixture, at 11:08: that is §4's repair, which the brief asks for, and not a re-point.
Every rune was driven through the real route. The controls, the pre-pass and the acceptance run follow.

**THE BACKUP.** `../save-backups/HO-20260930-104538`: `profile.json` `2892470f…`, `relics.json` `fdc12ffa…`,
`run_save.bin` `fa85daa9…`, `settings.cfg` `0c1b39c3…` — each byte-identical to the live file, and to HN's, HL's and
HK's backups. The player's run save is v13 and holds four core runes and no other rune.

**THE LITERAL SWEEP, BEFORE THE RUNS.** Every string literal of the 134 root scripts — 16,480 needles, floor four
characters — looked for in HEAD's copy and HO's of each of the 39 files edited by then: **18 lost, 434 gained.** The
eighteen were read one by one. Six are `check_ho`'s own absence anchors, the text it asserts is gone (*No reachable
loadout gets there*, Holy Conduit's `= 1.15`, the Peddler's old row format twice, the suite's old buy line, the log
line that named every cleanse for the talent). Twelve are needles no reader of that file holds: `check_fd`'s
fingerprints inside `check_flow.gd`, two common words in `check_hn.gd`, one in `check_hl.gd`, and five names in
`docs/state.md`, which only `check_es` opens. Every edit made after the pre-pass was swept the same way against the
copy it had read (§7d).

### §7a — THE RECON: HEAD'S INSTRUMENTS AGAINST HO'S GAME AND DOCUMENTS

HEAD's every root script, runner, baseline table and pin manifest, against HO's `scripts/`, `data/`, `docs/` and
`CLAUDE.md`, in an isolated copy, with the prediction written eleven seconds before the launch.
**129 targets as HN counted them — 128 with a row in `baselines.json`, and `check_de`, the count differ over their
logs — in 76 min 17 s**, with the controls running beside it, so under a 480 s default bound (`check_gp` sits within
seconds of 240). **It read the prediction, target for target: twelve red, six green with a higher count, the two
sanctioned reds at their counts, and every other target at HEAD's count** — `check_de` 533 / 16 / 9 notices. No
target that drives a fight and reads a number moved, so **the spawn-default change moved no live figure**.

| target | HEAD's instrument on HO's tree | what it met |
|---|---|---|
| `check_es` | 52 / 1, one throw | *the authored pool is 168 entries, expected 166*; then `Invalid access to property or key 'party'` — the band table — and five arms never ran |
| `check_ez` | 131 / 5 | the pool; *17 are HF's class runes*; *HF's tithe is not a class rune*; *77 of 75 landed* |
| `check_fk` | 65 / 2 | *17 live runes are written for no lineage*; *a scope that rolls for nobody* |
| `check_fo` | 90 / 1 | *the live pool is 77 (17 of them HF's), not 60 + 15* |
| `check_fe` | 79 / 3 | 12 rows carry BREAK, not 11; DEFENSE 41, not 39; 144 rows, not 142 |
| `check_gx` | 1364 / 1 | *35 ungated live ordinary runes — 33 since HF* |
| `check_gv` | 1024 / 14, forty throws | §0 ×5 (unsorted), §1 ×4 (no lineage to seat — the throws), §2c ×1 and its early return (23 arms unrun), §3 ×4 |
| `check_hk` | 140 / 2 | §2h *its crest does not say it is empty*; §4 *2 party runes are authored — the ruling is none* |
| `check_hl` | 168 / 3 | §1c *the hero's panel drew no Equip for the rune bought* (×2); §6 *the ruling is none* |
| `check_hn` | 74 / 6 | the trap arms (*…on every hero but the Cleric it should REPLACE 1.0*; *the trap is closed, re-derive the census*), §3c (*`false` … now reads something*), the file arm |
| `test_runes` | 7489 / 25 | 24 × *grant N was 'Fellowship' (scope 'party'), not an ordinary rune of his class*; the cache arm |
| `check_fh` | 164 / 1 | §3 *the cache pick was answered and no rune arrived* — the seed's first rune is a core rune |
| `check_em`, `check_gs`, `check_gp`, `test_batch_cb`, `test_batch_bh`, `test_batch_al` | green, +6, +2, +24, +18, +2, +2 | walks over rune ids; `check_gp`'s road |
| `check_gj` | 70 / 1, sanctioned | *the card says +153 gold and the purse moved 173* |
| `check_cm_live` | 13 / 4, sanctioned | unchanged |

`test_batch_bk` read 129 / 0: neither of its two coin-flips fell this time.

### §7b — THE CENSUS: WHAT THE FIRST RUNES OF A THIRD SCOPE DID TO THE INSTRUMENTS

**THE BRIEF EXPECTED THE RECON NOT TO REPEAT HN's CLEAN READING, AND THE REDS WERE THE SMALLER HALF OF IT.** Every rune
in the file had been class-scoped (or retired) since HC, and the instruments had grown around that: tables keyed by
two scope bands, walks that skip anything not `class:`, arms that press the first offer and look for it on a hero,
fixtures that write a rolled rune onto a hero's list. Two entries scoped `party` went through all of them. **A census
of every gate, suite and fixture — 133 files — found the rows below.** Fifty-four were read in full by nine readers,
each against a sheet of facts checked on disk: the files the rune instruments are made of.
The other seventy-nine were swept, comments stripped, for the word *rune* in any form: **fifty-five never say it, and
the twenty-four that do were read at each site** — none rolls a rune, puts one down or branches on a scope. Four walk
`Runes.ids()`: `test_batch_cb` and `test_batch_bh`, whose counts moved as the recon read; `test_batch_cp`, whose
question the pair passes; and `test_batch_bs`, one of the eight walks below. `check_fx` §5 counts conditions over the
whole file (ruling 4). The rest name a core rune by its id, a unit's `rune_` field, a needle in a source file, or are
the two fixtures. The recon is the other half of it: every one of those targets RAN. **The rule it leaves is in
`docs/instrument-rules.md`**: an instrument puts a rune it did not name down through `Run.hold_rune`, and a scope
walk names every band.

**RED ON HEAD's INSTRUMENT (the recon, §7a). Each re-pointed to its intent, with its reason at the site.**

| instrument | what HEAD's arm assumed | re-pointed to |
|---|---|---|
| `check_es` §1, §2 | the pool is 166; a band table with two keys (it THREW on the third band, and five arms never ran); a local copy of `_scope_ok` with two cases | 168; a third band; the third case |
| `check_ez` §0, §4 | *live, no engine, no lineage* is HF's fifteen; 75 payloads land | the crest is a population apart, with a partition arm; 77 |
| `check_fk` §1 | fifteen live runes have no lineage; `party` is a scope that rolls for nobody | the crest's scope branched off first; exactly two |
| `check_fo` §2c | the live pool is 60 + 15 | 60 + 15 + 2 |
| `check_fe` §1 | 142 tag rows, eleven with BREAK, DEFENSE leading 39 | 144, twelve, 41 |
| `check_gx` §1 | 33 ungated live ordinary runes | 35 |
| `check_gv` §0, §1, §3 | every ordinary rune has a lineage or is a class's kit rune; every rune can be seated on a hero of its lineage; a no-engine offer is the class's free runes | a `CREST` group; its drive is `check_ho` §5's; the class's free runes and the crest's |
| `check_gv` §2c | one roll in forty comes up all rows | the triple is built from the rows the rolls offer |
| `check_hk` §2h, §4 | the bag panel always says *No crest rune held.*; the file holds no crest entry | the line is present exactly when no crest rune is in the bag; no FIXTURE reached the file |
| `check_hl` §1c, §6 | the counter's first row is a rune its hero can equip; the file holds no crest entry | it buys the first row a hero can wear; no fixture reached the file |
| `check_hn` §3 | the file holds no crest entry; a payload replaces a default; `false` is ignored | no fixture reached the file; a payload adds; `false` inverts |
| `test_runes` `_rich_grant`, `_start_rune_pool` | a grant or a cache candidate is a rune of the hero's class or a core rune | or a crest rune, with a positive arm |
| `check_fh` §3 | a rune picked from a cache lands on the hero who picked it | it lands where its kind lands |
| `check_gs` §4 | — (its count of door calls went 13 → 14 on a first build of the Peddler's row) | the ROW was rebuilt to call the door once; the gate is untouched |

**GREEN AND ASKING NOTHING, OR ASKING IT OF A STATE NO RUN REACHES. Each re-pointed.**

| instrument | what it did | re-pointed to |
|---|---|---|
| `check_gv` §3 (eight floors; four owed-row arms) | floored the whole offer's size, which the crest's two ride: slack by two for every class. The owed-row arm could no longer read zero | both count the class's own runes |
| `check_gv` §4 (the event door) | read a grant as new entries of a hero's list; a crest rune never lands there | reads what the party holds. *The branch has never fired: the roads press an event's first choice.* |
| `check_hf` §3 (eight floors) | the same slack | the class's own runes, and the crest's asked apart |
| `check_hc` §3 | seated every rune the Cleric could be offered on his own list, the crest's two with them; its floor passed on three class runes | `Run.hold_rune`; the floor counts his class's |
| `check_fd` §1a | its fingerprint of a file that grants a rune knew a hero's list and two roll doors | and the put-down doors and the bag's and the crest's appends |
| `check_fd` §1d | landed the first pick on the hero by hand; the exclusion it proved was the pouch's | put down as the map puts it down |
| `check_fd` §1e | matched a button's whole label against rune names; a crest button was no button | reads the name before *(for …)*; counts what it found against what the overlay was handed |
| `check_fh` §9, §9b, a note | appended grants to a hero's list by hand | `Run.hold_rune`; `runes_worn` |
| `check_hk` §1f, §4c, §5 | an unread bucket for drops of no class; a count of two that held only by the step before it; six crest runes on heroes in a pre-bag save | a partition arm; counted by id; only what a hero could wear |
| `test_runes` `_eligibility` | skipped every scope that is not `class:` | the crest's case, and a red for an unknown scope |
| `test_batch_bk` §4 | counted the heroes' own lists after an event's grant: red about one run in four | everything the party holds |
| `check_flow` | wore one unseeded draw, written onto a hero: a crest rune two draws in fifteen | three named runes through `Run.hold_rune` |
| `check_ek` §3 | — (a new gate that reads a tag row must be on its list) | `check_ho.gd` listed |

**GREEN, THE COUNT MOVED, THE INSTRUMENT UNTOUCHED**: `check_em` +6, `check_gs` +2, `check_gx` +2 (with its pin),
`test_batch_cb` +18, `test_batch_bh` +2, `test_batch_al` +2 — each a walk that asserts once per rune id — and
`check_gp` +24, whose seeded road is a different road (below). `check_gj`'s sanctioned red prints +153 / +173 where it
printed +151 / +171.

**NOT ASKED OF THE CREST PAIR, LEFT, AND RECORDED IN `docs/state.md`.** Eight suites' *class-wide runes touch no
lineage counter* walks filter on `class:<key>` (`ar`, `as`, `at`, `ax`, `ay`, `az`, `ba`, `bs`) — `check_ho` §5a and
`check_em` §1 ask that of both. `test_rune_battle` wears no crest rune — `check_ho` §5b and §5c do. `check_gf`
compares nothing of the bag or the crest across a quit. And four shapes that are not live for these two and would be
for a crest rune of another kind: one that GRANTS a card (`check_et` §4, `check_ea` §1), one with a healing cost
(`test_runes` `_healing_floor`, `test_batch_ax` §5), one that writes a ceiling (`test_runes` `_ordering`), and one
with a `heroes_…` condition (`test_batch_ak`).

**`check_gp`'s +24, ATTRIBUTED BY AN ok() TRACE WITH A STUB ARM.** Its §4 asserts once per distinct card its seeded
no-engine road is offered. Three runs with every `ok()` printed:

| tree | checks | runtime |
|---|---|---|
| HEAD's | 441 | 222.5 s |
| HO's, with the two crest entries given a `retired` string | 441 — **message for message HEAD's, in the same order** | 222.7 s |
| HO's | 465 (74 cards offered where 50 were) | 230.5 s |

So the move is the two runes in the pools and nothing else: **the spawn-default change, Holy Conduit, the parry
baseline and the four screens moved nothing on two whole runs through the real screens.** Standing alone on HO's tree
the gate read 233.5 s against the runner's 240 s default, and 235 s in the pre-pass, so it has its own bound (480),
the way `check_fx` and `check_gv` have theirs.

### §7c — THE CONTROLS: FIFTY-SEVEN, ONE DEFECT EACH, READ BY FAIL TEXT

Each ran in a clone of the finished tree with one defect written in; the gate was run and its FAIL lines were read —
never a count. **Forty-three are `check_ho`'s own** (every one re-run after the gate's last edit — the one the
pre-pass forced, §7d), **one is `check_fx`'s, and thirteen are the re-points'**, nine of which carry a second arm:
HEAD's copy of the gate on the same defect. (The thirteen ran on a base taken before `baselines.json`, the pin
manifest and the changelog's last paragraphs were written; the other forty-four on the tree as it stood at the second
pass, proved file for file. No line read below depends on a file that changed after its run.)

**`check_ho`'s FORTY-THREE, AND `check_fx`'s ONE.** Every one printed the line it was aimed at.

| # | the defect | the FAIL line read (`check_ho` unless named) |
|---|---|---|
| K01 | the Peddler's row names the hero it was rolled against | §1c: *0 of the 2 crest rows say the rune is for the crest*; *a crest rune's row names a hero* |
| K02 | a cache's button gives a crest rune's bare name | §1d: *the Mage's cache does not say its crest runes are the crest's* |
| K03 | a crest rune worn at the pick is not announced | §1d: *a pick every hero now wears was not announced* |
| K04 | the event's line names the hero who took a crest rune | §1e: *the event's line reads 'RUNE: Tithe (Pyromancer)'* |
| K05 | `_scope_ok` refuses the crest's scope | §1a: *the roll does not offer `tithe` to a warrior* … (28 lines) |
| K06 | the drop counts a crest rune once for every hero | §1b: *the crest rune took 306 of 400 drops against one class rune* (295 to 328 over seven runs; four in five is 320) |
| K07 | the sim's counter rolls each hero without what is on it | §1g: *the sim's counter holds it 4 times in 4 rows* |
| K08 | the save does not carry the crest | §1f: *the crest did not round-trip the save*; `check_hk` §4g, §5 |
| K32 | a crest rune asked for is never worn in the crest | §1d: *…went to [] (the Mage's own: [])*; `check_flow`: *tithe was put down as 'bag'* |
| K34 | `rune_for_label` has no answer for a crest rune | §1a: *does not read as the crest's (any hero)*; §1b, §1c, §1d, §1e |
| K35 | the Peddler rolls each hero without what is on his counter | §1c: *the counter holds [fellowship, fellowship, tithe, tithe]*; `check_hk` §4c |
| K36 | a hero can wear a crest rune in a slot of his own | §1a: *a warrior could wear `tithe` in a slot of his own* … (8 lines) |
| K09 | a hero picked twice at the draft is seated twice | §2a: *pressing the Warrior twice left [warrior, warrior] picked*; *the draft seated …* |
| K10 | the draft's roster holds a fifth hero | §2a: *the draft's roster is […] — a party can now be seated without one of the four classes* |
| K11 | a hero who falls in a won fight stays down | §2b: *a hero who fell in a WON fight is still down after it — … Gravesong's condition is reachable* |
| K12 | Gravesong is authored as the brief specified it | §2d: *the file's crest runes are [fellowship, gravesong, tithe]*; *a crest rune carries a condition*. **And `check_ez` §4 (*1 runes carry a condition, and FN retired the last of them*) and `check_fn` §1b red with it** — ruling 4 — beside `check_es`, `check_fk`, `check_fo`, `check_gx` and `check_ek` (an unsorted third crest rune) |
| K12x | the same rune, against the gate that holds every rune to no condition | **`check_fx` §5: *1 rune payload(s) carry a condition — a rune reading a node*** (496 / 1): the third gate of ruling 4 |
| K46 | a fight quit after a hero fell resumes onto the map | §2c: *the resume opened res://scenes/map.tscn, not the fight*; *the fight resumed after a quit opened with 0 down and the fixture paid on 0* |
| K38 | a rune reads who stands and does not say when | §2d: *a rune reads who stands and does not say it is read as the fight opens: [gravesong]* |
| K13 | `heroes_all_standing: false` is read as not asked | §3: *`false` with all four standing paid on 4*; §2c; `check_hn` §3c |
| K14 | a hero's config carries no default | §4: *a hero's config does not carry […]*; *+0.20 healing received read […]*; §4d: *Vampiric Rune on the warrior heals at x-0.30 (a heal of 40 lands 0)*; `check_hn` §3a (4 lines) |
| K15 | Holy Conduit sets the total | §4e: *Holy Conduit SETS the Cleric's healing again*. *(`check_hn` is green: see below.)* |
| K16 | the parry sentinel is carried as the sentinel | §4: *the parry sentinel is carried as -1.0*; *+0.10 parry chance read [0, 0, 0, 0]*; `check_hn` §3a |
| K17 | the heal clamp's comment says no loadout reaches it | §4e: *the clamp's comment still says no loadout reaches it* |
| K18 | Tithe writes the node's own counter | §5a: *`tithe` writes the node's own counter*; `check_em`: *writes a live talent node's counter — the charter forbids it* |
| K19 | Tithe's payout reads the node's share alone | §5b: *Tithe paid the rule's share on 0 of the four heroes' blows*; `check_em` §2 |
| K20 | Tithe's guard reads the node's counter alone | §5b: *the heal went to the Warrior 0 and the Mage 0*; `check_em` §2 |
| K21 | Fellowship's guard reads the node's counter alone | §5c: *Fellowship logged 0 cleanses of the 12 debuffs laid*; `check_em` §2 |
| K22 | Fellowship's loop runs the node's count alone | §5c: the same; `check_em` §2 |
| K23 | Tithe carries a condition | §2d, §5a: *`tithe` carries a condition*; `check_ez` §4; `check_fn` §1b |
| K24 | another rune is named Fellowship | §5e: *'Fellowship' is the name of [rune:Fellowship, rune:Fellowship]* |
| K30 | the hero sheet does not stamp the crest's payload | §5d |
| K31 | the crest's cleanse is logged under the talent's name | §5c: *the log names 0 cleanses of the crest's (and 12 of the node's)* |
| K33 | the roll call does not name the crest | §5b: *the roll call names the crest 0 times*; §2c, §3 |
| K42 | Fellowship's words do not say whose turn pays | §5a |
| K43 | Tithe costs 100 gold | §5a; `check_ez` §0; `check_fk` §1 |
| K44 | Tithe wears the long shape, *Rune of the Tithe* | §5a; **`check_fd` §3: *a LIVE ordinary rune still wears the retired pool's `Rune of…` shape*** — the brief's question, answered; `check_fo` §2c |
| K45 | a crest rune's int field is not on the coercion list | §5a: *`fellowship`'s figure reaches the unit as 3, not an int*; `check_em` §3 |
| K25 | the blacksmith suite buys the first pairing again | §6: *`test_batch_bk` §3 does not buy the pairing the helper names* |
| K26 | Elevation's card speaks the threshold as a number | §7: *Elevation reads '…'* |
| K27 | its handler's comment does | §7: *Elevation's handler comment still speaks the threshold as a number* |
| K28 | the standing rule is not in `CLAUDE.md` | §7 |
| K29 | the copies' policy is not in the reference | §8 (two lines) |
| K40 | the card's grant and the constant disagree | §7: *the card's grant and `ELEVATION_STACKS` disagree* |

**WHAT THE CONTROLS FOUND IN THE GATE ITSELF, ALL REPAIRED BEFORE THE RE-RUN.**
- **A failing stretch did not end.** §5c ran its live stretch until eight cleanses were logged or 60,000 frames had
  passed; green, it takes sixty. Under K21 it sat for minutes at under 1% of a core — in the battery, a TIMED OUT that
  reads like a hang — and the fight it had outlasted ended in a victory that threw on the gate's constant encounter.
  The stretch is bounded at 1,200 frames and stops if the fight ends, and every fight is handed its own copy of the
  encounter. K21, K22 and K31 now finish in under a minute with their lines.
- **Three reads threw under a defect and hid the arms behind them** (K14, K18, K44). Each reads through `.get()` now,
  so K14 prints all ten of its lines where it printed four.
- **§6 pinned that the suite CALLS the helper, not that it buys what the helper names** (K25 was silent on its first
  run). It pins the line that uses the answer.
- **Three positive arms named the two crest runes by id**; with a third in the file (K38) they read red for a reason
  that was not theirs. They park every crest rune the file holds.
- **K15 is silent in `check_hn` and that is a finding about the fix, not the control.** Holy Conduit runs before any
  payload, on a config that now carries 1.0, so *set 1.15* and *add 0.15* give the same number today. Adding is the
  form that stays right if anything ever writes the field before it; only the two source arms can tell them apart.

**THE RE-POINTS' THIRTEEN.** The repaired arm must red on the defect it guards; HEAD's arm beside it shows what HEAD's
could not see.

| # | the defect | the repaired gate | HEAD's gate, same defect |
|---|---|---|---|
| R01 | a crest rune's scope is a word nothing resolves (`partyy`) | `check_es` §2 *name a scope nothing resolves*; `test_runes` *carry a scope that is none of …*; `check_ez`, `check_fk`, `check_fo` red | — |
| R02 | a crest rune is written for a lineage | `check_ez` §0 (5 lines); `check_fk` §1 *the crest's, and written for holy* | — |
| R03 | one of the Warrior's own no-engine runes is retired | `check_hf` §3 *offered 4 … of his class at spawn*; `check_gv` §3 *offered 4 of his class's runes at spawn, below its floor of 5* | `check_hf` **green** (306 / 0); `check_gv` prints fifteen lines and none is the floor's — it floors the whole offer, which still reads six |
| R04 | one of the Cleric's own no-engine runes is retired | `check_hc` §3 *(4 of his class's, 6 held in all)* | **green** (74 / 0) |
| R05 | what the party holds leaves out the crest | `check_fd` §1d *the second pick still offered the first pick's rune 15 times of 400* | **green** (53 / 0) |
| R06 | a cache's crest button wears a suffix the locator does not know | `check_fd` §1e *the overlay was handed […3] and the drive read […2]* | **green** |
| R07 | a file that must grant no rune hands one to the bag | `check_fd` §1a *…now grants one — blacksmith_screen.gd (bag_rune()* | **green** |
| R08 | a cache's pick slots a core rune (HL §1's defect) | `check_fh` §3 *…a core rune, landed on an engine slot, not the bag* | **green** (164 / 0) — and red on the tree WITHOUT the defect (§7a) |
| R09 | the drop never holds a crest rune | `check_hk` §1f *400 drops held no crest rune*; `check_ho` §1b | red only on the arms HEAD's copy is red on anyway |
| R11 | the crest's scope stops short of the Hunter | `test_runes` *a crest rune does not reach a no-lineage hunter* … (8 lines); `check_es` §2 | 19 lines, none of them naming the Hunter |
| R12 | the event verb's roll excludes only the hero's own pouch | `check_hc` §3 *was granted 0 runes of 20; the fall-back stopped paying* | **green** |
| R13 | `check_ho` is not on the tag-checker list | `check_ek` §3 *exactly the authored TARGETS check a tag* | — |
| R19 | the event's rune is rolled and never put down | `test_batch_bk` §4 *rune_grant delivers a rune to the party*; `check_ho` §1e | — |

**NOT CONTROLLED, AND WHY.** `check_gv` §3's owed-row arm (*no engine … opens a single rune of his class*) can red only
with a class's whole rune set gone. `check_gv` §4's event door has never fired on its roads (§8). `check_flow` has one
arm and K32 bit it. `check_ho` §9 (the player's files) would need the gate to write one.

### §7d — THE PRE-PASS AND THE ACCEPTANCE RUN

**THE PRE-PASS — AND IT DID NOT READ THE PREDICTION.** The finished tree in an isolated copy, proved the tree file for
file (495 files hashed on both sides; `project.godot` aside, which differs in the copy's `config/name` alone), the
prediction written before the launch. **130 targets as HN counted them — 129 with a row, and `check_de` — in 74 min
22 s (14:45:22 to 15:59:44). It read `check_de` 537 / 1 / 1 notice: one target off its row, and the fault was this
batch's.**

- **`check_da` read 42 / 2**: *"check_ho.gd instantiates the battle scene by hand — go through `gate_fixture.gd`
  (BATCH DB §1)"*. `check_ho` §2c follows the run's own `resume_scene()` into the fight it reopens, and asserted
  the path that came back against the battle scene's file name. DB §1's mark is that file name in a gate's source,
  whatever the gate does with it.
- **Neither the recon nor the forty-one-target run could have seen it**: both run HEAD's root scripts, so the new
  gate is not in the copy. The gates that walk the gate FILES meet a new gate for the first time in a full run —
  HK's new gate met this same sweep the same way (42 / 2 on its first run) — and `check_da` was not among the gates
  run standalone on this one. **The lesson is recorded where the rule lives** (`docs/instrument-rules.md`, DA §3 /
  DB §1's block): the mark is the path's literal, a gate asks what opened, and the ten gates that walk the gate
  files are run against a new gate when it is written.
- **Repaired in the gate, with no exemption**: the arm asks what opened — a scene that is a fight — and the path is
  named nowhere. One assertion for one, so the count stays 170. Its control is K46 (§7c): a quit fight made to resume
  onto the map reds the arm by name, and the arm behind it, with no throw.
- **Every other target read its row**: `check_ho` 170 / 0, `check_gp` 465 in 235 s (five seconds inside the 240 s
  default it no longer runs under), `check_gv` 1047 in 611 s, `test_batch_bk` 131 / 0, the two sanctioned reds at
  their counts, the harness gates 22 / 382 / 8. **No `Parse Error` and no `SCRIPT ERROR` in any of the 130 logs** —
  grepped, not tallied.

**THE SECOND PASS.** Four files differ from the tree the pre-pass read, and nothing else does (the 495 hashed again):

| file | what changed after the pre-pass copy was taken |
|---|---|
| `check_ho.gd` | the §2c arm above |
| `docs/changelog.html` | the entry's count of the existing checks (*129*, as HN counted them — the count differ is one), the comments corrected (*five*), the controls (*fifty-seven*), the rehearsal's finding, and the Cairn of §8 |
| `docs/instrument-rules.md` | the new rule's words: a rune the instrument *did not name*, where it said *a rune* (below); and the bullet above, in DA §3 / DB §1's block |
| `pin-manifest.json` | rebuilt: 1,593 pins before and after, 25 of `check_ho`'s renumbered by the moved arm |

- **THE NEW INSTRUMENT RULE WAS BROADER THAN ITS MISCHIEF, AND THE GATE WRITTEN BESIDE IT BROKE IT.** As first
  recorded it said an instrument *never appends* a rune to a hero's list. Swept, comments stripped: **56 sites in 24
  gate, suite and fixture files do** — both fixtures' `runes` option, resets to an empty list, named class runes, a
  save's fossil — `check_ho` among them. The mischief was an arm that appended WHATEVER A ROLL RETURNED. The rule now
  binds a rune the instrument did not name — a rolled one, a granted one, a bought one — and says what it does not
  reach.
- **Each edit was swept as a scratch copy against the tree the pre-pass read** (16,480 literals of 134 readers, floor
  4): the two documents lost and gained none; `check_ho.gd` lost three, all the scene path — the point of the edit.
  Two rewordings were thrown back by the sweep for a gained literal (*choose*, *the battle*) and worded again.
- **The copy was re-proved the tree, and the battery's own runner, cut to thirty-nine targets, read every reader of
  the three edited files at its row**: `check_da` 41 / 0, `check_ho` 170 / 0, `check_ed` 18 / 0, `check_parse` 204 and
  thirty-five more — the thirty that open the changelog, the ten that walk the gate files — none off its row, and
  `check_da`'s the one line that differs from the pre-pass's. After the last edit, the bullet in the instrument rules,
  that file's ten readers were run once more: each at its row, none differing.
- **And the controls were run a last time on the edited gate** (§7c): all forty-two read 170 checks, at least one
  failure, no throw — forty-one the same lines as their last run and one differing in a hero's name — with K46 for
  the re-worded arm and K12x for `check_fx`.

**THE ACCEPTANCE RUN, IN THE REPOSITORY, THE TREE FROZEN.** Every file of the tree hashed before and after — 496:
everything but `.git`, the `.godot` cache and `save-backups/`, the untracked `check_ho.gd` among them, by absolute
path — and first proved the tree the last pass read; the player's four files hashed before and after; the prediction
written six seconds before the launch (`PREDICTION_ACCEPT.md` 16:33:58, the launch 16:34:04). **130 targets in 74 min
12 s (16:34:04 to 17:48:16). It read `check_de` 537 / 0 / 0 — the prediction.** Every target read its row. Against the
pre-pass, target line for target line, two differ: `check_da`, 41 / 0 where it read 42 / 2, and `check_de` itself.
`check_ho` 170 / 0 in 30 s; `check_gp` 465 in 234 s, under its 480; `check_gv` 1047 in 610 s; `test_batch_bk` 131 / 0;
the two sanctioned reds at their counts (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *the card says +153 gold and the
purse moved 173*); the harness gates 22 / 382 / 8. **No `Parse Error`, no `SCRIPT ERROR`, no TIMED OUT and no missing
verdict in any of the 130 logs** — grepped. **The tree was byte-identical after it, 496 files of 496, and the player's
four files are byte-identical in hash, size and modification time, and to the backup.** What the run wrote beside them
is the gates' own scratch: thirty-two files rewritten (each gate's `…_profile.json` and `…_relics.json`,
`run_save_harness.bin`) and two new, `check_ho`'s `ho_profile.json` and `ho_relics.json`.

**AFTER THE RUN.** `docs/state.md` took its verification line, ruling 4's third gate, the Cairn of §8 and this batch's
own folders; swept against the copy the battery read, it lost and gained no needle, and **`check_es`, the one gate
that opens it, was re-run against the shipped tree: 57 / 0**, its row, with the player's files hashed again after it.
This report was written last; no gate opens `docs/reports/`.

**THE PUSH.** Committed on `class-merge` by name (never `git add -A`: `save-backups/` stays untracked) and pushed to
`origin/class-merge`; `git ls-remote origin class-merge` is compared with local HEAD after the push. A commit cannot
carry its own hash, so the two hashes side by side are in the batch's closing message, as HN's and HL's were.

## §8 — FOUND AND NOT FIXED

**In the game.**
- **FOUR OF HL's FIVE `heroes_…` KEYS ARE CONSTANTS IN A RUN PLAYED FORWARD** (§3c). `heroes_hold_core` is the one a
  drafted party answers either way.
- **TWO THINGS THE GAME ALREADY HOLDS WAIT FOR A HERO DOWN BETWEEN FIGHTS, AND CAN NEVER FIND ONE.** The event *The
  Cairn of the Fallen* (`fallen_cairn`, weight 8) requires a member at 0 health and raises the fallen at 35%: **it
  cannot be drawn.** Eleven lines write a member's health; the one that writes a 0 is the fight's own banking
  (`battle._bank_party_losses`), which stops once a fight is decided, and every victory then writes at least a fifth
  (`check_ho` §2b drives it). Measured on this batch's own simulated runs: **0 of 3,957 events drawn, where each of
  the other nineteen was drawn at least 18 times.** And a Revive Potion used from the map (`map_screen._use_item`:
  *revive offers the fallen*) can only answer *"No one to use the Revive Potion on."* Both wait for the state
  *Gravesong* waits for, and ruling 1's second option would wake all three.
- **THE RUN SUMMARY NAMES NO CREST RUNE.** `battle._member_summary` lists each hero's own `runes`; the crest is left
  out, as core runes have been since GK and the bag since HK.
- **THE SIM'S COUNTER CAN STILL STOCK A CORE RUNE** (`run_sim._roll_rune_offers` rolls `generate_rune`); the real
  Peddler has sold none since HL §1. `check_he` §1's and `check_hf` §3's "Peddler" tallies roll the same door.
- **FIVE COMMENTS STILL NAME FAITH'S THRESHOLD AS FIVE** (§0b): `unit.gd:988`, `battle.gd:17555`, `:17571`, `:17967`,
  `:27524`.
- **TITHE'S RULE PAYS AT LEAST 1 A BLOW, EVEN A BLOW THAT APPLIED NO BREAK, AND A PARTY AT FULL HEALTH PAYS THE
  WARRIOR** and wastes it. Both are the talent's read site, unchanged.
- **FELLOWSHIP CAN CLEAR THE BLEED WARNING CHIP**, which comes back on the next hit; the talent always could.
- **`_on_vow_share` AND `_on_rite_return` LEAVE THE DAMAGE FRAME ON THE DEVOUT** mid-blow: three of 5,630 measured
  debuff landings were attributed through it. Whether the rest of that blow's damage is booked to him was not
  followed.
- **`shop_screen._roll_offers`' FOUR-ATTEMPT RE-ROLL LOOP IS DEAD SINCE HK** — `peddler_rune` already excludes what the
  party holds.
- **HOLY CONDUIT ADDING RATHER THAN SETTING CHANGES NO NUMBER TODAY** (control K15): it runs before any payload. It is
  built as the brief asked and pinned at the source.
- **THE BRIEF'S PRECEDENT — *the shape that retired Skirmisher and Tracker* — IS NOT IN THE GAME**: both are live core
  runes.

**In the instruments.**
- **`check_gv` §4's EVENT DOOR HAS NEVER FIRED.** Its roads press an event's first choice, and the one event that grants
  a rune grants it on its second. The branch is re-pointed and is still an arm that never runs.
- **THE SHAPES THAT ARE LATENT FOR A CREST RUNE OF ANOTHER KIND, THE EIGHT WALKS THAT DO NOT ASK THE PAIR, AND
  `check_gf`'s MISSING QUIT** — §7b's last paragraph; each is in `docs/state.md`.
- **`check_fd` §1a's EIGHT NEEDLES ARE HELD IN A CONST LIST, WHICH THE PIN MANIFEST CANNOT SEE** — three pins left it.
  The arm itself asserts each needle lives in `run_state.gd`.
- **THE SIM'S REPORT KEYS, FOUND WHILE MEASURING**: `hero_deaths` counts companions (1,711 against 1,480 hero bodies in
  one log), and `heal_hero_*` includes overheal. A full-depth sim puts *Cleanse Debuffs Each Turn* and *Mitigation per
  Debuff You Carry* on all four heroes, so a talented baseline is already eight cleanses a round.
- **TWO STALE THINGS THE CENSUS MET, NEITHER THE CREST'S**: `check_ct_map.gd:107` has been vacuous since FD §1, and
  `check_gp.gd:1039`'s comment says `hold_rune` slots an engine while a slot is free.

**On the machine.**
- **461 OLDER ISOLATED USER-DATA FOLDERS REMAIN** (142,224 KiB) — outside the policy; the designer's.
- **THIS BATCH'S OWN**: fifteen *"Dawn of Decay HO …"* folders, 41,304 KiB, named in §5 — they stay one batch, and HP
  clears them by that prefix.

## §9 — WHAT MOVED

**THE GAME.** `scripts/unit.gd` (`hero_spawn_defaults`, `HERO_PARRY_CHANCE`, two `rune_` fields, the clamp's comment),
`scripts/classes.gd` (`hero_config` carries the defaults; Elevation's words and comments), `scripts/battle.gd` (Holy
Conduit adds; the parry line; the two read sites' sums and the log's name; Elevation's comments), `scripts/talents.gd`
(the two lines of §2), `scripts/runes.gd` (two rows in each of three tables), `scripts/shop_screen.gd`,
`scripts/map_screen.gd`, `scripts/events.gd` (whose rune it is), `scripts/run_sim.gd` (the counter),
`scripts/party_screen.gd` (a comment). `data/runes.json`: two entries, 166 → 168. `data/glossary.json`: two
sentences.

**THE DOCUMENTS.** `docs/changelog.html` (the entry), `docs/design-notes.md` (the entry, at the top),
`docs/master.html` (the stamp; Elevation's row; the crest's paragraph; and its rune counts, scope and price, which
still said sixty live runes, all of a class, at 100 gold), `docs/instrument-rules.md` (two blocks, and a bullet in DA
§3 / DB §1's), `docs/state.md`, `CLAUDE.md` (+6,517 B, to 413,431 B = 403.74 KiB of 470: the standing rule on
magnitudes in text; the crest block; FK §2a's bullet; two index rows; one count), and this report.

**THE INSTRUMENTS.** `check_ho.gd` (new, 170). Re-pointed, each with its reason at the site: `check_ek`, `check_es`,
`check_ez`, `check_fd`, `check_fe`, `check_fh`, `check_fk`, `check_flow`, `check_fo`, `check_gv`, `check_gx`,
`check_hc`, `check_hf`, `check_hk`, `check_hl`, `check_hn`, `test_batch_bk`, `test_runes`. `suite_fixture.gd` (two
helpers). `run_battery.sh` (`check_ho` in GATES; `check_gp`'s own bound). `baselines.json` (twenty rows move,
`check_ho`'s new among them; seven more gain a note). `pin-manifest.json` rebuilt, 1,560 → 1,593 pins.
