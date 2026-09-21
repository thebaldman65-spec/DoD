# BATCH HA — THE LAST STAGE, CENSUSED AND PRICED: FORTY-TWO GATES STILL ASK ABOUT SPECS

**On `class-merge`, from `ac5072c` (GZ). IMPLEMENT ONLY. FP's sixth stage, taken as a census.** Every target the
battery launches was read arm by arm for what it asks of the merged game. **The middle group — targets that pass
while still asking a pre-merge question — is 42 targets and 130 arms, and twenty of those arms cannot fail as
written or pass while the merged game contradicts them.** That is large, so by the brief's own rule it is **priced
and not repaired**: no gate, suite, fixture or baseline row moved. The merge back to `main` is reported (§3), not
taken. `README.md` is stripped to what cannot go stale (§4) and GZ's ceiling principle is recorded (§5). **No rune,
engine, card, kit, pool or node moved, and `main` is untouched.**

---

## NEEDS A RULING

1. **THE REPAIR IS TWO BATCHES, AND THE ORDER IS THE PROPOSAL.** **HB: the twenty tier-1 arms first** (fifteen
   targets — each one a hole, not a stale sentence), **then the thirty-five FOLD arms** (eleven suites whose
   per-shelf and class-wide-shelf floors become one per-class floor through one shared helper) — 55 arms in 23
   targets. **HC: the remaining seventy-five tier-2 arms in 36 targets** — the re-points and the retirements, with `check_ea` §1's four-arm re-derivation and `check_dp` §1's
   per-class status table as the two that are more than a re-point. §2 prices both and says why not one.
2. **FIVE CALLS THE REPAIR CANNOT MAKE ON ITS OWN**, because each is a statement about the game, not about a gate:
   - **Guard Change and Lunge** (`test_batch_ak:345`): every Warrior is offered both since GP, and the arm still says
     *"a sibling has no stance to swap"*. Retire the arm (every Warrior is meant to have them), or rule them
     holder-only (two `ENGINE_READ` rows, driven both ways — a card change, not a gate repair).
   - **Immolate and Pyroblast** (`test_batch_ar:684`, `:686`): *"spec-only — it reads a passive a sibling will not
     have"*; every Mage is offered both, and neither reads Overburn any more. Retire, or rule them holder-only.
   - **Summoning** (`check_dr` §1, and `CLAUDE.md`'s DR §1 block and FO §2 bullet): exclusive to the Pack Bond engine
     (its three enablers), or to the Hunter class (because an earned Call the Wilds summons with no Pack Bond)? The
     re-pointed arm asserts whichever is ruled.
   - **The class-wide cards' "weaker" rule** (`test_batch_bq:344`, `:349`, EB §1): GP made them ordinary cards of the
     class pool and recorded the rebalance as owed. Retire the comparison, or re-point it over every Cleric who can
     draft Heal.
   - **The floor the FOLD family asserts**: a per-class floor on `Classes.draft_pool(k)`, on the engine-free
     `Classes.offerable(draft_pool(k), [])`, or both. Today's figures are 43 / 51 / 43 / 41 and 40 / 38 / 29 / 34.
3. **`main` LOADS A RUN SAVE THE MERGED BUILD WROTE, AND ITS PROFILE GUARD HAS NO COUNTERPART THERE** (§3c). The
   designer's own saves on disk today are the merged build's. Whether `main` gains a forward guard before it is next
   played, or the merge lands first, is the designer's.
4. **THE BRANCH IS NOT READY TO LAND, AND TWO THINGS STAND BETWEEN IT AND READY** (§3d): the middle group, and the
   lineage layers the charter rules away and nothing has built — **the sharpest being that a hero who takes a spine
   or a rule engine at class selection can be offered no ordinary rune at all** (§1g).

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `ac5072c` = `origin/class-merge` before anything moved |
| 2 | *"FP's sixth and final stage"* | **HELD** | `docs/state.md`'s running order, step 6: *"THE GATES — 52 engine-bound targets"* |
| 3 | *"FP measured 52 engine-bound battery targets carrying 71.6% of all asserted checks"* | **HELD, AND NOW RECONSTRUCTED** | `docs/reports/FP.md` §1: 97 targets banded 10 / 14 / 21 / **52**; 32,393 of 45,248 check floors = 71.6%. **The 52 are recoverable exactly from FP's own `run_battery.sh` (`7880687`) minus the three bands FP named: 34 suites + 18 gates.** `docs/merge-recon.html` §1e's prose says *"All 46 rune and battle suites … plus 18 gates"*, which would be 64 — **46 is the whole suite count; the band holds 34.** |
| 4 | *"Most have been repaired incidentally, batch by batch"* | **THE MECHANISM IS WRONG** | They were repaired **deliberately and at once**: GK re-pointed 45 `passive_id` comparisons in 36 files and made both fixtures seat the lineage's engine rune, and closed its own census at *"nothing GK broke is left broken"* (`docs/reports/GK.md` §3). What later batches did was move counts (row 6), not repair reds |
| 5 | *"GK's census … found 67 of 104 targets red and 38 throwing on `passive_id` alone"* | **HELD** | GK §3a: suites 40 of 46 + gates 27 of 58 = 67 of 104; 203 errors in 38 targets were the one `passive_id` line, and 42 targets threw in all |
| 6 | *"every batch since has moved some of them"* | **DID NOT HOLD** | Measured over `baselines.json` at every commit from GK to GZ: FP's 52 rows moved at GK (12), GM (1), GN (11), GO (5), GP (6), GS (14), GV (1) and GW (1). **GL, GQ, GR, GT, GU, GX (both commits), GY and GZ moved none of them** |
| 7 | *"GZ found `check_dv` §4 passing when it should have failed, because the changelog header records every cut"* | **HELD** | GZ §3 |
| 8 | *"FG's finding recurring for the third time"* | **TRUE OF A DIFFERENT THING** | GZ's *third* counts the bare-`contains` shape — a pin satisfied by later prose — whose first two instances are BZ→BB and CD→BO. **FG's** finding is the always-true alternation in DV's version of the same arm, and GZ calls its own find that shape *"arriving by a shorter road"* — its first recurrence, not its third |
| 9 | *"`main` has sat at `b722cc4` since GI"* | **HELD** | `main` = `origin/main` = `b722cc4` (2026-09-14). The merge base is FS (`3b80fbe`); `main`'s only commits since are GG's and GI's documentation lines |
| 10 | *"Its `state.md` names two defects fixed only on the branch — the quit skip and the unreachable end boss"* | **HELD, AND IT NAMES A THIRD** | GI's own line on `main` adds *"GI's fix for a zone boss that can field the Hollow Crown, which is `main`'s too"* |
| 11 | *"FQ ruled the conflict convention for eight files"* | **HELD** | FQ measured **eight** conflicting files over fourteen commits, and `check_fr` §4 pins all eight by name; `docs/ways-of-working.md`'s table carries a ninth row (`docs/reports/XX.md`) that *cannot conflict*. The design-notes row was amended at GY §2 |
| 12 | *"GZ found `README.md` naming Batch BP … because nothing in the tree opens it"* | **HELD, RE-VERIFIED** | No `.gd`, `.py` or `.sh` file in the tree names `README.md` |
| 13 | *"The four gates GY §3 found finding their subject by the property under test stay reported"* / *"GY found two that filter by rendered text and assert the result is empty"* | **HELD** | `check_gx:412`, `check_gx:769`, `test_batch_as:900`, `check_ct_map:96`; the last two are the vacuous pair |
| 14 | *"The Crown's resistance, Sanctity's potency layer and the engine cards stay queued"* | **HELD** | The engine-card items are GQ's rulings 1 and 2 |
| 15 | *"when it is done, `class-merge` is complete and could land on `main`"* | **NOT ON ITS OWN** | Step 6 is the running order's last step, but GK's charter also rules *"there are no specs"* and marks it RULED, NOT BUILT: four lineage layers still read a spec, and one of them offers a spine-taker no ordinary rune at all. §3d |

---

## §1 — THE POPULATION, DERIVED; THE CENSUS, ARM BY ARM

### §1a — What was counted, and how

**THE POPULATION IS EVERY FILE THE BATTERY LAUNCHES, NOT FP's 52.** `run_battery.sh`'s own arrays give **46 suites
and 69 gates**; the runner launches four more from sections of its own (`test_run_harness`, `check_map_screen`,
`check_ct_map`, `check_de`) — **119 files, 121 launches** (the harness runs three times). **Four more `.gd` files at
the root are launched by nothing** (`check_ck_width`, `check_cu`, `check_cv`, `check_dn`), and the two fixtures every
target seats through (`gate_fixture`, `suite_fixture`) were read as well: **125 files in all.**

**FOUR INSTRUMENTS, EACH CATCHING WHAT THE ONE BEFORE IT COULD NOT.**

| instrument | what it did | what it could not see |
|---|---|---|
| **1. a comment-stripped vocabulary sweep** | every line of all 125 files matched against four families — spec ids and spec tables, the passive vocabulary, `passive_id` in any form (comments included), and `second_resource` — plus the post-merge engine vocabulary as a contrast. **105 of the 119 launched targets name a spec concept; 13 name nothing pre-merge at all** | what an arm MEANS — a spec id seating a fixture and a spec id asking a dissolved question look identical |
| **2. nine readers under one rubric** | each of the 112 files with a hit, read arm by arm against a written rubric: eight relations the merge **dissolved** (D1 engine by spec, D2 resource by spec, D3 offer by spec, D4 kit by spec, D5 tree by spec, D6 *"has chosen"* by spec, D7 ownership by spec, D8 per-spec depth) and nine lineage layers that **still live** (stat block, boss pools, spec-scoped runes, display name, the engine↔lineage mapping, shelves as authoring locations, the seat convention, the names that must not be renamed, the class→lineage table). Every arm classed SEAT, LIVE, PRE, PROSE or PRINT, with file and line | the names instrument 1 never matched |
| **3. HA's own supplementary sweeps** | `class_draft_pool` / `CLASS_DRAFT_POOLS` / `specs_chosen` / the deleted seam names over all 125 files (**197 lines in 58 files**), which added **18 arms** the readers' hit lists never showed them; and **every document pin in `pin-manifest.json`** (249 of them) filtered for a spec-era claim — GZ's exact shape, a pin satisfied because the document still carries the old answer | an arm whose needle names nothing spec-era |
| **4. a re-check of the survivors** | every assertion in the 83 files with no PRE arm (the 77 clean launched targets, both fixtures and the four launched by nothing), grepped for pre-merge phrasing (*opening kit*, *drafts from*, *exclusive*, *spec-only*, *his own*, `core_slots(`, `spec_abilities(`, `PROTECTED_CORES`) and each hit read | — **it found nothing the readers missed**: every hit was post-merge wording, a talent-pair word, or prose |

**THE CUT BETWEEN THE MIDDLE GROUP AND THE REST IS THE ARM'S INTENT, READ FROM ITS OWN COMMENT.** An arm whose
purpose is a dissolved relation is in the middle group whether or not its condition still holds; an arm whose
purpose is a live relation is not, even when its message uses pre-merge words. So a per-shelf floor that exists
*"so a pool that quietly empties trips"* is in (the hero draws his class pool, not a shelf), and the tranche-order
pins that exist because *"a later tranche APPENDS; it does not rewrite"* are out (append discipline is live
authoring, and only their second reason is stale). **The two tiers inside the group:** tier 1 is an arm that
cannot fail as written, or passes while the merged game contradicts its claim; tier 2 is an arm that asks a
dissolved question whose answer still happens to hold.

**THE FIXTURE SEAT IS NOT PRE-MERGE, AND THAT WAS CHECKED RATHER THAN ASSUMED.** Both fixtures seat a lineage with
its engine rune slotted and `awakened` set (`Runes.engine_pouch_for_spec`) — GK's ruled convention, *"an instrument
that seats a lineage seats its engine rune"* — so a target that seats `["pyromancer", …]` and asserts Overburn pays
is asking about a holder of Overburn. **Both fixtures were read in full and both are correct**, including
`lineage_cards`, which seats the cards a lineage opened with until GS as DRAFTED cards — the way a player now gets
them — and never as an opening kit.

### §1b — THE FOUR QUESTIONS, OVER ALL 119 LAUNCHED TARGETS

| question | yes |
|---|---|
| 1 — reads a spec concept at all (any spec id, spec table or spec field) | **105** |
| 2 — reads an engine by its old name (through the spec, the passive vocabulary or `second_resource_name`) | **24** |
| 3 — reads a lineage through a field that no longer means what it did | **53** |
| 4 — `passive_id`, in any form | **2**, and only as negative needles (`check_ft`, `check_fx`); a comment in `test_batch_bv` is the third mention |

### §1c — REPAIRED AND CORRECT: 75 TARGETS

**Every spec read in these is a SEAT (the fixture seats the engine), a LIVE lineage layer, or prose.**

`check_cl_resolver`, `check_cl_width`, `check_cm`, `check_cn`, `check_co`, `check_cs`, `check_ct`, `check_ct_map`, `check_cy`, `check_cz`, `check_da`, `check_de`, `check_di`, `check_dj`, `check_dk`, `check_dl`, `check_dm`, `check_ds`, `check_dw`, `check_eb`, `check_ec`, `check_ed`, `check_ek`, `check_el`, `check_em`, `check_et`, `check_eu`, `check_ev`, `check_ew`, `check_ez`, `check_fd`, `check_fe`, `check_ff`, `check_fg`, `check_fh`, `check_fi`, `check_flow`, `check_fm`, `check_fn`, `check_fq`, `check_fr`, `check_fs`, `check_fx`, `check_gf`, `check_gm`, `check_go`, `check_gp`, `check_gq`, `check_gs`, `check_gt`, `check_gu`, `check_gv`, `check_gw`, `check_gx`, `check_map`, `check_map_screen`, `check_parse`, `test_batch_ai`, `test_batch_as`, `test_batch_ax`, `test_batch_bc`, `test_batch_bd`, `test_batch_be`, `test_batch_bf`, `test_batch_bg`, `test_batch_bh`, `test_batch_bi`, `test_batch_bj`, `test_batch_bk`, `test_batch_bl`, `test_batch_bm`, `test_batch_bn`, `test_batch_bs`, `test_rune_battle`, `test_runes`


### §1d — THE MIDDLE GROUP, BY NAME: 42 TARGETS, 130 ARMS

| target | Q1 · Q2 · Q3 | arms | tier-1 | repair / fold / retire | in FP's 52 |
|---|---|---|---|---|---|
| `check_do` | Y · Y · Y | 1 |  | 1 / 0 / 0 | **no** |
| `check_dp` | Y · Y · Y | 2 |  | 2 / 0 / 0 | **no** |
| `check_dr` | Y · – · Y | 3 | 1 | 3 / 0 / 0 | yes |
| `check_du` | Y · – · – | 1 | 1 | 0 / 0 / 1 | yes |
| `check_dv` | Y · – · Y | 3 |  | 2 / 0 / 1 | **no** |
| `check_ea` | Y · – · Y | 5 |  | 5 / 0 / 0 | yes |
| `check_eg` | Y · – · Y | 2 | 2 | 2 / 0 / 0 | **no** |
| `check_eh` | Y · Y · Y | 3 |  | 2 / 0 / 1 | **no** |
| `check_es` | Y · – · Y | 1 |  | 1 / 0 / 0 | yes |
| `check_fk` | Y · – · Y | 1 |  | 1 / 0 / 0 | yes |
| `check_fo` | Y · Y · – | 1 | 1 | 1 / 0 / 0 | yes |
| `check_ft` | Y · Y · Y | 1 | 1 | 1 / 0 / 0 | **no** |
| `check_gn` | Y · – · Y | 1 |  | 0 / 0 / 1 | **no** |
| `test_batch_ah` | Y · Y · Y | 8 |  | 5 / 0 / 3 | **no** |
| `test_batch_ah_battle` | Y · – · Y | 2 | 1 | 2 / 0 / 0 | yes |
| `test_batch_aj` | Y · – · Y | 3 |  | 3 / 0 / 0 | yes |
| `test_batch_ak` | Y · Y · Y | 1 | 1 | 0 / 0 / 1 | yes |
| `test_batch_al` | Y · – · Y | 1 |  | 0 / 0 / 1 | yes |
| `test_batch_an` | Y · – · Y | 2 |  | 2 / 0 / 0 | yes |
| `test_batch_ar` | Y · Y · Y | 4 | 3 | 0 / 0 / 4 | yes |
| `test_batch_at` | Y · Y · Y | 2 |  | 2 / 0 / 0 | yes |
| `test_batch_au` | Y · – · Y | 4 |  | 3 / 0 / 1 | yes |
| `test_batch_av` | Y · Y · Y | 1 |  | 1 / 0 / 0 | yes |
| `test_batch_aw` | Y · – · Y | 2 |  | 2 / 0 / 0 | yes |
| `test_batch_ay` | Y · – · Y | 2 |  | 2 / 0 / 0 | yes |
| `test_batch_az` | Y · Y · – | 2 | 1 | 0 / 0 / 2 | yes |
| `test_batch_ba` | Y · Y · – | 1 | 1 | 0 / 0 / 1 | yes |
| `test_batch_bb` | Y · – · Y | 1 |  | 1 / 0 / 0 | **no** |
| `test_batch_bo` | Y · Y · Y | 11 | 3 | 6 / 4 / 1 | yes |
| `test_batch_bp` | Y · – · Y | 4 |  | 2 / 1 / 1 | yes |
| `test_batch_bq` | Y · – · Y | 4 |  | 2 / 2 / 0 | yes |
| `test_batch_br` | Y · – · Y | 8 | 1 | 3 / 4 / 1 | yes |
| `test_batch_bt` | Y · – · Y | 6 |  | 0 / 5 / 1 | yes |
| `test_batch_bu` | Y · Y · Y | 7 | 1 | 1 / 5 / 1 | yes |
| `test_batch_bv` | Y · Y · Y | 6 |  | 1 / 4 / 1 | yes |
| `test_batch_bw` | Y · – · Y | 6 |  | 2 / 3 / 1 | yes |
| `test_batch_bx` | Y · – · Y | 2 | 1 | 2 / 0 / 0 | yes |
| `test_batch_cb` | Y · Y · Y | 5 |  | 1 / 3 / 1 | yes |
| `test_batch_cd` | Y · – · Y | 2 |  | 2 / 0 / 0 | **no** |
| `test_batch_ce` | Y · – · Y | 4 |  | 0 / 3 / 1 | yes |
| `test_batch_cp` | Y · Y · Y | 2 |  | 0 / 1 / 1 | yes |
| `test_run_harness` | Y · – · Y | 2 | 1 | 2 / 0 / 0 | **no** |
| **total** | | **130** | **20** | **68 / 35 / 27** | 31 of 42 |

#### Tier 1 — the arms that cannot fail as written, or pass while the merged game contradicts their claim

| arm | what it asserts, and why it cannot fail | action |
|---|---|---|
| `check_dr:179` | no second reviver - tested as Holy ownership, so a second reviver on the Holy table passes | REPAIR |
| `check_du:405` | per-lineage core census instances>distinct - holds by construction since GS | RETIRE |
| `check_eg:257` | Guard Change 'can never be benched' - refused for any name not carried, and it is protected for nobody since GS | REPAIR |
| `check_eg:259` | Guard Change 'nor carried through this door' - same | REPAIR |
| `check_fo:654` | records that no companion can stand beside a Focus holder - one Hunter may now hold Lethal Aim and Pack Bond | REPAIR |
| `check_ft:1298` | 'fire, frost and arcane book the same floor' - all three drives cast Magic Bolt, so fire and frost are never cast | REPAIR |
| `test_batch_ah_battle:345` | the sheet shows an 'earned' Crushing Blow - every Warrior's class kit holds it since GN | REPAIR |
| `test_batch_ak:345` | Guard Change / Lunge 'never offered to a sibling with no stance' - every Warrior is offered both | RETIRE |
| `test_batch_ar:684` | Immolate 'spec-only - reads a passive a sibling will not have' - every Mage is offered it | RETIRE |
| `test_batch_ar:686` | Pyroblast, the same - every Mage is offered it | RETIRE |
| `test_batch_ar:712` | 'his opening kit is still all fire' - the Mage kit holds Nexus Ward (DEFENSE) | RETIRE |
| `test_batch_az:618` | no class:hunter rune writes a Sharpshooter counter - every such rune is retired or payload-less, so it cannot fail | RETIRE |
| `test_batch_ba:534` | Tripwire / Shrapnel Charge / Snare Trap 'base kit, not earnable' - false for Shrapnel Charge since GS | RETIRE |
| `test_batch_bo:507` | Flamewave is protected - on a member with no engine, who never had Flamewave | REPAIR |
| `test_batch_bo:510` | benching Flamewave is refused - refused because he never had it | REPAIR |
| `test_batch_bo:627` | an owned Winter's Toll is not re-offered - ENGINE_READ drops it for an engine-less member whether owned or not | REPAIR |
| `test_batch_br:1566` | pins CLAUDE.md's 'ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY' - the seam GP deleted; the document still carries it | REPAIR |
| `test_batch_bu:385` | no spec_abilities definition carries a NINE name - walks the CLASS keys, so the assertion never runs | REPAIR |
| `test_batch_bx:410` | a protected card cannot be benched OR the Swordmaster's enablers are empty - empty since GS, so it cannot fail | REPAIR |
| `test_run_harness:404` | talent_points_earned('') == 0 - nothing ever writes key '', so it cannot fail | REPAIR |

#### Tier 2 — every other arm, by target

- **`check_do`** — `:475` precision_ranks read-site pin keeps a reason about the Swordmaster's guaranteed statuses (dormant field) (**REPAIR**, D4/D5)
- **`check_dp`** — `:191` the per-lineage tree sweep read more than 0 nodes (**REPAIR**, D5); `:200` no node reads a status outside a per-spec guaranteed-status table built on cores and passives (**REPAIR**, D4/D2/D5, M)
- **`check_dr`** — `:126` summon specials 'belong to the Beastmaster' via spec_abilities ownership (**REPAIR**, D7); `:168` resurrection 'belongs to the Holy Cleric' via spec_abilities ownership (**REPAIR**, D7)
- **`check_dv`** — `:251` emptiable boss pools counted against the lineage's own shelf (**REPAIR**, D3); `:260` Holy's un-draftable boss cards checked against the Holy shelf only (**REPAIR**, D3); `:270` core_slots('holy') == 0 (**RETIRE**, D4)
- **`check_ea`** — `:316` award-always-pays floor per lineage shelf, not per class pool x engines held (**REPAIR**, D3/D8, M); `:331` full-three floor over the pre-GP two-tier chain (**REPAIR**, D3, M); `:346` no lineage's shelf floor below 3 (**REPAIR**, D3, M); `:394` lost awards from the per-spec two-tier floor (**REPAIR**, D3, M); `:399` emptiable boss pools counted against the lineage's own shelf (**REPAIR**, D3)
- **`check_eh`** — `:156` arm C: the lineage's reach is gone and EH's third tier must pay - the tier GP deleted (**REPAIR**, D3); `:213` all 12 lineages: boss pool + lineage shelf held still leaves the class tier paying 3 (**REPAIR**, D8/D3); `:251` core_slots != protected_names size - the ladder no longer reads core_slots (**RETIRE**, D4)
- **`check_es`** — `:640` a swap card taken from the Berserker's shelf as 'one a player could actually make' (**REPAIR**, D3)
- **`check_fk`** — `:338` rune requirement reach set = own shelf + class-wide shelf, no sibling shelves, no ENGINE_READ (**REPAIR**, D3)
- **`check_gn`** — `:197` ability_slots_used == lineage_slots + kit_slots with no engine held (**RETIRE**, D4)
- **`test_batch_ah`** — `:62` each lineage's spec_abilities holds 3 bar entries - 'opens with' (**RETIRE**, D4); `:80` the five AH trims absent from spec_abilities - 'left the kit' (**RETIRE**, D4); `:130` no class-wide card costs a spec-exclusive secondary resource (**REPAIR**, D2/D3); `:133` no class-wide card is a 'Beastmaster signature' (**REPAIR**, D7/D3); `:136` Hex of Ruin 'stays Occultist-only' (**REPAIR**, D7); `:138` no class-wide card is 'gated on a spec passive' - replaced by ENGINE_READ / SITS_OUT (**RETIRE**, D2/D3); `:285` the award refuses a member 'with no spec' (**REPAIR**, D6); `:287` the fallback refuses a member 'with no spec' (**REPAIR**, D6)
- **`test_batch_ah_battle`** — `:207` action-bar fillers from class-wide + Berserker shelf, 'new' = not in spec_abilities (**REPAIR**, D3/D4)
- **`test_batch_aj`** — `:409` Hack and Slash 'is in the Berserker kit' via spec_abilities (**REPAIR**, D4); `:552` Battle Shout 'drafts from the Berserker' as reachability (**REPAIR**, D3); `:584` Rampage 'drafts from the Berserker' as reachability (**REPAIR**, D3)
- **`test_batch_al`** — `:692` War Stomp / Interpose not in spec_abilities('warden') as 'not opening kit' (duplicate of 519/521) (**RETIRE**, D4)
- **`test_batch_an`** — `:824` sibling-spec set built from boss pools AND draft shelves (positive arm) (**REPAIR**, D3); `:829` no zone-boss offer returns a sibling-spec entry, over the same mixed set (**REPAIR**, D3)
- **`test_batch_ar`** — `:614` Flame Shield 'not in the kit' = spec_abilities (covered by 676) (**RETIRE**, D4)
- **`test_batch_at`** — `:603` 'STABILIZE IS OUT of the opening three' = spec_abilities (**REPAIR**, D4); `:628` Stabilize 'spec-only: it reads Resonance' via the class-wide shelf (**REPAIR**, D3/D1)
- **`test_batch_au`** — `:364` each of 12 per-lineage trees deals 27 cells and none grants (**RETIRE**, D5); `:657` Firestorm / Rime 'drafts from the <spec> instead' (**REPAIR**, D3); `:777` Magi's Wrath 'drafts from the Arcanist instead' (**REPAIR**, D3); `:946` the debug grant holds no sibling-spec entry, siblings' shelves counted as theirs (**REPAIR**, D3/D7)
- **`test_batch_av`** — `:303` Resurrection / Intercession not on the Cleric class-wide shelf 'never offered to a sibling with no stacks' (**REPAIR**, D3)
- **`test_batch_aw`** — `:466` Sacred Resolve 'drafts from the Devout' (**REPAIR**, D3); `:468` Bulwark of Fortitude 'drafts from the Devout' (**REPAIR**, D3)
- **`test_batch_ay`** — `:403` retired payload edits Kill Command 'which every Beastmaster owns' (**REPAIR**, D4); `:410` retired payload edits Hunter's Instinct 'which every Beastmaster owns' (**REPAIR**, D4)
- **`test_batch_az`** — `:627` each Sharpshooter rune's lane is one of his deleted tree's lanes (**RETIRE**, D5)
- **`test_batch_bb`** — `:760` no Mage lineage's spec_abilities holds Ashes of Al'ar - 'does not START with it' (**REPAIR**, D4)
- **`test_batch_bo`** — `:194` nine lineage shelves >= 8 (**FOLD**, D8); `:217` three Warrior lineage shelves >= 8 (**FOLD**, D8); `:223` the Warrior shelf is NAMED - 'one of four heroes had no draft' (**REPAIR**, D3); `:225` the Warrior shelf 'FULL, at least EIGHT of its own' (**FOLD**, D8); `:241` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:343` no card on one lineage's shelf is in a sibling's boss pool (**RETIRE**, D3/D7, M); `:394` CAP - core_slots(spec) >= 3 free slots (**REPAIR**, D4); `:437` core_slots('beastmaster') == 1 - 'they cost ONE slot' (**REPAIR**, D4)
- **`test_batch_bp`** — `:139` each of the 12 shelves non-empty - 'EVERY spec has a draft now' (**REPAIR**, D8); `:163` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:212` a tranche card is not in the class-wide draft (**RETIRE**, D3, found by HA's own sweep); `:232` a lineage's enablers are absent from its OWN shelf only (**REPAIR**, D3)
- **`test_batch_bq`** — `:215` the Hunter class-wide shelf >= 6 (**FOLD**, D3, found by HA's own sweep); `:217` the Warrior class-wide shelf >= 6 (**FOLD**, D3, found by HA's own sweep); `:344` Ministration on the beefiest ally < 'Holy's Heal' - Heal is a Cleric pool card (**REPAIR**, D7); `:349` the same at five Mercy (**REPAIR**, D7)
- **`test_batch_br`** — `:198` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:259` nine lineage shelves >= 8 (**FOLD**, D8); `:262` three Warrior lineage shelves >= 8 (**FOLD**, D8); `:313` each Warrior lineage can draw Rally, via the class-wide shelf (**REPAIR**, D3); `:318` each Hunter lineage can draw Field Dressing, via the class-wide shelf (**REPAIR**, D3); `:677` a Warden's offer holds a Warden-shelf card - the per-card seam roll GP deleted (**RETIRE**, D3); `:755` each class-wide shelf 'never rolls an empty class pool' (**FOLD**, D3, found by HA's own sweep)
- **`test_batch_bt`** — `:181` Mage lineage shelves >= 8 (**FOLD**, D8); `:183` Cleric lineage shelves >= 8 (**FOLD**, D8); `:228` Warrior lineage shelves >= 8 (**FOLD**, D8); `:231` Hunter lineage shelves >= 8 (**FOLD**, D8); `:252` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:255` a tranche card is not on a class-wide shelf ('leaking into a class pool') (**RETIRE**, D3, found by HA's own sweep)
- **`test_batch_bu`** — `:184` lineage shelves >= 8 (**FOLD**, D8); `:186` lineage shelves >= 8 (**FOLD**, D8); `:194` lineage shelves >= 8 (**FOLD**, D8); `:221` lineage shelves >= 8 (**FOLD**, D8); `:252` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:255` a tranche card is not on a class-wide shelf (**RETIRE**, D3, found by HA's own sweep)
- **`test_batch_bv`** — `:211` Hunter lineage shelves >= 8 (**FOLD**, D8); `:215` nine lineage shelves >= 8 (**FOLD**, D8); `:224` three Warrior lineage shelves >= 8 (**FOLD**, D8); `:273` class-wide shelves >= 3 (**FOLD**, D3); `:276` a NINE card is not on a class-wide shelf (**RETIRE**, D3); `:300` a Hunter lineage's enablers are absent from its OWN shelf only (**REPAIR**, D3)
- **`test_batch_bw`** — `:214` nine lineage shelves >= 8 (**FOLD**, D8); `:239` three Warrior lineage shelves >= 8 (**FOLD**, D8); `:286` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:289` a tranche card is not on a class-wide shelf (**RETIRE**, D3, found by HA's own sweep); `:310` a lineage's enablers are absent from its OWN shelf only (**REPAIR**, D3); `:455` no NINE card in any spec_abilities 'kit does not already hold' (**REPAIR**, D4)
- **`test_batch_bx`** — `:251` the Warden shelf >= 8 'spec cards to be offered' (**REPAIR**, D3/D8)
- **`test_batch_cb`** — `:177` nine lineage shelves >= 8 (**FOLD**, D8); `:199` three Warrior lineage shelves >= 8 (**FOLD**, D8); `:224` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:227` a tranche card is not on a class-wide shelf (**RETIRE**, D3, found by HA's own sweep); `:1246` pins master.html's 'All twelve specs draft from at least ten' (a doc edit rides with it) (**REPAIR**, D8/D3)
- **`test_batch_cd`** — `:400` every shelf >= SPEC_FLOOR 8 (**REPAIR**, D8); `:422` the thinnest shelf >= 10 as 'the one a card is owed to next' (**REPAIR**, D8)
- **`test_batch_ce`** — `:203` nine lineage shelves >= 8 (**FOLD**, D8); `:230` three Warrior lineage shelves >= 8 (**FOLD**, D8); `:264` class-wide shelves >= 3 (**FOLD**, D3, found by HA's own sweep); `:267` a tranche card is not on a class-wide shelf (**RETIRE**, D3, found by HA's own sweep)
- **`test_batch_cp`** — `:178` 12 lineage shelves >= 8 (**FOLD**, D8); `:229` a CP card is absent from every class-wide shelf (**RETIRE**, D3, found by HA's own sweep)
- **`test_run_harness`** — `:407` a hero with his spec blanked banks nothing - the spine-taker who does bank is never seated (**REPAIR**, D6)

#### The prints of a pre-merge table (not asserted, not counted as arms)

`check_do:451` (D4+1), `check_ea:256` (D3), `check_ea:302` (D3), `check_ea:390` (D3), `check_ea:401` (D3), `test_batch_cd:425` (D8), `check_eh:226` (D3/D8), `check_dp:376` (D3), `check_dn:327` (D3), `check_dn:402` (D3/D4)


### §1e — RED, SKIPPED OR EXEMPTED: WHY, AND SINCE WHEN

| target | state | since | why |
|---|---|---|---|
| `check_cm_live` | **red, 13 checks / 4 failures, sanctioned** | **CQ §1** | `_nobody_can_press()` is true under every headless gate, so the defensive bar never opens through an attack; the four reds are one fact (FH named it). Its row carries `fails: [4, 4]`. It reads its Warden by `has_engine("heavy_plating")` — **no pre-merge arm** |
| `check_gj` | **red, 70 / 1, sanctioned** | **GN** | the victory card leaves out the Tollkeeper's Bell's 20 gold. The arm is right and the game is wrong; the row carries `fails: [1, 1]`. **No pre-merge arm** — its hand-rolled `_new_run` seats lineages with no engine rune, which is harmless because nothing it asserts reads one |
| `test_rune_battle` | green, **failure band `[0, 1]`** | **DE**, seeded at DF §0 | the White Flame's pierce is a race under machine load; the one row still carrying a `flake` field. **No pre-merge arm** |
| `check_ck_width`, `check_cu`, `check_cv`, `check_dn` | **launched by nothing** | since their own batches: **CP, CU, CV, DN** | audit instruments that assert nothing; *"what a failure in an audit REPORT means is a ruling rather than a detail"*, and since EI they are parse-covered and named as `check_parse`'s residue every run. **`check_dn`'s whole question is pre-merge** — does a node depend on the spec's passive or its protected core — and it prints two per-spec tables (D3/D4). The other three are clean |
| the seven no-count targets (`check_cl_resolver`, `check_cl_width`, `check_cm`, `check_cn`, `check_flow`, `check_map`, `check_map_screen`) | **exempt from the count floor**, completion read off an `expect` marker | **FS §1** | they print no tally by design; `check_de` §2 refuses a no-count row without a marker |
| `test_batch_as`, `test_batch_at`, `test_batch_aw` — one arm each | **pass vacuously, on purpose, named at their sites** | **DG** | the exclusive-pair list they read was removed with CW's narrative; owed, and in `docs/state.md` |
| `check_ew` §6's last arm | **vacuous** (`ok(step == step, …)`) | recorded in `docs/state.md` | owed to whichever batch next touches the gate |
| `check_gx:412`, `check_gx:769`, `test_batch_as:900`, `check_ct_map:96` | **find their subject by the property they test** | **GY §3** | reported, and stay reported (§6) |

**NONE OF THE RED, SKIPPED OR EXEMPTED ROWS IS RED OR EXEMPT BECAUSE OF THE MERGE.** Every one predates GK or is a
game defect the arm is right about, and every one was re-read for pre-merge arms and has none — `check_dn` aside,
which runs nowhere.

### §1f — WHERE FP's 52 STAND TODAY

**Twenty are repaired and correct, thirty-one are in the middle group, and one is red on purpose.**

- **Repaired and correct (20):** `test_batch_as`, `ax`, `bg`, `bh`, `bi`, `bn`, `bs`, `test_runes`,
  `test_rune_battle`, `check_cs`, `cy`, `cz`, `di`, `et`, `eu`, `ev`, `ew`, `ez`, `fh`, `fn`.
- **In the middle group (31):** `test_batch_ah_battle`, `aj`, `ak`, `al`, `an`, `ar`, `at`, `au`, `av`, `aw`, `ay`,
  `az`, `ba`, `bo`, `bp`, `bq`, `br`, `bt`, `bu`, `bv`, `bw`, `bx`, `cb`, `ce`, `cp`, `check_dr`, `du`, `ea`, `es`,
  `fk`, `fo`.
- **Red on purpose (1):** `check_cm_live`.

**AND ELEVEN OF THE MIDDLE GROUP ARE NOT IN FP's 52 AT ALL**, which is the reason the brief was right to say *derive
the population*: `check_do`, `check_dp`, `check_dv`, `check_eh`, `test_batch_ah`, `test_batch_bb` and
`test_batch_cd` sat in FP's **band 2** (table-bound — "re-derivation, not rewriting"), `check_eg` in **band 1**
(seating only), `check_ft` and `check_gn` did not exist until FT and GN, and `test_run_harness` was never in the
arrays FP swept. **FP's band 3 was defined by `passive_id`, `second_resource` and a `spec:` rune scope** — the engine
half of the merge — **and the middle group is overwhelmingly the other half: the offer, the kit and ownership**
(D3 in 60 arms, D8 in 31, D4 in 27, D7 in 12, against D1 in 7 and D2 in 3).

### §1g — WHAT THE CENSUS FOUND THAT IS NOT A GATE

**None of these is repaired here** — the brief forbids rune, engine, card, kit and pool changes, and each is either
the designer's or its own batch.

- **A HERO WHO TAKES A SPINE OR A RULE ENGINE AT CLASS SELECTION CAN BE OFFERED NO ORDINARY RUNE AT ALL.** All 60 live
  ordinary runes are `spec:`-scoped and all 24 `class:`-scoped runes are engine runes; `Runes._scope_ok` passes a
  `spec:` rune only when the member's lineage matches, and a spine-taker's lineage is empty. **So every Peddler row,
  cache and bargain he is ever shown is one of his class's engine runes.** GV's ruling 5 names the narrowness (*"a
  rune's scope is still the lineage while the card pools merged at GP"*); this is its sharpest case, and it is not in
  the queue in these words. Measured off `data/runes.json`, not driven.
- **`Run.ability_slots_used` IS KEYED ON THE LINEAGE AND NEVER READS AN ENGINE** (`check_gm:378` and `check_gn:197`
  are near-tautologies against it). It is correct today because `lineage_slots` is zero for every lineage; it is the
  door a future lineage card would have to pass through.
- **THE DEBUG PRE-GRANT *"All Spec Abilities Unlocked"* STILL GRANTS ONE LINEAGE'S BOSS POOL AND SHELF**
  (`battle.gd` ~1322), not the class pool the draft now reads. A testing aid scoped to a population no player draws.
- **AT LEAST TWENTY-THREE TARGETS SEAT A LINEAGE BY HAND WITH NO ENGINE RUNE**, against GK's *"a hand-built seat
  must too"*: `check_eb`, `check_eg`, `check_es`, `check_et`, `check_fd`, `check_fe`, `check_fm`, `check_fn`,
  `check_flow`, `check_gf`, `check_gj`, `check_ct_map`, `check_map_screen`, `test_batch_aj`, `test_batch_al`,
  `test_batch_an`, `test_batch_bh`, `test_batch_bo`, `test_batch_bp`, `test_batch_br`, `test_batch_bx`, `test_runes`
  and `test_run_harness` (each named by its reader; a count off the readers' notes, not a sweep). **Harmless in most**
  — nothing they assert reads an engine — **but not in three whose populations the engine gates narrow**:
  `check_et`'s `_member` (every `Runes.ENGINE_READ` rune is withheld from its retirement walks; `check_fd`'s identical
  helper was repaired at GV and this one never was), `test_runes`' exhaustion and start-pool members, and `check_fm`'s
  `_member`, which never draws an engine-read rune or a spine-taker's pool. **And the engine-less seat is exactly what
  makes `test_batch_bo:507`, `:510` and `:627` vacuous.**
- **THREE GATES READ TWELVE ENGINES' TEXT WHERE THERE ARE TWENTY-FOUR.** `check_cl_resolver` (unresolved tokens),
  `check_cl_width` (line width) and `check_do` §4's barred-name list reach engine text through
  `SPEC_INFO[s]["passive_desc"]`, so the three spines' and the nine rule engines' rule texts are never checked. **None
  carries a token today**, so the gap is latent; `check_gx:304` likewise samples lineage engines only.
- **SMALL AND DEAD:** `check_di:391` looks a hero up by `_hero(scene, "pack_bond")`, which can never match (the engine
  id is `pack`) and falls back to a class lookup; `test_batch_cp`'s `PASSIVE_OF` table maps the Beastmaster to
  `"loyalty"` where the engine is `pack`, inert only because nothing calls it with that key; `check_cy`'s sweep always
  casts from the first living hero, so its two-party reason (the Holy's Mercy, the Devout's Faith, a Sharpshooter's
  Focus) is never exercised.
- **TWO DOCUMENTS STATE A PRE-MERGE FACT, AND A PIN KEEPS EACH GREEN.** `CLAUDE.md:3421` says *"THE ONE-IN-FOUR CLASS
  SEAM DRAWS A REAL ENTRY FOR EVERY HERO IN THE GAME"* — the seam GP deleted — and `test_batch_br:1566` pins it;
  `docs/master.html` says *"All twelve specs draft from at least ten"*, and `test_batch_cb:1246` pins it. **Both are
  left as they are**: correcting either sentence reds its pin, and the pin is middle-group work for the repair batch,
  so the document and its pin move together there.

---

## §2 — THE PRICE, AND WHY THIS BATCH STOPS AT IT

**The brief's rule: *"If the middle group is large, report the count and the method and stop."* It is 42 targets and
130 arms — more than a third of the battery — so nothing was repaired and nothing was retired.** What is owed is
priced in units of work rather than in minutes, because no earlier batch measured a per-arm repair time and a figure
invented here would be the first thing the next brief quoted.

| kind | arms | targets | what one costs | how it is proved |
|---|---|---|---|---|
| **FOLD** — a per-shelf or class-wide-shelf floor becomes a per-class floor | **35** | **11** suites | **one shared helper**, then a call per site. **It must be one helper in a fixture** — `docs/instrument-rules.md`'s *a helper copied between gates inherits its bugs* — not eleven copies | **one control serves the family**: a scratch copy that thins one class's pool below the floor must turn all eleven red; and the blind spot of the old arms is shown beside it — moving a card between two shelves of one class reds the per-shelf floors and moves nothing a hero is offered |
| **RETIRE** — the subject is gone | **27** | 21 | inverted onto the ruling that removed its subject, never deleted: the DY §3 idiom, which `check_gp` §1 already uses for the seam (*`draft_card_is_class` has no code*). **The Melted Armor contract: kept, said to be kept.** One is larger: `test_batch_bo:343`'s live half becomes a name-uniqueness sweep over the corpus | put the removed thing back in a scratch copy and see the inverted arm red |
| **REPAIR** — re-pointed at the door that answers the post-merge question | **68** | 32 | **63 are a re-point onto a door that exists** (`draft_pool`, `offerable`, `opening_kit`, `protected_names`, `engine_enablers`, `engine_read`, `sits_out_engine`, `awakened`, `ability_corpus`). **Five are more**: `check_ea` §1's four share one re-derivation over class × engines held (a spine-taker included), and `check_dp` §1 needs `check_do`'s guaranteed-status table re-keyed by class | a two-armed control per target, on a scratch copy with its own `user://` |

**AND THREE COSTS SIT ON TOP OF THE ARMS.**

- **EVERY REPAIRED TARGET IS BROKEN ON PURPOSE AND SEEN RED** — the brief's §7 rule, and GY's reason for it: an arm
  that filters by a rendered value and asserts the result empty passes on a reformat. **Forty-two targets owe at least
  one control each**, read by their FAIL text and not by their count, fewer only where one injected defect genuinely
  serves a family.
- **COUNTS MOVE, SO ROWS MOVE FIRST.** A FOLD replaces twelve per-shelf `ok()`s with four per-class ones; a retirement
  can change a loop's arm count. **Every moved row is predicted and written into `baselines.json` with its reason
  before the verification run** — DF's rule — which on this population is up to one row per repaired target, and a
  FOLD moves the row of every suite it touches.
- **TWO DOCUMENT SENTENCES MOVE WITH THEIR PINS** (§1g): `CLAUDE.md:3421`'s seam and `docs/master.html`'s *"All
  twelve specs draft from at least ten"* — the second with the stamp.

**THE PROPOSAL IS TWO BATCHES.** **HB takes the twenty tier-1 arms and the FOLD family** — 55 arms in 23 targets,
because the tier-1 arms are holes rather than stale questions, and because three of the FOLD suites (`test_batch_bo`,
`test_batch_br`, `test_batch_bu`) carry tier-1 arms of their own and are cheaper opened once. **HC takes the other 75
arms in 36 targets**, including all six of the larger ones. **HA's census took a whole batch to read 125 files; the
repair edits 42 of them, proves each one red, and moves their rows** — one batch would be the brief the rule exists
to stop. If HB finds HC smaller than priced, it says so.

**THE CENSUS IS WRITTEN TO BE TRANSCRIBED.** Every arm in §1d carries its file, its line, its relation, its action
and its cost; `docs/state.md` carries the proposal. The repair batches should not need to re-derive the population —
only to re-verify each arm's line before editing it, because a line number is a claim too.

---

## §3 — WHAT LANDING ON `main` WOULD TAKE. REPORTED; NOTHING MERGED

**Everything below was measured with git plumbing that writes nothing to either branch** (`git merge-tree
--write-tree`, `git diff`, `git show main:…`), and the save question was DRIVEN in isolated copies whose
`user://` could not reach the player's saves.

### §3a — The conflicts: ONE, and FQ's convention covers it

| | |
|---|---|
| merge base | **FS, `3b80fbe`** — the branch forked after FS, not at FQ; FQ, FR and FS are on both sides |
| commits on `class-merge` only | **33** (FT → GZ, GX twice) |
| commits on `main` only | **2**: GG's and GI's documentation lines, both `docs/state.md` alone (+8, then one line re-worded) |
| files that differ, `main` → `class-merge` | 179, +61,679 / −15,347 lines |
| **conflicts a merge raises, either direction** | **exactly one: `docs/state.md`** |
| the merged tree against `class-merge` | identical in every file but `docs/state.md` |

**FQ's convention for that file is *"Take the branch's wholesale. It is rewritten every batch and has no reader."*** It
applies as written. Every other file auto-merges to the branch's content, because `main` changed nothing else since FS
— so `baselines.json`, `run_battery.sh`, `CLAUDE.md`, `docs/master.html`, `docs/changelog.html` and
`docs/design-notes.md`, the rows the convention was written for, **raise no conflict at all**: the hard cases FQ ruled
on only arise if `main` is edited, and it has not been.

### §3b — What `main` would lose

**Nothing of its own.** Its two commits are twelve lines of `docs/state.md` recording three defects — the quit skip,
the end boss with no button, and the zone boss that could field the Hollow Crown — and all three are FIXED on the
branch, where `docs/state.md` already records them as closed. Taking the branch's file wholesale drops those lines and
loses no fact, because the fact they record is that the fix lives on the branch.

**What does go is a GAME, not a file**: after the merge the pre-merge game — twelve specs, spec trees, spec pools —
exists only in history. `b722cc4` is the last commit that plays it. **Tag it before merging** if the designer wants to
keep it one checkout away; nothing in the repo tags it today.

### §3c — The saves: `Profile`'s guard holds, and the run save has none on `main`

**DRIVEN, NOT READ.** Two isolated copies — `main` at `b722cc4` and the branch at `ac5072c` — each `rsync`'d out of the
repo with its `.godot` cache, **each renamed in `project.godot` before anything ran in it** so its `user://` could not
reach the player's, and **both seeded from byte-identical copies of the player's four save files** (md5-matched to the
backup taken as this batch's first action). One probe, the same in both: load the profile and try to save it, load
the run, open the map, open a fight.

| | **`main`'s build** (profile v2, run save v12) | **the branch's build** (profile v3, run save v13) — the control |
|---|---|---|
| the profile (v3, written by the merged build) | **REFUSED, and nothing written**: *"it was written by a NEWER build than this one (version 3) … NOTHING HAS BEEN CHANGED OR DELETED"*; `profile.json` byte-identical after | accepted |
| the run save (v13, written by the merged build) | **LOADED, with no refusal and no word to the player** | loaded |
| the party it seats in a fight | **Warrior 1 ability, Pyromancer 5, Cleric 1, Hunter 1** | **5, 6, 5, 5** |
| the run save afterwards | byte-identical (the probe quit before any step saved) | byte-identical |

**FQ BUILT THE PROFILE'S GUARD FOR EXACTLY THIS AND IT WORKS AS BUILT.** `Profile` refuses a newer version, makes
`_save()` a no-op, and says so on the main menu. **THE RUN SAVE HAS NO COUNTERPART.** `main`'s `load_run` refuses only
a version BELOW 10, so a v13 run loads — and **three of the four heroes in the designer's own save took a spine or a
rule engine at class selection** (the Rune of the Reaver, the Rune of the Hierophant, the Runes of the Medic and the
Tracker), so they carry no lineage, and `main` — which has no class kits and no engine runes — seats each of them
with **his basic attack and nothing else**. The run plays on as a different, weaker party, and nothing says why.
**What `main` would write back at its first save was not driven**: its `save_run` writes v12 and none of GF's
pending-step keys, which the branch reads tolerantly as a v12 save.

**IT MATTERS ONLY UNTIL THE MERGE LANDS, AND ONLY IF `main` IS PLAYED BEFORE THEN.** After a merge `main` IS the
branch's build and reads its own saves. **The saves on disk today are already the merged build's** — `profile.json` is
v3 and `run_save.bin` is v13 — so the designer who opens `main` now meets a refused profile and a run that plays wrong.
**A forward refusal in `main`'s `load_run`, in the profile's shape, is a small code change on `main`**, so it is a
ruling (NEEDS A RULING 3), not something this batch could take on a branch it was told not to touch.

**THE PROBE'S FIRST RUN MEASURED THE WRONG FILE, AND THAT IS RECORDED BECAUSE IT READ LIKE A FINDING.** Both builds
first returned `load_run = false`. **FI's redirect** sends every `--script` process to `run_save_harness.bin`, which the
seeded folders do not hold — so the probe was measuring the redirect, not the save. It was pointed at
`user://run_save.bin` explicitly, which is safe only because each copy's `user://` is a scratch folder, and re-run
from re-seeded copies.

### §3d — IS THE BRANCH READY? NO — AND TWO THINGS STAND BETWEEN IT AND READY

**MECHANICALLY THE MERGE IS TRIVIAL**: one conflict, answered by a convention the designer already ruled, and nothing
of `main`'s own lost. **What is not ready is the thing a merge would certify.**

1. **THE BATTERY DOES NOT YET SPEAK FOR THE MERGED GAME.** It is green, and **130 of its arms in 42 targets still ask
   the pre-merge game's questions** — twenty of them cannot fail at all or pass against a false claim (§1d). A branch
   landed on that battery lands on a statement nobody has checked. **This is the running order's own step 6, and it is
   HB and HC.**
2. **THE CHARTER SAYS *THERE ARE NO SPECS*, AND FOUR LAYERS STILL READ ONE** — the RULED, NOT BUILT half of GK's
   charter: spec-scoped runes, per-lineage boss pools, per-lineage stat blocks, and the lineage opening (now its
   engine's enablers alone). **Three of the four are quiet. The rune layer is not**: a hero who takes a spine or a rule
   engine is offered no ordinary rune at all (§1g), and **three of the four heroes in the designer's own save are that
   hero.** Whether the lineage layers merge before landing or after is the designer's; the rune half is the one a
   player meets on the first Peddler.

**AND WHAT CAN LAND AS KNOWN DEBT, SAID SO RATHER THAN LEFT TO BE FOUND:** the sanctioned `check_gj` red (the victory
card leaves out the Tollkeeper's Bell's 20 gold, a player-visible defect on the branch); the Crown's Break and freeze
resistance, Sanctity's potency layer and the engine-card texts (queued, §6); and the owed rulings the queue carries,
many of them player-visible words that would ship as proposed. **None of these is a reason not to merge; each is a
reason to merge knowing.**

**AND TAG `b722cc4` FIRST** (§3b) if the pre-merge game is to stay one checkout away.

---

## §4 — `README.md` SAYS ONLY WHAT CANNOT GO STALE

**Ruled, and done: it holds what the project is, where things live and which file a reader opens first, and it
points at `docs/state.md` wherever a live fact would go.** It went from 62 lines to 28. **Nothing in the tree opens
it** — no `.gd`, `.py` or `.sh` file names it, re-verified here, and the same sweep is not blind: it finds **31
targets that open `CLAUDE.md`** and 17 that open the changelog — so nothing can go red on it, which is the reasoning
the ruling records: **a file no instrument reads will always drift, so it must not contain anything that can.** The
rule is written where the file roles are, in `CLAUDE.md`'s *WHAT THIS FILE IS* block, beside the pointer to
`docs/state.md`; the file itself says only *"This file holds only what does not change"*, because a sentence in it
claiming that nothing reads it would itself be a claim that could go stale.

**WHAT WAS REMOVED, EVERY LINE OF IT TRUE ONLY AT ONE MOMENT:**

| removed | why it went |
|---|---|
| *"Phase 1: combat prototype"*, *"Phase 2 in progress"* | a phase |
| the controls — *"hit SPACE when the cursor is in the gold zone (Perfect)"* | a mechanic: CN took the bar off every ability with nothing to multiply, and basic attacks resolve at a fixed Good |
| *"Spire-style run map (`scenes/map.tscn`, the main scene) … Fight / Elite / Rest / Loot nodes … victory offers Rest-or-Scavenge"* | three facts, all stale: the main scene is `main_menu.tscn`, and AN removed the rest nodes |
| *"Party of 3 (Warrior/Rage, Mage/Mana, Cleric/Mana) vs 2 Orc Raiders + 1 Orc Chief"*, the Break numbers, *"Timing-bar skill checks on every ability"* | a party of four since the Hunter, and every ability does not carry a bar |
| the `DOD_AUTOPLAY` / `DOD_SIM` command lines and *"the main scene is now the run map"* | the environment flags are `CLAUDE.md`'s debug table; the main-scene claim was false |
| *"`scenes/battle.tscn` — entry scene"*, the four-file project layout, *"Soldier + Orc sheets"* | a layout from before the map, the screens and the autoloads |
| *"it starts at Batch FT (2026-09-09)"*, *"Batch FS back to Batch 1"* | **a boundary** — the exact claim GZ found 126 batches stale, re-pointed at GZ and stale again at the next cut |
| *"Batch FH brought it in"*, the knowledge-sync deselection advice | a batch, and a rule that lives in `CLAUDE.md`'s sync block |
| *"`docs/build_docs.py` — builds the Word exports"*, *"Design docs live one folder up in `DoD/*.docx`"* | a pointer at an export the designer ruled must stay stale (FG, written at FN §3) — an invitation to the rebuild the rule forbids |

## §5 — GZ's PRINCIPLE, RECORDED WHERE THE OTHER CEILINGS ARE

**Written into `docs/instrument-rules.md` directly after FG §2's *A CEILING NOBODY MEASURES IS A CEILING THAT GETS
CROSSED SILENTLY*, as its corollary**, with a row in `CLAUDE.md`'s index of that file:

> **A CEILING IS A NUMBER WITH AN ANSWER BEHIND IT.** The changelog's answer is to MOVE entries into the archive;
> `CLAUDE.md`'s is to SPLIT. **A file whose only answer would be to delete has no ceiling**, because a number with no
> action behind it is a warning nobody can obey.

**WHY THAT FILE AND NOT `CLAUDE.md`.** The changelog's threshold (CW §4) and FG's rule about ceilings in general both
live in `docs/instrument-rules.md`; `CLAUDE.md`'s own ceiling block governs one file. A rule about when a bar may be
stated at all is FG §2's corollary, and *a rule goes in one file and is not summarised in the other* — so the
reference holds it and `CLAUDE.md` indexes the heading, as it does every other rule over there. **Its worked case is
the archive** (GZ §6): *ARCHIVE MEANS MOVE, NEVER DELETE* sits in the block that would have to state the archive's
bar, so the bar's one remedy is the one that block bans. **Its instruction for a future batch: before proposing a
ceiling, name its answer.**

**THE THRESHOLD SENTENCE `check_fg` PARSES WAS NOT TOUCHED**, and the new block was checked for the parser's pattern
before it was written: `check_fg` §1 reads *THE THRESHOLD IS n KB* out of this same file and asserts that every
statement of it agrees.

---

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **No merge to `main`**, and no tag: §3 reports, and the tag is offered, not taken.
- **No gate, suite or fixture repaired or retired**: §2's price is the brief's stopping rule, applied.
- **No rune, engine, card, kit, pool or node changed**, including the three the census found (§1g) — the rune scope, the
  debug pre-grant, the slot door.
- **The two document sentences a pin keeps green** (`CLAUDE.md:3421`, `docs/master.html`'s per-spec depth) are left
  for the batch that repairs their pins. `docs/master.html` is byte-unchanged and its stamp did not move.
- **The Crown's resistance, Sanctity's potency layer and the engine-card texts stay queued. The four gates GY §3
  found finding their subject by the property under test stay reported.**

---

## §7 — VERIFICATION

**NO GATE WAS REPAIRED, SO THE BRIEF'S *break the thing it guards* RULE OWES NOTHING HERE — IT IS §2's PRICE FOR HB AND
HC.** What was proved instead is that this batch moved no reading, and that the census's own instruments did what the
report says they did.

| | |
|---|---|
| **the saves** | backed up as the batch's first action (`../save-backups/HA-20260921-002123`), md5-verified against the live files; **byte-identical after HEAD's battery, after the pre-pass and after the verification run**. §3c's drives never touched the player's folder — each ran in a renamed copy seeded from the backup |
| **HEAD's unmodified gates, against the frozen tree** | **121 of 121 launched; `check_de` 501 checks / 0 failures / 0 notices**; the two reds are the sanctioned ones at their baseline counts, with FAIL lines byte-identical to GZ's (`check_gj`: *"the card says +158 gold and the purse moved 178"*; `check_cm_live`: the four). **The tree was hashed before and after — 424 files — and did not move** |
| **the pre-pass** | the 66 targets that name an edited document (38 suites, 28 gates), run through a copy of the runner so each kept its flags: **every check, failure and throw count identical to HEAD's run** |
| **the verification run, on the tree with this batch's documents** | **121 of 121; `check_de` 501 / 0 / 0; the same two reds with the same FAIL lines.** One count differs from HEAD's run: **`test_batch_an` 6,056 → 6,053** — the suite `baselines.json` names *"THE KNOWN DRIFTER"* (its map budgets and rest slots), inside its band of 6,049–6,066, reading none of the edited documents, and the differ silent. **The tree was hashed at the start and the end — 425 files — and did not move** |
| **the parse floor** | **`Parse Error` on 0 lines in every log of all three runs**, read off the logs and not off a tally; every target reported 0 throws |
| **the needle instrument** | `build_pin_manifest.py --check` **current, 1,494 pins**, after every document edit — no pin changed residency |
| **the two ceilings** | `check_fg` §1: the changelog **148,347 B = 148.35 KB = 144.87 KiB, 251,653 B under the bar**; §2: `CLAUDE.md` **351,443 B, 66.79 KiB under its 410 KiB ceiling**. Neither warns |

**EVERY NEGATIVE ANCHOR IN THIS REPORT HAS ITS POSITIVE ARM.** *No file opens `README.md`* beside the same sweep finding
31 that open `CLAUDE.md` and 17 the changelog; *`main` refuses the profile* beside the branch accepting the same file;
*`main` loads the run save* beside the branch loading it too and seating the full kits; *the tree did not move* beside
the freeze that saw this report arrive as a 425th file.

**AND THREE OF THE CENSUS'S OWN INSTRUMENTS WERE CAUGHT SHORT AND CORRECTED BEFORE ANYTHING RESTED ON THEM:** the
vocabulary sweep omitted the class-shelf names (a reader said so; HA's second sweep added 18 arms and ruled them
uniformly); the first save probe read FI's harness path instead of the save (§3c); and one grep for running Godot
processes matched my own shell's command line — the rows were read, not the count, and they were `zsh`.

---

## §8 — WHAT MOVED

| file | what |
|---|---|
| `README.md` | stripped to what cannot go stale — 62 lines to 28 (§4) |
| `CLAUDE.md` | the README rule in *WHAT THIS FILE IS*; one index row and the sentence above the index naming it (§5). **+594 B, 351,443 B = 343.21 KiB, 66.79 KiB under the ceiling** |
| `docs/instrument-rules.md` | *A CEILING IS A NUMBER WITH AN ANSWER BEHIND IT*, after FG §2 (§5) |
| `docs/changelog.html` | this batch's entry |
| `docs/design-notes.md` | one entry, at the top |
| `docs/state.md` | rewritten: the WHERE block, HA's rulings and findings, GZ's ruling 2 taken, the merge's header and step 6 |
| `docs/reports/HA.md` | **NEW** |

**NOT TOUCHED:** no `.gd`, no `.tscn`, no `data/`, no `run_battery.sh`, no `pin-manifest.json`, **no `baselines.json`
row** — no gate was edited, so no count could move, and the count differ says so — `docs/master.html`,
`docs/combat-rules.md` and `docs/ways-of-working.md` byte-unchanged, proved off the start-of-batch freeze.
