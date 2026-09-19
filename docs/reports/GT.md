# Batch GT — The pouch never traps the player, three cards at the baseline, and a card that sits out

*Branch `class-merge`, from `90a0450` (GS). `main` is untouched. **IMPLEMENT ONLY.** Three items the designer ruled:
the rune pouch could strand the player below the screen; Fireball, Frostbolt and Aimed Shot came back cheaper and
quicker than the kit card beside them; and a card drafted under an engine stayed in hand, dead, once the engine was
dropped. No engine, kit or pool changed, and no card was authored.*

## NEEDS A RULING

**All four are player-visible.** Everything else is in `docs/state.md`'s queue.

1. **FIREBALL'S AND FROSTBOLT'S MOVES ARE LARGE — AND NOT BECAUSE THEY WERE MISPRICED BEFORE THE MERGE** (§2b). Each
   went from free with no cooldown to **15 Mana and cooldown 2**, Magic Missiles' price; Aimed Shot went from 20 and 1
   to **25 and 2**, Powershot's. The brief read a large move as a card mispriced before the merge. **These two were
   priced right for the job they had**: until GS each was a lineage's basic attack in slot 0, and a basic is free by
   construction. GS put them in the draft as they stood, so the size of the move measures the change of job the merge
   gave them. **What was built is parity on both axes** — the baseline read off the kit card. The smallest move that
   ends EB's inversion is one axis, and it is priced in §2b.
2. **A CARD THAT SITS OUT KEEPS ITS SLOT** (§3d). The brief asked which. **It stays counted — the same as GM §2's
   "the slot a bound card held stays counted"** — because the card is still carried; benching it on the map frees the
   slot, free and reversible. Freeing it on its own would let the player fill it, and the engine's return would then
   leave the kit one over its cap. What happens then is the ruling this alternative needs.
3. **BATTLE POISE AND SHATTERPOINT ARE A SEPARATE CASE** (§3e). Both are **cards, not runes**, and both cast and do their
   own work with no engine: driven on a Warrior holding none, Shatterpoint breaks its target either way and adds its
   free Overpower only with Overpower carried (68 damage against 16), and Battle Poise, reached through a drafted
   Feint, pivots on a parry only with Guard Change carried. **A card whose second clause needs another card is GM's
   half-working group, not a card that cannot be cast** — sitting either out would take a working card away. Paying the
   clause to a hero who does not own the card would change what the card gives, and is the designer's.
4. **THE SAME SHAPE ON THREE MORE RETURNING CARDS, OUTSIDE EB's CONTROL** (§2c). Under EB's control — same role, same
   initiative — only the three were inverted, and none is now. Dropping the role control, the other two former basics
   are cheaper and shorter than a kit card at the same initiative: **Arcane Explosion** against Magic Missiles and
   **Shadowrend** against Ministration. Dropping the initiative control too, **Guard Change** (0 Rage, cooldown 1,
   initiative 1.5) is cheaper, shorter and quicker than Crushing Blow and Pommel Strike. Not retuned; the ruling named
   three.

## THE SHORT VERSION

- **The pouch's Close button is pinned** (§1). Every engine row, note and rune row sits in one scroller; Close sits
  below it, at y 658–696 in all **176** configurations `check_gt` opens — each engine alone, every pair of one class's
  six, each class's six held at once, each with the pouch empty and with an ordinary rune. On GS's layout, Close was
  wholly off the 720-pixel screen for **4 of 24 alone, 60 of 60 pairs and 4 of 4 sixes** with the pouch empty (y 1142
  at worst). **Nothing scrolls in any of the 176**: the longest, a Hunter holding all six, is 431 pixels in a
  583-pixel list.
- **The Peddler had the same cause, and one fix shape covers both** (§1c). Its offers stack at their own heights in
  one scroller that ends above Leave. With every class's longest engine rule, all four Buy buttons had been unusable;
  now none overlaps another and every one is bought through its own button.
- **Fireball and Frostbolt cost 15 Mana with cooldown 2, Aimed Shot 25 with cooldown 2** (§2) — the kit card each
  undercut. Nothing else of theirs moved. `check_eb` §1 reads no crossover.
- **A card that cannot be cast without its engine sits out while the engine is gone** (§3). The door was asked about
  all **204** cards a hero can earn: **17** cannot be cast without their engine and are rows of `Classes.SITS_OUT`;
  ten more are refused bare but open with a card or a board and are not. The card is kept, carried and counted; the
  battle and the hero sheet ask one door; the sheet and the Kit panel say why.
- **The brief's §4 rulings are recorded**: Razor Ice, Divine Shield and Hex of Ruin say ruled where they said
  PROPOSED; Bloodlust stays outside the slot count; the four basic changes stand.
- **Verification:** the acceptance battery is **GREEN — 117 targets in 56 minutes on a frozen tree, `check_de` at
  485 / 0 / 0** (GS's 481 and four for `check_gt`'s row) and `check_gt` at 3,157 / 0. The only reds are the two standing
  sanctioned ones, their FAIL lines byte-identical to HEAD's. **The unmodified battery ran against GT's code first**:
  113 of 116 targets read as at GS, and the three that moved were `check_eb` and `check_gm` — both instruments pinning
  what the rulings changed, both repaired to intent — and `check_de` for them.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md` whole, `docs/state.md`'s WHERE block and queue, `docs/reports/GS.md`,
GM §2, and the code the brief names — `map_screen._open_rune_panel`, `shop_screen._draw_screen`, `check_eb`,
`basic_override_ability`, `ENGINE_READ`, the battle spawn and the usability door.

| The brief says | Verdict | What the repo says |
|---|---|---|
| GS found Bloodlust sits outside the slot count, and the rule was right | Held | GS ruling 2; recorded as ruled (§4 of the brief). |
| the pouch's only Close button draws off the bottom for four runes held alone — Cryomancer, Devout, Occultist, Beastmaster | Held | Measured on GS's code, pouch empty: Close tops 757, 757, 737, 797. |
| it predates GS — it was five runes before | Held | GS §3c. |
| engines are droppable and swappable, so the pouch is opened constantly | Held | `Run.toggle_engine` is the pouch's door. |
| **a hero holds two, so the pouch shows two rules at once, and nobody has measured that case** | **Pairs: held and unmeasured. "Holds two": not held** | A hero SLOTS two and can HOLD all six of his class's engine runes: `Run.hold_rune` keeps one past the two slots, unslotted, and `Runes.eligible_ids` offers every one he does not hold. The pouch lists every held engine with its rule. **The longest combination is six rules, not two** — measured with the pairs. |
| the Peddler spills — long rules overflow into the next hero's offer; same cause | **Held, and worse than reported** | With every class's longest engine rule, **all four Buy buttons were unusable**: three drawn under the next offer, the fourth below the screen at y 785. With the shortest, one of four covered. Same cause; one fix shape covers both (§1c). |
| Fireball, Frostbolt and Aimed Shot are cheaper and faster than the kit | Held | `check_eb` §1 named them at GS. |
| EB measured 17 comparable pairs, 13 favouring the core | Held | EA §3; `check_eb` §1 reads 30 pairs, 21 favouring, today. |
| these three are among the first cards a player meets | Held in effect | All three are offered to any hero of the class from the first draft; none reads an engine. |
| the correction should be small; a large move means a card mispriced before the merge | **Large for two, and the inference does not hold for them** | NEEDS A RULING 1. |
| **GS found three; it did not sweep for the shape** | **Not held** | `check_eb` §1 walks every shelf card against every protected core of its lineage, under EB's control, every battery, and read exactly three at GS. What no instrument swept is the shape OUTSIDE that control; GT did (§2c). |
| Death Ray, Resurrection or Hymn of Hope, drafted and the engine dropped, leave a card he can never cast | **Held, and it is seventeen cards, not three** | §3a. GS §6 named the three it returned to the pool; the rest were GM's ruling-1 group. |
| GM ruled this shape for the engine's OWN cards | Held | GM §2; `ENGINE_BOUND` deleted at GS. |
| GM left the slot half unbuilt — "a dropped card's ability slot stays counted" | Held in substance | GM §2c: *"the slot a bound card held stays counted"*. |
| **Battle Poise's free Guard Change and Shatterpoint's free Overpower … a rune granting a free cast** | **Not runes: both are cards** | Battle Poise is a Swordmaster draft card, Shatterpoint a Swordmaster zone-boss card. The brief's distinction still holds (§3e). |
| back up the four saves | **Three exist** | `profile.json`, `relics.json`, `settings.cfg`; no run was in progress, so no `run_save.bin` (§5a). |
| the sim bot cannot use most of the 29, so a sim measures a hero who does not use 26 of his pool | Not re-derived | Queued, as ruled. |
| "and the stamp" | `docs/master.html`'s stamp and `docs/state.md`'s *Last rewritten* | Player-visible batch; the working agreement's step 1. |

## §1 — THE POUCH NEVER TRAPS THE PLAYER

### §1a — What trapped it

`map_screen._open_rune_panel` drew a `PanelContainer` from y 120 holding, top to bottom, the title, the ENGINES heading,
**one row per held engine rune** (its rule in a 520-pixel autowrapped label), a two-line note when the pouch is empty,
**a 380-pixel rune scroller** and Close. Every row above the scroller is as tall as its rule, and the panel grows to
hold them, so a long rule pushes Close down; there is no other way out of the overlay.

**A hero holds more than two engine runes.** `Run.hold_rune` slots a rune while a slot is free and keeps the rest; the
offer never stops rolling the class's engine runes he does not hold. The pouch lists every held one.

### §1b — The fix, and the measurement

**A fixed panel** — x 140, y 24, 1000 × 672 (`POUCH_RECT`) — holds the title, **one scroller** that fills everything
between it and Close, and **Close below the scroller**. Every engine row, the notes and the rune rows are in the
scroller; the labels are 860 pixels wide (`POUCH_TEXT_W`), at the size they always were (12). **Nothing was shrunk or
cut.** A rune pouch with many ordinary runes scrolls, as its rune list always did; now the engines scroll with them.

Measured by drawing the pouch (`check_gt` §1, and a probe run on GS's code for the before):

| Configuration (88 with the pouch empty, 88 with an ordinary rune) | GS's layout: Close | GT: Close | GT: the longest, its rules / the list in the 583-pixel scroller |
|---|---|---|---|
| One engine alone (24) | wholly off **4**, partly **18**, on 2 (worst y 797, Beastmaster) | y 658–696 in all | Beastmaster — 97 / 186 |
| **A pair of one class's engines (60)** | **wholly off 60** (worst y 882, Beastmaster + Sharpshooter) | y 658–696 in all | Beastmaster + Sharpshooter — 154 / 251 |
| A class's six held (4) | wholly off **4** (worst y 1142) | y 658–696 in all | the Hunter's six — 302 / 431 |
| The same 88 with one ordinary rune beside them | off 38, partly 30, on 20 | y 658–696 in all | the Hunter's six — 406 |

**Close was pressed in all 176 and closed the pouch every time**, and Unequip and Equip — each re-opens the pouch —
put it back where it was.

### §1c — The Peddler: the same cause, and one fix shape covers both

`shop_screen._draw_screen` laid each hero's offer 130 pixels below the last (`162 + i * 130`), a minimum of 118 tall,
and drew each later panel over the one before. Measured on GS's code with four offers, one per hero:

| Deal | GS's layout | GT |
|---|---|---|
| every seat's longest ordinary rune | 0 of 4 Buy buttons covered | stacks 454 px in the 470 px column — **unscrolled** |
| every class's shortest engine rule | **1 of 4 covered** (the Cleric's, under the Hunter's offer) | 500 px — scrolls |
| every class's longest engine rule | **4 of 4 unusable** — three under the next offer, the fourth at y 785 | 799 px — scrolls |

**The cause is the pouch's** — a stack whose height is its text, laid at fixed positions — **and so is the fix**: the
offers stack at their own heights inside one scroller (x 620–1260, y 162–632), which ends above Leave; Leave stays at
(530, 640), outside it. The column is wider, to the screen's right margin, which is what lets four ordinary offers fit
unscrolled. `check_gt` §2 asserts no offer overlaps another, every Buy is inside the scroller and can be scrolled wholly
into view, the column ends above Leave, and every offer is bought through its own button.

## §2 — THREE CARDS AT THE BASELINE

### §2a — The baseline, derived

EB's method, `check_eb` §1's pairing: a draft card and a protected core of the same lineage, in the same role
(derived from the fields), at the same initiative, neither capped. **The baseline is the core's cost and cooldown at
that initiative**, and the ruling retunes each card to it:

| Card | GS | Priced against | GT | Moved |
|---|---|---|---|---|
| Fireball | 0 Mana, cooldown 0, initiative 2.0 | **Magic Missiles** — 15, cooldown 2, 2.0 (the Mage kit) | **15 Mana, cooldown 2** | +15 Mana, +2 cooldown |
| Frostbolt | 0 Mana, cooldown 0, initiative 2.0 | **Magic Missiles** | **15 Mana, cooldown 2** | +15 Mana, +2 cooldown |
| Aimed Shot | 20 Mana, cooldown 1, initiative 3.0 | **Powershot** — 25, cooldown 2, 3.0 (the Hunter kit) | **25 Mana, cooldown 2** | +5 Mana, +1 cooldown |

Damage, Break damage, initiative, the status laid and the Perfect did not move (`check_gt` §4 pins each). Against
Magic Bolt, the Mage's basic at the same initiative, Fireball and Frostbolt are now dearer on both axes, which is EB's
intended direction.

### §2b — The size of the move, and the alternative

**Fireball and Frostbolt moved from free to Magic Missiles' price.** The brief expected a large move to mean a card
mispriced before the merge; these two were not. Until GS each was a lineage's basic in slot 0, resolving at a fixed
Good, and a basic is free by construction. GS moved them into the pool unchanged, so the move measures the job they
gained. **Aimed Shot**, always a costed card, moved by 5 Mana and one turn.

**The one-axis alternative**, which also ends EB's inversion (an inversion needs cheaper AND shorter): Fireball and
Frostbolt **free with cooldown 2**, or **15 Mana with cooldown 0**; Aimed Shot **20 Mana with cooldown 2**, or **25 with
cooldown 1**. Each leaves the card cheaper than its kit card on one axis, which EB's 13-of-17 allows.

### §2c — The other 26, swept for the shape

Each of the 29 returning cards against every card of its class kit, the class basic and its lineage's enabler, on cost,
cooldown and initiative, before and after GT:

| Shape | Before GT | After GT |
|---|---|---|
| **EB's inversion** — same role, same initiative, cheaper AND shorter | 3: Fireball, Frostbolt (Magic Missiles), Aimed Shot (Powershot) | **0** |
| Same initiative, **another role**, cheaper and shorter | 2: **Arcane Explosion** < Magic Missiles; **Shadowrend** < Ministration | 2, the same |
| **Lower** initiative, any role, cheaper and shorter | 8 | 5: **Guard Change** < Crushing Blow and < Pommel Strike; Frostbolt < Razor Ice; Arcane Explosion < Magic Burst; Shadowrend < Hex of Ruin |

EB recorded why the uncontrolled form is not a property (a cantrip beside a nuke). **The two former basics are the ones
worth a ruling** — the same free card as Fireball and Frostbolt, sitting beside a costed kit card at the same
initiative — and Guard Change is a stance swap with 15 Break damage beside the Warrior's costed strikes. NEEDS A
RULING 4.

## §3 — A CARD THAT CANNOT BE CAST WITHOUT ITS ENGINE SITS OUT

### §3a — The population, derived at the door

Every card a hero of each class can earn — the class draft pool and every lineage's zone-boss pool, **204** — was asked
`battle._ability_usable` on a hero holding **no** engine, on a board dressed to allow everything an engine does not give
(a bottomless bar, no cooldowns, every enemy burning, chilled and poisoned at half health, a fallen ally for
Resurrection). **27 were refused.** Each refusal was then tried again through every route a card or a board gives with
still no engine:

| Refused bare | Opens with no engine by | Sits out? |
|---|---|---|
| Battle Poise, Counter Time | a drafted Guard Change turns the guard Defensive | no |
| Reprisal | a heal landed first | no |
| Execute | an enemy under 20% health, or Broken | no |
| Kill Command, Twin Hunt, Savage Sweep, Ghostpack, Bestial Wrath, Spirit Bond | a companion from an earned Call the Wilds | no |
| **Winter's Toll, Rimebinding, Cryoclasm, Shatter** | nothing — a Glacial Hold is laid only under the engine | **yes (Glacial Hold)** |
| **Arcane Bolt, Unmaking, Death Ray, Stabilize** | nothing — only the engine installs Resonance | **yes (Runaway Resonance)** |
| **Divine Plea, Hymn of Hope, Resurrection** | nothing — only the engine installs Mercy | **yes (Mercy)** |
| **Blessing of the Faithful, Aegis Reversal** | nothing — no Faith or divine barrier without it | **yes (Conviction)** |
| **Transference, Requiem** | nothing — no Ruin is laid without it | **yes (Wrath of the Old Gods)** |
| **Unleash, Primal Surge** | nothing — no Loyalty is gained without it | **yes (Pack Bond)** |

**Every one of the seventeen opens with its engine held** (driven, `check_gt` §3d). Fifteen are rows of `ENGINE_READ`
and name the same engine there; **Stabilize and Primal Surge are zone-boss cards `ENGINE_READ` never swept**. The ten
that open by a route are conditional on a card or a board, GP's Battle Poise shape, and always fight.

### §3b — What was built

- **`Classes.SITS_OUT`** — the seventeen, each with its engine and its `why` — with `sits_out_engine(card)` and
  `sits_out(card, engines)`.
- **`Run.seated_ability_names(member)`** — the loadout less every card that sits out for the engines he has slotted:
  **the one door**. The battle spawn and the hero sheet ask it. `Run.sitting_out_names(member)` is its complement, and
  `Run.sits_out_note(card)` the one sentence two screens show.
- **The hero sheet** draws a card that sits out as its own greyed chip, *"Death Ray — sits out"*, its tooltip naming the
  rune; **the Kit panel on the map** shows the carried row in amber with the same sentence in place of the card's text.

### §3c — Where the state lives, and the re-slotted engine

**Nothing new is written.** The card stays in `bm_abilities` (owned — never offered again) and `bm_equipped`
(carried); the only state that decides whether it fights is the engine rune's own `equipped` flag in
`member["engines"]`, which the pouch's door writes and the save carries. **Driven for every engine** (`check_gt` §3e):
taken through the draft door (the boss pick's writer for Stabilize and Primal Surge) under the engine, seated; the
engine dropped through `Run.toggle_engine` — the rune kept, the pool and the loadout unchanged, the card left out of a
fight whose real turn loop then ran eight turns on autoplay; the hero sheet and the Kit panel saying why; the save
round-tripped with all of it; the engine slotted again through the same door — **seated again**.

### §3d — The slot

**It stays counted.** A card that sits out is still carried, so `Run.ability_slots_used` counts it — GM §2c's shape for
a dropped bound card: *"the slot a bound card held stays counted"*. **Sitting out is not benching**: benching it on the
map frees the slot, and carrying it again takes it back, both driven. Freeing the slot on its own would let the player
fill it, and the engine's return would put the kit one over its cap. NEEDS A RULING 2.

### §3e — Battle Poise and Shatterpoint

Neither is in the ruling. **Both are cards**, and the census found both castable with no engine: Battle Poise needs the
Defensive guard, which a drafted swap reaches; Shatterpoint needs nothing. Their second clauses name another card:

| Card | Its own work, no engine | The clause | Driven, the named card not carried | Carried |
|---|---|---|---|---|
| Shatterpoint | 40 Break damage, breaks the target | a free Overpower when it breaks | breaks it, **16** damage | breaks it, **68** damage — the free Overpower |
| Battle Poise | a parry takes a turn off every cooldown | once a turn, a parry buys a free Guard Change | the stance stays Defensive | **pivots to Aggressive** |

`battle.gd` finds the card on the hero's bar (`_find_ability`). **A card that half-works is GM's untouched group**, and
sitting either out would take away a card that works. NEEDS A RULING 3.

## §4 — WHAT DID NOT MOVE

No engine, kit or pool; no card authored; no magnitude but the three prices. The enablers, the slot count and the
basics stand as ruled — the three `PROTECTED_CORES` rows now say *derived at GS, ruled at GT* where they said
*PROPOSED, GS*, and `check_gs`'s copy of the table says *ruled at GT*. The four engine texts naming cards that no longer travel and the sim
bot's reach stay queued.

## §5 — VERIFICATION

### §5a — The saves

The player's save files were copied to `save-backups/GT-20260919-115424/` before anything ran and verified by md5:
`profile.json` (0969096b…), `relics.json` (fdc12ffa…) and `settings.cfg` (0c1b39c3…) — byte for byte what GS's backup
holds, so nothing has written them since. **The fourth, `run_save.bin`, does not exist**: no run was in progress. Both
control copies were renamed (`config/name`) before anything ran in them, so neither `user://` could reach the player's
folder; `check_gt` §5 and `check_gs` §5 read the three files byte for byte every run. **Hashed again after the
acceptance run: all three byte-identical to the backup, and `run_save.bin` still absent.** The process table held no
Godot process when the batch ended.

### §5b — The unmodified battery against the new tree

Before a gate was edited, the whole battery ran unmodified against GT's code, on a tree stamped by md5 before and after
(574 files by absolute path, untracked included — identical): **116 targets in 56 minutes. 113 read exactly what GS's
acceptance run read**, every suite among them — including every suite and gate that casts Fireball, Frostbolt or Aimed
Shot by name. The three that moved:

| Target | GS's acceptance | Recon | Cause |
|---|---|---|---|
| `check_eb` | 19 / 0 | **16 / 4** | Its three named crossovers are gone because the cards were retuned (§2) — three *"known crossover is gone"* lines and *"0 crossovers against 3 named"*. Predicted. |
| `check_gm` | 148 / 0 | **148 / 5** | §2 pinned GS's found-and-not-fixed state as current behaviour — *"with no engine, arcanist's Death Ray stays on the bar — drafted — and the door refuses it"*, the same for Hymn of Hope and Resurrection, and the two bars that held them. The ruling takes all three off the bar. Not predicted; an instrument, not a game defect. |
| `check_de` | 481 / 0 | 481 / 3 | The two above. |

**Not one `Parse Error` or `SCRIPT ERROR` line in any target's stream**, grepped rather than tallied. The two standing
sanctioned reds read as they did — `check_cm_live` 13 / 4 and `check_gj` §4's *"the card says +169 gold and the purse
moved 189"* — **with FAIL lines byte-identical to GS's acceptance run, which was HEAD's code.**

### §5c — The repairs, and each one's second arm

**The project's one rule for a repair: to intent, never deleted, never loosened.**

| Target | Recon | Now | HEAD's row | What changed |
|---|---|---|---|---|
| `check_eb` | 16 / 4 | **16 / 0** | 19 | The named list is empty and any inversion reds; `RETUNED` asserts each of the three gone **because** it now costs what its kit card costs, with its cooldown. 19 → 16: the two loops over the named list walk none (−6), `RETUNED` walks three (+3). **Armed with Fireball free again: 17 / 3**, naming the crossover and the broken tie. |
| `check_gm` | 148 / 5 | **148 / 0** | 148 | §2's bar is the kit and the drafted cards **less what sits out** for the engines held, and each of the three is asserted **kept, off the bar, and refused by the door** — the reason it sits out. **Armed with the spawn reading the whole loadout — GS's behaviour: 148 / 5**, naming the three. |
| `check_gs` | 730 / 0 | 730 / 0 | 730 | Comments only — the three derived `MINIMUM` rows say *ruled at GT* — proved by a comment-stripped diff. |
| `check_parse` | 190 / 0 | **191 / 0** | 190 | `check_gt` joined the battery. |

### §5d — `check_gt`, and its controls

**3,157 checks** — §1 the 176 pouch configurations and the two toggles, §2 the three Peddler deals, §3 the table,
the census of 204, the four routes, the six engines held and the six drives, §4 the prices, §5 the files. Fourteen defects were injected one at a time into an isolated copy, restored by
copy after each and compared byte for byte after the last (465 files, identical); **the clean arm read 3,157 / 0, and
every injection bit with a FAIL line naming its defect**:

| Injected | Read | The FAIL line it printed |
|---|---|---|
| **HEAD's own `_open_rune_panel`** | 3,157 / 666 | *Close is not wholly on the 1280 x 720 screen*, *Close moved*, *the rule is drawn outside the scroller* |
| Close put inside the scroller | 3,157 / 335 | *Close is inside a scroller, where text can carry it off* |
| The engine rows outside the scroller | 3,157 / 336 | *the rule is drawn outside the scroller, where it can push Close* |
| The rules drawn at size 9 | 3,157 / 336 | *drawn at size 9, not 12 — the text was shrunk* |
| The Peddler at HEAD's fixed pitch | 3,157 / 20 | *offers 2 and 3 overlap* (shortest rules), *offers 0 and 1 … 2 and 3 overlap* (longest), *Buy is outside the column's scroller* |
| Stabilize's row removed | 3,157 / 7 | *the table says* — nothing; *with the engine dropped the fight still seats Stabilize* |
| A row added for Battle Poise | 3,158 / 1 | *Battle Poise sits out, and no ruling named it* |
| The spawn reading the whole loadout | 3,174 / 17 | *with the engine dropped the fight still seats Winter's Toll* — and each of the seventeen |
| The hero sheet reading the whole loadout | 3,157 / 17 | *the hero sheet also shows Winter's Toll as a seated card* |
| The slot freed while a card sits out | 3,157 / 18 | *the slot count moved from 8 to 4 — a card that sits out keeps its slot* |
| The drop destroying the cards | 3,157 / 41 | *dropping the engine changed what the hero owns* |
| The Kit panel saying nothing | 3,157 / 17 | *the Kit panel does not say Winter's Toll sits out, or which rune brings it back* |
| Fireball free again | 3,157 / 1 | *Fireball costs 0, cooldown 0, initiative 2.0 — the baseline is Magic Missiles's 15, 2, 2.0* |
| Aimed Shot's damage 46 | 3,157 / 1 | *something of Aimed Shot besides its cost and cooldown moved* |

**The first pass found two instrument faults, both fixed before the second**: one assertion carried three properties,
so the shrunk-text control and the outside-the-scroller control printed the same line; and the Peddler's panel walk
read only the new column, so HEAD's fixed pitch read as *"0 panels"* rather than as the overlap it is. **HEAD's code
cannot run this gate** — it calls `Classes.SITS_OUT`, `Run.seated_ability_names` and the new layout's shape — so the
HEAD arms are HEAD's pouch function and HEAD's pitch inside GT's code.

### §5e — The pre-pass and the acceptance battery

**A full pre-pass came first**, over the landed tree with every document, instrument and baseline row in place — the
rows written from standalone readings beforehand: **117 targets in 56 minutes, green on its first run, `check_de` at
485 / 0 / 0**, on a tree stamped identical before and after (575 files). Against the recon it moved exactly the rows GT
moved — `check_eb`, `check_gm`, `check_parse`, `check_gt` and `check_de` — and two counts that move on their own:
**`test_batch_an`** 6,054 → 6,056, which read 6,055, 6,059 and 6,054 in three standalone runs on the unchanged tree (its
band is 6,049–6,066), and **`test_batch_bk`** 130 → 129, whose count follows the map topology it rolls (band 128–130,
fourteen readings). The two sanctioned reds' FAIL lines were byte-identical to HEAD's again. **Three edits followed it,
before the acceptance run**: `check_gt`'s comment on what `_turns_taken` counts (every unit's turn, not the hero's), the
sits-out sentence reworded to carry no pronoun, and the three moved rows' observation counts — each re-checked
standalone (`check_ed` 18 / 0, the manifest current, `check_parse` 191 / 0, `check_gt` 3,157 / 0).

**The acceptance battery, on the frozen tree** — stamped by md5 before and after, 575 files by absolute path, untracked
included, identical: **117 targets in 56 minutes (14:34–15:31), `BATTERY_EXIT` 0, `check_de` at 485 / 0 / 0**, `check_gt`
at **3,157 / 0**, and the run harness's three gates PASS at 22 / 382 / 8. Against the pre-pass, 116 targets read the same
and `test_batch_bk` read 130, the other end of its known spread. **The only reds are the two sanctioned ones** —
`check_cm_live` 13 / 4 and `check_gj` §4 at +169 / +189 — **their FAIL lines byte-identical to GS's acceptance run,
which was HEAD's code.** Not one `Parse Error` or `SCRIPT ERROR` line in any target's stream, grepped rather than
tallied.

**Sizes, as `check_fg` printed them:** `CLAUDE.md` 331,327 → **335,070 B = 327.22 KiB**, 12.78 KiB under its 340 KiB
ceiling; `docs/changelog.html` 382,364 B, 17,636 B under its bar, GT's entry 3,432 B. **The pin manifest** holds the
same 1,491 pins; three of `check_gm`'s moved their gate-side locator with the lines inserted above them. `check_ed` read
18 / 0 against HEAD's manifest before it was regenerated, and `check_ec` 24 / 0 with the documents landed.

## §6 — FOUND AND NOT FIXED

- **A ZONE BOSS CAN OFFER A CARD THAT WILL SIT OUT.** `Run.roll_spec_ability_offer` draws the hero's lineage pool with
  no engine filter, so an Arcanist who dropped Resonance can be offered Stabilize. The draft never offers one
  (`Classes.offerable`); the boss pools were never merged or gated (GP).
- **ENGINE-HEAVY PEDDLER DEALS SCROLL** (§1c): 500 and 799 pixels in a 470-pixel column. Every offer is reachable.
- **CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GT ctl" and "Dawn of Decay GT
  probe", each renamed before anything ran in it. They can be deleted.

## §7 — FILES

- **Game code (6):** `scripts/map_screen.gd` (the pouch; the Kit panel's note), `shop_screen.gd` (the Peddler's column),
  `classes.gd` (the three prices; `SITS_OUT`; the ruled markers), `run_state.gd` (`seated_ability_names`,
  `sitting_out_names`, `sits_out_note`), `battle.gd` (the spawn asks the door), `party_screen.gd` (the sheet asks the
  door and draws a card that sits out).
- **New gate:** `check_gt.gd`, and `run_battery.sh`'s GATES.
- **Repaired to intent (2):** `check_eb`, `check_gm`. **Comments only (1):** `check_gs`.
- **Instrument data:** `baselines.json` (`check_gt` new at 3,157; `check_parse` 190 → 191; `check_eb` 19 → 16) and
  `pin-manifest.json` (three locators).
- **Documents:** `CLAUDE.md` (two new standing rules — the control a player needs to leave, and the card that sits out
  — and EG's questions, GK's bound-card bullet and EB's crossovers corrected), `docs/master.html` (and its stamp),
  `docs/state.md`, `docs/changelog.html`, `docs/design-notes.md`, and this report (new).
- **Not edited:** `data/*.json`; `save-backups/`, which stays uncommitted.
