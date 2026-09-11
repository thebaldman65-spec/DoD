# BATCH FX — ONE TALENT TREE, KEYED TO THE CLASS

**THE FIFTH BATCH ON `class-merge`, AND THE FIRST THAT MERGES ANYTHING: THE TALENT LAYER, AND ONLY THE TALENT
LAYER.** The twelve spec trees and their 324 nodes are deleted. ONE tree of 27 nodes stands in their place, and
each CLASS buys into it out of its own purse, so a Berserker, a Swordmaster and a Warden all spend the Warrior's
points in it. **What did not happen:** no spec dissolved, no pool merged, no engine became a rune and no spine was
attached (`check_ft` §0 holds). No node is read outside a battle, and the relic seam (EN §4) stands. `main` is
untouched.

**THE LINE, AS THE DESIGNER RULED IT:** *"A talent may not touch a rune, an ability, a passive or an engine."* Every
node is one `stat` payload on a field the battle already reads. None grants, none edits an ability, and none
carries a condition.

---

## NEEDS A RULING

1. **`TIER_SPEND_MIN`, THE SPEND GATE, IS A CANDIDATE AT 3.** Its range is 1–9 and both ends are priced in §1. The
   brief left the number to the designer, and the batch did not choose it.
2. **FIVE MAGNITUDES ARE PROPOSED, NOT TAKEN:** More Attack +10, More Armor +5%, A Bigger Resource Pool +20, More
   Damage Dealt +10% and Less Damage Taken 10%. For each, either no node ever wrote the field, or the only node that
   did is not one of the 43. Each is priced against a named reference in §3.
3. **FOUR OF THE BRIEF'S TWENTY-SEVEN WERE NOT TODAY FOR A TREE ALL FOUR CLASSES BUY, AND AN ALTERNATE FROM THE
   BRIEF'S OWN LIST STANDS IN EACH PLACE** (§2). The designer may prefer a different alternate, or may rule that a
   hook be built. The brief said to build none.
4. **TWO NAMES DEVIATE FROM THE BRIEF'S LABELS, EACH FOR A STATED REASON.** *Cleanse Debuffs Each Turn*: the
   precedent cleanses two debuffs and the label said one, so the name carries no number rather than the wrong one.
   *Breaking Heals a Hero*: the brief's "the party" is a retired word, and the read site heals one body.
5. **THE DESIGNER'S OWN SAVE CANNOT FEEL THE SPEND GATE.** The max fold gives 68 / 65 / 66 / 68 against a 54-point
   tree, so every class can buy the whole tree the day this lands (§4). That is not a defect; it is what four debug
   grants of 60 fold to. But a playtest of the gate needs a fresh profile.
6. **THE WIDE WATCH'S RETIREMENT HAS LOST ITS REASON.** It was retired because Overkill (`ss_overkill`) already kept
   Focus whole through a kill. That node is deleted and nothing writes `overkill`, so the rune's clause now exists only
   on the retired rune. Whether it returns is the designer's, since rune content is written with the designer.
   `check_fo` §3 asserts the present state, and goes red the day something carries the clause again.
7. **DEEPENING HEX'S FLOOR HAS LOST ITS DERIVATION.** `RUIN_FLOOR` 3 was priced as Avatar of Ruin's step of 5 minus
   the rune's 2, "the deepest the live tree can go". With Avatar deleted, the deepest a live Occultist reaches is every
   8th stack, so the floor binds no live build. The choice is to keep 3 or re-rule it. `check_fo` §1c carries the
   state.
8. **FIVE NODE NAMES USE A TAG WORD:** You Break Harder and We Do Not Break (BREAK), A Bigger Resource Pool and Pay a
   Lethal Hit out of Your Resource Pool (RESOURCE), and Mitigation per Debuff You Carry (DEBUFF). All five are
   recorded in `check_ek`'s `CLASH_EXEMPT`, as EL's rule allows. In the DEBUFF one the word does different work:
   debuffs carried, where the tag means debuffs landed. The names are the brief's own labels, so a rename is the
   designer's call.

## THE SHORT VERSION

1. **ONE TREE: 27 NODES IN THREE TIERS OF NINE AT 1 / 2 / 3 POINTS, SO 54 POINTS A CLASS.** The tree is flat
   within a tier: no lanes, no rows, no graph, no prerequisite, no exclusive node. **Buying is wearing.** With
   nothing exclusive there is no equip step left to keep, so every cell a class owns is on every hero of that class,
   every run. BM's unlock-is-not-equip rule is retired with its premise, and `CLAUDE.md` says why.
2. **A TIER NEEDS BOTH GATES.** The DIFFICULTY gate is BM's shape read in tiers, "as today": `TIERS_OPEN [0, 1, 2,
   3]`, so tier N opens at the end boss of rung N, for every class at once. The SPEND gate is new:
   `TIER_SPEND_MIN` cells owned in the tier below, per class.
3. **THE TWENTY-SEVEN:** 23 of the brief's nodes and 4 alternates from its own list. **18 magnitudes are TAKEN
   from a surviving precedent**, 4 come from a live node outside the 43 (called REFERENCE), and **5 are PROPOSED**
   against a named reference. None was inherited from a dead node: Overpressure is in no payload.
4. **THE FOLD.** Twelve spec purses become four class purses by MAX, once, behind FQ's guard: `Profile.VERSION` 3
   and `MIN_VERSION` 2 (moved from 1). A file that cannot be read, or a purse that cannot be placed, is REFUSED and
   the file is left untouched. The fold was driven live on a copy of the designer's profile before anything wrote
   the real one.
5. **WHAT READ THE TREES.** FX deleted 22 symbols. `LANE_TREES` alone was read by 32 files at HEAD. Against the
   new tree, the reconnaissance battery (every gate unmodified) found 28 suites, 7 gates and the run harness unable
   to parse, and 10 suites and 4 gates red. **51 targets were repaired to the new tree's intent: 25,636 checks became 20,638, of which 1,864 were deleted with the trees they asked about (each recorded at its site) and none was a mechanic check.**
6. **THE RUNES READ NO NODE.** No rune carries a condition, no rune or card names a node id, and `has_node(`
   appears in `talents.gd` alone. Five independent sweeps agree. **But five player-facing texts named deleted nodes and were corrected**, and **one retired rune's reason and one rune floor rested on deleted nodes** — the Wide Watch's retirement and Deepening Hex's floor — and both are queued for the designer.
7. **THE RECONNAISSANCE BATTERY WROTE THE DESIGNER'S PROFILE, AND THE VERIFIED BACKUP RESTORED IT.** Two scene
   gates had re-saved the profile idempotently for many batches, and every md5 freeze was blind to it. FX's fold
   made the same write destructive. Both gates now write a scratch file. §6.
8. **A NEW GATE, `check_fx` (494 checks), AND TEN NEGATIVE CONTROLS, EACH READ BY ITS FAIL TEXT.** The clean runs before and after read 494 / 0, and all nine injected defects bit. **One of them made the gate itself throw rather than fail** (a node writing the sentinel field instead of the bonus), so §4b now reports a field the tree stops writing and carries on: 493 to 494 checks, and the control reads 7 FAIL lines and 0 throws. §7a.

---

## §0 — THE BRIEF'S PREMISES

Each premise was checked against the code before anything was edited:

- **"Rung 1 opens tier 2" is off by one**, against the code and against the brief's own "as today". BM's
  `TIER_ROWS [0, 3, 6, 9]` opened rows 1–3 at rung 1, which is the first third of a tree. **Implemented as today:**
  `TIERS_OPEN [0, 1, 2, 3]`, so rung 1 opens tier 1. A fresh profile opens nothing (EN §3's tutorial gate, which
  stays).
- **"A Perfect pays; nothing has ever done this" is false.** `hl_holy_light` paid Mana on a Perfect. It paid Mana
  only, and that is why the node is not TODAY for a four-class tree (§2). The idea itself is not new.
- **"43 of FP's 50"** is FW's re-sort under the line, and the TAKEN magnitudes in §3 come from those 43 alone.
  Four precedents outside the 43 (Last Hope, Iron Will, Undying Rage, Devoutness) are live nodes whose numbers were
  used, and each is labelled REFERENCE rather than salvage.
- **Overpressure is dead.** Its read is the enemy's own field, and nothing copies the node's value onto an enemy.
  No magnitude comes from it.
- **`check_ft` §0 holds** (no spine switch is assigned), and **the relic seam stands**: no node reaches the purse,
  the pouch, the shop, the spawn line, a victory's pay or an elite's drop.
- **The brief's structure is "three tiers of nine, costs 1/2/3, 54 total"**, and that is BM's own curve: 9×1 +
  9×2 + 9×3 = 54, which is the price of one spec tree under BM. So the merged tree costs a class exactly what one
  spec tree cost.

## §1 — THE SHAPE, AND THE SPEND GATE'S TWO ENDS

`Talents.TREE` holds 27 nodes, each `{id, name, tier, desc, payload: {stat: {...}}}`. Every question about the
shape is asked in one place:

- `cell_cost(tier)` answers what a cell costs.
- `tiers_open(d)` and `tier_open(tier, d)` answer the difficulty gate.
- `bought_in_tier` and `spend_gate_met` answer the spend gate.
- `can_buy` and `can_refund` answer whether a cell may be bought or refunded.
- `worn_learned` gives what a hero wears.

`can_buy` names its reason in the player's words:

- *"Locked: beat the end boss on difficulty N"*
- *"Locked: own N more in tier T first"*
- *"Costs N — you have M"*

`can_refund` refuses a single refund that would strand the tier above it. A respec clears every tier at once and
is free outside a run, as before.

**THE SPEND GATE, PRICED AT BOTH ENDS.** It counts CELLS, not points, so it reads the same at both gates. A
completed run banks 3 points a class, one per zone boss. The difficulty gate binds separately: tier 2 still needs
the rung-2 end boss and tier 3 the rung-3 one.

| `TIER_SPEND_MIN` | First tier-2 node | First tier-3 node | What it feels like |
|---|---|---|---|
| **1** | 1 + 2 = 3 points, 1 run | 1 + 2 + 3 = 6 points, 2 runs | Decoration. One cheap cell a tier, and a class stands in tier 3 after two runs (still behind the rung-3 end boss). |
| **3** (candidate) | 3 + 2 = 5 points, 2 runs | 3 + 6 + 3 = 12 points, 4 runs | A tier is tasted before the next one opens: three cells, a third of it. |
| **9** | 9 + 2 = 11 points, 4 runs | 9 + 18 + 3 = 30 points, 10 runs | A tier must be bought out before the next opens. The tree becomes a strict ladder, and a class has spent half its 54 points (9 + 18 = 27) before its first tier-3 node. |

**3 is derived rather than chosen.** It is the three nodes a hero wore in each tier under BM (one a row, three rows
a tier), and it is exactly one completed run's purse. **The designer's folded purses (65–68) meet any value at
once** (§4).

## §2 — THE TWENTY-SEVEN, AND THE FOUR THAT WERE NOT TODAY

Every node the brief listed was checked for a field the battle already reads, and for whether that field pays
**every class that can buy the node**. A class tree is bought by four classes, so a field read for one currency pays
three quarters of the game nothing. That is the project's most common shipped defect: a payload that attaches and
pays 1.0000.

| Tier | The brief's node | Shipped as | Verdict |
|---|---|---|---|
| 1 | More health · More Attack · More armor · More crit chance · More Speed · Parry more · A bigger resource pool · More damage dealt · Less damage taken | `tn_health` · `tn_attack` · `tn_armor` · `tn_crit` · `tn_speed` · `tn_parry` · `tn_pool` · `tn_damage` · `tn_guard` | all TODAY |
| 2 | You Break harder · A cooldown ticks on a crit · Cleanse one debuff a turn · Heal more when low · Mitigation per debuff you carry · Armor penetration · Enemies look past you | `tn_break` · `tn_crit_cooldown` · `tn_cleanse` · `tn_last_hope` · `tn_iron_will` · `tn_pierce` · `tn_look_past` | all TODAY |
| 2 | **Regenerate more resource** | **`tn_break_heal`, Breaking Heals a Hero** (the brief's alternate "Breaking heals the party") | **NOT TODAY.** Rage has no regeneration field, so no Warrior is paid. The Mage's Evocation *assigns* `mana_regen_bonus = 10` at the spawn, over whatever the tree wrote (FW's third trap), so no Mage is paid either. |
| 2 | **Debuffs on you expire sooner** | **`tn_kill_down`, Kill What Is Down** (alternate) | **NOT TODAY.** No field shortens debuffs alone. The one that exists, `mod_status_turns` (Fleeting), is applied inside `add_status` to every status, buffs included (`unit.gd`, its one read site). |
| 3 | Refuse death once · Pay a lethal hit out of your resource pool · You cannot miss · Your crits crack guards · Breaking an enemy refuels you · A chance to skip a cooldown entirely · Your first casts of a fight are free | `tn_refuse_death` · `tn_resource_ward` · `tn_no_miss` · `tn_crack_guards` · `tn_break_refuel` · `tn_skip_cooldown` · `tn_free_casts` | all TODAY |
| 3 | **A Perfect pays** | **`tn_crit_pays`, A Crit Pays** (alternate) | **NOT TODAY.** The precedent, `hl_holy_light`, paid **Mana** on a Perfect, so a Warrior is paid nothing. A Perfect also does not exist on the abilities that run no check. |
| 3 | **Elusive while you carry an affliction** | **`tn_unbreaking`, We Do Not Break** (alternate) | **NOT TODAY.** Nothing grants Elusive for CARRYING an affliction. The field nearby, `hit_and_run`, grants Elusive when the hero AFFLICTS an enemy (`battle.gd`, `_apply_status(src, "elusive", src.hit_and_run)`). That is the opposite trigger. |

**Two alternates from the brief's list were not used**: *enemy debuffs rebound* and *when an ally falls low I
answer*. Four places needed four alternates. The two left over were not needed, so they were not assessed.

**The node on a per-currency field writes both currencies.** *Pay a lethal hit out of your resource pool* carries
`last_rites` (the Rage form, below 25% health, paid 1 Rage a point) AND `conversion_ranks` (the Mana form, 30% of
all damage paid as Mana). Each read site tests `resource_name`, so every hero is paid in the pool he holds.
`check_fx` §4 drives all four classes, and control C6 (§7) proves the Mana half is separately load-bearing.

**Two nodes are party-wide by their read site**: Heal More When Low (`last_hope_pct`) and We Do Not Break
(`devoutness_ranks`). The spawn stamps the best holder's figure on every hero, so two holders in one party do not
stack. This is the read site's shape, not a defect in the node, and `CLAUDE.md` records it.

## §3 — THE MAGNITUDES: PRECEDENT, WHAT IT PAID, AND WHETHER IT WAS TAKEN

A **TAKEN** magnitude and its wording come from one of the 43 surviving precedents (FW's re-sort of FP's 50). A
**REFERENCE** is a live node outside the 43 whose number was used. A **PROPOSED** magnitude has no precedent and is
priced against the stated reference. **The wording lost its pronouns (the text standard) and the spec it no longer
belongs to; no magnitude moved in the carry.** The comment above each node in `talents.gd` names the same thing.

| # | Node | Field = value | Precedent and what it paid | Status |
|---|---|---|---|---|
| 1 | More Health | `max_hp_pct` 0.20 | Woodcraft (`sv_woodcraft`) and Unwavering Faith (`dv_unwavering`): the same node twice, 0.20 | TAKEN |
| 2 | More Attack | `attack` 10 | **None**: no node ever wrote `attack`. Priced against the +10% party Attack boons two events pay (Blood Altar, Training Grounds), which is +10 on a base-100 hero | **PROPOSED** |
| 3 | More Armor | `armor` 0.05 | **None**: no node ever wrote `armor`. Priced against the relic hook `hero_armor_add` 0.05, the one permanent armor bonus that ships | **PROPOSED** |
| 4 | More Crit Chance | `crit_bonus` 0.15 | Steady Hands (`ss_steady`), 0.15 | TAKEN |
| 5 | More Speed | `speed` 18 | Fletcher's Speed (`ss_fletcher`), 18 | TAKEN |
| 6 | Parry More | `parry_bonus` 0.12 | Sword Mastery (`sm_sword_mastery`), 0.12 | TAKEN |
| 7 | A Bigger Resource Pool | `max_resource` 20 | **None**: no node ever wrote `max_resource`. Priced as Woodcraft's +20% of health, taken as the same share of a 100-point pool | **PROPOSED** |
| 8 | More Damage Dealt | `dmg_bonus` 0.10 | **No surviving precedent**: Reckless Fury (`bz_reckless`) paid 0.20 WITH +0.15 damage taken, and is not one of the 43. Priced against the relic hook `hero_attack_mult` 0.10, which lands in this same field at the spawn | **PROPOSED** |
| 9 | Less Damage Taken | `dmg_taken_bonus` −0.10 | **No surviving precedent**: Measured Rage (`bz_measured`) paid −0.20 as a row-6 node conditional on Reckless Fury, and is not one of the 43. Priced as the mirror of More Damage Dealt | **PROPOSED** |
| 10 | You Break Harder | `broken_will_ranks` 25 | Broken Will (`oc_broken_will`), 25 | TAKEN |
| 11 | Breaking Heals a Hero | `blood_communion` 20 | Blood Communion (`oc_blood_communion`), 20 | TAKEN (alternate) |
| 12 | A Cooldown Ticks on a Crit | `follow_through` 2 | Follow-Through (`ss_follow`), 2 | TAKEN |
| 13 | Kill What Is Down | `bonecracker_ranks` 40 | Bonecracker (`ss_bonecracker`), 40 | TAKEN (alternate) |
| 14 | Cleanse Debuffs Each Turn | `field_medic` 2 | Field Medic (`sv_medic`), 2. The brief's label said one, and the precedent's magnitude is the answer | TAKEN |
| 15 | Heal More When Low | `last_hope_pct` 40 | Last Hope (`hl_last_hope`), 40. A live node, not one of the 43 | REFERENCE |
| 16 | Mitigation per Debuff You Carry | `iron_will_ranks` 1 (×12% at the read site) | Iron Will (`wd_iron_will`), 1. A live node, not one of the 43 | REFERENCE |
| 17 | Armor Penetration | `pierce_bonus` 0.30 | Armor Piercer (`ss_piercer`), 0.30 | TAKEN |
| 18 | Enemies Look Past You | `ghillie` 65 | Ghillie Suit (`sv_ghillie`), 65 | TAKEN |
| 19 | A Crit Pays | `whetstone` 3 | Whetstone (`sm_whetstone`), 3 | TAKEN (alternate) |
| 20 | Refuse Death Once | `undying_rage` 1 | Undying Rage (`bz_undying`), 1. A live node, not one of the 43. The field carries a rider the read site pays and no payload can remove (50% more damage below a quarter's health until the refusal is spent), so the text states it | REFERENCE |
| 21 | Pay a Lethal Hit out of Your Resource Pool | `last_rites` 1 + `conversion_ranks` 30 | Last Rites (`bz_last_rites`), 1, and Conversion (`ar_conversion`), 30: one precedent per currency | TAKEN (both) |
| 22 | You Cannot Miss | `no_cover` 1 | No Cover (`ss_no_cover`), 1 | TAKEN |
| 23 | We Do Not Break | `devoutness_ranks` 20 | Devoutness (`dv_devoutness`), 20. A live node, not one of the 43 | REFERENCE (alternate) |
| 24 | Your Crits Crack Guards | `sundering_shot` 45 | Sundering Shot (`ss_sundering`), 45 | TAKEN |
| 25 | Breaking an Enemy Refuels You | `no_quarter_ranks` 1 (×45 at the read site) | No Quarter (`sm_perfect_form`), 1 | TAKEN |
| 26 | A Chance to Skip a Cooldown Entirely | `rapid_fire` 50 | Rapid Fire (`ss_rapid`), 50 | TAKEN |
| 27 | Your First Casts of a Fight Are Free | `snap_shot` 2 | Snap Shot (`ss_snap`), 2 | TAKEN |

**18 TAKEN, 4 REFERENCE, 5 PROPOSED.** No two nodes write one field. `check_fx` §1 asserts this over the whole
tree, and it is the one half of BM's row-8 rule that survives the lanes. Every node's text is tied to its magnitude
by a field→factor/phrase table in the gate, so a payload that moves without its text goes red (control C3).

## §4 — THE FOLD, AGAINST THE DESIGNER'S PROFILE

**BACKED UP AND HASH-VERIFIED BEFORE ANYTHING ELSE HAPPENED.** `save-backups/FX-20260910-231422/` holds all four
save files, each md5-identical to the original and to FW's backup:

| File | md5 |
|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

**RE-VERIFIED AT EVERY POINT A RUN COULD HAVE WRITTEN THEM.** The hashes were checked again after the reconnaissance
battery's write was restored (§6), after the pre-pass battery, and after the acceptance battery. Each time, all four
live save files carried exactly the hashes above. **Their modification times prove more than the hashes can.**
`profile.json` was last written on 2026-09-10 at 21:01, before this batch began, and the other three earlier still.
So neither battery wrote them at all, not even with identical bytes (§6's lesson). The migration itself was driven
only on copies (`check_fx` §3). The designer's file is still v2 and still matches the backup at hand-over, and it
migrates on the first launch of this build.

**THE FOLD, REPORTED BEFORE IT WAS WRITTEN.** It was driven by `check_fx` §3 on a copy. The designer's v2 file
carries twelve purses:

| Class | Its three spec purses | Folds to (MAX) | A sum would have given |
|---|---|---|---|
| Warrior | Berserker 68 · Swordmaster 60 · Warden 60 | **68** | 188 |
| Mage | Pyromancer 63 · Cryomancer 65 · Arcanist 60 | **65** | 188 |
| Cleric | Holy 66 · Devout (`inquisitor`) 62 · Occultist 60 | **66** | 188 |
| Hunter | Beastmaster 68 · Survivalist (`mystic`) 60 · Sharpshooter 60 | **68** | 188 |

**The four sums are equal (188) because a party is one of each class**, so every zone-boss point lands on one spec
of every class. The 60s are `debug_grant_meta`'s grant. The fold also does the following:

- **It drops `talent_cells`.** The Berserker's nine v2 cells named deleted nodes, so they are dropped and no point
  is refunded: the purse is points EARNED, and available is earned minus the cells spent, which are none after the
  fold.
- **It drops `talent_equipped`**, which was empty.
- **It keeps `talent_tier` 3.**
- **It leaves every chronicle bucket untouched** (`runs_started`, `runs_completed`, `wipes`, `forfeits`,
  `bosses_killed`, `events_seen`, `zones_cleared`, `flags`).

**After the fold every class can buy the whole 54-point tree, with 11–14 points left over.**

**THE GUARD IS FQ's, AND THE FLOOR MOVED.** `VERSION` is 3 and `MIN_VERSION` is 2 (it was 1). The guard refuses in
these cases, leaving the file untouched each time (the refusal hash is asserted in `check_fx` §3):

- A file from a newer build.
- A file below the floor.
- A file that is not a dictionary.
- A v2 file whose purses cannot be placed: a key that is not a spec this build knows, or a purse that is not a
  number.

**It refuses rather than zeroing.** A v2 file stays v2 on disk until its first save. **The fold happens on the
designer's first launch of this build**, and after that save the twelve purses exist only in the backup. **`main`'s
v2 build refuses a v3 profile, without deleting it**, until the merge lands there: FQ's guard, working as intended.
Keep the backup.

## §5 — WHAT READ THE TREES, WHAT BROKE, AND HOW EACH WAS REPAIRED

**WHAT READ THEM, AT HEAD**, counted before anything was deleted (`git grep -w` over `*.gd`, `*.sh` and `*.py`):

| Symbol | Files | Game files |
|---|---|---|
| `LANE_TREES` | 32 | `classes.gd`, `talents.gd` |
| `LANE_NAMES` | 4 | `battle.gd`, `party_screen.gd`, `talents.gd`, `talents_screen.gd` |
| `TIER_ROWS` | 1 | `talents.gd` |
| `CAPSTONE_ROW` | 20 | `party_screen.gd`, `run_sim.gd`, `talents.gd`, `talents_screen.gd` |
| `CELLS_PER_SPEC` | 5 | `talents.gd` |
| `row_nodes` / `row_picks` / `row_picked` | 6 / 2 / 1 | `run_sim.gd`, `party_screen.gd`, `talents.gd` |
| `has_capstone` / `tier_of_row` | 1 / 3 | `talents.gd`, `talents_screen.gd` |
| `rows_unlocked` / `row_unlocked` | 5 / 3 | `battle.gd`, `draft_screen.gd`, `talents.gd`, `talents_screen.gd` |
| `full_spec_cost` | 4 | `talents.gd`, `talents_screen.gd` |
| `can_equip` / `equipped_learned` | 3 / 3 | `profile.gd`, `talents.gd` |
| `talent_equipped` / `equip_cell` / `unequip_row` | 3 / 3 / 2 | `profile.gd`, `talents_screen.gd` |
| `equipped_talents` | 4 | `profile.gd`, `run_state.gd` |
| `rows_built` / `DOD_SIM_BUILDS` / `_target_lane` | 2 / 2 / 1 | `run_sim.gd` |

**The game side was re-pointed in the same edit as each deletion:**

- `talents.gd` was rewritten.
- `profile.gd` was rewritten (v3, class-keyed).
- `talents_screen.gd` was rewritten: four class buttons, three tier bands, click to buy.
- `party_screen.gd`'s tree section now draws the class tree, read-only, with the worn cells lit.
- `run_state.gd`'s handoff reads the spec's class.
- `run_sim.gd` builds by tier: `DOD_SIM_TIERS`, where `DOD_SIM_ROWS` is read as rows/3 and `DOD_SIM_BUILDS` warns
  and is ignored.
- `battle.gd`: No Quarter's float names the pool the hero holds, the member summary gives a tier spread, and the end
  boss announces the tier it opens.
- `draft_screen.gd` and `map_screen.gd` got text only.
- `classes.gd`: `talent_granted_names()` walks the one tree and returns nothing.
- `unit.gd`: Iron Will's chip says "for every debuff carried".

**WHAT BROKE, READ OFF THE RECONNAISSANCE BATTERY: HEAD'S GATES, UNMODIFIED, AGAINST THE NEW TREE.** This was run
before a single gate was edited, as the brief ordered:

- **No verdict (parse):** 28 suites (`ai`, `aj`, `ak`, `al`, `ar`, `as`, `at`, `au`, `av`, `aw`, `ax`, `ay`, `az`,
  `ba`, `bc`, `be`, `bf`, `bg`, `bh`, `bi`, `bj`, `bm`, `br`, `bs`, `bt`, `bv`, `bw`, `cb`), 7 gates (`check_do`,
  `dp`, `du`, `ek`, `em`, `fo`, `fq`) and the run harness (all three gates; it read `RunSim.rows_built`).
- **Red:**
  - `ah_battle` 67/1
  - `bb` 177/19
  - `bd` 71/8
  - `bn` 81/9
  - `bp` 276/1
  - `bx` 155/5, with the count down 6
  - `ce` 1114/1
  - `cp` 696/1, with the count down 1
  - `test_runes` 5354/48
  - `test_rune_battle` 96/1 with a throw, and the count down 1
  - `check_parse` 181/39
  - `check_dk` 64/6
  - `check_ed` 18/1 (the pin manifest)
  - `check_fk` 64/1
- **Also:** `check_cm_live` 13/4 is the sanctioned red. Three residue instruments that are not battery targets
  (`check_cu`, `check_cv`, `check_dn`) could not parse either. `check_de` read 445/134.
- **Everything else was green**, including every gate that reads the corpus.

**THE REPAIRS.** Each stale assertion was repaired to the new tree's intent (CQ §3). A node-identity check was
deleted only where its subject was the deleted trees themselves (DG §2), with an exact count and a comment at the
site. Every target below parses and reads 0 failures and 0 throws in standalone runs; the acceptance run is §7c. **Each count
that fell fell by exactly the deletions listed, plus the re-pointed walks named in the last column**, and each agent that
repaired a file reproduced HEAD's count first (several rebuilt HEAD out of the repo and logged every check) so the
reconciliation was against a per-section count rather than a total.

| Target | Checks before | After | Deleted (DG §2) | What else moved |
|---|---|---|---|---|
| `test_batch_ai` | 2219 | 228 | 0 | walks re-pointed from twelve trees to the one tree |
| `test_batch_aj` | 420 | 213 | 183 | re-pointed walks −24 |
| `test_batch_ak` | 496 | 338 | 161 | per-node walk 24 → 27, +3 |
| `test_batch_al` | 623 | 455 | 171 | per-node walk 24 → 27, +3 |
| `test_batch_ar` | 740 | 512 | 235 | +7 added (migration, dormant read sites) |
| `test_batch_as` | 399 | 266 | 138 | +5 added |
| `test_batch_at` | 477 | 352 | 130 | +5 added |
| `test_batch_au` | 288 | 278 | 10 |  |
| `test_batch_av` | 356 | 269 | 87 |  |
| `test_batch_aw` | 355 | 212 | 143 |  |
| `test_batch_ax` | 356 | 218 | 138 |  |
| `test_batch_ay` | 486 | 405 | 81 |  |
| `test_batch_az` | 519 | 450 | 69 |  |
| `test_batch_ba` | 690 | 635 | 55 | 52 by the agent, 3 by the lead after the master.html sweep |
| `test_batch_bb` | 177 | 173 | 4 |  |
| `test_batch_bc` | 91 | 89 | 2 |  |
| `test_batch_bd` | 71 | 71 | 0 | one-for-one |
| `test_batch_be` | 34 | 27 | 7 |  |
| `test_batch_bf` | 79 | 74 | 5 |  |
| `test_batch_bg` | 47 | 41 | 6 |  |
| `test_batch_bh` | 295 | 280 | 15 |  |
| `test_batch_bi` | 92 | 88 | 4 |  |
| `test_batch_bj` | 73 | 70 | 3 |  |
| `test_batch_bm` | 1891 | 773 | 10 | 324 nodes → 27, twelve purses → four (−1,150); +42 added (the fold, FX absence pins, both gates) |
| `test_batch_bn` | 81 | 80 | 1 |  |
| `test_batch_bp` | 276 | 276 | 0 | one-for-one |
| `test_batch_br` | 1592 | 1590 | 2 |  |
| `test_batch_bs` | 267 | 246 | 41 | +20 (the re-skin check per node of the one tree) |
| `test_batch_bt` | 375 | 373 | 2 |  |
| `test_batch_bv` | 864 | 565 | 2 | label sweep 324 → 27 (−297) |
| `test_batch_bw` | 515 | 513 | 2 |  |
| `test_batch_bx` | 161 | 156 | 4 | two per-name checks folded (−2), one control added (+1) |
| `test_batch_cb` | 1730 | 1729 | 1 |  |
| `test_batch_ce` | 1114 | 1114 | 0 | one-for-one |
| `test_batch_cp` | 697 | 697 | 0 | one-for-one |
| `test_batch_ah_battle` | 67 | 67 | 0 | one-for-one |
| `test_runes` | 5354 | 5306 | 48 |  |
| `test_rune_battle` | 97 | 97 | 0 | one-for-one |
| `harness_1` | 22 | 22 | 0 |  |
| `harness_2` | 166 | 382 | 0 | three checks per worn cell × 18 more cells a member (+216) |
| `harness_3` | 8 | 8 | 0 |  |
| `check_do` | 131 | 86 | 51 | +6 added (the designer's line, both arms) |
| `check_em` | 412 | 416 | 0 | +4 added (no rune names a node) |
| `check_fq` | 48 | 47 | 1 |  |
| `check_dp` | 48 | 32 | 17 | +1 added |
| `check_du` | 32 | 32 | 0 | one-for-one |
| `check_ek` | 45 | 46 | 0 | +1 added |
| `check_fo` | 93 | 85 | 8 |  |
| `check_dk` | 64 | 60 | 4 |  |
| `check_fk` | 64 | 63 | 1 |  |
| `check_fs` | 39 | 33 | 22 | +16 added (§1 asks the one tree; repaired by the lead) |
| **51 targets** | **25636** | **20638** | **1864** | |

**1864 checks were deleted, and every one asked about the deleted trees themselves:** a node's id, row, lane, name,
capstone flag, tooltip text or scale, the one-per-row exclusivity, or the grid's shape. Each deletion carries a comment at
its site naming what it asked and why the subject is gone. **No mechanic check was deleted.**

**HOW THE MECHANIC CHECKS SURVIVED THE TREES.**
- **Every read site FX kept still has its old question.** A suite that learned a retired node now carries that node's
  exact payload in a `RETIRED` table copied from the deleted trees. The fixture's existing `patch` option puts the payload
  on the hero's tree, so it still lands through the real spawn (`apply_from_tree` → `apply_payload`), and every effect
  assertion is unchanged.
- **Where a node of the one tree carries the same field at the same number, the check learns that node instead** — Sword
  Mastery's questions go to Parry More, Devoutness's to We Do Not Break, and so on through the precedent map.
- **A learned id that is neither live nor carried fails loudly**, so a typo cannot pass silently.
- **Every "the id survives" check is inverted:** the migration drops a retired id, and a live cell beside it survives, so
  the drop is a filter and not a wipe.
- **BM's "buying a cell does not equip it" control is inverted to buying IS wearing**, and a refund or respec un-wears.
- **The shape questions — size, unique ids, rank, tier, exclusivity — are asked of the one tree.**

**CHECKS THAT WERE VACUOUS AT HEAD, FOUND BY THE REPAIR AND FIXED BY IT:**
- `test_batch_bw`'s label sweep looked class keys up in the spec-keyed `LANE_TREES`, so its nine checks compared nothing.
- `test_batch_cb`'s grant-collision loop read nothing, for the same reason.
- `test_batch_ay` and `test_batch_az` passed `ability_names` a member with no tree, so their grant half never reached a
  node.
- The run harness's purse total summed spec keys, which read 0 on a v3 profile — "the walk banked NOTHING" would have
  passed without reading the ledger.
- `test_batch_ah_battle`'s "it grants nothing", `test_batch_bb`'s one-beast §1 and five of `test_batch_bn`'s release
  checks passed on a field at 0.

**CHECKS FOUND WEAK OR VACUOUS AND NOT CHANGED, BECAUSE THEY PREDATE FX** (§9 queues them):
- `test_batch_bw`'s kit sweep runs 0 checks, at HEAD and now.
- Two of `test_batch_bs`'s Forge Body checks stay green with no Forge Body: the first seeded blow of a battle takes less
  than every later one, and the pair's order favours it.
- `test_batch_al`'s "Toughness raised Constitution" passes without Toughness.
- `test_batch_av`'s "raises them holding NO Mercy" passes without Serenity.
- `test_batch_aw`/`ax`'s "exclusive reference names a live node" loop iterates 0 times.

**THE JUDGEMENT CALLS THE REPAIRS MADE, AND THE LEAD ACCEPTED:**
- `desc_for`'s `{v}`/scale rendering stays tested off retired text. It is live machinery that no node or rune feeds today.
- Row fill became tier fill.
- `test_batch_ar`'s defence floor went from 5 to 1: it was the Inferno lane's size, and the surviving claim is only that
  the tree carries mitigation.
- Capstone checks were deleted rather than inverted.
- Two tag-word clashes and one rune-counter audit were re-pointed at the retired spec fields rather than the one tree,
  whose shared stat fields are `check_em`'s unit math.

**THE RUNES AND CARDS.** No rune in `data/runes.json`, live or retired, carries a `condition`. No rune or card names
an old node id as a literal. `has_node(` appears in `talents.gd` alone. **No rune depends on a node, and five sweeps say so independently:**
- `check_em` §5 reads 0 of 1,772 rune strings naming a node by id or name.
- `check_fx` §5 finds no rune condition, and `has_node(` is in `talents.gd` alone.
- No rune payload carries an `upgrade` arm keyed to a node.
- The four granting runes all resolve.
- The retired runes' `lane` tags are copied by `Runes.build` and read by nothing.

**CARDS AND PASSIVES WERE A DIFFERENT MATTER: FIVE TEXTS PROMISED SOMETHING ONLY A DELETED NODE PAID, AND THE LEAD CUT
EACH CLAUSE.** The read sites stay, dormant, and the text now says only what the code pays:
- **Answering Steel** — on the card, its chip and its recast chip — said "Riposte's counter still answers".
- **Savage Sweep** said "Under The Pack the deeper bond runs".
- **Fault Line** said "Deep Focus moves that line".
- **The Devout's Conviction passive** said "Apostle adds another 1x and Fervor another".
- **Shieldwall's block** said "so they feed Tenacity and Rally".

**ONE RETIREMENT AND ONE FLOOR NOW REST ON DELETED NODES, AND EACH IS QUEUED AS A RULING:**
- The Wide Watch was retired because Overkill already kept Focus whole through a kill.
- Deepening Hex's `RUIN_FLOOR` of 3 was priced as Avatar of Ruin's 5 − 2.

`check_fo` §3 and §1c now assert the state each left, and each goes red the day a node or rune writes the field again.

**AND THE COMBAT LOG CARRIED THE PRECEDENTS' NAMES, SO THE LEAD RELABELLED IT.** The log lines and source labels that
fire for a node of the one tree now print that node's name: Parry More, Cleanse Debuffs Each Turn, Your First Casts of a
Fight Are Free, A Chance to Skip a Cooldown Entirely, Mitigation per Debuff You Carry, A Cooldown Ticks on a Crit,
Breaking an Enemy Refuels You, Enemies Look Past You, Pay a Lethal Hit out of Your Resource Pool, Refuse Death Once, and
We Do Not Break on its chip text. **The STATUS names stayed** — the `iron_will` and `undying_rage` chips are statuses,
named for what they do rather than for who applied them. The 154 log labels on dormant read sites cannot fire and were
left (§9).

## §6 — THE PROFILE WRITE, AND WHY NO FREEZE SAW IT

**The reconnaissance battery wrote the designer's `profile.json`.** It changed from md5 `b05e329b…` to `eac50650…`,
carrying a v3 fold: purses {cleric 66, hunter 68, mage 65, warrior 68}, cells emptied, version 3. The write happened
during the scene gates.

**The cause.** `check_ct_map.gd` and `check_map_screen.gd` call `Profile.set_flag("run_framing_seen")` with no
`save_path` redirect. The flag was already set, so for many batches every battery re-saved the file with
**byte-identical** content, and FI's, FQ's and FW's freezes each correctly read "unchanged". **FX's load-time fold
turned the same idempotent save into a destructive one.**

**The response:**

1. The written file was kept as evidence in the scratchpad.
2. The profile was restored from the verified backup, and md5 `b05e329b…` was re-confirmed.
3. Both gates were redirected to a scratch profile (`user://check_ct_map_profile.json`,
   `user://check_map_screen_profile.json`) that they delete on exit.
4. Both gates were re-run: the real file's md5 was unchanged, `check_map_screen` read OK and `check_ct_map` read
   83/0.

**The lesson is written to the working notes rather than to `CLAUDE.md`:** a hash freeze proves the bytes did not
change; it cannot prove nothing wrote them. Before a batch that changes a save format, sweep every target for calls
that reach a save writer and require a redirect in each.

## §7 — VERIFICATION

### 7a. THE NEGATIVE CONTROLS, EACH READ BY ITS FAIL TEXT

The controls ran in an out-of-repo copy that carries `.godot`, so the working tree was never touched. Each one
injected a single defect, asserted the injection landed, ran `check_fx`, and was restored by copy. Each restore was
proved by a diff against the working tree; run 2's three mismatches are explained below the table.

| # | The injection | Run 1 (493-check gate) | Run 2 (494-check gate) | What the FAIL text says |
|---|---|---|---|---|
| C0 | none | 493 / 0 | **494 / 0** | — |
| C1 | the fold SUMS instead of taking the max | 9 | **9** | Each class "folded to 188 — the highest of its three is 68 and the sum would be 188", its fold report, and "three Warrior purses of 3 folded to 9". |
| C2 | the spend gate always opens | 4 | **4** | Two intended arms: "tier 2 opened at rung 2 with 1 tier-1 cell owned", and "a Mage with rung 3 and no tier-1 cell bought into tier 2". Two cascades from that node already being owned. |
| C3 | a payload moves and its text does not | 1 | **1** | "tn_health's text does not say `+25% maximum Health` — its payload pays 0.25". |
| C4 | the Break read site pays nothing | 1 | **1** | "tn_break — the blow's Break read 18 against 18". |
| C5 | a class passive assigns over a node's field on the Mage | 1 | **1** | "tn_crit — `crit_bonus` on the mage moved by 0.0, not 0.15". |
| C6 | the Mana half of the lethal-hit node pays nothing | 1 | **1** | "a Mage paid 0 Mana and lost 40 health against 40" (the Rage half still passes). |
| C7 | a live rune reads a node through a condition | 1 | **1** | "1 rune payload(s) carry a condition — a rune reading a node". |
| C8 | the profile's floor did not move | 1 | **1** | "`MIN_VERSION` is still 1 — FX was to move it". |
| C9 | the zero-start trap: a node writes `parry_chance` instead of `parry_bonus` | 468 / 5 and **1 throw** | **493 / 7, 0 throws** | §1's missing text row; §4a's sentinel landing at +1.12 on all four classes; §4b's "the tree no longer writes parry_bonus"; the parry arm's "0 parries in 400". |
| C10 | none | 493 / 0 | **494 / 0** | — |

**C9 IS WHY THE GATE CHANGED BETWEEN THE RUNS.** In run 1 the injected field left §4b indexing a key no node wrote. The
gate threw there, so every node after Parry More went unread: 468 checks, a truncated gate that reads as fewer checks
rather than as the defect. §4b now names every field it drives once, reports any the tree stopped writing, and drives
that field at 0 so its own arm fails. C9 reads 493 rather than 494 because §1's text arm reports the missing row and then
skips the phrase comparison that needs it (`continue` after the failed `TEXT.has`), which was confirmed at the code.

**EVERY INJECTION LANDED, AND THE SCRIPT ASSERTED IT**: a control whose injection does not land tests nothing, so each
refuses to run on anything but exactly one match.

**IN RUN 2, THREE RESTORE LINES READ "RESTORE MISMATCH", AND THE RESTORES HAD WORKED.** The lead relabelled
`battle.gd` and `unit.gd` in the working tree while the controls ran in the copy.
- Both files in the copy are byte-identical to their own pre-control backups, and to the pre-relabel snapshot.
- The copy-versus-repo difference is exactly the relabel: 13 strings in `battle.gd` and 4 in `unit.gd`.
- `check_fx` reads none of those strings. Its parry arm tests only that the source label is non-empty.
- The copy was also renamed mid-run to give it its own `user://`, because the pre-pass battery was running
  concurrently. Before that, the two runs of this gate would have shared one scratch profile.

### 7b. THE UNMODIFIED GATES, BEFORE ANY WAS EDITED AND AGAIN AFTER `check_fx` EXISTED

**THE RECONNAISSANCE BATTERY RAN HEAD'S GATES, UNMODIFIED, AGAINST THE NEW TREE, BEFORE ANY GATE WAS EDITED.** Its
reds are §5's second list, and it is the run that wrote the designer's profile (§6).

**AFTER `check_fx` WAS WRITTEN, THE GATES THAT READ THE WHOLE CORPUS WERE RUN AGAIN, STANDALONE, OVER THE FINISHED
TREE:**
- `check_ed` read 18/0, after the pin manifest was regenerated (1,460 pins; its source-residency count shows one unresolved pin, and HEAD's count showed one too).
- `check_ec` read 23/0.
- `check_parse` read 182/0: 181 plus `check_fx.gd`, predicted before the run.
- `check_fg` read 22/0: both ceilings hold.

**THE PRE-PASS: A FULL BATTERY OVER THE FINISHED TREE, RUN TO FIND WHAT A NEEDLE SWEEP CANNOT.** 108 targets
launched.
- Every suite row read 0 failures and 0 throws, and every repaired suite landed on its predicted baseline.
- The run harness read 22 / 382 / 8.
- `check_cm_live` read its sanctioned 13 / 4.
- **The one exception was `check_fx`, and it was the runner rather than the gate.** The battery's 240-second watchdog
  killed it inside §4(b) with its log still growing and 0 script errors, so `check_de` read 449 / 4, and all four
  failures were `check_fx`'s unreadable count. **It is slow because it waits, not because it hangs.** Every blow it
  drives through `_resolve` pays the battle's real hit-animation pauses: `_wait()` awaits a timer unless `sim` is set,
  and §4 drives the nodes live on purpose. **It gets a measured per-target bound, `TMO[check_fx]` = 720 s**, which is CQ §1's answer for `check_map`. The
  measurement was a standalone run over the final tree: 354 s wall and 494 / 0, with §0–§4(a) done in about 3 s and
  the rest spent in §4(b) at a few percent CPU. The bound is about twice that. The gate is not switched to sim mode, because that would change what "every node pays,
  live" measures.

### 7c. THE ACCEPTANCE RUN OVER THE FINISHED TREE

**GREEN, WITH THE ONE SANCTIONED RED, OVER A TREE PROVEN FROZEN.** 108 targets launched, and none timed out.
- `check_de` read **449 / 0, with 0 notices**. Every target's check and failure counts matched its baseline, including
  the 44 rows FX moved and the one it added.
- `check_fx` read **494 / 0 with 0 throws**, inside its new 720-second bound.
- The run harness read **22 / 382 / 8**, with no throws.
- Every suite and every other gate read 0 failures and 0 throws. `check_cl_width` and `check_map_screen` completed;
  they print no count by design.
- **`check_cm_live` read its sanctioned 13 / 4.** All four failures are about the defensive bar: the bar appearing,
  the bar naming the blow, and the brace's two multipliers. FX's changes to `battle.gd` never reach that system.
  The hunks sit in the member summary, `_resolve`'s log strings and No Quarter's pool, `_resolve_special`, the boss
  resolution, the spawn, `_roll_parry`'s label, the evade source and one status text. No changed line names
  `_defensive_brace`, the skill check or anything defensive. The gate was not re-run at HEAD.

**THE TREE WAS FROZEN AROUND THE RUN, AND THE STAMP SAYS WHAT MOVED.** 386 files were hashed by absolute path
before the battery and again after it: every tracked and untracked file except the save backups, plus the four live
save files. Exactly three differ:
- `docs/changelog.html` corrects a wrong count ("two retired runes"). It was proven first on a scratch copy against
  all 13,106 suite and gate needles. It lost and gained nothing and grew 7 bytes.
- `docs/state.md` adds three rulings the queue was missing. It was proven the same way. It lost nothing, and gained
  four strings that no reader of state.md holds.
- This report, which no target reads.

**Neither battery wrote the four save files** (§4).

## §8 — WHAT MOVED

**GAME CODE, ELEVEN FILES.**
- `scripts/talents.gd` was rewritten: the one tree, both gates, buying-is-wearing.
- `scripts/profile.gd` was rewritten: v3, the class-keyed ledger, the fold and its refusals.
- `scripts/talents_screen.gd` was rewritten: four class purses, three tier bands, click to buy.
- `scripts/party_screen.gd`: the hero sheet draws the class tree, read-only, with the worn cells lit.
- `scripts/run_state.gd`: the handoff reads the spec's class; two comments updated.
- `scripts/run_sim.gd`: builds by tier through `DOD_SIM_TIERS`; `DOD_SIM_BUILDS` is retired with a warning.
- `scripts/battle.gd`:
  - No Quarter names the pool the hero holds.
  - The member summary gives a tier spread.
  - The end boss names the tier it opens.
  - Eleven log and source labels were relabelled.
  - Answering Steel's two chip texts were cut.
- `scripts/unit.gd`: Iron Will's chip text, and three relabelled log lines.
- `scripts/classes.gd`: `talent_granted_names` walks the one tree, and five card and passive texts were cut.
- `scripts/draft_screen.gd` and `scripts/map_screen.gd`: text only.

**DATA.** `data/glossary.json` has 45 edits: the talent entries are keyed to the class tree, and every clause naming a
deleted node is cut.

**DOCUMENTS.**
- `CLAUDE.md`:
  - The BM block.
  - A new standing rule for the one tree.
  - EN §3 and §4.
  - The DO banner.
  - The row-8 retirement.
  - The debug surfaces.
  - The UNIT_MATH bullet.
  - The note that other rules' node citations read as history.
  - The harness counts.
- `docs/master.html`: §7 was rewritten, 167 lines outside it were swept of deleted nodes, and the stamp moved.
- `docs/changelog.html`, `docs/design-notes.md` and `docs/state.md`.
- `docs/instrument-rules.md`: the sim bullets.
- `sim.sh`'s header.
- This report, which is new.

**INSTRUMENTS.**
- `check_fx.gd` is new: 494 checks.
- 39 suite files, including the run harness, were repaired to intent (§5).
- 13 gate files were repaired: nine battery gates, the three read-only residues, and `check_fs`, which went red on the
  §7 rewrite and was repaired by the lead.
- `check_ct_map.gd` and `check_map_screen.gd` write a scratch profile now (§6).
- `run_battery.sh`: `check_fx` joined `GATES`, and the harness header carries the new counts.
- `baselines.json`: 44 rows moved and one added. Each moved row's note names what moved it.
- `pin-manifest.json` was regenerated: 1,460 pins.

**NOT COMMITTED.** `save-backups/FX-20260910-231422/` holds the designer's four save files. It follows every batch's
backup: the folder has never been tracked, and it stays that way.

## §9 — FOUND AND NOT FIXED

**PLAYER-FACING, OR ABLE TO BECOME SO.**
- **The status NAMES keep their precedents' words: the `iron_will` chip "Iron Will" and the `undying_rage` chip
  "Undying Rage".** They are statuses, named for what they do, and the log lines beside them now name the node. Whether
  a chip should be renamed after the node that applies it is the designer's.
- **154 log labels, and a dozen status chips, sit on dormant read sites and still carry deleted nodes' names.** They
  cannot fire today, because nothing writes their fields. The list is in the master.html sweep's working
  (`flabels.out`). The day a tree, rune or card writes one of those fields again, its label is owed a look.
- **The "Builds with" lines in master.html §6 whose every partner was a deleted node were refilled with live cards**
  (for example Hoarfrost Armor → Killing Frost, Alms ↔ Divine Presence). That is card copy nobody chose, and it is worth
  the designer's read.

**DORMANT, BY DESIGN, AND COUNTED.**
- **275 of the 304 stat fields the twelve trees wrote have no writer now.** Every read site stands, for the next tree,
  rune or card.
- The consequences a player could meet:
  - The Devout's Faith lane is left with only the Binding Oath rune's opening Faith.
  - The Beastmaster's two-companion mode (`the_pack`) cannot be reached.
  - The Mercy line sits at half health always (`guardian_step` and `mercy_threshold` are unwritten).
  - Nothing buys the Bared Guard's cost back (`sm_def_stance`, EP §4).

**COMMENTS THAT NAME DELETED NODES.**
- About 349 comment lines in `scripts/` carry the retired vocabulary: lanes, capstones, rows and node names. They are
  mostly the SYNERGY and AXIS lines above each card in `classes.gd`, and `unit.gd`'s field headers.
- Named instances:
  - the `DOD_SIM_TALENTS` example at `battle.gd:1205`;
  - the Battle Shout tiers note at `battle.gd:208-219`;
  - the Iron Will note at `classes.gd` ~3003;
  - the Killing Frost collision note at ~3110;
  - `unit.gd:1114`'s "quadruple" (x3 since BI);
  - the "Richocet" misspelling at `battle.gd:8647` and `unit.gd:457`;
  - `Run._migrate_trees`' header, which says vanished points "are refunded".

**PRE-EXISTING, FOUND IN PASSING, NOT FX's.**
- **Suite checks that cannot fail** (§5): `test_batch_bw`'s kit sweep, two of `test_batch_bs`'s Forge Body checks,
  `test_batch_al`'s Toughness check, `test_batch_av`'s no-Mercy raise, and `test_batch_aw`/`ax`'s empty
  exclusive-reference loop.
- `test_rune_battle` and `test_batch_ay` call `_do_summon` without awaiting it. This is harness-only, and no game call
  site does it.
- `Talents.granted_ability` cannot see a node granting a card that is not a pending talent ability. The new
  `ability_names` checks do see it.
- Thirty-six retired runes carry `lane` tags naming deleted lanes. The data is inert, and nothing renders it.
  `CLAUDE.md`'s EM block still says the lane fields are "STILL SHOWN".
- **master.html, as the sweep found it:**
  - §3 says elites and mini-bosses pay a talent point, against §8.
  - §4.3's Seasoned Fighter "above/below half HP" has no health gate in the code.
  - The Parry Up row credits the retired Still Wrist rune.
  - Overcharge is "half" in §5.1 and "FULL" in §6.2.
  - §12 still says "talent-gated abilities".
- The glossary's elite and event talent-point claims, carried on FW's list.
- Four control copies left user-data folders under Godot's `app_userdata`: "DoD G2 curcopy", "DoD G2 headcopy",
  "DoD G6 ctlcopy" and "Dawn of Decay FX ctl". Each copy was renamed so that its `user://` could not reach the
  player's save folder. They are harmless and can be deleted.
