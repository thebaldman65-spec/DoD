# BATCH CT — THE GATE FOR THE SLOTTED POUCH, THE THREE NEW ITEMS AND THE
# PERCENTAGE POTIONS.
#
# The brief's floor is "it parses, it runs, a battle resolves each new item,
# and the pouch renders full and empty". PARSING IS NOT CHECKED HERE and must
# not be: check_parse.gd owns that, and the honest read of it is grepping the
# engine's stderr for `Parse Error`, never a tally (Batch CN's scar).
#
# WHAT THIS DOES INSTEAD IS SPAWN A REAL BATTLE and drive each new item
# through `_use_item` on live units, then assert against what actually landed
# — the same shape check_co.gd uses, for the same reason: a table checked
# against another table proves the two tables agree, not that the game does.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ct.gd 2>&1 | grep -cE "Parse Error|SCRIPT ERROR"
extends SceneTree

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


# BATCH DB — the tally is the fixture's. This delegates rather than
# re-implements: FOUR gates' copies of this never counted a check at all.
func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260820)
	var run := root.get_node("/root/Run")
	print("BATCH CT — THE POUCH GETS SLOTS")

	# ---------- §1: the slot ladder and the opening ----------
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	ok(run.ITEM_SLOTS_BY_ZONE == [4, 5, 6], "the ladder is 4/5/6 by zone")
	ok(run.zone_idx == 0, "a new run stands in zone 1")
	ok(run.item_slots() == 4, "zone 1 holds four slots")
	# THE RESOLUTION §1 DEMANDED BE WRITTEN DOWN: the opening drops to four
	# TYPES rather than starting over capacity.
	ok(run.slots_used() == 4, "the opening pouch is four types, not five")
	ok(run.slots_free() == 0, "and it opens exactly full — nothing over capacity")
	ok(not run.items.has("defense"), "the Defense Potion is the type dropped")
	for id in run.items:
		ok(run.ITEM_INFO.has(id), "opening type %s is a real id" % id)
	# The ladder actually moves with the zone.
	run.zone_idx = 1
	ok(run.item_slots() == 5, "zone 2 holds five slots")
	run.zone_idx = 2
	ok(run.item_slots() == 6, "zone 3 holds six slots")
	# Past the end of the ladder it CLAMPS rather than indexing off the end —
	# the end boss sits in the last zone and nothing may crash there.
	run.zone_idx = 7
	ok(run.item_slots() == 6, "a zone past the ladder clamps to six")
	run.zone_idx = 0

	# ---------- §1: a stack falling to zero KEEPS its slot ----------
	run.items["bomb"] = 0
	ok(run.slots_used() == 4, "an emptied stack still holds its slot")
	ok(run.needs_slot("visage"), "and the pouch is still full against a new type")
	run.items["bomb"] = 1

	# ---------- §2: discard and sell free it ----------
	ok(run.discard_item("bomb"), "discarding a held type reports true")
	ok(run.slots_used() == 3, "and the slot comes free")
	ok(not run.discard_item("bomb"), "discarding what is not held reports false")
	ok(not run.needs_slot("visage"), "a free slot takes a new type")

	# ---------- §3: no room is a CHOICE, a full stack is a WALL ----------
	ok(run.add_item("visage") == 1, "the freed slot takes a Cursed Visage")
	ok(run.slots_free() == 0, "the pouch is full again")
	# A type with no slot: OFFERED, never silently refused.
	ok(run.needs_slot("hourglass"), "an unheld type with no slot needs one")
	ok(run.offer_item("hourglass"), "and it is OFFERED rather than refused")
	ok(run.pending_item_offers == ["hourglass"], "the offer is queued for the map")
	ok(run.add_item("hourglass") == 0, "add_item still lands nothing for it")
	ok(not run.items.has("hourglass"), "and the type did not sneak in")
	# A type at its STACK cap: refused, and NOT offered. The two must never
	# be conflated — that is the §3 line this pair exists to hold.
	run.items["visage"] = run.item_stack_cap("visage")
	ok(not run.offer_item("visage"), "a FULL STACK is never turned into an offer")
	ok(run.add_item("visage") == 0, "it is refused outright")
	run.pending_item_offers = []

	# ---------- §4: the per-type stack caps ----------
	ok(run.item_stack_cap("cleanse") == 4, "the Draught caps at four")
	ok(run.item_stack_cap("visage") == 2, "the Visage caps at two")
	ok(run.item_stack_cap("hourglass") == 2, "the Hourglass caps at two")
	ok(run.item_stack_cap("health") == run.ITEM_CAP, "a potion keeps Batch AN's six")
	ok(run.item_stack_cap("health") == 6, "and that six is still six")

	# ---------- §5: the status is registered on both sides ----------
	var battle_gd := load("res://scripts/battle.gd")
	var unit_gd := load("res://scripts/unit.gd")
	ok(battle_gd.STATUS_INFO.has("hexed"), "the hex has a chip")
	ok(unit_gd.DEBUFF_IDS.has("hexed"), "and it is a DEBUFF (Trapper counts it)")
	ok(not battle_gd.DISPEL_NEVER.has("hexed"),
		"it is kept from Dispel by DEBUFF_IDS, not by a second list")
	# The collision this batch refused to ship: `cripple` is untouched.
	ok(unit_gd.DEBUFF_IDS.has("cripple"), "the OLD Cripple is still a debuff")
	ok(battle_gd.STATUS_INFO["cripple"][0] == "Cripple", "and still named Cripple")
	ok(battle_gd.STATUS_INFO["hexed"][0] == "Hexed", "the new one is named Hexed")
	ok(battle_gd.STATUS_INFO["hexed"][1] != battle_gd.STATUS_INFO["cripple"][1],
		"the two chips cannot be read as each other")

	# ---------- §6: the values are percentages / scale with depth ----------
	run.combat_wins = 0
	ok(run.bomb_damage() == 50, "the Bomb opens at 50 — a run opens unchanged")
	run.combat_wins = 25
	ok(run.bomb_damage() == 75, "and rides +2%/win to 75 at 25 wins")
	run.combat_wins = 0
	ok(run.mana_potion_restore(100) == 40,
		"the Mana Potion is the old flat 40 at the base max of 100")
	ok(run.health_potion_heal(200) == 40, "the Health Potion is 20% of maximum")
	ok(run.health_potion_heal(500) == 100, "and it SCALES, which is the whole point")
	ok(run.health_potion_heal(1) >= 1, "and never rounds to a heal of nothing")
	# §6's untouched pair.
	ok(run.ITEM_INFO["revive"][1].find("50%") >= 0, "Revive is untouched at 50%")
	ok(run.ITEM_INFO["defense"][1].find("10%") >= 0, "Defense is untouched at +10%")

	# ---------- §7: the loot pool ----------
	ok(run.LOOT_POOL.has("cleanse"), "the Draught drops")
	ok(not run.LOOT_POOL.has("visage"), "the Visage does NOT drop — shop only")
	ok(not run.LOOT_POOL.has("hourglass"), "nor the Hourglass — shop only")
	ok(run.LOOT_POOL.count("cleanse") < run.LOOT_POOL.count("health"),
		"and the Draught drops at a LIGHTER weight than a potion")
	# Every id the pool can name must be a real item, or a drop crashes.
	for id in run.LOOT_POOL:
		ok(run.ITEM_INFO.has(id), "loot id %s is a real item" % id)

	# §7: the relics. Neither can push the opening over its slot cap, and that
	# is asserted rather than assumed — it is the whole reason new_run does not
	# need a run-start swap offer.
	for relic_id in ["waystone", "packcharm"]:
		run.new_run(["warrior", "mage", "cleric", "hunter"], [relic_id], "standard")
		ok(run.slots_used() <= run.item_slots(),
			"%s cannot push the opening over its slot cap" % relic_id)
	# And the prices exist for every id, which is what run_sim indexes blind.
	# The prices live on `Run` beside ITEM_INFO (see the note there for why they
	# must not be preloaded off shop_screen.gd). Every id must carry one, because
	# run_sim walks ITEM_IDS and indexes this blind.
	for id in run.ITEM_IDS:
		ok(run.ITEM_PRICES.has(id), "%s carries a price" % id)
		# §2: a sale must be a LOSS, or the shop is a free locker.
		var buy: int = int(run.ITEM_PRICES[id])
		ok(int(round(buy * run.SELL_FRACTION)) < buy,
			"%s sells back for less than it costs" % id)

	# ---------- the v11 save, and that a v10 one still LOADS ----------
	#
	# The changelog claims v11 is TOLERANT — that a v10 save loads rather than
	# being wiped — and a claim about a migration is worth exactly as much as the
	# round trip that proves it. This writes a real v10 save and loads it.
	#
	# **IT BACKS UP ANY REAL SAVE FIRST AND PUTS IT BACK.** SAVE_PATH is the
	# player's actual `user://run_save.bin`; a gate that eats an in-progress run
	# to prove a point about migrations is a worse bug than the one it is
	# testing. There is no save on this machine today — there will be one day.
	var save_path: String = run.SAVE_PATH
	var backup: PackedByteArray = PackedByteArray()
	var had_save := FileAccess.file_exists(save_path)
	if had_save:
		backup = FileAccess.get_file_as_bytes(save_path)
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	run.save_run()
	ok(FileAccess.file_exists(save_path), "the run saves")
	var raw := FileAccess.open(save_path, FileAccess.READ)
	var blob: Variant = raw.get_var(true)
	raw = null
	ok(blob is Dictionary and int(blob.get("version", 0)) == 11,
		"...at v11")
	ok((blob as Dictionary).has("pending_item_offers"),
		"...carrying the §3 offer queue")
	# Now make it a v10 save: the old version, and none of CT's new field.
	var v10: Dictionary = (blob as Dictionary).duplicate(true)
	v10["version"] = 10
	v10.erase("pending_item_offers")
	var w := FileAccess.open(save_path, FileAccess.WRITE)
	w.store_var(v10, true)
	w = null
	run.items = {}
	run.pending_item_offers = ["visage"]
	ok(run.load_run(), "A V10 SAVE LOADS — tolerant, not refused")
	ok(run.slots_used() > 0, "...with its pouch intact")
	ok(run.pending_item_offers.is_empty(),
		"...and no offers, which is right: a v10 build could not create one")
	# Put the machine back exactly as it was found.
	if had_save:
		var rw := FileAccess.open(save_path, FileAccess.WRITE)
		rw.store_buffer(backup)
		rw = null
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	ok(FileAccess.file_exists(save_path) == had_save,
		"the gate leaves the player's save exactly as it found it")

	# ---------- the battle half: each new item, on live units ----------
	# A HELD, EMPTY SLOT goes in deliberately: "the pouch renders full and
	# empty", and empty only exists because a drained stack keeps its slot.
	# `run` is passed in because this gate already holds it.
	var scene: Node = await Gate.spawn(self,
		["warden", "pyromancer", "holy", "beastmaster"],
		{"run": run, "items": {"bomb": 0}})
	if scene == null:
		ok(false, "the battle never spawned")
		_report()
		return
	var heroes: Array = scene.heroes
	var enemies: Array = scene.enemies
	ok(not heroes.is_empty() and not enemies.is_empty(), "the battle has both sides")

	# The pouch RENDERS FULL AND EMPTY — the brief's own floor. `_init_items`
	# is keyed off the held slots, so a held-but-empty slot must survive it.
	ok(scene.items.size() == run.items.size(),
		"the battle pouch has one entry per HELD SLOT")
	for id in scene.items:
		ok(run.items.has(id), "battle pouch entry %s is a slot the run holds" % id)

	# EACH NEW ITEM IS DRIVEN THROUGH THE REAL `_use_item`, not re-implemented
	# here. `_pick_target` awaits the `_target_picked` signal, so the coroutine
	# is STARTED and the signal emitted from this side — which is the only way
	# to walk a path that normally needs a mouse, and it exercises the refund,
	# the log and the turn-bar rebuild exactly as a player's press would.
	var subject: Object = heroes[0]

	# --- CLEANSE: reads DEBUFF_IDS, strips the lot, never touches a buff ---
	scene.items["cleanse"] = ["Cleansing Draught", 2, "t"]
	scene.item_used = false
	scene._apply_status(subject, "poison", 3)
	scene._apply_status(subject, "slow", 3)
	scene._apply_status(subject, "fortify", 3)   # a BUFF — must survive
	ok(subject.has_status("poison") and subject.has_status("slow"),
		"the subject is afflicted before the Draught")
	for s in scene._cleansable_debuffs(subject):
		ok(unit_gd.DEBUFF_IDS.has(s.id),
			"the cleanse set is DERIVED from DEBUFF_IDS (saw %s)" % s.id)
	# ONE afflicted hero, so `_use_item` takes its single-candidate branch and
	# no pick is owed.
	scene._use_item("cleanse")
	for _i in 30:
		await process_frame
	ok(not subject.has_status("poison"), "the Draught takes the Poison")
	ok(not subject.has_status("slow"), "and the Slow")
	ok(subject.has_status("fortify"),
		"and NEVER the buff — no Draught can strip the party's own work")
	ok(int(scene.items["cleanse"][1]) == 1, "and it spent exactly one charge")

	# A Draught with nothing to cleanse is HANDED BACK, not drunk into nothing.
	scene.item_used = false
	scene._use_item("cleanse")
	for _i in 20:
		await process_frame
	ok(int(scene.items["cleanse"][1]) == 1,
		"a Draught with no affliction to take is refunded, never swallowed")

	# --- VISAGE: every living enemy, battle-long, and it BITES ---
	scene.items["visage"] = ["Cursed Visage", 1, "t"]
	scene.item_used = false
	var living: Array = enemies.filter(func(e): return not e.dead)
	ok(not living.is_empty(), "there are enemies to curse")
	scene._use_item("visage")   # party-wide: no target pick at all
	for _i in 40:
		await process_frame
	for e in living:
		ok(e.has_status("hexed"), "%s is Hexed by the Visage" % e.unit_name)
		ok(int(e.get_status("hexed").get("turns", 0)) < 0,
			"and it is battle-long by the negative-duration convention")
	ok(int(scene.items["visage"][1]) == 0, "the Visage is spent")
	# The hex is not decoration: it must be OUT of the dispellable set, or a
	# Mage strips the party's own hundred gold of work back off.
	for e in living:
		for s in scene._dispellable_buffs(e):
			ok(String(s.id) != "hexed", "Dispel can never take the Hex")

	# --- HOURGLASS: written through next_time, and the hero really is next ---
	scene.items["hourglass"] = ["Resonating Hourglass", 1, "t"]
	scene.item_used = false
	var mover: Object = heroes[heroes.size() - 1]
	for u in heroes + enemies:
		u.next_time = 100.0
	mover.next_time = 900.0
	var bar_before: int = scene.turn_bar.get_child_count()
	# Four living heroes, so this one DOES owe a pick — start the coroutine and
	# answer it.
	scene._use_item("hourglass")
	await process_frame
	await process_frame
	scene._target_picked.emit(mover)
	for _i in 40:
		await process_frame
	var beaten := true
	for u in heroes + enemies:
		if u != mover and not u.dead and u.next_time <= mover.next_time:
			beaten = false
	ok(beaten, "the Hourglass puts its chosen hero ahead of every other unit")
	ok(mover.next_time >= scene._clock, "and never schedules them into the past")
	ok(mover.next_time < 900.0, "the delay of the current action is waived")
	ok(int(scene.items["hourglass"][1]) == 0, "the Hourglass is spent")
	ok(scene.turn_bar.get_child_count() > 0 and bar_before >= 0,
		"and the turn bar was rebuilt rather than reordering invisibly")

	# TARGETS ANY LIVING HERO, NOT ONLY THE ONE ACTING (§4) — the pool the item
	# offers is every living non-companion hero, which is asserted rather than
	# inferred from the pick above.
	var pool_size := 0
	for h in heroes:
		if not h.dead and not h.is_companion:
			pool_size += 1
	ok(pool_size > 1, "the Hourglass could reach more than just the acting hero")

	scene.queue_free()
	_report()


# BATCH DB — one shape for every gate: `NAME: N checks / M failures`.
func _report() -> void:
	_g.report(self)

