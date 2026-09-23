# BATCH HF — FIFTEEN CLASS RUNES, AND THE BOAR

**On `class-merge`, from `8d47428` (HE). IMPLEMENT ONLY.** The designer authored fifteen runes that read no engine —
five Cleric, five Mage, three Warrior, two Hunter — and Aper, the boar that Tusk and Bristle adds to Summon Companion;
this batch builds them, **drives every one on a hero holding no engine**, and builds §6 and §7's rulings: **Long Poison
un-gated** (Snare Trap, in every Hunter's kit, lays the very Poison it reads), **Mark of the Hunt offered to every Hunter
with a pet** (HE's gate undone; it sits out beside a dismisser, where neither half pays), and **Venom Coating gated on
Trapper** at every door, the zone boss included. **The sequence shifted again: the other seventy-three stale checks are
HG's**, and `docs/state.md` says so. No existing rune was retuned or retired; no engine, kit, card, pool or node moved;
the Mage pool was not split. `main` is untouched.

**THE FIGURES.** **Fifteen runes** in `data/runes.json` (151 → 166 entries, 60 → 75 live ordinary runes), every one class-scoped at
100g, written for no lineage and on no engine row, **each driven worn and bare on a hero holding no engine**, and each
confirmed against the rule at the line that pays it (§0b). **Aper**, a fourth companion kind, reached only through
Tusk and Bristle: every third charge stuns for one turn, the rhythm unchanged at 10 Loyalty, a boss resisting until
Broken. **What a hero holding no engine can be offered, at spawn / at the ceiling** (HC's table, by name): Warrior
2 / 6 → **5 / 9**, Mage 0 / 4 → **5 / 9**, Cleric 0 / 0 → **5 / 5**, Hunter 4 / 6 → **7 / 9** — every class at five.
**The rune gate's rows 43 → 42** (Long Poison out), **the card gate's 42** (Mark of the Hunt out, Venom Coating in, ruled),
**the pet gate's rune rows 4 → 5** (Tusk and Bristle), and **one new cause for a worn rune to sit out** (a rune he
wears cancels it). **One new gate**, `check_hf` (306), and **eighteen instruments repaired**, each with its reason at
the site (§9). **29 controls**, one defect a copy, each read by its FAIL text (§10). **The acceptance run:
125 of 125 launched, `check_de` 517 checks / 0 failures / 0 notices, no `Parse Error` and no `SCRIPT ERROR`, the tree frozen and the player’s saves byte-identical to the backup** (§12).

---

## NEEDS A RULING

1. **BURNING GROUND'S BURN — PROPOSED: 5% OF THE CLERIC'S MAXIMUM HEALTH, HOLY, AT THE START OF EACH OF HIS TURNS
   WHILE HIS CONSECRATION HOLDS (the brief's §1).** The brief asked for it to be priced against Consecration's own 5% heal. It is
   that 5% pointed the other way: the heal is 5% of each hero's OWN maximum at the start of each of THEIR turns; the
   burn is 5% of the CASTER's maximum to every enemy at the start of each of HIS turns, less the enemy's holy
   resistance, as a tick (no armor). **Four burns a cast** (his own copy of the blessing counts down on his turns), 6
   to each enemy at the Cleric's 121 maximum. Over one cast against three enemies it deals 72 against the heal's ~97
   across four heroes. **The rune's text names no number** (the designer's words are *"deals holy damage to every
   enemy each turn it lasts"*); if a number is wanted on the card, proposed: *"Consecration also deals holy damage
   equal to 5% of his maximum health to every enemy each turn it lasts."* The magnitude is the rune's payload
   (`rune_burning_ground` 0.05), so a ruling moves data.
2. **APER'S BODY, CHARGE AND BOON — PROPOSED (the brief's §4).** Ruled: it charges, every third strike stuns for one turn and the
   rhythm never shortens, a boss resists until Broken, and Loyalty raises its charge. **Proposed, against the other
   three:** 80 health and a charge of 20% of the hunter's Attack — the wolf's and the eagle's, the two companions that
   are not the tank; **Pack Bond's boon is its own charge, 15% harder a step of the bond's curve** (x1 at the first
   Loyalty, x2 at five) — the wolf's 15%, measured to land about where the wolf's boon does in absolute terms (the
   wolf's +15% rides the hunter's own ~20%-of-Attack shot per wounded enemy; the boar's rides its own 20%-of-Attack
   charge). No arrival effect and no raw-stack gift: none was authored. The strike step every companion takes (+5% a
   Loyalty stack) applies to it too.
3. **ABUNDANCE'S SHIELD — IT ADDS; IT HOLDS TWO TURNS (PROPOSED); AND WHETHER IT NEEDS A CEILING (the brief's §5).** Built as the
   words say: the overheal BECOMES a shield, added to any barrier standing (a max would make most of it become
   nothing). Two turns is Blessed Vestments' duration, the one other heal that leaves a barrier. **How fast it stacks
   under Consecration, measured on a party at full health: every hero gains the drip's spill every turn it holds —
   8 / 5 / 7 / 6 a turn (Warrior / Mage / Cleric / Hunter, at 154 / 99 / 121 / 110 maximum), 32 / 20 / 28 / 24 after
   four turns, about 20% of each maximum**; a Ministration into a full bar adds 20% of the target's maximum at once
   (30% under Vow of Silence, whose drip also rises by half). It is bounded by the healing poured into full bars and
   it expires two turns after the last spill, so **no ceiling was written**; a Holy Cleric's Mercy multiplier scales
   every heal it reaches, and so every spill. Cap it, or let it stand.
4. **MARK OF THE HUNT'S TEXT — PROPOSED WORDING THAT NAMES WHAT EACH HALF NEEDS (the brief's §7).** HE's proposal no longer fits
   (the card is not Pack Bond's). The card reads today, as its six lines:

   ```
   Mark an enemy for 7 turns: you and
   your companion deal +25% damage to it
   and every strike on it restores 3%
   of your max Mana. The cooldown resets
   if the marked enemy dies.
   Works with or without a companion.
   ```

   **Proposed (A) — the first five lines as they are, and the sixth replaced by two that say what each half needs:**

   ```
   Mark an enemy for 7 turns: you and          34
   your companion deal +25% damage to it       37
   and every strike on it restores 3%          34
   of your max Mana. The cooldown resets       37
   if the marked enemy dies.                   25
   Your companion's half needs a companion;    40
   yours needs the Rune of the Beastmaster.    40
   ```

   **Or (B) — the same two halves, and the "you" and "your" the text standard forbids taken out with them:**

   ```
   Mark an enemy for 7 turns: the Hunter's     39
   and the companion's attacks on it deal      38
   +25% damage, and every strike on it         35
   restores 3% of the Hunter's max Mana.       37
   The companion's half needs only a           33
   companion; the Hunter's needs the Rune      38
   of the Beastmaster. The cooldown resets     39
   if the marked enemy dies.                   25
   ```

   Every line is under the 44 ceiling (measured in code: A's widest 40, B's widest 39). Not written: the card's text
   is authored, and the brief asks for a proposal.
5. **KILL COMMAND HAS NO ORDER FOR APER (the brief's §4, FOUND HERE).** Kill Command's order is the companion's own — Ursus mauls,
   Canis bites, Aguila dives — and it names the three. With only Aper standing the cast logs the order and does
   nothing; with two companions under The Pack, the other obeys. **Ghostpack and Call of the Wild also name the three**
   and leave Aper out. A card's effects are the designer's, so none was given an arm. The smallest fix, if wanted:
   Aper obeys Kill Command with an ordinary charge (counting toward its rhythm).

## FOR THE RECORD — WHAT THE BRIEF ASKED ME TO REPORT, AND WHAT I BUILT

- **RETURNED BURDEN: THE ENEMY THAT APPLIED IT, WHILE IT STANDS; ELSE ANOTHER AT RANDOM (§1).** The rune says
  *returned*, and a burden returned goes back to whoever laid it — which also makes the card an answer to the enemy
  doing the laying. The applier is the name the status carries (`src_name`, DI's rule); where two enemies of one kind
  stand, the first of that name on the field takes it, because instances of a kind share a name. With the applier
  fallen, or no applier recorded (a bargain's or a modifier's status: 105 of the 220 call sites pass no `src`, `check_di`), another living
  enemy at random: nothing says which, so none is preferred. Each goes as it stood — its turns left, power, tick and
  every stack — with the Cleric as its source, so a boss still refuses a stun until Broken.
- **SEEKING MISSILES: SPREAD (§2).** Each extra missile flies at the weakened enemy it was counted for, after the
  volley's own three; a target that is weakened takes its seeker on top. With Unravel's weakness everywhere the volley
  reaches every enemy — the build the brief names. A seeker whose enemy has fallen falls back on the target.
- **GRUDGE BEFORE ANYTHING HAS STRUCK HIM: NOTHING (§3).** The foe is set where every blow that reaches him is booked
  (the line Opening and Momentum read *"an enemy struck him"* off — a block or a parry names its enemy, a miss does
  not); with no foe, neither the +40% nor the -20% applies, and when the foe falls the grudge goes with it.
- **RENDING BLOWS: THREE STACKS TAKE ALL THE ARMOR (§3).** One Sunder is x0.65 of armor — a MULTIPLIER, so three
  compounded would leave 27%. The brief's *"three times 35%"* is an addition, so the depths ADD: 35% of the armor a
  depth, 70% at two, and the third FLOORED AT ZERO. Driven on a raider's 0.15: 0.0975 / 0.045 / 0.000.
- **APER'S THIRD-STRIKE COUNTER RESETS ON A SWAP, A FRESH SUMMON AND A NEW FIGHT (§4) — ALL THREE, BECAUSE THE COUNT IS
  THE BODY'S.** A companion returns from a swap or a death as a fresh body (its health and statuses do not carry,
  `_do_summon`), and a new fight builds every unit anew; the rhythm is the boar's, so it restarts with the boar — and
  the chip on the boar shows it restarting.
- **THE BOT CHOOSES APER (§4).** The bot's order of preference was the literal `["canis", "aguila", "ursus"]` at three
  sites (the class kit's case, the rotation's fill and its swap); it is one constant now with Aper first — handed only
  to a Hunter wearing the rune, so every other Hunter's order is unchanged draw for draw — and the swap prices Aper at
  its boon. Driven: with the rune the rotation and the class-kit case both call Summon Aper; without it, Summon Canis.
- **VOW OF SILENCE AND BURNING GROUND: GX's TELL APPLIES, AND IT IS USED (§5).** Burning Ground pays nothing beside the
  vow, so it sits out, with GX's sentence (a third cause) on GX's four surfaces; both are still offered and can be
  worn together.
- **VOW OF SILENCE KEEPS HIS BREAK DAMAGE (§1).** *"He deals no damage"*, read in this game's own words: Break damage
  is "Break damage (BD)" everywhere, so a Vow Cleric's Smite deals 0 and still lays its 16 Break damage. If the vow is
  meant to silence his Break too, it is one line.
- **A SPELL IS A CAST WITH A MANA PRICE (§2).** Clarity and Profligate read *"a spell"* and *"his spells"*; the free
  basic (Magic Bolt) costs nothing and is not one, so Clarity is not a +50% on every free bolt at a full bar.

---

## §0 — THE PREMISES, AND EVERY READ SITE AGAINST THE RULE

### §0a — the brief's claims, checked against the repo before anything was edited

| The brief said | The repo said | |
|---|---|---|
| HE recorded HF as *"the other seventy-three stale checks"* | `docs/state.md` said so twice (the WHERE block and the running order's step 6), and once more as *"HF's now"* against HA's second document pin | held; all three now name **HG** |
| after HE the no-engine offer is *"Warrior 2, Mage 0, Cleric 0, Hunter 4"* | HE's state and `check_gv` §3's `RUNE_FLOOR`: 2 / 6, 0 / 4, 0 / 0, 4 / 6 (spawn / ceiling) | held (the spawn halves) |
| *"these fifteen bring every class to five"* | Warrior 2 + 3, Mage 0 + 5, Cleric 0 + 5 — and the Hunter 4 + 2 + Long Poison (§6) = **7** | held, and the Hunter goes past it |
| *"HE confirmed a no-engine Mage is now offered no runes at the start of a run"* | HE's ruling 5 | held |
| every kit card named — Ministration, Unburden, Consecration; Magic Burst, Nexus Ward, Magic Missiles; Crushing Blow, Pommel Strike, Mocking Blow; Powershot, Snare Trap, Summon Companion | `Classes.CLASS_KITS`, word for word | held |
| the kit statuses — Elemental Weakness (Magic Burst), taunt (Mocking Blow), Sunder (Crushing Blow), stun and Poison (Snare Trap) | each card's own payload: `_apply_elem_weak`, `mocked`, `sunder`; Snare Trap stuns and Poisons **when it springs**, on the enemy's turn | held; the Poison lands a turn late, which is why HC's census missed it (§6) |
| *"Mocking Blow makes two enemies strike him"* | *"the target AND one other enemy must attack the Warrior for 4 turns"* | held |
| *"Threatening Presence already draws enemies to him"* | the Warrior's class passive: Warriors draw 20% more of the random picks | held |
| *"three times 35% is past a whole armour value"* | one Sunder is a MULTIPLIER — armor x0.65 — so three compounded would leave 27% | **the words are an addition, and were built as one** (35% of the armor a depth, floored at zero; FOR THE RECORD) |
| Aper's boss rule is *"Pommel Strike's rule exactly"* | Pommel Strike's stun lands on an unbroken boss **on a Perfect**; a companion's charge has no bar | held for the rule; the Perfect exception cannot apply |
| *"GN and GS both found the bot cannot use cards outside its lineage branches"* | GN: a kit card owes the bot a case in `_bot_class_kit_pick`; the bot's pet order was a literal of the three | held; Aper needed its own entry (FOR THE RECORD) |
| the Cleric's five *"build on healing and mitigation"* | Burning Ground is damage (Consecration's), and Returned Burden casts afflictions | three of five |
| Snare Trap's Poison *"is the same status Long Poison reads"* (§6, to establish) | the spring calls `_apply_poison` with the Hunter as `src`; Long Poison is read at that line, off `src` | **yes** — un-gated (§6) |
| *"HB's pet gate withholds"* Tusk and Bristle *"from a Sharpshooter"* | the gate is `Runes.COMPANION_READ`, a table: a new rune that needs a companion owes it a row (HB) | built as a row, then driven: 0 in 400 cache rolls beside Lethal Aim (§3) |
| Mark of the Hunt's companion half *"never needed the engine"* | the companion's two halves are read off the companion; the hunter's two inside `has_engine("pack")` | held (driven, §7) |
| Venom Coating: *"everything it does needs Trapper"* | its whole payoff — every attack Poisons — is read inside Trapper's on-hit block | held |
| *"declining a draft refuses its held-back cards. The column shows them"* | the draft column shows how many it holds back and the rune that brings them back — not their names | recorded as ruled; the wording differs |
| *"Slaughterhouse stays on the Berserker's engine"*; *"Stabilize and Primal Surge are gated boss cards"* | both as HE built them | recorded, nothing moved |

### §0b — every rune at the line that pays it (the rule: kit cards and basic, class resource, the kit's statuses, healing and damage)

| Rune | Where it is read | What that line reads | An engine? |
|---|---|---|---|
| Abundance | `_abundance_shield`, called from `_stat_heal`'s door | the heal's own overheal (`last_overheal`), once a heal | none |
| Returned Burden | Unburden's arm, `_return_burden` | what `purge_debuffs_taken` lifted, and each status's `src_name` | none |
| Burning Ground | `_burning_ground_tick`, after `_consecration_tick` | his own Consecration standing, his maximum health, the enemy's holy resistance | none |
| Eleventh Hour | Ministration's arm | the target's health against `ELEVENTH_HOUR_AT` | none |
| Vow of Silence | `_healing_done_mult`, the drip in `_consecration_tick`, and `_deal_gate` | heals; the attribution frame | none |
| Unravel | the strike loop, beside Magic Burst's own weakness | Magic Burst, `_apply_elem_weak` | none |
| Seeking Missiles | the strike loop's hit count | Magic Missiles, `elem_weak` on each enemy | none |
| Detonating Ward | Nexus Ward's arm (arms it), `take_hit`'s absorb, `barrier_broken_cb`, `status_expired_cb` | the ward's own absorbs | none |
| Clarity | `_resolve`, before the price comes off | a Mana price, the Mana bar full | none |
| Profligate | `_resolve` (damage) and `_eff_cost` (price) | a Mana price | none |
| Goading Roar | the enemy blow's multiplier block, on Cripple's line | `mocked`, which Mocking Blow lays, and its power (the Warrior's seat) | none |
| Rending Blows | the strike loop, below Crushing Blow's Sunder | Crushing Blow, `sunder` and its depth | none |
| Grudge | the strike loop: set where a blow reaches him, paid in the multiplier block | the enemy whose blow reached him | none |
| Opportunist | the strike loop's Powershot block | Powershot, `stunned` (any source) | none |
| Tusk and Bristle | `battle._summon_choice`, the one place a call is built | Summon Companion | none |

**Not one reads an engine.** Two of the brief's list are close enough to name: Grudge is set on the line **Momentum and
Opening read** (*an enemy struck him*) — it reads the blow, not either engine's meter; and Aper's charge grows with
**Loyalty**, which is Pack Bond's (§4) — the brief's own words (*"Pack Bond deepens the bond"*), paid by the engine
into the boar the way it is paid into the other three, while the RUNE reads no engine: without Pack Bond the boar
charges and stuns on the same rhythm (§2's no-engine arm).

---

## §1–§4 — THE FIFTEEN, AS BUILT, AND WHAT EACH PAYS ON A HERO HOLDING NO ENGINE

Every figure below is `check_hf` §1's: each rune worn and bare on the same board under the same dice, a party
holding no engine, the deterministic fixture (no miss, no block, no parry, no crit). The rune reaches its hero
through the spawn, as a bought one does; the gate never writes a rune field.

**CLERIC (§1).**

| Rune | Worn / bare | How it is built |
|---|---|---|
| Abundance | Ministration into a full bar: a spill of 31 becomes a 31 shield; three drips: 6 / 12 / 18 (bare 0) | off `last_overheal` at `_stat_heal`'s door, once a heal (`overheal_shielded`); **added** to any barrier standing; two turns (PROPOSED, NEEDS A RULING 3); the shield carries the Cleric as its source |
| Returned Burden | Blind back on the archer that laid it, Cripple on the raider; a Hex with no applier onto a random enemy (bare: nothing moves) | FOR THE RECORD |
| Burning Ground | one caster turn burns 6 / 6 / 6 (bare 0) | the start of HIS turn while HIS Consecration holds (his own copy counts down on his turns, so four burns a cast); 5% of his maximum, holy, a tick (no armor) — PROPOSED, NEEDS A RULING 1 |
| Eleventh Hour | Ministration at 20% health: 62 worn / 31 bare; at 27%, just above the line: 31 / 31 | read before the heal lands (after it, nobody is low); the rune's 1.0 is the increase, so it doubles the whole heal |
| Vow of Silence | Smite 0 / 20 — its 16 Break damage lands both ways; Ministration 46 / 31; the ground's drip 8 / 6; a tick of his 0 / 12 | `_healing_done_mult` and the drip; the silence at `_deal_gate` (the frame, enemies only; FOR THE RECORD) |

**MAGE (§2).**

| Rune | Worn / bare | How it is built |
|---|---|---|
| Unravel | weakness on three of three worn, one of three bare | the same weakness through the same door (`_apply_elem_weak`) on each other living enemy, laid after the Burst's blow, as the target's is |
| Seeking Missiles | with every enemy weakened: 49 / 11 / 12 worn against 36 / 0 / 0 bare (the target, then the other two) | FOR THE RECORD; each seeker is a counted hit with its own roll, so every rule that counts hits counts it |
| Detonating Ward | broken at 200 absorbed: 200 to each enemy; run out at 7: 7 to each (bare 0 / 0) | armed at Nexus Ward's cast; every absorb booked while armed (`ward_det_absorbed`); a flat blow — no armor, no resistance — through `barrier_broken_cb` (mid-blow, as the Mantle's pass) and `status_expired_cb` |
| Clarity | Magic Burst from a full bar 53 against 35 bare; from a short bar 35 / 35; Magic Bolt 22 / 22 | a spell is a cast with a Mana price, decided before the price comes off (FOR THE RECORD) |
| Profligate | Magic Burst 49 against 35; the price 50 against 25; Magic Bolt 22 / 22 | the price doubles in `_eff_cost` after every discount and before the ward's multiplier; a waived cast stays free |

**WARRIOR (§3).**

| Rune | Worn / bare | How it is built |
|---|---|---|
| Goading Roar | a taunted blow on him 13 worn / 17 bare; an untaunted one 17 / 17 | on Cripple's line, where this game says an enemy *deals less*; it reads the Warrior's seat off the taunt's power and books what it spared to him |
| Rending Blows | a raider's armor 0.15 → 0.0975 / 0.045 / 0.000 / 0.000 worn (depths 1, 2, 3, 3) against 0.0975 flat bare | FOR THE RECORD; the depth is the status's power (`BattleUnit.sunder_depth`) and the chip says it |
| Grudge | before anything struck him 19 / 19; on his foe 26 / 19; on another 15 / 19; his foe fallen 19 / 19 | FOR THE RECORD |

**HUNTER (§4).**

| Rune | Worn / bare | How it is built |
|---|---|---|
| Opportunist | Powershot on a stunned enemy 33 / 16; on a free one 16 / 16 | the Powershot block, any stun (a snare, Pommel Strike, Aper's third charge); a boss that refused a stun is not stunned and is not doubled |
| Tusk and Bristle | the picker offers Ursus, Canis, Aguila and **Aper** worn; the three bare | `_summon_choice` is the one place a call is built, so one line gates the picker, the swap and the bot |

**APER** (`check_hf` §2): with no engine, six charges stun on the 3rd and 6th, the chip reading 1/3, 2/3, 0/3 and round
again; **under Pack Bond at 10 Loyalty the rhythm is the same six** — it never shortens; against a boss, three charges
while unbroken stun nothing and the three after it is Broken stun on the sixth (the count ran on); the charge is 16
with no engine and **19 under Pack Bond** (the boon, x1.20 at that Loyalty). The body is 80 health; it is
`Classes.RUNE_COMPANION_KINDS`' one kind and `Classes.is_companion_kind` is the door that asks *is this a companion*;
its call is defined beside the three in `spec_abilities("beastmaster")` and is in no pool or kit, so its one door is
the rune (`check_dv` §5). The bot calls it first when the rune is worn — `["Summon Aper", "Summon Aper"]` through the
rotation and the class-kit case, `["Summon Canis", "Summon Canis"]` without — and a Sharpshooter wearing the rune
cannot call it (his engine dismisses the pet).

**LONG POISON (§6), on the same board**: the snare's Poison lasts the fight (−1) worn against 4 turns bare, with no
engine.

---

## §5 — THE TWO PAIRINGS THAT CANCEL

**VOW OF SILENCE BESIDE BURNING GROUND: GX's TELL APPLIES, WITH A THIRD CAUSE, AND IT IS USED.** GX's rule is that a
rune which cannot pay sits out, visibly, while it stays worn; its two causes were an engine that is not equipped and a
companion that is dismissed. Burning Ground beside the vow is a third — **a rune another rune he wears forbids** — so
the table is `Runes.CANCELLED_BY` (one row, Burning Ground: Vow of Silence) and the one answer is
`Runes.cancelled_by`, which `Runes.sits_out` asks off the ids of the ordinary runes he has EQUIPPED
(`Run.worn_rune_ids`) — never what he owns: a vow in the pouch forbids nothing. The sentence is GX's, byte for byte
in its opening clause, with the rune's nouns (37 characters at its widest line):

```
Sits out of every fight while the
Vow of Silence is worn, which forbids
the damage it deals.
Still worn: the slot stays filled.
Unequipping the rune frees the slot.
```

**Driven on all four of GX's surfaces** (`check_hf` §4 and §4b): the battle log's roll call names it sitting out, and
the burn's read site refuses, so it pays nothing beside the vow (burned: no) and burns alone (burned: yes); the map's
rune slot reads `○ Burning Ground` with the sentence in its tooltip, and `Burning Ground` worn alone; the pouch row
carries the one sentence, flattened, and the rune's own rule worn alone; the hero sheet's state column reads `sits out`
once, with the sentence, and never worn alone. **The vow is never the one that sits out** — it pays — and both are
still offered and can be bought and worn together.

**ABUNDANCE UNDER CONSECRATION: THE SHIELD GROWS BY THE DRIP'S SPILL EVERY TURN IT HOLDS.** Measured on a party at full
health through four turns of the ground, each hero's own drip, the spill read off the tick (`last_overheal`, the
recipient's own healing multipliers included) rather than re-derived:

| Hero (maximum) | a spill a turn | after 1 / 2 / 3 / 4 turns |
|---|---|---|
| Warrior (154) | 8 | 8 / 16 / 24 / 32 |
| Mage (99) | 5 | 5 / 10 / 15 / 20 |
| Cleric (121) | 7 | 7 / 14 / 21 / 28 |
| Hunter (110) | 6 | 6 / 12 / 18 / 24 |

About 5% of each maximum a turn, ~20% after four. It is bounded by the healing poured into full bars, and it lapses two
turns after the last spill; **no ceiling was written** (NEEDS A RULING 3).

---

## §6 — LONG POISON IS UN-GATED

**The Poison Snare Trap lays IS the Poison Long Poison reads.** The snare springs at the start of the snared enemy's
turn, and the spring calls `_apply_poison(victim, 4, …, src)` with the Hunter as `src`; Long Poison is read at that
line — `elif src.rune_long_poison > 0: p_turns = -1` — off the same `src`. So every Hunter's kit card lays the status
the rune reads, and HE §1's premise (*no class kit lays it*, from HC's census) did not hold: **the census cast each
card once, onto a clean enemy, and read what it laid then — a trap lays nothing at the cast.** The row is gone from
`Runes.ENGINE_READ`, the read site asks no engine (Thin Blood's price beside it still asks Trapper, GW §3's reason),
and it is offered to every Hunter: at spawn with no engine (`check_hf` §3), at the Peddler, a cache and a bargain with
Trapper and without (`check_he` §1, inverted), handed over by a cache answered with Trapper out, and seated either way
(`check_he` §2). Driven paying with no engine: the snare's Poison lasts the fight (§1). `CLAUDE.md`'s HC block carries
the lesson — find every kit card that lays a status, including one whose payload lands on a later turn.

---

## §7 — MARK OF THE HUNT, AND VENOM COATING

**MARK OF THE HUNT IS OFFERED TO EVERY HUNTER WITH A PET.** HE §2's full gate is undone: the card is out of the card
gate and the seat table, and is a row of `Classes.COMPANION_READ` whose **door opens** (`door: false` — it half-works,
so the derivation never refuses it bare) and whose **seat is RULED** (`seat: true, ruled: "HF §7"`, read by
`Classes.companion_seat` and `Classes.companion_read_ruled`): beside a dismisser neither half can pay, so a copy
carried there sits out with the pet's sentence, and the pet gate withholds it from the offer — **which closes HE's
finding that it was offered beside Lethal Aim and then sat out**. `Classes.sits_out`'s clause for a row whose engine
itself sits out is kept and binds no row now — the rule for the next one, not a patch for this card.

**What a Hunter with a companion and no Pack Bond receives, driven** (`check_hf` §5, 400 rolls an arm at the
Beastmaster's zone boss, the one pool that holds the card):

| Holding | Offered | Carried | What it pays him |
|---|---|---|---|
| no engine | 307 in 400 | seated | the companion's half: a wolf's blow on the prey 20 against 16 off it, 3 Mana fed a blow; his own shot 16 on and off |
| Pack Bond slotted | 251 in 400 | seated | both halves: his own shot on the prey 20 against 16 |
| Pack Bond owned and unslotted | 307 in 400 | seated | the companion's half, as with no engine |
| Lethal Aim slotted | 0 | sits out | nothing (no companion) |
| Pack Bond beside Lethal Aim | 0 | sits out | nothing |

**Before HE** he was offered it (HE's report: *"0 times unslotted where HEAD offered it just as often"*), it was
seated, and it paid the same companion's half; **at HE** he was offered it 0 times in 400 and a copy he carried sat
out, paying nothing; **now** he is offered it and it pays what it paid before HE. The rate is not HD's: the
Beastmaster's zone-boss pool is five cards (Bestial Wrath, Spirit Bond, Primal Surge, Call of the Wild and the mark),
and since HE §3 Primal Surge — Pack Bond's — is withheld from a Hunter without Pack Bond, so a triple is drawn from four
and holds the mark about three times in four (307); with Pack Bond slotted it is drawn from five (251).

**VENOM COATING IS TRAPPER'S.** A RULED row of `Classes.ENGINE_READ` (`engine: "trapper", ruled: "HF §7"`), so
`Classes.offerable` withholds it at every door the card table reaches: the Survivalist's zone boss offered it 246 in 400
with Trapper slotted, **0** with no engine, **0** with Trapper owned and unslotted; a stored triple answered without
Trapper holds it back, keeps it and hands it back once Trapper is in (`check_hf` §5, `check_he` §4). It is on no draft
pool, so the boss is its one door. **It is a row at the OFFER only** — its cast lands with no engine (the coating goes
on and pays nothing), so the seat derivation never finds it, and a copy drafted under Trapper stays on the bar after
Trapper is dropped (FOUND AND NOT FIXED).

**RECORDED, AS HE RULED:** Slaughterhouse stays on Blood Frenzy (the cost accepted when the six were gated on their
authoring engine); Stabilize and Primal Surge are gated boss cards; declining a draft refuses its held-back cards.
Nothing moved for any of the three.

---

## §8 — THE NAME SWEEP (BR §1), EVERY NEAR-MISS TREATED AS A HIT

**Seventeen names** — the fifteen, Aper and its call *Summon Aper* (and the chip's word, *Rhythm*) — against **1,277
labels in sixteen populations**: abilities 231, enemies 21, enemy abilities 48, glossary entries and ids 98 each, items
and item ids 8 each, lanes 36, relics 25, runes and rune ids 151 each (retired included), spec and passive names 27,
status ids 172 and labels 169, the seven tags and the 27 talent nodes. A hit is an exact match, a containment, a
shared stem or an embedded word; the batch's own new names (Summon Aper, the `aper_rhythm` chip and its *Rhythm*) are
excluded by (population, name).

**No ability-against-ability duplicate**, the one kind BR §1 renames: *Summon Aper* is the only new ability name and
nothing else holds it. **Every other hit is a label collision, and ships as specified** — every name here is the
designer's — **and is named here:**

| Name | Hits | The ones that matter |
|---|---|---|
| Burning Ground | 17 | **Consecrated Ground** (the Devout's card and its `cons_ground` chip — the brief's named near-miss, and the same class); Burn, Slow Burn and Overburn (card, chips, glossary); two retired runes (the Burning Censer, the Long Burn) |
| Detonating Ward | 17 | **Detonation** (the Pyromancer's card — the brief's near-miss, and the same class — and a retired rune lane of that name); the `ward` status and its *Ward* label (a contained word); **Nexus Ward**, the card it reads; the Warden (spec name, engine rune, a chip label), the Withered Warden (enemy), Warding Chant (enemy ability), two relics and two retired runes |
| Returned Burden | 14 | **Unburden**, the card it reads, and its *Unburdened* chip; Rite of Return (card and chip); Turn the Blade (card and chip, *turn* inside *Returned*); The Extra Turn (glossary), a talent node and a retired rune |
| Eleventh Hour | 5 | the Resonating Hourglass (item) and the Cracked Hourglass (relic); Events (glossary, *event* inside *Eleventh*) |
| Vow of Silence | 5 | the `vow` status id (a contained word) and **Vow of Suffering** — card and chip, a Cleric card — and a retired rune (the Standing Vow) |
| Seeking Missiles | 5 | **Magic Missiles**, the card it reads; Missing (glossary), You Cannot Miss (talent node), The King's Ledger (relic, *king* inside *Seeking*) |
| Rending Blows | 3 | **Shadowrend** (the brief's near-miss — a Cleric card, a different class); **Crushing Blow**, the card it reads, and Mocking Blow |
| Goading Roar | 2 | the `roar` status id and its label **Guardian's Roar** — Ursus's chip, the Hunter's bear |
| Grudge | 2 | a retired rune, **the Rune of Grudges** (id `grudges`) — a retired entry still owns its name, and the two names differ by a letter |
| Profligate | 1 | Tier Gates (glossary, *gate* inside *Profligate*) |
| Aper | 2 | a retired rune, the Rune of the **Reaper** (*aper* inside it) |
| Summon Aper | 4 | Summon Ursus, Canis, Aguila and Companion — its own family, by design |
| Abundance, Unravel, Clarity, Opportunist, Tusk and Bristle, Rhythm | 0 | — |

**AND ONE THE SWEEP'S POPULATIONS COULD NOT SEE, FOUND BY A GATE: *OPPORTUNIST*.** Two talent nodes deleted at FX carried
the word — a Swordmaster node whose counter `opportunist` is still declared on `BattleUnit`, dormant, and the
Sharpshooter's *Opportunist's Aim* (`opp_aim_step`). The rune's field was first `rune_opportunist`, and `check_em` §2 —
which reads `rune_X` beside `X` as a rune re-keyed off a node's counter — went red five times on the kinship (EM's
field-name rule, working). **The field is `rune_opportunist_shot`**, and the comment beside it says why. No label
population carries a unit field, which is why the sweep read 0.

---

## §9 — THE UNMODIFIED GATES AGAINST THE NEW TREE, AND EVERY REPAIR

**HEAD's whole battery ran first, unmodified, against HF's game code** (an isolated copy, renamed in `project.godot`
before anything ran in it, its own `user://` seeded from the backup): **124 of 124 targets launched, no `Parse Error`
in any log, one target threw** (`check_gv`, 300 `SCRIPT ERROR`s: its §1 drive seats the lineage a rune was written for,
and the fifteen were written for none), and **`check_de` read 513 checks / 21 failures / 16 notices.** Every red was
read by its FAIL text before anything was edited, and every repair below is to the arm's intent, with its reason in a
comment at the site (CQ §3). The counts are each target's standalone reading on the landed tree.

| Target | HEAD's copy on HF's code | What it asked that moved | The repair | Now |
|---|---|---|---|---|
| `check_gv` | 1040 / 80, 300 throws | the rows and the groups partition the ordinary runes; Long Poison a row; §1 drives each by its lineage | Long Poison out of `ROWS` into `STATUS`; the fifteen a `KIT` group, sorted by what each reads, scoped to a class; §1 asserts `check_hf` §1 drives each (the drive is there, not copied here); `RUNE_FLOOR` at the gate's own print | 1037 / 0 |
| `check_he` | 251 / 20 | HE's rulings: Long Poison's row, Mark of the Hunt's two, the boss rows | every arm inverted to HF §6 and §7, none deleted; Venom Coating driven at the boss | 249 / 0 |
| `check_gt` | 3190 / 8 | Mark of the Hunt a ruled seat row | an UNDONE row: no row in either table, usable bare, seated and shown seated with Pack Bond dropped | 3187 / 0 |
| `check_ez` | 114 / 6 | its sixty were *the live non-engine runes* | the sixty written for a lineage; the fifteen counted beside them, each asked price, scope, tag and shape | 129 / 0 |
| `check_em` | 468 / 5 | `rune_opportunist` read as a rune twin of the dormant `opportunist` | **the code moved, not the gate**: the field is `rune_opportunist_shot` | 464 / 0 |
| `check_fe` | 79 / 3 | the rune tag table's size and primary columns; BREAK on 11 rows | 142 rows; DEBUFF 38, DEFENSE 39, OFFENSE 32. **Its third red was the batch's own tag**: Rending Blows was first tagged DEBUFF and BREAK, and re-derived at its read site to DEBUFF alone — Sunder takes armor, and nothing it reads touches Break — so BREAK stays on 11 rows | 79 / 0 |
| `check_fk` | 64 / 3 | its pool of sixty | the fifteen counted apart and held to the pool's rules | 65 / 0 |
| `check_gx` | 1320 / 3 | 43 gated, 17 ungated, four companion runes | 42, 33, five | 1320 / 0 |
| `check_es` | 57 / 2 | the pool's size; the costed set | 166; Grudge joins the set (a real term) | 57 / 0 |
| `check_di` | 44 / 1 | `CALL_SITES` 217 | 220 (Returned Burden, Aper's stun, Abundance's shield) | 44 / 0 |
| `check_dv` | 83 / 1 | eight abilities outside every pool and kit | nine, and Summon Aper's one door is the rune | 84 / 0 |
| `check_fn` | 81 / 1 | TRADEOFF 12 | 15 | 81 / 0 |
| `check_fo` | 90 / 1 | the live pool 60 | 75, the trade still FO's sixty | 90 / 0 |
| `check_ft` | 147 / 1 | §6c holds `note_blow_met` and the Block roll adjacent | **the code moved**: Grudge's record stands above FV §1's comment | 147 / 0 |
| `check_hc` | 72 / 1 | a no-engine Cleric has nothing ordinary eligible | he is granted ordinary runes now; the fall-back driven on a Cleric carrying his five | 74 / 0 |
| `test_batch_as`, `_at` | 272 / 1, 358 / 1 | the Mage's class-wide runes, three | the three retired and HF's five live, each asked the same question | 273 / 0, 359 / 0 |
| `test_batch_az` | 449 / 1 | no live Hunter rune written for no lineage | HF's two are that population, asked AZ's question again | 450 / 0 |
| `test_batch_ba` | 818 / 1 | the Hunter's class-wide runes | HF's two counted live and asked the Survivalist's counters | 819 / 0 |

**GREEN AND MOVED** (a per-rune or per-card loop walking the new content; each attributed by an ok() trace, the notes in
`baselines.json`): `check_dr` 83 → 84, `check_gs` 733 → 749, `test_batch_al` 479 → 494, `_ar` 508 → 513, `_ax`
218 → 223, `_ay` 405 → 407, `_bh` 304 → 319, `_bu` 492 → 493, `_bv` 551 → 552, `_cb` 1962 → 2097 and `test_runes`
6655 → 7370. **The two sanctioned reds** stayed at their counts: `check_cm_live` 13 / 4, and `check_gj` 70 / 1 — its
figures moved again (*"+167 gold and the purse moved 187"* on HF's code), the gap the same twenty.

**AND TWO REPAIRS THE RECON COULD NOT HAVE SHOWN**, because HEAD's battery holds no `check_hf.gd`: `check_ek` §3 lists
it among the targets that check a tag (listed before the battery, `TAG_CHECKERS`), and `check_da` §3 forbids a gate
authoring its own `_spawn` — `check_hf`'s party helper delegated to `Gate.spawn` and was named `_spawn`, so it is
`_fight` now (the pre-pass of the gates that sweep every `.gd` caught it).

**THE LITERAL SWEEP** (every string literal of four or more characters in all 129 instruments, HEAD's copy and the
working copy, against every changed file, HEAD's bytes and the working bytes, raw and whitespace-flattened): **14 LOST**,
each read at its instrument and none of them a needle into the file it left — `check_gp`'s `" with Pack Bond"` and
`" without Pack Bond"` (a message's format, from `CLAUDE.md` and `master.html`); `check_fs`'s and `test_batch_cb`'s number
words `fourteen` and `sixty` (their word readers, from `master.html`); `check_hf`'s own negative needle for Long Poison's
old guard (from `battle.gd`, asserted absent); `test_batch_ba`'s `"his Poison never expires"` (a message, from the
deleted `runes.gd` row's `why`); and **seven from `docs/state.md`**, which is rewritten every batch — `SCOPE_INFO`,
`bared_plate`, `rune_bared_plate_bd`, `rune_bd_bonus`, `scripts/run_sim.gd`, `scripts/shop_screen.gd` and `ERROR`, every
one of them HE's own WHERE block, held by gates that read SOURCE files rather than that one. **Every GAINED literal** is
a positive needle of `check_hf` or `check_he`, or a common word that no negative assertion reads.

---

## §10 — THE CONTROLS

**29 controls, one defect a copy**, each in its own isolated copy of the landed tree (renamed in `project.godot`
before anything ran in it, its `user://` seeded from the backup), each gate run unmodified against it and **read by
its FAIL text, never its count**: a control that reds on the wrong line has not shown the arm it was aimed at.

| # | The defect | What went red, in its own words |
|---|---|---|
| c01 | Abundance's read site also asks for the Rune of the Holy (`has_engine("mercy")`) — a no-engine rune reading an engine | `check_hf` 3: *"§1 Abundance: Ministration on a full ally left a shield of 0 worn (spill 31)"*, the three drips 0 / 0 / 0, and §4's four turns on the party |
| c02 | Burning Ground's own refusal beside the vow removed | first run: `check_hf` **green** — the vow's frame gate silences the burn anyway, so health could not tell a refused tick from a silenced one; §4 now reads the log too (a silenced tick still logs a burn and books it to the recap). Re-run: `check_hf` 1: *"§4 (both worn): the roll call says it sits out 1 times, the ground did not burn, and the log carries 1 burns"* |
| c03 | the map's rune slot builds its sentence without the worn ids | `check_hf` 1: *"§4b (with the vow): the map's slot for Burning Ground does not carry the sentence in its tooltip"* |
| c04 | `APER_STUN_EVERY` 3 → 2 | `check_hf` 7: *"six charges stunned [false, true, false, true, false, true] — every third, never sooner"*, in both arms, and the chip reading 1/2 |
| c05 | Aper's stun written straight onto the victim, around `_apply_status` | `check_hf` 1: *"charges on a boss stunned [false, false, true, …] — resisted unbroken at the third"* |
| c06 | Tusk and Bristle's pet-gate row removed | `check_hf` 2: *"tusk_and_bristle is not a `COMPANION_READ` row"*, *"a Hunter with Lethal Aim was offered Tusk and Bristle 101 times"*; `check_gx` 1: *"4 sit out beside the dismisser — the five that need a companion"* |
| c07 | Long Poison's read site asks for Trapper again | `check_hf` 2: *"`_apply_poison` still asks an engine"*, *"the snare's Poison stood at 4 turns worn and 4 bare on a Hunter holding no engine"*; `check_he` green — it asks the offer and the seat, never the payout (its own header says so) |
| c07b | Long Poison's `Runes.ENGINE_READ` row put back, on Trapper | **the two-armed control for §6's repairs.** `check_hf` 5 (*"Long Poison is still an engine row"*, the ruled set, and a Hunter never offered it with no engine, with Pack Bond, with Lethal Aim); `check_gx` 2 (*"43 gated runes"*, *"32 ungated"*); the repaired `check_he` 5 (§0's row and ruled set, §1's offer and cache answer, §2's seat); the repaired `check_gv` 6 (§0's table, §2a's roll, §3's spawn set and both Hunter floors). **HEAD's `check_he`, which expects the row, goes the other way: six Long Poison reds on HF's tree, zero with the row back** — it is satisfied by the defect its repair now catches. **HEAD's `check_gv` reads the same way**: 16 Long Poison reds on HF's tree, 1 with the row back — and the one that stays is the rune paying with the engine merely owned (*"long_poison moved something with trapper merely OWNED"*), which is HF §6's finding said by HEAD's own gate: the read site pays without the engine, so the row does not belong in the table. |
| c08 | Mark of the Hunt's ruled seat off | `check_hf` 5 (*"with Lethal Aim slotted, carried Mark of the Hunt is seated"*, the row, the sentence); `check_he` 6 (§0's companion row, §3's seats, the sentence, the bar beside Lethal Aim) |
| c09 | Venom Coating's card-gate row removed | `check_hf` 5 (*"with no engine the zone boss offered Venom Coating 246 times"*, Trapper unslotted the same, the stored answer handed over); `check_he` 6 (§0's rows and boss set, §4's roll and answer) |
| c10 | Sunder's depth unfloored | `check_hf` 1: *"armor 0.1500 read [0.0975, 0.045, -0.0075] … FLOORED AT ZERO at three"* |
| c11 | Grudge's penalty paid with no grudge, and after the foe falls | `check_hf` 2: *"before any enemy struck him his Strike dealt 15 worn against 19 bare — NO grudge, NO penalty"*, and the same once the foe fell |
| c12 | a spell is any cast off the Mana bar, free ones included | `check_hf` 2: *"Magic Bolt at full Mana dealt 33 against 22 bare — a free cast is not a spell"*, and Profligate's *"31 against 22"* |
| c13 | Profligate's price no longer doubles | `check_hf` 1: *"Magic Burst dealt 49 for 25 Mana against 35 for 25 bare — 40% more for twice the Mana"* |
| c14 | every seeker flies at the first weakened body (`seek_bodies[0]`) | `check_hf` 1: *"the two other weakened enemies took [0, 0] worn and [0, 0] bare — a missile each, spread"* |
| c15 | Eleventh Hour's line moved from a quarter to a half | first run: `check_hf` **green** — its above-the-line probe sat at exactly 50%, which is not below 50%. The probe moved to 27%, just above the ruled quarter. Re-run: `check_hf` 1: *"at 27% health, just above a quarter, Ministration healed 62 worn against 31 bare — the same"* |
| c16 | the vow zeroes a silenced blow's Break damage too | `check_hf` 1: *"Smite's Break damage read 0 worn against 16 bare — Break damage is its own word and still lands"* |
| c17 | Abundance's shield replaces the barrier standing instead of adding to it | `check_hf` 2: *"three drips on a full hero left shields [6, 6, 6] worn — each spill ADDS 6"*, and §4's party read flat |
| c18 | the ward that runs out does not detonate | `check_hf` 1: *"the ward ENDED having absorbed 7 and dealt [0, 0, 0] worn"* |
| c19 | Unravel's read site never fires | `check_hf` 1: *"Magic Burst left Elemental Weakness on [true, false, false] worn and [true, false, false] bare"* |
| c20 | Goading Roar's cut never applied | `check_hf` 1: *"the taunted enemy's blow dealt 17 worn against 17 bare — 25% less"* |
| c21 | Opportunist's doubling never applied | `check_hf` 1: *"Powershot on a stunned enemy dealt 16 worn against 16 bare — double"* |
| c22 | the bot's order loses Aper (`BOT_PET_ORDER` back to the three) | `check_hf` 1: *"the bot's rotation and its class-kit case called ["Summon Canis", "Summon Canis"] with the rune — Aper"* |
| c23 | Abundance retired in `data/runes.json`, so the Cleric falls below five | `check_hf` 5: *"abundance is not a live ordinary rune"*, *"a cleric holding no engine is offered 4 ordinary runes at spawn — every class reaches five"*, the by-name arm, HE's-plus-HF's arithmetic, and the three doors; `check_gv` 2 floors: *"offered 4 at spawn, below its floor of 5"* and the same at the ceiling (its §2c sampling lost a triple of three rows as collateral, which is the pool being one rune thinner) |
| c24 | `check_hf`'s own table stops naming Abundance, so nothing drives it | `check_gv` 1: *"abundance reads no engine and `check_hf` §1 does not drive it — a KIT rune nobody drives"* — the pointer is checked, not assumed |
| c25 | Mark of the Hunt's seat row put back in `Classes.SITS_OUT`, keyed to Pack Bond | the repaired `check_gt` 6: *"Mark of the Hunt still sits out without pack — HF §7 undid HE §2's ruling"*, *"sits out, and no ruling named it"*, and the drive's four (the bar, the sheet, the Kit panel, the seats with Pack Bond dropped). **HEAD's `check_gt` goes the other way**: eight reds on HF's tree, two with the row back — and both of those are the missing `ruled` marker, not the seat |
| c26 | `check_hc` §3's construction no longer carries the Cleric's five, so the fall-back's premise is false | `check_hc` 2: *"the Cleric carrying every ordinary rune he could be offered (0) is still eligible for an ordinary one"*, and the fall-back arm reading *"granted 0 runes of 20"* — the construction is asserted, so a premise that stops holding cannot pass quietly |
| c27 | Long Poison's `written_for` removed, so a lineage rune reads as one of HF's | `check_ez` 3 (*"59 entries carry no retirement, expected 60"*, *"16 are HF's class runes"*, the live walk), `check_fk` 2 (*"the live pool is 59, not 60"*, *"16 live runes are written for no lineage"*), `check_fo` 1 (*"the live pool is 75 (16 of them HF's), not 60 + 15"*) — the two populations are told apart by the field, and each gate says so in its own words |
| c28 | `check_ek`'s list of tag-checking targets drops `check_hf.gd` | `check_ek` 1: *"exactly the authored TARGETS check a tag — found [… check_hf.gd …]"* — a new gate that reads a tag is listed, or the population arm says so |

**TWO CONTROLS READ GREEN THE FIRST TIME, AND BOTH ARE REPORTED WITH WHAT THEY FOUND** — a control that does not bite
is a measurement of the arm, not a wasted run. **c02**: Burning Ground's refusal beside the vow could be removed and
the burn still paid nothing, because the vow's own damage gate silences it anyway; health could not tell a refused
tick from a silenced one, so §4 reads the battle log too (a silenced tick still logs its burn and books it to the
recap — two false records), and the re-run reds. **c15**: Eleventh Hour's above-the-line probe sat at exactly half
health, so a threshold moved to half was not below it; the probe sits at 27%, just above the ruled quarter, and the
re-run reds. **THREE CONTROLS ARE TWO-ARMED** (c07b, c25 and, by its own construction, c26): the defect is read by the
repaired gate AND by HEAD's copy of it, and the two go opposite ways — HEAD's `check_he` loses six Long Poison reds
and HEAD's `check_gt` six of its eight Mark of the Hunt reds when the old rows are put back, which is what a repair
that re-points a gate is supposed to look like.

---

## §11 — WHAT WAS DELIBERATELY NOT DONE

- **No existing rune was retuned or retired.** `data/runes.json` gained fifteen entries and lost nothing: every other
  entry is byte-unchanged. Long Poison's un-gating is a row taken out of `Runes.ENGINE_READ` and a guard taken off its
  read site; its entry did not move.
- **No engine, kit, card, pool or node changed.** `Classes.CLASS_KITS`, every draft and boss pool and the talent tree are
  as HE left them. **Summon Aper is a call, not a card**: its definition sits beside the other three calls in
  `spec_abilities("beastmaster")`, it is in no kit and no pool, and Summon Companion's picker is the only place it is
  reached — through the rune. Its description is the brief's words with the three proposed numbers in them (NEEDS A
  RULING 2), and every line is under the 44 ceiling.
- **No card's text was reworded**: Mark of the Hunt's is proposed, twice (NEEDS A RULING 4); Summon Companion's still
  names three (FOUND AND NOT FIXED); Kill Command, Ghostpack and Call of the Wild were given no arm for Aper (NEEDS A
  RULING 5).
- **Venom Coating's payload did not move** — the card is gated, as ruled; its payload stays inside Trapper's block.
- **HG — the other seventy-three stale checks — follows.** None was taken here; `docs/state.md` names HG for them.
- **The Mage pool was not split on mechanics** (ruled: see how it plays).
- **No magnitude was invented beyond the three the brief left unset**, and each of those is flagged: Burning Ground's
  burn, Aper's body and boon, Abundance's duration (NEEDS A RULING 1–3). A number the batch had to choose to build a
  rule the brief worded — Rending Blows' 35% a depth, the Sunder's own step; Eleventh Hour's quarter, the brief's 25% —
  is the brief's own.
- **`main` is untouched.**

---

## §12 — THE VERIFICATION

- **THE SAVES, FIRST.** The player's four files were copied to `../save-backups/HF-20260922-160208` before anything ran
  and verified by MD5 against the live files (profile `ed4144e1…`, relics `fdc12ffa…`, run save `25582edd…`, settings
  `0c1b39c3…`, the same four HE's backup holds). **They are byte-identical to that backup now**, and the four hashes
  taken at the start of the acceptance run and at its end are the same four.
- **HEAD's UNMODIFIED BATTERY AGAINST HF's CODE** (§9): 124 of 124 launched, no `Parse Error`, `check_de` 513 / 21 / 16.
- **THE PRE-PASS** — the whole battery on an isolated copy of the landed tree, the rows written first: **125 of 125
  launched, `check_de` 517 checks / 0 failures / 0 notices**, and no `Parse Error` and no `SCRIPT ERROR` in any of the
  125 logs.
- **THE ACCEPTANCE RUN**, in the repository, with nothing else running (the rows of `ps` read before it started, not a
  count): **125 of 125 launched (with `check_hf`), `check_de` 517 checks / 0 failures / 0 notices**, no `Parse Error`
  and no `SCRIPT ERROR` in any log, and **the two sanctioned reds at their counts** — `check_cm_live` 13 / 4, and
  `check_gj` 70 / 1, whose figures moved with HF's runes to *"+167 gold and the purse moved 187"*, the gap still the
  Tollkeeper's Bell's twenty.
- **THE FREEZE**: every tracked and untracked file hashed by absolute path at the start of the run and at its end —
  **564 paths, and two moved: `docs/state.md` and `docs/reports/HF.md`**, both this batch writing itself up while the
  run was going. **Nothing else in the tree moved**, no instrument reads `docs/reports/`, and the one target that opens
  `docs/state.md` — `check_es` §4's census sweep — was re-run against the final documents afterwards and reads 57 / 0
  (with `check_ec` 24 / 0 and `check_fg` 22 / 0 beside it). **The rest of the tree is what the run read.**
- **THE PARSE FLOOR**, read the brief's way — `Parse Error` grepped in every log, never a tally and never an exit code:
  **zero across the recon's 124, the pre-pass's 125 and the acceptance run's 125**.

---

## §13 — WHAT MOVED

- **`scripts/battle.gd`** — the fifteen's read sites (Abundance's shield at `_stat_heal`, Returned Burden's
  `_return_burden`, `_burning_ground_tick`, Eleventh Hour at Ministration, the vow at `_healing_done_mult`, the drip and
  `_deal_gate`, Unravel, Seeking Missiles' hit count, Detonating Ward's arming and `_ward_detonate`, Clarity and
  Profligate at `_resolve` and `_eff_cost`, Goading Roar, Rending Blows' deepening, Grudge's record and payment,
  Opportunist); Aper (`COMPANION_STATS`, the `_summon_choice` gate, the picker over both kind lists, `BOT_PET_ORDER` at
  three sites, `_bot_boon_worth`, the strike arm, the `aper_rhythm` chip); Long Poison's guard off; the roll call's
  worn ids.
- **`scripts/unit.gd`** — sixteen `rune_` fields, `grudge_foe`, the ward's two fields, `aper_strikes`, `deal_gate_cb`
  at `take_hit` and `take_tick_damage`, the ward's absorb booked, `sunder_depth` and `SUNDER_STEP`,
  `purge_debuffs_taken`, `overheal_shielded`; a stale comment on `rune_long_poison`.
- **`scripts/classes.gd`** — Summon Aper's call and tag row, `RUNE_COMPANION_KINDS` and `is_companion_kind`; Venom
  Coating's ruled card-gate row; Mark of the Hunt out of the card gate and the seat table and into `COMPANION_READ`
  with a ruled seat (`companion_seat`, `companion_read_ruled`), and `sits_out` asking the seat.
- **`scripts/runes.gd`** — Long Poison's row out of `ENGINE_READ`; Tusk and Bristle's `COMPANION_READ` row;
  `CANCELLED_BY` and `cancelled_by`, and `sits_out` taking the worn ids; the fifteen's tag and shape rows.
- **`scripts/run_state.gd`** — `worn_rune_ids`, the cancelled cause in `rune_sits_out_note`, `sitting_out_rune_names`
  and `sits_out_note` asking the new doors. **`scripts/map_screen.gd`**, **`scripts/party_screen.gd`** — the worn ids
  passed to the note on the pouch, the map's rune slot and the hero sheet.
- **`data/runes.json`** — the fifteen, and nothing else.
- **The instruments**: `check_hf.gd` (**NEW**, 306 checks) and `run_battery.sh`; the repaired `check_gv`, `check_he`,
  `check_gt`, `check_ez`, `check_fe`, `check_fk`, `check_gx`, `check_es`, `check_di`, `check_dv`, `check_fn`,
  `check_fo`, `check_hc`, `check_ek`, `test_batch_as`, `test_batch_at`, `test_batch_az` and `test_batch_ba` (§9);
  `pin-manifest.json` regenerated; `baselines.json`.
- **The documents**: `CLAUDE.md` (the no-engine block, and the HB, HC, GM, GP, GT and GV blocks amended),
  `docs/master.html` and its stamp, `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md` (rewritten), and
  `docs/reports/HF.md` (**NEW**).

---

## FOUND AND NOT FIXED

- **SUMMON COMPANION'S TEXT NAMES THREE COMPANIONS** (*"Ursus, Canis or Aguila, chosen at the cast"*), and with Tusk and
  Bristle worn the picker offers a fourth. The card's text is authored; the rune's own text says what it adds, and the
  picker shows Aper's call with its own description. Wording is the designer's.
- **A VENOM COATING CARRIED WITHOUT TRAPPER IS STILL SEATED** (§7). HF §7 gates the OFFER; the card casts with no
  engine, so the seat derivation never finds it, and a copy drafted under Trapper stays on the bar after Trapper is
  dropped — casting a coating that pays nothing. A seat row would be a ruling (HE §2's shape for Mark of the Hunt,
  since undone).
- **RETURNED BURDEN FINDS ITS APPLIER BY NAME.** A status carries its applier's name (`src_name`, DI's rule), and two
  enemies of one kind share a name, so the first of that name on the field takes the burden back.
- **A REFLECT LEAKS PAST VOW OF SILENCE.** The vow reads the attribution frame, and Consecrated Ground's reflect is
  dealt inside the enemy's own blow, whose frame is the enemy's — so a Vow Cleric standing on Consecrated Ground (a
  drafted card) still hurts the enemy that strikes him. BL's rule, one reader more: damage the frame does not credit to
  him is damage the vow cannot see.
- **DETONATING WARD PAYS ON TWO REMOVALS, NOT EVERY ONE.** It detonates when the ward BREAKS or ENDS — the two the rune
  names; a barrier stripped another way (a purge, a smaller ward cast over it, the fight ending) pays nothing, and the
  absorbed total starts over at the next cast.
- **BURNING GROUND STOPS WHEN THE CLERIC FALLS.** It burns at the start of HIS turn, and a fallen Cleric has none, while
  the ground he laid goes on healing the others for its remaining turns.
- **`check_hf` §3's EARLIER CEILING WAS A SECOND DEFINITION, AND IT IS GONE.** Its first cut counted every card any rune
  of the class names — the Warrior's ceiling read 10 there against `check_gv` §3's 9, the tenth being Blood Debt, whose
  Blood Price only the Berserker's zone boss offers. HC's table is `check_gv`'s (a hero with no lineage drafts only his
  class's pool), so `check_hf` reads it that way now and `RUNE_FLOOR` is the gate's own print. Recorded so a later
  reading of "ten" is known for what it was.
- **THIRTY-SEVEN ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named **"Dawn of Decay HF
  …"**: the recon of HEAD's gates (**"recon"**), this tree's working copy (**"dev"**) and a one-off debug copy (**"dbg"**), the two ok() trace trees (**"trace_head"**, **"trace_new"**), the pre-pass (**"prepass"**) and the thirty-one control runs (**"ctl_c01"** to **"ctl_c28"**, with **"ctl_c07b"** and the two re-runs **"ctl_c02r"** and **"ctl_c15r"**). Each was renamed in `project.godot` before anything ran in it and seeded from the backup; they can
  be deleted. **There are 272 such folders now**, counting every folder there but the live game's own. **The
  untracked `save-backups/` folder inside the repo is not this batch's**; this batch's backup is
  `../save-backups/HF-20260922-160208`.
