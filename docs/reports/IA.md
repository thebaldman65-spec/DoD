# BATCH IA — THE THIRD CORE SLOT, AND THE BAG

**On `class-merge`, from `91a824e` (HZ). IMPLEMENT ONLY.** **§0: HZ's seven rulings are answered** — one changed code (the
reflect's log line and Lifewell read what landed, §1) and six are confirmed with their reasons written where a later batch will meet
them. **§2: a hero equips three core runes** — `Run.ENGINE_SLOTS` 2 → 3, a flat constant read by name everywhere; no save carries
it, so no save version moved, driven both ways; a core rune applies at the spawn; the event verb's fallback was the one door left
that could slot a core rune on arrival, and it holds it now. **§3: the hero's rune panel is three sections** — CORE (every slot
drawn), WORN, HELD, NOT WORN — and the sections replace the per-row state; the crest's bag is untouched, the kit preview stays flat.
**§4: the word is CORE** on the hero sheet and the kit preview. **§5: one stale claim** points at its instrument. **§6: HZ's fifteen
folders were not cleared** — the move was refused. **§8: two recons of HEAD's whole battery — §1 alone, then all of IA's code — and the
second found what IA moved in eight gates**, each a gate meeting the sections or the cap, **and one thing more: the panel scrolls where a
core slot is empty, because an empty slot is a row, and the first re-point of `check_gt` had walked only the case with every slot
filled** — the shortest. Repaired in the gate, controlled two-armed, and folded into ruling 1.

**VERDICT: LANDED.** HZ's seven rulings are answered — one in code, the reflect's log line and Lifewell reading what landed, and
six confirmed with their reasons recorded where a later batch will meet them. **The third core slot and the screen that shows it
shipped as one change**: `Run.ENGINE_SLOTS` is three and read by name everywhere, no save version moved (driven both ways), a core
rune still applies at the spawn, and the event verb's core rune is held unworn; the hero's rune panel is three sections in the
designer's order, the sections replacing the per-row state, the crest's bag untouched and the kit preview flat. §4 and §5 shipped
too. **HEAD's whole battery read IA's code twice — §1 alone moved nothing; all of it moved eight gates, each meeting what IA
changed, and showed that the first re-point of `check_gt` walked only the shortest panels — and every one was re-pointed,
re-tuned or repaired to intent and controlled**: forty-five controls — thirty-five, then ten on the repaired `check_gt`, the
repair two-armed against its own first version and every earlier control that ran it re-run — every defect red at its line. The pre-pass and the acceptance run read `check_de`
581 / 0 / 0, each as predicted. **HZ's fifteen folders were not cleared — the move was refused, and §6 carries the command.** Five rulings are owed and none
blocks; the first is whether the panel pages where it scrolls.

## NEEDS A RULING

1. **THE PANEL SCROLLS WHERE IT HOLDS MORE THAN THE SCREEN (§3d).** At the holding cap in every class — eight held beside three
   worn: 693–753 px of text against a 583 px scroller with every core slot filled, **704–815 px with every slot empty** — and, because
   an empty core slot is a row, **for a hero holding his class's six with a slot empty in 12 of 24 such panels** (to 693 px). Close is
   pinned below the scroller in every one, GT §1's ruled shape for this panel, and the panel already spans the screen. **Scrolling here
   is not new**: HEAD's panel at its own cap scrolled for three classes of four (574–634 px against 558). HU §1 rules that a list of
   buttons outgrowing the screen pages and never scrolls, and this panel is a list of buttons. **Page it, or keep GT §1's scroll for
   this panel.** A pager over three sections is not one batch's afterthought: where a page breaks inside a section is the design
   question.
2. **THE SAVE VERSION DID NOT MOVE (§2).** No save carries a slot count — a save holds each core rune's `equipped` flag — so the raise
   is no structure a build must walk: a two-slotted save opens here with the third slot empty, and a three-slotted save opens in HZ's
   build with all three slotted, over that build's cap, nothing lost. **Confirm, or bump it** so an older build refuses a newer save
   (HL §5) instead of opening it over its cap.
3. **THE EMPTY SLOT'S WORDS (§2).** An empty core slot reads *— empty core slot —*, the map card's *— empty —* register; where the
   hero holds no core rune at all HN §2.6's line follows the slots, word for word. Confirm, or word it.
4. **THE EVENT VERB'S CORE RUNE IS HELD, NOT SLOTTED (§2).** Its grant prefers an ordinary rune and, once his ordinary pool is spent,
   falls back on the whole roll, core runes included — and then asked to slot it, which a free core slot granted, with the card it
   brings. It is held unworn now, as at the cache. Confirm.
5. **THE FAMILY §0.6 NAMES (§1).** Every other reader of a figure computed above the vow's gate is reported, not repaired — the census
   is §1's last table. Its own batch.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HZ; premise 1 is HZ's push hash | **Held**: `git ls-remote origin class-merge` = `91a824e53265948dfadc05f1b52ae28ac93d6079` = local HEAD, read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | HZ's table qualified five, *two the good kind*: the telegraph exists and names its ability | **Held** (HZ premise 13 and §1a) |
| 3 | *Empty Pulpit and Dead Air never pay* was wrong; *they are comeback runes* | **Held** (HZ ruling 2; `check_hz` §1d drives the switch at a death) |
| 4 | §0.1: a full bar deals **63**, 0.63 of Attack a point; the census's median Rage card **1.09**; only **Shatterpoint (0.47)** and **Overpower (0.40)** convert worse, *both buy something besides damage*; the bar costs *about five turns* | **Held**: HZ §2's table, nineteen cards, median the tenth at 1.09; Shatterpoint is the heaviest Break blow and casts a free Overpower on a Break, Overpower holds a Broken target an extra turn; about 20 Rage a turn against a bar of 100 |
| 5 | §0.2: HP §1's live re-read makes them work; three of four live crest runes are insurance, Tithe unconditional; `heroes_hold_core` live since HQ; *at 20% back every fight* | **Held**: only the three carry a `condition` (HZ premise 23); `heroes_hold_core` joined `LIVE_KEYS` at HQ §1; a won fight writes at least a fifth back (FOUND AT HO) |
| 6 | §0.3: the band is the same `_damage_line` a hero's card quotes; the intent block computes nothing | **Held** (HZ §1a; `test_batch_bl`'s control) |
| 7 | §0.4: one point, on blows of 4k + 2 at power 50; *0.35 − 0.25 = 0.09999999999999998* | **Held**: 18 = 4·4 + 2 (HZ ruling 4); the float is the one HP §1d recorded |
| 8 | §0.5: `test_batch_cp`'s named set goes to nine | **Held** (HZ: 8 → 9) |
| 9 | §0.6: the heal and the log line read the pre-gate figure — *the same bug at the same site* | **Held**, read at the site: the log line printed `reflect` above `take_tick_damage` and Lifewell healed off it, and the vow's gate refuses inside the door. **Not said, and found: Lifewell has no live writer** — its node went at FX and `rune_lifewell_ranks`' one writer, the Burning Censer, is retired — so the fix reaches a saved run wearing the Censer and nothing else today |
| 10 | §0.7: Tithe's chip reads PAYING whenever worn | **Held** (HZ §1d) |
| 11 | §2: *HH retired `check_eh` §3 onto the ladder's `core_slots` — so the cap may already scale with something* | **Not held**: `Classes.core_slots` is a lineage's protected-core ABILITY slots on the ability ladder (`ABILITY_SLOTS_BY_BOSS`); the core-RUNE cap is `Run.ENGINE_SLOTS`, a flat 2 since GK that scaled with nothing. **Three is a new number, not a rung** |
| 12 | §2: HL §5 — a newer save is refused by an older build and `save` is a NO-OP while refused | **Held** (`Run.save_run`'s guard, `load_run`'s ceiling) |
| 13 | §2: HN §2.6's line, *No core rune held. Core runes are found in play, alongside the others.* | **Held** (the panel; `check_hn` §2b pins it) |
| 14 | §2: HL §1a was a core rune slotting itself on arrival | **Held** — and one door still could: the event verb (§2e) |
| 15 | §3: the bag is crest-only; a class's runes live on the hero | **Held** (HR §1) |
| 16 | §3: *HR built [the panel], HZ's kit preview reads it* | **Half**: HR gave the panel its held rows (GK built it, HK its rows); **the preview reads the hero SHEET**, not the panel — the sheet's doors and its state column. The panel had **one heading** (*CORE RUNES — n of 2 slots filled*) and **one unheaded list** of worn and held ordinary runes mixed, a ✦ before a worn row and *(held)* after a held one; **its state was per-row marks, not a column** — the state COLUMN is the sheet's |
| 17 | §3: HU §1's pager is the precedent; the panel is a list of buttons | **Held**; the panel already scrolled at HEAD's holding cap for three classes (§3d) |
| 18 | §4: the hero sheet's state column reads CREST, ENGINE, WORN, and the kit preview reads it too — *verify* | **Held**: `party_screen.gd:528` and `kit_preview.gd:201` both printed ENGINE |
| 19 | §4: HL §2 kept `ENGINE_READ`, `has_engine` and the rest | **Held**; `Run._refresh_rune_names` untouched (§4) |
| 20 | §5: *FIVE sites … It is nine, at HEAD and at HZ*; `check_dm` §1 prints the live figure; one of HX's 87 | **Held**: nine (`check_ia` §5 prints it); `check_dm` §1 prints its live count; HX's appendix row 234–237 |
| 21 | §6: HZ's fifteen folders, 6,312 KiB | **Held**: fifteen, 6,312 KiB, by prefix; **the move was refused** (§6) |
| 22 | §7: *HY repaired one, HZ repaired two and reported two* | **Half**: true as counts of re-read repairs, but **none of the three was one of HX's 87** — each repaired what its own change falsified (HY the reference's list of `docs/state.md`'s readers, HZ the intent and frame blocks); the two HZ reported are among them. **The 87 stood at 87 until IA §5** |
| 23 | §7: `RUPTURE_BREAK_PER_TICK` stays at 10, *unfelt after six batches* | **Held**: 10; HU to HZ are six batches after HT confirmed it (seven since HS built it) |
| 24 | §7: the re-measure does not run, *four batches since HV* | **Held**: HW, HX, HY, HZ |
| 25 | §8: HZ's backup `../save-backups/HZ-20261009-163227`; the four player files byte-identical to HY's | **Held** — **and still**: byte-identical to HZ's backup at IA, md5, size and modification time — **nothing played for three batches** |
| 26 | §8: HZ's recon 2 found eleven moved gates, one a real defect; five of six road walkers press the first button that is not *Not yet* | **Held** (HZ §6b) |
| 27 | §8: `check_hz` set `last_rites` by hand | **Held** (HZ §6b, D43/D43h) |
| 28 | §8: HZ read 140 in 77 min 28 s | **Held** (HZ §6f) |
| 29 | §8: `CLAUDE.md` 435.49 KiB, 74.51 under 510; `docs/state.md` 331.30 KiB, 48.70 under 380 | **Held**: 445,944 B and 339,252 B at HEAD |

## §0 — HZ's SEVEN RULINGS, ANSWERED

**One changed code (6, §1 below). Six are confirmations, and each reason is written where a later batch will meet it** — HW's rule:
a ruling lands whether it moves a line or not.

- **§0.1 — Boil Over's rate: 0.8% and the 40% floor stand.** Recorded in `docs/state.md` under BOIL OVER'S RATE, the tension with it:
  a full bar converts 0.63 of Attack a point of Rage against the census's median 1.09, and only Shatterpoint and Overpower convert
  worse while each buys something besides damage; the pass condition compares one dump with two Rampages and ignores the five turns
  the bar took to fill, so both cannot hold. **The missing figure is enemy health**, recorded as what the rate is read against when
  it is next ruled; **the lever — a rate that rises with the fraction poured — is recorded and not built.** `CLAUDE.md`'s dump bullet
  carries the principle: nothing is authored onto a card nobody has cast.
- **§0.2 — Empty Pulpit and Dead Air are comeback runes, confirmed, not re-cut.** `CLAUDE.md`'s crest block records the live re-read as
  load-bearing for the pool (*a batch that narrows it deletes three runes in silence*); `docs/state.md`'s new THE CREST POOL records
  the finding (three of four live crest runes are disaster insurance; Tithe the unconditional fourth), the direction out
  (`heroes_hold_core`, a condition that is not a death, live since HQ) and **what now prices them**: whether a fallen hero stays
  down between fights — owed before any of the three is re-cut, and so noted on that item (FOUND AT HO). Nothing authored.
- **§0.3 — The telegraph keeps its band.** The combat rules' intent block records why (the one line every card in the hand already
  speaks), the rejected alternative (the percentage alone) and **the boundary**: the telegraph quotes the attack's own line and never
  reads a target's body; the day it reads armour it is a prediction and BL's finding bites.
- **§0.4 — The mirror keeps its point.** The combat rules' frame block, beside the vow share's rounding, now carries the magnitude (one
  point, on blows of 4k + 2 at power 50, in the player's favour) and why the subtraction was rejected — so nobody re-finds it as a
  defect.
- **§0.5 — Boil Over stays Perfectless.** `test_batch_cp`'s nine is the correct reading. The principle is §0.1's and is in the same
  `CLAUDE.md` bullet.
- **§0.6 — Lifewell and the log line: FIXED** (§1). The rule — *a figure printed or paid off a blow is the blow that landed, never the
  blow that was computed* — is recorded beside the frame's in `docs/combat-rules.md`, with the reflect as its worked example.
- **§0.7 — Tithe's chip stays, and the two surfaces are named** in `CLAUDE.md`'s HZ §1 block: the crest strip shows the crest the party
  wears; the chip's ARMED or PAYING says whether it pays; a hero's plate takes a chip only for a payout that turns on and off.

## §1 — THE TWO LINES §0.6 OWES

**`battle._vow_silences`** is the vow's gate's own predicate, factored out of `_deal_gate` with its answer unchanged (`_deal_gate`
asks it at the two doors and floats SILENT). **At the reflect it is asked under the ground's frame** — the frame the door's gate reads
— so `cg_landed` is the reflect if it lands and 0 if the layer's vow silences it: **the log line prints only a reflect that landed, with
its figure, and Lifewell pays only on one**. With the vow off both are byte for byte what they were. The two needles two suites pin at
this site are kept (`test_batch_bc`'s `_devout_heal(cg_dv, well_got, "lifewell", wh)`, `test_batch_aw`'s ranks term).

**Driven on the real battle** (`check_ia` §1), Lifewell seated through the spawn — the retired Burning Censer worn by the Devout, as a
saved run can wear it, its payload (`rune_lifewell_ranks` 20, `rune_righteous_step` 10) asserted on him as the premise, Conviction
asserted held: **with his Vow of Silence**, an Orc Raider's Slash on the Warden standing in his ground — **the raider lost 0, the log
holds no reflect line and no Lifewell line, and none of the three wounded heroes was healed; with the vow off**, the raider lost 4, the
log reads *Consecrated Ground reflects 4 to Orc Raider (Righteous Fire)* and *Lifewell — the reflected pain mends the heroes for 1*,
and all three wounded heroes were healed. The frame is the raider's own after the reflect, both arms.

**`check_hy` and `check_hz` did not move** (recon 1, §8b): neither reads the reflect's log line or seats Lifewell; `check_hy` §5 reads
the raider's health, which did not change.

**LIFEWELL HAS NO LIVE WRITER, AND THE BRIEF DID NOT SAY SO.** Its talent node went with the twelve trees at FX, and the only writer of
`rune_lifewell_ranks` is the Burning Censer, retired at ET §1 and kept on the Melted Armor contract — so no fight a new run reaches pays
it. The fix is real for a saved run that still wears the Censer, and for whatever writes the field next.

### §1b — THE SWEEP FOR THE SHAPE: REPORTED, NOT REPAIRED

**Only one gate refuses damage — the vow's — and it refuses only what the frame credits to a vowed hero; the vow is a Cleric rune.** So a
member of the family is a reader that prints or pays a figure computed above `take_hit` / `take_tick_damage` for a blow a Cleric can be
credited with:

| reader | where | what it does with a refused blow |
|---|---|---|
| the strike's damage float | `_resolve`, after the door | floats the computed `final` beside SILENT |
| the strike's log line | `_resolve`, after the door | prints *N dmg* for a blow that dealt 0 |
| `total_dealt` | summed above the door (`total_dealt += final`) | pays the card's lifesteal, the rune's lifesteal, siphon and recoil off a refused blow |
| the Ruin leech | above the door | heals off `final` for any hero striking a Ruined enemy |
| every `take_tick_damage` label | built by the caller, above the gate | a silenced reflect still floats *-N Reflect* (a silenced tick its number) |

**And beyond the strike loop, 43 door calls print or pay the figure they hand the door within fourteen lines of it** (a mechanical sweep
over `battle.gd`: `bomb_dmg`, `echo`, `rift_dmg`, the specials' `*_final` figures, the bleed's) — most are other classes' cards no vow
reaches today. **Each repair is a different arm owing its own control, so the family is its own batch** (FZ's pricing rule); it is
recorded under FOUND AT IA.

## §2 — THE THIRD CORE SLOT

**The five answers, each with what was driven.**

- **WHERE THE CAP LIVES, AND EVERY READER.** `Run.ENGINE_SLOTS`, `run_state.gd` — **a flat constant, 2 since GK, scaled with nothing; three
  is a new number, not a rung.** The brief's premise read `check_eh` §3's *ladder's `core_slots`* as the cap; it is `Classes.core_slots`,
  a lineage's protected-core ability slots on the ability ladder (premise 11). **Readers**: `Run.hold_rune` (a core rune worn while one
  is free), `Run.engine_toggle_refusal` (the refusal), the panel's CORE head and its Swap branch, the hero sheet's header (*n/3 core*),
  and three gates through `Gate.engine_sets` (`check_ea` §1 twice, `check_eh` §2) — every one asks it by name. **IA adds three
  readers, all by name**: the panel draws its empty slots off it, and `check_gt` §1 and `check_hu` §1a walk the sets it allows
  where they walked pairs (§8b).
- **WHAT WAS PINNED AT TWO, AND WHAT MOVED.** Code: the constant (moved), the refusal *Both core slots are filled.* (moved: *Every core slot
  is filled.* — HO §0: a sentence says the rule, never the figure) and its tooltip; **a layout built for two: the map card's core line**,
  one non-wrapping line in a 284 px box that the widest PAIR already overran (372 px at font 11; the widest three reach 442) — it wraps
  now, bottom-up, in the room the badges take only when a pick is owed (measured, and rendered to PNG: two lines inside every card). **A
  save's shape: nothing** — no save holds a slot count. **Documents**: `CLAUDE.md`'s charter (*two dedicated slots*, recorded over GK's
  two as GS and HB recorded theirs), its GT §1, HU §1 and drop blocks, the engine-and-axis rule and the tag reference (*two a hero at
  most*, both found by the re-read, §8c), `docs/master.html` (five places), the glossary's Runes entry
  (*into two core slots*) — all moved. **Gates**: `check_gt` §1 walked pairs and sixes with two slotted (re-pointed at the cap: every
  set of up to three, and — after recon 2 showed an empty slot is a row — the six and the holding cap at every slot count, §8b); `check_hu` §1a walked pairs (re-pointed at the cap through `Gate.engine_sets`;
  the widest bar is unchanged at 13 entries, because no class has a third lineage engine that brings a card). Comments in `runes.gd`,
  `unit.gd`, `battle.gd`, `party_screen.gd` and `map_screen.gd` that said *two* say it no longer.
- **THE SAVE, BOTH WAYS.** **A save holding two slotted opens in this build with three slots and the third empty** — written through
  `Run.save_run`, read back through `Run.load_run`, the panel reading *CORE — 2 of 3 slots* with one empty slot and an Equip that fills
  it (`check_ia` §2b), and no key naming a slot count anywhere in the saved dictionary. **And a save this build writes with three slotted
  opens in HZ's build** (driven in a copy of HEAD): not refused — it is v15 — the Warrior holding all three slotted, his panel reading
  *CORE RUNES — 3 of 2 slots filled*, a fourth refused with *Both core slots are filled.*, and the fight's spawn seating all three
  engines with both their cards. **No save version moved**: the slot count is no save's field, a bump would make HZ's build refuse and
  keep the save rather than open it, and HL §5 makes that a decision — ruling 2.
- **THE EMPTY SLOT'S WORDS.** Every empty core slot is drawn as a row reading *— empty core slot —* (the map card's *— empty —* register:
  the slot is the thing shown), and where the hero holds no core rune at all HN §2.6's line follows the slots, word for word — `check_hn`
  §2b still pins it, re-tuned only for its section head. Ruling 3.
- **WHEN A CORE IS UNSLOTTED, AND WHEN IT APPLIES.** **At the spawn, never at slot time**: `Run.toggle_engine` flips the rune's `equipped`
  flag and nothing else, and the battle reads the slotted set once, as it is built (GM §2). **Driven mid-run** (`check_ia` §2c): the
  Warrior awakened on the Berserker's rune, the Stances' held — Equip pressed on his real panel, the member differing from before in that
  one flag; **the run's own next fight** seats both engines and both cards (Bloodlust, Guard Change); Unequip pressed on the Berserker's,
  and the fight after seats the Stances and Guard Change and neither the Berserker's engine nor Bloodlust.
- **HL §1a, THREE TIMES THE SURFACE — ONE DOOR WAS STILL OPEN.** Every door that puts a core rune down was read: class selection slots
  the one taken (by design); a cache's and a bargain's pick never ask (HL §1); the drop and the Peddler's Buy ask nothing (and the
  Peddler sells none); the sim asks (its policy, not the player's). **The event verb asked whenever an ordinary slot was free** — and its
  grant, which prefers an ordinary rune, falls back on the whole roll once his ordinary pool is spent, core runes included: the core rune
  slotted itself and its card joined the kit. **It is held unworn now and the event's line says so** (`check_ia` §2d: the pool parked down
  to one core rune; the line reads *Rune of the Warden (core) (Berserker) — held, not worn*, his slotted count unmoved; the positive arm,
  an ordinary rune handed over with a slot free, is still worn). Ruling 4.

**THE THING TO WATCH, RECORDED** in `docs/state.md`'s TO WATCH IN PLAY in the shape HN §2.3 used: three cores may dilute the directional,
and the lever — an earned third slot — named and not built.

## §3 — THE BAG: THREE SECTIONS, PER CLASS

**What the panel was** (premise 16): one heading, *CORE RUNES — n of 2 slots filled*; HN's line when he held no core rune; his core runes'
rows, worn and held interleaved in list order; then one unheaded list of his ordinary runes, worn and held mixed — a ✦ before a worn row,
*(held)* after a held one — and above the list HR's line, *HELD, NOT WORN: n of 8 …*. **Its state was per-row marks; the state COLUMN is
the hero sheet's.**

**What it is** (`map_screen._open_rune_panel`, two row builders `_pouch_engine_row` and `_pouch_rune_row`, one head and one note
builder): **CORE — n of 3 slots** (every slot drawn; an empty one *— empty core slot —*; HN's line when none is held) · separator ·
**WORN — n of 3 slots** (*No rune worn.* when empty) · separator · **HELD, NOT WORN — n of 8**, a line saying what the section is, then
every held rune, core runes first (*Nothing held. A rune drops after every fight, and the Peddler sells them.* when empty). The buttons
are the ones the rows always carried, bound to the same doors with the same indices. **GT §1's shape holds**: one scroller, Close below
it, nothing shrunk.

- **THE SECTIONS REPLACE THE STATE**: no row carries ✦ or *(held)*; **HR's count line is superseded by the section head that now counts**
  (two counts of one thing in one panel is §0.7's rot). **HR's nameplate ✦ N survives**: it is the map's one glance at a holding, outside
  the panel, and the button into it — a different surface with a different job.
- **The crest's bag is untouched** (driven: it lists the crest's runes under *THE CREST*, and no hero section). **The kit preview stays
  flat** with its state column (driven: its runes are one list, CORE / WORN / held beside each name, no section head).
- **Driven on the real screen, with the negative arms** (`check_ia` §3): **a hero holding nothing** — the sequence read off the panel in
  order is exactly *CORE — 0 of 3 slots*, three empty slots, HN's line, a separator, *WORN — 0 of 3 slots*, *No rune worn.*, a separator,
  *HELD, NOT WORN — 0 of 8*, its line and *Nothing held …*, every label visible at 12 points or more on the screen, Close outside the
  scroller; **every kind in its section** (two slotted, two held core runes, two worn, two held) — CORE, WORN and HELD hold exactly the
  runes they should, in the designer's order, two separators, one empty slot, no row marked; **a rune moved between sections and the
  panel re-read each time** — Equip moves a held rune into WORN (3 of 3), Unequip moves a slotted core into HELD (two empty slots), and a
  Swap through the chooser puts the held rune in WORN and the worn one in HELD; **more than fit** — the holding cap (§3d).
- **§3d — MORE THAN FIT: IT SCROLLS, AND THE PAGER IS RULING 1.** The holding cap — every core slot filled, three worn and eight
  held, fourteen runes — reads 693–753 px in a 583 px scroller in every class, and **with every core slot empty 704–815 px, the panel's
  true longest**, because an empty slot is a row; a hero holding his class's six with a slot empty scrolls too, in 12 of 24 such panels
  (recon 2 found it, §8b). Close is pinned in every one, and every row scrolls wholly into view. HEAD's panel at its own cap (two
  slotted) already scrolled for three classes of four (574–634 px in 558). `check_gt`'s holding-cap arm runs at every slot count every
  battery, and its six arm records which sixes scroll.

## §4 — THE WORD *ENGINE*, WHERE THE PLAYER CAN SEE IT

**Verified, then fixed** (premise 18). **Two surfaces changed**: the hero sheet's state column (`party_screen.gd`) and the kit preview's
(`kit_preview.gd`, which copies it) read **CORE** for a slotted core rune; CREST, WORN, held and *sits out* unmoved. No other player-facing
string says *engine* but the three card texts HN ruled stay as authored (a sweep of every string literal in `scripts/`: the rest are
`ENGINE_READ` rows' `why`, which no screen shows). **`Run._refresh_rune_names` untouched** — a column's label, not a rune's name.
Driven (`check_ia` §4): the sheet reads CORE once for the Warrior's one slotted core rune and ENGINE nowhere; the preview's row reads
*CORE* beside the rune's name.

## §5 — ONE STALE CLAIM, REPAIRED BY HY's OWN SECOND RULE

`docs/instrument-rules.md`'s DM §2 block: *FIVE sites in `battle.gd` spell … byte for byte … reads the wrong site four times in five* —
**now *more than one site … `check_dm` §1 prints the live count***, the number and the fraction derived from it dropped. `check_ia` §5
asserts the pointer and no count, and its positive arm that the walk is still shared (nine sites). **Repaired: this one.**

**HX's 87 stand at 86** (premise 22): none was repaired at HY or HZ — their re-reads repaired only what their own changes falsified, and
none of those is an appendix row — and IA §5 retires the first. **At one a batch the 86 last eighty-six more; the brief's *forty* rested
on a rate HY and HZ never had (premise 22). The claims batch is owed its own letter.**

## §6 — HOUSEKEEPING

**HZ's fifteen folders were not cleared.** Selected by their prefix — *Dawn of Decay HZ ctlA, ctlB, ctlE, ctlF, ctlG, ctlH, ctlI, final,
prepass, probe, recon, recon2, sub1, trhead, trnew* — fifteen, **6,312 KiB**; the move into a named Trash folder, HO §5's step, **was
refused by the session's safety classifier**, so it was not pursued another way (HO §5). `app_userdata` read **477 folders and 148,956 KiB**,
the same after (nothing moved). The live *Dawn of Decay* folder, the older copies and `../save-backups/` were not touched; IA's own backup
is `../save-backups/IA-20261011-174253`. **To clear them by hand**:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (Batch HZ's 15)" && mv "$HOME/Library/Application Support/Godot/app_userdata/Dawn of Decay HZ "* "$HOME/.Trash/DoD spent user-data folders (Batch HZ's 15)/"
```

**IA's own copies** are named *Dawn of Decay IA …* (§8 counts them) and stay for IB.

## §7 — WHAT IS DELIBERATELY NOT DONE

- **The draft flow is IB's**; the Cleric's regen and the Mage's fire are IC's.
- **The 87 — now 86 — are not repaired** beyond §5's one; at one a batch they last eighty-six more, and the claims batch is owed its own
  letter.
- **No crest rune is re-cut or authored; the crest cap stays at one. Boil Over's rate is not re-ruled, its Perfect not authored, the
  rising-rate lever not built. The third slot is not gated behind a rung.**
- **No conjunction is authored**: `RUPTURE_BREAK_PER_TICK` stays at 10, still unfelt after six batches; the pager and the chips are in,
  and the cast is the designer's.
- **The re-measure does not run** — four batches since HV. Its two readings against the two ceilings are §8g's two lines, and nothing more.
- **The family §0.6 names** (§1b) and **the panel's pager** (ruling 1) are reported, not built.
- Standing and unchanged: a copied Frostbind's refusal is RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire
  becomes Sunder + Burn and Contagion and Reckoning owe re-cuts; the Occultist's Break card is CE §3's ask; the Skirmisher and the Tracker
  are ruled into ordinary runes and unbuilt; Channel's tempo payout is owed; whether a fallen hero stays down between fights is owed and
  now prices three crest runes; Tithe's read site and its talent rebalance; a bomb's surface text; the block index.

## §8 — THE VERIFICATION

### §8a — THE PUSH CHECK AND THE SAVES, BEFORE ANYTHING

**Premise 1**: `git ls-remote origin class-merge` read `91a824e53265948dfadc05f1b52ae28ac93d6079`, local HEAD, at 17:42, before
anything ran; the tree clean but the untracked `save-backups/`. **The saves were backed up first** to
`../save-backups/IA-20261011-174253` and verified by hash: all four player files byte-identical to the copies — md5, size and
modification time — **and to HZ's backup**, which was byte-identical to HY's: `run_save.bin` and `profile.json` last written on
2026-10-08, **so nothing has been played for three batches**, the four surfaces HZ shipped for play included. Read again at the
close, unchanged (§8f). No Godot was running: the rows of `ps`, read by executable.

### §8b — HEAD's GATES, UNMODIFIED, AGAINST THE NEW CODE: TWO RECONS

**§1 changes the damage path, so the recon is the whole battery, and §0.8 put §1 first, so it ran first, alone.**

**Recon 1 — §1 alone.** HEAD's 139 targets and the differ, unmodified, against an isolated copy holding HEAD's tree and IA §1's
`battle.gd` (*"Dawn of Decay IA recon"*, seeded from the backup), predicted before the launch: every target at HZ's acceptance
reading — `check_hy` and `check_hz` unmoved, because neither reads the reflect's log line and nothing they seat writes Lifewell.
**17:55:24 to 19:12:54 — 77 min 30 s, with the first two control rounds running beside it — read `check_de` 577 / 0 / 0, exactly as
predicted**: `check_hy` 173 / 0 and `check_hz` 107 / 0; `test_batch_bc` and `test_batch_aw`, whose two needles sit at the reflect's
Lifewell line, 89 / 0 and 212 / 0; `check_cm_live` 13 / 4 and `check_gj` 70 / 1 with their sanctioned lines word for word (the
defensive bar no gate can press; *the card says +157 gold and the purse moved 177*); `test_batch_an` 6054 and `test_batch_bk` 131,
inside their bands; the run harness PASS 22 / 382 / 8; 140 names in `.ran` — the 139 targets and the differ — each once, in one
ascending sequence; no Parse Error, SCRIPT ERROR, TIMED OUT, NO VERDICT or CUT OFF line. **So §1 moved nothing in HEAD's battery —
which answers the brief's *report whether `check_hy` or `check_hz` moves*: neither did, and neither was re-tuned for it.**

**Recon 2 — all of IA's game code.** HEAD's 139 targets and the differ, unmodified, against an isolated copy holding IA's nine game
files (`battle.gd`, `events.gd`, `kit_preview.gd`, `map_screen.gd`, `party_screen.gd`, `run_state.gd`, `runes.gd`, `unit.gd` and the
glossary) and HEAD's copy of every gate, suite, document, baselines row and the runner (*"Dawn of Decay IA recon2"*, proved to be HEAD
but for those nine and its name), the prediction written first — including, before the launch, **the six road walkers and
`check_fm`**, which the brief asked to be checked first: IA adds no button to a pick overlay, and every road finds the panel's buttons by
the method they are bound to and the row index, never by their words. **19:13:22 to 20:31:00 — 77 min 38 s, beside the pre-pass for its
last hour — read `check_de` 577 / 7 / 2.** 140 names in `.ran`, each once, in one ascending sequence; no Parse Error, SCRIPT ERROR,
TIMED OUT, NO VERDICT or CUT OFF line; the run harness PASS 22 / 382 / 8; `test_batch_an` 6053 and `test_batch_bk` 131, inside their
bands; `check_cm_live` 13 / 4 and `check_gj` 70 / 1 with their sanctioned lines. **The roads did not move** — `check_fe` 79, `check_fh`
167, `check_fm` 82, `check_gj` 70, `check_gp` 443, `check_gv` 1057, `check_hk` 168 — nor did `check_hc`, `check_gs` or `check_hl`, which
open the panel and find its rows by binding or by words IA kept. **Every moved target, with its cause read off its FAIL lines and the
code they name:**

| target | HEAD's gate on IA's code | cause | predicted |
|---|---|---|---|
| `check_ea` | 236 → 396, a notice | §1 walks every set of up to `Run.ENGINE_SLOTS` engines a hero of each class can hold, and the cap is three: eighty more seats, two floors each | yes (a rise; the size traced before the launch) |
| `check_eh` | 230 → 310, a notice | §2 asks the class tier's depth of the same sets | yes |
| `check_gt` §1 | 3477 / 125 | **120**: a held row's expected text ends *(held)*, which the sections replaced — 24 engines alone and 60 pairs with one ordinary rune, and the four sixes' held engines and their ordinary rune; **4**: the holding-cap arm's eight held rows, the same cause; **1: *the text scrolls for 1 configurations — the cleric's six, one ordinary rune*** — HEAD's six with two slotted, one slot empty | the 120, yes; the 4, in kind (an arm the count missed); **the scroll, no — a finding (below)** |
| `check_gx` §3, §4b | 1367 → 1237 / 89 | each panel row looked up by its exact text **with the ✦**, which the sections replaced, so no lookup finds its row: 42 gated runes red with the engine in and 42 with it out, the three summaries, and §4b's two tells and their summary; **the count falls by exactly the 130 arms that hang on a found row** — three under each of the 42 sits-out rows and two under each of §4b's two tells | the reds, yes; **the fall, no** — the same cause, read off the code |
| `check_hf` §4b | 314 / 3 | the vow's and the ground's rows matched by exact text with the ✦ | yes |
| `check_hn` §2b | 74 / 1 | *CORE RUNES — 1 of* is the CORE section's head now, *CORE — 1 of 3 slots* | yes |
| `check_hr` §1f | 100 / 1 | *HELD, NOT WORN: 2 of 8* beside rows ending *(held)* — the section's head says it, and no row does | yes |
| `check_hz` §1b | 107 / 1 | the kit preview's state column reads CORE where the gate expects ENGINE | yes |

**So HEAD's battery read IA's code as working, and every red is a gate meeting what IA changed.** The repairs to every one but the
finding were drafted from recon 2's prediction before it ran, then held against its FAIL lines: `check_gt`, `check_gx`, `check_hf`,
`check_hn`, `check_hr` and `check_hz` re-tuned to the sections (no ✦, no *(held)*, the new heads, CORE), `check_gt` and `check_hu`
re-pointed at the cap through `Gate.engine_sets`, and the counts moved with their traces (`check_gt` +2,640 for the eighty triples,
`check_ea` +160, `check_eh` +80, `check_hr` +2 for a split compound arm, `check_parse` +1 for `check_ia`).

**THE FINDING: THE FIRST RE-POINT WALKED THE SHORTEST CASE.** HEAD's one scroll line was not a re-tune's to absorb: HEAD's six with
two slotted is, on IA's panel, **a six with a core slot empty, and an empty slot is a row** — so it is taller than the six with every
slot filled, which is the only six the first re-point opened. Measured in a scratch copy, the six at every slot count: with every slot
filled it fits for every class (446–551 px in 583); **with a slot empty it scrolls in 12 of 24** (the Mage, the Cleric and the Hunter at
none or one slotted, and the Cleric at two with one ordinary rune; to 693 px). **And the holding-cap arm had the same blind spot**:
every slot filled is 693–753 px, **every slot empty 704–815 px** — the panel's true longest. Close stayed pinned and every row stayed
reachable in all of them, and the panel already spans the screen (`POUCH_RECT`, y 24 to 696 of 720), so this is GT §1's sanctioned
scroll and not a layout defect — **but the gate no longer opened what it claims to: `CLAUDE.md` says `check_gt` §1 opens the pouch in
every combination.** **Repaired, in the gate**: §1 opens each class's six at every slot count from none to the cap, and runs the
holding-cap arm once a slot count; every configuration with its slots filled must still fit, as at HEAD, and a six with a slot empty is
recorded where it scrolls, Close asserted pinned in each. `check_gt` 6117 → **6813**, attributed by trace: +612 for the six at three
more slot counts, +84 for the holding cap at three more, one count message re-worded. The comment above `POUCH_RECT`, which said a
class's six *fits with nothing scrolling*, says what is true now (a stripped diff proves the edit comment-only), and ruling 1 is widened
to say where the panel scrolls. Controlled two-armed (round three, §8d).

### §8c — THE RE-READ (HY §6)

**The population is the names the diff touches** — every function, constant, field, file and gate IA's game and gate diff edits,
**210 names**, matched against every backticked name in both references, 123 pairs, each sentence read against the new tree: **none
stood false by IA's change.** **The same re-read over the required read, `CLAUDE.md`, found two that did, both repaired**: the
engine-and-axis rule's *Exclusive to its class, held as a rune, two a hero at most* and the tag reference's copy of it, *two a hero
at most* — three since §2, each now says so with the batch. **And a third that IA's first re-point had made false and its repair made
true again**: GT §1's *`check_gt` §1 opens the pouch in every combination* (§8b's finding). The combat rules' frame block and its new bullet name `_deal_gate` and `battle._vow_silences` as they stand; the
instrument rules' claims naming `gate_fixture.gd`, `glossary.json` (its single-space indent and missing trailing newline, both
kept: a one-line diff that round-trips), `check_hr`'s event verb, `check_hf`'s Peddler columns and `check_hu` §3b are history or
still true. **The one live count IA touched is §5's, now a pointer.** **And one claim among HX's 87 is staler by IA's hand, reported and not
repaired** (§5: this one and no others): the combat rules' header, *every block below is byte-identical to what stood in
`CLAUDE.md`*, which HY and HZ reported — IA wrote into two of its blocks again, the intent block (§0.3) and the frame block (§0.4,
§0.6). **And the short strings were swept at their own length**: the
worn mark `✦` (one character) is gone from the hero's rune panel alone — the hero sheet, the Kit panel, the crest's bag and the
nameplate keep it, and every gate needle that read it on the panel (`check_hf` §4b, `check_gx` §3 and §4b) was re-tuned; no gate
looks for the column word ENGINE on a screen but `check_ia`'s own negative arms.

### §8d — THE CONTROLS: EVERY ONE BREAKS ITS NEEDLE

**One defect per APFS clone of the finished tree, each patch count-asserted so a patch that does not land is reported rather than run
as a baseline, every FAIL line read — and the round that counts is the second, on the final tree.** Round one (33 controls,
18:32 to 18:56, on the tree as it stood at 18:17) read every defect red at its line but one; it ran `check_ia` at 78, before its
compound arms were split, so every control was run again. **The one it could not read was C51, and the fault was the control's**:
its patch wrote six card names into the Warden lineage's enablers, and a lineage's enablers resolve only through its own definition
table (`Classes.lineage_opening`), so the names landed, parsed and added nothing to any bar — both arms green, for the wrong reason.
Round two corrects it: the kit grows six entries only when a third core rune is slotted, constructed in `Classes.opening_kit`
itself. **Round two — thirty-five controls on a copy taken at 18:58, whose every script, gate, fixture and data file is the final tree's
but `check_gt.gd` and one comment in `map_screen.gd`, both changed after recon 2 (round three re-runs every control that ran
`check_gt`)** (lane *"Dawn of Decay IA ctlB"*, seeded from the
backup), predicted before any of its output was read: 18:59:06 to 19:28:27, **every defect red at the line it aims at, the baseline (C00) green at every count, nothing that failed
to land and no throw — exactly as predicted.** **C51h is the one arm that stays green, and that is its point**: HEAD's `check_hu`
walks pairs, so a bar that overflows only with three core runes slotted passes it, where IA's walk reads the nineteen-entry menu.
**C52h reds, and it says something narrower than C52**: HEAD's `check_gt` slots the cap only in its four six-held configurations,
so it catches a defect that lives at three through those eight arms, where IA's walk meets it in all 168 three-slotted arms —
the eighty triples and the four sixes, each opened twice.

The H rows are HEAD arms — a re-tuned gate read against HEAD's copy of what it re-tuned, or HEAD's copy of a gate read against IA's
code — and C51h and C52h are the two-armed halves of the cap's re-points. Where a defect breaks more than one arm the count says so;
the line shown is the first.

| id | the defect planted | read (the first FAIL line per gate) |
|---|---|---|
| C00 | baseline: the landed tree, no patch | `check_ia` 82 / 0, green<br>`check_gt` 6117 / 0, green<br>`check_gx` 1367 / 0, green<br>`check_hf` 314 / 0, green<br>`check_hn` 74 / 0, green<br>`check_hr` 102 / 0, green<br>`check_hz` 107 / 0, green<br>`check_hu` 104 / 0, green |
| C01 | the reflect's log line reads the computed figure again, landed or not | `check_ia` 82 / 1 — *§1 (vowed): the log prints a reflect that never landed: '→ Consecrated Ground reflects 4 to Orc Raider (Righteous Fire)'* |
| C02 | Lifewell pays on the computed reflect again | `check_ia` 82 / 1 — *§1 (vowed): Lifewell watered 3 heroes off a reflect the vow silenced ('→ Talent: Lifewell — the reflected pain mends the heroes for 1')* |
| C03 | the reflect's line prints a figure that is not the one that landed | `check_ia` 82 / 1 — *§1 (no vow): the log's reflect is not the 4 that landed: '→ Consecrated Ground reflects 5 to Orc Raider (Righteous Fire)'* |
| C04 | the gate's predicate never silences (the vow is gone from the door) | `check_ia` 82 / 3 — *§1 (vowed): the raider lost 4 — the vowed Devout's own ground reflected* (+2 more)<br>`check_hy` 173 / 10 — *§1 (A0 no share, the Devout vowed) blow 1: the raider lost 22 — the mirror 8, the wire 12 and the reflect 0 make 20* (+9 more) |
| H01 | HEAD's battle.gd under check_ia | `check_ia` 82 / 2 — *§1 (vowed): the log prints a reflect that never landed: '→ Consecrated Ground reflects 4 to Orc Raider (Righteous Fire)'* (+1 more) |
| C10 | the cap back to two | `check_ia` 82 / 9 — *§2a: `Run.ENGINE_SLOTS` is 2 — the designer ruled three* (+8 more)<br>`check_gt` 3477 / 1 — *§1: 88 configurations — every set of up to 2 of each class's six, and its six: 88 expected* |
| C11 | the refusal says 'Both core slots are filled.' again | `check_ia` 82 / 1 — *§2a: a fourth core rune was not refused with 'Every core slot is filled.' (Both core slots are filled.)* |
| C12 | the event verb asks to slot a core rune again (HEAD's ask) | `check_ia` 82 / 2 — *§2d: the event slotted the core rune it handed over — one choice handing over two things* (+1 more) |
| C13 | slotting a core rune writes more than its flag | `check_ia` 82 / 1 — *§2c: slotting a core rune on the map wrote more than its own `equipped` flag* |
| C14 | a core-slot count rides the save | `check_ia` 82 / 1 — *§2b: the save carries a core-slot count ["engine_slots"] — a slot count in a save owes a version* |
| C15 | the card's core line no longer wraps (HEAD's layout) | `check_ia` 82 / 2 — *§6: the widest set (442 px) fits one line of 656 — the arm reads no overflow* (+1 more) |
| C20 | a held ordinary row prints '(held)' again | `check_ia` 82 / 1 — *§3b: a row prints its state beside the section that says it: ["row:Second Winter — Breaking a hold leaves the enemy Chilled to the depth the hold was worth, instead of on…*<br>`check_gt` 6117 / 172 — *§1: engine_berserker alone, one ordinary rune — last_word's rule is not drawn whole* (+171 more)<br>`check_hr` 102 / 1 — *§1f: a row of the Mage's panel still prints `(held)` beside the section that says it* |
| C21 | a worn ordinary row prints its ✦ again | `check_ia` 82 / 3 — *§3b: WORN holds ["✦ Chain Fire", "✦ Ashfall"], not the worn ["Chain Fire", "Ashfall"]* (+2 more)<br>`check_hf` 314 / 2 — *§4b (with the vow): the vow's pouch row does not show its own rule* (+1 more) |
| C22 | a WORN head drawn above CORE (the order broken) | `check_ia` 82 / 5 — *§3a: a hero holding nothing draws ["WORN — 0 of 3 slots", "CORE — 0 of 3 slots", "— empty core slot —", "— empty core slot —", "— empty core slot —", "No core rune held. …* (+4 more) |
| C23 | an empty core slot is not drawn | `check_ia` 82 / 4 — *§2b: the loaded save's panel reads 'CORE — 2 of 3 slots' with 0 empty core slots — three slots, the third empty* (+3 more) |
| C24 | HR's count line back beside the section that counts | `check_ia` 82 / 1 — *§3b: HR's count line stands beside the section that counts — two counts of one thing* |
| C25 | held core runes listed after the held ordinary ones | `check_ia` 82 / 1 — *§3b: HELD, NOT WORN holds ["Second Winter", "Ember Leap", "Rune of the Arcanist (core)", "Rune of the Invoker (core)"], not ["Rune of the Arcanist (core)", "Rune of the I…* |
| C26 | the crest's bag takes a hero's section head | `check_ia` 82 / 1 — *§3e: the crest's bag drew a hero's section head* |
| C27 | Close inside the panel's scroller | `check_ia` 82 / 3 — *§3a: the bare panel's Close is inside the scroller, where text can carry it off* (+2 more)<br>`check_gt` 6117 / 663 — *§1: engine_berserker alone, the pouch empty — Close is inside a scroller, where text can carry it off* (+662 more) |
| C28 | the kit preview grows a section head | `check_ia` 82 / 1 — *§3g: the kit preview is not one flat list with its state column* |
| C2M | the nameplate's held marker loses its ✦ (HR's marker on the map, which IA keeps) | `check_ia` 82 / 1 — *§3f: the Mage's nameplate does not carry ✦ 8*<br>`check_hr` 102 / 3 — *§2: the Beastmaster's nameplate does not mark one rune waiting (1 held)* (+2 more) |
| C29 | a worn rune that sits out shows its rule in the panel, not GX's sentence | `check_gx` 1237 / 46 — *§3 ambush (engine out): the pouch row does not say the rune is sitting out* (+45 more)<br>`check_hf` 314 / 1 — *§4b (with the vow): the pouch row shows the rune's own rule — it should say it sits out, in the one sentence* |
| H02 | HEAD's map_screen.gd under check_ia | `check_ia` 82 / 18 — *§2a: with every core slot full, a held core rune drew no Swap saying so* (+17 more) |
| C30 | the hero sheet's state column says ENGINE again | `check_ia` 82 / 1 — *§4: the sheet's state column reads CORE 0 time(s) and ENGINE 1 — the Warrior's one slotted core rune* |
| C31 | the kit preview says ENGINE again | `check_ia` 82 / 3 — *§3g: the kit preview is not one flat list with its state column* (+2 more)<br>`check_hz` 107 / 1 — *§1b: the preview does not show the Warrior's core rune as it reads (`Rune of the Berserker (core)`, CORE)* |
| H03 | HEAD's kit_preview.gd under the re-tuned check_hz | `check_hz` 107 / 1 — *§1b: the preview does not show the Warrior's core rune as it reads (`Rune of the Berserker (core)`, CORE)* |
| C40 | the shared-walk sentence states a count of sites again | `check_ia` 82 / 1 — *§5: the shared-walk sentence states a count of sites again: FIVE sites* |
| C41 | the shared-walk sentence loses its pointer to check_dm §1 | `check_ia` 82 / 1 — *§5: the shared-walk sentence does not point at `check_dm` §1's live count* |
| C50 | the panel's core heading renamed (check_hn's re-tune) | `check_hn` 74 / 1 — *§2b: the Warrior holds a core rune and his pouch showed the empty line, or no core-rune header*<br>`check_ia` 82 / 5 — *§2a: the panel's core head reads ''* (+4 more) |
| C51 | a kit that grows six entries only when a third core rune is slotted — check_hu's walk reads triples | `check_hu` 104 / 2 — *§1a: in normal play a hero raises a 19-entry menu (berserker ["bloodrage", "heavy_plating", "seasoned"], 7 earned) — more than one page; the pager is live without the deb…* (+1 more) |
| C51h | the same, under HEAD's check_hu (its walk reads pairs) | `check_hu` 104 / 0, green |
| C52 | Close moves only when three core runes are slotted — check_gt's walk reads triples | `check_gt` 6117 / 1 — *§1: the text scrolls for 168 configurations, first ["engine_berserker + engine_warden + engine_swordmaster, the pouch empty", "engine_berserker + engine_warden + engine_m…* |
| C52h | the same, under HEAD's check_gt | `check_gt` 3477 / 125 — *§1: the warrior's six, the pouch empty — engine_swordmaster's rule is not drawn whole* (+124 more) |
| H04 | HEAD's map_screen.gd (one heading, rows marked ✦ and (held)) under the re-tuned panel gates | `check_hn` 74 / 1 — *§2b: the Warrior holds a core rune and his pouch showed the empty line, or no core-rune header*<br>`check_hr` 102 / 3 — *§1f: the Mage's panel draws no HELD, NOT WORN section* (+2 more)<br>`check_hf` 314 / 3 — *§4b (with the vow): the pouch row is missing — it should say it sits out, in the one sentence* (+2 more)<br>`check_gt` 6117 / 196 — *§1: the warrior's six, the pouch empty — engine_momentum's rule is not drawn whole* (+195 more)<br>`check_gx` 1367 / 42 — *§3 ambush: the pouch row is not the one sentence, flattened* (+41 more) |

**Round three — the repair of `check_gt`, two-armed, on the final tree** (lane *"Dawn of Decay IA ctlC"*, a copy taken after the repair,
predicted first): the baseline, two defects that live only where the first re-point never looked, each under the repaired gate and
under the pre-repair population (the *p* rows: the same gate with the six and the holding cap walked at the cap alone), and every round
two control that ran `check_gt`, re-run against the repaired gate. 20:44:21 to 20:53:29, **exactly as predicted**: the baseline green at 6813; **C53 and C54 red in the repaired gate and green under
the pre-repair population** — a Close that moves only where a slot is empty is invisible to a walk that only ever fills them; C10, the
cap back to two, now reads `check_gt` green at its two-slot population (3941) — the walk follows the cap, and the cap's pin is
`check_ia` §2a, red in round two; C20, C27, C52 and H04 red as in round two, with more lines where the new configurations carry the
rows.

| id | the defect planted | read (the first FAIL line) |
|---|---|---|
| C00 | baseline: the landed tree, no patch | `check_gt` 6813 / 0, green |
| C53 | Close inside the scroller only while a hero holds his six with a core slot empty — the repaired walk | `check_gt` 6813 / 80 — *§1: the warrior's six, 0 slotted, the pouch empty — Close moved to [P: (140.0, 623.0), S: (1000.0, 38.0)] from [P: (140.0, 658.0), S: (1000.0, 38.0)]* (+79 more) |
| C53p | the same, under the pre-repair population (the six and the holding cap with the cap slotted only) | `check_gt` 6117 / 0, green |
| C54 | Close inside the scroller only with every core slot empty and the holding full — the repaired cap arm | `check_gt` 6813 / 8 — *§1: the warrior holding 8 of his class's runes, 0 slotted — Close is not where it always is, outside the scroller ([P: (140.0, 779.0), S: (992.0, 38.0)])* (+7 more) |
| C54p | the same, under the pre-repair population (the six and the holding cap with the cap slotted only) | `check_gt` 6117 / 0, green |
| C10 | the cap back to two | `check_gt` 3941 / 0, green |
| C20 | a held ordinary row prints '(held)' again | `check_gt` 6813 / 196 — *§1: engine_berserker alone, one ordinary rune — last_word's rule is not drawn whole* (+195 more) |
| C27 | Close inside the panel's scroller | `check_gt` 6813 / 743 — *§1: engine_berserker alone, the pouch empty — Close is inside a scroller, where text can carry it off* (+742 more) |
| C52 | Close moves only when three core runes are slotted — check_gt's walk reads triples | `check_gt` 6813 / 1 — *§1: the text scrolls for 168 configurations, first ["engine_berserker + engine_warden + engine_swordmaster, the pouch empty", "engine_berserker + engine_warden + engine_m…* |
| H04 | HEAD's map_screen.gd (one heading, rows marked ✦ and (held)) under the re-tuned panel gates | `check_gt` 6813 / 340 — *§1: the warrior's six, 0 slotted, the pouch empty — engine_berserker's rule is not drawn whole* (+339 more) |

### §8e — THE PRE-PASS

**The whole battery in an isolated copy, before the repository's own run** — 141 targets in a copy proved equal to the tree as it
stood at 19:29 but its name (*"Dawn of Decay IA prepass"*, 521 files), predicted first, launched beside recon 2 to save the hour it would otherwise
wait. 19:29:47 to 20:47:21 — 77 min 34 s, beside recon 2 for its first hour — **read `check_de` 581 / 0 / 0, exactly as predicted**:
`check_ia` new at 82 / 0, `check_parse` 216, `check_gt` 6117 (the first re-point), `check_ea` 396, `check_eh` 310, `check_hr` 102,
the re-tuned gates at their counts (`check_hn` 74, `check_hz` 107, `check_hf` 314, `check_gx` 1367, `check_hu` 104), `check_hy`
173 / 0, `check_cm_live` 13 / 4 and `check_gj` 70 / 1 with their sanctioned lines word for word, `test_batch_an` 6055 and
`test_batch_bk` 130 inside their bands, the run harness PASS 22 / 382 / 8, 141 names in `.ran` each once in one ascending sequence,
and no Parse Error, SCRIPT ERROR, TIMED OUT, NO VERDICT or CUT OFF line.

**It read the tree as it stood before the repair**, so what changed after it — `check_gt.gd`, the comment in `map_screen.gd`, the
baselines row, the manifest, and the lines in `CLAUDE.md`, `docs/state.md`, the changelog and the design notes — was read again.
**The post-repair subset**: every reader of those files, twenty-one targets, in a copy proved equal to the final tree (*"Dawn of Decay
IA postfix"*), predicted first — 20:48:09 to 20:53:54 — each at its prediction, green: `check_gt` 6813, `check_ed` 18, `check_gw` 76,
`check_da` 41, `check_gs` 824, `check_hx` 39, `check_ff` 68, `check_ec` 24, `check_fg` 30, `check_es` 57, `check_hp` 171, `check_fr`
25, `check_dv` 84, `check_el` 24, `check_ek` 47, `check_dm` 93, `test_batch_bx` 159, `test_batch_ce` 930, `test_batch_bn` 80,
`test_batch_bs` 246 and `check_ia` 82. **And a standalone `check_de` over the pre-pass's logs, with the subset's `check_gt` log in
place, against the final baselines, read 581 / 0 / 0** — every row proved before the repository's run.

**Earlier, a document subset** — fifteen targets on the tree at 19:14, before the changelog's last lines and the WHERE block's
instruments bullet — read each document gate green at its row; it is superseded by the two runs above and kept as the record that
the documents were read before the battery.

### §8f — THE ACCEPTANCE RUN, IN THE REPOSITORY

**The repository's own runner, in the repository, on the final tree** — the report still in the scratchpad and the post-run lines not
yet written — **141 targets, 20:54:27 to 22:12:12: 77 min 45 s.** The tree was frozen by md5 before and after — 521 files, untracked
included — and read byte-identical; the rows of `ps` were read every 15 s by executable, 310 readings in the run's window, **no game
window in any**. **`check_de` read 581 / 0 / 0, exactly as predicted**: every target at its final row — `check_gt` 6813, `check_ia` 82,
`check_parse` 216, `check_ea` 396, `check_eh` 310, `check_hr` 102, the re-tuned gates at their counts (`check_hn` 74, `check_hz` 107,
`check_hf` 314, `check_gx` 1367, `check_hu` 104), `check_hy` 173, `check_gw` 76, `check_gp` 443, `check_gv` 1057 — `check_cm_live`
13 / 4 and `check_gj` 70 / 1 with their sanctioned lines word for word, `test_batch_an` 6048 and `test_batch_bk` 131 inside their
bands, the run harness PASS 22 / 382 / 8; 141 names in `.ran`, each once, in one ascending sequence; no Parse Error, SCRIPT ERROR,
TIMED OUT, NO VERDICT or CUT OFF line. **The player's four files were untouched** — md5, size and modification time against the
backup. **HZ read 140 in 77 min 28 s; IA read 141 in 77 min 45 s.**

**Then the final tree.** The post-run lines in `docs/state.md` — the verification bullet and the two readings, its own size a fixed
point — were written after the run and swept against every gate literal: 22,285 fragments, **none lost**; three gained, each in a gate
that never opens the file (`check_cl_resolver`'s *FAIL*, the *files)* of `check_da` and `check_fi`, `check_go`'s *-20*). **Every reader
of the file and the document instruments were re-run on it** in an isolated copy proved equal to the tree, which differs from the
acceptance freeze in that one file (*"Dawn of Decay IA final"*), predicted first: `check_dm` 93, `check_es` 57, `check_fg` 30, `check_fr` 25, `check_ek` 47, `check_hp` 171, `check_hx` 39,
`test_batch_as` 273, `test_batch_aw` 212, `test_batch_at` 359, `test_batch_aj` 213, `check_ec` 24, `check_ff` 68 and `check_ed` 18,
each at its acceptance reading, green — **and `check_de` over the acceptance run's own logs, read against this tree, 581 / 0 / 0.**

### §8g — THE TWO READINGS AGAINST THE TWO CEILINGS, AND WHAT IS LEFT RUNNING

- **`CLAUDE.md` closes IA at 449,554 B = 439.02 KiB — 70.98 KiB under its 510 KiB ceiling** (+3,610 B at IA).
- **`docs/state.md` closes IA at 345,112 B = 337.02 KiB — 42.98 KiB under its 380 KiB ceiling** (+5,860 B at IA, its own post-run
  lines included).

**Nothing is left running**: the rows of `ps` read after the last run hold no Godot. **IA's own copies stay for IB** (HO §5): fourteen user-data folders — *Dawn of Decay IA ctlA, ctlB, ctlC, docsub, final, postfix, prepass, probe, probe6,
recon, recon2, trgt, trhead, trnew* — 5,200 KiB; `app_userdata` reads 491 folders and 154,124 KiB in all.
**HZ's fifteen stay beside them, 6,312 KiB** (§6).

### §8h — THE PUSH

Committed to `class-merge` by name — `save-backups/` left untracked — and pushed. `git ls-remote origin class-merge` is read after the
push and reported in the hand-back beside local HEAD: a commit cannot carry its own hash.
