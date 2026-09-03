# BATCH EP — THE SECOND RUNG IS THE SAME FIGHT, TWICE AS HARD

**Measured, ruled on nowhere.** Rung 2 does not scale enemy health at all any more — **EO's own
change made rung 1's health and rung 2's health bit-identical** — so the two rungs run fights of
the same LENGTH, asking the same questions, and rung 2 simply doubles what a wrong answer costs.
**That is the failure EO fixed one rung down, arriving one rung up wearing the opposite sign.**

**AND THE BRIEF'S HEADLINE NUMBER IS WRONG.** Rung 2 with the rows rung 1 unlocks reads **22%**,
not 7%. The 7% was one n=30 reading whose own band is ±12 points; at n=100 the figure is
**22% ± 8.1**. The cliff is real and it is steeper than the brief's framing on the comparison
that is actually like for like — **95% → 22% on the same loadout** — but a player clears rung 2
roughly one attempt in four and a half, not one in fourteen.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*Five were checked. Two are wrong, and one of them is the number the batch is named after.*

| claim | verdict |
|---|---|
| "rung 1 now lands at 73% untalented" | **holds** — EO's n=100 AFTER arm, unchanged on this tree |
| **"rung 2 reads 7% with exactly the rows rung 1 unlocks"** | **WRONG. It reads 22% (22/100, ±8.1 pts).** EO's 7% was 2 of 30, and the harness prints a ±12-point band at that n in its own header. The two bands touch at ~19% and the point estimates are three times apart. |
| "stability flat at 100 and `ab.pressure` flat at every rung" | **holds, re-derived** — 21 of 21 kinds read `stability` 100; 48 of 48 rung-1 abilities are field-for-field identical at rung 2 |
| "every question the ruling named was authored, present and unreachable" (EO on rung 1) | **holds** |
| **"at the depth EJ gave the seven vaulted abilities"** | **NO SUCH PASSAGE.** `docs/reports/EJ.md` presents no abilities and vaults none; its only "seven" is *"eight dead rune clauses, seven of them fiction"* — extractor false positives in §2. `Classes.vault_ability()` holds **ten** definitions and every one is named by a live pool. **The only rune-option format the designer has actually seen is EO §3's own** (theme / axis / balance / synergy) and §4 below uses it, deepened. |

---

## §1 — WHAT RUNG 2 CHANGES. **IT IS ATTACK, AND ALMOST NOTHING ELSE.**

**Derived from the code, and every reader of the ladder swept independently of EO's sweep.** The
table carries four fields with a consequence and they have exactly ten readers between them:

| field | readers | what it does |
|---|---|---|
| `rung` | `battle.gd:1078`, `battle.gd:23193`, `run_sim.gd:240` | the enemy-ability filter, the meta gate, the report header |
| `mult` | `run_state.gd:1084` (`zone_base_mult`), `run_state.gd:1105` (`zone_base_mult_hp`) | ATTACK, and HEALTH with the rung floored out of it |
| `severity_floor` | `run_state.gd:2366` (`roll_offer`) | what the guaranteed mild bargain may be |
| `fixed_modifier` | `run_state.gd:2413` (`arm_fixed_modifier`) | rung 3 only |

**`Run.difficulty` outside that block is display and save only** — `draft_screen.gd:141`,
`battle.gd:23994`, and the two setters at `run_state.gd:463` / `:1989`.

### THE ANSWER: **NO. AND HEALTH IS NOT A LEVER BETWEEN THESE TWO RUNGS AT ALL.**

*Both spawn multipliers, both rungs, all three zones.*

```
wanderer  z1 atk=0.500000 hp=1.000000  z2 atk=0.750000 hp=1.500000  z3 atk=1.100000 hp=2.200000
warden    z1 atk=1.000000 hp=1.000000  z2 atk=1.500000 hp=1.500000  z3 atk=2.200000 hp=2.200000
```

**The health row is bit-identical on 3 of 3 products and the attack row doubles on 3 of 3.**
`zone_base_mult_hp` is `_zone_ladder(slot) * maxf(difficulty_mult(), 1.0)`, and `maxf` returns
rung 1's 0.50 as 1.00 and rung 2's 1.00 as 1.00. **EO floored the rung out of the health path to
stop rung 1 being short. The same floor makes rung 2's enemies exactly as durable as rung 1's.**

*Zone 1, slot 8, reproducing `battle.gd:1604-1616`'s own arithmetic including the ceil-to-10:*

| enemy | rung 1 hp | rung 2 hp | rung 1 atk | rung 2 atk | stability |
|---|---|---|---|---|---|
| raider | 170 | **170** | 58 | **116** | 100 |
| archer | 140 | **140** | 58 | **116** | 100 |
| shaman | 140 | **140** | 29 | **58** | 100 |
| brute | 320 | **320** | 58 | **116** | 100 |
| withered_warden | 600 | **600** | 58 | **116** | 100 |
| hollow_crown | 750 | **750** | 67 | **133** | 100 |

### THE THREE THINGS THAT DO MOVE, AND TWO OF THEM ARE SMALL

**1. ATTACK, ×2.00.** The whole of the rung's magnitude.

**2. ONE ABILITY, ON ONE ENEMY.** Config-diffed through `Enemies.config` at rung 1 against
rung 2, all 21 kinds:

```
KINDS THAT DIFFER BY RUNG (1 vs 2): 1 of 21  ["hollow_crown"]
  hollow_crown : rung1 3 [Crown of Thorns, Hollow Wail, Regalia]
  hollow_crown : rung2 4 [... + Sundering Decree]
CHECKED 48 rung-1 abilities across 21 kinds; MOVED 0
```

`data/enemies.json` holds **50 authored abilities and 2 rung tags, both the end boss's**. Every
other field of every other ability — `delay`, `pressure`, `applies_status`, `status_chance`,
`cooldown`, `damage`, `heal`, `aoe`, `multi_hits` — is byte-for-byte the same at both rungs.

**3. THE SEVERITY FLOOR, 2 → 3 — AND IT IS THE ONLY TWIST THAT WORKS.** Measured live over
**400 offers a rung**, mean severity of the three options offered:

| rung | floor | SAFE pool | GAMBLE pool | **mean severity offered** |
|---|---|---|---|---|
| 1 Wanderer | ≤2 | 12 | 8 | **2.83** |
| 2 Warden | ≤3 | 16 | 4 | **3.29** |
| 3 Ruin | ≤4 | 20 | **0** | **2.31** |

**THE TWIST INVERTS AT RUNG 3, AND NOTHING HAS EVER SAID SO.** `roll_offer` draws one option from
the pool at or below the floor and two from the pool above it. At rung 4-floor there *is* no pool
above it, so both gambles fall through the guard clause and are drawn from the whole
twenty-modifier table — **rung 3's bargains come out milder than rung 1's.** The source comment on
that guard reads *"it holds seven and needs to supply two, so this is a guard, not a path"*: the
high pool holds **8 at rung 1, 4 at rung 2 and 0 at rung 3**, and at rung 3 the guard **is** the
path. **The comment is corrected in this batch and nothing else is touched** — rung 3 is not this
brief's and no ruling is made on it.

### EVERYTHING ELSE READS NO RUNG AT ALL

Encounter counts (`SLOTS_PER_ZONE` 16 × 3 zones = 48 + the end boss = 49), elite and boss
composition (`compose` and `battle_budget` take no rung argument), gold (`award_gold` reads none),
loot and the relic ladder. **Re-derived by grepping every caller of `difficulty_*` and
`DIFFICULTIES`, not by reasoning about it.**

### **SO THE FIGHTS ARE THE SAME LENGTH, AND THE MEASUREMENT SAYS SO**

Enemy health identical, `stability` a flat 100 on all 21 kinds, hero `pressure` untouched — a
100-point Break bar costs **7.2 casts of a pressure-bearing ability at the corpus mean** (76 of
227 abilities carry any pressure; mean 13.8) at rung 1 and at rung 2 alike. **Rounds to
resolution, same loadout, n=100 a rung:**

| rows 1–3 equipped | trash | elite | boss |
|---|---|---|---|
| **rung 1** | **7.8** | 7.3 | 10.0 |
| **rung 2** | **7.4** | 6.9 | 10.1 |

**The rung-2 fight is not longer, not shorter, and not different. It is the same fight taking the
same number of turns, and the enemy hits twice as hard while it happens.**

---

## §1b — WHERE THE 22% IS ACTUALLY LOST

**Four arms, `--run 100` each, `DOD_SIM_ROUTE=balanced`, the standard four specs, EO's method.**

| arm | rung | rows | **completion** | 95% band | fights | wipes | **loss per fight** |
|---|---|---|---|---|---|---|---|
| **B** | 1 | 3 | **95%** | ±4.3 | 2681 | 5 | **0.19%** |
| **A** | 2 | 3 | **22%** | ±8.1 | 1994 | 78 | **3.91%** |
| **C** | 2 | 0 | **3%** | ±3.3 | 1412 | 97 | **6.87%** |
| **D** | 2 | 9 | **90%** | ±5.9 | 2693 | 10 | **0.37%** |

*(EO's rung 1 / rows 0 / n=100 reads 73% and was not re-run; the tree has not moved.)*

**THE CLIFF, ON THE ONLY COMPARISON THAT IS LIKE FOR LIKE: 95% → 22% on the same three talent
rows.** 73 points at **15.6 standard errors on the difference**. The brief's 73%-against-7% pair
compared an untalented party at rung 1 with a talented one at rung 2 and understated the drop
while overstating how bad rung 2 is.

### **IT IS ATTRITION, NOT A WALL, AND NOT A BOSS**

*Exact wipe slot for all 78 of arm A's wipes, read off the harness's own per-run progress line.
Slot 8 is the mini-boss, 16 the zone boss, 17 the end boss.*

```
t2 x2   t4 x1   t5 x1   t7 x1   t8 x7 (MINI-BOSS)  t9 x3   t10 x6
t11 x7  t12 x13  t13 x8  t14 x11  t15 x11  t16 x7 (ZONE BOSS)
FIXED NODES (8 + 16 + 17): 14 of 78 = 18%
SLOTS 10-15 (ordinary trash and elite): 56 of 78 = 72%
BY ZONE: z1 x9   z2 x34   z3 x35
```

**Only 18% of run-ending deaths happen at a node the route cannot duck.** Nearly three quarters
happen at ordinary fights in the back half of a zone, and the mass is spread across six slots
rather than piled on one. **No single fight is a wall:** the worst per-fight win rate the report
prints for arm A is **88%** (z3 t10), and z1 is a clean 100% at every slot. The run ends because a
party takes about twenty-six fights and **the per-fight loss rate is 3.91% at rung 2 against
0.19% at rung 1 on the same loadout — a factor of twenty-one.**

The mechanism is visible in the deaths column, same loadout, rung 1 against rung 2:

| slot | deaths/fight, rung 1 | deaths/fight, rung 2 |
|---|---|---|
| z2 t8 | 0.08 | **0.65** |
| z2 t10 | 0.10 | **1.03** |
| z3 t8 | 0.38 | **1.56** |
| z3 t10 | 0.35 | **1.58** |

**A rung-2 party wins nearly every fight and arrives at the next one a body down.** That is what
doubling attack and holding health constant produces: not a fight it loses, a fight it survives
badly, twenty-six times.

### **AND THE HARNESS'S OWN WIPE TABLE WOULD HAVE GIVEN THE OPPOSITE ANSWER**

`run_sim.gd`'s wipe distribution bands `tier >= 11` as **"boss"**, and its per-tier table loops
`for ft in range(1, 12)` and labels `ft == 11` as **"boss"**. **A zone has held SIXTEEN slots
since BATCH BK; the zone boss is slot 16 and the mini-boss slot 8.** So:

· the **"boss"** band is **six slots**, and reads **57** for arm A where the true zone-boss count
  is **7**;
· the per-tier table **silently drops slots 12–16** — five of a zone's sixteen, and the five where
  most wipes happen. Its printed win rates are therefore optimistic by construction, because it
  omits exactly the slots where runs end;
· `_finish_run`'s own comment still says the depth ladder is *"((zone-1)\*11 + tier, so a full
  clear is 33)"* while the code reads `SLOTS_PER_ZONE` and the header correctly prints **of 49**.

**Reading the printed table literally would have produced "70 of 97 wipes are at a boss" — the
exact opposite of what happened.** The true distribution above came from the per-run progress line
(`wiped z%d t%d`), which carries the exact slot and needed no instrument change. **Nothing was
fixed:** changing the report mid-batch would have described an instrument that produced none of
the numbers in it, and would break comparability with every prior batch's wipe table. **It is
named here as the next instrument, the way EO named the missing Break telemetry.**

---

## §1c — WHAT ROWS 1–3 ARE WORTH. **NINETEEN POINTS, AND A SEVENFOLD MULTIPLE.**

**The brief's test was "if they move the rung 2 figure by two points, the tutorial gate is not
teaching what it gates."** They move it from **3% to 22%** — **+19 points at 4.2 standard errors
on the difference**, and a **7.3× multiple on the completion rate.** The gate teaches what it
gates.

**AND THE ARM IS EXACTLY THE FIRST-CLEAR PLAYER, WHICH IS WORTH PROVING RATHER THAN ASSUMING.**
`Profile.award_zone_boss_points` pays **1 point per spec per ZONE boss** and the end boss pays
none, so a run that clears rung 1 banks exactly **3 points**. Rows 1–3 hold **9 cells**
(3 lanes × 3 rows) at `TIER_COSTS[0]` = **1 point each**. **Three points buys three of the nine
cells, and `DOD_SIM_ROWS=3` equips exactly three nodes.** The arm is not an approximation of the
player who just cleared rung 1; it is that player's loadout.

**THE CEILING IS NOT MEASURABLE WITH THIS HARNESS AND IS STATED RATHER THAN GUESSED.** A player
who took three attempts at rung 1 banks nine points and can fill **all nine** cells of rows 1–3.
`DOD_SIM_ROWS` fills one lane's rows and `DOD_SIM_BUILDS` names one lane per spec, so a
three-lane, nine-node loadout cannot be expressed. **22% is therefore a FLOOR on what a rung-1
graduate reads, not an estimate of one**, and the true figure for a player who ground the starter
rung sits somewhere between 22% and the 90% that nine full rows buy.

---

## §2 — THE OPTIONS. **NOTHING IS SET, NOTHING IS RETUNED, NOTHING IS RULED.**

**No scale factor was touched.** `DIFFICULTIES["wanderer"]["mult"]` is still ×0.50, unplayed, and
EO's own flag on it stands. A rung-2 change stacked on an unplayed rung-1 change compounds two
unmeasured decisions and the second would be attributed to the first.

**§1's finding narrows the field before any of these are weighed: rung 2 is not "harder"
differently from rung 1 — it is the identical fight with the damage doubled.** So the question in
front of the designer is not how much harder rung 2 should be. It is **what rung 2 should ask that
rung 1 does not.**

### **A — TUNE THE DAMAGE SCALE**
· *Cost.* One number. Nothing else in the game moves.
· *What it teaches.* **Nothing.** It moves where the cliff sits, not what the rung asks. A player
  who clears a retuned rung 2 has learned exactly what they learned at rung 1.
· *Note.* It is the only option that certainly closes the gap, and the only one that needs no
  authoring. It is also the one §2 warns against taking on top of an unplayed ×0.50.

### **B — MAKE THE BREAK GATE RUNG-AWARE**
· *Cost.* Small and shaped like something already shipped: enemy `stability` is a flat 100 on all
  21 kinds, and a rung-aware multiplier on it is the same one-line shape as `zone_base_mult_hp`.
· *What it teaches.* **Break as a resource rather than a formality.** At the corpus mean a
  100-point bar is 7.2 pressure-bearing casts; ×1.3 makes it 9.4, and the player has to choose
  *which* enemy is worth Breaking and *when*, instead of Breaking everything eventually.
· *The risk, measured.* **Pressure is not evenly distributed and this option taxes the thin specs
  hardest.** Per spec draft pool: Sharpshooter 6 pressure-bearing cards, Arcanist 5, Berserker and
  Occultist and Swordmaster and Pyromancer 4 — but **Holy 1 (mean 6.0) and the Inquisitor 0**.
  A rung-aware Break gate would quietly become a *spec* gate.

### **C — RUNG-TAGGED ABILITIES, THE MACHINERY THAT ALREADY EXISTS**
· *Cost.* **Zero code.** `Enemies.config` already filters on `rung` and defaults an untagged
  ability to 1, so a third tag is one field in `data/enemies.json`. The cost is **authoring** —
  and every new ability owes `master.html`, `text-standard.html` and a card row in the same batch.
· *What it teaches.* **The most, because it changes the QUESTION rather than the price of getting
  it wrong.** It is the only option here that gives rung 2 something rung 1 does not have. It is
  also the ladder's own stated principle — *"stat inflation alone is a wall, a named twist is a
  ladder"* — applied to enemies rather than to bargains.
· *Where it stands today.* **2 of 50 authored abilities carry a rung tag and both are the end
  boss's.** Rung 2 adds exactly one ability to exactly one enemy in the whole game.

### **D — CHANGE THE ENCOUNTER SHAPE, NOT THE ENEMIES**
· *Cost.* `battle_budget` and `compose` take no rung today; threading one through is small.
· *What it teaches.* **Target priority and the value of reach.** A wider warband at the same
  per-enemy strength makes AoE, cleave and Break-spreading real decisions rather than incidental
  ones, and it lengthens the fight without making any single blow harder to survive — the axis
  §1 shows rung 2 does not currently move at all.
· *The trap, named.* The budget ramp was rescaled at BK §5 precisely because slot 15 would
  otherwise have collided with the boss's own 10–12 band, and `compose` floors elite and mini-boss
  rosters at 6 so an elite cannot degrade to a plain mob. **A rung-aware budget has to respect
  both, or it silently changes what an elite IS.**

### **E — MAKE THE TWIST THAT EXISTS ACTUALLY WORK**
· *Cost.* One line, and it is rung **3**'s problem rather than rung 2's — at rung 2 the severity
  floor does fire (2.83 → 3.29 mean severity).
· *What it teaches.* Nothing new at rung 2. It is listed because §1 found it while answering the
  brief's question, and because **a ladder whose top rung offers milder bargains than its bottom
  one is a defect wherever it is ruled on.**

### **AND ONE THING THAT IS NOT AN OPTION**

**Giving rung 2's enemies rung 1's health back is not available**, because they already have it.
Any option that works through health has to *raise* rung 2 above the shared baseline, which
un-does the floor EO put in and re-opens the question EO closed.

---

## §3 — THE 22% IS A BOT FLOOR, NOT A PLAYER FORECAST

**The bot does not learn between rungs and a player does.** Every policy it plays by is printed in
its own report header and none of them improve with experience. What follows is what those
policies **exclude** — each read off the code, not off the document.

| the decision | what the bot does | where |
|---|---|---|
| **which ability to cast** | a fixed per-spec rotation of `if` clauses, identical on turn 1 and turn 30 | `battle.gd:4367` |
| **which drafted card to cast** | **the first usable one in slot order** — and only when the kit rotation has already fallen through to the basic attack | `battle.gd:4042` |
| **items in battle** | one Health Potion, drunk when a hero *opens a turn* below 35% HP. **Bomb, revive, defense and mana items are never used at all** — the branch reads `items["health"]` and nothing else | `battle.gd:3581` |
| **items before a fight** | never. There is no pre-emptive or offensive item use of any kind | — |
| **routing** | one tier ahead only: it ranks the nodes it can reach *from where it stands* and takes the best-ranked | `run_sim.gd:376` |
| **shops** | heal-first, then the priciest affordable thing not already carried. **Rune picks ignore build synergy entirely**, and the fight-first route means it reaches **0.0 of 0.0 shops** on this party | `run_sim.gd:507` |
| **bargains** | severity-extreme: the harshest offered above 60% party HP, the mildest below. It never reads what the modifier *does* | `run_sim.gd:393` |
| **ability picks** | the first entry in the offer | `trophies=first-in-pool` |
| **events** | the first valid option | `events=first-valid` |
| **talents** | one lane, cheapest node first, **the tree's FIRST lane — 24 of 36 lanes have never been measured at all** | `run_sim.gd:972` |
| **the timing bar** | 20% Perfect, otherwise Good, on offence; on defence it rolls 20% and otherwise takes **no mitigation at all** | `battle.gd:3877`, `DEF_BOT_PERFECT` |

**A player does every one of those things better after their first run, and several of them are
the whole of the difficulty.** The two that matter most at rung 2 specifically are the ones §1b
points at: **a party dying by attrition is a party that should have spent an item and did not**,
and the bot owns exactly one item behaviour, triggered after the damage has already landed.

**That list is the gap between 22% and whatever a person scores, and it is worth having beside the
number rather than inferred from it.** It is not an argument that rung 2 is fine — the same bot
reads 95% one rung down on the same loadout, and the bot's blindnesses are constant across that
pair.

---

## §4 — FOUR RUNE ITEMS, RE-PRESENTED IN FULL

**EO reported these and they never reached the designer.** Nothing here is authored, nothing is
retired, and nothing is ruled.

### **THE FLOORS, RESTATED — RE-DERIVED THROUGH `Runes.eligible_ids`, NOT QUOTED**

*Empty pouch, every spec, through the game's own door.* **65 authored, 12 retired, 53 offerable.**

```
FLOORS — drawable 9 (Occultist), spec-scoped 2 (Cryomancer), rare shelf 5 (Occultist),
         against 3 rune slots
```

Reproduces EO name for name. The Beastmaster sits at **12 drawable / 4 spec-scoped**, the joint
deepest pool in the game, **because his three went to the re-author half rather than the retired
one.**

### **HALF ONE — THE BEASTMASTER'S THREE. OPTIONS ONLY.**

**The fact that decides all three, and it is new.** Every talent node the three runes mirror sits
in **rows 1–3** — the rows a single rung-1 clear opens:

| rune clause | value | the node it mirrors | lane / row | node value | the rune is |
|---|---|---|---|---|---|
| `rune_wild_communion_step` | 1.5 | Wild Communion | devotion / **1** | 7 | **21%** of it |
| `rune_absolute_step` | 3.0 | Absolute Devotion | devotion / **3** | 15 | **20%** |
| `rune_quick_whistle_ranks` | 1 | Quick Whistle | pack / **1** | 3 | **33%** |
| `rune_momentum_ranks` | 8 | Feral Momentum | pack / **2** | 25 | **32%** |
| `rune_companion_hp_pct` | 0.05 | The Wild Within | handler / **2** | 0.40 | **12.5%** |

**A 100g rare rune buys between an eighth and a third of a node the player already owns.** That is
the charter's complaint stated as a magnitude, and it is why "re-author" and not "retune" is the
question in front of the designer.

---

**RUNE OF THE DEEP BOND** — 100g, rare, `spec:beastmaster`, lane *devotion*. Both clauses scale on
Loyalty: `rune_wild_communion_step` 1.5 and `rune_absolute_step` 3.0.

· *What it does today, at the read sites.* `_bond_step` (`battle.gd:13349`) computes
  `BOND_STEP + 0.01 * (absolute_step + rune_absolute_step)`, doubled again by Ancient Pact; the
  Loyalty strike step is `5.0 + wild_communion_step + rune_wild_communion_step`
  (`battle.gd:13444`), and the same sum is read again for a bodiless blow (`:20730`) and for a
  living companion's damage (`:21860`). **Four read sites, all live.**
· *Theme.* The bond that deepens rather than the bond that spreads: the longest-standing companion
  is the one that has earned something.
· *Axis.* **DEPTH** — read the accumulated meter and pay its depth. The row-8 shape applied to an
  item.
· *Balance.* Loyalty already over-arrives — `docs/state.md` records a **21.2 peak against a nominal
  5** — so depth-scaling pushes the direction that is already too far. A cap, or a payout that
  flattens above the nominal, is the obvious counterweight and should be priced before the rune is.
· *Synergy / interest.* **It is the only one of the three that rewards NOT swapping**, which makes
  it the exact opposite of the Turning Pack and gives the pair a real decision between them. That
  opposition is the strongest argument for authoring either.

**RUNE OF THE TURNING PACK** — 100g, rare, `spec:beastmaster`, lane *pack*.
`rune_quick_whistle_ranks` 1 and `rune_momentum_ranks` 8.

· *What it does today.* The first shaves one turn off the shared Swap Companion cooldown
  (`battle.gd:20522`, floored at zero); the second is Feral Momentum's per-distinct-beast
  multiplier, read for a bodiless blow (`:20732`) and for a companion's damage (`:21862`).
· *Theme.* The handler who never shows the same animal twice.
· *Axis.* **BREADTH / TEMPO** — pay for the SWAP itself rather than for what the swapped-in beast
  hits for.
· *Balance.* The Beastmaster's five-card BOSS POOL already deals **no damage and no Break
  at all** (`docs/state.md`; it is the only pool in the game with no damaging card), so a second non-damaging item deepens a concentration finding rather than
  answering one. **A version that paid the swap in Break or in a damage window would answer it
  instead.** And the sim measures **0.35 swaps a trash fight** (arm C, n=1310 fights) — a rune that shaves the cooldown
  of an action the bot almost never takes is priced against a behaviour nobody has confirmed a
  player takes either.
· *Synergy / interest.* Tempo is the axis his kit is thinnest on, and a swap-priced rune makes
  Quick Whistle a decision rather than a formality.

**RUNE OF THE SHARED WILD** — 100g, rare, `spec:beastmaster`, **no lane** — a splash.
`rune_wild_communion_step` 1.5, `rune_momentum_ranks` 8, `rune_companion_hp_pct` 0.05.

· *What it does today.* The first two are the other two runes' clauses; the third is its own —
  `base_hp = stats[0] * (1.0 + companion_hp_pct + rune_companion_hp_pct)` at the summon
  (`battle.gd:20543`).
· *Theme.* The beast that comes home. The only one of the three about the companion's body.
· *Axis.* **SURVIVAL** — the companion living through the fight rather than hitting harder in it.
· *Balance.* **Safest of the three.** It adds no damage to a spec whose damage is already
  concentrated, and companion durability is the one Beastmaster number no other rune touches. The
  sim measures **0.22 companion deaths a trash fight and 0.39 at a boss** (arm C), so there is a real
  event for it to act on.
· *Synergy / interest.* **It is the only splash of the three, and splashes are the half the
  charter hurt most** — with no lanes to reach across, "a little of every bond" has nothing to
  reach. Re-authoring it as one idea makes it a lane rune wearing a splash's name, and **that is a
  real cost the designer should price before choosing this one.**

**AND THE HONEST NOTE ON ALL THREE, RE-VERIFIED.** These are the only runes among the sixteen
whose retirement would remove a MECHANIC rather than an item from a shelf. **After a blanket
retirement there would not be one rune in the game touching a companion** — no class-wide or
universal rune does either — **and the companion IS the spec.**

### **HALF TWO — THE BARED GUARD. REPORTED ALONE, RULED ON NOWHERE.**

**Rune of the Bared Guard — 75g, rare, `spec:swordmaster`, lane Blade, `scarred=true`.**
`rune_seasoned_off_bonus` +0.10 and `rune_seasoned_def_bonus` −0.15.

**ITS TWO CLAUSES ARE THE TRADE, AND THE ARITHMETIC IS EXACT.** Seasoned Fighter's two stances
resolve at `battle.gd:9335` and `:9809`:

| | deals | takes |
|---|---|---|
| Aggressive, no rune | ×1.15 | ×1.10 |
| Defensive, no rune | ×0.90 | **×0.85** |
| Aggressive, **with the rune** | **×1.25** | ×1.10 |
| Defensive, **with the rune** | ×0.90 | **×1.00** |

**The −0.15 is exactly the size of the mitigation it removes**: `maxf(0.85 - seasoned_def_bonus -
rune_seasoned_def_bonus - discipline, 0.0)` resolves to 1.00 on the nose. The card's own sentence
— *"Defensive Stance no longer reduces damage taken"* — is literally true rather than
approximately so. The rune widens the offensive gap between the stances from 1.28× to 1.39× and
narrows the defensive gap from 0.77× to 0.91×.

**AND THE COST IS 80% REFUNDABLE BY ONE ROW-1 TALENT NODE, WHICH NOTHING HAS SAID BEFORE.**
`sm_def_stance` — **Defensive Stance, lane Poise, row 1** — writes `seasoned_def_bonus` 0.12 into
the same subtraction. A Swordmaster holding both reads `0.85 − 0.12 + 0.15 = 0.88` against a
vanilla 0.85. **The node is inside the three rows a single rung-1 clear opens**, so the refund is
available to the first player who ever sees the rune. Whether a Scarred rune whose cost a starter
talent buys back is still a trade is a design question and it is the designer's.

**AND ONE CORRECTION TO EO, MEASURED.** EO wrote that retiring it would leave the Swordmaster
*"the only spec in the game with no Scarred rune."* **Measured through `eligible_ids`, that is an
overstatement:**

| spec group | scarred runes drawable | of which spec-scoped |
|---|---|---|
| the three WARRIOR specs (Berserker, Warden, **Swordmaster**) | **3** | 1 |
| the other nine specs | **4** | 1 |

**There are 17 Scarred runes: 2 universal, 3 class-scoped (mage, cleric, hunter — there is no
`class:warrior` one), and exactly 1 per spec.** Retiring the Bared Guard would leave the
Swordmaster **2** — `glass` and `vampiric`, both universal. **He would not have "no Scarred rune";
he would be the only spec with no SPEC-SCOPED one, and would hold the thinnest Scarred shelf in
the game at 2 against a range of 3–4.** The set-shape argument stands and is sharper than EO put
it; the loss is smaller than EO priced it.

· **As a loss:** it is the only item in the game that lets a Swordmaster buy *commitment*. Trading
  a defensive posture for an aggressive one is a decision no other rune in his pool offers —
  `still_wrist`, `shattered_guard` and `duelist` are all pure upside.
· **Nothing mechanical depends on it either way:** `Runes.is_cost()` already refuses to scale its
  negative term under the sim's rarity lever.
· **It is live, offerable and untouched.**

---

## §5 — WHAT MOVED, AND WHAT DELIBERATELY DID NOT

| file | what |
|---|---|
| `scripts/run_state.gd` | **one comment**, on `roll_offer`'s guard clause. No executable byte moved. |
| `docs/master.html` | the rung-2 cell says health is identical to rung 1's; the stamp |
| `docs/changelog.html` | this batch's entry |
| `docs/state.md` | rewritten |
| `docs/reports/EP.md` | this file |

**NOT DONE, STATED SO THE BATCH IS NOT READ AS CLEAN:**

· **No scale factor set, no rung retuned, no ruling made.** §2 is options.
· **Nothing authored for the three re-authors, and the Bared Guard is not ruled on.**
· **The run report's wipe banding and its dropped slots 12–16 were NOT fixed**, and neither was
  `_finish_run`'s stale "of 33" comment. Named, not repaired — see §1b.
· **No gate.** A gate encodes a ruling and nothing here is ruled.
· **No `CLAUDE.md` rule.** Nothing is settled until §1 is read.
· **The nine-cell rows-1-3 ceiling was not measured** and cannot be with this harness (§1c).
· **Rung 3's inverted bargain twist is reported and left.** It is not this brief's rung.
· **No Break-count telemetry was added.** EO named it as the obvious next instrument and it is
  still missing; §1's Break claim rests on the flat arithmetic and on rounds to resolution.

---

## §5b — THE VERIFICATION RUN

**THE FLOOR FIRST, THE WAY THE BRIEF SPECIFIES.** `grep -lE 'Parse Error'` over every one of the
**87 battery logs: 0 files matched.** `SCRIPT ERROR`: **0 files matched.** Never a tally, never an
exit code.

| | |
|---|---|
| targets run | **87** |
| checks | **41,420** |
| throws | **0** |
| `Parse Error` | **0** |
| the differ | **`check_de`: 358 / 0 / 0** |
| run harness | 22 / 166 / 8 |
| `check_ct_map` | 83 / 0 · `check_map_screen: OK` |

**THE TREE WAS FROZEN AND THE FREEZE WAS PROVED**, not assumed: **204 files md5'd by ABSOLUTE
path** before the run and again after — identical, zero drift. **`.ran` holds 87 names with no
duplicate**, every name has a log and every log a name, so no second battery wrote into the
directory.

**NOT ONE BASELINE ROW MOVED, WHICH WAS WRITTEN DOWN BEFORE THE RUN.** The batch changes no
executable byte and adds no gate, so `check_parse` reads its recorded **161** and no second row was
owed. `check_de` reads **358 / 0 / 0** — the same target count as EO, and **zero notices as well as
zero errors**, so nothing rose either.

**THE TWO STANDING REDS ARE STANDING AND NOTHING ELSE IS RED.** `test_rune_battle` reads
**97 / 1** against its recorded band of 97 / 0–1, and `check_cm_live` reads **13 / 4** against a
recorded 13 / 4. **Neither moved, and no third appeared.**

**`check_parse` RESIDUE READS 4** — `check_ck_width`, `check_cu`, `check_cv`, `check_dn`, the four
long-standing ones. **The five measurement probes this batch wrote were moved out of the tree
before the run and the residue walk proves it**, which is the check doing exactly the job EM's
battery found for it.

### THE PRE-CHECK, DERIVED BY GREPPING THE PATH RATHER THAN BY REASONING ABOUT IT

**`res://docs/master.html` has 25 readers, `res://docs/changelog.html` 16 and
`res://scripts/run_state.gd` 19 — 36 deduped targets, and every one was run before the battery:
0 red, 0 parse errors, 0 throws.** `docs/state.md` and `docs/reports/` are read by **zero**
targets (`grep -rl` on both paths returns nothing; all six `.gd` mentions of `state.md` are
comments), which is what makes this file and that one safe to write after the run.

**AND "BLANK" HAD TO BE SEPARATED FROM "DID NOT RUN" AGAIN.** `check_map` and `check_flow` print
no check-count line at all, so the battery's grep reads `?` for both — indistinguishable from a
target that never launched. **Both were confirmed by reading their logs**: `check_flow` prints its
`ok` lines and `check_map` its four routing distributions.

**AND ONE PRE-CHECK READING WAS THE HARNESS'S OWN SCAR REPRODUCING ITSELF IN MY RUNNER.**
`test_batch_bl` read **88 / 4** in the pre-check and **88 / 0** in the battery. The pre-check
script omitted `EXTRA[test_batch_bl]="--fixed-fps 12"`, which `run_battery.sh` carries precisely
because that suite under-runs without it — the same flag CLAUDE.md records as one of the three
scars baked into the battery script. **Re-run by hand with the flag it reads 88 / 0, its recorded
baseline.** A pre-check that does not reproduce the battery's per-target flags is a pre-check that
manufactures its own reds.

### THE RETIRED-WORD PRE-CHECK, RUN BEFORE THE BATTERY

`test_batch_bx` §4 keeps *beast* out of player-facing prose and §4b keeps *party* out, and both
read `master.html` — the trap DU and DS each paid for. **Both strips were reproduced exactly**
(lower-case, the five `PARTY_IDENTS` removed, then `contains("party")`; and both casings of
*beastmaster* removed, then `contains("beast")`) **against the edited document: clean in both.**
The 13-file source sweep §4b runs reads **0 strays**. `bx` reads **161 / 0** in the battery.

### THE NEGATIVE CONTROLS. **FOUR WERE ARMED AND ALL FOUR BIT.**

| control | armed on | armed | disarmed |
|---|---|---|---|
| **1 — the comment-stripped diff**, the instrument that proves the one source edit moves no code | the comment insert also swallowing the `picked.append(low.pop_front())` below it | **10 diff lines, naming the swallowed line** | **0** (1429 code lines both sides) |
| **2 — the retired-word strip**, on a needle `test_batch_bx` §4b demonstrably reads | *"The whole party climbs the difficulty ladder"* into `master.html` | **contains("party") = True** | **False** |
| **3 — the literal sweep**, on a needle BOTH trees carry, BROKEN rather than extended | every `×1.00` in `master.html` replaced | **LOST=1** | **LOST=0** |
| **4 — the wipe extractor**, two-armed, on the instrument §1b's whole answer rests on | (a) 3 `COMPLETED` runs turned into `wiped z2 t16`; (b) 5 turned into `wiped z1 t3` | (a) t16 **7 → 10**, fixed share **18% → 21%**; (b) t3 **0 → 5**, fixed count **stays 14** | 78 wipes, 14 fixed, 18% |

**CONTROL 3 HAD TO BE RE-AIMED, AND THAT IS THE PART WORTH KEEPING.** The first needle chosen was
`&times;1.00`, taken from `test_batch_bn`'s line `doc.contains("&times;1.00") or
doc.contains("×1.00")`. **`&times;1.00` appears in `master.html` at HEAD zero times** — the
assertion has always passed through the OR's *second* branch. A control armed on it would have
moved nothing and proved nothing, because a needle absent from both trees can never appear in
LOST or GAINED. **The group is evaluated as the operator joins it (EC §1), and an extractor that
reads each literal separately reports a needle the suite never depended on.** Re-armed on `×1.00`,
which both trees carry twice, it bit.

### THE LITERAL SWEEP

**11,142 needles ≥4 characters, extracted from all 89 targets, against HEAD:**

| file | LOST | GAINED |
|---|---|---|
| `docs/master.html` | **0** | **0** |
| `scripts/run_state.gd` | **0** | **0** |
| `docs/changelog.html` | 0 | 17 |
| `docs/state.md` | 9 | 18 |

**But the sweep is not the proof, and the changelog's 17 are the reason to say so.** Its 16
readers were enumerated rather than counted: **every one asserts exactly two things** — a positive
`find("/changelog-archive.html</code>")` (untouched, 3 occurrences) and a NEGATIVE
`not contains("<h2>2026-…&mdash; Batch YY")` on its own batch's heading. **None of the 17 GAINED
literals is an `<h2>…Batch` heading**, and no suite asserts Batch EP absent. `check_dv` §4's
count is one `ok()` over all headings rather than one per heading, so its 83 does not move with an
entry — confirmed at 83 / 0 in both the pre-check and the battery. **`state.md`'s 27 flips reach
nothing, because no target reads it.** The one that looks alarming — `"which catches 1 Ruin"` —
is `test_batch_bj`'s pin into **`data/runes.json`**, which this batch did not touch; `state.md`
merely happened to quote it.

### THE POST-RUN EDITS, AND WHY THEY COST NOTHING

Three files were edited after the frozen run: `docs/reports/EP.md` (this section, and two
corrections), `docs/state.md` (the last-measurements block and two stale figures), and nothing
else. **Both are read by ZERO targets**, derived by grepping `res://docs/reports` and
`res://docs/state.md` across all 89 — so unlike EO's post-run set, this one contains no file any
suite or gate opens, and the needle sweep is a formality rather than the argument.

**ONE OF THE TWO CORRECTIONS IS THIS BATCH'S OWN TRAP CLOSING ON IT.** §1's reader table cited
`run_state.gd:2406` for `arm_fixed_modifier` — measured before the eight-line comment this batch
inserted at line 2381. **The guard is at 2413 now.** A comment that documents a mechanism moves
every line number below it, including the ones in the report that documents the same mechanism.

### WHAT THE INSTRUMENTS COULD NOT SEE, NAMED RATHER THAN DISCOVERED LATER

· **The nine-cell ceiling of rows 1–3 is unmeasurable with this harness** (§1c). 22% is a floor.
· **The run report's per-tier table drops slots 12–16 and mislabels slot 11 as the boss** (§1b).
  Every printed win rate in this report inherits that, which is why the wipe distribution was
  rebuilt from the per-run progress line instead.
· **No Break-count telemetry exists in run mode.** §1's Break claim rests on the flat
  `stability` / `pressure` arithmetic and on rounds to resolution, not on a Break tally. EO named
  this as the obvious next instrument and it is still missing.
· **Nothing was measured on the real difficulty a human plays at.** Every figure is the bot's,
  with the eleven exclusions §3 enumerates.
· **A THREE-HOUR-OLD ORPHANED SIM FROM BATCH EO's SESSION WAS FOUND SPINNING AT 98.8% CPU** during
  this battery. Both its arms had printed complete reports and written their `.ran` markers at
  14:47 — the figures EO published — and the process never exited. It was killed; it wrote nothing
  and the freeze proves the tree did not move. **A completed `--run` sim does not always quit, and
  a battery with a per-target watchdog is exactly the thing a spinning orphan can cost.**
