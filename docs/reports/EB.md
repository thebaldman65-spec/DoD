# BATCH EB — THE CORES ARE THE BASELINE, AND A SWEEP FOR HEADERS THAT NAME THE DEAD

*2026-08-31. Two rulings and two instrument repairs. **EA's 13-of-17 is ruled INTENDED and asserted
as the inversion rather than as the ratio; every comment in the tree is swept for a name that no
longer resolves, and sixteen were repaired.** No ability magnitude moved, no card was authored,
`Ability.PURE_BUFFS` was not widened, and **every `.gd` change outside the new gate is comments
only, proven with a comment-stripped diff.***

---

## THE BRIEF'S AND THE RECORD'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because three of them changed the work.

1. **§2 SAYS `Run.roll_ability_offer` IS "a function DY deleted". IT WAS DELETED AT AN §4** —
   eighteen batches earlier — and `test_batch_an` §1 has asserted its absence ever since, in its
   `gone_fn` list. `scripts/classes.gd:155` records the correct attribution in the file the brief
   was reasoning about. DY §3 deleted `CLASS_POOLS`; AN §4 deleted the roller. **Two deletions, two
   batches, and the brief merged them.**
2. **§1's PROPERTY AS LITERALLY STATED IS NOT ASSERTABLE, AND IT IS RED AT HEAD.** *"A draft card
   that becomes cheaper and faster than its comparable core"* — compared without the
   equal-initiative control, **21 of 96** same-spec same-role pairs already satisfy it. Kindled Mind
   at 15 Mana and initiative 1.5 against Death Ray at 55 and 5.0 is a cantrip beside a nuke, not a
   mispricing. **At equal initiative "faster" is impossible by construction**, so the tempo axis
   that survives the control is COOLDOWN, and that is the axis §1's gate asserts.
3. **§3's FIRST ITEM WAS ALREADY DONE, AND THE DESCRIPTION OF IT IS WRONG IN A WAY THAT MATTERS.**
   The brief says the extractor "reads 32 asserted literals where there are 95" and "has been
   running at a third of its subject through every batch that trusted it." EA fixed it *inside* EA
   and certified with the fixed one. **And re-measured, the hole never lost a literal at all** — it
   lost the BOUNDARY between assertions, which is worse. See §3.
4. **EA's "both counter-cases are the same draft card" IS RIGHT, BUT ONLY ONE OF THE TWO IS A
   CROSSOVER.** Divine Plea against Renewal is cheaper AND shorter. Against Holy's Heal the same
   card is cheaper and LONGER — an ordinary trade. **One crossover and one trade, not two of a
   kind**, and the distinction is the whole of what §1's gate asserts.
5. **EA's 13-of-17 HELD EXACTLY**, re-derived rather than inherited, as did the 17-pair population,
   the resource split 10/2, the cooldown split 13/1, and the cap's 29.5% against 12.8%.

---

## §1 — RULED: THE PROTECTED CORE IS THE BASELINE

**The ruling, in `CLAUDE.md` with its reasoning AND with its counter-reading:**

> **A protected core may be cheaper and faster than a comparable draft card. The core is the
> baseline; the draft card pays for the slot it occupies.** A measurement showing cores are cheaper
> is the design working. **Do not retune the layer on that measurement alone.**

**A protected core arrives FREE with the spec; a draft card costs a PICK out of a capped set of
slots.** A draft card paying that pick in initiative and in resource is the correct relationship.
EA's 13-of-17 is evidence the layer is *consistent*, not evidence it is broken.

**THE COUNTER-READING IS RECORDED BESIDE IT BECAUSE NOTHING IN THE CODE DISTINGUISHES THE TWO.**
Both readings fit the same seventeen pairs. A future reader running the same measurement will find
the same thirteen and reach for a retune — and they should know they are overturning a ruling
rather than fixing a defect.

**`Ability.PURE_BUFFS` WAS NOT WIDENED AND NO MAGNITUDE MOVED.** The cap reaching **29.5% of the
draft layer against 12.8% of the cores** is recorded as *the same relationship expressed through the
cap*: the one instrument that prices tempo reaches the side that pays. Under this ruling it is not
a defect and not a second finding.

### WHAT IS ASSERTED IS THE INVERSION, NOT THE RATIO

`check_eb` §1 re-derives the pair table live and catches the case the ruling does **not** cover: a
draft card **cheaper on resource AND shorter on cooldown** than a comparable core, at the same spec,
same role and same initiative with `PURE_BUFFS` excluded from both sides. That is a card that pays
no pick and gives none back.

**The live table, derived rather than inherited — 39 protected cores, 129 draft cards, 17
comparable pairs, 13 favouring the core, ONE crossover:**

| | measured | asserted by |
|---|---|---|
| comparable pairs | **17** | `check_eb` §1 (floor 12) |
| favour the core | **13** | `check_ea` §4 — **printed here, not re-asserted** |
| **crossovers** | **1** | **`check_eb` §1, NAMED in both directions** |
| under `BUFF_DELAY_CAP` | core 5/39, draft 38/129 | `check_ea` §4 |

**THE ONE CROSSOVER IS NAMED RATHER THAN COUNTED.** Holy's **Divine Plea** (0 Mana, cooldown 2)
against **Renewal** (20 Mana, cooldown 3) at initiative 3.0 in the heal role. It is asserted in
BOTH directions: a second crossover reds the gate, and **the named one vanishing reds it too**,
because that means the pair was re-priced and the ruling revisited with nothing saying so.

**IT IS NOT A SECOND COPY OF `check_ea` §4.** That section asks whether the LAYER still leans the
way EA measured it and pins the aggregate direction. This one asks a different question of the same
table — *has any individual card crossed over* — and the aggregate cannot answer it, because 13 of
17 can hold while one card inverts. The ratio is **printed** as this section's own denominator and
asserted nowhere.

---

## §2 — THE SWEEP: 118 NAMES, 16 STALE, 71 CORRECT

`run_sim._award_trophies`'s header named `Run.roll_ability_offer`. That was the fourth instance of
one shape, so the whole tree was swept.

**THE POPULATION, REPORTED BEFORE ANYTHING WAS REPAIRED:** **4,049 code-shaped tokens in comments
across 111 `.gd` files** — backticked identifiers (this project's own convention), plus dotted
`Owner.member` references and `call()`-shaped tokens, because **the brief's own instance is in bare
parentheses and the backtick convention alone cannot see it.**

| | | |
|---|---|---|
| **STALE — a live claim in a dead name** | **16** | repaired |
| **RECORDS of a deletion — correct** | **71** | left alone |
| noise: engine / GDScript names | 10 | — |
| noise: shorthand and document names | 10 | — |
| noise: suffix conventions (`_step`, `_PERFECT`) | 8 | — |
| noise: live cards written in id casing (`sever`, `drumfire`) | 2 | — |
| noise: names composed at runtime (`cy_meter_bloodrage`) | 1 | — |
| **total unresolved** | **118** | |

**A COMMENT RECORDING A DELETION IS CORRECT AND MUST NOT BE SWEPT.** Seventy-one of the 118 read
*"`CLASS_POOLS` IS DELETED"*, *"`_overburn_drain` is deleted"*, *"`_raise_faith_peak` IS DELETED, NOT
LEFT UNREACHABLE"*. Repairing one of those deletes the project's memory of why a symbol is gone.
**The stale ones are the comments making a LIVE claim in a dead name**, and that distinction is a
judgement per row, which is why the list was reported before it was repaired.

### THE HAYSTACK CANNOT BE A GREP, AND THE BRIEF'S OWN INSTANCE PROVES IT

The first version of this sweep **could not see `Run.roll_ability_offer` at all.**

- `check_dv.gd:68` asserts `not rs.contains("func roll_ability_offer")`.
- `test_batch_an.gd:126` holds the bare literal `"roll_ability_offer"` in its `gone_fn` list.

**The two checks that prove the function is dead are exactly what make a text sweep report it as
alive.** The universe has to be a SYMBOL TABLE of declarations matched by equality — and the
declarations have to be read with the string literals **masked**, because an unmasked
`func\s+(\w+)` scan reads *inside* `"func roll_ability_offer"` and declares the dead name back into
existence out of the assertion that pins it absent. **That is the needle extractor's bracket-depth
bug wearing a different hat, in a different instrument, found the same week.**

### THE SIXTEEN

| site | named | is actually | repair |
|---|---|---|---|
| `scripts/run_sim.gd:865` | `Run.roll_ability_offer` | deleted at AN §4 | **deleted** — the rollers are named at the site below |
| `scripts/run_state.gd:2396` | `PERFECT_HALF` | replaced by `SC_PROFILE_DEFAULT` at CN §1 | **deleted** — `battle.gd` carries the current version |
| `scripts/battle.gd:912` | `_hero_turn` | `_player_turn` | corrected |
| `scripts/battle.gd:6786` | `_intent_detail_note` | **never existed** — written at BL, never shipped | **deleted** |
| `scripts/battle.gd:24705` | `_devout_break_cut` | `faith_break_cut`, in `_on_unit_credit` | corrected |
| `scripts/battle.gd:440` | `mirror_images` | the `mirror` chip, charges in its POWER | corrected |
| `scripts/unit.gd:71` | `anathema` | `breaking_darkness` (renamed at CG) | corrected |
| `scripts/unit.gd:3280` | `drink_overheal` | `_bank_overheal` | corrected |
| `scripts/classes.gd:2896` | `Classes.CONFIGS` | `Classes.hero_config()` | corrected |
| `check_da.gd:145` | `_battle()` | `_spawn_battle()` | corrected |
| `check_de.gd:22` | `BASELINE` | `baselines.json` | corrected |
| `test_batch_cd.gd:39` | `BASELINE` | `baselines.json` | corrected |
| `test_batch_au.gd:588` | `unit.can_overcharge` | `unit.overcharge_ready()` | corrected |
| `test_batch_bq.gd:25` | `CLASS_POOLS` byte-unchanged | the body asserts it **DELETED** | header re-pointed at the body |
| `test_batch_br.gd:28` | `CLASS_POOLS` byte-unchanged | the body asserts it **DELETED** | header re-pointed at the body |
| **`test_batch_bp.gd:341`** | `CLASS_POOLS`, and *"in no DRAFT pool at all"* | **Rallying Shout is in the WARDEN's** | corrected **and asserted** |

**THE RULE IS SPLIT WHERE DR's WAS NOT.** DR's rule from Flash Freeze stands — *a comment corrected
to describe a deleted feature is still a comment about a deleted feature* — but it is about
DELETIONS. A **rename** leaves a live claim wearing a dead name, and deleting it throws away
something true. So: **delete where the thing is gone, correct the name where the thing only moved.**
Three of the sixteen were deletions and thirteen were moves.

### THE SHARPEST OF THE SIXTEEN WAS NOT PROSE, AND IT BECAME A GATE

`test_batch_bp` §7 stuffs three hand-written fillers onto a Swordmaster kit **after**
`award_draft_pick` has rolled. DR repaired a one-in-eight flake there by choosing names no draw can
reach, and the comment recording the repair said all three are *"in no DRAFT pool at all"*.

**Rallying Shout is in the Warden's.** The repair is still correct, for a narrower reason the
comment never gave: §7 is a **Swordmaster** flow, and `draft_pool_left` offers his own spec pool and
the **Warrior** class pool and nothing else. Sweeping Strikes and Shatterpoint are `SPEC_POOLS`
boss-pick cards in no draft pool anywhere; Rallying Shout drafts from the Warden alone.

**A comment stating a stronger invariant than the code has is worse than one stating none**, because
the next batch relies on the strong version — and this invariant is exactly the kind that breaks
without anybody touching the file that depends on it. The pools grow; a name no draw could reach
becomes a name a draw can. **That is how DR's flake arrived in the first place.** `check_eb` §2
asserts it live, driven through `draft_pool_left` itself.

### CAN IT BE AN INSTRUMENT? IT CAN. IT SHOULD NOT BE ONE, AND NOTHING IS RULED

**Mechanically possible: yes, and it was built and run** — the sweep in this section is that
instrument. **What it would cost is the answer:** on this tree it raises **118 rows to find 16
defects**, a 5.5-to-1 false-alarm rate, and **71 of the 118 are comments that are correct and must
stay.** A gate cannot tell a record of a deletion from a stale claim without reading the sentence,
because the two contain the same dead name.

**A false alarm is how an instrument gets switched off** — this project's own words, from
`check_ea` §3's design. So §2 ships a **rule** and no gate: a rule costs nothing on a batch that
deletes nothing, and it lands at the moment the information exists, which is the moment of the
deletion. **Reported, and ruled on nowhere.**

---

## §3 — THE TWO INSTRUMENT REPAIRS

### THE EXTRACTOR NEVER LOST A LITERAL. IT LOST THE BOUNDARY BETWEEN ASSERTIONS

EA recorded its needle extractor as reading **32** asserted literals where there are **95**, and the
brief carried that forward as *"running at a third of its subject through every batch that trusted
it."* **Neither half survives measurement.**

- **EA fixed it inside EA and certified with the fixed one.** The 32-reading build existed for
  minutes and certified nothing. **That exact build no longer exists and could not be reproduced**,
  which is stated rather than worked around.
- **What CAN be measured is what the bug does.** Running the current extractor with its
  string-masking disabled finds the **same 124 distinct asserted literals** (90 positive, 34
  negative) as the fixed one. **Not one literal is lost.**
- **What collapses is the GROUPING: 73 positive groups become 45, and 30 negative become 25.** An
  unbalanced `"("` inside a failure message leaves the bracket depth open and glues the following
  statements into one.
- **AND AN OR-GROUP PASSES WHEN ANY MEMBER IS PRESENT.** So **28 independent positive assertions and
  5 negative ones were being satisfied by a sibling's hit rather than their own** — a check passing
  for a reason other than the one it states, inside the instrument built to find exactly that.
- **THE COUNT TO ASSERT IS THE GROUP COUNT, NOT THE LITERAL COUNT.** A literal census cannot see
  this failure mode at all: it reads 124 either way.

**AND THE FIXED EXTRACTOR STILL HAD HALF THE SAME BUG, WHICH IS NOW CLOSED.** `statements()` masked
strings before counting depth; **`or_groups()` did not** — so a `(` or the literal word `or` inside
a message could split one assertion into an or-group. **It moves no number on this tree** (73/22/30/46
before and after), so it is a latent hole rather than a live defect, and it is reported as such.

**WHAT THE FULL POPULATION TURNS UP: nothing red, and three known absences.** All 124 literals
resolve; the verifier is **GREEN at HEAD and green after**. Of the **46 locators**, **three do not
resolve** — `test_batch_at`'s `" — cold_snap"` and `"EXCLUSIVE talent pair ("`, and
`test_batch_aw`'s `"no rune may write"`. **These are the three vacuous assertions `docs/state.md`
already carries as owed**, named at their own sites since DG. The widened extractor found the
population the record already described, and found nothing the record did not.

### AND A PRECONDITION ON THE NEGATIVE-CONTROL RULE

> **A control armed on unasserted prose reports the same green a working check does.** Arm it on
> something a suite demonstrably reads, and **confirm the disarmed state is RED before trusting the
> armed one.**

EA's first control wrapped a `CLAUDE.md` heading no suite reads, went green correctly, and was
indistinguishable from a working check. **EB hit the same shape from the other side and it is
recorded in §4 below**: the parse control this batch owed was armed on the new GATE first, and
`check_parse` does not walk the gates — so it read clean for the wrong reason.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No ability magnitude moved, no card was authored, and `Ability.PURE_BUFFS` was not widened.**
  §1 is a ruling about how to READ a measurement, not a re-pricing.
- **The comment sweep is not a gate.** Mechanically possible, built and run; 118 rows to find 16
  defects, and 71 of the 118 are comments that are correct. **Reported, ruled on nowhere.**
- **The 13-of-17 is not re-asserted.** `check_ea` §4 owns the aggregate direction; `check_eb` §1
  prints it as its own denominator. Two copies of one fact in two gates is DJ's defect.
- **The three vacuous assertions in `as`, `at` and `aw` are untouched.** §3's widened extractor
  found them again — they are the three locators that do not resolve — and they remain what
  `docs/state.md` already records: owed, named at their sites, and DG's sanctioned exception.
- **`or_groups`'s residual masking hole is closed but changes nothing here**, and that is stated
  rather than presented as a repair with an effect.

---

## §5 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md` and
`baselines.json`'s `check_eb` row were all final before the certification run. **`docs/state.md`
and this report are written during it and are read by nothing.**

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: EXACTLY ONE ROW MOVES — `check_eb` arrives at 12 — AND `check_de` READS 329 / 0 / 0.**

Predicted from what each suite **READS**:

- **`check_eb`** is a new target, so `check_de` gains four assertions (325 → **329**). Its own row
  was written BEFORE the battery, off **three identical standalone readings of 12**, so `check_de`
  certifies on pass one instead of reporting an unwatched target.
- **Every `.gd` change outside the new gate is comments only**, proven with a comment-stripped diff
  against `git show HEAD`, so no check count can move.
- **The four documents** are asserted by `contains` calls whose COUNT is fixed. EB only ADDS to
  them; the literal-flip sweep reads **0 lost** in all four.
- **`check_da` §3 and `check_dw` §0** — `check_eb` reads only the SPEC side of the draft pools and
  goes through `draft_pool_left` rather than `Classes.class_draft_pool`, and every section returns
  void. **Run standalone before the battery: `check_da` 39 / 0 and `check_dw` 35 / 0.** No
  exemption, and no line moved in `check_dw`'s table.
- **`check_dv` §4's changelog span** is a FLOOR of 16 since DW; EB's entry takes the live file to
  22 and cannot red it.

**IT HELD ON THE SECOND BATTERY AND NOT ON THE FIRST.** See below.

### THE PRE-BATTERY INSTRUMENTS

1. **THE NEEDLE VERIFIER**, with `or_groups`'s residual string-masking hole closed: **73 positive
   groups, 22 or-alternatives, 30 negatives, 46 locators across 82 files.** Green at HEAD, green
   after. Three locators do not resolve and all three are the known vacuous trio.
2. **THE LITERAL-FLIP SWEEP** over the four tracked documents, 10,867 distinct literals at a floor
   of 4: **`CLAUDE.md` 7 gained / 0 lost; `master.html` 1 / 0; `changelog.html` 6 / 0;
   `design-notes.md` 7 / 0.** All cross-checked against the tree's **275 negative assertions**:
   **0 gained literals are negatively asserted against the document they landed in.**
   · **ONE GAINED LITERAL WAS AN ACCIDENT AND WAS REWORDED**: `BATCH BR` appeared inside the prose
   *"AND THE BATCH BROKE A SUITE"*. Harmless, and removed anyway — a batch-code substring landing
   in a tracked document is not a thing to leave to luck.
3. **THE RETIRED-WORD SWEEP**, re-implemented from `test_batch_bx` §4 and §4b's own strips (the
   `PARTY_IDENTS` list is read out of the suite rather than copied): **0 *beast* and 0 *party*
   across 13 `.gd` files and `master.html`.**
4. **A 39-TARGET SUBSET BATTERY** over every live reader of the four documents plus the edited
   suites and `check_da` / `check_dw` / `check_eb`: **all 39 green, 0 `Parse Error`, 0
   `SCRIPT ERROR`, every count exactly on its baseline.**
5. **A COMMENT-STRIPPED DIFF** over all twelve edited `.gd` files against `git show HEAD`:
   **zero code lines changed in any of them.**

### THE NEGATIVE CONTROLS — AND THE ONE THAT DID NOT BITE IS THE ONE WORTH KEEPING

0. **THE PARSE CONTROL WAS ARMED ON THE NEW GATE FIRST AND READ CLEAN FOR THE WRONG REASON.** A
   closing parenthesis was removed from `check_eb`'s own signature; **`check_parse` reported
   0 `Parse Error` lines and a tally of 0 failures.** It is correct: `check_parse` walks
   `res://scripts` and `res://scenes` and **does not cover the gates**. **This is EB §3's own new
   rule biting its author** — a control armed where the instrument does not look proves nothing,
   and says so in the same word a real pass does.
   · **RE-ARMED TWICE.** Against the broken GATE launched directly: **`Parse Error: Expected
   parameter name.` in stderr, no tally line printed at all, and the process still exits 0** —
   the exact fault `run_battery.sh`'s `throws=` column exists for. Then re-armed inside
   `check_parse`'s actual scope, on `run_state.gd`'s `draft_pool_left` signature: **22
   `Parse Error` lines in stderr**, tally 7. **Grepped from stderr, never from the tally and never
   from the exit code.** Both restored by `cp`.
1. **THE NEEDLE CONTROL, ARMED ON A NEEDLE TAKEN OUT OF THE EXTRACTOR'S OWN DUMP.**
   `PROTECTED CORE is guaranteed and permitted` — `check_do`'s — split across a line wrap, **not one
   character deleted.** The verifier went **RED (1 violation)** naming the file and the document,
   and **`check_do` went 131 / 1.** Restored by `cp`; CLAUDE.md's md5 back to
   `3ab455561729c06a923b999ea8dadb35` and the verifier green again.
2. **§1's CONTROL: A REAL SECOND CROSSOVER, INJECTED INTO THE DATA.** The Occultist's *Suffering*
   was moved from 25 Mana / cooldown 4 to **15 / cooldown 1**, against Hex of Ruin's 20 / cooldown 2
   at the same initiative 2.5 in the damage role. **`check_eb` went 13 / 2**, naming the card, the
   core and the spec, and the count assertion caught it separately: *"2 crossovers against 1
   named"*. Restored by `cp`; `classes.gd` md5 back to `83d874b72914f6cfc2f1551a3e1d81ce`.
3. **§2's CONTROL: THE FILLER MADE REACHABLE.** *Rallying Shout* was added to the SWORDMASTER draft
   pool. **`check_eb` went 12 / 1** with *"filler Rallying Shout is reachable by a swordmaster draw
   — §7's three checks will red on a draw that lands on it (DR's flake, returning)"*. Restored by
   `cp`; md5 identical.

### THE FIRST BATTERY TOOK A SUITE RED, AND IT IS THE FINDING OF THE BATCH

**`test_batch_bl` control 1 pins the phrase `THIS BATCH DOES NOT SHIP ONE` inside `battle.gd`.**
EB §2 reworded that sentence while deleting the dangling `_intent_detail_note` pointer beside it.

**EVERY INSTRUMENT THIS PROJECT OWNS SAID GREEN.** The needle verifier: green. The literal-flip
sweep: 0 lost in all four documents. The comment-stripped diff: *comments only, zero code lines*.
The 39-target subset battery: all green. **The full battery took `bl` to 88 / 1 and `check_de`
reported it as REDDER.**

**THE HOLE IS STRUCTURAL AND IT IS NOW WRITTEN DOWN.** Both document instruments track needles into
the four tracked DOCUMENTS. **A suite that asserts a literal against `.gd` SOURCE is a haystack
neither of them watches**, and `bl` is not a reader of any tracked document, so the subset battery
did not include it either. **"Comments only" proves no code moved; it says nothing about whether a
suite reads the comment.**

**THE INSTRUMENT THAT SEES IT IS THE SAME SWEEP WITH THE EDITED SOURCES AS THE DOCUMENTS.** Built
and run: every literal in the tree at a floor of 4, tested for presence in each edited `.gd` file
before and after. It reads **five lost literals**, and the first is the one that bit:

| file | lost | verdict |
|---|---|---|
| **`scripts/battle.gd`** | **`THIS BATCH DOES NOT SHIP ONE`** | **the break — `test_batch_bl` control 1** |
| `scripts/run_sim.gd` | `roll_ability_offer` | no assertion reads it out of this file |
| `scripts/run_state.gd` | `PERFECT`, `every hero`, `perfect` | substring noise; the one static hit is `"func _perfected_chip("`, which still resolves |

**The needle is restored word for word**, with a note at the site saying it is a needle and must
stay, and the `_intent_detail_note` deletion is kept. `battle.gd` now reads **0 lost**. The rule is
in `CLAUDE.md`, and **the tree was re-frozen and the battery run a second time** — a batch that
edits behind its own certification run has not certified anything.

### THE ACCEPTANCE RUN (THE SECOND)

**One battery, and it found nothing.** No suite failure, no throw, no notice, and the only red is
the one that is on purpose.

| | DZ's acceptance | EA's acceptance | **EB's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 321 / 0 / 0 | 325 / 0 / 0 | **329 / 0 / 0** |
| targets in the manifest | 78 | 79 | **80** |

**EIGHTY TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY. 0 `Parse Error` and 0 `SCRIPT ERROR` in
every log** — grepped from the streams rather than read off a tally or an exit code, and **not one
of the 80 logs contains either marker.** `check_map_screen: OK`; `check_ct_map` 83 / 0; the run
harness reads **22 / 165 / 8**, all three passing.

**AND THE PREDICTION HELD EXACTLY.** **`check_de` reported 329 checks, 0 failures and ZERO
NOTICES.** `check_eb` read **12** — the one row written before the run — and **no other row
moved.** `check_de` itself went 325 → 329, four assertions for the one new target, which is the
movement nothing reports because it has no row of its own. `test_batch_an` read **6054**, inside
its recorded [6046, 6063] band, and the differ said so by saying nothing.

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**177 files were MD5-stamped before the acceptance run and re-compared after: EVERY ONE IS
BYTE-IDENTICAL.** `CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`,
`baselines.json` and every `.gd` file are unchanged across the run, so **the battery certified what
ships.**

**EXACTLY TWO FILES DIFFER FROM THE CERTIFIED TREE NOW, AND BOTH ARE READ BY NOTHING**:
`docs/state.md`, and this report — §1 to §3 of it were inside the freeze, §4 and §5 were written
after the run because they record it. **Six files NAME `state.md` and all six mentions are inside
comments**; nothing in the tree reads either file, and `check_de` reads neither.

### THE CODE CHANGE

**ONE NEW FILE AND ZERO CODE LINES ANYWHERE ELSE**, proven with a comment-stripped diff against
`git show HEAD` over all twelve edited `.gd` files:

- **`check_eb.gd`** — the new gate, 12 checks.
- **`scripts/battle.gd`, `run_state.gd`, `run_sim.gd`, `unit.gd`, `classes.gd`, `check_da.gd`,
  `check_de.gd`, `test_batch_au.gd`, `bp`, `bq`, `br`, `cd`** — **comments only, zero code lines in
  every one of them.**
- **`run_battery.sh`** gains `check_eb` in `GATES`; **`baselines.json`** gains its row, written at
  `indent=1` for a 14-line insertion and no churn.
