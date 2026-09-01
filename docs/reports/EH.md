# BATCH EH — THE THIRD TIER, AND A SWEEP FOR PRECEDENT THAT WAS NEVER TRUE

**The zone-boss award is a chain of three pools now: the hero's SPEC BOSS pool, then his SPEC DRAFT
pool, then his CLASS-WIDE DRAFT pool.** Batch EA built the second tier and chose it *because that
pool could not itself empty*; Batch EG broke both halves of that arithmetic one batch later. **No
ability magnitude moved, no card was authored, no pool gained or lost an entry, and EA's second
tier is byte-unchanged.**

**§2 swept `master.html` for claims of fact the code had stopped honouring: sixteen sites across
twelve claims, plus two source comments.** The brief's own account of the defect it named did not
survive the sweep, and that is reported first because a brief is the shared record.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*Derive, do not recall.* **Four of the brief's claims move when checked against the repo, and one
of them is the premise §2 was written on.**

| the brief said | re-derived here | why |
|---|---|---|
| the false rune-ladder precedent misled two briefs eleven batches apart **through `master.html`** | **`master.html` has never carried that claim** | it says "three flat slots" (§11), "no runes and three empty slots" (§2 and §8) and "three rune slots" (§3) — all four mentions are correct and one of them says *flat*. The false ladder lived in the BRIEFS; the correction has been in `CLAUDE.md` since EG |
| **the class-wide pool is the one that cannot empty** — six cards a class, shared across three specs, and no hero can hold another spec's picks | **the second half is true and the first does not follow from it** | no SIBLING drains it — every hero filters it against his own `owned_ability_names` — but the hero himself can: `draft_card_is_class` returns TRUE unconditionally once the spec side is dry |
| **all seven enablers are protected** | **all SIXTEEN are** | `PROTECTED_CORES` names sixteen across nine specs; EG audited the seven its brief listed. All sixteen are protected, so the conclusion held and only the sweep did not |
| **the ladder alone takes the Occultist's boss pool to 2** | the Occultist's **fallback** floor is 2; his **boss** pool is 3 and did not move | the ladder moves the drain on the spec DRAFT pool, which is what EG measured and `check_ea` §1 printed |

**AND ONE THE BRIEF GOT EXACTLY RIGHT, WHICH IS WORTH SAYING BECAUSE IT IS THE INSTRUCTION THAT
FOUND THE WHOLE OF §2.** *"Verify that claim rather than assuming it, since EA's spec-pool floor was
true when written and stopped being true one batch later."* It stopped being true again, one tier
down, and only because the brief said to check.

---

## §1 — THE ZONE-BOSS AWARD GETS A CLASS-WIDE THIRD TIER

### WHAT WAS BUILT

`Run.roll_class_fallback_offer(member)` — thirteen lines beside the tier it follows, reading
`Classes.class_draft_pool(Classes.class_of_spec(spec))` filtered by `owned_ability_names`, shuffled,
sliced to three. `award_ability_pick` reads it only when both pools above come back empty.
`run_sim.gd`'s mirror of the chain gained the same third step, for the reason its EA comment already
gives: a bot that stopped at two tiers would under-measure exactly the population the third tier was
built for.

**Two pools above it are byte-unchanged.** `roll_spec_ability_offer` and `roll_spec_fallback_offer`
are untouched; `check_ea` §0 asserts the second tier still draws from `spec_draft_pool` and does
**not** read the class pool, so the two cannot silently merge.

**It is not the thing DY §3 forbade, and that is asserted rather than argued.** That rule bars
re-creating the deleted 61-entry `CLASS_POOLS`; its own next sentence says a re-opened class draw
reads `CLASS_DRAFT_POOLS`, which is live, curated, and what this reads. `check_ea` §0 asserts the
award contains neither `class_pool(` nor `CLASS_POOLS`, out of the comment-stripped source.

**EA's principle is restated where the change is recorded, in three places** — the source header,
`CLAUDE.md`'s standing rule and `master.html` §6a: *a zone-boss award must always pay something
real, and the baseline it replaced was silence.* The announcement requirement carries to the third
tier and is driven live.

### THE DEPTH ACROSS ALL THREE TIERS, UNDER A FULLY-HELD LOADOUT

Derived every run by `check_ea` §1. `earn` is `cap − core_slots(spec)` at the ladder's top rung;
`rune` is the ability-granting-rune drain, derived off `runes.json` against each pool separately.

| spec | boss | draft | class | earn | rune s+c | tier-2 floor | **tier-2+3 floor** |
|---|---|---|---|---|---|---|---|
| Berserker | 3 | 10 | 6 | 7 | 0+0 | 3 | **9** |
| Warden | 4 | 10 | 6 | 7 | 0+0 | 3 | **9** |
| Swordmaster | 4 | 12 | 6 | 7 | 0+0 | 5 | **11** |
| Pyromancer | 3 | 13 | 7 | 7 | 0+0 | 6 | **13** |
| Cryomancer | 3 | 11 | 7 | 7 | 0+0 | 4 | **11** |
| Arcanist | 4 | 12 | 7 | 7 | 0+0 | 5 | **12** |
| Holy | 3 | 10 | 6 | 6 | 0+0 | 4 | **10** |
| Devout | 2 | 11 | 6 | 7 | 1+0 | 3 | **9** |
| Occultist | 3 | 10 | 6 | 7 | 1+0 | **2** | **8** |
| Beastmaster | 5 | 10 | 6 | 7 | 0+0 | 3 | **9** |
| Sharpshooter | 5 | 10 | 6 | 7 | 0+0 | 3 | **9** |
| Survivalist | 5 | 10 | 6 | 7 | 0+0 | 3 | **9** |

**The floor ran 2–6 and runs 8–13, against an award that asks for three.** The two draft pools are
**disjoint on all twelve** — no class-wide card appears in any spec draft pool or any boss pool — so
the chain's floor is the two pools summed against ONE `earn` budget, because a hero cannot spend the
same seven slots twice.

**No rune grants a class-wide card**, on all twelve. That is derived rather than assumed: it is the
one term that can push the third tier below its arithmetic, and `check_ea` §1's rune walk now reads
both pools instead of one.

### CAN ANY HERO STILL BE PAID NOTHING? YES — AND THE ANSWER IS TWO ANSWERS

**Under a fully-held LOADOUT: no.** All twelve are offered a full three off the class-wide tier.
`check_eh` §2 drives this through the live rollers rather than off the table above — a member
holding his entire boss pool and his entire spec draft pool, asked of the three real functions.

**Under a fully-held POOL: yes, every hero can.** EG §2 made a benched card stay in the pool and
`owned_ability_names` reads the pool, so what drains the filter is every card a hero has ever taken
rather than every card he carries — and the slot cap does not bound that at all. A hero who also
owns his whole class-wide pool is paid nothing, and `check_eh` §2 asserts that state reaches zero on
all twelve, because a gate that only proved the happy direction would be measuring its own setup.

**WHAT HOLDS THE FLOOR UP IS ARITHMETIC, NOT STRUCTURE, AND THAT IS THE POINT OF THE WHOLE
SECTION.** Emptying the chain means OWNING every card in both draft pools — **15 at the cheapest
spec (Occultist), 20 at the Pyromancer** — and a draft offer pays at most one card. A bound on the
number of events in a run is not a property of a container, and it does not quietly become false
when somebody widens a pool. **EA's reason for its tier was structural, and structural claims about
a design are hostage to every other batch.**

### `check_ea` §1 KEPT EG'S SPLIT AND GAINED A THIRD QUESTION

The brief said to keep it split and add the third tier as its own question rather than widening
either half. Both halves EG split are untouched to the character:

- `floor_now >= 1` per spec — **the RULE** (*an award always pays*), twelve checks, unchanged.
- `short_specs == ["occultist"]` — **the stricter claim** (*every award offers a full three*) as a
  named set, unchanged.
- `floor_all >= awards` per spec — **NEW.** The stricter claim restored, across the chain rather
  than inside either half. It is a third assertion because the first two still ask what the SPEC
  tier alone can do, and that is the question the record needs the day somebody re-prices a spec
  draft pool.

**62 → 86 checks.** +24, every one predicted before the battery.

### AND `check_ea` §0'S WINDOW WAS A DEFECT THIS BATCH TRIPPED TWICE IN ONE EDIT

EA read the award's body as `rs.substr(aw, 1400)` off the **raw** file. This batch broke it two ways
at once:

1. **The third tier landed at offset 2113**, a thousand characters past the end of the window. A
   premise added there would have been asserted against text the window could not reach.
2. **The comment explaining it NAMES `CLASS_POOLS`** — so §0's third premise, which exists to catch
   the deleted class-boss draw coming back, would have read prose *about* a deletion as the deletion
   being undone.

**The window is the whole function now** — bounded on the next `func`, taken from
`Gate.strip_comments` — and the needle is broadened to both forms of the deleted container, which
the raw window could not safely ask for. Both are repairs the record already predicted: *a comment
outgrows a scan window*, and *a comment naming a banned string trips the gate*.

---

## §2 — THE `master.html` SWEEP

### REPORTED BEFORE REPAIRING

**Population, layered, because the brief's warning about low estimates is the only reliable thing
about a sweep's size.** 3,040 lines. **697 lines carry a uniqueness marker**; of those, **66 are
claims of the corpus-wide form** (*the only X in the game*, *no other*, *nothing else*). The
mechanism-claim layer is not marker-shaped at all and turned out to be the larger half.

**SIXTEEN SITES. Twelve distinct claims.**

| # | line(s) | the claim | verdict | what the code says |
|---|---|---|---|---|
| 1 | 84 | *"zone bosses 1 and 2 hand every hero an ability pick"* | **FALSE** | BM §6: three zone bosses pay, "INCLUDING THE THIRD, which used to be the end boss" |
| 2 | 123 | *"Zone 3's boss is the end boss: the run ends on its death"* | **FALSE** | the end boss is slot 17, its own node after zone 3's boss — contradicted by lines 104, 106 and 114 of the same section |
| 3 | 1081 | *"opens a run with its core attack plus exactly 3 spec abilities"* | **FALSE for 2 of 12** | `spec_abilities` is 4 for Holy and 5 for the Beastmaster; the document says so itself 60 and 200 lines below |
| 4 | 1082 | *"earns 2 more over the run — one from zone 1's boss and one from zone 2's"* | **FALSE** | three |
| 5 | 1083–84 | *"There is no cap and no swap step, so a full run ends at core + 3 + 2 = 6 abilities"* | **FALSE** | BO §2 added the cap and BO §3 the swap step; EG made the cap a ladder 7 → 10 |
| 6 | 1085–86 | the award is *"drawn from its SPEC pool only"* | **STALE** | three tiers |
| 7 | 1152 | *"THE ZONE-BOSS DRAW READS THE SPEC POOL ALONE, AND THERE IS NO SECOND POOL BESIDE IT ANY MORE"* | **STALE** | two more pools beside it |
| 8 | 1175–77 | *"the fallback pool cannot itself run out ... which floors the fallback at six cards"* | **FALSE** | false since EG; the floor was 2–6 before this batch |
| 9 | 1194–95 | *"a kit has room for only seven abilities, so past that point every new one replaces an old one"* | **FALSE** | ten by the end, and it benches rather than replaces — contradicted by lines 1249–62 of the **same section** |
| 10 | 1207–08 | *"Zone bosses — The existing §6a pick, unchanged: same timing, same SPEC pool"* | **STALE** | the chain |
| 11 | 1280, 1638 | *"Guard Change is the only stance swap in the game"* (×2) | **FALSE** | BP: Precision Strike and Feint both switch. It is his only **unconditional** one |
| 12 | 1552 | *"nothing else a Warrior does improves anyone else's numbers"* | **FALSE** | Battle Shout: *"More damage dealt, to every hero"* |
| 13 | 1037, 1811 | *"the only thing that removes Resonance"* (×2) | **FALSE** | Arcane Bolt halves it after the blow (`ARCANE_BOLT_KEEP` = 0.5) |
| 14 | 2354–56 | the two-tier fallback, and no mention of the slot the zone boss now grants | **STALE** | three tiers |
| 15 | 2358 | *"Abilities: two picks per run, from zone 1's and zone 2's bosses"* | **FALSE** | three |

**THE LARGEST GROUP IS NOT A SUPERLATIVE AT ALL.** Nine of the sixteen are in §6a, which still
described the game *before Batch BO*. **§6b, fifty lines below, was current the whole time** — EG
swept the section it was writing in and not the one above it, which is now a rule in `CLAUDE.md`.

### AND TWO SOURCE COMMENTS, FOUND BY THE SAME SWEEP

- **`classes.gd:4444`** carried a **third** copy of the stance-swap claim, one screen above the
  `PROTECTED_CORES` `why` that BP corrected. BP fixed one of three.
- **`unit.gd:691`**: *"Both ends are uncapped and nothing removes stacks."* The "uncapped" half is
  true; **two earned cards remove Resonance** — Stabilize floors the meter at 2, Arcane Bolt halves
  it. Corrected, with both named.

Both edits are proved comment-only by a comment-stripped diff against `HEAD`: **0 differing lines
in each.**

### WHAT THE SWEEP DID *NOT* SETTLE, STATED SO IT IS NOT READ AS CLEAN

- **Line 1511 — Fault Line is *"the only Break lever the Hunter class has anywhere"*.** **21
  Hunter-reachable abilities carry Break damage**, Shrapnel Charge at 25 and Powershot at 20. But
  "lever" may mean *amplifies Break* rather than *deals Break*, and the code cannot settle which.
  **Reported, not repaired** — and it is the sharpest single argument in §4 below.
- **The card catalogue's spec-scoped superlatives** (*"the only card in his kit that…"*, ~30 of the
  66) were read but not individually re-derived against every pool. They are design statements about
  a pool rather than about a mechanism, which is the line the brief drew.
- **Verified TRUE and left alone**, so the population is not read as all-defect: the Warden is the
  only Block-stat character and the Swordmaster the only parry-stat one (one `block_chance` and one
  `parry_chance` in `HERO_STATS`); Resonance is the only uncapped resource; nothing but a
  Cryomancer's own release thaws a hold (the Cleansing Rite is explicitly carved out at
  `_cleansable_debuffs`); the defensive check is the Warden always and the Swordmaster in Defensive
  or Formless and no other spec; Exhortation is the Cleric's only offensive **group** buff (Blessing
  of Zeal is single-target); the draft stands at 154 = 129 + 25.

### REPAIRED TOWARD THE CODE, AND PROVED NOT TO HAVE MOVED AN ASSERTION

Every site corrected toward the code, per the standing rule. **A literal-needle sweep over all
11,181 string literals in the 85 gates and suites, run against `HEAD`'s copy of each tracked
document and the repaired copy:**

| document | present before | after | LOST | GAINED |
|---|---|---|---|---|
| `docs/master.html` | 1115 | 1118 | **0** | 3 |
| `CLAUDE.md` | 823 | 827 | **0** | 4 |
| `docs/changelog.html` | 824 | 829 | **0** | 5 |
| `docs/design-notes.md` | 900 | 900 | **0** | 0 |
| `docs/instrument-rules.md` | 318 | 318 | **0** | 0 |
| `docs/state.md` | 570 | 571 | 13 | 14 |

**Zero LOST across every asserted document.** Each GAINED needle was traced to its assertion site
and none reads a document (`"drain"` is asserted against an ability description, `"spec-draft"` is a
dictionary key in `check_dn`). `docs/state.md`'s 13 losses are safe because **nothing in the tree
asserts against that file** — verified by grep rather than recalled.

**AND THE EXTRACTOR ITSELF HAD A HOLE, WHICH IS WORTH RECORDING BECAUSE IT WAS FOUND BY DOUBTING
IT.** The first pass decoded literals with Python's `unicode_escape`, which mangles the 2,795
needles carrying non-ASCII — every one of them would have read absent in both snapshots and any flip
inside them would have been invisible. Re-run with a hand-written unescaper that leaves UTF-8 alone,
the *present* count moved 1111 → 1114. **An extractor is a population, and this one was three
literals short.**

---

## §2b — CAN THIS BE AN INSTRUMENT? MEASURED, RULED ON NOWHERE

`check_eh` §4 reports and asserts nothing about the document: **56 uniqueness claims survive in the
repaired file; 12 of them name a live ability the code can be asked about.**

**THE RATIO IS AN UPPER BOUND ON A GATE'S SIGNAL, NOT ITS YIELD.** Line 1511 is the argument: *"the
only Break lever the Hunter class has anywhere"* **names a live ability and is not checkable** — the
code knows what deals Break, and it does not know what a *lever* is. A gate over this population
would have to be right about the difference, and EB declined to gate the header sweep at 118 rows
for 16 defects on exactly that arithmetic.

**WHAT IS MECHANICALLY CHECKABLE IS A NARROWER THING THAN THE BRIEF'S CATEGORY, AND IT ALREADY HAS
INSTRUMENTS.** `test_batch_ah` derives §6a's pool tables from the constants; `check_do` derives the
draft total; `test_batch_cd` renders its needles from the constants rather than authoring them. Every
one of those checks a claim that is a **rendered value**, not a claim that is a **sentence**. Nine of
this batch's sixteen sites were sentences.

**AND A TWO-ARMED CONTROL SETTLES WHY THE DEFECT SURVIVES, WHICH IS MORE USEFUL THAN A PROPOSAL:**

- **ARM 1** — the false stance-swap sentence put back into `master.html`: `check_dk` 64/0,
  `check_do` 131/0, `check_dm` 93/0, `check_ec` 23/0, `test_batch_ah` 5584/0. **All five green.**
- **ARM 2** — the same harness, armed on a literal a suite demonstrably reads (`test_batch_ah`
  asserts every spec pool verbatim; the Devout's row broken from `", "` to `" and "`):
  **`test_batch_ah` 5584 checks / 1 failure.**

The first arm was run once *incorrectly* and is reported that way: the injection appended to the
needle instead of breaking it, so `doc.contains(needle)` was still true and the control read green
for the wrong reason. **A control needs a real needle**, and the re-armed version is the one above.

**Ruled on nothing.** The finding is that `master.html`'s factual prose is asserted by nothing, and
that is why *"the only stance swap in the game"* outlived its own correction by nineteen batches.

---

## §3 — THE THREE THINGS EG LEFT ON THE RECORD

### (1) THE LADDER READS `core_slots`, AND NOTHING ELSE READS THE OTHER

Confirmed, live, on all twelve: `core_slots` and `protected_names().size()` disagree everywhere —
3 against 4 for ten specs, 4 against 5 for Holy, 3 against 6 for the Beastmaster.

- **The CAP** (`ability_slots_used`) reads `Classes.core_slots(spec)` and does not mention
  `protected_names`.
- **The LADDER** (`ability_slot_cap`) reads neither — it is indexed by `zone_bosses_cleared` alone.
- **`protected_names` has exactly one live reader outside its own definition**: `map_screen.gd`, the
  loadout panel's CORE rows — the list that cannot be benched, which is what a NAME count is for.
  Asserted as the derived reader set `["classes.gd", "map_screen.gd"]`, so a second reader trips it.

### (2) ALL SEVEN ENABLERS ARE PROTECTED — AND THERE ARE SIXTEEN

**This is the finding of §3.** EG's record reads *"all seven named enablers are in
`protected_names` for their spec"*, and every word of it is true. It audited the seven the brief
listed: Quick Shot, Consecrated Ground, Heal, the three summons, Guard Change.

**`PROTECTED_CORES` names SIXTEEN, across NINE specs.** The nine outside the brief's list —
Fireball, Detonation, Frostbolt, Ice Lance, Arcane Explosion, Hymn of Hope, Divine Shield,
Shadowrend, Hex of Ruin — were outside the audit.

| spec | enablers |
|---|---|
| Swordmaster | Guard Change |
| Pyromancer | Fireball, Detonation |
| Cryomancer | Frostbolt, Ice Lance |
| Arcanist | Arcane Explosion |
| Holy | Heal, Hymn of Hope |
| Devout | Divine Shield, Consecrated Ground |
| Occultist | Shadowrend, Hex of Ruin |
| Beastmaster | Summon Ursus, Summon Canis, Summon Aguila |
| Sharpshooter | Quick Shot |

**All sixteen are in `protected_names` for their spec. No live brick.** The conclusion held; the
sweep did not. `CLAUDE.md`'s own rule names the shape — *a named list cannot audit itself* — and
this is its fourth recorded instance. **It is the hardest kind to catch, because nothing goes red.**

**AND THE TWO WRONG REASONS ARE CORRECTED WHERE EG RECORDED THEM AND PINNED WHERE THEY CAN GO RED.**
EG corrected both in its report; `check_eh` §3 asserts them as facts, because a reason living only
in prose is the next brief's false precedent:

- **Heal is one of FIVE Mercy outlets**, four of them protected. `_consume_empower` accepts
  `holy_heal`, `renewal`, `hymn`, `resurrection` and `divine_plea` — asserted as a count of 5.
- **Every single-target attack the Sharpshooter makes generates Focus.** `_sharpshooter_focus`
  gates on the resource name and `not _focus_safe(ab)`, never on a card — asserted as the
  **absence** of "Quick Shot" from that function, so the brief's wrong reason cannot become the
  code. What Quick Shot uniquely is: his only free, every-turn generator and the only one paying the
  sequence bonus, which is what `PROTECTED_CORES`'s `why` already said.

### (3) `decline_draft` IS THE LEDGER'S ONLY WRITER

Confirmed two ways. Statically: `_refuse_draft(` occurs exactly twice in the comment-stripped
source — one definition, one call, inside `decline_draft`. **Driven live**: a card taken and then
benched on a real member leaves `draft_refused` empty, stays in `bm_abilities`, and stays inside
`owned_ability_names` — so a benched card is kept off every offer by **ownership**, not by refusal.

---

## §4 — VERIFICATION

### THE LIVE DRIVE, IN THREE ARMS

`check_eh` §1 resolves a real zone boss through `battle._resolve_boss` on a party of
Swordmaster / Cryomancer / Devout / Survivalist, three times:

| arm | held | must be paid from | observed (hero 0) |
|---|---|---|---|
| A | nothing | spec BOSS pool | Execute, Lunge, Sweeping Strikes |
| B | boss pool | spec DRAFT pool | Formless, Feint, Battle Poise |
| C | boss + spec draft | **CLASS-WIDE pool** | Cleave, Rally, Warcry |

Every arm asserts **its own premise per hero before it is driven**, reads the **announcement off the
end card's own Label**, and reads the **queued offer back** — because an announcement cannot tell
three tiers apart, and a chain that reached the class pool first would pay a weaker card on every
award while satisfying any arm that only asked *did something arrive*.

**ONE ASSERTION WAS WRITTEN WRONG AND REPAIRED TO INTENT.** The offer size was asserted as a flat
three and went red on the **Devout**, whose boss pool is two cards, so arm A fills short by AP §3's
shipped rule. It is `mini(3, left)` now — derived from what the tier actually held. Asserting three
would have made the one spec this whole thread exists for the one spec the gate could not measure.

**AND `check_ea` §2B WENT RED AND WAS REPAIRED, NOT LOOSENED.** EA wrote arm B as *"empty BOTH
pools"* because both was all there were; the third tier then paid a real card into an arm built to
prove silence, and the arm failed for the right reason. The question is unchanged — *is the
announcement conditional on an award being made* — and answering it now costs one more pool. It is
written against the CHAIN rather than two named rollers, so a fourth tier would fail here loudly
instead of quietly turning arm B vacuous.

### NEGATIVE CONTROLS — FOUR, EACH ARMED ON SOMETHING A GATE DEMONSTRABLY READS

| control | disarmed state | result |
|---|---|---|
| 1. chain order inverted (class tier before spec draft) | `check_ea` 86/0, `check_eh` 175/0 | **`check_ea` 86/1** (`§0: the class-wide tier is read BEFORE the spec draft tier`) and **`check_eh` 175/4** (every hero paid out of the wrong pool in arm B) |
| 2. third tier deleted from the chain | as above | **`check_ea` 86/2**, and **`check_eh` §1C goes SILENT** — "the victory card does not announce the award" on all four heroes |
| 3. third tier filters on `draft_refused` | as above | **`check_ea` 86/1** (`a fallback tier now filters on the no-return ledger`) |
| 4. the `master.html` sweep, two arms | see §2b | ARM 1 (false claim restored) **all five readers green**; ARM 2 (a read needle broken) **`test_batch_ah` 5584/1** |

**Control 2 is the decisive one and is why the gate drives a battle**: deleting the tier makes the
victory card go quiet, which is the exact defect EA existed to end, and no static assertion in the
project would have noticed.

### PREDICTIONS, FROM WHAT EACH TARGET READS

| target | reads | predicted |
|---|---|---|
| `check_ea` | the award's body, the three rollers, both draft pools | **62 → 86** (+24, enumerated in `baselines.json`) |
| `check_eh` | new | **175**, off three identical standalone readings |
| `check_da` | the two draft-pool marks per file | **unchanged** — `check_ea` and `check_eh` both gained the second mark and both were exempted **before** the battery |
| `check_ed` | the pin manifest | **unchanged at 18**; manifest regenerated, 1329 → 1335 pins |
| `test_batch_ah` | `master.html` §6a pool tables, the stamp | **unchanged** — the tables are untouched and the stamp is bumped to EH |
| everything else reading a document | `contains` whose count is fixed | **unchanged** — 0 LOST needles across every asserted document |

Nothing else was predicted to move: no ability magnitude, no pool entry, no card, no constant a
suite counts.

### THE BATTERY, AND THE ONE PREDICTION THAT WAS WRONG

**RUN 1 — 84 targets. Two reds: `check_cm_live` 4/4 (the recorded intentional red, identical on
unmodified HEAD) and `check_da` 42/2.** `check_ea` read **86/0** and `check_eh` **175/0**, both on
their predicted lines.

**`check_da` §3b ACCUSED `check_eh::_arm` OF RETURNING A HAND-ROLLED CORPUS, AND `_arm` IS
`-> void`.** The cause is in `Gate.returning_bodies`: it tested `-> void` against the **first line**
of a signature, so a void function whose signature is **wrapped** entered §3b's population as if it
returned something.

**IT IS A POPULATION, NOT A ONE-FILE SLIP. Six functions across three files were in that state,
five of them since before this batch** — `check_dm::_clause_in_walk`, `::_no_op_chip`,
`::_cast_narrow`, `test_runes::_payloads`, `::_power_arm`, and `check_eh::_arm`. They passed only
because none of the other five touches two walk families. **A fingerprint's population being wrong
in the direction that does not fail is the hardest kind to notice**, and it took a new void function
that happened to read three pools to surface it.

**AN EXEMPTION WAS NOT AVAILABLE, WHICH IS WHY THE HELPER WAS REPAIRED INSTEAD.** `check_dw` §0
pins `RETURN_WALK_EXEMPT.size() == 1` and names its single member, so adding a second entry would
have turned `check_dw` red — the exemption table is a claim DW made deliberately. `returning_bodies`
accumulates the signature to the line that closes it now, capped at eight lines so a malformed head
cannot walk into the body.

**PROVED BY A TWO-ARMED CONTROL, AND THE FIRST ATTEMPT AT IT WAS WRONG:**

| arm | injection | result |
|---|---|---|
| **(void, repaired helper)** | a wrapped-signature `-> void` reading two walk families | **348 returning bodies, correctly SKIPPED, 0 accused** |
| **(void, HEAD's helper)** | the same injection | **355 bodies, WRONGLY ACCUSED** — `check_cy.gd::_eh_control_void` named |

The first attempt armed a **returning** function with a wrapped signature; both arms caught it,
because HEAD's first-line test finds no `-> void` there either. It proved nothing. **A control has
to be armed in the direction the repair actually changes**, which is a void function wrongly
INCLUDED, not a returning one correctly caught.

**`check_da` 39 → 41**, and the +2 is the two `WALK_EXEMPT` rows (asserted live, one check each).
The rule and both fingerprints are unchanged; `RETURN_WALK_EXEMPT` is untouched at one.

**RUN 2 — 84 targets, tree frozen (0 of 191 files drifted, md5 before and after, absolute paths).
The only failure is `check_cm_live` 4/4. `check_de`: 345 checks / 0 failures / 0 NOTICES** — every
count on its recorded line, certifying on pass one.

### AND ONE THING THE SWEEP FOUND ABOUT THE FLOOR ITSELF — REPORTED, NOT FIXED

**`check_parse.gd` WALKS `res://scripts` AND `res://scenes` ONLY.** When `gate_fixture.gd` was
briefly broken during the repair above — a duplicate `var k` in the same scope — the brief's own
floor procedure, *grep stderr for `Parse Error`*, came back **clean**. The repo ROOT is outside that
gate's territory, and the root holds `gate_fixture.gd` (preloaded by 23 gates), `suite_fixture.gd`,
all 39 gates and all 47 suites.

It surfaces downstream — every dependent gate fails to load and prints no count — but late, and a
gate that fails to load is exactly the shape `check_de` was built to catch rather than the shape a
parse gate should let through. **Widening it is a baseline move in a batch that has not been briefed
for it, so it is reported here and carried in `docs/state.md`'s open queue.**
