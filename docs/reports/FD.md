# BATCH FD — THE CACHE RE-ASKS, BREAK BECOMES SECONDARY-ONLY, AND THE SHARED RUIN IS RENAMED

*2026-09-06. Three items. §1 was reported as two bugs and is one hole plus one ruling; §2 is a tag
ruling with one per-card judgement inside it; §3 is one string.*

---

## §0 — WHAT THE BRIEF GOT WRONG, FIRST, BECAUSE THREE OF ITS PREMISES DECIDED THE WORK

**The brief said to verify every premise. Four did not survive.**

| Premise | What the repo says |
|---|---|
| *"the retirement flag is not read at every offer site"* | **FALSE.** All four offer sites read it. 1,200+ draws, zero leaks. |
| *"ET's live drive did not cover the site the designer is seeing"* | **TRUE, but not as a missed door** — ET drives every door that ROLLS. The site the designer sees does not roll. |
| *"Firestorm and Pyrewake … both should read OFFENSE primary"* | **NEITHER IS IN THE POPULATION.** Both are `["DEBUFF", "BREAK"]` — BREAK is already their secondary. And there is no card called "Pyrewake"; it is **Pyre Wake**. |
| *"61 of the 66 retired ones use the `Rune of the…` form"* | **52** use `Rune of the…`; **61** use `Rune of …`. The 61 is right for the wider family. |

**The two named cards are the most important of these**, because the brief also said *"derive the
full population rather than taking those two — my lists have been short every time."* Taking them
would have moved two cards that did not need moving and missed all 54 that did.

---

## §1 — THE OFFER SITES: THE ROLL DOORS WERE NEVER THE HOLE

### 1a. THE POPULATION, DERIVED FROM THE WRITE

A rune reaches a hero **exactly where something appends to `member["runes"]`**. That is the
derivation; a list of screens would have missed the bargain and included the sim.

| Site | Door it reaches the pool through |
|---|---|
| **The Peddler** — `shop_screen._roll_offers` | `Run.generate_rune` → `Runes.generate` → `eligible_ids` |
| **The elite cache** — `battle.gd` victory branch | `Run.roll_rune_candidates` → `generate_rune` → same |
| **The bargain** (a severity-3/4 rung) — `run_state.gd` | `Run.roll_rune_candidates` → same |
| **The event verb** — `events.gd` | `Run.grant_rune` → `eligible_ids`, falling back to `generate_rune` |
| *(the sim's own three sites — `run_sim.gd`)* | *the same three `Run` functions; not player-facing* |

**And three absences, asserted rather than assumed:** the **spec-choice screen** offers no rune (AN
deleted the opening pick and its comment says so), **boss trophies award ABILITIES**
(`roll_spec_ability_offer`), and **no relic grants one**. `check_fd` §1a pins all four sites by the
call each makes and asserts five more files grant nothing.

**In `scripts/`, only `run_state.gd` names `Runes.generate`, `eligible_ids`, `config`, `build` or
`template_rune` at all.** The door really is one door.

### 1b. DRIVEN, INCLUDING ON THE DESIGNER'S OWN SAVED PARTY

The first thing driven was not a synthetic member — it was **the party in
`user://run_save.bin`**, written at 10:00 on the day of the brief: warrior/**berserker**,
mage/**pyromancer**, cleric/**holy**, hunter/**sharpshooter**.

```
warrior/berserker    live eligible = []
mage/pyromancer      live eligible = []
cleric/holy          live eligible = []
hunter/sharpshooter  live eligible = [keen_focus, heavy_bolts, wide_watch, long_draw_press]
```

**300 Peddler draws per hero. Zero retired entries. Zero.** Three of the four heroes can be offered
**nothing but the generated stat family** — Rune of Vitality, Rune of Warding, Rune of Swiftness,
Rune of Poise, Rune of Precision, Rune of Springs — because every authored rune for berserker,
pyromancer and holy is retired and **eight of the twelve specs are still unwritten**.

`check_fd` §1b re-drives it as a gate: 360 shop draws, 12 grants and 96 triples across all twelve
specs, **0 retired**, with a floor on the number of distinct LIVE runes reached — because *"nothing
retired came out"* is exactly what a walk that read nothing would print.

### 1c. THE HOLE: THE CACHE DOES NOT ROLL AT THE OFFER

`roll_rune_candidates` runs **at the drop**. Its triple is stored on the member
(`member["rune_candidates"]`), rides the party dict **into the save**, and is answered whenever the
player opens the card. Between the roll and the answer:

- **a rune can be retired** — and a run in progress across ET or FC keeps offering it;
- **a rune can be acquired** — from the Peddler, or from a second cache queued behind the first.

**`Runes.is_retired` had ZERO callers in the game.** `eligible_ids` re-implements the test inline,
and the stored triple never goes back through it. `map_screen`'s overlay read `queue3[0]` directly
and `_pick_rune` appended whatever was at that index, with no check of any kind.

**Measured, 400 trials, on a fresh Sharpshooter:**

| | |
|---|---|
| two queued triples share at least one name | **265 / 400** (re-driven in the gate at 285 / 400) |
| a queued candidate is also the Peddler's offer | **127 / 400** |
| the pick path refuses either | **never** |

**The designer's live save carries the symptom.** `hunter/sharpshooter` wears **`heavy_bolts`
twice, both equipped** — under a shop header that reads *"RUNES (one of each, permanent for this
run)"*.

**So both reports were true at once, and this is the transferable finding.** `check_et` §2 drives
five doors on twelve specs and asserts no retired entry reaches an offer; it reads clean and it is
correct. **It drives the producer. The player uses the consumer.** Recorded as a standing rule in
`CLAUDE.md`.

### 1d. THE REPAIR — ONE DOOR, AND IT IS NOT A REROLL

`Run.rune_choice(member)` takes the head triple, drops any candidate that is **now retired** or
**now owned** (or a repeat inside the triple), tops it back to three through `generate_rune` —
which reaches `eligible_ids`, so a top-up cannot reintroduce either fault — and **writes the repair
back onto the member**. The overlay and `map_screen._pick_rune` both come through it.

- **WRITING IT BACK IS WHAT MAKES IT A REPAIR RATHER THAN A REROLL.** BATCH X ruled that a cache
  does not reroll when a screen opens. A triple with nothing wrong with it is **returned
  untouched**, and one that is repaired is repaired **once** — so the array the buttons were built
  from is the array the handler indexes.
- **THE TOP-UP CANNOT COME BACK EMPTY IN A REAL RUN**, and it is guarded anyway.
  `generate_rune` returns `{}` only under `DOD_SIM_RUNES=off`, and under that flag
  `roll_rune_candidates` returns `[]` and nothing is ever queued — so a non-empty queue proves runes
  were on when it was written. `_pick_rune` refuses an empty repaired triple rather than indexing
  `[-1]`.

### 1e. THE MERCHANT'S ABILITY DRAFT — NOT A BUG, AND WITHDRAWN ANYWAY

**It is BATCH BO §3 and it was deliberate**: *"The third of the four sources: an elite always gives
one, an event may trade one, and this is the one you can simply BUY."* It reached the pool through
`Run.draft_pool_left` and `Run.award_draft_pick` — **the same door every other draft source uses**.
It is not an offer site assembling its own contents, and it **shares no cause with §1c**. The two
arrived on one screen and were reported as one symptom.

**Withdrawn because the designer ruled it.** What goes with it, stated:

- **A draft pick is earned and never bought.** The other three sources are untouched, and
  `check_fd` §1f asserts they still stand **in the same breath** as the removal.
- **`Run.draft_price()` is KEPT with no game-side caller** — the 120 / 180 / 240 ladder, on the
  same contract a retired rune is kept on.
- **`run_sim` never bought one** (its shop policy buys items and runes only), so **no figure in the
  economy report moves**.
- **The left column of the shop is empty from y=452 to the Leave button at 640.** Cosmetic, and
  reported rather than redesigned. **The 36-row pitch is deliberately NOT widened back**: CT
  measured it against the draft header, and a ninth item type lands at y=450 under this pitch and
  y=610 under the old one, so the measured layout is the one that survives growth.

### 1f. THE SAME IDIOM IS IN THREE MORE PLACES AND ONLY ONE IS GUARDED — **REPORTED, NOT FIXED**

| Queue | Resolution | Re-asked? |
|---|---|---|
| `draft_candidates` (the ability draft) | `Run.take_draft_ability` | **YES** — refuses a card the hero already knows |
| `bm_candidates` (the zone-boss pick) | `map_screen._pick_ability` → `Run.hold_ability` | **NO** |
| `up_candidates` (the upgrade pick) | `map_screen._pick_upgrade` → `member["upgrades"]` | **NO** |

**Their reachability was NOT driven** and this report does not claim it. Both need two picks queued
before either is answered; whether the game produces that is a question for whoever takes it.
**Out of §4's scope** — this batch was told to fix the rune hole, and widening a repair into two
more systems on a hunch is how a batch stops being reviewable.

---

## §2 — BREAK BECOMES A SECONDARY TAG ONLY

### THE POPULATION, DERIVED

**54 of 227 rows carried BREAK first. 20 of them as their ONLY tag.**

| | before | after |
|---|---|---|
| DEBUFF | 68 | 68 |
| DEFENSE | 56 | 56 |
| **BREAK** | **54** | **0** |
| RESOURCE | 17 | 17 |
| **OFFENSE** | **16** | **70** |
| TEMPO | 8 | 8 |
| MARK | 8 | 8 |
| *corpus* | *227* | *227* |
| *cards carrying BREAK at all* | *46* | *99* |

**53 became `["OFFENSE", "BREAK"]`. The 54th is Feint** — see below.

**30 rows lost a secondary to make room**: 18 RESOURCE, 9 DEBUFF, 2 DEFENSE, 1 TEMPO. (20 had no
secondary to lose; 3 already read OFFENSE second and are a clean swap.) **That is cheap for one
specific reason and only that reason: a SECONDARY FEEDS NO CONDITION.** EZ §0c counts the PRIMARY
only, so a displaced secondary moves `tag_census` — a screen — and nothing a rune asks. Had EZ
counted both tags this would have been a balance change wearing a vocabulary fix's clothes.

### FEINT — THE ONE PER-CARD JUDGEMENT, AND IT WAS FOUND BY THE ORDERING RULE

`Feint` was `["BREAK", "MARK"]`. Under the rule as stated it becomes `["OFFENSE", "BREAK"]` — which
**drops MARK**, and **EL §2 ruled that Feint carries MARK second** (it marks on one of its two
stance branches). `check_el` asserts that pin by name.

**The older ruling keeps the slot.** FD §2's *binding* half is *no card carries BREAK first*; the
*retained-secondary* half is the reason it is a demotion rather than a removal, and on this one card
the two cannot both be had. **`Feint` reads `["OFFENSE", "MARK"]` and is the one card of the 54
where the demotion became a removal.** `check_el`'s pin was re-pointed **in place, with its
reason**, from `["Feint", "BREAK"]` to `["Feint", "OFFENSE"]`; it still asserts the MARK half from
its own side, so the two rulings cannot drift apart.

**IT WAS FOUND BY RUNNING `check_el` UNMODIFIED AGAINST THE NEW CODE BEFORE ANYTHING WAS
RE-POINTED** — FA §1b's standing rule, paying for itself for the second time in three batches.

### WHAT IT DOES TO THE TWO CONDITIONS

**THRESHOLD IS UNTOUCHED, AND THAT IS A DERIVATION RATHER THAN A MEASUREMENT.** The transform moved
cards between exactly two columns, BREAK and OFFENSE. A threshold's count can only have moved if it
names one of them. **None of the four live thresholds does** — Deepening Hex asks DEBUFF, Bracing
Line and the Answering Pack ask DEFENSE, Heavy Bolts asks MARK. `check_fd` §2 asserts **no live rune
gates on BREAK *or* on OFFENSE**, in both directions, so the day one is authored the gate says so.

**AND A BREAK THRESHOLD IS NOW UNMEETABLE.** `master.html` used to warn that a rune asking for 2+
BREAK *"would be on from the first fight for almost everyone and no swap could turn it off"*. **That
warning is now inverted**: no card can contribute a BREAK primary at all, so such a rune could never
be met by anyone, ever. The document says so now, in the same paragraph.

**BREADTH ONLY EVER GETS HARDER, AND IT IS MEASURED AGAINST AN EXACT RECONSTRUCTION.**
`primary_tag_peak` folds what was a hero's BREAK column into his OFFENSE one, so the peak rises or
holds and never falls. **Before FD, no row read `["OFFENSE", "BREAK"]`** — the three cards carrying
both had them the other way round — so reading every such row's primary back as BREAK inverts the
transform row for row. The gate asserts that population (53 + Feint) rather than trusting the shape.

Over **36 real drafted loadouts** (every spec, at 4 / 5 / 7 drafted cards, taken through
`Run.draft_pool_left`):

| | |
|---|---|
| breadth met, before | **4 of 36** |
| breadth met, after | **2 of 36** |
| loadouts whose peak ROSE | **5** |
| loadouts whose peak FELL | **0** (asserted per loadout) |

**That is the cost, and it falls on Wide Rite, Long Watch, Wide Watch and Shared Scent.** It is not
ruled on here.

### `RUNE_TAGS` IS DELIBERATELY NOT TOUCHED — **AND THIS NEEDS A RULING**

The ruling names **cards**, four times. The vocabulary is shared, so after this batch the primary
vocabulary is uniform **on cards and not on runes**. Five rune rows still carry BREAK first:

- **`long_watch`** (`["BREAK"]`) — **LIVE**
- **`bared_plate`** (`["BREAK", "DEFENSE"]`) — **LIVE**
- `comet`, `seventh_bolt`, `shattered_guard` — retired

**Widening a ruling is not implementing it**, so they are pinned at five and reported.
`Runes.RUNE_TAGS` is display-only (`rune_tag_line`), so nothing behaves differently either way.
**The question for the designer: do the two live rune rows follow the cards?**

---

## §3 — `Rune of the Shared Ruin` → `Shared Ruin`

**One string, plus its one pointer.** The `name` in `data/runes.json`, and the sentence inside Split
Tongue's own retirement string that said *"Replaced by the Rune of the Shared Ruin"* — a retirement
record pointing at a name that no longer exists is worse than a record that follows its subject.

**The premises, re-derived:** 20 of the 21 live runes carry one- or two-word names (the Shared Ruin
was the 21st, at five). **52 of the 66 retired entries begin `Rune of the`, and 61 begin
`Rune of`** — the brief's 61 is the wider family, not the narrower one.

**THE BR §1 SWEEP, ON THE SHORTENED FORM.** Swept against the **227-name ability corpus**, the
**whole 87-entry rune pool including the retired half**, the **six template runes**, and every
talent node name. **No collision.** Containment neighbours: `Hex of Ruin` (ability),
`Weight of Ruin` and `Avatar of Ruin` (talent nodes) — none is the name, and none contains it.
`Standing Mark`, `Wide Rite` and `Shared Hide` (the three the brief named as close) resolve to
their own single entries and are untouched.

**The rule is written into `text-standard.html` §4.11**, with the generated stat family — Rune of
Vitality and its five siblings — named as its one deliberate exception, because the long form is
what marks a filler rune as filler on a shop row beside an authored one.

---

## §4 — ALSO CORRECTED, BECAUSE §2 IS WRITTEN IN THAT SECTION

CLAUDE.md's rule is to **sweep for the mechanism, not for the section you edited**. Two false
claims about the tag mechanism were standing in §6c and in the glossary:

- **`master.html` §6c: *"NO CLAUSE READS A TAG YET."*** False since **BATCH EZ** gated eight runes.
- **`glossary.json` `archetype_tags`: *"THE TAGS ARE SHOWN AND READ NOTHING."*** Same claim, and
  **contradicted by the glossary's own `runes` entry two screens away**, which describes THRESHOLD
  and BREADTH runes at length.

Both repaired. Neither was FD's to make and both were in the paragraph FD had to rewrite.

**NOT REPAIRED, AND NAMED SO THE NEXT BATCH CAN FIND THEM:**

- **`master.html`'s rune section still says *"with the pool empty there is nothing left to price"*
  and *"the 53 ET retires"* and *"Spec coverage: 65 authored runes"*.** Superseded at EZ. It is a
  different section from the one this batch wrote in, and it is a paragraph rather than a sentence.
- **The `merchant` glossary entry says the Peddler offers a rune *"to each hero who has a free
  slot"*.** `_roll_offers` checks no slot — it offers to every hero. Pre-existing, one sentence.

---

## §5 — VERIFICATION

### FIVE NEGATIVE CONTROLS, EACH DISCRIMINATING, AND ONE THAT DID NOT BITE ON ITS FIRST ARMING

| Control | Result |
|---|---|
| `rune_choice` neutered to HEAD's behaviour (return the stored triple) | **6 reds** — and §1e reproduced the designer's exact symptom through the real screen: `["Heavy Bolts", "Heavy Bolts"]` in the pouch |
| one BREAK primary restored (`Cleave`) | **3 reds** |
| the old rune name restored | **2 reds** |
| the merchant's three draft needles restored | **4 reds** |
| **`rune_choice` turned into a REROLL** | **exactly 2 reds** — the idempotence arm and the no-reroll arm, and nothing else |

**THE REROLL CONTROL READ GREEN ON ITS FIRST ARMING.** Deleting the early return left the rebuilt
array identical to the stored one, so the injection changed nothing and the gate read 87 / 0.
Re-armed by **discarding the survivors** it bit, and only the two arms it should. That is the fifth
time this project has recorded a control whose injection did not break the needle it aimed at.

**Every control file was restored from a pre-control copy and `md5`-verified identical** across all
five files.

### THE ORDERING RULE PAID AGAIN

HEAD's unmodified gates were run against the new code **before any of them was edited** (FA §1b).
See the battery section below for the full list; the one that mattered is **`check_el`**, whose
Feint pin is the ruling collision in §2 and which no source read would have surfaced.


### `check_es` §4's TABLE, RE-PRINTED — **AND THE BRIEF'S EXPECTATION OF IT IS WRONG**

The brief said *"BREAK met a 2+ threshold on ten of twelve protected cores. Under drafted-only
counting that table already changed — re-print it and report what moves."*

**That table is the CORE KIT, counting BOTH TAGS. It is neither drafted-only nor primary-only, and
it never answered the question the brief attributes to it.** It is ES §4's shape — right for a
screen — while the two conditions are EZ §0c's, which count the PRIMARY over the DRAFTED half. So
what moves is not what was expected:

```
  spec           DEBU    DEFE    BREA    RESO    OFFE    TEMP    MARK
  berserker      2       0       4       0       0(2)    0       0
  warden         2       1       3       0       0(1)    0       0
  swordmaster    1       1       3       0       1(3)    0       0
  pyromancer     4       0       4       0       0       0       0
  cryomancer     4       0       4       0       0       0       0
  arcanist       0       0       4       0       0(4)    0       0
  holy           0       4       1       1       0(1)    0       0
  inquisitor     0       2       1       1       1(2)    1       0
  occultist      3       1       2       1       0       0       0
  beastmaster    1       0       5       0       1(5)    0       0
  sharpshooter   0       0       3       1       1(4)    0       0
  mystic         1       0       3       0       0(3)    0       0
                                      before(after)

  specs meeting a 2+ census on the CORE KIT ALONE, of 12   before -> after
    DEBUFF     5 ->  5      RESOURCE   0 ->  0
    DEFENSE    2 ->  2      TEMPO      0 ->  0
    BREAK     10 -> 10      MARK       0 ->  0
    OFFENSE    0 ->  7
```

- **BREAK'S ROW DOES NOT MOVE AT ALL — still 10 of 12.** The census counts both tags and **BREAK
  stayed on every card**; only its slot changed. That is the demotion working: a straight removal
  would have taken this row to zero, which is what the ruling rejected.
- **OFFENSE GOES 0 → 7 OF 12**, and that is the whole movement. **Seven specs now meet a 2+ OFFENSE
  census on their core kit alone**, which is exactly the trap this table exists to flag: a rune
  written to *ES's* shape asking for 2+ OFFENSE would be on from the first fight for seven of twelve
  heroes with no swap able to turn it off. **A rune written to EZ's shape is unaffected** — that one
  counts the primary over the DRAFTED half and the core is not in the sum.

---

## §6 — THE BATTERY

**94 targets, `sort .ran | uniq -d` ZERO duplicates, 94 names and 94 logs compared both ways, and
0 `Parse Error`, 0 `SCRIPT ERROR`, 0 timeouts across every log** — grepped from the log FILES,
never from a target's own tally.

`check_fd` **87 / 0** (new), `check_ez` **133 / 0**, `check_ek` 46 / 0, `check_el` 23 / 0,
`check_ed` 18 / 0, `test_batch_bo` **1140 / 0**, `check_parse` **168 / 0**, `test_runes` 3839 / 0,
`test_rune_battle` 97 / 0, `check_et` 25 / 0, `check_es` 44 / 0, `test_batch_ax` 356 / 0,
`check_ec` 23 / 0, harness gates **22 / 166 / 8 PASS**, `check_ct_map` 83 / 0.
**`check_de` reads 386 / 0 failures / 0 NOTICES** — every count on its recorded line.

**THE ONLY FOUR `FAIL:` LINES IN THE WHOLE RUN ARE `check_cm_live`'s** — 13 / 4 against a recorded
`fails: [4, 4]`, and **diffed line for line against the same gate's output on the first run**: the
bar on the enemy's attack, its top line naming the incoming blow, and the brace's two magnitudes.
**This batch moved no UI code.** `check_cl_width` and `check_map_screen` report no readable count
**by design**, which is what their rows record.

**THE FREEZE HELD EXACTLY.** An md5 stamp of **342 files, absolute paths, tracked AND untracked**,
before and after over the same path list — **zero differ, and no path added or removed**. The
`check_es` §4 measurement probe above was written, run and **deleted before the freeze was
re-verified**, and the stamp was taken again afterwards and still holds; `check_parse` shows no
residue at 168.

### THE TWO RUNS, AND WHAT THE FIRST ONE WAS FOR

**Run 1 was HEAD's unmodified gates against the new code** (FA §1b), before a single gate was
edited. It returned **six reds across five targets**:

| Target | | |
|---|---|---|
| `test_batch_bo` | 2 of 3 | **predicted — but only two fired.** The third needle, `Run.draft_price()`, went on matching **the paragraph in `shop_screen.gd` that explains why the column is gone**. CLAUDE.md's EV §5 rule from the other side. It reads the comment-stripped source now, through the authored `Gate.strip_comments` rather than a copy. |
| `check_ed` | 2 | **predicted** — the new gate's eight pins unrecorded, and `test_batch_bo`'s three pins broken. (It strips comments, so it saw all three; `test_batch_bo` did not.) The manifest was regenerated **after** this run, never before it — 1371 → 1380 pins. |
| `check_ek` | 1 | **predicted** — `check_fd.gd` is a sixth `TAG_CHECKER`. Listed, not exempted. |
| `check_el` | 1 | **NOT predicted** — Feint. §2 above. |
| `check_ez` | **6 + a THROW**, 132 → 118 | **NOT predicted.** §1 and §4 each hard-coded BREAK as a tag with primaries to draw from. §1 threw at `mk[0]` and **deleted fourteen checks of §5**; §4's 2/2/2 breadth arm came back four cards long and stopped meeting the condition it exists to test, and **its own self-check caught it and named all four breadth runes** — which is precisely what FA §4 built that assertion for. |
| `check_cm_live` | 4 | the recorded sanctioned red, unchanged. |

**`check_ez` IS REPAIRED BY DERIVING THE TAG, NOT BY NAMING A DIFFERENT ONE.** §1 takes the first
tag in `TAG_ORDER` that is neither of the two already used and still carries two primaries; §4 takes
the first three that carry two. **Naming a second word buys the identical failure the next time the
vocabulary moves, and this gate exists because the vocabulary is content.** The +1 in its count
(132 → 133) is §1's new assertion that the derivation **found** a tag — so an empty vocabulary reads
as one failing assertion rather than as a throw that silently deletes a section.

**Run 2 is the acceptance run above.** Nothing was repaired while either battery was running.

### THE POST-RUN DOC EDIT, AND ITS NEEDLE PROOF

`docs/reports/FD.md` — this file — gained §5's table and this section **after** the acceptance run.
`docs/state.md` was written **before** the stamp and is inside the frozen population.

**NOTHING IN THE TREE OPENS EITHER PATH, RE-DERIVED HERE RATHER THAN INHERITED.** Every `.gd` in
the repo was swept **comment-stripped** for `state.md` and `docs/reports`: the only surviving hit is
`check_eb.gd:143`, and it is a **failure MESSAGE** naming `docs/reports/EB.md` inside an `ok()`
string, not a read. No `FileAccess`, `_src`, `load(` or `open(` call anywhere names either path.
