# Batch GF — A quit puts the heroes back where they were standing

*Branch `class-merge`, from `ac33c1b` (GE); `git ls-remote origin class-merge` read `ac33c1b` before the push.
`main` (`3b80fbe`, the merge-base) is untouched.*

## NEEDS A RULING

1. **A QUIT INSIDE A FIGHT RESTARTS IT.** The battle itself is never saved, so a fight resumed after a quit opens from
   its beginning: the same warband, the same bargain, the party's health as it stood when it stepped on, and nothing
   paid until the fight is won. A player can therefore abandon a losing fight and start it again as often as they
   like. It is strictly less than before GF, when the quit skipped the fight and kept the health. **Whether a quit
   should cost more than a restart is the designer's.** Saving a fight in the middle was not attempted.
2. **THE END BOSS HAS NO BUTTON, AND ITS FIX NEEDS WORDS THE PLAYER READS** (§1e; found at GF, not fixed, first in the
   queue). The fix is the map's loop reading the board's own size, plus a node label and a tooltip: `NODE_LABELS` has no
   `endboss` row and `_node_tooltip` has no branch for it, so the default would print *"Encounter 17 of 16"*.
3. **`main` STILL CARRIES THE DEFECT, AND NOTHING ON `main` SAYS SO.** The brief asked for it to be recorded as `main`'s
   so it is not lost if the branch is abandoned. It is recorded as `main`'s on this branch — here, in `docs/state.md`,
   in the changelog and in `CLAUDE.md`'s new rule — and no batch writes to `main` before the merge lands. **Whether a
   note, or the repair, should go to `main` now is the designer's.**
4. **THE ZONE BOSS FOUGHT IS NOT ALWAYS THE ONE THE GAME NAMES.** The Hollow Crown, the end boss's kind, carries the
   `boss` role and `"zones": [1, 2, 3]`, so a zone boss node can compose it, and zone 1's did in GF's drives. The run
   summary now names the boss that was on the field (§3b); the map's header and `Profile.note_boss` still name the
   zone's. Whether the end boss's kind belongs in the zone rosters is content.
5. **TWO GLOSSARY STATUSES NOTHING CAN APPLY.** Decay and Elemental Weakness are described as live, and each one's
   applier depends on a field nothing writes; Melted Armor's and Caught Fast's entries say that of themselves. A note is
   content (§3d).

## THE SHORT VERSION

- **§1 — DRIVEN AT NINETEEN QUIT POINTS THROUGH THE REAL SCREENS, AS A REAL QUIT, AND THE SEVENTEEN DRIVEN ON BOTH
  BRANCHES READ THE SAME ON `main` AS HERE, TO THE GOLD PIECE.** The defect is `main`'s and older than the merge:
  `save_run` and `load_run` are the same code on both branches and `main_menu.gd` is byte-identical.
- **§1 — WHAT IT IS.** The step onto a node — visited, and the position moved — is taken at the click and saved at
  once, by design. The unfinished step was never in the save: the encounter, the bargain rolled for it and the one
  taken, the event drawn. `load_run` set all of them to nothing and Continue always opened the map, so **the resume
  landed past the node.** Nothing marks a node cleared; there is no such state.
- **§1 — WHICH OFFERS.** The **bargain** is the one offer lost, at an elite and at a mini-boss. The **draft**, the
  **rune cache**, the **mini-boss's upgrade** and the **zone boss's ability pick** all survive a quit, because each rides
  the party, which is saved whole — the last on a board with nothing to press.
- **§2 — THE REPAIR.** The run save is v13 and carries the step in flight; `Run.resume_scene` is the one place a
  resumed run is placed; `claim_reward` marks the encounter resolved before any victory's first save, so **a won fight
  can be neither fought nor paid twice.** v13 is tolerant, and the refusal threshold stays at 10.
- **§3 — THE FOUR TEXTS, EACH SURFACE SWEPT:** the zone boss's card, the run summary, the fight recap's five costs,
  and the glossary read whole — 745 claims, 95 stale in 46 entries — with the chips, the first-run card and
  `docs/master.html`'s copies.
- **§4 — NOT DONE, AS RULED.**
- **VERIFICATION** is below.

## §0 — THE BRIEF'S PREMISES

Each was checked against the repo, the reports and the code before anything was edited.

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD was `ac33c1b` (GE), and `origin/class-merge` read the same |
| 2 | *"GB found it … GB found it in play"* | **NOT AS STATED — GB WORKED IT OUT FROM THE CODE** | HEAD's `docs/state.md` files it under GB's findings as *"Worked out from the code at GB, not driven. GC read the sites it rests on on `main` too, and they are the same, so it likely predates the merge; driving it is the next batch's."* `docs/reports/GB.md` does not mention it. GF is the first batch to drive it |
| 3 | *"the only one of the five queued player-facing items that costs the player an encounter"* | **HELD** | The other four were the texts §3 corrects |
| 4 | *"Nothing in the merge has touched the save or resume path"* | **HELD FOR THE CODE** | `save_run` and `load_run` differ between `main` and `ac33c1b` in comments only — zero code lines — and `main_menu.gd` is byte-identical. The drives are the proof (§1) |
| 5 | *"the tree merged while specs still existed, and the spines are attached to nobody"* | **HELD** | FX's one class tree under twelve live specs; FT's three spines are machinery on nobody, and `check_ft` §0 asserts it |
| 6 | *"GE found the Focus pricing my brief credited to GC is not in GC's report, and that GC's own claim about `master.html` carrying a sentence was wrong"* | **HELD** | `docs/reports/GE.md` §0, rows 2 and 16 |
| 7 | *"the last four player-visible defects in this project were all found by a person playing and none by a battery"* | **NOT CHECKED** | No document keeps that count. This batch's defect was found by reading code (row 2); the end boss's missing button (§1e) was found by GF's drive, not by a battery |
| 8 | *"FD found the elite cache rolls at the drop and answers a node later"* | **HELD** | `CLAUDE.md`'s FD §1 block: the triple rides `member["rune_candidates"]`, which is why the cache survives a quit (§1) |
| 9 | *"`run_state.gd` refuses below its threshold"* | **HELD** | A save below version 10 is refused and cleared |
| 10 | *"FQ built `Profile`'s guard for exactly this class of change"* | **HELD** | `docs/reports/FQ.md`: `_load()` refuses a version below `MIN_VERSION` or above `VERSION` |
| 11 | *"A migration that silently defaults is the failure FQ measured: `cells_spent 0`, `equipped_learned` empty, `owns_cell` still true"* | **HELD, AS FQ'S MEASUREMENT** | FQ's premise table carries it as TRUE. `equipped_learned` itself was deleted at FX |
| 12 | *"A zone boss's victory text says each spec banks a talent point. Specs do not bank anything since FX."* | **HELD** | HEAD's card: *"Each spec that walked this road banks 1 talent point."* The purse is the class's since FX |
| 13 | *"The run summary shows 'Tier N of 10'."* | **HELD** | HEAD: `"Tier %d of 10" % mini(int(snap["tier"]), 10)`, on zones of sixteen encounters |
| 14 | *"The glossary's item entry says 'Five items' and gives the old fixed amounts. CT moved the pouch to slots and percentages."* | **HELD** | HEAD's `consumables` entry: *"Five items … Health Potion (40 HP), Mana Potion (40 Mana or Rage), Bomb (50 damage to all enemies) … Loot nodes, shops, and elite spoils refill the satchel."* There are eight items, the heal and the Mana are percentages, the Bomb scales with wins, and loot nodes went at AN |
| 15 | *"The fight recap is missing five health costs."* | **HELD** | Phoenix Rebirth, Dark Pact, Blood Offering, Blood Price and Shared Grief remove the caster's health directly, below the one door the recap's ledger hangs off, and `CLAUDE.md`'s BL §2 block named them as reporting nothing |
| 16 | *"GB found 521 stale claims of 2,764 across three files where the brief named three."* | **HELD** | `docs/reports/GB.md` §4a: 2,764 claims, of which 223 gone, 94 moved and 204 figures are stale |
| 17 | *"`relics.gd`'s header claiming every hook is read at one site"* | **NOT TOUCHED, AS RULED** | GE §0 row 18 measured six of its 18 hooks read at two to four sites |
| 18 | *"two screen tests were overwriting `profile.json` for many batches before FX caught it"* | **HELD** | `docs/reports/FX.md`: two gates had re-saved the designer's profile idempotently for many batches, and FX's fold made it destructive |

## §1 — REPRODUCED, AS A REAL QUIT, ON BOTH BRANCHES

### 1a. How it was driven

A scratch driver, not in the tree, plays a run through the real screens — the main menu, the draft, the awakening, the
map, the offer, the battle, the event, the shop — with the bot taking the hero turns. It presses each node through its
lattice button. At the quit point it prints the live state and the save on disk, and then the process dies: **no script
in the game hooks the window's close request**, so a killed process is the same event for the save as a closed window.
A second, fresh process presses Continue on the real main menu and prints where the run lands. The battle's own ☰ *Exit
to Main Menu* was driven in one process, with Continue pressed after it.

Every drive ran in an isolated copy whose `config/name` was renamed, so `user://` was never the player's: `ac33c1b` in
one copy and `main` in another, seed 7 at every point, and seeds 7, 11, 13, 17 and 23 for a merchant bought by a
bargain on `main`. **Nineteen quit points; seventeen driven on both branches, and those seventeen read identically on
both** — position, gold, health, wins and every owed pick.

### 1b. What each quit point did

| Quit point | Save at the quit | Continue opened | The encounter |
|---|---|---|---|
| An elite's bargain | v12; the elite visited and the position on it; no encounter, no bargain | the map, the next column pressable | **walked past**, with its rewards |
| A mini-boss's bargain | the same | the map | **walked past** |
| A fight, window closed mid-fight | the same | the map | **walked past** |
| A fight, the battle's ☰ *Exit to Main Menu* | the same | the map | **walked past** |
| An elite, mid-fight, bargain taken | the same; the bargain taken is not in it | the map | **walked past**, bargain and all |
| A mini-boss, mid-fight | the same | the map | **walked past** |
| An elite's victory card | the win paid and saved; a draft owed every hero, a rune pick owed one | the map, the draft overlay open | survives |
| The draft overlay | the same | the map, the overlay open | survives |
| The rune cache | a rune pick owed | the map, the pick owed | survives |
| A mini-boss's victory card | an upgrade pick owed every hero | the map, the picks owed | survives |
| A zone boss, mid-fight | v12; the boss visited | the map, **nothing pressable** | **stranded** |
| A zone boss's victory card | the win paid; an ability pick owed every hero | the map, **nothing pressable** | the pick survives, **stranded** |
| Zone 3's boss, mid-fight or on its card (`main` drove the card) | the same | the map; the end boss is reachable and has no button (§1e) | **stranded** |
| The end boss, mid-fight | the same | the map, nothing pressable | **stranded** |
| An event | the event node visited; the event drawn is not in it | the map | **walked past** |
| A merchant | the merchant visited | the map | **walked past** |
| The forge | the forge visited | the map | **walked past** |
| A won fight whose bargain bought a merchant, quit on its card (`main`, five seeds) | `pending_shop` true | the map, the merchant still owed | not visited on resume |

The end boss has no lattice button (§1e), so the driver reached it through the map's own node handler.

### 1c. The three readings the brief asked to tell apart

*"Is the node marked cleared, is the map advanced, or does the resume simply land past it?"*

- **Marked cleared: no.** Nothing marks a node cleared, and there is no such state.
- **The map advanced: yes, and by design.** `Run.advance` marks the node visited and moves the position the moment it
  is pressed, and the node's save writes both. That is the commitment to the route, and the fight's own scaling reads
  the position.
- **The resume lands past it: yes — this is the defect.** The record of the unfinished step — `encounter`, the bargain
  in `pending_modifier` and `pending_reward`, and `pending_event` — was never written to the save; `load_run` set all
  four to nothing; and `main_menu._on_continue` opened the map whatever the save held. At a zone boss the same landing
  strands the party, because the boss's column is the last on the board and only the boss's victory button descends.

**Which offers are affected.** The bargain is the only offer that is lost, and it is lost at both nodes that offer one.
Every post-fight offer survives, because each is a member key — `draft_candidates`, `rune_candidates`,
`up_candidates`, `bm_candidates` — and the party is saved whole: the draft overlay reopens, the rune pick and the
upgrade pick stay owed, and the zone boss's ability pick stays owed on a board the party cannot leave.

**`main`.** Every point driven on both branches reads the same, and the save and resume code is the same code. **The
defect is `main`'s and predates the merge.** It is repaired on `class-merge` only (NEEDS A RULING, item 3).

### 1d. The same drives on the repaired tree

The nineteen quit points again, against the final tree in an isolated copy — seed 7 at every point, and seeds 7 and 13
for the bought merchant: 21 pairs of processes, and no error line in any of them.

| Quit point | Save at the quit | Continue opened |
|---|---|---|
| An elite's bargain | v13; the encounter and its three bargains | **the elite's bargain**, the same three |
| A mini-boss's bargain | the same | **the mini-boss's bargain** |
| A fight, window closed mid-fight | v13; the encounter, not resolved | **the same fight**, gold unpaid, health as at the step |
| A fight, the battle's ☰ *Exit to Main Menu* | the same | **the same fight** |
| An elite, mid-fight, bargain taken | the encounter, its bargains and the one taken | **the same fight**, the bargain with it |
| A mini-boss, mid-fight | the same | **the same fight** |
| An elite's victory card | the encounter resolved | the map, the draft overlay open |
| The draft overlay | the same | the map, the overlay open |
| The rune cache | the same | the map, the pick owed |
| A mini-boss's victory card | the same | the map, the picks owed |
| A zone boss, mid-fight | the encounter, not resolved | **the boss fight** |
| A zone boss's victory card | the encounter resolved | **the next zone**, its first column pressable |
| Zone 3's boss, mid-fight | not resolved | **the boss fight** |
| Zone 3's boss's victory card | resolved | the map with nothing to press — the end boss's missing button (§1e), not the resume |
| The end boss, mid-fight | not resolved | **the end boss** |
| An event | the event drawn | **the event** |
| A merchant | nothing pending | the map: walked past, as queued (§2d) |
| The forge | nothing pending | the map: walked past, as queued |
| A won fight whose bargain bought a merchant, quit on its card (two seeds) | resolved, and the merchant owed | **the merchant** |

`check_gf` asserts the same landings inside one process, and what each one carries: the same warband and the same
bargain, gold and wins paid once, and every owed pick unchanged.

### 1e. Found while driving it: the end boss has no button

`map_screen._draw_lattice` draws `for s in Run.SLOTS_PER_ZONE` — sixteen columns — and the end boss is the final zone's
seventeenth slot (`END_BOSS_SLOT`, appended by `_generate_map`). After the third zone boss's *"Walk on"*,
`Run.reachable()` returns the end boss and the map draws no button for it: the edge to it is drawn, because the edge
loop reads `map[s + 1]`, and the node is not. Driven on both branches, with a quit and without one. The loop is BK's
and the end boss is BM's, so a player's run has ended at the third zone boss ever since — and beating the end boss is
the only thing that opens a talent tier (EN §3). No battery saw it: `check_fh` §1 completes runs by calling
`_on_node_pressed` directly, and the map gates draw the screen without pressing the column it lacks. It is one defect of
its own and the next batch; GF repaired one.

## §2 — THE REPAIR, AT THE ONE PLACE A RESUME IS DECIDED

### 2a. One site

**`Run.resume_scene()` is where a resumed run is placed**, and `main_menu._on_continue` opens it in place of the map.
It reads, in order: an event drawn and not answered → the event; an encounter not resolved → its bargain, if it is a
bargain node and none was taken, and otherwise the fight; a merchant a bargain bought → the merchant, visited once and
saved; a non-final zone's boss column → the next zone, descended once and saved; otherwise the map.

What it reads is written where the step is decided, not by the screens:

- **`encounter`** is set where the node is stepped onto, as it always was, and is saved now. It carries **`offer`**, the
  three bargains, frozen on first sight by `Run.encounter_offer`; **`bargain`**, the one taken, recorded by
  `accept_offer`; and **`resolved`**, marked by `claim_reward`.
- **`pending_modifier`** and **`pending_reward`**, the bargain's terms, and **`pending_event`**, the event drawn, are the
  fields they always were, saved now.

The offer screen's one change is to ask `Run.encounter_offer()` rather than roll. That is FD §1's rule one door along: a
screen that rolled on every open would make a quit a reroll of the terms. `roll_offer` stays a pure roll, because the
suites sample it. `battle._resolve_boss` now saves after the award unconditionally — it saved only when a pick was
made — so the resolved mark reaches the disk even when no hero is paid a pick. `Run.BARGAIN_NODES` names the two
bargain nodes once, and the map reads it.

### 2b. What the save needed, and the version

**Four keys, and the version moves: v12 → v13.** The file carries new fields, so it is a new version.

**v13 IS TOLERANT, AND THE REFUSAL THRESHOLD STAYS AT 10.** `CLAUDE.md`'s rule is that the threshold is a claim about a
structure this build cannot walk, and a field with a sane default is not one. There is still no ceiling, so a v12 build
reading a v13 file ignores the four keys and loses only the record.

**AGAINST FQ'S FAILURE.** FQ's migration produced a profile that looked valid while asserting what the file never held:
`owns_cell` true for cells no tree carried. A v12 run save holds no record of an unfinished step because v12 never
wrote one, so an empty record is the truth about that file, and it resumes exactly where a v12 build resumed it — past a
pending fight, which nothing in the file can recover. **The one place that default would strand the party is decided
explicitly: a non-final zone's boss column descends.** A v12 file cannot say whether the boss fell, and re-fighting a
boss that did fall would bank its point and its relic twice, so a v12 save quit inside a zone boss descends without the
fight. `check_gf` §7 asserts all three arms: the control at v13, v12 to the map, and v12 on a boss descending.

### 2c. The inverse

*"Quit, resume, fight it, quit again, fight it again. Report whether that is possible and prove it is not."*

- **A fight quit before it is won restarts as often as it is quit.** That is possible, and it is the design question in
  NEEDS A RULING, item 1: nothing is paid until the fight is won.
- **A fight that was won can be neither fought nor paid again.** `claim_reward` is where every victory passes, and it
  marks the encounter resolved before any victory's first save; `resume_scene` never re-enters a resolved encounter;
  and a wipe or a forfeit clears the save outright.
- **Proved by `check_gf`, through the real screens and the real Continue.** A plain fight quit twice, once through the ☰
  and once as a closed window, opens the same fight each time with no gold paid; won and then quit, it opens the map
  with gold and wins paid once, the encounter no longer pending, and the nodes pressable. An elite won and quit on its
  card opens the map with its draft overlay and rune picks as they were, not doubled. A zone boss beaten on its card
  descends once, and a second quit does not move the party again, because the descent was saved. **HEAD's code read 42
  failures of the same 98** (Verification).

### 2d. What a resume does not re-enter

**The Peddler and the forge.** Both roll their stock in their own `_ready`, so re-entering either on resume would make a
quit a reroll of the shop, and freezing the stock is a change to two screens, which the brief ruled out. A quit in the
middle of either still loses the node. Queued.

**THE RULE IS IN `CLAUDE.md`**, as *A STEP IN FLIGHT RIDES THE SAVE, AND A RESUME PUTS THE PARTY BACK IN IT (Batch
GF)*, beside the frozen-offer rule it extends. The `VERSIONS` bullet names v13 and extends the tolerance sentence.

## §3 — THE FOUR TEXTS, EACH SURFACE SWEPT

### 3a. The zone boss's victory card

*"Each spec that walked this road banks 1 talent point"* reads *"Each class that walked this road banks 1 talent
point."* The same card's *"NEW ABILITY: %s may choose one of three"* and the mini-boss's *"ABILITY UPGRADE: … one of
three"* lose the figure — both awards can offer fewer (FM §3), and the offer shows its own count. `_resolve_boss`'s
header comment says the award is per class and names the fallback chain. **The master document's copies of what a
victory pays in talent points went with it**: the victory-rewards paragraph, the mini-boss, the elites paragraph, the
finale and zone completion said a point on an elite, a mini-boss or a boss; only a zone boss banks one. Its four
*"three offered"* became *"up to three offered"*.

### 3b. The run summary

*"Tier N of 10"* reads *"encounter N of M"*, with M the board's own size, as the map says it. A zone boss is named from
the warband that was on the field (`_boss_in_warband`), not from the zone's table. The end boss is named, and its kind
reads *"The END BOSS"* rather than *"A fight"*. The economy lines counted mini-bosses as elites and sales as combat gold:
they now read *"Battles won: N of M   Elites and mini-bosses taken: K"* and *"Gold: N earned in fights, bargains and
sales, N spent at shops and the forge, N unspent"*, which is what their counters hold. The master document's copies lose
the rests the game no longer has.

### 3c. The fight recap

The five direct costs book through **`_book_self_cost`**, which frames the payer and the card around one booking,
books the ledger through the same body `_on_damage_taken` uses, and restores the frame it found. It reaches the
recap's ledger and nothing else, so none of the five feeds an on-damage rider, as `CLAUDE.md` requires. Self-inflicted
is still decided by identity, so all five read as the hero's own. It books nothing for a companion or in a sim, which
is where the ledger itself books nothing. `CLAUDE.md`'s BL §2 block says so now: a new direct cost calls
`_book_self_cost`.

### 3d. The glossary, read whole

The brief named one entry. **Every claim in all 98 entries was read against the code**, in four slices, each claim
with the file and line that settles it:

| claims | hold | gone | moved | figure | wrong | unverifiable |
|---|---|---|---|---|---|---|
| **745** | **641** | 11 | 3 | 24 | 57 | 9 |

**95 stale claims, in 46 entries, corrected toward the code** — the list of 46 is the diff. The item entry names all
eight items, their percentages, and where each works: only the Health, Mana and Revive potions work on the map, and a
Mana Potion restores no Rage there. Among the rest: the Ruin mark can be stripped, Resonance stops at 99 and a third
card takes it away, Deadfall springs four times, Arcane Arrows banks six charges, the Empower key is C, Feint's two
branches were described the wrong way round, a wipe keeps your talents, a benched card stays yours, only a Perfect
Pommel Strike stuns an unbroken boss, the difficulty entry names the three rungs, and a run is 49 encounters with the
end boss last. **Where the thing described is gone** — loot nodes, talent points from elites, tag-reading runes, a
second companion, a spec playing *Rush* — **the claim is deleted rather than rewritten**, DR's rule.

**Left as they are:** the nine claims no code can settle, which are intent (the class-wide cards being weaker on
purpose, among them); Decay and Elemental Weakness with no note (NEEDS A RULING, item 5); and the group words card and
chip text still use (*"the line"*, *"everyone"*) — the glossary no longer says they are gone, and the cards are
authored text.

### 3e. The same claims on other surfaces

- **The chips:** Ruin (*"No ceiling, does not wear off; detonates every 10th stack"*) and the Umbral Sigil.
- **The first-run card:** it said an elite pays a talent point; it pays a draft pick and a rune.
- **`docs/master.html`**, every copy of a corrected claim: Ruin twice (the status table and the Occultist's passive) —
  no maximum, does not wear off, and the four things that take it away; Resonance twice — no practical maximum, the
  meter stops at 99, and three earned cards take it away, Threshold with the two it already named; six elites stand in
  every zone; Arcane Arrows forks six hits; only Pommel Strike's Perfect lands a Stun on an unbroken boss, and neither
  Snare Trap nor Deadfall has a Perfect to promise one; and the spec roles no longer include *Rush*. Its saving and
  burger bullets describe the repair, the relic plan no longer claims v13, and the stamp is GF's.
- **`classes.gd`:** the Berserker's protected-core `why` — an internal string — no longer cites a deleted node.

**Two surfaces were left, because neither is player-facing:** `CLAUDE.md`'s governor table still calls Resonance
uncapped with two removers and Ruin never-clearing, and three comments carry the old figures — the one above the
Arcanist's `second_max = 99`, the header of Runaway Resonance's first clause, and Arcane Arrows' handler, beside an
unread `ARCANE_ARROW_CHARGES` of 5. Queued in `docs/state.md`.

## §4 — NOT DONE, AS RULED

- **No merge work.** Engines-to-runes is next.
- **`relics.gd`'s header stays queued**, and the relic redirect stays deferred.
- **No node, rune, magnitude or engine moved.** `data/runes.json`, `data/enemies.json`, `scripts/talents.gd`,
  `scripts/relics.gd` and `scripts/unit.gd` are unchanged, and no number moved in the scripts that were edited.

## FOUND AND NOT FIXED

Each is in `docs/state.md`'s queue, with its evidence:

- **The end boss has no button** (§1e) — first in the queue, and the next batch.
- **A Peddler or a forge quit in the middle of a visit is still walked past** (§2d).
- **The zone boss fought is not always the one the game names** (NEEDS A RULING, item 4).
- **`docs/master.html`'s debug paragraph** still names a rest summon and *"Jump to Boss Tier"*.
- **A mini-boss can award an upgrade the forge already put on the same ability.** `roll_upgrade_offer` drops an upgrade
  only through `has_upgrade`, which ignores a bought entry on purpose, and then pairs it with any ability it fits, the
  forged one included. The forge's own roll refuses that pairing, so *never twice on one ability* holds from one side
  only, and six of the eight upgrades stack when stamped twice (FE §2). Read in the code, not driven.
- **The rule and the comments of §3e**, and **the glossary census's leftovers of §3d**.
- **No spec plays the *Rush* archetype**, which `Classes.ARCHETYPE_DESC` and `docs/master.html` §6's table still define.

## VERIFICATION

### The parse floor

`check_parse` reads **183 checks / 0 failures**, and its stderr carries no `Parse Error`, `Compile Error` or `SCRIPT
ERROR` line — read after the last code edit, Shared Grief's booking. It was 182 at GE; the one is `check_gf.gd`.

### `check_gf`, and the HEAD control

**NEW, 98 checks.** It quits at every branch of `resume_scene` through the real screens — the battle's own ☰ where the
screen is a battle, and a scene change, which is what a closed window leaves the save, elsewhere. Before pressing the
real Continue it sets every run field the resume reads to a wrong value, so only the file on disk can answer. It hashes
the player's run save before and after, with both arms unconditional, and its Profile writes go to a scratch file.

- **98 / 0** in an isolated copy, and **98 / 0** in the real tree, with the four saves hashed unchanged across it.
- **HEAD's code read 98 / 42**, through a shim that adds only the one name the gate calls (`encounter_pending`). The 42
  are the defect's, section by section: the elite walked past and its bargains re-rolled (7), the bargain-to-fight
  chain (5), the elite's inverse with nothing to stand on (4), the plain fight walked past both ways (7), its inverse
  (2), the zone boss stranded and a second quit skipping a zone (7), the event walked past and the merchant unvisited
  (7), and the v12 arms (3).

### The batteries

- **Reconnaissance: the unmodified gates against the new code**, before the documents moved — 109 targets, three reds,
  all predicted. `check_ea` 86 / 1: the award announcement's pin. `check_cm_live` 13 / 4: its sanctioned four, with the
  same FAIL lines. `check_de` 449 / 2 and one notice: `check_ea` went redder, `check_gf` had no row, and `check_parse`
  rose to 183.
- **Pre-pass: the gates as HEAD wrote them, against the final tree**, in an isolated copy — 109 targets, in the
  reconnaissance battery's order, and four reds, all predicted. `test_batch_ax` 218 / 1: *"the Ruin glossary entry
  states 'NEVER CLEARS'"*. `check_ea` 86 / 1: the same announcement pin. `check_cm_live` 13 / 4: its sanctioned four,
  with the same FAIL lines. `check_de` 453 / 2: those two going redder, and nothing else — the new rows for
  `check_parse` and `check_gf` cleared the reconnaissance battery's other two findings, and the `check_gf` row is the
  four checks `check_de` gained. No log carried a `Parse Error`, `Compile Error` or `SCRIPT ERROR` line.
- **Acceptance: all 109 targets through `run_battery.sh` in the real tree, 01:29:44 → 02:16:29 (46 m 45 s)**, over
  the finished tree with every document and every re-pointed gate in place, and nothing edited during it. `.ran` is one
  sequence of 109 names in the reconnaissance battery's order, with no duplicate, and no Godot or battery process was in
  `ps` before the launch or after the run — the rows were read, not counted. **`check_de`: 453 checks / 0 failures / 0
  notices**, so every `baselines.json` row read at its row, the two this batch added or moved included: `check_gf`
  98 / 0 and `check_parse` 183 / 0. The re-pointed pair read `check_ea` 86 / 0 and `test_batch_ax` 218 / 0. The
  harness passed at 22 / 382 / 8 with no throws; `check_map_screen` COMPLETE; `check_ct_map` 83 / 0; `test_batch_an`
  6,053 and `test_batch_bk` 129, each inside its band; `check_fx` 496 / 0; `test_runes` 5,306 / 0 and
  `test_rune_battle` 97 / 0; `check_ed` 18 / 0 and `check_ec` 23 / 0; and `check_fg` 22 / 0, printing `CLAUDE.md` at
  322,025 B = 314.48 KiB against its 340 KiB ceiling and the changelog at 322,635 B, 77,365 B under its 400,000 B bar.
  **`check_cm_live`: 13 / 4, the sanctioned red, its four FAIL lines identical to GE's acceptance log character for
  character.** That log came out of GE's own scratchpad, confirmed as GE's by its `check_cs` 130, `check_ez` 103 and
  `check_de` 449 / 0, and was copied before it was compared.
- **Parse across the run.** No `Parse Error`, `Compile Error` or `SCRIPT ERROR` line in any of the 109 logs, read off
  the logs and never off a tally or an exit code — and none across the pre-pass's 109 or the reconnaissance battery's 109 either.
- **The freeze.** Every file in the repo but `.git` and the `.godot` build cache — tracked, untracked and ignored — and
  the four player saves were hashed before the launch and after the run: **502 lines, identical byte for byte.**
- **One file was written after the run: this report.** Its acceptance figures went in after the after-freeze was
  taken, and no gate or suite reads `docs/reports/`.

### The re-pointed pins

Each was run as HEAD wrote it against the new tree first, and repaired to its intent in place, with its reason at the
site:

- **`check_ea` §0** asked for *"NEW ABILITY: %s may choose one of three"*; it asks for the announcement without the
  figure. Red in the reconnaissance battery as predicted.
- **`test_batch_ax` §1** asked the Ruin entry for *"NEVER CLEARS"*, the claim §3d corrected; it asks for *"DOES NOT WEAR
  OFF"*. Red in the pre-pass as predicted: *"the Ruin glossary entry states 'NEVER CLEARS'"*.

### The literal sweep and the pin manifest

- **The literal sweep** read every string literal of four or more characters in every `.gd` file — raw, lowered and
  whitespace-flattened — against HEAD's copy and the final copy of each of the fifteen edited files. **Every LOST
  needle was read at its holder, and only two were pins on what lost them**: `check_ea`'s announcement and
  `test_batch_ax`'s *"NEVER CLEARS"*, the two re-pointed above. The rest are held for the holder's own use — the
  difficulty argument *"standard"*, the map's scene path in the gates that open it, card names in fixtures, a bargain's
  runtime text — or were words `docs/state.md` and `CLAUDE.md` stopped using in places no holder reads. **Every GAINED
  needle was read as well**, because a gained needle can turn an absence pin, and none is read against the file that
  gained it.
- **The pin manifest was stale by exactly the re-pointed `check_ea` needle**, and is regenerated: 1,464 pins, one
  needle moved, its residency `code` where it was `alt-sibling`. `test_batch_ax`'s phrases sit in a loop over a list,
  which the manifest does not bind, and `check_gf`'s checks are runtime rather than source pins.
- **Standalone in the real tree after the edits:** `check_ea` 86 / 0, `test_batch_ax` 218 / 0, `check_ed` 18 / 0 and
  `check_ec` 23 / 0.

### The saves

Backed up before anything ran, at `save-backups/GF-20260913-225253/` (not committed), and verified by hash:

| file | md5 |
|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

All four read the same as the backup before `check_gf`'s real-tree run and after it, and before the acceptance launch
and after the run.

The designer's run save is v12, and it was read from a copy: it stands on a won elite with nothing pending, so v13
resumes it exactly where a v12 build does.

### `CLAUDE.md`

**322,025 B (314.5 KiB)**, +3,594 B this batch, against the 340 KiB ceiling.

### The push

To `class-merge`, once this report's figures were in. `git ls-remote origin class-merge` is read against local HEAD
after the push and reported with the batch, because a commit cannot carry its own hash.

## THE FOLDERS THIS BATCH LEFT

Four scratch `user://` folders under `~/Library/Application Support/Godot/app_userdata/`: *Dawn of Decay GF head*, *GF
main*, *GF new* and *GF recon*, one for each isolated copy. Nothing in the game reads them, and they are safe to delete.
