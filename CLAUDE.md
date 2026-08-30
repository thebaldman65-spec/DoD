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

**DO NOT ADD A BATCH BLOCK TO THIS FILE.** If a batch learns something that binds future
work, add or amend a RULE here in the file's own voice — dateless, batch-agnostic, stated as
an instruction. Cite the batch that set it in parentheses for provenance, and stop there.
**Target: this file stays under 3% of the knowledge sync and roughly flat over time** — rules
accumulate far more slowly than batches do.

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
  `an` and `bk` both drift — `bk` generates real zone maps and then walks them, so its count is a
  function of the topology it rolled. **A count-diffing rule reads a drift as a regression**, so a
  suite known to drift must carry its band beside it. **The live counts and bands live in
  `baselines.json` — ONE machine-readable file, and the only one. `check_de` reads it; neither this
  file nor `docs/state.md` restates it, they point at it.**
  - **A BAND ALSO CARRIES THE NUMBER OF OBSERVATIONS BEHIND IT (STANDING, DE §1).** A band is a
    claim about a distribution nobody has characterised, and **the number of readings behind it is
    part of the claim.** `an`'s nine-observation band was exceeded on its TENTH reading, inside the
    batch that wrote it. **Widen where a reading demands it and nowhere else**, so every number in
    the table stays traceable to a run.
- **A FLAKY ASSERTION IS A THIRD KIND OF INSTABILITY AND IS NOT A DRIFT.** A suite whose COUNT is
  rock steady can still fail by chance when an assertion compares two damage rolls that can land
  on the same integer. **A bare `<` or `>` between two blows is not a check, it is a coin flip
  with good odds.** A suite that calls `seed()` zero times has a different stream every run, which
  is what makes the flake intermittent.
  - **AND A RATIO WITH A MARGIN IS NOT THE ANSWER ON ITS OWN — DD MEASURED THAT.** Both of `at`'s
    flaky checks WERE ratios with margins. The first line of the strike block is
    `randf_range(0.9, 1.1)`, so **one blow carries ±10% and a RATIO of two carries up to 22%**,
    against bands of ±20% and ±7%. **THE NOISE WAS THE WIDTH OF THE QUESTION**, and widening the
    band far enough to swallow it would have stopped the check telling apart the two answers it
    exists to separate.
  - **COMPUTE THE PROPAGATED NOISE BEFORE CHOOSING THE BAND (STANDING, DE §4).** **A margin
    only works if it is WIDER than the noise it sits on**, and **a ratio of two rolled quantities
    carries roughly twice the variance of either** — ±10% on each blow is ±22% on the ratio, not
    ±10%. **Do that arithmetic first, not after the flake.** If the propagated noise is wider than
    the band the question needs, **THE BAND IS NOT AVAILABLE**: seed the pair and assert exactly.
    **The recommendation to assert ratios with margins is incomplete without this and must not
    stand unqualified** — followed on its own it produced both of `at`'s flakes.
  - **SEED THE PAIR, NOT THE SUITE.** `seed()` the same value immediately before EACH blow of a
    compared pair, so both draw the same variance and the only thing left between them is what is
    under test (the AV/BS/BT idiom). **Where the check averages a LOOP of pairs, vary the seed per
    iteration** (`seed(base + i)`) or the averaging that makes its band meaningful collapses into
    the same measurement N times.
  - **`at` IS SEEDED AND PINNED AS OF DD (470 / 3 over five runs), AND IT WAS TWO CHECKS, NOT
    ONE** — seeding the recorded one exposed a second nobody had recorded. **`bo` REMAINS A KNOWN
    FLAKE** at roughly 1 in 13; its rate and its band live in `baselines.json`, and its FAILURE
    count is carried as a band, not a number.
  - **`test_rune_battle` IS A SECOND KNOWN FLAKE, FOUND BY `check_de` ON ITS FIRST ACCEPTANCE RUN
    (DE §7).** Its check count is rock steady at 97 and only the FAILURE moves — the pyromancer
    `rune_resist_pierce` check drives a LIVE battle and requires the proc to actually land, and the
    suite calls `seed()` zero times. **2 red in 15 readings, and BOTH reds landed under machine
    load** (during the acceptance battery and on the run immediately after it), against ten
    consecutive clean runs on an idle machine. **That the load matters is a HYPOTHESIS, not a
    finding** — the assertion's own comment says its snapshot "is the one that cannot race", so a
    race is the first thing to look at. Band `0–1`, rate in `baselines.json`.
  - **AND A KNOWN FLAKE IS A PLACE A SECOND RED CAN HIDE (STANDING, FOUND AT DE §6).** `bo` was
    recorded as `0–1 (the known flake)` in every document. **It is not.** Its floor of **1 is
    DETERMINISTIC and is not the flake**: §6 asserts `CLAUDE.md` contains the literal `TRANCHES 2
    AND 3`, which **CW's split removed** — so it belongs to CW's family alongside `bb`, `bn`, `bq`,
    `br` and `bx`. **The flake is a SECOND failure on top of it, which reads 2.** The band
    `0–1` happened to admit the observed value, so nothing ever contradicted the label, and **the
    project's standing failure total was under-stated by one suite and one failure.** It was **47
    across 20**, and 48 on a run where the flake fires. **WHEN A SUITE IS EXCUSED BY A KNOWN CAUSE,
    CHECK THAT THE RED IN FRONT OF YOU IS THAT CAUSE** — this is §3's own thesis, found by §3's
    instrument on its first run.
    (**CORRECTED AT DF: `ce` WAS NEVER IN CW's FAMILY** and was named in it here and in
    `docs/state.md` for two batches. `BATCH CE` is still in this file — a passing mention inside a
    surviving rule — so that check PASSES, and passes by accident. CW's family was eight
    assertions, not eleven: `bb` 2, `bn` 2, `bq` 1, `br` 2, `bx` 1.)
  - **A BAND WIDE ENOUGH TO COVER A GENUINE FAILURE CANNOT REPORT ONE (STANDING, SET AT DF §0).**
    This is the general rule underneath `bo`, and it is about what a band is FOR. **A band is for a
    count that legitimately varies — a suite that walks generated content, a draw that differs run
    to run. It is never a place to admit a red.** The moment a floor is set above zero to stop a
    known failure from shouting, the row has stopped being a measurement and become an excuse, and
    **the one thing it can no longer do is tell you the failure is still there** — nor that a
    second has arrived beneath it. **A FAILURE COUNT'S FLOOR AND A CHECK COUNT'S FLOOR ARE NOT THE
    SAME KIND OF NUMBER.** A check-count floor is the lowest value a healthy run produced. A
    FAILURE-count floor is a promise that exactly that many reds are known, named and deliberate —
    so it belongs in `baselines.json` **with the reason written beside it**, and a band around it
    is only ever a FLAKE's contribution, never a deterministic red's.
- **THE BATTERY'S COUNT GREP MUST MATCH EVERY SHAPE A SUITE PRINTS.** Three are in use:
  `checks: N   failures: N`, `BATCH XX: N passed, N FAILED`, and `N checks`. A count-diffing rule
  cannot see a regression in a suite whose count reads `?`, so a too-narrow grep is a blind spot
  that looks like coverage. This was found and fixed three separate times.
- **`check_parse` DOES NOT COVER THE TEST SUITES.** It walks `res://scripts` and `res://scenes`
  only, so a syntax error in a root-level `test_batch_*.gd` is invisible to it and surfaces only
  when the battery reaches that suite — up to forty minutes in. Load them directly when a suite
  has just been edited.
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
- **WHAT MUST STAY SELECTED:** `CLAUDE.md`, `docs/state.md`, `docs/changelog.html`,
  `docs/master.html`, `docs/design-notes.md`, `docs/text-standard.html`, `docs/reports/`, and the
  game scripts — `battle.gd`, `unit.gd`, `classes.gd`, `talents.gd`, `run_state.gd` and the
  screens.
- **THE TEST SUITES ARE AT THE REPO ROOT, NOT IN `scripts/`.** `scripts/` is game code and stays
  selected in full. **Deselecting "the scripts folder" would drop `battle.gd` and keep every
  suite — the exact inverse of the intent.** Check a path before acting on a size figure.
- **`scripts/battle.gd` IS THE LARGEST FILE IN THE PROJECT AND IS NOT A SYNC PROBLEM THAT CAN BE
  SOLVED**, because it is read constantly. **Recorded as a CODE-HEALTH observation: a file that
  size wants splitting eventually, and doing it deliberately is far cheaper than doing it when it
  becomes unworkable.**
- `addendum.html` is RETIRED (frozen history; do not update it) and lives in the archive folder,
  not in `docs/`.

## The skill check — FOUR CASES, AND THE BAR IS PARAMETERIC (STANDING, SET AT CM, CN AND CS)
`docs/master.html` §4.2 documents all four cases: the normal check, the gated check, the
defensive check, and **BATCH CS's SHARPSHOOTER SEQUENCE**. **They share ONE bar and ONE set of
zones — and as of BATCH CN those are a PROFILE rather than constants.**
- **THE DEFAULT PROFILE IS AUTHORITATIVE, NOT A FALLBACK.** `battle.SC_PROFILE_DEFAULT` holds
  `perfect_half` 0.045, `good_half` 0.16, `centre` 0.5, `sweep_time` 0.72, `presses` 1,
  `press_taper` 1.0 — today's numbers exactly — and **every caller uses it except the
  Sharpshooter's basic attack.** **A LATER BATCH THAT EDITS A VALUE THERE CHANGES EVERY CHECK IN
  THE GAME AT ONCE.** `check_cn.gd` asserts the six values AND THE FIELD COUNT, and asserts that
  the zone rects and the grade boundaries the profile produces are the ones the pre-CN formulas
  drew. **CS ADDED THE SIXTH FIELD AND check_cn CAUGHT IT ON THE FIRST RUN, WHICH IS THE GATE
  WORKING** — `press_taper` 1.0 is the NO-OP, so nothing else moved.
- **`centre` IS WIRED AND UNUSED; `presses` IS USED BY EXACTLY ONE ABILITY.** Nothing in the game
  moves the window off 0.5. **`presses` > 1 is the Sharpshooter's basic attack and nothing else
  (BATCH CS).** CN's worst-grade combine was a placeholder and **CS deleted it** — a sequence is
  now the SUM OF WHAT LANDED, and `_worse_grade` / `_GRADE_ORDER` are gone rather than left
  reachable. CN's comment saying "CO's Sharpshooter basic is the first" was wrong about the
  batch — CO was the recast refusal — and is corrected in place.
- **THE ZONE RECTS ARE RESIZED PER CAST** (`_apply_sc_profile`), not built once at UI setup.
  Grading and drawing come off the same dictionary on the same line of execution — split them and
  a profile that widens the window grades one thing and draws another, and **the player would be
  aiming at a lie.**
- **`up_sure` IS NOW WRITABLE AND WAS DELIBERATELY NOT WRITTEN AT CN.** The comment in
  `run_state.gd` explaining why it was refused (the window is not a parameter) **is out of date
  as of CN** on that count. Its second objection still stands and is the harder one: **the bot
  never runs the bar** — it rolls a grade off hardcoded probabilities — so a widened window is
  invisible to every instrument the project owns.

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
> **THE SHARPSHOOTER'S EXCEPTION IS SPENT AS OF CS, AND IT IS A FIXED OFFSET RATHER THAN A
> SLOPE: 15% less timing tolerance than everybody else's, THE SAME 15% AT ONE PRESS AND AT
> FOUR.** Harder than everyone else's, not harder the better you play. It is taken against
> `SC_PROFILE_DEFAULT` in `_sharpshooter_basic_profile` rather than written as a literal, so it
> survives a change to the default as an offset.

### WHERE THE CHECK COMES OFF (STANDING, SET AT BATCH CN §2)
**113 of the 211 drafted abilities now run no bar at all.** `Ability.runs_skill_check()` is the
ONE answer, asked by the cast path and by the draft card alike.
- **THE CRITERION IS MECHANICAL: remove the check wherever the grade multiplier has nothing to
  multiply.** No damage and no Break damage means ×1.15 and ×0.6 both resolve to nothing.
- **THE FIELDS ALONE ARE NOT THE CRITERION, AND THIS IS THE TRAP CN FOUND.** Half the corpus does
  its work inside a `special` handler, so `damage: 0, pressure: 0` is TRUE of **Feint, Guard
  Change, Kill Command, Savage Sweep, Precision Strike, Harvest, Primal Surge, Call the Wilds**
  and others that hit hard. `Ability.DAMAGE_SPECIALS` names the handlers that actually resolve
  damage or BD; **a field-only test would have stripped the bar off every one of them.**
- **ONLY THE BASE EFFECT COUNTS.** A handler whose only damage sits inside `if is_perfect` is
  caught — that branch is the orphaned bonus, not a reason to keep grading. **BEWITCH is the
  whole of that case**: its strike was Perfect-only, so it lost its bar.
  · **THE STRIKE IS REMOVED, NOT FOLDED (BATCH CR §2).** Losing the bar is still right — there
    is no base damage for a grade to multiply. Folding the strike in was the separate mistake:
    it handed the card a free extra ENEMY attack with no natural gate, acquired by accident.
    **THE CRITERION DECIDES WHETHER AN ABILITY GRADES; IT DOES NOT DECIDE WHAT AN ORPHANED BONUS
    BECOMES. Those are two questions and CN answered only the first.**
- **FOUR OVERRIDES.** **Heals keep their check** (`Ability.HEAL_SPECIALS`, an authored list
  because "is this a heal" is a question about the card — RENEWAL heals through a status, so
  nothing heals at cast time and a purely mechanical read would have taken its bar away while
  HEAL beside it kept one). **Shields lose theirs** whether or not the absorb scaled with the
  grade. **Pure debuff appliers lose theirs** — the grade has never affected whether a status
  lands. **Break damage counts as something to multiply**, so an ability with BD and no HP damage
  KEEPS its bar (Breaking Darkness at 20 BD is the case to check against).
- **A GATED ABILITY ALWAYS KEEPS ITS BAR, and this clause is CN's own addition.** CM's **Reckless
  Abandon** has no damage and no BD, so the criterion catches it cleanly — and obeying it there
  would have deleted a CM feature in silence. **An ability whose Sloppy loses the cast cannot
  lose the check that produces the Sloppy.**
- **BASIC ATTACKS RESOLVE AT A FIXED GOOD, EXCEPT THE SHARPSHOOTER'S.** Read off **slot 0** and
  off the **hero's passive** (`lethal_aim`), not off a name: his basic IS Quick Shot, the same
  object the Beastmaster and Mystic carry, so there is no card to flag. **CS made his the
  SEQUENCE and `_is_sharpshooter_basic` is the one answer to "is this it"**, asked by all three
  grade branches and by the payout so none of them can decide it differently.
- **THE NO-CHECK TEST SITS ABOVE THE AUTOPLAY ROLL AND THAT ORDER IS LOAD-BEARING.** Leave the
  bot's 20%-Perfect roll on top and it still rolls Perfects nobody can press for, **every folded
  bonus gets paid twice in a sim**, and the balance numbers stop describing the player's game.
- **EVERY ORPHANED PERFECT WAS FOLDED INTO THE BASE EFFECT, NOT DELETED** (105 abilities), and
  **`perfect_text`/`perfect_id` were cleared on all of them** — CK taught the draft card to render
  Perfect, so an orphan would advertise a bonus that can never fire. `check_cn.gd` gates it.
- **NOTHING IS CONSUMED UNTIL AFTER THE GRADE, AND BOTH CM FEATURES ARE BUILT ON THAT.** The
  Cancel button already returned to the action bar "with nothing spent" even after a target was
  chosen, so consumption has always happened downstream of the grade. **Neither feature has or
  needs a refund path.** A gated failure is the existing cancel path with the turn spent instead
  of returned. **That is what makes three of the five expressible at all**: Requiem eats Ruin off
  the *enemy*, Unleash eats the *companion's* Loyalty, Boil Over drops the Berserker's live
  Frenzy bonus — "refund the resource" is undefined for every one of them.
- **`_grade_skill_check()` TAKES NO ARGUMENTS AND MUST NOT LEARN WHICH ABILITY IT IS GRADING.**
  The caller knows; the flag is tested at the call site in `_hero_turn`. `_run_skill_check`'s one
  new argument, `mode`, names *what* is being graded ("" / "gated" / "defensive") and picks only
  the top line, the tint and which orientation card is owed.
- **STANDING RULE: NO HEALING OR REVIVAL ABILITY IS EVER GATED.** Resurrection is deliberately
  excluded and this is a rule, not a scoping choice — **losing a resurrection to a hand slip is
  the worst outcome the system could produce.** A later batch extending the gated set **must not
  reach for one**. `check_cm.gd` asserts it over the whole 211-ability corpus, not over the five.
- **STANDING RULE: THE DEFENSIVE CHECK CAN ONLY MITIGATE.** Perfect is ×0.85 damage and ×0.75
  Break; **Good and Sloppy are IDENTICAL and never worse.** `_defensive_brace` returns a
  *boolean* rather than a grade, so the absence of a third outcome is structural rather than a
  convention somebody has to remember. **A defensive check must never be able to make an incoming
  blow larger.**
- **The gated five are `Ability.gated`: Death Ray, Requiem, Reckless Abandon, Boil Over,
  Unleash.** The tell is `Classes.GATED_TELL`, ONE string on four surfaces (ability button,
  battle tooltip, draft card, the bar while it sweeps) and **never authored into a description**
  — CL §1's rule applied to a sentence.
- **`_has_defensive_check` IS THE ONE ANSWER TO "does this unit get a defensive bar"** (Warden
  always; Swordmaster only in the Defensive guard; Formless counts as both). **It reads
  `u.stance` DIRECTLY and deliberately NOT through `_stance_satisfies`** — that helper is for
  ABILITY gates, and Feigned Guard's scope is abilities and nothing else, so a Feigned Guard does
  not conjure a defensive check any more than it moves Bracing or Untouchable.
- **TWO NARROWINGS OF "every qualifying incoming attack", both reported at CM:** a **counter**
  raises no bar (a free swing drawn by the hero's own action; the offensive bar does not run for
  one either), and an attack carrying a **`special`** raises none (it never reaches the ordinary
  strike loop, which is the only place the mitigation is applied). **Exactly one enemy attack is
  skipped by the second clause today — the Bloodcaller's Blood Tribute.** The Hurler's Siege
  Stone is NOT skipped: its `windup` deals nothing, and the landing returns a turn later as a
  plain attack copy.
- **PACING IS THE KNOWN RISK AND THE NUMBER EXISTS NOW: 6.9–9.4 defensive checks a battle with a
  Warden in the party, against 22.8–27.3 hero actions.** The party's presses rise about a third;
  **the WARDEN's own roughly double** (he acts ~7 times and braces 7–9). **Uncapped on purpose
  for the first pass** — a cap is a retreat available afterwards, and it is a designer's call.

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
brief — `wd_hold_line` (the undying window, 1/2→2/3). The Tempo chip's legend said "one turn" and
moved with them. **The one place the old reading was written down as a rule was
`battle.gd`'s `hold_the_line` comment**; it now records the ruling instead.

## HERO AND ALLY ARE THE ONLY TWO WORDS (STANDING, SET AT BATCH CV §4, CLOSED AT DM §3)
> **HERO — one of the four. ALLY — heroes and companions together. AND THERE IS NO THIRD WORD.**

**CORRECTED AT DJ §1 — THE BEAST DOES NOT STAND IN `heroes`.** This block said it did, and so did
DH's Harvest comment; `heroes.append` is reached at exactly one site (the party spawn) and a
summoned beast goes to `companions`. **The exclusion CV measured is real, but the mechanism is the
COLLECTION, not the filter**: all **23** `heroes` walks carrying an explicit `not h.is_companion`
are filtering an array that can never hold one, so the filter removes nothing. It is still worth
reading as INTENT — an author who wrote it meant to exclude — but it is not the thing doing the
excluding, and **a walk with no such filter is not thereby including companions.**

A Beastmaster's beast is visibly on the player's side and gets none of what "ally" promises.
**Twenty-eight node texts promised "every ally" or "the whole party" and paid only the four**; all twenty-eight now say *hero*. **CV's brief said
sixteen — the mechanical sweep of all 41 ally/party-worded nodes found twenty-eight**, and the
three extra populations are why: **23** carry an explicit `is_companion` filter in
`battle.gd` (which, per DJ §1 above, records intent rather than doing the excluding), **2 more** (`hl_guardian`, `hl_resurrection`) by `unit.gd:1320`'s
`is_hero and not is_companion` gate on `below_half_cb` — a Mercy generator, not a filter — and
**3 more** (`dv_apostle`, `dv_fervor`, `dv_oath`) because `_gain_faith` refuses companions
outright, so a beast can never hold the stack the node is written around.

**THE EXCLUSION ITSELF IS INTENDED AND NO READ SITE MOVED.** Under The Pack a party-wide buff
would otherwise reach six units.

**FOUR TEXTS MOVED THE OTHER WAY, AND CV'S STATED TEST FOR MOVING THEM WAS WRONG.**
`wd_rally`, `wd_hold_line`, `dv_devoutness` and `dv_waters` said "party" and were moved to *ally*
because **"their read sites genuinely include companions"**. **NONE OF THE FOUR DID** — DJ §2
re-derived every one. **THAT SENTENCE IS THE THING TO DELETE FROM YOUR HEAD**, because it is the
test a future author would apply and it was never run: three of the four walked bare `heroes`, and
`dv_waters` runs per-TURN on a unit that takes none. **DK RULED ON ALL FOUR AND THEY SPLIT
TWO AND TWO** — `wd_rally` and `wd_hold_line` had their CODE corrected and are *ally* truthfully
now; `dv_devoutness` and `dv_waters` had their TEXT corrected to *hero*. **All four land correctly
for the first time, and by a different route than CV recorded.** Precision runs both directions or
the two words are decoration.

**THE TEST IS NOT "DOES THE COLLECTION REACH ONE". IT IS "DOES THE EFFECT ARRIVE".** DK found the
third failure mode with `wd_tank_spank`: the collection can be widened, the status applies
cleanly, and the beast is still paid nothing, because the READ SITE downstream never runs for it.
**Walk the chain from the loop to the number that moves, and measure it on a live beast.** A
widening that changes no measurement is a widening that did not land — and it is worse than the
narrow word, because a chip appears and it reads as working.

**`wd_tank_spank` WAS CITED HERE AS THE PROOF THE DISTINCTION IS WORTH HAVING, DJ §2 FOUND IT WAS
THE OPPOSITE, AND DK REPAIRED IT — AS THE TEXT, NOT THE CODE.** It said "ally" and walked bare
`heroes`. **It now says HERO, and the reason is the one worth carrying**: widening it would have
been a NO-OP. `empower` applies to a companion perfectly well and pays it nothing, because a beast
strikes through `_companion_hit` — its own damage path, which reads none of the hero strike loop's
multiplier block. **Measured at DK over 40 seeded blows with the chip standing: 34392 damage
against 34392, a ratio of exactly 1.0000.** `check_dk` §4 measures that ratio on every run, so the
day somebody gives `_companion_hit` an `empower` read, the gate says this ruling is stale instead
of staying quietly true.

**A RULE WHOSE WORKED EXAMPLE WAS WRONG NEEDS ITS EXAMPLE REPAIRED AS LOUDLY AS THE RULE.** The
distinction IS worth having — it is just that this was never the proof of it. **The proof is now
`wd_hold_line`**: it says "ally", it reads `_hero_side()`, and a summoned bear measurably banks 20
Break from a 40-BD blow against an unheld 40.

**WHEN WRITING A NEW NODE, THE TEST IS THE READ SITE'S COLLECTION *AND THEN THE CHAIN BELOW IT*,
NOT ITS FILTER AND NOT THE SENTENCE'S RHYTHM.** `_hero_side()` includes companions (living ones
only); `heroes + companions` includes them dead or alive; **a walk over bare `heroes` never does,
filter or no filter**;
`_gain_faith` refuses them outright, so nothing Faith-flavoured can ever say "ally"; and a
per-TURN effect can never reach one either, because `_next_unit()` walks `heroes + enemies` and a
companion takes no turns.

## STANDING RULE — "PARTY" IS RETIRED FROM PLAYER-FACING TEXT (Batch DL §2)
> **The word "party" must not appear in any player-facing string. Every use becomes *hero* or
> *ally*, decided by its READ SITE — and where the group is the ENEMY side, *warband*.**

**IT READS AS EITHER, AND THAT IS NOT A STYLE COMPLAINT.** Rallying Shout's Pressure clause said
*"the whole party sheds 30 Pressure"* and paid four for the life of the project. **DJ §2 swept
every ally-worded text and DK §2 ruled on eleven of them, and NEITHER SWEEP COULD SEE IT**, because
both were sweeping for the word *ally* and this clause carried neither of the two words. **A word
that means either is a word no sweep can check.**

- **THE READ SITE'S COLLECTION IS THE TEST, not the sentence's rhythm.** `_hero_side()` includes
  companions, so an effect reaching through it says *ally*. **A walk over bare `heroes` says
  *hero*, with or without an `is_companion` clause** — all 23 of those filter an array that never
  holds one.
- **THREE FURTHER EXCLUSIONS MEAN *hero* HOWEVER THE COLLECTION IS SPELLED:** an effect stamped
  once where the four are built (no companion exists yet); a per-turn effect (`_next_unit()` walks
  `heroes + enemies`, so a companion never takes a turn); and anything Faith-flavoured
  (`_gain_faith` refuses companions outright).
- **A CLAUSE WHOSE PAYLOAD A COMPANION STRUCTURALLY CANNOT RECEIVE SAYS *hero*, AND THE REASON IS
  RECORDED BESIDE IT** — "no resource bar", "reads no Empower via `_companion_hit`". A word without
  its reason gets re-litigated.
- **THE SURVIVING USES ARE IDENTIFIERS AND ARE NAMED**: `party_mark` (a status id), the `party`
  event target, `spec_in_party` (an event condition), and `party.tscn`. Nothing else.
- **PROSE ABOUT THE GAME IS NOT PLAYER-FACING.** This file, `docs/changelog.html`,
  `docs/design-notes.md` and the batch reports are exempt. **History is not swept.**
- **THE RULE IS KEPT BY A CHECK, IN THE PLACE THE LAST ONE WENT.** `test_batch_bx` §4 already
  forbids "beast" in player-facing prose and caught seven uses in DK before the battery; DL §2 adds
  the same sweep for "party", over the same file set. **It was shown to bite before it was
  trusted** — a "party" planted in a live description reds it.

## STANDING RULE — THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE, NOT THE ABILITY (Batch DL §1)
> **Read a card clause by clause. Two clauses under one word can have two different answers, and
> the one that carries neither word is the one no sweep will find.**

**RALLYING SHOUT IS THE WORKED EXAMPLE AND IT COST TWO SWEEPS.** One card, one sentence, two
clauses: *"the whole party sheds 30 Pressure, and every other ally regains 30% of their
resource."* The resource half is a hero's — a companion has no bar. **The Pressure half is an
ally's — a companion HAS a Break meter**, on the very axis DK had already widened Hold the Line
along. DJ §2 and DK §2 both looked at the ABILITY, found the ally-worded half, ruled on it, and
left the other half standing.
- **THE CARD NOW CARRIES BOTH WORDS IN ONE SENTENCE**, and the source carries the reason for each
  beside its own loop. **The two clauses are two loops** — the Pressure walk and the resource walk
  are separate, so each site's collection is visible where it is read rather than being a filter
  hung off a shared one.
- **MEASURED, NOT ASSERTED (the DK §1 rule applied):** on a live summoned Ursus, the beast shed
  **0** Pressure before and **30** after, against a hero's 30 either way. `check_dl` §2 re-measures
  it every run, with the union broken as its control.
- **`resource_name == ""` IS THE RULING AT THE RESOURCE SITE, NOT DECORATION ON IT.** DK recorded
  the reason as *"a companion is built with no `resource_name` and `max_resource` 0"*. **The second
  half was false** — `max_resource` is `unit.gd`'s default **100** on a companion, never overridden
  at the summon. Rallying Shout's resource loop was the one of the three that carried no guard, so
  a careless widening of it would have paid a beast 30 points of a bar that does not exist. **The
  guard is what makes the recorded reason true at the site.**

## THE ALLY/HERO THREAD IS CLOSED (Batch DM §3) — RULE ON CLAUSES, NOT ON ABILITIES
> **A card can carry two clauses of different shape under one word, and a sweep that reads the
> ability will not see it. "Party" is retired; HERO means the four, ALLY means heroes and
> companions, and every *hero* ruling carries the structural reason a companion cannot receive it.**

**NINE BATCHES: CV, DH, DI, DJ, DK, DL AND DM, WITH DF AND DG'S SORTS UNDER THEM.** Each one found
the next thing, and the reason it took nine is in the shape of the question rather than in any
batch's care: **CV swept for a claim about read sites and never ran the test; DJ swept ABILITIES;
DK ruled on ABILITIES; DL found that the unit is the CLAUSE.** DM read the last six cards clause by
clause and the thread ends there.

- **THE SIX ARE SIXTEEN CLAUSES; FOURTEEN CARRY A COLLECTION AND ALL FOURTEEN WERE ALREADY
  RIGHT.** Bulwark of Fortitude 4, Consecrated Ground 3, Divine Wrath 2, Battle Shout 1 group +
  1 self, Hold the Line 2 group + 1 self, Sacred Resolve 2. Every one of the fourteen says what
  its read site walks. **A batch that finds nothing to widen has still measured something**, and
  this is the measurement that lets the thread close instead of being abandoned.
- **WHAT WAS WRONG WAS A THIRD SCOPE, AND IT HAS NO WORD HERE. A CLAUSE CAN BE NARROWER THAN
  EITHER.** Battle Shout and Hold the Line each hand **five Rage to the CASTER** — one body.
  Battle Shout's card put it inside *"A roar every hero answers:"*, so a group clause's colon-list
  promised four heroes a payload that reaches one. **Hold the Line already worded the identical
  payload correctly** (`Refunds 5 Rage.` as its own sentence) — **so the fix was to copy the sibling
  card, not to invent a phrasing.** `check_co` and `check_cy` had both recorded it as "hands the
  caster +5 Rage" since CO; **the card was the only surface that disagreed.**
- **A WORD WITHOUT ITS REASON GETS RE-LITIGATED, SO ALL FIFTEEN CARRY ONE.** There are **five**
  reasons and no sixth: no resource bar to refuel; `_companion_hit` reads none of the hero strike
  loop's multiplier block; stamped once at party spawn before a companion exists; **per-turn** —
  `_next_unit()` walks `heroes + enemies` and a summon carries `next_time = INF`; and `_gain_faith`
  refuses companions outright. **Two of the six are narrow by CHOICE and say so** rather than
  implying an impossibility — Bulwark's Break immunity, armor and cast heal and Consecrated
  Ground's mitigation and reflect are all plainly receivable, and widening them is a magnitude
  change on beast survivability, which is DK's "new PLAY, not a widening".
- **BULWARK IS THE SHARPEST OF THE SIX: WIDENING ITS LOOP WOULD SHIP THREE QUARTERS OF A CARD.**
  Three of its four clauses would arrive and the fourth — the 10%-a-turn regen, the sustain the
  card is named for — never can. **A partial arrival reads as working**, which is the Tank and
  Spank failure in a new shape.
- **AND THE SURFACES NOBODY SWEEPS ARE STILL DOCUMENTS.** DL corrected Consecrated Ground's Faith
  clause on the CARD and left **three copies in `master.html` and one in the glossary** still
  saying *ally* for a clause `_gain_faith` refuses outright — the DA/DC/DG shape exactly, one
  surface fixed and the rest carried. **When a clause moves, sweep the CLAUSE across every surface,
  not the card across one.**

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

**THE SHAPES THE ERRORS TAKE, so they can be recognised early:**
- **A NAMED PRECEDENT THAT DOES NOT EXIST.** "Follow the rune equip-slot ladder — it grows 2→3→4
  by zone and announces each new slot": that ladder was DELETED batches earlier and the function
  has returned a flat 3 ever since. There was nothing to copy.
- **A LAYOUT CLAIM THAT WAS NEVER MEASURED.** "Six buttons fit the existing row" — at the shipped
  pitch, button six spanned x=1270–1452 on a 1280-wide viewport. **Measure it; do not eyeball it.**
- **A NAME THAT COLLIDES WITH A LIVE ONE.** A requested status id already existed under a
  near-identical name. **Sweep the roster before authoring.**
- **TWO MECHANISMS DESCRIBED AS ONE.** "Exactly as the Bomb and Defense Potion already do" — the
  Bomb is refused by `_usable_on_map` (the button never lights); the Defense Potion's button is
  ENABLED and toasts a refusal after the press. **Pick one and say which.**
- **A COUNT THAT IS LOW.** Re-derived counts have come back LARGER three times (four→five,
  16→28, 37→220). **A NAMED LIST CANNOT AUDIT ITSELF — the list is the thing under suspicion.**
  Run the sweep over the whole population, not over the names the brief supplies.
- **A CLAIM ABOUT A PRIOR BATCH'S OUTCOME.** One brief stated a previous batch "left them red"
  when the battery had been green since. **Check the repo, not the brief's memory of it.**

**REPORT EVERY DISCREPANCY IN THE BATCH REPORT, INCLUDING THE ONES THAT MADE NO DIFFERENCE.**
The brief is the shared record; leaving an error in it means the next brief inherits it.

## THE SHARPSHOOTER'S BASIC IS A SEQUENCE (STANDING, SET AT BATCH CS)
**His BASIC ATTACK ONLY. No other ability of his changes, and no other hero's bar moves at all.**
`_is_sharpshooter_basic` is the single answer to "is this it" — read off the hero's passive
(`lethal_aim`) and off **slot 0**, never off a name, because his basic IS Quick Shot and the
Beastmaster and Survivalist carry the same object.
- **ONE PRESS, PLUS ONE PER 50 FOCUS HELD, CAPPED AT FOUR.** 0–49 → 1, 50–99 → 2, 100–149 → 3,
  150+ → 4. Read **at the moment the bar opens**, from Focus held at that instant.
- **THE CAP IS THE POINT AND IT IS NOT A ROUNDING CHOICE. DO NOT RAISE IT.** Focus has no ceiling
  (`FOCUS_UNCAPPED`), so an uncapped rule makes 400 Focus a NINE-press sequence with a tightening
  window **on the action he presses most** — an ability a player without the reflexes cannot use.
  That is the failure that sank timed hits in Legend of Dragoon and Mother 3. `check_cs.gd`
  asserts the cap, and the reason sits beside `SS_SEQ_MAX_PRESSES` in `battle.gd`.
- **PARTIAL CREDIT: every landed press counts, a miss ENDS the sequence and keeps what came
  before.** "Landed" is **Good or better**. A four-press attempt missing on the second is worth
  ONE press. **This REPLACED CN's worst-grade combine rather than joining it — `_worse_grade` and
  `_GRADE_ORDER` are deleted, so both behaviours are not left reachable.**
- **IT PAYS IN FOCUS, NOT DAMAGE.** `SS_SEQ_FOCUS_PER_PRESS` (8) a landed press, plus
  `SS_SEQ_FULL_BONUS` (20) for a full sequence. **Damage resolves off the FIRST press's grade**
  and presses two through four add none — a deep-Focus Sharpshooter **ramps faster, he does not
  hit harder per swing**, because Focus already converts to crit chance and then crit multiplier.
- **THE PAYOUT IS AFTER `_resolve`, NOT BEFORE IT.** `_sharpshooter_focus` runs inside `_resolve`
  and **dumps the meter to zero on a target switch**; paying first would delete the points the
  same shot just earned. `_gain_focus` is the only way in, so Spray of Arrows' ceiling, the
  conversion signature and the deepest-Focus ledger all see it as they see the engine's.
- **THE WINDOW TIGHTENS 15% A PRESS, AND THE OPENING WINDOW WIDENS WITH THE COUNT** (1.00 / 1.31 /
  1.57 / 1.86) so the whole sequence stays about as achievable at four presses as at one.
  **ONLY THE GOOD WINDOW WIDENS. THE PERFECT WINDOW IS DELIBERATELY HELD FIXED** — the first
  press's Perfect sets the damage, so widening it with the count would let depth buy damage
  directly, which is the thing "ramp faster, not hit harder" exists to prevent.
- **THE §4 NUMBERS COME FROM A STATED MODEL, NOT FROM PLAY DATA, AND NOTHING IN THIS REPO CAN
  MEASURE THEM.** The bot never runs the bar, so a widened window is invisible to every instrument
  the project owns. The model: difficulty is **time inside the window**; the player's timing error
  is Gaussian with **SD ≈ 60 ms**; a press's risk is that tail and a sequence's risk is the sum of
  its presses'. Under it the sequence lands **89.7 / 90.0 / 90.0 / 90.0%** at 1–4 presses.
  `check_cs.gd` re-derives the table from the constants so a hand-edited row cannot pass silently
  — **but the 60 ms is a guess about human reflexes and the gate cannot check it.**
- **THE PAYOUT CONSTANTS ARE PINNED IN `check_cs.gd`, AND THE REASON IS A GAP THAT GATE HAD.**
  Every payout assertion is written as `landed * SS_SEQ_FOCUS_PER_PRESS`, so a negative control
  that moved 8 to 9 **passed clean**. The changelog, master.html §4.2 and the glossary all quote
  the figure; pinning it means moving it is one line here and four in the docs, together.
- **THE TELL IS KEYED ON THE PRESS COUNT, NOT ON A NEW `mode`.** At 0–49 Focus his basic IS a
  one-press check and reads as the ordinary bar. Above that the bar says "SHOT n OF N" before the
  first press and on every one, and an early end reads as **"CHAIN BROKEN 2 / 4 — Good"** rather
  than vanishing, because a sequence that just stops reads as dropped input.
- **THE BOT ROLLS PER PRESS AND STOPS AT THE FIRST FAILURE.** At one press it is byte-for-byte the
  line it always was — one `randf()`, the same thresholds — so no other hero's grade moves.
- **`check_cs.gd` IS A LIVE GATE (104 checks) BECAUSE IT HAS TO BE.** The bot cannot press a bar,
  so nothing else in the battery reaches partial credit, the taper or the tell. It spawns a real
  battle, drives the bar by hand at every press count, and resolves the basic for real at each.
- **OPEN, REPORTED AT CS AND NOT ACTED ON: the gold Perfect zone is drawn on presses 2–4 and buys
  nothing there.** "Landed" is Good or better and the damage is on the first press, so a Perfect
  on a later press is worth exactly a Good. It is still drawn and still graded — one code path,
  no special case. **Hiding it after the first press is the obvious fix and would also make "the
  first press sets the damage" visible without text**, but that is a design change and the
  designer's call.
- **THREE THINGS THE BRIEF DID NOT ACCOUNT FOR ARE REPORTED IN THE CHANGELOG §7.** The largest:
  the brief called the full-sequence reward "the Perfect bonus, +20 Focus", but **Quick Shot's
  Perfect bonus is +10 Mana** (`perfect_id: "mana"`) and the +20 Focus (`focus20`) belongs to
  **Aimed Shot**. Quick Shot is a protected core the Beastmaster and Survivalist also carry, so
  the +20 shipped as a NAMED full-sequence bonus and Quick Shot's own Perfect is untouched.

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

`test_batch_cd` §1 spawned forty-five child Godots from inside a suite the battery was itself
running. DD widened its table from five suites to forty-five and **the battery went from 29.6
minutes to about 50.** That was a design error in the brief, not in the implementation.

- **ASK WHAT THE SUITE DOES THAT THE RUNNER CANNOT, AND ACCEPT "NOTHING" AS AN ANSWER.** For the
  differ half it was nothing: `run_battery.sh` already spawns every target, already captures every
  stream INCLUDING STDERR (`>"$log" 2>&1`), already greps the same three count shapes and already
  counts the same two throw markers. **The only thing it did not do was COMPARE.**
- **THE DIFFER IS `check_de.gd`, A POST-PASS THAT READS THE LOGS THE RUNNER WROTE AND SPAWNS
  NOTHING.** It runs once, last of all, so it covers the gates, the harness and the scene runs too
  — none of which the old table held. **Reading a file cannot nest, so the nesting is structurally
  impossible now rather than merely avoided**, and the table may hold `test_batch_cd` itself, which
  the old design could never watch (a suite that drives itself does not terminate).
- **IT IS RE-RUNNABLE IN SECONDS.** Re-checking the old differ's answer cost 22 minutes because it
  re-ran the tree. Over a log directory that already exists the answer is instant, and it cannot
  drift, because the evidence is fixed.
- **WRITTEN IN GDSCRIPT, NOT IN SHELL.** Bash string handling is how the battery's count grep came
  to be too narrow three times, and how a message spelling a throw marker out in full would make
  the battery accuse the differ of throwing. **The count-differ has been mis-instrumented twice; it
  is not a place to be clever.**
- **A FALL AND A RISE ARE NOT THE SAME EVENT, AND THE POLARITY INVERTS BETWEEN THE TWO HALVES.**
  - A **FALLING CHECK COUNT** is this project's signature failure — `bb` 172→168, `bo` 505→495,
    harness gate 2 at CA, and the seven `SCRIPT ERROR`s that hid 2,714 assertions. **ERROR.** A
    **RISING** one is usually a suite's own loop walking new content. **NOTICE.** So **the FLOOR of
    a band is asserted and the ceiling is not** — the same asymmetry `an`'s band rule already had.
  - A **RISING FAILURE COUNT** is the 48th failure among 47. **ERROR.** A **FALLING** one means
    something was repaired. **NOTICE.**
- **BASELINE THE FAILURE COUNT PER SUITE — IT IS WORTH MORE THAN THE CHECK COUNT (DE §3).** With 47
  known failures across 20 suites **a 48th is invisible**. `test_batch_bi` was right and the game
  was wrong **for four batches**, and it hid because that suite was already red for an unrelated
  reason. **A red check does not announce a second problem underneath it.** A suite going from 6
  red to 7 is now reported exactly as loudly as one going from 0 to 1.
- **A NOTICE IS NOT SILENCE. A BASELINE MOVES ONLY IN THE BATCH THAT CAUSES THE MOVEMENT, AND THE
  CHANGELOG SAYS WHY.** Otherwise the table drifts into whatever the code happens to do, which is
  CQ §3's failure arriving in a new place.
- **THE RUNNER WRITES A MANIFEST (`$OUT/.ran`) AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does not clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log — **the one fault a count-differ must never
  commit.** A log named in the manifest is always this run's, because `run_one` truncates it at
  spawn. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and **the differ
  says so instead of reporting a clean tree.**

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
in a gate.** It walks the kits, the class pools and the spec pools (the Batch CL enumeration) and
then walks `Classes.talent_granted_names()` through **`Talents.granted_ability`**, the one resolver
both grant shapes go through. **The corpus is 216; the CL walk alone reaches 211.**
- **DO NOT WRITE A SECOND COPY OF IT IN A GATE.** Five gates each held their own — `check_cm`,
  `check_cn`, `check_co`, `check_cy` and **`check_cl_width`, the original the other four copied** —
  and the first three plus the original all carried the same hole for as long as they existed:
  **a talent node that GRANTS an ability which is in no pool was invisible to every one of them.**
  The five it missed are **Backdraft, Pyroblast, Glacial Prison, Cryoclasm and Intercession**.
- **IT LIVES ON THE GAME'S DATA RATHER THAN ON THE TEST**, because a gate that owns the answer is a
  second authority the game itself never consults. `Classes.pool_ability` already falls through to
  `Talents.granted_ability`, so this is a dependency the file had, used a second time.
- **`check_cz.gd` KEEPS THE OLD CL WALK AS A NEGATIVE CONTROL.** Its whole job is to still be
  missing the five; if it ever stops being, the gap closed itself and every report about it is
  stale.
- **CN's CRITERION OWES NOTHING** — re-run over the five it answers all of them correctly, and only
  its printed population was ever short. **CO's ONE RULING WAS TAKEN AT DA §1: GLACIAL PRISON IS
  GATED**, and it is the first talent-grant in `RECAST_GATED`. **That is what the enumeration hole
  actually cost** — the criterion could not be applied to an ability no walk in the project could
  see, so the defect was invisible rather than merely unfixed.

## A HELPER COPIED BETWEEN GATES INHERITS ITS BUGS AND DIVERGES SILENTLY (STANDING, SET AT DA §3, THE GATES CONSOLIDATED AT DB §1)
> **Enumerate the ability corpus through `Classes.ability_corpus()`. Never copy another gate's
> walk.** A talent can grant an ability that lives in no pool, and a hand-rolled walk misses five.
> **A helper copied between gates inherits its bugs silently and diverges from its origin without
> anything reporting it.**

**THIS IS A DIFFERENT FAILURE FROM EVERY OTHER TRAP IN THIS FILE AND IT IS THE FIRST CONFIRMED CASE
IN THE PROJECT.** The rest are DRIFT: one authority, edited, and a second copy left behind. This is
**PROPAGATION BY COPY** — five gates were wrong in five places from birth, because four of them
copied `check_cl_width`'s walk rather than deriving one. **Fixing the origin leaves four.** Drift
gives you one stale copy and a chance that a diff notices; a copied helper gives you N, all born
wrong, none of them diffed against anything.

- **THE TELL IS A HELPER WITH THE SAME NAME IN THREE OR MORE GATES.** Ask whether the answer belongs
  to the GAME's data rather than to the test — `ability_corpus` did, which is why it lives on
  `Classes` and not in a gate.
- **CZ's `_cl_only_corpus` IS THE ONE ALLOWED COPY** and it is allowed because being a copy is its
  job: it is the negative control that proves the old walk still misses the five. **`check_da`
  names it as the exemption, so a later reader cannot "consolidate" it into uselessness.**
- **DONE AT BATCH DB: `_spawn` IS AUTHORED ONCE, IN `gate_fixture.gd`, AND ALL SEVEN GATES GO
  THROUGH IT.** The fixture carries the tally too (`ok` / `report`). **`check_da` §3 no longer
  COUNTS the copies — it ASSERTS there are none**: a gate that authors its own `_spawn`, or that
  instantiates the battle scene by hand, fails it by name. Both marks are joined at runtime so the
  gate does not accuse itself.
- **THE THREE DIFFERENCES THAT WERE REAL ARE NAMED ARGUMENTS NOW**, not invisible edits inside a
  copy: `deterministic` (the AK/AL/AR damage forcing — `check_cm_live`, `check_cs`), `items`
  (`check_ct`'s held empty slot) and `run` (a gate that already holds the node).
- **AND THE ONE THAT WAS NOT REAL WAS RULED DEAD.** Five copies hand-set `skill_check_taught` and
  `defensive_check_taught`; two did not. **The flags are unreachable in a gate** —
  `_nobody_can_press()` is `sim or autoplay or headless`, so the read site is never entered and the
  brace always takes the bot branch. **Their only live effect was `Profile._save()` writing the
  player's `user://profile.json` on every gate run.** They are gone from all five. **DA's own
  write-up of this said "two others"; it was five** — the census counted bodies correctly and
  described them from memory.
- **WHAT DB LEARNED BUILDING IT, AND IT IS A TRAP: A BASE CLASS IS THE RIGHT SHAPE AND IT DOES NOT
  COMPILE.** `extends GateBase` (or `extends "res://gate_base.gd"`) on a `--script` SceneTree
  target fails with `Could not find base class` **and exits 0 having run nothing**. The fixture is
  a `preload`ed `RefCounted` for that reason, and it carries **no `class_name`** — that registration
  lives in the gitignored `.godot/global_script_class_cache.cfg`, so it would resolve here and fail
  on a fresh clone.
- **DONE AT BATCH DD, AND IT WAS TEN TIMES DB's: `_spawn` IS AUTHORED ONCE FOR THE SUITES TOO**, in
  `suite_fixture.gd`, and `_kill` with it. **1,128 lines deleted against 391 added across the 37
  suites, and not one of the 389 call sites moved** — a suite keeps its OWN `_spawn` signature and delegates, because
  **thirty-seven signatures are not one signature** (`learned`, `granted`, `member_patch`, `prep`,
  `learner`, `mod_id`, `cleric_spec`, `earned`, `runes`, `frames` between them). **`check_da` §3
  asserts the suites now as well as the gates**: a suite carrying a `_spawn` that does not reach the
  fixture fails by name, and the ten hand-built boards that remain — in `al`, `an`, `ax`, `bl`,
  `test_rune_battle` and `test_run_harness`, none of them a copied helper — are a **named ratchet**
  rather than a wildcard.
- **AND THE CENSUS NUMBER EVERY DOCUMENT CARRIED WAS WRONG IN BOTH DIRECTIONS.** "34 distinct
  bodies" reproduces neither way it can be measured: **36 raw, 33 once comments and blank lines are
  stripped** (four pairs are twins — bh/bi, bo/bp, bq/br, bt/cb). **`_kill` "byte-identical in 14"
  is true only after normalising** — four raw bodies, and every difference between them was the
  wording of one comment. **DERIVE A CENSUS BEFORE QUOTING IT**; this one travelled from DA through
  DB, this file, `state.md` and DD's own brief unchecked.
- **`_run` IS 39 BODIES IN 39 SUITES AND IS NOT THE SAME PROBLEM.** It is each suite's own driver.
  **The copied helper is hiding INSIDE it: 38 of the 39 open with the same save-backup preamble and
  37 swap `Profile.save_path` to a per-suite file and back.** That is the next duplication of this
  shape and it is owed, not taken.
- **AND THE RULE'S ENFORCEMENT HAD A BLIND SPOT (Batch DV §5), WHICH IS CLOSED AT DW §1 — AND THE
  DIAGNOSIS WAS ONE HOLE SHORT.** DV found `test_batch_cp._corpus()` hand-rolling the walk while
  `check_da` §3 read 37/0, and named two reasons: the walk sweep read **`check_*.gd` ONLY**, and the
  fingerprint matched the two pool **ACCESSORS** where that walk read the **CONSTANTS**. Both held.
  **THE THIRD WAS BIGGER THAN EITHER AND NO POPULATION AXIS WOULD HAVE FOUND IT: the fingerprint
  assumed a corpus walk touches the DRAFT pools at all.** `check_cl_resolver._every_ability()` is a
  walk **in a gate** — inside the swept population, read on every battery run since DA — and it
  reads only `Classes.kit()` and `Classes.spec_abilities()`. **It reached 43 of 227.**
  **THREE WALKS, NOT ONE, AND THE TWO DV HAD NOT FOUND WERE THE TWO THAT REACHED LESS: 43, 91
  (`test_batch_bh._all_ability_names`, which reads NEITHER draft pool) and 207.** All three are
  delegations now.
- **THE WIDENED RULE ASKS WHAT A WALK IS RATHER THAN WHICH CALLS IT MAKES (Batch DW §1).** *A
  function that RETURNS a collection built out of two or more of the game's seven ability-source
  families is answering "what abilities exist?", and `Classes.ability_corpus()` is the one
  authorised answer.* **THE RETURN IS THE DISCRIMINATOR AND IT IS DOING REAL WORK**: a body that
  reads a pool and ASSERTS on it returns void and is not a walk. A flat union of marks over gates
  and suites accuses **sixteen** files, and sixteen exemptions is not a rule — **an exemption
  granted to a genuine violation is worse than the violation it covers**, so the fingerprint has to
  be sharp enough that its catches are real. This one carries **ONE** exemption
  (`check_cz::_cl_only_corpus`, the deliberate CL negative control) and it is keyed `file::func`,
  **never by file**: a file-scoped exemption blinds the rule to a new walk arriving in that file
  later. **COMMENTS ARE STRIPPED BEFORE THE MATCH** — `check_ds` took a red for a header comment
  that named two accessors while explaining that it does not call them, and prose describing a walk
  is not a walk.
- **A GATE THAT COUNTS A POPULATION IS ONLY AS GOOD AS ITS ENUMERATION, AND A GREEN EQUALITY OVER A
  SHORT WALK READS EXACTLY LIKE A GREEN EQUALITY.** `test_batch_cp` §3's `ability_hits ==
  ["Shatter"]` is the case, and DW paid it out: over the real corpus that population is **EIGHT**,
  and the biconditional beside it was **SIX where the truth is EIGHT**. Both are corrected, both
  print the live figure, and **`check_dw` re-derives each one live and asserts the suite's named
  table equals it** — a named population is only useful while it is still the real one. **ARCANE
  EXPLOSION BROKE BOTH RULES ON ARRIVAL AT DU §4 AND NOTHING WENT RED**, because the rules that
  would have caught it could not see it.
- **AND THE COST OF THE HOLE WAS NOT THE VIOLATION, IT WAS THE SEVENTEEN QUIET READINGS.** `check_da`
  read **37/0 on every battery since DA** with three hand-rolled walks standing in the tree. **A
  fingerprint with a hole does not fail loudly and does not fail slowly — it passes.** Proved by a
  one-character control: with the smallest walk restored, changing the family threshold from `2` to
  `3` returns `check_da` to a clean 39/0 with a 43-of-227 walk in the tree.

## A recast that would not improve is REFUSED (STANDING, SET AT BATCH CO)
**THE RULE: a status recast that would improve neither duration nor power is refused, and the
refusal is scoped to abilities whose WHOLE PAYLOAD is the status.** `_recast_refused` is the ONE
answer; `RECAST_GATED` (**59** abilities since DA §2) is the set.

- **WHY IT EXISTS.** `add_status` resolves a re-application as `max()` on duration and power, so a
  status whose power is a **snapshot of live state** could be recast at a weaker value, have that
  value discarded by the max, and still charge full resource, a full cooldown and the turn.
  Vespers reads the Cleric's current maximum health, Magic Barrier the Mage's, Divine Shield the
  Devout's — all three move during a fight.
- **THE SCOPE LIMIT MATTERS MORE THAN THE RULE.** An ability that also deals damage, heals, or
  converts a resource **must still cast** when its buff would not improve: that half is worth the
  turn on its own, and refusing it would be a worse bug than the one being fixed.
  **FUNERAL PYRE, STABILIZE, BATTLE SHOUT, RECKLESS ABANDON and BLESSING OF ZEAL are excluded for
  exactly that reason** — four of them were the cards that motivated the batch.
- **DERIVE MEMBERSHIP BY WALKING `_resolve_special`, NEVER BY READING `damage`/`pressure`** — CN's
  trap, and it is the same trap here: those fields are zero on Feint, Guard Change and Kill
  Command. 211 abilities → 134 with no field-level payload → 58 that qualify.
- **NEVER GATE ON A `power` THAT IS NOT A MAGNITUDE.** Mark of the Hunt, Snare Line, Eye of the
  Storm and Vendetta store `heroes.find(attacker)` in the status power; a numeric test there
  refuses on a hero's slot number. They are excluded and must stay excluded.
- **THE TEST IS EXACT AND COMPUTED AT CAST TIME**, never read off the authored value. Refusing a
  cast that would in fact have improved something is **strictly worse** than the bug. Three things
  the arithmetic must keep: powers recomputed live; **Fleeting normalised** (the target's own
  `mod_status_turns`, as `add_status` applies it); **a negative turn count is permanence, not a
  duration**, so nothing lengthens a battle-long status.
- **RIDERS COUNT AS IMPROVEMENT.** `barrier` is SHARED and `_grant_divine_shield` stamps `divine`,
  Blessed Barrier, Afterglow, Warded Robes, Unyielding (Mantle its hops). A Devout casting over a
  Mage's LARGER barrier improves it — it becomes divine, which feeds Faith — with neither duration
  nor power moving.
- **LAYERED FAITH IS NOT SUBSUMED AND MUST BE READ BY THE GATE.** BM's bespoke path is not a
  refusal: it pre-adds the standing pool so the recast is **additive**, always improves, and is
  never refused. The two compose. **Interpose is the same shape** and is the one member of the set
  that can never refuse.
- **ONE RULE, NOT ONE STRING PER CARD.** No ability description says anything about a second cast.
  It is stated once in the **glossary** (`recast_refused`) and carried in the moment by the tell,
  which lives in `_ability_tooltip` — the one site every surface reads.
- **AN ABILITY THAT PROPOSES NO WRITE AT ALL IS NOT THIS GATE'S QUESTION** (Alms and Divine
  Presence in a kit without Mercy): the handler already logs why, and refusing there would darken
  a button with a reason this rule cannot state.
- **A STATUS DURATION IS DECLARED TWICE AND BOTH COPIES MUST MOVE (STANDING, FOUND AT CR §3).**
  The cast handler writes it, and **`_recast_writes` declares it again** so the gate can predict
  what a recast would do. CR reverted three durations 6 → 4 in the handlers and left the table at
  6; the gate then proposed a longer write than the handler performs, read every recast as an
  improvement, and **stopped refusing a saturated recast on Alms, Divine Presence and Vespers.**
  **`check_co` FAILED ALL THREE BY NAME**, which is what a gate that spawns real battles buys over
  one that reads the table. **ANY EDIT TO A DURATION, POWER OR RIDER ON A `RECAST_GATED` ABILITY
  OWES THE SAME EDIT AT `_recast_writes`** — it is Batch BP's Eye of the Storm (two copies of one
  figure) one door along.
- **A HANDLER THAT GUARDS ITS OWN WRITE NEEDS THE GUARD MIRRORED, NOT THE VALUE (STANDING, DA §2).**
  Every other member of the set calls `_apply_status` unconditionally and lets `add_status`'s
  `max()` discard the weaker value; **Glacial Prison does not** — it reads
  `if not target.has_status("chilled")` and never calls it at all. `_recast_writes` therefore
  proposes the Chilled half **only when it would land**, and proposes the freeze half
  unconditionally so `_status_write_improves` can decide it. Get this backwards and the table reads
  its own optimism as an improvement — **CR §3 from the other direction.**
- **THE REFUSAL DARKENS A BUTTON, NOT A PICK, AND THAT BOUNDS WHAT IT CAN EVER BUY.** For a
  picked-target card the pool is every legal target, so the button dims only when **no** legal pick
  would improve. On Glacial Prison one unfrozen enemy anywhere keeps it lit; the refusal is real but
  it fires on single-enemy boards and little else. **That is the honest scope of the rule and not a
  defect in it** — Rime, Bola and Hysteria have carried the same scope since CO. **A per-pick
  refusal would be a second path, which CO forbids: one door, `_ability_usable`.**
- **`check_co.gd` IS THE ANTI-ROT PROOF AND IT IS A LIVE ONE.** It spawns **two** real battles —
  Alms and Divine Presence need Mercy, Mantle needs a living Devout, so one party cannot write the
  whole set — casts all 59 onto every unit each can reach, and asserts the gate's prediction
  against what actually landed. It also asserts the excluded cards OUT by name.
- **KNOWN, RECORDED, NOT FIXED:** Battle Shout, Stabilize and Eye of the Storm call
  `update_status` with a *computed* power after `_apply_status`, and `update_status` **assigns**
  power where `add_status` maxes it — so on those three a weaker recast **overwrites the standing
  buff downward**. All three carry a second payload, so the refusal cannot reach them; widening
  scope to catch them would delete a resource conversion the player wanted.

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
- **AND A DEAD STRUCTURE CAN BE THE LAST LISTING OF LIVE CONTENT.** Seven abilities are authored,
  resolving and fully implemented, and **`CLASS_POOLS` is the only list in the game that names
  them** — deleting the container would delete the record of the contents. **Before deleting a
  structure, ask what is reachable ONLY through it**, and count it.

## THE TRAPS — RULES THAT WERE BURIED IN BATCH BLOCKS (GATHERED AT BATCH CW §1)

**Every one of these cost a batch something.** They were stated inside a narrative and would
have been lost with it. **Live counts belong in `docs/state.md`; the rule is what is here.**

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
- **`wild_communion_ranks` IS THE BEASTMASTER'S; `communion_ranks` IS THE DEVOUT'S. THEY ARE
  DIFFERENT SPECS AND SHARE NO COUNTER AT ALL.** They have been crossed once already. The trap is
  asserted in BOTH directions, and the test walks both trees to prove the separation.
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
  **TWELVE scenes since Batch BK** (blacksmith is new). `check_parse.gd`
  force-loads every script and scene in one pass and is the faster gate.
- **`check_cm.gd` (Batch CM) is the GATED-ABILITY invariant gate**, and it is the enforcement
  behind the standing rule above: it walks the whole 211-ability corpus and fails if the gated
  set is not the five §1 names, if any gated ability heals or revives, if the draft card's tell
  disagrees with the flag, or if the tell breaks the standard's 44-character ceiling. **Run it
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
- **`test_batch_bl.gd` NEEDS `--fixed-fps 12` AND IT IS NOT THE sim.sh FLAG.** sim.sh passes
  240 to make frames run back-to-back in WALL time; this suite passes 12 to make each frame a
  big TIME step, because a real-play battle paces itself with `create_timer` waits and §2's
  ledger can only be read after a fight ENDS. At the default step a three-orc fight does not
  finish inside any sane frame budget; at 12 it finishes in ~700 frames and nothing the battle
  computes reads delta. Any future suite that has to run a REAL-PLAY battle to completion wants
  the same trick.
- New `class_name` files need `--headless --import` before they resolve.
- **RUNNING THE FULL SUITE BATTERY DESTROYS THE PLAYER'S IN-PROGRESS RUN (Batch BN, learned the
  expensive way).** Twenty-five suites spawn a live battle, which means `Run.new_run` and
  `clear_save`, and **`user://run_save.bin` is simply gone afterwards** — several suites back it
  up and restore it, but a LATER suite in the battery then wipes it again, so the individual
  backups buy nothing when the whole battery runs. `profile.json` survives with a few counters
  incremented (runs_started, occasionally a forfeit) and `relics.json` is byte-identical, so the
  META layer is safe; it is the run in flight that is lost. **Copy `run_save.bin` aside before a
  battery run if the designer has a run going**, and say so afterwards either way.
- Balance: `./sim.sh N` = N battles of the FIXED raider/chief/archer/archer
  lineup (power 7, unscaled) — kit smoke tests only; its win% carries NO
  difficulty signal (Batch R). **sim.sh passes `--fixed-fps 240` since Batch
  BJ §1 — 5.3x faster (headless frame-sync sleep removed), nothing the sim
  computes changes; a --run 100 is ~8 minutes. Every report ends with the
  BJ §3a signature-payoff table (per-spec signature moments, trash | boss).** `./sim.sh --sweep N` (DOD_SIM_SWEEP=1) = N
  battles at EACH budget 3/6/9/12, fresh fight-theme warband per battle,
  enemies unscaled (`DOD_SIM_ZONE` picks the roster); per budget it also
  prints avg enemy count, avg enemies alive entering round 3, and per-hero
  damage share (Batch S — a DOD_SIM_THEME'd sweep = per-theme share for
  free). `./sim.sh --run N` (DOD_SIM_RUN=N, def 50) = N COMPLETE runs with
  progression BOTH sides (tier scaling + slot mult, HP/mana/item carry,
  points earned AND spent, elite runes auto-equipped, trophies) → run
  report: wipe distribution, per-tier averages, measured party-vs-warband
  power table + run economy (gold earned/spent/unspent, items used/left,
  merchants/events/**blacksmiths**/bargains per run — **NOT rests: Batch AN
  deleted them and the "taken vs offered" row reads 0.0/0.0 forever**) + a
  per-invocation "Matrix row" line for cross-policy assembly. Policies
  env-set + printed: DOD_SIM_ROUTE (**greedy|balanced|cautious** since Batch
  BK, one axis — how much ELITE the bot accepts; `default` ALIASES balanced
  and `elites` ALIASES greedy so old scripts and Matrix rows still resolve).
  **BATCH BG §1 MEASURED WHAT THE THREE POLICIES WERE WORTH ON THE LINE AND
  THE ANSWER WAS NOTHING** ("Reachable nodes per step: 1.00 — steps offering
  a real choice: 0% (0 of 2764)", every node type taken == offered): from AN
  to BJ the three route rows were THREE SAMPLES OF ONE CONFIGURATION.
  **BATCH BK MADE THEM A REAL BAND AGAIN** — 1.61 reachable per step, 41% of
  steps a real choice, and the three policies walk 6.5 / 6.0 / 2.2 elites a
  run. A pre-BK three-policy row is still a triplicate, not a bracket; a
  post-BK one is a bracket.
  **BATCH DB §3 — AND THE HARDER HALF OF THAT, WHICH IS A COVERAGE FACT
  RATHER THAN A COMPARISON ONE: TWO THIRDS OF EVERY TALENT TREE IS OUTSIDE
  EVERY MEASUREMENT EVER TAKEN IN THIS PROJECT.** `Talents.LANES` is **3**
  and there are **twelve specs**, so the project has **36 lanes and every
  figure it has ever published was walked on the same 12**. **NO SIM NUMBER
  HERE HAS EVER INVOLVED GLACIAL PRISON** — the Cryomancer's Deep Freeze lane
  has never run outside DA's single smoke arm — and the same is true of
  Second Prison, Cold Snap, Glacial Economy and Absolute Zero. **THIS IS NOT
  A BUG AND IT IS NOT A BACKLOG ITEM**: a fixed default party is precisely
  what makes arms comparable across batches. It is a **permanent caveat on
  every sim figure**, and the rule that follows from it is narrow and
  absolute: **no sim figure may be quoted about a card in a non-default lane,
  and several have been.** The sim's own report prints the unmeasured count
  beside `builds=` since DB, so the caveat arrives with the number instead of
  living only here.
  **BATCH BG §1 STANDING CAUTION ON EVERY RUN BAND: `DOD_SIM_BUILDS`
  DEFAULTS TO EACH TREE'S FIRST LANE, AND THAT IS A CONFOUND WITH A KNOWN
  SIGN.** For the default party the first lane is Berserker Bloodletting,
  Cryomancer Winter, **Devout BULWARK — the lane BF measured at 14% against
  FAITH's 33%** — and Beastmaster devotion. Two of those four ARE the lanes
  their own batches measured as standouts, so a default-vs-named comparison
  is a two-hero difference, not a four-hero one. **Always print the build
  string beside a run number**, DOD_SIM_SHOPS=off / DOD_SIM_ITEMS=off
  (both default ON: shops heal-first — hero <50% buys a Health Potion each —
  then priciest affordable offer not carried, runes incl. but only onto a
  free slot + equipped at purchase, never dipping under the 40g reserve;
  battle bot drinks a carried Health Potion opening a turn <35% HP, run
  sims ONLY — sweep/standalone stay dry so R/S baselines hold),
  DOD_SIM_BUILDS="spec:Lane,...", DOD_SIM_TROPHIES, DOD_SIM_RELICS (draft),
  DOD_SIM_ROTATE=1 (Batch W: rotate all twelve specs; shares then carry
  sample counts — see Batch W in the changelog),
  DOD_SIM_DIFFICULTY=wanderer|warden|ruin — a RUNG of BM's ladder
  (x0.50 / x1.00 / x1.30 through zone_base_mult; "standard" still
  resolves and maps to warden). **THE DEFAULT IS RUNG 1 SINCE BATCH BM
  AND THAT IS THE TRAP: an unset flag is NOT the old baseline.** A row
  meant to compare against a pre-BM number must set warden explicitly,
  and BATCH BN MOVED RUNG 1 FROM x0.70 TO x0.50, so an unset-flag row
  taken before BN is not comparable with one taken after it either),
  DOD_SIM_RUNE_ECON=rich / DOD_SIM_RUNE_POWER=<mult> (Batch AD
  EXPERIMENT ARMS — measurement only, never shipped; UNLIKE every other
  flag here they are gated on Run.sim_run as well as the env, so a stale
  export cannot put a real run in an arm. rich = all slots from t1 + a
  spec-eligible authored rune granted at each zone half-mark; power = a
  multiplier on authored payload UPSIDE only, costs held, tpl_* stat
  sticks untouched).
  RETIRED IN BATCH AN, along with the features they controlled, and NOT
  revived by BK: DOD_SIM_MAP, DOD_SIM_MINIBOSS (the mini-boss is structural
  — slot 8 of every zone), DOD_SIM_START_RUNE and DOD_SIM_SPEC_OPENING
  (heroes begin with no runes). Matrix rows read **`map=branch`** since
  Batch BK (`map=line` = an AN-to-BJ row), carry no start=/specopen=/mb=
  field, and report depth out of **48 SLOTS** — so NO PRE-BK ROW IS
  COMPARABLE WITH A POST-BK ONE, and no pre-AN row with either.
  RunSim
  (scripts/run_sim.gd statics, Run injected Events-style) owns setup/map
  walk/report; battle.gd hooks: _ready begin+note_battle_start, _check_end
  sim branch → RunSim.on_battle_end. Run.sim_run=true makes
  save_run/clear_save NO-OPS (sims can never touch the real save) and no
  Profile/Relics.unlock calls exist in RunSim. GOTCHA: children added in a
  SceneTree script's _initialize never fire _ready (root not ready) — park
  scene-spawning tests on the first process_frame (scratchpad
  test_run_harness.gd = the 3 correctness gates: hero win scaling, talent
  spend conservation, enemy tier×slot scaling — rerun it before trusting
  any --run report after touching spawn/scaling code).
- **QUOTE THE RUN HARNESS AS "GATES 1/2/3" AGAIN — BATCH CA REPAIRED GATE 2, AND BY'S INSTRUCTION
  TO QUOTE ONLY 1 AND 3 IS SUPERSEDED. THE REASON IT EXISTED IS WHY THE HARNESS NOW PRINTS A
  COUNT.** From BM to BY, `test_run_harness.gd:125` called `run.award_spec_point` — **deleted by
  BM §6** — from **above every `_check` in the function**. The error aborted
  `_gate_talent_conservation` outright: zero checks ran, zero failed, and it printed `GATE 2 PASS`
  on the way out. **129 of BM's own replacement assertions had never executed once**, and twelve
  batches of VERIFIED blocks quoted "gates 1/2/3" on the strength of a word that was never earned.
  **A COUNT OF ZERO FAILURES IS NOT EVIDENCE WHEN THE COUNT OF CHECKS IS ALSO ZERO**, and this one
  printed a WORD rather than a number, which is why it outlived the `ah` and `an` cases.
  **CA'S NEXT CLAUSE READ "those print counts, and a count that reads wrong is visible at a
  glance", AND BATCH CD DISPROVED IT — THE CORRECTION IS THE MORE USEFUL HALF OF THE RULE.** `ah`
  and `an` DID print counts, those counts WERE wrong by 125 and 2,434 checks, and nobody saw it
  for twelve batches; three more suites were doing the same thing. **A COUNT IS ONLY VISIBLE AT A
  GLANCE IF SOMETHING IS COMPARING IT TO WHAT IT SHOULD BE** — and until CD nothing was, because
  the battery's counts lived in prose in this file and were transcribed forward by hand. **THE
  REAL RULE: A COUNT THAT NOBODY DIFFS IS A WORD.** test_batch_cd §1 is what diffs the five, as a
  FLOOR per suite; extend it rather than trusting a reader.
  **THE TWO STANDING RULES CA SHIPPED BIND EVERY GATE IN THE HARNESS, PRESENT AND FUTURE. They live
  in `_check` / `_check_range` / `_go`, so a gate added later inherits both by doing nothing:**
  **(1) A GATE REPORTS ITS CHECK COUNT, NOT A VERDICT** — `GATE 2 PASS (165 checks)`, never a bare
  `GATE 2 PASS`. **(2) A GATE THAT RUNS ZERO CHECKS MUST FAIL** — an empty gate is a broken gate,
  and it is the one case where silence has to be loud. **THE LIVE COUNTS ARE 22 / 165 / 8.** Quote
  them beside the verdict, and treat a moved count as something to explain rather than a nuisance. Matrix rows come from
  the per-invocation "Matrix row:" report line — assemble across
  runs, never rerun one row against another batch's flags. test_run_harness.gd RECREATED (scratchpad dies with its
  session): gate 1 win scaling + HP-sync asserts, gate 2 talent
  conservation via ceil(N/3) price replay (converted lane trees KEEP
  multi-rank nodes — extra ranks cost 1), gate 3 enemy tier×slot at
  the new rates; plus probes for ramp rolls and theme satisfiability
  (elite themes need budget ≥6 in every roster — hence the elite
  floor).
  **TUNE AGAINST THE CURVE, NEVER ONE POINT** — the ~85% win-rate target
  describes TOP-BAND (budget 10-12) encounters only, and attrition
  (deaths/battle) is the sensitive dial. `DOD_AUTOPLAY=1` = 1 debug battle
  (echoes every combat-log line as "[LOG] ..." — grep it in headless tests;
  NOTE: the end screen waits for input, so headless autoplay runs never exit
  on their own — run with a timeout/kill or they pile up as zombies).
  `DOD_SIM_SPECS="berserker,cryomancer,inquisitor,beastmaster"` picks the bot's
  specs (warrior,mage,cleric,hunter order). `DOD_SIM_ENEMIES="boss,shaman,..."`
  forces the enemy lineup in test battles. `DOD_SIM_TALENTS="bz_bloodcraze:3"`
  force-learns talents on bot heroes whose spec tree has the id.
  **STANDING NOTE — HOW TO READ A LANE ROW (Batch BC §0). THE HARNESS IS
  PER-HERO; THE FLAG STRING IS WHAT HAS ALWAYS BEEN ONE-SPEC.** It walks EVERY
  hero and keeps whichever named ids appear in THAT hero's own tree — but all
  **288 node ids across the twelve trees are disjoint** (asserted in
  test_batch_bc), so a string naming one spec's lane builds exactly ONE hero.
  **THERE IS NOTHING TO FIX HERE AND FIXING IT WOULD BE WRONG** — name four
  lanes and four heroes build. What it means is that **EVERY LANE ROW EVER
  REPORTED — the Warden's Threat at 30%, Holy's Radiance at 50%, the Devout's
  Faith at 80% — IS A FULLY-BUILT HERO MEASURED AGAINST THREE UNBUILT ONES.**
  Those rows are honest A/B comparisons of one spec's lanes AGAINST EACH OTHER,
  which is mostly what they were used for; they are NOT "how much of a real
  party's work this hero does". **A CONTRIBUTION SHARE INFLATES TWICE THAT WAY,
  and the second half is the one nobody expects**: three unbuilt allies shrink
  the DENOMINATOR, and they also feed the NUMERATOR for a support, because they
  take more punishment and fights run longer. Measured on the Devout: enemy
  damage/battle 207 -> 74 and rounds/battle 7.8 -> 5.4 once the other three are
  built, and his releases fall 32.2 -> 11.1 with them. **THE LEVEL MOVES A LOT
  AND THE LANE RANKING BARELY MOVES** (FAITH/ungeared is 4.4x one-hero and 5.0x
  all-four), so a re-measure is only owed where a row was read as an absolute.
  **BATCH BE BUILT THE ALL-FOUR LANE CONTROL SET FOR THE DEVOUT, which BC's grid
  lacked — use it rather than re-deriving it** (n=200, same lineup, other three
  on berserker Bloodletting + cryomancer Thaw + beastmaster devotion): **FAITH
  33% | ZEAL 31% | BULWARK 14% | ungeared 11%**, against the one-hero 54/42/23/18.
  **The FAITH cell is BF's re-measure (BE read 45 / 73 before its §2 condition);
  ZEAL, BULWARK and ungeared are BE's and are byte-identical by construction —
  a build without `dv_communion` makes no Communion draw at all.**
  **STANDING NOTE — WHAT A CONTRIBUTION SHARE CAN AND CANNOT SEE. THE BLIND SPOT
  BE §4 FOUND (Batch BE) IS CLOSED (Batch BF §1), AND WHAT CLOSED IT WAS TWO NEW
  COLUMNS, NOT A NEW SHARE.**
  **WHAT THE OLD COLUMN IS, AND IT IS NOW LABELLED AS SUCH: `d+h+p%` (it was
  called `contrib%`, and at least one number in this project's history was read
  the second way) = `(dmg + heal + prev) / pool`, pool built in `_stat` from
  exactly three key prefixes — `dmg_hero_`, `heal_hero_`, `prev_hero_`. THAT
  COLUMN DID NOT MOVE BY A POINT IN BF and must not: it is the control that makes
  every pre-BF row comparable with every post-BF one.** The table prints a legend
  under itself saying outright that it is not a share of the party's work.
  **WHAT IS NEW: `BD%` (a hero's Break DEALT over the party's, off its own
  `pool_bd_hero_` pool and its own `_b_bd_slice`) and `BDprev/b` (Break refused or
  reduced), plus a `break_prevented_line` audit under the table naming which
  effect refused what.**
  **BREAK IS STILL NOT FOLDED INTO `d+h+p%` AND MUST NOT BE** — that needs an
  exchange rate between a Break point and a hit point (one? a tenth?) that nobody
  can defend, and inventing it buries a guess inside every measurement taken
  afterwards. The two slices are SEPARATE DICTS for this reason: `_b_slice` is
  summed wholesale into the d+h+p pool, so a Break key living in it would fold
  Break in through nothing more than a `for` loop.
  **BREAK PREVENTED NOW HAS ONE DOOR — `_prev_bd`, on BC's `_devout_prev` pattern
  (per-hero total and named term written by the SAME call, so parts can never
  disagree with the total). SIX REDUCERS BOOK THROUGH IT** via `unit.gd`'s
  `_credit_bd` and the `bd_` term prefix that routes them: **Devoutness, Bulwark
  of Fortitude, Hold the Line, Ward, Immovable, Bracing.** Before BF exactly ONE
  of the six was booked anywhere. `faith_break_cut` survives as the Devoutness
  term's alias so `faith_report_line` and BC's test read on.
  **TWO DELIBERATE EXCLUSIONS, PINNED IN test_batch_bf SO THEY CANNOT BE QUIETLY
  REVERSED: base Constitution** (a stat block is not a contribution — the same
  rule that keeps base armor and resists out of `prev_hero_`; BRACING *is* booked,
  because a stance a talent bought is exactly what the damage side counts) **and
  the run modifiers `mod_bd_mult`/`mod_no_break`** (nobody in the party did that).
  **TWO MORE ARE ADJACENT AND ARE NOT IN THE COLUMN: Rallying Shout removes 30-50
  BANKED Break from each hero, and Battered Not Broken shrugs 30/rank off a
  blocker's meter.** Those are Break *healing*, not Break refused — a different
  question from "how much never landed" — so they are not booked; if a later batch
  wants them it wants a new column, not this one. **Nothing else in the game
  writes `pressure` downward except `revive` and `recover_from_break`, which are
  structural.**
  **WHY IT MATTERED, AND IT REACHED WELL PAST THE DEVOUT: BC's grid read
  −Devoutness at 80% — a zero — and that zero was the instrument, not the node.**
  The Warden's whole THREAT lane is Break (AL measured his BD/battle 104 -> 320
  and the party's Breaks/battle 1.02 -> 2.35), the Occultist's Broken Will and
  Entropy exist to grind a boss's meter, and BD gave a single deadfall 270 Break
  points. **A BUILD THAT PAYS IN BREAK STILL READS LOW IN `d+h+p%` BY
  CONSTRUCTION — read it in `BD%` and `BDprev/b`, and never call such a build weak
  off the d+h+p column alone.**
  `DOD_SIM_ABILITIES="Resurrection,Divine Plea"` appends pending
  talent-gated abilities (Classes.pending_talent_ability; Holy only).
  `DOD_ENEMIES_OFF=1` arms the enemy-skip debug toggle headlessly.
  `DOD_DEBUG=1` adds map-burger debug items (gold/points/heal/
  jump-to-boss/next-zone; the talent grant is +200) in an EXPORTED build;
  `DOD_DEBUG=0` FORCES THE GATE SHUT in a dev build (Batch AC — the only
  way a headless test can stand where an exported build stands).
- GDScript gotchas that bit us: multiline lambdas in call args (use named
  methods), ternaries need parens for type inference, `:=` can't infer from
  untyped funcs, edits via python heredocs (apostrophes!) — use chr(39),
  min()/max() are numeric-only (String args = runtime error mid-_init and
  a headless --script run then idles forever — compare with < instead).
- **EVERY data/*.json FILE IS TAB-INDENTED, so `json.dumps(..., indent=2)`
  REWRITES THE WHOLE FILE** — a one-entry glossary edit came out as a 1,966-line
  diff that buried the change and reset a shipped file's formatting convention.
  Use `indent="\t"` and `ensure_ascii=False`, and ROUND-TRIP FIRST (dump the
  unmodified parse and assert it equals the file byte for byte) before writing.
  Caught at review, not by a test — nothing asserts a data file's whitespace.

## Architecture (all UI built in code, no editor scenes)
- `scripts/run_state.gd` (autoload `Run`): party/items/gold/the LINE/zones,
  save (user://run_save.bin v10, auto-saved after every slot), relic slots
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
  points, the correct state). The run save is **v10** and **a pre-v10 save is REFUSED and
  cleared** (the final zone gained a 17th slot; a v9 map has no position after its boss).
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

## STANDING REFERENCE — ENEMY INTENT: ONE DECLARED-ACTION STORE, THREE RE-VALIDATION BRANCHES (Batch BL §1)
**DECLARE ON SCHEDULE, RESOLVE ON TURN.** `_choose_enemy_action` is the SELECTION half lifted
out of `_enemy_turn` **byte-for-byte** — §1 forbade an AI rewrite and that function is where the
promise is kept, so a diff touching the rules inside it broke the promise. Only *when* it runs
moved. Sites:
· **Declaration**: `_declare_intent(u)` (writes `BattleUnit.intent` + the plate).
  Called from **`_declare_all_intents()`** at battle start (in `_run_battle`, after the opening
  oath/Faith hooks — they move state the policy reads) and from **the turn loop right after
  `await _enemy_turn(u)`**, NOT from the bottom of `_enemy_turn`: that function has eight
  returns and a declaration owed on all of them is a declaration owed by the caller. Also on
  each lost-turn branch (stun/freeze/broken, after the discard) and in `_hold_release`.
· **Re-validation** at resolution, `_revalidate_intent(u)`, in this fixed order — (1) **target
  gone → re-target within the SAME ability** (`_istat("intent_retarget")`); (2) **ability
  unusable → fall back to `_cheapest_attack` AND LOG IT** (`intent_fallback`; a silent
  substitution is the intent system lying); (3) **cannot act → `_discard_intent`, DISCARDED NOT
  BANKED** (`intent_discarded` + `intent_discard_<cause>`; stunned/frozen/broken/held).
  **READ THE TARGET UNTYPED FIRST** — a declared beast can be `queue_free`d between declaration
  and resolution, and a typed assignment of a freed instance errors BEFORE `is_instance_valid`
  can run. Found in a live 50-run measurement; pinned in test_batch_bl.
· **A FOURTH counter, deliberately not one of the three**: `intent_hijacked` — Hysteria,
  Bewitch and Psychosis take the turn, so the unit ACTS but not as declared. Counted at the
  moment each branch COMMITS (Psychosis is a coin-flip; clearing on the status alone would
  throw away declarations on the half of turns the madness does not take).
· **THE `charging` STATUS IS THE SAME MECHANISM, NOT A SECOND ONE.** The wind-up stores its
  blow in `intent` like everything else; the status survives only as the chip and the cancel
  hook. **Nothing reads an ability name off the status any more** (asserted). `_declare_intent`
  returns early on `has_status("charging")` — that ONE line is why a charging enemy declares
  once, not twice. `_cancel_charge` routes through `_discard_intent`, so a cancelled wind-up
  counts as exactly one discard. **A later batch wanting a multi-turn declaration sets
  `intent.turns` and adds a chip. IT DOES NOT ADD A SECOND STORE.**
· **Counters go through `_istat`, NOT `_stat`** — unconditional, not sim-gated, because the
  re-validation rates are a property of the MECHANISM and must be observable in real play or
  "a stun really discards" is only checkable by trusting the code that does it. In sim they
  land in the same `sim_stats` dict, so there is still exactly one counter.
  `intent_report_line(stats)` is a static and prints in BOTH reports.
· **Categories are DATA-DRIVEN** (`_intent_category`): windup → mend → ally-target → aoe →
  `pressure > damage` → applies_status-and-not-this-unit's-hardest-hit → strike. Order IS the
  classification. An enemy added to enemies.json classifies itself; there is no name table.
**NO PREDICTED NUMBER SHIPPED, AND THIS IS THE FINDING RATHER THAN AN OMISSION.** §1 required
the number come from the same call the real hit makes, run dry, and named the escape hatch. The
strike block is `battle.gd` ~4990-5670 (~680 lines) and fails on two counts, either fatal
alone: (a) it mutates on the way through — `crit_streak`, resource restores, `float_text`, and
writes to THREE ledgers (`_prev`, `_devout_prev`, `_stat`); (b) its FIRST line is
`randf_range(0.9, 1.1)` and a crit rolls inside it, so **the same call with identical inputs
returns a different number**, and §4's "predicted equals dealt" could not hold even after a
perfect extraction. Icon + the ABILITY'S OWN NAME is shown instead — read off the declaration,
so it cannot drift. **The negative control changed shape to match**: test_batch_bl greps the
intent block for `attacker.attack` / `effective_armor` / `randf_range` / `resists.get` and
fails if a later batch adds a preview by reimplementing the maths.
**TWO THINGS §1 DELIBERATELY DID NOT BUILD — NOT BUILT, NOT MISSED:**
· **HIDDEN INTENT** (an enemy whose intent is concealed, making information a resource the
  player fights for). A good mechanic and a DIFFERENT one; author it once the baseline is
  legible. Flagged, not built.
**MEASURED AT BL (150 runs, 50 per policy, 50,799 declarations) — the baseline a later batch
compares against.** Re-targeted **3.2 / 3.5 / 5.9%** (greedy/balanced/cautious); **fell back to
basic 0.0% in all three** (the number §1 said to watch — the declaration is NOT happening too
early); discarded **16.1 / 15.1 / 11.2%**, and it is **almost all the Cryomancer's hold** (3014
/ 2598 / 1365) with Break the remainder (103 / 94 / 162) and **zero plain stun or freeze** —
in this party his freeze always becomes a hold. **ONE IN SIX DECLARED ENEMY ACTIONS NEVER
HAPPENS.** `intent_hijacked` reads **0.0% and that is a MEASUREMENT HOLE, NOT A RESULT**: the
standard test party carries no Occultist, so no madness status was ever applied — the counter
is asserted in the suite but has never run at scale. **Completions 52 / 46 / 20% against BK's
39.3 / 43.3 / 21.3.** All three inside their 95% bands, **but greedy is +12.7 pts and near the
edge of its own, so it is a signal rather than noise.** The bot cannot benefit from SEEING an
intent, so if it is real the mechanism must be the one behavioural shift below — an enemy that
declared before a Break window opened does not take it. **NOTHING WAS TUNED**; BK's baselines
are two batches old and correcting inside the batch that moves them is the Devout mistake.
· **AN AI REWRITE.** Selection logic is untouched. **What DID change is that state-sensitive
  policies now read the board ONE TURN EARLIER** — reported, corrected nowhere: the whole of
  `_enemy_support_action` (Healing Wave <40%, Regenerate <50%, Cleansing Rite, Shielding, Wild
  Growth <70%, Dark Vigil), the **Broken-hero exploit** (the most sensitive of all — a Break
  window is short and a declaration made before it opens will not take it), `_lowest_hp` /
  `_threat_pick`, the taunt narrowing, and the Savage Presence / Ghillie Suit rolls.

## STANDING REFERENCE — THE RECAP LEDGERS AND THEIR BOUND (Batch BL §2)
**DAMAGE TAKEN WAS TRACKED NOWHERE BEFORE BL** — `_stat` knew `dmg_hero_` / `heal_hero_` /
`prev_hero_` / `bd_hero_` / `st_hero_` and nothing taken. It now hangs off ONE door:
**`BattleUnit.damage_taken_cb`**, fired by `_report_taken` from the only two places health
leaves a unit (`take_hit`, `take_tick_damage`). It reports the **DELTA, not the argument** (a
52 into a hero on 40 is 40 taken, or the column would disagree with the health bar) and sits
**BELOW ALL FOUR DEATH-REFUSALS** — Hold the Line, Undying Rage, Ashes of Al'ar,
Intercession/Martyrdom. Above them it would count health handed straight back AND file a
refused death as a killing blow. A future damage source cannot forget to report: it cannot
remove health without one of those two functions.
· **ATTRIBUTION IS A FRAME**, `_dmg_frame(src, label, src_name)`, set at **`_resolve`'s entry**
  — one site covering the strike, its splash, echoes, the reflect/retaliation it draws and the
  recoil/Blood Price it costs — **re-established after each of the TEN nested `await _resolve`
  calls** (a counter leaves the frame pointing at itself) and set explicitly at the two damage
  sites outside `_resolve`: the **DoT tick loop** (from the status's `src_name`, which
  `_apply_status` already stamps — the applier may be dead). **THE THIRD SITE WAS THE
  OVERBURN/CAUTERISE DRAIN AND BATCH BS DELETED IT WITH THE DRAIN.** **SELF-INFLICTED IS DECIDED BY IDENTITY** (`victim == _dmg_src`), which covers Blood
  Price, Dark Pact and recoil in one rule and cannot go stale
  the way a name list would.
· **BY KIND, NEVER BY INSTANCE** — `_taken_source` reads the new `BattleUnit.enemy_kind`
  (stamped in `_enemy_config` AFTER the "boss" alias resolves, so a boss books as what it is).
  `unit_name` happens to agree today; keying on that agreement would make the aggregation an
  accident the first uniquely-named enemy breaks. Negative control renames two same-kind
  instances and asserts one row.
· **New tally keys** (`Run.tally`): `dealt` hero→ability→amount, `taken`
  hero→"`<kind> / <ability>`"→amount, `taken_total` hero→amount (**exact, never folded**),
  `kills` (list), `final` (a whole copy of the other four, **overwritten every battle — so at
  run end it IS the final battle** and nothing has to know which fight that was).
  Writers `tally_dealt` / `tally_taken` / `tally_kill` / `tally_bank_final`, all through the
  ONE bounded writer `_tally_book`.
· **THE BOUND: `TALLY_KEYS_PER_HERO = 24` rows per hero per map, INCLUDING the `(other)` row**
  (so "at most 24", not "24 plus one"); `TALLY_KILLS_MAX = 12`, oldest kept. Overflow FOLDS
  into `(other)` rather than being dropped — the total stays exact and only the breakdown gets
  coarser, which is the right way round when the panel reports a top 5.
· **Banked by `_bank_run_ledgers()`**, called from `_check_end`'s run branch AND from
  `_do_forfeit` (a forfeit never reaches `_check_end`, and the abandoned fight is exactly what
  the tester wants explained). **Idempotent** — it clears the slices as it banks.
· **SAVE VERSION 8 → 9, TOLERANT** (unlike BK's v8 refusal): these are counters, not structure,
  so a v8 save loads and seeds the new keys at zero mid-run. A recap that starts counting
  halfway beats a wiped run.
· **BL DROPPED A `sim and` GUARD IN THE DoT TICK LOOP and it was a real hole, not a tidy-up**:
  in REAL PLAY a Pyromancer's Burn and a Survivalist's Poison reached neither the run summary's
  damage share nor anything else. **Sim totals are untouched** — that path already counted the
  ticks — so **no baseline moves**.
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
· RETIRED, still printed as retired in the report header: `DOD_SIM_MAP`, `DOD_SIM_MINIBOSS`,
  `DOD_SIM_START_RUNE`, `DOD_SIM_SPEC_OPENING` (Batch AN, with their features).

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
  never heal the hunter off enemy hits | `_on_beast_death` battle.gd ~10790; the clamp const
  beside BOND_STEP ~7370-7385; `_loyalty_cap` returns the LOYALTY_UNCAPPED sentinel (only Wild
  Rotation hands it a number — the cap IS that node's cost).
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

**THE LAST SENTENCE IS THE RULING, AND IT IS WORTH 83 NODES.** The charter as first written said
two different things: one clause permitted a node to be general in two ways only — *a STAT, or the
spec's OWN resource and passive* — and another said *a node modifying a CORE KIT ability is
guaranteed*. Under the first reading the trees were 235 of 324 clean; under the second, 318.
**THE SECOND READING STANDS: the hero owns its core kit in EVERY run, so modifying it is not a
bet.** The looser sentence is corrected wherever it was written down so it cannot be quoted back.
**DO NOT RE-OPEN THIS AS AN OPEN QUESTION** — `docs/talent-audit.html` §8 records it as settled.

· **WHAT IS PERMITTED, IN FULL:** a STAT; the spec's own PASSIVE; the spec's own RESOURCE; the
  spec's PROTECTED CORE (`Classes.protected_names` plus `core_enablers`); and **another node in
  the same tree** — a cross-row conditional bets on a node the player CHOOSES, not on a card they
  are DEALT, so the seventeen tree-internal dependencies are not the defect and all of them stay.
· **WHAT IS FORBIDDEN:** granting an ability at all, and naming any ability from a draft pool, a
  spec pool (the zone-boss trophy), a class pool or another spec — **including as a bonus clause
  on a node that works without it.** A bonus clause on a drawn card is still a bet; §2's four
  rewords cut exactly that shape.
· **RUNES MAY STILL GRANT, AND FOUR DO** — Comet (a `new_ability`), Binding Souls, the Last Rites
  and the Flayed Mind (`grant_ability`). A rune is BOUGHT with knowledge of the run in front of
  you, which is the whole distinction. **`Talents.apply_payload`'s two grant branches and
  `_collided` are therefore NOT dead and must not be deleted** even though no talent reaches them.
· **CUTTING A CLAUSE MEANS CUTTING ITS PAYLOAD TERM.** A node whose text loses a clause while its
  code keeps paying it is the defect this project has found five times. DO cut three terms with
  three clauses (`sunder_guard_bd`, `rallying_stomp_ranks`, `bulwark_line_ranks`), field and read
  site together, and `check_do` §3 asserts all three are absent from the whole of `scripts/`.
· **A RE-AUTHORED CELL KEEPS ITS ID, ITS LANE AND ITS ROW.** `Talents.cells_spent` prices each
  owned cell off the row it CURRENTLY sits in, so a node that MOVES row mis-prices a saved
  allocation — DN measured a full Berserker ledger at **−2 available points**, with nothing to
  refuse it, clamp it or log it. **Nothing in DO moved a cell, so no save migration was needed
  and `Profile` is still v2.** `check_do` §3 asserts the twenty-five re-authored cells are all in
  their original lane and row.
· **THE GATE ASSERTS THE PROPERTY AND PRINTS THE COUNT, NEVER THE REVERSE.** DN's own gate
  asserted a NUMBER and its first battery caught it, costing a second thirty-five-minute frozen
  run. `check_do` §1 asserts *no node grants* and *no node names an ability outside its protected
  core*, and prints 324 / 0 / 98 / 1 / 0 beside them.
· **NAME A RE-AUTHORED NODE SO IT CANNOT BE CONFUSED WITH THE CARD IT REPLACED.** A talent tree is
  a namespace and the matcher resolves same-tree names first — but a node NAMED "Overcharge" beside
  a draft card called Overcharge is the `wd_spiked`/Spite trap DN documented, in a new place. The
  Arcanist's row-4 Resonance cell is **Overdraw** for that reason. Five nodes were already named
  after live abilities before DO (Second Wind, Spite, Rally, Killing Frost, Divine Presence);
  **DO added no sixth.**
· **WHAT THE MOVE COSTS, RECORDED RATHER THAN HIDDEN: nine abilities lost their upgraded
  variant.** An `upgrade` arm fires only where a node's grant COLLIDES with an earned copy, and no
  node grants — so `battle_shout_node`, `lunge_upgraded`, `execute_upgraded`, `hold_line_upgraded`,
  `rampage_upgraded`, `overcharge_extra`, `intercession_long`, `resolve_extra_turns` and
  `bulwark_extra_turns` are read-only-zero now. **The fields and their read sites are LEFT
  STANDING** — each reads a base beside it, deleting a branch is deleting a mechanic, and two are
  already in `runes.gd`'s coercion list against the day a rune writes them.

### THE STATUS HALF, ADDED AT DP — AND IT IS THE SAME RULE, NOT A SECOND ONE

> **A talent may not read a status the spec has no guaranteed way to apply.**
> The ability rule and the status rule are the same rule — `sm_precision` named no ability and
> was still a bet, and the ability-matching instrument could not see it.

**THIS COST WAS DO's OWN AND IT WAS REPORTED RATHER THAN HIDDEN.** Mind Flay and Mass Hysteria are
the only appliers of Psychosis and Hysteria in the game, and DO moved both into the draft — so four
Occultist Madness cells (`oc_spread`, `oc_whispers`, `oc_delirium`, `oc_permanent`) read a status
he can no longer guarantee. **Before DO those dependencies were TREE-INTERNAL, which the charter
explicitly permits.** A ruling can create a defect without anyone making a mistake.

· **AN INSTRUMENT THAT MATCHES ABILITY NAMES CANNOT SEE THIS CLASS OF BET AT ALL.** A node can
  name no ability whatsoever and still bet on the draw, because a STATUS has appliers and a node
  reads the status rather than the card. `check_dp` §1 sweeps every node's rendered text against
  every status form and asserts the PROPERTY.
· **THE RATCHET IS ASYMMETRIC, FOR `baselines.json`'s REASON ONE LAYER UP.** A pair NOT in
  `check_dp.KNOWN_PAIRS` is an **error** — it is a new bet. A known pair that has GONE is a
  **notice** — that is a repair, and a gate that reds on a repair teaches the next batch to leave
  the defect alone.
· **FOUR OF THE SIX TOLERATED PAIRS ARE INSTRUMENT ARTEFACTS, NOT BETS, AND EACH SAYS WHICH.**
  The sweep matches a rendered WORD, so it cannot tell a node READING a status from one APPLYING
  it (`sv_virulence` and `ss_exposed_nerve` both apply the Exposed they then read), nor an enemy's
  debuff landing on the HERO from a hero's landing on an enemy (`ss_no_cover` is an IMMUNITY).
  **Only `sm_guarded` is a real bet, and it is a bonus clause gated on a tree-internal node with
  an unconditional base clause — the node cannot go dead.**
· **RE-POINTING A LANE ONTO ONE QUANTITY FLATTENS IT.** Madness was authored as a theme, and four
  cells all reading "stacks of Ruin" would be one idea repeated four times. The four read four
  DIFFERENT quantities — an application, an application's magnitude, an event, and a depth
  threshold — and **none reads a detonation**, because Grim Focus, Unraveling and Avatar of Ruin
  already own that event. `check_dp` §2 asserts the four are distinct.
· **BEFORE RE-POINTING A NODE OFF A FIELD, CHECK WHETHER A RUNE WRITES IT.** The Rune of the
  Whispering Dark writes `spread_ranks` AND `spread_ruin`; a fresh field name would have left two
  of that rune's four clauses paying nothing, in silence — the exact dud the rune schema exists to
  prevent. **Both fields were KEPT and their meaning re-pointed instead**, which cost one line of
  card text. `check_dp` §4 now asserts the general property: **every stat field any rune writes
  has a live read site in `scripts/`** (116 fields, 0 dead).
· **A CONSTANT QUOTED AT MORE THAN ONE SITE MOVES IN A FUNCTION, NEVER AT THE SITES.**
  `OLD_GODS_MARK` is the passive's mark and was quoted at five call sites; Whispers moves it, so
  the five call `_old_gods_mark()` now — `_ruin_threshold()`'s shape exactly, which Avatar of Ruin
  has used since AX. **The base stays the one authored copy**, and `check_dp` §3 asserts no
  `_gain_ruin` call quotes it directly, so a sixth site cannot be added that the node silently
  fails to reach.
· **A CONTAGION THAT MARKS THROUGH THE FUNCTION THAT MARKS IT NEEDS A RE-ENTRY GUARD.** Covenant
  of Ash breaks its recursion BY IDENTITY (the ash always lands on one known bearer, so
  `mirror == target` stops it); a contagion lands on a RANDOM enemy and has no such property.
  `_ruin_spreading` is the equivalent, and it is bounded rather than absolute — a covenant mirror
  can still roll its own contagion, so the ceiling is two rolls per originating mark.
· **A RUNE GRANT RESOLVES THROUGH `Classes.pending_talent_ability`, NOT THROUGH THE DRAFT
  RESOLVER.** DO moved twenty-two card NAMES into `SPEC_DRAFT_POOLS` while the six `grant_ability`
  DEFINITIONS stayed where they were, which is the only reason four granting runes still work.
  **Had a definition moved with its name, its rune would grant nothing, silently.** `check_dp` §5
  asserts every rune grant still resolves.
· **TWO RUNES NOW DUPLICATE A DRAFT CARD'S GRANT, AND THAT IS NOT A DEAD RUNE.** Binding Souls
  grants Sacred Resolve and Flayed Mind grants Mind Flay; both cards are in their spec's draft
  pool since DO. Holding both COLLIDES: `_collided` finds no authored `upgrade` arm and no
  `no_fallback`, so the rune owes its generic and `Run.apply_upgrades` — which runs last — turns
  it into an upgrade on the very card it would have granted (**Honed** and **Quickened**
  respectively). That is the Rune of the Last Rites' shipped behaviour since AV, now reachable by
  two more. **Both descs still open "Grants …", which is wrong whenever the card was drafted** —
  the Last Rites is the one that says so honestly, and the other two are owed a sentence.

## STANDING REFERENCE — THE ABILITY DRAFT, THE SEVEN-SLOT CAP AND THE TWELVE PROTECTED CORES (Batch BO, reach rewritten at BX)
**AN ELITE OFFERS A DRAFT TO EVERY LIVING HERO (Batch BX §2), on ONE SCREEN of four columns,
each hero drawing from their OWN pools and keeping their OWN no-return ledger.** BO offered to
one hero drawn at random; that is history. Everything else in this block is BO's and still
current.
**A SECOND ABILITY SOURCE BESIDE THE BOSS PICK, AND IT IS A SEPARATE POOL ON PURPOSE.**
`Classes.SPEC_DRAFT_POOLS` / `CLASS_DRAFT_POOLS` are what elites, merchants and events offer;
`SPEC_POOLS` is still what a ZONE BOSS offers and it is byte-untouched. Sharing one pool would
have re-weighted every boss offer in the game the moment eighteen entries landed, which is what
"the existing pick, unchanged" forbids. **A drafted ability lands in `member["bm_abilities"]`,
the SAME list a boss pick writes**, so the battle spawn, the hero sheet, `Talents.ability_names`,
the rune eligibility filter and the upgrade pairing all pick it up with no new plumbing —
**NO SAVE VERSION MOVES (still v10)**; the new member keys (`draft_candidates`,
`draft_picks_owed`, `draft_refused`) ride the party dict, which is saved wholesale.
· **THE CAP IS 7 (`Run.ABILITY_SLOT_CAP`) AND IT BINDS EVERY SOURCE**, the boss pick included.
  §3 leaves the boss OFFER unchanged, but a cap that one pool can walk past is not a cap: a
  Beastmaster's five spec-pool entries alone reach eight. `Run.ability_slots_used` =
  `Classes.core_slots(spec)` + earned.size().
· **PROTECTED = THE OPENING KIT. EARNED = DROPPABLE.** `Run.drop_earned_ability` is THE ONE
  PLACE a drop is written and it refuses anything not in `bm_abilities` — so "a protected
  ability can never be dropped" is not a branch that could be got wrong, it is the absence of
  the name from the list. Both pick paths call it.
· **DECLINING REFUSES THE WHOLE OFFER; TAKING ONE REFUSES NOTHING.** `draft_refused` is the
  no-return ledger, per hero per run. A DROP writes it too.
· **THE OFFER FILLS SHORT rather than padding with repeats** (AP §3's rule, unchanged), and
  `Run.draft_card_is_class` is the one-in-four seam — **its own function precisely so a test
  can drive it 4000 times while both class pools are still empty.** A check on the roller could
  only ever measure zero today, and a check that can only pass is a gap (BK's zero-blacksmith
  lesson).
· **THE UI IS THE EXISTING OVERLAY, NOT A SECOND ONE.** `map_screen._open_pick_overlay` gained
  a "draft" kind and a `pending` argument; the drop step is the same overlay redrawn.
**THE TWELVE PROTECTED CORES — `Classes.PROTECTED_CORES`, AND THE `enablers` COLUMN IS THE
THING A LATER BATCH WOULD MOST EASILY BREAK.** It is AUTHORED rather than derived, and
test_batch_bo asserts every named enabler is in that spec's opening kit and in NO pool. The
failure it prevents is SILENT: a spine that stops working because its enabler became draftable.
`slots` | spec | what the passive cannot function without:
· 3 **Berserker** — nothing (Blood Frenzy reads his own health bar).
· 3 **Warden** — nothing (Heavy Plating is a Block rule, it reads no ability).
· 3 **Swordmaster** — **Guard Change**. AK called it "the only stance swap in the game" and
  **BATCH BP MADE THAT FALSE** (Precision Strike and Feint both switch). It is still the
  enabler for a sharper reason: it is his only UNCONDITIONAL swap — the other two are
  drafted, cost Rage and carry cooldowns.
· 3 **Pyromancer** — **Fireball, Detonation** (Overburn needs an applier AND a spender).
· 3 **Cryomancer** — **Frostbolt, Ice Lance** (a Chilled applier, and a release).
· 3 **Arcanist** — **Arcane Explosion** (the free cast that guarantees a build every turn).
· 4 **Holy** — **Heal, Hymn of Hope** (Mercy must be spendable; Empower needs a heal).
· 3 **Devout** — **Divine Shield, Consecrated Ground** (the only Faith trigger, and the drip BI
  measured at 66% of all Faith).
· 3 **Occultist** — **Shadowrend, Hex of Ruin** (the debuffs the passive marks off).
· 3 **Beastmaster** — **all three summons**. **FIVE ABILITIES IN THREE SLOTS** — the summon
  picker has been ONE bar entry since AH, and counting three would take a spec to two draftable
  picks for a bookkeeping reason.
· 3 **Sharpshooter** — **Quick Shot** (Lethal Aim counts consecutive single-target attacks).
· 3 **Survivalist** — nothing (Trapper's breadth term counts statuses from ANY source).
**BATCH DS CLOSED THE HUNTER CLASS GAP. THE DRAFT STANDS AT 149 OF 149 AND NOTHING IS OWED
— 125 SPEC + 24 CLASS-WIDE.** Its three specs held the three SHALLOWEST pools in the game (eight
apiece), received NONE of DO's twenty-two, and **not one of their twenty-four cards was a heal, a
shield or hero-side mitigation.** All three read TEN now, matching the Cleric class, and each
spec's defence is shaped by its own engine — the companion for the Beastmaster, the Focus meter
for the Sharpshooter, the affliction board for the Survivalist. **THE FLOOR STAYS AT EIGHT AND IS
NOW SLACK EVERYWHERE**: the Warden's nine is the shallowest pool in the game, and `SPEC_FLOOR`
catches a pool that EMPTIES rather than tracking the deepening.
**BATCH DR MOVED THE TOTAL TWICE IN ONE BATCH AND THE NET WAS +1, TO 143 OF 143.** §2 retired one
Cryomancer card as an exact duplicate at a worse price (12 → 11) and §4 gave the Swordmaster
two (10 → 12).
**BATCH DO MOVED IT BEFORE THAT, FOR THE FIRST TIME SINCE CI, AND IT WAS NOT A NEW TRANCHE
EITHER** — it stood at 142 of 142 with 118 spec. Twenty-two talent nodes
GRANTED an ability; the charter forbids that outright now, so all twenty-two cards moved into
their spec's draft pool rather than being deleted. **NO POOL LOST ANYTHING AND THE FLOOR IS STILL
EIGHT** — nine specs are deeper than eight and three (beastmaster, sharpshooter, mystic) still
read exactly eight, because those three trees granted nothing to move. **THE PER-SPEC
EXPECTATION IS A TABLE NOW, NOT A MULTIPLE** (`test_batch_cd.PER_SPEC_DEPTH`): writing `12 * 8`
again would re-assert the CI-era shape over a tree that has moved past it.
**THE TARGET WAS 120, NOT ~96, AND THE ~96 IS DEAD (Batch CD §2). 96 SPEC (12 specs x 8) + 24
CLASS-WIDE = 120; THE DRAFT STOOD AT 120 OF 120 AND NOTHING WAS OWED (Batch CI), AND DO'S
TWENTY-TWO TOOK IT TO 142 OF 142, DR'S NET +1 TO 143 OF 143 AND DS'S SIX TO 149 OF 149.** The ~96 came from an older
assumption of SIX spec cards per spec and CB completed the Mage at EIGHT, which is what makes the
spec target 96. **`test_batch_bt` HAD ASSERTED DEPTH 8 SINCE CB, so the tests encoded the right
figure while the prose contradicted it for a whole batch** — the stale denominator was in
master.html §6b, in this file, AND in three comments in `classes.gd`, which is why CD's §2 swept
for it rather than fixing the two known sites. **DO NOT QUOTE ~96 AGAIN.** Dated changelog entries
keep it as written (they are the record of what each batch believed — CA's rule); this is
the correction.
**TRANCHE 3 IS COMPLETE AND THE ABILITY DRAFT IS FINISHED (Batch CB the Mage nine, CE the Cleric
nine, CH the Hunter nine, CI the WARRIOR nine) — `SPEC_DRAFT_POOLS` REACHED 96 AND THE DRAFT
REACHED 120 OF 120 THERE. **SINCE BATCH DS IT IS 125 AND 149 OF 149: ALL TWELVE SPECS DRAFT FROM
AT LEAST NINE — ELEVEN OF THEM FROM TEN OR MORE — ALL FOUR CLASS POOLS HOLD SIX, AND
NOTHING IS OWED.** The asserted FLOOR is still eight and is deliberately slack; the Warden's
nine is the live minimum.
**THE ASYMMETRY THAT SHAPED EVERY BATCH FROM BO TO CH IS GONE. DO NOT RE-RECORD ANY PART OF THE
DRAFT AS OWED, AND DO NOT WRITE "the Hunter and Warrior six draft from five" ANYWHERE AGAIN** —
that sentence is dead in master.html §6b, in `classes.gd`'s header comment and here.
· **WHAT THE SUITES GUARD FROM HERE ON IS THE FLATNESS, NOT A DEBT.** Every draft suite's per-spec
  depth loop inverted for the SEVENTH and LAST time at CI. It has asserted, in order: each earlier
  tranche's own asymmetry, then the flatness tranche 2 achieved, then CB's new asymmetry, that
  asymmetry halved at CE, quartered at CH, and now gone. A pool that quietly EMPTIES now trips,
  where before it would have read as the old debt coming back.
**THE FILL-SHORT CONSTRUCTIONS HAD NOWHERE LEFT TO GO, SO THE ARITHMETIC MOVED INSTEAD (Batch CI
§5), AND THE SHAPE THEY LANDED IN IS THE ONE A LATER BATCH MUST KEEP.** Three of the four
(test_batch_bo, bq, br) refused the whole class pool plus a HARDCODED three of the hero's own
cards — an arithmetic that assumed a five-deep pool, and at eight it leaves FIVE standing so the
offer comes up FULL and the check stops measuring the fill-short rule. **There is no thin pool and
no hero left to relocate to**, so the refusal is written RELATIVE TO THE LIVE POOL SIZE now
(refuse everything but two), which is test_batch_bx's shape — bx was already pool-size-relative
and needed no repair at all. **A later tranche that deepened a pool would move those setups and
NOT their answers**, which is what makes this the last time they could need it. **A construction
that has to relocate is how a paid debt announces itself; one that can no longer relocate is how
a finished one does.**
**TRANCHES 2 AND 3 ARE BOTH PAID, AND THE SPEC-DEPTH DEBT THEY MEASURED IS CLOSED (Batch DG §3).**
Tranche 2 took `SPEC_DRAFT_POOLS` to 60 and every spec to FIVE (BT the Mage nine, BU the Cleric
nine, BV the Hunter nine, BW the WARRIOR nine); tranche 3 took it to 96 and every spec to EIGHT
(CB the Mage nine, CE the Cleric nine, CH the Hunter nine, CI the WARRIOR nine). **THE FOUR
CLASSES COMPLETED IN THAT ORDER — THE MAGE FIRST, THE CLERIC SECOND, THE HUNTER THIRD AND THE
WARRIOR LAST — AND ALL FOUR ARE COMPLETE.** **NO PART OF THE DRAFT IS OWED: 96 SPEC ACROSS TWELVE
SPECS AT EIGHT, PLUS 24 CLASS-WIDE ACROSS FOUR POOLS OF SIX, WAS 120 OF 120 — AND DO'S TWENTY-TWO
TOOK THE SPEC HALF TO 118 AND THE WHOLE DRAFT TO 142 OF 142, DR'S NET +1 TO 119 AND
143 OF 143, AND DS'S SIX HUNTER CARDS TO 125 AND 149 OF 149.**
**NO OFFER FILLS SHORT FOR A SPEC REASON ANY MORE** — it fills short only when a run has refused
or taken most of a pool, which is the no-return ledger working. Every draft suite's per-spec depth
loop is an INVERSION now (it asserts the FLATNESS, where each earlier tranche asserted its own
asymmetry), and **test_batch_bo's fill-short construction had to move for the THIRD time** — onto
a hero worn down by `draft_refused`, because there is no thin pool left in the game to build it
on. **BV PREDICTED THAT FORCED MOVE IN WRITING and called it the honest signal that the debt is
paid. It is.**
**THE WARRIOR POOLS WERE OWED AND ARE PAID (Batch BP) — do not re-record them as empty.** All
three were NAMED and EMPTY at BO because the lane names only arrived in BM; BP filled them with
two apiece (Berserker Blood Offering / Gut Rip, Warden Covering Guard / Eye of the Storm,
Swordmaster Precision Strike / Feint), which took `SPEC_DRAFT_POOLS` to 24 entries and gave every
spec a draft. **It stands at 96 now, and 24 is the CLASS-WIDE figure** — the two were one digit
apart in one paragraph, which is how the stale half below went unread for so long. **THE
CLASS-WIDE TRANCHE IS PAID IN FULL (Batch BQ then BR) — DO NOT RE-RECORD ANY OF IT AS OWED.** BQ
shipped six MAGE and six CLERIC; **BR shipped six HUNTER and six WARRIOR**, so `CLASS_DRAFT_POOLS`
is 24 of a target 24 and **THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY FOR EVERY HERO IN THE
GAME** — no class rolls an empty pool and no offer loses its class card.
**AND THE SNAPSHOT THAT SAT HERE IS CUT (Batch DG §3), WHICH IS THE ACTUAL FINDING.** This
paragraph used to read that the draft held sixty-six of a target 120 (Batch BU), that
`SPEC_DRAFT_POOLS` was 24 entries, and that the HUNTER and WARRIOR six were still at two — **a
BU-era snapshot sitting 49 lines below the line that already said 120 OF 120, inside one standing
block, with different answers.** **IT SURVIVED CW's SPLIT BECAUSE THAT SWEEP WAS FOR NARRATIVE
FORM AND THIS WAS NARRATIVE IN EVERY WAY BUT ITS FORMATTING** — a superseded snapshot wearing a
STANDING heading. **A STANDING BLOCK STATES A NUMBER ONCE.** Two assertions pinned phrases from
this half — `test_batch_bo` §6 and `test_batch_ce` §5 — and both are INVERTED to protect the
record of COMPLETION instead, which is the idiom BP, BQ and BR each used as a debt was paid.
**CLASS-WIDE AUTHORING RULES, recorded with the arrays so they travel with the content:**
deliberately UNTIED AND GENERAL (Magic Barrier, not Frostbolt — the test is whether it would
read as off-theme for ANY spec of that class), and **WEAKER THAN SPEC ABILITIES AND
UNCONDITIONAL** — they feed no passive, so at equal power they would be a safe default that
dilutes every build. **BQ ADDS A THIRD RULE, LEARNED BY BREAKING IT: verify the "weaker" half
against the LIVE spec kits rather than trusting the brief, AND CHECK IT AGAINST THE FREE CORE
ATTACK TOO** — Chastise is dominated by Smite, and no comparison against spec ABILITIES alone
would ever have caught it.

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
  was the only swap in the game; three copies of "flip it, restamp the chip, pay Tempo" drift.
· **TEMPO IS PART OF THE PIVOT AND NOT PART OF GUARD CHANGE**, and that is a decision: the node's
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
  Sharpshooter Tempo r5). Five more sites clear a cooldown outright through `cooldowns.erase` —
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
  Change's own 15 BD, Sunder Guard's 40-to-every-enemy, No Quarter and Tempo stay on that card, or
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
