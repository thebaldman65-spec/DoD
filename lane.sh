#!/bin/zsh
# BATCH IQ §7 — THE LANE DRIVER, AND THE ONE THING IT REFUSES.
#
# A LANE is a scratch copy of this tree that a batch runs Godot in — a recon, a
# control, a trace, a probe. Godot keys `user://` by the project's
# `config/name`, so a lane runs in its own user-data folder ONLY because its
# copy of `project.godot` carries a name of its own. **A copy whose name is
# the live one writes the PLAYER's folder** — his run save, his profile, his
# relics and his playtest readout.
#
# IP found that the hard way: three trace copies restored HEAD's tracked files
# with `git checkout HEAD -- .`, which put `project.godot`'s live name back, and
# four trace runs executed in the player's own folder, two at once. Nothing was
# lost — the gates restore what they find — and it was found by reading
# failures neither tree had. **So a lane asserts its own name before it
# launches anything, and a lane whose name is the live one does not run.**
#
#   ./lane.sh live                          print the live project name, as this script reads it
#   ./lane.sh check  <lane>                 exit 0 if <lane> may run, 1 (and why) if not
#   ./lane.sh make   <lane> <name> [<src>]  clone <src> (default: this tree) to <lane>, named <name>, checked
#   ./lane.sh godot  <lane> <godot args>    check, then run Godot in <lane> (`--path` is added)
#   ./lane.sh battery <lane> [suites]       check, then run <lane>'s own run_battery.sh
#
# THE LIVE NAME IS READ, NEVER TYPED: it is `config/name` in HEAD's committed
# `project.godot` (the tree's own copy if git cannot answer). THE REPOSITORY IS
# WHERE THIS SCRIPT LIVES, so run the repository's copy — a lane's own copy of
# this file would take the lane for the repository. The repository itself is
# not a lane and is refused as one: it runs as the live project on purpose
# (every acceptance does), through `./run_battery.sh`, not through here.

REPO="${0:A:h}"

_name_in() {
	[[ -f "$1" ]] || return 1
	sed -n 's/^config\/name="\(.*\)"$/\1/p' "$1" | head -n 1
}

_live_name() {
	local n
	n=$(git -C "$REPO" show HEAD:project.godot 2>/dev/null | sed -n 's/^config\/name="\(.*\)"$/\1/p' | head -n 1)
	[[ -z "$n" ]] && n=$(_name_in "$REPO/project.godot")
	print -r -- "$n"
}

# The assertion. Prints one line either way; exit 1 is a refusal.
check() {
	local lane="$1" live name
	if [[ -z "$lane" || ! -d "$lane" ]]; then
		print -r -- "LANE REFUSED: '$lane' is not a directory."
		return 1
	fi
	live=$(_live_name)
	if [[ -z "$live" ]]; then
		print -r -- "LANE REFUSED: the live project name could not be read from $REPO."
		return 1
	fi
	if [[ "${lane:A}" == "${REPO:A}" ]]; then
		print -r -- "LANE REFUSED: $lane is the repository, not a lane — it runs as the live project '$live' on purpose, through ./run_battery.sh."
		return 1
	fi
	if [[ ! -f "$lane/project.godot" ]]; then
		print -r -- "LANE REFUSED: $lane has no project.godot."
		return 1
	fi
	name=$(_name_in "$lane/project.godot")
	if [[ -z "$name" ]]; then
		print -r -- "LANE REFUSED: $lane/project.godot names no project (config/name), so its user folder is not its own."
		return 1
	fi
	if [[ "$name" == "$live" ]]; then
		print -r -- "LANE REFUSED: $lane runs as '$name', the LIVE project — it would write the player's user folder. Rename it (lane.sh make does) before it runs."
		return 1
	fi
	print -r -- "LANE OK: $lane runs as '$name', not the live '$live'."
	return 0
}

make_lane() {
	local lane="$1" name="$2" src="${3:-$REPO}" live f b
	if [[ -z "$lane" || -z "$name" ]]; then
		print -r -- "usage: lane.sh make <lane> <name> [<src>]"
		return 1
	fi
	live=$(_live_name)
	if [[ "$name" == "$live" ]]; then
		print -r -- "LANE REFUSED: '$name' is the live project name."
		return 1
	fi
	if [[ -e "$lane" ]]; then
		print -r -- "LANE REFUSED: $lane exists."
		return 1
	fi
	mkdir -p "$lane" || return 1
	setopt local_options null_glob
	for f in "$src"/* "$src"/.[^.]*; do
		b=${f:t}
		[[ "$b" == "save-backups" ]] && continue
		cp -c -R "$f" "$lane/$b" || return 1
	done
	sed -i "" -E "s/^config\/name=\".*\"/config\/name=\"$name\"/" "$lane/project.godot"
	if [[ ! -d "$HOME/Library/Application Support/Godot/app_userdata/$name" ]]; then
		print -r -- "LANE NOTE: no user folder named '$name' exists yet — Godot will make one (reuse an idle lane's name first)."
	fi
	check "$lane"
}

_godot() {
	sed -n 's/^GODOT=//p' "$REPO/run_battery.sh" | head -n 1
}

case "$1" in
	live)    _live_name ;;
	check)   check "$2" ;;
	make)    make_lane "$2" "$3" "$4" ;;
	godot)   lane="$2"; shift 2; check "$lane" >&2 || exit 1; exec "$(_godot)" --path "$lane" "$@" ;;
	battery) lane="$2"; shift 2; check "$lane" || exit 1; exec "$lane/run_battery.sh" "$@" ;;
	*)       print -r -- "usage: lane.sh live|check|make|godot|battery <lane> ..."; exit 2 ;;
esac
