# BATCH HP — THE CONDITION AS A FIGHT RUNS, AND THE THREE RUNES IT MAKES REAL

**On `class-merge`, from `d8ed141` (HO). IMPLEMENT ONLY.** HO's seven rulings are taken (§0). **The continuous half of
HK's door 3 is built** (§1): four of the five `heroes_…` keys are read again at every death and every revive, a live
payload is written on the built heroes once the fallen are laid down and rebuilt from its base at every switch, and a
switch is a line in the log both ways. §1's stop clause did not bind. **Empty Pulpit, Dead Air and Dirge are
authored against it** (§2), their figures proposed against a measurement of how often and how late their conditions
hold. **Fellowship is retired** on ET's contract (§3), **Tithe's words narrow** (§4), **FN's ruling is reconciled** in
three gates each re-pointed to its own intent (§5), and the small things are done (§6). A new gate, `check_hp`, drives
all of it.

**VERDICT: IT SHIPS.** The acceptance run in the repository read `check_de` 541 / 0 / 0 over 131 targets, every target at
its row, the tree byte-identical after it and the player's four files byte-identical to the backup (§8e). Five rulings
are owed, the first three magnitudes; none blocks the batch.

## NEEDS A RULING — FIVE; THE FIRST IS THREE MAGNITUDES AND THE SECOND IS WHAT A RETIREMENT KEEPS

1. **THE THREE LIVE CREST RUNES' FIGURES ARE PROPOSED: DIRGE 45%, EMPTY PULPIT 50%, DEAD AIR 50% (§2).** At the brief's
   25 / 12 / 12 they were worth 0.50, 0.08–0.09 and 0.08–0.15 of what a bare ±10% on every hero adds over the same
   fights, and moved nothing about a run. At the proposed figures each pays 4½ to 5 times the bare figure while it
   holds (FN's relation, `check_fn` §1b) and is worth **0.72–0.86 (Dirge), 0.77–0.81 (Empty Pulpit) and 0.26–0.49
   (Dead Air)** of the bare over the same fights. **Dead Air is the one I trust least**: how often no Mage stands
   depends on which Mage (the Arcanist is down for 13–15% of a normal fight's hero turns, the Pyromancer for 6–11%), and
   matching the bare worth would take 80–180%. Only Dirge moved a run's depth (party A, 19.4 → 22.3 ±0.9). **Empty
   Pulpit pays mostly inside fights already being lost**: in a normal fight that is WON the Cleric is down for 2% of the
   damage taken.
2. **FELLOWSHIP'S FIELD WENT INTO RETIREMENT WITH IT, NOT OUT OF THE GAME (§3).** The brief's *if none, they go with the
   rune* is read as ET's procedure, which the same line names: `rune_field_medic` has no other writer, so it is kept
   beside the retired entry with its read site and its log name. **So a save that held it loads WITH it, still worn and
   still paying**, not *without it*, and `data/runes.json` went 168 → 171 (three authored, none deleted), not 167.
   `check_et` §5 and `check_dp` §4 red on a retired rune's field with no reader, and FO §2's rule (`CLAUDE.md`, the
   Melted Armor contract) keeps it. Deleting the field would overturn FO §2 for this rune and change a retired entry's
   payload; the designer's call.
3. **`heroes_hold_core` STAYS AT THE SPAWN, AND ITS REASON IS HALF OF WHY IT COULD MOVE (§1a).** Nothing in the battle
   writes an engine's slot (GM §2) — but the key counts the heroes who STAND (HL §6), so read once it stays paid after
   its only holder falls: the staleness the four live keys no longer have. `check_hp` §1f prints the key turning false
   with its holder down. Confirm, or make it live — one line: it joins `LIVE_KEYS`, and a payload carrying it then
   refuses a consumed field.
4. **TITHE'S WORDS ARE TRUE OF ITS READ SITE BUT FOR THREE NARROW CASES (§4)**: Break a card lands in its own handler,
   the Long Watch's carry onto a second enemy, and a blow that lands no Break, which still heals 1. The talent
   *Breaking Heals a Hero* says *every point of Break damage dealt* over the same site.
5. **THE WORDS, PROPOSED**: a switch's lines (*its condition holds now, so it pays from here* / *its condition no
   longer holds, so it pays nothing from here*), the roll call's *its condition does not hold as the fight opens, so it
   pays nothing until it does*, the refused tail *its payload is refused, so it pays nothing this fight*, and the run
   summary's *The crest: …* and *The bag: …*.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | Four of HL's five keys are constants in a run played forward | **Held** (HO §3c; `check_ho` §2a/§2b). |
| 2 | `heroes_hold_core` cannot change inside a fight — nothing in `battle.gd` writes an engine's slot | **The slot: held** (`check_hp` §1f sweeps it). **The key: half** — it counts the heroes who stand, so its holder's fall turns it (RULING 3). |
| 3 | A field read fresh is reversible; a consumed one is not | **Held**, and the line is derived per field (§1b): 17 of the 28 read fresh, 11 consumed. |
| 4 | `dmg_bonus` and `dmg_taken_bonus` are terms in a sum read on every blow | **Held**: one read site each, and nothing writes either after the spawn. |
| 5 | The hard cases: `max_hp`, `max_resource`, the max-merged stamps, a card grant | **Held, and the census is larger**: a companion copies six of a Hunter's fields at every summon (`attack`, `armor`, `speed`, `stability`, `constitution`, `crit_bonus`), Whetstone writes Attack mid-fight, Iron Will's chip is laid at the spawn, and the first turn order is seeded off `speed`. |
| 6 | The doors are a death, a revive (two callers) and a quit fight's fallen laid down | **Held, and they are two functions**: `dead` is written in `unit._die()` and `revive()` and nowhere else; the lay-down passes `_die()`. No door is missing (§1c). |
| 7 | The tell: GX's rule covers a rune that pays nothing at the spawn; a mid-fight switch is new | **Held**; the switch has its own lines (§1c). |
| 8 | HO measured 0.38 to 0.85 deaths a fight, which is not the denominator | **Held**: the denominator is hero turns with a hero down — about a fifth of a fight (§2). |
| 9 | *Cold Hearth* and *Gravesong* are not authored, so their names are a naming decision | **Held.** |
| 10 | Fellowship is live; `data/runes.json` 168 → 167 | **Live: held. 168 → 167: did not hold** — ET's procedure keeps the entry; with §2's three the file is 171 (RULING 2). |
| 11 | The player's save holds four core runes and no other | **Held**, by hash against HO's backup (§8); no save on disk holds Fellowship. |
| 12 | *Tithe* reads only the Break an ordinary blow applies | **Held** (§4), with the floor of 1 HO found. |
| 13 | Three gates red on a `condition` key: `check_ez` §4, `check_fn` §1b, `check_fx` §5 | **Held**, and each asks a different thing (§5). |
| 14 | The run summary omits the crest, core runes since GK and the bag since HK | **Held** (§6). |
| 15 | `run_sim._roll_rune_offers` rolls `generate_rune` | **Held** (§6). |
| 16 | Five comments name Faith's threshold as five | **Held, and there were thirteen** in the present tense (§6). |
| 17 | `shop_screen._roll_offers`' re-roll is dead since HK | **Held, and the sim's mirror of it too** (§6). |
| 18 | HO's fifteen copies, prefix *"Dawn of Decay HO …"* | **Held**: fifteen, 41,256 KiB now (HO recorded 41,304) (§6). |
| 19 | Tithe's collision is a relic's id in a table nothing resolves through | **Held** (`check_ho` §5e). |
| 20 | HO read 130 targets in 74 min 12 s | Not taken as a runtime; measured (§8). |
| 21 | Pointing the sim's counter at the Peddler's door may move `check_he` §1's and `check_hf` §3's figures | **They moved, and not for that.** Neither reads the sim's counter: both tally `Run.generate_rune`, the door the Peddler left at HL §1. Run on HP's tree with the three new entries retired and Fellowship restored, both read HO's acceptance exactly — the move is the crest's four runes in every offer (§6, §9). |

## §0 — HO'S SEVEN RULINGS

All seven are taken as ruled. **1**: the continuous half is built (§1) and the three runes authored against it (§2);
the reasoning, and the three answers it was chosen over, are in `CLAUDE.md`'s crest block and `docs/design-notes.md`.
**2**: Tithe holds at 30 and its words narrow (§4). **3**: Fellowship is retired (§3). **4**: FN's ruling stands and a
conditioned rune pays more than the bare equivalent (§5). **5**: *a card stating its own cost and payout is what a card
is* is recorded in the magnitudes rule itself. **6**: the crest's words are kept as HO proposed them, and no marker.
**7**: *Cold Hearth* is **Dead Air** and *Gravesong* is **Dirge**; Tithe keeps its name. `check_hp` §2f swept the two
new names against 1,022 names in fourteen populations: Dead Air near-misses the Survivalist's zone-boss card
*Deadfall* (a shared stem), and ships as a named near-miss.

## §1 — THE CONDITION AS A FIGHT RUNS

**WHAT IT COST, AGAINST HL §6's PRICE.** HL priced *a door where the party's state changes, a reversible stamp, and a
tell* as a batch of its own. It was: about 70 lines of code in `talents.gd` (the keys, the derived field lists, the
refusal, the deferral in `apply_payload`), about 100 in `battle.gd` (registration at the spawn, the opening read, the
two doors, the recomputation, the tells), 4 in `unit.gd` (the revive door) and 4 in `runes.gd` (the refusal at load) —
and a gate. It worked on its first drive, so **§1d's stop clause did not bind** and §2 proceeded. The cost that HL did
not price is in the instruments: every fixture that drove a `heroes_…` key did it on maximum health, which the door now
refuses (§8).

### §1a — THE KEYS, AS RULED

`Talents.LIVE_KEYS` = `heroes_include_class`, `heroes_lack_class`, `heroes_class_count`, `heroes_all_standing` (both
values). **`heroes_hold_core` stays at the spawn**, and the premise it was ruled on half holds: nothing in `battle.gd`
writes an engine's slot (swept), but the key counts the heroes who stand, so read once it stays paid after its only
holder falls (RULING 3). A live payload's other keys — `heroes_hold_core`, `has_node`, `owns_ability` — are weighed once,
at the spawn; if they fail it pays nothing that fight.

### §1b — WHICH FIELDS A LIVE PAYLOAD MAY WRITE — DERIVED

**The population is HN §3a's twenty-eight every-hero fields.** Each was read at every line in `battle.gd` and `unit.gd`
that reads or writes it (comments stripped), and at `_do_summon`, which builds a companion from its Hunter.

| read fresh — reversible (17) | read at |
|---|---|
| `dmg_bonus` | the strike loop's one multiplier term, every blow dealt |
| `dmg_taken_bonus` | the strike loop, every blow taken |
| `parry_bonus` | the parry roll, every melee blow taken |
| `pierce_bonus` | the strike loop's armor term |
| `block_chance` | the block roll, and the Heavy Plating chip, refreshed with the bars |
| `broken_will_ranks` | every blow's Break, summed with its `rune_` twin |
| `blood_communion` | every hero blow on an enemy (Tithe's site), summed with its twin |
| `bonecracker_ranks` | every blow on a Broken enemy, summed with its twin |
| `field_medic` | every hero's turn start, summed with its twin |
| `follow_through` | on a crit |
| `deflection` | every ranged blow taken |
| `undying_rage` | the lethal blow and every blow dealt below a quarter, with its own once-a-fight latch; its chip is refreshed each turn |
| `no_cover` | every blow dealt |
| `sundering_shot` | on a crit |
| `no_quarter_ranks` | on a Break |
| `rapid_fire` | every cast with a cooldown |
| `snap_shot` | every cast that costs, against its own `snap_used` counter |

**And the four `rune_` twins** (`rune_broken_will_ranks`, `rune_blood_communion`, `rune_bonecracker_ranks`,
`rune_field_medic`) are live too: each is summed with its node's field in the one expression that reads them. **No
live field is written after the spawn** — `check_hp` §1b sweeps for an assignment and finds only the spawn's own
hand-over of `parry_bonus`.

| consumed — refused (11) | where |
|---|---|
| `max_hp` | builds the health bar at the spawn, and the spawn scales it after the payloads |
| `max_hp_pct` | multiplied into maximum health at the spawn; not a unit field |
| `attack` | the spawn scales it after the payloads; a companion copies it at every summon; Whetstone writes it mid-fight |
| `armor` | a companion copies it at every summon |
| `crit_bonus` | a companion copies it at every summon, and a battle modifier floors it at the spawn |
| `speed` | the first turn order is seeded off it once, and a companion copies it at every summon |
| `max_resource` | builds the resource bar at the spawn; every gain is clamped to it |
| `iron_will_ranks` | its chip is laid at the spawn, only when the figure is above nothing |
| `whetstone` | its payout writes Attack for the rest of the fight, so taking the field back leaves what it paid |
| `constitution` | a companion copies it at every summon, and Unrelenting lends and takes back Constitution mid-fight |
| `stability` | a companion copies it at every summon, and the Break bar is filled against it |

**The party-wide stamps** (`devoutness_ranks`, `last_hope_pct`, `guardian_step` and the two twins, HN §3a's third
group) are refused beside them: the battle takes the best holder's figure once, at the spawn. **A card, an ability's
figures, a live condition nested in an `also` or `upgrade`, and a field on neither list** are refused as well.
`Talents.live_refusal` is the one answer; `Runes._load` asks it of every entry as the table loads and `push_error`s,
and `Talents.apply_payload` asks it wherever a payload is applied, so a refused payload is paid by no route — at the
spawn the roll call says *its payload is refused, so it pays nothing this fight*.

### §1c — THE DOORS, THE REVERSAL AND THE TELL

**THE DOORS.** `dead` is written in exactly two places in the game's scripts — `unit._die()` and `BattleUnit.revive()`
— and `check_hp` §1a sweeps every script to say so. `_die()` already called `died_cb` (GO); `revive()` now calls
`revived_cb`, and the battle wires both where every unit is made. **HL's third door, a quit fight's fallen laid down,
is the first door**: `_lay_down_the_fallen` calls `_die()`. It is read as the OPENING, not a switch: the live payloads
are opened right after the lay-down, and before that the door has nothing registered to switch. **No door is missing.**
Death refusals (Rite of Return, Intercession, Martyrdom, Ashes of Al'ar, Undying Rage, Hold the Line) all act before
`_die()` and change nobody's standing; the debug *Full Restore* skips the dead.

**THE REVERSAL — A RECOMPUTATION, BECAUSE A SUBTRACTION IS NOT EXACT.** The brief asked that the number return to
*exactly* what it was. Taking a figure back by subtraction does not: a hero at the Dragonbone Idol's 0.10 who gains 0.25
reads 0.35, and 0.35 − 0.25 is 0.09999999999999998. So each touched field keeps its value from before any live payload
wrote it, and is set to that base plus every live payload on it that holds now, in the order they were registered;
the same set always yields the same bits. **Driven (`check_hp` §1d)**: open 0.10 on all four; the Mage falls through
the damage door, 0.35 on all four; he is raised through the battle's own Revive Potion, 0.10 bit for bit (`==`, not
approximately); he falls again, 0.35 — the same bits as the first fall. The subtraction's figure is printed beside it.
A field another writer moves between two reads keeps that move (the door folds it into the base); no live field has
such a writer.

**THE TELL — WHAT WAS WRITTEN.** At the opening, the roll call's tail for a live rune whose condition does not hold is
*"its condition does not hold as the fight opens, so it pays nothing until it does"* (the spawn-read tail said *this
fight*, which a live rune cannot promise). At every switch after it, a line in the roll call's shape:
*"Rune: the crest: Dirge — its condition holds now, so it pays from here"* and *"… — its condition no longer holds, so
it pays nothing from here"*. For a hero rune the line names the hero.

**THE QUIT-AND-RESUMED FIGHT AGREES WITH THE SPAWN-TIME READING.** Driven (`check_hp` §1e): a fight opened with a live
crest, the Mage killed, the save loaded, the real resume — the fight reopened with one down and the crest paying on all
four from the opening, the roll call carrying no tail, and no switch line.

## §2 — EMPTY PULPIT, DEAD AIR AND DIRGE

> **Empty Pulpit** — *While no Cleric stands, every hero takes 50% less damage.* `heroes_lack_class: "cleric"`,
> `dmg_taken_bonus` −0.50. **Dead Air** — *While no Mage stands, every hero deals 50% more damage.*
> `heroes_lack_class: "mage"`, `dmg_bonus` +0.50. **Dirge** — *While a hero lies fallen, the rest deal 45% more damage.*
> `heroes_all_standing: false`, `dmg_bonus` +0.45. Crest runes, 150g, bare-named, words broken under 44.
> **EVERY FIGURE IS PROPOSED.**

### §2a — THE MEASUREMENT, TAKEN FIRST

**How.** A probe in isolated copies (never the repo) booked, per battle: every hero's fall and rise with the hero turn
it landed on; the hero turns taken while each seat was down; the damage dealt and taken through the strike loop, split
by whether a hero was down, the Cleric was down, or the Mage was down; and, with a rune worn, **exactly what its live
part added to each blow** (the blow's damage × the live share of its multiplier). The crest was worn from the first
fight of every run. Rung 2, no talents, 150 runs an arm, two parties: **A** = Berserker, Arcanist, Devout, Beastmaster
(HO's party A), **B** = Swordmaster, Pyromancer, Holy, Sharpshooter (a weaker party with the one revive card). Normal
fights only below; ± is a standard error over runs. *Rounds* are CY's: hero turns ÷ 4.

| arm | normal fights | rounds | falls | hero turns with one down | no Cleric | no Mage | strike damage dealt | of it with one down | with no Mage | damage taken | of it with no Cleric | the rune paid | depth of 49 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A, none | 660 | 7.92 ±0.12 | 0.74 ±0.05 | 22.1% | 2.8% | 14.4% | 614 | 21.4% | 12.2% | 303 | 8.6% | — | 19.4 ±0.8 |
| A, Dirge 25% | 643 | 7.67 | 0.73 | 21.9% | 2.7% | 14.2% | 637 | 24.0% | 13.1% | 289 | 7.1% | +30.5 ±2.6 | 19.2 ±0.8 |
| A, Dead Air 12% | 610 | 7.73 | 0.73 | 23.1% | 2.8% | 14.7% | 613 | 24.2% | 13.5% | 295 | 7.3% | +8.8 ±1.2 | 18.4 ±0.8 |
| A, Empty Pulpit 12% | 643 | 8.04 | 0.61 | 20.6% | 2.1% | 15.0% | 615 | 19.3% | 12.7% | 303 | 6.0% | 2.5 ±0.4 kept | 18.6 ±0.7 |
| **A, Dirge 45%** | 795 | 7.78 | 0.67 | 20.5% | 3.3% | 12.7% | 679 | 25.7% | 13.1% | 301 | 7.8% | **+53.5 ±3.7** | **22.3 ±0.9** |
| **A, Dead Air 50%** | 595 | 7.37 | 0.72 | 20.5% | 3.0% | 12.8% | 576 | 22.9% | 14.0% | 273 | 8.7% | **+26.7 ±3.3** | 18.3 ±0.6 |
| **A, Empty Pulpit 50%** | 758 | 7.79 | 0.65 | 21.1% | 5.5% | 13.3% | 623 | 21.9% | 11.8% | 284 | 8.4% | **23.7 ±2.6 kept** | 20.8 ±0.8 |
| B, none | 404 | 6.33 ±0.12 | 1.05 ±0.07 | 23.4% | 4.4% | 8.0% | 510 | 21.3% | 5.5% | 316 | 7.0% | — | 13.1 ±0.5 |
| B, Dirge 25% | 419 | 6.02 | 1.08 | 22.2% | 5.8% | 6.8% | 506 | 24.2% | 5.8% | 297 | 9.4% | +24.4 ±1.9 | 13.5 ±0.5 |
| B, Dead Air 12% | 376 | 6.22 | 1.08 | 24.4% | 2.8% | 10.7% | 498 | 20.9% | 7.6% | 321 | 6.5% | +4.1 ±1.2 | 12.7 ±0.5 |
| B, Empty Pulpit 12% | 422 | 6.13 | 1.11 | 23.7% | 4.6% | 8.5% | 490 | 21.5% | 5.8% | 325 | 7.1% | 3.1 ±0.4 kept | 12.8 ±0.4 |
| **B, Dirge 45%** | 450 | 6.21 | 1.02 | 19.5% | 3.3% | 6.4% | 531 | 21.7% | 5.7% | 314 | 5.8% | **+35.6 ±2.7** | 13.4 ±0.5 |
| **B, Dead Air 50%** | 398 | 6.18 | 1.02 | 23.5% | 4.4% | 7.4% | 519 | 24.1% | 7.7% | 304 | 7.3% | **+13.3 ±2.3** | 13.1 ±0.5 |
| **B, Empty Pulpit 50%** | 388 | 6.37 | 1.14 | 25.5% | 10.4% | 5.7% | 518 | 24.5% | 3.8% | 306 | 8.9% | **27.1 ±3.2 kept** | 13.0 ±0.4 |

**The brief's three questions, answered.**
- **How many rounds of a normal fight a hero spends fallen.** In party A a normal fight is 7.9 rounds and 1.75 of them
  (hero turns ÷ 4) are taken with at least one hero down; the Mage alone is down 1.14 rounds, the Cleric 0.22. In
  party B, 6.3 rounds, 1.48 with one down; the Mage 0.50, the Cleric 0.28. **About a fifth of a fight, whichever
  party** — which is the denominator the three pay against, and the reason 12% and 25% were small.
- **How late a hero falls.** The first fall of a fight that has one lands 0.33 (A) and 0.42 (B) of the way through its
  hero turns (medians 0.29 and 0.40); every fall averaged over, 0.64 and 0.69, with the upper quartile at the very end
  — a lost fight falls in a cascade. **A third of normal fights have a fall (31–42%), and of those, 40–50% are the
  fight that ends the run.** In a WON normal fight a hero is down for 16–18% of the damage dealt, the Cleric for 2% of
  the damage taken.
- **What each is worth over a fight at the proposed figure.** Against what a bare ±10% on every hero adds to the same
  fights (the tree's two nodes, the reference `check_fn` §1b holds): **at the brief's figures Dirge 0.50–0.51, Dead
  Air 0.08–0.15, Empty Pulpit 0.08–0.09; at the proposed figures Dirge 0.72–0.86, Dead Air 0.26–0.49, Empty Pulpit
  0.77–0.81.**
- **And revives are rare in play**: 0.000–0.003 a normal fight in party A and 0.005–0.048 in B, where the Holy can
  cast Resurrection; the sim uses no Revive Potion in a fight. So a switch OFF in a sim is almost always the fight's
  end, and `check_hp` drives the revive by hand through the real item door.

### §2b — THE FIGURES, AND WHY

**FN's reconciliation sets the floor and the measurement sets the height.** A conditioned rune must pay more than the
bare equivalent while it holds (§5). How much more follows from how often it holds: Dirge's condition holds for a fifth
of a fight's damage in both parties, so a figure about five times the bare one is worth about as much over a fight.

- **Dirge 45%** — the figure at which it is worth nearly what a bare 10% is worth over the same fights (0.72–0.86), the
  same in both parties; in the moment the three standing deal 1.45 times, a little more than makes up the fallen one
  (1.33). The one rune that moved a run's depth (A: 19.4 → 22.3, about 2½ standard errors; B: none).
- **Empty Pulpit 50%** — worth 0.77–0.81 of the bare, and the family's own reason stands behind the size: *no Cleric
  pays mitigation for the healing that is missing*, and a Cleric's healing and prevention are a large share of what
  keeps the four up (the sim's per-hero report puts the Devout's at 302 a battle beside 270 taken). **It pays mostly in
  fights being lost** (2% of the damage taken in a won normal fight is taken with the Cleric down).
- **Dead Air 50%** — worth 0.26–0.49 of the bare. Matching the bare would take 80–180%, and fully standing in for the
  Mage's share of the damage (41–46%) 69–85%; 50% is the figure at which the three standing make up about two thirds of
  the missing Mage. **The number I trust least**, because how often no Mage stands depends on which Mage.
- **Priced with the other crest runes at 150g**; the measurement argued for no other price.

### §2c — THE REAL ROUTE, AND A REAL FIGHT

Driven (`check_hp` §2b–§2d): each is in every hero's pool at every roll; with the pool parked to it, **a real normal
fight's drop puts it in the bag**; the bag's own Equip door (`party_rune_rows` → `toggle_party_rune`) wears it in the
crest; then **a real fight in which its hero falls and is revived** — it pays on all four exactly while its condition
holds, and the figure returns to the heroes' base at the revive (`==`), the log saying both switches. A fall that is
not its condition's switches nothing. A seeded blow pays what the words say: the Warrior's basic took 17 with all
standing and 25 with the Hunter down under Dirge (×1.45); a foe's blow took 43 from the Warrior with the Cleric up and
21 with him down under Empty Pulpit (×0.5).

## §3 — FELLOWSHIP IS RETIRED

**ET's procedure**: the entry is kept with a `retired` string that names the batch and what is lost (`check_et` §1's
test), its payload and its `RUNE_SHAPES` row stay, and `Runes.eligible_ids` skips it — no door offers it (`check_hp` §3:
0 of four heroes, where Tithe beside it reaches all four). **`rune_field_medic` has no other writer** — the talent
writes `field_medic`, its own counter — so it is now one of the fields only a retired rune writes (`check_et` §5's
ratchet may grow) and **its read site stays**, summed with the talent's in the one loop that cleanses (RULING 2 says
why it was not deleted). **`_crest_name_for`'s branch stays with it**: a saved run wearing Fellowship is still paid, and
the log still names the crest rune rather than the talent for each cleanse it pays.

**THE PLAYER'S SAVE HOLDS FOUR CORE RUNES AND NO OTHER** — read directly by a read-only probe in an isolated copy:
version 13, the Runes of the Swordmaster, the Cryomancer, the Oathkeeper and the Sharpshooter in the four heroes' core
slots, no ordinary rune, an empty bag and no crest; its hash was the same before and after, and the same as HO's
backup. **A save that did hold it loads WITH it** (`check_hp` §3: a run saved with Fellowship in the crest loaded with it in the crest, and
the next fight's spawn put its field on all four), which is ET's contract, not *without it* (RULING 2).

**THE FINDING IS IN `CLAUDE.md`** (the crest block): hero-side debuff supply is 0.296 a round, four cleanses a round is
thirteen times demand, 1 is the floor of *each hero, each turn*, and the layer it deleted is worth 1.9% of damage
taken.

## §4 — TITHE'S WORDS

> **Tithe** — *A hero's attack that lands Break heals whoever among the four is lowest, for 30% of it.*
> Broken 38 / 33 / 14 characters.

**True of the read site, but for three narrow cases** (RULING 4). The site is `_resolve`'s strike loop, on a hero's
blow into an enemy, paying `max(round(Break applied × share), 1)` to the lowest standing hero by share of health. So:
a card whose Break lands inside its own handler pays nothing, though a player may call it an attack; the Long Watch's
carry onto a second enemy pays nothing; and a blow that carries Break into an enemy already Broken applies none and
still heals 1. HO measured the size of what the words used to claim: party A booked 42.1 Break a round and the site read
41.8; the Long Watch Warden's party booked 66.3 and it read 42.4.

**The read site is not widened.** It is *Breaking Heals a Hero*'s too, so widening it is a talent rebalance, recorded
as owed in `docs/state.md` with HO's figures.

## §5 — FN'S RULING, RECONCILED

**Three gates, three questions.**
- **`check_fx` §5** holds that *nothing reads a node but the tree's own door*. A condition was only ever a node read
  while the tree's `has_node` was the one condition a rune could carry. It counts a condition naming `has_node` now,
  and prints every condition it read (3, none naming a node).
- **`check_ez` §4** is EZ's: every payload lands, and none carries EZ's retired tag conditions. It counts
  `tag_threshold` and `tag_breadth` now, and **lands a payload that asks who stands on a party for which it holds**
  (through the hero sheet's route), so every live payload in its population still lands its field (79 of 79).
- **`check_fn` §1b** is FN's pricing rule, and it holds the relation: every live rune carrying a condition writes each
  field strictly beyond the largest figure a bare writer of that field carries — a live rune with no condition, or a
  node of the one tree. Today each of the three is weighed against the tree's node: Empty Pulpit's −0.50 against
  *tn_guard*'s −0.10, Dead Air's +0.50 and Dirge's +0.45 against *tn_damage*'s +0.10. **A conditioned rune authored at a
  bare figure reds** (control H16), and a field no bare writer carries reds until the batch names a reference.

The rule is recorded in `CLAUDE.md`, in FN's block: *a conditioned rune pays more than the bare equivalent*, and the
answer is the magnitude.

## §6 — THE SMALL THINGS

- **THE RUN SUMMARY** names each hero's core runes first on his *Runes* line (each core rune's name carries *(core)*),
  and adds *The crest: …* and *The bag: …* under the heroes — *empty* when empty. The snapshot carries the crest and the
  bag, which it never did.
- **THE SIM'S COUNTER** rolls through `Run.peddler_rune`, the real counter's door, so it stocks no core rune (`check_hp`
  §6: 0 core of 240 stocked over 60 counters dealt to a party holding no core rune). **`check_he` §1's and `check_hf`
  §3's Peddler tallies moved, and not because of it**: neither reads the sim's counter — both tally `Run.generate_rune`
  (§9). Every figure in both tables moved (Slaughterhouse at the Peddler 27 → 26, the Bared Plate 27 → 35, the Long
  Fuse 30 → 20; Goading Roar 33 → 26), because every offer now carries four crest runes where it carried two. **A stub
  arm proves it**: HP's tree with the three new entries retired and Fellowship's retirement taken off reads both gates
  exactly as HO's acceptance did, line for line.
- **THE DEAD RE-ROLL** is deleted from `shop_screen._roll_offers` and from the sim's mirror of it: every roll already
  leaves out what the party holds (`party_rune_names`, the hero's own list among it), so the loop's one question could
  only be answered no.
- **FAITH'S THRESHOLD AS A FIGURE, THIRTEEN COMMENTS.** HO named five; a sweep of every comment found eight more
  present-tense claims — and the eighth only on the gate's own run, because the sweep skipped lines opening with a
  batch mark and that header did. Each now names the rule (*the threshold*, *the cap*, `FAITH_RELEASE`). Dated history
  (*CZ moved it 5 → 3*) stays. The rule's census is cleared; `check_hp` §6 holds the thirteen phrases absent.
- **HO's FIFTEEN COPIES** moved to the Trash under *"DoD spent user-data folders (Batch HO's fifteen, cleared at HP
  2026-09-30)"*: 15 folders, **41,256 KiB**. Godot's `app_userdata` went from 483 folders and 185,972 KiB to 468 and
  144,736 KiB; the 461 older folders and the live *Dawn of Decay* folder were not touched, nor `../save-backups/`.

## §7 — WHAT WAS DELIBERATELY NOT DONE

- **Whether a fallen hero stays down between fights** is not decided; *The Cairn of the Fallen* and a map Revive Potion
  wait on it, and `docs/state.md` says so.
- **Skirmisher and Tracker** are recorded as RULED, NOT BUILT, with new names owed (`docs/state.md`, `CLAUDE.md`).
- `heroes_class_count` still reads a named class; no OR and no list form; no card-granting crest rune (and the bot owes a
  case for one); no Kinship rune; no *no Warrior* or *no Hunter* crest; Tithe's read site not widened; the crest cap at
  one; `CLAUDE.md` not split; Volley, Ambusher and Channel's tempo payout not built.

## §8 — VERIFICATION

**THE ORDER.** The saves were backed up and verified by hash before anything else. **HEAD's unmodified instruments were
launched against the new game and documents (the recon, §8a) before any existing gate was edited** — at 20:33:42, with
the prediction written the same second — and the first five re-points (`check_ez` §4, `check_fn` §1b, `check_fx` §5,
`check_hl` §6, `check_hn` §3) were made in the repo while it ran, each checked against the recon's FAIL lines as they
arrived. The documentation was written before the acceptance run. The controls (§8c), the pre-pass (§8d) and the
acceptance run (§8e) follow.

**THE BACKUP.** `../save-backups/HP-20260930-193909`: `profile.json` `2892470f…`, `relics.json` `fdc12ffa…`,
`run_save.bin` `fa85daa9…`, `settings.cfg` `0c1b39c3…` — each byte-identical to the live file and to HO's backup. The
player's run save is v13 and holds four core runes (Swordmaster, Cryomancer, Oathkeeper, Sharpshooter), no other rune,
no bag and no crest: no save on disk holds Fellowship.

### §8a — THE RECON: HEAD'S INSTRUMENTS AGAINST HP'S GAME AND DOCUMENTS

HEAD's every root script, runner, baseline table and pin manifest, against HP's `scripts/`, `data/`, `docs/` and
`CLAUDE.md`, in an isolated copy seeded from the backup. **130 targets — 129 rows and `check_de` — in 74 min 12 s.**
`check_de` 537 / 14 / 9 notices. Against the prediction: every predicted red was red but one, **`check_hk`, which read
142 / 0** (its §4 already counted crest runes by id); `check_fd`, UNSURE, was red; every other UNSURE target was green.

| target | HEAD's instrument on HP's tree | what it met |
|---|---|---|
| `check_es` | 57 / 1 | *the authored pool is 171 entries, expected 168* |
| `check_ez` | 134 / 6 | the pool and the crest's count; three payloads *did not land* on a party-less ctx; *3 runes carry a condition* |
| `check_fd` | 56 / 1 | *3 live runes carry a condition — FN retired both gated secondaries* |
| `check_fe` | 79 / 2 | DEFENSE 42, OFFENSE 34; 147 rows, not 144 |
| `check_fk` | 66 / 1 | *4 live runes are the crest's, not HO's two* |
| `check_fn` | 81 / 1 | *3 of 171 entries carry a payload condition* |
| `check_fo` | 90 / 1 | *the live pool is 79 … not 60 + 15 + 2* |
| `check_fx` | 496 / 1 | *3 rune payload(s) carry a condition — a rune reading a node* |
| `check_gv` | 1058 / 14, sixty throws | §0 ×8 (three unsorted, Fellowship sorted and retired), §1 ×6 (no board for a crest rune — the throws) |
| `check_gx` | 1366 / 1 | *37 ungated live ordinary runes — 35 since HO* |
| `check_hl` | 169 / 12 | §6's fixture paid `max_hp` through a live key, which the door refuses |
| `check_hn` | 74 / 8 | §3's fixture, the same |
| `check_ho` | 170 / 28 | §1 Fellowship not live and not offered (×13), §2c and §3 the fixture refused (×11), §2d the three in the file (×3), §5e *'Empty Pulpit' is the name of rune:Empty Pulpit* |
| `test_runes`, `test_batch_cb`, `test_batch_bh`, `test_batch_al`, `check_gs`, `check_gp` | green, +183, +27, +3, +3, +2, +9 | walks over rune ids; `check_gp`'s road |
| `check_gj` | 70 / 1, sanctioned | *the card says +175 gold and the purse moved 195* (HO's +153 / 173) |
| `check_cm_live` | 13 / 4, sanctioned | unchanged, line for line |

### §8b — THE RE-POINTS, AND THE COUNTS THAT MOVED

**Thirteen gates were re-pointed, each to its intent, with its reason at the site** — `check_es` §1, `check_ez` §0/§4,
`check_fd` §2, `check_fe` §1, `check_fk` §1, `check_fn` §1b, `check_fo` §2c, `check_fx` §5, `check_gv` §0/§1, `check_gx`
§1, `check_hl` §6, `check_hn` §3 and `check_ho` §1/§2c/§2d/§3/§5a/§5e — and `check_ek` lists `check_hp.gd` among the
targets that check a tag. Each re-point's reason is in its `baselines.json` row.
- **`check_gv` §1's crest arm had gone slack, and it is tightened.** It accepted a crest rune NAMED in `check_ho`'s
  `CRESTS` as driven, and at HP that const became §1's route pair, which names Dirge — a rune §5 never wears. It asks
  for a `check_ho` §5 section named for the rune, or `check_hp` §2's table and section.
- **`check_ho`'s `CRESTS` did two jobs**: the route arms' pair and §5's drive list. It is the route's pair (Tithe and
  Dirge); §5a asks HO's two entries by id, Fellowship retired and kept; §5e sweeps every crest entry.
- **Every count that moved is attributed by an ok() trace** (HEAD's target on HEAD's tree against HP's on HP's):
  `test_runes` +183 (the three entries' per-entry arms +111, Fellowship's retired arms −24, the grant loop's draws
  +96), `test_batch_cb` +27, `test_batch_bh` +3, `test_batch_al` +3, `check_gs` +2 (+3 −1), and `check_gv` +10 (§0
  +8, §1 +2; §2c, §2e and §3 changed message for message and not in number). **`check_gp`'s +9 took a stub arm**: HP's
  tree with the three new entries retired and Fellowship's retirement taken off read 465, **message for message HEAD's,
  in order** — so nothing else HP changed moved its road, the live door and the sim's counter included.
- **The stub arm answered the brief's question about `check_he` §1 and `check_hf` §3** too: on it both read HO's
  acceptance line for line. Their figures moved for the crest's four runes in every offer; neither reads the sim's
  counter (§9).

**The gates that walk gate files or read the documents**, run on the finished tree: `check_parse` 205, `check_da` 41,
`check_ec` 24, `check_ed` 18, `check_ek` 47, `check_ff` 68, `check_fg` 22, `check_fr` 25, `check_gw` 76 (its shape
sweep 96 against a ceiling of 96 — `check_hp` hand-sets nothing), `check_di` 44, `check_hi` 11, `check_dr` 84,
`check_es` 57, `check_et` 27, `check_em` 470, all 0 failures and no throw. The pin manifest holds 1,644 pins (48 of
them `check_hp`'s); its unresolved set is HEAD's, unchanged.

**THE LITERAL SWEEP.** Every string literal of the 135 root scripts — 16,745 needles, floor four characters — looked
for in HEAD's copy and HP's of each of the 30 edited files: **43 lost, 281 gained.** Each lost needle was read at its
reader. Sixteen are `check_hp`'s own absence anchors, lost from the scripts it holds them absent in (the Faith
phrases, the dead re-roll, the sim's old door). The rest are needles no reader of that file holds: `check_ho`'s route
and name needles lost from `CLAUDE.md`, `docs/master.html` and `docs/state.md`, which it never opens; dictionary keys and runtime reads (`break`, `guard`,
`tick`, `falls`, *does not switch*) that happen to have stood in the lost text; and names in `docs/state.md`, which only
`check_es` and `check_hp` open, for needles they hold elsewhere.

### §8c — THE CONTROLS

**Thirty-eight, one defect each, in a clone of the finished tree, read by FAIL text** — twenty-three that break what
the new gate alone asks, and fifteen that break a re-pointed gate (eight with HEAD's copy of it run beside it on the
same defect). **Every one reds with the line it names.** Two were rebuilt before they were trusted, and a re-pointed gate was split:
- **H07 broke the file, not the rule**: its inserted writer landed at the wrong indent inside a two-line call, and
  `battle.gd` did not parse — `check_hp` read 108 / 17 with twenty-one throws, its own line among them. Rebuilt at the
  block's indent, it reds on §1b alone.
- **H03's first shape re-applied the delta** between the last write and the recompute, which comes back exact on
  §1d's 0.10 + 0.25 and drifts only on §2c's 0.10 + 0.50: §1d stayed green. Rebuilt to add a payload's figure on and
  take it off — the defect the brief names — §1d reds (0.1 + 0.25 − 0.25 is 0.09999999999999998), and §2c with it.
- **`check_fd` §2 sorted a key into one list only**: H17 (a tag key beside a `heroes_…` key) red the tag arm and the
  positive arm together. Each key is sorted once now, so each of H17 and H18 names its own defect alone.

| | defect | reds |
|---|---|---|
| H01–H13 | the live door: no re-read at a death or a revive; the reversal subtracts; the opening read before the lay-down; the spawn stamps a live payload; a consumed field made live; a live field written mid-fight; `heroes_hold_core` made live; no switch line; no roll-call tail; the table does not refuse; a nested live condition accepted; the sheet hands `LIVE_DOOR` | `check_hp` §1a–§1g |
| H14–H15, H19–H27 | Empty Pulpit on a present class; Dirge's words and figure apart; Fellowship un-retired; its read site deleted; Tithe's old words; `CLAUDE.md` without FN's reconciliation; the summary without the crest, or the core runes; the sim's counter on `generate_rune`; a Faith comment at five; the dead re-roll back | `check_hp` §2–§6 (H14 `check_ho` §2d too) |
| H16 | Dead Air authored at the bare figure | `check_fn` §1b |
| H17, H18 | a retired tag key; a node key | `check_ez` §4, `check_fn` §1b, `check_fd` §2; `check_fx` §5, `check_fd` §2 |
| H28 | the live door never opens | `check_hl` §6, `check_hn` §3, `check_ho` §2c |
| H29 | a crest payload stops landing on a party it holds for | `check_ez` §4 |
| H30–H32 | Dirge retired; Dirge tagged DEFENSE; Fellowship's entry deleted | `check_fk` §1, `check_fo` §2c, `check_gx` §1, `check_ho` §1a; `check_fe` §1; `check_es` §1, `check_hp` §3 |
| H33–H36 | Dirge's words without *while*; Dead Air named *Cold Hearth*; a script string spelling *Dirge*; Fellowship's payload on the node's counter | `check_ho` §2d, §5e, §5a (and `check_hp` §2e, §3) |
| H37, H38 | a fifth crest rune sorted nowhere; `check_hp`'s table without Dirge | `check_gv` §0, §1 |

**The reversed arm of every re-point is the recon**: HEAD's copy red on the clean tree, the re-pointed one green.

### §8d — THE PRE-PASS

The finished tree in an isolated copy seeded from the backup, proved by hash (498 files, `project.godot` aside), the
prediction written three minutes before the launch. **131 targets in 75 min 12 s; `check_de` 541 / 1 / 0 notices.**
Every target read its predicted row — `check_hp` 145, `check_parse` 205, the thirteen re-pointed and the six that rose,
`check_hk` 142 with the copy seeded, the two sanctioned reds at their counts — **but one, which the prediction did not
see**: `test_batch_bx` §4b, *no player-facing string still reads 'party'*, on five strings in `scripts/talents.gd`.
They were the refusal's reasons for HN's stamps (*a party-wide stamp: …*), written into `Talents.CONSUMED_FIELDS` after
the recon's copy was taken, so the recon never read them, and a string in a game script is player-facing to that sweep
whoever it is shown to. They read *a stamp across the four: …* now; `check_hp` §1c reads each reason off the constant,
so it moved with them. No Parse Error and no SCRIPT ERROR in any log.

**THE SECOND PASS.** Three files moved after the pre-pass's copy: `scripts/talents.gd` (the five strings),
`docs/state.md` (one pointer sentence) and this report. The literal sweep against the copy the pre-pass read lost and
gained nothing in either tracked file, and the pin manifest did not change. Every root script that opens
`scripts/talents.gd` and both that open `docs/state.md` — twenty-nine battery targets — ran in a second copy proved
by hash, the prediction written before the launch: **every one at its row, `test_batch_bx` 159 / 0,
in 15 min 8 s**, no Parse Error and no SCRIPT ERROR. Two report scripts that open `scripts/talents.gd` and are not
battery targets (`check_cu`, `check_cv`) printed on HP's tree what they print on HEAD's, line for line.

### §8e — THE ACCEPTANCE RUN

In the repository, the tree frozen — every file hashed by absolute path before the launch (499, `project.godot`
included) — and the player's four files hashed, the prediction written sixteen minutes before. **131 targets in
74 min 56 s; `check_de` 541 / 0 / 0 notices. Every target read its row**, and its pre-pass value but `test_batch_bx`
(159 / 0, the repair) and `test_batch_an`'s seeded count (6054 against 6052, inside its band): `check_hp` 145,
`check_parse` 205, `check_ho` 176, `check_gv` 1057, `check_gp` 474, `check_hk` 142, the two sanctioned reds at their
counts (`check_cm_live` 13 / 4, `check_gj` 70 / 1, card +175 against a purse of +195), the run harness's three gates
PASS (22 / 382 / 8). **No Parse Error, no SCRIPT ERROR, no TIMED OUT and no NO VERDICT line in any of the 131 logs.**
`check_gp` ran 229 s against its 480, `check_gv` 617 s against its 1200 and `check_fx` 364 s against its 720.

**The tree was byte-identical after the run, 499 of 499 files, and the player's four files are byte-identical — hash,
size and mtime — and equal to the 19:39 backup.** What the run wrote in the player's folder was the gates' own scratch
files, `hp_profile.json` and `hp_relics.json` among them, beside the four.

**AFTER THE RUN**, `docs/state.md`'s verification line and HP's own copies were written, the changelog gained one
sentence on the pre-pass, and this report was finished. **Swept against the copy the run read** (the second pass's,
proved equal to the tree), `docs/state.md` and `docs/changelog.html` lost no needle and gained one, `scripts/talents.gd`,
which its four readers open as a path and none looks for in `docs/state.md`. The two gates that open `docs/state.md`
were re-run on the final tree: `check_es` 57 / 0 and `check_hp` 145 / 0.

## §9 — FOUND AND NOT FIXED

- **TITHE'S READ SITE OWES A TALENT REBALANCE** (§4): it is *Breaking Heals a Hero*'s site too, tuned against the narrow
  read. HO's figures stand in `docs/state.md`.
- **THE BOT ALL BUT NEVER REVIVES** (0 to 0.05 a normal fight, §2a), so a live rune measured in a sim switches off at a
  fight's end rather than at a revive, and Empty Pulpit's and Dead Air's sim worth is a floor.
- **DEAD AIR NEAR-MISSES *DEADFALL*** (§2f); it ships as a named near-miss.
- **A LIVE CREST RUNE HAS NO SHAPE WORD FOR ITS GATE**: the three are `STAT` in `Runes.RUNE_SHAPES`, whose secondaries
  are the two retired tag conditions and TRADEOFF. Read by instruments alone.
- **`check_he` §1's AND `check_hf` §3's "PEDDLER" COLUMN IS NOT THE PEDDLER'S DOOR**: both tally `Run.generate_rune`,
  which the Peddler left at HL §1 for `Run.peddler_rune` (the same roll, less every core rune). The gating each asserts
  holds through either door; the printed figures are not the counter's. Re-pointing moves both gates' tallies.
- **`check_hk`'s COUNT IS THE COPY'S**: 142 where the player's three files exist, 139 where they do not — §8 asks each
  file that existed whether it was rewritten. An isolated run is seeded from the backup to match the battery.
- **`test_batch_ak`'s WHOLE-POOL WALK ASKS NOTHING OF THE THREE LIVE RUNES** (HO's census named the shape as latent). It
  applies every payload under a party-less ctx and counts it *touched*, with no assertion inside the loop; a hero key
  with no party reads false (HL §6's safe direction), so each of the three applies nothing there and is counted anyway.
  `check_ez` §4 lands each on a party for which it holds, and `check_hp` §2 drives each through a real fight; the walk
  is not re-pointed.

**On the machine.**
- **461 OLDER ISOLATED USER-DATA FOLDERS REMAIN** — outside the policy; the designer's.
- **THIS BATCH'S OWN: TWENTY-EIGHT *"Dawn of Decay HP …"* FOLDERS, 17,248 KiB** — `work`, `work2`, `head`, `recon`,
  `prepass`, `second`, `m1`, `ctl1`–`ctl4`, `trace head`, `trace new`, `trace stub`, and the fourteen measurement lanes
  (`lane A_…`, `lane A2_…`, `lane B_…`, `lane B2_…`). They stay one batch, and HQ clears them by that prefix. Godot's
  `app_userdata` holds 490 folders, 159,772 KiB, the live *Dawn of Decay* among them.

## §10 — WHAT MOVED

- **The game**: `scripts/talents.gd` (the live keys, the two field lists, the refusal, `apply_payload`'s two doors),
  `scripts/battle.gd` (the live door, the run summary, Faith's comments), `scripts/unit.gd` (`revived_cb`, two Faith
  comments), `scripts/runes.gd` (the table refuses as it loads; the three rows in both tables), `scripts/classes.gd`
  (one Faith comment), `scripts/run_sim.gd` and `scripts/shop_screen.gd` (the counter's door, the dead re-roll).
- **The data**: `data/runes.json` (Empty Pulpit, Dead Air and Dirge; Fellowship retired; Tithe's words),
  `data/glossary.json` (the crest's live runes).
- **The instruments**: `check_hp.gd` (**new**) and `run_battery.sh`; thirteen gates re-pointed to their intents —
  `check_es`, `check_ez`, `check_fd`, `check_fe`, `check_fk`, `check_fn`, `check_fo`, `check_fx`, `check_gv`, `check_gx`,
  `check_hl`, `check_hn`, `check_ho` — and `check_ek`'s list; `pin-manifest.json`; `baselines.json`.
- **The documents**: `CLAUDE.md`, `docs/instrument-rules.md`, `docs/master.html` and its stamp, `docs/state.md`,
  `docs/changelog.html`, `docs/design-notes.md`, and this report (**new**).
