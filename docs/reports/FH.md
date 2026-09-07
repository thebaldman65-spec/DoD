# BATCH FH — THE ARCHIVE COMES INTO THE REPO, AND A WHOLE RUN IS DRIVEN THROUGH THE REAL SCREENS

*2026-09-06. Two halves, and the second is the batch. §1 brings `DoD-archive/` into version control
for one header edit. §2 is the first thing in this project that plays the game: a real, non-sim run
walked end to end through the shipped screens, pressing real buttons. **No rune, card, ability,
talent, constant or magnitude moved, no rule about the game was written, and no file under
`scenes/` or `scripts/` was touched.***

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

| Premise | What the repo says |
|---|---|
| *"the rune offer — the Peddler, an elite cache …, and **a boss trophy**"* | **A BOSS AWARDS NO RUNE.** `_resolve_boss` awards a relic, a slot rung, an ability pick and a meta talent point, and reaches no rune door at all. The live doors are the **Peddler**, the **elite cache**, the **bargain's `rune` reward** and the **event verb `rune_grant`**. "Trophy" in this tree means a `SPEC_POOLS` boss-pick ABILITY, which is what §6 drives. §3 asserts the absence so the claim cannot rot back in. |
| *"**1,646,681 B** of history"* | **THAT IS THE ARCHIVED CHANGELOG ALONE.** The folder is **1,680,660 B** — the retired `addendum.html` (33,711 B) is beside it and moves with it. |
| *"which is exactly what the **44 test suites** do"* | **44 IS THE `test_batch_*` COUNT.** The tree holds **47 `test_*.gd`** files and the battery runs **46** of them (`test_run_harness` is driven separately by `DOD_GATE`). `docs/state.md` says 47 and the brief says 44; they are two different populations and both readings are live. |
| *"`DoD-archive/`, one level up beside the `.docx` exports"* (`README.md`) | **FALSE ON BOTH HALVES.** The repo root is `DoD/game`; the archive was at `Documents/DoD-archive` — **two levels up**, and the `.docx` exports are in `DoD/`, one level *below* it. Corrected. |
| *"Confirm nothing reads the archive by absolute path or by an out-of-repo assumption"* | **ONE THING DID, AND IT IS THE HEADER.** §1. |
| *"the last four player-visible defects were all found by a person playing and none by a battery"* | **TRUE, AND §2 IS THE ANSWER TO WHY.** `map_screen._on_node_pressed` opens with `if Run.sim_run: return`. |

---

## §1 — `DoD-archive/` IS IN THE REPO

**Two files, 1,680,660 B, moved in and proved byte-identical by md5 against a copy frozen before
the first byte moved.**

**THE REASON IT WAS EVER OUTSIDE WAS KNOWLEDGE-SYNC CAPACITY, AND THE FILE PICKER HAD SOLVED THAT
PROBLEM THE WHOLE TIME.** Tracked and deselected is exactly what the 44 suites already are. Two
tools, two problems — version control for backup, the picker for capacity — and the repo boundary
was being used for both.

### 1a. THE ONE THING THAT RESOLVES THE ARCHIVE IS THE LIVE CHANGELOG'S OWN HEADER

**Fifteen readers follow it** — the fourteen suites `bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw,
bx, cb, ce` plus **`check_dv` §4** — each one finding `/changelog-archive.html</code>` and reading
back to the opening `<code>`:

```gdscript
var mark := live.find("/changelog-archive.html</code>")
var open_at := live.rfind("<code>", mark) + 6
var arch_path := live.substr(open_at, mark + "/changelog-archive.html".length() - open_at)
```

**NO `.gd` FILE IN THE TREE NAMES THE ARCHIVE BY PATH** — swept comment-stripped and raw — so the
move was **one header edit**. The absolute `/Users/zipples/Documents/DoD-archive/…` becomes
**`res://DoD-archive/changelog-archive.html`**, which is machine-independent as the old one was
not: fifteen assertions became portable without one of them being touched.

**THE LEADING SLASH IS STILL THE ANCHOR AND IT STILL MATTERS.** The header names the file twice
and the bare-filename mention comes first; `/changelog-archive.html</code>` skips it.

**AND FG'S OWN CHANGELOG ENTRY KEEPS THE OLD ABSOLUTE PATH.** An entry is history and is not
edited. `find` returns the first occurrence and the header is above it, so the entry is inert.

### 1b. RUN BEFORE ANY ASSERTION WAS EDITED, AND ARMED TO PROVE IT

**All fifteen ran green against the moved tree before one assertion was edited** —
`test_batch_bb` 177/0, `bn` 81/0, `bo` 1140/0, `bp` 276/0, `bq` 883/0, `br` 1592/0, `bs` 267/0,
`bt` 375/0, `bu` 444/0, `bv` 864/0, `bw` 515/0, `bx` 161/0, `cb` 1370/0, `ce` 1114/0 and
`check_dv` 83/0 — alongside `check_ec` 23/0, `check_ed` 18/0, `check_ea` 86/0, `check_fg` 22/0,
`check_ff` 55/0 and `check_parse` 171/0.

**A CLEAN PASS AFTER A MOVE IS EXACTLY WHAT A READER THAT NEVER RESOLVED ANYTHING WOULD PRINT**, so
the pointer was armed at a directory that does not exist:

| arm | result |
|---|---|
| header points at `res://DoD-archive-NOPE/…`, `check_dv` | **83 / 4** — "the archive reads 0 characters", 0 entries, EP dropped, header no longer names the live file |
| the same, `test_batch_bb` | **177 → 173 checks, 2 failures, 1 throw** — the count falls as well, which is `check_de`'s own signal |

### 1c. WHAT TO DESELECT, MEASURED

**`DoD-archive/` — both files. Nothing else needs to move.**

| block | files | B | MiB | share |
|---|---|---|---|---|
| **`DoD-archive/` (new at FH)** | **2** | **1,680,660** | **1.6028** | **14.2%** |
| `docs/reports/` | 64 | 1,736,240 | 1.6558 | 14.6% |
| `test_*.gd` suites | 47 | 1,993,161 | 1.9008 | 16.8% |
| `check_*.gd` + fixtures | 55 | 1,050,745 | 1.0021 | 8.9% |
| `pin-manifest.json` | 1 | 326,436 | 0.3113 | 2.8% |
| audits (`docs/*-audit.html`) | 4 | 377,803 | 0.3603 | 3.2% |

**The archive alone is larger than every `check_*.gd` in the tree put together.** The sync reads
**11.3106 MiB** with it and **9.7078 MiB** without it — *exactly where it stood before this batch*.

The ladder, applying the standing list in order: everything **219 files / 11.3106 MiB** → less the
archive **217 / 9.7078** → less the suites **170 / 7.8069** → less `pin-manifest.json` **169 /
7.4956** → less `docs/build_docs.py` **168 / 7.4939** → less the four ruled-on audits **164 /
7.1336 MiB**.

**`docs/reports/` IS NOW THE SECOND-LARGEST BLOCK AND GROWS BY ONE FILE EVERY BATCH.** Reported,
**not recommended**: `CLAUDE.md` lists it as MUST STAY SELECTED and moving it is a ruling.

---

## §2 — `check_fh.gd` DRIVES A WHOLE RUN, AND IT IS THE BATCH

**161 checks, 0 failures, ~70 s, deterministic across three standalone readings.**

**THE ARGUMENT FOR IT IS ONE LINE OF `map_screen.gd`:**

```gdscript
func _on_node_pressed(j: int) -> void:
	if Run.sim_run:
		return
```

That line is why `run_sim` and a player are two different programs. RunSim walks `Run` directly and
never loads a screen, so every defect that lives in a screen is invisible to a battery that is
otherwise very good indeed. **The last four player-visible defects were all found by a person
playing and none by 46 suites and 46 gates.**

**SO THE DRIVE IS NOT A SIM.** `sim_run` is false, the scenes are the shipped scenes, and every
step is `emit_signal("pressed")` on the Button the screen drew — never a call to the handler,
because a button whose signal was never connected is the defect being hunted and calling the
handler hides it.

### 2a. THE THREE THINGS THAT MADE A LIVE DRIVE POSSIBLE

1. **`Engine.time_scale` MUST BE RE-ASSERTED EVERY FRAME.** `battle._break_impact()` sets it to
   `0.05` for a hitstop and then puts it back to the **literal `1.0`** rather than to what it was,
   so the first Break of the run silently cancels any scale a driver set. **Measured: 561 s for ten
   battles set once, 15 s for the same ten re-asserted.** Invisible in play, where the scale is
   always 1.0 — which is why it survived.
2. **THE PLAYER'S RUN SAVE IS A FILE THE GATE MUST OWN.** `Run.SAVE_PATH` is a `const` and cannot
   be redirected the way every suite redirects `Profile.save_path`. **An in-memory backup is not
   enough, and this gate proved it on its author** — see §3.
3. **THE DRIVE OWNS NO SCENE.** A `--script` SceneTree has no `current_scene` of its own, so
   `change_scene_to_file` — what every real button calls — behaves the way a button makes it
   behave, with nothing of the gate's in the way.

### 2b. §1 OF THE GATE — THE RUN, WALKED

**All 49 encounters.** 30 battles, 8 elites, 3 zone bosses, 3 mini-bosses, 4 events, 5 merchants,
8 blacksmiths; **7 draft screens with 28 cards pressed, 28 tag lines rendered and 12 benches**;
7 rune picks, 8 ability picks and 12 upgrade picks answered on the cards; 30 shop purchases;
11 bargains taken; 2 potions drunk through the map's own footer button and target picker.

**IT ASSERTS THE DRIVE, NEVER THE BALANCE.** Where the autoplay bot dies is **printed, not
asserted**: it reached **slot 47 of 49 on rung 1** and wiped at the third zone. That is a bot
datum — the bot rolls a flat `good` on every skill check, never drinks a potion *in a fight*
(`battle.gd` gates its item use on `RunSim.active`), and this route takes the first reachable node
every time. **A stall, a screen with no way off, or a button that does nothing is this batch's
business; where a bot dies is the designer's**, and a gate that asserted it would red on ordinary
tuning work.

**THE DRIVE PLAYS WANDERER, RUNG 1, AND THAT IS A PLAYER'S CHOICE RATHER THAN A THUMB ON THE
SCALE.** `Run.difficulty` defaults to `wanderer`; the string `"standard"` that `gate_fixture`
passes is a LEGACY id resolving to `warden`, **rung 2 at ×1.00** — so a drive that copied the
fixture would have been playing a harder run than the one the menu opens on. On rung 2 the same
drive died at slot 32.

### 2c. EVERY PATH THE BRIEF NAMED — DRIVEN OR NOT DRIVEN

| path | | what happened |
|---|---|---|
| **The draft** — an offer at each slot count | **driven** | The ladder is `[7, 8, 9, 10]` indexed by zone bosses cleared, asserted as a list. The route only reaches 7/8/9, so the fourth rung is **constructed**; the offer and the press are not. |
| — a swap and a bench | **driven** | At the cap, the card button only STAGES; the re-drawn column carries `Choose what <card> replaces`, and **that** opens the z=64 overlay whose buttons read `Bench <name>`. Two presses, not one. The **protected core is asserted absent** from that list. Pool 8 → 9 while the loadout stays 8 — EG §2's "a benched card is KEPT". |
| — the tag line on the card | **driven** | `Classes.card_tag_line` read **off the overlay**, not off the table. 28 of 28. |
| **The rune offer** — the Peddler | **driven** | 4 runes offered, one bought on the real Buy button; the hero's pouch grew by exactly that rune. **The screen is asserted not to name a draft** — FD's defect. |
| — an elite cache **answered a node later** | **driven** | Rolled, then `Run.advance` walks a whole node, then the card's own overlay is opened and pressed. The pick survives the step; the offer is asserted to contain no **retired** rune (ES §1's defect) and none already worn (CD's). |
| — a boss trophy | **not a rune source** | §0. `_resolve_boss` is swept comment-stripped for `roll_rune_candidates`, `grant_rune` and `rune_picks_owed`: none. Asserted, so the day one is added the claim is re-derived. |
| **A rune's condition on and off by benching** | **driven** | A tag threshold met, then broken by pressing `Bench` rows on the real loadout panel, then restored by pressing `Carry`. **Both surfaces followed** — the panel's `RUNE CONDITIONS` line and the hero sheet's. |
| **The pouch** — purchase / slot grant / full-stack refusal / sell | **driven** | Purchase moves gold and takes a slot. The ladder is **`[4, 5, 6]` indexed by `zone_idx`**, *not* by bosses cleared — the ability ladder is the one indexed by bosses, and the two part company on the third boss. A full stack **takes no gold**. A sell is **two presses** and takes the **whole stack and its slot**. A new kind at a full pouch is **queued as a CHOICE**, not refused (CT §3). |
| **The skill check** — ordinary / gated / defensive / the Sharpshooter's four presses | **three driven, one half-driven** | See §2d. |
| **A zone boss award at an exhausted pool** | **driven** | Both earlier tiers emptied through the run's own doors; **EA §1's fallback and EH §1's third tier pay**, the offer comes from the class pool, and it is answerable on the real card. |
| **The end boss** | **driven** | Reached by **pressing the last node** on the final zone's map — `advance_zone` to the last zone, stand on the zone boss, press its one link. The board is `The Hollow Crown`, the run-summary card is drawn, `Run.active` goes false. |

### 2d. THE SKILL CHECK, AND THE ONE HALF `--headless` CANNOT REACH

**Ordinary, gated and the sequence are driven on the real bar** — `sc_pos` set, `_grade_skill_check()`
called, the bar asserted VISIBLE while it grades. Centre → `perfect`, 0.60 → `good`, 0.99 → `fail`;
the gated bar's own line reads `SPACE or CLICK — A SLOPPY LOSES THIS CAST` and `_gated_failure`
spends **neither the resource nor the cooldown**.

**THE SHARPSHOOTER'S EXCEPTION IS ASSERTED IN SECONDS, NOT IN FRACTIONS, AND THE FRACTION IS THE
WRONG READING.** His `good_half` is **0.2615 of the track against the default's 0.1600** — 63%
*wider* — because his `sweep_time` is his own literal 0.52 s. In tolerance it is **0.1360 s against
0.1600 s**, the fixed 15% less that `CLAUDE.md` states, and **both halves take the identical
offset**, which is what "an offset, not a slope" has to mean numerically. A gate comparing
`good_half` alone would conclude the exception runs backwards.

**THE DEFENSIVE CASE IS HALF-DRIVEN AND THE OTHER HALF IS UNREACHABLE BY CONSTRUCTION.**
`_defensive_brace` chooses between the bar and a bot roll on `_nobody_can_press()`, which is
`sim or autoplay or DisplayServer.get_name() == "headless"` — so under **every** gate in this
project the bot branch is taken and the bar can never open through an attack. **`check_cm_live`'s
four standing failures are that one fact, not four defects**: `the bar appeared`, `the bar's top
line names the incoming blow`, and two comparisons of two bot rolls. CQ §1 made it that way
deliberately, to stop four suites deadlocking on a modal nobody could press. So §7 drives the
**bar** the way the brace calls it — it grades, it says `INCOMING`, it carries no Cancel — and
**asserts `_nobody_can_press()` is TRUE**, so the day that stops being true the gate says so and
those four reds are re-derived rather than carried.

### 2e. TWO CENSUSES, BECAUSE THE DEFECTS THE BRIEF NAMES ARE VISUAL

**§9 — EVERY VISIBLE ENABLED BUTTON ON 13 SCREENS IS ASKED WHETHER ANYTHING IS CONNECTED TO
`pressed`.** No press is needed, so it is safe on Sell, Discard and Confirm. **120 buttons, 0
dead** — the map (31), the draft screen (5 and 6 staged), the upgrade overlay (4), the rune pouch
(4), the loadout panel (5), the item target picker (5), the Peddler (13), the Blacksmith (4), the
hero sheet (32), the bargain (3), an event (3), the main menu (5).

**THE 28 EXEMPTIONS ARE MECHANICAL, AND THAT IS THE DIFFERENCE BETWEEN A CENSUS AND A LIST.** A
`MenuButton`'s action lives on its popup; a **hover surface** is `focus_mode` NONE + an arrow
cursor + something connected to `mouse_entered`. A list of names would go stale the day a screen is
redrawn; **a control that lost its handler matches none of the three.** The population is printed
`n of m` beside every screen, because a census that walked nothing prints exactly like a census
that found nothing wrong.

**§9b — THE RENDERED STRINGS AGAINST THE RUN'S OWN NUMBERS.** Gold, pouch slots, hero HP, the hero
sheet's rune line — and **something is bought to prove the shop REFRESHES** rather than drawing a
correct first frame. This is the one defect class every other instrument is blind to by
construction: **every gate reads `Run`, and so does the label, so the two can only disagree on a
screen.**

---

## §3 — SIX THINGS FOUND AND DELIBERATELY NOT FIXED

**None is a crash and none is a softlock**, so under the brief's rule they are listed and the
designer rules on what matters.

**(1) `check_da` AND `check_cs` DELETE THE PLAYER'S RUN SAVE. This is the largest of the six.**
`gate_fixture.spawn` sets `run.sim_run = false` and `run.active = true` — it has to, because a
`sim_run` battle is not the battle a player fights — and `battle._check_end` then reaches
`Run.clear_save()` on a wipe and `Run.save_run()` on a victory. **MEASURED BY BISECTION, ONE GATE
AT A TIME AGAINST A FRESH COPY OF A REAL 62,360 B RUN SAVE:**

| gate | the save after |
|---|---|
| `check_da` | **GONE** |
| `check_cs` | **GONE** |
| `check_ea`, `check_ec`, `check_ed`, `check_es`, `check_fg`, `check_parse` | byte-identical |

Only `check_ct` and now `check_fh` protect it. **THE SYMPTOM IS SILENCE**, which is why it
survived: the next run of anything simply reports there was no save to protect.

**(2) The defensive brace's player branch is unreachable headless** — §2d.

**(3) `battle._break_impact()` restores `Engine.time_scale` to the literal `1.0`** — §2a.

**(4) The hero sheet draws 27 enabled Buttons that do nothing when pressed.** Deliberate, and
`party_screen._make_tree_node` says so: *"neither is clickable. `Button` survives only because it
is the cheapest hover surface; `disabled` stays false or the tooltip stops firing."* Reported
because it is the same silhouette as the 604 dead buttons that shipped once.

**(5) `Run.grant_rune` returns a rune it does not FIT.** Its callers — measured, `events.gd` and
`run_sim.gd` — append to `member["runes"]` themselves. Not a defect today; exactly the shape that
goes wrong on the next caller, and it read an empty pouch in this gate's own first draft.

**(6) No boss awards a rune** — §0.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No rune, card, ability, talent, constant or magnitude moved. No new rune was authored.**
- **No file under `scenes/` or `scripts/` was touched.** §2 found six things and repaired none of
  them, because none is a crash or a softlock.
- **The `.docx` exports stay stale.** The designer ruled it.
- **No document was swept and no rule about the game was written.** The two new rules are about
  INSTRUMENTS and went straight into `docs/instrument-rules.md`, costing `CLAUDE.md` two index
  rows.
- **`docs/reports/` IS NOT PROPOSED FOR DESELECTION.** It is the second-largest block and grows
  every batch, and `CLAUDE.md` lists it as MUST STAY SELECTED. **Recorded, not taken.**

---

## §5 — VERIFICATION

- **The tree was frozen with a 301-file `rsync` as this batch's FIRST action**, the archive
  included, before the first byte moved.
- **DOCUMENTATION WRITTEN BEFORE THE VERIFICATION RUN.**
- **HEAD's unmodified gates run against the moved tree BEFORE any of them was edited** — the
  fifteen archive readers plus `check_ec`, `check_ed`, `check_ea`, `check_fg`, `check_ff` and
  `check_parse`: **all clean.**
- **AND RUN AGAIN ONCE THE NEW GATE WAS IN THE TREE**, which is FF §3b's rule. **That pass is what
  found `check_da` 41 → 43 / 4**, and it found two different faults wearing one name:
  1. a gate that reads **both** draft pools trips §3's enumeration fingerprint. Fixed toward the
     rule — the pools are asked through **`Run.draft_pool_left`**, the draft's own door, which
     answers the membership question the flat corpus cannot.
  2. **A COMMENT NAMING THE BATTLE SCENE'S PATH TRIPS THE FIXTURE FINGERPRINT EXACTLY AS THE PATH
     DOES**, because the match is a plain substring on RAW source. The gate read **42 / 2 on a file
     that instantiates nothing**. This is EV §5's standing rule — *prose recording a removal reads
     exactly like the removal not happening* — arriving through a gate's own fingerprint, so no new
     rule was written for it.

  Neither was fixed by an exemption.
- **EIGHT CONTROLS, EIGHT BITES**, each confirmed to break the arm it aims at:

  | arm | result |
  |---|---|
  | a dead Button added to the map footer | **§9: 1 button with nothing connected** |
  | the Peddler's gold label drawn off `Run.gold + 1` | **§9b: 2 failures, on arrival and after the purchase** |
  | the bench overlay made to refuse to open | **§2: 7 failures, and 157 → 153 checks** |
  | `roll_rune_candidates` added to `_resolve_boss` | **§3: "the brief's `boss trophy` has become real"** |
  | `_gated_failure` made to spend 1 resource | **§7: "A GATED FAILURE SPENT THE RESOURCE — 40.0 → 39.0"** |
  | `ITEM_SLOTS_BY_ZONE` moved to `[4, 4, 6]` | **§5: "the pouch ladder read [4, 4, 6]"** |
  | the tag line stopped rendering on the card | **§2: "0 of 12 cards rendered their tag line"** |
  | the bargain screen made never to leave | **§1: "the drive walked only 2 encounters"** |

- **AND ONE CONTROL DID NOT BITE, WHICH IS THE WHOLE REASON THEY ARE ARMED.** The gated-resource
  injection first read **157 / 0**: the hero the arm stood on had **zero resource and no cooldown**,
  so `maxf(resource - 1, 0)` changed nothing and the assertion passed on a meter that could not
  fall. The arm was repaired to put the meter and the cooldown somewhere they can fall from — with
  a check asserting exactly that — and the same injection then read **158 / 1**.
- **AND A TWO-ARMED CONTROL ON THE SAVE REPAIR.** Arm one is HEAD's shape, which is what destroyed
  a real run save. Arm two: `kill -9` the gate the instant the save disappears, then run it again —
  **62,360 B recovered, byte-identical.**
- **AND A TWO-ARMED CONTROL ON THE COUNT.** The restore's byte-equality arm was guarded behind
  `if _had_save`, so the gate read **160 on a machine with no run in progress and 161 on one with a
  save** — a baseline that reds for a reason unrelated to the tree. Both arms run unconditionally
  now and it reads **161 / 0 both ways**, measured by moving the save aside and back.
- **Two baseline rows, both written before the battery**, each off **three identical standalone
  readings**: `check_fh` new at **161 / 0**, and `check_parse` **171 → 172** — a new battery target
  raises the gate whose count IS its coverage, and **a new gate owes two rows**.
- **`pin-manifest.json` regenerated: 1412 → 1417.** It read `current` at first, and the reason is
  now a standing rule: **the manifest binds a holder off `var x :=` and never off `var x: String
  =`**, so a gate written with explicit types pins nothing it can see.
- **BATTERY 1 — 98 TARGETS, AND ONE UNPREDICTED RED.** Zero `Parse Error` and zero
  `SCRIPT ERROR` across all 98 logs; the tree **md5-frozen with 301 files byte-identical before
  and after**, stamped with absolute paths so a moved working directory could not read as drift,
  and **no file appeared or vanished**. `check_fh` **161 / 0** and `check_parse` **172 / 0**, both
  matching the rows written before the run; all 46 suites green; the harness 22 / 166 / 8;
  `check_ct_map` 83 / 0. **The only sanctioned red, `check_cm_live` 13 / 4**, exactly as recorded.
  **THE ONE UNPREDICTED RED WAS `check_ek` 46 / 1** — §3's authored `TAG_CHECKERS` census, which
  a new gate joins BY EXISTING: `check_fh` §2 reads `Classes.card_tag_line` off the draft card
  (EK §3's own feature) and §4 reads `TAG_ORDER` and `primary_tag_count` for a rune condition.
  **LISTED, NOT EXEMPTED**, which is what EZ added the fifth for, FD the sixth and FE the seventh.
  `check_de` reported it as *"check_ek went REDDER"*, which is precisely the movement it exists to
  see. **AND THE PRE-PASS SHOULD HAVE CAUGHT IT: it ran a CHOSEN SUBSET of the gates rather than
  all of them**, which is the transferable half and is written into `check_ek.gd` beside the name.
- **AND BATTERY 1 DESTROYED THE PLAYER'S RUN SAVE, IN THE WILD, EXACTLY AS §3(1) PREDICTED.**
  `check_fh` runs after `check_da` and `check_cs` in the GATES order and its own first line read
  `none — nothing to protect`. The save was backed up before the battery and restored after,
  byte-identical. **That finding is no longer an inference from a bisection; it is a measurement
  of a whole battery run.**
- **BATTERY 2 — THE ACCEPTANCE RUN, AND IT IS CLEAN.** After the one repair —
  `check_ek.gd`'s authored `TAG_CHECKERS`, one name added with its reason — and a fresh md5
  freeze: **98 targets**, `check_de` **402 checks / 0 failures / 0 NOTICES**, so every count in
  the tree matches its baseline exactly. **`check_fh` 161 / 0** and **`check_parse` 172 / 0**,
  both matching the rows written before the first run; **`check_ek` 46 / 0**; all 46 suites green
  with 0 throws; the harness **22 / 166 / 8**; `check_ct_map` **83 / 0**; `check_dv` 83 / 0,
  `check_ec` 23 / 0, `check_ed` 18 / 0, `check_da` 41 / 0, `check_ea` 86 / 0, `check_ff` 55 / 0,
  `check_fg` 22 / 0. **THE ONLY RED IS `check_cm_live` AT 13 / 4** — its recorded baseline and the
  one red that is on purpose.
- **Floor: `grep` stderr for `Parse Error` across all 98 logs — ZERO, and zero `SCRIPT ERROR`.**
- **THE TREE WAS md5-FROZEN ACROSS BOTH RUNS: 301 files byte-identical before and after each**,
  the archive included, stamped with absolute paths so a moved working directory could not read as
  drift, and **no file appeared or vanished**. **No red was repaired while a battery ran.**
- **THE PLAYER'S RUN SAVE WAS BACKED UP BEFORE THE BATTERY AND RESTORED AFTER IT**, byte-identical,
  because of §3(1).
