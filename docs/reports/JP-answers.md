# JP §2 — THE PARTY's THREE ANSWERS, READ OUT AT SOURCE

Part of JP's report (`docs/reports/JP.md`). **A readout, not a design**: it names what exists, at source, for the three answers
being chosen in conversation, and what a card answering each would have to add and what that would cost to build. **It authors
nothing** — no card, talent, rune, status or ability, no figure for one. Every door below is a file, a function (`—` for the
file's own scope) and a line quoted from it as it stands on the tree that lands; `check_jp` §2 reads each quote in its function
and reds on a door that does not exist or a row that quotes nothing. A line number is no citation, so none is given.

## 1. TAKING MALICE OUT OF THE POOL

| door | file | function | the line, quoted |
|---|---|---|---|
| the pool: a battle field, empty at every fight's opening | `scripts/battle.gd` | `—` | `var malice := 0` |
| its cap | `scripts/battle.gd` | `—` | `const MALICE_CAP := 150` |
| the one way in: what the cap refuses is wasted | `scripts/battle.gd` | `_malice_fill` | `var got := mini(points, maxi(MALICE_CAP - malice, 0))` |
| the one write that raises it | `scripts/battle.gd` | `_malice_fill` | `malice += got` |
| the damage term and the overkill term, together | `scripts/battle.gd` | `_malice_on_damage` | `_malice_fill(pts + maxi(past_last, 0))` |
| the damage term counts the hero side's blows only | `scripts/battle.gd` | `_malice_on_damage` | `if dealer == null or not dealer.is_hero:` |
| the overkill figure, at the damage door | `scripts/unit.gd` | `_report_taken` | `var past_last := maxi(amount - lost, 0) if hp <= 0 else 0` |
| the kill term, whoever dealt the kill | `scripts/battle.gd` | `_on_unit_died` | `_malice_fill(MALICE_PER_KILL)` |
| every death reaches it, the statuses still on the body | `scripts/unit.gd` | `_die` | `died_cb.call(self)` |
| the one way out, and its floor at zero | `scripts/battle.gd` | `_malice_pay` | `malice = maxi(malice - points, 0)` |
| a warband heal pays what the body gained | `scripts/battle.gd` | `_warband_heal` | `_malice_pay(maxi(body.hp - hp0, 0))` |
| a Raise pays the health it stands a body up with | `scripts/battle.gd` | `_resolve_special` | `_malice_pay(target.hp)` |
| a Rally pays its price | `scripts/battle.gd` | `_resolve_special` | `_malice_pay(MALICE_RALLY_PRICE)` |
| an Entrench pays its price | `scripts/battle.gd` | `_resolve_special` | `_malice_pay(MALICE_ENTRENCH_PRICE)` |
| a heal is bounded at resolution by what no declaration has set aside | `scripts/battle.gd` | `_warband_heal` | `var ask := fig if body.has_status("blight") else mini(fig, _malice_free(caster))` |
| a declared spend is bought at the body's turn, asking the list, the cost and the cooldown, never the pool | `scripts/battle.gd` | `_warband_free_spend` | `if not _intent_ability_usable(u, ab):` |
| what the pool did, read by the instruments and by three warband heals' log lines | `scripts/battle.gd` | `—` | `var malice_ledger := {"generated": 0, "banked": 0, "wasted": 0, "spent": 0}` |
| a heal's log line reads the ledger around its own call | `scripts/battle.gd` | `_resolve_special` | `growth_spent = int(malice_ledger["spent"]) - growth_spent` |
| the strip redraws on every change, a rise or a fall | `scripts/battle.gd` | `_refresh_malice_strip` | `_malice_fill_rect.size = Vector2(84.0 * clampf(float(malice) / MALICE_CAP, 0.0, 1.0), 6)` |
| the strip's count | `scripts/battle.gd` | `_refresh_malice_strip` | `_malice_count.text = "%d/%d" % [malice, MALICE_CAP]` |
| a field a hero's blow carries, read on every hit and costing no turn | `scripts/battle.gd` | `_resolve` | `if ab.delay_push > 0.0:` |
| the hit's status line, both sides' blows alike | `scripts/battle.gd` | `_resolve` | `if not result.died and not ab.applies_status.is_empty() \` |
| a card with a `special` is handed off before the strike loop, and runs no on-hit line | `scripts/battle.gd` | `_resolve` | `await _resolve_special(attacker, ab, target, grade, dmg_mult)` |

**WHAT EXISTS.** **Where Malice is added**: `_malice_fill`, the one way in, called from two doors — the damage door's
`_malice_on_damage` (a point every `MALICE_DAMAGE_STEP` of health the hero side removes, and every point a blow spends past a body's
last, the two summed into one call) and the death door's `_on_unit_died` (`MALICE_PER_KILL` for every body of the warband that falls,
*whoever dealt it*). **Where it is spent**: `_malice_pay`, the one way out — a warband heal (what the body gained) and the three spends
(a Raise, a Rally, an Entrench) in their `_resolve_special` arms. **Nothing else subtracts from it**: the pool has exactly two writes,
`malice += got` and `malice = maxi(malice - points, 0)`. **A floor at zero exists**, in `_malice_pay`'s own line. **The strip shows
a fall**: `_refresh_malice_strip` is called from the pay as from the fill and sets the bar's width and its count off `malice` each
time (not in a sim). **The ledger** books every point that left as `spent`, which the instruments read as what the warband bought, and three warband heals' log lines print *— N Malice* off its difference around their own call (the source's comment, *nothing in the game reads it*, is stale: FOUND AT JP).

**WHETHER A HERO's BLOW COULD CARRY A DRAIN THE WAY A WARBAND BLOW CARRIES A HEX.** The shape exists and costs the party no turn: the
strike loop in `_resolve` reads a blow's own fields on every hit, the hero side's and the warband's alike — `applies_status` lays its
status on a hit (that is how a hex rides a warband blow since JO), and `delay_push` moves the struck body's clock on a hit. **Nothing
drains Malice today**: no field, no status and no handler reaches `_malice_pay` but the four above, and `applies_status` lays a status on
a body, while the pool is the fight's, on no body. **The blow must be a damaging card that is no `special`**: `_resolve` hands a
`special` to `_resolve_special` before the strike loop, so it runs no on-hit line. **What a card would have to add**: a field on `Ability` read in the strike loop beside
`delay_push`, after the Block and the miss (so a blocked or missed blow drains nothing), taking points out through a door of its own or
through `_malice_pay` — and if through `_malice_pay`, the ledger would book the drain as `spent` beside the warband's own heals, so
a fourth ledger key keeps the instruments' readings true (the heals' log lines take a difference around one call, so a drain at another moment does not reach them); and a sentence in the strip's tooltip (`_malice_words` states every way in
and out). **And it meets a declaration**: a heal or a spend sets its price aside when it is declared (`_malice_free`), a heal is bounded
at resolution by what is free, but a declared spend is bought at the body's turn without asking the pool (`_warband_free_spend`) and pays
its flat price through the floor — so a drain between a declaration and its buy lets a Rally or an Entrench land underpaid, the pool paying only
what is left while the ledger books the full price as `spent`. A drain that respects the reserve, or a spend asked its price at the buy, closes it. **Cost**: one `Ability` field, about five lines in `_resolve`, a ledger key, one tooltip sentence, and a gate driving a
blow that lands, one that is blocked and one that misses.

**WHAT THE +25-A-KILL AND THE OVERKILL TERMS WOULD TAKE TO SWITCH OFF CONDITIONALLY.** **The kill term** is one unconditional call in
`_on_unit_died`, and the death door is reached from `unit._die` before the body's statuses are cleared — so a condition on **the
dying body** (a status a hero laid on it) is in scope at that line, and **the killer** is reachable there by `_frame_dealer()`
(read four lines below it for the Reaver). One `if` around the call is the whole change; a debug kill (`_debug_kill_enemies`) passes
the same door, and **a Raised body's second fall fills it again** (FOUND AT JK), so a condition says whether it reads that fall. **The overkill term** is the `past_last` half of `_malice_on_damage`'s one call, with the victim and the dealer in scope:
a condition there zeroes `maxi(past_last, 0)` and leaves the damage term standing. **Cost**: each is one condition and a gate that
drives a kill or an overkill both ways.

## 2. REFUSING A HEX

| door | file | function | the line, quoted |
|---|---|---|---|
| an area blow rolls no miss: the single blow's miss names it out | `scripts/battle.gd` | `_resolve` | `elif not is_counter and not ab.aoe and ab.multi_hits == 0 and ab.random_hits == 0 \` |
| an area blow cannot be parried | `scripts/battle.gd` | `_resolve` | `if not is_counter and not ab.aoe \` |
| Block: no counter, no Broken body (and no companion, the line below it) | `scripts/battle.gd` | `_resolve` | `if not is_counter and not strike_target.broken and not strike_target.dead \` |
| the base Block is the first source | `scripts/battle.gd` | `_resolve` | `if not bared and block_roll < strike_target.block_chance:` |
| a hero's Block, unless his spec sets one | `scripts/unit.gd` | `—` | `var block_chance := 0.0` |
| the one spec that sets it | `scripts/classes.gd` | `—` | `"max_hp": 200, "armor": 0.32, "block_chance": 0.10,` |
| the spec's figure reaches the body | `scripts/classes.gd` | `—` | `cfg["block_chance"] = float(info["block_chance"])` |
| the Block a Covering Guard lends, and Heavy Plating's slice | `scripts/battle.gd` | `_live_block_chance` | `var bc := u.block_chance + _plating_slice(u)` |
| the slice: Heavy Plating's, widened by Shieldwall and by a Split Shield's Bulwark Line | `scripts/battle.gd` | `_plating_slice` | `if u.has_status("bulwark_line"):` |
| the hit lays its hex: no roll but the move's chance | `scripts/battle.gd` | `_resolve` | `and randf() <= status_chance:` |
| a move's chance, when it names none | `scripts/ability.gd` | `—` | `var status_chance := 1.0` |
| the status door every hex passes | `scripts/battle.gd` | `_resolve` | `_apply_status(strike_target, ab.applies_status["id"], turns, status_meta,` |
| a refusal before a status lands: a boss's hard control | `scripts/battle.gd` | `_apply_status` | `if not force and id in ["stunned", "frozen", "psychosis", "bewitch", "hysteria"] \` |
| a refusal before a status lands: Ironclad, three named ids | `scripts/battle.gd` | `_apply_status` | `if target.has_status("ironclad") and id in ["stunned", "frozen", "dazed"]:` |
| a refusal before a status lands: Hallowed, every debuff | `scripts/battle.gd` | `_apply_status` | `if target.has_status("sanctified") and BattleUnit.DEBUFF_IDS.has(id):` |
| what lays Hallowed: an Empowered Divine Plea | `scripts/battle.gd` | `_resolve_special` | `_apply_status(target, "sanctified", 3, 0, 0, attacker)` |
| the four hexes are debuffs | `scripts/unit.gd` | `—` | `"gall", "sap", "mire", "fester",` |
| a rebound that would turn a debuff back, its field written by nothing | `scripts/battle.gd` | `_resolve` | `var mirror_r := _max_hero_rank("mirror_ranks")` |
| the one duration term on the body that receives | `scripts/unit.gd` | `add_status` | `turns = maxi(turns + mod_status_turns, 1)` |
| the cleanse's one filter (Unburden, the Empowered heals) | `scripts/unit.gd` | `purge_debuffs_taken` | `if s.id == "broken" or _is_sticky(s) or not DEBUFF_IDS.has(s.id):` |
| a Dispel on a hero, and the talent's turn-start wash | `scripts/unit.gd` | `dispel_one_debuff` | `if s.id != "broken" and DEBUFF_IDS.has(s.id):` |
| Field Dressing sheds one, on its caster | `scripts/battle.gd` | `_resolve_special` | `var fd_shed := attacker.dispel_one_debuff()` |
| the Rune of the Medic sheds one, on the lowest hero | `scripts/battle.gd` | `_field_kit_mend` | `var fk_shed := pick.dispel_one_debuff()` |
| the Cleansing Draught reads the Rite's filter | `scripts/battle.gd` | `_use_item` | `for cl_s in _cleansable_debuffs(cl_target):` |

**WHAT EXISTS.** **The miss**: a single blow rolls one; the branch that rolls it names `not ab.aoe` out, and the per-strike miss
names only the multi-hit, random and chosen kinds — so Gall and the Wretched Bellow, area blows, roll none, and **no area blow can be parried**
either. **The Block** is the one roll left: it negates the whole hit and its on-hit effects (the hex with it), and it is no companion's
and no Broken body's. **`block_chance` has no universal baseline**: `0.0` on every hero but the Warden (`0.10`); on the warband's side
the Shieldmaster carries `0.05` — with Heavy Plating's slice (widened by Shieldwall and by a Split Shield's Bulwark Line, which the brief's list leaves out), Interpose's charges and a Covering Guard, which lends the covering Warden's own chance (a caster with none lends none), the other sources; no talent's payload
and no live rune writes it (the Rune of the Sentinel's `+4%` and the Rune of the Iron Promise's `+10%` are retired). So **most heroes cannot defend against an area hex by any
roll**. **Every door a status passes onto a hero**: the strike loop's status line in `_resolve` (a hit, not a death, and the move's
`status_chance`, `1.0` when it names none — none of the four hex blows names one), then `_apply_status`, then `unit.add_status`.
**Something does refuse a status before it lands** — three things, all in `_apply_status`'s head: **a boss's hard-control immunity**
(the warband's side only, a boss unbroken); **Ironclad**, a Warrior's card, refusing three named ids (`stunned`, `frozen`, `dazed`) and
no hex; and **Hallowed**, which an **Empowered Divine Plea** lays on the hero it heals for 3 turns, refusing every id in `DEBUFF_IDS`
— **the four hexes among them**. Umbral Mirror's rebound would turn a warband debuff back onto its caster, but its field
(`mirror_ranks`) has no writer, so it is dormant. **No resistance roll exists on a hero**, and no ward absorbs a status (a
barrier absorbs damage; the status line asks only that the body did not die). Fleeting's `mod_status_turns` shortens a status on the
body that receives it, and refuses none.

**WHICH CLEANSES REACH WHICH HEX TODAY.** All four hexes are in `DEBUFF_IDS` and none is sticky (JL §2), so every cleanse the party owns
reaches every one of them: **Unburden** (the Cleric's, `purge_debuffs_taken`), the **Empowered Holy Heal** and the **Empowered Divine
Plea** (`purge_debuffs`, the same filter), **Dispel** on a hero (the Mage's class card; `dispel_one_debuff`, one at random a count),
**Field Dressing** (one, on its caster), the **Rune of the Medic** (one, on the lowest hero), the tier-2 talent **Cleanse Debuffs Each
Turn** (two at the holder's turn start, each off a random ally, a companion among them), and the **Cleansing Draught**
(`_cleansable_debuffs`, the item). Two more cleanse sites, On the Mend's and Cleansing Waters', have no writer, as Umbral
Mirror has none. Every single-pick cleanse
picks at random among every debuff but Broken — Bleed among them — so it does not aim at a hex. Gall, Sap, Mire and Fester alike; **each removes after, and only Hallowed refuses before.**

**WHAT A REFUSAL WOULD NEED, BEYOND HALLOWED.** The door is built: a refusal is one `if` in `_apply_status`'s head, beside the three
that stand, reading a status on the target and returning before the status lands, with its float text and its log line — Ironclad's
shape for a named few ids, Hallowed's for every debuff. **What a card would add** is only what lays the refusing status (a card's
handler or a blow's `applies_status`), and a gate driving a hex refused and one not. **Cost**: a status row, one `if`, the handler.

**WHAT A BASE BLOCK FOR EVERY HERO WOULD TOUCH.** `var block_chance := 0.0` in `scripts/unit.gd` is a default that a spec's figure
replaces: `classes.gd` copies a hero spec's `block_chance` into the body's config, and `unit.setup` writes every config key over the
field. So a base at that default reaches every hero but the Warden and every warband body but the Shieldmaster — the Warden's `0.10`
replaces it, and so does the Shieldmaster's `0.05` (`data/enemies.json`) — and what a Covering Guard lends (the Warden's live chance,
Heavy Plating's slice on top) rises only if his row rises. A base in every spec's row is the other way. **It is the roll every blow
meets**, so it moves every fight's damage, Break damage and on-hit statuses — not the hexes alone — and the gates that drive a Block
move with it. The hero sheet's *Block* row reads the spec's own figure (`party_screen.gd`, `cfg.get("block_chance", 0.0) > 0.0`), so
it shows a base only if every spec's row carries it; `gate_fixture`'s deterministic `-10.0` is written over the field after the spawn
and does not move. **A balance question, and the designer's.**

## 3. READING WHAT THE WARBAND DECLARED

| door | file | function | the line, quoted |
|---|---|---|---|
| every body carries the field | `scripts/unit.gd` | `—` | `var intent := {}` |
| a hero never declares | `scripts/battle.gd` | `_declare_intent` | `if u == null or not is_instance_valid(u) or u.dead or u.is_hero:` |
| what a declaration holds | `scripts/battle.gd` | `_declare_intent` | `"ability": ab, "target": chosen["target"], "turns": 1,` |
| the spend riding it, the two-name plate's second name | `scripts/battle.gd` | `_declare_intent` | `u.intent["spend"] = {"ability": sp[0], "target": sp[1], "malice": _malice_price(u, sp[0], sp[1])}` |
| a wind-up is a declaration too | `scripts/battle.gd` | `_resolve_special` | `"message": "", "logs": [], "category": "windup",` |
| cleared at its own turn, before it resolves | `scripts/battle.gd` | `_revalidate_intent` | `var decl: Dictionary = u.intent.duplicate()` |
| cleared by a stun, a freeze, a hold or a Break | `scripts/battle.gd` | `_discard_intent` | `_istat("intent_discard_" + cause)` |
| Heads Down holds a declared move to the basic at re-validation | `scripts/battle.gd` | `_intent_ability_usable` | `if u.has_status("heads_down"):` |
| a warband body's Break discards its declaration, and it declares again | `scripts/battle.gd` | `_run_battle` | `_discard_intent(u, "broken")` |
| the Break meter, every body's, both sides | `scripts/unit.gd` | `take_hit` | `if pressure >= stability:` |
| the dead declare nothing | `scripts/battle.gd` | `_run_battle` | `e.intent = {}` |
| the plate reads it | `scripts/battle.gd` | `_refresh_intent_plate` | `var detail := _intent_detail(u, u.intent["ability"], cat)` |
| the plate's two names | `scripts/battle.gd` | `_refresh_intent_plate` | `line = "%s %s · %s" % [INTENT_ICONS["bolster"][0], (sp_ab as Ability).display_name, line]` |
| the turn bar's icon reads it | `scripts/battle.gd` | `_rebuild_turn_bar` | `var cat := String(u.intent.get("category", "strike"))` |
| the `CD` chip: a body's own counters, by move | `scripts/unit.gd` | `sync_cooldown_chip` | `var left := int(cooldowns.get(ab.display_name, 0))` |
| the counters | `scripts/unit.gd` | `—` | `var cooldowns := {}` |
| a talent's or a rune's condition: what it can read | `scripts/talents.gd` | `condition_met` | `if not party_condition_met(cond, ctx.get("party", [])):` |

**WHAT EXISTS.** **The field**: `intent`, a dictionary every body carries; **set** by `_declare_intent` at the end of a body's turn,
at a fight's opening, after a hold's release and after a Raise (the move, its target, whether it is support, the Malice it sets aside, the plate's category, and since JL
the spend riding it), and by a wind-up's arm in `_resolve_special`; **cleared** at the body's own turn by `_revalidate_intent` (which
copies it and empties the field before the move resolves), by a wind-up landing in `_enemy_turn`, by `_discard_intent` on a stun, a freeze, a hold or a Break, by a hijack
(`_intent_hijacked`), by the death sweep in `_run_battle`, and by a Raise standing a body up. **Its readers are all the warband's own
machinery and the plate**: the plate, its hover, the turn bar's icon, the enemy's turn, the pool's reserve (`_malice_free`), the
spends' own checks and a wind-up's cancel. **No hero card, talent or rune reads it today** — and no hero ever has one:
`_declare_intent` returns at once for a hero.

**WHETHER THE WARBAND HAS A BREAK METER OF ITS OWN — AND THE PREMISE READ THE OTHER WAY.** Every body of the warband has a Break meter,
the same `take_hit` meter a hero's is (its `stability` in `data/enemies.json`, 100 on every kind), and **an enemy's Break discards its
declared move**: the turn loop's Broken branch in `_run_battle` calls `_discard_intent(u, "broken")`, then declares again. **A hero's
Break discards nothing of the kind**, because a hero declares nothing. So the asymmetry runs the other way from the brief's premise: the
party can already make the warband lose a declared move — by Breaking, stunning, freezing or holding the body, by a madness that hijacks
its turn, or by Heads Down, which holds it to its basic at re-validation — and the warband has no
such lever on a hero's choice; and there is **no warband-level Break meter** — the one meter the warband shares is Malice.

**WHETHER A CARD COULD CONDITION ON A DECLARED MOVE's WORTH, ITS COOLDOWN, OR THE POOL's LEVEL.** **A card's handler can read all of
them but the worth**: an arm of `_resolve_special` has the picked body in scope, so `target.intent.get("ability")` (an `Ability`, its
`damage`, `pressure`, `cooldown`, `aoe` and `applies_status`), `target.cooldowns` (the counters the `CD` chip shows) and `malice` (the
battle's field) are each one read away. **A talent's or a rune's condition cannot**: `Talents.condition_met` reads a node held, a card
owned and the party's standing heroes (`ctx` carries `learned`, `member` and `party`, and the live keys are re-read only at a death or a
revive) — no enemy, no declaration and no pool reaches it. **A declared move's WORTH is not in the game at all**: JI's line is
`check_ji.line_blow`, a gate's static, so a card conditioning on worth needs the line's arithmetic moved into the game for the gate
and the card to share, or a second copy of it, which the figure rules forbid. **What a card would add**: a handler arm reading the
field, and — if its condition is to show before the cast — a line in the tooltip and a refusal or a dud reason (`_pick_dud`) where the
condition is unmet. **Cost**: a handler; for worth, the line moved into the game first.
