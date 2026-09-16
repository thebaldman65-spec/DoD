# Batch GK — Engines become runes

*Branch `class-merge`, from `3e4bd5e` (GJ); `git ls-remote origin class-merge` read `3e4bd5e` before the push. `main` is
untouched.*

## NEEDS A RULING

1. **THE THREE SPINE RUNES' NAMES ARE PROPOSED.** The twelve spec engines take the brief's names — *Rune of the
   Berserker* through *Rune of the Survivalist*. The three class engines had none to take: **Momentum is proposed as the
   *Rune of the Vanguard*, Channel as the *Rune of the Invoker*, Sanctity as the *Rune of the Hierophant*.** None
   collides with any of the 142 entries in `data/runes.json` or the six template nouns, and a whole-word sweep of every live name population — the probe's eleven (abilities, statuses, relics, runes, talent nodes, items, specs, tags, themes, zones, rungs) and every string in `data/enemies.json`, `events.json`, `glossary.json` and `runes.json`, 5,867 strings — finds *Vanguard*, *Invoker* and *Hierophant* nowhere but on their own runes.
2. **THE THREE SPINES' RULE TEXTS ARE PROPOSED.** `Classes.SPINE_INFO` carries the words an engine rune shows for
   Momentum, Channel and Sanctity; each was written off its own constants and says what the code does, and none was
   ever player-facing before GK.
3. **THE CLASS-SELECTION WORDS ARE PROPOSED:** *"Take one of three engine runes — a second can join it later, and
   either can be dropped (hero 1 of 4)"*, and the button *"Walk this path"* (the old screen's).
4. **AN ENGINE RUNE COSTS THE FLAT 100 GOLD.** The brief rules costs out of this batch (§4); every engine rune is priced
   at the pool's flat rate until one is set.
5. **THE LINEAGE INTERIM.** The spec id survives as the hero's LINEAGE, set by the engine he takes at class selection and
   read by the four layers GK does not merge — his opening kit, his stat block, his draft and boss pools, his
   spec-scoped runes. **A hero who drops his lineage's engine keeps his lineage**: a Pyromancer with no rune is still
   named, statted and offered cards as a Pyromancer. That is the state between this batch and the pool merge, not a
   design.
6. **AN ENABLER CANNOT BE A STAT, AND ONE IS.** Heavy Plating's base is the Warden's `block_chance` 0.10, which lives in
   the Warden's stat block and so stays with the LINEAGE. A Warden who drops the rune keeps 0.10 Block; another Warrior
   who takes it climbs from zero plus its own 15% slice. Whether Heavy Plating carries its 0.10 with it is the
   designer's (§2e).
7. **A HERO WHO TAKES A CLASS ENGINE OPENS WITH ONE ABILITY.** Taking Momentum, Channel or Sanctity at class selection
   gives no lineage, so the hero opens with his class's basic attack alone — *Strike*, *Magic Bolt*, *Smite* — and
   drafts from his class's pool. Driven in two of the three drives (§5): seed 1's Warrior and Cleric, seed 2's Mage.
8. **THE HUNTER'S DEAL IS NO DEAL.** Three of three: every Hunter is dealt all three of his class's engine runes, so
   class selection asks him which one, never which three. The Warrior's, Mage's and Cleric's four each appear in about
   three deals of four (§1c). The charter's six a class ends it.
9. **NO ENGINE RUNE CARRIES A TAG.** `Runes.RUNE_TAGS` has no row for the fifteen; a tag says what a payload does, and an
   engine rune has no payload. `check_ek` exempts them as a set — all of them, and not none — until the designer says
   which words an engine wears.

## THE SHORT VERSION

- **§1 — FIFTEEN ENGINE RUNES, AND THE NINE ARE OWED.** Every engine that exists is a rune in `data/runes.json`, named
  for the spec that carried it or (the three spines) proposed, scoped to its class, with its engine id in `engine` and
  an empty payload. The Warrior, Mage and Cleric hold four, the Hunter three; **the draft of three runs on an uneven
  pool** and the Hunter is dealt all three every time.
- **§2 — THE MACHINERY.** A deal of three at class selection, frozen on the member; `Run.awaken`, the one door the
  screen and the sim share; two slots in `member["engines"]`, apart from the three ordinary ones; drop and swap, to
  nothing, from the map's rune pouch; the enabler travels with its engine and takes no slot. **No save version moved.
  A hero with no engine is legal, fights and wins, and nothing throws. `passive_id` is deleted** — a unit holds
  `engines`, and every read is `has_engine(id)`.
- **§3 — THE DAMAGE, THEN THE REPAIR.** Against the unmodified battery GK's tree read **67 of 104 targets
  red**, and the harness's gate 2: nothing failed to load, **42 targets threw** — 38 of them on the one deleted field —
  and a fixture seated every hero with a spec and no engine rune, so every engine read zero. Repaired in a stated order
  (§3b); **what is left red is what was red before GK: `check_cm_live`'s one sanctioned red, unchanged (§3c).**
- **§4 — NOT DONE, AS RULED:** the nine engines, the pool merge, the engine-reading runes and cards, engine rune costs,
  any talent node.
- **§5 — DRIVEN.** Three whole runs through the real screens, re-run on the repaired code: class selection dealt what each member froze (12 of 12), twelve engines were taken — three of them spines — and fought with; four second engines arrived, three from elite caches and one bought at the Peddler; each was dropped through the pouch's own button, then every engine on every hero, and **all three zero-engine fights were won with no script error**.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `docs/state.md`, `docs/merge-recon.html`, `docs/reports/GJ.md`, and the code each
premise names.

| Premise | Verdict |
|---|---|
| Fifteen engines exist | **HELD** — four Warrior, four Mage, four Cleric, three Hunter. |
| "Momentum, Channel, Sanctity and Focus" — the four new ones | **THREE.** Focus is the Sharpshooter's meter and Lethal Aim was a spec passive before GK; the three spines are the only engines no spec carried. |
| "Quick Shot is the only Focus generator" | **FALSE.** `_gain_focus` has nine callers, and every consecutive attack on one enemy builds Focus through `_sharpshooter_focus`. **Quick Shot is the only FREE attack**, which is why it is Lethal Aim's enabler — the reason stands, the sentence does not. |
| "The three summons are 10 of 10 Beastmaster cards" | **MISSTATED.** The ten Beastmaster draft cards READ the companion; the summons are three abilities, not ten cards. The enabler finding holds. |
| A class "with four or five" | **NO CLASS HAS FIVE** — 4 / 4 / 4 / 3. |
| The recon's 87 of 97 targets | **THE RECON'S FIGURE.** The battery runs 110 targets now (46 suites, 58 gates, three harness gates, two scene runs, the count differ). |
| The relic layer's "spec literals" | **A DAMAGE TYPE**, not a spec: both `relics.gd` sites the recon counted are `"holy"` inside a `dmg_type_mult` hook — the word the Holy spec's id happens to share. |
| `events.gd`'s `spec_in_party` | **A LINEAGE READ**, and it stays one until the pool merge. |
| Sixteen enablers across nine specs | **HELD** (§2d). |
| `check_ft` §0 inverts | **HELD** — the census read it red exactly as written: *"found 3"*, all three in `_sync_engine_switches`. |

## §1 — THE FIFTEEN, AND THE NINE THAT ARE OWED

### 1a. The runes

| Class | Engine — the brief's name, then the engine's own (id) | Rune | Enabler it brings |
|---|---|---|---|
| Warrior | Blood Frenzy (`bloodrage`) | Rune of the Berserker | — |
| Warrior | Heavy Plating (`heavy_plating`) | Rune of the Warden | — (a stat, §2e) |
| Warrior | Stances — *Seasoned Fighter* (`seasoned`) | Rune of the Swordmaster | Guard Change |
| Warrior | Momentum (`momentum`) | **Rune of the Vanguard** *(proposed)* | — |
| Mage | Burn — *Overburn* (`overburn`) | Rune of the Pyromancer | Fireball, Detonation |
| Mage | Chilled — *Glacial Hold* (`permafrost`) | Rune of the Cryomancer | Frostbolt, Ice Lance |
| Mage | Resonance — *Runaway Resonance* (`resonance`) | Rune of the Arcanist | Arcane Explosion |
| Mage | Channel (`channel`) | **Rune of the Invoker** *(proposed)* | — |
| Cleric | Mercy (`mercy`) | Rune of the Holy | Heal, Hymn of Hope |
| Cleric | Faith — *Conviction* (`conviction`) | Rune of the Devout | Divine Shield, Consecrated Ground |
| Cleric | Ruin — *Wrath of the Old Gods* (`old_gods`) | Rune of the Occultist | Shadowrend, Hex of Ruin |
| Cleric | Sanctity (`sanctity`) | **Rune of the Hierophant** *(proposed)* | — |
| Hunter | Loyalty — *Pack Bond* (`pack`) | Rune of the Beastmaster | Summon Ursus, Summon Canis, Summon Aguila |
| Hunter | Focus — *Lethal Aim* (`lethal_aim`) | Rune of the Sharpshooter | Quick Shot (the class basic) |
| Hunter | Trapper (`trapper`) | Rune of the Survivalist | — |

Each entry is `"engine": <id>`, `"scope": "class:<class>"`, `"price": 100`, `"payload": {}`. **The engine id IS the
passive id** — nothing was renamed, so every read of an engine is the id it always was. An engine rune's text is its
entry's one line plus the engine's own live description (`Runes._engine_fields`), so the rune says exactly what the
spec's passive chip said.

### 1b. The nine

**Not authored, as ruled.** Six a class is RULED, NOT BUILT: the Warrior, the Mage and the Cleric are two short, the
Hunter three.

### 1c. What a class with four — or three — does at the draft of three

Probed at 4,000 deals a class, through `Run.deal_engines` itself:

- **The deal is always three.** No class ever drew fewer, and no deal repeated a rune.
- **A four-engine class shows each of its engines in about three deals of four** (the arithmetic is exactly 3/4).
- **The Hunter is dealt all three, every time** — 100% each. The system runs on the uneven pool; it simply offers the
  Hunter no variety in WHICH three (NEEDS A RULING 8).

And a class with five would show each in three deals of five; none exists. **The draft needs no change the day the
nine land** — `deal_engines` draws three from whatever `Classes.class_engines` returns.

## §2 — THE MACHINERY

### 2a. The draft of three, and the one door

`Run.deal_engines(idx)` draws three of the member's class's engine runes and FREEZES them on the member
(`member["engine_offer"]`), so a screen redrawn — or a save reloaded mid-selection — shows the same three.
**`Run.awaken(idx, rune_id)` is the one door**: the class-selection screen and the sim both call it. It slots the rune,
sets the LINEAGE to the spec that engine carried (none, for a spine), gives the hero the class's one tree, marks him
`awakened`, drops the offer, syncs his health and equips his class's talents.

**`awakened` replaces `spec != ""` as "has chosen"**, because a hero who takes a spine has chosen and has no spec.
Four readers of the old meaning were found and moved to it — the class-selection screen's queue and the talent handoff
when the machinery was built, and the zone-boss bank and the fallback draft rolls in §3's repair.

### 2b. Two slots, and where the state lives

**In the party dict**: `member["engines"]`, a list of rune dicts each carrying `equipped`, apart from
`member["runes"]`. `Run.ENGINE_SLOTS` is 2; `rune_slots()` is still 3 and unchanged. `Runes.held_engines(member)` — the
equipped ones, by engine id, in slot order — is **the one answer** the spawn, the kit, the sheet and the map all ask.
`Run.hold_rune` is the one place a taken rune is put down (the Peddler, the elite cache, the bargain, the event verb and
the sim all hand theirs to it): an ordinary rune goes in the pouch, an engine rune to the engine slots, slotted while
one is free and held unslotted otherwise.

**THE SAVE VERSION DOES NOT MOVE.** The engines ride the party dict, as the ability loadout does. `load_run` migrates a
member written before GK — no `engines` key — to the engine his spec carried, slotted, and marks him `awakened`: what he
was fighting with when the file was written. A member with no spec gets nothing (an empty engine id names no rune —
§3b(a) closed the one hole in that).

### 2c. Drop and swap, to nothing

`Run.toggle_engine(member, i)` from the map's rune pouch, which grew an ENGINES section with an Equip / Unequip button
per rune. **Unslotting keeps the rune** — the pouch already works that way — so a drop is reversible between fights;
slotting is refused only when both slots are full. **Zero engines is a legal state.**

**A hero with no engine**, driven in every drive (§5):

- **can** fight, and win: his kit is his class's basic plus his lineage's abilities LESS its engine's enablers (a
  Pyromancer who dropped his rune opens *Magic Bolt, Wildfire, Flamewave*); he drafts, takes ordinary runes, banks his
  class's zone-boss point, wears his class's talents, and can slot any engine rune he holds;
- **cannot** use an enabler (they left with the engine), and has no engine meter, no engine chip and no spine switch;
- **throws nothing**: every drive's zero-engine fight ran with no script error.

### 2d. The sixteen enablers, each to its engine

`PROTECTED_CORES[lineage]["enablers"]`, derived rather than listed. **Sixteen across nine lineages, as the brief says.**

| Engine | Enablers | |
|---|---|---|
| Burn (Overburn) | Fireball, Detonation | **more than one** |
| Chilled (Glacial Hold) | Frostbolt, Ice Lance | **more than one** |
| Mercy | Heal, Hymn of Hope | **more than one** |
| Faith | Divine Shield, Consecrated Ground | **more than one** |
| Ruin | Shadowrend, Hex of Ruin | **more than one** |
| Loyalty | Summon Ursus, Summon Canis, Summon Aguila | **more than one** (three, sharing one bar entry) |
| Stances | Guard Change | one |
| Resonance | Arcane Explosion | one |
| Focus | Quick Shot | one — **and it is the Hunter's class basic**, so every Hunter has it with or without the engine |
| Blood Frenzy, Heavy Plating, Trapper, Momentum, Channel, Sanctity | — | **none** |

A basic-attack enabler (Fireball, Frostbolt, Arcane Explosion, Shadowrend) takes slot 0 while the class basic stands
there and is appended otherwise — so a Mage holding two Mage engines opens with both basics. **`Classes.opening_kit` is
the one kit builder**; `lineage_slots(spec)` is `core_slots` less the enabler slots, the three summons counting one.

### 2e. The engine whose enabler is a STAT

**One: Heavy Plating.** Its base is the Warden's `block_chance` 0.10 — the stat block, not an ability — so it stays with
the Warden lineage (NEEDS A RULING 6). No other engine's base is a stat.

### 2f. What replaces `passive_id`, and what reads it that GK does not repair

**`BattleUnit.engines`** — the held engine ids in slot order, set from the member at spawn (or the spec's own engine,
for a standalone bot battle) — and **`has_engine(id)`**. `engine_chip_id` gives the first engine the chip id the one
passive always used (`spec_passive`) and the second its own (`spec_passive_2`, in `DISPEL_NEVER` beside it).
**`_sync_engine_switches` is the ONE writer of the three spine switches**, off `engines`, at `setup`. **55 code lines in
`battle.gd` and 7 in `unit.gd` read an engine**; no code line names `passive_id`.

**What reads it and is not repaired:** everything that reads an engine does so by id, unchanged — so **every
engine-reading rune and card now reaches any hero holding that engine, including one holding it second.** A rune
written for the Beastmaster that reads Loyalty pays a Survivalist who took Loyalty as his second rune; which of the 43
engine-reading runes and the engine-reading cards SHOULD is step 5 of the running order and §4 rules it out of GK. And
the four LINEAGE layers still read the spec id (NEEDS A RULING 5).

## §3 — THE DAMAGE, THEN THE REPAIR

### 3a. The damage census — the unmodified battery against GK's tree

**The tree: GK's code, the fifteen engine runes, and the charter in `CLAUDE.md`. Every gate and suite unmodified.**
Predicted in writing before the launch; frozen before and after — 527 hashes, the tree and the four saves — and identical.

- **WHAT FAILS TO LOAD: NOTHING.** `check_parse` 184 / 0; not one Parse, Compile or *Failed to load* line in any of the
  110 logs.
- **WHAT THROWS: 42 TARGETS — 31 suites and 11 gates.** **203 of the errors, in 38 targets, are one line**: *"Invalid
  access to property or key 'passive_id' on a base object of type 'Node2D (BattleUnit)'"* — an instrument reading the
  deleted field off a spawned hero. Every other throw is that one's consequence: a hero not found comes back `Nil`, and
  the next line reads it (`test_batch_av`, `bb`, `bg`, `bh`, `bi`, `ay`, `check_ez`). **Two gates never finished** —
  `check_cm_live` and `check_cs` threw at their first read and sat until the watchdog killed them at 240 s.
- **WHAT SILENTLY READS AN ENGINE NOBODY HAS: every fixture-seated hero.** Both fixtures seated a SPEC and no engine
  rune, so each hero spawned with `engines == []`: Resonance built nothing (`test_batch_au`, *"one death builds
  exactly 3 (got 0)"*), no Devout was found by `_living_devout` (`bc`, `be`, `bf`, `check_da`), Faith paid nothing
  (`check_dm`), and a kit without its enablers changed the shop's reason for an empty column (`check_fm`).
- **MOVED BY CONSTRUCTION, NOT DAMAGE:** pool counts that do not know an engine rune (`check_es`, `ez`, `fk`, `fo`,
  `test_runes`, `ba`, `as`, `at`); the slot arithmetic the charter changed (`bo`, `bp`, `bx`, `check_eg`, `eh`, `ea`); the
  source pins GK rewrote (`bm`, `check_fx`, `ed`, `ew`, `bw`, `bv`); `spec_passive_2` in the mark census (`check_el`); the
  untagged engine runes (`check_ek`); the brief's *Rune of…* names (`check_fd`); engine runes' empty payloads
  (`check_et`, `test_runes`); and `check_ft` §0, written to invert.
- **AND TWO REAL DEFECTS IN GK'S OWN CODE**, which the census is the only reason anyone knows: `bank_zone_boss_points`
  paid a class whose hero had not awakened (the harness's gate 2: *"the un-awakened one did not: got 3, want 2"*), and
  the two fallback draft rolls paid a member who had not been through class selection (`test_batch_ah`).

**The tally: suites 40 of 46 red, gates 27 of 58, the harness's gate 2, and the count differ 158 of 457.** Green
throughout: six suites (`test_batch_ai`, `an`, `bd`, `bj`, `bl`, `cd`), 31 gates, the harness's gates 1 and 3, and both scene runs.

### 3b. The repair, in the order it was done

**(a) THE GAME, FIRST.** Three corrections to GK's own code, each the census's finding:
- **A member not yet awakened draws from no pool** — `draft_pool_left` and `roll_class_fallback_offer` refuse a member
  with no spec who has not been through class selection (a spine-taker, awakened, still draws his class's cards).
- **A member not yet awakened banks no zone-boss point**, for his class either — FX's rule, which the class-keyed bank
  had dropped. `_resolve_boss` reaches it through the same one function.
- **An empty engine id names no rune.** `Runes.engine_rune_id("")` matched the first ORDINARY rune, whose `engine` is
  empty too, so a save with an un-chosen member would have loaded him with an ordinary rune in an engine slot.

**(b) THE TWO FIXTURES** seat each lineage's engine rune, slotted, and mark the hero awakened — what class selection
hands a player who takes it — so every suite and gate that seats a spec seats the engine the spec used to bring. **The
single change that cleared most of the census.**

**(c) THE MECHANICAL RE-POINT.** Every instrument read of `passive_id` became `has_engine(...)`: 45 comparisons in 36
files by two patterns, and eleven special shapes by hand — the companion's empty engine list (`check_du`), two
messages (`check_fo`), a write that strips and restores the Warden's plating (`test_batch_bp`), heroes keyed by engine
(`test_rune_battle`), `check_ew`'s source pin and its helper's comment, and two negative needle lists that now name
`has_engine` too (`check_ft` §2c and `check_fx`). The source pins in `test_batch_bw` and `test_batch_bv` named the old
comparison inside a quoted string, which the second pattern re-pointed in place.

**(d) `check_ft` §0, INVERTED** to `CLAUDE.md`'s sentence: the three switches' ONE writer is
`_sync_engine_switches`, off `engines`, called from `setup`, asserted over the comment-stripped sweep with its
constructed control; and **both halves on a driven party** — four lineages holding no spine read every switch off,
and a second board where three heroes hold the three spine runes (one in a second slot, one having dropped his own)
reads exactly those switches on, with two Momentum steps quickening the holder and not the hero beside him.

**(e) THE POOL POPULATIONS.** Every count that walks `data/runes.json` counts the fifteen engine runes BESIDE the pool
rather than inside it — an ordinary-rune invariant stays pinned and the engine runes get an arm of their own (their
scope, their price, their number). An engine rune's empty payload is exempt from the payload rules as a SET, never one
by one: `test_runes`' one-branch rule, its power arm, its exhaustion walk; `check_et`'s offer and build checks, each
with an arm proving engine runes did reach the offer. **The cache-triple rule is re-derived, not widened**: every
candidate must be the holder's own spec rune or one of his class's engine runes, per candidate, with an arm proving the
engine runes reach the cache.

**(f) THE SLOT ARITHMETIC.** An enabler sits outside the slot count, so every cap fill reads `Classes.lineage_slots`,
not `core_slots`: a fresh Pyromancer uses two of seven, and five earned cards fill him.

**(g) THE PINS GK REWROTE AND THE SEATS THAT BRING NO ENGINE.** The awakening's pins point at `Run.awaken`; the talent
source at `Profile.worn_talents(key)`; a Swordmaster holding Stances owns Guard Change, with the arm that a Swordmaster
who dropped it does not; and the suites that seat a lineage by hand seat its engine rune.

**THE FOURTH AND FIFTH PASSES — WHAT THE FIRST RE-RUN AND THE PRE-PASS STILL READ.** Five more instruments seated a lineage by hand, and each now seats its engine rune: `test_rune_battle` (three seats — its Sharpshooter had no Focus meter at all), `check_fh` (two — its engine-less party wiped at the fight after the mini-boss, nine encounters into the run it walks whole), `check_fm` (three — a kit without its enablers changed the shop's reason for an empty column) and `test_batch_an`'s `_spawn_battle` (the Pyromancer spawned without Detonation and Holy without Heal and Hymn of Hope, so its per-ability loops read three fewer checks — 6,043 against a floor of 6,046, in the census as well). `check_fh` §3's pouch is both lists, since the rune it buys can be an engine rune; `check_fo` §2c counts the engine runes beside the pool. **And one flake the change had made:** `test_batch_bx` §2 puts two heroes on one lineage, one of them on the Warrior's seat, to prove one's refusals never hide a card from the other. The class half of the draft keys to the class now, so the Warrior-seated Cryomancer drafted Warrior cards the other could never be offered — **a red on any draw that dealt him one.** It passed the census and the first re-run by the luck of the draw and failed the pre-pass; the two heroes are one class as well as one lineage now. A static sweep of every four-hero party in the instruments found five more that seat a lineage on another class's seat; none reaches a class-keyed draw. **`pin-manifest.json` is regenerated** — 1,467 pins to HEAD's 1,464, and its one unresolved source pin is HEAD's own (`check_fh`'s `grant_rune`).

### 3c. What is left broken

**Nothing GK broke is left broken.** On the repaired tree every suite and gate reads green but one, and that one is the red this project has carried on purpose since long before GK: `check_cm_live`, 13 checks and 4 failures, identical on unmodified HEAD and recorded as owed in the gate itself. Its row did not move.

- **WHAT MOVED INSTEAD OF BREAKING** — the rows GK's content and its repair changed, each written into `baselines.json` with its reason before the acceptance run: 15 rows. **The fifteen engine runes meeting per-entry walks, with their arms**: `test_runes` 5306 → 5502, `ba` 633 → 703, `cb` 1729 → 1864, `al` 455 → 470, `bh` 280 → 295. **`check_ft` 140 → 146**, §0 inverted. **One new arm each**: `check_ek` 46 → 47, `check_et` 26 → 27, `check_ez` 103 → 104, `check_fd` 50 → 51, `check_fk` 63 → 64, `check_fo` 87 → 88, `ak` 338 → 339, `as` 266 → 267, `at` 352 → 353. Each row's note carries its reason, counted off the diff.
- **WHAT GK LEFT UNDONE IS NOT BROKEN**: §4's list and the rulings above. Nothing in the battery stands in for any of it, and nothing in it is sanctioned red on GK's account.
- **TWO THINGS READ RED ONLY IN THE COPIES THE REPAIR WAS STAGED IN, AND NEITHER IS THE TREE'S**: `check_fr` §1, because a copy has no `.git`; and `check_ed`, until `pin-manifest.json` is regenerated, which the landing does.

## §4 — NOT DONE, AS RULED

- **The nine engines** — six a class is RULED, NOT BUILT.
- **The pool merge** — the three draft pools of a class are still three, keyed by lineage.
- **The 43 engine-reading runes and the engine-reading cards** — read by id, unchanged (§2f).
- **Engine rune costs** — the flat 100 gold (NEEDS A RULING 4).
- **No talent node moved.**

## §5 — DRIVEN, THE WHOLE PATH

**Three whole runs through the real screens** (`drive_gk.gd`, in an isolated copy with its own `user://`), re-run on the repaired code. Each seed plans a different engine per class, so twelve are taken across the three — the three spines among them — and the fifteen are all dealt.

| Seed | Taken at class selection | A battle with them | A second engine | Dropped | With zero engines |
|---|---|---|---|---|---|
| 1 | Vanguard *(spine)* · Pyromancer · Hierophant *(spine)* · Beastmaster | victory | the Cleric takes the **Rune of the Holy** from an elite cache → Sanctity + Mercy | the Holy, then every engine | **victory**, two battles |
| 2 | Warden · Invoker *(spine)* · Occultist · Sharpshooter | victory | the Mage takes the **Pyromancer** from an elite cache → Channel + Overburn; the Hunter the **Beastmaster** → Focus + Loyalty | the Pyromancer, then every engine | **victory**, two battles |
| 3 | Swordmaster · Arcanist · Holy · Survivalist | victory | the Warrior **buys the Vanguard at the Peddler** → Stances + Momentum | the Vanguard, then every engine | **victory**, two battles |

- **The screen deals what the member froze**: all twelve deals read the same three runes on the screen and in `member["engine_offer"]`.
- **The kit follows the rune**: a spine-taker opens with his class's basic alone (*Strike*, *Magic Bolt*, *Smite*); a lineage opens with its whole protected core, enablers included (the Beastmaster: *Quick Shot, Summon Ursus, Summon Canis, Summon Aguila, Hunter's Instinct, Kill Command*).
- **A second engine lands in the second slot wherever it comes from**, and a spine-taker holding a spec engine second gets that engine's enablers (seed 2's Mage: Channel, then Overburn, Fireball and Detonation with it).
- **Every drop went through the pouch's own Unequip.** With every engine gone, the twelve heroes fought with:

| Hero | Kit with no engine | Chips |
|---|---|---|
| Warrior (took the Vanguard) | Strike | the class passive |
| Mage (took the Invoker) | Magic Bolt | the class passive |
| Cleric (took the Hierophant) | Smite | the class passive |
| Pyromancer | Magic Bolt, Wildfire, Flamewave | the class passive |
| Arcanist | Magic Bolt, Arcane Cannon, Arcane Barrage, Death Ray | the class passive |
| Warden | Strike, Mocking Blow, Crushing Blow, Shieldwall | the class passive |
| Swordmaster | Strike, Overpower, Pommel Strike | the class passive |
| Holy | Smite, Renewal, Resurrection | the class passive |
| Occultist | Smite, Bewitch, Dark Pact | the class passive |
| Beastmaster | Quick Shot, Hunter's Instinct, Kill Command | the class passive, Instinct |
| Sharpshooter | Quick Shot, Aimed Shot, Powershot, Hold Breath | the class passive, Hold Breath |
| Survivalist | Quick Shot, Tripwire, Shrapnel Charge, Snare Trap | the class passive |

  No hero with no engine has a second meter, an engine chip or an enabler; **every zero-engine fight was won, and not one of the three runs printed a script error.**

## FOUND AND NOT FIXED

- **`save-backups/` IS UNTRACKED AND NOT IGNORED.** Every batch's player-save backup since FR sits there, and none was
  ever committed because each batch staged by path; a `git add -A` would commit four player saves nineteen times over.
  One `.gitignore` line; not GK's to add unasked.
- **`check_fm` §2a's second arm names text the game no longer prints** — *"wait on cards they have not drafted"*, where
  `Runes.empty_offer_reason` says *"wait on abilities they have not earned"*. The arm is an OR, so it is inert: the
  check passes on the other arm or on neither. Found because GK's census reached it; not GK's.
- **Two comments in `battle.gd`** (DT's companion census) still say a companion's `passive_id` is always empty. It is
  `engines` that is always empty now; the arithmetic they describe is unchanged.
- **FIVE FOUR-HERO PARTIES IN THE INSTRUMENTS SEAT A LINEAGE ON ANOTHER CLASS'S SEAT** (`check_fn` twice, `check_fo`, `test_batch_bm`, `test_batch_bx`'s default). All are artificial, and a static sweep found that none reaches a class-keyed draw — the one that did, `test_batch_bx` §2, is repaired (§3b). The next batch that keys anything else to `member["key"]` meets them again.
- **`test_batch_an`, the project's known drifter, read 6,046 on the repaired tree — its band's floor exactly.** Nothing GK did moves the band once the kits hold their enablers, so the band is unchanged; a drift of one below it reads as a fall.

## VERIFICATION

### The saves

**Backed up before anything was written** — `save-backups/GK-20260915-163015/` — and verified by hash: `profile.json`
`b05e329b…`, `relics.json` `fdc12ffa…`, `run_save.bin` `c44d45da…`, `settings.cfg` `0c1b39c3…`, each matching the live
file. **Re-hashed after the acceptance run: identical — all four hashes above, byte for byte**

### The parse floor

Read off `check_parse`'s stderr, never its tally: **184 / 0 and not one Parse, Compile or load error** on the census
tree, after each repair pass, and on the acceptance tree.

### The census

In §3a. Frozen before and after — 527 hashes, the tree and the four saves — and identical; every figure there is off its logs.

### The acceptance run

**Run against the landed repo, predicted in writing before the landing and frozen before and after** — 528 hashes, the tree and the four saves — **identical**. 18:38:00 to 19:25.

- **Suites: 46 of 46 green**, every one at its row.
- **Gates: 57 of 58 green, and `check_cm_live` at 13 / 4** — its standing sanctioned red, its four FAIL lines identical to GJ's acceptance run, which is the control on HEAD's side.
- **The harness: gates 1, 2 and 3 PASS** (22 / 382 / 8) — gate 2 the census's red, closed by §3b(a).
- **Both scene runs complete**; `check_ct_map` 83 / 0.
- **`check_de`**: `check_de: 457 checks / 0 failures / 0 notices` — no FAIL line. The fifteen rows GK moved read exactly their new counts, and `test_batch_an` read 6053, inside its band.
- **`check_parse` 184 / 0**, and not one Parse, Compile or load error on its stderr.
- **Every prediction held.**

### The probe and the drives

**The probe, re-run on the final game code** (`probe_gk.gd`, in the isolated copy; exit 0, no script error):

- **Every engine rune resolves** — its engine, lineage, class, scope, the flat 100 gold and its enablers — exactly as §1a tabulates.
- **The deal, 4,000 a class:** always three runes, never a repeat. Each of the Warrior's, the Mage's and the Cleric's four appeared in 2,970–3,043 deals (the arithmetic is 3,000); each of the Hunter's three in all 4,000.
- **The kit:** all twelve lineages holding their own engine open with exactly their protected core — 0 of 12 differ. Dropped, each opens with that core less its enablers (the Pyromancer *Magic Bolt, Wildfire, Flamewave*; the Devout *Smite, Blessing of Zeal*); a class holding only a spine opens with its basic; and a second engine adds its enablers and takes no slot — a Pyromancer holding Chilled as well opens with both basics and both engines' abilities, six in all.
- **The slots:** `lineage_slots` reads 3 for the Berserker, Warden, Arcanist, Sharpshooter and Survivalist; 2 for the Swordmaster, Pyromancer, Cryomancer, Holy, Occultist and Beastmaster; 1 for the Devout.
- **A driven battle** — a Berserker holding Blood Frenzy and Momentum (the Momentum switch on, two engine chips), a Pyromancer holding two Mage engines, a Cleric holding only Sanctity (its switch on, *Smite* alone) and a Beastmaster whose rune is unslotted (no engine, no summons, the class chip only) — ran with no script error.

**The drives** are §5: three whole runs on the final game code, no script error in any.

### The literal sweep

**Every string literal of four or more characters in the final 114 root `.gd` files — 13,408 — looked for in HEAD's copy and the landed copy of the 19 files GK changed** (six documents, `data/runes.json` and twelve scripts): **LOST 42, GAINED 113.**

- **The documents lose five, all in `docs/state.md`** — GJ's WHAT MOVED list, which GK's replaces — and none of that file's nine readers names any of them.
- **The scripts' 37 losses are GK's own rewrites**, and the pre-pass ran every suite and gate against exactly this code: nothing it read red is unexplained (§3c).
- **The gains were checked for NEGATIVE uses**, the one kind a gain can flip. Eleven instrument lines name a gained literal inside a `not … contains`; every one reads a different source from the file that gained it — one guard line of `battle.gd`, a talent payload, an ability's description, a slice of the turn code, two conditionals inside source scans — and every one of those gates read green against this code.
- **One document pin moved with its document**: `check_dr` §8's engine anchor, re-pointed to the charter's definition in the same pass that landed the `CLAUDE.md` carrying it.

### The push

**Committed and pushed to `class-merge` only**; `main` is untouched. The remote read `3e4bd5e` (GJ) before the push. The post-push reading of `git ls-remote origin class-merge` against local HEAD is reported with the delivery rather than here — written into this file, it would change the commit it names.
