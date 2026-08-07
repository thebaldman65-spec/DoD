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
#                               DOD_SIM_ROUTE (retained, but a line offers no
#                               route choice) /
#                               DOD_SIM_SHOPS=off / DOD_SIM_ITEMS=off (both
#                               on by default: heal-first shopping with a
#                               40g reserve, drink a Health Potion under
#                               35% HP) / DOD_SIM_BUILDS / DOD_SIM_TROPHIES /
#                               DOD_SIM_RELICS.
# Batch AN: a run is a LINE (3 zones x 12 fixed slots), so DOD_SIM_ROUTE has
#   nothing left to choose and the report's "choice" figure reads 0% by
#   design. DOD_SIM_MAP, DOD_SIM_MINIBOSS, DOD_SIM_START_RUNE and
#   DOD_SIM_SPEC_OPENING are RETIRED with the features they controlled; a
#   Matrix row now reads map=line and reports depth out of 36 SLOTS, so no
#   pre-AN row is comparable with a post-AN one.
# DOD_SIM_DIFFICULTY=wanderer ./sim.sh --run ... = the alpha testing
#   difficulty (enemies x0.7 via the zone ladder). Default standard —
#   never set for baseline rows.
# DOD_SIM_GRANT_ALL=1 ./sim.sh ... for full-kit runs.
# DOD_SIM_ROTATE=1 ./sim.sh ... cycles the spec in each class slot across
#   successive battles (sweep/standalone) or runs (--run), so all TWELVE
#   specs get measured — per-spec shares come with sample counts. The
#   fixed default party stays the default for A/B against prior batches.
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
