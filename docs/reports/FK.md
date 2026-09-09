# BATCH FK — FORTY RUNES, EIGHT SPECS

*2026-09-08. Full working. `docs/state.md` carries the summary; this file carries the evidence.*

**THIRTY-NINE OF THE FORTY SHIPPED. ONE IS REPORTED AND NOT SHIPPED**, because its whole clause
is already the base kit and it would have shipped 100% inert — the brief's own ruling is that
*"a rune that ships inert is worse than one that does not ship."* See §7.

---

## §0 — THE PREMISES, CHECKED FIRST

The brief carried **fourteen checkable premises about the code**. **Ten held. Four did not.**

| # | Premise | Verdict |
|---|---|---|
| 1 | `spec:devout` and `spec:survivalist` roll for nobody; the keys are `inquisitor` and `mystic` | **HELD** |
| 2 | Berserker: Rage he spends already feeds the passive; the band caps at 20 and fills sooner | **HELD** |
| 3 | Pyromancer: `Backdraft` collides with something live, and the rune must be renamed | **HELD, WRONG KIND** — §2 |
| 4 | Cryomancer: four `rune_*_ranks` fields arrive through `_max_hero_rank` party-wide | **HELD** |
| 5 | Arcanist: `RESONANCE_TAKEN_STEP` has no bonus term, deliberately | **HELD** |
| 6 | Arcanist: `Resonant Core` is a retired rune's name and is **free** | **FALSE** — §4 |
| 7 | Swordmaster: both stance DOWNSIDES are bare literals with no bonus field | **HELD** |
| 8 | Swordmaster: `Whetstone` is a live node in his Blade lane | **HELD** |
| 9 | Holy: `Long Watch` is also a LIVE rune on the Warden | **HELD** |
| 10 | Holy: the Mercy bar is `second_resource`, shared with Resonance and Focus | **HELD** |
| 11 | Devout: Consecrated Ground grants Faith **only to its caster** | **FALSE** — §7 |
| 12 | Devout: **Fervor already extends the ground to allies** | **FALSE** — §7 |
| 13 | Survivalist: Force of Nature replaces Trapper's term via `elif` | **HELD** |
| 14 | Survivalist: every affliction the Second Barb cycles must be in `DEBUFF_IDS` | **HELD** |
| 15 | A RETIRED rune's name is **free** (said of `Killing Cold`, `Resonant Core`, `Open Hand`, `Long Watch`, `Martyr`) | **FALSE** — §2a |
| 16 | The forty are named `Rune of the …` | **FALSE** — that is the RETIRED pool's shape; §2a |

**Five collisions were named in the brief; the sweep found TEN EXACT hits and three of them are
new.** §1. **And two premises about NAMING were false in a way no sweep could catch, because they
are about the pool's own conventions rather than about the roster — §2a.**

---

## §1 — THE BR §1 NAME SWEEP, ON ALL FORTY

**Derived from a running headless engine, not from source text.** A throwaway probe called the
game's own accessors — `Classes.ability_corpus`, `Classes.talent_granted_names`,
`Talents.LANE_TREES`, `data/runes.json` and `BattleUnit.DEBUFF_IDS` — and dumped **708 names**:
227 abilities, 324 talent nodes, 21 live runes, 66 retired ones, 27 statuses and every lane name.
**Zero `Parse Error` in the probe's stderr** (grepped, never the exit code). The probe was deleted
before the commit.

**Every one of the forty was swept against all 708, and a near-miss was treated as a hit** — exact
match, containment either way, and shared-token overlap. **190 hits over the forty.** The ten that
are EXACT:

| Rune name | Collides with | Kind | Same spec? | Named in the brief? |
|---|---|---|---|---|
| **Blood Debt** | **ABILITY** `Blood Debt` (Berserker spec draft) | ability | **YES** | **no** |
| **Slaughterhouse** | NODE `Slaughterhouse` (Berserker, Bloodletting r8) | node | **YES** | implied |
| **Backdraft** | **ABILITY** `Backdraft` (Pyromancer spec draft) | ability | **YES** | yes — as a *node* |
| **Cold Snap** | NODE `Cold Snap` (Cryomancer, Deep Freeze r6) | node | **YES** | **no** |
| **Resonant Core** | NODE `Resonant Core` (Arcanist, Resonance r5) | node | **YES** | **no** |
| **Overflow** | NODE `Overflow` (Holy, Radiance r7) | node | no | yes |
| **Whetstone** | NODE `Whetstone` (Swordmaster, Blade r8) | node | **YES** | yes |
| **Grace** | NODE `Grace` (Holy, Mercy r5) | node | **YES** | **no** |
| **Vigil** | **LANE** `Vigil` (the Holy's own lane) | lane | **YES** | **no** |
| **Long Watch** | **LIVE RUNE** `Long Watch` (Warden) | rune | no | yes |

**ONE WAS RENAMED AND NINE SHIP AS SPECIFIED, WHICH IS BR §1's OWN RULE.** An
ABILITY-vs-ABILITY duplicate is a real break — `Classes.pool_ability` is keyed on `display_name`
— and must be renamed; everything else is a LABEL collision that ships and is flagged.

- **RENAMED: `Rune of the Backdraft` → `RUNE OF THE EMBER LEAP`,** as the brief ordered. **The
  brief's reason was wrong and the order was right.** It is not a talent node in the Inferno lane
  — there is no node of that name in any of the 324 — it is a **live Pyromancer draft card**
  (`special = backdraft`, DEBUFF · RESOURCE, 20 Mana / 3cd), which is a *closer* collision than
  the one the brief named: a rune and a card with one name, both reachable by one hero, and the
  rune does not even attach to that card.
  · **AND THE PROJECT HAS BEEN THROUGH THIS EXACT COLLISION ONCE ALREADY, IN THE OPPOSITE
    DIRECTION.** `test_batch_cb` asserts, by name, that the Pyromancer node `py_melt`
    ***"no longer collides with the card name"***, that ***"Backdraft is a DRAFT card now"***, and
    that ***"the name still resolves, as it always has."*** So a node of that name DID exist, batch
    CB renamed it away **because the draft card owns the word**, and a suite has been holding that
    ruling ever since. **The brief's premise describes the state CB deliberately repaired.** That
    makes the rename doubly right — the card is the surviving owner and CB is the precedent — and
    it is the sharpest illustration on this page of why a brief's account of *what* a name collides
    with is a premise like any other.
  · **The alternative is brought back rather than presented as settled**: `Ember Leap` is swept
    clean against all 708 (no exact, no containment, and only the ordinary `ember`/`leap` token
    overlaps), and renaming it again is one string in `data/runes.json` and one comment.
- **`Rune of Blood Debt` IS THE WORST COLLISION IN THE SET AND IT SHIPS.** A rune and a card
  with the same name, in the same spec's reachable pool, both about the same fantasy — and the
  rune attaches to a *different* card (`requires_ability: "Blood Price"`). Nothing resolves a rune
  by name (`config`/`build` key on the id; the only name-keyed read is the per-member pouch
  dedupe), so nothing breaks. **It is the BP Precision Strike / CK Iron Will grade of collision
  and it is reported, not resolved** — renaming it is the designer's call and one string.
- **`Long Watch` IS A RUNE-vs-RUNE DUPLICATE AND IT IS SAFE, WHICH WAS CHECKED RATHER THAN
  ASSUMED.** The only name-keyed rune lookup in the game is `eligible_ids`'s
  `owned_names.has(display_name(e))` — a **per-member** dedupe, fed from that member's own pouch.
  The two runes have **disjoint spec scopes** (`spec:warden`, `spec:holy`) and `_scope_ok` runs
  first, so no single hero can ever hold both and the dedupe can never mis-fire. **The cost is a
  player reading one name for two effects across two heroes**, which is a real cost and is the
  designer's to overturn.
- **Four of the ten are SAME-SPEC node collisions** (Slaughterhouse, Cold Snap, Resonant Core,
  Whetstone, Grace — five, with Vigil's lane a sixth). That is the **CK Iron Will grade**: same
  class, same spec reachable, so one hero really can hold both and see the word twice. Nothing
  resolves a node name either. All ship and all are flagged here.

---

## §2 — WHAT EACH RUNE ACTUALLY WRITES, AND WHERE

**All thirty-nine are `stat` payloads writing rune-owned fields**, which is the shape all
twenty-one live runes already have. **Thirty-eight ints and one float.** Every int is in
`Runes.STAT_INT_KEYS` for the AA reason (JSON parses `1` as a float and a float into a typed int
var is a runtime error **at spawn**, not a rounding); the one float —
`rune_seasoned_off_bonus`, the Whetstone's 0.03 step — is deliberately absent and named in that
list's own block, because coercing it would flatten it to zero, which is the failure that reads
exactly like the rune working.

**NINE OF THE THIRTY-NINE NEEDED NO NEW READ SITE SHAPE and thirty did.** The brief asked for this
to be reported rather than discovered: **every one of the forty needs code.** Not one is expressible
as a payload against an existing idle field alone — the eight specs hold 34 idle `rune_*` fields
between them and **exactly one of the thirty-nine reaches one** (the Whetstone, onto
`rune_seasoned_off_bonus`, and even that needed a second field and a turn counter to mean "grows").

**THE FOUR PLACEMENTS WORTH RECORDING, because each is a door that already existed:**

- **`_overburn_refund` IS THE ONE DOOR EVERY BURN CONSUMER SHARES**, so the Pyre Debt and the
  Ember Leap both live inside it and **neither adds a call site** — `test_batch_ar`'s pinned count
  of `_overburn_refund(attacker,` stays at 6. The Ashfall passes **zero** through the same call
  rather than removing it, for the same reason.
- **`_add_bleed_with_burst` IS THE ONE BLEEDOUT PATH**, so the Slaughterhouse rune fires for a
  meter that filled on its own, for Gut Rip's forced burst, under the Exsanguination capstone and
  down Arterial Spray's chain — the same property the *node* of that name relies on.
- **`_gain_faith` AND `FAITH_RELEASE` ARE ONE ENGINE**, so the Fourth Stack moves the cap and the
  release threshold together and Communion's own `>= FAITH_RELEASE` guard follows.
- **`STALKING_HORSE_STATUSES` IS THE CYCLE THE SECOND BARB USES**, not a second list. That is
  load-bearing rather than tidy: every id in it is in `DEBUFF_IDS` by construction, and an
  affliction outside that curated list applies, logs, reads as working and pays Trapper's breadth
  term **nothing**.

**AND ONE LOOP HAD TO CHANGE SHAPE.** `for hit_i in total_hits:` evaluates its range once, so the
**Rune of the Butcher's Bill** — which adds a strike when a Bleed lands, from *inside* the body —
would have raised a number nothing read. It is a `while` with the increment at the top now:
`hit_i` runs 0..total_hits-1 exactly as before, every `break` means what it meant, there are no
`continue`s at that level, and `hit_i == total_hits - 1` at the crit site now reads *"the last hit
including an added one"*, which is the correct reading of a strike that really is last.

---

## §2a — A RETIRED RUNE'S NAME IS NOT FREE, AND THE LIVE POOL'S SHAPE IS BARE

**Both premises failed together and one edit fixed both.** Neither was reachable by the BR §1
sweep: that sweep asks *"does this name exist"*, and these are questions about **what the pool's own
conventions are**.

### (1) `test_runes` PINS DISPLAY-NAME UNIQUENESS ACROSS THE WHOLE FILE, RETIRED INCLUDED

The brief says three times that a retired rune's name is **free** — of `Killing Cold`,
`Resonant Core`, and of `Open Hand` / `Long Watch` / `Martyr`. **It is not.** `test_runes`'
schema walk asserts no two entries share a `display_name`, and it says why in its own comment:

> **ES §1 — AND THE NAME IS NOW THE ONLY THING KEEPING THEM APART.** `display_name` used to
> prepend a tier or the Scarred prefix, so two entries could share a `name` and still be distinct
> runes; **they cannot now**, which makes this uniqueness check load-bearing where it used to be
> belt-and-braces.

And a retired entry is **kept and still resolves** — EO §3's contract: `config`, `build` and
`display_name` all answer for it, so a saved run holding one keeps working. **Two entries sharing
one name is therefore two resolvable runes wearing one word.** Four of the thirty-nine tripped it.

### (2) `check_fd` §3 PINS THAT THE LIVE POOL DOES NOT WEAR `Rune of the …`

The brief writes all forty as *"Rune of the X"*. **Every one of the 21 live runes is BARE** —
`Deepening Hex`, `Standing Wall`, `Keen Focus`, `Bared Fang` — and `check_fd` §3 asserts that a
live rune wearing the long shape is **the retired pool's shape leaking back**, with a floor on the
retired side (≥60) proving the shape really is the retired pool's rather than a coincidence.

### THE ONE EDIT THAT CLOSED BOTH, AND THE ONE RENAME IT FORCED

**Bare-naming the thirty-nine turned `check_fd` §3 green AND removed all four duplicates at a
stroke** — `Rune of the Killing Cold` and `Killing Cold` are different strings, and the live pool's
own convention is the second. **The brief's "free" premise becomes true under the pool's own
naming rule**, which is a neater outcome than a rename would have been.

**IT FORCED EXACTLY ONE RENAME, AND IT IS THE ONE §1 HAD ALREADY FLAGGED.** Bare-named, the Holy's
`Long Watch` is byte-identical to the Warden's live `Long Watch` — no longer a label collision but
a **duplicate display name**, which the uniqueness pin refuses. It is **`Carried Mercy`**, swept
clean against all 747 names. **§1's analysis was right that nothing RESOLVES a rune by name and
wrong that the collision was therefore free**: the schema forbids it regardless, and the schema is
what a later batch will meet.

**THE BARE NAMES WERE RE-SWEPT**, because stripping a prefix changes what a sweep sees. Same
picture: one ABILITY exact (`Blood Debt`, reported not resolved), five NODE exacts, one LANE exact
(`Vigil`), and no rune-vs-rune duplicate anywhere in the 126.

---

## §3 — THE LIVE DRIVE: 39 OF 39 PAY, AND THE FIRST READING SAID 0 OF 39

**Every FK rune equipped through the real door** — `Runes.build` into the member's pouch, with
`requires_ability` honoured by giving the hero the card, because
`Talents.apply_payload` matches on `display_name` and **a rune naming an ability the hero does not
own applies silently and does nothing**. Three passes, one spec per class slot, every FK spec
driven in its own slot. **The field is read back off the SPAWNED UNIT, never off the payload.**

| | |
|---|---|
| **39 of 39 PAID** | every payload field lands non-zero on the spawned hero |
| **0 inert** | including the Whetstone's two fields and the one float, which reads `0.03` |

**AND THE FIRST READING WAS `0 of 39`, WHICH IS WORTH RECORDING BECAUSE IT IS FJ §5's LESSON
AGAIN.** The probe threw `Invalid access to property 'bm_abilities'` while granting the required
cards — the key does not exist on a fresh member — so **no rune was equipped at all** and every one
read as inert. A table of thirty-nine `**INERT**` rows is exactly the alarming answer, and it was
false. **`check_ez` §4 had asserted "60 of 60 landed" through the same `apply_payload` door minutes
earlier**, which is what said the instrument was wrong rather than the runes.

### AND THE TWO THAT CHANGE CONTROL FLOW WERE DRIVEN TO THEIR READ SITES

A field landing is not a read site firing. The two runes that change how a turn resolves were
driven through a whole autoplayed fight and counted out of the combat log:

| Rune | Fired |
|---|---|
| **Rune of the Butcher's Bill** — a Bleed buys another swing | **2** |
| **Rune of the Slaughterhouse** — a bleedout buys a turn | **1** |

**The Slaughterhouse firing at all is the proof a bleedout happened**, which is what the free
action hangs off; and the Butcher's Bill firing twice is the `while` conversion working, because a
`for` would have counted the extra strike and never run it.

### WHAT THE DRIVE DOES **NOT** COVER, STATED RATHER THAN IMPLIED

**`test_rune_battle` DRIVES NINE OF THE TWELVE SPECS AND NOT THE THREE WARRIORS.** Its passes are
pyromancer/holy, cryomancer/occultist, arcanist/inquisitor and the three Hunter specs — so
**berserker, swordmaster and warden equip no runes in the battery at all**, and FK put ten new
runes on two of those three. The probe above covers them; the SUITE does not, and closing that is a
small, clearly-scoped instrument change rather than something to bolt on at the end of a batch this
size. **It is owed, and it is named here so it is not re-discovered.**

---

## §4 — THE FOUR FIELD NAMES THAT HAD TO CHANGE, AND THE GATES THAT CAUGHT THEM

**Two existing gates found two real faults in the first cut. Neither was visible from the data.**

### (1) `check_em` — TWO RUNE FIELDS SHADOWED A LIVE TALENT COUNTER

EM's rule is that a talent counter `X` with a rune half `rune_X` must be READ as `X + rune_X`, and
its instrument walks every read site to check. **`whetstone` and `slaughterhouse` are both live
talent counters** — the Swordmaster's Blade row 8 and the Berserker's Bloodletting row 8 — so
**naming the runes' fields `rune_whetstone` and `rune_slaughterhouse` made EM's rule claim that
every read of `attacker.whetstone` owed a `+ attacker.rune_whetstone`**, which is false: the rune
fields mean
something entirely unrelated to those nodes. **Nine reds**, and the repair is a rename, not an
exemption: `rune_growing_edge` and `rune_bleedout_action`. *(This is the "name matching needs
boundaries AND a namespace" hazard arriving through a prefix rather than through a word.)*

### (2) `check_ez` §4 — A SCRIPT MUST NOT WRITE A `rune_*` FIELD, AND THE ENEMY STAMPS DID

`check_ez` §4 asserts **`runes.json` is the only writer of a rune-owned field**, and the rule is
right: a rune field whose value can arrive from a script is a field whose value is not the rune's.
**Two of FK's runes have to be stamped onto the ENEMY** — the Long Fuse holds a Burn clock and the
Deep Cold lifts a Chill cap, and both are read in `unit.gd`, which cannot see the party. The first
cut stamped `rune_long_fuse` and `rune_deep_cold` onto enemies and tripped the rule.

**THE REPAIR IS A RENAME AND IT IS ALSO THE HONEST READING.** An enemy never wears a rune, so what
is stamped on one is a **battle fact about that body** and not a payload: `burn_clock_held` and
`chill_uncapped`. The rune's own field stays on the hero where the payload wrote it, the rule is
untouched, and no exemption was written.

---

## §5 — THE PLACEMENTS THAT NEEDED NO NEW CALL SITE

**Four doors already existed, and using them is why several pinned counts did not move.**

| Rune(s) | Door | What it bought |
|---|---|---|
| Pyre Debt, Ember Leap, Ashfall | `_overburn_refund` | the ONE door every Burn consumer shares — **`test_batch_ar`'s pinned `_overburn_refund(attacker,` count stays at 6**, and the Ashfall passes **zero** through it rather than removing the call |
| Slaughterhouse | `_add_bleed_with_burst` | the ONE bleedout path, so a meter that filled on its own, Gut Rip's forced burst, the Exsanguination capstone and Arterial Spray's chain all pay |
| Fourth Stack | `_gain_faith` + `FAITH_RELEASE` | one engine, so the cap, the release and Communion's own guard move together |
| Second Barb | `STALKING_HORSE_STATUSES` | every id in it is in `DEBUFF_IDS` **by construction**, so the cycle cannot hand out an affliction that pays Trapper's breadth term nothing |
| Killing Cold, Overtone | `_resolve`'s cost line | the one line every ability in the game passes through — CZ §1's own property, reused |
| Last Word, Vigil | `_check_below_half` / `heal_amount` | both crossings the game can make already funnel through those two functions |

---

## §6 — THE TRADEOFFS, LISTED, BECAUSE EIGHT IS TWICE WHAT THE POOL HAD

| Rune | Upside | Price |
|---|---|---|
| **Blood Debt** | Blood Price bills the enemy, and their missing health is his Frenzy | he pays no health, so nothing banks his own floor from the cut |
| **Pyre Debt** | Overburn refunds **double** | a tenth of the refund burns him |
| **Glass Prison** | Glacial Prison holds **two** | both cells shatter on any damage, from any source |
| **Dissonance** | the damage curve reads **twice** his Resonance | so does the taken curve — and the curve is quadratic, so 2n is over **four** times the payout AND over four times the price |
| **Naked Blade** | both stances' upsides **doubled** | both downsides doubled with them |
| **Martyr** | Mercy accrues when an enemy strikes him | nobody but himself may heal him |
| **Bare Altar** | Faith builds **twice** as fast | Divine Shield absorbs **half** as much |
| **Thin Blood** | the barb fires on **every** strike | his Poison deals no damage at all |


---

## §7 — THE RUNE OF THE STANDING GROUND IS **NOT SHIPPED**, AND WHY

**ITS CLAUSE IS THE BASE KIT, VERBATIM, AND HAS BEEN SINCE BATCH AW §2.**

The brief: *"Consecrated Ground grants Faith to allies standing in it, not only to its caster."*

The code, in three lines that need no interpretation:

1. **`battle.gd`'s `cons_ground` handler applies the status to EVERY living non-companion hero** —
   `for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
   _apply_status(h, "cons_ground", 3, 0, 0, attacker)`. It is not the caster's status.
2. **`_ground_faith_tick(u)` is called at EVERY unit's turn start** (`battle.gd`, the turn-start
   block) and grants `FAITH_PER_GROUND_TURN` to whichever hero `u` is, gated only on
   `u.has_status("cons_ground")`.
3. **The comment directly above that call says so**: *"Batch AW §2: the holy ground is a Faith
   engine in the BASE KIT now."*

**So the rune as written would install, log nothing, and change nothing. It is 100% inert.**

**AND THE BRIEF'S SECOND CLAIM ABOUT IT IS FALSE TOO.** *"Fervor is the node that already extends
the ground to allies."* **Fervor extends nothing.** Its own `desc` (`talents.gd`, `dv_fervor`,
Faith row 6): *"While Consecrated Ground holds, every hero standing on it counts each stack of
Faith DOUBLE… **It grants no extra Faith at all.**"* It is a **payout multiplier**, read at
`battle.gd`'s Apostle/Fervor multiplier, and it has never touched the drip. **The interaction the
brief asked me to report is therefore not an interaction**: there is nothing for the rune to stack
with, because the rune's clause does not exist and Fervor's does something else.

**WHY IT IS REPORTED RATHER THAN QUIETLY RE-AIMED.** The brief is explicit in both directions and
they resolve cleanly here:

> *"Nothing here was invented by a batch and nothing here may be altered by one."*
> *"Do not silently drop one — **a rune that ships inert is worse than one that does not ship**."*

A rune whose payload is already the base kit **is** the inert case, so shipping it is what the
second sentence forbids; inventing a different payload for it is what the first sentence forbids.
**The Devout ships four and the fifth is owed with a decision attached.**

### THE TWO NEAREST LIVE ALTERNATIVES, PRICED, FOR THE DESIGNER

Both are one field and one line, and **neither is authored here** — they are the two places a rune
pointed at "Consecrated Ground is a deeper Faith source" could actually land.

| Option | Where | What it would cost |
|---|---|---|
| **The ground kindles DEEPER** — `FAITH_PER_GROUND_TURN + rune_X` | `_ground_faith_tick`'s one `_gain_faith` call | One int field, one term. **BI §2 measured the ground at 9.1 Faith a battle against the absorb's 1.5**, so +1 a turn is a large multiplier on the engine's dry source and wants measuring before a number is chosen. |
| **The ground kindles the DEVOUT'S OWN count** at a second rate | same call, `u == devout` branch | One int field, one branch. **BH §2 closed the Devout's own release deliberately** and his count holds at the cap and never releases, so this pays him peak and nothing else — smaller, and it does not touch the frequency loop BH §2 shut. |

**Neither is recommended over the other here.** Rune content is written with the designer, one rune
at a time, and this file does not invent it.

---

## §8 — THE OVERLAPS A LATER BATCH MUST NOT RE-DERIVE

Three runes duplicate part of something already shipped. **All three ship; all three are named
here rather than found later.**

### (1) THE RUNE OF THE LONG POISON IS ONE THIRD OF A CAPSTONE, AND GOES INERT UNDER IT

**`Perfected Toxin` (`sv_epidemic`, Venom row 9, CAPSTONE) reads:** *"Your Poison cannot be
cleansed, **never expires**, and its tick rises by {v} each turn it persists."*

The rune's whole clause is the middle third of that sentence. **A Survivalist holding the capstone
gains nothing at all from the rune**; one who has not walked the Venom lane gains the whole
permanence. The implementation is written as an `elif` **below** the capstone's branch and
deliberately does **not** set `sticky` — that flag is what makes a poison uncleansable, and taking
cleansing off the table is the capstone's clause, not the rune's. So the two are not identical and
the rune is not a cheaper capstone; it is one of its three clauses, at 100g, for a hero who cannot
reach row 9.

**This is the brief's own question answered for a second capstone.** §8 asked *"report which of the
five go inert under the capstone"* about **Force of Nature**; the answer there is **none** — not
one of the five is written against Trapper's +8% step, which was the constraint, and all five land
elsewhere (`_apply_poison`'s tick, the barb's chance, the barb's affliction, `Cull`'s purge,
`Downwind`'s spread). **The capstone that actually eats one of them is Perfected Toxin, which the
brief did not ask about.**

### (2) THE RUNE OF THE LAYERED AEGIS SITS BESIDE RADIENT AEGIS AND IS NOT IT

**`Radient Aegis` (`dv_aegis`, Bulwark row 2)** already echoes Divine Shield onto a second ally —
**on a roll** (`randf() < 0.01 * aegis_ranks`). The rune is **unconditional**, and it picks the
ally **lowest on health** rather than at random, because a guaranteed second shield that lands on
the healthiest body is a clause that reads as working while doing nothing. **The two compose**: a
Devout holding both shields two by rule and may shield a third by luck.

### (3) THE RUNE OF THE OPEN LINE REUSES `formless` AND PAYS NO RECOIL

The **Formless** card already holds both stances' upsides and neither downside — and **pays both
downsides afterwards** (`formless_pending` arms `formless_recoil` when the window lapses). The rune
applies the same status and **never sets `formless_pending`**, so the window simply ends. That is
the exchange, and it is why the rune's window is two ticks against the card's four. **The
Discipline accumulation survives**, because `_swordmaster_switch` is what throws it away and the
rune does not call it — the clearest statement of what the rune traded.

---

## §9 — WHAT WAS DELIBERATELY NOT DONE

- **The ~~six~~ EIGHT shipped gated runes are not repaired.** Owed, next batch, exactly as the
  brief says. *(Corrected at FN: this report is closed and the line is struck rather than rewritten.
  There are EIGHT — four THRESHOLD and four BREADTH — and this was one of eleven lines across five
  files that said six. `check_fk.STILL_GATED` held the right list the whole time; FL §2a derived the
  count off it and FN paid the repair.)*
- **The generated stat family stays.** It comes out once the pool is proven; that was the
  designer's ruling on order.
- **No THRESHOLD and no BREADTH is authored.** All thirty-nine carry a bare shape or a TRADEOFF.
  **Eight carry a TRADEOFF**, against the four the first twenty-one had.
- **No card, ability, talent, constant or magnitude moved** except where a rune's payload required
  it. `ARCANE_BOLT_KEEP`, `FAITH_RELEASE`, `FAITH_PER_ABSORB`, `HOLD_RELEASE_STACKS`,
  `FRENZY_RAGE_PER_STEP`, `PYRE_SHARE_PERFECT`, `FIREDRAW_TAKE_PERFECT`, `RESONANCE_TAKEN_STEP`
  and the four stance literals are all **byte-unchanged**; every rune reads *beside* them.
- **`RESONANCE_TAKEN_STEP` GOT NO BONUS TERM**, which the brief made a condition. The Dissonance
  reaches the taken curve by **doubling the meter inside `resonance_curve()`** — the one function
  both curves already share — so the authored decision at `unit.gd:766` stands untouched and the
  nameplate chip follows for free.
- **NONE of the Cryomancer's five writes a party-wide MAX field.** `rune_frigid_ranks`,
  `rune_frostbite_ranks`, `rune_hungering_ranks` and `rune_hypothermia_ranks` are untouched; all
  five Cryomancer runes carry fields of their own.
- **No rune SOFTENS a Swordmaster downside**, which the recon named as the likeliest EZ-shaped
  mistake on the page. The Naked Blade **doubles** both downsides, which is the opposite.

---

## §10 — THE GATES THAT MOVED, AND WHY EACH MOVE IS A CENSUS AND NOT A WEAKENING

**The unmodified gates were run against the new tree BEFORE any of them was edited**, per the
brief. That run is reconnaissance and is discarded — a control edit landed behind it — but its red
list is the one repaired here, and every red was re-derived statically as well.

**A LITERAL SWEEP OVER EVERY LINE THE DIFF REMOVED.** 43 removed code lines, swept against all 90
gates and suites for a pin. **Two are pinned, one hit was a false positive, and forty are free.**

| Pin | What it asserts | What FK did | The repair |
|---|---|---|---|
| `test_batch_bf` §2 | the Communion walk names `FAITH_RELEASE`, not a digit | the Fourth Stack moves the release, so the walk reads a derived local | **RE-POINTED AND STRENGTHENED** — the new pin names the local AND its derivation from `FAITH_RELEASE`, so a batch replacing the derivation with a digit is still caught |
| `test_batch_br` §1 | locates the hit loop by `find("for hit_i in total_hits:")` to slice its body | the Butcher's Bill needs a LIVE bound, so the loop is a `while` | **RE-POINTED** to the new header. `ok(loop_start > 0 …)` is what caught it, which is the pin working |
| `test_batch_ax` §(4) | `add_status` no longer caps **Ruin** at 5 | FK touched the **chilled** branch | **FALSE POSITIVE** — different branch, different status, assertion untouched |

**AND THE CENSUS PINS, WHICH A POOL GROWTH NECESSARILY MOVES.** Five targets count runes by scope
and were written when that spec had four. **Every one is a count of a growing population**, and
re-pointing a census is not weakening an assertion — but each was checked for a RULE hiding inside
the count before it was moved.



---

## §11 — VERIFICATION

The brief's floor: **it parses, it runs.**

- **`grep 'Parse Error'` over stderr: 0**, never a tally and never the exit code. `check_parse`
  reads **174** — 173 plus `check_fk` joining the battery, which is that gate's count being its
  coverage.
- **The live drive: 39 of 39 payload fields land on a spawned unit**, and the two control-flow
  runes were counted firing out of a real fight's combat log.
- **`check_fk` is NEW at 64 checks / 0 failures**, three identical standalone readings, and it was
  **ARMED before it was believed** — three controls, two of them a matched pair:
  - **arm one**: a payload field `BattleUnit` does not declare → §3 and §4 red (3 failures);
  - **arm two, the pair**: the same field **declared, written and READ** → §3 green; the same field
    **declared, written and NOT read** → §3 red at *"writes a field NOTHING READS (1 mentions)"*.
    **The second arm is the one that matters** — the first proves the walk can see a missing field,
    and only the pair proves it can see an INERT one, which is what the section is for;
  - **§6's control**: narrowing Consecrated Ground to its caster → §6 red at *"the rune is
    authorable now"*, which is the assertion doing exactly the job it was written for.
- **THE TWO DOCUMENT EDITS WERE SWEPT, AND THE SWEEP WAS ARMED FIRST.** Every string literal of
  4+ characters in every file that reads the document, against the copy at HEAD and the copy now:

  | Document | Reader files | Needles | LOST | GAINED |
  |---|---|---|---|---|
  | `docs/master.html` | 34 | 8,741 | **0** | 0 |
  | `docs/changelog.html` | 18 | 3,528 | **0** | 11 |

  **A sweep that reads 0 on a changed file has proved nothing**, so it was armed: a **same-length**
  one-character edit to a real needle moved the count to **1 LOST**. Same length on purpose — a
  drop or a duplication moves the file size and a weaker check would catch it. **The control was
  applied to an in-memory COPY and never to the frozen tree**, because 34 targets read
  `master.html` and a battery target reading it mid-edit would red for a reason that is not the
  tree's. **Every GAINED was checked for negative use** and all eleven are common identifiers
  (`Mercy`, `Resonance`, `Backdraft`, `Consecrated Ground`…); the nine negative-looking assertions
  that name one are all about SOURCE or a live status, none against the changelog.
- **`docs/state.md` AND `docs/reports/FK.md` WERE THE ONLY FILES EDITED DURING THE FREEZE**, and
  both have **zero readers** — no `.gd` file opens `res://docs/state.md` or any path under
  `res://docs/reports` (FJ §4 proved the first; the second was re-checked here). Nothing a battery
  target reads moved after the acceptance run started.
- **`build_pin_manifest.py --check`: current at 1,432 pins**, and **`check_ed` was run against
  HEAD's manifest BEFORE regenerating** — it named exactly the two broken pins the literal sweep
  had found and the eight new ones, which is the manifest confirming the sweep rather than
  standing in for it.
- **THE FULL BATTERY IS GREEN: 100 targets, and `check_de` reports 0 failures and 0 NOTICES**, so
  every baseline row matches its target exactly rather than merely not falling.
- **THE ONE RED IS THE SANCTIONED ONE, AND IT WAS CONTROLLED AGAINST HEAD RATHER THAN AGAINST ITS
  COUNT.** `check_cm_live` fails 4 of 13 by its own baseline (*"THE ONE RED THAT IS ON PURPOSE…
  identical on unmodified HEAD"*), and it is the only thing in the project that presses the
  defensive bar — which sits in `_resolve`, two lines above where FK books the Killing Cold and the
  Overtone. **A matching count would not have been enough**, so HEAD's tree was rebuilt out of
  repo (`rsync` + `git --work-tree=… checkout HEAD`, keeping `.godot` — an out-of-repo copy without
  that cache reads every `class_name` as a Parse Error) and the gate run against it. **Its four
  FAIL lines are byte-identical to FK's.**
- **THE FREEZE HELD**: zero files under the repo were modified after the acceptance run was
  launched, checked by mtime against the launch timestamp.
- **THE FIRST ACCEPTANCE RUN IS NOT THIS ONE.** It found seven reds — the four duplicate display
  names and the cache band (§2a), `check_da` §3's corpus mark, and the `check_di`/`check_dj`
  censuses — every one of which is repaired above. **A run that finds reds is reconnaissance and is
  discarded**; this is the run the batch is accepted on.
