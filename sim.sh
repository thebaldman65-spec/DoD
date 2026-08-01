#!/bin/zsh
# Headless balance sim, gated kits (the real game).
#   ./sim.sh                 -> 200 battles, the standard test party
#   ./sim.sh 50              -> 50 battles
#   ./sim.sh 50 a,b,c,d      -> custom specs (warrior,mage,cleric,hunter order)
#   ./sim.sh --sweep 200     -> 200 battles at EACH budget 3/6/9/12, fresh
#                               warband per battle — prints the difficulty
#                               curve (DOD_SIM_ZONE picks the roster,
#                               DOD_SIM_THEME narrows the roll to one theme)
# DOD_SIM_GRANT_ALL=1 ./sim.sh ... for full-kit runs.
cd "$(dirname "$0")"
sweep=""
if [[ "$1" == "--sweep" ]]; then
  sweep=1
  shift
fi
DOD_SIM="${1:-200}" \
DOD_SIM_SWEEP="$sweep" \
DOD_SIM_SPECS="${2:-berserker,cryomancer,inquisitor,beastmaster}" \
  /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
  res://scenes/battle.tscn
