# BATCH FQ — THE PROFILE'S VERSION GUARD.
#
#   §1  IT REFUSES WHAT IT SHOULD REFUSE, AND ACCEPTS WHAT IT SHOULD ACCEPT —
#       both arms, because a guard that never refuses and a guard that refuses
#       everything pass exactly the same static check
#   §2  A REFUSED PROFILE IS NEVER WRITTEN — the file hashed before and after
#       four separate write paths, which is the arm that protects the player's
#       twelve purses rather than merely reporting on them
#   §3  AN ACCEPTED PROFILE ROUND-TRIPS WITHOUT LOSS — every key, every
#       accessor, through JSON and back
#   §4  THE THREE THINGS THAT DECAY SILENTLY — the floor/ceiling relation, the
#       ORDER inside `_save()`, and the fact that the refusal does not DELETE
#
# **WHY THIS BATCH EARNS A GATE, AND IT IS NOT THE USUAL REASON.** BN's warning
# about the run save sat in `docs/instrument-rules.md` for thirty batches doing
# nothing, because a documented hazard is not an instrument. **Every merge batch
# touches talent ids**, and the failure this guards is silent in all three of
# its fields at once: FP drove a profile with six points and three bought cells
# against a tree that no longer held them and got `cells_spent` 0,
# `equipped_learned` empty and `owns_cell` STILL TRUE — the points come back,
# the loadout empties, and nothing errors or logs.
#
# **THE ARM THAT MATTERS IS §2 AND NOT §1.** A wrong load is a bad read and is
# recoverable; `_save()` writing the merged dictionary back on the next point
# earned is a bad WRITE, and the designer's live profile carries twelve purses
# at 60-68 points each. §1 asks whether the branch fires. §2 asks whether the
# file survived it, which is the only question the player has.
#
# **AND THE ORDER INSIDE `_save()` IS ITS OWN ARM (§4b) BECAUSE THE OBVIOUS
# SPELLING IS WRONG.** `if refused: return` placed BEFORE `_load()` tests a
# flag that is still false on the first write of a session — which is exactly
# the write that destroys the file. The guard would look correct and be inert.
# That arm drives the first-call case rather than reading the source.
#
# THE VERSION NUMBER ITSELF IS NEVER PINNED — `docs/instrument-rules.md`'s
# standing rule, learned three times off the run save. Every arm below is
# written against `Profile.VERSION` and `Profile.MIN_VERSION`, so the batch
# that bumps either does not fail this gate for bumping it. **The RELATION is
# pinned and the NUMBERS are not.**
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fq.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# NEVER `user://profile.json`. This gate writes deliberately malformed files to
# `Profile.save_path` and the whole point of the batch is that the real one is
# not disposable. The redirect is the FIRST thing `_initialize` does and §0
# asserts it landed before any other arm runs.
const SCRATCH := "user://check_fq_profile.json"

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	Profile.save_path = SCRATCH
	print("BATCH FQ — THE PROFILE'S VERSION GUARD")
	_s0_the_redirect()
	_s1_refuses_and_accepts()
	_s2_a_refused_profile_is_never_written()
	_s3_round_trip()
	_s4_what_decays()
	_cleanup()
	_g.report(self)


# ─── helpers ────────────────────────────────────────────────────────────────

func _write(txt: String) -> void:
	var f := FileAccess.open(SCRATCH, FileAccess.WRITE)
	f.store_string(txt)
	f = null


func _hash() -> String:
	return FileAccess.get_md5(SCRATCH)


# A fresh load off whatever is on disk. `loaded`/`data` are the two statics the
# harness already resets (`check_eg` does exactly this), and `_load()` is called
# here rather than left to the first accessor so that an arm reading `refused`
# reads THIS file's verdict and not the previous arm's — a probe fault found
# while writing this gate, where every arm printed its predecessor's state.
func _reload() -> void:
	Profile.loaded = false
	Profile.data = {}
	Profile._load()


# A profile with something in every bucket, so §3 has something to lose.
func _populated() -> Dictionary:
	return {
		"version": Profile.VERSION,
		"runs_started": {"berserker": 42, "holy": 40},
		"runs_completed": {"berserker": 4},
		"wipes": {"berserker": 2},
		"forfeits": {"holy": 1},
		"bosses_killed": {"withered_warden": 13},
		"events_seen": {"blood_altar": 2, "cursed_idol": 3},
		"zones_cleared": 13,
		"flags": {"run_framing_seen": true, "skill_check_taught": true},
		"talent_points": {"berserker": 68, "holy": 66},
		"talent_cells": {"berserker": {"bz_savagery": true, "bz_hemorrhage": true}},
		"talent_equipped": {"berserker": {"1": "bz_savagery"}},
		"talent_tier": 3,
	}


func _cleanup() -> void:
	if FileAccess.file_exists(SCRATCH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH))


# ═══ §0 — THE REDIRECT, ASSERTED BEFORE ANYTHING WRITES ══════════════════════

func _s0_the_redirect() -> void:
	print("\n§0 — the scratch redirect")
	ok(Profile.save_path == SCRATCH,
		"§0: `Profile.save_path` is not the scratch file — this gate writes malformed profiles and would be writing them over the player's")
	ok(not SCRATCH.contains("profile.json") or SCRATCH.contains("check_fq"),
		"§0: the scratch path is not distinguishable from the real profile")
	print("  writing to %s" % SCRATCH)


# ═══ §1 — IT REFUSES WHAT IT SHOULD, AND ACCEPTS WHAT IT SHOULD ══════════════
#
# THE POSITIVE ARM IS NOT A FORMALITY. A branch that refuses everything would
# make every arm in §2 pass — the file is never written because the profile is
# never loaded — and the game would silently stop saving. §1a is what tells the
# two apart, and it is asserted as hard as the refusals are.

func _s1_refuses_and_accepts() -> void:
	print("\n§1 — the branch, in both directions")

	# §1a — THE POSITIVE ARM.
	_write(JSON.stringify(_populated()))
	_reload()
	ok(not Profile.refused,
		"§1a: a profile written at the CURRENT version was REFUSED — the guard refuses everything, and §2's arms below are passing vacuously")
	ok(Profile.talent_points_earned("berserker") == 68,
		"§1a: an accepted profile did not read its own purse back (got %d, wrote 68)" % Profile.talent_points_earned("berserker"))
	ok(Profile.talent_tier() == 3,
		"§1a: an accepted profile did not read its own tier back")
	ok(Profile.refusal_message() == "",
		"§1a: an accepted profile still produces a refusal message — the main menu would banner a healthy save")
	print("  accepted v%d: 68 points, tier 3, no message" % Profile.VERSION)

	# §1b — BELOW THE FLOOR. A missing version key reads 0, which is the shape
	# `run_state.load_run()` refuses and the shape a file this build never wrote
	# arrives in.
	_write(JSON.stringify({"talent_points": {"berserker": 68}}))
	_reload()
	ok(Profile.refused,
		"§1b: a profile with NO VERSION KEY was accepted — it reads 0, which is below the floor, and its keys were merged over the defaults")
	ok(Profile.talent_points_earned("berserker") == 0,
		"§1b: a REFUSED profile's purse was read anyway — the refusal returned before the merge and it did not")

	# §1c — ABOVE THE CEILING. The half that is live today: under the code this
	# replaced, a version-99 profile loaded clean and was stamped back to the
	# current version. It is also the half FQ §2's branch makes routine.
	_write(JSON.stringify({"version": Profile.VERSION + 1, "talent_points": {"berserker": 68}}))
	_reload()
	ok(Profile.refused,
		"§1c: a profile ONE VERSION NEWER than this build was accepted — a build on the other side of the merge branch would read it, stamp it down and overwrite it")
	ok(Profile.refused_version == Profile.VERSION + 1,
		"§1c: the refusal did not record the version it saw (got %d)" % Profile.refused_version)

	# §1d — AND FAR ABOVE, so the ceiling is a RELATION and not an off-by-one.
	_write(JSON.stringify({"version": 99, "talent_points": {"berserker": 68}}))
	_reload()
	ok(Profile.refused,
		"§1d: a version-99 profile was accepted")

	# §1e — NOT A DICTIONARY. Before FQ this fell through to the defaults and
	# was then overwritten by the next `_save()`: a corrupt profile becoming a
	# DELETED one, with no message in between.
	_write("[1, 2, 3]")
	_reload()
	ok(Profile.refused,
		"§1e: a JSON file that is not a dictionary was not refused — it falls through to the defaults and the next `_save()` overwrites it")
	_write("not json at all {{{")
	_reload()
	ok(Profile.refused,
		"§1e: a file that is not JSON at all was not refused")

	# §1f — AND THE MESSAGE IS THE PLAYER'S, NOT THE FORMAT'S. A refusal the
	# player cannot act on is the quiet zero wearing a warning label: the file
	# path is what makes copying it somewhere safe possible.
	var msg := Profile.refusal_message()
	ok(msg != "",
		"§1f: a refused profile produced NO message — the main menu has nothing to show and the refusal reads as a fresh start")
	ok(msg.contains(SCRATCH),
		"§1f: the refusal message does not name the FILE, so the player cannot find the thing they need to copy")
	ok(msg.to_lower().contains("nothing has been changed or deleted"),
		"§1f: the refusal message does not say the file is intact — which is the one fact that stops a player starting over on top of it")
	# §1g — AND AN ACCEPTED PROFILE MUST ACTUALLY WRITE.
	# **THE POSITIVE ARM FOR THE WHOLE OF §2, AND THE GATE WAS SHIPPED WITHOUT
	# IT FOR ONE DRAFT.** Every arm in §2 asserts the file did NOT change. A
	# `_save()` broken outright — one that never writes at all — satisfies every
	# one of them, and satisfies §3's round trip too, because §3 re-reads a file
	# it never actually rewrote. **Measured, not argued: with `_save()` made
	# inert in an out-of-repo copy, this gate read 46 checks / 0 failures.**
	# That is the vacuous-check shape — a guard that has stopped asking its
	# question printing exactly like a clean one — and this is the only arm that
	# tells a GUARDED save from a DEAD one.
	_write(JSON.stringify(_populated()))
	_reload()
	var live_hash := _hash()
	var before_points := Profile.talent_points_earned("berserker")
	Profile.award_zone_boss_points(["berserker"])
	ok(_hash() != live_hash,
		"§1g: an ACCEPTED profile did NOT write on a point earned — `_save()` is inert, the game has silently stopped saving, and every arm in §2 is passing because nothing writes at all")
	ok(Profile.talent_points_earned("berserker") == before_points + 1,
		"§1g: the point earned did not reach the purse (%d -> %d)" % [before_points, Profile.talent_points_earned("berserker")])
	print("  accepted profile WRITES: %d -> %d points, file changed"
		% [before_points, Profile.talent_points_earned("berserker")])
	print("  refused: no-key, +1, 99, non-dict, non-JSON — 5 shapes")


# ═══ §2 — A REFUSED PROFILE IS NEVER WRITTEN ════════════════════════════════
#
# THE ARM THE BATCH EXISTS FOR. Everything in §1 is a message; this is the file
# on disk. Four write paths are driven, not one, because `_save()` is reached
# from `_bump`, from the talent ledger, from `set_flag` and directly — and a
# guard installed at three of the four would read as installed.

func _s2_a_refused_profile_is_never_written() -> void:
	print("\n§2 — the file, hashed across four write paths")

	_write(JSON.stringify({"version": 99, "talent_points": {"berserker": 68},
		"zones_cleared": 13, "talent_tier": 3}))
	var before := _hash()
	_reload()
	ok(Profile.refused, "§2: the setup profile was not refused — every arm below is vacuous")

	Profile.award_zone_boss_points(["berserker"])   # the ledger
	ok(_hash() == before, "§2a: `award_zone_boss_points` WROTE to a refused profile — this is the line that destroys the purses on the first zone boss")
	Profile.note_completion(["berserker"])          # _bump
	ok(_hash() == before, "§2b: `note_completion` (via `_bump`) wrote to a refused profile")
	Profile.set_flag("run_framing_seen")            # set_flag
	ok(_hash() == before, "§2c: `set_flag` wrote to a refused profile")
	Profile.note_zone_cleared()                     # direct
	ok(_hash() == before, "§2d: `note_zone_cleared` wrote to a refused profile")
	Profile._save()                                 # the bare call
	ok(_hash() == before, "§2e: a bare `_save()` wrote to a refused profile")

	# AND THE FILE IS STILL THERE. The refusal must not resolve itself by
	# deleting the thing it refused — `run_state.load_run()` calls
	# `clear_save()` and this one deliberately does not, because a refused run
	# save is one run and a refused profile is every run ever finished.
	ok(FileAccess.file_exists(SCRATCH),
		"§2f: the refused profile was DELETED — the guard resolved the problem by destroying exactly what it exists to protect")
	var raw: Variant = JSON.parse_string(FileAccess.open(SCRATCH, FileAccess.READ).get_as_text())
	ok(raw is Dictionary and int((raw as Dictionary).get("talent_points", {}).get("berserker", 0)) == 68,
		"§2f: the refused profile's purse is no longer 68 on disk")
	print("  md5 %s unchanged across 5 write paths; 68 points still on disk" % before.substr(0, 12))


# ═══ §3 — AN ACCEPTED PROFILE ROUND-TRIPS WITHOUT LOSS ══════════════════════
#
# The other check §1 of the brief asks for. A guard that refuses correctly and
# then loses a bucket on the way through JSON has moved the failure rather than
# fixed it, and the ledger buckets are the ones nothing else would notice.

func _s3_round_trip() -> void:
	print("\n§3 — save → load, key by key")

	var written := _populated()
	_write(JSON.stringify(written))
	_reload()
	ok(not Profile.refused, "§3: the round-trip profile was refused — every arm below is vacuous")

	# Read every accessor BEFORE the save.
	var before := {
		"points_bz": Profile.talent_points_earned("berserker"),
		"points_holy": Profile.talent_points_earned("holy"),
		"avail_bz": Profile.talent_points_available("berserker"),
		"tier": Profile.talent_tier(),
		"cells_bz": Profile.talent_cells("berserker").size(),
		"equipped_bz": Profile.talent_equipped("berserker").size(),
		"learned_bz": Profile.equipped_talents("berserker").size(),
		"owns": Profile.owns_cell("berserker", "bz_savagery"),
		"completions": Profile.completions_for("berserker"),
		"events": Profile.distinct_events_seen(),
		"flag": Profile.flag("run_framing_seen"),
		"zones": int(Profile._load()["zones_cleared"]),
	}
	Profile._save()
	_reload()
	var after := {
		"points_bz": Profile.talent_points_earned("berserker"),
		"points_holy": Profile.talent_points_earned("holy"),
		"avail_bz": Profile.talent_points_available("berserker"),
		"tier": Profile.talent_tier(),
		"cells_bz": Profile.talent_cells("berserker").size(),
		"equipped_bz": Profile.talent_equipped("berserker").size(),
		"learned_bz": Profile.equipped_talents("berserker").size(),
		"owns": Profile.owns_cell("berserker", "bz_savagery"),
		"completions": Profile.completions_for("berserker"),
		"events": Profile.distinct_events_seen(),
		"flag": Profile.flag("run_framing_seen"),
		"zones": int(Profile._load()["zones_cleared"]),
	}
	for k in before:
		ok(before[k] == after[k],
			"§3: `%s` did not survive a save/load round trip (%s -> %s)" % [k, str(before[k]), str(after[k])])

	# EVERY KEY, not only the ones an accessor reaches. A bucket that no
	# accessor asks about is exactly the one a migration drops silently.
	var on_disk: Variant = JSON.parse_string(FileAccess.open(SCRATCH, FileAccess.READ).get_as_text())
	ok(on_disk is Dictionary, "§3: the saved profile does not parse back as a dictionary")
	var missing: Array = []
	for k in written:
		if not (on_disk as Dictionary).has(k):
			missing.append(k)
	ok(missing.is_empty(),
		"§3: keys were LOST through the round trip: %s" % str(missing))
	# ...and the defaults' own key set, which is the population that matters
	# when a bucket is added: a new key must survive its first save.
	var defaults_missing: Array = []
	for k in Profile._load():
		if not (on_disk as Dictionary).has(k):
			defaults_missing.append(k)
	ok(defaults_missing.is_empty(),
		"§3: keys the DEFAULTS declare did not reach the file: %s" % str(defaults_missing))
	print("  %d accessors and %d keys survived; %d keys on disk"
		% [before.size(), written.size(), (on_disk as Dictionary).size()])


# ═══ §4 — THE THREE THINGS THAT DECAY SILENTLY ══════════════════════════════

func _s4_what_decays() -> void:
	print("\n§4 — the relation, the order, and the non-deletion")

	# §4a — THE RELATION, NOT THE NUMBERS. `docs/instrument-rules.md`'s standing
	# rule: three batches broke a sibling suite by bumping the run save's
	# version because a suite had pinned the literal. Nothing here pins 1 or 2.
	ok(Profile.MIN_VERSION <= Profile.VERSION,
		"§4a: `MIN_VERSION` (%d) is above `VERSION` (%d) — the build refuses every profile it can write, including its own"
			% [Profile.MIN_VERSION, Profile.VERSION])
	ok(Profile.MIN_VERSION >= 1,
		"§4a: `MIN_VERSION` is below 1, so a file with no version key at all (which reads 0) would be ACCEPTED")

	# §4b — THE ORDER INSIDE `_save()`, DRIVEN RATHER THAN READ.
	# `if refused: return` placed BEFORE `_load()` reads a flag that is still
	# false on the FIRST write of a session — the very write that destroys the
	# file — and the guard looks correct in the source either way. This arm
	# makes `_save()` the first Profile call after a reset, which is the only
	# state that tells the two spellings apart.
	_write(JSON.stringify({"version": 99, "talent_points": {"berserker": 68}}))
	var h := _hash()
	Profile.loaded = false
	Profile.data = {}
	Profile._save()          # <- the FIRST call. Nothing has loaded yet.
	ok(_hash() == h,
		"§4b: `_save()` called as the FIRST Profile call of a session WROTE to a refused profile — the `refused` guard is being read before `_load()` has set it")

	# §4c — AND THE REFUSAL DOES NOT DELETE. Asserted as a property of the
	# source as well as of the behaviour, because the tempting repair on the day
	# a player is stuck behind a refusal is to make it clear the file the way
	# `load_run()` does.
	var src := FileAccess.open("res://scripts/profile.gd", FileAccess.READ).get_as_text()
	ok(not src.contains("DirAccess.remove_absolute"),
		"§4c: `profile.gd` now deletes a file — the profile refusal must never clear what it refuses, which is the one difference from `run_state.load_run()`")
	ok(src.contains("MIN_VERSION"),
		"§4c: `MIN_VERSION` is gone from `profile.gd` — the floor was removed rather than raised")
	ok(FileAccess.file_exists(SCRATCH),
		"§4c: the refused profile is gone from disk at the end of the gate")
	print("  floor %d, ceiling %d; first-call save inert; no delete path"
		% [Profile.MIN_VERSION, Profile.VERSION])
