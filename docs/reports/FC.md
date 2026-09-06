# BATCH FC — SPLIT TONGUE IS REPLACED BY THE RUNE OF THE SHARED RUIN

Split Tongue is retired and replaced. **The batch's subject turned out to be smaller than its most
important finding**: the replacement rune, built exactly as the card text reads, was **perpetual
motion** — two enemies seeded once and never marked again produced **80 detonations over 40 rounds**
with the Occultist doing nothing at all — and it is not a hang, so nothing in the tree could have
seen it. The brief's own §2 asked the question that found it and authorised the cap.

**Five negative controls, all discriminating. Two instrument defects found, and both rules were
already written. One vacuous arm, caught by its own positive pair. And the batch's own literal-sweep
control read green on its first arming, for a reason worth recording.**

---

## THE BRIEF'S PREMISES, RE-DERIVED

The brief says to verify every premise. **Thirteen checked, eleven confirmed, one narrower than
stated, one imprecise.**

| premise | verdict |
|---|---|
| Deepening Hex moves the detonation *cadence* | **CONFIRMED** — `rune_hex_threshold: 8` → `_ruin_threshold()`, `battle.gd:15136` |
| Standing Mark moves the lifesteal *cap* | **CONFIRMED** — `rune_ruin_leech_cap: 0.20`, read into `leech_cap` at `battle.gd:10284` |
| Wide Rite moves the mark *rate* | **CONFIRMED** — `rune_wide_rite: 1` → `_old_gods_mark()`, the one function all five quoting sites call |
| Open Wound trades *permanence* for reach | **CONFIRMED** — Shadowrend marks every enemy; Ruin decays 1 a turn on every bearer |
| **nothing changes what a detonation DOES** | **CONFIRMED, AND IT IS THE LOAD-BEARING ONE** — `_detonate_ruin` reads only the Occultist's Attack, `grim_ranks` and `unravel_ranks`, and **no rune writes either counter** (`talents.gd:2352`, `2362` are their only writers) |
| `_ruin_threshold()` and the detonation site are already read by Deepening Hex and by the primer | **CONFIRMED** — and the survivors are known in exactly one place, the `not target.dead` arm |
| Requiem consumes the whole pile and **fires no detonation** | **CONFIRMED** — it removes `ruin_primed` and `ruin` and never calls `_detonate_ruin`; asserted two ways at `check_ez` §5 |
| the pool stays at twenty-one live runes | **CONFIRMED as a consequence, not as an input** — one out, one in; the FILE goes 86 → 87 because a retirement is kept |
| Hex of Ruin is base 20% against three chosen enemies | **CONFIRMED** — `classes.gd:5650`, and after FC nothing in `data/runes.json` modifies that card |
| FA priced it at 12% against a false roster premise; FB measured it strictly worse | **CONFIRMED as FA's and FB's, cited rather than re-derived** |
| the named constants are unmoved | **CONFIRMED** — `SC_PROFILE_DEFAULT`, `CRIT_EXCESS_STEP`, `BOND_CONVERT`, `BOND_MITIGATION_MAX` and every `SS_SEQ_*` read back unchanged |
| **"Ruin already survives its own detonation — that is Requiem's whole design"** | **IMPRECISE, AND THE DISTINCTION MATTERS.** The stacks surviving is **AX §1's** design, not Requiem's; Requiem *depends* on it and *spends* it. The phrase is also the project's own idiom for "the mark is not consumed by its blast" — which is why it is **not** a claim about death, and why §2's death case resolves the way it does |
| **"a deep mark seeds rather than sits on a corpse"** | **NARROWER THAN IT READS** — see §2e. `BattleUnit._die` calls `statuses.clear()`, so a corpse carries nothing and a killing detonation moves nothing. The rune spreads the mark over the fight; it does not rescue it at the moment of death |

---

## §1 — WHY THIS ONE, AND THE PREMISE THAT MADE IT SAFE

**The axis is real and it is measured out of the code rather than taken from the brief.**
`_detonate_ruin`'s whole body reads three things that a talent or rune could move: `occ.attack`,
`grim_ranks` (Grim Focus) and `unravel_ranks` (Unraveling). Both counters are written by exactly one
talent node each and by **no rune in the file, live or retired**. The Occultist's other four runes
write `rune_hex_threshold`, `rune_ruin_leech_cap`, `rune_wide_rite` and `rune_open_wound`, and not
one of those is read inside the detonation. **So "nothing changes what a detonation DOES" is a
property of the tree, not a claim about it.**

**And it needs no target-count assumption**, which is the whole reason it was chosen: there is no
board size at which "half the survivors jump to the deepest other" does nothing, and no talent that
already does it.

---

## §2 — WHAT HAD TO BE DECIDED, EACH REPORTED AND EACH DRIVEN LIVE

**Every answer below is a measurement from a probe written, run and DELETED before the freeze**, and
every one of them is now an assertion in `check_ez` §5.

### **§2a — WHERE IT SITS**

In `_detonate_ruin`'s `not target.dead` arm, reading `sr_left` — **the same number the "the mark
endures" line already prints**. The line was hoisted into a local rather than read twice, because a
second site computing "what survived" would be a second answer to one question and the two would
drift. `_ruin_focus` is **deliberately not reused** for the receiver pick: that helper answers the
BOT's question and returns an unbroken boss ahead of any mark at all, which is a different question
wearing the same words.

### **§2b — HALF, ROUNDED DOWN, AND IT IS A MOVE**

Integer division on a meter that only holds integers. **21 keeps 11 and sends 10.** The bearer LOSES
what the receiver gains — "jump" is a move, not a copy — which is the rune's cost, and it is the
clause a control proved is asserted (§4, control B).

### **§2c — AND IT COSTS THE BEARER NO CADENCE, WHICH IS A PROPERTY OF THE THRESHOLD**

Detonation arms on a MULTIPLE (`st % step == 0`), so a pile halved from a multiple is still exactly
one threshold from its next blast. **Measured: 20 stacks → next prime 10 stacks away; halved to 10 →
next prime 10 stacks away.** The rune takes depth and amplification, not tempo. Asserted against
`_ruin_threshold()` rather than against the literal 10, so it survives Deepening Hex and Avatar of
Ruin.

### **§2d — WITH NO OTHER BODY THE STACKS STAY**

One enemy alive, 21 stacks, detonated: **21 after.** Nothing is deleted. A rune that dropped Ruin on
a single-enemy board would be the Split Tongue failure again in a new place, and it would read as
working everywhere else.

### **§2e — A KILLING BLAST MOVES NOTHING, AND THE BRIEF'S PHRASE IS NARROWER THAN IT READS**

`BattleUnit._die` calls `statuses.clear()`. A bearer the blast kills carries **zero** Ruin
afterwards, so there are no survivors to halve. Driven: a bearer at 30 stacks and 1 hp detonates,
dies, reads 0, and the receiver gets **nothing**. **This is reported rather than engineered around.**
Reading the pile *before* the blow would make a killing detonation jump, but "the stacks that survive
the blast" is this project's own idiom for AX §1's rule — the mark is not consumed by its own
detonation — and it is not a phrase about death. The block sits inside the `not target.dead` arm by
construction rather than behind a second guard.

### **§2f — AND REQUIEM FIRES NO DETONATION, CONFIRMED RATHER THAN ASSUMED**

Requiem removes `ruin_primed` and `ruin` and never calls `_detonate_ruin`. Confirmed two ways, both
asserted: the rune's field is read at **exactly one site** in the comment-stripped `battle.gd`, and
Requiem's own handler body does not reach that site. The second arm is the one that went vacuous
first — see §5.

---

## §3 — IT CHAINED, AND UNBOUNDED IT WAS PERPETUAL MOTION

**THIS IS THE BATCH'S MOST TRANSFERABLE FINDING, AND THE BRIEF'S OWN QUESTION FOUND IT.** §2 asked
*"does that detonation also jump? Report which, and cap it if it can loop."* It does, and it can.

**The mechanism.** The jump goes through `_gain_ruin`, which arms the receiver's threshold — that is
the cascade the rune exists for, and it is Unraveling's own reason for using the same door. But the
jump **MOVES** stacks rather than granting them, so the pile is **conserved**: A gives half to B, B
crosses a multiple and primes, B detonates and gives half back to A, A crosses a multiple and primes.
**The same stacks cross the threshold forever.**

**Measured before it was bounded, with no marking at all after the seed:**

| arm | detonations over 40 rounds, ZERO marks | total Ruin, before → after |
|---|---|---|
| without the rune | **2** — one per seeded mark, then nothing | 40 → 40 |
| **with the rune, unbounded** | **80** — exactly two a round, forever | 40 → 40 |

The pair reached a steady state (one body permanently primed at 26, the other holding 14) and paid
90% of the Occultist's Attack **plus a full-party heal of 25% of his max HP**, twice a round, with
the Occultist doing nothing.

**IT IS NOT A HANG**, because the turn-start check fires once per bearer per turn — which is exactly
why the watchdog, `check_parse` and every static gate would have read clean forever. **AND THE TELL
IS A CONSERVED TOTAL WITH A RISING EVENT COUNT**: an instrument watching the meter reads flat in both
arms.

**EVERY EXISTING GUARD IN THIS AREA WOULD HAVE READ CLEAN.** There is no recursion — nothing
re-enters, because a primed mark waits for its bearer's own turn. Covenant of Ash's identity break has
nothing to break. Spread of Madness's `_ruin_spreading` flag guards a call, and this loop is across
turns. The target is deterministic rather than random, so `CLAUDE.md`'s existing contagion bullet —
*an effect that lands on a RANDOM target needs an explicit bound* — does not reach it either.

**THE BOUND IS A RULE AND NOT AN AMOUNT.** A mark the Occultist primed HIMSELF jumps; a mark a JUMP
primed detonates in full and stops. **Chain length is exactly two, by construction**, and there is no
number in it to re-tune. The flag is `ruin_shared_in`, engine state on the unit in
`weight_of_ruin`'s precedent, consumed at the top of `_detonate_ruin` above every early return.

**AND IT IS SET ONLY WHERE THE JUMP DID THE ARMING**, read across the `_gain_ruin` call rather than
assumed. A receiver the jump merely DEEPENED keeps its own next detonation whole — flagging every
receiver would silently withhold the rune from a mark the player went on to build by hand, which is
invisible from the code and from every static check.

**What the bound costs, measured both orders on a fresh board per arm:**

| | detonations over 60 marks | final depths | no-marking engine |
|---|---|---|---|
| without the rune | **6** | `[60, 0, 0]` | 2, then stops |
| with the rune, unbounded | 93 | `[40, 20, 0]` | **80, forever** |
| **with the rune, bounded (shipped)** | **16** | `[5, 55, 0]` | **3, then stops** |

**×2.67 on detonations and the engine terminates.** Both orders read identically (16 / 16 and 6 / 6),
so the figure is not an ordering artefact. And the depth column is §1's ruling showing up as
behaviour: **highest-Ruin targeting CONCENTRATES onto a second body rather than spreading across the
board**, which is what the brief chose it for.

Recorded as a standing design rule in `CLAUDE.md`: **a spread that MOVES a threshold meter is
perpetual motion; one that ADDS to it is not.**

---

## §4 — THE CONTROLS, AND ALL FIVE BIT

**Every one is armed on something `check_ez` demonstrably reads, and the green state was confirmed
before and after.** `scripts/battle.gd` was restored from a pre-control copy and **md5-verified**
(`8cb2be5a25ba2a13941dd7b56c21173d`), and the gate re-read 132 / 0 afterwards.

| control | what it does | result |
|---|---|---|
| **A — the jump removed** | the move and the feed both replaced by `pass` | **132 / 6** — every jump arm by name |
| **B — a COPY, not a MOVE** | the receiver is fed; the bearer keeps everything | **132 / 3, and the RECEIVER arm PASSED** |
| **C — half ROUNDS UP** | `(sr_left + 1) / 2` | **132 / 1** — the odd-pile arm alone; its neighbours all green |
| **D — the chain bound removed** | `and not sr_fed` dropped | **132 / 1** — the fed-detonation arm alone |
| **E — LOWEST-Ruin receiver** | the comparison inverted | **132 / 3** — including *"the shallower body gets NOTHING"* |

**B IS THE ONE THAT EARNED AN ASSERTION.** A rune that fed the receiver without taking from the
bearer goes **green** on *"the enemy carrying the most Ruin receives them"* — the arm a brief would
naturally ask for. Only the bearer arm and the odd-pile arm can tell a move from a copy. This is FB
§1a's shape a batch later: not a check that fails to bite, but a check that bites on the wrong thing.

**C AND E ARE THE "DISTINGUISH THE RULING FROM ITS NEIGHBOURS" CONTROLS THE BRIEF ASKED FOR.** Under
control C the even-pile arms (20 → 10) read identically under both roundings and pass; **only the odd
pile can carry the rounding ruling**, and it is the only red. Under control E the receiver arm and
the *untouched third body* arm both fire — the second is what separates §1's highest-Ruin ruling from
the lowest-Ruin alternative the brief explicitly weighed and rejected.

---

## §5 — A VACUOUS ARM CAUGHT BY ITS OWN POSITIVE PAIR, AND A CONTROL WHOSE INJECTION DID NOT BREAK

**Two instrument failures inside this batch, both found, both recorded.**

**THE ANCHOR.** The Requiem confirmation was anchored on `"requiem":` and matched the **BOT's**
`ab.special == "requiem"` fifteen thousand lines earlier. The body it measured was never the handler,
and *"Requiem fires no detonation"* went **green over targeting code**. **The paired positive arm is
the only reason it was caught** — *"…and it SPENDS the pile, which is the whole card"* failed, which
is a body-identity assertion wearing a behaviour assertion's clothes. The anchor carries its indent
now (`\n\t\t"requiem":`, count 1, asserted) and both ends are bounded. Recorded as a fourth form on
`instrument-rules.md`'s ED §2 block.

**THE INJECTION.** The literal sweep's control was armed by rewriting `THE ABILITY DRAFT` — a needle
drawn out of the needle list and demonstrably read by `test_batch_bo` §6 — as `THE ABILITY DRAFTT`.
**Both arms read green**: the sweep `LOST 0`, the suite 1140 / 0. **The needle survives as a
substring, and every instrument here asks `contains`.** Re-armed as `THE ABILITY DRAFX` the sweep read
**LOST 1** naming it and the suite went **1140 / 1** on `§6: ...and carries the draft's own section`.
Restored, md5-verified, back to 1140 / 0. The negative-control rule now carries the precondition:
**assert the needle is ABSENT in the injection itself, and replace every occurrence.**

---

## §6 — TWO DEFECTS IN INSTRUMENTS THIS BATCH DID NOT OWN, AND BOTH RULES WERE ALREADY WRITTEN

**`test_batch_ax`'s detonation control was already too narrow at HEAD.** It read
`substr(det_at, 2600)` of `_detonate_ruin`, **a function 2624 characters long before FC touched
anything** — 24 characters outside the control, shrinking with every line the function gains, and
printing exactly as green at half coverage as at full. **REPAIRED, not widened by a number**: the
body is derived from the file's own declaration separator (not from the next `func` — nine thousand
characters of block comment sit between them), and the derivation asserts its own end, its length
band, and that it holds exactly one function. **+3 checks, and this is `instrument-rules.md`'s ED §2
rule paid rather than a new one.**

**`check_ed` §2 still carries the line-bounded holder binding its own standing rule names.** Its
holder regex is `var\s+(\w+)\s*:?=\s*[^\n]*"res://…"`, and `[^\n]*` cannot cross a newline, so a
haystack written as

```gdscript
var b_src := Gate.strip_comments(
    FileAccess.get_file_as_string("res://scripts/battle.gd"))
```

binds nothing and every pin read off it is invisible to the completeness scan. **The manifest BUILDER
sees it either way**, which is what makes the gap silent: written wrapped, `check_ed` read **18 / 0
against a manifest missing five entries**; written flat, it named all five and the regenerated
manifest carries them. **FC wrote its holder flat and did NOT widen the scan** — that is a change to
a gate's population and belongs to a batch that owns it. **A rule the instrument itself has not been
repaired to is a rule that will be paid again**, and it is on the record in both places.

---

## §7 — RETIRING SPLIT TONGUE, AND WHAT "RETIRED" TURNED OUT TO MEAN

**The Melted Armor contract, exactly as ET retired the 53.** The entry is kept, `config`, `build` and
`display_name` all still resolve it, a saved run holding one keeps working, and `eligible_ids` skips
it at the one door both offer paths come through. Its `rune_split_tongue` read site in `_resolve` is
kept and is now reachable by nothing — the `rune_entropy_ranks` contract.

**The string records the PREMISE rather than the weakness**, which is the useful half: *it was
authored against a base that did not exist.* Both repricings go with it, so a later reader meets a
retired rune with two numbers behind it and can see that **neither number was the problem**.

### **§7a — AND "RETIRED" STOPPED MEANING "AUTHORED UNDER THE OLD LANE RULE", IN THREE PLACES AT ONCE**

**HEAD's unmodified gates were run against the new code before a single assertion was edited** —
FA's own standing rule, and this is the run that earns it. **Nineteen targets, six reds, four
predicted and two not.**

| red | predicted? |
|---|---|
| `check_ez` §0: the authored pool is 87, expected 86 | yes |
| `check_es` §1: the authored pool is 87, expected 86 | yes |
| `check_et` §1: `split_tongue` names no batch or no loss | yes |
| `test_runes`: occultist has 5 RETIRED spec runes, expected 4 | yes |
| **`check_es` §5: 13 retired splashes, expected one per spec** | **NO** |
| **`test_runes`: occultist: 2 splash runes, expected exactly 1** | **NO** |

**All three of the unpredicted-and-related reds have ONE cause**: three separate walks read
"retired" as "authored under ET's one-rune-per-lane rule", and a rune retired at FC was never
authored under that rule. **The populations are narrowed, never the assertions loosened.**

**THE DISCRIMINATOR IS `RUNE_SHAPES` MEMBERSHIP, WHICH IS THE VINTAGE ITSELF.** The 65 predate EZ
§0's ABILITY / PASSIVE / STAT vocabulary and carry no row; everything authored at EZ or since carries
one; and retiring a rune does not take its row away, because a retired rune is still an ABILITY rune.
**So there is no vintage list and no per-batch exemption, and the next EZ-era retirement classifies
itself with no edit.** The narrowing is asserted rather than trusted: a skipped entry must carry no
`lane` and must name neither EO nor ET.

**`check_et` §1's declarative test was widened the same way.** The rule is *a retirement names a
batch and names a loss*; the test asked whether it named one of **two** batches, and reported FC's
string as *"names no batch"* while naming FC in its first five characters. **The fingerprint is
widened to any `BATCH ` mark; the table is not extended.** `RETIRED_AT_ET` and the EO/ET counts are
untouched and still pin ET's own sixty-five, and a new arm asserts every later-vintage retirement
carries the `RUNE_SHAPES` row — because one entry losing that row would silently rejoin the lane-rule
population **in all three places at once**, and this is the assertion that would say so.

---

## §8 — THE VERIFICATION RUN

### **§8a — THE FREEZE**

An md5 stamp of **391 files, absolute paths, tracked AND untracked**, taken before the run and
re-taken after over the same path list. **ZERO DIFFER**, and **the path list itself was re-derived
after the run and is the same 391 paths** — nothing appeared and nothing vanished, which a digest
comparison alone cannot see. **The measurement probe was deleted before the stamp was taken**, so it
is not in the tree and leaves no `check_parse` residue (167 / 0).

### **§8b — THE BATTERY**

**93 targets. `sort .ran | uniq -d` → ZERO duplicates**, 93 names and 93 logs compared both ways.
**0 `Parse Error`, 0 `SCRIPT ERROR` and 0 timeouts across all 93 logs**, swept by grepping every log
FILE rather than by reading any target's own tally.

| target | result |
|---|---|
| `check_ez` | **132 / 0** |
| `test_runes` | **3839 / 0** |
| `check_et` | **25 / 0** |
| `test_batch_ax` | **356 / 0** |
| `check_es` | 44 / 0 |
| `check_parse` | **167 / 0** |
| `check_ed` | 18 / 0 |
| `check_ec` | 23 / 0 |
| `check_ek` | 46 / 0 |
| `test_rune_battle` | 97 / 0 |
| harness gates 1 / 2 / 3 | PASS 22 / 166 / 8 |
| `check_ct_map` | 83 / 0 |
| `check_de` | **382 / 0 / 0 notices** (re-run; see §8c) |

**Two lines in the run are not `fails=0`, and neither is a fault:**

- **`check_cm_live` 13 / 4** — the sanctioned red, against a recorded `fails: [4, 4]`. **The lines
  are compared, not the count**: *the bar appeared on the enemy's attack*, *the bar's top line names
  the incoming blow*, *the brace lands near x0.85*, *the brace's Break half lands near x0.75* — the
  four its row names, and **this batch moved no UI code**.
- **`check_cl_width` `checks=? fails=?`** and **`check_map_screen`** — both report no readable count
  by design, which is what their rows record. `check_map_screen`'s `expect` string
  (`check_map_screen: OK`) is present in the log.

### **§8c — FOUR COUNT NOTICES THAT WERE NOT PREDICTED, AND ALL FOUR ARE ONE POOL ENTRY**

The acceptance run returned **382 / 0 / 4 notices**: `check_em` 286→289, `test_batch_al` 582→583,
`test_batch_bh` 254→255, `test_batch_cb` 1361→1370. **Every one is a per-entry loop over a
`data/runes.json` that went 86 → 87, and not one assertion in any of them changed.**

**THIS WAS PREDICTABLE AND WAS NOT PREDICTED, AND THAT IS THE finding.** `test_batch_bh`'s own
baseline note already names those three suites as the pool-walkers whose counts move with the file's
size — *"the same shape as `test_batch_al`'s and `test_batch_cb`'s"* — and FC grew the file. The four
rows should have moved before the battery with the other four.

**ATTRIBUTED IN BOTH DIRECTIONS RATHER THAN ARGUED.** With HEAD's 86-entry `data/runes.json` and
every other FC change in place, all four read their OLD numbers **exactly** (286 / 582 / 254 / 1361);
with FC's 87-entry file, their new ones. `data/runes.json` was restored from a pre-arm copy and
md5-verified. Three identical standalone readings of each new value followed, the rows were moved
with their arithmetic in the note, and **`check_de` was re-run over the SAME battery logs** — it
spawns nothing, so this is a post-pass and not a second run — reading **382 / 0 / 0 notices, 92 of 92
recorded targets swept, 0 off their recorded line.**

**The four rows say in the note that they were moved AFTER the run.** A row written after the run
cannot disagree with it, and the honest handling is to say so rather than to let it read like a
prediction.

### **§8d — THE PRE-BATTERY BASELINES, WRITTEN OFF THREE IDENTICAL READINGS AND COUNTED OFF THE DIFF**

`check_ez` **115 → 132** (+17: twelve arms for the new read site, five for Requiem — enumerated in
the row), `check_et` **24 → 25** (+1), `test_batch_ax` **353 → 356** (+3), `test_runes`
**3803 → 3839**.

**`test_runes`' +36 is SPLIT BY CONTROLLED ARMS rather than derived by argument**, three readings with
the FC suite fixed and only the data changing: **HEAD's data → 3803** (identical to HEAD/HEAD, so the
suite's new arms add ZERO when nothing is retired after ET — that is the control), **the retirement
alone → 3802** (net −1), **the full batch → 3839** (so the new entry alone is +37). −1 + 37 = +36.
`data/runes.json` was restored and md5-verified after each arm.

### **§8e — THE LITERAL SWEEP**

**10,365 needles** — every string literal of four characters or more in the `.gd` corpus, backslash
escapes RESOLVED, extracted by a char-by-char scanner that handles both quote styles with neither
eating the other, format-bearing literals separated out, and the population taken as the **UNION** of
the before and after corpora (10,348 from 125 files before, 10,362 from 125 after). Each document is
diffed against a **391-file `rsync` copy of the tree taken as the batch's first action, before a
single byte moved.**

**LOST 0 IN EVERY DOCUMENT.** `CLAUDE.md` (GAINED 2), `master.html` (0), `changelog.html` (7),
`design-notes.md` (5), `instrument-rules.md` (9), `baselines.json` (5), `data/runes.json` (10),
`pin-manifest.json` (3), `glossary.json`, the three audit pages, `README.md` and `project.godot` all
unmoved.

**ARMED BOTH WAYS BEFORE IT WAS BELIEVED** — and the first arming failed, which is §5's second
finding.

**`docs/state.md` READS LOST 0**, and nothing opens it. **Re-derived here rather than inherited from
FB**: every mention of `state.md` in the `.gd` corpus is inside a comment, and no `FileAccess`,
`_src`, `load(` or `open(` call in any script names it or `docs/reports/`.

### **§8f — THE POST-RUN EDITS ARE FOUR, AND ALL FOUR ARE NAMED**

`baselines.json`'s four notice rows, `docs/state.md`'s rewritten WHERE block, this report, and the
`check_de` re-run's own reading. **`baselines.json` IS read by six targets** — `check_parse`,
`check_dp`, `check_map_screen`, `test_batch_cd`, `test_batch_ay` and `check_de` — so all six were
**re-run after the edit**: 167 / 0, 48 / 0, `OK`, 99 / 0, 486 / 0 and 382 / 0 / 0. The literal sweep
was re-run after every document edit and still reads LOST 0 everywhere.

---

## §9 — THE TWO OCCULTIST RUNES THAT FIGHT, REPORTED (the brief's §5)

**The specific collision FB found is gone with the retirement.** Nothing pays a hard `1` against
`_old_gods_mark()` any more, so Wide Rite's +1 is no longer silently cancelled by anything.

**What replaces it is the opposite sign, and it is reported in three parts with the evidence for each
labelled.**

- **THE SHARED RUIN COMPOUNDS WITH DEEPENING HEX AND WITH WIDE RITE** — *derived from the read
  sites*. Both raise detonation frequency, and every detonation is now also a jump. Two runes on one
  quantity, pointing the same way.
- **IT MAKES OPEN WOUND'S COST STRICTLY WORSE** — *measured*. Open Wound bleeds 1 Ruin a turn off
  **every** bearer; the Shared Ruin's whole purpose is to put the mark on more bearers. Over the
  60-mark measurement the mark sat on **one** body without the rune (`[60, 0, 0]`) and on **two**
  with it (`[5, 55, 0]`), so the decay bill doubles.
- **STANDING MARK IS THE ONE WHERE THE READING IS NOT OBVIOUS, AND IT IS REPORTED AS ARITHMETIC
  RATHER THAN AS A MEASUREMENT.** The draught is `min(0.02 × stacks, cap)`
  (`battle.gd:10286`), so halving a pile halves the draught **on that body** wherever the pile sits
  under the cap — and the Standing Mark's raised 60% cap puts *more* of the pile inside that linear
  region, which makes the halving cost more rather than less. **But the stacks are not destroyed,
  they move**, so striking the receiver now heals more, and whether it nets out depends on which body
  the party strikes. **This half was not measured and is not claimed as measured.**

**Ruled on: nothing.**

---

## §10 — WHAT IS DELIBERATELY NOT DONE

- **The Occultist's other four are untouched.** Deepening Hex, Standing Mark, Wide Rite and Open
  Wound all stand, byte-unchanged in the data.
- **Hex of Ruin is untouched**, and `data/runes.json` now modifies that card **not at all** — the
  brief's §4 requirement, checked by reading every payload naming it.
- **The pool stays at twenty-one live runes.** One out, one in.
- **No constant, ability, talent or magnitude moved.** `SC_PROFILE_DEFAULT`, `CRIT_EXCESS_STEP`,
  `BOND_CONVERT`, `BOND_MITIGATION_MAX`, `SHIELDWALL_BLOCK`, `RUIN_THRESHOLD`, `OLD_GODS_MARK`,
  `RUIN_LEECH_CAP` and every `SS_SEQ_*` read back unchanged.
- **No other rune is authored.** Eight specs and the class runes are still unwritten.
- **`UNSCALABLE` did not move.** `split_tongue` is still a member for `comet`'s reason, and a retired
  entry is still in `data`, so its membership check still resolves.
- **`check_ed` §2's holder scan was NOT widened**, and `RUNE_SHAPES`' `split_tongue` row was NOT
  removed — the row is what makes the vintage discriminator work, and a retired rune is still an
  ABILITY rune.
- **Pandemonium is not changed.** FB's §2d measurement was about Split Tongue, which is retired; the
  capstone itself was never the defect.

---

## §11 — WHAT IS OWED, AND TO WHOM

**TO THE DESIGNER — one report and one flag.**

**THE RUNE IS WORTH ×2.67 ON DETONATIONS AND THAT IS A LOT.** Over 60 marks on a three-enemy board it
turns 6 detonations into 16, each worth 90% of the Occultist's Attack plus a full-party heal of 25%
of his max HP. **That is a magnitude question and no magnitude was chosen by this batch** — the card
text says "half", the bound says "chain length two", and neither is a number a batch may pick. It is
on the record where the designer will meet it.

**THE NAME BREAKS THE TWENTY-ONE's CONVENTION, AND IS SHIPPED AS TRANSCRIBED.** All twenty other live
runes carry one- or two-word names (Deepening Hex, Wide Rite, Bared Fang); **61 of the 66 retired ones
use the "Rune of the …" form**, and the new one is the only live rune wearing it. The BR §1 name sweep
over 722 names — every rune live and retired, every talent node, every ability display name, every
status label — found **no collision**, and the near-misses are all reported as hits: `Rune of the
Shared Wild` (retired), `Rune of the Deepening Ruin` (retired), `Shared Hide` and `Shared Scent`
(live), `Shared Devotion` and `Shared Vigil` (nodes), `Shared Grief` (ability), `Avatar of Ruin`,
`Weight of Ruin`, `Ruined Mind` (nodes), `Hex of Ruin` (ability) and the `Ruin` status labels. **A
name is the designer's and was not changed; the convention divergence is a report.**

**NOT OWED, AND SAID SO:**

- **Nothing about §1, §2 or §3 is open.** Every decision the brief listed is reported, driven live
  and asserted, and the chain the brief asked about is bounded by a rule rather than by an amount.
- **The Split Tongue arithmetic is closed by retirement rather than by a third number.**
- **`check_ez` §5's Split Tongue block is KEPT and still passes** — the payload is kept, so the shape
  arm and FB's re-tune arm still pin what they pinned; a kept payload that nothing drives is a
  payload that rots.
- **`check_ed` §2's scan hole is named at §6 and deliberately not closed.**
