# Batch GQ — The engine cards say only what differs

*Branch `class-merge`, from `03d0ed3` (GP). `main` is untouched. **IMPLEMENT ONLY.** The class-selection screen: the
subtitle under each rune's name goes, the class kit moves off the three cards and appears once below them at the
figures of a hero holding no engine, and each card keeps only what differs. One game script, one new gate, the battery
runner, the baselines and the documents. No engine, kit card, magnitude or rule moved.*

## NEEDS A RULING

**Only what a player meets, or what blocks the ruled work, is here** (`docs/ways-of-working.md`). The rest is in
`docs/state.md`'s queue.

1. **THE SCREEN'S NEW WORDS ARE PROPOSED.** On a card: *"Also opens with: Summon Ursus, Summon Canis, Summon Aguila,
   Hunter's Instinct, Kill Command"*, and *"Fireball (in place of Magic Bolt)"* where a rune's own basic replaces the
   class basic. Under the cards: *"With no engine, the Warrior opens every fight with these. A rune adds what its card
   names."* And, on a Warrior's screen dealt the Rune of the Warden: *"Figures are for the Warrior with no engine: the
   Rune of the Warden sets Attack to 75, and they move with it."*
2. **THE CARD'S TEXT WINDOW IS FIXED AT 280 PIXELS, SO A DEAL OF SHORT RULES SHOWS EMPTY CARD SPACE** (§2d). It was
   sized so that no rune's text scrolls and the kit still fits the screen, and it puts the kit and the three buttons in
   the same place on every deal. The alternative — cards fitted to the tallest text on the screen — moves the kit and
   the buttons from deal to deal, and was not taken.
3. **`CLAUDE.md` CROSSED ITS 340 KiB CEILING AT GP, AND THE MOVE LEFT IS THE DESIGNER'S** (FOUND AND NOT FIXED
   below). Not player-facing; it blocks the ceiling's own ruled procedure, whose only remaining step is a split by
   subject that overturns a tiebreak. GQ added nothing to the file.

## THE SHORT VERSION

- **The subtitle is gone** — the spec's archetype (*Tank*, *Ramp*…) or, for a rune with no lineage, *"Warrior engine"*
  — and so is the one-sentence lineage blurb. **Both rendered on this screen and on no other.**
- **Each card is its rune's name, its engine rule and — for a rune that carries a lineage — the abilities it opens with
  beyond the kit, by name.** That last clause is a ruling taken mid-batch, because **the brief's premise held for only
  half the runes**: the twelve with no lineage (the three spines and all nine rule engines) add nothing, and **the other
  twelve each add one to five abilities no other card offers — thirty-seven in all.** Removing them with the kit would
  have removed the very differences the screen exists to show (§2a).
- **The class basic and class kit appear once, below the cards,** at the class's own Attack — a hero holding no engine.
  **A line under them names a dealt rune that would move one of those figures**, derived rather than listed: only the
  Rune of the Warden, on a Warrior's screen.
- **No card scrolls.** Before, 22 of the 24 did, the Beastmaster's by **877 pixels**; now the tallest text is his at
  **277 in a 280 window**, and the lowest line on any screen ends at **691 of 720**. The text was not shrunk.
- **New gate `check_gq`, 5,112 checks**, draws all eighty deals — twenty per class — on the real screen, and was
  armed against HEAD's own screen and nine targeted injections before it was trusted.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md`, `docs/state.md`, `docs/reports/GP.md`, `docs/ways-of-working.md`,
`docs/text-standard.html` and the code each premise names. **Fourteen rows: four premises did not hold, one held in
effect and not in mechanism, and the rest held.**

| The brief says | Verdict | What the repo says |
|---|---|---|
| each card repeats the same three class-kit abilities, because the kit is guaranteed | **Held** | Every card listed the kit, and the class basic besides. |
| so he reads identical text three times **to find the one paragraph that differs** | **DID NOT HOLD for half the runes** | True of the twelve runes with no lineage. **The twelve that carry one each list 1–5 abilities no other card has** (37 in all), and four swap the class basic for their own (§2a). |
| Strike reads 15–19 under one card and 20–25 under the others | Held | 23% of Attack: 15–19 at 75, 20–25 at 100. |
| **the Warden's Heavy Plating changes his stats** | **Held in effect, not in mechanism** | Heavy Plating is a Block rule. Taking its rune makes the hero a Warden LINEAGE, and that stat block's Attack is the Tank role's **75** (`ROLE_ATTACK`). A second rune moves Attack too: the Occultist's lineage attacks at **100** against a Cleric's 50 (§2c). |
| GP found EG's 53–55% offer-at-cap figure stale; HEAD read 73–74% | Held | GP §3c. |
| each card carries a line under the rune name — *Tank*, *Warrior engine*, *Ramp* | Held | `SPEC_INFO[lineage]["archetype"]`, or `"%s engine"` for a rune with no lineage, with `ARCHETYPE_DESC` as its tooltip (§1). |
| the kit appears once, below them, **with the class passive that is already there** | **DID NOT HOLD** | The class passive is ABOVE the cards, at y=110, and §3 of the brief keeps it there. The kit is below the cards; the two are not beside each other. |
| GP's pools are 34–41 deep | Held | 38 / 41 / 34 / 36. Nothing on this screen reads a pool. |
| GN found four of its twelve kit cards needed rewording | Held | GN's ruling 4: Nexus Ward, Tripwire, Consecration, Powershot. What the twelve read on this screen is §3. |
| **Vanguard, Invoker, Hierophant and the Hunter's three bring no enabler, so their cards are the engine rule alone** | **DID NOT HOLD as written** | The cards that are the rule alone are the three spines and **all nine** rule engines — the Warrior's, Mage's and Cleric's two apiece as well as the Hunter's three. And **"no enabler" is not the test**: Blood Frenzy, Heavy Plating and Trapper bring no enabler and still add cards (Wildstrikes and Hack and Slash; Shieldwall; Shrapnel Charge). **The test is the lineage.** |
| **`check_map_screen` and the class-selection gates read this surface** | **DID NOT HOLD for `check_map_screen`** | It seats specs by hand, sets `specs_chosen`, and never draws class selection. The screen's readers are `check_gn` §3 and `check_go` §1, which press its buttons, and `test_batch_bm`, `check_fd` and `check_em`, which read its source (§4c). |
| the queue stands (the Crown, the Bell, Elemental Weakness's 17, Nexus Ward, the kill credit, the rebalance, the 43 runes, the 52 gates) | Held | Every item is in `docs/state.md`'s queue, untouched. |
| the subtitle may render elsewhere | Checked: **it does not** | Swept over `scripts/` and `scenes/`: `archetype` and the blurb render only here. |
| no engine, kit card, magnitude or rule changes | Held | None moved. |

## §1 — THE SUBTITLE

**Where it came from.** `spec_choice_screen.gd` built it per card: `Classes.SPEC_INFO[lineage]["archetype"]` in bold,
with `Classes.ARCHETYPE_DESC` as its tooltip, and for a rune with no lineage the literal `"%s engine" % key.capitalize()`
— *"Warrior engine"*. Under it, the card's text opened with `SPEC_INFO[lineage]["blurb"]`.

**Where else it rendered: nowhere.** A sweep of `scripts/` and `scenes/` finds both fields read only by this screen.
**So removing them from this screen removes them from the game's screens**, which the brief's "this screen only" clause
anticipated for the other case. Both are removed.

**What stays.** `SPEC_INFO` keeps `archetype` and `blurb` byte for byte. **The archetype is not a display string**:
`Classes.spec_attack` reads it through `ARCHETYPE_ROLE` and `ROLE_ATTACK`, which is how the Warden's lineage attacks at
75 and the Occultist's at 100. `ARCHETYPE_DESC` and the twelve blurbs have no reader left in the game, and are kept
(FOUND AND NOT FIXED).

## §2 — THE KIT, ONCE, BELOW; EACH CARD, WHAT DIFFERS

### 2a. What the cards held, and the ruling it took

Before GQ each card listed the rune's whole opening kit — `Classes.opening_kit(class, lineage, [engine])` — under its
rule. Diffed against a hero holding no engine:

| | runes | what the card listed beyond the bare kit |
|---|---|---|
| **no lineage** | the 3 spines and the 9 rule engines | **nothing** — the rule, and the kit repeated |
| **a lineage** | the 12 spec engines | **1 to 5 abilities each, 37 in all**; four replace the class basic |

**The brief's instruction — the card is the rule and nothing else — would have deleted those 37 names from the screen.**
A player choosing Pack Bond could not have seen that it brings companions, nor a Mage that Overburn replaces Magic Bolt.
That is a player-visible reading of an ambiguous instruction, so it went to the designer as three options (the rule
alone; the rule and its enablers; the rule and what it adds) with a preview of each. **Ruled: the rule, and what it adds,
by name.**

### 2b. What was built

- **A card** is the rune's name, then `Engine: <rule>`, then — only for a rune that carries a lineage — one line:
  *"Also opens with: …"* naming, in the order the hero's bar holds them, the abilities his opening kit holds that a hero
  with no engine's does not. **Where the lineage's basic takes slot 0**, that card reads *"Fireball (in place of Magic
  Bolt)"*: the kit below shows the class basic, which that hero does not hold. The four: Fireball, Frostbolt and Arcane
  Explosion for Magic Bolt; Shadowrend for Smite. **Derived at draw time off the one kit builder the battle reads**, so
  a lineage that changes its kit changes its card.
- **The kit**, under the cards: a line introducing it, then the class basic and the three class-kit abilities in four
  columns, each printed exactly as the cards used to print them — name, damage range and scaling, description.
- **The class passive line and the screen's own subtitle** (*"Take one of three engine runes…"*, GK's proposed words)
  are untouched and where they stood.

### 2c. The figures, and the note

**The kit is priced at the class's own Attack** — `hero_config(class)["attack"]`: Warrior, Mage and Hunter 100, Cleric
50. That is the hero before he takes anything, the brief's basis, and the one Attack that belongs to no card.

**Two lineages set another Attack**: the Warden's (the Tank role, 75) and the Occultist's (the Pressure role, 100). **The
note is derived, not listed**: it names a dealt rune only if that rune's hero still holds a kit card whose line the new
Attack prints differently. That names the Warden — his hero holds Strike, Crushing Blow, Bloodlust and Mocking Blow, all
priced off Attack — and **not the Occultist**, whose hero raises Attack to 100 and holds no kit card with a figure: his
Shadowrend takes the place of Smite, and Ministration, Unburden and Consecration carry none. **"This rune changes Attack"
and "this rune changes a number on this screen" are different claims**, and a note keyed on the first would print on
ten Cleric deals where it is false; `check_gq`'s control B proves it does not.

**On all eighty deals the note stands on exactly ten** — the ten Warrior deals holding the Rune of the Warden.

### 2d. Does any card still scroll

**No.** Measured on the real screen, headless, with the game's own font, for all twenty-four runes:

| | before GQ | after |
|---|---|---|
| text window | 320 px | **280 px** |
| cards that scroll | **22 of 24** | **0 of 24** |
| the worst | the Beastmaster's, **by 877 px** (1,197 in 320) | the Beastmaster's is the tallest, **277 in 280** |
| the lowest line on any screen | the card's button, ~594 | **691 of 720** — a Warrior deal holding the Warden, whose note adds a line |

The window was sized against every rune's text rather than shrinking any of it. `check_gq` §4 re-measures all
twenty-four every battery and prints which scroll; a 200-pixel window, armed as a control, prints four
(the Cryomancer 37, the Devout 37, the Occultist 17, the Beastmaster 77).

## §3 — WHAT EACH CARD AND THE KIT BLOCK RENDER

Driven on the real screen for all four classes; every deal of three was drawn, and each rune's card reads the same in
every deal that holds it. **The rule is each rune's `passive_desc` or rule text, flattened**; below it:

| rune | the card below its name |
|---|---|
| Rune of the Berserker | **Also opens with:** Wildstrikes, Hack and Slash |
| Rune of the Warden | **Also opens with:** Shieldwall |
| Rune of the Swordmaster | **Also opens with:** Overpower, Pommel Strike, Guard Change |
| Rune of the Vanguard | *(the rule alone)* |
| Rune of the Reaver | *(the rule alone)* |
| Rune of the Bastion | *(the rule alone)* |
| Rune of the Pyromancer | **Also opens with:** Fireball (in place of Magic Bolt), Detonation, Wildfire, Flamewave |
| Rune of the Cryomancer | **Also opens with:** Frostbolt (in place of Magic Bolt), Razor Ice, Blizzard, Ice Lance |
| Rune of the Arcanist | **Also opens with:** Arcane Explosion (in place of Magic Bolt), Arcane Cannon, Arcane Barrage, Death Ray |
| Rune of the Invoker | *(the rule alone)* |
| Rune of the Weaver | *(the rule alone)* |
| Rune of the Leech | *(the rule alone)* |
| Rune of the Holy | **Also opens with:** Heal, Renewal, Hymn of Hope, Resurrection |
| Rune of the Devout | **Also opens with:** Divine Shield, Consecrated Ground, Blessing of Zeal |
| Rune of the Occultist | **Also opens with:** Shadowrend (in place of Smite), Hex of Ruin, Bewitch, Dark Pact |
| Rune of the Hierophant | *(the rule alone)* |
| Rune of the Oathkeeper | *(the rule alone)* |
| Rune of the Arbiter | *(the rule alone)* |
| Rune of the Beastmaster | **Also opens with:** Summon Ursus, Summon Canis, Summon Aguila, Hunter's Instinct, Kill Command |
| Rune of the Sharpshooter | **Also opens with:** Aimed Shot, Hold Breath |
| Rune of the Survivalist | **Also opens with:** Shrapnel Charge |
| Rune of the Tracker | *(the rule alone)* |
| Rune of the Skirmisher | *(the rule alone)* |
| Rune of the Medic | *(the rule alone)* |

**The kit block, once per class, at the class's own Attack:**

| class | the four columns |
|---|---|
| Warrior (Attack 100) | **Strike** 20–25 Physical (23%) · **Crushing Blow** 38–47 (43%) · **Bloodlust** 23–29 (26%) · **Mocking Blow** 24–30 (27%) |
| Mage (100) | **Magic Bolt** 22–28 Arcane (25%) · **Magic Burst** 36–44 (40%) · **Nexus Ward** · **Magic Missiles** 10–13 (12%) |
| Cleric (50) | **Smite** 19–24 Holy (44%) · **Ministration** · **Unburden** · **Consecration** |
| Hunter (100) | **Quick Shot** 18–22 Physical (20%) · **Powershot** 18–22 (20%) · **Snare Trap** · **Tripwire** |

Each column carries the card's description under its line, as the cards did. **Read on this screen, four of the twelve
kit texts break the text standard** — none of them GQ's to change, all recorded in FOUND AND NOT FIXED: Ministration's
*"No stacks, no shields, no marks — it simply works"* and Magic Missiles' *"Cheap, certain, and it never needs anything
to be true first"* are design rationale on a card; Magic Missiles restates *"12% of Attack each"* beside the damage line
that prints it; and **Nexus Ward's and Ministration's 20% are plain text rather than tokens**, so no surface in the game
resolves either to a number.

**Looked at, not only read.** Four screens were rendered windowed at 1280×720 in an isolated copy and inspected —
the Warrior's (Berserker, Warden, Vanguard: the note stands), the Mage's (Pyromancer, Cryomancer, Weaver), the Cleric's
(Hierophant, Devout, Occultist) and the Hunter's (Beastmaster, Sharpshooter, Medic). Nothing overlaps; the one fault
they showed, the kit's four columns centred on one another in a row as tall as the longest, was fixed by
top-aligning them before the gate was written. They are not committed.

## §4 — A DEAL HOLDING A SPINE, AND THE INSTRUMENTS

### 4a. The spine deal

**It works.** `check_gq` §5 deals every hero a rune with no lineage beside two that carry one and presses the real
buttons: the Warrior takes the Warden (so the lineage path and the note's screen are both pressed), the Mage the
Invoker, the Cleric the Hierophant, the Hunter the Medic. The screen moves hero by hero and lands on the map, each hero
holding what he took and the lineage it carries. **`check_gn` §3 and `check_go` §1 — HEAD's own drives of a spine and a
rule engine taken at class selection and carried into the first battle — ran unmodified against the new screen and
passed** (§4c).

### 4b. The new gate

**`check_gq.gd`, 5,112 checks.** §0 derives what each of the 24 runes adds over a hero holding no engine, and asserts a
rune adds something exactly when it carries a lineage, and that the one bare card a rune can take away is the class
basic, replaced in slot 0. §1–§4 and §6 draw **all eighty deals** — twenty of three from six, per class — and read
each: three cards, each its rune's name and one body; the body its rule and exactly what the rune adds, derived off
`Classes.opening_kit` and not off the screen's helpers; no archetype line, no blurb, no ability line or figure on any
card; the kit once below the cards at the no-engine figures and the same on every deal of a class; the class passive
where it stood; the note on exactly the deals that move a figure, naming the rune and its Attack; the lowest line and
every button inside the screen; and the screen's own new words free of pronouns, of *party* and *beast*, and of the nine
internal engine names in any inflection. §5 is the spine deal, pressed. §7 is the player's three files, byte for byte.

**ARMED BEFORE IT WAS TRUSTED — against HEAD's own screen and nine targeted injections, in an isolated copy renamed so
its `user://` could not reach the player's saves:**

| the injection | reads | where |
|---|---|---|
| HEAD's own screen | **2,402 / 962** | §1 on every card; §2 on every screen; §3 on the ten Warden deals |
| the archetype line put back | 2,592 / 491 | §1 — every archetype word, and *"Warrior engine"* on every rune with no lineage |
| a kit card put back on every card | 5,352 / 1,040 | §1 — the ability line, the figure, the repeated description |
| the kit priced at ¾ Attack | 5,112 / 80 | §2 on every screen |
| **the note keyed on "Attack differs" alone** | 5,132 / 10 | **§3 on exactly the ten Cleric deals holding the Occultist** |
| the note removed | 5,082 / 10 | §3 on the ten Warden deals |
| the *in place of* clause removed | 5,112 / 80 | §1 on the four replacing runes' cards |
| a 330-pixel window | 5,112 / 10 | §4 — the Warden deals end at 741 px |
| a pronoun in the kit's line / an internal engine name in the card's | 5,112 / 80 and 240 | §6, and §1's exact reading |

A 200-pixel window turns nothing red and prints four scrolling cards — the census measures, and asserts nothing, by
design (§2d).

### 4c. The unmodified gates against the new screen

**Run before any gate was edited, as the brief required: the whole battery, against the tree with the new screen and
nothing else changed.** **114 targets, 55 minutes, and `check_de` read 473 checks / 0
failures / 0 notices** — no count moved and no target went red but the two standing sanctioned ones, `check_cm_live`
13 / 4 and `check_gj` §4's Bell (whose printed figures are corrected below). **Every reader of the screen passed
unchanged:** `check_gn` 197 / 0 and `check_go` 401 / 0, which press its buttons through a spine and a rule engine into
the first battle; `test_batch_bm` 773 / 0, which pins `Run.awaken(idx, rune_id)` in its source; `check_fd` 51 / 0,
which asserts it grants no rune; and `check_em` 416 / 0, which sweeps it for rune fields. **So no instrument owed a
repair, and none was edited.** The run was one ascending sequence in the runner's order, no name twice; the tree was
stamped by md5 before it (556 files, absolute paths, untracked included) and was byte-identical after; the streams
carried no parse or script error.

**AND THE PASS WAS TAKEN A SECOND TIME ONCE THE NEW GATE WAS IN THE TREE**, because a new instrument can trip another
gate's sweep of the instruments (FF's lesson). The eleven targets that read other instruments' sources —
`check_parse`, `check_da`, `check_ea`, `check_ec`, `check_ed`, `check_ek`, `check_fm`, `check_ff`, `check_eh`,
`check_fn` and `test_batch_cd` — and the four that read the edited documents' pins and sizes (`check_fr`, `check_fg`,
`check_es`, `check_dv`) read exactly their rows with `check_gq.gd` and the new documents present, **except
`check_parse`, 188 → 189: the new gate joining the population it parses**, the one move this batch predicted and
wrote. The twenty-three suites that read `master.html`, the changelog, the design notes, the text standard or
`docs/state.md` read every count they read on the recon. **`pin-manifest.json` regenerates byte-identical.**

## VERIFICATION

**THE ACCEPTANCE RUN IS GREEN.** 115 targets in 55 minutes, **`check_de` reading 477 checks / 0 failures / 0
notices** — every row this batch moved is recorded with its reason and no count drifted unrecorded. `check_gq` read
5,112 / 0. **The only two reds are the standing sanctioned ones:** `check_cm_live` 13 / 4, unchanged since before GK,
and `check_gj` §4's Tollkeeper's Bell, at the corrected +172 / +192.

**THE ORDER.**

1. **The four player saves backed up and verified by hash before a line was written** —
   `save-backups/GQ-20260918-105750` — and read back by hash after the recon, after the standalone readings and after
   the acceptance run: unchanged every time. (The designer had played that morning: the profile and the run save were
   newer than GP's backup.)
2. **The brief checked against the repo before anything was edited** (§0), and **the one player-visible ambiguity it
   left went to the designer as three options with previews** (§2a) before the screen was finished.
3. **The screen built and looked at**: probes that draw it and dump every label, then windowed renders of four deals
   in an isolated copy renamed so its `user://` could not reach the player's saves. One layout fault found there was
   fixed (§3).
4. **The unmodified battery against the new tree, before any gate existed or was edited** (§4c): 114 targets, green
   but for the two sanctioned reds. No instrument owed a repair.
5. **The new gate written and armed in the copy** — HEAD's screen and nine targeted injections (§4b); **the documents written as staged copies and swept
   for every string literal in every gate and suite**, before against after: `master.html`, the changelog, the design notes
   and the text standard lost none; `docs/state.md` lost eight with GP's WHERE block and the screen's source eight
   short words, and **no reader of either file pins any of them**; every literal gained was checked against the readers
   of the file that gained it. **Each file was landed by copy only onto a repo file whose hash had not moved since it
   was staged.**
6. **The second pass with the new gate in the tree** (§4c), the standalone readings the new baseline rows rest on
   (`check_gq` 5,112 / 0 and `check_parse` 189 / 0, each read in the copy and again in the tree), and **the baselines
   written before the run.**
7. **The acceptance battery, over a tree stamped by md5 before it** (557 files, absolute paths, untracked included)
   **and byte-identical after it**; one ascending sequence in the runner's order, no name twice, and no parse or
   script error in any stream.
8. **`ps` rows read after it, not a count**: no Godot and no battery running.

**WRITTEN AFTER THE RUN, AND WHY THAT IS SAFE.** This report, which nothing in the tree reads; `docs/state.md`'s
VERIFICATION bullet, which gained the verdict; and one sentence in each of `docs/state.md` and `baselines.json`'s
`check_gj` note, which said the Bell's figure held over "three runs each" when it was read once on GP's code and four
times on GQ's. **Each was proved against its reader rather than assumed harmless:** `docs/state.md` is read by
`check_es` §4 alone, through its "2+ threshold" windows, and `check_es` re-run over the final file prints exactly what
it printed in the battery; `baselines.json` is read by `check_de`, which re-read the acceptance run's own logs against
the final file and printed exactly what it printed in the battery, 477 / 0 / 0. The literal sweep moved on neither.

## FOUND AND NOT FIXED

- **PLAYER-FACING, AND MET ON THIS SCREEN FIRST: FOUR KIT TEXTS BREAK THE TEXT STANDARD** (§3). Ministration's and
  Magic Missiles' closing sentences are design rationale on a card; Magic Missiles restates *"12% of Attack each"* beside
  the line that prints it; **Nexus Ward's *"20% of the Mage's maximum health"* and Ministration's *"20% of THEIR maximum
  health"* are plain text, not tokens**, so the hero sheet and the battle tooltip — which resolve a token to its value —
  print the bare percentage there too. A kit card's text is outside GQ.
- **`Classes.ARCHETYPE_DESC` AND THE TWELVE `SPEC_INFO` BLURBS HAVE NO READER IN THE GAME NOW.** Kept, not deleted: a
  structure orphaned by a ruling is a design question, not dead code (`CLAUDE.md`, DV §1). The archetype field itself
  is live — it sets a lineage's Attack.
- **`CLAUDE.md` IS 348,868 B = 340.69 KiB, OVER ITS 340 KiB CEILING SINCE GP** (GP added 3,894 B from 344,974).
  `check_fg` §2 prints its CEILING WARNING and passes; it FAILS past 348.10 KiB (356,454 B), **7,586 B away — less than
  one large batch's rules**. `docs/state.md` carried the subject seam as *"owed a ruling before the file reaches 340
  KiB"*; it has reached it. GQ added nothing to the file.
- **THE HUNTER'S CLASS PASSIVE AND A HUNTER RUNE ARE BOTH *TRACKER*,** and on a deal holding the Rune of the Tracker the
  two stand one above the other — the passive line over the cards and the rune's card. GO's ruling 2, re-observed and
  unchanged.
- **`check_gj` §4's SANCTIONED RED READS CARD +172 AGAINST A PURSE OF +192**, not GP's recorded +177 / +197 — on GP's
  own code and on GQ's alike: once on GP's, in an isolated copy, and four times on GQ's (the recon, twice in the copy,
  the acceptance run), identical every time. The gate never draws class selection, so GQ's code is not on its path. **The figure GP wrote does not reproduce on the commit that recorded it.** The gap is still the
  Bell's 20 gold and the counts row did not move; the figure is corrected in `baselines.json`'s note and in
  `docs/state.md`.
- **FOUR OF THE BRIEF'S PREMISES DID NOT HOLD, AND ONE HELD ONLY IN EFFECT** (§0).
- **ONE CONTROL COPY LEFT A USER-DATA FOLDER** under Godot's `app_userdata`: "Dawn of Decay GQ ctl". It was renamed
  before anything ran in it, so its `user://` could not reach the player's saves. It can be deleted.
