# Batch JF — the cut, the read-outs, and the verification put right

**On `class-merge`, after JE (`4b8763d`, JE's commit). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `4b8763d0`, JE's push and local HEAD, before anything ran (2026-11-02 17:36). **The designer's files were backed up first** (`../save-backups/JF-20261102-173640`, byte-identical to JE's by `diff -r`) and read only through copies; md5s at the open and the close, §5.

**What shipped.** **No game code and no data moved**: two comment lines in `scripts/run_state.gd`, nothing else under `scripts/` or `data/`. JE's four rulings are answered and written where they bind. The sim's relic default is row DV34 of the divergence census, a POLICY, with the sentence beside the absolute scale. `docs/state.md` is cut by 9.52 KiB and stands 1,490 B lighter. The crest pool is read out in four tables. The verification is reworded: all 489 positional reads re-derived, a recon owed when the game's code or data moves, the readers the floor.

**Three findings matter most, and each moves something the brief said.**

- **THE BOT WEARS A CREST RUNE, SO JE's *NONE* WAS NOT ONE.** `RunSim._sim_take_drop` wears the first crest rune it draws: 55 of 60 runs at Wanderer, 44 at Warden, 38 at Ruin, 166 of 180 on the incumbent. So *no rune worn* needed its own arm, and `docs/reports/JE-crest.tsv`'s *paired by seed against the same party with no crest* is false. Against a true none (`docs/reports/JF-crest.tsv`), JE's arms read at Warden +1.62 ± 1.14, +2.42 ± 1.09 and +1.22 ± 1.04 of depth for Dirge, Dead Air and Empty Pulpit, finishing 9 of 60 against 5 on each. **Dead Air reads past two errors at Warden, where JE read nothing past 1.6**: one reading of about two dozen, which is near what chance hands, on arms that share the map and little past the first fights. At Ruin all three are flat.
- **"RUIN RUNES" DOES NOT HOLD ON THE RULE's OWN POPULATION.** The incumbent finishes 57 runs of 60 at Ruin with no crest worn, so on *the population that finishes runs* Ruin's uptimes are 0.8, 0.4 and 0.3%, not 17.7, 9.1 and 2.2. **And *all three fire almost exclusively in runs already lost* is false where runs finish in numbers**: six to eight held turns in ten fall in runs that finish, because lost runs are few. What is true is a rate, four to thirteen times a hero turn in a lost run, on five lost runs and three; at Warden, where five finish, the table cannot tell them apart. The conclusion that no figure moves stands.
- **THE TIES READ THE OLD WAY ARE EIGHT, NOT THREE.** Encumbered is the one grade such a choice ever moved, Fractured stands in JB's sentence beside Porous, and IZ's own table prints the test on Slick Footing, Feverish and Warded. All eight are settled and no grade moved at JF; the fight seed they postdate is IY's, not IZ's.

**Of 42 premises, 32 did not hold as written or left a consequence out.** Each is taken the way I would recommend and said so; nothing was asked of the designer. **My own bets**: §6 grades them.

**THE VERDICT**: **SHIPPED, AND VERIFIED ON THE ACCEPTANCE. JE's four rulings are written where they bind, the sim's relic default is a census row, `docs/state.md` is cut, the crest pool is read out with nothing built, ruled or recommended, and the verification is reworded with `pos_seq.py` under a control.** The acceptance reads 172 targets, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout and `check_de` 705 / 0 / 0, with only the two carried reds, `check_gj`'s sanctioned §4 and `check_cm_live`'s 5 inside its band. All twenty-four controls bit on the tree that lands. **One thing to read strictly**: no recon ran, on my reading that a comment moves no die; ruling 4 names that sentence as mine. **Four rulings wait on you**, NEEDS A RULING, each already taken the way I recommend, and nothing waits on a reply.

## §0 — THE BRIEF's PREMISES, VERIFIED (`CLAUDE.md`: verify the brief against the repo)

Read against `docs/state.md`, `docs/reports/JE.md`, `JE-spiral.tsv`, `JE-pooled.tsv`, `JE-crest.tsv`, `JE-turns.tsv`, the logs and the code, before any edit. **Under the standing word nothing here went to the designer.**

| # | the brief says | verdict |
|---|---|---|
| 1 | the push check | **True**: `4b8763d0`, JE's commit, no follow-up taken. |
| 2 | §5: *the eight strays are cleared from my end* | **The conditional fired**: the folder reads 619 at the open, so the command did not run and `KNOWN_STRAYS` stands, with FOUND AT JD's item. |
| 3 | §0: JE's figures, ±1.23, r 0.771, ±0.93 | **True to the digit.** |
| 4 | §0.1: *since IZ's fight seed* | **The fight seed is IY's** (`DOD_SIM_FIGHT_SEED`, IY §1). JE wrote IZ's too. The first fight-seeded ties are IY's. |
| 5 | §0.1: *Ambushed, Porous and Fleeting* | **The set is eight.** The order is *every grade whose tie was read the old way*. Encumbered is the one grade such a choice ever moved (`docs/reports/IZ-grades.tsv`: `grade` 1, `iy_grade` 2), Fractured stands in JB's sentence with Porous, and `docs/reports/IZ-reread.tsv` prints the same test on Slick Footing, Feverish and Warded, each the reading its grade rests on. Outpaced's reference pair is in JB's sentence too and feeds no grade. **All eight are settled and no grade moved at JF.** My first text said five, and the outside reader took it to eight. |
| 6 | §0.1: *a tie between two batches' arms* | **The rule does not reach Porous as worded**: Porous's two readings and Fractured's are one batch's, JB's. The rule stands in the designer's words. NEEDS A RULING 1. |
| 7 | §0.1: *Porous pools over its cut at either end* | **True, and never computed**: `JE-pooled.tsv` holds Ambushed alone. It holds because both readings sit over 1.78. |
| 8 | §0.1: *Fleeting's two readings were two decks* | **True, and so were Porous's and Fractured's**: JB's sentence says each was *on an earlier state of the deck*. The line says so. |
| 9 | §0.2: every figure | **True to the digit**: -1.43 ± 0.59, -1.88 ± 0.54, +0.040, +0.059, +0.008, +0.009, 48 of 120, 37 of 113, 49 of 93, 39 of 103. |
| 10 | §0.2: *JD's arms ran at the default of none* | **They opened with none.** An event's rare relic reached about a third of runs, and moved one fight of 3,363 before the end boss. |
| 11 | §0.3's table | **True of JE's table, and that table is the bot's default arm**, which wears a crest rune in most runs. Read with no crest worn: §4. |
| 12 | §0.3: *about thirty hero turns*, *seventeen to twenty* | **True.** |
| 13 | §0.3: *Wanderer is where 57 runs of 60 finish* | **57 is JC's rule.** On the tree that stands, 55. |
| 14 | §0.3: *Ruin is where none do* | **True of the reference four only.** The incumbent finishes 58 of 60 at Ruin, 57 with no crest worn, and `docs/state.md` printed its column; the brief dropped it. **So on the rule's own population Ruin's uptimes are 0.8, 0.4 and 0.3%, and *Ruin runes* does not hold.** The sentence says what the table says: a lost run holds them four to thirteen times as often as a run that finishes at Wanderer and on the incumbent at Ruin, and at Warden, where five finish, it cannot tell them apart. My first text said *on any rung*; the outside reader recomputed it and that was false. NEEDS A RULING 2. |
| 14b | §0.3: *all three runes fire almost exclusively in runs that are already lost* | **False where runs finish in numbers.** Of the turns each condition holds with no crest worn, 78, 75 and 65% fall in runs that finish at Wanderer, and 71, 73 and 61% on the incumbent at Ruin, because lost runs are few. **What is true is a rate**: a hero turn of a lost run holds them four to thirteen times as often. I missed this row; the fresh reader found it. NEEDS A RULING 2. |
| 15 | §0.3: *Dirge at 45% over 1.4% of turns is worth about six-tenths of a percent* | **The arithmetic holds and the uptime is the default arm's.** With no crest worn, on runs that finish, 1.7%, so about eight-tenths. The rule states that. |
| 16 | §0.3: *the same shape JB found in reverse* | **I cannot find it in JB's report.** The nearest record is HQ §1's watch item, *the Cleric mostly falls in fights already going badly*. Not written. |
| 17 | §0.3, §4: *the pool is a queued item*; *the next parked item* | **Half.** *Parked* has no record: one hit, `st/b`. *Queued* has one: HEAD's roadmap read *counted and priced* under *THE QUEUE IT DISPLACED COMES BACK*. The order stands. |
| 18 | §0.3: *the three go on TO WATCH IN PLAY* | **They stood there already**, one row naming all three and a second on Empty Pulpit, and the block's heading says each is one constant, which *no magnitude fixes 1.4%* contradicts. The row naming all three is amended, no third added, and the exception said. |
| 19 | §0.4 | **True**: two `spec_in_party` events, both 8; the Cairn 12. |
| 20 | §0.5, §0.6 | **True**, read row by row against JE's report. |
| 21 | §1: *where crest runes are priced* | `CLAUDE.md`'s crest block, after *A RUNE PAID WHILE A HERO IS MISSING*. |
| 22 | §2: *classify it as that census classifies things* | **POLICY, row DV34**, and a RULE was never open: `check_iv` §3b holds that count at zero. |
| 23 | §2: *a shared relic-less baseline* | **The true word is *opens with none***: the Grave hands a rare relic in about a third of runs. The sentence says so. |
| 24 | §2: *three relics took Wanderer's falls from 53 to 14* | **On JD's rule. On the tree that stands, 13.** |
| 25 | §2: *write that where the scale is defined* | **It stands in three places**, the ladder block, the comment above `Run.MODIFIERS` and the grades block. All three carry it. |
| 26 | §2, by the same reasoning, unasked | **The crest is a second default.** The close-read found JF treating one and not the other: row DV35, and a clause beside the scale. |
| 26b | §6: *the positional reader stays*, apart from the four it calls not negotiable | **The rule writes it among them.** A reading: §6 says *stays*, and a rule that left it out would read as optional. NEEDS A RULING 4. |
| 27 | §3: 28.06 KiB, 3.3 batches, 8,776 B, 10,890 B, 5,048 B | **True to the byte.** *The nearer of the two ceilings* is true in batches and false in KiB: 19.46 under against 28.06. |
| 28 | §3: *the two size figures* | **True, and the same lines held two more false statements**, both gone. |
| 29 | §3: *a sweep of what the census prints is the fix JE named* | **It did not fit: the census printed no folder size.** It prints one now. |
| 30 | §4: *the same probe over the rest of the pool* | **The rest of the pool is Tithe, which has no condition, and Fellowship, retired.** Each read as what its read site asks. JE's count was fall-to-end; the door reads the condition itself and reproduces it within 0.06 of a point. |
| 31 | §4: *no rune worn* | **A default sim is not that**: the bot wears the first crest rune it draws. Every arm was driven both ways. |
| 32 | §4: *if the count differs from what the roadmap says* | **The roadmap states no number.** 17 rows. |
| 33 | §5: `test_batch_bx` §4b | **True.** |
| 34 | §6: *JE's five readers cost about 1.3 million tokens and found two unmet orders and eleven false sentences of mine* | **Three of the five cost that, and the eleven were in JE's own report**, by the fresh reader. The point stands, and the rule's words say it as it was. |
| 35 | §6: *`pos_select`'s parse had been wrong since JB* | **Since IX at the latest**: the line is the same at IX, IY, IZ, JA, JB, JC and JD. |
| 36 | §6: *`pos_seq.py` … has cleared reads in two batches and has never had one of its own* | **True**: JD and JE. **And it did not pass**: §6. |
| 37 | §6: *the honest skip was 26 of 489* | **True at JE.** At JF the passes read all 489, 183 of them byte-identical. |
| 38 | §6's C02: *the three settled ties* | Eight, by premise 5. |
| 39 | §6's H01: *every code arm* | **No game code moved, so H01 has only the comment to red**, and it does. Said in §6. |
| 40 | §6's C13: *`pos_seq.py` broken so a moved read reads unmoved* | **The tool lives outside the tree**, so the arm reads a kept table, and the control regenerates that table with a broken copy. Said in §6. |

## THE RULINGS, AND WHERE EACH IS WRITTEN

- **§0.1 — THE COVARIANCE CLAUSE, AND THE STANDING CORRECTION**: `CLAUDE.md`'s ladder block, directly after the pooling rule; the comment above `Run.MODIFIERS`; `docs/state.md`'s grades block points there. The one line names eight.
- **§0.2 — THE RULING AT FIFTEEN AND ITS PRICE**: `CLAUDE.md`'s block *A FALL STAYS INSIDE ITS FIGHT*. `check_jf` §1c recomputes each percentage off `docs/reports/JE-spiral.tsv`'s counts.
- **§0.3 — THE WORTH RULE**: `CLAUDE.md`'s crest block, directly after *A RUNE PAID WHILE A HERO IS MISSING*, where crest runes are priced. **THE THREE ON TO WATCH IN PLAY**: they stood there already, so the row naming all three is amended and no third added; and the block's heading says each is one constant, so the row says it is the exception.
- **§0.4 — A REQUIREMENT THE PLAYER CHOSE**: beside *do not gate twice*, in the fall's block. Both boons stay at 8.
- **§2 — THE DEFAULT**: row DV34; the sentence in `CLAUDE.md`'s ladder block, the comment above `Run.MODIFIERS` and `docs/state.md`'s grades block, the three places the scale stands.
- **§6 — THE THREE REWORDINGS**: `docs/instrument-rules.md`, in *WRITE THE DOCUMENTS BEFORE THE VERIFICATION RUN*.

## §2 — THE DEFAULT, RECORDED

**Row DV34, sorted POLICY, and row DV35 beside it, which the close-read asked for: the bot wearing the first crest rune it draws is a second default of the same shape.** The census's words: a POLICY is the bot choosing, a RULE the bot playing a different game, a MODEL the bot standing in for the player's hands. The bot takes no relic at the draft unless a job names some: the same door (`Run.new_run`), and a legal draft. **It is not a RULE**, which `CLAUDE.md` says a batch repairs in that batch and `check_iv` §3b holds at zero. **The word is *opens with none*, not *relic-less***: the Collector's Grave hands a rare relic in about a third of runs, JE's own root finding, so *a shared relic-less baseline* is wrong by the same margin *every arm carried no relic* was. **What rests on it, once and not re-measured**: every grade is a modifier against *none* on one tree, so a shared baseline that opens with no relic is consistent and the grades stand. What rests on the default is the absolute scale: three relics take Wanderer's falls from 53 to 13 on the tree that stands (14 on JD's rule), so a party that finds them plays a milder deck than the one graded. No grade re-read, and no arm re-driven for one.

## §3 — `docs/state.md` IS CUT

**The room at the open**: 360,385 B, 351.94 KiB of 380, 28.06 KiB under, 3.3 batches at JC's 8,776 B. **The cut**: 9,745 B gross, 9.52 KiB, in 20 units (`docs/reports/JF-cut.tsv`, each with what closed it). **Written**: 8,255 B. **The net**: -1,490 B. **The room at the close**: 358,895 B, 350.48 KiB, 29.52 KiB under, 3.4 batches at JC's rate. **THE 6 KiB CLAUSE DOES NOT FIRE.** **NAMED ANYWAY, BECAUSE YOU ASKED TO KNOW EARLY**: the close-read, after the cut was done, found `### THE MERGE'S RUNNING ORDER` (3,187 B) and `### HA's RULINGS OWED` (1,655 B) closed by their own heads, and `### ~~THE END BOSS HAS NO BUTTON~~` (476 B) nearly so: its head still owes two wordings. `### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED` is part closed, its flakes paragraph and DR's collision about 2,557 B of 3,443; its retired-word paragraph stays, because the strip §5 orders stands nowhere else.

**WHAT WAS DERIVED CLOSED.** The blocks' reader read the 63 opened blocks at source and I re-read each unit before cutting: two whole blocks, JE's four rulings, four items JF's own work closes, and thirteen items fixed, overtaken, copied or asking nothing. **A partly closed item stays and is not amended here**: FOUND AT HO's Tithe line, FOUND AT GC's *28*, FOUND AT GL's Renewal, and the IS pointer that names them.

**THE TWO SIZE FIGURES.** Both are gone, and two more false statements in the same lines with them: *BOTH FILES*, where the folder holds three, and *larger than every `check_*.gd`*, where it is 2.77 MB against 4.60 MB. **The fix JE named did not fit**: the census printed no folder size. **So it prints one now** (`claude_md_census.py`, four lines, beyond the brief), and `docs/state.md` points at it, so JF's own cut cannot stale it.

## §4 — THE CREST POOL, READ OUT

**Nothing built, ruled or recommended. Each read predicted first** (`s1/PREDICT_POOL.md`, md5 `7c0e5d91…`; `s1/PREDICT_UP.md`, md5 `9fa387ec…`; `s1/PREDICT_UP2.md`, md5 `8500505f…`), graded in §6.

### READ 1 — WHAT THE POOL IS TODAY (`docs/reports/JF-pool.tsv`, `JF-draw.tsv`)

| rune | status | figure | its condition | where it is read | anything reads it? |
|---|---|---|---|---|---|
| Tithe | live | 30% | none: a read at the blow | the strike loop's Break block, `result.bd` above 0, to the lowest hero | yes |
| Empty Pulpit | live | 50% | `heroes_lack_class`: cleric | `Talents.party_condition_met` off `_live_party`, at every death and revive | yes |
| Dead Air | live | 75% | `heroes_lack_class`: mage | the same | yes |
| Dirge | live | 45% | `heroes_all_standing`: false | the same | yes |
| Fellowship | retired | 1 a turn | a debuff on the hero side at his turn | the hero-turn upkeep, for a saved run wearing it | yes; no door offers it |

**No Watchtower here**: each condition has a reader and a writer, `check_jf` §4a drives the three door conditions on a constructed party both ways, and the two read sites are pinned.

**The cap is one** (`Run.PARTY_RUNE_SLOTS`); the bag holds six, crest runes only. **A crest rune arrives three ways**: the fight drop, the Peddler and the event verb, never a hero's own pick of three. **What competes in the drop**: a flat union of 55 to 60 ids at a run's spawn on the four parties driven, 4 of them crest runes, 6.7 to 7.3%, and 20 core runes. **Nothing in the roll asks whether the crest is filled.** The bot still ends 55 of 60 Wanderer runs with one worn. The union's counts: `tools/jf_union.gd`, a lane at a run's spawn.

### READ 2 — THE DEPENDENCIES (`docs/reports/JF-deps.tsv`)

**17 rows, each read off the record it names**: 9 wait on the ruling, 3 are play questions it would reopen, 5 bound it. **THE ROADMAP STATES NO NUMBER, SO THERE IS NOTHING TO DIFFER FROM.** *Parked* appears once in the file, for `st/b`; HEAD's roadmap put the three runes under *THE QUEUE IT DISPLACED COMES BACK*. **The brief's *dependency list* is no thing in the file**: the rows are read off every block that names the pool. The list the fallen hero's question held was JC's seven, and it is not the pool's. **RULED AND NOT BUILT holds none**: one item, a copied Frostbind.

| thing | kind | what it needs the ruling to say | what it cannot be decided without |
|---|---|---|---|
| A crest rune keyed on what the party carries | waits on the ruling | Whether the pool's next rune reads what the party carries, and that rune's words: authoring is the designer's | How often a given core is held on the population that finishes runs, which no table here reads; HO §3's census of what a crest may write |
| The crest's other doors | waits on the ruling | Which door the pool opens next, if any | `docs/reports/HL.md` §6's list and what each door costs; and EN §4's seam: an effect on the purse is a relic by that rule, so the money door may not be a rune's |
| The crest's cap | waits on the ruling | Whether one stays, given what `docs/reports/JF-uptimes.tsv` reads of the three | `docs/reports/JF-uptimes.tsv`; what a second slot does to the bag and the crest strip, which no gate has walked at two |
| How a crest rune is drawn | waits on the ruling | Whether the pool's draw stays those three routes: the same door as the ruling HW owes | `docs/reports/JF-draw.tsv` |
| Tithe's read site | waits on the ruling | Whether Tithe's site is split from the talent's or rebalanced with it | The talent's own measurement and batch, which the record owes first |
| What each rune is worth over a fight | waits on the ruling | Any magnitude read against what it replaces on the reference four | HQ's damage probe, which reads the live share of every blow |
| A rune that saves a run against one that lengthens it | waits on the ruling | What a crest rune is priced against: finishes, depth or falls | An instrument that reads finishes past sixty paired runs |
| The condition shapes the door lacks | waits on the ruling | Which shapes the pool wants, if any | The rune that asks for one |
| A crest rune that grants a card | waits on the ruling | Whether the pool holds one | `docs/reports/HO.md` §7's list of what each shape owes |
| Whether a switch reads as a moment | a play question it would reopen | Nothing: a ruling can read play here and play has not been read | A second run that wears one |
| Whether the four are felt | a play question it would reopen | Nothing | A second run that wears one |
| Empty Pulpit in fights being lost | a play question it would reopen | Nothing | A second run that wears one |
| A crest rune that cleanses | a bound on the ruling | That a cleansing crest stays out unless the supply it answers moves | `docs/reports/JF-uptimes.tsv`'s Fellowship rows |
| The live re-read | a bound on the ruling | That any re-cut of the live door re-prices those three | Nothing further |
| A party rune has to read the party | a bound on the ruling | That the next rune names what of the party it reads | Nothing further |
| What a crest rune may write | a bound on the ruling | That a new rune writes a `rune_` field and never a node's own counter | Nothing further |
| A hole in the four paid in a stat | a bound on the ruling | That neither returns | Nothing further |

### READ 3 — THE UPTIMES (`docs/reports/JF-uptimes.tsv`, 168 rows)

**The method is JE's probe made exact**: every condition asked at the door a worn rune would ask it, at each hero turn, spending no die. **The proof it is read-only**: all seven arms JE drove reproduce JE's `[JCF]` and `[JEF]` lines byte for byte. **On those arms it reproduces JE's shares** to within 0.06 of a point, the gap a raise.

**WITH NO CREST WORN** (the bot's crest doors held shut; 420 runs, `crest=0` at every run's end):

| population, rung | finished | Dirge | Dead Air | Empty Pulpit | Tithe, a blow that pays | Fellowship |
|---|---|---|---|---|---|---|
| the reference four, Wanderer | 55 of 60 | 2.0% | 1.0% | 0.5% | 42.9% | 29.1% |
| the reference four, Warden | 5 of 60 | 12.6% | 7.6% | 2.2% | 44.7% | 28.3% |
| the reference four, Ruin | 0 of 60 | 18.0% | 9.4% | 1.8% | 44.1% | 24.5% |
| the same, three relics, Wanderer | 58 of 60 | 0.7% | 0.5% | 0.1% | 40.8% | 27.7% |
| the incumbent, Wanderer | 60 of 60 | 0.0% | 0.0% | 0.0% | 32.6% | 4.8% |
| the incumbent, Warden | 60 of 60 | 0.4% | 0.3% | 0.1% | 34.9% | 5.1% |
| the incumbent, Ruin | 57 of 60 | 1.0% | 0.6% | 0.5% | 34.9% | 4.9% |

**ON RUNS THAT FINISH, WHICH IS THE RULE's POPULATION**:

| population, rung | runs | Dirge | Dead Air | Empty Pulpit |
|---|---|---|---|---|
| the reference four, Wanderer | 55 | **1.7%** | **0.8%** | **0.3%** |
| the reference four, Warden | 5 | 14.3% | 7.4% | 2.4% |
| the same, three relics, Wanderer | 58 | 0.5% | 0.4% | 0.0% |
| the incumbent, Wanderer | 60 | 0.0% | 0.0% | 0.0% |
| the incumbent, Warden | 60 | 0.4% | 0.3% | 0.1% |
| the incumbent, Ruin | 57 | **0.8%** | **0.4%** | **0.3%** |

**The Warden row rests on five runs.**

**WHERE THE HELD TURNS FALL**, the premise §0.3 stands on and I first missed (the fresh reader's table, recomputed off the same lines): with no crest worn, the share of each condition's held turns that fall in runs that finish.

| | Dirge | Dead Air | Empty Pulpit |
|---|---|---|---|
| the reference four, Wanderer | 78% | 75% | 65% |
| the incumbent, Ruin | 71% | 73% | 61% |

**So lost runs hold them far oftener and hold few of them**: a hero turn of a lost run reads four to thirteen times the rate, on five lost runs and three. **By the rule**: Dirge at 45% over 1.7% of turns is about 0.77%, Dead Air at 75% over 0.8% about 0.6%, Empty Pulpit at 50% over 0.3% about 0.16%, each a gross and not a price. **Tithe has no condition, so its row reads a blow**: about 2.8 health a hero turn on the reference four. **Fellowship's condition holds on about a fifth as many hero turns on the incumbent as on the reference four**, 5% against 24 to 29%, read and not priced.

**WHAT THE POOL DOES AT ALL** (`docs/reports/JF-crest.tsv`, paired by seed against the true none): the bot's default crest takes Warden's finishes from 5 of 60 to 9, +0.067 ± 0.032 (2.05 errors), and depth +0.82 ± 0.60; at Ruin and Wanderer nothing moves past an error and a half. **Falls do not move on any arm past two errors, and two readings of about two dozen past two is near what chance hands.**

## §5 — HOUSEKEEPING

- **THE MOVE WAS NOT ATTEMPTED** (IB §4). **THE FOLDER READS 619 AT THE OPEN, SO THE COMMAND WAS NOT RUN AND `KNOWN_STRAYS` STANDS.** `./lane.sh strays` prints the eight and *IT const probe* and *[unnamed project]*. `./lane.sh spent` prints the one clearing command.
- **USER-DATA FOLDERS: 619 AT THE OPEN, 619 AT THE CLOSE. JF ADDED NONE.** Every lane's name came from the `app_userdata` listing, the one `lane.sh` checks against, and none raised a LANE NOTE.
- **`lane.sh` for every launch and one process a lane: held.**
- **EVERY WAIT READ THE RUNNER's DONE LINE AND CARRIED A TIME BOUND** (`tools/wait_run.sh`). Twenty-one waits, each on its own marker: the drives, the readers and the pre-runs at bounds of 200 to 585 seconds, set again when one ran out, and the acceptance at 115 minutes, which it did not reach.
- **THE RETIRED-WORD STRIP RAN BEFORE THE BATTERY**, `test_batch_bx` on the pre-run, and `docs/master.html` did not move.
- **The designer's files were backed up first and read only through copies.** **All seven md5s at the open**: `run_save.bin` fcb20c91…, `profile.json` 608d89c0…, `relics.json` fdc12ffa…, `settings.cfg` 0c1b39c3…, `latest.txt` e43f2d0a…, and the two readout files, `run-20261014` 2b0f0212… and `run-20261018` 610bcd8c…. **All seven at the close, after the acceptance, through a fresh copy (`logs/close_copy`): each equal to the open's.**
- **BOTH CEILINGS.** `CLAUDE.md` 502,309 → 506,348 B: +4,039 B, 494.48 of 510 KiB, **15.52 KiB under**, 3.0 batches at JC's +5,233 B. `docs/state.md` 360,385 → 358,895 B: -1,490 B net, 350.48 of 380 KiB, **29.52 KiB under**, the archive taking 9,745 B and JF writing 8,255 B, 3.4 batches at JC's 8,776 B. **`CLAUDE.md` is the nearer ceiling in batches again**, 3.0 against 3.4, which it was not at the open.
- **The close's own timestamp: 2026-11-02 22:14 PST.**

## WHAT IS DELIBERATELY NOT DONE

No figure of a crest rune moved, no rune authored, re-worded or re-valued; no boon's weight moved; no arm re-read for a grade, no grade moved, the deck closed at twenty-five; no ruling on the pool; the partly closed items left whole; `docs/master.html` unmoved, because the game did not move; `docs/reports/JE-crest.tsv` left as JE wrote it, a kept record, with the correction beside it in `JF-crest.tsv`; the 187 cheap gates; the standing list; nothing of the playthrough.

## FOUND AT JF AND NOT FIXED

- **JE's CREST *NONE* WORE A CREST RUNE** (§4): the bot wears the first crest rune it draws, so `docs/reports/JE-crest.tsv`'s *paired against the same party with no crest* is false and JE's table stands as a worn rune against another. A kept report is not rewritten; `docs/reports/JF-crest.tsv` is the re-read.
- **THE HUNK PASS CLEARS A FIXED-WIDTH READ TOO** (§6): `pos_hunks.py` reads needles and no width. `tools/pos_width.py` sends such reads to the reader; the next batch copies it. **The width regex is a pattern over the census's prose**, so a width it did not write down goes unseen.
- **AT WARDEN THE REFERENCE FOUR FINISH 5 RUNS OF 60 WITH NO CREST WORN** (§4): that rung's *runs that finish* rests on five runs.
- **TITHE's UPTIME IS A BLOW's, NOT A CONDITION's** (§4): 43 to 45% of hero turns on the reference four, about 2.8 health a hero turn; 33 to 35% on the incumbent, 2.9 to 3.5.
- **AN INLINE `_doc("res://…").contains(…)` PIN SITS OUTSIDE `check_ed`'s SCAN** (the positional reader's side finding): the shape stands in five gates at HEAD and `check_jf` adds two; most have no manifest entry.
- **THE TOOL THE CONTROL PROVED BLIND HAD CLEARED 54 READS AT JD AND JE** (§6): 50 stand on their subject, 4 stand tight, slack under a tenth of their width, and none is off it or unread. Three of the four red loudly if pushed. **`test_batch_bm` §9 is the one that would not**: its 1,400-character window reads 18% of the branch its message names, 60 characters of slack, comments filling the rest. And `Gate.within(x, at, Gate.block(x, at))` is true of any non-empty block, so it shows nothing about what a block covers, and a column-0 comment ends a block silently: `test_batch_bs`'s read of `take_tick_damage` is negative-only.
- **THREE THINGS NAMED AND NOT TAKEN**: two census sentences stale at HEAD (*no scope swallows a static func*, on rows 31, 34 and 304, and rows whose selection predates `Gate.block`); the three blocks §3 names, 5.19 KiB, found after the cut was done; and three partly closed items, FOUND AT HO's Tithe line, FOUND AT GC's *28* and FOUND AT GL's Renewal.
- **WHAT WENT BEYOND THE BRIEF**: `claude_md_census.py` prints the archive folder; `pos_seq.py` is repaired and `tools/pos_width.py` added; the arms of §4 with no crest worn, the three-relic arm and the incumbent at Wanderer and Warden, which the rule's population needs; `docs/reports/JF-crest.tsv`; row DV35 and its clause; S4-003 re-read HELD, the standing list's own order; `CLAUDE.md`'s *grows by one every batch* struck. **No game code moved.**

## NEEDS A RULING

1. **THE TIES READ THE OLD WAY ARE EIGHT, NOT THREE (JF §0.1).** The brief's line named Ambushed, Porous and Fleeting. Encumbered is the one grade such a choice ever moved (IZ's 2 → 1, `docs/reports/IZ-grades.tsv`), Fractured stands in JB's sentence beside Porous, and `docs/reports/IZ-reread.tsv` prints the same test on Slick Footing, Feverish and Warded, each the reading its grade rests on. **Taken**: the line names eight, all settled, and no grade moved at JF. **Porous's and Fractured's arms are one batch's, so *two batches' arms* does not reach them as worded.** **The alternative**: *two readings of one population on one seed block*, which reaches them. **Reversing it** is a few words in the rule.
2. **"RUIN RUNES" DOES NOT HOLD ON THE RULE's OWN POPULATION, AND THE UPTIME THE RULE QUOTES IS THE TRUE NONE's (JF §0.3, §4).** The incumbent finishes 57 runs of 60 at Ruin with no crest worn, and JE's 1.4% was read on a party wearing a crest rune in 55 of 60 runs. **Taken**: the rule's words as ordered; its figures read with no crest worn on runs that finish, 1.7, 0.8 and 0.3% at Wanderer and 0.8, 0.4 and 0.3% on the incumbent at Ruin; a rate per hero turn, four to thirteen times a lost run's against a finishing run's, in place of *Ruin runes*. **And *fire almost exclusively in runs that are already lost* does not hold where runs finish in numbers**: 61 to 78% of held turns fall in runs that finish, because lost runs are few. **The alternatives**: the brief's 1.4, 0.8 and 0.4%, the default sim's over every run; or 2.0, 1.0 and 0.5%, no crest worn over every Wanderer run, which keeps the brief's scope with the crest repaired. **Reversing it** is one sentence in `CLAUDE.md`, one row of TO WATCH IN PLAY and `check_jf` §1d's cells.
3. **THE RELIC DEFAULT AND THE CREST DEFAULT ARE SORTED POLICY (JF §2, §4).** The bot takes no relic at the draft unless a job names some, and wears the first crest rune it draws: the same doors and legal choices. **Taken**: POLICY, rows DV34 and DV35. **The alternative**: MODEL, the bot standing in for a player's hands; RULE is out, because a RULE is repaired in its batch and `check_iv` §3b holds that count at zero. **Reversing it** is one cell a row.
4. **THREE WORDS OF MINE STAND UNDER YOUR VERIFICATION RULES (JF §6).** The readers' list names the positional reader, where you wrote *the positional reader stays* apart from the four; *a comment moves no die, and a code line owes the recon* is my reading of *code*, and it is the sentence that exempts this batch, so it is marked the batch's; and the recon rule names the game's code and a gate's own change, and a `.py` instrument's or the runner's change is neither (JF changed `claude_md_census.py` and `run_battery.sh`). **Taken**: all three as written, the third read as a gate's. **The alternative**: strike the first, or name instruments in the rule. **Reversing it** is one clause each.

## §6 — VERIFICATION

**THE ORDER.** The routing first (17:38, before any edit), the blocks' reader on what it opened (17:58). The premises read before any edit. The drives each with a prediction first. The documents as scripts replayed from HEAD, each anchor asserted once (`JF-work/edits/rebuild.sh`), never on the repository. The literal sweep before the pre-run's prediction. **The new text's reader and the close-read before any pre-run**, as the brief orders, and their repairs in. Then the pre-run with the positional readers beside it, on a frozen copy; pre-run 2 with the controls beside it, on clones; the standalone `check_de`; the fresh reader on this report, and its repairs; the 54 reads; pre-run 3 and the controls again on the tree that lands; and the acceptance. **No recon: none is owed.** `diff` of `scripts/` and `data/` against HEAD is two comment lines in `scripts/run_state.gd`, and the rule reads *when the game's code or data moves*.

**THE PREDICTIONS, EACH A FILE WRITTEN BEFORE ITS LAUNCH, GRADED.**

| | written before | right | wrong |
|---|---|---|---|
| the uptimes, `s1/PREDICT_UP.md`, md5 `9fa387ec…` | the drive, 17:41:34 against 17:41:59 | the read-only proof, all seven arms byte for byte; every JE share within 0.15, and the bet on a raise unspent; three relics at Wanderer 0.54% in 0.2–0.7; Tithe's hero turns 44%, in a band centred on 55; flat across the rungs; 32 minutes in 20–55 | **Warden's finishers 12.1% against 3–10**: I thought a finishing run would hold it far less, and it does not. Below full 97% of a Break blow against 70–95. Tithe's worth 2.8 a hero turn against 0.7–2.5. **Fellowship falls with the rung, where I wrote it rises.** The incumbent at Warden 0.43%, where I wrote under 0.3 |
| the true none, `s1/PREDICT_UP2.md`, md5 `8500505f…` | the drive; its header types 17:50 and its mtime, 17:45:27, is what proves it | `crest=0` on all 420 lines; every uptime in its band; the finishes 55, 5 and 57 in theirs; JE's three arms at +1.62, +2.42 and +1.22 against +1.5, +2.3 and +1.1 | **Falls**: I wrote that a crest saves about 7% of them, and at Warden the true none reads 360 against 360, at Ruin 332 against 345. **The 1-in-3 landed**: Dead Air's depth passes two errors |
| the pool and its dependents, `s1/PREDICT_POOL.md`, md5 `7c0e5d91…` | either table | five entries; every condition has a reader, the 1-in-6 unspent; the three routes | **A union of 60 or more, under 7%**: 55 to 60 by party, 6.7 to 7.3% (`logs/union.txt`). **Five to nine rows**: 17, of which 9 wait on the ruling. **A roadmap's number to differ from**: there is none |
| the pre-run, `s1/PREDICT_PRE.md`, md5 `c9be77fa…` | the launch | 133 targets, 0 errors from the tree; every count on its row; `check_iu` §8 ×2 named; every bet unspent; 22 minutes in 20–55 | **Two reds of my harness, unnamed**: `test_batch_bl` needs the battery's `--fixed-fps 12`, which my own notes say, and `check_map_screen` is a scene |
| pre-run 2, `s1/PREDICT_PRE2.md`, md5 `e13e843a…` | the launch | every target on its row; 0 errors; both bets unspent; 4 minutes against 6–20 | **I wrote 39 targets for 40; the 1-in-4 landed**: `check_de` 705, where I wrote 702 |
| the controls, `s1/PREDICT_CTL.md`, md5 `e84d48c4…` | the launch | every wanted line bit, every must-hold line held, 0 throws; H01 on the two comment arms alone; each bet unspent | **I wrote 22 for 24.** The time: 47 seconds against 2–12 minutes |
| pre-run 3, `s1/PREDICT_PRE3.md`, md5 `85bd04ab…` | the launch | every target on its row, 0 errors, the bet unspent, `check_de` 705 as I wrote, 21 minutes in 18–40 | none |
| the acceptance, `s1/PREDICT_ACC.md`, md5 `52139c7b…` | the launch | 172 targets, 0 errors, no timeout; only the two carried reds; `check_de` 705 / 0 / 0; every named row; `test_batch_bk` 131, `check_hk` 168, `check_gp` 451, `check_cm_live` 5; 87 minutes against 88; the bet on a third red unspent | `test_batch_an` 6,015 where I wrote near 6,024: nine under, inside its band of 6,013 to 6,035 |
| the report's landing, `s1/PREDICT_REP.md`, md5 `4c9aa9c1…` | the launch | every count at the acceptance's, 0 errors; 164 codes, *CW to JF*; the 1-in-10 unspent; 3 minutes in 2–8 | none |

**THE LITERAL SWEEP** (`logs/lit_w2.tsv`, before the pre-run's prediction): 25 files, 1,190 MOVED, 1,590 GAINED, 31 LOST, each LOST row walked: the cut's words and `check_je`'s two re-pointed needles, none read off the file it left. The outside reader swept 26,498 needles on an 8-character floor, on an earlier tree, and came to the same conclusion.

**THE RETIRED-WORD STRIP**: `test_batch_bx` on the pre-run, 164 / 0. `docs/master.html` did not move.

**THE PRE-RUN** (`logs/pre1`, 133 targets on four lanes, every gate that names a file JF changed and JE's 48, 19:11 to 19:33): 0 `Parse Error` from the tree, every count on its row, `check_jf` 238 / 0, `check_je` 251 / 0, `check_parse` 248 / 0. The reds: `check_iu` §8 ×2, the routing's close lists, named before the launch; and my harness's two, above. **PRE-RUN 2** (`logs/pre2`, 40 targets, 19:34 to 19:39): all green, `check_iu` 185 / 0, `test_batch_bl` 88 / 0 with its flag, `check_map_screen` complete as a scene. **PRE-RUN 3** (`logs/pre3`, the tree that lands, every repair in, the same 133 with both flags right): all green on their rows, 133 of 133, 0 errors: `check_jf` 245 / 0, `check_iu` 185 / 0, `check_je` 251 / 0, `check_hx` 42 / 0, `check_is` 96 / 0, `check_parse` 248 / 0, `test_batch_bl` 88 / 0, 20:17 to 20:38. **THE STANDALONE `check_de`** (`logs/de_standalone.log`; JE's acceptance logs with these laid over): 705 / 0 / 0.

**THE BLOCKS' READER** (`route/opened_reader.md`, 63 blocks, 129,539 B): it derived what was closed, found the census prints no folder, found the ties short by two, found *Ruin runes* false, found `check_je` pinning both rules §6 rewrites, and found that the roadmap states no number.

**THE CLOSE-READ** (the routing record's third list; 68 blocks, 138,597 B): ten bore, 3 ROUTED and 7 NOT ROUTED, each repaired. **Its heaviest finding was outside any block: JF had found the crest default and treated it as the relic default was not**, so DV35; and my cut had left `DOD_SIM_RELICS` on no index row.

**THE OUTSIDE READER ON THE NEW TEXT** (`route/reader1_findings.md`, before any pre-run; recomputing from the raw logs): **8 defects, 5 stale, 10 soft and 9 holes in the gate, no game fault, and every uptime the text quotes held.** The ones worth naming: `check_hx` §1d would have redded on two backticked tool names; *on any rung* was false at Warden, the heaviest sentence I wrote; the ties were eight, not my five; *nothing else is read past two* was false of the table it cited; the fixed-width regex missed nested calls, the hole the tool was repaired for; nine index rows still routed to items the cut moved; `_tsv` dropped a malformed row in silence, so C11 by deletion stayed green; §3b could pass on an empty table; C08 tested first words. All repaired. **It also corrected me on the control**: the first run found one move read as unmoved; the fixed-width read I had already written in as a limit.

**THE POSITIONAL RE-RUN: ALL 489** (`IT-positional-census.tsv`, re-derived on a frozen copy made at 19:08, before pre-run 1; the tree that lands differs from it in `docs/state.md`, the routing record, the tables and `check_jf`, and the mechanical passes ran again on it). **Cut one is withdrawn, so the select marks every read and the window pass reads every named file.** 284 settled mechanically on the tree that lands; 204 by two readers outside the working read, each emulating the selection on both trees: 128 populations, 59 reads a needle sent, 17 fixed-width reads on a changed haystack (`route/positional_jf_a.tsv`, `positional_jf_b.tsv`); and one the last passes added, `check_iq` §0.2, read by me: *second* stands on my new sentence 600 lines past the block it selects. **173 SAME, 16 LINE-SHIFT, 16 IN-PLACE, 0 OFF-SUBJECT, 0 UNPORTED**; 108 of the 204 cleared from their writers, 106 SAME and 2 IN-PLACE, each marked and not driven. **Across the 489: 457 SAME, 16 LINE-SHIFT, 16 IN-PLACE. No verdict moved, and the thirteen standing MISSES still miss.** `check_jf` joining the sweeps is half of the IN-PLACE; the changelog's new entry, the archive's new first heading and the index are the rest. **JF's diff can only show what JF moved**: the next paragraph is what it could not.

**`pos_seq.py` HAS A CONTROL** (`tools/pos_seq_ctl.py`, `docs/reports/JF-posseq.tsv`: the tool run whole on a scratch repository, only its repository constant changed; twelve fixtures, ten moved reads and two unmoved). **The tool as JE left it misreads three of the ten**: a needle on another line of one hunk, a fixed-width read, and a nested one. **Repaired, it reads all twelve.** Three breaks re-run on the repaired tool each red: its clear answering yes (C13), its per-hunk compare, its hard list. **One break cannot bite and I say so**: dropping the whole-file count changes nothing, because the per-hunk compare already implies it. **What stands behind what it still cannot see**: the census's width regex is a pattern over prose, so a width the census did not write down goes unseen, and a reader is what stands there. **The arm reads a table**: the tool lives outside the tree, so C13 regenerates `JF-posseq.tsv` with a broken copy.

**THE READS IT HAD ALREADY CLEARED.** I first wrote that this batch's reader read them. **It had not, and the fresh reader showed it**: replaying the repaired tool on JD's and JE's own inputs holds 10 of JE's 22 clears and 46 of JD's 149, 54 reads apart from the one already in this batch's list and with the two sets' overlap, none in any reader's list at JD, JE or JF. JF's diff could not show them. **So they were read, on the tree that lands, by a reader outside the working read** (`docs/reports/JF-backread.tsv`): 50 stand on their subject, 4 stand tight, slack under a tenth of their width, and none is off it or unread. Three of the four red loudly if pushed. **`test_batch_bm` §9 is the one that would not**: its 1,400-character window reads 18% of the branch its message names, 60 characters of slack, comments filling the rest. And `Gate.within(x, at, Gate.block(x, at))` is true of any non-empty block, so it shows nothing about what a block covers, and a column-0 comment ends a block silently: `test_batch_bs`'s read of `take_tick_damage` is negative-only.

**THE CONTROLS** (`JF-work/tools/ctl_jf.py`, on the tree that lands: one clone each, the anchor dry-checked or the operation asserting its own row, the gate through `lane.sh`, read by FAIL text; `s1/PREDICT_CTL.md`). **TWENTY-FOUR, ALL BIT, RUN TWICE, THE SECOND TIME ON THE TREE THAT LANDS: 0 throws, no must-hold line reddened, each read by its FAIL text.**

| | the break | what reddened (FAIL text) |
|---|---|---|
| C01 | the covariance clause struck | §1a *the covariance clause does not stand in the pooling rule* |
| C02 | the settled ties left unnamed | §1b *the settled ties are not named in one line*; the correction held |
| C03 | the trace's price left out | §1c *the ruling's block does not carry the trace's price (40% AGAINST 33% …)*, *does not say what the price is* |
| C04 | the worth rule without its uptimes | §1d, six lines, each named: *does not state the reference four, rung 1 (Dirge 1.7%)*; the rule's own sentence held |
| C05 | §0.4's sentence struck | §1e, both halves |
| C05b | a build-gated boon moved to 12 | §1e *old_trapper's weight moved to 12*; the other boon held |
| C06 | the relic default's row removed | §2a *holds no row for the sim's relic default* |
| C06b | that row sorted RULE | §2a *is sorted RULE* |
| C07 | the scale left without the default | §2b *the absolute scale stands without the default beside it*; the scale itself held |
| C08 | a closed block cut without the archive taking it | §3a *1 units were cut and the archive did not take them* |
| C08b | a unit truncated in the move | §3a, by its hash: the arm that read first words would have passed |
| C09 | a stale folder size left as JE left it | §3b *a stale archive-folder size stands: '2,189,661 B'* |
| C10 | a pool row not saying whether anything reads it | §4a *dirge's row does not say whether anything reads its condition* |
| C11 | an uptime without its population | §4b, and §1d's cells |
| C11b | an uptime without its rung | §4b |
| C11c | an uptime row losing a cell, tab and all | *1 rows do not hold the table's columns*: this one passed until the outside reader |
| C12 | a dependency asserted from the brief | §4c *1 rows are asserted from a brief, not a record* |
| C12b | a dependency whose quote stands nowhere | §4c *quotes stand in no record they name* |
| C13 | `pos_seq.py`'s clear answering yes | §6c *occurrence_added_above: the tool reads SAME BY OCCURRENCE*, and three more; the positive arm held |
| C13b | `pos_seq.py` as JE left it | §6c, the three it misreads |
| C14 | a twenty-sixth card | §5 *the deck holds 26, and it is closed at 25* |
| H01 | HEAD's code under the final gate | **two lines, and that is all it has**: the comment above `Run.MODIFIERS`, twice. No game code moved, so no other code arm can red |
| H02 | HEAD's documents under the final gate | 111 lines: every ruling, §2's record, §3, §4's tables, §6's rewordings |
| R01 | Dirge re-tuned at its source, 45% to 50% | §1d *does not state the figure the data holds (50%)*, *does not state the product*, §4a's table, §4a's two sentences of `docs/master.html`, and `check_hp` §2a *the designer ruled*, `CLAUDE.md`'s holder. **The card's own words did not red**: they read the figure through the door. **My first R01 ran one gate and missed `master.html`, JE's fresh reader's finding again**; the fresh reader caught it |

**THE FRESH READER, ON THE ASSEMBLED REPORT** (`report/reader2_findings.md`; read-only, given the brief, this report, the tree and the logs, told to walk the brief line by line and recompute with its own scripts): **no game fault; every uptime table and every crest pairing held; 2 unmet orders, 13 false claims, 3 stale, 13 soft, each checked at source and repaired.**

- **The worst was mine and it was about the control**: I wrote that this batch's reader had read the reads the blind tool cleared. It had not. They are read now, above.
- **R01 ran one gate and missed `docs/master.html`, which JE's fresh reader had found of JE's R01, word for word.** `check_jf` §4a reads its two sentences now and R01 runs `check_hp` too.
- **§0.3's *fire almost exclusively in runs already lost* had no row in §0**, and it is false where runs finish in numbers. It has one, a table, and a clause in RULINGS 2.
- **Prose left by a repair**: *five* twice where the line says eight; *two rows* where one moved; *runs being lost* in the deps table; *a third option* the ruling omitted; a verdict's two errors at 2.09 off rounded figures, 2.05 off the runs.
- **Template carried from JE**: *most of the IN-PLACE*, which is half; *108 of the SAME*, which is 106; the order of the verification, which the timestamps did not bear out; the times; the *13 soft* of a reader whose kept file says 10.
- **Three things my report held and `docs/state.md` did not**, in it now, because a report is swept by nothing.

**THE ACCEPTANCE**: the repository, the 25 files landed behind the hash guard, alone on the machine, 20:40 to 22:07. **172 targets, 0 `Parse Error`, 0 `SCRIPT ERROR`, no timeout.** Red: only the two carried, `check_gj`'s sanctioned §4 (70 / 1, *the card says +180 gold and the purse moved 200*) and `check_cm_live` 13 / 5, inside its 4–5. **`check_de` 705 / 0 / 0.** `check_jf` 245 / 0, `check_je` 251 / 0, `check_iu` 185 / 0, `check_hx` 42 / 0, `check_is` 96 / 0, `check_parse` 248 / 0; `test_batch_an` 6,015, `test_batch_bk` 131, `check_hk` 168, `check_gp` 451. The 665 frozen files read unmoved by md5 after it, `git status` unchanged.

**THE REPORT's LANDING**: fourteen gates alone in one lane, on a clone of this tree with this report in, 22:10 to 22:13: every count equal to the acceptance's, 0 errors. `check_is` and `check_jc` print 164 codes where the acceptance printed 163, and `check_jc` reads *CW to JF*. The copy they read differs from this one only in this sentence, its row in the predictions and the close's timestamp, and `land_jf.py` proved no gate reads a report's words.

**THE PUSH.** `git ls-remote origin class-merge` read `4b8763d0`, JE's push and local HEAD, before anything ran (17:36), and again after the acceptance (22:09), unmoved. **This report travels inside the commit it describes, so it cannot read its own push**: the push to `class-merge` and the remote's read-back against local HEAD come after these words, and the close's message gives them.

**TWO READINGS, BOTH FILES, IQ's METHOD, AT THE OPEN AND THE CLOSE.** `CLAUDE.md` 502,309 B and `docs/state.md` 360,385 B at the open, before the cut; `CLAUDE.md` 506,348 B and `docs/state.md` 358,895 B at the close, after it, each read twice by `wc -c` and the index's own measure, agreeing.

**READERS OUTSIDE THE WORKING READ, COUNTED**: the blocks' reader, the close-read, the new text's reader, two positional readers, the reader of the 54 and the fresh reader on this report: seven, about 3.0 million tokens.
