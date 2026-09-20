# Batch GV — The runes that read an engine

*Branch `class-merge`, from `4a39839` (GU). `main` is untouched. **IMPLEMENT ONLY.** GP gated the CARDS at the offer
door — a card that reads an engine is offered only to a hero holding it — and the runes were never re-read. GV reads
all sixty live ordinary runes at their read sites, drives every one of them with its engine equipped and with it merely
owned, and offers the thirty-five that cannot pay without it only while it is equipped. No rune was retuned,
re-authored or retired; no engine, kit, pool, card or node moved.*

## NEEDS A RULING

**Four of the five are player-visible.** Everything else is in `docs/state.md`'s queue.

1. **A QUEUED ROW SITS OUT OF A CACHE'S ANSWER RATHER THAN BEING REPAIRED AWAY — THE BATCH'S CALL** (§4b). FD §1's rule
   is that an offer frozen at the drop is re-asked at the answer and **the repair is written back**, and that is right
   for a candidate that can only get worse: a retired rune and a rune he already owns can never come back. **An
   unequipped engine is the player's own reversible choice**, so a row stays in the stored triple, is filtered out of
   the answer while the engine is out, and is offered again the moment it is back; `map_screen._pick_rune` indexes the
   list the buttons were built from. **The alternative is FD's literal form** — drop the row, top the triple up, store
   that — under which one toggle before answering a cache costs it those runes for good and can spend the pick on
   nothing.
2. **THE GATE READS WHAT HE HAS EQUIPPED, AND IT IS THE ONLY READING THAT GATES ANYTHING** (§2). A spec rune is offered
   by LINEAGE, the lineage is the engine taken at class selection, and nothing in the game sells or discards an engine
   rune — **so every hero who can be offered a row owns its engine for the whole run**, and a gate on ownership would
   withhold nothing at all. What the brief asked to be told, measured: a hero who unequips his engine is sold different
   runes at the Peddler (rolled as he stands; re-equipping before the visit restores them), **a cache or bargain ROLLED
   while it was out never contains its rows**, and an elite fought with it out drops a cache without them — which is
   the reading the card draft already takes at a victory.
3. **A BOUGHT RUNE WHOSE ENGINE IS DROPPED KEEPS ITS SLOT AND PAYS NOTHING, AND NOTHING SAYS SO** (§5). GT ruled it for
   a CARD — it sits out and returns. A rune is bought with gold, so the brief asked for a report and no ruling: nothing
   was built. It stays equipped in one of the three ordinary slots, pays nothing (measured, §1), and no screen says
   why. **Two are worse than nothing**: the Martyr still refuses every ally's heal and Thin Blood still stops his own
   poison biting. Four options are priced in §5 and none is taken.
4. **THE SHARED HIDE PAYS NOBODY ANYTHING, WITH ITS ENGINE OR WITHOUT IT** (§3c). The rune's field lands on the HUNTER
   and `_shared_hide_mult` reads the COMPANION, which never receives it — so a 100g rune multiplies a companion's blow
   by exactly 1.0000 for every hero who has ever bought it. **Not repaired**: wiring it moves a magnitude, which is the
   designer's (CQ §6). `check_gv` §1 asserts it dead in BOTH arms, so the day it is wired the gate says so and asks for
   it to be sorted again.
5. **THE RUNE LAYER HAS THE NARROWNESS THE CARD LAYER AVOIDED** (§2). A hero who unequips his engine is offered **none**
   of his lineage's five runes on four lineages of twelve, and **a hero holding two engines is offered nothing of the
   second engine's lineage** — a rune's scope is still the lineage while the card pools merged at GP. Whether the rune
   pools merge the way the draft pools did is the designer's; nothing here assumes it.

## THE SHORT VERSION

- **Thirty-five of the sixty live ordinary runes cannot pay without their engine** (§1), and each is offered only while
  that engine is equipped: `Runes.ENGINE_READ` is the table, `Runes.offerable` the one answer, `Runes.eligible_ids` the
  one roll door and `Run.rune_choice` the answer door.
- **The other twenty-five all move something without their engine and none is gated** — five HALF-work, eleven ride a
  card, four a status any card lays, one the stance every Warrior has, three nothing at all, and one pays nobody
  anything.
- **The population was derived at the read site and driven both ways** (§1): every payload field traced to every line
  that reads it with its guard chain, then every rune worn on four boards — its engine equipped or merely owned, the
  rune worn or not, the same dice. **35 of 35 rows pay equipped and move nothing owned; 24 of 24 others move something
  owned.**
- **FP's 43 was the game at FP** (§3a): thirty-three of it are rows, **ten are not** (four Beastmaster runes a Call the
  Wilds companion answers, two stance runes any swap card answers, and four whose main effect reads no engine), and
  **two it did not count are** (Grace and Open Hand, whose cards are priced in Mercy since GS §1).
- **The doors, driven** (§4): the Peddler's own screen, the elite cache rolled equipped and answered unequipped, the
  bargain's rune reward, the event verb — and **four whole runs through the real screens**: three with every engine
  unequipped (**148 offers, not one a row**) and one with two engines apiece (**11 rows among 69**).
- **What a hero with no engine is offered, per lineage** (§2): Arcanist, Holy, Occultist and Sharpshooter **0 of 5**;
  Devout 1 of 4; Warden, Swordmaster, Pyromancer and Survivalist 3; Berserker and Cryomancer 4; Beastmaster 4 of 6.
- **Four gates were repaired to intent** (§6b), each for the same reason: a hand-built lineage hero carrying no engine
  rune, which GK's rule already forbids.
- **Verification:** **119 targets, `BATTERY_EXIT` 0, `check_de` 493 / 0 / 0**, on a tree stamped by md5 before and after (588 files, identical), with no `Parse Error` or `SCRIPT ERROR` in any of the 119 logs and the two standing sanctioned reds unchanged in their text. **Ten injected defects, one per isolated copy, each bit and each named its own defect** (§6c), and the player's four saves are byte-identical to the backup taken before any Godot process ran.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md` whole, `docs/state.md`'s WHERE block and queue, `docs/reports/GU.md`,
`docs/reports/GM.md` §1, `docs/merge-recon.html` §4a, `docs/ways-of-working.md`, and the code the brief names —
`Runes.eligible_ids` and every caller, `Run.rune_choice`, `Classes.ENGINE_READ` and `SITS_OUT`, and the read site of
every field the sixty runes write.

| The brief says | Verdict | What the repo says |
|---|---|---|
| GP gated the cards — a card that reads an engine is offered only to a holder | Held | `Classes.offerable`, read off `Runes.held_engines` (the EQUIPPED set). |
| the runes were never re-read | Held | `eligible_ids` asked scope, the pouch, `requires_ability` and retirement, and no engine. GM §1 named ten and gated none. |
| FP measured 43 of 60 runes reading the engine beside them | Held as FP's | `docs/merge-recon.html` §4a: 43 engine / 2 enabler / 8 spec-status / 7 neither. §3a re-derives it against today's game. |
| that was before GK made engines droppable | Held | GK built the two slots and the drop; before it a lineage always had its engine. |
| **a Deepening Hex offered to a Cleric without the Occultist rune** | **Only in one sense** | A Cleric is offered Deepening Hex only if his LINEAGE is the Occultist, and such a hero **owns** the Rune of the Occultist for the whole run — nothing sells or discards one. "Without" can only mean *not equipped*, which is the state the gate reads (§2). |
| GU found `check_eb` was only comparing each lineage's own shelf | Held | GU §3a. |
| FP's figure predates GK, GO, GS and GT | Held | All four are after FP. |
| **nine engine runes were authored since** | Held | GO's nine rule engines; 15 + 9 = the 24 live engine runes. |
| **the eleven old engines became runes** | **Not held** | GK made **fifteen** engine runes — the twelve lineage engines and the three spines. Eleven is the figure `docs/merge-recon.html`'s plan table carried. |
| twelve lineage runes were trimmed of what they carried | Held | GS §1: every lineage opens with its engine's enablers alone; six of the twenty-four bring a card, eighteen none. |
| GT found 17 engine-locked cards by asking about all 204 | Held | GT §3; `Classes.SITS_OUT`. |
| GU checked all 204 against the kits | Held | GU §2. |
| CN found 137 abilities a field-level test misjudges | Held | `CLAUDE.md`, GP's block. |
| GP found six cards no board test could see — Unslaked, Anvil, Recompense; Intercession, Last Howl, Succession | Held | `check_gp` §2c and §2d. |
| GP reported 35 of 38, 29 of 41, 22 of 34, 29 of 36 | Held | GP §2e. |
| a hero owns up to six and slots two; GT found the pouch lists all six | Held | `Run.ENGINE_SLOTS` = 2; GT §1. |
| GT ruled a card sits out while the engine is gone, never deleted, keeps its slot | Held | `CLAUDE.md`'s sits-out block; `Run.seated_ability_names`. |
| a hero buys Deepening Hex for 100g | Held | Every live rune is 100g (EZ §0). |
| FD found the elite cache rolls at the drop and answers a node later | Held | FD §1; `Run.rune_choice`. |
| a former basic is priced against what it competes with now — GU's ruling; record it if it is not already recorded | **Recorded** | It was not: `docs/state.md` carried it as GU's ruling 1, owed. It is in `CLAUDE.md`'s EB block now, with **RULED, NOT BUILT** beside Arcane Explosion's and Shadowrend's prices. |
| the four engine rule texts and the sim bot's reach stay queued | Held | Untouched. |
| the 52 engine-bound gates are the next stage | Held | Step 6 of the running order. |
| back up the saves, four exist | **Held** | Four files, and all four are byte-identical to GU's backup — the run in progress has not moved since GU (§6a). |

## §1 — THE POPULATION, DERIVED AND DRIVEN

### §1a — The method, and why it is two instruments

**A RUNE IS A PAYLOAD OF FIELDS, AND A FIELD SAYS NOTHING ABOUT WHO PAYS.** Sixty live ordinary runes write sixty-two
`rune_*` fields between them, and every one of those fields was traced to **every line in `scripts/` that reads it**,
with the guard chain above that line: the `if` chain, the early returns in its function, and the gates every caller of
that function carries (GM §1's census method). That reading is what sorts a rune; it is not what proves the sorting.

**SO EVERY ONE OF THE SIXTY WAS ALSO DRIVEN, ON FOUR BOARDS** (`check_gv` §1). A board seats the rune's lineage hero at
his class's seat with his engine rune **equipped** or **merely owned** — the state the pouch's own door leaves him in —
and with the rune worn or not; the card its `requires_ability` names, and any card the drive casts, are drafted and
carried in all four; the dice are re-laid before each drive. The rune is then made to do its job through the game's own
doors, and one value is read back:

- **`Δ equipped` — the rune worn against not worn, with the engine.** This is the arm that makes the table more than a
  list of runes that do nothing: if the rune does not pay here, the drive never reached it.
- **`Δ owned` — the same pair with the engine merely owned.** A row must move **nothing**.

**35 of 35 rows pay equipped and move nothing owned; 24 of 24 non-rows move something owned.** The one exception is
named: the Shared Hide moves nothing in either arm (§3c).

### §1b — The thirty-five rows, and what each drive read

| Rune | Lineage / engine | What the drive did | Δ equipped | Δ owned |
|---|---|---|---|---|
| Deepening Hex | Occultist / Wrath of the Old Gods | eight Ruin laid through `_gain_ruin` | primed at 8 against not primed | no Ruin either way |
| Standing Mark | Occultist | a strike into a forty-stack mark | healed to 90 against 75 | 46 against 46 |
| Shared Ruin | Occultist | a primed mark detonated beside a second body | 9 stacks against 3 | 3 against 3 |
| Wide Rite | Occultist | the passive's own mark laid | 3 stacks against 2 | none either way |
| Open Wound | Occultist | Shadowrend cast at one of three | the others marked 2 each against 0 | 0 against 0 |
| Vigil | Holy / Mercy | an ally healed back over half | +1 Mercy against 0 | no bar either way |
| Open Hand | Holy | Divine Plea cast with a second ally under half | the other healed 99 against 29 | the cast is refused either way |
| Carried Mercy | Holy | the victory's own state sync | 3 carried against none | none either way |
| Grace | Holy | Hymn of Hope cast | an echo of 0.11 against none | the cast is refused either way |
| Martyr | Holy | struck by an enemy | +1 Mercy against 0 | no bar either way |
| Deep Absorb | Devout / Conviction | a divine shield absorbing a blow | Faith peak 3 against 2 | no Faith either way |
| Fourth Stack | Devout | five Faith kindled on an ally | peak 4 against 3 | no Faith either way |
| Bare Altar | Devout | the same absorb | peak 3 against 2 | no Faith either way |
| Ember Leap | Pyromancer / Overburn | Funeral Pyre consuming six turns of Burn | 3 turns leap against none | no refund either way |
| Pyre Debt | Pyromancer | the same consume | 12 Mana and 1 health against 6 and none | no refund either way |
| Second Winter | Cryomancer / Glacial Hold | a hold released | 3 Chilled against 1 | 1 against 1 |
| Resonant Core | Arcanist / Runaway Resonance | ten Resonance at the victory sync | 1 carried against none | none either way |
| Half Note | Arcanist | Arcane Bolt cast on eight stacks | 7 left against 5 | the cast is refused either way |
| Overtone | Arcanist | three casts | 4 Resonance against 3 | none either way |
| Dissonance | Arcanist | a strike on four stacks | 34 dealt against 25 | 22 against 22 |
| Overflow | Arcanist | a crit cast | 3 Resonance against 2 | none either way |
| Open Vein | Berserker / Blood Frenzy | 40 Rage spent, then a strike | 22 dealt against 19 | 16 against 16 |
| Standing Wall | Warden / Heavy Plating | a blocked blow on a 24% climb | the climb halves to 12 against 0 | 24 against 24 |
| Bracing Line | Warden | an ally struck behind a 40% wall | 8 taken against 9 | 9 against 9 |
| Whetstone | Swordmaster / Seasoned Fighter | a strike after three turns in the guard | 21 dealt against 19 | 16 against 16 |
| Naked Blade | Swordmaster | an Aggressive strike | 21 dealt against 19 | 16 against 16 |
| Long Leash | Beastmaster / Pack Bond | a companion at ten Loyalty striking | 23 dealt against 21 | 15 against 15 |
| Shared Scent | Beastmaster | a bonded companion felled, then the next called | the next arrives at 7 against 1 | 0 against 0 |
| Keen Focus | Sharpshooter / Lethal Aim | a target switch on 100 Focus | 50 kept against 0 | no Focus either way |
| Heavy Bolts | Sharpshooter | the conversion read at 90 Focus | 0.40 chance and ×0.05 against 0.45 and none | none either way |
| Ambush | Sharpshooter | Called Volley on 50 Focus | 18 dealt against 14 | 14 against 14 |
| Shared Mark | Sharpshooter | an ally striking his mark | +5 Focus against 0 | no Focus either way |
| Long Draw | Sharpshooter | the sequence's own press count at 100 Focus | 4 presses against 3 | 1 against 1 |
| Second Barb | Survivalist / Trapper | twenty-four enemy blows | a Cripple and a Poison against two Poisons | nothing either way |
| Thin Blood | Survivalist | the same twenty-four | twenty-four barbs against two | nothing either way |

### §1c — The twenty-five that are not gated, and what each reads instead

**HALF-WORKS — GP's own group, and the reading that keeps them offered.** A rune that still does part of its job is a
legitimate offer; what the engine keeps is measured beside it (`check_gv` §1c):

| Rune | Without its engine | What the engine keeps |
|---|---|---|
| Killing Cold | bites a body sitting on four Chilled, for 20,000 on the gate's own dressed board | a body that can be HELD stays at four: on trash it bites nothing without the engine and 20,000 with it |
| Glass Prison | freezes a second body, and both are glass | those cells are PRISONS only with it: 2 held equipped, 0 owned |
| Open Line | Guard Change lays Formless instead of switching, which opens both stance gates | the guards' numbers: the blow he deals after it reads 19 against 15 equipped, and 16 against 16 owned |
| Blood Debt | the target pays 7.5% of its health and he pays nothing | the missing health becomes Blood Frenzy steps: +20% equipped, +0% owned |
| Second Whistle | a companion arrives holding 3 Loyalty, which the strike step reads | the Pack Bond boon it buys: 1.8 equipped, 0.0 owned |

**THE 20,000 IS A FIXTURE FIGURE AND NOT A BOSS'S HEALTH.** `check_gv` dresses a body with 100,000 health so a percentage-of-health bite has room to read at all; no enemy in the game is that large. What the row measures is the CONTRAST — four Chilled held against a body that sheds them — and the number is only the scale the board was built at.

**A CARD (eleven).** Ashfall (Funeral Pyre), Chain Fire (Firedraw), Cold Snap (Ice Lance), Butcher's Bill (Hack and
Slash), Split Shield (Shieldwall), Long Blade (Sever), Full Board (Cull), Carrion (Downwind), Answering Pack and Bared
Fang (a companion, which an earned Call the Wilds fields with no engine at all), and **Layered Aegis, whose card is
Conviction's own enabler** — so `requires_ability` already withholds it from a Devout who has unequipped the engine,
and its payload (a second barrier) needs no Devout: 2 warded against 1 in both arms.

**A STATUS ANY CARD LAYS (four).** Long Fuse (Burn), Deep Cold (Chilled), Long Poison (Poison — Snare Trap is in every
Hunter's class kit), Slaughterhouse (a bleedout).

**THE STANCE (one).** Mirror Guard: every Warrior stands in the Aggressive guard and any drafted swap card reaches the
Defensive one, so its parry return pays 3 in both arms.

**NOTHING AT ALL (three).** Last Word (his own health), Long Watch and Bared Plate (Break damage).

**AND ONE THAT PAYS NOBODY (one).** The Shared Hide (§3c).

## §2 — WHAT A HERO CAN BE OFFERED

**HIS KIT MADE WHOLE, THROUGH THE LIVE DOOR** (`check_gv` §3): every rune his lineage can be offered, with his engine
equipped and with it merely owned. The engine runes of his class are in both counts and are excluded from the table
below, which is his own lineage's set.

| Class | Lineage | Equipped | Engine merely owned | What is left |
|---|---|---|---|---|
| Warrior | Berserker | 5 | **4** | Last Word, Blood Debt, Butcher's Bill, Slaughterhouse |
| | Warden | 5 | **3** | Split Shield, Long Watch, Bared Plate |
| | Swordmaster | 5 | **3** | Mirror Guard, Open Line, Long Blade |
| Mage | Pyromancer | 5 | **3** | Long Fuse, Ashfall, Chain Fire |
| | Cryomancer | 5 | **4** | Killing Cold, Glass Prison, Cold Snap, Deep Cold |
| | Arcanist | 5 | **0** | — |
| Cleric | Holy | 5 | **0** | — |
| | Devout | 4 | **1** | Layered Aegis |
| | Occultist | 5 | **0** | — |
| Hunter | Beastmaster | 6 | **4** | Shared Hide, Answering Pack, Second Whistle, Bared Fang |
| | Sharpshooter | 5 | **0** | — |
| | Survivalist | 5 | **3** | Long Poison, Full Board, Carrion |

**PER CLASS**: the Warrior's three lineages hold 15 runes and 10 survive an unequipped engine; the Mage's 15 and 7; the
Cleric's 14 and **1**; the Hunter's 16 and 7.

**AND A HERO HOLDING TWO ENGINES IS OFFERED EXACTLY WHAT HIS LINEAGE OFFERS.** `check_gv` §3 seats every lineage beside
every other engine of its class in turn: the count never moves. A Holy Cleric holding the Rune of the Occultist in his
second slot is rolled **no** Occultist rune (§4a), because `_scope_ok` reads `member["spec"]` — the lineage — and not
the engines he holds. **A spine-taker has no lineage and is offered no spec rune at all**, engine or none; his ordinary
pool is his class's six engine runes.

**THE LOAD-BEARING QUESTION, ANSWERED BY THE CODE RATHER THAN CHOSEN.** The gate reads the EQUIPPED set
(`Runes.held_engines`). An ownership reading would gate nothing: the only heroes who can be offered a row are heroes of
its lineage, every one of them took that engine at class selection, and `member["engines"]` is written by `new_run`,
`awaken`, `hold_rune`, `toggle_engine` and the save migration — **none of which can remove a rune**. The battle reads
the same set (`BattleUnit.engines`), so an unequipped engine pays nothing in a fight; the card gate reads it; and a
rune's `requires_ability` has read it since GS, because an enabler leaves the kit with its engine.

## §3 — WHAT THE READING FOUND

### §3a — FP's 43 against today's 35

FP traced every payload field to every read site in six scripts and classified on the guard chain: **43 engine / 2
enabler / 8 spec-status / 7 neither**. That was the game in front of FP. Of its 43, **33 are rows**; ten are not, and
two runes outside its 43 are:

| Left the engine set | Why, today |
|---|---|
| Shared Hide, Answering Pack, Bared Fang, Second Whistle | a companion no longer needs Pack Bond — an earned **Call the Wilds** fields one with no engine, the companion strike step reads Loyalty ungated, and Second Whistle WRITES Loyalty rather than growing it |
| Mirror Guard, Open Line | the stances are every Warrior's since GS §1 put every swap card in the draft; the engine keeps the guards' NUMBERS, which is why Open Line is half rather than whole |
| Bared Plate | its +25% Break damage is read at the strike line with no engine; the Block it spends is the Warden's own stat |
| Blood Debt | the bill goes to the target, which is damage a hero without the engine still deals |
| Glass Prison | Glacial Prison still freezes without Glacial Hold — ordinary ice rather than a prison — and the rune still seals the second body |
| Ashfall | Funeral Pyre keeps its fire; what it costs (the Overburn refund) is the engine's, so the rune is worth MORE to a hero without one, not less |

| Joined it | Why |
|---|---|
| Grace, Open Hand | each modifies a card GS §1 moved into the pool and priced in Mercy — Hymn of Hope and Divine Plea are refused against an absent bar, so neither rune can be reached |

### §3b — Two rows are worse than nothing without their engine

**THE MARTYR'S PRICE AND THIN BLOOD'S ARE READ WITH NO ENGINE AT ALL.** Driven (`check_gv` §1b), on a board where the
engine is merely owned:

- **Martyr**: an ally's heal of 40 lands **0** with the rune worn and **46** without it. The price sits in
  `heal_amount`'s absolute refusals; the Mercy it pays for needs the bar.
- **Thin Blood**: a poison he lays ticks for **0** with the rune worn and **3** without it. The barb it buys is inside
  the Trapper block.

That is a second reason for the row rather than the first, and it is the sharpest case for ruling 3: a hero who drops
his engine while holding either is playing a worse game than a hero holding no rune at all.

### §3c — The Shared Hide pays nobody

`Talents.apply_payload` writes `rune_shared_hide` onto the **hunter** at the spawn. `_companion_hit` multiplies by
`_shared_hide_mult(comp)`, which reads **`comp.rune_shared_hide`** — and `_do_summon` builds a companion from a cfg
that carries no rune field, so the companion's copy is 0 for every hunter who has ever bought it. Probed on a live
board: the hunter reads 1, the summoned Canis reads 0, and the multiplier is 1.0000 with Surge standing on the beast.
Driven in `check_gv` §1: **15 damage dealt in all four arms.**

**`check_ez` §4's arm could not see it**: it sets `beast.rune_shared_hide = 1` by hand and then reads the multiplier,
which is the one path a real run never takes. **The gate holds it as a NAMED DEAD rune** — asserted to move nothing in
either arm — so the day the field reaches a companion, `check_gv` reds and says it must be sorted again.

## §4 — WHAT WAS BUILT

### §4a — The roll: one door, every site

`Runes.ENGINE_READ` (35 rows, each with its engine and a `why`) and `Runes.offerable(id, engines)`. `eligible_ids`
asks it once per entry against `held_engines(member)`, which covers **the Peddler** (`shop_screen._roll_offers` →
`Run.generate_rune`), **the elite cache** and **the bargain** (`Run.roll_rune_candidates`) and **the event verb**
(`Run.grant_rune`) — the four sites FD §1 derived off what a rune reaches a hero through.

Driven (`check_gv` §2): every row is withheld from an owner who has not equipped it and rolled the moment he does (35
of 35, both directions, on all twelve lineages); twelve Peddler visits an arm offered **0 rows unequipped and 17
equipped**; twelve bargain rewards **0 and 16**; twenty event grants to a Sharpshooter with Lethal Aim out, none a row.

### §4b — The answer: a row sits out and stays stored

`Run.rune_choice` keeps FD's repair (retired, owned, topped up, written back) and then filters what it returns through
the same gate **without** writing that back; `Run.rune_choice_withheld` is what the overlay reads to say what is
waiting. Driven on the real map screen:

- a cache rolled with the Old Gods equipped — Deepening Hex, Wide Rite, Shared Ruin — **offers none of the three**
  unequipped, keeps all three stored in the same order, and **offers all three again** when it is equipped;
- the overlay for that cache draws no rune button, says *"The cache holds nothing this hero can take while the Rune of
  the Occultist is not equipped"*, offers **Let it go** and **Not yet**, and closing it spends nothing;
- a part-row cache (Open Vein beside Last Word and Slaughterhouse, Blood Frenzy unequipped) draws two buttons, says
  *"The cache holds 1 more that waits on the Rune of the Berserker being equipped"*, and **the button pressed is the
  rune handed over** — the third stored rune, which a pick reading the stored triple would have got wrong.

### §4c — The sentence, when there is nothing left

`Runes.empty_offer_reason` had two causes and has **three**, plus a fourth sentence for two at once: a hero whose last
runes read an engine he has not equipped is told *"the runes left for that awakening wait on the Rune of the Occultist
being equipped"* rather than that he already carries everything. `Runes.locked_by_engine` is its population.

### §4d — Four whole runs, on the real screens

`check_gv` §4 walks the map, fights with the bot, answers every pick, and records every rune offer by name: **three
roads with every engine unequipped** (one per lineage set, every engine the road hands the party unequipped again
through the pouch's own door before each step) and **one with two engines apiece**.

| Arm | Offers read | Rows among them |
|---|---|---|
| no engine (3 runs, 93 battles) | 80 at the Peddler, 68 at a cache or bargain | **0** |
| two engines (1 run, 28 battles) | 36 at the Peddler, 33 at a cache or bargain | **11** |

## §5 — THE DROPPED-ENGINE CASE, REPORTED

**A RUNE BOUGHT UNDER ITS ENGINE IS NOT TAKEN AWAY, AND NOTHING WAS BUILT HERE.** The rune stays in the pouch, stays
equipped in one of the three ordinary slots, and its payload still attaches at the spawn — it simply pays nothing,
which §1 measures for all thirty-five. The player can unequip it himself on the map, free and reversible, and the slot
is his again.

**WHY "SITS OUT" MAY BE THE WRONG ANSWER HERE, AS THE BRIEF SAID.** A card that sits out is a card the door would
refuse, and GT's ruling keeps it seated in the kit so the slot count does not move. A rune has no door to refuse it:
what it does is arithmetic at a read site that never runs. So sitting a rune out would change nothing mechanically for
thirty-three of the thirty-five — **except for the Martyr and Thin Blood, whose price it would lift** (§3b).

**THE FOUR ANSWERS, PRICED AND NOT TAKEN:**

1. **Leave it (what ships).** Nothing is built; the player manages the slot. The cost is silence: no screen says the
   rune is asleep, and two runes keep charging him.
2. **Sit it out, as a card does.** The payload is skipped while the engine is out and a note says which rune wakes it.
   It costs a note on two screens and lifts the two prices; the slot still counts, as GT ruled for a card.
3. **Unequip it automatically.** The slot comes back at once, and the player loses the choice — and a re-equipped
   engine would not put the rune back on its own.
4. **Let it be sold.** The largest of the four: nothing in the game sells a rune today, and a sale price is a new
   pricing rule beside the flat 100g.

## §6 — VERIFICATION

### §6a — The saves

The player's four save files were copied to `save-backups/GV-20260919-211307/` before any Godot process ran and
verified by md5: `profile.json` (ed4144e1…), `relics.json` (fdc12ffa…), `run_save.bin` (25582edd…) and `settings.cfg`
(0c1b39c3…). **All four are byte-identical to GU's backup**, so the run in progress has not moved since GU.
**THEY WERE HASHED AGAIN WHEN THE ACCEPTANCE BATTERY FINISHED AND ALL FOUR ARE UNMOVED** — the same four digests, against a backup taken before any Godot process ran. **119 targets, four whole runs driven through the real screens and ten control copies did not touch the player's run**: each control copy carries its own `config/name`, because `user://` is keyed by the project name and an out-of-repo copy would otherwise share the player's directory. No Godot process was left standing at the end — read off the rows of `ps`, not off a count.

### §6b — The unmodified battery against the new tree, and the repairs

**Before a gate was edited**, the whole battery ran unmodified against GV's game code, on a tree stamped by md5 before
and after (586 files by absolute path, untracked included — identical): **118 targets in 57 minutes (21:54–22:51),
`BATTERY_EXIT` 0, `check_de` at 489 / 7.** Four targets moved, all of them rune-offer instruments, and **every one
moved for the same reason: a hand-built lineage hero carrying no engine rune**, which GK's rule already forbids and
which the gate made visible.

| Target | On GV's code, unmodified | Repaired | What changed |
|---|---|---|---|
| `test_runes` | 5,542 / 32 — every row "does not roll for its own spec" | **5,625 / 0** | `_eligibility` and `_rich_grant` seat the lineage's engine rune; the count RISES by 3 against GU's 5,622 because a Devout holding Conviction owns Divine Shield, so Layered Aegis rolls for him |
| `check_fd` | 48 / 4 and a throw — §1c's triples are Lethal Aim's | **51 / 0** | `_member` and §1e's Sharpshooter seat it |
| `check_es` | 57 / 1 — thirty rows read as silently absent | **57 / 0** | §2's three walks seat it, and the arm learns that an engine rune the hero HOLDS is not silent either |
| `check_fo` | 88 / 1 — the Shared Mark unofferable | **88 / 0** | §2b's Sharpshooter seats it |

The two standing sanctioned reds read as they did — `check_cm_live` 13 / 4 and `check_gj` §4's gold line — and every
other target read exactly what GU's acceptance run read. **`check_gj`'s figures moved** (card +158 against a purse of
+178, where GU recorded +169 / +189): the gap is still the Tollkeeper's Bell's 20 gold and the counts did not move,
and what its seeded run draws moves with the rune offers. **Armed against HEAD's own code**, rebuilt out of the repo
with its ignored files and its `.git` (`git checkout` over an `rsync`): `check_gj` reads **70 / 1 with the FAIL line
*"the card says +169 gold and the purse moved 189"*** there — GU's figures exactly — so the movement is GV's rune
offers and not the Bell.

**AND THE FOUR REPAIRS ARE ARMED THE SAME WAY.** Each repaired gate was run against **HEAD's game code** in that
rebuild as well as against GV's: `check_es` 57 / 0, `check_fd` 51 / 0, `check_fo` 88 / 0 and `test_runes` **5,625** / 0
on both. A repair that only worked beside the new gate would read differently on the two arms; and the +3 in
`test_runes` is on HEAD's code too, which is what says it is the seat being right rather than anything GV built.

### §6c — `check_gv`, and its controls

**TEN DEFECTS WERE INJECTED, ONE PER ISOLATED COPY**, each copy built by `rsync` from the landed tree with its own
`config/name` so its `user://` could not reach the player's files, and each run whole. **The clean gate reads 874 / 0;
every injection bit, and the FAIL line names its own defect** — the text is what matters, not the count:

| Injected | Read | The FAIL line it printed |
|---|---|---|
| **The gate taken out of the roll** (`eligible_ids` asks `offerable` no longer) | 927 / **111** | *the row open_vein is rolled for a berserker who OWNS bloodrage and has not equipped it* — and 34 more like it, with §2d's Peddler, §2e's event verb, §3's per-lineage table and §4's roads |
| **The gate reading what he OWNS** rather than what he has equipped | 927 / **111** | **the same 111 lines, byte for byte** — which is the measurement behind ruling 2: an ownership gate and NO gate are indistinguishable, because every hero who can be offered a row owns its engine all run |
| **The answer's filter written back** (FD's literal form) | 874 / 9 | *the answer rewrote the stored triple — the rows were repaired away, not sat out*; *with the engine back the cache offers \[\], not the three it rolled*; *the withheld list names 0* |
| **The answer not filtered at all** | 875 / 9 | *a row was handed over with its engine unequipped — \["Deepening Hex", "Wide Rite", "Shared Ruin"\]*; *the overlay drew Deepening Hex as a button with the Old Gods unequipped* |
| **A row deleted from the table** (the Vigil) | 874 / 6 | *`Runes.ENGINE_READ` holds 34 rows against the 35 ruled*; *vigil reads mercy by ruling and the table says ''*; *the row vigil is rolled for a holy who OWNS mercy* |
| **A rune that works without its engine added to it** (the Long Fuse) | 874 / 3 | *`Runes.ENGINE_READ` gates long_fuse, which no ruling names*; *long_fuse reads no engine and is not rolled for a pyromancer either way* |
| **The Shared Hide wired** — the hunter's field copied onto the companion at the summon | 874 / 1 | *shared_hide paid something ({ "dealt": 18 } / { "dealt": 15 }, …) — it is no longer dead; sort it again* |
| **The empty-offer sentence's engine cause removed** | 874 / 1 | *the empty offer does not name the engine rune that brings the runes back* |
| **`_pick_rune` indexing the stored triple again** | 874 / 1 | *pressing Slaughterhouse handed over \["Last Word"\] — the pick read the stored triple, not the offer* |
| **A row made to pay with no engine** (the Martyr's Mercy no longer asks for the bar) | 874 / 2 | *martyr_fk moved something with mercy merely OWNED ({ "mercy": 1 } against { "mercy": 0 }) — it does not belong in the table* |

**THE TWO ARMS THAT MATTER MOST ARE THE LAST FOUR.** A gate that only asserted the table would pass an injection that
moved the CODE; a gate that only drove the runes would pass one that moved the TABLE. Each half is armed against the
other here, and the Shared Hide's row is armed in the direction a repair would take it rather than in the direction a
regression would.

### §6d — The pre-pass and the acceptance battery

**THE PRE-PASS RAN AFTER THE DOCUMENTS WERE WRITTEN AND BEFORE THE BATTERY**, over every gate that reads a document
or a literal out of one — the population GV's edits could move, rather than a sample of it. **Twelve gates, all
clean:** `check_parse` 193 / 0, `check_eh` 156 / 0, `check_ea` 83 / 0, `check_ff` 68 / 0, `check_ek` 47 / 0,
`check_da` 43 / 0, `check_dw` 35 / 0, `check_fs` 33 / 0, `check_fr` 25 / 0, `check_ec` 24 / 0, `check_fg` 22 / 0 and
`check_ed` 18 / 0. `check_fr` §5 read the four rule files at **CLAUDE.md 340,523 B**, ways-of-working 12,949 B,
instrument-rules 119,839 B and combat-rules 30,440 B; `check_fg` §2 read the same 340,523 B as **332.54 KiB against
the 340 KiB ceiling — 7,637 B (7.46 KiB) of headroom** — and the changelog at 388,238 B against its 400,000 B bar.

**THE ACCEPTANCE BATTERY RAN ON A FROZEN TREE**, stamped by md5 before it started and again when it finished: **588
files by absolute path, untracked included, and the two stamps are identical** — so nothing was edited behind the run
and the reading is of one tree rather than of a mixture.

- **119 targets, 23:46:35 to 00:53:20 (66 min 45 s), `BATTERY_EXIT` 0, and `throws=0` on every one of the 119.**
- **`check_de` 493 checks / 0 failures / 0 notices** — no target moved a count against `baselines.json`.
- **The new gate and the three counts GV moved read as predicted**: `check_gv` **874 / 0**, `check_parse` **193 / 0**
  (192 before GV's gate joined the tree), `test_runes` **5,625 / 0**. The four repaired gates hold: `check_es` 57 / 0,
  `check_fd` 51 / 0, `check_fo` 88 / 0.
- **The run harness**: `GATE 1 PASS (22)`, `GATE 2 PASS (382)`, `GATE 3 PASS (8)`, `throws=0` — the live counts
  written into `run_battery.sh`'s own header, so no gate passed while running a third of itself.
- **The floor is met by the stderr and not by a tally**: every one of the 119 target logs was swept for `Parse Error`
  and `SCRIPT ERROR` and **none holds either**.
- **The only reds are the two standing sanctioned ones, and each was read as text rather than as a count.**
  `check_cm_live` 13 / 4, its four FAIL lines byte-identical to the recon's — *the bar appeared on the enemy's
  attack*, *the bar's top line names the incoming blow (was: )*, *the brace lands near x0.85*, *the brace's Break half
  lands near x0.75*. `check_gj` 70 / 1 — *§4: the card says +158 gold and the purse moved 178* — attributed to GV's
  rune offers by the HEAD rebuild in §6b, which prints GU's own +169 / +189 against the same gate.

**AND THE DOCUMENTS MOVED AFTER THE BATTERY, SO THEY WERE PROVED AGAIN RATHER THAN ASSUMED.** Four files changed
between the stamp the run finished on and the commit — `docs/reports/GV.md` (this section), `docs/state.md` (its
verification line and the date), `docs/changelog.html` and `docs/master.html` (the date alone) — **derived by
re-hashing the run's own 588-file stamp, not from memory of what was edited.** Three things were run against the
final tree:

- **The literal sweep, before and after the date edits: identical.** Every string literal of four characters or more
  in all 121 suites and gates, against each tracked document at HEAD and now — **no literal moved.** The six LOST are
  `docs/state.md`'s, which is rewritten every batch by rule, and the battery had already passed on a tree carrying
  all six.
- **Every target that OPENS one of the three moved documents — twenty-nine of them, derived by grepping for the
  `res://docs/...` path rather than taken from the pre-pass list — re-run whole: 0 failures, 0 `Parse Error`, 0
  `SCRIPT ERROR`.** The pre-pass's twelve were not that population; eight of the twenty-nine are suites it never held.
- **The eight pre-pass gates outside that set re-run too**, each reading exactly its pre-pass count: `check_parse`
  193 / 0, `check_ea` 83 / 0, `check_ff` 68 / 0, `check_ek` 47 / 0, `check_da` 43 / 0, `check_dw` 35 / 0, `check_fr`
  25 / 0, `check_ed` 18 / 0.

**THE THREE COUNTS GV MOVED TOOK THEIR SECOND READING AND `baselines.json` RECORDS IT** — `checks_obs` and
`fails_obs` are incremented by one on `check_gv`, `test_runes` and `check_parse`, which is six integers and **six
changed lines**: the file is written at indent 1 and a re-dump would churn it whole. `check_de` was re-run against
the acceptance logs afterwards and reads **493 / 0 / 0, 118 of 118 targets on their recorded line**.

## §7 — FOUND AND NOT FIXED

- **The Shared Hide pays nobody anything** (§3c), and `check_ez` §4's arm could not see it.
- **The Martyr and Thin Blood charge their price with no engine** (§3b).
- **The sim bot never meets the gate at a cache's answer**: `run_sim` answers a rolled triple off the member's own
  array rather than through `Run.rune_choice`, so a sim measures the roll's gate and not the answer's. Sims only, and
  every sim party keeps its engine equipped.
- **Five more hand-built lineage seats carry no engine rune** — `check_fd` §1d's collision measurement, `check_et`'s,
  `check_fe`'s, `test_runes`' `_exhaustion` and `_start_rune_pool`. None of their questions reaches a row today, so
  none was touched; GK's rule says they should all seat one.
- **A cache or bargain ROLLED while an engine is unequipped never holds its rows**, and re-equipping cannot bring back
  what was never rolled. That is the roll reading the hero as he stood, the same way the card draft reads him at a
  victory; it is named here because it is the one place the gate takes something that a toggle cannot give back.
- **`check_gv` is this battery's third road driver** (`check_gp` §4 and `check_gj` drive whole runs too). DA §3's rule
  about copied helpers points at consolidating them into `gate_fixture.gd`; that is its own batch and is not taken.

## §8 — FILES

- **Game code (3):** `scripts/runes.gd` (`ENGINE_READ`, `engine_read`, `offerable`, the gate in `eligible_ids`,
  `locked_by_engine`, `waited_on`, the third and fourth empty-offer sentences), `scripts/run_state.gd`
  (`_engine_seated`, `rune_choice_withheld`, the filter at the answer), `scripts/map_screen.gd` (the overlay's two new
  lines and its Let-it-go arm; `_pick_rune` indexes the offer it drew).
- **New gate:** `check_gv.gd`, and `run_battery.sh`'s `GATES` and its own `TMO` bound.
- **Repaired to intent (4):** `test_runes`, `check_fd`, `check_es`, `check_fo`.
- **Instrument data:** `baselines.json` (`check_gv` new; `test_runes` 5,622 → 5,625; `check_parse` 192 → 193);
  `pin-manifest.json` (regenerated — the repairs moved line numbers).
- **Documents:** `CLAUDE.md` (the new standing rule, FD's reversible-state bullet, FM's third cause, and the
  former-basic ruling recorded), `docs/master.html` (§6.0 and §8, and its stamp), `docs/state.md`,
  `docs/changelog.html`, `docs/design-notes.md`, and this report (new).
- **Not edited:** `data/runes.json` — no rune's name, price, payload, scope or `requires_ability` moved.
