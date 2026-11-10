# Batch JS — The Frozen Plains

**On `class-merge`, after JR (`2d603b5`, JR's commit). IMPLEMENT ONLY, under the designer's floor — balance is the designer's, judged by playing; a batch's only job is making sure its code works (`docs/ways-of-working.md`): no balance drive of any kind ran — no arm, no pairing, no predicted balance figure, no grade re-read, no completion figure.** `git ls-remote origin class-merge` read `2d603b5`, JR's push and local HEAD, before anything ran (2026-11-09, 11:57:06, `push_open.txt`). **The designer's files were backed up first** (`../save-backups/JS-20261109-115706`) and read only through copies; md5s at the open and the close, §6.

**What shipped.**
- **§1 — the Frozen Plains, a second candidate at slots 1 and 3.** The Icewrought Titan its boss, roster 4 its opener and roster 5 its finale; the Scarlands keeps slot 2 alone and a run stays three zones. **Every run draws a slot of two** — a player's and a sim's alike — so a run is one of four shapes; `DOD_ZONE_ROTATION=0` holds a sim to each pool's first. The twelve kinds tagged for all three old rosters take both new ones; each new roster fields four to six bodies in about two fight nodes of three, as the old ones do. The zone wears the Forest's backdrop, a named placeholder, and the two Forest events dealt by slot now name their zone.
- **§2 — six kinds**, each at its role's Attack, each second move the least whole damage that clears JI's line with its cooldown the line's band, frost-resistant and soft to fire, slower and more armoured than the kind a stated rule picks for each; the Hoarfrost Warden heals and Raises on the warband's Malice, and the Stillwrought is Sap's second carrier. The line's reference board stands, so no existing kind's band moved.
- **§3 — the Icewrought Titan**, whose Entomb freezes one hero for one turn; a Block or a miss lays nothing, Ironclad and Hallowed refuse it, a cleanse lifts it. No rung tag.
- **§4 — the count, on the fights where the warband attacks**: 62 of them, the number beside every row, its two zeros explained and driven.
- **§0 — the state's ceiling raised 440 → 520 KiB** where HY set it, with its reason; `CLAUDE.md` stays at 510.

**JR's five rulings**, accepted as taken under the brief's standing instruction, went to the archive struck, one line each below. **JS's own choices** — the draw, the six kinds' figures, the charge as a declared blow, the Titan's figures, the backdrop, the core that travels and the Forest's events — are each taken on the recommendation and owed with their reversal: seven items, NEEDS A RULING. The deck is closed at twenty-five.

**What it cost the documents**: `CLAUDE.md` +42 B written (511,063 B, 10.92 KiB under its 510); `docs/state.md` +13,533 B net — 18,190 B written and 4,657 B archived — at 461,660 B, 69.16 KiB under its new 520 at the close, and under ES's +13,700 B, the largest single-batch growth on record, which the preamble's alarm reads.

**Verification** (§6): **the Frozen Plains, its six kinds and the Icewrought Titan are in the game, and they work as built.** The pre-run of record and the acceptance each read every target with the two carried reds and nothing else, `check_de` 757 / 0 / 0; the new gate `check_js` reads 79 / 0 — the zone, the draw a player gets, the shares the composer fields, the six at JI's line, the Warden's heal and the Titan's freeze driven on real boards; **64 controls read as wanted on the tree that lands**, and HEAD's code and documents under the final gate red without throwing; all 489 positional reads hold; and the count — 62 fights where the warband attacks — holds byte for byte off three batteries. Seven choices are owed, each with its reversal; nothing waits on a reply.

## THE BRIEF's PREMISES, VERIFIED

Each was checked at source on HEAD's frozen copy (`lanes/read0`, `2d603b5`), by me or by the blocks' reader (`route/opened_reader.md`, written
12:31, before the first edit reached a lane at 12:34). **The brief stays wrong where it was wrong** — every departure is named here.

| # | the brief says | verdict |
|---|---|---|
| 1 | the push check reads JR's push and local HEAD | **True**: `2d603b5`, origin and local HEAD, read at 11:57:06 (`push_open.txt`). |
| 2 | §0 JR closed the state at 437.62 KiB, 2.38 KiB under its 440 | **True**: 448,127 B. |
| 3 | §0 *520 KiB, about 5.6 batches at JG's 14,605 B* | **Half**: 5.6 is the 80 KiB the raise adds (81,920 / 14,605 = 5.61); the room at JR's close under 520 KiB is 84,353 B = 82.38 KiB, 5.78 batches. |
| 4 | §0 JR read 286,191 B of 449,926 and derived which part | **True** (`docs/reports/JR-routing.md`). |
| 5 | §0 written where the ceiling is set (HY), with its reason | **True, and the reason was already there** (*THE CEILING's JOB WAS TO BOUND WHAT A BATCH READS, AND THE ROUTING DOES THAT NOW*). **Not said**: `check_jj` §1 pins the number (`CEILING_KIB := 440`) — re-pointed at 520 with JS's raise recorded; and two more places state 440 (the index's preamble and THE PLAYTEST'S OTHER FINDINGS), each moved. |
| 6 | §0 `CLAUDE.md` stays at 510, where it closed 10.96 KiB under | **True**; and one of its sentences states the state's ceiling (*JJ §1 raised that file's to 440 KiB … the two ceilings are 972,800 B now*), stale the moment §0 lands: one clause edited, +24 B. |
| 7 | §0 JR's rulings are not in the brief; accept them all | **Taken**: the block went to the archive struck and answered; JS's seven stand in its place, the core's by role. |
| 8 | §1 `run_state.gd` says random draws stay behind `DOD_ZONE_ROTATION=1` *until each pool holds ~2 candidates* | **Half**: the comment says *with today's single-candidate pools both modes draw identically*; and since IW §0.3 the flag is the sim's — a player's run takes each pool's first, so turning the flag on cannot reach a player (`check_iw` §0.3 drives it). The question is the player's door, and `check_iv` §2's latent arm reds the day a pool holds two: JS's ruling 1. |
| 9 | §1 *a second candidate at slots 1 and 3 gives four run shapes* | **True only with the door**: under the fixed order a player meets one shape, and the Frozen Plains never. |
| 10 | §1 `ZONE_DEFS`' shape, the forest's `{1: 1, 3: 3}`, *take the next two roster ids* | **True**: rosters 1–3 in use; the Frozen Plains takes 4 and 5. |
| 11 | §1 *the talent economy of ~35 points a run assumes 3 zones × 11 tiers* | **False**: no comment in the tree says it. Talents are meta (one point a class a zone boss, three a run); every zone runs `SLOTS_PER_ZONE`, 16 slots. The *11* echoes the run report's known-wrong wipe band (THE RUN REPORT'S WIPE TABLE). |
| 12 | §1 *it keeps 11 tiers like the others* | **The direction holds, the figure does not**: no zone carries a tier count; it keeps the sixteen slots every zone runs. `SLOT_COUNT` stays 3. |
| 13 | §1 every kind tagged for all of 1, 2 and 3 takes both new rosters; the Ashblade is the Scarlands' | **True, and the derivation names twelve**: ten drawn kinds, the Orc Chief (fielded by the elite themes) and the Hollow Crown (never composed): JS's ruling 6. Six kinds are neither core nor exclusive (the Whelp, Slinger, Totemist, Wolfrider, Bog Troll, Ash Hurler) and do not travel either. |
| 14 | §1 a roster must field four to six bodies | **True of both**: four to six in 66.0% and 65.1% of fight nodes, beside 61–70% for the old three (`check_js` §1, derived). |
| 15 | §1 `zone_name` keys in the battle and map background dicts; *do not crash on a missing key* | **Half**: there is a third dict, the event screen's, and **nothing crashes today** — all three already fall back to the Forest's art. C05 breaks the fallback to bite. |
| 16 | §1 *find the fifth thing* (a save key, a wipe band, an achievement, the recap) | **Found, in two parts**: the event screen's background dict, and two events written for the Forest and dealt by slot (the Old Spring, the Echo of the Warden) — keyed to their zone (JS's ruling 7). The save keeps the zone's id and name (no version moved: FOUND AT JS); the wipe table and the zone multipliers key on the slot's place; there is no achievement; the recap prints the name. |
| 17 | §2 *adding an enemy is a JSON edit, not a code change* | **Half**: true for a blow, a status and a spend; **false for a heal under a new name** — `_enemy_support_action` casts heals by display name, so a new name is never cast. The Warden's heal is the warband's Healing Wave. |
| 18 | §2 the player owns *Chilled, Rime, Frostbind, Glacial Hold, Bitter Cold, Frostbite* | **Half**: four are statuses; *Glacial Hold* is the Cryomancer's hold on `frozen` and *Bitter Cold* a freeze's spread. No new status was authored either way. |
| 19 | §2 role Attack *Damage 100 / Tank 75 / Support 50*; *Hex Bolt's 44 at Attack 50 prices 22* | **Half**: no code defines the role's Attack — it is each kind's `attack`, by the master document's convention (`check_js` §2 now holds it, C07); 44 at Attack 50 **deals** 22, and the line **prices** it 26.86, its Break in the sum. |
| 20 | §2 each second move clears JI's 1.4× line with Break in the sum, as JN §1 and JO §1 did | **True**: each the least whole damage that clears it; every band the rule's (`docs/reports/JS-kinds.tsv`). |
| 21 | §2 the Hoarfrost Warden's Malice spend is a Raise | **Half**: a Raise alone holds neither a Rally nor an Entrench, which every kind can buy (`check_jk` §1 reds it); it holds a Raise and an Entrench, as the other Raise holders do (ruling 2). |
| 22 | §2 *do not drop it for being a fourth mender* | **Half**: the fifth mender-tagged kind in the game (the Totemist, Shaman, Ritual Chanter and Grave Totem before it), the fourth in roster 5. Kept. |
| 23 | §2 Sap at 0.15% of hero turns *because* the Orc Hexer appeared in 2 of JQ's 56; *if JR has already moved that weight* | **Half**: 2 of 56 is JQ's count; 0.15% is JM's drive uptime, a different population (JR's premise 5); **there is no weight** — JR moved tags. Together: with JR's *sniper* tag the Orc Hexer is in 16–19% of every old roster's fights (9–10% without it); the Stillwrought adds one in roster 5 alone (a finale fields a carrier in 22.4%). Neither makes the other redundant. |
| 24 | §2 the roles system enrolls each in every theme that wants its role | **True**: listed in THE FROZEN PLAINS; nothing is fielded where it should not be. The Stillwrought sits in no elite theme and not in the Boss Escort (no hexer role); frost bodies appear under the themes' old names (a Hailcaster in a *Poison Volley*), on the LOOK-LIST. |
| 25 | §2 the Rimehorn's *telegraphed charge* | **Taken as the plate's declaration**: every warband move is declared a turn ahead, and a Break move reads *crush*; the Ash Hurler's wind-up would tell the player a single blow strikes every ally (ruling 3). |
| 26 | §3 *the designer has confirmed a hero can be Frozen*; `frozen` beside `stunned` in `_apply_status`'s head; Ironclad refuses it | **True**: the turn loop asks no `is_hero`; Ironclad refuses it by name; Hallowed refuses it too (`DEBUFF_IDS`). **No enemy laid it before**: the Titan is the first freeze of a hero in play. |
| 27 | §3 what `frozen` does to a hero | **One turn a turn of the status**, passed by before the turn's own tick; damage does not end it; defences do not change; the chip names the Cryomancer's hold (on the LOOK-LIST). |
| 28 | §3 can it be blocked, missed or cleansed, on JO ruling 5's shape | **All three**, driven in `check_js` §3: a Block and a miss lay nothing; a cleanse lifts it; Ironclad and Hallowed refuse it; a parry does not stop it (the strike loop lays a status on any blow that did not kill). |
| 29 | §3 the end boss's rung filter | **True**: the Titan carries no rung tag and reads the same at every rung (`check_js` §3, `test_batch_bm` §6). |
| 30 | §3 *the sweep will flag* Icewrought against the Ash-Wrought Tyrant | **False**: run three ways (and by stem), the sweep meets nothing for the Titan — the stem sits at a compound's end, which none of the four tests reads; nor the Gravewrought Coin, a relic. No exact hit for any new name; the near-misses are in FOUND AT JS and below. |
| 31 | the brief's *WHY THE FULL FLOOR*: the zone *moves the ability corpus*, *THE LADDER's authored count* and *LIVE COUNTS* | **Half**: the ability corpus is the heroes' (233, unmoved) and LIVE COUNTS holds no enemy figure; THE LADDER's count moves (76 → 98 authored warband abilities); master §9's table and `run_state.gd`'s comment move, and master §3's *every pool holds one candidate today* too. |
| 32 | §6 *all 489 positional reads* | **True** (489 rows). |
| 33 | §6 *a recon is owed* | **True**, run on the candidate (§6). |
| 34 | the floor, the expected writing | **The brief states none**: JS stated its own before any document edit (`s1/EXPECTED_WRITING.md`, born 12:11:43). |
| 35 | §2 *slower and more armoured than its equivalent elsewhere*; the Thrall *slow* | **True by the rule JS states, and only by it** (ruling 2; `check_js` §2 derives each equivalent): the first kind of its role, power and enemy role the Forest's opener roster fields, one that does not travel (not tagged for every old roster) first. Against every kind of the role it is not so — the Orc Raider beside the Thrall is slower and more armoured, the Orc Archer as armoured as the Hailcaster — and the Thrall at speed 100 is above the old non-boss median (97.5), so among its role and power it is *slow* against the Whelp alone (five old kinds are faster: the Whelp, the Wolfrider, the Ashblade, the Ritual Chanter and the Grave Totem). The master's row says *slower than the Whelp*. |

## THE RULINGS, AND WHERE EACH IS WRITTEN

JR's five (accepted as taken under the brief's standing instruction, written before JR reported) are struck in `DoD-archive/state-archive.md` under `## ARCHIVED AT JS`, one line
each here: **1.** the three carriers' tags stand (the Grave Totem in roster 2, the Rot Behemoth in roster 1, the Orc Hexer a sniper); **2.** the
citation sweep's reach stands (the held records at their counts); **3.** a citation's tree stands (`docs/reports/JR-citations.tsv`); **4.** a
trigger met by the row's own stands (*Cleanse Debuffs*); **5.** the look-list's rows from JI to JQ stand passed. The one living citation of
them, the look-list's *JR's ruling 5*, reads *accepted at JS §0*. JS's seven stand in `docs/state.md` under `### JS's RULINGS OWED`, CORE by
role, and below under NEEDS A RULING.

## §0 — THE STATE's CEILING, 520 KiB

The preamble's sentence, where HY set it and JJ raised it, reads 520 KiB, the reason beside it the one that raised it at JJ grown stronger —
the routing bounds what a batch reads (JI 166,750 B of 365,181; JJ 203,915 B of 379,111; JR 286,191 B of 449,926), so a ceiling on the
whole file prices a read nobody takes — and JJ's 440, about five batches at JG's rate, kept beside it as the record JS's raise
superseded. The 80 KiB the raise adds is 5.6 batches at JG's 14,605 B written. **The archive's method is untouched**, and JS archived what
its rulings closed: JR's five and FOUND AT IW's first item (§1). Three more places stated 440 — the index's preamble, THE PLAYTEST'S OTHER
FINDINGS and `CLAUDE.md`'s sentence on the two ceilings (972,800 B → 1,054,720 B) — and each moved; `check_jj` §1, which held 440, holds
520. `CLAUDE.md` stays at 510.

## §1 — THE FROZEN PLAINS

**THE ZONE** (`scripts/run_state.gd`): `ZONE_DEFS` gains `frozen_plains` — *The Frozen Plains*, boss `icewrought_titan`, rosters `{1: 4, 3: 5}`
— and `SLOT_POOLS` reads `[["forest", "frozen_plains"], ["scarlands"], ["forest", "frozen_plains"]]`. `SLOT_COUNT` stays 3, and the zone runs
the same sixteen slots as every zone. The comment above them says what changed and names the third background dict.

**THE DRAW, AND WHY IT IS EVERY RUN's (JS's ruling 1).** Since IW §0.3 `DOD_ZONE_ROTATION` was the sim's, and a player's run took each pool's
first author: with a second candidate that is a zone no player draws, the defect the brief says it would be embarrassing to ship, and
`check_iv` §2's latent arm reds the day a pool holds two. So `draw_zones` draws within a pool of two for every run — `pool.pick_random() if
pool.size() > 1 and rotation_enabled() else pool[0]` — and `rotation_enabled` is `not (sim_run and DOD_ZONE_ROTATION == "0")`: a player's run
never reads the flag, and a sim keeps one arm, `=0`, which holds it to each pool's first author. A pool of one takes its zone with no die.
**What it costs**: the draw spends two dice at `new_run`, so every seeded gate that starts a run rolls its fights anew (§6).

**THE KINDS THAT TRAVEL, DERIVED.** Every kind tagged for rosters 1, 2 and 3 takes 4 and 5: the Orc Raider, Archer, Shieldmaster, Shaman,
Hexer, Brute, Ritual Chanter and Bloodcaller, the Rot Behemoth, the Grave Totem, the Orc Chief and the Hollow Crown — twelve (ruling 6). The
Ashblade, the two old zone bosses and six kinds tagged for two rosters do not travel. **Roster 4 holds 16 kinds, roster 5 19**, and a fight node
fields four to six bodies in 66.0% and 65.1% of draws, beside rosters 1, 2 and 3's 69.6%, 61.4% and 66.6% (`check_js` §1, through
`Run._theme_combos`; `tools/draw_js.py` reproduces each).

**THE BACKDROP** (ruling 5): the battle's, the map's and the event screen's dicts name *The Frozen Plains* against the Forest's art, each with
a comment saying it is a placeholder; a zone no dict names falls back to the Forest's (`check_js` §1 drives a battle under each). On the
LOOK-LIST.

**THE FIFTH THING** (ruling 7): two events written for the Forest — the Old Spring (*a rotting wood*) and the Echo of the Warden (*the trees
here grow in the Warden's image*) — were dealt by slot because a slot was a zone. `Events.failed_reason` takes a `zone` requirement, read off
the run's own draw (`zone_draw`, never re-drawn), and the two carry `"zone": ["forest"]` beside their slots. The save keeps the zone's id (`zone_draw`) and name (no
version moved: FOUND AT JS); the wipe table, the multipliers, the pouch and the map's *Zone n of m* key on the slot's place; the profile's
boss tally keys on the kind; there is no achievement.

## §2 — SIX KINDS

`data/enemies.json`, tint and scale over the orc sheet (`docs/reports/JS-kinds.tsv` keeps every figure). **The figures, derived**: each basic
at its role's Attack; each second move the least whole damage that clears JI's line with its Break in the sum (`check_ji.line_blow`; a point
less falls under it); every cooldown and every spend's cooldown the line's band (`check_ji` §1a, `check_jk` §2). **The signature**: frost
+50%, fire −25%, each slower and more armoured than the kind it stands for — picked by one rule, which `check_js` §2 derives: the first
kind in data order of its role, power and enemy role that the Forest's opener roster fields, a kind of the Forest's own before one that
travels (ruling 2). It is not true against every kind of the role: the Orc Raider beside the Thrall is slower and more armoured still,
and the Orc Archer as armoured as the Hailcaster.

| kind | role, power, enemy role | stands for | health, armour, speed | basic | second move | multiple, band | spend |
|---|---|---|---|---|---|---|---|
| Frostbitten Thrall | skirmisher 1, damage | the Whelp (0.05, 115) | 95, 0.07, 100 | Numb Claws 33, Break 12 | Hobbling Bite 46, Break 18, Slowed 2 at 70% | 1.406, 2 | Rally, 3 |
| Icebound Bulwark | bulwark 2, tank | the Shieldmaster (0.25, 85) | 190, **0.40**, 65 | Ice-Shod Bash 38, Break 26 | Glacier Press 38, **Break 70** | 1.407, 2 | Entrench, 3 |
| Hailcaster | sniper 1, damage | the Slinger (0.08, 100) | 85, 0.10, 92, ranged | Hailstone 24 frost, Break 18 | Hailstorm 8 frost, Break 8, every hero, Dazed 2 | 1.425, 2 | Rally, 3 |
| Rimehorn | brute 3, damage | the Orc Brute (0.20, 75) | **300**, 0.24, 68 | Gore 42, Break 30 | Trampling Charge 52, **Break 64** | 1.416, 2 | Rally, 2 |
| Hoarfrost Warden | mender 2, support | the Orc Shaman (0.01, 100) | 130, 0.08, 90, ranged | Chill Touch 32 frost, Break 12 | Healing Wave (25% of its target's health; priced on the median body, 127.5) | 1.581, 2 | Raise, 3; Entrench, 4 |
| The Stillwrought | hexer 2, support | the Orc Hexer (0.05, 95) | 120, 0.10, 88, ranged | Stillbolt 46 frost, Break 14 | Leaching Stillness 58 shadow, Break 30, Sap 3 | 1.415, 2 | Entrench, 4 |

**THE REFERENCE BOARD STANDS.** JI's line prices a heal on the median composable body (127.5) and a Rally on the median basic (36.595), and
six kinds at the wrong figures would move both — the Orc Raider's Rally sits 2% above its band's edge (the blocks' reader's H6). Three of the
six healths sit at or under 125 and three at or over 130, three basics at or under 36.25 and three at or over 36.94, so both medians stand to
the fourth place and no existing kind's band moved (ruling 2; `check_js` §2 holds the board).

**TWO OF THE SIX DO A SECOND JOB.** **The Hoarfrost Warden** heals with the warband's Healing Wave — the name `_enemy_support_action` casts
by, so it needs no new branch — at one Malice a point restored (since JJ), and holds an Entrench beside its Raise (`check_jk` §1). It is a
content-hole kind by construction: a basic, a heal and two spends. **The Stillwrought** lays Sap on Leaching Stillness, 3 turns as Bone Rattle
does (`check_jl` §5 writes the hexes' sentence off the last carrier in data order); a fight in roster 5 fields a Sap carrier in 22.4%, where a
Forest finale fields one in 19.2%.

**WHERE THE ROLES ENROLL THEM** (the brief's premise): the Thrall in every theme with a skirmisher pool (eight fight themes, the three elite
themes, the Boss Escort); the Bulwark in seven fight themes, two elite and the escort; the Hailcaster in six fight, three elite and the
escort; the Rimehorn in the Monster Den, the escort and two elite themes, of which only the Rage Company can field it (an Elite Patrol's chief,
bulwark and mender leave no room for a power-3 brute under an elite's 10); the Warden in seven fight themes, the Elite Patrol and the escort; the
Stillwrought in five fight themes and none of the others. None is fielded where its role is not wanted.

**THE NAMES**, swept three ways (and by a word's first five letters) against 1,044 names (`sweep/namesweep_js.txt`; the carried tool read no
enemy's name until JS's copy read `unit_name`): no exact hit. Contained or sharing a word: *The Frozen Plains* holds the status *Frozen*;
*Frostbitten Thrall* sits beside *Frostbite*; *Icebound Bulwark* beside the `bulwark` role, *Bulwark Line* and *Bulwark of Fortitude*;
*Rimehorn* holds the Cryomancer's *Rime*; *Hoarfrost Warden* holds the bargain card *Hoarfrost* and *Warden* three ways (the Warrior's
lineage, the second rung, the Withered Warden); *the Stillwrought* and its moves near *the Still Wrist*; *Numb Claws* holds the Bog Troll's
*Claw*; *Trampling Charge* the Warrior's *Charge*; *Glacier Press* and *Glacier Fist* near *Glacial Hold*; *Chill Touch* near *Chilled*. All are
labels in the warband's namespace, which nothing resolves by name: they ship and are flagged (BR §1).

## §3 — THE ICEWROUGHT TITAN

`icewrought_titan` — boss, power 7, roles `["boss"]`, rosters 4 and 5, 460 health, armour 0.32, speed 75, Attack 100, the tank's role,
scale 4.4 (ruling 4). **Glacier Fist** (frost, 44, Break 24) its basic; **Entomb** (frost, 60, Break 40, one hero, `frozen` 1 turn, cooling 2 —
1.412 of its basic); an **Entrench** (3). **What `frozen` does to a hero**: the turn loop passes the turn by before the turn's own tick —
*is frozen solid and loses their turn* — and the clock ticks on the lost turn, so a freeze of one turn costs one turn; damage does not end
it; no defence asks it. **What stops it**: a Block and a miss lay nothing, Ironclad and Hallowed refuse it at the status door, a cleanse lifts
it; a parry does not (the strike loop lays a status on any blow that did not kill). A boss's own immunity is a target's and never stands in its
way. An Umbral Mirror rebound sends it to the Titan, a boss, who refuses it unbroken; a Swordmaster's Feint redirects the declared
Entomb onto the Titan's fellow, and an escort that is no boss takes it for a turn; a companion struck by it loses nothing, having no
turn of its own (FOUND AT JS). **No rung tag**: its kit reads the same at every rung.
The comment in `_recast_writes` that counted `frozen`'s one call site now says the strike loop lays it too — on a hero, on the Titan by
a rebound, on an escort by a Feint — and that the error stays the safe one. **One turn**, held at the data by `check_js` §3: the card's
*a turn lost*, the master's two rows and the changelog state it.

## §4 — THE COUNT, ON THE FIGHTS WHERE THE WARBAND ATTACKS

`docs/reports/JS-count.tsv`, off recon 1's logs (`tools/count_js.py`, JP's definition unchanged: a fight opens at `Enemy warband:`, and
it is one where the warband attacks when it carries no attacks-off skip and at least one blow opened by a warband body). **62 such
fights of the 342 the logs hold** — 268 with enemy attacks off, 11 with attacks on and no warband blow, and **one set apart**:
`check_js` §3's lost-turn board, whose four Entombs the gate's own hand casts through `_resolve` while the warband takes no turn of its
own (the new text's reader found JP's definition would have credited them to the Titan; the table counts that fight in a row of its own).
Every row carries the 62 beside it.

| what | count, of 62 |
|---|---|
| fielded: the Frostbitten Thrall / Icebound Bulwark / Hailcaster / Rimehorn / Hoarfrost Warden / Stillwrought / Icewrought Titan | 2 / 1 / 1 / 1 / 1 / 1 / 1 |
| second moves cast: Hobbling Bite / Glacier Press / Hailstorm / Trampling Charge / Healing Wave / Leaching Stillness / Entomb | 4 / 2 / 3 / 4 / **0** / 3 / 1 |
| Sap laid on a hero or a companion, by carrier: the Orc Hexer / the Stillwrought | 2 / 3 |
| Frozen laid on a hero or a companion; a hero's turn lost to it | **0**; **0** |

A cast is counted once though an area move prints a line a body it strikes: Hailstorm's three casts are 15 lines (four heroes and a
companion each); the fresh reader found the first table counting the lines.

**THE ZEROS, EXPLAINED.** **The Healing Wave**: the Wardens' one fight is `check_jq` §4's three-Warden board; their bodies took nine
turns of their own there, nine blows, and declared the Wave on none — a Raise that stood a fallen Warden up with 56 health rode one of
them (a spend is bought beside a body's action, JL §1), and two more turns were lost to stuns; the Berserker's Mocking Blow mocked two
Wardens at once and one again later, and a taunt forces a blow. The choice itself is `check_js` §2's drive: a body in
the Warden's kit hurt by a quarter, with a pool that pays, is handed the Wave by `_enemy_support_action`, and with an empty pool is
not. **Frozen**: the Titan's one fight (`check_jq` §4, alone on its board) cast Entomb once, at the Holy, and missed; `check_js` §3 drives
the landing, the Block, the miss, Ironclad, Hallowed, the cleanse and the lost turn — exactly one each, on a board where every hero is
held off the timeline while it is struck. **A count, nothing compared**: the seven are met through `check_jq` §4's one fight a kind and
the composed fights' one meeting with a JS kind (`check_gf`'s Thrall), so how often a player meets a kind is `check_js` §1's
derivation, never this table.

## §5 — WHAT IS DELIBERATELY NOT DONE

No balance drive, and the untalented line stays retired. No fourth slot. No status authored (`check_js` §2 holds `STATUS_INFO` at its 168
ids). No new special or handler: the Warden's heal reuses its name, the Rimehorn's charge is a declared blow, the freeze rides a blow. No
per-kind art; the backdrop is a named placeholder. No dial pulled — the Cleric's cut, JO's seven and JN's ten stand (`check_js` §5 and the
twelve re-pointed gates — six digests and the counts and kept tables beside them — each reading the warband its batch left). No existing kind's stats, kit or tags moved but the twelve core kinds'
two roster tags. The Scarlands keeps slot 2 alone. No grade re-authored; the deck stays closed at twenty-five. No second forest boss: a
Forest→Scarlands→Forest run meets the Withered Warden twice, and a Frozen→Scarlands→Frozen run the Titan twice. The brief's left-standing
list is untouched. `CLAUDE.md` is not cut and stays at 510.

## FOUND AT JS AND NOT FIXED

The state's six items (`docs/state.md`, FOUND AT JS), and three the report alone carries, for the state's room.

- **A JS SAVE OPENED IN AN OLDER BUILD PLAYS THE FOREST, WITH RAIDERS WHERE THE FROST KINDS STOOD** (JS §1): no version moved — the zone's
  id and the new kinds' ids are values an older build reads generously (IB §0.2's rule), taking the zone as its slot's first candidate
  (`_drop_stale_save_keys`) and an unknown kind as an Orc Raider (`Enemies.config`'s fallback). Nothing crashes; the run reads wrong.
- **A SEEDED GATE THAT STARTS A RUN ROLLS ITS FIGHTS ANEW, AND A SIM's ROAD IS NOT THE FOREST's** (JS's ruling 1): the draw spends two
  dice at `new_run` — a seeded road reads them anew and can follow the draw into the Frozen Plains — `check_gf`'s, `check_gp`'s, `check_gv`'s and `check_gj`'s did at JS's recon, and `check_gp`'s count rose 458 → 484 (HEAD's code with JS's data reads 458); every other seeded row held its count. A sim meets the Frozen Plains in three runs of four and `run_sim`'s per-slot tables mix the two zones,
  so a figure compared against one of record, taken on the Forest's road, is retaken with `DOD_ZONE_ROTATION=0`.
- **A SINGLE-PICK CLEANSE TAKES SAP BEFORE THE FREEZE, A PARRY DOES NOT STOP IT, A FEINT CAN SEND IT TO AN ESCORT, AND A COMPANION
  SPENDS IT** (JS §3): JQ §2's aim takes a hex first, so a hero sapped and frozen in the Titan's fight (its escort can draw the Orc Hexer,
  a sniper since JR) keeps the freeze; the strike loop lays a status on any blow that did not kill, so a parried Entomb freezes, where a
  Block and a miss do not; a Swordmaster's Feint redirects the declared Entomb onto a fellow of the Titan's, which freezes for a turn
  (`_recast_writes`' comment); and Entomb and Hailstorm reach a hero's companion — a frozen beast ticks with its master and has no turn to
  lose, so the blow's freeze is spent for nothing.
- **THE SIX's NAMES NEAR-MISS LIVE ONES, AND THE SWEEP IS BLIND TO A COMPOUND's STEM** (JS §2, §3; the list in `docs/reports/JS.md`):
  no exact hit; *Hoarfrost Warden* holds a bargain card's name and *Warden* three ways, *Rimehorn* the Cryomancer's *Rime*; and the
  three-way sweep never met *Icewrought* against *Ash-Wrought* or the Gravewrought Coin. Labels in the warband's namespace ship and are
  flagged (BR §1); each rename is one string and the designer's.
- **MOST OF `check_js`'s DOCUMENT NEEDLES BIND TO NO HOLDER IN THE PIN MANIFEST** (as JR named its four): the three backdrop needles (their path built at run time, so the file reads as missing), §0's ceiling sentence, its reason and its record and the rulings' reversal word, §6's readings and projection, §2's reads of `docs/master.html`'s enemy rows and of `JS-kinds.tsv`, and §4's of `JS-count.tsv` — a needle sweep
  through the manifest misses them, so it sweeps `check_js.gd` itself.
- **TWO CHEAP ROWS OF JS's SUBJECT ARE NOT BUILT** (THE RULES A GATE COULD CHEAPLY HOLD, the close-read): S2-046 (an enemy's self-cast is
  tagged `"ally"`) and S2-090 (a zone boss node fields `boss_kind()`, never a roster's `boss`-tagged kind — the Titan is one in rosters 4
  and 5). The brief keeps the cheap gates standing; both stay rows on the standing list, unbuilt, as FOUND AT JG records its own.
- **THE NAMES' NEAR-MISSES** (§2, §3; every hit in `sweep/namesweep_js.txt`): two sit inside the warband's own namespace — *Hobbling
  Bite* beside the Wolfrider's *Lunging Bite*, and *Glacier Fist* beside the Rot Behemoth's *Rotting Fist*, a core kind that can stand in
  the Titan's own fight; *Chill Touch* names the Cryomancer's Chilled and lays nothing; *Frostbitten* sits beside
  the player's Frostbite; *Icebound Bulwark* beside the `bulwark` role, *Bulwark of Fortitude* and *Bulwark Line*; *Trampling Charge* holds
  the hero card *Charge*; *Numb Claws* the Bog Troll's *Claw*; *Glacier Press* and *Glacier Fist* sit near *Glacial Hold*; *Stillbolt* is
  *Frostbolt*'s compound, which the sweep's stem test cannot see; *Rimehorn* holds *Rime*; *Hoarfrost Warden* the bargain card *Hoarfrost*
  and *Warden* three ways; *the Stillwrought* sits near *the Still Wrist*. Each is a label in the warband's namespace, which nothing resolves
  by name.
- **THE ZONE's REFUSAL SENTENCE IS REACHED BY THE DEBUG PICKER ALONE** (§1): no choice carries a `zone` key, so *Only in the Forest of Old
  (the heroes are in the Frozen Plains).* shows nowhere a player goes today; JS wrote its articles as the slot sentence beside it reads.
- **A COUNT OVER THE BATTERY's ATTACKING FIGHTS SEES THE FROZEN PLAINS THROUGH ITS GATES' BOARDS** (§4): as JR found for its carriers,
  `check_jq` §4 seats each kind once by hand and, in the attacking fights, the composed roads met a JS kind once (`check_gf`'s Thrall);
  with attacks off they fielded one in 87 fights (`check_gv` 55, `check_gp` 15, `check_gj` 14, `check_gf` 3), which the count does not
  read. How often the game fields a kind is `check_js` §1's derivation, never the count.

## NEEDS A RULING — SEVEN, EACH TAKEN ON THE RECOMMENDATION, NONE HOLDING ANYTHING UP

1. **THE DRAW IS THE GAME's: A SLOT OF TWO DRAWS FOR EVERY RUN (JS §1).** Since IW §0.3 the flag was the sim's and a player's run took each pool's first, so the Frozen Plains would be a zone no player draws (`check_iv` §2's latent arm reds the day a pool holds two). **Taken**: `Run.draw_zones` draws within a pool of two for a player's run and a sim's alike; a pool of one takes its zone with no die; the flag's one arm left is a sim's `DOD_ZONE_ROTATION=0`, holding it to each pool's first, which a player's run never reads. The draw spends two dice at a new run, so every seeded gate that starts one rolls its fights anew. **The alternatives**: the fixed order for the player (the Frozen Plains never met), or the Frozen Plains first in its pools (the Forest never met). **Reversing it** is `rotation_enabled`'s line and `draw_zones`' condition, and `check_iv` §2's and `check_iw` §0.3's arms.
2. **THE SIX KINDS' FIGURES AND NAMES (JS §2).** Health, armour, speed, tint and scale set against the kind each stands for (the Whelp, the Shieldmaster, the Slinger, the Orc Brute, the Orc Shaman, the Orc Hexer) — by one rule, `check_js` §2's: the first kind in data order of its role, power and enemy role that the Forest's opener roster fields, one that does not travel (not tagged for every old roster) before one that does; against every kind of its role it is not so (the Orc Raider beside the Thrall is slower and more armoured still, the Orc Archer as armoured as the Hailcaster); each basic off its role's Attack; each second move the least whole damage that clears JI's line; every cooldown the line's band; the riders' turns after the moves that already lay them; the moves' names, swept with no exact hit. **The healths and basics straddle the line's reference board** (its median body 127.5, its median basic 36.595), so no existing heal or spend is priced anew. **The Warden heals with the warband's Healing Wave**, the name `_enemy_support_action` casts by, and **holds an Entrench beside its Raise**, as the other Raise holders do — the brief's *Raise* alone reds `check_jk` §1, which every kind's Rally or Entrench answers. **The alternative**: figures that move the medians, and existing bands with them. **Reversing it** is the seven blocks of `data/enemies.json`.
3. **THE RIMEHORN's *TELEGRAPHED CHARGE* IS A DECLARED BLOW, NOT A WIND-UP (JS §2).** Every warband move is declared on the plate a turn ahead, and one whose Break exceeds its damage is declared a *crush*: Trampling Charge is one. **The alternative**: the Ash Hurler's `windup`, whose chip says *heavy damage to every ally*, false on a single blow without a handler line changed. **Reversing it** is the move's `special` and the chip's line.
4. **THE TITAN's FIGURES (JS §3).** A freeze of one turn, the ordinary freeze's, on Entomb, a single frost blow at JI's line (cooldown 2); Glacier Fist its basic, Entrench its spend; 460 health, armour 0.32, speed 75, Attack 100, the tank's role as the Withered Warden's — slower than it and less armoured (0.32 against 0.35): the six's signature is theirs, not the boss's — scale 4.4 as the zone bosses'. **The alternatives**: a longer freeze, or a heavier Entomb in a longer band. **Reversing it** is the Titan's block.
5. **THE FROZEN PLAINS WEARS THE FOREST's BACKDROP (JS §1).** No art exists; the battle's, the map's and the event screen's dicts name the zone against the Forest's art — the cooler of the two, and each dict's fallback — with a comment saying it is a placeholder. **The alternative**: the Scarlands' red. **Reversing it** is three strings; the art is the designer's.
6. **THE CORE THAT TRAVELS IS EVERY KIND TAGGED FOR ALL THREE OLD ROSTERS, THE ORC CHIEF AND THE HOLLOW CROWN AMONG THEM (JS §1).** The brief's derivation read literally: twelve kinds. The Orc Chief is fielded by the elite themes from any roster that tags him, so the Frozen Plains' elites field him; the Hollow Crown is never composed, so its two tags read nothing. **The alternative**: the ten drawn kinds alone, which leaves the Frozen Plains' elite nodes no elite, so `compose` falls to its plain fallback at an elite's pay. **Reversing it** is two `zones` arrays — and JR's ruling 1's reversal now takes rosters 4 and 5 off the Grave Totem and the Rot Behemoth too.
7. **THE FOREST's TWO EVENTS NAME THEIR ZONE (JS §1, the fifth thing a zone keys on).** The Old Spring and the Echo of the Warden were dealt by slot because a slot was a zone. **Taken**: a `zone` requirement in `Events.failed_reason`, read off the run's own draw (`zone_draw`), the two keyed to the Forest beside their slots. **The alternative**: the Forest's words dealt in the Frozen Plains. **Reversing it** is the clause and the two `zone` keys.

## §6 — VERIFICATION

**WHAT MOVED IN THE GAME.** The tree that lands differs from HEAD in:
- **the game**: `data/enemies.json` (seven kinds appended; rosters 4 and 5 on twelve kinds' `zones`), `data/events.json` (two events take a
  `zone` key), `scripts/run_state.gd` (the zone def, the pools, `rotation_enabled` and `draw_zones`, their comments), `scripts/events.gd`
  (the `zone` requirement), `scripts/battle.gd`, `scripts/map_screen.gd` and `scripts/event_screen.gd` (one background key each; `battle.gd` a
  comment in `_recast_writes` too). **A fight runs through the new data and the draw; no line of the fight's own code moved**;
- **the gates and records**: the new gate `check_js.gd`; twelve gates re-pointed (`check_ji`, `check_jj`, `check_jk`, `check_jl`, `check_jm`,
  `check_jn`, `check_jo`, `check_jp`, `check_jq`, `check_jr`, `check_iv`, `check_iw`); `run_battery.sh`, `baselines.json`, `pin-manifest.json`;
- **the documents**: `docs/state.md`, `DoD-archive/state-archive.md`, `docs/master.html`, `docs/combat-rules.md`, `CLAUDE.md` (two clauses: the two ceilings' sentence and the IW §0.3 flag rule),
  `docs/changelog.html`, `docs/design-notes.md`;
- **three kept files** in `docs/reports`: `JS-routing.md`, `JS-kinds.tsv`, `JS-count.tsv`, and this report.

**THE PUSH CHECK.** `git ls-remote origin class-merge` read `2d603b5`, JR's push and local HEAD, at 11:57:06 (`push_open.txt`), before
anything ran.


**THE ORDER, AS THE FOLDER SHOWS IT** (each time read off the file's own stamp; a file's time is its last write unless *born* is said), in time order.
1. **The open, 11:57:06–11:57:07**: the push check, the open readings, the open md5s, the user-data count (621) and the backup.
2. **The routing of record** (`route/JS-routing.src.md`), 11:59:31, before any edit; HEAD frozen for the blocks' reader (`lanes/read0`, 12:00:18).
3. **The expected writing** (`s1/EXPECTED_WRITING.md`), born 12:11:43, before any document edit.
4. **The blocks' reader's findings** (`route/opened_reader.md`), 12:31:55, before the first edit reached a lane (`lanes/h1`, born 12:34:05).
5. **The code stage**: HEAD's gates on JS's code and data on `lanes/h1`–`h1c` (12:34:19–12:37:44); the re-points on `lanes/c1`–`c1c` (12:41:51–12:43:34).
6. **Recon 1's lane frozen** (`lanes/r1.md5`, 13:01:16, 746 files); its prediction born 13:01:28, before the launch (`logs/r1.out` born 13:01:52); a correction appended at 13:03.
7. **The readers' copy frozen** (`lanes/read1.md5`, 13:02:04); the readers' prompts (13:03:13–13:04:00); their findings: the close-read 13:20:01, positional B 13:23:50 and A 13:24:12 (last written), the new text's reader 13:34:41.
8. **The readers' repairs** (the edit scripts; `lanes/f1` rebuilt at 13:22 and 13:49); the prediction's board reading corrected by append at 13:42:21, before the recon ended.
9. **Recon 1 ended** at 14:35:52 (`EXIT 0`); the side-by-side traces — HEAD on HEAD (`lanes/h1c` rebuilt, 14:36:59–14:41:15), HEAD on JS's code and data (`lanes/h1`, 14:41:34–14:45:22), HEAD's code with JS's data (`lanes/h1c`, 14:51:28–14:55:43); the count kept off its logs (`kept/JS-count.tsv`, born 14:36:59); a time correction appended to the prediction at 14:50:06.
10. **The documents' subset** on `lanes/f1` (14:47:22–15:06:05); the landing tree first built and frozen in `lanes/f1b` (14:56:27); the positional delta's reader (`route/positional_js_delta.tsv`, 15:02:13); the first control run (14:57:48–15:08:26); the literal sweep (15:04:58).
11. **The close stage**: `lanes/f1b` rebuilt with the routing's close lists, its subset on the identical `lanes/f1c` (15:09:58–15:15:01); the WHERE's count shortened for the growth record and the tree refrozen (15:11:39); the WHERE's readers (15:15:55–15:20:52) and the second control run (15:11:40–15:22:37) on it; the fresh reader's draft and copy (15:12:40; `lanes/read2`, 15:11:56).
12. **The fresh reader's findings** (`route/fresh_findings.md`, 15:34:36); its repairs; **the tree that lands rebuilt and frozen at 15:37:31** (`lanes/f1b.md5`, kept as `lanes/f1b_final.md5`, 747 files) — then the readers' subset (24 targets, 15:38:11–15:44:16), the last control run (`logs/ctl_land2/`, 15:37:49–15:47:53) and the literal
sweep (15:44:36) on it.
13. **The pre-run's prediction** born 15:48:23.398, 5.16 s before its launch marker (15:48:28.558); the pre-run ended at 17:22:33 (`EXIT 0`);
the count tool repaired (outside the tree) and both batteries' counts re-taken; the push check before the landing at 17:23:14; the landing
(17:23:21–17:23:31); the acceptance's prediction born 17:23:49.896, 5.8 s before its marker (17:23:55.714); the acceptance ended at
18:55:07 (`EXIT 0`); the listing gates on a clone of the repository with this report in (`lanes/lst`, 18:56:13–18:56:55: `check_jr` 81 / 0 with 217 documents held at zero, the report among them, and `check_hx`, `check_is`, `check_jc`, `check_jo` and `check_jp` at the acceptance's counts, every one 0 failures); the report landed last.

**THE PREMISES** (the table above, 35 rows): each checked at source on HEAD's frozen copy before an edit reached a lane, the last row
after the new text's reader named it.

**THE ROUTING OF RECORD** (`docs/reports/JS-routing.md`; its source `route/JS-routing.src.md`, born 11:59:31, before any edit): the
brief's seven subjects matched 65 rows, 4 population rows and one block the brief named by its words — 97 blocks, 291,772 B of HEAD's 448,127, each read whole. The CORE, the population rows, the close-read's 59 closed blocks and the upkeep are its
other lists. **The blocks' reader** (`route/opened_reader.md`, 12:31:55, before the first edit reached a lane at 12:34): the opened blocks
read whole and the premises checked at source. **Its sixteen HIGH, all taken**: the ceiling's raise reds `check_jj` §1 (re-pointed); the
draw a player gets owed its door (ruling 1); the fifth thing a zone keys on (ruling 7); the universal core holding all three of JR's
carriers (`check_jr` §1's tags read with the new rosters aside); every warband digest and count red on seven added kinds, which
`MOVED_SINCE` cannot carry (`ADDED_SINCE`, twelve re-points); the line's reference board, which six kinds at the wrong figures move
(the six straddle it); the Warden's *Raise* alone reds two gates (an Entrench beside it, ruling 2); the Titan's freeze on a blow, as JO's
ruling 5 shapes a hex; the Stillwrought's Sap at exactly 3 turns; the name sweep run three ways and by stem; the text pins the new moves
move; two false premises (*11 tiers*, *~35 points*); the count's population; archive only what the rulings close; the standing picks;
and the routing's heading spelled as `check_iu` §8 reads it.

**THE CLOSE-READ** (`route/close_read_findings.md` and `route/close_read.md`, 13:20:01): the 59 closed blocks read whole against the
finished work. **One plainly bore, its trigger matched, and the routing did not follow it** (THE RULES A GATE COULD CHEAPLY HOLD: its two rows of JS's subject, S2-046 and S2-090,
recorded unbuilt in FOUND AT JS); **seven arguably bore and were not routed**, each row now carrying the trigger that would have routed
it. In JS's own text **2 HIGH and 8 MEDIUM, every one taken**: `CLAUDE.md`'s IW §0.3 clause rewritten with its supersession recorded;
the count's words (then the fill's fallback) written off this recon; the spends' holders, the hexes' second carrier, the cooldowns'
heading, the stamp, the two standing-list rows, the sim figures' road, `events.gd`'s key list, and the latent-shapes row.

**THE NEW TEXT's READER** (`route/newtext_findings.md`, 13:34:41; on the readers' copy `lanes/read1`, frozen 13:02:04, with its own
scripts): every figure of the seven kinds, every draw share and the twelve core kinds recomputed by its own instruments; the twelve
re-points ask their questions. **3 HIGH, all taken**: H1 `CLAUDE.md`'s rule (repaired by the close-read's pass already, on the tree the
reader did not see); **H2 master §9's table, which no gate read — `check_js` §2 now reads each of the seven's rows** (power, roles,
rosters, health); **H3 the count would credit `check_js`'s own hand-cast Entombs to the warband, and the prediction said the reverse** —
the count sets that fight apart by target and fills its `why`, and `s1/PREDICT_R1.md` carries the correction appended in place.
**11 MEDIUM, all taken**: the Feint path in `_recast_writes`' comment and FOUND AT JS; the lost-turn drive made exact (every hero held
off the timeline while struck, exactly one turn each); the spends' counts; *thirty-two* spends keep the dead `delay`; master §3b's `zone`;
the comparator stated as a rule (`check_js` §2 derives it, ruling 2, premise 35, master's Thrall row); `JS-kinds.tsv` re-derived row by
row with the Warden's second spend; the freeze's one turn held (`FREEZE_TURNS`); `check_iw` §0.3's comment; `check_js`'s needles the
manifest cannot see named in FOUND AT JS; the sim's road. **Its LOW, all taken but one** — 1.41, the six's shares behind a door
(`check_js` §1), the gate's header, the board derived with the seven taken out, `ROSTERS_SINCE` dropped where nothing read it, the
WHERE's supersession wording, the combat rules' parenthetical, the recipe, the content hole's fourth, the share census, ruling 6, the
companion, the master's rosters note, the look-list's three lines, the FOUND index row, the changelog, the refusal sentence's articles,
and the roster read through `.get` — **and the name near-misses are listed here, in FOUND AT JS, not in the state**, for its room.

**ALL 489 POSITIONAL READS** (`docs/reports/IT-positional-census.tsv`; `tools/pos/`). On the readers' copy (`lanes/read1`): the
mechanical passes settled 189 (`route/pos_r1/`); **300 went to two readers outside the working read** (`route/positional_js_a.tsv`,
`_b.tsv`, 150 rows each): **145 STANDS, 113 LINE-SHIFT, 42 IN-PLACE, 0 OFF-SUBJECT, 0 UNPORTED** — one near miss named, the stamp
window's one character of margin. On the tree that lands against the readers' copy (`route/pos_f1b/`): 132 STANDS (nothing they read moved), 28 by window, 286 same by hunk, and **43 read by a third reader outside the working read** (`route/positional_js_delta.tsv`): **36 STANDS, 4 LINE-SHIFT, 3 IN-PLACE, none off-subject or unported** — the changelog's newest entry still JS's and longer; `check_is` §5's trigger lists, FOUND AT IW's row at its three-trigger floor and THE FROZEN PLAINS' then one byte under the 400 (since trimmed to 384); `check_is` §6's body. Before that reader, the repaired comment in `battle.gd`'s `_recast_writes` had sent 21 reads to it on its ordinary words — *held*, *tick*, *Feint*, *turns* — and was reworded to say the same without them; 8 needle hits remained, each judged. The close stage's tree and the fresh reader's repairs, each read again mechanically, send no read the reader did not judge.

**THE LITERAL SWEEP** (`tools/litsweep.py`, a 4-character floor, every file the tree's diff names, HEAD's copy against the tree):
on the repaired tree (`sweep/litsweep_f1_r2.tsv`), 29,388 literals over 33 files, 12 lost; on the tree that lands before its close (`sweep/litsweep_f1b.tsv`, 15:04:58), 29,392 over 34 files, **the same 12 lost with the same holders** — the state's words that went to the archive with JR's rulings and FOUND AT IW's item (*### JR's RULINGS OWED*, *behemoth*, *roles*, *three warband heals' log lines*, *Inert* and the rest, every holder re-pointed or reading the archive), *never to split this file* (a re-wrap in the preamble, still there flattened), *Inert* in `CLAUDE.md`'s rewritten flag clause (`test_batch_au`'s ability name, no document read) and `check_iv.gd`'s *mult* (no holder reads that file) — and its new literals `check_js`'s own words and two baseline notes, which no gate that holds them reads.

**THE CODE STAGE** (`lanes/h1`, `h1b` and `h1c`, HEAD's gates on JS's code and data, 12:34:19–12:37:44 — `h1c` rebuilt from HEAD at
14:36 for the side-by-side traces; `lanes/c1`–`c1c`, the re-points, 12:41:51–12:43:34): **HEAD's twelve
gates each red on JS's work** — `check_ji` 3, `check_jj` 1, `check_jk` 2, `check_jl` 3, `check_jm` 2, `check_jn` 1, `check_jo` 3,
`check_jp` 2, `check_jq` 1, `check_jr` 5, `check_iv` 2, `check_iw` 2 — each traced to a digest, a count or a door, and each re-point at
its gate's own intent turned it green on the code stage (`check_jj` §1 and `check_ji` §1f waited on the documents, green at the final
stage). The gates beside them (`check_hi`, `check_ht`, `check_iq`, `check_hk`, `check_ih`) read green there with HEAD's copy.

**THE NEW GATE, `check_js`** (§0–§6, 79 checks on the tree that lands; `check_parse` 261 with it):
- **§0**: JR's five struck in the archive and answered; JS's seven owed with their reversals; the ceiling at 520 KiB in the sentence
  `check_fg` §4 parses, its reason beside it and the 440 it superseded recorded.
- **§1**: the pools, the slot count and the slot it never takes; a roster for each slot it hosts; the core derived and no zone's own
  kind travelling; four to six bodies on each roster derived through `Run._theme_combos` for every budget `Run.battle_budget` rolls, and
  **every share the state records** (the six's, the four-to-six, roster 5's Sap carriers) derived the same way; the draw driven for a
  player's run and a sim's, and the sim's `=0`; the rosters each slot fields and the boss; the backdrop's fallback driven on two boards.
- **§2**: the six kinds' shape and Attack; the signature against the kind **a stated rule picks**, derived; each second move the least
  whole damage at JI's line and its band; the reference board with the seven taken out and in; no status authored; Sap's second
  carrier; **the Warden's Healing Wave chosen by the warband's own door, driven** (a body hurt by a quarter with a pool that pays: the
  Wave; an empty pool: none); the state's record of the figures; **`JS-kinds.tsv` re-derived row by row**; **master §9's seven rows**.
- **§3**: the Titan's data and its one-turn freeze; the freeze driven on a real board — a hit lands it, a Block and a miss lay nothing,
  Ironclad and Hallowed refuse it, a cleanse lifts it — and **exactly one lost turn each**, the four heroes held off the timeline while
  struck and put due together; no rung tag.
- **§4**: the kept count's denominator on every row and its `why`. **§5**: the warband as JR left it beside JS's additions, the Cleric's
  cut, the deck at twenty-five. **§6**: the readings and the player's files.

**THE CONTROLS** (`tools/ctl_js.py`: each on its own clone of the frozen tree, in one of three control lanes; the gate through `lane.sh`; its FAIL lines
read, never its count; a control may name the lines it must NOT red): **64 controls, every one biting as wanted on the tree that lands**
(`logs/ctl_land2/`, 15:37:49–15:47:53, after the dry check — every anchor asserted once, 49 operations applied and the fifteen that read
HEAD's files checked in their clones), **none reddening a line it must hold**; two read two gates each, so 66 verdicts. The same 64 read
the same way on the freeze before the fresh reader's repairs (`logs/ctl_land/`, 15:11:40–15:22:37). A first run on an earlier freeze
(`logs/ctl_final/`, 14:57–15:08) bit everywhere too and read twelve verdicts as missed for the driver's sake alone: eight
wants lacked the escaped apostrophe an array prints (`thrall\'s`), and the two two-gate controls asked each gate for the other's text — the
driver now takes a want list by gate. (Two controls share the id `R_jjh`, the HEAD arm of `check_jj`'s count and of its ceiling; both
ran, one JSON is kept.)
- **§1, the zone** — C01a the zone out of the pools, C01b at slot 2, C01c a fourth slot; **C01d the player's door shut** (`check_js` §1 and
  `check_iv` §2 each red on it); C02 one roster for both slots; C03 roster 4 starved below four bodies; C04 the Ashblade travelling; **C05
  the battle's background read with no fallback** (the arena throws, and the gate still names it and finishes).
- **§2, the six** — C06a–e each second move a point under JI's line, C06f–g a band off; C07 the Hailcaster's Attack off its role; C08 a
  status authored and laid; C09a the Warden dropped (its heal drive reds too), C09b the Stillwrought's Sap gone; **R01 a re-tune at the
  source** — the Hobbling Bite 46 → 47 reds the state's record, the line and the kept table.
- **§3, the Titan** — C10a no freeze, C10b Entomb at its own side, **C10c a two-turn freeze**; C11a `frozen` out of the debuffs (no cleanse,
  Hallowed lets it through), C11b an area Entomb (no miss), C11c a blocked blow laying it; C12 a rung tag.
- **§4–§6** — C13a the denominator's column gone, C13b a kind at nought with no word; C14a an old kind's health, C14b the Cleric's cut;
  C15a the ceiling left at 440 (`check_js` §0 and `check_jj` §1), C15b its reason gone; C16 a twenty-sixth card.
- **H01 — HEAD's code and data under the final gate**: 55 checks, 16 failures, no throw — the zone, the pools, the player's door, the six,
  Sap's carrier, the Warden, the kept table, master's rows, the Titan and both drives; §0, §4, §5 and §6 hold. **H02 — HEAD's documents**:
  74 checks, 12 failures, each on its want list — JR's rulings open, the archive's struck block, JS's owed, the ceiling at 440 and its
  record, the shares, the record of the figures, the kept tables gone, master's rows, the WHERE's reading; §3 and §5 hold.
- **THE RE-POINTS, EACH TWO-ARMED** — HEAD's copy of each of the twelve re-pointed gates reds on the tree (R_jih, R_jjh twice, R_jkh, R_jlh,
  R_jmh, R_jnh, R_joh, R_jph, R_jqh, R_jrh, R_ivh, R_iwh), and the tree's copy reds on the break it is about: an old kind's figure moved
  beside JS's additions (R_ji, R_jn, R_jo, R_jp, R_jq, R_jr), an eighth kind beside the seven (R_jjk, R_jkk, R_jlk, R_jmk), Sap on the Whelp
  (R_jlc, R_jmc, R_jrc), the Warden's Healing Wave recorded at 3 (R_jif), and the flag reaching a player's run (R_iw).

**RECON 1 — ON THE CANDIDATE** (`s1/PREDICT_R1.md`, born 13:01:28, before the launch at 13:01:52 (`logs/r1.out` born); the whole battery on `lanes/r1`, frozen
at 13:01:16 with 746 files; logs to `/tmp/dod_battery_js_r1`, emptied first; `logs/r1.out`, to 14:35:52, `EXIT 0`): **no parse error,
script error or timeout**; the carried reds alone, `check_cm_live` 13 / 5 and `check_gj` 70 / 1 (Tollkeeper's Bell, the same FAIL text
as HEAD's gate on JS's code and data); `check_iu` 185 / 2, §8's close lists; `check_js` 70 / 1, §4's kept count not yet written; `check_de` 757 /
2 on those two going redder. **Five rows rose, each traced side by side before it moved**: `check_ji` 86 → 93 and `check_jr` 79 → 81,
HEAD's gates reading the same on JS's code and data (their walks over the new kinds; the re-points moved no count); `check_ih` 98 → 100 and
`test_batch_bm` 777 → 784, HEAD's copies reading 98 and 777 on HEAD (14:36–14:37) and the new counts on HEAD's code with JS's data
(`lanes/h1c`, 14:55), their walks over the plates and the kinds; **`check_gp` 458 → 484, its seeded road re-rolled** — the helper answered 112 draft screens where
it answered 96 — HEAD's gate reading 484 on JS's code and data (`lanes/h1`, 14:41–14:45) and **458 on HEAD's code with JS's data**
(`lanes/h1c`, 14:51–14:55): **JS's draw moves it — its two dice and the Frozen Plains they send the road into (15 of its 59 fights field
a JS kind) — and the data alone does not.** That arm cannot tell the dice from the zone: under HEAD's code no pool holds the Frozen
Plains (the fresh reader's H1, which corrected the first reading here). `check_gv`'s, `check_gj`'s and `check_gf`'s roads crossed the
Frozen Plains too (55 of 133, 14 of 35 and 3 of 8 fights field a JS kind) and held their counts; every other row held, the seeded ones
with them. **The prediction**: its lines held but three — its `check_js` board reading (corrected by append at 13:42:21, before the
recon ended; H3 above), *a hero Frozen at least once* (none was; §4), and two rises it did not foresee, `check_ih` and `test_batch_bm`,
data walks; it predicted `check_ji`'s 93 and `check_jr`'s 81 outright and named `check_gp` among thirteen seeded rows that might move. A
second correction, appended at 13:03 after the launch, says `check_jq` §4's seven new fights are each a JS kind's.

**THE SUBSETS** (`tools/run_lane_gates.sh`, `tools/run_subset.sh`; stderr read in every log): on the code stage, HEAD's gates on JS's code and data (`lanes/h1`–`h1b`, 12:35–12:37) and the re-points (`lanes/c1`–`c1c`,
12:42–12:43); **the documents' subset — the 61 targets that read what JS edited** — on `lanes/f1` (14:47–15:06): green but `check_gj`'s
carried red and `check_iu` §8's upkeep line, which the close stage writes; **the close stage's seventeen** on `lanes/f1c` (15:09–15:15),
every one green, `check_iu` 185 / 0 with the routing's close lists in; and, once the WHERE's count line was shortened, **its fourteen
readers on those bytes** (`lanes/f1c` rebuilt identical to the frozen tree but its name, 15:15–15:20), every one green; and on the
tree that lands after the fresh reader's repairs, **the twenty-four readers of what those repairs touched** (15:38:11–15:44:16), every one
green. No parse or
script error in any of their logs; `test_batch_aj` and `test_batch_bx` print their own *0 FAILED*, `test_batch_bm` 784 / 0.

**THE FRESH READER** (`route/fresh_findings.md`; outside the working read, on the assembled draft `route/JS_draft_fresh.md`, 15:12:40, and the frozen
landing tree's copy `lanes/read2`, with its own scripts and no Godot): **the count reproduced byte for byte** (its own parser too: 342 /
268 / 11 / 1 / 62, every cell), **every share** (69.6 / 61.4 / 66.6 / 66.0 / 65.1%, the six's, roster 5's 22.4 / 15.6 / 8.1%), the kinds
per roster and the core, **every figure of `JS-kinds.tsv`** by its own line, the Break price, the sizes and both projections. **2 HIGH,
both taken**: H1, *the draw's dice, not the new kinds* — the HEAD-code-with-JS-data arm cannot tell the dice from the zone they send the
road into, so the recon paragraph, FOUND AT JS and `check_gp`'s baseline note now say JS's draw moves it and the data alone does not,
and name the three other roads that crossed; H2, the prediction's grade (three lines missed, not two). **7 MEDIUM, all taken**: Hailstorm
counted in casts (3, 15 lines) by `tools/count_js.py`, not lines; the expected writing set against what was written, archived and net;
the Hexer's share with JR's tag and without it (9.6 / 9.1 / 10.2%); the comparator rule worded as `check_js` runs it (one that does not
travel, not *the Forest's own* — which would pick the Archer and fail), in ruling 2, the premise and the gate's two comments; the
Thrall's *slow* given its population; the names' near-misses without *IN FULL*, the two inside the warband's namespace added; the code
stage's three lanes and `h1c`'s rebuild. **12 LOW, all taken**: two clauses of `CLAUDE.md`; the Wardens' nine turns (a Raise rides one)
and the two Mocked; the stage times; *six digests* among the twelve re-points; the routing's sum (with the core's 15 and the population's
16); the close-read's *routed*; the sweep's lost words; the Rimehorn's one elite theme; premise 27's pointer; the Wave's 25% of its
target; the composed roads' 87 fights with attacks off; JR's rulings accepted under the brief's standing instruction. The tree's repairs
were rebuilt from the edit scripts, the state held under the growth record (+13,533 B net against ES's +13,700), the tree refrozen and
read again.

**THE PRE-RUN OF RECORD** (`s1/PREDICT_PRERUN.md`, born 15:48:23.398, 5.16 s before the launch marker `logs/.pre_launch`, 15:48:28.558; the whole battery on
`lanes/f1b`, the tree that lands as frozen at 15:37:31 (`lanes/f1b_final.md5`, 747 files), through `lane.sh battery` with
`DOD_BATTERY_OUT=/tmp/dod_battery_js_pre`, emptied first; `logs/pre.out`, 15:48:28–17:22:33, `EXIT 0`; its 185 logs, every one written
after the marker): **every line of the prediction held but the count's, which held after a repair to the tool** — no parse error, script error or timeout (stderr read in all 185 logs); **the two
carried reds and nothing else** (`check_cm_live` 13 / 5, `check_gj` 70 / 1, Tollkeeper's Bell); `check_js` 79 / 0, `check_iu` 185 / 0,
`check_parse` 261 / 0, the twelve re-pointed gates 0 failures; **`check_de` 757 / 0 / 0 notices**, every moved row at its move
(`check_gp` 484, `check_ih` 100, `check_ji` 93, `check_jr` 81, `test_batch_bm` 784); the harness 22 / 382 / 8; the lane unmoved against its
freeze (747 files, 0 moved); the user-data folders 622; the player's files at their open md5s. **The count's repair, to the tool and not the tree**: `check_js`'s repaired lost-turn board now waits for the warband's turn, so its fight prints the attacks-off skip
and `tools/count_js.py`'s summary row counted it twice (269 off of 342); set apart before that row, the pre-run's logs and the recon's both
give `kept/JS-count.tsv` byte for byte, and the table never changed.

**THE ACCEPTANCE** (`s1/PREDICT_ACC.md`, born 17:23:49.896, 5.8 s before the launch marker `logs/.acc_launch`, 17:23:55.714; the whole battery in the
repository after the landing, `./run_battery.sh` with `DOD_BATTERY_OUT=/tmp/dod_battery_js_acc`, emptied first; `logs/acc.out`,
17:23:55–18:55:07, `EXIT 0`; its 185 logs, every one written after the marker): **every line of the prediction held** — no parse error,
script error or timeout (stderr read in all 185 logs); **the two carried reds and nothing else** (`check_cm_live` 13 / 5, `check_gj` 70 / 1,
Tollkeeper's Bell, the pre-run's FAIL text); `check_js` 79 / 0, `check_iu` 185 / 0, `check_parse` 261 / 0, the twelve re-pointed gates 0
failures; **`check_de` 757 / 0 / 0 notices**; the harness 22 / 382 / 8; **the count off its logs `kept/JS-count.tsv` byte for byte**;
the 33 landed files unmoved against the freeze; the user-data folders 622; the player's files at their open md5s.

**THE LANDING** **THE PUSH CHECK BEFORE THE LANDING**: `git ls-remote origin class-merge` read `2d603b5` again at 17:23:14, local HEAD the same
(`push_preland.txt`) — origin did not move while JS ran. **The landing** (`tools/land_js.py --go`, `logs/land.out`, 17:23:21–17:23:31): the
33 files of the frozen tree's diff against HEAD (`tools/land_list_js.txt`, the tree's own diff, `project.godot` aside), each copied only
because the repository held HEAD's bytes there (or nothing, for the four new files) and the tree held the freeze's bytes; the report
re-proved unread by any gate, held back to land last from the work folder. The repository's untracked `save-backups/` folder is not
JS's and is not committed.

**THE TWO READINGS, AND THE PROJECTION FOR JT** (the state's WHERE block states them; `check_js` §6 and `check_jr` §4 read them): **`CLAUDE.md`**: 511,021 B at the open
(11:57:07, `readings-open.txt`) and **511,063 B = 499.08 KiB at the close — 10.92 KiB under its 510**, +42 B written (the two clauses),
2.1 batches at JG's +5,329 B. **`docs/state.md`**: 448,127 B at the open and **461,660 B = 450.84 KiB at the close — 69.16 KiB under its
new 520**: +13,533 B net, 18,190 B written and 4,657 B archived (the archive 741,086 → 746,253 B with its heading), 4.8 batches at JG's
14,605 B written, and under ES's +13,700 B, the largest single-batch growth on record. **The expected writing** (`s1/EXPECTED_WRITING.md`,
born before any document edit): `CLAUDE.md` +0 within 0.5 KiB, and it wrote +0.04 KiB; the state about +14 KiB written, 4 archived and
+10 net, and it wrote 17.76, archived 4.55 and grew +13.22 — **3.8 KiB over on writing and 3.2 KiB over net**. **JR's projection for JS**:
5.75 KiB of room in `CLAUDE.md` and the state 11.89 KiB past its 440; JS closed with 10.92 and 69.16, the second against 520.
**PROJECTED FOR JT**: `CLAUDE.md` 10.92 KiB of room, 2.1 batches at JG's rate — at JG's writing JT closes with 5.71 KiB; the state 69.16
KiB, 4.8 batches — at JG's writing 54.90 KiB under its 520. JT's brief states its expected writing, or JT states its own before the work;
its condition reads the room less that.

**THE PLAYER's FILES**: the nine files under the live `Dawn of Decay` folder — the save, the profile, the relics, the settings and the five readout
files — read through copies only, each at its open md5 (`md5_open.txt`) after the recon, the pre-run and the acceptance alike; backed up
first at `../save-backups/JS-20261109-115706`. **The user-data folders read 622 at the close against 621 at the open**: the one new
folder is `Dawn of Decay IA f1`, made at 14:46 by the first Godot run in `lanes/f1`, a lane JS named fresh where an idle name should have
been reused; it holds that lane's scratch runs and is listed by `lane.sh spent`'s patterns.
