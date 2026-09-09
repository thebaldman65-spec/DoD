# BATCH FN — THE EIGHT GATED RUNES COME OFF THEIR CONDITIONS

*2026-09-08. Full working. `docs/state.md` carries the summary; this file carries the evidence.*

**THRESHOLD and BREADTH are retired and the eight runes that still carried them are
unconditional.** The payload condition, the shape label and the clause on the card came off all
eight together, and with the last payload gone the reading machinery had no reader left.

**THE MEASUREMENT IS THE HALF NOTHING HAD DONE.** The brief asked what the seven other conditions
were actually costing, since only Bracing Line's *level* had ever been priced. **The spread is
enormous and two of the eight were unreachable at a full bar.**

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

**Fourteen checkable claims. Thirteen held. One is unverifiable from the repo and is marked as
such — and two of the thirteen held in a way that changed what had to be written.**

| # | Premise | Verdict |
|---|---|---|
| 1 | THRESHOLD and BREADTH were retired at FK; eight runes still carry them | **HELD** — `check_fk.STILL_GATED`, and all eight carried both condition and label |
| 2 | …and they are the last users of the machinery | **HELD** — a census of all 126 entries found exactly those eight `condition` keys, and **`Talents.condition_met` was the only game-side caller of the door** |
| 3 | At a flat 100g a gated rune is strictly worse than a bare one | **HELD** — all eight are `"price": 100` in the data |
| 4 | BREAK can never carry a THRESHOLD — zero of 227 cards have it as a primary since FD | **HELD** — FD §2's ruling, `check_fd` §2 asserts it |
| 5 | The Devout can never satisfy BREADTH — two distinct primaries against a rule needing three | **HELD, RE-DERIVED** — his 17 earnable cards are DEFENSE 14 / OFFENSE 3. Exactly two |
| 6 | A condition can be live at one bar size and dead at the next | **HELD, AND NOW MEASURED ON THE FOUR SPECS THAT ACTUALLY CARRY THESE RUNES** — the Wide Rite is 2.1% at four drafted cards, **0.0% at five**, 3.6% at six and **0.0% at seven**. §1 |
| 7 | **IT IS EIGHT, NOT SIX**, and eleven lines across five files say six | **HELD** — the eleven located and all eleven corrected. §4 |
| 8 | The eleven include a brief that enumerated 4 + 4 and called it six | **UNVERIFIABLE FROM THE REPO** — FK's brief is not a tracked file. FL §2a records it; nothing here can check it |
| 9 | Bracing Line's 8.98% prices the LEVEL, not the condition — measured with the threshold assumed met | **HELD** — `battle.gd:10049`'s read site tests `passive_id == "heavy_plating"` and `plating_bonus * 100 >= BRACING_LINE_LEVEL` and **never sees a tag** |
| 10 | Anything in the record saying otherwise is wrong and should be corrected | **HELD AND ALREADY DONE — THERE WAS NOTHING LEFT TO CORRECT.** Both readable copies (`docs/state.md`'s queue item and the changelog's FL entry) already state it FL's way. Swept: no file in the tree prices 8.98% as the condition's rate |
| 11 | Nothing has measured the other seven's conditions | **HELD** — `docs/spec-recon.html`'s tag-spread tables cover the **eight UNAUTHORED specs**, not the four that carry these runes. §1 is new work |
| 12 | `Classes.tag_count` and the census are read by `check_es` §4's per-spec table | **HELD** — `check_es.gd:544/560/581/609/633/644` |
| 13 | The `.docx` ruling exists only in a closed report and contradicts the Working agreement | **HELD** — `docs/reports/FH.md` §4 and nowhere else; step (3) required the rebuild. §3 |
| 14 | FM found "five per hero" wrong in both directions and five empty branches reachable at once | **HELD** — `docs/reports/FM.md` §0 and §2 |

· **PREMISE 2 IS THE ONE THAT MADE §2 SAFE TO TAKE.** "They are the last users" is a claim about
  a whole population, and it was checked as one rather than read off the brief: **no entry in
  `data/runes.json`, live or retired, carries a `condition` other than those eight**, and **no
  file under `data/` carries `tag_threshold` or `tag_breadth` at all.** Had a talent payload
  carried one, removing the door would have silently unconditioned a talent.

---

## §1 — WHAT UNGATING ACTUALLY CHANGES, PER RUNE

### THE METHOD, STATED BEFORE THE NUMBERS

**The condition depends only on the multiset of PRIMARY tags in a hero's drafted cards**, so the
question *"how often was it met"* has an exact combinatorial answer rather than a sampled one:
**over every distinct set of `n` cards a hero could draft, what share satisfies the clause.**
Counted exactly, by summing the multivariate hypergeometric weight of every tag composition — no
sampling, no seed, no simulation.

- **THE POOL IS THE RECON'S OWN UNION** — boss pool + spec draft pool + class draft pool, which is
  what `docs/spec-recon.html` calls a spec's *earnable* cards. **A second, tighter reading drops
  the boss trophies** and is reported beside it; the two agree on every headline.
- **THE BAR SIZES ARE THE LADDER'S.** `ability_slot_cap()` is `[7, 8, 9, 10]` by zone bosses
  cleared, minus `core_slots`, which is **3 for all four of these specs** — so the drafted half
  runs **4 → 7**, one size per rung.
- **WHAT THIS IS AND IS NOT.** It is the share of a hero's BUILD SPACE the condition permits —
  how much of what he could build he must give up to switch the rune on. **It is not a play
  frequency**: a player who wants the rune builds for it. Both readings of the number are useful
  and the first is the one that prices a constraint.

### THE EIGHT, MEASURED — EARNABLE-POOL READING

| Rune | Spec | Shape | Tag | n=4 | n=5 | n=6 | n=7 | mean |
|---|---|---|---|---|---|---|---|---|
| **Deepening Hex** | Occultist | THRESHOLD | DEBUFF | 83.8% | 68.6% | 85.5% | 73.2% | **77.8%** |
| **Bracing Line** | Warden | THRESHOLD | DEFENSE | 47.5% | 23.7% | 37.8% | 18.2% | **31.8%** |
| **Long Watch** | Warden | BREADTH | — | 18.2% | 4.8% | 39.0% | 20.3% | **20.6%** |
| **Wide Watch** | Sharpshooter | BREADTH | — | 12.1% | 1.8% | 29.8% | 13.9% | **14.4%** |
| **Answering Pack** | Beastmaster | THRESHOLD | DEFENSE | 22.8% | 6.3% | 11.5% | 2.5% | **10.8%** |
| **Shared Scent** | Beastmaster | BREADTH | — | 8.4% | 1.1% | 18.4% | 6.5% | **8.6%** |
| **Heavy Bolts** | Sharpshooter | THRESHOLD | MARK | 8.0% | 0.8% | 1.5% | **0.0%** | **2.6%** |
| **Wide Rite** | Occultist | BREADTH | — | 2.1% | **0.0%** | 3.6% | **0.0%** | **1.4%** |

### AND THE DRAFT-ONLY READING, WHICH AGREES

| Rune | n=4 | n=5 | n=6 | n=7 | mean |
|---|---|---|---|---|---|
| Deepening Hex | 80.8% | 63.5% | 81.8% | 67.1% | 73.3% |
| Bracing Line | 36.5% | 13.9% | 24.2% | 7.7% | 20.6% |
| Long Watch | 24.7% | 7.8% | 52.9% | 33.0% | 29.6% |
| Wide Watch | 7.9% | **0.0%** | 24.7% | 9.4% | 10.5% |
| Answering Pack | 24.5% | 6.3% | 11.8% | 1.9% | 11.1% |
| Shared Scent | 10.1% | 1.5% | 21.4% | 7.3% | 10.1% |
| Heavy Bolts | 13.6% | 1.8% | 3.6% | **0.0%** | 4.7% |
| Wide Rite | 2.5% | **0.0%** | 4.5% | **0.0%** | 1.7% |

**THE POOLS THE FIGURES ARE OVER:**

| Spec | Earnable | Distinct primaries | Spread |
|---|---|---|---|
| Occultist | 17 | **4** | DEBUFF 10 · DEFENSE 5 · OFFENSE 1 · MARK 1 |
| Warden | 19 | **6** | DEFENSE 7 · OFFENSE 6 · DEBUFF 2 · RESOURCE 2 · TEMPO 1 · MARK 1 |
| Sharpshooter | 21 | **5** | OFFENSE 10 · DEBUFF 4 · DEFENSE 3 · MARK 3 · TEMPO 1 |
| Beastmaster | 21 | **5** | OFFENSE 11 · DEFENSE 5 · DEBUFF 2 · MARK 2 · TEMPO 1 |

### THE THREE THINGS THAT COME OUT OF THAT TABLE

**(1) TWO OF THE EIGHT ARE UNREACHABLE AT A FULL BAR, AND THE ARITHMETIC IS EXACT RATHER THAN
STATISTICAL.**

- **HEAVY BOLTS DIES AT THE TOP OF THE LADDER.** `count(MARK) * 2 >= 7` needs **four** MARK cards.
  **The Sharpshooter's whole earnable pool holds three.** A fully-laddered Sharpshooter — seven
  drafted cards, three zone bosses down — **cannot switch this rune on by any play.** It is not
  rare; it is impossible, and it becomes impossible exactly when a run is at its most invested.
- **THE WIDE RITE IS DEAD AT TWO OF FOUR RUNGS.** BREADTH needs `peak * 3 <= n`. At **n=5** that
  is a peak of 1, which needs five distinct primaries and the Occultist's pool holds four. At
  **n=7** it is a peak of 2, and 2+2+1+1 = **6 < 7** — his OFFENSE and MARK columns hold one card
  each, so the bar cannot be filled without a third of it sharing a tag. **Live at four and six,
  dead at five and seven.** FJ predicted this shape on the Holy and the Swordmaster; it is worse
  here, and it is on a rune that shipped.
- **AND THE WIDE WATCH IS DEAD AT n=5 WITHOUT A BOSS TROPHY.** Its 1.8% at five is carried
  entirely by the one TEMPO card in the Sharpshooter's BOSS pool; on draft alone it reads **0.0%**.
  A rune whose condition depends on winning a specific boss pick is not a rune with a lever.

**(2) THE OTHER SIX RANGE FROM "NEARLY FREE" TO "NEARLY DEAD", AND THE SPREAD IS 55× WIDE.**
Deepening Hex held on **77.8%** of the Occultist's build space and the Wide Rite on **1.4%** of
the same hero's. **Both were sold at 100g, and both wore the same word on the card.** The one
number the shape never had was a price, and the one thing a condition should be is comparable.

**(3) THE ODD/EVEN ALTERNATION IS THE LADDER'S, NOT A MEASUREMENT ARTEFACT.** Every BREADTH row
dips at n=5 and n=7 and rises at n=4 and n=6, because `peak * 3 <= n` is a step function on an
integer denominator: at 6 a peak of 2 exactly reaches, at 7 it does not. **A player's rune blinks
off when he clears a zone boss** — which is the moment the game has just rewarded him.

### WHERE A MAGNITUDE WAS CHOSEN AGAINST THE GATE — FLAGGED, NOT RETUNED

**Not one magnitude moved in this batch.** The two the record touches:

- **BRACING LINE'S LEVEL OF 32 IS UNTOUCHED AND THE RECORD IS ALREADY RIGHT.** `docs/reports/EZ.md`
  §2b(i) measured **8.98%** of incoming hits (11.91% with the Standing Wall, n = 200,000 an arm)
  **with the threshold assumed met** — so the figure prices Heavy Plating's +32% LEVEL, which is a
  gate in `battle.gd` that never saw a tag. **Ungating does not invalidate what 32 was ruled
  against; it makes that figure true.** FL §2b corrected this and both readable copies already say
  so — **the sweep found nothing left to correct**, which is premise 10 answered by measurement
  rather than by edit.
- **HEAVY BOLTS' 20 IS A CONVERSION AND NOT A GAIN, WHICH IS WORTH SAYING BECAUSE IT READS LIKE
  ONE.** `focus_convert()` is `maxi(100 - deep_focus - rune_deep_focus - rune_heavy_bolts, 1)`, and
  `focus_crit_chance` is `min(focus, convert) * 0.005` while `focus_crit_mult` is
  `max(focus - convert, 0) * 0.005`. **Dropping the point 100 → 80 trades ten percentage points off
  the crit-chance ceiling for multiplier sooner.** It is additive with the Deep Focus node (40) and
  the Rune of the Deep Sight (8): a Sharpshooter holding all three converts at **32**.

### **THREE OF THE EIGHT CARRY A SECOND GATE THAT WAS NEVER THE SECONDARY — AND ONLY ONE WAS ON THE RECORD**

**FL §2b named the shape off Bracing Line and warned that whoever repairs the eight should read
each read site before assuming the label is the whole condition. Reading all eight found two
more, and both are worse than Bracing Line's, because both make the rune worth EXACTLY ZERO.**

| Rune | What it does at the read site | The second gate | Worth, when it holds |
|---|---|---|---|
| **Deepening Hex** | `_ruin_threshold`: `step = mini(step, 8)` | **Avatar of Ruin** (Ruin lane row 9) installs `avatar_ruin = 5`, and `mini(5, 8)` is **5** | **ZERO.** The capstone already detonates every 5th stack |
| **Wide Watch** | `_sharpshooter_focus`: an `elif` arm that skips the meter clamp on a kill | **Overkill** (Penetration row 7), whose own text reads *"the carry keeps your Focus in FULL rather than dropping it to the usual 50"* — the rune's clause, word for word, one `elif` below | **ZERO.** The next arm, `elif attacker.overkill <= 0`, is what clamps |
| **Bracing Line** | `-5%` on a hit against another hero | **Heavy Plating at +32%** (`BRACING_LINE_LEVEL`), tested in the FIGHT | 8.98% of incoming hits (EZ §2b(i)) |

· **THE OTHER TWO NEAR-MISSES ARE NOT ZEROES AND ARE NAMED SO THEY ARE NOT COUNTED AS ONE.**
  **The Answering Pack loses to Bear the Brunt** — `if not hunter.has_status("bear_brunt")` — but
  that is a FALLBACK by design and by comment: the card is a cast with a cost, the rune is passive,
  and a Beastmaster holding both is covered twice in a fight. **The Shared Scent needs a companion
  death and then a call**, which is situational rather than gated.
· **DEEPENING HEX'S ZERO IS ALREADY ASSERTED AND NOBODY HAD READ IT AS A FINDING.** `check_ez` §5
  asserts *"with Avatar of Ruin held it stays 5 — the rune never makes it SHALLOWER"*, which was
  written to catch a rune that ASSIGNED. It is correct and it is deliberate; **what nobody wrote
  down is that the correct behaviour makes the rune worth nothing to a capstone holder.**
· **WIDE WATCH'S ZERO HAS A COSMETIC TELL.** With the rune held, the `elif` chain's Overkill log
  line can never print, so an Overkill Sharpshooter wearing the Wide Watch sees the rune's message
  instead of his talent's. **Nothing behaves differently; the log attributes the effect to the
  thing that did not cause it.**
· **ALL THREE ARE DESIGN QUESTIONS AND ALL THREE ARE THE DESIGNER'S.** Nothing here is retuned.

### WHAT EACH OF THE EIGHT DOES NOW, IN ONE LINE

| Rune | Read site | Ungating changes |
|---|---|---|
| Deepening Hex | `battle._ruin_threshold` | Ruin detonates every 8th stack rather than 10th, **always** — unless Avatar of Ruin is held, when it is worth 0 either way |
| Wide Rite | `battle._old_gods_mark` | +1 Ruin marked per debuff, **always**. Pure addition, no second gate. **The largest real change of the eight** — it went from 1.4% to 100% |
| Bracing Line | `battle.gd:10049` | −5% damage to other heroes **whenever the plating stands at +32%**, which is now the whole condition |
| Long Watch | `battle.gd:10600` | Break damage carries to a second enemy on any Break-dealing hit, **always** |
| Heavy Bolts | `unit.focus_convert` | The conversion point drops 100 → 80, **always** — from 0–8% to 100%, the second largest change |
| Wide Watch | `battle._sharpshooter_focus` | Focus survives a kill whole, **always** — unless Overkill is held, when it is worth 0 either way |
| Answering Pack | `battle._on_brunt_guard` | The deepest bond takes the killing blow once a fight, **always**, as the fallback below Bear the Brunt |
| Shared Scent | `battle.gd:22097` / `:23515` | A fallen companion's Loyalty banks and carries to the next called, **always** |

---

## §2 — THE MACHINERY: WHAT WENT, WHAT STAYED, AND WHY

**REPORTED BEFORE ANYTHING WAS REMOVED, PER THE BRIEF.** Every name in the brief's list was traced
to its callers first; three of them turned out to have a caller the brief did not name, and one
turned out to be older than the conditions and stayed.

### REMOVED — NINE FUNCTIONS, ONE DOOR CALL AND TWO SCREEN LINES

| Removed | Its callers before FN | Why it is dead |
|---|---|---|
| `Runes.loadout_condition_met` | `Talents.condition_met` only | No payload carries either key; a door that can only answer one way is not a door |
| `Runes.threshold_met` | `loadout_condition_met`, `party_screen`, `map_screen` | All three go |
| `Runes.breadth_met_fraction` | `loadout_condition_met`, `breadth_line`, both screens | All go |
| `Runes.threshold_line` | **zero already** (the tick beside it was built inline) | — |
| `Runes.breadth_line` | both screens | Both go |
| `Runes.drafted_names` | `loadout_condition_met`, both screens | All three go |
| `Classes.primary_tag_count` | `threshold_met`, `threshold_line`, both screens | All four go |
| `Classes.primary_tag_census` | `primary_tag_peak` only | Its one caller goes |
| `Classes.primary_tag_peak` | `breadth_met_fraction`, `breadth_line` | Both go |
| `Talents.condition_met`'s tag branch | — | The two keys appear in no payload in the tree |
| The `RUNE CONDITIONS` line ×2 | — | It displayed a fraction that decides nothing |

**THE THREE `Classes.primary_tag_*` HELPERS WENT BECAUSE GIT SAYS THEY CAME IN WITH THE
CONDITIONS.** `git log -S` puts all three in **Batch EZ**, and `docs/reports/EZ.md` §0c says why in
its own words — *"added beside the originals rather than replacing them"*, because a condition
needs a partition and a census is not one. **They came in for the fractions and they go out with
them.**

### KEPT — AND EACH FOR A STATED REASON, NOT FOR SYMMETRY

| Kept | Why |
|---|---|
| `Classes.tag_count` / `tag_census` / `tag_breadth` | **OLDER — ES §4's, not EZ's.** They answer what a SCREEN shows, both tags counted; `check_es` §4 reads them for the per-spec core-kit table it prints every battery, and both screens still draw `CARRIED BY TAG` off them |
| `Classes.card_tag_primary` | **OLDER STILL — it arrived at EK with the vocabulary itself** (`git log -S`), and it is the accessor for the primary-first ordering `check_ek` §2 pins on `CARD_TAGS`. **Zero callers now, kept and asserted**, which is `rune_tag_line`'s own shape (FE §1b) |
| `Runes.tag_threshold_met` / `breadth_met` | **ES §4/§5's ABSOLUTE-count shapes over the whole bar** — a different question from EZ's fractions over the drafted half, never read by a rune, driven by `check_es` §4, and the door a future tag-reading rune comes back through |
| `Runes.rune_tag_line` / `RUNE_TAGS` | FE §1b's zero-caller reader, kept for the rune-offer surface EK deferred |
| `Runes.RUNE_SECONDARIES` | **THRESHOLD and BREADTH stay as WORDS.** The ruling belongs in an assertion, not in a spelling: deleting them would make a re-authored gate impossible to express and would hide the retirement instead of stating it. §4 forbids moving a constant, and this is the reading that respects it |
| The `CARRIED BY TAG` census on both screens | **The tags are player-facing on the draft card and are not conditions** — EK's whole point, and the brief's own instruction |

### `check_fk` §2 INVERTED RATHER THAN BEING DELETED

`STILL_GATED` asserted the eight carried **both** their condition and their label, so *"none of
the thirty-nine is authored"* could not be satisfied by quietly ungating the ones owed a repair.
**The constant is `WAS_GATED` now and the arm asserts none of the eight carries either** — the
same guard against a silent re-gating that the original was against a silent ungating. **The count
does not move**: it is one `ok` either way.

---

## §3 — THE `.docx` CONTRADICTION

**`CLAUDE.md`'s *Working agreement* step (3) required rebuilding both exports on EVERY design
change. The designer's ruling that they stay stale lived in exactly one place — `docs/reports/FH.md`
§4 — which is the one file class no instrument reads and no sweep covers.**

**RULED: THE EXPORTS STAY STALE. Step (3) now says so, and carries the reason.**

- **THE REASON IS MECHANICAL AND IT IS WORSE THAN STALENESS.** `docs/build_docs.py` reads
  `docs/changelog.html` **by relative name**, and that file is the **RECENT HALF only** — the
  changelog has been cut four times (BZ at BO/BP, CX at CN/CO, DV at DF/DG, FG at EP/EQ) and
  everything older lives in `DoD-archive/changelog-archive.html`. **Rebuilding would overwrite
  `DoD Changelog.docx` with a fraction of itself.** That is not a stale export becoming fresh; it
  is an archive being destroyed. **The archive is the archive.**
- **THE SCRIPT IS KEPT.** It still resolves and still works. The day the changelog stops being cut,
  or the day the exporter learns to concatenate the archive first, the rebuild comes back — **a
  tool that is not run is not a tool that is wrong.**
- **THE STATE ON DISK ALREADY AGREED WITH THE RULING AND NOT THE RULE**, which is FL §2c's finding:
  both `.docx` are dated 2026-09-06 while the HTML is 2026-09-08.

---

## §4 — THE ELEVEN LINES THAT SAID SIX

**All eleven corrected, derived from `check_fk.STILL_GATED` as the brief required.**

| File | Lines | What was done |
|---|---|---|
| `check_fk.gd` | **5** — 6, 8, 53, 134, 153 | the header, the constant's comment, §2's two comments and its arm's message; **all five rewritten with the inversion** |
| `scripts/runes.gd` | **1** — 536 | *"THE SIX ALREADY-SHIPPED GATED RUNES ARE NOT REPAIRED HERE"* → the eight, repaired at FN |
| `docs/master.html` | **3** | the retirement bullet's *SIX ALREADY-SHIPPED*, *"because six live runes still come through it"* and *"asserts those six are still gated"* |
| `docs/changelog.html` | **1** | the FK entry's *WHAT DID NOT MOVE*, corrected in place with a note saying it was one of the eleven |
| `docs/reports/FK.md` | **1** — §9 | **struck rather than rewritten**, because the report is closed and the strike is the honest shape |

· **THE THREE REMAINING "six live runes" STRINGS IN THE TREE ARE QUOTATIONS OF THE WRONG LINE**,
  inside FL's own report of the finding (`docs/reports/FL.md`, the changelog's FL entry and
  `docs/state.md`'s queue item). **They are citing the error, not asserting it**, and they stay.

---

## §5 — WHAT WAS DELIBERATELY NOT DONE

- **No rune's magnitude is retuned.** §1 flags three zeroes and one conversion; the designer rules.
- **No class or universal rune is authored**, and no rune was authored, retired or re-scoped.
- **The tags stay.** `CARRIED BY TAG` is on both screens and the draft card's tag line is untouched.
- **The generated stat family stays out of the offer path and stays in the data**, per FM.
- **No card, ability, talent or constant moved.** `BRACING_LINE_LEVEL` is still 32,
  `RUIN_THRESHOLD` still 10, `FOCUS_CONVERT` still 100, `RUNE_SECONDARIES` still three words.
- **No rune price, scope, lane or `requires_ability` moved** — the whole `data/` diff is eight
  `desc` strings and eight `condition` objects.
- **`check_es` §4's per-spec core-kit table is untouched**, and so is every read site `check_ez` §5
  drives.

---

## §6 — VERIFICATION

**THE FLOOR, READ OFF STDERR AND NEVER OFF A TALLY OR AN EXIT CODE.** `grep 'Parse Error'` over the
stderr of a full `check_parse` run: **0**. `check_parse` reads **176 / 0**, and the +1 over FM's 175
is `check_fn.gd` itself — that gate's count IS its coverage, so a new gate owes that row as well as
its own. The battery manifest reads **100 targets, 0 missing**, and `check_fn.gd` is not in the
RESIDUE list, which is the half that says it is wired into `run_battery.sh` rather than merely
present.

### THE UNMODIFIED GATES WERE RUN AGAINST THE NEW TREE FIRST, AND THE RUN IS DISCARDED

**Per the brief. A full battery, before a single gate was edited.** Every suite was green —
including `test_runes` at **5318 / 0** and `test_rune_battle` at **97 / 0**, which is the answer to
*does the game still work* — and the reds were these:

| Target | Recon | Predicted? | Verdict |
|---|---|---|---|
| `check_ez`, `check_fd`, `check_fe`, `check_fh` | **PARSE FAILURE** (43 / 6 / 4 / 22 throws) | **yes** | They call the removed functions. `check_parse` read 175 / 4 and named all four |
| `check_fk` | 64 / **1** | **yes** | §2's `STILL_GATED` arm, naming all sixteen halves. **This is the arm the brief said inverts** |
| `check_ek` | 45 / **2** | **yes** | `talents.gd` left the game-tag population and the consumer arm went vacuous |
| **`check_ed`** | 18 / **1** | **no** | Four pins from `check_fe.gd` anchored on `scripts/runes.gd` — `func threshold_met(`, `func breadth_met_fraction(`, `Classes.primary_tag_count`, `Classes.primary_tag_peak`. **The manifest is the needle instrument and it was read BEFORE regeneration**, which is what made this a finding rather than a diff |
| **`check_es`** | 47 / **1** | **NO — AND IT IS THE SHARPEST OF THE RUN** | §5 below |
| `check_cm_live` | 13 / **4** | baseline | The one red that is on purpose |
| `check_de` | 414 / 20 | — | All twenty downstream of the above |

### `check_es` §5's FLOOR WAS WRITTEN FOR EXACTLY THIS AND CAUGHT IT

**Its message is *"%d live splashes — the BREADTH shape has gone extinct"* and its comment says the
floor is what stops the shape going quietly extinct.** FN made it extinct — **loudly, by ruling** —
which is the one case a floor at four was never guarding against.

**IT INVERTS TO AN EQUALITY AT ZERO, AND THE INVERSION IS THE STRONGER CHECK.** A floor asked *has
somebody let this rot?*; an equality at zero asks *has somebody authored one against the ruling?*,
and only the second has a live answer. **ES §5's machinery is untouched and is still driven**:
`Runes.breadth_met` is KEPT, because what was retired is EZ §0's FRACTION over the drafted half and
not ES §5's absolute count over the whole bar — **the two were never the same question**, and a
batch that deleted both because they share a word would have taken out the door the next rune comes
back through.

### `check_fn` IS NEW — 80 CHECKS, THREE IDENTICAL STANDALONE READINGS, FIVE CONTROLS

Its four sections and why each ruling decays are in the gate's own header and in its
`baselines.json` row. The three things worth repeating:

- **§1's POPULATION IS A CENSUS OF ALL 126 ENTRIES, LIVE AND RETIRED.** A `"condition"` key is four
  characters and nothing else in the tree would notice one arriving; a retired entry still resolves
  through `config` and a saved run can hold one. **A NINTH gated rune is caught by the assertion
  that watches these eight.**
- **§1d IS THE ARM THAT SEPARATES A REMOVAL FROM A TRIM.** Bracing Line's Heavy Plating clause is
  a SECOND gate and must still be on the card; the arm asserts it, and asserts
  `BRACING_LINE_LEVEL := 32` in `battle.gd` beside it, so the card and the fight agree.
- **§4 RE-IMPLEMENTS EZ §0's RETIRED PREDICATE AND RUNS IT FIRST.** Without it, an arm built on a
  loadout that PASSED the old rule proves nothing — `check_fd` §2's `_pre_fd_peak` precedent, and
  the control below shows it biting.

**THE FIVE CONTROLS, EACH APPLIED TO AN OUT-OF-REPO COPY AND NEVER TO THE TREE:**

| Control | Result |
|---|---|
| One rune re-gated, payload **and** label (the exact edit FN made, reversed) | **3 reds** — §1a, §1b, §1c |
| `threshold_met` restored **plus a caller one file over** | **2 reds** — §2a names the definition, §2c names **both** files |
| A `RUNE CONDITIONS` Label re-added to the loadout panel | **2 reds** — §3, both the line and the breadth half |
| `_spec_bar` inverted to stack the threshold's **own** tag | **6 reds** — every one of them an arm's own control firing: *"the `failing` loadout MEETS the retired condition; the arm proves nothing"* |
| `rune_tag_line` renamed away | **exactly 1** — §2b, the KEPT positive arm |

· **A SIXTH CONTROL IS CAUGHT BY THE COMPILER AND THAT IS WORTH STATING RATHER THAN COUNTING.**
  Renaming `card_tag_primary` away produced **no gate output at all**, because `check_fn` reads it
  — a parse failure, not an assertion. It bites; it bites louder than an `ok`.
· **AND ONE CONTROL'S FIRST ARMING FAILED TO ARM, WHICH IS RECORDED RATHER THAN TIDIED AWAY.** The
  `RUNE CONDITIONS` injection's anchor string did not match, the Python assertion threw before the
  edit, and the gate then ran against the **unmodified** copy and printed **80 / 0** — *"did not
  bite"* wearing the exact shape of a clean run. Re-anchored and re-armed, it read 2 reds.
· **§4's LIVE ARM WAS PROVED BY ITS OWN ABSENCE FIRST.** The first run of `check_fn` against a copy
  **without** the `gate_fixture` hook read **0 of 8 reaching a live BattleUnit**, with all eight
  named. The hook is what makes that arm real, and the failure said so before the fix did.

### THE ONE FIXTURE CHANGE, AND WHY IT IS THE FIXTURE AND NOT A SECOND ONE

`gate_fixture.spawn` gained a fourth `opts` key, **`party`** — `{seat: {key: value}}` stamped onto
`run.party[seat]` after the spec/tree/runes reset and before the scene instantiates. **THE WINDOW
IS THE POINT**: `battle.gd`'s spawn reads `party[i]["runes"]` and the member dict as it builds each
hero, and `spawn` clears `runes` unconditionally, so a caller cannot simply set them first.
**The alternative was a second battle fixture**, which is precisely what DB §1 consolidated seven
copies of and what `check_da` §3 catches — and it caught FM twice for the same reason one batch
ago. **`check_da` reads 42 / 0**, unchanged.

· **AND `check_fn` DOES NOT NAME BOTH DRAFT POOLS.** Its failing bars come through
  `Run.draft_pool_left` — the live door, `check_fd` §2's idiom — which is both the right question
  (a hero cannot draft another spec's card) and what keeps this gate out of `check_da` §3's
  hand-rolled-corpus walk. **A gate that named both accessors would have needed an exemption**;
  this one needed a better read site.

### THE COUNTS THAT MOVED, AND WHY EACH MOVED

| Target | Before | After | Why |
|---|---|---|---|
| `check_parse` | 175 | **176** | `check_fn.gd` — its count IS its coverage |
| **`check_fn`** | — | **80** | new |
| `check_ez` | 132 | **96** | §1/§2/§3 collapse — the two fractions, the counted-set discrimination and the condition re-read all had their subject retired. **The LEVER survives and is kept**: §2 still asserts the three candidate sets differ and that the bar is the equipped half plus the protected names; §3 still drives both live doors |
| `check_fd` | 87 | **50** | one retired arm. §2's breadth drive was `ok(now >= was, …)` once per real loadout across every spec at three bar sizes; it drove `Classes.primary_tag_peak` and `Runes.breadth_met_fraction`, both deleted. `_pre_fd_peak` went with its only caller |
| `check_ek` | 46 | **45** | `TAG_CONSUMERS` goes empty (−2) and `NO_TAG_FILES` gains `talents.gd` (+1) — **a tighter bound, not a looser one** |
| `check_fe` | 79 | **78** | §1b's predicate-source arms re-point to the payload census; the `rune_tag_line` sweep and `RUNE_TAGS`' population arm are untouched |
| `check_fh` | 162 | **163** | §4 changes subject from the condition to the bench lever and gains the second surface's absent-line arm |
| `check_es` | 47 | **47** | §5's floor inverts in place |
| `check_fk` | 64 | **64** | §2's arm inverts in place |
| `pin-manifest.json` | 1437 | **1440** | four `check_fe` pins gone, seven new. `check_ed` **18 / 0** before regeneration was 18 / 1, after is 18 / 0 |

### THE LITERAL SWEEPS, AND THE FOUR THAT NEEDED PROVING

**(1) EVERY LINE THE `scripts/` AND `data/` DIFF REMOVED, swept against all 90 gates and suites plus
`pin-manifest.json` and `baselines.json`: 116 non-comment lines, and the ten that appear verbatim
anywhere are all generic GDScript** (`return []`, `return false`, `return n`, `return out`,
`return true`, `var n := 0`, `var out := {}`) **appearing as those files' own code.** The three that
looked specific were not: `for tag in Classes.TAG_ORDER:` is `check_ek`'s own line,
`if cond.is_empty():` is `check_fd`'s, and `or bool(cond.get("tag_breadth", false))` is
`check_ez`'s. **The eight removed `desc` clauses appear in exactly one file — `check_fn.gd`, which
asserts their absence.**

**(2) EVERY 4+ CHARACTER STRING LITERAL** — both quote kinds, escape-aware, on RAW source, which
fails toward MORE needles — in every `.gd` that names each edited document, against HEAD's copy and
the copy now:

| Document | Readers (loose) | Needles | LOST | STRICT readers | STRICT LOST |
|---|---|---|---|---|---|
| `CLAUDE.md` | 59 | 16,365 | 4 | 29 | **1** |
| `docs/master.html` | 34 | 12,473 | 4 | 25 | **3** |
| `docs/changelog.html` | 18 | 4,355 | **0** | 17 | **0** |
| `docs/text-standard.html` | 6 | 2,249 | **0** | 4 | **0** |
| `docs/design-notes.md` | 4 | 962 | **0** | 4 | **0** |
| `docs/instrument-rules.md` | 6 | 1,002 | **0** | 4 | **0** |
| `docs/state.md` | 9 | 3,100 | **0** | **0** | — |
| `docs/talent-audit.html` | 3 | 332 | **0** | 1 | **0** |

**THE FOUR STRICT LOSSES WERE PROVED FALSE POSITIVES RATHER THAN ASSUMED TO BE.**
`'s own rule'` (CLAUDE.md) appears in **no CODE line of any strict reader** — comment-only, in four
gates' prose. `bm_abilities`, `bm_equipped` and `core_slots` (master.html) appear in **79, 7 and 18
code lines** across `check_eh`, `check_fe` and nine suites, and **every one is an assertion about
the GAME** — a member-dict key or a `Classes.core_slots()` call — that happens to share a substring
with a paragraph this batch removed. **PROVED BY RUNNING THEM**: `check_eh` 175 / 0,
`test_batch_bo` 1140 / 0, `test_batch_bp` 276 / 0, `test_batch_bx` 161 / 0, `test_batch_ce`
1114 / 0, `test_batch_ah` 5584 / 0.

· **AND THE LOOSE READING'S FOURTH master.html LOSS IS THE ONE WORTH NAMING**: `'rally'`, which
  HEAD's document held exactly once — **inside the word *literally***, in a sentence this batch
  removed. A four-character needle in a 12,000-needle sweep will find a word inside a word.

### THE TREE WAS FROZEN ACROSS THE BATTERY

**363 paths — `git ls-files` PLUS `git ls-files --others --exclude-standard`, so `check_fn.gd` is
inside it — md5'd by ABSOLUTE path so a moved cwd cannot report the tree as drifted.**
**`docs/state.md` and `docs/reports/FN.md` are the only files edited during the freeze**, and
neither is opened by any `.gd` file: the strict sweep above reads **0 strict readers for
`docs/state.md`**, and `docs/reports/` is reached by no `FileAccess` call anywhere in the tree.

### FM'S OWN §3 REPAIR IS NOW DORMANT, AND IT IS RECORDED RATHER THAN REVERTED

`check_fh` §3's needle was scoped one batch ago because **eight live runes carried *"his drafted
cards"* in their own `desc`** — the gated pair FK left owed. **Those are the eight clauses FN
removed**, so **zero live runes name a draft now** and the excusal has nothing to excuse. **The
scoping is not reverted**: it is correct on its own terms, its BUTTON arm is unaffected, and the day
a rune's text names a draft again the scoping is what stops a false red. **A repair whose occasion
disappears is not a repair that was wrong.**

### THE ACCEPTANCE RUN

**THE FULL BATTERY IS GREEN: 102 targets, and the ONE red is the sanctioned one.**
`check_de` reports **418 checks / 0 failures / 0 NOTICES**, so every baseline row matches its
target *exactly* rather than merely not falling — and the +4 over FM's 414 is the four checks a new
target adds to that gate's own sweep, exactly as FM predicted for `check_fm`.

**`check_cm_live` reads 13 / 4 and the FOUR LINES WERE COMPARED, NOT THE COUNT:**

```
FAIL: the bar appeared on the enemy's attack
FAIL: the bar's top line names the incoming blow (was: )
FAIL: the brace lands near x0.85
FAIL: the brace's Break half lands near x0.75
```

**THE OUT-OF-REPO HEAD REBUILD WAS NEEDED THIS TIME AND IT WAS RUN.** FL could skip it because that
batch moved no `.gd` file at all; **FN moved `gate_fixture.gd`**, which is the file every
fixture-driven gate executes, so an argument that the change is additive is not evidence.
**A clean HEAD copy reads `check_cm_live: 13 checks / 4 failures` with those four lines
byte-identical.** The chain is complete in both directions: the reconnaissance run, taken with
`gate_fixture.gd` still at HEAD, printed the same four; so did FL's run two batches ago.

· **AND THE REBUILD METHOD IS AN INSTRUMENT FINDING WORTH CARRYING.** The first attempt used
  `git archive HEAD | tar -x`, which is **tracked files only** — and `.godot/` and `*.import` are
  both gitignored. The copy could not resolve `res://scenes/battle.tscn`, so **every
  fixture-driven gate threw `Cannot call method 'get' on a null value` inside
  `gate_fixture.spawn`** and then sat at ~1% CPU rather than exiting. **The method that works is
  `rsync` the whole working tree — ignored files included — and then
  `git --work-tree=<copy> checkout HEAD -- .`**, which puts HEAD's tracked content into a tree that
  still has its import cache. Verified: the rebuilt copy runs the gate in 70 seconds.

### THE FREEZE HELD

**363 paths, `git ls-files` PLUS `git ls-files --others --exclude-standard`, md5'd by ABSOLUTE
path.** Re-stamped after the run: **exactly one file differs and it is `docs/state.md`**, the
declared exception; **0 missing.** `docs/reports/FN.md` did not exist when the list was built and
is the second declared exception. Neither is opened by any `.gd` file.

### THE FINAL FIGURES, READ OFF `check_fg` RATHER THAN HAND-CARRIED

`docs/changelog.html` at **208,377 B = 208.38 KB**, under CW §4's 400 KB bar with **191.62 KB** of
headroom; the FN entry itself is **6,008 B**. `CLAUDE.md` at **284,394 B = 277.73 KiB** against
EE's 290 KiB — **12.27 KiB of headroom, the tightest it has been.**

· **AND THAT HEADROOM IS PARTLY A DECISION THIS BATCH TOOK AND THEN REVERSED.** The first draft of
  the retired EZ §0 rule kept its full text and all six of its bullets in `CLAUDE.md` as "the
  record" — **4,976 bytes**, which left 8.35 KiB. **It was cut to a nine-line pointer**, on
  `CLAUDE.md`'s own terms: that file holds what BINDS a batch, the two transferable halves are in
  the new rule above it, and the rest is a mechanism that no longer exists. **A retired rule kept
  at length in the rules file is a rule a future batch reads as live** — which is the same fault as
  a ruling kept only in a closed report (§3), pointed the other way.
