# BATCH ED — THE UNREAD THIRD WAS NOT UNREAD, AND THE PINS GET A MANIFEST

**A prune that retired nothing, and the coverage EC reported and ruled on nowhere.**

All 43 never-cited blocks of `CLAUDE.md` were read in full and **every one is live** — zero
retirements, and two stale *names* repaired instead. The source-pin manifest is built, derived by a
committed generator and enforced by a new gate every battery. **No game behaviour changed, no
ability moved, no card was authored.**

---

## THE BRIEF'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

The brief said *"derive, do not recall"*, and three of its figures moved when derived.

| the brief said | at HEAD | why |
|---|---|---|
| **42 blocks, 74,398 B, 32.0%** never asserted nor quoted | **43 blocks, 77,591 B, 33.3%** | EC's own `state.md` rewrite dropped the only sentence that had ever quoted one block |
| **915** assertions pin a literal into `.gd` source | **1014** | EC's census captured a fixed window after each locator and stepped over the second member of every conjunction |
| **37** of those resolve only inside a comment; **12** are the AXIS/SYNERGY convention | **39**, and **13** | the same window bug |
| `classes.gd` 22 / `battle.gd` 12 comment-resident | 22 / **14** | the same window bug |
| the changelog's **917** | superseded | EC shipped the pre-repair figure in the changelog and the post-repair one in the report |

**`classes.gd` at 22, `run_sim.gd` at 2 and `run_state.gd` at 1 re-derived exactly**, and so did the
brief's claim that the AXIS/SYNERGY convention is pinned by **six** suites. The 4.7× ratio the brief
quotes is the one figure that got *better* for its own argument: it is **4.4×** on the corrected
population, because the document side grew too.

---

## §1 — THE 43 NEVER-CITED BLOCKS, AND WHY NONE WAS RETIRED

### THE MEASUREMENT WAS SOUND AND THE INFERENCE WAS NOT

EC's number is right: **33.3% of `CLAUDE.md` — 43 of 94 rule-blocks — is neither asserted by any
suite or gate nor quoted verbatim anywhere else in the repo since its own batch wrote it.**
Re-derived at HEAD with EC's own instrument.

| | blocks | chars | share |
|---|---|---|---|
| asserted by a suite or gate | 24 | 60,978 | 26.2% |
| quoted elsewhere, never asserted | 27 | 94,254 | 40.5% |
| **neither asserted nor quoted** | **43** | **77,591** | **33.3%** |

**But "never cited" is a fact about citation, not about load**, and for a rule that works by being
obeyed the two come apart completely — nobody quotes the rule they are following, so a well-obeyed
rule and a dead one produce identical evidence under a citation count.

### THE VERDICT, AGAINST THE BRIEF'S THREE CATEGORIES

| category | count |
|---|---|
| a rule nothing enforces and nothing needs — **retire** | **0** |
| a rule nothing enforces that **still binds future work** — keep | **43** |
| a narrative that survived DZ's prune — retire | **0** |

**Zero retirements.** Every one of the 43 is a live standing rule or a live reference: the report
convention, the archive schedule, the duration convention, the `preload`/autoload trap, the clamped
call sites, the boss hard-control gate, the row-8 criterion, the leave-one-out rule, the debug
surface table, the computed block, the names-that-look-wrong list, the shell and engine gotchas.
Four name themselves as reference rather than rule, and one of those says *"Not for deletion."*
outright.

### THE CLAIM WAS TESTED, NOT JUDGED — TWICE

Reading 43 blocks and forming an opinion about each is exactly the *"a named list cannot audit
itself"* trap. So both halves were made mechanical.

**FIRST: IS THE "ASSERTED" HALF COMPLETE?** If a suite reads `CLAUDE.md` in some shape the needle
extractor cannot see, a block called never-asserted could be load-bearing invisibly. Every condition
on a `CLAUDE.md` holder across the 25 reader files was classified independently: **50 `contains`, 4
`find`, 3 `substr`, 1 `to_lower`.** An independent extraction of every literal tested against the
file found 57 distinct needles against the extractor's 61 — and, the question that matters,
**0 of them land in a block the census called never-asserted.** The three `find`-then-`substr` sites
are the documented vacuous trio in `as`/`at`/`aw` plus `test_batch_cd`, which is guarded three ways.

**SECOND: DOES EACH BLOCK'S SUBJECT STILL EXIST?** A block whose subject is gone is dead; a block
whose subject is live binds work. Every backticked identifier in the 43 was resolved against a
**declaration table with string literals masked and comments stripped** — because, as `CLAUDE.md`'s
own EB §2 block says, the two checks that prove `roll_ability_offer` DELETED are exactly what make a
text grep report it alive.

**THE FIRST BUILD OF THAT SWEEP WAS WRONG AND ITS CONTROL CAUGHT IT.** Treating `'` as a string
delimiter let an apostrophe in one comment (*"the hero's"*) open a string that ran to the next
apostrophe anywhere later in the file, swallowing every declaration between them: the table read
4,348 symbols and reported `_apply_status`, `vault_ability` and `takes_delay_cap` as deleted. With a
proper tokenizer it reads **6,786** — the bug was eating more than a third of the tree. Both control
arms then behaved: 25 symbols verified live by grep all resolved, and the three the tree asserts
*absent* (`roll_ability_offer`, `CLASS_POOLS`, `_overburn_drain`) all read dead.

**Nine of the 43 name a symbol that does not resolve. Seven are correct as written** — they are
records of deletions, which EB's rule says must not be swept, or they name engine surfaces
(`ScrollContainer`, `_init`, `process_frame`) and file basenames. **Two are real.**

### THE TWO STALE NAMES, BOTH REPAIRED

1. **`wild_communion_ranks` has not existed since Batch AY.** The names-that-look-wrong block named
   it as the Beastmaster's live field. The live field is **`wild_communion_step`**, and
   `test_batch_ay.gd:348` pins `0.015 * pm.wild_communion_ranks` **absent** from `battle.gd` — so the
   guide named the dead one while a suite asserted it dead, and `talents.gd:2143` states the same
   trap correctly one file away. The *rule* is true and still binds — `communion_ranks` is the
   Devout's and the two share no counter — and `test_batch_ay` §6 does walk both trees in both
   directions, as the block claims. **Corrected the name, and recorded that the ranked form is
   retired**, which is EB's repair rule exactly: correct where the thing moved, delete only where it
   is gone.

2. **The debug-surface table claimed four retired sim flags are "still printed as retired in the
   report header".** `DOD_SIM_MAP`, `DOD_SIM_MINIBOSS`, `DOD_SIM_START_RUNE` and
   `DOD_SIM_SPEC_OPENING` appear **nowhere in `scripts/`**, and `run_sim.gd` prints no retired line
   at all. The *record* that they are retired is correct and is kept; the claim about where it lives
   was corrected to `sim.sh`'s header and `master.html`, which is where it actually is.

**The prune found nothing to cut. The liveness test found two repairs.**

### AND THE MEASURE HAS A HOLE THAT IS WORTH MORE THAN THE PRUNE

**One block changed category between EC and ED with nobody touching it.** *"STANDING DESIGN RULE —
THE PROTECTED CORE IS THE BASELINE (Batch EB §1)"* was `quoted` for EC and is `neither` now. Its only
quotation — *"29.5% of the draft layer against 12.8% of the cores"* — lived in **EB's
`docs/state.md`**, and **EC's own rewrite of that file dropped the sentence.**

`docs/state.md` is inside the knowledge sync and is rewritten from scratch every batch, so
*"is this rule quoted anywhere?"* is partly a question about **what the last rewrite happened to
say.** The 33.3% is a reading against a corpus that churns by construction. That is now a rule.

### THE RATIO AFTER, AND WHAT THE STEADY STATE ACTUALLY IS

**ED CLEARS 3% — AND IT CLEARS IT WITHOUT REMOVING A SINGLE BYTE FROM `CLAUDE.md`, WHICH IS THE
SHARPEST THING THIS BATCH MEASURED.**

| | `CLAUDE.md` | sync | ratio |
|---|---|---|---|
| EC | 228.91 KiB | 164 files / 7.23 MiB | **3.093%** |
| **ED** | **233.08 KiB** | **168 files / 7.60 MiB** | **2.994%** |

The file **grew** by 4.17 KiB — two standing rules, two name repairs, and the source-pin block
re-pointed at its instrument. The ratio fell anyway, because **the denominator grew by 0.37 MiB**,
and **296 KiB of that is `pin-manifest.json`** — a derived instrument file with nothing to do with
`CLAUDE.md` at all.

**A TARGET THAT CAN BE MET BY ADDING AN UNRELATED FILE IS NOT MEASURING WHAT IT NAMES.** §1 already
showed the file has no dead weight; this shows the metric does not track the property anyone cares
about. The prune was never the lever — the sync's growth is — and a batch can satisfy CW's rule by
committing a large generated artefact, which is the opposite of what the rule was written for.

**AND `pin-manifest.json` IS ITSELF THE FIRST CANDIDATE FOR DESELECTION.** It is derived, it is
re-derivable in seconds by a committed generator, and it is now the fifth-largest file in the sync.
The 47 suite files are already noted as deselectable-but-not-archivable; this is the same shape and
a better candidate, because nothing is lost by regenerating it. **Reported, not taken** — what the
sync carries is the designer's.

**The brief asked what the file's real steady state looks like, and it is not 3%.** Derived from git
across **eighteen prune-free batches (DJ→EC)**:

| | per batch |
|---|---|
| `CLAUDE.md` grows | **+4,835 B** |
| the knowledge sync grows | **+79,726 B** |
| **marginal ratio** | **6.06%** |

Over the three post-DZ batches alone it is **+6,252 B against +71,848 B = 8.70%.** The ratio
converges on the marginal rate, so **pruning nothing, the file settles around 6%** — roughly double
the target. It rises about **+0.13 points a batch**, and the only thing that has ever moved it down
is a prune.

**So 3% is not a steady state the file drifts from and can be returned to. It is a number below the
growth law, reachable only by cutting, about every eight batches, forever.** DZ's cut was 51.21 KiB
and cost a whole batch; it bought eleven batches. Clearing 3% today needs **7.09 KiB** — and ED has
just established there is no dead weight to take it from.

**RULED ON NOWHERE, AND THAT IS DELIBERATE.** The two live options are unchanged from EC's report —
move the target to the growth law, or split the file as CW split the changelog — and the choice is
the designer's. What ED adds is that the third option, *keep 3% and prune periodically*, now has a
measured price: **a maintenance batch every eight passes, and this one found nothing to cut.**

---

## §2 — THE SOURCE-PIN MANIFEST

### THE POPULATION, RE-DERIVED — AND EC'S CENSUS WAS SHORT BY NINETY-NINE

**`pin-manifest.json` holds 1313 pins: 1014 into `.gd` source across 17 files, 229 into the four
tracked documents, 70 elsewhere.** The document instruments watch the smaller half by **4.4×**.

EC measured this once and reported it two ways — **915** in the report and `docs/state.md`, **917**
four times in the changelog (the pre-repair figure). **Both were low**, and the reason is the defect
EC had just closed one instrument earlier.

**FOUR EXTRACTOR BUGS, EACH FOUND BY A DISAGREEMENT RATHER THAN BY A FAILURE:**

1. **A GREEDY CAPTURE WINDOW — 99 pins.** The census matched `holder.contains(` followed by
   `.{0,600}`. `finditer` resumes at the **end** of a match, so in
   `ok(src.contains(A) and src.contains(B), …)` the second call fell **inside** the first match and
   was never seen. **This is EC §1's own defect in a second instrument** — the conjunction blindness
   EC fixed in the document sweep, still open in the source census EC used to measure it. Capturing
   the *argument* as a token instead of a window: 929 → 1003.
2. **A LINE-BOUNDED HOLDER BINDING — 11 pins.** `test_batch_cb` writes
   `var src := _strip_comments(` with the `res://` path on the **next line**; a `[^\n]*` binding
   never reaches it, so `src` bound to nothing and every pin in that function was invisible. Holders
   are bound from **statements** now, which join continuations.
3. **A MASKER THAT KNEW ONE QUOTE STYLE — 12 pins.** `rs.find('party.append({"key": key')` holds an
   unbalanced `(` and `{` inside a **single**-quoted string; masking only double quotes left them
   counted, depth never returned to zero, and **sixty lines of that function joined into one
   statement.**
4. **FORMAT TEMPLATES DROPPED RATHER THAN RECORDED — 17 pins.** `'"%s": [' % id` has no static
   needle, but it is still a pin. Dropping it left literals the gate could see and the manifest could
   not answer for.

**The corrected extraction is a strict superset of EC's**: every one of EC's 915 has a counterpart,
and where EC truncated a single-quoted needle at its first embedded quote (`'_apply_status`) the
manifest now carries the whole thing (`_apply_status(attacker, "empower", 3)`).

### WHERE EACH LITERAL LIVES, RE-DERIVED RATHER THAN DECLARED

| residency | source pins | verified every battery? |
|---|---|---|
| **`code`** — survives comment-stripping; a rewording cannot move it | **600** | yes |
| **`comment`** — resolves ONLY inside a comment | **39** | yes |
| `absent` — negative, correctly not resolving | 285 | yes |
| `narrow` — negative, but the suite reads a slice or one line-segment | 17 | **no**, counted |
| `runtime` — composed at runtime; no static needle | 71 | **no**, counted |
| `alt-sibling` — an alternation member answered by its group | 2 | by group |
| **total** | **1014** | **926 verified** |

**NO SILENT CAP.** `check_ed` prints the 88 it does not verify on every run, because a coverage
figure nobody states reads as full coverage.

### THE 39 COMMENT-RESIDENT PINS ARE THE FRAGILE ONES, AND THEY ARE FLAGGED

A pin anchored to code survives any comment edit. **A pin that resolves only inside a comment is the
one a rewording breaks, and it is the population EB's break came out of.**

| target | pins |
|---|---|
| `scripts/classes.gd` | **22** |
| `scripts/battle.gd` | **14** |
| `scripts/run_sim.gd` | 2 |
| `scripts/run_state.gd` | 1 |

**Thirteen of them are the `AXIS` / `SYNERGY` header convention, pinned by six different tranche
suites** — `bt`, `bu`, `bv`, `bw`, `cb`, `ce`. **One comment convention holds up six suites at
once**, and `check_ed` §3 asserts that from outside so it cannot quietly stop being true.

### HOW A PIN ADDED WITHOUT AN ENTRY IS CAUGHT

**The brief asked for this to be enforced or for it to be said that it cannot be. It is enforced,
in two places, and what each cannot see is stated.**

**THE SPLIT IS THE DESIGN, AND IT IS WHAT STOPS THE MANIFEST GOING STALE.**

- **`build_pin_manifest.py` DERIVES it.** Working out *which* file a literal is pinned into needs
  holder propagation through function parameters — `test_batch_bl` reads `battle.gd` in `_run()` and
  asserts on it 536 lines later inside `_section_negative_controls(bsrc, usrc)`. One analysis, in one
  committed place, re-runnable. `--check` re-derives and exits 1 if the manifest would change: that
  is the **exact** authority, with no exemptions and no blind spots.
- **`check_ed.gd` ENFORCES it and re-derives none of that.** It re-reads each named haystack and asks
  whether the recorded claim still holds. **It cannot drift from the generator because it repeats
  none of the generator's judgement.**

**WHAT `check_ed` §2 CANNOT SEE IS WRITTEN DOWN AT §2 ITSELF** (DW §1's rule): a holder arriving as a
function parameter, a needle held in a `for x in [...]` list, and a needle composed at runtime. It
sees the shape a new pin is overwhelmingly written in — **901 of them today** — and everything it
sees must have an entry.

**THE FIRST DESIGN OF THAT RULE WAS WRONG AND THE EXEMPTION COUNT SAID SO.** Demanding that *every*
literal in a locator call anywhere in the tree have an entry would have needed **663 exemptions out
of 1646**, because most such literals are tested against ability descriptions and log lines rather
than files. DW §1's note — *if widening a rule means exempting most of what it catches, the
fingerprint is wrong* — applies exactly. Scoping the demand to holders bound to a real file, **per
function**, brings it to **zero exemptions**. Scoping it per *file* instead reds a clean tree, because
`src` is bound to four different documents across `test_batch_bx` alone.

### THE GATE

**`check_ed.gd`, 18 checks, three identical standalone readings before the battery.**

- **§0** asserts the population before anything is concluded from it (EA §1), and **reds on a
  residency class it does not know** — so a class added by a later generator cannot go unwatched.
  Floors throughout, never equalities (DX §1): this population grows with every batch that authors a
  suite.
- **§1** is the half the batch exists for. Code-anchored needles must survive comment-stripping;
  comment-resident ones must be present raw **and absent once stripped** (both halves — a pin that
  migrated *out* of a comment is no longer fragile and the manifest should stop saying it is);
  negatives must stay absent.
- **AN ALTERNATION IS ANSWERED BY ITS GROUP, AND GETTING THAT WRONG REDS A WORKING CHECK.**
  `test_batch_bj` writes `ok(not src.contains(A) or not src.contains(B), …)` — a group of two
  **negatives**, satisfied when a member is **absent**. The first build tested every member for
  presence and reddened it. Twelve alternation groups; **zero have no member whose own claim holds.**
- **§3** counts and names the comment-resident population and the six-suite convention.
- **§4** proves the discrimination on synthetic input every run, **including that a `#` inside a
  string literal is not a comment** — read as one it strips live code and reports a code-anchored pin
  as comment-resident, which is the exact misreading the gate exists to prevent.

**IT EXCLUDES ITSELF FROM ITS OWN SWEEP**, the way `check_de` does: a gate that enumerates pins is a
file full of pin-shaped literals, and leaving it in would grow the population it measures on every
run. Its locator vocabulary is **joined at runtime rather than written as one literal**, which is
`check_da` §3's lesson — a gate whose source contains its own fingerprint accuses itself on the first
run and is suppressed on the second.

It reads the manifest and the suite sources only — spawns no battle, walks no ability corpus, names
neither draft-pool accessor — so it **needs no `check_da` §3 exemption**, confirmed by running
`check_da`, `check_dw`, `check_ea` and `check_ec` standalone before the battery: **39 / 35 / 60 / 22,
all matching their baselines, all zero failures.**

### EC'S VACUOUS CHECK IS CONFIRMED CLOSED

`test_batch_bg` §2 is repaired and the repair is real, measured rather than read: the slice runs from
`func _gain_faith(` at 765,801 to `func _conviction_growth(` at 775,218 — **9,417 characters** — its
opening anchor is asserted (`ok(i > 0, …)`), and `body` contains neither `.apostle` nor `oath_ranks`.
**It also carries a POSITIVE assertion** (`body.contains("u.faith_stacks = 0")`), which cannot pass on
an empty string, so the slice proves itself every run.

### AND THE SWEEP FOR THAT SHAPE FOUND THREE MORE, ALL NOW GUARDED

**87 `find`-then-`substr` slices in the tree**, classified by whether they can go vacuous in silence:

| | count |
|---|---|
| **guarded** — an `ok()` asserts the locator resolved | 51 |
| **self-proving** — a POSITIVE assertion reads the slice, which cannot pass on `""` | 14 |
| archive-path extraction — nothing asserts on the slice; a bad anchor fails loudly at the file open | 14 |
| the **documented vacuous trio** in `as` / `at` / `aw`, already recorded as owed | 3 |
| **live, resolving, and UNGUARDED** | **3** |

The three carriers are **`check_dr` §5** (the `counter_time` arm), **`test_batch_bm`'s negative
control 4** (the party-member slice) and **`test_batch_bs`'s kiln tick** (`take_tick_damage`). All
three resolve today, so none was vacuous — **each was one deleted anchor away from going silent**,
which is exactly what happened to `test_batch_bg`. **All three now assert their anchor**, one check
each: `check_dr` 79 → 80, `test_batch_bm` 1888 → 1889, `test_batch_bs` 266 → 267, every one confirmed
standalone before the battery.

---

## §3 — WHAT IS DELIBERATELY NOT DONE

- **NO `.gd` SOURCE IS REWORDED TO SUIT THE MANIFEST.** The manifest describes what is. The only
  `.gd` edits are the three locator guards, which are the shape §2 was asked to sweep for.
- **NO ABILITY MAGNITUDE MOVES**, no card is authored, and `scripts/` carries no behavioural change.
- **`docs/state.md` IS NOT PRUNED** — it is rewritten every batch and cannot grow.
- **NO RULING ON THE 3% TARGET.** The arithmetic is now complete enough to decide it; the decision
  is the designer's.
- **THE `narrow` AND `runtime` PINS ARE NOT CHASED.** 88 pins have no static needle or a haystack
  narrower than a file. Verifying them means modelling each suite's slice, which is the generator's
  job growing into an interpreter. They are counted and named instead.
- **THE DOCUMENTED VACUOUS TRIO IS UNTOUCHED.** `as`, `at` and `aw` are recorded as owed with their
  reasons, and DG's sanctioned fall is those six reds and nothing else.

---

## §4 — THE CODE CHANGE

- **`build_pin_manifest.py`** — NEW. Derives the manifest; `--check` is the exact staleness authority.
- **`pin-manifest.json`** — NEW. 1313 pins with haystack, polarity, residency and alternation group.
- **`check_ed.gd`** — NEW gate, 18 checks.
- **`check_dr.gd`, `test_batch_bm.gd`, `test_batch_bs.gd`** — one locator guard each (+1 check each).
- **`CLAUDE.md`** — two stale names repaired; two standing rules added; the source-pin block
  re-pointed at the instrument instead of restating a figure that had already rotted three ways.
- **`run_battery.sh`** gains `check_ed` in `GATES`; **`baselines.json`** gains its row and moves three,
  written at `indent=1` for no churn.
- **`scripts/` IS UNTOUCHED.** No game file changed at all.

---

## §5 — VERIFICATION

### THE DOCUMENTATION WAS WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/changelog.html`, `docs/design-notes.md`, `docs/master.html`'s stamp,
`pin-manifest.json` and `baselines.json`'s four rows were all final before the certification run.
**`docs/state.md` and this report are read by nothing** — no `.gd` file opens `res://docs/state.md`
or `res://docs/reports/`, and `check_de` reads neither — so both were written after, which is what
lets a batch certify the tree that ships.

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: EXACTLY FOUR ROWS MOVE — `check_ed` ARRIVES AT 18, `check_dr` 79 → 80,
`test_batch_bm` 1888 → 1889, `test_batch_bs` 266 → 267 — AND `check_de` READS 337 / 0 / 0.**

Predicted from what each target **READS**:

- **`check_ed`** is a new target, so `check_de` gains four assertions (333 → **337**). Its row was
  written before the battery off **three identical standalone readings of 18**.
- **The three guards add exactly one `ok()` each**, in three different files, and change no other
  condition. Each was confirmed standalone before the run.
- **Nothing else moves.** The three edited suites' other assertions read the same haystacks; the
  documents are asserted by `contains` calls whose COUNT is fixed and ED only ADDS to them; and
  `check_da` §3, `check_dw` §0, `check_ea` §3 and `check_ec` §2 were each run standalone against the
  new gate first — **39 / 35 / 60 / 22, every one matching its baseline** — so `check_ed` carries no
  fingerprint and needs no exemption.
- **`check_dv` §4's changelog span is a FLOOR of 16**; the live file goes to 24 entries.
- **The fourteen stamp gates compare `>=` their own batch code**, every one `CE` or older, and
  `ED >= CE` holds lexically.

### THE PRE-BATTERY INSTRUMENTS

1. **THE NEEDLE VERIFIER, WITH EC'S GROUP BOUNDARY IN PLACE**: **105 statements (75 positive, 30
   negative) over 127 members, 10 conjunctions, 9 alternations, 46 locators across 84 files.**
   **GREEN — 0 unsatisfied.**
2. **THE LITERAL-FLIP SWEEP, TAKEN AGAINST `git show HEAD` RATHER THAN A SNAPSHOT** — 10,995
   distinct literals at a floor of 4, over **every edited file**, `.gd` included, which is EB's
   lesson: a comment-only edit to source changes a haystack no document instrument reads.
   **0 LOST in every one of the eight**, so no pin was broken. 19 gained, and **0 of the 19 is
   negatively asserted against the file it landed in**, cross-checked against all 371 negative pins
   in the manifest. The single near-miss is `kiln_forged_at` landing in a `baselines.json` note while
   `test_batch_bs` pins it absent from `scripts/unit.gd` — a different file, and nothing asserts on
   that one.
3. **THE RETIRED-WORD SWEEP**, re-implemented from `test_batch_bx` §4/§4b with `PARTY_IDENTS` read
   out of the suite rather than copied: **0 *party*** in `master.html`, and the one *beast* is the
   lower-case `beastmaster` spec id inside a `DOD_SIM_SPECS` example — **identical at HEAD and after**,
   which a two-character stamp edit could not have changed.
4. **THE SOURCE-PIN CENSUS AND `check_ed` ITSELF**, run over the edited tree.
5. **THE FOUR FINGERPRINT GATES**, standalone, before the run.

### THE NEGATIVE CONTROLS

Each armed on something the gate **demonstrably reads**, restored by `cp` with the md5 compared —
the break reads RED and the restored tree reads GREEN.

| # | armed on | reading |
|---|---|---|
| **A** | a **code-anchored** pin: `func award_ability_pick` renamed in `run_state.gd` | **RED** — `check_ed` 18 / 1, naming all three broken pins and the two suites that hold them |
| **B** | a **comment-resident** pin: `test_batch_bl`'s `BATCH BL §2: a v8 save carries a tally` reworded | **RED** — 18 / 1, *"MOVED"* with the suite, the file and the needle |
| **C** | a **new pin, manifest not regenerated**: one `contains` added to `test_batch_cd` | **RED** — 18 / 1, *"UNRECORDED: test_batch_cd: A NEEDLE ED NEVER RECORDED"* |

**CONTROL A HAD TO BE ARMED TWICE, AND THAT IS THE ONE WORTH RECORDING.** The first arm appended a
suffix — `func award_ability_pick` → `func award_ability_pick_RENAMED` — and the gate stayed
**GREEN**, correctly: the pin is a **substring**, and it was still there. **A control armed on a
change that does not remove the needle reads green and proves nothing.** Re-armed as
`func grant_ability_pick`, so the needle actually disappears, it reds immediately.

Restored by `cp` and re-verified: `scripts/run_state.gd` back to md5
`9508183de98d0e0c9a606c3a504c3207`, `test_batch_cd.gd` to `f8a45d00ef6fa1a5b0aa0c332ddad0f0`, and
`check_ed` green again at 18 / 0.

### THE ACCEPTANCE RUN

**One battery, and it found nothing.** No suite failure, no throw, no notice, no timeout, and the
only red is the one that is on purpose.

| | EB's acceptance | EC's acceptance | **ED's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 329 / 0 / 0 | 333 / 0 / 0 | **337 / 0 / 0** |
| targets in the manifest | 80 | 81 | **82** |

**EIGHTY-TWO TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY-TWO**, with no log on disk the manifest
does not name and none named that is not on disk — compared both ways. **0 `Parse Error` and 0
`SCRIPT ERROR` in every one of the 82 logs**, grepped from the streams rather than read off a tally
or an exit code. `check_map_screen: OK`; `check_ct_map` 83 / 0; the run harness reads
**22 / 165 / 8**, all three PASS with no throws. **40,671 checks** in total.

**AND THE PREDICTION HELD EXACTLY.** `check_de` reported **337 checks, 0 failures and ZERO
NOTICES**, with **81 of 81 recorded targets swept and 0 off their recorded line**. `check_ed` read
**18** and was printed as certified on the first pass rather than as an unwatched target.
`check_dr` read **80**, `test_batch_bm` **1889**, `test_batch_bs` **267** — the three predicted
movements, each landing on the number written before the run. **No other row moved.**

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**182 files were MD5-stamped before the acceptance run and re-compared after: EVERY ONE IS
BYTE-IDENTICAL.** `CLAUDE.md`, `pin-manifest.json`, `baselines.json`, `run_battery.sh` and every
`.gd` file are unchanged across the run, **so the battery certified what ships.**

**EXACTLY TWO FILES DIFFER FROM THE CERTIFIED TREE NOW, AND BOTH ARE READ BY NOTHING**:
`docs/state.md`, and this report — §1 to §4 of it were inside the freeze, §5 was written after
because it records the run.
