# Batch GI — The end boss has a button, and a zone boss is the one its zone names

*Branch `class-merge`, from `3adc1ed` (GH); `git ls-remote origin class-merge` read `3adc1ed` before the push. `main`
takes one line of documentation (§5) and no code.*

## NEEDS A RULING

1. **THE END BOSS'S WORDS ARE PROPOSED, AND THE DESIGNER CONFIRMS THEM** (§3 carries what they match, verbatim).
   - **Label:** *END BOSS* — the name the glossary (*The End Boss*), the framing card (*"and then the end boss"*) and the
     run summary (*"The END BOSS"*) already give this node. It fits the button at both sizes (62 px of 68 closed, 72 of
     76 open, measured).
   - **Tooltip:** *"The END BOSS. Nothing goes around it."* over *"It is always the Hollow Crown, and the road ends
     here."* — the zone boss's two sentences, with the second turned round: the zone boss's says the player will not
     know which boss waits, and the end boss is always the same one. *"The road ends here."* is the end boss's own
     victory line.
   - **The readout's name past the third zone boss:** *"Zone 3 of 3 — encounter 16 of 17 (48 of 49) — the Hollow Crown
     waits"*, where it said *"the Withered Warden waits"* over a Warden the heroes had just killed. Same sentence, the
     creature the next step fights.
   - **Its colour is the zone boss's red.** A choice, not words; it is one constant to change.

## THE SHORT VERSION

- **§1 — THE BOARD IS ALREADY SEVENTEEN WIDE; ONLY THE DRAWING WAS SIXTEEN. WIDENED THE DRAWING.** BM appended the end
  boss to the final board as its seventeenth slot, and the save, the resume, `reachable()`, the run's 49 and the
  rewards were built on that; `map_screen._draw_lattice` alone kept looping `SLOTS_PER_ZONE`. **Nothing reads the
  drawn width but the map screen**, so reading the board's own size moves no other system — the tier ladder, the budget
  ramp, `compose`, the boss band and the sim read the constant, which is what a zone *generates*, and every one of
  them is right to; the severity floor reads no width at all. Keeping sixteen and transitioning would strand the third zone boss's
  ability pick and slot behind the fight they are for; putting the end boss in the sixteenth column removes an
  encounter and a zone boss's rewards, **which is a design question about what the last encounter is, so it was not
  taken** (§1c).
- **§2 — THE NODE'S IDENTITY IS THE AUTHORITY, AND THE FIX IS WHERE THE TWO PARTED.** The Boss Escort theme filled its
  `boss` role from every `boss`-tagged kind the zone's roster allows, and the Hollow Crown is tagged into all three
  rosters. **On HEAD it was the zone boss in 286, 309 and 335 of 2,000 composed warbands in zones 1, 2 and 3** — one in
  six or seven, in every zone — while the readout, `Profile.note_boss` and the zone named the zone's own. `compose`
  now fills the role with `boss_kind()`: **0 of 6,000.** Zone 1 driven thirty times through the real screens on each
  build: **7 of 30 zone-1 bosses were the Hollow Crown on HEAD, 0 of 30 after**, and three of HEAD's walked to the
  boss and stepped on: the battle fielded the Crown under *"… — the Withered Warden waits"*.
- **§3 — THE ZONE BOSSES SHARE ONE LABEL AND ONE TOOLTIP**, reported verbatim with every other surface that names them;
  the proposal is above, and its BR §1 sweep over 1,244 live names found no exact hit and only same-meaning neighbours.
- **§4 — RAGE'S RESET IS RECORDED AS RULED, AND THE TWO THINGS A QUIT STILL BUYS AS ACCEPTED**, with the reason, in
  `docs/state.md` and in `CLAUDE.md`'s GH block.
- **§5 — `main`'s NOTE** said the end boss was fixed on neither branch; one line now says it is fixed on `class-merge`
  only, by ruling.
- **§7 — DRIVEN TO THE END BOSS AND KILLED, THROUGH ITS OWN BUTTON.** Two whole runs on the new code (seeds 7 and 11)
  pressed the END BOSS button, killed the Hollow Crown, and ended on *THE DECAY RECEDES*: a relic unlocked, **talent
  tier 1 opened**, the run save cleared, Continue greyed. The same seed on HEAD stopped after the third zone boss on a
  board whose seventeenth column drew nothing (*"reachable [0]; pressable []"*).

## §0 — THE BRIEF'S PREMISES

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD `3adc1ed` (GH); `origin/class-merge` read the same |
| 2 | *"the map draws 16 columns and the end boss is the 17th, so no run has ever reached it, on either branch"* | **HELD, FOR A RUN THROUGH THE MAP** | Driven again at GI on HEAD (§7). `check_fh` §8 has fought it for batches — by calling `_on_node_pressed`, with a full-health party, and not as a run. `main`'s loop is the same three lines |
| 3 | *"The game has been unfinishable for as long as the lattice has been 16 wide"* | **NOT AS STATED, BY FIVE HOURS** | BK made the lattice sixteen wide (`a0dc125`, 2026-08-12 17:20) and BM added the end boss as a seventeenth slot (`8e822fe`, 22:59 the same day). Between them the third zone boss *was* the end boss, so a run could finish; it has been unfinishable since BM |
| 4 | *"109 battery targets did not see it"* | **HELD** | GH's batteries ran 109 targets; GI's reconnaissance ran 109 as well. Why none could see it is `CLAUDE.md`'s new rule (§1d) |
| 5 | *"GH found five of my premises wrong — four dead heroes were never a softlock, the save never overwrote health, and GG costed by reading rather than driving"* | **HELD AS A COUNT, WITH ONE NAME FROM A SIXTH ROW** | GH §0 scored rows 6, 11, 20, 22 and 23 NOT AS STATED or NOT AS QUOTED — five. The third example named is row 24, which GH scored HALF |
| 6 | *"BK lengthened the lattice to sixteen and something may depend on that width"* | **HELD — AND NOTHING DEPENDS ON THE DRAWN WIDTH** | §1b: every reader of the constant is a reader of what a zone generates; the one reader of the drawn width is the map screen |
| 7 | *"EP found `run_sim.gd` bands `tier >= 11` as boss and drops slots 12–16 … 57 boss wipes where 7 existed"* | **HELD** | `run_sim.gd`'s wipe table reads `if wt >= 11: bands["boss"]` and its per-tier tables loop `range(1, 12)`; EP's figures are in `docs/state.md`. Untouched (§1b) |
| 8 | *"the map's draw, routing, the tier ladder, the budget ramp, `compose`, the severity floor, the sim's banding, every suite"* | **HELD AS A LIST TO CHECK; ONE ENTRY READS NO WIDTH** | The severity floor is a per-rung field (`DIFFICULTIES[...]["severity_floor"]`) and reads no slot at all (§1b) |
| 9 | *"Zone 1 can draw the Hollow Crown while naming a different boss"* | **HELD, AND IN EVERY ZONE** | §2c: zones 1, 2 and 3 alike, about one boss in seven |
| 10 | *"repairing the label to follow the creature would leave the end boss's creature appearing in zone 1"* | **HELD** | §2b |
| 11 | *"The Hollow Crown, its five abilities and every zone boss are all live names"* | **HELD** | Crown of Thorns, Hollow Wail, Regalia, Sundering Decree (rung 2) and The Long Dark (rung 3) in `data/enemies.json`; three at rung 1 |
| 12 | *"A quit before anything is lost rerolls the opening … A quit clears the heroes' cooldowns and statuses"* | **HELD** | GH §4b, driven |
| 13 | *"both need GG's multi-batch full capture to close"* | **HELD** | GH NEEDS A RULING item 2; GG §2d |
| 14 | *"A quit now costs health, Mana, items and a death"* | **HELD** | GH §1 |
| 15 | *"The end boss is unreachable on `main` too — `main`'s `state.md` records it at GG and does not fix it"* | **HELD** | `main`'s `62fdf6e`; its bullet read *"FOUND AT GF ON BOTH BRANCHES AND FIXED ON NEITHER"*. `main`'s composer and `enemies.json` are GI's HEAD's too, so `main` carries §2's mismatch as well (`git show main:` diffed, a comment apart) |
| 16 | *"Rage resets, ruled at GH — my brief listed it as carrying and every fight starts it at zero"* | **HELD AS A RULING, WITH GH's QUALIFIER** | GH built it resetting and recorded it as owed a ruling; this brief is the ruling, recorded at GI. Every fight opens Rage at zero **plus First Blood's and Bottled Storm's floors** (GH §1) |
| 17 | *"Melted Armor and Caught Fast stay … the Peddler and the forge stay lost … the mini-boss … stays queued … No merge work"* | **HELD** | Untouched (§6) |
| 18 | *"DRIVE A FULL RUN TO THE END BOSS AND KILL IT … it has never been done"* | **HELD FOR A RUN** | `check_fh` §8 fights the end boss on its own, reached through the handler; GF's drive reached it the same way and quit mid-fight. No run had killed it through the map (§7) |
| 19 | *"Anything reading the map's width is likely to move"* | **NOT AS FOUND** | The reconnaissance battery read every target at its row: `check_de` 453 / 0 / 0 (VERIFICATION) |
| 20 | *"`docs/changelog.html`, `CLAUDE.md`, `docs/state.md` rewritten, `baselines.json`, … `master.html`, and the stamp"* | **HELD; `baselines.json` UNCHANGED, BECAUSE NO ROW MOVED** | Every document moved; `master.html`'s stamp reads Batch GI |

## §1 — WHY IT IS SIXTEEN, AND WHAT READS THE WIDTH

### 1a. What the board is

- **A zone generates sixteen slots** (`SLOTS_PER_ZONE`, BK): fourteen branching columns, the mini-boss at slot 8 and
  the zone boss at slot 16 (`BOSS_SLOT`).
- **The final board carries a seventeenth** (`END_BOSS_SLOT`, BM): `_build_lattice` appends the end boss after every
  edge is wired and links the final zone's boss to it. So the final board is seventeen wide in the data — the save
  holds seventeen, `reachable()` offers the seventeenth, `total_slots()` counts 49 — and has been since BM.
- **Only the drawing was sixteen.** `_draw_lattice` computed its width off `SLOTS_PER_ZONE - 1` and looped
  `for s in Run.SLOTS_PER_ZONE` twice, for the edges and for the nodes. The edge loop reads `map[s + 1]`, so the
  zone boss's edge to the end boss was drawn; the node loop stopped at sixteen, so the end boss had no button.

### 1b. Every reader of the width

Censused off the tree — every line in every `.gd` naming `SLOTS_PER_ZONE`, `BOSS_SLOT`, `MINI_SLOT`, `END_BOSS_SLOT`,
`BRANCH_COLUMNS`, `total_slots`, `run_slot_number`, `is_end_boss_slot`, `map.size()`, the lattice draw or its tooltip:
118 lines in 13 files.

| Reader | What it reads | What it does with it | Widening the drawing moves it? |
|---|---|---|---|
| **The map's draw** (`map_screen._draw_lattice`) | `SLOTS_PER_ZONE` for the width and both loops | draws sixteen columns on every board | **this is the defect — it reads `Run.map.size()` now** |
| The map's tooltips (`_node_tooltip`) | `SLOTS_PER_ZONE` in *"Encounter %d of %d"* | printed *"of 16"* on the final board, where the readout said *"of 17"* | **moved with the draw** — the board's own size, as the readout and the summary already print it |
| The map's readout (`_draw_header`) | `Run.map.size()`, `total_slots()`, a literal *"16 encounters to the"* | *"encounter N of 16/17 (M of 49)"* | no — already the board's size; the literal is true on every board, the zone boss being the sixteenth |
| Routing (`Run.reachable`, `reachable_from`, `current_node`, `advance`) | `map.size()` | offers the seventeenth after the final zone's boss | no — already the board's size |
| The generator (`_build_lattice`, `_assign_node_types`, `_compose_warbands`) | `SLOTS_PER_ZONE`, `BRANCH_COLUMNS`, `MINI_SLOT`, `BOSS_SLOT`; `map.size()` | builds sixteen slots, types fourteen columns, appends the end boss | no |
| The tier ladder (`battle._spawn_units`) | `clampi(slot_idx + 1, 1, SLOTS_PER_ZONE)` | enemy HP +2.5% and Attack +2% a tier; the end boss (slot index 16) reads tier 16, the zone boss's | no — and the clamp is why the end boss scales as the zone boss does rather than one tier past it |
| The budget ramp (`Run.battle_budget`) | tier clamped to 1..16; `tier >= SLOTS_PER_ZONE` is the boss's 10–12 band; `3 + floor((tier-1) × 5/14)` below it | BK §5's rescale | no |
| `compose` | the node type and the tier | fills a theme at the budget; the end boss is never composed | no (§2 changes what it fields at a boss, not the width) |
| The severity floor | the rung's own table | the guaranteed mild bargain | **reads no width at all** |
| The sim's banding (`run_sim.gd`) | `wt >= 11` as "boss", per-tier tables `range(1, 12)`; `depth_reached` off `SLOTS_PER_ZONE` | EP's twelve-slot banding, queued | no — and the sim never walks the end boss (it ends a run at the third zone boss; FOUND AND NOT FIXED) |
| The summary (`battle._run_snapshot`) | tier clamped to 16; `zone_slots` = `map.size()` | *"encounter N of M"* | no — already the board's size |
| Debug *Jump to Boss Slot* | `BOSS_SLOT - 1` | walks to the zone boss's column | no |
| The resume (`Run.resume_scene`) | `BOSS_SLOT` and `has_next_zone()` | descends from a non-final zone's boss | no |
| **Every suite and gate** | `test_batch_bk` 22 lines, `test_batch_an` 12, `test_batch_ah` 12, `check_map` 7, `check_fh` 5, `test_batch_bm` 4, `check_map_screen`, `check_gf`, `check_flow` 1 each | the generator's constants and a sixteen-slot zone; `check_fh` §1 and `test_run_harness` walk 49 and one end boss | **no — none reads the drawn width.** `check_map_screen` draws zone 1; `check_flow` and `check_ct_map` set `zone_idx = 2` on a zone-1 board; `check_fh` §8 calls the handler. The reconnaissance battery read every one at its row (VERIFICATION) |

**So the constant has two meanings and only one reader had the wrong one.** `SLOTS_PER_ZONE` is what a zone
*generates* — sixteen, everywhere — and every reader above but the draw means that. The draw wanted the width of the
board in front of the player, which is `Run.map.size()`.

### 1c. The three shapes, and what each costs

| | Widen to 17 (the drawing) | Keep 16; the end boss as a transition | The end boss IN the sixteenth |
|---|---|---|---|
| **Code** | `map_screen.gd`: the width and two loops; a label, a colour, a tooltip branch | `battle._next_zone` on the final board opens the end boss's fight; `Run.resume_scene`'s card branch the same; the lattice's dangling edge removed or left | `_build_lattice` stops appending; the final boss slot becomes the end boss; `END_BOSS_SLOT`, `total_slots()`, `is_end_boss_slot` and `_resolve_boss`'s branch rewritten |
| **The save** | unchanged (v13; the map already holds seventeen) | unchanged | the v10 refusal's reason (*"the final zone gained a seventeenth slot"*) is gone, and a v13 save's final board is one longer than the build walks |
| **What the player keeps** | everything: a map step before the end boss, its tooltip, the pouch, the loadout and the owed picks | **the third zone boss's ability pick and new slot are answered on the map, so they would arrive after the only fight left** — the reason the end boss awards no pick at all | **the third zone boss goes**: its talent point (three a completed run become two), its relic, its ability pick, the slot ladder's fourth rung, and an encounter (49 → 48) |
| **Gates it would move** (read off their assertions, not run) | none predicted, none read (VERIFICATION) | `check_gf`'s resume arms, `check_fh` §1/§8 | `test_run_harness` (49, three zone bosses, one end boss), `test_batch_bm`'s pins, `check_fh` (49), `test_batch_an`, `check_eg` §3 (three grants) |
| **Documents** | one row and one bullet in `master.html` | the map section and the resume rule | the run's shape in `master.html`, the glossary (*"the forty-ninth encounter"*), the framing card (*"49 encounters"*), `CLAUDE.md`'s BM §6 and EN §3 blocks |

### 1d. The recommendation, and why it was taken rather than asked

**Widen the drawing.** BM already ruled what the last encounter is — a seventeenth slot on the final board, after a
zone boss that pays like the other two — and every system but the draw already implements that. Widening the draw
implements the ruled design and changes nothing else; it is an implementation call, which the brief left to the batch.

**The third shape is not an implementation call, and GI stopped there.** Putting the end boss in the sixteenth column
decides what the last encounter IS — whether a run has a third zone boss, and what a completed run pays — so it is the
designer's, and nothing in GI takes it. The second is costed above and is worse than the first on the player's side.

**And the rule it leaves behind** is in `CLAUDE.md`, beside BM §6's block: *a loop over the board reads the board's
own size, never `SLOTS_PER_ZONE`*.

## §2 — THE ZONE BOSS: ONE SYSTEM DISAGREEING WITH ANOTHER

### 2a. The cause

- **A boss node's warband comes out of `compose("boss")`**, which can only draw the *Boss Escort* theme, whose pool is
  `{"boss": 1, …}` with `mins: {"boss": 1}`. `_theme_combos` filled each role from **every kind the zone's roster tags
  with it**, so the `boss` role held every `boss`-tagged kind legal in the roster.
- **The Hollow Crown is `boss`-tagged with `"zones": [1, 2, 3]`**, so it is legal in every roster (1 and 3 are the
  Forest of Old's, 2 the Scarlands'). It came in with BM (`8e822fe`), the batch that made it the end boss.
- **The name comes from `ZONE_DEFS`**: `forest` → `withered_warden`, `scarlands` → `ash_tyrant`, read by
  `Run.boss_kind()` — the map's readout (*"the %s waits"*), `Profile.note_boss` at a zone boss's death, and the summary's
  zone line. So the creature and the name came out of two tables that disagreed about one Crown in seven.

### 2b. Which is authoritative: the node's identity

- **`ZONE_DEFS` authors one boss for each zone**, and every surface that names a zone boss reads it: the readout, the
  profile's tally, the summary's zone line. **And the code already says so where a warband becomes units:**
  `battle._enemy_config` resolves the literal kind `"boss"` to `Run.boss_kind()` under the comment *"The zone def owns
  its boss"*.
- **The Hollow Crown is the END boss by BM's ruling**: *"FIXED, not composed … so it can be learned"*, and the one kind
  whose kit grows with the rung. Met as a zone boss, it is neither fixed nor met once, and a rung-2 or rung-3 player met
  its rung abilities in zone 1 — `_enemy_config` builds every enemy at the run's rung.
- **Relabelling to follow the creature would have made the words honest and left the larger problem**, as the brief
  says: the end boss turning up as an ordinary zone's boss. GF had already made the summary name the warband's boss
  (`_boss_in_warband`), which was honest about the fight and did not touch the cause.
- **So the fix is at the site where they part**: `compose` passes the zone's named boss to `_theme_combos`, which fills
  the `boss` role with it and nothing else. Every other role is filled as before. The roster tags did not move —
  whether the end boss's kind belongs in them is content — and nothing reads them for a boss now but `compose_test`,
  the `DOD_SIM_THEME` hook, which ignores run state by design.

### 2c. Every zone, measured

Two populations, both through the game's own code, in isolated copies (config names *Dawn of Decay GI head* / *GI new*):

| | Zone 1 (Forest, roster 1) | Zone 2 (Scarlands, roster 2) | Zone 3 (Forest, roster 3) |
|---|---|---|---|
| **HEAD — the composer**, 2,000 `compose("boss", 16)` a zone | Crown **286**, Warden 1,714 | Crown **309**, Tyrant 1,691 | Crown **335**, Warden 1,665 |
| **HEAD — map birth**, 150 whole runs, the boss node each board carries | Crown **18** of 150 | Crown **24** of 150 | Crown **22** of 150 |
| **GI — the composer** | Warden 2,000 | Tyrant 2,000 | Warden 2,000 |
| **GI — map birth** | Warden 150 | Tyrant 150 | Warden 150 |

The end boss node on the final board was the Hollow Crown in 150 of 150 runs on both builds.

**And through the real screens, as GF found it** — new runs from the main menu, through the draft and the awakening,
onto zone 1's map:

| | HEAD | GI |
|---|---|---|
| Thirty new runs (seeds 1–30): the readout against zone 1's boss node | readout *"Zone 1 of 3 — 16 encounters to the Withered Warden"* every time; the node was **the Hollow Crown in 7 of 30** (seeds 1, 4, 7, 8, 9, 22, 26) | the same readout; **the Withered Warden in 30 of 30** |
| Seeds 1, 4 and 8 walked to the boss and stepped onto it | the step under *"Zone 1 of 3 — encounter 15 of 16 (15 of 49) — the Withered Warden waits"*; **the battle fielded the Hollow Crown** all three times | the same readout; the battle fielded **the Withered Warden** all three times |
| The whole runs of §7, every zone's boss | seed 7: zone 1's boss was **the Crown**; zones 2 and 3 matched | seeds 7 and 11: all six zone bosses matched |

## §3 — THE LABEL AND THE TOOLTIP

### 3a. What the zone bosses read, verbatim

**All three zone bosses share one label and one tooltip; what differs between them is the name the readout prints.**
The label, the tooltip and the readout one step before each boss are read off the drives (§7), on both builds; the
readout before a zone's first step is the same format string the drives read in zone 1, filled with each zone's boss;
the victory card and the summary line are the code's own strings, and the drives pressed each card's button.

| Surface | Zone 1 | Zone 2 | Zone 3 |
|---|---|---|---|
| **Node label** | BOSS | BOSS | BOSS |
| **Tooltip** | *The zone's boss. Nothing goes around it.* / *You will not know which until you meet it.* | the same | the same |
| **Readout, before the first step** | *Zone 1 of 3 — 16 encounters to the Withered Warden* | *Zone 2 of 3 — 16 encounters to the Ash-Wrought Tyrant* | *Zone 3 of 3 — 16 encounters to the Withered Warden* |
| **Readout, one step before it** | *Zone 1 of 3 — encounter 15 of 16 (15 of 49) — the Withered Warden waits* | *Zone 2 of 3 — encounter 15 of 16 (31 of 49) — the Ash-Wrought Tyrant waits* | *Zone 3 of 3 — encounter 15 of 17 (47 of 49) — the Withered Warden waits* |
| **Victory card** | *THE ZONE IS CLEANSED*: *"+N gold."* / *"Each class that walked this road banks 1 talent point."*, then the pouch, relic, slot and ability lines; *Descend into The Scarlands* | the same; *Descend into Forest of Old* | the same; *Walk on* |
| **Summary, a run ended at it** | *"The zone boss — Boss Escort: …"* | the same | the same |

Beside them, for the voice: the **mini-boss** is labelled *WARDEN* with *"A mini-boss holds the middle of the zone."* /
*"You will not know which until you meet it."* / *"A bargain is offered before it."*; the **glossary** calls the end boss
*The End Boss* (*"A fourth boss after zone 3. Awards a relic while any is locked, no points, and opens a talent tier."*);
and the end boss's own victory card already says *"The road ends here."*

**The zone boss's second sentence stays true under §2.** *"You will not know which"* hides the warband, and the
escort still varies; the boss itself was always the zone's own until BM tagged the Crown into every roster.

### 3b. The proposal

As in NEEDS A RULING: label **END BOSS**; tooltip *"The END BOSS. Nothing goes around it."* / *"It is always the Hollow
Crown, and the road ends here."*; and the readout, past the final zone's boss, naming the Hollow Crown. The name in
both comes from the data (`Enemies.name_after_the(Run.END_BOSS_KIND)`) rather than being typed, and that helper exists
because the Crown's own name carries *"The"*: the readout's *"the %s waits"* would have printed *"the The Hollow
Crown"*, and the summary's end-boss line already did — *"facing the The Hollow Crown"* — in the one summary no run
could reach until now. It reads *"facing the Hollow Crown"* since GI, driven through a forfeit (§7).

### 3c. The name sweep (BR §1)

1,244 live names in 16 populations, collected off the game's own accessors: abilities 227 (`Classes.ability_corpus()`),
talent nodes 27, runes 254 (names and ids, retired included), relics 50, items 16, tags 7, specs 24, themes 12, zones 2,
difficulty rungs 3, statuses 309 (ids and labels), enemies 42, enemy abilities 48, glossary terms 196, event titles 20,
and the map's other node labels 7. Word-bounded, case-folded:

- ***END BOSS*: 0 exact.** Contained: the glossary term *The End Boss* (this node's own entry) and the label *BOSS* (the
  zone boss's) — same meaning both. Shared word: the theme *Boss Escort* and the glossary's *Boss Trophies* — bosses
  both. **Nothing a player fights, casts, wears or carries is called anything like it**, and none of the Crown's five
  abilities or the zone bosses' names is touched.
- **The tooltip names two live things and both are the thing itself**: *the Hollow Crown* and *The End Boss*.
- **The sweep's side finding is the mini-boss's label**, below in FOUND AND NOT FIXED.

## §4 — THE TWO ACCEPTED QUIT CONSEQUENCES, AND RAGE

Recorded in `docs/state.md`'s quit item as **ACCEPTED, NOT OPEN**, each with the reason — closing either needs the fight
itself captured (GG's A or B), and a quit already costs health, Mana, items and a death, which is the substance:

- **a quit before anything is lost rolls the opening again** — the turn order and the enemies' first declared moves;
- **a quit clears the heroes' cooldowns, once-a-fight refusals and statuses** along with the warband's.

**Rage's reset is recorded as the designer's ruling** in the same item, and in `CLAUDE.md`'s GH block, which said it was
owed one. `CLAUDE.md`'s block also gains the accepted pair as a rule — *do not queue either as a defect* — so a batch
reading the rule meets the ruling, not only a batch reading the queue.

## §5 — `main`

`main`'s `docs/state.md` read: *"… THE END BOSS HAS NO BUTTON … FOUND AT GF ON BOTH BRANCHES AND FIXED ON NEITHER."*
After GI that sentence is false, so it is the one line changed, documentation only: *"… BRANCHES; FIXED ON `class-merge` AT GI AND NOT HERE, BY RULING — IT ARRIVES WITH THE MERGE, AS DOES GI's FIX FOR A ZONE BOSS THAT CAN FIELD THE HOLLOW CROWN, WHICH IS `main`'s TOO."*. `main`'s code is
untouched, and it still carries both of GI's defects — its lattice loop and its composer are HEAD's (`git show main:`,
a comment apart).

## §6 — NOT DONE, AS RULED

- **Rage resets** — recorded as ruled, not changed (§4).
- **Melted Armor and Caught Fast** stay in the glossary.
- **The Peddler and the forge** stay lost on a quit.
- **The mini-boss awarding an upgrade the forge already applied** stays queued.
- **No merge work**: `data/`, `scripts/talents.gd`, `scripts/classes.gd` and `scripts/unit.gd` are unchanged, and no
  card, rune, node, number or engine moved.

## FOUND AND NOT FIXED

- **PLAYER-FACING: THE MINI-BOSS'S NODE IS LABELLED *WARDEN*, AND THREE LIVE NAMES CARRY THE WORD** — the Withered
  Warden (the first and third zones' boss, named by the readout on the same screen), the Warden spec, and the second
  difficulty rung. Found by §3c's sweep run over the existing labels. A label collision ships and is flagged (BR §1);
  renaming it is the designer's.
- **PLAYER-FACING, SMALL: A RUN ENDED AT THE END BOSS NAMES IT TWICE** under *The final battle* — *"The END BOSS — The
  Hollow Crown: The Hollow Crown."* — because the node's theme and its one enemy are both the Crown. The line's ordinary
  shape; its words are the designer's.
- **THE SIM NEVER FIGHTS THE END BOSS.** `run_sim.on_battle_end` ends a run at the third zone boss, and its own comment
  calls closing that a batch of its own because every sim baseline would move. Every sim completion is a
  third-zone-boss completion. It was recorded in the source only; it is in `docs/state.md` now.
- **NOTHING IN THE BATTERY PRESSES THE END BOSS'S BUTTON.** `check_fh` §8 reaches it through `_on_node_pressed`; the
  map-screen gates never draw the final board. A gate is owed to a test batch; GI was IMPLEMENT ONLY.
- **AT RUNG 1, A PARTY THAT STARTED THE END BOSS AT ONE HEALTH STILL BEAT IT.** A constructed drive set every hero to 1
  before stepping on; the Crown opened with Regalia (a ward on itself) and the Devout's Bulwark healed 10% a turn, and
  the party won. A datum about a placeholder boss at half damage, not a finding against anything GI changed.

## VERIFICATION

### The saves

Backed up before anything ran, at `save-backups/GI-20260914-200843/` (not committed), and verified by hash. All four read
the same as GH's figures:

| file | md5 |
|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

All four read the same as the backup before each battery's launch and after its run — the reconnaissance battery's, the pre-pass's and the acceptance battery's freezes each hash them with the tree — and the acceptance battery's after-freeze reads the four hashes above.

### The parse floor

`check_parse` read **183 checks / 0 failures** after the code edits, and its stream carried no `Parse Error`, `Compile
Error`, `SCRIPT ERROR` or `Failed to load` line — read off the stream, never off the tally or the exit code.
It read 183 / 0 again in all three batteries, the acceptance battery's over the finished tree with every document in place, each time with no error line in its stream; the count does not move, because no file joined or left the population it walks. `--check-only` on `map_screen.gd` and `battle.gd` prints `Identifier not found: Run` — and prints it
identically on HEAD's copies of both: a `--script` compile cannot see an autoload, which is `CLAUDE.md`'s own rule, and
it is not a parse error in either file. `run_state.gd` and `enemies.gd` compile clean under it.

### The probes and the drives

Four isolated copies, each with its `config/name` renamed so its `user://` was never the player's: **GI head** and **GI
head z** (HEAD's code) and **GI new** and **GI new z** (GI's). The probes and the driver live in the scratchpad, not the
tree. **Every drive steps onto a node by pressing that node's own lattice button** — found by what its `pressed` signal
is bound to — **and never calls `_on_node_pressed` by hand**: where the map draws no button, the drive stops and says
so, which is the reading GF's driver had to step around. A drive plays the real screens from the main menu: the draft,
the awakening, the map, bargains (the least severe), events, the Peddler and the forge (left), drafts declined and owed
picks taken, every fight fought by the autoplay bot on Wanderer (rung 1). **No log of any probe or drive carries a
`SCRIPT ERROR` or `Parse Error` line**; 66 of the 71 drive logs end on the engine's *"N resources still in use at exit"*
notice, which 75 of GH's acceptance logs carry as well — an engine message at exit, not a script's.

| Drive | Code | Seed | Reading |
|---|---|---|---|
| A whole run | HEAD | 7 | Zone 1's boss node carried **the Hollow Crown** under *"… — the Withered Warden waits"*; zones 2 and 3 matched. After the third zone boss's *Walk on*: 43 lattice buttons drawn for a 17-slot board, `reachable()` **[0]**, pressable **[]** — **NO BUTTON** for the end boss; the readout *"Zone 3 of 3 — encounter 16 of 17 (48 of 49) — the Withered Warden waits"*; the run active and saved, and nowhere to go |
| A whole run | GI | 7 | All three zone bosses the zone's own. After the third: the END BOSS button pressable (**[0]**), tooltip as proposed, readout *"… — the Hollow Crown waits"*; **the end boss pressed, fought and killed** after 32 battles |
| A whole run | GI | 11 | The same, 36 battles; the card's **New Run** opened the draft |
| A whole run, the end boss forfeited through the battle's ☰ | GI | 7 | The ☰ offered *Restart Run, Forfeit Run, Glossary, Settings, Exit to Main Menu*; *Just stopping* → *THE RUN IS ABANDONED* — *"Forfeited — Zone 3 (Forest of Old), facing the Hollow Crown (wanderer difficulty)."* / *"Reason given: Just stopping."* / *"The END BOSS — The Hollow Crown: The Hollow Crown."*; the run closed and Continue greyed; the profile booked no completion |
| A whole run, every hero set to 1 health before the end boss | GI | 7 | Constructed to reach the defeat card; **the party won anyway** (FOUND AND NOT FIXED) |
| Thirty new runs to zone 1's map | HEAD | 1–30 | 7 of 30 boss nodes the Hollow Crown; the readout named the Withered Warden every time |
| The same thirty | GI | 1–30 | 0 of 30 |
| Three walked to zone 1's boss and stepped on | HEAD | 1, 4, 8 | The battle fielded **the Hollow Crown** under *"… — the Withered Warden waits"*, three of three |
| The same three | GI | 1, 4, 8 | The battle fielded **the Withered Warden**, three of three |

**What the end boss's victory does**, read off the screen and off the copy's own disk (seed 7, a fresh profile):

- **The card:** *THE DECAY RECEDES* — *"Run complete — all 3 zones cleansed (wanderer difficulty)."* — then *The final
  victory*: *"+169 gold."* / *"The road ends here."* / *"RELIC UNLOCKED: Emberheart"* / *"Fire and Holy damage +20%."* /
  *"TALENT TIER 1 IS OPEN — for every class."* — then the heroes as they stood.
- **The awards:** one relic (Emberheart), the first talent tier, gold; no talent point and no ability pick, as ruled.
- **The profile write:** `talent_tier` 0 → **1**; `bosses_killed` Withered Warden 2, Ash-Wrought Tyrant 1, Hollow
  Crown 1 — the zone bosses booked as the bosses fought, which HEAD could not promise; `runs_completed` 1 for each of the
  four specs; `zones_cleared` 3; talent points 3 a class, all from the three zone bosses; no wipe.
- **The relic write:** `relics.json` holds four, one a boss kill, the end boss's included.
- **Whether the run ends cleanly: yes.** `Run.active` false, the run save deleted, the main menu's Continue greyed, no
  error line; the card's own buttons are *Copy summary* and *New Run*, with the battle's ☰ still on screen, and New Run opens the
  draft (seed 11). The second
  run in the same copy printed no tier line — the tier never falls, and a rung-1 clear opens tier 1 only — and doubled
  the tallies.

### The census

§2c's table: the composer at 2,000 draws a zone and map birth at 150 whole runs, on both builds.

### The gates, unmodified against the new code

- **Predicted before it ran**, in writing and stamped before the launch: every row at its `baselines.json` row,
  `check_de` 453 / 0 / 0, `check_cm_live` 13 / 4 with GH's four FAIL lines, and the two drifters (`test_batch_an`,
  `test_batch_bk`) inside their bands — named in advance as the risk, because a shuffled warband of a different size
  moves the dice for everything drawn after a board's boss.
- **The reading: the unmodified gates against the new code, before any gate or document moved.** 109 targets,
  20:31:56 → 21:18:46 (46 m 50 s); `.ran` is one sequence of 109 names in the battery's own order, with no duplicate.
  **`check_de` read 453 checks / 0 failures / 0 notices — every row at its band, the prediction.** `check_cm_live`
  13 / 4, its four FAIL lines identical to GH's acceptance log byte for byte; `test_batch_an` 6,053 and
  `test_batch_bk` 129, each inside its band; `check_fh` 163 / 0, `check_gf` 104 / 0, `check_parse` 183 / 0,
  `check_ct_map` 83 / 0, `check_map` and `check_flow` complete with no failure, and the harness 22 / 382 / 8 with no
  throws. No log carries a `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line. The tree and the four
  saves hashed identical before the launch and after the run (516 lines), and no Godot or battery process was in `ps`
  after it.
- **So nothing that reads the map's width moved, and no gate was re-pointed.** The brief expected movement (§0 row 19);
  §1b's census is why there was none — no target reads the drawn width. **`baselines.json` is unchanged**, because a
  baseline moves only in the batch that moves it, and nothing moved.

### The literal sweep

Every string literal of four or more characters in the 113 root `.gd` files — **13,266 distinct** — checked raw,
lowered and whitespace-flattened against HEAD's copy and the new copy of each edited file, with the population printed
(the instrument refuses to report below 100 files or 10,000 literals).

| Edited files | LOST | GAINED |
|---|---|---|
| `scripts/map_screen.gd`, `run_state.gd`, `battle.gd`, `enemies.gd` | 0 | 15 |
| `CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md` | 0 | 5 |
| `docs/state.md` | 7 | 3 |

**Every holder was read, and none is a needle into the file that moved.** The GAINED are data keys and labels
(`endboss`, `final`, `summary`, `Other`/`other`, `after`, `line`, and *the main menu* — `check_fh`'s census label), two
screen texts (*THE HOLLOW CROWN*, `check_fh`'s card search, and *The road ends here.*, `test_batch_bl`'s snapshot
argument), `check_fs`'s number words (*seventeen*), three format-string fragments (`   %s`), and two gates' parsing
vocabulary (`begins_with`, `substr(`). **`docs/state.md`'s seven LOST and three GAINED** are button prefixes, tally
keys, format strings and file paths held by `check_fh`, `check_fq`, `check_eg`, `check_ek`, `check_fd`, `check_fe`,
`check_fn` and `test_run_harness` — and **the only target that opens `docs/state.md` is `check_es`**, which reads it by
regex for its *"2+ threshold"* windows: two before the rewrite and two after.

### The retired-word pre-check

`test_batch_bx` §4 (*beast*) and §4b (*party*) reproduced — string literals only, the same identifier strips — over the
thirteen scripts they read and over the new `master.html`: **0 strays**, on HEAD and on the new tree alike. The new
literals are *END BOSS*, the tooltip and a `"The "` in `enemies.gd`.

### The pin manifest

`build_pin_manifest.py --check` read the manifest **current, 1,464 pins**, with the code edits in, and `check_ed` read
**18 / 0** against HEAD's manifest. Over the landed tree, with every document in place, it read **current again, 1,464 pins**, and `pin-manifest.json` is unchanged: no source pin moved and no document pin's holder changed.

### The pre-pass, and the acceptance battery

- **A pre-pass over the landed tree, before the acceptance battery**: every suite that opens one of the five edited
  documents — twenty-four, derived by `res://` path — and every gate, the harness and both scene runs, through
  `run_battery.sh` itself (`./run_battery.sh ah as at aw ax ay az ba bb bn bo bp bq br bs bt bu bv bw bx cb cd ce cp`),
  in the real tree. 87 targets, 21:20:34 → 21:56:07 (35 m 33 s); `.ran` is one sequence of 87 names in the subset's own order, with
  no duplicate. **`check_de` read 365 checks / 1 failure / 0 notices, and the one failure is the subset refusal by
  design** — *"22 DID NOT (a subset run cannot certify the tree)"*, naming exactly the twenty-two suites not asked for.
  Every other row read at its band: `test_batch_bx` 156, `test_batch_ce` 1,114, `test_batch_cd` 99, `check_ec` 23,
  `check_es` 57, `check_fg` 22, `check_fs` 33, `check_dv` 83, `check_ff` 55, `check_fr` 25, `check_ed` 18, `check_da`
  43, `check_dw` 35, `check_ek` 46, `check_ea` 86, `check_parse` 183, `check_fh` 163, `check_fx` 496 and `check_gf`
  104, every one at 0 failures; `check_cm_live` 13 / 4 with GH's four FAIL lines. No log carries an error line, and the
  tree and the four saves hashed identical before and after (517 lines, this report among them).
- **Acceptance: every target through `run_battery.sh` in the real tree**, over the finished tree with every document in
  place and nothing edited during it.
  - **Predicted before it ran**, in writing: every row at its `baselines.json` row, `check_de` 453 / 0 / 0,
    `check_cm_live` 13 / 4 with GH's four FAIL lines, and the two drifters inside their bands.
  - **The reading.** 109 targets, 21:57:16 → 22:43:54 (46 m 38 s). `.ran` is one sequence of 109 names in the battery's
    own order, with no duplicate. **`check_de` read 453 checks / 0 failures / 0 notices — the prediction, row for
    row.**
  - **The rows quoted.** `check_fh` 163 / 0, `check_gf` 104 / 0, `check_parse` 183 / 0, `check_fx` 496 / 0, `check_es`
    57 / 0, `check_ec` 23 / 0, `check_ed` 18 / 0, `check_fg` 22 / 0, `check_fs` 33 / 0, `test_batch_bx` 156 / 0,
    `test_batch_ce` 1,114 / 0 and `check_ct_map` 83 / 0; `test_batch_an` read 6,050 and `test_batch_bk` 130, each inside
    its band; `check_map` and `check_flow` complete; the harness 22 / 382 / 8 with no throws.
  - **`check_cm_live` read 13 / 4, the sanctioned red, and its four FAIL lines are identical to GH's acceptance log byte
    for byte** — as they were in the reconnaissance battery and the pre-pass. GI touched `battle.gd` at a comment and
    the end boss's summary line, nowhere near the defensive bar that gate presses.
  - **No error lines.** No `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` line appears in any of the
    109 logs, nor in the reconnaissance battery's 109 or the pre-pass's 87.
  - **The freeze.** Every file in the repo but `.git` and the `.godot` build cache — tracked, untracked and ignored — and
    the four player saves were hashed before the launch and after the run: **517 lines, identical byte for byte**. No
    Godot or battery process was in `ps` before the launch or after the run.
  - **One file was written after the run: this report.** Its acceptance figures went in after the after-freeze was
    taken, and no gate or suite reads `docs/reports/`.

### `CLAUDE.md`

**329,140 B (321.43 KiB)**, +2,172 B this batch, against the 340 KiB ceiling — 19,020 B (18.57 KiB) under it. The changelog is **330,117 B**, +2,218 B, 69,883 B under its 400,000 B bar.
`check_fg` read both in the acceptance battery.

### The push

To `class-merge`, once this report's figures were in. `git ls-remote origin class-merge` is read against local HEAD after
the push and reported with the batch, because a commit cannot carry its own hash. `main`'s one line is its own commit on
`main`, pushed after `class-merge`'s, and its hash is reported the same way.

## THE FOLDERS THIS BATCH LEFT

Four scratch `user://` folders under `~/Library/Application Support/Godot/app_userdata/`: *Dawn of Decay GI head*,
*GI head z*, *GI new* and *GI new z*, one for each isolated copy the probes and drives ran in. Nothing in the game reads
them, and they are safe to delete. The backup is at `save-backups/GI-20260914-200843/`, untracked like its predecessors.
