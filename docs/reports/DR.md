# BATCH DR — THE ENGINE / AXIS FRAMEWORK, AND THE SWORDMASTER'S POOL

DQ found two grade-2 dominations and measured that the pools vary enormously. This batch repairs
both, widens the most concentrated pool in the game, and records the framework the audit made
visible so future pools are authored against it rather than by feel.

**THE DRAFT MOVES TWICE IN ONE BATCH AND THE NET IS +1: 142 → 143.** Down one for the retirement
(§2), up two for the Swordmaster (§4).

---

## §0 — WHAT THE BRIEF ASKED FOR THAT THE REPO ANSWERS DIFFERENTLY

Four, and all four changed the work. **The brief's own instruction was to derive every number,
including pool sizes, and this is what deriving them produced.**

| the brief said | the repo says |
|---|---|
| **Cooldown manipulation is the Swordmaster's** — "Answering Steel and Battle Poise are the only cards in the game that do it" | **FALSE, and decisively.** `_tick_cooldowns` has **SEVEN** callers. §1 below. **The assertion was not authored.** |
| Revival is the Holy Cleric's — "verify this is already true and report if it is not" | **TRUE AMONG ABILITIES, with a qualifier.** `.revive(` has two call sites; the second is the **Revive Potion**, and the `revive_pct` map event is a third channel. |
| **Shatterpoint is a talent** | It is a **`SPEC_POOLS` BOSS PICK** (and a `CLASS_POOLS["warrior"]` one). The substantive point survives untouched — no *draft* card opened the Break window — but the mechanism matters: the Breaker lane depended on an offer he may never see. |
| Add four axes, **re-author Lunge and author new cards for the rest**, **pool goes 10 → 12** | **The arithmetic does not close.** Four axes minus Lunge is three more, which is three new cards and 10 → 13. **10 → 12 means Lunge plus TWO new cards, so one card carries two axes.** The 12 was taken, because it is the figure the baseline prediction rests on; the designer confirmed it. |

**AND ONE MORE STALE COUNT, FOUND WHILE REMOVING SOMETHING ELSE.** `_hold_freeze`'s header said
**THREE callers** while DO's Cryoclasm had quietly made it four, and named a `force` argument **no
caller has passed since CR** — which `test_batch_ax` already asserts. Corrected with its reason.
It is the same species as the comment §2 deleted, three hundred lines away, and neither was
findable from the other.

---

## §1 — THE FRAMEWORK, AND THE EXCLUSIVE THAT WAS NOT ONE

Two things were both being called "axis". Recorded in `CLAUDE.md`:

> **An ENGINE is the spec's own currency** — stances, Loyalty, Focus, Resonance, Ruin, Faith,
> Mercy, Burn, Chilled, Frenzy, Block. **Exclusive by construction, one per spec.**
>
> **An AXIS is an effect type** — single-target damage, area damage, healing, shielding,
> mitigation, control, tempo, Break, resource generation, meter manipulation. **Shared,
> deliberately.**
>
> **Adding axes to a spec does not dilute its identity; the engine still gates everything.**

**THE EXCLUSIVES ARE ASSERTED AS PROPERTIES AND NEVER AS COUNTS**, in `check_dr` §§1–3, because
this is the third batch running whose brief mis-stated a population: DN's gate asserted two
exclusives and there were five, DO's brief asserted nine grant-capstones and there were
twenty-two, **and DR's brief asserted three exclusive axes when one of the three was false.**

### COMPANION SUMMONING — THE BEASTMASTER. TRUE.
Derived over the whole corpus rather than over his kit: `special: "summon"` exists on **exactly
three** abilities and all three are his protected core. `_do_summon` is the only thing that puts a
body on the field and its only other caller is **Call the Wilds**, his own draft card. A summon
authored anywhere else fails the gate — the negative control put one on the Sharpshooter and it
red.

### REVIVAL — THE HOLY CLERIC, AMONG ABILITIES. TRUE, WITH THE QUALIFIER PRINTED.
`BattleUnit.revive()` has **two** callers in `battle.gd`: `resurrection` (hers, and the only
ABILITY that reaches it) and the **REVIVE POTION**, which any hero may drink. `events.gd`'s
`revive_pct` is a third channel. **Exclusive as an ability; not exclusive as a channel** — the
gate asserts the count at 2 so a *third* caller, which would be a second reviving ability, trips.

### COOLDOWN MANIPULATION IS **NOT** THE SWORDMASTER'S, AND THE CLAIM IS THE USEFUL RECORD.
`_tick_cooldowns` has **seven** callers:

| site | owner |
|---|---|
| `battle.gd:8257` | **Answering Steel** — Swordmaster draft card |
| `battle.gd:8263` | **Battle Poise** — Swordmaster draft card |
| `battle.gd:16629` | **BLINK — A MAGE CLASS-WIDE DRAFT CARD.** Its own comment: *"AXIS: tempo, not damage. It goes through `_tick_cooldowns`, THE one implementation."* |
| `battle.gd:15150` | **BLESSING OF ZEAL — the Devout's PROTECTED CORE**, ticking the target's cooldowns on cast |
| `battle.gd:11608` | **Frostbound Hours** (`cr_frostbound`, Cryomancer Thaw r8) — **every hero's** cooldowns |
| `battle.gd:3795` | **Practised Hands** (`sv_practised`, Survivalist Guerilla r8) |
| `battle.gd:9787` | **Follow-Through** (`ss_follow`, Sharpshooter Tempo r5) |

Five more sites clear a cooldown **outright** through `cooldowns.erase` — Sever against a Broken
target, Hex of Ruin's perfect, Apex Predator, Overkill, Mark of the Hunt — plus Terminal Velocity.

**THE RULE THIS PRODUCED, AND IT IS THE PART WORTH KEEPING:** *before declaring an axis exclusive,
derive the population that touches it.* **A one-door helper that "only two cards call" is the
shape this went wrong in — a single implementation reads like a single owner and is not the same
thing.** What IS one implementation is the FUNCTION (BQ extracted four hand-written copies); what
is shared is the axis. `check_dr` §3 asserts the axis is SHARED and names all seven as an
asymmetric ratchet.

---

## §2 — FLASH FREEZE IS RETIRED, AND THE SUSPENSION WAS DELETED RATHER THAN UPDATED

**THE CARD.** Comments and cosmetics stripped, its handler and Glacial Prison's were the same
three steps in the same order. Glacial Prison is cheaper (25 v 30), shorter on cooldown (4 v 5),
faster (2.5 v 3.0) **and is in `RECAST_GATED` where Flash Freeze was not** — so the dearer card
was also the only one of the two that could be spent on an enemy already held, with the turn gone.
The Cryomancer's pool goes 12 → 11 and can afford it. **`check_dr` §4 asserts the SURVIVOR is
still there**, because retiring the wrong half of the pair would pass every other assertion.

**THE MECHANIC IS NOT THE CARD.** Four Chilled stacks still flash-freeze — that is
`_apply_status`'s own branch, one of `_hold_freeze`'s callers, and it belonged to no ability. The
gate asserts it survived.

**THE COMMENT.** It suspended *"no ability may be a strictly better version of another in the same
pool"* for two named reasons, **and both were dead**: the acquisition channel died at DO (Glacial
Prison became draftable) and the Perfect died at CR (`test_batch_ax` asserts the `force` argument
gone). Neither batch touched the comment, so the exception stood for two batches reading as a live
decision. **A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS IS WORSE THAN AN UNDOCUMENTED
ONE, BECAUSE IT READS AS DELIBERATE** — an undocumented one gets found by the next audit; a
documented one gets believed. Recorded in `CLAUDE.md`'s traps with the shape to sweep for:
*"strictly worse, but acceptable because X and Y"*.

### EVERY SITE THAT READ THE CARD BY NAME — THIRTEEN LIVE, AND NONE IN RUNES, TALENTS OR THE GLOSSARY

| file | what |
|---|---|
| `scripts/classes.gd` ×3 | the pool entry, the card def, **the suspension comment** |
| `scripts/battle.gd` ×5 | the handler, the auto-target list, the ungated-cards note, `_hold_freeze`'s header, `_apply_status`'s carve-out note |
| `test_batch_bt.gd` ×5 | the card table (`NINE` → **`BT_CARDS`**, because a const named NINE holding eight is this project's oldest defect), the `_definitions` loop, the driver call, `_live_flash_freeze`, **and `_one_shield_door`'s slice anchor** |
| `test_batch_cb.gd` | a comment naming its `_hold_freeze` idiom — re-pointed at Glacial Prison, which uses the same one |
| `test_batch_ax.gd` ×2 | the comment and the **failure message**. The assertion itself is general (nothing may FORCE a freeze) and **stays**; only the message moved, because a failure naming a card that no longer exists sends the next batch looking for the wrong thing. |
| `check_cv.gd` | the 220-name roster |
| `CLAUDE.md` ×3, `docs/master.html` ×2 | prose and the card table |

History — the changelog, `design-notes.md`, the CY and DQ reports — is **not** edited. It is the
record of what each batch believed.

**`_one_shield_door`'S ANCHOR IS THE ONE WORTH NAMING.** It sliced from `"funeral_pyre":` to
`'\n\t\t"flash_freeze":'`. With the case gone, `find` returns −1 and the slice runs to end of file
— **which the length assertion beside it catches**. It would have failed LOUDLY rather than
silently, which is exactly what an anchored slice is for, and it is re-pointed at the case that
follows Funeral Pyre now.

---

## §3 — BATTLE POISE: THE DEFENSIVE GUARD BUYS A FREE GUARD CHANGE

DQ's Finding 2 was that its whole payload was a subset of Answering Steel's — cheaper (20 v 25),
longer (6 turns v 4), ungated, paying the same `_tick_cooldowns` constant **plus** +20% parry and
15 Rage a parry. **Its stance requirement was pure cost with nothing bought by it**, which is what
made the domination inevitable rather than accidental.

**ONCE A TURN, A PARRY NOW LETS HIM GUARD CHANGE WITHOUT SPENDING AN ACTION.** Answering Steel
cannot have it: it has no stance requirement to reward. The two are no longer nested, and the
stacking-partners comment at the parry site stands — it answered *do these combine* and never
answered *which do you take*, and a three-card offer only ever asks the second.

**FOUR THINGS ARE BOUNDED, ALL FOUR THE DESIGNER'S RULING:**

- **THE PIVOT ONLY** — `_swordmaster_switch`, not the ability's payload. Guard Change's own 15 BD,
  **SUNDER GUARD's 40 BD to every enemy**, No Quarter and Tempo stay on that card, for the reason
  `_swordmaster_switch`'s own header gives. **A Defensive Swordmaster holding Sunder Guard and
  parrying twice a turn would otherwise land 80 free Break damage across the field every turn.**
- **ONCE A TURN**, not once a parry, and it does not bank. The flag is per-HIS-turn, cleared in
  `_player_turn` beside `watchtower_used`, which is the same shape for the same reason.
- **THE COOLDOWN TICK STAYS** and still pays on every parry.
- **IT RESPECTS GUARD CHANGE'S OWN 1-TURN COOLDOWN**, and **starts** it — respecting a cooldown a
  use does not pay into is respecting it exactly once.

**ONE CALL DOES ALL OF THAT.** The site asks `_ability_usable` about the **real** Guard Change
rather than re-deciding, which is what keeps three promises from ever disagreeing: **FORMLESS
refuses it** (there is no stance to change), the cooldown is respected, and the cost is checked
even though it is zero today. That is BW's door, used for the thing it was built for.

**AND THE PIVOT IS NOT FREE OF CONSEQUENCE:** it throws away **DISCIPLINE's** accumulation, like
every other call to the one pivot. A Discipline build wants it refused and gets that by not
holding the card. That interaction is recorded rather than discovered later.

---

## §4 — THE SWORDMASTER GAINS FOUR AXES ON THREE CARDS, 10 → 12

**WHAT THE POOL WAS.** Derived: ten cards making **four decisions** — DMG-ST/ENEMY-ONE ×4,
STANCE/SELF ×3, TEMPO/SELF ×2, DMG-BURST/ENEMY-ONE ×1. A player who had drafted four cards had
seen everything it decides. His healing, area damage, control and party buff were all in the
Warrior class pool, which is one card in four.

**WHAT IT IS NOW: twelve cards on eight decisions.** Every one of the three reads the stance
engine, and BW's rule decides how: **READERS BRANCH AND FLIP; GATED ONES REQUIRE AND STAY.**

### LUNGE, RE-AUTHORED ONTO BREAK — the sharpest gap, and the reason it was the card to take

An entire **BREAKER** lane is built around a Break window — Punishment, Off Balance, Guard
Breaker, Overpressure and No Quarter all live inside it, and **Sever's cooldown clears against a
Broken target** so the window can be swung through — and **not one draft card opened it**.

**TWO CHANGES AND NOTHING ELSE MOVED.**

- **COOLDOWN 0 → 3.** Of 142 draft cards only Lunge and Pyroblast repeated every turn, where all
  twelve cooldown-zero abilities in the protected cores are the free basic attack. **At the end of
  a lane the price was the node; in a pool there is no price** — and a Break-window opener with no
  cooldown is also the shape that never lets the window close. **Pyroblast is still on that list
  and that ruling stays open.**
- **THE GUARD DECIDES WHERE THE BREAK LANDS.** AGGRESSIVE puts **15 more Break** into that one
  enemy; DEFENSIVE puts **12 Break on every OTHER enemy**, because he does not overreach and the
  recovery leaves the whole line off balance. The target does not pay the breadth number as well —
  paying it twice would make the Defensive branch the deeper one and delete the trade.

Damage 35 → 30, because it is a Break card now and not a damage card. **SHATTERPOINT KEEPS ITS
TITLE** at 40 Break in one blow, so the boss pick's own text stays true. **It stays an ORDINARY
ATTACK** — a `special` would hand-roll the blow and lose the crit, the armour read, the parry
roll, Overwhelm, Off Balance and Whetstone (BT's Arcane Bolt rule) — and both riders sit where the
wound rider already lives, reading the same `_eff_stance`, so a Feigned Guard moves them together.
**SUNDER GUARD is the deliberate partner and not a duplicate**: that node re-points GUARD CHANGE
into a field-wide Break blow; this is a STRIKE whose recovery spreads a smaller one.

**The `BATCH DO — THE TWENTY-TWO` block's header claimed all twenty-two were verbatim. It says so
no longer**, and names Lunge as the one exception with the reason. The other twenty-one are
untouched.

### WHEELING CUT — AREA DAMAGE **and** SELF-MITIGATION, the card that carries two

30 Rage, 2.5, 4cd, `aoe`: **every enemy takes 20% of Attack and 12 Break**. His pool had **no area
damage at all**; his only field-wide option for a whole run was Cleave, out of the class pool.

A **reader**, so BP's arriving-stance principle decides both branches — **the thing that would
most easily be got backwards**: cast from AGGRESSIVE he lands DEFENSIVE, so the branch hands him
**defence** (20% less damage taken, 3 turns); cast from DEFENSIVE he lands AGGRESSIVE, so it hands
him **offence** (+20% damage dealt, 3 turns). He is never stranded — he always arrives holding
something. **PERFECT: BOTH GUARDS' GIFTS AT ONCE**, which is the one bonus that could only belong
to this card, because the branch *is* the card.

**THE SWEEP IS THE PIPELINE'S AND NOT THE HANDLER'S** — real `damage` and `pressure` with `aoe`,
exactly as Cinderfall and Blizzard are — so the crit, the armour read, the variance roll,
Overwhelm, Off Balance and Whetstone all come free and the handler is nine lines. Two new statuses
on FORMLESS's precedent: the two arrivals are different states and one chip could not say which
guard bought it.

**IT NEEDED A PERFECT AND THAT IS `test_batch_bo` §5's BICONDITIONAL DOING ITS JOB.** The card
runs a bar, so it must state one; the suite caught the omission on the first run. DO left two
named debts there (Rampage, Pyroblast) and **this batch adds no third.**

### COUNTER TIME — CONTROL, on a pool that could not take an enemy's turn away at all

25 Rage, 2.0, 5cd, **requires the Defensive guard**: one enemy loses its next **TWO** turns, and
the card deals **nothing** — no damage, no Break, no Rage. **POMMEL STRIKE is his only Stun and it
is protected core**, so a whole run's control was one core ability's one-turn rider.

**IT IS NOT A SECOND POMMEL STRIKE.** That card is cheaper (20 v 25), ungated, deals 25% of
Attack, lands 30 Break, builds 10 Rage, carries a keen 25% crit and Stuns for ONE turn. This buys
a SECOND turn for a stance and a whole action that pays nothing. **Neither dominates**: the core
card is the better attack and this is the better answer, and the only board on which this is the
pick is one where a turn is worth more than a blow.

- **GATED, NOT A READER.** Refused at `_ability_usable` — a Feigned Guard genuinely lets an
  Aggressive Swordmaster cast it, a Formless one satisfies it outright — and **it does not flip
  him**, which `check_dr` asserts at the source AND drives live.
- **THE BOSS RULE IS INHERITED, NOT RE-WRITTEN.** `stunned` is one of the five ids
  `_apply_status`'s carve-out refuses on an unbroken boss, and this passes **no `force`**. A
  second test here would be a second rule.
- **IT RUNS NO BAR AND SO ADVERTISES NO PERFECT** (CV §3): no damage, no heal, no Break damage, and
  `counter_time` is in neither `DAMAGE_SPECIALS` nor `HEAL_SPECIALS`.
- **IT JOINS `RECAST_GATED`; WHEELING CUT DELIBERATELY DOES NOT.** Its entire payload is a status,
  so a recast onto a saturated field buys literally nothing (BO §5). A card that deals damage is
  never a wasted cast, which is why no damaging card is in that list.

**PRECISION STRIKE AND FEINT ARE UNTOUCHED** — BW's original readers, and the branch-and-flip
pattern is the spec's signature.

---

## §5 — WHAT IS DELIBERATELY NOT DONE

- **NO OTHER POOL IS TOUCHED.** The Beastmaster's 8-of-8 companion binding, the Cryomancer's
  remaining 11-of-11 ice and the Pyromancer's one-currency problem are reported and **unruled**.
- **THE HUNTER CLASS GAP IS NOT ADDRESSED** — three shallowest pools, none of DO's twenty-two, and
  not one of its twenty-four spec cards is a heal, a shield or mitigation. **Bigger than the
  Swordmaster's and it is next, not now.**
- **NO TALENT MOVES. NO CELL CHANGES ROW OR LANE, SO NO MIGRATION IS NEEDED**, and no save version
  moves. `Talents.LANES` is untouched and `Profile` stays v2.
- **PYROBLAST IS STILL COOLDOWN-ZERO.** DQ's ruling — price the repeatable cards or write down
  that a repeatable card is a legitimate draft shape — is answered for Lunge by re-authoring it
  and left open for Pyroblast.
- **`SPEC_POOLS` STILL HOLDS LUNGE AND EXECUTE ALONGSIDE THE DRAFT POOL**, so both are reachable
  through two channels. Reported, out of scope, and worth a ruling with the rest of the boss-pick
  pools DQ dumped and did not audit.

---

## §6 — VERIFICATION

**THE DOCUMENTATION WAS WRITTEN BEFORE THE RUN**, except the three documents no suite and no gate
reads (below), which is DP's and DQ's allowance.

### THE NAME SWEEP — BR §1, OVER 1,127 LABELS

Every ability `display_name` in `classes.gd` and `talents.gd`, every talent node **name and id**,
every `STATUS_INFO` **id and label**, every rune name, and every pool entry. **Both new names come
back clean on all three tests** — exact match, containment either way, and shared word with stop
words removed. **A near-miss was treated as a hit**: `Stop Thrust` was rejected for sharing
*thrust* with `sm_lunge` "Committed Thrust", the Swordmaster's own row-2 node, which is the
`wd_spiked`/Spite shape.

### THE PROPERTIES, AND FOUR NEGATIVE CONTROLS THAT ALL BEHAVED

| control | result |
|---|---|
| A `special: "summon"` ability authored onto the **Sharpshooter** | **RED** — 1 failure, naming the spec |
| A **third `.revive(` call site** added to `battle.gd` | **RED** — "3 call sites, not 2" |
| A `_tick_cooldowns` **caller removed** (Blink's) | **RED** — "7 mentions; 8 expected — a caller has GONE" |
| The retired card's name put back **as a COMMENT** in `classes.gd` | **GREEN** — 0 failures naming it. The comment-stripping works. |
| The same name put back **in CODE** | **RED** — 4 failures: the def, the pool, the spec half, the total |

**THE LAST TWO ARE ONE CONTROL RUN FROM BOTH SIDES** and it is the one that mattered most: this
batch's own `classes.gd` prose *records the retirement by naming the card*, so an un-stripped
absence check would have read the record as the removal not having happened.

### `check_dr` DRIVES ALL THREE CARDS AND THE FREE PIVOT ON A LIVE BOARD

A def that resolves is not a card that works. §9 spawns a board through `gate_fixture.gd` — the
one authored fixture — and asserts: Counter Time refused from Aggressive and allowed from
Defensive **and from Formless**; that it Stuns for 2 and **does not flip him**; Wheeling Cut's two
branches granting the correct arrival in each direction and flipping both times; the Perfect
granting both; Lunge's Aggressive branch leaving a bystander's meter **untouched** and its
Defensive branch moving it. Then, with the parry forced to 100% **against a melee attacker** —
only a melee attack can be parried, and the fixture's board carries an archer, so picking the last
living enemy would have measured the ranged refusal and read as the clause being dead — Battle
Poise's free pivot fires, spends its flag, **refuses a second parry in the same turn**, is refused
under **Formless**, and is refused while Guard Change is on cooldown.

**IT NEEDS NO `check_da` §3 `WALK_EXEMPT` ENTRY.** It reads only the SPEC draft pool and takes the
class half off the constant, so the two-call fingerprint does not match — and, for the reason DO
learned the hard way, its header does not spell the other call out either.

### PREDICTED BASELINE MOVEMENTS, DERIVED BEFORE THE RUN

| row | from | to | why |
|---|---|---|---|
| `test_batch_bt` | 458 | **407** | the retired card's table row, its `_definitions` entry and the whole of `_live_flash_freeze` |
| `check_co` | 297 | **301** | `counter_time` joins `RECAST_GATED` |
| `check_dr` | — | **79 / 0** | new row, new gate, `GATES` goes 21 → 22 |
| `check_de` | 301 | **305** | four assertions per target, and this batch adds one target. **It has no row of its own** — it is the differ. |
| `check_di` | 44 | **44** | count unchanged; its `CALL_SITES` **const** moved 203 → 205, with the reason in the gate's own comment |
| targets in the manifest | 73 | **74** | |
| the draft total | 142 | **143** | 119 spec + 24 class-wide |

**`check_di`'S EQUALITY TRIPPED AND THAT IS WHAT IT IS FOR.** Net +2 call sites: the retired
card's stamped `chilled` application went with it, and three arrived — Wheeling Cut's two grants
and Counter Time's Stun. **`with_src` did not move, and that is arithmetic rather than luck**:
Counter Time passes its `attacker`, exactly replacing the stamped site the retirement took, and
the two Wheeling Cut grants are self-buffs on the hero that nothing Harvest-shaped reads. The
unstamped remainder goes 97 → 99.

### THE LITERAL SWEEP

**10,415 literals at a floor of 4**, from all 78 suites and gates, evaluated against twenty
documents and sources, diffed against `git show HEAD` in one pass.

**7 LOST, and every one is accounted for:**

| literal | why it went, and why nothing breaks |
|---|---|
| `Cold Snap`, `Second Prison` | in the retired card's SYNERGY comment. Both are read by `test_batch_as`'s **talent-node table**, asserted against `talents.gd`, not `classes.gd`. |
| `Exposes` | Lunge's old description. Read by `check_do`'s `STATUS_FORMS`, which matches **`Talents.desc_for`** output, not card text. |
| `_hold_freeze` | the suspension comment. Its only suite use is a **`scene.call`** in `test_batch_cb` — a runtime call, not a source `contains`. |
| `REPORTED, NOT RE-TUNED…`, `flash_` (×2) | **`check_dr`'s own NEGATIVE needles.** Their absence is the assertion. |

**No document edit lost a single literal** — the second sweep, taken after CLAUDE.md, master.html
and the changelog were written, added zero to that list.

**69 GAINED, and the dangerous kind is zero.** Every negative `contains` in the tree was located
and cross-referenced against the gained set. Five matched, and all five are **scoped to a slice**
rather than reading a whole document: `check_dr`'s own (the Counter Time case body),
`test_batch_bw` ×2 (the `feigned_guard` case body and the Seasoned Fighter mitigation branch, both
bounded by their own end anchors, both still green at 551/0), and `test_batch_ak` ×2, which read
**the runtime combat log** rather than a file — and no new `_log` or `_message` string in this
batch contains the word they refuse.

### THE COMMENT-STRIPPED DIFF

**Proving "no comment insert ate code" the way DR's own CLAUDE.md entry says to.** With every
line-leading `#` stripped, `battle.gd` lost **17** code lines and gained 93. All seventeen are
accounted for: the retired handler (13 lines) plus four lines this batch deliberately replaced
(the Battle Poise chip, its cast log, the recast-target list, and Lunge's inlined `_eff_stance`
call). `classes.gd`'s losses are the retired def and pool entry and three replaced descriptions.
**Nothing was swallowed.**

### THE PARSE FLOOR, WITH ITS CONTROL

`check_parse` reads **0 `Parse Error` and 0 `SCRIPT ERROR` on the stderr grep**, never the tally
and never the exit code. **The control was run**: a deliberate `func _dr_negative_control(:` at the
foot of `battle.gd` produced `Parse Error: Expected parameter name.` and the tree read clean again
once restored **from a scratchpad backup rather than by `git checkout`**.

### EXPECT `at`, `bo` OR `test_rune_battle` BACK

Fourteen consecutive quiet readings on rows that red about **one in eighteen**. `test_batch_at`'s
unseeded §1 ratio, `bo`'s §5 NULL FIELD flake and `test_rune_battle`'s pierce are all still open,
still unseeded and still banded. **A red from any of them is not this batch's.**

---

## §7 — THE BATTERY, AND WHAT CERTIFIED THE DOCUMENTS

**TWO BATTERIES. BATTERY 2 IS THE ACCEPTANCE RUN BECAUSE IT CAME BACK CLEAN.** 161 files were
MD5-stamped before it and re-compared after and **not one moved**.

| | DQ's acceptance | DR battery 1 | DR battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | **3** (`bp`, pre-existing, repaired) | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 301 / 0 / 0 | 305 / 1 / 3 | **305 / 0 / 0 — exactly the prediction** |
| targets in the manifest | 73 | 74 | **74** |

**SEVENTY-FOUR TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-FOUR. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log.** `test_batch_an` read 6051 and `test_batch_bk` 129, both inside their
bands; harness gates 22 / 165 / 8; `check_ct_map` 83 / 0; `check_dr` **79 / 0**.

### BATTERY 1 WAS NOT DISCARDED — IT IS WHAT FOUND THE TWO THINGS WORTH FINDING

**`test_batch_bp` WENT 0 → 3, AND IT IS NOT THIS BATCH'S RED.** §7 hand-builds a Warrior kit to
reach the 7-slot cap and then TAKES `cands[1]`, a card drawn at random from his live draft pool —
and two of the three hand-written filler names, **LUNGE and EXECUTE, have been IN that pool since
DO**. A draw landing on either made the hand-built kit already own the card the take is about, so
`take_draft_ability` returned *"already known"* and three checks went red **with nothing whatever
wrong in the product**. **DERIVED, NOT ASSERTED:** all three replacement fillers (Sweeping Strikes,
Shatterpoint, Rallying Shout) were checked against every spec and class draft pool and appear in
none, where Lunge and Execute appear in the Swordmaster's — so no draw can collide. **And DR's own
two new cards made it LESS likely, not more**: the pool went 10 → 12.

**THREE BASELINE ROWS ROSE THAT DR HAD NOT PREDICTED**, and `check_de`'s asymmetric ratchet
reported all three as NOTICES rather than reds, which is what that asymmetry is for:
`test_batch_bo` 1064 → **1070**, `test_batch_cb` 1196 → **1197**, `test_batch_ce` 1138 → **1139**.
All three are their own loops walking the net +1 draft card. **All five moved rows moved in the
batch that caused them**, which is `baselines.json`'s own rule.

### THE DOCUMENTS WRITTEN AFTER THE ACCEPTANCE RUN, AND HOW EACH IS CERTIFIED

`docs/state.md`, this report, `docs/draft-audit.html`'s three resolution banners and
`docs/design-notes.md`'s two entries. **The first three are read by NO suite and NO gate** —
derived, not assumed: a code-only grep over all 78 suites and gates finds not one line opening
`state.md`, `docs/reports/` or `draft-audit.html`.

**`design-notes.md` IS read, by three suites, and the certification is a LITERAL SWEEP rather than
an assumption.** All three read it for a positive `contains("Batch BN" / "Batch BS" / "Batch CE")`,
which an APPEND cannot remove, and **no negative `contains` in the tree reads that file at all**.
The sweep was taken a third time after every document edit and diffed: **0 LOST in `CLAUDE.md`,
`master.html`, `changelog.html`, `design-notes.md` and `draft-audit.html`** — so every `contains`
assertion in the tree reads exactly what it read during battery 2. `state.md` lost 26 literals and
that is irrelevant, because nothing reads it; **the seven LOST across the whole batch are the seven
named in §6 and not one of them is in a document.**

### THE FREEZE

`docs/draft-audit.html` and this report were the only two files to move during battery 1, and
**nothing moved during battery 2**. Both were re-stamped and diffed rather than assumed.
