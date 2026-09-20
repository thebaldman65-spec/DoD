# BATCH GZ — THE CHANGELOG CUT, ON TIME

**On `class-merge`, from `58b7d97` (GY). IMPLEMENT ONLY.** The fifth cut of `docs/changelog.html`,
taken at the boundary CW §4 names, **one batch after the watcher FG built asked for it** — which is
the first time this file has been cut because something measured it rather than because someone
noticed. **No rune, card, kit, engine, pool or node moved, no magnitude was retuned, and the only
`.gd` edit in the tree is five literals and two counts in `check_dv` §4.** `main` is untouched.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

**Twenty-three premises are checkable. Nineteen held, two did not, and two are true of a different
thing than the brief says.**

**HELD (nineteen).** `docs/changelog.html` measured **400,021 B** at HEAD, **21 B** over CW §4's
400,000. `check_fg` §1 printed the CEILING WARNING and read **22 checks / 0 failures** — the warning
arm and the failure arm are exactly as the brief states them, read out of the gate's own source:
over the bar **with** the newest entry is a printed warning, over it **without** the newest entry is
`ok(before <= bar)` and a red, so the cut is owed now and **HA** fails without it. CW §4's procedure —
cut at a batch boundary, move the OLDER entries, never delete, the live file never moves so
`docs/build_docs.py` keeps resolving — is in `docs/instrument-rules.md` as quoted. **FG's precedent
holds exactly**: `docs/reports/FG.md`'s table reads 435,335 B / 52 entries → **147,929 B / 17
entries**, which is 147.93 KB and 144.46 KiB, under 150 on both. **CX left 162.1 KB / 10 entries**
(`docs/reports/CX.md`). **DV left 150.0 KiB** — 149.97 to two more places, so the brief's figure is
DV's own, carried at higher precision. The threshold's unit is the rule's own word and it is
decimal; FG took the stricter reading and prints both. **A size check cannot see a misspelt word and
the byte-exact rejoin can** — proved here, not quoted (§2b). **Nothing hardcodes the archive path**:
15 readers reach it through the live file's own header, 0 by a literal path. **A bare
`contains("Batch XX")` is satisfied by a later entry naming that batch in prose, and it has happened
twice** — BZ→BB and CD→BO, both recorded in the rule; **this batch found a third instance of the
same shape and it is in a gate, not a suite** (§3). The reader population is derived and not listed
(§4). GY did find `docs/design-notes.md` in two blocks with 73 entries out of place, and *"EF forbade
that"* was retired at GR §2. `CLAUDE.md`'s ceiling did move to **410 KiB** at GY. The 52
engine-bound gates are step 6; the Crown's resistance, Sanctity's potency layer and the engine cards
are still queued.

**DID NOT HOLD:**

1. ***"The archive has grown twice."*** **It has grown three times since it was created, and not at
   all since it entered the repo.** `DoD-archive/changelog-archive.html` was created by **BZ's**
   split at BO/BP and added to by **CX** (CN/CO), **DV** (DF/DG) and **FG** (EP/EQ) — three
   additions after its creation, four cuts in total. **FH did not grow it**; FH moved the folder
   into the repo and edited one sentence of its header. **This batch is the first growth it has had
   since it became a tracked file**, which is the fact the brief's §3 is really about and is
   stronger than the one it states: every previous addition happened while the file was outside
   version control.
2. ***"`CLAUDE.md` is not touched."*** **Two live facts in it are falsified by this cut, and I
   corrected both.** See §5 — this is the one place this batch went past its brief, and it is
   flagged there rather than buried.

**TRUE OF A DIFFERENT THING:**

3. ***"FH measured it at 1,646,681 B."*** That is FH's figure for **the archived changelog alone and
   before FH's own header edit** — `docs/reports/FH.md` says so in its own premise table, and
   corrects the brief that quoted it: *"THAT IS THE ARCHIVED CHANGELOG ALONE. The folder is
   1,680,660 B."* **The file FH actually shipped is 1,646,949 B** (`git cat-file -s` at `8eb0057`,
   the only commit that file has). The 268 B is FH's header edit. The brief has inherited the
   pre-edit reading.
4. ***"FU found it held one and went red on a correct file."*** **FU's red landed on `check_fg`
   §2, not §1.** The defect was shared — both form checks were `contains()` on a whole sentence with
   its number inside — but the number that moved was `CLAUDE.md`'s ceiling, so §2 is what went red
   against a correct rule and a correct file. **§1 has never held a copy of the changelog bar and it
   does not hold one now**, which is the thing the brief asks to be confirmed, and it is confirmed
   in §2d.

---

## §1 — THE ORDER, CHECKED BEFORE THE CUT

**A cut at a batch boundary assumes the entries are in batch order.** GY found
`docs/design-notes.md` was two blocks with opposite conventions and 73 entries out of place, so the
same question was asked of the changelog **first, and answered before a byte moved.**

| the question | the answer, over all 60 entries |
|---|---|
| strictly descending by batch code? | **yes — 0 inversions** |
| dates non-increasing top to bottom? | **yes — 0 inversions** |
| every heading carries a batch label? | **yes — 60 of 60** |
| every heading carries a date? | **yes — 60 of 60** |
| any batch code twice? | **no — 0 duplicates** |

**THE CHANGELOG DOES NOT HAVE THE DESIGN NOTES' PROBLEM, AND THE REASON IS STRUCTURAL.** That file
drifted because `CLAUDE.md` said *newest first* for one and *append* for the other; the changelog has
only ever been written append-at-the-**TOP**, its own header says *"Newest first"*, and GY ruled out
the changelog-habit explanation by direction. **The cut therefore takes the set it means to take**,
and that is asserted rather than assumed: the verifier's ORDER PRESERVED arm reads the live half's
headings as the original's first 31 **in order** and the archive's newest 29 as the moved ones **in
order**.

One thing worth recording and not a defect: **the letters are not contiguous.** Over the whole
corpus — 203 letter-labelled entries running B to GZ across both halves — **four letters have no
entry at all: AM, CC, CF and GD.** A missing letter is a batch that was never written, not an entry
that went missing, and **the multiset proof below is what tells those two apart** — it compares the
headings that exist before and after, and never asks the file to be contiguous.

---

## §2 — THE CUT, AT FS/FT

**29 entries moved — Batch FS back to Batch EQ — into `DoD-archive/changelog-archive.html`.
Nothing was deleted. No entry was edited.**

| | before | after |
|---|---|---|
| `docs/changelog.html` | **400,021 B**, 60 entries (GY → EQ) | **144,740 B = 144.74 KB = 141.35 KiB**, **32 entries** (GZ → FT) |
| — without this batch's own entry | | 139,933 B = 139.93 KB = 136.65 KiB, 31 entries |
| `DoD-archive/changelog-archive.html` | 1,646,949 B, **185 entries** | **1,907,462 B**, **214 entries** (FS → Batch 1) |
| `DoD-archive/` as a folder | 1,680,660 B | **1,941,173 B** |

**This batch's own entry is 4,807 B, inside the 2,871–4,838 B range of the seven entries before it**
(GS 4,838 / GT 3,432 / GU 2,871 / GV 3,003 / GW 4,200 / GX 4,292 / GY 3,291). GY's ruling recorded
that its entry *"was not trimmed to sit under the bar"*; this one was not padded or trimmed either,
and the figure is here so that is checkable rather than asserted.

### §2a — Why FS/FT, and not one entry further

**THE AIM IN THE RULE IS *"around 150 KB"*, AND THE SHAPE TO FOLLOW IS FG's: under 150 on BOTH
readings of KB, with this batch's own entry counted.** FG's 17 entries were 147.93 KB and 144.46
KiB. Taken one entry further — keeping Batch FS, whose entry is 9,564 B — this file would have
shipped at **154,304 B = 154.30 KB = 150.69 KiB, over on BOTH readings.**
**FS/FT is the last boundary that clears both.**

| cut | left live | on both readings |
|---|---|---|
| CX at CN/CO | 162.1 KB, 10 entries | over |
| DV at DF/DG | 150.0 KiB = 153.6 KB, **16 entries** | over on KB, level on KiB |
| FG at EP/EQ | 147,929 B, 17 entries | **under** |
| **GZ at FS/FT** | **144,740 B**, **32 entries** | **under** |

**THIS CUT LEAVES THE MOST ENTRIES AND THE FEWEST BYTES OF ANY CUT ON RECORD**, because entries have
been getting shorter: the newest 7 average **3,669 B** and the newest 20 average **4,099 B**, against
the 5,863 B a batch the live file actually grew at between FG's cut and GY's crossing. **So the
headroom reads two ways and both are reported**: 255,260 B to the bar is **44 batches** at FG's own
realised rate and **62 to 70** at the rate of the last 7 to 20 entries. The honest figure is the
first one, because it is the only one measured over a whole cut-to-cut window.

### §2b — The verification, and the proof of the proof

**NO FILE SIZE IS ASSERTED ANYWHERE.** Sizes are printed beside the bar and nowhere else, for the
reason CW §4 gives and this batch re-proved: **a dropped entry and a duplicated one both move the
length, so a size check catches them — and one misspelt word inside a kept entry moves it by zero.**

The splitter proves its own arithmetic, which proves the splitter self-consistent and nothing else,
so **a second script with no code in common re-derived everything from FROZEN copies of both
original files**: a line-walk extractor instead of a byte regex, headings compared as a MULTISET,
and every body hashed individually.

| arm | result |
|---|---|
| headings counted two independent ways on all four files | 60/60, 185/185, 31/31, 214/214 — **agree** |
| counts sum | 31 + 214 = 245 = 60 + 185 |
| heading multiset identical before and after | **yes** |
| zero overlap / exactly once / none invented / none dropped | 0 / all / 0 / 0 |
| order preserved on both sides | **yes**, both halves |
| **the two bodies rejoined are BYTE-IDENTICAL to the original** | **yes**, sha256 `06f447fc…` |
| the archive's pre-existing 185 entries byte-unchanged | **yes**, sha256 `9b4a1f67…` |
| each of the 60 original entries hashed where it now lives | **60 of 60 identical** |
| both footers byte-unchanged | **yes** |

**AND THE PROOF WAS PROVED, ON THREE SCRATCH PAIRS THE REAL TREE NEVER SAW.** Each control makes
exactly one defect and each one names the arm it aims at:

| control | failures | which arms |
|---|---|---|
| **an entry dropped** from the live half | **11** | counts, multiset, DROPPED, order ×3, all three byte arms |
| **an entry in both halves** | **11** | counts, multiset, overlap, exactly-once, order ×2, byte arms |
| **one word misspelt inside a kept entry**, same length | **3** | **the byte arms alone** |

**The third is the one that matters.** `rune` → `rume` inside one kept entry leaves the file at
**139,861 B, byte-for-byte the same length**, and every heading count, every order arm and the whole
multiset read clean. **Only the rejoin sees it.** That is CW §4's rule demonstrated rather than
repeated.

### §2c — The two headers

**BOTH HALVES CARRY A HEADER NAMING THE OTHER, WITH THE COUNTERPART'S FULL PATH** — the anchor 15
readers follow. `<code>res://DoD-archive/changelog-archive.html</code>` is byte-unchanged and the
bare-filename mention still sits in front of it, which is what `find("/changelog-archive.html</code>")`
skips past. Five sentences moved, all of them in the two headers, and the entry regions were
re-hashed after each edit to prove no edit reached an entry.

**THREE OF THE FIVE WERE STALE CLAIMS THIS CUT CREATED, NOT BOUNDARY NUMBERS:**

- the live header's *"see the **Batch FH** entry below"* — **FH's entry is one of the 29 that moved**,
  so the pointer would have pointed at nothing. It now says the cut moved it.
- the archive header's *"EVERYTHING BELOW WAS WRITTEN WHILE THIS FILE WAS NOT BACKED UP"* — **true of
  everything below the Batch FH entry and false of the eleven entries above it** (FS, FR, FQ, FP, FO,
  FN, FM, FL, FK, FJ, FI), all of which this cut moved in. Scoped to *"everything below the Batch FH
  entry"*, which is the newest-first file's own way of saying *"written before FH"*.
- the archive header's recovery pointers, which end *"anything added here after that is not"* —
  **the fifth split needs no recovery pointer at all**, because FH put this file in version control
  before these entries were moved into it. Said so.

### §2d — `check_fg` §1 stops warning, and it still holds no copy of the bar

```
§1 — docs/changelog.html against the threshold the rule states
  live 144740 B = 144.74 KB = 141.35 KiB   |  bar 400 KB = 400000 B
  newest entry 4807 B; the file WITHOUT it is 139933 B = 139.93 KB
  under the bar with 255260 B = 255.26 KB of headroom
check_fg: 22 checks / 0 failures
```

**Confirmed, and confirmed the way the brief asks.** The gate's only route to the number is
`_bar_from_rule(ir, "THE THRESHOLD IS ([0-9]+(?:\\.[0-9]+)?) KB")` over
`docs/instrument-rules.md` — a pattern that finds the FORM whatever the number is, collects every
occurrence and asserts the set has one member. **No literal of the bar appears anywhere in
`check_fg.gd`**, which was checked by reading the file, not by trusting its header comment. **The
bar printed above, `400 KB = 400000 B`, was parsed out of the rule on this run** — the gate was not
edited by this batch at all.

---

## §3 — WHAT THE UNMODIFIED GATES DID, AND THE ARM THAT PASSED WHEN IT SHOULD HAVE FAILED

**The brief asks for the unmodified gates against the new tree before any of them is edited. That
run is the measurement, not a formality.**

| | |
|---|---|
| `check_fg` | **22 / 0**, warning gone |
| `check_dv` | **83 checks / 4 failures**, all four in §4 |

```
§4 — the changelog cut
  FAIL: §4: the archive holds 214 entries, not the 185 the cut made
  FAIL: §4: the live file's oldest entry, Batch EQ, is missing
  FAIL: §4: Batch EQ is in BOTH halves — the cut duplicated an entry
  FAIL: §4: the cutting batch's own entry is not in the live changelog
```

**FIVE BOUNDARY LITERALS WERE OWED A RE-POINT. FOUR BIT. THE FIFTH PASSED.**

`check_dv` §4's last boundary arm is `live.contains("Batch FG</b> at EP/EQ")`, and **it did not
fail.** The live header records **every** cut in its own history — *"Batch BZ split them at BO/BP,
Batch CX cut again at CN/CO, Batch DV at DF/DG and Batch FG at EP/EQ"* — so FG's clause is still in
the file after FG's boundary has stopped being the boundary.

**THIS IS THE SHAPE FG TOOK THE `or` OFF FOR, ARRIVING BY A SHORTER ROAD.** DV wrote
`contains("Batch DV</b> at DF/DG") or contains("Batch DV")`, and the second member was always true
because the header names every cut. FG replaced it with a pin on the cutting batch's own clause —
which asks its question **for exactly one batch** and is then satisfied by the record again. The
difference is only that it takes a cut rather than a rename to break it. `check_ec` §1 reads
alternations and would not see this one: it is a single `contains`, and it resolves.

**Re-pointed and NOT repaired** (FZ's pricing rule). The repair is a pin on the header's **last**
cut rather than on a named one, or on the boundary the header states in its opening sentence; either
one is a different arm with its own two-armed control, and that is its own batch. It is written into
`docs/instrument-rules.md` under CW §4 and into `check_dv.gd` beside the arm.

### §3a — And a needle broken by a line wrap, caught before the gate ran

The first version of the live header wrapped `<b>Batch GZ</b> at` / `FS/FT` across a newline, so the
re-pointed needle `Batch GZ</b> at FS/FT` **was not in the file** — a green-looking edit that would
have taken `check_dv` §4 red for a reason having nothing to do with the cut. **`build_pin_manifest.py`
caught it**: that pin came back `"r": "unresolved"`, the only document pin in the tree that did.
Re-wrapped, re-derived, `"r": "code"`. **The manifest is a needle instrument and it was read as one
before the gate was run.**

---

## §4 — THE READER POPULATION, DERIVED

**CX found eleven where `state.md` recorded nine and FG found fifteen, so it is derived every time
rather than carried.** Three different questions, asked separately, with GDScript comments stripped
so a mention in a comment can never count as a read:

| question | answer |
|---|---|
| **opens `res://docs/changelog.html` in code** | **17** — the 14 suites `bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, cb, ce`, plus `check_dv` §4, `check_fg` §1 and **`check_ec` §2** |
| **reaches the archive through the live file's own header** | **15** — the 14 suites plus `check_dv` §4. `check_fg` and `check_ec` never open the archive |
| **hardcodes the archive path** | **0** |
| **reads the live file by RELATIVE name, outside `res://`** | **2** — `docs/build_docs.py` (the `.docx` export, which is why the live file must never move) and `build_pin_manifest.py` (holder set) |

**EVERY ONE OF THE 14 SUITES PINS A BATCH THAT WAS ALREADY ARCHIVED** — BB through CE, all of them
moved out at BZ's or CX's cut — so **not one of them owed a re-point.** That is the whole payoff of
CD's pattern: a cut costs the suites nothing as long as they anchor on the `<h2>` and follow the
header. `check_dv` §4 is the one reader whose literals name the boundary itself, and `check_ec` §2
is the second reader of those same literals, which is the debt FG had to pay twice.

### §4a — The population nobody has ever counted: files that STATE the boundary

**THE DEBT HAS ALWAYS BEEN MEASURED OVER THE FILES THAT OPEN THE CHANGELOG. THAT IS NOT THE
POPULATION.** Swept instead for every file that **states** the boundary or the cut:

| file | what it said | how stale |
|---|---|---|
| **`README.md`** | *"This is the RECENT half only: it starts at **Batch BP** (2026-08-13)"* | written at **BZ**'s split (`06e382c`) and never re-pointed through CX, DV or FG — **three cuts and 126 batches** |
| **`README.md`** | *"changelog-archive.html, **Batch EP** back to Batch 1"* | one cut |
| **`CLAUDE.md`** | *"the changelog has been cut **four** times (BZ at BO/BP, CX at CN/CO, DV at DF/DG, FG at EP/EQ)"* | this batch makes it five |
| **`CLAUDE.md`** | *"DESELECT `DoD-archive/` — both files. It is **1,680,660 B**"* | every cut moves it; now 1,941,173 B |

**ALL FOUR CORRECTED.** **Nothing in the tree opens `README.md`** — no gate, no suite, no script —
which is the whole reason it could sit three cuts stale with a green tree every battery. *A file no
instrument reads is a file whose claims can never go red.* Written into `docs/instrument-rules.md`
under CW §4 as **sweep by the CLAIM, not by the reader.**

---

## §5 — WHERE THIS BATCH WENT PAST ITS BRIEF, AND WHY

**The brief's §4 says `CLAUDE.md` is not touched. I touched it, twice, and this is the flag.**

The reason the brief gives is the ceiling — *"Its ceiling moved to 410 KiB at GY and it reads
336.63"* — and **that instruction is followed to the letter: the ceiling block is byte-unchanged and
nothing was re-derived.** What the brief did not anticipate is that `CLAUDE.md` carries two **live
measurements that this batch's own act falsifies**: the number of cuts taken, and the archive
folder's byte size. Leaving them is not "not touching the file"; it is shipping a required read with
two false sentences in it, in the batch that made them false — and CW §4's own standing rule is that
**the cut is not done until everything the cut invalidates is re-pointed IN THE SAME BATCH.**

**The edit is +13 B and `CLAUDE.md` ships at 350,849 B = 342.63 KiB with 68,991 B = 67.37 KiB of
headroom**, both arms of `check_fg` §2 are green
and no rule, ruling or reasoning in that file moved. **If the designer wants it reverted, it is two
`sed` lines and the live figures live in this report and in `state.md` instead.**

`README.md` and `docs/instrument-rules.md` are not in the brief's not-touched list; both are in §4a
and §3.

---

## §6 — THE ARCHIVE'S OWN THRESHOLD: REPORTED, NOT RULED

**It is 1,907,462 B after this cut** — the folder, with the retired `addendum.html` beside it, is
**1,941,173 B** — and **nothing measures it.** The brief asks whether it needs a watcher of its own
and says to rule on nothing. **The honest answer is that it does not, and the reason is what the two
measured ceilings are actually for.**

| | `docs/changelog.html` | `CLAUDE.md` | `DoD-archive/changelog-archive.html` |
|---|---|---|---|
| who reads it every batch | the knowledge-base sync, 17 files in the tree | every batch, by rule | **15 files, and only ever through the live header** |
| what the ceiling protects | sync capacity | the required read's cost | — |
| **what crossing it costs** | a cut — entries MOVE and nothing is lost | a split or a re-derivation — nothing is lost | **nothing to move it to** |
| **what the answer to a breach would be** | move | split | **DELETE** |

**A CEILING IS A NUMBER WITH AN ANSWER BEHIND IT.** FG's rule is that a ceiling nobody measures gets
crossed silently, and the corollary is the one that decides this: **a ceiling nobody can answer is a
ceiling that asks for the thing the same rule forbids.** The changelog's answer is *move it to the
archive*; the archive **is** the archive, and CW §4 says ARCHIVE MEANS MOVE, NEVER DELETE in the
same block. A bar on it would have exactly one remedy and the rule already bans it.

**AND ITS TWO REAL COSTS ARE BOTH ALREADY MEASURED BY SOMETHING ELSE.** It is deselected from the
knowledge-base sync **by name**, so it costs the sync nothing at any size — `CLAUDE.md` carries the
instruction and now carries the current figure. Its repo cost is git's, and git stores it once. **It
is a different kind of file from the two that do have ceilings**: they are read, and it is only ever
reached.

**What it is owed instead is what this batch gave it: a reading, in a file something asserts on.**
The folder's byte figure now lives in `CLAUDE.md`'s sync block — which `check_fg` §2 already reads
every battery for a different number — and the file's own figure is in `state.md`. **Reported. Not
ruled, and no gate was written.**

---

## §7 — THE VERIFICATION RUN

**121 of 121 targets launched, and `check_de` — the count differ, a post-pass over this run's own
logs — reads `501 checks / 0 failures / 0 notices`.** Not one target's check count or failure count
moved against `baselines.json`, which is the measurement behind *"no baseline row moved"* rather
than an assumption about it.

**TWO REDS, AND BOTH ARE THE SANCTIONED ONES, AT EXACTLY THEIR BASELINE COUNTS:**

| target | run | baseline | |
|---|---|---|---|
| `check_cm_live` | 13 checks / **4 failures** | `fails: [4, 4]` | *"THE ONE RED THAT IS ON PURPOSE… identical on unmodified HEAD"* — the only thing pressing the defensive bar |
| `check_gj` | 70 checks / **1 failure** | `fails: [1, 1]` | the Bell's 20 gold: `the card says +158 gold and the purse moved 178` |

### §7a — `check_gj`'s figures moved since the baseline note, so it was controlled rather than argued

The note in `baselines.json` records **+169 / +189** at GS and **+172 / +192** at GQ; this run reads
**+158 / +178**. *A sanctioned red whose numbers have moved is not a sanctioned red until the
movement is attributed*, so a **two-armed isolated control** was run rather than reasoned about:
`HEADCOPY` at `58b7d97` and `NEWCOPY` at this tree, each `rsync`'d out of the repo with its `.godot`
cache, each renamed in `project.godot` so its `user://` could not reach the player's saves, and
**both seeded from a byte-identical copy of the live `user://`**.

| arm | verdict | FAIL line |
|---|---|---|
| **HEAD** `58b7d97` | 70 checks / 1 failure | `§4: the card says +158 gold and the purse moved 178` |
| **GZ** | 70 checks / 1 failure | **the same line, byte for byte** |

**The red is inherited, not caused.** The gap is still exactly the Bell's 20 gold, and the drift from
GS's figures is GT through GY's pools and kits moving what the gate's seeded run draws —
**`check_gj` names none of the seven files this batch touched**, which was checked before the control
rather than offered instead of it.

### §7b — The post-run edit, and its needle proof

This batch's changelog entry states the size of the file it is in, which is a **self-referential
figure and needs a fixed point** — it was iterated and then read back **off disk**: the file is
144,740 B and the entry says 144,740 B and 255,260 B of headroom. The entry grew 4,594 → 4,807 B
after the battery, so the four gates that read that file were re-run against the shipped tree:

| | re-run | baseline | |
|---|---|---|---|
| `check_dv` | **83 / 0** | `[83, 83]` / `[0, 0]` | §4 prints `live 32 entries (GZ..FT), archive 214 (FS..Batch 1), 0 overlapping headings` |
| `check_fg` | **22 / 0** | `[22, 22]` / `[0, 0]` | `the file WITHOUT it is 139933 B` — the failure arm's input is untouched by the entry's growth, as predicted |
| `check_ec` | **24 / 0** | `[24, 24]` / `[0, 0]` | every document pin still resolves |
| `check_ed` | **18 / 0** | `[18, 18]` / `[0, 0]` | the manifest still matches the tree off disk |

**And the player's saves are byte-identical to the backup taken before anything ran** — `profile.json`,
`relics.json`, `run_save.bin` and `settings.cfg`, all four md5-matched before the battery and again
after it.

---

## §8 — WHAT MOVED

| file | what |
|---|---|
| `docs/changelog.html` | **cut** 60 → 31 entries, header re-pointed (3 sentences), GZ's entry added → 32 |
| `DoD-archive/changelog-archive.html` | **+29 entries** 185 → 214, header re-pointed (3 sentences) |
| `check_dv.gd` | §4 — five boundary literals, two counts, and the comment block recording why |
| `pin-manifest.json` | re-derived: **exactly 4 needles changed, nothing else** |
| `CLAUDE.md` | two stale live facts (§5) |
| `README.md` | two stale claims, one of them three cuts old |
| `docs/instrument-rules.md` | two lessons under CW §4 |
| `docs/state.md` | rewritten |
| `docs/reports/GZ.md` | **NEW** |

**NOT TOUCHED:** no game `.gd`, no `.tscn`, no `data/`, no `run_battery.sh`, no new gate, **no
`baselines.json` row** — no target's check count moved, which is measured and not assumed —
`docs/master.html`, `docs/design-notes.md`, `docs/combat-rules.md` and `docs/ways-of-working.md`
byte-unchanged, proved off the start-of-batch freeze.
