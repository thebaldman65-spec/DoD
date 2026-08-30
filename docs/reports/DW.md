# BATCH DW — THE WALK, THE FINGERPRINT THAT SHOULD HAVE CAUGHT IT, AND THE OVERRUNS

*2026-08-29. Three items. **The brief named one hand-rolled corpus walk and two holes in the rule
that should have caught it. There were THREE walks and THREE holes**, and in both cases the one
nobody had named was the worst. Two populations pinned as equalities over a short walk are corrected
to their real size, and one text overrun turns out to have been authored twice.*

---

## THE BRIEF'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because two of them changed the work.

1. **§5 says §2 will move `test_batch_cp`'s check count "since its walk grows from 211 to 227".
   THE COUNT DID NOT MOVE — it holds at 697.** The walk did grow, and both of its populations were
   wrong and are corrected; but each is asserted as a single equality, so twenty more abilities
   walked produce no new checks. **The rows that moved are `check_da` (37 → 39) and `check_dv`
   (128 → 130), neither of which the brief predicted.**
2. **"`test_batch_cp` walks a corpus that reaches 211." IT REACHES 207.** 211 is the NAME count;
   the walk resolves each name through `Classes.pool_ability` and **returns 207 abilities**, because
   the four class basics it does reach — Magic Bolt, Smite, Strike, Quick Shot — do not resolve
   through that accessor and fall out at the resolve step. §3's rules run over the returned array,
   so 207 is the operative figure. Both numbers are real and they measure different things.
3. **§1 says the fingerprint has two holes. IT HAS THREE, and the third is the largest** — see §1
   below. The two named holes are both real; neither of them is why the worst walk hid.
4. **§3 says Shadowrend's overrun is one of four things "the corpus fix made visible". IT WAS NOT
   MADE VISIBLE BY ANYTHING** — the identical string is authored on SMITE as well, and Smite has
   been in the corpus since long before DU. See §3.
5. **Everything else held**, including the 44-character ceiling, the rendered 49, DV's eight-name
   digit population, and both named exemptions being legitimate.

---

## §1 — THE FINGERPRINT HAD THREE HOLES, AND THE THIRD WAS INSIDE THE POPULATION IT ALREADY SWEPT

`check_da` §3 has asserted since Batch DA that no gate hand-rolls the ability corpus.
`test_batch_cp._corpus()` is a hand-rolled ability corpus. **The two existed side by side for their
whole lives and the gate read 37/0 on every battery run in between.**

DV diagnosed two holes. Both are real:

| hole | what it is |
|---|---|
| **population** | the walk sweep reads `check_*.gd` **only** — §3's suite half is about `_spawn` |
| **convention** | the fingerprint matches the two draft-pool **ACCESSORS**; `cp` reads the **CONSTANTS** |

**AND A THIRD, WHICH NO POPULATION AXIS WOULD EVER HAVE FOUND: the fingerprint took *"a corpus walk
reads the draft pools"* as a premise rather than as an assumption.**

> `check_cl_resolver._every_ability()` is a corpus walk **in a gate** — inside the population
> `check_da` had been sweeping since DA, read on every battery run since — and it reads only
> `Classes.kit()` and `Classes.spec_abilities()`. **It reached 43 of 227.**

### THE CENSUS — THREE WALKS, AND THE TWO DV HAD NOT FOUND REACHED LESS

**Reported before any of them was repaired**, which is the brief's instruction and the right order:
the count is the finding.

| walk | reaches | of 227 | what it feeds |
|---|---|---|---|
| `check_cl_resolver::_every_ability` | **43** | 19% | CL §1's **asserted** unexpanded-token sweep |
| `test_batch_bh::_all_ability_names` | **91** | 40% | §1's *"Certain reaches exactly 2 game-wide"* |
| `test_batch_cp::_corpus` | **207** | 91% | §2's biconditional and §3's literal-digit rule |

- **`check_cl_resolver` IS THE ONE THAT OUTRANKS THE BRIEF'S.** It is the gate that *authored* the
  CL §1 rule, and the half of it that is a real gate — `bad += unresolved`, an unexpanded token
  surviving resolution — was running over **19% of the game**. **RE-RUN OVER ALL 227 IT STILL READS
  ZERO.** Nothing was hiding. That is worth stating plainly rather than counted as a catch: the
  instrument was blind, and the thing it was blind to was not there. Its **reported** half moves
  6 → 8, and the two it could never see are Arcane Explosion and **Shatter** — the one name
  `test_batch_cp` §3 pinned its entire population on.
- **`test_batch_bh` READS NEITHER DRAFT POOL**, so no fingerprint built on those two calls could
  have accused it whatever population it swept. **Its number did not move**: Certain reaches exactly
  two abilities over the real corpus as it did over 91. **The claim was true and the instrument
  behind it could not have known** — 136 abilities were never asked.
- **`test_batch_cp` IS DV's**, and it is the only one of the three whose blindness had actually cost
  something. See §2.

### THE WIDENED RULE ASKS WHAT A WALK *IS*, NOT WHICH CALLS IT MAKES

> **A function that RETURNS a collection built out of two or more of the game's seven
> ability-source families is answering "what abilities exist?", and `Classes.ability_corpus()` is
> the one authorised answer.**

**THE RETURN IS THE DISCRIMINATOR AND IT IS DOING REAL WORK.** A body that reads a pool and
ASSERTS on it returns void and is not a walk. This matters more than it looks:

| fingerprint | files accused | exemptions needed |
|---|---|---|
| flat union of marks, gates + suites | **16** | **16** |
| function-body breadth, ≥5 families | 9 | 7 |
| **returning bodies, ≥2 families** | **3** | **1** |

**SIXTEEN EXEMPTIONS IS NOT A RULE.** It is a rule with a list of the places it has agreed not to
look — and **an exemption granted to a genuine violation is worse than the violation it covers**,
because the violation is at least still visible. The fingerprint has to be sharp enough that its
catches are real, and sharpening the question is what does that, not lengthening the list of marks.

- **THE ONE EXEMPTION IS `check_cz::_cl_only_corpus`**, the deliberate Batch CL negative control,
  with its reason at the site. **It is keyed `file::func`, never by file** — a file-scoped exemption
  blinds the rule to a new walk arriving in that file later, which is the `check_ds` lesson one turn
  further on.
- **COMMENTS ARE STRIPPED BEFORE THE MATCH.** `check_ds` took a red from §3 for a header comment
  that named both accessors while explaining that the file does not call them. Stripping is that
  ruling made mechanical: prose describing a walk is not a walk.
- **THE OLD SWEEP AND BOTH ITS EXEMPTIONS ARE UNTOUCHED.** This is an **added** instrument, not a
  loosened one — loosening a rule to cover a new case re-argues every case it already settled.
  `check_da` goes **37 → 39** (`accused.is_empty()` plus the one-entry exempt-alive loop; a run that
  accuses reads 40, because each accusation is its own check).
- **THE SOURCE SCANNER IS AUTHORED ONCE**, in `gate_fixture.gd`, because `check_da` and `check_dw`
  both need it and DA/DB/DD's whole lesson is that the second copy is where the two disagree.

---

## §2 — TWO POPULATIONS PINNED AS EQUALITIES OVER A WALK THAT COULD NOT SEE THEM

`test_batch_cp._corpus()` is `return Classes.ability_corpus()` now, and **both of its named
populations were wrong.**

### THE LITERAL-DIGIT RULE PINNED ONE. THE POPULATION IS EIGHT.

`AUTHORED_DIGIT_ABILITIES == ["Shatter"]`, as an equality, over a walk reaching 207.

| ability | the parenthetical |
|---|---|
| **Arcane Explosion** | `(2 on a critical strike)` |
| Detonation | `(tick × turns left × 2.5)` |
| Hymn of Hope | `(+1 Mercy)` |
| Resurrection | `(+1 Mercy)` |
| Shatter | `(max 12)` |
| Summon Aguila | `(80 HP)` |
| Summon Canis | `(80 HP)` |
| Summon Ursus | `(110 HP)` |

**Seven were always invisible; DU's corpus fix added the eighth and the walk could not see that
either.** They are **recorded, not rewritten** — `check_cl_resolver` §1's own standing note is that
a parenthetical digit is legal in prose that is not a resolved value, so this is a named population
a human has read and a **ninth** has to be a decision. Rewriting shipped player-facing text is
authoring.

### THE CHECKED-BUT-PERFECTLESS BICONDITIONAL PINNED SIX. THE POPULATION IS EIGHT.

**Arcane Explosion and Death Ray** join Called Shot, Coup de Grâce, Pinning Shot, Powershot,
Pyroblast and Rampage.

**ARCANE EXPLOSION IS IN BOTH TABLES AND IT IS THE ARCANIST'S LIVE BASIC ATTACK.** It runs a skill
check — so the player gets a timing bar — and advertises no Perfect at all, on the card a hero casts
most. **It entered the corpus at DU §4 and broke both rules on arrival with nothing going red**,
because the rules that would have caught it could not see it. **Authoring a Perfect for it is a
design decision and none was taken**; `check_dw` §2 asserts the gap is still where DW found it.

### AND BOTH FAILURE MESSAGES CARRIED A SECOND COPY OF A COUNT

One read *"the ABILITY-level authored digits are exactly the recorded **fourteen**"* against a table
holding **one**. The other read *"exactly the named **six**"*. **Both now count the table rather than
naming a number, and both print the live figure beside the population** — the second-copy defect was
sitting inside the assertions written to catch drift. The header comment above the biconditional
said *"the **five** abilities"* against a table of six, and says neither now.

---

## §3 — THE 49-CHARACTER OVERRUN WAS AUTHORED TWICE, AND THE OLDER COPY WAS NEVER HIDDEN

DV recorded Shadowrend's rendered Perfect at **49** against the measured **44**-character ceiling as
*the one thing DU §4's corpus fix made visible*. **It was not.**

`"Cleric recovers {mhp:5}"` is authored at **two** sites — `classes.gd:140` on **SMITE**, the Cleric
class basic, and `classes.gd:4560` on Shadowrend — and `Classes.ability_corpus()` has walked
`kit("cleric")` since long before DU. **The identical 49-character breach was already in the corpus
under Smite's name. DU added a second instance of a breach that was always visible.**

**PROVED MECHANICALLY RATHER THAN ARGUED.** Repairing both drops `check_cl_width`'s `perfect_text`
overrun count **56 → 48**, and **8 is four render contexts × two abilities** — had only Shadowrend
ever been over, it would have fallen by four.

### THE REPAIR, AND WHY IT IS THE FILE'S OWN IDIOM

Both sites read **`{mhp:5}`** now, rendering at **33**. That is the dominant shape in the file for a
bare magnitude — `{mhp:35}`, `{mhp:20}`, `{mhp:8} per stack`, `{atk:22}` — and
`"Cleric recovers …"` was the outlier. The `Perfect:` label and the card it sits on already say
whose recovery it is, and `perfect_id` is `self_heal`, which heals the caster. **Rewording to fit a
measured ceiling is repair; the magnitude, the id and the behaviour are untouched.**

- **`check_dv` §5's PIN IS INVERTED RATHER THAN DELETED.** It asserted the overrun and its own
  failure message said that if it ever fits, the report is stale. It asserts the **fit** now —
  a deleted check lets the overrun come back silently. **128 → 130.**
- **`check_dw` §3 ASSERTS THE TWO STRINGS AGREE.** Fixing one of two copies is how two copies start.
- **AND IT ASSERTS THE ASYMMETRY THAT MAKES THE CORRECTION TRUE**: Smite **is** in the unoverridden
  `kit("cleric")` and Shadowrend is **not** — it arrives only through `apply_kit_overrides`. That is
  the whole of why "the one thing DU made visible" was wrong, and it is asserted rather than
  written down.

### THE COMPLETE RESULT FOR ALL FOUR ABILITIES DU MADE CHECKABLE

Nobody had read it. **Three of the four were clean.**

| ability | description | perfect_text | verdict |
|---|---|---|---|
| Fireball | 35 | 33 | **inside on every field** |
| Frostbolt | 40 | 33 | **inside on every field** |
| Arcane Explosion | 34 | *(none)* | inside the ceiling; breaks **both** §2 rules |
| **Shadowrend** | 35 | **49 → 33** | the only width breach, and never only its own |

**That three of the four were clean is only visible because all four were measured** rather than the
one that failed. `check_dw` §4 measures all four every run.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **Holy's empty boss awards.** Unchanged and still the designer's. **The sharpest point restated:
  the spec with the emptiest pool also carries four protected cores, so it has the fewest slots in
  the game to receive a card** — and the two card-shaped fallbacks are worth least exactly where the
  hole is worst, while gold and a rune cost no slot.
- **`CLASS_POOLS`.** Untouched. A lost feature holding seven abilities listed nowhere else. It stays
  named in `state.md`'s queue.
- **The eight literal-digit parentheticals and the eight Perfectless abilities are REPORTED, not
  rewritten.** Both are authoring.
- **No ability magnitude moved.** §3 is text; §1 and §2 are instruments.


---

## §5 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html` and `docs/design-notes.md` all landed
**before** the run, because roughly 35 suites assert against the first three. `docs/state.md` and
this report are written after: no suite reads either, `check_de` reads neither, and the differ is
re-runnable in seconds over a log directory that already exists.

### THE PRE-BATTERY DEFENCES, ALL FOUR PAID

- **THE RETIRED-WORD SWEEP, USING `bx`'s OWN STRIPS.** `test_batch_bx` §4 keeps *beast* out of
  player-facing prose and §4b keeps *party* out; both read `master.html`. Run over the edited file
  now and at `HEAD`: **0 surviving occurrences of *party* either way, and 0 of *beast* with
  `Beastmaster` removed.** DU was caught by this sweep and DS took four reds from it.
- **THE LITERAL SWEEP: 12,694 literals at a floor of 4**, from all 82 suites, gates and fixtures,
  evaluated against every changed document and source and diffed against `git show HEAD` in one
  pass. **159 GAINED, 43 LOST — and the dangerous kind is ZERO**: every `not <doc>.contains(L)` in
  the tree (217 of them) was cross-referenced against the gained literals, with **no hits**. The 43
  LOST are the three deleted walk bodies (`"warrior"`, `"cleric"`, `"grant_ability"` and the rest)
  and prose inside the two rewritten `baselines.json` notes — **and nothing reads that file by
  literal**: `check_de` parses it as JSON, and `check_dp` and `test_batch_cd` only name it in
  comments.
- **THE COMMENT-STRIPPED DIFF WAS TAKEN AGAINST `HEAD`.** With every comment-only line stripped:
  `check_da.gd` **GAINED 53 code lines and LOST 0**; `gate_fixture.gd` **GAINED 46, LOST 0**; the
  three repaired walks lost their bodies and gained a delegation apiece; and **`scripts/classes.gd`
  is 1935 code lines before and after, with exactly ONE distinct line gained and ONE lost** — which
  is the proof that the two-site text repair really was those two sites and nothing was swallowed.
  `run_battery.sh` changed one line.
- **THE PARSE CHECK WAS GREPPED FROM STDERR AFTER EVERY EDIT**, never from the tally and never from
  the exit code.

### FOUR NEGATIVE CONTROLS, ALL FOUR BIT

| control | result | which assertions |
|---|---|---|
| `test_batch_cp._corpus()` **re-hand-rolled** | **2 / 2 / 2** | `check_da` (the accusation and the sweep), `check_dw` §0 (the delegation and the family marks), and the suite's own two populations |
| the smallest walk restored **+ `families < 2` → `< 3`** | **`check_da` 39/0 — CLEAN** | none. `check_dw` stays at **2** |
| Shadowrend's Perfect **diverged from Smite's, still fitting** | **exactly 1** | the divergence guard alone |
| a **void** function reading **both pool constants** added to a gate | **`check_da` 39/0** | none — no false positive on the widened convention axis |

**THE SECOND ONE IS THE ONE WORTH HAVING.** It is a single character, and it returns `check_da` to a
clean **39/0 with a 43-of-227 walk standing in the tree** — *the exact defect DV found, reproduced on
demand.* It proves two things at once: the threshold of two is load-bearing rather than decorative,
and **`check_dw` is not redundant with `check_da`**, because it stays red through it.

**THE THIRD IS DV's SHAPE** — a change no other assertion in the project would notice, agreeing with
the ceiling in every state the game can produce, failing exactly one check.

Every file was backed up to the scratchpad and **restored by `cp`, never by `git checkout`**, and
all eight md5s were verified identical afterwards.

### PREDICTED BASELINE MOVEMENT — AND THE BRIEF'S PREDICTION WAS THE WRONG ONE

Written into `baselines.json` **before** the run.

| row | predicted | read |
|---|---|---|
| `check_dw` | **NEW at 35 / 0** | **35 / 0** |
| `check_da` | **37 → 39** | **39 / 0** |
| `check_dv` | **128 → 130** | **130 / 0** |
| `check_de` (no row of its own) | **317 → 321**, four assertions for one new target | **321 / 0 / 0** |
| `test_batch_cp` | **no movement** (the brief predicted movement) | **697** |
| everything else | **no movement** | **none** |

**`check_de` READ ZERO NOTICES**, so not one check count in the tree moved outside its band.

### THE ACCEPTANCE BATTERY — ONE RUN, AND IT FOUND TWO REDS

| | DU's | DV's | **DW's** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 313 / 0 / 0 | 317 / 0 / 0 | **321 / 0 / 0** |
| targets in the manifest | 76 | 77 | **78** |

**SEVENTY-EIGHT TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-EIGHT. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log**, grepped from the streams rather than off a tally or an exit code.

#### RED 1 — `check_dv` §4, AND IT IS A DEFECT IN DV'S GATE RATHER THAN IN DW'S WORK

`ok(live_span == 16, …)` against a changelog that **gains an entry every batch**. DV's own
acceptance was the only run that could ever satisfy it. **DW is the batch it broke on, and DW's own
changelog entry is what broke it.**

**THIS IS CD §1's FAULT, WRITTEN A SIXTH TIME.** `state.md` already records the shape — a hardcoded
batch stamp that *"has to be hand-bumped every batch to keep passing"*, which **turned five suites
red at once at CJ**. It asserts a **FLOOR** now: the cut left 16 and entries are only ever added, so
an entry **vanishing** from the live file still fails, which is what the check is for. **The archive
keeps its equality at 149**, because that file only moves when a cut moves it — the difference
between an invariant and a batch number.

#### RED 2 — A SECOND UNSEEDED FLAKE, AND `state.md` SAID THERE WAS ONLY ONE

`test_run_harness` gate 2 failed on *"the walk crossed a event"*. **The standing record since DT was
that `test_batch_at` §1 is the last unseeded flake in the project. It is not.**

`test_run_harness.gd` calls **`seed()` zero times**. Gate 2 walks a randomly **generated** map by
taking `reachable()[0]` at every step and then asserts each of six node types was crossed at least
once; an unsteered greedy route can miss the rarest. **Observed once in 34 readings** — the battery,
plus 32 clean standalone re-runs and one earlier — so the rate is roughly 3%.

- **IT IS NOT DW's, AND THAT IS SHOWN RATHER THAN CLAIMED.** `test_run_harness.gd` is
  **byte-identical to `HEAD`**, and the batch's only change under `scripts/` is two `perfect_text`
  strings — proved by the comment-stripped diff at exactly one distinct line gained and one lost.
  Map generation cannot read them.
- **AND IT IS DELIBERATELY NOT SEEDED.** **One flake at a time is how the effect stays
  attributable** — DT's rule, the one that worked on `bo` — and `at`'s is still open. **The repair
  is known and it is DD's: seed the walk, do NOT widen the assertion**, because the six types being
  present is the question and relaxing it to five deletes the check rather than repairing it.
- Recorded in `baselines.json` as a band with its rate and its reason.

### THE TREE WAS FROZEN, AND THE TWO FILES THAT MOVED ARE ACCOUNTED FOR

**168 files were MD5-stamped before the run and re-compared after. TWO moved**, both edited *after*
the battery in response to Red 1: `check_dv.gd` (after which `check_dv`, `check_da` and `check_dw`
were all re-run, because `check_da` §3 and `check_dw` §0 read that file's source) and
`baselines.json` (read only by `check_de`, which was re-run over the same log directory — which is
exactly what it is built for). **166 of 168 did not move during the run.**

---

## §6 — DOCUMENTATION AND THE PUSH

`docs/changelog.html` (DW's entry), `CLAUDE.md` (one new standing rule and a rewritten
propagation-by-copy block), `docs/state.md` **rewritten**, `baselines.json` (three rows at
`indent=1`), this report, `docs/design-notes.md`, `docs/master.html` (the stamp), plus
`run_battery.sh` and the new `check_dw.gd`.

**AND `docs/state.md` HAD GROWN A HISTORY SECTION, WHICH ITS OWN HEADER SAYS MEANS IT IS WRONG.**
DV's rewrite left **DU's entire `WHERE THE PROJECT IS` block standing underneath its own** — a
second *"Next letter"* bullet (reading DV where the file elsewhere read DW) and a second *"Phase"*
bullet included. **Removed at DW.** Nothing in the tree asserts on that file, so it went unreported
for a batch, which is the argument for reading it rather than appending to it.

**THE KNOWLEDGE SYNC ROSE AGAIN: 156 files, 6.86 MiB**, against DV's 152 / 6.77. DV's cut was a
one-off and ordinary growth resumed. `docs/changelog.html` is 159.2 KiB and grows about 9 KiB a
batch, so CW's 400 threshold is roughly twenty-six batches away. **`CLAUDE.md` is 250 KiB = 3.56%**,
level with DV — CW's *"under 3% and roughly flat"* is met on the second half and missed on the
first, and **DG through DW have now all declined the prune**.
