# BATCH IH — THE CARD, THE SHEET, AND EVERY PLATE THAT OVERLAPS ITSELF

**On `class-merge`, from `29407e8` (IG). IMPLEMENT ONLY.** **The designer played.** His file is
`readout/run-20261014-134942.jsonl` — four fights of a fresh rung-2 run (Warden, a Mage on the class's own engine, Devout,
Sharpshooter) — **and it is debug-touched**: from the second fight every hero holds his class's whole pool (the unlock-all), and the
fights end in a fraction of a round. It was backed up first, with the four player files (§9a). `run_save.bin` moved for the first
time in eleven batches: 40,284 B at 14:30 today — **a second, fresh rung-1 run** standing at its first node, no fight finished.

**What IH did.** **The readout was repaired first** (§0.2): it names every debug action and every fight one touched, says why
each conjunction ended, and carries the lineage's name and each core rune's kind; the brief's 13 is the body's Constitution, not a
defect. **The card lost its core-rune line and gained `Runes n/6` beside Kit** (§2). **The sheet shows what the hero is** — the blurb,
the live stats, the class passive and his lineage's own engine, the talents — and nothing he wears, with no scroller (§3). **The Runes
panel was looked at on the real screen and left alone** (§4). **The sheet's ability hover moved to the Kit panel's rows, with the live
config it is built from, and the kit preview reads the same builder** (§5). **Every plate and card was laid out again so that nothing
on one is drawn over anything else on it** — three Godot sizing traps made every finding — **and `check_ih` §6 asserts the rule over
337 configurations** (§6). **The dealt core rune is slotted; the screenshot was reading the card's ordinary slots** (§7a). The two
rules are recorded in `CLAUDE.md` (§0); sixteen gates were re-pointed to the surface that answers each one's question (§1a); and two
defects found on the way were fixed: Sanctity's rule text said 16 after IG set 13, and the Stances line said +15% where the fight
pays 30%.

**VERDICT: GREEN. The pre-pass and the acceptance each read `check_de` 609 / 0 / 0 over 148 targets, as predicted, with only the
predicted rows moved; the recon's every red was named but `check_fr`'s, which was the lane's; twenty-six controls and HEAD's code
bite; no die moved**

## NEEDS A RULING

1. **PLAY ONE ZONE WITHOUT THE DEBUG MENU, AND SEND THE FILE.** The first file prices nothing (§0.2); the readout now names every
   debug action, so a file that names none is play. It answers Boil Over's rate, Rupture's number, the vow's worth, Sanctity's step
   (a Cleric on the Hierophant's rune) and the Cleric's Mana.
2. **SANCTITY's STEP AT 13 — CONFIRM THE NUMBER** (IG's ruling 2, carried: the file holds no Hierophant).
3. **THE BERSERKER's AND THE PYROMANCER's ART (§6b).** The art is the odd one: two illustrations beside ten lineages that share the
   Soldier sheet's small figure. The layout holds any of them now; which art a lineage wears is yours.
4. **THE CORE RUNE's TELL ON THE RUNES BUTTON (§2).** It marked the card's line (HC §5); the line is gone, so the button wears ○, amber
   and the sentence. Confirm, or say where it goes.
5. **TWO SHAPES §6 CHOSE** — the chip row's `+N` (a wrapping row would grow a plate into the next) and a value a size smaller inside its
   bar when it is wider than the bar (Resonance and Focus have no ceiling). Confirm both.
6. **THE FREED ROOM (§7b)** — proposals below; nothing was moved into it.

## THE BRIEF's PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §9b: IG's push hash | **Held**: `29407e8…` on the remote and at local HEAD, read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | §9a: the readout is in no backup set; back it up first | **Held, and done first** (14:46, before any other action): `../save-backups/IH-20261014-144644` holds the four player files and `readout/` (`latest.txt`, `run-20261014-134942.jsonl`, 16,291 B, a header and four fights), md5-identical to the live folder |
| 3 | §9a: `run_save.bin` 42,200 B at 2026-10-08 09:23 for eleven batches | **Moved**: 40,284 B at **2026-10-14 14:30**. Decoded from the backup: a **fresh rung-1 (wanderer) run** — Berserker, Pyromancer, Devout, Sharpshooter — at zone 1, slot 0, no win, gold 60, `debug_used` false, every core rune `equipped: true`. Two game sessions today (the log rotation: 13:46:53, 14:07:49); both logs hold the engine's header alone — no error in his play |
| 4 | §9a: the file in hand is four fights of a fresh rung-2 run; a newer one? | **Held**: `resumed: false`, rung 2, four fight lines. **No newer readout file** — the second run has finished no fight, and a file is claimed at a fight's end |
| 5 | §0.2: three of four fights ended rather than won; the debug menu | **Held in shape**: rounds 0.3 / 0.5 / 1.8 / 0.3, hero turns 1 / 2 / 7 / 1, and from fight 2 every hero holds his class's whole pool (49, 56, 48, 50 cards) — the unlock-all. **Nothing in the file said so** (fixed: §0.2) |
| 6 | §0.2: the Rupture stood one turn and its body likely died | **Held as far as the file goes**: `stood` 1, `ticks` 1, `standing_at_end` false; why it ended is exactly what the file could not say (§0.2b) |
| 7 | §0.2: `RUPTURE_BREAK_PER_TICK` 10, the tick ground 13 | **No defect**: the tick passes 10 to `take_hit`, which divides by the body's Constitution — the Orc Slinger's is **80** (`data/enemies.json`): 10 × 100 / 80 = 12.5 → 13. The readout records what the meter took. The constant is what the game uses |
| 8 | §0.2: the Mage reads `lineage: ""`; the Cleric is named Devout and reads `inquisitor` | **Both by design**: the field is `member["spec"]`, written only by `Run.awaken` from the engine taken. The Mage took the **Rune of the Invoker (core)**, whose engine is **Channel — the Mage's spine**, which carries no lineage, so `spec` is "". The Devout's pool key is `inquisitor` (CLAUDE.md, *names that look wrong and are right*). Repaired so a census can read it (§0.2c) |
| 9 | §1a: `check_gx` §3 reads the sheet's worn rune rows (24 arms) | **Held** — 12 engines × 2 arms |
| 10 | §1a: `check_hu` §4b reads a chip on the sheet | **Not held**: it reads a battle unit's Iron Will chip; `check_hu` never opens the sheet |
| 11 | §1a: the readers named | **47 arms in 14 files**: of the brief's named list ten are readers; `check_hu`, `check_hk`, `check_ho` §5d and `check_hp` read no removed block (`check_ho` §5d and `check_hp` §1a/§1g read the sheet's PROLOGUE, which IH moved — re-pointed with it, §1a). **Four reader files went unnamed**: `check_fh`, `check_ek`, `test_batch_cp`, `test_batch_ah_battle`; and `check_hl` §6 read the prologue too |
| 12 | §2: removing the line frees exactly the room the button needs | **Held, measured**: the line sat at x 8–232 below the slots; the button (65 px) and Kit (56) take x 165–292 of the CHOOSE row, which narrows to 151 px (its widest face, *CHOOSE — upgrade*, is 124) |
| 13 | §2: `Runes 6/6` against `KIT_BTN_W` 56 | **Held**: *Runes 6/6* is **56 px** at font 10 with the button's margins (*Kit 10/10* 51); *○ Runes 6/6* — the face a core rune sitting out gives it — is 65, and the button takes 65 so the face can change and the button cannot move |
| 14 | §3: the passive block scrolls over its own last line onto ABILITIES | **Held**, rendered at HEAD: an 80-px scroller at y 242 under the ABILITIES header at 296; and **two more collisions on the same sheet** — the RUNES block drew *None worn* under a listed core rune, and the tag line ran under the talent board at x 500 |
| 15 | §5: the sheet's tooltip is `_ability_tooltip`, the builder every ability surface uses | **Not held**: the sheet built its own off `Classes.computed_block` at the hero's live Attack (CK §1's static builder); `battle._ability_tooltip` is the live, in-fight third copy CK §1 keeps apart by ruling (cooldown left, Surge, refusals); **and the kit preview had a fourth** (the block at no Attack). The sheet's builder was moved, with the prologue its numbers need (§5) |
| 16 | §6a: the tan box under two portraits is cut off (*Allie…*) | **Found**: the **engine chip** — Blood Frenzy's `+0% (floor 0%)` and Lethal Aim's `Aim +0%` drawn in a 26-px box, their tag labels 111 and 67 px wide hanging out of it. No string beginning *Allie* is drawn on a plate |
| 17 | §6b: the Warrior's portrait — wrong size, or the card the wrong shape? | **Both, in part**: the art is the odd one (the Berserker's 64-px bust, the Pyromancer's 236-px frame, beside ten lineages on the Soldier sheet), **and** the layout let any texture grow past its column (§6b) |
| 18 | §7a: IA §2e says class selection slots the one taken; the screenshot says otherwise | **IA holds**: `Run.awaken` writes `equipped = true`, and the designer's own save reads it four times. The three *— empty —* buttons are his **ordinary** rune slots; the core rune was named only on the line §2 removed |
| 19 | §8: IG read 592 folders, 258,260 KiB; spent prefixes 585, 251,660 KiB | **Held** (§8) |
| 20 | §9b: IG read 147 in 81 min 36 s | **Held** (IG §8g) |
| 21 | §9b: the two readings — 456.66 KiB (53.34 under), 345.24 KiB (34.76 under, 21.4 batches at 1,661 B) | **Held** (IG's close) |

## §0.2 — THE READOUT, REPAIRED FIRST

**The file, read.** `run-20261014-134942.jsonl`: a `run` header (`resumed: false`, rung 2, `warden` difficulty, no relic, no crest)
and four `fight` lines — a normal fight (Totemist, Shaman), an elite (Chief, two Whelps), a normal fight (four Slingers, the one
Rupture), an elite. **From fight 2 every hero holds his class's whole pool** (49 / 56 / 48 / 50 cards) — the menu's *All Class
Abilities Unlocked* — and fights 1, 2 and 4 end at a third to a half of a round with almost nothing dealt. **The file carried no
word of it**; the brief's damage arithmetic was withdrawn for exactly that reason, and it was right to be.

### §0.2a — THE READOUT RECORDS DEBUG

`Run.note_debug(action, taken)` is called beside each of the two `Run.debug_used = true` writes (the map burger's dispatch and the
battle's `DEBUG ▾` menu, which stay the flag's only two writers), naming the action by what it does — *+200 Gold*, *60 talent
points to every class, every tier open* (the menu label still says *+200 Talent Points*, FOUND AT IH), *Full Heal Heroes*, *Jump
to Boss Slot*, *Advance to Next Zone*, *Reroll Specs*, *All Class Abilities Unlocked: on/off*, *Free Travel: on/off*, *Test a node:
…*, *Full Restore*, *Kill All Enemies*, *Cooldowns OFF / back on*, *Enemy attacks OFF / back on*, *Turn lock → …* — before the
action runs (a Kill All ends the fight inside its own call). The readout keeps it in the run's readout state, never in the save.
**Three places carry it, because a written line is never rewritten** (IF's append-only rule): the header carries `debug_used` (the
run's flag, which rides the save, so a resumed run carries it too) and `debug` (every action taken before the header was written);
**an action taken after the file exists is a `{"kind": "debug"}` line of its own, appended the moment it is taken**; and **every
fight line carries `debug`**: the actions taken since the previous fight line (on the map, or in this fight) and the switches in
force as it opened (a pre-granted kit, a summoned node, free travel, enemy attacks off — the menu's, or `DOD_ENEMIES_OFF`'s). A
clean fight's list is empty. **A fight whose list is not empty prices nothing.**

### §0.2b — A CONJUNCTION RECORDS WHY IT ENDED

A composition leaves a body through four doors, each of which already logged its reason: `_dissolve` (its clock — *the clock*; a
cleanse; a consumer taking an ingredient), `remove_status` lifting it whole, a purge lifting it whole, and `_die`. Each now hands
that reason to `BattleUnit.conj_end_cb` (wired at `_make_unit`, where every unit passes); the battle's `_on_conj_end` passes it to
the readout behind its null test. The line carries `ended` — *its clock ran out*, *it was cleansed*, *an ingredient was consumed*,
*its body died*, or *the fight ended* when it stands at the end — and `ended_turn`. **An end no door reported reads *it left by a
door the readout does not hear***; `check_ih` §0b drives all five and holds that there is none (the fallback that classified a dead
body by reading it was taken out, so the hook at `_die` is the only source and a control breaks it, C04).

### §0.2c — THE LINEAGE

The field is `member["spec"]`, written once by `Run.awaken` from the engine the hero took. **Two of four do not carry it as read,
both by design**: the Mage took the Rune of the Invoker (core), whose engine is Channel — **the Mage's spine, which belongs to no
lineage** — so `spec` is ""; the Cleric's lineage key is `inquisitor`, displayed as *Devout*. The readout now writes beside it
`lineage_name` (*Devout*, "" for none) and `core_kind` for each core rune (`lineage`, `spine` or `rule`). **Every census this
conversation has run by lineage silently left out a hero on a spine or a rule engine**; `core_kind` is the field to census those by.

### §0.2d — THE 13

`_dot_tick_rider` hands `TICK_BREAK["rupture"]` — `RUPTURE_BREAK_PER_TICK`, 10 — to `take_hit(0, 10)`, which scales Break by the
body's Constitution before anything else: 10 × 100 / 80 = 12.5, rounded to **13** for an Orc Slinger. The readout records what the
meter took. **The constant is what the tick reads; not a defect.** The legend says so now.

## §1 — THE TWO CENSUSES, KEPT

**§1a** (kept: `census_1a.md`, the batch's working file, summarised here): **47 reader arms in 14 files** read the three removed
blocks or the card's line — 32 open the sheet and read its labels, 7 read `party_screen.gd`'s text or pin a count on it, 8 read the
card line — about 206 executions a battery and ~90 reds unre-pointed, plus ~96 more in `check_gx` §3 had the new button been bound
like a rune slot. **Each was asked which question it asked, and re-pointed to the surface that answers it now** (table below); no
arm that asked a live question was deleted. **And four arms the census filed as reading kept code read code IH moved**: the sheet's
prologue (`check_hl` §6, `check_hp` §1a and §1g, `check_ho` §5d) — found when `check_hl` read red on the moved code, re-pointed to
`Run.hero_live_config`'s own body. `check_hp` §1a was an absence pin and would have passed vacuously.

| Gate | Arm(s) | The question | Re-pointed to |
|---|---|---|---|
| `check_fh` | §4 (sheet census + RUNE CONDITIONS), §9b (the sheet's RUNES line) | the census is drawn where the swap happens; the count on screen matches the run | §4: the sheet draws **no** census (the panel's positive arms stand above it); §9b: the card's **Runes button** reads the run's count |
| `check_fn` | §3 (three sheet arms) | the census is the panel's, the retired line gone | the sheet draws no census (one arm; the panel's three stand) |
| `check_gs` | §4 (the sheet with all 24 engine runes; the door's 13 calls) | every surface that shows a rune's text asks the door | the **kit preview** with all 24; the four files read are shop, map, **kit preview**, spec choice — still 13 |
| `check_gt` | §3 (17 sits-out chips, the seated filter, the undone row) | a card that sits out says why; it is not also drawn seated | the **kit preview**'s lines, the sentence on the line itself |
| `check_gx` | §3b (24 rows, the state column, its tooltip); §3's slot sweep | a worn rune that sits out says so, with GX's sentence | the **kit preview**'s line (its state inline, the sentence on its hover — one arm a rune, the state column's separate tooltip, has no counterpart: −12); `_slot_buttons` leaves out `runes_button` |
| `check_hc` | §1 (three tinted screens), §6 (the card's line ○ + amber + hover; the sheet's state column) | HC §5's tell on GX's four surfaces | §1: two tinted screens of three read (the kit preview draws state colours); §6: the card's **Runes button**, the **kit preview** |
| `check_hf` | §4b (Burning Ground's sheet row, its sentence, its rule, the state) | GX's surfaces say a rune sits out | the **kit preview** |
| `check_ia` | §4 (the sheet's CORE), §6 (the card line fits its card) | CORE is the word; the card says what he wears, inside the card | §4: the sheet carries no state (negative) beside the **Runes panel**'s CORE head (positive, +1); §6: the **Runes button** counts the widest three cores inside the card, its panel names them |
| `check_id` | §3a (↑ on four surfaces), §3b (the sheet's ↑ chip), §4c (the line clear of Kit) | ↑ names an upgrade wherever one appears; the row's controls do not overlap | §3a: the **Kit panel's row** is the fourth surface (map_screen two lines); §3b: the Kit panel's ↑ row and its hover; §4c: the **Runes button** inside its card, clear of Kit and CHOOSE (+1 a card) |
| `check_ie` | §4 (the sheet's worn row beside WORN, no ✦) | ✦ names a rune and never doubles a state | the **kit preview**'s worn line |
| `check_ek` | §3 (four files name a tag) | exactly the authored files name a tag | three define/display; `party_screen.gd` joins `NO_TAG_FILES` |
| `test_batch_cp` | §3 (`computed_block` in party_screen) | the live-Attack surface calls the one builder | `Run.ability_hover`'s own body |
| `test_batch_ah_battle` | §5 (the sheet shows the earned cards) | the surface reads the earned list | the **Kit panel** |
| `check_hl` §6, `check_hp` §1a/§1g, `check_ho` §5d | the prologue's needles in party_screen | the sheet's numbers are the spawn's | `Run.hero_live_config`'s body, and the sheet calling it |

**§1b** (kept: `census_1b.md`): **the surfaces that draw a portrait or a bar** — the battle's hero plates, its enemy plates and
companion plates (one builder, `BattleUnit.build_plate`), the turn-order strip, the crest strip, the map's hero cards, the
skill-check bar, the bargain card, and the run-start hero picker (portrait in a container — clean); the class-selection screen, the
draft screens, the kit preview, the victory card, the run summary, the shop, the events, the Blacksmith and the relic screen draw no
portrait and no fill bar. **One mechanism behind nearly every finding** (census 1b §0): a Control's theme overrides reach its
minimum size only once it is in the tree, so a size set before `add_child` is clamped to the default 16-px font's line (22–23 px)
and kept; a TextureRect sized before its expand mode keeps its texture's size; a wrapping Label given its text before its width
keeps a word-per-line height.

## §2 — THE CARD: THE LINE GOES, THE BUTTON ARRIVES

**The line went whole** — the list of core-rune titles and the *click the card for the sheet* hint both. **`Runes n/6` joins Kit**
on the card's bottom row: n his slotted core runes plus his worn runes (`Run.engines_worn` + `Run.runes_worn`), 6 the two slot
counts the panel heads (`Run.ENGINE_SLOTS` + `Run.rune_slots()`); its hover says the split and what he holds unworn.
**Measured** (the button's own minimum at font 10): *Runes 6/6* is 56 px, *○ Runes 6/6* 65 — so `RUNES_BTN_W` is 65 and the face can
change without the button moving. The row reads, from the right: Kit (56, x 236–292), a 6-px gap, Runes (65, x 165–230), a 6-px
gap, CHOOSE when a pick is owed (151 px wide from x 8; its widest face, *CHOOSE — upgrade*, is 124). The gap is 6, not 4: at 4 the
two dark faces read as one box on the real screen. **HC §5's tell rides the button** (the line was the map's one place a core rune
that pays nothing was said): ○ in the face, amber, and GX's sentence ending its hover — `check_hc` §6 reads it there (ruling 4).
The button carries the `runes_button` meta, because `check_gx` §3 reads every other button bound to the rune panel as a slot.
**Found in the building and fixed**: the button's first version was sized before it was parented and drew 85 px wide, under Kit —
`check_id` §4c caught it, the first of §6's mechanism met in IH's own code.

**Driven** (`check_ih` §2): no card draws the line; every card's button reads the run's count and lies inside its card on Kit's row,
left of Kit, its face inside it; pressing it opens that hero's panel (*Warrior — RUNES* for card 0, and so on) and no other; Close
returns to the card with its face unchanged. **The negative arm**: a hero wearing nothing reads `Runes 0/6`, and his panel draws CORE
— 0 of 3 with three *— empty —* rows, WORN — 0 of 3 with *No rune worn.*, and HELD, NOT WORN — 0 of 8 with *Nothing held*.

## §3 — THE SHEET: WHAT HE IS, AND NOTHING ELSE

**Kept**: the blurb; the live stats (HP, Attack, the resource, Armor, Resistances, Speed, Constitution, Crit Chance, Parry, and
Block on a Warden); the class passive; the talent tree with *(LOCKED FOR THIS RUN)*. **Removed**: *ABILITIES — n of 7 slots* and its
chips, *CARRIED BY TAG*, and the RUNES block.

**What the passive block held**: the class passive's line (*Class: <name> — <desc>*), then one line for **each slotted core rune's
engine** (`_passive_desc_live`), then *Core rune: none held.* when none. Since GK a lineage's engine IS a core rune, so the block
printed his lineage's own engine and **every other core rune's rule beside it** — the Berserker wearing the Warden's core rune
printed Seasoned Fighter as though he were one. **Now**: the class passive, and his lineage's own engine
(`Classes.engine_of_spec(spec)`) while its rune is slotted. Another core rune's rule is on the Runes panel's CORE row
(`Runes.shown_desc`, the one door). A hero awakened on the class's spine — the designer's Mage — has no lineage, and his block is the
class passive alone; Channel's rule is on his Runes panel. *None held* is that panel's to say. **The scroller went**: the block has
the column (a label parented, sized, then given its text, so it wraps at 400 px and is as tall as its lines).

**Found and fixed in the block it keeps**: the Swordmaster's Stances line read **+15%** damage in the aggressive stance while the
fight pays `SEASONED_AGG_DEALT`, **30%** since HL, and called Guard Change *earnable*; it reads the constant now (census 1a's side
finding, verified against the battle's own chip).

**Driven** (`check_ih` §3, the designer's four lineages and a Swordmaster): every kept block drawn; **the negative arm** — no
ability row, no tag census, no rune name, no state word and no scroller anywhere on the sheet; **the positive arm** — the Kit panel
draws his cards and the census, the Runes panel the worn core rune whose rule the sheet gave up.

## §4 — THE RUNES PANEL, BEHIND ITS BUTTON

**What opens it today**: the new button (always), the ✦ marker on the nameplate (while he holds a rune unworn), and **each of the
card's three rune slots** (always — every slot, empty or filled, is bound to his panel). **All three kept**: the marker is the glance
that says something waits, the button and the slots the ways in; the slot that shows a worn rune's name opens the panel that moves
it. **Looked at on the real screen** (rendered, IH's tree): CORE heads its section in amber over amber rows, WORN in green over green
rows, HELD, NOT WORN in purple, each separated — **the distinction reads, and nothing was changed.** **The longest panel** — all six of his class's core
runes (three slotted, three held) and eight runes (three worn, five held): a full holding of eight, fourteen rows — draws every rune
exactly once (`check_ih` §4).

## §5 — THE KIT PANEL's ABILITY HOVER

**The premise did not hold** (premise 15): there were three builders. **What moved**: the sheet's prologue — sixty lines that build
a hero's live config the way the battle spawn does (kit, passive, spec stats, earned cards, tree, runes, the crest's rune, upgrades
last, Ashen Skin, maximum health, Toughness, node scaling) — moved unchanged into `Run.hero_live_config`, which the sheet now calls;
and the chip's tooltip moved into `Run.ability_hover` (the resolved description, `Classes.computed_block` at his live Attack, the
*Scaling* line, the upgrades that landed). **Every ability row on the Kit panel** — STARTING KIT, ENABLERS, CARRIED, BENCHED —
carries it; a benched card's hover is read seated, through the same doors; a carried card that sits out carries GX's sentence (the
sheet's chip's); a row whose card took an upgrade wears ↑ (`Run.ability_landed`), as the sheet's chip did. **The kit preview** built
a fourth copy at no Attack; it reads the same builder now, so the two are one string. **`battle._ability_tooltip` is left apart** by
CK §1's ruling (it reads a live unit: cooldown left, Surge, refusals). **Driven** (`check_ih` §5): the longest description in the game
(*Harvest*, 342 characters, the Survivalist's lineage pool) carried, upgraded and hovered whole; every row's hover the builder's; the
kit preview's, string for string; a sitting-out card's sentence; **the negative arm** — no head or note carries a hover; and the sheet
and the preview build none of their own.

## §6 — THE LAYOUT PASS: NOTHING DRAWN OVER ANYTHING ELSE

### §6a — WHAT THE SCREENSHOT SHOWS, NAMED AND MEASURED (HEAD → IH, rects relative to the plate or card)

1. **Every hero plate's values through its bars**: each value label was **98 × 23** on a **98 × 10** (HP) or **98 × 9** bar — sized
   before it was parented, so at the default font's 22-px line, centred on that box and hanging under its bar into the next. **Now
   126 × 12 on a 126 × 12 bar**, a font-8 value's whole line.
2. **The enemy plates the same**, and *Break 0/100* under it: the same labels; now the same fix.
3. **The Berserker's portrait over his name and his Rage line** — on **the map card** (*— ge — builds in combat* is the card's Rage
   line): the portrait was sized before its expand mode, so it drew at its texture's own **64 × 64** from x 8 to 72 across a text
   column that starts at 58 (the Soldier crop the others wear is 44 × 60 too, but its figure is 17 × 21 in the middle of it). On the
   battle plate the same bust drew **64 × 64** over a 34-px column, and the Pyromancer's 236-px frame crop **104 × 142**, down into the
   next plate. **Now 44 × 44 on the card and 34 × 34 on the plate, in their columns.**
4. **The Sharpshooter's Focus line cut at the plate's edge**: in a 98-px bar its readout runs 95 px at zero Focus and 113 at depth;
   the plate is **172** wide now with a 126-px bar, and a readout wider than its bar takes font 7 inside it (Resonance has no ceiling).
5. **The intent line outside its plate's text column**: it started at **x 4**, across the enemy's 44 × 60 portrait; **now x 42**, the
   bars' column, 126 × 13 at font 9. **The tan box**: the engine chip, 26 px wide, its tag label **111 × 23** (Blood Frenzy's
   *+0% (floor 0%)*) hanging out of it; **now 53 × 12 with its tag inside it** — every chip as wide as its tag.

### §6b — WHAT WAS BUILT, SURFACE BY SURFACE

- **The battle plate** (`BattleUnit.build_plate`): every label parented before it is sized (`BattleUnit._put`); the portrait's expand
  mode before its size; `PLATE_W` 144 → **172**; the name a 16-px line (Pirata One 11) in a 162-px box; bars **12 px**, a font-8 line;
  a value wider than its bar at font 7 (`_fit_bar_text`); the intent line at the bars' x; the chip row's chips fitted to their tags
  (12 px floor) and stopping short of the rune chips, a last `+N` chip naming the rest on its hover; the rune chip's ✦ at font 8 (its
  line is 12 px parented — HZ §1d's 18 was the clamp) filling its chip by anchors. **Heights**: 73 (one resource), 86 (two), 74 (an
  enemy with its intent line), 87 (an enemy with Rage), 68 (a companion).
- **The stacks** (`battle.gd`): the heroes' from y **170** every **90** (six plates — four heroes and The Pack's two beasts — end at
  706; the turn strip ends at 88); **the warband's laid by each plate's own height** from **200** with a 4-px gap (`_stack_enemy_plates`):
  a Chief's 87 at a fixed pitch ran into the next plate. Six plates of 74 end at 664 — above the dev DEBUG button at 678, which
  census 1b found over enemy plate 5.
- **The crest strip**: its label 50 × 22 over chip 0 and 5 px into plate 0 → 40 × 13, chips from x 44.
- **The skill-check bar**: its two lines parented before they are sized (each was 22 px); the panel 59 → 64 so the result line is
  inside it; the cursor 16 px inside its 16-px track (it stood 3 px proud above and below, across the result line's top).
- **The long-fight nudge**: drawn across the turn strip's portraits at y 52 → under the strip at y 92.
- **The map card**: the portrait's order (64 → 44); the name a 20-px line (font 14; a name wider than its box takes font 12 — *Warrior
  — Unawakened* beside a ✦ marker is 160 px in 146); the HP value's bar 15 → **16** (font 11's line) and the Mana bar 11 → 12 (font 8,
  the font now named by the caller, not `h - 4`); both bars 4 px lower, under the ✦ marker's 26-px foot (`check_ih` §6 caught the
  marker over the HP bar); the ↑ badge and the owed-pick badges parented before they are sized.
- **The bargain card** (`offer_screen._draw_option`): every label parented, sized, then given its text — **the descriptions drew as one
  unwrapped line through the next card** (census 1b §6, confirmed: the walk read a description 897 px tall before the fix).
- **The hero sheet's blurb and passive block**: wrap, parent, size, then text.

**THE WARRIOR's PORTRAIT — SIZE OR SHAPE?** The art is the odd one: the Berserker wears a dedicated 64-px bust
(`Berserker_Portrait.png`) and the Pyromancer his 236-px frame, while the other ten lineages share the Soldier sheet's crop, whose
figure is 17 × 21 in a 44 × 60 cell. **And the layout was wrong for any of them**: a column the code meant as 34 (plate) or 44 (card)
took its texture's size. The layout now holds any art in its column; at 44 px the bust reads as a face and the Soldier as a small
figure. **Which art a lineage wears is the designer's question** (ruling 3).

### §6c — THE GATE ARM (`check_ih` §6)

**The rule as an assertion**: on one plate or card, no two drawn rects meet but a value laid on its own bar and contained by it top
and bottom (a bar is its track and the fill inside it; a chip's tag is its chip's value), no drawn rect runs past its container, no
line is wider than its box; **a Label's rect is its line box**, never its ink. **And a second arm**: each side's plates clear of one
another and on the screen. **The walk**: four warbands of up to six covering all 21 enemy kinds, against four parties covering the
twelve lineages and the four classes on their spines and a rule engine (a Beastmaster's companion among them), each held **as
spawned and declaring, at its longest values** (four-digit health, full bars, Focus 150, the warband's longest declared action),
**with its chip row full** (fourteen statuses and three rune chips), **with no intent and the row empty**, and **with a hero fallen**;
the turn strip's slots, the crest strip, the skill-check bar at its longest result; **every map card** for the four parties, and the
designer's party with upgrades, a full Kit, runes held, every pick owed, a core rune sitting out, a hero at 0 and a hero unawakened;
**every bargain card** (all twenty modifiers). **337 configurations** — 185 battle plates, 40 plate stacks, 56 turn-strip slots, 4 crest strips, 4 skill-check bars, 28 map
cards and 20 bargain cards — and **1,010 values read inside their own bars**. **The fullest**: a battle plate, the Holy hero with his
chip row full (34 drawn rects); a map card, the Pyromancer owing every pick (17). **The emptiest**: the Orc Raider's plate as spawned
(8); the Berserker's card as dealt (11). **Controlled both ways**: the walker's own arm passes a value inside its
bar and catches the same value moved half a line down; the controls in §9e plant each defect back.

## §7 — TWO THINGS THE SCREENSHOTS RAISE

### §7a — THE DEALT CORE RUNE IS SLOTTED

**IA §2e holds; the screenshot read the card's other slots.** `Run.awaken` slots the engine taken (`rune["equipped"] = true`), and the
designer's own save reads `equipped: true` on all four heroes' core runes. **The three *— empty —* buttons on every card are his
ORDINARY rune slots** (`Run.rune_slots()` over `member["runes"]`), which a fresh run fills from drops; the sheet's *0/3 equipped, 1/3
core* said exactly that. The core rune was named on the card only by the line §2 removed — **the card now counts it on the Runes
button (*Runes 1/6* at a run's start)**. No trap and no ruling owed; the ruling the brief reserved is answered by the code.

### §7b — THE FREED ROOM (proposals; nothing built)

- **The card**: the line's room — 26 px between the rune slots (ending y 88) and the button row (y 114) — is the owed-pick badges'
  line when a pick is owed, and empty otherwise (rendered). **Proposal: leave it.** Moving the slots or the buttons up would make the
  card change shape between owing and not owing.
- **The sheet**: the left column below the passive block (from about y 330 to the foot) is empty (rendered). **Proposals**: (a) leave
  it — the sheet says what he is in a glance; (b) the stats one size larger; (c) the talent board moved left and widened, its node
  names on fewer lines. None is IH's to choose.

## §8 — HOUSEKEEPING

**THE MOVE WAS NOT ATTEMPTED** (IB §4). **Read at IH's start** (before its own folders, at 14:46): **592 folders**, IG's close, the live
*Dawn of Decay* folder **69 entries** (IG's 68 and the `readout/` folder), 520 KiB. **Read at the close**: **599 folders, 259,700 KiB** in
all — IH's own seven among them (**1,424 KiB**). The spent prefixes — every *Dawn of Decay* copy from FX to IG (IG's five included,
**6,060 KiB**) and the five *DoD …* copies — are **590 folders, 257,720 KiB**: IG's 585 at its reading (251,660 KiB) and IG's five.
The live *Dawn of Decay* folder holds **69 entries, 544 KiB** at the close: no IH scratch file in it (`check_ih` writes
`user://ih_profile.json` and `ih_relics.json` and removes both), the harness's save and the engine's logs re-written by the
acceptance as at every acceptance.

**ONE command clears every spent prefix** — every *Dawn of Decay* copy from FX to IG (IG's five included) and the five *DoD …* copies —
leaving the live *Dawn of Decay* folder, IH's own seven and `[unnamed project]`:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IG)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-G]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IG)/"
```

Each of its three patterns was listed before it was written here — 470, 115 and 5 folders, the 590 — and none reaches IH's seven
(*Dawn of Decay IH …*) or the live folder. **IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so
a prefix already cleared is dropped from the paste first.

**The folders, by IG's own rule — one a concurrent lane — and IH did not keep it.** IH made **seven**: *IH A* (14:57, the IH code
lane), *IH H* (15:02, HEAD's renders), *IH B* and *IH C* (15:19, two of three re-pointing lanes run at once), *IH R* (15:47, the
recon), *IH K* (16:03, the controls) and *IH T* (16:17, the traces). **The peak was four lanes at once**, read off each folder's own
last writes: at 16:03:48 the two rect probes for §6a's before-and-after (IH's code in *A*, HEAD's in *H*) ran beside the recon and
the first control — **so four was the floor for this schedule, and three of the seven could each have reused a folder no running
lane held**: *C* (15:19) while *H* stood idle from 15:13 to 16:03, *K* (16:03) after *B* finished at 16:02, and *T* (16:17) after
*A* and *B*. Lanes that ran one after another shared a folder safely — the trace lanes shared *IH T*, the controls *IH K*, and the
gap run, the final-tree checks, the pre-pass and the close's six gates shared *IH R* after the recon — and no two running lanes
ever shared one. **The rule binds a batch's folder count as well as its safety: the next batch reuses before it makes.**

**THE LIVE FOLDER's `readout/`**, read and not changed: `latest.txt` (40 B, naming `user://readout/run-20261014-134942.jsonl`) and
`run-20261014-134942.jsonl` (16,291 B, a header and four fights, last written 14:07:18). Backed up with the four player files
(§9a); no gate writes it (`check_if` §9 and `check_ih` §9 compare it whole, before and after).

## §9 — THE VERIFICATION

### §9a — THE READOUT FILE, FIRST

**Backed up before anything else ran** (14:46:44, the batch's first action after reading the brief): `../save-backups/IH-20261014-144644`
holds `profile.json`, `relics.json`, `run_save.bin`, `settings.cfg` and **`readout/`** — `latest.txt` (40 B) and
**`run-20261014-134942.jsonl` (16,291 B; a `run` header and four `fight` lines)** — each md5-identical to the live folder.
**The save moved**: `run_save.bin` was 42,200 B at 2026-10-08 09:23 for eleven batches; it is **40,284 B at 2026-10-14 14:30:10** — a
**fresh** rung-1 run (Berserker, Pyromancer, Devout, Sharpshooter) at its first node, saved during the second of two game sessions
today (the logs rotate at 13:46:53 and 14:07:49; each holds only the engine's header). The readout's run is the first session's: fresh
(`resumed: false`), rung 2. **No newer readout file exists** — the second run has finished no fight.

### §9b — THE PUSH CHECK, THE SWEEPS AND THE INTEGER PINS, BEFORE THE PREDICTION

`git ls-remote origin class-merge` read `29407e8…`, local HEAD the same, before anything ran. **The literal sweep** (IG's
`litsweep_ig.py`, double- and single-quoted, every gate's literals HEAD's and the tree's) over IH's nine game files: **155 lost, 151
gained, 42 short flips, 75 counts moved** — nearly all common words a gate holds for another file; **filtered to the gates that name
the file a literal left** (`litfilter.py`), the lost needles are the census's (§1a) plus four it filed as kept code: the sheet's
prologue lines `check_hl` §6, `check_hp` §1g and `check_ho` §5d read (moved to `Run.hero_live_config`; found when `check_hl` read red
on the moved code, before the recon, and named in its prediction). **The pin manifest**: every lost needle a pin holds — predicted as
`check_ed`'s red (IG's miss, named this time); rebuilt, 1,779 → **1,795 pins**, the same three unresolved as HEAD.

**The integer pins at the doors the diff touches** (comment-stripped `scripts/*.gd`, HEAD → IH): `_apply_status(` 222 → 222,
`add_status(` 17 → 17, `float_text(` 348 → 348, `set_display_chip(` 20 → 20, `apply_upgrades(` 3 → 3, `Run.debug_used = true` 2 → 2 —
**unmoved: IH spends no die and touches no damage path**; `Runes.shown_desc(` 14 → 13 and `Runes.RUNE_TINT` 8 → 7 (the sheet's rune
block — `check_gs`'s 13 and `check_hc`'s count re-pointed), `Classes.computed_block(` 5 → 4 (the sheet's and the kit preview's →
`Run.ability_hover`), `Run.seated_ability_names(` 3 → 2 (moved into the run node), `_readout.` 16 → 17 (`conj_ended`, behind its null
test — `check_if` §1e reads it). **No pool depth moves**: the diff touches no card, rune, shelf or pool.

**THE BLAST RADIUS, READ FIRST.** IH's code changes what plates and cards draw and where, and what the readout writes; **it spends no
die** (the counts above) **and changes no figure a fight computes**. §6 moves rects on every plate in battle: **what it can reach** is
any gate that reads a plate's, a card's or a panel's geometry or labels (`check_hz` clicks a plate, a chip and the intent line by their
rects; `check_ie`, `check_ig` and `check_hs` count a plate's chips); **what it cannot reach** is a seeded road's dice — no float, no
status, no `randf` moved.

**THE REFERENCE CLAIMS, RE-READ (HY §6).** Every claim in `docs/instrument-rules.md`, `docs/combat-rules.md` and
`docs/ways-of-working.md` that names a surface IH touched — the hero sheet, `party_screen`, the card's core-rune line, a plate, the
Kit and Runes panels, the kit preview, the readout, `computed_block`, `_ability_tooltip` — was read against the tree: **two**, and both
hold. `docs/combat-rules.md`'s *`party_screen`'s hero card prints the base rate … plus `crit_bonus`* is the sheet's Crit Chance line,
which IH kept (§3); `docs/instrument-rules.md`'s *`check_map_screen` … opens the rune panel, the loadout panel* still opens both. **No
live count IH moved stands in any of the three** (the battery's 147, `check_parse`'s 223, the manifest's 1,779, `check_de`'s 605 and
the plate's width, swept: none).

### §9c — THE RECON: HEAD's BATTERY ON IH's CODE

**The shape**: HEAD's 146 targets — HEAD's gates and HEAD's documents — on IH's game code (nine scripts), in an APFS clone with its
own user folder (*IH R*), 15:48:19 to 17:08:16 — **147 targets in 79 min 57 s**. The prediction (`RECON_PREDICTION.md`, 15:48:13)
was written after the literal sweep and census 1a. **`check_de` 605 / 23 / 0**, and every red but one is a reader the prediction
named, at the count it named: `check_fh` 2, `check_fn` 1, `check_gs` 26, `check_gt` 18, `check_hc` 4, `check_hf` 3, `check_ia` 2,
`check_id` 2, `check_ie` 1, `check_ek` 1, `check_hl` 1, `check_ho` 2, `check_hp` 1, `test_batch_cp` 1, `test_batch_ah_battle` 3,
`check_ed` 1 (IG's miss, named this time). **`check_gx` read 109 against a predicted ~121**: the sections were right — 84 are §3's
slot sweep counting the Runes button as a fourth slot, twice for each of the 42 runes that read an engine (the prediction took 48),
and 25 are §3b's sheet rows and its said-or-quiet line. **The one miss is `check_fr` 2, and it is the lane's, not IH's**: §1 reads
the branch refs out of `.git`, and the recon's clone was made without it. The pre-pass's clone carries `.git`.
**What was predicted green and was**: `check_gp` 444, `check_gj` 70 / 1 (its sanctioned §4), `check_gv` 1057, `check_hk` 168,
`check_gn` 204, `check_hz` 107 (the plate's clicks), `check_ig` 51, `check_if` 85, `check_hs`, `check_hu`, `check_ib`, `check_ic`,
`check_map_screen`, `check_ct_map`, the skill-check gates, `test_batch_bk` 130, `test_batch_an` 6047 (both in band), `check_cm_live`
13 / 5 (its band), the harness 22 / 382 / 8. **No die moved**: against IG's acceptance logs, run by the same gates on IG's code,
`check_gp` (10,285 lines), `check_gv` (19,741), `check_hk` (5,551) and `check_gj` (4,505) read line for line but for their runtime
and leak lines; `check_go`'s one printed figure differs, and it differs between IG's own runs on IG's code (60 in its acceptance, 80
in its pre-pass and both recons). **The recon copy was unchanged by its run** (537 files, md5 before and after).
**AND THE RECON RAN ONE CODE CHANGE SHORT, FOUND AFTER IT.** Four of its nine scripts differ from the final tree: three by comments
only (a comment-stripped diff reads 0 code lines) and `readout.gd` by five — the fallback that classified an unheard conjunction end
by reading its body, taken out after the launch (C04's repair). **The gap was swept and run**: every literal in HEAD's and the
tree's gates (22,067), counted in the recon's copy of the four and the final copy — five presence flips, each a word the new
comments gained (*preview* and *the kit preview* for `check_gs`, *there* for `check_da`, *pos* for `check_ec`, *holds* for
`check_hd`) — and HEAD's `check_if`, `check_da`, `check_hd` and `check_ec` run on the final four: 85 / 0, 41 / 0, 35 / 0, 24 / 0.

### §9d — THE CONTROLS

**Every repair and every gate arm IH wrote was planted back, each in its own APFS clone of the final tree, each patch asserted to
match exactly once before it ran** (`controls_ih.py`). **H01 is HEAD's game code under IH's gates**: every re-pointed gate that asks a
question HEAD's code answered differently reds on it. **Four re-pointed gates read green under H01 — `check_gs`, `check_gt`, `check_ie`
and `test_batch_ah_battle` — because the surface each was moved to (the kit preview, the Kit panel) already answered at HEAD**; a
two-armed control needs each to bite on the surface it reads now, so **C23–C26 plant the defect there**.

**Twenty-six controls and HEAD's code, every one biting, each read by its FAIL text and not its count** (C00 is the final tree, unpatched):

| # | The defect planted | What read it |
|---|---|---|
| C00 | baseline: the final tree, no patch | `check_ih` 94 / 0<br>`check_fh` 167 / 0<br>`check_gx` 1355 / 0<br>`check_hc` 75 / 0<br>`check_id` 211 / 0 |
| C01 | the battle's debug dispatch tells the readout nothing | `check_ih` 94 / 2 — *§0a: the header does not carry the run's flag and the two actions before it: true / [{ "action": "+200 Gold", "taken": "on the map" }]* |
| C02 | no switch in force is read as a fight opens | `check_ih` 94 / 1 — *§0a: the unlock switch does not touch every fight while it is on: [{ "action": "All Class Abilities Unlocked: on", "taken": "on the map" }] / []* |
| C03 | a conjunction's clock or a consumer ends it unheard (the hook at `_dissolve` gone) | `check_ih` 94 / 2 — *§0b: the five Ruptures do not say why each ended, in order: ["it was cleansed", "it left by a door the readout does not hear", "it left by a door the * |
| C04 | a body dying ends its conjunction unheard (the hook at `_die` gone) | `check_ih` 94 / 2 — *§0b: the five Ruptures do not say why each ended, in order: ["its clock ran out", "it was cleansed", "an ingredient was consumed", "it left by a door * |
| C05 | the lineage's name is not written | `check_ih` 94 / 2 — *§0c: the four rows do not read lineage, its name and the core rune's kind as `awaken` set them: [["warden", <null>, ["lineage"]], ["", <null>, ["spine* |
| C06 | the card's core-rune line drawn again | `check_ih` 94 / 2 — *§2: a card still draws the core-rune line: ["core runes: Berserker — click the card for the sheet", "core runes: Berserker — click the card for the sh* |
| C07 | the Runes button counts the ordinary runes alone | `check_ih` 94 / 5 — *§2: card 0's Runes button reads 'Runes 0/6' — want `Runes 1/6`*<br>`check_fh` 167 / 1 — *§9b: the first card's Runes button reads 'Runes 3/6' — want `Runes 4/6`, the run's own count* |
| C08 | every card's Runes button opens the first hero's panel | `check_ih` 94 / 5 — *§2: card 1's Runes button opened 'Warrior — RUNES' (panel for 0)* |
| C09 | the sheet's passive block prints every core rune's rule again | `check_ih` 94 / 4 — *§3 (warrior): the passive block is not the class passive and the lineage's own engine: ["Class: Threatening Presence — Enemies are 20% more likely to * |
| C10 | the sheet's rune header drawn again | `check_ih` 94 / 4 — *§3 (warrior): the sheet draws something he wears, or a scroller: ["RUNES  (0/3 equipped, 1/3 core — swap them on the map)"] (0 scrollers)* |
| C11 | the passive block back in a scroller | `check_ih` 94 / 8 — *§3 (warrior): the sheet draws something he wears, or a scroller: [] (1 scrollers)* |
| C12 | a carried card's Kit-panel row carries no hover | `check_ih` 94 / 4 — *§5: a Kit-panel ability row carries no hover ["Harvest", "Twin Hunt", "Call the Wilds"], or not the moved builder's [] (7 rows)* |
| C13 | the kit preview builds its own hover again, at no Attack | `check_ih` 94 / 2 — *§5: the kit preview's hover differs from the Kit panel's for ["Quick Shot", "Powershot", "Harvest"] (2 the same)* |
| C14 | a plate's value sized before it is parented (IH's first defect, put back) | `check_ih` 94 / 1 — *§6: 2067 drawn rects over another or past their container — ["Berserker hero (as spawned, declaring): text \'+0% (floor 0%)\' [P: (13.0, 228.0), S: (5* |
| C15 | the plate's portrait sized before its expand mode | `check_ih` 94 / 1 — *§6: 1951 drawn rects over another or past their container — ["Berserker hero (as spawned, declaring): text \'+0% (floor 0%)\' [P: (13.0, 228.0), S: (5* |
| C16 | the chip row runs on past the plate (no `+N`) | `check_ih` 94 / 1 — *§6: 524 drawn rects over another or past their container — ["Berserker hero (the chip row full): panel \'Panel\' [P: (129.0, 228.0), S: (14.0, 12.0)] * |
| C17 | the map card's HP value in a bar a pixel short of its line | `check_ih` 94 / 1 — *§6: 55 drawn rects over another or past their container — ["card 0 Berserker (as dealt): text \'175 / 175\' [P: (66.0, 115.0), S: (234.0, 16.0)] over * |
| C18 | the warband's stack at a fixed 80-px pitch again | `check_ih` 94 / 1 — *§6: 10 drawn rects over another or past their container — ["the warband\'s stack (as spawned, declaring): Orc Chief\'s plate over Withered Warden\'s",* |
| C19 | Sanctity's rule text names 16 again | `check_ih` 94 / 2 — *§0d: Sanctity's rule does not read `every 13 changes` and `up to 5.` off its constants: Sanctity: every 16 changes to the statuses on the field* |
| C20 | the Stances line reads 0.15 again | `check_ih` 94 / 1 — *§3: the Swordmaster's Stances line does not read `AGGRESSIVE — +30% damage dealt`, or still calls Guard Change earnable* |
| C21 | a conjunction standing at the fight's end is not said to have ended with it | `check_ih` 94 / 2 — *§0b: the five Ruptures do not say why each ended, in order: ["its clock ran out", "it was cleansed", "an ingredient was consumed", "its body died", "i* |
| C22 | the Runes button counted as a rune slot again (its meta gone) | `check_ih` 79 / 8 — *§2: card 0's Runes button reads 'none' — want `Runes 1/6`*<br>`check_gx` 1355 / 84 — *§3 ambush (engine out): 4 rune slot buttons — 3 expected* |
| H01 | HEAD's game code under IH's gates | `check_ih` 64 / 33 (1 throws) — *§0a: +200 Gold on the map before any fight is not kept for the header: { "fresh": true }*<br>`check_fh` 167 / 2 — *§4: the hero sheet still draws a `CARRIED BY TAG` census — it is the Kit panel's (IH §3)*<br>`check_fn` 83 / 1 — *§3: the hero sheet still draws a `CARRIED BY TAG` census — it is the loadout panel's (IH §3)*<br>`check_gs` 824 / 0<br>`check_gt` 6816 / 0<br>`check_gx` 1355 / 12 — *§3 ambush (engine out): the kit preview's line does not carry the sentence naming Rune of the Sharpshooter (core)*<br>`check_hc` 73 / 3 — *§6 (Lethal Aim in): the Hunter's card drew no Runes button*<br>`check_hf` 314 / 2 — *§4b (with the vow): the kit preview's Burning Ground line does not hang the sentence*<br>`check_ia` 81 / 3 — *§4: the sheet reads CORE 1 time(s) and ENGINE 0 — it carries no rune state since IH §3*<br>`check_id` 210 / 6 — *§3a: ↑ is not drawn once on each of the four upgrade surfaces and nowhere else: { "battle.gd": 1, "blacksmith_screen.gd": 1, "map_screen.gd": 1 } ["pa*<br>`check_ie` 70 / 0<br>`check_ek` 47 / 2 — *exactly the authored FILES in the GAME name a tag — found [scripts/classes.gd, scripts/map_screen.gd, scripts/party_screen.gd, scripts/runes.gd], expe*<br>`check_hl` 169 / 1 — *§6: the hero sheet's prologue (`Run.hero_live_config`) does not hand the party to the payload's condition*<br>`check_ho` 176 / 2 — *§5d: the hero sheet no longer stamps the crest's payload on the hero it shows*<br>`check_hp` 171 / 2 — *§1a: the hero sheet's prologue hands `LIVE_DOOR`, so it would show a live rune paying nothing at the opening*<br>`test_batch_cp` 586 / 1 — *the moved hover (`Run.ability_hover`) calls the SAME builder*<br>`test_batch_ah_battle` 71 / 0<br>`check_if` 85 / 0 |
| C23 | the kit preview shows a rune's raw desc around the door | `check_gs` 824 / 2 — *§4: `kit_preview.gd` reads a rune's desc around the door (rune.get("desc")*; *§4: the four screens ask the door 12 times — thirteen surfaces render a rune's text* |
| C24 | the kit preview's sits-out line drops its sentence | `check_gt` 6816 / 17 — *§3 permafrost: the kit preview does not show Winter's Toll sitting out with its reason ()* (one a sitting-out card, every engine) |
| C25 | the kit preview's worn line carries ✦ beside its state | `check_ie` 70 / 1 — *§4: the kit preview's worn line is not WORN beside its name, or it carries ✦ (["   WORN ✦   Vigil — …"])* |
| C26 | the Kit panel draws no carried card | `test_batch_ah_battle` 71 / 3 — *the Kit panel shows the earned Blood Price* (and Cleave, Rallying Shout) |

### §9e — THE MOVED COUNTS, ATTRIBUTED

Each moved row was attributed by an ok() trace: HEAD's gate on HEAD's tree and IH's gate on IH's, every `ok()` printed, the message
multisets diffed with digits masked (`trace_H`, `trace_N`). **`check_fh` 168 → 167**: §4's two sheet arms (the census present,
RUNE CONDITIONS absent) are one, the sheet drawing no census; §9b reads the card's Runes button, one for one. **`check_fn` 85 → 83**:
§3's three sheet arms are one. **`check_gx` 1367 → 1355** (−97 +85, every message paired): §3b's 24 sheet rows are the kit
preview's lines, whose state stands on the line, so the state column's own tooltip arm has no counterpart (−12). **`check_ia`
82 → 83**: §4's sheet arm is the negative beside the Runes panel's CORE head (+1); §6's four arms are four. **`check_id` 210 → 211**
(−6 +7): §4c's line arm ran on three cards and the Runes button's runs on four. **`check_parse` 223 → 224**: `check_ih`. `check_hc`,
`check_ek` and `check_ie` moved one for one, their counts unmoved. **No die moved**: the integer pins at every door the diff touches
held (§9b), and the seeded roads read IG's acceptance logs line for line (§9c).

### §9f — THE PRE-PASS AND THE ACCEPTANCE RUN

**The prediction** (`ACCEPT_PREDICTION.md`, written at 16:31, before either launch): 148 targets, **`check_de` 609 / 0 / 0**, and
seven rows moving against IG's acceptance — `check_ih` new, `check_parse` 224, `check_fh` 167, `check_fn` 83, `check_gx` 1355,
`check_ia` 83, `check_id` 211 — and nothing else.

**The pre-pass**: an APFS clone proved equal to the tree (538 files, the project name aside) and **carrying `.git`** this time,
its own user folder (*IH R*, idle since the recon), 148 targets, 17:13:08 to 18:35:28 — **`check_de` 609 / 0 / 0**, `check_fr`
25 / 0 with its refs to read. **The acceptance in the repository**: 148 targets, 17:13:08 to 18:35:30 — **82 min 22 s** against
IG's 81 min 36 s for 147 — **`check_de` 609 / 0 / 0, as predicted**: `check_ih` 94 / 0, `check_parse` 224 / 0, `check_fh` 167,
`check_fn` 83, `check_gx` 1355, `check_ia` 83, `check_id` 211, each 0 failures; every other re-pointed gate at IG's count with 0
failures (`check_gs` 824, `check_gt` 6816, `check_hc` 75, `check_hf` 314, `check_ie` 70, `check_ek` 47, `check_hl` 169,
`check_ho` 176, `check_hp` 171, `check_hx` 39, `test_batch_cp` 586, `test_batch_ah_battle` 71); `check_ed` 18 / 0 and `check_ec`
24 / 0 on the rebuilt manifest; `check_gp` 444, `check_gj` 70 / 1 (its sanctioned §4 at *+168 / 188*, IF's and IG's line),
`check_gv` 1057, `check_hk` 168, `check_gn` 204, `check_hz` 107, `check_hs` 83, `check_hu` 105, `check_ig` 51, `check_if` 85,
`test_batch_bk` 131 (its band 129–131), `test_batch_an` 6055 (pre-pass 6053; its band 6044–6066), `check_cm_live` 13 / 5 inside
its band (its five FAIL lines md5-identical to IG's, in both runs), the harness 22 / 382 / 8. **Against IG's acceptance, row by
row, only the seven predicted rows and `check_de` moved**, with `test_batch_an` inside its band. **Against IG's acceptance logs, the
seeded roads read line for line**: `check_gp` and `check_gv` differ by their runtime and leak lines, `check_hk` by its leak lines,
and `check_gj` by those and one combat line printed five lines earlier — the same line, a fight still printing at quit.
**`ps` read by rows every 15 s**: 331 readings and **641 Godot rows** across the two batteries — 316 readings saw two, 9 saw one,
6 saw none (between targets) — **640 of them `--headless` targets by their command line, and one a target caught as it exited**:
`(Godot)`, one second old, its arguments already gone, at 17:25:25 — the second the pre-pass's `test_batch_bm` closed its log.
No game window. **The tree was byte-identical before and after** (538 files, tracked and untracked), and **the player's four
files and the readout were untouched** (md5 against the backup, before and after).

### §9g — THE CLOSE

**The post-run lines** — `docs/state.md`'s verification line and its two readings — were written after the run, at a fixed point
(the file states its own size: **356,044 B**). **Their needle proof**: every gate literal, double- and single-quoted (22,067),
counted in the copy the battery read and the final file — **no presence flip**. **The four gates that open `docs/state.md` and the
two manifest instruments, re-run on the final tree in an isolated copy** (*IH R*): `check_es` 57 / 0, `check_fg` 30 / 0, `check_hp`
171 / 0, `check_hx` 39 / 0, `check_ec` 24 / 0, `check_ed` 18 / 0 — each at its acceptance reading.

**THE TWO READINGS.** **`CLAUDE.md` is 474,769 B = 463.64 KiB against its 510 KiB ceiling — 46.36 KiB under** (+7,149 B at IH, the
largest growth since HP's +7,935: two standing rules, and the amendments to the blocks that named the sheet, the card's line
or the prologue IH moved) — 5.7 batches at
EZ's record (47,471 ÷ 8,293), 6.6 at IH's own rate. **`docs/state.md` is 356,044 B = 347.70 KiB against its 380 KiB ceiling —
32.30 KiB under** (+2,521 B at IH): 5.6 batches at IA's +5,860 B, **the worst case**; **the honest rate** is ID +952 B, IE +3,917,
IF +236, IG +1,540, IH +2,521 — a mean of 1,833 B over the five, **18.0 batches at it, and the room is planned against that one**.
`docs/state.md` still binds first at the honest rate; `CLAUDE.md` binds first at the record. **The re-measure is II's.**

**The player's four files and the readout, re-read at the close**: byte-identical to `../save-backups/IH-20261014-144644` by md5,
`run_save.bin` 40,284 B last written 2026-10-14 14:30, `readout/` the one file of four fights. **This report was written last**,
from a draft kept in the scratchpad until its verdict was in, and grepped for an unsubstituted template token before it was written out.
