# Dawn of Decay — project guide for Claude

Turn-based party roguelike (Godot 4.7, GDScript). **`docs/master.html`
("DoD Master Document.docx") is the authoritative design reference** — keep it
updated alongside `docs/addendum.html` (the living changelog). The original
`../*.docx` concept docs are superseded by both.

## Working agreement (user's standing rules)
- User is a beginner coder: explain plainly; Claude writes all code; user is
  the designer + playtester. Iterate on their feedback each session.
- EVERY design change: (1) update `docs/master.html` (current truth) and bump
  its "Last updated" timestamp; (2) add an entry to `docs/changelog.html`
  (newest first); (3) rebuild both docx via `python3 docs/build_docs.py`
  (unwraps paragraphs — plain textutil makes Word spacing weird; exports are
  Arial size 14 by user preference).
- master.html shows ONLY what is currently in the game (user rule 07-20):
  no vault lists, no "was/now/moved/reworked/renamed" notes, no decision
  dates — change history belongs in changelog.html alone.
- Terminology: damage against the Break meter = "Break damage (BD)" everywhere.
- `docs/addendum.html` is RETIRED (frozen history; do not update it).
- User drops new assets in `../imported files/` — always check there.
  New character sprites need the Soldier format: 100x100 frame strips named
  `Name_Idle/Walk/Attack01-03/Hurt/Death.png`.
- Commit after each change batch. Launch the game for playtesting via
  `/Applications/Godot.app/Contents/MacOS/Godot --path <this dir>` (background,
  watch stderr for errors).

## Verify before shipping
- Parse: run each scene headless with `--quit-after 90`, grep "SCRIPT ERROR".
- New `class_name` files need `--headless --import` before they resolve.
- Balance: `DOD_SIM=50 <godot> --headless --path . res://scenes/battle.tscn`
  prints a report (target ~85% wins). `DOD_AUTOPLAY=1` = 1 debug battle
  (echoes every combat-log line as "[LOG] ..." — grep it in headless tests;
  NOTE: the end screen waits for input, so headless autoplay runs never exit
  on their own — run with a timeout/kill or they pile up as zombies).
  `DOD_SIM_SPECS="berserker,cryomancer,inquisitor,beastmaster"` picks the bot's
  specs (warrior,mage,cleric,hunter order). `DOD_SIM_ENEMIES="boss,shaman,..."`
  forces the enemy lineup in test battles. `DOD_SIM_TALENTS="bz_bloodcraze:3"`
  force-learns talents on bot heroes whose spec tree has the id.
  `DOD_SIM_ABILITIES="Resurrection,Divine Plea"` appends pending
  talent-gated abilities (Classes.pending_talent_ability; Holy only).
  `DOD_ENEMIES_OFF=1` arms the enemy-skip debug toggle headlessly.
  `DOD_DEBUG=1` adds map-burger debug items (gold/points/heal/
  jump-to-boss/next-zone; the talent grant is +200).
- GDScript gotchas that bit us: multiline lambdas in call args (use named
  methods), ternaries need parens for type inference, `:=` can't infer from
  untyped funcs, edits via python heredocs (apostrophes!) — use chr(39).

## Architecture (all UI built in code, no editor scenes)
- `scripts/run_state.gd` (autoload `Run`): party/items/gold/map/zones, save
  (user://run_save.bin, auto-saved after every node), relic slots (max 3).
- `scripts/settings.gd` (autoload `Settings`): volume/fullscreen.
- `scripts/classes.gd`: hero configs, core kits, spec info/abilities, passives.
- `scripts/talents.gd`: tiered pools (1-6), per-run generated trees (2/tier),
  {id: ranks} learned dicts, `apply_payload` shared with shop runes.
- `scripts/relics.gd`: permanent unlocks (user://relics.json), 1 per boss kill.
- `scripts/battle.gd`: the big one — initiative timeline, Pressure/Break,
  skill checks, statuses, AoE/random-hits, damage types + resists, items,
  sim/autoplay modes, victory/defeat flow.
- `scripts/unit.gd`: combatant node (sheet animations, bars, status chips,
  bleed buildup meter, outline shader hover).
- Screens: main_menu → draft (pick 4 + relics) → spec_choice (permanent) →
  map (burger menu, shop/rest/loot nodes) → battle → party (talents/runes).

## Current systems snapshot (2026-07-16)
HOLY MERCY REWORK (07-22): FAITH IS GONE from all clerics (no second
resource except Holy; the +10/action build site removed; ability
faith_cost now = generic secondary cost). MIRACLE keyword retired. Core
cleric = Smite only (Mend Wounds VAULTED; Resurrection now a Holy
talent ability). Unity 25 Mana, Umbral Sigil 20 Mana. HEALING RULE:
ability heals scale off the CASTER'S MAX HEALTH (Smite/Shadowrend
perfect = 5% max HP; "self_heal" perfect handler). MERCY (Holy only,
0-5, gold bar): +1 on any party member crossing below 50% HP
(unit.below_half_cb → battle._on_hero_below_half; fires from take_hit
AND take_tick_damage, companions excluded); +5% healing done per stack
HELD (_healing_done_mult — costs deduct BEFORE specials resolve);
spenders via faith_cost (Hymn 1, Divine Plea 2, Resurrection 3).
EMPOWER: battle.empower_armed (✦ toggle on action bar + hotkey C, reset
each turn; bot sets it in the cleric policy) → _consume_empower in
_resolve_special pays +1 stack and FORCES is_perfect=false. Kit: Heal
("holy_heal" special, 40% caster HP, empower cleanses via
unit.purge_debuffs — never strips "broken"), Renewal (tick = 15% caster
HP snapshotted Mercy-scaled into status tick field; turn-start site
reads it; empower also blankets caster), Hymn ("hymn", 20/35emp/25perf %
of each TARGET's max HP), Resurrection (20/25perf/100emp % + renewal on
empower), Divine Plea ("divine_plea", full heal; empower = purge +
"sanctified" 3t — _apply_status guard bounces ALL DEBUFF_IDS while
sanctified). Status expiry now logs "fades from" (unit.tick_statuses);
STUNNED/FROZEN lost turns tick statuses+cooldowns (fix 07-22). Arcanist
tuning (07-22): Resonance dmg-taken +5%/stack (was 10); Overcharge
recoil surcharges REMOVED (weighting = passive trio only).
DEVOUT CONVICTION REWORK + TREE (07-23, 8th tree): passive "devotion"
→ "conviction". FAITH = per-ALLY stacks (unit.faith_stacks 0-5, chip
"F#") gained ONLY when a DIVINE SHIELD barrier absorbs damage for the
holder (barrier status flag "divine" → unit.shield_absorbed_cb →
_gain_faith; doubled under "zeal" status — the ×2 lives in
_gain_faith) — only while a
living Devout stands (_living_devout gate on gain AND on the
per-stack combat effects: target-side −3%/stack, attacker-side
+2%/stack in _resolve; Unwavering Faith is now +5%/rank max HP via
max_hp_pct, 07-23). At 5:
_gain_faith releases — heal (15+5×faithful)% max, reset, Devout +3%
max Mana, Communion rolls (0.20×ranks×THEIR stacks per other member).
Kit: Divine Shield v2 (15 Mana, 30/35% of Devout max HP barrier, 2cd —
_grant_divine_shield stamps riders on the barrier status:
blessed_pct/afterglow; Sacred Covenant via unit.lethal_saved_cb →
_on_lethal_saved when a barrier eats a killing blow; Radient Aegis
echo roll in the special), Consecrated Ground ("cons_ground" party
status: −15% target-side + 10% reflect after the mitigation log),
Blessing of Zeal ("zeal" ALLY status: +15% dmg attacker-side, faith
×2, cooldown −1 on cast). Sacred Resolve = ex-Unity, talent-granted
(special stays "unity"; Healing Pulse/Cleansing Waters snapshotted
onto the unity status as "pulse"/"cleanse", ticked in the turn-start
block). Bulwark of Fortitude capstone ("bulwark" status: pressure_add
= 0 in take_hit, armor ×1.5 in effective_armor, 10% max HP tick at
turn start; perfect instant 5% party heal). DIVINE WRATH VAULTED ("wrath"
status machinery kept). Devoutness talent replaces the aura: devotion
status power-driven (5×ranks%, unit.take_hit reads status_power).
STATUS RENAME: "sanctified" label now "Hallowed" (Consecrated belongs
to Consecrated Ground). Holy Capacitor banks 5%/rank (07-23, was 33).
HOLY TREE (07-22, 7th fixed tree; source JSON was one column right —
normalized): Triage (triage_ranks: _heal_crit_mult ×1.5 rolls on
instant heals — holy_heal/hymn-per-target/renewal burst, NOT renewal
ticks — + flat 3%/rank in _healing_done_mult), Heavenly Aura
(heavenly_ranks deepens the Mercy per-stack term), Holy Light (perfect
casts +1%/rank max Mana — block next to the faith_cost deduction),
Guardian Angel + Last Hope are PARTY-WIDE STAMPS set after spawn
(unit.mercy_threshold 0.5+0.03r used by _check_below_half in take_hit/
take_tick_damage; unit.last_hope_bonus applied receiver-side in
heal_amount when hp<25%), Divine Presence (end of _player_turn drip to
_lowest_hp), Inner Faith (max_hp_pct payload), Holy Capacitor
(unit.last_overheal set by every heal_amount; _bank_overheal chips
"capacitor"; released by the next holy_heal), On the Mend (ranks
SNAPSHOTTED into the renewal status dict field "mend" at every apply
site; rolled at the turn-start tick via unit.dispel_one_debuff),
Sanctified (refund rolls at BOTH spend sites: faith_cost deduction +
_consume_empower). Res/Divine Plea granted via NEW apply_payload branch
{"grant_ability": name} → Classes.pending_talent_ability (single
source with DOD_SIM_ABILITIES). STATUS RENAME: "sanctified" status
label is now "Consecrated" (chip Cn) — the talent owns the Sanctified
name; internal id unchanged.
ENCOUNTERS = POWER BUDGET (07-16): enemy power {raider/archer 1, sm/shaman
2, chief 4, boss 7}; every battle SPENDS ITS BUDGET EXACTLY via themed
warbands (Run.THEMES two-step: theme → fill roles; combos enumerated in
run_state._theme_combos; theme in encounter["theme"], logged at battle
start; field caps at 6 — ENEMY_LAYOUTS has a 6-slot layout). BUDGET
SCALES PER ZONE (Run.battle_budget; in-zone tier = floor_idx+1): t1-3 →
3-6, t4-7 → 6-9, t8-11 incl boss → 10-12; later zones restart the ladder
with NEW tougher rosters (TODO — Forest of Old only for now). CHIEFS ONLY
IN ELITE FIGHTS (Honor Guard/Rage Company/Elite Patrol are elite-node
themes; Warband pool has no chief). Swarm/Poison Volley only fit low
budgets (by math). ALL HERO ABILITY COOLDOWNS -1 (07-16); ENEMIES HAVE NO
COOLDOWNS AT ALL (kits carry none; AI gates by resources/conditions; the
"bides its time" fallback was removed — every enemy always has a 0-cost
attack, keep it that way or _enemy_turn's pick_random crashes on empty).
Orc Shaman = support: Healing Wave (25% max HP, lowest sub-40% ally,
tank/support enemy_role first) + Chain Lightning; Lightning Bolt VAULTED.
Burn REAPPLICATION extends duration by the APPLIED turns (unit.add_status
burn branch). ADJACENT IS STRICT (07-16): dead neighbor = no bonus on
that side, never jumps past corpses (_adjacent_enemies). Log itemizes
mitigation: "(nature resist -8) (armor -12) (WEAK! +9)".
CRYOMANCER TREE (07-20, 5th fixed tree): Hungering Cold/Frostbite/
Hypothermia/Frigid Grip are PARTY-WIDE talent auras read via
_max_hero_rank(field) (frigid stamps unit.frigid_bonus on victims at
chilled application); Piercing Ice (Ice Lance crit_mult), Icy Veins
(unit.icy_veins_charge armed on lance kills, consumed next lance),
Splintering Shards (extra Razor hit roll in total_hits), Whiteout
(Blizzard daze 2t), Freezing Advance (rime-echo sting), Empowered
Frostbolt (flat % add). Talent abilities: Rime ("rime" special+status,
echo in _apply_status chilled branch, _rime_echoing guard stops chains;
ALSO applies frostbite 2t on cast) and Shatter capstone (aoe filtered to
chilled targets, raw ×stacks, usable gate needs a chilled enemy, perfect
sets cooldowns["Shatter"]=5). FROSTBITE STATUS (07-20): healing received
-50% for 2t (unit.heal_amount mult; heal_amount now RETURNS the final
healed int; healing_wave/wild_growth display it + log "halved by
Frostbite"); in DEBUFF_IDS; applied by Rime cast + permafrost on-hit.
Row-1 talent renamed "Brittle Ice" (id stays cr_frostbite/frostbite_ranks
— saves keep ranks). Passive "permafrost": frozen targets take +15% from
all sources (target-side in _resolve) AND frost hits 25% chance to
frostbite (on-hit passives block in _resolve). Razor Ice v3: 2 random
@20%, always chills, perfect flat 25%. Blizzard 15% Atk (07-20).
Ice Lance 35% Atk (07-20).
ARCANIST REWORK + TREE (07-20, 6th fixed tree): core Magic Bolt →
Arcane Explosion via apply_kit_overrides (free, 10% × 2 DISTINCT random
enemies — struck_before filter in the random-hit picker — 10BD, no
perfect). Kit: Cannon (25M, 40%, BD=5×stacks computed in the pr calc,
2cd, perfect eff_delay 3.0), Barrage (20M, 8%×6 bolts @ pool of 3
lowest-HP enemies, 3BD, 2.5, perfect 7th), Stabilize special (free,
3cd, consumes ALL stacks → +5 Mana/stack + "stabilized" chip 10%/stack
DR 2t target-side in _resolve; usable gate ≥1 stack; perfect heals 5%
max HP). DEATH RAY VAULTED ("mana15" perfect machinery kept). Talent
abilities: Overcharge special (unit.overcharged + overcharge_mult
1.5/1.65 perfect, second_max=8, once-per-battle gate; Cannon/Barrage
+15% recoil in the recoil block) and Magi's Wrath capstone (aoe 15%,
+4%/stack, BD 2.5×stacks, recoil 15%−3% per enemies_struck, perfect
eff_delay 3.5). _resonance_power(u) weights stacks 6-8 — used by
dmg/crit/dmg-taken + tooltip buff_mult + plate readout; Backlash Ward
fires at the dynamic max. Talents: Mindfulness (extra cooldown tick
every 7−ranks turns, turn-start block), Arcane Mastery (+1%/rank
crit/stack), Mana Attunement + Unlimited Power (both inside
_gain_resonance — overflow branch returns early), Temporal Rift (crit
echo after the sigil block), On the Edge (post-take_hit in the strike
loop, threshold (20+5r)% — RISES with ranks, user-corrected 07-20),
Conversion + Stable Alignment (unit.take_hit — cap (40−5r)% max HP),
Critical Mass (crit_streak in the crit branch),
Suppressing Fire (Barrage ramp in raw calc). Talents.desc_for renders 2
decimals now (0.25 steps). Bot mage rotation: Wrath ≥3 foes/≥3 stacks →
Overcharge ≥4 stacks → Stabilize at max stacks under 70% HP → Cannon ≥2
stacks → Barrage. DEBUG: "Cooldowns OFF" CHECK
toggle (debug_cooldowns_off — start_cooldown skipped while on; replaces
the old reset command).
CRYOMANCER REWORK (07-18): archetype CONTROL (new, Damage role/100 Atk,
ARCHETYPE_ROLE+DESC). CHILLED = STACKING debuff (max 4, unit.add_status
chilled branch + _chilled_desc; reapplication RESETS the 3-turn clock;
chip "C#"): x1 -25% speed, x2 -50% (effective_speed), x3 also -15% dmg
dealt (attacker-side in _resolve); 4 stacks → FROZEN in _apply_status
(stacks reset, frozen = lose next turn like stunned — own block in
_run_battle; bosses resist unless Broken; unit.was_frozen marks it).
Passive "shattering" (replaces "chill" on-hit, which is GONE): +2% crit
per enemy was_frozen this battle (live spec chip). Kit: core → Frostbolt
via apply_kit_overrides (free, 20% Atk frost, 1 chilled stack, perfect
flat 25%); Razor Ice v2 (3 random, +3%/chilled stack, perfect chills
unchilled); Blizzard v2 (aoe, 1-2 stacks each, perfect_id "mana5");
Ice Lance (auto-crit vs frozen, perfect pr=20). Old Frost Bolt VAULTED.
PYROMANCER REWORK (07-16): passive "inferno" = Inferno Master (+5% dmg
per burning enemy, cap 25%; live spec chip via _update_talent_chips; the
old "ignite" on-hit passive is GONE). Core Magic Bolt → Fireball via
apply_kit_overrides (free, 20% Atk fire, 15BD, burn 3t; perfect = flat
25% Atk in _resolve). Kit: Detonation (consumes target burn pre-mitigation
for tick×turns bonus, perfect re-burns 1t), Wildfire (spreads target burn
to Adjacent at half duration rounded up — captured PRE-hit so kills still
spread), Flamewave (aoe; burning targets +2t, perfect +3t via
update_status). VAULTED: Pyroblast, Flame Surge, Phoenix Rebirth, and
Mana Shield from ALL mage specs (mage core = Magic Bolt only; specials
"phoenix"/"mana_shield" machinery kept for the vault). Resurrection
5cd. Autoplay mage policy = burn loop (Flamewave ≥2 burning / Detonation
≥3 turns / Wildfire) then the Arcanist rotation (see the 07-20 ARCANIST
block above) / Barrage / basic.
ATTACK & SCALING (07-16): every unit has an Attack stat; ability `damage`
is a PERCENT of the user's current Attack. Role bases: Damage 100 / Tank 75
/ Support 50 (Classes.spec_attack; Bruiser = Damage role; per-spec stat
blocks + "resists" dicts land class by class — spec_resists, 0% now, shown
via stat-page "Resistances" hover). Heroes: +2% of base Atk/HP per combat
win (Run.combat_wins, saved); enemies: +4% Atk / +5% HP of base per global
node tier (zone_idx*FLOORS+floor_idx, replaces zone mult), HP rounded UP
to 10s.
Armor/resists/speed/con/crit/block/parry NEVER scale. DoTs (burn 6%,
poison 3%/stack) snapshot the applier's Attack ("tick" on the status);
companions hit for % of the hunter's Attack. Cleric core Smite = 44% (of
50 Atk); Warden Mocking 27%/Crushing 43%/War Stomp 15%x3 (75 Atk);
Shieldmaster Strike 37% (75); Shaman 70%/30% (50) + fire/frost 25%,
nature 50% resists. PARRY IS MELEE-ONLY (attacker.is_ranged — hunter+mage
ranged among heroes); parries and blocks log their SOURCE (reflexes/Sword
Mastery/Parry Up; Shieldwall/Heavy Plating/base Block — Warden Tenacity
+5 maxHP battle-long (tenacity_hp_gained excluded from save sync) and
Rally (party rally_heal +15% healing 2t) proc on HEAVY PLATING blocks
only). Warden tree v2 (07-16 JSON): Endurance 1%/rank. Talent tooltips:
desc "{v}" + "scale" {base, step} → Talents.desc_for renders invested
value (never "per rank"). Saved runs swap tree snapshots for live defs on
load (refunds orphans). War Stomp: allies regain 10% resource post-cast.
Class passive NOT on draft cards (awakening screen + party sheet only).

## Older snapshot (2026-07-10)
4 heroes (Warrior/Mage/Cleric/Hunter — one of each), 3 specs each, per-run
shuffled talent trees, damage types (7) with resists + Weaknesses (config
"weak": [types] = +25% damage taken, "WEAK!" feedback; assignments TBD),
bleed buildup (100 = 20% max HP bleedout, ignores armor; poison ticks count
as nature damage),
gold + shop runes (rarity-generated, 2 equip slots), 2 zones (Forest →
Scarlands). Basic orcs: Raider, red Archer (poison), orange Shieldmaster
(single-ally 25% ward), blue Shaman (nature caster, party-wide Chain
Lightning); Chief = elite; Withered Warden has a unique boss kit (Timber Slam
+ Dazed / Roots of Wrath / Wild Growth, 75% nature resist). Every encounter =
3-5 random-typed foes (elite/boss nodes: Chief/boss + 2-4 basics). Relics
meta layer. Map: 10 tiers × 3 nodes + boss; fixed 18 fight / 6 rest / 6 shop;
links = own column + 70% one adjacent (never all 3). Elites drop rune + item +
80-100 gold. Music autoload (menu/map/battle + boss intro; spec choice = menu
track, boss tune plays on spec-confirm fade to map), zone battle art, bow SFX,
full-scene 1:1 battle camera (sprites 3.2/3.9/4.4). Specs overhauled 07-08:
Swordmaster Seasoned Fighter + Pommel Strike, Devout (ex-Inquisitor) Unity,
Occultist Mind Flay, Beastmaster summonable companions (sphere placeholders,
no timeline turns, "Summon Companion ▸" submenu), Survivalist Trapper +
stacking Poison (3/turn/stack), Chilled = renamed Slow. Break meter 0-100 w/
numeric readout; CONSTITUTION = break resistance (pressure × 100/con; per-spec
values in SPEC_INFO, bosses 160 + stun-immune unless Broken). Talent pools are
THEMATIC per spec (8 signatures each, T5 = new ability). See master.html §6-7.
Combat: crit 10%; miss 5% (Dazed +20%); parry 5% heroes / 2.5% enemies —
a PARRIED hit lands at 25% damage + 25% BD, no auto-counter ("Counter
Attack" = parry-answer basic; Riposte talent grants it); BLOCK = full
negation (block_chance stat: Warden 5% + Heavy Plating 15%, Shieldmaster
5%; Shieldwall charges guarantee); COOLDOWNS on all abilities (unit.
cooldowns, ability_ready; enemies + bot respect them); Armor Pen keyword;
Buff/Debuff keyword (DEBUFF_IDS in unit.gd); ADJACENT keyword = nearest
living enemy each side of the target in formation order (_adjacent_enemies;
Sundering splashes only there). TALENT VISIBILITY (07-16): procs log as
"Talent: ..." lines (log_proc hook on units for unit-side procs); stateful
talent buffs are chips w/ live counters (Enraged/Unrelenting 3-turn con/
Endurance/Iron Will/Crushing Blows/Battle Shout/Shieldwall SW#/Elemental
Weakness -x%) via unit.update_status + battle._update_talent_chips; buff
casts (shield_block/hold_the_line/battle_shout) are self-cast, no target.
CLASS PASSIVES (all specs): Warrior targeted 1.2x, Cleric +15% heals
received, Hunter acts first, Mage +10 mana/turn — shown on draft cards,
the awakening screen, and the party sheet (sheet stats mirror battle math:
spec constitution + Toughness, stance-aware passive text). Mocking Blow taunt; ability hotkeys by MENU slot; Tab/Space/
X/Alt controls; Space continues victory screens. TALENT TREES ARE FIXED-
ONLY (berserker/swordmaster/warden/pyromancer 12-node grids, row gating
5/10/15 + prereqs, talents.gd; others "coming soon"). Talent ranks
ADDITIVE. PYROMANCER TREE (07-18): Accelerant (+1%/rank burn tick, in
_dot_tick), Pyromaniac (+1%/rank inferno step), Super Nova (Detonation
crit), Invigorating Ashes + Melt Armor (burn-tick site in _run_battle;
melt = enemy "melted" chip + unit.melted armor shred, in DEBUFF_IDS),
Molten Core (target-side), Explosive Force (fire-crit burn extend),
Seeding Embers (unit.burn_at_death captured in _die, harvested in
_update_talent_chips → "seeding" buff), Ashes of Al'ar (self-revive in
take_hit/take_tick_damage, 11%/rank, ashes_used once/battle), Implosion
(Detonation echo via _free_copy). Talent abilities: Flame Shield
("flame_shield" special+status, self-cast, thorn burn in the Trapper
block; perfect = pulse ticks all burning) and Firestorm capstone
(random_hits, 6-8 bolts rolled by display_name in _resolve, 7-9 perfect). Warrior kits reshuffled 07-15
(Crushing Blow to Warden, Sweeping Strikes, talent-granted Lunge/Execute/
Shieldwall v2/Hold the Line/Battle Shout/Rampage-recast). Unit UI lives on NAMEPLATE stacks
(180px plates, heroes left edge, enemies right; portrait + name + bars +
chips; ACTING unit's plate = gold border, that's the turn indicator — no
arrow; hover/Tab lights plates; plain style until UI assets arrive); parties
grouped tight; combat log hideable (– button). SPECCED HEROES DISPLAY THEIR
SPEC NAME everywhere (unit_name = spec; logic keys on unit.hero_key — never
match display names!). Battle DEBUG ▾ menu (bottom-right): Full Restore,
Reset cooldowns, Enemy attacks OFF, per-hero turn LOCK (every HERO turn
theirs — enemies still act; displaced heroes' clocks tick as if they acted).
Renewal is Holy-only (15 HP/turn). Cleric core has Resurrection (40 Faith,
revive 20% hp/resource, targets the fallen); Devout has Divine Wrath
("wrath" status +15% dmg/speed); Occultist: Shadowrend basic (via
Classes.apply_kit_overrides — call it wherever kits are assembled!),
Mind Flay 30 Mana, Umbral Sigil (50% damage echo to the branded enemy's
party). RESOLUTION TEMPLATE DECIDED 07-12: Pyromancer size wins — author
characters at 236px frames shown 1:1; Berserker (124px @1.25) is legacy
until re-generated. Own-art specs live in battle.gd SPEC_ART (untinted).
Partial sheets fall back — see unit.gd _build_sprite. Battle bg at max
zoom-out (cover 1296x736). Beastmaster: "Summon Companion" = menu slot W →
beast picker (Tab/Space/X); hotkeys map to _menu_entries slots, NOT raw
ability indices. ALL battle UI ~20% smaller (plates 144px, log 240px). Specs carry archetype
tags (Ramp/Rush/Nuker/Pressure/Healer/Warder/Tank/Bruiser) in SPEC_INFO.
Battle has burger menu (restart/settings overlay/exit); skill checks accept
Space or left click; no announcer text (combat log only).

## Known open threads
- Menu background image not yet in imported files (fallback: forest art).
- Distinct Mage/Cleric/Hunter sprites awaited from user.
- Boss tri-choice class modifiers deferred (design doc) until 3+ zones.
- Full rune loot table pending; relic pool needs growth (5 now).
- Sim bot wins ~90%+ with 4 heroes; real difficulty tuning by user playtest.
