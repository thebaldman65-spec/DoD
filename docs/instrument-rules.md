# Dawn of Decay — INSTRUMENT RULES

**THE FILE A BATCH IS REQUIRED TO READ IS `CLAUDE.md`, AT THE REPO ROOT. THIS FILE IS THE
REFERENCE IT POINTS AT.** It holds the standing rules that bind the INSTRUMENTS — the suites, the
gates, the battery, `baselines.json`, the negative controls, the sweeps and the censuses, and the
discipline for operating on the tracked documents. **It holds no rule about what the game may
contain**, and it is not a second place to look for one.

**THE SEAM IS WHAT A RULE BINDS, NOT WHAT IT IS ABOUT (SET AT EF §2).** A rule that governs how a
batch VERIFIES itself is here. A rule that governs what the GAME may contain is in `CLAUDE.md`.
**Where a rule does both, it stayed in `CLAUDE.md`** — a batch that reads only one of the two must
not be able to miss a rule about the game, so the tiebreak runs one way only.

**EVERY RULE BELOW IS THE `CLAUDE.md` TEXT, MOVED AND NOT REWRITTEN.** Not one character inside a
moved block was edited, and the two halves were asserted to re-concatenate byte for byte against
the pre-split file before either was trusted. **Only the two `##` section headings that carry the
orphaned `###` blocks are new**, and they are marked as this file's own.

**WHEN A RULE MOVES BACK OR ACROSS, THE PIN MOVES WITH IT IN THE SAME BATCH.** Four assertions were
re-pointed at this file when it was created (`check_ec` §2 twice, `test_batch_ce` twice), and
`build_pin_manifest.py` and `check_ec` both treat this file as a tracked document, so a pin written
against it is inside the instruments' territory rather than outside it.

**THIS FILE IS UNDER THE SAME CEILING PROCEDURE AS `CLAUDE.md` AND HAS NO STATED CEILING YET.** A
ceiling is DERIVED, not chosen, and deriving one is a ruling; the arithmetic is in
`docs/reports/EF.md` §2 and the live size is in `docs/state.md`. **Do not state this file's live
size in this file.**

---

## AN INSTRUMENT'S CORPUS MUST NOT CONTAIN WHAT THE INSTRUMENT REWRITES (STANDING, SET AT EE §2)
> **Before quoting a measurement, name the files in its corpus that the batch itself writes.** A
> measurement whose evidence includes the batch's own output is partly measuring its own input, and
> it reads exactly like a measurement that is not.

- **`docs/state.md` IS OUT OF ANY CITATION CORPUS, ALWAYS.** It is rewritten from scratch every
  batch, so *"is this rule quoted anywhere?"* is partly a question about what the last rewrite
  happened to say — **a rule can change category with nobody touching it**, and one did between EC
  and ED. `docs/reports/<CODE>.md` and `docs/changelog.html` gain the batch's own prose the same
  way; **name them, or report the number as the range it is.**
- **THE SHAPE HAS COST THIS PROJECT FOUR TIMES AND THREE OF THE FOUR WERE FOUND BY A DISAGREEMENT,
  NOT BY A FAILURE.** EC's greedy capture window was live *inside the census EC used to measure that
  very defect*. The sync ratio holds its own numerator, so a batch could meet the target by
  committing an unrelated file. **An instrument folded into its own subject reports a clean tree in
  the same words a clean tree does** — which is EA §1's rule arriving through the corpus instead of
  through an empty match.
- **THE FOUR PLACES THAT ALREADY CLOSE IT ARE THE PATTERN TO COPY**, so nobody re-derives them:
  `check_de` and `check_ed` each name themselves in a `SELF` constant and drop out of their own
  sweep; `check_ec` §3 deliberately binds **no** document holder, because a section building
  synthetic assertion text would otherwise be extracted as if a suite had written it; `check_da` §3
  keeps the same discipline for a gate whose source carries its own fingerprint.
- **WHERE THE CORPUS CANNOT BE NARROWED, WEIGHT IT OUT AND SAY SO.** A gate that must read a file
  the batch writes — `check_de` against `baselines.json` — is sound because the file is the CLAIM
  being tested, not evidence about it. **That distinction is the test: is the churning file the
  claim, or the evidence?**

## THE CHANGELOG IS ARCHIVED ON A SCHEDULE (STANDING, SET AT BATCH CW §4)

BZ split the changelog once, by hand, when it got too large. **This is that split as a rule
rather than an event.** **CX is the first cut made BY the rule** — live 494.2 KB → 162.1 KB at the
CN/CO boundary, 23 entries moved, 140 entries before and after. Its two lessons are folded in
below.

- **THE THRESHOLD IS 400 KB.** When `docs/changelog.html` exceeds it, cut at the next batch
  boundary and move the OLDEST entries into `changelog-archive.html`, leaving the live file the
  most recent ones. Aim to leave the live file around 150 KB — the size BZ's own cut produced —
  so the next cut is many batches away rather than immediate.
- **CUT AT A BATCH BOUNDARY AND EDIT NO ENTRY.** The live file starts at a batch; the archive
  ends at the one before it.
- **ARCHIVE MEANS MOVE OUT OF THE REPO, NEVER DELETE** — to `/Users/zipples/Documents/DoD-archive/`,
  beside the `.docx` exports. **The live file never moves**, which is why `docs/build_docs.py`
  reads it by relative path and keeps working.
- **ASSERT THE HALVES RE-CONCATENATE BYTE FOR BYTE BEFORE TRUSTING THE SPLIT.** Extract every
  `<h2>` heading from the original and from both halves: the counts must sum, with zero overlap
  and order preserved, and the two bodies joined must be byte-identical to the original.
  **A split that drops one entry of 140 is invisible and no suite would catch it. Do not assert
  file sizes** — sizes agreeing is consistent with a duplicated entry and a dropped one.
- **AN `<h2>` DOES NOT ALWAYS FIT ON ONE LINE, AND A LINE-ANCHORED EXTRACTOR WILL QUIETLY MISS
  ONE.** Batch BF's heading wraps, so `^<h2>.*</h2>$` counts 107 where the archive holds 108.
  **Match across lines, and count the same thing two different ways** — CX caught this only
  because a `grep -c '^<h2>'` and a regex disagreed by one, which is exactly the size of the
  error the byte-for-byte rule exists to catch.
- **VERIFY FROM A BACKUP, WITH A SECOND SCRIPT.** The splitter asserting its own arithmetic proves
  the splitter self-consistent, not the split correct. CX re-derived every heading from untouched
  copies of both original files and asserted each of the 140 appears **exactly once** across the
  two halves, and that none was invented.
- **BOTH HALVES CARRY A HEADER NAMING THE OTHER**, with the counterpart's full path. In a year
  neither file's contents will say where the rest went.
- **ANYTHING THAT READS THE CHANGELOG FOLLOWS CD'S PATTERN — ANCHOR ON THE `<h2>` HEADING, AND
  REACH THE ARCHIVE BY FOLLOWING THE PATH OUT OF THE LIVE FILE'S OWN HEADER, NEVER BY
  HARDCODING IT.** A bare `changelog.contains("Batch BN")` is satisfied by a LATER entry naming
  that batch in its own prose, so it **passes without its subject being in the file at all** —
  a check that has stopped asking its question, with no throw to announce it. Two suites have
  done exactly this.
- **THE CUT IS NOT DONE UNTIL EVERY SUITE WHOSE ENTRY MOVED IS RE-POINTED, IN THE SAME BATCH.**
  CX moved 23 entries and re-pointed **eleven suites** (bp, bq, br, bs, bt, bu, bv, bw, bx, cb,
  ce). **Eight of them would have gone on PASSING** — a bare `contains("Batch XX")` is satisfied
  by a later entry naming the batch in prose. BZ left that debt for BB, CD found the same thing in
  BO two batches later; **it is cheaper by far to repair it in the batch that causes it.**
  Fourteen suites now read the archive, so a cut that forgets this breaks a suite the batch never
  touched.
- **A FILE IN THE ARCHIVE IS NOT IN VERSION CONTROL AND IS NOT BACKED UP BY GITHUB.** If the
  machine is lost, it is lost with it. The archive folder must live somewhere the machine backs
  up — iCloud-synced Documents, a Time Machine target, or a second private repo. **At BZ none of
  the three was in place, and it is the designer's call to fix.**

## ON A SPLIT-CLAUSE CARD, EVERY PIN NAMES THE CLAUSE IT PINS (STANDING, Batch DM §2)
> **A pin that matches the CARD rather than the CLAUSE can go red for the wrong reason, or stay
> green while its subject moves — which is the failure pin-as-measurement exists to prevent.**

- **ANCHOR ON THE CLAUSE LINE AND SEARCH BACKWARD FOR THE WALK.** The clause line is the unique
  half; the walk is often shared. **FIVE sites in `battle.gd` spell
  `heroes.filter(func(he): return not he.dead and not he.is_companion)` byte for byte** — Bulwark
  and Consecrated Ground among them — so a forward `find` from the walk reads the wrong site four
  times in five. **`check_dm` §1 asserted TWO on its first run and the gate caught it**, which is
  the count-in-a-brief fault landing inside the instrument written to prevent it; the live count is
  PRINTED now and the assertion is the property (`> 1`) rather than a number. **DL was bitten by exactly this** — a
  forward `find` on War Stomp's guard measured a site 200k characters earlier — and fixed the
  fragments rather than the direction. `check_dm` §1 fixes the direction, and asserts that the two
  walks are STILL shared so the hazard cannot quietly disappear.
- **TWO OF `check_dk`'s ELEVEN PINS WERE AUDITED AND BOTH MOVED.** Its `wd_hold_line` entry pinned
  the `hold_bd` clause and stopped — **`undying` is a second group clause in the same loop and
  could have been moved onto bare `heroes` with that entry still green.** Its `dv_waters` entry
  pinned the rank-and-roll gate, which keeps nothing narrow: **the table's heading says "the read
  line that keeps them narrow" and that fragment would have stayed green with the whole turn-start
  block deleted.** Re-pointed at `_next_unit()`'s walk, which is what actually excludes a companion
  — and which serves the whole per-turn family, so one pin replaces three copies.

## A SUITE MUST NOT PIN THE SAVE VERSION LITERAL (STANDING — BK §6's RULE, RE-LEARNED AT CT)
**Three batches have now broken a sibling suite by bumping the save version.** BL's recap ledgers
broke BK's pinned `8`; BM's move to `10` broke it again; **CT's move to `11` broke `test_batch_bl`
and `test_batch_bm`, both of which pinned `10`.** BK §6 was re-pointed to **"8 or later"** with a
comment saying "so the next bump does not fail a map test either" — and BK is the one that passed.
- **A suite asserts the INVARIANT IT OWNS, never the newest number.** BL owns "the recap ledgers are
  in the save"; BM owns "the party and its equipped talents are in the save, and a pre-v10 save is
  refused". Neither is a claim about which version is current.
- **The idiom is BK's, and all three now use it:** parse the number out of the source and assert
  `>=` a floor. Do not write `contains('"version": N')`.
- **The refusal floor is a SEPARATE assertion and it is fine to pin** — `if save_version < 10:` is a
  real invariant about what this build will load, not a moving number.
- **THE SAME DISEASE, THIRD DOOR: `test_batch_bx` pinned the SOURCE TEXT of a guard.** CT split
  `if Run.sim_run or _draft_columns().is_empty():` into two guards so §3's chaining had somewhere to
  live; the behaviour is identical. Re-pointed and **SCOPED TO THE FUNCTION BODY** — strictly
  stronger than the global `contains` it replaced, which would have passed on either of the two
  `if Run.sim_run:` lines elsewhere in that file. **A source-grep suite should scope to the function
  it is talking about**, or it is asserting that a string exists somewhere in 2,000 lines.
- **NOT EVERY PIN IS A MISTAKE, AND `test_batch_ce`'s GLOSSARY COUNT IS THE COUNTER-EXAMPLE.** Its
  comment says the count is pinned *deliberately*, so growth "should have to be stated rather than
  absorbed". **Bump it and say what was added and why; do not loosen it to `>=`.** CT bumped 94 → 96
  and, in doing so, deleted three entries it had already written — per-item entries for the three new
  items, each fully described by its own tooltip, in a category (`run`) that has never held one.
  **The pin did its job: it forced the question and the answer was "two, not five".**

## THE BATTERY IS A SCRIPT NOW — `run_battery.sh` (STANDING, SET AT CP §1)
It was reconstructed by hand every batch, and this file carried three scars from that. All three
are baked in: **flags in an ARRAY** (zsh does not word-split an unquoted expansion, which silently
under-ran `test_batch_bl`), a **count grep that accepts a comma or none**, and a **`^ *FAIL` grep
that needs no indent**. Two are CP's own:
- **A PER-SUITE WATCHDOG, because a hang has no count and a hung suite takes the whole battery with
  it.** Every later count then goes MISSING rather than wrong, which is the one failure mode a
  count-diffing rule cannot catch. A timeout is reported as its OWN outcome.
- **A LOCK, because killing a hung suite's Godot does NOT kill the battery that spawned it.** Two
  invocations ran into one log directory during CP, every count became whichever process finished
  last, and nothing errored. That run was discarded.
- **THE SUITES PRINT COUNTS IN FIVE DIFFERENT FORMATS** (`N checks, M failures` / `N passed, M
  FAILED` / `N checks / M failures` / `checks: N  failures: M` / `sections: S  checks: N
  failures: M`), so any single grep reports `?` for some. **A COUNT THE HARNESS CANNOT PARSE IS
  WORSE THAN A COUNT NOBODY DIFFS** — CD's rule, one layer further out.
- **BATCH DE ADDED THREE THINGS AND REMOVED ONE.** `test_batch_cp` is in `SUITES` at last (it was
  in no array and only `test_batch_cd` ran it); the script writes a **manifest** of what it ran;
  and the **count differ runs as a post-pass at the end** (`check_de`). **`TMO[test_batch_cd]=2400`
  is gone** — that bound existed only because the suite spawned forty-five child Godots, and
  nothing in `SUITES` spawns a suite any more.

## THE COUNT DIFFER IS A PROPERTY OF THE RUN, NOT OF A SUITE IN IT (STANDING, SET AT BATCH DE)
> **Comparing this run's counts to recorded ones belongs to the RUNNER.** A suite that spawns
> suites **squares the work when you widen it**, so the instrument gets more expensive exactly as
> it gets more useful — and the only lever left is to watch less.

- **ASK WHAT THE SUITE DOES THAT THE RUNNER CANNOT, AND ACCEPT "NOTHING" AS AN ANSWER.**
  `run_battery.sh` already spawns every target, captures every stream INCLUDING STDERR, greps the
  count shapes and counts the throw markers. **The only thing it did not do was COMPARE.**
- **THE DIFFER IS `check_de.gd`, A POST-PASS THAT READS THE LOGS THE RUNNER WROTE AND SPAWNS
  NOTHING.** It runs last, so it covers the gates, the harness and the scene runs too. **Reading a
  file cannot nest, so the nesting is structurally impossible rather than merely avoided**, and the
  table may hold the suite that could never watch itself.
- **IT IS RE-RUNNABLE IN SECONDS** over a log directory that already exists, and the answer cannot
  drift because the evidence is fixed. **That is what lets a batch write `docs/state.md` and its
  report AFTER the battery and still certify the tree.**
- **WRITTEN IN GDSCRIPT, NOT IN SHELL.** Bash string handling is how the count grep came to be too
  narrow three times, and how a message spelling a throw marker out in full would make the battery
  accuse the differ of throwing. **The count-differ has been mis-instrumented twice; it is not a
  place to be clever.**
- **A FALL AND A RISE ARE NOT THE SAME EVENT, AND THE POLARITY INVERTS BETWEEN THE TWO HALVES.**
  A **FALLING CHECK COUNT** is this project's signature failure — **ERROR**; a RISING one is
  usually a suite's own loop walking new content — **NOTICE**. So **the FLOOR of a band is
  asserted and the ceiling is not.** A **RISING FAILURE COUNT** is the extra red nobody named —
  **ERROR**; a FALLING one means something was repaired — **NOTICE**.
- **BASELINE THE FAILURE COUNT PER SUITE — IT IS WORTH MORE THAN THE CHECK COUNT.** Among dozens of
  known failures **one more is invisible**, and a suite already red for an unrelated reason is
  where a real finding hides for batches. **A red check does not announce a second problem
  underneath it.** A suite going 6 red to 7 is reported exactly as loudly as one going 0 to 1.
- **A NOTICE IS NOT SILENCE. A BASELINE MOVES ONLY IN THE BATCH THAT CAUSES THE MOVEMENT, AND THE
  CHANGELOG SAYS WHY.** Otherwise the table drifts into whatever the code happens to do.
- **THE RUNNER WRITES A MANIFEST (`$OUT/.ran`) AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `$OUT` is not cleared between runs, so a target that failed to launch would otherwise
  be blessed by its PREVIOUS run's log — **the one fault a count-differ must never commit.** A
  subset invocation writes a short manifest and **the differ says so instead of reporting a clean
  tree.**
## NEVER ASSERT AN EQUALITY AGAINST A COLLECTION THAT GROWS (STANDING, SET AT DX §1)
> **Changelog entries, corpus size, pool depth, suite counts, call-site counts — assert a FLOOR,
> or assert a PROPERTY.** An equality against a growing set fails on the next batch that does its
> job, and **the failure looks like a regression.**

**THIS IS CD §1's FAULT AND DX IS ITS SIXTH INSTANCE, WHICH IS WHY IT IS A CONSTRUCTION RULE
RATHER THAN A SIXTH TRAP.** The shape turned five suites red at once at CJ; `check_dv` §4 read
`live_span == 16` against a changelog that gains an entry every batch, so **DV's own acceptance was
the only run that could ever satisfy it and DW's own entry broke it.**

- **THE HARM IS NOT THE FAILING, IT IS THE FAILING'S DISGUISE.** A red that means *"a batch did its
  job"* is indistinguishable from a red that means *"something was deleted"*, and the next reader
  has to re-derive which. **A floor's failure has exactly one meaning: something LEFT.**
- **AND THE SECOND HARM IS THE COUNT OF SITES.** DX's sweep found **forty-one equalities across
  thirteen files pinning ONE growing number** — the draft total — with `>=` nowhere. DO, DR and DS
  each authored cards and each had to hand-bump a dozen files, and **a batch that missed one would
  have shipped a red that read as a regression.** **THIRTY-FIVE ASSERT A FLOOR NOW; the six that stay
  are all in `test_batch_cd`.**
- **THE MESSAGE MOVES WITH THE OPERATOR.** A floor whose message still says *"holds 149"* has been
  half-repaired: it must name the **live figure** and the **direction** — *"has FALLEN to %d, below
  the 149 that shipped"* — or the reader still cannot tell the two meanings apart.

### THE ONE EXEMPTION, AND IT IS NARROW: A STALENESS TRIPWIRE

> **A staleness tripwire is a SINGLE site whose failure message says the ground moved and names
> what to re-derive.** It is a property assertion wearing an equality's clothes, and it is
> legitimate. **Thirty copies of one is not a tripwire, it is a tax.**

**A FLOOR CANNOT SEE A THING ARRIVING, AND SOMETIMES THE ARRIVAL IS THE EVENT WORTH CATCHING.**
`check_di`'s `CALL_SITES` equality caught DP silently deleting an `_apply_status` site, which is
exactly what it is for — and its sibling `SRC_FLOOR` is a ratchet, because that one measures
progress. **The pair is the model: the tripwire and the ratchet, side by side, each doing the job
the other cannot.**

- **THE TEST FOR THE EXEMPTION IS TWO QUESTIONS, AND BOTH MUST PASS.** *Is this the only site that
  pins this number?* and *does its failure message read as a notice rather than as a regression?*
  DX's sweep left five instruments standing on that test — `test_batch_cd`'s draft targets (beside
  `PER_SPEC_DEPTH`, the authoritative table a new card must move anyway), `check_di`'s
  `CALL_SITES`, `check_dv`'s two boss-pool census pins and its Holy-pool pin, and `check_cz`'s
  `SHIELD_SPECIALS` registry. **Count the SITES, not the files** — `test_batch_cd` holds six
  assertions and is one instrument.
- **PUT THE TRIPWIRE WHERE THE EDIT ALREADY HAS TO LAND.** The equality that survives belongs
  beside the authoritative table, so a batch that trips it makes ONE edit rather than twelve.
- **AND A TRIPWIRE THAT CANNOT SAY WHAT MOVED IS NOT ONE.** `test_batch_cd`'s message read
  `"the draft stands at %d of %d" % [DRAFT_TARGET, DRAFT_TARGET]` — the target twice, so the single
  assertion left to announce a moved draft would have reported *149 of 149* while the draft stood
  at 150. **That is the second-copy-of-a-count defect sitting inside the instrument written to
  catch drift**, and DW found the identical shape in two `test_batch_cp` messages one batch
  earlier. **When you keep an equality, make its message print the live figure.**

### REPAIR TO A FLOOR OR A PROPERTY, NEVER BY DELETING THE CHECK

**A count that FALLS is still the signal worth having; what must go is the ceiling that no longer
means anything.** This is CQ §3's rule applied to an operator rather than to a value.
- **NEGATIVE-CONTROL A FLOOR IN BOTH DIRECTIONS, BECAUSE A FLOOR THAT CAN NEVER FAIL IS THE HOLLOW
  CHECK THIS PROJECT HAS SPENT TWENTY BATCHES REMOVING.** Take one item OUT and confirm every floor
  reds; put one IN and confirm the floors stay silent **while the one surviving tripwire still
  fires.** DX ran both: a removal reds `check_dr` (2), `test_batch_cd` (5), `cp` (2), `bt` (1) and
  `ce` (4); an addition leaves all eleven floor files green and reds `test_batch_cd` alone, most
  sharply as `warden drafts 10 (want 9)`.
- **CONVERTING `==` TO `>=` MOVES NO CHECK COUNT** — one `ok()` before, one after — so a count that
  moves across this repair means an assertion was removed rather than re-pointed. All thirteen
  targets DX touched read their baselines exactly.
- **A FROZEN COLLECTION IS NOT A GROWING ONE AND ITS EQUALITY IS CORRECT.** The changelog ARCHIVE
  keeps `== 149` because only a cut moves it. **Ask whether a batch doing its job would ADD to it
  — that is the whole test.** (`CLASS_POOLS`' byte-freeze pins were the other example DX named;
  **DY §3 deleted that dict**, and those six pins assert its ABSENCE off the source now, which is
  the same claim made about a structure that is gone.)
- **AND THE FIRST SWEEP MISSED ONE, WHICH IS THE LIMIT OF A SWEEP BY ACCESSOR NAME.** DX's sweep
  matched `ok()` conditions that name a pool accessor, and `test_batch_bq` §3/§4 reads
  `live.size() == 6` where `live` was assigned from `class_draft_pool()` two lines up. **It was the
  exact site the next batch to author a class-wide card would trip**, and DY was that batch.
  **A CONDITION READING A LOCAL IS STILL A CONDITION READING THE POOL** — sweep the variable, not
  just the call.

## PIN THE RULE, NEVER THE BATCH CODE (STANDING, SET AT EA §2)
> **A pin on a batch code tests WHEN something was written; a pin on a rule tests that the rule is
> still there.** `CLAUDE.md` stopped narrating batches at CW's split, so a check reading
> `contains("BATCH XX")` against it is asserting the presence of a structure that no longer exists.

- **AND EACH ONE PASSED ANYWAY, WHICH IS THE HALF WORTH KEEPING.** All six EA re-pointed were
  satisfied by a STANDING RULE that names the batch in passing — the difficulty ladder's
  attribution, the governor table's rewrite marker, the content-batch convention. **A check that
  passes for a reason other than the one it states has stopped asking its question**, and it reads
  green while it does it.
- **THE SHAPE HAS TWO FORMS AND THE SECOND IS THE ONE A READING MISSES.** A BARE pin
  (`contains("BATCH BS")`) is visible; a pin whose literal merely CARRIES a code
  (`contains("BATCH BN §2 — WAS x0.70")`) is a real rule pin that still reds the day the
  attribution is edited. **Re-point both: assert the number, the heading or the sentence — the
  thing the batch bought, not the batch.**
- **SWEEP BY THE VARIABLE HOLDING THE DOCUMENT, AND SCOPE IT PER FUNCTION.** Grepping for the
  filename finds the read, not the needle three hundred lines below it; and `test_batch_bx` binds
  the name `master` three times in one file — twice to a STRIPPED copy and once to the raw
  document — so a file-scoped map reports a violation that is not there. **DZ found three of these
  by reading and predicted a fourth it would not find. The fourth was one line below the third.**

## A SWEEP ASSERTS ITS OWN POPULATION, OR IT CANNOT TELL "CLEAN" FROM "READ NOTHING" (STANDING, EA §5)
> **Every sweep prints and asserts how much it looked at.** A walk that matched no files, no
> literals or no rows reports *no violations* in exactly the same words as a clean tree.

- **EA's OWN CONTROL FAILED THIS WAY AND IT IS WHY THE RULE IS HERE.** A probe asking which runes
  grant an ability read `runes.json` as an Array; it is a **Dictionary**, so the walk never ran and
  printed *"rune entries naming an ability grant = 0"*. **The real answer is four**, two of which
  collide with a spec draft pool. The number was wrong in the safe-looking direction.
- **AND AN EXTRACTOR IS A POPULATION TOO.** EA's needle verifier read **32** asserted literals
  where there are **95**, because it counted brackets inside string literals and glued every
  statement after a `"("` into one. **Mask the strings before counting depth**, take EVERY call in
  the logical statement rather than the first, follow chained calls (`doc.to_lower().contains(…)`),
  and model `or` groups — demanding both halves of an `or` is a false alarm, and a false alarm is
  how an instrument gets switched off.
- **AND EB §3 RE-MEASURED THAT HOLE: IT NEVER LOST A LITERAL, IT LOST THE BOUNDARY BETWEEN
  ASSERTIONS — WHICH IS WORSE.** Reading the tree with string-masking disabled finds the **same 124
  distinct asserted literals** (90 positive, 34 negative) as the fixed extractor. What collapses is
  the GROUPING: **73 positive groups become 45 and 30 negative become 25**, because an unbalanced
  `"("` glues the following statements into one. **An or-group passes when ANY member is present**,
  so 28 independent assertions were being satisfied by a sibling's hit rather than their own —
  a check passing for a reason other than the one it states, inside the instrument built to find
  exactly that. **The count to assert is the GROUP count, not the literal count.**
- **AND EC §1 RE-MEASURED IT A SECOND TIME. THE OR-GROUP SPLITTER HAD NEVER FIRED ONCE.** EB's
  build modelled `or` by splitting a statement at a TOP-LEVEL `or` — and **every assertion in this
  tree is wrapped in `ok(...)`, so the operator sits one bracket in and the depth-0 scan found none
  in any of the 82 files.** Every statement collapsed to a single group, and that group was
  satisfied when ANY member was present. **So a CONJUNCTION was being evaluated as a DISJUNCTION**:
  `contains(A) and contains(B)` passed on A alone. The splitter was not mis-tuned, it was
  unreachable, and a literal census reads the same 125 members either way.

## A GROUP OF LITERALS IS EVALUATED AS THE OPERATOR JOINS IT (STANDING, SET AT EC §1)
> **A GROUP OF LITERALS IS EVALUATED AS THE OPERATOR JOINS IT.** `and` means EVERY member must
> hold; `or` means ONE suffices. **Find the operator at the depth of the boolean EXPRESSION, not at
> the depth of the statement.**

- **THE TWO FAILURES ARE OPPOSITE AND BOTH ARE FATAL.** Satisfying a group when any member holds
  passes a conjunction on a sibling's hit — a check passing for a reason other than the one it
  states, silently. Demanding every member reds a genuine alternation — and **a false alarm is how
  an instrument gets switched off**, which is why the header sweep was left un-gated at 118 rows
  for 16 defects.
- **MEASURED, ON THIS TREE: 103 asserting statements, 125 members, 10 CONJUNCTIONS and 9
  ALTERNATIONS.** Six of the nine alternations have a member that is legitimately absent, so a
  repair that treated every group as a conjunction would raise **six false alarms on the first
  run**. All ten conjunctions hold in full, so the hole cost nothing HERE — **it was a live
  blindness with no live defect under it, and that is a thing worth writing down rather than
  discovering again.**
- **ASSERT THAT THE MODEL FITS, DO NOT ASSUME IT.** `check_ec` §1 reds on a statement that mixes
  `and` and `or` at the boolean depth, because a two-shaped evaluator cannot judge one and
  guessing is how the first hole was dug.
- **AND THE SAME BOUNDARY GOVERNS POLARITY.** `not` may sit behind a RECEIVER, not just behind
  whitespace — `not FileAccess.get_file_as_string(…).contains("const CLASS_POOLS")` — and a fixed
  look-behind for `not\s*$` reads that as POSITIVE and reports a deliberately-absent literal as a
  needle that no longer resolves.
- **UNESCAPE IN ONE LEFT-TO-RIGHT PASS, NEVER AS A CHAIN OF `replace` CALLS.** A chain that runs
  `\n` before `\\` turns an ESCAPED BACKSLASH followed by `n` into a real newline, so a suite
  pinning the two raw characters a source file holds matches nothing. Six pins into `classes.gd`
  read as unresolved for that reason alone.

## AN INSTRUMENT'S TERRITORY IS A CLAIM (STANDING, SET AT EC §2)
> **AN INSTRUMENT'S TERRITORY IS A CLAIM, and a check living outside it is not protected by it.**
> Before trusting a green sweep, say what its haystack IS — and what it therefore is not.

- **THE POPULATION NOBODY HAD MEASURED: assertions that pin a literal into a `.gd` SOURCE file
  outnumber the ones pinning the four tracked documents, and every document instrument this project
  owns watches only the documents.** **THE LIVE FIGURES ARE NOT WRITTEN HERE**: `pin-manifest.json`
  carries them and `check_ed` prints them every battery, which is DJ §3's rule — a number with an
  instrument behind it cannot rot, and a number in prose always can. **EC's own copies proved it
  inside one batch**: the report and `docs/state.md` said 915, the changelog said 917 four times,
  and ED's re-derivation says both were low.
- **THE EXPOSED SUB-POPULATION IS THE COMMENT-RESIDENT ONE**: positive pins whose literal resolves
  ONLY inside a COMMENT of the target file, most of them into `classes.gd` and `battle.gd`.
  **A batch rewording one of those comments reds a suite with every document instrument green**,
  which is exactly what happened at EB. **`check_ed` §3 counts them and names the files**, and it
  asserts the `AXIS`/`SYNERGY` header convention is pinned by six different tranche suites at once —
  worth knowing before anybody tidies those headers.
- **COVERAGE IS RULED ON NOW, AND THE RULING IS THE MANIFEST (ED §2).** Extending the document
  instruments to source costs the noise the paragraph above warns about, and a rule saying "do not
  pin source" invalidates every existing pin. **`build_pin_manifest.py` DERIVES the manifest and
  `check_ed` ENFORCES it**, and that split is what stops it going stale: attribution needs holder
  propagation through function parameters, enforcement needs none, so the enforcing half cannot
  drift from the deriving one. **§1 verifies every recorded pin still resolves as recorded; §2
  catches a pin added without an entry; what §2 CANNOT see is written down at §2 itself.**
- **AND THE CENSUS FOUND A LIVE ONE.** `test_batch_bg` §2 sliced `battle.gd` from
  `find("# The fifth stack:")`, which BH had already deleted. `find` returned **-1**, Godot's
  `substr` on a negative offset returns **""**, and `not "".contains(anything)` is true — so **two
  checks passed while reading nothing at all**, and the comment above them already said the
  question was "asked of the whole branch". **A slice built from a `find()` is only as real as the
  anchor: assert the anchor resolved.**
  - **TWO THINGS LOOK LIKE THAT ASSERTION AND ARE NOT (EE §4).** **A ternary is not a guard**:
    `x.substr(i, n) if i >= 0 else ""` reads exactly like one and is the mechanism that makes the
    vacuum SILENT — it converts a crash into a negative assertion that holds for every needle.
    **And an ALTERNATION member does not prove its own slice**: `ok(slice.contains(A) or
    whole.contains(A), …)` is satisfied by the sibling while the slice reads nothing, which is EC's
    group boundary arriving one layer down. **Only an `ok()` on the OFFSET, or a positive read of
    the slice that stands ALONE, is a guard.**
  - **AND THE SWEEP FOR THIS SHAPE IS RE-RUN, NOT TRUSTED ONCE.** ED swept 87 slices and repaired
    three; re-derived at EE over a wider population it found **three more**, two of them on a
    COMMENT anchor — the fragile residency class — and one feeding a `for` loop rather than a
    `contains`. **The vacuum wears whatever the call site wears.**

## A SCAN THAT CAPTURES A WINDOW IS BLIND TO WHAT THE WINDOW SWALLOWED (STANDING, SET AT ED §2)
> **Capture the ARGUMENT, never a fixed span after it.** `finditer` resumes at the END of a match,
> so a greedy tail eats every later call in the same statement — and the second member of a
> conjunction is exactly what disappears.

- **THIS IS EC §1'S DEFECT IN A SECOND INSTRUMENT, AND EC'S OWN CENSUS WAS THE VICTIM.** EC closed
  the or-group boundary in the DOCUMENT sweep and measured the source population at **915** with a
  `.{0,600}` window still open. `ok(src.contains(A) and src.contains(B), …)` yielded A and stepped
  over B. **The live figure is 1014.** A census cannot audit itself: the same statements are read
  either way and the total looks plausible at both.
- **THE TELL IS A COUNT THAT MOVES WHEN THE CAPTURE NARROWS**, not a failure. Nothing errored, and
  the population was quoted into a brief and a report before anybody re-derived it.
- **THE SAME BUG HAS A SECOND FORM: A LINE-BOUNDED BINDING.** `var src := _strip_comments(` with
  the `res://` path on the NEXT line binds nothing under `[^\n]*`, so every pin in that function is
  invisible. **Bind holders from STATEMENTS, which join continuations, never from lines.**
- **AND A THIRD, WHICH IS THE ONE THAT LOOKS LIKE PROSE:** masking only double-quoted strings
  leaves an unbalanced `(` inside a SINGLE-quoted one, depth never returns to zero, and sixty lines
  join into one statement. **GDScript has both quote styles; a masker that knows one is a
  statement-merger.** Strip comments first, or an apostrophe in prose opens a string that never
  closes — that one ate a third of the tree's declarations in ED's first build.

## A COMMENT NAMING CODE IS A CLAIM, AND IT GOES STALE SILENTLY (STANDING, SET AT EB §2)
> **A comment naming a function, constant, ability or field is a claim that can go stale silently.
> When a batch deletes or renames something, it sweeps the comments too** — the compiler will not,
> and nothing else does.

- **FOUR INSTANCES OF ONE SHAPE EARNED THE RULE, AND THE SWEEP FOUND SIXTEEN.** Flash Freeze's
  suspension comment outlived both its justifications; `_hold_freeze`'s header said three callers
  where there were four; `battle.gd` listed Regalia as a live shield source that had never fired;
  `vault_ability()`'s header described the seven as returnable after they had been returned.
- **REPAIR BY DELETING THE STALE CLAIM WHERE THE THING IS GONE; CORRECT THE NAME WHERE THE THING
  ONLY MOVED.** DR's rule from Flash Freeze stands — *a comment corrected to describe a deleted
  feature is still a comment about a deleted feature* — but it is about DELETIONS. A RENAME leaves
  a live claim wearing a dead name, and deleting it throws away something true.
- **A COMMENT THAT RECORDS A DELETION IS CORRECT AND MUST NOT BE SWEPT.** Of the 118 unresolved
  names EB §2's sweep raised, **71 were records** — *"`CLASS_POOLS` IS DELETED"*, *"`_overburn_drain`
  is deleted"* — and repairing one of those would delete the project's memory of why a symbol is
  gone. **The stale ones are the comments that make a LIVE claim in a dead name.**
- **A COMMENT IN A `.gd` FILE IS AN ASSERTED SURFACE, AND EB BROKE A SUITE PROVING IT.** The
  needle verifier and the literal-flip sweep both track needles into the four tracked DOCUMENTS.
  **Suites also assert literals against `.gd` SOURCE** — `test_batch_bl` control 1 pins the phrase
  `THIS BATCH DOES NOT SHIP ONE` inside `battle.gd` — and a comment-only edit changes a haystack
  neither instrument watches. EB reworded that sentence, **both document instruments stayed green,
  the comment-stripped diff read "comments only", and the battery took `bl` red.**
  · **THE SWEEP TO RUN IS THE SAME ONE WITH THE EDITED SOURCES AS THE DOCUMENTS**: every literal in
    the tree, at a floor of 4, tested for presence in each edited `.gd` file before and after.
    **A LOST literal is a candidate needle.** It takes seconds and it is the only instrument that
    can see this.
  · **AND "COMMENTS ONLY" STOPS BEING A SAFETY ARGUMENT.** The comment-stripped diff proves no CODE
    moved; it says nothing about whether a suite reads the comment. Both proofs are owed.
- **THE HAYSTACK CANNOT BE A GREP, AND THIS IS THE SHARP PART.** `check_dv` asserts
  `not rs.contains("func roll_ability_offer")` and `test_batch_an` §1 holds the bare literal
  `"roll_ability_offer"` in its `gone_fn` list — **so the two checks that prove the function is
  deleted are exactly what make a text sweep report it as resolving.** The universe has to be a
  SYMBOL TABLE of declarations, matched by equality, and the declarations have to be read with the
  string literals MASKED — an unmasked `func\s+(\w+)` scan declares the dead name back into
  existence out of the assertion that pins it absent.

## ARM A NEGATIVE CONTROL ON A NEEDLE A SUITE DEMONSTRABLY READS (STANDING, SET AT EB §3)
> **A control armed on unasserted prose reports the same green a working check does.** Arm it on
> something a suite demonstrably reads, and **confirm the disarmed state is RED before trusting the
> armed one.**

- **THIS IS A PRECONDITION ON THE NEGATIVE-CONTROL RULE, NOT A NEW RULE.** A control exists to prove
  an instrument BITES. One armed on a string nothing asserts proves only that nothing asserts it —
  and it says so in the same word a real pass does.
- **EA's FIRST CONTROL FAILED THIS WAY.** It wrapped a `CLAUDE.md` heading no suite reads, went
  green correctly, and was indistinguishable from a working check. The re-arm on one of EA §2's own
  re-pointed needles bit immediately, and `test_batch_bs` went 266 / 1.
- **THE ORDER IS: PICK THE NEEDLE OUT OF THE NEEDLE LIST, BREAK IT, SEE RED, RESTORE, SEE GREEN.**
  Picking the string first and hoping it is asserted is the step that fails. Restore **by `cp` from
  a scratchpad backup, never by `git checkout`** — that has cost this project a batch's uncommitted
  work once already.

## WRITE THE PREDICTED BASELINES BEFORE THE VERIFICATION RUN (STANDING, EARNED AT DF)
> **In a repair batch, write the predicted baselines BEFORE the verification run.** A baseline
> written afterwards records whatever happened; written first, it is a test. **The difference is
> whether the batch can fail.**

- **A BASELINE WRITTEN AFTER THE RUN CANNOT DISAGREE WITH IT.** Filling `baselines.json` in from
  the log is bookkeeping wearing the clothes of a check: every row matches, because every row was
  copied from the thing it claims to verify. **The file is only an instrument while the numbers in
  it were committed to in advance.**
- **PREDICT EVERY ROW YOU EXPECT TO MOVE, AND SAY WHICH DIRECTION AND BY HOW MUCH.** "The count
  falls" is not a prediction; "`as` falls by exactly two, `at` by three, `aw` by one, and nothing
  else moves" is. **A fall of the wrong SIZE is the same alarm as a fall nobody sanctioned** —
  it means something was deleted that the batch did not mean to delete.
- **THE TWO-SIDED FORM IS WHAT MAKES IT AN ACCEPTANCE TEST.** A smaller movement than predicted
  means a repair did not land. A LARGER one means something was repaired, deleted or broken by
  accident. **Both are reported rather than banked**, and neither is visible at all if the table
  was written from the run.
- **THIS EXTENDS THE RULE THAT A BASELINE MOVES ONLY IN THE BATCH THAT CAUSES THE MOVEMENT.** That
  rule says WHEN a row may move; this one says WHEN IT MAY BE WRITTEN. Together they are what stop
  the table drifting into whatever the code happens to do.

## WHAT A METER MEASURES IS NOT ALWAYS WHAT THE REPORT SAYS IT MEASURES (STANDING, FOUND AT CZ §2)
**`CY_METERS`' `conviction` row samples the DEVOUT'S OWN Faith, and his Faith HOLDS at the
threshold and never releases by rule (Batch BH §2).** It has never been able to say anything about
release frequency. Four batches quoted it as "the average fight ends without a release ever
firing"; the number that answers that was printed four lines below it the whole time —
`releases/battle` in the Faith decomposition, reading **0.51 to 1.49** on unmodified HEAD.
- **THE INSTRUMENT WAS NOT WRONG. THE SENTENCE ATTACHED TO IT WAS**, and the repair differs: a
  wrong instrument gets rebuilt, a wrong sentence gets rewritten. **Rebuilding an instrument
  mid-comparison throws away every figure you wanted to compare against**, so the row keeps its
  meaning and the caveat is written beside it in the code.
- **THE GENERAL TRAP: when a measurement and its interpretation agree about the VERDICT, nothing
  forces anyone to check whether they agree about the SUBJECT.** Every consequence drawn from the
  mis-reading happened to be sound, so it survived until a batch tried to fix the number rather
  than the mechanism.

## A STALE ASSERTION IS REPAIRED TO INTENT, NEVER DELETED (STANDING — CQ §3's RULE, RE-PAID AT DC)
> **Repair an assertion to the value the ruling establishes as INTENDED, never to whatever the
> code happens to do. Repoint it; do not remove it. And publish the check count either side,
> because the count is the proof.**

- **REPAIRING TO THE CODE IS HOW AN ACCIDENT GETS BLESSED AND THE EVIDENCE DISAPPEARS.** CQ §3's
  case is the one to remember: `test_batch_ce` asserted "a perfect hands over 3 stacks" and
  rewriting that to 3 would have made a bug permanent. **Where the intended value and the code
  agree, repair to the intended value anyway — the habit is the point.**
- **A SUITE THAT STOPS ASSERTING IS THE FAILURE BEING FIXED, NOT A WAY OF FIXING IT.** Deleting a
  check to reach green destroys exactly the thing that would have caught the next regression.
- **THE ONE EXCEPTION, AND IT IS NARROW (STANDING, SET AT DG §2): A CHECK ASKING ABOUT A DELETED
  FEATURE IS NOT A LIVE QUESTION.** This rule exists to stop a live question being silenced. A
  check whose SUBJECT no longer exists anywhere — not in the code, not in the documents, not in
  the archive — **cannot pass, cannot fail meaningfully, and cannot be repointed at anything**,
  and keeping it red is not evidence: it is noise that hides the next real red. DG deleted six
  assertions pinning `CLAUDE.md`'s **exclusive-pair list**, whose strings CW's split removed and
  whose rule Batch AI had already retired to a bare `pass`.
  - **THE EXCEPTION IS PAID FOR WITH A PREDICTION, NOT WITH A JUDGEMENT.** State the exact
    post-deletion count in `baselines.json` BEFORE the run. **A fall of the wrong SIZE is the same
    alarm as an unsanctioned one** — it means something else went with it — and that prediction is
    the only thing standing between this exception and the failure the rule exists to prevent.
  - **RECORD IT AT THE DELETION SITE**, in a comment where the assertions stood, naming what they
    asked and why the subject is gone. A reader who finds a gap learns nothing.
  - **IF THE SUBJECT EXISTS ANYWHERE AT ALL, THIS IS NOT THE EXCEPTION — REPOINT INSTEAD.** The
    test is whether a true answer is available to the check, not whether one is convenient.
- **THE CHECK COUNT EITHER SIDE IS THE AUDIT, AND IT IS CHEAP.** A repaired assertion leaves the
  count UNCHANGED. **If a suite's count moves across a repair pass, an assertion was removed
  rather than repointed** — report the count before and after, per suite. DC's five moved by zero
  (34 / 78 / 47 / 233 / 91) while 23 failures went to none.
- **KEEP THE SHAPE WHEN YOU LOWER THE RUNG.** `bi` §1 ratchets a peak over four gains; under the
  new threshold the fourth cannot lift it. **Shortening the loop would have passed and stopped
  asking the question** — it asserts `mini(i + 1, RELEASE)` and still runs four times.
- **AND A MOVED THRESHOLD CAN INVALIDATE HOW AN ASSERTION LOOKS, NOT ONLY WHAT IT PINS.** DC's one
  failed repair: `be`'s Communion rate was repointed from three stacks to two and still read
  **0.0%** — because at one stack below the threshold an advance RELEASES and resets the count, so
  **the stack-count detector reads every fire as a miss.** The release counter is the only honest
  witness there. **`test_batch_bf` had written that rule at the function that needed it and `be`
  was repaired without reading it.** When you move a driven depth, ask what the drive now DOES.
- **A CONSTANT'S BLAST RADIUS IS EVERY ASSERTION THAT PINS A CONSEQUENCE OF IT, NOT ONLY THE ONES
  THAT NAME IT (STANDING, SET AT DF §1).** DC swept `FAITH_RELEASE` 5 → 3 and repaired 23
  assertions across `be`, `bf`, `bg`, `bh` and `bi` — **and left eight more standing in `bu` and
  `ce` for three batches.** The eight do not contain the words `FAITH_RELEASE` or the number 5 in
  any greppable place: they read `w.faith_peak == 5`, `m.faith_stacks == 4`, `1 +
  ELEVATION_STACKS_TEST`. **They are arithmetic ABOUT the threshold, so a search for the threshold
  cannot find them.** Sweep by driving the constant, not by grepping its name: change it, run
  everything, and let the failures enumerate the radius.
- **AND WHEN A THRESHOLD FALLS, A PROBE THAT PARKED BELOW IT MAY NOW CROSS IT — WHICH CAN MAKE THE
  CHECK STRONGER (DF §2).** `ce`'s Elevation probe drove three allies at 0, 1 and 2 to prove the
  card ADDS a count rather than writing a floor. At `RELEASE` = 3 two of the three now release
  instead of coming to rest — and **the release is a better discriminator than the old one**,
  because a floor-write of 2 would leave all three at 2 and nobody would release at all. **Ask what
  the new threshold makes VISIBLE before assuming it has taken something away.**

## A HELPER COPIED BETWEEN GATES INHERITS ITS BUGS AND DIVERGES SILENTLY (STANDING, SET AT DA §3, THE GATES CONSOLIDATED AT DB §1)
> **Enumerate the ability corpus through `Classes.ability_corpus()`. Never copy another gate's
> walk.** A talent can grant an ability that lives in no pool, and a hand-rolled walk misses it.
> **A helper copied between gates inherits its bugs silently and diverges from its origin without
> anything reporting it.**

**THIS IS A DIFFERENT FAILURE FROM EVERY OTHER TRAP IN THIS FILE.** The rest are DRIFT: one
authority, edited, and a second copy left behind. This is **PROPAGATION BY COPY** — gates wrong in
N places from birth, because they copied a walk rather than deriving one. **Fixing the origin
leaves the rest.** Drift gives you one stale copy and a chance a diff notices; a copied helper
gives you N, all born wrong, none of them diffed against anything.

- **THE TELL IS A HELPER WITH THE SAME NAME IN THREE OR MORE GATES.** Ask whether the answer
  belongs to the GAME's data rather than to the test.
- **`check_cz`'s `_cl_only_corpus` IS THE ONE ALLOWED COPY**, because being a copy is its job — it
  is the negative control. **`check_da` names it as the exemption**, so a later reader cannot
  "consolidate" it into uselessness.
- **`_spawn` IS AUTHORED ONCE FOR THE GATES (`gate_fixture.gd`) AND ONCE FOR THE SUITES
  (`suite_fixture.gd`), AND `_kill` WITH IT.** Each suite keeps its OWN `_spawn` SIGNATURE and
  delegates — **thirty-seven signatures are not one signature** — so no call site moved.
  **`check_da` §3 no longer COUNTS the copies, it ASSERTS there are none**: a gate or suite that
  authors its own `_spawn`, or instantiates the battle scene by hand, fails it by name, and the
  hand-built boards that remain are a **named ratchet** rather than a wildcard.
- **THE DIFFERENCES THAT ARE REAL BECOME NAMED ARGUMENTS**, not invisible edits inside a copy:
  `deterministic`, `items`, `run`.
- **A BASE CLASS IS THE RIGHT SHAPE AND IT DOES NOT COMPILE.** `extends GateBase` on a `--script`
  SceneTree target fails with `Could not find base class` **and exits 0 having run nothing**. The
  fixture is a `preload`ed `RefCounted` for that reason, and carries **no `class_name`** — that
  registration lives in the gitignored `.godot` cache, so it would resolve here and fail on a
  fresh clone.
- **A FINGERPRINT IS ONLY AS WIDE AS THE POPULATION IT SWEEPS AND THE CONVENTION IT MATCHES.**
  Three hand-rolled walks stood in the tree for seventeen quiet readings: the sweep read
  `check_*.gd` only, the fingerprint matched the pool ACCESSORS where a walk read the CONSTANTS,
  and — the largest — it assumed a corpus walk touches the draft pools at all, so a walk reaching
  43 of 227 sat inside the swept population unseen. **THE WAY TO FIND THE NEXT HOLE IS TO ASK WHAT
  THE RULE IS ABOUT AND RE-DERIVE THE FINGERPRINT FROM THAT**, not to patch the holes you were
  told about.
- **THE WIDENED RULE ASKS WHAT A WALK IS RATHER THAN WHICH CALLS IT MAKES.** *A function that
  RETURNS a collection built out of two or more of the game's ability-source families is answering
  "what abilities exist?"* **THE RETURN IS THE DISCRIMINATOR** — a body that reads a pool and
  ASSERTS on it returns void and is not a walk.
- **A COUNT OF EXEMPTIONS MEASURES A FINGERPRINT'S SHARPNESS.** If widening a rule means exempting
  most of what it catches, the fingerprint is wrong and the exemptions are hiding it. **An
  exemption granted to a genuine violation is worse than the violation it covers**, and an
  exemption is keyed `file::func`, **never by file** — a file-scoped one blinds the rule to a new
  walk arriving in that file later. **COMMENTS ARE STRIPPED BEFORE THE MATCH**: prose describing a
  walk is not a walk.
- **AND THE REPAIR IS AN ADDED INSTRUMENT, NOT A LOOSENED ONE.** Loosening a rule to cover a new
  case re-argues every case it already settled; adding a second question beside it does not, and
  the two can disagree usefully. **ASSERT THE EXEMPTION TABLE'S SIZE FROM OUTSIDE**, so a batch
  adding one has to move a line in another file and say why.
- **A GATE THAT COUNTS A POPULATION IS ONLY AS GOOD AS ITS ENUMERATION, AND A GREEN EQUALITY OVER
  A SHORT WALK READS EXACTLY LIKE A GREEN EQUALITY.** **A named population is only useful while it
  is still the real one**, so a gate re-derives it live and requires the suite's table to equal it.
- **A FINGERPRINT WITH A HOLE DOES NOT FAIL LOUDLY AND DOES NOT FAIL SLOWLY — IT PASSES.**
## THE INSTRUMENTS AND THE HOLES THEY CANNOT SEE (this file's own heading, EF §2)

### A FINGERPRINT INSPECTS A POPULATION AND A CONVENTION, AND EACH IS A PLACE TO HIDE (Batch DW §1)
**THE RULE: a rule enforced by matching source text is only as wide as the population it sweeps and
the calling convention it matches, and a violation that avoids either one is invisible to it — so
when a fingerprint is written, WRITE DOWN WHAT IT CANNOT SEE.** `check_da` §3 was authored to catch
exactly what `test_batch_cp` does, the two existed side by side for their whole lives, and it never
saw it.

- **THE HOLES ARE NOT SYMMETRIC AND THE COUNT OF THEM IS NOT KNOWABLE FROM INSIDE.** DV read the
  gate and named two; there were three, and the third was the largest — `check_cl_resolver` sat in
  the swept population the whole time, reading 43 of 227, because the fingerprint took *"a corpus
  walk reads the draft pools"* as a premise rather than as an assumption. **The way to find the
  third hole is to ask what the rule IS about and re-derive the fingerprint from that**, not to
  patch the two you were told about.
- **AND THE REPAIR IS AN ADDED INSTRUMENT, NOT A LOOSENED ONE.** The old sweep and both its
  exemptions are untouched at DW. Loosening a rule to cover a new case re-argues every case it
  already settled; adding a second question beside it does not, and the two can disagree usefully.
- **A COUNT OF EXEMPTIONS IS A MEASURE OF A FINGERPRINT'S SHARPNESS.** If widening a rule means
  exempting most of what it catches, the fingerprint is wrong and the exemptions are hiding it.
  **Sharpen the question until the catches are real** — DW's went from sixteen catches needing
  sixteen exemptions to three catches and one.
- **AND ASSERT THE EXEMPTION TABLE'S SIZE FROM OUTSIDE.** `check_dw` §0 pins `check_da`'s at ONE, so
  a batch that adds a second has to move a line in another file and say why.

## THE TRAPS — THE INSTRUMENT HALF (this file's own heading, EF §2)

**Every one of these cost a batch something.** The three traps that are about the GAME —
the documented exception, the names that look wrong and are right, and the shell/engine
gotchas — stayed in `CLAUDE.md` under the same section title.

### GATES THAT PASS WITHOUT ASKING THEIR QUESTION
- **A GATE REPORTS ITS CHECK COUNT, NOT A VERDICT** — `GATE 2 PASS (165 checks)`, never a bare
  `GATE 2 PASS`. **A GATE THAT RUNS ZERO CHECKS MUST FAIL.** An empty gate is a broken gate, and
  it is the one case where silence has to be loud. Both rules live in `_check` / `_check_range` /
  `_go`, so a gate added later inherits them by doing nothing. **This existed because a deleted
  call aborted a gate outright: zero checks ran, zero failed, and it printed `GATE 2 PASS` on the
  way out — 129 assertions had never executed once, and twelve batches of VERIFIED blocks quoted
  it.** A count of zero failures is not evidence when the count of checks is also zero.
- **A COUNT THAT NOBODY DIFFS IS A WORD.** Printing a number is not enough: two suites printed
  counts that were wrong by 125 and 2,434 checks and nobody saw it for twelve batches. **A count
  is only visible at a glance if something is comparing it to what it should be.**
  `test_batch_cd` §1 is what diffs them.
- **AND AN INSTRUMENT'S SCOPE IS PART OF ITS READING (STANDING, SET AT DD §1).** `cd`'s table held
  **five suites out of forty-five** from CD until DD — **a ninth of the project** — and the cost was
  measured rather than argued: **repairing five suites at DC did not move `cd` by one line, because
  none of the five was in the table.** A green differ over a ninth of the tree reads exactly like a
  green differ over the tree. **When a rule says "nothing moved", ask what it was watching.**
  - **IT IS `[checks_lo, checks_hi, fails_lo, fails_hi]` PER SUITE NOW, NOT A FLOOR.** A floor
    cannot see a count that RISES, and `bx` gained five checks at CX and `al` lost one at CV —
    both found batches later, by accident, by somebody verifying something else.
  - **THE FAILURE HALF IS THE HALF A FLOOR NEVER HAD.** **A failure count moving inside an
    already-red suite is invisible in an aggregate**, and that is exactly how `test_batch_bi` stayed
    wrong for four batches while its suite was red for an unrelated reason.
  - **BANDS, WITH THE OBSERVATION COUNT BESIDE THEM.** `an` **6047–6063** (ten observations), `bk`
    129–130 (five), `bo` 0–1 failures. **A band written from too few readings reads a normal run as
    a regression** — the same failure as a wrong count, in the opposite direction.
  - **AND A BAND WRITTEN TO A SAMPLE'S EXACT EXTREMES IS ONE OF THOSE. DD MEASURED IT.** `an`'s
    band was written from nine observations as 6047–6054 and **was exceeded on its tenth reading,
    inside the same batch** (6055, at zero failures). A sample's extremes are exceeded by roughly
    two runs in eleven. **THE RULE, APPLIED WHEN A BAND IS EXCEEDED AND NOT BEFORE: floor = the
    lowest observation; ceiling = the highest PLUS the observed spread.** It is asymmetric because
    **the floor is the half that catches a real fault** — a section that stopped running costs
    hundreds of checks, not five — so the floor stays tight and the ceiling takes the headroom.
    **Headroom goes where a reading demands it**, so every number in the table is traceable to a
    run: `bk` has not been exceeded and was not widened.
  - **AND IT COSTS 22 MINUTES: IT RUNS THE BATTERY INSIDE THE BATTERY.** `run_battery.sh` carries
    `TMO[test_batch_cd]=2400` for that, because **at the 240s default the sweep is killed before it
    prints a row, and a killed suite reports NO COUNT.**
- **VERIFY A PARSE BY GREPPING STDERR, NEVER BY A TALLY.** `grep -cE "Parse Error|SCRIPT ERROR"`
  over the run's own stream is the authority. **Godot returns a NON-NULL GDScript for a file whose
  parse failed** — it prints the error and hands back the resource anyway — so `load(path) != null`
  reported "0 failures" on a tree with a real Parse Error in it. `check_parse.gd` asks
  `can_instantiate()` now, which is false exactly when the parse is broken; **grep the stream
  anyway. A gate that can only pass is a gap.**
- **AND THE EXIT CODE IS NOT A SIGNAL EITHER — IT IS THE SAME DEFECT ONE LAYER OUT.** `load()`
  handing back a broken script and the process handing back `0` are one fault wearing two faces:
  **the tool reports success for work it did not do.** `check_da`'s first run printed a
  clean-looking report and **exited 0 with two `Parse Error` lines on stderr**; only the stderr
  grep caught it. **Batch DB reproduced it deliberately and it is trivial to hit** — a `--script`
  target whose BASE CLASS does not resolve prints
  `Parse Error: Could not find base class`, runs **not one line** of the gate, and **exits 0**:
  ```
  Godot --headless --path . --script probe_gate.gd ; echo $?
  SCRIPT ERROR: Parse Error: Could not find base class "ProbeBase".
  0
  ```
  **A gate that never ran cannot fail, and a runner that trusts `$?` will call that a pass.**
  `run_battery.sh` is right to print `throws=` beside every count and that column is not
  decoration — **`throws=` is the only thing standing between this fault and a green report.**
- **A CHECK THAT PASSES FOR A REASON IT IS NOT TESTING IS THE SAME GAP, AND ONLY A NEGATIVE
  CONTROL FINDS IT.** Deleting an ability's no-chain refusal did not trip the check written to
  catch it — the cast had just started a 5-turn cooldown, so the refusal came from the COOLDOWN
  and the assertion stayed green. **A check only discriminates once the thing under test is the
  ONLY thing that can produce the answer** (`sv.cooldowns.clear()` immediately before it).

### THE master.html STAMP GATE
- **THE STAMP CHECK IS DUPLICATED ACROSS FOURTEEN SUITES AND IS NO LONGER A LITERAL** (ah, bb,
  bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, ce). Each finds `Last updated:`, reads the two-letter
  code out of `(Batch XX)` and asserts it is **no older than that suite's own batch code**, so a
  re-stamp never owes a bump again.
- **DO NOT AUTHOR ANOTHER LITERAL-STAMP CHECK.** The literal version had to be hand-bumped every
  batch to keep passing, and one re-stamp turned five of them red at once, where they sat until
  another batch found them while verifying something else. **This is the "check that can only
  pass" fault in its other direction: a check that can only pass for a SINGLE BATCH.**
- **THE COMPARISON LEANS ON TWO-LETTER CODES SORTING LEXICALLY.** A three-letter batch code needs
  one more line in each of the fourteen, and `substr(_code_at + 7, 2)` will read it wrong until
  it gets one.
- **GREP FOR THE GATE RATHER THAN TRUSTING A COUNT IN A DOCUMENT, THIS ONE INCLUDED** —
  `grep -ln "Last updated" test_batch_*.gd`. Published counts of it have been wrong in both
  directions more than once, and a grep for batch codes in COMMENTS will over-report it.

### SUITES AND THE HARNESS
- **A SUITE MUST NOT PIN THE SAVE VERSION LITERAL** — it turns a save bump into a suite failure
  that reads like a regression.
- **NEVER `preload` A SCRIPT THAT NAMES AN AUTOLOAD.** It resolves at parse time, before the
  autoload exists, and it cost a gate. **Autoloads (`Run`) do not resolve in a `--script`
  SceneTree at all** — a test that needs one must be a SCENE run.
- **RUNNING THE FULL BATTERY DESTROYS THE PLAYER'S IN-PROGRESS RUN.** Many suites spawn a live
  battle, which means `Run.new_run` and `clear_save`, and `user://run_save.bin` is simply gone
  afterwards. Individual suites that back it up buy nothing, because a LATER suite wipes it again.
  **Copy `run_save.bin` aside before a battery run if the designer has a run going, and say so
  afterwards either way.** The META layer (`profile.json`, `relics.json`) is safe.
- **"IS THERE ANYBODY THERE TO PRESS?" IS ONE QUESTION, ASKED IN ONE PLACE** —
  `battle._nobody_can_press()` is `sim or autoplay or DisplayServer.get_name() == "headless"`.
  **`sim or autoplay` names the two BOTS, not the absence of a player**: a hand-driven suite is
  neither, because it sets `Run.active` and clears `sim`/`autoplay`/`sim_run` precisely to get the
  real battle path. Four suites hung for five batches awaiting a signal only a key press emits.
  **A PROFILE FLAG IS NOT A BOT GUARD** — setting one by hand is one file knowing about the trap.
  Any future headless modal will hit this.
- **`test_batch_bl.gd` NEEDS `--fixed-fps 12`, AND IT IS NOT THE `sim.sh` FLAG** (which passes
  240, for wall-clock speed). 12 makes each frame a big TIME step, because a real-play battle
  paces itself with `create_timer` waits. **Any future suite that must run a REAL-PLAY battle to
  completion wants the same trick.**
- **A SUITE THAT ARMS A FLAG ON EVERYONE FOR DETERMINISM CAN NEVER SEE THE BRANCH THAT FLAG
  SUPPRESSES.** Determinism bought at the cost of the code path under test is not determinism.

## Verify before shipping
- **STANDING CONVENTION, SET AT BATCH CG AND BINDING ON EVERY CONTENT BATCH FROM IT: A CONTENT
  BATCH DOES NOT SHIP A TEST SUITE.** No new suite, no negative controls, no smoke sweeps, no
  measurement. **THE FLOOR IS: IT PARSES, IT RUNS, AND A LIVE BATTLE THROWS NOTHING** — that is
  the whole verification ask. **TESTING MOVES TO PERIODIC DEDICATED TEST BATCHES INSTEAD.**
  · **WHAT THIS DOES NOT LICENSE: LEAVING AN EXISTING SUITE ASSERTING SOMETHING THE BATCH JUST
    MADE FALSE.** A check whose subject was renamed or deleted has stopped asking its question,
    which is the exact fault CA, CD and CE spent three batches closing — so a content batch still
    RE-POINTS IN PLACE, with the reason in the file, and INVERTS rather than deletes where the
    correct answer moved. CG re-pointed three suites (ce, bi, av) under this rule while writing
    none.
  · Every "VERIFIED" block written before BATCH CE followed the old convention (a new suite, a
    battery pass and a wall of negative controls per batch). Those blocks live in
    `docs/changelog.html` and its archive. **They are the record of what each batch did, not a
    standard a content batch is now held to.**
- Parse: run each scene headless with `--quit-after 90`, grep "SCRIPT ERROR".
  **THIRTEEN scenes in `scenes/`**, plus the two gate scenes at the repo root.
  `check_parse.gd` force-loads all of them in one pass and is the faster gate —
  **and since EI it force-loads the gates, the suites, both fixtures and the
  data JSON too, off a population derived from `run_battery.sh`.** The rule
  that binds it is in `CLAUDE.md`; this line is the pointer, not a second copy.
- **`check_cm.gd` (Batch CM) is the GATED-ABILITY invariant gate**, and it is the enforcement
  behind the no-gated-healing rule in `CLAUDE.md`: it walks the whole 211-ability corpus and fails
  if the gated set is not the five §1 names, if any gated ability heals or revives, if the draft
  card's tell disagrees with the flag, or if the tell breaks the standard's 44-character ceiling. **Run it
  in any batch that touches `Ability.gated` or adds an ability.**
- **`check_cm_live.gd` (Batch CM) is the only thing that PRESSES THE DEFENSIVE BAR.** Every
  headless battle takes `_defensive_brace`'s bot branch, so `_run_skill_check`'s defensive path
  is exercised nowhere else. It spawns a real non-autoplay battle, drives an enemy attack into a
  Warden, presses the bar by hand, and measures ×0.85 / ×0.75 plus "Sloppy equals Good".
  · **`block_chance = 0.0` DOES NOT TURN A WARDEN'S BLOCK OFF, and it cost this gate a false
    failure.** `_live_block_chance` adds `_plating_slice` (0.15 + Heavy Plating's climb) ON TOP
    of the field. The sum is clamped to [0,1], so **a large NEGATIVE field is what actually
    disables it** — and because a block throws the climb away, samples must be INTERLEAVED, not
    run in two consecutive blocks. **Any future Warden measurement wants both.**
- **`check_map.gd` (Batch BK) is the MAP GENERATION instrument**: N generated
  zones → node count, column widths, out-degree, foreclosure depth, the entry
  guarantee, reach contiguity, and the walked distribution under an unsteered
  route plus the three policies. ~0.2s a zone (26 warbands pre-rolled for
  hover-scouting), so 1500 zones is ~5 minutes.
- **`check_map_screen.tscn` (Batch BK) is the only thing that EXECUTES the
  lattice draw.** The scene-parse gate loads map.tscn with no active run, so
  it bounces to the main menu and never draws a node. This builds the screen
  against a real in-flight run at three positions and opens both overlays.
  It is a SCENE run, not `--script`: **autoloads (`Run`) do not resolve in a
  `--script` SceneTree.**
- **`test_batch_bl.gd` NEEDS `--fixed-fps 12`, AND IT IS NOT THE `sim.sh` FLAG** (which passes
  240, for wall-clock speed). 12 makes each frame a big TIME step, because a real-play battle
  paces itself with `create_timer` waits. **Any future suite that must run a REAL-PLAY battle to
  completion wants the same trick.**
- **RUNNING THE FULL BATTERY DESTROYS THE PLAYER'S IN-PROGRESS RUN.** Many suites spawn a live
  battle, so `user://run_save.bin` is gone afterwards and per-suite backups buy nothing (a later
  suite wipes it again). **Copy it aside before a battery run if the designer has a run going**,
  and say so afterwards either way. The META layer (`profile.json`, `relics.json`) is safe.
- **THE SIM IS `./sim.sh`.** `N` = N battles of the fixed raider/chief/archer/archer lineup (kit
  smoke only — **its win% carries NO difficulty signal**); `--sweep N` = N battles at each budget
  3/6/9/12; `--run N` = N complete runs with progression both sides, ending in the run report and
  a per-invocation `Matrix row:` line. **Assemble Matrix rows across runs; never re-run one row
  against another batch's flags.** Every flag is listed once, in the DEBUG SURFACES table in
  `CLAUDE.md` — **that table is the reference; do not restate it here or there.**
  · **TUNE AGAINST THE CURVE, NEVER ONE POINT.** The ~85% win-rate target describes TOP-BAND
    (budget 10-12) encounters only, and attrition (deaths/battle) is the sensitive dial.
  · **ALWAYS PRINT THE BUILD STRING BESIDE A RUN NUMBER.** `DOD_SIM_BUILDS` defaults to each
    tree's FIRST lane, so a default-vs-named comparison is a two-hero difference, not a
    four-hero one — a confound with a known sign.
  · **NO SIM FIGURE MAY BE QUOTED ABOUT A CARD IN A NON-DEFAULT LANE, AND SEVERAL HAVE BEEN.**
    `Talents.LANES` is 3 across twelve specs, so two thirds of the lanes have never appeared in
    any measurement taken here. That is not a bug — a fixed default party is what makes arms
    comparable — it is a permanent caveat, and the sim prints the unmeasured count beside
    `builds=` so it arrives with the number.
  · **A ROW IS ONLY COMPARABLE WITH ROWS TAKEN UNDER THE SAME STRUCTURE.** No pre-BK row is
    comparable with a post-BK one (`map=branch`, 48 slots, three real route policies rather
    than three samples of one), and **`DOD_SIM_DIFFICULTY` DEFAULTS TO RUNG 1 — an unset flag is
    NOT the old baseline.** Set `warden` explicitly for a baseline row.
  · **A LANE ROW IS ONE FULLY-BUILT HERO MEASURED AGAINST THREE UNBUILT ONES.** Those rows are
    honest A/B comparisons of a spec's lanes against each other; they are NOT "how much of a
    real party's work this hero does". **A CONTRIBUTION SHARE INFLATES TWICE** — unbuilt allies
    shrink the denominator and, for a support, feed the numerator. The lane RANKING barely
    moves, so a re-measure is owed only where a row was read as an absolute.
  · **`d+h+p%` IS NOT A SHARE OF THE PARTY'S WORK, AND BREAK IS NOT IN IT.** Break has its own
    columns (`BD%`, `BDprev/b`) and **must not be folded in** — that needs an exchange rate
    between a Break point and a hit point that nobody can defend, and inventing it buries a
    guess inside every later measurement. **A BUILD THAT PAYS IN BREAK READS LOW IN `d+h+p%` BY
    CONSTRUCTION** — read it in `BD%` and never call such a build weak off `d+h+p%` alone.
  · **BREAK PREVENTED HAS ONE DOOR, `_prev_bd`** (per-hero total and named term written by the
    same call, so parts can never disagree with the total). **Break HEALING is a different
    question from Break refused** — Rallying Shout and Battered Not Broken remove BANKED Break
    and are deliberately not booked; a batch that wants them wants a new column.
  · **RunSim CALLS `Profile` NOWHERE** — a sim that read the player's ledger would make every
    baseline depend on whoever ran it. `Run.sim_run = true` makes `save_run`/`clear_save`
    no-ops, so a sim can never touch the real save.
- **QUOTE THE RUN HARNESS AS "GATES 1/2/3", AND QUOTE THE COUNTS BESIDE THE VERDICT.** Its two
  standing rules live in `_check` / `_check_range` / `_go`, so a gate added later inherits both
  by doing nothing: **(1) A GATE REPORTS ITS CHECK COUNT, NOT A VERDICT** — `GATE 2 PASS (165
  checks)`, never a bare `GATE 2 PASS` — and **(2) A GATE THAT RUNS ZERO CHECKS MUST FAIL.**
  **A COUNT OF ZERO FAILURES IS NOT EVIDENCE WHEN THE COUNT OF CHECKS IS ALSO ZERO**, and a
  gate that printed a WORD outlived two that printed wrong numbers. **THE LIVE COUNTS ARE IN
  `baselines.json`; treat a moved count as something to explain rather than a nuisance.**
- **A COUNT THAT NOBODY DIFFS IS A WORD.** Printing a number is not enough — two suites printed
  counts wrong by 125 and 2,434 checks and nobody saw it for twelve batches. **A count is only
  visible at a glance if something is comparing it to what it should be**, which is what
  `check_de` is for.
## STANDING RULE — A NUMBER QUOTED FROM ONE DOCUMENT INTO ANOTHER STOPS BEING A MEASUREMENT (Batch DJ §3)
> **Re-derive a figure at the point of use, or cite where it was measured and when.**

DI's `src` coverage figure — **53 of 204** — was a single-line grep that could not see the 25 calls
that wrap across lines; **twelve of those already passed a source, so the true figure was 63.** It
had been quoted into `docs/state.md`, into DH's own source comment and into DI's brief without ever
being re-taken.
· **AND THE COPY IN THE SOURCE COMMENT SURVIVED THE BATCH THAT CORRECTED THE OTHERS.** DI moved the
  figure in `docs/state.md` and left `battle.gd`'s Harvest comment reading 53, one line above a
  `244 call sites` that had been 204 since before DH. **A batch that corrects a number owes a sweep
  for its other copies**, and the copy in the code is the one nobody greps.
· **THE FIX IS NOT A BETTER NUMBER, IT IS FEWER COPIES.** DJ deleted both figures from that comment
  and pointed it at `check_di` §1, which walks the file and prints the live count on every battery
  run. **A number with an instrument behind it cannot rot; a number in prose always can.**
· **IT IS THE SAME DEFECT AS THE SECOND COPY RULE** (`docs/state.md` and `CLAUDE.md` point at
  `baselines.json` rather than restating it) — this is that rule applied to measurements taken
  inside a batch rather than to the baseline table.

