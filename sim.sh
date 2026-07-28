#!/bin/zsh
# Headless balance sim, gated kits (the real game).
#   ./sim.sh              -> 200 battles, the standard test party
#   ./sim.sh 50           -> 50 battles
#   ./sim.sh 50 a,b,c,d   -> custom specs (warrior,mage,cleric,hunter order)
# DOD_SIM_GRANT_ALL=1 ./sim.sh ... for full-kit runs.
cd "$(dirname "$0")"
DOD_SIM="${1:-200}" \
DOD_SIM_SPECS="${2:-berserker,cryomancer,inquisitor,beastmaster}" \
  /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
  res://scenes/battle.tscn
