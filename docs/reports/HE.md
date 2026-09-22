# BATCH HE — GATES AND DOORS

**On `class-merge`, from `708080d` (HD). IMPLEMENT ONLY.** HC and HD each left follow-ups about what a hero is
offered and at which door; the designer ruled every one in the brief, and this batch builds them. **Seven runes gate
on their engine** — each on the engine that authored what it reads, and Bared Plate on the one engine that gives a
Warrior Block to trade — and each read site asks that engine too, so the "sits out" the screens already print is true.
**Mark of the Hunt is Pack Bond's**, offered only with it and sitting out whenever it does. **The zone boss asks the
engine half of the card gate, and the draft re-asks at the pick**, drawing no button for a card it holds back and
saying why. **The `[Class]` band is gone from every surface. Charge's pins are relabelled** as the designer's reprice.
No rune was authored; no engine, kit, pool or node moved beyond the gates named. `main` is untouched. **HF takes the
other seventy-three.**

**THE FIGURES.** **Seven RULED rune rows** (`Runes.ENGINE_READ`, 36 → 43) and **nine read sites** asking the same
engine (Bared Plate's three among them). **Three card rows** (`Classes.ENGINE_READ`, 39 → 42): Stabilize and Primal Surge derived, Mark of the Hunt
ruled; **one ruled seat row** and one clause in `Classes.sits_out`. **Seven zone-boss offers moved, not four** — each
0 in 400 rolls with its engine unslotted where HEAD offered it exactly as often as slotted. **What a hero holding no
engine can be offered, at spawn / at the ceiling:** Warrior 5 / 9 → **2 / 6**, Mage 3 / 7 → **0 / 4**, Hunter 5 / 7 →
**4 / 6**, Cleric 0 / 0. **One new gate**, `check_he` (251), and **eight instruments repaired**, one of them for a hole
the recon could not show (§6). **Thirty-five control runs**, one defect a copy, each read by its FAIL text: twenty-nine defects read red on the arm that names them, three read green on the version without the repair — the hole, shown — and three were re-run after two of `check_he`'s messages and one locator were repaired (§7). **Rows: seven counts moved and one row added**, and six more notes at unchanged counts (§6). **The acceptance run: 124 of 124 launched (with `check_he`), `check_de` 513 checks / 0 failures / 0 notices, the tree frozen and the player's saves byte-identical to the backup** (§9).

---

## NEEDS A RULING

1. **MARK OF THE HUNT'S TEXT (§2).** The brief: *a card that needs an engine should name it — propose the wording*. The
   card reads today, as its six lines:

   ```
   Mark an enemy for 7 turns: you and
   your companion deal +25% damage to it
   and every strike on it restores 3%
   of your max Mana. The cooldown resets
   if the marked enemy dies.
   Works with or without a companion.
   ```

   **Proposed**: the first five lines as they are, and the sixth replaced by two that name the engine rune — the
   player's noun for it on every other surface:

   ```
   Needs the Rune of the Beastmaster, and
   works with or without a companion.
   ```

   38 and 34 characters, under the 44 ceiling. Not written: the card's text is authored, and the brief asks for a
   proposal. *(The card also speaks in "you" and "your", which the text standard forbids; the proposal leaves those
   lines alone — FOUND AT HE.)*
2. **MARK OF THE HUNT HALF-WORKED WITHOUT PACK BOND (§2, §0 premise 13).** The brief's *"its bonus damage and Mana pay
   nothing without it"* is true of the HUNTER's halves and not of the COMPANION's: its +25% on the marked prey
   (`_companion_hit`) and the Mana its blows feed back read no engine, and every Hunter but the Sharpshooter fields a
   companion. **Driven on HEAD's code with no engine: a Canis blow on the marked prey 94 against 75 on an unmarked one,
   and 3 Mana fed; with Pack Bond the same 94 and 3.** The ruling is built — a RULED row, HD's stance-piece shape — so
   **a Hunter who fields a companion and holds no Pack Bond is no longer offered, or seated, a card that paid him
   half.** Confirm; or move the hunter's halves out of the Pack Bond block and ungate the card.
3. **SLAUGHTERHOUSE'S ENGINE AUTHORS NO BLEED (§1a, §0 premise 10).** *"Gate each on the engine that authored it"*:
   Blood Frenzy reads the Berserker's own health and the Rage he spends, Bloodlust (the card it brings) lays no Bleed
   (GS §1's ruling), and **no engine lays one** — drafted cards (Wildstrikes, Hack and Slash, Rampage, Gut Rip), the
   Hunter's wolf and the Bloodletting bargain do. Built on Blood Frenzy as the brief's table names it: the lineage the
   rune was written for, and the engine the game's signature table already credits a bleedout to (`_sig("bloodrage")`,
   BJ §3a). **Mirror Guard is the milder form of the same thing** — the Stances lay no guard (a swap card turns it),
   they are the engine its numbers are read under. Confirm both.
4. **THE ZONE BOSS MOVED SEVEN OFFERS, NOT FOUR (§3a, §0 premise 16).** Stabilize (Runaway Resonance) and Primal Surge
   (Pack Bond) are on a lineage's boss pool and in no draft pool, cannot be cast without their engine (GT's seat
   rows), and were never card-gate rows because GP derived that table over the draft pools, the one door that asked it
   then. Asking the engine half without them would have left the boss offering two cards the hero sheet greys out the
   moment they are taken, so **they are rows, derived and not ruled**; Mark of the Hunt is the seventh, by §2's
   ruling. Confirm the two.
5. **A MAGE HOLDING NO ENGINE IS OFFERED NO ORDINARY RUNE AT SPAWN (§1c).** His three were Long Fuse, Killing Cold and
   Deep Cold; the four left (Ashfall, Chain Fire, Glass Prison, Cold Snap) each wait on a card he drafts. It is §1's
   accepted cost at its sharpest — the Cleric's shape, reached by a second class — and `check_gv` §3 records his spawn
   half as OWED beside the Cleric's. The rune design pass inherits it; nothing is owed a ruling unless the designer
   wants the spawn half filled before that pass.
6. **DECLINING A DRAFT REFUSES ITS HELD-BACK CARDS TOO (§3b).** The no-return rule refuses the whole stored offer, so a
   player who declines an offer he cannot answer while an engine is unequipped also refuses the cards that were
   waiting on it. The column says so in the all-held line (*"declining refuses the whole offer"*). Whether declining
   should skip what is held back — or whether an offer that is wholly held should be declinable at all — is the
   designer's.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `708080d` = `origin/class-merge` before anything moved |
| 2 | *"THE SEQUENCE SHIFTS AGAIN. This takes HE; the other assertions HA found become HF"* | **RECORDED** | `docs/state.md` named HE *"the other seventy-three"*; it names HF now |
| 3 | *"HD found my brief handed it HC's RUNE table for the CARD floors"* | **HELD** | HD §0 premise 14 |
| 4 | *"Additions to GV's `ENGINE_READ` table"* | **HELD** | `Runes.ENGINE_READ` — GV's rune table; seven rows added (§1) |
| 5 | *"Six runes read a status or stance that no class kit applies"* | **HELD** | HC §2c, re-read at each read site (§1a) |
| 6 | *"Long Fuse — the Pyromancer's engine"* | **HELD** | reads Burn (`_stamp_fk_enemy_runes` → `burn_clock_held`); Overburn reads the Burn field and its one enabler, Flamewave, lays Burn on every enemy |
| 7 | *"Killing Cold, Deep Cold — the Cryomancer's engine"* | **HELD** | Killing Cold reads an enemy at four Chilled (`_killing_cold_cast`), Deep Cold the Chilled he lays (`chill_uncapped`); Permafrost's Glacial Hold reads four Chilled and its enabler Razor Ice lays three |
| 8 | *"Long Poison — the Survivalist's engine"* | **HELD** | reads the Poison he lays (`_apply_poison`, src him); Trapper's barb lays it on a hero's attacker and its on-hit package (Shrapnel Charge, Venom Coating) on his target |
| 9 | *"Mirror Guard — Stances"* | **HELD AS THE STANCE'S ENGINE, NOT ITS AUTHOR** | reads `stance == "defensive"` (`_mirror_guard_return`); every Warrior opens Aggressive and a SWAP CARD lays the guard — Guard Change (the Stances holder's since HD §1), Precision Strike, Feint, Wheeling Cut with no engine. The Stances are the engine the guard's numbers are read under |
| 10 | *"Slaughterhouse — the Berserker's engine"* | **DOES NOT HOLD AS "AUTHORED"; BUILT AS NAMED** | reads a bleedout (`_add_bleed_with_burst`, the one bleedout path). **No engine lays a Bleed**: Blood Frenzy reads his health and the Rage he spends, and Bloodlust, the card it brings, lays none (GS §1's ruling: *"the Berserker brings Bloodlust and no bleed ability"*). The Berserker's is the lineage the rune was written for (`written_for`) and the engine the signature table credits a bleedout to (`_sig("bloodrage")`, BJ §3a) — gated there, as the brief's table names |
| 11 | *"a Warrior without Heavy Plating has none to lose — so it was free for every Warrior but the Warden"* | **ONE CASE SHORT** | a Warden-LINEAGE Warrior who unslots Heavy Plating keeps the lineage's 0.10 Block (the stat block), so he had a cost to lose too; built as named — gated on Heavy Plating, the engine, not the lineage |
| 12 | *"A card, so this is GP's card gate, not ENGINE_READ"* | **ONE WORD SHORT** | GP's card gate IS a table named `ENGINE_READ` too (`Classes.ENGINE_READ`); §1's is `Runes.ENGINE_READ`. Built in the card table |
| 13 | *"HC found it secretly reads Pack Bond: its bonus damage and Mana pay nothing without it"* | **HALF HELD** | the HUNTER's halves (+25% on his strikes on the prey, 3% Mana a strike) sit inside `has_engine("pack")`; the COMPANION's halves — its +25% on the prey (`_companion_hit`) and the Mana its blows feed back — read no engine, and every Hunter but the Sharpshooter fields a companion. **Driven on HEAD's code, no engine: a Canis blow on the marked prey 94 against 75 on an unmarked one, and 3 Mana fed; with Pack Bond the same 94 and 3.** So without Pack Bond the card HALF-works for any Hunter who fields a companion; beside Lethal Aim (no companion) only the hunter's halves could pay, and they did. Built as ruled — a RULED row, HD's stance-piece shape |
| 14 | *"it still pays when Pack Bond is sitting out beside Lethal Aim — so HB's 'sits out' tell is untrue"* | **HELD** | HC §5c drove it (15 → 18 damage, 0 → 3 Mana) |
| 15 | *"HD found Lunge offered at a Swordmaster's zone boss with the Stances unslotted — 280 times in 400 rolls"* | **HELD** | HD's `check_hd` §2; HE's own seeded drive reads 303 / 303 on HEAD's code |
| 16 | *"Report the four boss offers that move — Lunge, Shatter, Overcharge and Divine Plea"* | **FOUR OF SEVEN** | those four are every boss card with a card-gate row at HEAD. **Two more are cards that sit out without their engine and were never rows** — Stabilize (Resonance) and Primal Surge (Pack Bond), `SITS_OUT` rows since GT that GP's draft-only derivation never swept — and **Mark of the Hunt** joins by §2's ruling. §3 |
| 17 | *"HD drove it: a Guard Change rolled while the Stances were slotted is handed over after they are unslotted"* | **HELD** | reproduced on HEAD's code (`take_draft_ability` → `""`) |
| 18 | *"The rune cache and the zone boss re-ask at the answer; the draft does not"* | **HELD** | `Run.rune_choice` (engine and pet), `Run.ability_choice` (pet only, until §3) |
| 19 | *"FE's 604 dead buttons were a correct refusal that left the UI lying"* | **HELD** | FE §2 |
| 20 | *"Every offered rune reads '[Class]'"* | **HELD, ON TWO SURFACES; THE BAND ON FIVE** | the WORD rendered on the Peddler's row and a cache's (or bargain's) button; the band's TINT on those two and the map card's rune slot, the pouch row and the hero sheet's row (§4) |
| 21 | *"HD left two `test_batch_br` arms live because they pin the designer's reprice of Charge — 20 Break damage, 30 Rage"* | **FIVE ARMS, AND AN ANCHOR** | the Charge-against-Strike block asserts five comparisons (Break damage, damage, arrival, net Rage, cooldown) and the anchor that finds Strike; two carry the reprice's own figures (20 BD over Strike's 18; 30 Rage, net under Strike's) — all six relabelled, and the `_weaker_half` 30 Rage arm with them (§5) |
| 22 | *"'That class' in the empty-shop sentence is already built — HC did it and it is confirmed"* | **HELD** | `Runes.empty_offer_reason`'s six sentences say *that class* (HC §1c) |
| 23 | *"No engine, kit, pool or node changes beyond the gates named"* | **HELD** | no engine, kit, pool or node moved; the gates are §1-§3's |

## §1 — SEVEN RUNES GATE ON THEIR ENGINE

### §1a — The rows, and the mapping verified at each read site

**Built as seven RULED rows of `Runes.ENGINE_READ`** (GV's rune table), each carrying `"ruled": "HE §1"`, read by a new
`Runes.engine_read_ruled` — the card table's `Classes.engine_read_ruled` one layer up. `offerable`, `sits_out` and every
door ask a ruled row exactly as a derived one.

| rune | reads (the read site) | gated on | does that engine lay what it reads? |
|---|---|---|---|
| Long Fuse | Burn on an enemy — `burn_clock_held`, stamped at the spawn (`_stamp_fk_enemy_runes`) and read in `tick_statuses` | Overburn (the Rune of the Pyromancer) | **yes** — Flamewave, its one enabler, lays Burn on every enemy; Overburn reads the Burn field |
| Killing Cold | an enemy at four Chilled, on his cast (`_killing_cold_cast`) | Permafrost (the Rune of the Cryomancer) | **yes** — Razor Ice, its enabler, lays three Chilled; Glacial Hold reads four |
| Deep Cold | the Chilled he lays, uncapped (`chill_uncapped`, stamped at the spawn) | Permafrost | **yes**, the same |
| Long Poison | the Poison he lays (`_apply_poison`, src him) | Trapper (the Rune of the Survivalist) | **yes** — Trapper's barb poisons a hero's attacker, and its on-hit package (Shrapnel Charge, Venom Coating) his target |
| Mirror Guard | `defender.stance == "defensive"` (`_mirror_guard_return`) | the Stances (the Rune of the Swordmaster) | **no guard is laid by an engine** — every Warrior opens Aggressive and a swap card turns the guard: Guard Change (the Stances holder's since HD §1), and Precision Strike, Feint and Wheeling Cut with no engine at all. The Stances are the engine the guard's numbers are read under |
| Slaughterhouse | a bleedout, at the one bleedout path (`_add_bleed_with_burst`) | Blood Frenzy (the Rune of the Berserker) | **no — and no engine lays a Bleed.** Blood Frenzy reads his own health and the Rage he spends; Bloodlust, the card it brings, lays none (GS §1's ruling). Drafted cards (Wildstrikes, Hack and Slash, Rampage, Gut Rip), the Hunter's wolf and the Bloodletting bargain do. Gated as the brief's table names it — the lineage the rune was written for, and the engine the game's signature table already credits a bleedout to (`_sig("bloodrage")`, BJ §3a). NEEDS A RULING 3 |
| Bared Plate | its price at the Block roll and `_live_block_chance`; its +25% at the Break-damage site | Heavy Plating (the Rune of the Warden) | its price is Block chance, and only Heavy Plating's slice gives a Warrior Block to lose — **but a Warden-LINEAGE Warrior keeps the lineage's 0.10 without it**, so *"none to lose"* is one case short; gated on the engine, as ruled |

**Every one of the seven is the engine of the lineage the rune was written for** (`written_for` → `Classes.engine_of_spec`),
which `check_gv` §0 asserts of every row — so the brief's table and that rule agree on all seven, including the two whose
engine authors nothing they read.

### §1b — The read sites ask the engine too, and why

**A row SITS OUT without its engine (GX §1): the pouch row, the map's rune slot, the hero sheet and the battle log's
roll call all say *"Sits out of every fight while the Rune of the … is not equipped"*.** That sentence is true of GV's
thirty-six because each of their read sites was already inside its engine's block (GV derived them that way, and GW §3
gated the two prices that were not). **None of these seven was**: Long Fuse held a Burn a drafted Firestorm lit, Mirror
Guard returned blows in a guard Feint reached, Bared Plate refused his Block roll and paid its Break damage with no
engine at all. Adding them to the table alone would have told a player a rune sits out while it paid. **So each read
site asks the row's engine** — no engine, no payout, and for Bared Plate no price (GW §3's *no engine, no cost and no
payout*):

| rune | the site | the gate added |
|---|---|---|
| Long Fuse, Deep Cold | `battle._stamp_fk_enemy_runes` | the wearer found by `_living_hero_with` must hold Overburn / Permafrost |
| Killing Cold | `battle._killing_cold_cast` | `or not caster.has_engine("permafrost")` |
| Long Poison | `battle._apply_poison` | `elif src.rune_long_poison > 0 and src.has_engine("trapper")` |
| Mirror Guard | `battle._mirror_guard_return` | `or not defender.has_engine("seasoned")` |
| Slaughterhouse | `battle._add_bleed_with_burst` | `butcher_rune.has_engine("bloodrage")` |
| Bared Plate's price | the Block roll (`bared`) and `_live_block_chance` | `and … .has_engine("heavy_plating")` |
| Bared Plate's +25% | the Break-damage site | its own field, `rune_bared_plate_bd`, summed into the same multiplier only under Heavy Plating |

**BARED PLATE'S 0.25 MOVED TO A FIELD OF ITS OWN, AND THAT IS `data/runes.json`'S ONE CHANGE.** It rode `rune_bd_bonus`,
which the retired Shattered Guard, Duelist and Sentinel also write; a saved run holding one of those is still paid (EO
§3's contract), so gating the shared field would have withheld theirs. The new field is a float (`unit.gd`), stays off
`STAT_INT_KEYS` (0.25 would round to nothing), and is read at the same line and summed into the same multiplier — **with
the engine slotted the arithmetic is byte for byte what it was.** The desc, the price and the magnitude did not move.

### §1c — What a hero can be offered, before and after

Read off `Runes.eligible_ids` for a member of each class holding no engine (ordinary runes; the ceiling is every card any
rune of his class names drafted, and a Berserker's is one more — Blood Debt's card is on his boss pool):

| class | HEAD, at spawn / ceiling | HE |
|---|---|---|
| Warrior | 5 / 9 (10 Berserker) — Long Watch, Bared Plate, Last Word, Slaughterhouse, Mirror Guard | **2 / 6 (7)** — Long Watch, Last Word |
| Mage | 3 / 7 — Long Fuse, Killing Cold, Deep Cold | **0 / 4** — Ashfall, Chain Fire, Glass Prison, Cold Snap once their cards are drafted |
| Cleric | 0 / 0 | 0 / 0 |
| Hunter | 5 / 7 — the four companion runes and Long Poison | **4 / 6** — the four companion runes |

**The Mage holding no engine is offered no ordinary rune at spawn** — the three he had were the Burn and Chill runes.
`check_gv` §3's `RUNE_FLOOR` moved to the new reading, and **his spawn half is OWED now, as the Cleric's is**: a zero
floor asserts nothing, so his row asserts instead that some engine he can slot opens a rune at spawn (NEEDS A RULING 5).

**And each of the seven, 400 rolls an arm at the Peddler (`generate_rune`), 400 at an elite cache
(`roll_rune_candidates`), 400 at a bargain (`claim_reward`), HEAD against HE** (`check_he` §1 prints HE's; HEAD's by the
same seeded probe on HEAD's code):

| rune | HEAD, no engine (Peddler) | HE, no engine (Peddler · cache · bargain) | HE, its engine (Peddler · cache · bargain) |
|---|---|---|---|
| Long Fuse | 52 | 0 · 0 · 0 | 45 · 150 · 133 (Overburn) |
| Killing Cold | 40 | 0 · 0 · 0 | 47 · 144 · 138 (Permafrost) |
| Deep Cold | 48 | 0 · 0 · 0 | 48 · 155 · 153 (Permafrost) |
| Long Poison | 42 | 0 · 0 · 0 | 38 · 114 · 99 (Trapper) |
| Mirror Guard | 42 | 0 · 0 · 0 | 44 · 117 · 132 (the Stances) |
| Slaughterhouse | 37 | 0 · 0 · 0 | 51 · 141 · 120 (Blood Frenzy) |
| Bared Plate | 40 | 0 · 0 · 0 | 44 · 117 · 132 (Heavy Plating) |

*A cache and a bargain each hand over a triple, so their counts are appearances in 400 triples; the Peddler draws one
rune a roll from a pool that holds the class's engine runes too. **And with a WRONG engine slotted each reads 0 at all
three doors** — a Warrior holding the Stances is offered no Slaughterhouse or Bared Plate, a Mage holding Overburn no
Killing Cold or Deep Cold (`check_he` §1 drives each class with no engine and with each engine that gates one of the
seven, and reads all of the class's seven on every arm).* **And a cache
rolled with the engine slotted and answered after the pouch takes it out** holds the row back, keeps it stored, and
hands it over once the engine is back (`check_he` §1).

## §2 — MARK OF THE HUNT IS PACK BOND'S

**Built as a RULED row of GP's card gate — which is a table named `ENGINE_READ` too (`Classes.ENGINE_READ`) — and a RULED
row of `Classes.SITS_OUT`, both `"ruled": "HE §2"`**, and **`Classes.sits_out` gained one clause: a row keyed to an engine
that needs the pet (`engine_needs_pet`: Pack Bond) sits out while the pet is dismissed** — while Pack Bond itself sits out
beside the Rune of the Sharpshooter (HC §5). It moves no existing row: Pack Bond's other two seat rows, Unleash and Primal
Surge, are `COMPANION_READ` rows the door refuses with no companion, so each already sat out beside a dismisser.

**What the card needs, driven** (`check_he` §3, and the probe on HEAD's code):

| Hunter (the Beastmaster's lineage) | offered at the zone boss, 400 rolls (HEAD → HE) | seated |
|---|---|---|
| Pack Bond slotted | 251 → **251** | yes |
| Pack Bond owned, unslotted | 251 → **0** | **sits out** |
| Lethal Aim alone | not driven on HEAD → **0** | **sits out** |
| Pack Bond beside Lethal Aim | 400 → **400** (offered: Pack Bond is slotted) | **sits out, with Pack Bond** |

**THE PREMISE HELD FOR HALF THE CARD.** HC drove the hunter's own Quick Shot: +25% and 3% Mana only under Pack Bond. **The
companion's halves read no engine** — its +25% on the marked prey is in `_companion_hit`, and the Mana its blows feed back
sits beside it — and every Hunter but the Sharpshooter fields a companion. Driven on HEAD's code with no engine: **a Canis
blow on the marked prey 94 against 75 on an unmarked one, and 3 Mana fed; with Pack Bond the same 94 and 3.** So the card
HALF-worked without Pack Bond, which is exactly HD's stance-piece shape, and it is a RULED row for the same reason. **The
cost of the ruling is that a Hunter who fields a companion and holds no Pack Bond is no longer offered, or seated, a card
that paid him half** (NEEDS A RULING 2).

**THE TELL IS TRUE NOW.** Beside Lethal Aim the card sits out, so nothing lays the mark whose hunter's halves Pack Bond
pays; Pack Bond's other eight reads all need a companion (HC §5c). The card's sentence beside Lethal Aim is a THIRD cause
in `Run.sits_out_note` — *"Sits out of every fight while the / Rune of the Beastmaster sits out beside / the Rune of the
Sharpshooter, which / dismisses the companion it needs."* then GT's two closing lines — because the engine's words (*"is
not equipped"*) would be false and the pet's (*"the companion it needs"*, said of the card) would say the card needs a
companion, which it does not. Every line is under 44 characters (39 the widest).

**WHAT ITS TEXT SHOULD SAY (the designer confirms).** It reads today:

```
Mark an enemy for 7 turns: you and          34
your companion deal +25% damage to it       37
and every strike on it restores 3%          34
of your max Mana. The cooldown resets       37
if the marked enemy dies.                   25
Works with or without a companion.          34
```

**Proposed — the sixth line replaced by two that name the engine rune, the player's noun for it on every other surface:**

```
Mark an enemy for 7 turns: you and          34
your companion deal +25% damage to it       37
and every strike on it restores 3%          34
of your max Mana. The cooldown resets       37
if the marked enemy dies.                   25
Needs the Rune of the Beastmaster, and      38
works with or without a companion.          34
```

Not written: the card's field is authored text, and the brief asks for a proposal. *(The card also says "you" and "your"
throughout, which the text standard asks to avoid; the proposal leaves those lines as they are.)*

## §3 — TWO DOORS THAT DID NOT RE-ASK

### §3a — The zone boss asks the engine half

**`Run.roll_spec_ability_offer` asks the whole of `Classes.offerable` now, and the answer does too** (`Run.ability_choice`
→ `_card_seated`, which was `_pet_seated` and asked `Classes.pet_withholds` alone). A triple rolled while the engine was
slotted is FILTERED at the answer, never repaired away (GV's rule), and the boss overlay splits what it holds back into
its two causes — the rune cache's words for an engine (*"The offer holds 1 more that waits on the Rune of the Swordmaster
being equipped. / Equip it and they return."*), HC's words, byte for byte, for the pet.

**THE BOSS OFFERS THAT MOVE — SEVEN, NOT FOUR.** The four the brief names are every boss card that was a card-gate row at
HEAD. **Two more are cards that cannot be cast without their engine and were never rows**: Stabilize (Runaway Resonance)
and Primal Surge (Pack Bond) are on a lineage's boss pool and in no draft pool, and have been `SITS_OUT` rows since GT —
GT's own comment names them *"two zone-boss cards `ENGINE_READ` never swept"* — because GP derived the card gate over the
draft pools, the one door that asked it. Asking the engine half without them would have left the boss offering two cards
the hero sheet greys out the moment they are taken, so **they are rows, derived and not ruled** (NEEDS A RULING 4). The
seventh is Mark of the Hunt, §2's ruling. `check_he` §0 asserts every `SITS_OUT` row is a card-gate row naming the same
engine, so the offer and the seat cannot disagree about a card again.

**Before and after, 400 seeded rolls an arm, the same dice both trees** (`check_he` §4; HEAD's by the same probe):

| boss card | lineage | engine | slotted, HEAD → HE | unslotted, HEAD → HE |
|---|---|---|---|---|
| Lunge | Swordmaster | the Stances | 303 → 303 | **303 → 0** |
| Shatter | Cryomancer | Permafrost | 400 → 400 | **400 → 0** |
| Overcharge | Arcanist | Resonance | 291 → 291 | **291 → 0** |
| Stabilize | Arcanist | Resonance | 303 → 303 | **303 → 0** |
| Divine Plea | Holy | Mercy | 400 → 400 | **400 → 0** |
| Primal Surge | Beastmaster | Pack Bond | 240 → 240 | **240 → 0** |
| Mark of the Hunt | Beastmaster | Pack Bond | 251 → 251 | **251 → 0** |

**The slotted arm did not move a draw**: `offerable` is a filter in the same order, so a hero whose engine is in rolls
exactly the dice he rolled before. (HD's 280 was its own seed; this batch's seed reads 303 on HEAD's code.)

### §3b — The draft re-asks at the pick

**`Run.draft_choice` is the one list**: the head triple, less what the hero now owns and what `Classes.offerable` withholds
from the engines slotted now. **The party draft screen draws its buttons from it and `take_draft_ability` refuses a name
not in it** — with the reason (*"Guard Change waits on the Rune of the Swordmaster being equipped"*, or the pet's words).
It FILTERS and writes nothing back: the engine is one press from back, so the card waits in `draft_candidates`, and
slotting the engine returns it (GV's rule; not a reroll — nothing is drawn).

**WHAT THE PLAYER SEES WHEN A DRAFTED CARD IS WITHHELD AT THE PICK:**

- **No button for it.** The column draws the cards `draft_choice` hands over and nothing else — FE's 604 dead buttons
  were a correct refusal left on the screen, and a held card is never one.
- **A line under the cards saying what the column holds and which rune brings it back** — *"The offer holds 1 more that
  waits on the Rune of the Swordmaster being equipped."* — the boss overlay's words, and the pet's words for a companion
  card beside the Rune of the Sharpshooter.
- **When the whole offer is held**: *"Nothing in this offer can be taken now. Later keeps the pick owed; declining refuses
  the whole offer."* — **Later** leaves the screen with the pick still owed, so the pouch can put the engine back, and the
  card's badge reopens the column. **Declining refuses the whole stored offer, held cards with it** — the no-return rule —
  and the line says so (NEEDS A RULING 6).
- **The "fills short" line reads the stored triple**, so a held card is never reported as a pool that ran dry.

**FOUND HERE AND BUILT WITH IT: A CARD KNOWN FROM AN EARLIER QUEUED TRIPLE WAS A DEAD BUTTON.** Two draft triples queued
before either is answered can share a card (both rolled from the same not-yet-owned pool). Taking it from the first left
it in the second as a button whose pick `take_draft_ability` refused with *"already known"* — FE's shape at the draft.
`draft_choice` filters an owned card too, and the column says *"The offer holds 1 this hero already knows."*

**Driven for every engine that gates a draft card** (ten: Blood Frenzy, Heavy Plating, the Stances, Permafrost,
Resonance, Mercy, Conviction, the Old Gods, Pack Bond, Lethal Aim): a triple rolled with it slotted, answered with it
unslotted — held back, refused with the reason, the stored triple unchanged and the pick still owed; slotted again, taken
(`check_he` §5).

## §4 — THE "[CLASS]" LABEL GOES

**EVERY SURFACE IT RENDERED ON** — the WORD on two, the band's TINT on five:

| surface | the word `[Class]` | the band's tint |
|---|---|---|
| the Peddler's row (`shop_screen`) | **yes** — *"Long Watch  [Class]  (for Warrior 1)"* | yes |
| a cache's or a bargain's button (`map_screen`'s pick overlay) | **yes** — *"Long Watch  [Class]"* | yes |
| the map card's rune slot (`map_screen`) | no | yes |
| the rune pouch's row (`map_screen`) | no | yes, unequipped |
| the hero sheet's rune row (`party_screen`) | no | yes, unequipped |

**Dropped from all five.** The word is gone, and a rune's text is drawn in one colour, `Runes.RUNE_TINT` — the class band's
blue, which every rune a player can be offered already wore, so no live rune changes colour; only a retired universal kept
in an old save, which read grey, reads the same as the rest. **`SCOPE_INFO` and `Runes.shown_scope` are deleted, not
zeroed, and `Runes.build` no longer writes `scope_label` / `scope_color` onto an instance** — nothing reads either. An
instance that rides a save from before HE still carries both, and nothing displays them. `scope_band` stays: the sim's
worn-rune report and the instruments read it, and show it to nobody.

## §5 — CHARGE'S PINS ARE RELABELLED

**The brief said two arms; the block is five comparisons and an anchor.** `test_batch_br`'s `_break_damage()` measures
Charge against the free Strike on Break damage (20 over 18), damage, arrival, net Rage (30 gained less 20 spent, under
Strike's) and cooldown, after an anchor that finds Strike. Two carry the reprice's own figures; the three others pin where
the reprice left Charge standing. **The comment above them stated BQ's rule — *"the floor for a class card is the free core
attack"* — which is what read as the retired rule**, so the whole block is relabelled: the comment says it is the
designer's reprice, kept by ruling at HE §5 and not the retired rule, and not to be retired with the "weaker" arms; every
message opens *CHARGE'S REPRICE*. **The `_weaker_half` arm asserting Charge's 30 Rage is relabelled the same way.** No
assertion changed and no count moved.

## §6 — THE UNMODIFIED GATES AGAINST THE NEW TREE, AND WHAT WAS REPAIRED

**HEAD's battery ran first, unmodified, against HE's game code** — an isolated copy, renamed and seeded from the
backup, every gate and suite as HEAD holds it: **123 of 123 launched, and `check_de` read 509 checks / 16 failures / 4
notices.** Every red was read by its FAIL text before any instrument was touched, and each is one of two things: an
instrument asking the game HE replaced, or HE's own game change arriving where it should.

| target | HEAD's gate on HE's code | cause | repair |
|---|---|---|---|
| `check_parse`, `check_hc` | `check_hc` does not parse: *"Static function "shown_scope()" not found in base "Runes""* — so it read no count, and `check_parse` read it as a parse failure | HE §4 deleted the band door `check_hc` §1 asked | §1 re-pointed to the band's absence: a fresh build carries no `scope_label` / `scope_color`, no screen asks a band door, and the three surfaces read `Runes.RUNE_TINT` (72 / 0, its count) |
| `check_fd` | 1 — *"§1e: the rune overlay drew NO pick buttons — the drive read nothing"* | §1e found the cache's buttons by the band's `"  ["` | finds them by any rune's display name — deliberately not by the repaired triple it asserts (an arm must not locate by what it asserts) — 52 / 0 |
| `check_gs` | 26 — *"§4: the Peddler draws no line for engine_…"* ×24, and the two totals | §4b found the Peddler's row by `name + "  ["` | finds it by `name + "  (for "`, the row's own shape — 733 / 0, its count |
| `check_gt` | 1 — *"§3: Mark of the Hunt sits out, and no ruling named it"* | HE §2's ruled seat row | `RULED_BY_DESIGNER` beside `RULED`, driven as a ruling: its premise (usable bare) asserted, its seat driven with Pack Bond's derived rows — 3,190 / 0 |
| `check_gv` | 31 — §0 seven rows no ruling names; §1 the seven *"moved something with its engine merely OWNED"* inverted; §2a seven *"reads no engine and is not rolled"*; §2c a part-row cache's third rune is a row now (3); §3 three floors | the seven HE §1 rows | the seven into `ROWS` and out of `GROUPS`; `RUNE_FLOOR` to HE's reading, owed **half by half** (the Mage's spawn half is 0 while his ceiling is 4); §2c's third rune Long Watch; §1c's Killing Cold arm kept as the record of the half; **and a third §1b price arm, Bared Plate's (below)** — 965 / 0 |
| `check_gx` | 2 — *"43 gated runes — the table holds 36"*; *"17 ungated … — 24 since HC"* | the seven rows | the two counts, with the reason — 1,330 / 0 |
| `check_hd` | 1 — *"the ruled rows are [Guard Change, Lunge, Mark of the Hunt] — the ruling named two"* | HE §2's third ruled row | asks which rows carry HD §1; **and its two §2 findings are ASSERTED now that HE §3 built them** — the boss offers Lunge 0 times in 400 with the Stances unslotted, and the draft's answer refuses a piece whose engine is out and hands it over once it is back, on one member — 31 / 0 |
| `test_batch_ah` | 120 — *"cryomancer / arcanist / holy is offered min(3, pool) = 3 (got 2)"*, 40 each; and it FELL to 5,305 | §3 seated a lineage with NO engine rune, which GK's rule says a hand-built seat must carry; the boss asks the engine half since HE §3, so that hero is not offered Shatter, Overcharge, Stabilize or Divine Plea | the seat carries `Runes.engine_pouch_for_spec(spec)` and `awakened` — 5,554 / 0, its count |
| `test_runes` | 0 failures; FELL 6,697 → 6,655 | fourteen grants fewer — each of the seven rows now reaches only its own engine's lineage (arcanist 3, pyromancer 2, berserker 2, swordmaster 2, warden 2, cryomancer 1, sharpshooter 1, beastmaster 1), three checks a grant | none: the loop walks the live pool, so the row moves (§7) |
| `check_gp` | NOTICE: rose 443 → 446 | Stabilize and Primal Surge are driven as rows (§2, +2) and Mark of the Hunt as a ruled row (§2e, +1) | none — the row moves |
| `check_gj` | 70 / 1, sanctioned — *"+159 gold and the purse moved 179"* | the same Tollkeeper's Bell twenty; HEAD's own code, seeded with the same saves the same day, reads +178 / 198 | none — HE's gates move what the gate's seeded run is offered; the note moves |
| `check_cm_live` | 13 / 4, sanctioned | — | — |

**`test_batch_br` is not on the list because it read green**: §5's relabelling changed messages and comments, not a
count (1,486 / 0 either way).

**AND ONE HOLE THE RECON COULD NOT SHOW: NOTHING DROVE BARED PLATE'S PRICE.** `check_gv` §1 drives every row's payout
both ways — Bared Plate's Break damage among them — and §1b drove GW §3's two prices (the Martyr, Thin Blood); Bared
Plate's price, a refused Block roll and a zeroed `_live_block_chance`, was asserted by nothing, so either of its two
new engine checks could have been deleted with every gate green. **§1b drives it now, on the same three boards**: with
his Block chance set to a certainty, four blows, and the chance a Covering Guard would read — the refusal lands only
with Heavy Plating EQUIPPED (§7's c10 and c11 break each site).

### The rows that moved, each attributed by an ok() trace

Each by HEAD's gate on HEAD's tree against HE's gate on HE's tree, every `ok()` message counted, digits masked:

| row | from → to | where |
|---|---|---|
| `check_gv` | 918 → **965** | §0 +35 (five arms a row, for seven rows); §2a +7 (a row asserts both ways at the roll, where a group rune asserted one); §3 +2 (the floor split per half: two halves for the Warrior and the Hunter, the Mage's ceiling alone); §1b +3 (Bared Plate's price); §1, §2c, §2e, §4, §5 +0 (the seven change arms, not counts; §2e's sampled rows moved) |
| `check_gx` | 1,155 → **1,330** | §1 +28 (seven rows × five gated arms, less the one ungated arm each asked); §3 +112 (every gated rune on the pouch and the map's slot, both arms, sixteen a rune; the hero sheet walks the first gated rune per engine alphabetically, and Bared Plate, Deep Cold, Long Poison and Mirror Guard replace Bracing Line, Second Winter, Second Barb and Naked Blade, eight arms each way); §5 +35 (each rune's sentence: its lines against the tooltip's 44 and its engine named) |
| `check_gt` | 3,161 → **3,190** | §3 +29: every derived row carries no ruling (+17); Mark of the Hunt's ruled row (+4 in the table's arms, +1 its premise, +1 opened with Pack Bond); Pack Bond's drive with a third row (+6) |
| `check_hd` | 28 → **31** | §2 +3: the boss's Lunge unslotted, the answer's refusal, the answer slotted again |
| `check_gp` | 443 → **446** | §2 +2, §2e +1 (above) |
| `test_runes` | 6,697 → **6,655** | fourteen grants × three (above) |
| `check_parse` | 197 → **198** | `check_he` joined the battery's GATES |
| `check_he` | new | **251** |

## §7 — THE CONTROLS

**Every gate HE added, and every repaired arm, broken on purpose — one defect an isolated copy**, each copy renamed in
`project.godot` before anything ran in it and seeded from the backup, the gates run unmodified, and **each read by its
FAIL text**, not its count. A control that went red for the wrong reason, or printed a line that did not name its
defect, was not accepted as read (three were re-run, below).

| # | the defect | red | the FAIL text that names it |
|---|---|---|---|
| c01 | Long Fuse's rune row renamed out of `Runes.ENGINE_READ` | `check_he` 8, `check_gx` 9 | *"§1: a mage holding [] was offered long_fuse (Peddler 47, cache 179, bargain 186) — it is overburn's holder's (HE §1)"*; *"§2: Long Fuse worn with overburn unslotted — it does not sit out"*; `check_gx` *"§1: 18 ungated live ordinary runes — 17 since HE"* |
| c02 | Slaughterhouse's row names the Stances, not Blood Frenzy | `check_he` 7 | *"§0: slaughterhouse_rune reads `seasoned` in `Runes.ENGINE_READ`, not bloodrage"*; *"§1: a warrior holding ["seasoned"] was offered slaughterhouse_rune (Peddler 36, cache 111, bargain 109)"* |
| c03 | Mirror Guard's row loses `ruled` | `check_he` 2 | *"§0: mirror_guard's rune row is not marked as the designer's ruling"* |
| c13 | Mark of the Hunt's card-gate row renamed out | `check_he` 9, `check_gp` 1 | *"§3: with Pack Bond owned and unslotted the zone boss offered Mark of the Hunt 307 times — it is Pack Bond's (HE §2)"*; `check_gp` §2e's ruled-row premise |
| c14 | Mark of the Hunt's seat row renamed out | `check_he` 8, `check_gt` 8 | *"§3: with Pack Bond beside Lethal Aim, carried Mark of the Hunt is seated and does not sit out"*; `check_gt` *"§3 pack: with the engine dropped the fight still seats Mark of the Hunt"* |
| c14b | the same row DELETED, beside HEAD's `check_gt` | `check_he` 8, `check_gt` 7 | *"§0: the seat table holds 17 rows — it has stopped covering the pool"*; `check_gt` *"§3 pack: sitting out ["Primal Surge", "Unleash"] and seated ["Mark of the Hunt", "Hunter's Instinct"]"*. **HEAD's `check_gt` on the same defect reads 3,161 / 0** — it cannot see Mark of the Hunt seated without Pack Bond: the hole, shown. *(c14 renamed the key rather than deleting it, and HEAD's copy read the stray name as an unnamed row — a red for the wrong reason, so c14b deletes it.)* |
| c15 | `Classes.sits_out`'s new clause removed | `check_he` 2 | *"§3: with Pack Bond beside Lethal Aim, carried Mark of the Hunt is seated and does not sit out"* |
| c16 | the note's third cause removed | `check_he` 1 | *"§3: beside Lethal Aim the card says: Sits out of every fight while the Rune of the Beastmaster is not equipped…"* — the engine's words, false beside Lethal Aim |
| c17 | Stabilize's card-gate row renamed out | `check_he` 5, `check_gp` 1 | *"§0: ["Stabilize"] sit out without an engine the offer does not withhold them for"*; *"§4: a arcanist-lineage hero whose resonance is unslotted was offered Stabilize 400 times by his zone boss"* |
| c18 | the boss's roll back to the pet half alone (HC's) | `check_he` 9, `check_hd` 1 | all seven boss cards offered unslotted (Lunge 303, Shatter 400, Overcharge 291, Stabilize 303, Divine Plea 400, Primal Surge 240, Mark of the Hunt 251); `check_hd` *"§2: … offered Lunge 280 times in 400 rolls … whose Stances are UNSLOTTED"*. **HEAD's `check_hd` on the same defect reads only its own §0 ruled-set red** — its §2 printed the finding and asserted nothing: the hole, shown |
| c19 | the boss's answer back to the pet half alone | `check_he` 8 | *"§4: answered with seasoned out the boss hands over ["Lunge", …], holds back []"*, for all seven |
| c20 | the boss overlay's engine line removed | `check_he` 1 | *"§4 (the Stances out): the overlay draws no Lunge button and does not name the engine — unslotted, the card is held back and the sentence names the rune that brings it back"* (re-run as c20b: the first run's message read *"draws no a Lunge button"*, and the message was repaired before the run was read) |
| c21 | `take_draft_ability`'s re-ask removed | `check_he` 30, `check_hd` 2 | *"§5: Lunge answered with seasoned out — the pick said '', and the hero owns ["Lunge"]"* for every gating engine; `check_hd` *"§2: Guard Change … was handed over (no refusal)"*. **HEAD's `check_hd` reads only its §0 red** |
| c22 | the draft column draws the stored triple, not `draft_choice` | `check_he` 2 | *"§5 (the Stances out): the column draws a Guard Change button"*; the known card drawn as a button |
| c23 | `draft_choice` stops filtering a known card | `check_he` 2 | *"§5: the second triple still offers Cleave after it was taken"* |
| c24 | the Peddler's row carries `[Class]` again | `check_he` 1, `check_gs` 26 | `check_he` *"§6: the Peddler's row still carries a band: Long Watch  [Class]  (for Warrior 1)"* (c24b). **The first run's `check_he` read *"the Peddler drew 0 rows for Long Watch"*: §6 found the row by its band-free shape, so a band coming back read as a missing row — an arm locating by what it asserts. It finds the row by the rune's name now, and c24b is the re-run.** `check_gs` §4b reads 26 either way, its locator being the row's shape |
| c25 | a cache's button carries `[Class]` again | `check_he` 2, `check_fd` 1 | *"§6: a cache's button still carries a band: ["Long Watch  [Class]", …]"* |
| c27 | `rune_bared_plate_bd` declared an int | `check_he` 1 | *"§0: `BattleUnit` does not declare `rune_bared_plate_bd` as a float — 0.25 would round to nothing"* |
| c28 | the draft column's engine line removed | `check_he` 1 | *"§5 (the Stances out): the column draws no Guard Change button and does not name the engine — unslotted, …"* (c28b, after the same message repair as c20) |
| c00 | none — the landed tree, with `check_he` as repaired for c20, c24 and c28 | — | `check_he` 251 / 0 |
| c04 | Long Fuse's read site stops asking Overburn | `check_gv` 2 | *"§1: long_fuse moved something with overburn merely OWNED ({ "burn": 3 } against { "burn": 2 }) — it does not belong in the table"*, and *"only 42 of 43 rows read clean on both arms"* |
| c05 | Deep Cold's read site stops asking Permafrost | `check_gv` 2 | *"§1: deep_cold moved something with permafrost merely OWNED ({ "chill": 6 } against { "chill": 4 })"* |
| c06 | Killing Cold's read site stops asking Permafrost | `check_gv` 2 | *"§1: killing_cold_fk moved something with permafrost merely OWNED ({ "bit": 20000 } against { "bit": 0 })"* — §1's boss body sitting on four Chilled; §1c's trash body stays green, because without the engine its pile is not held at four (the arm is kept as the record of the half, and says so) |
| c07 | Long Poison's read site stops asking Trapper | `check_gv` 2 | *"§1: long_poison moved something with trapper merely OWNED ({ "turns": -1 } against { "turns": 3 })"* |
| c08 | Mirror Guard's read site stops asking the Stances | `check_gv` 2 | *"§1: mirror_guard moved something with seasoned merely OWNED ({ "returned": 3 } against { "returned": 0 })"* |
| c09 | Slaughterhouse's read site stops asking Blood Frenzy | `check_gv` 2 | *"§1: slaughterhouse_rune moved something with bloodrage merely OWNED ({ "first": true } against { "first": false })"* |
| c10 | Bared Plate's price at the Block roll stops asking Heavy Plating | `check_gv` 1 | *"§1b: his Block was refused with the engine merely owned and the rune worn (chance 1.00, 0 blocked)"* — the roll refused while the chance a Covering Guard reads stayed whole: this site, not the other |
| c11 | Bared Plate's price at `_live_block_chance` stops asking Heavy Plating | `check_gv` 1 | *"§1b: … (chance 0.00, 4 blocked)"* — the other site |
| c10p, c11p | c10's and c11's defects, against `check_gv` WITHOUT §1b's third board | **none** | **962 / 0 on both** — before the arm nothing in the gate drove the price, so either engine check could be deleted with the gate green: the hole §6 names, shown |
| c12 | Bared Plate's +25% at the Break-damage site stops asking Heavy Plating | `check_gv` 2 | *"§1: bared_plate moved something with heavy_plating merely OWNED ({ "bd": 25 } against { "bd": 20 })"* |
| c26 | Bared Plate's payload back on `rune_bd_bonus` in `data/runes.json` | `check_he` 2, `check_gv` 2 | *"§0: Bared Plate still writes `rune_bd_bonus`, the field three retired runes share — a gate on it withholds theirs"*; `check_gv` sees the ungated field pay with the engine owned (25 against 20) |

**Thirty-five control runs, every one read by its FAIL text.** Twenty-nine defects (c01–c28, and c14b) each read red
on the arm that names it; c00 is the landed tree, green; c14b's HEAD arm and c10p / c11p are the other arm — HEAD's
`check_gt`, and `check_gv` without its new board — reading GREEN on the defect, which is the hole each repair closes;
and c20, c24 and c28 were re-run as c20b, c24b and c28b after `check_he`'s messages and §6's locator were repaired
(above). **Two things the controls changed**: `check_he`'s two garbled messages, and §6 finding the Peddler's row by the
rune's name rather than by the band-free shape it asserts.

## §8 — WHAT WAS DELIBERATELY NOT DONE

- **No rune was authored, retuned or retired.** Bared Plate's payload key moved (`rune_bd_bonus` →
  `rune_bared_plate_bd`); its magnitude, price and desc did not. The Cleric's no-engine runes ride the rune design pass
  — and so, now, does the Mage's empty spawn offer (NEEDS A RULING 5).
- **Immolate and Pyroblast stay as GP left them.**
- **"That class" in the empty-offer sentence was not touched** — confirmed in the brief as built at HC.
- **Mark of the Hunt's text was not changed** — proposed (NEEDS A RULING 1); the designer confirms.
- **Venom Coating was not gated** (FOUND AT HE): its whole payoff reads Trapper, but it is one of GM's open cards —
  move the payload out of the engine's block, or gate the card — and that is the designer's.
- **No engine, kit, pool or node changed.** The only card rows beyond the brief's are Stabilize and Primal Surge, which
  the seat table already carried (NEEDS A RULING 4).
- **`check_gv` §2c's `get_slice("  [", 0)` was left standing** — harmless with no band (FOUND AT HE).
- **HF — the other seventy-three — follows.** `main` is untouched.

## §9 — VERIFICATION

- **THE SAVES FIRST.** The player's four files (`profile.json`, `relics.json`, `run_save.bin`, `settings.cfg`) were
  copied to `../save-backups/HE-20260922-101431` with an `MD5SUMS.txt` before anything ran, and every isolated copy was
  seeded from that backup, never from the live folder.
- **HEAD's unmodified battery against HE's game code**, in an isolated copy (§6): 123 of 123 launched, `check_de`
  509 / 16 failures / 4 notices, every red read by its FAIL text and every repair made to what that text named.
- **Each repaired instrument and `check_he` standalone**, in isolated copies, every stream grepped for `Parse Error`
  and `SCRIPT ERROR` (none), and every moved count attributed by an ok() trace (§6). The census gates that walk every
  gate file read at their rows standalone before the battery: `check_da` 42, `check_dw` 35, `check_ea` 83, `check_ek`
  47, `check_ff` 68, `check_gw` 76, `check_ec` 24, `check_fr` 25; `check_ed` read one red against HEAD's pin manifest
  (six new pins unrecorded, in `check_hc` and `check_he`), and 18 / 0 against the regenerated one (1,511 pins).
- **The literal sweep**: every literal of four or more characters in every instrument, HEAD's copy and this one,
  against the five documents this batch edited — **no pinned needle changed presence** (206 document pins read, raw
  and whitespace-flattened); the only pinned counts that moved are the changelog's entry count, which moves every batch,
  and a comma count the manifest attributes to `master.html` for `test_batch_bb`, which read green in both runs.
- **The controls** (§7): thirty-five runs, each read by its FAIL text.
- **THE PRE-PASS** — the whole battery on an isolated copy of the landed tree, rows written: **124 of 124 launched, `check_de` 513 checks / 0 failures / 0 notices**, no `Parse Error` and no `SCRIPT
  ERROR` in any of the 124 logs. The copy was proved the tree: hashed against the repo afterwards, it differed only in
  `project.godot` (the rename), this report and `docs/state.md`, whose later edits move no pinned needle (none is
  pinned there, and `check_es`'s two claim windows are unchanged).
- **THE ACCEPTANCE RUN** — the whole battery in the repo, the tree hashed at its start and its end: **124 of 124 launched, `check_de` 513 checks / 0 failures / 0 notices**, no `Parse Error` and
  no `SCRIPT ERROR` in any log; the tree — 562 paths, tracked and untracked — hashed at the start and the end, and
  none moved; the two sanctioned reds at their counts (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *"the card says +159
  gold and the purse moved 179"*).
- **THE SAVES AFTER**: the four files are byte-identical to the backup (`MD5SUMS.txt`), hashed before the acceptance run and after it.

## §10 — WHAT MOVED

- **Game:** `scripts/runes.gd` (the seven ruled rows, `engine_read_ruled`, `cards_wait_on`, `RUNE_TINT`; `SCOPE_INFO`
  and `shown_scope` deleted, and `build` / `template_rune` write no band), `scripts/battle.gd` (the seven runes' read sites),
  `scripts/unit.gd` (`rune_bared_plate_bd`, a float), `scripts/classes.gd` (three card rows, Mark of the Hunt's seat
  row, `sits_out_ruled`, the sits-out clause), `scripts/run_state.gd` (the note's third cause; the boss's whole
  `offerable` at the roll and `_card_seated` at the answer; `draft_choice`, `draft_choice_withheld`,
  `draft_withheld_reason` and the refusal at the pick), `scripts/map_screen.gd` (the boss overlay's two held lines, the
  draft column off `draft_choice` with its held lines, the band), `scripts/shop_screen.gd` and `scripts/party_screen.gd`
  (the band), and a comment in `scripts/run_sim.gd`; `data/runes.json` (Bared Plate's payload key, nothing else).
- **Instruments:** `check_he.gd` (**NEW**); the gates `check_fd`, `check_gs`, `check_gt`, `check_gv`, `check_gx`,
  `check_hc` and `check_hd`; the suites `test_batch_ah` and `test_batch_br`; `run_battery.sh`; `pin-manifest.json`
  (regenerated: 1,511 pins, from 1,506); `baselines.json` (§6's rows and notes, and `check_he`'s).
- **Documents:** `CLAUDE.md`, `docs/master.html` and its stamp, `docs/changelog.html`, `docs/design-notes.md`,
  `docs/state.md`, and this report (**NEW**).

## FOUND AT HE AND NOT FIXED

- **VENOM COATING IS OFFERED AT THE SURVIVALIST'S ZONE BOSS TO A HERO IT CANNOT PAY.** Its whole payoff — every attack
  Poisons — is read inside Trapper's block (the Survivalist's on-hit package in `battle.gd`), so without Trapper the card
  spends a turn laying a coating that does nothing. The boss asks the card gate since HE §3, and Venom Coating is not a
  row: the cast lands, so the cast test cannot see it — GP's *a row whose payout is a later strike* shape, found here by
  reading the site while deriving the boss-only cards. **It is GM's ruling 1, still open** (move the payload out of the
  block, or gate the card), so it is reported and not gated.
- **BESIDE THE RUNE OF THE SHARPSHOOTER, MARK OF THE HUNT IS STILL OFFERED, AND SITS OUT ONCE TAKEN.** The ruling gates
  the OFFER on Pack Bond being equipped, and beside Lethal Aim it is equipped — and sitting out (HC §5's ruling for
  Pack Bond itself: legal, and visible). So the Beastmaster's zone boss offers the card to that Hunter exactly as
  often as to any Pack Bond holder (400 in 400, `check_he` §3 pins it), and the hero sheet greys it out the moment it
  is taken. Pack Bond's other two rows (Unleash, Primal Surge) need a companion, so the pet half withholds them there;
  this one needs none. Withholding it would need the offer to ask whether an engine is IN EFFECT, not whether it is
  slotted — a ruling, not a repair.
- **MARK OF THE HUNT'S CARD SPEAKS IN *"you"* AND *"your"***, which the text standard forbids. The proposed wording (HE's
  ruling 1) leaves those lines as they are: rewriting authored text is the designer's.
- **`check_gv` §2c STILL SPLITS A CACHE BUTTON'S TEXT ON THE BAND'S `"  ["`.** With no band the split returns the whole
  text, which is the rune's name, so the arm is right; a harmless relic of the band, left standing.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (HE §0): *"Slaughterhouse — the Berserker's engine"* as its author (no
  engine lays a Bleed; ruling 3); *"Mirror Guard — Stances"* as its author (the Stances lay no guard, a swap card does);
  *"a Warrior without Heavy Plating has none to lose"* (a Warden-lineage Warrior keeps the lineage's 0.10); *"its bonus
  damage and Mana pay nothing without it"* (the companion's halves read no engine; ruling 2); *"the four boss offers
  that move"* (seven; ruling 4); *"a card, so this is GP's card gate, not ENGINE_READ"* (GP's card gate is a table named
  `ENGINE_READ` too); and *"two `test_batch_br` arms"* (five comparisons, their anchor and the 30 Rage arm).
- **SIXTY ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named **"Dawn of Decay
  HE …"**: the recon of HEAD's gates (**"HE recon"**), HEAD's trees (**"HE head"**, **"head2"**, **"headgj"**), this tree's
  traces and standalone runs (**"HE trace"**, **"trace2"**, **"solo"** and the seventeen **"solo check_…"**), the pre-pass
  (**"HE prepass"**) and the thirty-five controls (**"HE ctl c00"** to **"c28b"**). Each was renamed in `project.godot`
  before anything ran in it and seeded from the backup; they can be deleted. **There are 228 such folders now**,
  counting every folder there but the live game's own. **The untracked `save-backups/` folder inside the repo is not
  this batch's**; this batch's backup is `../save-backups/HE-20260922-101431`.
