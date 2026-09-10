# BATCH FT — THREE SPINES, BUILT ON NOBODY

**THE FIRST BATCH ON `class-merge`.** Nothing was merged, no spec dissolved, no pool moved, no
engine became a rune, no talent node moved and no hero gained a meter. **`main` is untouched and
still playable.**

**MOMENTUM (Warrior), CHANNEL (Mage) and SANCTITY (Cleric) exist as machinery with no owner.**
They are declared, they are driven, they pay what they compute — and **nothing in `scripts/` or
`data/` can reach any of them.** `check_ft` §0 asserts that, and it is the assertion that inverts
the day a spine is attached.

---

## §0 — NOTHING IS ATTACHED, AND THAT IS ASSERTED RATHER THAN STATED

**The safety property is three switches.** `momentum_active`, `channel_active` and
`sanctity_active` are declared on `BattleUnit`, default FALSE, and **nothing under `scripts/` or
`data/` assigns one.** Every payout opens with its own switch and returns its identity value
without it — `0.0`, `1.0`, `0`.

**`check_ft` §0 asserts it four ways**, because "nobody holds one" can be satisfied in three
different places and a check that only asked one of them would pass a real attachment:

| Arm | What it asks |
|---|---|
| §0a | **No spec passive names one.** `SPEC_INFO[spec]["passive"]` is what `passive_id` is stamped from — the table a spine would have to enter to be attached at all. Twelve specs, asserted as twelve so the sweep cannot be vacuous. |
| §0b | **Nothing under `scripts/` or `data/` assigns a switch.** A comment-stripped sweep over 25 files, matching an assignment shape rather than a mention, with the `var` declaration excluded by construction. |
| §0c | **The matcher can bite.** The same code run over a constructed line finds the assignment and NOT the declaration beside it. A zero in §0b means nothing without this. |
| §0d | **Driven.** A live four-spec party spawns with all twelve switch readings false and all twelve payout readings at their identity value. |

**THE INVERSION IS THE POINT.** The batch that attaches a spine takes §0 red and has to rewrite
it — `check_ez` §1 and `check_fk` §2 have both been through exactly this, and both were better for
it. The control confirms it: **giving one hero Channel in `scripts/unit.gd` reds §0b, §0d and §1d
at once.**

### WHAT THE DISPLAY WILL NEED, REPORTED AND NOT BUILT

**No display is built and none is needed yet** — nothing reads these in a real run. What the
attaching batch will meet, measured rather than predicted:

- **THE NAMEPLATE BAR BREAKS BY CONSTRUCTION AND CANNOT BE WIDENED CHEAPLY.** `unit.gd`'s
  second-resource block is ONE fill, ONE colour chosen by a ternary on the NAME, and ONE label.
  A hero carrying a class core AND a spec meter has two currencies and one bar.
- **THE GAME ALREADY ANSWERED THIS THREE TIMES AND NEVER WIDENED THE BAR.** Faith, Loyalty and
  Ruin all live outside `second_resource` and all three display as STATUS CHIPS. A chip is the
  existing answer and it costs nothing new.
- **AND `second_resource_name` IS THE DISCRIMINATOR, WHICH IS THE REAL BILL.** 26 sites in
  `unit.gd` and 196 in `battle.gd` read that field or its name, and `unit.gd`'s own comment warns
  that read sites are written against the NAME "never against the FIELD". Every one of them is
  *which currency is this?* asked of a field that holds one.
- **SO THE RECOMMENDATION IS A CHIP, NOT A SECOND BAR** — and it is a recommendation, not a
  decision. **A chip cannot show a fill**, which is what a ramping meter most wants to show, and
  that is the trade the designer is being asked to make.

**AND `second_resource` IS THREE CURRENCIES, NOT FOUR — FP's premise 6 re-verified.** It is written
in exactly three places (Resonance, Mercy, Focus). **Faith is `faith_stacks`**, a separate int on
every ally, and `faith_cost` is a misnamed MERCY cost — `classes.gd:1291` says so in as many words.

---

## §1 — CHANNEL: BUILDS ON THE COST, PAYS SPELL DAMAGE

**FP's two findings both held.** `note_resource_spent` is generic in shape and books the NET off
the bar at the one line every ability in the game pays through; `dmg_bonus` is read at **exactly
one site** — `battle.gd:9770`, the whole general damage multiplier in the game. Both verified at
the site, not quoted.

### THE BUILD HALF IS TWO LINES AND A SECOND FIELD

`note_resource_spent` opened `if amount <= 0 or resource_name != "Rage": return`. It now books
Rage into `rage_spent` and **Mana into `mana_spent`**, and the paragraph above it was already a
description of a PROPERTY rather than of Rage: measuring the bar catches the waivers, the
discounts, the refunds and the clamp at zero for either currency without knowing any of their
names.

**TWO FIELDS AND NOT ONE, WHICH IS EM'S CHARTER APPLIED.** `rage_spent` holding Mana is a name
that lies — FO §1's objection to `rune_hex_threshold` — and a shared field would make Blood
Frenzy's second term readable by a Mage, which is the failure `check_em` §2 exists to catch from
the other side. Driven: a Mage's spend lands in `mana_spent` and NOT in `rage_spent`, and the
reverse.

### IT CANNOT SEE WHAT WAS CAST, AND THAT IS ASSERTED AGAINST THE SOURCE

**`check_ft` §1a reads the function's own body and requires it to name no `dmg_type`, no `ab.`, no
ability, no `display_name`, no school, no element and no `is_spell`.** A driven check cannot prove
this: a function that reads the ability and happens not to branch on it today passes every drive
that exists. The control — teaching the build half to declare a `dmg_type` local — reds it.

### THE PAYOUT, AND THE ONE RULING INSIDE IT

**There is no `is_spell` flag on `Ability`.** The available partition is `dmg_type` — arcane /
nature / shadow / holy / physical / fire / frost — so *spell damage* has to mean **not physical**,
or Channel pays into all damage and buys the basic attack with it.

**IMPLEMENTED AS `CHANNEL_SPARES_PHYSICAL := true`, WHICH IS THE RULING'S ONE LINE.** Flipping the
constant is the whole of the other reading. **This is flagged, not tuned** — the machinery had to
take a position to be drivable at all, and the position is one word.

### FLAGGED, NOT TUNED — THE RATE, AND WHAT THE METER ACTUALLY READS

**The three constants are placeholders and are named as such in the code:**

| Constant | Value | What it decides |
|---|---|---|
| `CHANNEL_MANA_PER_STEP` | 40 | how much Mana a step costs |
| `CHANNEL_MAX_STEPS` | 6 | the cap |
| `CHANNEL_STEP_BONUS` | 0.03 | +3% spell damage a step, so +18% at the cap |

**AND HERE IS WHAT A MAGE'S METER ACTUALLY READS, MEASURED WHERE IT COULD BE AND DERIVED WHERE IT
COULD NOT.** The economy first, all of it read at the site: **Mana starts at 100, caps at 100, and
regenerates 12 a turn** (`_mana_regen` is `12 + mana_regen_bonus`; Evocation, the Mage class
passive, adds 10 for 22). The Mage kits: **Pyromancer mean 23.3 a costed card, Cryomancer 26.7,
Arcanist 33.3** — and every Mage's basic attack is FREE, which is the number that matters.

**A DRIVEN AUTOPLAY FIGHT, standard warband, Pyromancer:** he took **6 turns** before the fight
ended and cast Flamewave ×3 (25), Wildfire (20) and the free Fireball ×2 — **95 Mana of net spend
over 6 turns, about 16 a turn**, because he falls back to the free basic when the bar is low.

| | net spend | steps at 40/step | payout |
|---|---|---|---|
| **his 5th turn, at the observed rate** | ~80 | **2** | +6% |
| **his 10th turn, at the observed rate** | ~160 | **4** | +12% |
| **his 5th turn, emptying the bar every turn (the ceiling)** | 148 | **3** | +9% |
| **his 10th turn, emptying the bar every turn (the ceiling)** | 208 | **5** | +15% |

**THE TURN-10 ROW IS A PROJECTION AND IS LABELLED ONE.** A standard warband fight ends before a
Mage takes ten turns — the observed one ended at six — so the rate is measured and the tenth turn
is extrapolated from it. The ceiling rows are arithmetic on the economy and are exact: he cannot
spend more than has entered the bar.

**WHAT THAT SAYS, AND IT IS THE DESIGNER'S CALL:** at 40 Mana a step **the meter barely moves
inside a standard fight** — two steps by turn five, and the +18% cap is out of reach of anything
shorter than a boss. If Channel is meant to be felt in ordinary fights the step wants to be
smaller, and if it is meant to be a long-fight engine it is priced about right. **No number was
picked quietly; all three are here.**

### DRIVEN, AND THE INSTRUMENT'S OWN SCAR

**The live A/B reproduces the payout's own arithmetic to four places: x1.1799 against x1.1800.**
Same card, same caster, same victim, six pairs, order flipped every other iteration.

**THAT NUMBER TOOK FOUR CONFOUNDS TO GET, AND EACH ONE PRODUCED A DIFFERENCE THAT READ LIKE A
FINDING:**

1. **THE VICTIM DIED ON THE CONTROL ARM.** The second arm then read **0** — which is
   indistinguishable from a payout that pays nothing, the exact defect this section exists to
   catch. Closed by restoring `dead`, health, Pressure and the Break state between arms.
2. **THE ARCANIST'S OWN ENGINE RAMPS.** Resonance climbs with every cast and feeds the SAME damage
   pipeline, so alternating cold-then-hot puts every hot arm later — **measured at x1.2422 before
   it was closed** against a true x1.18. Closed by zeroing `second_resource` per strike AND by
   flipping the pair order.
3. **THE FIRST READING IS A WARM-UP.** It measured 0 twice on a board where every later arm landed.
4. **THE ROLL IS ±10% ON EVERY BLOW.** `randf_range(0.9, 1.1)`. Six-pair sums still left the
   physical control reading between **x0.9537 and x1.0349 across three runs** — a spread that
   swallows a real finding and manufactures a false one in equal measure. **Closed by re-seeding
   before each arm so both draw the same rolls.**

**AND THE PHYSICAL CONTROL HAD TO BECOME THE SAME CARD.** Its first draft used the Sharpshooter's
Aimed Shot and read **x1.1015 on a payout that pays physical exactly nothing** — because his basic
is a SEQUENCE and his Focus climbs. It is now the identical card with `dmg_type` set to
`"physical"` for the pair and put back afterwards, which holds the caster, the victim, the roll,
the order and every ramp fixed. **It reads x1.0000.**

---

## §2 — MOMENTUM: BOTH HALVES OF THE EXCHANGE, PAID IN INITIATIVE

### THE ANSWER TO THE BRIEF'S QUESTION: THE TAKEN HALF EXISTS TWICE, THE DEALT HALF NOT AT ALL

**Damage TAKEN per turn exists in two shapes, both with their semantics already argued out in the
file:**

- **`dmg_by_turn`** — taken, keyed on the GLOBAL turn index, written by `_report_taken` ("the one
  door, so it books what was ACTUALLY removed, below every death refusal") and bounded to two keys.
- **`trance_taken`** — taken **since his last turn**, and its own comment says exactly why it is not
  a read of the other: *"that one is a fixed two-turn window keyed on the GLOBAL turn index, this
  one is the span between one hero's turns."*

**Damage DEALT per turn does not exist in any shape.** What exists is `total_dealt`, a local inside
`_resolve()` alive for one cast, and `_run_dealt`, a run-long hero→ability recap ledger. **So yes —
that was the batch's real work, and it is said here because the brief asked.**

### AND "A TURN" IS THE SPAN, NOT THE INDEX — THE ONE DECISION A READER WILL GET WRONG

**`battle_turn` is stamped from `_turns_taken`, which counts UNIT turns across the whole field.**
A hero deals on index N and is struck back on N+3. **A meter keyed on that index would see the two
halves of one exchange as different turns and never book anything at all** — it would ship, parse,
run, and read zero forever.

**So Momentum carries `trance_taken`'s window**, with **two accumulators of its own** rather than a
read of that field: Battle Trance CONSUMES `trance_taken` (battle.gd zeroes it at every tick), and
a second reader of a consumed accumulator reads zeros it did not earn.

- `momentum_taken` rides `_report_taken`, beside `trance_taken`, below every death refusal.
- `momentum_dealt` rides **`battle.gd`'s new `_book_dealt`**, which hangs off the `dmg_hero_` branch
  of `_stat` — the single site every hero damage credit in the game already passes through, 34 call
  sites and counting. **It is written ABOVE the `sim` branch on purpose**: everything below books
  into one of two places depending on which bot is driving, and a ledger a passive reads has to be
  written on both paths or the meter is blind in exactly the mode the balance simulator measures it
  in.
- **A beast's work is its hunter's for free.** `_contrib_name` has folded a companion into its
  `pack_master` by the time the key is built, so a companion cannot open a ledger of its own.

**THE SPAN IS CLOSED WHETHER OR NOT A STEP WAS EARNED**, and that is not tidiness: leaving a lone
accumulator standing would let a turn he only dealt on pair with a later turn he only took on,
which is the opposite of *both halves, in the same turn*. Driven, both ways.

### THE PAYOUT, AND THE SECOND-WRITER QUESTION THE BRIEF ASKED ABOUT

**`effective_speed()` is a closed list of exactly six terms** — `speed`, `mod_speed_mult`, Slowed,
Chilled, Quick Draw, Wrath — and **five of the six are statuses or a run modifier**. There is no
general per-unit speed multiplier a passive could feed: `mod_speed_mult` belongs to the Frenzied
modifier. Verified at the site.

**WHAT ELSE READS THE SAME FIELD, COUNTED:** `next_time` is WRITTEN at **23 sites** in `battle.gd` and appears at **45** in
all, and `effective_speed()` is read at **16** — both counted on a QUOTE-AWARE
comment strip, because a naive one truncates at the `#` inside a colour literal and under-read
`next_time` by four. The population includes the timeline
seed, the four `BASIC_DELAY` advances, the turn-skip paths, `delay_push` (Shockwave), the
Resonating Hourglass' and Reacquire's pull-forward writes, the Glacial Hold `INF` parking and its
release, the companion's `INF`, and the initiative PREVIEW.

**THE DECISION: A MULTIPLIER ON THE DELAY, NOT A SEVENTH TERM IN `effective_speed()`.**

- A seventh term is **one line**, but that function is what all the `next_time` writes divide by,
  so it bends the timeline **continuously** and compounds with Chilled, Slowed, Quick Draw and
  Wrath at once. **Measured, not argued:** the control that adds one made the live delta read
  **x0.6296** where the engine's own arithmetic says x0.6800 — the compounding, in a number.
- A delay multiplier scales the turn being scheduled **and nothing else**.

**AND IT IS ONE FUNCTION READ AT THREE SITES, WHICH IS `_bond_convert`'S SHAPE AND NOT A SECOND
WRITER.** `_bond_convert` is one body read from five sites and is the project's own precedent for
*one place deciding one thing*. The three:

1. **the post-cast schedule** (`battle.gd`'s `attacker.next_time += eff_delay * 100.0 / ...`);
2. **the gated-failure schedule**, which exists so a lost cast costs the same tempo a landed one
   does — leaving the term off there would have made a Sloppy check the one place his own engine
   stopped applying;
3. **the initiative PREVIEW**, which would otherwise draw a timeline the fight does not honour.

**`check_ft` §2g asserts the count is exactly three and that `effective_speed()` carries no
momentum term.** The control that drops **one** of the three reds the count AND makes the live
delta read **x1.0000** — this project's most common shipped defect, wearing its own name.

### FLAGGED, NOT TUNED

`MOMENTUM_MAX_STEPS` **8** and `MOMENTUM_STEP_HASTE` **0.04** — a step buys 4% off the delay of his
next turn, to −32% at the cap. **Driven live through `_resolve`: the delta reads x0.6800 exactly.**
**The rate is the designer's**, and the shape of the question is: eight exchanges is a long fight,
and −32% initiative is roughly a free turn every three.

---

## §3 — SANCTITY: AN EVENT COUNTER, AND THE POTENCY LAYER MEASURED BEFORE IT WAS BUILT

### THE READING HALF, AND WHY IT IS NOT TRAPPER'S

**FP's premise-9 correction held and it is load-bearing.** `battle._status_count` — Trapper's
breadth term — reads **a target's status LIST at strike time**, over the curated `DEBUFF_IDS`
allowlist: one body, debuffs only, a SNAPSHOT. **Sanctity counts APPLICATION EVENTS**: any status,
any body, any source, as they happen.

**The two cannot substitute.** A status that lands and leaves is **invisible** to the state reader
and is a real event to the counter; a status standing since turn one is the reverse. `check_ft` §3a
drives exactly that case and asserts both instruments at once.

**THE FUNNEL IS `add_status` AND THE COUNT LIVES ON ITS NEW-ENTRY PATH.** `_apply_status` is called
**214** times and calls `add_status` exactly once; **36** further calls reach `add_status`
directly, one of which is `_apply_status`'s own — **249 distinct authoring sites, one door.** The refresh branch returns before the counter, so a
Burn re-applied to a body already burning books nothing: **the event is a status ARRIVING on a body
that did not have it.**

**THE LEDGER IS STATIC BECAUSE THE EVENT STREAM IS GLOBAL.** "From any source, on anyone" means
every holder sees one stream, so there is one count rather than one per holder — and one count
means one place that clears it. `battle._ready()` calls `BattleUnit.reset_sanctity()` above
`_spawn_units`, the first thing that can apply a status; without it the second battle in a process
would open on the first one's tally.

### THE TWO CONSTRAINTS THE BRIEF NAMED

**A STATUS THE BEAST WEARS IS NOT DOUBLE-COUNTED**, and the reason is the shape of the door rather
than a guard: the counter is on the funnel, and the funnel runs **once per body**. A beast is a
body; a status on it books one event, exactly as a status on any hero does. There is no second
site that could book it again — which is the point of putting the count at the funnel rather than
at `_apply_status`, where 36 direct calls would have bypassed it.

**AND WHAT STOPS APPLY-AND-REMOVE FARMING IS ONE SENTENCE: ONE EVENT PER (TURN, BODY, STATUS).**
A status moving on a given body in a given turn is worth exactly one, whichever direction it moved
and however many times. Consequences, all driven:

- **Eight apply-and-remove cycles on one body in one turn book ONE event.** The control that
  removes the dedupe reads **16**.
- **Breadth still pays.** The same status on a second body is a second event, so a Consecration on
  four allies is four. That is the pattern the engine is meant to reward.
- **The cap is per TURN, not for the battle.** The same body and status books again next turn.
- **A removal that removes nothing books nothing.** `remove_status` filters unconditionally and is
  called on bodies that are already clean, so the door counts a DELTA rather than a call.
- **A cleanse books what it actually took.** `purge_debuffs` takes several at once, so the ids are
  captured before the filter — a count alone could not say WHICH left, and the ledger is keyed on
  the status. Three statuses land, the cleanse takes the two debuffs, and it books two.

**AND A RULING: A NATURAL EXPIRY IS NOT A REMOVAL.** `tick_statuses` running a clock out is time
passing, not a hero acting, and a meter that built from it would build for a hero doing nothing —
which is the perpetual-motion shape FC §2 already ruled against on a different meter. **Asserted:
an expiry books nothing, on a fresh turn where a real removal would have booked.**

### THE PAYOUT WAS MEASURED BEFORE IT WAS BUILT, AND THE ANSWER IS NO

**The brief asked three questions before any of it was written. Here are the numbers.**

| Question | Answer |
|---|---|
| How many sites author a status DURATION? | **All 249.** `turns` is a parameter at every application site without exception. |
| How many author a MAGNITUDE? | **81 of 249** pass a non-zero `power`; **26** pass a non-zero `tick`. Across the ids: only **65** ever carry a magnitude at the funnel at all, and **93 of the 156 declared `STATUS_INFO` ids carry none at any site.** |
| Can a single multiplier reach them without touching each site? | **DURATION: YES. POTENCY: NO.** |

**`STATUS_INFO` holds 156 ids and carries `[label, chip tag, colour, tooltip]` — not one
magnitude.** Strength arrives as the per-call `power` and `tick` arguments and everything else lives
in the handler that reads the status. **Every status magnitude in this game is authored per site.**

**SO A GENERAL POTENCY MULTIPLIER WOULD REACH ABOUT A THIRD OF THE STATUSES AND READ AS WORKING**,
which is precisely what the brief said not to ship. **It is not built.**

**WHAT IS BUILT IS THE STAGED VERSION: DURATION ALONE, KEYED ON THE APPLIER.**

- It lands at `_apply_status`, as **the fourth clause of a sentence the file already writes three
  times**: Permafrost, Emberkeep and the two row-8 nodes all lengthen a status SCOPED TO THE SRC.
  A class core paying "duration" is that shape with the scope widened from one status to all of
  them.
- **Off the applier, never off the victim — and that is the difference from Fleeting.**
  `mod_status_turns` is the game's one general duration term. It is read in `add_status`, **off the
  body RECEIVING the status**, it belongs to the Fleeting run modifier, and it is only ever set
  to −1. Sanctity is the other direction, and a funnel that receives no source cannot ask it.
  (FP said this read site was unique; **it is read at two — `add_status` applies it and
  `_status_write_improves` normalises against it**, which that function's own comment explains.
  Both were checked.)
- **The `turns > 0` guard is Emberkeep's guard for Emberkeep's reason:** a negative count is a
  PERMANENCE FLAG, and adding to it would produce a number nothing downstream understands and
  quietly un-permanent a battle-long status. **Driven: a battle-long status stays at −1 in a
  Sanctity holder's hands**, and the control that removes the guard reds exactly that arm.

**AND THE COVERAGE IS COUNTED AND PRINTED RATHER THAN DESCRIBED.** `check_ft` §3i walks
`battle.gd` and reports **CHECKED 214 of 214 `_apply_status` call sites — 110 carry a source, 104
do not.** Those figures were produced independently twice, by a Python instrument and by the gate's
own GDScript walk, and they agree. **93 real-duration applications in the game cannot see this
line, and the 36 direct `add_status` calls have no source parameter at all.** Closing that gap is
139 call sites and is a batch of its own.

### FLAGGED, NOT TUNED

`SANCTITY_PER_STEP` **6** events a step, `SANCTITY_MAX_STEPS` **5**, `SANCTITY_STEP_TURNS` **1** —
so a full meter adds **5 turns** to a status the holder applies, which is a very large number and
is deliberately left where the designer can see it. **A cleric applying two statuses a turn reaches
the cap in about fifteen turns; a party fight generates far more than that from every source at
once, which is the whole question — "from any source, on anyone" is a very wide door and the rate
has to be read against the traffic, not against his own casting.**

---

## §4 — WHAT WAS DELIBERATELY NOT DONE

- **Nothing is attached to any hero, class or spec.** Asserted four ways.
- **No spec dissolved, no pool merged, no engine became a rune, no talent node moved.**
- **No existing engine, rune, card, ability or constant was retuned.** The three edits to live
  behaviour are all inert without a switch: one term added to the damage multiplier sum, one
  multiplier added to three scheduling lines, one addend added to `eff_turns`. All three read their
  identity value for every hero in the game.
- **No display was built.** §0 reports what it will need.
- **Focus was not touched.**
- **A general status POTENCY multiplier was not built**, and §3 says why with the census.

---

## §5 — VERIFICATION

**THE FLOOR:** `check_parse` **181 / 0**, and **`Parse Error` grepped from stderr: 0** — never a
tally and never the exit code. The `.gd` comment corrections made between the two passes were
proved comment-only by a **comment-stripped diff: zero non-blank lines changed**, because a comment
insert has eaten a live line in this project before.

**`check_ft`: 79 checks / 0 failures**, and the three live A/Bs are reproducible run to run:
Channel x1.1799, the same card as physical x1.0000, Momentum's `next_time` delta x0.6800.

**NINE NEGATIVE CONTROLS. ALL NINE BIT, AND EACH PRODUCED A DIFFERENT SIGNATURE** — which is what
makes them nine controls rather than one check firing nine times.

| Control | Reds |
|---|---|
| A hero is GIVEN Channel in `scripts/` | 3 — §0b names the file and the line, §0d reads 8 of 12, §1d's OFF arm |
| The build half is taught to read the ability | 1 — §1a |
| A seventh term is added to `effective_speed()` | 2 — §2g, and §2h's live delta moves to **x0.6296** |
| The (turn, body, status) dedupe is removed | 4 — §3a and all three §3c arms; the churn loop reads **16** |
| The permanence guard comes off the duration payout | 1 — §3h |
| A payout loses its switch guard | 4 — §0d, §3g, and §4's CHECKED 2 of 3 |
| Channel stops sparing physical | 2 — §1d, and §1f reads 888 against 750 |
| **ONE** of the three initiative read sites is dropped | 3 — the count reads 2, and the live delta reads **x1.0000** |
| The cleanse door books a count instead of the ids | 1 — §3f reads 0 |

**The tree was restored byte-exactly after the controls** — all three touched files md5-identical
to the pre-control copies, and the gate back to 79/0.

**THE DOCUMENT EDITS WERE SWEPT, AND THE SWEEP WAS PROVED ABLE TO BITE.** Every string literal of
four characters or more, taken from the **complete reader population of each document** — 64
readers of `CLAUDE.md`, 21 of `docs/changelog.html`, 7 of `docs/design-notes.md`, 12 of
`docs/state.md`, found by the `res://` path — that was present in the live file before the edit:
**1,845 needles, and 1 LOST.**

**THE ONE LOST IS A FALSE POSITIVE AND WAS RUN TO GROUND RATHER THAN WAVED THROUGH.** It is
`check_es.gd`, and it is in the needle set because `check_ek.gd` names `res://docs/state.md` in a
comment and separately carries a `TAG_CHECKERS` list of gate FILE NAMES — one of which happened to
appear in FS's *WHAT MOVED* line, which this rewrite replaced. `TAG_CHECKERS` is about which gates
may name the tag surface and says nothing about this document. **The sweep is over-broad in the
direction that costs a paragraph rather than a battery.**

**AND THE CONTROL WAS ARMED IN BOTH DIRECTIONS.** The needle `TABLE THAT IS A CEILING RATHER THAN
A COST` was chosen **off the needle list** — it is `test_batch_bs`'s, and that suite is the only
reader that carries it — and removing it read **LOST = 1** against the edited copy AND against
HEAD's, so the zero on the real arm is not vacuous. **That literal is exactly what the CLAUDE.md
edit had to work around**: three capped spines joining the governor table make *"THE ONE governor
that is a ceiling rather than a cost"* false, and the repair keeps the asserted substring verbatim
inside a sentence that is true again.

**THE BATTERY WAS RUN TWICE, WHICH IS WHAT A BATCH THAT WRITES AN INSTRUMENT OWES.** Pass 1 put the
**unmodified gates against the new code before any document moved**; pass 2 is the acceptance run
over the shipped tree. Both over a FROZEN tree md5-stamped with **absolute paths** across the whole
working tree, tracked and untracked, so the new gate and the new report are inside the freeze.

**PASS 2, THE ACCEPTANCE RUN OVER THE SHIPPED TREE: 107 TARGETS, ZERO THROWS, ZERO TIMEOUTS, ZERO
INCOMPLETE, AND THE SAME ONE RED.** `check_parse` **181 / 0**, `check_ft` **79 / 0**, `check_de`
**445 checks / 0 failures / 0 notices**, `check_es` **57 / 0**, `check_ed` **18 / 0**, and all four
changelog gates green (`check_dv` 83/0, `check_ec` 23/0, `check_el` 23/0, `check_fg` 22/0).
**`check_fg`'s own report: `CLAUDE.md` is 294,754 B = 287.85 KiB against the 290 KiB ceiling — 2,206
bytes of headroom, and this batch spent 4,148 of them.** That is the tightest this file has been and
it is worth a later batch knowing: **the next standing rule of any size needs a cut somewhere else
first.** **The freeze held: 376 files md5-stamped with absolute paths before and after, ZERO
DIFFER.**

**PASS 1: 107 TARGETS, ZERO THROWS, ZERO TIMEOUTS, ZERO INCOMPLETE, AND ONE RED.** All 47 suites
green. `check_parse` **181 / 0** with the residue still 4 and **`Parse Error` grepped from stderr:
0**. `check_ft` **79 / 0**. `check_de` **445 checks / 0 failures / 0 notices**, so both new baseline
rows landed where they were written. `check_es` **57 / 0**, `check_ed` **18 / 0**, `check_fg`
**22 / 0**, `check_ek` **45 / 0**, `check_fs` **39 / 0**, `check_fr` **25 / 0**.

**THE ONE RED IS THE SANCTIONED `check_cm_live` 13 / 4, AND IT WAS PROVED SANCTIONED RATHER THAN
ASSUMED.** Its baseline note says *"identical on unmodified HEAD"* and does not enumerate the
lines, so **HEAD's `unit.gd` and `battle.gd` were put back and the gate re-run**: the same four
FAIL lines, word for word — the bar on the enemy's attack, its top line, the brace near x0.85 and
its Break half near x0.75. **A count matching a count is not the same claim.** The tree was
restored byte-exactly afterwards and both files md5-verified.

**AND `check_es` WAS RE-RUN AGAINST THE SHIPPED `state.md`**, which is the obligation
`docs/instrument-rules.md` records for a batch that rewrites that file: **57 / 0** after the
rewrite, with the core-kit census phrases still standing in the queue section this batch did not
touch.

**THE PASS-2 FIGURES ARE A POST-RUN EDIT AND THEY WERE PAID FOR RATHER THAN WAVED THROUGH.** Only
`docs/state.md` and this file changed after the acceptance run, and reports are the one file class
no instrument reads — so `state.md` is the whole exposure. **A fresh needle snapshot was taken from
the copy the battery ACTUALLY READ** (1,858 needles across the four documents' complete reader
populations) and swept after the edit: **0 LOST.** Then **every one of `state.md`'s twelve readers
that is a battery target was re-run against the shipped copy**: `check_es` 57/0, `check_ek` 45/0,
`check_fr` 25/0, `check_dm` 93/0, `test_batch_aj` 420/0, `test_batch_as` 399/0, `test_batch_at`
477/0, `test_batch_aw` 355/0, with `Parse Error` grepped from stderr at 0 for all eight. **The
shipped tree is the verified tree.**

**THE SAVE BACKUP:** the designer's four files were copied to `save-backups/FT-…` and md5-verified
against the originals and against FS's backup **before anything else happened**. All four match
FS's exactly, so nothing has moved since.

---

## §6 — WHAT NEEDS A RULING

**Nothing here blocks the next batch. All five are the designer's.**

1. **CHANNEL'S PARTITION.** *Spell damage* = **not physical** (implemented), or Channel pays all
   damage and buys the basic attack with it. One constant, `CHANNEL_SPARES_PHYSICAL`.
2. **CHANNEL'S RATE.** 40 Mana a step / 6 steps / +3% a step gives **2 steps by a Mage's fifth
   turn** at the observed spend. Too slow to be felt in an ordinary fight, about right for a boss.
3. **MOMENTUM'S RATE.** 8 steps × 4% off the delay = −32% at the cap, which is roughly a free turn
   every three.
4. **SANCTITY'S RATE.** 6 events a step / 5 steps / +1 turn a step is a large payout on a very wide
   door. The rate has to be read against the whole party's status traffic, not against his casting.
5. **AND THE ONE THAT IS NOT A NUMBER: HOW A SECOND METER DISPLAYS.** A chip is the existing answer
   and costs nothing; a chip cannot show a fill. §0 has the measurement.
