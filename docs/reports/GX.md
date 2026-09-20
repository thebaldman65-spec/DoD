# BATCH GX — A RUNE SITTING OUT SAYS SO

**On `class-merge`. Implement only, and the thirtieth batch on the branch.** GV gated thirty-five
runes on their engine being equipped and closed the OFFER. This closes the other half: a rune
bought while the engine was in, whose engine is now out, sitting in its slot paying nothing with
nothing on any screen saying why. **GT solved the same defect one layer down; this is GT's answer
one layer up, in GT's own words.** `main` is untouched.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

**Seventeen premises are checkable. Fourteen held; three did not, and one of those changed a
figure this report quotes.**

**HELD (fourteen).** GV gated **35** runes (`Runes.ENGINE_READ`, counted). A gated rune with the
engine out sits in its slot paying nothing, with no tell (GV's ruling 3, `docs/state.md`). GT's
tell does name which rune brings the card back, on the hero sheet and the map's Kit panel. GW
found **90 of 92** hand-set sites on the body the game writes to, and the other two are the ones
that hid the dead Shared Hide. The Shared Hide costs **100 gold**; its multipliers are ×1.2500 /
×1.5625 / ×2.3359 and its blows +26.5% / +57.6% / +138.3% (GW §1c); +138.3% *is* the deepest of
three loadouts; and it paid nothing at all until GW. GS found **twenty-four** placeholder rune
descriptions (`runes.gd`, GS §3). GT found the pouch's Close button off-screen for all **sixty**
pairs of one class's engines. A shop cannot offer a gated rune while the engine is out —
**measured here, not assumed: 0 of 35 in the offer pool** (`check_gx` §6). GW's ninety legitimate
arranging sites are untouched and its two are repaired. `test_batch_bx` §4 bans the common noun
*beast* from `docs/master.html` and GW's bullet used it twice (GW §6d). The Crown's Break and
freeze resistance is owed, and the **52** engine-bound gates are step 6.

**DID NOT HOLD:**

1. ***"+138% … needs a Warcry, an Empower and a Battle Shout all live"* — IT NEEDS FOUR, NOT
   THREE.** GW's deep loadout is **Warcry + Empower + Battle Shout + the Pivot** (GW §1c's table).
   The argument the brief asks to be recorded is *stronger* with the correction, not weaker, and
   §2 below states it at four.
2. ***"a benched card's tell"* — A BENCHED CARD HAS NO TELL; A CARD THAT SITS OUT DOES.** The
   distinction is GT's own and `CLAUDE.md` states it in those words: ***"Sitting out is not
   benching"***. Benching is the player's deliberate act to free a slot; sitting out is what the
   engine's absence does to a card he is still carrying. **The tell GX copies is the sits-out one**,
   and getting this backwards would have put the tell on the wrong population.
3. ***"Sanctity's honest text"* — NO SUCH QUEUE ITEM** (the other two names in that sentence do
   resolve, so only this one is wrong). What is queued for Sanctity is its
   **status-potency layer**, *"the single largest unbuilt system the recon found"*. The Crown's
   Break and freeze resistance is owed, and the engine-card text items are GQ's rulings 1 and 2
   (the class-selection card's words and its fixed 280-pixel window). All three stay queued; only
   the middle name was wrong.

---

## §1 — THE TELL

**EVERY SURFACE THAT SHOWS A RUNE THE HERO IS ALREADY WEARING SAYS WHETHER IT IS SITTING OUT, AND
NAMES THE ENGINE RUNE THAT BRINGS IT BACK.**

### §1a — GT's wording, reported and reused

**GT's sentence, verbatim** (`Run.sits_out_note`), hand-broken at 44 characters because the hero
sheet renders it as a tooltip and a tooltip does not wrap:

```
Sits out of every fight while the
<Rune name> is not equipped.
Still carried: the slot stays counted.
Benching the card frees the slot.
```

**GX's is the same sentence with the nouns each surface already uses** (`Run.rune_sits_out_note`):

```
Sits out of every fight while the
<Rune name> is not equipped.
Still worn: the slot stays filled.
Unequipping the rune frees the slot.
```

**THE OPENING CLAUSE IS BYTE-IDENTICAL AND THE REST MOVES ONLY WHERE THE NOUN DOES.** A rune is
**worn** where a card is **carried**; the pouch counts slots **filled** where the Kit panel counts
them **counted**; and **unequipping** frees the slot where **benching** does — each word taken from
the surface that already uses it (the hero sheet's state column reads `WORN`, the pouch's title
reads *"N of 3 slots filled"*, its button reads `Unequip`). **`check_gx` §5 asserts the shared
clause present in both notes and the divergent clauses absent from each other, in both directions**,
so collapsing the two into one sentence reds and so does rewording either. Every line of all
thirty-five is under the ceiling; **the longest is 41 characters** — *"Rune of the Sharpshooter is
not equipped."*

**AND GT's PLACEMENT.** GT put the sentence **in place of the card's own text** on the map's Kit
panel — the panel where the slot can be freed — and as a **greyed chip with the sentence as a
tooltip** on the hero sheet. GX does the same thing one layer up, on the surfaces that answer to
the same description.

### §1b — Every surface that shows a rune

**NINE, DERIVED BY SWEEPING EVERY LINE IN `scripts/` THAT READS A RUNE'S DISPLAY NAME**, comments
stripped, and classifying each — **24 lines: 6 are the sim bot's and the shop's owned-name dedupe,
3 are GX's own guards on the tell, and the remaining 15 render a name into text, across nine
surfaces.** Not from a list.

**FOUR CARRY THE TELL NOW:**

| surface | where | what it does |
|---|---|---|
| **The rune pouch** | `map_screen._open_rune_panel`, the ordinary rune rows | The row shows the sentence, flattened, **in place of the rune's own rule**, in the Kit panel's amber. **This is the one that matters**: it is where a rune is dropped and swapped and where the engine it waits on is re-slotted, so the reason and both remedies are in one place. |
| **The map's three rune slots** | `map_screen._draw_screen`, the hero card | The face is marked and the sentence is the tooltip. **The only one of the three the player does not have to open anything to read.** |
| **The hero sheet** | `party_screen._draw_detail`, the rune rows | The state column reads `sits out` instead of `WORN`, in the same amber, with the sentence on the column and on the row. The rune's own rule **stays** on the row: this page is read to study a loadout, not to change one. |
| **The battle log's roll call** | `battle.gd`, `_rune_roll_call` | The `Rune:` line the spawn writes for every equipped rune carries the sentence's first two lines. **Found by doing the census; the brief named three surfaces.** |

**FIVE NEED NOTHING, AND EACH FOR ITS OWN REASON:**

| surface | why nothing |
|---|---|
| **The Peddler** (`shop_screen`) | **A gated rune cannot be OFFERED while the engine is out** — GV's gate, at `Runes.eligible_ids`. A tell here could never render. **Measured rather than argued**: `check_gx` §6 asks the pool itself and reads **0 of 35** with the engine out against **3** with it in, so the emptiness is the gate and not an empty pool. |
| **A cache or elite offer** (`map_screen`, the `"rune"` branch) | Filtered by the same gate at `Run.rune_choice`, **and GV already built the tell for what it holds back**: *"The cache holds N more that wait on the Rune of the … being equipped."* The gap was never the offer. |
| **A bargain or an event grant** (`events.gd`) | The same door — `run_state.grant_rune` → `Runes.generate` → `eligible_ids`. One gate closes all four offer sites by construction (FM §1). |
| **The run-end summary** (`battle._member_summary`) | A retrospective that lists the whole pouch and has never distinguished worn from carried. Marking one rune there would be the only state distinction on a line that makes none. |
| **The pouch's ENGINE rows** | An engine rune reads no engine, so `Runes.sits_out` is false for all twenty-four; its `Equip` / `Unequip` button already *is* the state the tell is about. |

**THE ROLL CALL IS THE ONE PLACE GX WENT PAST WHAT THE BRIEF NAMED**, on the brief's own
instruction that *every* surface says it. It prints `Rune: <hero>: <name>` for **every equipped
rune** at the spawn, and a rune that sits out is still equipped, so it was named in the log of a
fight it paid nothing in. **A card that sits out is simply absent from the fight; a rune is not** —
the asymmetry the card layer never had, and the reason GT had nothing to mark here. **Its tail is
`Run.rune_sits_out_note`'s own first two lines, joined**, so the log cannot drift from the screens;
`check_gx` §3c asserts it against that function. It reads:

```
Occultist: Deepening Hex — Sits out of every fight while the Rune of the Occultist is not equipped.
```

### §1c — The pouch, measured

**A TELL ADDED TO A LIST THAT ALREADY OVERFLOWED IS WORTH MEASURING**, and this list has overflowed
before: GT found Close wholly below the 720-pixel screen for four engines held alone, for all sixty
pairs of one class's engines and for every class's six, at y 1142 at worst. GX puts a sentence that
wraps to two lines into rows that were one.

| configuration | the list | the scroller | Close |
|---|---|---|---|
| six runes held, engine in (none sitting out) | **287 px** | 583 px | (140, 658), 1000 × 38 |
| six runes held, **two sitting out** | **298 px** | 583 px | unmoved |
| **the panel's own worst case** — a class's six engine rules *and* six runes, two sitting out | **543 px** | 583 px | unmoved |

**NOTHING SCROLLS IN ANY OF THE THREE, AND CLOSE IS AT THE SAME RECTANGLE IN ALL THREE.** The two
sitting-out rows add **11 px** to the list. **The worst case leaves 40 px of headroom** — GT's
layout holds under GX's text, but not by much, and that is the number a later batch adding anything
to this panel should read first. Both tells are drawn whole, inside the scroller, at size 12:
nothing was shrunk (GQ's rule).

### §1d — Why the map's slot carries a marker and not a word

**MEASURED OVER ALL THIRTY-FIVE GATED NAMES, AT THE SIZE THE BUTTON DRAWS** (`check_gx` §2). The
slot is 92 px wide and the three slots are pitched 96 apart; the 92 is a *minimum*, so a longer face
grows the button and it lies over its neighbour rather than clipping.

| face | widest of 35 | fits the 92-px slot |
|---|---|---|
| the name alone | **74 px** | yes |
| the name with a marker | **82 px** | yes |
| `<name> (out)` | 99 px | no |
| `<name> — out` | 105 px | no |
| `<name> — sits out` | 124 px | no |

**NO WORD FITS AND A MARKER DOES**, so the face carries the marker and the amber, and the tooltip
carries the same sentence the pouch and the hero sheet show. **The marker is in the TEXT and not only in
the colour**, because a colour alone is not a tell. The drawn button is asserted inside the 96-px
pitch in the live drive, not only in the string measurement.

---

## §2 — THE SHARED HIDE'S PRICE IS NOT CHANGED

**RULED: 100 gold stands, judged in play.** The reasoning is recorded here because the measurement
invites a raise and the raise should not be re-proposed from the number alone.

- **+138.3% IS THE DEEPEST OF THREE LOADOUTS AND IT NEEDS FOUR SEPARATE DAMAGE EFFECTS STANDING
  ON THE COMPANION AT ONCE** — a Warcry, an Empower, a Battle Shout **and the Pivot** (the brief
  said three; GW's table says four). **Three are party buffs and the fourth is not**: the Pivot is
  `tempo`, a two-turn damage status a stance switch grants, standing on the companion itself — so
  the requirement is if anything harder than "a party built around him", not easier. **The thin
  loadout, one buff, is +26.5%.**
- **AND NOBODY HAS EVER FELT ANY OF IT.** Until GW the rune multiplied a companion's blow by
  exactly 1.0000 from the day it shipped, so there is no play experience of it being too strong to
  weigh a raise against. A price moved on a measurement alone, before anyone has met the thing, is
  a price moved twice.

**GW's FIGURES, RECORDED BESIDE THE RULING SO A LATER BATCH DOES NOT READ A RE-MEASUREMENT AS NEW:**

| loadout | multiplier | 40 seeded bear blows, rune worn | not worn | swing |
|---|---|---|---|---|
| thin — Warcry alone | ×1.2500 | 406 | 321 | **+26.5%** |
| mid — Warcry + Empower | ×1.5625 | 506 | 321 | **+57.6%** |
| deep — Warcry + Empower + Battle Shout + Pivot | ×2.3359 | 765 | 321 | **+138.3%** |

**These are GW's, driven as blows** (`docs/reports/GW.md` §1c), against EZ's own multipliers, which
GW reproduced to four places. **The rune's text, price, terms and multiplier are byte-unchanged at
GX** and `check_gx` §6 asserts the price and the text against `runes.json`.

---

## §3 — WHAT IS DELIBERATELY NOT DONE

- **No rune is retuned, re-authored or retired.** `check_gx` §6 asserts it from the other side: a
  rune that sits out is still equipped, still fills its slot, still has its payload applied at the
  spawn, and its price and text are byte-identical to `runes.json`.
- **The rune is not unequipped for the player, the slot is not freed for him, and it is not made
  sellable.** GV priced four options — leave it alone, sit it out with a note the way a card does,
  unequip it automatically, or let it be sold. **GX takes the second.** Taking any of the other
  three would be a different ruling built under this one's name.
- **The refusal stays inside each read site**, where GV put it. Nothing about how a rune pays moved.
- **The 90 legitimate arranging sites GW's sweep found are not touched.**
- **The Crown's Break and freeze resistance, Sanctity's status-potency layer and GQ's two
  class-selection text rulings stay queued.**
- **The 52 engine-bound gates are the next stage.**
- **No engine, kit, pool, card or node changes.**

---

## §4 — THE NEW GATE

**`check_gx`, eight sections, every negative anchor with its positive arm.**

- **§1 — the predicate over its DERIVED population, never a typed list.** Each of `ENGINE_READ`'s
  35 rows sits out for a hero holding no engine, pays with its own engine slotted, sits out again
  for a hero holding some *other* engine, and **reads the same through `sits_out` as through GV's
  `offerable` inverted** — one predicate, not two. Beside it: the other **25** live ordinary runes,
  which never sit out on any engine set, and four engine runes, which never sit out at all.
- **§2 — the slot's face, measured**, all five forms (§1d above): two positives and three negatives
  on one measurement.
- **§3 / §3c — the four surfaces driven, every row, both arms.** The pouch and the map's slot for
  all **35 and 35**; the hero sheet for one rune per engine, **12 and 12**; the roll call through a
  real spawn, its tail asserted against `rune_sits_out_note` itself. Beside them, on the same
  surfaces and the same frame, **an ungated rune** (the Shared Hide, which reads no engine) and **a
  gated rune sitting in the pouch unequipped** — neither marked, because the tell is about a slot
  that is paying nothing.
- **§4 — the pouch with six held and two sitting out, and GT's own worst case on top of it**
  (§1c above). Close on the screen, at one rectangle across all three configurations, outside every
  scroller and pressed shut in each; both tells drawn whole at size 12 inside the scroller. **The
  heights are PRINTED, not pinned** — a pixel height is a reading, and pinning one reds on any later
  layout change for no defect.
- **§5 — the sentence** (§1a above), including that the note's fallback clause is still reachable.
- **§6 — nothing was retuned** (§3 above), and GV's offer gate reads exactly as it did.
- **§7 — the player's three files, byte for byte.**

---

## §5 — VERIFICATION

### §5a — The acceptance run

**121 TARGETS ON A TREE FROZEN BY md5 BEFORE AND AFTER, AND ALL 422 FILES ARE BYTE-IDENTICAL
ACROSS THE RUN** — nothing was edited behind the battery, so every count below is one tree's.

| | |
|---|---|
| suites | **46 of 46 clean** — zero fails, zero throws, zero FAIL lines |
| gates | clean but the two standing sanctioned reds |
| the run harness | **22 / 382 / 8**, throws=0 |
| `check_parse` | **195 / 0** |
| `check_de`, the count differ | **501 / 0**, one notice |
| the player's four saves | byte-identical to the backup taken before any Godot process ran |

**EVERY PREDICTED BASELINE WAS MET EXACTLY.** `check_gx` **1130 / 0**, written into `baselines.json`
off the standalone reading before the run. Its neighbours did not move: `check_gt` **3157 / 0**,
`check_gv` **877 / 0**, `check_gw` **76 / 0**, `check_ez` **114 / 0**, `check_gu` **317 / 0**.

**THE ONE NOTICE IS THIS BATCH'S OWN AND ITS ROW IS MOVED HERE.** `check_parse` rose 194 → 195
because `check_gx` joined `run_battery.sh`'s GATES and that gate counts the battery's own target
list. Nothing about the parse changed. The row moves in the batch that caused it, which is this one.

**NO `Parse Error` AND NO `SCRIPT ERROR` IN ANY LOG**, read out of stderr rather than off a tally
or an exit code.

### §5a(i) — The two sanctioned reds, diffed against an isolated rebuild of `07c6b99`

**BOTH ARE BYTE-IDENTICAL TO HEAD's.** The rebuild is an `rsync` of the tree with `git archive
07c6b99 | tar -x` over it — so it carries the ignored files and the `.godot` cache a checkout would
not — with `config/name` renamed first and GX's own untracked files removed.

| gate | new tree | HEAD rebuild | the FAIL text |
|---|---|---|---|
| `check_cm_live` | 13 / 4 | 13 / 4 | four lines, **diff empty** |
| `check_gj` | 70 / 1 | 70 / 1 | *"the card says +158 gold and the purse moved 178"*, **diff empty** |

`check_gj`'s gold figures are GW's own +158 / 178, unmoved.

### §5a(ii) — What was run BEFORE the acceptance run, and what was not edited

**NO EXISTING GATE WAS EDITED BY THIS BATCH.** `check_gx` is new; `run_battery.sh` and
`baselines.json` gained its row. So *"run the unmodified gates against the new tree before editing
any of them"* is the whole verification here rather than a preliminary to a re-point.

**THE DOC AND SOURCE-SCANNING GATES WERE RUN AGAINST THE NEW TREE FIRST**, so a two-hour battery
was not spent discovering a doc typo: `test_batch_bx` 157 / 0 (BX §4's ban on *beast* in
`docs/master.html`, reproduced over the edited file at **0 strays** before it was landed),
`check_fg` 22 / 0 (`CLAUDE.md` 336.63 KiB, under its 340 KiB ceiling, no warning), `check_ec` 24 / 0,
`check_eh` 156 / 0, `check_es` 57 / 0, `check_fr` 25 / 0, `check_da` 43 / 0, `check_dw` 35 / 0,
`check_ed` 18 / 0, `check_ek` 47 / 0, `check_ds` 57 / 0, `check_ff` 68 / 0.

### §5b — The negative controls

**EIGHT INJECTED DEFECTS IN EIGHT ISOLATED COPIES, EACH BITING AND EACH NAMING ITS OWN DEFECT.**
Every copy is an `rsync` of the frozen tree with `config/name` renamed first, so its `user://` can
never reach the player's saves, and the runner carries no `set -e` — a red gate exits non-zero and
would kill the loop silently.

| control | what was injected | tally | the FAIL line that names it |
|---|---|---|---|
| `pouch` | the pouch row's tell deleted | **1021 / 39** | *the pouch row does not say the rune is sitting out* |
| `sheet` | the hero sheet's tell deleted | **1130 / 37** | *the sheet's state column does not read `sits out`* |
| `slot` | the map slot's marker never applied | **1130 / 71** | *the map's slot reads `Ambush`, not the marked name* |
| `slotword` | the face the §2 measurement ruled out, put back | **1130 / 68** | *the slot drawing `Ambush — sits out` is 99 px wide, over the 96-px pitch* |
| `note` | the rune note reworded onto the card's nouns | **1130 / 3** | *the rune note has lost the line "Still worn: the slot stays filled."* |
| `predicate` | `Runes.sits_out` inverted — one token | **1019 / 388** | *ambush does not sit out for a hero holding no engine* |
| `unworn` | the `equipped` guard dropped from the door | **1130 / 1** | *a gated rune sitting in the pouch unequipped is reported as sitting out* |
| `rollcall` | the battle log's tail never appended | **1130 / 3** | *the roll call does not say the rune sits out* |

**`note` AND `slotword` ARE THE TWO THAT MATTER**, because neither is a deletion: `note` is the
edit a later batch "unifying the two sentences" would make, and `slotword` is the face a batch that
did not measure would reach for. Both still render; both red.

### §5c — The control that found a defect in the gate, and the two-armed proof of its repair

**`slotword` FIRST PRINTED THE SAME FAIL LINES AS `slot`, WHICH IS A CONTROL PROVING NOTHING.**
The slot arm read the button by the face it EXPECTED (`_button(mp, "○ " + name)`), so a button
carrying the WRONG face was simply not found — the arm reported the absence and **the width
assertion beside it never executed at all**. A vacuous arm prints exactly like a clean one.

**THE REPAIR IS TO FIND THE BUTTON BY THE DOOR IT OPENS** — every button whose `pressed` is bound
to `_open_rune_panel(seat)` — and then to assert its drawn width **in both arms and on whatever it
drew**, before asking what its face says.

**PROVED WITH BOTH ARMS ON THE SAME INJECTION:**

| gate | `slotword`'s FAIL lines |
|---|---|
| before the repair | *the map's slot does not mark the rune as sitting out* — **byte-identical to `slot`'s** |
| after the repair | *the slot drawing `Ambush — sits out` is 99 px wide, over the 96-px pitch* |

**AND THE LIVE WIDTHS CONFIRM §2's STRING MEASUREMENT INDEPENDENTLY**: the drawn buttons read 99,
108 and 118 px for the three shortest gated names, against the 99 px §2 measured for the narrowest
word form. The gate went from 955 to **1130** checks on the repair.

---

### §5d — The post-run documents, and the needle proof that they moved nothing

**`docs/state.md` AND THIS REPORT ARE WRITTEN AFTER THE VERIFICATION RUN BY RULE** — `check_es`'s
own comment says so, and `state.md` holds the run's figures. Two corrections landed with them: the
Pivot is a stance-switch status rather than a party buff (§2), which `docs/changelog.html` and
`docs/design-notes.md` had stated loosely, and `check_parse`'s baseline row moved 194 → 195 for the
notice the differ raised.

**EXACTLY FIVE FILES DIFFER FROM THE STAMPED TREE**, by md5 over all 422: `baselines.json`,
`docs/changelog.html`, `docs/design-notes.md`, `docs/state.md` and `docs/reports/GX.md`.

**THE RE-RUN POPULATION IS EVERY TARGET THAT READS ONE OF THE FIVE, DERIVED RATHER THAN GUESSED**
— every `*.gd` in the tree whose source names one of those paths: **34 targets**, twenty suites and
fourteen gates. They were re-run through a copy of the runner, because `./run_battery.sh a b`
replaces SUITES only and would have run every gate as well. *(The copy's own `cd "$(dirname "$0")"`
had to be re-pointed at the repo — a runner copy that cd's to itself runs in the wrong tree, which
it did once, loudly.)*

**THIRTY-FOUR CAME BACK AND EXACTLY ONE READS DIFFERENTLY FROM THE ACCEPTANCE RUN, AND IT IS
`check_de`** — 501 / 0 in the full battery against 169 / 6 here, which is the count differ
**refusing a subset run on principle**: *"a subset run cannot certify the tree"*, naming the 98
targets that did not. That refusal is the differ doing its job, not a red. **Every other count and
every other failure count is identical**, which is the proof the documents moved what they were
meant to move and nothing else.

## §6 — FOUND AT GX AND NOT FIXED

- **NINE ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GX head" (the
  rebuild of `07c6b99` the two sanctioned reds were diffed against) and eight named for their control — pouch,
  sheet, slot, slotword, note, predicate, unworn, rollcall. **Each was renamed before anything ran in it**, so its
  `user://` could not reach the player's saves. They can be deleted.
- **`docs/changelog.html` CARRIED THREE UNRESOLVED PLACEHOLDERS IN GW's ENTRY — REPAIRED.** The
  line describing the Shared Hide's three measured swings read *"THIN_SWING, MID_SWING and
  DEEP_SWING more damage from the same seeded blows"*: template tokens that resolve to nothing
  anywhere in the tree. They carry GW's own figures now. **The sweep that found them is the
  population, not a glance**: every `ALL_CAPS_WITH_UNDERSCORES` token in the nine tracked documents
  that resolves to nothing in `scripts/`, `*.gd`, `data/`, the shell scripts or any other document,
  and appears in one document only — **three, all on that one line, and nothing else**. (A narrower
  five-document run of the same sweep also flags `REAL_SAVE`; it is a real identifier from FI's
  gate, named in four documents, and the nine-document population is the right one.) **This is GS's
  twenty-four placeholder rune descriptions arriving in a document instead of in data, and no
  instrument reads for the shape.**
- **`docs/design-notes.md` CARRIES TWO CONVENTIONS AND GV's AND GW's ENTRIES ARE AT THE BOTTOM OF
  IT.** GP through GU sit at the top under `## <Title> (Batch XX) — <date>`; GK, GM, GN, GO, GV and
  GW were appended at the foot under `## Batch XX — <title>`, below 9,000 lines of older notes,
  where a reader following the file's own *"Newest first"* header will not find them. **The two
  instructions genuinely conflict** — that header against `CLAUDE.md`'s working agreement, which
  says *append* — so this is a ruling, not a slip. GX's entry is at the top. **The move was not
  taken**: nothing asserts on position (the three suites that read this file ask only that their own
  batch is named), so it is free whenever it is ruled.
- **A GATE ARM OF GX's OWN WENT VACUOUS, AND A CONTROL FOUND IT** (§5c). The map slot was read by
  the face it expected, so a WRONG face was missed rather than measured and the width assertion
  beside it never ran. Repaired and proved two-armed. **The general shape is worth the note: an arm
  that locates a thing by the value it is about to assert can only ever fail by absence.**
- **GX's FIRST DRAFT SHIPPED A FUNCTION WITH NO CALLER AND A GATE CONSTANT WITH NO USE**, both
  written by this batch and both removed before the verification run: `Run.rune_id_by_name` (the
  screens read the id off the rune instance directly) and `check_gx`'s `NO_LINEAGE`. Found by
  sweeping every name GX declared for a use beyond its own declaration, **with comments stripped so
  prose naming a function did not count as a call**.
- **AND ITS FIRST DRAFT OF THE LOG LINE WAS A FOURTH PHRASING** — *"— sits out, the Rune of the
  Occultist is not equipped"*, the same two facts in different words from the sentence the three
  screens show, which is the exact thing this batch's own rule forbids. The tail is built from
  `Run.rune_sits_out_note`'s first two lines now and `check_gx` §3c asserts it against that
  function, so the log cannot drift from the screens.
- **THE POUCH'S WORST CASE HAS 40 px OF HEADROOM LEFT** (§1c). GT sized the panel for a class's six
  engine rules; GX put a two-line sentence into rows that were one line. It still does not scroll
  and Close never moves — but **a further row of text on that panel is the thing to measure before
  it is added**, not after.
- **`CLAUDE.md` IS AT 336.63 KiB AGAINST ITS 340 KiB CEILING — 3.37 KiB OF HEADROOM.** GX added
  1.62 KiB by extending GT's sits-out block rather than opening a second one, and `check_fg` §2
  reads it under the ceiling with no warning. **The largest single-batch growth on record is
  +8.10 KiB, which is more than the headroom is**, and the file's own FU §1 / GR §2 block says the
  next batch at this ceiling is not looking for a seam: both remaining moves are the designer's.
  Raised here rather than at the wall.
