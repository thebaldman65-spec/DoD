# BATCH HJ — THE LAST TWENTY-THREE

**On `class-merge`, from `7d9905a` (HI). IMPLEMENT ONLY. The merge's final instrument batch.** HI re-pointed
twenty-seven of the fifty arms still asking the merged game an old question and left these twenty-three — the eight
gates, `test_batch_ah` and `test_run_harness` — where both LARGER re-derivations sit. **All twenty-three are
re-pointed to what they were for** (§1), each with a note at its site, and **both re-derivations are rebuilt from the
population the game actually uses**: the award floors over **class × engines held** (88 seats) where they read twelve
lineage shelves with no engine, and the guaranteed-status table **keyed by class** — the class basic and kit only —
where it credited opening kits GS dissolved, engines GK made droppable and nodes FX deleted (§1a, §1b). **Every
re-point was shown to bite** (§2): **every forward control reds the repaired arm and leaves HEAD's copy silent, and
the fourteen arms whose repair also NARROWS took the defect run the other way, where HEAD's copy alone goes red.**
**And every absence among the twenty-three is paired with an arm that fails when what it looked at is not there**
(§1c, the brief's §6): HJ's first pass left two walks unpaired and paired a third to the file instead of to the walk;
all three are repaired, and six more controls show each new arm biting (§2d).
**The debug toggle grants the class pool, as ruled**, its four stale comments are corrected and it is renamed — **"All
Class Abilities Unlocked", proposed** (§3). **With this batch all 130 arms HA found are dispositioned — 68 repaired or
re-pointed, 35 folded, 27 retired — and FP's six stages are done** (§4). What stands between `class-merge` and `main`
is unchanged: merge base FS, one conflict (`docs/state.md`), `main` losing nothing of its own (§4d). **Not merged; the
designer plays it first.** No card, rune, engine, kit, pool or node moved.

## NEEDS A RULING — ONE, AND NOTHING WAITS ON IT

1. **THE DEBUG TOGGLE'S NAME: *"All Class Abilities Unlocked"* (PROPOSED).** The ruling is built (§3): the toggle
   grants the hero's class draft pool, and his lineage's zone-boss pool — the boss half is this batch's implementation
   call, stated so it can be ruled otherwise, because the boss pools were not merged. The name is the map burger's
   menu label; nothing keys on it, and the variable (`debug_grant_all`) and the sim flag (`DOD_SIM_GRANT_ALL`) never said
   *spec*. Confirm it, or name it.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `7d9905a` = `origin/class-merge` (read off the remote with `git ls-remote`) before anything moved; the tree clean but for the untracked `save-backups/` |
| 2 | *"HI split the fifty re-points by file and took 27 in 16 test files. These are the remaining 23 — the 8 gates, `test_batch_ah` and `test_run_harness`"* | **HELD** | HI §1's split table; `docs/state.md`'s HJ table lists twenty-three arms in exactly those ten files, and **all ten are byte-identical to HH's tree** (`git diff b05907c 7d9905a` on the ten is empty), so every line in the table was the line HH mapped — each was re-read at it before an edit |
| 3 | *"where BOTH BIG RE-DERIVATIONS SIT"* | **HELD** | `check_ea` ×4 with `:400` (and `check_dv:251`/`:260` beside them), and `check_do:475` with `check_dp:191`/`:200` — HI §1 and the state.md table's constraint 2 |
| 4 | *"When this lands, every assertion HA found is repaired or retired, and FP's six stages are done"* | **HELD FOR BOTH — AND HA NAMED A SECOND THING BETWEEN THE BRANCH AND READY, WHICH IS NOT ONE OF FP's SIX** | The tally is §4a (all 130 dispositioned) and the stages §4b. HA §3d's item 2 — *"the charter says there are no specs, and four layers still read one"* — is GK's RULED, NOT BUILT, not a stage of FP's running order: the rune half closed at HC §1, the boss pools stay lineage-keyed by GP's ruling, and the per-lineage stat block still stands (§4c) |
| 5 | *"HI found the population was 50, not 51 — `check_gn:208` was already among HH's 49"* | **HELD** | HI §0 row 3 |
| 6 | *"a new baseline row adds four checks, not two"* | **HELD, AND THIS BATCH ADDS NO ROW** | HI §7f: `check_de` runs all four per-row arms only for a target that has a row. HJ adds no target, so no row: `check_de`'s count moves by nothing from rows (§7) |
| 7 | *"HG found `check_fk:368`'s `ok(` line byte-identical to the day HA read it while HC had repaired it two batches earlier"* | **AS HH §0 ROW 5 CORRECTED IT — THIRD TIME IN A BRIEF** | HC came two batches after HA and four before HG; HI §0 row 7 recorded the same correction of the same phrase |
| 8 | *"`docs/state.md` carries the list and the method HI left"* | **HELD** | the HJ table and *THE METHOD, MEASURED AT HI* |
| 9 | *"a re-derivation that silently changes its own population is the shape `check_eb` had when it swept only each lineage's own shelf and missed a permanent Daze at Crushing Blow's price"* | **HELD** | GY's record: GU's `check_eb` §1 paired each lineage's shelf with that lineage's protected names alone, and Sweeping Strikes — *"keeps a 3-turn Daze permanently refreshed"* (DU §5) — sat in a zone-boss pool the sweep never read; GU §2 priced it at Crushing Blow |
| 10 | *"`test_run_harness` … is what the battery's own gates run through"* | **HELD IN THIS READING: IT *IS* THE BATTERY'S GATES 1/2/3** | `run_battery.sh` launches `test_run_harness.gd` three times under `DOD_GATE=1/2/3` and prints `GATE n`; no other target preloads or spawns it (`check_da` lists it among the hand-built boards; `test_batch_ah` and `test_batch_an` name it in comments only). The HJ arm is in GATE 2 |
| 11 | *"HI ran the defect the other way instead: HEAD red, the repair green"* | **HELD** | HI §3b, K12r and K14r |
| 12 | *"HI also found one that read green on both sides because the defect put nothing in play, and replaced it"* | **HELD** | HI §3a: K4, replaced by K4b |
| 13 | *"'All Spec Abilities Unlocked' still grants one lineage"* | **HELD** | `battle.gd`'s spawn granted `Classes.spec_pool(spec) + Classes.spec_draft_pool(spec)` under `spec != ""` — the lineage's boss pool and shelf, and nothing to a hero who took a spine |
| 14 | *"The one `test_batch_au` check that depends on it"* | **HELD** | the named-complaint arm (`au:986`–`:996`, thirteen checks); the other §5 arms — his own boss pool held, no sibling boss card his class cannot draft, the set non-empty — hold under either scope |
| 15 | *"It is a dev tool and no player sees it"* | **HELD** | the map burger's DEBUG section is drawn only under `Run.debug_enabled()` (dev build or `DOD_DEBUG=1`), and a sim reaches it only through `DOD_SIM_GRANT_ALL=1` |
| 16 | *"HH and HI both measured it: merge base FS, one conflict in `docs/state.md`, `main` losing nothing of its own"* | **HELD, AT HEAD AND ON HJ's TREE** | §4d |
| 17 | *"the Crown's Break and freeze resistance, Sanctity's potency layer, the engine cards, the class-wide rebalance, the sim bot's blind spot on the 29 returned cards, and HF's open rulings"* | **HELD** | each is in `docs/state.md`'s queue, untouched (§4e) |
| 18 | *"HI predicted 519 and read 521"* | **HELD** | HI §7f |
| 19 | *"`test_batch_an` drifts on random map generation — HI traced its whole spread to a line no batch touched"* | **HELD** | HI §7d: §1's `is not a rest` check, one per node of three freshly generated maps |
| 20 | *"The battery runs about 71 minutes"* | **HELD** | HI: 71 m 25 s, 71 m 15 s, 71 m 04 s; this batch's three in §7 |
| 21 | *"and the stamp"* | **`docs/master.html`'s `Last updated` IS BUMPED**, and `docs/state.md`'s *Last rewritten* | this batch edits `master.html`: the toggle's name and what it grants |

---

## §1 — THE TWENTY-THREE, RE-POINTED TO WHAT THEY WERE FOR

**Each was re-read at its line, with the lines that feed it, before it was edited** (HG §1b's rule) — all ten files
were byte-identical to HH's tree, so every line was the line HH mapped — and each carries a note at its site saying
what it asked and what it asks now. *(Lines after HJ's edits.)* **Widens / narrows** is said before each control was
armed (HI §3b's rule): a widening sees more defects than HEAD's copy; a narrowing calls fewer things a defect.

| arm (HEAD → now) | fires | what it asked | what it asks now | shape |
|---|---|---|---|---|
| `test_batch_ah:62` → 84 | 12 → 12 | each lineage *"opens with"* three (Holy four), off `spec_abilities` with the summons folded into one slot | each lineage **DEFINES** three cards of its own (Holy four) — GS made the table its definitions — and the companion calls it holds are **exactly the calls a card or rune can make** (`companion_call` over `COMPANION_KINDS` + `RUNE_COMPANION_KINDS`), grouped as the one pet card's (HB) | widens |
| `test_batch_ah:157` → 228 | 20 → 179 | no **class-wide shelf** card costs Mercy/Faith | over each class's **one pool**: a card that costs Mercy is a Mercy `ENGINE_READ` row | widens the population, narrows the defect |
| `test_batch_ah:160` → 234 | 20 → 179 | no class-wide card is a Beastmaster signature (summon, call_wild, kill_command) | over the pool: no card is a companion's call, and a companion's order is a `COMPANION_READ` row | widens and narrows |
| `test_batch_ah:163` → 240 | 20 → 179 | Hex of Ruin is not class-wide | Hex of Ruin is in **no class pool** — Wrath of the Old Gods' enabler travels with the engine | widens |
| `test_batch_ah:165` → 252 | 20 → 179 | no class-wide card is gated on a spec passive (a hand list of specials) | over the pool, each special AH named is withheld by the gate that should withhold it: Stabilize and Overcharge by Resonance's row, Primal Surge by Pack Bond's, Bestial Wrath and Spirit Bond by the pet gate; **Wildfire by nothing** — it reads Burn, which the Mage pool's own fire cards lay (GP: conditional on a card) | widens and narrows (HG's c5) |
| `test_batch_ah:324` → 447 | 1 → 1 | the award refuses a member *"with no spec"* | the award refuses a member who has **not chosen** (`awakened` false) **and pays a spine-taker who has**, with no spec — both in one check | widens |
| `test_batch_ah:326` → 450 | 1 → 1 | *"…and owes no pick"* | the un-awakened member owes nothing **and the spine-taker owes one** | widens |
| `test_run_harness:432` → 447 (GATE 2) | 1 → 1 | *"the un-awakened one did not"* bank — with his spec blanked, and no spine-taker ever seated | SPECS[1]'s hero takes the spine-taker's seat for the same bank (spec blanked, `awakened` set, restored after): the un-awakened hero's class stays at 2 **and the spine-taker's goes to 3** | widens |
| `check_ea:317` → 311 | 12 → 88 | the fallback floor ≥ 1 per LINEAGE SHELF | **per class × engine set**: the class pool as `offerable` filters it for the set, less the loadout that set leaves, less rune drain, ≥ 1 | re-derived (§1a) |
| `check_ea:332` → 316 | 12 → 88 | the full three over the pre-GP two-tier chain (shelf + class-wide shelf) | the same floor ≥ `awards` per seat — the chain is two tiers and the fallback is the last | re-derived |
| `check_ea:347` → 344 | 1 → 1 | no lineage's floor fills short | no **seat**'s floor fills short | re-derived |
| `check_ea:395` → 392 | 1 → 1 | lost awards off the per-lineage two-tier floor | lost awards over every seat and every lineage it could carry (boss cards not in the pool and offerable for the set) | re-derived |
| `check_ea:400` → 411 | 1 → 1 | 8 lineages can empty a boss pool, against the lineage's **own shelf** | against the **class pool** — a boss card drafted off a sibling's shelf empties it too | widens and narrows |
| `check_dv:251` → 258 | 1 → 1 | emptiable boss pools against the lineage's own shelf | against the class pool | widens and narrows |
| `check_dv:260` → 270 | 1 → 1 | Holy's boss cards not on the **Holy shelf** | not in the **Cleric pool** | widens and narrows |
| `check_eh:156` → 174 | 12 → 12 | the offer is three or everything the tier had, `left` counted over the raw pool; arm C holds the lineage's shelf — *the tier GP deleted* | `left` counts what the tier **can offer him** (`offerable`, his engines); **arm C is the last live tier nearly dry**: the boss pool and all but two of what the class tier can offer held, so it must pay, be announced, and offer those two | widens and narrows |
| `check_eh:213` → 268 | 12 → 88 | 12 lineages holding their boss pool and **own shelf** are paid three by the class tier | per class × engine set, a spine-taker (no lineage, awakened) whose **loadout is full of the cards the tier can offer him** is paid three, through the live roller | re-derived (§1a) |
| `check_do:475` → 531 | 3 → 25 | the `precision_ranks` read site gates on none of dazed/cripple/exposed, *"which the Swordmaster cannot guarantee"* | on **none of the 25 statuses some class cannot guarantee** (the one tree is worn by every class); Stunned, DP's own move, held by name **while no node writes the field** — asserted | re-derived (§1b), widens |
| `check_dp:191` → 200 | 1 → 1 | the sweep read nodes, through `generate_tree` per lineage | the sweep read the tree `Run.awaken` hands every hero (`Talents.tree()`), **once per class**, and all four classes | widens and narrows |
| `check_dp:200` → 210 | 1 → 1 | no node reads a status its **lineage** row lacks | no node reads a status its **class** row lacks | re-derived (§1b) |
| `check_dr:205` → 231 | 1 → 1 | `resurrection` is defined in the **Holy's table** | no class but the **Cleric** is handed a card carrying it — by pool, boss pools, kit or basic — **and its row names Mercy**; the defining table printed as the record | widens and narrows |
| `check_es:656` → 665 | 1 → 1 | a tagged swap card off the **Berserker's shelf** | off what the door **offers** him: `offerable(draft_pool(key), held)` | widens and narrows |
| `check_gn:216` → 245 | 24 → 24 | `ability_slots_used` of a member holding **no engine** == `lineage_slots + kit_slots` — the door's own two terms | with the engine **held**, the door == the slot-taking cards he **opens with** (`opening_kit` less the basic and the held engines' enablers); the kit's no-engine slots beside it, as GN wrote them | widens |

### §1a — THE FIRST RE-DERIVATION: THE AWARD FLOORS (`check_ea` ×5, `check_eh:213`, `check_dv` ×2)

| | derived FROM, until HJ | derived FROM, now |
|---|---|---|
| **the unit** | the twelve LINEAGES | every CLASS × every set of engines a hero of it can hold slotted: none, one of six, two — **22 a class, 88 in all** (`Gate.engine_sets`, written once in `gate_fixture.gd`) |
| **the pool** | the lineage's own shelf (EA's tier) and the class-wide shelf (EH's tier) | `Classes.draft_pool(class)` — **the pool the fallback reads** — as `Classes.offerable` filters it for the set |
| **the drain** | `cap − (lineage_slots + kit_slots(class, spec))`, **no engine** | `cap −` the fewest slots any lineage of the class opens using **with that set** (`kit_slots(class, lineage, set)` — Lethal Aim dismisses the pet and frees a slot) |
| **the rune drain** | granting runes whose card sits on the lineage's shelf / the class-wide shelf | granting runes a hero of the class can wear whose card the door **offers** for the set |
| **what it missed** | every sibling shelf he draws from, and the engine gate: a Holy's shelf alone carried seven cards a Cleric without Mercy is never offered | — |
| **what it reads** | the shelf floor 4 to 9, the shelf-plus-class-wide floor 8 to 14 | **floors of 20 to 44** — the thinnest seat a Cleric holding nothing (29 offered, 7 earnable, 2 drained) |

### §1b — THE SECOND RE-DERIVATION: THE GUARANTEED-STATUS TABLE (`check_do:475`, `check_dp:191`/`:200`)

| | derived FROM, until HJ | derived FROM, now |
|---|---|---|
| **the key** | the twelve LINEAGES | the four CLASSES — a node of the one tree is worn by every class that buys it (FX) |
| **a guarantee** | the lineage's PROTECTED CORE (its opening kit at DN — GS §1 put all but the enablers on the shelves), its PASSIVE (an engine rune since GK, droppable to nothing) and its TREE's nodes (all twelve trees deleted at FX: `bz_hemorrhage`, `wd_ricochet`, `dv_judgement`, `oc_emp_hex`) | only what EVERY hero of the class holds whatever engine he holds or drops: **his class basic and his class kit**, less the pet a dismisser loses |
| **the rows** | 12 rows, 24 guarantees (two lineages with none) | 4 rows, 10 guarantees — warrior: Sunder (Crushing Blow), Stunned (Pommel Strike), Mocked (Mocking Blow) · mage: Elemental Weakness (Magic Burst), Barrier (Nexus Ward) · cleric: Unburdened (Unburden), Consecration (Consecration) · hunter: Snared, and on its spring Stunned and Poison (Snare Trap) |
| **the witness** | none | a new §4 arm asserts every row names a card every hero of the class holds with no engine and with each engine alone; `check_gn` §1–§2 cast every kit card on a hero holding no engine and assert what each lays |
| **what it missed** | every guarantee it credited to a drafted card, a droppable engine or a deleted node | — |
| **what it reads** | 24 live pairs (tn_no_miss × 12 lineages), 0 new | **8 live pairs (tn_no_miss × 4 classes), 0 new** — the one tree reads no other status |

### §1c — EVERY NEGATIVE ANCHOR, PAIRED WITH A POSITIVE ARM (the brief's §6)

**The rule is FC §6's (`docs/instrument-rules.md`): an arm asserting that something is ABSENT from a window passes
over an empty window having asked nothing, so it is paired with an arm that fails when the window is not the one it
claims to be.** An implication — *a card that costs Mercy carries the Mercy row* — is the same shape one step along:
it passes over a population holding no card it applies to. Of the twenty-three, six assert an absence and three an
implication:

| arm | what it asserts | its positive arm |
|---|---|---|
| `test_batch_ah:234` | no pool card is a companion's call (absence); a companion's order carries its row (implication) | **NEW, `:260` and `:269`**: every class's pool walked whole, every name a card; the walk met a companion's order (Kill Command) |
| `test_batch_ah:240` | Hex of Ruin is in no pool (absence) | **NEW, `:260` and `:274`**: the window is the pool; Hex of Ruin resolves and is Wrath of the Old Gods' enabler |
| `test_batch_ah:228`, `:252` | a Mercy card carries the Mercy row; a gated special carries its gate (implications) | **NEW, `:269`**: the walk met Mercy cards (Divine Plea, Hymn of Hope, Resurrection) and an engine-gated one (Overcharge) |
| `check_ea:344`, `:392` | no seat fills short; no award is lost (absences) — and the floor arms `:311`/`:316` fire once a seat | **NEW, `:431`**: the seats walked are the arithmetic of the classes' engines, 88, counted without `Gate.engine_sets` |
| `check_do:531` | the `precision_ranks` read gates on no status some class cannot guarantee (absence, over the statement walk) | **`:543`, STRENGTHENED**: it asked the FILE for the Stunned read with a raw `contains`, which a comment satisfies; it asks the WALK too |
| `check_dp:210` | no node reads a status a class cannot guarantee (absence) | `:200`, HJ's own re-point: nodes read, and every class swept |

**TWO WALKS WERE UNPAIRED AND ONE WAS PAIRED TO THE WRONG THING, AND THE AUDIT THAT FOUND THEM CAME LATE — IT IS
RECORDED.** HJ's first pass wrote none of the four new arms. **`test_batch_ah`'s walk lost its positive half in the
re-point itself**: HEAD's class-wide loop carried two per-card arms (*"class draft … resolves"*, *"… resolves to its
own name"*) beside its absences, the four curation arms moved onto the class pool without them, and the new loop skips
a name that resolves to nothing. **`check_ea` counted its seats, printed them, and asserted nothing about them.** All
three were found by auditing against the brief's §6 while the pre-pass ran (§7f), after every document had been
written. They add four checks (`test_batch_ah` 6186 → 6189, `check_ea` 235 → 236) and change no other line a count
reads. **Every other arm among the twenty-three asserts an equality or a positive count, which an empty population
fails by itself**, and the three refusals — `test_batch_ah:447`/`:450` and the harness's bank — carry their positive
half in the same check: the spine-taker beside the refused member is paid.

---

## §2 — EVERY RE-POINT SHOWN TO BITE

**HD's rule, run over all twenty-three, with HI §3b's for the ones that narrow.** One defect per isolated copy of the
tree as landed (renamed in `project.godot`, its `user://` seeded from HJ's backup, `.git` left out because no control
target reads it); **two arms per copy**: NEW is the landed target, HEAD is HEAD's (`7d9905a`) copy of the same file
dropped into the same injected copy. **Read by the FAIL text, never the count** — a script prints, per control and
target, the FAIL lines only NEW printed and only HEAD printed, and every line below is one it printed. Each control
was stated FORWARD (a defect only the repair should see) or REVERSED (a defect only HEAD's copy calls one) before it
was armed, from §1's widens / narrows column.

### §2a — THE CONTROLS

| ctl | the defect | arm | NEW (the repaired arm) | HEAD's copy |
|---|---|---|---|---|
| **A1** | the award's fallback reads *has chosen* as *has a spec* (the pre-GK test) | `ah:447`, `:450` | red — *"refuses a member who has not chosen (true) and pays a spine-taker who has, with no spec (false)"*, and *"…the spine-taker one pick (0)"* | silent |
| **H1** | the zone-boss bank reads *has chosen* as *has a spec* | `harness:447` (GATE 2) | **GATE 2 FAIL** — *"the un-awakened one did not, and the spine-taker beside him did: got [2, 2], want [2, 3]"*, and the two checks around the seat | **GATE 2 PASS** |
| **A62** | a fifth companion call, *Summon Lupus*, defined in the Beastmaster's table — a call no card or rune can make | `ah:84` | red — *"beastmaster DEFINES 3 cards of its own, the pet card's calls as one (got 3; calls [… "Summon Lupus" …] against the [… four] a card or rune can make)"* | silent: its fold counted five summons as one slot |
| **A157f** | Resurrection's `ENGINE_READ` row deleted | `ah:228`, `check_dr:231` | red in both — *"Resurrection costs 1 Mercy and its offer row names '', not Mercy (the cleric pool)"*; *"Resurrection's offer row names '' (want 'mercy')"* | silent in both |
| **A160f** | Kill Command's `COMPANION_READ` row deleted | `ah:234` | red — *"Kill Command is a companion's signature a hero with no pet could be offered (the hunter pool)"* | silent |
| **A163f** | Hex of Ruin put on the Occultist's shelf | `ah:240` | red — *"Hex of Ruin is in the cleric pool — it travels with its engine and is drafted by nobody"* | silent: it read the class-wide shelf |
| **A165f** | Overcharge's `ENGINE_READ` row deleted | `ah:252` | red — *"Overcharge reads resonance and the gate does not withhold it (row '')"* | silent |
| **A157r** | Divine Plea (a Mercy row) authored on the Cleric class-wide shelf — **gated, so no defect** | `ah:228` | **silent** | red — *"Divine Plea costs no Mercy/Faith (class draft cleric)"* |
| **A160r** | Kill Command (a pet row) authored on the Hunter class-wide shelf | `ah:234` | **silent** | red — *"Kill Command is not a Beastmaster signature (class pool)"* |
| **A165r** | = HG's c5: Stabilize authored on the Mage class-wide shelf | `ah:252` | **silent** | red — *"Stabilize is not gated on a spec passive (class pool)"* |
| **E1f** | = HI's K1: every class's pool stops reading its lineage shelves | `check_ea:311`–`:392`, `check_eh:268` | red — all **176** floor checks (*"a warrior holding [] floors at -1 … (6 offered, 7 earnable)"*), the short-seat set, *"346 zone-boss awards can still pay nothing"*; and **all 88** of `check_eh`'s seats (*"is paid 0 cards, not three"*) | **silent on §1 and §2** — it counts the shelves itself, not the pool the fallback reads (both copies red on §4's pricing walk, identically) |
| **E1r** | the whole Warrior pool authored on the Berserker's shelf — **every card still in the one pool** | the same | **silent** | red, eight lines — *"warden's fallback pool floors at -7"*, the Swordmaster's, the short set, *"7 specs can empty a boss pool"*; *"berserker's class tier pays 0 cards … to a fully-held hero"*, *"only 11 of the twelve"* |
| **E2f** | War Stomp (a Warden boss card) on the Berserker's shelf | `check_ea:411`, `check_dv:258` | red in both — *"9 lineages can empty a boss pool"*; *"9 specs can be short of a full award set"* | silent: War Stomp is not on the Warden's own shelf |
| **E2r** | Immolate and Firestorm authored on the Cryomancer's shelf instead of the Pyromancer's | the same | **silent** | red in both — *"7 specs can empty a boss pool"* |
| **V260f** | Dawnbreak (a Holy boss card) on the Devout's shelf | `check_dv:270` | red — *"the Holy Cleric's boss cards no Cleric can draft are 1"* | silent |
| **V260r** | Divine Plea authored on the Devout's shelf instead of the Holy's | the same | **silent** | red — *"un-draftable boss cards are 3"*, and `:251`'s *"7 specs"* |
| **EH156f** | the class tier offers ONE card when fewer than three remain | `check_eh:174` | red, arm C — *"swordmaster was offered 1 cards out of a tier holding 2"*, and the other three | silent: its arm C left the tier nearly whole |
| **EH156r** | the fixture seats every lineage with NO engine (a hero who dropped his) | `check_eh:174` | **silent** — Shatter is gated, so the tier offers him two | red — *"§1A: cryomancer was offered 2 cards out of a tier holding 3"* |
| **D475f** | a second `precision_ranks` read, gated on Burn | `check_do:531` | red — *"gates on `burn`, which the warrior, mage, cleric, hunter cannot guarantee"* | silent: it asked dazed, cripple and exposed only |
| **P191f** | the tree `Run.awaken` hands every hero is empty; the lineage door still hands one | `check_dp:200` | red — *"§1 read 0 talent nodes across 0 of 4 classes"* | silent: it read `generate_tree` |
| **P191r** | the lineage door hands no tree; the tree every hero wears is whole | the same | **silent** | red — *"§1 read no talent node — `generate_tree` handed every spec an empty tree"* |
| **P200f** | a node reads Sunder (*"…10% less health damage from a Sundered foe"*) | `check_dp:210` | red — **mage, cleric, hunter**, whose kits lay no Sunder | red on **ten lineages, and not the Devout**, whose row credited Sunder to `dv_judgement` — a node FX deleted |
| **R1** | Resurrection put on the Arcanist's shelf — a second class handed revival | `check_dr:231` | red — *"the classes handed a card carrying it are ["mage", "cleric"]"* | silent: the definition still sits in the Holy's table |
| **R3** | Resurrection's definition moved from the Holy's table to the Devout's — **still the Cleric's, still a Mercy row** | the same | **silent** | red — *"`resurrection` belongs to 'inquisitor', not 'holy'"* |
| **S1** | the offer door withholds everything from a hero holding no engine | `check_es:665` | red — *"no tagged card the berserker's draft offer could hold to swap (0 offered)"* | silent: it took the card off the shelf |
| **S2** | the Berserker's shelf authored onto the Warden's — every card still in the one pool | the same | **silent** | red — *"no tagged card in the berserker draft pool to swap"* |
| **G1** | the slot door stops reading the engines he holds | `check_gn:245` | red — *"lethal_aim, engine held, opens at 2 of 7 slots and the door counts 3"* | silent: it asked with no engine, where the two agree |

**Every forward control put the repaired arm red and left HEAD's copy of it silent, and every reversed control put
HEAD's copy red and left the repaired arm silent**, each by its own FAIL line; the other red lines in a log are printed
by both arms identically, which is what the per-line comparison exists to show. **P200f is the one control where both
arms red on the same defect, by construction**: every status the one tree could read is missing from SOME lineage's
old row, so HEAD's arm reds on any bet — and what the re-key changes is WHO is weighed. The per-line text is the
control: HEAD's copy names ten lineages and is silent on the Devout, whose row credited a deleted node, which is the
`check_eb` shape the brief named.

### §2b — WHICH ARMS NEEDED THE REVERSED CONTROL, AND WHY

HI §3b's rule: a widening takes HD's two arms; a narrowing takes the forward control and the reversed one. **Fourteen
of the twenty-three narrow as well as widen**, because the merge moved the unit from a lineage's shelf to the class's
one pool, and a card moved between two shelves of one class — or a gated card sitting in the pool — is a defect only
to the old arm: `ah:157`, `:160` and `:165` (A157r, A160r, A165r), `check_ea:317`, `:332` and `:347` and
`check_eh:213` (E1r), `check_ea:400` and `check_dv:251` (E2r), `check_dv:260` (V260r), `check_eh:156` (EH156r),
`check_dp:191` (P191r), `check_dr:205` (R3) and `check_es:656` (S2). **Each also took its forward control**, so every
one of them was shown both halves. **Nine widen only, and HD's two arms were enough**: `ah:62`, `:163`, `:324` and
`:326`, the harness's arm, `check_do:475`, `check_gn:216` and `check_ea:395` — the old lost-award count cannot be
reddened by moving cards between shelves, because a lineage's boss cards all read "safe" against a shelf that has been
emptied — and `check_dp:200`, the per-line case above.

### §2c — WHAT IT COST, AND THE ONE CONTROL RUN AGAIN

**Twenty-eight controls — the twenty-seven above and the parse floor's arm (§7b) — took 74 Godot runs with 0
unintended throws** (the parse arm's two are its point), **from 12:09:50 to 12:20:59**, beside the reconnaissance
battery, and every injection's anchor was count-checked and its text re-read from disk first.

**ONE CONTROL WAS CONFOUNDED AS FIRST RUN, AND IT IS RECORDED.** `check_dp` reads its status table out of
`check_do.gd`'s constants, so P200f's HEAD arm — HEAD's `check_dp` dropped into the injected copy — read the NEW
class-keyed table and named all twelve lineages. **Run again with HEAD's `check_do.gd` beside HEAD's `check_dp`**, it
reads as above. A target that loads another file's constants owes its HEAD arm both files. (A157f was also run a second
time, so the record carries `check_dr`'s reworded FAIL message; its reading did not change.)

### §2d — THE PAIRING ARMS, EACH SHOWN TO BITE

**Six more controls, one per new condition, run as the twenty-seven were** (one defect per isolated copy, NEW and
HEAD's copy in it, read by FAIL text): **12 Godot runs, 0 throws, 13:09:44 to 13:11:59**, beside the pre-pass while it
was in its suites and nowhere near `check_gp` (§6). All six injections were dry-run on text-only copies first.

| ctl | the defect | arm | NEW | HEAD's copy |
|---|---|---|---|---|
| **AHW1** | the Mage's pool reads empty | `ah:260`, `:269` | red — *"the class-pool walk above read an empty pool for ["mage"] and skipped []…"*, and *"…met no engine- or pet-gated card…"* (Overcharge left with the pool) | silent |
| **AHW2** | a shelf names a card that resolves to nothing (*"Unwritten Card"*, on the Arcanist's) | `ah:260` | red — *"…read an empty pool for [] and skipped ["Unwritten Card (mage)"], which resolve to no card…"* | silent |
| **AHM** | no pool card costs Mercy (the Holy's three taken off her shelf) | `ah:269` | red — *"the class-pool walk met no Mercy card, so the arm conditional on it above asked nothing"* | silent |
| **AHX** | Hex of Ruin renamed out of the game | `ah:274` | red — *"Hex of Ruin is no longer Wrath of the Old Gods' enabler, so the arm above keeping it out of every pool asserts the absence of nothing"* | **silent — HEAD's own *"Hex of Ruin stays Occultist-only"* read green in a game holding no Hex of Ruin**: the unpaired absence, exactly |
| **EAS** | the seat enumeration collapses to the no-engine seat | `check_ea:431` | red — *"the floors above seated 4 class × engine-set heroes, not the 88 the classes' engines make…"* | silent — it walks no seats |
| **DOW** | the precision read moves to Dazed, and a comment keeps the Stunned text | `check_do:543` | red — *"…or the statement walk above did not find it there (2 reads found, gating on ["dazed"])"*; and `:531`, on Dazed | **its pin silent** — the comment satisfied the raw `contains`; its precision arm red, on Dazed, for the Swordmaster |

**On the first five, every other arm in the NEW log read green** — the four curation arms had nothing to fail on, and
the floors passed on four seats — so within its target each defect was seen by the new arm or by nothing. **On DOW the
absence arm reds by itself**, on Dazed; what the strengthened pin adds is that its positive half no longer passes off
a comment.

---

## §3 — THE DEBUG TOGGLE GRANTS THE CLASS POOL

**Ruled by the designer, and built.** The map burger's pre-grant toggle (`Run.debug_grant_all`) handed a hero his
LINEAGE's boss pool and his lineage's SHELF — `Classes.spec_pool(spec) + Classes.spec_draft_pool(spec)` — and nothing
at all to a hero who took a spine, whose `spec` is empty. Under one pool a class a hero drafts every shelf of his
class, so the aid granted less than a hero can hold.

- **WHAT IT GRANTS NOW** (`scripts/battle.gd`, the spawn): every card of the hero's CLASS's one draft pool
  (`Classes.draft_pool(key)`), whatever lineage he took and whether he took one at all, and **his lineage's zone-boss
  pool** as before. **The boss half is an implementation call, stated so it can be ruled otherwise**: the boss pools
  were not merged (GP's ruling), so the one a hero can earn from is still his lineage's, and dropping it would make
  the toggle grant less than it did. A sibling's boss card his class pool does not hold stays out — the one thing
  AU §5's complaint was ever right about, and `test_batch_au`'s arm at `:980` still asks it.
- **THE GATES ARE NOT ASKED, ON PURPOSE.** The engine and pet gates are the OFFER's (`Classes.offerable`); a card that
  reads an engine the hero does not hold is granted and refused on its own button, which is what the game does with
  such a card, so an "all unlocked" aid shows the tester what a player would meet. A Sharpshooter holding Lethal Aim
  is granted the companion cards and cannot cast them, for the same reason.
- **THE STALE COMMENTS ARE CORRECTED**, four of them: the grant site's (*"the class-wide draft pool is excluded for
  exactly AU §5's reason, and is empty today besides"*), a second one fifty lines above it that still described the
  aid as *"this const"* from Batch 31, `run_state.gd`'s note on the variable (*"every talent/trophy ability"*), and
  the map burger's note on its toast (AU §5's *"their OWN spec's kit only"*). The toast itself now says what is
  granted.
- **THE NAME — PROPOSED: *"All Class Abilities Unlocked"*.** Off the word *Spec*, and the smallest change that says what
  it does: the class pool is the ruled scope, and the one lineage-keyed half it keeps — the boss pool — is still one of
  the class's own.
  It is the menu item's label and nothing keys on it; the variable (`debug_grant_all`) and the sim flag
  (`DOD_SIM_GRANT_ALL`) never said *spec* and are unchanged. **The designer confirms** (NEEDS A RULING).
- **`test_batch_au`'s named-complaint arm FOLLOWS THE RULING** (`au:1004`–`:1018`, thirteen checks, one for one): of
  the thirteen Pyromancer and Cryomancer cards it names, the eleven on a Mage shelf are the Arcanist's own pool and he
  now HOLDS each; the two that are not — Flamewave and Razor Ice, Overburn's and Permafrost's enablers, in no pool —
  travel with their engines, and an Arcanist holding Resonance holds neither. Which side each name is asked is read
  off `Classes.draft_pool`, not listed. **181 / 0 on the new tree, 181 before**; HEAD's copy of the arm on the new
  grant reds on exactly the eleven (HI's K14r measured it, and HJ's ok() trace ran HEAD's copy on this tree: 181 / 11, §7d).
- **`docs/master.html`** describes the toggle by its new name and scope, and the stamp is HJ's; **`CLAUDE.md`'s DEBUG
  SURFACES table** carries the new row, marked as ruled and the name as proposed.

## §4 — WHAT THIS CLOSES

### §4a — EVERY ASSERTION HA FOUND: ALL 130, DISPOSITIONED

HA §1d found **130 arms in 42 targets** still asking the pre-merge game's questions. Every one is repaired, folded or
retired, and none is left open:

| | arms | where | how |
|---|---|---|---|
| **tier 1, the holes** | **20** | HD | **16 repaired, 4 retired** (HD's own figures, HG §0 row 3) |
| **the FOLD family** | **35** | HD §3 | every per-shelf and class-wide-shelf floor folded onto `Fixture.class_pool_floors`, verified gone at HG §1a (HD folded a thirty-sixth HA had not listed, `test_batch_bq:204`) |
| **`test_batch_bq:344`, `:349`** | **2** | HD §1b | retired by ruling (the class-wide cards' "weaker" rule) |
| **already done before HG's sort** | **3** | HB (2), HC (1) | `check_dr:126` and `test_batch_bo:437` re-pointed at HB, `check_fk:368` at HC §1 (HG §1c) |
| **HG's seventy, sorted 48 / 5 / 17** | **70** | HH, HI, HJ | **HH retired 21** (5 subject-gone, 16 superseded) and found the 22nd vacuous (`bw:417`), which went to the re-points; **HI re-pointed 26 of them** (its 27th, `test_batch_cd`'s class-wide floor, was never in HA's census — the ruled fiftieth); **HJ re-pointed the last 23** |
| **total** | **130** | | **68 repaired or re-pointed · 35 folded · 27 retired** |

**The 68 / 35 / 27 happens to equal HA's action column in total, and not arm for arm**: HD, for one, repaired
sixteen holes and retired four where HA's column marked thirteen and seven. Each batch's report carries its own arms.
**Two arms of the same shapes were never in HA's census and are not in the 130**: HD's thirty-sixth fold
(`test_batch_bq:204`) and HI's ruled fiftieth (`test_batch_cd`'s class-wide shelf floor), both folded.

**AND HA's TEN PRE-MERGE PRINTS** (*"not asserted, not counted as arms"*): `test_batch_cd:425` moved with HI's
re-point; `check_ea:256`, `:302`, `:390` and `:401` are §1's own table and were re-derived with it here, and so were
`check_do:451` (§4's report, re-keyed by class) and `check_eh:226` (§2's print, re-worded); `check_dp:376` (§5's
*"draftable by"*) names the class whose pool holds a rune-granted card now, a print only. **`check_dn`'s two
(`:327`, `:402`) stand**: `check_dn` is launched by nothing (HA §1e) and asserts nothing; named, not touched.

### §4b — FP's SIX STAGES: ALL DONE

| stage (FP's running order, `docs/state.md`) | done at |
|---|---|
| 1 — **the spines**, on nobody | **FT** (built), **FU** (Channel's rate), **FV** (Momentum's and Sanctity's) |
| 2 — **the talent layer** | **FX**: one tree of twenty-seven, bought per class |
| 3 — **engines to runes**, each with its enabler | **GK** (the fifteen as runes), **GO** (the nine rule engines, six a class), **GS** (an engine brings only what it cannot run without); the class kit at **GN** |
| 4 — **the pools** | **GP**: one draft pool a class |
| 5 — **the engine-reading runes and cards** | the cards at **GP**, the runes at **GV**; the rune scope made the class at **HC** |
| 6 — **the gates** | censused at **HA**; **HD** (the holes and the fold), **HG** (derived and sorted), **HH** (retirements), **HI** (27 re-points and `check_hi`), **HJ** (the last 23) |

### §4c — AND THE ONE THING HA NAMED BESIDE THE GATES, WHICH IS NOT A STAGE

HA §3d said two things stood between the branch and READY: the middle group (closed above) and **"the charter says
there are no specs, and four layers still read one"** — GK's RULED, NOT BUILT. **Where the four stand today:** the
spec-scoped runes are class-scoped since **HC §1**; the lineage opening is its engine's enablers alone since **GS**,
which is the charter's own shape; **the zone-boss pools stay lineage-keyed by GP's ruling** (*"the merge joined the
draft's two, not the game's three"*); and **the per-lineage stat block still stands** (`Classes.apply_spec_stats`, read
at the spawn and on the hero sheet). `CLAUDE.md` still marks *there are no specs* RULED, NOT BUILT. **HA left the
timing to the designer** (*"whether the lineage layers merge before landing or after is the designer's"*), and it is
not in the brief's list of merge work or of the queue, so it is reported here rather than decided.

### §4d — WHAT STANDS BETWEEN `class-merge` AND `main`: UNCHANGED

**Measured at HEAD before anything moved, and again on HJ's own tree without touching a ref, the index or the working
tree** (HH's and HI's method): a temporary index takes HEAD and HJ's twenty-four changed and new files, a commit object
is written with no ref, and `git merge-tree` merges it with `main`.

| | at HEAD (before HJ moved anything) | on HJ's tree (the probe) |
|---|---|---|
| merge base | `3b80fbe` (FS) | `3b80fbe` (FS) |
| commits on `class-merge` only | 42 | 43 (HJ's probe the forty-third) |
| commits on `main` only | 2 (GG's and GI's, documents only) | 2 |
| conflicts | one: `docs/state.md` | one: `docs/state.md` |
| the merged tree against the branch's | `docs/state.md` alone | `docs/state.md` alone |
| `main`'s own changes since the base | `docs/state.md` alone | `docs/state.md` alone |

**So `main` loses nothing of its own**: the only file it changed since the base is the one file that conflicts, and
`docs/ways-of-working.md` already rules that one (*"take the branch's wholesale"*). HEAD named the same commit and the
index hashed the same, before and after, and the probe matched the working files blob for blob (24 of 24). **Not
merged**; `main` = `origin/main` = `b722cc4`, read off the remote with `git ls-remote`, untouched.

### §4e — ON THE BRANCH AND NOT MERGE WORK: THE QUEUE, NOT BLOCKERS

Each is in `docs/state.md`'s queue and untouched here: **the Crown's Break and freeze resistance** (GN's brief named it
the batch after the kits); **Sanctity's status-potency layer** (FT onward — the largest unbuilt system the recon
found); **the engine-card texts** (GQ's rulings 1 and 2); **the class-wide rebalance** (GP's ruling 1 — the rule that
made those cards weaker is retired at HD §1, the rebalance is still owed); **the sim bot's blind spot on the
twenty-nine returned cards** (GS: the drafted hook casts only what `Classes.draft_ability` resolves, and none of the
twenty-nine is defined there); and **HF's five open rulings** (Burning Ground's burn, Aper's body and boon, Abundance's
shield, Mark of the Hunt's text, Kill Command's order for Aper). And the sanctioned `check_gj` red (the victory card
leaves out the Tollkeeper's Bell's 20 gold) rides the branch as known debt, as HA §3d said.

---

## §5 — WHAT WAS DELIBERATELY NOT DONE

- **No rune, engine, card, kit, pool or node changed.** Under `scripts/` the only edits are §3's: the grant in
  `battle.gd`'s spawn, the toggle's label and toast in `map_screen.gd`, and four comments (two in `battle.gd`, one
  each in `map_screen.gd` and `run_state.gd`). Nothing under `data/` moved.
- **The `precision_ranks` read site is not moved.** Under the class table it gates on Stunned, which the Mage and the
  Cleric cannot guarantee (§6); it is game code, the field is dormant, and the gate holds the read by name for exactly
  as long as no node writes the field.
- **No merge to `main`**, and `main` is untouched (`b722cc4` = `origin/main`, read off the remote).
- **HF's five open rulings stay open**, and the queue the brief names stands (§4e).
- **HA §3d's lineage layers are not touched** — the per-lineage stat block and the lineage-keyed zone-boss pools (§4c).
- **`check_dn`'s two pre-merge prints stand**: the gate is launched by nothing and asserts nothing.
- **The `.docx` exports are not rebuilt** (ruled at FG).

## §6 — FOUND AND NOT FIXED

- **THE `precision_ranks` READ SITE IS A LATENT BET FOR TWO CLASSES.** DP moved the Swordmaster's old node's payout onto
  Stunned because his opening kit laid it. Under the one tree a node that writes the field again is worn by every class
  that buys it, and only the Warrior's kit (Pommel Strike) and the Hunter's (Snare Trap, on its spring) lay a Stun.
  **Nothing pays it today** — no node writes the field, which `check_do` §4 now asserts — and the day one does, the arm
  reds on Stunned for the Mage and the Cleric.
- **`check_gp` RUNS WITHIN NINE SECONDS OF ITS WATCHDOG.** It carries no bound of its own in `run_battery.sh`, so it
  runs under the 240 s default, and HI's acceptance log shows it taking **231 s**; it read 224 s in HJ's standalone
  run beside the reconnaissance battery, and **232 s, 231 s and 231 s in HJ's three batteries** — the reconnaissance,
  the pre-pass and the acceptance run, off their log times. A slower machine, or a heavier load beside a battery, cuts
  it off as TIMED OUT — and a cut-off gate reads like a hung one. HJ ran nothing beside the batteries while they were
  in it. A bound of its own, the shape `check_fx` and `check_gv` have, is a runner edit and not this batch's.
- **THIRTY-NINE ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named *"Dawn of Decay
  HJ …"*: the probe and working copies (*"head"*, *"work"*), the reconnaissance battery (*"recon"*), the thirty-four
  controls (*"ctl A1"* to *"ctl PARSE"*, and §2d's six, *"ctl AHW1"* to *"ctl DOW"*; P200f's and A157f's second runs
  reused their own), the ok() trace (*"trace"*, both runs) and the pre-pass (*"prepass"*). **There are 374 such
  folders now**, counting every folder there but the live game's own. This batch's backup is
  `../save-backups/HJ-20260925-110132`. They hold nothing a player needs and can be deleted.

---

## §7 — VERIFICATION

*Written before the pre-pass and the acceptance run, per the brief's §6; the figures only the runs can give are filled
after them.*

### §7a — THE PLAYER'S FILES, FIRST

Backed up to `../save-backups/HJ-20260925-110132` before anything ran, and verified by md5 byte-identical to the live
folder: `profile.json` `16ed50e8…`, `relics.json` `fdc12ffa…`, `run_save.bin` `3a5d953a…`, `settings.cfg` `0c1b39c3…`.
**Two of the four moved since HI's backup** (`profile.json` and `run_save.bin`, written at 10:57–10:58 today, before
this session began — the designer played), so HJ's backup is the reference, not HI's. **After both runs, and after
everything else this batch ran, the four are byte-identical to the backup again**: the same four sums, off the live
folder — the acceptance run, the one that plays in the live game's own `user://`, included.

### §7b — THE INSTRUMENTS, EACH SHOWN TO BITE

- **The parse floor.** Every log is grepped for `Parse Error` and `SCRIPT ERROR` — never a tally, never an exit code.
  **Armed first**: control PARSE left an expression off an assignment in an isolated copy of
  `check_ea` — the run printed *"SCRIPT ERROR: Parse Error: Expected expression for variable initial value after
  "="."* and **no verdict line at all**, while HEAD's copy in the same injected copy read 83 / 0. Across all 86
  control runs (§2c's 74 and §2d's 12) that is the one log carrying a parse error.
- **The ok() trace** (HI's `trace_ok.py`): in an isolated copy every `ok(` call site in the eleven edited ok()-targets
  is rewritten to print its own line, line numbers kept; HEAD's copies traced in the same copy. **Its self-check is
  the ledger**: in every traced run the fires sum to the count the target printed — **22 of 22 exactly**, HEAD's
  eleven and HJ's eleven, on the landed tree and again after §1c's arms. **Its bite is the moved lines themselves**:
  every line whose fires changed is one of the twenty-three or the companion arm beside it (§7d).
- **The harness needs no trace: it prints every check by label.** GATE 1 and GATE 3 print byte-identical check lines on
  HEAD and on HJ's tree (22 and 8); **GATE 2 differs in exactly one line of 382, the re-pointed arm** —
  *"the un-awakened one did not (2)"* became *"the un-awakened one did not, and the spine-taker beside him did ([2,
  3])"*. Every other label and every other value is the same, so the repair changed nothing else the harness reports.
- **The injections.** Every anchor is count-checked, the file re-read and the injected text asserted present (and, for
  a deleted row, absent); **all 27, and §2d's six, were dry-run on a text-only copy before any control ran**, and the
  pool-list parser was proved against the probe's live pool data — every shelf and every class-wide shelf read back
  exactly (0 of 16 mismatched).
- **The row move.** `baselines.json` is edited as text, so its indent-1 layout stands: **five rows** (two of them
  moved again for §1c's arms), and the file parses equal to HEAD's except those rows' `checks`, `checks_obs` and
  `note`. numstat **17 / 17**.

### §7c — HEAD's UNMODIFIED GATES AGAINST THE NEW TREE, BEFORE ANY GATE WAS EDITED

**HEAD's gates ran unmodified against the new tree** — §3's grant, label and comments, and `test_batch_au`'s re-point;
every gate, `test_batch_ah` and the harness HEAD's — in an isolated copy (*"Dawn of Decay HJ recon"*, its `user://`
seeded from the backup): **11:14:31 to 12:25:27, 70 min 56 s**. **The prediction was written at 11:14:22, nine seconds
before the launch** (checked by the file's mtime against the runner's `START`): no gate or suite but `test_batch_au`
reads `debug_grant_all` (a grep over every root `.gd`), no pin in `pin-manifest.json` names the moved `scripts/` text
(0 of 1,519), so every target should read HI's row and `check_de` 521 / 0 / 0.

**It read exactly that.** 126 of 126 launched, one ascending sequence with no duplicate, the same target list as HI's
acceptance run; **none of the 126 logs holds a `Parse Error` or a `SCRIPT ERROR`** (grepped per log); every target on
its HI row, **and every target's count and failures identical to HI's acceptance reading but `test_batch_an`**, which
read 6054 against 6055 — its known drift, inside its band; the harness **22 / 382 / 8** with no throw; the two
sanctioned reds at their counts and their text — `check_cm_live` 13 / 4, and `check_gj` 70 / 1 with *"+167 gold and the
purse moved 187"*; **`check_de` 521 checks / 0 failures / 0 notices.** **So no unmodified gate depends on the scope of
the debug grant, and nothing the brief did not name went red.** The gates were edited in the repository after the
recon copy was taken; the copy is what the recon read.

**AND THE LITERAL SWEEP OVER §3's EDITS FOUND NO PIN.** Every string literal of four characters or more in every root
`.gd`, at HEAD and in the tree, searched in HEAD's and the edited `battle.gd`, `map_screen.gd` and `run_state.gd`: seven
needles left `battle.gd`, and every one is a comment's (the grant's old comment named `CLASS_POOLS` and the shelf
accessor) or a needle no reader asks of that file (`check_gp` asserts `spec_draft_pool` ABSENT from a different body).

### §7d — THE COUNT, ATTRIBUTED LINE BY LINE

**An ok() trace of the eleven edited ok()-targets beside HEAD's copies of them, in one isolated copy** (*"Dawn of Decay
HJ trace"*), HEAD's lines mapped onto HJ's through a diff of the two sources, **run again after §1c's arms**.
**TOTAL 6,556 → 7,449 (+893)** — it read 7,445 (+889) before them — and every line whose fires moved is a re-pointed
arm, the companion arm beside it, or a pairing arm:

| target | HEAD → HJ | the lines that moved |
|---|---|---|
| `test_batch_ah` | 5550 → 6189 (+639) | `:62` → `:84` 12 → 12; `:157`/`:160`/`:163`/`:165` 20 each → `:228`/`:234`/`:240`/`:252` **179 each**; `:260`, `:269`, `:274` **1 each, new** (§1c); `:324`/`:326` → `:447`/`:450` 1 → 1 |
| `check_ea` | 83 → 236 (+153) | `:317`/`:332` 12 each → `:311`/`:316` **88 each**; `:347` → `:344` 1 → 1; `:431` **1, new** (§1c) (`:395` and `:400` read byte-identical, their re-point in the lines above them) |
| `check_eh` | 153 → 229 (+76) | `:213` 12 → `:268` **88**; the tally beside it, `:228` → `:273`, 1 → 1 (`:156` byte-identical, fires 12: its re-point is in `left` and arm C's seat) |
| `check_do` | 86 → 112 (+26) | `:475` 3 → `:531` **25**; `:481` **4**, new — the table's own population; `:478` → `:543` 1 → 1, the pin now asking the walk too (§1c) |
| `check_da` | 42 → 41 (−1) | `:354`, the exempt-list arm, 5 → 4: `check_ea` left `WALK_EXEMPT` |
| `check_dp` | 32 → 32 | `:191` → `:200` 1 → 1; `:160` → `:161` 1 → 1 (the loaded-table guard, its local renamed) |
| `check_dr`, `check_es`, `check_gn` | 84, 57, 204 — unchanged | `:205` → `:231`, `:656` → `:665`, `:216` → `:245`, one for one |
| `check_dv` | 84 → 84 | **no line moved**: both arms' `ok(` lines are byte-identical, and the re-point is in the lines that feed them — HG §1b's shape, which a line check would have called untouched |
| `test_batch_au` | 181 → 181 | the named arm's two lines (8 and 5 fires) became four (7 held, 1 not; 4 held, 1 not) |

**HEAD's `test_batch_au` on the new grant read 181 / 11**, on exactly the eleven Mage-pool cards it names — HI's K14r,
now the game, and the reason the arm follows the ruling.

### §7e — AFTER THE DOCUMENTS LANDED: THE READERS OF WHAT MOVED

**Every reader of a document HJ changed, with every target HJ edited and the gates that read the sources whole —
twice.** Forty-one targets open `CLAUDE.md`, the changelog, the design notes, `state.md` or `master.html` by their
`res://` paths — a grep over every root `.gd`, drawn again after the documents landed, and the same forty-one — and to
them were added the edited targets that open none of those (`check_ea`, `check_gn`, `check_da`, `test_batch_au` and
the harness's three gates), the census gates (`check_ek`, `check_dw`, `check_gw`), the manifest's reader `check_ed`,
`check_hi`, `check_parse` and `check_gs`: fifty-five targets, and every root walker of the gates' own sources is among
them. **First on the landed tree, 12:33:34 to 12:50:29; then again after §1c's arms and the documents' last edits, in
two parts so that no Godot run stood beside the pre-pass while it was in `check_gp` (§6) — 13:20:21 to 13:27:17, and
13:48:34 to 13:58:34.** Both times in an isolated copy of the tree (*"Dawn of Decay HJ work"*), proved against the
tree before the run (489 files, only `project.godot` differing, by its rename): **every one of the fifty-five on its
landed row, 0 throws, and none of the logs holds a `Parse Error` or a `SCRIPT ERROR`** (grepped per log). Proved again
after the second run, the copy differed from the tree in this report and in `state.md` alone — the pairing sentence in
its WHERE block reworded and re-wrapped while part one ran — and that difference is 0 needles LOST, 0 GAINED, and
`check_es`'s window census identical (the sweep below). `check_ed` reads 18 / 0; `check_fg` reads `CLAUDE.md` at
389,760 B = 380.62 KiB, 29.38 KiB under its 410 KiB ceiling, and the changelog at 184,582 B against its 400 KB bar.

- **The literal sweep over every file that differs from HEAD** — the 15,644 string literals of four characters or
  more in every root `.gd`, at HEAD and in the tree, searched in each of the twenty-four changed files and in its HEAD
  blob, raw and whitespace-flattened. The design notes, `master.html` and `pin-manifest.json` LOST and GAINED none.
  `CLAUDE.md` GAINED two, `CLASS pool` (`check_eh`'s) and `Overcharge` (`check_do`'s, among five owners); the
  changelog GAINED `ABSENT` (`check_ec`'s); `baselines.json` GAINED `precision_ranks` and `companion's order`;
  `state.md` LOST `resurrect` and `resurrection` and GAINED `GUARANTEED_STATUS`, `STUNNED`, `Stunned`,
  `scripts/battle.gd` and `scripts/map_screen.gd`. **No reader of any of those documents asserts one of them**:
  `check_eh` does not open `CLAUDE.md`; `check_do` does, and asks it for two sentences of the talent rule and nothing
  else (its `Overcharge` is a key of its card-to-rune table); `check_ec` opens the changelog, and its `ABSENT` is a
  word of its own FAIL message; `check_de`, the one reader of `baselines.json`, owns neither of its two; and none of
  `state.md`'s seven is `check_es`'s, the one gate that opens it.
- **And every document edit made after the pre-pass copy was taken — the pairing sentences, the counts, the
  re-wraps — was swept again, the pre-pass copy's text against the tree's**, and **`check_es`'s own read of
  `state.md` was reproduced**: it matches a regex window (`2\+ threshold`, whitespace-flattened, then `TAG for <word>`
  inside it), which a literal sweep cannot see. Both copies read two windows and the same four pairs; the literal
  sweep reads 0 LOST and 0 GAINED on `state.md` and the design notes, and on the changelog only the `ABSENT` above.
  **Both instruments were armed first**, on a scratch copy of `state.md`: one of `check_es`'s own literals broken by
  one character's case was reported LOST, and a claim injected into a window made it three.
- **The pin manifest, regenerated** (again after §1c's arms): 1,519 pins, and on every field but the gate line they
  are HEAD's 1,519 exactly; 35 of them, on 34 lines, sit at a moved line of the same gate, and the residency census is
  HEAD's to the pin (693 in code, 40 in a comment only, 306 absent by design, 82 composed at runtime, 40 narrow, 3 on
  a sibling, 1 unresolved, HEAD's). `--check` reads it current.
- **The merge, measured on this tree** (§4d): unchanged.

### §7f — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass** — the full battery in an isolated copy of the tree as it stood before §1c's arms (*"Dawn of Decay HJ
prepass"*, proved file for file before the run: 489 files, only `project.godot` differing, by its rename; and after
it, when the copy had gained no file), its `user://` seeded from the backup: **12:53:12 to 14:04:23, 71 min 11 s.**
126 of 126 launched, one sequence with no duplicate, and none of the 126 logs holds a `Parse Error` or a `SCRIPT
ERROR` (grepped per log); every target on its row in that copy — `test_batch_ah` 6186, `check_ea` 235, `check_eh` 229,
`check_do` 112, `check_da` 41 — and `test_batch_an` at 6054; the two sanctioned reds at their counts, `check_cm_live`
13 / 4 and `check_gj` 70 / 1 with *"+167 gold and the purse moved 187"*; the harness 22 / 382 / 8 with no throw.
**`check_de` read 521 checks / 0 failures / 0 notices — its prediction exactly**, written at 12:34, with an addendum at
12:53:11, a second before the launch, recording the readers pre-check and the copy's proof and changing no figure.

**§1c's ARMS LANDED WHILE IT RAN, SO WHAT THEY MOVED WAS PROVED BEFORE THE ACCEPTANCE RUN, NOT ASSUMED.** Between the
pre-pass's copy and the final tree nine files differ — `test_batch_ah.gd`, `check_ea.gd`, `check_do.gd`,
`baselines.json`, `pin-manifest.json`, the changelog, the design notes, `state.md` and this report — and every target
that reads one of them is among §7e's fifty-five, which read the final tree on its final rows. **`check_de` was then
run standalone over the pre-pass's logs with those fifty-five substituted, against the final `baselines.json`:
521 / 0 / 0.**

**The acceptance run, in the repository, frozen**: every file on disk under the repo but `.git/`, `.godot/` and the
untracked `save-backups/`, on absolute paths — this report among them — hashed before and after: **489 files, and NOT
ONE MOVED.** **14:05:09 to 15:16:11, 71 min 02 s**; the prediction was written at 14:04:59, ten seconds before the launch.
126 of 126 launched and none of the 126 logs holds a `Parse Error` or a `SCRIPT ERROR`; every target on its landed row
— `test_batch_ah` 6189, `check_ea` 236, `check_eh` 229, `check_do` 112, `check_da` 41 — and `test_batch_an` at 6053;
the sanctioned reds at their counts, with the same text; the harness PASS at 22 / 382 / 8. **`check_de` read 521 checks
/ 0 failures / 0 notices — the prediction exactly.** Nothing in the tree was edited from the before-hash to the
after-hash; the edits after it are this report's run figures and `docs/state.md`'s verification line.

**The two post-run edits, proved against what reads them.** No target opens `docs/reports/` (a grep over every root
`.gd` finds no `res://docs/reports` read). `docs/state.md` has one reader, `check_es`: every string literal of every
root `.gd` (15,644) was searched in the `state.md` the acceptance run read — its hash is in the after-freeze — and in
the edited one, raw and whitespace-flattened: **0 LOST, 0 GAINED**, and `check_es`'s own window census, reproduced,
reads two windows and the same four pairs in both — and `check_es` itself printed two windows and four figures for it.
`check_es` then read **57 / 0** on the final tree in an isolated copy (proved: 489 files, only `project.godot`
differing), with `check_ed` 18 / 0 and `check_ec` 24 / 0.

---

## §8 — WHAT MOVED

- **The ten targets, the twenty-three arms** (§1): `check_do`, `check_dp`, `check_dr`, `check_dv`, `check_ea`, `check_eh`,
  `check_es`, `check_gn`, `test_batch_ah`, `test_run_harness` — each arm with a note at its site saying what it asked and
  what it asks now. `check_dp` §5's *"draftable by"* print names the class (a print, not an arm). **And §1c's
  pairing**: three positive arms after `test_batch_ah` §2's walk, one after `check_ea` §1's seats, and `check_do`'s
  Stunned pin asking the statement walk as well as the file.
- **`test_batch_au`**: the named-complaint arm follows §3's ruling, thirteen checks one for one, and two comments.
- **`check_da.gd`**: `check_ea.gd`'s `WALK_EXEMPT` row deleted — the re-derived §1 reads neither shelf accessor, and the
  exempt-list arm would have caught the exemption going stale (42 → 41).
- **`gate_fixture.gd`**: `engine_sets()`, additive — the engine sets a hero of a class can hold, written once for
  `check_ea` and `check_eh`. No existing function changed.
- **`scripts/battle.gd`, `scripts/map_screen.gd`, `scripts/run_state.gd`**: §3 — the grant (the class draft pool and the
  lineage's boss pool), the menu label and toast, four comments. No card, rune, engine, kit, pool or node.
- **`docs/master.html`**: the toggle's name and what it grants, and the `Last updated` stamp.
- **`baselines.json`, five rows** (`test_batch_ah` 5550 → 6189, `check_ea` 83 → 236, `check_eh` 153 → 229, `check_do`
  86 → 112, `check_da` 42 → 41), every one attributed by the ok() trace, not a subtraction; no row added.
- **`pin-manifest.json`**, regenerated: 1,519 pins, the same 1,519 — none gone, none new, 35 at a moved line (on 34 lines:
  two share `test_run_harness.gd:213`).
- **`docs/reports/HJ.md` (NEW)**, `docs/changelog.html`, `CLAUDE.md`, `docs/design-notes.md` and `docs/state.md`.
- **Nothing under `data/`.**
