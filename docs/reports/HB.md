# BATCH HB — EVERY HUNTER HAS A PET

**On `class-merge`, from `68aee95` (HA). IMPLEMENT ONLY. Authored with the designer and transcribed, not proposed.**
The companion is the Hunter's class identity now: **Summon Companion** is his third class-kit card — one card that
calls Ursus, Canis or Aguila, chosen at the cast — and every Hunter holds it but the Sharpshooter, whose Lethal Aim
dismisses the pet and pays for it with the freed slot, a ×2.5 critical and a new meter. **Tripwire** gave up its kit
slot and went to the Survivalist's shelf. **Pack Bond brings nothing** and deepens the bond. **THE SEQUENCE SHIFTED
WITH THIS BRIEF**: HA planned HB for its twenty holes and HC for the other 75; this batch took HB, the rune scopes are
HC, HA's twenty holes (with the fold family HA priced beside them) are HD, and the other 75 are HE — recorded in
`docs/state.md`. **No other kit, engine or pool moved, the Mage pool is not split, and `main` is untouched.**

---

## NEEDS A RULING

1. **"+50% CRIT MULTIPLIER" WAS READ AS +0.50 ON THE MULTIPLIER, SO LETHAL AIM'S ×2 IS ×2.5** — the unit every term
   in `lethal_crit_mult()` is written in, and the one EW's surplus conversion pays in (0.50 of multiplier). The other
   reading, ×2 × 1.5 = ×3, is one constant: `unit.gd`'s `SHARPSHOOTER_CRIT_MULT`. Focus rides on top either way
   (×3 at 200 Focus, ×3.5 at 300 on this reading).
2. **THE PITY METER HAS NO CAP, AND IT COUNTS HITS.** The brief gave no cap; Heavy Plating, the model it names, stops
   at +40%. Built uncapped, the reset governs — §4d prices it: it lifts a bare Sharpshooter's crit rate per landed hit
   from 10% to 22.1%, and a streak reaches certainty about once in forty million streaks at that base. *"Per landed
   attack"* was read as BR §1 reads a charge — per HIT — so an area attack climbs it once per enemy struck and a
   multi-hit card once per hit (§4c); per CAST is the other reading.
3. **A SHARPSHOOTER FIELDS NO COMPANION BY ANY ROUTE, CALL THE WILDS INCLUDED.** *Dismisses the pet* was read as no
   companion at all, so the one drafted card that summons is withheld from his offer and sits out if he carries it,
   and the summon door refuses him. The other reading lets a drafted summon through.
4. **UNEQUIPPING THE RUNE OF THE SHARPSHOOTER IS REFUSED WHILE EVERY SLOT IS FULL** — it returns Summon Companion to
   the kit, and the kit would overfill the bar. The pouch's button is disabled with the reason (*"Bench a card
   first"*). Benching one for him, or letting the kit overfill, are the alternatives.
5. **THE ZONE BOSS'S TIER-1 OFFER STILL ASKS NO DOOR** (`Run.roll_spec_ability_offer`), so a Beastmaster-lineage
   Hunter holding Lethal Aim can be offered Bestial Wrath, Spirit Bond or Primal Surge — companion cards that sit out
   for him — and Call of the Wild, whose absent companions strike bodiless. GP left the boss pools as they were and
   the brief changes no pool; asking `Classes.offerable` there is one line and moves every engine's boss offer.
6. **A HUNTER MAY HOLD PACK BOND AND LETHAL AIM TOGETHER**, and then Pack Bond does nothing: every read of it needs a
   companion and he has none. Nothing withholds either engine from the other's holder.
7. **SUMMON COMPANION IS TAGGED OFFENSE / BREAK — TWO OF ITS THREE CALLS — AND THE CORE-KIT CENSUS MOVED WITH IT.**
   The Beastmaster's core no longer carries Summon Canis's DEBUFF, so DEBUFF is met at 2+ by five lineages' cores
   alone, not six (`check_es` §4 caught it; the three documents that state it are corrected). DEBUFF / BREAK, for the
   wolf, is the other reading and moves the OFFENSE column instead.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `68aee95` = `origin/class-merge` before anything moved |
| 2 | *"HA planned HB for the twenty holes and HC for the other 75"* | **HELD, WITH ONE WORD SHORT** | HA §2's HB was the twenty tier-1 arms **and** the thirty-five FOLD arms — 55 arms in 23 targets — and its HC the other 75. Recorded in `docs/state.md` as HA priced it: **HD = the twenty holes and the fold family, HE = the other 75** |
| 3 | *"HA found three of the four heroes in the designer's current save can never be offered an ordinary rune"* | **HELD, RE-READ OFF THE SAVE** | a copy of `run_save.bin` (v13): the Warrior holds the Rune of the Reaver, the Cleric Sanctity, the Hunter the Medic and the Tracker — no lineage, and all sixty live ordinary runes are `spec:`-scoped; the Mage holds Overburn and is the Pyromancer |
| 4 | *"Three cards gave three buttons; one card gives one"* | **HALF: THE BATTLE ALREADY GAVE ONE** | in a fight the three summons were ONE menu entry — *Summon Companion ▸* on W — opening a three-button picker, and at capacity the same entry offered three swap clones. They were three CARDS everywhere else: three rows on the hero sheet, the Kit panel, the class-selection card and Pack Bond's enabler list. The picker is kept; the card is one |
| 5 | *"the bot, which GN and GS both found cannot use cards outside its lineage branches"* | **HELD** | GN §4a: four kit cards cast only under an engine branch or never (Bloodlust, Mocking Blow, Powershot, Tripwire); GS: *"the sim bot cannot see most of the 29 outside their rotations"* |
| 6 | *"Tripwire goes BACK to the Hunter pool"* | **"BACK" DOES NOT HOLD — IT HAS NEVER BEEN IN ONE** | Tripwire was a Survivalist opening card from its authoring until GN made it a class-kit card, and a kit card is in no pool (`check_gn` §0). It enters the pool for the first time, on the shelf of the lineage that defines it |
| 7 | *"GS's rule: a card that stops travelling must land somewhere"* | **HELD** | `CLAUDE.md`'s charter block: *"A CARD THAT STOPS TRAVELLING LANDS ON ITS LINEAGE'S SHELF … NEVER NOWHERE"* |
| 8 | *"GS listed them as the one stated exception to an engine brings only what it cannot run without"* | **HELD** | `PROTECTED_CORES["beastmaster"]`'s comment: *"RULED (GS §1): the stated exception"* |
| 9 | *"Pack Bond … DEEPENS the bond — Loyalty, its conversion at 8, EV's saturation fallback, the Shared Hide"* | **THREE OF FOUR; THE SHARED HIDE IS NOT PACK BOND'S** | Loyalty accrues only through `_gain_loyalty`, which returns without the engine; the conversion (`_bond_convert`) and EV's fallback (`_bond_fallback`, through `_bond_reach`) read it. **The Shared Hide is a rune whose read site is the companion's blow** (`_shared_hide_mult`) and reads no engine — GV sorted it into its CARD group, *"a companion"*. It is a companion reader (§3) |
| 10 | *"Cards and runes that need a companion were gated on Pack Bond because only Pack Bond brought one"* | **DID NOT HOLD AT EITHER LAYER** | GP gated the BOND readers on Pack Bond (Unleash, Bring It Down, Last Howl, Succession, Ghostpack) and left every card that needs only a companion ungated — Kill Command, Twin Hunt, Savage Sweep, Bloodbond, Bear the Brunt, Call the Wilds — because an earned Call the Wilds gave any Hunter one. GV did the same for runes: the Long Leash and the Shared Scent are Pack Bond rows; the Shared Hide, the Bared Fang and the Answering Pack are in its CARD group and the Second Whistle in HALF. **So nothing that needs only a companion was gated on Pack Bond, and the gated set did not move** — which is the brief's own *"this generalises GS's Kill Command"* |
| 11 | *"GS found Kill Command already offered to any Hunter because a drafted Call the Wilds gave a companion"* | **HELD** | `CLAUDE.md`'s GK/GS charter block, GM §2's bullet |
| 12 | *"FT found `second_resource` is already three currencies in one field"* | **HELD** | FT's report: *"`second_resource` IS THREE CURRENCIES, NOT FOUR"* (Mercy, Resonance, Focus; FK §4 wrote the carry rule off it) |
| 13 | *"every unblocked hit raises the Warden's Block and a block resets it"* | **HELD, AND IT HAS A CAP THE BRIEF DOES NOT GIVE THE PITY METER** | Heavy Plating climbs +8% an unblocked hit to **+40%** and any Block resets it (the Standing Wall halves, Anvil holds). The brief states no cap for the new meter and none was written: the reset governs (§4d) |
| 14 | *"EW made crit chance above 100% convert to multiplier at 0.50"* | **HELD** | `battle.CRIT_EXCESS_STEP` 0.50, ruled at EX |
| 15 | *"GV's gate reads is an engine equipped"* | **HELD** | `Runes.offerable` / `Classes.offerable`: `e == "" or engines.has(e)` |
| 16 | *"a kit card it cannot cast is the failure GN found four times"* | **HELD** | premise 5's four |

---

## §1 — SUMMON COMPANION IS ONE SPELL

### §1a — How the choice is presented

**One card on every surface that lists cards, and the fight's picker where the choice is made.**

- **In a fight** the card is the *Summon Companion ▸* entry on **W** — the entry the three summons already shared
  (`_show_actions` groups every `summon` ability into one menu slot, and did before HB). Pressing it opens the picker:
  three buttons, **Summon Ursus**, **Summon Canis** and **Summon Aguila**, each with its call's own price, its own
  tooltip (the companion's words: its blow, its arrival, its gift) and its own cooldown; **Tab** cycles, **Space**
  summons, **X** closes. The three calls are built by one function, `battle._summon_choice`, off each companion's one
  definition at the CARD's price, so an upgrade on the card moves all three.
- **At capacity** the same entry reads *Swap Companion ▸* and the picker offers **Swap Ursus / Canis / Aguila** at
  10 Mana and 1.0 initiative on one shared 3-turn cooldown — unchanged.
- **Everywhere else** — the hero sheet, the Kit panel, the class-selection card — it is one row, **Summon
  Companion**, with the card's own text: *"Call a companion to fight beside the Hunter: Ursus, Canis or Aguila,
  chosen at the cast. With one standing, casting it again swaps in another."*
- **The Sharpshooter** has no entry on W — his Powershot and Snare Trap take W and E — and the lineage choice screen
  says what he opens without (*"Opens without: Summon Companion"*).
- **The cooldown is kept per companion**, as three cards kept it: a call is cast under its own name, and a name keys
  a cooldown, so a bear called this turn leaves the wolf and the eagle ready. **It cannot matter in play today**: with
  one companion standing the picker offers swaps, and nothing live raises the cap above one — `the_pack`, the old
  capstone that did, has no writer since the trees merged (only suites set it by hand). The card itself is a menu entry and never a cast: `_ability_usable` refuses a summon
  that names no companion, and the handler warns and summons nothing if one is resolved past that door.

### §1b — It works for the player and for the bot, driven

**The player** (`hb_player`, a probe on the finished tree): a Tracker's turn parked on the action bar, the bot off.
**W** is the summons group holding Summon Companion; pressed, it opens the picker with **Summon Ursus, Summon Canis and
Summon Aguila at 20 Mana and 3.0 each**; Tab to the wolf, Space — Canis stands, its call on cooldown under its own
name. At his next turn **W at capacity opens Swap Ursus, Swap Canis and Swap Aguila at 10 Mana and 1.0**; Space on the
bear swaps it in, *Swap Companion* on its shared 3 turns. **A Sharpshooter's W is Powershot, and no picker opens.**

**The bot** (`hb_bot`): the real turn loop on autoplay, a Hunter holding one engine and nothing else, 24 of his
turns against a warband refilled so it never falls, one stretch per engine:

| engine | kit cards cast | a companion stood | companion strikes | summon / swap lines |
|---|---|---|---|---|
| Pack Bond (the Beastmaster's) | Summon Companion, Snare Trap, Powershot | yes | 14 | 1 |
| the Survivalist's | Summon Companion, Snare Trap, Powershot | yes | 16 | 2 |
| the Tracker | Summon Companion, Snare Trap, Powershot | yes | 16 | 2 |
| the Skirmisher | Summon Companion, Snare Trap, Powershot | yes | 16 | 2 |
| the Medic | Summon Companion, Snare Trap, Powershot | yes | 15 | 2 |
| **Lethal Aim (the Sharpshooter's)** | **Snare Trap, Powershot** — no summon attempted | **no** | 0 | 0 |
| the Survivalist's, carrying a drafted Tripwire | all three and **Tripwire** | yes | 12 | 2 |
| Lethal Aim, carrying a drafted Tripwire | Snare Trap, Powershot and **Tripwire** | no | 0 | 0 |

The rotation summons first for every Hunter and the class branch has the same case for the card it owns, both through
`_summon_choice`. **A drafted Tripwire needed a fix to be cast at all**: the drafted hook only admits cards that
`Classes.draft_ability` defines, and Tripwire's one definition stays in the Survivalist's table — the reason GS's
twenty-nine returned cards are invisible to that hook. It is let through by its special, the one of them the hook has
a case for, so HB's move does not undo GN's *"the bot casts Tripwire"*. The other twenty-nine stay GS's finding.

### §1c — What crosses a swap, and whether it matches the three separate cards

**The same thing crosses it on both trees: the bond, not the body.** Driven identically on this tree and on HEAD's
(an isolated copy at `68aee95`, the three separate cards): summon Canis, wound it to half, lay Exposed on it, give
it 2 Loyalty; swap to Ursus through the picker's own swap clone; swap back.

| | HEAD (`68aee95`, three cards) | HB (one card, three calls) |
|---|---|---|
| the three calls | Summon Ursus / Canis / Aguila — 20 Mana, 3.0, cd 3 each | **the same** |
| Canis summoned | Loyalty `{canis: 1}`; *Summon Canis* on cooldown 4 | **the same** |
| the wolf before the swap | 40 / 80, *elusive, loyalty, exposed*, 3 Loyalty | **the same** |
| swap to Ursus | 10 Mana, 1.0; `{canis: 3, ursus: 1}`; *Swap Companion* 3 | **the same** |
| **the wolf swapped back** | **80 / 80, *elusive, loyalty*, 4 Loyalty** | **the same** |

**Every line the drive printed is byte-identical on the two trees** (a Beastmaster holding Pack Bond on both, since
HEAD's summons were his alone). The per-engine drive (`hb_drive`) adds the rest: on every engine that fields a pet the
companion strikes beside the basic, the picker at capacity offers the three swaps at 10 / 1.0, and a wolf swapped back
returns at full health with its own chips — at the Loyalty it left with, plus one only under Pack Bond.

- **Loyalty carries**, per companion: it lives on the Hunter (`loyalty[kind]`), not on the body, and a companion
  swapped back in finds its meter where it left it. **With Pack Bond it gains 1 on arriving; without it gains
  nothing** — Loyalty grows only through `_gain_loyalty`, which is Pack Bond's (§3), and the swap tooltips now say
  *+1 Loyalty* only to its holder.
- **Health does not carry**: the companion returns a fresh body at full health.
- **Statuses do not carry**: Exposed is gone; the companion's own arrival statuses (Elusive, its Loyalty chip) are
  stamped anew.

---

## §2 — THE KIT, AND WHERE TRIPWIRE WENT

- **`Classes.CLASS_KITS["hunter"]` = Powershot · Snare Trap · Summon Companion.** Summon Companion is a class-kit card
  defined in `Classes.class_kit_ability` (the second, after GN's Magic Burst), tagged OFFENSE / BREAK (ruling 7),
  protected at the bench door like every kit card.
- **Tripwire is on the Survivalist's shelf** (`SPEC_DRAFT_POOLS["mystic"]`). It was never in a pool — the
  Survivalist opened with it until GN made it a kit card — so it enters one for the first time, on the shelf of the
  lineage that defines it, by GS's rule that a card that stops travelling lands there and never nowhere.
- **Where it landed, read off the live tables** (`corpus`): the draft is **179** — **159** spec + 20 class-wide —
  in pools of **43 / 51 / 43 / 42**; the Survivalist's shelf **12**, and the **Warden's 11 the shallowest alone**; the
  corpus **229** (Summon Companion is its one addition; Tripwire and the three summons are all still in it). A Hunter
  holding no engine is offered **35** of the 42 — Tripwire among them, it reads no engine — Pack Bond's holder 40, a
  Sharpshooter **31**. The engine-read population is still **37** of the 179.
- **The bot casts it where it is now**: the drafted hook names a drafted Tripwire when a melee enemy stands and no wire
  is rigged, the test the class branch gave it as a kit card (§1b's stretch, and `check_gn` §4's arm).

---

## §3 — PACK BOND BRINGS NOTHING; WHAT READS A COMPANION AND WHAT READS THE BOND

**`PROTECTED_CORES["beastmaster"]` is slots 0, enablers none**, with the `why` *"Pack Bond reads a living companion,
and every Hunter but the Sharpshooter summons one from the class kit's Summon Companion. The engine brings nothing: it
makes the bond grow."* GS's stated exception is retired and recorded as retired in `CLAUDE.md`'s charter block.

**A COMPANION NOW FIGHTS FOR EVERY HUNTER.** The strike beside the Hunter — the companion's blow at his target after
his own — sat inside `has_engine("pack")` in `_resolve`, written when only Pack Bond brought a pet; until HB a Hunter
who called one with an earned Call the Wilds had a companion that stood beside him and never struck. The condition is
the Hunter's blow now; **inside it the Ghost Pack node and the Ghostpack card stay Pack Bond's**. Driven: the
companion strikes beside the basic for every one of the five engines that field one (§1b).

**WHAT PACK BOND DEEPENS, READ AT THE READ SITE:** the three boons (`_bond_reach` returns 0 without the engine —
Savage Presence's pull and cover, Canis's wounded-prey bonus, Aguila's party crit), Loyalty's growth
(`_gain_loyalty`), the conversion at 8 (`_bond_convert`) and EV's fallback (`_bond_fallback`). **The Shared Hide is not
among them** — premise 9: it is a rune whose read site is the companion's blow and it reads no engine.

**THE TWO LISTS, RE-DERIVED AT THE READ SITE.** Every card a Hunter can earn — the class pool and the three Hunter
lineages' boss pools, 60 cards — was cast by `hb_derive` on one board and one seed per arm: **PACK+PET** (Pack Bond,
Canis standing at 4 Loyalty earned through `_gain_loyalty`), **PACK** (Pack Bond, no companion) and **PET** (the
Tracker's engine, Canis standing, no Loyalty). A card refused in PACK and usable in PACK+PET is refused at the door with
no companion; a card that casts in PACK and moves nothing off the caster is silent without one, and is read at its
handler, because a status laid now may pay on a later event.

**1. THE CARDS THAT READ A COMPANION — offered to every Hunter who fields one, withheld from the Sharpshooter
(`Classes.COMPANION_READ`, fourteen):**

| | cards | how it was found |
|---|---|---|
| refused with none standing (`door`) | **Kill Command, Twin Hunt, Savage Sweep, Bestial Wrath, Spirit Bond, Ghostpack, Unleash, Primal Surge** | the PACK arm refused every one of the eight, and PACK+PET cast it |
| fields one | **Call the Wilds** | it casts with no companion — it brings one — so the summon door refuses it to a dismisser (ruling 3) and it sits out for him like a door row |
| silent without one | **Bloodbond, Bear the Brunt, Bring It Down, Last Howl, Succession** | cast and moved nothing in PACK; each pays on an event a companion is party to — the blow meant to fell it, the deepest bond, a fall, a swap — read at the handler |

**THE OTHER FIFTEEN SILENT CARDS WERE READ, NOT ASSUMED** — the survivors of a classification are where its misses
land. Hunter's Instinct, Fault Line, Dug In, Hold Breath, Preparation, Stalking Horse, Downwind, Thick Hide, Salve,
Tripwire, Camouflage, Arcane Arrows, Quick Draw, Venom Coating and Deadfall are buffs on the caster, marks and traps
whose effect lands on him or on a later event; **none reads a companion.** Hunter's Instinct half-works — its +10%
Attack pays with none, its companion heal only with one — and by GP's groups a card that half-works is not a row.

**2. THE CARDS THAT READ THE BOND — still gated on Pack Bond, and HB moved none of them:** at the offer (`ENGINE_READ`)
**Unleash, Bring It Down, Last Howl, Succession, Ghostpack**; at the seat (`SITS_OUT`) **Unleash, Primal Surge**. The PET
arm confirms three of them: with a companion and no Pack Bond, **Unleash and Primal Surge are refused, and Bring It Down
casts and moves nothing** where PACK+PET laid its statuses on the party — *"no bond deep enough to call on"*.
Ghostpack's cast moves nothing on any arm — its strike rides the strike-alongside — and it is read at that handler,
where HB kept it inside `pack_bond`; Last Howl and Succession pay on a fall and a swap, and are read at theirs. **The bond rows are in the companion table too**,
because a bond needs a companion as well as the engine: a hero holding Pack Bond and Lethal Aim has none (ruling 6).

**3. THE RUNES THAT READ A COMPANION — `Runes.COMPANION_READ`, six, every field traced to its read site:** **the Shared
Hide** (the companion's blow reads the buffs it wears — `_companion_hit`), **the Bared Fang** (+30% to that blow, paid in
its heals — `_companion_hit`, `_do_summon`), **the Answering Pack** (the deepest bond takes the Hunter's lethal blow —
`_on_brunt_guard`, which stands down with none), **the Second Whistle** (a summoned companion arrives with 3 Loyalty —
`_do_summon`), and Pack Bond's two, which read the bond as well: **the Long Leash** (the split point) and **the Shared
Scent** (a fallen companion's Loyalty carried on — `_on_beast_death`, spent at `_do_summon`). **The first four are
ungated** — GV sorted three of them into its CARD group, *"a companion, which Call the Wilds fields with no engine"*, and
the Second Whistle into HALF — **and the last two stay Pack Bond's `ENGINE_READ` rows.** The Beastmaster's four other
companion runes (the Deep Bond, the Turning Pack, the Loosened Straps, the Shared Wild) are retired since ET §1.

---

## §4 — THE SHARPSHOOTER DISMISSES THE PET

**Only the Lethal Aim engine does** (`Classes.PET_DISMISSERS`). A Hunter holding it opens without Summon Companion,
fields no companion by any route (ruling 3), and is paid three ways: the slot, the multiplier and the meter. **Focus is
kept, untouched.**

### §4a — The slot, driven in a real spawn

A Sharpshooter's kit is **two slots** (Powershot, Snare Trap) against every other Hunter's three, so a full bar
holds **five drafted cards**: spawned through the battle's own door with Aimed Shot, Called Volley, Crossfire, Trophy
Shot and Kill Command, he reads **7 of 7**, and the fight seats the four that need no pet — **Kill Command sits out**,
still counted, with the note *"Sits out of every fight while the Rune of the Sharpshooter is equipped, which
dismisses the companion it needs. Still carried: the slot stays counted. Benching the card frees the slot."* The same
member with the rune unslotted — built by hand, the state the pouch refuses to reach — reads **8 of 7**: Summon
Companion back in the kit and Kill Command seated again. That is the overfill the refusal below exists to stop.

**Unslotting the rune with every slot full is refused (ruling 4).** Dropping Lethal Aim puts Summon Companion back in
the kit, and a kit card counts against the cap, so a full bar would become an overfull one — a cap one route can walk
past is not a cap (EG). `Run.engine_toggle_refusal` is the one answer; `Run.toggle_engine` asks it and the map's pouch
disables the button with its text as the tooltip: *"Unequipping it returns Summon Companion to the kit, and every slot
is full. Bench a card first."* Driven: refused at 7 of 7 with the rune still equipped; accepted after one card is
benched, and the count is 7 again with the pet back.

### §4b — The multiplier

`lethal_crit_mult()` = `2.0 + SHARPSHOOTER_CRIT_MULT + 0.01 × (Executioner's Eye − Consistent Aim) + Focus's share`,
with `SHARPSHOOTER_CRIT_MULT` = **0.50**: ×2.5 on an empty meter, ×3 at 200 Focus, ×3.5 at 300, ×4 at 400. It is the
one implementation the strike loop, the nameplate and the sim read, so all three moved together. **Read as +0.50 of
multiplier (ruling 1).**

### §4c — The pity meter: where it lives, and what "lands" means

- **Where it lives.** `BattleUnit.crit_pity` — a field of its own, never `second_resource`, which is already three
  currencies (FT). **Built the way Heavy Plating is**: one field on the unit, one writer (`battle._note_pity`, called
  from `_resolve`'s strike loop below every source of `is_crit`, so a forced crit resets it like a rolled one), read into
  the same total the roll spends (so EW's surplus above 100% sees it), and a chip — the Lethal Aim status shows
  *"Aim +N%"* and says what it is. Step: `BattleUnit.PITY_CRIT_STEP` = 0.05. Reset: any crit, to zero. **Kept through a
  target switch** — Focus clears on a switch and this does not, so a Sharpshooter forced off his mark loses his Focus
  and keeps this.
- **"Lands" is BR §1's word for a charge, not a new one** (`docs/combat-rules.md`): a strike that MISSED or was
  BLOCKED spends nothing, and neither does one an absolute parry zeroed. Read at the code: a missed or blocked strike
  `continue`s out of the strike loop before the crit roll, so `_note_pity` is never called for one; an absolute parry
  reaches it and is refused there. **Only a blow that deals damage counts** (`ab.damage > 0`).
- **An area attack counts once per enemy it strikes**, because that rule counts hits and the strike loop resolves one
  blow per target: Called Volley on three enemies landing three non-crits is +15%. **A multi-hit card counts once per
  hit** (Triple Shot's three arrows are three landings). **His multi-press basic counts once**: the sequence's presses
  pay Focus, and the blow is resolved once, off the first press's grade.
- Driven (the pity arms of `hb_drive`, on the finished tree): four basics that landed without a critical → +20%; a
  critical → 0, with the log's *"the critical resets the +20% the misses built"*; Called Volley landing on three enemies
  → +15%; six blinded basics of which four missed → +10% (two landings); the chip read *"Aim +25%"*.

### §4d — A deep Sharpshooter at turn 10, and whether the reset stops the meter reaching certainty

**DRIVEN, NOT ASSUMED** (`hb_turn10`, a probe on the finished tree): a Sharpshooter holding Lethal Aim, played by the
bot through ten of his turns against one mark whose health is refilled so it never falls, twelve fights on twelve
seeds, sampled at the start of each of his turns. **BARE** is Lethal Aim and nothing else; **DEEP** is his lineage with
every crit and Focus source he can hold with no pet — More Crit Chance (+15%), the Glass Rune (+8%), the Deep Sight
(Focus converts 8 sooner, +20 Focus a critical) and the Long Draw (opens on 60 Focus, +10 an attack).

| at the start of his turn | Focus | chance from Focus | the meter (mean; range over 12 fights) | multiplier | total crit chance on his mark |
|---|---|---|---|---|---|
| BARE, turn 4 | 48 | +24.0% | +7.1% (0–10%) | ×2.50 | 41.1% |
| BARE, turn 7 | 106 | +47.8% | +2.5% (0–15%) | ×2.55 | 60.3% |
| **BARE, turn 10** | **211** | **+50.0%** | **+2.9% (0–10%)** | **×3.06** | **62.9%** |
| DEEP, turn 4 | 142 | +46.0% | +1.3% (0–5%) | ×2.75 | 80.2% |
| DEEP, turn 7 | 276 | +46.0% | +0.4% (0–5%) | ×3.42 | 79.4% |
| **DEEP, turn 10** | **406** | **+46.0%** | **+1.3% (0–5%)** | **×4.07** | **80.2%** |

(Identical consecutive rows in the probe's print are real: a Snare Trap turn deals no damage, so it moves neither Focus
nor the meter.) **The meter does its work early, before Focus arrives** — +7.1% on a bare Sharpshooter's fourth turn,
when his chance is still 34% without it — **and fades as Focus lifts the base**, because a higher chance crits sooner
and resets it. It never read above +15% in 240 sampled turns.


**THE ARITHMETIC, AT A FIXED BASE.** Over landed hits the meter is a Markov chain: from pity *k*, a hit crits with
probability `min(1, base + 0.05k)` and resets, or does not and climbs. Its long-run figures:

| base chance | hits from 0 to certainty | mean pity at a roll | crit rate per landed hit (base alone) | P(a streak from 0 reaches certainty) |
|---|---|---|---|---|
| 10% | 18 | +12.1% | **22.1%** (10%) | 2.4 × 10⁻⁸ |
| 20% | 16 | +9.2% | 29.2% (20%) | 3.2 × 10⁻⁸ |
| 35% | 13 | +6.0% | 41.0% (35%) | 7.6 × 10⁻⁸ |
| 60% | 8 | +2.7% | 62.7% (60%) | 1.6 × 10⁻⁶ |
| 73% | 6 | +1.6% | 74.6% (73%) | 1.7 × 10⁻⁶ |
| 85% | 3 | +0.8% | 85.8% (85%) | 7.5 × 10⁻⁴ |

**Does the reset stop the meter reaching certainty? Not absolutely, and it does not need to.** Certainty is
reachable — a streak of *k* landed non-crits — but the lower his chance, the longer that streak is, so the meter is
worth most exactly where a streak is least likely to finish: at a 10% base it more than doubles his crit rate and
reaches certainty about once in forty million streaks. At a high base the streak is short and certainty is reachable
(one streak in 1,300 at 85%), and there the meter adds under one point, because he crits before it climbs. **At the
tenth-turn bases above**, before the meter: the bare Sharpshooter's 60% needs eight straight landed non-crits from zero
— once in about 635,000 streaks — and the deep one's 79% needs five, once in about 451,000. **The hit
that reaches certainty crits and resets it**, so the meter never sits at certainty. Above 100% the surplus becomes
multiplier at EW's 0.50 like every other term.


### §4e — THE NEGATIVE GATE: WHAT IT LOOKS LIKE, AND WHY GV'S MACHINERY COULD NOT HOLD IT

**GV's gate asks one question: is the engine this card needs equipped?** `ENGINE_READ` is a table of rows
`{engine, why}` — one engine a card or rune cannot pay without — and `offerable` reads `e == "" or engines.has(e)`.
**The Sharpshooter's question is the opposite shape.** *Is a pet present* is *no engine that dismisses one is
equipped*: a negative, over a set, about an engine the card does NOT name. A row that holds the one engine a card
needs has nowhere to write the engine that kills it, and writing `"engine": "not lethal_aim"` would teach every door
that reads the field a second grammar. **So GV's machinery cannot express it, and it is not stretched to.**

What it looks like instead — **one predicate and two small tables, asked by the doors GV already built:**

| piece | where | what it answers |
|---|---|---|
| `Classes.PET_DISMISSERS` = `["lethal_aim"]` and `Classes.dismisses_pet(engines)` | `classes.gd` | THE ONE ANSWER to *does this hero field no pet*. Every door below asks it, so a second dismissing engine is one list entry |
| `Classes.COMPANION_READ` (14 cards, each with `door` and `why`) and `reads_companion` / `companion_door` | `classes.gd` | which cards need a companion; `door` is true for the nine the usability door refuses with none standing |
| `Runes.COMPANION_READ` (6 runes) and `reads_companion` | `runes.gd` | the same, one layer up |
| `Classes.offerable` / `Runes.offerable` | the offer doors (draft, zone-boss fallback; Peddler, cache, bargain, event verb, a queued offer's answer) | beside the engine test: `not (reads_companion(n) and dismisses_pet(engines))` |
| `Classes.sits_out` | the seat door (`Run.seated_ability_names`) | a card whose `door` is true sits out of every fight while he holds the dismisser — GT §3's rule: kept and counted, never destroyed |
| `Runes.sits_out` | GX's tell: the pouch, the map's rune slot, the hero sheet, the battle's roll call | a rune row says it sits out; its payload is still applied at the spawn (GV's refusal is at each read site) and has no companion to pay into |
| `Run.sits_out_note` / `rune_sits_out_note`, `Runes.empty_offer_reason` | the pouch, the hero sheet, the roll call, an empty offer | say WHICH rune dismissed the pet (*"Rune of the Sharpshooter is equipped, which dismisses the companion it needs"*) |
| `battle._ability_usable` | the summon door | refuses `summon` and `call_wilds` to a dismisser on every route; the tooltip says why |
| `Classes.class_kit_names_for` / `class_kit_for` / `kit_slots` | the kit | the class kit less the pet, read off the engines he holds |

**Every negative is paired with its positive**, in the gates and in the drives: withheld from the Sharpshooter beside
offered to the Tracker holding the same pool (31 against 35 of 42); sitting out with Lethal Aim beside seated with it
unequipped (§4a); no picker on W for him beside the three calls for every other engine (§1b).

---

## §5 — WHAT WAS DELIBERATELY NOT DONE

- **No other engine dismisses the pet.** `PET_DISMISSERS` is one entry.
- **The Mage pool is not split**, and no other kit, engine, pool or node moved. Tripwire's move is the only pool change,
  and it is the brief's.
- **Companion runes and a new companion are queued, not authored.** The six live companion runes are unchanged in
  effect; the Second Whistle's words name the card (`data/runes.json`), because the three cards they named are one.
- **The rune scopes are HC**, and HA's twenty holes and the fold family are HD, as the brief orders. Nothing HA priced
  was repaired here except where HB's own move reached a gate.
- **The zone boss's tier-1 draw was left asking no door** (ruling 5), and **Pack Bond is still offered to a Lethal Aim
  holder** (ruling 6): both are rulings, not implementation calls.
- **The three summons keep their definitions, their words and their tags** — they are the calls, and `check_dr` §1
  asserts they are still the Beastmaster lineage's three. Only Ursus's text moved: it named Savage Presence as the
  bear's own, and it is the Pack Bond boon, which Canis's and Aguila's texts already said of theirs.

---

## §6 — THE UNMODIFIED GATES AGAINST THE NEW TREE, AND EVERY REPAIR

**HEAD's battery ran first, unmodified, against the new code with HEAD's documents** (`../recon1`, 121 of 121
launched, the tree hashed at the start and at the end — 425 paths, none moved). Every red and every count that left
its band is below, with its cause read off the FAIL text or, for a count that moved with no red, off an `ok()` trace —
each suite's assertion helper instrumented in two out-of-repo copies, HEAD's and this tree's, and the multisets of
assertion messages diffed. **Nothing was repaired until the whole run was read.**

| target | HEAD's gate on HB's code | what it caught | what was done |
|---|---|---|---|
| `test_batch_az` | 450 / **16** | the Focus multiplier table at ×2 where it is ×2.5, and a source pin on `lethal_crit_mult`'s old line | **re-pointed**: the eleven figures (×2.5 / ×3 / ×3.5 / ×4 by Focus; the Eye, the pair, Opening Volley), the damage band widened to the ×2.5 spread, the pin to the new line — 450 |
| `test_batch_bb` | 173 / **2**, **4 throws** | `_find_ability(h, "Summon Ursus")` finds nothing: the Hunter holds one card now | **re-pointed** through `_summon_choice`, the helper the picker and the bot build the calls with — 173 |
| `test_batch_bo` | 1,308 / **2** | §2: *"Pack Bond needs a beast — all three summons are protected"* and the one-bar-entry arm | **re-pointed**: Pack Bond's core is empty and the pet card is the kit's. The count is the trace's: nine per-enabler arms left with the summons and six arrived with Tripwire's shelf row — 1,308 |
| `test_batch_bv` | 562 / **3** | the Beastmaster's summons as his core (two arms) and the draft needle | **re-pointed**: the three calls are the kit card's and none is draftable in any class pool; one bar entry, the kit's third — 562 (three per-enabler arms left with the summons) |
| `test_batch_cd` | 99 / **5** | `PER_SPEC_DEPTH`'s Survivalist at 11, the spec half 158, the draft 178 — the tripwire the table exists to be | **re-pinned**: Survivalist 12, 159, 179, with the reason; and `classes.gd`'s draft header, which it reads, to *"OF A TARGET 179"* — 99 |
| `test_batch_ce` | 859 / **1** | the draft needle; and 83 fewer checks — its no-enabler-in-any-pool sweep ran 28 checks per enabler and lost the three summons (−84), and its names sweep gained Tripwire (+1) | **re-pointed**: the sweep reads the enablers AND the pet card's three calls, so a summon in any draft or boss pool still reds it — 946 |
| `test_batch_br`, `bu`, `cb`, `bw`, `check_do` | 1 each | `master.html`'s live draft — *"179 of 179"*, *"hundred and seventy-nine"* | **the documents**, not a repair. `bw` also lost the three per-enabler arms (503), `cb` gained Tripwire's names arm (1,970) |
| `test_batch_au` | 296, green | — | **+1**: its sibling-shelf sweep walks Tripwire (*"beastmaster does NOT hold sibling-spec entry Tripwire"*). Row moved |
| `test_batch_bp` | 441, green | — | **−3**: its every-enabler-out-of-every-draft-pool loop lost the three summons; its 175 sampled-offer arms read 175 on both trees. Row moved |
| `check_dr` | 81 / **1** | *"Summon Companion carries `special: summon` and belongs to OUTSIDE THE BEASTMASTER'S CORE"* — HA's summoning question (c), answered by the designer | **re-pointed**: exclusive to the Hunter class — the three definitions the Beastmaster's, the one card the Hunter kit's and no other class's, with a positive arm on each — 83 |
| `check_ed` | 18 / **1** | `test_batch_az`'s pin on the old multiplier line | **`pin-manifest.json` re-derived**: 1,494 pins, residency unchanged, the one entry that moved is that pin |
| `check_eh` | 153 / **1** | *"6 named enablers across 6 lineages, not the nine across seven"* | **re-pinned** at six across six, with the reason — 153 (three per-enabler arms left with the summons) |
| `check_es` | 57 / **3** | the core-kit census: DEBUFF met at 2+ by **five** lineages, and three documents saying six | **the documents** — ruling 7 |
| `check_fd` | 51 / **1** | 54 rows read `[OFFENSE, BREAK]` where FD's reconstruction counts 53 | **re-pointed**: the rows authored into that shape since FD (`AUTHORED_SINCE_FD`, Summon Companion) are held apart, pinned at one and asserted to read the shape — 52 |
| `check_fe` | 78 / **1** | the card OFFENSE column at 71, FD's 70 | **re-pinned** at 71: a row authored, BREAK-first still zero — 78 |
| `check_gm` | 149 / **1**, **2 throws** (+1: a new arm walks Tripwire as a Survivalist shelf card) | the board's summon cast the CARD, which names no companion (`COMPANION_STATS["companion"]`), and *"a drop frees no slot"* read the Sharpshooter's 2 and 3 as a drop | **re-pointed**: the board fields the wolf through `_summon_choice`; the slot arm reads the held count as the dropped one less the card the engine dismisses. **And the game guards it**: the summon handler warns and summons nothing for a summon naming no companion — 149 |
| `check_gn` | 196 / **7** | the Sharpshooter's kit and protected list without the pet; *"the hunter holds Tripwire"*; the class branch naming Summon Canis for Tripwire, Snare Trap and Powershot; the live stretch never seeing *"Summon Companion"* | **re-pointed**: the kit a hero holds reads his engines; Tripwire driven as a drafted card; the Hunter's picks are the pet (by its call), Snare Trap, Powershot; the live stretch reads the calls' cooldowns. **Four arms added**: Summon Companion driven on a hero with no engine (picker, fielded, strikes beside the basic) and the drafted hook naming a drafted Tripwire — 204 |
| `check_go` | 401 / **4** | *"the Hunter holds Tripwire"* (§9, twice); a parked Sharpshooter with no Tripwire to answer with, and the stretch silent after it (§12) | **re-pointed**: Tripwire seated as a drafted card on all three boards — 401 |
| `check_gp` | 431, green | — | **−21, a drawn measurement**: §4 asserts one arm per distinct card a whole seeded road offers a hero with no engine, and HB changes what consumes the RNG on that road — 65 offered cards on HEAD, 43 now — and §4b walks Tripwire (+1). Row moved |
| `check_gq` | 5,019 / **33** | the Sharpshooter's engine card read as replacing the class basic: its *"Opens without: Summon Companion"* line fails the exact-text arm, the replaced-basic arm and the list arm in each of the ten deals that draw it (thirty) and three §0 arms | **re-pointed**: a dismissed pet is not a replaced basic — the card's two lines are read apart and the dismissed card is held to the dismissing engine exactly — 5,018 |
| `check_gs` | 751 / **16** | Pack Bond's MINIMUM row, the pet leaving the Sharpshooter's kit, five carrying engines, twenty-three threes, and the summons with no home among enabler, kit and shelf | **re-pointed**: Pack Bond's row retired; the pet the one thing an engine may take; five carry; 23 threes and one two; a fourth home — a call of the kit's pet card — and 30 returned (Tripwire the thirtieth) — 732 |
| `check_gu` | 318 / **4** | Bola, Quarry's Mark, Hold Breath and Mark of the Hunt below Summon Companion as well as Snare Trap | **sorted, GU's rule**: all four below it only through the catch-all role (none is a summon); nothing retuned — 321 |
| `check_gv` | 877 / **1** | *"a beastmaster holding lethal_aim second is offered 0 of his runes, not 6"* | **re-pointed**: a second engine offers his own runes less those needing a companion when it dismisses the pet — HB's rule, ruling 6's case — 877 |
| `check_gx` | 1,130 / **5** | four ungated runes sit out beside Lethal Aim | **re-pointed**: they sit out on a set that dismisses the pet and on no other, and they are the four that need a companion — 1,130 |
| `check_gt` | 3,160, green | — | **+3**: its walk of the Hunter pool asserts three arms a card and Tripwire joined the pool (51 cards to 52). Row moved |
| `check_cm_live`, `check_gj` | the sanctioned reds | — | unchanged counts; `check_gj`'s figures moved with the draw, as at GS: *"the card says +173 gold and the purse moved 193"* — still the Bell's 20 |

**THE DOCUMENT NEEDLES** (`test_batch_br`, `bu`, `bv`, `bw`, `cb`, `ce`, `check_do`): seven arms asking
`master.html` to state the live draft — *"179"*, *"179 of 179"*, *"hundred and seventy-nine"* — which it did not until
the documents were written. **They are the batch's documents arriving, not repairs**: each is green against the
finished `master.html` and was red against HEAD's, which is the two-armed control. **`check_es` §4** is the same shape
over a census: it printed DEBUFF at five and read *"six"* in all three documents.

**THE CONTROLS.** Every repaired arm was broken on purpose in an isolated copy of the finished tree — one defect per
copy, the gate re-run, **the FAIL text read and not the count** — and every repair that uses no name HB added was also
run against HEAD's code, where it must red for HB's reason:

| the defect injected | gate | FAIL lines | the first FAIL line, verbatim |
|---|---|---|---|
| `SHARPSHOOTER_CRIT_MULT` 0.50 → 0.00 | `test_batch_az` | 14 | FAIL: 0 Focus reads a multiplier of x2.5 (got x2.00) |
| `_summon_choice` returns nothing | `test_batch_bb` | 2 | FAIL: §1: both summons resolve |
| `_summon_choice` returns nothing | `check_gm` | 0 | — green — |
| Summon Ursus back as Pack Bond's enabler | `test_batch_bo` | 2 | FAIL: §2: Pack Bond needs a beast, and the beast is every Hunter's — the kit's Summon Companion, protected (HB §3) |
| Summon Ursus back as Pack Bond's enabler | `check_eh` | 1 | FAIL: §3: 7 named enablers across 7 lineages, not the six across six HB left the table holding |
| Summon Canis put on the Survivalist's shelf | `test_batch_bv` | 2 | FAIL: the three summons are the Hunter kit card's three calls, and none of them is draftable (HB: no longer the Beastmaster's core) |
| Tripwire taken off the Survivalist's shelf | `test_batch_cd` | 5 | FAIL: mystic drafts 11 (want 12) |
| the pet card in the Warrior's kit | `check_dr` | 2 | FAIL: Summon Companion carries `special: summon` and belongs to OUTSIDE THE BEASTMASTER'S CORE, not the beastmaster or the Hunter's kit |
| Snare Trap re-tagged `[OFFENSE, BREAK]` | `check_fd` | 1 | FAIL: §2: 54 rows read `[OFFENSE, BREAK]`, not the 53 that moved into that shape — the reconstruction is not exact |
| Snare Trap re-tagged `[OFFENSE, BREAK]` | `check_fe` | 1 | FAIL: §1: the card OFFENSE column reads 72, not FD's 70 and HB's one more |
| Summon Companion re-tagged `[OFFENSE, DEBUFF]` | `check_fd` | 1 | FAIL: §2: 0 of the 1 rows authored into `[OFFENSE, BREAK]` since FD read that shape — HB's Summon Companion is the one |
| `PET_DISMISSERS` emptied | `check_gs` | 1 | FAIL: §0: 24 of 24 engines open on three slots and 0 on two — twenty-three and the Sharpshooter's one |
| the strike beside the Hunter back inside `has_engine("pack")` | `check_gn` | 1 | FAIL: §1: ...and it strikes beside the Hunter's basic with no engine held |
| the class branch's pet case switched off | `check_gn` | 1 | FAIL: §4: on a board it has work on, the class branch names Summon Companion (named Snare Trap) |
| the rune card's *Opens without* line removed | `check_gq` | 10 | FAIL: §1: hunter ["engine_beastmaster", "engine_sharpshooter", "engine_mystic"] — engine_sharpshooter's card reads its rule and what it adds, exactly () |
| Summon Companion priced 25 Mana | `check_gu` | 0 | — green — |
| `Runes.offerable` forgets the pet | `check_gv` | 1 | FAIL: §3: a beastmaster holding lethal_aim second is offered 6 of his runes, not 0 |
| `Runes.sits_out` forgets the pet | `check_gx` | 5 | FAIL: §1: answering_pack is ungated and reads as sitting out (a set with a pet), or beside the dismisser it reads false where it needs a companion |
| a drafted Tripwire made to sit out | `check_go` | 4 | FAIL: §9 (alone): the Hunter holds Tripwire |
| `kit_slots` stops reading the engines | `check_gm` | 1 | FAIL: §2: sharpshooter's slot count is 3 with the engine and 3 without (a drop frees no slot) |
| Summon Ursus put in the Sharpshooter's boss pool | `test_batch_ce` | 1 | FAIL: the Hunter kit's Summon Companion call Summon Ursus is in NO boss spec pool (sharpshooter) |
| Summon Companion priced 5 Mana | `check_gu` | 4 | FAIL: §2: Bola sits below ["Snare Trap"], where its row says ["Snare Trap", "Summon Companion"] |

**ONE CONTROL WAS ARMED THE WRONG WAY, AND IT IS KEPT IN THE TABLE.** Pricing Summon Companion at 25 Mana left
`check_gu` green, because GU's *below* is *no dearer on every axis*: a dearer kit card sits over more cards, never fewer,
so that defect is not one the rows can see. The control in the direction the repair changes — the card at 5 Mana, under
the four rows that name it — is the table's last row, and it reds all four. **And one control reads green on purpose**: `check_gm`'s board
fields its wolf through `_summon_choice`, and with the helper returning nothing the gate stays green — no arm of it needs
that companion, so the repair there is only the end of the throw, and `test_batch_bb` is where the helper is guarded.

**THE HEAD ARM** — the four repairs that name nothing HB added, run unchanged against HEAD's code in an isolated copy:

| repaired gate | on HEAD's code |
|---|---|
| `test_batch_cd` | 9 FAIL — *"mystic drafts 11 (want 12)"*, *"SPEC_DRAFT_POOLS holds 159 entries (got 158)"*, and HEAD's `master.html` and `classes.gd` saying 178 |
| `check_eh` | 1 FAIL — *"§3: 9 named enablers across 7 lineages, not the six across six HB left the table holding"* |
| `check_fe` | 1 FAIL — *"§1: the card OFFENSE column reads 70, not FD's 70 and HB's one more"* |
| `check_fd` | 1 FAIL — *"§2: 0 of the 1 rows authored into `[OFFENSE, BREAK]` since FD read that shape"* |

The rest name `Classes.PET_CARD`, `dismisses_pet` or `_summon_choice`, which HEAD does not have, so against HEAD they
would stop at the first name rather than red for a reason; their other arm is §6's table itself — HEAD's gates, red on
HB's code for HB's reasons.

---

## §7 — VERIFICATION

**EVERY FIGURE BELOW IS READ OFF A LOG OR A HASH, AND THE TREE WAS FROZEN THROUGH EACH RUN.**

| | |
|---|---|
| **the saves** | backed up as the batch's first action (`../save-backups/HB-20260921-045412`) and md5-verified against the live files; **byte-identical after the recon, after every probe, after the pre-pass and after the acceptance run**. The traces, the controls and the finished tree's probes ran in renamed isolated copies; the batch's first drive and the subset runs ran in the tree the way a gate does, every profile pointed at a scratch file |
| **HEAD's unmodified gates, against the new tree** | 121 of 121 launched; `check_de` 501 checks / 35 failures / 8 notices, **every one read** (§6); the tree hashed at the start and the end — 425 paths, none moved |
| **the pre-pass, on the finished tree** | **121 of 121; no red but the two sanctioned ones at their counts** (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *"the card says +173 gold and the purse moved 193"*); **no `Parse Error` and no `SCRIPT ERROR` in any log**; the tree hashed at the start and the end — 425 paths, none moved. `check_de` read 501 / 6 / 10 against HEAD's rows, and **all sixteen are the rows this report moves (§6) and nothing else**. With the rows moved, `check_de` re-read those same logs at **501 checks / 0 failures / 0 notices** — the rows were proved before the acceptance run, not after it |
| **the acceptance run, with the rows** | **121 of 121; `check_de` 501 checks / 0 failures / 0 notices; the two sanctioned reds and no other** (`check_cm_live` 13 / 4, `check_gj` 70 / 1 with the same line); **no `Parse Error` and no `SCRIPT ERROR` in any log**; every count inside its row, the known drifter `test_batch_an` at 6,053 inside its 6,049–6,066; the tree hashed at the start and the end — 425 paths, none moved |
| **the parse floor** | **`Parse Error` on 0 lines in every log of all three runs, every probe and every control**, read off the logs and not off a tally; `check_parse` 195 checks / 0 failures |
| **the needle instrument** | `build_pin_manifest.py --check` **current, 1,494 pins**, re-derived after the gate repairs; the one entry that moved is `test_batch_az`'s re-pointed pin, residency unchanged |
| **the documents' needles** | every string literal of 4+ characters in the 121 targets (14,590) looked up in the five edited documents, raw and whitespace-flattened, before and after: **2 LOST, neither a pin** (a message format in `check_gp`, a word `state.md` no longer says and no gate reads there) and **37 GAINED, none a negative pin** — every negative document assertion in the tree was read by hand (`test_batch_bx`'s *beast* and *party*, `ba`'s banned names, `bs`, `cd`, `az`, `check_dk`) |
| **the two ceilings** | `check_fg` §1: the changelog **152,496 B = 152.50 KB = 148.92 KiB, 247,504 B under the bar**; §2: `CLAUDE.md` **358,552 B = 350.15 KiB, 59.85 KiB under its 410 KiB ceiling**. Neither warns |

---

## §8 — WHAT MOVED

| file | what |
|---|---|
| `scripts/classes.gd` | the Hunter kit (Summon Companion in Tripwire's slot) and its card; Tripwire on the Survivalist's shelf; `PROTECTED_CORES["beastmaster"]` to nothing; the pet helpers (`PET_CARD`, `COMPANION_KINDS`, `PET_DISMISSERS`, `dismisses_pet`, `companion_call`, `class_kit_names_for`, `class_kit_for`, `kit_slots(…, engines)`); `COMPANION_READ` and its two readers, asked by `offerable` and `sits_out`; the card's tags; the Sharpshooter's engine text; Summon Ursus's words; the drafted abilities' header, *"OF A TARGET 179"*, which `test_batch_cd` reads |
| `scripts/unit.gd` | `crit_pity`, `PITY_CRIT_STEP`, `SHARPSHOOTER_CRIT_MULT`; `lethal_crit_mult()` at ×2.5; the Lethal Aim chip's *Aim +N%* |
| `scripts/battle.gd` | `_summon_choice` and the picker built on it; the summon door for a dismisser and for the card itself; the summon handler's guard; the bot's summons (rotation and class branch) and the drafted hook's Tripwire; the strike beside the Hunter out of Pack Bond's check; the pity roll and `_note_pity`; the swap tooltips' Loyalty clause; the roll call's engine-aware note |
| `scripts/run_state.gd` | the kit counted off the held engines; `engine_toggle_refusal` and the pouch's refusal; the sits-out notes naming the dismissing rune |
| `scripts/runes.gd` | `COMPANION_READ` (six runes), asked by `offerable` and `sits_out`; `locked_by_pet`, `dismisser_name`; the empty offer's fourth cause |
| `scripts/map_screen.gd`, `party_screen.gd` | the pouch's disabled toggle with its reason; the notes asked with the held engines |
| `scripts/spec_choice_screen.gd` | *"Opens without: …"* on a rune's card; the kit heading |
| `data/runes.json` | the Second Whistle's words name Summon Companion |
| `data/glossary.json` | Focus's ×2.5 / ×3 / ×3.5; the crit entry's meter; the companion entry |
| `check_dr`, `check_eh`, `check_fd`, `check_fe`, `check_gm`, `check_gn`, `check_go`, `check_gq`, `check_gs`, `check_gu`, `check_gv`, `check_gx` | re-pointed to HB's rules, each with its reason in the file (§6); `check_gn` gains four arms, `check_dr` two, `check_fd` one |
| `test_batch_az`, `bb`, `bo`, `bv`, `cd`, `ce` | re-pointed to HB's rules, each with its reason in the file (§6); `test_batch_ce`'s sweep reads the pet card's three calls |
| `baselines.json` | seventeen rows: the sixteen whose counts moved (§6's table names each move and its cause), each written with its reason before the acceptance run off the pre-pass and its `_obs` reset to the two readings behind it; and `check_gj`'s note, re-figured (*+173 / +193*). Dumped at `indent=1`, so the diff is those rows and nothing else (52 lines each way) |
| `pin-manifest.json` | re-derived after the gate repairs (`build_pin_manifest.py`) |
| `CLAUDE.md` | the standing rule *EVERY HUNTER HAS A PET, AND ONLY THE SHARPSHOOTER DISMISSES IT*; the charter's summon sentence recorded as HB's; the kit, core, draft, GP, GV and DR §1 facts; ES's census figure. **+7,109 B: 358,552 B = 350.15 KiB, 59.85 KiB under its 410 KiB ceiling** |
| `docs/master.html` and its stamp | §4, §4.3, §5, §5.2, §6.0, §6a, §6b, §6c, §6.4 and §10 |
| `docs/changelog.html` | this batch's entry |
| `docs/design-notes.md` | one entry, at the top |
| `docs/state.md` | rewritten: the WHERE block, HB's rulings and findings, the sequence (HB, HC, HD, HE), HA's rulings answered, the merge's header and steps 4 and 6, the draft and slot facts, the census figure |
| `docs/reports/HB.md` | **NEW** |

**NOT TOUCHED:** `run_battery.sh`, `docs/combat-rules.md`, `docs/ways-of-working.md`, `docs/instrument-rules.md`,
`README.md`, the fixtures, and every `.tscn`.
