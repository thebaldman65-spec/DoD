# Dawn of Decay — project guide for Claude

Turn-based party roguelike (Godot 4.7, GDScript). **`docs/master.html`
("DoD Master Document.docx") is the authoritative design reference** — keep it
updated alongside `docs/changelog.html` (the living changelog). The original
`../*.docx` concept docs are superseded by both.

## WHAT THIS FILE IS, AND WHAT IT IS NOT (STANDING, SET AT BATCH CW)

**THIS FILE HOLDS STANDING RULES ONLY — things that govern what a FUTURE session does.**
Nothing else. It was split at CW because it had been doing two jobs and doing both badly: it
had grown a narrative block per batch since the beginning, and the rules that actually bind
behaviour were buried among sixty of them. **A rule buried in a batch block is a rule about to
be forgotten**, and that is the whole reason for the split.

**THE TEST FOR A LINE IN HERE: does it tell a future session what to do or not do?** If it
describes what happened, it is not a rule and it does not belong here.

- **What happened** → `docs/changelog.html` (and `changelog-archive.html`).
- **Where the project is right now** — open queue, live counts, what is known-broken →
  **`docs/state.md`**, which is REWRITTEN every batch and never appended to.
- **What the game currently is** → `docs/master.html`.
- **Why a decision was made** → `docs/design-notes.md`.
- **What a given batch did** → `docs/reports/<CODE>.md`.
- **How a batch VERIFIES itself** — the suites, the gates, the battery, `baselines.json`, the
  negative controls and the sweeps → **`docs/instrument-rules.md`**, split out of this file at
  EF §2. **This file stays the required read**; that one is the reference it points at.

**DO NOT ADD A BATCH BLOCK TO THIS FILE.** If a batch learns something that binds future
work, add or amend a RULE here in the file's own voice — dateless, batch-agnostic, stated as
an instruction. Cite the batch that set it in parentheses for provenance, and stop there.
**Target: this file stays under a stated CEILING IN KiB — see the ceiling block below.** It is
not measured as a share of anything, and it does not state its own live size: writing that number
into this file changes it.

## THE INSTRUMENT RULES LIVE IN `docs/instrument-rules.md` (STANDING, SET AT EF §2)
> **THIS FILE IS THE REQUIRED READ. `docs/instrument-rules.md` IS A REFERENCE IT POINTS AT, AND IT
> IS OPENED WHEN A BATCH BUILDS, REPAIRS OR RUNS AN INSTRUMENT.** There are not two files a batch
> must read: **every rule about what the GAME may contain is in this file**, and the tiebreak below
> runs one way only.

- **THE SEAM IS WHAT A RULE BINDS, NOT WHAT IT IS ABOUT.** A rule that governs how a batch VERIFIES
  itself — a suite, a gate, the battery, `baselines.json`, a negative control, a sweep, a census, or
  an operation on a tracked document — is in `docs/instrument-rules.md`. A rule that governs what
  the game may contain is here. **WHERE A RULE DOES BOTH, IT STAYS HERE.**
- **THE SPLIT IS THE CEILING BLOCK'S OWN PROCEDURE, TAKEN EARLY ON PURPOSE.** The seam was measured
  before the ceiling was near, and **a seam is cleaner measured than reached** — a split taken under
  a ceiling is a split taken in a hurry.
- **NOTHING WAS REWRITTEN AND NOTHING WAS PRUNED.** Every moved block is byte-identical to what
  stood here, the two halves were asserted to re-concatenate byte for byte, and **every suite whose
  pin moved was re-pointed in the same batch** — CW's split discipline, unchanged.
- **WHEN A NEW RULE IS WRITTEN, IT GOES IN ONE FILE AND IS NOT SUMMARISED IN THE OTHER.** A summary
  is a second copy of a rule, and **a second copy is what let this file contradict itself 1900 lines
  apart after CW's split** — DL found that contradiction four batches later. The list below is an
  INDEX of headings, not a restatement of anything.
- **AND THE INDEX IS HEADING TEXT, SO A PIN CAN BE SATISFIED BY IT. PIN A MOVED RULE AGAINST THE
  FILE THE RULE LIVES IN.** `contains("AN INSTRUMENT'S TERRITORY IS A CLAIM")` against THIS file
  passes off the row below while the rule itself could have been deleted — **a check that has
  stopped asking its question**, which is the CW/CD fault arriving through an index instead of
  through prose. **`check_ec` §2's own two needles are pinned against `docs/instrument-rules.md`
  for exactly that reason**, and every document instrument scopes a pin to the file it names.

**WHAT IS OVER THERE** — twenty-six blocks in twenty-four entries, in the order they stood
here; the two `###` children of the equality rule travel with their parent:

| | |
|---|---|
| AN INSTRUMENT'S CORPUS MUST NOT CONTAIN WHAT THE INSTRUMENT REWRITES | EE §2 |
| THE CHANGELOG IS ARCHIVED ON A SCHEDULE | CW §4 |
| ON A SPLIT-CLAUSE CARD, EVERY PIN NAMES THE CLAUSE IT PINS | DM §2 |
| A SUITE MUST NOT PIN THE SAVE VERSION LITERAL | BK §6 / CT |
| THE BATTERY IS A SCRIPT NOW | CP §1 |
| THE COUNT DIFFER IS A PROPERTY OF THE RUN, NOT OF A SUITE IN IT | DE |
| NEVER ASSERT AN EQUALITY AGAINST A COLLECTION THAT GROWS *(+ the staleness-tripwire exemption, and repair to a floor)* | DX §1 |
| PIN THE RULE, NEVER THE BATCH CODE | EA §2 |
| A SWEEP ASSERTS ITS OWN POPULATION | EA §5 |
| A GROUP OF LITERALS IS EVALUATED AS THE OPERATOR JOINS IT | EC §1 |
| AN INSTRUMENT'S TERRITORY IS A CLAIM | EC §2 |
| A SCAN THAT CAPTURES A WINDOW IS BLIND TO WHAT THE WINDOW SWALLOWED | ED §2 |
| A COMMENT NAMING CODE IS A CLAIM, AND IT GOES STALE SILENTLY | EB §2 |
| ARM A NEGATIVE CONTROL ON A NEEDLE A SUITE DEMONSTRABLY READS | EB §3 |
| WRITE THE PREDICTED BASELINES BEFORE THE VERIFICATION RUN | DF |
| WHAT A METER MEASURES IS NOT ALWAYS WHAT THE REPORT SAYS IT MEASURES | CZ §2 |
| A STALE ASSERTION IS REPAIRED TO INTENT, NEVER DELETED | CQ §3 / DC |
| A HELPER COPIED BETWEEN GATES INHERITS ITS BUGS AND DIVERGES SILENTLY | DA §3 / DB §1 |
| A FINGERPRINT INSPECTS A POPULATION AND A CONVENTION | DW §1 |
| GATES THAT PASS WITHOUT ASKING THEIR QUESTION | CW §1 |
| THE master.html STAMP GATE | CW §1 |
| SUITES AND THE HARNESS | CW §1 |
| Verify before shipping *(the battery, the gates, the sim, the run harness)* | CG onward |
| A NUMBER QUOTED FROM ONE DOCUMENT INTO ANOTHER STOPS BEING A MEASUREMENT | DJ §3 |

## Working agreement (user's standing rules)
- User is a beginner coder: explain plainly; Claude writes all code; user is
  the designer + playtester. Iterate on their feedback each session.
- EVERY design change: (1) update `docs/master.html` (current truth) and bump
  its "Last updated" timestamp; (2) add an entry to `docs/changelog.html`
  (newest first); (3) rebuild both docx via `python3 docs/build_docs.py`
  (unwraps paragraphs — plain textutil makes Word spacing weird; exports are
  Arial size 14 by user preference); (4) append a short "why" entry to
  docs/design-notes.md — rationale only, not instructions.
- master.html shows ONLY what is currently in the game (user rule 07-20):
  no vault lists, no "was/now/moved/reworked/renamed" notes, no decision
  dates — change history belongs in changelog.html alone.
- Terminology: damage against the Break meter = "Break damage (BD)" everywhere.
- **A SUITE'S CHECK COUNT CAN DRIFT, AND A DRIFTING SUITE IS RECORDED AS A BAND, NOT A NUMBER.**
  A suite that walks generated content has a count that is a function of what it rolled, and
  **a count-diffing rule reads a drift as a regression.** **The live counts and bands live in
  `baselines.json` — ONE machine-readable file, and the only one. `check_de` reads it; neither
  this file nor `docs/state.md` restates it, they point at it.**
  - **A BAND ALSO CARRIES THE NUMBER OF OBSERVATIONS BEHIND IT (STANDING, DE §1).** A band is a
    claim about a distribution nobody has characterised, and **the number of readings behind it is
    part of the claim.** **A band written to a sample's exact extremes is exceeded by roughly two
    runs in eleven**, so: **floor = the lowest observation; ceiling = the highest PLUS the observed
    spread.** It is asymmetric because **the floor is the half that catches a real fault** — a
    section that stopped running costs hundreds of checks, not five. **Widen where a reading
    demands it and nowhere else**, so every number stays traceable to a run.
- **A FLAKY ASSERTION IS A THIRD KIND OF INSTABILITY AND IS NOT A DRIFT.** A suite whose COUNT is
  rock steady can still fail by chance when an assertion compares two damage rolls that can land
  on the same integer. **A bare `<` or `>` between two blows is not a check, it is a coin flip
  with good odds.**
  - **A RATIO WITH A MARGIN IS NOT THE ANSWER ON ITS OWN, AND COMPUTING THE PROPAGATED NOISE
    FIRST IS (STANDING, DE §4).** The first line of the strike block is `randf_range(0.9, 1.1)`,
    so **one blow carries ±10% and a RATIO of two carries up to 22%.** **A margin only works if it
    is WIDER than the noise it sits on. Do that arithmetic before choosing the band, not after
    the flake.** If the propagated noise is wider than the band the question needs, **THE BAND IS
    NOT AVAILABLE**: seed the pair and assert exactly.
  - **SEED THE PAIR, NOT THE SUITE.** `seed()` the same value immediately before EACH blow of a
    compared pair, so both draw the same variance and the only thing left between them is what is
    under test. **Where the check averages a LOOP of pairs, vary the seed per iteration**
    (`seed(base + i)`) or the averaging that makes its band meaningful collapses into the same
    measurement N times. **Where a GENERATED WALK is the subject, seed at every generation** —
    the guarantee is per-BOARD.
  - **THE BAND IS THE QUESTION. DO NOT WIDEN IT TO SWALLOW A FLAKE** — that deletes the check
    rather than repairing it.
  - **A SOURCE SWEEP CANNOT FIND A FLAKE, IN EITHER DIRECTION (STANDING, MEASURED AT DX §2).**
    **`seed()`-count is not evidence**: twenty suites and gates make unseeded draws and are
    perfectly stable, and a suite can call no RNG function at all while flaking on
    `battle.gd`'s own roll, which no sweep of the suite tree can see. **ONLY READINGS FIND A
    FLAKE, AND THE READINGS ARE IN `baselines.json`** — the rows carrying a `flake` field are the
    answer to "how many are there", and nothing else is.
  - **CHARACTERISE A FAILURE BEFORE NAMING IT.** A flake recorded as one thing at one rate has
    twice turned out to be a different thing at a different rate once it was measured at scale.
  - **A KNOWN FLAKE IS A PLACE A SECOND RED CAN HIDE (STANDING, FOUND AT DE §6).** A row banded
    `0–1` "for the known flake" hid a DETERMINISTIC failure at its floor for batches, because the
    band happened to admit the observed value and nothing ever contradicted the label. **WHEN A
    SUITE IS EXCUSED BY A KNOWN CAUSE, CHECK THAT THE RED IN FRONT OF YOU IS THAT CAUSE.**
  - **A BAND WIDE ENOUGH TO COVER A GENUINE FAILURE CANNOT REPORT ONE (STANDING, SET AT DF §0).**
    **A band is for a count that legitimately varies. It is never a place to admit a red.** The
    moment a floor is set above zero to stop a known failure from shouting, the row has stopped
    being a measurement and become an excuse — and **the one thing it can no longer do is tell you
    the failure is still there**, nor that a second has arrived beneath it. **A FAILURE COUNT'S
    FLOOR AND A CHECK COUNT'S FLOOR ARE NOT THE SAME KIND OF NUMBER**: a failure floor is a promise
    that exactly that many reds are known, named and deliberate, so it belongs in `baselines.json`
    **with the reason written beside it**, and a band around it is only ever a FLAKE's
    contribution, never a deterministic red's.
- **THE BATTERY'S COUNT GREP MUST MATCH EVERY SHAPE A SUITE PRINTS.** Three are in use:
  `checks: N   failures: N`, `BATCH XX: N passed, N FAILED`, and `N checks`. A count-diffing rule
  cannot see a regression in a suite whose count reads `?`, so a too-narrow grep is a blind spot
  that looks like coverage. This was found and fixed three separate times.
- **THE PARSE FLOOR COVERS EVERYTHING THE BATTERY SPAWNS, AND ITS POPULATION IS DERIVED FROM
  `run_battery.sh` RATHER THAN FROM A LIST OF DIRECTORIES (STANDING, WIDENED AT EI §1).**
  `check_parse` walks the battery's own `SUITES` and `GATES` arrays, every literal `--script`
  target, every `run_one`, every scene run, the transitive `preload` / `ext_resource` /
  `change_scene_to_file` closure of all of them, `project.godot`'s autoloads and main scene, what
  is left of `scripts/` and `scenes/`, and `res://data/*.json`. **A target added to the battery is
  covered the same day, without editing that gate.**
  · **A DIRECTORY LIST IS WHAT WENT STALE, THREE SEPARATE TIMES**, and the third one is the reason
    this rule is here: `gate_fixture.gd` was briefly broken and **the floor procedure every
    implement-only batch runs — grep stderr for `Parse Error` — came back CLEAN while 23 gates
    could not load**, because the repo ROOT was outside the walk. **DO NOT NARROW IT BACK TO A
    DIRECTORY**, and do not add a population by naming its folder.
  · **THE GATE MUST NOT `preload` ANYTHING.** A floor that preloads `gate_fixture.gd` cannot report
    that `gate_fixture.gd` is broken — it fails to load itself, prints a Parse Error, runs not one
    line and **exits 0**. The gate that checks the fixtures must not be one of the files that
    depends on them.
  · **ITS CHECK COUNT IS ITS COVERAGE AND THE FLOOR IS ASSERTED.** A failure total reads zero
    whether the walk covers 158 files or 41, which is exactly how it was short three times without
    anything going red. A FALL in that count is an error; a RISE is a notice telling the next batch
    to record the number in `baselines.json`.
  · **AND STILL GREP THE STREAM.** The tally is a ratchet on coverage, not the verdict. A data-file
    JSON error is the one population the engine says nothing about, so the gate prints that one to
    stderr naming itself a `Parse Error` — the floor procedure is one procedure.
- **A FOLD, A RENAME OR A REFACTOR THAT CHANGES A MAGNITUDE IS A DESIGN CHANGE. IT GOES TO THE
  DESIGNER AS A REPORT AND IS NEVER APPLIED ON THE BATCH'S OWN JUDGMENT (STANDING, SET AT BATCH
  CQ §6).** The rule exists because of CN §3: removing the timing bar from 113 abilities orphaned
  their Perfect bonuses, and folding each one into its base effect was mechanically correct and
  locally reasonable at all **105** sites — an orphaned bonus genuinely has nowhere else to go.
  It still **moved 105 magnitudes nobody chose**, **undid one explicit decision** (Elevation: the
  designer picked 2 Faith with a raised cost over 3 at CG, and the fold made it 3), and
  **converted eighteen timed buffs into permanent ones** by pushing their duration to or past
  their own cooldown — a class of change that is invisible in a diff of magnitudes.
  **THE BATCH THAT FOLDS IS THE ONE LEAST ABLE TO SEE THIS**, because each individual fold looks
  like tidying; only the census shows the size of it. Report every one, revert only where the
  change overwrote an explicit, recent decision, and leave the rest for the designer.
- **"IS THERE ANYBODY THERE TO PRESS?" IS ONE QUESTION, ASKED IN ONE PLACE (STANDING, CQ §1).**
  `battle._nobody_can_press()` is `sim or autoplay or DisplayServer.get_name() == "headless"`.
  `sim or autoplay` names the two BOTS, **not the absence of a player**: a hand-driven suite is
  neither, because it sets `Run.active` and clears `sim`/`autoplay`/`sim_run` precisely to get
  the real battle path. Four suites (al, bp, br, bw) hung for five batches on
  `_defensive_brace`'s `else` branch awaiting `_skill_done` — a signal only a key press emits —
  at zero CPU, mid-battle, which is hang mode (1) below. **A Profile flag is not a bot guard**
  either: `check_cm_live.gd` set two by hand, which is one file knowing about the trap.
- **ALL PLAYER-FACING TEXT IS WRITTEN TO `docs/text-standard.html` (STANDING, SET AT BATCH CJ).
  EVERY BATCH FROM CJ FORWARD, INCLUDING TUNING THAT COMES OUT OF PLAYTESTING.** Ability
  `description` and `perfect_text`, `passive_desc`, status/chip text, talent nodes, runes,
  relics, glossary, and master.html's tables. The load-bearing rules:
  · **~~TWO TIERS~~ — SUPERSEDED AT BATCH CL §1. DO NOT APPLY IT.** The rule was: draft screen
    and glossary may show percentages and formulas, everywhere else may not, because mid-combat
    surfaces could not show arithmetic. **CL DELETED THE SPLIT by removing its premise** — a
    percentage is now followed by its computed value in parentheses (`20% of maximum health
    (34)`) on every surface, so the player is never asked to compute anything AND the formula
    stays visible so scaling stays legible. One rule, everywhere. `text-standard.html` §1 was
    REWRITTEN rather than appended to, on the brief's instruction: a superseded rule left in
    place is how BY's "quote only gates 1 and 3" survived twelve batches. **This bullet is kept
    only as a pointer, because the two-tier phrasing outlived its own deletion here for three
    batches** — it is the thing to check when a rule looks like it contradicts the standard.
  · **THE PARENTHETICAL IS COMPUTED AT RENDER TIME AND NEVER AUTHORED (STANDING, CL §1).**
    `Classes.resolve_values` expands a token; **a literal digit inside parentheses in any
    authored field is a defect**, because typing one creates a second copy of a number that can
    drift from the code — the exact failure `text-audit.html` exists to catch. Four resolution
    cases: a *final* percentage resolves to the resulting TOTAL **on chips only**; volatile
    stats resolve live and are allowed to move between reads; where there is nothing to resolve
    against (glossary, a draft card with no target) the percentage stands alone with **no
    placeholder and no dash**; and resolution follows **the owner the prose names**, which is
    why §4.2's name-the-owner rule has to be right before the wiring is.
  · **The player must never be asked to do math while choosing an action.** This half of the
    old rule SURVIVES CL and is the reason the parenthetical exists. The battle tooltip already
    computes damage/BD/cooldown/initiative/Perfect, so a description restating them in
    arithmetic is still a second copy of a number the renderer has.
  · **NO DESIGN RATIONALE ON A CARD, EVER — it goes in `changelog.html`.** Flavor is welcome:
    ONE short clause, mechanically empty, removable. If it could be mistaken for a rule, cut it.
  · **No pronouns** ("Loses 20% of current health", not "he loses"/"you lose"). **Always name
    whose percentage.** **`(Perfect: X)`, the value alone.** **Keywords capitalised — Break
    matters most.** **Never a bare "3 turns"** (duration vs cooldown). **State what a second
    cast does** whenever one is possible.
  · **LINE CEILING 44 CHARACTERS, MEASURED not guessed** (Open Sans SemiBold at font 11 in the
    258px draft card; 45 is where it overflows). **The ability corpus already holds it, 936/936
    lines — do not "fix" it.**
  · **`\n` IS LOAD-BEARING IN TOOLTIPS AND MUST NOT BE STRIPPED THERE.** Nothing overrides
    `make_custom_tooltip`, so Godot's default tooltip does NOT autowrap — strip the breaks and a
    322-char description renders ~2000px wide. The no-`\n` rule applies TO `passive_desc` (it
    renders in an autowrapping 400px label, where 23 of its 67 lines overflow); removing them
    from ability descriptions needs a custom tooltip FIRST, which is a code batch.
  · **THE CODE'S FIELD IS AUTHORITATIVE — master.html is corrected toward it, never the reverse.**
    **THE TWO ARE NOT THE SAME STRING: of 120 draft ability rows in master.html, ZERO carry the
    code's sentence** (independently authored, median 3.0x longer). **Do not calibrate "how the
    cards read" from master.html — it is text no player has ever seen.**
  · **AND WHEN A CLAIM OF FACT IS CORRECTED, SWEEP FOR EVERY COPY OF IT — THE DOCUMENT IS ONE
    SURFACE OF THREE (Batch EH §2).** BP corrected *"Guard Change is the only stance swap in the
    game"* in `PROTECTED_CORES`'s `why` and left the identical sentence **twice in `master.html`
    and once in a `classes.gd` comment one screen above the line it fixed**, where all three sat
    for nineteen batches. **`master.html`'S FACTUAL PROSE IS ASSERTED BY NOTHING**, proved by a
    two-armed control at EH: putting the false sentence back leaves all five of its readers green,
    while breaking a literal a suite demonstrably reads turns `test_batch_ah` red. **A false claim
    in that document does not decay and is not caught; it is only ever found by someone looking.**
  · **A SECTION BEING CURRENT IS NOT EVIDENCE THAT THE SECTION ABOVE IT IS.** EH found `master.html`
    §6b fully swept for EG's slot ladder and the bench, and **§6a — fifty lines up, describing the
    same mechanism — still saying "There is no cap and no swap step" and "a full run ends at
    core + 3 + 2 = 6 abilities", which BO §2 made false**. A batch sweeps the section it is writing
    in. **Sweep for the MECHANISM across the document, not for the section you edited.**
  · `docs/text-audit.html` is the REPORT of what is currently non-conforming, in three buckets,
    and **IT NOW HOLDS TWO PASSES**: Batch CJ's over abilities, runes, statuses and the length
    ceiling, and **§CK at the foot** over the 93 glossary entries, all enemy text and all event
    text. **Bucket 1 first: polishing the grammar on a wrong description makes it read more
    confidently while staying wrong.**
    · **CJ'S TWO BUCKET-1 ITEMS ARE BOTH CLOSED BY BATCH CK, AND SO IS ITS LARGEST BUCKET-2
      ITEM.** (1) **The Warrior ability is `Ironclad` now, not "Iron Will"** — the name its own
      status id always carried; **the WARDEN TALENT keeps `iron_will` and keeps the name Iron
      Will**, and master.html §4.6 carries two rows where it carried one. **Do not "restore" Iron
      Will to the ability; the collision is what was fixed.** (2) **Battle Shout's registry
      fallback carries NO NUMBERS** — stripped rather than corrected, because there is no single
      number that is right across nodes 0/1/2. **Do not put a magnitude back into it.**
      (3) **The draft card renders the computed block** — see the CK §1 standing reference below.
    · **§CK's OWN bucket 1 is OPEN and is a design question**: the end boss's `Regalia` cannot be
      cast and its description names the wrong mechanic (carried in `docs/state.md`'s open queue).
- `addendum.html` is RETIRED (frozen history; do not update it). **Batch BZ MOVED IT OUT OF THE
  REPO** to `/Users/zipples/Documents/DoD-archive/addendum.html`; it is no longer `docs/addendum.html`.
- User drops new assets in `../imported files/` — always check there.
  New character sprites need the Soldier format: 100x100 frame strips named
  `Name_Idle/Walk/Attack01-03/Hurt/Death.png`.
- Commit AND PUSH (origin/main) after each change batch. Launch the game for playtesting via
  `/Applications/Godot.app/Contents/MacOS/Godot --path <this dir>` (background,
  watch stderr for errors).

## EVERY BATCH WRITES ITS REPORT INTO THE REPO (STANDING, SET AT BATCH CW §3)

**`docs/reports/<CODE>.md`, committed with the batch.** Same content as the chat summary — what
shipped, what was measured, what was found and not fixed, what needs a ruling — but committed,
so it arrives through the knowledge sync instead of being hand-copied into a chat window.

- **THE COPYING IS WHAT THIS REPLACES, AND IT HAD ALREADY LOST THINGS.** CL's overflow
  measurement was written into `text-standard.html` §4.8 and then reported as missing. **A report
  that says something is absent when it is present is harder to catch than an absence** — nobody
  goes looking for a thing they have been told is not there.
- **THE FILE IS THE REPORT, NOT A SUMMARY OF IT.** Do not write a short version here and a long
  version in chat. If it is worth telling the designer, it goes in the file.
- **A RULING THE BATCH NEEDS GOES UNDER ITS OWN HEADING**, so the designer can answer without
  reading the rest.
- **RETROFIT NOTHING.** Reports written before CW stay where they are.

## THIS FILE IS MEASURED IN KiB, AND THE CEILING IS 290 KiB (STANDING, RULED AT EE §1)
> **`CLAUDE.md` IS MEASURED AS A SIZE, NEVER AS A SHARE OF THE SYNC, AND THE CEILING IS 290 KiB.**
> **When it is reached the answer is a SPLIT. It is never a prune.** The 3%-of-sync target this
> replaces is retired: three readings killed it and all three are recorded below, so nobody derives
> it again.

- **A TARGET YOU CAN MEET BY COMMITTING AN UNRELATED FILE IS NOT MEASURING DENSITY.** ED cleared 3%
  **without removing a byte** — the file GREW that batch — because the denominator grew, and 296 KiB
  of that growth was the pin manifest ED itself added. The numerator is inside the denominator, so
  writing a rule moves both; **the share was never a property of this file.**
- **AND THE PRUNE HAS NOW FAILED TWICE, MEASURED.** DZ cut **51.18 KiB** at the cost of a whole
  batch and the ratio was back over target **two batches later**. ED then read every never-cited
  block and retired **NONE** — zero dead rules, zero surviving narrative, two stale NAMES repaired.
  **There is no dead weight to cut, and that has been tested rather than judged.**
- **NEVER-QUOTED IS NOT DEAD.** "Neither asserted nor quoted" is a fact about citation, not about
  load. **Nobody quotes the rule they are obeying**, so a well-obeyed rule and a dead one produce
  identical evidence under a citation count. **Do not prune this file by a reference count.**
- **THE 290 KiB IS DERIVED, NOT CHOSEN.** The FLOOR is measured: DZ's prune produced **210.59 KiB**
  with the narrative gone, and everything added since has been tested live. The HEADROOM is measured:
  the largest single-batch growth on record is **+8.09 KiB**, and **a ceiling within one batch's
  reach fires on whoever writes the big batch rather than on the file's condition**, so it is ten of
  those. 210.59 + 80.90 = 291.49, **stated as 290 and rounded DOWN** — a ceiling above its own
  derivation is one nobody trusts.
- **THE PROCEDURE AT 290 KiB IS A SPLIT, AND IT HAS BEEN TAKEN ONCE (EF §2).** A ceiling in KiB is a
  ceiling on the READ, not on how many rules the project may hold — **splitting caps the read
  without capping the rules, and pruning caps the rules, which is why it was always the wrong
  instrument.** The instrument seam was the cut taken; the seven `STANDING REFERENCE` blocks are
  the one still available. **Take CW's split discipline with it**: both halves name each other by
  path, every suite whose pin moved is re-pointed in the SAME batch, and the halves are asserted to
  re-concatenate byte for byte.
  · **TAKE A SPLIT AT A MEASURED SEAM, NOT AT A REACHED CEILING (STANDING, EF §2).** EF split at
    52.50 KiB of headroom rather than at zero. **A seam is cleaner measured than reached**, and a
    split taken under a ceiling is a split taken in a hurry — which is the same argument that made
    the prune the wrong instrument.
- **THE 290 KiB BINDS THIS FILE, THE REQUIRED READ — AND ITS DERIVATION NOW COVERS TWO FILES.** The
  FLOOR term was measured on a file that still held the instrument half, so **290 is conservative
  for this file alone: it fires later than its own derivation would, never earlier.** Re-deriving it
  per half is a RULING and EF did not take it; the arithmetic for both halves is in
  `docs/reports/EF.md` §2. **`docs/instrument-rules.md` is under the same procedure and has no
  stated ceiling yet.**
- **DO NOT STATE THIS FILE'S LIVE SIZE IN THIS FILE.** The live reading belongs in `docs/state.md`
  and the batch report. **A file that records its own size changes it by recording it**, which is
  the same shape as *an instrument's corpus must not contain what the instrument rewrites*, in
  `docs/instrument-rules.md`.

## Repo weight and the knowledge-base sync (STANDING — BY, ACTED ON AT BZ AND CW)
**The number that matters is not the repo, it is the TEXT.** Most of the repo is `assets/` —
mp3/wav/png/ttf that a knowledge-base sync does not ingest. **The sync is the only figure to
watch. Live sizes and percentages live in `docs/state.md`, not here** — they move every batch.

- **THE REPO IS NOT CARRYING DEAD WEIGHT — IT IS CARRYING ITS OWN HISTORY.** BY audited all 219
  tracked files and found exactly ONE dead file, a `.DS_Store`. **That is why every saving since
  has come from moving history out, never from deleting anything.**
- **DO NOT ARCHIVE THE TEST SUITES, AND DO NOT DELETE THEM FOR SPACE.** They are the single
  largest block in the sync and **they must be in the repo to run.** Each encodes decisions in
  assertion form — suites have been re-pointed in place *with their reason* precisely so a later
  batch could not quietly reverse a decision. **Written down before someone proposes deleting
  them.** They can be DESELECTED from the sync (see below); that is a different act.
- **THE SUITES DO NOT NEED TO BE IN THE KNOWLEDGE SYNC — CLAUDE CODE READS THEM OFF DISK.**
  Anything that only Claude Code ever opens is a candidate for deselection in the connector's
  file picker: the suites, `docs/build_docs.py`, the archived changelog, and any audit document
  whose findings have been ruled on and applied. **Deselecting is not deleting and does not touch
  the repo.**
- **A DERIVED FILE IS THE BEST DESELECTION CANDIDATE THERE IS, AND `pin-manifest.json` IS ONE
  (EE §3).** It is generated by `build_pin_manifest.py`, enforced by `check_ed` off disk every
  battery, and **the design instance has never read it**. Nothing is lost by regenerating it, which
  is the property the suites do not have. **It stays in the repo and the gate goes on reading it.**
  **A generated artefact belongs in the repo and not in the sync**, and adding one to the sync used
  to be a way to satisfy a ratio — which is half of why that ratio is retired.
- **WHAT MUST STAY SELECTED:** `CLAUDE.md`, **`docs/instrument-rules.md`**, `docs/state.md`,
  `docs/changelog.html`, `docs/master.html`, `docs/design-notes.md`, `docs/text-standard.html`,
  `docs/reports/`, and the game scripts — `battle.gd`, `unit.gd`, `classes.gd`, `talents.gd`,
  `run_state.gd` and the screens. **A SPLIT ADDS A FILE TO THIS LIST, NEVER REMOVES ONE FROM THE
  SYNC** — the rules did not stop being rules by moving.
- **THE TEST SUITES ARE AT THE REPO ROOT, NOT IN `scripts/`.** `scripts/` is game code and stays
  selected in full. **Deselecting "the scripts folder" would drop `battle.gd` and keep every
  suite — the exact inverse of the intent.** Check a path before acting on a size figure.
- **`scripts/battle.gd` IS THE LARGEST FILE IN THE PROJECT AND IS NOT A SYNC PROBLEM THAT CAN BE
  SOLVED**, because it is read constantly. **Recorded as a CODE-HEALTH observation: a file that
  size wants splitting eventually, and doing it deliberately is far cheaper than doing it when it
  becomes unworkable.**
- `addendum.html` is RETIRED (frozen history; do not update it) and lives in the archive folder,
  not in `docs/`.
- **THE SHARE OF THE SYNC IS NOT A TARGET AND IS NOT TRACKED (RULED AT EE §1).** `CLAUDE.md` is
  measured in KiB against a stated ceiling — see the ceiling block above. **The sync figure is still
  worth WATCHING**, because it is what the connector ingests; it is simply not a budget any file is
  held to. Live sizes stay in `docs/state.md`.

## The skill check — FOUR CASES, AND THE BAR IS PARAMETERIC (STANDING, SET AT CM, CN AND CS)
`docs/master.html` §4.2 documents all four cases: the normal check, the gated check, the
defensive check, and the Sharpshooter's SEQUENCE. **They share ONE bar and ONE set of zones, and
those are a PROFILE rather than constants.**
- **THE DEFAULT PROFILE IS AUTHORITATIVE, NOT A FALLBACK.** `battle.SC_PROFILE_DEFAULT` is what
  every caller uses except the Sharpshooter's basic attack. **A LATER BATCH THAT EDITS A VALUE
  THERE CHANGES EVERY CHECK IN THE GAME AT ONCE.** `check_cn.gd` asserts the values AND THE FIELD
  COUNT, and asserts that the zone rects and grade boundaries the profile produces are the ones
  the pre-CN formulas drew. **The live values are in `docs/state.md`.**
- **`centre` IS WIRED AND UNUSED; `presses` > 1 IS THE SHARPSHOOTER'S BASIC AND NOTHING ELSE.**
- **THE ZONE RECTS ARE RESIZED PER CAST** (`_apply_sc_profile`), not built once at UI setup.
  Grading and drawing come off the same dictionary on the same line of execution — split them and
  a profile that widens the window grades one thing and draws another, and **the player would be
  aiming at a lie.**
- **A WIDENED WINDOW IS INVISIBLE TO EVERY INSTRUMENT THE PROJECT OWNS**, because the bot never
  runs the bar — it rolls a grade off hardcoded probabilities.

### THE RULE EVERY PROFILE IS AUTHORED TO (STANDING, SET AT CN, BINDING ON CO)
> **VARY THE CHARACTER, HOLD THE DIFFICULTY CONSTANT.** A profile expresses a spec's identity,
> not its difficulty. **The Perfect window is authored as a FRACTION OF SWEEP TIME, not as a
> fixed width** — so a fast narrow bar and a slow wide one are exactly as hard to land while
> feeling nothing alike. **A spec whose bar is genuinely harder is a spec a player can lose
> access to through no fault of their build**, which is the failure mode that sank timed hits in
> Legend of Dragoon and Mother 3.
>
> **TWO DELIBERATE EXCEPTIONS, BOTH OPT-IN:** the **Sharpshooter**, whose bar is meant to be
> harder and to pay more, and the **relic that swaps a hero's bar for a riskier one while held.**
>
> **THE SHARPSHOOTER'S EXCEPTION IS SPENT, AND IT IS A FIXED OFFSET RATHER THAN A SLOPE:** 15%
> less timing tolerance than everybody else's, the same 15% at one press and at four. Harder than
> everyone else's, not harder the better you play. **It is taken against `SC_PROFILE_DEFAULT` in
> `_sharpshooter_basic_profile` rather than written as a literal**, so it survives a change to the
> default as an offset.

### WHERE THE CHECK COMES OFF (STANDING, SET AT BATCH CN §2)
**`Ability.runs_skill_check()` is the ONE answer**, asked by the cast path and by the draft card
alike. **The live population is in `docs/state.md`.**
- **THE CRITERION IS MECHANICAL: remove the check wherever the grade multiplier has nothing to
  multiply.** No damage and no Break damage means the Perfect and Sloppy multipliers both resolve
  to nothing.
- **THE FIELDS ALONE ARE NOT THE CRITERION, AND THIS IS THE TRAP CN FOUND.** Half the corpus does
  its work inside a `special` handler, so `damage: 0, pressure: 0` is TRUE of Feint, Guard Change,
  Kill Command, Harvest and others that hit hard. `Ability.DAMAGE_SPECIALS` names the handlers
  that actually resolve damage or BD; **a field-only test would have stripped the bar off every
  one of them.**
- **ONLY THE BASE EFFECT COUNTS.** A handler whose only damage sits inside `if is_perfect` is
  caught — that branch is the orphaned bonus, not a reason to keep grading.
  · **AN ORPHANED BONUS IS REMOVED OR FOLDED, AND THAT IS A SECOND QUESTION.** **THE CRITERION
    DECIDES WHETHER AN ABILITY GRADES; IT DOES NOT DECIDE WHAT AN ORPHANED BONUS BECOMES.**
    Folding one in handed a card a free extra enemy attack with no natural gate, acquired by
    accident.
- **FOUR OVERRIDES.** **Heals keep their check** (`Ability.HEAL_SPECIALS`, an authored list
  because "is this a heal" is a question about the card — Renewal heals through a status, so
  nothing heals at cast time and a purely mechanical read would take its bar away while HEAL
  beside it kept one). **Shields lose theirs.** **Pure debuff appliers lose theirs** — the grade
  has never affected whether a status lands. **Break damage counts as something to multiply**, so
  an ability with BD and no HP damage KEEPS its bar.
- **A GATED ABILITY ALWAYS KEEPS ITS BAR.** **An ability whose Sloppy loses the cast cannot lose
  the check that produces the Sloppy**, and obeying the bare criterion there would have deleted a
  feature in silence.
- **BASIC ATTACKS RESOLVE AT A FIXED GOOD, EXCEPT THE SHARPSHOOTER'S.** Read off **slot 0** and
  off the **hero's passive**, not off a name: his basic IS Quick Shot, the same object two other
  specs carry, so there is no card to flag.
- **THE NO-CHECK TEST SITS ABOVE THE AUTOPLAY ROLL AND THAT ORDER IS LOAD-BEARING.** Leave the
  bot's Perfect roll on top and it rolls Perfects nobody can press for, **every folded bonus gets
  paid twice in a sim**, and the balance numbers stop describing the player's game.
- **CLEAR `perfect_text` / `perfect_id` WHEREVER A BONUS WAS FOLDED**, or the draft card
  advertises a bonus that can never fire.
- **NOTHING IS CONSUMED UNTIL AFTER THE GRADE**, so a gated failure is the existing cancel path
  with the turn spent instead of returned. **Neither gated feature has or needs a refund path** —
  "refund the resource" is undefined for a card that eats an enemy's meter or a companion's.
- **`_grade_skill_check()` TAKES NO ARGUMENTS AND MUST NOT LEARN WHICH ABILITY IT IS GRADING.**
  The caller knows; the flag is tested at the call site. `_run_skill_check`'s `mode` argument names
  *what* is being graded ("" / "gated" / "defensive") and picks only the top line, the tint and
  which orientation card is owed.
- **STANDING RULE: NO HEALING OR REVIVAL ABILITY IS EVER GATED.** Resurrection is deliberately
  excluded and this is a rule, not a scoping choice — **losing a resurrection to a hand slip is
  the worst outcome the system could produce.** A later batch extending the gated set **must not
  reach for one**. `check_cm.gd` asserts it over the whole corpus, not over the gated five.
- **STANDING RULE: THE DEFENSIVE CHECK CAN ONLY MITIGATE.** Perfect is ×0.85 damage and ×0.75
  Break; **Good and Sloppy are IDENTICAL and never worse.** `_defensive_brace` returns a *boolean*
  rather than a grade, so **the absence of a third outcome is structural** rather than a convention
  somebody has to remember. **A defensive check must never be able to make an incoming blow
  larger.**
- **THE GATED TELL IS `Classes.GATED_TELL`, ONE string on four surfaces** (ability button, battle
  tooltip, draft card, the bar while it sweeps) and **never authored into a description**.
- **`_has_defensive_check` IS THE ONE ANSWER TO "does this unit get a defensive bar".** It reads
  `u.stance` DIRECTLY and deliberately NOT through `_stance_satisfies` — that helper is for
  ABILITY gates, so a Feigned Guard does not conjure a defensive check.
- **TWO NARROWINGS OF "every qualifying incoming attack":** a **counter** raises no bar (a free
  swing drawn by the hero's own action), and an attack carrying a **`special`** raises none (it
  never reaches the ordinary strike loop, which is the only place the mitigation is applied).
- **PACING IS THE KNOWN RISK AND IT IS UNCAPPED ON PURPOSE FOR THE FIRST PASS** — a cap is a
  retreat available afterwards, and it is a designer's call.
## A DURATION IS STATED AS APPLIED (STANDING, SET AT BATCH CV §1)
> **"N turns" is the number the code passes to `_apply_status`. It is never the acting-turn
> count, and `tick_statuses()` running before a unit acts is an implementation detail rather
> than a wording convention.**

`tick_statuses()` (`unit.gd:2171`) decrements at the START of a unit's turn, so a status applied
with `N` covers `N` calendar turns and `N-1` of the bearer's own actions. **Both readings were in
use across the trees** — CU found `cr_rime` using both in a single sentence, the node saying 3 and
the ability description inside its own payload saying 4.

**THE CHIP DECIDES IT.** The chip counts down the raw value, so a node saying 3 while the chip
shows 4 contradicts something the player is looking at right now. The acting-turn reading also
makes every text a TRANSLATION of its own code, and translations rot — which is exactly how the
corpus came to hold both at once.

**NO CODE MOVED. FIVE NODE TEXTS DID**: `sm_deep_thrust` (1→2), `py_flame_shield` (3→4),
`dv_resolve` (3/5→4/6), `cr_rime` (3→4) and — found by CV's own sweep of all 324, not named in the
brief — `wd_hold_line` (the undying window, 1/2→2/3). The Pivot chip's legend (then named Tempo) said
"one turn" and
moved with them. **The one place the old reading was written down as a rule was
`battle.gd`'s `hold_the_line` comment**; it now records the ruling instead.

## HERO AND ALLY ARE THE ONLY TWO WORDS (STANDING, SET AT BATCH CV §4, CLOSED AT DM §3)
> **HERO — one of the four. ALLY — heroes and companions together. AND THERE IS NO THIRD WORD.**
> Where the group is the ENEMY side, *warband*.

**THE TEST IS NOT "DOES THE COLLECTION REACH ONE". IT IS "DOES THE EFFECT ARRIVE."** Walk the
chain from the loop to the number that moves, and **measure it on a live companion**. A widening
that changes no measurement is worse than the narrow word, because a chip appears and it reads as
working — a PARTIAL arrival reads as working too, which is the same failure one step along.

- **THE READ SITE'S COLLECTION IS THE TEST, NOT THE SENTENCE'S RHYTHM.** `_hero_side()` includes
  living companions; `heroes + companions` includes them dead or alive; **a walk over bare
  `heroes` never does, filter or no filter** — every `not h.is_companion` clause on a `heroes`
  walk is filtering an array that cannot hold one, so it records INTENT and does no excluding.
- **THREE FURTHER EXCLUSIONS MEAN *hero* HOWEVER THE COLLECTION IS SPELLED:** an effect stamped
  once where the four are built (no companion exists yet); a **per-turn** effect (`_next_unit()`
  walks `heroes + enemies` and a summon carries `next_time = INF`); and anything Faith-flavoured
  (`_gain_faith` refuses companions outright).
- **THE UNIT OF A RULING IS THE CLAUSE, NOT THE ABILITY.** Two clauses under one word can have two
  different answers, and **the clause carrying NEITHER word is the one no sweep will find** —
  Rallying Shout's *"the whole party sheds 30 Pressure, and every other ally regains 30% of their
  resource"* is one sentence whose halves are an ally's and a hero's, and two sweeps that read the
  ABILITY each ruled on one half and left the other standing.
- **A WORD WITHOUT ITS REASON GETS RE-LITIGATED, SO EVERY *hero* RULING CARRIES THE STRUCTURAL
  REASON A COMPANION CANNOT RECEIVE IT.** There are **five** and no sixth: no resource bar to
  refuel; `_companion_hit` reads none of the hero strike loop's multiplier block; stamped once at
  party spawn; per-turn; `_gain_faith` refuses them. **A clause that is narrow by CHOICE says so**
  rather than implying an impossibility — widening one of those is a magnitude change on companion
  survivability, which is new PLAY rather than a widening.
- **A GUARD AT THE SITE IS WHAT MAKES A RECORDED REASON TRUE.** A companion is built with no
  `resource_name`, but `max_resource` is `unit.gd`'s default **100** — so "it has no bar" is only
  true because the loop tests the name.
- **WHEN A CLAUSE MOVES, SWEEP THE CLAUSE ACROSS EVERY SURFACE, NOT THE CARD ACROSS ONE.** The
  card, `master.html` and the glossary each carry copies, and fixing one while the rest carry the
  old word is this project's oldest recurring defect.
- **THE SURVIVING USES OF "party" ARE IDENTIFIERS AND ARE NAMED**: `party_mark` (a status id), the
  `party` event target, `spec_in_party` (an event condition), and `party.tscn`. Nothing else.
- **PROSE ABOUT THE GAME IS NOT PLAYER-FACING.** This file, `docs/changelog.html`,
  `docs/design-notes.md` and the batch reports are exempt. **History is not swept.**
- **THE RULE IS KEPT BY A CHECK.** `test_batch_bx` §4 forbids "beast" in player-facing prose and
  §4b keeps **"PARTY" IS RETIRED FROM PLAYER-FACING TEXT** over the same file set. **Each was
  shown to bite before it was trusted.**

## STANDING RULE — THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE, NOT THE ABILITY (Batch DL §1)
> **Read a card clause by clause. Two clauses under one word can have two different answers, and
> the one that carries neither word is the one no sweep will find.**

## THE ALLY/HERO THREAD IS CLOSED (Batch DM §3) — RULE ON CLAUSES, NOT ON ABILITIES
> **A card can carry two clauses of different shape under one word, and a sweep that reads the
> ability will not see it. "Party" is retired; HERO means the four, ALLY means heroes and
> companions, and every *hero* ruling carries the structural reason a companion cannot receive it.**

**IT TOOK NINE BATCHES, AND THE REASON IS IN THE SHAPE OF THE QUESTION RATHER THAN IN ANY BATCH'S
CARE:** one swept for a claim about read sites and never ran the test; the next swept ABILITIES;
the next ruled on ABILITIES; the next found that the unit is the CLAUSE. **A BATCH THAT FINDS
NOTHING TO WIDEN HAS STILL MEASURED SOMETHING** — that is what lets a thread close rather than be
abandoned.

- **A CLAUSE CAN BE NARROWER THAN EITHER WORD, AND THAT SCOPE HAS NO NAME HERE.** Battle Shout and
  Hold the Line each hand **five Rage to the CASTER** — one body — and one of the two wrote it
  inside a group clause's colon-list, promising four heroes a payload that reaches one. **The fix
  was to copy the sibling card that already worded it correctly, not to invent a phrasing.**
## NEVER `preload` A SCRIPT THAT NAMES AN AUTOLOAD (STANDING, SET AT BATCH CT — AND IT COST A GATE)
**`run_sim.gd` carried a hand-copied mirror of `shop_screen.gd`'s `ITEM_PRICES`. CT replaced the
copy with `const ITEM_PRICES := preload("res://scripts/shop_screen.gd").ITEM_PRICES` — and that
"fix" was worse than the duplication it removed.**
- `shop_screen.gd` names the **`Run` autoload** at compile time. **Autoloads are NOT registered when
  a `--script` SceneTree compiles its dependency chain**, so the preload failed with
  `Identifier not found: Run`, cascaded through `run_sim.gd`, and took **`test_run_harness.gd`** down
  with it.
- **THE DAMAGE WAS NEARLY INVISIBLE.** The battery still printed `GATE 1 PASS`, `GATE 2 PASS`,
  `GATE 3 PASS`. The only tells were `throws=3` beside them and **GATE 2 reporting 57 checks against
  its documented 165** — it ran barely a third of itself and said PASS. **This is exactly why the
  battery reports the throw count beside the check count** (CD's rule), and exactly why the live
  counts 22/165/8 are written into `run_battery.sh`'s own header. **Read both. A gate that passes
  with throws is not a gate that passed.**
- **THE FIX IS RUNTIME, NOT COMPILE TIME:** `ITEM_PRICES` and `SELL_FRACTION` now live in
  `run_state.gd` beside `ITEM_INFO` and the stack caps — §6's "single place these numbers are
  written" covers a price as much as a heal — and both consumers read them off the run node they
  already hold. **No preload, so nothing to fail at compile time.**
- **The general rule: a `--script` harness can only compile files that name no autoload.** Reading a
  const off the autoload's own script at runtime is always safe; `preload`ing anything that mentions
  `Run`, `Profile`, `Talents`, `Classes` or `Relics` is never safe.

## THE POUCH IS SLOT-LIMITED (STANDING, SET AT BATCH CT §1)
**Acquiring an item is a choice about what to give up.** A **slot** holds one item **TYPE** and its
whole stack — six Health Potions are one slot, not six. **4 → 5 → 6 by zone**
(`ITEM_SLOTS_BY_ZONE`), announced on the zone-victory screen in `_resolve_boss`.
- **THE CAP IS THE DESIGN, NOT A LIMITATION.** Items cost no turn, so before it the shop only ever
  asked "can you afford it" and the answer was yes to everything in reach. Gold was the only
  ceiling; slots are the tradeoff.
- **A STACK FALLING TO ZERO DOES NOT FREE ITS SLOT.** The key stays in `Run.items` until the type is
  **discarded** (map pouch, confirmed) or **sold** (merchant, 40% of listed price). This is why
  `slots_used()` is `items.size()` and never a count of positive stacks — if an emptied stack freed
  its slot the cap would stop binding exactly when it should be biting. **Every writer of
  `Run.items` must respect this**; `events.gd`'s negative-count take is the one direct write left,
  and it is deliberate for exactly this reason.
- **TWO WALLS, AND THEY MUST NEVER BE CONFLATED: NO ROOM IS A CHOICE, A FULL STACK IS A WALL.**
  A grant with no slot becomes a **swap offer** queued on `Run.pending_item_offers` and resolved by
  the map's owed-pick overlay (take it and give up a named stack, or **decline** — declining is
  always a button). A grant over the **per-type stack cap** is still **refused with a message**,
  which is Batch AN §6 standing unchanged. `needs_slot()` answers the first; `item_full()` the
  second. **Ask `needs_slot()` BEFORE `add_item()`** or a choice is printed as a refusal.
- **STACK CAPS ARE PER TYPE NOW** (`ITEM_STACK_CAPS`, default `ITEM_CAP` = 6): Cleansing Draught 4,
  Cursed Visage 2, Resonating Hourglass 2. **Never hardcode "six" in a refusal message again** —
  three of the eight items are not six.
- **A SALE MUST BE A LOSS** (`SELL_FRACTION` = 0.4). An even trade makes the shop a free locker:
  buy everything, park the overflow with the merchant, collect it next visit, and the cap means
  nothing.

## ITEM EFFECTS ARE PERCENTAGES OR SCALE WITH RUN DEPTH (STANDING, SET AT BATCH CT §6)
**A flat number in the pouch decays against a party that grows.** The free healing scaled and the
paid healing did not: clearing a slot heals `SLOT_HEAL_PCT` (15%) of maximum and heroes gain **+2%
base HP per win**, so a flat-40 Health Potion was worth less every fight while the shop kept
charging 30 gold for it. **Do not author a flat item value.**
- Health **20% of max HP**; Mana **40% of max resource**; Bomb **50 base × (1 + 0.02 ×
  `combat_wins`)**, the heroes' own rate. Revive (50%) and Defense (+10% armor) were already
  percentages and are untouched.
- **The values live in `Run` as functions** — `health_potion_heal`, `mana_potion_restore`,
  `bomb_damage` — and **battle and map both CALL them**. The old comment claimed the two "read the
  same 40" while each spelled the literal out separately, which is a claim, not a mechanism.
- **FLAGGED, NOT TUNED: the Health Potion is a NERF at run start.** Base class HP is 154/99/121/110,
  so 20% is 31/20/24/22 against the old 40, and it only overtakes 40 past 200 max HP. Shipped as the
  brief specified. Mana's 40% **is** the old flat 40 at the base max of 100, and the Bomb opens at
  50 — those two are washes and this one is not.

## `hexed` IS NOT `crippled`, AND THE BRIEF ASKED FOR `crippled` (STANDING, SET AT BATCH CT §5)
**`cripple` already existed** — "Cripple", −25% damage dealt, in `DEBUFF_IDS`, applied by three
abilities and two enemies. The glossary entry for it reads "A **crippled** unit deals 25% less
damage" and `battle.gd`'s Corrupted Channeling comment says "a **Crippled** enemy". Batch CT's brief
asked for a second status called `crippled` / "Crippled" at −15%. **It shipped as `hexed` /
"Hexed", chip "Hx".**
- **Every number and rule of §5 is unchanged** — −15% damage dealt, battle-long (`-1` turns), in
  `DEBUFF_IDS` so a Trapper counts it and the derived `_dispellable_buffs` set cannot reach it.
  Only the name moved.
- **Why:** two chips a player cannot tell apart, and twelve `has_status("cripple")` call sites one
  typo away from a silent bug, is not worth a homonym. **If a later batch wants the brief's name,
  it is a rename — but rename `cripple` too, or the pair is unreadable again.**
- **The two STACK** (multiplicative, `raw *= 0.75` then `raw *= 0.85`). Separate statuses from
  separate sources; stacking is the only reading that leaves neither silently free.

## VERIFY THE BRIEF AGAINST THE REPO BEFORE IMPLEMENTING IT (STANDING)
**A brief's mechanical claims are checked against the code before anything is edited, every
time.** This is not scepticism about the designer — a brief is written from a document, and the
document drifts from the code. **Three consecutive briefs (CR, CT, CV) each carried between three
and five wrong claims, and every one was caught this way.**

### AND A PRECEDENT IS A CLAIM, SO A PRECEDENT GETS CHECKED (STANDING, SET AT EI §2)
> **When a brief cites a precedent — a prior ruling, a mechanism, an existing ladder or convention
> — the batch VERIFIES it against the code before building on it, and reports if it does not
> hold.** A wrong precedent is worse than a wrong number: a number gets re-derived, and a
> precedent gets INHERITED.

**THE RULE ABOUT FIGURES DID NOT COVER THIS, AND THE GAP IS WHY IT IS WRITTEN DOWN.** The standing
rules already say to derive a figure from the file rather than quote it — but a precedent is not a
figure, and nothing told a batch to check one. **DOCUMENTS GET SWEPT AND BRIEFS DO NOT**, so a
false precedent has no instrument standing between it and the next batch; it propagates by being
read, which is the one channel this project has never gated.

- **THE WORKED EXAMPLE IS THREE ERRORS IN ONE LINEAGE, ALL OF THEM IN BRIEFS.** CT asserted a rune
  equip ladder that had been deleted at AN §9, and found that itself. **Eleven batches later EG's
  brief asserted the same ladder.** EH's brief then diagnosed the source as `master.html` — and
  **that document has never carried the claim**, so the correction was aimed at a file that was
  right all along.
- **THIS IS ALREADY WHAT HAPPENS, AND THAT IS THE ARGUMENT FOR WRITING IT DOWN RATHER THAN AGAINST
  IT.** It is why EG caught CT's and why EH caught EG's. **A practice nobody has stated survives
  only as long as every session thinks to do it.**
- **IT IS FORWARD-LOOKING ONLY. DO NOT SWEEP PAST BRIEFS.** They are history, the changelog holds
  them, and the reports already record every correction.

**THE SHAPES THE ERRORS TAKE, so they can be recognised early:**
- **A NAMED PRECEDENT THAT DOES NOT EXIST — AND THIS ONE HAS NOW BEEN NAMED BY TWO BRIEFS,
  ELEVEN BATCHES APART.** "Follow the rune equip-slot ladder — it grows 2→3→4 by zone and announces
  each new slot": that ladder was DELETED at AN §9 and `rune_slots()` has returned a flat 3 ever
  since. There was nothing to copy at CT and there was nothing to copy at EG. **A FALSE PRECEDENT
  SURVIVES BEING CAUGHT**, because it is caught in a batch report and briefs are written from the
  design document. **When one is found, correct the document it came from, not only the batch.**
  - **AND EH SWEPT `master.html` FOR THIS ONE AND IT WAS NEVER THERE.** The document says "three
    flat slots", "no runes and three empty slots" and "three rune slots" in all four places it
    mentions them. **The false ladder lived in the BRIEFS, not in the document** — so "correct the
    document it came from" means FINDING which document it came from, and the answer here was
    neither `master.html` nor any file in the repo. **Do not assume the design document is the
    source of a false precedent; check it.**
- **A LAYOUT CLAIM THAT WAS NEVER MEASURED.** "Six buttons fit the existing row" — at the shipped
  pitch, button six spanned x=1270–1452 on a 1280-wide viewport. **Measure it; do not eyeball it.**
- **A NAME THAT COLLIDES WITH A LIVE ONE.** A requested status id already existed under a
  near-identical name. **Sweep the roster before authoring.**
- **TWO MECHANISMS DESCRIBED AS ONE.** "Exactly as the Bomb and Defense Potion already do" — the
  Bomb is refused by `_usable_on_map` (the button never lights); the Defense Potion's button is
  ENABLED and toasts a refusal after the press. **Pick one and say which.**
- **A COUNT THAT IS LOW.** Re-derived counts have come back LARGER four times (four→five,
  16→28, 37→220, and **7→16 at EH**). **A NAMED LIST CANNOT AUDIT ITSELF — the list is the thing
  under suspicion.** Run the sweep over the whole population, not over the names the brief supplies.
  **THE EH INSTANCE IS THE ONE TO REMEMBER, BECAUSE THE AUDIT THAT MISSED IT WAS ITSELF A CHECK OF
  A BRIEF'S CLAIM.** EG's record reads *"all seven named enablers are in `protected_names` for their
  spec"*, and every word is true — it audited the seven the brief listed. `PROTECTED_CORES` names
  **sixteen, across nine specs**; the nine outside the brief's list were outside the audit. All
  sixteen are protected, so the CONCLUSION held and only the sweep did not. **A right conclusion
  reached over the wrong population is the hardest kind to catch, because nothing goes red.**
- **A CLAIM ABOUT A PRIOR BATCH'S OUTCOME.** One brief stated a previous batch "left them red"
  when the battery had been green since. **Check the repo, not the brief's memory of it.**

**REPORT EVERY DISCREPANCY IN THE BATCH REPORT, INCLUDING THE ONES THAT MADE NO DIFFERENCE.**
The brief is the shared record; leaving an error in it means the next brief inherits it.

## THE SHARPSHOOTER'S BASIC IS A SEQUENCE (STANDING, SET AT BATCH CS)
**HIS BASIC ATTACK ONLY. No other ability of his changes, and no other hero's bar moves at all.**
`_is_sharpshooter_basic` is the single answer to "is this it" — read off the hero's passive
(`lethal_aim`) and off **slot 0**, never off a name, because his basic IS Quick Shot and two other
specs carry the same object.
- **ONE PRESS, PLUS ONE PER 50 FOCUS HELD, CAPPED AT FOUR**, read at the moment the bar opens.
- **THE CAP IS THE POINT AND IT IS NOT A ROUNDING CHOICE. DO NOT RAISE IT.** Focus has no ceiling,
  so an uncapped rule makes deep Focus a nine-press sequence with a tightening window **on the
  action he presses most** — an ability a player without the reflexes cannot use. `check_cs.gd`
  asserts the cap and the reason sits beside `SS_SEQ_MAX_PRESSES`.
- **PARTIAL CREDIT: every landed press counts, a miss ENDS the sequence and keeps what came
  before.** "Landed" is Good or better. **This REPLACED CN's worst-grade combine rather than
  joining it** — `_worse_grade` and `_GRADE_ORDER` are deleted, so both behaviours are not left
  reachable.
- **IT PAYS IN FOCUS, NOT DAMAGE.** Damage resolves off the FIRST press's grade and later presses
  add none — a deep-Focus Sharpshooter **ramps faster, he does not hit harder per swing**, because
  Focus already converts to crit chance and then crit multiplier.
- **THE PAYOUT IS AFTER `_resolve`, NOT BEFORE IT.** `_sharpshooter_focus` dumps the meter to zero
  on a target switch; paying first would delete the points the same shot just earned. `_gain_focus`
  is the only way in, so every ledger sees it as it sees the engine's.
- **ONLY THE GOOD WINDOW WIDENS WITH THE PRESS COUNT. THE PERFECT WINDOW IS DELIBERATELY HELD
  FIXED** — the first press's Perfect sets the damage, so widening it would let depth buy damage
  directly, which is the thing "ramp faster, not hit harder" exists to prevent.
- **THE §4 LANDING-RATE TABLE COMES FROM A STATED MODEL, NOT FROM PLAY DATA, AND NOTHING IN THIS
  REPO CAN MEASURE IT.** The bot never runs the bar, so a widened window is invisible to every
  instrument the project owns. `check_cs.gd` re-derives the table from the constants so a
  hand-edited row cannot pass silently — **but the timing-error SD is a guess about human reflexes
  and the gate cannot check it.**
- **PIN THE PAYOUT CONSTANTS, NOT JUST THE ARITHMETIC.** Every payout assertion written as
  `landed * SS_SEQ_FOCUS_PER_PRESS` passes a negative control that moves the constant.
- **THE TELL IS KEYED ON THE PRESS COUNT, NOT ON A NEW `mode`**, and an early end reads as
  **"CHAIN BROKEN 2 / 4 — Good"** rather than vanishing, because a sequence that just stops reads
  as dropped input.
- **THE BOT ROLLS PER PRESS AND STOPS AT THE FIRST FAILURE.** At one press it is byte-for-byte the
  line it always was, so no other hero's grade moves.
- **OPEN, REPORTED AND NOT ACTED ON: the gold Perfect zone is drawn on presses 2–4 and buys
  nothing there.** Hiding it after the first press is the obvious fix and would make "the first
  press sets the damage" visible without text — a design change and the designer's call.
## THE THREE CLAMPED CALL SITES, AND WHY `update_status` IS NOT CLAMPED (STANDING, SET AT CP §0)
**`update_status` ASSIGNS power where `add_status` MAXES it.** On the three sites whose power is
computed from LIVE STATE, that let a weaker recast overwrite a standing buff DOWNWARD — worse than
the waste CO's refusal was written to fix, and unreachable by that refusal because all three carry
a second payload.
- **THE CLAMP IS AT THE CALL SITE, THREE TIMES: Battle Shout, Stabilize, Eye of the Storm.** Each
  reads `status_power` BEFORE `_apply_status` and writes the chip only when the new value is at
  least as strong. `status_power` returns **-1** when nothing stands, so a fresh cast always
  writes. **THE CAST STILL PAYS** — the +5 Rage, the Mana and 5% heal, and the taunts all sit
  OUTSIDE the guarded branch, which is the whole reason the fix belongs here and not in the gate.
- **DO NOT CLAMP `update_status` GLOBALLY, AND TWO SITES SETTLE IT ALONE.** `held_breath` and
  `instinct` compute `status_power(...) - 1` and write it back — they are COUNTDOWNS, and a global
  `maxi` freezes them at their opening value forever, so neither is ever spent. Six more banks
  decrement through the same door: `mirror`, `arrows`, `feint_guard`, `berserk`, `deadfall`,
  `loyalty`. **Nothing would crash and nothing would log.**
- **THE CENSUS IS IN CP's CHANGELOG ENTRY AND IS THE ARTEFACT TO READ BEFORE TOUCHING THIS**: 69
  call sites, 42 passing a power, and 29 of them calling `_apply_status` then `update_status` on
  one status (the shape that can downgrade). **`spite` is the trap in that list** — it passes a
  CAP as the power while its chip text carries the live figure, so a naive "never write a smaller
  number" rule would be WRONG there.
- **REPORTED, NOT FIXED — TWO MORE SITES HAVE THE IDENTICAL DEFECT:** `blood_debt` (35 on a
  perfect, 25 otherwise, so a non-perfect re-mark drops the standing share) and
  `reckless_abandon` (scales with Rage spent, and the cast ZEROES the bar, so a second cast in its
  own window is necessarily smaller — CM gates it below one full step, not below the standing
  value). Both take the same three-line clamp; CP scoped itself to the three CO recorded.

## HARD CONTROL LANDS ON A BOSS ONLY ONCE IT IS BROKEN (STANDING, SET AT BATCH CR §1)
> **Hard control lands on a boss only once that boss is BROKEN. Never before.**

**THE CHECK ALREADY EXISTED AND THERE IS STILL ONLY ONE OF IT.** `_apply_status` refuses
`stunned`, `frozen`, `psychosis`, `bewitch` and `hysteria` on `target.is_boss and not
target.broken` — the same `broken` the Occultist's Madness lane rests on. **A SECOND CHECK MUST
NOT BE WRITTEN**; an ability obeys this rule by not passing `force`.
- **WHY IT HAD TO BE RE-RULED.** Flash Freeze and Snare Trap bought the boss carve-out with their
  PERFECTS. CN took the bar off both, their Perfect became their base, and **boss immunity to
  hard control silently ceased to exist** — the Occultist's whole gate rests on Broken meaning
  something. Neither could be restored to its old condition, because **"only on a Perfect" is not
  expressible on an ability with no bar.** So the gate moved to the mechanic that already exists.
  **THIS IS BETTER THAN THE PRE-FOLD BEHAVIOUR, NOT A RESTORATION OF IT: a bypass earned through
  play rather than through timing.**
- **`force` HAS EXACTLY ONE CALLER NOW AND IT IS POMMEL STRIKE.** That card KEPT its bar (25
  damage, so `runs_skill_check()` is true), so "only on a Perfect" is still expressible there and
  its perfect still lands the Stun on an unbroken boss. **REPORTED AND DELIBERATELY NOT CHANGED
  AT CR** — it is the one ability left applying hard control to a boss on a condition other than
  Broken, and whether it joins the rule is a designer's call, not a batch's.
- **`_spring_trap`'s `force_stun` PARAMETER SURVIVES WITH NO CALLER PASSING TRUE.** Left in place
  rather than removed (a shared helper's signature is adjacent scope), but **a future caller
  passing `true` is re-opening the door this rule closed.**
- **THE CONFORMING SET, CENSUSED AT CR AND WORTH NOT RE-DERIVING:** Mind Flay (`psychosis`),
  Bewitch, Mass Hysteria, Glacial Prison and Cryoclasm (both through `_hold_freeze` with no
  force), Spread of Madness (which filters `not e.is_boss or e.broken` itself) and Ricochet's
  stagger all already gate on Broken. **Flash Freeze and Snare Trap were the only two that did
  not.**

## REMOVING A SKILL CHECK MAKES ITS PERFECT-ONLY BEHAVIOUR UNCONDITIONAL (STANDING, CR §7)
> **Any Perfect that gated a BINARY — boss immunity, an extra strike, a refund — must be ruled on
> BEFORE the bar comes off, not audited afterwards.**

A magnitude fold is visible in a diff and a census can find it later. **A BINARY IS NOT A
MAGNITUDE**: "the Stun lands on an unbroken boss" and "one of those strikes lands at once" are
rules that switch from off to always-on, and nothing in the diff of `X if is_perfect else Y`
becoming `X` says which kind of thing just changed. CN's criterion answered *does this ability
still grade?* correctly 113 times; **it never asked what the orphaned bonus should become**, and
folding was assumed because folding preserves the most. Three of CR's seven cards are that gap:
Bewitch's free enemy attack, and Flash Freeze and Snare Trap deleting a game-wide immunity rule.

## THE LITERAL-DIGIT RULE IS A BASELINE, NOT A GATE (STANDING, CP §3)
CL §1's rule is that a parenthetical is COMPUTED and never authored. **Swept over every authored
field the corpus holds 89 across 979 fields — not the ~200 CP's brief assumed — and CL was RIGHT
to make it a report**: most are legitimate prose that is not a resolved value (`(max 5)`,
`(0-100)`, `(2 on a crit)`, `(cap 100)`), so **asserting zero fails against correct text.**
`test_batch_cp` pins the **fourteen ability-level offenders EXACTLY** (the surface CL's rule was
about, and the one CK taught the draft card to render) and the corpus count as a **CEILING**. A new
authored digit trips either way; the fourteen are recorded as OWED rather than rewritten, because
rewriting shipped player-facing text is authoring.
**AND THE PERFECT RULE IS NOT A BICONDITIONAL.** CN's enforceable direction — runs no check ⇒ no
Perfect — holds at **ZERO violations**. The converse fails for **five** abilities (Called Shot,
Coup de Grâce, Pinning Shot, Powershot, Rampage) whose bars still multiply damage, and **git shows
all five have had an empty `perfect_text` since long before CN** — an authoring pattern, not a
regression. All five are NAMED so a sixth trips.
**CK's MISSING WIDTH MEASUREMENT (`check_ck_width.gd`): 195 abilities, 725 block lines, mean 3.72
a card (the brief's "five" is 3.72), and 8 lines (1.1%) exceed the 258px card — worst +94px
(Feint's Perfect).** So the block costs the column its LINE COUNT, which CK already measured; it is
NOT a wrapping problem.

## A PASSIVE PAID IN DAMAGE TAKEN INVERTS AGAINST EVERY BATCH THAT HELPS THE PARTY (STANDING, CZ §1)
> **A passive paid in what the party is trying to prevent needs a SECOND TERM the hero controls.
> Tuning cannot fix it — any number you pick is a number the next mitigation buff will erode.**

Blood Frenzy pays the Berserker for health he has already LOST, so **better healing, better
mitigation and better play all weaken him.** CY did not set out to nerf him: it made buffs cheaper
to hold, the party held more of them, he took less damage, and his own band got *shallower* in a
batch aimed at helping him. **That will keep happening.**
- **THE SECOND TERM IS RAGE SPENT, AND WHAT MAKES IT THE RIGHT ONE IS THAT HE CONTROLS IT.** Every
  other candidate was a version of "the fight went badly", which is the same failure one door
  along. His pool already moves Rage constantly, so **his own cards feed his own passive.**
- **THE BAND DOES NOT GROW, AND ENFORCING THAT IS HALF THE DESIGN.** `FRENZY_MAX_STEPS` = 20 is the
  ceiling the health term ALREADY had; the steps are SUMMED and then CLAMPED, so the second term
  fills the band **sooner** and can never make it **deeper**. **A Berserker already in the red gains
  nothing from it** — at that point the identity term is paying in full. Adding on top would change
  what the spec IS.
- **THE RATE IS A RULE, NOT A CONSTANT: `FRENZY_RAGE_PER_STEP` = 5, because a full Rage bar is 100
  and five Rage is 5% of it** — the health term's own rate off the other bar. *+2% per 5% of health
  missing, +2% per 5% of Rage spent.*
- **THE LEDGER BOOKS WHAT LEFT THE BAR, NEVER `ab.cost`.** One function
  (`BattleUnit.note_resource_spent`), three callers. Measuring the bar is what catches the waivers
  (Snap Shot, Twin Hunt), the discounts (`_eff_cost`), the refunds (`resource_gain`) and the clamp
  at zero **without knowing any of their names** — and it is what makes the term un-farmable.
- **A FOURTH SPEND SITE ADDED LATER MUST REPORT TO IT** or the band silently under-pays.

## FAITH RELEASES AT `FAITH_RELEASE`, AND THE LANE TRADES DEPTH FOR FREQUENCY (STANDING, CZ §2, AMENDED DA §1)
**The threshold is ONE number (`battle.FAITH_RELEASE`, 3) and it was a literal `5` in three
places** — the cap on the count, the release branch, and Communion's "still building" guard.
**THE BUILDERS ARE BACK AT THEIR PRE-CZ RATES: `FAITH_PER_ABSORB` 2, `FAITH_PER_GROUND_TURN` 1.**
- **SHORTENING THE BAR LOWERS THE HELD CEILING TOO, AND THAT IS THE COST.** Faith pays on the
  highest count held and the count caps at the threshold, so the deepest benefit an ally can carry
  fell from 5 stacks to 3. **The lane trades depth of hold for frequency of release, deliberately.**
- **A BUILDER RATE THAT MEETS THE THRESHOLD IN ONE EVENT CHANGES WHAT THE CARD IS, AND THAT IS WHY
  CZ's BUILDERS WENT BACK.** At 3 per absorb against a threshold of 3, **one absorbed hit is a
  whole release** — a shielded ally never HOLDS Faith, so `faith_peak`, the high-water mark the
  whole lane pays on, stops existing for allies and the card becomes a per-hit heal. **A magnitude
  that changes what a card IS must never be a silent consequence of a threshold moving somewhere
  else.** `check_da` asserts the RELATIONSHIP (`FAITH_PER_ABSORB < FAITH_RELEASE`) rather than the
  number, and drives one absorb live to prove the hold is there.
- **THE THRESHOLD WAS SIZED AGAINST STRUCTURE AND THE BUILDERS WERE SIZED AGAINST A BAD NUMBER.**
  That is the whole of why one stayed and both went back. CZ sized the builders against CY's
  arrival row and then itself proved that row samples the Devout's own held meter; the figure that
  answers "does a release fire" is `releases/battle`, and it read **0.81 a battle at rung 2**, not
  1.6 of 5. **When a batch discredits the measurement it is sized against, everything it sized is
  owed a re-derivation — including the parts that look fine.**
- **RAISING THE ABSORB RATE DOES NOT MOVE THE ARRIVAL FIGURE.** That row is the Devout's own meter,
  fed by the ground drip on his own turns; absorbs buy ally release frequency and nothing else.
  Measured, not assumed.
- **THE THRESHOLD ALONE IS WORTH ROUGHLY A TRIPLING OF RELEASES** — 0.81 → **2.60** a battle at
  rung 2, against 4.24 for the threshold plus tripled builders. Measured at every rung in
  `docs/reports/DA.md`. **Elevation (2 of 3) and Blessing of the Faithful (3 of 3) were reported
  and deliberately not changed at either batch.**
- **THE SUITES WERE PAID AT DC, AND THE DERIVED BAND IS WHAT MOVED.** An ally's count is clamped
  at the threshold and releases on reaching it, so **the deepest an ally can HOLD is 2**, and
  Communion — which skips `faith_stacks >= FAITH_RELEASE` — **rolls over a 1–2 band, peaking at
  30% rather than 60%.** Each of `be`, `bf`, `bg`, `bh`, `bi` carries `const RELEASE := 3` and
  `const HELD_MAX := RELEASE - 1` **once**, so the next ruling costs one line a suite.
- **AND DA'S REVERT MOVED THE CODE AND LEFT TWO PIECES OF PROSE BEHIND, FOR FOUR BATCHES.** The
  Devout's `passive_desc` in `classes.gd` and the `faith` status chip in `battle.gd` both read
  **"3 a hit"** against `FAITH_PER_ABSORB` = **2**; `docs/master.html` said `(2 a hit)` the whole
  time. **The documentation was right and the game was wrong**, and the suite that asks the
  question was already red for the threshold, so nothing announced it. **When a batch reverts a
  constant, sweep the PROSE for the number it reverted** — the code change is the easy half.

## A REVERTED CONSTANT MUST BE SWEPT THROUGH THE ABILITY CARD TOO (STANDING, SET AT DF §1)
> **When a batch reverts a magnitude, sweep every place the number is SPOKEN — the passive text,
> the status chip, the design doc, AND THE ABILITY'S OWN CARD. The card is the copy the player
> reads while deciding, and it is the one that gets missed.**

- **THE CASE: CONSECRATED GROUND PROMISED DOUBLE WHAT IT PAID FOR FOUR BATCHES.** CZ raised
  `FAITH_PER_GROUND_TURN` 1 → 2 and moved the card's "kindled 1 Faith" to "kindled 2" **with it,
  correctly**. DA reverted the constant to 1 and **left the card at 2.** DC then swept exactly this
  defect and fixed two instances — the Devout's `passive_desc` and the `faith` status chip — and
  **did not reach the third.** `docs/master.html` read "(1 an ally a turn)" throughout and was
  right about the NUMBER the whole time, so the design doc and the game disagreed and only a suite
  noticed. **AND IT WAS WRONG ABOUT THE WORD FOR JUST AS LONG, WHICH NOBODY LOOKED AT** — the drip
  is refused to a companion twice over, so *ally* was never available to it. **DM §1 corrected
  that half**, in three `master.html` copies and one glossary copy; the quoted string above is
  history and no longer appears in the file.
- **THE SUITE THAT NOTICED WAS READ AS STALE FOR FOUR BATCHES.** `test_batch_bj` §2 asserts
  `classes.gd` contains "kindled 1 Faith" and it is **correct** — the code pays 1, and
  `test_batch_aw`'s live checks measure it landing 1 at a time through a real turn. **A red that
  sits in a pile of stale reds is invisible**, which is the whole reason a failure total gets
  sorted before it gets repaired.
- **THE ORDER THAT CATCHES IT: the constant, then every call site, then every STRING that states
  the number.** Grep the number, not the field — the card says "2 Faith", not
  `FAITH_PER_GROUND_TURN`.
- **THE CASE IS CLOSED AT DG §1, AND THE RULING WENT TO THE CARD.** The card reads "kindled 1
  Faith" again and **`FAITH_PER_GROUND_TURN` did not move**. DA's revert was deliberate: at the
  reverted magnitudes an absorbed hit was very nearly a whole release and a shielded ally never
  held Faith at all, so **raising the ground drip to match the card would have partly reopened
  what that revert closed**. The prose was wrong, not the constant.
- **AND THE SWEEP FOUND THE CARD WAS THE ONLY STALE SURFACE.** Five places speak this number —
  the card, the Devout's `passive_desc`, the `faith` status chip, `data/glossary.json` and
  `docs/master.html` — **and the other four all read 1 already.** DC's two repairs were to the
  ABSORB magnitude, a different constant reverted in the same batch. **When a batch reverts two
  constants at once, sweep them as two sweeps**, or the one with fewer surfaces looks finished
  because the other one was.

## A PURE BUFF COSTS HALF A SWING (STANDING, SET AT BATCH CY §1)
> **A pure buff's initiative delay is capped at HALF the basic attack's delay. Setting up costs
> less tempo than swinging.**

**WRITE IT AGAINST `BASIC_DELAY`, NEVER AS THE 1.0 IT EVALUATES TO.** `Ability.BUFF_DELAY_CAP` is
`BASIC_DELAY * 0.5`, and `BASIC_DELAY` lives on **`Ability`** (battle.gd aliases it) because the
delay is an ability's property and `Ability.make` is where the cap is applied. There is exactly one
authored `2.0` in the project. **A later batch that retunes the baseline retunes the rule with it;
a later batch that writes `1.0` has replaced the rule with a coincidence.**

**THE REASON, SO NOBODY LIFTS THE CAP AS ARBITRARY.** §0 measured the fight the game actually has:
**3.0 to 5.5 turns per hero** — trash 3.5/3.8/4.1 rounds at the three difficulty rungs, and
**elite fights are the shortest of the three kinds at every rung**. A turn spent setting up is
**20–33% of everything a hero will do**, so the ramp specs' engines never returned their cost.

### THE ELITE BEING SHORTEST IS ACCEPTED, NOT A DEFECT (STANDING, RULED AT EN §5)
> **Elites are burst checks by design. A ramp spec having least room exactly where the difficulty
> spikes is the intended tension, not a finding.**

**DO NOT RE-DISCOVER IT.** CY reported it as *"the finding nobody would have predicted"* and it has
been re-derived once already; it is ruled and it stays.
- **THE FIGURES TO QUOTE ARE EN's, NOT CY's.** Re-measured at EN over `--run 30` a rung on the live
  tree: **elite 3.4 / 3.7 / 4.0** against trash 3.9 / 4.3 / 4.4 and boss 3.8 / 4.4 / 5.4. CY's
  3.0 / 3.3 / 3.6 are superseded and DA's rung-3 row (all three kinds at 4.4) does not reproduce.
- **THE "NO LONGER HOLDS AT RUNG 3" CAVEAT IS RETIRED.** DA measured rung 3 flat and the caveat
  stood from DA to EN; **on the live tree the elite is shortest at all three rungs again**, by
  0.4-0.5 rounds. The caveat was true when written and is not true now.
- **THE CONFOUNDERS RIDE WITH THE NUMBER, AS THEY DID AT CY.** The sim party is FULLY TALENTED
  (`rows=9 of 9`) and wears each tree's FIRST lane; companions are excluded from both halves of the
  ratio; n=30 runs a rung. **A rounds figure is comparable only against another rounds figure taken
  the same way.**
Blood Frenzy reaches 31% of its band and Faith 1.6 of the 5 a release needs; **the average fight
ends without a Faith release ever firing.**

**THE BUFF IS NOT FREE AND MUST NOT BECOME FREE.** It still spends its resource, its cooldown and
half a swing. A free buff makes every buff strictly correct to cast and deletes the decision across
the whole category — and Anvil, Formless, Discipline, Unslaked and Spite were all priced as turns
you spend.

**THE POPULATION IS DERIVED BY WALKING `battle._resolve_special`, NEVER BY READING `damage` AND
`pressure`** — those are zero on **137 of 216** abilities, Feint and Kill Command among them.
`Ability.PURE_BUFFS` (52) is the set and `check_cy.gd` re-walks it live. The criterion:

> **A PURE BUFF is an ability whose ENTIRE cast-time payload is one or more statuses (or
> status-backed flags) written to the CASTER or to LIVING ALLIES.** At cast: no damage, no Break
> damage, no heal, no resource, no Pressure, no cooldown, no initiative, no summon, no revive, no
> purge, and **nothing at all written to any enemy**.

**CAST TIME IS THE WHOLE OF IT, because the delay is paid at cast.** What the status goes on to do
— Venom Coating poisoning later hits, Tripwire springing on an enemy's turn — is what the buff IS,
not a second payload.
**FOUR POPULATIONS ARE EXCLUDED AND REPORTED, NOT CHANGED:** heals (`HEAL_SPECIALS` plus the `heal`
fields is the ONE answer to *is this a heal*), **shields** (a *consumable absorb pool or charge
count that eats incoming attacks* — percentage mitigation for N turns is NOT one), anything with a
second payload, and every enemy ability.
**HALF IS THE DESIGNER'S FIRST GUESS AND IS FLAGGED, NOT TUNED.**

### A SHIELD TAKES THE CAP; A HEAL DOES NOT (STANDING, RULED AT BATCH CZ §3)
> **A shield is played BEFORE the blow. A heal answers what just happened.**

CY reported the six shields and changed none of them; **CZ ruled they take the cap** — Divine
Shield, Interpose, Magic Barrier, Mantle, Mirror Image and Vespers, all now at `BUFF_DELAY_CAP`.
**The mechanical criterion that separated them from pure buffs is still correct and is not what
decided this**: *what kind of thing is this* and *what should it cost in tempo* are two questions,
and conflating them is why they sat unruled for a batch.
- **THEY ARE A SEPARATE POPULATION AND MUST STAY ONE.** `Ability.SHIELD_SPECIALS` is a second list,
  never five names appended to `PURE_BUFFS`, so CY's table stays checkable as the thing CY derived.
  **`Ability.takes_delay_cap()` is the ONE function that unions them** — `make()` and every gate
  ask it, so the two populations can never be capped by two different rules.
- **THE FIFTEEN HEALS KEEP THEIR FULL PRICE AND THE NEGATIVE HALF IS ASSERTED.** `check_cz.gd`
  fails if any drafted heal is caught by the cap or sits at or under it. A rule with only its
  positive half checked would let a later batch halve every heal in the game and still pass.

### THE LADDER HAS THREE RUNGS AND EVERY ONE IS WRITTEN AGAINST THE ONE ABOVE (STANDING, CZ §4)
`BASIC_DELAY` **2.0** (a swing) → `BUFF_DELAY_CAP` **1.0** (setup, half a swing) →
`Ability.DELAY_FLOOR` **0.5** (the cheapest an UPGRADE can buy, half the cap again).
- **`up_speed`'S FLOOR WAS A LITERAL `1.0` AND CY'S CAP LANDED EXACTLY ON IT.** Swift was live on
  all 52 pure buffs one day and bought nothing at all the next, in total silence. **CR's rule, one
  rung further down: a floor is a QUOTING SITE even when it quotes a number nobody thought was
  related.** It became a quote of the cap retroactively, by collision.
- **A JUSTIFICATION FOR NOT CHECKING SOMETHING IS A THING TO RE-READ WHENEVER ITS SUBJECT MOVES.**
  `upgrade_fits` fell through to `return true` on the comment "Swift is the one that fits
  everything — every ability has a delay". True for eight batches, false overnight, and the comment
  is what stopped anyone looking. **Nothing in a diff points at a comment.**
- **ASSERT THE GENERAL PROPERTY, NEVER A LIST.** `check_cz.gd` asserts that Swift changes the delay
  of every ability `upgrade_fits` says it fits — true today and true whatever a later batch
  authors, where a list of 52 names would have rotted immediately.
- **ZERO IS REACHABLE AND DELIBERATELY NOT HERE.** Instinctive Rotation sets `eff_delay = 0.0` as a
  talent's whole payload; an upgrade must not buy what a node exists to grant.
- **MANA SHIELD'S `minf(eff_delay, 1.5)` IS INERT AND IS KEPT ANYWAY.** It is a CLAMP: what it does
  now is keep the discount unable to RAISE the cost, which is the exact failure CY caught it in.

## THE ENUMERATION IS `Classes.ability_corpus()` AND IT IS THE ONLY ONE (STANDING, SET AT CZ §0)
**"What are all the abilities in the game?" has exactly one answer and it lives on `Classes`, not
in a gate.** It walks the kits and the pools (the Batch CL enumeration), applies
`apply_kit_overrides` so the four overridden basics are reached, and resolves talent grants through
**`Talents.granted_ability`**. **The live corpus size is in `docs/state.md`, not here.**
- **DO NOT WRITE A SECOND COPY OF IT IN A GATE.** Five gates each held their own and four of them
  carried one hole for as long as they existed: **a talent node granting an ability that is in no
  pool was invisible to every one of them.**
- **IT LIVES ON THE GAME'S DATA RATHER THAN ON THE TEST**, because a gate that owns the answer is a
  second authority the game itself never consults.
- **`check_cz.gd` KEEPS THE OLD CL WALK AS A NEGATIVE CONTROL.** Its whole job is to still be
  missing what the complete walk reaches; if it ever stops being, the gap closed itself and every
  report about it is stale. **It asserts a SET IDENTITY, not an equality**, so a fifth kit override
  is covered by doing nothing — and an ability outside every kit and pool is in NEITHER walk and
  cannot hide inside the difference.

## A recast that would not improve is REFUSED (STANDING, SET AT BATCH CO)
**THE RULE: a status recast that would improve neither duration nor power is refused, and the
refusal is scoped to abilities whose WHOLE PAYLOAD is the status.** `_recast_refused` is the ONE
answer and `RECAST_GATED` is the set; **its live size is in `docs/state.md`, not here.**

- **WHY IT EXISTS.** `add_status` resolves a re-application as `max()` on duration and power, so a
  status whose power is a **snapshot of live state** could be recast at a weaker value, have that
  value discarded by the max, and still charge full resource, a full cooldown and the turn.
- **THE SCOPE LIMIT MATTERS MORE THAN THE RULE.** An ability that also deals damage, heals, or
  converts a resource **must still cast** when its buff would not improve: that half is worth the
  turn on its own, and refusing it would be a worse bug than the one being fixed.
  **FUNERAL PYRE, STABILIZE, BATTLE SHOUT, RECKLESS ABANDON and BLESSING OF ZEAL are excluded for
  exactly that reason.**
- **DERIVE MEMBERSHIP BY WALKING `_resolve_special`, NEVER BY READING `damage`/`pressure`** — CN's
  trap, and it is the same trap here: those fields are zero on Feint, Guard Change and Kill
  Command, all of which hit hard from inside their handlers.
- **NEVER GATE ON A `power` THAT IS NOT A MAGNITUDE.** Mark of the Hunt, Snare Line, Eye of the
  Storm and Vendetta store `heroes.find(attacker)` in the status power; a numeric test there
  refuses on a hero's slot number. They are excluded and must stay excluded.
- **THE TEST IS EXACT AND COMPUTED AT CAST TIME**, never read off the authored value. Refusing a
  cast that would in fact have improved something is **strictly worse** than the bug. Three things
  the arithmetic must keep: powers recomputed live; **Fleeting normalised** (the target's own
  `mod_status_turns`, as `add_status` applies it); **a negative turn count is permanence, not a
  duration**, so nothing lengthens a battle-long status.
- **RIDERS COUNT AS IMPROVEMENT.** `barrier` is SHARED and `_grant_divine_shield` stamps `divine`,
  so a Devout casting over a Mage's LARGER barrier improves it — it becomes divine, which feeds
  Faith — with neither duration nor power moving.
- **LAYERED FAITH IS NOT SUBSUMED AND MUST BE READ BY THE GATE.** BM's bespoke path pre-adds the
  standing pool, so the recast is **additive**, always improves, and is never refused.
  **Interpose is the same shape** and is the one member of the set that can never refuse.
- **ONE RULE, NOT ONE STRING PER CARD.** No ability description says anything about a second cast:
  it is stated once in the **glossary** (`recast_refused`) and carried in the moment by the tell,
  which lives in `_ability_tooltip` — the one site every surface reads.
- **AN ABILITY THAT PROPOSES NO WRITE AT ALL IS NOT THIS GATE'S QUESTION** (Alms and Divine
  Presence in a kit without Mercy): the handler already logs why, and refusing there would darken
  a button with a reason this rule cannot state.
- **A STATUS DURATION IS DECLARED TWICE AND BOTH COPIES MUST MOVE (STANDING, FOUND AT CR §3).**
  The cast handler writes it, and **`_recast_writes` declares it again** so the gate can predict
  what a recast would do. Leave the table behind and the gate proposes a longer write than the
  handler performs, reads every recast as an improvement, and stops refusing altogether.
  **ANY EDIT TO A DURATION, POWER OR RIDER ON A `RECAST_GATED` ABILITY OWES THE SAME EDIT AT
  `_recast_writes`.**
- **A HANDLER THAT GUARDS ITS OWN WRITE NEEDS THE GUARD MIRRORED, NOT THE VALUE (STANDING, DA §2).**
  Every other member of the set calls `_apply_status` unconditionally and lets `add_status`'s
  `max()` discard the weaker value; **Glacial Prison does not** — it reads
  `if not target.has_status("chilled")` and never calls it at all. `_recast_writes` therefore
  proposes the Chilled half **only when it would land**, and the freeze half unconditionally.
  Get this backwards and the table reads its own optimism as an improvement.
- **AND A PROPOSAL MUST EQUAL WHAT A *GOOD* CAST WRITES.** `check_co` saturates by casting at
  grade `"good"`, so an entry proposing the PERFECT's duration improves on what is standing every
  time and the card never refuses. **A `special` carrying a POWER needs its own arm** rather than
  a `RECAST_SELF_PLAIN` row, because that table writes `power: 0`.
- **THE REFUSAL DARKENS A BUTTON, NOT A PICK, AND THAT BOUNDS WHAT IT CAN EVER BUY.** For a
  picked-target card the pool is every legal target, so the button dims only when **no** legal pick
  would improve. **That is the honest scope of the rule and not a defect in it** — a per-pick
  refusal would be a second path, which CO forbids: **one door, `_ability_usable`.**
- **`check_co.gd` IS THE ANTI-ROT PROOF AND IT IS A LIVE ONE.** It spawns **two** real battles
  (one party cannot write the whole set), casts every member onto every unit each can reach, and
  asserts the gate's prediction against what actually landed. It also asserts the excluded cards
  OUT by name.
- **KNOWN, RECORDED, NOT FIXED:** Battle Shout, Stabilize and Eye of the Storm call
  `update_status` with a *computed* power after `_apply_status`, and `update_status` **assigns**
  power where `add_status` maxes it — so on those three a weaker recast **overwrites the standing
  buff downward**. All three carry a second payload, so the refusal cannot reach them; widening
  scope to catch them would delete a resource conversion the player wanted.
### ADDING A NAME TO A TABLE IS NOT A CHANGE UNTIL THE MACHINERY REACHES ITS SHAPE (Batch DV §3)
> **Before recording that an ability "joins `RECAST_GATED`", drive the refusal live and watch it
> fire. That table reasons about STATUS writes; a payload of any other shape passes straight
> through it and the membership does nothing at all.**

`_recast_refused` asks `_recast_targets` for a pool and `_recast_writes` for the chips a cast
would lay. **`ashes` writes an integer FIELD**, so `_recast_targets` has no arm for it and returns
`[]`, the loop never runs, and the function returns **false with the card fully armed** — measured,
not reasoned. Adding the string to the list changes no behaviour; its only visible effect would be
`check_co` reporting the card as never exercised, **which reads like coverage.**
- **THE REFUSAL STILL GOES THROUGH `_ability_usable` AND THAT IS NOT A SECOND PATH.** That function
  is the door; `_recast_refused` is one condition inside it, and a bespoke condition beside the
  others (`overcharge`, `preparation`, `reckless_abandon`) is the same door. **A second path would
  be a refusal written at resolution, or in the popup builder.**
- **DO NOT INVENT A PSEUDO-STATUS TO CARRY A FIELD INTO THAT TABLE.** It puts a name in
  `_recast_refusal_note` that `STATUS_INFO` cannot render and the player holds no chip for.
- **AND THE BESPOKE CONDITION OWES THE TOOLTIP LINE, LIKE EVERY OTHER ONE.** CO §3's rule: a
  darkened button with no reason reads as a bug. Where the refusal has two genuinely different
  causes they get two sentences — an armed phoenix is a resource still held; a spent one is gone.

### THE AUTOPLAY HEURISTIC'S REFUSAL LIST IS AN ORACLE FOR PLAYER-DOOR GAPS (Batch DV §3)
> **The bot's rotation refuses things the player's door permits. Where the bot's guard means "this
> cast would do nothing", that is a defect in the door. Where it means "this cast is a bad idea",
> it is policy and must NOT be promoted into a refusal.**

`ashes` was found by accident during an audit of something else, and **`check_co` structurally
could not have found it: it saturates the MEMBERS of `RECAST_GATED`, so it measures the list rather
than the candidates for it.** The bot's list is the other half of that question and is free.
- **THE TEST IS THE HANDLER, NOT THE GUARD'S SHAPE.** Hold Breath's bot guard reads
  `not u.has_status("held_breath")` and looks identical to a waste refusal — but the handler also
  pays **+40 Focus**, so a recast is never nothing. Snare Trap also fires `_hit_and_run`; Renewal's
  Perfect pays a burst. **Refusing any of those is the strictly-worse bug arriving through the fix
  for the first one.**
- **AND THE BOT'S GUARD IS NOT AN EXACT ORACLE EVEN WHERE IT POINTS AT A REAL GAP.** Deadfall's
  `deadfall_armed <= 0` also refuses a part-spent or DORMANT deadfall, and a recast on either
  genuinely restores charges and clears the rest. **Derive the exact condition from the handler;
  the bot only tells you where to look.**

### THE VAULT'S EXIT IS THE POOLS, AND A VAULT ENTRY IS OWED ONE (Batch DY §3)
> **`Classes.vault_ability()` holds the ONE definition of ten live cards. Its exit is the draft and
> boss pools, and nothing else. A definition here that no pool names is reachable by NOTHING.**

`vault_ability()`'s own header promised for eighteen batches that its entries *"return as earnable
picks without a line of new mechanics"*. **THE PROMISE WAS TRUE AND THE EXIT WAS SHUT**: the only
route out was `CLASS_POOLS`, and AN §4 closed the draw that read it. Seven finished abilities sat
there, and **DK, DL and DM each spent measured engineering on one of them** — a widened heal driven
on a live bear, a widened Pressure clause with a new guard authored for it, a two-clause card read
in a scope audit — with nothing anywhere saying the cards were unreachable.
- **THE COST OF AN UNREACHABLE DEFINITION IS PAID BY EVERY SWEEP, SILENTLY.** All seven were in
  `ability_corpus()`, so the width gates, the text rules, `check_cn`'s bar criterion and
  `check_dw`'s two populations had all been auditing cards no player could obtain.
- **SO: A NEW VAULT ENTRY IS OWED A POOL IN THE SAME BATCH.** The header says so at the site.
  DY §1/§2 re-homed all seven and `CLASS_POOLS` was deleted behind them.
- **AND THE VAULT IS KEPT, BECAUSE IT IS NOT A HOLDING PEN ANY MORE.** It is the single-source
  definition table those ten cards resolve through; a second copy in a pool is the drift the
  resolver exists to prevent.

### ESTABLISH WHY A STRUCTURE IS DEAD BEFORE DELETING IT (Batch DV §1)
> **Dead code is deleted rather than zeroed — but a structure ORPHANED by a later change is a LOST
> FEATURE, and one that was never wired is scaffolding. Only the second is a deletion. The first is
> a design question, and answering it by deleting is answering it.**

**`CLASS_POOLS` is the worked example and it reads exactly like scaffolding**: 61 entries no run
can reach, and `run_state.gd`'s own comment saying nothing reads them. **It was live** — Batch AH's
award drew 1 from the spec pool and 2 from the class pool, and **Batch AN §4 re-pointed the award
and DELETED `roll_ability_offer`**, leaving the pools standing on purpose.
- **THE PROVENANCE IS THE TEST, NOT THE CURRENT REACHABILITY.** Both cases look identical today.
  Ask what deleted the reader, and name the batch; `test_batch_an` §1 asserting a function *absent*
  is the kind of evidence that settles it.
- **AND A DEAD STRUCTURE CAN BE THE LAST LISTING OF LIVE CONTENT.** Seven abilities were authored,
  resolving and fully implemented, and **`CLASS_POOLS` was the only list in the game that named
  them** — deleting the container would have deleted the record of the contents. **Before deleting a
  structure, ask what is reachable ONLY through it**, and count it.
- **THE WORKED EXAMPLE IS CLOSED AT BATCH DY §3, AND THE ORDER IS THE RULE IT LEAVES BEHIND.**
  **RE-HOME WHAT IS REACHABLE ONLY THROUGH A STRUCTURE BEFORE YOU DELETE THE STRUCTURE, AND IN THAT
  ORDER.** All seven went into live pools first — five draft, two boss — and the container was
  removed behind them, so `ability_corpus()` read **227 on both sides of the batch**. Deleting
  first would have dropped it to 220 mid-batch and moved the printed population of roughly fifteen
  gates for no reason at all, and every one of those movements would have had to be un-moved.
- **AND THE DELETION'S REAL COST WAS THE READERS, NOT THE CONTENTS.** Nothing in a run read
  `CLASS_POOLS`, and `pool_ability()` never consulted it — but **eighteen suites and gates did**,
  and a grep for the constant found only some of them: `class_pool()`, its accessor, had callers
  the constant's name never appears beside. **SWEEP FOR THE ACCESSOR AS WELL AS THE CONSTANT.**
  Each reader is re-pointed at the live structure that answers the same question, or inverted to
  assert the container's ABSENCE off the source (`test_batch_an`'s idiom for `roll_ability_offer`);
  **a check that survives deletion by asking an empty dict a question is worse than a red.**

## THE TRAPS — RULES THAT WERE BURIED IN BATCH BLOCKS (GATHERED AT BATCH CW §1)

**Every one of these cost a batch something.** They were stated inside a narrative and would
have been lost with it. **Live counts belong in `docs/state.md`; the rule is what is here.**
**THE INSTRUMENT HALF OF THIS SECTION IS IN `docs/instrument-rules.md`** under the same title —
gates that pass without asking their question, the `master.html` stamp gate, and the suites and
the harness. **The three below are the ones about the GAME.**

### A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS (Batch DR §2)
**A SUSPENSION OF A STANDING RULE MUST BE DELETED WITH ITS REASONS, NOT UPDATED AROUND THEM.**
`classes.gd` carried a comment suspending *"no ability may be a strictly better version of another
in the same pool"* over one card, **for two named reasons — and both reasons were later removed by
batches that had no cause to look at that card.** The acquisition channel died at DO (the ability
it was distinguished from became draftable); the Perfect died at CR (a suite asserts the `force`
argument gone). Neither batch touched the comment, so the exception stood for two batches reading
as a live decision.
· **A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS IS WORSE THAN AN UNDOCUMENTED ONE,
  BECAUSE IT READS AS DELIBERATE.** An undocumented one gets found by the next audit; a documented
  one gets believed.
· **THE SHAPE TO SWEEP FOR: "strictly worse, but acceptable because X and Y".** When a later batch
  deletes X or Y, nothing points back at the comment. Same species as the stale ~96 denominator CD
  swept, the `53 of 204` figure DJ pinned, and `_hold_freeze`'s header — which said THREE callers
  while there were four, and named a `force` no caller had passed since CR.
· **WHEN THE REASONS ARE DEAD, THE EXCEPTION IS DEAD.** DR deleted the comment AND retired the
  card rather than re-justifying either.
· **AND A COMMENT RECORDING A REMOVAL NAMES THE THING REMOVED**, so an absence check must strip
  comments first or the record reads exactly like the removal not having happened. `check_dr` §4
  strips, and its negative control puts the name back in a comment and confirms the gate stays
  quiet, then puts it back in code and confirms it reds.
· **AND THE MIRROR OF IT, WHICH COST BATCH DT A RED: A COMMENT EXPLAINING THAT A FILE DOES NOT DO
  X NAMES X, AND A FINGERPRINT THAT MATCHES ON X THEREFORE MATCHES THE COMMENT.** `check_ds`'s
  header set out to record that the gate does not hand-roll the ability corpus, spelled both of
  `check_da` §3's marks to say so, and `check_da` went red on the first run naming `check_ds` as a
  hand-rolled walk. **THE FIX IS NEVER THE EXEMPTION** — an exemption granted to a sentence blinds
  the rule to a real violation arriving in that file later. `check_da` solves it for its own source
  by splitting the literals at runtime; a COMMENT cannot concatenate, so the names stay out of the
  prose and the paragraph says why they are absent. **The general form: before writing a comment
  that names a banned string, ask whether anything greps for it.**

### NAMES THAT LOOK WRONG AND ARE RIGHT — NEVER "CORRECT" THEM
- **THE DEVOUT'S POOL KEY IS `inquisitor`, NOT `devout`.** `SPEC_INFO["inquisitor"]` carries the
  display name "Devout" and master.html's draft table prints "Devout", so **the docs and the code
  disagree BY DESIGN and have since the spec was named**. A `"devout":` key raises nothing,
  resolves nothing, and ships cards no hero can ever be offered — **it fails silently and costs a
  whole third of a batch**. test_batch_ce pins all three halves: the key present, `"devout"`
  absent, `SPEC_INFO` still displaying Devout.
- **THE SURVIVALIST'S SPEC ID IS `mystic` AND MUST NEVER BE RENAMED.** Saves and trees key on it.
- **`wild_communion_step` IS THE BEASTMASTER'S; `communion_ranks` IS THE DEVOUT'S. THEY ARE
  DIFFERENT SPECS AND SHARE NO COUNTER AT ALL.** They have been crossed once already. The trap is
  asserted in BOTH directions and `test_batch_ay` §6 walks both trees to prove the separation.
  **The ranked form `wild_communion_ranks` is RETIRED** — AY replaced it with the `_step` float
  and `test_batch_ay` pins it absent from `battle.gd`; this block named the dead one as the live
  field until ED.
- **A `_step` FIELD IS A FLOAT AND IS DELIBERATELY ABSENT FROM `Runes.STAT_INT_KEYS`**
  (`wild_communion_step`, `absolute_step`, `guardian_step`, `conduit_step`). Adding one there
  coerces 1.5 to 1 **with nothing crashing** — the payload silently pays a third less.

- **AN ENEMY ABILITY'S `"target": "ally"` MEANS *OWN SIDE*, NOT "somebody else" — AND THERE IS NO
  `"self"`.** `Ability.Target` is `{ENEMY, ALLY}` and `Enemies.config` maps the literal string
  `"ally"` and nothing else, so **`"target": "self"` is silently unmapped and falls through to
  `Target.ENEMY`** — a boss authored that way wards a hero. **Every self-cast in the game is
  tagged `"ally"`**: the Bog Troll's Regenerate, the Ritual Chanter's Cleansing Rite, the Grave
  Totem's Dark Vigil, and the Hollow Crown's Regalia. **The unit a support cast lands on is chosen
  in `_enemy_support_action`, not in the data** — re-point a cast there, never in the JSON.
- **A PAYLOAD SHARED BY TWO ABILITIES MUST LOG `ab.display_name`, NEVER A LITERAL NAME.** The
  `enemy_shield` branch printed the string "Shielding", which was harmless while one ability used
  it and became a lie the moment a second did — the Hollow Crown announced its Regalia as the
  Shieldmaster's card. **`_resolve_special` has `ab` in scope at every branch; use it.** A message
  that names the caster twice ("X shields X!") is the same tell that a branch never expected a
  self-cast.

### THE SHELL, THE ENGINE AND THE FILES
- **ZSH DOES NOT WORD-SPLIT UNQUOTED EXPANSIONS: A BATTERY SCRIPT MUST HOLD FLAGS IN AN ARRAY,
  NOT A STRING.** `fps="--fixed-fps 12"` passed as bare `$fps` reaches Godot as ONE token, the
  flag is rejected, and the suite silently runs at the default step — reporting failures that read
  as real. Use `fps=(--fixed-fps 12)`. **The bash habit silently under-runs the one suite that
  most needs the flag.**
- **`\n` IN A GDSCRIPT STRING IS TWO CHARACTERS, SO A `\bword\b` REGEX SILENTLY FAILS ON EVERY
  HAND-WRAPPED TOOLTIP.** The `n` of the escape is a WORD character, so `"this\nbeast's own gift"`
  has no word boundary before the word — and a rename pass skips exactly the multi-line
  descriptions that matter most. **Mask escapes to a non-word sentinel first, and add an ALL-CAPS
  rule.** Found by re-running the survey afterwards, not by the pass reporting anything:
  **a rename script that silently does 90% of the job looks identical to one that worked.**
- **EVERY `data/*.json` FILE IS TAB-INDENTED, so `json.dumps(..., indent=2)` REWRITES THE WHOLE
  FILE** — a one-entry glossary edit came out as a 1,966-line diff that buried the change. Use
  `indent="\t"` and `ensure_ascii=False`, and **ROUND-TRIP FIRST**: dump the unmodified parse and
  assert it equals the file byte for byte before writing. Nothing asserts a data file's whitespace.
- **A REFERENCE COUNT OF ZERO IS NOT EVIDENCE A FILE IS DEAD**, and it was wrong four ways in one
  audit, every one of which would have broken the build. (1) **Sprite paths are BUILT at runtime**
  (`"%s/%s_%s.png" % [...]`), so sixteen of twenty sprite files are named nowhere in source **and
  the parse gate still passes** after deleting them. (2) **A `class_name` global is reached by
  NAME and has no `preload` to find** (`Profile`, `Enemies`, `Glossary`, `GlossaryPanel`).
  (3) Two files can reference only each other, a closed loop with nothing pointing in, and both be
  live. (4) A font's `OFL.txt` is its LICENCE and may not be removed at any reference count.
- **NEW `class_name` FILES NEED `--headless --import` BEFORE THEY RESOLVE.**
- **GDScript gotchas that bit us:** multiline lambdas in call args (use named methods); ternaries
  need parens for type inference; `:=` can't infer from untyped funcs; edits via python heredocs
  (apostrophes! — use `chr(39)`); `min()`/`max()` are numeric-only, and **String args are a
  runtime error mid-`_init` that leaves a headless `--script` run idling forever** — compare with
  `<` instead. Children added in a SceneTree script's `_initialize` never fire `_ready` (root not
  ready) — park scene-spawning tests on the first `process_frame`.

## Architecture (all UI built in code, no editor scenes)
- `scripts/run_state.gd` (autoload `Run`): party/items/gold/the LINE/zones,
  save (user://run_save.bin v12, auto-saved after every slot), relic slots
  (max 3), the offer table (MODIFIERS/REWARDS), merchant+event scheduling,
  and the ability-upgrade pool.
- `scripts/settings.gd` (autoload `Settings`): volume/fullscreen.
- `scripts/classes.gd`: hero configs, core kits, spec info/abilities, passives.
- `scripts/talents.gd`: 12 fixed trees, each 3 lanes x 7 exclusive ROWS + a
  capstone row (Batch AI). {id: ranks} learned dicts (ranks always 1 now).
  `apply_payload` shared with shop runes, and the ONE read site for a
  payload's `condition`. Owns `ability_names` (Run.owned_ability_names
  forwards to it — autoloads don't resolve inside a class_name script).
- `scripts/relics.gd`: permanent unlocks (user://relics.json), 1 per boss kill.
- `scripts/battle.gd`: the big one — initiative timeline, Pressure/Break,
  skill checks, statuses, AoE/random-hits, damage types + resists, items,
  sim/autoplay modes, victory/defeat flow.
- `scripts/unit.gd`: combatant node (sheet animations, bars, status chips,
  bleed buildup meter, outline shader hover).
- Screens: main_menu → draft (pick 4 + relics) → spec_choice (permanent) →
  map (THE hub: the road, four hero cards, potions, burger) → offer (before
  every elite/mini-boss) → battle → sometimes shop and/or event → back to map.
  party.tscn is the HERO SHEET now, opened from a card.

## STANDING RULES — TALENTS ARE META PROGRESSION (Batch BM)
**BUYING A CELL UNLOCKS AN OPTION. IT DOES NOT EQUIP IT.** This is the load-bearing rule of the
whole talent system and it is the one a later batch would most easily collapse. A CELL is a
(spec, node) pair bought ONCE, permanently, out of that spec's banked points on `Profile`.
EQUIPPING is a separate act and it is what a run reads: **you still pick ONE node per row, and
it locks for the run.** Owning all three cells in a row makes that row a real three-way
argument; owning one leaves no argument in it. **THAT IS WHY TWENTY BATCHES OF ROW PRICING
DESCRIBE THE ENDGAME RATHER THAN NEEDING A THIRD PASS** — a row is still priced against two
closed doors. Collapsing the two into one click turns every tree into a checklist and throws
AJ-through-BA away. `Talents.can_buy` and `Talents.can_equip` are separate questions on purpose;
test_batch_bm's negative control 1 builds the collapse and proves it is rejected.
· **EARNING** — 1 point per spec per ZONE BOSS defeated (3 a completed run; a zone-2 wipe still
  banks 1 or 2, and that partial credit is the mechanism, not a rule). Only specs that PLAYED
  earn. Points are PER SPEC and never transfer; banking is uncapped. **NOTHING IN A RUN AWARDS
  ONE** and the END BOSS awards none either — it awards a relic and opens rows.
· **SPENDING** — cells cost by TIER: rows 1-3 cost 1, rows 4-6 cost 2, rows 7-9 cost 3.
  **27 cells = 54 points a spec = 18 completions.** `Talents.tier_of_row` / `cell_cost` /
  `rows_unlocked` are the ONE place any of it is decided.
· **RESPEC** — free, any time OUTSIDE a run, NEVER during one. The build screen's `_locked()`
  is the gate and every mutator re-checks it.
· **ROW GATING IS GLOBAL** — rows 1-3 at difficulty 1, 4-6 at 2, 7-9 at 3, for EVERY SPEC AT
  ONCE. Points are per spec; rows are not. A tier arrives FULLY unlocked, which is what an
  uncapped bank is for. A fresh save has NO rows, NO points and no talents at all.
· **VERSIONS** — `Profile` is **v2** (tolerant load: a v1 profile arrives at tier 0 with zero
  points, the correct state). The run save is **v12** and **a pre-v10 save is REFUSED and
  cleared** (the final zone gained a 17th slot; a v9 map has no position after its boss).
  **v11 (CT) and v12 (EG) ARE BOTH TOLERANT AND NEITHER MOVED THE REFUSAL THRESHOLD** — the
  threshold is a claim about a structure this build cannot walk, and a version bump for a field
  with a sane default is not one. **DO NOT RAISE THE THRESHOLD TO MATCH THE VERSION.**
· **DELETED, NOT ZEROED** (each pinned ABSENT in test_batch_bm): `Run.award_talent_points`,
  `Run.award_spec_point`, `member["talent_points"]`, `member["talent_flex"]`,
  `Talents.can_learn`, `Talents.purse_for`, `Talents.points_spent`, `MAX_PER_ROW`, the events
  verb `talent_points` and both relics' `start_talent_points` hook. **`Run.tally` never had a
  talent counter** — checked, not assumed; the brief expected one.
· **SUPERSEDED FIGURES, NAMED AS SUPERSEDED: BK's 10.9 / 10.8 / 6.0 talent points per hero per
  run, and every "nodes owned entering a boss" reading before BM.** They measured a per-run
  purse that does not exist. Never compare a post-BM number against them.
· **THE HANDOFF** is `Run.equip_spec_talents(idx)`, called from BOTH paths (the spec screen and
  RunSim.start_run — the sync_spec_hp pattern). A real run reads `Profile.equipped_talents`; a
  SIM reads `Run.sim_talents`, installed by `RunSim.install_builds`. **RunSim CALLS Profile
  nowhere at all** — a sim that read the player's ledger would make every baseline depend on
  whoever ran it.

## STANDING RULE — A RELIC SETS UP THE RUN; A TALENT CHANGES WHAT A SPEC DOES IN A FIGHT (Batch EN §4)
> **Both are permanent meta-progression, and nothing in the project said what each was FOR.
> The read site is what separates them, and it separates them cleanly.**

**THIS IS DERIVED FROM THE CODE, NOT ASSERTED.** `relics.gd`'s own header names every hook and the
ONE site each is read at, and the sites are: `new_run` (the opening purse and pouch), **battle
SPAWN** (base stats, written before turn one), the victory screen, `award_gold`, rest nodes, shop
prices, elite spoils. **NOT ONE RELIC HOOK IS READ WHILE A TURN IS RESOLVING** — swept over all
25 read sites of `relic_add` / `relic_dict`, which land in exactly `_spawn_units`, `_check_end`,
`new_run`, `award_gold` and the three shop-price copies. And the header's own
*"NEEDS PLUMBING (declared out for now)"* list — on-kill and per-turn procs, revive-on-death,
enemy-side auras, DoT-tick and Break-damage multipliers — **is precisely the in-combat category.**
A talent counter, by contrast, is a `BattleUnit` field read inside `battle.gd`'s combat math, and
the talent trees are **the only meta layer that reaches a turn as it resolves.**

**THE SECOND AXIS FOLLOWS FROM WHEN EACH IS CHOSEN.** Relics are assigned at the DRAFT, **before
specs are chosen**, so a relic *cannot* be about a spec — it is party-wide by construction rather
than by preference. Talents are copied off `Profile` the moment a spec is confirmed and locked for
the run, so a talent can only be about that spec.

**THE RULE FOR A FUTURE AUTHOR, AND THE TELL IS THE READ SITE:**
- **If the effect must be read while a turn resolves, or must know which spec the hero is, it is a
  TALENT.** It costs points, it is bought per spec, and it is gated behind a difficulty rung.
- **If it sets the run up — the purse, the pouch, the shop, the spawn line, what a victory pays,
  what an elite drops — it is a RELIC.** It is earned automatically, it is party-wide, and adding
  one on an existing hook is **pure data**.
- **If it is this run's kit rather than this account's — a stat, a resource, or the mechanics and
  values of a core ability, draft ability or passive — it is a RUNE** (the charter, Batch EM).
  Runes are the run-scoped, per-hero, bought layer between the two permanent ones.
- **A NEW HOOK IS A BIGGER DECISION THAN A NEW RELIC.** Every hook is read at exactly one site by
  construction; a second read site for one hook is how the vocabulary stops being auditable.

**WHAT THIS RULE DOES NOT DECIDE.** It says what each layer is FOR; it does not say a relic must
stay party-wide. **THE PER-HERO RULING (a relic assigned to one hero at pickup) STANDS AND IS
UNBUILT** — see the relic block in `docs/state.md`, and note that four hooks (`victory_heal_pct`,
`victory_mana_pct`, `rest_heal_add`, `resource_floor_pct`) need a ruling before any of it, and that
the draft assigns relics before there are specs to assign them to.

## STANDING RULE — WHAT MAKES A ROW-8 NODE (Batch BM §2), AND BH'S FIFTEEN POINTS
**ROW 8 IS THE NODE THAT ONLY MATTERS ONCE THE REST OF THE LANE IS BOUGHT — a payoff that reads
the build itself rather than adding to it.** Every future node authored into row 8, and any node
authored anywhere, must do ONE of these: **READ an accumulated quantity** the lane has spent
rows building and pay off its DEPTH rather than its existence; **REMOVE a constraint** the lane
has been working around all game; or **CONVERT** the lane's currency into something it could not
previously buy. **IT MUST NOT BE A LARGER MAGNITUDE OF ANY NODE ABOVE IT.** A lane whose every
node multiplies the same term is one node with several prices (BC diagnosed it, BH proved it).
**THE TEST IS MECHANICAL AND IT SHIPS: test_batch_bm fails any row-8 payload that writes a stat
field an earlier node in the SAME LANE writes.** A shared field is the signature of a re-skin.
**AND BH'S FIFTEEN-POINT RULE IS A STANDING TEST FOR ANY NEW NODE:** under leave-one-out, no
single node should move its lane's headline by more than about fifteen points. Read it with BH's
three caveats (a lane that does little passes trivially; a compounding lane under-reports every
node in it; a FLAT grid on a lane that does something is a finding, not a null result).
**THE LANE THIS IS OWED ON AND WAS NOT RUN: Harmonic Convergence (Arcanist, Resonance row 8).**
It reads the build rate, and AT §3 measured that build rate beats per-stack value QUADRATICALLY
on a triangular curve. One `DOD_SIM_TALENTS` string with the id withheld is the whole harness.

## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS (Batch BM §5/§6)
**`Run.difficulty` WAS REUSED, NOT SHADOWED** — it was already a saved String var chosen at the
draft and armable from `DOD_SIM_DIFFICULTY`, already folded into ONE multiplier at
`zone_base_mult`. What changed is the TABLE it keys into (`Run.DIFFICULTIES`). Batch Y's ids
still resolve: **"standard" maps to rung 2**, the rung it was tuned at, so every old script and
Matrix row reads. **EVERY SCALING NUMBER IS PROVISIONAL** — balance is deferred by designer
decision and the STRUCTURE is what shipped.
· **rung 1 Wanderer x0.50 (BATCH BN §2 — WAS x0.70, AND THE NEW NUMBER IS THE ONLY THING ON
  THIS LADDER CHOSEN BY MEASUREMENT).** DELIBERATELY BELOW the present balance, because this is
  the rung played with ZERO talents and it is the gate the whole meta layer sits behind. BM
  reused Batch Y's 0.70 — a float picked for the Wanderer affordance, not for this job — and an
  untalented party completed **12-13%** at it, i.e. eight attempts before the first unlock with
  nothing banked in between. **SWEPT AT n=100 A ROW, untalented (`DOD_SIM_ROWS=0`), balanced:
  x0.70 13% | x0.60 28% | x0.50 83% | x0.40 95%.** 70% (a first run won in one or two attempts)
  is the target; 0.50 is the closest of the four. **THE CURVE IS A CLIFF between 0.60 and 0.50
  — 55 points across one step — so 70% sits in an unsampled gap and 0.50 is "the nearest
  sampled value", not a number to defend to three figures.**
· **rung 2 Warden x1.00** — the present balance BYTE FOR BYTE, so every BK row still describes
  it. Twist: **the severity floor rises** (`roll_offer` reads `difficulty_def().severity_floor`
  instead of a constant 2), so the guaranteed mild bargain option may be severity 3.
· **rung 3 Ruin x1.30** — floor rises again, plus **FIXED ENCOUNTERS CARRY A MODIFIER**
  (`Run.arm_fixed_modifier`, armed at BOTH walk sites): the mini-boss and every boss, the nodes
  a route cannot duck. It is NOT a bargain — no offer, no choice, NO REWARD.
**THE END BOSS is a 17th slot on the FINAL ZONE'S BOARD, so a run is 49 encounters** (BK settled
on 48). `END_BOSS_SLOT` / `END_BOSS_KIND` / `total_slots()`. It is **FIXED, not composed** (the
one node whose lineup does not come out of the budget system), so it can be learned, and it
**gains stats AND MECHANICS with difficulty** — `Enemies.config(kind, rung)` drops any ability
tagged `"rung": N` below that rung, and **the end boss is the only user**; every other kind reads
identically at every rung. It awards a relic ALWAYS, no ability pick, no talent points, and
**`Profile.note_end_boss(rung)` is what opens the meta tree's row tiers.** ZONE BOSSES — the
third included, which used to BE the end boss — now pay a point, a relic and an ability pick and
open what follows them.

### THE STARTER RUNG IS A META-PROGRESSION GATE AND MAY NOT BE REMOVED AS A BALANCE CHANGE (STANDING, EN §3)
> **Rung 1 is not the easy difficulty. It is the only door into the talent trees, and a fresh
> profile has to walk through it with nothing.**

**EN WAS ASKED TO REMOVE IT AND STOPPED, WHICH IS WHAT ITS OWN BRIEF INSTRUCTED ON FINDING A GATE.**
The chain is four links and every one of them is in the code:
`battle._resolve_boss` → `Profile.note_end_boss(Run.difficulty_rung())` → `talent_tier = rung` →
`Talents.rows_unlocked(tier)` off **`TIER_ROWS [0, 3, 6, 9]`**. **TIER 0 OPENS NO ROWS AT ALL**, and
`Talents.can_buy` refuses every locked cell with *"Locked: beat the end boss on difficulty N"*. So
**clearing rung 1 is the only thing in the game that opens rows 1-3 of all twelve trees**, and it
opens them for every spec at once.
- **THE MEASUREMENT THAT DECIDES IT, TAKEN AT EN ON THE LIVE TREE** (`DOD_SIM_ROWS=0`, `--run 30` a
  rung — BN's own instrument, re-run): **untalented completion is 97% at rung 1, 3% at rung 2 and
  0% at rung 3.** Removing rung 1 moves the first meta unlock from a one-attempt clear to roughly
  a thirty-attempt one. **That is the exact state BN §2 measured at x0.70 (13%) and deliberately
  fixed by choosing x0.50.**
- **THE "IT IS BORING" CASE IS TRUE OF A POPULATION THAT IS NOT THE ONE PLAYING IT.** The 100%
  bot completion at rung 1 comes from a sim party that is **FULLY TALENTED** (`rows=9 of 9`, CY's
  own named confounder, re-confirmed at EN: 100 / 80 / 80% across the three rungs at n=20).
  **A fully-talented bot has already been through the gate the rung exists to be.**
- **RELICS ARE NOT BEHIND IT.** `Relics.unlock_random()` fires on every boss kill at every rung
  (`battle.gd` `_resolve_boss`, both halves), so the relic ladder is difficulty-independent and
  would survive a removal. **The talent ladder would not.**
- **AND A REMOVAL RENUMBERS.** `def["rung"]` IS the talent tier index — `draft_screen` advertises
  each rung's unlock as `rows_unlocked(rung - 1) + 1 .. rows_unlocked(rung)`, `enemies.json` tags
  two end-boss abilities `"rung": 2` and `"rung": 3`, and `Enemies.config(kind, rung)` drops
  anything above the rung played. **Re-homing an unlock is a design decision and it is not a
  batch's to take.** `run_state.gd` already refuses a pre-v10 save; **do not invent a second
  refusal path for a renumbered ladder.**

## STANDING REFERENCE — ENEMY INTENT: ONE DECLARED-ACTION STORE, THREE RE-VALIDATION BRANCHES (Batch BL §1)
**DECLARE ON SCHEDULE, RESOLVE ON TURN.** `_choose_enemy_action` is the SELECTION half lifted out
of `_enemy_turn` **byte-for-byte** — only *when* it runs moved, and a diff touching the rules
inside it breaks that promise.
· **Declaration**: `_declare_intent(u)`, called from `_declare_all_intents()` at battle start
  (after the opening oath/Faith hooks, which move state the policy reads), from the turn loop
  **right after** `await _enemy_turn(u)` — **NOT from the bottom of `_enemy_turn`**, which has
  eight returns, and a declaration owed on all of them is a declaration owed by the caller — on
  each lost-turn branch after the discard, and in `_hold_release`.
· **Re-validation** at resolution, `_revalidate_intent(u)`, in this fixed order: (1) target gone
  → **re-target within the SAME ability**; (2) ability unusable → fall back to `_cheapest_attack`
  **AND LOG IT** (a silent substitution is the intent system lying); (3) cannot act →
  `_discard_intent`, **DISCARDED NOT BANKED**. **READ THE TARGET UNTYPED FIRST** — a declared
  companion can be `queue_free`d between declaration and resolution, and a typed assignment of a
  freed instance errors BEFORE `is_instance_valid` can run.
· **A FOURTH counter, deliberately not one of the three**: `intent_hijacked` — Hysteria, Bewitch
  and Psychosis take the turn, so the unit ACTS but not as declared. Counted at the moment each
  branch COMMITS, never on the status alone.
· **THE `charging` STATUS IS THE SAME MECHANISM, NOT A SECOND ONE.** The wind-up stores its blow
  in `intent` like everything else. `_declare_intent` returns early on `has_status("charging")` —
  that ONE line is why a charging enemy declares once, not twice. **A later batch wanting a
  multi-turn declaration sets `intent.turns` and adds a chip. IT DOES NOT ADD A SECOND STORE.**
· **Counters go through `_istat`, NOT `_stat`** — unconditional, not sim-gated, because the
  re-validation rates are a property of the MECHANISM and must be observable in real play.
· **Categories are DATA-DRIVEN** (`_intent_category`): windup → mend → ally-target → aoe →
  `pressure > damage` → applies-status-and-not-this-unit's-hardest-hit → strike. **Order IS the
  classification**, so an enemy added to `enemies.json` classifies itself and there is no name
  table.
**NO PREDICTED DAMAGE NUMBER MAY SHIP, AND THAT IS A FINDING RATHER THAN AN OMISSION.** The strike
block fails on two counts, either fatal alone: it MUTATES on the way through (`crit_streak`,
resource restores, `float_text`, three ledgers), and its FIRST line is `randf_range(0.9, 1.1)`
with a crit rolling inside it — **the same call with identical inputs returns a different
number.** Icon plus the ability's own name is shown instead, read off the declaration so it cannot
drift. **`test_batch_bl` greps the intent block for `attacker.attack` / `effective_armor` /
`randf_range` / `resists.get` and fails if a later batch adds a preview by reimplementing the
maths.**
· **HIDDEN INTENT IS FLAGGED, NOT BUILT** — a good mechanic and a DIFFERENT one; author it once
  the baseline is legible.
· **STATE-SENSITIVE POLICIES NOW READ THE BOARD ONE TURN EARLIER**, reported and corrected
  nowhere: `_enemy_support_action`'s thresholds, the Broken-hero exploit (the most sensitive — a
  Break window is short and a declaration made before it opens will not take it), `_lowest_hp` /
  `_threat_pick`, the taunt narrowing and the presence rolls. **Selection logic itself is
  untouched; an AI rewrite is out of scope.**

## STANDING REFERENCE — THE RECAP LEDGERS AND THEIR BOUND (Batch BL §2)
**DAMAGE TAKEN HANGS OFF ONE DOOR: `BattleUnit.damage_taken_cb`**, fired by `_report_taken` from
the only two places health leaves a unit (`take_hit`, `take_tick_damage`). It reports the **DELTA,
not the argument** (a 52 into a hero on 40 is 40 taken, or the column disagrees with the health
bar) and sits **BELOW ALL FOUR DEATH-REFUSALS** — above them it would count health handed straight
back AND file a refused death as a killing blow. **A future damage source cannot forget to report:
it cannot remove health without one of those two functions.**
· **ATTRIBUTION IS A FRAME**, `_dmg_frame(src, label, src_name)`, set at **`_resolve`'s entry** —
  one site covering the strike, its splash, echoes, the reflect/retaliation it draws and the
  recoil it costs — **re-established after each nested `await _resolve`** (a counter leaves the
  frame pointing at itself) and set explicitly at the DoT tick loop, from the status's `src_name`,
  because the applier may be dead. **SELF-INFLICTED IS DECIDED BY IDENTITY** (`victim ==
  _dmg_src`), which covers Blood Price, Dark Pact and recoil in one rule and cannot go stale the
  way a name list would.
· **BY KIND, NEVER BY INSTANCE** — `_taken_source` reads `BattleUnit.enemy_kind`, stamped AFTER
  the "boss" alias resolves. `unit_name` happens to agree today; keying on that agreement would
  make the aggregation an accident the first uniquely-named enemy breaks.
· **THE BOUND: `TALLY_KEYS_PER_HERO = 24` rows per hero per map, INCLUDING the `(other)` row**;
  `TALLY_KILLS_MAX = 12`, oldest kept. **Overflow FOLDS into `(other)` rather than being
  dropped** — the total stays exact and only the breakdown gets coarser, which is the right way
  round when the panel reports a top five.
· **Banked by `_bank_run_ledgers()`**, from `_check_end`'s run branch AND from `_do_forfeit` (a
  forfeit never reaches `_check_end`, and the abandoned fight is exactly what the tester wants
  explained). **Idempotent** — it clears the slices as it banks.
· Renderer `_append_breakdown(...)` is written ONCE and called TWICE (whole run, final battle);
  everything goes into the SAME line list `_summary_plain_text` walks, so the Copy button stays
  complete. **Not a defeat-only screen** — wipes, forfeits and completions all get it.
## STANDING RULE — FIFTEEN POINTS UNDER LEAVE-ONE-OUT IS WHAT MAKES A LANE A LANE (Batch BH §2)
**If withholding any single node moves a lane's headline contribution by more than about fifteen
points, that lane is not a set of choices — it is ONE choice with several prices, and no amount
of re-pricing will make it behave.** BC's grid had Communion at THIRTY-THREE on the Devout's
Faith lane, and four consecutive batches then tuned magnitudes on a lane whose fault was its
shape. This is a test you can run on a tree before anybody plays it, and it is cheap:
`DOD_SIM_TALENTS` with one id withheld is the whole harness.
**TWO CAVEATS THAT MUST TRAVEL WITH IT, both learned by running it (BH §2):**
· **A LANE THAT DOES LITTLE PASSES TRIVIALLY.** No node can move a headline by fifteen points
when the whole lane is worth three above ungeared. Read the grid against the lane's own
distance from the ungeared floor, never as an absolute.
· **THE GRID UNDER-REPORTS EVERY NODE IN A COMPOUNDING LANE.** Where several nodes multiply the
same term, withholding one leaves the others multiplying, so each reads small and the total is
large. BC measured Binding Oath at one point on exactly this lane. **A small leave-one-out
number is evidence of a node's marginal worth, NOT of its structural role.**
· **A THIRD CAVEAT, ADDED BY BATCH BI §1, AND IT IS THE ONE THAT NEARLY GOT MISSED: A FLAT GRID
ON A LANE THAT DOES SOMETHING IS A FINDING, NOT A NULL RESULT.** BH's grid moved by at most one
point in any cell and read as "the lane is fine, just small". It was the signature of the
antagonism in the standing rule directly below — every node's contribution was being eaten by
its neighbour's — and no amount of re-pricing would have found it.

## STANDING RULE — HELD VALUE AND SPEND FREQUENCY ARE ANTAGONISTIC ON A SINGLE METER (Batch BI §1)
**A resource that both (a) pays something while HELD and (b) is CONSUMED at a threshold has two
effects reading one number and wanting opposite things from it: the spend wants it empty, the
held value wants it full.** Whatever you do to one, you pay for on the other. **DO NOT ADD A
"SECOND AXIS" TO SUCH A LANE BY GIVING A NODE THE HELD HALF: that is not a second axis, it is a
second price on the first one.**
**THIS IS THE SAME FAULT BC DIAGNOSED, ARRIVED AT FROM THE OPPOSITE SIDE.** BC found nodes all
pushing one number the SAME way and called it one node with eight prices; this is nodes pushing
one number AGAINST each other. **DIRECTION IS NOT THE TEST. SHARING THE NUMBER IS THE TEST** —
two effects that read the same term are one effect with two prices, whichever way they push it.
**THE TEST, BEFORE ADDING ANY SECOND AXIS: ask what the new axis READS.** If it reads state the
first axis mutates, it will compound or cancel and which one is only a matter of sign.
**THE REPAIR SHAPE, FOR WHEN THIS RECURS: give the second effect its own DERIVED quantity rather
than the meter.** BI's `faith_peak` is the Devout's — a high-water mark that rises with the count
and does not fall when a spend empties it, so frequency and depth can both be real. **DO NOT
RE-COUPLE THEM.** Faith's held half must never read `faith_stacks` again; that is
test_batch_bi's first negative control, and the mis-write reads as a smaller number rather than
as a bug.

## STANDING DESIGN RULE — THE CONTAGION SPACE IS RESERVED (Batch BA §1)
**A future spec is planned whose fantasy is DISEASE AND VIRALITY. Nothing self-propagating
may be authored into the Survivalist's tree, or into any existing spec, until that spec is
built.** Off-limits: transmission between enemies, transmission from a corpse, field-wide
infection — anything that spreads WITHOUT the hero acting. **POISON ITSELF IS NOT RESERVED
AND STAYS ENTIRELY THE SURVIVALIST'S**: poison is craft — curare, hemlock, a blade wiped on
the right leaf. The distinction to hold is *a hunter who knows which plant does what* versus
*a plague that no longer needs him.* This is recorded as a RULE rather than as four edits on
purpose: without it a later batch re-adds "spreads to another enemy" innocently and spends
the new spec's idea a second time. **BA re-specced four nodes off it** — Epidemic (capstone,
every enemy permanently Poisoned), Plague Bearer (rot leaps enemy to enemy), Creeping Death
(a corpse passes its stacks to the living) and the NAME Virulence (a pathogen term). SNARES
and GUERILLA were never disease and are untouched by the rule.

## STANDING REFERENCE — THE DEBUG SURFACES, ALL OF THEM IN ONE TABLE (Batch BJ §1)
Half of these were documented only in changelog entries; this is the record. Not for deletion.
**Gate for every UI surface: `Run.debug_enabled()`** = dev build OR `DOD_DEBUG=1` (exported),
and `DOD_DEBUG=0` FORCES it shut; every use trips `Run.debug_used` → the run summary's "not a
clean data point" line. Sims can never reach the UI surfaces (`_debug_allowed()` excludes
sim/autoplay/sim_run).
· MAP BURGER debug items (map_screen, ids 10-16/20-26): +200 Gold | +200 Talent Points (all) |
  Full Heal Party | Jump to Boss Slot | Advance to Next Zone | Reroll Specs | "All Spec
  Abilities Unlocked" check = `Run.debug_grant_all`, the PRE-GRANT toggle (spec-scoped, AU §5;
  also armable headlessly via `DOD_SIM_GRANT_ALL=1`) | Free Travel check =
  `Run.debug_free_travel` | Test-a-Node submenu: Shop / ??? Event / Fight / Elite / Mini-boss
  (in place, `Run.debug_summon` books nothing).
· BATTLE `DEBUG ▾` menu (battle.gd, dev builds, not sim/autoplay): Full Restore | Kill All
  Enemies (a switch, not a hit — on-death procs reading a killing blow do not fire) |
  Cooldowns OFF (check) | Enemy attacks OFF (check; armable headlessly via
  `DOD_ENEMIES_OFF=1`) | per-hero Turn Lock (radio).
· ENV FLAGS, sim family (defaults in parens): `DOD_SIM` (battle count, standalone),
  `DOD_SIM_SWEEP` (budgets 3/6/9/12), `DOD_SIM_RUN` (full runs), `DOD_SIM_SPECS` (party,
  warrior/mage/cleric/hunter order), `DOD_SIM_ENEMIES` (forced lineup), `DOD_SIM_ZONE` (roster)
  / `DOD_SIM_THEME` (one theme) / `DOD_SIM_BUDGET` (def 6, standalone), `DOD_SIM_TALENTS`
  (force-learn ids), `DOD_SIM_ABILITIES` (append pending/pool abilities by name),
  `DOD_SIM_GRANT_ALL`, `DOD_SIM_ROTATE` (all twelve specs), `DOD_SIM_ROUTE`
  (greedy|default|cautious|elites — one walk since AN), `DOD_SIM_SHOPS`/`DOD_SIM_ITEMS`
  (economy policies, def on), `DOD_SIM_BUILDS` (def each tree's FIRST lane — the BG confound),
  `DOD_SIM_TROPHIES`, `DOD_SIM_RELICS`, `DOD_SIM_RUNES` (full|stats|off, def full),
  `DOD_SIM_RUNE_ECON=rich` / `DOD_SIM_RUNE_POWER=<mult>` (AD experiment arms, double-gated on
  Run.sim_run), `DOD_SIM_DIFFICULTY` (wanderer|warden|ruin = rungs 1-3 at x0.50 / x1.00 /
  x1.30, "standard" aliases warden; **DEFAULTS TO RUNG 1** — set warden for a baseline row),
  `DOD_SIM_DEBUG` (echo the combat log in sim mode — the hang discriminator).
· ENV FLAGS, non-sim: `DOD_AUTOPLAY` (1 debug battle, echoes "[LOG]"; never exits on its own —
  timeout/kill it), `DOD_DEBUG` (above), `DOD_ENEMIES_OFF` (above), `DOD_ZONE_ROTATION`
  (randomize zone draws within slot pools).
· RETIRED, and **the record lives in `sim.sh`'s header and master.html — the sim prints no
  retired line and `scripts/` names none of them**: `DOD_SIM_MAP`, `DOD_SIM_MINIBOSS`,
  `DOD_SIM_START_RUNE`, `DOD_SIM_SPEC_OPENING` (Batch AN, with their features). ED corrected
  the report-header claim.

## STANDING REFERENCE — THE UNCAPPED-METER GOVERNOR TABLE (Batch BJ §3b)
Six ratcheting accumulators exist; every governor was VERIFIED AT ITS SITE this batch. No
meter is ungoverned. meter | what governs it | where the governor lives:
· **Overburn's field total** (burn turns, uncapped) | **REWRITTEN AT BATCH BS, NOT AMENDED —
  ITS OLD ENTRY ASSERTED THE ASYMMETRY AS THE GOVERNOR AND THAT CLAIM IS NOW FALSE.** BJ read:
  "the BONUS caps at +40 while the DRAIN never caps — the asymmetry IS the governor,
  over-lighting is how he loses". **THERE IS NO DRAIN.** The governor is now a **PLAIN FLAT
  CAP** and nothing lifts it: +2% a burn-turn to +40%, full stop. `_overburn_capped`,
  `_overburn_drain` and `_overburn_tick` are DELETED, so a meter that keeps climbing simply
  stops paying past 20 burn-turns and costs nothing to hold. **THIS IS THE ONE GOVERNOR IN THE
  TABLE THAT IS A CEILING RATHER THAN A COST**, and that is deliberate — the cost was the fault
  BS removed | `_overburn_mult` (the ONE place the cap is decided), OVERBURN_STEP/CAP consts.
· **Loyalty** (per beast, no ceiling) | the beast's DEATH breaks the meter (Steadfast Bond
  keeps a share); plus BOND_MITIGATION_MAX 0.75 clamps Savage Presence so an uncapped boon can
  never heal the hunter off enemy hits | `_on_beast_death` battle.gd ~21730; the clamp const
  beside BOND_STEP ~13300-13345; `_loyalty_cap` returns the LOYALTY_UNCAPPED sentinel (only Wild
  Rotation hands it a number — the cap IS that node's cost). **THE ADDRESSES WERE STALE BY TEN
  THOUSAND LINES** (EQ found it, ER corrected it) — the table's CONTENT was right throughout, and
  a citation is a claim that rots the same way a number does. **THE CONVERSION IS BUILT AT EU AND
  THIS ROW DOES NOT MOVE FOR IT** — `BOND_CONVERT` 8 changes what a stack PAYS, never how many
  there are, so the governor is still the beast's death and Wild Rotation is still the only
  ceiling. `_bond_convert` beside `BOND_STEP` is the one place the split is decided.
· **Focus** (uncapped; Spray caps 50) | the FIXED-100 CONVERSION: the first 100 points buy
  crit CHANCE (saturates at +50%), everything past buys MULTIPLIER only; Deep Focus moves the
  split point down, floor 1 | FOCUS_CONVERT/FOCUS_STEP + focus_convert()/focus_crit_chance()/
  focus_crit_mult()/lethal_crit_mult(), unit.gd ~605-645 (THE ONE PLACE THE SPLIT IS DECIDED).
· **Resonance** (uncapped both ends; **TWO EARNED CARDS REMOVE STACKS — see below, and the old
  "nothing removes stacks" is CORRECTED rather than amended**) | the uncapped DAMAGE-TAKEN cost:
  RESONANCE_TAKEN_STEP 0.75%/curve-point on the same triangular curve T(N)=N(N+1)/2, and
  NOTHING may modify that step (deliberate — Conduit and Magi's Wrath name the damage curve
  only) | unit.gd ~543-582 (THE ONE PLACE THE CURVE IS DECIDED), read at battle.gd's
  strike-target block. **THE TWO SPENDERS, AND NEITHER IS IN HIS OPENING KIT — BOTH MUST BE
  EARNED: STABILIZE** (boss pool, since AT) vents everything above a floor of 2 for Mana and a
  ward, and **ARCANE BOLT** (draft pool, Batch BT) pays 15% of Attack a stack and then HALVES what
  he holds. **THE SHAPES ARE DELIBERATELY DIFFERENT AND MUST STAY SO**: a vent-to-floor is a way
  OUT of the escalation, a halving is a change of SLOPE — the curve keeps compounding from where it
  lands. Two spenders with one shape would be one card with two prices (BI's rule, other door).
  **NEITHER IS A CONTRADICTION TO BE "FIXED"**: AT's "nothing removes it" described the PASSIVE
  (no decay, no cap, no reset), and an earned spender is the exception a player buys. No test ever
  asserted the absolute — checked across every suite at BT, not assumed.
· **Ruin** (uncapped, never clears, detonates every 10th stack — Avatar installs 5) | the
  LIFESTEAL caps at RUIN_LEECH_CAP = 0.40 of the damage dealt, whatever the stacks and
  whatever the talents (Soul Glut included); the amplification is ALLOWED to run |
  battle.gd ~7846 (const), applied at the strike-loop leech block ~5680.
· **faith_peak** (never falls in battle) | the BATTLE RESET: `_reset_faith_meters()` zeroes
  count and peak together at battle start, before the opening oath; one ratchet site in
  `_gain_faith` | battle.gd ~8125-8171.

## STANDING REFERENCE — THE COMPUTED BLOCK: ONE BUILDER, TWO SCREENS, AND THE THIRD COPY THAT STAYS (Batch CK §1)
**`Classes.computed_block(ab, attack, resource)` IS THE ONLY BUILDER OF AN ABILITY'S NUMBERS FOR
A STATIC SURFACE, AND TWO SCREENS SHARE IT.** It emits damage (with school, Break damage and hit
count), heal, cost, cooldown, initiative and **Perfect**. Its two callers:
- **The DRAFT CARD** (`map_screen._draft_column`) — passes `attack = 0`, so it prints the
  ability's **scaling percentage** ("Damage: 35% of Attack (Frost)   BD: 10").
- **The HERO SHEET** (`party_screen._draw_detail`) — passes the hero's live Attack, so it prints
  the **real range**, and keeps its own `Scaling: N% of Attack` line OUTSIDE the block (on the
  draft card that line and the block's damage line would be the same figure twice).
**A LATER BATCH CHANGING THE BLOCK CHANGES BOTH SCREENS. That shared path is the point** — before
CK the sheet held the only copy, which is exactly why the draft card had none and thirty damaging
cards drafted with no damage figure at all.
- **THE DRAFT CARD IS AN ARITHMETIC-ALLOWED SURFACE AND THE OFFER PICKER IN THE SAME FILE IS NOT.**
  `map_screen._pick_button` (the mini-boss / upgrade / rune offer and the drop step) renders
  `description` alone BY DESIGN — it is read in the same breath as a fight, so the standard's
  mid-combat tier binds it. **`map_screen.gd` renders both tiers. Do not "make them consistent".**
- **THE THIRD COPY IS `battle._ability_tooltip` AND IT IS DELIBERATELY NOT FOLDED IN.** It reads a
  live `BattleUnit`: Surge, Empower and the Resonance curve multiply its damage and it prints
  "(ready in N)" off that unit's cooldown clock. It is a mid-combat tooltip with live state in it,
  not a static card, and merging it would move numbers inside a fight.
- **OWED: THE LIVE-ATTACK PROLOGUE IS WRITTEN THREE TIMES AND THE MAP SCREEN HAS NONE OF THEM.**
  `party_screen._draw_detail` and the battle spawn each build a hero's live Attack with their own
  sixty-line sequence (hero_config, kit overrides, passive, spec stats, tree, runes, upgrades,
  node scaling); `run_sim` is the third. **Extracting that into one helper is its own batch** —
  CK did not do it, because a fourth copy on the map screen would be a worse duplication than the
  one §1 existed to prevent, and because the hero sheet's agreement with the battle spawn is
  load-bearing. **When it lands, the draft card gets a real damage range by changing ONE
  ARGUMENT** — `Classes.computed_block(ab, <live attack>, res_name)` — and nothing else moves.
- **LAYOUT, MEASURED AT CK AND NOT PAPERED OVER.** The draft column's content went from
  313–389px to **557–671px** against a **388px** scroll viewport (+225 to +282px, 12–14 block
  lines over three cards) — and **three of the four columns were already at or over that viewport
  before CK**. Nothing is clipped: it is a `ScrollContainer` with horizontal scrolling disabled
  and autowrap on. **The cost is that the column runs ~1.5 viewports where it ran ~1**, so a
  player sees about two cards at a time on the screen built for comparing three. **The font was
  NOT shrunk and the block was NOT truncated** — if this is to be fixed, fix the layout.
- **`perfect_text` HAD NEVER BEEN RENDERED ANYWHERE UNTIL CK, AND IS NOW MEASURED**: of 193
  strings (over 207 resolvable abilities), **17 are wider than the 258px card and wrap to exactly
  two rows; none reaches three.** CJ's 44-character ceiling holds 936/936 *description* lines and
  never bound `perfect_text`, which carries no authored breaks and autowraps correctly. **Making
  Perfect visible also exposed 107 strings in the "60 Rage instead of 40" shape the standard
  rejects. They were not wrong before; they were invisible.** CL cleans them up.

## STANDING RULE — A TALENT MAY NOT GRANT AN ABILITY, NOR DEPEND ON ONE THE HERO IS NOT GUARANTEED (Batch DO, status half at DP)

> **A talent may not grant an ability, and may not depend on an ability or status the hero is not
> guaranteed to have.** Talents are chosen before the run knowing nothing; abilities come from the
> draft, runes sharpen them.
> **A talent modifying the spec's PROTECTED CORE is guaranteed and permitted.**

**THE LAST SENTENCE IS THE RULING AND IT IS WORTH 83 NODES.** The charter as first written said two
different things — one clause permitting a node to be general only as a STAT or the spec's own
resource and passive, another saying a node modifying a CORE KIT ability is guaranteed. **THE
SECOND READING STANDS: the hero owns its core kit in EVERY run, so modifying it is not a bet.**
**DO NOT RE-OPEN THIS AS AN OPEN QUESTION** — `docs/talent-audit.html` §8 records it as settled.

· **WHAT IS PERMITTED, IN FULL:** a STAT; the spec's own PASSIVE; the spec's own RESOURCE; the
  spec's PROTECTED CORE (`Classes.protected_names` plus `core_enablers`); and **another node in
  the same tree** — a cross-row conditional bets on a node the player CHOOSES, not on a card they
  are DEALT.
· **WHAT IS FORBIDDEN:** granting an ability at all, and naming any ability from a draft pool, a
  spec pool or another spec — **including as a bonus clause on a node that works without it.** A
  bonus clause on a drawn card is still a bet.
· **RUNES MAY STILL GRANT.** A rune is BOUGHT with knowledge of the run in front of you, which is
  the whole distinction. **`Talents.apply_payload`'s two grant branches and `_collided` are
  therefore NOT dead and must not be deleted** even though no talent reaches them.
· **CUTTING A CLAUSE MEANS CUTTING ITS PAYLOAD TERM.** A node whose text loses a clause while its
  code keeps paying it is the defect this project has found five times — cut the field and the
  read site together, and assert the field absent from the whole of `scripts/`.
· **A RE-AUTHORED CELL KEEPS ITS ID, ITS LANE AND ITS ROW.** `Talents.cells_spent` prices each
  owned cell off the row it CURRENTLY sits in, so **a node that MOVES row mis-prices a saved
  allocation** — measured at a full ledger of −2 available points, with nothing to refuse it, clamp
  it or log it. Moving a cell owes a save migration; not moving one owes nothing.
· **THE GATE ASSERTS THE PROPERTY AND PRINTS THE COUNT, NEVER THE REVERSE.** A gate that asserted
  a NUMBER here cost a second thirty-five-minute frozen run on its own first battery.
· **NAME A RE-AUTHORED NODE SO IT CANNOT BE CONFUSED WITH THE CARD IT REPLACED.** A talent tree is
  a namespace and the matcher resolves same-tree names first — but a node named after a live draft
  card is a trap in a new place. Five nodes were already named after live abilities before DO and
  **DO added no sixth.**
· **WHAT THE MOVE COSTS, RECORDED RATHER THAN HIDDEN: nine abilities lost their upgraded
  variant.** An `upgrade` arm fires only where a node's grant COLLIDES with an earned copy, and no
  node grants — so those fields are read-only-zero now. **The fields and their read sites are LEFT
  STANDING**: each reads a base beside it, deleting a branch is deleting a mechanic, and two are
  already in `runes.gd`'s coercion list against the day a rune writes them.

### THE STATUS HALF, ADDED AT DP — AND IT IS THE SAME RULE, NOT A SECOND ONE

> **A talent may not read a status the spec has no guaranteed way to apply.**
> The ability rule and the status rule are the same rule — `sm_precision` named no ability and
> was still a bet, and the ability-matching instrument could not see it.

**A RULING CAN CREATE A DEFECT WITHOUT ANYONE MAKING A MISTAKE.** Moving the only two appliers of a
status into the draft turned four tree-internal dependencies — which the charter explicitly permits
— into bets, in the same batch that wrote the charter.

· **AN INSTRUMENT THAT MATCHES ABILITY NAMES CANNOT SEE THIS CLASS OF BET AT ALL.** A node can
  name no ability whatsoever and still bet on the draw, because a STATUS has appliers and the node
  reads the status rather than the card. Sweep every node's rendered text against every status
  form and assert the PROPERTY.
· **THE RATCHET IS ASYMMETRIC.** A pair NOT in `check_dp.KNOWN_PAIRS` is an **error** — it is a
  new bet. A known pair that has GONE is a **notice** — that is a repair, and **a gate that reds on
  a repair teaches the next batch to leave the defect alone.**
· **A TEXT SWEEP CANNOT TELL A NODE READING A STATUS FROM ONE APPLYING IT**, nor an enemy's debuff
  landing on the HERO from a hero's landing on an enemy. **Every tolerated pair carries which of
  those it is**, so the next batch reads why rather than re-deriving it.
· **RE-POINTING A LANE ONTO ONE QUANTITY FLATTENS IT.** Four cells all reading one number are one
  idea repeated four times; re-point them onto four DIFFERENT quantities and assert the four are
  distinct.
· **BEFORE RE-POINTING A NODE OFF A FIELD, CHECK WHETHER A RUNE WRITES IT.** A fresh field name
  leaves that rune's clauses paying nothing, in silence — the exact dud the rune schema exists to
  prevent. **Keep the field and re-point its MEANING.** `check_dp` §4 asserts the general property:
  **every stat field any rune writes has a live read site in `scripts/`.** **BATCH EM OPENED THE
  SAME DOOR FROM THE OTHER SIDE** — a rune re-keyed off a node's field goes dead in the GUARD
  rather than in the arithmetic — and the rule for that is its own standing section below.
· **A CONSTANT QUOTED AT MORE THAN ONE SITE MOVES IN A FUNCTION, NEVER AT THE SITES**, and a gate
  asserts no caller quotes it directly, so a new site cannot be added that a node silently fails to
  reach.
· **A CONTAGION THAT MARKS THROUGH THE FUNCTION THAT MARKS IT NEEDS A RE-ENTRY GUARD.** An effect
  that always lands on one known bearer breaks its own recursion BY IDENTITY; one that lands on a
  RANDOM target has no such property and needs an explicit bound.
· **A RUNE GRANT RESOLVES THROUGH `Classes.pending_talent_ability`, NOT THROUGH THE DRAFT
  RESOLVER.** Moving a card NAME into a draft pool while its `grant_ability` DEFINITION stays put
  is the only reason granting runes still work — **had a definition moved with its name, its rune
  would grant nothing, silently.** Assert every rune grant still resolves.
· **A RUNE THAT DUPLICATES A DRAFT CARD'S GRANT IS NOT A DEAD RUNE.** Holding both collides,
  `_collided` finds no authored `upgrade` arm, so the rune owes its generic and `Run.apply_upgrades`
  turns it into an upgrade on the very card it would have granted. **A "Grants …" desc is wrong
  whenever the card was drafted**, and the honest wording already exists on one of them.


## STANDING RULE — A DIFFICULTY RUNG SCALES WHAT A MISTAKE COSTS, NEVER WHETHER THE QUESTION IS ASKED (Batch EO §2)

> **The rung is allowed to change enemy DAMAGE. It is not allowed to change enemy HEALTH, ability
> sets, intents, statuses, Break thresholds or encounter counts.**

**HEALTH IS NOT FORGIVENESS — IT IS THE FIGHT'S LENGTH, AND LENGTH IS WHAT LETS AN ENEMY ASK ITS
QUESTION.** The starter rung's ×0.50 used to apply to `max_hp` and `attack` together, and the
half that hit health is what made the rung boring: enemy `stability` is a flat 100 at every rung
and `ab.pressure` is flat too, so the Break gate needs the SAME number of hero turns at rung 1 as
at rung 3 — and the enemy died before the heroes got there. The same half took the 2.5–4.0 delay
telegraphs, the statuses worth cleansing and the turn of pressure an item is for. **Measured
untalented, n=30 a rung: a rung-1 trash fight ran 5.7 rounds against rung 2's 7.8, and 9.2 after
the fix; two-armed at n=100 it reads 5.7 → 9.1 over ~1,130 fights an arm, with completion
92% → 73%.** **MEASURE THIS ON ROUNDS, NOT ON COMPLETION** — a completion figure at n=30 carries a
±12-point band and the run harness prints that warning itself. A rung that forgives on damage still forgives a wrong answer; a rung that forgives on
health never poses the question.

· **THE TWO PATHS ARE `Run.zone_base_mult` (ATTACK) AND `Run.zone_base_mult_hp` (HEALTH), AND THE
  ONLY THING THEY DISAGREE ABOUT IS THE RUNG.** Both multiply the same `_zone_ladder(slot)`; the
  health path wraps the rung in `maxf(difficulty_mult(), 1.0)`. **The floor is what confines the
  change to rung 1** — rung 2's ×1.00 and rung 3's ×1.30 come back untouched, proved bit-identical
  rather than argued. A future rung BELOW 1.0 gets the same treatment for free; a rung above it is
  unaffected by construction.
· **THE LADDER CARRIES EXACTLY FOUR FIELDS WITH A CONSEQUENCE**, and a fifth added without a
  reader is a field that lies: `rung` (the meta gate and the enemy-ability filter), `mult`,
  `severity_floor` (the bargain floor) and `fixed_modifier` (rung 3's unduckable nodes).
  **Nothing else in the game reads the difficulty** — encounter counts, elite and boss
  composition, gold and the relic ladder are rung-independent, and `Run.difficulty` outside that
  block is display and save only.
· **THE ONE PLACE A RUNG MAY CHANGE MECHANICS IS AN ABILITY TAGGED `"rung": N` IN
  `data/enemies.json`, AND IT IS AN ADDITION ABOVE RUNG 1 RATHER THAN A REMOVAL BELOW IT.**
  `Enemies.config` defaults an untagged ability to rung 1, so the starter rung is the BASELINE
  kit and higher rungs add to it. There are exactly two such tags in the game, both on the end
  boss. **A tag that took an ability AWAY from rung 1 would break this rule**; one that gives a
  higher rung a new mechanic is what the ladder is for.
· **THE VERIFICATION IS A LIVE UNTALENTED MEASUREMENT AND NOTHING ELSE WILL DO.** `DOD_SIM_ROWS=0`
  with `--run 30` a rung. **A rung that scales a number nothing reads passes every static check
  there is** — that is exactly what a health-only change would have done to a completion sweep run
  at `rows=9`, where all three rungs already read 80–100%.

## STANDING RULE — A RUNG MAY ONLY SCALE A SYSTEM EVERY SPEC CAN PARTICIPATE IN (Batch EP §2, ruled by the designer)

> **A rung-wide multiplier on a system whose participation is UNEVEN is not a difficulty lever.
> It is a spec gate wearing one.**

**RULED AT EP: making the Break gate rung-aware is REJECTED, on its own measurement.** Raising
enemy `stability` with the rung is small, one-line, and shaped exactly like `zone_base_mult_hp` —
which is precisely why it is tempting. **But pressure is not evenly distributed across the twelve
specs**, measured over the draft pools: Sharpshooter **6** pressure-bearing cards, Arcanist 5,
Berserker / Swordmaster / Pyromancer / Occultist 4, Beastmaster 2, **Holy 1 (mean 6.0) and the
DEVOUT 0**. Only **76 of the 227-ability corpus** carry any pressure at all.

· **THE SPEC THAT WOULD BE LOCKED OUT IS THE ONE LEAST ABLE TO ROUTE AROUND IT.** The Devout
  (`SPEC_INFO["inquisitor"]`, archetype *Warder*) is the party's defensive anchor, built on Faith
  and absorbs, and it holds **zero** pressure-bearing draft cards. A rung that costs more Break
  would price a rung against a spec that cannot pay in that currency at all.
· **THE ID IS `inquisitor` AND THE NAME IS `Devout`; `mystic` IS THE `Survivalist`.** Two of the
  twelve display under a different word than their id, and a table printed by id reads as a
  different spec to whoever reads names. **Print the display name beside the id in any
  spec-by-spec figure a designer will rule on.**
· **THE TEST GENERALISES BEYOND BREAK.** Before scaling any system with the rung, count how many
  specs can participate in it. A lever every spec meets (damage taken) is a difficulty lever; a
  lever six specs meet is a gate.

## STANDING DESIGN RULE — A RUNE'S COST MAY BE BOUGHT BACK, AND PAYING FOR THAT IS THE DECISION (Batch EP §4, ruled by the designer; relabelled at ES §3)

> **A talent node that refunds a costed rune's downside is not a bug in the rune. The point,
> the lane and the row it costs ARE the trade.**

**BATCH ES §3 RETIRED THE WORD, NOT THE RULE.** This rule was written about "a Scarred rune", and
there is no Scarred label any more — the flag, the prefix and the colour are gone and every cost
clause is byte-unchanged. **The rule is about a rune that CHARGES for its upside**, which is what
`Runes.is_cost` recognises, and it reads exactly as it did.

**RULED AT EP: the Rune of the Bared Guard is KEPT, and the 80% refund is ACCEPTED.** Its
`rune_seasoned_def_bonus` −0.15 exactly cancels Defensive Stance's 0.85 mitigation
(`maxf(0.85 - seasoned_def_bonus - rune_seasoned_def_bonus - discipline, 0.0)` resolves to 1.00 on
the nose), and `sm_def_stance` — **Defensive Stance, lane Poise, row 1** — writes 0.12 back into
the same subtraction, leaving 0.88 against a vanilla 0.85. **The node is inside the three rows a
single rung-1 clear opens**, so the refund is available to the first player who ever sees the rune.
**The designer's ruling: paying a point and a lane to soften a costed rune is a decision, which is
what the cost is for.**

· **THE TWO REPAIRS THAT WERE REFUSED, NAMED SO THEY ARE NOT RE-PROPOSED**: making the rune's term
  un-refundable, and moving `sm_def_stance` deeper into the tree. Both were considered and both
  were rejected in favour of accepting the interaction.
· **AND THE SET-SHAPE FACT THAT KEPT IT.** There are **17 costed runes — 2 universal, 3
  class-scoped (mage, cleric, hunter; there is NO `class:warrior` one) and exactly 1 per spec** —
  so the three Warrior specs already draw 3 where the other nine draw 4. Retiring the Bared Guard
  would leave the Swordmaster **2**, the thinnest costed shelf in the game and the only spec with
  no spec-scoped one. **It is also the only item that lets a Swordmaster buy commitment**;
  `still_wrist`, `shattered_guard` and `duelist` are all pure upside.
· **ES §3 RE-DERIVED THAT 17 AND IT IS A DIFFERENT 17 FROM THE FLAG'S.** The count is the same and
  the SET is not. **`exsanguination` carried the flag and has no payload cost term at all** — its
  promise (veins open at 85) and its price (the bleedout tears 15% of max health instead of 20%)
  are two behaviours of ONE field at ONE read site, so nothing can sweep for it; it is named in
  `test_runes.COST_WITHOUT_A_TERM` and in `check_es` §3 rather than suppressed. **And `anchor`
  carries a real −10 Speed and never carried the flag**, because the old schema forbade a "scarred
  common" and it is the one common in the file — **a rarity rule was hiding a cost.** The Warrior
  arithmetic above is unaffected: `exsanguination` is the Berserker's and `anchor` is universal.

## STANDING RULE — THE OFFERABLE RUNE POOL IS RETIRED, AND A RETIREMENT IS DECLARED PER ENTRY (Batch ET §1, ruled by the designer)

> **All 65 authored entries are retired. Nothing is offerable but the generated stat family.
> A retired entry is KEPT and SAID to be kept: it keeps its name, price, payload and desc, it
> still resolves, and it carries a string naming WHAT IS LOST.**

**THE REASONING, RECORDED WITH THE RULING SO IT IS NEVER RECONSTRUCTED WRONGLY.** The pool was
authored to the one-rune-per-talent-lane rule, which was replaced; keyed to talent counters, which
were rebuilt at DO and DP; and re-keyed onto rune-owned fields at EM. **What survived all of that
was the magnitudes, and the magnitudes were never the interesting part.** A pool authored to the
real charter — threshold-gated, reading archetype tags on the holder's DRAFTED cards — will be
better than 53 patched ones.

· **A RETIREMENT WITH NO STRING IS A DELETION NOBODY WROTE DOWN.** `eligible_ids` reads the
  `retired` key and nothing else, so a bare `"retired": "yes"` would empty the pool exactly as
  effectively and record nothing. **The string is the only place the loss lives**, and it is what a
  future author reads before re-covering that ground. `check_et` §1 asserts every entry carries one
  naming its batch and its loss.
· **THE TWO VINTAGES ARE ONE DECISION.** EO §3 retired twelve, ET §1 the other fifty-three, and
  EO's twelve keep their existing strings unrewritten. A reader meeting a uniformly empty pool must
  not mistake the two passes for two decisions.
· **RETIRED IS NOT DELETED, AND KEPT CONTENT THAT NOTHING DRIVES IS CONTENT THAT ROTS.**
  `test_rune_battle` walks `Runes.ids()` rather than the offer pool and still reads **97 / 0** with
  every entry retired — the pool is unofferable, not broken. **Do not "simplify" a suite onto
  `eligible_ids` to get a green file**; that is the silent repair, it is the smaller diff, and EO's
  own comment in that suite names it.
· **THE READ SITES ARE THE TRAP THIS SETS FOR THE NEXT BATCH.** **72 of the 84 stat fields the
  retired pool writes have `data/runes.json` as their only writer in the project**, so their
  branches in `battle.gd` can no longer fire — and a branch that cannot fire is indistinguishable
  from dead code to every instrument here. **Deleting one is deleting a mechanic the pool is meant
  to come back to.** `check_et` §5 pins the population as an asymmetric ratchet: it may grow, and it
  may not shrink without a line changing there.
· **AN ASSERTION THAT THE POOL IS NON-EMPTY IS NOW A STATEMENT OF THIS RULING, NOT AN ALARM.**
  Three of them existed and all three were made TWO-ARMED rather than deleted — `test_runes`
  `_rich_grant` and `_start_rune_pool`, and `check_es` §2. **Each comes back on its own the day a
  rune is authored.** A one-armed repair reads green on the day the whole file stops rolling.
· **AND ONE MEASUREMENT WENT DORMANT RATHER THAN WRONG.** `check_es` §1 measures that the offer is
  flat across zone slots; with the pool empty it is 100% at every slot BY CONSTRUCTION and the arm
  cannot fail. **It prints DORMANT rather than passing quietly** — a vacuous check prints exactly
  like a clean one.

## STANDING RULE — RUNE CONTENT IS WRITTEN WITH THE DESIGNER, ONE RUNE AT A TIME (Batch ES, ruled by the designer)

> **A batch may build machinery, re-scope, retire or repair. It never authors a rune, never
> re-authors one, never retunes one, and never presents rune content as options.**

Rune content is written in conversation, one rune at a time. **A batch that finds itself listing
three candidate clauses for the designer to pick from has already broken this rule** — the
listing is the authoring. What a batch owes instead is the measurement the decision needs and the
machinery the decision will land on.

· **THE TEST IS WHETHER A MAGNITUDE MOVED.** ES removed rarity, the Scarred label and the offer
  odds and moved **not one authored magnitude**: every `payload`, `price` and `desc` in
  `data/runes.json` is byte-unchanged. The one number it moved is the GENERATED stat family's,
  and only because the ×1/×2/×3 ladder was literally a rarity field.

## STANDING RULE — THERE ARE NO RUNE RARITY TIERS, AND AN OFFER IS FLAT ACROSS THE RUN (Batch ES §1, ruled by the designer)

> **Rarity is removed entirely. No tiers, no rarity odds, no zone progression in rune quality.
> A batch proposing a quality grade is proposing to overturn a ruling.**

**WHAT RARITY DID, AND WHERE EACH HALF WENT.** It *meant kind* — an authoring convention, never a
behaviour, and every rune goes on doing exactly what it did. It *drove the offer odds* — 60/30/10
at zone 1 deepening to 25/45/30 by zone 3, **the only thing that made a late offer differ from an
early one**, and measured on the live pool that put **half of every zone-1 offer** into the
generated stat family against a fifth of every zone-3 offer; it is a flat **~30% at every slot**
now — and **100% at every slot since ET §1 retired the authored pool**. It *set the price* for the
generated family; authored runes have always carried their own.

· **PRICE IS THE OPEN QUESTION AND NO RULE WAS INVENTED FOR IT.** The 53 offerable runes carry
  prices of 50 / 75 / 100 / 120 / 160 written against a tier table that no longer exists. **That
  is a design decision and it is the designer's.**
· **`Runes.is_cost` NEVER READ RARITY AND IS UNAFFECTED**, which is worth writing down because
  three reports in a row called `DOD_SIM_RUNE_POWER` "the sim's rarity lever". It is a POWER
  lever; `is_cost` reads a field name and a sign.
· **THE ZONE SLOT IS STILL IN `Runes.generate`'s SIGNATURE AND IS DELIBERATELY UNREAD** —
  `_zone_slot`, asserted by `check_es` §1. It is the hook a later batch would want if a zone is
  ever allowed to change an offer again, and a parameter nothing reads cannot break the ruling.

## STANDING RULE — A RUNE'S SCOPE IS SPEC AND CLASS (Batch ES §2; the five universals' half SUPERSEDED at ET §1)

> **Losing five authored, working runes to a scoping rule is waste. The class each of the five
> lands on is CONTENT and is the designer's, and until it is made they stay universal.**

**BATCH ET §1 SUPERSEDED THE SECOND SENTENCE AND LEFT THE FIRST STANDING.** The five are retired
with the other forty-eight, so there is no class left to choose and the question leaves the queue.
**The scope AXIS is untouched**: every entry still declares one, `_scope_ok` still resolves all
three bands, and the shop row still shows the band — the next pool is authored against this rule.
**`check_es` §2 was re-pointed rather than deleted**, and onto a wider population than it watched
before: every entry a spec cannot draw must be undrawable BECAUSE IT IS RETIRED, so a retirement
wearing an eligibility rule still goes red across all 65.

**THE SIZE OF THE MOVE IS MEASURED: the five are 5 of every spec's 9–12 offerable runes** — 42% to
56% of the drawable pool — so this is the largest single movement the rune pool has ever taken.
Whichever class each lands on, the other three specs' pools lose it. **The Occultist is thinnest
at 9 today.** **Those figures are ET's BEFORE reading and are kept as the record of what the pool
was**; the depth table `check_es` §2 prints now reads zero across all twelve.

· **TWO OF THE FIVE CHARGE FOR THEIR UPSIDE** (the Glass and Vampiric Runes), and EP measured that
  those two are what a Swordmaster falls back on if the Bared Guard is ever retired. **Re-scoping
  them removes that fallback for every spec outside the chosen class.**

## STANDING RULE — A RUNE READS ITS HOLDER'S EQUIPPED CARDS, NEVER HIS POOL (Batch ES §4, ruled by the designer)

> **A rune that keys off archetype tags counts the cards the hero is CARRYING. Thresholds are the
> default shape — hold 2+ of a tag, get the effect — mixed per rune where a rune wants otherwise.
> A SPLASH pays for BREADTH across tags where a normal rune pays for depth in one.**

**THE EQUIPPED/OWNED DISTINCTION IS LOAD-BEARING AND EG CREATED IT.** A hero's pool is everything
drafted and nothing ever leaves it, so **counting owned cards means a threshold turns on once,
late, and never off — the flat increment with a delay.** Counting the loadout keeps it a live
decision: **you can swap to switch a rune on or off, so the loadout becomes a lever.**

· **THE DOOR IS `Run.loadout_ability_names(member)` → `Classes.tag_census` / `tag_count` /
  `tag_breadth`, with `Runes.tag_threshold_met` and `Runes.breadth_met` as the two shapes a rune
  asks through.** The list is the PROTECTED CORE plus the equipped earned cards, which is what
  `battle.gd`'s spawn assembles and what the 7-to-10 slot cap counts.
· **THE `Runes` HELPERS TAKE THE NAME LIST AND NOT THE MEMBER, AND THAT IS A CONSTRAINT.** They
  are static on a `class_name` script, and **a static function cannot see an autoload** — reaching
  `Run` from there is a compile error. The split is also what keeps `run_state.gd` free of every
  tag word, which `check_ek` §3 asserts at zero for that file by name.
· **A THRESHOLD'S MAGNITUDE MUST BE CHOSEN AGAINST THE CORE-KIT BASELINE.** Before a card is
  drafted, the cores alone already meet a 2+ threshold on **BREAK for ten of the twelve specs**
  and on **DEBUFF for seven**; **MARK is zero for all twelve** and **TEMPO reaches 1 on exactly
  one**. A rune asking 2+ BREAK is on from the first fight for almost everyone and no swap turns
  it off. `check_es` §4 prints the per-spec table every battery run.
· **THE COUNT MUST BE VISIBLE AND MUST MOVE ON A SWAP.** A silent threshold is a stat nobody knows
  they have. It is drawn on the loadout panel (where the swap happens) and on the hero sheet, and
  **both are driven** — `check_es` §4 through the real equip/unequip doors, `check_map_screen`
  through the real screen.
· **WHEN A RUNE FINALLY READS IT IN A FIGHT, THE PLACE IS THE SPAWN AND NOT THE STRIKE LOOP.** The
  loadout cannot change during a battle, so the count is a per-hero constant for the whole fight.

## STANDING RULE — LOYALTY IS GOVERNED BY A CONVERSION, NEVER BY A CEILING (Batch ER, ruled by the designer)
> **The designer has ruled that Loyalty does NOT flatten. Above nominal the meter CONVERTS: each
> stack stops adding to the term it was adding to and adds to something else, on the shape Focus
> already uses. Below nominal nothing changes and the ACCRUAL is never touched.**

**BUILT AT BATCH EU. THE CURRENCY IS THE PACK BOND BOON'S OWN GROWTH AND THE POINT IS 8.**
`BOND_CONVERT := 8` beside `BOND_STEP`; `_bond_convert()` is the one place the split is decided
(`focus_convert()`'s counterpart) and `_bond_paid` / `_bond_converted` are its two halves. **Below
the point NOTHING MOVED**; above it a stack stops adding to `_comp_dmg_mult`'s strike step and
feeds `_bond_mult` a second time. **The measurements are live in `docs/reports/EU.md` with their n
and their standard error — do not quote a figure from here, there is none.**

- **WHY 8 AND NOT THE NOMINAL 5, WHICH IS THE ONLY MAGNITUDE THIS BATCH CHOSE.** Loyalty arrives
  at 10.08 ±0.12 with the rows a single rung-1 clear opens and 6.64 ±0.09 untalented (ER §6), so a
  split at 5 converts most of a typical meter and a split at 8 bites only the tail that
  over-arrives. **AND 8 IS KINDRED'S OWN THRESHOLD**, so no point below it can put a row-8 node on
  the far side of a phase change the player never chose.
- **THE FOUR RAW-STACK READERS AND THE THREE GIFTS DO NOT CONVERT, AND THIS IS THE THING MOST
  LIKELY TO BE GOT WRONG.** Unleash, Primal Surge, Last Howl and Bring It Down COUNT stacks; the
  split changes what a stack PAYS. A batch that re-points one of them at `_bond_paid` changes the
  game's largest single Loyalty payout silently — `check_eu` §2 casts all four to stop it.
- **A FUNCTION CAN HOLD BOTH HALVES AND TWO OF THEM DO.** `_ghost_hit` reads the paid half for its
  strike step and the WHOLE meter for Aguila's armor pierce; `_companion_strike` likewise for
  Canis's Bleed. One variable serving both silently converts the gift.
- **AND THE MIRROR IS A READ SITE TOO.** `_bot_boon_worth` recomputes `_bond_mult`'s curve so the
  bot can price a swap it has not made; ER §1d's payout table omitted it and EQ §1's census caught
  it. Leaving it behind would have made the bot under-value exactly the deep bonds the conversion
  pays most for, and nothing compares the two functions.

- **WHAT THIS RULES OUT, BY NAME.** The four shapes `docs/reports/EQ.md` §2 priced — diminishing
  above nominal, a soft cap, a hard cap at twice nominal, a hard cap AT nominal — **are all off the
  table as governors of this meter.** A later batch proposing one is proposing to overturn this.
- **WHAT MAKES THE CONVERSION SAFE WHERE A CAP IS NOT, AND IT IS THE ACCRUAL.** A conversion writes
  nothing into `_gain_loyalty` or `_loyalty_cap`, so **Kindred still fires at 8, Lone Bond still
  seats at 6 and None Left Behind still seats at 5.** Every threshold reader and every raw-stack
  reader — Unleash, Primal Surge, Last Howl, Bring It Down — is untouched **by construction**, not
  by care. That is the whole reason the shape was ruled and it is the property to preserve.
- **AND THE PORT OF FOCUS'S SHAPE IS NOT A PORT OF FOCUS'S SAFETY. THIS IS THE TRAP.** Focus's
  conversion has a **zero loss column for two reasons Loyalty has neither of**: its first half
  SATURATES (crit chance stops paying at +50%, so the converted stacks were buying nothing), and
  its RATE is untouchable (`FOCUS_STEP` is a const no node modifies — **Deep Focus moves the SPLIT
  POINT, not the rate**). **Loyalty's first half does not saturate and every one of its rates has a
  node on it** — `_bond_step` is raised by Absolute Devotion, doubled by Ancient Pact and raised
  again by a rune; the strike step is raised by Wild Communion and a rune. **So a conversion here
  DOES cost the payout readers something, and what it costs is measured rather than assumed.**
- **THE CONSEQUENCE FOR HOW IT IS BUILT: MOVE THE SPLIT POINT, NEVER THE RATE.** That is Deep
  Focus's shape and it is the half of the precedent that transfers. **A node or rune that steepens
  the converted half re-creates the over-arrival on the other side of the split**, which is what the
  ruling exists to stop.
- **NOMINAL WAS NOT A LIVE NUMBER AND `BOND_CONVERT` IS — BUT THEY ARE DIFFERENT NUMBERS AND THE
  INSTRUMENT KEPT ITS OWN.** The 5 in `battle.CY_METERS` means *where the boon reads x2*, which is
  still true and is still what every arrival figure from EQ, ER and EU is quoted against.
  **`CY_METERS` WAS DELIBERATELY NOT REPOINTED AT `BOND_CONVERT`**: re-denominating it would have
  silently broken comparability with every prior measurement of this meter, and the two numbers
  answer different questions. The header there names both so a later reader cannot conflate them.
- **THE TWO EXISTING CLAMPS ARE PART OF THE DECISION, NOT BYSTANDERS.** `BOND_MITIGATION_MAX` 0.75
  and Savage Presence's taunt clamp of 1.0 both read `_bond_mult`. **A conversion that caps
  `_bond_mult` at nominal puts both out of reach at every talent depth**, which by AR §4's rule
  makes them dead constants rather than governors; a conversion that FEEDS `_bond_mult` makes both
  bind harder. **THE SENTENCE IS OWED AND HERE IT IS: EU FEEDS `_bond_mult`, SO BOTH CLAMPS BIND
  HARDER AND NEITHER BECOMES A DEAD CONSTANT.** That is the branch ER §1f called "the clamps do
  more work rather than less", and it is the opposite of what the four flattening shapes would have
  done. **How much harder is measured, not asserted** — `docs/reports/EU.md` §4 carries the binding
  rate of each of the three limits before and after, at all three loadouts.
- **AND THE CONVERSION MUST BE LEGIBLE WHERE FOCUS'S IS.** `unit.gd`'s nameplate prints both halves
  of Focus side by side (`Focus %d (+%d%% crit / x%s)`), which is why a player can see the phase
  change. **EU'S COUNTERPART IS `_stamp_loyalty_chip`'S FOURTH LINE**, which names the point at
  EVERY depth and counts the converted stacks once there are any — printed BELOW the point as well
  as above it, because a phase you only learn about by crossing it is still a surprise and Focus's
  nameplate shows its second half at zero Focus. **The chip's strike figure reads the PAID half**:
  a chip still multiplying by the whole meter would print a bonus the blow does not have, which is
  worse than the silent phase. **A silent second phase is a stat nobody knows they have.**

## STANDING RULE — A RETIRED PIECE OF CONTENT IS KEPT, AND SAID TO BE KEPT (Batch EO §3, the Melted Armor contract)

> **Retiring content means it stops being OFFERED. It does not mean the entry is deleted, and it
> does not mean the suites stop driving it.**

**THE PRECEDENT IS MELTED ARMOR**, whose `data/glossary.json` entry says outright that nothing in
the game applies it and why — `docs/text-audit.html` calls that the most honest string in the
game. EO §3 retired twelve runes on the same contract: each keeps its entry in `data/runes.json`
with a `retired` string naming **what is lost**, `Runes.config` / `build` / `display_name` all
still resolve it so a saved run holding one keeps working, and `Runes.eligible_ids` — the one
door both offer paths use — skips it.

· **THE FILTER GOES AT THE SINGLE DOOR, NOT AT THE CALLERS.** Both rune offer paths (`generate`
  and `run_state.grant_rune`) reach the authored pool through `eligible_ids`; one `continue`
  there retires a rune everywhere without touching either caller, and neither can be blanked by
  it — `generate` falls back to the generated stat family (**ES §1: it widened an exhausted RARITY
  first, and there is no rarity to widen out of now, so that fall is the whole floor**), and
  `grant_rune` falls back to `generate_rune`.
· **ASSERT THE RETIREMENT IN BOTH DIRECTIONS.** `test_runes` now says a retired entry must roll
  for NOBODY and a live one must still roll for its own spec. **An exemption arm instead would
  read green on the day the whole file stopped rolling** — the same shape `check_em` §4 was
  inverted to avoid at EN §6.
· **A SUITE THAT TESTS WHETHER A CLAUSE PAYS MUST WALK `Runes.ids()`, NOT `eligible_ids`.**
  `test_rune_battle` drives every authored spec rune through a live battle; walking the offer
  pool stops driving all twelve on the day they are retired. **It does not fail silently — armed,
  the control reads 17 failures, because the clause assertions name specific runes and values.**
  **The hazard is the REPAIR:** the two ways to green are to walk the authored set, or to delete
  those twelve runes' clause assertions, and the second is silent and is the tempting one.
  **Kept content that nothing drives is content that rots**, and the whole point of keeping it is
  that a later batch can point something at it again.
· **A COUNT DERIVED FROM THE LIVE POOL SURVIVES THE NEXT RETIREMENT; A LITERAL DOES NOT.**
  `test_runes`'s grant loop asked for the literal 4 every spec was authored and read nine
  failures the moment some specs kept 2. It asks for the number that survives now.

## STANDING RULE — A RUNE IS DISCONNECTED FROM THE TALENT TREES (Batch EM, the designer's charter)

> **A rune modifies stats and resources, and the mechanics and values of core abilities, draft
> abilities and passives. It does not write a talent node's own counter.**

**THE CHARTER IS THE DESIGNER'S AND THIS IS ITS MECHANICAL HALF.** EJ audited the gap and sized it
at **59 of 135 clauses in 32 of the 65 runes**; EM re-keyed **56** onto rune-owned fields. What
remains open is design and is in `docs/state.md` — the three clauses with no home, the sixteen
runes the charter empties, and whether the lane rule is replaced with anything.

· **THE FIELD NAME IS THE RULE: `rune_X` BESIDE `X`, READ AT THE SAME SITE.** Batch AL shipped this
  three times before the charter existed (`rune_grudge_bonus`, `rune_vigil_bonus`,
  `rune_on_edge_ranks`) and the method is in the source comments at each site. **Do not invent a
  second shape.**
· **A THRESHOLD TAKES THE MAX; A PAYOUT SUMS — AND GETTING IT BACKWARDS IS SILENT.** A summed
  threshold fires early (35 + 25 = 60% is not "both effects", it is a third effect neither asked
  for) and a maxed payout underpays. Neither throws. **All 56 of EM's clauses were payouts**; On
  the Edge is still the only threshold any rune shares and it is still AL's.
· **THE GUARD IS THE DANGEROUS HALF, NOT THE ARITHMETIC.** `if u.spread_ranks > 0` is FALSE for a
  hero holding the rune and not the node, so the clause pays nothing and nothing throws.
  **EVERY PRESENCE TEST ON A RE-KEYED FIELD MUST SUM THE PAIR.** Measured: with the guard reading
  the node's counter alone, a rune-only Occultist spread a mark **0 times in 400**; summed, 55–66.
  This is DP's Whispering Dark dud arriving through the repair for it.
· **`check_em` §2 IS THE INSTRUMENT AND IT WORKS ON STATEMENTS, NOT LINES.** A guard and its payout
  are two statements and an expression is often three lines. **Its first version excluded a match
  preceded by a word character OR A DOT** — and `attacker.vulture` has a dot in front of it, so it
  was blind to 80 of its 85 sites while printing a clean zero. **A control for a sweep like this
  must be armed on a DOTTED read.**
· **A TALENT NODE WRITING THE SAME FIELD DOES NOT BY ITSELF MAKE A RUNE TALENT-KEYED.**
  `crit_bonus`, `speed`, `max_hp_pct`, `block_chance`, `parry_bonus`, `dmg_bonus`,
  `dmg_taken_bonus`, `pierce_bonus` and `bleed_bonus` are the unit's own math, read in global
  pipelines that relics also write. **They are `check_em.UNIT_MATH`, asserted as an EQUALITY**, so
  a tenth needs a line and a reason. (`armor` is NOT among them: EJ's report said nine and listed
  ten, and no live node writes `armor` at all.)
· **`rune_X` INHERITS NOTHING FROM `X`.** `Runes._typed_payload` restores an int for a field ending
  `_ranks` or listed in `STAT_INT_KEYS`, so **a `rune_` int whose name does not end `_ranks` needs
  its own row there** — and a `rune_` FLOAT must be in neither, or the coercion rounds the rune
  quietly under strength (the AT `conduit_step` precedent; the Bared Guard's −0.15 would flatten to
  0 outright). `check_em` §3 derives both directions off the BattleUnit declaration.
· **THE THREE WITH NOTHING UNDERNEATH THEM WERE ANSWERED AT EN, AND THE SET IS CLOSED.**
  `divine_presence_pct`, `entropy_ranks` and `pleasure_pct` are per-turn drips that exist only as
  their node, so EM had nothing to re-point onto and priced four options rather than guessing (the
  AR §4 rule). **EN took option A: a field of its own for each, summed at the drip's EXISTING
  tick.** All 59 clauses are rune-owned now. **THERE IS NO SECOND TICK AND THERE MUST NOT BE ONE** —
  a hero holding the rune AND the node would be paid twice, which is a magnitude moving, and a
  magnitude moving is the one thing a re-key forbids.
· **ALL THREE ARE PAYOUTS AND ALL THREE GUARDS ARE PRESENCE TESTS — MEASURED, NOT ASSUMED BY
  ANALOGY.** EM's 56 had zero applications of AL's MAX rule and EN's three have zero as well, but
  each was read at its own site before the arithmetic was chosen: `divine_presence_pct` is a % of
  max HP, `entropy_ranks` a Break figure and `pleasure_pct` a % per unique debuff — three
  magnitudes, and each `> 0` beside them asks *does this hero have the effect at all*.
· **`check_em` §4 ASSERTS THE CLOSURE, NOT AN EMPTY TABLE.** EM's `NO_HOME` said "the day one is
  answered this gate reds and the answer is to delete its row" — all three were answered at once,
  and deleting the table outright would have left §4 looping over nothing and **printing exactly
  like a clean run**. It walks EN's three as a live population in BOTH directions (the rune writes
  `rune_X`; NOTHING writes the bare `X`) and prints `CHECKED n of m`.
· **THE `lane` FIELDS ARE STILL AUTHORED AND STILL SHOWN, AND THEY NOW DESCRIBE HISTORY.** 36 lane
  runes and 12 splashes were built on *"worth more to a hero whose points went elsewhere"*; a rune
  with its own field is worth the same to every hero of its spec. **That was measured, not
  overlooked** — see `docs/design-notes.md` and `docs/master.html`.


## STANDING REFERENCE — THE ABILITY DRAFT, THE SLOT LADDER AND THE TWELVE PROTECTED CORES (Batch BO, reach rewritten at BX, the cap and the loadout at EG)
**AN ELITE OFFERS A DRAFT TO EVERY LIVING HERO, on ONE SCREEN of four columns, each hero drawing
from their OWN pools and keeping their OWN no-return ledger.**

**A SECOND ABILITY SOURCE BESIDE THE BOSS PICK, AND IT IS A SEPARATE POOL ON PURPOSE.**
`Classes.SPEC_DRAFT_POOLS` / `CLASS_DRAFT_POOLS` are what elites, merchants and events offer;
`SPEC_POOLS` is what a ZONE BOSS offers. **Sharing one pool would re-weight every boss offer in
the game**, which is what "the existing pick, unchanged" forbids. **A drafted ability lands in
`member["bm_abilities"]`, the SAME list a boss pick writes**, so the battle spawn, the hero sheet,
`Talents.ability_names`, the rune filter and the upgrade pairing all pick it up with no new
plumbing — **NO SAVE VERSION MOVED FOR THE DRAFT ITSELF** (EG moved it for the slot ladder, which
is run state rather than a member key); the member keys (`draft_candidates`, `draft_picks_owed`,
`draft_refused`, and **`bm_equipped` since EG**) ride the party dict, which is saved wholesale.
**A drafted card removes itself from the boss offer and vice versa; that one shared list is what
lets a boss pool empty below its own depth.**
· **THE CAP IS A LADDER AND IT BINDS EVERY SOURCE**, the boss pick included: a cap one pool can
  walk past is not a cap. `Run.ability_slots_used` = `Classes.core_slots(spec)` + the LOADOUT, and
  it is compared against **`Run.ability_slot_cap()`, never against a constant**.
· **PROTECTED = THE OPENING KIT. EARNED = BENCHABLE, NEVER LOST.** `Run.unequip_earned_ability` is
  THE ONE PLACE a card leaves the loadout and it refuses anything not in `bm_abilities` — so "a
  protected ability can never be benched" is not a branch that could be got wrong, it is the
  absence of the name from the list. `Run.hold_ability` is the ONE place a card enters the pool,
  and both pick paths call both.
· **DECLINING REFUSES THE WHOLE OFFER; TAKING ONE REFUSES NOTHING; BENCHING ONE REFUSES NOTHING.**
  `draft_refused` is the no-return ledger, per hero per run, and **`decline_draft` is its only
  writer since EG.**
· **THE OFFER FILLS SHORT rather than padding with repeats**, and `Run.draft_card_is_class` is the
  one-in-four seam — **its own function precisely so a test can drive it 4000 times.** A check on
  the roller that could only ever measure zero is a check that can only pass, which is a gap.
· **THE UI IS THE EXISTING OVERLAY, NOT A SECOND ONE.**

**THE TWELVE PROTECTED CORES — `Classes.PROTECTED_CORES`, AND THE `enablers` COLUMN IS THE THING A
LATER BATCH WOULD MOST EASILY BREAK.** It is AUTHORED rather than derived, and `test_batch_bo`
asserts every named enabler is in that spec's opening kit and in NO pool. **The failure it prevents
is SILENT: a spine that stops working because its enabler became draftable.** Holy is the only spec
at FOUR slots (Heal, Hymn of Hope), so she has the fewest earnable slots in the game; the
Beastmaster's three summons are FIVE ABILITIES IN THREE SLOTS, because the summon picker has been
one bar entry since AH. **The table itself is in `classes.gd` with a `why` on every row — read it
there rather than copying it here.**

**THE DRAFT IS COMPLETE AND NOTHING IS OWED: 154 of 154, 129 spec + 25 class-wide.** All twelve
specs draft from at least TEN; the Mage class pool holds seven and the other three hold six.
**DO NOT RE-RECORD ANY PART OF THE DRAFT AS OWED.** In particular:
· **THE WARRIOR POOLS WERE OWED AND ARE PAID** — Berserker Blood Offering / Gut Rip, Warden
  Covering Guard / Eye of the Storm, Swordmaster Precision Strike / Feint.
· **THE CLASS-WIDE TRANCHE IS PAID IN FULL**: `CLASS_DRAFT_POOLS` is 24 of a target 24 against its
  own original target, and
  **THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY FOR EVERY HERO IN THE GAME** — no class rolls an
  empty pool and no offer loses its class card.
· **TRANCHES 2 AND 3 ARE BOTH PAID**, the four classes completing in order — the Mage first,
  **THE CLERIC SECOND**, the Hunter third and the Warrior last, and **ALL FOUR ARE COMPLETE**.
· **NEITHER HALF IS A FLAT MULTIPLE ANY MORE.** Both expectations are summed tables
  (`test_batch_cd.PER_SPEC_DEPTH` and `PER_CLASS_DEPTH`) — **do not write `12 * 8` or `4 * 6`
  again**, and do not quote the old ninety-six-card denominator, which died at CD §2.
· **THE ASSERTED FLOORS ARE EIGHT (spec) AND SIX (class), AND BOTH ARE DELIBERATELY SLACK.** They
  catch a pool that EMPTIES rather than tracking the deepening. **Every draft suite asserts the
  FLOOR and the TOTAL; the two tables above are the only authoritative depths.**
· **A STANDING BLOCK STATES A NUMBER ONCE.** A superseded snapshot once sat forty-nine lines below
  the line that contradicted it, inside this block, and **survived CW's split because that sweep
  was for narrative FORM and this was narrative in every way but its formatting.**
· **WHAT THE SUITES GUARD FROM HERE ON IS THE FLATNESS, NOT A DEBT.** A pool that quietly empties
  trips, where before it would have read as an old debt coming back.
· **A CONSTRUCTION THAT HAS TO RELOCATE IS HOW A PAID DEBT ANNOUNCES ITSELF; ONE THAT CAN NO
  LONGER RELOCATE IS HOW A FINISHED ONE DOES.** Write a suite's refusal setup RELATIVE TO THE LIVE
  POOL SIZE, never against a hardcoded count of the hero's own cards — the hardcoded shape stops
  measuring the fill-short rule the moment a pool deepens under it.

**CLASS-WIDE AUTHORING RULES, recorded with the arrays so they travel with the content:**
deliberately UNTIED AND GENERAL (Magic Barrier, not Frostbolt — the test is whether it would read
as off-theme for ANY spec of that class), and **WEAKER THAN SPEC ABILITIES AND UNCONDITIONAL** —
they feed no passive, so at equal power they would be a safe default that dilutes every build.
**VERIFY THE "WEAKER" HALF AGAINST THE LIVE SPEC KITS RATHER THAN TRUSTING THE BRIEF, AND CHECK IT
AGAINST THE FREE CORE ATTACK TOO** — a comparison against spec ABILITIES alone misses a card
dominated by a basic.

## STANDING RULE — THE SLOT LADDER, AND THE POOL IS NOT THE LOADOUT (Batch EG)
> **ABILITY SLOTS GROW ON A ZONE BOSS: `Run.ABILITY_SLOTS_BY_BOSS` is `[7, 8, 9, 10]` and
> `Run.ability_slot_cap()` is the only reader of it. AND A HERO'S POOL AND HIS LOADOUT ARE TWO
> SETS: `bm_abilities` is everything he has earned and nothing ever leaves it; `bm_equipped` is
> what he carries, and it is what the cap binds.**

- **NEVER COMPARE AGAINST A CAP CONSTANT. ASK `Run.ability_slot_cap()`.** It is a function for the
  same reason `Run.item_slots()` is: the number moves inside a run. A suite that fills a hero "to
  the cap" writes `run.ability_slot_cap() - Classes.core_slots(spec)` and never a literal — BO's
  own rule about writing a refusal setup relative to the live pool, one door along.
- **THE LADDER IS INDEXED BY ZONE BOSSES CLEARED, NOT BY `zone_idx`, AND THE TWO PART COMPANY ON
  THE THIRD BOSS.** BM §6 made the end boss a slot on the third zone's own board, so
  `has_next_zone()` is already false when the third ZONE boss dies, `advance_zone()` never runs and
  `zone_idx` stays 2. **A ladder read off `zone_idx` grants twice in a run that beats all three.**
  `Run.zone_bosses_cleared` counts the event; `Run.note_zone_boss_cleared()` is its only writer.
- **THE SLOT ARRIVES BEFORE THE AWARD, IN `battle._resolve_boss`, AND THAT ORDER IS LOAD-BEARING.**
  It is granted by the boss dying rather than by the award being offered, so a hero whose pools are
  both dry still gains it — and granting it first is what makes "a hero at cap can receive both"
  true, because the pick is resolved later against a cap that has already moved.
- **RESET IT WHERE `zone_idx` IS RESET.** A second run in one session would otherwise open every
  hero at ten. This is CT's scar (the opening pouch sized off the previous run's zone) arriving at
  a second ladder; it is written down rather than re-learned.
- **WHICH SET A READER WANTS IS DECIDED BY THE QUESTION, AND THERE ARE ONLY TWO QUESTIONS.**
  *What can this hero CAST?* → the loadout (`Run.equipped_ability_names`) — the battle spawn and
  the hero sheet, and nothing else. *What does this hero OWN, so he is not offered it again?* → the
  pool (`bm_abilities`) — `Runes.kit_names` → `Talents.ability_names` → `Run.owned_ability_names`,
  and through it the draft, the boss award and its fallback. **READING THE LOADOUT FOR THE SECOND
  QUESTION RE-OFFERS A BENCHED CARD AS IF IT WERE NEW**, which is the exact defect
  `owned_ability_names` exists to prevent.
- **A BENCH IS NOT A DROP AND MUST NOT WRITE THE LEDGER.** A benched card is blocked from being
  re-offered by OWNERSHIP, not by refusal. **`decline_draft` is the ledger's only writer**, and the
  no-return rule is unchanged: a declined offer is gone for the run.
- **A STEP THAT LISTS WHAT MAY BE BENCHED LISTS THE LOADOUT, NEVER THE POOL.** The pool holds
  benched cards, which cannot be benched again — listing them puts a button on the screen that the
  door correctly refuses and that therefore does nothing. **The bot has the same obligation**: a
  policy that names a card off `earned_ability_names` gets a refusal string back and counts a
  capped offer as an untaken one.
- **`bm_equipped` DEFAULTS TO THE WHOLE POOL AND THAT DEFAULT IS WHY NO SAVE WAS WIPED.** A member
  dict written before EG — a v11 save, and every suite fixture that stuffs `bm_abilities` — means
  exactly what it always meant: everything earned is carried. **Do not "tidy" that default away.**

## STANDING DESIGN RULE — A ZONE-BOSS AWARD ALWAYS PAYS (Batch EA §1, widened at EH §1)
> **THE AWARD IS A CHAIN OF THREE POOLS AND THE ORDER IS THE RULING: the hero's SPEC BOSS pool,
> then his SPEC DRAFT pool, then his CLASS-WIDE DRAFT pool.** Each is read only when the one above
> it comes back empty. Every tier is offered three at a time and **announced exactly like any other
> award.**

- **THE BASELINE IT REPLACED WAS NOT A WEAK REWARD, IT WAS SILENCE.** `award_ability_pick` returned
  false, `battle._award_ability_picks` skipped that hero, and the victory card did not name them.
  **Whatever a fallback pays, it must be announced the way a normal award is** — the announcement is
  the half that was missing, not the grant.
- **THE MECHANISM THAT EMPTIES THESE POOLS IS THAT `bm_abilities` IS ONE LIST.** A drafted card
  removes itself from the boss offer and vice versa, so **a fallback must exclude what the hero
  holds rather than assume the pools are disjoint.** Eight of the twelve specs can be emptied this
  way; **the Devout is the sharp case, not Holy** — his boss pool is two and both entries are
  draftable, so all three of his awards could pay nothing.
- **WHY THIS POOL, RECORDED WITH THE RULING SO IT IS NOT RE-LITIGATED.** It is the only candidate
  that keeps a zone-boss award feeling like one. A rune returns `[]` in a runes-off run, which
  reintroduces the hole somewhere else; gold does not move the depth table at all. And it stays
  SPEC-LOCKED, so AN §4's ruling holds.
- **THE FALLBACK POOL CANNOT BE EMPTIED BY THE LOADOUT, AND EG §2 MADE THE LOADOUT THE WRONG
  BOUND.** EA's arithmetic was that a hero holds at most `ABILITY_SLOT_CAP - core_slots(spec)`
  earned abilities against spec draft pools of ten to thirteen. **Both terms moved at EG**: the cap
  is a ladder to ten, and — decisively — **a benched card stays in the pool, so what a hero OWNS is
  every card he has ever taken and is bounded by the POOL rather than by the cap.**
  `owned_ability_names` is what the fallback filters on, so it is the pool that drains it.
  **UNDER THE LOADOUT BOUND THE FALLBACK STILL CANNOT EMPTY; UNDER THE POOL BOUND IT CAN.**
  `check_ea` §1 asserts the first and PRINTS the second, because closing the second is a design
  decision (a class-wide third tier, priced at EA and not taken) and **a gate encodes a ruling.**
  **The live floors are in `docs/state.md`; they are not restated here.**
- **AND "AN AWARD ALWAYS PAYS" AND "AN AWARD OFFERS THREE" ARE TWO CLAIMS.** They were one
  assertion until EG, because at a flat cap of seven the floor was six everywhere and both held.
  **The rule is the first one** (`floor >= 1`); the second is stricter, and the specs that can fill
  short are a NAMED SET in `check_ea` §1 rather than a loosened band.
- **AND `owned_ability_names` CANNOT SEE AN ABILITY A RUNE GRANTS** — the grant lands on the battle
  `cfg`, never on the member dict. That is pre-existing and shared by every channel, but it is the
  one term that can push the floor below the slot arithmetic, so **derive it off `runes.json`
  rather than assuming it is zero.** EH §1 derived it against the class-wide tier as well: **no
  rune grants a class-pool card**, on all twelve.
- **BATCH EH §1 TOOK THE THIRD TIER EA PRICED, AND EA'S RULING IS OVERTURNED IN ITS SECOND TIER
  ONLY, NEVER IN ITS REASONING.** The principle stands unchanged and is the reason the chain exists:
  a zone-boss award must always pay something real, and the baseline it replaced was silence. **The
  class-wide tier is class-locked rather than spec-locked, which is the one thing it gives up**, and
  it is NOT the thing DY §3 forbade — that rule bars re-creating the deleted `CLASS_POOLS`, and its
  own next sentence says a re-opened class draw reads `CLASS_DRAFT_POOLS`, which is what this reads.
- **AND THE THIRD TIER DEEPENS THE FLOOR; IT DOES NOT REMOVE IT. DO NOT WRITE THAT IT CANNOT
  EMPTY.** EA chose the tier above it on exactly that claim, and the claim was true when written and
  false one batch later. **No SIBLING drains the class pool** — every hero filters it against what
  he himself owns — **but the hero himself can**: roughly one draft card in four is class-wide, and
  `draft_card_is_class` returns TRUE unconditionally once the spec side is dry. What holds the floor
  up is arithmetic, not structure: emptying the chain means OWNING every card in both draft pools,
  and an offer pays at most one. **Under a fully-held LOADOUT no hero can be paid nothing; under a
  fully-held POOL every hero still can.** `check_eh` §2 asserts both directions.

## STANDING DESIGN RULE — THE PROTECTED CORE IS THE BASELINE (Batch EB §1)
> **A protected core may be cheaper and faster than a comparable draft card. The core is the
> baseline; the draft card pays for the slot it occupies.** A measurement showing cores are cheaper
> is the design working. **Do not retune the layer on that measurement alone.**

- **THE REASONING, WHICH HAS TO TRAVEL WITH THE NUMBER.** A protected core arrives FREE with the
  spec; a draft card costs a PICK out of a capped set of slots. **A draft card paying that pick in
  initiative and in resource is the correct relationship**, not a mispricing — "cheaper to cast" is
  exactly what a designer would author on purpose if the core is the baseline the spec is built
  around.
- **AND THE COUNTER-READING, RECORDED BECAUSE NOTHING IN THE CODE DISTINGUISHES THE TWO.** EA §3
  measured **13 of 17** comparable pairs favouring the core — controlled for spec, role and
  initiative, with `PURE_BUFFS` excluded from both sides — resource cheaper 10 to 2 and cooldown
  shorter 13 to 1. **A future reader will find that same consistency and read it as a systematic
  under-pricing of the cores.** Both readings fit the same numbers. This entry is the ruling that
  the first one is intended; it is not evidence against the second, and a designer who wants to
  re-price the layer is overturning a ruling rather than fixing a bug.
- **THE 13-OF-17 IS THE INTENDED STATE AND IS NOT WHAT A GATE SHOULD CATCH.** What is worth
  catching is the INVERSION: a draft card that is cheaper on resource AND shorter on cooldown than
  a comparable core, which is a card that pays no pick and gives none back. `check_eb` §1 asserts
  it per pair, in both directions, and PRINTS the live ratio without asserting it — `check_ea` §4
  owns the aggregate direction.
- **THE UNCONTROLLED FORM OF THAT PROPERTY IS NOT A PROPERTY, AND IT IS WORTH KNOWING WHY.**
  Dropped the equal-initiative control, **21 of 96** same-spec same-role pairs already have a draft
  card cheaper AND faster — Kindled Mind at 15 Mana and initiative 1.5 against Death Ray at 55 and
  5.0. That is a cantrip beside a nuke. **At equal initiative "faster" is impossible by
  construction, so the tempo axis that survives the control is COOLDOWN**, and a gate that asserts
  the uncontrolled form reads RED the day it is written.
- **EXACTLY ONE CROSSOVER EXISTS AND IT IS NAMED RATHER THAN COUNTED.** Holy's **Divine Plea**
  (0 Mana, cooldown 2) against **Renewal** (20 Mana, cooldown 3) at the same initiative in the heal
  role. Against Holy's **Heal** the same card is cheaper and LONGER, which is an ordinary trade and
  not a crossover — EA §3's two counter-cases are one crossover and one trade.
- **THE CAP BINDING THE TWO LAYERS AT DIFFERENT RATES IS THE SAME RELATIONSHIP, NOT A SECOND
  FINDING.** `Ability.BUFF_DELAY_CAP` reaches **29.5% of the draft layer against 12.8% of the
  cores**. Under this ruling that is what a priced layer looks like beside a baseline one: the
  instrument that prices tempo reaches the side that pays. **It is not a defect and it is not a
  reason to widen `Ability.PURE_BUFFS`** — EB widened nothing and moved no magnitude.

## STANDING DESIGN RULE — THE ARRIVING-STANCE PRINCIPLE (Batch BP §3)
**EVERY STANCE ABILITY MUST BUY WHAT THE STANCE IT LEAVES HIM IN WANTS.** The Swordmaster's
stances were a binary toggle with passive numbers on each side and NOTHING in his kit ever
behaved differently depending on which one he was in; BP's two draft cards (Precision Strike,
Feint) both READ the stance and then SWITCH it, and both are authored against this rule. Cast
from Aggressive he lands in Defensive, so the ability hands him **defence**; cast from Defensive
he lands in Aggressive, so it hands him **offence**. **He is never stranded — he always arrives
holding something, and that is what makes the switch a feature rather than a tax.**
**IT IS RECORDED AS A RULE BECAUSE IT IS THE THING A LATER STANCE ABILITY WOULD MOST EASILY GET
BACKWARDS** — the intuitive authoring ("the Aggressive branch is the offensive one") produces
exactly the inverted card, and it would still read fine on the tooltip.
· **THE PIVOT IS ONE IMPLEMENTATION, THREE CALLERS — `_swordmaster_switch(u)`** (Guard Change,
  Precision Strike, Feint). Batch AK's Guard Change could afford to own the pivot inline while it
  was the only swap in the game; three copies of "flip it, restamp the chip, pay Pivot" drift.
· **PIVOT IS PART OF THE SWAP AND NOT PART OF GUARD CHANGE**, and that is a decision: the node's
  text reads "Switching stance grants +30% damage for 1 turn" and NAMES NO ABILITY, so a swap
  that skipped it would make a shipped tooltip false. Everything Guard Change pays BEYOND the
  pivot — its Break damage, Sunder Guard, No Quarter, the parry perfect — stays on Guard Change.
· **stance-GATED ABILITIES WERE BUILT IN BATCH BW — see the standing rule directly below.** BP
  named them a future direction and deliberately did not build them; the rule they wanted is now
  written, and it is the READERS-BRANCH-AND-FLIP / GATED-REQUIRE-AND-STAY distinction.
· **"GUARD CHANGE IS THE ONLY STANCE SWAP IN THE GAME" IS NO LONGER TRUE** and `PROTECTED_CORES`
  says so. It is still the Swordmaster's enabler for a sharper reason: it is the only
  UNCONDITIONAL swap — the other two are DRAFTED (he may never be offered either), cost Rage, and
  sit on 3- and 4-turn cooldowns.

## STANDING RULE — AN ENGINE IS EXCLUSIVE, AN AXIS IS SHARED (Batch DR §1)

**TWO THINGS WERE BOTH BEING CALLED "AXIS" AND SEPARATING THEM IS WHAT MAKES THE RULE WORKABLE.**

> **An ENGINE is the spec's own currency** — stances, Loyalty, Focus, Resonance, Ruin, Faith,
> Mercy, Burn, Chilled, Frenzy, Block. **Exclusive by construction, one per spec.** This is where
> identity lives.
>
> **An AXIS is an effect type** — single-target damage, area damage, healing, shielding,
> mitigation, control, tempo, Break, resource generation, meter manipulation. **Shared, and
> deliberately so.**
>
> **A pool is one exclusive engine plus a selection of shared axes.** A pool covering few axes
> holds one build no matter how strong its engine is.
>
> **Adding axes to a spec does not dilute its identity; the engine still gates everything.**

**THIS IS THE RULE POOLS ARE AUTHORED AGAINST NOW, INSTEAD OF BY FEEL.** DQ measured the
Swordmaster at ten cards making FOUR decisions — a player who had drafted four had seen everything
his pool decides — while his engine (the stance) was as strong as any in the game. **Depth of
engine is not breadth of pool, and only the second one is what a draft offer is asking about.**

### THE EXCLUSIVE AXES, AND THERE ARE TWO — NOT THREE

**ASSERTED AS PROPERTIES IN `check_dr`, NEVER AS COUNTS.** DN's gate asserted two exclusives and
there were five; DO's brief asserted nine grant-capstones and there were twenty-two; **DR's own
brief asserted three exclusive axes and one of the three was false.** A count is a fact about
today; a property is the thing worth pinning.

· **COMPANION SUMMONING — THE BEASTMASTER.** True, and verified over the whole corpus: `special:
  "summon"` exists on exactly three abilities and all three are his protected core, and
  `_do_summon`'s only other caller is his own draft card Call the Wilds.
· **REVIVAL — THE HOLY CLERIC, AMONG ABILITIES.** True with a qualifier the gate prints rather
  than hides: `BattleUnit.revive()` has **two** callers, `resurrection` (hers) and the **REVIVE
  POTION**, and the `revive_pct` map event is a third channel. **Exclusive as an ability; not
  exclusive as a channel.**
· **COOLDOWN MANIPULATION IS *NOT* THE SWORDMASTER'S, AND THE CLAIM THAT IT WAS IS THE USEFUL
  RECORD.** `_tick_cooldowns` has **SEVEN** callers: Answering Steel and Battle Poise (his),
  **BLINK — a MAGE CLASS-WIDE DRAFT CARD whose own comment names tempo as its axis**, **BLESSING OF
  ZEAL — the Devout's PROTECTED CORE**, and three talent nodes (Frostbound Hours, Cryomancer Thaw
  r8, which ticks EVERY hero's; Practised Hands, Survivalist Guerilla r8; Follow-Through,
  Sharpshooter Pace r5). Five more sites clear a cooldown outright through `cooldowns.erase` —
  Sever on a Broken target, Hex of Ruin's perfect, Apex Predator, Overkill, Mark of the Hunt —
  plus Terminal Velocity. **What IS one implementation is the FUNCTION** (BQ extracted four
  hand-written copies); what is shared is the axis.

**BEFORE DECLARING AN AXIS EXCLUSIVE, DERIVE THE POPULATION THAT TOUCHES IT.** A one-door helper
that "only two cards call" is the shape this went wrong in: **a single implementation reads like a
single owner and is not the same thing.**

### AND THE SAME RULE POINTED THE OTHER WAY — BEFORE DECLARING AN AXIS *ABSENT*, DERIVE IT TOO (Batch DS §1)

**DR'S BRIEF WAS WRONG ABOUT AN AXIS BEING EXCLUSIVE; DS'S WAS WRONG ABOUT ONE BEING MISSING, AND
THE SECOND ERROR IS THE EASIER ONE TO SHIP.** DS's brief held that *"the Hunter class has no Break
generation anywhere"* and asked for a Beastmaster card to be the class's first. **TWELVE OF THE
THIRTY HUNTER DRAFT CARDS GENERATE BREAK** — `pressure` IS Break, so a card generates it without
ever saying the word, which is exactly why an eyeball over the descriptions missed it. **UNLEASH
ALREADY LANDS BREAK ON THAT VERY POOL** and FAULT LINE is a dedicated Break card the audit scores
as one of the Sharpshooter's five decisions. The proposed card would have been a second copy of a
clause already in its own pool — a BD §4 violation authored on the strength of a sentence.
· **THE MEASUREMENT IS A FIELD SWEEP, NOT A READING.** An absence claim is only as good as the
  field it was derived from; derive it from the DATA (`pressure > 0`, `heal > 0`, the `special`),
  never from the card text, because a card's payload and its prose are different populations.
· **THE AXIS THAT REALLY WAS ABSENT WAS A DIFFERENT ONE.** HEAL, SHIELD and every MIT- axis were
  genuinely missing from all twenty-four Hunter spec cards, and so were AMP-TEAM, RESOURCE, STRIP,
  DOT, METER-MOVE and DEATH-DENY. **Nine absent axes, not three** — so the brief's diagnosis was
  right and its remedy was aimed at the one axis the class already had.

### A REPEATABLE DRAFT CARD IS A LEGITIMATE SHAPE WHEN IT IS PRICED ELSEWHERE (Batch DU §1)

**PYROBLAST KEEPS COOLDOWN ZERO, AND THE REASONING IS RECORDED BESIDE THE RULING RATHER THAN LEFT
TO BE RE-DERIVED.** DQ's finding was that it is the only repeatable card in the draft; DR then gave
LUNGE a cooldown for exactly that shape. **Without the reasoning written down, the next batch reads
the two decisions as an inconsistency and "fixes" the wrong one.**

> **A cooldown is not this project's only rate limiter.** A card priced hard enough on TEMPO or on
> RESOURCE is already bounded, and a cooldown laid on top of that prices it twice.

· **DR's PRECEDENT DOES NOT TRANSFER, AND THE MEASUREMENT IS WHAT SAYS SO.** The PROVENANCE is
  identical — both were talent grants DO moved wholesale into `SPEC_DRAFT_POOLS`, and both walked
  in still carrying the cooldown a gated lane-end ability never needed. **The premise is not.** DR's
  argument was *at the end of a talent lane the price was the node, and in a pool there is no
  price*. Lunge cost 25 of a 100 bar at 3.5 delay — **ordinary on both axes**, so that was
  literally true of it. **PYROBLAST'S 6.0 DELAY IS THE LONGEST IN THE PROJECT with nothing above
  it** (three times `Ability.BASIC_DELAY`), and **its 45 mana is the SECOND-HIGHEST COST IN THE
  GAME** — the only card above it is Death Ray at 55, **which carries cooldown 3**. A full
  Pyromancer bar buys two casts with ten to spare.
· **AND COOLDOWNS TICK IN THE UNIT'S OWN TURNS.** A 6.0-delay cast has already spent three basic
  attacks' worth of tempo before a cooldown would begin counting down, so a cooldown of 3 would
  roughly HALVE the frequency of a card whose entire identity is the one enormous slow blow.
· **IF ONE IS EVER TAKEN ANYWAY IT IS ON THE UNIQUENESS ARGUMENT AND NOT THE PRICE ONE, AND IT IS
  2 RATHER THAN DR's 3** — 3 would price Pyroblast strictly above the card that is strictly
  heavier on both of the axes a cooldown is not measuring.
· **THE POPULATION IS RE-DERIVED EVERY RUN AND NOT REMEMBERED.** `check_dr` §5 prints the live
  cooldown-zero draft list on every battery. **It walks the DRAFT pools only**, deliberately — the
  boss-pick pools are a separate census, and folding them in would make every earlier reading of
  that line incomparable. DU §5 audited them separately and ruled on nothing.

### A DEAD PLAYER CARD IS A DEAD CARD; A DEAD ENEMY DEBUFF IS AN EXPLOIT (Batch DU §2)

**THIS IS THE LINE THAT SEPARATES DU's WIDENING FROM DK's REFUSAL TO WIDEN, AND BOTH DECISIONS ARE
CORRECT UNDER IT.** DK found Empower attaching perfectly to a companion and paying nothing, and
ruled the CARD's text narrow rather than teaching `_companion_hit` to read it — because widening a
damage loop moves a balance number, which is the designer's. **DU widened it for Cripple and
Chilled.** The difference is not size and it is not confidence:

> **A player effect that lands and pays nothing costs the player a card.**
> **An ENEMY effect that lands and pays nothing costs the player nothing — it is a malus the
> player is escaping, and the chip says otherwise.** The first is a dead card; the second is an
> exploit, and only one of them is fixed by narrowing the words.

· **WHAT IT REACHED THROUGH.** `_choose_enemy_action` picks its target from `_hero_side()`, which
  holds the living companion, and `_apply_status` lands the rider on whatever was struck **with no
  companion filter** — so two enemy abilities landed a -25% that never applied. Chilled reaches one
  through the frost battle modifier, which stamps a summoned companion deliberately.
· **NARROW, AND NAMED.** `_companion_hit` reads those two statuses and nothing else. **Of the hero
  strike loop's 84 multiplier terms, 76 of the misses are unreachable BY SHAPE** — the function
  takes a float and not an `Ability`, a companion's `passive_id` is always empty, and every
  talent-rank field on one is always zero. **A GENERAL WIDENING WOULD HANG VISIBLE CHIPS ON A
  COMPANION THAT CHANGE NOTHING, WHICH IS WORSE THAN THE NARROW MISS BECAUSE IT READS AS WORKING.**
· **A MAGNITUDE CHANGE IS MEASURED, NOT ASSERTED, AND THE GATE IS PART OF THE RULING.**
  `check_du` §1 and §2 measure the ratios on forty seeded blows every battery run — 1.0000 before,
  0.7501 after for Cripple — because a gate that asserted the READ SITE EXISTS would have passed on
  every one of the nine statuses DT measured attaching and paying nothing.
· **AND AN EFFECT CAN BE INERT TWICE OVER.** Typed relic damage CAN be written onto a companion,
  and is still deliberately unread: **a companion's blow carries no damage type at all**, so the
  read would find nothing to apply. Fixing half of that would read as working while paying exactly
  what it pays now.

## STANDING REFERENCE — AN ENGINE, AN AXIS, AND NOW A TAG (Batch EK §1, NAMED AT EL §2)

**THREE VOCABULARIES, AND THEY ARE NOT THE SAME ONE.** DR separated the first two; EK adds the
third and it is the only one the player ever sees.

> **An ENGINE is the spec's own currency.** Exclusive, one per spec. Identity.
> **An AXIS is an effect type** — single-target damage, healing, control, tempo. Shared, internal
> to the design audits, and **never shown to a player**.
> **A TAG is what a card is FOR**, in seven words the player reads on the draft card:
> **DEBUFF · DEFENSE · BREAK · RESOURCE · OFFENSE · TEMPO · MARK.** Carried by every ability in
> the corpus and every authored rune, at most two a card, **the first is the primary**.

- **THE TABLES ARE `Classes.CARD_TAGS` AND `Runes.RUNE_TAGS`, AND EACH HAS EXACTLY ONE ACCESSOR.**
  `Classes.card_tags()` / `Runes.rune_tags()`, with `Classes.card_tag_line()` the ONE builder of
  the displayed string (CK §1's rule one layer down). A batch keying anything off a tag comes
  through those doors and nowhere else.
- **THEY ARE MECHANICALLY INERT AND THAT IS A RULING, NOT AN OVERSIGHT — RE-AFFIRMED AT EN §5.**
  No clause reads a tag count, no card's behaviour changes, no magnitude moves. **WHETHER RUNES
  EVER READ A TAG WAITS UNTIL THE DESIGNER HAS PLAYED WITH TAGS ON A REAL DRAFT SCREEN**, and EM
  deliberately keyed nothing to a tag while re-keying 56 clauses past them. **The game-side
  population stays at THREE** and a batch is not owed a differential mechanism for having touched
  the rune layer. **`check_ek` §3 asserts it as a
  POPULATION** — every `.gd` in the repo is swept comment-stripped, and **EL §3 SPLIT THAT
  POPULATION IN TWO BECAUSE IT WAS TWO CLAIMS**: the files in the SHIPPED GAME that name a tag are
  pinned at **THREE** (`classes.gd` and `runes.gd` define, `map_screen.gd` displays) and the
  TARGETS that check one are listed separately. **A fourth file in the game is the fault this
  section exists for; a fourth gate is not**, and rolling them into one number made writing a new
  gate indistinguishable from breaking the rule. ZERO is still asserted separately in `battle.gd`,
  `unit.gd`, `talents.gd`, `run_state.gd`, `run_sim.gd` and `ability.gd`.
- **THE VOCABULARY IS MECHANICS BECAUSE THE CORPUS DOES NOT HOLD SIX STATUS NAMES, AND THAT IS
  MEASURED RATHER THAN ASSERTED.** The six biggest status FAMILIES in the game (Burn, Frost, Bleed,
  Poison, Ruin, Mark) reach **40 of the 154 draft cards and leave 114 with nothing**. The reason is
  structural: **a status system belongs to one spec, so it does not vary inside the pool the player
  is drafting from** — the Pyromancer's pool is 12 Burn cards of 13. The seven shipped cover **154
  of 154**. Full working and the alternative set: `docs/reports/EK.md` §1.
- **SEVEN IS THE CEILING AND AN EIGHTH NEEDS AN ARGUMENT (RULED AT EL §2).** A tag only means
  something if **holding two is notable**. Every word added divides the corpus finer, and the point
  at which a pool of ten to thirteen cards stops producing a repeated combination is the point at
  which a second card on a tag stops being a signal. **Seven is where the next one starts costing
  meaning.** `check_ek` §2 pins the count as an EQUALITY so an eighth is a decision somebody made,
  and prints the spread so the claim can be re-tested rather than taken.
- **A TAG NAME IS SWEPT LIKE AN ABILITY NAME, AND THE SWEEP'S POPULATION IS WIDER THAN "EVERY
  ABILITY, NODE, STATUS AND RUNE".** EK swept those four and shipped two renames off them (WARD →
  SHELTER, TEMPO → CLOCK). **EL found three surfaces that sweep could not see** and added all
  three to `check_ek` §4: **talent and rune LANES** (`_collect_names` reads `"name"` keys, and a
  lane lives under `"lane"` — `Tempo` was the Sharpshooter's third lane in nine nodes while the
  sweep called the tag clean), **item ids and names** (`defense` is the Defense Potion, and the
  pouch button renders `Defense` on the same screen as the draft card), and **relics**. **And the
  status-LABEL arm was repaired**: it asked whether `battle.gd` contained `["Ward",` — an exact
  whole label — so it was blind to every label merely CONTAINING the word, which is why the
  `party_mark` chip reading *"Hunter's Mark"* went unseen. Every label is word-boundary matched now.
- **TWO OF THE SEVEN SHIP WITH NAMED COLLISIONS, AND THE EXEMPTION IS A LIST RATHER THAN A SKIP.**
  `check_ek` §4 compares each tag's clash set against `CLASH_EXEMPT` as an EQUALITY, so a fifth
  collision still trips. **MARK meets Hunter's Mark, Quarry's Mark, Mark of the Hunt and the
  `party_mark` chip — and all four MEAN what the tag means**, which is not what happened to WARD
  (`Ward` meant *takes 50% less Break damage*). **DEFENSE meets the Defense Potion**, which carries
  no tag and can never render beside one on a row. **A SAME-MEANING COLLISION SHIPS AND IS NAMED; A
  DIFFERENT-MEANING ONE IS RENAMED.** That is the line EL drew, and it is the reason the two words
  the brief flagged hardest are still the words.
- **EL §1 FREED `Tempo` BY MOVING THE CHEAP SIDE, AND THE CHEAP SIDE WAS SIX STRINGS.** The chip is
  **PIVOT** (its own legend already said *"the pivot's momentum"*), `sm_deep_thrust` is **Pivot**,
  `cr_icy_veins` is **Shockwave** (`battle.gd`'s own log line already said *"the shockwave sets the
  field back"*), `dv_crusade` is **Crusade** — **the name its `crusade_ranks` counter always
  carried, so CK's Ironclad precedent brought in no new word** — and the Sharpshooter's third lane
  is **Pace**. **THE STATUS IDS DID NOT MOVE** (`tempo`, `shattered_tempo`, `crusade_ranks`): the
  collision was the LABEL, and each declaration in `unit.gd` now names its display word so the id
  stays traceable.
- **RENAMING THE VOCABULARY COST 292 ROWS, AND THAT IS A FINDING ABOUT THE DESIGN.** `CARD_TAGS`
  and `RUNE_TAGS` hold the words as LITERALS, not as references to `TAG_ORDER` — so every row
  moved. **What did hold is the property that mattered**: no reader outside those two tables names
  a tag word, so the rename never left `classes.gd` and `runes.gd` and not one clause in the game
  had to be read. **A future rename is the same shape: two files and a `sed`, plus the documents.**
- **A TAG IS DERIVED FROM THE READ SITE, NEVER FROM THE NAME OR THE DESCRIPTION**, and on this
  corpus a field-level reading produces almost nothing: **`heal` is 0 on all 154 draft cards** and
  123 of them carry a `special`. The read site of a card is its arm in `_resolve_special`, **plus
  every block keyed on its `display_name` in the hero strike loop** (58 abilities carry one, and
  Blood Debt's whole payload is one of them), plus the card-specific helpers those call, **plus
  whatever reads the status a setup card lays** — Aegis Wall applies `aegis_wall` and nothing else,
  and its healing is in the BLOCK handler.
- **AND THE READ SITE FOR A WHOLE TAG CAN ALREADY BE WRITTEN DOWN IN THE GAME (EL §2).** MARK's
  population is not a judgement about which cards feel like marks: **`battle.DISPEL_NEVER`'s own
  comment names them** — *"the five MARKS the party applies — covenant, quarry, snare_line,
  feinted, hunt_mark"*, with `blood_debt`, `vendetta` and `reacquire` named the same way, plus
  `party_mark` and `arcane_echo` whose card texts say *"one mark at a time"*. **That list gives TEN
  cards; EK's reading of the card texts gave six** and missed Covenant of Ash, Snare Line and Feint
  entirely. **`check_el` §1 derives the cards LIVE** out of `battle.gd`'s apply sites and requires
  the table to agree in both directions, so an eleventh mark cannot arrive with its card untagged.
- **A NEW ABILITY OR RUNE IS OWED A ROW IN THE SAME BATCH.** `check_ek` §1 walks
  `Classes.ability_corpus()` and `Runes.ids()` and requires a tag on every one, **and requires the
  tables not to outrun them either** — a row naming a card that does not exist is the shape
  `CLASS_POOLS` spent eighteen batches in.
- **`master.html` §6c IS A DERIVED TABLE NOW, NOT A TRANSCRIBED ONE (EL §2).** `check_el` §2 parses
  the section and requires its words, their order and their meanings to be `TAG_ORDER` and
  `TAG_INFO` word for word, and requires the five retired words to be absent from it. **EH proved
  that document's factual prose is asserted by nothing**; this is the one part of it that is
  machine-comparable, so it is compared.

## STANDING RULE — THE THREE DOORS THAT BITE A NEW DRAFT CARD (Batch DS §2)

**ALL THREE ARE MECHANICAL, ALL THREE WENT RED ON DS'S FIRST RUN, AND ALL THREE ARE CHEAPER TO
READ HERE THAN TO REDISCOVER.**
· **A PURE BUFF ADVERTISES NO PERFECT.** `Ability.runs_skill_check()` gives a bar to damage,
  Break damage, healing, a `gated` card, and the named `DAMAGE_SPECIALS`/`HEAL_SPECIALS` — and to
  nothing else. `test_batch_bo` §5 asserts the BICONDITIONAL, so a buff carrying `perfect_text`
  trips. **Four of DS's six were authored with a Perfect and had to lose it**; SALVE kept its by
  joining `HEAL_SPECIALS`, which is honest rather than a workaround — its heal rides a status it
  applies, which is RENEWAL's shape, and that list is the answer to *"is this card a heal"*.
· **A RECAST PROPOSAL MUST EQUAL WHAT A *GOOD* CAST WRITES.** `check_co` saturates by casting at
  grade `"good"`, so `_recast_writes` proposing the PERFECT's duration improves on what is
  standing every time and the card never refuses a wasted recast. `emberkeep` looks like a
  counter-example and is not — its handler writes `EMBERKEEP_TURNS + 1` unconditionally.
  **A card whose `special` carries a POWER needs its own arm rather than a `RECAST_SELF_PLAIN`
  row**, because that table writes `power: 0`.
· **`DEBUFF_IDS` IS FOR ENEMY-SIDE AFFLICTIONS AND A HERO-SIDE BUFF MUST NEVER BE LISTED.** DS's
  brief asked for all six of its statuses there; five sit on a HERO, and listing one puts the
  party's own work inside the cleansable set for a mender's Cleansing Rite. `unit.gd`'s list names
  five existing deliberate absences for this reason. **The one that did belong is the one that
  lands on an enemy** — and being listed is what makes it feed a Survivalist's Trapper breadth.


## STANDING RULE — READERS BRANCH AND FLIP; GATED ONES REQUIRE AND STAY (Batch BW §3)
**THERE ARE NOW TWO KINDS OF STANCE CARD AND THE DISTINCTION GOVERNS EVERY FUTURE SWORDMASTER
ABILITY.** A **READER** works in either guard, does something DIFFERENT in each (BP's
arriving-stance principle decides which branch buys what), and then **SWITCHES** him — Precision
Strike and Feint. A **GATED** card **REQUIRES** a guard: in the wrong one it is **REFUSED OUTRIGHT**
— unavailable, not a weaker branch — and casting it **MOVES NOTHING**. Sever (Aggressive) and
Battle Poise (Defensive) were the first two, and **COUNTER TIME (Defensive, Batch DR §4) is the
third**. **GETTING THE TWO CARD TYPES BACKWARDS IS THE EASIEST MISTAKE TO MAKE ON THIS SPEC**, and
both wrong versions read fine on a tooltip.
· **A GATE MUST BUY SOMETHING (Batch DR §3).** Battle Poise's Defensive requirement was pure cost
  with nothing bought by it, which is precisely why ANSWERING STEEL — cheaper, longer, ungated,
  paying the same cooldown tick plus two clauses more — held its whole payload as a subset. **A
  stance requirement with no payoff is a domination waiting to be measured.** It buys a free GUARD
  CHANGE once a turn off a parry now, which Answering Steel cannot have because it has no
  requirement to reward. **The free pivot asks `_ability_usable` about the REAL Guard Change** —
  the same door — so Formless refuses it and Guard Change's own 1-turn cooldown is respected, in
  one place rather than two that could disagree. **It is the PIVOT and not the ability**: Guard
  Change's own 15 BD, Sunder Guard's 40-to-every-enemy, No Quarter and Pivot stay on that card, or
  a Defensive build parrying twice a turn lands 80 free Break across the field every turn.
· **`_ability_usable` IS THE DOOR**, matching how Death Ray's Resonance gate and BV's nine are
  refused — so the greyed button, the bot's drafted-pick wrapper and the cast itself can never
  disagree. A gate written at resolution instead would be a different, much smaller ability.
· **FEIGNED GUARD SATISFIES THE GATE AT `_ability_usable`, AND THAT CLAUSE IS WHAT MAKES THE CARD
  WORTH A SLOT.** For 2 turns his ABILITIES resolve as though cast from the other stance **and
  satisfy that stance's requirement**, while he keeps the guard he is standing in. Merely changing
  the branch taken at resolution is a minor modifier; satisfying the gate is what lets an
  Aggressive build cast Battle Poise and a Defensive build cast Sever. **THOSE ARE TWO DIFFERENT
  SITES AND ONLY THE FIRST MAKES THE CARD TRUE** — test_batch_bw drives it AT THE DOOR.
· **IT DOES NOT SWITCH THE STANCE AND MUST NOT BE BUILT TO.** There is deliberately no
  `_swordmaster_switch` call in its branch and test_batch_bw asserts the absence; a later author
  adding one "for consistency with the other two stance cards" deletes the ability.
· **ONE HELPER, `_eff_stance(u)`, AND ITS SCOPE IS ABILITIES ONLY.** Callers: the stance gates in
  `_ability_usable` (Sever, Battle Poise and DR's Counter Time), the `precision_strike`, `feint`
  and `wheeling_cut` branches, and Lunge's stance-keyed wound and its Break rider.
  **SEASONED FIGHTER (the passive), KILLING EDGE, BRACING AND UNTOUCHABLE ALL KEEP READING
  `u.stance` DIRECTLY**, so an Aggressive build under a Feigned Guard keeps Aggressive's damage
  bonus the whole time — which is the synergy the card is sold on. **Widening the helper to the
  passive would delete that, silently**; test_batch_bw pins the passive's read site.


## STANDING RULE — CHARGES AND ON-HIT EFFECTS COUNT HITS, NOT CASTS (Batch BR §1)
**A multi-hit ability spends one charge PER HIT and fires its on-hit effects PER HIT.** Aimed
Volley is three shots; under Arcane Arrows it spends **three** of five charges and forks **three**
times. Magic Missiles and Called Volley behave the same way. **This is a real power increase for
multi-hit abilities and it is deliberate — it is what makes a multi-hit kit and a charge bank a
BUILD rather than a coincidence.** A strike that MISSED or was BLOCKED spends nothing, and neither
does one an absolute parry zeroed: a charge rides a blow that landed.
· **WHERE IT LIVES**: `_arcane_arrow_splash` is called from INSIDE `_resolve`'s `for hit_i in
  total_hits` loop, after the strike resolves, and ONE function both spends the charge and deals
  the blow. It reads `final` — the damage THIS hit actually dealt — rather than re-deriving from
  the ability's nominal damage, which would drift the moment a crit, a resist or an armor read
  differed.
· **APPLIED RETROACTIVELY, AND WHAT CHANGED IS ONE THING: MIRROR IMAGE** (BQ) now spends one image
  per hit of a multi-hit attack. The gate is `multi_hits` ALONE, which keeps the card's promise
  true — a multi-hit ability is repeated strikes on ONE target, i.e. single-target, while an area
  attack, a random scatter and a chosen pair are not and still spend nothing. **IT CHANGES NOTHING
  IN PLAY TODAY**: no enemy in enemies.json carries `multi_hits` or `random_hits` (asserted, not
  assumed) and heroes do not attack the Mage. It is the rule made TRUE ahead of its use.
· **THE OTHER THREE CHARGE BANKS ALREADY COUNTED HITS** — Interpose's `shield_charges` (the block
  branch), Waiting Guard's `banked_guards` and Feint's `feint_guards` (both on the parry roll).
  All three sit inside the strike loop. Verified at their sites; no change.
· **ONE PLACE THE RULE WAS DELIBERATELY NOT APPLIED, AND IT IS A FINDING RATHER THAN AN OMISSION:
  SPRAY OF ARROWS**, gated `ab.multi_hits == 0 and ab.random_hits == 0` by Batch AZ's own design
  (`spray` is how many extra ENEMIES a single shot finds; a multi-hit already finds its target
  three times). Firing it per hit would TRIPLE a shipped talent's magnitude — a balance change the
  standing testing scope forbids measuring. The same shape applies to the Survivalist's post-loop
  on-hit package (Coated Blades, Venom Coating): moving it inside the loop would triple its output
  AND change whether a missed or blocked strike still applies it, a second unasked change riding
  along. Both are pinned in test_batch_br so a later batch reads the reasoning first.

## STANDING RULE — EVERY ABILITY NAMES WHAT IT BUILDS WITH (Batch BT §1)
**FROM TRANCHE 2 ONWARD, AN ABILITY THAT CANNOT NAME ITS COMBO HAS NOT BEEN DESIGNED YET.**
Tranche 1 asked what GAP a card filled, which was the right question against a pool of two — with
the pool that thin, anything coherent was an improvement. **At five per spec that question stops
discriminating**: five cards each filling a different gap are still five cards nobody plans a run
around. So every ability authored from here on NAMES what it is meant to be played beside — which
TALENT NODE, which OTHER CARD, which CAPSTONE — and the line ships in three places: the comment
above the definition in `classes.gd`, the `Builds with:` line in master.html's draft table (which
is what a player actually reads), and the changelog entry. **A CARD THAT APPEARS IN NOBODY'S BUILD
PLAN IS A CARD THAT FILLS A SLOT.**
· **IT IS AN ACCEPTANCE TEST, NOT DOCUMENTATION, and test_batch_bt makes it mechanical**: each of
  the nine must carry both an `AXIS:` and a `SYNERGY:` line in the comment above it. A tranche that
  skips the line trips.
· **IT COMPOSES WITH THE OLDER RULES RATHER THAN REPLACING THEM.** The axis line (BO §5) still
  says what the card is FOR; BD §4's "no ability may be a strictly better version of another in
  the same pool" still binds; BR §1's name sweep still runs first. The synergy line is what
  catches the card that passes all three and is still inert.
· **WHAT IT CAUGHT IMMEDIATELY, and it is why the rule earns its keep: FLASH FREEZE IS STRICTLY
  DOMINATED BY GLACIAL PRISON on cost, initiative and cooldown.** Writing the synergy line is what
  forced the comparison. See the BT block for the resolution (the acquisition channel is the
  distinction, and the perfect is what stops it being dominated outright).

## STANDING RULE — A STATUS IS APPLIED WITH ITS `src` (Batch DI)
**`_apply_status`'s sixth argument is not optional in spirit.** It has stamped `src_name` onto the
status since Batch W, and a site that omits it does not fail — it silently mis-credits everything
that reads the source. **A missing `src` is invisible by construction**: an unstamped status and
one the reader applied himself are the same value to every consumer, so the defect can only ever
be found by counting call sites, never by playing.
· **DH's HARVEST CLAUSE IS THE FIRST THING IN THE GAME WHOSE MAGNITUDE DEPENDS ON IT**, and it
  shipped one batch ahead of the plumbing. It pays 12% a status rising to 18% when the whole board
  is the party's work; against a realistic board DI measured the under-payment at **3923 → 5308,
  a 35% correction**. It was not a rounding error and it was not visible anywhere.
· **A CLAUSE WHOSE MAGNITUDE DEPENDS ON INCOMPLETE PLUMBING IS WORSE THAN ONE THAT DOES NOT
  EXIST**, because it looks like it works. When a clause starts reading a field, the same batch
  owes a count of how many writers actually write it.
· **WHERE THE TRUE SOURCE IS AMBIGUOUS, REPORT IT — DO NOT PICK.** A status applied BY a status, a
  reflected effect, an item nobody holds, an environmental stamp. **Getting the source wrong is
  worse than leaving it absent**: absent under-pays, wrong mis-credits. DI left fourteen sites
  unstamped for exactly this reason and named every one in `docs/reports/DI.md` §2.
· **AND RESOLVE THE NAME AGAINST THE PARTY, NEVER MERELY COMPARE IT TO YOUR OWN.** `_apply_status`
  stamps for ANY source, an enemy's included, so `src != self.unit_name` reads one enemy's debuff
  on another as the party's work.
· **`heroes` DOES NOT CARRY THE COMPANIONS** — see the standing rule of its own below, which DJ
  earned by closing this. Harvest's ally loop walked `heroes`, so a wound Aguila opened paid the
  base rate however it was stamped; **DI left the seven companion sites unstamped rather than let
  the sweep look complete while the wound still paid nothing**, and DJ stamped them with the loop.
· **AND MEASURE COVERAGE WITH A WALK, NOT A `grep`** — see the second standing rule below, which
  DJ earned from this. `check_di` §1 balances parens, skips comments, and PRINTS the live figure
  on every battery run.

## STANDING RULE — `heroes` DOES NOT CONTAIN THE COMPANIONS; `companions` DOES (Batch DJ §1)
> **Any loop implementing the *ally* convention must read BOTH.** A loop over `heroes` alone
> silently excludes companions and **reports nothing** — it looks like a balance quirk, not a bug.

**`heroes.append` is reached at exactly ONE site**, the party spawn; a summoned beast is appended
to `companions` at the one place a companion is built. Nothing else ever writes either array.
**The line numbers that used to stand here are deleted rather than re-numbered** — DK's own edits
moved one of them, which is this block's neighbouring rule met in the wild.
· **THE THREE IDIOMS, AND THEY ARE NOT INTERCHANGEABLE.** `heroes + companions` is the union **dead
  or alive**; `_hero_side()` is the union **of the living only**; bare `heroes` is the four, and no
  `not h.is_companion` clause on it changes that — **all 23 such filters in `battle.gd` are
  filtering an array that cannot hold one.** They record the author's INTENT, which is worth
  reading. They are not what does the excluding.
· **AND A PER-TURN EFFECT IS A FOURTH EXCLUSION NOBODY WRITES DOWN.** `_next_unit()` walks
  `heroes + enemies`, so a companion takes no turns — a "each ally, each turn" clause can never
  reach one however its collection is spelled.
· **PICKING THE UNION IS A DECISION ABOUT `dead`, NOT ONLY ABOUT COMPANIONS.** `docs/reports/DI.md`
  proposed DJ's fix as *"one word: `heroes` → `_hero_side()`"*. **That word would have been
  wrong.** Harvest's loop deliberately does not filter `dead` — a hero who has since fallen still
  opened the wound — and `_hero_side()` does. Measured: the suggested fix passes the companion
  check at 1.5000 and drops a fallen opener's board to **0.6664**, a fresh 33% under-payment in the
  same loop, in the same shape, introduced by the fix for the first one. **`check_dj` §4 is the
  control that catches it.**
· **THE COST OF GETTING IT WRONG IS SILENCE.** Before DJ, a companion-opened board paid **exactly
  1.0000** of a self-opened one — the bonus simply did not arrive, and no log, no test and no
  battery said so. It now pays **1.5000**, which is what a hero's wound pays.
· **DJ SWEPT ELEVEN AND RULED ON NONE; DK RULED ON ALL ELEVEN AND THEY SPLIT FOUR AND SEVEN.**
  **FOUR had their CODE corrected** and now read `_hero_side()` — Rally, Hold the Line, Sanctuary,
  Field Medic. **SEVEN had their TEXT corrected to "hero"** — Rallying Cry, War Stomp and Rallying
  Shout's RESOURCE clause (a beast has no resource bar — **its Pressure clause is a separate
  ruling and DL §1 widened it**), Devoutness and Last Hope (stamped at party spawn, before a
  beast exists), Cleansing Waters (per-turn, and a companion takes none) and Tank and Spank (the
  chip lands and pays nothing). **The reason is recorded beside each one in the source**, because
  "hero" alone is a decision the next author re-litigates. `check_dk` §1 pins both populations by
  their own read lines, so neither half can rot without saying so.

## STANDING RULE — A WIDENING IS DONE WHEN THE EFFECT ARRIVES, NOT WHEN THE COLLECTION WIDENS (Batch DK §1)
> **Widen the loop, then walk the chain to the number that moves, then measure it on a live body.**
> A widening that changes no measurement is not a smaller fix — it is **worse than the narrow
> word**, because a chip appears on the unit and it reads as working.

DK widened five candidates and **only four of them landed**. The fifth, `wd_tank_spank`, applies
`empower` to a companion perfectly cleanly: the status attaches, the chip renders, the tooltip
reads. **It pays exactly nothing.** A beast strikes through `_companion_hit`, which is its own
damage path and reads none of the hero strike loop's multiplier block — measured over 40 seeded
blows with the chip standing, **34392 damage against 34392, ratio 1.0000.** Its TEXT was corrected
instead.
· **THE THREE PLACES A WIDENING DIES, AND ONLY THE FIRST IS THE COLLECTION.** (1) the loop walks
  bare `heroes`; (2) a filter downstream removes it — this is the one CV §4 believed was the
  mechanism and it never was, since **all 23 `is_companion` filters walk `heroes` and remove
  nothing**; (3) **the READ SITE below simply never runs for that body.** The third is invisible to
  every source grep and to every check that asserts on a collection.
· **SO THE EVIDENCE IS A LIVE MEASUREMENT ON THE ACTUAL BODY, NOT A COLLECTION ASSERTION.**
  `check_dk` §2 summons a real bear and reads what each of the four pays it: Sanctuary heals it
  **1200 of a 10000 body**, Hold the Line leaves it at **20 Break from a 40-BD blow** against an
  unheld 40 and holds it at 1 HP through a lethal one, Rally turns a 1000 heal into **1300**, and
  the Field Medic's pool holds it once it is poisoned.
· **AND THE CONTROL IS NOT OPTIONAL, BECAUSE THE BUG WAS INVISIBLE.** Four effects paid four units
  instead of five for the life of the project and no log, no suite and no battery ever said so — so
  a check that passes on the fixed tree proves nothing. `check_dk` §2 empties `companions` for the
  length of one arm, which is exactly the pre-DK collection, and asserts the beast is untouched:
  **Sanctuary heals it 0, Hold the Line leaves it the full 40.**
· **PIN THE REASON YOU DID *NOT* WIDEN, AS A MEASUREMENT.** `check_dk` §4 re-measures Tank and
  Spank's 1.0000 on every battery run. A ruling of the form "we left this narrow BECAUSE widening
  would pay nothing" is a claim about a code path, and a claim about a code path rots — pinned this
  way, the day somebody gives `_companion_hit` an `empower` read the gate says the ruling is stale
  instead of staying quietly true.
· **A RECEIVE-SITE TAKES `_hero_side()`; A SITE ASKING WHO *DID* SOMETHING TAKES `heroes +
  companions`.** All four of DK's widenings ask who RECEIVES an effect, and a corpse receives
  nothing — so all four take the living, by the authored name rather than by a fifth hand-rolled
  copy of the predicate. **Harvest is the counter-case and must not be dragged along**: it asks who
  *opened* a wound, and a hero who has since fallen still opened it, so it spells its union out.
  Both are `heroes + companions`; only one filters `dead`.

## STANDING RULE — A CROSS-SPEC COUPLING IS NAMED IN THE CARD TEXT, AND IS A BONUS ON A CARD THAT ALREADY WORKS ALONE (Batch DH)
**A RUN FIELDS FOUR OF TWELVE SPECS, SO A CLAUSE THAT NEEDS A SPECIFIC PARTNER IS DEAD MOST OF THE
TIME.** Every one of the 120 draft abilities was authored inside its own spec, so for most of the
draft's life the pools never referenced each other and drafting was a decision about ONE HERO
rather than about the party. Two accidental exceptions proved the shape works — Fault Line hands
the Sharpshooter the Break that Breaking Darkness amplifies, and Downwind copies whatever debuff
an ally applied — and both are among the most interesting cards in their pools. DH made nine
deliberate. The two halves of the rule are not separable:
· **NAMED IN THE CARD TEXT.** If it is not visible on the draft card the player cannot draft FOR
  it, and **the draft screen is the only place the decision happens**. A quiet synergy is a
  coincidence, not a design. Naming it is sometimes the WHOLE change: DH's Breaking Darkness clause
  is text only — the card already amplified every source of Break, including allies', and had done
  since it shipped.
· **HUB AND SPOKE, NOT PAIRS.** The clause runs ONE WAY into a spec already built to be fed
  (the Survivalist's Trapper counts statuses from any source; the Pyromancer consumes Burn
  whoever lit it). **A two-way pair is two dead cards when either partner is absent.**
· **A BONUS ON TOP, NEVER A CONDITION.** No magnitude on the existing effect moves. A lone
  Pyromancer draws exactly what he always drew; a Holy beside a healthy party gains exactly the
  4 Mercy she always gained.
· **ANY STATUS A FEEDER APPLIES MUST BE IN `DEBUFF_IDS`** — the Survivalist's breadth term and
  the Swordmaster's Overwhelm both count that curated list and nothing else, so a status outside
  it applies, logs, reads as working and feeds them **nothing**. This is silent.
· **AND CHECK THE CLAUSE AGAINST WHAT IS ALREADY SHIPPED, NOT ONLY AGAINST THE TALENT TREES.**
  DH's brief asked for "Canis's strikes apply Bleed"; `Summon Canis` has read *"attacks with you
  for 20% of your Attack, building 20 Bleed"* for many batches. **A card's own text is part of
  the roster BR §1 tells you to sweep.** The gap was the OTHER TWO companions, and the clause
  moved to the card that sends any of them.

## STANDING RULE — SWEEP A NAME AGAINST THE WHOLE ROSTER BEFORE AUTHORING IT (Batch BR §1)
**Every ability, talent node, status and rune.** An ABILITY-vs-ABILITY duplicate is a real break —
`Classes.pool_ability` is keyed on `display_name`, so two abilities sharing one make the resolver
answer the wrong question — and must be RENAMED. Everything else is a LABEL collision: a node's
name is not an ability name, nothing resolves it, so it SHIPS AS SPECIFIED AND IS FLAGGED (the BO
Second Wind / BP Precision Strike / AV Shared Vigil precedent; renaming either is the designer's
call and one string).
· **RENAMED HERE: the Warrior recovery card was authored as SECOND WIND**, which Holy already holds
  as an ability (tranche 1, BO). It is **BATTLE TRANCE**.
· **REPORTED, NOT RESOLVED — RALLY** is also a Warden talent node (Banner row 2) and a live `rally`
  status label. The ability needs no status of its own, so nothing can overwrite anything.
· **REPORTED, NOT RESOLVED — IRON WILL is the worst collision the project has had.** It is a Warden
  talent node (Threat row 3) AND a live status with that exact label, and it is a WARRIOR class
  card — so **same class, same spec reachable**: a Warden holding the node can draft the card.
  Worse than BP's Precision Strike (same spec, but a node against a SPEC card). Nothing breaks, and
  **the ability's status is `ironclad` with its own chip** precisely so a Warden holding both never
  sees two chips reading the same word.
