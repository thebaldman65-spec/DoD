# Batch GC — six rules whose facts moved, and a ruling recorded before it is built says so

*Branch `class-merge`, from `fce040c` (GB). `main` is untouched. Documents only: no source, data, suite, gate,
`baselines.json` row or `pin-manifest.json` pin moved.*

## NEEDS A RULING

1. **PLAYER-FACING: LONG DRAW'S CARD IS TRUE AT ONE STAGE OF FOUR.** The card: *"His basic attack runs one EXTRA press at
   every stage — but the added press buys no widening, so the sequence is harder to hold."* The profile takes its
   opening widening off the press count **with the rune's press included** (`SS_SEQ_OPEN[mini(presses, 4) - 1]`), so
   below 150 Focus the added press does buy the widening the table gives the longer chain, and the table was solved to
   make a longer chain exactly as easy to hold. On `check_cs`'s own model the chain holds as well or marginally better
   with the rune at three stages of four, and is harder only at 150+ (96.0% against 98.8%). The table is §2b.
   **Two fixes exist and they are different rulings:** the card's words (say the cost is at the top stage), or the
   rune's shape (make the added press take no widening at every stage). Rune content is written with the designer, so
   neither was taken.
2. **A SEVENTH RULE WHOSE FACTS MOVED UNDER IT — REPORT-ONLY, THE SAME SHAPE AS GB's SIX.** `CLAUDE.md`'s EN §4 block is
   headed *"A RELIC SETS UP THE RUN; A TALENT CHANGES WHAT A SPEC DOES IN A FIGHT"*, and its first rule bullet reads
   *"If the effect must be read while a turn resolves, or must know which spec the hero is, it is a TALENT."* Since FX a
   talent is a stat payload every class buys and every hero of the class wears, may not touch a passive or an engine,
   and must pay every class, so an effect that must know the spec cannot be a talent. One clause of that block was
   updated for FX (*"since FX the tree keys to the CLASS"*); the rule was not. `docs/master.html`'s relic paragraph
   carries the same sentence. **Found by §3's census** (§3f).

## THE SHORT VERSION

- **§1 — FOUR RULES RETIRE, EACH MARKED AS HISTORY.** BH §2's fifteen-point block is deleted and BM §2's block says where
  it went; BA §1 loses the clause reserving the Survivalist's tree; CN's never-authored relic exception is deleted, not
  made conditional; the second copy of CQ §1 leaves `docs/instrument-rules.md`, and its one extra sentence moves home.
- **§2 — THE CAP IS FOUR, AND A RUNE MAY RAISE IT; A BATCH MAY NOT.** CS's reason is quoted and re-read against EY's
  bar: it was a reason about difficulty, and on the project's own model the capped chain now lands 98.8% of the time,
  so the difficulty-at-four half is outgrown. A nine-press chain still lands 49.5%, so the cap keeps the BOUND.
- **§3 — `RULED, NOT BUILT` IS A CATEGORY.** The rule is in `CLAUDE.md`'s file-purpose block. **Before anything was
  marked, a census read 881 claims resting on a merge ruling** across the five documents that state the present and
  the game's own source. It found ten of FT's shape; eight are marked, one went with §1, and one is left unmarked with
  its reason. It found **138** pointing the other way: eleven close here, the rest are queued.
- **§4 — DEFLECTION STANDS**, with GB's sweep recorded beside the ruling in `CLAUDE.md`'s name-sweep block.
- **§5 — NOT DONE, AS RULED.**
- **§6 — THE DOCUMENT EDITS WERE PROVED BEFORE THE BATTERY**: a literal sweep over every edited document, each changed
  region read as prose, and the document gates run standalone at their rows.
- **VERIFICATION** is below, written after the acceptance run.

## §0 — THE BRIEF'S PREMISES

Each was checked against the repo, the reports and the code before anything was edited.

| # | Premise | Verdict | What the record says |
|---|---|---|---|
| 1 | *"On `class-merge`."* | **HELD** | HEAD was `fce040c` (GB), equal to `origin/class-merge` by `git ls-remote` before anything moved |
| 2 | *"Documentation only, except where §5 finds a category"* | **READ AS §3, AND IT DID NOT FIRE** | §5 lists what is not done and finds no category; §3 is the section that makes one. Read that way, the exception would cover a code comment stating an unbuilt ruling. §3's census swept the game's source for exactly that and found none to mark, so the batch is documentation only |
| 3 | GB *"found 521 stale claims of 2,764 — 19%"* | **HELD** | GB §4a: 223 gone + 94 moved + 204 figure = 521 of 2,764 (18.85%) |
| 4 | BH §2's fifteen points *"is still written as a live rule"* while BM §2 records its retirement at FX | **HELD** | `CLAUDE.md` carried BH §2's block as a standing rule, with three caveats, 146 lines below BM §2's *RETIRED WITH ITS SUBJECT AT FX* |
| 5 | BA §1 reserves *"the Survivalist's tree"*; *"No spec tree exists"* | **HELD** | `scripts/talents.gd` holds one `TREE` of 27 and no `LANE_TREES`; FX deleted the twelve |
| 6 | *"No such relic has ever existed in `relics.gd`"* | **HELD** | `relics.gd`'s five commits add no hook that touches the bar; its live code names no `skill`, `sweep`, `sc_profile`, `presses` or `riskier` |
| 7 | *"the bar-swap relic was discussed at CW"* | **NOT AS STATED** | The clause was written at **CN** (`8c3c676`, `CLAUDE.md` and CN's changelog entry). CW's report asks the per-hero question and never mentions a bar. **CX** is where a bar-swapping relic is discussed — its design note gives it as the reason per-hero relics are right. It was never authored, which is the premise that matters, and that holds |
| 8 | `instrument-rules.md` carries *"a near-verbatim second copy"* of CQ §1 | **HELD, WITH ONE DIFFERENCE** | The copy lacked `CLAUDE.md`'s four suite names, `_defensive_brace` and `check_cm_live.gd`, and carried one sentence `CLAUDE.md`'s did not: *"Any future headless modal will hit this."* That sentence moved home with the deletion, so nothing unique was lost |
| 9 | CS says *"CAPPED AT FOUR … DO NOT RAISE IT"* | **HELD** | `CLAUDE.md`'s sequence block, and the reason beside `SS_SEQ_MAX_PRESSES` in `battle.gd` |
| 10 | *"The Long Draw rune raises the count and the cap by its own figure"* | **HELD** | `_sequence_presses` is `clampi(1 + rune + Focus/50, 1, SS_SEQ_MAX_PRESSES + rune)`; `long_draw_press` is live and writes `rune_long_draw_presses` 1 |
| 11 | *"GB named the rune under the rule without re-ruling it"* | **HELD** | The sentence entered `CLAUDE.md` at `fce040c` (`git log -S`) |
| 12 | *"The sweep went 0.72 → 1.00"* | **HELD** | EY; `SC_PROFILE_DEFAULT["sweep_time"]` reads 1.00 |
| 13 | *"FT measured the Sharpshooter's four-press opening window at 97.3% of the track with a 6.9 ms miss band at each end"* | **THE FIGURES HOLD; THE BATCH IS EY** | EY §1b: opening `good_half` 0.4867, so 97.3% of the track, and a miss band of 0.0133, 6.9 ms of his 520 ms pass. `docs/reports/FT.md` carries neither figure; `docs/state.md`'s skill-check item quotes them as EY's |
| 14 | *"If CS's reason was about difficulty"* | **IT WAS** | CS's words: *"an ability a player without the reflexes simply cannot use"*, on an uncapped chain. §2 re-reads it |
| 15 | FT §1 says Focus *"is the Hunter's"*, and only the Sharpshooter carries it | **HELD** | `CLAUDE.md`'s FT §1 block; `battle.gd` assigns `second_resource_name = "Focus"` under `if spec == "sharpshooter"` and nowhere else; `SPEC_INFO` still holds twelve specs |
| 16 | *"the class cores, the engine runes, the enabler rule, the pool merge, the twelve-purses fold"* | **HELD AS THE PROPOSAL'S PARTS** | `docs/merge-recon.html`'s *THE PROPOSAL THIS MEASURES* names all five, and `docs/state.md`'s running order stages them. **The fold is BUILT** (FX, MAX, Profile v3); **the class cores are machinery on nobody**; the other three are ruled and waiting |
| 17 | *"GB found 195 stale claims in `CLAUDE.md` where the brief named three"* | **HELD IN SUBSTANCE** | GB §4a: 76 + 41 + 78 = 195 in `CLAUDE.md`. GB's brief named three claims across three files, one of them in `CLAUDE.md` (the index rows) |
| 18 | *"FZ found two in `instrument-rules.md` where GA found eighteen"* | **HELD** | GA §3 |
| 19 | Deflection *"clashes with none of 746 names across ten populations"* | **HELD** | GB's table: 227 + 21 + 50 + 98 + 8 + 27 + 25 + 127 + 156 + 7 = 746, ten populations; no exact, contained or shared-word hit |
| 20 | *"it is the precedent node's own name and the field's name"* | **HELD** | `sm_composure` was *Deflection*; `unit.gd` declares `var deflection` |
| 21 | *"it is already what the read site's log line prints"* | **HELD** | `battle.gd`: `→ Talent: Deflection — %s turns the shot aside` |
| 22 | *Parry Ranged Blows* *"near-misses five, including the glossary's own term Parry"* | **HELD** | GB's table: the glossary term *Parry* (contained), the abilities Crushing Blow and Mocking Blow, the node Parry More, the status Parry Up |
| 23 | *"The five player-facing items stay queued. The quit/resume skip is next"* | **HELD, THE COUNT UNSETTLED** | `docs/state.md` labels three GB findings PLAYER-FACING (the victory text, *Tier N of 10*, the glossary's item entry) and the quit/resume skip sits beside them unlabelled; GC labels it now. Which fifth the brief counts is not recoverable from the tree, and none of them moved |
| 24 | The skip *"may predate the merge entirely"* | **CONSISTENT WITH THE CODE, NOT DRIVEN** | The sites the finding rests on read the same on `main`: `map_screen.gd`'s visited reads (the two branches differ by 7 lines in that file) and `load_run`'s clearing of the pending encounter sit at the same lines |
| 25 | §5: the crit nodes, Heal More When Low, We Do Not Break, the relic redirect | **HELD** | Untouched; `Relics.SAVE_PATH` is still a `const` |
| 26 | §5: *"No spec dissolves, no pool merges, no engine becomes a rune, no spine is attached"* | **HELD** | `unit.gd`'s three `*_active` switches default false and nothing in `scripts/` or `data/` assigns one |
| 27 | §6: *"~35 suites assert against `CLAUDE.md`"* | **31 BY ITS PATH** | The literal sweep's reader census: 14 gates and 17 suites open `res://CLAUDE.md` |
| 28 | *"this batch edits six rules in it"* | **FIVE IN `CLAUDE.md` AND ONE IN `docs/instrument-rules.md`** | BH §2, BA §1, CN, CS and FT §1; and the CQ §1 copy |
| 29 | *"… and the stamp"* | **READ AS `docs/state.md`'s *Last rewritten*** | `docs/master.html` is not edited: nothing a player can meet changes, and its §4.2 cap prose is base-mechanics text by that document's own convention (it names 13 of the 60 live runes, and not Long Draw). The FU §0 reading |

## §1 — FOUR THAT RETIRE

**Where the thing a rule describes is gone, the claim is deleted rather than updated, and the deletion is said where a
reader will meet it.**

- **BH §2's fifteen points under leave-one-out.** The whole block — the rule and its three caveats — is deleted. BM §2's
  block, whose heading already names *"BH'S FIFTEEN POINTS"* and which has said *"RETIRED WITH ITS SUBJECT AT FX"* since
  FX, now also says that BH §2's own block stood further down as a live rule until GC deleted it, where its text is
  (the file as GB left it, `fce040c`), and that BI §1's rule, which the third caveat pointed at, stands on its own.
- **BA §1's reservation of the Survivalist's tree.** The rule keeps its point — a disease spec is planned, and nothing
  self-propagating is authored into an existing spec until it is built — and loses only *"into the Survivalist's tree,
  or"*, with one sentence saying so. `test_batch_ba` §1's two pins (`CONTAGION`, `self-propagating`) still read.
- **CN's relic exception.** *"TWO DELIBERATE EXCEPTIONS, BOTH OPT-IN"* is now *"ONE DELIBERATE EXCEPTION, AND IT IS
  OPT-IN"*, the Sharpshooter, with one sentence recording that a second was named from CN and never authored and was
  deleted rather than kept as a conditional. **And one pointer**: the Long Draw rune, which lengthens his chain, is
  sanctioned where the cap is, in the sequence block. Without it CN's rule would now read *"a fixed offset rather than a
  slope"* beside a bought rune that makes his deepest chain harder — the contradiction §2 exists to close, re-opened one
  block up.
- **The instrument-rules copy of CQ §1.** Deleted. Its place holds one line saying the bot guard is a rule of
  `CLAUDE.md`'s *Working agreement* and is kept there only. The copy's one sentence the original lacked, *"Any future
  headless modal will hit this"*, is appended to the original, so the deletion lost nothing.

**Every other copy was swept** (EH §2's rule), and none needed an edit: design notes and comments that cite BH's grid
narrate history; `docs/systems-recon.html` names the relic and already says it does not exist (a recon is regenerated,
never hand-edited — queued); `battle.gd`'s comment at the guard is the implementation, not a copy of the rule.

## §2 — THE CAP IS AMENDED, AND ITS REASON IS RE-READ AGAINST EY'S BAR

**The amendment, in `CLAUDE.md`'s sequence block:** *the cap is four, and a rune may raise it; a batch may not.* Long Draw
is named as the sanctioned exception, with its cost: at the top stage its five-press chain opens at the four-press row,
because `SS_SEQ_OPEN` has four rows and is deliberately not extended.

**CS's reason, found and quoted** — CS's own changelog entry, and the comment CS left beside `SS_SEQ_MAX_PRESSES`:
*"Focus has no ceiling, so an uncapped rule makes 400 Focus a nine-press sequence with a tightening window on his
most-used action — an ability a player without the reflexes simply cannot use."* **It is a reason about difficulty, and
about an UNCAPPED chain.** Its last sentence is the half the amendment keeps: *"Four is the ceiling; Focus keeps climbing
and the sequence does not."*

**Why a rune is permitted where a batch is not:**
- **A batch that raises `SS_SEQ_MAX_PRESSES` lengthens every Sharpshooter's most-used action for every player at once**
  — CN's *a spec a player can lose access to through no fault of their build*.
- **A rune is the build.** Bought per hero, per run, declinable, and written with the designer one rune at a time.
- **It raises the cap by its own fixed figure**, so the chain still does not follow Focus. A rune that raised it by an
  amount read off Focus would be the uncapped rule again, and the amendment says so.

### 2a. Whether EY's slower bar changes the reasoning — it outgrew it at four and not past it

`check_cs`'s own model (timing error Gaussian with SD 60 ms; the chain lands when every press lands its Good window;
windows from the live constants), reproduced to the printed digit of `check_cs` §4 at one to four presses and extended
past the cap:

| presses | Focus held | lands at 0.72 | lands at 1.00 |
|---|---|---|---|
| 1 | 0–49 | 89.7% | 97.7% |
| 2 | 50–99 | 90.0% | 98.5% |
| 3 | 100–149 | 90.0% | 98.7% |
| **4 — the cap** | 150+ | 90.0% | **98.8%** |
| 5 | (200+, uncapped) | 79.9% | 96.0% |
| 6 | (250+) | 65.7% | 90.2% |
| 7 | (300+) | 49.1% | 80.1% |
| 8 | (350+) | 32.9% | 66.0% |
| **9 — CS's example** | (400+) | 19.5% | **49.5%** |

- **At the cap, the difficulty half is outgrown.** The capped chain lands 98.8% of the time and opens across 97.3% of
  the track. Nothing in the amendment rests on four being hard.
- **Past the cap, it holds**, because every press is 85% of the one before and the table has four rows: the windows
  shrink geometrically and nothing widens them. The slower bar moved the collapse about two presses deeper (below 90% at
  the seventh press rather than the fifth) and did not remove it. **CS's own example, nine presses at 400 Focus, still
  lands half the time.**
- **So the amendment keeps the bound and drops the difficulty-at-four** — the brief's *"the amendment should not
  preserve a justification the game has already outgrown"*, applied to the half that is outgrown and not to the half
  that is not.

### 2b. And Long Draw's own card is true at one stage of four — under NEEDS A RULING

`_sharpshooter_basic_profile` picks the opening widening off the press count **with the rune's press included**. Below
150 Focus the added press therefore buys the widening the table gives the longer chain; only at the top stage is there
no row to give:

| Focus | presses, bare → with the rune | lands bare (1.00) | with Long Draw (1.00) | at 0.72, bare → with |
|---|---|---|---|---|
| 0–49 | 1 → 2 | 97.7% | 98.5% | 89.7% → 90.0% |
| 50–99 | 2 → 3 | 98.5% | 98.7% | 90.0% → 90.0% |
| 100–149 | 3 → 4 | 98.7% | 98.8% | 90.0% → 90.0% |
| **150+** | **4 → 5** | 98.8% | **96.0%** | 90.0% → **79.9%** |

- **At three stages of four the chain is, on the model, as easy or marginally easier to hold with the rune**, because
  `SS_SEQ_OPEN` was solved to hold a longer chain flat. The card's *"the added press buys no widening"* is true at 150+
  Focus only.
- **`check_ez` §5 asserts the cost at 300 Focus and nowhere else**; its per-stage arm checks only that a press is added.
- **EZ §3c priced the cost on CS's 0.72 rates** (89.7 / 90.0 / 90.0 / 90.0) although EY had moved the bar to 1.00 the
  batch before. At the live bar the top-stage cost is 2.8 points on the model, not 10.1.

## §3 — `RULED, NOT BUILT`: THE CENSUS FIRST, THEN THE MARKS

### 3a. The population, and the rulings it was read against

**The brief's five names are the merge proposal's parts**, and a named list cannot audit itself, so the census read
every claim resting on ANY merge ruling since FP — not only those five — in the five documents that state the present
(`CLAUDE.md`, `docs/state.md`, `docs/instrument-rules.md`, `docs/ways-of-working.md`, `docs/master.html`) and in the
game's own source. History (the changelog, design notes, reports) and the recons (regenerated, never hand-edited) are
outside it.

| ruling | built today? |
|---|---|
| The twelve specs dissolve into four classes | **no** — twelve specs are live |
| Each spec's passive becomes an engine rune; a hero is guaranteed one early | **no** — no engine rune exists |
| An engine's enabler travels with its rune (and the enabler concept covers stats) | **no** |
| The three spec draft pools of a class merge into one, and the rune pools with them | **no** — pools are keyed by spec |
| One core engine per class: Focus (Hunter), Momentum, Channel, Sanctity | **machinery built on nobody (FT–FV); attachment no; Focus is the Sharpshooter's** |
| The engine-reading runes and cards re-homed; the 52 engine-bound gates rewritten | **no** |
| One talent tree of 27, keyed to the class; the line; a cell bought is worn | **yes** (FX, GB) |
| Twelve purses fold into four by MAX | **yes** (FX, Profile v3) |
| The branch; the Profile version guard | **yes** (FQ) |
| The spine rates and doors | **yes, on nobody** (FU, FV); Sanctity's potency half **no** |

### 3b. The census came first, and it read HEAD

Thirteen read-only agents took fourteen slices of a frozen snapshot of HEAD — md5-equal to the repo's HEAD — so no
mark could shape the population. Every row carries a verbatim quote, the ruling it rests on, a verdict and the code
evidence. **Every total below is computed from the per-slice counts by a script that refuses a slice whose verdicts do
not sum to its rows.**

| document | rows | true today | unbuilt, stated as built | already marked | unsure | the other direction |
|---|---|---|---|---|---|---|
| `CLAUDE.md` | 319 | 223 | 6 | 15 | 9 | 66 |
| `docs/state.md` | 243 | 159 | 2 | 38 | 6 | 38 |
| `docs/instrument-rules.md` | 10 | 7 | 0 | 0 | 0 | 3 |
| `docs/ways-of-working.md` | 10 | 7 | 2 | 1 | 0 | 0 |
| `docs/master.html` | 220 | 182 | 0 | 7 | 3 | 28 |
| the game's source (`scripts/*.gd`, `data/*.json`) | 79 | 63 | 0 | 10 | 3 | 3 |
| **all** | **881** | **641** | **10** | **71** | **21** | **138** |

*The source is 54,739 lines and was swept by a vocabulary of 27 terms with every hit read in context, not read whole;
the hit counts per term are in the agent's return. The documents were read line by line.*

### 3c. The full list: ten claims of FT's shape, and what was done with each

| # | where (HEAD) | the claim | what is true | done |
|---|---|---|---|---|
| 1 | `CLAUDE.md` 465 | CN: *"… and the relic that swaps a hero's bar for a riskier one while held"* | No such relic has ever existed | **deleted** with §1 |
| 2 | `CLAUDE.md` 1712 | FT §1: Focus *"is the Hunter's"* | Only the Sharpshooter carries Focus | **marked** |
| 3 | `CLAUDE.md` 1712–1713 | *"Momentum (Warrior), Channel (Mage) and Sanctity (Cleric) … were built at FT"* | Their machinery was; no class holds one | **marked** |
| 4 | `CLAUDE.md` 1772–1773 | *"A slower rate … moves every Warrior further from the target"* | The meter fills on every hero today; only its payout is unattached | **left unmarked** — the sentence is about the meter's depth, which is built, and names no payout. Borderline, and said so |
| 5 | `CLAUDE.md` 1898 | governor row: *"momentum (Warrior spine)"* | No Warrior holds it | **marked** |
| 6 | `CLAUDE.md` 1905 | governor row: *"sanctity_events (Cleric spine, …)"* | No Cleric holds it | **marked** |
| 7 | `docs/state.md` 100 | FW's edge 3: *"THE CLASS SPINES … Momentum, Channel, Sanctity and Focus … all four read universal traffic"* | As class spines all four are unbuilt; Focus builds off his own attacks and cards | **marked**, and Focus's traffic corrected |
| 8 | `docs/state.md` 634 | *"AN ENGINE RUNE CARRYING HEAVY PLATING INSTALLS A CLIMB ON A BASE OF ZERO"* | No engine rune exists | **marked**, and re-tensed *would install* |
| 9 | `docs/ways-of-working.md` 165 | *"every engine-bound row measured on the branch is wrong for `main` and the reverse"* | Those rows read the same on both branches until the engines move | **marked** |
| 10 | `docs/ways-of-working.md` 171–172 | *"A rule that NAMES one is a claim about a game only one side has"* | True of a node since FX; of a spec or an engine only once they dissolve | **marked** |

**Six say a class core is attached (2–7), three describe the engine move as done (8–10), and one named a relic that was
never authored (1).** None is in `docs/master.html` or in the game's source. The marker appears five times in
`CLAUDE.md`, three in `docs/ways-of-working.md`, and in `docs/state.md` on its two rows and in the lines this batch
wrote.

### 3d. Already marked — 71

The largest group is FT's machinery described as *on nobody* (in `CLAUDE.md`'s FT block, `unit.gd`'s banner and
`battle.gd`'s read sites), the running order's steps 3–6, *"no spec dissolves, no pool merges, no engine becomes a
rune"*, Sanctity's unbuilt potency half, and two pre-FP rulings of the same shape that were already marked unbuilt:
**per-hero relics** (ruled at CX) and **the rung-2 ladder** (ruled after EP). **Those two are the precedent for the
category; GC names it, it did not invent it.** One of them sits in `docs/master.html` (§3f).

### 3e. Unsure — 21

Each needs a reading the tree cannot settle, and none was acted on. Among them: whether BA §1's planned disease spec
survives the dissolve; whether *"POISON … STAYS ENTIRELY THE SURVIVALIST'S"* survives the pool merge; whether *"the next
pool is authored against this rule"* means before or after the rune-pool merge; *"a class meter"* in the RESOURCE tag's
text (`TAG_INFO`, pinned by `check_el` §2), when no class meter is attached; `battle.gd`'s *"his own engine"* at
Momentum's third read site; and FQ's reason for the Profile guard (*"every merge batch touches talent ids"*), which the
one tree has partly overtaken.

### 3f. The other direction — 138, and what is queued

**The census found the opposite fault nearly fourteen times as often: text still describing what the merge has already
moved.** It is not this category, and the brief ruled this category and not those rules, so eleven were closed where
GC was already editing and the rest are queued in `docs/state.md` under *FOUND AT GC AND NOT FIXED*:
- **Closed at GC (11):** the six rows of BH §2's block and the Survivalist's tree (§1); and in `docs/state.md`, the heading
  *"THE CLASS MERGE IS MEASURED AND UNRULED"* (the file's own running order says the merge was ruled at FQ), FP's
  *"the ruling is the designer's"* beneath it, and FP's *"one pool, one tree and one stat line simultaneously"* with its
  pilot's *"salvaged out of 81"*, which FX's tree-alone merge overtook.
- **`CLAUDE.md` (66):** deleted nodes, lanes, rows and capstones cited in rules — FX's block tells the reader to take each
  as the record and GB kept them on that ground — **and EN §4's rule, which is not a citation and is under NEEDS A
  RULING.**
- **`docs/master.html` (28):** the talent-point economy in §2, §3 and §5 still reads as it did before BM; a builds-with
  cell names the Poise lane; Harvest is said to sit in the Hunter class pool; *"the talent trees"* is plural in three
  places; and the per-hero relic ruling appears as unbuilt, a plan in the one document that holds none.
- **`docs/state.md` (38):** the Loyalty item and a block that declares *"NONE OF IT IS STALE"* still price deleted nodes;
  `Talents.LANES` and the lane-build sim policy are cited as live; DN §8 is called open though DO ruled it.
- **`docs/instrument-rules.md` (3)** and **the source (3, all wording).**

### 3g. The rule, and where it lives

**`CLAUDE.md`'s file-purpose block**, because the rule is about what that file states: the designer's three sentences,
then four bullets — the marker is the exact phrase beside the claim; the batch that builds the thing takes the marker
off in the same batch (a marker that outlives its build is this fault pointed the other way); FT §1 is the worked
example, with the census; and `docs/master.html` never carries it. **`docs/ways-of-working.md` points at it** for the
brief that transcribes a ruling, and adds only the upstream half: a brief that states a ruling in the present tense
hands the batch the same false fact. It does not restate the rule (`check_fr` §2's no-second-copy check was reproduced
on the edited file before it was written).

**The category has no instrument, and that is queued rather than built.** A gate could assert, per marked claim, the fact
that makes it unbuilt, so the day one is built the gate reds and says the marker is owed its removal. The brief is
documentation only, and a gate is a judgement about what to pin that the next batch to touch a core is better placed to
make.

### 3h. What the census could not do, and one fault in its own brief

- **My census brief listed Channel's *spell damage = not physical* among the built rulings.** It is implemented
  (`CHANNEL_SPARES_PHYSICAL`), and FT, FU and FV all call it still owed a ruling, which is what `docs/state.md` says. The
  agents read it the repo's way; nothing was marked on the strength of my wording.
- **The source sweep is keyword-driven**, with its vocabulary printed; a claim in words none of the 27 terms reaches
  would not be in it.
- **The 21 unsure rows are unsettled by construction.**

## §4 — THE NODE'S NAME STANDS

**Deflection is confirmed, and the sweep is recorded with the ruling** in `CLAUDE.md`'s name-sweep block (BR §1), beside
the other name rulings that block carries, so the name is not revisited:
- it met **nothing** in **746 names across ten populations** — no exact, no contained and no shared-word hit;
- it is the precedent node's own name (`sm_composure`) and the field's (`deflection`), and it is what the read site's
  log line prints;
- **the designer's own label, *Parry Ranged Blows*, near-misses five**: the glossary term *Parry*, the abilities Crushing
  Blow and Mocking Blow, the node Parry More and the status Parry Up.

`docs/state.md`'s FY §1 item, which carried *"a name proposed for the designer to confirm"*, now carries the ruling. No
string in the game moved: `talents.gd`, the glossary and `master.html` already say *Deflection*.

## §5 — NOT DONE, AS RULED

The five player-facing items stay queued and the quit/resume skip is next, as its own batch; `docs/state.md` now labels
it PLAYER-FACING and NEXT. The three crit nodes, Heal More When Low and We Do Not Break stay. The relic redirect stays
deferred. No spec dissolves, no pool merges, no engine becomes a rune, and no spine is attached. **No node, rune,
magnitude or game behaviour moved**: §2 amends a rule about the cap, and the cap is where it was.

## §6 — THE DOCUMENT EDITS, PROVED BEFORE THE BATTERY

**Six documents moved** (`git diff --stat`: `CLAUDE.md` 113 lines, `docs/state.md` 161, `docs/changelog.html` 56,
`docs/design-notes.md` 43, `docs/instrument-rules.md` 11, `docs/ways-of-working.md` 9), and nothing else.

- **Every edit was a script that asserted its facts against the code before writing, with every anchor count-checked.**
  One refused and wrote nothing: the §3 script expected at least six markers in `CLAUDE.md` and the edits place exactly
  five, because the rule's bullets name the marker without repeating it. The assertion was tightened to exactly five and
  the run repeated.
- **The literal sweep** — every string literal of four characters or more in every `.gd` file, both quote styles,
  24,882 distinct needles over 140 files, raw, lowered and flattened — against HEAD's copy of each edited document.
  Every needle that moved and whose owner opens that document was settled at its read site: *Binding Oath* in
  `test_batch_aw` is checked against `battle.gd`, not `CLAUDE.md`; *choices* in `test_batch_bo` is an event key; *null*
  and *, was* are message fragments; *Crushing Blow* and *Mocking Blow* in `bq`/`br` sit in kept records compared
  against nothing live; and *§3: `* in `check_es` is an assertion message (the gate reads `docs/state.md` only through
  its "2+ threshold" window, which the rewrite asserted unmoved). **No needle a reader holds was lost or gained.**
- **Every changed region was printed as flattened prose and read.** One of my own sentences was wrong and was fixed
  before the battery: the first CN pointer described Long Draw as *"not widening the press it adds"* — the card's own
  claim, which §2b shows is true at one stage of four.
- **The document gates, standalone on the finished tree:** `check_ec` 23 / 0, `check_ff` 55 / 0, `check_fg` 22 / 0,
  `check_fr` 25 / 0, `check_es` 57 / 0 — each its row, no `Parse Error`, no `SCRIPT ERROR`. **`build_pin_manifest.py
  --check` reads current at 1,460 pins**, so no regeneration is owed.
- **The census snapshot was taken before the first edit** and md5-checked against HEAD, and the §3 marks were applied
  only after all fourteen slices had returned.

## VERIFICATION

**The acceptance battery ran over the finished tree — every document edit in place, nothing edited after — with the
predictions written first.** GC moved no source, data, suite or gate, so **the run is also the pre-pass the brief asks
for: HEAD's unmodified gates and suites against the new tree.** No target needed repairing, so no instrument was edited
and no second run was owed.

- **The run:** all 108 targets through `run_battery.sh`, 11:47:40 → 12:34:07 (46 m 27 s), exit 0. `.ran` is one
  ascending sequence of 108 names with no duplicate. No Godot process was in `ps` before the launch or after it — the
  rows were read, not counted.
- **The predictions: every one of the 107 `baselines.json` rows at its row** — the harness at 22 / 382 / 8 with no
  throws, `check_map_screen` COMPLETE, `check_ct_map` 83 / 0, `test_batch_an` 6054 in [6046, 6063], `test_batch_bk` 130
  in [128, 130].
- **`check_de`: 449 checks / 0 failures / 0 notices.**
- **`check_cm_live`: 13 / 4, the sanctioned red, its four FAIL lines identical to GB's character for character**,
  compared against GB's acceptance log, copied before this batch began.
- **The document readers, inside the battery:** `check_ec` 23 / 0, `check_ed` 18 / 0, `check_ff` 55 / 0, `check_fg`
  22 / 0, `check_fr` 25 / 0, `check_es` 57 / 0 — each the reading it gave standalone before the run. `check_fg` prints
  `CLAUDE.md` at 314,927 B = 307.55 KiB, 32.45 KiB under its 340 KiB ceiling, and the changelog at 313,248 B, 86,752 B
  under its 400,000 B bar.
- **`check_cs` §4 printed the model rows §2a quotes** — 97.7 / 98.5 / 98.7 / 98.8% at one to four presses — and read
  104 / 0.
- **`check_fx` §4b's Deflection drive printed GB's table unchanged**: the melee blow takes 7 / 8 / 8 / 9 health with the
  node and without it; the ranged blow takes 28 / 31 / 30 / 33 without it and the parried figure, with one turned-shot
  line, with it — on all four classes.
- **Parse:** 0 `Parse Error` lines across the 108 logs, read off the logs and never off a tally or an exit code; 0
  `SCRIPT ERROR` lines.
- **The freeze:** every file in the repo — tracked, untracked and ignored, 486 files — and the four player saves were
  hashed before the launch and after the run: 490 lines, identical byte for byte. The saves also hash the same as GC's
  own backup (`save-backups/GC-20260913-110157/`), taken before anything moved, and as GB's: `profile.json`
  `b05e329b…`, `run_save.bin` `c44d45da…`, `relics.json` `fdc12ffa…`, `settings.cfg` `0c1b39c3…`.
- **One file was written after the run: this report.** No gate or suite reads `docs/reports/`, and it was outside both
  freeze stamps by construction — it did not exist when either was taken.
