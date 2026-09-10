# BATCH FU — THE CEILING MOVES, AND CHANNEL GETS ITS NUMBER

**THE SECOND BATCH ON `class-merge`.** Two items: §1 moves `CLAUDE.md`'s ceiling from 290 to 340 KiB
and records what happens at 340; §2 gives Channel its ruled build rule and its first real rate.
**Nothing is attached to any hero** — `check_ft` §0 still asserts that the three spines are reachable
by nobody, and it is still the section that inverts. **`docs/master.html` is not edited and its stamp
is not bumped**: nothing a player can meet has changed.

---

## §0 — THE BRIEF'S PREMISES, CHECKED BEFORE ANYTHING WAS EDITED

| Premise | What the repo says |
|---|---|
| *"`CLAUDE.md` is at 287.85 KiB with 2,206 bytes left. FT spent 4,148."* | **TRUE.** HEAD's file is 294,754 B; the 290 KiB bar is 296,960 B; `git` puts FT's commit at +4,148 B. |
| *"EE's 290 was DZ's measured rules-only reading plus ten of the largest single-batch growth on record"* | **TRUE** — `docs/reports/EE.md`: 210.59 + 80.90 = 291.49, stated as 290. |
| *"Both terms are forty batches and four months stale"* | **THE BATCHES ARE RIGHT AND THE MONTHS ARE NOT.** EE is dated **2026-08-31** and DZ **2026-08-30** in the archived changelog — about forty batch codes, but **eleven days** before this batch. Nothing in the ruling rests on the elapsed time; it is corrected so the figure does not travel. |
| *"FF's measured 261.03 KiB plus ten × 8.09 KiB is 341.9"* | **THE ARITHMETIC IS RIGHT AND ONE INPUT IS STALE.** 8.09 KiB is **EB's +8,287 B**. Over the 56 batches since DK (EE's own window), **EZ grew the file by +8,293 B — six bytes more** — so the largest single-batch growth on record is **8.10 KiB** and the re-run is 261.03 + 81.00 = **342.03**. It still rounds down to **340**, so the ruled number stands; the ceiling block carries EZ's figure because that is what "current inputs" means. |
| *"FF's measured +4,315 B a batch ... roughly twelve batches of headroom"* | **TRUE** — FF's 25-batch mean is +4,314.6 B. After FU's own edits the file reads **298,560 B = 291.56 KiB**; 340 KiB is 348,160 B, so the headroom is **49,600 B = 48.44 KiB — 11.5 batches at FF's mean and six at EZ's worst**. |
| *"ED read all 43 uncited blocks and found zero dead; FF classified all 105 ... three quarters is rule about what the game may contain; FF stated there is no third seam"* | **ALL TRUE** — `docs/reports/FF.md` §0, §1a (74.0%) and §1f. |
| *"combat law is 66.74 KiB and card law 59.12"* | **TRUE AS FF's FIGURES AND NOT AS TODAY's.** FF measured them on FE's 280.80 KiB file; the file has grown since and FF's per-block classification is not in the repo. **Quoted with that provenance in the ceiling block, and not re-derived** — re-deriving is a classification, and the brief asked for the seam to be named, not measured. |
| *"FG's threshold watcher reads the ceiling from the rule"* | **HALF TRUE, AND THE OTHER HALF IS THE FINDING §1 WAS RUN TO SURFACE.** Its parse arms read the bar out of the rule and followed 340 with no edit. **Its FORM check was the literal `"THE CEILING IS 290 KiB"`**, a copy of the number — see §1b. |
| *"FT measured a Pyromancer at 95 Mana over 6 casts ... ~16 a turn, because his basic is free"* | **TRUE AS FT's ONE FIGHT; THE "BECAUSE" DOES NOT HOLD AT SCALE.** Over 7,562 driven Pyromancer casts in rung-1 trash, **11.8% were free**, not FT's 2 of 6. The reason is below. |
| FT's economy: *"Mana starts at 100, caps at 100 and regenerates 12 a turn"* — in FT.md, in `CLAUDE.md`'s governor row and in `docs/state.md` | **FALSE FOR EVERY MAGE.** `battle.gd:1279` sets `mana_regen_bonus = 10` for the whole Mage class — Evocation, the class passive — and `_mana_regen` is `12 + mana_regen_bonus`. **A Mage regenerates 22.** FT's own report names Evocation in the sentence before its table and then prices the table at 12. **The two live copies — `CLAUDE.md`'s governor row and `docs/state.md` — are corrected**; FT's report is history and is not edited. |
| *"Rung-1 trash runs ~9 rounds since EO"* | **STALE.** Measured at n≈1,100 trash fights per party: **7.48 / 8.23 / 8.04** rounds for the Pyromancer / Cryomancer / Arcanist parties. The Cryomancer party is EO's own default party, and EO read 9.1–9.2. |
| *"At 40 a step the current form reaches 2 steps by turn five and the cap is unreachable outside a boss"* | **BOTH HALVES HOLD, AND THEY DO NOT MEAN THE METER WAS SLOW.** Step 2 arrives at his ~4th cast and the cap is reached in only 1.9–6.6% of trash fights — **but at 40 the meter already ENDED a trash fight at a median of 3 steps, which is half the cap**: means 2.90 / 3.40 / 2.66. |
| *"the Arcanist's Resonance loop and the Cryomancer's cheaper casts will not read like the Pyromancer's"* | **HALF TRUE.** They do not read alike — but **the Cryomancer's casts are not cheaper**: his costed net is 24.6 a cast, the Arcanist's is 24.6 and the Pyromancer's 23.1. **He takes more turns**: 7.39 casts a trash fight against the Arcanist's 5.57. |
| *"FT asserted element-blindness against `note_resource_spent`'s own source"* | **TRUE** — `check_ft` §1a. Kept pointed at the new form: see §2c. |
| §4's *"and the stamp"* | **READ AS `docs/state.md`'s *Last rewritten* stamp**, because §3 rules that `master.html`'s stamp is not bumped. Named here so the reading is visible. |

---

## §1 — THE CEILING GOES TO 340 KiB

### 1a. THE DERIVATION, BY EE's OWN METHOD WITH CURRENT INPUTS

| term | EE (290) | FU (340) |
|---|---|---|
| FLOOR — the most recent reading of this file with nothing in it but tested rules | DZ's prune, **210.59 KiB**, taken before the instrument half left the file | FF's split, **261.03 KiB**, after ED read every never-cited block and FF classified all 105 |
| HEADROOM — ten of the largest single-batch growth on record | ten × **EB's +8.09 KiB** | ten × **EZ's +8.10 KiB** (8,293 B) |
| sum | 291.49 | **342.03** |
| stated, rounded down | **290** | **340** |

**The old "290 is conservative because its floor still held the instrument half" caveat retires with
the number it described** — FF's floor is this file alone. `docs/instrument-rules.md` still has no
stated ceiling, and that is still a ruling nobody has taken.

| | HEAD (FT) | FU |
|---|---|---|
| `CLAUDE.md` | 294,754 B = 287.85 KiB | **298,560 B = 291.56 KiB** (+3,806 B this batch) |
| the ceiling | 290 KiB = 296,960 B | **340 KiB = 348,160 B** |
| headroom | 2,206 B | **49,600 B = 48.44 KiB** — 11.5 batches at FF's +4,315 B mean, 6.0 at EZ's worst |
| `check_fg`'s deadline | 290 + 8.09 = 298.09 KiB | **340 + 8.10 = 348.10 KiB = 356,454 B** |

**AND THIS BATCH ALONE WOULD HAVE CROSSED THE OLD CEILING.** FU's own edits are +3,806 B against
FT's 2,206 B of headroom: under 290 the file would now sit **1,600 B past the bar** — a printed warning
this batch and a failure the next. That is the wall the brief described, arriving on the batch that
moves it.

### 1b. THE WATCHER FOLLOWED THE NUMBER AND HELD A COPY OF IT

**The brief asked whether `check_fg` follows the new number without an edit, and said a copy would be
a finding. Both happened.** Run unmodified against the edited `CLAUDE.md`:

```
§2 — CLAUDE.md against the ceiling the rule states
  FAIL: §2: CLAUDE.md no longer states its ceiling in the form this gate reads
  ceiling 340 KiB = 348160 B; deadline 340 + 8.10 = 348.10 KiB = 356454 B
check_fg: 22 checks / 1 failures
```

- **THE PARSE ARMS FOLLOWED.** The ceiling and the deadline both came out of the rule's own prose,
  EZ's 8.10 included, with no edit to the gate.
- **THE FORM ARM WAS THE COPY.** `ok(cm.contains("THE CEILING IS 290 KiB"), …)` asserts the sentence
  *with its number*, so the first batch to move the bar took the gate red against a correct rule and
  a correct file. **§1 carried the changelog's `"THE THRESHOLD IS 400 KB"` the same way** — never
  exercised, because that threshold has never moved.
- **SO THE HEADER'S CLAIM WAS FALSE**: *"IT HOLDS NO COPY OF EITHER NUMBER"* — and
  `docs/instrument-rules.md` states the same thing as a standing rule, and `baselines.json`'s note
  repeats it. **A gate built specifically against second copies of a number held one in its
  least-examined line.**
- **THE REPAIR**: both form checks now assert the form with **the same pattern that parses the
  number** (`bars.size() >= 1`), so a reworded rule still reds and a moved number no longer does.
  **The count stays 22** — one assertion replaced by one. The rule in `docs/instrument-rules.md`
  gains the sub-bullet that makes the shape transferable.
- **AND `pin-manifest.json` MOVED BY EXACTLY THOSE TWO PINS.** A regeneration diffed in the
  scratchpad before anything was blessed read one change after the `CLAUDE.md` edit (the ceiling pin,
  `code → unresolved`), and after the repair **1,448 → 1,446 pins: exactly those two removed and
  nothing added** — `--check` current, and `check_ed` 18 / 0 against the regenerated file.

### 1c. AN INSTRUMENT FINDING ON THE WAY — AND THE ONE THING MY OWN PREDICTION GOT WRONG

**`check_ed` read 18 / 0 against HEAD's manifest with the ceiling pin already unresolvable.** Its §0
builds its population from pins whose haystack ends in `.gd`, so the document pins are outside it.
**I wrote that up as "the document pins are verified by nothing but the suites that hold them", and
the pre-pass proved it false**: `check_ec` §2 reads every member of every `contains` group against the
five tracked documents, and it went **24 / 2 on exactly that pin** — the one red my written prediction
did not name. **The document half HAS an instrument; it is `check_ec`, not `check_ed`.**

- **SO THE PIN PROOF FOR A DOCUMENT EDIT IS `check_ec`**, with `build_pin_manifest.py --check` and a
  regeneration diff (which also named the pin); for a source edit it is `check_ed`. The procedure the
  project had been using for document edits — *"run `check_ed` against HEAD's manifest with the
  edited documents in place"* — could not have seen this pin move.
- **NOTHING IS BROKEN**: each gate's header says what it reads. What is worth keeping is the shape of
  the mistake — a finding about one gate's population, written up as a finding about the tree's. It
  is recorded in the queue as a procedure note, and the claim never reached a document.

### 1d. WHAT HAPPENS AT 340, NAMED SO IT IS NOT REDISCOVERED

- **EE's procedure is exhausted.** Split-never-prune has no seam left of the kind it takes (FF §1f),
  and the ceiling has now been re-derived once.
- **A second re-derivation is not the same move made twice.** Every audit of this file has found
  nothing dead, so its next "rules-only reading" would simply be its size on the day, and a ceiling
  derived from a file's own size moves with the file.
- **THE SEAM THAT EXISTS IS BY SUBJECT.** At FF's classification, COMBAT RESOLUTION LAW was 66.74 KiB
  (24 blocks) and CARD / ABILITY AUTHORING LAW 59.12 KiB (21 blocks); either could become a reference
  the main file points at, the way `docs/instrument-rules.md` did. **It is a real seam and it is not
  the one FF's one-way tiebreak allows**, because both subjects are rules about what the game may
  contain — so **taking it is overturning the tiebreak for a subject, and that is the designer's
  ruling.** Written into `CLAUDE.md`'s ceiling block, where the next batch at the ceiling will read it.

---

## §2 — CHANNEL: A FREE CAST COUNTS AS A FLOOR VALUE OF MANA

### 2a. THE BUILD RULE, AND WHERE "A CAST" COMES FROM

**One term, not two.** `note_resource_spent(amount, cast := false)`: a Mana booking that its caller
marks as a cast books `maxi(amount, CHANNEL_CAST_FLOOR)`. **There is exactly one caller that marks
one**: the spend line in `_resolve`, which passes `not is_counter`.

- **`not is_counter` IS THAT LINE'S EXISTING DEFINITION OF A CAST.** Twelve lines below it, the
  Killing Cold and the Overtone's cast counter both read it — *"`is_counter` is excluded so a
  retaliation is not a cast"*. The floor inherits the definition rather than writing a second one.
  **Of the sixteen recursive `_resolve` calls in `battle.gd`, the nine that carry a blow on from a
  hero's action — counters, echoes and free strikes (Vengeful Guardian, Shatterpoint, Untouchable,
  Riposte, Opportunist among them) — all pass `is_counter = true`**, and the seven that pass false are
  enemy turns and the turns a hijack status borrows.
- **THE DEFAULT IS *NOT A CAST*, AND THAT IS WHAT KEEPS EVERYTHING ELSE BYTE-IDENTICAL.** The other
  three callers — Last Rites, Reckless Abandon and Blood Debt's Rage-equivalent — and `check_cz`'s and
  `check_ft` §1c's direct calls book exactly what they did. `check_cz` read **134 / 0** unmodified.
- **THE FLOOR NAMES MANA.** A Warrior's free basic books nothing, so Blood Frenzy's ledger does not
  move.
- **THE CODE THAT MOVED, PROVED BY A COMMENT-STRIPPED DIFF:** one line in `battle.gd` (the call gains
  `, not is_counter`) and seven in `unit.gd` (the step, the floor constant, the signature and the
  two-line clause). Nothing else.

### 2b. THE FLOOR IS 10, AND ITS REASON IS A RELATION

**It is Blink's price — the cheapest card a Mage can pay for.** Swept over every card a Mage of any
spec can hold, and confirmed on the driven casts: the only prices below 20 a Mage ever paid were
Blink's 10 and a family of 15s, and the 13s and 19s are those under Warded's ×1.25. `mod_cost_mult`
has one writer and it raises; Effortless zeroes a cost outright. **So a Mage's price is 10 or more,
or 0 — and a floor of 10 lifts no card he pays for.** In play it touches the free casts and nothing
else, which is why the two readings of "floor" (a minimum, or a value for zero only) cannot be told
apart in the game as it stands. **`check_ft` §5h asserts the relation**, not the number: the day a
Mage card is authored under 10, the gate reds and the floor is owed a ruling.

### 2c. THE ELEMENT-BLIND ASSERTION, POINTED AT THE NEW FORM

`check_ft` §1a still reads `note_resource_spent`'s body off the comment-stripped source and requires
it to name no `dmg_type`, no `ab.`, no ability, no `display_name`, no school, no element and no
`is_spell`. **Its positive half now also requires the body to name `CHANNEL_CAST_FLOOR`** — the
function reads the cost, the cast flag and the floor, and the assertion says so rather than going on
describing the two-term function it replaced.

### 2d. THE STEP IS 42 — THE MEASUREMENT

**The instrument.** A temporary probe line at the spend line printed every Mage resolution's cost and
net, and one at `_check_end` printed each fight's kind, rounds and the ledger. **It was self-checking**:
the sum of every fight's probed bookings had to equal the ledger that fight ended on — **7,797 fights,
0 disagreements**, so no Mana booking happened anywhere the probe could not see. `battle.gd` was backed
up before the probe and restored from the backup afterwards, **byte-identical to HEAD's blob**, before
the real change was made.

**The fights.** `DOD_SIM_ROWS=0` (a rung-1 player has no talents by construction), rung 1, `--run 100`
at each Mage spec, the same three beside him (Berserker, Devout, Beastmaster — the default party with
its Mage swapped). Measured with the switch OFF, because nothing can switch it on; an attached meter
would shorten a fight slightly and so read a little lower than this.

| rung-1 trash, untalented | fights | rounds | Mage casts / fight | free casts | costed net / cast | net Mana / fight |
|---|---|---|---|---|---|---|
| Pyromancer | 1,144 | 7.48 | 6.61 | **11.8%** | 23.1 | 134.9 |
| Cryomancer | 1,162 | 8.23 | 7.39 | **14.6%** | 24.6 | 155.2 |
| Arcanist | 1,102 | 8.04 | 5.57 | **8.6%** | 24.6 | 125.2 |

**The target:** *roughly half the +18% cap by the end of a normal fight* — three steps.

| floor / step | trash, mean steps at fight end (Pyro / Cryo / Arc) | medians | trash fights at the cap | boss fights at the cap |
|---|---|---|---|---|
| 0 / 40 — FT's form | 2.90 / 3.40 / 2.66 | 3 / 3 / 3 | 3.7 / 6.6 / 1.9% | 20.3 / 15.3 / 6.6% |
| 10 / 40 | 3.11 / 3.67 / 2.80 | 3 / **4** / 3 | 4.5 / 7.5 / 2.0% | 23.1 / 19.4 / 7.8% |
| **10 / 42 — SHIPPED** | **2.88 / 3.44 / 2.60** | **3 / 3 / 3** | **1.9 / 5.2 / 1.2%** | **16.1 / 13.2 / 5.8%** |
| 10 / 44 | 2.74 / 3.24 / 2.46 | 3 / 3 / 3 | 1.5 / 3.7 / 1.0% | 14.7 / 10.4 / 3.1% |

- **WHY 42:** with the floor fixed at 10 by its relation, 42 is the step that puts **all three medians
  at exactly three steps** and centres the three means on three (2.97 across the specs). At 40 the
  Cryomancer's median is four; at 44 the Arcanist's mean falls under 2.5. On bosses the meter reads
  4.18 / 4.12 / 3.25 steps and reaches the cap in 6–16% of fights — **present in a normal fight,
  with the cap left to long fights and bosses**, which is the brief's shape.
- **STATED PLAINLY, AS THE BRIEF ASKED: THE THREE SPECS CANNOT ALL LAND ON THREE WITH ONE PAIR OF
  NUMBERS.** They land at **2.60 to 3.44**, all three medians at three, and the gap is structural:
  **the Cryomancer takes 7.39 casts a trash fight and the Arcanist 5.57**, at the same 24.6 Mana a
  costed cast. A per-cast floor cannot move a difference in how many casts there are — and it widens
  it slightly, because the Cryomancer is also the one who casts free most often (the floor adds about
  **11 Mana a trash fight to him, 8 to the Pyromancer and 5 to the Arcanist**). **Closing it would take
  a rate per spec, which would make a class core a spec engine** — the one thing `CLAUDE.md`'s *A CLASS
  CORE IS A LEDGER* says a core may not be. None of the three lands far from the target; the Arcanist
  is the lowest and it is reported rather than averaged away.
- **THE FLOOR IS A SMALL TERM, AND THAT IS THE MEASUREMENT RATHER THAN A CHOICE.** At 22 regen a Mage
  seldom runs dry, so a free cast is roughly one cast in eight; FT's picture of a Mage falling back to
  his basic came from one fight at an economy priced at 12. **Most of the meter's pace was always the
  step.** At 10 / 42 the mean cast on which the third step arrives is the 6th–6.4th, in 55–77% of
  trash fights.
- **WHAT THE FLOOR ACTUALLY BUYS IS CONSISTENCY, NOT PACE.** After his 5th cast in a trash fight a
  Mage reads **2.04 / 2.40 / 2.23 steps** at FT's 0 / 40 — so the brief's *"2 steps by turn five"*
  holds — and **2.03 / 2.18 / 2.13** at 10 / 42. What moves is the share of fights with at least two
  steps by then: **83 / 91 / 93% → 96 / 98 / 98%**. A Mage who spends his early turns on free casts no
  longer sits at zero, and the larger step keeps the end-of-fight median where the target puts it.
- **PRESENT WITHOUT DOMINATING, MEASURED AS WHAT A CAST CARRIES.** The meter's value at the moment each
  cast resolves, averaged over every Mage cast in rung-1 trash, is **+3.6% (Pyromancer), +4.5%
  (Cryomancer) and +3.3% (Arcanist)** spell damage at 10 / 42 — against +3.8 / +4.7 / +3.3% at FT's
  form. The end-of-fight three steps is the ceiling of a normal fight, not its average.
- **ZERO MAGE COUNTERS OCCURRED IN 7,797 FIGHTS**, so the counter exclusion changed nothing measured
  here; it is structural, and §5d drives it.

---

## §3 — WHAT IS DELIBERATELY NOT DONE

- **Nothing is attached to any hero.** `check_ft` §0 still asserts the three spines are reachable by
  nobody and is still written to invert.
- **Momentum's and Sanctity's rates are untouched.** They are the designer's and are next.
- **Channel's partition (`CHANNEL_SPARES_PHYSICAL`) and the display question are still open**; this
  brief ruled on neither.
- **No spec dissolved, no pool merged, no engine became a rune, no talent node moved.**
- **`docs/master.html` is not edited and its stamp is not bumped**, per FT's ruling.
- **`CLAUDE.md` was not split and nothing was pruned.** The subject seam is named, not taken.
- **`check_ed`'s population was not widened.** The document half is `check_ec`'s, so nothing is owed;
  the procedure note is in the queue.

---

## §4 — VERIFICATION

**THE FLOOR.** `check_parse` **181 / 0** with the residue still 4, and **`Parse Error` and `SCRIPT
ERROR` grepped from every log at zero** — never a tally and never the exit code. The code change is
proved by a **comment-stripped diff: one code line in `battle.gd`, seven in `unit.gd`, and nothing
else**, because a comment insert has eaten a live line in this project before.

### 4a. THE PRE-PASS — EVERY UNMODIFIED GATE AGAINST THE NEW TREE, BEFORE ANY GATE WAS EDITED

**FA §1b's rule, and the brief's.** The tree held the code and every `CLAUDE.md` edit; every gate,
suite and baseline was HEAD's. **The prediction was written to the scratchpad before the launch**: `check_fg`
22 / 1 on its form arm, `check_de` flagging that, `check_cm_live` 13 / 4, everything else at its row.

| | pre-pass |
|---|---|
| targets / throws / timeouts / incomplete | **107 / 0 / 0 / 0**, one monotonic `.ran` sequence, no duplicates |
| `Parse Error` + `SCRIPT ERROR`, grepped from all 107 logs | **0** |
| the freeze, absolute paths, tracked + untracked + the four saves | **396 files, zero differ** |
| `check_cm_live` (deliberate) | **13 / 4 — its four FAIL lines word for word FT's own log** |
| `check_fg` | **22 / 1 — predicted** |
| `check_ec` | **24 / 2 — NOT predicted** |
| `check_ft` (HEAD's gate on the new code) | 79 / 0, §1e x1.1799, §1f x1.0000 |
| `check_de` | 445 / 2 / 1 |
| run harness | 22 / 166 / 8 |

**The miss is §1c**: the prediction named `check_ed` as the only pin gate, and the document half is
`check_ec`'s. Both reds were one literal.

### 4b. THE GATES, READ BEFORE THE BATTERY

`check_fg` **22 / 0**, `check_ec` **23 / 0** (back on its row), `check_ft` **112 / 0 on three readings
identical in every check line**, `check_parse` **181 / 0**. The three `check_ft` logs differ only in
Godot's exit bookkeeping (*"N ObjectDB instances were leaked at exit"*, reading 2, 4 and absent) —
**HEAD's own `check_ft` printed the same line in the pre-pass**, so it is not §5's, and the battery's
throw grep does not count it. **Two baseline rows were written before the battery**: `check_ft`
79 → 112 off the three readings, and `check_fg`'s note (its count did not move). **No gate was added,
so `check_parse` owes no row.**

**THE PIN MANIFEST:** **1,448 → 1,446 pins: exactly those two removed and nothing added**, `--check` current, and `check_ed` 18 / 0 against the regenerated file.

### 4c. THE DOCUMENT AND SOURCE EDITS WERE SWEPT, AND THE SWEEP WAS PROVED ABLE TO BITE

Every string literal of four characters or more in the complete reader population of each edited
file — both quote styles, unescaped by `build_pin_manifest`'s own one-pass `unescape` — compared
between HEAD's copy and the working copy in raw, lowercased and flattened form, so a re-wrap that
splits a needle reads as a loss:

| file | readers | needles | LOST | GAINED |
|---|---|---|---|---|
| `CLAUDE.md` | 31 | 570 | **0** | 0 |
| `docs/instrument-rules.md` | 5 | 82 | **0** | 0 |
| `docs/changelog.html` | 17 | 217 | **0** | 1 — `Blink`, an ability name in `test_batch_bq` |
| `docs/design-notes.md` | 4 | 105 | **0** | 0 |
| `docs/state.md` (widened — see under the table) | 8 | 179 | 2 — both `test_batch_as` needles into `battle.gd`; lowered or flattened, a third — `permafrost` | 1 — `test_batch_aw`'s `"patch"` dictionary key |
| `scripts/unit.gd` | 30 | 985 | **0** | 3 — `Blink` and `Effortless` (names in `bq` and `au`), and `CHANNEL_CAST_FLOOR`, §1a's own new needle |
| `scripts/battle.gd` | 74 | 2,456 | **0** | 0 |
| `baselines.json` | 1 | 20 | **0** | 0 |
| `pin-manifest.json` | 1 | 21 | **0** | 0 |

**`docs/state.md`'S ROW IS WIDENED, AND ITS RULE IS WRITTEN HERE BECAUSE EVERY OTHER ROW USES A
DIFFERENT ONE.** The other rows' populations are the files naming the edited file's `res://` path.
For `state.md` that is ONE file — `check_es`, the only gate that opens it — and under that rule the
row reads 47 needles and a clean zero. So the sweep was widened to the eight gates and suites that
name the file at all: `check_es`, `check_fr`, `check_dm`, `check_ek` and `test_batch_aj` / `as` /
`at` / `aw`. **Seven of the eight never open it** — six name it in a comment, and `check_fr` in a
list it asks `ways-of-working.md` about — so nothing that row lost or gained can be an assertion on
`state.md`. The third LOST, `permafrost`, is a passive id that `as` and `at` compare against a live
hero's `passive_id`. The widest population is eleven (add `check_de`, `scripts/classes.gd` and
`scripts/party_screen.gd`, each naming the file in a comment), and the post-run sweep in §4 used
all eleven.

**Every GAINED and all three LOSTs were checked at the call site**, not waved through: none is asserted
against the file it gained or lost in. **The sweep was armed on real needles taken off the needle
list**: deleting `check_fg`'s `THE CEILING IS 290 KiB` from `CLAUDE.md` in memory read LOST = 1, and
deleting `check_ft`'s `momentum_delay_mult()` from `battle.gd` read it LOST in both forms. Before
`check_fg` was repaired, `CLAUDE.md`'s sweep read exactly that one LOST — the finding, seen by the
second instrument as well.

**AND THE READER TEST WAS TOO NARROW FOR `state.md`, FOUND BEFORE IT COST ANYTHING.** A
`res://docs/state.md` needle finds ONE reader (`check_es`); FT's report counted twelve. A grep for the
bare file name found `check_fr`'s path list — a size comparison — and six files that name it only in
comments. **All eight were swept and re-run in the subset.**

### 4d. THE NEGATIVE CONTROLS

**Eight controls, each an exact-once injection into the real tree, the gate run standalone the way the
battery runs it, the file restored from a scratchpad copy and its md5 required to match the pre-control
stamp — and the whole tree re-stamped after the set.** Each prediction was written into the runner
before it ran.

**THE FIRST ARMING FOUND A DEFECT IN THE GATE'S MESSAGES, NOT IN ITS ASSERTIONS.** Every control bit
exactly where it was aimed — but the red lines read *"Wildfire books its 30 net — not 30"* and *"a cast
that could only take 9 books the floor 19"*, because I had put the MEASURED value in the slot the
sentence calls the expected one. **A failure message that contradicts itself is worst at the one
moment somebody has to read it**, and the project's rule is that a line reports what was measured
beside what was wanted. **Twelve §5 messages were rewritten to *reads X, want Y*; no condition changed
and no line moved** (the file's line count is identical, so the pin manifest's statement map cannot
shift), and **every control was re-run on the shipped copy.** The table is the re-run's.

| control | injected into | predicted | read |
|---|---|---|---|
| **C1** — the floor made ADDITIVE (`amount += floor`) | `unit.gd` | §5b and §5c at all three specs | **112 / 7** — §5b ×3, §5c ×3, and §5g's refund arm |
| **C2** — the floor IGNORED (`if false and cast …`) | `unit.gd` | §5a, §5c, §5f and §5g's cast arms | **112 / 10** — §5a ×3, §5c ×3, §5f and §5g ×3 |
| **C3** — COUNTERS given the floor (the call passes `true`) | `battle.gd` | §5d at all three, nothing else | **112 / 3** — §5d ×3 |
| **C4** — the floor on RAGE too (the Mana test dropped) | `unit.gd` | §5e ×3 and §5g's Warrior arm | **112 / 4** — exactly those |
| **C5** — the floor raised ABOVE BLINK (11) | `unit.gd` | §5h, alone | **112 / 1** — *"the floor 11 … the cheapest price a Mage can pay (Blink, 10)"* |
| **C6** — the build half taught to name a `dmg_type` | `unit.gd` | §1a, alone | **112 / 1** — §1a |
| **C7** — the ceiling sentence reworded, both statements | `CLAUDE.md` | §2's form and set arms, and the count falls | **18 / 2** — the arm returns early, 22 → 18 |
| **C8** — the threshold sentence reworded | `docs/instrument-rules.md` | §1's form and set arms, and the count falls | **17 / 2** — 22 → 17 |
| **C9** — a Mage pool names a card that exists nowhere (added after the reconnaissance run) | `classes.gd` | §5h's population arm, alone | **112 / 1** — *"1 membership names outside it"* |

- **THE RE-RUN READ THE SAME EIGHT COUNTS AND THE SAME ARMS, AND NOW THE LINES SAY WHAT HAPPENED.** C1:
  *"Wildfire reads 30, want its 20 net and never 30 — the floor is a minimum, not a bonus"*. C2: *"the
  free casts of all three Mage specs read [0, 0, 0], want [10, 10, 10]"*. C4: *"the Warrior's free
  Strike reads 10 Rage and 0 Mana, want 0 and 0"*. The three §5 messages left as they were already
  print both numbers in their right places — the project's FAIL-plus-property shape.
- **EIGHT SIGNATURES, NOT ONE CHECK FIRING EIGHT TIMES.** No two controls red the same set of arms.
- **C3 IS THE ONLY WAY THE COUNTER EXCLUSION CAN BE SEEN.** No Mage counter occurred in 7,797 driven
  fights, so the exclusion is structural and only a constructed counter can show it holding.
- **C5 IS THE RELATION ARM, AND IT IS WHY THE FLOOR CANNOT OUTLIVE ITS REASON.** The mechanism is
  untouched and only the reason fails — a floor raised to 11 still works perfectly, and is still the
  wrong number, because Blink would then book more than it cost.
- **C7 AND C8 ARE THE REPAIRED FORM CHECKS, PROVED STILL ABLE TO BITE.** Number-free, they red when the
  FORM goes, and the count falls with them — a disarmed gate shows twice. With HEAD's gate reading
  **22 / 1** on the new `CLAUDE.md` and the repaired one **22 / 0**, that is the repair's two-armed
  control: the old arm fails on the new tree, the new arm passes on it, and the new arm still bites.
- **Every file came back byte-exact, and the whole tree — 392 files — was identical after the set.**

### 4e. THE SUBSET, THEN THE ACCEPTANCE RUN

**THE SUBSET — 28 TARGETS, RUN BEFORE THE CERTIFICATION RUN, AND EVERY ONE ON ITS ROW.** Every
battery target that reads a document installed after the pre-pass (`docs/instrument-rules.md`,
`docs/changelog.html`, `docs/design-notes.md`), `state.md`'s two real readers and the six that name it
only in comments, and the gates this batch edited or that verify pins — **ten gates and eighteen
suites, zero throws, and every count exactly on its `baselines.json` row**, checked against the rows by
script rather than by eye: `check_ec` 23, `check_fg` 22, `check_ft` 112, `check_ed` 18, `check_ff` 55,
`check_dv` 83, `check_es` 57, `check_fr` 25, `check_dm` 93, `check_ek` 45, and the eighteen suites at
theirs — `test_batch_ce` 1114 and `test_batch_cb` 1730 among them. **The tree was re-stamped
afterwards and was identical.** A needle sweep has holes a run finds; this is the run, taken before the
one that certifies.

### 4f. THE FIRST ACCEPTANCE RUN WAS RECONNAISSANCE — AND THE HOLE WAS MY SUBSET

**107 targets, zero throws, zero timeouts, zero incomplete, zero `Parse Error`, the freeze held across
396 files — and one unpredicted red: `check_da` 43 / 2**, *"check_ft.gd hand-rolls the ability corpus
— `Classes.ability_corpus()` is the walk (BATCH DA §3)"*.

- **THE GATE WAS RIGHT.** §5h's first draft built its Mage population by resolving the three pools
  itself — a second enumeration, which `CLAUDE.md`'s *THE ENUMERATION IS `Classes.ability_corpus()`
  AND IT IS THE ONLY ONE* forbids in a gate. `check_da` §3's fingerprint is exactly that: a gate whose
  source carries both draft-pool accessors.
- **THE SUBSET COULD NOT HAVE SEEN IT, AND THAT IS THE LESSON.** It was chosen by which targets read
  the edited DOCUMENTS; `check_da` reads gate SOURCE. FF §3b's rule — a batch that writes an instrument
  owes the pass twice, the second once its own instrument is in the tree — was honoured in shape and
  missed in population. **After a gate edit, the second pass must include every gate that fingerprints
  gate source**: `check_da`, `check_dw`, `check_ea`, `check_ek`, `check_ff`.
- **THE FIX IS ON THE RULE'S OWN TERMS.** The population is now `Classes.ability_corpus()`; the pools
  answer only which corpus cards a Mage can HOLD — the award chain's question, which a flat list cannot
  answer — so the file still carries both accessors, and `check_da`'s own `WALK_EXEMPT` table gains the
  reasoned row it exists for: the fifth over-fire, `check_fk`'s shape exactly. **An exemption without
  the restructure would have been the violation with a permit**; the row was written after the
  population moved, and says so. The exempt loop asserts the file still carries the marks, so the
  exemption cannot outlive its reason — which is also why `check_da`'s count rises 42 → 43.
- **AND A NINTH CONTROL**, because the new population arm needed its own bite: **C9** renames Blink in
  the Mage class pool to a card that exists nowhere, and §5h's population arm must red alone — a
  membership name outside the corpus is counted, not dropped. C5 was re-run on the new §5h.
- **THE RED WAS NOT REPAIRED WHILE THE BATTERY RAN.** The run finished, every count was read, and only
  then was the tree fixed, re-verified and re-frozen for the second run.

**THE RE-VERIFICATION, BEFORE THE SECOND RUN — AND THIS TIME THE POPULATION WAS EVERY GATE THAT READS
GATE SOURCE.** `check_ft` **112 / 0 on three readings** (§5h now prints *"CHECKED 227 corpus cards; 57 a
Mage can hold, 0 membership names outside the corpus; cheapest price 10 (Blink)"* — the same answer,
reached through the sanctioned walk), `check_da` **43 / 0 on three readings**, and on their rows
`check_dw` 35, `check_ea` 86, `check_ek` 45, `check_ff` 55, `check_ed` 18 and `check_parse` 181 with the
residue still 4. `pin-manifest.json` stayed current at 1,446 — the restructure moved no pin, and the
exemption row is inside one `const` statement. **`check_da`'s baseline row moved 42 → 43** off the three
readings, and only that row moved. The changelog and `state.md` additions were swept before install and
again on the real tree: zero LOST.

**C5 AND C9, ON THE RESTRUCTURED §5h.** C5 (the floor raised to 11) still reds the relation alone —
*"the floor 11 is at or under the cheapest price a Mage can pay (Blink, 10)"* — and **C9** (Blink
renamed in the Mage class pool to a card that exists nowhere) reds the population arm alone: *"the
corpus walk read 226 cards, 56 a Mage can hold, 1 membership names outside it"*. The unresolvable name
was counted rather than dropped, and the relation still passed on the next-cheapest price — so C9 is
the arm that stops a pool typo from quietly moving the floor's reason. Both files came back
byte-exact, and the whole tree — 392 files — was identical after the pair.

**THE ACCEPTANCE RUN OVER THE SHIPPED TREE: 107 targets, 0 throws, 0 timeouts, 0 incomplete, `Parse Error` and `SCRIPT ERROR` grepped from all 107 logs at 0; `check_de` 445 checks / 0 failures / 0 notices; the one red is `check_cm_live` 13 / 4 with its FAIL lines identical to FT's; and the freeze held — 396 files md5-stamped with absolute paths before and after, zero differ, the four saves identical.**

| | the certifying run |
|---|---|
| targets / throws / timeouts / incomplete | **107 / 0 / 0 / 0** |
| `Parse Error` + `SCRIPT ERROR`, grepped from every log | **0** |
| `check_cm_live` (deliberate) | 13 / 4 — FAIL lines identical to FT's |
| `check_fg` | **22 / 0** |
| `check_ec` | **23 / 0** |
| `check_da` | **43 / 0** |
| `check_ft` | **112 / 0** |
| `check_de` (checks / failures / notices) | **445 / 0 / 0** |
| run harness (gates 1 / 2 / 3) | 22 / 166 / 8 |
| the freeze | 396 files md5-stamped with absolute paths before and after, zero differ, the four saves identical |
| the designer's four save files | byte-identical |

**AFTER THE RUN, AND SAID SO: TWO FILES WERE WRITTEN BEHIND THE CERTIFYING BATTERY** —
`docs/state.md`'s acceptance cells plus the last sentence of its battery bullet, and this section. Both
were filled from the run's own output, and neither was taken as safe on its file class alone:

- **`docs/state.md`'s reader population was taken by census, not remembered.** A `find` over every
  `.gd` outside `save-backups/` and `.godot/` gives ONE file naming `res://docs/state.md` —
  `check_es`, whose §4 lists it in `CENSUS_DOCS_SWEPT` — and no gate opens `res://docs` as a
  directory. `check_fr` names the path only to ask whether `ways-of-working.md` does, and
  `check_ec`'s five documents do not include it. **The first attempt at that census was aborted by
  zsh on an unmatched `data/*.gd` glob and printed nothing at all**, which reads exactly like a
  population of zero.
- **The change was swept against the copy the battery READ** (snapshotted, and md5-matched to the
  freeze stamp): over `check_es`, 164 literals and 47 needles, **LOST 0 in all three forms and
  GAINED 0** — and the sweep's control, deleting `exsanguination` from the shipping copy in memory,
  reported it LOST. **Over all eleven files that name `state.md` at all** (§4c's widened eight plus
  `check_de`, `classes.gd` and `party_screen.gd`), 2,527 literals and 409 needles read the same
  zero in every form.
  **`check_es` §4 reads that file by REGEX, which a literal sweep cannot see**, so its extraction
  was reproduced on both copies: two windows and the same four figures in each, matching the gate's
  own print in the certifying run.
- **Installed, then re-stamped against the certifying run's own list: 396 files, one differs, and it
  is `docs/state.md`.** `pin-manifest.json` reads current at 1,446 and was not written.
- **And `check_es`, re-run standalone against the shipped copy with `run_one`'s own command, printed
  a log BYTE-IDENTICAL to its battery log** — 57 / 0, no `Parse Error`, no `SCRIPT ERROR`, no FAIL
  line.
- **This report is read by no gate** and was not in the tree while the battery ran, so nothing in it
  is asserted by anything.

**THE SAVE BACKUP:** the designer's four files were copied to `save-backups/FU-20260910-092605` and
md5-verified against the originals and against FT's backup **before anything else happened**. All
four match FT's exactly, so nothing has moved since.

---

## §5 — WHAT NEEDS A RULING

1. **THE SUBJECT SEAM.** At 340 the next move is a split by subject — combat law or card law as a
   reference the main file points at — and it requires overturning EF's one-way tiebreak for that
   subject. It is the designer's call, and it is better made before the file is at 340 than at it.
2. **THE CHANNEL SPREAD, IF IT MATTERS.** The Cryomancer ends a trash fight near 3.4 steps and the
   Arcanist near 2.6 at one rate. If that is too wide, the lever is not the floor; it is whether a
   class core may carry any per-spec term at all.
3. **STILL OPEN FROM FT:** Channel's partition, Momentum's rate, Sanctity's rate, and how a second
   meter displays.
