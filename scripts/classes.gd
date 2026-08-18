# Shared class data: hero configs, ability kits, and specialization flavor.
# Used by both the battle scene and the party screen.
class_name Classes

# Per-slot tints distinguish heroes until distinct class sprites arrive.
const HERO_TINTS := [Color.WHITE, Color(0.65, 0.75, 1.0), Color(1.0, 0.9, 0.6),
	Color(0.7, 1.0, 0.75)]

# Class passives: one per CLASS, active for every spec of that class (and
# before awakening). Mechanics live in battle.gd, keyed by hero_key.
const CLASS_PASSIVES := {
	"warrior": {"name": "Threatening Presence",
		"desc": "Enemies are 20% more likely to attack the Warrior."},
	"cleric": {"name": "Holy Conduit",
		"desc": "All healing the Cleric receives is increased by 15%."},
	"hunter": {"name": "Tracker",
		"desc": "Always attacks first in every fight."},
	"mage": {"name": "Evocation",
		"desc": "Regenerates an additional 10 Mana per turn."},
}


# Dedicated spec portrait art (shown untinted, original colors).
const SPEC_PORTRAITS := {
	"berserker": "res://assets/sprites/berserker/Berserker_Portrait.png",
}


# List icon: the spec's portrait when it has one, else a cropped close-up
# of the class's idle sprite.
static func class_icon(key: String, spec := "") -> Texture2D:
	if spec != "" and SPEC_PORTRAITS.has(spec):
		return load(SPEC_PORTRAITS[spec])
	var sheet_dir: String = hero_config(key)["sheet_dir"]
	var prefix: String = sheet_dir.get_file().capitalize()
	var tex: Texture2D = load("%s/%s_Idle.png" % [sheet_dir, prefix])
	if tex == null:
		return null
	var crop := AtlasTexture.new()
	crop.atlas = tex
	crop.region = Rect2(28, 18, 44, 60)
	return crop


# Class bases; the spec's Attack (spec_attack) replaces "attack" once
# awakened. Hunters and Mages attack from range — their hits can't be
# parried (parry is a melee answer).
static func hero_config(key: String) -> Dictionary:
	var soldier := "res://assets/sprites/soldier"
	match key:
		"hunter":
			return {"unit_name": "Hunter", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 110, "attack": 100, "armor": 0.12, "speed": 105.0,
				"stability": 100, "constitution": 95, "is_ranged": true,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}
		"warrior":
			return {"unit_name": "Warrior", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 154, "attack": 100, "armor": 0.25, "speed": 95.0,
				"stability": 100, "constitution": 110,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": kit(key)}
		"mage":
			return {"unit_name": "Mage", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 99, "attack": 100, "armor": 0.10, "speed": 110.0,
				"stability": 100, "constitution": 85, "is_ranged": true,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}
		_:
			return {"unit_name": "Cleric", "is_hero": true, "sheet_dir": soldier,
				"max_hp": 121, "attack": 50, "armor": 0.15, "speed": 85.0,
				"stability": 100, "constitution": 100,
				"resource_name": "Mana", "resource": 100, "max_resource": 100,
				"abilities": kit(key)}


static func kit(key: String) -> Array:
	match key:
		"warrior":
			return warrior_kit()
		"mage":
			return mage_kit()
		"hunter":
			return hunter_kit()
		_:
			return cleric_kit()


static func hunter_kit() -> Array:
	return [
		Ability.make({"display_name": "Quick Shot", "cost": 0, "damage": 20, "pressure": 14,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "+10 bonus Mana",
			"description": "Basic ranged shot."}),
	]


static func warrior_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "cost": 0, "damage": 23, "pressure": 18,
			"resource_gain": 20, "delay": 2.0, "anim": "attack01",
			"perfect_id": "rage", "perfect_text": "+10 bonus Rage",
			"description": "Basic attack. Builds 20 Rage."}),
	]


# VAULTED — Mana Shield (removed from ALL mage specs 07-16, kept for
# future return): {"display_name": "Mana Shield", "cooldown": 3, "cost": 15,
#   "special": "mana_shield", "delay": 2.0, "anim": "attack03",
#   "perfect_text": "Initiative cost 1.5 instead of 2",
#   "description": "50% of damage taken converts into Mana (3 turns)."}
static func mage_kit() -> Array:
	return [
		Ability.make({"display_name": "Magic Bolt", "dmg_type": "arcane", "cost": 0, "damage": 25, "pressure": 14,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "Restores 10 Mana",
			"description": "Basic arcane projectile."}),
	]


# ---------- VAULT: removed from kits, kept for future return ----------
# Arcane Surge (was mage core): {"display_name": "Arcane Surge", "cost": 15,
#   "special": "surge", "delay": 3.0, "anim": "attack03",
#   "perfect_text": "+2 Resonance instead of +1",
#   "description": "+20% attack on your next turn. Guarantees +1 Resonance."}
# Reality Fracture (was arcanist): {"display_name": "Reality Fracture",
#   "dmg_type": "arcane", "cost": 20, "damage": 15, "pressure": 14,
#   "delay": 2.0, "anim": "attack03", "delay_push": 6.0,
#   "perfect_text": "Also +1 Resonance",
#   "description": "Shove the target far down the initiative order."}


static func cleric_kit() -> Array:
	# VAULTED — kept for future return: Mend Wounds (25 Mana flat 45 heal).
	# Resurrection now belongs to the Holy tree (pending_talent_ability).
	return [
		# damage 44 = 44% of the Cleric's 50 Attack -> the familiar 22.
		Ability.make({"display_name": "Smite", "dmg_type": "holy", "cost": 0, "damage": 44, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers {mhp:5}",
			"description": "Basic radiant strike."}),
	]


# ---------- the earnable pools (Batch AH) ----------
#
# Every hero starts with its core attack plus exactly 3 spec abilities and
# EARNS 6 more over a run — two per zone, one from the mini-boss and one
# from the zone boss. Each award offers 3 abilities the hero does not own:
# 1 from its SPEC_POOLS entry and 2 from its class's CLASS_POOLS entry
# (Run.roll_ability_offer). Nothing here is new content: a pool entry is
# either an ability trimmed out of a starting kit, an ability a talent node
# grants, an ability another spec of the same class starts with, or a
# vaulted ability whose machinery never left battle.gd.
#
# SPEC_POOLS — what only THIS spec can earn: its own trims, its own
# talent-granted abilities, and its own vaulted ones.
const SPEC_POOLS := {
	# Warrior.
	"berserker": ["Blood Price", "Battle Shout", "Rampage"],
	"warden": ["War Stomp", "Interpose", "Hold the Line", "Retaliation"],
	# Batch AK: Guard Change came OUT of this pool and back into the opening
	# three; Shatterpoint went the other way.
	"swordmaster": ["Sweeping Strikes", "Shatterpoint", "Lunge", "Execute"],
	# Mage. Batch AR re-specced Flame Shield into IMMOLATE, which reads
	# Overburn and so can only ever be a spec pick.
	#
	# ASHES OF AL'AR IS IN ALL THREE MAGE POOLS (Batch BB §6), AND THAT IS A
	# CORRECTION TO THE BRIEF RATHER THAN A LIBERTY. §6 says the ability "joins
	# CLASS_POOLS["mage"]" and calls that one array entry; it IS one array entry
	# and it is made below — but **BATCH AN §4 RETIRED THE CLASS DRAW**, and
	# `award_ability_pick` has read `roll_spec_ability_offer` (SPEC POOLS ONLY)
	# ever since. `CLASS_POOLS` still resolves and nothing reads it, so the
	# class-pool entry ALONE would have given the ability a home no boss can
	# reach — an unearnable answer to a homelessness thread, which is not what
	# §6 asked for. The entry the LIVE draw needs is a spec-pool one per Mage
	# spec; the class-pool entry is made as instructed and stands ready for the
	# day the class draw reopens. "Any Mage may earn it" is the design either
	# way, and re-opening the class draw is a live change to how every one of
	# the twelve specs is offered abilities — far past this section's scope.
	"pyromancer": ["Immolate", "Firestorm", "Ashes of Al'ar"],
	"cryomancer": ["Rime", "Shatter", "Ashes of Al'ar"],
	# Batch AT: STABILIZE joins the pool — it left the opening three because it
	# is the escape hatch from the escalation, and earning it back is the right
	# shape for a safety valve. Every entry here reads Resonance, so none of
	# them can ever be class-pool-eligible (AH's curation rule).
	"arcanist": ["Overcharge", "Magi's Wrath", "Stabilize", "Ashes of Al'ar"],
	# Cleric. The Mercy/Faith spenders can only ever be spec picks — a sibling
	# has no stacks to pay them with. BATCH AV: RESURRECTION LEFT THIS POOL
	# because it joined her opening kit — a boss cannot offer what she starts
	# with. Intercession is deliberately NOT here: it is the Vigil row-4 node's
	# grant and reads Mercy on trigger, so a sibling could not pay it either.
	"holy": ["Divine Plea"],
	"inquisitor": ["Sacred Resolve", "Bulwark of Fortitude"],
	"occultist": ["Mind Flay", "Mass Hysteria", "Umbral Sigil"],
	# Hunter — the three pools that shipped in Batch 30/32, unchanged.
	"beastmaster": ["Bestial Wrath", "Spirit Bond", "Primal Surge",
		"Call of the Wild", "Mark of the Hunt"],
	"sharpshooter": ["Quick Draw", "Triple Shot", "Coup de Grâce",
		"Pinning Shot", "Called Shot"],
	"mystic": ["Explosive Shot", "Venom Coating", "Hamstring",
		"Deadfall", "Harvest"],
}

# CLASS_POOLS — what ANY spec of the class can earn: the sibling specs'
# abilities plus the class's vaulted ones. CURATION RULE: an entry has to
# FUNCTION for a sibling. Anything that costs a spec-exclusive secondary
# resource (faith_cost), reads a passive the taker will not have (Burn to
# consume, Resonance to spend, Loyalty or a living beast, the Swordmaster's
# stance), or is a spec's signature identity piece (the summons, Kill
# Command, Hex of Ruin) stays in SPEC_POOLS only. The changelog lists every
# exclusion and its reason.
const CLASS_POOLS := {
	"warrior": ["Bloodlust", "Wildstrikes", "Hack and Slash", "Blood Price",
		"Battle Shout", "Rampage", "Mocking Blow", "Crushing Blow", "War Stomp",
		"Shieldwall", "Interpose", "Hold the Line", "Overpower", "Pommel Strike",
		"Shatterpoint", "Sweeping Strikes", "Execute", "Rallying Shout"],
	# Batch AR: "Flame Shield" LEFT this pool because it stopped existing —
	# the node that defined it is Immolate now, and Immolate reads Overburn,
	# so it fails the curation rule that a class-pool entry must FUNCTION for
	# a sibling. Pyroblast is a Pyromancer tree node and is deliberately NOT
	# listed: its bonus reads a Burn the taker cannot apply.
	# BATCH BB §6: ASHES OF AL'AR TAKES THE SLOT FLAME SHIELD LEFT, putting the
	# pool back at twelve. It passes AH's curation rule cleanly — a self-revive
	# reads nothing but the taker's own health, so it FUNCTIONS for any Mage —
	# and it is the designer's answer to the homeless-ability thread AR opened.
	# It is EARNABLE, never default: the Pyromancer can have his escape hatch
	# back only by spending a boss pick on it, which is a choice against his own
	# spine rather than the hole AR deliberately left.
	"mage": ["Flamewave", "Firestorm", "Razor Ice", "Blizzard",
		"Ice Lance", "Rime", "Arcane Barrage", "Mana Shield", "Arcane Surge",
		"Reality Fracture", "Phoenix Rebirth", "Ashes of Al'ar"],
	"cleric": ["Heal", "Renewal", "Divine Shield", "Consecrated Ground",
		"Blessing of Zeal", "Sacred Resolve", "Bulwark of Fortitude", "Bewitch",
		"Dark Pact", "Mind Flay", "Mass Hysteria", "Dawnbreak", "Sanctuary",
		"Divine Wrath"],
	"hunter": ["Hunter's Instinct", "Mark of the Hunt", "Aimed Shot", "Powershot",
		"Hold Breath", "Quick Draw", "Triple Shot", "Pinning Shot", "Called Shot",
		"Tripwire", "Shrapnel Charge", "Snare Trap", "Explosive Shot",
		"Venom Coating", "Hamstring", "Deadfall", "Harvest"],
}


# ---------- THE ABILITY DRAFT (Batch BO) ----------
#
# A SECOND POOL, DELIBERATELY SEPARATE FROM `SPEC_POOLS` ABOVE. The zone-boss
# pick is unchanged and still reads SPEC_POOLS; the DRAFT is what elites,
# merchants and events offer, and it reads the two dicts below. Keeping the two
# apart is the only thing that makes "the existing pick, unchanged" true rather
# than nearly true — a shared pool would have re-weighted every boss offer in
# the game the moment eighteen entries landed.
#
# WHAT A DRAFTED ABILITY IS, MECHANICALLY: exactly what an earned one already
# was. It lands in `member["bm_abilities"]`, the same list the boss pick writes,
# so the battle spawn, the hero sheet, `Talents.ability_names`, the rune
# eligibility filter and the upgrade pairing all pick it up with no new
# plumbing and NO SAVE VERSION MOVES (still v10). What the draft adds beside it
# is `member["draft_refused"]` — the names this run may never offer again.
#
# **THE DRAFT IS COMPLETE AT 120 OF 120 (BATCH CI): TWELVE SPECS AT EIGHT
# APIECE (96) PLUS FOUR CLASS POOLS OF SIX (24), AND NOTHING IS OWED.** BO
# opened with eighteen against that target, so an offer of three routinely came
# up two or one; tranche 2 took every spec to five (BT/BU/BV/BW) and tranche 3
# to eight (CB the Mage, CE the Cleric, CH the Hunter, CI the Warrior).
#
# AN OFFER STILL FILLS **SHORT** RATHER THAN PADDING WITH REPEATS — AP §3's
# existing rule for upgrade offers, applied unchanged — but **the only thing
# that can make it fill short now is a run that has already REFUSED or taken
# most of a pool.** It can no longer happen because of which hero drew it, and
# there is no thin pool left anywhere in the game to build one on. The draft
# suites assert the flatness, so a pool quietly EMPTYING would trip rather than
# reading as the old asymmetry coming back.
const SPEC_DRAFT_POOLS := {
	# WARRIOR — EIGHT APIECE SINCE BATCH CI, AND THE WARRIOR IS THE FOURTH AND
	# LAST CLASS COMPLETE. All three pools were NAMED AND EMPTY at BO, so one of
	# four heroes in every party had no draft at all; BP put two apiece in, BW's
	# tranche-2 third took them to five, and CI lands tranche 3's last third
	# here. **THE ASYMMETRY THAT HAS SHAPED EVERY BATCH SINCE BO IS GONE, AND SO
	# IS THE DEBT** — twelve specs at eight apiece plus four class pools of six
	# is 120 of 120, and nothing is owed.
	#
	# THE WARRIOR IS THE ONE CLASS WHOSE KEYS NEVER LIED: `berserker`, `warden`
	# and `swordmaster` are the real keys AND the real display names, unlike the
	# Devout (`inquisitor`) and the Survivalist (`mystic`) above.
	"berserker": ["Blood Offering", "Gut Rip", "Reckless Abandon", "Berserk",
		"Blood Debt", "Unslaked", "Spite", "Boil Over"],
	"warden": ["Covering Guard", "Eye of the Storm", "Shield Slam", "Vendetta",
		"Aegis Wall", "Anvil", "Recompense", "Turn the Blade"],
	"swordmaster": ["Precision Strike", "Feint", "Sever", "Battle Poise",
		"Feigned Guard", "Discipline", "Answering Steel", "Formless"],
	# MAGE — EIGHT APIECE SINCE BATCH CB, AND THE MAGE WAS THE FIRST CLASS
	# COMPLETE. BT took the three Mage pools to five (tranche 2's first third),
	# BU the Cleric three, BV the Hunter three and BW the Warrior three; CB
	# landed tranche 3's first third here, CE its second, CH its third and CI
	# its last. **ALL TWELVE SPECS NOW DRAFT FROM EIGHT** — the asymmetry that
	# ran from BO to CH pointed at the Warrior for its whole life and is dead.
	"pyromancer": ["Cinderfall", "Ember Debt", "Slow Burn", "Stoke",
		"Funeral Pyre", "Firedraw", "Pyre Wake", "Emberkeep"],
	"cryomancer": ["Winter's Toll", "Rimebinding", "Flash Freeze",
		"Killing Frost", "Hoarfrost Armor", "Deep Winter", "Cold Iron",
		"Frostbind"],
	"arcanist": ["Null Field", "Kindled Mind", "Arcane Bolt", "Inner Arcane",
		"Arcane Echo", "Resonant Field", "Threshold", "Unmaking"],
	# CLERIC — EIGHT APIECE SINCE BATCH CE, AND THE CLERIC IS THE SECOND CLASS
	# COMPLETE. BU took the three pools to five (tranche 2's second third); CE
	# lands tranche 3's second third here. THE DEVOUT'S KEY IS `inquisitor` AND
	# HAS BEEN SINCE THE SPEC WAS NAMED — `SPEC_INFO["inquisitor"]` carries the
	# display name "Devout" and master.html's draft table prints "Devout", so
	# the docs and the code disagree BY DESIGN. A `"devout":` entry here would
	# raise nothing, resolve nothing, and ship three cards no hero could ever be
	# offered.
	"holy": ["Second Wind", "Rite of Return", "Recant", "Shared Grief",
		"Reprisal", "Divine Presence", "Alms", "Vespers"],
	"inquisitor": ["Vow of Suffering", "Aegis Reversal", "Ordination",
		"Fortified Spirit", "Reliquary", "Elevation",
		"Blessing of the Faithful", "Mantle"],
	"occultist": ["Blight the Well", "Covenant of Ash", "Suffering",
		"Transference", "Anointing", "Breaking Darkness", "Requiem", "Penance"],
	# HUNTER — EIGHT APIECE SINCE BATCH CH, AND THE HUNTER IS THE THIRD CLASS
	# COMPLETE. BV took the three pools to five (tranche 2's third third); CH
	# lands tranche 3's third third here. THE SURVIVALIST'S KEY IS `mystic` AND
	# HAS BEEN SINCE THE SPEC WAS NAMED — `SPEC_INFO["mystic"]` carries the
	# display name "Survivalist" and master.html prints "Survivalist", so the
	# docs and the code disagree BY DESIGN, exactly as they do for the Devout.
	# A `"survivalist":` entry here would raise nothing, resolve nothing, and
	# ship three cards no hero could ever be offered.
	"beastmaster": ["Twin Hunt", "Call the Wilds", "Bloodbond", "Savage Sweep",
		"Ghostpack", "Last Howl", "Succession", "Unleash"],
	"sharpshooter": ["Called Volley", "Quarry's Mark", "Crossfire",
		"Calibrating Shot", "Trophy Shot", "Reacquire", "Fault Line",
		"Drumfire"],
	"mystic": ["Choking Smoke", "Snare Line", "Loaded Shot", "Hunt",
		"Preparation", "Stalking Horse", "Downwind", "Cull"],
}

# CLASS-WIDE DRAFT ABILITIES — COMPLETE (Batch BR). Six per class,
# twenty-four in all. BQ shipped the MAGE and CLERIC twelve and named the
# HUNTER and WARRIOR twelve as owed; BR pays that debt, so THE ONE-IN-FOUR
# CLASS SEAM NOW DRAWS A REAL ENTRY FOR EVERY HERO IN THE GAME. No class rolls
# an empty pool any more, and no offer loses its class card.
#
# **THE DRAFT IS 120 OF A TARGET 120 AS OF BATCH CI (96 spec + 24 class-wide),
# AND NOTHING IS OWED.** Tranche 3 closed with the Warrior third; every one of
# the twelve spec pools is eight deep and every one of the four class pools is
# six deep.
#
# THE TARGET IS 120, NOT ~96, AND BATCH CD CORRECTED IT HERE (§2). The ~96 came
# from an older assumption of SIX spec cards per spec; CB completed the Mage at
# EIGHT, which makes the spec target 12 x 8 = 96 and the whole draft 96 + 24 =
# 120. test_batch_bt has asserted depth 8 since CB, so the tests encoded the
# right figure while three comments in this file and master.html carried the
# old one.
#
# **WHAT A LATER BATCH CAN STILL BREAK IS NOT THE COUNT BUT THE FLATNESS.** This
# block read "48 ... spec pools remain thin at two apiece" from BR until BW
# corrected it toward the code, and every draft suite's per-spec depth loop has
# been re-pointed SEVEN times since BO — each earlier tranche's asymmetry, then
# the flatness tranche 2 achieved, then CB's new asymmetry, halved at CE,
# quartered at CH, and now GONE. It asserts a flat EIGHT now, so a pool that
# quietly empties trips rather than reading as the old debt returning.
#
# THIS IS A SEPARATE STRUCTURE FROM `CLASS_POOLS` ABOVE AND IT MUST STAY ONE.
# The reason is BO's own, applied to the other pool: `CLASS_POOLS` feeds the
# BOSS pick today, so dropping six abilities into it would silently re-weight
# every boss offer in the game as a side effect of a draft change. THE
# TIDY-LOOKING EDIT A LATER BATCH WOULD MAKE — folding two class pools into one
# — IS EXACTLY THE ONE THIS COMMENT EXISTS TO REFUSE. `CLASS_POOLS` is
# byte-untouched by Batch BQ AND by Batch BR; test_batch_bq and test_batch_br
# both assert it AS LITERALS rather than by size, because a swap of two names
# would keep the count and change every boss draw in the game.
#
# THE AUTHORING RULES, RECORDED WITH THE CONTENT THEY GOVERN: a class-wide
# ability is DELIBERATELY UNTIED AND GENERAL — Magic Barrier, not Frostbolt.
# The test is whether it would read as off-theme for ANY spec of that class; if
# a Pyromancer drawing it would feel like he wandered into the wrong tree, it is
# a spec ability. And they are WEAKER THAN SPEC ABILITIES AND UNCONDITIONAL:
# they feed no passive (a Barrier does nothing for Overburn, a heal nothing for
# Ruin), so at equal power they would be a safe default that dilutes every
# build. Slightly weaker but always-on makes them the pick you take when your
# spec's engine is not online yet, which is a real role and a different one.
const CLASS_DRAFT_POOLS := {
	"warrior": ["Battle Trance", "Rally", "Charge", "Cleave", "Warcry",
		"Ironclad"],
	"mage": ["Magic Barrier", "Mirror Image", "Magic Missiles", "Mana Well",
		"Dispel", "Blink"],
	"cleric": ["Ministration", "Consecration", "Chastise", "Unburden",
		"Exhortation", "Undying Vigil"],
	"hunter": ["Field Dressing", "Camouflage", "Aimed Volley", "Bola",
		"Hunter's Mark", "Arcane Arrows"],
}

# Roughly one card in four is class-wide; the rest are spec. Read by
# `Run.roll_draft_offer` per CARD, so a three-card offer averages 0.75
# class-wide entries rather than being forced to hold exactly one.
const CLASS_DRAFT_SHARE := 0.25


# ---------- THE PROTECTED CORE (Batch BO §2) ----------
#
# EVERY SPEC KEEPS A PROTECTED CORE: its passive, its basic attack, and the
# minimum abilities its passive needs to function. Protected abilities can
# NEVER be dropped, so every drop decision is among EARNED abilities — which
# keeps the choice clean and makes the slot cap unable to break a passive.
#
# THE FAILURE MODE THIS TABLE EXISTS TO PREVENT IS SILENT: a spine that stops
# working because its enabler became draftable. Nothing crashes, nothing logs,
# the spec simply reads as weak. `enablers` is therefore AUTHORED rather than
# derived, and test_batch_bo asserts every named enabler is still in that
# spec's opening kit and in NO draft or spec pool.
#
# TWO COLUMNS, AND THE DISTINCTION IS THE WHOLE POINT:
# · `slots` — how many of the cap's seven the opening kit occupies. Ten specs
#   sit at 3 (leaving 4 draftable). HOLY IS 4, because Batch AV gave her a
#   fourth opening ability on purpose. THE BEASTMASTER HOLDS FIVE ABILITIES IN
#   THREE SLOTS: his three summons share one action-bar entry, which has been
#   Batch AH's rule since the pools were built, and counting them as three
#   would take a spec down to two draftable picks for a bookkeeping reason.
# · `enablers` — the MINIMUM the passive cannot function without. IT VARIES,
#   and it is decided per spec rather than by a rule: Overburn is meaningless
#   without a Burn applier and without Detonation to spend it, so the
#   Pyromancer's core is larger than the Berserker's, whose Blood Frenzy reads
#   nothing but his own health bar. An EMPTY list is a real answer, not an
#   omission — those specs' opening abilities are protected because they
#   shipped in the kit, not because the passive needs them.
const PROTECTED_CORES := {
	"berserker": {"slots": 3, "enablers": [],
		"why": "Blood Frenzy reads his own health bar and nothing else."},
	"warden": {"slots": 3, "enablers": [],
		"why": "Heavy Plating is a Block-chance rule; it reads no ability."},
	# BATCH BP corrected this `why` toward the code rather than leaving it to
	# rot: Guard Change is no longer the ONLY stance swap in the game — Precision
	# Strike and Feint both switch. It is still the enabler, and for a sharper
	# reason than before: it is the only UNCONDITIONAL one. The other two are
	# DRAFTED (a Swordmaster may never be offered either), cost Rage, and sit on
	# 3- and 4-turn cooldowns, so a passive that is half inert without a swap
	# still cannot be left depending on them.
	"swordmaster": {"slots": 3, "enablers": ["Guard Change"],
		"why": "Seasoned Fighter is two stances, and Guard Change is his only UNCONDITIONAL stance swap — the two drafted ones are neither guaranteed nor free (Batch AK, corrected BP)."},
	"pyromancer": {"slots": 3, "enablers": ["Fireball", "Detonation"],
		"why": "Overburn needs a Burn applier to build the field and a spender to empty it."},
	"cryomancer": {"slots": 3, "enablers": ["Frostbolt", "Ice Lance"],
		"why": "Glacial Hold needs a Chilled applier to reach four stacks and a release to end the hold."},
	"arcanist": {"slots": 3, "enablers": ["Arcane Explosion"],
		"why": "Runaway Resonance builds on damaging casts; the free core attack is what guarantees one every turn."},
	"holy": {"slots": 4, "enablers": ["Heal", "Hymn of Hope"],
		"why": "Mercy is earned passively and must be SPENDABLE — Hymn pays stacks outright, and Empower needs a heal to empower."},
	"inquisitor": {"slots": 3, "enablers": ["Divine Shield", "Consecrated Ground"],
		"why": "Conviction builds ONLY on Divine Shield absorbs, and Batch BI measured the ground's drip at 66% of all Faith."},
	"occultist": {"slots": 3, "enablers": ["Shadowrend", "Hex of Ruin"],
		"why": "Wrath of the Old Gods marks on debuffs HE applies; these two are the debuffs he always holds."},
	"beastmaster": {"slots": 3,
		"enablers": ["Summon Ursus", "Summon Canis", "Summon Aguila"],
		"why": "Pack Bond reads a living companion. With no summon there is no boon, no Loyalty and no passive at all."},
	"sharpshooter": {"slots": 3, "enablers": ["Quick Shot"],
		"why": "Lethal Aim counts consecutive single-target attacks; the free shot is what lets him stay on a mark every turn."},
	"mystic": {"slots": 3, "enablers": [],
		"why": "Trapper's poison rides being struck, and its breadth term counts statuses from ANY source — including his allies'."},
}


static func spec_draft_pool(spec: String) -> Array:
	return SPEC_DRAFT_POOLS.get(spec, [])


static func class_draft_pool(class_name_key: String) -> Array:
	return CLASS_DRAFT_POOLS.get(class_name_key, [])


# How many of the cap's seven slots this spec's protected core occupies.
static func core_slots(spec: String) -> int:
	return int(PROTECTED_CORES.get(spec, {}).get("slots", 3))


# The minimum the passive cannot function without. Authored, not derived —
# see the block above for why.
static func core_enablers(spec: String) -> Array:
	return PROTECTED_CORES.get(spec, {}).get("enablers", [])


# Every display name the spec's protected core covers, READ OFF THE LIVE KIT
# so it can never drift from what the hero actually opens holding: the class
# core attack (after `apply_kit_overrides` renames it) plus every opening spec
# ability. This is the list the drop step refuses.
static func protected_names(spec: String) -> Array:
	var out: Array = []
	var class_key := class_of_spec(spec)
	if class_key != "":
		var cfg := {"abilities": kit(class_key)}
		apply_kit_overrides(cfg, spec)
		for ab in cfg["abilities"]:
			out.append(ab.display_name)
	for ab2 in spec_abilities(spec):
		if ab2 != null and not out.has(ab2.display_name):
			out.append(ab2.display_name)
	return out


static func spec_pool(spec: String) -> Array:
	return SPEC_POOLS.get(spec, [])


static func class_pool(class_name_key: String) -> Array:
	return CLASS_POOLS.get(class_name_key, [])


# The class a spec belongs to ("" when the spec is unknown/unawakened).
static func class_of_spec(spec: String) -> String:
	for class_key in SPEC_IDS:
		if SPEC_IDS[class_key].has(spec):
			return class_key
	return ""


# BATCH CM §1 — THE GATED TELL, ONE STRING, THREE SURFACES. The battle tooltip
# (`battle._ability_tooltip`), the ability button (`battle._ability_popup_button`)
# and the draft card (`computed_block` below) all say it, and they say the SAME
# words because a rule stated three ways is a rule the player has to reconcile.
# It lives here for `computed_block`'s reason: this file is the one both screens
# already call into.
#
# IT IS RENDERED FROM THE FLAG AND NEVER AUTHORED INTO A DESCRIPTION — CL §1's
# rule applied to a sentence rather than to a number. Five cards carrying their
# own copy is five places for the gate to outlive itself.
const GATED_TELL := "GATED: a Sloppy check loses the cast.\nOnly the turn is spent."


# ---------- THE COMPUTED BLOCK (Batch CK §1) ----------
#
# ONE BUILDER, TWO SURFACES, AND THAT IS THE WHOLE POINT OF IT LIVING HERE.
# The draft card (`map_screen._draft_column`) and the hero sheet
# (`party_screen._draw_detail`) both put an ability's numbers under its
# description. Before CK the sheet held the only copy, so the draft card showed
# the description ALONE — and 30 of the 66 damaging abilities never state their
# damage in prose, because every other surface computes it (audit §2.1). Ice
# Lance was the sharpest: `damage: 35` in the dict and a card that reads only
# "+5% of Attack per Chilled stack", so it drafted as a per-stack ability. A
# SECOND COPY ON THE MAP SCREEN IS THE DRIFT THIS THREAD IS ABOUT, so both
# callers come here.
#
# THE THIRD SURFACE IS DELIBERATELY NOT FOLDED IN. `battle._ability_tooltip`
# reads a LIVE BattleUnit: Surge, Empower and the Resonance curve multiply its
# damage, and it prints "(ready in N)" off that unit's cooldown clock. It is a
# mid-combat tooltip with live state in it rather than a static card, and
# merging it would move numbers inside a fight. Recorded in CLAUDE.md as the one
# remaining copy, with this reason.
#
# `attack` IS THE HERO'S LIVE ATTACK STAT, OR 0 WHEN THE CALLER HAS NONE, AND
# THE TWO PRINT DIFFERENT LINES ON PURPOSE. With a figure it prints the real
# range the hit will roll; with 0 it prints the ability's own SCALING
# PERCENTAGE. Both are legal on these two screens and nowhere else — the draft
# screen and the glossary are the arithmetic-ALLOWED tier in
# `docs/text-standard.html`. The draft card passes 0 because THE MAP SCREEN HAS
# NO LIVE ATTACK TO READ: only `party_screen._draw_detail` and the battle spawn
# build one, each with its own sixty-line prologue (hero_config, kit overrides,
# passive, spec stats, tree, runes, upgrades, node scaling), and a third copy of
# THAT on the map screen would be a far worse duplication than the one this
# function exists to prevent. Extracting it is its own batch; when it lands,
# this call site changes by one argument and the range appears.
static func computed_block(ab: Ability, attack: int = 0,
		resource: String = "", ctx: Dictionary = {}) -> String:
	if ab == null:
		return ""
	var lines := PackedStringArray()
	if ab.damage > 0:
		var bd := "   BD: %d" % ab.pressure
		var hits := ""
		if ab.random_hits > 0 or ab.multi_hits > 0:
			hits = "   × %d hits" % maxi(ab.random_hits, ab.multi_hits)
		if attack > 0:
			# The same 0.9/1.1 variance band the battle tooltip quotes, off the
			# same field — this is the range the strike loop will roll inside.
			var hit := ab.damage * 0.01 * float(attack)
			lines.append("Damage: %d–%d (%s)%s%s" % [int(hit * 0.9),
				int(round(hit * 1.1)), ab.dmg_type.capitalize(), bd, hits])
		else:
			lines.append("Damage: %d%% of Attack (%s)%s%s" % [ab.damage,
				ab.dmg_type.capitalize(), bd, hits])
	if ab.heal > 0:
		lines.append("Heals: %d" % ab.heal)
	# NO COST LINE ON A FREE ABILITY rather than a "Costs nothing" line: the
	# card is 258px wide and the block already adds five lines to it, so a line
	# that says nothing is a line that pushes a real one out of view.
	if ab.cost > 0 and resource != "":
		lines.append("Costs %d %s" % [ab.cost, resource])
	elif ab.cost > 0:
		lines.append("Costs %d" % ab.cost)
	# `faith_cost` IS MERCY EVERYWHERE IT APPEARS — Resurrection, Divine Plea
	# and Hymn of Hope, all three Holy Cleric (see `pending_talent_ability`'s
	# header). `battle._ability_popup_button` names it off the live unit's
	# `second_resource_name` because a BattleUnit has one; neither caller here
	# does, and inventing a generic word for a resource with exactly one owner
	# would read worse than its name.
	if ab.faith_cost > 0:
		lines.append("Costs %d Mercy" % ab.faith_cost)
	if ab.cooldown > 0:
		lines.append("Cooldown: %d turn%s" % [ab.cooldown,
			"" if ab.cooldown == 1 else "s"])
	lines.append("Initiative cost: %.1f" % ab.delay)
	if ab.perfect_text != "":
		# §1 applies to `perfect_text` as much as to `description` — CK made the
		# draft card render Perfect, so all 190 of these are on the screen where
		# cards are compared and every one of them needs its value resolved.
		lines.append("Perfect: %s" % resolve_values(ab.perfect_text, ctx))
	# BATCH CM §1 — THE TELL, third of three surfaces, and LAST IN THE BLOCK on
	# purpose: it is the one line that is about whether the card resolves at all,
	# so it reads after everything it can take away. The draft card is where the
	# decision to carry one of these is actually made, which is why "the player
	# must know BEFORE committing" reaches this screen and not only the fight.
	if ab.gated:
		lines.append(GATED_TELL)
	return "\n".join(lines)


# ---------- BATCH CL §1 — THE VALUE RESOLVER ----------
# A percentage is followed by its computed value in parentheses:
# "20% of maximum health (34)". THE PARENTHETICAL IS COMPUTED HERE AND IS NEVER
# AUTHORED INTO A STRING. An authored "(34)" would be a second copy of a number
# the code already owns, in two hundred new places — which is the exact drift
# `text-audit.html` exists to catch, reintroduced at scale. A description
# carries a TOKEN and this expands it; a literal digit inside parentheses in any
# authored field is a defect.
#
#   {mhp:20}          20% of maximum health (34)
#   {mhp:20|target}   20% of the target's maximum health
#   {chp:20}          20% of current health (28)     — volatile, MOVES, correct
#   {res:3}           3% of maximum Mana (4)         — names the live resource
#   {atk:8}           8% of Attack (12)
#   {tot:25|block}    +25% Block chance (→ 35%)      — CHIPS ONLY
#
# `ctx` carries whatever bases the calling surface actually HAS, and nothing is
# required. A surface with no hero — the draft card, the offer picker, the
# glossary — passes {} and every token falls back to the bare percentage with
# no parenthetical, no placeholder and no dash, which is §1's third resolution
# case. This is why the resolver cannot fail: an absent base is a legal answer.
#
# THE OWNER SUFFIX IS WHAT MAKES §4.2 MECHANICAL. The words come from HERE, so
# the prose's "whose percentage" and the base the renderer divides into can no
# longer drift apart — naming the owner and resolving against it are one edit.
# A self-owned value is bare ("maximum health") because the pronouns are gone;
# an other-owned one says whose. Target- and ally-owned values are usually
# unresolvable at tooltip time (the tooltip is built for the CASTER, before a
# target is picked), so they correctly fall through to the bare percentage.
const _VALUE_WORDS := {
	"mhp": {"words": "maximum health", "key": "max_hp"},
	"chp": {"words": "current health", "key": "hp"},
	"atk": {"words": "Attack", "key": "attack"},
	"res": {"words": "maximum %s", "key": "max_resource"},
}

# The already-final case (§1, first resolution case). On a status chip a final
# percentage resolves to the resulting TOTAL, because mid-fight the useful
# number is what Block actually IS now. Everywhere else a final percentage
# stands alone — a card reading "+25% Block chance (25%)" is noise.
const _TOTAL_STATS := {
	"block": {"label": "Block chance", "key": "block_chance"},
	"parry": {"label": "Parry chance", "key": "parry_chance"},
	"crit": {"label": "critical chance", "key": "crit_bonus"},
}

static var _value_rx: RegEx = null


static func resolve_values(text: String, ctx: Dictionary = {}) -> String:
	if text == "" or not text.contains("{"):
		return text
	if _value_rx == null:
		_value_rx = RegEx.new()
		_value_rx.compile("\\{(mhp|chp|atk|res|tot):(\\d+(?:\\.\\d+)?)(?:\\|(\\w+))?\\}")
	var found := _value_rx.search_all(text)
	if found.is_empty():
		return text
	# Spliced RIGHT TO LEFT so every match's offsets stay valid: each expansion
	# only ever changes the string after the match being replaced, and the next
	# one worked on lies entirely before it.
	var out := text
	for i in range(found.size() - 1, -1, -1):
		var m: RegExMatch = found[i]
		out = out.substr(0, m.get_start()) \
			+ _expand_value(m.get_string(1), float(m.get_string(2)),
				m.get_string(3), ctx) \
			+ out.substr(m.get_end())
	return out


static func _expand_value(kind: String, pct: float, owner: String,
		ctx: Dictionary) -> String:
	# Whole percentages print whole; the Arcanist's 1.5 and 0.75 steps keep
	# their one decimal, which is the only place a fraction appears.
	var num := ("%d" % int(pct)) if is_equal_approx(pct, float(int(pct))) \
		else String.num(pct, 2).rstrip("0").rstrip(".")
	if kind == "tot":
		var stat: Dictionary = _TOTAL_STATS.get(owner, {})
		var bare := "+%s%% %s" % [num, String(stat.get("label", owner))]
		if stat.is_empty() or not ctx.has(stat["key"]):
			return bare
		# The chip's stat is carried as a fraction (0.10 = 10%); the token's
		# percentage is added to it, so the chip states what the stat became.
		var total := float(ctx[stat["key"]]) * 100.0 + pct
		return "%s (→ %d%%)" % [bare, int(round(total))]
	var spec: Dictionary = _VALUE_WORDS.get(kind, {})
	if spec.is_empty():
		return "%s%%" % num
	var words := String(spec["words"])
	var key := String(spec["key"])
	if kind == "res":
		# NO GENERIC WORD FOR A RESOURCE THAT HAS A NAME: a unit knows whether
		# it spends Rage or Mana, and "maximum resource" reads like a debug
		# string. With no unit the percentage stands alone anyway.
		if not ctx.has("resource_name") or String(ctx["resource_name"]) == "":
			return "%s%%" % num
		words = words % String(ctx["resource_name"])
	match owner:
		"target":
			words = "the target's " + words
			key = "target_" + key
		"ally":
			words = "the ally's " + words
			key = "ally_" + key
	var bare := "%s%% of %s" % [num, words]
	if not ctx.has(key):
		return bare
	return "%s (%d)" % [bare, int(round(float(ctx[key]) * pct * 0.01))]


# The ctx a live BattleUnit supplies. Kept HERE rather than in battle.gd so the
# hero sheet and the battle tooltip cannot disagree about what a token resolves
# against — the sheet builds the same dict from a config, and both go through
# one resolver.
static func value_ctx_from_unit(u) -> Dictionary:
	if u == null:
		return {}
	return {
		"max_hp": u.max_hp, "hp": u.hp, "attack": u.attack,
		"max_resource": u.max_resource, "resource_name": u.resource_name,
		"block_chance": u.block_chance, "parry_chance": maxf(u.parry_chance, 0.0),
		"crit_bonus": u.crit_bonus,
	}


# The same ctx off the hero sheet's side, where the hero is a config dict and a
# `Run.party` member rather than a spawned unit. The sheet's `cfg` has already
# been through the full sixty-line prologue (kit overrides, passive, spec stats,
# tree, runes, node scaling) by the time this is called, so the bases here are
# the same ones the battle spawn will produce. `member` carries the only thing
# `cfg` cannot: how much health the hero is actually on right now.
static func value_ctx_from_config(cfg: Dictionary, member: Dictionary = {}) -> Dictionary:
	var ctx := {
		"max_hp": int(cfg.get("max_hp", 0)),
		"attack": int(cfg.get("attack", 0)),
		"max_resource": int(cfg.get("max_resource", 0)),
		"resource_name": String(cfg.get("resource_name", "")),
		"block_chance": float(cfg.get("block_chance", 0.0)),
		"parry_chance": maxf(float(cfg.get("parry_chance", 0.0)), 0.0),
		"crit_bonus": float(cfg.get("crit_bonus", 0.0)),
	}
	if member.has("hp"):
		ctx["hp"] = int(member["hp"])
	return ctx


# Resolve a pool NAME to its Ability, from either pool. The `spec` argument
# survives from the Batch 30 signature and only steers the three hunter
# trophy tables; everything else resolves by name alone, because a display
# name is unique across the whole game.
static func spec_pool_ability(spec: String, display_name: String) -> Ability:
	if spec == "sharpshooter":
		var ss := sharpshooter_pool_ability(display_name)
		if ss != null:
			return ss
	if spec == "mystic":
		var sv := survivalist_pool_ability(display_name)
		if sv != null:
			return sv
	return pool_ability(display_name)


# THE resolver. Order matters only for speed — no name lives in two of
# these. Nothing here holds a second copy of an ability that exists
# elsewhere: kit pieces are read back out of the living kits and
# talent-granted ones out of the living trees, so a pool copy can never
# drift from the copy the kit or the talent hands out.
static func pool_ability(display_name: String) -> Ability:
	# BATCH BO: the draft's own defs come first — they are a plain match and
	# nothing else in the game holds a copy of them, so a drafted ability
	# resolves everywhere an earned one already did (battle spawn, hero sheet,
	# blacksmith pairing, upgrade eligibility) with no second resolver.
	var drafted := draft_ability(display_name)
	if drafted != null:
		return drafted
	var beast := beastmaster_pool_ability(display_name)
	if beast != null:
		return beast
	var ss := sharpshooter_pool_ability(display_name)
	if ss != null:
		return ss
	var sv := survivalist_pool_ability(display_name)
	if sv != null:
		return sv
	var pend := pending_talent_ability(display_name)
	if pend != null:
		return pend
	var trimmed := trimmed_kit_ability(display_name)
	if trimmed != null:
		return trimmed
	var vault := vault_ability(display_name)
	if vault != null:
		return vault
	# Another spec of the same class starts with it — read the live kit.
	for class_key in SPEC_IDS:
		for spec_id in SPEC_IDS[class_key]:
			for ab in spec_abilities(spec_id):
				if ab.display_name == display_name:
					return ab
	# A talent node grants it (new_ability payloads live in the trees).
	return Talents.granted_ability(display_name)


# -- THE DRAFTED ABILITIES — ONE HUNDRED AND ELEVEN OF A TARGET 120 (BO..CH) --
#
# BATCH BO SHIPPED EIGHTEEN — six MAGE, six CLERIC, six HUNTER — and named the
# six WARRIOR entries as owed rather than pretending the pools were full.
# BATCH BP CLOSED THAT DEBT: six more, two per Warrior spec, so all twelve
# specs have a draft and `SPEC_DRAFT_POOLS` is 24 entries.
# BATCH BQ ADDED THE FIRST TWELVE CLASS-WIDE ONES — six MAGE, six CLERIC.
# BATCH BR ADDS THE OTHER TWELVE — six HUNTER, six WARRIOR — so
# `CLASS_DRAFT_POOLS` IS FULL AT 24 AND THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL
# ENTRY FOR EVERY HERO IN THE GAME.
# TRANCHE 2 IS COMPLETE: BATCH BT the MAGE nine, BATCH BU the CLERIC nine,
# BATCH BV the HUNTER nine and BATCH BW the WARRIOR nine — nine spec cards
# apiece, three per spec — so all twelve specs draft from at least FIVE and no
# offer fills short for a SPEC reason any more.
# TRANCHE 3 IS THREE QUARTERS PAID: BATCH CB took the three MAGE pools to EIGHT,
# BATCH CE the three CLERIC pools and BATCH CH the three HUNTER pools, so THE
# HUNTER IS THE THIRD CLASS COMPLETE. The WARRIOR third is what is left — 9
# cards, and it is the last debt the draft carries.
#
# EVERY ABILITY NAMES THE AXIS IT SERVES, in its comment. That rule is here
# because the twelve tree batches spent themselves removing nodes that existed
# to fill a grid, and a hundred and twenty abilities has the same risk in a
# larger form.
# NO ABILITY MAY BE A STRICTLY BETTER VERSION OF ANOTHER IN THE SAME POOL —
# Batch BD found Deadfall had duplicated Snare Trap for fourteen batches.
#
# ONE NUMBER PER ABILITY IS THIS BATCH'S RATHER THAN THE BRIEF'S, AND IT IS
# FLAGGED HERE RATHER THAN BURIED: **Break damage**. §5 specifies cost,
# initiative, cooldown, target and effect for all eighteen and says nothing
# about `pressure`, exactly as Batch AT's brief said nothing about Death Ray's
# — and that omission became a thread that took three batches to close. The
# two that are ordinary attacks carry BD in line with their siblings; the rest
# are not attacks and carry none.
#
# BATCH BW APPLIED THAT RULE TO THE WARRIOR NINE AND REPORTED WHAT IT ASSIGNED,
# because §1 asked for BD to be decided rather than omitted. THREE OF THE NINE
# ARE ATTACKS and carry it; the other six are not and carry none, which is a
# decision on each of them and not an oversight on any:
#   · Shield Slam  40 — named by the brief.
#   · Sever        15 — 40% of Attack for 25 Rage, priced beside Feint (35%/12)
#                       and Precision Strike's Defensive branch (15%/15). Its BD
#                       is what OPENS the window its cooldown clause then
#                       exploits, so the number matters most on the first cast.
#   · Blood Debt   10 — 30% of Attack for 20 Rage, one step under Feint on the
#                       same curve; Gut Rip's 20 is the 30-Rage end of it.
#   · Reckless Abandon, Berserk, Battle Poise, Feigned Guard, Vendetta and
#     Aegis Wall land no blow at all, so BD would have nothing to ride.
static func draft_ability(display_name: String) -> Ability:
	match display_name:
		# ----- BERSERKER (Batch BP): how do you get low, and what do you do
		# with the blood. His damage scales with missing health and four
		# Bloodletting nodes fire off a bleedout event — AND HE CONTROLS
		# NEITHER. Enemy damage decides when he reaches his power band; a
		# 100-point buildup decides when four of his own nodes fire.
		#
		# AXIS: buying the frenzy band on purpose. Every other hero avoids
		# damage; he needs it, and today he waits for someone to give it to him.
		# PERCENT OF CURRENT HEALTH, NOT MAXIMUM — so it can never kill him and
		# its absolute cost shrinks as he drops, which is correct for a spec
		# that wants to live low rather than die low.
		"Blood Offering":
			return Ability.make({"display_name": "Blood Offering", "cost": 0,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 3,
				"anim": "attack02", "special": "blood_offering",
				"perfect_id": "", "perfect_text": "",
				"description": "Open a vein on purpose: lose 20% of\nyour CURRENT health and gain 60 Rage.\nIt can never take you below 1 — and\nthe lower you are, the less it costs."})
		# AXIS: the bleedout stops being the enemy's clock. Bloodcraze, Scent of
		# Blood, Arterial Spray and Blood Tithe are four nodes waiting on a
		# trigger he cannot pull. IT FIRES THE REAL BLEEDOUT PATH, not a copy,
		# so every talent that reads a bleedout sees this one — Slaughterhouse
		# included, which leaves the meter at 50 rather than 0.
		"Gut Rip":
			return Ability.make({"display_name": "Gut Rip", "cost": 30,
				"damage": 6, "pressure": 20, "delay": 2.5, "cooldown": 4,
				"anim": "attack03", "special": "gut_rip",
				"perfect_id": "", "perfect_text": "{atk:9} per 10 buildup",
				"description": "Tear the wound wide: the target BLEEDS\nOUT at once whatever its buildup, and\ntakes 6% of Attack for every 10 points\nconsumed. Everything that answers a\nbleedout answers this one."})
		# ----- BERSERKER, TRANCHE 2 (Batch BW): spend the rage, take the risk,
		# and finally get paid back. BP's pair were both single-target and both
		# about him getting LOW, and nothing in the spec paid him back for being
		# there. These three are the dump, the risk dial at maximum, and the
		# sustain hole filled by his own engine.
		#
		# AXIS: the dump. Rage is a resource he ACCUMULATES and spends in
		# 20-to-35 point sips; nothing in the kit ever asked what a full bar is
		# worth all at once. At 100 Rage this is +20% for three turns and it
		# costs him every ability he might have cast in that window — which is
		# the trade, not a drawback bolted on.
		#
		# SYNERGY: BLOOD OFFERING feeds it 40 Rage out of his own health, so the
		# two chain into a dump he can pay for on demand; BLOOD TITHE (45 Rage a
		# bleedout) and BLOODIED MOMENTUM (40 a kill) refill the bar he just
		# emptied, which is what turns a once-a-fight button into a rhythm. And
		# it is a DELIBERATE ANTI-SYNERGY WITH BLOODWAKE, which pays him for
		# HOLDING Rage — a Bloodwake build wants a different card entirely, and
		# that is what makes this a build decision rather than a strict pick.
		"Reckless Abandon":
			return Ability.make({"display_name": "Reckless Abandon", "cost": 0,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack02", "special": "reckless_abandon", "gated": true,
				"perfect_id": "", "perfect_text": "3% per 10 Rage",
				"description": "Throw everything at it: spend ALL your\nRage, and for 3 turns deal +2% damage\nfor every 10 points SPENT. A full bar\nis +20% — and three turns with nothing\nleft to cast."})
		# AXIS: the risk dial at maximum, and THE DRAWBACK IS THE PAYOFF. Blood
		# Frenzy scales his damage with missing health, so taking 30% more
		# damage drives him into his own power band — the only card in the game
		# whose downside feeds the passive of the hero holding it.
		#
		# TWO DIFFERENT CLOCKS ON ONE CARD and the description says so plainly:
		# the three doubled attacks are CHARGES that wait until spent (Feint's
		# and Waiting Guard's idiom), while the 30% is an ordinary 3-turn
		# status. A player who reads "3" twice and assumes one number is the
		# person this wording exists for.
		#
		# PER BR §1 IT COUNTS HITS, NOT CASTS, so a doubled multi-hit ability is
		# very large: Hack and Slash spends all three charges in one cast and
		# lands six. FLAGGED AS PROBABLY THE STRONGEST CARD IN THE WARRIOR SET
		# AND SHIPPED TO BE WATCHED RATHER THAN PRE-TUNED (§2).
		#
		# SYNERGY: HACK AND SLASH and WILDSTRIKES are three-hit and area blows
		# that spend the whole bank in one cast, and every doubled strike carries
		# his bleed buildup — so it fills meters for GUT RIP and BLOOD DEBT twice
		# as fast. BLOOD FRENZY is the other half of the trade: the 30% more
		# damage taken is the fastest way into his own missing-health band, and
		# DEATHWISH and UNDYING RAGE both pay again once he is there. SCAR TISSUE
		# is what makes the risk survivable.
		"Berserk":
			return Ability.make({"display_name": "Berserk", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack03", "special": "berserk",
				"perfect_id": "", "perfect_text": "",
				"description": "Let it take you: your next 4 STRIKES\neach land twice — they wait until\nspent. For 3 turns you take 30% more\ndamage, which is where Blood Frenzy\nlives."})
		# AXIS: a reason to survive being low. Blood Frenzy pays him for missing
		# health and NOTHING IN HIS KIT PAYS HIM BACK — that is the sustain hole,
		# and this fills it out of his own engine rather than with a heal.
		#
		# THE MARK IS BATTLE-LONG AND SURVIVES THE BLEEDOUT THAT PAYS IT. That
		# is the clause most likely to be built as one-shot by accident, and it
		# is the whole card.
		#
		# SYNERGY: SLAUGHTERHOUSE (Bloodletting row 8) drops a bleedout to 50
		# rather than 0, so the SAME marked enemy bleeds out repeatedly and one
		# mark pays three or four times — that pairing is the card's ceiling and
		# the reason the mark must persist. GUT RIP cashes it on demand,
		# HEMORRHAGE and SAVAGERY fill the meter faster, ARTERIAL SPRAY spreads
		# the buildup that fills it, BLOODCRAZE is the small unmarked version of
		# the same idea (holding both is a real sustain build), and BLOOD
		# OFFERING becomes near-free once a mark is out.
		"Blood Debt":
			return Ability.make({"display_name": "Blood Debt", "cost": 20,
				"damage": 30, "pressure": 10, "delay": 2.0, "cooldown": 4,
				"anim": "attack01",
				"perfect_id": "", "perfect_text": "{mhp:35}",
				"description": "Name the debt and collect it: strike\nfor 30% of Attack and MARK the enemy\nfor the rest of the battle. Every time\nit bleeds out you heal 25% of your\nmaximum health — and the mark SURVIVES\nthe bleedout, so it pays again."})
		# ----- SWORDMASTER (Batch BP): what is a stance worth. Stances were a
		# binary toggle with passive numbers on each side and NOTHING in his kit
		# ever behaved differently depending on which one he was in. Both entries
		# read the stance and then SWITCH it.
		#
		# THE GOVERNING PRINCIPLE, AND IT IS WHAT MAKES THE SWITCH A FEATURE
		# RATHER THAN A TAX: EACH BRANCH BUYS WHAT THE STANCE HE IS ARRIVING IN
		# WANTS. Cast from Aggressive he lands in Defensive, so the ability hands
		# him defence; cast from Defensive he lands in Aggressive, so it hands
		# him offence. He is never stranded — he always arrives holding
		# something. A LATER STANCE ABILITY MUST BE AUTHORED THE SAME WAY ROUND;
		# it is the thing that would most easily be got backwards.
		#
		# AXIS: the same blade, two intentions. ARMOR IS BYPASSED OUTRIGHT rather
		# than penetrated by a percentage — a multiplier on a base of zero would
		# have been a clause that silently does nothing, which is the exact dud
		# AP §3's eligibility rule exists to prevent.
		"Precision Strike":
			return Ability.make({"display_name": "Precision Strike", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 3,
				"anim": "attack01", "special": "precision_strike",
				"perfect_id": "", "perfect_text": "The stance holds 4 turns",
				"description": "Read the guard, then change it.\nFROM AGGRESSIVE: strike TWICE for 20%\nof Attack each, and gain +25% parry\nfor 3 turns.\nFROM DEFENSIVE: strike ONCE for 15%\nof Attack with 15 BD, and your attacks\nignore ALL armor for 3 turns.\nEither way the stance then SWITCHES."})
		# AXIS: their swing lands somewhere they did not intend. From the front
		# foot he tricks them into a friend; from the back foot into themselves.
		# CHARGES, NOT TURNS — they wait until spent, so a Feint cast into a lull
		# is not wasted and it cannot be dodged by an enemy simply not attacking.
		"Feint":
			return Ability.make({"display_name": "Feint", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 4,
				"anim": "attack02", "special": "feint",
				"perfect_id": "", "perfect_text": "Defensive banks a third charge; Aggressive strikes for 45%",
				"description": "Sell an opening.\nFROM AGGRESSIVE: strike for 35% of\nAttack, and that enemy's next attack\nlands on one of its OWN allies.\nFROM DEFENSIVE: no strike — bank 2\ncharges, each parrying an attack\noutright and returning its damage to\nthe attacker.\nEither way the stance then SWITCHES."})
		# ----- SWORDMASTER, TRANCHE 2 (Batch BW): THE FIRST STANCE-GATED CARDS.
		#
		# THE STANDING RULE THIS BATCH ESTABLISHES, AND IT GOVERNS EVERY FUTURE
		# SWORDMASTER CARD: **READERS BRANCH AND FLIP. GATED ONES REQUIRE AND
		# STAY.** BP shipped the readers (Precision Strike, Feint) — they branch
		# on the stance and then switch it, and BP's arriving-stance principle
		# decides which branch buys what. A GATED card is a different animal: it
		# is REFUSED OUTRIGHT in the wrong stance (not a weaker branch —
		# unavailable), and casting it does not move him. Getting these two card
		# types backwards is the single easiest mistake to make here.
		#
		# `_ability_usable` IS THE DOOR, matching how Death Ray's Resonance gate
		# and BV's nine are refused — so the greyed button, the bot's pool and
		# the cast itself can never disagree.
		#
		# AXIS: the Break window rewards aggression. His Breaker lane opens a
		# one-turn window and NOTHING let him swing repeatedly inside it.
		# SYNERGY: SHATTERPOINT is what opens the window on demand, and
		# PUNISHMENT (+60% against a Broken target), OFF BALANCE, PRESSURE POINT
		# and GUARD BREAKER all live inside it — every one of them is worth more
		# per swing, and this is the card that buys extra swings. SUNDER GUARD's
		# party-wide Break off a free Guard Change is how the window arrives at
		# all against a boss. Any Pin-shaped effect that extends Broken makes the
		# clear fire more than once, which is the build this card is for.
		"Sever":
			return Ability.make({"display_name": "Sever", "cost": 25,
				"damage": 40, "pressure": 15, "delay": 2.5, "cooldown": 4,
				"anim": "attack03",
				"perfect_id": "", "perfect_text": "Also strips 35% armor for 3 turns",
				"description": "REQUIRES THE AGGRESSIVE GUARD.\nCut deep for 40% of Attack. If the\ntarget is BROKEN this ability's\ncooldown is cleared outright, so the\nwindow can be swung through again\nand again."})
		# AXIS: defence buys tempo. He is the only parry-STAT hero in the game —
		# 12% base, plus Sword Mastery and High Guard — and every point of it
		# currently just makes hits smaller. THIS IS THE CONNECTION HIS THREE
		# LANES HAVE NEVER HAD: Poise feeding Blade and Breaker.
		#
		# SYNERGY: the whole POISE lane is the enabler, because the card pays PER
		# PARRY — SWORD MASTERY and SWORDSMANSHIP raise the roll, HIGH GUARD
		# hardens it after every success, DEFLECTION lets him parry ranged
		# attacks at all, WAITING GUARD banks guaranteed parries and FEINT's
		# charges are two more. What it buys back is the other two lanes:
		# SEVER, SHATTERPOINT, EXECUTE and GUARD CHANGE all come off cooldown
		# faster. IT GOES THROUGH `_tick_cooldowns` — BQ's one implementation of
		# cooldown reduction — rather than writing a second walk of the same
		# dictionary.
		"Battle Poise":
			return Ability.make({"display_name": "Battle Poise", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 4,
				"anim": "attack01", "special": "battle_poise",
				"perfect_id": "", "perfect_text": "",
				"description": "REQUIRES THE DEFENSIVE GUARD.\nFor 4 turns every attack he PARRIES\ntakes a turn off all his cooldowns.\nThe more often he turns a blade, the\nfaster the rest of his kit comes back."})
		# AXIS: the only card in the game that lets a build have BOTH HALVES of
		# its own toggle.
		#
		# THE GATE-SATISFYING CLAUSE IS LOAD-BEARING, NOT A CONVENIENCE. Without
		# it this is a minor modifier on two abilities; with it, an Aggressive
		# build can cast Battle Poise and a Defensive build can cast Sever, and
		# THAT is what makes it worth a slot. It must satisfy the gate in
		# `_ability_usable` and not merely change the branch taken at
		# resolution — those are two different sites and only the first makes
		# the card true.
		#
		# IT DOES NOT SWITCH THE STANCE AND MUST NOT BE BUILT TO. A reader that
		# flips plus a window that does not is the whole distinction between the
		# two card types.
		#
		# SYNERGY: it is the card that makes the other four stance cards
		# compose. An AGGRESSIVE build gets BATTLE POISE plus two turns of
		# PRECISION STRIKE's armor bypass and FEINT's counter charges WHILE
		# KEEPING AGGRESSIVE'S DAMAGE BONUS AND KILLING EDGE the whole time —
		# his passive still reads the guard he is actually in, and only his
		# ABILITIES are fooled. Reversed, a DEFENSIVE build gets SEVER, LUNGE's
		# Exposed and Precision Strike's double hit while keeping SEASONED
		# FIGHTER's mitigation, BRACING and UNTOUCHABLE.
		"Feigned Guard":
			return Ability.make({"display_name": "Feigned Guard", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.0, "cooldown": 3,
				"anim": "attack02", "special": "feigned_guard",
				"perfect_id": "", "perfect_text": "",
				"description": "Show them the wrong guard. For 3 turns\nyour ABILITIES resolve as though cast\nfrom the OTHER stance — and satisfy\nthat stance's requirement — while you\nkeep the one you are standing in. It\ndoes NOT switch your guard."})
		# ----- WARDEN (Batch BP): what does protection look like when it is not
		# his own. Block is his signature stat and it has only ever protected
		# him; Taunt brings damage to him one enemy at a time.
		#
		# AXIS: his stat protecting someone else. THIS IS NOT REDIRECTION —
		# nothing moves to him. The attack simply stops, which is what Block does
		# and what nothing else in the game does. It reads his LIVE Block chance,
		# so Shieldwall, Heavy Plating's climb and Bulwark Line all feed it.
		"Covering Guard":
			return Ability.make({"display_name": "Covering Guard", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.5, "cooldown": 4,
				"anim": "attack01", "special": "covering_guard",
				"target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Stand over another: for 4 turns YOUR\nBlock chance is rolled against every\nattack aimed at one ally, and a\nsuccess negates it entirely. Nothing\nmoves to you — the blow just stops.\nIt reads your Block LIVE."})
		# AXIS: being outnumbered becomes the point. A party-wide defensive
		# cooldown that costs him everything, and it is self-balancing — a bigger
		# field means more mitigation as well as more incoming.
		"Eye of the Storm":
			return Ability.make({"display_name": "Eye of the Storm", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 4,
				"anim": "attack03", "special": "eye_of_storm",
				"perfect_id": "", "perfect_text": "",
				"description": "Take the whole field: EVERY enemy is\ntaunted onto you for 3 turns, and you\ntake 8% less damage for each one\ntaunted. The more of them there are,\nthe better you weather it."})
		# ----- WARDEN, TRANCHE 2 (Batch BW): his bulk as a weapon, a permanent
		# duel, and Block that pays the party. BP's pair were BOTH DEFENSIVE and
		# he has no offense at all; the first of these three is the answer to
		# that, and it is offense made out of the stat he already stacks.
		#
		# TWO OF THE THREE READ HIS MAXIMUM HEALTH AND HEAVY PLATING GROWS IT
		# MID-BATTLE (Tenacity, +15 per Block). THEY MUST READ IT LIVE. A
		# snapshot at cast makes the whole Plate lane silently stop feeding
		# them, which is the class of bug that fails no test and reads as the
		# card merely being weak.
		#
		# AXIS: his bulk as a weapon. The Break contributes to a WARRIOR PARTY'S
		# central axis rather than to his own damage number, which is why 40 BD
		# sits on a card whose damage is a health percentage.
		# SYNERGY: the whole PLATE lane is its damage stat — HEAVY PLATING,
		# TENACITY (+15 maximum health a block) and UNWAVERING FAITH-shaped
		# max-health terms all make the blow bigger, and SHIELDWALL, BULWARK
		# LINE and INTERPOSE buy the blocks Tenacity grows on. The Break half
		# feeds SUNDERING, ELEMENTAL WEAKNESS and BATTERED NOT BROKEN, and hands
		# a Swordmaster's SEVER and PUNISHMENT the Broken target they want.
		"Shield Slam":
			return Ability.make({"display_name": "Shield Slam", "cost": 25,
				"damage": 0, "pressure": 40, "delay": 2.5, "cooldown": 3,
				"anim": "attack01", "special": "shield_slam",
				"perfect_id": "", "perfect_text": "{mhp:20}",
				"description": "Put the shield through them: damage\nequal to 15% of your MAXIMUM health,\nplus 40 Break damage. Heavy Plating\ngrows that maximum every time you\nblock, and this reads it LIVE."})
		# AXIS: a permanent duel. Eye of the Storm taunts EVERYTHING for two
		# turns; this locks ONE thing forever, which is the opposite trade and
		# the reason both are worth holding.
		#
		# NAMED VENDETTA AND NOT "GRUDGE" (Batch BW §1, reported): `wd_grudge`
		# is already a Warden THREAT-lane talent — the same spec, the same lane
		# — and the Rune of Grudges pays into the same term. Two things called
		# Grudge one row apart is exactly what BR §1's naming sweep exists to
		# catch. The talent keeps the name (its id is save-migrated); the
		# unshipped card moved. THEY COMPOSE: Grudge the talent pays +25%
		# against a target HIS taunt binds, and this is a taunt that never
		# lapses.
		#
		# IT REUSES THE TAUNT SYSTEM rather than writing a parallel one — the
		# `mocked` status at -1 turns, which is exactly the shape The Whole Room
		# already installs — so the lock RELEASES IF THE WARDEN FALLS for free:
		# `_choose_enemy_action` re-resolves the taunter live and ignores a dead
		# one.
		#
		# SYNERGY: GRUDGE THE TALENT pays +25% against a target HIS taunt binds,
		# and this is a taunt that never lapses — the two are written for each
		# other and now sit one row apart in the same lane. SPITE and BRUISING
		# GUARD reflect everything it throws, IMMOVABLE refuses the Break it
		# builds, HEAVY PLATING and SHIELDWALL turn its attacks into the blocks
		# TENACITY and AEGIS WALL feed on, and the 20% makes it a duel he wins.
		# EYE OF THE STORM is the opposite trade rather than a rival: the whole
		# field for two turns, or one enemy forever.
		"Vendetta":
			return Ability.make({"display_name": "Vendetta", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack02", "special": "vendetta",
				"perfect_id": "", "perfect_text": "",
				"description": "Make it personal: for the REST OF THE\nBATTLE that enemy can attack nobody\nbut you, and you take 30% less damage\nfrom it. It ends only when one of you\ndoes."})
		# AXIS: his signature stat feeds the party. BLOCK NEGATES AN ATTACK
		# ENTIRELY AND PAYS HIM NOTHING BEYOND THAT — this is the first thing in
		# the game that makes a block worth something to anyone else.
		#
		# IT READS **BLOCKS**, NOT ATTACKS TAKEN, and that is the clause that
		# could silently be built wrong: a blocked attack is one that was
		# negated, and a hit that got through pays nothing.
		#
		# SYNERGY: SHIELDWALL and BULWARK LINE raise Block chance, INTERPOSE
		# gives guaranteed charges the wall pays off outright, and HEAVY PLATING
		# and TENACITY grow the maximum the heal reads — four things a
		# Plate/Banner build already stacks, all making one card larger. EYE OF
		# THE STORM and VENDETTA both drag attacks onto him, which is what turns
		# a Block chance into a heal RATE; RALLY (+30% healing received) and
		# UNBURDENED multiply what lands on the party.
		"Aegis Wall":
			return Ability.make({"display_name": "Aegis Wall", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack03", "special": "aegis_wall",
				"perfect_id": "", "perfect_text": "",
				"description": "The wall answers for everyone: for 4\nturns every attack you BLOCK heals the\nwhole party for 8% of your maximum\nhealth. A blow that gets through pays\nnothing — only a block."})
		# ===== BATCH CI — TRANCHE 3, THE WARRIOR NINE. THE DRAFT IS COMPLETE. =====
		#
		# A CONTIGUOUS BLOCK rather than interleaved with BP's and BW's entries
		# above (CB/CE/CH's shape — BW's had to interleave, these do not). The
		# AXIS/SYNERGY acceptance check still anchors PER ABILITY, because a
		# shared header must not be able to satisfy all nine at once.
		#
		# EIGHT OF THE NINE CARRY A `special`; BOIL OVER DELIBERATELY DOES NOT,
		# and that looks like an omission which is why it is recorded (the BV
		# five-of-nine / CB Cold Iron pattern). `_resolve` sends any ability
		# holding a `special` down `_resolve_special`, which means hand-rolling
		# the blow and losing the whole attack pipeline with it — crits, armor,
		# resists, Break, the parry roll AND Blood Frenzy's own multiplier at the
		# strike site. Boil Over is an ordinary strike with two riders and NEEDS
		# that pipeline, so it keys on `display_name` at the ordinary sites.
		#
		# ----- BERSERKER: the ratchet, the band, the payout. His two earlier
		# tranches asked how he gets LOW (BP) and what a full bar buys (BW).
		# These three are the first cards in the game that read the passive's own
		# FLOOR — the half of Blood Frenzy that has never had a lever on it.
		#
		# AXIS: the ratchet rate. Blood Frenzy's floor keeps HALF the peak he
		# reaches, and nothing in the game has ever touched that fraction —
		# Scar Tissue raises it from the tree, and a Berserker who did not buy
		# that node has no way to. This is the drafted answer, and it is a
		# WINDOW rather than a permanent raise, so the play pattern is the point:
		# cast it, THEN dive, and the floor locks in at double its usual value
		# for the rest of the battle.
		#
		# SYNERGY: BLOOD OFFERING is the dive he controls (20% of current health
		# on demand), so the two are a two-card combo that banks a floor on his
		# own schedule rather than waiting for an enemy to grant it; BERSERK's
		# 30%-more-damage-taken is the same dive from the other side and lands
		# him deeper. SCAR TISSUE composes rather than overlaps — the card can
		# only ever RAISE what is kept, so a Berserker holding both loses
		# nothing. BOIL OVER is the card that spends what this banks, and
		# UNDYING RAGE and DEATHWISH both pay again for living down there.
		"Unslaked":
			return Ability.make({"display_name": "Unslaked", "cost": 30,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack02", "special": "unslaked",
				"perfect_id": "", "perfect_text": "",
				"description": "Nothing settles it. For 4 turns Blood\nFrenzy's floor keeps the FULL bonus you\nreach instead of half of it. Cast it,\nthen dive: what you bank at the bottom\nis yours for the rest of the battle."})
		# AXIS: surviving the band he is paid for standing in. Blood Frenzy pays
		# him for missing health and every other answer to being low is a HEAL,
		# which lifts him straight back out of his own power band.
		#
		# **MITIGATION, NOT HEALING, AND THAT IS THE WHOLE CARD.** A version that
		# healed him here would fight his passive: it would take back the missing
		# health the passive is paying for, so the card would cancel itself. This
		# one keeps him exactly where he is and simply makes it survivable, and
		# it gets LARGER the deeper he goes — the first defensive card in the
		# game that rewards being nearly dead.
		#
		# SYNERGY: BLOOD FRENZY reads the same missing health this does, so
		# every point that makes this bigger makes his damage bigger too; BERSERK
		# and RECKLESS FURY both invite the damage this refuses, and SCAR TISSUE
		# and UNSLAKED bank the floor he earns on the way down. UNDYING RAGE and
		# ASHES-shaped death refusals are what the last 15% is for, and BLOOD
		# DEBT's bleedout heal is the deliberate opposite number — take that one
		# to leave the band, this one to live in it.
		"Spite":
			return Ability.make({"display_name": "Spite", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack02", "special": "spite",
				"perfect_id": "", "perfect_text": "",
				"description": "Out of pure spite. For 6 turns take 1%\nless damage for every 5% of maximum\nhealth MISSING, up to 40%. It is\nmitigation and never healing — it keeps\nyou in the frenzy band rather than\nlifting you out of it."})
		# AXIS: cashing the live bonus instead of carrying it. Blood Frenzy is a
		# multiplier he holds and never SPENDS; this is the one card that takes
		# the number itself as payment.
		#
		# **THE COST IS THE GAP BETWEEN THE BONUS AND THE FLOOR**, which is what
		# makes it a different card in every build rather than a flat drawback:
		# the floor is untouched, so a Berserker who banked a deep one barely
		# feels the two turns, and one who has not just lost most of his damage.
		# That is precisely why UNSLAKED is worth a slot beside it.
		#
		# SYNERGY: UNSLAKED above all — a floor holding the FULL peak makes the
		# recovery nearly free, and the two together are the batch's own combo.
		# SCAR TISSUE does the same thing from the tree. BLOOD OFFERING and
		# BERSERK drive the live bonus up before the strike lands, and RECKLESS
		# ABANDON's window multiplies the blow it pays for. Anything that Breaks
		# the target first (SHIELD SLAM, a Swordmaster's SUNDER GUARD) lands it
		# into a +25% crit window.
		"Boil Over":
			return Ability.make({"display_name": "Boil Over", "cost": 40,
				"damage": 30, "pressure": 15, "delay": 2.5, "cooldown": 5,
				"anim": "attack03", "gated": true,
				"perfect_id": "", "perfect_text": "The recovery costs 1 turn",
				"description": "Spend the rage itself: strike for 30%\nof Attack plus 2% more for every POINT\nof your live Blood Frenzy bonus. For 2\nturns afterwards you receive only the\nFLOOR, not the live bonus — the floor\nitself is untouched."})
		# ----- WARDEN: deny the reset, get paid for it, or turn it outward.
		# Heavy Plating climbs +8% Block per unblocked hit and a BLOCK THROWS THE
		# WHOLE CLIMB AWAY. That sawtooth is his passive's central cruelty and
		# nothing has ever had an answer to it. These three are three answers,
		# and two of them are deliberately incompatible.
		#
		# AXIS: the sawtooth becomes a staircase. The climb exists as bad-luck
		# protection, so throwing it away on success is the passive taxing him
		# for the thing it is meant to buy.
		#
		# **FLAGGED, NOT TUNED (§2): with the bonus free to climb to its +40%
		# ceiling and stay there, this is potentially the strongest card in the
		# batch.** It ships as written and play prices it — the same treatment
		# BW's Berserk and CH's Fault Line got, and for the same reason.
		#
		# SYNERGY: the whole PLATE lane compounds with it — PLATE DISCIPLINE
		# steepens the climb to +12% a hit so the ceiling arrives in two hits and
		# then STAYS, TENACITY banks +15 maximum health per block it keeps
		# buying, and UNKILLABLE mends on every one. SHIELDWALL and BULWARK LINE
		# add their own slice on top of a plating bonus that no longer falls.
		# AEGIS WALL and TURN THE BLADE both pay PER BLOCK, so a card that raises
		# how often he blocks raises everything they pay. **RECOMPENSE IS THE
		# DELIBERATE ANTI-SYNERGY** and both cards say so.
		"Anvil":
			return Ability.make({"display_name": "Anvil", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack01", "special": "anvil",
				"perfect_id": "", "perfect_text": "",
				"description": "Do not move. For 4 turns BLOCKING no\nlonger resets the Heavy Plating bonus,\nso the climb keeps everything it earns\nand the sawtooth becomes a staircase.\nRECOMPENSE is paid nothing while this\nholds — there is no reset to pay it."})
		# AXIS: getting paid for the cruelty instead of preventing it. Anvil
		# refuses the reset; this one is FUNDED BY IT, and the deeper the climb
		# was the larger the payout — so the same term that makes the sawtooth
		# hurt is the term that makes this card good.
		#
		# **ANVIL AND RECOMPENSE ACTIVELY FIGHT EACH OTHER AND THAT IS INTENDED
		# (§2).** A Warden holding both gets nothing from the second while the
		# first is up. They are TWO ANSWERS TO THE SAME CRUELTY, not a stack, and
		# it must not be smoothed over — both descriptions say so outright, and
		# it falls out of the implementation rather than being a special case:
		# Anvil suppresses the reset, and no reset means nothing to pay for.
		#
		# SYNERGY: PLATE DISCIPLINE is worth more here than anywhere else — a
		# +12%-a-hit climb means the resets it feeds on are BIGGER, so the two
		# nodes that make the sawtooth worse make this card better. Everything he
		# spends Rage on is the payoff, and his own pool is 100: SHIELD SLAM,
		# VENDETTA, EYE OF THE STORM and AEGIS WALL all come back sooner off a
		# bar a single deep reset can refill by a third.
		"Recompense":
			return Ability.make({"display_name": "Recompense", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack02",
				"special": "recompense",
				"perfect_id": "", "perfect_text": "",
				"description": "Be paid for the loss. For 6 turns,\nwhenever Blocking resets your Heavy\nPlating bonus you gain Rage equal to\nthe percentage points lost — a reset\nfrom +32% pays 32 Rage. ANVIL prevents\nthose resets, so the two do not stack."})
		# AXIS: the block pointed outward. A Block NEGATES an attack entirely and
		# pays him nothing beyond that; Aegis Wall made it worth something to the
		# party, and this makes it worth something to the enemy that threw it.
		#
		# THIS MAKES **THREE SPECS ACROSS THREE CLASSES** GENERATING BREAK THAT
		# THE OCCULTIST'S BREAKING DARKNESS AMPLIFIES — the Warden here, the
		# Sharpshooter's FAULT LINE and the Occultist himself. That web is
		# deliberate (§2) and it is the reason this card is Break rather than
		# damage: a Warrior party's central axis is the Break meter, and he is
		# the hero standing where the blows land.
		#
		# SYNERGY: BREAKING DARKNESS (Occultist) lands every point of it 25%
		# harder, and SUNDERING, ELEMENTAL WEAKNESS and BROKEN WILL all multiply
		# it from his own tree. BRUISING GUARD pays flat Break on the same
		# trigger and the two ADD. ANVIL, SHIELDWALL, BULWARK LINE and INTERPOSE
		# all buy more blocks, which is the only thing that makes this scale.
		# What it hands over is a BROKEN target: a Swordmaster's SEVER clears its
		# own cooldown against one and PUNISHMENT pays +60% into it.
		"Turn the Blade":
			return Ability.make({"display_name": "Turn the Blade", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 4,
				"anim": "attack03", "special": "turn_the_blade",
				"perfect_id": "", "perfect_text": "",
				"description": "Send it back. For 4 turns every attack\nyou BLOCK deals Break damage to the\nattacker equal to half the damage the\nblock refused. A blow that gets THROUGH\npays nothing — only a block."})
		# ----- SWORDMASTER: dwell, parry, and neither stance. BP gave him
		# readers that branch and flip, BW gated cards that require and stay.
		# These three are the first that argue with the switch itself.
		#
		# AXIS: paying him for REFUSING to switch. His whole spec is built on
		# the pivot — the passive is two stances, his enabler is the swap, and
		# five drafted cards read or require a guard — and nothing has ever
		# rewarded standing still.
		#
		# **IT FIGHTS HIS OWN READERS AND HIS OWN GATED CARDS, WHICH IS THE
		# TENSION WORTH HAVING (§3).** Precision Strike and Feint both flip him,
		# so casting either throws the accumulation away; Sever and Battle Poise
		# each demand a specific guard, so holding one means giving up the other.
		# That is a real decision rather than a drawback.
		#
		# SYNERGY: SEASONED FIGHTER is the thing it deepens, so it is worth
		# exactly as much as the stance he is standing in — and it composes
		# ADDITIVELY with the two nodes that already deepen that passive
		# (Aggressive Stance and Defensive Stance), because it writes into their
		# read sites rather than a third. FEIGNED GUARD is the card that resolves
		# the whole tension: it satisfies the OTHER stance's requirement WITHOUT
		# switching him, so a Discipline build can still cast Sever or Battle
		# Poise without losing a turn of accumulation. KILLING EDGE, BRACING and
		# UNTOUCHABLE all pay a build that has committed to one guard anyway.
		"Discipline":
			return Ability.make({"display_name": "Discipline", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack01", "special": "discipline",
				"perfect_id": "", "perfect_text": "",
				"description": "Do not be moved. For 7 turns, each\nconsecutive turn held in the SAME\nstance strengthens that stance's own\neffect by 4%, up to 15%. A GUARD CHANGE\nresets the accumulation to nothing —\nand so does any card that switches you."})
		# AXIS: the parry stat finally buying something. He is the only
		# parry-STAT character in the game — 12% base, plus Sword Mastery,
		# Swordsmanship and High Guard — and THIS IS THE FIRST CARD THAT READS
		# IT (Battle Poise pays per parry too, and this is the card that makes
		# the roll itself worth raising).
		#
		# **THE RIPOSTE TALENT ALREADY GRANTS A COUNTER-ATTACK ON PARRY AND THIS
		# MUST NOT DUPLICATE IT (§3).** Answering Steel pays TEMPO — Rage and
		# cooldowns — and never damage, so a hero holding both gets the counter
		# AND the tempo off one parry and the two stack cleanly.
		#
		# SYNERGY: the whole POISE lane raises the roll this doubles down on —
		# SWORD MASTERY and SWORDSMANSHIP raise the chance, HIGH GUARD hardens
		# it after every success, DEFLECTION lets him parry ranged attacks at
		# all, WAITING GUARD banks guaranteed parries and FEINT's charges are two
		# more, and RIPOSTE answers each one with a free Overpower. BATTLE POISE
		# is the deliberate stacking partner rather than a rival: both pay per
		# parry, so a single turned blade takes TWO turns off every cooldown he
		# holds. What the Rage buys back is FORMLESS, the most expensive card in
		# his pool at 35.
		"Answering Steel":
			return Ability.make({"display_name": "Answering Steel", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack02", "special": "answering_steel",
				"perfect_id": "", "perfect_text": "",
				"description": "Let the blade answer. For 6 turns your\nparry chance is +20%, and every attack\nyou PARRY grants 15 Rage and takes a\nturn off all your cooldowns. It pays\ntempo, not damage — Riposte's counter\nstill answers as well."})
		# AXIS: being neither, and both. The stance is the spec's one binary and
		# every card in his pool sits on one side of it; this is the card that
		# refuses the question for three turns.
		#
		# TWO IMPLEMENTATION CALLS, BOTH DELIBERATE AND BOTH WRITTEN DOWN (§3):
		# · **HE COUNTS AS BOTH STANCES FOR STANCE-GATED ABILITIES**, so every
		#   gated card in his kit is usable during the window. THAT is what makes
		#   this a build-enabler rather than a stat buff, and it is decided at
		#   `_ability_usable` — the same door BW's gated cards are refused at —
		#   so the greyed button, the bot's pool and the cast cannot disagree.
		# · **GUARD CHANGE IS REFUSED WHILE IT HOLDS**, at that same door: there
		#   is no stance to change.
		#
		# SYNERGY: SEVER and BATTLE POISE are the two cards it exists for — an
		# Aggressive build gets the Defensive window and a Defensive build gets
		# the Aggressive one, without giving up the guard his passive reads.
		# FEIGNED GUARD is the cheaper, narrower version of the same idea (it
		# satisfies the OTHER gate; this satisfies BOTH) and they compose. It is
		# also the one window in which a DISCIPLINE build can cast its gated
		# cards without switching. The recoil is what SEASONED FIGHTER's own two
		# downsides look like paid at once, so a build that can spend the two
		# turns behind a WARDEN's taunt pays very little for it.
		"Formless":
			return Ability.make({"display_name": "Formless", "cost": 35,
				"damage": 0, "pressure": 0, "delay": 2.5, "cooldown": 6,
				"anim": "attack03", "special": "formless",
				"perfect_id": "", "perfect_text": "",
				"description": "Hold no guard at all. For 4 turns you\ndeal +15% damage AND take 15% less —\nboth stances' upsides and neither\ndownside — and you count as BOTH\nstances for anything that requires one.\nYou cannot Guard Change. When it ends\nyou suffer BOTH downsides for 2 turns."})
		# ----- PYROMANCER: different answers to how do you commit -----
		# AXIS: spending wide instead of deep. Detonation empties one bank;
		# this skims every bank, and Overburn refunds every turn it takes.
		"Cinderfall":
			return Ability.make({"display_name": "Cinderfall", "dmg_type": "fire",
				"cost": 30, "damage": 20, "pressure": 8, "delay": 3.0,
				"cooldown": 3, "aoe": true, "anim": "attack03",
				"special": "cinderfall",
				"perfect_id": "", "perfect_text": "Takes 3 turns of Burn from each",
				"description": "Rake the whole field for 20% of Attack,\nthen tear 2 turns of Burn from EACH\nburning enemy to deal that much again\nto it. Overburn refunds every turn taken."})
		# AXIS: PAID BEFORE IT BURNS (BATCH BS §4, re-authored). Its old axis was
		# "commitment without the bill" — an exemption from Overburn's Mana
		# drain — and BS deleted the drain, so the card's whole second sentence
		# had nothing left to say. Every other Burn payout in the kit EMPTIES
		# the bank (Detonation eats a stack, Wildfire and Cinderfall skim the
		# field); this is the deepest single-target Burn he can lay AND the only
		# card Overburn pays for without consuming anything.
		"Ember Debt":
			return Ability.make({"display_name": "Ember Debt", "dmg_type": "fire",
				"cost": 20, "damage": 0, "pressure": 0, "delay": 2.0,
				"cooldown": 4, "anim": "attack02", "special": "ember_debt",
				"perfect_id": "", "perfect_text": "",
				"description": "Set a debt alight: 12 turns of Burn on\none enemy — and Overburn pays you for\nevery one of them NOW, as though you\nhad already consumed them. The fire\nstill burns its full term."})
		# ----- CRYOMANCER: what do you do with the time you bought -----
		# AXIS: cashing in without releasing. Shatter and Ice Lance both end the
		# hold to be paid; this collects interest and leaves the prison standing.
		"Winter's Toll":
			return Ability.make({"display_name": "Winter's Toll", "dmg_type": "frost",
				"cost": 25, "damage": 8, "pressure": 0, "delay": 2.5,
				"cooldown": 4, "anim": "attack02", "special": "winters_toll",
				"perfect_id": "", "perfect_text": "{atk:12} per turn held",
				"description": "Collect the interest: the HELD enemy\ntakes 8% of Attack for every turn it\nhas spent in the ice — AND THE HOLD\nCONTINUES. Unusable while he holds\nnothing."})
		# AXIS: the hold as a template. One deep prison becomes the next one.
		"Rimebinding":
			return Ability.make({"display_name": "Rimebinding", "dmg_type": "frost",
				"cost": 20, "damage": 0, "pressure": 0, "delay": 2.0,
				"cooldown": 3, "anim": "attack02", "special": "rimebinding",
				"perfect_id": "", "perfect_text": "",
				"description": "Copy the prison: apply Chilled to one\nenemy equal to the stacks standing on\nthe enemy you already hold, plus one. Four\nstacks put it in the ice too."})
		# ----- ARCANIST: what carries you through the early game -----
		# AXIS: the ramp defends itself. Worthless at 2 stacks, enormous at 12 —
		# so it does not rescue his early game, it makes surviving TO the late
		# game the reward for ramping. Deliberately the opposite of Stabilize.
		"Null Field":
			return Ability.make({"display_name": "Null Field", "dmg_type": "arcane",
				"cost": 25, "damage": 0, "pressure": 0, "delay": 2.0,
				"cooldown": 4, "anim": "attack03", "special": "null_field",
				"perfect_id": "", "perfect_text": "",
				"description": "Fold the storm inward: for 4 turns you\ntake 5% less damage PER RESONANCE\nSTACK — read live, so it deepens as\nyou keep casting. Nothing at 2 stacks;\nhalf again at 10."})
		# AXIS: buying the ramp with tempo. His fastest early climb and a card
		# he would rather not cast late — the correct shape for escalation.
		"Kindled Mind":
			return Ability.make({"display_name": "Kindled Mind", "dmg_type": "arcane",
				"cost": 15, "damage": 15, "pressure": 6, "delay": 1.5,
				"cooldown": 2, "anim": "attack01",
				"perfect_id": "", "perfect_text": "Builds 4 Resonance",
				"description": "A small deliberate spark: 15% of\nAttack, and it banks 3 Resonance\ninstead of 1."})
		# ----- HOLY: what does reversal cost you -----
		# AXIS: undoing recent history rather than topping up. Enormous on
		# someone just spiked, worthless on someone healthy.
		"Second Wind":
			return Ability.make({"display_name": "Second Wind", "cost": 30,
				"special": "second_wind_holy", "target": Ability.Target.ALLY,
				"delay": 2.5, "cooldown": 4, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Up to {mhp:55|ally}",
				"description": "Take back the last two turns: heal an\nally for ALL the damage they have\ntaken in that window, up to 40% of\ntheir maximum. Nothing on someone\nwho has not been hit."})
		# AXIS: reversal bought in advance rather than reacted to. Resurrection
		# undoes a death and costs Mercy; this prevents one and costs her health.
		"Rite of Return":
			return Ability.make({"display_name": "Rite of Return", "cost": 35,
				"special": "rite_of_return", "target": Ability.Target.ALLY,
				"delay": 3.0, "cooldown": 5, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "Promise one ally the road back: for 4\nturns, the next blow that would fell\nthem restores them to 50% health\ninstead — and Holy loses 30% of hers\nwhen it pays."})
		# ----- DEVOUT: what else can he lend -----
		# AXIS: mitigation by relocation. Divine Shield absorbs a capped amount;
		# this has no cap, and every hit he eats builds that ally's Faith.
		"Vow of Suffering":
			return Ability.make({"display_name": "Vow of Suffering", "cost": 20,
				"special": "vow_suffering", "target": Ability.Target.ALLY,
				"delay": 2.0, "cooldown": 3, "anim": "attack02",
				"perfect_id": "", "perfect_text": "",
				"description": "Take their wounds as your own: for 4\nturns HALF the damage that ally takes\nis redirected to the Devout — and\nevery share he eats kindles that ally\n1 Faith."})
		# AXIS: unspent protection becomes offence. His shields expire unspent
		# constantly; this makes over-shielding a resource.
		"Aegis Reversal":
			return Ability.make({"display_name": "Aegis Reversal", "cost": 30,
				"special": "aegis_reversal", "target": Ability.Target.ALLY,
				"delay": 2.5, "cooldown": 4, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "Spend the shield that was never spent:\nconsumes an ally's Divine Shield, and\ntheir next attack deals bonus damage\nworth half again what the shield had left."})
		# ----- OCCULTIST: what else can be corrupted -----
		# AXIS: corrupting recovery. DELIBERATELY SITUATIONAL — near-dead
		# against a warband with no healer, decisive against one with. A pool
		# needs a few cards that are excellent when the board calls for them,
		# or every pick is a safe generic.
		"Blight the Well":
			return Ability.make({"display_name": "Blight the Well",
				"dmg_type": "shadow", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 4, "anim": "attack03",
				"special": "blight_well",
				"perfect_id": "", "perfect_text": "",
				"description": "Poison the source: for 6 turns, any\nhealing that enemy receives DAMAGES\nit for the same amount instead."})
		# AXIS: corruption that compounds onto a chosen target. Spread pressure
		# becomes focused pressure without giving up the spread.
		"Covenant of Ash":
			return Ability.make({"display_name": "Covenant of Ash",
				"dmg_type": "shadow", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "covenant_ash",
				"perfect_id": "", "perfect_text": "",
				"description": "Bind one enemy to the ash: while the\nmark holds, EVERY stack of Ruin\napplied to ANY enemy also lands here.\nTwo Ruin land there as it is bound.\nOne covenant at a time."})
		# ----- BEASTMASTER: what does the partnership give you -----
		# AXIS: the two bodies acting deliberately, where the rest of his kit
		# has the beast on its own clock.
		"Twin Hunt":
			return Ability.make({"display_name": "Twin Hunt", "cost": 25,
				"damage": 40, "pressure": 12, "delay": 2.5, "cooldown": 3,
				"anim": "attack02", "special": "twin_hunt",
				"perfect_id": "", "perfect_text": "The companion's blow lands at {atk:55}",
				"description": "Strike as one: the Beastmaster and his\ncompanion each hit for 40% of Attack. If\nthe COMPANION'S blow is the killing one,\nhis next ability costs nothing."})
		# AXIS: rotation without the tax. BJ measured swaps at 0.05 per trash
		# battle — the central verb of an entire lane barely happens.
		"Call the Wilds":
			return Ability.make({"display_name": "Call the Wilds", "cost": 20,
				"special": "call_wilds", "delay": 2.0, "cooldown": 5,
				"anim": "attack01",
				"perfect_id": "", "perfect_text": "The arriving companion strikes twice",
				"description": "Whistle the pack round: call in the\nabsent companion you are most bonded with,\nkeeping its Loyalty AND paying no Swap\ncooldown — and it strikes the moment\nit arrives."})
		# ----- SHARPSHOOTER: what breaks the patience, and what pays for it -----
		# AXIS: hitting the field without breaking the bond.
		"Called Volley":
			return Ability.make({"display_name": "Called Volley", "cost": 30,
				"damage": 20, "pressure": 8, "delay": 3.0, "cooldown": 4,
				"aoe": true, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Deals {atk:26}",
				"description": "Loose on the whole line for 20% of\nAttack — and his Focus and his mark\nsurvive it untouched."})
		# AXIS: patience that accelerates. It deliberately does NOT protect
		# Focus on the marked enemy's death — Overkill already does that, and an
		# ability duplicating a row-7 talent is the Deadfall fault.
		"Quarry's Mark":
			return Ability.make({"display_name": "Quarry's Mark", "cost": 15,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 3,
				"anim": "attack01", "special": "quarrys_mark",
				"perfect_id": "", "perfect_text": "",
				"description": "Name the quarry for the rest of the\nbattle: Focus gained from attacking it\nis DOUBLED, and the mark pays 20 Focus\nat once. One mark at a time.\nSwitching away still clears him — the\nmark makes committing pay faster."})
		# ----- SURVIVALIST: what else can be worn down -----
		# AXIS: an affliction his kit does not otherwise have. Blind is an
		# EXISTING status at +50% miss — used, not re-authored. Priced against
		# that: AoE attacks never miss, so it blanks single-target attacks only.
		"Choking Smoke":
			return Ability.make({"display_name": "Choking Smoke",
				"dmg_type": "nature", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 4, "aoe": true, "anim": "attack03",
				"special": "choking_smoke",
				"perfect_id": "", "perfect_text": "",
				"description": "Foul the air: EVERY enemy is Blinded\nfor 3 turns — 50% more likely to miss.\nArea attacks never miss, so it blanks\nsingle-target blows only."})
		# AXIS: the traps stop waiting.
		"Snare Line":
			return Ability.make({"display_name": "Snare Line",
				"dmg_type": "nature", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 4, "anim": "attack03",
				"special": "snare_line",
				"perfect_id": "", "perfect_text": "",
				"description": "Run a line across the whole field: for\ntwo turns EVERY enemy that acts springs\none of your traps where it stands —\nteeth, Break and all. It fills no trap\nslot and spends no placed trap."})
		# ================= BATCH BQ: THE CLASS-WIDE TWELVE =================
		#
		# SIX MAGE AND SIX CLERIC, filling half the seam BO opened: one card in
		# four is class-wide, and until BQ that seam rolled into an empty pool
		# for every hero in the game. THE HUNTER AND WARRIOR TWELVE FOLLOW
		# BELOW (Batch BR) and the seam is closed — see `CLASS_DRAFT_POOLS`.
		#
		# THEY ARE WEAKER THAN SPEC ABILITIES AND UNCONDITIONAL, and the
		# "weaker" half was VERIFIED against the live spec kits rather than
		# assumed — every comparison is in the changelog with its arithmetic.
		# ONE OF THE TWELVE FAILS IT IN THE OTHER DIRECTION AND IS REPORTED
		# RATHER THAN RE-TUNED: see Chastise below.
		#
		# BREAK DAMAGE WAS ASSIGNED DELIBERATELY RATHER THAN BY OMISSION (the
		# correction BO made to its own predecessor, applied up front). The
		# brief names only Chastise's 20. TWO of the twelve are attacks and
		# carry BD; the other ten are not attacks, and Break from an ability
		# that never strikes is Break from nowhere.
		#
		# ----- MAGE: the tools every spine wants and no spine provides,
		# BECAUSE A SPINE THAT PROVIDED THEM WOULD STOP BEING A SPINE. The
		# Pyromancer has no defence at all by design (AR removed every option
		# deliberately), the Arcanist's went to the vault with Stabilize (AT),
		# and the Cryomancer's is a hold that a boss shrugs.
		#
		# AXIS: the floor beneath all three. ABSORPTION — it eats a share of
		# everything, area attacks included.
		"Magic Barrier":
			return Ability.make({"display_name": "Magic Barrier",
				"dmg_type": "arcane", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack03",
				"special": "magic_barrier",
				"perfect_id": "", "perfect_text": "",
				"description": "Raise a ward of raw magic: absorbs\ndamage equal to 20% of your maximum\nhealth for 3 turns. It eats a share of\nEVERYTHING, area attacks included."})
		# AXIS: evasion rather than absorption, and THE TWO MUST NOT BE A
		# STRICT UPGRADE OF EACH OTHER IN EITHER DIRECTION — §2's rule applied
		# inside one pool. Better than the Barrier against three big single
		# hits, worse against a swarm or an area attack: those roll no miss at
		# all, so they spend no image and the ward does nothing about them.
		"Mirror Image":
			return Ability.make({"display_name": "Mirror Image",
				"dmg_type": "arcane", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack03",
				"special": "mirror_image",
				"perfect_id": "", "perfect_text": "",
				"description": "Step behind four copies of yourself:\nthe next FOUR single-target attacks\nagainst you MISS outright. Area attacks\nnever miss, so they never spend one.\nThe images wait until spent."})
		# AXIS: the reliable filler. Multi-hit, so it plays with anything
		# reading HITS rather than casts, and cheap enough to cast while saving
		# for something bigger. DELIBERATELY THE LESSER of the Mage's multi-hit
		# fillers: 3 x 12% against Razor Ice's 3 x 15% and Arcane Barrage's
		# 6 x 8%, and 3 BD a bolt against their 10 and 3.
		"Magic Missiles":
			return Ability.make({"display_name": "Magic Missiles",
				"dmg_type": "arcane", "cost": 15, "damage": 12, "pressure": 3,
				"delay": 2.0, "cooldown": 2, "anim": "attack01",
				"multi_hits": 3,
				"perfect_id": "", "perfect_text": "A fourth bolt",
				"description": "Three bolts of raw force into one\nenemy, 12% of Attack each. Cheap,\ncertain, and it never needs anything\nto be true first."})
		# AXIS: a read on the fight rather than a free button. It costs Mana to
		# make Mana, so it is net-positive only if the fight lasts — and the
		# pool's own ceiling is what keeps it honest when he casts it full.
		"Mana Well":
			return Ability.make({"display_name": "Mana Well",
				"dmg_type": "arcane", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 1.5, "cooldown": 5, "anim": "attack03",
				"special": "mana_well",
				"perfect_id": "", "perfect_text": "",
				"description": "Open the well: for 4 turns your Mana\nregeneration is DOUBLED. It costs Mana\nto make Mana — a long fight pays for\nit and a short one does not."})
		# AXIS: utility nobody has. TWO HALVES, AND THE ENEMY HALF IS THIN —
		# `shielded` is the ONLY beneficial status an enemy can carry in the
		# whole game (two of nineteen kinds apply it), so that half removes at
		# most ONE thing and usually nothing. MEASURED AND REPORTED rather than
		# quietly dropped: authoring enemy buffs is a content decision and not
		# this batch's, and the ally half is a real answer on its own.
		"Dispel":
			return Ability.make({"display_name": "Dispel",
				"dmg_type": "arcane", "cost": 15, "damage": 0, "pressure": 0,
				"delay": 1.5, "cooldown": 3, "anim": "attack02",
				"special": "dispel",
				"perfect_id": "", "perfect_text": "",
				"description": "Unpick what is woven: strip THREE harmful\neffects from an ALLY, or THREE\nbeneficial ones from an ENEMY. Point it at\nwhichever side is wearing something it\nshould not be."})
		# AXIS: tempo, not damage. Worth most to whoever has the most on
		# cooldown, so it scales with KIT SIZE rather than with any spec —
		# which is the cleanest statement of "class-wide" in the pool.
		"Blink":
			return Ability.make({"display_name": "Blink",
				"dmg_type": "arcane", "cost": 10, "damage": 0, "pressure": 0,
				"delay": 1.0, "cooldown": 3, "anim": "attack03",
				"special": "blink",
				"perfect_id": "", "perfect_text": "",
				"description": "Step out of the moment and back into\nit: every one of your cooldowns loses\ntwo turns. Blink's own does not — a\nself-refunding cooldown is no cooldown\nat all."})
		# ----- CLERIC: three support-shaped spines with enormous CONDITIONAL
		# power and no baseline. NONE OF THE THREE CAN SIMPLY HEAL SOMEONE ON
		# TURN ONE: Holy's healing is gated behind Mercy, the Devout's behind
		# shields absorbing hits, the Occultist's behind marks on enemies.
		#
		# THE NAMES ARE CHOSEN FOR REGISTER. The Occultist is a Cleric, and
		# "Sanctified Ground" on him reads as a joke. These are priestly and
		# old — rites, offices, practices — words about what a cleric DOES
		# rather than which side he is on, and every one has to sit on an
		# Occultist tongue as easily as on Holy's.
		#
		# AXIS: the plain heal none of them has. DELIBERATELY THE LESSER of it
		# and Holy's Heal — 20% of the TARGET's maximum tops out at 40 on the
		# Warden's 200, against Heal's 40% of her own 150, i.e. 60, and both
		# are multiplied by the same Mercy term.
		"Ministration":
			return Ability.make({"display_name": "Ministration",
				"dmg_type": "holy", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 2, "anim": "attack02",
				"special": "ministration", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "Heals {mhp:26|ally}",
				"description": "The plain office: heal one ally for 20%\nof THEIR maximum health. No stacks, no\nshields, no marks — it simply works."})
		# AXIS: sustained rather than burst, the opposite read to Ministration.
		# Per target it is small on purpose; what it buys is that it is small
		# for EVERYONE, every turn, while it holds.
		"Consecration":
			return Ability.make({"display_name": "Consecration",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 5, "anim": "attack03",
				"special": "consecration",
				"perfect_id": "", "perfect_text": "",
				"description": "Bless the ground you all stand on: for\n4 turns the WHOLE PARTY regains 5% of\nmaximum health at the start of each of\ntheir turns."})
		# AXIS: something to do with a turn. All three Clerics have turns where
		# nobody needs healing and their engine is not ready, and the Break
		# means that turn still contributes.
		#
		# REPORTED, NOT RE-TUNED — THE ONE CARD OF THE TWELVE THAT FAILS §2 IN
		# THE OTHER DIRECTION, i.e. it is too weak to pick rather than too
		# strong. The brief names both numbers, and against them the FREE core
		# attack wins on damage for all three Cleric specs: Smite is 44% of
		# Attack with 16 BD at no cost and no cooldown, Shadowrend 25% with
		# 16 BD plus a Cripple. Chastise pays 15 Mana and a 2-turn cooldown for
		# 25% of Attack and 4 more Break, so it is DOMINATED. The lever is one
		# of its two numbers and it is the designer's, not a batch's.
		"Chastise":
			return Ability.make({"display_name": "Chastise",
				"dmg_type": "holy", "cost": 15, "damage": 25, "pressure": 20,
				"delay": 2.0, "cooldown": 2, "anim": "attack01",
				"perfect_id": "", "perfect_text": "Deals 30 Break damage",
				"description": "Rebuke one enemy: 25% of Attack as holy\ndamage and 20 Break damage. For the\nturns when nobody needs mending and the\nengine is not ready."})
		# AXIS: cleanse with a tail. A PURE cleanse is dead against a warband
		# that applies nothing, and the mitigation half is what makes it never
		# a wasted card — the unconditional rule stated as a mechanic rather
		# than as an intention.
		"Unburden":
			return Ability.make({"display_name": "Unburden",
				"dmg_type": "holy", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 1.5, "cooldown": 4, "anim": "attack02",
				"special": "unburden", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Lift the weight: remove EVERY harmful\neffect from one ally, and they take 20%\nless damage for 3 turns. With nothing\nto remove it is still the mitigation."})
		# AXIS: the only offensive party buff a Cleric has. BANKED, NOT TIMED —
		# it waits for each hero's next swing rather than expiring on a turn
		# count, so a slow hero is not cheated of it.
		"Exhortation":
			return Ability.make({"display_name": "Exhortation",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 4, "anim": "attack03",
				"special": "exhortation",
				"perfect_id": "", "perfect_text": "",
				"description": "Call them on: the WHOLE PARTY's next\nattack deals 35% more damage. It is\nBANKED, not timed — it waits for each\nhero's next swing however long they\ntake to take it."})
		# AXIS: making one heal into two. IT IS THE ONE CLASS ABILITY THAT GETS
		# BETTER THE MORE SPEC-SPECIFIC THE BUILD IS, a deliberate inversion of
		# the unconditional-floor role the other five play: Holy's big heals
		# fork, the Devout's shield-conversion trickles outward, the
		# Occultist's lifesteal spreads.
		#
		# NAME NOTE, RECORDED SO IT IS A KNOWN OVERLAP RATHER THAN A DISCOVERED
		# ONE: it sits near the Berserker's UNDYING RAGE (Fury capstone) and
		# near Holy's VIGIL lane. Different objects, no mechanical collision —
		# three uses of two words.
		#
		# NO DEATH-SAVE CLAUSE, deliberately: Holy already has three
		# (Resurrection, Intercession, Rite of Return) and a fourth in the
		# class pool would make her the only spec whose class card duplicates
		# her own identity.
		"Undying Vigil":
			return Ability.make({"display_name": "Undying Vigil",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "undying_vigil", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Keep watch over one ally: for 4 turns,\nwhenever they are healed BY ANY SOURCE,\na second ally on lower health is healed\nfor half as much."})
		# ============ BATCH BR: THE HUNTER AND WARRIOR CLASS-WIDE TWELVE ======
		#
		# THE SEAM CLOSES HERE. BQ filled Mage and Cleric; these twelve fill the
		# other two, so every hero's one-in-four class card draws a real entry
		# and no class rolls an empty pool.
		#
		# THE TWO STANDING RULES §1 SET, both recorded beside the content they
		# were set for and both applying game-wide from here on:
		#   1. CHARGES AND THE EFFECTS THAT RIDE THEM COUNT HITS, NOT CASTS.
		#      A three-shot ability spends three of Arcane Arrows' five and
		#      splashes three times. It is a real power increase for multi-hit
		#      kits and it is deliberate.
		#   2. A NAME IS SWEPT AGAINST THE WHOLE ROSTER BEFORE IT IS AUTHORED —
		#      every ability, talent node, status and rune. The Warrior recovery
		#      card was authored as SECOND WIND, which Holy already holds
		#      (tranche 1, BO), and is BATTLE TRANCE for that reason.
		#
		# BREAK DAMAGE ASSIGNED DELIBERATELY, as BO's own correction requires.
		# §4 names two figures (Aimed Volley 25, Cleave 15 each) and leaves the
		# rest to this batch. THREE of the twelve are attacks and carry BD;
		# the other nine never strike, and Break from an ability that never
		# strikes is Break from nowhere.
		#
		# ----- HUNTER: three spines that are all CONDITIONAL, and a class with
		# NO HEALING WHATSOEVER and the thinnest defensive kit in the game. The
		# Beastmaster needs a beast standing, the Sharpshooter needs to not have
		# switched, the Survivalist needs statuses already on the board — so all
		# three have opening turns where the engine is not running.
		#
		# AXIS: the only self-heal a Hunter can get. THE ONE UNCONDITIONAL
		# ANSWER TO A CLASS-WIDE HOLE — every other class can mend itself
		# somewhere; this one cannot, at all, in any of its three trees.
		"Field Dressing":
			return Ability.make({"display_name": "Field Dressing", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 3,
				"anim": "attack02", "special": "field_dressing",
				"perfect_id": "", "perfect_text": "Heals {mhp:24}",
				"description": "Bind the wound where you stand: heal\n18% of your maximum health and shake\noff one harmful effect. The only\nself-heal a Hunter can get."})
		# AXIS: buying TIME rather than absorbing damage — the defensive shape
		# the class does not have, stated as evasion so it never overlaps the
		# Mage's Barrier or the Warden's Block.
		#
		# FLAGGED, NOT SILENTLY SHIPPED: it sits close to the Survivalist's
		# GHILLIE SUIT (Guerilla row 6, 65% and permanent). The two STACK — one
		# combined roll, computed as independent chances rather than either
		# overwriting the other — and for a Survivalist already holding the node
		# this is close to a dead draw. See `_evade_chance` in battle.gd.
		"Camouflage":
			return Ability.make({"display_name": "Camouflage", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "camouflage",
				"perfect_id": "", "perfect_text": "",
				"description": "Go to ground: for 3 turns enemies are\n70% less likely to aim at you. It buys\nTIME rather than soaking damage —\nnothing about the blow changes, only\nwho it lands on."})
		# AXIS: the reliable strike. Every Hunter kit is built on a conditional
		# and this works when nothing is set up yet — and being MULTI-HIT is
		# what makes it play with a charge bank (§1) rather than beside one.
		#
		# DELIBERATELY THE LESSER of the class's multi-hit shots: 3 x 12% = 36%
		# against Triple Shot's 3 x 18% = 54%, for 10 less Mana. Its 8 BD a shot
		# is §4's 25 read as a TOTAL and split three ways — 24 across the volley,
		# level with Triple Shot's 8-a-shot rather than above it.
		"Aimed Volley":
			return Ability.make({"display_name": "Aimed Volley", "cost": 20,
				"damage": 12, "pressure": 8, "delay": 2.5, "cooldown": 3,
				"anim": "attack02", "multi_hits": 3,
				"perfect_id": "", "perfect_text": "A fourth shot",
				"description": "Three shots into one enemy, 12% of\nAttack each with 8 Break damage a\nshot. No mark, no bond, no stance —\nit works on turn one."})
		# AXIS: two statuses on one card, and nothing else at all. THE PRICE OF
		# THE BREADTH IS THAT IT IS ALL IT DOES — no damage, no Break, no third
		# status — which is what keeps it under the Survivalist's own appliers.
		"Bola":
			return Ability.make({"display_name": "Bola", "cost": 15,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 3,
				"anim": "attack01", "special": "bola",
				"perfect_id": "", "perfect_text": "",
				"description": "Whip the cord round its legs: the\ntarget is SLOWED and CRIPPLED for 4\nturns. Two afflictions, one card, and\nnot one point of damage."})
		# AXIS: focus fire made explicit — the ONLY party-wide amplifier the
		# class has. It is the enemy that is marked, so every hero and every
		# beast on the field reads it, which is what separates it from the
		# Beastmaster's MARK OF THE HUNT (that one pays HIM and his beast 25%,
		# and restores his Mana; this one pays EVERYONE 15% and nothing else).
		"Hunter's Mark":
			return Ability.make({"display_name": "Hunter's Mark", "cost": 15,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "hunters_mark",
				"perfect_id": "", "perfect_text": "",
				"description": "Call the target out: for 6 turns the\nWHOLE PARTY deals 15% more damage to\nit. One mark at a time — the point is\nthat everyone shoots the same thing."})
		# AXIS: a charge BANK, which the class has never had. BANKED, NOT TIMED
		# — the charges wait until spent, on the Interpose/`shield_charges`
		# precedent BQ used for Mirror Image, so a cast into a lull is not
		# wasted. PER §1 A THREE-SHOT ABILITY SPENDS THREE.
		"Arcane Arrows":
			return Ability.make({"display_name": "Arcane Arrows",
				"dmg_type": "arcane", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 5, "anim": "attack03",
				"special": "arcane_arrows",
				"perfect_id": "", "perfect_text": "",
				"description": "Quench six arrows in raw magic: each\nof your next six ATTACKS also strikes\nan additional random enemy for half\ndamage. They wait until spent — and a\nthree-shot volley spends three."})
		# ----- WARRIOR: three spines that are all melee, all Rage-driven and
		# all REACTIVE. The Berserker needs to be hurt, the Swordmaster needs a
		# stance and a Break window, the Warden needs to be attacked. NONE CAN
		# MAKE SOMETHING HAPPEN ON TURN ONE, and the class has no ranged option
		# and no way to reach a back line.
		#
		# ALL THREE WARRIOR SPECS USE RAGE — verified at the site rather than
		# assumed before these were priced: `resource_name` is decided ONCE in
		# `CONFIGS["warrior"]` and no spec override touches it.
		#
		# FIVE OF THE SIX CARRY NO `resource_gain`, and that was the cleanest
		# statement of §4's "weaker than spec work" a Rage class can be given:
		# every Warrior spec ability builds 10-15 Rage while it spends, and these
		# spend without building. **CHARGE IS THE EXCEPTION, by the designer's
		# reprice immediately after BR shipped — it builds 30, more than any
		# Warrior spec ability and more than the free basic's 20.** Read its own
		# comment below before touching either number.
		#
		# AXIS: recovery that scales with the beating. IT READS DAMAGE TAKEN,
		# NOT MISSING HEALTH, and that distinction IS the ability — a Warrior
		# who enters full and is hammered heals hard; one who enters low and is
		# then ignored heals the 3% floor. THE RECOVERY IS DELAYED AND THAT IS
		# WHAT KEEPS IT HONEST: he has to survive the damage before he gets any
		# of it back, so it is not mitigation and cannot save him from a
		# killing blow.
		#
		# NAME: authored as SECOND WIND, which Holy already holds (BO). Renamed
		# here rather than shipped as a duplicate — see §1's rule above.
		"Battle Trance":
			return Ability.make({"display_name": "Battle Trance", "cost": 15,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "battle_trance",
				"perfect_id": "", "perfect_text": "",
				"description": "Go somewhere the pain cannot follow:\nfor 4 turns, at the start of each of\nyour turns heal 3% of maximum health\nPLUS HALF of all damage taken since\nyour last turn."})
		# AXIS: giving away tempo. THE ONLY ABILITY IN THE GAME THAT HANDS AN
		# ALLY A TURN, and the only tempo tool a class with none can have. It
		# reuses the EXISTING initiative machinery (the Cryomancer's Shattered
		# Tempo pushes units along the timeline; this is that hook aimed the
		# other way) — there is no second turn-order manipulator.
		#
		# IT CANNOT TARGET HIM, which is what bounds it: handing away a turn
		# costs him one, so no hero can be given consecutive turns off a single
		# Warrior, and the 4-turn cooldown bounds it again.
		"Rally":
			return Ability.make({"display_name": "Rally", "cost": 15,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "rally_ally",
				"target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Shout one ally forward: they act NEXT,\njumping straight to the front of the\norder, and regain 15% of their\nresource. You gave them the turn — it\ncost you yours."})
		# AXIS: reaching something NOW. The very fast initiative is the point —
		# it is a Warrior's only answer to a caster winding up.
		#
		# REPRICED BY THE DESIGNER IMMEDIATELY AFTER BATCH BR SHIPPED, AND THE
		# ARGUMENT IT REPLACES IS RECORDED HERE RATHER THAN DELETED. The batch
		# assigned 10 BD *deliberately below the free Strike's 18* and gave the
		# card no `resource_gain` at all, on the reasoning that what a class card
		# buys is the arrival and the Daze and it must not also win on Break —
		# BQ's rule (the floor for a class ability is the FREE BASIC) applied the
		# other way round. **THE DESIGNER'S CALL OVERRULES BOTH HALVES: 20 BD and
		# 30 Rage generated.**
		#
		# WHAT THAT MAKES IT, SAID PLAINLY BECAUSE IT IS THE ONE THING A LATER
		# READER WILL WANT: Charge now beats the free Strike on damage (25% vs
		# 23%), on Break (20 vs 18), on initiative (1.0 vs 2.0) and carries a
		# Daze, while still NET-GENERATING 10 Rage (30 gained against its own 20
		# spent). Strike wins only on net Rage (+20) and on having no cooldown.
		# **It is the first class-wide card in the game that generates its
		# resource**, and the only one of the twenty-four that is not weaker than
		# the free basic on every axis. Flagged, not silently absorbed.
		"Charge":
			return Ability.make({"display_name": "Charge", "cost": 20,
				"damage": 25, "pressure": 20, "delay": 1.0, "cooldown": 3,
				"anim": "attack02", "resource_gain": 30,
				"applies_status": {"id": "dazed", "turns": 1},
				"perfect_id": "", "perfect_text": "Dazed for 2 turns",
				"description": "Close the distance before it finishes\nthe cast: 25% of Attack and 20 Break\ndamage, and the target is DAZED for a\nturn. Builds 30 Rage. Nothing else in\nthe kit arrives this fast."})
		# AXIS: breadth from a narrow class. THREE CHOSEN enemies rather than
		# three random ones, which is the whole distinction from War Stomp (a
		# Warden spec-pool entry with the same 15% and the same 15 BD, for LESS
		# Rage and with an ally refuel on top). Cleave is unambiguously the
		# lesser of the two; what it buys is that the three are picked.
		"Cleave":
			return Ability.make({"display_name": "Cleave", "cost": 25,
				"damage": 15, "pressure": 15, "delay": 2.5, "cooldown": 3,
				"anim": "attack03", "choose_three": true,
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "{atk:22}",
				"description": "One wide swing across three chosen\nenemies: 15% of Attack and 15 Break\ndamage each. The narrow class finally\nhits more than one thing."})
		# AXIS: the party buff the class lacks. NOTHING A WARRIOR DOES CURRENTLY
		# IMPROVES ANYONE ELSE'S NUMBERS.
		#
		# CORRECTED TOWARD THE CODE AND REPORTED: §3 says "gains 20% Attack".
		# It is implemented as +20% DAMAGE DEALT, on Battle Shout's own read
		# site — `attack` is a raw stat read at dozens of sites (DoT snapshots,
		# companion strikes, poison ticks) and a temporary mutation of it needs
		# a revert path, which is the shape that produced this project's
		# ~127,000 max-HP runaway. The number is identical where it is felt.
		"Warcry":
			return Ability.make({"display_name": "Warcry", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack03", "special": "warcry",
				"perfect_id": "", "perfect_text": "",
				"description": "Put the whole line on the front foot:\nevery hero deals 20% more damage for\n4 turns. The one thing a Warrior can\ndo for somebody else's numbers."})
		# AXIS: refusing to be stopped. EVERY WARRIOR SPINE DIES TO LOSING A
		# TURN — a stunned Berserker is not bleeding anyone, a Broken Warden is
		# not blocking.
		#
		# THE BREAK HALF IS A CAP, NOT AN IMMUNITY, AND IT IS DECIDED RATHER
		# THAN LEFT OPEN: while it holds, his meter fills to 99 and no further.
		# Pressure still accumulates and simply cannot cross, so the moment the
		# trance ends he is sitting one hit from Broken. That makes it a DELAY
		# rather than a negation — the enemy's three turns of Break work are
		# deferred onto the turn he stops being immune, not erased. It is NOT
		# "the meter cannot fill" and NOT "Broken is refused": both read the
		# same in a short test and neither leaves him at 99 afterwards.
		#
		# THE NAME COLLISION IS RESOLVED AT BATCH CK §2 AND THIS ABILITY IS THE
		# HALF THAT MOVED. It was called IRON WILL, which is ALSO the Warden's
		# Threat row 3 node and the live status that node's chip rides — same
		# class, same spec reachable, worse than BP's Precision Strike. Nothing
		# broke (a node's name is not an ability name and nothing resolves it),
		# but master.html's single "Iron Will" status row described the TALENT,
		# so a reader checking THIS card got the other mechanic's answer.
		# **THE TALENT KEEPS THE NAME AND KEEPS `iron_will`.** This one took the
		# name its own status has always carried: `ironclad`. NO NEW WORD ENTERED
		# THE GAME — the rename made the card agree with the code rather than the
		# other way round, and the `special` moved with it so that no `iron_will`
		# string anywhere in the codebase belongs to this ability any more.
		#
		# NOT THE berserk/berserk_risk PATTERN, AND MUST NOT BE READ AS ONE. That
		# pair and formless/formless_recoil share a label DELIBERATELY — each is
		# the upside and the price of ONE ability, separated by chip tag and
		# colour. This was two unrelated mechanics that collided.
		"Ironclad":
			return Ability.make({"display_name": "Ironclad", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "ironclad",
				"perfect_id": "", "perfect_text": "",
				"description": "Set your teeth: for 4 turns you cannot\nbe Stunned, Frozen, Dazed or Broken,\nand take 15% less damage. The Break\nstill piles up to 99 — it just cannot\ncross until this ends."})
		# ========== BATCH BT: TRANCHE 2, THE MAGE NINE ==========
		#
		# THE SYNERGY RULE STARTS HERE AND IS STANDING FROM THIS TRANCHE ON.
		# Tranche 1 asked what GAP an ability filled, which was the right
		# question against an empty pool. With five per spec the question
		# becomes whether a BUILD can be assembled, so every entry below names
		# what it combos with — which talent node, which other card, which
		# capstone. A CARD THAT APPEARS IN NOBODY'S BUILD PLAN IS A CARD THAT
		# FILLS A SLOT, and the named combo is what a later batch checks a new
		# ability against.
		#
		# ----- PYROMANCER: hold the bank, multiply it, cash it for something
		# else. THE SPINE AFTER BATCH BS IS DEFERRED DAMAGE — he is weak until
		# he cashes in, and with the drain deleted holding fire no longer costs
		# Mana. What it costs is TURNS. These three are the three things a bank
		# can do: keep it, deepen it, or spend it on something other than
		# damage.
		#
		# AXIS: time, bought. Every payoff he owns reads a bank that is
		# shrinking under him and nothing in his kit could ever slow it.
		# SYNERGY: Powder Keg (Detonation row 8) banks 30% of each Detonation
		# into the next, Sea of Flame (Kindling row 8) pays +7% fire damage per
		# burning enemy, and Cataclysm eats the whole field — all three want the
		# field lit LONGER. Strongest immediately after Firestorm, which lays
		# 12-16 burn-turns in one cast.
		"Slow Burn":
			return Ability.make({"display_name": "Slow Burn", "dmg_type": "fire",
				"cost": 15, "damage": 0, "pressure": 0, "delay": 1.5,
				"cooldown": 4, "anim": "attack03", "special": "slow_burn",
				"perfect_id": "", "perfect_text": "",
				"description": "Bank the fire: for 4 turns the Burn on\nEVERY enemy stops counting down. It\nstill burns for its full damage — it\njust never gets shorter.\nThe mark rides enemies not yet alight,\nso fire laid inside the window holds too."})
		# AXIS: the bank multiplies instead of growing. Backdraft ADDS turns and
		# Ember Debt LAYS them; this one doubles what is already there, so it is
		# worth exactly as much as the stack he built and nothing on an empty one.
		# SYNERGY: Detonation pays 250% of the bank's remaining damage (325%
		# with Focused Flame), so doubling a deep stack is the largest single
		# swing available to him. Pairs directly with SLOW BURN — stall, double,
		# detonate — and with Cinder Trail's 4-turn Fireball. Total Commitment
		# consumes from the target AND its two neighbours, so a doubled centre
		# pays three ways.
		"Stoke":
			return Ability.make({"display_name": "Stoke", "dmg_type": "fire",
				"cost": 20, "damage": 25, "pressure": 8, "delay": 2.0,
				"cooldown": 3, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Burn turns TRIPLED",
				"description": "Feed the coals: 25% of Attack, and if\nthe target is Burning its remaining\nBurn turns are DOUBLED. Nothing extra\nagainst an enemy that is not alight.\nOverburn reads the field BEFORE the\ndoubling — later casts collect on it."})
		# AXIS: fire converted into survival rather than into damage — the only
		# card in his kit that does it, and the Inferno build's cash-in where
		# Detonation is the Detonation build's.
		# SYNERGY: BATCH BS turned the whole Inferno lane into mitigation (Ember
		# Shroud, Ashen Skin, Heat Haze, Immolate, Kiln-Forged, Ash Lung, Forge
		# Body), and every one of those is a PERCENTAGE — a shield is the flat
		# term that lane never gets. Overburn's refund pays 1 Mana per turn
		# consumed (2 with Crucible), so a deep stack cashed here is a shield
		# AND a pool.
		"Funeral Pyre":
			return Ability.make({"display_name": "Funeral Pyre", "dmg_type": "fire",
				"cost": 25, "damage": 0, "pressure": 0, "delay": 2.5,
				"cooldown": 4, "anim": "attack02", "special": "funeral_pyre",
				"perfect_id": "", "perfect_text": "",
				"description": "Put the fire out and wear it: consume\nALL Burn on one enemy and gain a\nshield worth 200% of the damage that\nBurn would still have dealt (3 turns).\nOverburn refunds every turn consumed."})
		# ----- CRYOMANCER: get a hold, pay before the hold, survive without
		# one. HIS POOL'S TWO EXISTING CARDS BOTH ASSUME HE ALREADY HOLDS
		# SOMETHING — Winter's Toll collects interest on a hold, Rimebinding
		# copies one — so against a boss, which resists Frozen until Broken,
		# both are dead cards for most of the fight.
		#
		# AXIS: the hold WITHOUT the build, on a card rather than a bought cell.
		# SYNERGY: Cold Snap (Deep Freeze row 6) fills a held enemy's Break
		# meter 15 a turn, so a boss frozen once tends to stay freezable, and
		# Second Prison (row 5) makes a second hold worth having. Expensive and
		# slow on purpose — THE EMERGENCY, NOT THE OPENER.
		#
		# REPORTED, NOT RE-TUNED: on every number this is a strictly worse
		# GLACIAL PRISON (Deep Freeze row 4 — 25 Mana, 2.5, 4cd for the same
		# outright freeze). The distinction is the ACQUISITION CHANNEL, which is
		# real: the node is a bought cell in ONE lane of ONE tree, so a Winter or
		# Thaw Cryomancer can never have it, while this is drafted by any of
		# them. Its PERFECT is what keeps it from being dominated outright — see
		# `_hold_freeze`'s `force` argument, which no node buys.
		"Flash Freeze":
			return Ability.make({"display_name": "Flash Freeze", "dmg_type": "frost",
				"cost": 30, "damage": 0, "pressure": 0, "delay": 3.0,
				"cooldown": 5, "anim": "attack03", "special": "flash_freeze",
				"perfect_id": "", "perfect_text": "",
				"description": "Seal it now: the target is Frozen\noutright whatever its Chilled stacks,\nand joins the Glacial Hold.\nThe ice takes even an UNBROKEN boss —\nbut a held boss shrugs it off after ONE\nturn. That turn is what this buys\nagainst one; it is not a lockdown."})
		# AXIS: the accumulation pays on its own. His stacks currently do
		# nothing but count toward a freeze, so a fight where the freeze never
		# lands is a fight where his build did nothing.
		# SYNERGY: it feeds Hypothermia (+3% damage taken per stack), Frigid
		# Grip (10% harder slow per stack), Winter's Depth (-8% Constitution per
		# stack, so they Break sooner) and Bitter Cold. Best after Blizzard or
		# Eternal Winter, which spread thin stacks wide — this is what turns
		# that spread into damage and depth.
		#
		# NAME COLLISION, REPORTED NOT RESOLVED (the BR §1 rule): KILLING FROST
		# is also a Cryomancer talent node (`cr_freezing`, Thaw row 2, "+15
		# points on the held-enemy window"). SAME SPEC, so a Cryomancer holding
		# the node can draft the card — what used to be called the Iron Will
		# shape, and BATCH CK §2 RESOLVED THAT ONE (the ability is Ironclad now),
		# so this is the last card-vs-node collision left in the game. It is a
		# LABEL collision only: a node's name is not an ability name and nothing
		# resolves it, the node's counter is `killing_frost` and the card's
		# handler is a `special`, and the two touch no shared field. What made
		# Iron Will worth renaming and leaves this one alone is that Iron Will's
		# two mechanics did not resemble each other and master.html documented
		# only the talent; these two both make a held enemy colder.
		"Killing Frost":
			return Ability.make({"display_name": "Killing Frost", "dmg_type": "frost",
				"cost": 20, "damage": 20, "pressure": 6, "delay": 2.0,
				"cooldown": 3, "aoe": true, "anim": "attack03",
				"special": "killing_frost",
				"perfect_id": "", "perfect_text": "3 stacks of Chilled each",
				"description": "Drive the cold home: every CHILLED\nenemy takes 20% of Attack and gains 2\nmore stacks of Chilled. Enemies that\nare not Chilled are untouched — and\nfour stacks still put one in the ice."})
		# AXIS: stacks built without spending a turn applying them, and the only
		# defence in his kit that a boss cannot shrug (his other one is a hold).
		# SYNERGY: Frigid Grip and Winter's Depth make every stack both a slow
		# and a step toward Broken, so the retaliation is an engine rather than
		# a deterrent; Splintering Shards makes Razor Ice always land its fourth
		# hit against the pile this builds.
		#
		# ADJACENCY, REPORTED: `hoarfrost` is also a severity-1 BATTLE MODIFIER
		# (Run.MODIFIERS — "everyone starts Chilled") and part of the Rune of
		# Hoarfrost Points, a class:hunter rune. Neither is an ability and
		# neither shares a name with this one; the status this card applies is
		# `rimeguard` precisely so the two chips can never read the same word.
		"Hoarfrost Armor":
			return Ability.make({"display_name": "Hoarfrost Armor", "dmg_type": "frost",
				"cost": 20, "damage": 0, "pressure": 0, "delay": 2.0,
				"cooldown": 4, "anim": "attack01", "special": "hoarfrost_armor",
				"perfect_id": "", "perfect_text": "",
				"description": "Wear the winter: for 4 turns you take\n25% less damage, and anything that\nstrikes you gains 2 stacks of Chilled.\nThey build the pile by hitting you."})
		# ----- ARCANIST: the first thing in the DRAFT that spends. Every node
		# and every drafted card he owns READS Resonance; the only spender he
		# has ever had is STABILIZE, which is a boss-pool pick and vents the
		# meter to a floor of 2 for Mana and a ward. So his decision has been
		# "cast whatever builds fastest", which is not a decision.
		#
		# AXIS: cash the curve, or keep climbing. At 6 stacks it is 90% of
		# Attack for a cost he barely notices; at 16 it is 240% and he falls
		# to 8. IT HALVES RATHER THAN VENTING TO A FLOOR, which is the whole
		# distinction from Stabilize: the curve keeps compounding from where it
		# lands instead of restarting, so spending is a decision about slope
		# rather than an abandonment of the ramp.
		# SYNERGY: Cascade (+1 build per cast at 10+ stacks), Harmonics and
		# Critical Mass all make the climb back cheaper, so a Resonance-lane
		# build can spend and re-ramp. The ENTROPY lane cares twice — halving
		# the stacks also halves the compounding DAMAGE-TAKEN penalty, so it is
		# an escape hatch that costs him his damage rather than a free one.
		"Arcane Bolt":
			return Ability.make({"display_name": "Arcane Bolt", "dmg_type": "arcane",
				"cost": 30, "damage": 15, "pressure": 8, "delay": 2.5,
				"cooldown": 4, "anim": "attack02",
				"perfect_id": "", "perfect_text": "{atk:20} per stack",
				"description": "Spend the storm: 15% of Attack for\nEVERY Resonance stack you hold, then\nyour stacks are HALVED.\nThe curve keeps compounding from where\nit lands — this is a change of slope,\nnot a reset."})
		# AXIS: the ramp's opening move, and its panic button, in one card.
		# SYNERGY: the opening cast in a four-enemy fight, and the panic button
		# late — below half health it pays double exactly when the compounding
		# damage-TAKEN penalty is killing him. On the Edge (Entropy row 2:
		# surviving below 35% builds 4) and Backlash (Resonance builds when he
		# takes damage) mean an ENTROPY build gets paid three ways for being
		# nearly dead.
		"Inner Arcane":
			return Ability.make({"display_name": "Inner Arcane", "dmg_type": "arcane",
				"cost": 15, "damage": 0, "pressure": 0, "delay": 1.0,
				"cooldown": 3, "anim": "attack01", "special": "inner_arcane",
				"perfect_id": "", "perfect_text": "",
				"description": "Gather it in: bank Resonance equal to\nthe number of enemies still ALIVE, plus\none —\nDOUBLED while you are below half\nhealth. Widest on turn one, and worth\nmost when you are nearly dead."})
		# AXIS: the only reason he has to focus one target. Worthless early (30%
		# of a small number) and enormous once the passive is paying +117%,
		# BECAUSE THE ECHO CARRIES HIS FULL MULTIPLIER — it reads the damage the
		# hit actually dealt rather than re-deriving from a nominal number.
		# SYNERGY: sits beside Temporal Rift (a crit echoes 40% at a RANDOM
		# enemy), Barrage Master (+3 bolts) and Suppressing Fire (each Barrage
		# bolt harder than the last). Per BR §1 THE ECHO COUNTS HITS: a
		# three-bolt Barrage echoes three times, which is what makes the
		# multi-hit nodes the ones to build with it.
		"Arcane Echo":
			return Ability.make({"display_name": "Arcane Echo", "dmg_type": "arcane",
				"cost": 25, "damage": 20, "pressure": 6, "delay": 2.0,
				"cooldown": 4, "anim": "attack03",
				"perfect_id": "", "perfect_text": "The echo holds a 4th turn",
				"description": "Set a resonance in one enemy: 20% of\nAttack, and for 3 turns every damaging\nHIT you land anywhere repeats at 30%\nagainst this target.\nA three-bolt Barrage echoes THREE\ntimes. One mark at a time."})
		# ========== BATCH CB: TRANCHE 3, THE MAGE NINE ==========
		#
		# THE MAGE POOLS GO 5 -> 8 AND THE MAGE BECOMES THE FIRST CLASS COMPLETE.
		# The Cleric, Hunter and Warrior thirds of tranche 3 are owed after this.
		#
		# ----- PYROMANCER: consolidate it, scatter it, and make it ARRIVE
		# BIGGER. His whole pool moves fire that already exists — Cinderfall
		# skims it, Stoke doubles one stack, Funeral Pyre spends it, Ember Debt
		# places it — and NOTHING in it changes how much arrives. Two of these
		# three are still bank moves (a consolidation and a scattering, the two
		# directions nothing covered); the third is the multiplier on GETTING
		# fire, which the pool has never had.
		#
		# AXIS: the bank CONSOLIDATED. Detonation pays 250% of ONE enemy's
		# remaining Burn (325% with Focused Flame), so a field of shallow fires
		# is worth far less than one deep one — and until now the only way to
		# build a deep stack was to keep casting at the same body.
		# SYNERGY: TOTAL COMMITMENT (Detonation consumes from the target AND its
		# two neighbours), POWDER KEG (Detonation banks 30% into the next) and
		# CATACLYSM. It is the deliberate counterpart to CINDERFALL, which
		# spreads the spend where this concentrates it.
		#
		# RENAMED FROM BACKDRAFT, AND THE BRIEF'S PREMISE WAS STALE — §1 asked
		# for it to be confirmed and it does not hold. BACKDRAFT IS STILL LIVE:
		# it is the Pyromancer's OWN Kindling row-4 node `py_melt`, which both
		# carries that name AND grants an ability whose `display_name` is
		# "Backdraft" (20 Mana, 2.0, 3cd — +2 turns of Burn to every burning
		# enemy). BS renamed the INFERNO row-5 node to Backblast to dodge exactly
		# this collision and left the Kindling node standing.
		# `Classes.pool_ability` is keyed on `display_name`, so a second
		# Backdraft would make the resolver answer the wrong question — an
		# ABILITY-vs-ABILITY duplicate, which BR §1 calls a REAL BREAK to be
		# RENAMED rather than a label collision to be flagged. FIREDRAW is swept
		# clean against every ability, talent node, status and rune.
		"Firedraw":
			return Ability.make({"display_name": "Firedraw", "dmg_type": "fire",
				"cost": 25, "damage": 0, "pressure": 0, "delay": 2.5,
				"cooldown": 4, "anim": "attack03", "special": "firedraw",
				"perfect_id": "", "perfect_text": "",
				"description": "Pull the field's fire into one body:\nconsume 6 turns of Burn from every\nOTHER enemy and add all of it here.\nIt takes what is there or 6, whichever\nis less, and never touches this\nenemy's own Burn."})
		# AXIS: the bank SCATTERED rather than cashed. A twelve-turn stack
		# becomes twelve small fires and 96% of Attack spread across the board —
		# the only card in the game that converts DEPTH into WIDTH.
		# SYNERGY: SEA OF FLAME (+7% fire damage per burning enemy) wants the
		# field wide and nothing else he owns widens it; feeds SLOW BURN
		# (scatter, then stop the tick-down); and it is the natural answer when
		# the deep target is about to die anyway and the bank would die with it.
		# Overburn's refund pays 1 Mana per turn consumed (2 with Crucible)
		# through the SAME door Detonation and Funeral Pyre use — there is no
		# second one.
		"Pyre Wake":
			return Ability.make({"display_name": "Pyre Wake", "dmg_type": "fire",
				"cost": 25, "damage": 8, "pressure": 0, "delay": 2.5,
				"cooldown": 4, "anim": "attack02", "special": "pyre_wake",
				"perfect_id": "", "perfect_text": "Each fire {atk:12}",
				"description": "Scatter the pyre: consume ALL of one\nenemy's Burn. For EVERY turn consumed,\na random enemy is set Burning 1 turn\nand takes 8% of Attack.\nOverburn refunds every turn consumed."})
		# AXIS: THE MULTIPLIER ON GETTING FIRE, not on moving it — and it is the
		# thing the pool most obviously lacks, because everything else in it is
		# downstream of already having a bank.
		# SYNERGY: FLAMEWAVE lays 4 turns on everyone instead of 2. FIRESTORM's
		# 6-8 bolts each land 4 instead of 2 — 24 to 32 burn-turns from ONE cast.
		# Then SLOW BURN freezes the tick-down and Detonation pays 250% of it. It
		# also doubles CINDER TRAIL (Fireball 4 -> 8) and CONFLAGRATION.
		#
		# IT DOUBLES AT APPLICATION AND IS NOT RETROACTIVE. Fire already standing
		# on the board is untouched — that is STOKE's job, and the two must not
		# collapse into each other (the Deadfall/Snare Trap duplication BD found,
		# avoided up front rather than discovered later). The implementation is
		# ONE clause at `_apply_status`'s `eff_turns` block, scoped to the SRC
		# exactly as Permafrost is, so an enemy Ashblade's burn and a rune's burn
		# are both correctly untouched.
		"Emberkeep":
			return Ability.make({"display_name": "Emberkeep", "dmg_type": "fire",
				"cost": 20, "damage": 0, "pressure": 0, "delay": 1.5,
				"cooldown": 4, "anim": "attack01", "special": "emberkeep",
				"perfect_id": "", "perfect_text": "",
				"description": "Keep the embers: for 4 turns every\nBurn YOU apply lands at DOUBLE\nduration.\nIt changes what ARRIVES, not what is\nalready burning — fire already on the\nboard is untouched."})
		# ----- CRYOMANCER: copy wide, hit the prisoner, chain two bodies. His
		# pool assumes a hold and acts on ONE enemy, and his control has always
		# been one enemy at a time.
		#
		# AXIS: the hold as a TEMPLATE, applied wide. Rimebinding copies it to
		# one; this copies it to all.
		# SYNERGY: BITTER COLD, WHITEOUT and ETERNAL WINTER all widen, and this
		# is the card that makes a deep prison pay for the whole field. Sets up
		# KILLING FROST, which pays every Chilled enemy.
		"Deep Winter":
			return Ability.make({"display_name": "Deep Winter", "dmg_type": "frost",
				"cost": 25, "damage": 0, "pressure": 0, "delay": 2.5,
				"cooldown": 4, "anim": "attack03", "special": "deep_winter",
				"perfect_id": "", "perfect_text": "",
				"description": "Spread the prison thin: every enemy\ngains Chilled equal to HALF the stacks\non the enemy you hold, rounded UP.\nHOLDING NOTHING, IT DOES NOTHING —\nthe prison is the template."})
		# AXIS: hitting the prisoner WITHOUT opening the cell. The hold is a
		# party-wide +15% damage window that only he can close, and until now
		# nothing of his own could safely strike into it — ICE LANCE IS THE
		# RELEASE, so his best blow against a held enemy ends the hold.
		# SYNERGY: BRITTLE ICE (held enemies are 6% likelier to be crit),
		# WINTER'S TOLL (collects on the hold without releasing it, the same rule
		# from the other side) and KILLING FROST.
		#
		# IT CARRIES NO `special`, THE BV FIVE-OF-NINE PATTERN, AND THAT IS
		# DELIBERATE: `_resolve` sends any ability holding a `special` down
		# `_resolve_special`, which means hand-rolling the blow and losing crits,
		# armor, resists, Break and the parry roll with it. This is an ORDINARY
		# strike with one conditional multiplier, so it keys on `display_name` at
		# the raw-damage block instead and keeps the whole pipeline.
		#
		# VERIFIED AGAINST ICE LANCE AND IT DOES NOT OUTCLASS IT — the arithmetic
		# is in the CB block in CLAUDE.md. Against a Frozen target the Lance
		# lands 55% of Attack and ALWAYS crits (110%+) for 15 BD; this lands 50%
		# at ordinary crit odds for 6 BD. It is cheaper (20 vs 25) and faster
		# (2.0 vs 3.0) on a LONGER cooldown (3 vs 2), and the distinction it is
		# sold on is that it does not open the cell.
		"Cold Iron":
			return Ability.make({"display_name": "Cold Iron", "dmg_type": "frost",
				"cost": 20, "damage": 25, "pressure": 6, "delay": 2.0,
				"cooldown": 3, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Deals {atk:35}",
				"description": "Strike the prisoner: 25% of Attack.\nAgainst a FROZEN target it deals\nDOUBLE — and it does NOT release the\nhold, so the ice and the damage window\nboth stand."})
		# AXIS: TWO PRISONERS ON ONE CHAIN. It does not grant another hold — it
		# gives him a second body that SUFFERS WITH THE FIRST, so everything he
		# does to one happens twice.
		# SYNERGY: KILLING FROST hits both, RIMEBINDING's copied stacks
		# immediately double, RAZOR ICE's three stacks become six across two
		# enemies, WINTER'S TOLL collects on one while the other bleeds. And if
		# both partners reach the freeze threshold THE PAIR FREEZES TOGETHER,
		# which is how a one-hold Cryomancer comes to hold two.
		#
		# THE SECOND TARGET IS A CLICK, AND THE BRIEF'S CONDITIONAL WAS FALSE:
		# §3 said to use a most-Chilled rule "if nothing selects two enemies
		# today". `Ability.choose_two` HAS EXISTED SINCE SHRAPNEL CHARGE and Hex
		# of Ruin uses `choose_three` beside it, so the UI answer already shipped
		# and the player picks both bodies. §3's rule is kept where it actually
		# bites — as the FALLBACK when no second target was chosen, which is the
		# BOT's path (autoplay skips the clicks) and the one-enemy-left path.
		# Without it `_resolve`'s generic fallback picks a RANDOM partner, and a
		# bond is not a card anyone wants aimed at random.
		"Frostbind":
			return Ability.make({"display_name": "Frostbind", "dmg_type": "frost",
				"cost": 25, "damage": 0, "pressure": 0, "delay": 2.5,
				"cooldown": 4, "anim": "attack03", "special": "frostbind",
				"choose_two": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Chain two enemies together for 4 turns:\nChilled landing on either lands on\nboth, and damage dealt to one is dealt\nto the other at 40%.\nThe mirrored blow does NOT mirror back.\nIf both reach the threshold, the pair\nfreezes together."})
		# ----- ARCANIST: share the curve, buy it early, make it unanswerable.
		# EVERYTHING HE HAS IS HIS OWN CURVE — nothing shares it, nothing changes
		# its shape, and nothing gets past what a boss's armor and healing do to
		# it.
		#
		# AXIS: the curve ARMS THE PARTY. This is the cross-spec card the pool
		# does not have — at 12 stacks he is at +117%, so allies get +58%:
		# enormous, brief, and it makes a deep Arcanist a party buff rather than
		# a solo act.
		# SYNERGY: SINGULARITY doubles the build rate, so a capstone build shares
		# a far bigger number; CASCADE and CRITICAL MASS get him deep faster; and
		# it pairs with the whole ENTROPY lane — the same stacks killing him now
		# pay three other people.
		#
		# IT READS HIS BONUS LIVE, NOT AT CAST — the status carries no number at
		# all, which is NULL FIELD's own rule and for the same reason: stamping
		# the value here would freeze it at cast time and delete the card's whole
		# axis. If he keeps building during the window the allies' share climbs
		# with him, which is the escalation being SHARED rather than a snapshot
		# being handed out.
		"Resonant Field":
			return Ability.make({"display_name": "Resonant Field", "dmg_type": "arcane",
				"cost": 25, "damage": 0, "pressure": 0, "delay": 2.0,
				"cooldown": 4, "anim": "attack01", "special": "resonant_field",
				"perfect_id": "", "perfect_text": "",
				"description": "Tune the party to the storm: for 4\nturns every ALLY deals bonus damage\nequal to HALF your current Resonance\nbonus.\nIt reads the meter LIVE — keep\nbuilding and their share climbs too."})
		# AXIS: the late game bought early, at the cost of the ramp. Below 15 it
		# is a huge jump; above 15 it is a nerf he would never take — so it
		# RESCUES A SLOW START and becomes dead weight in a long fight, which is
		# the right shape for an escalation spec's emergency.
		# SYNERGY: DEATH RAY gates at 8 and TERMINAL VELOCITY clears its cooldown
		# at 15, so this reaches both instantly; NULL FIELD at 15 stacks is 75%
		# mitigation.
		#
		# THE DAMAGE-TAKEN PENALTY ARRIVES WITH THE STACKS — the curve is read
		# live at the strike-target block and knows nothing about how the meter
		# got there — so it is genuinely dangerous rather than free: 15 stacks is
		# +90% damage taken on the spot.
		#
		# FLAGGED: 15 IS THE NUMBER THE DESIGNER TRUSTS LEAST IN THIS BATCH. Too
		# low and it is never worth casting, too high and it skips the spine.
		# SHIPPED TO BE WATCHED IN PLAY; DO NOT PRE-TUNE IT.
		"Threshold":
			return Ability.make({"display_name": "Threshold", "dmg_type": "arcane",
				"cost": 20, "damage": 0, "pressure": 0, "delay": 1.5,
				"cooldown": 5, "anim": "attack01", "special": "threshold",
				"perfect_id": "", "perfect_text": "",
				"description": "Skip the climb: your Resonance is SET\nto 15 at once, and you cannot gain any\nmore for 2 turns.\nThe damage-taken penalty arrives with\nthe stacks. Above 15 it takes them\nAWAY — this is an emergency, not an\nopener."})
		# AXIS: the curve made UNANSWERABLE. His scaling damage is still checked
		# by armor, resists and enemy healing, and a boss has all three. At 16
		# stacks this is 160% of Attack THROUGH EVERYTHING, and the heal lock
		# holds while the rest of the party finishes.
		# SYNERGY: ARCANE ECHO repeats it at 30% PER HIT; TERMINAL VELOCITY. It
		# answers the same warband problem BLIGHT THE WELL does from the
		# Occultist's side, so a party holding both locks a healer out entirely.
		#
		# IT CARRIES NO `special` (the BV pattern again): it needs crits, Break,
		# the parry roll and the compounding Resonance multiplier, so it rides
		# the ordinary strike and keys on `display_name` at FOUR rider sites —
		# the raw block (10% per stack), the resist block, the armor block and
		# the post-strike block that lays the lock.
		#
		# ITS BREAK IS FLAT RATHER THAN PER-STACK, DELIBERATELY, which is ARCANE
		# BOLT's own rule: a per-stack Break term is Arcane Cannon's and Magi's
		# Wrath's axis, and duplicating it here is the squaring trap AT exists
		# around, arriving through the Break door.
		#
		# REPORTED, NOT RE-TUNED — §4 ASKED FOR THIS COMPARISON AND THE ANSWER IS
		# NOT THE COMFORTABLE ONE. Death Ray is 150% of Attack flat, so the
		# crossover is EXACTLY 15 STACKS (10 x 15 = 150) and above it Unmaking
		# deals MORE raw damage for 25 less Mana and 2.0 less delay. THRESHOLD,
		# one card above, SETS HIM TO EXACTLY 15. See the CB block in CLAUDE.md.
		"Unmaking":
			return Ability.make({"display_name": "Unmaking", "dmg_type": "arcane",
				"cost": 30, "damage": 10, "pressure": 8, "delay": 3.0,
				"cooldown": 5, "anim": "attack02",
				"perfect_id": "", "perfect_text": "The heal lock holds a 4th turn",
				"description": "Undo it: 10% of Attack for EVERY\nResonance stack you hold. Its\nresistances and its armor are IGNORED,\nand it cannot be healed for 3 turns.\nAt 16 stacks that is 160% of Attack\nthrough everything."})
		# ========== BATCH BU: TRANCHE 2, THE CLERIC NINE ==========
		#
		# ----- HOLY: what else can be reversed. Her pool was Second Wind (undo
		# recent damage) and Rite of Return (prevent a death) — BOTH REACTIVE
		# AND BOTH DEFENSIVE. She had no offence at all, and Mercy was a meter
		# she waited for rather than one she controlled. These three are a third
		# reversal, a way to MAKE Mercy, and her first weapon.
		#
		# AXIS: reversal of expenditure, the one form of undoing she does not
		# have. It is the tranche's cross-spec card — its whole value is
		# measured on somebody else's sheet, and it reads Rage, Mana and Focus
		# alike: a Pyromancer who just emptied himself into Detonation, an
		# Arcanist halved by Arcane Bolt, a Berserker out of Rage before Gut Rip.
		#
		# SECOND CORRECTION TOWARD THE CODE: the brief says it reads "Rage, Mana
		# and Focus alike". THERE ARE ONLY TWO PRIMARY RESOURCES IN THE GAME —
		# `resource_name` is Rage for the Warrior and Mana for the other three
		# classes, decided once in `Classes.CONFIGS` with no spec override. FOCUS
		# IS A SECOND RESOURCE (Batch AZ), i.e. a spec meter, so it falls under
		# the rule below rather than beside Rage and Mana. The card's own text
		# says so.
		#
		# THE PRIMARY RESOURCE ONLY, AND THAT IS A RULE RATHER THAN AN
		# OVERSIGHT. Spec meters — Resonance, Mercy, Faith, Focus's converted
		# half — are not resources in this sense: they are earned curves, and
		# handing an Arcanist his curve back for 25 Mana would make one card
		# worth more than the passive it feeds.
		#
		# CORRECTION TOWARD THE CODE, RECORDED RATHER THAN GLOSSED: the brief
		# says nothing in the game restores another hero's resource. THREE
		# THINGS ALREADY DO — War Stomp refuels every ally 10% (20% perfect),
		# Cold Storage (Cryomancer, Deep Freeze row 8) drips the party a share
		# per held prison, and Rally's PERFECT hands its target 15%. What is
		# true is the smaller, more useful claim: nothing is a DEEP,
		# SINGLE-TARGET restore, and nothing exists whose entire payload is the
		# restore. At 30% of one ally's maximum this is three times War Stomp's
		# share aimed at the hero who actually needs it.
		# SYNERGY: it is the only card in the game that reads as a different
		# ability in every party. Beside the Pyromancer it is a second
		# Detonation; beside the Arcanist it buys back the Mana Arcane Bolt
		# spent; beside a Berserker it is 30 Rage toward Gut Rip. On her own
		# sheet it pairs with HEAVENLY AURA and SANCTIFIED, which make every
		# Mercy stack she is not spending on it worth more.
		"Recant":
			return Ability.make({"display_name": "Recant",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "recant", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Unspend it: one ally regains 40% of\ntheir MAXIMUM Rage or Mana.\nIt reaches the resource they cast\nwith — never a spec meter like\nResonance, Mercy, Faith or Focus."})
		# AXIS: martyrdom as an economy. Mercy arrives when somebody crosses
		# below half health, so until now the only way to fill her meter was to
		# let the party be hurt. This is her buying a stack with her own blood,
		# on turn one, at a moment she chooses.
		#
		# A FLAT 3 RATHER THAN A SCALING COUNT, DELIBERATELY. The first draft
		# paid per wounded ally, which in any real fight is her whole meter for
		# one cast — and a meter that fills itself is not a meter.
		#
		# IT MUST NEVER KILL HER: 25% of MAXIMUM, floored at 1 health.
		# SYNERGY: it is the switch that starts her engine on turn one.
		# HEAVENLY AURA pays +12% healing per stack held, ARDOR stops Empower
		# consuming a stack at 3+ (so this single cast turns Ardor ON), MARTYR'S
		# VIGOR raises the ceiling to 8, and SANCTIFIED gives every spend a 35%
		# chance to cost nothing. Without those it is expensive; with them it is
		# the first button she presses.
		"Shared Grief":
			return Ability.make({"display_name": "Shared Grief",
				"dmg_type": "holy", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "hurt",
				"special": "shared_grief",
				"perfect_id": "", "perfect_text": "",
				"description": "Take the wound yourself: lose 25% of\nyour MAXIMUM health and gain 4 Mercy.\nIt can never take you below 1.\nThe grief is the price — the Mercy is\nyours to spend at once."})
		# AXIS: her healing becomes a weapon. This is her ONLY offence and the
		# answer to the turn where nobody is hurt — the turn a healer has
		# nothing to do is the turn she has done her job.
		#
		# IT READS HEALING LANDED, NOT HEALING ATTEMPTED, and that is the clause
		# that would most easily be got wrong. Overheal does not count, or
		# SANCTUM's 60% spill would pay twice: once as the overheal it came from
		# and again as the heal it becomes.
		# SYNERGY: everything that raises her throughput raises this, which is
		# what makes it the Radiance lane's payoff card — TRIAGE (+30% on
		# instant heals), HEAVENLY AURA (+12% per Mercy stack), SANCTUM (the
		# overheal spill) and RADIANT CASCADE (a share of every heal to a second
		# ally) all feed the same two-turn window this reads.
		"Reprisal":
			return Ability.make({"display_name": "Reprisal",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 6,
				"delay": 2.5, "cooldown": 3, "anim": "attack01",
				"special": "reprisal",
				"perfect_id": "", "perfect_text": "75% of the healing",
				"description": "Answer for them: deal holy damage\nequal to 50% of the healing you have\nLANDED in the last two turns.\nOverhealing is not healing — only what\nactually closed a wound counts."})
		# ----- DEVOUT: what else can he place. His pool was Vow of Suffering
		# and Aegis Reversal — BOTH ACT ON SHIELDS ALREADY OUT. He could not put
		# Faith on anyone directly, and nothing in the game read `faith_peak`
		# except the held-value multiplier BI wrote.
		#
		# AXIS: starting the engine without waiting to be hit. Every Faith
		# source he owns is reactive (an absorb) or slow (the ground's drip);
		# this is the one that simply grants it.
		#
		# THE LOWEST-FAITH TARGETING IS A DESIGN DECISION AND MUST NOT BECOME
		# PLAYER-CHOSEN. It points the card at the ally COMMUNION CANNOT REACH —
		# Communion rolls at (15 x their own stacks)%, so the ally on zero is
		# the one it never touches — and it wastes nothing: `faith_stacks` caps
		# at five, so three granted to an ally already on four throws two away.
		# Aiming at the floor makes the grant worth its full three every time.
		#
		# CORRECTION TOWARD THE CODE, RECORDED RATHER THAN GLOSSED: the brief
		# justifies this with an Apostle release loop — grant 3 to an ally at 4,
		# they release, Apostle leaves them at 5, and every later gain releases
		# again. THAT LOOP CANNOT HAPPEN AND HAS NOT SINCE BATCH BG. Apostle was
		# taken off the release axis there (it is a HELD-value multiplier now)
		# and Binding Oath's remnant went at BH, so `_gain_faith` resets an
		# ally's count to ZERO on every release with no survivor at all. The
		# targeting rule is right; its stated reason was two batches stale.
		# SYNERGY: BLESSED ARE THE FAITHFUL makes the release it walks an ally
		# toward heal 35% of their maximum; COMMUNION spreads on that release,
		# and this feeds it the one ally it cannot roll for; RELIQUARY below
		# cashes the peak this raises. BINDING OATH pays HIM a stack every time
		# an ally releases, so a card that manufactures releases manufactures
		# his own held mitigation too.
		"Ordination":
			return Ability.make({"display_name": "Ordination",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "ordination",
				"perfect_id": "", "perfect_text": "",
				"description": "Ordain the least of them: grant 4 Faith\nto the ally holding the LEAST.\nIt always finds the floor — never the\nally who is nearly there — so no stack\nis ever wasted over the cap of five."})
		# AXIS: lending the number his whole kit is built on. Divine Shield
		# absorbs 30% of HIS maximum, Afterglow heals 20% of it, Healing Pulse
		# ticks 8% of it — every one of those spends the figure. THIS IS THE
		# FIRST THING THAT LENDS THE FIGURE ITSELF, and it stacks with a shield
		# rather than duplicating one: a shield is a bucket that empties, this
		# is a bigger bucket.
		#
		# THE DECAY IS THE INTERESTING HALF AND IT IS BUILT TO BE FELT. Current
		# health clamps under the shrinking maximum, so an ally kept topped up
		# loses real health each turn while an ally at half never notices it.
		# It rewards healing them INSIDE the window rather than after it.
		# SYNERGY: UNWAVERING FAITH (+20% his maximum) makes every point of it
		# larger, and so does CONVICTION's own growth as the fight runs.
		# Strongest laid on the ally a WARDEN is already covering, and
		# strongest of all with HEALING PULSE and CONSECRATED GROUND up, because
		# both tick a share into the window before it closes.
		"Fortified Spirit":
			return Ability.make({"display_name": "Fortified Spirit",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "fortified_spirit", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "Opens at {mhp:40}",
				"description": "Lend one ally your own bulk: their\nmaximum health rises by 30% of YOURS\nand they are healed for the same.\nThe loan DECAYS 10 points a turn over\n3 turns — health clamps under it, so\nheal them while it holds."})
		# AXIS: cashing an accumulation nothing else reads. `faith_peak` is the
		# high-water mark BI introduced so the held half of Faith would stop
		# fighting the release; it ratchets and never falls inside a battle, so
		# this grows all fight and pays most to whoever has CARRIED the most
		# faith rather than whoever happens to hold it now.
		#
		# 2.5% PER POINT, NOT 5%. At a peak of five that is 12.5% of the
		# tankiest hero in the party's maximum to EVERY ally — a real party heal
		# without being a second Hymn of Hope.
		# SYNERGY: UNWAVERING FAITH (+20% his maximum) and CONVICTION's growth
		# both enlarge every point of it, and ORDINATION above raises the very
		# peaks it reads. It reads PEAK, not current, so an ally who released
		# down to zero is still paid in full for what they carried — which is
		# the whole reason BI introduced the field.
		"Reliquary":
			return Ability.make({"display_name": "Reliquary",
				"dmg_type": "holy", "cost": 30, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 5, "anim": "attack03",
				"special": "reliquary",
				"perfect_id": "", "perfect_text": "3.5% per point",
				"description": "Open the reliquary: every ally is healed\nfor 2.5% of YOUR maximum health per\npoint of their PEAK Faith this battle.\nThe peak never falls — an ally who\nreleased down to zero is still paid for\nwhat they carried."})
		# ----- OCCULTIST: what else can be done to a mark. His pool was Blight
		# the Well and Covenant of Ash — BOTH ABOUT WHERE CORRUPTION LANDS. The
		# mark itself was a number and nothing but a number: everything read its
		# depth, nothing moved it, fed it or traded it.
		#
		# AXIS: corruption that works on the enemy's clock rather than on his.
		# One cast buys 8 stacks without another turn spent, which is the only
		# generation in his kit that does not need his attention. Best on a
		# boss, which is exactly where his tenth-stack threshold lives.
		#
		# THE 100% HEAL DOES NOT ROUTE THROUGH THE RUIN LIFESTEAL, which is
		# capped at 40% of the damage dealt whatever the stacks. Different
		# mechanism, different door — if they shared one this would silently pay
		# 40% and nothing would complain. The heal is ON CAST, off the cast's
		# own damage, never per tick.
		# SYNERGY: ENTROPY (Ruin bearers take 20 Break at their turn start) and
		# the per-stack lifesteal both scale with depth, and DEEPER HEX makes
		# each of those 8 stacks +5% damage taken rather than +2%. Cast early on
		# the body the party will still be hitting in four turns.
		"Suffering":
			return Ability.make({"display_name": "Suffering",
				"dmg_type": "shadow", "cost": 25, "damage": 20, "pressure": 8,
				"delay": 2.5, "cooldown": 4, "anim": "attack01",
				"special": "suffering",
				"perfect_id": "", "perfect_text": "3 Ruin a turn",
				"description": "Open a wound that thinks: 20% of Attack,\nand you are healed for ALL of the damage\nit deals.\nFor 4 turns the enemy gains 2 Ruin at\nthe start of each of ITS turns — eight\nstacks bought with one turn of yours."})
		# AXIS: corruption relocated rather than spent. His worst case is a deep
		# mark on something about to die — twelve stacks of work wasted when the
		# party finishes it. This carries the pile to the boss instead.
		#
		# IT FIRES NO DETONATION AND NO CONSUME PAYOFF IN TRANSIT, on
		# CRYOCLASM's precedent exactly: a move is not a gain, so it does not go
		# through `_gain_ruin` and the threshold cannot arm on stacks that were
		# already earned once.
		# SYNERGY: UNRAVELING (a detonation seeds 4 Ruin in every OTHER enemy)
		# spreads the mark wide and this pulls it back to a point, which is the
		# pairing the card exists for. Beside COVENANT OF ASH the same round
		# trip runs twice. And it is what makes AVATAR OF RUIN's threshold of 5
		# reachable on a boss in a fight that started on trash.
		"Transference":
			return Ability.make({"display_name": "Transference",
				"dmg_type": "shadow", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 3, "anim": "attack02",
				"special": "transference",
				"perfect_id": "", "perfect_text": "",
				"description": "Move the whole mark: EVERY Ruin stack on\nthe deepest-marked other enemy travels\nto this one, and 2 more join them.\nNothing detonates on the way — the\nstacks arrive as the work they already\nwere."})
		# AXIS: the party marks for him. Ruin is his alone; three other heroes
		# swing every turn and contribute nothing to the meter that IS his
		# entire spec. This is the tranche's other cross-spec card and the
		# largest generation increase available to him.
		#
		# ALLY APPLICATIONS COUNT HITS (BR §1), so a three-hit ability applies
		# THREE. The description says so outright because a player will assume
		# per cast.
		#
		# FLAGGED AS POSSIBLY THE STRONGEST CARD IN THE TRANCHE AND SHIPPED TO
		# BE WATCHED RATHER THAN PRE-TUNED. AY §8 had to DOUBLE Ruin generation
		# because trash detonations measured 0.00; four heroes marking instead
		# of one for three turns could overshoot the other way. The designer has
		# taken that call knowingly.
		# SYNERGY: it feeds ENTROPY, the party-wide per-stack lifesteal and
		# NECROSIS (+35% damage from ALL sources on a Ruined target) — so it
		# makes every hero's damage larger, not only his. Cast it before the
		# party's own burst rather than after, and pair it with SUFFERING above
		# so the enemy's clock and the party's both feed one pile.
		"Anointing":
			return Ability.make({"display_name": "Anointing",
				"dmg_type": "shadow", "cost": 30, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 5, "anim": "attack03",
				"special": "anointing",
				"perfect_id": "", "perfect_text": "",
				"description": "Anoint their blades: for 4 turns EVERY\nally's attacks apply 1 Ruin.\nIt counts HITS, not casts — a three-hit\nability applies three."})
		# ========== BATCH BV: TRANCHE 2, THE HUNTER NINE ==========
		#
		# FIVE OF THE NINE CARRY NO `special` AT ALL, AND THAT IS A DECISION
		# RATHER THAN AN OMISSION — the BT ARCANE BOLT pattern. `_resolve` sends
		# ANY ability holding a `special` down `_resolve_special`, which means
		# hand-rolling the blow and losing the whole attack pipeline with it:
		# crits, armor, resists, Break, the parry roll, the Focus engine and
		# every talent rider that reads a strike. Crossfire is defined by a CRIT,
		# Calibrating Shot and Trophy Shot are defined by the FOCUS ENGINE, Hunt
		# scales the raw damage, and Loaded Shot rides a landed hit — all five
		# NEED that pipeline, so they key on `display_name` at the ordinary rider
		# sites instead. The four that genuinely do nothing but their own effect
		# (Bloodbond, Savage Sweep, Ghostpack, Preparation) keep a `special`.
		#
		# ----- BEASTMASTER: the partnership protected, widened, and paid back.
		# His pool was Twin Hunt and Call the Wilds — BOTH ABOUT THE COMPANION
		# STRIKING. Nothing protected it, and Loyalty (uncapped, measured
		# reaching 50) DIES WITH IT. These three guard the investment, make it
		# wide, and pay out the rotation the Pack lane spends itself buying.
		#
		# WHAT "HIS COMPANION" RESOLVES TO UNDER THE PACK — DECIDED HERE RATHER
		# THAN BY WHICHEVER `beasts[0]` THE FILE REACHES FIRST, and the general
		# rule is worth more than either card: AN ORDERED ACTION GOES TO ONE
		# COMPANION; THE PASSIVE STRIKE-ALONGSIDE GOES TO ALL OF THEM. The
		# alongside-strike already loops `for cs_b in pack_now` and must, because
		# that is what The Pack's own text promises. An ordered action must not,
		# or the capstone silently doubles every card that names the beast.
		# · BLOODBOND is the exception that proves it: it names no companion at
		#   all. The guard is placed on the BOND, so under The Pack it covers
		#   BOTH and is spent by whichever one first takes a killing blow.
		# · SAVAGE SWEEP picks the HIGHEST-LOYALTY standing companion — The
		#   Pack's own rule ("the deeper bond always keeps its place") read the
		#   other way round, and it puts the 3 Loyalty where the boon curve
		#   compounds hardest. Three strikes whether one companion stands or two.
		# CLOSED IN BATCH BX §3 — TWIN HUNT PICKS THE HIGHEST-LOYALTY COMPANION
		# TOO. BV reported it picking `beasts[0]` by list order and BW left it
		# alone (its tranche changed no existing ability); BX pointed it at the
		# same rule. There is ONE implementation now, `battle._deepest_bond`,
		# shared by both cards — a rule written twice eventually disagrees with
		# itself, which is exactly what happened here across two batches.
		#
		# AXIS: protecting the single largest investment in the game. At 50
		# Loyalty a companion's death is the worst thing that happens to him, and
		# he has no answer at all today. IT IS A PLACED GUARD, NOT A WINDOW —
		# no duration, so it is never wasted on a turn nothing threatened the
		# beast, and it holds until it fires.
		#
		# THE REDIRECTED HALF STILL HITS HIM AND CAN KILL HIM, and the
		# description says so outright. A guard that cannot cost anything is not
		# a decision, it is a free stat.
		# SYNERGY: ANCIENT PACT makes the companion unhealable BY ANY SOURCE, so
		# nothing else in the game can save it — Bloodbond is the only answer a
		# Pact build has. WILD COMMUNION (+12% strike damage per Loyalty stack)
		# and ABSOLUTE DEVOTION (the +35% step) are what make a deep bond worth
		# bleeding for, and STEADFAST BOND softens the meter's loss if it ever
		# does die. It is the card that lets the devotion lane commit.
		"Bloodbond":
			return Ability.make({"display_name": "Bloodbond", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 4,
				"anim": "attack01", "special": "bloodbond",
				"perfect_id": "", "perfect_text": "",
				"description": "Swear the bond: the next blow that\nwould fell your companion is REFUSED,\nand you take a QUARTER of it instead.\nIt waits until it is needed — and the\nquarter you take can kill you."})
		# AXIS: the partnership made wide. Every companion in the game is
		# single-target and nothing in his kit changes that, so a Beastmaster
		# facing four bodies watches his best damage go into one of them.
		#
		# LOWEST-HEALTH TARGETING, NOT RANDOM, AND THAT IS THE CARD. It is a
		# finisher; a random spread would make it a worse Cinderfall and put it
		# straight into BD §4's "strictly better version of another" bin from the
		# wrong end. It reuses `_lowest_hp`, the same answer Overkill's carry and
		# the beast's own retarget already give.
		# SYNERGY: HERALD (an arriving beast's effects strike two additional
		# targets) and FERAL MOMENTUM (+25% companion damage per different
		# companion summoned) both pay per body hit, so this is the card that
		# gives them three at once. Beside TWIN HUNT from tranche 1 it is the
		# other half of a two-card burst — Twin Hunt for one target, this for the
		# field — and BESTIAL WRATH sharpens all three blows at 1.5x on the wolf.
		"Savage Sweep":
			return Ability.make({"display_name": "Savage Sweep", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.5, "cooldown": 4,
				"anim": "attack02", "special": "savage_sweep",
				"perfect_id": "", "perfect_text": "5 Loyalty",
				"description": "Loose the pack down the line: your\ncompanion strikes the THREE lowest-\nhealth enemies, and gains 3 Loyalty.\nUnder The Pack the deeper bond runs."})
		# AXIS: what rotating actually buys. FERAL MOMENTUM and MENAGERIE both
		# already reward having cycled, but both are small passive trickles; this
		# is the Pack build's PAYOFF, and it is deliberately near-worthless to a
		# Lone Bond build, which fields one companion and never swaps.
		#
		# EVERY KIND HE HAS SUMMONED THIS BATTLE, STANDING OR NOT — decided
		# rather than inferred, because the two readings differ by a third of the
		# card. Excluding the ones currently standing would make the ability get
		# SMALLER the moment a beast arrived, which is the opposite of what a
		# Pack payoff should feel like; a rotator who has fielded all three gets
		# three ghosts every attack whatever is on the board. Lone Bond gets one.
		# IT REUSES `kinds_summoned` (the ledger AY already keeps for Feral
		# Momentum and Menagerie) rather than writing a second one, and it rides
		# `_ghost_hit`, WHICH CREDITS THE HUNTER — BB §4 fixed exactly that site
		# after AY found it booking nothing, and a second uncredited striker
		# would undo the repair.
		# SYNERGY: WILD ROTATION, NO BEAST LEFT, SHARED DEVOTION and INSTINCTIVE
		# ROTATION all exist to make cycling cheap; this is what cycling PAYS.
		# HERALD makes each arrival wider on the way in. It stacks with the
		# GHOST PACK node rather than replacing it — see the changelog.
		"Ghostpack":
			return Ability.make({"display_name": "Ghostpack", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.5, "cooldown": 5,
				"anim": "attack03", "special": "ghostpack",
				"perfect_id": "", "perfect_text": "",
				"description": "Call the whole pack, living and lost:\nfor 4 turns EVERY companion you have\nsummoned this battle strikes alongside\nyour attacks for 40% — including the\nones no longer standing."})
		# ----- SHARPSHOOTER: the multiplier half, the finish, and the field.
		# His pool was Called Volley and Quarry's Mark — BOTH ABOUT GENERATING
		# AND KEEPING FOCUS. Nothing read the half PAST 100, where Focus stops
		# buying crit chance and starts buying crit MULTIPLIER without a ceiling.
		#
		# AXIS: the crit build goes wide. Past 100 Focus his multiplier climbs
		# without limit, so at x3.5 a single crit is already a field event — the
		# deeper his patience, the wider it hits. It is the one card that turns
		# the uncapped half of his meter into board presence rather than a bigger
		# number on one body.
		#
		# ANTI-SYNERGY WITH CONSISTENT AIM, DELIBERATELY AND NAMED: that node
		# trades multiplier for chance, so a Consistent build wants a different
		# card. That is what makes this a BUILD DECISION rather than a strict
		# pick, which is the whole subject of BT's synergy rule.
		# SYNERGY: EXECUTIONER'S EYE (x2.5) and TUNNEL VISION (+100% crit chance
		# on the enemy he has been working) make the crits reliable;
		# FOLLOW-THROUGH (crits cut all cooldowns), RAPID FIRE and SECOND NATURE
		# all multiply how many crits land inside the window. TROPHY SHOT below
		# is its setup card — carry 200 Focus into a fresh enemy with the splash
		# still live.
		"Crossfire":
			return Ability.make({"display_name": "Crossfire", "cost": 25,
				"damage": 30, "pressure": 10, "delay": 2.5, "cooldown": 4,
				"anim": "attack02",
				"perfect_id": "", "perfect_text": "Holds a 4th turn",
				"description": "Set the crossfire: 30% of Attack, and\nfor 3 turns every CRITICAL hit you\nland also strikes 2 other enemies for\n40% of that crit's damage."})
		# AXIS: patience rewarded for finishing what he started. A fresh enemy
		# pays nothing; one at 20% health pays 8 Focus on top of the ordinary
		# gain — so it accelerates hardest exactly when the target is about to
		# die and clear his meter.
		#
		# IT READS MISSING HEALTH, WHICH IS THE CLAUSE THAT WOULD MOST EASILY BE
		# GOT WRONG: against a full-health target it pays literally nothing, and
		# that zero is the design rather than a failure to fire.
		# SYNERGY: COUP DE GRÂCE reads missing health too and caps its reading at
		# 200 Focus, so this feeds the card that spends it. OVERKILL, MUSCLE
		# MEMORY and UNWAVERING all stack on top of the ordinary gain this
		# arrives beside, and QUARRY'S MARK from tranche 1 doubles that half.
		"Calibrating Shot":
			return Ability.make({"display_name": "Calibrating Shot", "cost": 20,
				"damage": 20, "pressure": 8, "delay": 1.5, "cooldown": 3,
				"anim": "attack01",
				"perfect_id": "", "perfect_text": "15% of missing health",
				"description": "Range them as you fire: 20% of Attack,\nand you gain Focus equal to 10% of\nthe target's MISSING health.\nA fresh enemy pays nothing."})
		# AXIS: the kill stops costing him. A target dying is the most common
		# event in a fight and it drops him to 50 retained — so the spec whose
		# entire engine is a meter is punished by the thing it is trying to do.
		# THIS IS THE ONLY CARD THAT MAKES FINISHING A KILL GOOD FOR THE METER
		# rather than the event that resets it.
		#
		# THE CLAUSE IS KILL-ONLY. If it does not kill it is an ordinary 35%
		# strike and the ordinary switch rules apply, and the description says
		# so — a conditional card that reads unconditional is a tooltip lying.
		# SYNERGY: OVERKILL already keeps Focus whole on a kill-CHAIN carry, so
		# this is its single-target cousin; holding both means the excess damage
		# carries AND the meter survives. BONECRACKER (+40% vs Broken) and
		# EXPOSED NERVE help it land the kill in the first place. It is the setup
		# card for CROSSFIRE above.
		"Trophy Shot":
			return Ability.make({"display_name": "Trophy Shot", "cost": 25,
				"damage": 35, "pressure": 12, "delay": 2.5, "cooldown": 4,
				"anim": "attack02",
				"perfect_id": "", "perfect_text": "Deals {atk:45}",
				"description": "Take the trophy: 35% of Attack. If\nthis KILLS the target your Focus is\nnot reduced at all and carries whole\nto the next enemy you attack.\nIf it does not kill, it is just a shot."})
		# ----- SURVIVALIST: hold the breadth, cash the breadth, buy a turn.
		# His pool was Choking Smoke and Snare Line — BOTH WIDE, BOTH ONE-SHOT.
		# His engine is breadth and BREADTH DECAYS: Cripple runs out while he is
		# applying Slow, and the count Trapper pays him for quietly shrinks.
		#
		# AXIS: craft as maintenance, on a turn he would have been attacking
		# anyway. Every other answer to decay costs him a whole cast re-applying
		# one status; this refreshes the entire board and still deals damage.
		#
		# TO FULL ORIGINAL DURATION, INCLUDING THE UNCLEANSABLE ONES. It reads
		# the `full_turns` ledger `add_status` keeps rather than a table of
		# defaults, because a talent that lengthened a status lengthened its full
		# value too — and it can only ever LENGTHEN: a re-applied Burn whose
		# running timer already exceeds its original is left alone.
		# SYNERGY: SLOW ACTING (halved tick, doubled duration, uncleansable) and
		# PERFECTED TOXIN both extend; this refreshes all of it at once. CREEPING
		# DEATH already refreshes the poison whenever any status lands — this
		# generalises that node to every affliction on the body. It is what makes
		# CHOKING SMOKE and SNARE LINE, which apply wide and then run down, worth
		# building around, and it holds the count HUNT below is paid on.
		"Loaded Shot":
			return Ability.make({"display_name": "Loaded Shot",
				"dmg_type": "nature", "cost": 20, "damage": 20, "pressure": 8,
				"delay": 2.0, "cooldown": 4, "anim": "attack01",
				"perfect_id": "", "perfect_text": "Also lands 2 turns of Poison",
				"description": "Reload with the good powder: 20% of\nAttack, and EVERY harmful effect on\nthe target has its duration reset to\nfull — the uncleansable ones too."})
		# AXIS: the count made into a weapon. It reads how many DIFFERENT
		# afflictions stand on the body and nothing else — at four statuses 60%
		# of Attack, at six 90%. The Survivalist's passive has always paid for
		# breadth; this is the first thing that lets him SPEND it.
		#
		# DISTINCT EFFECTS, NEVER STACKS. It shares `_status_count` with
		# Trapper's own +8%-per-status term, so the card and the passive can
		# never disagree about what breadth is — five stacks of Poison is one
		# affliction to both of them.
		# SYNERGY: VULTURE (+60% against 3+ afflictions) and FORCE OF NATURE
		# (Trapper's bonus rises to +20% AND applies to the whole party) read the
		# same quantity, so a breadth build is paid three times on one cast. Its
		# maintenance card is LOADED SHOT above, and PREPARATION below is what
		# buys the extra turn a wide board costs to arm.
		"Hunt":
			return Ability.make({"display_name": "Hunt",
				"dmg_type": "nature", "cost": 25, "damage": 15, "pressure": 10,
				"delay": 2.5, "cooldown": 4, "anim": "attack02",
				"perfect_id": "", "perfect_text": "{atk:20} per affliction",
				"description": "Run the quarry down: 15% of Attack for\nevery DIFFERENT harmful effect on the\ntarget. Stacks do not count twice —\nfive Poison stacks are one affliction."})
		# AXIS: AN EXTRA ACTION IS EXTRA BREADTH, for a spec where every status
		# costs a whole cast. It is the first extra-turn mechanic in the game.
		#
		# THREE RULES, DECIDED HERE RATHER THAN BY WHICHEVER BRANCH THE CODE
		# FALLS INTO — all three are in CLAUDE.md and asserted in test_batch_bv:
		# · THE EXTRA TURN IS A FULL TURN AND IT RE-TICKS HIS STATUSES. It is a
		#   normal trip through the initiative loop, so his DoTs bite, his buffs
		#   shorten and his cooldowns tick. Simpler, legible, and the cost is
		#   real without being punishing — ENEMY statuses tick on ENEMY turns, so
		#   the board he just armed is untouched.
		# · IT MUST NOT CHAIN. Casting Preparation ON the extra turn to earn
		#   another is the loop, so the cast is REFUSED while one is pending.
		#   That refusal is load-bearing, not a nicety.
		# · THE DELAY IS WHAT MAKES IT A SETUP CARD rather than "take two turns
		#   now" — cast it, spend the next turn arming something, then
		#   immediately capitalise.
		# SYNERGY: everything of his that costs a turn — COATED BLADES,
		# DISTILLATE, trap placement, DEADFALL NETWORK's three slots. HIT AND RUN
		# grants Elusive whenever he applies a status, so an extra turn is an
		# extra Elusive. And it is the direct setup for LOADED SHOT and HUNT
		# above: refresh the board, then swing at the count.
		"Preparation":
			return Ability.make({"display_name": "Preparation", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack01", "special": "preparation",
				"perfect_id": "", "perfect_text": "",
				"description": "Ready everything: after your NEXT turn\nyou immediately take ANOTHER one.\nIt is a full turn — your own statuses\ntick again, and it refunds 15 Mana.\nOnly one may be pending."})
		# ========== BATCH CE: TRANCHE 3, THE CLERIC NINE ==========
		#
		# A CONTIGUOUS BLOCK, like CB's and unlike BW's — but the AXIS/SYNERGY
		# check still anchors PER ABILITY, because a shared header must not be
		# able to satisfy all nine at once.
		#
		# ----- HOLY: three cards against the three things Mercy cannot do.
		# HER POOL COMPETES FOR THREE SLOTS, THE TIGHTEST IN THE GAME: her core
		# takes FOUR of the seven (Batch AV gave her Resurrection on purpose),
		# so eight cards fight over three. Every one of these has to earn its
		# place against a stiffer bar than any other spec's.
		#
		# THE GAP ALL THREE ARE AUTHORED AGAINST: MERCY IS ENTIRELY REACTIVE.
		# She gains a stack only when an ally crosses below half health, so her
		# engine is fuelled by the party taking damage — she can play perfectly
		# and be starved. Three consequences, one card each: she cannot MAKE a
		# stack, the CAP wastes what she over-earns, and every Empowered cast
		# TRADES the skill-check bonus for the surge.
		#
		# AXIS: Mercy on her own terms. It pays her on exactly the turns the
		# passive did not, which is what makes it impossible to be simply better
		# than waiting: THE TWO SOURCES ARE MUTUALLY EXCLUSIVE BY CONSTRUCTION.
		# A fall breaks the watch and the passive pays instead; no fall and the
		# watch pays. It can never double up and it can never be nothing on a
		# quiet fight, which is the fight the passive leaves her empty in.
		#
		# BATCH CG §1 — IT PAYS IN TWOS, EVERY SECOND TURN, AND THE SHAPE IS THE
		# POINT RATHER THAN THE RATE. Two Mercy arriving at once CAN OVERFLOW THE
		# CAP, which is the first time two of her own draft cards feed each other:
		# the spill lands in ALMS rather than being thrown away. A drip of one a
		# turn could only ever reach the ceiling one stack at a time and had
		# nothing to hand on.
		#
		# FLAGGED, NOT TUNED: 4 turns on a 4-turn cooldown is 100% UPTIME, where
		# the 3-turn version ran at 75%. Left as the designer chose it; it is a
		# playtest question rather than a batch's.
		#
		# FLAGGED — A LABEL COLLISION THIS BATCH CREATES, ON HER OWN SHEET.
		# `hl_presence` is a HOLY TALENT NODE already named "Divine Presence"
		# (Vigil row 2, the end-of-turn drip to the most wounded ally), so a
		# player building Holy meets both names. Per BR §1 that is a LABEL
		# collision and not a break — a node's name is not an ability name,
		# nothing resolves it, and the two carry different fields
		# (`divine_presence_pct` against this card's `divine_presence` special) —
		# so it SHIPS AS SPECIFIED AND IS RECORDED. It is closer than BP's
		# Precision Strike / Precision Strikes (same spec, and an exact match
		# rather than a plural), and renaming either is one string.
		# SYNERGY: HEAVENLY AURA (+12% healing per stack HELD) is what makes a
		# stack worth carrying rather than spending, so a quiet fight becomes a
		# throughput fight; ARDOR stops Empower consuming a stack at 3+, and
		# three quiet turns is exactly what turns Ardor on; MARTYR'S VIGOR
		# raises the ceiling this can climb to. Beside ALMS below it is the
		# whole answer to the cap: one card fills the meter on the quiet turns
		# and the other catches what will not fit.
		"Divine Presence":
			return Ability.make({"display_name": "Divine Presence",
				"dmg_type": "holy", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack03",
				"special": "divine_presence",
				"perfect_id": "", "perfect_text": "",
				"description": "Keep the watch: for 6 turns, gain 2\nMercy at the start of every SECOND\nturn of yours on which NO ally fell\nbelow the window. A fall pays the\npassive instead and breaks that watch."})
		# AXIS: the overflow. Mercy caps at 5 and a bad fight over-earns it; the
		# excess is simply gone. This is the sixth stack going somewhere.
		#
		# A WARD RATHER THAN A HEAL, AND THAT IS THE WHOLE DISTINCTION FROM
		# GRACE (Mercy row 5), which already turns a wasted stack into healing
		# for the ally who earned it. Two effects, one trigger, DIFFERENT
		# SHEETS: Grace pays health that a full bar throws away, this pays a
		# barrier that a full bar keeps. They STACK on the same spill rather
		# than replacing each other, which is what stops this being a strictly
		# better Grace wearing a draft card's clothes (BD §4).
		# SYNERGY: GRACE above all, for that reason. MARTYR'S VIGOR raises the
		# cap and so makes the spill RARER — a real anti-synergy, and the
		# correct one: the two answer the same problem from opposite ends.
		# BLESSED VESTMENTS wards on every heal she lands, so a party wearing
		# both is wearing two layers; and it is at its best in exactly the
		# fights HEAVENLY AURA wants, where she is holding rather than spending.
		"Alms":
			return Ability.make({"display_name": "Alms",
				"dmg_type": "holy", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "alms",
				"perfect_id": "", "perfect_text": "",
				"description": "Give away what will not fit: for 6\nturns, every stack of Mercy earned at\nthe CAP instead wards the ally who\nearned it, absorbing 12% of your\nmaximum health."})
		# AXIS: the crossing itself. Her engine is fuelled by allies falling
		# below the window, and every other card of hers is about what to do
		# once one has. This is the one that REFUSES the fall — and it is the
		# only place in her pool where helping an ally starves her own engine.
		#
		# THE LAST CLAUSE IS THE WHOLE CARD AND IS NOT AN EDGE CASE: IF THE ALLY
		# DOES NOT CROSS, SHE EARNS NO MERCY FOR A CROSSING THAT NEVER HAPPENED.
		# It is not a rule written anywhere — it falls out of the absorb landing
		# ABOVE `_check_below_half`, so the generator simply never fires. The
		# guard reads `mercy_threshold` rather than a literal half FOR THAT
		# REASON: GUARDIAN ANGEL moves the Mercy line to 65%, and a ward reading
		# a different line from the generator would make the trade it is sold on
		# false in exactly the build that cares most.
		#
		# ONE-SHOT, NOT A BUCKET. It waits until the blow arrives ("or until it
		# fires"), so a fight in which nobody is threatened does not waste it —
		# and one that never comes costs her only the turn.
		# SYNERGY: GUARDIAN ANGEL widens the window it watches, so it catches
		# the blow earlier and on more of the party's health bar; INTERCESSION
		# and MARTYRDOM answer the LETHAL blow where this answers the one
		# before it, so a party holding all three has three separate nets;
		# UNWAVERING FAITH and any max-health node enlarge the absorb, which is
		# a share of HER bulk rather than the ally's. The deliberate
		# ANTI-SYNERGY is with her own engine — with ALMS and with DIVINE
		# PRESENCE's overflow above, both of which want the crossings this
		# refuses.
		#
		# BATCH CG §1 — IT REPLACES OBSERVANCE IN THIS SLOT, AND THE EMPOWER
		# CARD IS GONE RATHER THAN RETIRED: the "an Empowered cast keeps its
		# perfect bonus for a second Mercy" rule went with it, so an Empowered
		# cast forfeits its perfect exactly as it did before Batch CE.
		"Vespers":
			return Ability.make({"display_name": "Vespers",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack03",
				"special": "vespers", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Say the evening office over them: for 6\nturns, or until it fires, the next blow\nthat would take that ally below half\nhealth is absorbed for 20% of YOUR\nmaximum. No crossing, no Mercy."})
		# ----- DEVOUT: two cards against the asymmetry nobody had exploited,
		# and one shield. FAITH IS PAID ON THE HIGHEST COUNT HELD THIS BATTLE
		# (`faith_peak`, Batch BI), so an early spike is worth exactly as much
		# as a long grind and lasts the whole fight — and both his builders are
		# slow drips (2 a shielded hit, 1 an ally turn on the ground). NOTHING
		# LET HIM BUY ONE. Second gap: his own Faith HOLDS and never releases
		# (BH §2), so the release payout does not exist for him at all.
		#
		# AXIS: buying the meter outright. Both of his builders are slow drips —
		# 2 a shielded hit, 1 an ally turn on the ground — and nothing in the
		# game let him hand a stack over. This is a whole party's worth at once.
		#
		# BATCH CG §2 — IT GRANTS REAL FAITH NOW, NOT A HIGH-WATER MARK. The
		# peak-floor version wrote `faith_peak` and never `faith_stacks`, so the
		# party was paid for a count it never carried and nobody was ever walked
		# toward a release. Two stacks on the bar go through `_gain_faith`, THE
		# ONE DOOR, which is what makes the consequence below real rather than
		# guarded against.
		#
		# AN ALLY ALREADY HOLDING 3 OR MORE REACHES THE CAP AND RELEASES —
		# healed 15% of maximum, the count reset, the Devout paid 3% of his
		# Mana. THAT IS CORRECT AND INTENDED rather than an edge case to gate
		# out: the peak is untouched by a release (BI §1), so a release costs
		# the ally nothing it was holding and the card is pure upside on a
		# party that has been building.
		# SYNERGY: APOSTLE and FERVOR are multipliers on the held half, so both
		# multiply everything this buys; RELIQUARY reads the peaks these stacks
		# ratchet on their way up and pays 2.5% of his maximum per point;
		# UNWAVERING FAITH enlarges the figure both of those are shares of; and
		# BINDING OATH swears him a stack of his own on every release this
		# triggers, so a party at three turns one cast into four payouts.
		"Elevation":
			return Ability.make({"display_name": "Elevation",
				"dmg_type": "holy", "cost": 35, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 5, "anim": "attack03",
				"special": "elevation",
				"perfect_id": "", "perfect_text": "",
				"description": "Raise them up: every ally gains 3\nstacks of Faith.\nAn ally already holding 3 crosses the\ncap and RELEASES on the spot — and\ntheir peak does not fall for it."})
		# AXIS: the payout that does not exist for him. An ally's fifth stack
		# heals them 15% and hands him Mana; HIS count holds at five and never
		# releases, so his Faith pools and buys him nothing beyond the peak it
		# already ratcheted. This is the card that finally spends it.
		#
		# IT IS NOT A RELEASE AND MUST NEVER BECOME ONE. BH §2 took the Devout
		# off the release branch because a releasing Devout puts the FREQUENCY
		# LOOP straight back — his release would heal, grow the principal and
		# roll Communion, which feeds further releases. So this pays its own
		# payout at its own site: no `_conviction_growth`, no Communion roll, no
		# Binding Oath, and it does NOT go through `_gain_faith`.
		#
		# GATED AT THREE, AND THE GATE IS WHAT STOPS IT BEING A SPAM HEAL.
		#
		# BATCH CG §2 — AND IT NOW COSTS THE PEAK. Spending his Faith DROPS HIS
		# HIGH-WATER MARK TO MATCH, which is the point of the change: as CE
		# shipped it he kept the peak, so the payout was free and the only thing
		# the card ever cost was a count that bought him nothing anyway. Now it
		# is burst sustain bought with permanent mitigation and damage for the
		# rest of the fight — 2% mitigation and +1.5% damage a point, multiplied
		# by Apostle and Fervor, surrendered on the spot.
		#
		# THIS IS A DELIBERATE EXCEPTION TO BI §1 AND MUST NOT BE READ AS A
		# REVERSAL OF IT. BI's repair was that HELD VALUE MUST NOT BE COUPLED TO
		# SPEND FREQUENCY — that the meter emptying must not silently cost the
		# mitigation. Here the surrender IS the price, it is named on the card,
		# and it is paid once by one cast rather than by every release in the
		# fight. The passive still never lowers a peak; this one ability does,
		# at its own site.
		# SYNERGY: BINDING OATH swears him a stack every time an ALLY releases,
		# so a party that is releasing is a party rebuilding both the count and
		# the peak this spends; CONSECRATED GROUND drips onto its own caster,
		# which is his other refill; and UNWAVERING FAITH (+20% his maximum)
		# makes every point of the heal larger, because all of it is a share of
		# his own bulk.
		"Blessing of the Faithful":
			return Ability.make({"display_name": "Blessing of the Faithful",
				"dmg_type": "holy", "cost": 20, "damage": 0, "pressure": 0,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "jubilee",
				"perfect_id": "", "perfect_text": "{mhp:8} per stack",
				"description": "Spend ALL your own Faith — 6% of your\nmaximum health and 3% of maximum Mana\nper stack. Needs 3 held.\nYour PEAK DROPS TO MATCH: the\nmitigation it bought is spent with it."})
		# AXIS: the absorb, which BI §2 measured as the DRY source of the whole
		# engine — 1.5 absorbed hits a battle, against the ground's 9.1 Faith.
		# Conviction builds ONLY on Divine Shield absorbs, so a shield that
		# becomes three shields is three times the trigger.
		#
		# IT IS THE POOL'S ONE SHIELD VARIANT, deliberately, and it is a shield
		# nothing else in the game is: DIVINE SHIELD is a bucket on one ally,
		# UNYIELDING AEGIS re-forms a broken one on THE SAME ally, and AEGIS
		# REVERSAL eats one that was never spent. This one LEAVES — it passes to
		# the ally with the lowest health fraction OTHER than the one it just
		# left, so it cannot bounce in place and it finds the fight.
		# SYNERGY: every Divine Shield rider rides each hop, because each hop is
		# a real Divine Shield — BLESSED BARRIER (absorbs become healing),
		# AFTERGLOW (the breaking shield mends), WARDED ROBES, SACRED COVENANT.
		# UNYIELDING AEGIS is the deliberate ANTI-synergy: a re-formed shield has
		# not broken, so it does not pass, and a player holding both trades hops
		# for depth. BLESSING OF ZEAL doubles the Faith every absorb pays.
		"Mantle":
			return Ability.make({"display_name": "Mantle",
				"dmg_type": "holy", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 4, "anim": "attack03",
				"special": "mantle", "target": Ability.Target.ALLY,
				"perfect_id": "", "perfect_text": "",
				"description": "Lay the mantle: a Divine Shield worth\n25% of your maximum health — and when\nit BREAKS it passes to the ally on the\nlowest health, three times. Every one\nof them builds Faith like the first."})
		# ----- OCCULTIST: he is the boss specialist by construction and the
		# boss refuses half his kit. Ruin detonates on every tenth stack and
		# never washes off, so trash dies before the mark matters; meanwhile the
		# whole Madness lane is refused by a boss UNTIL IT IS BROKEN, which
		# makes Break his gate — and his pool held nothing that ground it.
		#
		# AXIS: Break pressure, so the Madness gate is something he OPENS rather
		# than waits for. It is deliberately not a big number of his own: 20
		# Break damage is one Hex of Ruin's worth, and what the card sells is
		# that THE WHOLE PARTY'S Break lands harder for three turns.
		#
		# AN AMPLIFIER RATHER THAN A HIT, BECAUSE THE PARTY IS WHERE THE BREAK
		# IS. A Warden's Threat lane deals 320 Break a battle and the Occultist
		# deals a fraction of that; the lever with leverage is the multiplier,
		# not another cast of his own. NOTHING IN THE GAME HAS EVER AMPLIFIED
		# BREAK DAMAGE — Hunter's Mark amplifies damage, Ironclad and Bulwark
		# REFUSE Break, Devoutness and Hold the Line CUT it, and the reducers all
		# read a number this one has already raised.
		# SYNERGY: the WARDEN's whole Threat lane, above all — Sundering,
		# Bruising Guard and Shield Slam's 40. On his own sheet, BROKEN WILL
		# (+% Break dealt) and ENTROPY (Ruin bearers take Break at their own turn
		# start) both feed the meter this multiplies, and BEWITCH, MIND FLAY and
		# MASS HYSTERIA are what the open gate is FOR.
		#
		# BATCH CG §3 — THE AMPLIFIER IS 25%, NOT 50%, and everything structural
		# holds: the cast's own Break still lands BEFORE the mark so the card
		# cannot amplify itself, and the amplifier still sits ABOVE the reducers
		# so every defence in the game still answers it.
		"Breaking Darkness":
			return Ability.make({"display_name": "Breaking Darkness",
				"dmg_type": "shadow", "cost": 25, "damage": 0, "pressure": 20,
				"delay": 2.0, "cooldown": 4, "anim": "attack02",
				"special": "breaking_darkness",
				"perfect_id": "", "perfect_text": "Holds 4 turns",
				"description": "Break the dark over it: 20 Break\ndamage, and for 3 turns EVERY source\nof Break damage lands on it 25%\nharder. Break is what opens the madness\na boss would otherwise refuse."})
		# AXIS: the detonation cadence, and the lever nothing pulls. Ruin
		# detonates on every TENTH stack and the stacks SURVIVE the blast, so a
		# deep mark is an accumulation the game never lets him cash. This trades
		# the whole pile for one blow.
		#
		# IT IS A BAD TRADE MOST OF THE TIME AND THAT IS THE DESIGN. The mark he
		# spends is worth +2% damage taken a stack for the rest of the battle
		# (+5% under Deeper Hex) and it is what every later detonation is
		# counted toward; spending twenty stacks buys 160% of Attack now and
		# costs the party 40% more damage on that body for the whole fight. It
		# is the answer to "I need it dead this turn", not a rotation piece.
		#
		# IT SPENDS RATHER THAN DETONATES: it fires no detonation, so Unraveling
		# does not seed, Grim Focus does not deepen it and the party does not
		# feast — and it clears the PRIMER with the pile, or a mark primed at
		# ten would detonate for nothing at its next turn.
		#
		# THE DAMAGE IS PER STACK AND THE BREAK IS FLAT, which is ARCANE BOLT's
		# rule for exactly this reason: Ruin has no ceiling, and a per-stack
		# Break term on an uncapped count is the squaring trap.
		# SYNERGY: TRANSFERENCE gathers every mark on the field onto one body
		# and this cashes it; COVENANT OF ASH doubles what the gathering is worth;
		# ANOINTING makes the party build the pile in the first place; and
		# SUFFERING buys eight stacks with one turn of his. DEEPER HEX is the
		# deliberate ANTI-synergy — it makes holding the pile worth more.
		"Requiem":
			return Ability.make({"display_name": "Requiem",
				"dmg_type": "shadow", "cost": 30, "damage": 0, "pressure": 8,
				"delay": 3.0, "cooldown": 5, "anim": "attack03",
				"special": "requiem", "gated": true,
				"perfect_id": "", "perfect_text": "{atk:10} per stack",
				"description": "Sing it out: CONSUMES every stack of\nRuin on one enemy for 8% of Attack\neach, and the party is healed 2% of\nyour maximum per stack.\nNothing detonates — the mark is spent."})
		# AXIS: the free one, and it is aimed at the half of the game his spec
		# cannot reach. IT IS THE ONLY CARD OF HIS THAT READS NO RUIN AT ALL —
		# no stacks to build, no threshold to reach, no mark to spend — so it is
		# the one that still works in the trash fight that ends on round seven,
		# which is precisely where AX measured 0.00 detonations a battle.
		#
		# BATCH CG §3 — IT IS A MIRROR NOW, NOT A TICK. For its duration the
		# enemy takes shadow damage equal to 50% OF THE DAMAGE IT DEALS, whoever
		# it hits — so its own violence is what bills it rather than a number
		# read off its sheet at the moment it was named.
		#
		# THREE CONSEQUENCES, ALL DELIBERATE:
		#   · IT NO LONGER READS THE TARGET'S `attack` STAT. That property, and
		#     the snapshot rule that came with it, go away — no ability anywhere
		#     reads an enemy's Attack now, and none did before Batch CE.
		#   · IT PAYS NOTHING AGAINST AN ENEMY THAT DOES NOT ATTACK — stunned,
		#     charmed, frozen, holding still. The guaranteed floor a snapshotted
		#     tick gave it is gone. ACCEPTED: what it buys instead is that a
		#     blow which lands on the whole party bills the body that threw it.
		#   · THE BOT'S MARK IS UNCHANGED and still right: the HIGHEST-ATTACK
		#     enemy reflects the most, because it is the one that deals the most.
		# SYNERGY: BLIGHT THE WELL is the other card of his that spends a turn
		# doing nothing visible and pays over the following ones, and both want
		# the same body; DECAY and ENTROPY grind the same enemy's clock; and it
		# is the card to hold when BREAKING DARKNESS has already named the
		# target the party is grinding.
		"Penance":
			return Ability.make({"display_name": "Penance",
				"dmg_type": "shadow", "cost": 25, "damage": 0, "pressure": 0,
				"delay": 2.5, "cooldown": 4, "anim": "attack03",
				"special": "penance",
				"perfect_id": "", "perfect_text": "",
				"description": "Set the penance: for 4 turns that enemy\ntakes shadow damage equal to 50% of\nthe damage it deals, whoever it hits.\nAn enemy that never swings never pays."})
		# ========== BATCH CH: TRANCHE 3, THE HUNTER NINE ==========
		#
		# A CONTIGUOUS BLOCK (CB's and CE's shape), but the AXIS/SYNERGY check
		# still anchors PER ABILITY — a shared header must not satisfy all nine.
		#
		# THREE OF THE BRIEF'S NINE NAMES COLLIDED WITH LIVE CONTENT AND ALL
		# THREE MOVED. The brief predicted a crowded vocabulary and said to treat
		# a near-miss as a hit; the sweep came back with worse than near-misses.
		# `Kindred` is a live Beastmaster CAPSTONE (`bm_kindred`, devotion row 8)
		# reading the same Loyalty depth, so the card is SUCCESSION (BW's
		# Vendetta precedent: the node's id is save-bearing and the card was
		# unshipped, so the CARD moves). `Triple Tap` sits one word from TRIPLE
		# SHOT, the same spec's live boss-pool ability and also three strikes on
		# one target, so the card is DRUMFIRE. `Harvest` was not a near-miss at
		# all — see CULL below.
		#
		# ----- BEASTMASTER: keep it, move it, spend it.
		# THE GAP ALL THREE ARE AUTHORED AGAINST: LOYALTY IS THE ONLY RESOURCE IN
		# THE GAME THAT CAN DIE, and until now nothing let him do anything about
		# that except mourn it. BV's three protected the partnership; these three
		# treat the METER as a thing he can carry, move and spend.
		#
		# AXIS: the meter outliving the body it was earned on. Every other
		# Beastmaster card reads a LIVING bond; this one is the only thing in his
		# pool that pays BECAUSE the bond broke.
		# IT IS NOT VENGEANCE AND MUST NEVER BE WRITTEN AS "KEEP THE DEAD BEAST'S
		# BOON" — that is the `bm_vengeance` node, which inherits the BOON (the
		# `_bond_mult` curve plus its own +30%) for the rest of the battle. This
		# carries the METER to the HUNTER as a personal strike-damage buff, which
		# is a different quantity arriving in a different place. A hero holding
		# both gets both, and that stacking is INTENDED — Vengeance keeps the
		# companion's multiplier alive, Last Howl pays the man.
		# SYNERGY: STEADFAST BOND above all (it leaves a share of the meter
		# standing, so the same beast can pay twice), plus NONE LEFT BEHIND and
		# WILD ROTATION — every node that makes a beast's death routine. And it
		# is the deliberate counterpart to BLOODBOND, which spends a card
		# stopping the death this one is paid for.
		"Last Howl":
			return Ability.make({"display_name": "Last Howl", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "last_howl", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Swear the last howl: for the rest of the\nbattle, every companion that falls\ngives you +3% strike damage per stack\nof Loyalty it had earned. The meter\nbreaks as it always did — this is paid\nout of what it held, not instead."})
		# AXIS: the rotation stops costing the bond. THE PACK's whole lane is
		# named for cycling companions, and BJ measured 0.05 swaps a trash
		# battle — a verb nobody uses. BM removed the TURN cost (Instinctive
		# Rotation); this removes the DEPTH cost, which is the half a hunter
		# actually feels once the meter is uncapped.
		# READ THE PREMISE CAREFULLY, BECAUSE THE BRIEF'S IS HALF STALE AND THE
		# CODE IS RIGHT: a swap has NEVER cost Loyalty (BO §5 corrected exactly
		# this), because the meter lives on the HUNTER's dict per kind and only a
		# DEATH breaks it. So a RETURNING beast already keeps its own depth, and
		# what "starting it at nothing" truly describes is a kind that has never
		# been fielded. This card is what makes the FIRST rotation into a fresh
		# beast cheap, and it is deliberately a no-op when the incoming beast
		# already holds more than half of what is leaving.
		# SYNERGY: WILD ROTATION and QUICK WHISTLE (the two nodes that make him
		# swap often), MENAGERIE (which pays for kinds fielded), and THE PACK
		# itself — under the capstone `_swap_victim` evicts the SHALLOWER bond,
		# so what this carries forward is the smaller of his two meters.
		"Succession":
			return Ability.make({"display_name": "Succession", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "succession", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "For 6 turns a swap hands on the bond:\nthe arriving companion starts with HALF\nthe Loyalty of the one it replaces,\ninstead of whatever it had earned\nbefore. It never lowers a deeper bond."})
		# AXIS: the meter as AMMUNITION. Loyalty pays continuously and has no
		# ceiling, so a Beastmaster's only question about it is how deep it can
		# get — never when to cash it. This is the answer, and it is deliberately
		# a BAD trade most of the time: the curve he empties is what every other
		# card of his reads.
		# IT IS NOT PRIMAL SURGE, AND THE DISTINCTION IS SHAPE RATHER THAN SIZE
		# (BT's Stabilize/Arcane Bolt rule, through the Hunter door). Primal
		# Surge is a boss-pool card that spends EVERY companion's meter for 15% a
		# stack apiece AND leaves him a lasting +10% damage; it is a pack-wide
		# conversion on a 2-turn cooldown. This is ONE companion, at 20% a stack,
		# carrying BREAK and leaving nothing behind, on a 4-turn cooldown. Deep
		# on one bond it out-bursts the Surge and cracks a meter the Hunter has
		# no other way to crack; across two bonds the Surge pays more and keeps
		# paying. NEITHER DOMINATES, which is the bar BD §4 sets.
		# ITS BREAK IS FLAT AND MUST STAY FLAT: the stack count has no ceiling,
		# and a per-stack Break term on an uncapped meter is the squaring trap
		# Arcane Bolt, Requiem and Pyre Wake each refused from their own side.
		# SYNERGY: ABSOLUTE DEVOTION and ANCIENT PACT (the two nodes that steepen
		# the per-stack curve), UNBROKEN WATCH and SHARED DEVOTION (which fill
		# the meter faster), and LAST HOWL above — spend the bond, then be paid
		# again when the body that carried it falls.
		"Unleash":
			return Ability.make({"display_name": "Unleash", "cost": 25,
				"damage": 0, "pressure": 12, "delay": 2.5, "cooldown": 4,
				"anim": "attack02", "special": "unleash", "gated": true,
				"perfect_id": "", "perfect_text": "{atk:25} a stack",
				"description": "Spend the whole bond at once: your\ndeepest companion strikes immediately\nfor 20% of your Attack PER STACK of\nits Loyalty, with Break behind it.\nThat meter resets to zero.\nRequires a companion with Loyalty."})
		# ----- SHARPSHOOTER: the exception, the threshold, the depth.
		# THE GAP ALL THREE ARE AUTHORED AGAINST: his pool reads the meter's
		# FIRST hundred points and nothing else. Focus converts at 100 — every
		# point below buys crit CHANCE, every point above buys crit MULTIPLIER —
		# and before this batch not one card in the game read that threshold.
		#
		# AXIS: pricing the spec's central decision instead of removing it.
		# Switching targets clears Focus, which is the whole cost of his spine;
		# UNWAVERING (the node) pays him for never switching and SPRAY OF ARROWS
		# opts out of the meter entirely. This is the third answer — he may
		# juggle exactly TWO enemies deliberately, and pays a card slot for it.
		# Switching between any other pair still clears normally, so the spine is
		# intact and what he bought is one named exception.
		# SYNERGY: TROPHY SHOT and OVERKILL (the two things that already carry
		# Focus through a kill, so a marked enemy dying costs him nothing at
		# all), QUARRY'S MARK (a second name on a second body — the two marks are
		# separate and stack), and CROSSFIRE, which wants a deep meter aimed at
		# whichever of the two is worth the crit.
		"Reacquire":
			return Ability.make({"display_name": "Reacquire", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "reacquire",
				"perfect_id": "", "perfect_text": "",
				"description": "Name one enemy for the rest of the\nbattle. Leaving it BANKS your Focus\ninstead of clearing it, and returning\nto it gives the banked meter back, and\n25 Focus on the mark at once.\nSwitching between any two OTHER\ntargets still clears as it always did."})
		# AXIS: the half of his own passive nothing has ever read, and the Break
		# lever his whole CLASS lacks. Two separate reasons, and the second is
		# the one that reaches past this spec: the Hunter has no Break tool
		# anywhere in twelve specs' worth of kit, so a Sharpshooter holding this
		# is the only Hunter who can open a boss's meter for the party.
		# IT READS `focus_convert()` AND NEVER A LITERAL 100. DEEP FOCUS MOVES
		# THE SPLIT POINT DOWN (floor 1), so a card watching a hardcoded hundred
		# would silently stop agreeing with the passive in exactly the build that
		# bought the node — the `mercy_threshold` lesson Vespers already learned.
		# SYNERGY: DEEP FOCUS above all (it lowers the line this watches),
		# UNWAVERING and MUSCLE MEMORY (which get him over it), and it reaches
		# across the roster to the OCCULTIST's BREAKING DARKNESS, which amplifies
		# every source of Break damage in the game — this one included.
		"Fault Line":
			return Ability.make({"display_name": "Fault Line", "cost": 20,
				"damage": 0, "pressure": 0, "delay": 1.5, "cooldown": 4,
				"anim": "attack01", "special": "fault_line", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "For 6 turns, while your Focus stands\nABOVE the conversion point, every\nattack you land also deals 20 Break\ndamage. Deep Focus moves that line\ndown with it."})
		# AXIS: driving an uncapped meter DEEP inside a single turn. Every other
		# way he builds Focus pays once per turn on one mark, so the meter's
		# depth is a function of how many turns he stays — this is the only thing
		# that makes it a function of what he CASTS.
		# IT IS NOT TRIPLE SHOT, AND THE TWO POINT OPPOSITE WAYS. Triple Shot
		# (boss pool) is 18% a shot with every arrow rolling its own critical —
		# it SPENDS a deep meter, and its own description calls itself a crit
		# lottery. This is 14% a shot and each arrow feeds the engine
		# SEPARATELY, so it BUILDS one. Cheaper, softer, and pointed at the other
		# end of the same resource; a Sharpshooter holding both opens with this
		# and closes with that.
		# THE PER-HIT FOCUS IS BR §1'S RULE ARRIVING AT THE FOCUS ENGINE. That
		# engine has been called once per CAST since AZ, so every existing
		# multi-hit ability builds one stack of Focus however many arrows it
		# throws; this is the first ability in the game to count hits there, and
		# it says so in its own text because a player will assume otherwise.
		# SYNERGY: UNWAVERING (its ramp is per-turn, so three hits multiply what
		# the streak already pays), MUSCLE MEMORY, QUARRY'S MARK (which doubles
		# every one of the three), and FAULT LINE above — three counted hits is
		# the fastest way over the line it watches.
		"Drumfire":
			return Ability.make({"display_name": "Drumfire", "cost": 25,
				"damage": 14, "multi_hits": 3, "pressure": 6, "delay": 3.0,
				"anim": "attack02", "cooldown": 3,
				# `perfect_extra_hit` IS LEFT AT ITS DEFAULT (true), UNLIKE TRIPLE
				# SHOT'S, and the two are the reason each other reads the way it
				# does: Triple Shot buys a guaranteed CRIT with its perfect because
				# it is the card that spends the meter, and this buys a fourth
				# ARROW because it is the card that fills one. A fourth arrow is a
				# fourth COUNTED hit, which is the only perfect on this card that
				# is about its own mechanic rather than about damage.
				"perfect_id": "",
				"perfect_text": "A fourth arrow, counted like the rest.",
				"description": "Three arrows at one mark, 14% of\nAttack each — and EACH ONE counts\nseparately for Focus, where every\nother volley in the game counts once.\nThe fastest way to a deep meter."})
		# ----- SURVIVALIST (`mystic`): draw it, spread it, spend it.
		# THE GAP ALL THREE ARE AUTHORED AGAINST: TRAPPER PAYS FOR BREADTH — +8%
		# damage per DIFFERENT status on the target — and nothing in his kit has
		# ever helped him GET breadth except applying afflictions one at a time,
		# by hand, off his own turns.
		#
		# AXIS: the taunt that builds his own engine. He has no draw of any kind
		# today, and a plain taunt on a 100-Constitution spec would be a Warden
		# card in the wrong tree — the DIFFERENT-STATUS-PER-ATTACKER clause is
		# the whole ability, because it turns being attacked into the breadth his
		# passive promises and nothing has ever delivered.
		# EVERY STATUS IT LAYS IS IN `DEBUFF_IDS`, AND THAT IS LOAD-BEARING
		# RATHER THAN TIDY: Trapper's breadth term counts the curated list ONLY,
		# so a status outside it would apply, log, and read as working while
		# contributing nothing at all to his multiplier — the card would do
		# exactly half of what it says with nothing to announce it.
		# SYNERGY: FORCE OF NATURE and VULTURE (the two nodes paid per different
		# affliction), HUNT and CULL below (both priced on the count), and HIT
		# AND RUN, which grants Elusive every time he applies a status — a card
		# that applies one per incoming attack keeps it up permanently.
		"Stalking Horse":
			return Ability.make({"display_name": "Stalking Horse", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 4,
				"anim": "attack01", "special": "stalking_horse", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Play the stalking horse for 4 turns:\nenemies are drawn to swing at YOU, and\nevery attacker takes a DIFFERENT\naffliction — Poison, then Cripple, then\nSlowed, Exposed, Dazed and Blind. Your\nown breadth, built off their turns."})
		# AXIS: the party feeding his engine. Trapper's breadth term counts
		# statuses from ANY source — his `PROTECTED_CORES` entry says so in as
		# many words — and he is the ONLY spec in the game whose passive an ally
		# can pay into. Nothing has ever exploited that, and this is the card
		# that says it out loud.
		# IT COVERS EVERY HERO, HIMSELF INCLUDED, AND THAT IS ONE RULE RATHER
		# THAN A CARVE-OUT. Excluding him would make the card read as inert on
		# any turn he spent applying his own afflictions, and an invisible
		# special case at a shared door is exactly what this project keeps
		# warning about. What it is SOLD on is still the allies — a Pyromancer's
		# Burn, a Cryomancer's Chilled and an Occultist's whole board become his
		# breadth, on a second body, for free.
		# SYNERGY: any ally who applies statuses in volume — the OCCULTIST above
		# all, then the CRYOMANCER and the PYROMANCER — plus his own QUARTERMASTER
		# (which already puts his poison on his allies' blades) and CULL below,
		# which cashes what this spreads.
		"Downwind":
			return Ability.make({"display_name": "Downwind", "cost": 25,
				"damage": 0, "pressure": 0, "delay": 2.0, "cooldown": 5,
				"anim": "attack01", "special": "downwind", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "For 4 turns the wind carries it: every\nharmful effect any hero lands on an\nenemy is copied onto a SECOND enemy,\npreferring one that does not have it.\nHis engine, fed by the whole party."})
		# AXIS: spending the breadth. It DELIBERATELY FIGHTS HIS OWN PASSIVE —
		# what Trapper spent the fight building is what this eats — and that
		# tension is the point of the card rather than a cost to be smoothed
		# away.
		# THE BRIEF CALLED THIS ONE HARVEST AND HARVEST IS A LIVE ABILITY, IN THE
		# VERY POOL THIS SPEC DRAWS FROM AT A ZONE BOSS (`SPEC_POOLS["mystic"]`
		# and `CLASS_POOLS["hunter"]`). That is not a label collision to flag:
		# `pool_ability` is keyed on `display_name`, so a second Harvest makes
		# the resolver answer the wrong question — a REAL BREAK by BR §1 — and
		# the MECHANIC duplicated too, which is the Deadfall/Snare Trap failure
		# this batch's own §1 warns about. So the name moved AND the shape did.
		# HOW IT DIFFERS FROM HARVEST, AND NEITHER DOMINATES: Harvest empties ONE
		# enemy for 12% of Attack a status and heals him the same — burst plus
		# sustain, on one body. This empties one enemy and throws the reaping at
		# the WHOLE FIELD for 10% a status apiece, heals nothing, costs more and
		# returns more slowly. On a single target Harvest is strictly better; on
		# a full field this is worth several times as much. It reads
		# `_harvest_yield` — the ONE answer to "what would this reap" — so the
		# two can never disagree about what a sticky poison is worth.
		# ITS BREAK IS ZERO, AND THAT IS A DECISION ON A CARD THAT GENUINELY
		# DEALS DAMAGE: the multiplier is a count of afflictions with no ceiling
		# on it, so a Break term riding that count is the squaring trap from a
		# fourth direction. Pyre Wake is the precedent and the reason is the same.
		# SYNERGY: DOWNWIND above all (it spreads the board this cashes),
		# STALKING HORSE (which builds it off enemy turns), and SLOW ACTING and
		# PERFECTED TOXIN — both make a poison that CANNOT be cleansed, so it
		# stays on the body and is honestly not paid for.
		"Cull":
			return Ability.make({"display_name": "Cull", "dmg_type": "nature",
				"cost": 30, "damage": 0, "pressure": 0, "delay": 3.0,
				"cooldown": 5, "anim": "attack03", "special": "cull",
				"perfect_id": "", "perfect_text": "{atk:12} a status",
				"description": "CONSUME every affliction on one enemy:\nEVERY enemy takes 10% of Attack in\nnature damage per status removed.\nA poison that cannot be cleansed stays\n— and is not paid for. It strips your\nown Trapper bonus from that body."})
	return null


# ---------- the vault, unsealed ----------
#
# Abilities that left a kit but never left the code: every one of these
# still has its `special` handler in battle.gd, so they return as earnable
# picks without a line of new mechanics. FIVE could NOT come back, because
# their machinery went with them: Pyroblast, Flame Surge, Frost Bolt, Death
# Ray and Mend Wounds are prose in a comment, not code, and reviving them
# would mean AUTHORING them. BATCH AR AUTHORED PYROBLAST — it is a plain
# damage ability plus one conditional in the existing damage block, which is
# why it needed no subsystem; the other four are still prose. Three of the ten below (Mana Shield, Arcane
# Surge, Reality Fracture) kept their full dicts in the vault comments and
# come back verbatim; the other seven needed a cost/cooldown/initiative
# wrapper around effects the handler already defines exactly, and THOSE
# NUMBERS ARE NEW — the one balance judgment this batch made.
static func vault_ability(display_name: String) -> Ability:
	match display_name:
		"Rallying Shout":
			return Ability.make({"display_name": "Rallying Shout", "cost": 25,
				"special": "rally", "delay": 2.5, "anim": "attack03", "cooldown": 3,
				"perfect_id": "", "perfect_text": "",
				"description": "Raise the line: the whole party sheds\n50 Pressure, and every other ally\nregains 30% of their resource."})
		"Retaliation":
			return Ability.make({"display_name": "Retaliation", "cost": 20,
				"special": "retaliate", "delay": 2.0, "anim": "attack01", "cooldown": 3,
				"perfect_id": "", "perfect_text": "",
				"description": "Set the counter-stance: for 4 turns\nevery attacker is answered with a\nbasic strike."})
		"Mana Shield":
			return Ability.make({"display_name": "Mana Shield", "cooldown": 3,
				"cost": 15, "special": "mana_shield", "delay": 2.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "50% of damage taken converts into\nMana (3 turns). It is quick to cast."})
		# BATCH BB §6 — ASHES OF AL'AR GETS A HOME, AND IT NEEDED A WRAPPER.
		# The batch brief calls this "one array entry"; IT IS NOT, and the
		# difference is worth stating rather than quietly absorbing. Ashes of
		# Al'ar has never been an Ability — it was a Pyromancer TALENT, a passive
		# guard in `unit.take_hit` / `unit.take_tick_damage`, and AR removed the
		# node with every other defensive option in that spec. A CLASS_POOLS
		# entry has to resolve through `pool_ability` to an Ability, so putting
		# the self-revive Mage-wide means authoring the cast that arms it.
		#
		# THAT IS EXACTLY THE VAULT'S OWN PRECEDENT (Batch AH): seven of the ten
		# entries below "needed a cost/cooldown/initiative wrapper around effects
		# the handler already defines exactly, and THOSE NUMBERS ARE NEW". The
		# guard is live and untouched in unit.gd; the cost, the initiative and
		# the return share are this batch's one balance judgement, flagged here
		# rather than buried.
		#
		# ARMING IT COSTS A TURN, and for the Pyromancer that is the point: the
		# spec whose spine is having no escape hatch can buy one back only by
		# spending a boss pick AND a turn he would rather spend burning.
		"Ashes of Al'ar":
			return Ability.make({"display_name": "Ashes of Al'ar", "cost": 30,
				"special": "ashes", "delay": 2.5, "anim": "attack03", "cooldown": 0,
				"perfect_id": "", "perfect_text": "",
				"description": "Wreathe yourself in embers: the next\nblow that would kill you this battle\nreturns you at 40% health instead.\nOnce per battle."})
		"Arcane Surge":
			return Ability.make({"display_name": "Arcane Surge", "cost": 15,
				"special": "surge", "delay": 3.0, "anim": "attack03", "cooldown": 3,
				"perfect_id": "", "perfect_text": "",
				"description": "+20% attack on your next turn.\nAn Arcanist also banks 2 Resonance."})
		"Reality Fracture":
			return Ability.make({"display_name": "Reality Fracture",
				"dmg_type": "arcane", "cost": 20, "damage": 15, "pressure": 14,
				"delay": 2.0, "anim": "attack03", "delay_push": 6.0, "cooldown": 3,
				"perfect_id": "", "perfect_text": "An Arcanist also banks 1 Resonance",
				"description": "Shove the target far down the\ninitiative order."})
		# PHOENIX REBIRTH IS NOT HERE ANY MORE. Batch AR made it the
		# Pyromancer's Inferno capstone, so the TREE owns the only copy and
		# pool_ability finds it through Talents.granted_ability — the same
		# single-source rule every other talent grant follows. It stays in
		# CLASS_POOLS["mage"] and still resolves; only the def moved.
		"Dawnbreak":
			return Ability.make({"display_name": "Dawnbreak", "cost": 20,
				"special": "dawnbreak", "target": Ability.Target.ALLY,
				"delay": 3.0, "anim": "attack02", "cooldown": 2,
				"perfect_id": "", "perfect_text": "Heals 55",
				"description": "Call the dawn: heal an ally 40.\nWhatever overflows their bar heals\nthe caster instead."})
		"Sanctuary":
			return Ability.make({"display_name": "Sanctuary", "cost": 30,
				"special": "sanctuary", "delay": 3.5, "anim": "attack03", "cooldown": 4,
				"perfect_id": "", "perfect_text": "Heals 18%",
				"description": "Ground made safe: every ally heals\n12% of their max health."})
		"Divine Wrath":
			return Ability.make({"display_name": "Divine Wrath", "cost": 25,
				"special": "divine_wrath", "delay": 2.5, "anim": "attack03", "cooldown": 4,
				"perfect_id": "", "perfect_text": "",
				"description": "The light answers: the whole party\ndeals +15% damage and acts 15%\nfaster for 4 turns."})
		"Umbral Sigil":
			return Ability.make({"display_name": "Umbral Sigil", "cooldown": 4,
				"cost": 20, "special": "umbral_sigil", "delay": 3.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "Brand one enemy for 4 turns: half of\nevery attack it suffers echoes through\nits whole warband."})
	return null


# ---------- abilities trimmed out of a starting kit (Batch AH) ----------
#
# These left their spec's opening three and became earnable. The defs live
# here rather than in spec_abilities() so there is still exactly one copy.
static func trimmed_kit_ability(display_name: String) -> Ability:
	match display_name:
		"Blood Price":
			return Ability.make({"display_name": "Blood Price", "cost": 0,
				"special": "blood_price", "delay": 1.5, "anim": "attack02",
				"cooldown": 3,
				"perfect_id": "", "perfect_text": "",
				"description": "Open his own veins: pays 7.5% of\ncurrent health (never lethal) for\n30 Rage and +25% damage for 2 turns.\nBlood Frenzy wakes when HE says so."})
		"War Stomp":
			return Ability.make({"display_name": "War Stomp", "cost": 20, "damage": 15,
				"pressure": 15, "delay": 3.0, "anim": "attack03", "cooldown": 3,
				"random_hits": 3, "perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "Allies regain 20% of their resource",
				"description": "Slam the earth: 3 shockwaves rip\nrandom enemies for 15% Attack damage\nand 15 BD each. Allies regain 10%\nof their resource."})
		"Interpose":
			return Ability.make({"display_name": "Interpose", "cost": 25,
				"special": "interpose", "delay": 2.0, "anim": "attack01",
				"cooldown": 4,
				"perfect_id": "", "perfect_text": "",
				"description": "Throw the wall wide: EVERY ally, the\nWarden included, gains a shield charge\n— the next attack against them is\nBLOCKED."})
		"Sweeping Strikes":
			return Ability.make({"display_name": "Sweeping Strikes", "cost": 20,
				"damage": 15, "pressure": 12, "delay": 3.0, "anim": "attack02",
				"multi_hits": 2, "perfect_extra_hit": false, "resource_gain": 10,
				"applies_status": {"id": "dazed", "turns": 3},
				"perfect_id": "", "perfect_text": "+25% crit chance on the second swing",
				"description": "Two broad cuts that leave the target\nDazed for 3 turns. Builds 10 Rage."})
		# Batch AK: Guard Change went BACK into the opening three and
		# Shatterpoint took its place here. Guard Change is the only stance
		# swap in the game, and four nodes of the Swordmaster's tree read
		# the stance — trimming it turned a quarter of his tree inert.
		# Shatterpoint only accelerates a Break he reaches by other means,
		# so it is the safe piece to make earnable.
		# Batch AT: Stabilize came OUT of the Arcanist's opening three and into
		# SPEC_POOLS["arcanist"]. It is the escape hatch from the ramp — it
		# vents the very stacks Runaway Resonance exists to build — so it is a
		# choice a player EARNS rather than a default they start holding. Its
		# venting is the one thing that removes Resonance; the passive's "no
		# ceiling, nothing removes it" describes the passive's own rules, and
		# this is the exception the player buys deliberately.
		"Stabilize":
			return Ability.make({"display_name": "Stabilize", "cooldown": 3, "cost": 0,
				"damage": 0, "pressure": 0, "special": "stabilize", "delay": 1.5,
				"anim": "attack01",
				"perfect_id": "", "perfect_text": "",
				"description": "Vent the storm: consumes all\nResonance ABOVE 2 — +5 Mana and +10%\ndamage reduction (2 turns) per stack\nconsumed, and heals {mhp:5}.\nUnusable at 2 or fewer."})
		"Shatterpoint":
			return Ability.make({"display_name": "Shatterpoint", "cost": 30,
				"damage": 20, "pressure": 40, "delay": 3.0, "anim": "attack03",
				"cooldown": 4,
				"perfect_id": "", "perfect_text": "+15 bonus BD",
				"description": "Find the flaw and split it — his\nheaviest Break blow. If this hit\nBREAKS the target, he instantly casts\nOverpower on them for free."})
	return null


# The Survivalist's spec pool — 5 of the designed 8. Blight, Smoke Bomb and
# Field Dressing are still unwritten (Batch AH asked for them and its own
# opening line forbade authoring new abilities; the header won). Adding
# them later is a list edit and a def, no restructuring.
static func survivalist_pool_ability(display_name: String) -> Ability:
	match display_name:
		"Explosive Shot":
			return Ability.make({"display_name": "Explosive Shot", "cooldown": 3,
				"dmg_type": "nature", "cost": 35, "damage": 10, "pressure": 20,
				"delay": 3.0, "anim": "attack03", "aoe": true,
				"applies_status": {"id": "poison", "turns": 5},
				"perfect_id": "", "perfect_text": "Deals {atk:12}",
				"description": "A bursting powder charge rakes ALL\nenemies with nature damage and heavy\nBreak pressure, Poisoning each."})
		"Venom Coating":
			return Ability.make({"display_name": "Venom Coating", "cooldown": 5, "cost": 20,
				"special": "venom_coat", "delay": 1.5, "anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Coat your arrows: for 4 turns every\nattack applies Poison and refreshes\nexisting Poison timers."})
		"Hamstring":
			return Ability.make({"display_name": "Hamstring", "cooldown": 3, "cost": 25,
				"damage": 20, "pressure": 10, "delay": 2.5, "anim": "attack02",
				"applies_status": {"id": "cripple", "turns": 3},
				"perfect_id": "status_plus", "perfect_text": "Everything lasts 4 turns",
				"description": "A tearing shot through the leg:\nCripple, Slowed AND Exposed for\n3 turns — three statuses in one cast."})
		# BATCH BD — RE-SPECCED FROM A ONE-SHOT MINE INTO A PLACED HAZARD.
		# Read against the base kit, the old Deadfall WAS Snare Trap: same cost,
		# same initiative, same cooldown, same 1-turn stun at the victim's turn
		# start, both against the same trap cap — and the only distinction (you
		# don't pick) was handed straight back by its perfect. UNTARGETED IS THE
		# DESIGN NOW rather than the drawback, so the perfect can no longer name
		# the victim: that clause is exactly what collapsed the two abilities.
		# Per-spring damage is 35% -> 20% because there are THREE of them; the
		# payoff is three turns of denial rather than the numbers.
		"Deadfall":
			return Ability.make({"display_name": "Deadfall", "cooldown": 5, "cost": 25,
				"special": "deadfall", "delay": 2.0, "anim": "attack01",
				"perfect_id": "", "perfect_text": "",
				"description": "Arm a deadfall in the path. The next\nenemy to act takes 20% Atk nature\ndamage and is Stunned 1 turn; the trap\nthen lies dormant 2 turns, re-arms and\nsprings again — FOUR times in all.\nIt holds a trap slot until spent."})
		"Harvest":
			return Ability.make({"display_name": "Harvest", "cooldown": 4, "cost": 25,
				"special": "harvest", "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Heals 150% of the damage",
				"description": "CONSUME every status on one enemy:\n12% of Attack per status REMOVED,\nand you heal the same amount.\nA poison that cannot be cleansed\nstays — and is not paid for.\nCashing out strips your own Trapper\nbonus from the target — spend the\nboard wisely."})
	return null


# The Sharpshooter's spec pool — 5 of the designed 8, for the same reason
# as the Survivalist's above (Disengage, Suppressing Fire, Piercing Arrow).
static func sharpshooter_pool_ability(display_name: String) -> Ability:
	match display_name:
		"Quick Draw":
			return Ability.make({"display_name": "Quick Draw", "cooldown": 5, "cost": 15,
				"special": "quickdraw", "delay": 1.5, "anim": "attack01",
				"perfect_id": "", "perfect_text": "",
				"description": "Adrenaline takes over: all your abilities\nact 50% faster for 6 turns."})
		"Triple Shot":
			return Ability.make({"display_name": "Triple Shot", "cooldown": 3, "cost": 30,
				"damage": 18, "multi_hits": 3, "pressure": 8, "delay": 3.0, "anim": "attack02",
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "One arrow is a guaranteed critical.",
				"description": "Three arrows at one target, 18% of\nAttack each — every arrow rolls its\ncritical separately. A crit lottery\nfor a deep Focus meter."})
		"Coup de Grâce":
			return Ability.make({"display_name": "Coup de Grâce", "cooldown": 4, "cost": 25,
				"damage": 25, "pressure": 10, "delay": 3.5, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "CONSUMES ALL FOCUS: deals 25% of\nAttack plus 1% of the target's\nMISSING health per point of Focus\nspent, reading at most 200.\nCash out the patience."})
		"Pinning Shot":
			return Ability.make({"display_name": "Pinning Shot", "cooldown": 3, "cost": 20,
				"damage": 20, "pressure": 10, "delay": 2.5, "anim": "attack02",
				"applies_status": {"id": "slow", "turns": 3},
				"perfect_id": "", "perfect_text": "",
				"description": "A shaft through the leg: the target\nis Slowed AND Dazed for 3 turns."})
		"Called Shot":
			return Ability.make({"display_name": "Called Shot", "cooldown": 3, "cost": 25,
				"damage": 25, "pressure": 10, "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "",
				"description": "Pick your spot before loosing:\nSUNDER the target's armor (-35%,\n2 turns), CRACK their Break meter\n(+30 BD), or lay them EXPOSED\n(3 turns)."})
	return null


static func beastmaster_pool_ability(display_name: String) -> Ability:
	match display_name:
		"Bestial Wrath":
			return Ability.make({"display_name": "Bestial Wrath", "cooldown": 3, "cost": 25,
				"special": "bestial", "delay": 3.5, "anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "Unleash the companion for 3 turns —\nUrsus: max health DOUBLES, +50%\narmor, taunts 3 random enemies.\nCanis: +50% damage and +10 Bleed on\nits bleeding strikes. Aguila: +25%\ndamage and every strike BLINDS.\nRequires a living companion."})
		"Spirit Bond":
			return Ability.make({"display_name": "Spirit Bond", "cooldown": 3, "cost": 20,
				"special": "spirit_bond", "delay": 1.5, "anim": "attack01",
				"perfect_id": "", "perfect_text": "Both gain +10% max health for 5 turns",
				"description": "You and every living companion each heal\n25% of your max health now and 10%\nmore next turn. You restore 15% max\nMana now and 5% on each of your next\n2 turns. Requires a living companion."})
		"Primal Surge":
			return Ability.make({"display_name": "Primal Surge", "cooldown": 2, "cost": 20,
				"special": "primal_surge", "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "The Loyalty is spent but NOT lost",
				"description": "Spend ALL Loyalty: each living companion\nstrikes for 15% of your Attack per\nstack it spends, and you gain +10%\ndamage for the total turns. Loyalty\nresets to 0. Requires a companion with\nLoyalty."})
		"Call of the Wild":
			return Ability.make({"display_name": "Call of the Wild", "cooldown": 4, "cost": 30,
				"special": "call_wild", "delay": 4.0, "anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": "The whole pack answers: your living\ncompanions make their own strikes, the\nabsent ones appear to strike for 15%\nof your Attack, every arrival effect\nfires, and the absent depart."})
		"Mark of the Hunt":
			return Ability.make({"display_name": "Mark of the Hunt", "cooldown": 3, "cost": 15,
				"special": "mark_hunt", "delay": 2.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "",
				"description": "Mark an enemy for 7 turns: you and\nyour companion deal +25% damage to it\nand every strike on it restores 3%\nof your max Mana. The cooldown resets\nif the marked enemy dies.\nWorks with or without a companion."})
	return null


# DOD_SIM_ABILITIES test hook meanwhile. faith_cost = Mercy stacks.
#
# BATCH AV: "Resurrection" is no longer talent-gated — it is in the Holy
# OPENING KIT (`spec_abilities`) and the Rune of the Last Rites still grants
# it by name. Its def stays HERE and nowhere else, because those two callers
# and `pool_ability` must all read the same numbers; the kit list calls this
# function rather than holding a second copy (the AK resolver rule).
static func pending_talent_ability(display_name: String) -> Ability:
	match display_name:
		"Resurrection":
			return Ability.make({"display_name": "Resurrection", "cooldown": 3,
				"cost": 0, "faith_cost": 1, "special": "resurrection",
				"target": Ability.Target.ALLY, "delay": 4.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "Spend 1 Mercy: return a fallen ally\nto life with 25% health and resource.\nEmpower (+1 Mercy): full health and\nresource, plus 5 turns of Renewal."})
		"Divine Plea":
			return Ability.make({"display_name": "Divine Plea", "cooldown": 2,
				"cost": 0, "faith_cost": 2, "special": "divine_plea",
				"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
				"perfect_id": "", "perfect_text": "Restores 10 Mana",
				"description": "Spend 2 Mercy: FULLY heal an ally.\nEmpower (+1 Mercy): also cleanse all\ndebuffs and Hallow them against new\nones for 3 turns."})
		# BATCH AV — THE REVERSAL BUTTON: death itself refused rather than
		# healed away. NO faith_cost: it costs Mercy ON TRIGGER, not on cast,
		# so a Cleric holding nothing arms nothing (battle._on_intercession_save
		# is the one place that decides, and it refuses when she is empty).
		"Intercession":
			return Ability.make({"display_name": "Intercession", "cooldown": 4,
				"cost": 25, "special": "intercession", "delay": 2.0,
				"anim": "attack03",
				"perfect_id": "", "perfect_text": "The window lasts a turn longer",
				"description": "For 2 turns the next lethal blow\nagainst ANY hero is refused — they\nsurvive at 1 health and the Cleric\nloses 1 Mercy. She must be holding\none when it lands."})
		"Sacred Resolve":
			return Ability.make({"display_name": "Sacred Resolve", "cooldown": 5,
				"cost": 25, "special": "unity", "delay": 2.5, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "Bind the party's souls — all damage\nreceived is split evenly among them\nfor 4 turns (Break damage still lands\non the struck hero)."})
		"Mind Flay":
			return Ability.make({"display_name": "Mind Flay", "cooldown": 2,
				"dmg_type": "shadow", "cost": 25, "damage": 30, "pressure": 15,
				"choose_two": true, "delay": 3.0, "anim": "attack03",
				"applies_status": {"id": "psychosis", "turns": 3},
				"perfect_id": "status_plus", "perfect_text": "Psychosis lasts 4 turns",
				"description": "Flay TWO chosen minds: 30% of Attack\nin shadow each and Psychosis for\n3 turns — madness that turns them\non their own. A BOSS RESISTS UNTIL\nBROKEN."})
		"Mass Hysteria":
			return Ability.make({"display_name": "Mass Hysteria", "cooldown": 4,
				"cost": 30, "special": "hysteria", "delay": 4.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "The warband turns on itself: next\nturn every minion strikes a fellow\nwith DOUBLE Break damage, Sundering\nthem for 3 turns. A BOSS RESISTS\nUNTIL BROKEN. Cooldown 3."})
		"Bulwark of Fortitude":
			return Ability.make({"display_name": "Bulwark of Fortitude", "cooldown": 3,
				"cost": 30, "special": "bulwark", "delay": 3.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "",
				"description": "The unbreakable stand: for 3 turns\nthe party takes NO Break damage, has\nits armor increased by 50%, and heals\n10% of max health each turn.\nThe party heals {mhp:5} at once."})
	return null


# Spec kit corruption: the Occultist's Smite is warped into Shadowrend,
# the Pyromancer's Magic Bolt burns as Fireball. Applied by battle spawn
# AND the party screen.
static func apply_kit_overrides(cfg: Dictionary, spec: String) -> void:
	if spec == "occultist":
		cfg["abilities"][0] = Ability.make({"display_name": "Shadowrend",
			"dmg_type": "shadow", "cost": 0, "damage": 25, "pressure": 16,
			"delay": 2.0, "anim": "attack01",
			"applies_status": {"id": "cripple", "turns": 2},
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers {mhp:5}",
			"description": "A rending strike of gnawing shadow:\nCripples the target for 2 turns."})
	elif spec == "pyromancer":
		cfg["abilities"][0] = Ability.make({"display_name": "Fireball",
			"dmg_type": "fire", "cost": 0, "damage": 20, "pressure": 15,
			"delay": 2.0, "anim": "attack01",
			"applies_status": {"id": "burn", "turns": 3},
			"perfect_id": "", "perfect_text": "Deals {atk:25}",
			"description": "A crackling bolt of flame: applies\n3 turns of Burn (reapplying extends\nthe burn)."})
	elif spec == "cryomancer":
		cfg["abilities"][0] = Ability.make({"display_name": "Frostbolt",
			"dmg_type": "frost", "cost": 0, "damage": 20, "pressure": 15,
			"delay": 2.0, "anim": "attack01",
			"applies_status": {"id": "chilled", "turns": 3},
			"perfect_id": "", "perfect_text": "Deals {atk:25}",
			"description": "A shard of biting cold: applies 1 stack\nof Chilled. Four stacks put the enemy in\nGlacial Hold — off the turn order until\nthe Cryomancer releases it."})
	elif spec == "arcanist":
		cfg["abilities"][0] = Ability.make({"display_name": "Arcane Explosion",
			"dmg_type": "arcane", "cost": 0, "damage": 10, "pressure": 10,
			"delay": 2.0, "anim": "attack01", "random_hits": 2,
			"perfect_extra_hit": false,
			"perfect_id": "", "perfect_text": "",
			"description": "Unstable magic detonates over TWO\nrandom enemies. Builds 1 Resonance\n(2 on a critical strike)."})


# Archetype outline (design north star for every spec's kit):
#   Damage — Ramp: starts weak, snowballs as the battle progresses.
#            Rush: starts strong, resources dwindle as it progresses.
#            Nuker: banks resources for one devastating turn; exploits weakened foes.
#            Pressure: steady damage, debuffs/DoTs, Break pressure.
#            Bruiser: damage/tank hybrid, weakens enemies, moderate damage, debuffs.
#   Support — Healer: restores HP/mana, can revive.
#             Warder: damage mitigation and buffs.
#   Tank — Tank: absorbs and redirects damage, buffs.
const ARCHETYPE_ROLE := {
	"Ramp": "Damage", "Rush": "Damage", "Nuker": "Damage", "Pressure": "Damage",
	"Bruiser": "Damage", "Control": "Damage",
	"Healer": "Support", "Warder": "Support", "Tank": "Tank",
}

# Base ATTACK by role. Ability damage is a PERCENT of the user's current
# Attack; Attack (and max HP) scale +2% of base per completed combat node.
const ROLE_ATTACK := {"Damage": 100, "Tank": 75, "Support": 50}


# A spec's base Attack: explicit "attack" in SPEC_INFO wins (per-spec stat
# blocks are coming class by class), else the archetype role's base.
static func spec_attack(spec: String) -> int:
	var info: Dictionary = SPEC_INFO[spec]
	return int(info.get("attack",
		ROLE_ATTACK[ARCHETYPE_ROLE[info["archetype"]]]))


# A spec's innate resistances (fraction reduced per damage type, like armor
# for that type). Specs override via "resists" in SPEC_INFO — being filled
# in class by class; missing keys mean 0%.
static func spec_resists(spec: String) -> Dictionary:
	return SPEC_INFO[spec].get("resists", {})


# THE spec stat block, one source of truth: the battle spawn and the
# party sheet both call this (master.html §11 — the two must never
# drift; same precedent as apply_passive). Constitution/Attack/resists
# always; max_hp and armor only once a spec declares them (the
# Berserker leads — 175 HP / 15% armor keeps his effective HP against
# physical within 0.3% of the old 154 / 25%, trading mitigation for a
# bigger visible pool: more Frenzy runway, more Rage from being hit).
# parry_chance replaces the hero baseline outright (the Swordmaster is
# the only parry-stat character, as the Warden is the only Block one).
static func apply_spec_stats(cfg: Dictionary, spec: String) -> void:
	if spec == "" or not SPEC_INFO.has(spec):
		return
	var info: Dictionary = SPEC_INFO[spec]
	cfg["constitution"] = info.get("constitution", cfg.get("constitution", 100))
	cfg["attack"] = spec_attack(spec)
	cfg["resists"] = spec_resists(spec).duplicate()
	if info.has("max_hp"):
		cfg["max_hp"] = int(info["max_hp"])
	if info.has("armor"):
		cfg["armor"] = float(info["armor"])
	if info.has("parry_chance"):
		cfg["parry_chance"] = float(info["parry_chance"])
	if info.has("block_chance"):
		cfg["block_chance"] = float(info["block_chance"])


const ARCHETYPE_DESC := {
	"Ramp": "Starts weak, snowballs as the battle progresses.",
	"Rush": "Starts strong; resources dwindle as the fight drags on.",
	"Nuker": "Banks resources to unleash a single devastating turn.",
	"Pressure": "Steady damage, debuffs and DoTs, Break pressure.",
	"Healer": "Restores lost HP and mana; can revive.",
	"Warder": "Damage mitigation and protective buffs.",
	"Tank": "Absorbs and redirects damage; buffs the line.",
	"Bruiser": "Damage/tank hybrid — weakens foes with moderate damage and debuffs.",
	"Control": "Locks the battlefield down — slows, freezes, and shatters.",
}


# Specializations: ordered ids per class, plus display/passive/archetype data.
# Each spec = 1 passive (implemented via passive_id hooks in battle.gd)
# + 2 abilities appended to the core kit.
const SPEC_IDS := {
	"warrior": ["berserker", "warden", "swordmaster"],
	"mage": ["pyromancer", "cryomancer", "arcanist"],
	"cleric": ["holy", "inquisitor", "occultist"],
	"hunter": ["beastmaster", "sharpshooter", "mystic"],
}


# All twelve spec ids as a flat list, in class order — what the build screen
# and the sim's loadout installer walk. ONE derivation, so a thirteenth spec
# joins both by joining SPEC_IDS.
static func all_specs() -> Array:
	var out: Array = []
	for class_key in SPEC_IDS:
		for spec in SPEC_IDS[class_key]:
			out.append(String(spec))
	return out


# Batch W (DOD_SIM_ROTATE=1): the sim rotation schedule, shared by the
# sweep (n = battle index) and the run harness (n = run index). The base
# n term makes any 3 consecutive counters sample each class's three specs
# exactly once — evenness is guaranteed regardless of where a sweep stage
# starts. The drift terms (advancing every 3 and 9 counters) reshuffle
# which specs land TOGETHER, so a spec is measured across many party
# mixes instead of one fixed trio.
static func rotated_specs(n: int) -> Array:
	var order := ["warrior", "mage", "cleric", "hunter"]
	var third := int(n / 3.0)
	var ninth := int(n / 9.0)
	var out: Array = []
	for i in order.size():
		var drift: int = third * i + (ninth if i >= 2 else 0)
		out.append(SPEC_IDS[order[i]][(n + i + drift) % 3])
	return out


# Spec passives that are plain stat changes live here so both the battle
# spawner and the character sheet apply them identically.
# VAULTED — Bulwark (was the Warden passive): +10% armor, +30 Constitution.
static func apply_passive(cfg: Dictionary, spec: String) -> void:
	match SPEC_INFO[spec]["passive"]:
		"heavy_plating":
			# The Warden's Block stat moved into the spec stat block (Batch G:
			# 10% base via apply_spec_stats); the passive's +15% and its
			# climbing pity bonus live inside the block roll (battle.gd).
			pass

const SPEC_INFO := {
	"berserker": {"name": "Berserker", "constitution": 110, "archetype": "Ramp", "passive": "bloodrage",
		"max_hp": 175, "armor": 0.15,
		"resists": {"shadow": 0.10, "nature": 0.10, "frost": -0.15},
		"passive_desc": "Blood Frenzy: +2% damage for every 5% of health\nmissing. Half the highest bonus reached in a battle\nis kept as a floor for the rest of it.",
		"blurb": "Reckless savagery — grows stronger as their blood spills."},
	"warden": {"name": "Warden", "constitution": 130, "archetype": "Tank", "passive": "heavy_plating",
		"max_hp": 200, "armor": 0.32, "block_chance": 0.10,
		"resists": {"fire": 0.15, "frost": 0.15, "arcane": -0.20},
		"passive_desc": "Heavy Plating: +15% Block chance. Every attack that is\nNOT Blocked raises Block chance by 8% for the rest of\nthe battle (up to +40%); Blocking resets the bonus.",
		"blurb": "Protector of the weak — shields allies with their own body."},
	"swordmaster": {"name": "Swordmaster", "constitution": 120, "archetype": "Bruiser", "passive": "seasoned",
		"max_hp": 165, "armor": 0.22, "parry_chance": 0.12,
		"passive_desc": "Seasoned Fighter: fights in one of two stances.\nAGGRESSIVE — +15% damage dealt, +10% damage taken.\nDEFENSIVE — 15% less damage taken, -10% damage dealt.\nStarts each battle Aggressive; Guard Change swaps.",
		"blurb": "Precision and technique — presses hard, then weathers the storm."},
	# The Pyromancer and Cryomancer are mirror-image glass cannons: armoured
	# in their own element, soft to the opposite — a fire warband and a frost
	# warband ask different questions of the same party.
	"pyromancer": {"name": "Pyromancer", "constitution": 85, "archetype": "Nuker", "passive": "overburn",
		"max_hp": 135, "armor": 0.08,
		"resists": {"fire": 0.30, "frost": -0.20},
		"passive_desc": "Overburn: +2% damage for every turn of Burn standing\non the enemy team, up to +40%. Every turn of Burn\nCONSUMED refunds 1 Mana.",
		"blurb": "Aggressive flame — spend everything, or the fire spends you."},
	# The passive ID stays "permafrost" (Batch AS renamed the PASSIVE to
	# GLACIAL HOLD; the id is a key battle.gd matches on, like the
	# Survivalist's spec id "mystic", and renaming it buys nothing).
	"cryomancer": {"name": "Cryomancer", "constitution": 85, "archetype": "Control", "passive": "permafrost",
		"max_hp": 135, "armor": 0.08,
		"resists": {"frost": 0.30, "fire": -0.20},
		"passive_desc": "Glacial Hold: Chilled stacks the Cryomancer applies\nnever expire, and a Frozen enemy stays Frozen\nINDEFINITELY — it leaves the turn order until Ice Lance\nor Shatter releases it, or a new freeze passes the limit\nof ONE held enemy (which frees the oldest). Nothing else\nthaws it: not ally damage, not Blizzard, not time. A held\nenemy takes +15% damage from all sources and comes back\non 1 stack of Chilled. Bosses resist the freeze until\nBroken and shrug a hold after one turn.",
		"blurb": "Battlefield control — you decide when the enemy acts."},
	# The Arcanist's health bar is a resource he spends (like the Devout's):
	# Resonance bills him a COMPOUNDING damage-taken penalty and Cannon recoils
	# 15%, so he carries the class's biggest pool — and no armor to speak of,
	# because raw energy in robes stops nothing that closes the distance.
	"arcanist": {"name": "Arcanist", "constitution": 90, "archetype": "Ramp", "passive": "resonance",
		"max_hp": 155, "armor": 0.06,
		"resists": {"arcane": 0.20, "shadow": 0.10, "physical": -0.15},
		"passive_desc": "Runaway Resonance: damaging casts build stacks (2 on a\ncrit), with NO MAXIMUM, and nothing removes them. Each\nstack deepens the one before it — damage dealt and\ndamage taken both climb faster the more are held — and\neach stack adds +1% critical chance.",
		"blurb": "Unstable raw magic — nothing early, everything late."},
	"holy": {"name": "Holy", "constitution": 100, "archetype": "Healer", "passive": "mercy",
		"max_hp": 150, "armor": 0.10,
		"resists": {"holy": 0.20, "shadow": -0.15},
		"passive_desc": "Mercy: a stack is gained when an ally falls below 50%\nhealth (max 5). Each stack: +5% healing done. Stacks pay\nfor Hymn of Hope and talent abilities, or one Empowers a\nheal — Empowered casts forgo their Perfect bonus.",
		"blurb": "Pure vessel of light — mercy hardens into miracles."},
	"inquisitor": {"name": "Devout", "constitution": 110, "archetype": "Warder", "passive": "conviction",
		"max_hp": 175, "armor": 0.18,
		"resists": {"holy": 0.15, "fire": 0.10, "shadow": -0.10},
		"passive_desc": "Conviction: allies build Faith whenever Divine Shield\nabsorbs damage for them — 2 a hit, max 5 stacks, doubled\nunder Blessing of Zeal. Each stack: 2% damage mitigation\nand +1.5% damage dealt, PAID ON THE HIGHEST COUNT HELD\nTHIS BATTLE. Apostle adds another 1x and Fervor another\non Consecrated Ground, so both together are triple, not\nquadruple. At 5 the ally is healed for {mhp:15|ally}, and\nthe COUNT resets while the peak does not. The Devout\nrecovers {res:3}, carries Faith as well, and that count\nnever releases.",
		"blurb": "A living shrine — faith made armor for the whole party."},
	"occultist": {"name": "Occultist", "constitution": 95, "archetype": "Pressure", "passive": "old_gods",
		"max_hp": 155, "armor": 0.08,
		"resists": {"shadow": 0.25, "nature": 0.10, "fire": -0.20},
		"passive_desc": "Wrath of the Old Gods: every debuff applied marks the\ntarget with 2 Ruin. The marks have NO MAXIMUM and never\nwash off. Each stack: +2% damage taken, and heroes\nstriking a Ruined target heal 2% of the damage dealt per\nstack (up to 40%). One turn after every tenth stack, Ruin\ndetonates — 90% of Attack as shadow damage, the party\nheals {mhp:25}, and THE STACKS SURVIVE IT.",
		"blurb": "Forbidden rites — leech life and trade blood for power."},
	# Hunter stat blocks (Batch Q). The Beastmaster's armor is a multiplier
	# across up to three bodies — companions inherit it at summon — so it
	# sits below the Survivalist's despite similar Constitution.
	"beastmaster": {"name": "Beastmaster", "constitution": 100, "archetype": "Ramp", "passive": "pack",
		"max_hp": 160, "armor": 0.15,
		"resists": {"nature": 0.20, "physical": 0.05},
		"passive_desc": "Pack Bond — the active companion grants its boon. Ursus,\nSavage Presence: enemies are drawn to the bear and the\nBeastmaster takes 10% less damage. Canis: +15% damage per\nenemy under 35% health. Aguila: the whole party gains\n+10% crit. LOYALTY (per companion, NO MAXIMUM): +1 each\nturn the companion stands, and on summon or swap; +5%\nstrike damage per stack plus a companion-specific gift,\nand the boon itself grows 20% a stack — x2 at five. A\nmeter dies with its companion.",
		"blurb": "The wilds hunt beside them — every kill is shared."},
	# The lightest Hunter: a marksman who wants to be at range and pays for
	# being reached.
	"sharpshooter": {"name": "Sharpshooter", "constitution": 90, "archetype": "Nuker", "passive": "lethal_aim",
		"max_hp": 140, "armor": 0.10,
		"resists": {"nature": 0.10, "physical": -0.10},
		"passive_desc": "Lethal Aim: critical hits deal x2 damage instead of\nx1.5. Each consecutive attack against the same enemy\ngrants +20 FOCUS (NO CEILING; cleared on switching\ntargets, 50 retained on a kill). The first 100 points\neach grant +0.5% critical chance; every point past 100\ngrants +0.5% CRITICAL MULTIPLIER instead.",
		"blurb": "Every arrow an execution — patient, precise, final."},
	# The toughest Hunter by design: his passive rewards being struck and
	# Tripwire wants him in the fray. Deep nature affinity from a life
	# spent in it; raw arcane is the thing the woods teach nothing about.
	"mystic": {"name": "Survivalist", "constitution": 100, "archetype": "Pressure", "passive": "trapper",
		"max_hp": 170, "armor": 0.18,
		"resists": {"nature": 0.25, "shadow": 0.10, "arcane": -0.15},
		"passive_desc": "Trapper: enemies that strike the Hunter have a 25%\nchance to be Poisoned for 5 turns, and the Survivalist's\nabilities deal +8% damage per DIFFERENT status effect\nafflicting the target.",
		"blurb": "Endures the wilds and bleeds them dry — traps, powder, and steel."},
}


static func spec_abilities(spec: String) -> Array:
	match spec:
		"berserker":
			return [
				Ability.make({"display_name": "Bloodlust", "cost": 25, "damage": 26,
					"pressure": 18, "delay": 3.0, "anim": "attack02", "heal_missing": 0.3,
					"resource_gain": 10, "cooldown": 2,
					"perfect_id": "", "perfect_text": "Heals 45% of missing HP",
					"description": "Strike and drink deep: heals the Warrior\nfor 30% of their missing HP. Builds 10 Rage."}),
				Ability.make({"display_name": "Wildstrikes", "cost": 35, "damage": 16,
					"pressure": 14, "delay": 4.5, "anim": "attack03", "aoe": true,
					"bleed_build": 35, "bleed_chance": 0.5, "resource_gain": 10, "cooldown": 3,
					"perfect_id": "", "perfect_text": "Bleed lands on every target",
					"description": "Savage sweep: hits ALL enemies; each\nhas a 50% chance to build 35 Bleed.\nBuilds 10 Rage."}),
				Ability.make({"display_name": "Hack and Slash", "cost": 20, "damage": 10,
					"pressure": 10, "delay": 3.0, "anim": "attack01", "multi_hits": 3,
					"perfect_extra_hit": false,
					"bleed_build": 25, "bleed_chance": 0.5, "resource_gain": 10, "cooldown": 2,
					"perfect_id": "", "perfect_text": "Bleed lands on every strike.",
					"description": "Three savage cuts at one target; each\nhit has a 50% chance to build 25 Bleed —\na full flurry can bleed them out.\nBuilds 10 Rage."}),
			]
		"warden":
			# VAULTED — Retaliation (counter stance): kept for future return.
			# Shieldwall v1 (party -25% damage, 2 turns) was DELETED in Batch
			# AB: Batch G had already replaced it and its leftover machinery
			# was applying nothing. The live Shieldwall is the Block stance.
			# Damage %s are tuned against the Warden's 75 Attack (Tank role):
			# Mocking 27% ≈ 20, Crushing 43% ≈ 32 — the pre-scaling numbers.
			return [
				Ability.make({"display_name": "Mocking Blow", "cost": 0, "damage": 27, "pressure": 15,
					"resource_gain": 10, "delay": 2.0, "anim": "attack01", "cooldown": 1,
					"perfect_id": "", "perfect_text": "Taunts last 5 turns",
					"description": "Strike and humiliate: the target AND\none other enemy must attack the Warrior\nfor 4 turns. Builds 10 Rage."}),
				Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 43,
					"pressure": 20, "delay": 3.0, "anim": "attack03", "resource_gain": 10,
					"cooldown": 2,
					"applies_status": {"id": "sunder", "turns": 3},
					"perfect_id": "", "perfect_text": "+5 bonus BD",
					"description": "Moderate damage. Sunders armor\n(-35%) for 3 turns. Builds 10 Rage."}),
				# Shieldwall graduated from the talent tree (Batch G): his one
				# moment of control over the Block identity belongs in the base
				# kit. Batch AB made it a STANCE — it and Interpose were the
				# same verb pointed two ways, and the self-directed half was
				# the stronger. He now guarantees the line and gambles for
				# himself; the wd_shieldwall node buys duration.
				Ability.make({"display_name": "Shieldwall", "cost": 25,
					"special": "shield_block", "delay": 1.5, "anim": "attack01",
					"cooldown": 2,
					"perfect_id": "", "perfect_text": "",
					"description": "Set the wall: +25% Block chance for\n3 turns. These count as HEAVY PLATING\nblocks, so they feed Tenacity and\nRally — Interpose's charges never do."}),
			]
		"swordmaster":
			return [
				Ability.make({"display_name": "Overpower", "cost": 25, "damage": 15,
					"pressure": 20, "delay": 2.5, "anim": "attack02", "resource_gain": 10,
					"cooldown": 1,
					"perfect_id": "rage5", "perfect_text": "+5 bonus Rage",
					"description": "Exploits instability: +0.5 damage per\npoint of the target's Break meter;\na Broken target is held Broken one\nturn longer. Builds 10 Rage."}),
				Ability.make({"display_name": "Pommel Strike", "cost": 20, "damage": 25,
					"pressure": 30, "delay": 2.0, "anim": "attack01", "resource_gain": 10,
					"cooldown": 3,
					"applies_status": {"id": "stunned", "turns": 1},
					"perfect_id": "", "perfect_text": "The Stun lands even on a boss.",
					"description": "A skull-ringing bash with a keen 25%\ncrit chance: ALWAYS Stuns for 1 turn.\nBuilds 10 Rage.\nBosses resist Stun until Broken —\nunless the strike is PERFECT."}),
				# Batch AK put Guard Change back in the opening three (see
				# trimmed_kit_ability for why) — not a free action on
				# purpose: turn-less actions need engine support, so the
				# swap does double duty (stance, pressure, refuel) at a
				# bargain 1.5 initiative. The 1cd stops spam.
				Ability.make({"display_name": "Guard Change", "cost": 0,
					"special": "guard_change", "delay": 1.5, "anim": "attack01",
					"cooldown": 1, "resource_gain": 15,
					"perfect_id": "", "perfect_text": "+10% Parry chance for 2 turns",
					"description": "Shift to the other stance mid-flow.\nThe pivot presses the opening: 15 BD\nto the enemy nearest to Breaking.\nBuilds 15 Rage."}),
			]
		"pyromancer":
			# Burn-centric kit (07-16 rework; the core Magic Bolt becomes
			# Fireball via apply_kit_overrides). Batch AR made Detonation the
			# win condition and re-specced Flame Shield into Immolate, so the
			# spec has no defensive option anywhere in kit or tree — that is
			# deliberate, and it is the whole point of the commitment spec.
			# Pyroblast and Phoenix Rebirth came OUT of the vault as tree
			# nodes. STILL VAULTED: Flame Surge (20 Mana, 15% AoE cone).
			return [
				Ability.make({"display_name": "Detonation", "cooldown": 2, "dmg_type": "fire", "cost": 25,
					"damage": 25, "pressure": 20, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also applies 2 turns of Burn",
					"description": "The narrow release valve: consumes ONE\ntarget's Burn, adding 250% of its\nremaining damage (tick × turns left\n× 2.5) to this hit. Overburn refunds\n1 Mana for every turn consumed."}),
				Ability.make({"display_name": "Wildfire", "cooldown": 3, "dmg_type": "fire", "cost": 20,
					"damage": 0, "pressure": 10, "delay": 2.5, "anim": "attack02",
					"special": "wildfire",
					"perfect_id": "", "perfect_text": "Consumes 2 turns from each",
					"description": "The WIDE release valve: every burning\nenemy loses a turn of Burn and takes\n18% of Attack in fire. Detonation\nempties one bank; this one skims them\nall — and Overburn refunds every\nturn it takes."}),
				Ability.make({"display_name": "Flamewave", "cooldown": 2, "dmg_type": "fire", "cost": 25,
					"damage": 15, "pressure": 5, "delay": 3.0, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "3 turns of Burn",
					"description": "A rolling wall of fire rakes ALL\nenemies: applies 2 turns of Burn;\nthose already Burning burn 2 turns\nlonger instead."}),
			]
		"cryomancer":
			# Control kit (Batch O: Razor Ice concentrates on ONE target — the
			# spec's win condition is 4 stacks on a chosen enemy, so its main
			# applier stopped scattering them). VAULTED — kept for future
			# return: Frost Bolt (25 Mana spear, 50% double vs unchilled).
			return [
				Ability.make({"display_name": "Razor Ice", "cooldown": 3, "dmg_type": "frost", "cost": 25,
					"damage": 15, "pressure": 10, "delay": 2.5, "anim": "attack02",
					"multi_hits": 3, "perfect_extra_hit": false,
					"applies_status": {"id": "chilled", "turns": 3},
					"perfect_id": "", "perfect_text": "Deals {atk:25}",
					"description": "Three razor shards driven into ONE\ntarget; every shard applies a stack\nof Chilled — three quarters of a hold\nin a single cast."}),
				Ability.make({"display_name": "Blizzard", "cooldown": 4, "dmg_type": "frost", "cost": 30,
					"damage": 15, "pressure": 10, "delay": 3.5, "anim": "attack03", "aoe": true,
					"perfect_id": "", "perfect_text": "Two stacks of Chilled on every enemy.",
					"description": "Storm of ice rakes ALL enemies,\nlayering 1-2 stacks of Chilled\non each. It does NOT thaw a hold —\nno damage does."}),
				Ability.make({"display_name": "Ice Lance", "cooldown": 2, "dmg_type": "frost", "cost": 25,
					"damage": 35, "pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Deals 20 BD",
					"description": "A frozen spear driven deep: +5% of\nAttack per Chilled stack on the target,\nand it ALWAYS crits against Frozen\ntargets. Cast on a HELD enemy it is\nthe RELEASE — the ice breaks and the\nenemy returns on 1 stack of Chilled."}),
			]
		"arcanist":
			# Resonance-engine kit (07-20 rework; core Magic Bolt becomes Arcane
			# Explosion via apply_kit_overrides). BATCH AT: **DEATH RAY IS OUT
			# OF THE VAULT AND STABILIZE IS IN THE SPEC POOL.** Stabilize was
			# the escape hatch from the ramp — it vents the stacks the whole
			# spec exists to build — so it becomes something a player EARNS if
			# they want the safety valve back, and its def moved to
			# `trimmed_kit_ability` (exactly ONE def, the AK resolver rule).
			# Death Ray is what a ramp is FOR: a button greyed out for the
			# first four turns and then the only thing he wants to press.
			# Cannon KEEPS BD = 5 x stacks and its 15% recoil; its own
			# +7.5%-per-stack damage term is GONE — the passive compounds now,
			# and an ability-side per-stack term would square it.
			return [
				Ability.make({"display_name": "Arcane Cannon", "cooldown": 2, "dmg_type": "arcane", "cost": 25, "damage": 40,
					"pressure": 0, "delay": 3.5, "anim": "attack02", "recoil_base": 0.15,
					"perfect_id": "", "perfect_text": "Costs 3.0 initiative",
					"description": "Channel raw Resonance into a blast:\n40% of Attack, and BD = 5 x current\nstacks. Recoil: the Mage takes 15%\nof the damage dealt."}),
				Ability.make({"display_name": "Arcane Barrage", "cooldown": 2, "dmg_type": "arcane", "cost": 20, "damage": 8,
					"pressure": 3, "delay": 2.5, "anim": "attack03", "random_hits": 6,
					"perfect_extra_hit": false,
					"perfect_id": "", "perfect_text": "No two bolts strike the same enemy.",
					"description": "Six bolts hound the weakest: each\nstrikes one of the 2-3 enemies with\nthe lowest health."}),
				# BATCH AU: gate 5 -> 8 Resonance, cost 40 -> 55 Mana. At twelve
				# stacks it lands 325% of Attack in one hit, so it is a genuinely
				# LATE button now rather than a turn-five one — and at a Mage's 22
				# regen, 55 Mana is most of three turns' saving with Cannon and
				# Barrage competing for the same pool. Damage, initiative, cooldown
				# and target count are UNCHANGED and it still consumes nothing.
				# STILL NO BREAK DAMAGE — reported, not acted on (see CLAUDE.md).
				Ability.make({"display_name": "Death Ray", "cooldown": 3, "dmg_type": "arcane", "cost": 55,
					"damage": 150, "pressure": 0, "delay": 5.0, "anim": "attack03",
					"gated": true,
					"perfect_id": "", "perfect_text": "",
					"description": "The payoff: 150% of Attack as arcane\nto one enemy. Unusable below 8\nResonance — and it CONSUMES NO\nSTACKS. The ramp never comes down."}),
			]
		"holy":
			# Mercy kit (07-22 rework): heals scale off the CASTER's max
			# health; Mercy stacks fuel Hymn and Empowered casts. VAULTED —
			# kept for future return: Dawnbreak (20 Mana flat 40, overflow).
			#
			# BATCH AV — FOUR ABILITIES, WHERE EVERY OTHER SPEC HAS THREE, AND
			# THAT IS DELIBERATE. Resurrection is the thing that most means
			# "nothing is final", and as a row-5 node it was a pick most builds
			# skipped. She attacks at 50, so her abilities are not PART of her
			# contribution — they are all of it, and the parity break buys the
			# identity. Its def is NOT copied here: `pending_talent_ability`
			# stays the single source (the AK resolver rule), because the Rune
			# of the Last Rites still grants it by name and both must read the
			# same numbers. It LEFT `SPEC_POOLS["holy"]` for the same reason.
			return [
				Ability.make({"display_name": "Heal", "cooldown": 1, "cost": 20, "special": "holy_heal",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Cleric also recovers {mhp:5}",
					"description": "Mend an ally for 40% of the Cleric's\nmax health. Empower (1 Mercy): also\ncleanses all harmful effects."}),
				Ability.make({"display_name": "Renewal", "cooldown": 3, "cost": 20, "special": "renewal",
					"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Also heals 5% of the Cleric's health instantly",
					"description": "Ally heals 15% of the Cleric's max\nhealth at the start of each of their\nturns, for 5 turns. Empower (1 Mercy):\nRenewal also blankets the Cleric."}),
				Ability.make({"display_name": "Hymn of Hope", "cooldown": 2, "cost": 0, "faith_cost": 1,
					"special": "hymn", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "Heals 25%",
					"description": "Spend 1 Mercy: heal ALL allies for\n20% of their max health. Empower\n(+1 Mercy): 35% instead."}),
				pending_talent_ability("Resurrection"),
			]
		"inquisitor":
			# Conviction kit (07-23 rework). VAULTED — kept for future return:
			# Divine Wrath (25 Mana party +15% damage/speed) and the old flat
			# Divine Shield. Sacred Resolve (ex-Unity) and Bulwark of Fortitude
			# are talent-granted (pending_talent_ability).
			return [
				Ability.make({"display_name": "Divine Shield", "cooldown": 2, "cost": 15, "special": "divine_shield",
					"target": Ability.Target.ALLY, "delay": 2.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "Grant an ally a holy shield that\nabsorbs 35% of the Devout's max\nhealth, then breaks."}),
				Ability.make({"display_name": "Consecrated Ground", "cooldown": 3, "cost": 25, "special": "cons_ground",
					"delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "Holy ground blooms underfoot: the\nparty takes 15% less damage and\nreflects 10% of damage taken,\nfor 3 turns — and every ally is\nkindled 1 Faith at the start of\ntheir turn while it holds."}),
				Ability.make({"display_name": "Blessing of Zeal", "cooldown": 2, "cost": 20, "special": "zeal",
					"target": Ability.Target.ALLY, "delay": 2.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "",
					"description": "Kindle an ally: +15% damage for\n4 turns, their cooldowns tick down\n1 turn NOW, and their Faith gain is\ndoubled while the zeal burns."}),
			]
		"occultist":
			# Old Gods kit (07-24 rework). VAULTED — kept for future return:
			# Umbral Sigil (20 Mana warband brand) and the old Mind Flay
			# (maddened abilities at +100% BD). Mass Hysteria and the new
			# Mind Flay are talent-granted (pending_talent_ability).
			return [
				Ability.make({"display_name": "Hex of Ruin", "cooldown": 2, "dmg_type": "shadow", "cost": 20, "damage": 20,
					"pressure": 15, "delay": 2.5, "anim": "attack02", "choose_three": true,
					"applies_status": {"id": "exposed", "turns": 3},
					"perfect_id": "", "perfect_text": "No cooldown",
					"description": "Curse THREE chosen enemies: 20% of\nAttack in shadow each, leaving them\nExposed for 3 turns."}),
				Ability.make({"display_name": "Bewitch", "cooldown": 4, "cost": 25,
					"special": "bewitch", "delay": 3.5, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "Charm a mind — for 3 turns the target\nbasic-attacks its OWN allies, Dazing\nthem with every strike — and one of\nthose strikes lands at once.\nA BOSS RESISTS UNTIL BROKEN."}),
				Ability.make({"display_name": "Dark Pact", "cooldown": 3, "cost": 20,
					"special": "dark_pact", "delay": 3.0, "anim": "attack02",
					"perfect_id": "", "perfect_text": "Restores 5 Mana",
					"description": "Bleed for them: lose 20% max health;\nevery OTHER ally heals 15% of their\nmax health, and the Occultist regains\n30% of max health over 3 turns."}),
			]
		"beastmaster":
			return [
				Ability.make({"display_name": "Summon Ursus", "cooldown": 3, "cost": 20, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the bear (110 HP): attacks with\nyou, striking your target AND adjacent\nenemies for 10% of your Attack.\nSavage Presence: enemies are drawn to\nUrsus; you take 10% less damage.\nOn arrival: GUARDIAN'S ROAR — taunts\nthe weakest enemy, bear takes 25% less\ndamage for 2 turns.\nLoyalty gift: +3% max health per stack."}),
				Ability.make({"display_name": "Summon Canis", "cooldown": 3, "cost": 20, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the wolf (80 HP): attacks with you\nfor 20% of your Attack, building\n20 Bleed. Always ELUSIVE: enemies miss\nit 25% more. Pack Bond: +15% damage\nper enemy under 35% health.\nOn arrival: BLOODHOWL — 15 Bleed\nto every enemy.\nLoyalty gift: +2 Bleed per stack."}),
				Ability.make({"display_name": "Summon Aguila", "cooldown": 3, "cost": 20, "special": "summon",
					"delay": 3.0, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Call the eagle (80 HP): attacks with you\nfor 20% of your Attack, applying\nExposed. Always ELUSIVE: enemies miss\nit 25% more. Pack Bond: the whole\nparty gains +10% crit chance.\nOn arrival: dives a chosen enemy for\n15% of your Attack, Dazing them.\nLoyalty gift: ignores 20% armor\nper stack."}),
				Ability.make({"display_name": "Hunter's Instinct", "cooldown": 3, "cost": 20, "special": "instinct",
					"delay": 2.5, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Empower your next 3 Quick Shots:\neach deals +10% of your Attack and\nheals your companion for 15% of\nits max health."}),
				Ability.make({"display_name": "Kill Command", "cooldown": 3, "cost": 30, "special": "kill_command",
					"delay": 4.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "The companion gains 1 Loyalty",
					"description": "The order depends on the companion —\nUrsus: mauls for 45% of your Attack\nplus 40 Break damage. Canis: 3 bites\nof 18% Attack, 10 Bleed each; the wolf\nfeasts, healing 30% of its max health.\nAguila: strikes TWO chosen enemies for\n25% Attack, BLINDING them 3 turns.\nRequires a living companion.\nThe Pack: BOTH companions obey."}),
			]
		"sharpshooter":
			return [
				Ability.make({"display_name": "Aimed Shot", "cooldown": 1, "cost": 20, "damage": 45,
					"pressure": 15, "delay": 3.0, "anim": "attack02",
					"perfect_id": "focus20", "perfect_text": "+20 Focus",
					"description": "A perfect line. Patient, precise, final."}),
				Ability.make({"display_name": "Powershot", "cooldown": 2, "cost": 25, "damage": 20,
					"pressure": 20, "delay": 3.0, "anim": "attack03",
					"perfect_id": "", "perfect_text": "",
					"description": "+2% damage for every point of the\ntarget's Break bar already FULL —\nthe team breaks them, the marksman\nends them."}),
				Ability.make({"display_name": "Hold Breath", "cooldown": 3, "cost": 15, "special": "hold_breath",
					"delay": 1.5, "anim": "attack01", "no_skill_check": true,
					"perfect_id": "", "perfect_text": "",
					"description": "Patience made literal: gain +40 Focus,\nand your next attack is a GUARANTEED\ncritical that ignores all armor."}),
			]
		"mystic":
			return [
				Ability.make({"display_name": "Tripwire", "cooldown": 4, "cost": 20, "special": "tripwire",
					"delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "",
					"description": "Rig the ground: for 6 turns, retaliate\nagainst EVERY attacking melee enemy —\neven those striking your allies."}),
				Ability.make({"display_name": "Shrapnel Charge", "cooldown": 2, "dmg_type": "nature",
					"cost": 25, "damage": 20,
					"pressure": 25, "delay": 3.0, "anim": "attack03", "choose_two": true,
					"applies_status": {"id": "cripple", "turns": 3},
					"perfect_id": "status_plus", "perfect_text": "Adds Slowed; everything lasts 4 turns",
					"description": "A scattering charge rips TWO chosen\nenemies for 20% of Attack as nature\ndamage each,\nleaving them Poisoned AND Crippled\n(3 turns). Two statuses on two targets\n— the engine of the hunt."}),
				Ability.make({"display_name": "Snare Trap", "cooldown": 3, "cost": 20, "special": "snare_trap",
					"delay": 2.0, "anim": "attack01",
					"perfect_id": "", "perfect_text": "",
					"description": "Rig a snare on one enemy: the next\ntime it acts, it is STUNNED for 1 turn\nand Poisoned for 4. The stun lands even\non a boss."}),
			]
	return []

const CLASS_BLURBS := {
	"hunter": "Ranged damage. Mana fuels precision payoffs\nand primal magic.",
	"warrior": "Flexible frontliner. Rage builds through attack and pain.",
	"mage": "Glass cannon. Fire that spreads, frost that controls, and\nraw Resonance banked for devastating payoffs.",
	"cleric": "Divine vessel of the light — smite, mend, and shepherd the party.",
}
