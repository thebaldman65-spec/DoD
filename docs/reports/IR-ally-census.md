> **KEPT AS IR's CENSUS OF RECORD (ID §0.6: a census a later batch will be priced against is kept). IR's report §1b — every ally-target card's pick against its words. Read against HEAD; IR then narrowed all ten HERO cards (its last section describes the working tree mid-batch, when two were).** Written by a read-only reader; its scratch paths are not in the repository.

# Census 1b: every pick that reads `_hero_side()`, and whether its words say *hero*

## Scope and snapshot

- **The line numbers are HEAD's**: commit `11ef9fa` ("Batch IQ"); `scripts/battle.gd` is 31,174 lines. Copies are in `scratchpad/snap1b/head/`.
- **The working tree changed while I worked.** At 15:31 `battle.gd` grew to 31,208 lines, and `classes.gd`, `run_state.gd`, `map_screen.gd` and `run_sim.gd` changed too. These are uncommitted Batch IR edits; the in-flight section at the end describes them. I edited nothing.
- **What a "pick" means here.** A pick chooses one body, or a subset, out of a pool. A walk pays every member, and a door test asks whether *any* member qualifies.
- **Companion facts the verdicts rest on, at HEAD.**
  - `heroes` never holds a companion. `_hero_side()` = living heroes + living companions (`battle.gd:4083-4088`).
  - A companion is built with `is_hero: true` and `"abilities": []` (`:25302`), `is_companion = true` (`:25313`) and `next_time = INF` (`:25351`).
  - `_next_unit` walks `heroes + enemies` (`:4072`), so a companion never acts and is never `attacker` in `_resolve`.
  - The hero-only callbacks are wired by `for h in heroes` at spawn: `shield_absorbed_cb` `:1808`, `vigil_cb` `:1823`, `vow_cb` `:1860`, `rite_cb` `:1863`. A summon copies only `bloodbond_cb` (`:25356`).
  - `_gain_faith` refuses companions (`:19117`).
  - The Block roll skips companions (`:9950-9951`).
  - `battle_turn` is stamped on `heroes + enemies` only (`:3288-3289`).

## Table A: the ALLY-target cards (population (a), all through the player picker)

**How the picker works** (`battle.gd` `_player_turn`):
- The self-cast list (`:4447-4563`) catches **none** of the 20.
- `resurrection` has its own branch (`:4568-4578`).
- Every other ALLY card falls to `pool = _hero_side()` (`:4599`), then `_pick_target(pool, _target_refusals(...))` (`:4625`).
- `_target_refusals` returns `{}` for every ALLY card (`:8240-8261`).
- The only narrowings are Covering Guard `a != u` (`:4606-4607`) and Rally `a != u and not a.is_companion` (`:4614-4615`). **Covering Guard does NOT exclude companions**, despite the brief.
- "Can a companion be picked" assumes one is standing: a non-Sharpshooter Hunter has summoned it, or Call the Wilds put one out.

Card text lives in `scripts/classes.gd` (`desc` line given). Status chips live in `battle.gd` `STATUS_INFO`.

| # | Card | special | Site | Pool (narrowing) | Words (exact) | Companion pickable? | Effect arrives on a companion? | VERDICT |
|---|---|---|---|---|---|---|---|---|
| 1 | Covering Guard | covering_guard | battle.gd:4599, 4606-4607; desc classes.gd:3293 | `_hero_side()` minus caster only | "every attack aimed at **one hero**" (chip :491: "attacks aimed here") | **YES** | **NO.** The status lands (:21121), but the Block roll that reads it is gated `not strike_target.is_companion` (:9950-9951), so `_covering_warden` (:9957) is never asked for a companion. | **HERO-WORD-ADMITS-COMPANION** |
| 2 | Second Wind | second_wind_holy | :4599; desc :3812 | `_hero_side()` | "heal **an ally** … (a companion: all battle)"; perfect "Up to {mhp:55\|ally}" | YES | YES. `damage_taken_recent()` (unit.gd:5012) on a companion whose `battle_turn` stays 0 covers the whole battle, which is what the card says. | ALLY-WORD-OK |
| 3 | Rite of Return | rite_of_return | :4599; desc :3820 | `_hero_side()` | "Promise **one hero** the road back" (chip :395: "fell **this ally**") | **YES** | **NO.** Status at :20529; the save needs `rite_cb.is_valid()` (unit.gd:1935), and `rite_cb` is wired only on heroes (:1861-1863). The companion dies normally. | **HERO-WORD-ADMITS-COMPANION** |
| 4 | Vow of Suffering | vow_suffering | :4599; desc :3829 | `_hero_side()` | "the damage **that hero** takes … kindles **that hero** 1 Faith" (chip :394: "**this ally**" ×2) | **YES** | **NO.** Status at :20540; the redirect needs `vow_cb.is_valid()` (unit.gd:4596), and `vow_cb` is wired only on heroes (:1858-1860). The Faith half is refused anyway (`_gain_faith` :19117). | **HERO-WORD-ADMITS-COMPANION** |
| 5 | Aegis Reversal | aegis_reversal | :4599; desc :3837 | `_hero_side()` | "consumes **a hero's** Divine Shield, and their next attack deals bonus damage" | **YES**. A companion can carry a divine barrier: Divine Shield and Mantle picks admit companions, and `_grant_divine_shield` (:17855) refuses nobody. | **NEGATIVE.** The shield is removed (:20561) and `aegis_bonus` is stamped (:20563). It is read only for the acting `attacker` in `_resolve` (:11982); a companion never acts, and `_companion_hit` (:25716) does not read it. The cast spends the shield for nothing. | **HERO-WORD-ADMITS-COMPANION** |
| 6 | Ministration (Cleric kit) | ministration | :4599; desc :4031 | `_hero_side()` | "heal **one ally** for 20% of THEIR maximum"; perfect "Heals {mhp:26\|ally}" | YES | YES (`heal_amount`, :21713) | ALLY-WORD-OK |
| 7 | Unburden (Cleric kit) | unburden | :4599; desc :4070 | `_hero_side()` | "remove EVERY harmful effect from **one ally**, and they take 20% less damage" | YES | YES. Purge at :21767; the 20% is read in the strike loop (:11454) with no companion guard. | ALLY-WORD-OK |
| 8 | Undying Vigil | undying_vigil | :4599; desc :4102 | `_hero_side()` | "Keep watch over **one hero** … a second hero on lower health" (chip :507: "every heal **this ally** receives … a second hero") | **YES** | **NO.** Status at :21815; the fork needs `vigil_cb.is_valid()` (unit.gd:5321), and `vigil_cb` is wired only on heroes (:1811-1823). The fork's own pool is heroes-only (:31058-31061). | **HERO-WORD-ADMITS-COMPANION** (expected) |
| 9 | Rally | rally_ally | :4599, 4614-4615; desc :4259 | `_hero_side()` minus caster minus companions | "Shout **one hero** forward" | NO | n/a. A companion has no turn and no resource bar. | HERO-WORD-NARROWED-OK |
| 10 | Recant | recant | :4599; desc :4825 | `_hero_side()` | "**one ally** regains 40% of their MAXIMUM Rage or Mana" | YES | **NO.** Guard `target.resource_name == ""` (:24516) logs "Recant finds nothing to give back". | **Reverse defect, outside the four labels**: an ally word on a hero-only effect. The pick admits a companion and the turn is spent on nothing. By CV §4's no-resource-bar reason the word should be *hero*. |
| 11 | Fortified Spirit | fortified_spirit | :4599; desc :4928 | `_hero_side()` | "Lend **one hero** your own bulk … The loan DECAYS 10 points a turn" (chip at :24690: "start of each of **this ally's** turns"; glossary `lent_health`: "lends **an ally**") | **YES** | **MORE THAN THE CARD SAYS.** The max-HP raise and heal land (:24685-24690). The decay never runs: `_fortified_tick` is called only for the acting unit at turn start (:3882). | **HERO-WORD-ADMITS-COMPANION** (expected) |
| 12 | Vespers | vespers | :4599; desc :5390 | `_hero_side()` | "the next blow that would take **that ally** below half health is absorbed" | YES | YES. Read in `unit.take_hit` (unit.gd:4719-4724); `mercy_threshold` defaults to 0.5 (unit.gd:941). | ALLY-WORD-OK |
| 13 | Mantle | mantle | :4599; desc :5497 | `_hero_side()` | Pick: no word ("Lay the mantle: a Divine Shield …"). Hop: "passes to **the hero** on the lowest health". "Every one of them builds Faith like the first." | YES | Shield YES (:22725). `barrier_broken_cb` is on every unit (:2328), so a companion's shield still passes. The hop pool is heroes-only (:19034-19037). The "builds Faith like the first" clause fails when the first holder is a companion (`shield_absorbed_cb` heroes-only :1806-1808; `_gain_faith` :19117). | **AMBIGUOUS.** The pick carries no word and the shield arrives; the hop is HERO-WORD-NARROWED-OK; the Faith clause is false for a companion first holder. |
| 14 | Dawnbreak (Holy zone-boss pool, classes.gd:236) | dawnbreak | :4599; desc :6297 | `_hero_side()` | "heal **an ally** 40" | YES | YES (:19944) | ALLY-WORD-OK |
| 15 | Divine Plea | divine_plea | :4599; desc :6541 | `_hero_side()` | "FULLY heal **an ally** … cleanse … Hallow them" | YES | YES (:24406) | ALLY-WORD-OK |
| 16 | Heal | holy_heal | :4599; desc :7021 | `_hero_side()` | "Mend **an ally** for 40% of the Cleric's max health" | YES | YES (:24355) | ALLY-WORD-OK |
| 17 | Renewal | renewal | :4599; desc :7025 | `_hero_side()` | "**A hero** heals 15% … at the start of each of their turns" (chip :200: neutral) | **YES** | **NO for the main effect.** Status at :24475; the tick is at :3449, inside the turn loop, for the acting unit only. Only the Perfect's 5% burst arrives (:24494). The Empower copy goes to the caster. | **HERO-WORD-ADMITS-COMPANION** |
| 18 | Divine Shield (Devout enabler) | divine_shield | :4599; desc :7042 | `_hero_side()` | "Grant **an ally** a holy shield" | YES | YES (barrier, :19875). Conviction's absorb-Faith does not arrive, but the card does not promise it. Glossary `res_faith`'s "builds TWO stacks on its bearer" is false for a companion bearer (aside). | ALLY-WORD-OK |
| 19 | Blessing of Zeal | zeal | :4599; desc :7050 | `_hero_side()` | "Kindle **a hero**: +15% damage …, their cooldowns tick down …, their Faith gain is doubled" (chip :366: neutral) | **YES** | **NO, nothing arrives.** Status at :20073. The +15% is read only for the acting attacker (:10705); `_shared_hide_mult` (:25684-25713) does not list `zeal`. The cooldown tick (`_tick_cooldowns` :15736) moves nothing on a companion with `abilities: []`. The Faith doubling is refused at :19117. The Purity rider has no writer (dormant). | **HERO-WORD-ADMITS-COMPANION** |
| 20 | Resurrection | resurrection | **Own branch** :4568-4578 (not `_hero_side()`) | `heroes.filter(dead)` | "return **a fallen hero** to life" | NO | n/a | HERO-WORD-NARROWED-OK |

**Conditional note.** If the hunter wears Bared Fang, his companion carries `no_heals` (a rune's price), so the heal cards (Second Wind, Ministration, Dawnbreak, Divine Plea, Heal) are refused on that companion. That is by design, not structural.

## Table B: the other PICK sites that read `_hero_side()` (population (b), picks)

| Effect | Site | Pool | Pick | Words | Companion pickable? | Arrives? | VERDICT |
|---|---|---|---|---|---|---|---|
| Talent "Cleanse Debuffs Each Turn" (`tn_cleanse`, field_medic 2) and the retired crest Fellowship (`rune_field_medic`, read site kept) | battle.gd:3638 | `_hero_side()` filtered to bodies carrying a status | `pick_random()`, ×N | talents.gd:170 "cleanse … debuffs from **random allies**"; runes.json:970 "clears one debuff from **an ally**" | YES | YES (`dispel_one_debuff`) | ALLY-WORD-OK |
| Dispel (ally half) | :4595-4597 | `_hero_side()` + living enemies | player click | classes.gd:3999 "strip THREE harmful effects from **an ALLY**" | YES | YES. The `target.is_hero` branch (:21616+) is true for a companion. | ALLY-WORD-OK |
| Long Silence: a silenced enemy's declared move falls back to its basic | `_declare_intent` :8373 | `_hero_side()` | keep the declared target, else `_lowest_hp` | run_state.gd:4767 "Nobody may use the same ability twice this fight" (no target word) | YES | YES (an enemy blow) | NO-WORD (no mismatch) |
| Intent re-validation: the declared target died | `_revalidate_intent` :8476 | `_hero_side()` | `pick_random()` | none (internal BL §1) | YES | YES | NO-WORD |
| A wind-up's stored blow lands | `_enemy_turn` :8563 | `_hero_side()` | `pick_random()` | The only windup is the Hurler's Siege Stone, enemies.json: "heavy damage to **every ally**". It carries `aoe`, so the pick is nominal and the blow walks the hero side (:9656). | YES | YES | ALLY-WORD-OK |
| Enemy target selection | `_choose_enemy_action` :8699 (+ `_lowest_hp`, `_threat_pick`, taunt narrowings) | `_hero_side()` | lowest health or a threat pick | No enemy ability text in data/enemies.json says *hero* (swept) | YES (by design, DU §2) | YES | NO-WORD |
| Enemy `random_hits` shards | `_resolve` :9832 | `_hero_side()` | `pick_random()` per shard | none | YES | YES | NO-WORD. **Dormant**: no enemy ability in data/enemies.json carries `random_hits`. |
| Psychosis: a maddened support casts on the hero side | `_psychotic_support` :18254 | `_hero_side()` | `_lowest_hp` or random | chip :210 "casting its helpful magic on the enemy side" (no hero word) | YES | YES | NO-WORD |

## Table C: `_hero_side()` call sites that are WALKS or door tests, not picks (population (b))

| Site | What | Classification | Words |
|---|---|---|---|
| `_recast_targets` :6592 | covering_guard: `_hero_side()` minus caster | Door walk over the pick pool (the refusal asks every legal pick) | n/a |
| `_recast_targets` :6595 | undying_vigil, vow_suffering, rite_of_return, vespers, divine_shield, mantle → `_hero_side()` | Door walk over the pick pool | n/a. The header at :6573-6575 says this must equal the picker's pool. |
| `_ability_usable` :6974 | Aegis Reversal lights if **any** hero-side body holds a divine barrier | Door any-test | — |
| `_ability_usable` :6995 | Covering Guard lights if any other living hero-side body stands | Door any-test | — |
| `_resolve` :9656 | Enemy `aoe` strikes every living hero-side body | WALK | e.g. Siege Stone "every ally": OK |
| `_resolve` :10284 | Rally talent: every ally Rallied (+30% healing) | WALK | log "every ally". `rally` field has no writer in talents.gd or runes.json (dormant). |
| `_on_damage_taken`/judgment :16284 | Arbiter core rune (Judgment) heals every living ally | WALK | classes.gd:2194-2196 "every ally heals": OK |
| `_resolve_special` rally :19796 | Rallying Shout's Pressure clause | WALK | "every ally sheds 30 Pressure": OK |
| sanctuary :20016 | Sanctuary heal | WALK | "every ally heals 12%": OK |
| hold_the_line :23849 | Hold the Line | WALK | "Embolden every ally": OK |
| `_defensive_brace` :28131 | Any hero-side body with a defensive check, for aoe/scatter | Any-test | none |

`_hero_side` appears on 34 lines of HEAD `battle.gd`: 1 definition (:4083), 20 call sites (above), and 13 comment-only lines (3628, 6573, 10268, 10275, 16277, 19780, 19793, 20007, 23082, 23215, 23837, 23841, 25746). No other game script calls it; only gates do (check_di, check_du, check_dm, check_dl, check_gw, check_ds, check_dk).

## Table D: the bot's ALLY targeting (population (c))

For an ALLY card the bot's target is `auto_target` (`_player_turn` :4583-4584). Resurrection is the exception: its branch (:4568-4574) sets `fallen[0]` from `heroes`. `auto_target` is set by `_autoplay_pick` (:4884): the redoubt pick, then the rotation `_autoplay_pick_kit`, then `_bot_class_kit_pick`, then `_bot_drafted_pick`.

**Every bot pool is heroes-only**: `_bot_class_kit_pick` `allies` :4923 (`not is_companion`), `_bot_drafted_pick` `allies` :5032, and `_autoplay_pick_kit` `allies`/`weakest_ally` :5388/:5392 (`heroes` holds no companion). The bot never picks a companion for any ALLY card.

| Card | Bot site | Bot pool |
|---|---|---|
| Covering Guard | drafted :5062-5066 | heroes minus caster; skips when empty |
| Second Wind, Rite of Return, Vow of Suffering, Undying Vigil, Vespers | drafted default :5128 `_lowest_hp(allies)` | heroes. No check for an existing status, so it can recast onto a holder. |
| Aegis Reversal | drafted :5121-5127 | heroes with a divine barrier, else skip |
| Rally | drafted :5072-5080 | heroes minus caster |
| Recant | drafted :5087-5096 | heroes with a resource bar below max |
| Fortified Spirit | drafted :5103-5108 | heroes without `fortified` |
| Mantle | drafted :5115-5120 | heroes without a barrier |
| Ministration, Unburden | class kit :4968-4983 | heroes |
| Resurrection | rotation :5906-5912, then the `_player_turn` branch | fallen heroes |
| Divine Plea, Renewal, Heal | rotation :5923, :5939, :5945 | `weakest_ally` (heroes) |
| Divine Shield | rotation :5974 | `_likeliest_target(allies)` / `weakest_ally` (heroes) |
| Blessing of Zeal | rotation :5982-5999 | heroes |
| Dawnbreak | **none.** Its definition is in `vault_ability` (classes.gd:6292), so the drafted hook skips it (`draft_ability()==null`, :5040), and no rotation names it. | The bot never casts it. |
| Dispel (ally half) | drafted :5135-5139 | heroes |

Where the door and the bot already diverge at HEAD:
- Aegis Reversal's door (:6974) lights for a companion-only divine shield, which the bot skips.
- Covering Guard's door (:6995) lights when only a companion stands beside the Warden, which the bot skips.
- `_recast_targets` (:6592/:6595) keeps the button lit while a companion is improvable, but the bot aims at a hero.

## Summary

- **Call sites.** There are 20 call sites of `_hero_side()` in game code, plus the definition and 13 comments.
  - **9 are PICKs**: 3638, 4596, 4599, 8373, 8476, 8563, 8699, 9832, 18254.
  - **11 are WALKs or door tests**: 6592, 6595, 6974, 6995, 9656, 10284, 16284, 19796, 20016, 23849, 28131.
  - The ALLY picker (:4599) carries 19 cards: 18 admit a companion, and Rally excludes it. Resurrection is the 20th ALLY card and uses its own pool.
- **HERO-WORD-ADMITS-COMPANION: 8 cards, not 2.**
  1. **Fortified Spirit** (expected). The effect arrives in excess: the loan never decays.
  2. **Undying Vigil** (expected). The fork never fires.
  3. **Covering Guard.** The Block roll skips companions, so the cast does nothing. The brief's "already narrows" is false: it narrows only the caster.
  4. **Rite of Return.** `rite_cb` is wired on heroes only, so there is no save.
  5. **Vow of Suffering.** `vow_cb` is wired on heroes only, so there is no redirect, and the Faith half is refused.
  6. **Aegis Reversal.** It spends the companion's divine shield and the bonus is never read: a net loss.
  7. **Renewal.** The per-turn tick never runs; only the Perfect burst arrives.
  8. **Blessing of Zeal.** Nothing arrives.
- **Opposite mismatch (an *ally* word on a pick that excludes companions).** None inside the `_hero_side()` population.
  - Adjacent: the Split Shield rune (runes.json:524, "the **ally** he sets it in front of"). Its picker is `_split_shield_allies` = `heroes` minus the caster (:18169-18170, used at :4436-4446). The narrowing is right, because the Block roll skips companions (:9950-9951), but the word should be *hero*.
  - Bot-only: every ALLY-worded card (Second Wind, Ministration, Unburden, Vespers, Divine Plea, Heal, Divine Shield, Recant, and Dispel's ally half) is narrowed to heroes in the bot while the player's pick admits companions. That is policy narrowing, not a door the player lacks.
- **Reverse defect (an ally word, a companion admitted, nothing arrives): Recant.** A companion has no resource bar; the card should say *hero*.
- **Ambiguous: Mantle.** The pick carries no word and the shield arrives; the hop is narrowed to heroes; "Every one of them builds Faith like the first" is false when the first holder is a companion.
- **Surfaces that disagree with their own card.**
  - The Vow (:394), Rite (:395) and Vigil (:507) chips say "this ally" while their cards say *hero*.
  - Fortified Spirit's chip (:24690) and the glossary's `lent_health` say "ally" while its card says *hero*.
  - Glossary `hero_vs_ally`: "a single-target support ability you aim by hand CAN be aimed at a companion (Rally excepted …)". This sentence becomes false for every card that gets narrowed.

## The in-flight working tree (uncommitted Batch IR), read at 15:34

- `battle.gd:921` adds `const HERO_PICKS := ["fortified_spirit", "undying_vigil"]`, and `_player_turn` filters companions for those two (working-tree :4626).
  1. **It covers 2 of the 8 HERO-word cards.** Covering Guard, Rite of Return, Vow of Suffering, Aegis Reversal, Renewal and Blessing of Zeal still admit a companion.
  2. **`_recast_targets` is not narrowed.** At working-tree ~:6607 it still returns `_hero_side()` for `undying_vigil` (and vow and rite). Once only a companion lacks Vigil, the door stays lit for a pick the picker no longer offers, which contradicts the header at :6573-6575 ("the button cannot darken over a target the picker would have allowed", read both ways).
  3. **The door tests for Covering Guard (:6995) and Aegis Reversal (:6974) read `_hero_side()`.** If either card joins `HERO_PICKS`, its door must narrow too. Otherwise the button lights with an empty pool, and `_pick_target([])` offers only Cancel.
  4. **The chips and glossary entries above** need the clause swept (CV §4) in the same batch.
- `check_ir.gd` did not exist yet when I looked.
