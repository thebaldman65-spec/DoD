# BATCH HC — THE RUNES LEAVE THEIR SPECS

**On `class-merge`, from `b7fc9e8` (HB). IMPLEMENT ONLY.** Every rune that was scoped to a spec is scoped to its
class now — **all 110, the 60 live and the 50 retired** — mapped by the code key (`spec:inquisitor` is the Cleric's,
`spec:mystic` the Hunter's), and **three gates decide what a hero can use**: the engine it reads slotted
(`Runes.ENGINE_READ`, GV), the card it changes held (`requires_ability`), and a companion present
(`Runes.COMPANION_READ`, HB). It is GP's pool merge one layer over. **The three HB follow-ups are built as ruled**: the
Sharpshooter's pity meter counts per CAST; the zone boss's first-tier offer asks the pet gate and is the fourth door;
and Pack Bond held beside Lethal Aim sits out, visibly, in GX's words on GX's four surfaces. **No rune was authored,
retuned or retired; no engine, kit, card, node or pool moved; the Mage pool is not split; HD and HE come after.**
`main` is untouched.

**THE NUMBER THE BRIEF ASKED FOR, UNROUNDED (§3):** with no engine, a Warrior can be offered **5** ordinary runes at
spawn and **9** once he has drafted every card they name, a Mage **3** and **7**, a Hunter **5** and **7** — and **a
Cleric 0 and 0**. Every one of the Cleric's fourteen reads Mercy, Conviction or Ruin, so **a Cleric who takes a
spine, a rule engine or nothing is offered no ordinary rune at all**, and neither is one holding any pair of the
Cleric's three non-lineage engines. The names are in §3.

---

## NEEDS A RULING

1. **SIX RUNES FALL THROUGH ALL THREE GATES AND CAN STILL BE USELESS TO THE HERO THEY ARE OFFERED TO (§2c).** Long
   Fuse (Burn), Killing Cold and Deep Cold (Chilled), Long Poison (his own Poison), Mirror Guard (the Defensive
   guard) and Slaughterhouse (an enemy bleeding out). **No class kit lays any of the five things they read**, so
   each pays only once a drafted card, an engine's enabler or an ally supplies it. At the spec scope they reached
   only the lineage that did; now they reach the whole class. Driven on a full road (§8), the bot was offered them
   while carrying nothing that could pay them. **Gate them (and on what), or leave them as a draft to build toward,
   is the designer's.** Nothing was gated: a fourth gate is new machinery the brief did not ask for.
2. **BARED PLATE'S PRICE COSTS MOST WARRIORS NOTHING NOW (§2d).** *"+25% Break damage — but he can no longer
   Block"*: the price refuses the Block roll, and **a Warrior who is not of the Warden's lineage and holds no Heavy
   Plating opens with a Block chance of exactly zero** (driven: 0.000 for no lineage, the Berserker's and the
   Swordmaster's; 0.100 base and 0.250 live for a Warden with Heavy Plating; 0.150 for a no-lineage Warrior holding
   Heavy Plating). At `spec:warden` every hero who could buy it had the Warden's 10%; at `class:warrior` three
   lineages in four and every spine- or rule-engine-taker buy +25% Break damage for a price that refuses a roll that
   cannot succeed — until he drafts a Block card. **It is the one costed rune the scope change made free**, and a
   rune may not be retuned here.
3. **THE SCOPE BAND NO LONGER DISTINGUISHES ANYTHING A PLAYER IS OFFERED (§1d).** The `Spec` band is gone with the
   scope, so every rune a hero can be offered reads `[Class]` on the Peddler's row, a cache's button and the pouch.
   The band now tells a retired universal (never offered) from everything else. **Keep it, drop it from the
   surfaces, or show something else in its place** — the lineage a rune was written for is kept only as history
   (`written_for`), and the game is forbidden to read it (§1b).
4. **THE EMPTY-OFFER SENTENCE SAYS "CLASS" WHERE IT SAID "AWAKENING" (§1c).** *"…already carry every rune written
   for that class"* — six occurrences in `Runes.empty_offer_reason`'s cases, one door, four sites. The awakening WAS
   the lineage, and a rune is no longer written for one. Player-visible; confirm the word.
5. **ONE PACK BOND CARD STILL PAYS BESIDE LETHAL AIM — AND PAYS NOTHING WITHOUT PACK BOND (§5c).** The tell says
   Pack Bond *"Sits out of every fight while the Rune of the Sharpshooter is equipped"*, and every one of its ten reads
   needs a companion but two, and both are **Mark of the Hunt's**: the hunter's +25% on the marked prey and the 3% of
   his maximum Mana a strike on it restores. Driven, one Quick Shot on the prey: **Pack Bond and Lethal Aim, 15 → 18
   damage and 0 → 3 Mana; Lethal Aim alone, 15 and 0; Pack Bond alone, 18 and 3; no engine, 15 and 0.** Both halves
   sit inside `has_engine("pack")` — GM §1's open shape, a card's payload inside an engine's block — while the card's
   own text says *"Works with or without a companion"* and never names Pack Bond, and it is not an `ENGINE_READ` row
   (it is a boss pick, and the boss offer asks no engine). **So the brief's *"a dead engine in a live slot"* is one card
   short of true, and the same card is dead to a Beastmaster-lineage Hunter who drops Pack Bond.** Move the payload out
   of the block, gate the card on Pack Bond, or let the tell stand as the near-truth it is — the designer's.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`. Run after HB"* | **HELD** | HEAD `b7fc9e8` = `origin/class-merge` before anything moved |
| 2 | *"All 60 ordinary runes are spec-scoped"* | **HELD, AND IT IS 110** | 60 live ordinary runes, every one `spec:` — and **50 retired entries carried a spec scope too**. All 110 moved (§1a); the 12 retired class-scoped and 5 retired universal entries did not |
| 3 | *"a hero who takes a spine or a rule engine can NEVER be offered an ordinary rune — and three of his four heroes are that hero"* | **HELD, DRIVEN ON THE SAVE** | a copy of the designer's `run_save.bin` (v13) at HEAD: the Warrior (the Reaver), the Cleric (Sanctity) and the Hunter (the Medic and the Tracker) have no lineage and **0** eligible ordinary runes; the Mage (the Pyromancer) has **3** (§4) |
| 4 | *"Twelve of the twenty-four engines are spines or rule engines"* | **HELD** | 3 spines (Momentum, Channel, Sanctity) and the 9 `Classes.RULE_ENGINES`; the other 12 are the lineage engines |
| 5 | *"HB found my own premise wrong: nothing that needs only a companion was ever gated on Pack Bond"* | **HELD** | HB §0 premise 10 |
| 6 | *"It also derived 14 cards and 6 runes that need a companion; use that list"* | **HELD, AND USED** | `docs/state.md`'s HB block: *"fourteen cards … and six runes"*. The six are the Long Leash, the Shared Hide, the Answering Pack, the Second Whistle, the Shared Scent and the Bared Fang — `Runes.COMPANION_READ`, unchanged |
| 7 | *"`spec:inquisitor` is the Devout's and `spec:mystic` the Survivalist's — FJ found both were one string from rolling for nobody"* | **HELD** | FJ's report: *"a rune scoped `spec:devout` or `spec:survivalist` would roll for nobody, silently"* |
| 8 | *"`Runes._scope_ok` is the one FJ named"* | **HELD** | FJ: *"`Runes._scope_ok` matches on the spec key"*. It is not the only reader — §1c is the census |
| 9 | *"GV's engine gate — 35 runes"* | **HELD AT HEAD; 36 NOW** | `Runes.ENGINE_READ` held 35 rows. **Layered Aegis became the 36th** (§2a), the one requirement that can shrink between a roll and its answer |
| 10 | *"FM found 10 of 17 entries named something outside the spawn kit"* | **HELD AT FM; 16 OF 17 NOW** | FM: *"SEVENTEEN LIVE ENTRIES CARRY `requires_ability` AND TEN OF THEM NAME SOMETHING OUTSIDE THE SPAWN KIT"*. Re-derived on this tree: 17 live entries carry it, **16 naming a card no class kit holds** (every one is drafted or a boss pick) and **1 naming an engine's enabler** (Layered Aegis → Divine Shield, the Devout's) |
| 11 | *"GS has since moved 29 cards from engines back into the pools"* | **HELD** | `CLAUDE.md`, the charter block: *"GS §1 put the 29 cards that stopped travelling with an engine on their lineages' shelves"* |
| 12 | *"Report whether `requires_ability` is checked at the OFFER or only at the payload"* | **AT THE OFFER — AT EVERY ROLL, NOT AT THE ANSWER** | §2a. A hero who never drafted the card is not offered the rune |
| 13 | *"GP reported this for cards and said plainly whether the merge moved the narrowness"* | **HELD** | GP: *"The merge did not move the narrowness."* §3 says it for runes |
| 14 | *"HA found `main` loads a merged run save without warning and gives heroes only their basic attack"* | **HELD, NOT RE-DRIVEN** | HA's report and `docs/state.md`'s HA rulings; this batch never ran against the live save (§4) |
| 15 | *"HB built it per hit, so an area attack climbs it once per enemy struck"* | **HELD, DRIVEN** | at HEAD, Called Volley on three enemies climbed the meter **+15%**, and Triple Shot's three hits on one **+15%** (§5a) |
| 16 | *"it mirrors Heavy Plating, which counts per incoming attack"* | **HELD FOR AN AREA ATTACK, NOT FOR A MULTI-HIT** | Heavy Plating's climb is booked in `_resolve`'s strike loop, per unblocked STRIKE on the Warden: an enemy's area attack strikes him once, so it climbs once, but an enemy's multi-hit climbs it once per hit. **The ruling's direction does not depend on it** — per cast is what was ruled — and nothing about Heavy Plating moved |
| 17 | *"the reset on a crit already bounds it, so no cap is added"* | **HELD** | no cap written; the reset is unchanged |
| 18 | *"HB found a Beastmaster-lineage hero holding Lethal Aim can still be offered companion cards there"* | **HELD, DRIVEN** | at HEAD, 400 rolls of the Beastmaster's first-tier boss offer with Pack Bond and Lethal Aim drew **716** companion cards (§5b) |
| 19 | *"Boss pools stayed spec-keyed at GP"* | **HELD** | `Classes.SPEC_POOLS`; the offer still reads the lineage's pool |
| 20 | *"§6 already drives three doors"* | **A NUMBERING SLIP, NO EFFECT** | the doors are the brief's §7, which lists all four |
| 21 | *"with Lethal Aim equipped there is no bond to deepen, so it is a dead engine in a live slot"* | **ONE CARD SHORT** | of Pack Bond's ten reads, two need no companion and both are Mark of the Hunt's (+25% on the marked prey, and its Mana) — they pay beside Lethal Aim (ruling 5) |
| 22 | *"Use GX's tell — the same sentence, the same amber, the same surfaces"* | **HELD** | GX §1: the pouch row, the map's rune slot, the hero sheet's state column and the battle log's roll call; `Run.rune_sits_out_note`, amber `Color(0.85, 0.7, 0.45)` |
| 23 | *"HB's other four stand as built"* | **HELD, AND NONE MOVED** | ×2.5 (`SHARPSHOOTER_CRIT_MULT` 0.50); no companion by any route; the refused unequip (`Run.engine_toggle_refusal`); Summon Companion's OFFENSE / BREAK |
| 24 | *"FD found the cache rolls at the drop and answers later"* | **HELD** | FD §1; `Run.rune_choice` is the answer's door |

---

## §1 — SPEC SCOPE BECOMES CLASS SCOPE

### §1a — The mapping, and the 110

Every `"scope": "spec:X"` in `data/runes.json` became `"scope": "class:Y"` through `Classes.SPEC_IDS` — the code key,
never the display name:

| lineage key | display | class | live | retired |
|---|---|---|---|---|
| berserker · warden · swordmaster | Berserker · Warden · Swordmaster | warrior | 5 · 5 · 5 | — |
| pyromancer · cryomancer · arcanist | Pyromancer · Cryomancer · Arcanist | mage | 5 · 5 · 5 | — |
| holy · **inquisitor** · occultist | Holy · **Devout** · Occultist | cleric | 5 · 4 · 5 | — |
| beastmaster · sharpshooter · **mystic** | Beastmaster · Sharpshooter · **Survivalist** | hunter | 6 · 5 · 5 | — |
| | | **total** | **60** | **50** |

**The live pool is 15 Warrior, 15 Mage, 14 Cleric and 16 Hunter runes.** The data edit was a textual replacement of
the scope string and the insertion of `written_for` beside it (§1b), and nothing else: every name, price, payload, desc,
`requires_ability` and `retired` string is byte-identical, which was checked by re-parsing both files and diffing every
field but those two.

**THE RETIRED 50 MOVED WITH THE LIVE 60**, on FE §1's ruling for `RUNE_TAGS` (*one vocabulary does not carry two
rules*): a retired entry is kept so it can be read, and a `spec:` scope nobody resolves any more would be the one
place the old vocabulary survived. It rolls for nobody either way — `eligible_ids` skips a retirement before it asks
the scope.

### §1b — `written_for`: the lineage kept as history, and forbidden to the game

The scope was the only record of which lineage a rune was written for, and **several instruments ask exactly that**
— `test_rune_battle` seats a rune on its own lineage to drive it, `test_runes` counts each lineage's authored set,
and seven suites walk a lineage's runes. So each of the 110 carries it, beside the scope:
`"written_for": "<lineage key>"`, the way a retired lane is kept in `lane`.

**THE GAME NEVER READS IT, AND THAT IS ASSERTED.** A script that read `written_for` would be the spec scope back
under another name. `test_runes` walks every comment-stripped `scripts/*.gd` for the string and requires zero, and
requires exactly 110 entries to carry it (`_written_for_is_history`). `Runes.build` does not copy it onto an instance,
so it never rides a save.

### §1c — Every reader of a rune's scope, before anything changed

The brief's instruction was to report the readers before changing the scope. This is the census, taken on HEAD's tree
by reading every `scope`, `scope_label`, `scope_color`, `SCOPE_INFO`, `scope_band`, `_scope_ok` and `spec:` site in
`scripts/`, and every file that names them:

| reader | what it did with a scope | what HC did |
|---|---|---|
| `Runes._scope_ok` | universal → yes; `class:` → the hero's class; **`spec:` → the hero's lineage** | **the `spec:` branch is deleted**, not kept for a scope nothing carries; anything but the two bands refuses |
| its callers: `eligible_ids`, `locked_by_kit`, `locked_by_engine`, `locked_by_pet` | the roll, and the three empty-offer causes | unchanged — they ask `_scope_ok` |
| `Runes.SCOPE_INFO` / `scope_band` | three bands, `Spec` in purple | **the `Spec` band is deleted**; `scope_band` returns `class` or `universal` |
| `Runes.build` | wrote `scope`, `scope_label` and `scope_color` onto the instance — **which rides the save** | unchanged, and **nothing displays those fields any more** — `Runes.shown_scope` (new) reads the band off the data by id, GS §3's reason one field over: an instance built before HC would go on saying `Spec` |
| `shop_screen.gd` (the Peddler's row), `map_screen.gd` (the pouch row, the rune slot, a cache's button), `party_screen.gd` (the hero sheet) | the instance's `scope_label` / `scope_color` | **every one asks `Runes.shown_scope`** |
| `Run.grant_rune` — **the event verb and the rich sim arm** | preferred `spec:<his lineage>` among eligible runes, else the plain roll | **re-pointed**: read as it stood it matched nothing for every hero and fell through to the plain roll, handing an event's rune to an ENGINE rune as often as the roll draws one. It prefers an ORDINARY rune — the reading a spec rune had |
| `run_sim._pick_rune_candidate` | the sim bot's cache pick preferred `spec:<his lineage>` | **re-pointed** the same way: prefers a candidate that is not an engine rune |
| `run_sim`'s worn-rune report (`worn_kind`) | a `spec` column | reads `Runes.scope_band`: `class`, `universal`, `stick` |
| `Runes.empty_offer_reason` | *"…carry every rune written for that awakening"* | *"…that class"* — six sentences, one door (ruling 4) |
| `Runes._scoped_ids` | an exact scope match | **zero callers at HEAD and now**; untouched |
| `Runes.template_rune` (the generated stat family) | `class:` only | untouched |
| `events.gd`'s `class:` selector | an EVENT's party condition, not a rune's scope | not a reader |
| **the instruments** | about thirty gates and suites read a rune's scope | read when the unmodified battery ran (§7) and re-pointed with their reasons |

**AND THE EVENT VERB IS THE ONE WHOSE CHANGE A PLAYER CAN FEEL.** At HEAD a hero with no lineage got an ENGINE rune
from every event grant (the designer's Warrior: 400 of 400). Now he gets an ordinary rune wherever one is eligible, and
an engine rune only where none is — **the Cleric of no lineage still gets engine runes, because nothing else is
eligible for him** (§4).

### §1d — The band

Every live rune is `class:` and every offered rune therefore reads `[Class]`: **the band distinguishes nothing among
the runes a hero can be offered** (ruling 3). It was not removed — the three surfaces still draw it, through
`shown_scope` — because removing a surface's element is a UI decision the brief did not make.

---

## §2 — THREE GATES NOW DECIDE AN OFFER

### §2a — How the three compose

**At every roll the three are an AND**, inside the one door every rolling site shares (`Runes.eligible_ids`: the
Peddler, the elite cache, the bargain, the event verb): the scope (`_scope_ok`), not retired, not an engine rune he
already holds, **the required card in `kit_names`**, **`offerable`** — the ENGINE half (a row's engine slotted) and the
PET half (a companion row withheld while a dismisser is slotted) — and not owned.

- **`requires_ability` IS CHECKED AT THE OFFER — AT THE ROLL — AND NOT ONLY AT THE PAYLOAD.** `kit_names` is the
  opening kit (the class basic, the class kit less a dismissed pet, **and the enablers of the engines he has
  slotted**) plus everything he has earned, benched cards included. **A hero who never drafted the card is not
  offered the rune.** At the payload the rune is inert besides — its field is read inside the card's own handler, so
  it pays nothing without the card.
- **IT IS NOT RE-ASKED AT THE ANSWER** (`Run.rune_choice` → `_engine_seated`, which re-asks the engine and the pet):
  the pool it reads only grows — **except an engine's enabler, which leaves with the engine**. Of the 17
  requirements, exactly one names an enabler: **Layered Aegis → Divine Shield**, the Devout's. **Driven on both trees**
  (`hc_aegis_probe`): a cache holding Layered Aegis, Fourth Stack and Deep Absorb, rolled with Conviction slotted and
  answered after it was unslotted — **HEAD's answer handed over Layered Aegis alone** (the two Conviction rows held
  back, the requirement not asked, and a rune that then pays nothing — Divine Shield had left the kit with the
  engine); **HC's answer hands over nothing and keeps all three stored**. The ROLL was right on both trees: with
  Conviction unslotted, `eligible_ids` does not hold Layered Aegis. **It is an `ENGINE_READ` row now (Conviction)**, so
  the gate holds at the roll, at the answer (held back, the cache's sentence saying so) and at the seat (it sits out
  with GX's note). **This is the only change to who can be offered a rune beyond the scope itself; its data did not
  move.**
- **IT READS WHAT HE OWNS, NOT WHAT HE CARRIES.** A rune whose card is benched is still offered, and pays once the card
  is carried again — the loadout is the player's own lever (EG), the same reason GV filters rather than repairs.
- **THE ENGINE AND THE PET HALVES BOTH BIND THE BOND ROWS** (the Long Leash, the Shared Scent): they read Pack Bond and
  a companion. **The engine and the requirement both bind six** (the Half Note, the Ambush, the Open Wound, the Open
  Hand, the Grace, Layered Aegis). No rune carries both a requirement and the pet gate.

**Per class, what each gate holds** (the 60 live ordinary runes):

| class | an engine row | a requirement only | the pet gate only | **no gate at all** |
|---|---|---|---|---|
| Warrior (15) | 5 — Standing Wall, Bracing Line *(Heavy Plating)*; Open Vein *(Bloodrage)*; Whetstone, Naked Blade *(the stances)* | 5 — Split Shield, Blood Debt, Butcher's Bill, Open Line, Long Blade | — | **5 — Long Watch, Bared Plate, Last Word, Slaughterhouse, Mirror Guard** |
| Mage (15) | 8 — Ember Leap, Pyre Debt *(Overburn)*; Second Winter *(Permafrost)*; Resonant Core, Half Note, Overtone, Dissonance, Overflow *(Resonance)* | 4 — Ashfall, Chain Fire, Glass Prison, Cold Snap | — | **3 — Long Fuse, Killing Cold, Deep Cold** |
| Cleric (14) | **14** — Deepening Hex, Standing Mark, Shared Ruin, Wide Rite, Open Wound *(Ruin)*; Vigil, Open Hand, Carried Mercy, Grace, Martyr *(Mercy)*; Layered Aegis, Deep Absorb, Fourth Stack, Bare Altar *(Conviction)* | — | — | **0** |
| Hunter (16) | 9 — Keen Focus, Heavy Bolts, Ambush, Shared Mark, Long Draw *(Lethal Aim)*; Long Leash, Shared Scent *(Pack Bond, and a companion)*; Second Barb, Thin Blood *(Trapper)* | 2 — Full Board, Carrion | 4 — Shared Hide, Answering Pack, Second Whistle, Bared Fang | **1 — Long Poison** |

### §2b — A companion or the bond: the runes re-derived at the read site

HB re-derived it for cards; the brief asks the same for runes. **Six runes need a companion, and HB's six are the
six** — re-read at each read site on this tree:

| rune | read site | reads | offered to |
|---|---|---|---|
| **Long Leash** | `_bond_convert` (the split point, 8 → 11) | **the bond** — Loyalty exists only through Pack Bond's `_gain_loyalty` | a Hunter with **Pack Bond slotted and no dismisser** |
| **Shared Scent** | the fallen companion's Loyalty carried to the next call | **the bond** | the same |
| **Shared Hide** | `_shared_hide_mult`, the companion's blow | **a companion** | every Hunter with no dismisser |
| **Answering Pack** | the deepest bond takes the killing blow | **a companion** (the deepest by Loyalty; with no Pack Bond every companion is at zero and one still stands in) | the same |
| **Second Whistle** | the three calls open at 3 Loyalty | **a companion** — the Loyalty it pre-pays is read by the companion's strike step (`_comp_dmg_mult` → `_bond_paid`) with no engine check, so it pays without Pack Bond | the same |
| **Bared Fang** | +30% companion damage, no healing it | **a companion** | the same |

So **the companion readers reach every Hunter but a Lethal Aim holder, and the Loyalty readers stay on Pack Bond**, as
the brief expected. Nothing moved: this is the table HB left, confirmed.

### §2c — What falls through all three while still useless: the six status and stance runes

**This is the population the brief called the real finding if it was not empty. It is six.** Each reads a status or a
stance that no gate asks about:

| rune | written for | reads | what lays it for a hero of the class | at the spec scope it reached |
|---|---|---|---|---|
| **Long Fuse** | the Pyromancer | Burn on an enemy | Flamewave (Overburn's enabler); drafted Ember Debt, Firestorm, Fireball | the Pyromancer's lineage |
| **Killing Cold** | the Cryomancer | an enemy at maximum Chill | Razor Ice (Permafrost's enabler); drafted Glacial Prison, Frostbolt, Blizzard | the Cryomancer's lineage |
| **Deep Cold** | the Cryomancer | the Chilled stacks he applies | the same | the same |
| **Long Poison** | the Survivalist | his own Poison | **with no engine, drafted Explosive Shot alone**; Shrapnel Charge and Hamstring lay Poison only under an engine (GM §1's open shape: laid with the class's six slotted, not with none) | the Survivalist's lineage |
| **Mirror Guard** | the Swordmaster | the Defensive guard | drafted Precision Strike, Feint, Wheeling Cut, and Guard Change — the swap itself (refused on the probe's board only because Formless, cast earlier in the same walk, refuses it) | the Swordmaster's lineage |
| **Slaughterhouse** | the Berserker | an enemy bleeding out, whoever bled it | drafted Rampage, Wildstrikes, Hack and Slash; **an ally's Bleed** — Canis, when a Hunter fields the wolf, and a Hunter's Savage Sweep or Call of the Wild; the Bloodletting bargain (every attack adds 15 Bleed, on both sides) | the Berserker's lineage |

**THE METHOD.** Every card a hero of the class can earn — the class draft pool and every lineage's boss pool, 49 / 53
/ 46 / 57 — was cast once onto a clean enemy, **twice over: with the class's six engines slotted and with none**, and
what it laid was read off the enemy and the caster (`hc_appliers_probe`, isolated copy). The opening kits were cast
the same way for every class with no engine and with each engine: **no class kit lays Burn, Chill, Poison, Bleed or
the Defensive guard** — the three lineage enablers that lay anything are Flamewave (Burn), Razor Ice (Chill) and Hex
of Ruin (Ruin). **The census is a floor**: a card that needs a board it was not given (a low target, a stack to
consume, a companion standing) was refused rather than read — with six engines, 2 / 8 / 6 / 11 refusals (the Hunter's
eleven include every companion card, because Lethal Aim among the six dismisses the pet); with none, 2 / 14 / 8 / 5.

**AND NOTHING ELSE FALLS THROUGH.** The other three ungated runes pay any hero of the class — Long Watch (his Break
damage carries to a second enemy), Last Word (below a quarter health, he acts) — and Bared Plate pays too, which is
§2d's problem rather than this one's.

### §2d — The reverse case: a price the scope change made free

**Bared Plate** (ruling 2) is the one costed rune among the ungated nine, and its price reads a stat that only one
lineage and one engine supply. Driven in a spawn with the real Block roll (not the deterministic fixture, which
zeroes Block for every hero):

| Warrior | Block chance at spawn | live, with Heavy Plating's slice |
|---|---|---|
| no lineage, no engine | 0.000 | 0.000 |
| Berserker's lineage, Bloodrage | 0.000 | 0.000 |
| Swordmaster's lineage, the stances | 0.000 | 0.000 |
| Warden's lineage, Heavy Plating | 0.100 | 0.250 |
| no lineage, Heavy Plating | 0.000 | 0.150 |

**Nothing else was found of this shape.** Every other costed rune a hero can be offered is behind an engine row (GW
§3 already gated those costs with their payouts), a requirement (the price lands on the required card), or the pet
gate (the Bared Fang's unhealable companion is a real price for anyone who fields one).

---

## §3 — WHAT A HERO CAN ACTUALLY BE OFFERED

**Read off `Runes.eligible_ids` for a seated member of each class, with an empty pouch, in two columns** (the method is
GP's for cards): **AT SPAWN** — what the doors can hand him before he has drafted anything (his opening kit, his
slotted engines); and **CEILING** — what they can hand him once he has drafted every card any rune of his class
requires (`requires_ability` satisfied). A lineage only matters where a boss-pool card is required (Blood Debt, on the
Berserker's boss pool). **The lineage for an engine row is the engine's own; with no engine it is shown for every
lineage where it differs.** Isolated copy (`hc_offer_probe`); `check_gv` §3 prints the same table, by name, every
battery, and asserts how the gates compose rather than the counts.

### Warrior — 15 ordinary runes

| engines | at spawn | ceiling |
|---|---|---|
| **none** | **5** — Long Watch, Bared Plate, Last Word, Slaughterhouse, Mirror Guard | **9** — + Split Shield, Butcher's Bill, Open Line, Long Blade *(10 on the Berserker's lineage: + Blood Debt)* |
| Berserker (Bloodrage) | 6 — + Open Vein | 11 |
| Warden (Heavy Plating) | 7 — + Standing Wall, Bracing Line | 11 |
| Swordmaster (the stances) | 7 — + Whetstone, Naked Blade | 11 |
| the Vanguard (Momentum) · the Reaver · the Bastion | 5 each | 9 each |
| **best pairs** | **Warden + Swordmaster 9** | **13 — a three-way tie: Berserker + Warden, Berserker + Swordmaster (both on the Berserker's lineage; 12 on the other), Warden + Swordmaster** |

The Warrior's ceiling at the best pair is 13 of 15: two rows always need the third lineage engine.

### Mage — 15

| engines | at spawn | ceiling |
|---|---|---|
| **none** | **3** — Long Fuse, Killing Cold, Deep Cold | **7** — + Ashfall, Chain Fire, Glass Prison, Cold Snap |
| Pyromancer (Overburn) | 5 — + Ember Leap, Pyre Debt | 9 |
| Cryomancer (Permafrost) | 4 — + Second Winter | 8 |
| Arcanist (Resonance) | 7 — + Resonant Core, Overtone, Dissonance, Overflow | 12 — + Half Note |
| the Invoker (Channel) · the Weaver · the Leech | 3 each | 7 each |
| **best pair** | **Pyromancer + Arcanist 9** | **14** — every Mage rune but Second Winter |

**All three a no-engine Mage can be offered at spawn are §2c runes**, and none of the three pays until he drafts a
Burn or Chill card.

### Cleric — 14

| engines | at spawn | ceiling |
|---|---|---|
| **none** | **0** | **0** |
| Holy (Mercy) | 3 — Vigil, Carried Mercy, Martyr | 5 — + Open Hand, Grace |
| Devout (Conviction) | 4 — Layered Aegis, Deep Absorb, Fourth Stack, Bare Altar | 4 |
| Occultist (Ruin) | 4 — Deepening Hex, Standing Mark, Shared Ruin, Wide Rite | 5 — + Open Wound |
| the Hierophant (Sanctity) · the Oathkeeper · the Arbiter | **0 each** | **0 each** |
| Sanctity + Oathkeeper · Sanctity + Arbiter · Oathkeeper + Arbiter | **0** | **0** |
| **best pair** | **Devout + Occultist 8** | **Holy + Occultist 10** — Deepening Hex, Standing Mark, Shared Ruin, Wide Rite, Open Wound, Vigil, Open Hand, Carried Mercy, Grace, Martyr |

**THE CLERIC IS THE CLASS THE MERGE DID NOT REACH.** Every one of his fourteen reads one of his three lineage engines,
so a Cleric holding any of the other three — or none — is offered nothing, at spawn and at the ceiling alike. **HC did
not move his narrowness; it made it visible.**

### Hunter — 16

| engines | at spawn | ceiling |
|---|---|---|
| **none** | **5** — Shared Hide, Answering Pack, Second Whistle, Bared Fang, Long Poison | **7** — + Full Board, Carrion |
| Beastmaster (Pack Bond) | 7 — + Long Leash, Shared Scent | 9 |
| Sharpshooter (Lethal Aim) | 5 — Keen Focus, Heavy Bolts, Shared Mark, Long Draw, Long Poison (**the four companion runes are withheld**) | 8 — + Ambush, Full Board, Carrion |
| Survivalist (Trapper) | 7 — + Second Barb, Thin Blood | 9 |
| the Tracker · the Skirmisher · the Medic | 5 each | 7 each |
| Pack Bond + Lethal Aim | 5 — the Sharpshooter's set: **every Pack Bond and companion rune withheld** | 8 |
| **best pair** | **Beastmaster + Survivalist 9** | **11** — Long Leash, Shared Hide, Answering Pack, Second Whistle, Shared Scent, Bared Fang, Long Poison, Second Barb, Full Board, Carrion, Thin Blood |

### §3a — Against the spec scope

At HEAD a hero was offered his lineage's runes and nothing else; a hero with no lineage was offered none. **What the
merge moved**, per class, for the hero HA found stranded — a spine, a rule engine or nothing:

| class | HEAD, no lineage | HC, no engine (spawn / ceiling) |
|---|---|---|
| Warrior | 0 | **5 / 9** |
| Mage | 0 | **3 / 7** |
| Cleric | 0 | **0 / 0** |
| Hunter | 0 | **5 / 7** |

**The five a no-engine Warrior is offered, and the five a no-engine Hunter is, are the five the design pass has to
count from; the Mage's three are all conditional (§2c); the Cleric has none.**

---

## §4 — THE DESIGNER'S SAVE

**Backed up and verified by hash before anything ran**: the four files (`profile.json`, `relics.json`,
`run_save.bin`, `settings.cfg`) copied to `../save-backups/HC-20260921-093502` with `MD5SUMS.txt`, and the copies
checked byte-identical. **The drive ran in an isolated copy** whose `project.godot` was renamed first (*"Dawn of Decay
HC save probe"*), so its `user://` is its own, seeded from the backup. The save loads on this branch (v13, zone 1 slot
2, an elite pending, 203 gold); `main` was not touched. **The live saves were read again at the end and match
`MD5SUMS.txt`.**

Each hero's pool read off `eligible_ids`, and each door rolled 400 times (read and thrown away; nothing was saved):

| hero | lineage · engines | HEAD: ordinary runes the doors can hand him | **HC** |
|---|---|---|---|
| **Warrior** | none · the Reaver | **0** | **5** — Long Watch, Bared Plate, Last Word, Slaughterhouse, Mirror Guard |
| **Mage** | Pyromancer · Overburn | **3** — Long Fuse, Ember Leap, Pyre Debt | **5** — + Killing Cold, Deep Cold |
| **Cleric** | none · Sanctity | **0** | **0** |
| **Hunter** | none · the Medic, the Tracker | **0** | **5** — Shared Hide, Answering Pack, Second Whistle, Bared Fang, Long Poison |

**Of the fifteen, four cannot pay on this party as it stands**: Mirror Guard (the Warrior carries only Execute
beyond his kit — no Defensive guard), Killing Cold and Deep Cold (the Mage carries no Chill) and Long Poison (the Hunter
lays no Poison). **Slaughterhouse pays only through the Hunter's wolf** (Canis builds Bleed) or a Bleed card drafted
later, and **Bared Plate costs this Warrior nothing** (ruling 2). The other nine pay as they stand.

**The event verb, 400 grants a hero**: at HEAD the Warrior, the Cleric and the Hunter got engine runes only; now the
Warrior and the Hunter get ordinary runes only (the five each, spread evenly), the Mage his five, and **the Cleric
engine runes only**, because nothing else is eligible. **The Cleric's queued cache is three engine runes** (the
Occultist's, the Holy's, the Oathkeeper's) on both trees, and the overlay offers them unchanged.

---

## §5 — THE THREE RULINGS, BUILT AND DRIVEN

### §5a — The pity meter counts per cast

**`battle._note_pity(attacker, is_crit)` is the meter's one writer, and it is called ONCE, after the strike loop.** The
loop records, below every source of `is_crit`, whether a counted blow of the cast landed (`_pity_counts`: he holds
Lethal Aim, the blow deals damage, and no absolute parry zeroed it — BR §1's *landed*, unchanged) and whether any
critted. After the loop: a crit anywhere in the cast resets the meter; a cast that landed without one climbs it one
step. **Every strike of a cast rolls on the meter the cast opened with**, so the climb cannot feed its own cast. No cap
was written. Driven (crits forced off, then on), HEAD against HC:

| cast | struck | HEAD, no crit | **HC, no crit** | a crit (both trees) |
|---|---|---|---|---|
| Called Volley (area) | 3 enemies | +0% → **+15%** | +0% → **+5%** | +10% → +0% |
| Triple Shot (multi-hit) | 3 hits on 1 | +0% → **+15%** | +0% → **+5%** | +10% → +0% |
| Quick Shot | 1 | +0% → +5% | +0% → +5% | +10% → +0% |

**The chip and the words moved with it**: the Lethal Aim chip, the Sharpshooter's `passive_desc` (*"Every attack that
lands without a critical"*), the glossary's crit entry and `master.html` say *attack*, never *hit*.

### §5b — The zone boss's first-tier offer is the fourth door

`Run.roll_spec_ability_offer` asks **`Classes.pet_withholds`** — the PET half of `Classes.offerable`, split out as its
own function so both ask one answer — and **not the engine half**: asking the whole of `offerable` there would move
every engine's boss offer, which nobody ruled. **A triple rolled before the pet was dismissed is filtered at its
answer** (`Run.ability_choice` → `_pet_seated`), never repaired away — GV's rule for a state the player can undo — and
the boss overlay says what it holds back with the empty-offer sentence's own clause (*"The offer holds 3 more that need
a companion, which the Rune of the Sharpshooter dismisses."* and, when nothing is live, *"Unequip it and they
return."* — both rendered on the map's pick overlay, `hc_bossov_probe`). Driven, 400 rolls an arm, a
Beastmaster-lineage Hunter:

| engines | HEAD: companion cards drawn | **HC** | HC drew |
|---|---|---|---|
| Pack Bond | 719 | **716** | all five: Mark of the Hunt 248, Spirit Bond 232, Call of the Wild 236, Bestial Wrath 243, Primal Surge 241 |
| Pack Bond + Lethal Aim | 716 | **0** | Mark of the Hunt 400, Call of the Wild 400 — the two that need no companion |
| Lethal Aim + Pack Bond | 713 | **0** | the same |

**The answer, driven**: a triple stored with the pet present (*Bestial Wrath, Spirit Bond, Primal Surge*) answered with
Lethal Aim slotted gave **nothing live and all three held back, stored unchanged**; unslotting Lethal Aim gave all three
back. **On the road (§8), arm B's Pack Bond + Lethal Aim Hunter was offered no companion card at any zone boss and
earned none; HEAD's earned three** (Spirit Bond, Bestial Wrath, Primal Surge).

### §5c — Pack Bond beside Lethal Aim sits out, and says so

**`Classes.PET_ENGINES`** names the engines that need the pet (`["pack"]`), **`Classes.engine_needs_pet`** answers it,
and **`Runes.needs_companion`** — a companion row, or an engine rune whose engine needs the pet — is what `sits_out`
asks. Pack Bond is **still offered, held and slotted** beside Lethal Aim (ruled legal: `offerable` is unchanged, and
the Rune of the Beastmaster is offered to a Lethal Aim holder). **It is not a `COMPANION_READ` row**, which is the
offer's table. **The sentence is GX's, word for word** — `Run.rune_sits_out_note` with the rune's nouns: *"Sits out of
every fight while the Rune of the Sharpshooter is equipped, which dismisses the companion it needs. Still worn: the
slot stays filled. Unequipping the rune frees the slot."*

**EVERY SURFACE IT REACHES — GX's FOUR, DRIVEN ON THE REAL SCREENS:**

| surface | what it shows |
|---|---|
| **the pouch's engine row** (the map's rune pouch) | the row turns amber and carries the sentence |
| **the map card's engine line** | *"engines: ○ Beastmaster + Sharpshooter"*, amber `(0.85, 0.7, 0.45)`, the `○` marking the engine that sits out; **the sentence is on the card's hover**, after *"Open Beastmaster's talents and full sheet."* — the line itself ignores the mouse, so the card's button carries it |
| **the hero sheet's state column** | *"sits out"*, the sentence as its tooltip |
| **the battle log's roll call** | *"Beastmaster: Rune of the Beastmaster — Sits out of every fight while the Rune of the Sharpshooter is equipped,"* — the note's first two lines, GX's rule |

**Order does not matter** (`[pack, lethal_aim]` and `[lethal_aim, pack]` both sit out) and **it is predicated on the
slots**: Pack Bond with Lethal Aim held but unslotted, or alone, does not sit out. **`check_hc` §6 drives all four
surfaces both ways every battery** — marked, amber and saying it with Lethal Aim slotted, and none of it without. **The offer surfaces get nothing**,
GX's ruling — an engine rune that sits out is offered because the pairing is legal.

**THE ONE CARD IT DOES NOT SILENCE (ruling 5).** All ten `has_engine("pack")` sites were read: the Canis prey bonus,
Savage Presence, Aguila's party crit, the boons (`_bond_reach`), Loyalty (`_gain_loyalty`), the ghost strikes and the
two swap tooltips all need a companion or a bond; **Mark of the Hunt's two halves do not** — 15 → 18 damage and 0 → 3
Mana on the prey with both engines slotted, 15 and 0 with Lethal Aim alone (`hc_mark_probe`). Recorded in
`docs/state.md`, in `CLAUDE.md`'s HB block beside the rule, and in `master.html` beside the tell.

**AND THE OTHER FOUR HB RULINGS STAND AS BUILT, UNTOUCHED**: ×2.5; no companion by any route; unequipping Lethal Aim
refused while every slot is full; Summon Companion's OFFENSE / BREAK.

---

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **No rune was authored, retuned or retired.** Every name, price, payload and desc in `data/runes.json` is
  byte-identical; the scope strings moved and `written_for` was added. **Layered Aegis became an `ENGINE_READ` row**,
  which changes who is OFFERED it, not what it does.
- **No companion rune and no new companion** — they are Hunter runes, designed with every other rune in the pass that
  follows.
- **The Mage pool is not split.**
- **No engine, kit, card, node or pool changed.** The pity meter's counting and the boss offer's filter are the
  rulings' own changes; Summon Companion, Lethal Aim, the boss pools and every card's data are as HB left them.
- **The six status runes were not gated, Bared Plate was not re-priced, the band was not removed, and Mark of the
  Hunt's feed was not moved** — each is a ruling above.
- **HD and HE — the twenty holes and the other 75 — are after this.**
- **`main` is untouched.**

## §7 — THE UNMODIFIED GATES AGAINST THE NEW TREE, AND EVERY REPAIR

**HEAD's battery ran first, unmodified, against HC's code** (an isolated copy of the tree as it stood when the game
code was done — before `written_for` and the documents), 121 of 121 launched, no `Parse Error` in any log. **Nothing
was repaired until the whole run was read.** Every red, and every count that left its line, is below with its cause
read off the FAIL text or, for a count that moved with no red, off an `ok()` trace — each assertion helper
instrumented in two out-of-repo copies, HEAD's tree and this one, and the multisets of assertion messages diffed.
`check_de` read **501 checks / 26 failures / 8 notices**: 20 targets off their line.

| target | HEAD's gate on HC's code | what it caught | what was done |
|---|---|---|---|
| `test_runes` | 4,156 / **36**, fell from 5,625 | every lineage's authored set read off `spec:` — *"has 0 RETIRED spec runes"*, *"0 splash runes"*, *"0 lane runes charge for their upside"* — and `_eligibility`'s spec walk | **re-pointed** to the class scope with `written_for` for the lineage; `_eligibility` rebuilt (no entry `spec:`; the class known; `written_for` a lineage of its class; the rune rolls for its own lineage, every other lineage of the class and a no-lineage hero, and leaks into no other class); `_rich_grant` asks for an ordinary rune of the class; `_written_for_is_history` new — **6,697**, +1,072 by trace (row note) |
| `test_rune_battle` | 97 / **48** | *"pyromancer: nothing eligible to equip"* and every clause after it: `_spec_scoped` read the scope for the lineage | **re-pointed**: `_spec_scoped` and `_equip_all` read `written_for` — 97 |
| `test_batch_as` · `at` · `av` · `aw` · `ay` · `az` · `ba` | 296/2 · 370/6 · 269/3 · 212/4 · 449/1 · 494/3 · 1,439/2 | a lineage's runes counted off `spec:` (*"nine Cryomancer spec runes (got 0)"*); and *"class-wide"* walks that read `class:` alone now walking every lineage's runes (*"three Mage class-wide runes (got 30)"*, the Sharpshooter's own runes *"writing his counters"*) | **re-pointed**: the lineage off `written_for`; *class-wide* is the class entries with NO `written_for`, which is what the word meant when it was written — **every one back to its exact row** (267 · 353 · 269 · 212 · 405 · 450 · 772) |
| `test_batch_ar` · `ax` · `bs` | green: 536 (row 510) · 259 (row 218) · 246 | nothing red — **a population widened in silence**: `ar`'s and `bs`'s *"every Pyromancer and Mage rune"* walk and `ax`'s *"the three Cleric class-wide runes"* read `class:` and took in every lineage's runes | **re-pointed to the population they were written about** (the Pyromancer's and the class-wide ones; the class-wide three), off `written_for` — 510 · 218 · 246. `ax`'s Hollow Chalice report line keyed back to its lineage |
| `check_es` | 57 / **2** | §2: 64 lineage–rune pairs *"in scope for a spec, are not offered, and say nothing about why"* — another lineage's engine rows, now in scope for the class; §5: *"0 retired splashes"* | **re-pointed**: a rune withheld by a gate that names its reason (`ENGINE_READ`'s `why`, `COMPANION_READ`) is not silence, and anything else still lands; the bands are two and a scope that is not `universal` or a real class is bad; §5 reads the lineage off `written_for` — 57 |
| `check_ez` | 114 / **5** | *"SCOPE IS SPEC ONLY for all sixty"*, the per-spec authored counts | **re-pointed**: SCOPE IS CLASS ONLY, the class of the lineage each was written for; the counts off `written_for` — 114 |
| `check_fk` | 64 / **5** | *"the live pool spans 4 specs"*, *"nothing is scoped `spec:inquisitor`"*, §5's reach *"(class:warrior cannot earn it)"* | **re-pointed**: FJ's two code keys are asserted in `written_for`, and a display name there reds; the scope is the lineage's class; §5 asks whether any hero of the CLASS can hold the card — the kit, the one pool, every lineage's boss pool and enablers — 64 |
| `check_fn` | 48 / **5**, fell from 80 | *"the eight no longer sit on the four specs this gate drives"*, and §4 seated nothing | **re-pointed** to `written_for`, **+1**: each of the eight is scoped to its lineage's class — 81 |
| `check_fo` | 88 / **2** | the Wide Watch's and the Shared Mark's `spec:sharpshooter` | **re-pointed**: `class:hunter`, written for the Sharpshooter — 88 |
| `check_fm` | 81 / **1** | *"the empty column gives no reason"*: its needle was *"that awakening"*, the one case a drained party met at the lineage scope | **re-pointed**: the column must print the door's own reason for every hero, one of its causes; **+1**, *"that awakening"* gone — 82 |
| `check_fe` | 78 / **1** | *"the ability OVERLAY no longer renders through `ability_choice`"* — HC §5 holds the list in a local | **re-pointed and split, +1**: the list comes from `ability_choice`, and the buttons are drawn from that list — 79 |
| `check_ed` | 18 / **1** | `check_fe`'s pin on the old loop line | **`pin-manifest.json` re-derived** — the two new `check_fe` pins resolve in code, the old one is gone; `check_hc`'s and `test_runes`' directory pins join the existing `missing-file` holders; `check_fh`'s one `unresolved` pin is HEAD's too — 18 |
| `check_gt` | 3,136 / **6**, **5 throws**, fell from 3,160 | §1: the Rune of the Beastmaster's rule *"not drawn whole"* beside the Rune of the Sharpshooter — its row carries the sits-out sentence now; §2: *"a seat has no ordinary rune"*, and five throws building a rune from `""` | **re-pointed**: an engine that sits out draws GX's sentence whole; **+1**, exactly four rows do (the pairing's pair and the Hunter's six, in both pouches); §2 takes the seat's CLASS's longest rune — 3,161 |
| `check_gv` | 784 / **212**, **1,207 throws** | `_lineage` read the scope, so every board seated `class:x` as a lineage — 60 *"not scoped to a lineage"*, every row *"pays nothing even with its engine"*, every other rune *"moved nothing"* | **re-pointed**: `_lineage` reads `written_for`; Layered Aegis a ROW, and its drive casts Divine Shield off the bar only (below); §2b INVERTED — a second engine opens its rows; §2f's sentence may name the OTHER lineage engines; §3 rewritten per class; §4 counts a row of any lineage — **911**, +34 by trace |
| `check_gx` | 1,155 / **7** | *"36 gated runes — GV's table holds 35"* and the four arms counting against 35 | **re-pointed**: 36 and 24, and the literals are the table's size; §6 dresses the Cleric's seat, since the Warrior's reached an Occultist rune only through the spec scope — 1,155, +25 by trace |
| `check_da` | 43, green on HC's code | — then **43 / 1** once `check_fk` was re-pointed: *"check_fk.gd no longer carries the old walk"* | **the exemption deleted, not reworded** — `check_fk` reads neither shelf accessor now (EH's reason, at GP) — 42 |
| `check_et` · `check_ea` | green | a `spec:` branch in `_in_scope` and in a *wearable* test that nothing can reach | **the dead branch deleted** (`_scope_ok`'s two cases) — 27 · 83 |
| `check_cm_live` · `check_gj` | the sanctioned reds | — | unchanged counts; `check_gj` reads *"the card says +174 gold and the purse moved 194"* — still the Bell's 20 |

**AND ONE GV READING WAS AN ARTEFACT OF ITS DRIVE.** `check_gv` §1 sorted Layered Aegis as a CARD rune because it paid
with Conviction merely owned — and it did, because `_card` falls back to `Classes.pool_ability` when the hero does not
hold a card, so the drive cast Divine Shield off the definition table on a hero whose bar could not hold it. With the
cast taken off the bar, Layered Aegis moves nothing without Conviction, which is what the game does.

**NEW GATE `check_hc`**, seven sections, 72 checks, every negative with its positive: §1 the scope's doors; §2 Layered
Aegis at a cache's answer; §3 the event verb; §4 the pity meter per cast; §5 the zone boss's first tier; §6 Pack Bond
beside Lethal Aim on the four surfaces; §7 the player's files. It joined `run_battery.sh`'s GATES, which moved
`check_parse` to 196 (its population is that list) and adds four assertions to `check_de`. **`check_gw` §2's shape
count stays at 90** — the gate sets no rune, engine or talent field on a unit — and `check_da`, `check_dw`, `check_ea`,
`check_ek` and `check_ff`, which read gate source, were run with it in place.

**THE CONTROLS.** Every repair and every new arm was broken on purpose in an isolated copy of the finished tree — one
defect per copy, the gate re-run, **the FAIL text read and not the count**:

| the defect injected | gates run | FAIL lines | the first FAIL line, verbatim |
|---|---|---|---|
| c01 — Bared Plate's scope put back to `spec:warden` in the data | `test_runes` · `check_ez` · `check_fk` · `check_es` · `check_gv` | 2 · 1 · 1 · 2 · 2 | *"bared_plate: carries the scope 'spec:warden' — HC §1 re-scoped every spec rune to its class, and `_scope_ok` rolls a spec rune for nobody"* |
| c02 — `_scope_ok`'s spec branch restored | `check_hc` · `test_runes` | 1 · 0 | *"§1: `_scope_ok` passes a `spec:` entry for its own lineage — the spec branch is back"* (the data holds no spec scope, so `test_runes` is c01's to catch) |
| c03 — `Runes.shown_scope` reads `written_for` | `test_runes` | 1 | *"the game reads written_for in ["runes.gd"] — the spec scope is back"* |
| c04 — Layered Aegis's row deleted from `Runes.ENGINE_READ` | `check_hc` · `check_gx` · `check_gv` | 4 · 2 · 4 | *"§2: answered with Conviction out the cache hands over ["Layered Aegis"]"*; *"§1: 35 gated runes — the table holds 36"*; *"§0: `Runes.ENGINE_READ` holds 35 rows against the 36 ruled"* |
| c05 — the pity meter moved per strike again | `check_hc` | 4 | *"§4: Called Volley (3 struck, 1 hits) climbed the meter to +15% — one cast is ONE step, +5%"*, and Triple Shot's; **Quick Shot's arm stayed green**, the positive |
| c06 — the boss roll's pet filter removed | `check_hc` | 2 | *"§5: with ["pack", "lethal_aim"] slotted the first tier rolled 364 companion cards in 600 draws"* |
| c07 — the boss answer's pet filter removed | `check_hc` | 1 | *"§5: with Lethal Aim slotted the answer hands over ["Bestial Wrath", "Spirit Bond", "Primal Surge"] and holds back []"* |
| c08 — `needs_companion` stops reading the engine | `check_hc` · `check_gt` | 8 · 1 | *"§6: engines [["pack", true], ["lethal_aim", true]] — the Rune of the Beastmaster does not sit out"*; *"§1: 0 engine rows drew the sits-out sentence — the Pack Bond pairing appears in 4"* |
| c09 — the pouch's engine row loses the tell | `check_hc` · `check_gt` | 1 · 4 | *"§6 (Lethal Aim in): the pouch row reads '✦ Rune of the Beastmaster — Pack Bond — the active companion grants its boon…'"* |
| c10 — the event verb's preference removed | `check_hc` | 1 | *"§3: a Warrior holding no engine was granted 29 engine runes and 31 ordinary of 60"* |
| c11 — `shown_scope` reads the instance | `check_hc` | 1 | *"§1: a rune cached before HC shows the band its own fields carry (Spec) — the door read the instance"* |
| c12 — *that awakening* put back in all six sentences | `check_fm` | 1 | *"§2a: the empty column still says "that awakening""* |
| c13 — the boss overlay draws off the member | `check_fe` | 1 | *"§2: the ability OVERLAY no longer draws its buttons from the list `ability_choice` handed over"* |
| c14 — `offerable` drops the pet half | `check_gv` | 5 | *"§3: a hunter holding pack and lethal_aim is offered 14, not the 8 its two engines open — the gates are not an AND"* |
| c15 — `offerable` reads only the FIRST slotted engine | `check_gv` | 13 | *"§2b: a Holy Cleric holding the Old Gods second is rolled 0 of the 4 Old Gods rows that need no card"* |
| c16 — `written_for` stripped from all 110 | seventeen targets | 37 · 48 · 2 · 6 · 3 · 4 · 1 · 3 · 2 · 6 · 2 · 5 · 4 · 1 | `test_runes` *"written_for is on 0 entries"*, `test_rune_battle` *"pyromancer: nothing eligible to equip"*, and each of `as`, `at`, `av`, `aw`, `ay`, `az`, `ba`, `check_fn`, `fo`, `ez`, `fk`, `es` on its own lineage arm. **`ar`, `ax` and `bs` stay green** — their walks fall back to *every class entry* and widen (536, 259) — so for those three the ROW is the control: `check_de` reads the rise |
| c17 — the Comet's scope put back to `spec:arcanist` | `check_et` · `test_runes` | 0 · 1 | `test_runes`: *"comet: carries the scope 'spec:arcanist'"*. **`check_et` stays green**: its `spec:` branch was dead, and deleting it removed a reading, not a guard |
| c18 — `check_fk` reads both shelf accessors again | `check_da` | 2 | *"check_fk.gd hand-rolls the ability corpus — `Classes.ability_corpus()` is the walk (BATCH DA §3)"* |

**AND THE HEAD ARM.** The finished gates and suites were run against HEAD's code (an isolated rebuild of `b7fc9e8` with
them copied in): **every gate that asserts a scope reds for HC's reason** — `check_ez` 5, `check_fk` 5, `check_fn` 6,
`check_fo` 2, `check_es` a throw on the third band, `check_gx` 2 (35 rows), `check_gv` 186 and 1,207 throws,
`check_gt` 3 and 5 throws, `check_fm` 2, `check_fe` 2, `test_runes` 192, `test_rune_battle` 48, and `as`, `at`, `av`,
`aw`, `ay`, `ba`, `bs` on their lineage arms. **`test_batch_ax` (218), `az` (450) and `check_et` (27) stay green on
HEAD's code, and that is their repair being faithful**: each now asks for the population it was written about —
the class-wide entries — and HEAD's data holds exactly that population. `test_batch_ar` reads 495 there, fifteen
under its row: the Pyromancer's runes carry no `written_for` on HEAD's data.

## §8 — VERIFICATION

### §8a — The offers, driven: a full road per arm, all four doors, by name

**GP's and GV's method, on `check_gv` §4's road**: a whole seeded run (`ROAD_SEED` 20260921, rung 2, enemies off so
every fight is won) walked through the real screens, one party of the four classes, three arms — **every hero holding
NO engine** (anything a cache or the Peddler hands over is unslotted at every step, `check_gv` §4's shape), **the best
pairs** (§3), and **pairs that include Pack Bond beside Lethal Aim** — each offer read at the door the player reads it
at: **the Peddler's own offers; an elite cache and a bargain, each answered through the map's overlay A NODE LATER**,
told apart by the victory card's two sentences (the bargain is claimed before the elite spoils, so a hero handed both
holds the bargain's triple first; 0 triples unattributed on every arm); **and the zone boss's first-tier offer**, as
stored and as answered. `hc_road2_probe`, isolated copies of this tree and of HEAD's, the same seed. No `Parse Error`
and no `SCRIPT ERROR` in either log, and no stall: every arm reached the end boss's slot (z3 s17).

**ORDINARY RUNES OFFERED, DISTINCT, OVER THE WHOLE RUN:**

| arm | hero · engines | HEAD | **HC** |
|---|---|---|---|
| **no engine** | Warrior | **0** | **4** — Bared Plate, Long Blade, Mirror Guard, Open Line |
| | Mage | **0** | **4** — Deep Cold, Glass Prison, Killing Cold, Long Fuse |
| | Cleric | **0** | **0** |
| | Hunter | **0** | **5** — Answering Pack, Bared Fang, Long Poison, Second Whistle, Shared Hide |
| **best pairs** | Warrior · Berserker + Warden | 2 — Last Word, Slaughterhouse | 3 — Last Word, Open Vein, Standing Wall |
| | Mage · Pyromancer + Arcanist | 4 — Chain Fire, Ember Leap, Long Fuse, Pyre Debt | 6 — Dissonance, Ember Leap, Long Fuse, Overflow, Pyre Debt, Resonant Core |
| | Cleric · Holy + Occultist | 4 — Carried Mercy, Martyr, Open Hand, Vigil | 4 — Deepening Hex, Martyr, Standing Mark, Vigil |
| | Hunter · Beastmaster + Survivalist | 6 — Answering Pack, Bared Fang, Long Leash, Second Whistle, Shared Hide, Shared Scent | 6 — Answering Pack, Bared Fang, Carrion, Long Leash, Shared Hide, Shared Scent |
| **Pack Bond beside Lethal Aim** | Warrior · Warden + Swordmaster | 4 — Bared Plate, Bracing Line, Long Watch, Standing Wall | 5 — Bared Plate, Last Word, Mirror Guard, Slaughterhouse, Whetstone |
| | Mage · Cryomancer + Arcanist | 2 — Killing Cold, Second Winter | 7 — Deep Cold, Killing Cold, Long Fuse, Overflow, Overtone, Resonant Core, Second Winter |
| | Cleric · Devout + Occultist | 3 — Deep Absorb, Fourth Stack, Layered Aegis | 5 — Deep Absorb, Deepening Hex, Layered Aegis, Standing Mark, Wide Rite |
| | Hunter · **Beastmaster + Sharpshooter** | **0** | 6 — Full Board, Heavy Bolts, Keen Focus, Long Draw, Long Poison, Shared Mark — **no companion rune** |

A road is one seeded draw, so a count is what that road happened to offer and not the pool (§3 is the pool). **What it
shows is the shape**: at HEAD a hero with no engine was handed engine runes and nothing else at every door, and a
Beastmaster-lineage Hunter beside Lethal Aim was offered nothing, because every Beastmaster rune needs a companion; at
HC every class but the Cleric draws ordinary runes with no engine, the second engine's runes arrive with it (the
Warrior's Open Vein and Standing Wall, the Mage's Resonance set, the Cleric's Ruin set), and the Lethal Aim holder's
offers are his class's, less every rune that needs a companion.

**EACH DOOR, REACHED** (HC; the full counts are in the probe's log):

| door | no engine | best pairs | Pack Bond + Lethal Aim |
|---|---|---|---|
| **the Peddler** | all four | all four | all four |
| **an elite cache, answered a node later** | all four | Warrior, Mage, Cleric, Hunter | Warrior, Mage, Cleric |
| **a bargain, answered a node later** | Mage, Cleric, Hunter | Mage, Hunter | Warrior, Cleric, Hunter |
| **the zone boss's first tier** | all four, three bosses each | all four | all four |

**AT THE FOURTH DOOR** the Pack Bond + Lethal Aim Hunter was stored and answered *[Call of the Wild, Mark of the
Hunt]*, *[Mark of the Hunt]* and — his lineage's pool spent of every card he can use — the class pool's *[Trophy
Shot, Bola, Camouflage]*, and **earned no companion card**; on HEAD's tree the same seat was stored all three boss
offers with Spirit Bond, Primal Surge or Bestial Wrath in them, and earned all three. **The roll call said the Rune of
the Beastmaster sits out** in that arm's fights (*"Beastmaster: Rune of the Beastmaster — Sits out of every fight
while the Rune of the Sharpshooter is equipped,"*), and in no other arm.

**OFFERED WHILE NOTHING HE CARRIED COULD PAY THEM** (§2c, read at each offer against his loadout, his engines and, for
a bleedout, the party's wolf): no engine — the Mage's Long Fuse, the Hunter's Long Poison; best pairs — none;
Pack Bond + Lethal Aim — **the Warrior's Mirror Guard four times and Slaughterhouse once** (no swap card, and the
party's Hunter fields no wolf), the Mage's Long Fuse, the Hunter's Long Poison. **HEAD's roads show none: at the spec scope
they reached only the lineage they were written for, which on these roads carried what they read** — not a
guarantee (a Swordmaster-lineage hero with no swap card had the same dead Mirror Guard at HEAD), but the population
was one lineage wide.

### §8b — The battery, and every other reading

**EVERY FIGURE BELOW IS READ OFF A LOG OR A HASH, AND THE TREE WAS FROZEN THROUGH THE RUN.**

| | |
|---|---|
| **the saves** | backed up as the batch's first action (`../save-backups/HC-20260921-093502`) and md5-verified against the live files; **byte-identical after the recon, after every probe and control, and after the acceptance run**. Every drive, trace and control ran in a renamed isolated copy; the acceptance run ran in the tree the way a gate does, every profile pointed at a scratch file |
| **HEAD's unmodified gates, against the new code** | 121 of 121 launched; `check_de` 501 checks / 26 failures / 8 notices, **every one read** (§7) before anything was repaired |
| **the acceptance run, with the rows** | **122 of 122 launched (the 121 and `check_hc`); `check_de` 505 checks / 0 failures / 0 notices; the two sanctioned reds and no other** — `check_cm_live` 13 / 4 and `check_gj` 70 / 1, *"the card says +174 gold and the purse moved 194"*, both FAIL texts the same as on HEAD's gates; every count on its row, the known drifter `test_batch_an` at 6,052 inside its 6,049–6,066; the run harness 22 / 382 / 8 with throws 0; **the tree hashed at the start and the end — 428 paths (the tracked files, `check_hc.gd` and this report), none moved** |
| **the parse floor** | **`Parse Error` on 0 lines and `SCRIPT ERROR` on 0 lines in all 122 logs**, read off the logs and not off a tally; `check_parse` 196 checks / 0 failures |
| **the rows, written before the run** | every movement predicted off a standalone run and attributed by an `ok()` trace where it moved: `test_runes` 5,625 → 6,697, `check_gv` 877 → 911, `check_gx` 1,130 → 1,155, `check_gt` 3,160 → 3,161, `check_fe` 78 → 79, `check_fm` 81 → 82, `check_fn` 80 → 81, `check_da` 43 → 42, `check_parse` 195 → 196, and `check_hc` 72, new. **All met exactly** |
| **the needle instrument** | `build_pin_manifest.py --check` **current, 1,501 pins**; against HEAD's manifest the residency of **every** pin is unchanged — `check_fe`'s two new pins resolve in code where its one old one did, and the new directory pins (`check_hc`, `test_runes`) join the existing `missing-file` holders; `check_fh`'s one `unresolved` is HEAD's too |
| **the documents' needles** | every string literal of 4+ characters in the 122 targets (14,805) looked up in the seven edited documents and data files, raw and whitespace-flattened, HEAD's against the finished files: **14 LOST and 43 GAINED, and not one is a pin on that document** — the losses are data scopes (`spec:…`) and words the rewritten sections no longer say, and every negative assertion among the gains (*that awakening*, `spec:`, `written_for`) reads a screen, the data or `scripts/`, never the document |
| **the two ceilings** | `check_fg` §1: the changelog **156,606 B = 156.61 KB, 243,394 B under the bar**; §2: `CLAUDE.md` **364,607 B = 356.06 KiB, 53.94 KiB under its 410 KiB ceiling**. Neither warns |
| **after the run** | the report and `docs/state.md`'s verification line were written after the run, as every batch's are; `check_es` — the one gate that opens `state.md` — was re-run standalone against the finished file: **57 / 0** |

---

## §9 — FOUND AND NOT FIXED

- **THE EVENT VERB'S EMPTY LINE IS FALSE MORE OFTEN NOW.** `events.gd` prints *"RUNE: nothing answers — every hero
  already carries every rune written for them."* when no hero can take a rune — its own sentence, not the door the
  other four sites share. It was already false whenever a pool was empty for want of a card or an engine; at the class
  scope that is the ordinary case. Not reworded: player-facing words are the designer's.
- **A CARD DRAFT'S ANSWER RE-ASKS NEITHER THE ENGINE NOR THE PET** (`take_draft_ability` refuses only an owned card), so
  a card rolled while its engine was slotted can be taken after it was unslotted, and then sits out (GT §3). The rune
  cache and the boss offer filter at the answer; the draft does not. Read at the source, not driven.
- **`requires_ability` READS THE POOL, NOT THE LOADOUT**: a rune whose card is benched is still offered, and pays once the
  card is carried again. Recorded as EG's lever working, not as a defect.
- **HEAVY PLATING CLIMBS PER STRIKE** — an enemy's multi-hit climbs the Warden once a blow — so the per-cast ruling's
  stated model holds for an area attack and not for a multi-hit. The ruling did not depend on it.
- **`check_gv`'s `_card` FALLS BACK TO THE DEFINITION TABLE** when the hero does not hold a card. Repaired for the one
  drive it misled (Layered Aegis); every other drive seats the card it casts, so it reaches nothing else today.
- **THE CLERIC'S MAP CARD DRAWS NO ENGINE LINE WHILE HE OWES A PICK** — in the designer's save his card showed the pick in
  its place, on HEAD's tree and on this one alike. Not HC's; noted because §4 read the map.

---

## §10 — WHAT MOVED

| file | what |
|---|---|
| `data/runes.json` | the 110 `spec:` scopes → `class:`, and `written_for` on each; nothing else (every other field byte-identical) |
| `data/glossary.json` | the crit entry (*attack*) and the runes entry (the class and the three gates) |
| `scripts/runes.gd` | `_scope_ok`'s spec branch and the `Spec` band deleted; `shown_scope`; Layered Aegis an `ENGINE_READ` row; `needs_companion`, `pet_holds_back`; the empty-offer sentence's *that class* |
| `scripts/run_state.gd` | `grant_rune` prefers an ordinary rune; the boss offer's pet filter at the roll and the answer (`_pet_seated`, `ability_choice_withheld`); `sitting_out_rune_names` walks the engines; `rune_sits_out_note` reads `needs_companion` |
| `scripts/classes.gd` | `PET_ENGINES`, `engine_needs_pet`, `pet_withholds`; the Sharpshooter's words (*attack*) |
| `scripts/battle.gd` | the pity meter per cast (`_pity_counts`, `_note_pity`); a sitting-out engine in the roll call |
| `scripts/unit.gd` | the pity meter's comment and chip words |
| `scripts/map_screen.gd` | the band through `shown_scope`; the boss overlay's held-back line; the cache overlay's pet line; a sitting-out engine's pouch row and card line |
| `scripts/party_screen.gd`, `shop_screen.gd` | the band through `shown_scope` |
| `scripts/run_sim.gd` | the bot's cache pick prefers an ordinary rune; the worn-rune report's bands |
| `scripts/spec_choice_screen.gd` | a comment |
| `check_hc.gd` (**new**), `run_battery.sh` | the new gate, joined to GATES |
| thirteen gates, twelve suites | §7 |
| `pin-manifest.json`, `baselines.json` | re-derived; the rows §7 names |
| `CLAUDE.md` | *A RUNE IS SCOPED TO ITS CLASS, AND THREE GATES DECIDE WHAT A HERO CAN USE* (ES §2's spec half superseded); the HB block's three follow-ups; the GV, GK and relic/talent/rune blocks' spec sentences |
| `docs/master.html` and its stamp, `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md`, this report | the documents |

