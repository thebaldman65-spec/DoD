# Batch GU — The last three cards under the baseline, and the sweep for the shape

*Branch `class-merge`, from `b451b35` (GT). `main` is untouched. **IMPLEMENT ONLY.** GT priced Fireball, Frostbolt and
Aimed Shot at the kit card beside them and named three more cards with the same shape it did not retune. GU prices
those three against what they are for, sweeps every card a hero can earn for the shape, and retunes the one genuine
mispricing the sweep finds. No engine, kit, pool, node or rune changed; one card's cooldown moved.*

## NEEDS A RULING

**All three are player-visible.** Everything else is in `docs/state.md`'s queue.

1. **WHAT "THE BASELINE" IS FOR A FORMER BASIC — AND THE FOUR NOW SIT AT TWO** (§1a). Fireball and Frostbolt are at
   Magic Missiles' 15 Mana and cooldown 2 (GT, ruled). Arcane Explosion and Shadowrend are still at the price of the
   class basic each replaced — free, no cooldown, initiative 2.0 — because the brief grouped them and asked for no
   ruling. Two readings fit: a former basic's baseline is the basic it replaced (then all four are free), or it is the
   nearest card of its role (then the two with no kit card of their role would take the pool's **Arcane Barrage**, 20
   Mana and cooldown 2 at 2.5 — or **Killing Frost**, 20 and cooldown 3 at Arcane Explosion's own 2.0 — and
   **Chastise**, 15 and cooldown 2 at 2.0). Nothing moved.
2. **GUARD CHANGE: NONE OF ITS THREE AXES MOVED** (§1b). The brief asked whether all three move or one is what the
   card is for. Against Crushing Blow and Pommel Strike it is under on all three; **against Mocking Blow — the kit
   card nearest its price — only its initiative is under**, and that is the swap's point (AK priced it "a bargain"
   on purpose). At a strike's price it would take Crushing Blow's 20 / 2 / 3.0 or Pommel Strike's 20 / 3 / 2.0, and a
   longer cooldown would also slow Battle Poise's free pivot, which respects it.
3. **SWEEPING STRIKES IS THE ONE MAGNITUDE GU MOVED** (§2b): cooldown 0 → 2, Crushing Blow's, on the batch's judgment
   that it is a genuine mispricing — the brief delegated the grouping. It is the only card of the eleven that does a
   kit card's job with nothing paying for its lower price. The other ten's groups are the batch's reading and are
   ruled on by nobody, per the brief.

## THE SHORT VERSION

- **Arcane Explosion and Shadowrend are former basic attacks** (§1a) — each at the price of the basic it replaced in
  slot 0, with no card of its role in its class kit. **Guard Change is not** — it opened the Swordmaster's kit from AK
  to GS — and against the kit card nearest its price it is under on initiative alone (§1b). **None moved.**
- **The sweep asked all 204 cards a hero can earn** against his class kit, in the same field role, with EB's
  initiative control dropped (§2). **Eleven sat under a kit card on HEAD**: two former basics, five whose advantage is
  what they are for, three the field role pairs with Snare Trap only through its catch-all — and **one genuine
  mispricing, Sweeping Strikes, which now has Crushing Blow's cooldown of 2**.
- **`check_eb` was not asking about the merged pools** (§3a). It paired each lineage's shelf with that lineage's cores
  — 158 cards — so the 20 class-wide cards and all 26 boss picks were in no pair, and **it could not see Sweeping
  Strikes inverting against the Berserker's Bloodlust**. It and `check_ea` §4 now pair every card a hero of the class
  can earn with every protected card of the class: **29 of 43 pairs favour the core, 0 crossovers** (21 of 30 before).
- **`check_gu` casts every card priced at a kit card in a real fight** beside that kit card (§3b) — GT's three and
  GU's one. GT's gate had checked its three prices as data only.
- **Battle Poise and Shatterpoint stay as they are** (ruled in the brief; recorded in `CLAUDE.md`).
- **Verification:** the acceptance battery is **GREEN — 118 targets in 57 minutes on a frozen tree, `check_de` at 489 / 0 /
  0**, `check_gu` at 317 / 0; the only reds are the two standing sanctioned ones, their FAIL lines byte-identical to
  GT's. **The unmodified battery ran against GU's code first**: 116 of 117 targets read as at GT, and none moved for the
  cooldown — the only instrument that reads it is the one GU wrote.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md` whole, `docs/state.md`'s WHERE block and queue, `docs/reports/GT.md`, and
the code the brief names — the three cards and the class kits in `classes.gd`, `check_eb`, `check_ea` §4, `check_gt`,
the cast line in `battle._resolve`, and DU §5's boss-pool audit.

| The brief says | Verdict | What the repo says |
|---|---|---|
| GT retuned three cards cheaper and faster than the kit card beside them | Held | GT §2: cheaper and shorter at the same initiative. |
| GT found three more and did not retune them because the ruling named three | Held | GT §2c: "Not retuned; the ruling named three." |
| the principle is EB's — 17 comparable pairs, 13 favouring the core | Held | EA §3's measurement; EB §1's ruling. |
| GT found a hero can own six engine runes, Close off-screen for all 60 pairs, 17 engine-locked cards | Held | GT §0, §1b, §3a. |
| **Arcane Explosion and "Shadowrun"** | **Name** | Shadowrend. |
| they are cheaper and faster in a different role — **GT said so and did not retune them for that reason** | **Half held** | GT said they are in another role; it did not retune them because the ruling named three (GT §2c), not because of the role. |
| **Guard Change: three ways under, where the others are two** | **Held against two of the three kit cards** | Under Crushing Blow and Pommel Strike on cost, cooldown and initiative; **under Mocking Blow (0 Rage, cooldown 1, 2.0) on initiative alone** — GT's table did not list Mocking Blow. |
| check whether any of the three is a former basic attack | Done | **Arcane Explosion and Shadowrend are** (`basic_override_ability`); **Guard Change is not** — a former protected core (§1). |
| Fireball and Frostbolt were free by design until GS moved them into the pool | Held | GS §1; GT §2b. |
| **GT found three by reading and three more while doing so; neither was a sweep** | **Not held** | GS's three were found by `check_eb` §1's sweep of every shelf card under EB's control; GT's three more by GT §2c's sweep of the 29 returning cards. **What no sweep covered was all 204** — which §2 does. |
| GT's method found 17 engine-locked cards by asking about all 204 | Held | GT §3a. |
| `check_eb` reads 21 of 30 pairs favouring the core, 0 crossovers | Held | Re-run on HEAD: 21 of 30, 0 crossovers, 16 / 0. |
| **confirm it is asking about the merged pools** | **It was not** | It walked `spec_draft_pool` — the 12 lineage shelves, 158 cards — pairing each only with its own lineage's cores. Repaired (§3a). |
| Battle Poise and Shatterpoint stay as they are, ruled | Recorded | `CLAUDE.md`'s sits-out block. |
| the four engine texts and the sim bot's reach stay queued | Held | Untouched. |
| **GT drove its three** in a real fight | **Not held** | `check_gt` §4 compares the three cards' data with the kit cards'. Suites cast them by name (Fireball for its Burn, among others), and none reads the price the cast line took or the cooldown it started. `check_gu` §4 does, all four. |
| `check_eb` names the underpriced cards by hand and will need repointing | Held in substance | It names the retuned three (`RETUNED`) and EB's dissolved crossover; the repointing it needed was its population. |
| back up the saves | **Four exist now** | A run is in progress (`run_save.bin`, written after GT) and `profile.json` changed since GT's backup (§5a). |

## §1 — THE THREE

### §1a — Arcane Explosion and Shadowrend are former basic attacks

Until GS a lineage replaced its class basic in slot 0 while its engine was held (`apply_kit_overrides`, deleted at GS):
the Arcanist's Magic Bolt became Arcane Explosion and the Occultist's Smite became Shadowrend. GS put both in the draft
pool exactly as they stood, so **each still costs what the basic it replaced costs**:

| Card | Price (cost / cooldown / initiative) | The basic it replaced | Its role | A kit card of its role? | Nearest card of its role in the pool |
|---|---|---|---|---|---|
| Arcane Explosion — 2 random hits × 10%, 10 BD | 0 / 0 / 2.0 | **Magic Bolt**, 0 / 0 / 2.0 | area damage | **none** — the Mage kit is Magic Burst, Nexus Ward, Magic Missiles | **Arcane Barrage** (the Arcanist's own random-hit card): 20 / 2 / 2.5; at its own initiative, **Killing Frost**: 20 / 3 / 2.0 |
| Shadowrend — 25%, 16 BD, Cripple 2 turns | 0 / 0 / 2.0 | **Smite**, 0 / 0 / 2.0 | damage | **none** — the Cleric kit has no damage card, by ruling (GN) | **Chastise** — 25%, 20 BD at 2.0: 15 / 2 / 2.0 |

**GT's pairings were across roles**: Arcane Explosion against Magic Missiles (an area attack against a single-target
one — though both carry OFFENSE as their primary tag) and Shadowrend against Ministration (a strike against a heal).
Against the protected cards of their own role both sit under an ENABLER, not a kit card: Arcane Explosion under the
Pyromancer's Flamewave (25 / 2 / 3.0) and Shadowrend under the Occultist's Hex of Ruin (20 / 2 / 2.5), on all three
axes — but an enabler is only its engine's holder's.

**This changes what "the baseline" means for them**, which is what the brief anticipated. Priced against the basic they
replaced, both are exactly at the baseline. Priced against the nearest card of their role, both would move by as much
as Fireball and Frostbolt did. **Not retuned: a former basic is the brief's first group, reported and not ruled.**
NEEDS A RULING 1.

### §1b — Guard Change is not a former basic, and its initiative is what it is for

Guard Change opened the Swordmaster's kit from AK (*"not a free action on purpose … the swap does double duty (stance,
pressure, refuel) at a bargain 1.5 initiative. The 1cd stops spam"*) until GS §1 put every stance swap in the draft.
It was priced as a protected core — the baseline itself — and not as a basic. Its three axes against each kit card:

| Against | Kit card | Cost | Cooldown | Initiative | Under on |
|---|---|---|---|---|---|
| Crushing Blow | 20 Rage, cd 2, 3.0 — 43%, 20 BD, Sunder | 0 vs 20 | 1 vs 2 | 1.5 vs 3.0 | **all three** |
| Pommel Strike | 20 Rage, cd 3, 2.0 — 25%, 30 BD, Stun | 0 vs 20 | 1 vs 3 | 1.5 vs 2.0 | **all three** |
| **Mocking Blow** | **0 Rage, cd 1, 2.0** — 27%, 15 BD, taunt | 0 vs 0 | 1 vs 1 | 1.5 vs 2.0 | **initiative alone** |

**The field role calls it a damage card only because its 15 Break damage is on the bar criterion's list**; it deals
no damage, and its primary tag (OFFENSE, with DEFENSE) is not the kit strikes' (DEBUFF, with BREAK). The cards that do
its job are the pool's other swaps — Precision Strike (20 / 3 / 2.0), Feint (25 / 4 / 2.0), Wheeling Cut (30 / 4 / 2.5)
— which read the stance, branch on it and do more; Guard Change is the one unconditional swap. **So: of the three, the
initiative is what the card is for, and against the kit card nearest its price the other two are not under at all.
None moved.** A longer cooldown would also reach two other cards: Battle Poise's free pivot asks the usability door
about the real Guard Change and respects its cooldown (BW §3), and Battle Poise and Counter Time open with no engine
only through a drafted Guard Change (GT §3). NEEDS A RULING 2.

## §2 — THE SWEEP

### §2a — The method

**Every card a hero can earn** — the class draft pool and every lineage's zone-boss pool, GT §3's population: **204**
— against **the class kit** every hero of the class holds, **in the same role** (the role `check_ea` §4 and `check_eb`
§1 derive from the fields), with **EB's initiative control dropped**, and a pair left out where either side's
initiative is the buff cap (EB's rule: a clamped initiative is not a price anyone chose). **The shape is: under the kit
card on at least one of cost, cooldown and initiative, and dearer on none** — the brief's "cheaper, faster or
lower-initiative" read as undercutting. A card under on one axis and dearer on another is EB's trade, which EB §1
ruled the intended relationship; those are listed in §2d rather than grouped.

### §2b — Eleven cards under a kit card on HEAD, and their groups

| Card | Price | Under | Group | Why |
|---|---|---|---|---|
| Fireball | 15 / 2 / 2.0 | Magic Burst (25 / 2 / 3.0) | **former basic** | the Pyromancer's basic until GS; at Magic Missiles' price since GT |
| Frostbolt | 15 / 2 / 2.0 | Magic Burst | **former basic** | the Cryomancer's basic until GS; at Magic Missiles' price since GT |
| Guard Change | 0 / 1 / 1.5 | Crushing Blow, Pommel Strike, Mocking Blow | **its point** | the stance swap, priced a bargain on purpose (§1b) |
| Charge | 20 / 3 / 1.0 | Pommel Strike (20 / 3 / 2.0), initiative alone | **its point** | *"Nothing else in the kit arrives this fast"* — the quickest card a Warrior holds, and its numbers were the designer's call (its own comment) |
| Kindled Mind | 15 / 2 / 1.5 | Magic Burst; Magic Missiles (15 / 2 / 2.0), initiative alone | **its point** | *"buying the ramp with tempo"*: 15% a cast against Magic Missiles' 36% and Magic Burst's 40% |
| Primal Surge | 20 / 2 / 3.0 | Powershot (25 / 2 / 3.0), cost alone | **its point** | spends all Loyalty, and sits out without Pack Bond — paid in another currency |
| Bola | 15 / 3 / 1.5 | Snare Trap (20 / 3 / 2.0) | **its point** | a class-wide card whose payload is authored to keep it *"under the Survivalist's own appliers"* — two soft afflictions, no damage, no Break; the class-wide rebalance is GP's ruling 1 |
| Quarry's Mark | 15 / 3 / 1.5 | Snare Trap | **the field role's catch-all** | a MARK that pays Focus; neither card damages, heals, shields or lays a declared status, so the field role puts a mark and a trap in one bucket |
| Hold Breath | 15 / 3 / 1.5 | Snare Trap | **the field role's catch-all** | a RESOURCE card on the Sharpshooter himself |
| Mark of the Hunt | 15 / 3 / 2.0 | Snare Trap, cost alone | **the field role's catch-all** | a MARK for the Beastmaster and his companion |
| **Sweeping Strikes** | 20 / **0** / 3.0 | **Crushing Blow (20 / 2 / 3.0)**, cooldown alone | **genuine mispricing** | a Warrior strike doing a kit card's job, and nothing pays for its missing cooldown — below |

**Sweeping Strikes is the one.** It opened the Swordmaster's kit at Batch 10, the batch that introduced cooldowns, with
none; AH trimmed it into his zone-boss pool, where it has been an earned card since. Since GN put Crushing Blow in
every Warrior's kit it sat beside that card in the same role, at the same cost and initiative, with no cooldown
against its 2 — and **against the Berserker's Bloodlust (25 / 2 / 3.0) it was cheaper AND shorter at the same
initiative, EB's own inversion**, in a pool `check_eb` did not read. Nothing prices it elsewhere: no second currency,
no condition, and no limit of its own — **DU §5 recorded that it keeps a 3-turn Daze permanently refreshed at a net 10
Rage a cast**, "Lunge's profile", which DR gave a cooldown; nobody had ruled on it. **It takes Crushing Blow's
cooldown of 2, GT's method; cost 20 and initiative 3.0 were already Crushing Blow's.** Nothing else of it moved
(`check_gu` §3). Against Bloodlust it is now cheaper on cost and level on cooldown, a one-axis difference EB allows.

**Its consequences, measured rather than assumed:** the Quickened upgrade (two turns off a cooldown) now fits it, as it
fits Crushing Blow, so an upgraded copy is back at 0 — parity with the kit card holds; and the sim bot's Swordmaster
rotation, which casts it whenever it is ready at three foes or more, casts it at most one turn in three. Sims only.

### §2c — After GU

**Ten** rows under a kit card, `check_gu` §2's named table; Sweeping Strikes ties Crushing Blow and is under nothing.
Each group's ground is asked of the game rather than taken from the row: a former basic is one of the four
`basic_override_ability` defines (and Guard Change is not); a catch-all row's primary tag differs from the kit card's;
and each "its point" row's cited fact — Guard Change is the swap, Charge the quickest card a Warrior holds, Kindled
Mind under half the kit cards' damage, Primal Surge sitting out without Pack Bond, Bola a class-wide card with no
damage and no Break.

### §2d — What the "or" reading adds, listed rather than grouped

**Against the enablers rather than the kit**: 19 cards (27 pairs) — Hack and Slash, Overpower, Guard Change and Sweeping
Strikes under the Berserker's Bloodlust; Stoke, Fireball, Wildfire, Cold Iron, Frostbolt, Kindled Mind and Reality
Fracture under the Cryomancer's Razor Ice; Arcane Explosion and Arcane Barrage under the Pyromancer's Flamewave;
Shadowrend and Chastise under the Occultist's Hex of Ruin; Quarry's Mark, Hold Breath, Bola and Mark of the Hunt under
each of the Beastmaster's three summons. **Only Arcane Explosion and Shadowrend are under an enabler on all three
axes**; an enabler is only its engine's holder's, so none is in the population the brief named.

### §2d-i — THE TRADES: under a kit card on one axis, dearer on another (47 pairs, 44 cards)

| Card (cost / cooldown / initiative) | Class | Against | Under on | Dearer on |
|---|---|---|---|---|
| Aimed Volley (20 / 3 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | cost, initiative | cooldown |
| Arcane Bolt (30 / 4 / 2.5) | mage | Magic Burst (25 / 2 / 3.0) | initiative | cost, cooldown |
| Arcane Echo (25 / 4 / 2.0) | mage | Magic Burst (25 / 2 / 3.0) | initiative | cooldown |
| Blessing of Zeal (20 / 2 / 2.0) | cleric | Unburden (20 / 4 / 1.5) | cooldown | initiative |
| Blood Debt (20 / 4 / 2.0) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cooldown |
| Boil Over (40 / 5 / 2.5) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Bulwark of Fortitude (30 / 3 / 3.0) | cleric | Unburden (20 / 4 / 1.5) | cooldown | cost, initiative |
| Calibrating Shot (20 / 3 / 1.5) | hunter | Powershot (25 / 2 / 3.0) | cost, initiative | cooldown |
| Call the Wilds (20 / 5 / 2.0) | hunter | Powershot (25 / 2 / 3.0) | cost, initiative | cooldown |
| Charge (20 / 3 / 1.0) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cooldown |
| Charge (20 / 3 / 1.0) | warrior | Mocking Blow (0 / 1 / 2.0) | initiative | cost, cooldown |
| Cleave (25 / 3 / 2.5) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Cold Iron (20 / 3 / 2.0) | mage | Magic Burst (25 / 2 / 3.0) | cost, initiative | cooldown |
| Crossfire (25 / 4 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Divine Plea (0 / 2 / 3.0) | cleric | Ministration (20 / 2 / 2.0) | cost | initiative |
| Execute (30 / 3 / 2.0) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Feint (25 / 4 / 2.0) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Gut Rip (30 / 4 / 2.5) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Hack and Slash (20 / 2 / 3.0) | warrior | Pommel Strike (20 / 3 / 2.0) | cooldown | initiative |
| Hamstring (25 / 3 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Heads Down (25 / 4 / 2.0) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Heal (20 / 1 / 3.0) | cleric | Ministration (20 / 2 / 2.0) | cooldown | initiative |
| Hunt (25 / 4 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Hunter's Mark (15 / 4 / 1.5) | hunter | Snare Trap (20 / 3 / 2.0) | cost, initiative | cooldown |
| Hymn of Hope (0 / 2 / 3.5) | cleric | Ministration (20 / 2 / 2.0) | cost | initiative |
| Loaded Shot (20 / 4 / 2.0) | hunter | Powershot (25 / 2 / 3.0) | cost, initiative | cooldown |
| Overpower (25 / 1 / 2.5) | warrior | Crushing Blow (20 / 2 / 3.0) | cooldown, initiative | cost |
| Overpower (25 / 1 / 2.5) | warrior | Pommel Strike (20 / 3 / 2.0) | cooldown | cost, initiative |
| Pinning Shot (20 / 3 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | cost, initiative | cooldown |
| Precision Strike (20 / 3 / 2.0) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cooldown |
| Pyre Wake (25 / 4 / 2.5) | mage | Magic Burst (25 / 2 / 3.0) | initiative | cooldown |
| Pyroblast (45 / 0 / 6.0) | mage | Magic Burst (25 / 2 / 3.0) | cooldown | cost, initiative |
| Pyroblast (45 / 0 / 6.0) | mage | Magic Missiles (15 / 2 / 2.0) | cooldown | cost, initiative |
| Reacquire (20 / 4 / 1.5) | hunter | Snare Trap (20 / 3 / 2.0) | initiative | cooldown |
| Reality Fracture (20 / 3 / 2.0) | mage | Magic Burst (25 / 2 / 3.0) | cost, initiative | cooldown |
| Resurrection (0 / 3 / 4.0) | cleric | Unburden (20 / 4 / 1.5) | cost, cooldown | initiative |
| Savage Sweep (25 / 4 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Sever (25 / 4 / 2.5) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Shield Slam (25 / 3 / 2.5) | warrior | Crushing Blow (20 / 2 / 3.0) | initiative | cost, cooldown |
| Stoke (20 / 3 / 2.0) | mage | Magic Burst (25 / 2 / 3.0) | cost, initiative | cooldown |
| Sweeping Strikes (20 / 2 / 3.0) | warrior | Pommel Strike (20 / 3 / 2.0) | cooldown | initiative |
| Transference (20 / 3 / 2.0) | cleric | Unburden (20 / 4 / 1.5) | cooldown | initiative |
| Trophy Shot (25 / 4 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Twin Hunt (25 / 3 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Unleash (25 / 4 / 2.5) | hunter | Powershot (25 / 2 / 3.0) | initiative | cooldown |
| Wildfire (20 / 3 / 2.5) | mage | Magic Burst (25 / 2 / 3.0) | cost, initiative | cooldown |
| Winter's Toll (25 / 4 / 2.5) | mage | Magic Burst (25 / 2 / 3.0) | initiative | cooldown |

### §2d-ii — SET ASIDE BY EB's CAP RULE: under on cost or cooldown where one side's initiative is the buff cap (34 pairs, 31 cards)

| Card (cost / cooldown / initiative) | Class | Against | Under on |
|---|---|---|---|
| Aegis Reversal (30 / 4 / 2.5) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Alms (20 / 4 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Bestial Wrath (25 / 3 / 3.5) | hunter | Tripwire (20 / 4 / 1.0) | cooldown |
| Bewitch (25 / 4 / 3.5) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Blessing of Zeal (20 / 2 / 2.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Blight the Well (25 / 4 / 2.5) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Bola (15 / 3 / 1.5) | hunter | Tripwire (20 / 4 / 1.0) | cost, cooldown |
| Bulwark of Fortitude (30 / 3 / 3.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Consecrated Ground (25 / 3 / 1.0) | cleric | Unburden (20 / 4 / 1.5) | cooldown |
| Consecrated Ground (25 / 3 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Covenant of Ash (20 / 4 / 2.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Divine Presence (20 / 4 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Divine Wrath (25 / 4 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Exhortation (25 / 4 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Hold Breath (15 / 3 / 1.5) | hunter | Tripwire (20 / 4 / 1.0) | cost, cooldown |
| Hunter's Instinct (20 / 3 / 1.0) | hunter | Tripwire (20 / 4 / 1.0) | cooldown |
| Hunter's Mark (15 / 4 / 1.5) | hunter | Tripwire (20 / 4 / 1.0) | cost |
| Intercession (25 / 4 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Mark of the Hunt (15 / 3 / 2.0) | hunter | Tripwire (20 / 4 / 1.0) | cost, cooldown |
| Mass Hysteria (30 / 4 / 4.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Mirror Image (20 / 4 / 1.0) | mage | Nexus Ward (25 / 4 / 1.0) | cost |
| Ordination (25 / 4 / 2.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Penance (25 / 4 / 2.5) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Quarry's Mark (15 / 3 / 1.5) | hunter | Tripwire (20 / 4 / 1.0) | cost, cooldown |
| Quick Draw (15 / 5 / 1.0) | hunter | Snare Trap (20 / 3 / 2.0) | cost |
| Quick Draw (15 / 5 / 1.0) | hunter | Tripwire (20 / 4 / 1.0) | cost |
| Recant (25 / 4 / 2.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Resurrection (0 / 3 / 4.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Shared Grief (20 / 4 / 2.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Transference (20 / 3 / 2.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Umbral Sigil (20 / 4 / 3.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |
| Undying Vigil (25 / 4 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cooldown |
| Vow of Suffering (20 / 3 / 1.0) | cleric | Unburden (20 / 4 / 1.5) | cooldown |
| Vow of Suffering (20 / 3 / 1.0) | cleric | Consecration (25 / 5 / 1.0) | cost, cooldown |

## §3 — THE INSTRUMENTS

### §3a — `check_eb` and `check_ea` §4, repaired to intent

**Both walked the pre-GP population.** `check_eb` §1 and `check_ea` §4 read each lineage's shelf (`spec_draft_pool`)
and paired it with that lineage's protected names alone. Since GP a hero draws from his whole class pool, so **the 20
class-wide cards were in no pair, a lineage's card never met another lineage's enabler, and no boss pool was read** —
while a boss pick fills a slot under the same cap as a drafted card (EG). The class basic sat outside both only because
the pool resolver cannot see it.

**Both now walk every card a hero of the class can earn** (the merged pool and every boss pool, 204) against **every
protected card of the class** (the kit and every engine's enablers, 20), paired by class, **the basic left out on
purpose** — nothing is cheaper than a free card, so a pair against it could only swell the favouring count. Two
pairings that disagree make the two gates' numbers incomparable, so they move together.

| Reading | HEAD | GU |
|---|---|---|
| protected cards / earnable cards walked | 44 rows (per lineage) / 158 | 20 / 204 |
| comparable pairs (same class, role and initiative, cap excluded) | 30 | 43 |
| pairs favouring the core | 21 | 29 |
| core cheaper / dearer on resource | 17 / 1 | 22 / 5 |
| core shorter / longer on cooldown | 20 / 0 | 28 / 0 |
| under the buff cap: cores / earnable | 10 of 44 (22.7%) / 41 of 158 (25.9%) | 4 of 20 (20.0%) / 57 of 204 (27.9%) |
| crossovers | 0 | 0 — and on HEAD's Sweeping Strikes, 1 (against Bloodlust) |

`check_ea` §4's three direction assertions hold on the new population. **`check_eb` 16 → 21**: +4 for a per-class
assertion that the walk holds every class-wide card and every boss pick, +1 for Sweeping Strikes in `RETUNED`.
`check_ea` stays 83. **`_role_of` is static in `check_eb` now**, so `check_gu` asks that one rather than carrying a third
copy (DA §3's tell).

### §3b — `check_gu`

**317 checks.** §0 and §5 the player's files, byte for byte; §1 the three, none moved, with each's ground asked of the
game; §2 the sweep's named table in both directions, each group's ground, the four former basics derived and Sweeping
Strikes under nothing; §3 the retune and everything of Sweeping Strikes that did not move; §4 **the four cards priced
at a kit card — Fireball and Frostbolt beside Magic Missiles, Aimed Shot beside Powershot, Sweeping Strikes beside
Crushing Blow — cast through `battle._resolve` on the same hero in one real fight**:

| Card beside kit card | Price paid at the cast line | Cooldown clock after | Turn scheduled | The door: before, after, each turn start |
|---|---|---|---|---|
| Fireball beside Magic Missiles | 15 and 15 | 3 and 3 | +1.82 and +1.82 | open, shut, shut, shut, open |
| Frostbolt beside Magic Missiles | 15 and 15 | 3 and 3 | +1.82 and +1.82 | open, shut, shut, shut, open |
| Aimed Shot beside Powershot | 25 and 25 | 3 and 3 | +2.86 and +2.86 | open, shut, shut, shut, open |
| Sweeping Strikes beside Crushing Blow | 20 and 20 | 3 and 3 | +3.16 and +3.16 | open, shut, shut, shut, open |

A cooldown of 2 is 3 on the clock because it ticks at the hero's next turn start (`start_cooldown`), so the card is
unusable for exactly two of his turns. **GT's three were priced in data and never cast; all four are now.**

`check_gu` reads card tags, so it joined `check_ek`'s `TAG_CHECKERS` in the same batch — written before the battery
rather than learned from a red, as seven batches before it did.

## §4 — WHAT DID NOT MOVE

No engine, kit, pool, node or rune; no card authored; no magnitude but Sweeping Strikes' cooldown. Arcane Explosion,
Shadowrend and Guard Change are GS's numbers, asserted. Fireball, Frostbolt and Aimed Shot are GT's. Battle Poise and
Shatterpoint are as they were (ruled), the four engine texts naming cards that no longer travel and the sim bot's reach
stay queued, and the 43 engine-reading runes and the 52 engine-bound gates are the next two stages.

## §5 — VERIFICATION

### §5a — The saves

The player's four save files were copied to `save-backups/GU-20260919-161942/` before any Godot process ran and
verified by md5: `profile.json` (ed4144e1…), `relics.json` (fdc12ffa…), `run_save.bin` (25582edd…) and `settings.cfg`
(0c1b39c3…). **Four, where GT found three**: a run is in progress, written at 16:01 after GT's commit, and
`profile.json` differs from GT's backup (the designer played between batches); `relics.json` and `settings.cfg` are
byte for byte GT's. Both isolated copies were renamed (`config/name`) before anything ran in them. **Hashed again after the acceptance run: all four byte-identical to
the backup.** The process table held no Godot process when the batch ended.

### §5b — The unmodified battery against the new tree

Before a gate was edited, the whole battery ran unmodified against GU's code — one changed cooldown and its comment —
on a tree stamped by md5 before and after (580 files by absolute path, untracked included — identical): **117 targets
in 57 minutes (16:38–17:35), `BATTERY_EXIT` 0, `check_de` at 485 / 0 / 0.** **116 read exactly what GT's acceptance run
read**; the 117th, `test_batch_an`, read 6,058 against 6,056, inside its band (6,049–6,066) — a count that moves on its
own. **Not one target moved for Sweeping Strikes' cooldown**, `check_eb` among them at 16 / 0: it could not see a boss
pool, so the only instrument that reads the change is the one GU wrote. Not one `Parse Error` or `SCRIPT ERROR` line in
any target's stream, grepped rather than tallied. The two standing sanctioned reds read as they did — `check_cm_live`
13 / 4 and `check_gj` §4's *"the card says +169 gold and the purse moved 189"* — **with FAIL lines byte-identical to
GT's acceptance run**, and the run harness's three gates pass at 22 / 382 / 8 with no throws.

### §5c — The repairs, and each one's second arm

**The project's one rule for a repair: to intent, never deleted, never loosened.**

| Target | HEAD's gate on GU's code | Now | What changed | Armed |
|---|---|---|---|---|
| `check_eb` | 16 / 0 — blind to the boss pools | **21 / 0** | walks every card a hero can earn, paired by class; the population asserted per class; Sweeping Strikes in `RETUNED` | **HEAD's Sweeping Strikes: 22 / 3**, naming the crossover against Bloodlust; **its walk back on the draft pool alone: 21 / 6**, naming the lost boss picks |
| `check_ea` | 83 / 0 | **83 / 0** | §4 walks the same population | **its walk back on the draft pool alone: 83 / 1** |
| `check_ek` | 47 / 0 | **47 / 0** | `check_gu.gd` in `TAG_CHECKERS` | — |
| `check_parse` | 191 / 0 | **192 / 0** | `check_gu` joined the battery | — |

### §5d — `check_gu`, and its controls

**Twelve defects** were injected one at a time into an isolated copy, restored by copy after each and compared by md5
after the last (467 files, identical); **the clean arm read 317 / 0, and every injection bit with a FAIL line naming
its defect.** A thirteenth arm planted a probe to measure `check_da`'s blind spot (§6), and a fourteenth, run after the
pre-pass, proved the widened Charge check (below):

| Injected | Read | The FAIL line it printed |
|---|---|---|
| **HEAD's Sweeping Strikes** (cooldown 0) | `check_gu` 318 / 6; `check_eb` 22 / 3; `check_ea` 83 / 0 | *Sweeping Strikes is below the kit card Crushing Blow … no row names it*; *costs 20, cooldown 0 … the baseline is Crushing Blow's 20, 2, 3.0*; *started a cooldown of 0*; and in `check_eb` *the warrior card Sweeping Strikes is now cheaper AND shorter than the core Bloodlust* |
| **The cast line never starts its cooldown** (data says 2) | 317 / 2 — **§4 alone** | *Sweeping Strikes started a cooldown of 0 and Crushing Blow one of 3*; *the door read [true, true, true, true, true]* |
| The cast line takes 5 more for Fireball | 317 / 1 | *the cast line took 20 for Fireball and 15 for Magic Missiles — the baseline is 15* |
| A new card under the kit (Hack and Slash, cooldown 1) | `check_gu` 318 / 1; `check_eb` 22 / 2 | *Hack and Slash is below the kit card Crushing Blow … no row names it*; *cheaper AND shorter than the core Bloodlust* |
| Guard Change at initiative 2.0 | 317 / 4 | *sits below ["Crushing Blow", "Pommel Strike"], where its row says […, "Mocking Blow", …]*; *not under on initiative alone* |
| Kindled Mind at 19% | 317 / 1 | *Kindled Mind deals 19% a cast against Magic Missiles's 36% — not the cantrip its row says* |
| Hold Breath's primary tag DEBUFF | 317 / 1 | *grouped the field role's catch-all, and its primary tag is Snare Trap's* |
| The gate's row groups Guard Change a former basic | 317 / 1 | *Guard Change is grouped a former basic attack and is not one* |
| Arcane Explosion at 20 Mana | 317 / 2 | *not at the price of Magic Bolt, the mage basic it replaced* |
| The door lets Sweeping Strikes through while it cools | 317 / 1 | *the door read [true, true, true, true, true] for Sweeping Strikes* |
| `check_eb`'s walk back on the draft pool alone | 21 / 6 | *the walk read 20 protected cards and 178 earnable cards*; *the warrior walk does not hold … Sweeping Strikes, Shatterpoint* |
| `check_ea` §4's walk back on the draft pool alone | 83 / 1 | *the walk read 20 cores and 178 earnable cards* |
| A probe returning the merged pool plus the boss pools | `check_da` **43 / 0** — unseen; the class-shelf form **44 / 2** | §6's instrument gap, measured |
| War Stomp, a Warden boss pick, at initiative 1.0 | 317 / 1 | *Charge is not the quickest card a Warrior holds* — the check walks the boss pools as well as the pool and kit since the pre-pass |

**The second injection is the one the brief asked for**: the price moved in the data and not at the cast, and §1 to
§3 passed it. Two FAIL messages were reworded after the first pass (a list with a card three times, and "under both"
where one was meant) and both controls re-run against the final gates; the fourteenth arm's file was restored and
compared by md5 the same way.

### §5e — The pre-pass and the acceptance battery

**A full pre-pass came first**, run in the isolated copy over exactly the tree that later landed — proved after landing:
582 files by absolute path, identical to the copy but for its renamed `project.godot` — and alongside the tail of the
recon: **118 targets in 57 minutes (17:06–18:02), green on its first run, `check_de` at 489 / 0 / 0**, on a copy stamped
identical before and after (468 files). Against the recon it moved exactly the rows GU moved — `check_parse` 191 → 192,
`check_eb` 16 → 21, `check_de` 485 → 489 and `check_gu` new at 317 / 0 — and the two counts that move on their own:
`test_batch_an` 6,058 → 6,056 and `test_batch_bk` 130 → 129 (band 128–130). **Three edits followed it, before the
acceptance run**: `CLAUDE.md`'s groups bullet re-attributed (the brief named three groups; the catch-all is GU's
reading), `check_gu`'s Charge check widened to the boss pools (the fourteenth arm), and `baselines.json`'s notes and
observation counts — re-checked before landing (`check_gu` 317 / 0, `check_ec` 24 / 0, `check_ed` 18 / 0, `check_fg`
22 / 0, `check_ff` 68 / 0, the literal sweep 0 lost, the manifest current) and again standalone in the tree.

**The acceptance battery, on the frozen repo tree** — stamped by md5 before and after, 582 files by absolute path,
untracked included, identical: **118 targets in 57 minutes (18:06–19:02), `BATTERY_EXIT` 0, `check_de` at 489 / 0 /
0**, `check_gu` at **317 / 0**, `check_eb` 21 / 0, `check_ea` 83 / 0, `check_parse` 192 / 0, and the run harness's three
gates PASS at 22 / 382 / 8. Against the pre-pass, 117 targets read the same and `test_batch_an` read 6,057. **The only
reds are the two sanctioned ones** — `check_cm_live` 13 / 4 and `check_gj` §4 at +169 / +189 — **their FAIL lines
byte-identical to GT's acceptance run.** Not one `Parse Error` or `SCRIPT ERROR` line in any target's stream, grepped
rather than tallied.

**Sizes, as `check_fg` printed them:** `CLAUDE.md` 335,070 → **337,477 B = 329.57 KiB**, 10.43 KiB under its 340 KiB
ceiling; `docs/changelog.html` 385,235 B, 14,765 B under its bar, GU's entry 2,871 B. **The pin manifest** is unchanged
at 1,491 pins. **`docs/state.md`'s VERIFICATION line was written after the run** — it is the one line that differs from
the copy the battery read, it opens no *2+ threshold* window (the only thing `check_es` §4 reads there), and
`check_es` read the same count standalone after it. **And one heading in `CLAUDE.md` was corrected after the run** —
*"since GT there are none"* became *"since GU"*, because the same bullet records the crossover GU found: two letters,
no literal any target reads lost or gained against the copy the battery read, and `check_ec` 24 / 0, `check_fg` 22 / 0
and `check_ff` 68 / 0 standalone, as in the acceptance run.

## §6 — FOUND AND NOT FIXED

- **`check_da` §3b CANNOT SEE A WALK BUILT ON THE MERGED POOL.** Its source families predate GP: `Classes.draft_pool(`
  is in none of them, so a function RETURNING the merged pool plus the boss pools — every card a hero can earn — counts
  one family and is not accused. Proved in a control copy (§5d). Widening the families moves that gate; not taken.
- **Mirror Image sits 5 Mana under the kit's Nexus Ward at the same cooldown**, both shields whose initiative is the
  buff cap, so EB's rule sets the pair aside. Both were class-wide cards before GN: GP's ruling 1, not this one.
- **The 47 trades and 34 set-aside pairs** (§2d), listed; the brief's "or" reading, which EB's ruling allows.
- **Two control copies left user-data folders** under Godot's `app_userdata`: "Dawn of Decay GU copy" and "Dawn of
  Decay GU ctl", each renamed before anything ran in it. They can be deleted.

## §7 — FILES

- **Game code (1):** `scripts/classes.gd` — Sweeping Strikes' cooldown, with its reason.
- **New gate:** `check_gu.gd`, and `run_battery.sh`'s GATES.
- **Repaired to intent (2):** `check_eb` (and its `_role_of` made static), `check_ea` §4. **Listed (1):** `check_ek`.
- **Instrument data:** `baselines.json` (`check_gu` new at 317; `check_eb` 16 → 21; `check_parse` 191 → 192);
  `pin-manifest.json` unchanged — current at 1,491 pins, because no gate GU wrote or edited pins a literal into a file.
- **Documents:** `CLAUDE.md` (the EB block — the population, the fifth crossover, and the four groups; the sits-out
  block — Battle Poise and Shatterpoint, ruled), `docs/master.html` (Sweeping Strikes' line, and its stamp),
  `docs/state.md`, `docs/changelog.html`, `docs/design-notes.md`, and this report (new).
- **Not edited:** `data/*.json`; `save-backups/`, which stays uncommitted.
