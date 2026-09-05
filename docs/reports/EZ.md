# BATCH EZ — THE FIRST TWENTY-ONE RUNES

**Twenty-one runes across four specs, authored with the designer and transcribed rather than
proposed. The pool has been empty since ET §1 retired all 53; these are the first under the new
charter.** Price is **100g flat, every rune**; scope is **spec only** for all twenty-one. The
machinery ES §4 built and nothing read is finally read: **eight of the twenty-one are gated on
§0's two loadout conditions.**

---

## THE BRIEF'S PREMISES, RE-DERIVED

**The brief said to verify every premise. Most reproduce exactly. Six do not, and three of those
are load-bearing enough that the rune they describe could not have been built as transcribed.**

| the brief's claim | what the tree says |
|---|---|
| *"CONFIRM EY LANDED BEFORE PRICING IT. If `SC_PROFILE_DEFAULT.sweep_time` still reads 0.72, stop"* | **IT LANDED.** `battle.gd:57` reads `"sweep_time": 1.00`. Long Draw is priced against 1.00s. |
| *"`BOND_CONVERT` is 8 and `_bond_convert()` is the one place it is decided, built that way so a rune moves one line. Confirm it still is."* | **CONFIRMED, AND THE RUNE MOVED EXACTLY ONE LINE.** `const BOND_CONVERT := 8`; `_bond_convert(_hunter)` took the hunter and discarded it. The Long Leash is `BOND_CONVERT + hunter.rune_long_leash`, and the underscore came off the parameter. |
| *"Second Whistle names three abilities in the protected core, so every Beastmaster can roll it"* | **CONFIRMED.** `PROTECTED_CORES["beastmaster"].enablers` is exactly `Summon Ursus / Summon Canis / Summon Aguila`. |
| *"A hero drafts 4 slots at zone 1 and 7 by the end"* | **CONFIRMED FOR ALL FOUR SPECS IN THIS BATCH.** `ABILITY_SLOTS_BY_BOSS` is `[7, 8, 9, 10]` against `core_slots` of 3 for the Occultist, Warden, Sharpshooter and Beastmaster — 4 earned to 7. (**It is 3-to-6 for the Holy Cleric, whose core is 4**; no rune here is his.) |
| *"the counted set and the swap lever are the same set"* | **CONFIRMED, AND IT IS `equipped_ability_names` RATHER THAN `loadout_ability_names`.** `equip_earned_ability` / `unequip_earned_ability` write exactly that list; the second function is the core PLUS it. §0a. |
| **"Both count the PRIMARY tag only"** | **THIS CONTRADICTS ES §4, WHICH RULED THE OPPOSITE, AND BOTH RULINGS STAND.** `Classes.tag_count` counts BOTH tags by decision. Primary-only counterparts were added rather than the census being changed — §0c. |
| **"Hex of Ruin strikes two enemies instead of one"** | **FALSE IN BOTH HALVES: it already strikes THREE** (`choose_three: true`, and `_resolve_ability` builds a three-element `strike_targets`). As transcribed the rune is a NERF. §1a. |
| **"Wide Rite — every debuff he applies also marks 1 Ruin"** | **WRATH OF THE OLD GODS ALREADY MARKS 2 ON EVERY DEBUFF HE APPLIES.** The rune reads +1 rather than turning something on. §1c. |
| **"Shieldwall covers a second ally"** | **SHIELDWALL COVERS NO ALLY.** Batch AB made it a SELF stance; the thing that reaches an ally is the Bulwark Line node. §2a. |
| **"Each press in its sequence is 15% narrower than the one before it"** | **THAT IS `SS_SEQ_TAPER` = 0.85 AND HAS SHIPPED SINCE CS.** Read literally the clause describes the status quo and buys nothing. The rune's real cost is elsewhere and is `SS_SEQ_OPEN`. §3c. |
| **"Ambush — Called Volley … does not clear it"** | **ALREADY TRUE, TWICE OVER.** `_focus_safe` names Called Volley by hand, and every AoE has been Focus-safe since AZ. The card's own text already says so. §3d. |
| *"the companion inherits EVERYTHING — the full hero multiplier block, not a named list"* | **WHAT SHIPPED IS A NAMED LIST, AND THE REASON IS STRUCTURAL RATHER THAN A JUDGEMENT CALL.** §4b. |

---

## §0 — THE TWO CONDITIONS, AND THE THREE THINGS THAT HAD TO BE DECIDED TO BUILD THEM

**§0 of the brief is four sentences and every one of them settles something. Three needed a
decision the brief did not make, and all three are recorded here rather than in a comment.**

### **§0a — THE COUNTED SET, WHICH IS THE ONE A STATIC CHECK CANNOT SEE**

**Three sets are candidates and all three produce a sensible number.** The hero's POOL
(`earned_ability_names` — everything drafted, nothing ever leaves), his BAR
(`loadout_ability_names` — the protected core plus what he carries), and the DRAFTED HALF he is
carrying (`equipped_ability_names`).

**The brief rules the third and the code reads the third**, and the reason the other two are wrong
is measured rather than argued:

- **The POOL turns a threshold on once, late, and never off** — a flat increment with a delay,
  wearing a decision's clothes. It is also not the swap lever's set: `equip_earned_ability` and
  `unequip_earned_ability` write `bm_equipped`, and nothing writes the pool but a draft.
- **The BAR is the one that reads right and is worse.** *The Occultist's protected core alone
  carries the DEBUFF threshold* — Shadowrend and Hex of Ruin are both DEBUFF primaries against a
  three-slot core — so **Deepening Hex would be on from the first fight and no bench could turn it
  off.** That is exactly the constraint `check_es` §4 has printed every battery run since ES and
  the first time anything has been authored against it. `check_ez` §2 builds a member where the
  three sets give three different answers and asserts which one the condition reads.

### **§0b — AN EMPTY DRAFTED LIST MEETS BOTH CONDITIONS, VACUOUSLY. IMPLEMENTED LITERALLY, REPORTED, NOT PATCHED.**

Nothing carries the tag, so nothing fails to be half of it (`0 * 2 >= 0`); no tag exists, so none
exceeds a third (`0 * 3 <= 0`). **It is the literal reading of both rules and it is reachable** —
a player can bench everything and switch on a THRESHOLD rune and a BREADTH rune at the same time,
which is the one state the two shapes were designed never to share.

**A batch does not alter an authored condition**, so it ships as written and is named. It is the
sharpest thing in the batch and the cheapest to change: one clause, in one function. `check_ez` §1
asserts it in the direction it is true, so the day it is changed the gate says so.

### **§0c — PRIMARY-ONLY CONTRADICTS ES §4, AND BOTH RULINGS STAND**

**ES §4 ruled that a census counts BOTH tags on a card**, deliberately and with its reason in the
source: a card that Breaks and DEBUFFs is a member of both populations, and counting the primary
alone would make 61 of the corpus's second tags decorative. **EZ §0 rules that the two conditions
count the PRIMARY only.**

**They are not in conflict because they answer different questions, and the difference is not
cosmetic.** Under the both-tags count the per-tag numbers sum to MORE than the card count, so:

- a tag could **exceed a third while every tag did**, and
- "at least half carry the tag" could be met by **two different tags at once on the same three
  cards**.

Both conditions are fractions of one denominator and can only be read against a denominator the
parts add up to. **`Classes.primary_tag_count` / `primary_tag_census` / `primary_tag_peak` were
added beside the originals rather than replacing them**, and `check_ez` §1 proves they are
different numbers on a card whose SECOND tag is DEBUFF rather than asserting it.

### **§0d — WHERE IT IS READ, AND THE ONE DOOR**

`Talents.condition_met` gains two keys and **names no tag word**: it hands the whole `cond` dict to
`Runes.loadout_condition_met`. That is a constraint rather than a style — `check_ek` §3 asserts
that the set of `.gd` files naming the tag surface is EXACTLY four, and the rune layer's vocabulary
belongs in the rune layer (ES §4's own rule). §6b covers what that did to the gate.

### **§0e — AND THE STATE IS VISIBLE ON BOTH SCREENS**

The hero sheet (`party_screen._draw_detail`) and the loadout panel
(`map_screen._open_loadout_panel`) each carry a `RUNE CONDITIONS` line beside the existing census —
`4 of 7 — DEBUFF`, with a tick where the condition is met, and `peak 2 of 7 — BREADTH`. Both are
rebuilt from the live member on every draw, so **there is no cached count to go stale**, and
`_toggle_loadout` re-opens the panel after every bench. `check_ez` §3 drives the real bench and
carry doors and re-reads after each.

---

## §1 — THE OCCULTIST'S FIVE, AND TWO PREMISES THAT DID NOT SURVIVE

| rune | shape | where it lands |
|---|---|---|
| **Deepening Hex** | PASSIVE + THRESHOLD (DEBUFF) | `_ruin_threshold()` |
| **Standing Mark** | PASSIVE | the leech cap at the one `minf` |
| **Split Tongue** | ABILITY | `Hex of Ruin.aoe`, plus the mark at the Wrath site |
| **Wide Rite** | PASSIVE + BREADTH | `_old_gods_mark()` |
| **Open Wound** | ABILITY + TRADEOFF | the Wrath site, and the enemy turn-start tick |

### **§1a — HEX OF RUIN ALREADY STRIKES THREE, SO SPLIT TONGUE AS TRANSCRIBED IS A NERF**

`Ability.choose_three` has existed since Shrapnel Charge and **Hex of Ruin carries it**:
`{"display_name": "Hex of Ruin", … "choose_three": true}`. `_resolve_ability` builds
`strike_targets = [target, second, third]` for it. **"Strikes two enemies instead of one" is wrong
about the base and would REMOVE a target if built literally.**

**What shipped is the widening the name and the direction call for**: `{"ability": "Hex of Ruin",
"set": {"aoe": true}}` — the curse is spoken to the whole line — **at 1 Ruin a target instead of
2**, which is the "reduced Ruin per target" half of the card. **No magnitude was invented**: the
base mark is `_old_gods_mark()`'s 2 and 1 is the only integer below it that is not nothing.

> **AND THE ONE THING THIS BATCH DID NOT PRICE IS NAMED: the card's DAMAGE is unchanged at 20% of
> Attack, and it now lands on the whole line rather than on three chosen enemies.** At the
> four-enemy warbands the fixture builds that is the same three targets plus one; at the six-plus
> rosters `compose` floors elite and mini-boss lineups at, it is more. **A damage reduction to pay
> for that is a magnitude and is the designer's**, and it is flagged rather than chosen.

### **§1b — DEEPENING HEX IS A `mini`, NOT AN ASSIGNMENT, AND THE DIFFERENCE IS THE CAPSTONE**

`_ruin_threshold()` already had one override: **Avatar of Ruin installs 5**, in `avatar_ruin`, which
is the gate and the magnitude in one field. A rune that ASSIGNED 8 would push an Occultist holding
the capstone from detonating every 5th stack back to every 8th — **a rune sold as deepening the hex
making it shallower.** It takes the minimum. `check_ez` §5 asserts both directions.

### **§1c — WRATH OF THE OLD GODS ALREADY MARKS TWO, SO WIDE RITE IS +1**

The passive's mark is `OLD_GODS_MARK := 2` (raised from 1 at AY §8, because AX measured **0.00
detonations a battle in trash across 519 battles** — generation was the problem, not the
threshold). So *"every debuff he applies also marks 1 Ruin"* describes something already shipped at
twice the rate. **The rune is built as +1 to that mark, in `_old_gods_mark()`** — `whispers_step`'s
exact shape, so it lands at all five quoting sites or at none.

### **§1d — OPEN WOUND'S DECAY, AND WHERE IT SITS**

`Ruin has never decayed and never cleared` (AX §1). The rune takes one stack a turn from every
bearer, at the enemy turn-start tick **beside Entropy's drip and ABOVE the detonation check** — a
decay below the check would let a mark detonate on stacks the rune had already taken. **The primer
is a STATUS and is deliberately not disarmed**: a mark that reached a threshold has been noticed,
and un-arming it would make the rune silently DELETE detonations rather than delay them.

**The designer's own reading is the arithmetic**: detonation is a MULTIPLE, so a decay of 1 against
30 stacks delays the next threshold by half a turn and against 3 it takes a third of the mark.
**It fights Deepening Hex on purpose** — faster detonation wants depth, decay works against it.

---

## §2 — THE WARDEN'S FIVE

| rune | shape | where it lands |
|---|---|---|
| **Standing Wall** | PASSIVE | the plating reset, inside the Anvil `else` |
| **Bracing Line** | PASSIVE + THRESHOLD (DEFENSE) | the damage-taken block, at `BRACING_LINE_LEVEL` |
| **Split Shield** | ABILITY | `_recast_writes`' `shield_block` arm |
| **Long Watch** | PASSIVE + BREADTH | beside the hero strike's `take_hit` |
| **Bared Plate** | STAT + TRADEOFF | `rune_bd_bonus` (existing) + the block roll and `_live_block_chance` |

### **§2a — SHIELDWALL COVERS NO ALLY, SO THE SPLIT SHIELD IS BUILT AS ITS NAME**

**Batch AB made Shieldwall a SELF stance** — *"he guarantees the line and gambles for himself"* —
and `_recast_writes`' `shield_block` arm returns the `shieldwall` status only when `t == u`. The
thing that reaches an ally is the **Bulwark Line** node, through `bulwark_ally_block`.

The rune **splits the wall**: half its Block for him, and that same half for the ally he sets it in
front of. **Half is forced rather than chosen** — it is `SHIELDWALL_BLOCK / 2`, derived from the
constant the card already advertises, so it cannot drift if that number moves. **And it does not
delete Bulwark Line**: a Warden holding the node keeps `maxi(bulwark_ally_block, SHIELDWALL_BLOCK / 2)`
on the ally, so the rune cannot make a talent he has already bought worse.

### **§2b — STANDING WALL SITS INSIDE THE ANVIL BRANCH, AND RECOMPENSE IS PAID ON WHAT WAS LOST**

Two things already read the plating reset. **Anvil refuses it entirely** and **Recompense is PAID
by it** (a reset from +32% pays 32 Rage). The rune is placed **inside the Anvil `else`**, so a
Warden holding both gets the stronger effect rather than being paid twice — the ordering does the
work, exactly as the two cards' own texts already say. And **`rc_points` is recomputed after the
halving**, so a half reset from +32% pays 16 Rage rather than 32: paying the full meter for half a
loss would make the pair strictly better than either.

### **§2c — BARED PLATE REFUSES THE ROLL RATHER THAN ZEROING A FIELD**

The block roll is assembled from four sources — base `block_chance`, the passive's 15%, its climb,
and both stances — and clamped. **Zeroing `block_chance` would leave Shieldwall still buying blocks
off a Warden whose card says he has none.** The rune refuses the roll's first two slices and
`_live_block_chance` returns 0 for him. **The Covering Guard slice is deliberately left standing**:
that third slice is ANOTHER Warden's Block chance doing its job on this body, and it is not his.

---

## §3 — THE SHARPSHOOTER'S FIVE, AND THE ONE RUNE THAT TOUCHES A SKILL CHECK

| rune | shape | where it lands |
|---|---|---|
| **Keen Focus** | PASSIVE | the switch branch of `_sharpshooter_focus` |
| **Heavy Bolts** | PASSIVE + THRESHOLD (MARK) | `unit.focus_convert()` |
| **Ambush** | ABILITY | the strike loop, at the meter's own rate |
| **Wide Watch** | PASSIVE + BREADTH | the kill branch's `mini(…, 50)` |
| **Long Draw** | ABILITY + TRADEOFF | `_sequence_presses` and the `SS_SEQ_OPEN` index |

### **§3a — HEAVY BOLTS MOVES THE POINT AND THE RATE IS ASSERTED UNMOVED**

`focus_convert()` is `maxi(FOCUS_CONVERT - deep_focus - rune_deep_focus - rune_heavy_bolts, 1)`.
**ER's standing rule is the reason it is a subtraction from the POINT and not a change to
`FOCUS_STEP`**: a rune moves WHERE the meter changes kind, never what a point of it pays.
`check_ez` §5 asserts the rate at the new point — 80 points of chance is exactly
`80 x FOCUS_STEP` — because "the point moved and the rate did not" is only a claim until the
second half is read.

**AND THE TAG IS THE ONE A DRAFT CAN ACTUALLY MOVE.** ES §4's table: **MARK is zero for all twelve
protected cores**, so a MARK threshold is the one magnitude a player's own drafting decides
entirely. It is the sharpest choice in the brief.

### **§3b — KEEN FOCUS SITS BELOW REACQUIRE**

Reacquire banks the WHOLE meter on a marked body and pays it back on the return. A rune that halved
first would quietly halve what the node banks. Placed below it, a hero holding both **banks the
full meter and keeps half of it in hand** — the two compose, which is the shape this file already
gives Steadfast Bond and Vengeance.

### **§3c — LONG DRAW'S COST IS A TABLE THAT WAS DELIBERATELY NOT EXTENDED**

**The brief's "each press is 15% narrower than the one before it" is `SS_SEQ_TAPER` = 0.85 and has
shipped since CS.** Read literally the clause describes the status quo and the rune would be a pure
upside.

**The cost is `SS_SEQ_OPEN`.** It is a FOUR-entry table *solved* so that a one-, two-, three- or
four-press sequence lands with the same probability — CS §4's demand that a deeper sequence must
not be likelier to break, at 89.7 / 90.0 / 90.0 / 90.0%. **The rune adds a fifth press and the
table is NOT extended**: the fifth press opens at the four-press widening and takes another taper
step, so the sequence genuinely is harder to hold together. The index is clamped
(`SS_SEQ_OPEN[mini(presses, SS_SEQ_OPEN.size()) - 1]`), which is also what stops it being an
out-of-bounds read.

> **THIS IS THE THING A LATER BATCH WILL READ AS A BUG.** Four entries against five presses looks
> like an omission. Extending the table would delete the rune's entire cost and turn it into a pure
> upside, **with nothing else in the tree noticing** — so `check_ez` §5 asserts it as an
> INEQUALITY: the fifth press's Good half must be strictly narrower than the fourth press's was.

**`SS_SEQ_MAX_PRESSES` is raised by the same one the rune adds** rather than left at 4, or the
extra press would be swallowed at the top of the ladder and the card would pay nothing to the
deep-Focus build it is for. **The STAGES do not move** — `SS_SEQ_STEP` is untouched at 50.

### **§3d — AMBUSH'S SECOND CLAUSE WAS ALREADY TRUE AND IS NOT BUILT TWICE**

*"and does not clear it"* is `_focus_safe`, which names Called Volley by hand, and BO §5 already
recorded that **no area attack has ever cleared Focus** — the engine has been gated on
`not ab.aoe` since AZ. The card's own description says *"his Focus and his mark survive it
untouched."* **The rune's real payload is the scaling half**, at `BattleUnit.FOCUS_STEP` per point
— the meter's own rate, borrowed rather than invented, so it stays honest if the meter is
re-priced.

---

## §4 — THE BEASTMASTER'S SIX

| rune | shape | where it lands |
|---|---|---|
| **Long Leash** | PASSIVE | `_bond_convert()` — EU's own slot |
| **Shared Hide** | PASSIVE | `_shared_hide_mult`, new, in `_companion_hit` |
| **Answering Pack** | PASSIVE + THRESHOLD (DEFENSE) | `_on_brunt_guard` — Bear the Brunt's guard |
| **Second Whistle** | ABILITY | `_do_summon`'s arrival block |
| **Shared Scent** | PASSIVE + BREADTH | `_on_beast_death` banks, `_do_summon` spends |
| **Bared Fang** | STAT + TRADEOFF | `_companion_hit`, and Ancient Pact's `no_heals` |

### **§4a — LONG LEASH MOVED EXACTLY ONE LINE, AS EU PROMISED IT WOULD**

`_bond_convert(_hunter: BattleUnit)` took the hunter and discarded it, *"built that way so a rune
moves one line"*. The rune is `BOND_CONVERT + hunter.rune_long_leash` and the underscore came off
the parameter. **UP, not down, and that is the designer's direction**: ER §2c resolved that the
converted half is worth MORE than the strike step at depth, so a point moved DOWN is the buff — the
Long Leash buys three more stacks of the companion's own strike step before his patience starts
feeding the boon instead. `check_ez` §5 asserts EU's invariant survives the move: at 5, 9, 11, 14
and 20 Loyalty the paid and converted halves still sum to the meter.

### **§4b — THE SHARED HIDE IS THE BATCH'S ONE DIVERGENCE FROM A RULING**

**The ruling: *"the companion inherits EVERYTHING — the full hero multiplier block, not a share and
not a named list. A named list is the stale-list trap this project has now hit six times."*
WHAT SHIPPED IS A NAMED LIST.**

**The obstacle is shape, not judgement.** The hero multiplier block is ~84 terms written INLINE
inside `_resolve_ability`'s strike loop, interleaved with reads of `ab` (the Ability), of
`strike_target`, of `grade` and of local state built forty lines earlier. **There is no function to
call and no expression to reuse.** Extracting one is a refactor of the largest function in the
project — which this batch's own §5 forbids twice over ("no ability, talent, magnitude or constant
moves").

**What made the list defensible is that a different population is available and a function CAN be
complete over it: the buffs the companion is ALREADY WEARING and has never read.** That is DK's
measurement made actionable — Empower attached to a beast perfectly, chip and tooltip included, and
paid exactly **1.0000**. `check_ez` §5 reproduces that measurement rather than quoting it.

**It is read off the COMPANION, not off the hunter**, so a party buff that missed the beast is
honestly worth nothing and one that landed pays. The two hunter-side terms are there because both
are by construction about a bond that already broke.

### **§4b(i) — WHAT THE SHARED HIDE ACTUALLY TURNS ON, TERM BY TERM**

Driven on an out-of-repo instrumented copy, one status at a time, reading
`_shared_hide_mult` directly — **the term the rune changed, not a total a Loyalty roll would
swamp** (EQ's lesson about an instrument measuring the untouched term):

| term | multiplier | side |
|---|---|---|
| `surge` | **×1.2000** | the beast's own |
| `empower` | **×1.2500** | the beast's own |
| `blood_price` | **×1.2500** | the beast's own |
| `hexed` | **×0.8500** | the beast's own — **and it is a MALUS, kept deliberately** |
| `battle_shout` (power 30) | **×1.3000** | the beast's own |
| `warcry` (power 25) | **×1.2500** | the beast's own |
| `bring_it_down` (power 40) | **×1.4000** | the beast's own |
| `reckless_abandon` (power 20) | **×1.2000** | the beast's own |
| `tempo` (power 15) | **×1.1500** | the beast's own |
| `last_howl_dmg` (40) | **×1.4000** | the hunter's |
| `vengeance` (30) | **×1.3000** | the hunter's |

> **`hexed` IS IN THE LIST AND IT MAKES THE BEAST WEAKER. THAT IS NOT AN OVERSIGHT.** The Cursed
> Visage's hex is an enemy's effect, it lands on the companion, and the hero loop reads it as a
> −15%. **A rune that inherited only the upsides would be inheriting a different thing than the
> hero block** — and DU §3's own ruling is that an ENEMY debuff paying nothing is an exploit where
> a dead player card is merely a dead card. It is one term of eleven and it is named.

### **§4b(ii) — THE DAMAGE CHANGE AT THREE LOADOUTS**

**The loadouts are three real BUFF states rather than three talent-row counts**, because what this
rune reads is buffs the companion is wearing and a talent row grants it none:

| loadout | without | with | swing |
|---|---|---|---|
| thin — Warcry alone | ×1.0000 | **×1.2500** | **+25.0%** |
| mid — Warcry + Empower | ×1.0000 | **×1.5625** | **+56.2%** |
| deep — Warcry + Empower + Battle Shout + Tempo | ×1.0000 | **×2.3359** | **+133.6%** |

**THE SWING IS LARGE AND IT SHIPS ANYWAY, WHICH IS THE BRIEF'S OWN INSTRUCTION.** DK ruled Empower
to *text* rather than widening this loop precisely because widening it moves beast damage; **that
ruling is superseded here, for this rune only, and only while it is held.** The base path is
byte-unchanged for a Beastmaster who does not hold it — `_shared_hide_mult` returns exactly 1.0
when the field is zero, which `check_ez` §5 asserts.

**AND THE "WITHOUT" COLUMN IS 1.0000 AT EVERY LOADOUT, WHICH IS THE FINDING RATHER THAN THE
BASELINE.** Four party buffs are attached to the companion and paying nothing at all. That is DK's
1.0000 reproduced at four terms instead of one.

### **§4b(iii) — AND WHICH TERMS A COMPANION CAN NEVER RECEIVE, REGARDLESS**

Derived by walking the strike loop's `raw` multiplier statements **and classifying each by its
GUARD CHAIN rather than by the arithmetic line** — the first pass read the statement alone and
reported 82 of 124 as unclassified, because the condition that decides whether a term applies sits
in the `if` above it. **That is this project's own recorded lesson (diff the guard chain, not the
read line) and it is what makes the reading reproduce DU §2's:**

| why it cannot reach a companion | count |
|---|---|
| **ABILITY-KEYED** — `_companion_hit` takes a float and not an `Ability` | **26** |
| **ATTACKER-KEYED** — a companion is never allocated a talent tree, so every rank field on one is zero | **42** |
| **PASSIVE-KEYED** — a companion's `passive_id` is always the empty string | **16** |
| **TARGET-SIDE** — damage TAKEN rather than dealt; not this rune's question at all | **32** |
| unclassified | **8** |

**26 IS DU §2's OWN FIGURE, ARRIVED AT INDEPENDENTLY**, which is what makes the rest of the table
worth reading. **NONE of these is turned on by the Shared Hide and the rune does not claim to be** —
a term the beast cannot be given is not turned on by any rune, and saying which those are is the
difference between a rune that works and one that reads as working.

### **§2b(i) — HOW OFTEN BRACING LINE'S LEVEL HOLDS, WITH AND WITHOUT STANDING WALL**

The brief asks for it directly. Driven as the real cadence — one incoming hit at a time, with the
block roll taken at the Warden's **own live block chance including the climb**, so the feedback
loop is in the measurement: a deeper meter is likelier to block and so likelier to reset itself.
n = 200,000 hits an arm.

| arm | the level (+32%) holds on | mean live block chance |
|---|---|---|
| **Standing Wall absent** | **8.98%** of incoming hits | 0.357 |
| **Standing Wall HELD** | **11.91%** of incoming hits | 0.430 |

**THE PAIR COMPOUNDS AND THE MEASUREMENT SAYS SO: the level holds a THIRD MORE OFTEN with the wall
than without it** (11.91 against 8.98, a relative +32.6%). **And the second column is the mechanism
rather than a side effect** — a halved meter leaves more plating in the roll, so his own block
chance rises from 0.357 to 0.430, which is why the pair reads as a build rather than as two
unrelated runes.

> **AND THE FIGURE TO ARGUE WITH IS THAT 8.98%, NOT THE RATIO.** Bracing Line alone pays the party
> on fewer than one incoming hit in eleven. Whether a 5% party mitigation that is live a tenth of
> the time is worth 100g is a design judgement and it is the designer's; **32 was ruled and is
> built, and this is what 32 costs.**

### **§4c — ANSWERING PACK RIDES BEAR THE BRUNT'S GUARD, AND THE CARD WINS**

`brunt_cb` is already wired at spawn and `take_hit` already asks it at the one moment that matters
— *the blow that would fell the hunter.* **A second callback would be a second set of rules for one
question**, and the two would eventually disagree about whether a beast that dies paying still
counts as having covered him.

**Bear the Brunt wins where both stand, and it must**: the card is a cast with a Mana cost and the
rune is passive, so a rune that consumed the guard first would spend a status the player paid for.
The rune is the fallback, and a Beastmaster holding both is covered twice in a fight. **The rune
takes the WHOLE blow** — 100, written as a literal rather than pointed at `BRUNT_SHARE`, because
the two are different quantities that happen to be near each other and pointing the rune at the
card's constant would silently re-tune the rune the day the card is re-tuned.

**"Once a fight" is the SPEND and not the holding.** `answering_pack_spent` is reset at spawn beside
the arming, so the rune is never removed and stays a held item rather than a consumable.

### **§4d — SECOND WHISTLE AND SHARED SCENT BOTH RAISE, NEVER ASSIGN**

Succession's discipline, four blocks up in the same function: *a returning beast already keeps what
it earned, so an assignment would let a re-call into a deep bond LOWER it.* Both runes raise.
`check_ez` §5 drives it — a beast already at 9 Loyalty arrives at 9 or better — **and the control
proves the assertion is armed**: made to ASSIGN, the same beast arrives at 4 and the gate goes red.

**Shared Scent reads `had`**, the meter as it stood when the beast fell, for Last Howl's exact
reason: Steadfast Bond rewrites that meter three lines down, so a read taken afterwards would carry
only the share that SURVIVED rather than what the companion actually earned. **It stacks with
Steadfast Bond rather than replacing it** — that node holds a share of the DEAD kind's meter, this
carries the full meter to the NEXT kind, and they are different meters. **And the bank is SPENT**,
so one death pays one arrival.

### **§4e — BARED FANG WRITES ANCIENT PACT'S OWN FIELD**

`no_heals` sits at the top of `heal_amount` with the absolute refusals. **"Cannot be healed" is a
RULE and not an amount** — the same reading Unmaking and Weight of Ruin already ship — so a second
field would be a second answer to one question. `check_ez` §5 drives a 50-point heal into the
fanged companion and reads exactly 0.

---

## §7 — WHAT DID NOT MOVE, CHECKED RATHER THAN ASSERTED

Every item on the brief's §5 list, read out of the tree after the batch:

| | |
|---|---|
| `SC_PROFILE_DEFAULT.sweep_time` | **1.00** — EY's, untouched (`battle.gd:57`) |
| `perfect_half` / `good_half` | **0.045 / 0.16** — untouched |
| `CRIT_EXCESS_STEP` | **0.50** — EX's, untouched |
| `BOND_CONVERT` | **8** — the rune moves it through `_bond_convert()`, the constant is unmoved |
| `BOND_MITIGATION_MAX` | **0.75** — untouched |
| `SS_SEQ_STEP` / `SS_SEQ_OPEN` / `SS_SEQ_TAPER` | **50 / [1.0, 1.307, 1.574, 1.861] / 0.85** — all untouched. Only `SS_SEQ_MAX_PRESSES` is read with the rune's own `+1` at the call site; **the constant is unmoved at 4.** |
| class or universal runes | **none authored.** All 21 are `spec:` |
| a rune reading a tag other than through §0's two conditions | **none** — `check_ez` §0 asserts every condition names one of the seven tags and nothing else |

**AND THE EXECUTABLE DIFF WAS PROVED TO BE WHAT IT LOOKS LIKE.** A comment-stripped diff of all
seven touched game scripts against HEAD: **+345 executable lines, −25**, and **every one of the 25
is a line this batch deliberately rewrote** — `_bond_convert`'s signature, the block roll's three
branches, the plating reset and its log, the leech cap's `minf`, the Wrath mark, the brunt guard's
share/remove/log/frame, `_old_gods_mark`'s body, `_ruin_threshold`'s two returns,
`_sequence_presses`, the `SS_SEQ_OPEN` index, the Focus zero, `focus_convert` and
`STAT_INT_KEYS`'s closing bracket. **No comment insert swallowed live code**, which is the failure
this project has a rule about.

---

## §5 — THE GATE, AND THREE CONTROLS THAT ALL BIT

**`check_ez.gd` — 96 checks / 0 failures**, three identical standalone readings before the row was
written. Every claim in this report is driven by it rather than read out of the source:

- **§0** pins the pool (21 authored, 100g flat, spec-only, every one tagged AND shaped) and asserts
  the §0 LABEL agrees with the payload's CONDITION **in both directions**.
- **§1** drives the two fractions at 4, 5 and 7 drafted cards, asserts the odd-count boundary on
  both sides, and proves the primary-only count is a **different number** from the census.
- **§2** builds a member where the pool, the equipped half and the whole bar give **three different
  answers**, and asserts which one the condition reads.
- **§3** pulls the lever through the live `unequip_earned_ability` / `equip_earned_ability` doors.
- **§4** applies all 21 payloads to a real cfg and asserts the 8 gated ones are REFUSED on a
  failing arm — **and sweeps every game script for a WRITE to a rune-owned field**, so EM's charter
  is asserted rather than claimed.
- **§5** drives the read sites on a live board.

**THE THREE CONTROLS, ARMED BEFORE THE ROW WAS WRITTEN:**

| the injection | what the gate reads |
|---|---|
| Second Whistle **ASSIGNS** instead of raising | **1 failure** — the beast at 9 Loyalty arrives at 4 |
| the threshold rounds **the other way** (`> ` for `>=`) | **6 failures**, four of them payloads that stop landing |
| the **protected core** is counted into the drafted half | **12 failures** |

**Disarmed, the tree reads 96 / 0.**

---

## §6 — WHAT THE VERIFICATION FOUND, AND THE FIRST BATTERY WAS RECONNAISSANCE

**THE FIRST FULL RUN IS REPORTED AS RECONNAISSANCE RATHER THAN AS THE VERIFICATION, AND THE REASON
IS THAT THE FREEZE BROKE.** `test_batch_ax` went red at target 25 and its cause was read and
repaired while the run was still going — which is precisely the fault this project has a rule about
(DL discarded two runs for it). **The run was allowed to finish** because a battery that is going
to be re-run is worth more finished than killed: it found **eight** red targets, and fixing them one
run at a time would have cost eight batteries. **Then the tree was re-frozen and the battery was run
once, clean.** §7 is that run.

**WHAT THE RECONNAISSANCE FOUND — 0 `Parse Error`, 0 `SCRIPT ERROR`, 0 duplicates, and eight reds
of which one was already known:**

| target | why | what it needed |
|---|---|---|
| `test_batch_ax` 352 / **2** | the lifesteal cap's fingerprint was `RUIN_LEECH_CAP)` and the Standing Mark makes the site sum a rune field into a local | the FINGERPRINT re-pointed, tighter than before; the property untouched |
| `test_batch_cp` 697 / **2** | a **FIXED 1,400-byte `substr`** from the Anvil branch — the Standing Wall's comment pushed `has_status("recompense")` off its far end | the window deleted; both offsets found FROM the anchor, unbounded |
| `test_runes` 3790 / **10** | the OLD authoring rule (4 per spec, exactly 1 splash), plus `requires_ability`, plus the power arm | three re-points, all narrowing rather than loosening |
| `test_rune_battle` 97 / **3** | the same per-spec `== 4` | derived from the file's own population |
| `check_ed` 18 / **2** | the pin manifest still named `RUIN_LEECH_CAP)` | regenerated with `build_pin_manifest.py`, **run against HEAD's manifest first** |
| `check_eu` 38 / **1** | §0 asserts **exactly one line** reads `BOND_CONVERT`, and my two-armed `_bond_convert` named it twice | **MY CODE fixed, not the gate** — one line |
| `check_de` 382 / **6** | the aggregate reporting the five above going redder | closed by fixing them |
| `check_cm_live` 13 / **4** | **the known red**, `fails: [4, 4]` since CM | nothing — see §7 |

### **§6a — THE ONE TARGET WHERE MY CODE WAS WRONG AND THE GATE WAS RIGHT**

`check_eu` §0's claim is *the split is decided in one place, and one place means one line.* My first
`_bond_convert` was a two-armed body naming `BOND_CONVERT` twice. **The gate is right and the code
moved**: it is one expression now, `BOND_CONVERT + (0 if hunter == null else hunter.rune_long_leash)`.
**Every other red in the table was a fingerprint or a pool count; this one was a defect.**

### **§6b — WHAT `check_ek` §3's THIRD CATEGORY IS FOR**

EK's claim was *nothing reads a tag for anything but DISPLAY*, and **EZ ends it deliberately.**
`TAG_SURFACE` gains the eight new ways to read one, `TAG_CHECKERS` gains `check_ez.gd`, and
**`TAG_CONSUMERS` is new**: a file that reaches the machinery through the one door without holding
any of it. `talents.gd` is the only member, and it is asserted to name **EXACTLY the door** and no
other word of the surface, and no tag WORD at all — **a tighter bound than "none", not a looser
one.** `battle.gd` still holds zero, which is what says ES §4's *read at the SPAWN, never in the
strike loop* is still obeyed.

### **§6c — THE INSTRUMENTS, AND ONE OF THEM HAD A HOLE THE BATTERY FOUND**

- **THE LITERAL SWEEP — 15,458 distinct needles at a floor of 4, from 125 `.gd` files**, swept
  against snapshots taken before a byte was edited. **LOST 0 in every one of the eight documents.**
  **ARMED IN BOTH DIRECTIONS FIRST**: removing one real needle that appears exactly once in
  `master.html` — chosen out of the needle list, not invented — reads **LOST 2** (the needle and a
  shorter one contained in it); injecting a real needle the file genuinely does not carry reads
  **GAINED 6** against a disarmed 5. **It is written in Python rather than as a grep pipeline on
  purpose**: a `--` silently disables `--include` and fails toward MORE results.
- **AND THE ASSERTIONS WERE ENUMERATED RATHER THAN THE LITERALS.** 44 distinct GAINED needles
  across the eight documents; **exactly ONE target carries a negative `contains` assertion on any
  of them, and it is not against a document** — `test_batch_bd` asserts `not perfect_text.contains("choose")`
  on an Ability. **No document-level assertion is affected, and LOST is 0, so nothing lost its
  subject.**
- **THE SCAN-WINDOW CENSUS HAD A HOLE AND THE BATTERY FOUND IT, WHICH IS THE ORDER THAT MATTERS.**
  It located every `find()` anchor in the corpus and checked it against each edit's byte range —
  and read a clean zero for `test_batch_cp`'s, **because a GDScript literal carries ESCAPED quotes
  and searching the source for the escaped text never matches.** Repaired (unescape first), and
  re-derived a second way: **every fixed-size `substr` window in the corpus was enumerated with its
  anchor — 59 of them, the widest 3,000 bytes** — and each one over an edited file was read. The
  first pass also took the first and last divergence as ONE range, which is exact for a single-site
  edit and useless for this one: `battle.gd` has **36 separate hunks** and the span read the whole
  file. Per-hunk now.
- **THE COMMENT-STRIPPED DIFF.** +345 executable lines, −25 across the seven touched game scripts,
  and **every one of the 25 is a line this batch deliberately rewrote.** No comment insert swallowed
  live code.
- **AND THE RETIRED VOCABULARY WAS PRE-CHECKED, WHICH CAUGHT ONE.** `test_batch_bx` §4 forbids any
  player-facing string reading *beast*; the Second Whistle's `desc` said *"each field the beast"*.
  Corrected to *companion* before the battery. **The designer's NAMES and VALUES are untouched** —
  a card's prose is governed by the text standard, and this is that standard biting.

---

## §7 — THE VERIFICATION RUN

### **§7a — THE FREEZE HELD EXACTLY**

An md5 stamp of **336 files with ABSOLUTE paths, TRACKED AND UNTRACKED**, taken immediately before
the launch and again after. **ZERO differ**, and the population itself is identical — nothing
appeared outside the list while the battery read it. *(Absolute paths matter: a moved cwd between
the two stamps reports the whole tree as drifted. And the list is `git ls-files` PLUS
`--others --exclude-standard`, because `check_ez.gd` was untracked when it was taken and a
tracked-only population would not have covered the batch's own gate.)*

### **§7b — THE BATTERY**

| | |
|---|---|
| **targets** | **93** — one more than EY's 92, because `check_ez` joined |
| **`sort .ran \| uniq -d`** | **ZERO duplicates** — one battery wrote these logs |
| **`Parse Error` across all 93 logs** | **0** — read off the grep, never off a tally or an exit code |
| **`SCRIPT ERROR` across all 93 logs** | **0** |
| **timeouts** | **0** |
| **`check_de`** | **382 checks / 0 failures / 0 NOTICES** — no baseline row moved and none rose |
| **`check_ez`** | **96 / 0** — the batch's own gate |
| **`check_es` / `check_et` / `check_ek`** | **44 / 0**, **24 / 0**, **46 / 0** — the three re-points |
| **`check_parse`** | **167 / 0**, residue unchanged at 4 |
| **`check_ed`** | **18 / 0** — the regenerated manifest |
| **`check_eu` / `check_ev` / `check_ew`** | **38 / 0**, **54 / 0**, **38 / 0** — the Loyalty and crit gates, all unmoved |
| **`test_runes` / `test_rune_battle`** | **3803 / 0**, **97 / 0** |
| **`test_batch_ax` / `test_batch_cp`** | **353 / 0**, **697 / 0** |
| **run harness** | GATE 1 **22**, GATE 2 **166**, GATE 3 **8**, all PASS, throws 0 |
| **the only red** | **`check_cm_live` 13 / 4** |

### **§7c — AND THE ONE RED WAS CONTROLLED AGAINST HEAD RATHER THAN QUOTED**

`check_cm_live` carries `fails: [4, 4]` and is *"the only thing pressing the defensive bar"* —
**and this batch touched the block roll** (Bared Plate refuses its first two slices), so its row
being sanctioned is not by itself an answer. Run on an out-of-repo copy with **every game script
and `data/runes.json` restored to HEAD**, it reads **13 / 4 with the same four FAIL lines,
verbatim**: *the bar appeared on the enemy's attack*, *the bar's top line names the incoming blow*,
*the brace lands near ×0.85*, *the brace's Break half lands near ×0.75*. **The FAIL LINES were
compared, not the count.**

### **§7d — THE POST-RUN EDITS, AND WHY THEY NEED NO SECOND RUN**

**Two files were written after the battery: `docs/state.md` and this report.** Both were checked
against the population rule rather than assumed harmless: **no `.gd` in the tree opens either** —
`grep -rn 'res://docs/state.md'` and `grep -rn 'docs/reports'` return only comments naming the
paths, against a control of 25 real readers for `master.html`. **Every document with a reader was
written BEFORE the battery**, which is the ordering this project has a rule about.

**AND IT WAS RUN ANYWAY, BECAUSE A SWEEP HAS HOLES A RUN FINDS** — this batch's own scan-window
census is the proof of that (§6c). Nine document-heavy targets re-driven against the post-run tree
and compared against their **own battery readings**: `test_batch_bx` 161 / 0, `test_batch_bs`
267 / 0, `test_batch_at` 467 / 0, `check_dm` 93 / 0, `check_ec` 23 / 0, `check_ez` 96 / 0,
`check_es` 44 / 0, `check_et` 24 / 0, `check_ek` 46 / 0 — **all nine IDENTICAL to the battery, 0
`Parse Error` and 0 `SCRIPT ERROR`. Not merely green: unmoved.**

**AND THE POST-RUN SWEEP MOVED NEEDLES IN EXACTLY ONE FILE.** Re-sweeping after the two edits,
`docs/state.md` reads LOST 3 / GAINED 16 and **every other document is unchanged from the
pre-battery sweep** — `master.html` 0 / 5, `CLAUDE.md` 0 / 3, `data/glossary.json` 0 / 3, all
identical. **Nothing opens `docs/state.md`**: `grep -rn 'res://docs/state.md'` over every `.gd`
returns 0 readers and `grep -rn 'res://docs/reports'` returns 0, against a control of **25** real
readers for `master.html` — so the grep is reading, and what it reads is nothing.

### **§7e — THE DATE**

The implementation, the measurements, the reconnaissance run and the verification run were all done
on **2026-09-05**, and the batch is dated for that working day.

---

## §8 — WHAT MOVED

**MOVED — SEVEN GAME SCRIPTS:** `scripts/battle.gd` (the Occultist's four read sites and the decay
tick, the Warden's five, the Sharpshooter's five, the Beastmaster's six, and `_shared_hide_mult`);
`scripts/unit.gd` (21 rune fields, two per-battle fields, and `focus_convert`);
`scripts/runes.gd` (the two conditions, the one door, the two surface builders, `RUNE_SHAPES`,
21 `RUNE_TAGS` rows and 19 `STAT_INT_KEYS` entries); `scripts/classes.gd` (the three primary-only
primitives); `scripts/talents.gd` (`condition_met`'s one new call); `scripts/map_screen.gd` and
`scripts/party_screen.gd` (the `RUNE CONDITIONS` line).

**AND SIX TARGETS, ONE NEW:** `check_ez.gd` (new); `check_ek.gd`, `check_es.gd`, `check_et.gd`
(re-pointed for the growing pool); `test_batch_ax.gd`, `test_batch_cp.gd`, `test_runes.gd`,
`test_rune_battle.gd` (re-pointed for what the reconnaissance found); `run_battery.sh` (one name);
`pin-manifest.json` (regenerated).

**AND NINE DOCUMENTS:** `data/runes.json` (+130 lines, a pure append — **no existing entry moved a
byte**); `data/glossary.json`; `docs/changelog.html`; `CLAUDE.md`; `docs/master.html` and its
stamp; `docs/text-standard.html`; `docs/design-notes.md`; `baselines.json`; `docs/state.md`; and
this report.

**DELIBERATELY DID NOT MOVE:** `SC_PROFILE_DEFAULT` and every field in it; `CRIT_EXCESS_STEP`;
`BOND_CONVERT`, `BOND_STEP` and `BOND_MITIGATION_MAX`; `_bond_fallback`; `SS_SEQ_STEP`,
`SS_SEQ_OPEN`, `SS_SEQ_TAPER`, `SS_SEQ_OFFSET`, `SS_SEQ_SWEEP` and `SS_SEQ_MAX_PRESSES`;
`RUIN_THRESHOLD`, `RUIN_LEECH_CAP` and `OLD_GODS_MARK` (all three are read WITH a rune term now and
all three are byte-unchanged at their definitions); `Classes.tag_count` / `tag_census` /
`tag_breadth` and `Runes.tag_threshold_met` / `breadth_met`, all five of which ES §4/§5 authored
and none of which this batch touched; the 65 retired entries; and `docs/reports/` for every earlier
batch.

---

## §9 — WHAT IS OWED, AND TO WHOM

- **SPLIT TONGUE'S DAMAGE IS UNPRICED AND IT IS THE DESIGNER'S.** The rune makes Hex of Ruin `aoe`
  at its authored 20% of Attack. Against the four-enemy warband the fixture builds that is the same
  three targets plus one; against the six-plus rosters `compose` floors elite and mini-boss lineups
  at, it is more. **A damage reduction to pay for it is a magnitude and a batch does not choose one.**
- **THE VACUOUS EMPTY LOADOUT (§0b).** One clause, in one function, if the designer wants it closed.
- **THE SHARED HIDE'S LIST (§4b).** The batch that extracts the hero multiplier block into a
  callable is the one that can honour the ruling; it should re-point this rune at it rather than
  growing the list.
- **BRACING LINE PAYS ON 8.98% OF INCOMING HITS ALONE, 11.91% PAIRED.** 32 was ruled and is built;
  what it costs is now measured rather than assumed.
- **THE POWER ARM DOES NOT DESCEND INTO `also`** (recorded on `test_runes`' `UNSCALABLE` block).
  Nothing is unmeasured today; the day a rune puts a magnitude in an `also`, the probe will call it
  a dud rather than scale it.
- **AND `check_ew` §6's LAST ASSERTION IS STILL VACUOUS** — `ok(step == step, …)`, owed since EX and
  not repaired here, because this batch had no reason to touch that gate and touching it would have
  moved a count for nothing.
