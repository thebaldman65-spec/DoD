# BATCH FQ — THE VERSION GUARD, AND THE BRANCH

**NO MERGE WORK.** No spec dissolved, no pool merged, no engine became a rune, no node moved, and
**not one rune, card, ability, talent, constant or magnitude moved.** This batch built the two
things that had to exist before any of the merge starts.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

**Most held. Two did not, and one of the two is the brief's own claim about the tree.**

| Premise | Verdict |
|---|---|
| `Profile._load()` has no version branch | **TRUE** — it merges every key over the defaults and writes `data["version"] = VERSION` unconditionally, reading the old value nowhere |
| `_save()` overwrites on the next point earned | **TRUE** — `award_zone_boss_points` → `_save()`, and the designer's live profile carries twelve purses at 60–68 points |
| A scratch profile asked against a foreign tree returns `cells_spent` 0, `equipped_learned` empty, `owns_cell` still true | **TRUE** — re-derived independently, and the mechanism is that `owns_cell` never consults the tree at all |
| `run_state.gd` has the shape to copy | **TRUE, WITH ONE PART THAT MUST NOT BE COPIED** — see §1b |
| **Three files will conflict on every merge batch** | **FALSE — EIGHT do.** Measured over the last fourteen commits |
| **`git ls-remote origin main` appears in `run_battery.sh`'s own scars** | **FALSE** — that script contains no `git` call at all. The four gate files matching `git ` match it inside the word *digit* |

**FP's `block_chance` finding was re-verified rather than quoted** and it holds in every part —
with one addition the recon did not state, in §3.

---

## §1 — `Profile._load()` GETS A VERSION BRANCH

### §1a — WHAT IT DOES

**Three refusals, and not one of them writes.** A file that does not parse as a dictionary; a
version **below** `MIN_VERSION`; a version **above** `VERSION`. On any of them `_load()` returns
the defaults **without merging the file's keys**, sets a refusal reason, and **`_save()` becomes a
no-op for the rest of the session.**

- **`VERSION` is unchanged at 2.** No version was bumped; the brief forbade moving anything.
- **`MIN_VERSION := 1` refuses nothing today, on purpose.** There is nothing below it, so **no
  existing profile changes behaviour**. It is the line the merge moves: the batch that renames a
  talent id raises it, and every older profile is then refused rather than half-read.
- **The ceiling is the half that was already live.** A version-99 profile loaded clean under HEAD,
  was stamped back to 2 and re-saved at 2 — **driven, not reasoned about.**

### §1b — THE ONE PART OF `run_state.gd`'s SHAPE THAT IS DELIBERATELY NOT COPIED

**`load_run()` refuses and then calls `clear_save()`. This refusal does not delete.** A refused run
save is one run in flight and the player's alternative is starting another. **A refused profile is
every run they have ever finished** — twelve purses, a tier, a bought-cell ledger and a loadout —
so deleting it to resolve the refusal would BE the destruction the guard exists to prevent. The
file on disk is the only backup that exists, which is also why the on-screen message names its path.

**`check_fq` §4c asserts this in both directions**: behaviourally (the file is still there at the
end of the gate) and against the source (`profile.gd` contains no `DirAccess.remove_absolute`),
because the tempting repair on the day a player is stuck behind a refusal is to make it clear the
file the way `load_run()` does.

### §1c — WHAT THE PLAYER SEES

**The main menu banners it**, naming four things: the version found, the range this build reads,
**that nothing has been changed or deleted**, and the file's path.

**And `Talents` is disabled while a profile is refused.** A board with no rows is honest when the
profile is genuinely empty; on a refused profile it is a lie — it would offer cells to buy with
points that are not actually gone, spend them against a ledger that will never be written, and
show a loadout the player did not choose. **That is the same silent zero, arriving one screen
later.** `Relics` is left enabled: its tally reads zero, which is wrong but not actionable, and
the banner is on the screen the player is already looking at.

**Driven in both arms.** On a refused profile the banner is present and `Talents` is disabled; on
an accepted one **the banner is absent and `Talents` is enabled** — so neither is stuck on.

### §1d — EVERY FIELD THAT WOULD SILENTLY DEFAULT

**Derived from the live defaults dict, not quoted. The profile holds THIRTEEN keys.**

| Keyed on | Keys | What a merge does to them |
|---|---|---|
| **SPEC id** | `runs_started`, `runs_completed`, `wipes`, `forfeits`, `talent_points` | **Read 0 the moment a spec id changes.** The purse is orphaned but intact on disk |
| **SPEC id, then NODE id** | `talent_cells`, `talent_equipped` | **Where FP's three silent defaults live**, and the only two double-keyed fields |
| Nothing the merge renames | `bosses_killed`, `events_seen`, `zones_cleared`, `flags`, `talent_tier` | **Safe** — boss kind, event id, an int, flag names, a global int |
| Itself | `version` | The field with no branch, which is the batch |

**SEVEN of the thirteen are spec-keyed and TWO of those seven are keyed a second time on node ids.
FIVE are safe.** The three FP named are not three fields — they are three *accessors* over the
same two double-keyed ones:

- **`cells_spent` reads 0** because it asks `node_in_tree` per id and skips misses.
- **`equipped_learned` empties** for the same reason, one function over.
- **`owns_cell` stays TRUE** because it **never consults the tree at all** — it reads the raw
  ledger dict. That is why it is the one that disagrees with the other two.

**AND THE TOTALS SURVIVE WHERE THE PER-SPEC READS DO NOT.** `completions_total()` sums every value
in the bucket and divides by four, so it is *correct* after a spec rename while `completions_for`
returns zero. **A field that defaults to something plausible is worse than one that defaults to
nothing**, and this is the shape of it: the chronicle screen would keep reading right while every
per-spec read underneath it read zero.

**One more, found in the round trip and not in the read:** ints come back from JSON as **floats**
(`talent_tier` 3 → 3.0, `zones_cleared` 13 → 13.0). Every accessor coerces (`int()`, `clampi`), so
nothing is wrong today — **but no accessor guards the raw dict**, and a future read that skips the
coercion inherits a float.

### §1e — THE INSTRUMENT, AND WHY IT IS NOT A PARAGRAPH

**`check_fq.gd` — 46 checks.** BN's warning about the run save sat in documentation for thirty
batches doing nothing; the brief was explicit that this one gets an instrument.

- **§1 drives the branch in BOTH directions**, because **a guard that never refuses and a guard
  that refuses everything pass the same static check**. The positive arm is asserted as hard as
  the refusals and is what makes §2 non-vacuous.
- **§2 IS THE ARM THE BATCH EXISTS FOR**: the file md5-hashed across **five separate write paths**
  (`award_zone_boss_points`, `_bump`, `set_flag`, `note_zone_cleared`, a bare `_save()`), because a
  guard installed at four of the five would read as installed.
- **§3 is the lossless round trip** — twelve accessors and every key, in both directions.
- **§4b DRIVES `_save()` AS THE FIRST CALL OF A SESSION.** This is the arm I would not have written
  from the brief. `if refused: return` placed **before** `_load()` reads a flag that is still false
  on the first write of a session — **the very write that destroys the file** — and the source
  looks correct either way. **I wrote it the wrong way round first** and caught it while writing
  the comment, not while writing the code.
- **NO VERSION LITERAL IS PINNED ANYWHERE IN IT.** `docs/instrument-rules.md`'s standing rule,
  learned three times off the run save. Every arm reads `Profile.VERSION` / `Profile.MIN_VERSION`
  and pins the **relation**, so the batch that bumps either does not fail this gate for bumping it.

### §1f — THE CONTROLS

**Six, each armed on the needle it aims at, each restored by hash afterwards.**

| Control | Reds | Which arms |
|---|---|---|
| The ceiling branch removed | **11** | §1c, §1d, all of §2, §4b |
| The floor branch removed | **2** | §1b **only** |
| **`if refused` moved ABOVE `_load()`** | **1** | **§4b alone** |
| The `refused` guard deleted from `_save()` | **7** | §2a–f, §4b |
| The branch made to refuse everything | **5** | §1a's four, plus §3's vacuity arm |
| The refusal made to delete | 9 | §4c both ways — **but it also THREW**, so it is a weaker control than the other five |

**The third row is the one worth keeping.** A one-line reordering that looks correct in the source
is caught by exactly one arm and nothing else — which is both the value of that arm and the reason
it had to be driven rather than read.

**AND THE HEAD CONTROL IS HONEST ABOUT WHAT IT PROVES.** Running `check_fq` against HEAD's
`profile.gd` is a **parse error**, not a failure: the gate names `refused`, `refused_version` and
`refusal_message()`, none of which exist there. That proves the gate is genuinely new-code-bound
and **proves nothing about catching a subtly broken guard** — which is what the six surgical
controls above are for, and why they keep the API and break only the behaviour.

---

## §2 — THE MERGE GETS ITS OWN BRANCH

**The branch is `class-merge`, cut from FQ's own commit** rather than from before it — a branch
cut earlier would start the merge without the one thing built to survive it.

**Recorded in `docs/ways-of-working.md`**, which is where the brief put it and where it belongs:
that file binds what happens before and around a brief, not what a batch does with one.

**`CLAUDE.md`'s push step now POINTS at it rather than restating it** — that file's own rule about
second copies, and ways-of-working's own rule about pointing.

### §2a — THE BRIEF SAID THREE FILES. IT IS EIGHT.

**Measured over the last fourteen commits rather than predicted:**

| File | Batches that touched it | Convention |
|---|---|---|
| `docs/changelog.html` | **14 / 14** | Append-only at the top; **both sides' entries survive**, ordered by batch code |
| `docs/state.md` | **14 / 14** | **Take the branch's wholesale** — rewritten every batch, no reader |
| `CLAUDE.md` | 12 / 14 | By what a rule is ABOUT — see §2b |
| **`docs/master.html`** | **12 / 14** | **Re-derived at the merge point, not merged** — see §2c |
| **`baselines.json`** | 10 / 14 | Rows merge cleanly; **every number in an engine-bound row is a fact about a GAME** |
| `docs/design-notes.md` | 10 / 14 | Append-only. Both survive |
| **`pin-manifest.json`** | 10 / 14 | **NEVER hand-merged. It is DERIVED** — take either side, re-run the builder, `check_ed` says whether it is right |
| **`run_battery.sh`** | 10 / 14 | Both sides' `GATES` / `SUITES` entries survive — it is one array and a target is a name |

**Two of the five unpredicted ones are not documents at all**, and those are the two where a
line-level merge produces a file that looks right and is wrong.

### §2b — `CLAUDE.md`, WHICH THE BRIEF CALLED THE HARD ONE

**It reconciles by what a rule is ABOUT, not by who wrote it.** A rule naming no spec, engine or
node is **true on both sides** — instrument rules, working agreements, the verification floor — and
both sides' additions are kept. A rule that NAMES one is a claim about a game only one side has,
and at the merge point the branch's reading wins, because the branch's game is the one that ships.

**MEASURED: 54 of its 108 blocks name a spec or an engine, and 54 name neither.** A clean half.
**This is a triage and not a decision procedure** — the *Working agreement* block itself lands in
the "names a spec" half because the word *warden* appears somewhere in its body, and it is
obviously a both-sides rule. **It halves the reading; it does not remove it**, and it is written
down that way rather than as an automation that would quietly mis-file that block fourteen times.

### §2c — AND `master.html` IS HARDER THAN `CLAUDE.md`

**The brief did not name it, and it is the one entry with no line-level convention available.**
It is the single document forbidden to hold history (the designer's 07-20 rule: only what is
currently in the game). During the merge **the two sides describe different games**, so their edits
to it are not two versions of one sentence — there is no reconciliation that produces a true
document. **The branch's `master.html` is re-derived at the merge point**, and `main`'s edits to it
are read as *a list of things to check* rather than as text to keep.

### §2d — NO GATE READS THE BRANCH NAME

**Swept across `*.sh`, `*.gd`, `*.py`, `*.md`, `*.html`, `*.json`.** `run_battery.sh` contains no
`git` call at all — **the brief's claim that it carries a scar of one is false** — and the four
gate files that match `git ` match it inside the word *digit*. Live matches: **one**, `CLAUDE.md`'s
push step, now qualified. The others are closed batch reports and the changelog archive, which are
history and correct as they stand.

**Nothing asserted on that line's text** (`origin/main`, `Commit AND PUSH`, `after each change
batch` — zero readers each), so the edit could not take a suite red, and the literal sweep in §4
confirms it did not.

### §2e — WHAT IS NOT INSTRUMENTED, SAID PLAINLY

**`docs/ways-of-working.md` has ZERO readers.** No gate, no suite and no script reads it — measured
in the same sweep that found the other populations. **The rule this batch just recorded there is
enforced by nothing**, which is the same class of hazard as a ruling that lives only in a closed
report, one file over. It is not fixed here because an instrument for it would be a gate asserting
on prose, and the file's own preamble says it holds rules rather than measurements. **It is
recorded as a known gap rather than left to be discovered.**

---

## §3 — WHAT COMES AFTER, RECORDED IN `state.md`'s QUEUE

**Not done here.** The six-step running order is written into `docs/state.md`'s **queue section**
rather than its WHERE block, because that block is replaced every batch and a pointer inside it
lasts exactly one.

**FP's `block_chance` finding travels with it and was re-verified rather than quoted.** Every part
holds: `block_chance` defaults to **0.0** with no sentinel (`unit.gd:142`); the **Warden alone**
declares it at **0.10** (`classes.gd:5380`); the only other unconditional source is
`_plating_slice`, which opens `if u.passive_id == "heavy_plating"` (`battle.gd:15488`); and the
contrast is `parry_chance`'s **−1.0** sentinel against `PARRY_CHANCE := 0.05` for every hero
(`battle.gd:7777`).

**TWO THINGS THE RECON DID NOT STATE:**

- **`PROTECTED_CORES` DOCUMENTS ITS OWN HOLE.** The Warden's entry carries `"enablers": []` with
  the `why` **"Heavy Plating is a Block-chance rule; it reads no ability."** The gap is not
  something the merge will discover — **it is written in the table that has it.** So *"the enabler
  concept has to cover stats"* is a change to that table's **shape**, not to its contents.
- **ONE NODE ALREADY INSTALLS THE STAT.** `wd_mountain` (Immovable, the Plate capstone) grants
  `block_chance: 0.20` in its own payload. So a merged Warden node **can partially self-enable**,
  which makes the survivor question *"does it reach a non-zero base"* rather than *"does it name
  the engine"* — a sharper test than the one that cut three nodes at FP.

---

## §4 — VERIFICATION

**The designer's four save files were copied to `save-backups/FQ-20260909-134621/` and md5-verified
against the originals BEFORE anything else happened** — FI's convention, and this batch touches the
exact machinery.

### §4a — THE DOC EDITS WERE PROVED, NOT ASSUMED

**A literal sweep over every reader of every document this batch touched**, snapshotted against
HEAD's copy of each:

| Document | Readers | Needles | Present in HEAD | LOST | GAINED |
|---|---|---|---|---|---|
| `CLAUDE.md` | 61 | 11,937 | 1,029 | **0** | 0 |
| `docs/master.html` | 36 | 8,721 | 1,035 | **0** | 0 |
| `docs/changelog.html` | 20 | 3,498 | 224 | **0** | 1 |
| `docs/ways-of-working.md` | **0** | 0 | 0 | 0 | 0 |

**THE ONE GAINED LITERAL WAS CHASED AND IS AN OVER-REPORT OF MY OWN INSTRUMENT.**
`user://profile.json` now appears in the changelog because the FQ entry names it. Nine suites carry
that string — **every one of them as `Profile.save_path = "user://profile.json"`, a teardown
restore, asserted against nothing.** The sweep pools every literal in a reader rather than only the
ones aimed at the document, which over-reports and never under-reports. **Checked while I was
there: those nine restore the path and reset `loaded`/`data` as their last act and never call
`_save()` afterwards, so no suite writes the designer's profile.**

**AND THE ZERO IS NOT VACUOUS — A TWO-ARMED CONTROL.** The needle
`Absorbs and redirects damage; buffs the line.` — chosen **out of the needle list itself**, and one
`scripts/classes.gd` genuinely carries — was removed from the shipped `master.html` and, separately,
from HEAD's copy. **Arm A read LOST = 1. Arm B read GAINED = 1.** The sweep bites in both
directions, so the clean reading is a measurement.

### §4b — THE TREE WAS FROZEN

**369 files — tracked AND untracked**, hashed with absolute paths before the battery launched, so
that a moved working directory could not report the tree as drifted and a new untracked file could
not sit outside the population.

### §4c — THE BATTERY


**102 targets. THE ONLY RED IS THE SANCTIONED ONE.**

- **`check_fq` — 48 checks / 0 failures**, matching the row written before the run.
- **`check_de` (the count differ) — 426 checks / 0 failures / 0 notices.** Every baseline matched,
  **including both rows this batch wrote** (`check_fq` at 48, `check_parse` 177→178).
- **ZERO TARGETS THREW.** A suite that throws is not a suite that passed, and the battery reports
  the throw count beside the check count for that reason.
- **`check_cm_live` 13 / 4 — the one red that is on purpose**, and it was checked the way the
  standing rule requires: **the FAIL LINES were compared against a HEAD rebuild, not the count.**
  An out-of-repo copy of the tree with every FQ-touched file reverted to HEAD (and `.godot` and the
  `*.import` files carried across, or every `class_name` is a parse error) produced **the same four
  lines, in the same order.** Identical.
- **THE TREE WAS FROZEN ACROSS THE WHOLE RUN.** 369 files, tracked and untracked, md5'd with
  absolute paths before launch and after exit: **zero differ.**
- **AND THE DESIGNER'S SAVES SURVIVED IT.** All four files are byte-identical to the FQ backup
  after 102 targets — 24 of which delete `run_save.bin` under the census FI took. FI's repair is
  holding.

**WHAT WAS WRITTEN AFTER THE RUN, SAID PLAINLY:** `docs/state.md` and this file. **Neither is read
by any instrument** — verified with a fixed-string sweep rather than a regex (an unescaped `.` in
`state.md` matches `state_md` and over-reports), and no gate opens either path at runtime; every
hit is prose in a comment. **They were therefore outside the frozen population by choice**, which
is stated here rather than left as a gap in a "zero differ" claim.

### §4d — THE HOLE I FOUND IN MY OWN GATE, AND WHAT IT COST

**The first draft of `check_fq` was 46 checks and it could not tell a working `_save()` from a
dead one.** Every arm in §2 asserts *the file did NOT change*; §3's round trip re-reads a file it
never actually rewrote. **A `_save()` broken outright — the game silently never saving again —
satisfies all of them.**

**This was MEASURED rather than reasoned about**, in an out-of-repo copy (with `.godot` and the
`*.import` files, or every `class_name` is a parse error) so the frozen tree was untouched:
**`_save()` made inert, `check_fq` read 46 checks / 0 failures.** That is the vacuous-check shape —
an instrument that has stopped asking its question printing exactly like a clean one.

**§1g is the repair and it is two-armed:** it reds against the inert copy and passes against the
live one, which is what says it measures the repair rather than only itself. **48 checks.**

**IT COST THE FIRST BATTERY.** The run was killed at 14 of 102 rather than finished, because
finishing it would have validated a baseline row I already knew was wrong and then required a
second full run anyway. **And killing it is its own scar:** `pkill -f run_battery.sh` **did not
kill it** — the script survived on PPID 1 and moved on to the next suite while the lock was gone,
which is a battery still writing logs with nothing to show it is there. It was killed by PID, and
the process table was checked afterwards rather than the lock.

---

## §5 — WHAT IS DELIBERATELY NOT DONE

- **No merge work.** No spec dissolved, no pool merged, no engine became a rune, no node moved.
- **No spine is built.** That is the next batch, and its order is in the queue.
- **No rune, card, ability, talent, constant or magnitude moved.** No version was bumped —
  `Profile.VERSION` is still 2 and `run_state`'s is still 12.
- **NO STANDING RULE WAS WRITTEN INTO `CLAUDE.md`.** A row was added to its index table and then
  **removed**: that index lists rules that LIVE in `docs/instrument-rules.md`, and a row pointing
  at a rule never written there is the exact defect the index's own preamble names — a pin
  satisfiable by the index while the rule is absent. The batch's finding is carried by an
  instrument instead, which is what the brief asked for.
- **`master.html`'s RUN-SAVE figures are STALE and were left alone.** It says the run save is
  *format v8* and refuses *older than v8*; `run_state.gd` writes **v12** and refuses below **v10**.
  That is a false statement in the current-truth document, found while editing the adjacent profile
  block. **It is routed to the queue rather than fixed**, because correcting it is outside this
  brief's scope and the paragraph is not one §1 or §2 requires — but it is recorded here rather
  than left to be re-found.

---

## §6 — WHAT MOVED

`scripts/profile.gd`, `scripts/main_menu.gd`, `check_fq.gd` (**NEW**), `run_battery.sh`,
`baselines.json` (two rows — its own, and `check_parse` 177→178), `pin-manifest.json`,
`docs/ways-of-working.md`, `CLAUDE.md`, `docs/master.html`, `docs/changelog.html`,
`docs/design-notes.md`, `docs/state.md` (rewritten — the FP WHERE block replaced, not appended to,
and its absence checked) and this file.

**NOTHING ELSE.** No other `.gd`, no `.json` under `data/`, no other gate, and no other baseline
row. Two probe scripts were written, run and deleted before the freeze.

**The designer's four save files were copied to `save-backups/FQ-20260909-134621/` and md5-verified
against the originals before any other work**, and re-verified after.
