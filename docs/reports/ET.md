# BATCH ET — THE RUNE POOL IS RETIRED

**All 53 offerable runes are retired. The generated stat family survives. Nothing is authored.**

**Retired the way the twelve already are — kept, and SAID to be kept.** Every entry keeps its
`name`, `price`, `payload`, `desc`, `lane` and `scope`, still resolves through `config` / `build` /
`display_name`, and gains a string naming what is lost. **The whole data diff is 53 ADDED LINES —
zero deletions**, and **no file in `scripts/` was touched at all**: the retirement needed no code,
because `is_retired` and its single door were already the shape EO built at §3.

**Six negative controls were armed and all six bit.** Two of them had to be re-armed first, and both
re-arms are reported below rather than quietly fixed — one had corrupted the file instead of testing
the rule, and one had deleted a branch the field was still read through.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

| claim | verdict |
|---|---|
| *"All 53 offerable runes"* (§1) | **HOLDS.** 65 authored, 12 retired at EO §3, **53 live** — derived off the `retired` key, not counted by hand. |
| *"Comet and Flayed Mind grant an ability outright"* (§1) | **WRONG FOR FLAYED MIND, AND WRONG ABOUT WHICH OF THE FOUR IS THE BIG LOSS.** Mind Flay sits in the Occultist's **own** spec draft pool and his own boss pool since DO, and he is the only hero who can buy the rune — so it never granted him anything he could not draft, and once he had drafted it the payload **collided and paid Honed**. §4a. |
| *"Binding Souls and Last Rites grant an ability the hero may already hold"* (§1) | **"MAY" IS TOO WEAK FOR LAST RITES: it could NEVER grant.** Resurrection is the Holy Cleric's PROTECTED CORE, so the payload **always** collided and always paid Quickened — which is why its `desc` is the one honest *"she already knows it"* wording in the pool. Binding Souls holds as stated. §4a. |
| *"Binding Souls and Flayed Mind are the only way a hero obtains a card from outside his own pool"* (§1) | **FALSE FOR FLAYED MIND, TRUE-WITH-A-QUALIFIER FOR BINDING SOULS, AND IT MISSES THE ONE THAT MATTERS.** **Binding Souls is out-of-pool for the Holy Cleric and the Occultist only** — Sacred Resolve is the Devout's own card. And **the brief does not name COMET**, which is defined *inline* in its entry and exists in no pool, kit or tree: **the only ability in the game reachable ONLY through a rune.** §4a. |
| *"`Run.apply_upgrades` turns the collision into Honed or Quickened"* (§1) | **HOLDS, AND WHICH IS WHICH IS DERIVED RATHER THAN GUESSED** — driven through `_collided` and `upgrade_fits`: **Honed** for Mind Flay (it deals damage), **Quickened** for Sacred Resolve and Resurrection (neither does). §4a. |
| *"the roster reads as flat stat sticks"* (preamble) | **HOLDS FOR THE MAJORITY AND NOT FOR ALL, AND THE DIFFERENCE IS WHAT THE STRINGS ARE FOR.** Derived over the whole file: **33 of the 53 write at least one field no other rune writes.** The five splashes are the purest examples of the brief's reading — every one of `duelist`'s, `sentinel`'s and `level_aim`'s terms is shared with a sibling. §1b. |
| *"it is the only thing an offer can contain"* (§2) | **HOLDS, AND IT IS DRIVEN RATHER THAN ASSUMED.** 540 draws through five doors: none empty, none nameless, none payloadless, **and not one retired entry reached a live offer.** §2a. |
| *"ES measured the family at a flat ~30% of offers; it is now 100%"* (§2) | **HOLDS, AND THE FIGURE IS SPEC-DEPENDENT IN A WAY ES's SINGLE ROW DID NOT SHOW.** ES reported the Berserker's 29.9%; measured across four specs before ET it ran **30.1% / 39.0% / 40.2% / 32.4%**, because the share is the templates' fraction of each spec's own pool depth. It is 100% for all twelve now. §2b. |
| *"A suite that asserts a specific rune is offerable will red, and that is correct rather than a defect"* (§2) | **HOLDS — THREE DID, AND THE HAZARD WAS NOT THE RED.** §5. |
| *"ER's three Beastmaster re-authors are moot"* (§4) | **HOLDS.** The Deep Bond, the Turning Pack and the Shared Wild are all `spec:beastmaster` and all three are retired here. §6. |

---

## §1 — RETIRE ALL 53

### §1a — WHAT WAS WRITTEN, AND WHAT THE STRING IS FOR

**`eligible_ids` reads the `retired` key and nothing else.** A bare `"retired": "yes"` would empty
the pool exactly as effectively and record nothing — **so the string is the entire point of the
retirement and the mechanism is incidental.** EO set the standard at §3 and it is the right one:
*"LOST: the only item pairing Chilled's slow with a crit window on HELD enemies."*

`check_et` §1 asserts every entry carries one naming its batch and its loss:
**12 at EO §3, 53 at ET §1, 0 undeclared** — and that nothing is offerable for any of the twelve
specs through the live door.

**EO's TWELVE ARE NOT REWRITTEN.** Verified structurally: the twelve `BATCH EO §3` strings are
byte-identical to `HEAD`, and every `payload`, `price`, `desc`, `lane` and `scope` across all 65 is
unchanged. **`git diff --stat data/runes.json` reads 53 insertions and 0 deletions.**

### §1b — THE STRINGS WERE DERIVED, NOT IMPRESSIONISTIC, AND THE DERIVATION IS THE WORK

The brief warns that *"a retirement string saying 'flat stats' for a rune that did something
specific throws away the one thing worth keeping."* Asked what each rune "really did", an honest
answer for a third of them is *nothing another rune did not also do* — and the only way to know
**which** third is to derive field ownership across the file rather than read the descs.

**Derived over all 65 entries: 33 of the 53 write at least one field NO other rune writes.** That
derivation is what produced the losses worth naming, including:

| entry | what only it did |
|---|---|
| `comet` | its ability exists **nowhere else in the project** — §4a |
| `glass` | the only rune writing `dmg_taken_bonus`, the clause `Runes.PENALTY_FIELDS` exists for |
| `exsanguination` | the only writer of `blood_pact`, which `INVERTED_STAT_FIELDS` exists for |
| `reaper` | `rune_execute_bonus` — **no other writer anywhere in the game**, rune or node |
| `vampiric` | `rune_lifesteal` — likewise; sustain-by-hitting leaves the game with it |
| `white_flame` | `rune_resist_pierce` — the only item thinning enemy RESISTANCE rather than armor |
| `standard` | `rune_vigil_bonus` — the pool's one clause that mitigates for ALLIES |
| `warriors_edge` | `resource_gain` on Strike — the only item changing what a basic BUILDS |
| `seventh_bolt` | `random_hits` on Arcane Barrage — the only item adding a HIT to a multi-hit |
| `loosened_straps` | the only clause whose COST is inherited by the companions |
| `martyr` | the only entry making heals RECEIVED stronger; the other three writers charge |
| `quick_spring` | the one entry the power arm cannot speak for — both terms are INVERTED |

**And the five splashes are where the brief's reading is exactly right.** `duelist`, `sentinel` and
`level_aim` share every one of their terms with a sibling; their strings say so rather than
inventing a loss.

**TWO STRINGS WERE WRITTEN WRONG AND CORRECTED BEFORE THEY SHIPPED**, both by the same
over-claim: `colossus`'s said *"every one of them CHARGES for it"* of the six `max_hp_pct` writers
when `sentinel` pays it forward too, and `standard`'s said it was the only rune whose effect lands
on allies when `sleepless_vigil` and `burning_censer` both heal them. **A further eight said
"nothing reachable does X any more"** where a talent node still writes the bare field beside the
rune's — the EM/EN architecture — and all eight were narrowed to the rune layer.

---

## §2 — THE GENERATED STAT FAMILY SURVIVES

**Kept exactly as it was**: +10 max HP / +2% armor / +4 Speed / +12 Constitution / +2% crit / +8
max Mana, 50g. **No magnitude moved and no price was chosen.**

### §2a — THE FALLBACK, DRIVEN THROUGH EVERY DOOR

**`master.html` said an exhausted pool falls back to the generated family and the offer list never
comes back empty. That was a sentence about an edge case while 53 runes stood in front of it; it is
the ordinary path now, on the first Peddler of every run.** So it is driven.

`check_et` §2, **540 draws across all twelve specs through five doors**:

| door | what it exercises |
|---|---|
| `run.generate_rune` | **the Peddler** and the elite cache's single-rune path |
| `run.roll_rune_candidates` ×40 a spec | **the elite cache's pick-of-three, WITHOUT REPLACEMENT** — a Warrior has five markers against three draws, the tightest this gets |
| `run.grant_rune` | **the grant door** — the rich arm and the `rune_grant` map event |
| `run.generate_rune` on a full pouch | **the exhaustion floor**, at a pouch holding every template there is |

**None came back empty, none nameless, none with an empty payload, no cache triple repeated a name,
and not one retired entry reached a live offer.**

### §2b — WHAT MOVED IN THE OFFER, MEASURED BEFORE AND AFTER

*Through `Runes.generate` on the live door, empty pouch. The "before" arm was taken on unmodified
`HEAD` before a line was changed.*

| spec | eligible authored | stat-stick share BEFORE | AFTER | distinct runes before a repeat, BEFORE → AFTER |
|---|---|---|---|---|
| berserker | 11 | 30.1% | **100%** | 16 → **5** |
| cryomancer | 10 | 39.0% | **100%** | 16 → **6** |
| occultist | 9 | 40.2% | **100%** | 15 → **6** |
| beastmaster | 12 | 32.4% | **100%** | 18 → **6** |
| *(all twelve)* | 9–12 | ~30–40% | **100%** | **15–18 → 5–6** |

**THE EXHAUSTION FLOOR IS THE ONE BEHAVIOUR CHANGE A PLAYER COULD SEE.** It is the same code; it
used to sit behind 9–12 authored entries and it is five or six draws away now (six outside the
Warrior class, where `max_resource` is excluded). Past it, `generate` returns a template the hero
already owns rather than nothing — which is the contract, and it is asserted rather than assumed.

### §2c — EVERY RUNE CONSUMER, REPORTED

| consumer | path | verdict |
|---|---|---|
| **the Peddler** | `shop_screen` → `Run.generate_rune` | **survives** — driven, 12 specs |
| **the elite cache** | `map_screen` → `Run.roll_rune_candidates` | **survives** — 480 triples, all three distinct |
| **the grant door** | `events.gd` `rune_grant`, `run_sim` rich arm → `Run.grant_rune` | **survives** — falls through to the ordinary roll |
| **boss trophies** | `Runes.kit_names` reads `bm_abilities` for `requires_ability` | **untouched** — the kit half of eligibility is unchanged |
| **`eligible_ids`** | the single door | **returns empty for all twelve, by ruling** |
| **the swap panel** | `map_screen._open_rune_panel`, `Run.rune_slots()` = 3 | **survives** — driven live in `check_flow` |
| **the hero sheet** | `party_screen._draw_detail` | **survives** — reads `member["runes"]`, which fills with stat sticks |
| **`test_rune_battle`** | walks `Runes.ids()`, not the offer pool | **97 / 0, unchanged** |
| **`test_runes`** | four sections reach the doors | **3118 → 3022**, §5 |
| **`check_es`** | §2 reached `eligible_ids` | **42 → 43**, §5 |
| **`check_flow`, `test_batch_an`** | roll a triple and a worn rune | **green** — both handle a template pool |
| **`check_em`, `check_dp`, `check_ea`, `test_batch_ak/au/aw/ax/ay/az/ba/be/bj/bs/bx`** | read `config` / `build` / the raw JSON | **green** — retirement changes no payload |

---

## §3 — WHAT THE GAME IS LIKE MEANWHILE

**Sparse, not broken, and the distinction is measured rather than asserted.**

*30 complete sim runs on the retired pool, `route=balanced`, rung 1.*

| | ET (retired pool, `runes=full`) | control (`DOD_SIM_RUNES=stats`) |
|---|---|---|
| runs completed | **30 of 30 (100%)** | 30 of 30 (100%) |
| wiped | **0** | 0 |
| depth | **48.00 ± 0.00 of 49** | 48.00 of 49 |
| `ratio@z1t8` | 1.228 | 1.287 |
| shop runes offered / bought a run | **16.03 / 8.23** | 14.67 / 8.37 |
| elite runes won with no free slot | 5.87/run | 5.60/run |

**THE CONTROL IS THE POINT OF THAT TABLE.** `DOD_SIM_RUNES=stats` is the pre-existing flag for
"generated stat family only", so ET's `full` arm should now behave as the `stats` arm — **and it
does**, on completion, wipes, depth and the whole rune economy. The residual difference in offers
(16.03 against 14.67) is a real one and worth naming: the `stats` arm calls `template_rune`
directly while `full` goes through `generate`'s marker pool, so the two dedupe against the pouch by
slightly different paths.

**WHAT A PLAYER WOULD SEE.** An offer shows a generated stat stick with the *Universal* scope band
where the rarity word used to be; the three slots fill with them; the run completes. **The visible
consequence is that rune-shaped clauses read zero** — the run report's Faith-by-source line now
prints *"Binding Oath 0.00 | opening rune 0.00"*, which is `binding_oath` and `long_draw` being
unobtainable, exactly as ruled.

**NOTHING READS AS BROKEN.** No empty offer, no empty pouch slot, no blank shop row, no crash, no
change in completion or depth.

---

## §4 — THE FOUR ABILITY-GRANTING ENTRIES

### §4a — DERIVED THROUGH THE LIVE DOORS, AND THE BRIEF'S GROUPING WAS WRONG IN BOTH DIRECTIONS

*Classified by `Run.draft_pool_left` (what a hero can actually draw) and `Classes.protected_names`
(what he starts with), not off a table. Printed by `check_et` §4 every battery run.*

| entry | grants | who can buy | out-of-pool for | always collides for | fallback paid |
|---|---|---|---|---|---|
| `comet` | **Comet** | 3 Mage specs | **all three** | — | never collides |
| `binding_souls` | Sacred Resolve | 3 Cleric specs | **Holy, Occultist** | — | **Quickened** for the Devout |
| `flayed_mind` | Mind Flay | Occultist only | **nobody** | — | **Honed** |
| `last_rites` | Resurrection | Holy only | **nobody** | **Holy** | **Quickened** |

**THE RUNE OF THE COMET IS THE LARGEST SINGLE LOSS IN THE BATCH AND THE BRIEF DOES NOT NAME IT.**
COMET is defined *inline* in the entry's `new_ability` payload — `Classes.pending_talent_ability`
returns null for it, because there is nothing else to resolve. It is in no draft pool, no boss pool,
no talent tree and no protected core. **It is the only ability in the game reachable ONLY through a
rune**, so retiring the entry removes an ability outright, and **the entry holds the only copy of its
definition**: deleting it would delete the ability. `check_et` §4 pins that population at exactly
one, so a batch that deletes the entry — or quietly re-homes COMET into the shared resolver — has to
come and say so. **Control 4 armed exactly that and it bit.**

**FLAYED MIND WAS A SHORTCUT, NOT AN UNLOCK.** What is lost is the 160g option of skipping the
draft for a card the Occultist can already draw, and — when he had already drawn it — an upgrade.

**LAST RITES COULD NEVER GRANT AT ALL.** Its `desc` has always said so.

### §4b — THE STANDING RULES THIS TOUCHES, AND WHY THEY OUTLIVE THE RUNES

`CLAUDE.md` carries two rules built on these entries and **neither is weakened**:

- ***"A rune grant resolves through `Classes.pending_talent_ability`, not through the draft
  resolver … assert every rune grant still resolves."*** Retiring the runes does not retire that
  hazard — **it hides it**, because nothing offers the rune that would have failed. `check_et` §3
  drives all four grants through the real resolver anyway.
- ***"A rune that duplicates a draft card's grant is not a dead rune."*** Still true, and §4a is now
  the derived table behind it rather than an example.

---

## §5 — THE ASSERTIONS THAT HAD TO MOVE, AND THE REPAIR THAT WOULD HAVE BEEN SILENT

**Three checks asserted the pool was non-empty. All three went red at ET — and red was the easy
case. The hazard was the shape of the repair.**

Each had a one-line fix that produces a green file: **skip retired entries.** `_reachable` would
then have looped over nothing; `_rich_grant`'s grant loop would have run zero times; `check_es` §2
would have watched an empty set. **All three would print exactly like a clean run**, with the
coverage gone and no diff to point at. This is EO's own lesson from `test_rune_battle`, arriving one
file over and three times at once.

| site | what it asserted | what it asserts now |
|---|---|---|
| `test_runes._rich_grant` | `own > 0` — *"the retirement left its own set empty"*, on all twelve specs | **two-armed**: where a spec has surviving spec runes they must reach its hero without repeating; where it has none, **the FALLBACK must be what answers and must not return a spec rune** |
| `test_runes._start_rune_pool` | a 20–70% band on spec runes in a cache triple | **two-armed off the pool**: the band when any spec rune is eligible, **exactly zero** when none is — which still catches a retired rune leaking into a triple |
| `check_es` §2 | the five universals roll for all twelve specs | **re-pointed and WIDER**: every entry a spec cannot draw must be undrawable **because it is retired** — over all 65, not the five |
| `test_runes._reachable` | *(was not red for the right reason)* — it skipped any hero who could not currently ROLL the rune, so nine `requires_ability` entries read unreachable | **re-pointed from offerability onto SCOPE**, because *"does this rune name an ability its hero can hold"* is a question about the AUTHORED entry. Offerability is `_eligibility`'s question and is asserted there in both directions |

**EVERY ONE OF THE ORIGINAL ARMS COMES BACK ON ITS OWN THE DAY A RUNE IS AUTHORED, AND THAT IS
MEASURED RATHER THAN CLAIMED — CONTROL 6.**

**AND `check_es` §2 CAME BACK WIDER THAN IT WAS.** What ES §2 was guarding is narrower than the form
it took: a **stealth** retirement through an **eligibility rule** — a rune made undrawable by a scope
that stops resolving, a class key naming nothing, or a filter that quietly excludes it. **A declared
retirement is the opposite of that.** The re-pointed arm still catches the first over a population
of 65 where it watched five.

### §5b — AND ONE MEASUREMENT WENT DORMANT RATHER THAN WRONG

`check_es` §1 measures that the offer is flat across zone slots, which was ES's own ruling. With the
pool empty it reads **100.0% / 100.0% / 100.0%**: **flat, passing, and unfalsifiable.** A
re-invented tier could not show in it.

**A vacuous check prints exactly like a clean one**, so it prints `DORMANT` beside its reading and
names the condition that wakes it. Nothing was deleted and nothing was loosened.

---

## §6 — WHAT IS DELIBERATELY NOT DONE

- **NOT ONE RUNE IS AUTHORED, SKETCHED OR RESERVED.** No clause is proposed, no option list is
  offered, and no magnitude moved anywhere in `data/runes.json`.
- **NO PRICE IS CHOSEN.** Flat pricing is ruled; the number is not, and with the pool empty there is
  nothing to price. The 53 still carry 50 / 75 / 100 / 120 / 160 in the data, unmoved.
- **ES's TAG-READING MACHINERY IS UNTOUCHED AND STILL READS NOTHING.** `Runes.tag_threshold_met`,
  `Runes.breadth_met`, `Classes.tag_census` / `tag_count` / `tag_breadth` and
  `Run.loadout_ability_names` all stand, and `check_es` §4/§5 still drive them.
- **ER's THREE BEASTMASTER RE-AUTHORS ARE MOOT AND THE QUEUE NO LONGER CARRIES THEM AS OWED.** The
  Deep Bond, the Turning Pack and the Shared Wild are all `spec:beastmaster` and all three are
  retired here. **The measurements survive them and are worth keeping** — the Turning Pack's first
  clause being worth zero to any Beastmaster holding Quick Whistle, Feral Momentum's +8% being worth
  ~+9.9% rather than +24%, and the companion-death event at 0.22 a trash fight — because they are
  facts about the *systems*, and the next pool is authored against the same systems.
- **NO SOURCE FILE IN `scripts/` WAS TOUCHED.** Named because it looks like an omission and is not:
  `is_retired` and its single door were already the shape EO built at §3, so ET is a data change and
  three assertion repairs.

---

## §7 — WHAT THE RETIREMENT STRANDS, AND WHY IT IS WORTH A GATE

**72 of the 84 stat fields the retired pool writes have `data/runes.json` as their only writer in
the project.** (Over ET's own 53 entries alone it is **48 of 60**.) Their read sites in `battle.gd`
and `unit.gd` still stand and **can never fire**.

**This is a worse hazard than dead code, because it is indistinguishable from dead code by every
instrument here.** A later batch sweeping for unreachable branches finds 72 of them, all genuinely
unreachable, all correct to delete on the evidence available — and deleting any one of them deletes
a mechanic the pool is explicitly meant to come back to.

**`check_dp` §4 ASSERTS THE FORWARD DIRECTION AND WOULD GO ON PASSING THROUGH EXACTLY THAT MOVE** —
*"every stat field any rune writes has a live read site"* is still true when the field is deleted
from `runes.json` **alongside** its branches. **That is not a guess: control 5 is two-armed and
measured it.**

So `check_et` §5 pins the population as an **asymmetric ratchet**: it may GROW (a rune authored onto
a new field raises the floor by doing nothing) and it may not SHRINK without a line changing there.

---

## §8 — VERIFICATION

### The six negative controls, and all six bit

| # | control | armed on | armed reading | disarmed |
|---|---|---|---|---|
| **1** | **§1's declarative rule** — one entry's string replaced with a bare `"retired": "yes"` | `data/runes.json` (`anchor`), the file left VALID and at 65 entries | `check_et` **23 / 2** — *"`anchor (string names no batch or no loss)` carry no retirement record"*, and *"52 entries carry ET's retirement, expected 53"* | 23 / 0 |
| **2** | **§2's exhaustion fallback** — `generate` returns `{}` on an empty pool | `Runes.generate` | `check_et` **23 / 1** naming five specs' exhausted draws; `test_runes` **2844 / 2** (*"exhausted pool returned an empty offer"*, *"offer with no name"*) | 23 / 0; 3022 / 0 |
| **3** | **the retirement filter** — `eligible_ids` stops reading the key | `Runes.eligible_ids` | `check_et` **23 / 2** (offerable entries named, and *"a RETIRED authored entry reached a live offer"*); `test_runes` **3142 / 48** | 23 / 0; 3022 / 0 |
| **4** | **§4's comet ratchet** — COMET re-homed into the shared resolver | `Classes.pending_talent_ability` | `check_et` **23 / 1** — *"the rune-only ability population is [], not the recorded [comet -> Comet]"* | 23 / 0 |
| **5** | **§7's stranding, TWO-ARMED** — a mechanic deleted WHOLE: `reaper`'s payload term re-keyed and every `rune_execute_bonus` read site removed from `battle.gd` **and** `unit.gd` | `data/runes.json` + two scripts | **`check_dp` 48 / 0 — GREEN, which is the claim** — and `check_et` **23 / 1**: *"71 fields are rune-only, below the floor of 72"* | 48 / 0; 23 / 0 |
| **6** | **do the two-armed repairs come back?** — ONE rune (`warpath`) un-retired | `data/runes.json` | `test_runes` **3023 / 1** — the count rises by one as `_rich_grant`'s live arm replaces its empty arm, and the BAND arm fires: *"a spec rune is in the cache triple 6% of the time — outside the 20-70% band"*. `check_et` **23 / 4**. `check_es` **43 / 0**, correctly — `warpath` is drawable, so nothing is silently absent | 3022 / 0; 23 / 0; 43 / 0 |

**CONTROL 5 IS THE ONE THAT MATTERS, AND IT IS THE ONLY TWO-ARMED ONE.** Arming an injection and
watching the new gate go red proves only that the new code works. Arming the *same* injection
against the instrument that was supposed to cover it is what shows the gap is real: **`check_dp`
reads 48 / 0 through a deletion that removes a mechanic from the game.**

**CONTROL 6 IS THE ONE THAT PROVES A CLAIM RATHER THAN A MECHANISM.** *"Each comes back on its own
the day a rune is authored"* is the load-bearing sentence of §5, and un-retiring one entry
demonstrates it rather than asserting it — including the band arm firing on real data.

**TWO CONTROLS HAD TO BE RE-ARMED, AND BOTH FAILURES ARE REPORTED RATHER THAN QUIETLY FIXED:**

- **Control 1's first arming CORRUPTED THE FILE** instead of testing the rule. It read `check_et`
  **21 / 7** with *"the authored pool is 0 entries"* — which is a control on the JSON parser, not on
  §1. **A control that breaks the file is not a control**, and its seven failures were reassuring for
  the wrong reason. Re-armed with a valid-JSON edit and an assertion that the file still parses at
  65 entries, it bites at 2.
- **Control 5's first arming DID NOT BITE (23 / 0)**, and the check was right: it deleted
  `rune_execute_bonus` from `battle.gd` only, and **`unit.gd` still declared it**, so the field was
  still read somewhere. The injection was incomplete, not the assertion — and repairing the
  *injection* is what turned it into the two-armed control above.

### The literal-flip sweep

**11,424 distinct needles ≥ 4 characters from 93 targets, against every tracked document at `HEAD`
and in the working tree.**

| document | LOST | GAINED |
|---|---|---|
| `CLAUDE.md` | **0** | 2 |
| `docs/master.html` | **0** | 2 |
| `docs/changelog.html` | **0** | 2 |
| `docs/design-notes.md` | **0** | 1 |
| `baselines.json` | **0** | 6 |
| `data/runes.json` | **0** | 58 |
| `pin-manifest.json`, `run_battery.sh` | **0** | 0 |
| `docs/text-standard.html`, `data/glossary.json` | *unchanged* | |
| `docs/state.md` | **19** | 13 |

**THE 19 IN `docs/state.md` ARE TRACED RATHER THAN WAVED THROUGH: nothing reads that file.** Every
target naming it does so in a COMMENT, and `claude_md_census.py` — the one instrument that can quote
against it — **excludes it by default (EE §2)**. The nineteen are words that stood in ES's WHERE
block and do not stand in ET's (`DOD_SIM_RUNE_POWER`, `party_screen.gd`, `blood_pact`,
`dmg_taken_bonus` and fifteen more), which is what "rewritten every batch" means.

**THE 58 GAINED IN `data/runes.json` ARE THE HAZARD, NOT THE LOST**, because a gained needle can
turn a red absence-assertion green. Every one is prose inside a retirement string. The absence pins
that could have been flipped are key checks (`has("rarity")`, `has("scarred")`) rather than text
checks, and the dead-counter sweeps in `test_batch_ax` / `aw` / `be` name `*_ranks` forms that no
string uses. **All three suites were run before the battery: 352 / 0, 351 / 0, 34 / 0.**

### The retired-word pre-check, run before the battery — AND IT CAUGHT THREE

Reproducing `test_batch_bx` §4's and §4b's own strips against the EDITED files, rather than trusting
the literal sweep, which cannot see this class of fault:

**THREE RETIREMENT STRINGS VIOLATED A RETIRED VOCABULARY AND WOULD HAVE COST A BATTERY.**
`standard`'s said *"PARTY-WIDE MITIGATION"*, `burning_censer`'s said *"party heal"*, and
`loosened_straps`'s said *"every beast he calls"* — all three inside `data/runes.json`, which both
sweeps read. Reworded to *"MITIGATES FOR ALLIES"*, *"an ALLY-WIDE heal"* and *"every companion he
calls"*. **Re-run after the fix: `party` absent from all four data files and `master.html` after the
five `PARTY_IDENTS`; `beast` absent from `glossary.json`, `runes.json` and `master.html` after both
casings of `beastmaster`. `test_batch_bx` reads 161 / 0.**

### The pin manifest

**Run against `HEAD`'s manifest BEFORE regenerating: `check_ed` 18 / 0** — ET introduced no
unrecorded pin and broke none that was recorded. **Regenerated: 1353 → 1353, 8 GAINED and 8 LOST,
and every pair is the same pin at a moved line number** (`test_runes.gd#194 → #197`,
`check_es.gd#94 → #96`), which is the comment blocks added above them. **`check_ed` reads 18 / 0
after regeneration too.**

### Baseline rows

**FOUR ROWS, ALL WRITTEN BEFORE THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS EACH.**

| row | before | after | why |
|---|---|---|---|
| `test_runes` | [3118, 3118] | **[3022, 3022]** | **−96, counted off the diff and located BEFORE a line was changed**: the unrepaired tree read exactly 3010 (= 3118 − 108), which put the whole fall in `_rich_grant`. It goes 132 → 36: 12 (`own > 0`) + 36×3 (a grant per surviving spec rune) + 12 becomes 12×2 (the two-armed block) + 0 + 12. **No other section moved a count** — the other two repairs are one `ok()` either way |
| `check_es` | [42, 42] | **[43, 43]** | +1 — §2's re-pointed arm asks its question over all 65 entries as well as over the five |
| `check_parse` | [162, 162] | **[163, 163]** | +1 — **its count IS its coverage**, so `check_et` joining the battery raises it the same day. RESIDUE unchanged at 4 |
| `check_et` | — | **[23, 23]** | new |

**`check_de` HAS NO ROW OF ITS OWN**, so its own +4 for a new gate is reported by nothing; it is
predicted here at **362 → 366**.

### The gate's own hygiene

`check_et` reads only `Runes`, the data and `Run`'s own doors — **`Run.draft_pool_left` is the single
door the real draft reads**, so §4 gets both pools without naming either accessor. It therefore trips
neither `check_da` §3 fingerprint and **needs no exemption**, confirmed live before the battery:
**`check_da` 41 / 0 over 44 gates and 47 suites, 0 hand-rolled walks, 1 exempt** — `RETURN_WALK_EXEMPT`
still at one, which `check_dw` pins.

**AND ITS FLOOR WAS WRONG ON THE FIRST READING AND WAS CORRECTED BEFORE THE BATTERY.**
`RUNE_ONLY_FIELD_FLOOR` was written as **48**, which is the figure for ET's own 53 entries, while
the sweep walks all **65** and reads **72**. A floor of 48 against a live 72 is slack a deletion fits
through — **two dozen fields could have gone without a word.** It is the live number now.


### The battery

**46 suites, 37 gates, the three run-harness gates and both scene runs, plus the count differ —
89 targets. ZERO reds, zero throws, zero timeouts.**

| target | reading |
|---|---|
| **all 46 suites** | **0 failures, 0 throws** |
| `test_runes` | **3022 / 0** — the new baseline exactly |
| `test_rune_battle` | **97 / 0** — unmoved, with all 65 entries retired |
| `check_et` | **23 / 0** |
| `check_es` | **43 / 0** |
| `check_parse` | **163 / 0** |
| `check_da` | **41 / 0** — 0 hand-rolled walks, 1 exempt |
| `check_dp` | **48 / 0** | 
| `check_ed` | **18 / 0** |
| `check_em` | **223 / 0** |
| `check_ek`, `check_eh`, `check_eg` | 45 / 0, 175 / 0, 68 / 0 |
| run-harness gates 1 / 2 / 3 | **PASS** (22, 166, 8 checks) |
| `check_map_screen` | **OK** |
| `check_ct_map` | **83 / 0** |
| **`check_de` (the count differ)** | **366 / 0 failures / 0 NOTICES** — predicted at 362 → 366 before the run |

**`check_cm_live` reads 13 / 4 and that is the baseline** — `fails: [4, 4]`, *"THE ONE RED THAT IS
ON PURPOSE. Identical on unmodified HEAD."* It is the only red in the battery and it is the same
one it has always been.

**ZERO NOTICES FROM `check_de` IS THE LOAD-BEARING LINE**: every baseline row — including the four
this batch moved — matched what the logs said, so no count fell or rose unpredicted anywhere in the
tree.

**AND THE PARSE CHECK WAS READ OFF STDERR RATHER THAN OFF A TALLY**: `grep -rlE 'Parse Error|SCRIPT
ERROR'` over all 89 battery logs returns nothing, and a direct `check_parse` run with stdout
discarded prints nothing on stderr.

### The freeze

**The tree the battery read is the tree that is committed.** Every control restored from a
scratchpad copy — never `git checkout` — and verified byte-identical by `cmp`; `md5` over the six
perturbed files plus `scripts/classes.gd` and `scripts/unit.gd` matches the pre-control stamp
exactly. Only `docs/state.md` and this report were written after the battery began, and **nothing in
the project reads either**: every target naming `state.md` does so in a comment, and
`claude_md_census.py` — the one instrument that can quote against it — excludes it by default.
