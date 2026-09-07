# BATCH FI — NO TEST WRITES THE PLAYER'S SAVE, AND THIS IS THE INSTRUMENT.
#
#   §1  the redirect fired in THIS process, and the const still means the player
#   §2  `run_state.gd`'s four file operations go through the var, not the const
#   §3  the resolver, driven in BOTH directions — two harness argvs and two
#       player argvs, because a resolver that reads the command line itself can
#       only ever be tested in the one process the test runs in
#   §4  THE DESTRUCTION PATH, DRIVEN, WITH A TWO-ARMED CONTROL. Arm one is
#       HEAD's shape and the file it is told to write is destroyed; arm two is
#       FI's and the same file survives while the harness path moves instead
#   §5  no target in the tree names the player's path at all
#   §6  the player's own file, hashed before this gate ran and after
#
# **WHY THIS GATE EXISTS AT ALL.** A rule with no instrument is a note. The
# guidance "copy `run_save.bin` aside before a battery run" has been written
# down since BN and it did not stop the file being destroyed, because the thing
# it asked for was DISCIPLINE — and the census that finally measured this found
# a quarter of the battery destroying the save individually, so any subset run
# did too, and the wrapper that a battery script could have enforced is bypassed
# by running one gate alone. That is exactly how the save went missing.
#
# **THE NEEDLE IS READ OFF THE AUTOLOAD, NOT WRITTEN DOWN HERE.** §5 sweeps the
# tree for the player's path; if this file spelled that path out, this file
# would be the first thing the sweep found, and the usual repair for that — an
# exemption naming this gate — is the shape that blinds a rule to a real
# offender arriving in the exempted file later. The needle is `Run.SAVE_PATH`
# itself, so it cannot drift from what it is looking for either.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fi.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The file arm one of §4's control is told to destroy. It stands in for the
# player's save and is NOT the player's save: a control that proves a repair by
# damaging the thing the repair protects has understood neither.
const SURROGATE := "user://fi_surrogate_save.bin"
const SURROGATE_BYTES := "FI SURROGATE — a save that must survive arm two"

# **THE ONE FILE ALLOWED TO NAME THE PLAYER'S PATH**, because it is where the
# path is defined. Listed rather than pattern-matched, so a second name has to
# be added here by someone who has read this line.
const NAMES_IT_LEGALLY := ["scripts/run_state.gd"]

var _g := Gate.new()
var _run: Node = null
var _player_path := ""
var _had_save := false
var _player_md5 := ""


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	_run = root.get_node("/root/Run")
	_player_path = String(_run.SAVE_PATH)
	_had_save = FileAccess.file_exists(_player_path)
	if _had_save:
		_player_md5 = FileAccess.get_md5(_player_path)
	print("  the player's run save: %s" % (
		"present, %d B" % FileAccess.get_file_as_bytes(_player_path).size()
		if _had_save else "none on this machine"))

	_s1_the_redirect_fired()
	_s2_the_file_operations()
	_s3_the_resolver_both_ways()
	await _s4_the_destruction_path()
	_s5_nobody_names_it()
	_s6_the_players_file()
	_g.report(self)


# ── §1 ──────────────────────────────────────────────────────────────────────
func _s1_the_redirect_fired() -> void:
	print("\n§1 — the redirect fired in this process")
	ok(_run.save_path != _player_path,
		"§1: this process does not resolve the player's path")
	ok(_run.save_path == String(_run.TEST_SAVE_PATH),
		"§1: ...it resolves the harness path (%s)" % _run.save_path)
	ok(_player_path.ends_with("run_save.bin"),
		"§1: SAVE_PATH still names the player's own file")
	ok(_run.save_path_is_harness(OS.get_cmdline_args(),
			String(ProjectSettings.get_setting("application/run/main_scene", ""))),
		"§1: ...and the resolver agrees about this process")


# ── §2 ──────────────────────────────────────────────────────────────────────
# The four operations that open, test and delete the file. A redirect that the
# writes do not use is a variable, not a redirect — and the whole defect was
# a `const` nothing could point elsewhere, so the const staying is the point.
func _s2_the_file_operations() -> void:
	print("\n§2 — run_state.gd's four file operations use the var")
	# **THE FOUR NEEDLES ARE WRITTEN OUT, NOT LOOPED OVER A LIST, AND THE HOLDER
	# IS BOUND WITH `:=`.** `build_pin_manifest.py` binds a holder off
	# `var x :=` and indexes the literals passed to it; a needle that arrives
	# through a loop variable is invisible to the manifest and therefore to
	# `check_ed`, which is FH §2's own standing rule and which this gate broke on
	# its first draft — the manifest went 1417 → 1417 and `--check` was the only
	# thing that noticed.
	var body := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	ok(body.contains("FileAccess.open(save_path, FileAccess.WRITE)"),
		"§2: the save is WRITTEN through the var")
	ok(body.contains("FileAccess.file_exists(save_path)"),
		"§2: its existence is TESTED through the var")
	ok(body.contains("FileAccess.open(save_path, FileAccess.READ)"),
		"§2: it is READ through the var")
	ok(body.contains("DirAccess.remove_absolute(save_path)"),
		"§2: it is DELETED through the var")
	ok(not body.contains("(SAVE_PATH,") and not body.contains("(SAVE_PATH)"),
		"§2: ...and no file operation is left on the const")


# ── §3 ──────────────────────────────────────────────────────────────────────
# **A NEGATIVE ANCHOR WITH NO POSITIVE ARM IS HALF A TEST.** The two FALSE
# cases are the ones that matter to the player: a resolver that returned TRUE
# for everything would pass every other section in this file and would silently
# stop the shipped game from ever loading a save.
func _s3_the_resolver_both_ways() -> void:
	print("\n§3 — the resolver, in both directions")
	var main := String(ProjectSettings.get_setting("application/run/main_scene", ""))
	# Headless short-circuits the argv clauses, so the argv cases are asserted
	# against a main scene that is NOT this process's display.
	ok(_run.save_path_is_harness(PackedStringArray(["--script", "check_fi.gd"]), main),
		"§3: `--script` is a harness process")
	ok(_run.save_path_is_harness(PackedStringArray(["res://check_ct_map.tscn"]), main),
		"§3: a scene target that is not the main scene is a harness process")
	ok(main != "" and main.ends_with(".tscn"),
		"§3: the project names a main scene for the player arm to use")
	# **THE PLAYER ARMS CALL `argv_is_harness` AND DO NOT RE-IMPLEMENT IT.**
	# Every process that could run this assertion is headless, so
	# `save_path_is_harness` short-circuits TRUE before it reads an argument and
	# the two FALSE cases below could never execute through it. The argv reading
	# is its own function in `run_state.gd` for exactly this reason; a copy of
	# those four lines here would pass on the day the real ones changed.
	ok(not _run.argv_is_harness(PackedStringArray([]), main),
		"§3: a player's process — no arguments — is NOT a harness process")
	ok(not _run.argv_is_harness(PackedStringArray([main]), main),
		"§3: ...and neither is an explicit launch of the main scene")
	ok(_run.argv_is_harness(PackedStringArray(["--script", "check_fi.gd"]), main),
		"§3: ...while the same reading still catches `--script`")
	ok(_run.argv_is_harness(PackedStringArray(["res://check_map_screen.tscn"]), main),
		"§3: ...and a scene that is not the main scene")


# ── §4 ──────────────────────────────────────────────────────────────────────
# The two calls that destroyed twenty-four targets' worth of run saves, driven
# on a battle spawned by the same fixture that made them destructive:
# `gate_fixture.spawn` sets `sim_run = false` and `active = true`, which is what
# takes `save_run()` and `clear_save()` past their own guards.
func _s4_the_destruction_path() -> void:
	print("\n§4 — the destruction path, driven, with a two-armed control")
	var scene: Node = await Gate.spawn(self,
		["warden", "pyromancer", "holy", "beastmaster"], {"run": _run})
	if scene == null:
		ok(false, "§4: the battle never spawned")
		return
	ok(not _run.sim_run and _run.active,
		"§4: the fixture leaves the run in the state that reaches the save calls")

	# ARM ONE — HEAD's shape. The path the writes use IS the file we care
	# about, which is what `const SAVE_PATH` guaranteed for every target.
	_write_surrogate()
	_run.save_path = SURROGATE
	_run.save_run()
	ok(FileAccess.file_exists(SURROGATE)
			and FileAccess.get_file_as_bytes(SURROGATE) != SURROGATE_BYTES.to_utf8_buffer(),
		"§4 arm one: `save_run()` overwrites the file it is pointed at")
	_run.clear_save()
	ok(not FileAccess.file_exists(SURROGATE),
		"§4 arm one: ...and `clear_save()` destroys it — the control bites")

	# ARM TWO — FI's shape. Same two calls, same battle, same run. The only
	# thing that changed is where the process resolves its save.
	_write_surrogate()
	_run.save_path = String(_run.TEST_SAVE_PATH)
	if FileAccess.file_exists(_run.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(_run.save_path))
	_run.save_run()
	ok(FileAccess.file_exists(_run.save_path),
		"§4 arm two: `save_run()` wrote the harness path")
	ok(FileAccess.file_exists(SURROGATE)
			and FileAccess.get_file_as_bytes(SURROGATE) == SURROGATE_BYTES.to_utf8_buffer(),
		"§4 arm two: ...and the file arm one destroyed is byte-identical")
	_run.clear_save()
	ok(not FileAccess.file_exists(_run.save_path),
		"§4 arm two: `clear_save()` destroyed the harness path")
	ok(FileAccess.file_exists(SURROGATE),
		"§4 arm two: ...and still not the other one")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SURROGATE))


func _write_surrogate() -> void:
	var f := FileAccess.open(SURROGATE, FileAccess.WRITE)
	f.store_buffer(SURROGATE_BYTES.to_utf8_buffer())
	f = null


# ── §5 ──────────────────────────────────────────────────────────────────────
# **THE POPULATION IS EVERY `.gd` IN THE TREE, AND THE COUNT IS PRINTED.** A
# sweep that walked nothing prints the same clean zero as a sweep that walked
# everything and found nothing, which is how a check comes to pass for four
# batches without executing. `CHECKED n of m` is the difference.
func _s5_nobody_names_it() -> void:
	print("\n§5 — nobody else names the player's path")
	var offenders: Array = []
	var walked := 0
	var files := _every_gd("res://")
	for f in files:
		if NAMES_IT_LEGALLY.has(f.trim_prefix("res://")):
			continue
		walked += 1
		if FileAccess.get_file_as_string(f).contains(_player_path):
			offenders.append(f.trim_prefix("res://"))
	print("  CHECKED %d of %d .gd files (%d exempt by name), needle `%s`"
		% [walked, files.size(), files.size() - walked, _player_path])
	ok(walked >= 100, "§5: the sweep actually walked the tree (%d files)" % walked)
	ok(offenders.is_empty(),
		"§5: no file but the one that defines it names the player's path (%s)"
			% ", ".join(offenders))


func _every_gd(dir: String) -> Array:
	var out: Array = []
	var d := DirAccess.open(dir)
	if d == null:
		return out
	d.list_dir_begin()
	var n := d.get_next()
	while n != "":
		var p := dir.path_join(n)
		if d.current_is_dir():
			if not n.begins_with(".") and n != "DoD-archive":
				out.append_array(_every_gd(p))
		elif n.ends_with(".gd"):
			out.append(p)
		n = d.get_next()
	d.list_dir_end()
	return out


# ── §6 ──────────────────────────────────────────────────────────────────────
# **BOTH ARMS RUN WHETHER OR NOT THERE IS A SAVE**, for the reason FH measured:
# writing the second one as `if _had_save: ok(...)` makes the check count depend
# on whether the machine happens to have a run in progress, which is a baseline
# row that reds for a reason unrelated to the tree.
func _s6_the_players_file() -> void:
	print("\n§6 — the player's own file, before this gate and after")
	ok(FileAccess.file_exists(_player_path) == _had_save,
		"§6: the player's run save is NOT as this gate found it")
	ok(not _had_save or FileAccess.get_md5(_player_path) == _player_md5,
		"§6: the player's run save changed while this gate ran")
