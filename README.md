# Dawn of Decay

A turn-based, party-based roguelike, made in Godot with GDScript.

**This file holds only what does not change.** Where the project is right now is in
[`docs/state.md`](docs/state.md), which is rewritten every batch.

## Which file to open first

- **[`CLAUDE.md`](CLAUDE.md)**: the standing rules, and the required read before any change.
- **[`docs/state.md`](docs/state.md)**: where the project is: what is open, what is broken, the live
  counts.
- **[`docs/master.html`](docs/master.html)**: what the game is. It is the authoritative design
  reference.

## Where things live

- `scripts/`: the game's code.
- `scenes/`, `data/`, `assets/`, `shaders/`: the scenes, the content tables, the art, sound and fonts,
  and the shaders.
- `docs/`: the design reference, the changelog, the rule references, the design notes, and one report
  per batch in `docs/reports/`.
- `DoD-archive/`: the older half of the changelog, reached through the live changelog's own header.
- The repository root: `project.godot`, the test suites (`test_*.gd`), the gates (`check_*.gd`) and
  `run_battery.sh`, which runs them all. How a batch verifies itself is in
  [`docs/instrument-rules.md`](docs/instrument-rules.md).

To play, open this folder in Godot and run the project.
