# BATCH EC — THE BOUNDARY THE SWEEP LOST

*2026-08-31. One instrument repair and two measurements ruled on nowhere. **The needle sweep has
been evaluating a CONJUNCTION as a DISJUNCTION — its or-group splitter had never fired once — and
the population of assertions that pin a literal into `.gd` SOURCE is measured for the first time at
915.** No game behaviour changed, no ability moved, no card was authored, and nothing was pruned.*

---

## THE BRIEF'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first. One of them changed the work.

1. **§1 SAYS "73 POSITIVE GROUPS COLLAPSE TO 45". THAT COLLAPSE DOES NOT EXIST AT HEAD.** It is
   EB §3's measurement of the extractor **with its string-masking disabled** — a build EB had
   already repaired inside EB. Run at HEAD the extractor reads **73 positive groups and loses no
   boundary to bracket depth at all**. The live hole is a different one, and §1 below is about that
   instead.
2. **§1's SECOND HALF IS RIGHT, AND THE REASON IS NOT THE ONE GIVEN.** *"An or-group passes when
   ANY member is present"* is exactly what was happening — but not because or-groups were modelled
   loosely. **No group was ever split.** `or_groups()` looked for a top-level `or`, every assertion
   in this tree is wrapped in `ok(...)`, and so it returned ONE span for all 82 files. Every
   statement was a single bucket satisfied by `any()`. The splitter was unreachable, not mis-tuned.
3. **§3's "EB put it back over at 3.046%" IS 3.044% RE-DERIVED**, over 162 files and 7.17 MiB by
   `docs/state.md`'s own method. The 0.002-point gap is method, not movement — `state.md` says
   itself to treat the file COUNT as method-dependent — and it does not change the finding, which
   is that the target is breached.
4. **§3's "60 literals across 26 targets" DERIVES HERE AS 61 DISTINCT LITERALS ACROSS 25 READERS**,
   two of the 61 being this batch's own. The figure is inherited from EB and is restated as
   measured rather than repeated.

---

## §1 — THE OR-GROUP BOUNDARY

### WHAT THE INSTRUMENT WAS ACTUALLY DOING, DERIVED AT HEAD

The verifier bucketed its findings by `(file, statement, or-group index, polarity)` and satisfied a
positive bucket with `any(hits)`. **A bucket keyed by the or-group index holds the calls inside ONE
alternative — and those are joined by `and`.** So:

| written | meant | evaluated as | verdict |
|---|---|---|---|
| `contains(A) and contains(B)` | both | **either** | **a conjunction read as a disjunction** |
| `contains(A) or contains(B)` | either | either | correct — *by accident* |

The second row is right only because the splitter never fired. **Measured: `or_groups()` returns
`nalt > 1` for ZERO of the tree's 149 atom-bearing statements.** Nine statements contain an `or`
and ten contain an `and`; all nineteen came back as one span, because the operator sits at depth 1
inside `ok(` and the scan looked at depth 0.

**THIS IS WHY EVERY PREVIOUS MEASUREMENT CAME BACK CLEAN.** A literal census reads the same 125
members either way. The failure is in the BOUNDARY between them, and a census has no way to see it.

### THE FIX: A STATEMENT IS A DISJUNCTION OF CONJUNCTIONS

`or` binds looser than `and`, so the correct model is the one GDScript has. A member is satisfied
when the literal's presence matches its polarity; an alternative is satisfied when **all** its
members are; the statement is satisfied when **any** alternative is. The operator is found at the
depth of the boolean **expression** — the minimum bracket depth among the statement's own atoms —
not at the depth of the statement.

Unit-checked on five shapes before it was pointed at the tree:

| written | DNF read |
|---|---|
| `A and B` | `[A∧B]` |
| `A or B` | `[A] , [B]` |
| `A and (B or C)` | `[A∧B] , [A∧C]` |
| `(A or B) and C` | `[A∧C] , [B∧C]` |
| `A or B and C` | `[A] , [B∧C]` |

### WHAT THE 73 TURN UP AT FULL RESOLUTION

**103 asserting statements — 73 positive, 30 negative — over 125 members, plus 46 locators, across
82 files.** Nineteen statements hold more than one member: **ten are CONJUNCTIONS and nine are
ALTERNATIONS.** Every one is reported below with its verdict.

| # | suite | shape | members | verdict |
|---|---|---|---|---|
| 1 | `check_dm` | conjunction | 2 | **holds** — both Faith-drip parentheticals present |
| 2 | `check_do` | alternation | 2 | **legitimately satisfied** — upper-case form present, title-case absent |
| 3 | `check_dv` | alternation | 2 | **holds** — both present |
| 4 | `check_dv` | alternation | 2 | **legitimately satisfied** — the long form of the oracle rule is absent |
| 5 | `test_batch_ax` | conjunction | 2 | **holds** — both negatives absent |
| 6 | `test_batch_ba` | conjunction | 2 | **holds** — both negatives absent |
| 7 | `test_batch_ba` | conjunction | 2 | **holds** |
| 8 | `test_batch_bn` | alternation | 2 | **holds** — both entity and glyph present |
| 9 | `test_batch_bn` | alternation | 2 | **legitimately satisfied** — `&times;1.00` absent, `×1.00` present |
| 10 | `test_batch_bn` | conjunction | 3 | **holds** |
| 11 | `test_batch_bo` | alternation | 2 | **legitimately satisfied** — `The Ability Draft` absent, upper-case present |
| 12 | `test_batch_bo` | alternation | 3 | **legitimately satisfied** — `cap at 7` absent, two siblings present |
| 13 | `test_batch_bp` | conjunction | 2 | **holds** |
| 14 | `test_batch_bp` | alternation | 2 | **legitimately satisfied** — `stance-gated` absent, `stance-GATED` present |
| 15 | `test_batch_bq` | conjunction | 2 | **holds** — both negatives absent |
| 16 | `test_batch_br` | conjunction | 2 | **holds** — both negatives absent |
| 17 | `test_batch_bs` | alternation | 2 | **holds** — both present |
| 18 | `test_batch_bs` | conjunction | 3 | **holds** |
| 19 | `test_batch_ce` | conjunction | 2 | **holds** |

**ZERO REAL DEFECTS, AND THAT IS THE FINDING RATHER THAN A DISAPPOINTMENT.** All ten conjunctions
hold in full, so the blindness had no live defect underneath it. **What it did have was six live
false alarms waiting for the wrong repair.**

### THE WRONG REPAIR WOULD HAVE COST SIX

**Six of the nine alternations have a member that is legitimately absent** (rows 2, 4, 9, 11, 12,
14). Every one is the same design: a needle written twice because the document could spell it
either way — an HTML entity beside its unicode glyph, an upper-case heading beside its title-case
twin. **A repair that treated every group as a conjunction reds all six on its first run.**

That is not a smaller problem than the one being fixed. **118 rows for 16 defects is the reason
EB's header sweep was reported and never gated**, and this would have been six-for-nothing. So the
distinction between an alternation and a conjunction **is** the fix, and `check_ec` §3 proves it
discriminates on built input, in both directions, before it judges anything.

### AND TWO MORE EXTRACTOR BUGS THE SOURCE POPULATION EXPOSED

Both are latent in the document sweep — it reads the same 73/30/125 with and without them — and
both are live in the source sweep §2 builds, which is what surfaced them.

- **THE POLARITY LOOK-BEHIND MISSES A RECEIVER.** `not FileAccess.get_file_as_string(…).contains(
  "const CLASS_POOLS")` was read as POSITIVE, because a fixed 24-character `not\s*$` look-behind
  cannot see past `FileAccess.`. **Six deliberately-absent literals reported as pins that no longer
  resolve.**
- **UNESCAPE RAN ITS `replace` CHAIN IN THE WRONG ORDER.** `\n` was substituted before `\\`, so a
  source literal written `\\n` — an escaped backslash then `n`, which is what a suite writes to pin
  the two raw characters a `.gd` description holds — came out as a backslash plus a real newline
  and matched nothing. **Six pins into `classes.gd` read as unresolved for that reason alone.** It
  is one left-to-right pass now.

### THE REPAIR IS A GATE, NOT A SCRATCHPAD SCRIPT

**`check_ec` — 22 checks.** §0 asserts the population before anything is concluded from it. §1 reds
on a statement mixing `and` and `or` at the boolean depth, so the two-shaped model is checked
rather than assumed. §2 is the boundary. §3 is the discrimination control, run every time.

---

## §2 — A SUITE ASSERTING AGAINST `.gd` SOURCE IS INVISIBLE TO EVERY DOCUMENT INSTRUMENT

### THE POPULATION, MEASURED FOR THE FIRST TIME

**915 assertions pin a literal into a `.gd` source file, across 52 suites and 17 source files.**
The four tracked documents carry **196**. **The instruments were watching the smaller half by a
factor of 4.7.**

| where the literal resolves | pins |
|---|---|
| **anchored to CODE** — a reworded comment cannot move it | **499** |
| **anchored to a COMMENT** — positive, resolves nowhere else | **37** |
| negative, and correctly absent | 249 |
| negative, against a slice or a comment-stripped copy | 13 |
| composed at runtime — no static literal to pin | 116 |
| an alternation satisfied by its sibling (`test_batch_ay`) | 1 |
| **total** | **915** |

Reaching that number needed the extractor to follow a holder **through a function parameter**:
`test_batch_bl` reads `res://scripts/battle.gd` in `_run()` and asserts on it 536 lines later
inside `_section_negative_controls(bsrc, usrc)`. It also needed loop lists — six of `bl`'s own
control-1 needles are written as `for forbidden in [...]` and a sweep that reads only literals
written inside the call sees none of them.

### THE 37 ARE THE EXPOSURE, AND THEY ARE NAMED

A pin anchored to code survives any comment edit. **A pin that resolves ONLY inside a comment is
the one a rewording breaks, and it is the population EB's break came out of.**

| target | pins | asserting suites |
|---|---|---|
| `scripts/classes.gd` | **22** | `bt` 4, `cb` 4, `ce` 4, `bu` 3, `bv` 3, `bw` 2, `bi` 1, `bg` 1 |
| `scripts/battle.gd` | **12** | `bl` 3, `bb` 3, `ba` 2, `bm` 1, `bi` 1, `bs` 1, `test_run_harness` 1 |
| `scripts/run_sim.gd` | 2 | `bm` 2 |
| `scripts/run_state.gd` | 1 | `bl` 1 |

Twelve of the 22 in `classes.gd` are the `AXIS` / `SYNERGY` header convention, pinned by six
different tranche suites — **one comment convention holding up six suites at once**, which is the
shape worth knowing before anybody tidies those headers.

### AND THE CENSUS FOUND A LIVE VACUOUS CHECK

`test_batch_bg` §2 built its haystack as:

```
var body := src.substr(i, src.find("func _conviction_growth(") - i)
var rel := body.find("# The fifth stack:")
var after := body.substr(rel, body.length() - rel)
ok(not after.contains(".apostle"), …)
```

**`# The fifth stack:` is not in `battle.gd`. Batch BH deleted it.** Measured rather than reasoned,
with a probe against the live file: **`rel = -1`, and Godot's `substr` on a negative offset returns
`""`.** `not "".contains(anything)` is true for every needle there is, so **two checks passed while
reading nothing at all.**

**THE COMMENT ABOVE THEM ALREADY SAID SO.** BH wrote *"the slice has no anchor. The question
survives and is asked of the whole branch, which is strictly stronger"* — and then left the slice
standing. **The sentence was written and the change was never made.** Both questions are asked of
`body` now, which is what that sentence claimed; the property still holds — `body` contains neither
`.apostle` nor `oath_ranks`, verified live. `test_batch_bg` reads 47 / 0 before and after, so no
row moves.

**A SLICE BUILT FROM A `find()` IS ONLY AS REAL AS ITS ANCHOR.** `bg`'s outer anchor was asserted
(`ok(i > 0, …)`) and its inner one was not, which is the whole difference.

### WHAT COVERS IT — THREE OPTIONS, AND NONE IS CHOSEN

**This section reports and rules on nothing.** The costs are not comparable in a way a batch about
something else should be settling.

| option | what it costs | what it misses |
|---|---|---|
| **Extend the document instruments to source.** Run the same literal-flip sweep with the edited `.gd` files as the documents. | Nothing to build — it exists, EB wrote it after the break, and it takes seconds. It reads every literal in the tree at a floor of 4 against each edited file. | **It only fires on files a batch EDITS.** It cannot tell a needle from prose, so it reports every LOST literal and the reader judges — which on a comment-heavy edit is the 5.5-to-1 noise §1 warns about. |
| **A manifest of pinned literals the sweep reads.** Name the 37 (or all 915) in a file, and check the manifest against the tree. | A file that must be kept true, and a second place for the truth to rot. The 37 move whenever a suite is re-pointed. | Nothing, while it is accurate. **Everything, silently, once it is not** — which is the failure mode this project has paid for four times. |
| **A rule: do not pin `.gd` source.** | **Nothing to run.** It lands at authoring time, where the information is. | **It invalidates all 915 existing pins across 52 suites**, and many are the only assertion that a code path is shaped the way a ruling says. It is a rewrite, not a rule. |

**The general shape is what is worth keeping either way, and it is in `CLAUDE.md`:** an
instrument's territory is a claim, and a check living outside it is not protected by it. A green
sweep does not mean nothing is broken; it means nothing is broken **inside this haystack**.

---

## §3 — IS 3% THE RIGHT TARGET FOR `CLAUDE.md`?

### WHERE THE RATIO IS

| | `CLAUDE.md` | sync | ratio |
|---|---|---|---|
| DZ, after the prune | 210.56 KiB | 157 files / 6.98 MiB | **2.948%** |
| EA | 215.32 KiB | 160 / 7.10 MiB | 2.963% |
| EB (re-derived here) | 223.42 KiB | 162 / 7.17 MiB | **3.044%** |
| **EC** | **228.91 KiB** | **164 / 7.23 MiB** | **3.093%** |

**EC MOVES IT FURTHER OVER, AND THAT IS RECORDED RATHER THAN PASSED OVER.** Two standing rules and
two amendments cost **+5.49 KiB** and **+0.049 of a percentage point**; clearing 3% now needs
**7.09 KiB** out of the file. **No prune was taken** — the brief forbids it and the reason still
holds: it is bounded by **61 distinct literals across 25 reader files**, not by judgement, so it is
its own batch with its own battery.

### THE MEASUREMENT THAT DECIDES WHICH OPTION IS RIGHT

*How much of the file is rules that have never been read since they were written?* Measured two
ways, both exact about what they mean:

- **ASSERTED** — a suite or gate pins a literal inside the rule. This is the needle population,
  attributed back to the block it lands in.
- **QUOTED** — another file in the knowledge sync repeats a phrase from the rule verbatim,
  approximated by the file's own emphasis unit: every `**bolded**` span of 25 characters or more.
  **A rule's own originating batch report is excluded**, because the batch that wrote the rule
  wrote that report in the same pass and it is not evidence of a second reading.

The file as shipped tiles into **94 rule-blocks** (a heading and its body; a heading with
sub-headings keeps only its own intro, so the shares sum to 100).

| | blocks | bytes | share |
|---|---|---|---|
| **asserted by a suite or gate** | 24 | 60,978 | **26.2%** |
| quoted elsewhere, never asserted | 28 | 97,447 | **41.9%** |
| **neither asserted nor quoted** | **42** | **74,398** | **32.0%** |

**AND THE AGE OF THE NEVER-READ THIRD IS THE HALF THAT MATTERS.** A rule written this batch cannot
yet have been read again:

- written in the last eight batches (DV–EC): **9,782 B — 4.2% of the file**
- older than that, or citing no batch at all: **64,616 B — 27.8% of the file**

**So the file is not tight.** Clearing 3% needs **7.1 KiB**; **ten times that has never been
referenced by anything since the batch that wrote it.** That does not make those rules deletable —
**a rule that has never been quoted may still be load-bearing, and most rules work by being
obeyed** — but it settles the question the target cannot answer on its own: the pressure on the
ratio is not density.

### THE FOUR OPTIONS, WITH THE ARITHMETIC — AND NO RECOMMENDATION

| option | what it costs | what the measurement says about it |
|---|---|---|
| **Keep 3% and prune periodically.** | A maintenance batch every few passes. DZ's cut was 51.21 KiB and took a whole batch; the current overrun is 3.3 KiB. | **The growth law makes this recur by construction.** Three batches in a row have moved the ratio and every batch that earns a rule adds one. |
| **Raise the target to the measured steady state.** | Nothing to run. | Rules landed at **+8.1 KiB** (EB) and **+6.4 KiB** (EC) against a sync growing ~10 KiB a batch, so the ratio rises about **+0.08 points per rule-bearing batch**. A target set where the file actually sits is a target that can be held. |
| **Cap it structurally — a fixed rule count, adding one requires retiring one.** | Every batch must argue a retirement. **A suspension outlives its reasons**, and this project has already found a rule standing after both its justifications were deleted. | **43 blocks are unreferenced**, so a retirement queue would not be short of candidates — but it would be choosing by *unreferenced*, which is not the same as *dead*. |
| **Split again, as CW split the changelog** — rules binding every batch versus rules binding a subsystem. | One cut, once. **Four of the 42 never-read blocks name themselves as reference rather than rule** — the computed block, the debug surfaces, the shell and the files, the architecture note — and they are the natural far side of that cut. | The 26.2% that IS asserted is what a batch must not lose; the split would have a measured seam rather than a judged one, but four blocks is a small seam for a whole cut. |

**RULED ON NOWHERE. The choice is the designer's, and it is the kind that should be made once and
deliberately rather than as a side effect of a batch about instruments.**

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **NO PRUNE.** §3 forbids it and the bound is unchanged: 61 literals across 25 readers.
- **NO COVERAGE INSTRUMENT FOR §2.** Three options, costs stated, none chosen — because the
  cheapest to run is the one that invalidates all 915 pins, and that is not a side effect.
- **THE NEEDLE VERIFIER IS STILL NOT A GATE IN ITS FULL FORM.** `check_ec` asserts the BOUNDARY
  property over the same population; it does not take over the scratchpad sweep's job of reporting
  locators and lost literals, which stays a pre-battery instrument.
- **THE THREE VACUOUS DOCUMENT LOCATORS IN `as`, `at` AND `aw` ARE UNTOUCHED.** They are the three
  that still do not resolve, they are what `docs/state.md` records as owed, and they are DG's
  sanctioned exception. `test_batch_bg`'s was **not** one of them — it was unmeasured, in a
  different haystack, and it is repaired.
- **NO GAME BEHAVIOUR MOVED.** No ability, no card, no pool, no magnitude.

---

## §5 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/changelog.html`, `docs/design-notes.md` and `baselines.json`'s `check_ec` row
were all final before the certification run. **`docs/state.md` and this report are read by
nothing.** `docs/master.html` is untouched — nothing about the game changed.

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: EXACTLY ONE ROW MOVES — `check_ec` ARRIVES AT 22 — AND `check_de` READS 333 / 0 / 0.**

Predicted from what each suite **READS**:

- **`check_ec`** is a new target, so `check_de` gains four assertions (329 → **333**). Its row was
  written before the battery off **three identical standalone readings of 22**, so `check_de`
  certifies on pass one instead of reporting an unwatched target.
- **`test_batch_bg` stays at 47.** The repair deletes two locals and re-points two `contains` calls
  from an empty slice to the enclosing branch; the number of `ok()` calls is unchanged, and the
  property still holds. **Confirmed standalone: 47 / 0.**
- **The three edited documents are asserted by `contains` calls whose COUNT is fixed**, and EC only
  ADDS to them: the literal-flip sweep reads **0 lost** in all four.
- **`check_dv` §4's changelog span is a FLOOR of 16**; the live file goes to 23 entries and cannot
  red it.
- **`check_ea` §3's floors are `readers >= 20` and `scanned >= 40`.** `check_ec` adds a reader and
  two literals, neither of which is a batch code.
- **`check_da` §3 and `check_dw` §0** — `check_ec` reads only the four documents and the suite
  sources. It spawns no battle, instantiates no scene, walks no ability corpus and names neither
  draft-pool accessor, so it carries neither fingerprint and needs no exemption. **Run standalone
  before the battery.**

### THE PRE-BATTERY INSTRUMENTS

1. **THE NEEDLE VERIFIER, WITH THE GROUP BOUNDARY CLOSED**: **105 statements (75 positive, 30
   negative) over 127 members, 10 conjunctions, 9 alternations, 46 locators across 83 files.**
   Green at HEAD and green after. **Three locators do not resolve and all three are the known
   vacuous trio** in `at`, `at` and `aw` — the same three, unchanged.
2. **THE LITERAL-FLIP SWEEP** over the four tracked documents, **10,923 distinct literals at a
   floor of 4**: `CLAUDE.md` **5 gained / 0 lost**; `master.html` 0 / 0; `changelog.html` **3
   gained / 0 lost**; `design-notes.md` 0 / 0. All eight cross-checked against every negative
   assertion in the tree: **0 gained literals are negatively asserted against the document they
   landed in.** The near-misses are all negatives against `.gd` source (`const CLASS_POOLS` against
   `classes.gd`) or line-level `#` tests, and none reads a tracked document.
3. **THE RETIRED-WORD SWEEP**, re-implemented from `test_batch_bx` §4 and §4b with `PARTY_IDENTS`
   read out of the suite rather than copied: **0 *beast* and 0 *party* across 13 `.gd` files and
   `master.html`.** Clean before and after.
4. **THE SOURCE-PIN CENSUS** (§2's own instrument) run over the edited `.gd` files.
5. **A SUBSET BATTERY** over every live reader of the four documents plus the edited targets.

### THE NEGATIVE CONTROLS

Every one armed on something a **suite demonstrably reads**, and restored by `cp` with the md5
compared — EB §3's precondition, applied in both directions: the break reads RED and the restored
tree reads GREEN.

**1. THE BOUNDARY ITSELF, AND IT IS THE CONTROL THE BATCH TURNS ON.** `test_batch_bn` asserts a
**three-member conjunction** against `CLAUDE.md`. One member — `THE ONLY THING ON` — was reworded
out of the document, leaving the other two present. Four instruments were then run over the same
tree:

| instrument | reading |
|---|---|
| **EB's build — the one that certified EA and EB** | **GREEN. 0 violations.** |
| **EC's build** | **RED**, naming the file, the document and which of the three members fails |
| **`check_ec`** | **23 / 2**, with the same name |
| **`test_batch_bn` — a real suite** | **81 / 1**, *"CLAUDE.md still says rung 1 alone moved"* |

**The instrument that certified the last two batches said nothing, and the battery would have said
it three hours later.** That is the whole of §1 in one reading. Restored by `cp`; `CLAUDE.md` back
to md5 `1c9737319771cc4a68c22797c2754a40`, and all four green again.

**2. THE `test_batch_bg` REPAIR, ARMED IN TWO ARMS BECAUSE ONE ARM CANNOT SHOW IT.** A read of
`.apostle` was injected into `_gain_faith`'s branch in `battle.gd` — a COMMENT, deliberately, since
the haystack is raw source and §2 is about exactly that.

- **ARM A — the REPAIRED suite: RED**, *"§2: nothing in the release branch reads `apostle` — the
  park is gone"*.
- **ARM B — HEAD's suite with the vacuous slice, same injection: that check stayed GREEN.** Only a
  different check elsewhere in the suite noticed. **The check under test was reading `""` and
  said so by saying nothing.**

Restored by `cp`; `battle.gd` back to `2eb5db71a9855b24c6b9a71f2044a4b7` and
`test_batch_bg.gd` to `3c6983ed5c4fafdc4a0e76efc29c2f2a`.

**3. THE PARSE CONTROL, ARMED INSIDE `check_parse`'s ACTUAL SCOPE.** EB's control 0 was armed on a
GATE and read clean because `check_parse` walks `res://scripts` and `res://scenes` and does not
cover the gates. So this one was armed on `scripts/run_state.gd` — the closing parenthesis removed
from `draft_pool_left`'s signature. **22 `Parse Error` lines in stderr and 7 parse failures**,
**grepped from stderr, never from the tally and never from the exit code**. Disarmed: 0
`Parse Error` lines. Restored by `cp`; `scripts/` reads clean against `git status`.

### THE ACCEPTANCE RUN

**One battery, and it found nothing.** No suite failure, no throw, no notice, no timeout, and the
only red is the one that is on purpose.

| | EA's acceptance | EB's acceptance | **EC's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 325 / 0 / 0 | 329 / 0 / 0 | **333 / 0 / 0** |
| targets in the manifest | 79 | 80 | **81** |

**EIGHTY-ONE TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY-ONE**, with no log on disk that the
manifest does not name. **0 `Parse Error` and 0 `SCRIPT ERROR` in every one of the 81 logs** —
grepped from the streams rather than read off a tally or an exit code, and **not one log contains
either marker**. `check_map_screen: OK`; `check_ct_map` 83 / 0; the run harness reads
**22 / 165 / 8**, all three passing. **40,644 checks** in total.

**AND THE PREDICTION HELD EXACTLY.** `check_de` reported **333 checks, 0 failures and ZERO
NOTICES**. `check_ec` read **22** — the row written before the run, off three identical standalone
readings — and `check_de` printed it as *"22 checks / 0 failures (recorded 22 / 0) obs 3/3"*,
certifying on pass one rather than reporting an unwatched target. `check_de` itself went 329 → 333,
four assertions for the one new target, which is the movement nothing reports because it has no row
of its own. **`test_batch_bg` read 47**, unmoved by the repair. **No other row moved.**
`test_batch_an` read **6050**, inside its recorded [6046, 6063] band, and the differ said so by
saying nothing.

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**180 files were MD5-stamped before the acceptance run and re-compared after: EVERY ONE IS
BYTE-IDENTICAL.** `CLAUDE.md`, `docs/changelog.html`, `docs/design-notes.md`, `baselines.json`,
`run_battery.sh` and every `.gd` file are unchanged across the run, **so the battery certified what
ships.**

**EXACTLY TWO FILES DIFFER FROM THE CERTIFIED TREE NOW, AND BOTH ARE READ BY NOTHING**:
`docs/state.md`, and this report — §1 to §4 of it were inside the freeze, §5's controls and
acceptance were written after the run because they record it. **Every mention of either file in the
tree is inside a comment; no `.gd` file reads `res://docs/state.md` or `res://docs/reports/`
at all**, and `check_de` reads neither.

### THE CODE CHANGE

**ONE NEW FILE AND ONE REPAIRED SUITE.**

- **`check_ec.gd`** — the new gate, 22 checks.
- **`test_batch_bg.gd`** — §2's vacuous slice repaired: two locals deleted, two `contains` calls
  re-pointed from an empty slice to the enclosing branch, and a comment recording what was measured.
  **47 / 0 before and after.**
- **`run_battery.sh`** gains `check_ec` in `GATES`; **`baselines.json`** gains its row, written at
  `indent=1` for a 14-line insertion and no churn.
- **`scripts/` IS UNTOUCHED.** No game file changed at all.
