> **KEPT AS IR's CENSUS OF RECORD (ID §0.6: a census a later batch will be priced against is kept). IR's report §1d — every floor on a payout in the shipped game. Read against HEAD; IR fixed both DEFECT-SHAPE rows (Tithe, Sacred Resolve's split).** Written by a read-only reader; its scratch paths are not in the repository.

# Census 1d — every floor-of-a-positive-constant on a computed payout

**Read-only.** Nothing in `/Users/zipples/Documents/DoD/game` was edited, Godot was not run, and only read-only git commands were used (`git show HEAD:…`, `git diff`, `git log`).

## 0. The snapshot, and a warning about it

- **Line numbers are HEAD `11ef9fa`** ("Batch IQ: the three documents, and one crash", 2026-10-22 15:10). HEAD's `scripts/*.gd` were extracted to the scratchpad and scanned there.
- **Batch IR was editing the working tree during this census.** `scripts/battle.gd` changed at 15:30, 15:31, 15:39 and later. By 15:41 there were 8 files and +338/−61 uncommitted. At 15:41 I rescanned the working tree and compared floor expressions against HEAD. **Exactly one floor expression differs: Tithe.** IR §1d has added `var bc_bd := int(result.get("bd", pr))` and `if bc_pct > 0 and bc_bd > 0:` (working tree 12376-12377, floor at 12383). In the working tree Tithe is therefore already **GUARDED**. Every other floor in this census reads the same in HEAD and in the working tree; only the line numbers drift (by +6 to +44 in battle.gd).
- Unity's floor (DEFECT-SHAPE 2, below) was **untouched** in the working tree at 15:41 (line 12268 there).

## 1. Tithe, confirmed first (HEAD `scripts/battle.gd:12317-12344`)

```gdscript
if attacker.is_hero and not strike_target.is_hero and pr > 0:          # 12317 — Break CARRIED
    ...
    var bc_pct: int = attacker.blood_communion + attacker.rune_blood_communion   # 12332
    if bc_pct > 0:                                                               # 12333
        ...
        var bc_amt := maxi(int(round(
            result.get("bd", pr) * bc_pct / 100.0)), 1)                          # 12338-39 — Break LANDED, floored at 1
        var bc_got: int = bc_t.heal_amount(bc_amt, bc_t != attacker)
```

**The shape is confirmed.** The gate is `pr` (the Break the blow carried). The share is taken of `result.bd`, which is what `BattleUnit.take_hit` returns as `applied_bd` (unit.gd 4930-4967). When `applied_bd` is 0, `maxi(…, 1)` heals 1.

**Two owners share this site, and both have the same words:**
- Crest rune *Tithe*: `data/runes.json` `tithe` reads "A hero's attack that lands Break heals the hero furthest from full, for {rune_blood_communion}% of it." The payload is 30.
- The tree node *Blood Communion*: `scripts/talents.gd:155` reads "An attack that lands Break heals the hero furthest from full for {blood_communion}% of it." The payload is 20. This node is live in the one tree.

**What writes the Break landed to zero (unit.gd `take_hit`, HEAD), checked one by one:**

| case | the line that zeroes it | can Tithe's target be in this state? |
|---|---|---|
| **Broken target** | 4930-4932: `var applied_bd := 0` / `if not broken: applied_bd = pressure_add`. A Broken body takes no Break, so `applied_bd` stays 0. | **YES.** This is the common case: any attack on a Broken enemy. |
| **Bulwark** | 4902-4905: `if has_status("bulwark"): … pressure_add = 0` | **NO.** Bulwark of Fortitude is laid only on heroes (battle.gd 20125-20126 walks `heroes`). Tithe requires `not strike_target.is_hero`. |
| **Immovable** | 4913-4918: `if immovable > 0 and pressure_add > 0: … pressure_add = 0` | **NO.** It is a hero capstone, and the `immovable` field has **no writer anywhere** in `scripts/` or `data/` (DORMANT). |
| **Ironclad's cap** | 4948-4949: `applied_bd = maxi(applied_bd - (pressure - (stability - 1)), 0)`. At 99/100 the cap takes all of it. | **NO.** Ironclad is laid only on the casting hero (battle.gd 21994, `_apply_status(attacker, "ironclad", …)`). No enemy ability or carrier lays it. |
| **Deadened** (not in the brief) | 4910-4911: `if mod_no_break: pressure_add = 0` | **YES.** The live bargain `deadened` (run_state.gd 4742, severity 3) is stamped on **every** unit, enemies included (battle.gd 2150-2155 → 2230-2231). Under Deadened, every Break-carrying hero attack heals 1. |
| **Rounding** (not in the brief) | 4847: `round(pr * 100 / constitution)`. 4900: `pressure_add * mod_bd_mult / 100` (Muffled sets 75). | **YES, at the edges.** A small `pr` into a high-Constitution enemy, or `pr = 1` under Muffled, lands 0 and heals 1. |

**So the brief's four is right about Broken and wrong about the other three *at this read site*.** All three do zero `applied_bd`, but they are hero-side states and Tithe only fires on an enemy target. The reachable zero-paths are Broken, Deadened, and rounding. IR §1d's working-tree comment repeats the brief's four. IR's fix reads `result.bd`, so it closes every path anyway, but **the comment names three doors that cannot reach the site and omits Deadened.**

## 2. ID's Mirrorbound case, as it stands now

HEAD `battle.gd:13581-13583`:

```gdscript
recoil_pct += attacker.mod_recoil
if recoil_pct > 0.0 and not attacker.dead:
    var recoil := maxi(int(round(total_dealt * recoil_pct)), 1)
```

The **code is unchanged.** It still floors at 1 when `total_dealt` is 0, for example a vow-refused Cleric blow, or an enemy blow absolutely parried by a Feint charge. **ID repaired the words instead.** `run_state.gd:4754-4755` now reads: "An attack that does not miss sends a quarter of the damage it deals back on its attacker — at least 1, even when it deals none. On both sides." So for Mirrorbound this is **FLOOR-BY-DESIGN**.

The same line also bills the two native recoil cards, Arcane Cannon ("the Mage takes 15% of the damage dealt") and Magi's Wrath. For those, `total_dealt` is ≥1 whenever the line runs:
- a single-target miss takes the miss branch (9618) and never reaches this line;
- an `aoe` cast rolls no miss;
- every strike has the universal floor;
- the vow is Cleric-only.

So their words hold.

## 3. Method

- **Scanner.** It is written in Python. It strips comments, masks strings, bracket-matches across line continuations, and splits arguments at depth 0. It caught **every `maxi`/`maxf`/`max`/`clampi`/`clampf`/`clamp` call with a positive literal argument**. For a clamp, it counted the call when the lower bound is a positive literal. The first single-line pass missed 57 multi-line calls; the multi-line pass is the one used.
- **Coverage.** All of `scripts/*.gd`: 323 hits on 322 lines (227 `maxi`, 70 `maxf`, 20 `clampi`, 6 `clampf`). `unit.gd:3691` carries two.
- **Supplementary sweeps:**
  - `max*` calls whose floor is a **named constant or variable**: 52 calls; the floors among them are listed in §5;
  - two-line `if x <= 0: x = 1` idioms;
  - ternary `… else 1` idioms;
  - `ceil` was ruled out, because `ceil(0)` is 0.
- **Guard chains.** These were read with an indentation-walk extractor (enclosing `if`/`for`/`match`/`func` plus the early `return`/`continue` lines above the hit), then by hand. Callers were read where the guard sits outside (for example Arcane Echo's `if final > 0`, 13433-34).
- **Liveness.** I grepped every gating field against every payload in `data/runes.json` (live and retired separately), `scripts/talents.gd`, `scripts/classes.gd` and every assignment in `scripts/*.gd`. **DORMANT** means the field has no live writer, so the line cannot run in play.
- **Enemy resists.** I checked these because several floors re-floor after `(1 - resist)`. The highest enemy resist in `data/enemies.json` is **0.5**, so no `(1 - resist)` factor reaches zero for an enemy.

## 4. The table — one row per hit (HEAD 11ef9fa)

| file:line (HEAD 11ef9fa) | expression | owner | payout? | condition — can it be zero at the line? | guard (line) | words | CLASS |
|---|---|---|---|---|---|---|---|
| scripts/battle.gd:1732 | `clampi(Run.party[i]["hp"], 1, u.max_hp)` | spawn: saved hero hp | no (state clamp) | saved hp; 0 for a fallen hero, laid down after spawn (`_fallen_at_spawn`, 1731) | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:1909 | `maxi(int(OS.get_environment("DOD_SIM_ZONE")), 1)` | sim env (DOD_SIM_ZONE / DOD_SIM_BUDGET) | no | env parse | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:1927 | `maxi(int(OS.get_environment("DOD_SIM_BUDGET")), 1)` | sim env (DOD_SIM_ZONE / DOD_SIM_BUDGET) | no | env parse | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:1930 | `maxi(int(OS.get_environment("DOD_SIM_ZONE")), 1)` | sim env (DOD_SIM_ZONE / DOD_SIM_BUDGET) | no | env parse | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:1939 | `clampi(composition.size(), 1, 6)` | enemy layout index | no | composition size | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:1964 | `clampi(Run.slot_idx + 1, 1, Run.SLOTS_PER_ZONE)` | zone tier | no | slot index | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:2020 | `maxf(u.effective_speed(), 0.1)` | opening initiative | no (divisor guard) | speed | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:2184 | `maxi(mini(u.hp, int(round(u.max_hp * 0.7))), 1)` | Overgrown modifier | no (hp clamp on a cost) | 70% max hp clamp | - | "Both parties begin the fight at 70% health at most." | **NOT-A-PAYOUT** |
| scripts/battle.gd:2267 | `maxi(u.max_hp / 2, 1)` | Rot modifier | no (max-hp floor) | max_hp/2 | - | "Everyone's maximum health is halved" | **NOT-A-PAYOUT** |
| scripts/battle.gd:2270 | `clampi(u.hp, 1, u.max_hp)` | Rot modifier | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:2363 | `maxf(176.0, PLATE_FLOOR - total)` | enemy plate layout | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:2535 | `maxf(float(prof["sweep_time"]), 0.05)` | skill-check profile sanitiser | no | profile fields | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:2536 | `maxi(int(prof["presses"]), 1)` | skill-check profile sanitiser | no | profile fields | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:2541 | `clampf(float(prof["press_taper"]), 0.2, 1.0)` | skill-check profile sanitiser | no | profile fields | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:3093 | `maxi(u.status_stacks("poison"), 1)` | Poison DoT (`_dot_pass`) | stack count multiplying a tick | poison stacks; status present | `u.has_status(dot_id)` 3070 | - | **GUARDED** |
| scripts/battle.gd:3177 | `maxi(int(round( dot_dmg * 0.01 * h.ashen_skin_heal)), 1)` | Ashen Skin (talent field `ashen_skin_heal`) | heal | burn tick `dot_dmg` (pre-vow figure); 0 only at fire resist >= 1.0 (3110) — no enemy resist exceeds 0.5 | `h.ashen_skin_heal > 0` 3176 | node deleted at FX; field has NO writer (DORMANT) | **GUARDED** |
| scripts/battle.gd:3452 | `maxi(int(ren_stat.get("tick", 15)), 1)` | Renewal tick (Renewal, Dark Pact, Resurrection) | heal | snapshot `tick`; every writer floors it >= 1 (24472, 20184, 23890) | `has_status("renewal")` 3449 | "heal 15% of max health each turn" | **GUARDED** |
| scripts/battle.gd:3477 | `maxi(int(round(u.max_hp * 0.10)), 1)` | Bulwark of Fortitude tick | heal | 10% of max_hp (never 0) | `has_status("bulwark")` 3476 | "10% max health regained each turn" (chip 367) | **GUARDED** |
| scripts/battle.gd:3495 | `maxi(int(round(zl_dv.max_hp * 0.01 * (zl_dv.pulse_ranks + zl_dv.rune_pulse_ranks))), 1)` | Healing Pulse (pulse_ranks / rune_pulse_ranks) | heal | max_hp x ranks | ranks > 0, 3494 | talent deleted; only a RETIRED rune writes it (DORMANT) | **GUARDED** |
| scripts/battle.gd:3543 | `maxi(u.status_power("invig"), 1)` | Invigoration status | Mana | status power; only writer 20190 floors it >= 1 | `has_status("invig")` 3542 | DORMANT (`invigoration_ranks` has no writer) | **GUARDED** |
| scripts/battle.gd:3549 | `maxi(u.status_power("spirit_heal"), 1)` | Spirit Bond (delayed mend) | heal | status power = 10% max_hp at 23360 (> 0) | `has_status("spirit_heal")` 3548 | "...and 10% more next turn" | **GUARDED** |
| scripts/battle.gd:3555 | `maxi(u.status_power("spirit_mana"), 1)` | Spirit Bond (mana drip) | Mana | status power = 5% max_resource at 23362 | `has_status("spirit_mana")` and Mana 3554 | "5% on each of your next 2 turns" | **GUARDED** |
| scripts/battle.gd:3567 | `maxi(int(u.max_resource * 0.03 * u.living_flame_ranks), 1)` | Living Flame (living_flame_ranks) | Mana | max_resource x ranks | ranks > 0 3560; >= 3 burning 3566 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:3686 | `maxi(int(round(u.max_hp * sv2_pct / 100.0)), 1)` | Salve (2nd tick) | heal | `sv2_pct` (drawn off enemy statuses) | `sv2_pct <= 0` branch logs and skips, 3681 | card | **GUARDED** |
| scripts/battle.gd:3700 | `maxi(int(round(bc_h.max_hp * 0.05 * u.beacon_ranks * _healing_done_mult(u))), 1)` | Beacon (beacon_ranks) | heal | max_hp x ranks | ranks > 0 3697 | only a RETIRED rune writes it (DORMANT) | **GUARDED** |
| scripts/battle.gd:3808 | `clampi(u.hp, 1, u.max_hp)` | Vigor fading | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:3845 | `maxi(int(rc_h.max_resource * 0.01 * u.rallying_cry), 1)` | Rallying Cry (rallying_cry) | resource | max_resource x pct | rallying_cry > 0 3839; max_resource > 0 3843 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:4025 | `maxi(int(round(u.max_hp * Run.WASTING_PCT)), 1)` | Wasting modifier | damage (cost, both sides) | max_hp x WASTING_PCT (never 0) | `_modifier_is("wasting")` 4022 | "...loses N% of maximum health" | **GUARDED** |
| scripts/battle.gd:4291 | `maxi(int(round(ally.max_resource * 0.01 * u.cold_storage * held)), 1)` | Cold Storage (cold_storage) | resource | max_resource x holds | cold_storage > 0 and holds non-empty 4286; max_resource > 0 4289 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:4310 | `maxi(u.deadfall_armed, 1)` | Set and Forget re-arm | trap charge (1 trap back) | `trap_rearm` owed | `set_and_forget > 0 and trap_rearm > 0` 4308 | DORMANT (no writer); the payout IS one trap | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:4369 | `maxi(tick_b.status_power("spirit_heal"), 1)` | Spirit Bond (beast mend) | heal | status power 10% beast max_hp (23369) | has_status 4367 | card | **GUARDED** |
| scripts/battle.gd:4379 | `clampi(tick_b.hp, 1, tick_b.max_hp)` | Bestial Wrath fading | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:4387 | `clampi(tick_b.hp, 1, tick_b.max_hp)` | Vigor fading (beast) | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:4819 | `maxi(int(round(u.hp * 0.05)), 1)` | Entropy Toll (entropy_toll) | cost (self-damage, buys Resonance) | 5% of current hp (hp >= 1) | `if u.hp > toll` 4820 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:4833 | `maxi(int(round(u.max_hp * 0.01 * pp_pct * pp_uniques)), 1)` | Pleasure in Pain (pleasure_pct) | heal | unique enemy debuffs | pp_pct > 0 4830; pp_uniques > 0 4832 | only a RETIRED rune writes it (DORMANT) | **GUARDED** |
| scripts/battle.gd:4852 | `maxi(int(round(dp_t.max_hp * 0.01 * dp_pct * _healing_done_mult(u))), 1)` | Divine Presence (divine_presence_pct) | heal | max_hp x pct | dp_pct > 0 4847; target hurt 4851 | only a RETIRED rune writes it (DORMANT) | **GUARDED** |
| scripts/battle.gd:6447 | `maxi(int(round(c * u.mod_cost_mult)), 1)` | Warded modifier cost | no (price) | cost > 0 | `c > 0` 6446 | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6695 | `maxi(4, u.status_power("mirror"))` | `_recast_writes` prediction (Mirror Image) | no (refusal prediction; mirrors the handler) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6698 | `maxi(6, u.status_power("arrows"))` | `_recast_writes` prediction (Arcane Arrows) | no (refusal prediction; mirrors the handler) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6701 | `maxi(35, t.status_power("exhorted"))` | `_recast_writes` prediction (Exhortation) | no (refusal prediction; mirrors the handler) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6709 | `maxi(int(round(u.max_hp * 0.20)), 1)` | `_recast_writes` prediction (Magic Barrier) | no (refusal prediction; mirrors the handler) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6824 | `maxi(int(round(u.max_hp * VESPERS_PCT)), 1)` | `_recast_writes` prediction (Vespers) | no (refusal prediction; mirrors the handler) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6845 | `maxi(int(round(u.max_hp * MANTLE_PCT)), 1)` | `_recast_writes` prediction (Mantle) | no (refusal prediction; mirrors the handler) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:6892 | `maxi(want_turns + t.mod_status_turns, 1)` | `_status_write_improves` (Fleeting mirror) | no (prediction) | - | - | Fleeting: "(never below one)" | **NOT-A-PAYOUT** |
| scripts/battle.gd:7128 | `maxi(u.deadfall_network, 1)` | deadfall slot threshold | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:7537 | `maxi(int(ceil(float(rows) / float(BAR_PAGE_ROWS))), 1)` | ability-bar pager | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:7883 | `maxi(int(u.intent.get("turns", 1)), 1)` | intent hover | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:8332 | `maxi(int(u.intent.get("turns", 1)), 1)` | intent detail | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:9583 | `maxi(int(round(attacker.max_resource * 0.01 * attacker.holy_light_pct)), 1)` | Holy Light (holy_light_pct) | Mana | max_resource x pct | perfect and pct > 0 9581 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:10149 | `maxi(int(unkill_base * 0.08 * strike_target.unkillable_ranks), 1)` | Unkillable (unkillable_ranks) | heal | max_hp x ranks | ranks > 0 10146 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:10201 | `maxi(int(round( strike_target.max_hp * AEGIS_WALL_PCT)), 1)` | Aegis Wall (on block) | heal | max_hp x AEGIS_WALL_PCT (never 0); condition is the block, which happened | `has_status("aegis_wall")` 10200 inside the block branch 10027 | "every attack you BLOCK heals every hero for N% of your maximum health" | **GUARDED** |
| scripts/battle.gd:10244 | `maxi(int(round(tb_negated * TURN_THE_BLADE_SHARE)), 1)` | Turn the Blade | Break on the attacker | negated blow = ab.damage x attack x (1-armor) | `ab.damage > 0` 10241 | - | **GUARDED** |
| scripts/battle.gd:10370 | `maxi(int(round(ab.damage * 0.01 * attacker.attack * (1.0 - strike_target.effective_armor()))), 1)` | Feint charge return | damage to the attacker | ab.damage x attack x (1-armor) | `ab.damage > 0` 10369 | "returning its damage to the attacker" | **GUARDED** |
| scripts/battle.gd:10766 | `clampi(strike_target.hold_turns, 1, SHATTER_TURN_CAP)` | Shatter | multiplier (turns held) | `hold_turns`: 0 only within the turn of the freeze; `_hold_sync` (3292, 14713) adds 1 at the top of every turn before anyone acts | turn order (no route found that freezes and casts Shatter in one turn) | "PER TURN it spent frozen" | **GUARDED** |
| scripts/battle.gd:11623 | `maxf(1.0 - 0.01 * iw_pct, 0.1)` | Iron Will mitigation | no (multiplier floor 0.1) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:11718 | `maxf(1.0 - 0.01 * ma_c.mercy_aegis * ma_c.second_resource, 0.25)` | Mercy Aegis mitigation | no (multiplier floor 0.25) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:11972 | `maxi(int(round(raw * (1.0 - effective_armor))), 1)` | universal strike floor | damage | raw x (1-armor); raw > 0 on every strike (no ability reaches the loop with damage 0); an absolute parry is carved out (`0 if wall_parry`) | `wall_parry` 11971 | comment: "The universal floor of 1 yields to Untouchable's absolute parry." | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:12184 | `maxi(int(round(final * leech_pct)), 1)` | Ruin leech (Old Gods) | heal | final x leech_pct | `final > 0 and has_status("ruin")` 12168-69 (a vow-refused blow is final 0, 12152) | - | **GUARDED** |
| scripts/battle.gd:12217 | `maxi(int(round(final * 0.01 * mad_occ.cackling_ranks)), 1)` | Cackling Mirror (cackling_ranks) | heal | final | `final > 0` 12209; ranks > 0 12216 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:12230 | `maxi(int(round(final / float(bound.size()))), 1)` | Sacred Resolve (Unity split of a blow) | damage SHARE (cost on the four heroes) | `final` — 0 when the struck hero parries ABSOLUTELY (`final := 0 if wall_parry` 11971): a Feint charge (`parry_source == "Feint"`, 10353) or Untouchable | NONE for zero: only `has_status("unity")` 12226-27, `bound.size() > 1` 12229 | Sacred Resolve: "all damage received is split evenly among them"; Feint: "each parrying an attack outright and returning its damage to the attacker" | **DEFECT-SHAPE** |
| scripts/battle.gd:12255 | `maxi(int(round( final * 0.60 * sf_w.steadfast_ranks)), 1)` | Steadfast (steadfast_ranks) | absorb | final | `final > 1` 12250 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:12338 | `maxi(int(round( result.get("bd", pr) * bc_pct / 100.0)), 1)` | TITHE (crest rune, `rune_blood_communion`) + Blood Communion talent node (`blood_communion`) | heal | `result.bd` — Break the meter TOOK (unit.gd 4930-4949): 0 on a Broken target (4931) and under Deadened (4910-11, a live bargain stamped on enemies, battle 2230-31); Bulwark (4902-05), Immovable (4913-18) and Ironclad's cap (4948-49) also zero it but cannot reach Tithe's ENEMY target; also 0 when constitution or Muffled rounds a small `pr` away (4847, 4900) | `pr > 0` 12317 (Break CARRIED, not landed); `bc_pct > 0` 12333 | rune: "A hero's attack that lands Break heals the hero furthest from full, for 30% of it."; node (talents.gd 155): "An attack that lands Break heals the hero furthest from full for 20% of it." | **DEFECT-SHAPE** |
| scripts/battle.gd:12497 | `maxi(int(round(final * cg_pct)), 1)` | Consecrated Ground reflect | damage | final | `final > 0` 12492 | - | **GUARDED** |
| scripts/battle.gd:12527 | `maxi(int(round(cg_landed * 0.01 * (cg_dv.lifewell_ranks + cg_dv.rune_lifewell_ranks))), 1)` | Lifewell | heal | reflect landed | `cg_landed > 0` 12525 | only a RETIRED rune writes the rune half (DORMANT) | **GUARDED** |
| scripts/battle.gd:12540 | `maxi(int(round(final * 0.01 * cg_dv.judgement)), 1)` | Judgement (judgement) | Break | final | `final > 0` 12492; judgement > 0 12538 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:12563 | `maxi(int(round(final * 0.01 * attacker.temporal_ranks)), 1)` | Temporal rift (temporal_ranks) | damage | final — 0 only for a vow-refused blow, and the rift's own take_hit is then refused by the same vow gate | is_crit and ranks > 0 12559 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:12622 | `maxi(int(round(attacker.rune_rending_blows)), 1)` | Rending Blows rune | Sunder depth cap | rune figure | `rune_rending_blows > 0.0` 12619 | rune | **GUARDED** |
| scripts/battle.gd:13083 | `maxi(int(round( final * 0.30 * strike_target.spite_ranks)), 1)` | Spite (spite_ranks) | damage | final | `final > 0` 13080 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:13087 | `maxi(int(round(spite_dmg * 0.5)), 1)` | Spite rider | Break | spite_dmg (>= 1) | `spite_break > 0` 13086 | DORMANT | **GUARDED** |
| scripts/battle.gd:13316 | `maxi(int(round(ab.damage * cat_mult)), 1)` | Cataclysm (cataclysm) | damage | ab.damage x 0.6 (Detonation damage > 0) | cataclysm > 0 13297 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:13557 | `maxi(int(h.max_resource * stomp_pct), 1)` | War Stomp | resource | max_resource x 10/20% | `resource_name == ""` skipped 13555 | card | **GUARDED** |
| scripts/battle.gd:13583 | `maxi(int(round(total_dealt * recoil_pct)), 1)` | Recoil: Mirrorbound (mod_recoil) + Arcane Cannon / Magi's Wrath (recoil_base) | damage (cost) | `total_dealt` — 0 when every blow was refused or zeroed: a Vow-of-Silence Cleric under Mirrorbound, or an enemy blow absolutely parried (Feint charge) under Mirrorbound. For the two Mage cards it is >= 1 whenever the line runs (single-target miss branch 9618 never reaches it; aoe rolls no miss; strike floor; the vow is Cleric-only) | `recoil_pct > 0.0` 13582 only | Mirrorbound (run_state.gd 4754-55): "...a quarter of the damage it deals back on its attacker — at least 1, even when it deals none. On both sides."; Arcane Cannon: "the Mage takes 15% of the damage dealt" | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:13595 | `maxi(int(round(out / float(bl_targets.size()))), 1)` | Blowback each | damage | out | `out > 0` 13593 | DORMANT (`blowback` no writer) | **GUARDED** |
| scripts/battle.gd:13611 | `maxi(int(round(recoil / float(bound.size()))), 1)` | Unity split of recoil | damage share (cost) | recoil — >= 1 from 13583 unless Blowback zeroed it (13605); Blowback is DORMANT | `bound.size() > 1` 13610 | Sacred Resolve split | **GUARDED** |
| scripts/battle.gd:13654 | `maxi(int(round(total_dealt * 0.01 * attacker.siphon_ranks)), 1)` | Siphon (siphon_ranks) | Mana | total_dealt | `total_dealt > 0` 13652 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:13671 | `maxi(int(total_dealt * attacker.rune_lifesteal), 1)` | Vampiric rune (rune_lifesteal) | heal | total_dealt | `total_dealt > 0` 13670 | only a RETIRED rune writes it | **GUARDED** |
| scripts/battle.gd:13679 | `maxi(int(missing_hp * drain_frac), 1)` | heal_missing (Drain-type card, classes.gd 6853) | heal | missing hp | `missing_hp > 0` 13678 | card | **GUARDED** |
| scripts/battle.gd:13877 | `maxi(int(round(sp_raw * (1.0 - sp_t.effective_armor()))), 1)` | Spray (spray) | damage | ab.damage x attack | sp_pool non-empty 13871 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:14012 | `maxi(int(total_dealt * 0.75), 1)` | Tripwire retaliation | damage | total_dealt | `total_dealt > 0` 14003 | card | **GUARDED** |
| scripts/battle.gd:14048 | `maxi(int(round(total_dealt * 0.01 * chan_r)), 1)` | Corrupted Channeling (channeling_ranks) | heal | total_dealt | `total_dealt > 0` 14045 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:14064 | `maxi(int(round(attacker.max_resource * 0.01 * attacker.charged_bolts_ranks * float(attacker.second_resource / 4))), 1)` | Charged Bolts (charged_bolts_ranks) | Mana | Resonance / 4 | `second_resource >= 4` 14063 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:14509 | `maxi(int(round(e.max_hp * 0.01 * caster.rune_killing_cold * kc_stacks)), 1)` | Killing Cold rune | damage | max_hp x stacks | `rune_killing_cold <= 0` exit 14500; `kc_stacks < 4` continue 14507 | rune | **GUARDED** |
| scripts/battle.gd:14538 | `maxi(int(round(gl_h.max_resource * 0.01 * gl_h.glacial_ranks)), 1)` | Glacial Economy (glacial_ranks) | Mana | max_resource x ranks | `_living_hero_with("glacial_ranks")` 14536 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:14633 | `maxf(target.effective_speed(), 0.1)` | hold release reschedule | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:14658 | `maxf(e.effective_speed(), 0.1)` | Shockwave reschedule | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:15311 | `maxi(int(cp.get("stacks", 1)), 1)` | Creeping Death (stack count) | poison stack +1 | stacks of a standing poison | poison present 15298 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:15372 | `maxi(int(round(pct * 0.01 * applier.attack)), 1)` | `_dot_tick` (Burn/Bleed/etc. tick size) | DoT tick | pct x applier.attack (attack > 0) | applier non-null 15367 | - | **GUARDED** |
| scripts/battle.gd:15868 | `maxi(int(round(final * ARCANE_ARROW_SPLASH)), 1)` | Arcane Arrows splash | damage | final x ARCANE_ARROW_SPLASH | `final <= 0` exit 15860 | "strikes an additional random enemy for half damage" | **GUARDED** |
| scripts/battle.gd:15869 | `maxi(int(round(splash * (1.0 - float(victim.resists.get("arcane", 0.0))))), 1)` | Arcane Arrows splash (resist) | damage | splash x (1 - arcane resist); 0 only at resist 1.0 — no enemy exceeds 0.5 | as 15868 | - | **GUARDED** |
| scripts/battle.gd:15915 | `maxi(int(round(final * CROSSFIRE_SHARE)), 1)` | Crossfire splash | damage | final x CROSSFIRE_SHARE | `final <= 0` exit 15902 | - | **GUARDED** |
| scripts/battle.gd:15916 | `maxi(int(round(splash * (1.0 - float(victim.resists.get("physical", 0.0))))), 1)` | Crossfire splash (resist) | damage | physical resist < 1.0 | as 15915 | - | **GUARDED** |
| scripts/battle.gd:15967 | `maxi(int(round(landed * 0.5)), 1)` | Umbral Sigil echo | damage | landed | `landed <= 0` exit 15965 | - | **GUARDED** |
| scripts/battle.gd:16015 | `maxi(int(round(final * ARCANE_ECHO_SHARE)), 1)` | Arcane Echo repeat | damage | final | caller `if final > 0` 13433-34 | - | **GUARDED** |
| scripts/battle.gd:16016 | `maxi(int(round(echo * (1.0 - float(mark.resists.get("arcane", 0.0))))), 1)` | Arcane Echo repeat (resist) | damage | arcane resist < 1.0 | as 16015 | - | **GUARDED** |
| scripts/battle.gd:16282 | `maxi(int(round(lost * 0.01 * Classes.JUDGMENT_HEAL_PCT)), 1)` | Judgment rule engine | heal | lost | `lost <= 0` exit 16252 | engine text: heal a share of damage dealt to the judged | **GUARDED** |
| scripts/battle.gd:16376 | `maxi(int(round(pick.max_hp * 0.01 * Classes.FIELD_KIT_HEAL_PCT)), 1)` | Field Kit (Medic rule engine) | heal | max_hp x FIELD_KIT_HEAL_PCT (never 0) | pool non-empty 16373 | - | **GUARDED** |
| scripts/battle.gd:16435 | `maxf(basic.damage * 0.01 * u.attack, 1.0)` | bot Redoubt pick | no (bot threshold) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:16517 | `maxi(int(round(prevented)), 1)` | Forge Body throw | damage | prevented (float) | `prevented <= 0.0` exit 16512 | - | **GUARDED** |
| scripts/battle.gd:16616 | `maxi(int(round(back * 0.01 * u.rune_pyre_debt)), 1)` | Pyre Debt rune | damage (cost) | Mana refunded `back` | `back <= 0` exit 16607 | rune | **GUARDED** |
| scripts/battle.gd:17342 | `maxi(int(round(cleric.max_hp * 0.01 * cleric.grace_pct * _healing_done_mult(cleric))), 1)` | Grace spill (grace_pct) | heal | max_hp x pct | `grace_pct <= 0` exit 17340 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:17366 | `maxi(int(round(cleric.max_hp * 0.01 * maxi(cleric.status_power("alms"), 1))), 1)` | Alms spill | barrier | max_hp x alms power | `has_status("alms")` 17364 | "absorbing 12% of your maximum health" | **GUARDED** |
| scripts/battle.gd:17367 | `maxi(cleric.status_power("alms"), 1)` | Alms power | barrier % | status power = ALMS_WARD_PCT 12 (22574) | as 17366 | - | **GUARDED** |
| scripts/battle.gd:17503 | `maxi(int(saved.max_hp * 0.5), 1)` | Rite of Return | restore hp | 50% max_hp | rite status 17490ff | card | **GUARDED** |
| scripts/battle.gd:17509 | `maxi(int(round(cleric.max_hp * 0.30)), 1)` | Rite of Return toll | cost | 30% cleric max_hp | - | card | **GUARDED** |
| scripts/battle.gd:17585 | `maxi(int(round(amount * share_pct / 100.0)), 1)` | Blood Bond guard | damage share (cost) | amount | `amount <= 0` exit 17572 | card | **GUARDED** |
| scripts/battle.gd:17665 | `maxi(int(round(amount * share_pct / 100.0)), 1)` | Bear's Brunt / Answering Pack | damage share (cost) | amount | `amount <= 0` exit 17627 | card / rune | **GUARDED** |
| scripts/battle.gd:18043 | `maxi(int(round(ab.damage * 0.01 * attacker.attack * (1.0 - defender.effective_armor()) * 0.01 * defender.rune_mirror_guard)), 1)` | Mirror Guard rune | damage | ab.damage x attack | `ab.damage <= 0` exit 18041 | rune | **GUARDED** |
| scripts/battle.gd:18242 | `maxi(int(round(occ.max_hp * 0.01 * mi_ranks)), 1)` | Murderous Intent (murderous_ranks) | heal | occultist max_hp x ranks | mi_ranks > 0 18238 | DORMANT | **GUARDED** |
| scripts/battle.gd:18667 | `maxi(int(round(det_raw * (1.0 - resist))), 1)` | Ruin detonation (Old Gods) | damage | 0.9 x attack x (1 - shadow resist); resist <= 0.25 | - | - | **GUARDED** |
| scripts/battle.gd:18694 | `maxi(int(round(occ.max_hp * 0.25)), 1)` | Wrath of the Old Gods party heal | heal | 25% occultist max_hp | - | - | **GUARDED** |
| scripts/battle.gd:19038 | `maxi(h.max_hp, 1)` | Mantle hop pick | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:19039 | `maxi(pick.max_hp, 1)` | Mantle hop pick | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:19044 | `maxi(int(broke.get("original", 0)), 1)` | Mantle hop barrier | barrier | broken barrier's `original` (Mantle writes >= 1, 22720) | hops > 0 19028; pick 19041 | card | **GUARDED** |
| scripts/battle.gd:19180 | `maxi(int(round(u.max_hp * (0.15 + 0.01 * (devout.faithful_step + devout.rune_faithful_step)))), 1)` | Faith release heal | heal | 15% max_hp + steps | release reached | engine | **GUARDED** |
| scripts/battle.gd:19194 | `maxi(int(round(devout.max_resource * 0.03)), 1)` | Faith release Devout Mana | Mana | 3% max_resource | as 19180 | - | **GUARDED** |
| scripts/battle.gd:19295 | `maxi(int(round(devout.conviction_base_hp * pct)), 1)` | Conviction growth | max hp | base hp x pct | - | engine | **GUARDED** |
| scripts/battle.gd:19368 | `maxi(int(round(u.max_hp * cn_pct)), 1)` | Consecration drip | heal | max_hp x CONSECRATION_PCT | `has_status("consecration")` 19358 | card | **GUARDED** |
| scripts/battle.gd:19404 | `maxi(int(round(bg_base * (1.0 - float(bg_e.resists.get("holy", 0.0))))), 1)` | Burning Ground rune | damage | max_hp x rune; holy resist <= 0.25 | `rune_burning_ground <= 0.0` exit 19396 | rune | **GUARDED** |
| scripts/battle.gd:19461 | `maxi(int(rb.get("stacks", 1)), 1)` | Returned Burden (stacks re-laid) | status stacks | stacks of an effect the hero carried | - | rune | **GUARDED** |
| scripts/battle.gd:19565 | `maxi(int(round(saved.max_hp * 0.01 * devout.covenant_heal)), 1)` | Sacred Covenant heal | heal | max_hp x covenant_heal | `covenant_heal <= 0` exit 19563 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:19571 | `maxi(devout.covenant_faith, 1)` | Sacred Covenant Faith | Faith | `covenant_faith` — not the gated field | gated on `covenant_heal` (19563), NOT on covenant_faith | DORMANT: neither field has a writer; latent (a payload writing heal alone would pay 1 Faith) | **GUARDED** |
| scripts/battle.gd:19748 | `clampf(u.position.distance_to(dest) / 650.0, 0.2, 1.1)` | walk tween | no (animation) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:19922 | `maxi(attacker.hp - sacrifice, 1)` | Phoenix sacrifice | no (hp clamp on a cost) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:20089 | `maxi(int(round( attacker.max_hp * 0.01 * attacker.purity_ranks)), 1)` | Purity (purity_ranks) | barrier | max_hp x ranks | ranks > 0 20088 | DORMANT | **GUARDED** |
| scripts/battle.gd:20134 | `maxi(int(round(h.max_hp * 0.05)), 1)` | Bulwark of Fortitude cast heal | heal | 5% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:20161 | `maxi(int(round(attacker.max_hp * pact_pct)), 1)` | Dark Pact toll | cost | max_hp x pact_pct | `pact_pct > 0.0` 20160 | card | **GUARDED** |
| scripts/battle.gd:20163 | `maxi(attacker.hp - pact_cost, 1)` | Dark Pact toll | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:20176 | `maxi(int(round(h.max_hp * pact_heal_pct)), 1)` | Dark Pact party heal | heal | max_hp x 15%+ | - | card | **GUARDED** |
| scripts/battle.gd:20184 | `maxi(int(round(attacker.max_hp * 0.10)), 1)` | Dark Pact self-renewal tick | heal | 10% max_hp | - | "restores N HP ... (10% of max health)" | **GUARDED** |
| scripts/battle.gd:20190 | `maxi(int(round(attacker.max_resource * 0.01 * attacker.invigoration_ranks)), 1)` | Invigoration tick | Mana | max_resource x ranks | ranks > 0 20189 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:20365 | `maxi(int(round(cf_raw * (1.0 - foe.effective_armor()))), 1)` | Cinderfall | damage | ab.damage x attack x Overburn mult (>= 1); fire resist <= 0.5 | - | card | **GUARDED** |
| scripts/battle.gd:20442 | `maxi(held.hold_turns, 1)` | Winter's Toll | multiplier (turns held) | `hold_turns`: 0 only within the freeze's own turn (see 10766) | turn order | "takes N% of Attack for every turn it has spent in the ice" | **GUARDED** |
| scripts/battle.gd:20445 | `maxi(int(round(wt_raw * (1.0 - held.effective_armor()))), 1)` | Winter's Toll strike | damage | raw > 0 | - | - | **GUARDED** |
| scripts/battle.gd:20615 | `maxi(int(round(th_raw * (1.0 - target.effective_armor()))), 1)` | Twin Hunt strike | damage | ab.damage x attack | target alive 20602 | card | **GUARDED** |
| scripts/battle.gd:20788 | `maxi(int(round(attacker.hp * 0.20)), 1)` | Blood Offering price | cost | 20% current hp | - | card | **GUARDED** |
| scripts/battle.gd:20790 | `maxi(attacker.hp - bo_cost, 1)` | Blood Offering price | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:20830 | `maxi(int(round(gr_raw * (1.0 - target.effective_armor()))), 1)` | Gut Rip | damage | bleed held `gr_had` | explicit `... if gr_had > 0 else 0` on the same line | card — the REPAIRED shape: the floor is suppressed at zero | **GUARDED** |
| scripts/battle.gd:20985 | `maxi(int(round(ps_raw * (1.0 - ps_armor))), 1)` | Precision Strike strikes | damage | raw > 0 | target alive 20978 | card | **GUARDED** |
| scripts/battle.gd:21023 | `maxi(int(round(ft_raw * (1.0 - target.effective_armor()))), 1)` | Feint strike (Aggressive) | damage | FEINT_STRIKE_PCT x attack | target alive 21019 | card | **GUARDED** |
| scripts/battle.gd:21197 | `maxi(int(round(ss_raw * (1.0 - target.effective_armor()))), 1)` | Shield Slam | damage | max_hp x pct | target alive 21192 | card | **GUARDED** |
| scripts/battle.gd:21272 | `maxi(int(round(attacker.max_hp * AEGIS_WALL_PCT)), 1)` | Aegis Wall chip text | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:21279 | `maxi(int(round(attacker.max_hp * AEGIS_WALL_PCT)), 1)` | Aegis Wall log | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:21560 | `maxi(int(round(attacker.max_hp * mb_pct)), 1)` | Magic Barrier | barrier | 20% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:21593 | `maxi(4, attacker.status_power("mirror"))` | Mirror Image | charges | card's own count 4 (re-cast takes the higher) | - | "Step behind four copies of yourself" | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:21703 | `maxi(int(round(target.max_hp * mn_pct * _healing_done_mult(attacker) * (1.0 + attacker.rune_eleventh_hour if mn_eleventh else 1.0))), 1)` | Ministration | heal | max_hp x pct | target alive 21695 | card | **GUARDED** |
| scripts/battle.gd:21837 | `maxi(int(round(attacker.max_hp * fd_pct)), 1)` | Field Dressing | heal | 18/24% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:21910 | `maxi(6, attacker.status_power("arrows"))` | Arcane Arrows | charges | card's own count 6 (re-cast takes the higher) | - | "Quench six arrows" | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:21944 | `maxi(int(target.max_resource * 0.15), 1)` | Rally (ally) | resource | 15% max_resource | `resource_name != ""` 21943 | card | **GUARDED** |
| scripts/battle.gd:22126 | `maxi(int(round(kf_raw * (1.0 - foe.effective_armor()))), 1)` | Killing Frost | damage | raw > 0; frost resist < 1 | chilled 22121 | card | **GUARDED** |
| scripts/battle.gd:22307 | `maxi(int(round(pw_raw * (1.0 - pw_mark.effective_armor()))), 1)` | Pyre Wake | damage | raw x Overburn mult (>= 1) | - | card | **GUARDED** |
| scripts/battle.gd:22594 | `maxi(int(round(attacker.max_hp * VESPERS_PCT)), 1)` | Vespers | absorb power | max_hp x VESPERS_PCT | - | card | **GUARDED** |
| scripts/battle.gd:22696 | `maxi(int(round(attacker.max_hp * jb_pct * jb_stacks)), 1)` | Blessing of the Faithful (Jubilee) heal | heal | Faith stacks | `faith_stacks < JUBILEE_MIN_FAITH` refuses 22671 | card | **GUARDED** |
| scripts/battle.gd:22700 | `maxi(int(round(attacker.max_resource * 0.03 * jb_stacks)), 1)` | Blessing of the Faithful Mana | Mana | Faith stacks | as 22696 | card | **GUARDED** |
| scripts/battle.gd:22720 | `maxi(int(round(attacker.max_hp * MANTLE_PCT)), 1)` | Mantle | barrier | max_hp x MANTLE_PCT | living Devout 22715 | card | **GUARDED** |
| scripts/battle.gd:22786 | `maxi(int(round(rq_raw * (1.0 - target.effective_armor()))), 1)` | Requiem | damage | Ruin stacks | `rq_stacks <= 0` refuses 22765 | card | **GUARDED** |
| scripts/battle.gd:22796 | `maxi(int(round(attacker.max_hp * 0.02 * rq_stacks)), 1)` | Requiem party share | heal | Ruin stacks | as 22786 | card | **GUARDED** |
| scripts/battle.gd:23018 | `maxi(int(round(cu_raw * (1.0 - cu_e.effective_armor()))), 1)` | Cull | damage | afflictions removed `cu_n` | `_harvest_yield(target) <= 0` refuses 22977; cu_n is the purge's own count (or the yield, Full Board) | "10% of Attack in nature damage per status removed" | **GUARDED** |
| scripts/battle.gd:23254 | `maxi(int(round(hv_raw * (1.0 - target.effective_armor()))), 1)` | Harvest | damage (+ heal) | afflictions removed `hv_n` | `hv_n <= 0` refuses 23158; hv_n re-read as the purge's count | "12% of Attack per status REMOVED, and you heal the same amount" | **GUARDED** |
| scripts/battle.gd:23450 | `maxi(int(round(attacker.hp * 0.075)), 1)` | Blood Price | cost | 7.5% current hp | - | card | **GUARDED** |
| scripts/battle.gd:23483 | `maxi(int(round(bp_payer.hp * 0.075)), 1)` | Blood Debt rune (payer's price) | cost (on the payer) | 7.5% of payer's hp | `bp_debt` 23482 | rune | **GUARDED** |
| scripts/battle.gd:23492 | `maxi(bp_payer.max_hp, 1)` | Blood Debt Rage-equivalent | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:23513 | `maxi(attacker.hp - bp_cost, 1)` | Blood Price | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:23890 | `maxi(int(round(attacker.max_hp * 0.15 * _healing_done_mult(attacker))), 1)` | Resurrection (empowered renewal tick) | heal | 15% max_hp | empowered 23889 | card | **GUARDED** |
| scripts/battle.gd:23956 | `maxi(int(round(target.max_hp * 0.20)), 1)` | Wild Growth (enemy) | heal | 20% max_hp | - | enemy ability | **GUARDED** |
| scripts/battle.gd:24076 | `maxi(int(round(tp_a.max_hp * 0.06)), 1)` | Totem Pulse (enemy) | heal | 6% max_hp | - | enemy ability | **GUARDED** |
| scripts/battle.gd:24134 | `maxi(int(round(wf_raw * (1.0 - foe.effective_armor()))), 1)` | Wildfire | damage | raw > 0 | burning foe 24115 | card | **GUARDED** |
| scripts/battle.gd:24279 | `maxf(cc_from.effective_speed(), 0.1)` | Cryoclasm reschedule | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:24312 | `maxi(int(round(attacker.max_hp * 0.05)), 1)` | Stabilize heal | heal | 5% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:24346 | `maxi(int(round(attacker.max_hp * 0.40 * _healing_done_mult(attacker) * hh_crit)), 1)` | Heal (holy_heal) | heal | 40% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:24380 | `maxi(int(round(attacker.max_hp * 0.05)), 1)` | Heal perfect self | heal | 5% max_hp | perfect 24379 | card | **GUARDED** |
| scripts/battle.gd:24460 | `maxi(int(round(target.max_hp * 0.25)), 1)` | Healing Wave (enemy) | heal | 25% max_hp | - | enemy ability | **GUARDED** |
| scripts/battle.gd:24472 | `maxi(int(round(attacker.max_hp * 0.15 * _healing_done_mult(attacker))), 1)` | Renewal | heal tick | 15% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:24494 | `maxi(int(round(attacker.max_hp * 0.05 * rb_crit)), 1)` | Renewal perfect burst | heal | 5% max_hp | perfect 24490 | card | **GUARDED** |
| scripts/battle.gd:24526 | `maxi(int(round(target.max_resource * rc_pct)), 1)` | Recant | resource | 40% max_resource | `max_resource <= 0` refuses 24517 | card | **GUARDED** |
| scripts/battle.gd:24550 | `maxi(int(round(attacker.max_hp * 0.25)), 1)` | Shared Grief price | cost | 25% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:24579 | `maxi(attacker.hp - sg_cost, 1)` | Shared Grief price | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:24614 | `maxi(int(round(rp_raw * (1.0 - target.effective_armor()))), 1)` | Reprisal | damage | healing in the last two turns `rp_healed` | no-healing branch refuses 24608 | card | **GUARDED** |
| scripts/battle.gd:24674 | `maxi(int(round(attacker.max_hp * 0.10)), 1)` | Fortified Spirit step | max hp lent | 10% max_hp | - | card | **GUARDED** |
| scripts/battle.gd:24715 | `maxi(int(round(attacker.max_hp * rq_pct * rq_h.faith_peak)), 1)` | Reliquary | heal | faith_peak | `faith_peak <= 0` continue 24713 | card | **GUARDED** |
| scripts/battle.gd:24746 | `maxi(int(round(su_raw * (1.0 - target.effective_armor()))), 1)` | Suffering strike | damage | ab.damage x attack | - | card | **GUARDED** |
| scripts/battle.gd:25094 | `maxf(float(wounded), 0.5)` | bot boon worth | no (bot) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:25549 | `maxi(int(round(raw * (1.0 - gh_armor))), 1)` | ghost strike (Pack Bond) | damage | dmg from callers (> 0) | victim alive 25520 | - | **GUARDED** |
| scripts/battle.gd:25803 | `maxi(int(round(raw * (1.0 - comp_armor))), 1)` | companion strike | damage | dmg from callers (> 0) | victim alive 25718 | - | **GUARDED** |
| scripts/battle.gd:26022 | `maxi(int(round(0.03 * src.attack)), 1)` | Poison tick base | DoT tick | 3% attack (floor keeps a small Attack from rounding away — its own comment 26031) | - | - | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:26055 | `maxi(int(ceil(tick / 2.0)), 1)` | Slow Acting (half tick) | DoT tick | tick — 0 under Thin Blood (26051) and the floor would re-raise it to 1 | `slow_acting > 0` 26054; the status door re-zeroes a Thin Blood poison anyway (`hw_thin`, 14902-05) | DORMANT (`slow_acting` has no writer); Thin Blood: "His Poison deals NO damage" | **GUARDED** |
| scripts/battle.gd:26156 | `maxi(int(ps.get("tick", 0)), 1)` | Perfected Toxin chip | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:26157 | `maxi(int(ps.get("stacks", 1)), 1)` | Perfected Toxin chip | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:26179 | `maxi(int(trapper.attack * (0.25 + 0.01 * (trapper.wire_ranks + trapper.rune_wire_ranks)) * (1.0 + 0.01 * (trapper.cruel_ranks + trapper.rune_cruel_ranks))), 1)` | The Whole Forest bite | damage | attack x pct | `whole_forest == 0` continue 26175 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:26261 | `maxi(u.max_hp - shed, 1)` | Fortified Spirit expiry | no (max-hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:26275 | `maxi(int(round(float(left) / float(step))), 1)` | Fortified Spirit chip | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:26297 | `maxi(u.status_power("suffering"), 1)` | Suffering tick | Ruin | status power su_rate >= 2 (24800) | `has_status("suffering")` 26295 | "gains 2 Ruin at the start of each of ITS turns" | **GUARDED** |
| scripts/battle.gd:26308 | `maxi(int(round(u.max_hp * BATTLE_TRANCE_FLOOR)), 1)` | Battle Trance floor | heal | max_hp x BATTLE_TRANCE_FLOOR — the card's own floor term | has_status 26304 | "heal N% of maximum health PLUS HALF of all damage taken" | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:26453 | `maxi(int(round(tr_raw * (1.0 - victim.effective_armor()))), 1)` | trap spring | damage | dmg | `dmg > 0.0` 26448 | - | **GUARDED** |
| scripts/battle.gd:26554 | `clampi(1 + u.rune_long_draw_presses + int(u.second_resource / SS_SEQ_STEP), 1, SS_SEQ_MAX_PRESSES + u.rune_long_draw_presses)` | sequence presses | no (press count) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:27210 | `maxi(int(victim.max_hp * pact_pct), 1)` | bleedout | damage | max_hp x pct | - | - | **GUARDED** |
| scripts/battle.gd:27214 | `maxi(int(round(bleed_dmg / float(bound.size()))), 1)` | Unity split of a bleedout | damage share | bleed_dmg >= 1 | `bound.size() > 1` 27213 | Sacred Resolve split | **GUARDED** |
| scripts/battle.gd:27293 | `maxi(int(round( creditor.max_hp * 0.01 * debt_pct)), 1)` | Blood Debt heal | heal | mark power = BLOOD_DEBT_HEAL constants (12809) | debt mark present 27287 | card | **GUARDED** |
| scripts/battle.gd:27309 | `maxi(int(feaster.max_hp * 0.12 * feaster.bloodcraze), 1)` | Bloodcraze (bloodcraze) | heal | max_hp x ranks | bloodcraze > 0 27308 | DORMANT | **GUARDED** |
| scripts/battle.gd:27413 | `maxi(int(round(attacker.max_hp * 0.05)), 1)` | perfect `self_heal` | heal | 5% max_hp | - | - | **GUARDED** |
| scripts/battle.gd:27565 | `maxi(int(sc_profile["presses"]), 1)` | skill-check presses | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:28264 | `clampi(int((b as Dictionary).get("hp", comp.max_hp)), 1, comp.max_hp)` | returning companion hp | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:28359 | `maxi(h.hp, 1)` | `_live_party` standing read | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:28721 | `maxf(float(cy_party), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29246 | `maxf(s.get("intent_declared", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29262 | `maxf(sim_stats.get("battles", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29263 | `maxf(sim_stats.get("attacks", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29264 | `maxf(sim_stats.get("attack_landed", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29276 | `maxf(sim_stats.get("surviving_heroes", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29286 | `maxf(hero_total, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29403 | `maxf(tn, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29404 | `maxf(bn, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29407 | `maxf(tn, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29408 | `maxf(bn, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29506 | `maxf(rt_n, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29508 | `maxf(rb_n, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29583 | `maxf(stats.get("battles", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29680 | `maxf(abs_hits, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29681 | `maxf(h_turns, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29683 | `maxf(rel, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29711 | `maxf(s.get("battles", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29766 | `maxf(pool, 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29799 | `maxf(s.get("n_hero_" + hero, 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29806 | `maxf(s.get("pool_dmg_hero_" + hero, 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29807 | `maxf(s.get("pool_all_hero_" + hero, 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29808 | `maxf(s.get("pool_bd_hero_" + hero, 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29816 | `maxf(s.get("battles", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29820 | `maxf(s.get("battles", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29845 | `maxf(stats.get("battles", 0.0), 1.0)` | sim report / contrib table divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:29963 | `clampi(Run.slot_idx + 1, 1, Run.SLOTS_PER_ZONE)` | run snapshot tier | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:30764 | `maxi(int(round(lost * FROSTBIND_SHARE)), 1)` | Frostbind share | damage | lost | `lost <= 0` exit 30737 | card | **GUARDED** |
| scripts/battle.gd:30816 | `maxi(int(round(lost * 0.01 * maxi(pn_owed.status_power("penance"), 1))), 1)` | Penance | damage | lost | `lost <= 0` exit 30737 | "An enemy that never swings never pays." | **GUARDED** |
| scripts/battle.gd:30817 | `maxi(pn_owed.status_power("penance"), 1)` | Penance power | % | PENANCE_MIRROR x 100 constant (22840) | as 30816 | - | **GUARDED** |
| scripts/battle.gd:30822 | `maxi(int(round(pn_share * (1.0 - pn_resist))), 1)` | Penance (shadow resist) | damage | resist < 1 | as 30816 | - | **GUARDED** |
| scripts/battle.gd:30925 | `clampi(Run.slot_idx + 1, 1, Run.SLOTS_PER_ZONE)` | kill record tier | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:30974 | `maxi(int(round(u.max_hp * 0.01 * u.backblast)), 1)` | Backblast (backblast) | heal | max_hp x pct | `backblast <= 0` exit 30969 | DORMANT (no writer) | **GUARDED** |
| scripts/battle.gd:31057 | `maxi(int(round(amount * VIGIL_SHARE)), 1)` | Vigil rune fork | heal | amount healed | `amount <= 0` exit 31055 | rune | **GUARDED** |
| scripts/battle.gd:31058 | `maxi(healed.max_hp, 1)` | Vigil ratio | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:31061 | `maxi(h.max_hp, 1)` | Vigil ratio | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:31140 | `clampf(pitch + randf_range(-0.05, 0.05), 0.1, 3.0)` | sfx pitch | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/events.gd:239 | `maxi(int(m["hp"]) - int(round(int(m["max_hp"]) * amount)), 1)` | event `damage_pct` | no (hp clamp: an event cannot kill) | - | - | - | **NOT-A-PAYOUT** |
| scripts/events.gd:251 | `maxi(int(round(int(m["max_hp"]) * (1.0 + amount))), 10)` | event `max_hp_pct` | no (max-hp floor 10) | - | - | - | **NOT-A-PAYOUT** |
| scripts/events.gd:252 | `clampi(int(m["hp"]), 1, int(m["max_hp"]))` | event `max_hp_pct` | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/events.gd:304 | `maxi(int(round(int(m["max_hp"]) * amount)), 1)` | event `revive_pct` | revive hp | max_hp x amount | fallen only 303 | event text | **GUARDED** |
| scripts/map_screen.gd:810 | `maxi(int(member["max_hp"]), 1)` | hero card hp bar | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/map_screen.gd:819 | `maxi(int(member["max_mana"]), 1)` | hero card mana bar | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/map_screen.gd:1657 | `clampi(n, 1, 4)` | confirm text | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/map_screen.gd:4127 | `maxi(int(member["max_hp"]) / 2, 1)` | Revive item (map) | revive hp | max_hp / 2 | item held 4106 | item | **GUARDED** |
| scripts/party_screen.gd:459 | `maxf(pos.x, 12.0)` | tooltip position | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/party_screen.gd:460 | `clampf(pos.y, 12.0, 720.0 - _tree_tip.size.y - 12.0)` | tooltip position | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/profile.gd:470 | `maxi(int(purse.get(String(cls), 0)), 60)` | debug grant meta | no (debug) | - | - | - | **NOT-A-PAYOUT** |
| scripts/readout.gd:404 | `maxf(float(_seats.size()), 1.0)` | readout rounds | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:212 | `maxi(n, 1)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:489 | `maxf(float(m["max_hp"]), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:490 | `maxf(run.party.size(), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:516 | `maxi(int(round(base * (1.0 - run.relic_add("shop_discount")))), 1)` | sim shop price | no (price) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:732 | `maxf(1.0 - clampf(h.armor, 0.0, 0.95), 0.05)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:738 | `maxf(living, 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:741 | `maxf(1.0 - clampf(e.armor, 0.0, 0.95), 0.05)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:750 | `maxf(e_atk * e_ehp, 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:760 | `maxf(run.party.size(), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1136 | `maxf(float(n), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1144 | `maxf(float(runs_done), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1246 | `maxf(float(n_runs), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1249 | `maxf(float(r8_samples.size()), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1251 | `maxi(r8_samples.size(), 1)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1312 | `maxf(t["fights"], 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1329 | `maxf(t["fights"], 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1337 | `maxf(e_atk * e_ehp, 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1415 | `maxf(boss_entries, 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1485 | `maxf(draft_attempts, 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1515 | `maxf(slots_avail_sum, 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1529 | `maxf(float(walk_steps), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1569 | `maxf(t8["fights"], 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1571 | `maxf((t8["e_atk"] / f8) * (t8["e_ehp"] / f8), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1584 | `maxi(offer_count, 1)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1586 | `maxf(float(runs_done), 1.0)` | sim statistics | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:1310 | `maxi(slot, 1)` | zone ladder index | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:1338 | `maxf(difficulty_mult(), 1.0)` | health multiplier (rung floored at 1.0) | no (scaling) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:1359 | `maxf(difficulty_mult(), 1.0)` | end-boss multiplier | no (scaling) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:1374 | `clampi(tier, 1, SLOTS_PER_ZONE)` | battle budget tier | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:1390 | `maxi(budget, 6)` | elite budget floor 6 | no (budget) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:1423 | `clampi(budget / 2, 2, 5)` | fallback warband size | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:2203 | `maxi(int(round(Runes.price_of(rune) * (1.0 - relic_add("shop_discount")))), 1)` | rune price | no (price) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:2207 | `maxi(int(round(rune_price(rune) * RUNE_SELL_FRACTION)), 1)` | rune sell value | gold | rune price (>= 1) | - | "sells back for a third" | **GUARDED** |
| scripts/run_state.gd:3817 | `maxi(int(round(base * (1.0 - relic_add("shop_discount")))), 1)` | draft price | no (price) | - | - | - | **NOT-A-PAYOUT** |
| scripts/run_state.gd:4613 | `maxi(int(round(max_hp * HEALTH_POTION_PCT)), 1)` | Health Potion | heal | max_hp x 20% | - | item | **GUARDED** |
| scripts/run_state.gd:4617 | `maxi(int(round(max_resource * MANA_POTION_PCT)), 1)` | Mana Potion | Mana | max_resource x 40% | map refuses a hero with no Mana (map_screen 4119) | item | **GUARDED** |
| scripts/run_state.gd:5664 | `maxi(int(round(base * (1.0 - relic_add("shop_discount")))), 1)` | blacksmith price | no (price) | - | - | - | **NOT-A-PAYOUT** |
| scripts/settings.gd:19 | `clampf(volume, 0.0001, 1.0)` | volume | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/shop_screen.gd:393 | `maxi(int(round(base * (1.0 - Run.relic_add("shop_discount")))), 1)` | shop price | no (price) | - | - | - | **NOT-A-PAYOUT** |
| scripts/shop_screen.gd:419 | `maxi(int(round(_price(Run.ITEM_PRICES[id]) * Run.SELL_FRACTION)), 1)` | item sell value | gold | listed price (>= 1) | - | comment 414-17: "Always at least 1g" | **GUARDED** |
| scripts/talents.gd:267 | `clampi(int(node.get("tier", 1)), 1, TIERS)` | tier_of | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/talents.gd:284 | `clampi(tier, 1, TIERS)` | cell_cost | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/talents.gd:716 | `maxi(ranks, 1)` | desc_for scale | no (display) | - | - | - | **NOT-A-PAYOUT** |
| scripts/talents_screen.gd:371 | `maxf(pos.x, 12.0)` | tooltip position | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/talents_screen.gd:372 | `clampf(pos.y, 12.0, 720.0 - _tip.size.y - 12.0)` | tooltip position | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:905 | `maxi(FOCUS_CONVERT - deep_focus - rune_deep_focus - rune_heavy_bolts, 1)` | Focus convert point | no (threshold) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:1099 | `clampi(maxi(hp, int(save_max * 0.2)), 1, save_max)` | victory hp (fallen return at 20%) | no (hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:1143 | `maxi(max_hp - lent, 1)` | Fortified Spirit expiry | no (max-hp clamp) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:1952 | `maxi(int(max_hp * MARTYRDOM_RETURN), 1)` | Martyrdom return | restore hp | 30% max_hp | martyrdom_guard 1951 | DORMANT | **GUARDED** |
| scripts/unit.gd:1969 | `maxi(int(max_hp * 0.01 * ashes_return), 1)` | Ashes of Al'ar | restore hp | max_hp x ashes_return | `ashes_return <= 0` exit 1966 | card | **GUARDED** |
| scripts/unit.gd:2418 | `maxf(1.0 - momentum * MOMENTUM_STEP_HASTE, 0.1)` | Momentum delay | no (multiplier) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:3526 | `maxi(turns + mod_status_turns, 1)` | status duration under Fleeting | status turns | turns + mod_status_turns (Fleeting -1) | `turns > 0` 3525 | Fleeting: "Every status applied lasts one turn less (never below one)." | **FLOOR-BY-DESIGN** |
| scripts/unit.gd:3691 | `clampi(n, 1, 4)` | Chilled stack clamp | no (stack count of a standing chill) | - | status present 3689 | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:3691 | `maxi(n, 1)` | Chilled stack clamp (uncapped) | no | - | status present 3689 | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:3988 | `maxf(0.75 - frigid_bonus, 0.1)` | Chilled speed | no (multiplier) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:3990 | `maxf(0.5 - frigid_bonus * chill, 0.1)` | Chilled speed | no (multiplier) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4061 | `maxi(int(get_status("sunder").get("power", 0)), 1)` | Sunder depth | armor cut depth | sunder power; status present | `has_status("sunder")` 4059 | CLAUDE.md HF: "one deep when nothing deepened it" | **FLOOR-BY-DESIGN** |
| scripts/unit.gd:4146 | `maxf(12.0, ceilf(w) + 4.0)` | chip width | no (UI) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4408 | `maxf(keep, 1.0)` | Unslaked keep | frenzy floor share 1.0 | card sets FULL | `has_status("unslaked")` 4407 | "keeps the FULL bonus you reach" | **FLOOR-BY-DESIGN** |
| scripts/unit.gd:4469 | `maxi(Classes.SIPHON_MANA_PER_POINT, 1)` | Siphon rate | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4527 | `maxi(int(round(absorbed * bb_pct)), 1)` | Blessed Barrier heal | heal | absorbed | `absorbed > 0` 4526 | - | **GUARDED** |
| scripts/unit.gd:4561 | `maxi(int(round(int(s.get("original", 0)) * reform_pct)), 1)` | Unyielding Aegis re-form | barrier | original x pct | `reform_pct > 0.0` 4560 | - | **GUARDED** |
| scripts/unit.gd:4617 | `maxi(last_rites, 1)` | Last Rites divisor | no (divisor) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4639 | `maxi(int(round(max_hp * 0.01 * stable_ranks)), 1)` | Stable Alignment cap | no (a cap on damage taken) | - | - | DORMANT | **NOT-A-PAYOUT** |
| scripts/unit.gd:4722 | `maxi(status_power("vespers"), 1)` | Vespers catch | absorb | status power (>= 1 at 22594) | `amount > 0` and threshold crossing 4719 | card | **GUARDED** |
| scripts/unit.gd:4818 | `maxi(int(amount * 0.5), 1)` | Mana Shield | Mana | amount x 0.5 | `amount > 0` 4817 | "half the pain flows back as Mana" | **GUARDED** |
| scripts/unit.gd:4845 | `maxf(eff_con * (1.0 - minf(thin, 0.75)), 10.0)` | Winter's Depth / Sunder Shot constitution | no (divisor floor 10) | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4847 | `maxf(eff_con, 1.0)` | constitution divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4865 | `maxi(status_power("breaking_darkness"), 1)` | Breaking Darkness amplifier | Break % | status power = BREAKING_DARKNESS_BD_PCT (22749) | `pressure_add > 0` and status 4863 | card | **GUARDED** |
| scripts/unit.gd:4869 | `maxf(constitution, 1.0)` | Bracing credit divisor | no | - | - | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:4892 | `maxi(status_power("hold_bd"), 50)` | Hold the Line cut | Break cut % | status power; floor 50 is the card's base (pre-AL save fallback) | `has_status("hold_bd")` 4889 | "50% less Break damage for 2 turns" | **FLOOR-BY-DESIGN** |
| scripts/unit.gd:5151 | `maxi(int(max_hp * pct), 1)` | revive | revive hp | max_hp x pct | callers pass pct > 0 | - | **GUARDED** |

## 5. Floors the literal scan cannot see (named-constant or variable floors, `if`-style floors)

| file:line (HEAD) | expression | owner | payout? | condition / guard | words | CLASS |
|---|---|---|---|---|---|---|
| scripts/battle.gd:1768 | `maxi(u.resource, int(res_floor * u.max_resource))` | Bottled Storm relic (`resource_floor_pct`) | opening resource | `res_floor > 0.0 and max_resource > 0` (1767) | relic: battles open with a floor under the tank | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:1777 | `maxi(u.resource, mini(u.opening_rage, u.max_resource))` | First Blood (`opening_rage`) | opening Rage | `opening_rage > 0` (1776); field DORMANT (no writer) | "he opens at 40" | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:6733 | `maxi(u.bulwark_ally_block, SHIELDWALL_BLOCK / 2)` | `_recast_writes` (Shieldwall) | no (prediction) | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:14625 | `maxi(HOLD_RELEASE_STACKS, target.hold_turns)` | Second Winter rune | Chilled on release | `hold_turns > 0` (14624) | "the ice does not let go" — a floor, never less | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:17583-84 | `if share_pct <= 0: share_pct = 50` | Blood Bond guard | share default | missing power falls back to the base 50 (comment 17577-81) | card | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:17663-64 | `if share_pct <= 0: share_pct = BRUNT_SHARE` | Bear's Brunt | share default | same shape | card | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:18454 | `maxi(step - occ.rune_hex_deepen, RUIN_FLOOR)` | Deepening Hex | no (a threshold step, FO §1's ruled floor) | - | - | **NOT-A-PAYOUT** |
| scripts/battle.gd:19459-60 | `if rb_turns == 0: rb_turns = 1` | Returned Burden | duration of an effect cast back | 0 only for an effect lifted at 0 turns. **Uncertain**: I found no state where a standing status carries 0 turns when Unburden lifts it. | rune | **GUARDED (uncertain)** |
| scripts/battle.gd:23733 | `maxi(attacker.status_power("shieldwall"), wall_pct)` | Shieldwall | Block % | re-cast keeps the higher | card | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:23755 | `maxi(target.status_power(sw_id), sw_pct)` | Shieldwall (split / ally) | Block % | same | card | **FLOOR-BY-DESIGN** |
| scripts/battle.gd:26418-19 | `df_h.trap_rearm = 1` | Set and Forget | no (a flag) | DORMANT | - | **NOT-A-PAYOUT** |
| scripts/unit.gd:1944, 4748, 4754, 5078, 5082 | `hp = 1` | Intercession, Hold the Line (undying), Undying Rage | death refused at 1 | each behind its own status/flag | "survive at 1 health" (Intercession card), "no one can die" (Hold the Line) | **FLOOR-BY-DESIGN** |
| scripts/unit.gd:4349 | `amount = maxi(amount, CHANNEL_CAST_FLOOR)` | Channel (Mage engine) | Channel ledger | **The condition CAN be zero** (a free cast spends 0 Mana) **and the line runs.** This is the one floor where the condition can be zero and the words still hold. | classes.gd 2105: "Every cast counts as at least {CHANNEL_CAST_FLOOR} Mana spent." | **FLOOR-BY-DESIGN** |
| scripts/run_state.gd:5414 | `maxf(ab.delay * 0.75, Ability.DELAY_FLOOR)` | Swift upgrade | no (delay) | - | - | **NOT-A-PAYOUT** |
| scripts/run_sim.gd:1208-09 | `if power_mult <= 0.0: power_mult = 1.0` | sim env | no | - | - | **NOT-A-PAYOUT** |

## 6. Summary

**Total hits in the literal scan: 323** (322 lines). Supplementary floors: 15 rows (§5).

| CLASS | literal scan | §5 |
|---|---|---|
| DEFECT-SHAPE | **2** | 0 |
| FLOOR-BY-DESIGN | 11 | 9 |
| GUARDED | 158 | 1 (uncertain) |
| NOT-A-PAYOUT | 152 | 5 |

### The DEFECT-SHAPE sites (HEAD 11ef9fa)

1. **`scripts/battle.gd:12338-12339` — Tithe (crest rune) and Blood Communion (tree node), heal.** `maxi(int(round(result.get("bd", pr) * bc_pct / 100.0)), 1)` is gated on `pr > 0` (12317), the Break carried, not on the Break landed. It heals 1 on:
   - any attack into a **Broken** enemy;
   - every Break-carrying attack under the **Deadened** bargain;
   - small-Break attacks that round away (Muffled, high Constitution).

   The words, "an attack that lands Break", are false there. **Status: already repaired in the working tree by IR §1d** (`bc_bd > 0`, working tree 12376-12383), not yet committed at 15:41.

2. **`scripts/battle.gd:12230` — Sacred Resolve's Unity split (a cost, the Mirrorbound family): `maxi(int(round(final / float(bound.size()))), 1)`.**
   - **The condition:** `final`. It is **0** when the struck hero parries absolutely: `var final := 0 if wall_parry` (11971), where `wall_parry` is a **Feint charge** (`parry_source == "Feint"`, 10353) or Untouchable (Untouchable is DORMANT).
   - **The guards:** only `has_status("unity")` (12226-27) and `bound.size() > 1` (12229). Nothing guards on zero.
   - **What happens:** every other living hero takes 1 through `take_hit` (12236). Then `final = share` (12243) hands the parrying hero 1 as well. So an absolute parry costs the party one HP per living hero, where it should cost nothing.
   - **The words it breaks:** Sacred Resolve says "all damage received is split evenly among them" (classes.gd 6560). Feint says "each parrying an attack outright and returning its damage to the attacker" (classes.gd 3158). The code's own comment at 10345-46 says "the hit lands NOTHING (damage, floor-of-1, and BD all zeroed)".
   - **Reachability:** **live.** Sacred Resolve is on the Devout's shelf and boss pool (classes.gd 237, 443), and Feint is a Swordmaster draft card. A party fields one Cleric and one Warrior, so the two can meet. It is not cast on any instrument I know of.
   - **Working tree:** unchanged at 15:41 (line 12268 there).

   **A related observation, which is not the zero shape:** the same floor also *amplifies* a small blow. A 1-damage blow on a bound party of four becomes 1 to each, 4 in total, because `round(1/4)` is 0 and floors to 1. The bleedout split (27214) and the recoil split (13611) have the same rounding, but their totals are always ≥1, so I classed them GUARDED.

### Latent (shape present, line unreachable today), classed GUARDED

- **`battle.gd:19571` — Sacred Covenant Faith.** `maxi(devout.covenant_faith, 1)` is gated on `covenant_heal` (19563), not on `covenant_faith`. A payload writing the heal alone would pay 1 Faith. Both fields are DORMANT.
- **`battle.gd:26055` — Slow Acting.** `maxi(int(ceil(tick / 2.0)), 1)` would re-raise Thin Blood's meant zero (26050-51) to 1. It is DORMANT (`slow_acting` has no writer), and the status door re-zeroes a Thin Blood poison anyway (`hw_thin`, 14902-05).
- **`battle.gd:13611` — Unity recoil split.** It would floor to 1 each if Blowback zeroed the recoil (13605). Blowback is DORMANT.
- **`battle.gd:12563` — Temporal rift.** It reads `final` with no `final > 0` guard. DORMANT, and a vow-refused `final` is also refused at the rift's own door.

### Judgements I hold with less than full confidence

- **Shatter (`10766`) and Winter's Toll (`20442`)**, multiplier `maxi(hold_turns, 1)`. Both cards say they pay per turn held. A fresh hold starts at 0 (14437), but `_hold_sync` adds 1 at the top of **every** turn before anyone acts (3292 → 14713). So 0 is reachable only if a freeze and the cast happen in one turn. I found no route to that, so I classed both GUARDED by turn order. If a same-turn route exists, both become DEFECT-SHAPE.
- **Cull (`23018`) and Harvest (`23254`).** The guard is `_harvest_yield(target) > 0`, which is a tier-weighted count of top-level `DEBUFF_IDS` entries. The paid count, however, is re-read as `_status_count` before minus after the purge, which is a distinct-base-id count. I believe the two agree whenever the yield is positive (sticky entries are excluded from both), but I did not drive it.
- **Returned Burden (`19459-60`, §5).** See the row.

### Everything else

- **NOT-A-PAYOUT** rows are divisor guards, UI and layout, sim statistics, prices, HP clamps on costs, recast predictions, and multiplier floors.
- **FLOOR-BY-DESIGN** rows are those whose words state the minimum, or where the minimum is the card's own figure:
  - Mirrorbound's recoil and the universal strike floor;
  - Mirror Image's 4 and Arcane Arrows' 6;
  - Fleeting's "never below one";
  - Battle Trance's floor term;
  - Hold the Line's base 50;
  - Sunder depth "one deep";
  - Unslaked's keep 1.0;
  - Set and Forget's one trap;
  - the poison tick's rounding floor;
  - plus the §5 set, Channel's "every cast counts as at least 10 Mana" included.
- **GUARDED** rows either have a `> 0` guard or exit above the line, or take their share of a base that is never zero (max HP, max resource, a status power that every writer sets ≥1, an enemy resist ≤0.5). Many of them are also DORMANT talent fields deleted at FX; the table says which.
