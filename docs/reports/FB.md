# BATCH FB — SPLIT TONGUE GOES BACK TO 20%

The designer reverted Batch FA's nerf. **The ruling followed FA's measurement rather than the
argument that set the number**, which is the shape worth naming before anything else: FA built 12%
exactly as ruled and reported that the reasoning behind it did not survive contact with the code. A
batch that had quietly patched the number instead of reporting it would have left the ruling
standing on a premise nobody could see.

**One implementation decision, one measurement, and one of the brief's own instructions declined
with the reason given.** The brief asked for two standing rules to be recorded; one of them was
already written, by FA, and writing it again is the exact second-copy fault `CLAUDE.md`'s own
preamble names.

---

## THE BRIEF'S PREMISES, RE-DERIVED

The brief says to verify every premise. **Eleven checked, nine confirmed, one FALSE, one narrower
than stated.**

| premise | verdict |
|---|---|
| `compose` floors the BUDGET at 6, not the enemy count | **CONFIRMED** — `run_state.gd:1136`, `budget = maxi(budget, 6)`, inside `compose` |
| a budget of 6 buys three power-2 enemies | **CONFIRMED as arithmetic** — `_combo_walk` accepts a composition only when `left == 0`, so the spend is exact; 8 of the 21 enemy kinds are power 2 |
| the board caps at six | **CONFIRMED** — `battle.gd:1598`, `ENEMY_LAYOUTS[clampi(composition.size(), 1, 6)]` |
| elite rosters are three enemies at tiers 1 and 4, every draw | **CONFIRMED AS FA's, NOT RE-DERIVED** — the mechanism is verified above; the 200×6 composition census is FA's and is cited as FA's |
| FA measured ×0.61 at three and ×0.79 at four | **CONFIRMED, INDEPENDENTLY** — see §2c: FB's own 20% arms times 12/20 reproduce FA's whole row |
| break-even is not reached until five | **CONFIRMED** — `N × 12 = 3 × 20` at `N = 5`, and FB's ratios put the 20% row at exactly `N/3` |
| Break moves ×1.00 / ×1.33 / ×1.67 / ×2.00 | **CONFIRMED** — measured again at §2a, and it is now the DAMAGE row too |
| the rune pays 1 Ruin a target instead of 2 | **NARROWER THAN STATED** — see §2d. The rune pays a hard `1`; the base is `_old_gods_mark()`, which is `2 + whispers_step + rune_wide_rite`. "Instead of 2" holds only at the untalented base |
| Hex of Ruin is authored at 20% against three chosen enemies | **CONFIRMED** — `classes.gd:5650`, `"damage": 20 … "choose_three": true` |
| §1's empty-loadout guard stands; Bracing Line at 32; the named constants unmoved | **CONFIRMED** — all read back unchanged, §5 |
| **"Record both in `CLAUDE.md`"** | **FALSE for one of the two.** *Run the unmodified gates against new code* is ALREADY there, authored by FA. See §4 |

---

## §1 — THE CLAUSE IS REMOVED, NOT SET BACK TO 20

**Ruled: revert. Built.**

```json
"payload": {"ability": "Hex of Ruin", "set": {"aoe": true},
            "also": [{"stat": {"rune_split_tongue": 1}}]}
```

**`data/runes.json` is now byte-identical to its Batch EZ state.** FA moved exactly one payload and
one desc in that file and both are back; `diff` against `8f21e52:data/runes.json` is empty. That is
worth stating as a property rather than as a claim — a revert that leaves a byte behind is not a
revert.

**The refused form is `{"aoe": true, "damage": 20}`.** It behaves identically today, which is
precisely why it is refused: a payload restating the card's own authored value is a second copy of a
magnitude, and it goes stale silently the day Hex of Ruin is re-tuned. **The correct form already
ships one file over.** Pandemonium — the Occultist's row-9 Madness capstone — carries
`{"ability": "Hex of Ruin", "set": {"aoe": true}, "add": {"pressure": 25}}`: it widens the target
set, it adds the Break it is about, and it says nothing about damage at all. The rune is now the
same shape as the talent that does the same thing.

**No game script moved a byte.** `scripts/runes.gd`, `scripts/battle.gd` and `scripts/classes.gd`
are unchanged; FA §1's two `is_empty()` guards stand exactly as built, and the `_gain_ruin(…, 1)`
branch that halves the mark is untouched.

### **§1a — THE ASSERTION THE BRIEF ASKED FOR IS VACUOUS AGAINST THE THING THE RULING FORBIDS, AND A CONTROL PROVED IT RATHER THAN AN ARGUMENT**

**This is the batch's most transferable finding.**

The brief's instruction was: *"keep that assertion and add its counterpart — the rune-applied
Ability must now read 20 too."* Built literally, that is one new check: apply the payload, assert
`hex.damage == 20`.

**That check passes on `{"aoe": true, "damage": 20}`** — the exact payload §1 spends a paragraph
forbidding. A gate built to the brief's own instruction would have gone **fully green** on the
defect the brief was written to prevent.

So `check_ez` §5 gains **two** arms rather than one:

- **THE SHAPE** — `set` and `add` carry no `damage` key at all. This is the ruling stated as a
  property of the payload rather than as a property of today's number.
- **THE RE-TUNE ARM, WHICH IS THE ONE THAT MATTERS** — move Hex of Ruin's *authored* damage to 33,
  apply the payload, and assert the Ability reads **33**. A rune that assigns 20 fails here; a rune
  that is silent about damage passes. **A value assertion pins a value; only this pins SILENCE**,
  and silence is what the ruling actually bought.

The arms are proved rather than argued — see §3, control B: armed with the forbidden payload the
gate reads **115 / 2**, naming the shape arm and the re-tune arm, **and the brief's own arm is not
among the failures.**

---

## §2 — WHAT THE RUNE IS NOW WORTH, AND IT IS NOT STRICTLY BETTER

**The brief predicted it probably is** — *"the Ruin halving is the only cost left — and if so, say
so."* **It is not, and the two cases where it is strictly worse are both ordinary.**

**Method.** Attack 100 for a clean denominator. Twenty casts an arm. **Each arm on its own board**,
and hp, statuses, Break and Broken reset before every cast — `ruin` and `exposed` are statuses, so
Hex of Ruin softens the board it is measuring, which is the reading FA's first pass got wrong by
0.36. **Every size run in both orders as a control**, and the two agree to within 0.05. The board is
the fixture's own three (`raider, raider, archer`) extended alternately, identical for both arms at
a given size. The probe was written, run and **deleted before the freeze**.

### **§2a — DAMAGE AND BREAK ARE NOW THE SAME RATIO, BECAUSE BOTH ARE JUST THE TARGET COUNT**

| board | dmg without | dmg with | **damage** | Break without | Break with | **Break** |
|---|---|---|---|---|---|---|
| 3 enemies | 52.4 over 3 | 52.2 over 3 | **×1.00** | 48.0 | 48.0 | **×1.00** |
| 4 enemies | 51.6 over 3 | 68.5 over 4 | **×1.33** | 47.1 | 63.0 | **×1.34** |
| 5 enemies | 51.4 over 3 | 86.5 over 5 | **×1.68** | 48.1 | 81.0 | **×1.68** |
| 6 enemies (the board cap) | 51.8 over 3 | 104.0 over 6 | **×2.01** | 47.5 | 96.0 | **×2.02** |

*Order control, the same arms run the other way round: damage ×0.98 / ×1.32 / ×1.64 / ×2.02, Break
×1.00 / ×1.35 / ×1.70 / ×2.04.*

With the damage clause gone the two meters carry the same information: the rune multiplies both by
`N/3`. **The Break side the brief called "the rune's main upside on a small board" is not an upside
on a small board** — it is ×1.00 at three, the same as the damage.

### **§2b — AT THREE ENEMIES THE RUNE IS STRICTLY WORSE THAN NOT HOLDING IT**

At exactly three live enemies, `aoe` and `choose_three` strike **the same three bodies** for the
same damage, the same Break and the same Exposed. The widening buys nothing, because there is
nothing to widen to. **The rune's only remaining effect on that board is halving the Ruin.**

| board | Ruin/cast without | Ruin/cast with | primings over 20 casts, without | with | deepest stack, without | with |
|---|---|---|---|---|---|---|
| 3 | 6.0 | **3.0** | **12** | **6** | 40 | **20** |
| 4 | 6.0 | 4.0 | 11 | 8 | 40 | **20** |
| 5 | 6.0 | 5.0 | 10 | 10 | 40 | **20** |
| 6 | 6.0 | 6.0 | 10 | **12** | 40 | **20** |

*The sustained arm: 20 casts, enemies made unkillable so the board size holds, `ruin_primed`
harvested and cleared each cast.*

**Ruin primes PER TARGET** — `_gain_ruin` reads `st % step == 0` on the struck body — so total Ruin
is the wrong denominator and depth is the right one. **The deepest stack any one enemy reaches is
halved at every board size**, 40 → 20, and that is the "1 instead of 2" showing up where it is paid.
Total Ruin breaks even only at **six**, the board cap, and even there it is spread across twice as
many bodies, which is why the priming column only crosses at six rather than at five.

**Three enemies is every elite and mini-boss draw at tiers 1 and 4** (FA's roster census) and a mean
of 3.12 at tier 8. **So the board on which the rune is strictly worse is the modal board.**

### **§2c — AND THIS REPRODUCES FA's TABLE, WHICH IS THE INDEPENDENT CHECK ON BOTH**

FA measured the 12% version at ×0.61 / ×0.79 / ×1.02 / ×1.18. FB measures the 20% version at
×1.00 / ×1.33 / ×1.68 / ×2.01. **Multiply FB's row by 12/20 and you get ×0.60 / ×0.80 / ×1.01 /
×1.21** — FA's row to within the noise on every entry, from a probe written independently on a
different tree. Two measurements taken a batch apart agree, which is worth more than either alone.

### **§2d — A SECOND STRICTLY-WORSE CASE, AND IT IS A TALENT RATHER THAN A BOARD SIZE**

**Pandemonium (`oc_hysteria`) already sets `aoe` on Hex of Ruin.** A hero holding it has the whole
line cursed before the rune is bought.

| board | dmg | Break | **Ruin** |
|---|---|---|---|
| 3 | ×1.01 | ×1.00 | **×0.50** |
| 4 | ×1.01 | ×1.00 | **×0.50** |
| 5 | ×1.02 | ×1.00 | **×0.50** |
| 6 | ×1.00 | ×1.00 | **×0.50** |

**For a hero down the Madness lane, Split Tongue is a 100g purchase that halves his Ruin and does
nothing else, at every board size.** FA's 12% made this worse still (it also cut the damage); the
revert improves it and does not fix it, because the overlap is the `aoe` flag itself.

**AND THE BRIEF'S "1 RUIN INSTEAD OF 2" IS NARROWER THAN IT READS.** The rune's branch pays a hard
`_gain_ruin(strike_target, 1)`. The base it replaces is `_old_gods_mark()`, which is
`OLD_GODS_MARK + occ.whispers_step + occ.rune_wide_rite` — **2 only for an Occultist with neither.**
A hero holding the Wide Rite rune marks 3, and Split Tongue takes him to 1: **a third, not a half.**
The two Occultist runes are anti-synergistic and nothing says so.

**No magnitude was changed on any of this.** The revert is the designer's ruling, built exactly as
ruled, and the numbers are put beside it. A magnitude is the designer's; a measurement is the
batch's.

---

## §3 — THE CONTROLS, AND ALL THREE BIT

**Every one is armed on something a target demonstrably reads, and the disarmed state was confirmed
before the armed state was trusted.**

| control | what it does | result |
|---|---|---|
| **A — HEAD's payload** | HEAD's `data/runes.json`, which **is** the FA payload, against FB's gate | `check_ez` **115 / 3** — the shape arm, the value arm and the re-tune arm, all three by name |
| **B — the forbidden payload** | `{"aoe": true, "damage": 20}` — the thing §1 refuses, which reads identically today | `check_ez` **115 / 2** — the shape arm and the re-tune arm. **The brief's own arm PASSED** |
| **C — HEAD's gate vs FB's code** | HEAD's unmodified 113-check `check_ez` against the reverted payload | `check_ez` **113 / 1** — `§5: Split Tongue takes it to 12% of Attack (reads 20)`, the predicted line and the only one |

**B is the control that earned the two new assertions**, and it is a shape this project has not
recorded before: not a check that fails to bite, but a check that bites on the WRONG THING. A and B
are the same repair armed in two directions — A says the behaviour moved, B says the gate can tell
the difference between the behaviour moving and the number being restated.

**Every file was restored from a pre-control copy and the restore was md5-verified rather than
assumed** — `data/runes.json` back to `c6444025531030a5a1ce8bb0b40e77bc`, `CLAUDE.md` back to
`e880e89f2f1bd50f5363cc366158791f`, and both targets re-run clean afterwards (`check_ez` 115 / 0,
`test_batch_bx` 161 / 0).

### **§3a — AND HEAD'S UNMODIFIED GATES WERE RUN AGAINST THE NEW CODE FIRST, PER FA's OWN RULE**

**Eighteen targets that read `data/runes.json`**, unmodified, against the reverted payload, before a
single assertion was edited: `check_ez`, `test_runes`, `test_rune_battle`, `check_es`, `check_et`,
`check_em`, `check_ea`, `check_dp`, `check_ed`, `check_parse`, and the eight `test_batch_*` suites
that open the file.

**Exactly one red, and it was the predicted one.** No unnamed dependency, where FA's equivalent pass
found three.

**THAT THE PASS FINDS NOTHING IS THE RESULT, NOT A REASON TO SKIP IT.** A rule recorded only on the
run that justified it reads as a rule about a near-miss; this is the entry that says what it costs
when it is clean — about two minutes, and it is what licensed re-pointing `check_ez` in one pass
rather than two.

**AND A COUNT THAT MOVES IS PART OF THE READING.** `test_runes` came back **3803 against a recorded
3804** in that same pass — no failure, no red, nothing in the diff pointing at it. `_int_restore`
loops `["add", "set"]` over `Runes.AB_INT_KEYS`, and `damage` was the only one of those keys the
payload carried. **That located the whole delta in one assertion before `baselines.json` moved**,
which is the difference between a baseline written off the arithmetic and one written off whatever
the code happened to do.

---

## §4 — ONE OF THE BRIEF'S TWO STANDING RULES WAS ALREADY WRITTEN, AND IT IS NOT WRITTEN TWICE

The brief's §3 asks for both of FA's findings to be recorded in `CLAUDE.md`.

**The first is already there.** `CLAUDE.md` carries **`STANDING RULE — RUN HEAD'S OWN GATE AGAINST
THE NEW CODE BEFORE RE-POINTING IT (Batch FA §1b)`** — the rule, the worked example, the cost of
skipping it, and the corollary that a re-pointed arm is checked before it is used. FA wrote it as
part of FA. **Writing it again is the second copy that file's own preamble names as what let it
contradict itself 1900 lines apart**, and the preamble is explicit that the index is headings and
not a restatement.

**So FB extends the existing block instead**, with the two things a second run adds that the first
could not: that the pass is cheap and informative when it is CLEAN, and that a moved check count is
part of its reading even when nothing fails.

**The second rule is genuinely new and is written.** It is placed directly beside the EV log rule it
generalises, because they are one shape:

> **A SNAPSHOT TAKEN MID-WAY MEASURES WHATEVER HAPPENED TO BE DONE AT THE TIME** (Batch FA §5,
> recorded at FB §3) — a before/after instrument is only as wide as its two endpoints; take the
> first before the first byte moves and the last after the last one. FA's own sweep took its second
> snapshot partway through and `docs/state.md`'s rewrite fell outside the pair, so it reported
> `LOST 0` for a file it had never compared.

**A NOTE ON WHERE IT WENT.** `CLAUDE.md`'s preamble sends rules that govern how a batch *verifies*
itself to `docs/instrument-rules.md`. Both of these are verification rules by that seam. **They are
in `CLAUDE.md`** because the brief says so, because the EV rule this one is written beside is there,
and because every instrument rule authored since the EE split (EV's, EW's, EX's, FA's two) is there
too — `instrument-rules.md` holds the 26 blocks the split moved and one DJ rule, and has not grown
since. **The seam is drifting and this batch did not correct it**; it is named here so the batch
that reconciles the two files does not have to re-derive which side the practice actually fell on.

---

## §5 — WHAT IS DELIBERATELY NOT DONE, READ OUT OF THE TREE AFTER THE BATCH

- **FA §1's empty-loadout guards stand**, both of them, in `threshold_met` and
  `breadth_met_fraction` rather than at the door — `scripts/runes.gd` is byte-unchanged.
- **Bracing Line stays at 32.** `const BRACING_LINE_LEVEL := 32`, unmoved.
- **The Shared Hide's named list stands.** The batch that extracts the hero multiplier block is the
  one that re-points that rune.
- **No constant, ability, talent or magnitude moved.** `SC_PROFILE_DEFAULT`, `CRIT_EXCESS_STEP`
  (0.50), `BOND_CONVERT` (8), `BOND_MITIGATION_MAX` (0.75), `SHIELDWALL_BLOCK` (25),
  `SS_SEQ_OPEN` (four entries) and `SS_SEQ_TAPER` (0.85) all read back unchanged.
- **No new rune is authored.** Eight specs and the class runes are still unwritten.
- **`UNSCALABLE` did not move.** `split_tongue` is still a member for `comet`'s reason, and with the
  damage clause gone its payload is a bare `set` of a flag — if anything a purer case of what the
  power arm refuses to scale. Its comment now quotes the current payload.
- **Pandemonium is not changed.** §2d is a measurement handed to the designer, not a defect a batch
  corrects.

---

## §6 — THE INSTRUMENTS

**THE LITERAL SWEEP, AND ITS FIRST ENDPOINT IS A COPY OF THE WHOLE TREE.** FA's sweep had a gap —
its second snapshot was taken partway through, so `state.md`'s rewrite sat outside the pair. FB
closes it by procedure rather than by care: **a 390-file `rsync` of the tree was the batch's first
action, before a single byte moved**, and every document is diffed against that copy.

The needle population is **every string literal of four characters or more written anywhere in the
`.gd` corpus, with backslash escapes RESOLVED**, format-bearing literals separated out so they do
not inflate the denominator, extracted by a char-by-char scanner rather than a regex (`'` and `"`
are both handled and neither eats the other — the masking hole this project has paid for twice).
**The population is the UNION of the before and after corpora**, because a batch that writes new
assertions legitimately grows it: **10,934 needles from 125 `.gd` files before, 10,960 from 126
after, 10,960 in the union.**

**AND THE SWEEP WAS ARMED BOTH WAYS BEFORE IT WAS BELIEVED.** A green sweep over prose nothing reads
is indistinguishable from a green sweep over prose everything reads. The needle was chosen **out of
the needle list**: `"PARTY" IS RETIRED FROM PLAYER-FACING TEXT`, broken in `CLAUDE.md`, and

- the sweep read **LOST 1**, naming it; and
- `test_batch_bx` §4b went **red** — `§4b: CLAUDE.md still carries the standing rule this check
  keeps`.

**The needle is written with ESCAPED QUOTES in the suite** (`"\"PARTY\" IS RETIRED…"`), so a plain
grep of the source for the resolved text finds **nothing** — only an escape-resolving extractor sees
it. That is the hole the resolution step exists to close, demonstrated on a live needle rather than
asserted. `CLAUDE.md` was restored and md5-verified and the suite returned to 161 / 0.

**THE RESULT: LOST 0 IN EVERY DOCUMENT A TARGET OPENS.** `CLAUDE.md` LOST 0 / GAINED 0,
`master.html` LOST 0 / GAINED 0, `changelog.html` LOST 0 / GAINED 2, `design-notes.md` LOST 0 /
GAINED 1, `baselines.json` LOST 0 / GAINED 2, `data/runes.json` LOST 0 / GAINED 0, and the six other
tracked surfaces unmoved.

**`docs/state.md` READS LOST 12 AND THAT IS THE REWRITE, PROVED HARMLESS TWO WAYS.** The twelve are
FA's WHERE block replaced by FB's, in the one document whose contract is that it is rewritten every
batch. **Nothing opens it**: all ten mentions of `state.md` in the `.gd` corpus are inside comments,
and no `FileAccess`, `_src`, `load(` or `open(` call in any script names it — re-derived here rather
than inherited from FA. **And every one of the twelve still lives in at least one document that IS
read** — `THE ABILITY DRAFT` in `CLAUDE.md`, `master.html` and the changelog (and
`test_batch_bo` §6's assertion, the one FB armed its own control on, reads `master.html`, which is
LOST 0); `loadout_condition_met` in four documents; `CRIT_EXCESS_STEP` in three. The empirical half
is stronger than either: the battery ran on the rewritten `state.md`.

---

## §7 — THE VERIFICATION RUN

### **§7a — THE FREEZE**

An md5 stamp of **390 files, absolute paths, tracked AND untracked**, taken before the run and
re-taken after it over **the same path list**. A relative-path stamp is worthless here — a moved
working directory between the two reads the whole tree as drifted — and a list built from
`git ls-files` alone would have missed anything untracked, which is how a report file has escaped a
freeze before. **The measurement probe was deleted before the stamp was taken rather than after**,
so it is not in the tree and does not appear as `check_parse` residue.

**ZERO DIFFER.** 390 files stamped before, 390 re-stamped after over the same absolute path list,
and the two are identical. **The path list itself was re-derived after the run and is the same 390
paths** — nothing appeared and nothing vanished, which is the half a digest comparison alone cannot
see.

**Nothing was repaired while the battery ran.** There was nothing to repair: the run was clean on
pass one.

### **§7b — THE BATTERY**

**93 targets. `sort .ran | uniq -d` → ZERO duplicates**, 93 names and 93 logs compared both ways.
**0 `Parse Error`, 0 `SCRIPT ERROR` and 0 timeouts across all 93 logs**, swept by grepping every log
FILE rather than by reading any target's own tally — a suite that throws is not a suite that passed,
and an exit code says nothing about either.

| target | result |
|---|---|
| `check_ez` | **115 / 0** |
| `test_runes` | **3803 / 0** |
| `test_rune_battle` | 97 / 0 |
| `check_es` | 44 / 0 |
| `check_et` | 24 / 0 |
| `check_ek` | 46 / 0 |
| `check_parse` | **167 / 0** — the probe left no residue |
| `check_ed` | 18 / 0 |
| `check_dv` | 83 / 0 |
| `check_ec` | 23 / 0 |
| `check_de` (the count differ) | **382 / 0 / 0 notices** |

**Two lines in the run are not `fails=0`, and neither is a fault:**

- **`check_cm_live` 13 / 4** — the sanctioned red, against a recorded `fails: [4, 4]`. **The lines
  are compared, not the count**: *the bar appeared on the enemy's attack*, *the bar's top line names
  the incoming blow*, *the brace lands near x0.85*, *the brace's Break half lands near x0.75* — the
  four its row names, and **this batch moved no game script**, so nothing in that area could have
  changed.
- **`check_cl_width` `checks=? fails=?`** — its baseline row carries `checks: null, fails: null`. It
  reports no readable count by design, which is what its row records.

**AND THE COUNT DIFFER IS NOT VACUOUS ON THE TWO ROWS THAT MOVED**, which matters because a baseline
edited to match whatever the code happens to do is worse than no baseline:

```
  check_ez                    115 checks /   0 failures   (recorded 115 / 0)   obs 3/3
  test_runes                 3803 checks /   0 failures   (recorded 3803 / 0)   obs 3/9
  92 of 92 recorded targets swept, 0 off their recorded line
```

**Both rows were written BEFORE the battery**, off three identical standalone readings each, with
the delta counted off the diff rather than guessed — `check_ez` +2 as §5's shape arm and re-tune
arm, and `test_runes` −1 as the single `_int_restore` assertion Split Tongue's removed `damage`
field no longer creates.

### **§7c — THE POST-RUN EDITS ARE TWO AND BOTH ARE NAMED**

Only two things were added to the tree after the battery: **`docs/state.md`'s §7 bullet** (the run's
own numbers, which could not exist before the run) and **this report**. **Neither file is opened by
any target** — §6 re-derives that for `state.md`, and no `.gd` file in the corpus names
`docs/reports/` at all. The claim about the run itself is the first stamp pair, not a later one:
**zero differ across all 390 while the battery was running.** The literal sweep was re-run after
both edits and reads **LOST 0** in every document a target opens.

---

## §8 — WHAT MOVED

**NO GAME SCRIPT, ONE TABLE, ONE TARGET AND FIVE DOCUMENTS.**

- **`data/runes.json`** — Split Tongue's payload loses `"damage": 12` and its desc loses the
  sentence naming it. **Byte-identical to `8f21e52` (Batch EZ) afterwards**; no other entry moved.
- **`check_ez.gd`** — **113 → 115.** §5's `damage == 12` arm becomes `== 20` (no count change),
  plus the shape arm and the re-tune arm.
- **`baselines.json`** — two rows, `check_ez` 113 → 115 and `test_runes` 3804 → 3803, each with its
  arithmetic in the note. **Twelve lines changed**: the file is `indent=1` and was edited
  surgically.
- **`CLAUDE.md`** — one rule **added** (the snapshot rule), one **extended** (FA's gate rule, with
  FB's clean run and the moved-count corollary). Nothing deleted.
- **`docs/changelog.html`**, **`docs/master.html`** and its stamp, **`docs/design-notes.md`**,
  **`docs/state.md`** (the WHERE block rewritten, not appended to), and this file.

**`scripts/runes.gd`, `scripts/battle.gd`, `scripts/classes.gd`, `scripts/talents.gd` and
`scripts/unit.gd` are byte-unchanged.** This batch changed one JSON value, one JSON string and one
gate.

---

## §9 — WHAT IS OWED, AND TO WHOM

**TO THE DESIGNER — one question, with two measurements under it.**

**Split Tongue is not strictly better than not holding it, and the brief expected it would be.** It
is **strictly worse at three enemies** — the same targets, the same damage, the same Break, and half
the Ruin — and three enemies is every elite and mini-boss draw at tiers 1 and 4. It is **strictly
worse at every board size for a hero holding Pandemonium**, whose capstone already sets `aoe`. It is
strictly better only at six, the board cap.

**That is a question about what the rune should COST rather than about what it should do.** The
widening is real and it is worth `N/3` on two meters at once. What it is priced in — a Ruin halving
that is worth nothing when the board is already three, and worth nothing but harm when the talent
tree has already widened the card — is the part the measurement says to look at. **Nothing was
changed on this finding.**

**AND THE WIDE RITE INTERACTION IS NEW AND IS OWED WITH IT.** The rune pays a hard 1 Ruin; the base
is `2 + whispers_step + rune_wide_rite`. A hero holding the Wide Rite rune marks 3, and Split Tongue
takes him to 1 — **the two Occultist runes fight each other and neither text says so.**

**NOT OWED, AND SAID SO:**

- **Nothing about §1 is open.** The clause is gone, the file is back to its EZ bytes, and the gate
  asserts the SHAPE and the re-tune, not just today's number.
- **The base Hex of Ruin is untouched and asserted so**, on the live Ability, before the payload.
- **`choose_three` is still pinned as surviving-and-dead** on the rune's version; that assertion was
  not touched.
- **The `CLAUDE.md` / `instrument-rules.md` seam is named at §4 and deliberately not corrected.**
