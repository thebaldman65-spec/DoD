# Dawn of Decay

Turn-based, party-based roguelike RPG. Phase 1: combat prototype.

## How to play the current build

1. Open Godot → Import → select this folder (`DoD/game`) → open the project.
2. Press **Cmd+B** (or the ▶ button top-right) to run.
3. On a hero's turn, click an ability, click a target, then hit **SPACE** when the
   cursor is in the gold zone (Perfect) or green zone (Good).

## What's implemented (Phase 2 in progress)

- Spire-style run map (`scenes/map.tscn`, the main scene): branching floors of
  Fight / Elite / Rest / Loot nodes capped by a Boss; party HP and shared items
  persist between battles; victory offers Rest-or-Scavenge; defeat ends the run
- Zones are flavor: enemy roster + background per region (Forest of Old first)

## Combat (Phase 1)

- Party of 3 (Warrior/Rage, Mage/Mana, Cleric/Mana) vs 2 Orc Raiders + 1 Orc Chief
- Initiative timeline (speed + per-ability delay costs, next 10 turns shown top-left)
- Pressure / Break: purple bar under HP; fill it past Stability and the unit
  BREAKS — loses next turn, defenses drop, +25% crit taken
- Timing-bar skill checks on every ability (Perfect / Good / Miss)
- Crits, armor, floating damage numbers, victory/defeat + restart

## Automated testing

(Point at the battle scene directly — the main scene is now the run map.)

- `DOD_AUTOPLAY=1 <godot> --headless --path . res://scenes/battle.tscn` — one
  auto-played battle with debug prints
- `DOD_SIM=200 <godot> --headless --path . res://scenes/battle.tscn` — 200
  max-speed battles, prints a balance report (win rate, rounds, damage share,
  breaks, roll rates, ability usage)

## Project layout

- `scenes/battle.tscn` — entry scene (everything is built in code)
- `scripts/battle.gd` — battle manager: turn loop, UI, damage math
- `scripts/unit.gd` — one combatant: sprite sheet animation, stats, bars
- `scripts/ability.gd` — ability data definition
- `assets/sprites/` — Soldier + Orc sheets (100x100 frames)

## Documentation

- `docs/master.html` — the authoritative design reference (current truth)
- `docs/changelog.html` — what changed and when, newest first. **This is the RECENT
  half only: it starts at Batch BP (2026-08-13).** Everything older lives in
  `changelog-archive.html` in the archive folder below.
- `docs/design-notes.md` — the "why" behind each batch, rationale only
- `docs/build_docs.py` — builds the Word exports of master + changelog into `DoD/*.docx`

**The archive folder is `DoD-archive/`**, one level up beside the `.docx` exports and
**outside this repo**. It holds the older half of the changelog (`changelog-archive.html`,
Batch BO back to Batch 1) and the retired `addendum.html`. It is kept out of the repo so
the knowledge-base sync does not carry it — but that means **it is not in version control
and is not backed up by GitHub**, so the folder needs to sit somewhere the machine itself
backs up (iCloud Drive, a Time Machine target, or a second private repo).

Design docs live one folder up in `DoD/*.docx`.
