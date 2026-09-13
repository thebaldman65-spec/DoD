# Batch GB — Deflection takes the cell, and three files are swept for what they state

*Branch `class-merge`, from `b619463` (GA). `main` is untouched.*

## NEEDS A RULING

1. **THE NODE'S NAME AND CARD TEXT ARE PROPOSED, NOT RULED.** Shipped as *Deflection* — *"This hero's Parry works
   against ranged attacks too."* The name is the designer's to confirm, and both alternatives are one string each
   (`talents.gd`, plus the read site's log label in `battle.gd`, which already says *Deflection*).

   | candidate | exact | contained | shared word (a near-miss counts as a hit, as the brief asked) |
   |---|---|---|---|
   | **Deflection** (proposed) | none | none | **none** |
   | *Parry Ranged Blows* (the brief's label) | none | the glossary term *Parry* | abilities Crushing Blow and Mocking Blow; node Parry More; status Parry Up |
   | *Parry Ranged Attacks* | none | the glossary term *Parry* | nodes More Attack and Parry More; status Parry Up |

   Swept over 746 names in ten populations, read live off the tree by a throwaway probe: 227 abilities, 21 enemies,
   50 enemy abilities, 98 glossary terms, 8 items, 27 talent nodes, 25 relics, 127 runes (retired included), 156
   statuses (id and label) and the 7 tags. **Why Deflection:** it collides with nothing; it is the precedent node's
   name and the field's name; and it is the word the read site's log line already prints when a ranged blow is turned
   (`→ Talent: Deflection — H turns the shot aside`). **Its cost:** the other twenty-six names are phrases and this one
   is a noun. **The text** is true for every holder however many heroes hold it, because the read site asks one
   question of one unit, the defender (§3).
2. **SIX STANDING RULES IN `CLAUDE.md` WHOSE FACTS MOVED UNDER THEM — REPORT-ONLY.** The §4 census found them, and a
   fix would rewrite a standing rule rather than a fact inside one:
   - BH §2's *fifteen points under leave-one-out* is still written as a live rule; the BM §2 block says it retired
     with the lanes at FX. BA §1 still reserves *"the Survivalist's tree"*, which no longer exists.
   - FT §1 says Focus *"is the Hunter's"*; only the Sharpshooter carries Focus (`battle.gd` sets it for that spec).
   - CN's profile rule names *"the relic that swaps a hero's bar for a riskier one"* as an opt-in exception; no such
     relic has ever existed in `relics.gd`.
   - CS's *"CAPPED AT FOUR … DO NOT RAISE IT"* stands beside the Long Draw rune, which raises the count and the cap
     by its own figure. GB added one sentence naming the rune under the rule and did not re-rule the cap.
   - `docs/instrument-rules.md` carries a near-verbatim second copy of CQ §1's *"IS THERE ANYBODY THERE TO PRESS?"*,
     against the rule that a rule lives in one file.

## THE SHORT VERSION

- **§1 — THE NODE.** Enemies Look Past You is retired outright. `tn_deflection` takes its cell at tier 2 and writes
  `deflection`, the one field the parry gate reads for a ranged blow. **Before GB nothing wrote that field, and parry
  could reach no ranged blow**: read at the gate, and measured at 0 of 2,574 ranged blows on four classes and 0 of
  2,860 on twelve specs.
- **§2 — THE MAGNITUDE IS THE PRECEDENT'S, TAKEN.** The deleted Swordmaster node Deflection wrote `deflection` 1, and
  unlike Overpressure it could fire: its read site reads the holder's own field, and the spawn copies every config key
  onto the unit. The gate asks `deflection > 0`, so 1 is all of it.
- **§3 — NAME AND TEXT.** Proposed, above. The only other surfaces the swap made false were the glossary's Parry entry
  and `master.html`'s parry rule, and both now name the exception; two card rows that stacked the retired node lost the
  clause.
- **§4 — THREE FILES SWEPT WHOLE, THE WAY GA SWEPT `docs/instrument-rules.md`.** A census of every present-tense claim
  about the tree, taken against HEAD's snapshot before a correction could shape it: `CLAUDE.md` 1,179 claims, 195
  stale; `docs/state.md` 1,022 claims, 220 stale; `scripts/run_state.gd`'s comments 563 claims, 106 stale. The brief's three
  named claims — the index rows, the `_ready()` comment and the 104.70 KiB figure — are closed with the rest (§4b).
- **§5 — NOT DONE, AS RULED.** The three crit nodes, Heal More When Low and We Do Not Break stay; the relic redirect
  stays deferred; Deepening Hex's floor stays at 8 and its wording is untouched; no spec dissolves, no pool merges, no
  engine becomes a rune and no spine is attached.
- **§6 — DRIVEN LIVE.** Every class, then every spec, parried ranged blows with the node and none without it, and every
  payout was recorded as it happened, off the read site's own log line and paired with the blow it turned.
- **§7 — THE PRE-PASS.** HEAD's unmodified gates and suites ran against the new tree before any of them was touched.
  Every predicted red read as predicted; one red was not predicted (`test_batch_bs` §5), and it is why `master.html`
  §7's tree row moved.
- **VERIFICATION** is below, written after the acceptance run.

## §0 — THE BRIEF'S PREMISES

Each was checked against the repo, the reports and the recon before anything was edited.

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD was `b619463`, equal to `origin/class-merge` by `git ls-remote` before anything moved |
| 2 | *"Small."* | **THE NODE IS; §4 IS NOT** | The swap is small. §4's instruction to sweep three files whole is a census of about 2,700 present-tense claims (§4a) |
| 3 | GA: none of the five alternates qualified, three already nodes and two pay the party once | **HELD** | GA §1a |
| 4 | GA: *"my §2 brief named the wrong two crit nodes"* | **HELD** | GA §0 row 9 |
| 5 | The card says *"65% less likely to target this hero while another ally lives"* | **HELD** | `talents.gd`:181 at HEAD |
| 6 | That text is false whenever other heroes hold it | **HELD** | FY §1b measured it; the read site (`_evade_chance`) re-picks the blow onto another hero, so a second holder is where it lands |
| 7 | *"is every class on day one"* | **HELD IN SUBSTANCE, WITH ONE PRECISION** | Every hero of a class wears every cell the class owns. The designer's `profile.json` is still **v2 on disk** (the fold writes on the next save) and owns no cell of the one tree yet; its folded purses (65–68) exceed the tree's 54, so "day one" is the day it is bought |
| 8 | The replacement is SR-EVADE 2, *Parry ranged blows*, writing `deflection` | **HELD** | SR-EVADE §3: `deflection` "parries ranged blows too", under the line YES; §6 row 2: TODAY |
| 9 | It carries no caveat in SR-REACH | **HELD** | GA's table, SR-EVADE 2: caveat "none" |
| 10 | Defensive, where the node it replaces was defensive | **HELD** | |
| 11 | It sits at tier 2 above *Parry more* at tier 1 | **HELD** | Parry More is `tn_parry`, tier 1 |
| 12 | Declined: a tick on every cast, because tier 2 has *a cooldown ticks on a crit* | **HELD** | `tn_crit_cooldown`, tier 2 |
| 13 | Declined: the opening casts, because tier 3 has *your first casts are free* | **HELD** | `tn_free_casts`, tier 3 |
| 14 | Declined: cap one hit, because tier 3 has *refuse death once* | **HELD** | `tn_refuse_death`, tier 3 |
| 15 | Declined: Penetration is Break, because the recon says it is worth nothing without penetration, and the tree has a penetration node | **HELD** | GA's table, SR-BREAK 3; `tn_pierce`, tier 2 |
| 16 | *"CONFIRM `deflection` IS WRITTEN NOWHERE ELSE"* | **CONFIRMED** | Declared at `unit.gd`:503, read at the parry gate in `battle.gd` and logged beside it. No writer in `scripts/` or `data/`. The one other literal is `test_batch_ak`'s verbatim copy of the deleted node's payload |
| 17 | *"confirm parry today cannot reach a ranged blow"* | **CONFIRMED, READ AND MEASURED** | The gate is `not attacker.is_ranged or strike_target.deflection > 0`, and `_roll_parry` has one caller, inside it. Measured: 0 of 2,574 ranged blows on the four classes, and 0 of 2,860 across all twelve specs (§6) |
| 18 | *"the way FX derived 22 of its 27 from survivors"* | **22 HAVE A PRECEDENT; 18 ARE SURVIVORS** | `talents.gd` at HEAD: 5 carry no precedent, 18 are TAKEN from FP's 43 survivors, and 4 are REFERENCES to live nodes that are not among the 43 (Last Hope, Iron Will, Undying Rage, Devoutness) |
| 19 | *"GA's table says `deflection` exists as a field; it does not say a node ever wrote it"* | **HELD, AND ONE DID** | Deflection (`sm_composure`), the Swordmaster's Poise row 7, `{"stat": {"deflection": 1}}`, deleted at FX (§2) |
| 20 | Overpressure never fired, so a precedent that never fired passes on no magnitude | **HELD AS A TEST; DEFLECTION PASSES IT** | Overpressure's read site read the enemy's own field, and nothing copied the node's value there. Deflection's read site reads the holder, and the spawn copies every config key onto the unit (the same loop at FX's parent). The read site is unchanged since then |
| 21 | Five node names use tag words and the designer ruled that acceptable | **HELD** | `check_ek` §4's `CLASH_EXEMPT`: five node names on BREAK, RESOURCE and DEBUFF. Deflection carries no tag word. `docs/state.md`'s item is closed as ruled |
| 22 | §4: `CLAUDE.md` index rows point at rules not in the reference file | **HELD, AND THE PARAGRAPH ABOVE THE ROWS WAS STALE TOO** | Three rows; the FR §5a / FS §1 block had no row; two positional sentences and one count were false (§4b) |
| 23 | §4: a stale comment in `run_state.gd` | **HELD** | Lines 198–199: *"decided once in `_ready()`"* |
| 24 | §4: a stale size figure in `docs/state.md` | **HELD** | The knowledge-sync section's 104.70 KiB for `docs/instrument-rules.md`; the file is 118,337 B (115.56 KiB) |
| 25 | *"GA found 18 stale claims of 81 … where FZ had found two by reading"* | **HELD** | GA §3 |
| 26 | §6: *"GA found reading the source counted three gates where recording the calls found four"* | **FY FOUND IT** | FY §5b's pre-pass; GA §0 row 20 quoted it as FY's |
| 27 | §5: the crit nodes, Heal More When Low, We Do Not Break, the relic redirect, Deepening Hex's floor | **HELD** | GA's rulings; `RUIN_FLOOR := 8` |
| 28 | *"`master.html` … and the stamp"* | **EDITED AND BUMPED** | A player can meet this change: the tree table, the parry bullet and two card rows move, so the stamp moves with them |

## §1 — THE NODE

**Enemies Look Past You (`tn_look_past`, `ghillie` 65, tier 2) is retired outright and `tn_deflection` takes its
cell.**

```
{"id": "tn_deflection", "name": "Deflection", "tier": 2,
	"desc": "This hero's Parry works against ranged attacks too.",
	"payload": {"stat": {"deflection": 1}}},
```

- **The field is read at one line and written by nothing else.** The parry gate in `_resolve`'s strike loop is
  `not attacker.is_ranged or strike_target.deflection > 0`, and `_roll_parry` has exactly one caller, inside that
  branch. So a ranged blow reached no parry roll at all before GB, and with the node it reaches the same roll a melee
  blow does — base chance, `parry_bonus`, stance and all.
- **A new id rather than the old one**, because an id is a name code keys on. Keeping `tn_look_past` would have
  carried any owned cell straight across and left a parry node wearing a targeting id. A cell whose id leaves the tree
  refunds itself: `cells_spent` skips an unknown id and `worn_learned` drops it. **The designer's file is still v2 on
  disk and owns no cell of the one tree**, so nothing was carried or lost.
- **The `ghillie` field and both its read sites stay** (`_evade_chance` and `_evade_source`), and nothing writes the
  field now. The next thing to write it pays through them. `_evade_source`'s label still says *Enemies Look Past You*;
  that label cannot print while nothing writes the field, and it is queued with FX's dormant labels in
  `docs/state.md`.
- **What else the swap made false**, and nothing more moved:
  - `data/glossary.json`'s Parry entry said ranged attacks cannot be parried; it now names the exception.
  - `docs/master.html`: the parry bullet names the exception; the Dug In and Camouflage rows lost the clause stacking
    the retired node; the tree table's tier-2 row; §7's prose; the stamp.

## §2 — THE MAGNITUDE

**The precedent is Deflection (`sm_composure`), the Swordmaster's Poise row 7, `{"stat": {"deflection": 1}}`,
deleted with the twelve trees at FX. Its magnitude is TAKEN.**

- **It could fire, which is the test Overpressure failed.** Overpressure's read site read the ENEMY's own field and
  nothing ever copied the node's value there, so it paid nothing at any magnitude. Deflection's read site reads the
  holder's own field, and the spawn copies every config key onto the unit — the same loop at FX's parent. The parry
  gate is unchanged since then, and eight enemy kinds attack from range. **So the precedent's number was a live
  number, and it is inherited rather than re-priced.**
- **The magnitude is a switch.** The gate asks `deflection > 0`, so any positive value is the whole effect and 1 is
  all of it. `check_fx` treats the field as a switch for exactly that reason: its card states the rule, not a number.
- **FX never had the choice.** It drew its precedents from FP's survivor list, and FP's list for the Swordmaster
  leaves Deflection out (§0 row 18), so the field went dormant with its tree rather than by a decision.

## §3 — THE NAME AND THE TEXT

The proposal and the sweep are under NEEDS A RULING. Two things about the text:

- **It had one job, and it is the one the old node failed.** *This hero's Parry works against ranged attacks too.*
  The read site asks about the defender and nobody else, so the sentence is true for every hero who holds it however
  many others do. Enemies Look Past You read the same way on its card and paid by moving the blow onto somebody else,
  which FY measured as three of the four heroes targeted MORE with all four holding it.
- **The precedent's *"arrows and spells alike"* is dropped.** An area spell is still not parried — the glossary says
  so — and flavour a player could take as a rule is cut under the text standard.
- **`CLAUDE.md` carries the ruling as a rule now**, in the FX block: a node's text must be true when every hero holds
  it, and *redundant is not false* — Heal More When Low and We Do Not Break stamp the best holder's figure on every
  hero, so a second holder adds nothing and both cards stay true.

## §4 — THREE FILES SWEPT WHOLE

### 4a. The census came first, and it read HEAD

Fourteen slices, each a table of every present-tense claim about the tree with a verdict and the evidence for it:
six of `CLAUDE.md`, six of `docs/state.md` (the WHERE block excepted, since it is replaced) and two of
`scripts/run_state.gd`'s comments. Thirteen were taken by read-only agents against a snapshot of HEAD and GA's
acceptance logs, and the last (`docs/state.md` from *The changelog* to the end) was taken by the batch itself. **No
correction could shape the population, because the population was HEAD's text.**

**The rules GA wrote for `docs/instrument-rules.md`, applied unchanged:**
- **Gone → delete it**, or re-tense it where the sentence narrates what a batch did (DR's rule).
- **Moved → correct the name**; a line-number citation is dropped rather than re-numbered (EB §2).
- **A stale figure → delete the figure** and keep the sentence (DJ §3). No new number was substituted unless the
  code in the same place states it.
- **Outside the population**: history, dated measurements that say when they were taken, quotations, and claims
  nothing in the tree can settle (UNVERIFIABLE).
- **Citations of deleted talent nodes stay**, because FX's block tells the reader to take every such citation as the
  record of why a rule exists, not as a claim that the node is live.
- **Report-only** where a fix would rewrite a standing rule or a ruling (NEEDS A RULING, item 2).

| file | claims | hold | stale: gone | moved | figure | unverifiable |
|---|---|---|---|---|---|---|
| `CLAUDE.md` (six slices) | 1,179 | 951 | 76 | 41 | 78 | 33 |
| `docs/state.md` (five agent slices) | 954 | 707 | 88 | 35 | 78 | 46 |
| `docs/state.md` (the tail, the batch's own) | 68 | 42 | 3 | 1 | 15 | 7 |
| `scripts/run_state.gd` (comments) | 563 | 451 | 56 | 17 | 33 | 6 |
| **all three** | **2,764** | **2,151** | **223** | **94** | **204** | **92** |

### 4b. What was corrected

**Counted from the diff rather than tallied by hand:**

| file | lines (+ / −) | hunks |
|---|---|---|
| `CLAUDE.md` | +228 / −206 | 134 |
| `docs/state.md` (rewritten: the WHERE block, GB's queue section and the census corrections) | +421 / −366 | 155 |
| `scripts/run_state.gd` (comments only — all 1,553 code lines identical to HEAD once comments are stripped) | +125 / −120 | 81 |

**Where each stale row went:**
- **Corrected in place** — deleted, re-tensed, renamed, or its figure dropped. This is most of them.
- **Kept as FX's record**: a deleted node, lane or tree cited as the reason a rule exists — the governor table's node
  terms, the Madness lane, Instinctive Rotation, Layered Faith, Communion, the Warden talent's Iron Will — because FX's
  block tells the reader to take every such citation that way.
- **Kept as dated or history**: a sentence that says when its measurement was taken, or narrates what a batch did.
- **Marked where they stand**: eighteen items in `docs/state.md`'s queue whose subject FX removed, or an earlier batch
  closed, carry a struck heading and one line saying so, and keep their text as the record.
- **Report-only**: the six `CLAUDE.md` rules under NEEDS A RULING, and three queue items whose correction would decide
  the item rather than a fact inside it.

**The brief's three named claims are closed with the rest:**
- **`CLAUDE.md`'s index** lost the three rows whose rules live in `CLAUDE.md` itself (FM §1, FN §1, FN §3), gained the
  row the reference file was missing (FR §5a / FS §1), and its paragraph no longer counts the blocks or names the last
  rows by batch — both of which had gone stale twice. It names no MOVED heading in prose, because `check_ff` §1 counts
  every non-row line that carries one.
- **`scripts/run_state.gd`'s FI header** says the redirect is decided in `_init()`, which is what the code does.
- **`docs/state.md`'s 104.70 KiB** went with the whole heaviest-files list, every figure of which was FH's; the section
  names the instruments that print the live sizes.

**One correction was wrong, and it was caught before the battery.** The census left `CLAUDE.md`'s *"his own draft card
Call the Wilds"* standing, and I "corrected" it to *Call of the Wild*. Those are two cards: *Call the Wilds*
(`call_wilds`) is the one that calls `_do_summon`, and *Call of the Wild* (`call_wild`) is the boss-pool summon
`NO_BAR_BY_DESIGN` names. The literal sweep flagged the lost name, the code settled it, and the line was restored. **A
correction is a claim too, and it gets the same check.**

### 4c. What the sweep found outside the three files

Queued in `docs/state.md` under *FOUND AT GB AND NOT FIXED*, with the two player-facing items first: a zone boss's
victory text still says *"Each spec that walked this road banks 1 talent point"* (it banks per class since FX), and
the run summary caps its tier at *"of 10"* where a zone has sixteen slots. The rest are a recap-ledger gap (five
`_resolve_special` branches subtract health directly, so Blood Price's and Dark Pact's costs are never booked), a
forfeit that books a summoned node, a fixed modifier that never reaches a mini-boss, stale comments and gate prints in
twelve files, and five dormant branches that only suites drive.

### 4d. The pins the corrections moved

**One pin moved, and it was found before the battery.** `test_batch_br` §5 asked `CLAUDE.md` for the figure
*"is 24 of a target 24"*, which the census found stale (`CLASS_DRAFT_POOLS` holds 25 against the original target of 24)
and GA's rule deleted. The literal sweep flagged it; `check_ec` §2 named it (24 / 2 against the corrected document);
and the suite, its §5 still HEAD's, read **1590 / 1**, the one FAIL line being §5's own. **It is re-pointed to the claim
the figure recorded, *THE CLASS-WIDE TRANCHE IS PAID IN FULL*, with the reason written at the site.**

**The control was two-armed.** `check_ec` read **23 / 0** on the corrected tree — its row. With that sentence mutated
by one letter of the same length (*PAID* → *PAIR*) it read **25 / 3**, naming `test_batch_br`'s new needle and also
`test_batch_bo`'s *PAID IN FULL*, so both pins are demonstrably read. Restored from a scratch copy (md5 equal), it read
23 / 0 again, and the suite read **1590 / 0**.

**The pin manifest's only non-positional change was that one pin going unresolved;** every other difference between
the tracked manifest and a regeneration was a line shift inside the four gates GB edited. The manifest is regenerated
after the last source edit. **The acceptance battery added nothing here**: `check_ed` read 18 / 0 and `check_ec` 23 / 0
inside it, the rows they read standalone, and no target went red but `check_cm_live`, whose 4 FAIL lines are
GA's word for word.

## §5 — NOT DONE, AS RULED

The three crit nodes stay. Heal More When Low and We Do Not Break stay. The relic redirect stays deferred until the
game can be test-played. Deepening Hex's floor stays at 8 and its wording is untouched. No spec dissolves, no pool
merges, no engine becomes a rune, and no spine is attached.

## §6 — DRIVEN LIVE, AGAINST A RANGED BLOW

**The instrument is the sim with the combat log echoed** (`DOD_SIM_DEBUG=1`), against a warband of three ranged kinds
(`DOD_SIM_ENEMIES=archer,hexer,slinger`), each arm run with and without `DOD_SIM_TALENTS=tn_deflection`:

```
DOD_SIM=400 DOD_SIM_SPECS=berserker,pyromancer,holy,sharpshooter DOD_SIM_ENEMIES=archer,hexer,slinger
    [DOD_SIM_TALENTS=tn_deflection] DOD_SIM_DEBUG=1 Godot --headless --fixed-fps 240 --path . res://scenes/battle.tscn
DOD_SIM=480 DOD_SIM_ROTATE=1 DOD_SIM_ENEMIES=archer,hexer,slinger [DOD_SIM_TALENTS=tn_deflection] DOD_SIM_DEBUG=1 …
```

**Each payout is recorded as it happens**: the read site logs `→ Talent: Deflection — H turns the shot aside` at the
moment it turns a blow. The analyzer pairs every such line with the next hit line, which must be a ranged enemy's blow
on the same hero carrying *(parried*, and conversely requires every parried enemy blow on a hero to have been
announced. **Both directions read zero unpaired in all eight logs.** The sim's own *"Rolls: parry"* figure is not used,
because its denominator mixes both sides' attacks.

**One party of each class, 400 battles an arm:**

| hero | with: blows landed | parried (= announced) | rate | without: blows landed | parried |
|---|---|---|---|---|---|
| Berserker | 1,139 | 57 | 5.0% | 1,172 | 0 |
| Holy | 486 | 28 | 5.8% | 492 | 0 |
| Pyromancer | 428 | 21 | 4.9% | 427 | 0 |
| Sharpshooter | 499 | 30 | 6.0% | 483 | 0 |
| **total** | **2,552** | **136** | **5.3%** | **2,574** | **0** |

**Every spec, rotated, 480 battles an arm:**

| spec | with: landed | parried | rate | without: landed | parried |
|---|---|---|---|---|---|
| Arcanist | 182 | 6 | 3.3% | 205 | 0 |
| Beastmaster | 168 | 5 | 3.0% | 198 | 0 |
| Berserker | 498 | 32 | 6.4% | 474 | 0 |
| Cryomancer | 161 | 7 | 4.3% | 177 | 0 |
| Devout | 154 | 3 | 1.9% | 188 | 0 |
| Holy | 174 | 12 | 6.9% | 202 | 0 |
| Occultist | 143 | 6 | 4.2% | 154 | 0 |
| Pyromancer | 158 | 14 | 8.9% | 152 | 0 |
| Sharpshooter | 149 | 4 | 2.7% | 143 | 0 |
| Survivalist | 154 | 11 | 7.1% | 145 | 0 |
| Swordmaster | 456 | 60 | 13.2% | 431 | 0 |
| Warden | 395 | 21 | 5.3% | 391 | 0 |
| **total** | **2,792** | **181** | **6.5%** | **2,860** | **0** |

- **Every class and every spec paid, and nobody paid without the node.** The rates sit at the base parry chance
  (0.05) for most heroes, and above it where a hero's own kit adds to the parry roll, as the Swordmaster's does —
  `_roll_parry` adds parry statuses and spends banked guards, and reads no stance. A per-spec rate at these counts
  carries a wide band; the claim the table carries is the zero column and the nonzero one, not the ranking.
- **The control is clean by construction.** The standalone battle sim gives a bot hero no talent unless
  `DOD_SIM_TALENTS` names one, so the arm without the node wears nothing and the arm with it wears Deflection
  alone.
- **Two smaller pilot pairs (40 and 48 battles) read the same way**: 14 of 246 and 19 of 280 with the node, 0 of 244
  and 0 of 275 without, pairing clean.
- **`check_fx` §4b drives it on all four classes as the defender, every battery**: a melee blow first, proving the
  forced parry was on the table; then a ranged blow refused without the node and turned with it, the log line counted
  as the payout happens. **The acceptance run printed it**, each cell *[health the blow took, turned-shot lines]*:

| defender | melee, without | melee, with | ranged, without | ranged, with |
|---|---|---|---|---|
| Warrior | 7, 0 | 7, 0 | 28, 0 | 7, 1 |
| Mage | 8, 0 | 8, 0 | 31, 0 | 8, 1 |
| Cleric | 8, 0 | 8, 0 | 30, 0 | 8, 1 |
| Hunter | 9, 0 | 9, 0 | 33, 0 | 9, 1 |

The melee blow takes the same health with the node and without it and prints no line either way, so the forced
parry was on the table. The ranged blow is not parried without the node (28 to 33 taken, no line), and with it is
turned to exactly the parried melee figure, with one line. The gate asserts those three shapes on every class, not
the figures.

## §7 — THE PRE-PASS: HEAD'S GATES AGAINST THE NEW TREE

HEAD's unmodified gates and suites ran as a full 108-target battery against the tree with only `talents.gd` and
`glossary.json` changed, the predictions written first.

| target | predicted | read |
|---|---|---|
| `check_fx` | 493 / 2 (§1 text-table row missing for `deflection`; §4b names `ghillie`) | **493 / 2**, both FAIL lines those two |
| `test_batch_ba` | 634 / 1 + a throw | **635 / 2 + a throw** — the prediction was wrong: the throw is inside `Talents.desc_for`, which returns "" to its caller, so the tooltip check still runs and fails |
| `test_batch_br` | 1590 / 7 | **1590 / 7** |
| `test_batch_ak` | 338 / 0 | **338 / 0** |
| `check_cm_live` | 13 / 4, the sanctioned red | **13 / 4** |
| `test_batch_bs` | at its row | **one red, NOT PREDICTED**: §5 requires `master.html` §7 to name every node of the live tree, and derives the names from `Talents.TREE` at runtime — so no literal sweep of HEAD against the working copy could see the needle |
| every other target | at its row | **at its row**; harness 22 / 382 / 8 |
| `check_de` | 5 reds | **6 reds**: the five, and `test_batch_bs` going redder |

The tree was frozen for the run (every tracked and untracked file hashed before and after; no difference), no
Godot process was left in `ps`, and the saves were untouched.

## §8 — THE INSTRUMENTS REPAIRED

Each repair went to the question the check was asking, after the unmodified copy had been read against the new tree.

- **`check_fx`**: the TEXT row for `ghillie` is gone; `deflection` joins `no_cover` in `SWITCHES` (a field whose card
  states the rule, not a number); `DRIVEN_FIELDS` names it; and the §4b arm is rewritten to drive Deflection on all four
  classes, melee and ranged, off and on. **496 / 0 standalone.**
- **`test_batch_ak`**: its precedent table maps `sm_composure` to `tn_deflection`, so the deleted node's payload is
  asked of the node that carries it now. **338 / 0.**
- **`test_batch_ba`**: it asked whether the node that owes Ghillie Suit's 65 pays it. No node owes it now — the same
  case FX deleted twenty-one siblings under — so the two checks went the same way, with their count recorded at the
  site. **633 / 0.**
- **`test_batch_br`**: §2 asserts no node of the tree writes `ghillie`; the Camouflage comparison first asserts that a
  Survivalist wearing all twenty-seven nodes carries no Ghillie field and does carry Deflection, then sets the field to
  measure the stacking. **1590 / 0.** Its §5 pin is re-pointed as well (§4d).
- **`test_batch_bs`** needed no edit: `master.html` §7's tree row names Deflection, and it reads **246 / 0**.
- **`baselines.json`**: `check_fx` and `test_batch_ba` move to their new counts, with the reason prepended to each
  note. After the acceptance battery each row rests on two readings of its new count, the standalone and the
  battery's, so `checks_obs` is 2 on both; `fails_obs` gained the battery's reading too (`check_fx` 2,
  `test_batch_ba` 10), and each note now ends by naming it. **No other row moved**: the battery read every other
  target at its row.

## VERIFICATION

**The acceptance battery ran over the finished tree, after every document and every source edit, with the
predictions written first.** All 108 targets went through `run_battery.sh`, which exited 0. No Godot process was in
`ps` before the launch or after it (the rows were read, not counted), and every tracked, untracked and ignored file
in the repo was hashed before and after, with the four player saves: 486 lines, 482 repo files and the 4 saves,
identical byte for byte.

| target | predicted | read |
|---|---|---|
| `check_fx` | 496 / 0 | **496 / 0** |
| `test_batch_ba` | 633 / 0 | **633 / 0** |
| `test_batch_br` | 1590 / 0 | **1590 / 0** |
| `test_batch_ak` | 338 / 0 | **338 / 0** |
| `test_batch_bs` | 246 / 0 | **246 / 0** |
| `check_ec` | 23 / 0 | **23 / 0** |
| `check_ed` | at its row, 0 failures | **18 / 0**, its row |
| `check_ff`, `check_fg`, `check_fr`, `check_es`, `check_dv`, `check_ea` | at their rows | **55 / 0, 22 / 0, 25 / 0, 57 / 0, 83 / 0, 86 / 0**, each at its row |
| `check_cm_live` | 13 / 4, the sanctioned red | **13 / 4**, its 4 FAIL lines identical to GA's |
| harness | 22 / 382 / 8 | **22 / 382 / 8**, no throws |
| `check_fh`, `check_eh`, `check_eg` | at their rows (their parties now wear Deflection) | **163 / 0, 175 / 0, 68 / 0**, each at its row |
| `test_batch_an`, `test_batch_bk` | inside their bands | **6054** in [6046, 6063]; **130** in [128, 130] |
| `check_de` | 0 failures | **449 / 0, 0 notices** |
| every other target | at its row, 0 failures, 0 throws | **at its row**, and no target threw |

**Every prediction held.**

- **Parse:** 0 `Parse Error` lines across the 108 logs, read off stderr and never off a tally or an exit code; 0
  `SCRIPT ERROR` lines.
- **`check_de`:** 449 checks / 0 failures / 0 notices. It has no row of its own, by design: it is the post-pass that
  reads everyone else's.
- **`check_cm_live`:** 13 / 4, the sanctioned red, its 4 FAIL lines identical to GA's.
- **`check_fx` §4b**, the live drive it prints every battery: 28 to 33 health taken from an unparried ranged blow,
  and the parried figure with one turned-shot line once the node is on, on all four classes. The table is in §6,
  read off this run.
- **The documents:** the literal sweep of every edited document and source against HEAD (every string literal of four
  characters or more in every `.gd`, raw, lowered and whitespace-flattened) lost one needle a reader holds, and §4d
  repaired it; `build_pin_manifest.py --check` reads current; `check_ed` 18 / 0 and `check_ec` 23 / 0 standalone.
- **Two files changed after the battery, and each is accounted for.** `baselines.json` gained this run's reading on
  the two rows GB moved (§8): the same literal sweep, run against the copy the battery read, lost and gained
  nothing, and `check_de`, re-run over this battery's logs against the bumped rows, read 449 / 0 / 0 again. The
  other is this report, and no gate reads a report: every non-comment `reports` in a `.gd` file is a check's
  label or `check_fr`'s path shape.
- **The saves:** all four hash the same as GB's own backup (`save-backups/GB-20260912-093654/`), taken before
  anything moved, and the same as the freeze's own save lines: `profile.json` `b05e329b…`, `run_save.bin` `c44d45da…`,
  `relics.json` `fdc12ffa…`, `settings.cfg` `0c1b39c3…`.
