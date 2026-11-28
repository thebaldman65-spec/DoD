# Batch KK — War Cry in Each Elite's Own Type, and a Brand's Three Turns

**THE RECORD ARRIVED AS THE DESIGNER's ANSWERS TO THREE QUESTIONS, NOT AS A DECISION RECORD, SAID HERE FIRST**: after KJ landed
(`9b74926`), its NEEDS A RULING items 9–11 — the three questions no answer had settled — were put before the designer with their
options and the recommendation first, each option's words checked against the landed report and the data before it was put, and
the designer chose the recommendation each time (27 November): item 9 *"As built (Recommended)"*, item 10 *"Its Maul's type
(Recommended)"*, item 11 *"Laid for 4: 3 turns (Recommended)"*, kept verbatim in `report/answers_9_11.md` in KJ's work folder.
Then *"Build KK here"*. The record names no lane, no source and no open questions; KK proceeds on what it carries
(`docs/ways-of-working.md`, *A MALFORMED RECORD IS REPORTED, NOT GUESSED AT*), and by the standing practice an answer that builds is a
batch (JZ's).

**THE VERDICT: DONE — GREEN BUT FOR THE TWO CARRIED REDS, AFTER ONE REPAIR ROUND: THE FRESH READER's TWO WORDS IN THE STATE, READ GREEN BY ITS 46 READERS' REPLAY AND `check_de` OVER THE RUN's LOGS.**
- **Each elite's War Cry deals the type of the blow it took the place of at KJ**: the Antlered Huntmaster's nature, the Rimeclad
  Warlord's frost and the Drowned Thane's shadow; the Orc Chief's stays physical, as its Chieftain's Maul was (§1).
- **Rot Brand lays Branded for 4, so a hero pays on its next three turns**, and its card still reads *"for 3 turns"*; the intent
  hover says *"on that hero's next 3 turns"*, as a Silence's says its one (§2).
- **Item 9, *"As built"*, moved nothing**: War Cry keeps the Maul's 20 Rage and its 4.0 recovery, Skullsplitter its 3.5 and the
  four hex moves their 2.5.
- **Three gates repaired and three checks added**: `check_kj` §1 holds each War Cry to the type of the blow it replaced, read off
  the warband KJ kept, and §2 holds the card's typed figure to the laid count, ticks a Brand and a Silence as a turn start ticks
  them (the tick held ahead of the turn's action in `_run_battle`) and reads the Brand's hover (62 → 65); `check_kg` and
  `check_kh`, which held War Cry physical — the new text's reader found them, where the literal sweep could not — hold it in the
  kind's type (§1).
- **Lane B's floor, by KK's own reading**: two kinds of key in the enemy data that rules already in the tree govern — three War
  Crys' types and Rot Brand's turns — with Rot Brand's card text, and the hover's line for the status it lays; no kind added, no
  rule moved.
- **Back to the designer: no balance question opens at KK.** Three of KK's own readings are taken (NEEDS A RULING); KJ's items 1–8
  were not asked and stand owed.

## THE RECORD's FACTS, CHECKED AT SOURCE

Each fact the three questions carried, read at its source on HEAD `9b74926` (KJ) and at `16002ae` (KJ's parent) before an edit:

| # | The fact, as KJ's item put it | Read at | Holds? |
|---|---|---|---|
| 1 | *"Every War Cry is physical (`check_kj` §1 holds it)"* | `data/enemies.json`: the four War Crys carry no `dmg_type`; `check_kj` §1's `or wc.has("dmg_type")` | **Yes** |
| 2 | *"The Mauls it replaced struck in the zone's type — the Huntmaster's nature, the Warlord's frost, the Thane's shadow"* | `16002ae`'s kits and KJ's `edits/data_kj.py` map: the Chief's Chieftain's Maul untyped, the Huntmaster's **Antler Rend** nature, the Warlord's Avalanche Maul frost, the Thane's Barrow Maul shadow | **Partly**: the Huntmaster's blow was Antler Rend, not a Maul by name; the fourth, the Chief's, physical (KK's RULINGS OWED, item 1) |
| 3 | KG's *"The zone's"*, KH's *"Each copies its Orc"* | `docs/reports/KG.md` (the damage type *"The zone's"*), `docs/reports/KH.md` (*"Each copies its Orc"*; *"Nature, like the Forest"*) | **Yes** |
| 4 | *"Rot Brand lays Branded for 3"* | `data/enemies.json`: `{"id": "branded", "turns": 3}`; its card *"for {=@applies_status.turns} turns"* | **Yes** |
| 5 | *"a clock ticks at its bearer's turn start, so the hero pays on two turns"* | `scripts/battle.gd`, the unit's turn: `u.tick_statuses()` before it acts; `scripts/unit.gd`, `tick_statuses`: `b.turns -= 1`, then a status at 0 removed | **Yes** |
| 6 | *"a Silence, meant for one, is laid for 2"* | `data/enemies.json`, Choking Hex: `{"id": "silenced", "turns": 2}` | **Yes** |
| 7 | Item 11's *"Reversing it: one key"* | the card reads the laid count through its token, and `Classes.resolve_figures` reads a field or a field times a figure (`\{=([^{}*]+)(?:\*([^{}]+))?\}`), never a field less one; the hover printed `" for %d turn%s"` off the laid count | **No** — the key, the card's figure and the hover's line (KK's RULINGS OWED, items 2 and 3) |
| 8 | Item 9's figures: War Cry 20 Rage and 4.0, Skullsplitter 3.5, the hex moves 2.5 beside basics of 2.0 | `data/enemies.json` | **Yes** |

## §0 — WHAT THE ANSWERS DECIDE, AND WHAT THEY LEAVE

**Decided, the designer's**: War Cry in its Maul's type (item 10); a Brand laid for 4, three turns paid, as the card's words read
(item 11); the figures of item 9 as built. **KK's readings, taken** (NEEDS A RULING): the Chief's War Cry physical, the type of the
blow it replaced; the hover's line the turns a Brand binds; the card's 3 typed and held by a gate. **Out of scope**: every other
figure, the rest of KJ's RULINGS OWED (items 1–8, not asked), and the other statuses' lines on the hover — a laid count that is
the card's own, *"for N turns"*, as every card in the game says it.

## §1 — WAR CRY's TYPE

`data/enemies.json`: the Antlered Huntmaster's War Cry carries `"dmg_type": "nature"`, the Rimeclad Warlord's `"frost"` and the
Drowned Thane's `"shadow"`, each placed after `anim` as the elites' other typed blows carry it; the Orc Chief's carries none,
physical, as its Chieftain's Maul and its other blows. A War Cry is an ordinary blow with a status (no `special`), so the strike
path reads its type as it reads any blow's, and a hero's resistance to that type counts against it. `check_kj` §1 holds each War
Cry to the type of the blow it took the place of, read off the warband KJ kept (`Gate.warband_before_kj()`, its blow named in
`WAR_CRY_REPLACED`), a blow with no type key physical — the answer's rule, never a list of types — and prints the four.
**And two more gates held War Cry physical** (`edits/gate_kgkh_kk.py`): `check_kg` §1 wanted the Chief's untyped blow and §3 forced
*"physical"* on the Rimeclad Warlord and the Drowned Thane, and `check_kh` §1 and §3 did the same on the Antlered Huntmaster; §1
built its want at run time from the pattern's untyped blow and §3 forced *"physical"*, a literal whose count in the changed
files did not move, so the literal sweep could not see them. KK's new text's
reader found both. Repaired to their intent: War Cry keeps the Chief's name, and its type is the kind's, as the renamed blows'
(KG's *"The zone's"*, KH's nature) — the same checks, the same counts, their comments mended.

## §2 — A BRAND's THREE TURNS

**The data** (`data/enemies.json`): Rot Brand's `applies_status` is `{"id": "branded", "turns": 4}`, and its card reads *"Brands one
hero for 3 turns: each ability that hero uses costs it 6% of its maximum health"* — the figure typed where the token stood, because
the token reads the laid count and the token door cannot subtract (THE RECORD's FACTS, 7). **The hover** (`scripts/battle.gd`,
`_intent_hover_text`): the afflictions that bind their bearer's own turns are named once, `BEARER_TURN_STATUSES` (Silenced and
Branded), and the line says the turns bound, one fewer than laid, when it is laid for more than one (laid for one, it binds none and
keeps *"for 1 turn"*, which no card lays) — *"on that hero's next turn"* for a Silence, as since KJ, and
*"on that hero's next 3 turns"* for a Brand; every other status keeps *"for N turns"*, its laid count. **The gate** (`check_kj` §2):
Rot Brand's card states one turn fewer than Branded is laid for; a Brand laid as Rot Brand lays it, ticked by hand as a turn start
ticks it, stands on as many of its bearer's turns as the card states (3), and a Silence laid as Choking Hex lays it on one — and
`_run_battle`'s source holds the turn's tick ahead of the hero's action, so the order the count rests on is held, not assumed (the
new text's reader found the first form assumed it); and the hover reads *"Applies Branded on that hero's next 3 turns"*. The
Silence's hover line is `check_hz` §1a's. **Not built, and found**: the chip, and Fleeting (FOUND AT KK).

## WHAT ELSE MOVED

**The documents**: `docs/master.html` — the Branded row and its paragraph (laid for 4, its next three), the Blightcap's roster row
(*Branded 4t, its next 3 turns*), War Cry's paragraph (the elite's own type, named for each) and the three elites' rows (nature,
frost, shadow), the stamp; `docs/changelog.html`, KK's entry; `docs/design-notes.md`, KK's why; `docs/state.md` — KK's RULINGS
OWED and the core's row, KJ's RULINGS OWED's head and items 9–11 answered and built, its own index row, the WHERE, and the two lines
that called every War Cry physical (the Drowned Barrow's Thane note, the elites' rename note), and FOUND AT KK with its row. **The
gates**: `check_kj.gd` and its `baselines.json` row (62 → 65); `check_kg.gd` and `check_kh.gd`, their counts unmoved; the pin
manifest regenerated. **No rule written**: `CLAUDE.md` unmoved.

## §5 — VERIFICATION

**Lane B's floor, by KK's own reading** (`docs/instrument-rules.md`, *LANE B, CONTENT*): two kinds of key in the enemy data that
rules already in the tree govern, with Rot Brand's card text and the hover's line for the status it lays, no rule moved and no kind
added — it parses, it runs, the existing gates pass, the count, the push check, the landing and the two ceiling readings; the
documents the change made false named and mended (the master document's Branded row and paragraph, the Blightcap's row, War Cry's
paragraph and the three elites' rows; the state's two lines that called every War Cry physical, and KJ's items 9–11), and two
gates the new text's reader found holding War Cry physical, repaired. Beside the floor, as KK's own: the premises at source, the
literal sweep, the new text's reader, the controls, the read-backs and the fresh reader on the assembled report.
- **The push check**: `origin/class-merge` at `9b74926`, local HEAD, read at KJ's push, which opened KK, and again before the landing (`logs/push_preland.txt`).
- **The premises at source**: THE RECORD's FACTS, read on HEAD and at `16002ae` before the first edit script was written (`edits/game_kk.py`, 22:55:46, builds on
  them) — two of the eight
  did not hold as put (the Huntmaster's blow, *"one key"*).
- **The documents replayed from HEAD** by `edits/rebuild.sh` and `edits/build_final.sh` (KK's work folder), every anchor asserted
  once, the tree built fresh for every run; the landing behind the hash guard (below).
- **It parses**: `check_parse` 274 / 0 on the game half (`logs/k0`), after the reader's mends (`logs/k1`) and in the run of record,
  no `Parse Error` or `SCRIPT ERROR` in its stream.
- **It runs**: `check_kj` resolves a Branded hero's ability in a fight and ticks the Brand's clock as a turn start does, and reads
  the hover's line, on the built tree; the War Cry's type reaches the blow (`check_kg` §3 and `check_kh` §3 strike a hero who
  resists the type and one who does not, and red unless the resisted blow is under a quarter of the plain one).
- **The new text's reader**, before the run of record (`report/newtext_read.md`): 1 HIGH, 4 MEDIUM, 5 LOW, each read at source and
  settled — the two gates holding War Cry physical repaired, the Brand's check made to hold its order, the chip and Fleeting found
  and not fixed, five wordings mended (FOUND AT KK).
- **The literal sweep**, before the prediction (`tools/litsweep.py`; `logs/litsweep_D2.tsv`): the 30,592 literals the instruments
  hold, counted in the eleven files the candidate changes, at HEAD and in `lanes/D`: **0 LOST**, **57 GAINED** — the new words of
  `check_kj`, the War Crys' and the Brand's names in the documents, and the state's few new terms; each holder read before the run,
  and none holds an absence needle over the file that gained it (`check_el`'s *CLOCK* is the master document's §6c alone;
  the holders of `_player_turn` read `battle.gd`'s bodies).
- **The controls** (`tools/ctl_kk.py`, `tools/ctl_kk.sh`; every anchor dry-checked on the candidate first; the prediction
  `logs/ctl2.pred`; `logs/ctl2`): **all eleven bite**, each on its own clone, each read at its FAIL text — **K1–K6 on `check_kj`**:
  the Warlord's War Cry untyped (*rimeclad_warlord (physical, the blow it took the place of frost)*), Rot Brand laid for 3 (the card
  against the laid count, the ticked Brand binding two, and the hover), its card saying 4 (the same three), Branded off
  `BEARER_TURN_STATUSES` (the hover), Choking Hex laid for 3 (*a Silence 2*), and the turn's tick taken off `_run_battle`'s main path
  (*the turn's clock ticks before its action: false*); **K7 and K8 on the repaired `check_kg` and `check_kh`** (the Warlord's and the
  Huntmaster's War Cry untyped, §1 and §3 each); **and the other arms, HEAD's own gates on KK's code**: K0 `check_kj` 62 / 1 (§1, the
  three typed elites), K9 `check_kg` (§1 and §3, the Warlord's frost and the Thane's shadow), K10 `check_kh` (§1 and §3, the
  Huntmaster's nature). No throw in any arm; every line of the prediction held. (A first run of six, `logs/ctl`, on the tree before
  the reader's mends, bit the same way; its K2 redded the hover check too, a third red its prediction had not named.)
- **The run of record** (`logs/a1.out`; the prediction `logs/a1.pred` written 23:22:09, the launch at 23:22:14): the whole battery
  23:22:14 to 00:42:39 on `lanes/D`, frozen at 23:22:09 (9,554 files, `.godot/` aside; `lanes/D.md5`), the user's game not
  running, exit 0. **Every line of its prediction held but two figures, both the prediction's own**: every recorded target
  at its row, no throw, and no `Parse Error` or `SCRIPT ERROR` in any stream; the two carried reds and no other — `check_cm_live`
  13 / 5 (the brace bar, its coin; its row 4–5) and `check_gj` 70 / 1 (*the card says +179 gold and the purse moved 199*);
  `check_kj` 65 / 0 at its new row, `check_kg` 95 / 0 and `check_kh` 159 / 0 (repaired, their counts unmoved), `check_hz` 106 / 0,
  `check_parse` 274 / 0, `check_ed` 18 / 0, `check_gp` 431 / 0 (27 and 33 battles, each to zone 3 slot 17; about 200 s from
  `check_go`'s log to its own, inside its 480), `check_go` 369 / 0, `check_hl` 170 / 0, `check_io` 120 / 0, `check_jw` 62 / 0,
  `check_is` 96 / 0, `check_di` 44 / 0, `test_batch_ce` 934 / 0, `test_batch_bl` 88 / 0 and `test_batch_bu` 472 / 0; `check_de`
  **809 / 0 / 0, 197 of 197 recorded targets swept, none off its recorded line**. **The figures that missed**: the prediction named
  `check_iu` 185 / 0, copied from KJ's run, a Lane A batch's; it ran **169 / 0**, its row's Lane B count (the row is 169 to 185,
  §8 following the lane the *Last batch:* line names), and printed *"CHECKED KK: Lane B by the state's Last batch line, so no
  routing of record is owed"* — the gate at its row, the prediction wrong; and its line 1 put the regenerated manifest at
  2,466 pins, KJ's count, where KK's build printed 2,468 (`logs/build_D3.log`), `check_ed` 18 / 0 on it as predicted.
- **The repair round, the fresh reader's** (`tools/repair1_kk.sh`; `logs/r1.out`): the WHERE's two *"two keys"* mended to *"two
  kinds of key"* in `edits/where_kk.md`, the tree replayed from HEAD by `edits/build_final.sh` into `lanes/c1` (built 00:57:21),
  which differs from the run's `lanes/D` in `docs/state.md` alone (+16 B: the two mends, the fills after them — 531,385 B, 1.07
  KiB of room — and the WHERE's index row; the pin manifest the same 2,468), frozen 00:58:29 (`lanes/c1.md5`, 9,554 files). The
  literal sweep, D against c1 (`logs/litsweep_c1.tsv`): **0 LOST, 0 GAINED**, one count moved (*kind*, 162 to 164 in the state,
  on which no reader of the state redded: the replay below). The prediction (`logs/r1.pred`, written 00:58:37, the launch at 00:58:41): the 46 gates
  that name `docs/state.md` (`logs/r1_run.txt`, the census of c1, the same 46 as KJ's) replayed on three clones of c1, 00:58:41 to
  01:04:20 (`logs/r1`): **every one at its count in the run of record, no fail**, no `Parse Error` or `SCRIPT ERROR` —
  `check_iu` 169, `check_is` 96, `check_jw` 62, `check_kj` 65, `test_batch_aj` 213 (*"213 checks, 0 FAILED"*, a count form the
  subset's summary does not read; `check_de` reads it); then `check_de` over the run's logs with these 46 in place
  (`logs/r1de`; `logs/r1_de.log`): **809 / 0 / 0, 197 of 197 recorded targets swept, none off its recorded line**. Every line of
  the prediction held.
- **The read-backs**: at 00:43:13, after the run of record (`tools/readback_kk.sh`; `logs/readback_a1.txt`, taken again at
  00:43:55): `lanes/D` at its 9,554 md5s, none differing; the player's 87 files at the md5s taken at 22:55, none differing; 623
  user-data folders then and now; the boot time unchanged. **And at 01:04:44, after the repair round**
  (`tools/readback_c1_kk.sh`; `logs/readback_r1.txt`): `lanes/c1` at its 9,554 md5s, none differing; the player's 87 files, none
  differing; 623 user-data folders; the boot time unchanged.
- **The fresh reader of the assembled report**: a general-purpose reader on the report as assembled at 00:44:17 (`report/KK_assembled.md`, before these mends), briefed to check it against the logs, the trees and HEAD — read-only, no Godot, no git in the frozen lane, the player's folder off limits: about 130 claims checked, **no HIGH**, 4 MEDIUM and 5 LOW, each read at source and settled — the WHERE's two *"two keys"* mended by the repair round, and eight of this report's sentences mended (FOUND AT KK).
- **The listing gates, on a clone with this report in** (`tools/listing_kk.sh`, `lanes/lst`, a clone of `lanes/c1`; `logs/lst`;
  the prediction `logs/lst3.pred` written 01:08:16, the launch at 01:08:20, done 01:10:30; `logs/lst.out`), on the tree that lands
  with this report as assembled, its listing sentence not yet filled: **every gate at its row, as predicted** — `check_jt` 4 / 0
  (*195 reports listed, CW to KK*, the newest KK.md, its closing block naming the four sections), and `check_jc` 70, `check_is` 96,
  `check_iu` 169, `check_jr` 87, `check_hx` 42, `check_jo` 54, `check_jp` 33, `check_fr` 25, `check_jv` 92, `check_jw` 62,
  `check_jx` 37, `check_di` 44, `check_jl` 62 and `check_kj` 65, each with no fail, and no `Parse Error` or `SCRIPT ERROR` in any
  log. **A first listing**, at 01:05:22 (`logs/lst2.pred`, `logs/lst_1`), redded `check_jr` §2 once — *a report spells a line
  number another way — 66, above the 65 held*: two line numbers this report gave the WHERE's mended lines in FOUND AT KK, copied
  from the fresh reader's citation; taken out, the sentence names the lines in words, and every other gate held as the rerun's.
  (The listing's first prediction, `logs/lst.pred` at 00:45:35, named `lanes/D`, before the repair round made `lanes/c1` the tree
  that lands.) This sentence, filled after the run, swept against the copy the gates read (`logs/litsweep_lst.tsv`): **0 LOST, 0
  GAINED**, 48 counts moved by its own words.
- **The two ceiling readings**: `CLAUDE.md` 529,587 B at the open and at the close (+0, KK wrote no rule), 62.83 KiB under its 580;
  `docs/state.md` 527,754 B at the open and 531,385 B at the close (+3,631: KK's RULINGS OWED, FOUND AT KK and their
  rows, the WHERE, KJ's items 9–11 answered), **1.07 KiB under its 520**, nothing archived — **and that room is thin**: the
  WHERE's projection says KL, at JG's rate, opens with an archive (`docs/instrument-rules.md`'s condition).
- **The landing**: `tools/land_kk.py`, behind IW's hash guard: the eleven files of the landing tree's own diff from HEAD
  (`lanes/c1`, the repair round's, frozen 00:58:29, `lanes/c1.md5`; `tools/land_list_kk.txt`, `project.godot` aside, asserted
  equal to the diff — the eleven names of the sweep's file list, `logs/litsweep_D2.files`, written 23:17:39, before the run's
  freeze; the landing list was copied from it at 23:22:22, after the freeze, with no git run in the lane), each copied only where
  the repository held HEAD's bytes and the tree's bytes were those the freeze recorded; no gate's code names this report by its
  path; and this report last, after its landing check — no unsubstituted token, the last heading WHAT THE NEXT DECISION RECORD
  OWES, the four sections named.

## FOUND AT KK

- **TWO GATES HELD WAR CRY PHYSICAL, AND THE LITERAL SWEEP COULD NOT SEE THEM** (the new text's reader, before the run of record;
  `report/newtext_read.md` in KK's work folder): `check_kg` §1 and §3 and `check_kh` §1 and §3 built their want from the pattern's
  untyped blow, or forced *"physical"*, so KK's data would have redded them six times on the first run; no literal moved, so the
  sweep's GAINED list held nothing of theirs. **Repaired to their intent** (§1), each with a control on the repaired gate and one
  on HEAD's (K7–K10). **What it shows**: a census of a change's readers by literal misses the gates that build a want at run time
  from data — the shape KJ's acceptance met in `check_hz`, met here before the run.
- **THE BRAND's CHECK ASSUMED THE ORDER IT COUNTS ON** (the same reader): it ticked the clock by hand, so a tick moved after the
  action would have left it green. It holds the order in `_run_battle`'s source now (K6). And five wordings, mended: the design
  note's credit for the Huntmaster (KH's, not KG's), two of the changelog's sentences, the WHERE's *"two keys"* on its *Last
  batch:* line, the gate's *"the
  hover says them"* and §1's empty name.
- **Not fixed, in the state's FOUND AT KK**: **a Brand's and a Silence's chip count the clock** — from the moment either lands
  until the hero's turn begins, the chip's tooltip reads the laid turns left (four on a Brand that binds three, two on a Silence
  that binds one), and the turns bound from that turn on; the chip's words are the designer's. **Fleeting takes a Brand's turns
  and the hover does not know** — Fleeting cuts every timed status by its figure, never under one, so on a Fleeting fight a Brand
  lands for one and binds none, and a Silence likewise, while the hover reads the data's count less one.
- **THE WHERE STILL SAID *"TWO KEYS"* TWICE** (the fresh reader of the assembled report, after the run of record): the sim's
  line and the projection's in the WHERE, KK's own new words, where KK touched three keys — the three War Crys'
  `dmg_type`, Rot Brand's `turns` and its card text. **Mended** to *"two kinds of key"*, the *Last batch:* line's words, by a
  repair round (§5): the state's 46 readers replayed and `check_de` over the run's logs. And in this report, eight of its own
  sentences: the prediction's second missed figure (the manifest's pins), the landing list's time, the wordings' count, the
  closing block's *"two keys"*, two sentences that called the readings open and taken, the hover's one-turn case, the push check's
  record and the premises' order — each mended here. No HIGH: no false claim about the game, the gates or the result.

## NEEDS A RULING — NO BALANCE QUESTION OPENS; THREE OF KK's OWN READINGS, TAKEN, NONE A FIGURE

1. **THE CHIEF's WAR CRY STAYS PHYSICAL.** *"Its Maul's type"* is read as the type of the blow each War Cry took the place of, off
   the warband KJ kept: the Orc Chief's Chieftain's Maul carried no type key, so its War Cry carries none and is physical, as the
   Chief's other blows; the Huntmaster's blow was Antler Rend, not a Maul by name, and its nature is the type taken. **The
   alternative**: a type for the Chief's War Cry, which no blow of the Chief ever had. **Reversing it**: a key.
2. **THE HOVER SAYS THE TURNS A BRAND BINDS, AS IT SAYS A SILENCE's.** The answer kept the card's words, *"for 3 turns"*; laid for
   4, the hover's *"for 4 turns"* would stand beside them — the card-against-hover shape KJ mended for a Silence. So the hover names
   the turns bound for both afflictions that bind their bearer's own turns (`battle.BEARER_TURN_STATUSES`). **The alternative**: the
   laid count on the hover, beside the card's three. **Reversing it**: a name off the list.
3. **ROT BRAND's CARD TYPES ITS 3, AND `check_kj` HOLDS IT.** A token reads the laid count and the token door never subtracts, so
   the card's figure is typed, and `check_kj` §2 holds it to the laid count and to a driven Brand (II §0.7: a text's number read off
   the code, or an instrument that asserts the two agree). **The alternative**: a `figure_` count on `Battle`, or a token that
   subtracts — code no answer asked for. **Reversing it**: the token back, which would print the laid 4.

## THE CHECKS THIS REPORT NAMES FOR RETIREMENT

**None new.** KK ran Lane B's floor. **What found KK's findings, by step**: the premises at source found the Huntmaster's replaced
blow named Antler Rend and item 11's *"one key"* three things; the new text's reader found two gates holding War Cry physical, the Brand's check assuming its order, the chip and Fleeting, and five wordings; the controls proved each new or repaired check reds on the defect it names, and HEAD's own gates red on KK's code. The run of record found nothing new: it redded only the two carried bands, and the two figures it missed were the prediction's own (`check_iu`'s Lane B count, the manifest's pins). The fresh reader of the assembled report found the WHERE's two *"two keys"*, mended by the repair round, and eight of this report's own sentences.

**Named apart, whose silence is their work** (JT §2): the push check, the two readings, the freeze and the hash guard.

## WHAT THE NEXT DECISION RECORD OWES

1. **The lane, declared** — A, B or C (`docs/ways-of-working.md`); KK ran Lane B's floor by its own reading (`docs/instrument-rules.md`,
   *LANE B, CONTENT*): two kinds of key in the enemy data that rules already in the tree govern, with Rot Brand's card text, and the
   hover's line for the status one of them lays; no kind added, no rule moved.
2. **What was decided, and what is out of scope** — War Cry in its Maul's type, a Brand laid for 4 with three turns paid, item 9's
   figures as built: each the designer's, built. **Out of scope at KK**: every other figure; KJ's items 1–8; the other statuses'
   hover lines. **Still open, the designer's**: KJ's RULINGS OWED items 1–8 (the three carrierless hexes first); KK's three
   readings, each taken and open to the designer's word; KI's item 1; the two look-list rows left NOT YET (FOUND AT KF); and the designer's play of the rework.
3. **What it was written from** — the designer's three answers and the questions as put (`report/answers_9_11.md`, KJ's work
   folder); `docs/reports/KJ.md`'s NEEDS A RULING, items 9–11; `docs/reports/KG.md` and `docs/reports/KH.md` (the types);
   `data/enemies.json` at `9b74926` and `16002ae`; every fact about the code as a file, a function and a quoted line (THE RECORD's
   FACTS).
4. **The open questions, both branches decided** — none of KK's own stands open; its three readings are taken (NEEDS A RULING).
5. **Not to get wrong**: **a status laid for N binds N−1 of its bearer's own turns** — its clock ticks at the bearer's turn start,
   before it acts — so a card that names the turns it binds owes a typed figure and an instrument, as Rot Brand's does, and a new
   affliction that binds its bearer's turns joins `BEARER_TURN_STATUSES`; **the token door never subtracts**; **a War Cry's type
   is the blow it replaced**, read off the warband KJ kept; and **a gate can build its want from the data at run time**
   (`check_kg` and `check_kh` did for War Cry's type), which no literal sweep sees — grep the gates for the fact a change moves,
   not only for its words.
