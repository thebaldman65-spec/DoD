#!/bin/zsh
# Headless balance sim, gated kits (the real game).
#   ./sim.sh                 -> 200 battles, the standard test party
#   ./sim.sh 50              -> 50 battles
#   ./sim.sh 50 a,b,c,d      -> custom specs (warrior,mage,cleric,hunter order)
#   ./sim.sh --sweep 200     -> 200 battles at EACH budget 3/6/9/12, fresh
#                               warband per battle — prints the difficulty
#                               curve + damage share and field size per
#                               budget (DOD_SIM_ZONE picks the roster,
#                               DOD_SIM_THEME narrows the roll to one theme)
#   ./sim.sh --run 50        -> 50 COMPLETE runs with progression on both
#                               sides (tier scaling, zone multipliers, talents
#                               earned AND spent, trophies, HP carried) —
#                               prints the run report. Policies via
#                               DOD_SIM_ROUTE / DOD_SIM_BUILDS /
#                               DOD_SIM_TROPHIES / DOD_SIM_RELICS.
# DOD_SIM_GRANT_ALL=1 ./sim.sh ... for full-kit runs.
cd "$(dirname "$0")"
sweep=""
runs=""
if [[ "$1" == "--sweep" ]]; then
  sweep=1
  shift
elif [[ "$1" == "--run" ]]; then
  shift
  if [[ "$1" == <-> ]]; then
    runs="$1"
    shift
  else
    runs=50
  fi
fi
if [[ -n "$runs" ]]; then
  DOD_SIM_RUN="$runs" \
  DOD_SIM_SPECS="${1:-berserker,cryomancer,inquisitor,beastmaster}" \
    /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
    res://scenes/battle.tscn
else
  DOD_SIM="${1:-200}" \
  DOD_SIM_SWEEP="$sweep" \
  DOD_SIM_SPECS="${2:-berserker,cryomancer,inquisitor,beastmaster}" \
    /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
    res://scenes/battle.tscn
fi
