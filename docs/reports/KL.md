# Batch KL — A Passive Shows Itself, Blood Tribute a Passive, and a Ready Move First

**THE RECORD ARRIVED AS THE DESIGNER's PLAYTEST MESSAGE, NOT AS A DECISION RECORD, SAID HERE FIRST**: after playing KK's build
(`6c116af`) on 28 November, the designer wrote ten things in one message — kept verbatim in `RECORD_KL.md` in KL's work folder,
typos and all. KL read each item at source before asking anything (THE RECORD's FACTS). Four questions, then a fifth and a sixth, went to
the designer with their options, the recommendation first, each option's claims read at source before it was put (the options as put: `RECORD_KL.md`). The designer chose the
recommendation each time. The record names no lane; KL ran **Lane A** by its own reading, its floor with three steps not as the
floor asks — the routing and the close-read late, the positional reads not run (§5) (a rule moved: a passive in a
move's place, a passive shown three ways, a ready move before the basic; a kind taken out of the data; a new gate), and by the
standing practice an answer that builds is a batch (JZ's).

**THE VERDICT: DONE — GREEN BUT FOR THE TWO CARRIED REDS, AFTER ONE REPAIR ROUND: THE RUN OF RECORD, `check_de` 813 / 0 OVER ITS 198 RECORDED TARGETS, NINETEEN CONTROLS BITING, AND THE FRESH READER's AND THE CLOSE-READ's WORDS IN THE LANDING TREE READ GREEN BY THEIR 51 READERS' REPLAY. THE POSITIONAL READS WERE NOT RUN (§5).**
- **Blood Tribute is the Orc Bloodcaller's passive, not an attack** (answer 1): each fall of its warband gives its attacks 25% more
  damage and Break for the rest of the fight — counted as it falls, a Raise taking none back, by KL's reading (NEEDS A RULING 2);
  its 44-damage shadow blow is gone.
  **A passive takes a move's place**: a tier-N kind carries N moves and passives (§1).
- **A passive shows itself** — the designer's three ways: a line in the combat log, its name floating over the body it works on,
  and a chip on the body it works through; their reach to all twelve recipe combos is KL's reading (NEEDS A RULING 1) (§2). **Pack Tactics was never broken**: it
  worked and said nothing (THE RECORD's FACTS).
- **A ready move comes before the basic** (answer 4), a move with no cooldown mixed with the basic (answer 6), and **Blood in the
  Water reads the designer's words**: every enemy of the fight goes for the hero with the weakest health as its blow lands, no
  taunt pulls it, and a Singled Out hero still draws it (answer 3) (§3).
- **The Orc Slinger is gone and the Orc Archer stands in its place**; **Cinder Cleave strikes two heroes and burns each for 3
  turns**, the Tyrant's other waits kept (answer 5); **Entomb lays a Chilled stack**, not a freeze (answer 2) (§4).
- **No zone was mixed up**: every Frozen Plains kind fields only in the Frozen Plains (0 of 8,537 bodies off their zone); the zone
  wore the Forest of Old's art. It and the Drowned Barrow are tinted now (THE ZONES).
- **Back to the designer: no balance question stays open.** Six answers built; KL's six readings taken (NEEDS A RULING).

## THE RECORD's FACTS, CHECKED AT SOURCE

Read on HEAD (`6c116af`) before any question was put, by probes in scratch lanes (`lanes/p1`, `lanes/p2` in KL's work folder;
`logs/p1_sim.log`, `logs/p2_probe.log`).

| # | The designer's words | At source |
|---|---|---|
| 1 | *"there was no indication that blood tribute ever activated"* | Blood Tribute was a 44-damage shadow move, cooldown 2, +25% for each fallen body; its log line printed only once a body had fallen, and nothing marked the Bloodcaller. |
| 5 | *"it seems that enemies are only using one type of attack"* | Three simulated runs, 765 warband actions: the tier-1 kinds (nine at the probe, eight since KL) carry one move by KJ's tier rule and field most bodies, so a ready move first changes nothing for them; a tier-2 or higher kind used its basic about three times in four, a random pick among its ready blows. No defect: the tier rule and the basic's share. KL's option to give tier 1 a second move went unpicked (`RECORD_KL.md`, the options as put). |
| 7 | *"Pack Tactics effect doesnt seem to be working"* | It worked: a raider's Slash averaged 39.9 with three fellows standing and 32.5 alone (×1.23; the multiplier reads 1.24). It printed nothing, wore nothing and floated nothing. |
| 9 | *"hailcaster, rimeclad warlord, frostbitten thrall, and steelveil matron appeared in the forest of old … the forest of olf and forzen waste enemies are mixted up"* | 30 seeded runs, every map node of every stage: 8,537 bodies, **0** off their zone's roster; the zone's name and roster always agree. The Frozen Plains (the designer's *frozen wastes*) wore the Forest's picture on the map, the events and in battle — a named placeholder since JS. |
| 10 | *"the icewroght tyrants entomb is applying dazed instead of a chilled stack"* | Entomb (the Icewrought Titan's) froze the hero it struck for one turn, as its card said — cast on each of the four in turn — and laid no Dazed. Among the zone's kinds, Dazed is the Hailcaster's Hailstone bite (30%, 2 turns), and a Hailcaster can escort the Titan. |
| 8 | *"the ash wrought titans cinder cleave"* | The data's Ash-Wrought Tyrant carries Cinder Cleave (its basic, 30 fire). |

## §0 — WHAT THE ANSWERS DECIDE, AND WHAT THEY LEAVE

The designer's own words decided items 1–4, 6 and 8 (`RECORD_KL.md`). Put as questions, after the probes: **1** *"+25% a
fall"*; **2** *"One Chilled stack"*; **3** *"War Cry's mark wins"*; **4** *"Ready move first"*; and, once the blocks' reader found
that Cinder Cleave's Burn moves the cooldown line for the Tyrant's other three moves, **5** *"Keep today's waits"*; once the new
text's reader found that the Hollow Crown's Sundering Decree, which has no cooldown, would always come first, **6** *"Mix it with
the basic"*. **Left to
KL's own readings, none a figure** (NEEDS A RULING): which passives show themselves; how a fall is counted; how the Cleave picks
its second hero; what a taunt does under Blood in the Water; what the basic is; the saved Slinger; the tint.

## §1 — BLOOD TRIBUTE, A PASSIVE IN A MOVE's PLACE

`data/enemies.json` gains a `passives` key: the Bloodcaller's moves are Ragged Cut alone, and its passive Blood Tribute. Its card
text keeps the clause `check_ij` §2e holds (*"Grows stronger for every one of its warband fallen this battle"*). Each fall of its
warband adds `BLOOD_TRIBUTE_PCT` (0.25) to its attacks' damage, in the strike loop beside Rally, and to their Break, at
`_resolve`'s head; `_kl_tribute` counts the falls as they come through `_on_unit_died`, so a Raise takes none back and a raised
body that falls again feeds it again (answer 1's *"for the rest of the fight"*). The old `blood_tribute` arm of `_resolve_special`
and its entry in `Ability.DAMAGE_SPECIALS` are gone. **The tier rule counts moves and passives** (`CLAUDE.md`'s new block A
PASSIVE SHOWS ITSELF; `check_kj` §1 repaired, `check_kl` §1).

## §2 — A PASSIVE SHOWS ITSELF

One door in `scripts/battle.gd`: `_kl_fired` writes the log's line and floats the passive's name over the body — a steady float
(`float_text`'s new `steady`), which draws no die, so a float never moves a seeded fight; `_kl_refresh_passives` lays or takes off
each body's chips at the fight's start, at every death and Raise and at each turn's start. **Blood Tribute** wears its *+N%* from
the start. **Every combo** wears a chip on the bodies it works through, reading what it gives them now (Pack Tactics' *+24%* with
four standing, Bodyguards' *off* when the tanks are down, The Rite's count), and fires as it raises or cuts a blow (Combined Arms,
Pack Tactics, Alpha, Compounding Curse, Focus Fire, Bodyguards, Interlocked Shields, Loyal Retinue), draws one (Blood in the
Water) or raises a heal (Field Medic); Static Charge, The Rite and Alpha's Daze, which logged already, float beside their lines.

## §3 — THE WARBAND's CHOICES

**A ready move before the basic** (`_choose_enemy_action`): a body uses a move that cools, other than its kit's first, whenever one
is ready and paid for, at random among them, and otherwise picks at random between its basic and any move with no cooldown
(answer 6: the Hollow Crown's Sundering Decree, from rung 2, has none); the Break-exploit branch (the hardest ready hit on a Broken
hero) stands. **Blood in the Water** (Rage Company): the hover reads *"All enemies attack the target with the weakest health,
regardless of taunts. A Singled Out hero still draws them."*; `_kj_aim` sends every body at the hero with the lowest share of its
health, with no 50% threshold, and `_kl_blood_water_aim` takes that aim again as the blow lands, so a blow declared at a hero
who has fallen since goes at the next weakest; no taunt pulls a body of it — Mocked, Savage Presence and the Stalking Horse are skipped, and a
taunted body casts its support and buys its spend as if untaunted — and a Singled Out hero still draws every blow (answer 3).

## §4 — THE KINDS AND MOVES THE DESIGNER NAMED

**The Orc Slinger is gone** (roster 2); `Enemies.RETIRED` maps it to the Orc Archer at the config and at the load, so a saved map
or encounter that names one fields an archer. **Cinder Cleave** carries `choose_two` and Burn for 3 turns: it strikes its target
and a second hero at random, each for the full blow, the Fen Lurker's Swipe's way, and burns each always. Its Burn prices the
Tyrant's basic at 56.3 on `check_ji`'s line (38.3 before), so the line would move Immolating Wave 4 → 3, Tyrant's Verdict 2 → 0
and his Rally 3 → 2; **the designer kept the three** (answer 5), held in `check_ji`'s `HELD` beside the four JO held, and in the
kept table `docs/reports/JO-held.tsv`, beside the thirteen held before (four of them in the game). **Entomb** lays one Chilled stack for 3 turns (answer 2): Hallowed refuses it, Ironclad
does not, and four stacks freeze a hero as any pile does (FOUND AT KL).

## THE ZONES ON THE FOREST's ART

`Run.PLACEHOLDER_TINT` tints the Frozen Plains blue and the Drowned Barrow green on the map, the event screen and in battle, so
neither is taken for the Forest of Old until their art exists.

## WHAT ELSE MOVED

- **Gates repaired, each to its rule's new intent** (`edits/gate_kl.py`): `check_kj` §1 (moves and passives) and §3 (the weakest,
  no threshold); `check_js` §1's record, §2's retired kind and §3 (Entomb's chill: it lands, a Block, a miss and Hallowed stop it,
  Ironclad does not, a cleanse lifts it, it costs no turn); `check_jk` §1 and `check_jp` §0 and §1 (a kind retired since, set
  aside as a kind added since is); `check_kh` §2 (the same, by `Enemies.RETIRED`); `check_jl` §2 and `check_jo` §2 (a ready move
  first); `check_jn` §1 (a held band); `check_hs` §2b (a body's display chips are no status's); `check_jw` §4's census (three new
  sites, Blood Tribute's old one gone).
- **Stale `.gd` comments mended**: Entomb's freeze in `_hold_freeze`'s note, the Bloodcaller in two comments, three over
  `_choose_enemy_action` that said its policy never moved, Heads Down's two (its policy, the count of abilities that cost zero).
- **`docs/combat-rules.md`'s intent block** says KL moved the selection's policy, by the designer's answers.
- **Censuses**: `check_jw` §4's census of the battle's reads of the warband (three sites in, Blood Tribute's out), `check_is` §4's
  hero-side pools (the aim's), `check_iu` §2's rules census (KL-001, KL-002), `check_hx`'s known blocks.

## §5 — VERIFICATION

**Lane A's floor** (`docs/instrument-rules.md`, *LANE A, STRUCTURAL — THE WHOLE FLOOR*; KL is Lane A by its own reading: a rule
moved — a passive in a move's place, a passive shown three ways, a ready move before the basic — a kind taken out of the data, and
a new gate), each step and where it stood — **three not as the floor asks, said first**:
- **The routing of record, late** (`docs/reports/KL-routing.md`): the subjects at 13:10, matched against HEAD's state, after the
  game half was built and its lane frozen for the recon (13:08) — the floor asks for the routing before any edit and the blocks'
  reader before the first edit reaches a lane — and before any document was written; the cut 63 blocks, 270,571 B; **the blocks'
  reader** (`report/blocks_reader.md`, 13:27): 53 findings — 23 HIGH, 19 MEDIUM, 11 LOW — and three blocks outside the cut, every
  count re-derived from the tree; mended from its quotes (`edits/state_kl.py`) but four set aside: rows 4, 32 and 33, LOW, for the
  file's room, and row 34, the look-list's word, still the designer's. It found the Tyrant's three bands moving on the line, which
  went to the designer as answer 5.
- **The close-read, late**: taken after the run of record, once the fresh reader found it missing — a reader on the 105 blocks the
  routing did not open (`report/close_cut.md`, 190,501 B), each read whole against the finished work (`report/close_read.md`): none
  stale but two — FOUND AT JL's float that draws a die (a passive's does not, since KL) and FOUND AT JZ's blow-rate reading owed on
  *KJ's* warband (now KL's), each mended in the landing tree (the repair round, below) — and one HIGH-grade claim, FOUND AT JK's
  *Blood Tribute counts the bodies down*, already mended by the blocks' reader's round.
- **The positional reads: not run at KL**, as they were not at KJ — the floor's *all the positional reads* (JF §6's re-run of
  every positional read) has no record in KL's work folder. **Owed, and named here so it is not taken for done.**
- **The push check**: `origin/class-merge` at `6c116af`, local HEAD, at KK's push, which opened KL (KK's record), and read again
  at 18:19:41 (`logs/push_check.txt`) and before the landing (`logs/push_preland.txt`).
- **The premises at source** (THE RECORD's FACTS): read on HEAD by two scratch probes before any question was put (`logs/p1_sim.log`,
  `logs/p2_probe.log`); four of the designer's readings did not hold as put (Entomb's Dazed, Pack Tactics broken, the zones mixed,
  one attack a body — the last half true, by the tier rule). A first sim launch ran the main menu with no scene and was killed at
  24 minutes, its wrapper and then its child; the relaunch on the battle scene ran.
- **The documents replayed from HEAD** by `edits/rebuild.sh` and `edits/build_final.sh`, every anchor asserted once, the tree
  built fresh for every run; the landing behind the hash guard (below).
- **The recon** (`logs/r0.out`, `logs/r0out`: the code half on HEAD's documents, 13:08 to 14:29): **eleven gates red beside the two
  carried** — `check_hs`, `check_ij`, `check_ji`, `check_jk`, `check_jl`, `check_jn`, `check_jo`, `check_jp`, `check_js`, `check_jw`
  and `check_kh`: ten owed a repair to KL's rules (the gates that count the warband's kinds or read the Slinger, the ready move's
  needles, the Tyrant's bands, Entomb's freeze, the census of the battle's reads, a Rupture's chip count), and `check_ij` §2e found
  KL's own Blood Tribute card dropping a clause it holds, mended in the data; `check_de` 809 / 13 — those eleven and two rows that
  fell (`check_ji`, `test_batch_bm`) — and three notices of rows that rose (`check_gp`, `check_ij`, `check_parse`). The recon was
  also the HEAD arm of every gate KL repaired: HEAD's copy redding on KL's code, at the FAIL text its repair answers.
- **The new text's reader** (`report/newtext_read.md`, on the tree of 14:30): 3 HIGH, 7 MEDIUM, 14 LOW — Blood in the Water's aim
  lost when its hero fell before the blow (re-aimed as the blow lands since), `check_js`'s repaired list missing the freeze the kept
  warband still lays, `docs/combat-rules.md`'s promise; the Hollow Crown's Sundering Decree, which went to the designer as answer 6;
  floats over bodies that wore no chip; each mended, or recorded in FOUND AT KL.
- **The subsets** on the built tree (`logs/s1` to `logs/s5`): every gate of the battery's list and two suites at s1 and s2, three
  clones each; at s3 to s5 the reds' gates. The reds they found, each closed: `check_js` §2 (the repaired list), `check_hx` §1c and
  `check_iu` §2 (the new block's population and its census rows), `check_is` §4, §5 and §6 (the aim's pool, a long index row, a batch
  named in master's text), `check_ji` §1f (master's cooling list naming Cinder Cleave), `check_jn` §0 (the archive's first find under
  a reused heading) and §1, `check_jw` §4 (the aim's site), and `check_kl` §4 twice — the aim returning the fallen hero at s2, a
  wrong unit name in its own needle at s3.
- **The literal sweep** over the final tree (`tools/litsweep.py`; `logs/litsweep_D6.tsv`): the 30,683 literals the instruments hold, counted in 21 of the 35 files the candidate changes (every one but the gates and the pin manifest), at HEAD and in `lanes/D`:
  **8 LOST**, **367 GAINED**. Each LOST read at its holders: *frozen*, *lost* and *slinger* left `data/enemies.json` with Entomb's
  freeze, its card and the Slinger — every holder reads them as a status id, a word of its own or a kind it sets aside, and the
  repaired gates set the Slinger aside by name; *blood_tribute* left `Ability.DAMAGE_SPECIALS`, held by `check_kl` alone, which asks
  that no move carries it; *_run_battle*, *_intent_category*, *not kill* and *next 3* left the state with the archived items, and
  no holder reads them there (each names a function, a card's text or a hero's card). The GAINED, the new words, were read by the run
  of record, all green.
- **The controls** (`tools/ctl_kl.py`, `tools/ctl_kl.sh`, a watchdog on each; sixteen arms' anchors dry-checked on the candidate
  before its last build, the output not kept; none failed to patch on its clone of the run tree; the prediction `logs/ctl.pred`;
  `logs/ctl`): **all nineteen bite**, each on its own clone, each read at its FAIL text — **K1–K10 and
  K17–K19 on `check_kl`**: the Bloodcaller's passive taken off (§1, §2), the old fallen count (*a Raise took a fall back*), Pack
  Tactics silent (§3), taunts back under Blood in the Water and Singled Out after the weakest (§4), the old random pick (§5),
  Cinder Cleave on one (§1, §6), Entomb's freeze (§1, §6), no battle tint (§7), no save repair (§1), the re-aim broken and its call
  taken out (§4), a no-cooldown move first again (§5); **K11 on the repaired `check_js`** (Entomb's freeze, §3), **K13 and K16 on
  `check_ji` and `check_jk`** without the Tyrant's holds (§1a, §2), **K14 on the repaired `check_kj`** (the passive off, §1); **and
  the other arms, HEAD's own gates on KL's code**: K12 `check_js` (§3: no freeze of one turn), K15 `check_kj` (§1, the Bloodcaller's
  one move; its §3 reads a constant KL took out, a script error there, and the gate ended on its own at 24 s). A first pass's three misses — K8, K13 and K16
  — were wants written without the backslash a printed array puts before an apostrophe; each had bitten, and the three re-ran clean
  (`logs/ctl_b.out`). **What the controls do not cover**: the repaired copies of `check_kj` §3, `check_js` §1 and §2, `check_jk`
  §1, `check_jp`, `check_kh`, `check_jl`, `check_jo`, `check_jn`, `check_hs`, `check_jw` and the three censuses have no arm of their
  own; their HEAD arms are the recon's reds.
- **The run of record** (`logs/a1.out`, `logs/a1out`; launched 16:33:03 on `lanes/D` as frozen at 16:32:49, `lanes/D.md5`, 9,575
  files; ended 17:54): **green but for the two carried reds** — `check_cm_live` 13 / 5 (its band) and `check_gj` 70 / 1 (its
  sanctioned §4), each as at KK; **`check_de` 813 / 0, no notice, 198 of 198 recorded targets at their rows** (199 run, `check_de` among them), `check_kl`'s new row of 47 and
  the four rows KL moved among them (`check_gp` 452, `check_ji` 109, `test_batch_bm` 800, `check_parse` 275). Every line of the
  prediction (`logs/a1.pred`, written 16:32:58) held, `check_iu` 185 on Lane A among them.
- **The read-backs** (`logs/readback_a1.txt`, 17:55:09): the frozen tree at its 9,575 md5s, none differing; the player's 87
  files at the md5s KL read before its run of record (`userdata_open_md5.txt` — read at 15:43:53, mid-batch: against KK's close, two changed, two
  added and two gone, by the designer's own play that opened KL; no lane runs under the live name), none differing; 623
  user-data folders, as KK left them; no reboot.
- **The repair round** (`tools/repair1_kl.sh`; the prediction `logs/r1.pred`; `logs/r1`, `logs/r1de`): the landing tree `lanes/c1`
  (built 18:30:43, frozen 18:30:58, `lanes/c1.md5`) differs from the run's in three files — the state's two close-read lines, the
  routing record's answers and order, `docs/combat-rules.md`'s KL bullet — swept with **0 literals lost that any reader holds**
  (`logs/litsweep_c1.tsv`: *five* and *green* left the routing record, held by no gate that reads it); **the 51 gates that read
  any of the three files**, each green at its run-of-record count (18:31:52 to 18:38:05; `check_de`, which the list also caught,
  ran apart on no logs and is read below), then `check_de` over the run's logs with the 51 in place: **813 / 0, no notice, 198 of
  198 recorded targets at their rows**.
- **The fresh reader of the assembled report**: as assembled at 17:55:27 (`report/fresh_read.md`): about 160 claims checked, **3 HIGH, 14 MEDIUM, 12 LOW** — the floor claimed
  whole without the close-read and the positional reads (the close-read taken since, the positional reads named as not run),
  the recon's reds miscounted, the controls' reach overstated; and the routing's late order, the count of targets, the
  watchdog, the push check unrecorded, two credits to the designer that were KL's, and the record and two documents left saying
  *five answers* or the policy *untouched*. Every one read at source and mended in this report, two in the landing tree (the
  routing record's answers and its order; `docs/combat-rules.md`'s KL bullet), and the options as put written into `RECORD_KL.md`.
- **The listing** (`tools/listing_kl.sh`; the prediction `logs/lst.pred`; `logs/lst`, 18:41:19): the sixteen gates that list
  `docs/reports` or read the newest report, on a clone of the landing tree with this report in, as it stood before its last two
  parts — every one green at its run-of-record count: `check_jt` reads 196 reports, CW to KL, the newest ending on its closing
  block; `check_jr` §2's line-number ceilings held (the report carries none of its spellings). The two parts written after it,
  swept against the copy it read (`logs/litsweep_lst.tsv`: 0 lost, six common words gained), and the listing run again on this
  report as it lands (18:44:49, `logs/lst_final.out`): all sixteen green.
- **The two ceiling readings**: `CLAUDE.md` 529,587 B at the open and 530,945 B at the close (+1,358 B, A PASSIVE SHOWS
  ITSELF), 61.50 KiB under its 580; `docs/state.md` 531,385 B at the open and 531,738 B at the close (+353 B net:
  5,049 B archived — KJ's items 9–11, three items of FOUND AT JN, FOUND AT JS's freeze edges — and 5,402 B written), **0.72
  KiB under its 520**, not raised — and thinner than KK's, so a batch that would overrun it archives what its own rulings close (the
  state's words).
- **The landing**: `tools/land_kl.py`, behind IW's hash guard: the 35 files of the landing tree's own diff from HEAD (`lanes/c1`,
  frozen 18:30:58, `lanes/c1.md5`; `tools/land_list_kl.txt`, `project.godot` aside, asserted equal to the diff), each copied only
  where the repository held HEAD's bytes and the tree's bytes were those the freeze recorded; no gate's code names this report by
  its path; and this report last, after its landing check — no unsubstituted token, the last heading WHAT THE NEXT DECISION RECORD
  OWES, the four sections named. The push check read `origin/class-merge` at `6c116af`, local HEAD, at 18:41:31 (`logs/push_preland.txt`).

## FOUND AT KL

- **FOUR CHILLED STACKS STILL FREEZE A HERO** — Entomb's stack piles with any other chill on him, and the fourth freezes him
  through `_hold_freeze`, an ordinary freeze, as every pile does.
- **THE LINE PRICES NO SECOND TARGET** — `check_ji.line_blow` reads Cinder Cleave's Burn and not its second hero, as it reads none of
  Swipe's; the Tyrant's three holds stand on that reading.
- **A TAUNT's WORDS PROMISE A PULL BLOOD IN THE WATER REFUSES** — Mocked's hover, Mocking Blow's and Goading Roar's cards (whose
  cut still pays), and the bots still taunt there; an evasion has no other hero to move a blow to, as under a Singled Out hero.
- *The run of record found nothing new: it redded only the two carried bands. What came after it was the readers': the fresh
  reader's findings, the close-read's two lines, mended in the landing tree and replayed (§5).*

## NEEDS A RULING — NO BALANCE QUESTION OPENS; SIX OF KL's OWN READINGS, TAKEN, NONE A FIGURE

1. **EVERY COMBO SHOWS ITSELF, NOT BLOOD TRIBUTE ALONE.** *"when something similar to this happens"* is read as every passive
   the warband carries. **The alternative**: Blood Tribute and Pack Tactics alone. **Reversing it**: the `_kl_fired` calls.
2. **A FALL FEEDS BLOOD TRIBUTE ONCE, AS IT FALLS**: a Raise takes none back. **The alternative**: the bodies counted down.
   **Reversing it**: `_kl_tribute`.
3. **CINDER CLEAVE STRIKES TWO AS SWIPE DOES**: the second hero at random, each for the full blow, each burned 3 turns, always.
   **The alternative**: the hero beside the target, or the blow split. **Reversing it**: keys in `data/enemies.json`.
4. **NO TAUNT REACHES A BLOOD IN THE WATER BODY**: a taunted body aims, casts and buys as if untaunted; *weakest* is the lowest
   share of health (the reading put in the question), a tie to the first seat, the aim taken again as the blow lands. **The alternative**: the taunt keeps the support half and the buy.
   **Reversing it**: `kl_untaunted` and the declaration's spend test.
5. **THE BASIC IS THE KIT's FIRST MOVE, AND THE BREAK EXPLOIT STANDS.** **The alternative**: a ready move first there too.
   **Reversing it**: `_choose_enemy_action`.
6. **A SAVED SLINGER READS AS AN ARCHER, AND THE TWO ZONES ON THE FOREST's ART ARE TINTED.** **The alternative**: a raider; no
   tint. **Reversing it**: `Enemies.RETIRED`; `Run.PLACEHOLDER_TINT`.

## THE CHECKS THIS REPORT NAMES FOR RETIREMENT

**None new.** KL ran Lane A's floor. **What found KL's findings, by step**: the premises at source found four of the designer's readings not as
put (Entomb's Dazed, Pack Tactics broken, the zones mixed, one attack a body); the blocks' reader found 53 stale claims in the state
and the Tyrant's bands moving on the line (answer 5); the recon found eleven gates red, ten owed a repair and one KL's own card; the new text's reader found Blood in
the Water's aim lost when its hero fell, `check_js`'s repaired list, `docs/combat-rules.md`'s promise and the Hollow Crown's
Sundering Decree (answer 6); the subsets found the new block's census rows, a long index row, a batch named in master's text and
the archive's first find under a reused heading; the controls proved `check_kl`'s sections and five repaired sections red on the defect each names (the rest of the repairs' HEAD arms are the recon's).

**Named apart, whose silence is their work** (JT §2): the push check, the two readings, the freeze and the hash guard.

## WHAT THE NEXT DECISION RECORD OWES

1. **The lane, declared** — A, B or C (`docs/ways-of-working.md`); KL ran Lane A's floor by its own reading.
2. **What was decided, and what is out of scope** — the designer's ten items and six answers, built. **Still open, the
   designer's**: KJ's RULINGS OWED items 1–8; KK's three readings and KL's six; KI's item 1; the two look-list rows left NOT YET
   (FOUND AT KF); and a look at KL's chips, floats and tints in play.
3. **What it was written from** — `RECORD_KL.md` and the questions as put; the probes' logs; `docs/reports/KL-routing.md`; the
   blocks' reader (`report/blocks_reader.md`); every fact about the code as a file, a function and a quoted line.
4. **The open questions, both branches decided** — KL's six readings are taken, each with its alternative and its reversal, and
   await the designer's word.
5. **Not to get wrong**: **a passive goes through `_kl_fired` and wears a chip**, or it is the silent passive this rule retired;
   **a kind taken out of the data is retired by name** (`Enemies.RETIRED`), and a gate that counts kinds sets it aside as it sets a
   kind added since; **a basic's new rider moves its kind's other cooldowns on the line**, so a change to a basic owes the designer
   the line's reading of the rest; **the Frozen Plains is not the Forest** — read the zone's name, not its picture.
