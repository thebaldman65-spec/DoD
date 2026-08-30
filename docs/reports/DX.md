# BATCH DX — A SIXTH INSTANCE EARNS A CONSTRUCTION RULE

*2026-08-29. Three items. **The rule the brief asked for, the sweep behind it, and the thirty-one
sites that sweep found — all pinning one number. The project's second unseeded flake, seeded and
settled at zero. And the `CLASS_POOLS` decision, priced with nothing authored.** No ability
magnitude moved and the draft is untouched at 149.*

---

## THE BRIEF'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because three of them changed the work.

1. **§2 says the harness flake was "observed red once in 34 readings" at roughly 3%, on
   *"the walk crossed a event"*. BOTH HALVES ARE TOO NARROW.** Over 400 unseeded walks the type
   that actually reached zero was **`blacksmith`**, not `event` — and `merchant` and `event` each
   came within **one** of it. **Three of the six types are at risk, not one.** The rate is well
   under 3%: 2 observed in ~474 readings, counting DW's own and **40 clean standalone re-runs at
   HEAD** taken before anything was touched.
2. **§2 asks me to say whether `test_batch_at` §1 is then the last unseeded flake. It is — and the
   sweep that would establish it does not exist.** See §2 below; this is the more useful answer and
   it is not the one the brief expected.
3. **§3 says "seven finished abilities existing in no pool, reachable by nothing" and that
   retiring the container "would delete the last listing" of them. THE SECOND HALF IS WRONG AND IT
   CHANGES A PRICE.** `Classes.pool_ability()` resolves by name through a chain that reads
   `vault_ability()` and **never consults `CLASS_POOLS` at all** — all seven still resolve with the
   container deleted. What deletion costs is the *manifest* and their place in the corpus (227 →
   220), which is real and smaller than recorded.
4. **§1's own rule needed an exemption its first sweep found.** Applied literally it would have
   deleted five working instruments. See §1.
5. **Everything else held**, including DW's `test_batch_cp` 697 and its 207-of-227 walk, DV's
   seven-name orphan list (re-derived live, exactly those seven), and `CLASS_POOLS` at 61.

---

## §1 — AN ASSERTION AGAINST A GROWING COLLECTION IS A FLOOR, NEVER AN EQUALITY

### THE RULE, AS RECORDED

> **Never assert an equality against a collection that grows.** Changelog entries, corpus size,
> pool depth, suite counts, call-site counts — **assert a floor, or assert a property.** An equality
> against a growing set fails on the next batch that does its job, and the failure looks like a
> regression.

It is in `CLAUDE.md` under its own heading, with the exemption below and the negative-control
requirement attached. **The harm it names is not the failing — it is the failing's disguise.** A red
meaning *a batch did its job* is indistinguishable from a red meaning *something was deleted*, and
the next reader has to re-derive which. A floor's failure has exactly one meaning.

### THE SWEEP, REPORTED BEFORE ANY OF IT WAS REPAIRED

Mechanical, not by eye: every `ok(...)` call in all 82 suites, gates and fixtures was parsed with
comments stripped, then filtered to those whose **condition reads a collection this project adds
to** — directly, or through a variable accumulated from one in the same function.

**THE POPULATION IS FORTY-ONE SITES ACROSS THIRTEEN FILES, AND EVERY ONE OF THEM PINS THE DRAFT.**
Counted from the diff, not by hand — an earlier draft of this report said thirty-one and was wrong.

| what is pinned | sites | where |
|---|---|---|
| spec draft half `== 125` | **15** | `check_dr`, `bo`, `bp`, `bq`, `br`, `bt`, `bu`, `bv`, `bw`, `cb`, `ce` ×2, `cp`, `cd` ×2 |
| per-class pool `.size() == 6` | **11** | `bo`, `bp`, `bq` ×2, `br`, `bt`, `bu`, `bv`, `bw`, `cb`, `ce` |
| whole draft `== 149` | **9** | `check_dr`, `br`, `bv`, `bw`, `cb`, `ce` ×2, `cd` ×2 |
| class draft half `== 24` | **4** | `check_dr`, `bq`, `br`, `cd` |
| per-spec depth `== PER_SPEC_DEPTH[spec]` | **1** | `cd` |
| the Beastmaster's boss pool `== 5` | **1** | `bo` |

**`>=` APPEARED NOWHERE IN ANY OF THEM.** DO added twenty-two cards, DR a net +1 and DS six — so
**each of the last three batches to author a card had to hand-bump a dozen files at once**, and a
batch that missed one would have shipped a red that read as a regression. Nobody had recorded that
as a cost, because each batch paid it once and it looked like bookkeeping.

**THE ASSERTIONS THEMSELVES CARRY THE EVIDENCE.** `test_batch_bo`'s site records five separate
re-pointings in its own comment — *"RE-POINTED AGAIN BY BATCH BU … BY BATCH BV … CLOSED BY BATCH BW
… RE-POINTED BY BATCH CB"* — and its failure message still read **"one hundred and eighteen ship"**
against a live value of **125**, stale by two batches. A second copy of a count, inside the
assertion written to catch drift.

### WHAT WAS SWEPT, EXAMINED AND DELIBERATELY LEFT ALONE

A rule's first sweep is also where it finds out what it must *not* touch.

| site | why it stays |
|---|---|
| `check_di:148` `sites == CALL_SITES` | **The brief's own rule names call-site counts — and this equality is load-bearing.** It caught DP silently deleting an `_apply_status` site, which is what it is for; its sibling `SRC_FLOOR` is a ratchet because that one measures progress. **One site, and its message reads as a notice.** |
| `check_dv:174/175` `SPEC_POOLS == 42 / 40 distinct` | DV's boss-pick census. One site each; messages say *"not the 42 on record"* — a staleness notice, not a regression claim. |
| `check_dv:185` Holy's boss pool `== 1` | A tripwire on an **open finding**: if the shortfall is ruled on and the pool deepens, the gate says DV's report is stale. That is the whole point of it. |
| `check_cz:359` `SHIELD_SPECIALS == SHIELDS` | The only thing asserting the registry's membership; a seventh shield **should** have to be reviewed against the cap rule. |
| `check_dv:329` archive `== 149` | **Not a growing collection** — only a cut moves the archive. DW ruled this correctly and it stands. |
| `CLASS_POOLS` freeze pins (`bt`, `cb`, `ce`, `bq`, `br`, `check_dv`) | A **frozen** collection is not a growing one; being byte-untouched is the claim. §3's ruling would move six sites at once, deliberately. |
| `.size() == 12` / `== 4` / tree `== 27` / `== 324` | Structural invariants — twelve specs, four classes, 27 cells. A batch doing its job does not add a thirteenth spec. |
| tranche-lead pins (`spec_draft_pool(x)[0] == …`, `slice(0,5) == […]`) | Properties of the **head** of a list. Appending cannot break them, which is why they were authored that way. |

### THE RULE'S OWN FIRST CORRECTION — A STALENESS TRIPWIRE

Applied literally the rule deletes five working instruments. So it grew a clause, with a name and a
two-question test:

> **A staleness tripwire is a SINGLE site whose failure message says the ground moved and names what
> to re-derive.** It is a property assertion wearing an equality's clothes and it is legitimate.
> **Thirty copies of one is not a tripwire, it is a tax.**

Both questions must pass: *is this the only site pinning this number*, and *does its message read as
a notice rather than as a regression*. All five above pass; none of the thirty-one draft sites did.

### THE REPAIR — THIRTY FLOORS AND ONE EQUALITY

**THIRTY-FIVE SITES ASSERT A FLOOR NOW**, across twelve files, each with a message naming the
**live figure** and the **direction**: *"the spec pools have FALLEN to %d, below the 125 that shipped"*. A floor whose
message still says *"holds 149"* is half-repaired — the reader still cannot tell the two meanings
apart.

**THE REMAINING SIX ARE KEPT ON PURPOSE AND ALL SIX ARE IN ONE FILE.** A floor cannot see a card *arriving*, and a card arriving
unannounced is exactly what `test_batch_cd.PER_SPEC_DEPTH` exists to force a batch to state. The
equality survives in **`test_batch_cd` alone** — the per-spec table pin, the three totals and two
restatements of them — beside the table a new card must move anyway, **so the failure costs one edit
in one file instead of thirty-five across twelve.**

**AND THAT ONE EQUALITY COULD NOT SAY WHAT HAD MOVED.** Its message read
`"the draft stands at %d of %d" % [DRAFT_TARGET, DRAFT_TARGET]` — the target printed twice, so the
single assertion left to announce a moved draft would have reported *149 of 149* while the draft
stood at 150. **The second-copy-of-a-count defect, sitting inside the tripwire written to catch
drift** — and DW found the identical shape in two `test_batch_cp` messages one batch earlier. Three
messages print live figures now.

**NOT ONE CHECK WAS DELETED AND NOT ONE COUNT MOVED.** Converting `==` to `>=` is one `ok()` before
and one after; all thirteen touched targets read their baselines exactly (see §5).

---

## §2 — THE SECOND UNSEEDED FLAKE, SEEDED

**`test_run_harness` gate 2 is seeded and it settled at ZERO.** Thirty seeded runs, **thirty
byte-identical walks**, 165 checks and 0 failures every time — so it was a flake and not a finding,
which is the half the brief asked to have measured rather than assumed.

### WHAT THE FLAKE ACTUALLY IS

Gate 2 walks three randomly generated maps by taking `reachable()[0]` at every step, then asserts
each of six node types was crossed at least once. `seed()` was called **zero** times in the file.

**MEASURED OVER 400 UNSEEDED WALKS, BEFORE ANYTHING WAS CHANGED:**

| type | minimum over 400 | reached zero |
|---|---|---|
| `fight` | 9 | never |
| `elite` | 2 | never |
| `miniboss` | 3 | never |
| **`blacksmith`** | **0** | **once** |
| `merchant` | 1 | never |
| `event` | 1 | never |

The walk length is **49 in all 400**. So **three of the six types are at risk and `blacksmith` is
the one that actually failed**, where DW's single observation had named `event`. **A repair aimed at
the recorded symptom rather than the measured population is how a flake comes back.**

### THE REPAIR, AND WHY IT IS SHAPED THIS WAY

**THE ASSERTION IS NOT WIDENED.** The six types being present is the question — the loop's own
comment says a walk that met no elite proves nothing about elites — so relaxing it to five would
delete the check rather than repair it. That is DD's rule and it is the reason the band was never
the answer.

**THE SEED GOES AT EVERY BOARD GENERATION, NOT ONCE BEFORE THE WALK.** Both shapes were measured and
both are exactly repeatable today. Seeding once leaves zones 1 and 2 drawing off whatever the loop
consumed before them, so **one added RNG draw inside the walk would silently re-roll two of the three
boards** and could re-flake the gate with nothing in the diff to explain it. Per-generation makes the
guarantee **per-board** — `bo`'s per-pair seed one layer out. The three boards stay **different from
one another**, because `_generate_map` reads `zone_idx`: the seeded walk crosses 12 fights, 6 elites,
3 minibosses, 9 blacksmiths, 12 merchants and 3 events, so this buys determinism without buying one
map walked three times.

**THE SEED IS THE BATCH DATE BY CONVENTION AND WAS VERIFIED, NOT FISHED FOR.** `seed(20260829)`
follows `bo`'s and `test_rune_battle`'s idiom, was taken first, and crosses all six types.

**THE NEGATIVE CONTROL IS A SEED THAT MISSES.** Searching seeds 1–119 finds 44 that drop a type;
`seed(101)` drops **`event`** and fails gate 2 on *"the walk crossed a event"* — **DW's own red,
reproduced on demand** — plus the ordinary-fight range at 6.0. The assertion still bites.
*(Those 44 are a search over small consecutive integers, a poorly-mixed corner of the seed space —
they are a source of controls, not a rate.)*

**FOUR CODE LINES**, proven by comment-stripped diff against `HEAD`: a two-line helper and two call
sites. The check count does not move.

### IS `test_batch_at` §1 NOW THE LAST UNSEEDED FLAKE?

**Yes — and the sweep that would establish it does not exist, which is worth more than the answer.**

A source sweep fails in **both** directions:

- **`seed()`-count is not evidence of a flake.** Twenty suites and gates make unseeded random draws
  and are perfectly stable — `bk` and `an` generate whole maps.
- **`test_batch_at` calls no RNG function at all.** Its one `seed()` is at line 603 and every use is
  *downstream* of the check that flakes. The noise is `battle.gd`'s `randf_range(0.9, 1.1)` in the
  strike loop, which **nothing in the suite tree can see.**

**Only readings find a flake, and the readings are in `baselines.json`.** Three rows carry a `flake`
field: `test_rune_battle` (seeded at DF §0, closed), `harness_2` (seeded here, closed) and
`test_batch_at` §1 — **which is now the only one.** The claim is true and it rests on the readings,
not on a grep.

---

## §3 — `CLASS_POOLS`: THE OPTIONS, PRICED. NOTHING AUTHORED.

**DV's ruling stands: it is a lost feature, not scaffolding.** Three independent sources agree it was
live, `run_state.gd` records AN §4 re-pointing the award away from it, and `test_batch_an` asserts
`roll_ability_offer()` deleted.

### THE DIAGNOSIS IS SHARPER THAN "SEVEN ORPHANS": THEY ARE THE VAULT

`Classes.vault_ability()` holds **38 ability definitions** kept deliberately. Its own header:

> *"Abilities that left a kit but never left the code: every one of these still has its `special`
> handler in `battle.gd`, so they return as earnable picks **without a line of new mechanics**."*

`CLASS_POOLS`' own curation comment calls its contents *"the sibling specs' abilities **plus the
class's vaulted ones**"*. **So `vault_ability()` is the mechanism and `CLASS_POOLS` is its
manifest.** Later batches re-homed **31 of the 38** into spec draft pools and boss pools. **AN §4
closed the class draw, which was the vault's only remaining exit** — and the seven still inside are
exactly the seven listed nowhere else.

**AND THE SEVEN ARE NOT INERT. THEY HAVE BEEN ABSORBING MAINTENANCE FOR FOUR BATCHES.**

- **DK §1 widened `sanctuary`'s heal to `_hero_side()`** and measured it on a live bear — 1200 off a
  10000 body. The handler's own comment says *"VAULTED ability's machinery (kept)"*.
- **DL §1 widened Rallying Shout's Pressure clause** (`special: "rally"` — **not** Rally, whose
  special is `rally_ally`), measured 30 Pressure shed on a summoned Ursus, and **authored a new
  `resource_name == ""` guard** on its resource loop.
- **DM §3 read Divine Wrath's two clauses** in the hero/ally audit — one of the six cards that
  closed that thread.
- **Two of the seven sit in `Ability.PURE_BUFFS`** (Mana Shield, Divine Wrath — both capped at 1.0 by
  CY/CZ's pass) and **two in `HEAL_SPECIALS`** (Sanctuary, Dawnbreak, both correctly running a bar).
- **All seven are in `ability_corpus()`**, so every population sweep in the project has been auditing
  them: the width gates, the text rules, `check_cn`'s bar criterion, `check_dw`'s two populations.

**Three recent batches spent measured, documented engineering on cards no player can obtain, and
nothing said so.** That is the cost of leaving the question open, stated as what has already
happened rather than as a risk.

### THE SEVEN, BY NAME, WITH WHAT EACH DOES

Derived live from `Classes.pool_ability`, not recalled.

| # | ability | class | cost | dmg | Break | cd | delay | what it does |
|---|---|---|---|---|---|---|---|---|
| 1 | **Rallying Shout** | warrior | 25 | 0 | 0 | 3 | 2.5 | *"Raise the line: every ally sheds 30 Pressure, and every other hero regains 30% of their resource."* Two clauses of different scope in one sentence — DL §1's worked example. No Perfect. |
| 2 | **Mana Shield** | mage | 15 | 0 | 0 | 3 | 1.0 | *"50% of damage taken converts into Mana for 3 turns. It is quick to cast."* A pure buff, capped at `BUFF_DELAY_CAP`. No Perfect. |
| 3 | **Arcane Surge** | mage | 15 | 0 | 0 | 3 | 3.0 | *"+20% attack on your next turn. An Arcanist also banks 2 Resonance."* Correctly outside `PURE_BUFFS` — the Resonance bank is a second, cast-time payload. No Perfect. |
| 4 | **Reality Fracture** | mage | 20 | 15 | 14 | 3 | 2.0 | *"Shove the target far down the initiative order."* Rides the `delay_push` **field** (6.0), read in the strike loop — fully implemented, no `special` needed. Perfect: *"An Arcanist also banks 1 Resonance"*. |
| 5 | **Dawnbreak** | cleric | 20 | 0 | 0 | 2 | 3.0 | *"Call the dawn: heal an ally 40. Whatever overflows their bar heals the caster instead."* Ally-targeted. Perfect: *"Heals 55"*. |
| 6 | **Sanctuary** | cleric | 30 | 0 | 0 | 4 | 3.5 | *"Ground made safe: every ally heals 12% of their max health."* Reaches a companion since DK §1. Perfect: *"Heals 18%"*. |
| 7 | **Divine Wrath** | cleric | 25 | 0 | 0 | 4 | 1.0 | *"The light answers: every hero deals +15% damage and acts 15% faster for 4 turns."* A pure buff, capped. No Perfect. |

**All seven resolve, all seven have live handlers, and none needs a line of new mechanics.**

### OPTION A — RESTORE THE AH-ERA DRAW

`run_state.gd`'s comment says *"re-opening the class draw is a one-line change if the designer wants
it back."* **That is true of the code and it is the smallest part of the price.**

- **THE CURATION DEBT IS 61 ENTRIES AGAINST TWELVE SPECS.** Measured: across the twelve specs,
  **56 of the 183 hero-and-entry pairs a reopened draw could offer duplicate something that hero can
  already reach**, and **27 of those are the hero's own protected core** — a card held on turn one.
  The Mystic would see **8 of 17** duplicated, the Sharpshooter 7 of 17; the Holy Cleric and
  Beastmaster only 2. A reopened draw needs those audited first, or a third of it offers cards back
  to heroes who have them.
- **IT REVERSES A STATED DESIGN RULING, NOT JUST A LINE.** AN §4's reason is written at the site:
  *"abilities are spec-locked now."* That is still how the draft reads today.
- **THE SLOT ARITHMETIC IS THE HARD PART.** `ABILITY_SLOT_CAP` is **7** with 3 protected cores (4 for
  Holy), so a hero has **3–4 earnable slots**. Today three zone bosses award **one pick each**, plus
  the elite drafts. AH's draw was 1 spec + 2 class, which would make it **nine boss picks per hero
  per run into 3–4 slots.** The cap was authored at BO precisely so a single pool could not walk past
  it.
- **AGAINST THE DRAFT AS IT STANDS AT 149:** the class channel would add a *third* acquisition
  channel over pools that are already complete, and **`bm_abilities` is one list** — a drafted card
  removes itself from the boss offer and vice versa, so a reopened class draw competes with the
  finished draft for the same slots rather than extending it.

### OPTION B — RETIRE THE CONTAINER, RE-HOME THE SEVEN

**What deletion actually costs, corrected from DV's record:** `pool_ability()` never reads
`CLASS_POOLS`, so **all seven still resolve with it gone.** What is lost is (a) the manifest — the
only place they are enumerated as a group — and (b) their place in the corpus: **227 → 220**, which
would move the printed population of roughly fifteen gates in one batch.

Where each of the seven would fit, and what it collides with:

| ability | best home | duplication |
|---|---|---|
| **Rallying Shout** | **Warden draft (9 → 10)** — the shallowest pool in the game | Partial. Its two clauses exist separately: Battered Not Broken (talent) also sheds banked Break; War Stomp and Rallying Cry also refuel. No single card does both. |
| **Mana Shield** | **Mage class draft (6 → 7)** — it is untied and general, which is exactly what class-wide cards are authored to be | **None found.** Nothing in the game converts damage taken into Mana. |
| **Arcane Surge** | Arcanist draft (10 → 11) | Overlaps **Overcharge** (arcanist boss pool) on the amp axis; its Resonance clause is the Arcanist's own engine, so it is spec-locked in effect. **Its 3.0 delay is three times the buff cap** — it is legitimately outside `PURE_BUFFS`, but it would want a pricing look before shipping. |
| **Reality Fracture** | Arcanist draft (10 → 11) | **None on the axis** — nothing else in the game shoves initiative through `delay_push`. Its damage/Break profile is ordinary. |
| **Dawnbreak** | **Holy boss pool (1 → 2)** | Overlaps **Divine Plea** (the sole occupant of that pool) on "heal an ally"; the overflow-to-caster clause is distinct. |
| **Sanctuary** | **Holy or Inquisitor boss pool** | Overlaps **Hymn of Hope**, Holy's protected core party-heal. The 12%-of-max shape differs from Hymn's. |
| **Divine Wrath** | Inquisitor draft (10 → 11) | Overlaps **Bring It Down** (DS's party-wide amp) and Blessing of Zeal. Divine Wrath is flat +15%/+15% at delay **1.0**; Bring It Down is priced at initiative **2.0** on PREPARATION's precedent for being party-wide. **That comparison is worth making before either moves.** |

**AND THIS OPTION ANSWERS AN OPEN QUESTION FOR FREE.** DV §2's sharpest finding is that **the Holy
Cleric's boss pool holds ONE card** against an award count of three. **Two of the seven are Cleric
heals.** Moving Dawnbreak and Sanctuary there takes it 1 → 3 and closes the structural shortfall
**without authoring anything**, using cards that already have handlers, text and a Perfect. It does
not need the fallback DV priced four candidates for.

**The cost of this option is that it moves the draft total** — which is now one edit in
`test_batch_cd` rather than twelve files, because of §1.

### OPTION C — RETIRE THEM DELIBERATELY, THE WAY A VAULTED ABILITY IS RETIRED

Keep the container, keep the definitions, and **say in writing that the seven are shelved** — the
model the brief names. Cost: **nothing moves**, and the corpus stays 227.

**What it buys:** the question stops being re-opened, and the next batch that widens a loop reads
*"this card is shelved"* before spending a measurement on it — which is precisely what DK, DL and DM
did not have.

**What it costs:** seven finished abilities stay unreachable indefinitely, and they stay inside every
population sweep, so the audit cost continues. **This is the only option that leaves the maintenance
bill in place**, and that bill is the measured part of this report.

### A FOURTH SHAPE THE BRIEF DID NOT NAME, RECORDED BECAUSE IT IS CHEAPER THAN THREE OF THEM

**Keep the vault and give it an exit that is not the class draw.** Four granting **runes** already
exist and resolve through `Classes.pending_talent_ability`; a rune is *bought with knowledge of the
run in front of you*, which is the distinction that makes a rune grant legitimate where a talent
grant is not. A rune that grants a vaulted card reaches the seven **without** reopening the 61-entry
channel, without reversing AN §4's spec-lock ruling, and without moving a single pool count.
**Reported, not recommended** — the rune content pass is itself unauthored, and which of these four
is right is the designer's call.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **Holy's empty boss awards.** Still the designer's, still in `state.md`'s queue. **§3 option B
  would close it as a side effect**, which is new information for that decision and is not a ruling
  on it.
- **No ability magnitude moved. No card was authored, re-homed or retired.**
- **No gate was added for §1's rule.** A gate asserting *"no equality against a growing collection"*
  would need a derived corpus of which collections grow, and nothing in the project derives that —
  the classification is a judgement (`SPEC_POOLS` grows, the changelog archive does not). Writing it
  as a name list would be the sixteen-exemption fingerprint DW rejected. **The rule is in
  `CLAUDE.md` and the tripwire is in `test_batch_cd`; a gate is owed only once somebody can state
  the population mechanically.**
- **`test_batch_at` §1 is still unseeded**, still banded, still open. One flake at a time.
- **The `check_di` / `check_dv` / `check_cz` tripwires were examined and left standing**, with the
  test they passed written down.

---

## §5 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html` (the stamp), `docs/changelog.html` and `docs/design-notes.md` all
landed **before** the run — 26 suites read `master.html`, 15 read the changelog and **3 read
`design-notes.md`**, which is the one people forget. `docs/state.md` and this report are written
after: no suite reads either, and `check_de` reads neither.

### THE PRE-BATTERY DEFENCES

- **THE PARSE CHECK WAS GREPPED FROM STDERR AFTER EVERY EDIT**, never from a tally and never from an
  exit code — and it was **shown to bite** before it was trusted: a deliberate
  `func _dx_negative_control(:` appended to `test_batch_cp.gd` produced one `Parse Error` line where
  the clean file produces zero. **The file was restored by `cp` and its md5 verified identical**,
  never by `git checkout`.
- **THE RETIRED-WORD SWEEP**, using `test_batch_bx` §4b's own `PARTY_IDENTS` strip over the edited
  `master.html`: **0 occurrences of *party* and 0 of *beast* (with `Beastmaster` removed), now and at
  HEAD.**
- **THE LITERAL SWEEP: 10,912 literals at a floor of 4**, from all 82 suites, gates and fixtures,
  evaluated against **all four** edited documents. **17 needles GAINED presence, 0 LOST**, and every
  one was cross-referenced against the **241** `not <x>.contains(L)` assertions in the tree. **One
  hit, and it is not the dangerous kind**: `test_batch_bw:680` `not vd_body.contains("func ")` reads
  a 1600-character slice of **`battle.gd` source**, not a document — and `battle.gd` is untouched.
- **THE COMMENT-STRIPPED DIFF AGAINST `HEAD`.** Every suite gained exactly as many code lines as it
  lost (the `==` → `>=` conversions and their messages); `check_dr` +6/−4 and `test_batch_cd` +4/−3,
  both because a one-line `ok()` became two. **`test_run_harness.gd` gained exactly FOUR code lines
  and lost none** — the helper, its `seed()`, and two call sites. **`scripts/classes.gd` is 1935 code
  lines before and after with +0/−0, and `scripts/battle.gd` 14,132 with +0/−0** — the proof that the
  negative controls left no trace and that no game code moved in this batch at all.

### THE NEGATIVE CONTROLS — §1 BOTH WAYS, §2 ONCE

| control | result |
|---|---|
| **Remove one card** (Anvil, Warden pool → 124 / 148) | **Every floor reds**: `check_dr` **2**, `test_batch_cd` **5**, `cp` **2**, `bt` **1**, `ce` **4** — each naming the live 124 / 148 and the direction. |
| **Add one card** (Rallying Shout, Warden pool → 126 / 150) | **All eleven floor files stay silent; `test_batch_cd` alone reds, with four messages** — the sharpest being `warden drafts 10 (want 9)`. The batch is told which pool moved and where to record it. |
| **A seed that misses a type** (`seed(101)`) | Gate 2 fails on *"the walk crossed a event"* — **DW's own red, reproduced on demand** — plus the ordinary-fight range at 6.0. |
| **The parse check** (`func _dx_negative_control(:`) | 1 `Parse Error` line against 0 clean. |

**THE SECOND ONE IS THE ONE WORTH HAVING.** It is what separates this repair from deleting the
checks: growth stops costing twelve red files, and the signal that a card arrived is *not gone* —
it moved to the one place the edit has to land anyway.

**AND ONE PROCEDURAL FAILURE, RECORDED BECAUSE IT COST TWO READINGS.** The first run of six suites
was taken **while the negative controls were mutating `scripts/classes.gd` underneath them** —
`bu`, `bv` and `bw` reported 1, 2 and 2 failures that were the race, not the tree. **Both runs were
discarded and re-taken on the frozen tree**, where all six read their baselines at zero. The tree
has to be frozen for a reading to mean anything; this is DL's lesson met again, in a new place.

### PREDICTED BASELINE MOVEMENT

Written into `baselines.json` **before** the run.

| row | predicted | why |
|---|---|---|
| `harness_2` | **`fails` [0,1] → [0,0]**, the `flake` field **removed**, note rewritten | seeded and settled at zero over 30 readings |
| **every other row** | **no movement whatsoever** | `==` → `>=` is one `ok()` either way; all thirteen touched targets were read at their exact baselines before the freeze — `check_dr` 79, `cd` 85, `cp` 697, `bo` 1106, `bp` 275, `bq` 742, `br` 1450, `bt` 407, `bu` 480, `bv` 900, `bw` 551, `cb` 1203, `ce` 1145, all at 0 failures |
| `check_de` (no row of its own) | **321, unchanged** | DX adds **no new target**, so the differ's four-assertions-per-target count does not move |
| `GATES` / manifest / row count | **26 / 78 / 77, all unchanged** | no gate added |

**This is a batch that should move exactly one number in the table, and that number is a failure
band falling to zero.**

