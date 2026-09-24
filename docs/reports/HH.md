# BATCH HH — TWENTY-ONE CHECKS RETIRED, AND ONE THAT COULD NOT BE

**On `class-merge`, from `35752c2` (HG). IMPLEMENT ONLY.** HG sorted seventy stale arms into 48 re-points, 5
retirements whose subject is gone and 17 retirements superseded by a newer check, and proposed taking the twenty-two
retirements first. **The designer ruled that order. Twenty-one are retired and one is not**: HG never drove the
seventeenth supersession, and driven — before anything was retired, as the brief requires — its arm read green every
time, because **it has never asserted anything**. It fires zero times. A check that guards nothing is not
superseded; by the brief's own rule it stays, and it goes to HI with the re-points. **HI's population is therefore
forty-nine, derived arm by arm** (§4). No card, rune, engine, kit, pool or node moved; nothing was re-pointed;
`main` is untouched.

---

## NEEDS A RULING

1. **`test_batch_cd`'s class-wide shelf floor is the same stale shape, and no census has it.** `cd` §2 asserts every
   class-wide shelf holds at least `CLASS_FLOOR` (three) — the shape HD §3 FOLDED out of eleven other suites into
   the class floors. It was never on HA's list, so HD did not fold it and HG did not sort it; HH found it retiring
   the per-shelf floor beside it. **Give it to HI as a fiftieth arm, or leave it.** (The two per-shelf and per-class
   depth EQUALITIES in the same function are the authoritative tables by standing rule and are not in question.)
2. **One name resolving to two definitions may be asked by nothing corpus-wide.** HG wrote that the live half of
   `test_batch_bo:297`'s question belongs to "a corpus name sweep". HH looked and did not find an instrument that
   asks, of every card, that a display name resolves to one definition across the resolvers (`pool_ability`,
   `spec_pool_ability`'s Sharpshooter and Survivalist tables): the per-tranche name sweeps ask it of their own nine
   each, and `test_batch_al` asks only that every boss-pool entry resolves. `bo:297` never asked it (it asked which
   pools a name sat in), so retiring it lost nothing — but the question may be unasked. A check, or a ruling that it
   is not needed.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `35752c2` = `origin/class-merge` before anything moved; the tree clean but for the untracked `save-backups/` |
| 2 | *"HG derived the population at seventy arms in thirty-four targets — neither figure on record"* | **HELD** | HG §1a: seventy in thirty-four, against HE's seventy-three and HA's 110 |
| 3 | *"sorted them 48 re-point / 5 retire-deleted / 17 superseded"* | **HELD AS HG's SORT; ONE OF THE SEVENTEEN DOES NOT SURVIVE DRIVING** | 48 / 5 / 17 in HG §2. `test_batch_bw:417` is vacuous (§2a): 48 / 5 / 16, and one kept |
| 4 | *"their controls are already run"* | **FOR SIXTEEN OF THE TWENTY-TWO** | HG's seven injections covered sixteen supersessions; the seventeenth (`bw:417`) was never driven, and none of the five subject-gone arms had a control. HH ran all of them (§6) |
| 5 | *"HG found `check_fk:368`'s `ok(` line byte-identical … while HC had repaired it two batches ago"* | **HELD IN SUBSTANCE** | HG §1b. HC came two batches after HA and four before HG |
| 6 | *"a line-number check would have counted 71"* | **HELD** | HG §1b |
| 7 | *"HG drove all eight it could"* | **SEVEN INJECTIONS, AND ONE IT COULD HAVE** | HG's c1–c6 and c8 (c7 merged into c1), beside one clean arm — HG's own count of eight. `bw:417` was drivable: HH drove it three ways (§2a) |
| 8 | *"THREE REFUTED ITS OWN RULING"* | **HELD — AND HH's DRIVE IS A FOURTH** | c5, c3 and c2 (for c2, one named superseder read zero for eight arms). HG's seven injections refuted three rulings; the one supersession it left undriven, driven here, refutes a fourth — so of the eight rulings put to a control, half were wrong, not a third |
| 9 | *"`check_gs` §0:242 exempts the Sharpshooter's enabler by name"* | **HELD IN EFFECT; THE EXCLUSION IS §1's TABLE** | §0:242 asserts his enabler IS the Hunter's basic; what leaves Quick Shot unasked is `MINIMUM`, the five-row table §1:338 walks |
| 10 | *"TWO ARMS ARE SUPERSEDED BY ANOTHER SUITE'S ARM"* | **SIX STAND WHOLLY ON ANOTHER TARGET** | `bp:214`, `cp:232` on three other suites' sweeps (not `bt:318` alone — HG's c2 logs show `cb`'s and `ce`'s naming all eight); `bv:270`, `bw:272` on `test_batch_bp` §5; `check_dv:270`, `test_batch_ah:80` on `check_gs` (§2c) |
| 11 | *"HA contradicts itself — §1d says retire, §1g says keep"* | **HELD AS HG READ IT** | §1d's table: RETIRE. §1g calls `ability_slots_used` "the door a future lineage card would have to pass through" and names the arm a near-tautology against it; it does not say *keep* in words |
| 12 | *"29 of 71 sat in moved code and 28 of those were a neighbour's repair"* | **HELD** | HG §1b |
| 13 | *"merge base FS, one conflict in `state.md`, `main` losing nothing"* | **HELD, MEASURED ON HH's OWN TREE** | §6h |
| 14 | *"The battery runs about 70 minutes"* | **HELD: the recon ran 71 min 12 s; the acceptance run's own time is in §6g** | §6 |
| 15 | *"and the stamp"* | **`docs/state.md`'s *Last rewritten* line** | `docs/master.html` is not edited — nothing a player meets changed (FU §0's reading) |

---

## §1 — FIVE RETIRED BECAUSE WHAT THEY GUARDED IS GONE

**Each is kept and said to be kept**: its computation still runs, its reading is PRINTED as a `[record]` line, and its
`ok()` asserts the fact that retired it — so the day that fact stops holding, the old question is live again and the
arm goes red saying so. The comment at each site records what it guarded and which batch removed it.

| arm (HEAD → now) | what it guarded | what removed it | what it asserts now | checks |
|---|---|---|---|---|
| `check_eh:251` → 270 | EG's record that `core_slots` and `protected_names` disagree on all twelve, so a reader can tell which the ladder reads | **GK** moved the cap onto `lineage_slots`; **GS §1** made that term zero for every lineage | no lineage takes a slot (twelve walked) | 1 → 1 |
| `test_batch_au:364` → 384 | each of twelve lineage trees deals 27 cells and grants nothing (BA's list, DO's charter) | **FX** deleted the twelve trees | every lineage is dealt the ONE tree | 12 → 1 |
| `test_batch_az:669` → 690 | a Sharpshooter rune's lane tag is one of his three lanes, so a renamed lane cannot leave a stale tag (AS's Honed Lance) | **FX** deleted his tree and its lanes; a rune's `lane` is history nothing reads | no node of the one tree carries a lane | 4 → 1 |
| `test_batch_bo:297` → 317 | no lineage-shelf card is in a SIBLING lineage's boss pool (DY's re-point) | **GP** made a class's shelves one pool: a sibling's card is the hero's own pool's, the shape of the sixteen allowed own-lineage overlaps | one pool a class (`one_pool_a_class`) | 159 → 1 |
| `test_batch_br:682` → 695 | a Warden's offer holds a Warden-shelf card — the spec side of the per-card seam roll | **GP** deleted the seam | one pool a class | 1 → 1 |

---

## §2 — SIXTEEN RETIRED BECAUSE SOMETHING ELSE ASKS BETTER, AND ONE THAT IS NOT

### §2a — THE ONE THAT WAS NEVER DRIVEN, DRIVEN FIRST

**`test_batch_bw:417`** — *"no NINE card in any `spec_abilities` — 'kit does not already hold'"* — was sorted
SUPERSEDED onto `check_gs` §1:306 and never driven. The brief says drive every remaining supersession before
retiring anything, so it was driven first, on HEAD's untouched tree, three ways, each in its own isolated copy:

| ctl | the defect (Aegis Wall, one of BW's nine) | `test_batch_bw` (the arm) | `check_gs` §1:306 (the named superseder) | what else went red |
|---|---|---|---|---|
| c9a | defined a second time in its OWN lineage's table (the Warden's) | **495 / 0 — green** | **green** — one home, the shelf | `check_gs` §1:326's count (*"31 cards returned to a pool"* — a message that misnames the defect) and `test_batch_al:689` (*"the Warden still DEFINES exactly 3 … (has 4)"*) |
| c9b | defined in a SIBLING's table (the Berserker's) | **495 / 0 — green** | **red** — *"Aegis Wall (the berserker's) has 0 homes"* | §1:326's count |
| c9c | put in an OPENING KIT as the game has one now (the Warrior's class kit) | **495 / 0 — green** | **green**; `check_gs` red seventeen times on the kit's shape | `check_gn` §0: *"no kit card is in a draft or boss pool (["Aegis Wall"])"* |

**The arm read green all three times, and an ok() trace of HEAD says why: it fires ZERO times.** It walks
`Classes.SPEC_IDS`, whose keys are the four CLASSES, and `spec_abilities("warrior")` falls through to `return []`,
so the inner loop never runs — **the shape HD §2 repaired in `test_batch_bu`'s NINE-name sweep.** HA filed it tier 2
and HG sorted it superseded; neither noticed it cannot fail. **It guards nothing, so it is not superseded; by the
brief's rule it stays**, and it goes to HI to be repaired to what it was for. A note at its site says so; no code
moved there.

### §2b — THE SIXTEEN

| arm (HEAD → now) | what it asked | superseder(s) — measured | control | checks |
|---|---|---|---|---|
| `check_dv:270` → 279 | Holy's authored core takes 0 bar entries | `check_gs` §0:254 (every lineage's authored slots = its enablers' bar entries) | c4 | 1 → 1 |
| `test_batch_ah:80` → 107 | AH's five trims are out of `spec_abilities` — "left the kit" | `check_gs` §1:306 (every defined card has one home) | c1 | 5 → 1 |
| `test_batch_al:692` → 712 | War Stomp and Interpose not in the Warden's `spec_abilities` — "not opening kit" | `test_batch_al:689` → 692 (the Warden DEFINES exactly 3) — not `:519`/`:521`, which stay green | c1 | 1 → 1 |
| `test_batch_ar:614` → 627 | Flame Shield not in the Pyromancer's `spec_abilities` — "not in the kit" | `test_batch_ar:676` → 695 (the name resolves to NOTHING) | c8 | 1 → 1 |
| `test_batch_bp:139` → 154 | each lineage shelf is non-empty — "EVERY spec has a draft now" | `Fixture.class_pool_floors` (asserted in `bp`); `test_batch_cd` §2's depth table | c6 | 12 → 1 |
| `test_batch_bp:214` → 251 | a BP card is not in the Warrior class-wide draft | **three other suites**: `test_batch_bt` `_names()`, and the class-wide arms of `test_batch_cb`'s and `test_batch_ce`'s `_names()` | c2 | 6 → 1 |
| `test_batch_bt:200` → 215 | a BT card is not on a class-wide shelf | `test_batch_bt:318` → 344 (whole-draft uniqueness) | c2 | 32 → 1 |
| `test_batch_bu:208` → 223 | a NINE card is not on a class-wide shelf | `test_batch_bu:332` → 352 ("appears in exactly ONE pool") | c2 | 36 → 1 |
| `test_batch_bv:246` → 261 | the same | `test_batch_bv:420` → 458 | c2 | 36 → 1 |
| `test_batch_bv:270` → 303 | a Hunter lineage's enabler is not on its OWN shelf | `test_batch_bp` §5's enabler arm (`:234` → 280) — its one case today is Quick Shot, which `check_gs` §1 leaves out | c3 | 1 → 1 |
| `test_batch_bw:251` → 266 | a NINE card is not on a class-wide shelf | `test_batch_bw:412` → 450 | c2 | 36 → 1 |
| `test_batch_bw:272` → 305 | an enabler is not on its own shelf (BO's control) — the same six `bp` §5 asks | `test_batch_bp` §5 (all six); `check_gs` §1:338 (five, more strictly) | c3 | 6 → 1 |
| `test_batch_cb:197` → 212 | a NINE card is not on a class-wide shelf | `test_batch_cb:329` → 352 (every class-wide card, not also a spec card) | c2 | 36 → 1 |
| `test_batch_cd:404` → 435 | each shelf holds at least CI's eight | `test_batch_cd:403` → 414 (the per-shelf depth table); `Fixture.class_pool_floors` (asserted in eleven other suites) | c6 | 12 → 1 |
| `test_batch_ce:247` → 262 | a NINE card is not on a class-wide shelf | `test_batch_ce:389` → 412 | c2 | 36 → 1 |
| `test_batch_cp:232` → 254 | a CP card is absent from every class-wide shelf | **three other suites**, as `bp:214` | c2 | 108 → 1 |

*`check_gs` is cited by HEAD's lines throughout, as HG cited it; HH's notes moved them: §0:242 stays at 242, §0:252 is
now 256, §0:254 is 258, §1:306 is 314, §1:318 is 326, §1:321 is 329, §1:326 is 334 and §1:338 is 352, each line
byte-identical.*

**What each asserts now.** Twelve of the sixteen, and two of §1's five, rest on one fact — a class's shelves are its
one pool (GP) — which lives once, in `suite_fixture.one_pool_a_class`, beside the pool floors: each retired site asks
it and names itself. Three (`ah:80`, `al:692`, `ar:614`) assert GS §1's fact that a lineage defines more than it
opens with; `check_dv:270` asserts that Mercy brings no card, the reason the Holy's core takes no bar entry.

### §2c — THE DEPENDENCIES, RECORDED AT BOTH ENDS

**The brief named two arms superseded by another suite's arm. Six retired arms stand wholly on another target**, and
two more lean on one for half their question:

| retired arm | stands on | recorded at the retired end | recorded at the superseder's end |
|---|---|---|---|
| `test_batch_bp:214` | `test_batch_bt`, `test_batch_cb`, `test_batch_ce` `_names()` | comment and `[record]` line naming all three | a note at each of the three naming `bp` §5 and `cp` §2 |
| `test_batch_cp:232` | the same three | the same | the same notes |
| `test_batch_bv:270` | `test_batch_bp` §5's enabler arm | comment naming it, and that it is HI's to re-point | a note at `bp` §5: the only arm left asking Quick Shot, and HI's re-point must keep asking it |
| `test_batch_bw:272` | `test_batch_bp` §5; `check_gs` §1:338 | the same | notes at both |
| `check_dv:270` | `check_gs` §0:254 | comment and FAIL message | a note in `check_gs` §0 |
| `test_batch_ah:80` | `check_gs` §1:306 | comment and FAIL message | a note in `check_gs` §1 |
| `test_batch_bp:139` (half) | `test_batch_cd`'s depth table (the other half is the floors `bp` asserts itself) | comment | a note at `suite_fixture.class_pool_floors` |
| `test_batch_cd:404` (half) | `Fixture.class_pool_floors`, asserted in eleven other suites (the other half is `cd`'s own depth table) | comment | notes at `class_pool_floors` and at `cd`'s depth equality |

**The record is a note, not a pin.** A retired assertion is a statement about the GAME, so none asserts another
target's source. What makes the notes the durable half is that they sit where the next editor of the superseder
has to read them, and that `docs/state.md` carries the same table in the queue until HI has passed through.

---

## §3 — `check_gn:208` IS A RE-POINT, BY RULING

**HA answers it twice.** Its §1d table marks `check_gn:197` (now `:208`) RETIRE — the arm restates
`ability_slots_used`, a near-tautology while `lineage_slots` is zero for every lineage. Its §1g calls
`ability_slots_used` *"the door a future lineage card would have to pass through"*, which is what the arm pins.
**Ruled: §1g, the specific reading, over §1d's general one.** It goes to HI with the re-points. **Recorded** at the
arm's own site (a note above it in `check_gn` §0), in `docs/state.md`'s HI table and here, so HA §1d's RETIRE is not
read as live.

---

## §4 — WHAT IS LEFT: FORTY-NINE, DERIVED

**Derived, not subtracted.** Every one of HG's forty-eight A arms, and `bw:417`, was mapped from HEAD to the tree HH
leaves, line by line through the diff; its own statement was compared byte for byte; and its enclosing function was
compared with comments stripped, so an arm HH's edits landed beside is flagged the way HG flagged its twenty-nine.
**And each was traced**: an ok() trace of HEAD attributes every check each target makes to its line, and **all
forty-eight fire at least once** — `bw:417` is the only one of HG's seventy that never fires.

| arm (line after HH) | HEAD | fires | HH landed | what it asks | the door it should ask |
|---|---|---|---|---|---|
| `check_do:475` | 475 | 3 | no | precision_ranks read-site pin keeps a reason about the Swordmaster's guaranteed statuses (dorma | the guaranteed-status table re-keyed by class (with check_dp:200) |
| `check_dp:191` | 191 | 1 | no | the per-lineage tree sweep read more than 0 nodes | the positive arm; the sweep walks SPEC_IDS, re-point to the one tree per class |
| `check_dp:200` | 200 | 1 | no | no node reads a status outside a per-spec guaranteed-status table built on cores and passives | LARGER: needs check_do's per-spec guaranteed-status table re-keyed by class |
| `check_dr:205` | 205 | 1 | no | resurrection 'belongs to the Holy Cleric' via spec_abilities ownership | resurrection's owner: defined once, reachable by every Cleric of the class pool |
| `check_dv:251` | 251 | 1 | **yes** | emptiable boss pools counted against the lineage's own shelf | emptiable boss pools, counted against the class pool, not the lineage shelf |
| `check_dv:260` | 260 | 1 | **yes** | Holy's un-draftable boss cards checked against the Holy shelf only | Holy's un-draftable boss cards, against the class pool |
| `check_ea:317` | 317 | 12 | no | award-always-pays floor per lineage shelf, not per class pool x engines held | LARGER: one re-derivation over class x engines held, shared by the four |
| `check_ea:332` | 332 | 12 | no | full-three floor over the pre-GP two-tier chain | LARGER: same re-derivation |
| `check_ea:347` | 347 | 1 | no | no lineage's shelf floor below 3 | LARGER: same re-derivation |
| `check_ea:395` | 395 | 1 | no | lost awards from the per-spec two-tier floor | LARGER: same re-derivation |
| `check_ea:400` | 400 | 1 | no | emptiable boss pools counted against the lineage's own shelf | emptiable against the class pool |
| `check_eh:156` | 156 | 12 | no | arm C: the lineage's reach is gone and EH's third tier must pay - the tier GP deleted | arm C reaches the tier GP deleted; re-point onto the two live tiers |
| `check_eh:213` | 213 | 12 | no | all 12 lineages: boss pool + lineage shelf held still leaves the class tier paying 3 | the class tier, asked per class x engines held rather than per lineage |
| `check_es:656` | 656 | 1 | no | a swap card taken from the Berserker's shelf as 'one a player could actually make' | a swap card taken off the class pool, which is what a player draws |
| `check_gn:216` | 208 | 24 | no | ability_slots_used == lineage_slots + kit_slots with no engine held | FLAGGED: HA's action says RETIRE, HA §1g says the door is worth keeping. **Ruled at HH §3: a re-point, by §1g; HA §1d's RETIRE is not live** |
| `test_batch_ah:62` | 62 | 12 | **yes** | each lineage's spec_abilities holds 3 bar entries - 'opens with' | c1: only test_batch_al:689 re-states it, and only for the Warden; the all-twelve definition count survives the merge |
| `test_batch_ah:157` | 130 | 20 | no | no class-wide card costs a spec-exclusive secondary resource | the curation rule, over the class pool |
| `test_batch_ah:160` | 133 | 20 | no | no class-wide card is a 'Beastmaster signature' | ditto, and the summons are every Hunter's kit card since HB |
| `test_batch_ah:163` | 136 | 20 | no | Hex of Ruin 'stays Occultist-only' | Hex of Ruin, over the class pool |
| `test_batch_ah:165` | 138 | 20 | no | no class-wide card is 'gated on a spec passive' - replaced by ENGINE_READ / SITS_OUT | c5: check_gp read 0 failures on the injection — NOT superseded; re-point onto the ENGINE_READ row the gate uses now |
| `test_batch_ah:324` | 297 | 1 | no | the award refuses a member 'with no spec' | the award's refusal: seat the spine-taker who DOES bank |
| `test_batch_ah:326` | 299 | 1 | no | the fallback refuses a member 'with no spec' | ditto |
| `test_batch_ah_battle:207` | 207 | 1 | no | action-bar fillers from class-wide + Berserker shelf, 'new' = not in spec_abilities | fillers off draft_pool('warrior'), the one pool a Warrior draws |
| `test_batch_aj:409` | 409 | 1 | no | Hack and Slash 'is in the Berserker kit' via spec_abilities | Hack and Slash: the definition table's wording, not 'the kit' |
| `test_batch_aj:552` | 552 | 1 | no | Battle Shout 'drafts from the Berserker' as reachability | Battle Shout reachable off the class pool |
| `test_batch_aj:584` | 584 | 1 | no | Rampage 'drafts from the Berserker' as reachability | Rampage, same |
| `test_batch_an:824` | 824 | 1 | no | sibling-spec set built from boss pools AND draft shelves (positive arm) | the spec-foreign set under one pool a class |
| `test_batch_an:829` | 829 | 900 | no | no zone-boss offer returns a sibling-spec entry, over the same mixed set | the zone-boss offer against that set |
| `test_batch_at:603` | 603 | 1 | no | 'STABILIZE IS OUT of the opening three' = spec_abilities | 'out of the opening three' asked of the live opening |
| `test_batch_at:628` | 628 | 1 | no | Stabilize 'spec-only: it reads Resonance' via the class-wide shelf | Stabilize's gate is ENGINE_READ now, not absence from a shelf |
| `test_batch_au:679` | 657 | 2 | no | Firestorm / Rime 'drafts from the <spec> instead' | Firestorm / Rime reachable off the class pool |
| `test_batch_au:799` | 777 | 1 | no | Magi's Wrath 'drafts from the Arcanist instead' | Magi's Wrath, same |
| `test_batch_au:968` | 946 | 121 | no | the debug grant holds no sibling-spec entry, siblings' shelves counted as theirs | the debug grant vs sibling entries, under one pool |
| `test_batch_av:303` | 303 | 1 | no | Resurrection / Intercession not on the Cleric class-wide shelf 'never offered to a sibling with | the two Mercy spenders, against the class pool |
| `test_batch_aw:466` | 466 | 1 | no | Sacred Resolve 'drafts from the Devout' | Sacred Resolve off the class pool |
| `test_batch_aw:468` | 468 | 1 | no | Bulwark of Fortitude 'drafts from the Devout' | Bulwark of Fortitude, same |
| `test_batch_ay:403` | 403 | 1 | no | retired payload edits Kill Command 'which every Beastmaster owns' | 'which every Beastmaster owns': the pet card is every Hunter's since HB |
| `test_batch_ay:410` | 410 | 1 | no | retired payload edits Hunter's Instinct 'which every Beastmaster owns' | ditto |
| `test_batch_bb:765` | 765 | 9 | no | no Mage lineage's spec_abilities holds Ashes of Al'ar - 'does not START with it' | 'does not START with it' asked of the live opening |
| `test_batch_bo:190` | 190 | 3 | **yes** | the Warrior shelf is NAMED - 'one of four heroes had no draft' | the three Warrior shelves NAMED: an authoring location, said so |
| `test_batch_bo:369` | 348 | 12 | no | CAP - core_slots(spec) >= 3 free slots | CAP - slots >= 3, re-worded off enabler_slots |
| `test_batch_bp:280` | 234 | 6 | **yes** | a lineage's enablers are absent from its OWN shelf only | c3: check_gs:338 caught Bloodlust and NOT Quick Shot (the Sharpshooter's enabler is the Hunter's basic); this is the widest of the three and is KEPT, re-pointed over the class pool |
| `test_batch_br:289` | 289 | 3 | no | each Warrior lineage can draw Rally, via the class-wide shelf | Rally: every Warrior draws it off the class pool |
| `test_batch_br:294` | 294 | 3 | no | each Hunter lineage can draw Field Dressing, via the class-wide shelf | Field Dressing, same |
| `test_batch_bx:251` | 251 | 1 | no | the Warden shelf >= 8 'spec cards to be offered' | the Warden's shelf as a real, named part of the one Warrior pool |
| `test_batch_cb:1239` | 1216 | 1 | no | pins master.html's 'All twelve specs draft from at least ten' (a doc edit rides with it) | GZ's SHAPE: master.html's sentence and its pin move together |
| `test_batch_cd:453` | 426 | 1 | **yes** | the thinnest shelf >= 10 as 'the one a card is owed to next' | the thinnest pool as the one a card is owed to next |
| `test_run_harness:432` | 432 | 1 | no | a hero with his spec blanked banks nothing - the spine-taker who does bank is never seated | the un-awakened hero: seat the spine-taker who banks |
| `test_batch_bw:465` | 417 | 0 | no | no NINE card in any `spec_abilities` — 'kit does not already hold' (HG sorted it superseded) | **HH: it fires ZERO times** — walks the four class keys; repair it to what it was for, as HD §2 did `test_batch_bu`'s |

**FORTY-NINE ARMS IN TWENTY-SIX TARGETS, ALL FORTY-NINE BYTE-IDENTICAL.** Fifteen are on a new line number, under HH's
notes or its retirement code above them. **Six sit in a function HH's retirement code now shares** — `check_dv:251`
and `:260` (`_s2_boss_depth`), `test_batch_ah:62` (`_test_kits`), and `test_batch_bo:190`, `test_batch_bp:280` and
`test_batch_cd:453` (each a `_pools`) — so HI re-reads the lines that feed each before editing it (HG §1b's rule).
**Twenty-two sit in ten of the nineteen targets HH's trace covers, and twenty-one of them fire exactly as often on the
landed tree as on HEAD; `bw:417`, now `:465`, fires zero times on both.** Of the other twenty-seven, one is
`check_gn`'s (a note only; 204 checks on both trees) and twenty-six are in fifteen files HH did not touch.

---

## §5 — WHAT WAS DELIBERATELY NOT DONE

- **No assertion was re-pointed.** That is HI. `bw:417` and `check_gn:208` carry notes and no code change.
- **No rune, engine, card, kit, pool or node changed.** Nothing under `scripts/` or `data/` moved.
- **No merge to `main`**, and `main` is untouched (§6).
- **HF's five open rulings stay open.**
- **`docs/master.html` is not edited**, so `test_batch_cb:1216`'s pinned sentence (the pin is at `:1239` after HH's
  notes) and its pin still move together, at HI.

---

## §6 — VERIFICATION

*Written before the acceptance run, per the brief's §6; the figures that only the run can give are filled after it and
marked so (§6h).*

### §6a — THE PLAYER'S FILES, FIRST

Backed up to `../save-backups/HH-20260924-111608` before anything ran and verified by md5 — byte-identical to the live
folder and to HG's backup: `profile.json` `ed4144e1…`, `relics.json` `fdc12ffa…`, `run_save.bin` `25582edd…`,
`settings.cfg` `0c1b39c3…`. **After both runs, and after everything else this batch ran, the four are byte-identical
to the backup again**: the same four sums, off the live folder.

### §6b — THE INSTRUMENTS THIS BATCH BUILT, EACH SHOWN TO BITE FIRST

- **The parse floor.** Every log is grepped for `Parse Error` and `SCRIPT ERROR`: never a tally, never an exit code.
  **Armed first**: HH's own first draft of `test_batch_au` declared `granting` a second time in the function it
  retired into. Put back into a copy, `--check-only` printed *"Parse Error: There is already a variable named
  "granting" declared in this scope."*, and the restored file hashed back to the landed one.
- **The ok() trace.** In an isolated copy, every `ok(` call site is rewritten to print its own line. Line numbers
  are preserved and the helper is appended. **Its self-check is the ledger**: in every traced target the fires
  sum to the count the target printed, 19 of 19 on HEAD and 19 of 19 on the landed tree. **Its bite is `bw:417`**:
  zero fires, where each of the other forty-eight A arms reads at least one.
- **The literal sweep over the documents.** Every string literal of four characters or more, in both quote styles and
  in every root `.gd` at HEAD and in the tree, is searched in each document draft and in HEAD's blob, raw and
  whitespace-flattened. `CLAUDE.md`, the changelog and the design notes read **0 LOST and 0 GAINED**. `state.md`,
  whose WHERE block and queue are rewritten every batch, reads 1 LOST (`'ERROR'`, a literal of `check_de`'s) and 11
  GAINED (six card names, and `awakened`, `mixed`, `precision_ranks`, `resurrect` and `resurrection`). **None of those
  needles is owned by `check_es`**, the one target that opens `state.md`, and its two claim windows (`2+ threshold …`)
  read identically before and after. **Armed**: one needle, broken in a copy of a draft, came back exactly: `WARRIOR
  POOLS WERE OWED AND ARE PAID`, held by `test_batch_bo`.
- **The forward map.** A HEAD line is mapped to its landed line through a diff of the two sources, and the statement
  is compared byte for byte. **All 49 of HI's arms are identical.** Its other arm is the retired lines: each maps to
  nothing, so a rewritten line cannot read as kept.
- **The code-only diff.** Comments are stripped quote-aware and blank lines dropped. `check_gs` and `check_gn` read
  **0 code lines**, notes only. Its positive arm is `check_eh` (11) and `check_dv` (5), where code did move.
  `test_batch_bw` reads 18, every one in its two retired arms in `_pools()`, and none in `_names()`, which holds
  `:417`.
- **The injections.** Each anchor is count-checked, the file re-read and the injected text asserted present. `b3`
  also asserts that exactly one entry of `runes.json` moved and that the file still parses.
- **The row move.** `baselines.json` is edited as text, so its indent-1 layout stands: thirteen rows, and the file
  parses equal to HEAD's except those rows' `checks`, `checks_obs` and `note`.

### §6c — HEAD's UNMODIFIED GATES AGAINST THE NEW TREE, BEFORE ANY GATE WAS EDITED

**HEAD's unmodified gates ran against every suite as HH edited it**, in an isolated copy (`Dawn of Decay HH recon`),
before any gate was touched: 11:42:10 to 12:53:22, **71 min 12 s**. **All 125 launched, and none of the 125 logs
holds a `Parse Error` or a `SCRIPT ERROR`** (grepped per log). The two sanctioned reds sat at their recorded counts:
`check_cm_live` 13 / 4, and `check_gj` 70 / 1 with *"+167 gold and the purse moved 187"*. **`check_de` read 517 /
13: exactly the thirteen predicted rows, each FELL to its predicted count and no other row moved.** The prediction
came from HEAD's trace, with each retired arm's fires replaced by its one new check. It was written while the recon
ran, forty seconds after it started and before any of its output was read. The five retired arms that fired once
moved no row. **The four gates HH then edited read their HEAD counts on the edited suites** — `check_eh` 153,
`check_dv` 84, `check_gs` 749, `check_gn` 204 — **and read the same four counts, with 0 failures, after their
edits.** After the gate edits and the pin manifest's regeneration, the census and pin gates read green in a copy of
the landed code: `check_da` 42, `check_dw` 35, `check_ec` 24, `check_ed` 18, `check_ek` 47, `check_ff` 68,
`check_gw` 76 and `check_parse` 199, with 0 failures in each.

### §6d — WHAT STILL BITES: EACH OF THE TWENTY-TWO, BROKEN ON PURPOSE

**One defect per isolated copy of the landed tree** (renamed in `project.godot`, its `user://` seeded from the backup),
**two arms per copy**: NEW is the landed target; HEAD is HEAD's copy of each retired arm's file, dropped into the same
injected copy. **Read by the FAIL text, never the count.** For §2's sixteen the question is that the superseder goes
red while the retired arm does not; for §1's five, what — if anything — still goes red.

**§2's sixteen: the retired arm is silent and its superseder is red, in every control.**

| ctl | the defect | the retired arm: NEW, and HEAD's copy of it | what goes red in NEW (the superseder, by its FAIL text) |
|---|---|---|---|
| **c1** | War Stomp defined back into the Warden's table | `ah:80`, `al:692`: **silent**, each `[record]` naming War Stomp. HEAD's red: *"War Stomp left the warden kit"*; *"War Stomp and Interpose are still earnable, not opening kit"* | `check_gs` §1:306 *"War Stomp (the warden's) has 0 homes among enabler, kit, shelf and the pet's calls — one"*, and four more; `test_batch_al:689` *"the Warden still DEFINES exactly 3 lineage abilities (has 4)"*; and HI's `test_batch_ah:62` *"warden opens with 3 spec abilities (got 4)"* |
| **c2** | eight lineage-shelf cards duplicated onto the Warrior's class-wide shelf | `bp:214`, `bt:200`, `bu:208`, `bv:246`, `bw:251`, `cb:197`, `ce:247`, `cp:232`: **all eight silent**. HEAD's copies red, each on its own card: `bp` Blood Offering, `bt` Slow Burn, `bu` Recant, `bv` Bloodbond, `bw` Aegis Wall, `cb` Firedraw, `ce` Alms, `cp` Alms and Unslaked | `test_batch_bt:318` *"no ability name is used twice across the whole draft"* naming all eight; `cb`'s and `ce`'s `_names()`, eight lines each; `bu`, `bv` and `bw` *"… appears in exactly ONE pool (got 2)"* on their own card; and the `master.html` draft-count pins. **`bp` and `cp` read 0 failures: what catches their defect is the three other suites' sweeps, as recorded** |
| **c3** | Bloodlust and Quick Shot put on their own lineage shelves | `bv:270`, `bw:272`: **silent**, their `[record]`s naming the cards. HEAD's red: `bv` on Quick Shot; `bw` on Bloodlust and Quick Shot | **`test_batch_bp` §5's enabler arm on BOTH** — *"berserker's enabler 'Bloodlust' is still NOT draftable"*, *"sharpshooter's enabler 'Quick Shot' …"*; `check_gs` on Bloodlust only (§1:306, §1:338, §3), because Quick Shot is not in its `MINIMUM` |
| **c4** | the Holy's authored slots, 0 → 1 | `check_dv:270`: **silent** (Mercy still brings no card; its `[record]` reads 1 bar entry). HEAD's red: *"Holy's protected core takes 1 bar entries, not the 0 GS §1 left it"* | `check_gs` §0, four lines, among them §0:254 *"holy's authored slots (1) are not its enablers' bar entries (0)"* |
| **c6** | the Warden's shelf emptied | `bp:139`, `cd:404`: **silent**. HEAD's red: *"EVERY spec has a draft now — warden is not empty"*; *"…and warden is still at or above CI's flat floor of 8"* | `test_batch_cd:403` *"warden drafts 0 (want 11)"* and `cd`'s totals; the class floors in `bp` and `bo`, *"the warrior pool holds 32 cards, below its floor of 43"*; `bp`'s Warden tranche pins |
| **c8** | Flame Shield defined back into the Pyromancer's table | `ar:614`: **silent**. HEAD's red: *"Flame Shield is not in the kit"* | `test_batch_ar:676` *"Flame Shield resolves to NOTHING — the name is dead in every pool"* |

**§1's five: what still goes red when what each arm guarded is broken, if anything does.**

| ctl | what the arm guarded, broken | the retired arm: NEW, and HEAD's copy of it | what still goes red in NEW |
|---|---|---|---|
| **b1** | the Holy's two numbers made to AGREE: her authored slots set to her protected-name count, 4 | `check_eh` §3: **the fact goes red**, *"a lineage takes a slot again (holy (4); 12 of 12 walked) — EG's question … is live again"*. HEAD's red: *"11 of the twelve specs disagree between `core_slots` and `protected_names`, not all twelve"* | **the retiring fact itself**, and beside it `check_gs` §0 (four lines, *"the holy lineage takes 4 slots"*) and `check_gn` §0 (*"… every lineage opens at 3 …"*). The two numbers can agree only if a lineage takes slots, and that is what the fact forbids |
| **b2** | a node of the one tree grants an ability (Cleave, on `tn_health`) | `au:364`: **silent**. HEAD's red twelve times, *"<lineage> grants no ability from any of its 27 cells (27 dealt; tn_health)"* | `test_batch_au` §2, seven lines (*"NO talent node grants an ability (1 do: tn_health -> Cleave)"*, the payload's shape, the granting walk); `check_fx` §1, *"a talent grants an ability (["Cleave"])"*; `check_cz`, *"talent grant `Cleave` resolves to nothing"* |
| **b3** | `deep_sight`'s lane tag renamed to AS's stale *Honed Lance* | `az:669`: **silent**. HEAD's red: *"the rune deep_sight carries a live lane tag (Honed Lance)"* | **NOTHING AT ALL.** All 28 battery targets whose code names a `lane` field or opens `runes.json` read green, with no parse error, script error or timeout, because a rune's `lane` is history nothing reads now: FX deleted the lanes the tag named, and the game copies the tag into a rune instance (`runes.gd` `build()`) and reads it nowhere. **This is the §1 case the brief describes: the retirement is verified by nothing going red** |
| **b4** | Gut Rip, a Berserker-shelf card, put in the Warden's boss pool | `bo:297`: **silent**. HEAD's red: *"'Gut Rip' is a berserker draft card and a SIBLING spec's boss card"* | **a census, not the sibling question**: `check_dv` §2, *"`SPEC_POOLS` is 45 entries, not the 44 on record"* and its distinct-name count. `test_batch_an`, `check_ea`, `check_eh`, `check_gs` and `check_he` stay green. Under GP a sibling's shelf is the hero's own pool, so the card is the same shape as the sixteen allowed own-lineage overlaps |
| **b5** | the Warrior's draft skips the Warden's shelf | `br:682`: **the fact goes red**, *"test_batch_br, §4's spec-side seam arm: a class's draft is not its four shelves together (warrior (43 on its shelves, 32 in its pool) …) — GP's one pool is split again …"*. HEAD's red: *"…beside real spec cards"* | **the retiring fact itself, at all fourteen one-pool sites in eleven suites, each naming its own arm**; the class floors wherever they are asserted (*"the warrior pool holds 32 cards, below its floor of 43"*); and `check_gp` §0, *"the warrior pool is not its three lineage shelves plus its class-wide shelf, in order"* |

**One prediction was wrong, and it is recorded rather than dropped.** Before b4 ran, HH predicted that
`test_batch_an:829`, one of HI's, would go red. It stayed green, and it could not have gone red: it walks a
*Berserker* hero's boss offers, and b4 put the card into the *Warden's* boss pool, which that walk never draws.

**What each of the twenty-two rests on, then.** For §2's sixteen it is the superseder in the table, driven red on
the landed tree. For §1: `check_eh` (b1) and `test_batch_br` (b5) rest on the retiring fact itself, which goes
red; `test_batch_au` (b2) rests on its own §2, `check_fx` §1 and `check_cz`; `test_batch_bo` (b4) rests on a
boss-pool census that counts the card but does not ask the old question; and **`test_batch_az` (b3) rests on
nothing, which is what a retired subject means.** The seventeenth, `bw:417`, was not retired (§2a).

### §6e — AND EACH RETIRING FACT, BROKEN ON PURPOSE: A RETIREMENT THAT CANNOT FAIL IS A GAP

**Each retiring fact was broken on purpose, in its own copy, because a retirement whose new assertion cannot go red
has only moved the gap.** HEAD's copy of the old arm shows whether the old question would have seen the break.

| ctl | the fact, broken | the new assertion, NEW | the old arm, HEAD |
|---|---|---|---|
| **w2** | every lineage opens with its whole definition table (the opening kit's name filter removed) | **red at all three**: `ah` *"a Warrior lineage opens with its whole definition table again (berserker (3 defined, 3 opened), …)"*; `al` *"the Warden opens with his whole definition table again (3 defined, 3 opened)"*; `ar` *"the Pyromancer opens with his whole definition table again …"* | **silent at all three**: the old arms read `spec_abilities` membership, which did not move (HEAD's `ar` goes red only on its where-arm, which is red on both trees) |
| **w3** | the Warden dealt a tree one cell short of the one tree | **red**: *"a lineage is dealt a tree of its own again (warden; 12 of 12 lineages walked, the one tree 27 cells)"* | red: *"warden grants no ability from any of its 27 cells (26 dealt; )"* |
| **w4** | a node of the one tree carries a lane (`tn_health`) | **red**: *"a node of the one tree carries a lane again (tn_health; 27 cells walked)"* | **silent**: the old arm read the runes' lane tags, not the tree |
| **w6** | Mercy brings a card (the Holy's Heal) | **red**: *"Mercy brings a card now (["Heal"]) — … DV's slot tripwire, retired at HH §2 onto check_gs §0, asks a live question again"*, with `check_gs` §0 and §1 beside it (nine lines) | **silent**: her authored slots are still 0 |
| **b1** | a lineage takes slots (§6d) | **red** on `check_eh` §3's fact | red |
| **b5** | a class's draft skips one of its own shelves (§6d) | **red at all fourteen one-pool sites, each naming itself** | red |

**Each of the twenty-one new assertions was seen red**: the fourteen one-pool sites in b5, `ah`, `al` and `ar` in
w2, `au` in w3, `az` in w4, `check_dv` in w6 and `check_eh` in b1. **In three of the four wake-ups (w2, w4 and w6)
HEAD's arm stayed silent**, so there the new assertion asks something the old one could not.

### §6f — THE COUNT, ATTRIBUTED LINE BY LINE

**An ok() trace of the landed tree, beside HEAD's, over the nineteen targets HH edited that assert anything**:
`check_eh`, `check_dv`, `check_gs` and the sixteen suites. `check_gn` carries a note only and reads 204 on both
trees. HEAD's lines were mapped to the landed tree through a diff of the two sources:

- **The only HEAD lines that lose fires are the twenty-one retired arms**: every one of them, and nothing else. Each
  maps to no line, because its `ok()` was replaced.
- **The only lines that exist in the landed tree alone are their twenty-one replacements**, each firing once.
- **`check_gs` moved no line**; its edits are notes.
- **17,256 → 16,735, −521: the net of the thirteen `baselines.json` rows.** `check_eh`, `check_dv`, `al`, `ar` and
  `br` each lost one fire and gained one, so their rows stand.
- **No failing line on either tree**, and in every target the fires sum to its printed count.

### §6g — THE PRE-PASS AND THE ACCEPTANCE RUN

**THE PREDICTION, WRITTEN FIRST (DF's rule).** Thirteen `baselines.json` rows moved, each by exactly the checks its
retired arms stopped making (§6f), and no other row is predicted to move. The battery should read 125 of 125
launched and **`check_de` 517 checks / 0 failures / 0 notices**, with no `Parse Error` and no `SCRIPT ERROR` in any
log. The two sanctioned reds should sit at their recorded counts: `check_cm_live` 13 / 4, and `check_gj` 70 / 1 with
*"+167 gold and the purse moved 187"*, the figure HF left. **That last figure is the evidence that no rune, card or
pool moved.** Any other movement would be a document this batch wrote reaching an instrument, and it would be named
here, not absorbed.

| | predicted | pre-pass (an isolated copy) | acceptance (the repository, frozen) |
|---|---|---|---|
| targets launched | 125 | **125 of 125** | **125 of 125** |
| `check_de` | 517 / 0 / 0 | **517 / 0 / 0** | **517 / 0 / 0** |
| `Parse Error` | none | **none in any of the 125 logs** | **none in any of the 125 logs** |
| `SCRIPT ERROR` | none | **none in any of the 125 logs** | **none in any of the 125 logs** |
| `check_cm_live` | 13 / 4, sanctioned | **13 / 4** | **13 / 4** |
| `check_gj` | 70 / 1, sanctioned, +167 / 187 | **70 / 1, +167 / 187** | **70 / 1, +167 / 187** |
| the thirteen moved rows | at their new counts | **all thirteen** | **all thirteen** |
| time | about 70 min | 71 min 00 s (13:44:39 to 14:55:39) | 71 min 00 s (14:56:06 to 16:07:06) |

**THE PREDICTION HELD EXACTLY, IN BOTH RUNS.** The parse floor was read off every log individually, never off a tally.
The sanctioned reds were read by their FAIL text: `check_cm_live`'s four are CQ §1's one fact (*"the bar appeared on
the enemy's attack"*, *"the bar's top line names the incoming blow (was: )"* and the two brace positions), and
`check_gj`'s one is *"§4: the card says +167 gold and the purse moved 187"*, to the digit.

### §6h — AFTER THE RUN

- **FILLED AFTER THE RUN, AND ONLY THESE:** §6g's two measured columns and its note, §6a's last line, §0's row 13
  and this §6h. Every other line of this report was written before the pre-pass started.
- **THE TREE WAS FROZEN BY MD5 BEFORE AND AFTER THE ACCEPTANCE RUN, ON ABSOLUTE PATHS: 486 FILES, AND NOT ONE MOVED.**
  The population is every file on disk under the repository except `.git/`, Godot's `.godot/` cache, the untracked
  `save-backups/` and Finder's `.DS_Store`. Ignored files are included, so an `.import` a run rewrote would show;
  none did.
- **The pre-pass copy was proved to be the tree before it ran**: 485 of 485 files byte-identical, and `project.godot`
  differing only in its name.
- **A FIRST PRE-PASS WAS STOPPED AT 15 OF 125 AND RESTARTED.** A re-read of the landed documents, after it had started,
  found two of HH's own sentences wrong. The changelog's §4 said the forty-nine were "each confirmed to actually fire",
  but `bw:417` fires zero times. A comment in `test_batch_cd` said HD §3 folded "thirty-five" floors, where HD's report
  says thirty-six. Both were corrected. The comment was a same-length edit, so no line moved: the stripped diff, the
  pin manifest and a parse check all read unchanged, and the literal sweep read the changelog 0 / 0 again. The first
  pre-pass was then stopped with no process left behind, and the second ran on the corrected tree.
- **THE POST-RUN EDITS, AND THE PROOF THEY MOVED NOTHING THAT READ THEM.** Only three things could not be written
  before the run, because they state what it read: `docs/state.md`'s verification line and user-data line, and this
  report's run figures (with §0's row 13 and this §6h). **`docs/reports/` is opened by nothing.** `docs/state.md` is
  opened by one target, `check_es` (§4's census sweep); re-run against the final documents after these edits, it reads
  57 checks / 0 failures, as it did in the battery, and its two claim windows (`2+ threshold …`) are identical in the
  copy the battery read and in the final file. The needle sweep between those two copies of `state.md` reads 0 LOST
  and 1 GAINED: `'ERROR'` (from "no `SCRIPT ERROR`"), a literal of `check_de`'s, which does not open `state.md`.
  Beside it, `check_ec`, `check_ed`, `check_fg` and `check_fr` read the final documents exactly as they did in the
  battery (24, 18, 22 and 25 checks, 0 failures each), and the pin manifest is current.
- **WHAT STANDS BETWEEN `class-merge` AND `main`, MEASURED ON HH's OWN TREE** with plumbing that moves no ref: a
  probe commit object built from a temporary index holding HEAD and the 28 changed files, each blob-identical to
  the working file. The real index and HEAD were hashed before and after, and both were unchanged.

| | HG | **HH** |
|---|---|---|
| merge base | FS, `3b80fbe` | **FS, `3b80fbe`**, unchanged |
| commits on `class-merge` only | 39 | **41**, with HH's |
| commits on `main` only | 2 | **2** |
| files differing | 189 | **191** |
| **conflicts a merge raises** | one: `docs/state.md` | **one: `docs/state.md`**, unchanged |
| the merged tree against `class-merge` | identical but for `docs/state.md` | **identical but for `docs/state.md`** |

**`main` still loses nothing of its own**: the only file it has changed since FS is `docs/state.md`, and FQ's
convention takes the branch's copy of that file whole.

---

## §7 — WHAT MOVED

| file | what moved |
|---|---|
| `suite_fixture.gd` | **`one_pool_a_class(who)`**: GP's fact that a class's four shelves together are its draft pool, asked by fourteen retired arms in eleven suites, each naming itself in the FAIL text; notes at the helper and at `class_pool_floors` |
| `check_eh.gd` | §3's disagreement arm now asserts that no lineage takes a slot, and prints its reading as a `[record]` |
| `check_dv.gd` | §2's Holy slot tripwire now asserts that Mercy brings no card, and prints its reading as a `[record]` |
| `check_gs.gd` | notes only, one at each of the three places another target now stands on it: §0 for `check_dv`, §1:306 for `test_batch_ah`, and `MINIMUM` for `bw`'s and `bp`'s enabler arms |
| `check_gn.gd` | a note only: §3's ruling, at the slot arm |
| sixteen suites | the retired arms, each kept and said to be kept; notes at every superseder (`test_batch_bt`, `bu`, `bv`, `bw`, `cb` and `ce` `_names()`, `bp` §5's enabler arm, `al:689`, `ar:676`, `cd:403`); at `bw:417` a note and no code; `test_batch_cd` preloads the fixture |
| `pin-manifest.json` | regenerated: the same 1517 pins; 361 `g` fields on a new line in 17 files; `--check` current |
| `baselines.json` | thirteen rows, net −521 (numstat 41 / 41, indent 1 kept) |
| documents | `docs/reports/HH.md` (new), `docs/changelog.html`, `CLAUDE.md` (+2071 B), `docs/design-notes.md`, `docs/state.md` |

**Nothing under `scripts/` or `data/` moved, `run_battery.sh` has no new entry, and no target was added.** The
battery is 125 targets, as at HG.
