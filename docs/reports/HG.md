# BATCH HG — THE REMAINING STALE ASSERTIONS, DERIVED AND SORTED; PRICED AND NOT REPAIRED

**On `class-merge`, from `e532d1e` (HF). IMPLEMENT ONLY.** HA's census found forty-two targets asking the merged
game pre-merge questions. HD took the twenty holes and the thirty-five pool floors; HB and HC repaired four more in
passing. **What is left is SEVENTY arms in THIRTY-FOUR targets** — not HE's seventy-three and not HA's 110, both of
which are derived here rather than taken. **The three dispositions §1 asks for are 48 re-points, 5 retirements whose
subject is gone, and 17 retirements superseded by a newer check.** By the brief's own §2 — FZ's rule — that is
larger than HD's batch, so **nothing was repaired**: no gate, suite, fixture or baseline arm moved. **Eight controls
were run anyway**, because a supersession is a claim: each injected the defect a retired arm guards and read the
named check. **Three of the eight refuted the ruling this batch had written**, and the sort carries what the
controls measured instead. `main` is untouched, and the merge is reported (§4), not taken.

---

## NEEDS A RULING

1. **THE SPLIT, AND ITS ORDER.** The brief says *"all the re-points, then all the retirements"*. The measured halves
   are **48 arms in 25 targets** and **22 arms in 16 targets**, and the re-point half is by itself larger than HD.
   The proposal is **HH: the 22 retirements** (the smaller half, and the one whose controls are already run and
   recorded below), **then HI: the 48 re-points**, which inverts the brief's order for the reason FZ's rule exists.
   Taking the re-points first is the designer's to say.
2. **`test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec7).has(en),` IS KEPT WHERE ITS TWO SIBLINGS ARE RETIRED, AND THE CONTROL IS WHY.** Control c3 put two
   enablers on their own lineage shelves. `check_gs` §1:338 — the check this batch proposed to retire all three
   onto — caught **Bloodlust and not Quick Shot**, because the Sharpshooter's enabler IS the Hunter's class basic
   and `check_gs` §0:242 exempts it by name. So one of the three is kept and re-pointed over the class pool.
   Confirm, or rule the Sharpshooter's case not worth an arm.
3. **`check_gn.gd` `_s0_the_kit`: `ok(used == Classes.lineage_slots(spec) + Classes.kit_slots(ck, spec)` HAS TWO ANSWERS IN HA's OWN REPORT.** HA §1d marks it RETIRE; HA §1g calls it *"the door a
   future lineage card would have to pass through"*, which is a reason to keep it. It is sorted **A** here, on §1g.
   Confirm.
4. **THE SUPERSEDED SEVENTEEN ARE A SECOND COPY, AND RETIRING THEM NARROWS NOTHING — EXCEPT THAT THEY ARE THE
   SECOND COPY.** Each was proved by control to leave a live arm red on the same defect. Two of those live arms are
   in a DIFFERENT suite (`test_batch_bt.gd` `_names`: `"no ability name is used twice across the whole draft (%s)" % str(dupes))` covers `test_batch_bp.gd` `_pools`: `ok(Classes.class_draft_pool("warrior").find(n3) < 0,` and `test_batch_cp.gd` `_standard_shape`: `ok(not Classes.CLASS_DRAFT_POOLS[cls].has(nm),`), which is a
   cross-suite dependency rather than a local one. Accept that, or keep those two.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `e532d1e` = `origin/class-merge` before anything moved; the tree was clean |
| 2 | *"HA read all 119 targets … and found 130 passing while still asking about specs"* | **HELD** | HA §1a: 119 launched targets, 125 files read; §1d: 42 targets, 130 arms |
| 3 | *"HD repaired the twenty HOLES"* | **HELD** | HD's own figures: sixteen repaired, four retired |
| 4 | *"HE's `state.md` called them seventy-three; HA counted 110"* | **BOTH HELD, AND NEITHER IS THE NUMBER** | HA's 110 is every tier-2 arm INCLUDING the 35 FOLD arms HD folded; HE's 73 is 75 non-FOLD arms less `test_batch_bq`'s two. **Seventy survive** — HE's 73 less `check_dr.gd` `_s1_summoning`: `print("§1 — COMPANION SUMMONING is exclusive to the Hunter (the Beastmaster defines the calls; the …`, `test_batch_bo.gd` `_cap_and_slots`: `"engines": [{"engine": "overburn", "equipped": true}]}` (both HB) and `check_fk.gd` `_s5_requires_ability_resolves`: `ok(unreachable.is_empty(),` (HC). §1 |
| 5 | *"HD and HE have both moved code since"* | **HELD, AND HB, HC AND HF DID TOO** | 63 battery targets moved between HA's commit and HEAD; four gates are new |
| 6 | *"verify each entry is still where HA found it"* | **HELD, AND IT WAS NOT ENOUGH** | HA's line numbers are exact **at HA's own commit** — all 110 land on an assertion head there. Today **39 of the 110 have moved or gone**. And a line check alone would have been wrong: **`check_fk.gd` `_s5_requires_ability_resolves`: `ok(unreachable.is_empty(),`'s `ok(` line is byte-identical while HC re-pointed the four lines that feed it.** §1c |
| 7 | *"HF found HC's own census missed Long Poison"* | **HELD** | HF §6; the caution is answered by §1d's sweep of everything added since HA, which found nothing new |
| 8 | *"GK through HF built `check_gk` to `check_hf`"* | **ONE WORD SHORT** | there is no `check_gk`, `check_gl`, `check_gh`, `check_gi` or `check_hb`; the gates of that stretch are `check_gm`–`check_gx` and `check_hc`–`check_hf`. Seventeen, not twenty-two |
| 9 | *"several of these may be superseded"* | **HELD — SEVENTEEN OF THEM** | §2, and the eight controls that measured it |
| 10 | *"HA found the merge itself trivial, one conflict in `state.md`"* | **HELD, AND IT STILL HOLDS AFTER HB–HF** | §4: still exactly one conflict, still `docs/state.md`, and the merged tree is identical to `class-merge` in every other file |

---

## §1 — THE POPULATION, DERIVED

### §1a — The arithmetic, from HA's own list forward

| | arms | |
|---|---|---|
| HA's middle group | **130** | 42 targets |
| less tier 1 — **HD** | −20 | the holes |
| **= tier 2** | **110** | HA's figure, and the brief's |
| less the FOLD family — **HD §3** | −35 | every one verified GONE, replaced by `Fixture.class_pool_floors` |
| = non-FOLD tier 2 | **75** | |
| less `test_batch_bq.gd` `_break_damage`: `# struck and says why. The cards are still authored weaker; the rebalance GP`, `_break_damage`: `# free core attack.` (its file read from the text around it) — **HD §1b**, retired by ruling | −2 | |
| **= HE's figure** | **73** | as `docs/state.md` carries it |
| less `check_dr.gd` `_s1_summoning`: `print("§1 — COMPANION SUMMONING is exclusive to the Hunter (the Beastmaster defines the calls; the …` and `test_batch_bo.gd` `_cap_and_slots`: `"engines": [{"engine": "overburn", "equipped": true}]}` — **HB** | −2 | both re-pointed in place, with their reasons in the source |
| less `check_fk.gd` `_s5_requires_ability_resolves`: `ok(unreachable.is_empty(),` — **HC §1** | −1 | the reach set became the class's |
| **= WHAT IS LEFT** | **70** | **in 34 targets** |

### §1b — How it was derived, and the instrument that failed first

**Every one of HA's 110 tier-2 arms was mapped forward from HA's commit to HEAD**, by diffing HA's copy of each file
against the live one and carrying the arm's index through the unchanged runs. **71 arms are textually unchanged;
39 changed or are gone** — and the 39 are exactly the 35 FOLD arms plus four.

**THEN THE MAPPING WAS CHECKED AGAINST THE ONE THING IT COULD NOT SEE, AND IT HAD MISSED ONE.** An arm's `ok(` line
can be byte-identical while the repair lands in the lines above it. So the ENCLOSING FUNCTION of all 71 was diffed,
comments stripped: **29 sit in a function whose code moved.** Twenty-eight of those moves are HD's fold or HB's pet
work landing beside the arm; **one is a repair — `check_fk.gd` `_s5_requires_ability_resolves`: `ok(unreachable.is_empty(),`, re-pointed at HC §1 from the lineage's own shelf to
`Classes.draft_pool(cls)`, with the reason written into the source.** Counting by line alone would have reported 71.

### §1c — The four that were already done, named

| arm | done at | what happened |
|---|---|---|
| `check_dr.gd` `_s1_summoning`: `print("§1 — COMPANION SUMMONING is exclusive to the Hunter (the Beastmaster defines the calls; the …` | **HB** | the summons' owner became the Hunter class; the arm admits the kit's pet card and asserts its three calls |
| `test_batch_bo.gd` `_cap_and_slots`: `"engines": [{"engine": "overburn", "equipped": true}]}` | **HB** | `core_slots("beastmaster") == 1` became `== 0` — Pack Bond brings nothing |
| `test_batch_bq.gd` `_break_damage`: `# struck and says why. The cards are still authored weaker; the rebalance GP`, `_break_damage`: `# free core attack.` (its file read from the text around it) | **HD §1b** | the *"class-wide cards are weaker"* rule retired by ruling; both comparisons kept computed and printed, neither asserted |
| `check_fk.gd` `_s5_requires_ability_resolves`: `ok(unreachable.is_empty(),` | **HC §1** | the reach is the class's: kit + `draft_pool(cls)` + every lineage's boss pool and protected names |

### §1d — WHAT HA COULD NOT HAVE CENSUSED, SWEPT HERE

HF found HC's census had missed Long Poison, so the population HA never read was swept with HA's own instrument-1
vocabulary: **the four gates added since HA in full (`check_hc`, `check_hd`, `check_he`, `check_hf`), and every line
ADDED to the other 59 moved targets.** Eight assertion lines name pre-merge vocabulary; **all eight are live** — a
zone-boss pool (`spec_pool`, a lineage layer the merge kept), `core_slots` under HB's ruling, a name-absence sweep,
and Lethal Aim dismissing the pet. **No stale arm has been added since HA.**

---

## §2 — THE SORT, AND THE EIGHT CONTROLS THAT CORRECTED IT

**THE THREE COUNTS, WHICH §1 OF THE BRIEF ASKS FOR BEFORE ANY REPAIR:**

| disposition | arms | targets |
|---|---|---|
| **A — RE-POINT.** Asks about specs; the property survives under classes | **48** | 25 |
| **B — RETIRE.** Asks about something the merge deleted | **5** | 5 |
| **C — RETIRE.** Asked better elsewhere; retire naming the check | **17** | 13 |
| **total** | **70** | **34** |

### §2a — A SUPERSESSION IS A CLAIM, SO IT WAS DRIVEN

**The brief forbids repairing, not measuring.** Every C ruling says *retiring this loses nothing, because check Y
catches the same defect* — and that is a statement about the game's instruments which can simply be false. So for
each family: an isolated copy of the tree with its own `user://`, seeded from the player's backup and renamed in
`project.godot`; **the defect the retired arm guards, injected**; then the retired arm's own target AND the named
check, both run, **both read by their FAIL text rather than by a count**.

| ctl | the defect injected | the retired arms | did they red? | did the NAMED check red? |
|---|---|---|---|---|
| **c1** | War Stomp authored back into the Warden's lineage definitions | `test_batch_ah.gd` `_test_kits`: `ok(slots == want, "%s opens with %d spec abilities (got %d)" % [`, `test_batch_ah.gd` `_test_kits`: `ok(not Classes.spec_abilities(spec).any(func(a): return a.display_name == name),`, `test_batch_al.gd` `_kit_unchanged`: `ok(not kit.has("War Stomp") and not kit.has("Interpose"),` | **yes**, all three | **check_gs §1:306 red** — *"War Stomp (the warden's) has 0 homes"*. But `` `test_batch_al.gd` `_conditional_halves`: `ok(not Talents.owns_ability(_member({}), "War Stomp"),` `/` `check_gs.gd` `_s3_the_warrior_kit`: `ok(kit.count("Bloodlust") == int(c[3]),` (its file read from the text around it) `` stayed **green** |
| **c2** | eight lineage-shelf cards put into `CLASS_DRAFT_POOLS["warrior"]` | `test_batch_bp.gd` `_pools`: `ok(Classes.class_draft_pool("warrior").find(n3) < 0,`, `test_batch_bt.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),`, `test_batch_bu.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),`, `test_batch_bv.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),`, `test_batch_bw.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),`, `test_batch_cb.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),`, `test_batch_ce.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),`, `test_batch_cp.gd` `_standard_shape`: `ok(not Classes.CLASS_DRAFT_POOLS[cls].has(nm),` | **yes**, all eight | **`check_gs` read 0 failures.** Six suites' OWN arms red instead; `bp` and `cp` only through `test_batch_bt.gd` `_names`: `"no ability name is used twice across the whole draft (%s)" % str(dupes))` |
| **c3** | Bloodlust and Quick Shot made draftable off their own shelves | `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec7).has(en),`, `test_batch_bv.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec).has(enabler),`, `test_batch_bw.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec).has(en),` | **yes**, all three | **check_gs §1:338 red on Bloodlust and SILENT on Quick Shot** |
| **c4** | the Holy's authored `slots` moved 0 → 1 | `check_dv.gd` `_s2_boss_depth`: `ok(Classes.core_slots("holy") == 0,` | **yes** | **check_gs §0:254 red** — *"holy's authored slots (1) are not its enablers' bar entries (0)"* |
| **c5** | Stabilize put into the Mage class-wide shelf | `test_batch_ah.gd` `_test_pools`: `ok(not ab.special in ["stabilize", "overcharge", "wildfire", "bestial",` | **yes** | **`check_gp` read 0 failures** |
| **c6** | the Warden's shelf emptied | `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec2).is_empty(),`, `test_batch_cd.gd` `_pools`: `ok(pool.size() >= SPEC_FLOOR,` | **yes**, both | **`Fixture.class_pool_floors` red in both `bp` and `bo`** — *"the warrior pool holds 32 cards, below its floor of 43"* |
| **c7** | *(merged into c1 — the same injection)* | | | |
| **c8** | Flame Shield authored back into the Pyromancer's definitions | `test_batch_ar.gd` `_kit`: `ok(not by_name.has("Flame Shield"), "Flame Shield is not in the kit")` | **yes** | **`test_batch_ar.gd` `_pools`: `ok(Classes.pool_ability("Flame Shield") == null,` red** — *"resolves to NOTHING — the name is dead in every pool"* |

**No copy showed a `Parse Error`.** The clean arm was read first: `check_gs` on an unmodified copy of the same tree
reads **749 checks / 0 failures**, which is `baselines.json`'s figure for it.

### §2b — THREE OF THE EIGHT REFUTED THE RULING, AND THE SORT CARRIES WHAT WAS MEASURED

- **c5 — `test_batch_ah.gd` `_test_pools`: `ok(not ab.special in ["stabilize", "overcharge", "wildfire", "bestial",` IS NOT SUPERSEDED, AND IT MOVES C → A.** The ruling was that `check_gp` §2, which casts
  every `ENGINE_READ` row with and without its engine, asks it better. It does not: **`check_gp` read 0 failures**
  with Stabilize sitting in the Mage class-wide shelf, because the gate withholds the card at the OFFER door
  whichever shelf it sits on, so nothing it drives breaks. The live form of AH's curation rule is *a class-pool card
  that reads an engine carries an `ENGINE_READ` row*, and that is a re-point.
- **c3 — ONE OF THE THREE ENABLER ARMS IS KEPT, C → A.** `check_gs` §1:338 asks whether an enabler is in the class
  DRAFT pool, which is strictly wider than the three arms' *"not on its own shelf"* — except for the Sharpshooter,
  **whose enabler is the Hunter's class basic and which `check_gs` §0:242 exempts by name.** Retiring all three
  would have lost that case silently. `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec7).has(en),` is the widest of the three and is kept.
- **c1 — `test_batch_ah.gd` `_test_kits`: `ok(slots == want, "%s opens with %d spec abilities (got %d)" % [` MOVES B → A, and `test_batch_al.gd` `_kit_unchanged`: `ok(not kit.has("War Stomp") and not kit.has("Interpose"),`'s SUPERSEDER IS A DIFFERENT ARM.** `` `test_batch_al.gd` `_conditional_halves`: `ok(not Talents.owns_ability(_member({}), "War Stomp"),` `/` `test_batch_ah.gd` `_find_anywhere`: `for ab in Classes.spec_abilities(spec):` (its file read from the text around it) `` — HA's
  named duplicate — stayed **green**: they ask `Talents.owns_ability` of a fresh Warden, and under GS a lineage
  opens with its enablers alone, so a card added to its DEFINITIONS never reaches them. What red beside `test_batch_al.gd` `_kit_unchanged`: `ok(not kit.has("War Stomp") and not kit.has("Interpose"),`
  was **`test_batch_al.gd` `_kit_unchanged`: `ok(kit.size() == 3, "the Warden still DEFINES exactly 3 lineage abilities (has %d)" % kit.size())`**, *"the Warden still DEFINES exactly 3 lineage abilities (has 4)"* — the live question, and the
  real superseder. And because `test_batch_al.gd` `_kit_unchanged`: `ok(kit.size() == 3, "the Warden still DEFINES exactly 3 lineage abilities (has %d)" % kit.size())` asks it of the Warden alone, **`test_batch_ah.gd` `_test_kits`: `ok(slots == want, "%s opens with %d spec abilities (got %d)" % [`'s all-twelve definition count is the
  only arm that asks it of every lineage**: its subject is not gone, only the words *"opens with"* are.
- **c2 — THE NAMED SUPERSEDER WAS WRONG FOR ALL EIGHT.** `check_gs` §1:320 counts homes for the THIRTY RETURNING
  cards; the eight arms guard authored draft cards, which are not in that population. `check_gs` read **0**. The
  real superseders are each suite's own cross-pool arm — *"appears in exactly ONE pool"* in `bu`, `bv`, `bw`;
  *"is not in a spec pool as well"* in `cb`; *"is not also a spec draft card"* in `ce` — and, for `bp` and `cp`
  which have none of their own, **`test_batch_bt.gd` `_names`: `"no ability name is used twice across the whole draft (%s)" % str(dupes))`, the whole-draft uniqueness sweep over every shelf and every
  class pool.** The disposition stands; the reason recorded is the measured one.

### §2c — THE SHAPE GZ FOUND, RE-CHECKED

HA named two documents keeping a pin green on a pre-merge fact. **`CLAUDE.md`'s one-in-four class seam is gone** —
HD repaired `test_batch_br.gd` `_docs`: `# passing WITHOUT ITS SUBJECT BEING ENUMERATED AT ALL — the same fault BE`, which was a tier-1 arm, and the sentence no longer appears in the file.
**`docs/master.html`'s *"All twelve specs draft from at least ten"* is still there, pinned at `test_batch_cb.gd` `_docs`: `ok(master.contains("All twelve specs draft from at least ten"),`,
and it is left as HA left it**: the sentence is arithmetically TRUE today (the thinnest shelf is the Warden's
eleven) while describing a relation the merge dissolved — a hero draws his class's one pool, not his lineage's
shelf. **The sentence and its pin move together, in the batch that re-points the pin.** Correcting the document
alone would red the pin; that is the shape, and this batch does not open it.

---

## §3 — THE PRICE, AND WHY THIS BATCH STOPS AT IT

**FZ's rule, applied to a measured population rather than an estimated one.**

| | HD (a full batch) | HG's remainder |
|---|---|---|
| arms | **56** (20 holes + 36 folded) | **70** |
| targets | 23 | **34** |
| controls | 26 | **≥ 40** (§3 owes a two-armed control per re-pointed assertion) |
| rows moved | 24 moved, 1 added | up to one per repaired target |
| new gates | 1 | 0 |

**Every count is larger, and the control count is larger than proportionally**, because §3 asks for a control per
re-pointed ASSERTION and not per target, and because each control is an isolated tree with its own seeded
`user://`. HD needed a full battery for the smaller number. **That is the condition FZ's rule names, so the count,
the sort and the method are reported and nothing is repaired.**

**THE METHOD, WRITTEN TO BE TRANSCRIBED.** The tables below carry, for every one of the seventy: the target, **the
line it is on TODAY**, the line HA gave, what it asks, and either the door to re-point it at or the check that
supersedes it. **A repair batch should not re-derive the population** — only re-verify each line before editing it,
**and diff the lines that FEED the arm, not the arm's own line**, which is the one thing HA's list could not carry
and the mistake that would have counted `check_fk` as outstanding.

**AND THE SEVENTEEN SUPERSEDED ARE THE CHEAP HALF BECAUSE THEIR CONTROLS ARE ALREADY RUN.** §2a's eight controls
are the *"record what it used to guard and why that no longer exists"* half of §3, done. What a retirement batch
still owes is the inverted arm and its comment, and a re-run.

## §3a — THE SEVENTY, BY DISPOSITION

### A — RE-POINT — 48 arms in 25 targets

| arm (line TODAY) | HA | what it asks | the door it should ask |
|---|---|---|---|
| `check_do.gd` `_s4_status_sweep`: `ok(gated.is_empty(),` | 475 | precision_ranks read-site pin keeps a reason about the Swordmaster's guaranteed statuses (dorma | the guaranteed-status table re-keyed by class (with `check_dp.gd` `_s1_property`: `ok(fresh.is_empty(),`) |
| `check_dp.gd` `_s1_property`: `ok(nodes > 0,` | 191 | the per-lineage tree sweep read more than 0 nodes | the positive arm; the sweep walks SPEC_IDS, re-point to the one tree per class |
| `check_dp.gd` `_s1_property`: `ok(fresh.is_empty(),` | 200 | no node reads a status outside a per-spec guaranteed-status table built on cores and passives | LARGER: needs check_do's per-spec guaranteed-status table re-keyed by class |
| `check_dr.gd` `_s2_revival`: `ok(found == REVIVE_SPEC,` | 168 | resurrection 'belongs to the Holy Cleric' via spec_abilities ownership | resurrection's owner: defined once, reachable by every Cleric of the class pool |
| `check_dv.gd` `_s2_boss_depth`: `ok(emptiable.size() == 8,` | 251 | emptiable boss pools counted against the lineage's own shelf | emptiable boss pools, counted against the class pool, not the lineage shelf |
| `check_dv.gd` `_s2_boss_depth`: `ok(holy_safe == 2,` | 260 | Holy's un-draftable boss cards checked against the Holy shelf only | Holy's un-draftable boss cards, against the class pool |
| `check_ea.gd` `_s1_depth`: `ok(floor_now >= 1,` | 316 | award-always-pays floor per lineage shelf, not per class pool x engines held | LARGER: one re-derivation over class x engines held, shared by the four |
| `check_ea.gd` `_s1_depth`: `ok(floor_all >= awards,` | 331 | full-three floor over the pre-GP two-tier chain | LARGER: same re-derivation |
| `check_ea.gd` `_s1_depth`: `ok(short_specs.is_empty(),` | 346 | no lineage's shelf floor below 3 | LARGER: same re-derivation |
| `check_ea.gd` `_s1_depth`: `ok(lost_after == 0,` | 394 | lost awards from the per-spec two-tier floor | LARGER: same re-derivation |
| `check_ea.gd` `_s1_depth`: `ok(emptiable == 8,` | 399 | emptiable boss pools counted against the lineage's own shelf | emptiable against the class pool |
| `check_eh.gd` `_arm`: `ok(int((q[0] as Array).size()) == mini(3, left),` | 156 | arm C: the lineage's reach is gone and EH's third tier must pay - the tier GP deleted | arm C reaches the tier GP deleted; re-point onto the two live tiers |
| `check_eh.gd` `_s2_depth_fully_held`: `ok(t2.size() == 3,` | 213 | all 12 lineages: boss pool + lineage shelf held still leaves the class tier paying 3 | the class tier, asked per class x engines held rather than per lineage |
| `check_es.gd` `_s4_tags_are_read`: `ok(card != "", "§4: no tagged card in the %s draft pool to swap" % spec3)` | 640 | a swap card taken from the Berserker's shelf as 'one a player could actually make' | a swap card taken off the class pool, which is what a player draws |
| `check_gn.gd` `_s0_the_kit`: `ok(used == Classes.lineage_slots(spec) + Classes.kit_slots(ck, spec)` | 197 | ability_slots_used == lineage_slots + kit_slots with no engine held | FLAGGED: HA's action says RETIRE, HA §1g says the door is worth keeping |
| `test_batch_ah.gd` `_test_kits`: `ok(slots == want, "%s opens with %d spec abilities (got %d)" % [` | 62 | each lineage's spec_abilities holds 3 bar entries - 'opens with' | c1: only `test_batch_al.gd` `_kit_unchanged`: `ok(kit.size() == 3, "the Warden still DEFINES exactly 3 lineage abilities (has %d)" % kit.size())` re-states it, and only for the Warden; the all-twelve definition count survives the merge |
| `test_batch_ah.gd` `_test_pools`: `ok(ab.faith_cost == 0,` | 130 | no class-wide card costs a spec-exclusive secondary resource | the curation rule, over the class pool |
| `test_batch_ah.gd` `_test_pools`: `ok(ab.special != "summon" and ab.special != "call_wild"` | 133 | no class-wide card is a 'Beastmaster signature' | ditto, and the summons are every Hunter's kit card since HB |
| `test_batch_ah.gd` `_test_pools`: `ok(name != "Hex of Ruin", "Hex of Ruin stays Occultist-only")` | 136 | Hex of Ruin 'stays Occultist-only' | Hex of Ruin, over the class pool |
| `test_batch_ah.gd` `_test_pools`: `ok(not ab.special in ["stabilize", "overcharge", "wildfire", "bestial",` | 138 | no class-wide card is 'gated on a spec passive' - replaced by ENGINE_READ / SITS_OUT | c5: check_gp read 0 failures on the injection — NOT superseded; re-point onto the ENGINE_READ row the gate uses now |
| `test_batch_ah.gd` `_test_offers`: `ok(not run.award_ability_pick(nospec),` | 285 | the award refuses a member 'with no spec' | the award's refusal: seat the spine-taker who DOES bank |
| `test_batch_ah.gd` `_test_offers`: `ok(int(nospec.get("bm_picks_owed", 0)) == 0, "...and owes no pick")` | 287 | the fallback refuses a member 'with no spec' | ditto |
| `test_batch_ah_battle.gd` `_test_action_bar`: `ok(earned.size() == 8, "the Warrior draft pools can supply 8 new abilities")` | 207 | action-bar fillers from class-wide + Berserker shelf, 'new' = not in spec_abilities | fillers off draft_pool('warrior'), the one pool a Warrior draws |
| `test_batch_aj.gd` `_ability_nodes`: `ok(base_hs != null, "Hack and Slash is in the Berserker kit")` | 409 | Hack and Slash 'is in the Berserker kit' via spec_abilities | Hack and Slash: the definition table's wording, not 'the kit' |
| `test_batch_aj.gd` `_upgrade_paths`: `ok(Classes.spec_draft_pool("berserker").has("Battle Shout"),` | 552 | Battle Shout 'drafts from the Berserker' as reachability | Battle Shout reachable off the class pool |
| `test_batch_aj.gd` `_upgrade_paths`: `ok(Classes.spec_draft_pool("berserker").has("Rampage"),` | 584 | Rampage 'drafts from the Berserker' as reachability | Rampage, same |
| `test_batch_an.gd` `_test_rewards`: `ok(not class_only.is_empty(), "the Warrior siblings hold spec-foreign entries")` | 824 | sibling-spec set built from boss pools AND draft shelves (positive arm) | the spec-foreign set under one pool a class |
| `test_batch_an.gd` `_test_rewards`: `ok(not class_only.has(n), "%s never arrives from a sibling spec" % n)` | 829 | no zone-boss offer returns a sibling-spec entry, over the same mixed set | the zone-boss offer against that set |
| `test_batch_at.gd` `_kit`: `ok(not names.has("Stabilize"),` | 603 | 'STABILIZE IS OUT of the opening three' = spec_abilities | 'out of the opening three' asked of the live opening |
| `test_batch_at.gd` `_kit`: `ok(not Classes.class_draft_pool("mage").has("Stabilize"),` | 628 | Stabilize 'spec-only: it reads Resonance' via the class-wide shelf | Stabilize's gate is ENGINE_READ now, not absence from a shelf |
| `test_batch_au.gd` `_live_fallback_generic`: `ok(Classes.spec_draft_pool(String(probe["spec"])).has(name),` | 657 | Firestorm / Rime 'drafts from the <spec> instead' | Firestorm / Rime reachable off the class pool |
| `test_batch_au.gd` `_live_capstones`: `ok(Classes.spec_draft_pool("arcanist").has("Magi's Wrath"),` | 777 | Magi's Wrath 'drafts from the Arcanist instead' | Magi's Wrath, same |
| `test_batch_au.gd` `_live_debug_grant`: `ok(not names.has(entry2),` | 946 | the debug grant holds no sibling-spec entry, siblings' shelves counted as theirs | the debug grant vs sibling entries, under one pool |
| `test_batch_av.gd` `_kit_and_pool`: `ok(not Classes.class_draft_pool("cleric").has("Resurrection")` | 303 | Resurrection / Intercession not on the Cleric class-wide shelf 'never offered to a sibling with | the two Mercy spenders, against the class pool |
| `test_batch_aw.gd` `_authored_fallbacks`: `ok(Classes.spec_draft_pool("inquisitor").has("Sacred Resolve"),` | 466 | Sacred Resolve 'drafts from the Devout' | Sacred Resolve off the class pool |
| `test_batch_aw.gd` `_authored_fallbacks`: `ok(Classes.spec_draft_pool("inquisitor").has("Bulwark of Fortitude"),` | 468 | Bulwark of Fortitude 'drafts from the Devout' | Bulwark of Fortitude, same |
| `test_batch_ay.gd` `_magnitudes`: `ok(bool(kc["found"]) and int(kc["cost"]) == int(kc["base_cost"]) - 10` | 403 | retired payload edits Kill Command 'which every Beastmaster owns' | 'which every Beastmaster owns': the pet card is every Hunter's since HB |
| `test_batch_ay.gd` `_magnitudes`: `ok(bool(hi["found"]) and int(hi["cost"]) == int(hi["base_cost"]) - 10,` | 410 | retired payload edits Hunter's Instinct 'which every Beastmaster owns' | ditto |
| `test_batch_bb.gd` `_ashes_pools`: `ok(kit.display_name != "Ashes of Al'ar",` | 760 | no Mage lineage's spec_abilities holds Ashes of Al'ar - 'does not START with it' | 'does not START with it' asked of the live opening |
| `test_batch_bo.gd` `_pools`: `ok(Classes.SPEC_DRAFT_POOLS.has(w),` | 223 | the Warrior shelf is NAMED - 'one of four heroes had no draft' | the three Warrior shelves NAMED: an authoring location, said so |
| `test_batch_bo.gd` `_cores`: `ok(CAP - slots >= 3,` | 394 | CAP - core_slots(spec) >= 3 free slots | CAP - slots >= 3, re-worded off enabler_slots |
| `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec7).has(en),` | 232 | a lineage's enablers are absent from its OWN shelf only | c3: `check_gs.gd` `_s1_nothing_lost`: `ok(not Classes.draft_pool(cls).has(n5), "§1: the enabler %s is in the %s draft pool" % [n5, cls])` caught Bloodlust and NOT Quick Shot (the Sharpshooter's enabler is the Hunter's basic); this is the widest of the three and is KEPT, re-pointed over the class pool |
| `test_batch_br.gd` `_pools`: `ok(Classes.class_draft_pool(Classes.class_of_spec(spec)).has("Rally"),` | 313 | each Warrior lineage can draw Rally, via the class-wide shelf | Rally: every Warrior draws it off the class pool |
| `test_batch_br.gd` `_pools`: `ok(Classes.class_draft_pool(Classes.class_of_spec(spec2)).has("Field Dressing"),` | 318 | each Hunter lineage can draw Field Dressing, via the class-wide shelf | Field Dressing, same |
| `test_batch_bx.gd` `_own_pools`: `ok(warden_cards.size() >= 8, "§2: the Warden has at least eight spec cards to be offered")` | 251 | the Warden shelf >= 8 'spec cards to be offered' | the Warden's shelf as a real, named part of the one Warrior pool |
| `test_batch_cb.gd` `_docs`: `ok(master.contains("All twelve specs draft from at least ten"),` | 1246 | pins master.html's 'All twelve specs draft from at least ten' (a doc edit rides with it) | GZ's SHAPE: master.html's sentence and its pin move together |
| `test_batch_cd.gd` `_pools`: `ok(thinnest >= 10,` | 422 | the thinnest shelf >= 10 as 'the one a card is owed to next' | the thinnest pool as the one a card is owed to next |
| `test_run_harness.gd` `_gate_talent_conservation`: `_check("the un-awakened one did not",` | 407 | a hero with his spec blanked banks nothing - the spine-taker who does bank is never seated | the un-awakened hero: seat the spine-taker who banks |

### B — RETIRE, THE SUBJECT IS GONE — 5 arms in 5 targets

| arm (line TODAY) | HA | what it asks | what removed its subject |
|---|---|---|---|
| `check_eh.gd` `_s3_the_record`: `ok(disagree == 12,` | 251 | core_slots != protected_names size - the ladder no longer reads core_slots | the ladder that read core_slots is gone; the disagreement's reason with it |
| `test_batch_au.gd` `_arcanist_authored`: `ok(bad.is_empty() and dealt.size() == 27,` | 364 | each of 12 per-lineage trees deals 27 cells and none grants | twelve per-lineage trees: FX left one tree |
| `test_batch_az.gd` `_rune_audit`: `ok(lane == "" or lanes.has(lane),` | 627 | each Sharpshooter rune's lane is one of his deleted tree's lanes | the lanes of the Sharpshooter tree FX deleted |
| `test_batch_bo.gd` `_pools`: `ok(not sib_hit,` | 343 | no card on one lineage's shelf is in a sibling's boss pool | the shelf-vs-sibling-boss collision; live half -> a corpus name sweep |
| `test_batch_br.gd` `_draft_flow`: `ok(saw_spec, "§4: ...beside real spec cards")` | 677 | a Warden's offer holds a Warden-shelf card - the per-card seam roll GP deleted | the per-card seam roll GP deleted |

### C — RETIRE, SUPERSEDED — 17 arms in 13 targets

| arm (line TODAY) | HA | what it asks | the check that supersedes it, and the control that proved it |
|---|---|---|---|
| `check_dv.gd` `_s2_boss_depth`: `ok(Classes.core_slots("holy") == 0,` | 270 | core_slots('holy') == 0 | check_gs §0:254 (core_slots == enabler_slots) — CONFIRMED by c4 |
| `test_batch_ah.gd` `_test_kits`: `ok(not Classes.spec_abilities(spec).any(func(a): return a.display_name == name),` | 80 | the five AH trims absent from spec_abilities - 'left the kit' | check_gs §1:306 (homes == 1) — CONFIRMED by c1 |
| `test_batch_al.gd` `_kit_unchanged`: `ok(not kit.has("War Stomp") and not kit.has("Interpose"),` | 692 | War Stomp / Interpose not in spec_abilities('warden') as 'not opening kit' (duplicate of 519/52 | `test_batch_al.gd` `_kit_unchanged`: `ok(kit.size() == 3, "the Warden still DEFINES exactly 3 lineage abilities (has %d)" % kit.size())` ('the Warden still DEFINES exactly 3') — c1 refuted `test_batch_al.gd` `_conditional_halves`: `ok(not Talents.owns_ability(_member({}), "War Stomp"),` (its file read from the text around it)/`test_batch_al.gd` `_conditional_halves`: `ok(not Talents.owns_ability(_member({}), "Interpose"),` (its file read from the text around it), which stayed green |
| `test_batch_ar.gd` `_kit`: `ok(not by_name.has("Flame Shield"), "Flame Shield is not in the kit")` | 614 | Flame Shield 'not in the kit' = spec_abilities (covered by 676) | `test_batch_ar.gd` `_pools`: `ok(Classes.pool_ability("Flame Shield") == null,` ('resolves to NOTHING') — CONFIRMED by c8 |
| `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec2).is_empty(),` | 139 | each of the 12 shelves non-empty - 'EVERY spec has a draft now' | HD §3's Fixture.class_pool_floors — CONFIRMED by c6 |
| `test_batch_bp.gd` `_pools`: `ok(Classes.class_draft_pool("warrior").find(n3) < 0,` | 212 | a tranche card is not in the class-wide draft | `test_batch_bt.gd` `_names`: `"no ability name is used twice across the whole draft (%s)" % str(dupes))`, the whole-draft uniqueness sweep — c2 refuted `check_gs.gd` `_s1_nothing_lost`: `ok(ab3 != null and ab3.display_name == String(n3), "§1: %s does not resolve through the pool …`, which stayed green |
| `test_batch_bt.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),` | 255 | a tranche card is not on a class-wide shelf ('leaking into a class pool') | `test_batch_bt.gd` `_names`: `"no ability name is used twice across the whole draft (%s)" % str(dupes))`, its own whole-draft uniqueness sweep — CONFIRMED by c2 |
| `test_batch_bu.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),` | 255 | a tranche card is not on a class-wide shelf | `test_batch_bu.gd` `_names`: `ok(int(seen.get(n, 0)) == 1,` ('appears in exactly ONE pool') — CONFIRMED by c2 |
| `test_batch_bv.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),` | 276 | a NINE card is not on a class-wide shelf | `test_batch_bv.gd` `_names`: `ok(int(seen.get(n, 0)) == 1,` ('appears in exactly ONE pool') — CONFIRMED by c2 |
| `test_batch_bv.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec).has(enabler),` | 300 | a Hunter lineage's enablers are absent from its OWN shelf only | check_gs §1:338 — CONFIRMED by c3 (the Quick Shot case is kept at `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec7).has(en),`) |
| `test_batch_bw.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),` | 289 | a tranche card is not on a class-wide shelf | `test_batch_bw.gd` `_names`: `ok(int(seen.get(n, 0)) == 1,` ('appears in exactly ONE pool') — CONFIRMED by c2 |
| `test_batch_bw.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec).has(en),` | 310 | a lineage's enablers are absent from its OWN shelf only | check_gs §1:338 — CONFIRMED by c3 (the Quick Shot case is kept at `test_batch_bp.gd` `_pools`: `ok(not Classes.spec_draft_pool(spec7).has(en),`) |
| `test_batch_bw.gd` `_names`: `ok(not NINE.has(ab.display_name),` | 455 | no NINE card in any spec_abilities 'kit does not already hold' | check_gs §1 (`check_gs.gd` `_s1_nothing_lost`: `ok(homes == 1, "§1: %s (the %s's) has %d homes among enabler, kit, shelf and the pet's calls — one" …` (its file read from the text around it)) |
| `test_batch_cb.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),` | 227 | a tranche card is not on a class-wide shelf | test_batch_cb's own cross-pool arm ('is not in a spec pool as well') — CONFIRMED by c2 |
| `test_batch_cd.gd` `_pools`: `ok(pool.size() >= SPEC_FLOOR,` | 400 | every shelf >= SPEC_FLOOR 8 | HD §3's Fixture.class_pool_floors — CONFIRMED by c6 |
| `test_batch_ce.gd` `_pools`: `ok(not Classes.class_draft_pool(cls).has(n),` | 267 | a tranche card is not on a class-wide shelf | test_batch_ce's own cross-pool arm ('is not also a spec draft card') — CONFIRMED by c2 |
| `test_batch_cp.gd` `_standard_shape`: `ok(not Classes.CLASS_DRAFT_POOLS[cls].has(nm),` | 229 | a CP card is absent from every class-wide shelf | `test_batch_bt.gd` `_names`: `"no ability name is used twice across the whole draft (%s)" % str(dupes))`, the whole-draft uniqueness sweep — c2 found no arm of cp's own |

---

## §4 — WHAT STANDS BETWEEN `class-merge` AND `main`. REPORTED; NOTHING MERGED

**Measured with plumbing that writes to neither branch** (`git merge-tree --write-tree`, `git diff`,
`git rev-list`). **HA's finding still holds after HB, HC, HD, HE and HF.**

| | HA (at `ac5072c`) | **HG (at `e532d1e`)** |
|---|---|---|
| merge base | FS, `3b80fbe` | **FS, `3b80fbe`** — unchanged |
| commits on `class-merge` only | 33 | **39** |
| commits on `main` only | 2 | **2** — GG's and GI's documentation lines, still the only ones |
| files differing | 179, +61,679 / −15,347 | **189, +74,113 / −16,645** |
| **conflicts a merge raises** | **one: `docs/state.md`** | **one: `docs/state.md`** — unchanged |
| the merged tree against `class-merge` | identical but for `docs/state.md` | **identical but for `docs/state.md`** |

**FQ's convention covers the one conflict as written** — *"take the branch's wholesale"* — and **`main` still loses
nothing of its own**: its two commits touch `docs/state.md` and nothing else, and every defect they record (the
quit skip, the end boss with no button, the zone boss that could field the Hollow Crown) is FIXED on the branch and
recorded there as closed. The hard rows FQ ruled for — `baselines.json`, `run_battery.sh`, `CLAUDE.md`,
`docs/master.html`, `docs/changelog.html`, `docs/design-notes.md` — **raise no conflict at all**, because `main` has
not been edited since FS.

**WHAT STANDS BETWEEN THE BRANCH AND `main` IS THEREFORE NOT THE MERGE.** It is the seventy arms above, and the
lineage layers GK's charter rules away and nothing has built. HA's sharpest case — *a hero who takes a spine or a
rule engine at class selection can be offered no ordinary rune at all* — **is no longer true of every class**: HC
took the runes off their specs and HF authored fifteen that read no engine, so a hero holding none is now offered
five at spawn in every class (`docs/state.md`'s table). **The narrowness HA named is closed; the middle group is
not.**

### §4a — WHAT IS LEFT ON THE BRANCH THAT IS NOT MERGE WORK

**These are the queue, not the blockers**, and every one was re-read in `docs/state.md` rather than quoted from the
brief:

- **The Crown's Break and freeze resistance** — owed, `docs/state.md`.
- **Sanctity's status-potency layer** — the largest unbuilt system the recon found.
- **The engine cards' texts** — GQ's rulings 1 and 2.
- **The class-wide rebalance** — EB §1's, and **sharper since HD §1b retired the rule that made those cards weaker
  while leaving them authored weaker**: the rebalance is owed and the rule that justified it is gone.
- **The sim bot's blind spot on the 29 returned cards** — `_bot_drafted_pick` casts a card only inside a rotation
  it recognises, so most of GS's twenty-nine are never cast in a sim.
- **And HF's five open rulings stay open**, untouched here: Burning Ground's burn, Aper's numbers, Abundance's
  ceiling, Mark of the Hunt's text, and Kill Command's silence on Aper.

---

## §5 — WHAT IS DELIBERATELY NOT DONE

- **No rune, engine, card, kit, pool or node changed.** Nothing under `scripts/` or `data/` was opened.
- **No gate, suite, fixture or `run_battery.sh` arm moved.** The eight controls ran in isolated copies outside the
  repository; the repository tree carries no instrument change.
- **No merge to `main`**, and `main` is untouched.
- **HF's five open rulings stay open.**
- **`docs/master.html` is not edited**, so `test_batch_cb.gd` `_docs`: `ok(master.contains("All twelve specs draft from at least ten"),`'s pinned sentence and the sentence itself stay
  together for the batch that re-points the pin (§2c). The stamp this batch owes is `docs/state.md`'s
  *Last rewritten* line (FU §0), and that is what moved.

---

## §6 — THE VERIFICATION

*(Written before the run, per §6.)*

**THE PREDICTION, WRITTEN FIRST (DF's rule).** No `.gd`, `.sh`, `.json` or `data/` file moved this batch, so
**no `baselines.json` row is predicted to move and none was edited.** The battery should read exactly what HF's
acceptance run read: **125 of 125 launched, `check_de` 517 checks / 0 failures / 0 notices**, no `Parse Error` and
no `SCRIPT ERROR`, and **the two sanctioned reds at their recorded counts** — `check_cm_live` 13 / 4 and
`check_gj` 70 / 1. **Any other movement is a document this batch wrote reaching an instrument**, and would be
named here rather than absorbed.

**THE ACCEPTANCE RUN, IN THE REPOSITORY, AGAINST THE FROZEN TREE. THE PREDICTION HELD EXACTLY.**

| | predicted | read |
|---|---|---|
| targets launched | 125 | **125 of 125** |
| `check_de` | 517 / 0 / 0 | **517 checks / 0 failures / 0 notices** |
| `Parse Error` | none | **none in any of the 125 logs** |
| `SCRIPT ERROR` | none | **none in any of the 125 logs** |
| `check_cm_live` | 13 / 4, sanctioned | **13 / 4** |
| `check_gj` | 70 / 1, sanctioned | **70 / 1** |
| `baselines.json` rows moved | none | **none** |

**THE PARSE FLOOR WAS READ OFF STDERR AND NOT OFF A TALLY**, per `docs/instrument-rules.md`: every one of the 125
logs was grepped for `Parse Error` and for `SCRIPT ERROR` individually, and `check_parse` names its four-file
residue as it always does (`check_ck_width`, `check_cu`, `check_cv`, `check_dn` — the audit instruments the battery
launches from nothing).

**THE TWO SANCTIONED REDS WERE READ BY THEIR FAIL TEXT, NOT BY THEIR COUNT.** `check_cm_live`'s four are CQ §1's
one fact — *"the bar appeared on the enemy's attack"*, *"the bar's top line names the incoming blow (was: )"*, and
the two brace positions — and `check_gj`'s one is **`§4: the card says +167 gold and the purse moved 187`**, which
is the figure HF left to the digit. **That figure is itself evidence this batch moved no rune, card or pool**: it
is a live measurement of the victory card against the purse, and it did not budge.

**THE TREE WAS FROZEN BY MD5 BEFORE AND AFTER, ON ABSOLUTE PATHS: 615 files, AND NOT ONE MOVED.** Every document
this batch writes was written BEFORE the run, so unlike a batch that writes its report afterwards there is nothing
to reconcile. **A battery that changes nothing it reads is the reading this batch is entitled to**, and it is
stronger than HF's, whose freeze showed two files moving while its run was going.

### §6a — THE TWO POST-RUN EDITS, AND THE PROOF THEY DID NOT MOVE WHAT READ THEM

**Two lines could not be written before the run, because they state what the run read**: `docs/state.md`'s battery
line and this §6. **Of everything in the tree, `docs/state.md` is read by exactly one instrument** — `check_es`
§4's `CENSUS_DOCS_SWEPT`, whose census windows this batch preserved verbatim — **and `docs/reports/` is read by no
`FileAccess` call at all.** Both were re-run against the FINAL documents after these two edits landed, beside the
other four document instruments, and each reads what the battery read below

| instrument | what it reads | in the battery | re-run against the FINAL documents |
|---|---|---|---|
| `check_es` | `docs/state.md` (§4's census sweep), `CLAUDE.md`, `docs/master.html` | 57 / 0 | **57 / 0** |
| `check_ec` | the document pins' territory | 24 / 0 | **24 / 0** |
| `check_ed` | the `.gd` pins | 18 / 0 | **18 / 0** |
| `check_fg` | `CLAUDE.md` against its stated ceiling; the changelog's headings | 22 / 0 | **22 / 0** |
| `check_fr` | `docs/ways-of-working.md` and the conflict table | 25 / 0 | **25 / 0** |
| `check_dv` | `docs/changelog.html`, both halves of the cut | 84 / 0 | **84 / 0** |

**Every one reads exactly what it read inside the battery**, with no `Parse Error` and no FAIL line, so the two
post-run lines moved nothing that reads them. `CLAUDE.md` ends at **381,747 B = 372.80 KiB, 37.20 KiB under its
410 KiB ceiling** (+2,896 B), which `check_fg` §2 measures out of the rule's own sentence rather than from a
number written here..

**THE PLAYER'S FILES.** Backed up to `../save-backups/HG-20260922-212509` before anything ran, and verified by
md5 at the time of the copy — `profile.json ed4144e1…`, `relics.json fdc12ffa…`, `run_save.bin 25582edd…`,
`settings.cfg 0c1b39c3…`. Re-read after everything ran (§6b).

**THE CONTROL COPIES' USER-DATA FOLDERS.** Eight isolated copies left folders under Godot's `app_userdata`, each
named **"Dawn of Decay HG …"**: the clean-arm reading (**"probe"**) and the seven injections (**"c1"**, **"c2"**,
**"c3"**, **"c4"**, **"c5"**, **"c6"**, **"c8"**; c7 was merged into c1 and never built). Each was renamed in
`project.godot` before anything ran in it and seeded from the backup, so no control could reach the player's saves.
**They can be deleted.**
