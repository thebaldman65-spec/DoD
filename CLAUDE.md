# Dawn of Decay — project guide for Claude

Turn-based party roguelike (Godot 4.7, GDScript). **`docs/master.html`
("DoD Master Document.docx") is the authoritative design reference** — keep it
updated alongside `docs/addendum.html` (the living changelog). The original
`../*.docx` concept docs are superseded by both.

## Working agreement (user's standing rules)
- User is a beginner coder: explain plainly; Claude writes all code; user is
  the designer + playtester. Iterate on their feedback each session.
- EVERY design change: append to Change Log in `docs/addendum.html`, then
  `textutil -convert docx -output "/Users/zipples/Documents/DoD/DoD Implementation Addendum.docx" docs/addendum.html`
- Keep `docs/master.html` current for anything it covers, then
  `textutil -convert docx -output "/Users/zipples/Documents/DoD/DoD Master Document.docx" docs/master.html`
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
  prints a report (target ~85% wins). `DOD_AUTOPLAY=1` = 1 debug battle.
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

## Current systems snapshot (2026-07-06)
4 heroes (Warrior/Mage/Cleric/Hunter — one of each), 3 specs each, per-run
shuffled talent trees, damage types (7) with resists, bleed buildup (100 =
20% max HP bleedout), gold + shop runes (rarity-generated, 2 equip slots),
2 zones (Forest → Scarlands, orc enemies incl. red Archer w/ poison), relics
meta layer. Map: 10 tiers × 3 nodes + boss; fixed 18 fight / 6 rest / 6 shop;
links = own column + 70% one adjacent (never all 3). Elites drop rune + item +
80-100 gold. Music autoload (menu/map/battle + boss intro), zone battle art,
bow SFX, full-scene 1:1 battle camera (sprites 3.2/3.9/4.4). Combat: crit 10%/miss 5%/parry 5%, Mocking Blow taunt, per-ability
initiative ghost preview (no Guard — removed by design). Specs carry archetype
tags (Ramp/Rush/Nuker/Pressure/Healer/Warder/Tank/Bruiser) in SPEC_INFO.
Battle has burger menu (restart/settings overlay/exit); skill checks accept
Space or left click; no announcer text (combat log only).

## Known open threads
- Menu background image not yet in imported files (fallback: forest art).
- Distinct Mage/Cleric/Hunter sprites awaited from user.
- Boss tri-choice class modifiers deferred (design doc) until 3+ zones.
- Full rune loot table pending; relic pool needs growth (6 now).
- Sim bot wins ~90%+ with 4 heroes; real difficulty tuning by user playtest.
