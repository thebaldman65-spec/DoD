# Batch GS — An engine brings only what it cannot run without

*Branch `class-merge`, from `379b6d2` (GR). `main` is untouched. **IMPLEMENT ONLY.** The designer narrowed the engine
rune charter's enabler clause after meeting it in play: an engine that brings four cards is choosing a spec, which is
the thing the merge dissolved. Every lineage now opens with its engine's enablers and nothing else; the 29 cards that
stopped travelling are on their lineages' shelves of the class pool; the Warrior's kit trades Bloodlust for Pommel
Strike; and an engine rune shows its engine's rule wherever a rune's text renders. No engine rule, card, magnitude or
rune was authored or retuned, and `data/runes.json` did not move.*

## NEEDS A RULING

**All five are player-visible.** The rest is in `docs/state.md`'s queue.

1. **THREE ENABLERS ARE THE BATCH'S DERIVATION, PROPOSED** (§1c). The test is the charter's — without the card, with the
   class basic and the class kit every hero holds, does the engine pay anything at all? — and where several cards would
   serve, the one that lays what the engine reads, which is how the designer's two picks read. **Razor Ice** for Glacial
   Hold (three Chilled on one enemy in a cast), **Divine Shield** for Conviction (the builder its own rule names),
   **Hex of Ruin** for Wrath of the Old Gods (Exposed on three enemies in a cast). Each alternative is in §1c.
2. **BLOODLUST COSTS THE BERSERKER NO SLOT** (§2b). The brief said a Warrior holding the Berserker's rune *"must hold
   Bloodlust once and pay one slot for it."* **Once holds. One slot does not**: Bloodlust is the Berserker's enabler
   now, and an enabler sits outside the slot count — the charter's own clause, which the brief did not overturn. Paying
   a slot would make Bloodlust the one enabler inside the count, for every Warrior who holds the rune. Built as the
   charter reads.
3. **THE RULE TEXT FITS THE OFFERS AND THE HERO SHEET, NOT THE PEDDLER OR THE POUCH — AND THE POUCH CAN STRAND THE
   PLAYER** (§3c). Measured on the live screens with all twenty-four runes, HEAD's code beside GS's:
   - **The pouch's Close button, its only way out, is drawn wholly below the 720-pixel screen for four engine runes
     held alone** (the Cryomancer's, the Devout's, the Occultist's, the Beastmaster's) and partly for eighteen more;
     beside one ordinary rune, one and three. **HEAD's placeholder made it five and nineteen** — GS did not cause it,
     and it is the pouch every hero opens straight after class selection.
   - **The Peddler lays rune offers 130 pixels apart, one a hero, and fifteen engine rules run past that by 22 to 137**
     (HEAD eighteen), so the next hero's offer is drawn over the rule and its Buy button; the fourth offer is the
     Hunter's, and the Beastmaster's and the Sharpshooter's run off the bottom there by 99 and 7, as on HEAD.
   - The offers fit (lowest panel 612 of 720); the hero sheet's rune list scrolls, and two rules are taller than its
     168-pixel window (HEAD three). **Nothing was shrunk or cut**: re-laying a screen is the designer's.
4. **FOUR BASICS CHANGED UNDER FOUR LINEAGES, AND NO NUMBER MOVED TO DO IT** (§1d) — CQ §6's shape, one ruling along.
   A Pyromancer's and a Cryomancer's basic is Magic Bolt (25% of Attack, arcane) where it was Fireball or Frostbolt (20%,
   laying Burn or Chilled); an Arcanist's is Magic Bolt where it was Arcane Explosion (10% on two random enemies); an
   Occultist's is Smite (44% of his 100 Attack, holy) where it was Shadowrend (25% and a 2-turn Cripple). It follows
   from *"brings Flamewave and nothing else"*; it is reported because a player feels every one of them.
5. **THREE RETURNING CARDS INVERT EB §1's BASELINE** (§5c, `check_eb`). A draft card cheaper on resource AND shorter on
   cooldown than a comparable core pays no pick and gives none back, and EB §1 named the one that existed. GS made three:
   **Fireball and Frostbolt** (0 Mana, cooldown 0) against the kit's **Magic Missiles** (15, cooldown 2) at initiative
   2.0, and **Aimed Shot** (20, cooldown 1) against the kit's **Powershot** (25, cooldown 2) at 3.0 — cards priced as
   openers, two of them a lineage's free basic. EB's own pair (Divine Plea against Renewal) dissolved, Renewal being a
   draft card now. **Nothing was retuned** (§4); `check_eb` §1 names the three so a fourth still reds.

## THE SHORT VERSION

- **Six of the twenty-four engines bring a card; eighteen bring nothing** (§1). Bloodlust and Flamewave (ruled), the
  three summons (the stated exception), Razor Ice, Divine Shield and Hex of Ruin (ruling 1). The Sharpshooter's Quick Shot
  is the Hunter's own basic. **Before GS a lineage opened with one to five cards beyond the kit, four of them replacing
  the class basic, and at four to six slots; now every hero opens at three.**
- **29 cards stopped travelling and all 29 are on their lineages' shelves** — none deleted. Pools **43 / 51 / 43 / 41 =
  178**, from 38 / 41 / 34 / 36. Every lineage shelf holds eleven to sixteen.
- **Each of the 29 was cast bare and held before it entered the pool** (GP §2's method): **Death Ray, Hymn of Hope and
  Resurrection are refused without their engine and joined `ENGINE_READ`** (34 → 37); the other 26 work without one;
  **Kill Command opens on one summon from an earned Call the Wilds**, so it is not gated.
- **GP §2 holds for the trimmed cards**, both directions, every battery (`check_gs` §2).
- **The Warrior's kit is Crushing Blow · Pommel Strike · Mocking Blow** (§2). A Warrior holds Bloodlust once, only with the
  Berserker's rune, whichever slot — **the dedupe follows the card** — and pays no slot (ruling 2). Pommel Strike reads
  no engine; its card restates its own Perfect.
- **An engine rune shows its engine's rule on every surface**, read live through one door (§3); six render sites in three
  scripts, and a sweep for any other. The fit is measured, not repaired (ruling 3).
- **The unmodified battery ran against the new tree first**: 115 targets, `check_de` at 477 checks and 86 failures —
  35 targets red and five that no longer parsed, beside the two standing sanctioned reds. Each was a suite or gate
  driving a card a lineage no longer opens with, asserting the old kit, reading a deleted name, or a document's needle
  — **none was a game defect**. All were repaired to intent (§5).
- **Found and not fixed** (§6): a drafted Death Ray or Resurrection stays, refused, when its engine is dropped; Battle
  Poise's free Guard Change and Shatterpoint's free Overpower now need the card drafted; four engine texts name cards
  that no longer travel; the sim bot cannot see most of the 29 outside their rotations.
- **Verification:** the acceptance battery is GREEN — 116 targets in 55 minutes on a frozen tree, `check_de` at
  481 / 0 / 0 (HEAD's 477 and four for `check_gs`'s row) and `check_gs` at 730 / 0. The only reds are the two standing
  sanctioned ones, both read against HEAD's code the same day (§5e).

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md` whole, `docs/state.md`'s WHERE block and queue, `docs/reports/GR.md`, GK §1–§3,
GM §2, GN, GP §2 and GQ §2–§3, and the code the brief names — `Classes.PROTECTED_CORES`, the kit builder, `CLASS_KITS`,
`ENGINE_READ`, the engine runes in `data/runes.json` and every surface that renders a rune's `desc`.

| The brief says | Verdict | What the repo says |
|---|---|---|
| GR moved combat law because batches write into it least — 4 commits since FF against 10 for rune law | Held | GR §1c. |
| engine law grew from 22.84 to 41.80 KiB | Held | GR §1b. |
| GK's rule *"an engine's enabler travels with it"* took `PROTECTED_CORES`' whole sixteen | **Held, and it is the smaller half** | Sixteen enablers across nine lineages travelled to a SECOND-slot holder. The hero who TOOK the rune at class selection also opened with his lineage's whole opening kit — its `spec_abilities` and, for four lineages, a basic that replaced the class's. **That is what the designer saw**: the class-selection card's *"Also opens with: Fireball (in place of Magic Bolt), Detonation, Wildfire, Flamewave"* (GQ §3). The trim is of both. |
| an engine that brings four cards | Held | The Pyromancer, the Cryomancer, the Arcanist, the Holy and the Occultist each opened with four beyond the kit — for four of the five, counting the basic that replaced the class's — and the Beastmaster with five (three summons, Hunter's Instinct, Kill Command). |
| Heavy Plating, Stances, Momentum, Savage Assault, Redoubt and the nine rule engines bring nothing already | **Not held for two, and it double-counts** | Savage Assault and Redoubt ARE two of the nine. The spines and the nine brought nothing — true. **Heavy Plating's rune opened with Shieldwall**, and **the stances' rune opened with Overpower, Pommel Strike and Guard Change, and sent Guard Change to a second-slot holder** — `PROTECTED_CORES["swordmaster"]` named it. Both bring nothing now, which is the state the sentence describes. |
| the trimming is entirely in the fifteen lineage engines | **Twelve** | Twelve engines carry a lineage. GK's *fifteen* included the three spines, which never had one. |
| most will come down to one card and several to none | **Not held: six carry a card, eighteen carry none** | Of the twelve lineage engines, five carry one card, the Beastmaster's three summons, and six nothing (§1). |
| the Berserker brings BLOODLUST and no bleed abilities | Held; taken | He opened with Bloodlust (through the kit), Wildstrikes and Hack and Slash; the two bleed cards are on his shelf. |
| the Pyromancer brings FLAME WAVE and nothing else | Held; taken — **the card is `Flamewave`, one word** | No card in any file is spelled *Flame Wave*. |
| the Occultist is trimmed the same way | Taken: **Hex of Ruin** | §1c. |
| the Beastmaster's three summons are the stated exception | Held; taken | |
| GP's pools are 38 / 41 / 34 / 36 | Held | `check_gp` §0 on HEAD. After: 43 / 51 / 43 / 41. |
| a trimmed card returns to the pool and is offered to the heroes who can use it | **Held once confirmed, and three of the 29 needed rows** | Every returning card was cast on a hero of its class holding no engine and again holding it (GP §2's method): Death Ray, Hymn of Hope and Resurrection are refused without their engine and joined `ENGINE_READ`; the other 26 work without one. **Kill Command is refused with no companion and works with one Call the Wilds summon with no engine**, so it is offered to any Hunter, as Battle Poise is to any Warrior. |
| Bloodlust is a Berserker card wearing a class card's slot | Held | A Berserker `spec_abilities` card GN put in the Warrior kit. |
| Pommel Strike replaces it | Taken | It was a **Swordmaster** lineage card, not a class card — §2 reports what it does. |
| GN found four of the twelve kit cards needed rewording | Held | GN's ruling 4: Nexus Ward, Tripwire, Consecration, Powershot. The *four kit texts breaking the standard* in the queue are GQ's finding and a different four. |
| a Warrior holding the Berserker rune must hold Bloodlust once **and pay one slot for it** | **Once: held. One slot: not held — he pays none** | Bloodlust is the Berserker's ENABLER now, and an enabler sits outside the slot count — the charter's clause, which the brief did not overturn. He opens using three slots, the kit's. NEEDS A RULING 2. |
| all twenty-four engine runes' descriptions are placeholders | Held | In `data/runes.json`. |
| the fifteen lineage runes read *"The Berserker's engine."*; the nine new ones and the three spines read *"A Warrior engine."* | **Twelve and twelve** | Twelve lineage runes read *"The <spec>'s engine."*; the three spines and the nine rule engines read *"A <class> engine."* 15 + 9 + 3 is 27. |
| not one says what the engine does; a player buying the Rune of the Occultist is told *"The Occultist's engine"* and nothing more | **The field says nothing; the screens said more** | GK's `Runes._engine_fields` has appended the engine's rule to every instance's desc since the runes existed, so the Peddler, the pouch, an offer and the hero sheet each showed *"The Occultist's engine. Wrath of the Old Gods: every debuff applied marks…"* — measured on HEAD's code in an isolated copy. What the player met FIRST was the placeholder, and on the Peddler a second offer's panel is drawn over the rule's lower lines (§3c). The ruling is implemented as written either way. |
| the class-selection screen is fine; it renders the engine's own rule text | Held | GQ. |
| GQ measured 22 of 24 cards scrolling, the Beastmaster's by 877 px | Held | GQ §2d. |
| `data/runes.json` is in the list of files to update, and §3 says *no data change* | **Read as §3 says** | Not edited: the placeholder stays in the data, unread. |
| "and the stamp" | **`docs/master.html`'s stamp and `docs/state.md`'s *Last rewritten*** | A player-visible batch: the kit, the pools and the rune text all moved, so master.html is edited and its stamp moves with it (the working agreement's step 1). |
| the queue stands, including the 43 engine-reading runes and the 52 engine-bound gates | Held | `docs/state.md` step 5 and step 6. |

## §1 — AN ENGINE BRINGS ONLY WHAT IT CANNOT RUN WITHOUT

### §1a — The rule, recorded over the old one

`CLAUDE.md`'s engine rune charter carries the designer's clause in its blockquote, where GK's *"an engine's enabler
travels with it"* stood, with a paragraph under it naming GK's clause as the one it replaced and why. **What travels
still sits outside the slot count and still leaves when the engine leaves**: GS narrowed WHAT travels, not how. Three
rules follow from it and are written with it: the per-engine test (§1b), *a lineage opens with its enablers and nothing
else, and no engine replaces the class basic*, and *a card that stops travelling lands on its lineage's shelf in the same
batch, cast both ways before it enters*.

### §1b — Per engine: what it brought, the minimum, and what went back to the pool

*Brought* is what a hero opened with beyond his class basic and kit when he took the rune at class selection, read off
HEAD's `Classes.opening_kit` in an isolated copy; *travelled* is what a class-mate holding it second received. Slots are
`Run.ability_slots_used` at the first rung.

| Class | Engine rune (engine) | Brought at HEAD | Travelled at HEAD | Slots | **Brings now** | Back to the pool |
|---|---|---|---|---|---|---|
| Warrior | Berserker (Blood Frenzy) | Wildstrikes, Hack and Slash (Bloodlust in the kit) | — | 5 | **Bloodlust** (ruled) | Wildstrikes, Hack and Slash |
| Warrior | Warden (Heavy Plating) | Shieldwall | — | 4 | — | Shieldwall |
| Warrior | Swordmaster (Seasoned Fighter) | Overpower, Pommel Strike, Guard Change | Guard Change | 5 | — | Overpower, Guard Change (Pommel Strike → the kit) |
| Warrior | Vanguard, Reaver, Bastion | — | — | 3 | — | — |
| Mage | Pyromancer (Overburn) | Fireball *(in place of Magic Bolt)*, Detonation, Wildfire, Flamewave | Fireball, Detonation | 5 | **Flamewave** (ruled) | Fireball, Detonation, Wildfire |
| Mage | Cryomancer (Glacial Hold) | Frostbolt *(in place)*, Razor Ice, Blizzard, Ice Lance | Frostbolt, Ice Lance | 5 | **Razor Ice** (PROPOSED) | Frostbolt, Blizzard, Ice Lance |
| Mage | Arcanist (Runaway Resonance) | Arcane Explosion *(in place)*, Arcane Cannon, Arcane Barrage, Death Ray | Arcane Explosion | 6 | — | all four |
| Mage | Invoker, Weaver, Leech | — | — | 3 | — | — |
| Cleric | Holy (Mercy) | Heal, Renewal, Hymn of Hope, Resurrection | Heal, Hymn of Hope | 5 | — | all four |
| Cleric | Devout (Conviction) | Divine Shield, Consecrated Ground, Blessing of Zeal | Divine Shield, Consecrated Ground | 4 | **Divine Shield** (PROPOSED) | Consecrated Ground, Blessing of Zeal |
| Cleric | Occultist (Wrath of the Old Gods) | Shadowrend *(in place of Smite)*, Hex of Ruin, Bewitch, Dark Pact | Shadowrend, Hex of Ruin | 5 | **Hex of Ruin** (PROPOSED) | Shadowrend, Bewitch, Dark Pact |
| Cleric | Hierophant, Oathkeeper, Arbiter | — | — | 3 | — | — |
| Hunter | Beastmaster (Pack Bond) | the three summons, Hunter's Instinct, Kill Command | the three summons | 5 | **the three summons** (the exception) | Hunter's Instinct, Kill Command |
| Hunter | Sharpshooter (Lethal Aim) | Aimed Shot, Hold Breath | Quick Shot (the basic) | 5 | Quick Shot — the Hunter's basic, nothing extra | Aimed Shot, Hold Breath |
| Hunter | Survivalist (Trapper) | Shrapnel Charge | — | 4 | — | Shrapnel Charge |
| Hunter | Tracker, Skirmisher, Medic | — | — | 3 | — | — |

**29 cards back to the pool; every hero opens at three slots.** The `why` on every `PROTECTED_CORES` row carries the
test's answer for its engine, and the three the batch derived say PROPOSED in the row.

### §1c — The test, per engine, and the three derivations

**Without the card — holding the class basic and the class kit — does the engine pay anything?** Heavy Plating is a
Block-chance rule and reads no ability. The stances open every battle Aggressive, and Aggressive pays from the first
blow; a swap is a card. Runaway Resonance builds on every damaging cast, and Magic Bolt is one. Mercy is gained when an
ally falls below half and pays on every heal, the kit's Ministration among them. Lethal Aim counts consecutive
single-target attacks, and the Hunter's own basic is one. Trapper reads being struck and statuses from any source. The
three spines and the nine rule engines read doors every hero passes (GO). **All of those bring nothing.**

**Overburn, Glacial Hold, Conviction and the Old Gods cannot pay with the basic and the kit**: no Mage basic or kit card
lays Burn or Chilled, and no Cleric basic or kit card lays a divine shield or a debuff. **Pack Bond** has no engine
without a companion. **Blood Frenzy** reads only health lost and Rage spent, so it pays without a card — Bloodlust is the
designer's ruling, not the test's answer.

Where several cards would each serve, the one that travels is the one that lays what the engine reads — the designer's
Flamewave lays Burn on every enemy Overburn counts:

| Engine | Proposed | Why it | The alternatives |
|---|---|---|---|
| Glacial Hold (four Chilled on one enemy holds it) | **Razor Ice** | three Chilled on one target in one cast: three quarters of a hold | Frostbolt, one a cast (four casts to a hold; the old enabler); Blizzard, one or two on every enemy, cooldown 4 |
| Conviction (Faith builds when a divine shield absorbs) | **Divine Shield** | the builder the engine's own rule text names | Consecrated Ground's drip of 1 Faith a turn to every hero on the ground — the other builder, and the old second enabler |
| Wrath of the Old Gods (every debuff applied marks Ruin) | **Hex of Ruin** | Exposed on three chosen enemies in one cast: three marks | Shadowrend, a free attack with a 2-turn Cripple on one (the old override basic); Bewitch, a charm on one, cooldown 4 |

### §1d — What the four lineages lost from slot 0

`apply_kit_overrides` is deleted and no engine replaces a basic. The four cards it used to lay in slot 0 keep their
one definition in `Classes.basic_override_ability` and are drafted by name, so, drafted, one of them sits past slot 0
and runs the skill check like any damaging card (a basic in slot 0 resolves at a fixed Good). **The basics each of
the four lineages opens with, at the same Attack:**

| Lineage | Opened with (slot 0) | Opens with now |
|---|---|---|
| Pyromancer | Fireball — 20% of Attack, fire, 3 turns of Burn | Magic Bolt — 25%, arcane |
| Cryomancer | Frostbolt — 20%, frost, 1 Chilled | Magic Bolt — 25%, arcane |
| Arcanist | Arcane Explosion — 10% on two random enemies, arcane | Magic Bolt — 25%, arcane |
| Occultist | Shadowrend — 25%, shadow, a 2-turn Cripple | Smite — 44%, holy (his Attack is 100, a Cleric's 50) |

The class-selection screen's figure line (GQ) now names the Rune of the Occultist on a Cleric's screen, because his
Smite reads his Attack. **No magnitude was edited.** NEEDS A RULING 4.

### §1e — Every card that stopped travelling landed, and GP §2 holds for it

**The 29 are on their shelves** (`SPEC_DRAFT_POOLS`, each under a `# BATCH GS §1` comment), so `Classes.draft_pool`
draws them and the engine gate decides who is offered them. Depths after:

| | Warrior | Mage | Cleric | Hunter |
|---|---|---|---|---|
| Class pool (HEAD → GS) | 38 → **43** | 41 → **51** | 34 → **43** | 36 → **41** |
| Shown to a hero holding no engine | 35 → **40** | 29 → **38** | 22 → **29** | 29 → **34** |
| Lineage shelves | Berserker 12, Warden 11, Swordmaster 14 | Pyromancer 16, Cryomancer 14, Arcanist 16 | Holy 14, Devout 13, Occultist 13 | Beastmaster 12, Sharpshooter 12, Survivalist 11 |

**GP §2's method, applied to the 29 before they entered.** Each was cast on a hero of its class holding no engine, on a
board dressed so a no-op could only be the engine's fault, and again holding it:

- **Refused bare, and gated:** Death Ray (below 8 Resonance), Hymn of Hope (1 Mercy against an absent bar),
  Resurrection (1 Mercy, a hero down or not). `ENGINE_READ` gained three rows, each with its `why`: **37**.
- **Refused with no companion and opened by an earned card, so NOT gated:** Kill Command — one Call the Wilds summon
  with no engine, and the Hunter ordered Ursus to strike for 36. GP's Battle Poise shape: conditional on a card.
- **Works without its engine, the engine adding to it:** the other 26 — Detonation's refund, Frostbolt's permanent
  Chilled, Arcane Cannon's Break damage, Shadowrend's Ruin, Hold Breath's Focus, Shrapnel Charge's Poison and the rest.
  Seven cast identically on both arms (Shieldwall, Guard Change, Consecrated Ground, Blessing of Zeal, Dark Pact,
  Hunter's Instinct, Aimed Shot), and every one moved the board bare.

`check_gs` §2 drives both arms for all 29 every battery, and asserts the offer door agrees in both directions.

### §1f — What changed in the code

`scripts/classes.gd`: `PROTECTED_CORES` rewritten under a GS §1 header; `CLASS_KITS`'s Warrior row; the 29 on
`SPEC_DRAFT_POOLS`; three `ENGINE_READ` rows; **`lineage_opening(spec)`** (a lineage's enablers as Abilities — its term in
`opening_kit`), **`basic_override_ability(name)`** (the four basics' one definition, resolved by `pool_ability`), and
`_hold_each`, the one dedupe; `enabler_slots`, `lineage_slots`, `kit_slots` and `protected_names` read the opening.
**Deleted, not zeroed**: `ENGINE_BOUND` with `engine_bound()`, and `apply_kit_overrides`, each with a comment at its old
site saying what stood there and why it went; `_carry_enablers` gave way to `lineage_opening` and `_hold_each`. `ability_corpus` reaches the four basics on their shelves.
`scripts/spec_choice_screen.gd` drops *"(in place of …)"*.

## §2 — THE WARRIOR'S KIT

### §2a — Pommel Strike

`CLASS_KITS["warrior"]` is **Crushing Blow · Pommel Strike · Mocking Blow**. Pommel Strike keeps its one definition in
the Swordmaster's `spec_abilities` and `class_kit` resolves it through `pool_ability` (GN's rule: a kit card keeps its
one definition where it was).

- **What it does:** one enemy, 25% of Attack, physical, **30 Break damage**; **always Stuns for 1 turn** — a boss resists
  the Stun until Broken, unless the strike is **Perfect** (its Perfect: the Stun lands even on an unbroken boss); its own
  **25% crit chance** in place of the base; **builds 10 Rage**. Tagged DEBUFF · BREAK.
- **Cost 20 Rage, cooldown 3, initiative 2.0.** It runs the skill check.
- **It reads no engine.** Its read sites are its crit base, its Perfect's Stun, and two talent branches — Pressure Point's
  Break and Untouchable's counter — whose fields (`pressure_point_ranks`, `untouchable`) nothing has written since FX.
  Cast on a Warrior with the stances and without, the two differ only by the stance's own damage term, which is the
  engine reading every blow, not the card reading the engine.
- **The text-standard check:** no pronoun, keywords capitalised, every line under 44 characters, no authored number in
  parentheses. **One fault: the description restates the Perfect** — *"Bosses resist Stun until Broken — unless the strike
  is PERFECT"* beside a Perfect line that says *"The Stun lands even on a boss"*, a second copy of a clause the renderer
  prints. Not authored at GS (§4); recorded in §6.
- **The bot:** `_bot_class_kit_pick`'s Warrior branch casts Mocking Blow when no enemy is held, then Pommel Strike wherever
  its Stun can land (not an unbroken boss — the Swordmaster rotation's own test), then Crushing Blow. Bloodlust's case
  left the branch; the Berserker rotation casts it, as it did before GN.

### §2b — Bloodlust once, and the slot

**The dedupe follows the card.** `Classes.opening_kit` appends by name through one helper, `_hold_each`, and skips a card
the hero already holds, whichever route brought it. Driven live in `check_gs` §3: a Berserker holds Bloodlust once; a
Warden holding the Berserker's rune second holds it once; a Warden who dropped it holds none; and a Warrior with no engine
opens with Strike, Crushing Blow, Pommel Strike and Mocking Blow in a real fight.

**The slot: none.** Bloodlust is an enabler, outside the count; every Warrior opens at three whichever engine he holds.
NEEDS A RULING 2.

## §3 — AN ENGINE RUNE SHOWS ITS ENGINE'S RULE

### §3a — The door

`Runes.shown_desc(rune)` is the one door every surface asks: an engine rune answers `Runes.engine_text(pid)` — the
engine's rule, the same words its class-selection card shows, flattened for a soft-wrapping label — read LIVE off
`Classes`, never off the instance, because an instance rides the save and a desc written onto it would go on showing the
day it was built. An ordinary rune answers its own desc, unchanged. `Runes._engine_fields` builds an instance's desc as
the rule alone. **No data changed**: the twenty-four placeholders stay in `data/runes.json`, unread.

### §3b — Every surface that renders a rune's text

| Surface | Site | Engine runes there |
|---|---|---|
| The Peddler's rune column | `shop_screen.gd` `_draw_screen` | yes |
| A rune offer — the elite cache and the bargain | `map_screen.gd`'s pick overlay, through `Run.rune_choice` | yes |
| The pouch's ENGINES rows | `map_screen.gd` `_open_rune_panel` | yes |
| The pouch's rune rows | `map_screen.gd` `_open_rune_panel` | ordinary runes only; asks the door anyway |
| The map card's worn-rune slot tooltip | `map_screen.gd` | ordinary runes only (engines hold their own slots); asks the door anyway |
| The hero sheet's rune list | `party_screen.gd` | yes |

Six sites in three scripts. The class-selection screen already rendered the rule (GQ). `check_gs` §4 draws the Peddler,
the pouch, an offer and the hero sheet with each of the twenty-four and asserts the rule shown and no placeholder shown,
asserts an ordinary rune's own desc, asserts the door answers the rule over an instance saved with the old words, and
sweeps the game's scripts for a rune's `desc` read anywhere but the door.

### §3c — The fit

Measured by drawing each screen with each rune, in isolated copies of HEAD's code and GS's (windowed; screenshots in the
batch's scratch). **Reported, not repaired; nothing was shrunk or truncated.**

| Surface | How it lays out | HEAD | GS |
|---|---|---|---|
| **Pouch, the engine held alone** (every hero after class selection) | fixed panel from y 120; a 380-pixel rune scroller; Close at the foot, the ONLY way out | Close wholly off-screen **5**, partly **19**, clear 0 | wholly off **4** (Cryomancer, Devout, Occultist, Beastmaster), partly **18**, clear **2** |
| Pouch, one ordinary rune beside it | the same | off 2, partly 3 | off **1** (Beastmaster), partly **3** |
| **The Peddler** | a panel per hero's offer, 130 apart, 118 minimum | 18 of 24 taller than the pitch | **15** taller, by 22 to 137 — the next offer is drawn over the rule and its Buy button |
| The Peddler's fourth offer (the Hunter's) | from y 552 | Beastmaster +99, Sharpshooter +7 past 720 | the same |
| A rune offer (cache, bargain) | three buttons in an overlay | lowest panel 632 of 720 | **612** — fits |
| The hero sheet | a 168-pixel scroller | 3 taller than the window | **2** (Cryomancer +9, Beastmaster +49); scrolls |

**The pouch is the finding.** With the rune held alone, its label runs 37 to 157 pixels, and the panel is a fixed stack
above a 380-pixel scroller, so a long rule pushes Close off the screen — there is no Escape and no other close. HEAD's
placeholder made every label taller; GS's rule-alone text brought two runes' Close fully back, and the rest is layout.

## §4 — WHAT DID NOT MOVE

No engine rule text, no engine magnitude, no card's numbers and no rune: Sanctity is not re-authored, no card was
authored, retuned or rebalanced, and the queue stands — step 5's 43 engine-reading runes and step 6's gates. The
stat blocks, the zone-boss pools (`SPEC_POOLS`) and the spec runes still follow the lineage.

## §5 — VERIFICATION

### §5a — The saves

The player's save files were copied to `save-backups/GS-20260918-185429/` before anything ran and verified by hash:
`profile.json`, `relics.json` and `settings.cfg`. **The fourth, `run_save.bin`, did not exist** — no run was in
progress (the profile was last written at 18:24, before the batch began; GR's backup still held a run save). Every
control copy was renamed (`config/name`) before it ran, so its `user://` could not reach them; `check_gs` §5 reads them byte for byte; and they were hashed again after the battery: identical — `profile.json`, `relics.json` and `settings.cfg`
match the backup byte for byte, and `run_save.bin` is still absent.

### §5b — The unmodified battery against the new tree

Before a gate was edited, the whole battery ran unmodified against GS's code in the tree: **115 targets, `check_de`
at 477 / 86 / 5 notices, `BATTERY_EXIT` 0.** Beside the two standing sanctioned reds (`check_cm_live` 13 / 4 and
`check_gj` §4's Bell), **thirty-five targets were red and five no longer parsed**, and four more moved their count
with no failure — `check_go` among them, skipping in silence. Sorted by cause, none of them a game defect:

- **A card the lineage no longer opens with, driven by a suite or gate that expected it in hand** — the largest group:
  a Fireball, a Detonation, a Death Ray, a Resurrection, a Shieldwall, an Aimed Shot not on the bar, so a cast threw or
  a check read nothing. One read GREEN while it skipped: `check_go` fell 401 → 398, two checks behind an
  `if det != null` and one behind a Shrapnel Charge lookup. **Repaired by seating the card as a player gets it now —
  drafted.**
- **An assertion about the old kit, the slot arithmetic or a pool depth** — *"Death Ray is in the opening three"*,
  *"Holy's four opening abilities cost four slots"*, *"a fresh Pyromancer uses 5 of 7"*, the sixteen-enabler table,
  the depth tables. **Repaired by asking the GS truth that answers the same question.**
- **Five files that no longer parsed**, each naming a structure GS deleted (`apply_kit_overrides`, the bound table),
  and `check_dn` outside the battery with them — so `check_parse` read 189 / 6.
- **Four documents' needles**: `master.html`'s draft total (178) in `check_do`, `test_batch_br` and `test_batch_bu`, and
  *DEBUFF for seven* where `check_es` §4's census reads six, in `master.html`, `CLAUDE.md` and `state.md`. Met by the
  documents.

### §5c — The repairs, target by target

**One rule for every repair, and it is the project's: a stale assertion is repaired to intent, never deleted, never
loosened.** Where a check drove a card a lineage no longer opens with, the card is seated as DRAFTED — the new
`lineage_cards` option both fixtures share, derived in one place (`gate_fixture.lineage_cards`: the card on the
lineage's shelf and defined by it, or the override it defined) — and found by name, never by bar position. Where a check
asserted the old kit, the slot arithmetic or a pool depth, it asks the GS truth that answers the same question.

*Recon* is the unmodified target against GS's code; *now* is the repaired target (`checks / failures`); *HEAD's
row* is `baselines.json` before GS. Every count that moved is attributed in the row's `baselines.json` note, by an
`ok()` trace where the cause was not already one sentence.

| Target | Recon | Now | HEAD's row | What changed, and why the count is what it is |
|---|---|---|---|---|
| `test_batch_ah_battle` | 68 / 1 | 68 / 0 | 69 | The bar count is `opening_kit` + the two earned, Bloodlust held once. −1: one hotkey check a menu slot, and the Berserker's bar is 13, not 14. |
| `test_batch_ai` | 227 / 1 | 228 / 0 | 228 | The "starting-kit piece" is derived off `opening_kit` (Hack and Slash is drafted now). |
| `test_batch_ak` | 334 / 17, 4 throws | 334 / 0 | 334 | Seats the Swordmaster's cards drafted; the §1 guarantee inverted to GS's truth — the rune alone gives no Guard Change, and a drafted one stays when it is dropped. |
| `test_batch_al` | 473 / 5, 2 throws | 479 / 0 | 479 | Seats Shieldwall drafted; the per-ally cover checks run again. |
| `test_batch_ar` | 501 / 2 | 510 / 0 | 510 | Seats Fireball, Detonation, Wildfire drafted and casts them by name; the kit check asks shelf and enabler. |
| `test_batch_as` | 263 / 3 | 267 / 0 | 267 | The Cryomancer's three, drafted, by name. |
| `test_batch_at` | 337 / 4, 1 throw | 353 / 0 | 353 | The Arcanist's four, drafted; Death Ray's check asks shelf, Resonance gate and bar; the lineage table asserted on the shelf. |
| `test_batch_au` | 291 / 7, 16 throws | 295 / 0 | 278 | Cannon and Death Ray drafted. +17: GS's deeper pools (+13, in the recon) and four checks a throw had cut. |
| `test_batch_av` | 259 / 15, 7 throws | 269 / 0 | 269 | The Holy's four drafted; §1 asks where they are now and that she opens as any Cleric. |
| `test_batch_az` | 450 / 5, 4 throws | 450 / 0 | 452 | Aimed Shot drafted. −2: the "comes from the kit" walk reads four names on his bar, not six. |
| `test_batch_bh` | 296 / 1 | 304 / 0 | 304 | Certain fits only Wildstrikes and Hack and Slash, so the upgrade battery seats the lineages' cards and reaches all eight again. |
| `test_batch_bn` | 77 / 1 | 80 / 0 | 80 | Ice Lance drafted. |
| `test_batch_bo` | 1308 / 25, 8 throws | 1311 / 0 | 1158 | The core, slot and fill checks re-derived on GS's opening; Fireball and Aimed Shot drafted; Arcane Explosion and Death Ray named on DO's argument. +150 is GS's pools under its per-card loops (in the recon), +3 checks a throw had cut. |
| `test_batch_bp` | 444 / 3 | 444 / 0 | 451 | The Swordmaster has no enabler and every Warrior opens at 3; §7's coin-flip bench pair re-pointed. −7: one check per enabler, sixteen to nine. |
| `test_batch_bq` | did not parse | 822 / 0 | 822 | Shadowrend read off `basic_override_ability`; Blink's kit arm casts a class-kit card. |
| `test_batch_bv` | 565 / 2 | 565 / 0 | 565 | The Beastmaster's core is one bar entry, no lineage slot. |
| `test_batch_bw` | 504 / 2 | 506 / 0 | 513 | Hack and Slash drafted for Berserk's board. −7: one check per enabler. |
| `test_batch_cb` | 1968 / 1 | 1969 / 0 | 1940 | Ice Lance drafted; the draft count read live and rendered in words. +29: GS's shelves under a per-card loop (+28, in the recon) and the Ice Lance control, which the missing card had cut. |
| `test_batch_cd` | 99 / 16 | 99 / 0 | 99 | The authoritative depth tables: 158 + 20 = 178. |
| `test_batch_ce` | 942 / 5 | 942 / 0 | 1109 | The three Cleric enabler rows and Holy's slots, re-pinned. −167: the enabler walk (16 → 9, across 28 pools) and the name walk (129 → 158). |
| `test_runes` | 5622 / 3 | 5622 / 0 | 5628 | A rune's card is reachable through the draft door too; the eligibility arm made two-way again. −6: Butcher's Bill and Split Shield no longer roll for a hero who has drafted nothing. |
| `test_rune_battle` | 95 / 3 | 97 / 0 | 97 | The Mage seat's cards drafted; the forced hit is Fireball again. |
| `check_cz` | did not parse | 136 / 0 | 134 | The override half asserted empty; the set identity is the class-kit half. +2. |
| `check_da` | 43 / 0 | 43 / 0 | 43 | `check_cz`'s exemption reason corrected. |
| `check_dr` | 79 / 3, 1 throw | 80 / 0 | 80 | The Swordmaster's pool is DR's 12 plus GS's two; Battle Poise's board seats Guard Change. |
| `check_du` | did not parse | 35 / 0 | 32 | No spec replaces its basic — inverted, not deleted; the four found by their one definer. +3. |
| `check_dv` | did not parse | 83 / 0 | 83 | Holy's core 0; outside every pool and kit: 37 → 8, the enablers. |
| `check_ea` | 83 / 1 | 83 / 0 | 83 | Earnable slots are the cap less `lineage_slots + kit_slots`; the short set is empty. |
| `check_eb` | 16 / 5 | 19 / 0 | 14 | Three named crossovers (ruling 5) and EB's asserted gone. |
| `check_eh` | 156 / 1 | 156 / 0 | 163 | Nine enablers across seven lineages. −7: the enabler walk. |
| `check_ez` | 68 / 2, 5 throws | 106 / 0 | 106 | Shieldwall drafted for the Split Shield's board. |
| `check_ft` | 146 / 1 | 146 / 0 | 146 | §1e picked Magic Burst once Death Ray left the bar, and its Elemental Weakness moved the next blow: the lineage's cards are seated, and the fifth confound is written down. |
| `check_gm` | did not parse | 148 / 0 | 101 | The bound table asserted gone; the builder both ways for all twelve; the gate driven at the offer. +47, all in §2. |
| `check_gn` | 196 / 9 | 199 / 0 | 197 | Pommel Strike's case driven; no lineage opens with a kit card; every lineage at 3. |
| `check_go` | 398 / 0 | 401 / 0 | 401 | Silent skips: §4 seats Detonation and §10 Shrapnel Charge, each now red if the card is missing. |
| `check_gp` | 458 / 8 | 452 / 0 | 389 | Death Ray's arm built to 8 Resonance; Resurrection cast at a fallen hero; the engine-less road kept engine-less. +69 is GS's pools (in the recon); −7 offers on the repaired road, +1 premise. |
| `check_gq` | 5018 / 8 | 5018 / 0 | 5112 | A rune adds exactly its engine's enablers; no rune replaces the basic. −94: GS's deals add fewer cards. |
| `check_dn` | did not parse | runs | — | Not in the battery; its core read off `opening_kit`. |

**Four targets went red on a document and nothing else** — `check_do`, `test_batch_br` and `test_batch_bu` on
`master.html`'s draft total, and `check_es` §4 on *DEBUFF for seven* in three documents (the census reads six) — and
the documents were corrected. **`check_parse`** was red for the six files that did not parse (`check_dn` among them), and reads 190 with
`check_gs`. **Three moved their count and nothing else**, attributed by an `ok()` trace of HEAD against GS:
`test_batch_an` −25 (its modifier arms assert once per opening card: eleven lineage cards left the party's openings
and two kit and basic cards joined, −27; the seeded route +2), `test_batch_ba` −1 (Shrapnel Charge left the
Survivalist's opening, one card fewer to walk) and `check_fh` −1 (its bench overlay's protected-card walk reads
Pommel Strike where it read Wildstrikes and Hack and Slash).

### §5d — `check_gs`, and its controls

**730 checks.** §0 the twenty-four openings against its own copy of the §1 table; §1 every card a lineage defines is an
enabler, a kit card or on its shelf, and the deleted structures stay deleted; §2 the 29 cast bare, and the offer door both
ways; §3 the Warrior's kit, the one Bloodlust, the bot's case; §4 the door and the four surfaces; §5 the player's files.

Eight defects were injected one at a time into an isolated copy of GS's code, restored by copy after each and compared
byte for byte after the last; the clean arm read **730 / 0**. **Every one bit, and every FAIL line names its defect**:

| Injected | Read | The FAIL line it printed |
|---|---|---|
| The Pyromancer's enabler swapped to Detonation | 730 / 6 | §0 *the overburn rune brings ["Detonation"] — the minimum recorded for it is ["Flamewave"]*; §1 *Flamewave … has 0 homes among enabler, kit and shelf* |
| Every lineage opening with its whole definition table — HEAD's shape | 742 / 58 | §0 every trimmed rune named with what it brings, and every lineage's slots |
| Wildfire taken off its shelf | 730 / 3 | §1 *Wildfire (the pyromancer's) has 0 homes*; §2 *a mage holding no engine is not offered Wildfire* |
| Hymn of Hope's `ENGINE_READ` row removed | 729 / 3 | §2 *Hymn of Hope is offered to a cleric holding no engine and does nothing for him* |
| Bloodlust back in the Warrior kit | 735 / 14 | §0 the Berserker brings nothing; §1 Pommel Strike has no home; §3 *the Warrior kit is ["Crushing Blow", "Bloodlust", "Mocking Blow"]* |
| The Peddler reading `rune["desc"]` around the door | 730 / 2 | §4 *`shop_screen.gd` reads a rune's desc around the door*; the door asked five times, not six |
| The door answering a saved instance's desc | 730 / 24 | §4, one per rune: *a saved engine_… shows the words it was saved with* |
| A `ENGINE_READ` row for Kill Command | 731 / 2 | §2 *Kill Command is a row of `ENGINE_READ` and opens on an earned Call the Wilds with no engine* |

**The last arm first read 730 / 1, and the one line was the count** (*4 returning cards are gated — GS derived three*):
the gated branch cast Kill Command on a bare board, where it is refused anyway. The branch now drives the companion an
earned Call the Wilds calls, so the defect is named where it is; the clean count did not move. **HEAD's code cannot run
this gate** — it calls `Runes.shown_desc`, `Classes.lineage_opening` and `Classes.basic_override_ability`, none of which
exist there — so the second arm IS HEAD's opening kit, inside GS's code, and it bites 58 ways.

### §5e — The acceptance battery

**A full pre-pass came first**, over the repaired tree with every document landed: green but for exactly the rows it
was run to find — 21 targets whose count moved (eleven fell and ten rose, each attributed in §5c) and `check_gs`,
unwatched — and those rows were written into `baselines.json` with their reasons before the acceptance run. **Its two
sanctioned reds were run on HEAD's code** in an isolated copy the same day: `check_cm_live` reads 13 / 4 there with FAIL
lines byte-identical to GS's, and `check_gj` §4 reads +172 / +192 there against +169 / +189 here — GS's pools and kits
move what the gate's seeded run draws, and the gap is still the Bell's 20 gold.

**The acceptance battery, on the frozen tree** — stamped by md5 before and after, 570 files by absolute path, untracked
included, identical: **116 targets in 55 minutes, `BATTERY_EXIT` 0, `check_de` at 481 / 0 / 0** (HEAD's 477 and four
for `check_gs`'s row), **`check_gs` at 730 / 0**, and the run harness's three gates PASS at 22 / 382 / 8. The only reds
are the two sanctioned ones, as recorded: `check_cm_live` 13 / 4 and `check_gj` §4 at +169 / +189. **Not one `Parse Error`
or `SCRIPT ERROR` line in any target's stream**, grepped rather than tallied. The player's files hashed identical to the
backup afterwards, and the process table held no Godot process.

**Sizes, as `check_fg` printed them:** `CLAUDE.md` 326,190 → **331,327 B = 323.56 KiB**, 16.44 KiB under its 340 KiB
ceiling; `docs/changelog.html` 378,932 B, 21,068 B under its bar, GS's entry 4,838 B. `check_gq` prints the
class-selection screen's lowest line at 711 of 720, on a Warrior's.

## §6 — FOUND AND NOT FIXED

- **A CARD THE ENGINE GATE OFFERS ONLY TO ITS HOLDER STAYS WHEN THE ENGINE IS DROPPED, REFUSED.** Driven through the real
  doors in an isolated copy: an Arcanist holding Resonance takes Death Ray from an offer (`Run.take_draft_ability`), a
  Holy holding Mercy takes Resurrection and Hymn of Hope, each drops the rune from the pouch (`Run.toggle_engine`) — and
  the next fight seats all three, every one refused by `_ability_usable`, the two Mercy cards labelled *"Resurrection
  1"* and *"Hymn of Hope   1"* with no meter named. An earned card is never lost (EG), so this is GM's ruling 1's second
  group grown by three, and GL's dead button back for the drafted copy: GM §2 closed it for the opening kit, which no
  longer holds any of the three. `CLAUDE.md`'s GM §2 bullet says so.
- **TWO CARDS' SECOND CLAUSES NOW NEED A DRAFTED CARD.** Battle Poise's *"ONCE A TURN a parry also buys a free GUARD
  CHANGE"* asks `_ability_usable` about the hero's own Guard Change, and Shatterpoint's *"he instantly casts Overpower on
  them for free"* casts the hero's own Overpower; both were the Swordmaster's opening kit until GS, and each clause pays
  nothing to a Warrior who has not drafted the card. The talent branches that also answer with Overpower or Pommel Strike
  (Riposte, Opportunist, Untouchable, Pressure Point) read fields nothing writes since FX.
- **FOUR ENGINE RULE TEXTS NAME CARDS THAT NO LONGER TRAVEL WITH THEM**, and every rune surface shows these texts now:
  Seasoned Fighter — *"Guard Change swaps"*; Glacial Hold — *"until Ice Lance or Shatter releases it … not Blizzard"*;
  Mercy — *"Stacks pay for Hymn of Hope"*; Conviction — *"doubled under Blessing of Zeal"*. No engine text moved (§4).
- **THE SIM BOT CANNOT CAST MOST OF THE 29 OUTSIDE THEIR OWN ROTATIONS.** `_bot_drafted_pick` casts a drafted card only
  if `Classes.draft_ability` resolves it, and none of the 29 is defined there — GM's Mana Shield finding, twenty-nine
  wide. The engine rotations still cast the cards they name, for their own lineage. **The four drafted basics are cast
  by nobody**: the rotations that used them read slot 0, which is the class basic now — the Cryomancer's *"Frostbolt the
  mark"* casts Magic Bolt. Sims only; a player casts what he holds.
- **THE FOUR DRAFTED BASICS RUN THE BAR NOW, AND ONE HAS NO PERFECT BEHIND IT.** In slot 0 a basic resolves at a
  fixed Good (CN §2); drafted, these four sit past slot 0 and run the skill check. Fireball's, Frostbolt's and
  Shadowrend's Perfect lines are reachable for the first time since CN, and **Arcane Explosion's bar has no Perfect** —
  a `test_batch_cp.CHECK_WITHOUT_PERFECT` name since DW, latent while it sat in slot 0 and live now (`test_batch_bo` §5
  names it and Death Ray beside DO's Rampage and Pyroblast, on DO's argument).
- **POMMEL STRIKE'S CARD RESTATES ITS PERFECT** (§2a).
- **THE CLASS-SELECTION SCREEN STILL FITS, AT 711 OF 720** on a Warrior's (GQ's lowest was 691 on any): the kit below the
  cards prints Pommel Strike where it printed Bloodlust. The figure note GQ built — *"Figures are for the … with no
  engine"* — is owed on 20 of the 80 deals now: the Warden's ten, and the Occultist's ten, which are new (§1d).
- **INSTRUMENT FINDINGS, NONE A VERDICT CHANGE.** `check_gp` §4's engine-less road answers every rune pick with the first
  button, so on GS's seeded walk it took ten engine runes and slotted seven, and read the game correctly offering their
  cards as a leak — it unslots them through the pouch's own door now, and asserts none is slotted when a draft is
  rolled. `test_batch_bp` §7's bench pair named Guard Change and Overpower, which a Swordmaster's own draw now deals him
  (the first card of about one offer in twenty) — a coin-flip red, re-pointed at his protected opening. And
  `test_batch_bw`'s *"against every opening kit"* loop walks the four class keys, for which `spec_abilities` returns
  nothing, so it has checked nothing since it was written; not repaired (no GS cause).
- **SIXTEEN OF THE SEVENTEEN LIVE RUNES THAT NAME A CARD NAME ONE OUTSIDE THE SPAWN KIT** (ten until GS). Open Wound
  (Shadowrend), the Split Shield (Shieldwall), Butcher's Bill (Hack and Slash), Cold Snap (Ice Lance), Open Line (Guard
  Change) and Grace (Hymn of Hope) join the ten offered only once their card is drafted — `requires_ability` doing its
  job. Only Layered Aegis (Divine Shield) is reachable at spawn, by the Devout.
- **THE RETIRED RUNE OF THE LAST RITES STILL SAYS *"She already knows Resurrection"***, and a Holy who has not drafted it is
  granted it now. Retired, so never offered; found by the repair of `test_batch_av`.
- **CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GS ctl", "GS head", "GS trace", "GS rep G1" to "G5",
  "GS rep G4probe", "GS rep G5 ctl" and "GS rep G5 head" — each renamed before anything ran
  in it. They can be deleted.

## §7 — FILES

- **Game code (7):** `scripts/classes.gd`, `battle.gd`, `runes.gd`, `shop_screen.gd`, `map_screen.gd`,
  `party_screen.gd`, `spec_choice_screen.gd`.
- **Fixtures (2):** `gate_fixture.gd` and `suite_fixture.gd` — the `lineage_cards` option, derived in one place.
- **New gate:** `check_gs.gd`, and `run_battery.sh`'s GATES.
- **Repaired to intent (38):** the suites `test_batch_ah_battle`, `ai`, `ak`, `al`, `ar`, `as`, `at`, `au`, `av`, `az`,
  `bh`, `bn`, `bo`, `bp`, `bq`, `bv`, `bw`, `cb`, `cd`, `ce`, `test_runes` and `test_rune_battle`; the gates `check_cz`,
  `da`, `dn`, `dr`, `du`, `dv`, `ea`, `eb`, `eh`, `ez`, `ft`, `gm`, `gn`, `go`, `gp` and `gq`.
- **Instrument data:** `pin-manifest.json` (1,475 → 1,491 pins: `check_gs`'s and `check_gm`'s new ones, and one
  `test_batch_cb` literal that is read live now), `baselines.json`.
- **Documents:** `CLAUDE.md`, `docs/master.html` (and its stamp), `docs/state.md`, `docs/changelog.html`,
  `docs/design-notes.md`, and this report (new).
- **Not edited:** `data/runes.json` (§3 ruled no data change), and `save-backups/`, which stays uncommitted.
