# BATCH FI — NO TEST WRITES THE PLAYER'S SAVE

*2026-09-07. Full working. `docs/state.md` carries the summary; this file carries the evidence.*

**The ruling is taken structurally.** A harness process cannot reach `user://run_save.bin` any
more — not because every target remembers to swap a path, but because there is no way to obtain a
`Run` that has not already decided which file it writes. **No rune, card, ability, talent, constant
or magnitude moved, no new rune was authored, and no file under `scenes/` was touched.**

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

The brief asked for every premise to be verified. Six were, and two needed correcting.

| premise | verdict |
|---|---|
| the 24 spawning targets that touch the save | **right for what it measured, wrong for what it was used for** — see §1 |
| FH found 24 of 80 by behavioural census | **TRUE**, and reproduced name for name |
| BN documented that a battery wipes the save; the guidance has been "back it up first" | **TRUE** — `docs/instrument-rules.md`, in the SUITES AND THE HARNESS block |
| `check_ct` §2 restores the save with a passing arm and §3 destroys it again | **TRUE** — `check_ct.gd:213` asserts it, `check_ct.gd:220` spawns the battle that eats it |
| a wrapper is bypassed by running one gate alone | **TRUE**, and it is why the redirect is a property of the process |
| a boss trophy does not award a rune (FH's correction) | **TRUE**, unchanged |
| **`Profile.save_path` is swapped by 37 of 39 suites' `_run` preamble** | **FALSE — it is 39 of 39** |
| *(and `docs/state.md` said 38 of 39)* | **also FALSE — 39 suites assign it** |

**ON THE `Profile.save_path` COUNT.** 39 suites have a `func _run()` body and **all 39 assign
`Profile.save_path`**; one more file does too (`test_run_harness.gd`), so the population is 40
files. The sets are not identical — `test_runes` has `_run()` and no swap, `test_batch_bm` has the
swap and no `_run()` — which is how both the brief's "37 of 39" and this file's predecessor's "38"
came about. **33 of the 39 swap it back**, and 38 carry the `_had_save` block. The brief's
"2 that do not" do not exist.

---

## §1 — THE POPULATION, RE-DERIVED BY OBSERVATION

**The brief said not to take 24 from it, and it was right to.**

### THE METHOD

Every one of the **98 battery targets** — with **no candidate predicate in front of them** — was
run **alone** against a fresh copy of the designer's real **62,360 B** run save, restored before
each target, with the save hashed after each. The battery's own flags and per-target timeouts were
copied exactly (`--fixed-fps 12` for `test_batch_bl`, 600 s for `check_map`, `DOD_GATE=1/2/3` for
the harness, the two scene targets as scenes).

**AND `Run`'s FOUR SAVE FUNCTIONS WERE INSTRUMENTED TO PRINT**, so the CALLS were counted and not
only the residue. The instrumentation was seven `print` lines and nothing else: stripping every
line containing the marker reproduced HEAD's `run_state.gd` **byte for byte** (md5
`fa31768670d33f9cce49b6d9764ad8ee` both ways), which is the proof that the census measured HEAD's
behaviour and not the instrument's.

### THE READING

| | |
|---|---|
| targets censused | **98** (FH censused 80) |
| **destroy the player's save at least once** | **67** |
| …of which also WRITE it | 11 |
| end with the file ABSENT | **25** |
| **destroy it and put it back before exiting** | **42** |
| READ it through `Run` (existence or contents) | **67** |
| …of which read its CONTENTS through `load_run()` | 3 — `test_batch_ah_battle`, `check_ct`, `check_eg` |
| never reach the save machinery at all | 21 |

### AGAINST FH's 24 — THE TWO READINGS RECONCILE EXACTLY

**FH's 24 is reproduced NAME FOR NAME: every one of them ends with the file gone here too, and
nothing in FH's list failed to.** The difference is one addition and one framing.

- **THE ADDITION IS `test_batch_ah`.** FH derived its candidates as *"reaches a spawn or sets
  `sim_run`"* — 80 of 98 — and `test_batch_ah` does neither. It calls `run.new_run()`, and
  `run_state.gd:465` calls `clear_save()` from inside it. It destroys the save, restores nothing,
  and was never in the 80. **FH's own transferable lesson was "derive the candidates from the
  source, then measure every member of it"; the correction is that THE DERIVATION is the step that
  fails silently.** FI censused all 98 and derived nothing.
- **THE FRAMING IS THAT AN END-STATE CENSUS CANNOT SEE A TARGET THAT PUTS IT BACK.** 67 destroy
  it; 43 carry a restore mechanism; 42 therefore end byte-identical and read as harmless. The
  arithmetic closes: **24 that never restore + 1 that restores and then destroys it again = the 25
  that end absent**, and the 43 restorers were derived independently, from the source, by grepping
  for the backup block rather than by subtraction.
- **THE ONE THAT RESTORES AND STILL ENDS ABSENT IS `check_ct`**, which is exactly the cautionary
  case the brief named, arriving as a measurement rather than as a reading.

### AND THE READS, WHICH THE BRIEF ASKED FOR SEPARATELY

**67 targets read the player's save through `Run`**, and **43 more read it directly** — the
`_had_save = FileAccess.file_exists(REAL_SAVE)` line at the top of the copied preamble, which is a
target depending on state it does not own. Three read its **contents**: `check_ct` and `check_eg`
each read a save they had just written, and `test_batch_ah_battle` round-trips one. All three are
repaired in §2; the rest went out with the preamble.

---

## §2 — THE MECHANISM

### THE SHAPE, FOLLOWED RATHER THAN REINVENTED

`Run.SAVE_PATH` **stays a `const` and stays the player's file**, because three gates read it to
mean exactly that. The four file operations moved onto **`Run.save_path`**, a var — the shape
`Profile.save_path` has had since Batch 40 — and `Run._init()` points it at `Run.TEST_SAVE_PATH`
(`user://run_save_harness.bin`) for any process that is not the shipped game.

```
func save_path_is_harness(args, main_scene) -> bool:
    return DisplayServer.get_name() == "headless" or argv_is_harness(args, main_scene)
```

**THE THREE SHAPES WERE MEASURED, NOT ASSUMED.** The engine strips `--headless`, `--path` and
`--quit-after` from `OS.get_cmdline_args()`; it does not strip `--script` or a positional scene.
A `--script` target reads `["--script", "check_fi.gd"]`, a scene target reads
`["res://check_ct_map.tscn"]`, and a player reads neither. An explicit launch of the project's
**main** scene is excluded by name, so `godot --path . res://scenes/main_menu.tscn` is a player.

**WHY THE PLAYER'S PATH IS OPT-IN RATHER THAN THE TEST PATH BEING OPT-OUT.** The failures are not
symmetrical. A test that forgets to opt out destroys a real run and says nothing — the symptom is
silence. A player's build that failed to opt in shows an empty Continue button, which is visible in
one second and destroys nothing. **The cheap failure is the one the default should produce.**

**THE KNOWN COST, STATED.** Running a single NON-MAIN scene from the editor (F6) now resolves to
the harness path, so an in-progress run is not offered on that screen. F5 — play project — is
unaffected. That is the false positive, and it is the recoverable direction.

### §2a — `_init()` AND NOT `_ready()`, WHICH A BATTERY FOUND AND NO READING WOULD HAVE

The first draft did this in `_ready()`. It was verified by probe, it worked, and **a full battery
run destroyed the designer's save anyway.**

**TWENTY-FOUR TARGETS NEVER USE THE AUTOLOAD.** They `load("res://scripts/run_state.gd").new()`
and drive the instance directly — a node that is never added to a tree, so `_ready()` never fires
and the instance kept the player's path. `test_batch_ah` and `test_batch_an`, the two suites that
end with the file gone, are both of them. `_init()` runs on `.new()` and on the autoload alike, so
**there is no way to obtain a `Run` that has not decided.**

**THIS IS ALSO WHY A STANDING RULE NEEDED CORRECTING.** `docs/instrument-rules.md` said *"Autoloads
(`Run`) do not resolve in a `--script` SceneTree at all — a test that needs one must be a SCENE
run."* Measured: `/root/Run` is **absent during `_initialize()` and present after the first
`process_frame`, with `_ready()` already run**. The IDENTIFIER does not resolve at parse time; the
NODE exists. Every gate's `root.get_node("/root/Run")` depends on the second fact, and so does
this batch.

### §2b — THE COPIED BACKUP PREAMBLE IS GONE FROM ALL 41 FILES

38 suites and 3 gates (`check_ea`, `check_eg`, `check_eh`) carried the same block, in exactly two
shapes; `check_ct` had an inline variant and `check_fh` a file-based one.

**IT IS NOT MERELY REDUNDANT NOW.** The restore is `FileAccess.open(REAL_SAVE, WRITE)` followed by
`store_buffer`, and **the open TRUNCATES**. A process that died between those two calls left the
player's save at **zero bytes**. **A backup that can destroy what it protects is worse than no
backup** — and under HEAD that branch had barely ever executed, because the first suite in the
battery deleted the save and every later suite therefore read `_had_save = false`.

`check_ct` and `check_fh` **keep their assertions and change their subject**: from *"the restore
this section performed worked"* to *"the player's file was never opened at all"*. `check_ct` gains
a paired arm (113 → 114); `check_fh`'s count is unchanged at 161, both arms still unguarded.

**DZ's COPIED-HELPER ITEM IS HALF-CLOSED.** The save-backup half of the `_run` preamble no longer
exists anywhere. **The `Profile.save_path` swap in 39 suites is untouched and still owed.** The
same mechanism would close it in about six lines of `profile.gd` — and it is deliberately not done
here, because seven battery suites do NOT swap it and would newly get a scratch profile instead of
the designer's, which is a behaviour change to seven suites and belongs to its own batch.

### §2c — `check_fi.gd` IS NEW, AND IT IS THE INSTRUMENT THE RULE NEVER HAD

**27 checks.** A rule with no instrument is a note, and this one had been a note since BN.

- **§1** the redirect fired in this process; the const still names the player's file.
- **§2** `run_state.gd`'s four file operations go through the var and none is left on the const.
- **§3** the resolver in **both** directions — two harness argvs TRUE and two player argvs FALSE.
  It calls `argv_is_harness` rather than re-implementing it: every process that could run the
  assertion is headless, so the real entry point short-circuits before it reads an argument, and a
  copy of those four lines in the gate would pass on the day the real ones changed. **That is why
  the resolver is split in two.**
- **§4** the destruction path **driven**, on a battle spawned by `gate_fixture` — the same fixture
  that made 67 targets destructive. **Two-armed:** arm one points the writes at a surrogate and
  `clear_save()` destroys it; arm two runs the same two calls on the same battle and the surrogate
  comes back byte-identical while the harness path moves instead. **The surrogate is not the
  player's file**: a control that proves a repair by damaging the thing the repair protects has
  understood neither.
- **§5** every `.gd` in the tree swept for the player's path, **`CHECKED 130 of 131` printed**, one
  file exempt by name. **The needle is read off `Run.SAVE_PATH` rather than written down**, so the
  gate cannot be the first thing its own sweep finds — the usual repair for that, an exemption
  naming the gate, is what blinds a rule to a real offender arriving in the exempted file later.
- **§6** the player's own file hashed before and after, **both arms unguarded**, so the count
  cannot depend on whether the machine has a run in progress (FH measured 160-vs-161 on that).

**ITS OWN FIRST DRAFT BROKE FH §2's STANDING RULE.** §2's four needles arrived through a loop
variable, so `build_pin_manifest.py` could not see them: the manifest went **1417 → 1417** and the
only thing that noticed was `--check`. Written out against a `:=`-bound holder they are six pins
and the manifest is **1423**.

---

## §3 — WHAT WAS DELIBERATELY NOT DONE

- **The other five FH findings stay open**, ranked by the designer; the hero sheet's 27 do-nothing
  buttons is still the one flagged next.
- **`Profile.save_path` is not made structural** — §2b says why, and it is now a one-batch job.
- **No rune, card, ability, talent, constant or magnitude moved. No new rune was authored.**
- **One stale figure corrected in passing.** `docs/design-notes.md` still carried FH's first,
  superseded measurement — *"`check_da` and `check_cs`, measured by bisection"*. FH corrected that
  number in five documents and missed this one. **A superseded number survives wherever the sweep
  was a sweep for the NEW figure rather than for the old.**

---

## §4 — VERIFICATION

**THE DESIGNER'S SAVE WAS COPIED ASIDE AND VERIFIED BY HASH BEFORE ANYTHING ELSE** — four files to
`DoD/save-backups/FI-20260907-100744/`, each md5-matched against the original — and re-verified
after every battery and every control. **It is byte-identical at 62,360 B,
`beabe9e03f5f27de9f3e264716208ad0`.** It was needed twice.

**DOCUMENTATION WAS WRITTEN BEFORE THE VERIFICATION RUN.** `docs/state.md` and this file are
written after it and nothing asserts on either.

### BASELINES, WRITTEN BEFORE THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS EACH

| target | | |
|---|---|---|
| `check_fi` | **NEW at 27 / 0** | three readings of 27 / 0 |
| `check_parse` | **172 → 173** | a new battery target raises the gate whose count IS its coverage |
| `check_ct` | **113 → 114** | §2's save arm re-pointed and paired |
| `pin-manifest.json` | **1417 → 1423** | six pins, all from `check_fi` §2 |

### HEAD'S UNMODIFIED INSTRUMENTS AGAINST THE NEW CODE, BEFORE ANY GATE WAS EDITED

**The two reds it found are the two that were predicted in writing beforehand**, and nothing else:
`check_ct` and `check_eg`, both holding `run.SAVE_PATH` in a local across a `save_run()` that now
writes elsewhere. **All 46 suites green.** The prediction file also named what would stay green and
the hazard to watch, which is what caught §2a: the run destroyed the save, the backup put it back,
and the investigation found the 24 `.new()` targets.

### THE CONTROLS — SIX, AND SIX BITES

| control | injection | result |
|---|---|---|
| A — the repair, two-armed | `test_batch_ah` against HEAD's `run_state.gd`, then FI's | **ABSENT** / **byte-identical** |
| B — `_init()` is load-bearing | move the redirect back to `_ready()` | save **ABSENT** again |
| C — §5's corpus sweep | put the player's path literal in `check_eb.gd` | §5 **FAILS**, naming the file |
| D — §2's needles | put one file operation back on the const | §2, §4 and **§6** all fail |
| E — §3's player arms | make `argv_is_harness` answer TRUE for everything | both player arms **FAIL** |
| F — the redirect itself | delete the `_init()` body | §1's two arms **FAIL** |

**CONTROL D DESTROYED THE SAVE AND `check_fi` §6 SAID SO** — *"the player's run save is NOT as this
gate found it"*. That is the instrument reporting its own damage, which is the strongest evidence
available that §6 is not decorative.

### THE DOC EDITS, PROVED BY NEEDLE SWEEP

Every string literal of 4 characters or longer in each of the **59 doc-reading targets** was tested
against six documents as they stood at HEAD and as they stand now — **88,368 (needle, document)
pairs**. **ZERO LOST.** 29 GAINED, every one checked against the pin manifest and against whether
its target opens that document at all: **none is pinned, and none is used negatively.**

### THE ACCEPTANCE RUN

**THE TREE WAS FROZEN ACROSS IT: 403 files md5-stamped with ABSOLUTE paths before and re-compared
after — ZERO drift, none appearing or vanishing.** The freeze covered **tracked AND untracked**
files, so `check_fi.gd` was inside the population it was meant to protect; a `git ls-files` freeze
would have left the batch's own new gate out of it.

| | |
|---|---|
| targets | **99** |
| **`Parse Error` / `SCRIPT ERROR`, grepped from the log FILES** | **0 / 0, across all 99 logs** |
| suite failures | **0**, all 46 green |
| `check_de` | **406 checks / 0 failures / 0 NOTICES** |
| `check_fi` | **27 / 0** |
| `check_parse` | **173 / 0**, RESIDUE 4 |
| `check_ct` | **114 / 0** |
| `check_fh` | **161 / 0** |
| `check_ek` | **46 / 0** |
| run harness | **22 / 166 / 8** |
| `check_ct_map` | **83 / 0** |
| the only red | **`check_cm_live` 13 / 4 — its recorded baseline** |
| **the player's run save afterwards** | **62,360 B, `beabe9e03f5f27de9f3e264716208ad0` — byte-identical** |

**`check_de` READ 406 / 0 / 0 WITH ZERO NOTICES**, so every count in the tree matches its baseline
exactly. Its own +4 came from the new baseline row and was predicted; it has no row of its own and
excludes itself by name.

**NO RED WAS REPAIRED WHILE A BATTERY RAN.** The two reds pre-pass A found were repaired between
runs; pre-pass B and the acceptance run were both clean from the first pass.

**THE ONE ASSERTION THAT MATTERED.** The brief said the only assertion that counts here is running
the whole battery against a known save and confirming the file is byte-identical afterwards, and
that it is exactly what nobody had. **It ran, and it is.** It is also the third independent reading
of the same thing this batch: the census restored it 98 times, pre-pass B left it untouched, and
control A showed HEAD destroying the same file that FI leaves alone.

---

## §5 — WHAT A LATER BATCH SHOULD NOT RE-DERIVE

- **AN END-STATE CENSUS CANNOT SEE A TARGET THAT PUTS IT BACK.** 24 versus 67 is the whole distance
  between measuring the residue and measuring the act.
- **AND THE CANDIDATE PREDICATE IS PART OF THE POPULATION.** FH's lesson was *"derive the candidates
  from the source, then measure every member"*; the correction is that **the derivation fails
  silently**. FI derived nothing and ran all 98.
- **`_init()`, NOT `_ready()`, FOR ANYTHING AN AUTOLOAD MUST DECIDE ONCE** — twenty-four targets
  construct `Run` by hand, and a node that never enters a tree never gets `_ready()`.
- **THE AUTOLOAD IDENTIFIER AND THE AUTOLOAD NODE ARE TWO DIFFERENT FACTS.** Only the identifier is
  unavailable under `--script`.
- **A BACKUP THAT TRUNCATES BEFORE IT RESTORES IS A DESTRUCTION PATH.** 41 files carried one.
- **THE `Profile.save_path` HALF OF DZ'S ITEM IS STILL OPEN**, and the mechanism to close it now
  exists. Seven battery suites do not swap it, so closing it changes their behaviour: its own batch.
