# Batch GO — The nine missing engines

*Branch `class-merge`, from `c8c5de7` (GN). `main` is untouched. **IMPLEMENT ONLY.** The nine engines are the
designer's and are transcribed here: every class now holds six engine runes, and class selection deals three of six.
Four game scripts and the rune file, one new gate, twelve instruments moved with the code, one standing
rule, and the documents.*

## NEEDS A RULING

**Only what a player meets, or what blocks the ruled work, is here** (`docs/ways-of-working.md`). The rest is in
`docs/state.md`'s queue.

1. **FOUR MAGNITUDES ARE PROPOSED, NOT RULED** (§1–§4). The brief ruled every third cast, half strength, 25%, 5%,
   halved and two turns, and those are in. Four clauses came without a figure, so these are live until ruled, each one
   constant in `Classes`:
   - **The Reaver: +10% damage a kill**, uncapped as ruled (*"permanently stronger for the rest of the fight"*).
   - **The Leech: 25% of the damage dealt returns as Mana, and a point of damage taken costs 1 Mana.**
   - **The Arbiter: every ally heals 5% of the damage dealt to the judged enemy** (at least 1).
   - **The Skirmisher: +200%** — *"enormous"*, read as triple.
2. **RUNE OF THE TRACKER IS THE HUNTER'S CLASS PASSIVE'S EXACT NAME** (§8e). The Hunter class passive is *Tracker*
   (*"Always attacks first in every fight"*), so a Hunter holding the rune wears two chips that both read *Tracker*.
   It ships as the brief named it — a label collision is flagged, not renamed (BR §1) — and it is the one exact hit of
   the sweep a player sees. Renaming either is one string.
3. **THE BASTION'S BANK LASTS THE FIGHT, NOT THE RUN** (§1b). *"It banks indefinitely"* was read as *no cap and no
   decay*: the bank lives on the fighting body, which every battle builds new, so it opens empty each fight. Carrying
   it between fights is a save-state change and was not taken.
4. **WHAT "PREVENTED" INCLUDES** (§1b), the brief's own question. **Every cut the prevented-damage ledger books while
   the strike loop names the Warrior, plus the block, any barrier's absorb, armor and resistance — whoever's work it
   was.** So a blow cut to nothing (an absolute parry), a blocked blow and a blow a barrier ate whole each bank the
   whole blow — the same thing to it — while **a miss banks nothing**, because no blow arrived. A block banks the
   nominal blow (the ability's percentage of Attack, before variance), since a blocked blow is never rolled. **Not
   banked:** a relocation (another hero taking the blow), a resource payment (the Leech's, the Vow's), a death refusal
   and an enemy special that bypasses the strike loop.
5. **THE WEAVER REPEATS THE DAMAGE, NOT THE CARD** (§2a), the brief's other question. Each enemy the third cast damaged
   is struck again for half of what it took, and nothing else: **no status, no heal or shield, no summon, no Break
   damage, and nothing consumed a second time** — a Detonation's repeat is half of the blow its consumed Burn paid for,
   and the Burn is consumed once. **A basic attack counts as a cast**; a counter does not.
6. **THE OATHKEEPER'S FIRST BOND IS CHOSEN BY THE GAME** (§3a): the other living hero with the lowest maximum health,
   seat order on a tie. **The player does not pick it.** It is **HERO by choice** — a companion could take a share and
   a heal, and widening it is a ruling. It passes when the bound hero falls, ends when the Cleric falls, and binds again
   at a revived Cleric's next turn.
7. **THE ARBITER'S JUDGMENT MOVES TO THE HEALTHIEST ENEMY WHEN THE JUDGED ONE FALLS** (§3b). **The brief says only the
   Tracker's mark moves.** Without a move the Arbiter is a dead engine after its first target, so it was given the
   Tracker's rule.
8. **THE TRACKER'S AND THE SKIRMISHER'S PAY IS THE STRIKE LOOP'S** (§4a, §4b), Exposed's coverage: an attack or
   ability that strikes, and (for the Tracker) a companion's blow. **Damage over time and a handler that works out its
   own damage do not read either.**
9. **A BLOW THE SKIRMISHER BLOCKS OR PARRIES STILL STRUCK HIM** (§4b), so it resets his quiet count; a miss does not.
10. **THE NINE RULE TEXTS AND THE THREE CHIPS ARE THE BATCH'S WORDS** (§1–§4) — including *Tracked*, *Judged* and
    *Oathbound*, and the three drafts reworded because they used an engine name as an ordinary word (§5).
11. **THE FIFTEEN OLDER ENGINES' NAMES STILL REACH THE PLAYER** (§5b). Their rule texts open with them — *Blood
    Frenzy:*, *Heavy Plating:*, *Momentum:* and the rest — on the chip and the class-selection card. The ruling was
    built for the nine; whether it reaches the fifteen is a question of its scope.

## THE SHORT VERSION

- **Every class holds six engine runes; every deal is three of six.** Drawn 600 times a class, every one of the six
  appears in 46–54% of deals, and every deal is three distinct runes of the hero's own class (§6c).
- **The nine are rules**: no lineage, no enabler, no payload, the flat 100 gold. **Each is playable on the class kit
  alone**: a hero who takes one opens with his basic and his three kit cards, driven through the real class-selection
  screen into a first battle for all four classes.
- **Each hangs off a door the game already had** — the death door, the damage door, the status funnel, the strike loop
  — and each was driven alone and beside another engine of its class, every negative arm beside a positive one.
- **No new meter.** Five of the nine store a number on the fighting body; the two marks are statuses; nothing touches
  `second_resource` (§7).
- **The Reaver's kill share, measured:** 16.0% to 27.2% of a party's kills over 96 live fights, 0.54 to 0.92 kills a
  fight, at most four (§1a).
- **One new gate (`check_go`, 401 checks), twelve instruments repaired to intent**, all found by running the
  battery unmodified first. **One of them hid a defect by luck**: `check_gj`'s sanctioned red had turned green because
  the new deal moved its seeded road off the Tollkeeper's Bell; the Bell is handed to that run on purpose now.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md`, `docs/state.md`, `docs/kit-recon.html`, `docs/reports/GN.md`, and the
code each premise names. **Twenty-one claims checked: thirteen held, eight did not hold as written.**

| The brief says | Verdict | What the repo says |
|---|---|---|
| GK converted the fifteen engines that existed | Held | Fifteen engine runes in `data/runes.json` at GN. |
| The nine bring the Warrior, Mage and Cleric to six and the Hunter from three to six | Held | Four, four, four and three at GN; two, two, two and three new. |
| Heavy Plating, the stances and Trapper — *none accrues anything* | **Did not hold** for Heavy Plating | Its climb accrues: +8% Block an unblocked blow, capped at +40%, reset by a block (halved under the Standing Wall). The stances and Trapper accrue nothing. |
| The engine names are internal and never reach the player | **Did not hold** for the fifteen | Their rule texts open with their names, on the chip tooltip and the class-selection card. Built true for the nine (§5). |
| GL found nine of seventeen premises did not hold in its brief | Held | `docs/reports/GL.md`: *seventeen checked, seven held, one held as a ruling, nine did not hold*. |
| With four heroes, the final blow is the Warrior's perhaps one time in three or four | Held, roughly | Measured 16–27% (§1a) — one in four at best, one in six beside a Beastmaster. |
| Savage Assault is the only engine that reads kills | **Did not hold** | Lethal Aim reads one: a kill keeps at most 50 of the Sharpshooter's Focus (`_sharpshooter_focus`). It holds within the Warrior's six. |
| GM found Momentum's "taken" half counted only health lost | **Did not hold** | That was FV §1 (`CLAUDE.md`'s FT block). |
| Nothing in the game repeats a cast | **Did not hold** | Rampage (a Berserker card) recasts itself free on a kill, and Arcane Echo's mark repeats every damaging hit at 30% against its target. Neither repeats *every third cast*. |
| The Leech is the only engine that changes what being hit means for the Mage | Held, with a qualifier | Among engines, Runaway Resonance also raises the damage an Arcanist takes. Mana Shield (a card) already turns half of a blow into Mana. |
| The Oathkeeper's link moves, not re-targetable | Held as built | §3a. |
| GL found the Hunter has no heal, shield or cleanse for another hero anywhere in his pool | Held, over a wider population | GL's recon said it of the seventeen kit candidates; it is true of all fifty-one cards a Hunter can hold. |
| *Rune of Ambush* is one of the sixty runes FK authored — a live name | **Did not hold as written** | The live rune is named *Ambush* (bare, as every live rune is) and was authored at EZ §3; the sixty is the live pool. A live *Ambush* does exist, so the rename's reason holds. |
| Field Kit reads Trapper's own vocabulary | Held | `BattleUnit.DEBUFF_IDS`, which Trapper counts (`snared` and `mocked` included). |
| Heavy Plating climbs while he is not hit, and Redoubt banks when he is | **Did not hold** | The plating climbs on a blow that lands unblocked and resets on a block; the Bastion banks on both. |
| Savage Assault and Blood Frenzy both reward a long fight | Held | §6. |
| FT found `second_resource` is three currencies in one field | Held | `docs/reports/FT.md`: Mercy, Resonance and Focus. |
| *Rune of the Sentinel* is a retired Warden splash | Held | Retired, Warden-scoped. |
| FK found a retired rune's name is not free | Held | `test_runes` pins uniqueness file-wide, retired included. |
| FN found ten exact collisions where a brief named five | **Did not hold** | That was FK (forty rune names against 708). |
| Every class needs six, and each deal is three | Held | The charter (`CLAUDE.md`, GK). |

## §1 — WARRIOR

### 1a. The Rune of the Reaver (Savage Assault)

**Built.** The death door is `unit._die()`: it now calls the battle's `_on_unit_died` once `dead` is set and **before**
the statuses clear — the first draft called it after, and a dying enemy's marks were already gone. A kill counts when
the attribution frame that dealt it names the Warrior himself: his strike, his handler, his repeat, or a
damage-over-time effect he laid (a tick's frame carries its applier's name). The bonus is `reaver_bonus()` =
`REAVER_KILL_PCT` × kills, a term of the one general damage multiplier, so it adds with the other general terms and
multiplies with Blood Frenzy's own line.

**Driven, alone and beside Blood Frenzy:** an enemy the Mage fells adds nothing; one his own Strike fells makes the
same seeded Strike land x1.099 (161 → 177, the 10% after rounding); a tick an ally laid books nothing and a tick he
laid books his kill; an enemy felled by an enemy books nothing; thirty kills are +300%, no cap. Beside Blood Frenzy the
frenzy reads the same with the kills, and with half his health gone the Strike lands harder still (232 against 177).

**The kill share, measured** — the brief asked for it rather than the one-in-three guess. Live autoplay fights with the
enemies striking, zone-one warbands at tiers 1–8 (every fourth an elite), rung 2, untalented, 24 fights a party; a
wrapper on every enemy's death callback recorded who the frame named:

| Party | Kills | The Warrior's | Share | Kills a fight | Most in a fight |
|---|---|---|---|---|---|
| No lineage (the Reaver alone) | 74 | 19 | **25.7%** | 0.79 | 3 |
| Spines (Momentum beside it; Channel, Sanctity) | 81 | 22 | **27.2%** | 0.92 | 4 |
| Berserker, Pyromancer, Holy, Sharpshooter | 82 | 17 | **20.7%** | 0.71 | 3 |
| Warden, Cryomancer, Occultist, Beastmaster | 81 | 13 | **16.0%** | 0.54 | 2 |

The engine's own counter matched the wrapper's count in all four (19, 22, 17, 13). **So the bonus reached +40% at
most and +5% to +9% on average.** In the first party **7 of 74 kills were filed to an enemy's frame** — a kill made
inside an enemy's own swing (FOUND AND NOT FIXED).

### 1b. The Rune of the Bastion (Redoubt)

**Built.** `redoubt_bank` is a float on the fighting body, rounded only where it is spent or shown. The strike loop
names the struck hero (`_redoubt_victim`) from the damage roll to the armor read; **every `_prev` delta in that window
banks into him** (the parry cut and every mitigation site that books its delta), the **block** banks the nominal blow,
**`_on_barrier_prevented`** banks any barrier's absorb on a holder whoever cast it, and after the armor read the **armor
cut and a positive resistance cut** bank. **The spend** sits on Aegis Reversal's line: slot 0, not a counter, not an
absolute parry, a bank of at least 1 — the whole bank is added to `final` after armor and emptied.

**Driven, alone and beside Heavy Plating** (a 145 blow alone, 142 on the Warden):

| What reached him | Landed | Banked |
|---|---|---|
| Nothing turned it (armor 0) | 145 | 0.00 |
| Armor | 108 | 37.0 |
| A miss | 0 | 0.00 |
| A block | 0 | 136.0 — the whole nominal blow |
| A parry, armor 0 | 32 | 95.6 — the three quarters it turned |
| A parry, with armor | 24 | 103.6 — the parry's cut and armor's |
| A barrier | 78 | 67.0 — what it ate |

A bank of 57 on the basic attack lands 228 against 171 and empties; Crushing Blow spends none; the basic as a counter
spends none (192 against 192); a basic that misses keeps it. Beside Heavy Plating the same unblocked blow also climbs
the plating (+0.08 → +0.16) and the block still resets it. **A parry draws one die fewer than an unparried blow** (a
banked Guard is spent before the roll), so the parry arm is paired with a parry on no armor, never with the plain
blow — the gate's first draft compared them and read a false red.

**The bot's case** (`_bot_redoubt_pick`, consulted first by `_autoplay_pick`): spend the bank on the basic once it is at
least the basic's own nominal blow, at the lowest-health enemy (a Broken one first). An implementation call that moves
simulated figures only.

## §2 — MAGE

### 2a. The Rune of the Weaver (Echo)

**Built.** The spend line (`not is_counter`) counts every cast into `echo_casts`; the third arms `_echo_state` for that
cast, the damage door tallies what each enemy took from it (the frame's label is the cast), and when `_resolve` ends the
tally fires through `_echo_fire` — `take_hit` with no Break damage, a death handled as the recap handles one. A cast
that dealt nothing logs that it repeats nothing. **Which kind of repeat, and why:** replaying the card would re-lay its
statuses, re-heal, re-summon and consume a second time, so a Detonation would eat a Burn that is gone. Repeating half
of what each enemy took means the same on every Mage card and cannot pay a consumption twice. **No Mage card summons.**

**Driven, alone and beside Overburn:** a counter is not a cast; the second cast does not repeat; the third lands 312
against 208 + 104 (Magic Bolt), 249 against 166 + 83 (Fireball beside Overburn); the repeat lays no Break damage;
Nexus Ward as the third cast counts and repeats nothing; Magic Missiles' three bolts repeat once as half their sum
(440 against 293); Detonation as the third cast repeats half its damage with the Burn consumed once (642 against 428).

### 2b. The Rune of the Leech (Siphon)

**Built.** The return is read at the damage door: 25% of what the Mage's frame dealt, capped at his bar. The payment
is `_siphon_pay` in `take_hit` (after the barrier, the Vow and the bond, before Conversion) and at the top of
`take_tick_damage`: 1 Mana a point, **whatever the Mana cannot cover reaching health — never refused** — and booked to
no spend ledger, so Channel does not build off a blow.

**Driven, alone and beside Runaway Resonance:** 361 dealt returns 90 Mana, and the same cast without the rune returns
none; without the rune a 120 blow reaches health (145 on the Arcanist); with it none does and none books as spent;
5 Mana covers 5 of it; **at no Mana the whole blow reaches health** (120 of 120); a tick is paid the same way.

## §3 — CLERIC

### 3a. The Rune of the Oathkeeper (Covenant)

**Built.** `covenant_with` on both bodies; `_covenant_bind` when the fight opens (after the fallen are laid down), when
the bound hero falls, and at a revived Cleric's turn. `_covenant_split` in `take_hit` (after the barrier and the Vow —
a barrier is the body's own and eats first) and in `take_tick_damage`: half of what gets through goes to the partner
through `take_tick_damage` (a bond paying out rolls no parry and wakes no rider), under a re-entry guard. **A price a
hero pays himself is not shared** (the frame names the body), **nor is Break damage.** `heal_amount` splits a heal after
its absolute refusals and before its multipliers; a half the partner refuses comes back. The partner wears the
`oathbound` chip.

**Driven, alone and beside Mercy:** the Cleric opens bound to the Mage (maximum 99, the lowest); a 130 blow on the Mage
lands 65 and 65, a 118 on the Cleric 59 and 59; an unbound hero's blow and heal are his alone; a price the Mage pays
himself stays his; a 200 heal on the Mage heals him 100 and the Cleric 115 (his own +15%); a half the Cleric cannot take
stays with the Mage; the Mage falls and the bond passes to the Hunter; the Cleric falls and it ends; a revived Cleric
binds again at his turn.

### 3b. The Rune of the Arbiter (Judgment)

**Built.** At the damage door, **before** a mark is laid, a blow an ally deals a judged enemy heals every living ally
(`_hero_side()`: companions included — *"the whole party"*, ALLY) 5% of it, under a re-entry guard; then the first enemy
the Cleric damages is judged (`_lay_engine_mark`). When the judged enemy falls, the death door lays the mark on the
living enemy with the most health. A fallen Arbiter judges nothing.

**Driven, alone and beside Wrath of the Old Gods (with a bear):** nothing is judged before the Cleric strikes; his blow
judges and heals nobody; the Warrior's blow on an unjudged enemy heals nobody; the Warrior's 164 on the judged enemy
heals every ally 8 (171 heals 9, the bear too); the judged enemy falls and the judgment passes to the healthiest; with
the Cleric fallen nobody is healed.

## §4 — HUNTER

### 4a. The Rune of the Tracker (Quarry)

**Built.** The first enemy the Hunter damages is marked `tracked` at the damage door; his later blows do not move it.
`_quarry_mult` sits beside Hunter's Mark's multiplier in the hero strike loop and in `_companion_hit`; a fallen Tracker's
mark pays nothing, and on its enemy's death the mark moves to the healthiest.

**Driven, alone and beside Pack Bond:** nothing is tracked before he strikes; only the first enemy is; a blow on another
leaves it; the Warrior's Strike lands x1.251 on the tracked enemy (234 against 187) and the wolf's bite 175 against
140; the tracked enemy falls and the mark passes; with the Hunter fallen the mark pays nothing (182 against 182).

### 4b. The Rune of the Skirmisher (Opening)

**Built.** Armed at spawn. Spent above the strike loop, on Exhortation's model, by the first damaging cast that is not a
counter and passes the miss roll; applied as one term. `note_blow_met()` — the one call every blow that reaches a body
passes, block and parry included — marks him struck; `_rule_engine_turn` at each of his turn starts counts an unstruck
span and re-arms at two.

**Driven, alone and beside Lethal Aim:** he opens armed; a miss, a counter and Tripwire keep it; the first attack that
lands spends it, 449 against 150 (x2.993 — rounding); one quiet turn is not enough and two are; a blocked blow resets
the count; a missed one does not. **The unarmed control spends one `randf_range` first**: the armed shot floats a word
above its roll, a float's place is one `randf_range` off the global dice, and **a `randf_range` spends more of the
stream than a `randf`** — measured when a `randf` control missed by 7%.

### 4c. The Rune of the Medic (Field Kit)

**Built.** In `_apply_status`, beside Downwind and above the per-status branches, once the status has taken hold: a
living hero holding the rune who lays a `DEBUFF_IDS` status (Break excepted) on an enemy mends the hero with the lowest
share of health — 5% of that hero's maximum, and one harmful effect shed — under a re-entry guard. Every application
counts, so a Snare Trap mends as it is rigged and again as it springs. A companion's affliction does not count.

**Driven, alone and beside Trapper:** the Hunter's Cripple heals the most wounded Warrior 8 (5% of 154) and sheds his
Slow; the Mage's Cripple mends nobody; the Hunter's mark mends nobody; a Stun a boss refuses mends nobody; the lowest
share is the one mended; Snare Trap mends twice (8, 8); beside Trapper, Shrapnel Charge's afflictions mend again and
again (24).

## §5 — THE ENGINE NAMES NEVER REACH THE PLAYER

### 5a. The nine

Every word a player reads comes from the rune's noun: the chip's label (`engine_title`), the rule text (built from the
noun and the constants), the chip's live line, the floats and the log. **Three first drafts used an engine name as an
ordinary word** — *the opening returns*, *every third cast echoes*, *the judgment passes* — and were reworded before
they landed (*the bonus returns*, *repeats*, *is judged in its place*). `check_go` sweeps the rule texts, the rune texts,
the three chips' texts, **every float literal in `battle.gd` and `unit.gd`**, every log line the nine write in the live
stretches and every rule-engine chip read live, for the nine names **in any inflection** (*echoes*, *quarries*). Three
live card names own an engine word (Arcane Echo, Covenant of Ash, Quarry's Mark) and are stripped before the sweep,
except a word that IS an engine name — Quarry's Mark's chip reads *Quarry*, and stripping it would blind the sweep.
One float is another card's own word and is named, not skipped: Arcane Echo's `%d Echo`.

### 5b. The fifteen

Their rule texts open with their engine names (*Blood Frenzy:*, *Heavy Plating:*, *Seasoned Fighter:*, *Overburn:*,
*Glacial Hold:*, *Runaway Resonance:*, *Mercy:*, *Conviction:*, *Wrath of the Old Gods:*, *Momentum:*, *Channel:*,
*Sanctity:* …), shown on the chip tooltip and the class-selection card. NEEDS A RULING 11.

## §6 — PAIRS THAT COMBINE OR CANCEL (RULED ON NONE)

A hero holds two engines, so each of the nine will sit beside each of the other five of its class. **Driven** marks a
pair the gate runs; the rest are read off the code.

**Warrior**
- **Bastion + Heavy Plating — combine (driven).** The plating's higher Block chance makes more blocks, and a block banks
  the whole blow; an unblocked blow climbs the plating *and* banks the armor cut. A block still resets the plating.
- **Reaver + Blood Frenzy — combine (driven).** Different terms that multiply: the Reaver's is in the general
  multiplier, Frenzy's its own line. Frenzy pays for health lost and Rage spent, the Reaver for kills.
- **Bastion + Blood Frenzy — pull apart.** Prevention is what the bank is made of and what starves Frenzy (CZ §1's
  inversion): a blow kept off banks and feeds no Frenzy; a blow that lands feeds Frenzy and banks only its armor cut.
- **Bastion + Momentum — combine.** Both read a blow met: a block, a parry or an absorb books an exchange and banks.
- **Bastion + the stances — combine.** Defensive mitigation books to `_prev` and banks; Untouchable's absolute parry
  banks the whole blow.
- **Reaver + Momentum, Reaver + the stances — combine.** Quicker turns are more swings; a stance's damage term
  multiplies with the kill bonus.
- **Reaver + Bastion — neutral.** The bank lands after the multipliers, so the kill bonus does not grow it; a kill the
  bank lands is a Reaver kill.

**Mage**
- **Weaver + Overburn / Detonation — combine (driven).** The repeat is half of what landed, Overburn's term included;
  a consumption is never repeated.
- **Weaver + Leech — combine.** The repeat is framed to the Mage, so it returns Mana.
- **Weaver + Channel — combine.** Channel's term is in what landed; the repeat is not a cast and builds nothing.
- **Weaver + Resonance, Weaver + Glacial Hold — neutral.** The repeat lays no stack, Chill or freeze.
- **Leech + Channel — combine one way.** Mana paid for a blow is not Mana spent, so it builds no Channel; the Mana the
  Leech returns pays for more casts, which do.
- **Leech + Resonance — partly cancel (driven).** Resonance raises the damage an Arcanist takes, which the Leech then
  bills in Mana; Mana spent on blows is Mana not cast.
- **Leech + Overburn / Glacial Hold — combine.** A tick the Mage laid is framed to him, so burning and chilled enemies
  return Mana.

**Cleric**
- **Oathkeeper + Mercy — partly cancel (driven beside Mercy).** Healing either bound hero receives is split, and a half
  into a full bar is spent there; a heal aimed at one wounded hero of the pair arrives at half.
- **Oathkeeper + Conviction — partly cancel.** The shared half reaches the partner through the tick door, which a
  Divine Shield does not absorb, so it builds no Faith.
- **Oathkeeper + Arbiter — neutral to cancelling.** The Arbiter's heals on the pair are split again; with one of them
  full, half is lost.
- **Oathkeeper + a Leech partner — combine.** The Mage's shared half is paid in Mana too.
- **Arbiter + Wrath of the Old Gods — combine (driven).** Ruin's lifesteal and the judgment's heal both read damage
  dealt and both pay.
- **Arbiter + Sanctity, Oathkeeper + Sanctity — marginal.** A mark or a bond chip landing is a status event; the marks
  are battle-long, so Sanctity lengthens nothing.

**Hunter**
- **Tracker + Pack Bond — combine (driven).** A companion's blow reads the mark.
- **Skirmisher + Lethal Aim — combine (driven).** The opening multiplies a Sharpshooter's shot; a crit multiplies it
  again.
- **Skirmisher + the class passive — combine.** *Tracker* makes him act first, so the bonus lands on turn one.
- **Skirmisher + Pack Bond — neutral.** A companion's blow does not carry the bonus.
- **Tracker + Skirmisher — neutral.** The opening shot lays the mark as it lands, so the mark does not deepen it.
- **Medic + Trapper — combine (driven).** Trapper pays for afflictions; the Medic mends on each (Shrapnel Charge's
  mended three times).
- **Medic + Snare Trap — combine (driven).** The rig and the spring each mend.
- **Medic + Lethal Aim, Medic + Pack Bond — weak.** A Sharpshooter lays few afflictions, and a companion's affliction
  does not count.

## §7 — WHAT STORES A NUMBER, AND WHERE

**No new meter; nothing touches `second_resource`.** On `BattleUnit`, rebuilt every fight:
- the Reaver: `reaver_kills` (an int);
- the Bastion: `redoubt_bank` (a float);
- the Weaver: `echo_casts` (an int) — the armed cast's tally lives on the battle (`_echo_state`) for one cast;
- the Leech: `siphon_returned` (display only);
- the Skirmisher: `opening_armed`, `opening_quiet`, `opening_struck`;
- the Oathkeeper: `covenant_with` (a reference) and `_covenant_guard`.

The Tracker's and the Arbiter's marks are statuses on the enemy (`tracked`, `judged`), battle-long, in `DISPEL_NEVER`;
the Medic stores nothing. **Every one is shown on its chip's live line.**

## §8 — NOT DONE, AS RULED

No engine rune cost (the flat 100 stands), no card authored for the new engines, nothing for the Crown's Break or
freeze resistance, no pool merge, no talent node, no kit change.

## FOUND AND NOT FIXED

- **A kill, a wound or a return made inside an enemy's own swing is filed to that enemy.** Tripwire's retaliation, a
  Feint's reflect and a Mirror Guard return deal their damage under the enemy's attribution frame, so the Reaver does
  not count the kill, the Leech returns no Mana, the Arbiter heals nobody and no mark is laid. 7 of 74 kills in a party
  with no lineage were filed that way (§1a).
- **"Quarry" is already a player-facing word**: Quarry's Mark's chip reads it.
- **The name sweep's near-misses** (§9e): the retired Rune of the Reaper (Reaver, Weaver), the retired Rune of the
  Binding Oath (Oathkeeper, Oathbound), the live Long Leash (Leech), the Survivalist's engine id `trapper` and the
  *old_trapper* event (Tracker), the glossary's *Bound (Frostbind)* (Oathbound), and mechanical ones (Sever, Healer,
  Breaker, Magic, Cracked Hourglass, Lunging Bite). *Leech* is exactly the lane of the retired Rune of the Hollow
  Chalice, which no screen shows. The dormant `field_medic` field keeps the *Field Medic* name in comments only.
- **The first draft listed the bond's chip in `DISPEL_NEVER`**, where Dispel reads an enemy's statuses. It sits on a
  hero, and CH's convention puts a hero-side status in neither list; `check_el` caught it by deriving marks from that
  list, and it was taken out before landing.
- **Four control copies left user-data folders** under Godot's `app_userdata`: "Dawn of Decay GO probe", "Dawn of
  Decay GO inject", "Dawn of Decay GO head" and "Dawn of Decay GO trace". Each was renamed so its `user://` could not
  reach the player's saves; they can be deleted. `save-backups/GO-20260917-160913` is untracked, as every batch's is.

## §9 — INSTRUMENTS

### 9a. The new gate

**`check_go.gd`, 401 checks.** §0 reads the nine (six a class, the rule shape, the rune names, the kit a holder opens
with, the name sweep, the text standard, no tag, the constants in the text, unique names, the three statuses' lists,
and every float). §1 draws the deal 600 times a class and presses the real class-selection screen twice — once reading
what it deals, once taking the Reaver, the Leech, the Arbiter and the Skirmisher into the first battle, where each hero
holds his basic and his kit. §2–§10 drive each engine on two boards. §11 drives the bot's case. §12 runs four live
autoplay stretches with the enemies striking (one fragile enemy revived, so kills and moving marks happen) and sweeps
their log and chips. §13 reads the player's three files byte for byte.

**The controls, in isolated copies** (`config/name` renamed): **eleven engine injections** — the Reaver's count, the
Bastion's `_prev` bank, the Weaver's share, both halves of the Leech, the bond's split, the Arbiter's heal, the
Tracker's multiplier, the Skirmisher's multiplier, the Medic's mend and the bot's case — read **48 failures, every one
in its own section**. **Four name leaks** — *echoes* in the rule text, a bare `OPENING` float, *quarries* in a log line
and *echo* in a chip's live line — each went red. **The first of them passed the gate's first draft**, which matched only
the bare word; the gate reads inflections since, and *quarries* is why it reads *-ies*. The gate cannot compile on
HEAD's code, which has none of the constants it names, so its HEAD arm is the injection run.

**Three pairings in the first draft were wrong and were fixed before landing:** a parry and a counter each draw one die
fewer than a plain blow, so each is paired with its own kind; and the Skirmisher's control spends the float's
`randf_range`. **One arm killed the hero it measured** (a 110 blow on a 110-health Hunter), which moved the bond it was
about to read. **One live stretch hung**: a hand-answered Sharpshooter basic opens the press bar and waits for a press, so
a parked Lethal Aim holder answers with Tripwire.

### 9b. Run unmodified first — the reconnaissance battery

HEAD's instruments over GO's code, every target, frozen before and after (550 stamps, the saves included, identical).
**Ten targets red**, every one a population or count that follows the nine: `test_batch_as`, `test_batch_at` and
`test_batch_ba` (per-class engine counts), `check_es` and `check_ez` (the pool size), `check_fk` and `check_fo` (the
engine rune count), `check_di` (two new `_apply_status` sites), `check_dj` (one new no-op filter), `check_el` (the mark
population); plus `check_cm_live`'s standing sanctioned red. **`check_gj` went green** and six targets rose (§9d). No
parse error and no script error in any log.

### 9c. What moved, and why

Every repair was run both ways before it was trusted: **green on GO's code, and red on HEAD's at exactly the line
it moved** — `check_el` with a two-line shim for the two names GO added (it cannot compile on HEAD otherwise), and
`check_gj` red on both by design.

| Instrument | What moved | Why |
|---|---|---|
| `test_batch_as` | Mage engine runes 4 → 6 | the Weaver and the Leech; the charter's six |
| `test_batch_at` | Mage engine runes 4 → 6 | the same |
| `test_batch_ba` | Hunter engine runes 3 → 6 | the Tracker, the Skirmisher and the Medic |
| `check_es` §1 | the authored pool 142 → 151 | the nine engine runes |
| `check_ez` §0 | the pool 142 → 151; engine runes 15 → 24 (with the sixty, 75 → 84) | the same |
| `check_fk` §1 | engine runes 15 → 24 | the same |
| `check_fo` §2c | engine runes 15 → 24 | the same |
| `check_di` §1 | `_apply_status` call sites 215 → 217 | the bond's chip and the engine marks, both passing their holder (`with_src` 111 → 113) |
| `check_dj` §5 | the no-op `is_companion` census 26 → 27 | the Medic's pick, a `heroes.filter` carrying the filter |
| `check_el` §1 | `DISPEL_NEVER` 15 → 17, marks 10 → 12, the two engine marks set apart as a set (+1 check) | the Tracker's and the Arbiter's marks are laid by rule engines, which carry no tag |
| `check_ek` §3 | `check_go.gd` joins the tag-reading gates | the new gate reads `Runes.rune_tags` |
| `check_gj` §4 | the Tollkeeper's Bell handed to the run before the victory it reads | the new deal moved the seeded road off it; the sanctioned red is kept |
| `run_battery.sh` | `check_go` joins the gates | |

### 9d. Count movements, attributed

Each rise was attributed by an ok()-trace: every check message printed in a HEAD copy and in a GO copy, and the
multisets diffed.

| Target | HEAD → GO | What the new checks are |
|---|---|---|
| `check_gn` | 170 → 197 | 27 = the nine × 3: each engine held, dropped, and its opening slot count |
| `test_batch_al` | 470 → 479 | one per new engine rune |
| `test_batch_ba` | 704 → 773 | the three new Hunter engine runes × 23 Survivalist fields |
| `test_batch_bh` | 295 → 304 | one per new engine rune; its seeded upgrade walk reshuffled, count-neutral |
| `test_batch_cb` | 1859 → 1940 | 81 = 9 cards × the 9 new rune names |
| `test_runes` | 5502 → 5628 | 126 = 14 per new engine rune; its seeded grant order reshuffled, count-neutral |
| `check_el` | 23 → 24 | the new engine-mark arm |
| `check_parse` | 186 → 187 | `check_go.gd` joined the population it parses |
| `check_gj` | 70 / 0 on GO's seed | **not a repair**: the seeded run held no Bell (below) |

**`check_gj`.** GN sanctioned §4's red — the victory card prints `Run.award_gold`'s figure while the Tollkeeper's Bell pays
+20 beside it — and its seeded road took the Bell off an event. A print in both copies read `active_relics=["tollbell"]`
on HEAD's code (70 / 1) and `[]` on GO's (70 / 0): **the new deal draws differently, the road moved, and the defect was
hidden, not fixed.** The Bell is now handed to that run before the one victory §4 reads, and the arm reds again on GO's
code (card +158, purse +178). The row stays 70 / 1.

### 9e. The name sweep (BR §1)

The nine rune names, their nouns, and the three chip labels, against **1,432 names in sixteen populations**: abilities,
talent nodes, status ids and labels, items, relics, specs, spines, classes and class passives, every engine id and
title, tags, archetypes, runes live and retired (names and ids), rune lanes, enemies, enemy abilities, the glossary and
events. Exact, contained, a shared word or stem, an edit distance of two or less, or one word inside another counts as
a hit. **Exact:** *Tracker* (the Hunter's class passive — NEEDS A RULING 2) and *Leech* (a retired rune's lane).
**Contained:** the same two. **Near:** listed under FOUND AND NOT FIXED. **Bastion, Skirmisher and Judged met nothing.**
The sweep's first run read zero everywhere because it excluded any name equal to a noun, which blinded it to the class
passive; it excludes only the nine's own entries now.

## VERIFICATION

### The saves

Backed up to `save-backups/GO-20260917-160913` before anything ran, verified by hash: `profile.json` b05e329b…,
`relics.json` fdc12ffa…, `run_save.bin` c44d45da…, `settings.cfg` 0c1b39c3… (md5), equal in the live folder, the backup
and GN's backup. **After the acceptance run they read the same four hashes**, and each of the three batteries froze them with the tree and read them unchanged.

### The parse floor

`check_parse` read **187 checks / 0 failures with an empty stderr** on the finished code — stderr grepped for
`Parse Error`, never the tally and never the exit code.

### Before the documents and instruments landed

- **The reconnaissance battery** (§9b): HEAD's instruments over GO's code, every target, the tree and the four saves
  frozen before and after and identical. Its reds and rises are §9c and §9d.
- **The gate, in isolated copies:** 401 / 0 on the finished code, twice; the injection runs of §9a.
- **Every repaired instrument, standalone in the tree:** green, but `check_gj`'s sanctioned 70 / 1 (card +158, purse
  +178); `check_parse` 187 / 0 with an empty stderr; `check_go` 401 / 0. **And on HEAD's code:** each red at exactly the
  line it moved (`check_el` 24 / 3 with its shim, `check_ez` 106 / 2, the rest one failure each).
- **The documents** were written as scratch copies, swept against HEAD's text for every string literal of four or more
  characters that any instrument or game script holds (17,428 needles, raw, lowered and whitespace-flattened), and
  landed behind a hash check that the tree's copies had not moved. **No needle was lost from `CLAUDE.md`,
  `master.html`, the changelog or the design notes.** `state.md` lost seven, all from the replaced WHERE block, and no
  instrument that holds one reads that file. The one gained needle an instrument asserts absent (`second_resource`,
  `test_batch_bu`) is asserted against a code slice, not a document. The retired-word strip of `test_batch_bx` §4 and
  §4b, reproduced, read clean on `master.html`, the four data files and the thirteen scripts.
- `pin-manifest.json` was regenerated: 1,470 pins, only `check_el`'s nine line numbers moved; `--check` reads current.
- `CLAUDE.md` is **344,974 B = 336.89 KiB** against its 340 ceiling (+2,150 B = +2.10 KiB, 3.11 KiB of headroom
  left); the changelog **359,359 B** against its 400,000 B bar — both as `check_fg` prints them.

### The pre-pass — every target, with the new gate, the repairs and the documents in the tree

**110 readings, every one inside its `baselines.json` row**; `check_de` **469 checks / 0 failures / 0 notices**; the run
harness **22 / 382 / 8**, no throws; the two sanctioned reds exactly where they are recorded (`check_cm_live` 13 / 4,
`check_gj` 70 / 1). **No log carries `Parse Error` or `SCRIPT ERROR`.** The tree and the four saves were frozen before
and after (552 stamps) and read identical. No Godot process was running before it began (the `ps` rows, read).

### Between the two

Nothing in the tree moved: the freeze taken before the acceptance run equals the pre-pass's after-freeze. The
predictions below were written before it began.

### The acceptance run

**Predicted in writing:** every target inside its row — the two sanctioned reds as above, `check_go` 401 / 0,
`check_parse` 187 / 0, `check_el` 24 / 0 — `check_de` 469 / 0 with no FAIL line, the harness 22 / 382 / 8, the tree and
the saves identical before and after, and no error line in any log.

**Every prediction held.** 110 readings, every one inside its row; `check_de` **469 checks / 0 failures / 0 notices**;
the harness **22 / 382 / 8**, no throws; `check_cm_live` 13 / 4 and `check_gj` 70 / 1 (card +158, purse +178),
`check_go` 401 / 0, `check_parse` 187 / 0, `check_el` 24 / 0. **No log carries `Parse Error` or `SCRIPT ERROR`.** The
tree and the four saves read identical before and after (552 stamps), and no Godot process was left running.

### After the run

Two edits came after the acceptance run: this report's verification section, which no instrument reads, and two
section references in `docs/state.md` that pointed at the wrong sections of this report (§6 for §9, §2 for §1a).
**The second was proved by the literal sweep against the copy the run read: no needle lost or gained**, in any of
the three forms.

### The push

**Committed and pushed to `class-merge` only**; `main` is untouched. The post-push reading of
`git ls-remote origin class-merge` against local HEAD is reported with the delivery rather than here — written into
this file, it would change the commit it names.

## WHAT MOVED

- `data/runes.json` — nine engine runes.
- `scripts/classes.gd` — the nine (`RULE_ENGINES`, the constants, the rule texts), and the engine readers taught them.
- `scripts/unit.gd` — the fields, the live chip lines, the bond's and the Leech's doors in `take_hit`,
  `take_tick_damage` and `heal_amount`, the death callback, the Skirmisher's struck flag.
- `scripts/battle.gd` — the three statuses, the wiring, the strike-loop terms and banks, the damage-door and death-door
  readers, the Medic's hook, the Weaver's repeat, the bot's case.
- `scripts/run_state.gd` — a comment.
- `check_go.gd` (**NEW**), `test_batch_as.gd`, `test_batch_at.gd`, `test_batch_ba.gd`, `check_di.gd`, `check_dj.gd`,
  `check_ek.gd`, `check_el.gd`, `check_es.gd`, `check_ez.gd`, `check_fk.gd`, `check_fo.gd`, `check_gj.gd`, `run_battery.sh`, `baselines.json`, `pin-manifest.json`.
- `CLAUDE.md` (the marker off, one rule, the GK block), `docs/master.html` (§6.0, the damage lists, the stamp),
  `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md`, and this report.
