# BATCH EQ — THE LOYALTY METER, MEASURED BEFORE A CURVE IS CHOSEN

**Measured and presented. Nothing was flattened, nothing was authored, nothing was retuned and no
rune was changed.** The designer ruled that Loyalty's payout should flatten above nominal and that
the Rune of the Deep Bond keeps DEPTH as its axis. This is the measuring that ruling asked for, and
the curve priced as options.

**THE BRIEF'S OWN FRAMING NEEDED THREE CORRECTIONS AND THE METER'S HEADLINE FIGURE NEEDED A
FOURTH.** They are in the table below and each one changes what §2 is choosing between.

**NOT ONE EXECUTABLE BYTE OF THE SHIPPED TREE MOVED.** Every measurement was taken on an
out-of-repo instrumented copy of the tree; the repo holds four document edits and nothing else.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

| claim | verdict |
|---|---|
| "Loyalty over-arrives at a measured 21.2 peak against a nominal 5" | **HALF RIGHT, AND THE HALF THAT IS WRONG IS THE ONE THE OPTIONS ARE PRICED AGAINST.** 21.2 is Batch DA's figure at `rows=9`; live at that loadout it is **18.45 ±0.17**. **At the loadout a single rung-1 clear buys — rows 1–3 — it is 10.13 ±0.11, and untalented it is 6.61 ±0.09.** The meter over-arrives at every loadout; it over-arrives *four times as far* at the top of the tree as at the bottom. |
| **"The Pack Bond boon doubles at 5 … a curve that flattens above 5 sits exactly on top of an existing cliff"** | **THERE IS NO CLIFF.** Batch AY §2 deleted the doubling STEP and replaced it with a continuous curve: `_bond_mult` is `1 + step × Loyalty`, and it reads ×2 at five only because `BOND_STEP` is 0.20. The constant's own header (*"At 5 Loyalty the curve reads x2 — EXACTLY today's doubling … and it keeps climbing past it"*), `master.html` (*"a CURVE, not a threshold"*) and the glossary (*"it never plateaus"*) all say so. **Nothing is layered on anything.** |
| **"Kindred's half-carry on a swap"** | **TWO CARDS CONFLATED.** **Kindred** (`bm_kindred`, devotion row 8) re-fires the arrival effect at **8 or more** Loyalty. The **half-carry on a swap is SUCCESSION**, a draft card, `SUCCESSION_SHARE = 50`, and it RAISES rather than assigns. Both are read sites and both are in §1's table, but they are different mechanisms with different classes. |
| **"a consumer like Unleash pays out what the curve produces"** | **NO — UNLEASH NEVER TOUCHES THE CURVE.** It reads the raw stack count and pays `0.20 × stacks × Attack` (0.25 on a Perfect). **So a flattening of the PAYOUT leaves Unleash untouched, and only a flattening of the ACCRUAL reaches it.** That distinction is the whole of §1 and it re-shapes §2. |
| **"Unleash … the game's largest single Loyalty payout"** | **PER CAST YES, IN AGGREGATE NO.** Measured: Unleash pays **1.8×** what one Primal Surge blow pays, and Primal Surge pays **2.4× Unleash's total** (4.3× fully talented) because it fires four times as often and spends *every* companion's meter. |
| **"his boss pool is the only one in the game with no damaging card"** (§3) | **WRONG IN BOTH READINGS.** On the FIELD reading **three pools carry no `damage` field, not one** — beastmaster (5), holy (3) and inquisitor/**Devout** (2), all `special`, all `damage 0` and `pressure 0`. On the BEHAVIOUR reading **his pool does not qualify at all**: Primal Surge is his biggest damage payout and Call of the Wild strikes with every absent companion. |
| "Tempo is the axis his kit is thinnest on" (§3) | **TRUE INSIDE HIS KIT, FALSE AGAINST THE GAME.** Across both his pools TEMPO is 1 and every other tag is ≥1, so it is his joint-thinnest. But **eight of the twelve specs carry ZERO TEMPO cards** and only the Swordmaster's three beat his one. A TEMPO re-author makes him the game's second-strongest TEMPO spec, not an average one. |
| "0.35 swaps a trash fight" (§3) | **REPRODUCES: 0.38** at the arm EP took it from (rung 2, untalented, n=1204 trash fights). |
| "0.22 companion deaths a trash fight and 0.39 at a boss" (§4) | **TRASH REPRODUCES EXACTLY (0.22). THE BOSS FIGURE READS 0.48** on n=94 boss fights at the same arm. |
| "EP found … *the depth EJ gave the seven vaulted abilities* does not exist" | **holds** — EP established it and nothing here disturbs it. |

---

## §0 — THE FLATTENING IS RULED AS ITS OWN CHANGE, AND NOTHING IN THIS BATCH TAKES IT

**Nothing was flattened.** §1 measures, §2 presents. No rune was touched, so no passive was
rewritten under cover of an item.

---

## §1 — EVERY SITE THAT READS THE METER

**Derived, not listed.** All **119 `.gd` files** were swept comment-stripped, with quote masking
done in one pass so a `#` inside a string cannot end a line and a quote inside a comment cannot
open one.

```
POPULATION       119 .gd files  (28 game, 91 suites and gates)
DIRECT `.loyalty` 42 sites in the shipped game   (33 reads, 9 WRITES)
                  53 more in the tree's own targets, which are not the game
DERIVED READERS   11 functions/fields, 37 call sites between them
```

### THE THREE CLASSES, AND WHY THE CLASSIFICATION IS THE ANSWER

A flattening moves the three differently, and **the brief's four shapes are all one of two
changes**: flatten the **PAYOUT** (the curve the multiplier readers apply) or flatten the
**ACCRUAL** (`_gain_loyalty` / `_loyalty_cap`, the number every reader sees).

**CLASS 1 — PAYOUT READERS. They multiply by the curve, and a payout flattening is exactly and
only these.**

| site | what it computes |
|---|---|
| `battle.gd:13349` `_bond_step` | `BOND_STEP + 0.01 × (absolute_step + rune_absolute_step)`, doubled by Ancient Pact |
| `battle.gd:13363` `_bond_mult` | `1 + step × Loyalty` — **the boon itself** |
| `battle.gd:21860` `_comp_dmg_mult` | the companion strike step, `0.05 + 0.01 × (wild_communion_step + rune_wild_communion_step)` per stack |
| `battle.gd:20729` `_ghost_hit` | the same step, on a bodiless blow (Call of the Wild, Ghost Pack) |
| `battle.gd:9379` | Canis's +15% per wounded enemy, **scaled by `_bond_mult`** |
| `battle.gd:9437` | Ursus's mitigation, `_bond_mult` **clamped at `BOND_MITIGATION_MAX` 0.75** |
| `battle.gd:7248` | Savage Presence's taunt pull, `_bond_mult` **clamped at 1.0** |
| `battle.gd:13462` `_party_crit_bonus` | Aguila's party crit, `0.10 × _bond_mult` |
| `battle.gd:13444` | **the chip's own text** — a display read, not a payout |

**CLASS 2 — STACK-COUNT READERS. Linear in the raw meter; they never see the curve. A payout
flattening leaves every one of them exactly where it is.**

| site | what it pays |
|---|---|
| `battle.gd:18461` **Unleash** | `0.20 × stacks × Attack` (0.25 Perfect) + 12 flat Break, then **writes the meter to 0** |
| `battle.gd:18943` **Primal Surge** | `0.15 × stacks × Attack` **per living companion**, + a damage buff for the total turns; **zeroes each meter after the blow** (not on a Perfect) |
| `battle.gd:21756` **Last Howl** | `last_howl (3) × the meter the fallen companion held`, accumulated into `last_howl_dmg` |
| `battle.gd:18632` **Bring It Down** | `min(stacks × 2, BRING_IT_DOWN_CAP 20)` percentage points, party-wide — **already hard-capped** |
| `battle.gd:15917` Kill Command | Canis's bite Bleed, `10 + 2 × stacks` |
| `battle.gd:20741` `_ghost_hit`'s pierce | Aguila, `0.20 × stacks`, clamped to 1.0 |
| `battle.gd:13414` / `20545` Ursus's gift | +3% of base max health per stack, at the gain AND at the summon |
| `battle.gd:20502-20514` **Succession** | carries **half** the outgoing meter to the arriving companion, raising never lowering |
| `battle.gd:18859` **Devoted Fury** | +1 Wrath turn per stack — **and it can never fire; see §6** |
| `battle.gd:20358` `_deepest_bond`, `:20460` `_swap_victim` | which companion an ordered action goes to, and which a swap evicts |
| `battle.gd:20375` `_bot_boon_worth` | the bot's swap comparison (it reads the curve too, off the raw meter) |
| `battle.gd:14650` the CY sampler | the reported peak |

**CLASS 3 — THRESHOLD READERS. Only ever "has the meter passed N".** Kindred at **8**
(`battle.gd:3488`); Unleash's door at **1** (`:5974`); Primal Surge's door at **1** (`:5986`); the
bot's Primal Surge preference at **4** (`:4775`). **And three sites WRITE a floor rather than
reading one**: Lone Bond seats at **6** (`:20535`), None Left Behind at **5** (`:20531`), and Wild
Rotation is the one node that hands `_loyalty_cap` a number — **3** (`:13379`).

### THE ANSWER THE CLASSIFICATION GIVES

**A flattening of the PAYOUT reaches 9 sites and no threshold.** Unleash, Primal Surge, Last Howl,
Bring It Down, both companion gifts and Succession all pay exactly what they pay today; Kindred
still fires at 8.

**A flattening of the ACCRUAL reaches all three classes at once**, and a hard cap below 8 makes
**Kindred — a row-8 talent node — unreachable**, while a cap below 6 makes **Lone Bond's own
seating** meaningless and below 5 does the same to **None Left Behind**.

### THE ONE THING THAT HAPPENS AT FIVE

**None Left Behind seats an arriving companion at 5.** That is the only 5 in the system. **The
boon does not step there** — see the corrections table. **The nominal 5 the report prints is a
literal in `battle.CY_METERS`**, whose own header explains it as *"where the Pack Bond curve reads
x2 (`BOND_STEP`)"*. It is a reference point, not a ceiling, and it is the only one of the four CY
denominators that is not a live constant.

---

## §1b — THE LIVE DISTRIBUTION

**Seven arms, `--run 100` (arm G is `--run 60`), `DOD_SIM_ROUTE=balanced`, the standard four specs
(`berserker,cryomancer,inquisitor,beastmaster`).** Every figure below is a live reading with its n
and its standard error. **The sim's Beastmaster wears the DEVOTION lane** (`_target_lane` returns
`tree[0].lane`), which is the lane the curve lives in, so these are the steepest-curve readings the
default harness can produce at each row depth.

**PER-BATTLE DEEPEST SINGLE BOND, over every battle a Beastmaster stood in:**

| arm | rung | rows | mean peak | sd | median | >5 | >8 | >10 | >15 | >20 | deepest | n |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **C** | 2 | 0 | **6.61 ±0.09** | 3.20 | 6 | 59.7 ±1.4 | 25.8 ±1.2 | 12.2 ±0.9 | 1.1 ±0.3 | 0.2 ±0.1 | 27 | 1298 |
| **A** | 2 | 1–3 | **10.13 ±0.11** | 4.96 | 10 | 82.3 ±0.9 | 61.1 ±1.1 | 43.8 ±1.1 | 12.9 ±0.8 | 3.4 ±0.4 | 34 | 1980 |
| **D** | 2 | 1–9 | **18.45 ±0.17** | 8.78 | 18 | 99.7 ±0.1 | 91.5 ±0.5 | 75.3 ±0.8 | 53.9 ±1.0 | 37.7 ±1.0 | **60** | 2600 |
| **B** | 1 | 1–3 | **11.26 ±0.10** | 5.30 | 11 | 86.7 ±0.7 | 68.9 ±0.9 | 53.1 ±1.0 | 19.0 ±0.8 | 5.4 ±0.4 | 34 | 2674 |

**BY ENCOUNTER KIND — the boss is where it runs deepest, at every loadout:**

| arm | trash | elite | boss |
|---|---|---|---|
| C (rows 0, rung 2) | 6.52 (n=535) | 6.29 (n=669) | **9.43** (n=94) |
| A (rows 1–3, rung 2) | 10.02 (n=854) | 9.67 (n=945) | **13.03** (n=181) |
| D (rows 1–9, rung 2) | 19.54 (n=1107) | 17.35 (n=1205) | 18.91 (n=288) |
| B (rows 1–3, rung 1) | 11.26 (n=1187) | 10.51 (n=1192) | **14.32** (n=295) |

### **THE RUNG MAKES THE METER SHALLOWER, WHICH IS THE GOVERNOR WORKING**

Rung 1 reads **11.26** against rung 2's **10.13** on the same three rows — because
`CLAUDE.md`'s uncapped-meter governor table names Loyalty's governor as **the companion's death**,
and rung 2 kills companions **three times as often**: 0.20 a trash fight against 0.06, 0.35 at a
boss against 0.13. **The thing that bounds this meter is not a number, it is an event, and it is
already load-bearing.** What outruns it is the talent tree, not the ladder.

### HOW MUCH OF HIS DAMAGE COMES FROM STACKS ABOVE 5

**Damage-weighted, banked at the site the damage lands, so every multiplier downstream of Loyalty
is already inside the number.**

| arm | rows | family A (the strike multiplier) | Primal Surge (linear) |
|---|---|---|---|
| C | 0 | **4.4%** (7338 blows, mean L 4.57) | — |
| A / E | 1–3 | **18.5% / 19.5%** (9261 / 9736 blows, mean L 6.74 / 6.84) | **26.1%** (324 blows, mean L spent 6.64) |
| D / F | 1–9 | **45.0% / 46.8%** (6144 / 6544 blows, mean L 15.34 / 16.09) | **74.3%** (129 blows, mean L spent 19.43) |
| B | 1–3, rung 1 | **21.0%** (13883 blows, mean L 7.13) | — |

**THE TWO SPENDERS, SEPARATED:**

| arm | Unleash | Primal Surge |
|---|---|---|
| E (rows 1–3) | 76 blows, **212 damage a blow**, 16113 total | 324 blows, 118 a blow, **38386 total** |
| F (rows 1–9) | 22 blows, **490 a blow**, 10789 total | 129 blows, 360 a blow, **46417 total** |
| G (rows 1–3, n=60) | 81 blows, **187 a blow**, 15118 total | 351 blows, 112 a blow, **39201 total** |

**Unleash is the bigger single blow (1.4–1.8×) and Primal Surge is the bigger payout (2.4–4.3× in
total).** Both are Class 2, so **a payout flattening changes neither.**

### **AND THE GAME ALREADY FLATTENS THIS METER IN THREE PLACES**

| bound | where | rows 1–3 | rows 1–9 |
|---|---|---|---|
| **Bring It Down, a hard cap at 20 points** | `BRING_IT_DOWN_CAP` | **binds on 41.5% ±3.6** of casts (mean L 9.66; paid 15.99 of a possible 19.32) | **binds on 94.1% ±5.7** (mean L 25.29; paid **20.00 of a possible 50.59**) |
| **Ursus's mitigation, clamped at 0.75** | `BOND_MITIGATION_MAX` | binds on **0.0–0.2%** (mean 0.187–0.194) | binds on **23.4–26.8%** (mean 0.649–0.711) |
| **Savage Presence's pull, clamped at 1.0** | `battle.gd:7248` | binds on **0.4%** (mean 0.322) | binds on **46.6–49.1%** (mean 1.209–1.262) — **the taunt is a certainty on half its rolls** |

**`master.html` already says of Bring It Down that "the cap binds about where the meter actually
sits". Measured, that is exactly right at rows 1–3 and badly under at rows 1–9.** Flattening above
nominal is not a new idea in this system; it is the third instance of one, and the two clamps exist
**because** the curve over-arrives.

### THE MEASUREMENT'S OWN LIMITS, STATED

- **The instrument reads Unleash's meter as 0 by construction.** `attacker.loyalty[ul_kind] = 0` is
  written *before* `_companion_hit` is called, and the probe samples at the landing site. **The
  printed "family B" share is therefore an overstatement; the Primal Surge half was recovered
  separately** (its handler empties the meter *after* the blow) and is what the tables above quote.
  Both recovered figures agree with `1 − 5/L` at the measured mean L to within 1.5 points.
- **Runes ARE in the sample**, at their natural rate — 3.44 acquired per hero per run, 0.57 spec
  runes worn per hero at run end. **The harness's own header says the opposite and is wrong; see
  §6.** The sim's rune policy prefers a candidate whose `lane` matches the build's target lane, and
  the target lane here is *devotion* — **so the bot preferentially buys the Deep Bond.**
- **The bot is the bot.** Every exclusion `docs/reports/EP.md` §3 enumerates still applies, minus
  the shop row, which was false.
- **24 of 36 lanes have never been measured.** These arms wear the devotion lane only.

---

## §2 — THE CURVE, AS OPTIONS. **AUTHOR NOTHING.**

**Every shape below is evaluated as a counterfactual over the measured histogram**, so what follows
is a loss, not a proposal. `L' = f(L)`; the strike step is priced as `1 + 0.05 L`, a linear spender
as `L`.

### THE LOSS, AT THE FIRST-CLEAR LOADOUT (arm A, rows 1–3, rung 2)

| shape | strike step lost | linear spender lost |
|---|---|---|
| **diminishing, half rate above 5** | 4.9% | 19.5% |
| diminishing, quarter rate above 5 | 7.3% | 29.3% |
| **soft cap, asymptote 10** | 5.5% | 22.1% |
| soft cap, asymptote 15 | 4.0% | 15.9% |
| **hard cap at 10 (×2 nominal)** | 2.8% | 11.3% |
| hard cap at 15 (×3 nominal) | 0.6% | 2.4% |
| **hard cap at 5 (AT nominal)** | 9.7% | 39.0% |

### THE SAME SHAPES FULLY TALENTED (arm D, rows 1–9, rung 2)

| shape | strike step lost | linear spender lost |
|---|---|---|
| diminishing, half rate above 5 | 17.6% | 40.2% |
| soft cap, asymptote 10 | 21.4% | 48.7% |
| soft cap, asymptote 15 | 16.8% | 38.4% |
| hard cap at 10 | 16.1% | 36.9% |
| hard cap at 15 | 8.6% | 19.6% |
| **hard cap at 5** | **29.7%** | **68.1%** |

**Untalented (arm C) every one of them is under 4% on the strike step.** **So the same curve is a
trim at the bottom of the tree and an amputation at the top, and the ratio between the two is
roughly six to one.** A shape chosen against the 21.2 figure is a shape chosen against the
fully-talented reading; the player who has just cleared rung 1 pays a fifth of it.

### WHAT UNLEASH PAYS AFTER

Priced on the same per-battle peak distribution — the honest proxy for what the meter reads when a
player chooses to spend it — at **20% of Attack a stack**:

| shape | rows 1–3 | rows 1–9 |
|---|---|---|
| **today** | **203% of Attack** | **369%** |
| diminishing, half rate | 149% (−26.6%) | 234% (−36.5%) |
| soft cap, asymptote 10 | 137% (−32.5%) | 165% (−55.2%) |
| hard cap at 10 | 162% (−19.8%) | 193% (−47.7%) |
| hard cap at 15 | 192% (−5.1%) | 264% (−28.5%) |
| **hard cap at 5** | **95% (−53.2%)** | **100% (−73.0%)** |

**AND THE ROW THAT MATTERS MOST: if the flattening is applied to the PAYOUT ONLY, every one of
those numbers stays at 203% and 369%.** Unleash reads the stack count. So does Primal Surge, Last
Howl and Bring It Down. **The choice between "flatten the payout" and "flatten the accrual" is
worth more than the choice of shape.**

### **THE FIFTH SHAPE, AND IT IS THE GAME'S OWN ANSWER TO THIS PROBLEM ON THE SIBLING METER**

**Focus is uncapped, over-arrives (128.2 against a nominal 100), and its governor is neither a cap
nor a taper — it is a CONVERSION.** `focus_crit_chance()` is `min(Focus, 100) × 0.005` and
`focus_crit_mult()` is `max(Focus − 100, 0) × 0.005`: **the rate never changes, the KIND does.**
Below the split point the meter buys crit chance (which saturates at +50%); above it, crit
multiplier. **Nothing is lost, nothing is capped, and the meter stops compounding on one axis.**

- **Cost.** One new read site and a split constant, plus whatever the second axis is. Larger than
  a cap, smaller than a re-author.
- **What it costs the player at the measured distribution: nothing.** A conversion is the only
  shape in this section whose "loss" column is zero.
- **What it costs the designer: naming the second thing Loyalty buys.** That is content, and this
  file does not invent it.
- **The precedent is exact**, and Deep Focus's shape shows how a node interacts with it: it moves
  the *split point* rather than raising a ceiling, which is what re-specced Absolute Devotion would
  do to a flattened curve.

### **WHAT BREAKS, ENUMERATED FROM §1's TABLE**

- **A HARD CAP AT NOMINAL MAKES A ROW-8 NODE UNREACHABLE.** Kindred fires at 8. **Any accrual cap
  below 8 deletes it** — and Wild Rotation's cap of 3 already does, which is a pre-existing tension
  nobody has recorded: a Beastmaster holding Wild Rotation can never satisfy Kindred.
- **A CAP BELOW 6 UNSEATS LONE BOND** (it seats its one companion at 6) and **a cap below 5 unseats
  None Left Behind** (arriving companions enter at 5). Both would then write a value the cap
  immediately clips.
- **THE TWO EXISTING CLAMPS BECOME DEAD OR NEARLY SO.** At a hard cap of 10 the Ursus mitigation
  reaches `0.10 × (1 + 0.20 × 10) = 0.30` against a clamp of 0.75, and the taunt pull reaches 0.45
  against 1.0 — **both clamps would then be unreachable at every talent depth**, which by AR §4's
  rule makes them dead constants rather than governors.
- **BRING IT DOWN'S OWN CAP WOULD BE DOUBLY BOUND.** It is capped at 20 points = 10 stacks. An
  accrual cap at 10 makes its own cap exactly reachable and never binding; a cap at 5 makes half of
  the card's stated range unreachable and its "up to +20%" text false.
- **NOTHING ELSE IN THE GAME READS THIS METER.** The 42 sites are the whole population.

### WHAT A FLATTENING WOULD OWE IN TEXT, COUNTED

The meter's uncappedness is **stated as a promise in nine places** and every one would have to move:
`battle.STATUS_INFO["loyalty"]` (*"with NO CEILING"*), the computed chip line in
`_stamp_loyalty_chip`, `Classes` `passive_desc` (*"NO MAXIMUM … x2 at five"*), `master.html`'s
Beastmaster block (*"a CURVE, not a threshold … ×5 at twenty, and it never stops climbing"*), its
Loyalty chip row, its Unleash and Bring It Down rows, and the glossary's `res_loyalty` (*"it never
plateaus"*) and `pack_bond` entries. **Plus Absolute Devotion's and Ancient Pact's node text, and
the three Beastmaster rune descriptions.** `test_batch_az` pins *"no ceiling"* and *"NO CEILING"*
against `master.html` today.

**AND THE STANDING DECISION A FLATTENING REVERSES IS WRITTEN DOWN.** `CLAUDE.md`'s uncapped-meter
governor table records six ratcheting accumulators, every governor verified at its site, and it
names **exactly one that is a CEILING rather than a COST** — Overburn's — *"and that is deliberate:
the cost was the fault BS removed."* **Four of §2's shapes would make Loyalty the second.** That is
the designer's to take; it is recorded here so it is taken knowingly.

---

## §3 — THE TURNING PACK, RE-AUTHORED. **OPTIONS ONLY; NOTHING AUTHORED.**

**Independent of §2's curve: both its clauses are Class 2 or outside the meter entirely.**

### **THE FACT THAT SHOULD DECIDE IT, AND IT IS NEW: HALF THE RUNE IS ALREADY WORTH ZERO**

`rune_quick_whistle_ranks` is read once, at `battle.gd:20520`:

```gdscript
hunter.cooldowns["Swap Companion"] = maxi(
    SWAP_COOLDOWN - hunter.quick_whistle_ranks
        - hunter.rune_quick_whistle_ranks, 0)
```

`SWAP_COOLDOWN` is **3** and **Quick Whistle shaves 3**. **So a Beastmaster holding Quick Whistle
is already at the floor and the rune's +1 pays exactly nothing** — and Quick Whistle is **pack row
1**, inside the three rows a single rung-1 clear opens. **Wild Rotation skips the block entirely**
(`if was_swap and hunter.wild_rotation == 0`), so it pays nothing there either. And the line only
runs on a **swap** — replacing a living companion at capacity — never on a first summon.

Measured in the sim's devotion build (which holds neither node) the extra turn bites on **100.0%
of 256 swaps**, mean resulting cooldown 2.90. **The arithmetic and the measurement are not in
conflict: the clause is fully live for a devotion or handler build and structurally dead for the
pack build the rune is named after.**

### THE BEHAVIOUR IT IS PRICED AGAINST, AND IT FALLS AS THE BUILD DEEPENS

| arm | swaps / trash fight | swaps / boss fight |
|---|---|---|
| C — rung 2, untalented | **0.38** (n=1204) | 0.68 (n=94) |
| A — rung 2, rows 1–3 | **0.21** (n=1799) | 0.27 (n=181) |
| B — rung 1, rows 1–3 | 0.20 (n=2379) | 0.40 (n=295) |
| D — rung 2, rows 1–9 | **0.02** (n=2312) | 0.02 (n=288) |

**The verb the rune cheapens is one the game does less of the better the bond gets** — because
`_swap_victim` evicts the shallower bond, `_bot_boon_worth` prices an established companion as
expensive to give up, and Lone Bond forbids swapping outright. **A re-author that makes swapping
worth doing is worth more than one that makes it cheaper**, exactly as the brief says, and the
measurement is why.

### AND ITS SECOND CLAUSE IS SMALLER THAN IT LOOKS

`rune_momentum_ranks` 8 is additive into Feral Momentum's multiplier, which reads
`kinds_summoned.size()` — **measured at a mean of 1.235 different companions on the ledger at a
companion blow, with 79.1% of blows at exactly one and 2.6% at three.** So **+8% a kind is worth
about +9.9%**, and the node's +25% is worth about +30.9%, not +75%. **Both the Turning Pack and the
Shared Wild carry this clause and both are priced against 1.235, not 3.**

### THE OPTIONS, PRICED

**Every one of these is a JSON edit unless it is marked otherwise** — `runes.gd`'s own header:
*"Adding a rune is a JSON edit; there is NO new payload machinery here."* A `stat` payload needs an
existing `rune_*` field and a read site; a new field needs both authored, plus a line in
`Runes.STAT_INT_KEYS` if it is an int not ending `_ranks`.

| # | shape | build cost | what it answers | what it costs |
|---|---|---|---|---|
| **1** | **Pay the swap in BREAK.** The arriving companion's first blow carries flat Break damage. | **New field + one read site** at `_do_summon`'s arrival, or at `_companion_hit`'s `pr` for the arriving companion's next strike. | Both concentration findings at once: it is Break the pool has none of *by field*, and it makes the swap worth taking. | Break is the axis §2's rejected option B showed is unevenly held — but this is an ITEM, not a rung, so the standing rule does not bind it. |
| **2** | **Pay the swap in a DAMAGE WINDOW.** The arriving companion strikes harder for N turns. | **New field + one read site** in `_comp_dmg_mult` or as a status. | Tempo, and it stacks with the arrival effects the pack lane already fires. | It is a fourth multiplier on companion damage, which is the number three of his runes and four of his nodes already push. |
| **3** | **Pay the swap in LOYALTY.** The arriving companion enters holding N. | **Zero new machinery** — `no_beast_left_loyalty`'s read site at `:20531` is the exact shape, and Succession is the draft-card precedent. | Makes rotation stop costing depth, which is the real reason the bot stops swapping. | **It is the one option §2 can invalidate**: it writes into the meter, so an accrual flattening prices it and a payout flattening does not. |
| **4** | **Remove the swap's TURN cost instead of its cooldown.** | `free_swap` exists (Instinctive Rotation, pack row 8) and `_swapped_free` is read once. **Zero new machinery.** | The measured cost of a swap is a turn, not a cooldown — BJ measured 0.05 swaps a battle before the node existed. | It duplicates a row-8 node outright, which is the charter's own complaint about these three runes restated. |
| **5** | **Keep the cooldown clause and fix its collision** by making the rune shave the FLOOR rather than the term. | One read-site change. | Nothing new; it only stops half the rune being worth zero. | It is a repair, not a re-author, and the brief asked for a re-author. |

**KEEPING THE OPPOSITION TO DEEP BOND EXPLICIT.** Deep Bond pays for *holding one companion*; the
Turning Pack must pay for *turning them over*. **Options 1, 2 and 4 are genuinely opposite** — none
of them reads the meter, so a player choosing between the two runes is choosing between depth and
tempo. **Option 3 is NOT opposite**: paying the swap in Loyalty makes rotation a way to build the
very meter Deep Bond deepens, and the pair collapses into one idea from the other direction.

---

## §4 — THE SHARED WILD, RE-AUTHORED. **OPTIONS ONLY; NOTHING AUTHORED.**

**The safest of the three, and the measurement supports keeping it closest to as it is.**

### THE EVENT IS REAL AND ITS SIZE IS NOW MEASURED

| arm | companion deaths / trash fight | / boss fight |
|---|---|---|
| C — rung 2, untalented | **0.22** | **0.48** |
| A — rung 2, rows 1–3 | **0.20** | **0.35** |
| G — rung 2, rows 1–3 (n=60) | 0.22 | 0.41 |
| B — **rung 1**, rows 1–3 | **0.06** | **0.13** |
| D — rung 2, rows 1–9 | 0.05 | 0.08 |

**The event is three times commoner at rung 2 than at rung 1 on the same loadout, and it nearly
vanishes at the top of the tree.** That is the same governor §1b names from the other side: a
companion death is what bounds the meter, so a rune that prevents deaths is a rune that raises the
meter's ceiling indirectly — **which is worth saying out loud in a batch about flattening it.**

### THE CLAUSE IT OWNS

`rune_companion_hp_pct` is read **once**, at `battle.gd:20542`, purely additive into the summon's
`base_hp`. **Unlike the Turning Pack's first clause it can never be worth nothing** — no node
drives it to a floor, and `companion_hp_pct` (The Wild Within, handler row 2, +0.40) adds rather
than saturates. Its two other clauses are the other two runes' (`rune_wild_communion_step` 1.5 and
`rune_momentum_ranks` 8, the latter worth ~+9.9% at the measured 1.235 kinds).

### THE OPTIONS, PRICED

| # | shape | build cost | what it answers | what it costs |
|---|---|---|---|---|
| **1** | **Keep all three clauses and re-price nothing.** | **Zero.** | Nothing — but it is the only option that does not spend the splash. | The charter's complaint stands: three unrelated numbers in a bundle. |
| **2** | **Deepen the health clause alone** (0.05 → a larger share) and drop the other two. | **Zero — a JSON edit.** | Companion durability, the one Beastmaster number no other rune touches, against a measured 0.20–0.22 deaths a trash fight. | **This is the splash's death and it should be priced as one** — see below. |
| **3** | **Pay on the DEATH rather than before it**: a share of the fallen companion's meter survives, or the next summon costs nothing. | `steadfast_bond` (`:21766`) and `no_beast_left_loyalty` (`:20531`) are both existing read sites. **Zero new machinery.** | It acts on the measured event directly rather than on the chance of it. | It duplicates two devotion/pack nodes, which is the charter's complaint again. |
| **4** | **Heal or shield the companion in flight** rather than raising its bar. | New field + a read site; `spirit_heal` and `bloodbond_cb` are the shapes. | The same event, on a different axis from The Wild Within, so the rune and the node stop being the same idea. | The largest build of the four, and Ancient Pact makes a companion unhealable by ANY source — so the clause is dead for exactly the build with the deepest bond. |

### **THE COST EP NAMED, PRICED**

**It is the only splash of the three** — no `lane` field, against the Deep Bond's *devotion* and the
Turning Pack's *pack*. **48 of the 65 authored runes were written to the lane rule** (36 lane runes,
12 splashes), whose point was that a rune is *"worth more to a hero whose points went elsewhere"*.
**The charter severed that, and the splashes lost most: with no lanes to reach across, "a little of
every bond" has nothing to reach.** Re-authoring it as one idea makes it **a lane rune wearing a
splash's name** — and the sim's own rune policy makes that concrete: `_pick_rune_candidate` prefers
a candidate whose `lane` matches the build's target lane, so **a splash is already the last thing
the bot reaches for.** That is a real loss and it is the designer's to weigh before choosing option
2, 3 or 4.

---

## §5 — THE DEEP BOND WAITS

**Not re-authored, as the brief directs.** Its axis is DEPTH and depth is measured against a curve
nobody has chosen.

**What this batch adds to that ruling: DEPTH and the flattening are the same decision.** Both of
its clauses — `rune_wild_communion_step` 1.5 and `rune_absolute_step` 3.0 — are **Class 1 payout
readers**, and they sit on the two steepest terms in the system. `rune_absolute_step` enters
`_bond_step`, which **Ancient Pact then doubles**, so a payout flattening reaches this rune twice
over and through a term another node multiplies. **Authoring it against an undecided meter would be
authoring twice, and the brief is right.**

---

## §6 — FOUR CORRECTIONS TO THE RECORD

### (1) `master.html` HAS CARRIED A RULE BATCH BB REVERTED — **CORRECTED HERE**

Batch BB §1 corrected the swap victim from *"replaces the OLDER of the two"* to the Loyalty rule,
in **both in-game tooltips and The Pack's talent text**, and `test_batch_bb` pins it — *over
`battle.gd`*. **`master.html` was never swept and has said OLDER ever since, contradicting its own
capstone row 330 lines below and both in-game surfaces.** That is `CLAUDE.md`'s EH §2 rule firing
again: *when a claim of fact is corrected, sweep for every copy of it — the document is one surface
of three.* **Corrected toward the code**, together with the shared cooldown: the document said
**2 turns**, `SWAP_COOLDOWN` is **3**.

### (2) THE SAME WRONG **2** IS STILL IN THE GAME'S OWN TEXT — **REPORTED, NOT FIXED**

- `battle.gd:6397` — the swap picker card's own description: *"Shared cooldown: 2 turns."*
- `battle.gd:5305` — the group-button tooltip: *"shared 2-turn cooldown"*
- `battle.gd:5296` — a source comment: *"(10 Mana, shared 2cd)"*
- `battle.gd:16296` — a comment that gets it **right**: *"the shared 3-turn Swap cooldown"*

**The card a player reads says 2 and the constant says 3.** Both strings are the same width as the
correction, so the 44-character ceiling is not in the way. **It is a source edit this brief did not
ask for, and it lands squarely on the mechanism §3 is about.**

### (3) THE RUN REPORT'S SHOP CONFOUNDER IS A VACUOUS READING THAT PRINTS LIKE A REAL ONE

`run_sim.gd:1136` reads `type_taken.get("shop", 0)` and `:1137` reads `type_offered.get("shop", 0)`.
**The node type is `"merchant"`** — `ROUTE_ORDER` and the type loop at `:1443` both say so — so
**`"shop"` is a key nothing ever writes and the line prints a structural zero**: *"it takes 0.0 of
0.0 shops offered per run."* The same report, four blocks lower and off the correct key, prints
**Merchants met 4.57/run walked + 2.73/run bought, Shop offered 17.45 bought 6.98, runes acquired
3.44 per hero per run.**

**Its prose is reversed as well.** It claims *"No route policy in this harness ranks a shop above a
fight (greedy/default/cautious/elites all put combat first)"* — and `ROUTE_ORDER` puts `fight`
**LAST in all three policies**, with `blacksmith` and `merchant` first and second in two of them.
The comment twenty lines above says so itself: *"balanced: trade nodes first"*.

**`docs/reports/EP.md` §3 quoted the false zero into its table of what the bot cannot do**
(*"the fight-first route means it reaches 0.0 of 0.0 shops on this party"*). **It is the exact
shape `docs/state.md` already records — a wrong key skipping every row and reporting a clean
zero — arriving through a report instead of a check.** Nothing was repaired: fixing an instrument
mid-measurement describes an instrument that produced none of the numbers in the batch.

### (4) ONE LOYALTY READ SITE CAN NEVER FIRE

`unit.devoted_fury` — *"Bestial Wrath: +N turns per Loyalty stack"* — is read at `battle.gd:18858`
and **written by nothing**. Batch DO re-authored `bm_devoted_fury` onto Kill Command's cost and
cooldown, and `test_batch_ay:258` asserts the counter absent: *"...and writes no `devoted_fury`
counter at all now"*. **A read-only-zero field with a live read site**, in the family
`icy_resolve_ranks` is already recorded in. **Reported, not deleted** — deleting a read site is a
mechanic deletion.

### AND ONE SMALLER THING, FOUND WHILE READING THE SAME MACHINERY

`battle.STATUS_INFO["bloodbond"]`'s registry description says the hunter takes **HALF** of the
refused blow. The card says **a QUARTER**, `master.html` says a quarter, the cast writes
`bb_pct = 25` into a computed chip line, and `_recast_writes` proposes `power: 25`. **The registry
string has exactly one consumer — the cast at `:20189` — and that call passes its own text
instead**, so the wrong number is unreachable today. **It is a live trap rather than a live
defect**: the next batch that adds a second `add_status("bloodbond", …)` without a custom
description ships HALF.

---

## §7 — WHAT MOVED, AND WHAT DELIBERATELY DID NOT

| file | what |
|---|---|
| `docs/master.html` | §6(1)'s two corrections, and the stamp |
| `docs/changelog.html` | this batch's entry |
| `docs/state.md` | rewritten |
| `docs/reports/EQ.md` | this file |

**NOT DONE, STATED SO THE BATCH IS NOT READ AS CLEAN:**

- **No curve was chosen, nothing was flattened, no magnitude moved.** §2 is options.
- **Nothing authored for the Turning Pack or the Shared Wild, and the Deep Bond was not touched.**
- **No `.gd`, `.json` or `.sh` byte moved.** The three in-game strings §6(2) names, the vacuous
  confounder §6(3) names, `devoted_fury` and the Bloodbond registry string are all **reported and
  left**.
- **No gate.** A gate encodes a ruling and nothing here is ruled.
- **No `CLAUDE.md` rule**, for the same reason.
- **No baseline row.** The batch adds no target and moves no assertion.
- **The Wild Rotation / Kindred tension is reported, not resolved** — a cap of 3 makes a threshold
  of 8 unreachable, and that is pre-existing.
- **Nothing was measured on a non-devotion Beastmaster lane**, so the Turning Pack's own lane is
  measured only through arithmetic.
- **Nothing was measured at rung 3.**
