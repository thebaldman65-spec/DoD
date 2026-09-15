# Batch GJ — The final fight becomes observable

*Branch `class-merge`, from `e11d5bb` (GI); `git ls-remote origin class-merge` read `e11d5bb` before the push. `main` is
untouched.*

## NEEDS A RULING

1. **WHICH READING OF "THE END BOSS IS NOT SCALED BY THE DIFFICULTY MULTIPLIER".** The brief's two sentences cannot
   both hold at rung 3: *"it takes rung 2's values at every rung"* would take rung 3's ×1.30 off the end boss, and
   *"Rungs 2 and 3 must not move"* forbids that. **Built: the rung may not DISCOUNT it** — `Run.end_boss_mult`, the zone
   ladder with the rung floored at 1.0, EO's own shape for health — so rung 1 meets it at rung 2's values and rungs 2
   and 3 are bit-identical (§3b). **The other reading is one line** (drop the rung term), and it would field a rung-3
   end boss at 1,910 health and 334 Attack instead of 2,490 and 434.
2. **THE RUNG-1 WORDS ARE PROPOSED.** Two player-facing claims said the first rung halves every enemy, and §3 made
   them false for one:
   - the draft screen's Wanderer tooltip: *"Enemies at 50% strength, the end boss at full."* (was *"Enemies at 50%
     strength."*);
   - the glossary's *The Road*: *"WANDERER is the first: its enemies hit half as hard - all but the END BOSS - and it
     is where a profile with no talents belongs."*
3. **THE END BOSS'S TOOLTIP AND ITS READOUT NAME (GI) ARE STILL UNCONFIRMED.** The brief confirms the *END BOSS* label
   (*"the `END BOSS` label just confirmed"*); it says nothing of the tooltip or the readout's *"— the Hollow Crown
   waits"*, so both stay proposed.
4. **THE END BOSS CANNOT KILL A PARTY ON THE FLOOR, AND THE RUNG WAS NOT WHY — THE DESIGNER'S, AND NOTHING WAS TUNED.**
   §3's whole test was to re-drive GI's one-health party at rung 1, and **it still wins: 7 of 7 on GJ's code, with the
   Crown at rung 2's strength, as 7 of 7 on HEAD's**; with the Devout already down as well, 3 of 4; against a
   Ruin-strength Crown, 2 of 2. In every fight the Crown opens with Regalia — a ward that deals nothing — and casts one
   to four abilities in all before it dies, Broken once or twice and, Broken, open to a freeze that takes its turn. The
   sims agree from the other side: **the end boss stopped none of the 148 untalented runs that reached it** at rungs 1
   and 2 (§1e). What would make the last fight able to kill a party on the floor is its shape — its opening, its
   health, what a Broken end boss is open to — which is content, and the end boss is a placeholder by decision
   (`docs/master.html` §13). §3c and §6 carry the fights.

## THE SHORT VERSION

- **§1 — THE SIM FIGHTS THE END BOSS, AND PRINTS BOTH COMPLETIONS OFF THE SAME RUNS.** `run_sim.on_battle_end` pays the third zone boss as the game does and walks on to the end
  boss, and the report and the Matrix row print both counts. Untalented, 150 runs a rung: **93% / 5% / 0% to the end
  boss, and 93% / 5% / 0% to the third zone boss off the same runs — the end boss met 148 times and stopped none. The
  delta is zero** (§1e). HEAD's sim read 89% at rung 1 the same day.
- **§2 — `check_gj` PRESSES THE BUTTON EVERY BATTERY.** A whole run walked through the real screens with every step a
  press on the node's own lattice button, the END BOSS pressed, the victory asserted (the gold as the purse moved, a
  relic, talent tier 0 → 1, the profile's write, the save deleted, Continue greyed) and a defeat asserted. **70 checks,
  41 s standalone** — it belongs in every battery. HEAD's code reads **70 / 8** (exactly GJ's eight arms) and GJ's code
  with GI's lattice fix reverted reads **25 / 3**.
- **§3 — NO RUNG DISCOUNTS THE END BOSS.** At rung 1 the Crown now spawns at **1,910 health and 334 Attack** — rung 2's —
  where it spawned at 1,910 and 167; spawned at every rung on both codes, **nothing else moves**. GI's one-health party, re-driven at rung 1: **it still wins — 7 of 7 on GJ's code, as on
  HEAD's.** The Crown opens with a ward and dies after one to four casts, so the multiplier it now takes is not what
  decides its fight (NEEDS A RULING 4).
- **§4 — MINI-BOSS, AND ONE NAME.** The mini-boss's node and its bargain say *MINI-BOSS*; a census of every string
  that carries *warden* finds no other surface. A run ended at the end boss reads *"The END BOSS — The Hollow Crown."*
- **§6 — DRIVEN, BOTH WAYS.** 27 whole runs through the real screens: the victory as GI read it, and — with every hero at
  1 and the Devout already down — **a real fought defeat at the end boss** (seed 1): *THE HEROES HAVE FALLEN*, *"Wiped —
  Zone 3 (Forest of Old), facing the Hollow Crown"*, *"The END BOSS — The Hollow Crown."*, a wipe booked, no tier, no
  completion, no relic, the save gone and Continue greyed.

## §0 — THE BRIEF'S PREMISES

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD `e11d5bb` (GI); `origin/class-merge` read the same |
| 2 | *"GI made the game finishable … two full runs, the button pressed, the Crown killed"* | **HELD** | GI §7: seeds 7 and 11, driven through the real screens |
| 3 | *"the simulator stops at the third zone boss"* | **HELD** | `run_sim.on_battle_end` gated the zone boss's award on `has_next_zone()` and set `run_over` on the third; the `endboss` node was never walked |
| 4 | *"none of the 109 targets presses the button"* | **HELD** | GI's batteries ran 109; `check_fh` §8 fights the end boss through `_on_node_pressed`, not the button |
| 5 | *"GI found the Crown was appearing as one zone boss in seven"* | **HELD** | GI §2: 286, 309 and 335 of 2,000 composed boss warbands on HEAD |
| 6 | *"every completion figure … EO's 97/3/0, EP's 22%, EV's arms, FV's … stop at encounter 48 of 49"* | **HELD, WITH ONE ATTRIBUTION** | The 97 / 3 / 0 is **EN's** (n=30 a rung); EO re-read it as 97 / 0 / 0 and moved rung 1 to 77% (n=30) and 73% (n=100). EP's 22% is rung 2 with rows 1–3. Every one is a run that killed the third zone boss — run slot 48 |
| 7 | *"the three rungs' untalented completion, which EO and EP established"* | **HELD AS A SCOPE** | EN 97 / 3 / 0 and EO 73% (rung 1, n=100) and EP's arm C 3% (rung 2, n=100) are the untalented headlines. GJ re-measured the three rungs untalented at n=150 |
| 8 | *"GI's own verification was two hand-played runs"* | **HELD AS DRIVES** | GI's runs were played by a driver through the real screens (`drive_gi.gd`), not by a person |
| 9 | *"`check_gf` … is the only thing in the project that plays the game"* | **NOT AS STATED** | `check_fh` §1 plays a whole 49-encounter run through the shipped scenes every battery (it presses the node handler, not the button); `check_gf` constructs its road through `Run.advance` and presses only the steps it tests |
| 10 | *"`check_fx` needed its own measured limit at about six minutes because it waits on real battle animations"* | **HELD** | `TMO[check_fx]=720`, measured at 354 s at FX; GI's acceptance log times it at about 366 s |
| 11 | *"a full run to encounter 49 is longer than anything in the battery"* | **NOT AS FOUND** | `check_gj` walks a whole run — 30 battles, 48 maps — in **41 s** standalone with the enemy's attacks off; `check_fh` plays one inside a gate of about 72 s. The longest targets are `check_fx` (~6 min) and `check_map` (~5 min) |
| 12 | *"GI found a party with every hero at 1 health beat it on the easiest rung"* | **HELD** | GI's FOUND AND NOT FIXED, seed 7 |
| 13 | *"EO's ×0.50 reaches the final fight"* | **HELD, FOR ATTACK ONLY** | Since EO §2 the rung discounts damage and not health: at rung 1 the Crown spawned at 1,910 health and **167** Attack, against rung 2's 1,910 and 334 (§3a) |
| 14 | *"If it carries authored numbers, it uses them unscaled. If the scale is the only thing setting them, it takes rung 2's values at every rung"* | **BOTH BRANCHES GIVE THE SAME NUMBERS** | The Crown carries authored numbers (620 health, 115 Attack in `data/enemies.json`), and the zone ladder (×2.2) and its tier (×1.40 / ×1.32) set them at every rung; the rung's multiplier is 1.00 at rung 2, so "unscaled by the rung" and "rung 2's values" are one set of numbers |
| 15 | *"Rungs 2 and 3 must not move"* | **CANNOT HOLD UNDER THE LITERAL RULING; HELD UNDER THE ONE BUILT** | Rung 3's end boss carries ×1.30 on HEAD; *"rung 2's values at every rung"* would move it to ×1.00. Built the floor (NEEDS A RULING 1); rungs 2 and 3 spawn bit-identical (§3b) |
| 16 | *"`WARDEN` … clashes with the Withered Warden, the Warden spec and the Warden difficulty — four things, one word"* | **HELD** | §4a's census |
| 17 | *"`MINI-BOSS` is the same plain voice as the `END BOSS` label just confirmed"* | **HELD AS A RULING, RECORDED** | `docs/state.md` carried the label as proposed; this brief is its confirmation |
| 18 | *"the run summary names the end boss twice — The END BOSS — The Hollow Crown: The Hollow Crown."* | **HELD** | GI's forfeit drive; `check_gj` §5 reads the doubled line on HEAD's code (its control) |
| 19 | *"§1 changes what the simulator does and several gates read its output"* | **NOT AS STATED** | No target runs a `--run` sim or reads its report. Sixteen targets read `run_sim.gd`'s SOURCE, and `test_run_harness` calls `RunSim.install_builds` and reads `tiers_built`; the reconnaissance battery moved no row (VERIFICATION) |
| 20 | *"The two accepted quit consequences … Melted Armor and Caught Fast … the mini-boss awarding an upgrade … No merge work"* | **HELD** | Untouched (§5) |

## §1 — THE SIMULATOR FINISHES THE RUN

### 1a. What changed

- **`run_sim.on_battle_end` pays the third zone boss as it pays the other two and walks on.** Its zone-boss branch was
  gated on `has_next_zone()` and set `run_over` on the third, so the sim ended every run there: the slot ladder stopped
  at 9, a run paid two zone-boss ability awards where the game pays three, and the `endboss` node was never walked. Now
  every zone boss grants the slot and the award (`note_zone_boss_cleared`, `_award_trophies`), only the first two descend
  (`advance_zone`), and the walk reaches the end boss through the final zone's boss's own edge like any other fight.
  **The end boss's victory ends the run and books nothing persistent** — its relic and its talent tier are the
  player's, and the sim still calls no `Relics` or `Profile` hook.
- **`Completed` is the end boss killed; the third zone boss's count prints beside it off the same runs** — in the
  report's first line, as a SECONDARY row with its own band, and in the Matrix row as `z3boss=` beside `completions=`.
  A guard line prints if a run ever counts complete without the end boss's death (`completed` against `endboss_kills`);
  none did.
- **What else reads differently, and was not re-read:** the awards ceiling is 3.00 (it printed 2.00 as a literal), a full
  clear is depth 49, the route-agency note counts 49 steps, the end boss's fight joins the `boss` rounds bucket, and the
  wipe table has an `end boss` column (§1f).

### 1b. The headline — the three rungs, untalented, both counts

150 runs a rung, `DOD_SIM_ROWS=0`, the balanced route, the standard four specs — EO's method — on GJ's code in an
isolated copy. **The n was declared before any rung-1 outcome was read**: each arm's first 150 runs, off the harness's
own per-run progress lines (rung 2 and rung 3 ran 200; their first 150 are used so every row stands on the same n).

| rung | to the third zone boss (what "completion" meant before GJ) | to the end boss | end boss met / stopped |
|---|---|---|---|
| 1 Wanderer | 93% ±4.0 | 93% ±4.0 | 140 / 0 |
| 2 Warden | 5% ±3.6 | 5% ±3.6 | 8 / 0 |
| 3 Ruin | 0% ±0.9 | 0% ±0.9 | 0 / 0 |

Rung 2's full 200 read 11 of 200 both ways (6%, ±3.2), the end boss met 11 times and stopping none; rung 3's full 200
read 0 of 200, the end boss never met (depth mean 15.9 of 49).

### 1c. The control — HEAD's sim, the same day

HEAD's `run_sim.gd`, which ends a run at the third zone boss, in its own isolated copy, rung 1 untalented: **89%**
over its first 150 runs, beside GJ's 93% to the third zone boss. The old count reads the same through the new
sim, so the `z3boss=` figure is the pre-GJ figure and not a re-definition of it.

### 1d. The rung-1 split

GJ's code with only §3's spawn branch taken back out, rung 1: **94%** to the end boss (met 141, stopped
0). Beside 93% it prices what the end boss's full strength costs an untalented party on the first rung;
beside the third-zone-boss count it prices the final fight itself.

### 1e. The delta, plainly

**ZERO, AT EVERY RUNG — AND THAT IS THE FINDING.** Of the first 150 runs of each arm, the end boss was met 140 times at
rung 1 and 8 times at rung 2 and stopped **none** of them; at rung 3 no run reached it. So counting the final fight moves no
rung's completion by a single run — rung 1 reads 93% to the third zone boss and 93% to the end boss — and every pre-GJ
untalented figure, re-read, would also have been a completion to the end boss. **Completion does not fall once the final
fight counts; the finding is that the final fight asks nothing an untalented party can fail.** With §3's floor taken out
of the same code, rung 1 reads 94% both ways (met 141, stopped none), so the end boss's full strength costs the first
rung nothing measurable either. The drives in §3c and §6 say why: the Crown opens with a ward and dies after one to four
casts. HEAD's own sim read 89% (±4.9) to the third zone boss the same day, beside GJ's 93% (±4.0) — inside each other's
bands.

### 1f. Found in GJ's own edit and repaired before the acceptance run: the `end boss` column was counted and never printed

The wipe table gained an `end boss` band for slot 17, and the `print` under it still carried four fields, so the band
was filled and never shown — an instrument branch that never fires, found by reading rung 3's report. The per-run
progress lines carry the exact slot, so no reading was lost; the `print` gained the fifth field after the reconnaissance
battery and before the documents landed, and the acceptance battery reads the repaired file.

## §2 — A CHECK PRESSES THE BUTTON

- **`check_gj.gd`, 70 checks, six sections** (its header is the index). §1 walks a whole run on the real screens,
  every step onto a node a press on that node's own lattice button — found by what its `pressed` is bound to — and never
  `_on_node_pressed` by hand; on every board it reads, the pressable nodes must be the reachable ones (GI's defect, on
  every board rather than the last). §2 reads the final board: one lattice button per node, the END BOSS button, its
  tooltip, the readout naming the Crown. §3 reads the Crown the press fields (§3 below). §4 the victory: the card, the
  gold line equal to what the purse moved, the relic named on the card and written to the gate's scratch relic file,
  talent tier 0 → 1 on its scratch profile with no talent point paid, the end boss and the completion booked, the run
  save deleted, Continue greyed. §5 a defeat. §6 the player's run save, profile and relic file byte for byte, both arms
  unconditional.
- **THE ENEMY'S ATTACKS ARE OFF** (`DOD_ENEMIES_OFF=1`, the switch `gate_fixture.spawn` already sets for every gate
  battle). Every fight is fought and won by the real scene on autoplay and none can be lost, so the gate asserts the
  drive and the end, never the balance — `check_fh` §1's reasoning. **The defeat §5 reads is built down GH's own path**:
  the END BOSS pressed, the battle's ☰ Exit, the save written with every hero at 0 — what the save holds when the last
  fall lands and the window closes — and the main menu's real Continue, which opens the fight with nobody standing.
- **ITS RELIC WRITE NEEDED A REDIRECT, AND IT GOT THE VAR, NOT THE RULE.** An unlock is a write to `user://relics.json`,
  a `const` until GJ; `Relics.save_path` now defaults to it and `check_gj` alone points it at `user://gj_relics.json`,
  opened with every relic locked so the one the victory unlocks can be read. The four gates FY §5b counted are
  untouched, and that deferral stands.
- **THE SCREEN PRIMITIVES LIVE IN `gate_fixture.gd`.** `check_fh` and `check_gf` each carry copies; a third driver would
  have been DA §3's tell, so `check_gj` reads them from the fixture. Moving the other two is owed (FOUND AND NOT FIXED).
- **RUNTIME: 41 s standalone, 70 / 0**, its whole run 30 battles over 48 maps. **It belongs in every battery** — under
  the default 240 s bound, so it carries no `TMO`. Its battery reading is in VERIFICATION.
- **THE CONTROLS, PREDICTED IN WRITING BEFORE EITHER RAN:**
  - **HEAD's code**, given only what the gate needs to compile and not throw — the relic redirect, the fixture's
    primitives, and an `end_boss_mult` stub carrying HEAD's semantics — reads **70 / 8**, exactly the eight predicted: the
    three mini-boss arms (three buttons read WARDEN, 48 lattice readings of WARDEN, the openers), the three scale arms
    (Attack 167 against 334, the discounted 167 itself, rung 1's multiplier 1.100 against the health path's 2.200) and
    the two summary arms (the one-string line absent, the doubled line present).
  - **GJ's code with GI's lattice fix reverted** (the width and both loops back to `SLOTS_PER_ZONE`) reads **25 / 3**:
    43 lattice buttons for the final board's 44 nodes, no END BOSS button, and §5's board with nothing to press.

## §3 — THE END BOSS IGNORES THE RUNG SCALE

### 3a. What it uses instead

**It carries authored numbers** — 620 health and 115 Attack in `data/enemies.json` — and meets every rung with them,
scaled by the zone ladder (×2.2 in the third zone) and its tier (×1.40 health, ×1.32 Attack at slot 16, the clamp
reading it as the zone boss's), **and by no discount**: `Run.end_boss_mult(slot)` is `_zone_ladder(slot) ×
maxf(difficulty_mult(), 1.0)`, read for health and Attack alike, keyed on the node (`encounter.type == "endboss"`). At
rung 1 that is rung 2's values, so the brief's two branches are one set of numbers (§0 row 14).

### 3b. Rungs 2 and 3 do not move — spawned, not argued

The end boss, the third zone's boss with an archer and a plain fight, spawned by the real battle scene at every rung on
HEAD's code and on GJ's, in isolated copies (`sim_run` set, nothing saved):

| rung | encounter | HEAD | GJ |
|---|---|---|---|
| 1 | end boss | Crown 1,910 / **167** | Crown 1,910 / **334** |
| 1 | zone boss | Withered Warden 1,540 / 145, archer 340 / 145 | the same |
| 1 | fight | raider 440 / 145, archer 340 / 145 | the same |
| 2 | end boss | Crown 1,910 / 334 | the same |
| 2 | zone boss | Withered Warden 1,540 / 290, archer 340 / 290 | the same |
| 2 | fight | raider 440 / 290, archer 340 / 290 | the same |
| 3 | end boss | Crown 2,490 / 434 | the same |
| 3 | zone boss | Withered Warden 2,010 / 378, archer 450 / 378 | the same |
| 3 | fight | raider 570 / 378, archer 450 / 378 | the same |

**Eighteen readings, one difference: rung 1's end-boss Attack.** `check_gj` §3 asserts the relation every battery —
`end_boss_mult` equal to the ordinary attack path at rungs 2 and 3, and to the health path, not the discounted one, at
rung 1.

### 3c. The whole test: re-driving the one-health party at rung 1

GI's drive, re-run: seed 7, a whole run through the real screens, every hero set to 1 health before the end boss's
step. **On GJ's code the party still won.** The same seed on HEAD's code is an exact pairing up to that fight, and the
difference inside it is the one §3 made — the Crown's Crown of Thorns on the Devout landed **98 against 49**:

- **GJ's code, every hero at 1 before the step:** won 7 of 7 (seeds 1–7).
- **HEAD's code, the same drive:** won 7 of 7 — the pairing is exact up to the fight, and inside it the Crown's blows
  are halved.
- **Harsher, on GJ's code:** every hero at 1 and the Devout already down, won 3 of 4; the same with the step taken on
  Ruin (the Crown at 2,490 / 434 with all five abilities and the fixed modifier), won 2 of 2.
- **Every fight, move by move:** §6's table.

**So the answer to the section's test is that it still wins, and why is the finding.** In all of these fights the Crown
opens with Regalia — a ward, no damage — and casts one to four abilities in all before it dies; it Breaks once or twice,
and a Broken boss is open to the freeze that takes its turn (CR §1). The multiplier doubles each blow it lands, and it
lands one or two. **The rung discount was not what let a party on the floor win; the fight's length is.** What would make
the last fight able to kill a party on the floor is content — its opening, its health, what a Broken end boss is open to
— and it is under NEEDS A RULING (4).

## §4 — THE MINI-BOSS BUTTON AND THE DOUBLE NAME

### 4a. Every surface the old word reached

**A census, not a guess:** every string literal in `scripts/*.gd` (comments stripped) and every string in
`data/*.json` that carries *warden*, case-folded — **50** — read one by one. None names the mini-boss now; on HEAD
exactly **two** did, and both moved:

| surface | HEAD | GJ |
|---|---|---|
| the mini-boss's lattice button (`map_screen.NODE_LABELS`) | *WARDEN* | *MINI-BOSS* |
| its bargain's opener (`offer_screen.gd`) | *"The WARDEN of this zone blocks the road."* | *"The MINI-BOSS of this zone blocks the road."* |

The other 48 are what the brief named: **the Warden spec** (its id, its name, the status chips that name it, its runes'
`spec:warden` scopes, the glossary entries that describe him), **the second rung** (its id and the glossary's road and
ladder entries), and **the Withered Warden** (its kind, its name, and the forest's own lore — *Echo of the Warden*).
Every other surface that names the node already said MINI-BOSS or mini-boss: the map's help text, the tooltip, the
summary's *"The zone's MINI-BOSS"*, the glossary's map-nodes entry and `master.html` §3's slot table.

### 4b. The name sweep (BR §1) and the fit

- **1,249 live names in 16 populations**, off the game's own accessors (GI's probe, re-run on GJ's code) and the JSON
  (abilities 227, talent nodes 27, runes 254, relics 50, items 16, tags 7, specs 24, themes 12, zones 2, rungs 3,
  statuses 312, enemies 42, enemy abilities 50, glossary terms and ids 196, event titles 20, the map's other node
  labels 7). Word-bounded and case-folded: **0 exact, 0 contained.** The seven that share a word are the boss family —
  *BOSS*, *END BOSS*, *The End Boss*, *Boss Trophies*, *Boss Escort* and two glossary ids — same meaning, all of them.
- **It fits:** 66 px of the 68 a closed node gives it, and **76 of 76** at the open node's larger font — no margin open,
  measured with GI's width probe on GJ's code. (*MINIBOSS* would be 62 / 72; the brief named the hyphenated word.)
- **`check_gj` §1 asserts both surfaces on every board the road reads**, paired: the mini-boss's own button reads
  MINI-BOSS in all three zones, no lattice button reads WARDEN, and each mini-boss bargain names the MINI-BOSS and not
  the WARDEN.

### 4c. One string

`_summary_lines` printed the final battle as `kind — theme: enemies`, and the end boss's theme IS its one enemy's name.
A lineup that is only the creature its theme names now prints the name once — *"The END BOSS — The Hollow Crown."* —
and every other warband keeps the ordinary shape. It is the line a wipe and a forfeit print at the end boss; `check_gj`
§5 reads it on the wipe card, and the fought defeat in §6 printed it.

## §5 — NOT DONE, AS RULED

- **The two accepted quit consequences** stay accepted; nothing in GJ touches a quit.
- **Melted Armor and Caught Fast** stay in the glossary.
- **The mini-boss awarding an upgrade the forge already applied** stays queued.
- **No merge work**: `data/enemies.json`, `data/runes.json`, `scripts/talents.gd`, `scripts/classes.gd` and
  `scripts/unit.gd` are untouched, and no node, rune, magnitude or engine moved beyond §3's scale exemption. The
  glossary's one edit is the rung-1 sentence §3 made false.

## §6 — DRIVEN BOTH WAYS

Every drive plays a whole run through the real screens from the map — the draft, owed picks, bargains, events, the
Peddler and the forge — every step onto a node a press on that node's own lattice button, every fight fought by the
autoplay bot on Wanderer with the enemy's attacks on, each in an isolated copy whose `config/name` is renamed and whose
`user://` is emptied before every drive. **The driver is GI's `drive_gi.gd`, its body unchanged**, with two constructed
set-ups added for the losing side (every hero at 1 with the Devout down; and the step onto the end boss taken on Ruin).

| code | the party at the end boss | seed | outcome | the Crown's casts, in order | heroes fell | Breaks |
|---|---|---|---|---|---|---|
| GJ | full health | 1 | **won** | Regalia › Hollow Wail | 0 | 2 |
| GJ | full health | 2 | **won** | Regalia › Crown of Thorns | 0 | 1 |
| GJ | full health | 3 | **won** | Regalia | 0 | 1 |
| GJ | full health | 4 | **won** | Regalia › Hollow Wail › Regalia | 0 | 2 |
| GJ | full health | 5 | **won** | Regalia › Hollow Wail | 0 | 1 |
| GJ | full health | 6 | **won** | Regalia › Hollow Wail | 0 | 2 |
| GJ | full health | 7 | **won** | Regalia › Hollow Wail | 0 | 1 |
| GJ | every hero at 1 | 1 | **won** | Regalia › Hollow Wail | 2 | 1 |
| GJ | every hero at 1 | 2 | **won** | Regalia › Crown of Thorns › Hollow Wail | 0 | 1 |
| GJ | every hero at 1 | 3 | **won** | Regalia › Hollow Wail | 2 | 1 |
| GJ | every hero at 1 | 4 | **won** | Regalia › Crown of Thorns › Hollow Wail | 0 | 2 |
| GJ | every hero at 1 | 5 | **won** | Regalia › Crown of Thorns | 0 | 1 |
| GJ | every hero at 1 | 6 | **won** | Regalia › Hollow Wail › Regalia › Hollow Wail | 2 | 2 |
| GJ | every hero at 1 | 7 | **won** | Regalia › Crown of Thorns | 1 | 1 |
| HEAD | every hero at 1 | 1 | **won** | Regalia › Hollow Wail › Crown of Thorns | 0 | 2 |
| HEAD | every hero at 1 | 2 | **won** | Regalia › Crown of Thorns › Crown of Thorns | 0 | 1 |
| HEAD | every hero at 1 | 3 | **won** | Regalia › Hollow Wail | 1 | 1 |
| HEAD | every hero at 1 | 4 | **won** | Regalia › Crown of Thorns › Hollow Wail | 0 | 2 |
| HEAD | every hero at 1 | 5 | **won** | Regalia › Crown of Thorns | 0 | 1 |
| HEAD | every hero at 1 | 6 | **won** | Regalia › Hollow Wail | 1 | 2 |
| HEAD | every hero at 1 | 7 | **won** | Regalia › Crown of Thorns | 1 | 1 |
| GJ | every hero at 1, the Devout down | 1 | **LOST** | Regalia › Hollow Wail › Crown of Thorns | 3 | 1 |
| GJ | every hero at 1, the Devout down | 2 | **won** | Regalia › Crown of Thorns › Crown of Thorns | 1 | 1 |
| GJ | every hero at 1, the Devout down | 3 | **won** | Regalia › Hollow Wail | 2 | 1 |
| GJ | every hero at 1, the Devout down | 7 | **won** | Regalia › Crown of Thorns | 0 | 1 |
| GJ | every hero at 1, the Devout down, the step on Ruin | 1 | **won** | Regalia › Hollow Wail | 2 | 1 |
| GJ | every hero at 1, the Devout down, the step on Ruin | 7 | **won** | Regalia › Hollow Wail › Regalia | 2 | 1 |

- GJ, full health: won 7 of 7
- GJ, every hero at 1: won 7 of 7
- HEAD, every hero at 1: won 7 of 7
- GJ, every hero at 1, the Devout down: won 3 of 4
- GJ, every hero at 1, the Devout down, the step on Ruin: won 2 of 2

- **THE VICTORY, as GI read it** (seed 7, GJ's code, full health): *THE DECAY RECEDES* — *"Run complete — all 3 zones
  cleansed (wanderer difficulty)."* / *"+169 gold."* / *"The road ends here."* / *"RELIC UNLOCKED: Emberheart"* /
  *"TALENT TIER 1 IS OPEN — for every class."*; the profile at talent tier 1 with the Crown booked; the run save gone;
  Continue DISABLED; the card's New Run opened the draft.
- **THE DEFEAT, which nobody had seen** (seed 1, GJ's code, every hero at 1 and the Devout down): the Crown's Regalia,
  then Hollow Wail killing the Berserker and the Sharpshooter (the Cryomancer's Ashes of Al'ar caught its lethal blow),
  then — Broken — Crown of Thorns for 134 on the Cryomancer. *THE HEROES HAVE FALLEN* — *"Wiped — Zone 3 (Forest of
  Old), facing the Hollow Crown (wanderer difficulty)."* / *The final battle* / *"The END BOSS — The Hollow Crown."* /
  *"Fallen: Berserker, Cryomancer, Devout, Sharpshooter."* The profile booked a wipe for each of the four specs, **no
  talent tier and no completion**, and the Crown is not among its bosses killed; the relic file holds the zone bosses'
  three unlocks and nothing from the end boss; `Run.active` false, the run save gone, **Continue DISABLED**. That is what
  `check_gj` §5 asserts every battery, down its constructed path.

## FOUND AND NOT FIXED

- **THE DESIGNER'S: THE END BOSS'S FIGHT IS TOO SHORT TO TEST A PARTY, AND §3 DID NOT CHANGE THAT** (§3c, NEEDS A
  RULING 4).
- **THE SCREEN PRIMITIVES ARE IN THREE DRIVERS AND AUTHORED ONCE FOR ONE.** `check_fh` and `check_gf` still carry their
  own copies of what `gate_fixture.gd` now holds; consolidating them is owed to a test batch.
- **THE SIM'S OTHER FIGURES MOVED WITH IT AND WERE NOT RE-READ** — three zone-boss awards a run, a slot ladder to 10, the
  end boss's fight in the `boss` rounds bucket, depth 49 for a full clear.
- **EP's TWELVE-SLOT BANDING STAYS QUEUED.** GJ gave the end boss its own wipe column and corrected `_finish_run`'s
  comment; the `boss` band still holds slots 11–15 and the per-tier table still stops at 11.
- **FY §5b's FOUR GATES STILL WRITE THE PLAYER'S RELIC FILE THE DAY A RELIC IS LOCKED.** `Relics.save_path` exists now,
  so closing it is one redirect line in each; it is deferred by ruling (GA) and GJ did not touch it.

## VERIFICATION

### The saves

Backed up before anything ran, at `save-backups/GJ-20260915-094907/` (not committed), and verified by hash; all four
read the same as GI's figures:

| file | md5 |
|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

All four read the same as the backup before each battery's launch and after its run — the reconnaissance battery's, the pre-pass's and the acceptance battery's freezes each hash them with the tree — and the acceptance battery's after-freeze reads the four hashes above.

### The parse floor

`check_parse` read **184 checks / 0 failures** after the code edits — 183 → 184 is `check_gj.gd` joining the population it
parses — and its stream carried no `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line, read off the
stream and never off the tally or the exit code. It read **184 / 0 again over the landed tree** — the documents in and `run_sim.gd`'s print repaired — its stream again carrying no error line, and 184 / 0 in all three batteries. `--check-only` was not used as a verdict: it cannot see autoloads (`CLAUDE.md`'s rule).

### The gate, its controls, and what it cost

`check_gj` standalone over the finished code in the real tree: **70 / 0, 41 s wall**, the four saves untouched. HEAD's
code **70 / 8** and the lattice-reverted copy **25 / 3**, both predicted in writing before they ran (§2). Its battery
reading: **70 / 0 in the acceptance battery, about 42 s of wall** between its log and the one before it.

### The probes, the sims and the drives

All in isolated copies in the scratchpad, each with its `config/name` renamed so its `user://` was never the player's:
*GJ head*, *GJ new*, *GJ no3*, *GJ ctl head*, *GJ ctl lattice*, *GJ drive A*, *GJ drive B*, *GJ drive H*. No log of any of
them carries a `SCRIPT ERROR` or `Parse Error` line.

- **The spawn probe** (§3b): eighteen spawns, one difference.
- **The width probe** (§4b) and **the name probe** (§4b), GI's, re-run on GJ's code.
- **The sims** (§1): five arms — GJ at rungs 1, 2 and 3, GJ without §3 at rung 1, HEAD at rung 1 — untalented, EO's
  method. The rung-2 and rung-3 arms ran 200 runs and printed their reports; the rung-1 arms were read at their first
  150 off the per-run progress line, the n declared before any rung-1 outcome was read. **The sims ran beside the
  reconnaissance battery**; a pause would have kept them off its CPU, and the signal did not take — `kill -STOP`
  returned 0 and the process stayed running, from the sandboxed shell and from outside it — so they ran at nice 20
  while the battery's targets ran at 10. No target of the reconnaissance battery or the pre-pass timed out, and the
  acceptance battery ran with the machine to itself.
- **The drives** (§6): 27 whole runs, the table in §6.

### The gates, unmodified against the new code

- **Predicted before it ran**, in writing and before the launch: `check_de` 457 / 0 / 0 (GI's 453 and four for
  `check_gj`'s row), `check_gj` 70 / 0, `check_parse` 184 / 0, `check_cm_live` 13 / 4 with GI's four FAIL lines, every
  other row at its `baselines.json` row with the two drifters inside their bands, and `check_fh` 163 / 0 whatever its two
  end-boss fights ended in (neither asserts the outcome, and the Crown hits twice as hard at rung 1 now).
- **The reading: the unmodified gates against the new code, before any existing gate, suite or document moved.** The
  tree was GJ's code, `check_gj.gd`, `gate_fixture.gd`'s primitives, `run_battery.sh`'s entry and `baselines.json`'s two
  rows. **110 targets, 10:15:27 → 11:09:13 (53 m 46 s)** — slower than GI's 46 m 50 s because the sims and drives shared
  the machine at a lower priority; no target timed out. `.ran` is one sequence of 110 names with no duplicate.
  **`check_de` read 457 checks / 0 failures / 0 notices — the prediction, row for row.**
- **The rows quoted:** `check_gj` 70 / 0, `check_parse` 184 / 0, `check_fh` 163 / 0, `check_gf` 104 / 0, `check_fx` 496 / 0,
  `check_ct_map` 83 / 0, `check_es` 57 / 0, `check_ec` 23 / 0, `check_ed` 18 / 0, `test_batch_bx` 156 / 0 and
  `test_batch_ce` 1,114 / 0; `test_batch_an` 6,057 and `test_batch_bk` 130, each inside its band; `check_map` and
  `check_flow` complete; the harness 22 / 382 / 8 with no throws. **`check_cm_live` 13 / 4, its four FAIL lines identical to
  GI's acceptance log byte for byte.**
- **No error lines**: none of the 110 logs carries a `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load`
  line. **The freeze** — every file in the repo but `.git` and the `.godot` cache, tracked, untracked and ignored, and the
  four player saves — hashed identical before the launch and after the run (522 lines), and no Godot or battery process
  was in `ps` before it or after it.
- **So no row moved and no existing gate or suite was re-pointed.** The brief expected §1 to move the gates that read the
  sim (§0 row 19); none reads its output, and the sixteen that read its source pin nothing GJ changed (the literal sweep
  below).

### The literal sweep

Every string literal of four or more characters in the 114 root `.gd` files — **13,378 distinct** — checked raw, lowered
and whitespace-flattened in HEAD's copy and the new copy of each edited file, with the population printed.

| edited files | LOST | GAINED |
|---|---|---|
| `scripts/run_sim.gd`, `run_state.gd`, `battle.gd`, `map_screen.gd`, `offer_screen.gd`, `relics.gd`, `draft_screen.gd`, `data/glossary.json`, `gate_fixture.gd`, `run_battery.sh` | 4 | 62 |
| `CLAUDE.md`, `docs/instrument-rules.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md` | 0 | 10 |
| `docs/state.md` | 1 | 9 |

The documents were swept as SCRATCH COPIES before any landed, and landed by `cp` only where the repo's file still hashed
to HEAD's blob, each then `cmp`-identical to the copy swept. **Their one LOST** is *"_on_node_pressed"*, which state.md's
rewritten end-boss item no longer names; its four holders (`check_fh`, `check_gf`, `check_gj`, `gate_fixture.gd`) read
screens, not state.md. **Of their nineteen GAINED**, four needles have a holder that even names the document —
*"endboss"* (`check_fh`, `test_run_harness`: `CLAUDE.md` in comments only), *"completions"* (`check_fq`: a dict key),
lowercase *"wanderer"* (six suites: a difficulty id, never asserted against the changelog) and *"scripts/run_sim.gd"*
(`check_ek`: state.md in a comment) — and none pins it. **`check_es` §4's two *"2+ threshold"* windows in state.md are
two before the rewrite and two after**, asserted by the script that wrote it.

**Every holder of a moved needle was found and read** — the literal's holder files, and whether each opens the edited
file. The four LOST: *"The WARDEN of this zone"* is `check_gj`'s own negative needle (it reads the screen, and asserts the
words absent); *"(SAVE_PATH)"* and *"(SAVE_PATH,"* are held by `check_fi`, which asserts them absent from another file;
*"check_"* is `check_ek`'s file-name prefix. Of the GAINED, the needles whose holders open the edited file are
`test_batch_bo`'s *"SEVEN"* (a read of `CLAUDE.md`) and *"difficulty"* (a dict key), `test_batch_bm`'s *"Profile."* (its
`RunSim CALLS Profile nowhere` walk reads `run_sim.gd`'s non-comment lines, where GJ added none) and `test_batch_bx`'s
*"_resolve"* (a method call). None pins what moved.

### The pin manifest

`build_pin_manifest.py --check` read the manifest **current, 1,464 pins**, with the code edits in. Over the landed tree, with every document in place, it read **current again, 1,464 pins**, and `pin-manifest.json` is unchanged: no source pin moved and no document pin's holder changed.

### The pre-pass, and the acceptance battery

- **A pre-pass over the landed tree, before the acceptance battery**: every suite that opens one of the edited documents
  or the glossary — twenty-six, derived by `res://` path — plus the four that read `run_sim.gd`'s source and were not
  already on the list (`bc`, `bf`, `bk`, `bm`), because its print repair landed after the reconnaissance battery; and
  every gate, the harness and both scene runs, through `run_battery.sh` itself. **94 targets, 11:11:31 → 11:52:39
  (41 m 08 s)**; `.ran` is one sequence of 94 names with no duplicate. **`check_de` read 393 checks / 1 failure / 0
  notices, and the one failure is the subset refusal by design** — *"16 DID NOT (a subset run cannot certify the tree)"*,
  naming exactly the sixteen suites computed off `run_battery.sh`'s `SUITES` before the launch. Every other row read at
  its band: `check_gj` 70, `check_parse` 184, `check_es` 57, `check_ec` 23, `check_ed` 18, `check_fg` 22, `check_fs` 33,
  `test_batch_bx` 156, `test_batch_ce` 1,114, `test_batch_bk` 129, `check_fh` 163, `check_fx` 496 and `check_gf` 104, every
  one at 0 failures; `check_cm_live` 13 / 4 with GI's four FAIL lines byte for byte; the harness 22 / 382 / 8. No log
  carries an error line, and the tree and the four saves hashed identical before and after (523 lines).
- **Acceptance: every target through `run_battery.sh` in the real tree**, over the finished tree with every document in
  place and nothing edited during it.
  - **Predicted before it ran**, in writing: `check_de` 457 / 0 / 0 with every row at its `baselines.json` row,
    `check_cm_live` 13 / 4 with GI's four FAIL lines, and the two drifters inside their bands.
  - **The reading.** 110 targets, 11:53:53 → 12:41:14 (47 m 21 s). `.ran` is one sequence of 110 names in the battery's own
    order, with no duplicate. **`check_de` read 457 checks / 0 failures / 0 notices — the prediction, row for row.**
  - **The rows quoted.** `check_gj` 70 / 0, `check_parse` 184 / 0, `check_fh` 163 / 0, `check_gf` 104 / 0, `check_fx` 496 / 0, `check_es` 57 / 0,
    `check_ec` 23 / 0, `check_ed` 18 / 0, `check_fg` 22 / 0, `check_fs` 33 / 0, `test_batch_bx` 156 / 0, `test_batch_ce` 1114 / 0 and
    `check_ct_map` 83 / 0; `test_batch_an` read 6052 and `test_batch_bk` 130, each inside its band; `check_map` and
    `check_flow` complete; the harness 22 / 382 / 8 with no throws.
  - **`check_cm_live` read 13 / 4, the sanctioned red, and its four FAIL lines are identical to GI's acceptance log byte
    for byte** — as they were in the reconnaissance battery and the pre-pass. GJ touched `battle.gd` at the end boss's
    spawn and the summary line, nowhere near the defensive bar that gate presses.
  - **No error lines.** No `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line appears in any of the
    110 logs, nor in the reconnaissance battery's 110 or the pre-pass's 94.
  - **The freeze.** Every file in the repo but `.git` and the `.godot` build cache — tracked, untracked and ignored — and
    the four player saves were hashed before the launch and after the run: **523 lines, identical byte for byte**. No
    Godot or battery process was in `ps` before the launch or after the run.
  - **One file was written after the run: this report.** Its acceptance figures went in after the after-freeze was
    taken, and no gate or suite reads `docs/reports/`.

### `CLAUDE.md`

**330,732 B (322.98 KiB)**, +1,592 B this batch, against the 340 KiB ceiling — 17,428 B (17.02 KiB) under it. The changelog is **332,423 B**, +2,306 B, 67,577 B under its 400,000 B bar. `check_fg` read both in the acceptance battery.

### The push

To `class-merge`, once this report's figures were in. `git ls-remote origin class-merge` is read against local HEAD after
the push and reported with the batch, because a commit cannot carry its own hash.

## THE FOLDERS THIS BATCH LEFT

Scratch `user://` folders under `~/Library/Application Support/Godot/app_userdata/`, one for each isolated copy: *Dawn of
Decay GJ head*, *GJ new*, *GJ no3*, *GJ ctl head*, *GJ ctl lattice*, *GJ drive A*, *GJ drive B*, *GJ drive H*. Nothing in the
game reads them, and they are safe to delete. The backup is at `save-backups/GJ-20260915-094907/`, untracked like its
predecessors.
