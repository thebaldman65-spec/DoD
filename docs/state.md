# Dawn of Decay — CURRENT STATE

**THIS FILE IS REWRITTEN EVERY BATCH, NEVER APPENDED TO.** It holds only what is true right now.
**If it grows a history section, it is wrong** — what happened belongs in `docs/changelog.html`,
the rules that bind future work belong in `CLAUDE.md`, and what the game currently *is* belongs
in `docs/master.html`.

**AND HOW A BATCH COMES TO EXIST BELONGS IN `docs/ways-of-working.md` (FL §1)** — design settled
before a brief is written, a recon read before content is authored, findings routed to the queue
below rather than to the designer, and implementation calls made by the batch. **It binds the
conversation UPSTREAM of a brief, which neither `CLAUDE.md` nor `docs/instrument-rules.md` has ever
covered. Read it before writing a brief, not after.** *This pointer is in the preamble rather than
in the WHERE block on purpose: that block is replaced every batch and a pointer inside it would
last exactly one.*

**AND WHAT THIS FILE CLOSES IS ARCHIVED, NEVER DELETED — `res://DoD-archive/state-archive.md` (HX §2).** A section whose
heading is struck, and an item of a *FOUND AT* section that is fixed, overtaken or superseded, moves there word for word in
the batch that closes it; what is still owed, or could not be settled by reading, stays — a doubtful item is cheaper kept
than wrongly archived. *This pointer is in the preamble for the reason the one above is; `check_hx` §2 follows it, and reds
the day this file stops naming its archive.*

**AND THIS FILE'S CEILING IS 380 KiB — AN ALARM ON THE CLOSING PRACTICE ABOVE, NOT A BAR THE FILE IS SPLIT AT (HY §3, ruled
by the designer).** The practice is what holds this file: what a batch closes goes to the archive. **Reaching the number
means the practice has stopped working — what was closed stayed — and the answer is to archive what is closed, never to
split this file**: a split is `CLAUDE.md`'s answer at its own ceiling, not this file's. The number is ten batches of this
file's mean growth over HO–HW (+5,528 B) above HX's close (339,639 B), rounded down. EE's method, ten of one batch's record
growth above the same close, gave 460 KiB — above the 455.8 KiB this file stood at when the trouble was met, so it would
never have fired: **an alarm set above the failure level is not an alarm.** `check_fg` §4 reads the number out of this
sentence every battery: over it is a warning, and past it by more than one batch at the record is a failure — the largest
single-batch growth on record is **+13.38 KiB** (ES's +13,700 B). *In the preamble for the archive pointer's reason.*

*Last rewritten: 2026-10-19 (Batch IQ).*

---

## WHERE THE PROJECT IS

- **Last batch: IQ — THE THREE DOCUMENTS, AND ONE CRASH.** IMPLEMENT ONLY. **This file's closed blocks are in the archive,
  `master.html` is swept against the code, the re-measure is priced on both files, and a save naming something gone no longer
  takes a screen down.** Full working: **`docs/reports/IQ.md`**. **The next letter is IR** (the roadmap, below).
- **THE DESIGNER's FILES, READ AND UNTOUCHED.** The readout holds what it held at IP: IH's debug-touched first file and the clean
  one, `readout/run-20261018-194229.jsonl`, which `latest.txt` names — 24,340 B, md5 `610bcd8c2b43f97703e63053e86728fa` at IQ's
  open and at its close, **still the one run, zone one through its boss: it has not grown, and no newer file has appeared**.
  `run_save.bin` (55,264 B) still holds that run at zone two's start — v15, and **no key in it names anything gone** (§4 read it, a
  copy in a lane). Both backed up with the player's files (`../save-backups/IQ-20261019-143844`). **A second run with a different
  party is still asked for** (IQ's ruling 1).
- **§1 — THIS FILE's CENSUS: 130 OF 141 BLOCKS BIND, 92.5% OF IT BY BYTES** (II's shape: four readers, one rubric, a frozen copy, each
  reader's bytes matching its slice). **The cut, every record read first (IJ §0.2)**: nine whole blocks and 95 closed items moved word
  for word to `DoD-archive/state-archive.md` (IQ's cut at its top), eight tables struck to their conclusion and a pointer (IM §0.7);
  two CLOSED verdicts overruled and kept — `BOND_MITIGATION_MAX` (a do-not-re-propose ruling no rule file holds) and THE SUITE REDS
  (two practices no rule file holds). **370,043 → 279,425 B before IQ wrote a line.** The census is kept: `docs/reports/IQ-state-census.tsv`.
- **§2 — `master.html` SWEPT, FACT BY FACT (IJ's rubric, eight readers)**: 871 units, 5,157 facts —
  4,949 agree, 171 disagree, 37 unread. **Every disagreement re-verified at its line and repaired, the words moved to
  the code** — 178 edits, 8 of them unread facts settled false — one finding rejected as true, and **7 where the code looks wrong**:
  each sentence now says what the code does, and the question is FOUND AT IQ. **The figures with a door are held**: `check_iq` §2 reads
  every card's price in the draft catalogue and in the class sections' statlines, the bargain deck, the rewards and the ladder
  against the code, 695 figures. Kept: `docs/reports/IQ-master-census.tsv`.
- **§3 — THE RE-MEASURE, PRICED, NOT BUILT.** HV §3b's census over HW–IP, both files: a core read whole, a 250-B index row for every
  other block, each batch opening what it needs. **`CLAUDE.md`: a batch reads about 245 KiB of 472 — 48% less, where HV found 38%**;
  **this file: about 85 KiB of HEAD's 361, 77% less** (and on IQ's own cut file about 80 KiB of 278, 71% less). Building it re-points 144 pins in 42 gates for `CLAUDE.md`
  and 7 in 4 for this file. **IQ's ruling 2.**
- **§4 — THE STALE OFFER, GUARDED (the designer's).** `Run.load_run` drops an offered modifier the deck does not hold, and an offer
  left empty whole; no die, no re-roll; the draw site reads the deck straight on purpose. **The family, censused: 167 reads of save
  data through a data table, 133 guarded, 34 not — 22 would crash, 9 would be wrong, 3 harmless.** Every crasher, and the event
  that strands a run, is guarded at the load door; a class this build lacks refuses the save down the floor's path (IQ's ruling 3);
  the reachable WRONG four — a card a save names by its pre-rename name — are FOUND AT IQ (IQ's ruling 4).
- **§7 — THE LANE DRIVER.** `lane.sh` reads the live name off HEAD's `project.godot` and refuses a copy that runs as it, the
  repository, and a copy with no name — **IP's slip, as a check**, about 20 ms a launch. Every Godot process IQ ran in a lane went
  through it.
- **§0 — THE RULINGS RECORDED**: *no third block* and *a tie that matters is a tie at a cut* (`docs/instrument-rules.md`, beside
  the tie rule), the Warden target (THE BARGAIN DECK's GRADES), *a key that comes off a save is a key the code did not choose*
  (`CLAUDE.md`'s FD §1 block), and two instrument rules with their rows — the guard's two arms and the lane's name.
- **THE INSTRUMENTS.** `check_iq` is new (§0, §1, §2, §4, §4b, §7, §9). Re-pointed: `check_ip` §7's top arm (*IP's own or a later
  batch's*) and its §0.2, which read the newest entry of `docs/design-notes.md` — a position pick, IQ's entry on top now — and reads IP's by its title. The gate-source readers read `check_iq`'s final source before the acceptance (twenty-eight by `check_ij` §0.4's derivation, `check_iq` among them only because its §7 hands the root's path to the driver — it reads no gate's source).
- **THE VERIFICATION** — `docs/reports/IQ.md` §9.
- **`CLAUDE.md` IS 485,156 B = 473.79 KiB AGAINST ITS 510 KiB CEILING — 36.21 KiB UNDER** (+1,562 B at IQ): 4.5
  batches at EZ's record (8,293 B), 19.6 at the mean of IM–IQ (1,890 B).
- **`docs/state.md` IS 284,849 B = 278.17 KiB AGAINST ITS 380 KiB CEILING — 101.83 KiB UNDER** (−85,194 B at IQ,
  this line included; the census's cut −90,618, IQ's own writing +5,424): 17.8 batches at IA's +5,860 B, the worst case; the
  honest rate, IQ's own writing beside IM–IP's — IM −4,046, IN +1,476, IO +1,714, IP +5,787 and IQ's own +5,424, a mean of 2,071 B over the five — **50.3 batches at it**. **The cut bought the room the
  practice was meant to keep**: at IP's close this file was 18.63 KiB under.
- **No save version moved**: every guard reads what v15 carries and writes nothing an older build would lose.
- **Phase.** The merge's running order stays complete; the branch is not merged. **Do not open a `class-merge` save in a build
  older than HL**: HL's ceiling refuses a newer save from HL's build on — HR's v15 is the first bump it has guarded — and HJ's and
  HK's builds, and `main`, carry no ceiling.
- **Next letter: IR — the claims** (the roadmap, below): HX's 87, standing at 86.

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION
### IQ's RULINGS OWED — **SEVEN; THE SECOND DECIDES THE SHAPE OF BOTH FILES, AND THE FIFTH TO SEVENTH ARE `master.html`'s**

Full working: `docs/reports/IQ.md`, NEEDS A RULING.

1. **A SECOND RUN, WITH A DIFFERENT PARTY** (carried from IP's ruling 1, IQ's brief §0.1). The readout's clean file is md5-identical at
   IQ's open and close — the run has not been played on — every figure in THE FIRST CLEAN PLAYTHROUGH (below) is one run and one party.
2. **THE BLOCK INDEX, PRICED ON BOTH FILES (IQ §3).** A core read whole, a 250-B index row for every other block, each batch opening
   what it needs: **`CLAUDE.md` read at about 245 KiB of 472 — 48% less (HV found 38%)**, **this file at about 85 KiB of HEAD's 361 —
   77% less** — and on IQ's own, cut file about 80 KiB of 278, 71% less. Over twenty batches the union of what they needed is 82% of `CLAUDE.md`, so the saving is per batch and the
   index must route each batch to its own few; a batch on a wrong premise because it did not open a block is not measurable before
   it happens. **Building it re-points 144 pins in 42 gates (`CLAUDE.md`) and 7 in 4 (this file), and its rows are written by hand.**
   Build it for both files, for one, a pilot first (HV §3f's), or not.
3. **A SAVE THAT NAMES A CLASS THIS BUILD DOES NOT HAVE IS REFUSED AND CLEARED (IQ §4b)** — the floor's path, chosen by IQ: a hero
   cannot be dropped from a party and a class cannot be invented, and two reads of an unknown class default to the Cleric. The
   alternative is HL's newer-save shape, refused and KEPT. No class has ever been removed, so no save has met it. Confirm, or keep it.
4. **A CARD A SAVE NAMES BY ITS OLD NAME (FOUND AT IQ).** CK renamed the Warrior's Iron Will to Ironclad and GN Magic Barrier to Nexus
   Ward, both after the v10 floor, so a save from before either can carry the old name: it holds a slot, shows as a blank takeable
   button in a queued offer, or carries an upgrade that never lands. **Nothing crashes**; the narrowest repair is a rename map at the
   load door. Build it, or leave it.
5. **SEVEN PLACES `master.html` DESCRIBED A GAME THE CODE DOES NOT PLAY, WHERE THE CODE LOOKS LIKE THE THING THAT IS WRONG (FOUND AT
   IQ)**: the Ruin mini-boss's fixed modifier, overwritten by the bargain taken; Fortified Spirit and Undying Vigil, which the picker
   lets fall on a companion, where the loan never decays and the fork never fires; two cards that say *everyone* (Aegis Wall, Hunter's
   Mark); Tithe healing 1 for an attack into a Broken enemy that lands no Break; a block sound loaded and never played; and seven
   statuses the glossary has no entry for. **Each sentence now says what the code does**; which of them the code should change is yours.
6. **185 OF `master.html`'s 871 UNITS CARRY A HISTORY OR RATIONALE CLAUSE, AND IT NAMES A BATCH 117 TIMES** (the stamp aside) — batch
   provenance, *was / now* and *since* notes and dated measurements, against the rule that it shows only what is in the game (the user
   rule of 07-20). IQ repaired what was false and stripped a clause only where it stood inside a repair; stripping the rest is one pass
   of its own. Strip them, or leave them.
7. **ABOUT 80 OF THE CATALOGUE's BEHAVIOUR FIGURES HAVE NO DOOR**: window lengths, Perfect figures and rates written as literals in
   their handlers (`aw_turns := 4`, Blood Offering's 0.20 and 60, Second Wind's 0.40 and 0.55, …). `check_iq` §2 holds every figure
   that has a door; these need a named constant first — a code batch, and a census of its own.

### THE FIRST CLEAN PLAYTHROUGH — **2026-10-18, WARDEN, ZONE ONE THROUGH ITS BOSS; SIX FINDINGS, ALL THE DESIGNER's TO RULE OR AUTHOR, NOTHING BUILT FROM THEM (IP §0.1, §4)**

**The file is `readout/run-20261018-194229.jsonl`** in the live folder (24,340 B; md5 `610bcd8c2b43f97703e63053e86728fa`), backed
up with the player's files (`../save-backups/IP-20261019-095709`) and **never touched**: ten fights at rung 2 (Warden), `debug_used`
false and every fight's `debug` empty — **the first clean playthrough in the project's history**. The party: a Berserker (his own
core), a Mage on the Invoker's spine (the Weaver's core second from fight 5, the Cryomancer's third from fight 7), a Cleric on the
Hierophant's spine (the Holy's core second at the boss) and a Sharpshooter; no talents, no relics; the vow, Grudge, Long Draw,
Shared Mark and Keen Focus worn. **One run, one party, so every figure below is a reading, not a rate**; a second run with a
different party is asked for. Each was re-derived off the file at IP and every one holds as the brief states it, two premises
aside (IP's report, §0.1).
- **RUPTURE IS UNREACHABLE, NOT MIS-TUNED.** The one Rupture formed at turn 20 on the mini-boss's Orc Chief (the Mage's Burn on his
  own chill) and its body died at turn 29: **stood 0 of its body's turns, ticks 0, Break 0.** The Mage held the Cryomancer's core
  by then, the Cryomancer's fourth chill FREEZES a body, and **a Rupture grinds on its body's own turns** — so the class that lays
  the chill takes the turns the Rupture pays on. Both Ruptures ever recorded ground nothing (IH's, debug-touched, stood one turn).
  **The designer's to author; no number fixes it** — `RUPTURE_BREAK_PER_TICK` is unmoved.
- **SANCTITY: A NORMAL FIGHT BOOKED 18.33 EVENTS AND 1.17 STEPS**, against the bot's 40.43 and 2.56 at IO §3's rung-1 road — **the
  bot books 2.2 times a player's status events** (different roads: the player's at rung 2 with his own party, the bot's at rung 1
  beside the default lineages, both untalented) — **and the boss booked 51, 2.78 times a normal fight.** *(The brief set that against
  FV's 1.55: 1.55 is II's brief's figure, a ratio of STEPS — IG's boss 4.04 against 2.58 — where FV's own boss-to-trash ratio of
  EVENTS read 1.09–1.16; the playthrough's steps ratio is 3 against 1.17, 2.57.)* **So a step set for half the cap in a normal
  fight puts a boss at 1.4 times the cap.** The target and the cap are the designer's; `SANCTITY_PER_STEP` is unmoved.
- **THE VOW PAID 2.2 TO 1**: over the seven fights it was worn, **322 damage refused for 707 healing added**, where ID ruled it
  roughly even — **an auto-take in zone one at rung 2** (TO WATCH IN PLAY's vow item).
- **THE CLERIC WAS THE DRIEST HERO, NOT THE FULLEST**: 3 hard-dry and 6 soft-dry turns of his 58, where **the Mage read 0 of 56
  and the Hunter 0 of 65** — the opposite of IE's and IF's sim (THE CLERIC's MANA RATE, below). The rate is unmoved.
- **BOIL OVER WAS NEVER DRAFTED**, so its rate is still unfelt; the question is its availability, not its figure (BOIL OVER'S
  RATE, below).
- **FOUND, UNASKED — RECORDED, NOTHING CHANGED (one run, one party):** **the Sharpshooter dealt 42.2% of the run's damage**
  (3,396 of 8,053; at the boss 988 of 1,955, his best turn 339); **the Berserker dealt 18.2%** (1,468), his `low_water` 0.00 in all
  ten fights and **22.9% of his costed turns hard-dry** (11 of 48).

### THE BARGAIN DECK's GRADES — **MEASURED (IO §2, RE-TAKEN AND RE-CUT AT IP §1b AND §2); TWO CUTS ARE TIES; THE GRADES ARE THE BOT's AND THE DEFAULT BUILD's**

**What the table is.** Each modifier forced on every bargain of a Ruin run (the sim's forced arm: IG's three parties, the default
build, seed block 21, twenty runs a party), the party's share of its health at a bargain fight's end, sorted and cut 6 / 6 / 4 / 4 / 3.
**Which instrument each figure is**: IO's for most; **IP's repaired bot** (the player's potion) for Bloodless, Miasma, Wasting and
the Thin Veil, the four the potion could move; **pooled over a second seed block** (block 41, IP's bot) for the six either side of
IO's cuts that IP re-measured. Every figure, its standard error and its source is IP's report, §1b.

| grade | holds, in the measured order | health at a bargain fight's end |
|---|---|---|
| **5** | Mirrorbound, Wasting, Bloodless | 0.706 – 0.640 |
| **4** | Rot, Thin Air, Miasma, Overgrown | 0.899 – 0.857 |
| **3** | the Long Silence, Feverish, the Thin Veil, Deadened | 0.910 – 0.899 |
| **2** | Slick Footing, Muffled, Encumbered, Bloodletting, Fleeting, Brittle | 0.945 – 0.921 |
| **1** | Hoarfrost, Dull Edge, Frenzied, Tinderbox, Warded, Parched | 0.963 – 0.948 |

- **TWO CUTS ARE TIES, NAMED ARBITRARY (IP §0.4's rule, `docs/instrument-rules.md`).** After a second seed block, **Parched |
  Slick Footing** (severity 1 | 2) sit 0.003 apart against two standard errors of 0.007, and **Deadened | Rot** (3 | 4) 0.001 apart
  against 0.011: the measurement cannot say which of each pair is costlier, so the sort's order stands and **either could hold
  either grade**. **NO THIRD BLOCK (IQ §0.2, the designer's): a tie that survives its second block is a measurement that
  succeeded** — the two cost the party the same, and *two modifiers that cost the same belong in the same grade; a boundary
  between them is an artifact of fixed counts, not a fact about the deck.* The cuts are made at fixed counts over a deck that
  clusters, so a cut falls inside a cluster somewhere; the bands read grades, not modifiers, so an arbitrary cut moves one
  modifier between two adjacent bands and nothing else. **Do not re-measure these two** — an hour to order two modifiers the
  measurement has already called equal (the rule beside the tie rule, `docs/instrument-rules.md`). The other two cuts are measurements: Brittle | the Long Silence (2 | 3) 0.011 apart, just past two standard errors (2.02),
  and the cliff, Overgrown | Mirrorbound (4 | 5), 0.151 apart.
- **LIMITATION ONE — THE GRADES ARE THE DEFAULT BUILD's (IP §0.5, the designer's).** The untalented arm completes no run on Ruin in
  any arm, so runs completed cannot break a tie there, and its standard errors run three to ten times the default build's. Cut the
  same way, **seven grade differently untalented**: Parched and Warded (2 untalented), Muffled and Deadened (1), Brittle (3),
  Overgrown (3) and the Thin Veil (4). Severity 5 holds the same three on both builds.
- **LIMITATION TWO — THE GRADES ARE THE BOT's (IP §0.5).** The bot books 2.2 times a player's status events (THE FIRST CLEAN
  PLAYTHROUGH, above), so **a grade that turns on statuses laid may be mis-graded for a player**: by mechanism that is **Fleeting**,
  whose door is every status applied. Hoarfrost lays one chill on every body at the start, and its cost reads the chill, not how
  many statuses anyone lays. **And the grades that turn on healing** — Bloodless, Miasma, Wasting and the Thin Veil — were the bot's
  potion's until IP §2 repaired it and re-took them; the bot still drinks by its own policy (below 35%, before acting), not a
  player's.
- **THE DECK HAS NO MIDDLE (IP §0.12, the designer's)**: between the cliff's 0.706 and Overgrown's 0.857 there is nothing. **Four or
  five modifiers costing 0.78 to 0.86 are what the deck is missing, and they are the designer's to author** — what gives Warden a
  middle rung; no count moves and no band is widened to reach for it. **THE TARGET, SET AT IQ §0.5 SO THE AUTHORING HAS A
  CONDITION RATHER THAN A FEELING: Warden's bargain fights end between 0.80 and 0.85 of the party's health** — the midpoint of the
  ladder it sits in. On IP's cut the three rungs end at 0.956, 0.908 and 0.687: Warden sits 0.048 under Wanderer and 0.221 over
  Ruin, so 0.908 is the best this deck can do and no re-grade of twenty-three modifiers makes it a middle rung. **Recorded, not
  pursued**: the four or five modifiers at 0.78–0.86 are the designer's, and nothing moves toward the target until they are authored.
- **THE THIN VEIL IS STILL FEVERISH's RULE AT TWICE THE FIGURE (IP §0.6)**: confirmed, and a rule of its own is owed — the
  designer's to author. **On the repaired instrument the two settings of the one dial cost the same** — Feverish 0.910, the Veil
  0.908 — and stand in one grade, 3.

### THE CLERIC's MANA RATE — **12, UNMOVED (IE §1); THE TUNING HANDLE AND THE FIGURES IT WAS MEASURED AGAINST**

**The drip is `battle._mana_regen`'s `12 + u.mana_regen_bonus`, one base for every Mana hero; the Mage's Evocation adds 10.** A
Cleric's own rate is that base — no lineage moves it, and no live rune, relic or node raises it. **The two tables it was measured
against live in their reports (IM §0.7)**: IE's probe — the share of his turns a hero is dry (the card the bot would cast with a full
bar costs more than he holds), 20 sim runs for each of the nine Mana lineages, rung 1, at bases 8 / 10 / 12 / 14, default and
untalented — in `docs/reports/IE.md` §1b; IF's re-read with the Cracked Hourglass's reach repaired (every Mana hero, never lowering a
bar above the cap), relic held and not, in `docs/reports/IF.md` §0.1b. **What each concludes, the figures the rate is priced by**: at
12 on the default build the Cleric is dry **4.1%** of his turns (the Mage 4.5%, the Hunter 3.9%), untalented **26.8%** (18.3%,
33.8%); with the Hourglass held, untalented, **11.5%** (16.4%, 20.9%). **IE's shape** (the Cleric dry sometimes, and less than the
Mage and the Hunter) **is WITHDRAWN** (IF's brief §0.1): it asked for a higher rate while the finding pointed down.

**THE FIRST CLEAN PLAYTHROUGH SAID THE OPPOSITE OF THE SIM (IP §0.1)**: the Cleric was the driest hero and the Mage and the
Hunter never dry — THE FIRST CLEAN PLAYTHROUGH, above. With the relic, at a turn's start the bars read 91 / 97 / 95 of 120 (default). **THE RATE STAYS 12, CONFIRMED (IG's brief §0.2):**
untalented — the designer's build — the Cleric is dry 11.5% of his turns with the relic, below the Mage's and the Hunter's, and the
caveat the sim cannot close (the bot heals when hurt, a player when it matters) is the readout's. These figures were taken while the
member's maximum was a fixed 100 (IG §4 changes that for a node-holder; the untalented rows hold no node) — re-read at IG §4c
on the default build with the relic held: dry 0.7 / 2.9 / 0.3%, opening a fight full 39.2 / 42.5 / 35.6% (24.1 / 36.5 / 15.4% before).

### SANCTITY's STEP — **13 (IG §2), RE-TAKEN ON THE REPAIRED BOT AT IO §3 AND UNMOVED; THE TUNING HANDLE AND THE FIGURES IT STANDS ON**

**`BattleUnit.SANCTITY_PER_STEP` is 13 events a step, `SANCTITY_MAX_STEPS` 5.** `check_ig` §2 pins the step in one place, so a
re-tune from play moves the constant and that line. **The target is FV §3's and was not reopened**: about half the cap by a normal
fight's end on untalented rung-1 fights. **RE-TAKEN AT IO §3 on the bot IN §3 repaired** (it had paid below the door's price on
about 2% of its costed casts untalented) — IG's probe, IG's population, IL's seeds and IL's shape, the one thing changed the bot;
**the step stays 13, and the measurement now asks for it outright**: a normal fight ends untalented at **2.56 steps at 13 and
2.37 at 14** (±0.03), so 13 is the nearer to half the cap by 0.06 against 0.13 — at IL it tipped to 14 by 0.05. The default build
**2.46**; a boss untalented **3.95, 38.9% at the cap**; the door lengthened **5.12 applications a fight** untalented (5.03 default).
IL's table is `docs/reports/IL.md` §1c and IO's is `docs/reports/IO.md` §3. **THE FIRST CLEAN PLAYTHROUGH READ IT, AND THE STEP
IS THE DESIGNER's TO RE-RULE (IP §0.1)**: a normal fight booked 18.33 events and 1.17 steps, the boss 51 — THE FIRST CLEAN
PLAYTHROUGH, above.

### FOUND AT IQ AND NOT FIXED

- **THE RUIN MINI-BOSS NEVER FIGHTS ITS FIXED MODIFIER.** In play `map_screen` arms one (`Run.arm_fixed_modifier`, the severity 3–4
  band) before the bargain, and `Run.accept_offer` overwrites `pending_modifier` with the bargain taken; the sim takes the bargain
  first and the arm's *never stack two* guard skips it. Either way a Ruin mini-boss fights the bargain alone, where `CLAUDE.md`'s
  ladder block names it among the fixed encounters that carry a modifier with no reward. `master.html` now says what the code does;
  which is meant is IQ's ruling 5.
- **A CARD A SAVE NAMES BY ITS PRE-RENAME NAME** (Iron Will, Magic Barrier): four reads take it straight — `map_screen._offer_card`'s
  queued offer, the slot count, `Run.apply_upgrades` and `Run.upgrade_choice` — and none crashes. IQ's ruling 4.
- **LATENT, AND WRONG, NOT A CRASH**: a saved stat payload naming a unit field since renamed pays nothing (`set()` drops it), and a
  payload naming a card since renamed adds nothing (IQ §4b's census).
- **`CLAUDE.md`'s STARTER-RUNG BLOCK SAYS CLEARING RUNG 1 IS THE ONLY THING THAT OPENS TIER 1** — beating the end boss on any rung opens
  it (`Profile.note_end_boss` sets the tier to the rung beaten, and `Talents.tier_open` opens every tier at or below it), and the
  draft deals all three rungs with no gate. `master.html`'s copy is repaired; the rule file's is a claim for IR, and `talents.gd`'s
  comment at its head repeats it.
- **THE FORMLESS CHIP SAYS NO RECOIL FOLLOWS, AND ONE DOES** — `battle.gd`'s `formless` status text against the recoil its expiry
  applies: a player-facing sentence the census found beside `master.html`, not repaired here.
- **A CHOOSE-THREE CARD ROLLS ITS MISS TWICE.** `_resolve`'s single-target miss guard excludes `choose_two` and not `choose_three`, so
  Cleave and Hex of Ruin roll a whole-cast miss on their first target and then a miss per strike (`master.html`'s miss line now says
  what a player meets: chosen-target attacks roll per strike).
- **CODE COMMENTS REPEATING WHAT THE CENSUS FOUND FALSE** — an asserted surface (DF §1), each repaired with its subject: `talents.gd`'s
  head (*rung 1 is the only door*), `run_state.gd`'s *an event pays no gold* and *`pending_event` is not saved*, *35% → 52%* (Honed
  makes 53%), Mark of the Hunt named as an engine-gated boss card, `battle.gd`'s *59* recast-gated abilities (63 refuse), Blood
  Offering's *40* Rage (60), Berserk's *4 on a perfect* and *spends all three* (four charges, always), and *converts depth into width*
  in two places.
- **`master.html` HOLDS 185 UNITS WITH A HISTORY OR RATIONALE CLAUSE, AND NAMES A BATCH 117 TIMES** (the stamp aside) — IQ's
  ruling 6. **And its zone-boss heading still reads *a zone-boss award always pays*** inside the history it narrates, while its own
  paragraph says the chain can empty; the sentence that stated the claim as a fact is repaired.
- **FORTIFIED SPIRIT AND UNDYING VIGIL TAKE A COMPANION AND DO NOTHING ON ONE.** Both pick from `_hero_side()`, companions included,
  where Covering Guard and Rally narrow the same pool: Fortified Spirit's loan decays at its bearer's turn start, which a companion never
  takes, so a loan on one never decays; the Vigil's fork is wired on the four heroes only. IQ's ruling 5.
- **TWO CARDS SAY *EVERYONE*** — Aegis Wall and Hunter's Mark, beside the *hero* or *ally* each also states — against `CLAUDE.md`'s
  *there is no third word*. IQ's ruling 5.
- **TITHE HEALS 1 FOR AN ATTACK THAT LANDS NO BREAK** — into a Broken enemy (or under Bulwark, Immovable or Ironclad's cap) the heal falls
  to its 1-health floor, where its words say an attack that lands Break. IQ's ruling 5.
- **THE BLOCK SOUND IS LOADED AND NEVER PLAYED** (`bow_blocked`; a block plays the parry's), and a comment still promises it. IQ's ruling 5.
- **SEVEN STATUSES THE BATTLE APPLIES HAVE NO GLOSSARY ENTRY** — Slow Burn, Heads Down, Unmaking, Breaking Darkness, Penance, Suffering
  and Blighted — where `master.html`'s glossary section said every debuff had one. IQ's ruling 5.
- **`CLAUDE.md`'s RELIC BLOCK COUNTS 25 READ SITES** of `relic_add` and `relic_dict`; the game holds 22, 26 with the sim's. A claim for IR,
  beside the starter-rung one.
- **`check_hn` §2a's WORN ARM READS THE BAG's RUNE** (IQ's position census, read and not driven): `got_worn` keeps the last *Fourth
  Stack* on the Cleric's list, and since HR §1's hand-out the bag's copy lands there after the worn one, so the worn rune's rename is
  asserted by no arm — an instrument defect older than IQ.
- **`check_ho` §8 READS A FIXED 2,400 CHARACTERS AFTER ITS HEADING, PAST ITS 2,288-CHARACTER BLOCK**: its tail now reads IQ's new block's
  heading where it read HO §1's. Every needle it holds sits inside the block, so the verdict holds — the *fixed window runs past its arm*
  shape, waiting for a needle that does not.

### FOUND AT IO AND NOT FIXED

- **`battle._cheapest_attack` RETURNS THE FIRST FREE DAMAGING ABILITY, NOT THE CHEAPEST** (its name says *cheapest*; every enemy
  kit's 0-cost attack comes first today, so the two agree on the live roster). The Long Silence's enemy exemption and Heads Down
  read it.

### FOUND AT IN AND NOT FIXED

- **THE `enemies_alive_r3` SAMPLE NEVER SAMPLES ROUND THREE**: it fires at `next_time >= 200`, written for 100 ticks a round,
  and a swing at the average speed moves a unit 2 ticks (`BASIC_DELAY`), so it reads the fight's end state nearly always.
  **Standing at IO**: Cruel Order's `ROUND_TICKS` was the honest reading of a round and is deleted with its one reader; the sample
  never read it, so the deletion did not touch it.
- **`run_sim._take_offer`'s COMMENT SAYS THE SAFE SLOT IS ALWAYS A 1 OR A 2**: false on Warden (1–3) since BM and on Ruin (3–4)
  since IM. Standing at IO.
- **`check_fh` §7's COMMENT SAYS THE FALLBACK PICKS *the card's own spec owner***; the code takes the first non-companion hero.
  Standing at IO.

### FOUND AT IM AND NOT FIXED

- **THE UPGRADED EXECUTE's FIX IS DORMANT IN PLAY**: nothing in `scripts/` or `data/` writes `execute_upgraded` (its node grant
  went with the twelve trees — DO's read-only-zero fields), so IM §3a's price test is driven with the field set by hand
  (`check_im` §3a) and reaches no fight until a writer returns.
- **THE `st/b` SPLIT IS PARKED, NOT SCHEDULED (IM's brief §0.6)**: afflictions landed on enemies and blessings landed on allies are
  two facts in one column, and the split is owed the next time the sim report itself is touched — measured before and after like
  any instrument change. Not before: IL §1c's Sanctity figures read through that door.
- **TWO GATES THE SUPERLATIVE CENSUS MET IN PASSING**: `check_gn` §4 computes the highest-health enemy (`hp_top`) and never reads it;
  `check_ew` §4 asserts `cap < 1.0 or cap >= 1.0`, which cannot fail — a printed figure wearing an `ok()`.
- **THE BOT CAN NO LONGER CAST A FIREDRAW ON THE ONE ENEMY ALIGHT**: the drafted hook aims Firedraw at the ripest fire, and with one
  enemy burning that body is the one the pick refuses, so the hook skips it (§3b). The rotation never cast Firedraw; whether the
  hook should draw a lone fire onto another body instead is a bot policy, not the pick's rule.

### FOUND AT IL AND NOT FIXED

- **TWO CLERIC CLAUSES LAY A STATUS WITH NO SOURCE AND ARE DORMANT** — Dark Pact's Invigoration (`invigoration_ranks`) and
  Blessed Vestments' ward (`vestments_pct`): no writer in the tree, so no fight reaches either, and IL §1 left both. Each owes
  the Cleric as its source the day its field is written; `check_il` §1a reds that day, naming the field.
- **`docs/combat-rules.md`'s HEADER CLAIM IS STALER AGAIN** — IL wrote into its DI block (*a status is applied with its `src`*).
  Among the 86, IO's (FOUND AT HZ).
### FOUND AT IK AND NOT FIXED

- **OTHER SUNDERS LAY THEIR OWN DURATIONS.** `BattleUnit.SUNDER_TURNS` is Sunder's own — Crushing Blow's and a Perfect Sever's —
  and the other sites lay Sunder for a figure of their own: Called Shot's *Armor* spot 2, Mass Hysteria's turned blow 3, the
  enemies' Sundering Strike and Tyrant's Verdict 2 (`data/enemies.json`), and Consecrated Ground's Judgement 2 (a field nothing
  writes since FX, so dormant). Each is its card's figure, stated where it stands; none reads the constant.

### FOUND AT IJ AND NOT FIXED

- **VESPERS IN THE GLOSSARY's `mercy_window`** — *the blow that would take an ally below the line*: whether a companion's window
  counts is not settled by reading; left as written.
- **WHAT `master.html`'s REPAIR LEFT UNSURE** (IJ's report §2): the Parry Up row (Guard Change's figures beside the chip's
  Precision Strike +25%); the potions on the map; the §4.6 Poison row's *never ticks on the turn it lands*; Answering Steel's
  *two turns off everything he holds* (each card skips its own cooldown); Firedraw's reason column; Mercy's row against the
  glossary's exceptions. None was changed.
- **SIEGE STONE's *heavy damage to every ally*** is the one enemy text that says *ally* for the heroes' side; whether its
  throw reaches a companion was not read. The other enemy texts say *warband* for their own side since IJ.
- **THE READOUT STILL NAMES DEBUG ACTION 12 *Full Heal Heroes*** where the menu reads *Full Heal Standing Heroes* — a record key
  `check_ih` pins, so it stayed.

### FOUND AT II AND NOT FIXED

- **`docs/combat-rules.md`'s HEADER CLAIM IS STALER AGAIN** — II wrote into the frame block (the two layer-framed sites, the closed
  partition) and the recap block (the tick's credit). Among the 86, IL's (FOUND AT HZ).
- **`CLAUDE.md`'s RARITY BLOCK SAYS THE LIVE RUNES *read 100g*** — stale since HK §3 set 150g; the census met it (slice 3). The stale-
  claims shape, in the required read rather than a reference.
- **`check_dr`'s PRINT-ONLY `TICK_SITES` NAMES THREE NODES FX DELETED** (Frostbound Hours, Practised Hands, Follow-Through) — the census
  met it (slice 4); nothing asserts on it.
- **CHAIN IGNITION's BURN IS LAID WITH NO SOURCE** (`_update_talent_chips`) and is dormant (`ember_wind` has no writer): the day it
  returns, its ticks deal under a frame naming nobody and credit nobody (§3's rule), where BL §2's name would have booked them to the
  Pyromancer.

### FOUND AT IH AND NOT FIXED

- **THE FULL-SCREEN ART IS SIZED BEFORE ITS EXPAND MODE** (census 1b): the map's and the event's backgrounds (1122 × 1402) draw at
  1280 × 1402 and show their upper part, not their centre — behind the cards, not on them.
- **THE BATTLE SPAWN STILL BUILDS ITS OWN LIVE PROLOGUE** — the sheet's moved to `Run.hero_live_config` (IH §5) and the spawn's did not
  (CK §1's owed helper, still one copy short).

### FOUND AT IG AND NOT FIXED

- **`DEBUFF_IDS` STILL NAMES `melted`**, inert since §1 (no status carries it — Melt Armor is a display chip, and dormant: nothing
  writes `melt_ranks`). As a status it counted as an affliction for every breadth reader and a mender's rite could take it; the
  day a node writes Melt Armor again, its chip counts toward none of them. `spec_passive`'s twin in `DISPEL_NEVER` (FOUND AT IE).
- **A HERO's FIRST FIGHT OF A RUN STILL OPENS AT THE CLASS's 100** — the member learns the bar's maximum at that fight's end, so a
  +20 node opens his first fight at 100 of 120, as at HEAD; every door after it reads 120 (IG §4). Computing it before the first
  spawn is the sixty-line prologue the hero sheet and the spawn each write (CK §1's owed helper).

### FOUND AT IF AND NOT FIXED

- **THE SIM's BOT CASTS A DRAFTED SMOULDER ONLY THROUGH THE DRAFTED HOOK** — as it does Fireball (FOUND AT IE): only when Magic Burst and
  Magic Missiles are both unavailable. A Cryomancer's Rupture reads 3.2% of his turns in the sim's default-build runs on IF's code and
  15.3% for one who holds Smoulder and casts it whenever it is ready (IF §2); the readout reads the designer's.
- **THE READOUT's *dealt* IS THE HERO's OWN** — a companion's blows are credited to the companion's name and are not in its hunter's
  figure; Boil Over and the vow, which the readout exists for, are not affected.
- **THE FIXED-DRAFT FIRE POLICY NEVER REACHES THE CRYOMANCER's CHILL** — a bar of fire cards is cast first every turn, so those arms read
  Chilled 0% and cannot speak to Rupture (IF §2 took a separate arm for it).

### FOUND AT IE AND NOT FIXED

- **THE SIM's BOT NEVER CASTS A DRAFTED FIREBALL, AND STOKE AND CINDERFALL RARELY** — Fireball (with Frostbolt and Arcane Explosion)
  is one of GS's returned cards the drafted hook cannot see, and a Mage reaches that hook only when Magic Burst and Magic Missiles are
  both unavailable; Stoke and Cinderfall are in no rotation arm (one cast in sixty runs, though `check_gp`'s seeded road meets a
  Cinderfall eight times). Every sim figure on a Mage's Burn is the bot's
  rotation's — Firestorm, Flamewave, Immolate — and understates a player who casts what he drafted. One case each, the bot's.
- **`DISPEL_NEVER` KEEPS `spec_passive` AND `spec_passive_2`**, inert since §2a (no status carries either); `check_el` and
  `test_batch_bq` pin them.
- **THE CENSUS's OWN, READ AND NOT DRIVEN**: Ember Leap's half-the-turns fires on Ember Debt's refund, which consumes nothing; eight
  Cleric rotation arms test `ab.cost` where the door uses `_eff_cost` (under Warded he can pick a card he cannot afford); two
  stale comments (`battle.gd`'s *Frostbolt the mark* — slot 0 is Magic Bolt — and Firedraw's *UP TO 4*, which takes 6).

### BOIL OVER'S RATE — **0.8% AND THE 40% FLOOR STAND (IA §0.1, the designer's); THE TENSION IS RECORDED HERE AND THE LEVER IS UNBUILT**

**0.8% of Attack for every point of Rage poured out, and a floor of 40% of the bar** (`Classes.BOIL_OVER_PCT_PER_RAGE`,
`Classes.BOIL_OVER_MIN_BAR`). **Two lower rates failed the shape at HZ and the card has never been cast in a real fight**, so it
ships at 0.8 and the next change to it comes from the designer's hands, not from arithmetic — and so does a Perfect, which it does
not carry (IA §0.5: the grade's harder blow lands, and a Sloppy loses the cast and keeps the bar). **The first clean playthrough never drafted it** (IP §0.1),
so its rate is still unfelt and the question is its availability. **The figures it was chosen
against**, each HZ's:
- **Maximum Rage**: 100 for every Warrior lineage; 120 with the tier-1 node that raises the pool (the sim's full build carries it).
- **Rage a turn, in real fights** (20 sim runs a lineage, the default rung): a Warrior gains **about 20 a turn** (median 15) in every
  zone and lineage, so a bar of 100 fills in **about five of his turns** — about a fight. Holding 100 or more, the bot's damaging
  actions dealt a median 35–54% of his Attack.
- **The census, on one deterministic board at Attack 100** (`check_hz` §2 prints it every battery, each card on its own board):
  the best ordinary turn is **Rampage, 45 for 40 Rage (52 with the Berserker's core)**; Execute 38, Cleave 35, Crushing Blow 30
  (31 with the core) — about 1.0 to 1.6 a point of Rage.
- **The dump on the same board**: **a full bar deals 63 without the core and 88 with it** (the core's band is filled by the dump's
  own spend, so 88 is its figure at any health); **a cast at the floor deals 25 and 29**, against Crushing Blow's 30 and 31.
  HW's good case for the old card was **84 for 40 Rage** with the core at half health; a full bar with the core is 88.
**The shape the designer set as the pass condition holds both ways**: a full bar beats the best ordinary turn and does not beat
two; a floor cast is worse than an ordinary card.

**THE TENSION, RECORDED BECAUSE IT IS THE DESIGNER'S OWN AND IT IS REAL.** A full bar deals 63, which is **0.63 of Attack a point
of Rage**, and the census's median Rage card converts **1.09 a point**. Only Shatterpoint (0.47) and Overpower (0.40) convert
worse, and **both buy something besides damage**. **A capstone that is the least efficient converter in the kit is backwards**,
and the pass condition is why it cannot be fixed by a rate: *not two of the best ordinary turn* compares one dump against two
Rampages and ignores that the bar cost about five turns to fill. **Both cannot hold.**
- **THE MISSING FIGURE IS ENEMY HEALTH, AND IT IS NOT MEASURED HERE EITHER.** 63 against a zone-one body and 63 against a zone-three
  elite are two different cards: **the rate is read against what it kills when it is next ruled** — a fight, not a census.
- **THE LEVER, NOT AUTHORED: a rate that rises with the fraction poured.** One constant, not a mechanic — the floor cast stays bad,
  a full bar becomes a payoff, and the median stops being an indictment. It is what to try if play says a full bar is not worth
  its five turns.

### THE CREST POOL — **THREE OF ITS FOUR LIVE RUNES ARE DISASTER INSURANCE (IA §0.2, the designer's); NOTHING IS AUTHORED OR RE-CUT**

**Empty Pulpit, Dead Air and Dirge are COMEBACK runes, confirmed and kept**: every fight opens with all four standing, so each pays
only after a fall — Dirge less for any hero fallen and Dead Air more for the Mage alone, a frequency-against-magnitude pair, and
Empty Pulpit the defensive one and the best of the three (*your healer is down, you are harder to kill*). **They pay because HP
§1's live re-read reads the condition again at every death**: load-bearing for the pool, and recorded so in `CLAUDE.md`'s crest
block.
- **THE FINDING IS THE POOL, NOT THE RUNES**: three of the four live crest runes are disaster insurance and the fourth, Tithe, is
  unconditional — a narrow design for the one slot the party shares. **The direction out**: `heroes_hold_core` has been live since
  HQ and is a condition that is not a death, so a crest rune keyed on what the party CARRIES is buildable today against HO §3's
  census. **Authoring one is the designer's.**
- **WHAT NOW PRICES THEM: WHETHER A FALLEN HERO STAYS DOWN BETWEEN FIGHTS** (FOUND AT HO). Brought back at the fifth every
  victory writes, the three pay for a few turns of a fight; if a fall lasted they would pay for whole fights. **That item is no
  longer only a difficulty ruling — it sets the value of three of four crest runes, and it is owed before any of them is re-cut.**
  **It decides four other things, each a different thing (IL's brief §0.5, corrected at IL: the Cairn is an event, not a relic)**:
  - **The Cairn of the Fallen — an EVENT that cannot be drawn at all.** Its `fallen_hero` requirement is a member at 0 health
    between fights, which nothing holds (FOUND AT HO). If a fall persists the requirement becomes reachable and the event lives
    with no change. Events draw by weight and its weight of 8 is true; no RELIC carries a weight (IK's premise 27 stands).
  - **Cairnmoss Poultice — a relic, suspended since IK §6.** Its whole effect was the retired rest node's; its new effect rides
    the post-fight recovery at the number that ruling sets.
  - **Martyr's Knucklebone — a relic that works, one clause short.** It kept its victory heal and lost the dead rest clause
    (`rest_heal_add`); whether the lost clause is replaced, and with what, is the ruling's. It is the mildest of the three and may
    need nothing. `master.html`'s hook paragraph names it alone, and is right to: the other relic is suspended and the Cairn is an
    event the document does not list.
  - **The map's Revive Potion**, which has nobody to raise on the map (FOUND AT HO).

### FOUND AT ID AND NOT FIXED

- **MIRRORBOUND's RECOIL IS THE STRIKE LOOP's, AND THE CARD SAYS *AN ATTACK*.** The recoil site (`battle._resolve`, after the strike
  loop) is reached by an attack with no `special`; a damaging card resolved through `_resolve_special` (`Ability.DAMAGE_SPECIALS`
  names 24 handlers — Feint, Kill Command, Suffering among them) recoils only where its handler runs a strike back through
  `_resolve`. A player reads every damaging card as an attack. ID's rewording made the card true of the floor and of both sides; this
  scope is one word on the card or one door in the code — the designer's.
- **`check_fh` KEEPS ITS OWN DRAFT HALF** — IB kept it because it reads each card's tag line off the screen; the zone boss's offer and
  the upgrade on the same screen go through the walkers' shared helper (`Gate.answer_boss_and_upgrade`), so there is one answer to
  those two and IB's two to a draft card.

### FOUND AT IC AND NOT FIXED

- **FIVE MEMBERS THE PARTITION FOUND DORMANT** — Overkill (`overkill`), Temporal Rift (`temporal_ranks`), Spite (`spite_ranks`),
  Blowback (`blowback`) and Forge Body (`forge_body_pct`): no writer in `scripts/` or `data/`. Overkill reads the strike's zeroed
  `final` now; Temporal Rift's floor of 1 would echo 1 off a refused crit, and the other three would print a refused figure,
  the day a writer returns.

### FOUND AT IA AND NOT FIXED

- **THE STALE CLAIMS ARE NOT RETIRING**: HX's 87 stood at 87 through HY and HZ — each re-read repaired only what its own change
  falsified — and IA §5 repairs the first of them, so **86 stand**. At one a batch they last eighty-six more: **the claims batch is
  owed its own letter — IL's (II's roadmap; IJ's in IG's).** One of them is staler by IA's hand: the combat rules' header claim (FOUND AT HZ) — IA wrote into the
  intent block and the frame block again.

### FOUND AT HY AND NOT FIXED

- **FOUR STALE CLAIMS HY's RE-READ MET, REPORTED AND NOT REPAIRED (§6's rule: repair or report each).** Three are among HX's
  87, which stay a batch of their own by ruling: `docs/combat-rules.md`'s header, *every block below is byte-identical to what
  stood in `CLAUDE.md`* (HU §3b's bullet, and now HY's frame bullet, were written there after the split); `_book_self_cost`
  *reaches the recap's ledger and nothing else* (it writes the save too, through `_bank_party_losses`, since GH); and the crit
  total's *twelve statements carrying thirteen terms* (thirteen and fourteen since HB's pity meter). **The fourth stands inside
  a block moved byte for byte**: HG's supersession block cites *HD §2's four* as retirements that print what they used to
  read, and only `check_du`'s and `test_batch_az`'s do — `test_batch_ar` prints the new reading, and `test_batch_ba` prints
  nothing. The one claim HY's own change falsified, the reference's list of this file's readers, was repaired.
- **TWO OF §1c's SIX RETALIATION SITES ARE FRAMED AND DORMANT**: Spite (`spite_ranks`) and the Whole Forest's bite
  (`whole_forest`) have had no writer since FX, so no fight reaches either; each now deals under its owner's frame and puts the
  swing's back, and `check_hy` §5 drives both with the field set by hand. A batch that writes either field again inherits the
  frame already in place.

### FOUND AT HZ AND NOT FIXED

- **THE `boil_over` STATUS HAS NO WRITER SINCE HZ §2** — `unit.frenzy_bonus()` still reads it, `STATUS_INFO` keeps its row and
  `check_hw` §1a prints it; kept, the `spite_ranks` and `whole_forest` shape.
- **`docs/combat-rules.md`'s HEADER CLAIM, *every block below is byte-identical to what stood in `CLAUDE.md`*, IS STALER** — HZ
  edited two more of its blocks (the intent block, the recap-ledger block). Among HX's 87, a batch of their own.

### RULED AND NOT BUILT — **FROM HX's BRIEF; BOIL OVER, HY's, IS BUILT AT HZ §2**

- **A COPIED FROSTBIND IS REFUSED, NOT ROUTED — RULED, NOT BUILT (HV's ruling 2, answered in HX's brief).** HX changed no game
  code. The build is one condition in Downwind's carry, and the card's words owe it a third noun beside the snare and Vendetta's
  lock (the designer's). Until it is built a copied Frostbind is carried as a chip with no partner, which counts for every
  breadth reader.

### FOUND AT HX AND NOT FIXED

- **THE OLDER USER-DATA COPIES ARE THE DESIGNER'S TO CLEAR**: 455 named *Dawn of Decay* FX… to HL… and five named *DoD …* stand
  in `app_userdata` (counted at HX, after HW's eighteen went to the Trash) — outside HO §5's policy, which clears only the
  previous batch's. A ready command is in `docs/reports/HX.md` §7. *Every batch's own record of its folders is archived behind
  this line.* **HO §5's CLEARING STEP IS RETIRED FROM THE BRIEF (IB §4, the designer's — so no batch reinstates it)**: the move
  was refused at HN and at IA, so a batch no longer attempts it; it reports the count and the disk and prints ONE command that
  clears every spent prefix at once, which the designer runs when he likes (the rule's own block, `docs/instrument-rules.md`, says
  so). **HZ's fifteen, IA's fourteen and IB's twelve stand beside the older ones**; IC's count and its command are in
  `docs/reports/IC.md` §4.
- **THE TWO REFERENCES HOLD 87 STALE CLAIMS AFTER HX — COUNTED BY A CENSUS (HX §1d), NOT FIXED.** HX §1d's census holds the
  figures (`docs/reports/HX.md` §1d). HX repaired the one passage its own work
  contradicted, the readers of this file; **every other claim is listed with what is true in `docs/reports/HX.md`'s appendix**,
  beside fourteen stale comments met while verifying (thirteen in instruments, one in `run_state.gd`). The standing ones a batch
  meets first: *the four tracked documents* (six), `_ready()` for the save redirect (`_init()`), *`check_cm_live` is the only
  thing that presses the defensive bar* (`check_fh` §7 too), *`Relics.SAVE_PATH` … with no redirect* (a var since GJ), the crit
  total's *twelve statements, thirteen terms* (thirteen and fourteen), and `_book_self_cost` *reaches the recap's ledger and
  nothing else* (it writes the save). **HX's ruling 4 is answered (HY §6): a batch re-reads the claims that name what it touched, and a live count in a reference points at its instrument or carries its batch — 31 of the 87 are counts. The 87 are a batch of their own, by ruling — and 86 stand after IA §5 (FOUND AT IA).**

### HW's RULINGS OWED — **THREE LEFT; THE TOAST'S WAS ANSWERED IN HZ's BRIEF AND BUILT AT HZ §3 (IT NAMES THE PET), AND THE MERCHANT'S READING IN IN's BRIEF (BUILT AT IN §2)**

Full working: `docs/reports/HW.md`, NEEDS A RULING.

4. **COUNTER TIME BESIDE POMMEL STRIKE (§3).** At one turn it is Pommel Strike's stun without the blow — its edge is that it
   cannot miss, be parried or be blocked, and it stacks a second stun in a window. Whether it wants more is the designer's;
   its second turn back is the stun-length system, ruled out of this batch.
5. **THE WORDS, PROPOSED**: Charge's *DAZED for 2 turns* (Perfect: *Dazed for 3 turns*); Counter Time's *loses its next
   turn*, on the card and in its log line; Snare Line's card without its chilled clause; the glossary's three (Runes, the
   Peddler, Severity); `master.html`'s rows (the partner-spec table is eight). **IJ §2 has since moved Snare Line's (*Stun*,
   not *Break*) and all three glossary entries'** — what waits for confirmation is IJ's words now (IJ's ruling 10).
6. **WHICH DRAFT IS *THE CLASS RUNE DRAFT* (§1c).** Read as a hero's own pick of three — the elite's rune cache and the
   bargain's rune (one roll, `Run.roll_rune_candidates`) — the only rune draft a hero answers himself. If the brief's *the caches
   are right* meant the elite's cache keeps crest runes, the scope comes off that roll and the defect has no other door.

### FOUND AT HW AND NOT FIXED

- **A HERO'S CLICK ZONE IS STILL THE 140x220 BOX, AND NEIGHBOURS OVERLAP**: `HERO_SLOTS` sets them 80 apart across and 75 down.
  *HZ §1c made the nameplate a second hit area for the same target; the body's zone is unchanged.*
  The same fit closes it, but a companion is summoned mid-fight beside them and would be owed a fit at the summon. Not reported
  in play.
- **THE VENOM LANE DOES NOT RIDE TRAPPER'S PLAIN BARB OR EXPLOSIVE SHOT**: both lay their Poison at the status door with
  `_dot_tick`, never through `_apply_poison` (Potent Toxins, Virulence, the stamps) — `_apply_poison`'s *every Survivalist
  poison flows through here* was not so, and the comment says so now. Routing them moves magnitudes; the designer's. Since IJ §2 the Long Poison rune's words name the exclusion (*not the
  barb's or Explosive Shot's*).
- **A THIN BLOOD POISON'S CHIP STILL STATES A FIGURE WHERE IT DEALS NOTHING** (`STATUS_INFO`'s text): since IJ §2 the row reads
  *3% of the applier's Attack as nature damage per stack* (HT §2f's stale *3 nature damage* repaired), which a Thin Blood poison
  does not deal; a second stack's re-written line reads 0.
- **`run_battery.sh` STILL DOES NOT ASK WHETHER THE GAME IS OPEN, AND A PLAIN `kill` STILL DOES NOT STOP IT** (HT's two, carried).
### THE PLAYTEST'S OTHER FINDINGS — **LATER BATCHES BY RULING (HW's brief §5); THE ROADMAP HOLDS THE ORDER**

- **THE RE-MEASURE RAN AT IQ §3, ON BOTH FILES — PRICED, NOT BUILT (IC §5's schedule, kept)**: HV §3b's census over the twenty
  batches HW–IP, and HV §3f's shape priced on today's files — `CLAUDE.md` read at about 245 KiB of 472 a batch (48% less, where
  HV found 38%), this file at about 85 KiB of HEAD's 361 (77% less) — with what building it re-points (`docs/reports/IQ.md` §3).
  **Whether to build the block index, for which file, or HV's pilot first, is IQ's ruling 2: nothing waits on another
  measurement.**
  **THE ORDER:**
- **IR — THE CLAIMS**: HX's 87 stand at **86** — the per-batch re-read stops the backlog growing and does not retire it, so it is a
  batch of its own (FOUND AT HX, FOUND AT IA). **The Cairn's *weight 8* is not one of them and is true** (an event's weight; IL
  §0.5), so the figure does not fall for it.
- **MANA STAYS (ruled).** The finding was that the Mage and the Hunter run dry and only the Cleric is always full; **measured at IE
  the sim does not show it**, and IF found the cause the designer saw — the Cracked Hourglass refilled the Cleric and not the Hunter
  (repaired, IF §0.1b); the rate is unmoved and is ruled after the readout (IF's rulings 1 and 2). **Channel's tempo payout — Mana
  spent buys speed — is alive and still owed.**
- **Unchanged, and said so**: `CONJUNCTIONS` keeps its one row and `RUPTURE_BREAK_PER_TICK` stays at 10 — **and the first clean
  playthrough says Rupture is UNREACHABLE, NOT MIS-TUNED (IP §0.1)**: its one Rupture stood none of its body's turns, because the
  Cryomancer that chilled it froze it, and a Rupture grinds on its body's own turns — the designer's to author, not a number's
  (THE FIRST CLEAN PLAYTHROUGH, above); before it, it was unfelt until the designer's
  play is read (IH §0.2 read one, debug-touched: it stood one turn, and its tick's 13 is an Orc Slinger's Constitution on the 10) — **IE §3a said why it could not have been** (a Rupture at 0.7% to 4.5% of a Mage's turns at IE's HEAD), and **IF
  made it reachable and readable**: Smoulder lights a chilled body (a Cryomancer holding it stands a Rupture at 15% of his turns,
  IF §2) and the readout writes every one that forms, its ticks and its Break (IF §1); a meter is
  not a conjunction half; Marrowfire becomes Sunder + Burn pending the design pass; the Occultist's Break card is CE §3's ask;
  the Skirmisher and the Tracker are ruled and unbuilt, with Volley's and Ambusher's core slots and both names owed; whether a
  fallen hero stays down between fights (it prices three crest runes, two relics, an event and the map's Revive Potion — IL §0.5); Tithe's read site; **the strike
  payouts' widening, a measurement — and whether Profligate's price narrows with its payout, a magnitude (both IK §5)**; **no page key and no targeted debug card pick** — each available if
  the designer asks (HU; recorded nowhere in this file until HX).
### FOUND AT HV AND NOT FIXED

- **OPEN LINE OWES AN `ENGINE_READ` ROW (the Stances).** It requires Guard Change, which only the Stances bring since HL §1, and
  HC §2's clause makes such a rune a row; `check_gv` still sorts it HALF. Worn with the Stances unslotted it pays nothing and says
  nothing, and a queued cache can hand it over without Guard Change. HL had the rune-scope block open and missed the clause.
- **`Run.rune_choice` NEVER ASKS `Runes.is_refused`** (FD §1's re-ask at a queued offer's answer; HR withheld a refused rune at
  the roll only). Reachable only by a saved queued offer of a now-refused rune.
- **A COPIED ELEMENTAL WEAKNESS SKIPS ITS DOOR'S LAST STEP**: `_apply_elem_weak` rewrites the chip to the value, the copy wears
  the table's *EW* and pays the same — display only, the hold's shape a fourth time, one line to route.
- **STALE LINES IN `CLAUDE.md`**: the rune-scope block's *(the block THE PARTY SCOPE, AND THE TWO RUNES IT HOLDS below); two
  entries carry it* (five carry the scope since HP); the drop block's *HO's rule that one choice is never two things* (HL §1's);
  the governor table's Ruin *never clears* (the live Open Wound rune decays it a stack a turn); the no-engine block's kit list
  omits Pommel Strike's Stun. **And in `docs/combat-rules.md`** (§3e's audit): the crit block's *twelve statements, carrying
  thirteen terms* (fourteen since HB's pity meter), the charges block's *single-target* premise (Seeking Missiles since HF),
  the header's *byte-identical* (HU edited CR §1), HU's own *as every other caller does* (Frostbind's mate forwards `force`), the
  clamp list and the six banks one site short each, and the BURN MAGNITUDE line (HR's, carried).
### FOUND AT HT AND NOT FIXED

- **`run_battery.sh` DOES NOT ASK WHETHER THE GAME IS OPEN, AND A PLAYER-FILE ARM CANNOT TELL A GATE'S WRITE FROM THE PLAYER'S**:
  the battery in the repository shares the live user folder with the game, so a designer playing during it reds every gate whose
  window a save lands in (six at HT, each by its §9 — §7 in `check_hp` — arm). A runner that refuses to start, or says so, while
  a non-headless Godot holds the project closes it; not taken (outside the brief).
- **THE RITE'S SECOND ID READ IS THE SAME SHAPE AS THE ONE §1.4 FIXED**: a stripped `ruin` takes `ruin_primed` too — correct while
  Ruin is no ingredient; Reckoning's batch owes it the lookup, beside `log_bleed_chip` and `set_ruin_stacks` (HS).
- **A PLAIN `kill` DOES NOT STOP THE BATTERY**: `run_battery.sh`'s `trap 'rmdir "$LOCK"' EXIT INT TERM` runs on TERM and the loop
  goes on — with its lock gone, so a second battery could start writing the same `$OUT` (CP's data fault). An `exit` in the
  INT/TERM trap closes it; not taken (outside the brief). Stop a battery with `kill -9` on its shell, then its Godot.
- **THE CENSUS'S OWN FINDINGS (`docs/reports/HT.md` §2f), ONE TOUCHED AT IJ §2 (Poison's chip row)**: card text the code does not pay (ruling 5); rules that
  meet badly — a re-applied Poison SETS its clock (it can shorten, and ends a permanent Long Poison), a fresh Poison skips its
  first tick, a purge takes Bleed's chip and leaves its meter (Cull and Harvest paid for a bleed that stays), a Downwind copy of
  Ruin can skip a detonation, a primed body emptied of Ruin still detonates, Downwind's bare copies (a partner-less Frostbind, a
  poison without `_apply_poison`'s stamps, a second permanent taunt off Vendetta, a second spring off Snare Trap — **ruled at
  HV §2: the snare and Vendetta's lock are not carried, the Ruin stack and the poison take their route, the Frostbind is owed a
  ruling**), Frostbind's partner found by name, ~~two shared chip tags~~ (**re-tagged at HU §4**, with eleven
  more the sweep found); stale text — Ruin's row
  and chip under the Open Wound and Deepening Hex runes, the primer's *next acts*, Poison's *refresh* (its *3 nature damage per stack* repaired at
  IJ §2), Rime's *every stack*, `VENDETTA_CUT` read by nothing, comments on the dormant Whole Room, on Bewitch's Daze, on
  Lingering Torment and on deleted talent nodes; twenty-odd dormant appliers and six dead branches, listed there.
### FOUND AT HS AND NOT FIXED

- **TITHE DOES NOT PAY ON A RUPTURE'S BREAK**, though the brief gives it as a reason for Break: its read site is a hero's
  landed blow in the strike loop, and a tick has no attacker. That read site is §7's owed work, not this batch's.
- **TWO READERS STILL LOOK AT THE TOP LEVEL ONLY**: `log_bleed_chip` and `set_ruin_stacks`. Correct while neither Bleed nor
  Ruin is an ingredient; the batch that authors Contagion or Reckoning re-points them to the lookup — with the rite's `ruin` →
  `ruin_primed`, the same shape (FOUND AT HT).
### THE FOUR OTHER CONJUNCTIONS — **DESIGNED; RULED, NOT BUILT (HS §4); A METER STATE IS NOT A HALF (RULED AT HU), SO THREE ARE RE-CUT**

**Unpriced content ships in the smallest unit that can be felt**: one is played and tuned before the next arrive. **A meter
state is not a conjunction half** (`CLAUDE.md`'s conjunction block): Broken and Bleed are meters with a chip, and a cleanse would
lift the chip and leave the meter. **The Warrior's half is a status he already lays** — Sunder, Stunned or Mocked, all from his kit.
- **Seize** — Chilled + Cripple: the target loses its turn. The Mage's chill beside a card that cripples. Two statuses the door
  can see; unchanged.
- **Marrowfire** (*Breach* until HT §3) — **Sunder + Burn, pending the design pass** (it was Broken + Burn). Ships as a named
  near-miss when it ships.
- **Contagion** (*Blight* until HT §3) — Poison + Bleed, **re-cut owed** (Bleed is a meter); **the name waits on the re-cut**.
- **Reckoning** — Ruin + Broken, **re-cut owed** (Broken is a meter).
- **THE OCCULTIST'S HOLE IS NOT A CONJUNCTION PROBLEM**: Madness is boss-gated on Broken and nothing live in his pool grinds the
  meter, so no conjunction could open that gate while meters are not halves. **It is CE §3's original ask — a Break card in his
  pool — and it is owed on its own.**
- **A TARGETED DEBUG CARD PICK IS NOT BUILT**: the pager makes the unlock-all bar navigable, which was the designer's ask; a debug
  tool that hands a hero exactly the cards a test needs is available if paging fifty cards proves worse than the overflow did.
- **THE APPLIER CENSUS IS TAKEN** (`docs/reports/HT.md` §2): every status a hero lays on an enemy — forty-four — by class, with
  its readers, its re-application rule, its duration and its `DEBUFF_IDS` row. It proposes nothing: the next conjunction, its
  halves and its class pair are the designer's (HT's ruling 6). **The draft label** that names which conjunction a card touches
  ships with the second and third — RULED, NOT BUILT: with one recipe and four heroes there is nothing to look up. **A tier 3
  must do something no card can do**; none is designed.

### FOUND AT HR AND NOT FIXED

- **THE CENSUS FOUND THE DOCUMENTS DISAGREEING WITH THE CODE ON FIRE AND ICE** (`docs/reports/HR.md` §4h): ~~`master.html`
  pays Shatter per stack (the code: per turn held), gives the hold window *+15% from all sources* (hero strikes only), has
  Firedraw take *what is there or 4* (always 6), has Emberkeep double *every Burn he applies* in one row (any hero's) and
  lay 4 through Flamewave (a burning body skips the doubling), says only the Tyrant's frost weakness is set, and names
  four Overburn refund consumers (six)~~ — **ALL SEVEN CORRECTED AT HT §3**, with every copy found off the document (the
  glossary's Overburn, the Glacial Hold rule text, three `battle.gd` comments and one in `classes.gd`); ~~`CLAUDE.md`'s DR §1
  block lists Burn and Chilled among statuses exclusive to a class and its recast block says a re-application resolves as
  `max()`~~ — **BOTH CORRECTED AT HS §1**; `docs/combat-rules.md` calls Burn's crit snapshot *a BURN MAGNITUDE* (nothing
  reads it); and six code comments are stale (§4h names them). None is player-facing; each is a sweep for the batch that
  touches it.
- **THE SIM NEVER ANSWERS A BARGAIN'S RUNE CACHE**, so every supply figure it prints omits 0.8–1.15 runes a hero a run.
### FOUND AT HP AND NOT FIXED

- **TITHE'S READ SITE OWES A TALENT REBALANCE, NOT A WIDENING IN PASSING (ruled at HP §4: recorded as owed).** It is
  *Breaking Heals a Hero*'s site too, every class can buy it, and it was tuned against the narrow read. HO's figures for
  the gap are `docs/reports/HO.md` §3a: a Warden on the Long Watch books about **1.4 times the Break for the same
  pay**, and fully talented the gap widens, because the tree's own procs never reach the site. Widening it is its own
  measurement and its own batch.
### THE SKIRMISHER AND THE TRACKER — **RULED INTO ORDINARY RUNES, RULED, NOT BUILT (recorded at HP §7)**

Ruled in conversation and never briefed. **Both are live core runes today**, dealt and slotted as any of the nine, and
each owes a NEW NAME before it is built. A brief that cites their retirement as precedent cites a ruling, not the
game — HO caught one. `CLAUDE.md`'s rule-engine block carries the same marker.

### FOUND AT HO AND NOT FIXED — **SIX CLOSED AT HP**

- **THE EVENT *THE CAIRN OF THE FALLEN* CANNOT BE DRAWN, AND A REVIVE POTION HAS NOBODY TO RAISE ON THE MAP — BOTH WAIT ON
  A RULING: WHETHER A FALLEN HERO STAYS DOWN BETWEEN FIGHTS (still open, not decided at HP, HP §7).** It is a difficulty
  ruling — **and since IA §0.2 (the designer's) it prices three of the four crest runes**, which pay for a few turns while a fall
  lasts a fight and would pay for whole fights if a fall lasted longer: it is owed before any of them is re-cut (THE CREST POOL,
  above). HP's ruling 1 had decoupled it from the runes' authoring. `fallen_cairn` (an event's weight 8, true — IL §0.5)
  requires a member at 0 health and raises the fallen at 35%; **Cairnmoss Poultice waits on the same ruling since IK §6** (suspended
  from every draw, its re-cut riding the post-fight recovery); the one line that writes a member's health to 0 is the
  fight's own banking (`battle._bank_party_losses`), which stops once a fight is decided, and every victory then writes
  at least a fifth. **0 of 3,957 events drawn across HO's measurement runs**, where each of the other nineteen was drawn
  at least 18 times. `map_screen._use_item` offers a Revive Potion *the fallen* and can only answer *"No one to use the
  Revive Potion on."* Since IJ §2 the glossary no longer says a Revive Potion works on the map.
- **TITHE'S RULE PAYS AT LEAST 1 A BLOW, EVEN ON A BLOW THAT APPLIED NO BREAK, AND A PARTY AT FULL HEALTH PAYS THE
  WARRIOR** (ties go to seat order) and wastes it. Both are the talent's read site, unchanged (the owed rebalance, HP).
- **THE TALENT *Cleanse Debuffs Each Turn* CAN CLEAR THE BLEED WARNING CHIP**, which comes back on the next hit
  (`dispel_one_debuff` takes it where `_cleansable_debuffs` refuses it). Fellowship could, and is retired (HP §3); a saved
  run wearing it still can.
- **`check_gv` §4's EVENT DOOR HAS NEVER FIRED.** Its roads press an event's first choice, and the only event that
  grants a rune grants it on its second. The branch is re-pointed at HO and is still an arm that never runs; the verb
  itself is `check_gv` §2e's and `check_ho` §1e's.
- **SHAPES THAT ARE NOT LIVE FOR THE CREST RUNES AND WOULD BE FOR ANOTHER KIND** (`docs/reports/HO.md` §7): a crest rune
  that GRANTS a card is in scope for nobody in `check_et` §4 and credited to no class in `check_ea` §1; one with a
  healing cost is min-ed as an alternative, not stacked, in `test_runes` `_healing_floor` and `test_batch_ax` §5; one
  that writes a ceiling is unguarded (`test_runes` `_ordering` pins the hero-rune site only). **A live condition is
  now authored** (HP §2), and `test_batch_ak`'s whole-pool walk applies it under a party-less ctx, where it pays
  nothing — **its claim narrowed at HQ §3 to what it proves** (the shared applicator takes every payload without a
  throw); `check_ez` §4 lands each on a party it holds for, and `check_hp` §2 drives the three through a real fight.
- **`check_gf` COMPARES NOTHING OF THE BAG, THE CREST OR THE WAITING DROPS ACROSS A QUIT.** `check_hk` §5 and
  `check_ho` §1f round-trip them through the save, and `check_hp` §1e quits with a live crest worn; no gate quits with
  the bag held and resumes.
- **TWO STALE THINGS THE CENSUS MET, NEITHER THE CREST'S**: `check_ct_map.gd:107`'s *supplies end above the draft
  header* arm has been vacuous since FD §1 took the draft off the Peddler, and `check_gp.gd:1039` says `hold_rune`
  slots an engine while a slot is free, false since HL §1.
### FOUND AT HN AND NOT FIXED

- **THE CENSUS'S MISSING SHAPES, PRICED FOR THE DESIGN PASS** (`docs/reports/HN.md` §3b, §3c, §3e): one key twice, an OR,
  and *any class twice* — each a few lines in `Talents.party_condition_met` and a drive. None is built.
### THE SHAPE RECON ON `CLAUDE.md` — **QUEUED AT HN §1, RUN AT HV §3, RULED AT HX §0: THE CHECKS, THIS FILE'S TRIM, THEN A RE-MEASURE**

The question it asked: **whether an index plus subjects read on demand beats one file with a moving ceiling.** It is not GY's
reasoning split, which stays rejected. The figures, the two natural experiments and the recommendation are in
`docs/reports/HV.md` §3. **Ruled at HX §0 (the designer's)**: the checks first — built, `check_hx` §1 — then this file's
trim — taken, HX §2 — then a re-measure, one section of the next batch: §3b's census over the batches since HV, the read this
trim left, and the checks' record. **HV's nine-unit pilot and the block index both waited on it, and it ran at IQ §3**, over the twenty batches HW–IP and on both
files: the block index beats one file with a moving ceiling on the read — `CLAUDE.md` 48% less a batch, where HV found 38%, and
this file 77% less — and building it is IQ's ruling 2. The live headroom is in the WHERE block.

### TO WATCH IN PLAY — **RULED AT HN §2; EACH IS ONE CONSTANT OR ONE LINE IF IT READS WRONG**

- **THE TALENT BOARD's WRAPPED NODE NAMES ON THE SHEET (II §0.6, the designer's).** The board was not widened: it is locked for
  the run and read as reference. If its wrapped names read badly in play, that is a small item of its own — and the readout will
  not find it; the designer's eyes will.
- **The Devout's own Faith never releases, so once he reaches the top he sits at 16% less damage taken and +12% damage
  dealt for the rest of the fight.** One constant if it reads absurd.
- **Defensive is now the weaker stance** — Aggressive's upside doubled to +30% and Defensive's cut stayed at 15%. A
  playtest question, not a batch's.
- **A fallen hero switches a live crest the moment he falls, and back the moment he is raised** (HP §1; the standing
  reading chosen at HN). Whether a switch reads as a moment or as noise is a playtest question.
- **TITHE AT 30 AND THE THREE LIVE CREST RUNES, ALL RULED (HP §0, HQ §1).** Whether 30% of the Break a blow applies is
  felt; and whether Empty Pulpit, Dead Air and Dirge are felt in the moments they pay — each is one number in
  `data/runes.json`. Fellowship is retired (HP §3).
- **EMPTY PULPIT PAYS MOSTLY INSIDE FIGHTS ALREADY BEING LOST (ruled at HQ §1: a watch item, not a defect).** In a normal
  fight that is WON the Cleric is down for 2% of the damage taken (HP §2a): the Cleric mostly falls in fights already
  going badly, so that is a property of the state and not of the figure. Whether it is felt when it holds is the
  playtest question.
- **THREE CORES MAY DILUTE THE DIRECTIONAL (IA §2, the designer's watch item).** `CLAUDE.md`'s charter says a core rune must change
  what a hero optimises for, and the test is *name the cards it tells you to draft*. A hero wearing three cores is optimising for
  three things, which may be optimising for nothing. **THE LEVER, NAMED AND NOT BUILT: the third slot could be EARNED rather than
  given** — gated behind a rung, so the early run keeps one direction and the third core is a progression reward. Three is ruled;
  this is the thing play compares against.
- **THE EVENT VERB IS AN UNAUTHORED SOURCE OF CORE RUNES (IB §0.4, the designer's watch item).** Its grant prefers an ordinary
  rune and falls back on the whole roll once a hero's ordinary pool is spent, core runes included — held unworn since IA. **Watch
  whether an ordinary pool actually runs dry in a run played forward**: if it does, events become the main source of core runes, and
  nobody authored that. The fallback is kept (it beats granting nothing); three core slots make this faucet matter more.
- **THE ARRIVAL'S WEIGHT (IB §1; ID §1).** After an elite the four heroes' screens open one after another, and after a zone boss
  the same four screens with the boss's offer in ABILITIES — one screen a hero, whatever he is owed. Whether that reads as a reminder
  or as a queue to click through is play's to say — the walk's order and its dismissal are one function each
  (`map_screen._arrival_next`, `_arrival_dismissed`).
- **THE VOW IMPROVES AS THE RUN GOES ON (ID §0.2, the designer's watch item) — AND IN ZONE ONE IT ALREADY PAID 2.2 TO 1 (IP §0.1):**
  the first clean playthrough wore it seven fights, 322 damage refused for 707 healing added, where ID ruled it roughly even —
  an auto-take at rung 2. Owed to the designer (THE FIRST CLEAN PLAYTHROUGH, above). Its cost is a flat refusal of every blow he lands —
  18 a Smite is a real cost in zone one and noise in zone three — while its +50% healing only grows: a decision early, an auto-take
  late. **THE LEVER, NAMED AND NOT BUILT: a cost that scales**, rather than a flat heal bonus. Never worn in a real fight.
- **THE HOURGLASS MADE THE HUNTER FIFTEEN POINTS LESS DRY (IF §0.1b; recorded at IG's brief §0.2, not tuned).** Untalented he
  went from dry 36.0% of his turns to 20.9% when the relic began to reach him, as its card said — the largest single resource
  change a repair has made, and a real power increase for a class nobody priced. The relic is not re-priced.
- **Communion's 105% at the top of its band stays dormant and flagged** (`communion_ranks`, which nothing writes);
  `test_batch_be` §6 reds the day a writer arrives.

### FOUND AT HL AND NOT FIXED

- **THREE CARD TEXTS USE *ENGINE* AS A WORD FOR A RULE** (`classes.gd:4059`, `:5822`, `:7142` at IJ, which tokenised two of the three and kept the word) — card text, left as
  authored (ruled at HN: the designer's); a player reads *core rune* on every screen and *engine* on three cards.
- **AN OLD SAVE WHOSE SWORDMASTER DRAFTED GUARD CHANGE HOLDS IT TWICE** and pays a slot for the earned copy until he
  benches it. None on disk.
- **THE THIRTEEN COMBAT-LOG LITERALS STAY LITERALS** (HL §9) — reading the name off the data is the durable form, and it
  is not a batch the brief has taken.

### HJ's RULINGS OWED — **ONE, AND NOTHING WAITS ON IT**

Full working: `docs/reports/HJ.md`, NEEDS A RULING.

1. **THE DEBUG TOGGLE'S NAME — PROPOSED: *"All Class Abilities Unlocked"*.** HI's ruling is built: the toggle grants the
   hero's class draft pool and his lineage's zone-boss pool (the boss half is HJ's implementation call — the boss pools
   were not merged — stated so it can be ruled otherwise). The label is the map burger's menu item and nothing keys on
   it; the variable and the sim flag never said *spec*. Confirm, or name it.

### THE CROSS-TARGET SUPERSESSIONS — **RECORDED AT BOTH ENDS AT HH; A BATCH THAT RETIRES OR NARROWS A SUPERSEDER READS THIS FIRST**

| retired arm | stands on | control |
|---|---|---|
| `test_batch_bp` §5, the tranche arm's class-wide half | `test_batch_bt`, `test_batch_cb` and `test_batch_ce` `_names()` | c2 |
| `test_batch_cp` §2, the class-wide half | the same three | c2 |
| `test_batch_bv`, the Hunter enabler arm | `test_batch_bp` §5's enabler arm — **re-pointed over the class pool at HI, still asking Quick Shot** | c3 |
| `test_batch_bw`, BO's enabler arm | `test_batch_bp` §5's enabler arm; `check_gs` §1 (five of six) | c3 |
| `check_dv` §2, the Holy slot tripwire | `check_gs` §0 | c4 |
| `test_batch_ah` §1, the trims' "left the kit" arm | `check_gs` §1 | c1 |
| `test_batch_bp` §5, every-spec-has-a-draft (half) | `test_batch_cd` §2's depth table (the other half is `bp`'s own class floors) | c6 |
| `test_batch_cd` §2, the per-shelf floor (half) | `Fixture.class_pool_floors`, asserted in eleven other suites **and in `cd` itself since HI folded its class-wide floor** (the other half is `cd`'s own depth table) | c6 |

### HF's RULINGS OWED — **FIVE; THE FIRST THREE ARE MAGNITUDES THE BRIEF LEFT UNSET, THE FOURTH IS WORDING**

Full working: `docs/reports/HF.md`, NEEDS A RULING.

1. **BURNING GROUND'S BURN — PROPOSED 5% OF THE CLERIC'S MAXIMUM HEALTH, HOLY, AT THE START OF EACH OF HIS TURNS WHILE
   HIS CONSECRATION HOLDS.** Priced against Consecration's own 5% heal, pointed the other way: four burns a cast, 6 to
   each enemy at his 121 maximum, 72 over a cast against three enemies beside the heal's ~97 across four heroes. The
   magnitude is the rune's payload (`rune_burning_ground` 0.05), so a ruling moves data. If the card should name a
   number, wording is proposed.
2. **APER'S BODY, CHARGE AND BOON — PROPOSED.** 80 health and a charge of 20% of the Hunter's Attack (the wolf's and the
   eagle's); Pack Bond's boon its own charge, 15% harder a step of the bond's curve (the wolf's rate). No arrival
   effect and no raw-stack gift: none was authored.
3. **ABUNDANCE'S SHIELD — IT ADDS, IT HOLDS TWO TURNS (PROPOSED), AND NO CEILING WAS WRITTEN.** Under Consecration it
   grows by the drip's spill every turn (about 5% of each maximum), and it is bounded by the healing poured into full
   bars. Cap it, or let it stand.
4. **MARK OF THE HUNT'S TEXT — TWO PROPOSALS THAT NAME WHAT EACH HALF NEEDS.** (A) keeps the card's five lines and
   replaces the sixth; (B) also takes out the *"you"* and *"your"* the text standard forbids. HE's proposal no longer
   fits. The designer confirms.
5. **KILL COMMAND HAS NO ORDER FOR APER, AND GHOSTPACK AND CALL OF THE WILD NAME THE THREE.** A card that orders a
   companion by kind does nothing for a kind it does not name; none was given an arm (a card's effect is the
   designer's). The smallest fix, if wanted: Aper obeys Kill Command with an ordinary charge.

### FOUND AT HF AND NOT FIXED

- **SUMMON COMPANION'S TEXT NAMES THREE COMPANIONS**, and with Tusk and Bristle worn the picker offers a fourth. The
  card's text is authored; the rune's own text says what it adds, and the picker shows Aper's call with its own
  description. Wording is the designer's.
- **A VENOM COATING CARRIED WITHOUT TRAPPER IS STILL SEATED.** HF §7 gates the OFFER; the card casts with no engine
  (the coating lands and pays nothing), so the seat derivation — the door refusing a card bare — never finds it, and a
  copy drafted under Trapper stays on the bar after Trapper is dropped. A seat row would be a ruling (HE §2's shape for
  Mark of the Hunt, since undone).
- **RETURNED BURDEN FINDS ITS APPLIER BY NAME.** A status carries its applier's name (`src_name`, DI's rule), and two
  enemies of one kind share a name, so the first of that name on the field takes the burden back.
- **DETONATING WARD PAYS ON TWO REMOVALS, NOT EVERY ONE.** It detonates when the ward BREAKS (`barrier_broken_cb`) or
  ENDS (`status_expired_cb`); a barrier stripped another way — a purge, a replacement by a smaller ward, the fight
  ending — pays nothing, and the absorbed total resets at the next cast.
- **BURNING GROUND STOPS WHEN THE CLERIC FALLS.** It burns at the start of HIS turn, and a fallen Cleric has none, while
  the ground he laid goes on healing the others for its remaining turns.
### HD's RULINGS OWED — **ONE LEFT; THREE CLOSED AT HE (1 AND 2 RULED AND BUILT AT HE §3, 3 KEPT AT HE §5 AS THE REPRICE'S PINS)**

Full working: `docs/reports/HD.md`, NEEDS A RULING.

4. **THE BRIEF'S §3 FIGURES WENT TO THE RUNES, AND THE FOLD TOOK THE CARDS' OWN.** The thirty-five floors are card-pool
   floors; the figures were HC's rune table (a hero holding no engine is offered no Cleric rune, but 29 Cleric cards).
   Built both ways (`docs/reports/HD.md` §3); confirm that is what was meant. **HE's brief did not answer it, so it is
   still owed**; the rune floor has since moved (HE §1).

### HA's RULINGS OWED — **TWO LEFT, BOTH ABOUT `main`; THE FIRST IS ANSWERED BY HB's SEQUENCE AND ALL FIVE OF THE SECOND WERE RULED FOR HD**


Full working: `docs/reports/HA.md`, NEEDS A RULING.

3. **`main` HAS NO FORWARD GUARD ON THE RUN SAVE.** Driven at HA §3c in isolated copies seeded from the player's saves:
   `main` refuses the merged build's v3 profile and writes nothing — FQ's guard, working as built — but **loads its v13
   run save without a word and seats three of the four heroes with their basic attack alone**, because they took a
   spine or a rule engine and `main` has no class kits or engine runes. **The saves on disk are already the merged
   build's.** A refusal in `main`'s `load_run`, in the profile's shape, is a small code change on `main`; whether it is
   made before `main` is next played, or the merge simply lands first, is the designer's.
4. **THE BRANCH IS NOT READY TO LAND, AND TWO THINGS STAND BETWEEN IT AND READY** (HA §3d): the middle group, and the
   lineage layers GK's charter rules away and nothing has built — ~~spec-scoped runes~~ (**merged at HC**: every rune is
   scoped to its class and three gates decide, `docs/reports/HC.md`), per-lineage boss pools and stat blocks. **The
   rune layer was the one a player meets first**: at HA a hero who took a spine or a rule engine was offered no ordinary
   rune at all; **since HC a Warrior, a Mage or a Hunter is, and a Cleric still is not** (HC's finding). Whether those layers
   merge before landing or after is the designer's. **Tag `b722cc4` before merging** if the pre-merge game should stay
   one checkout away; nothing tags it today.

### FOUND AT HA AND NOT FIXED

- **AT LEAST TWENTY-THREE TARGETS SEAT A LINEAGE BY HAND WITH NO ENGINE RUNE**, against GK's *"a hand-built seat must
  too"*. Harmless in most; not in `check_et` (every `Runes.ENGINE_READ` rune withheld from its retirement walks —
  `check_fd`'s identical helper was repaired at GV and this one never was), `test_runes`' exhaustion and start-pool
  members, `check_fm`'s `_member`, and `test_batch_bo` §2/§3, where it is what makes three arms vacuous. The list is in
  the report's §1g.
- **`Run.ability_slots_used` IS LINEAGE-KEYED, AND SINCE HB IT READS ONE ENGINE QUESTION** — whether one held dismisses
  the pet (`Classes.kit_slots(class, spec, engines)`) — so two gate arms are still near-tautologies against its
  lineage half (`check_gm:378`, `check_gn:197`). Correct while `lineage_slots` is zero for every lineage.
- **THREE GATES CHECK TWELVE ENGINES' TEXT WHERE THERE ARE TWENTY-FOUR** (`check_cl_resolver`, `check_cl_width`,
  `check_do` §4), reaching it through `SPEC_INFO[s]["passive_desc"]`; the spines' and the rule engines' texts are never
  checked. None carries CL's value token; since IJ §2 their figures are `{=…}` tokens `Classes.engine_desc` resolves
  (`check_cl_width` reads them resolved, `check_cl_resolver` and `check_do` §4 the raw text).
- **SMALL AND DEAD:** `check_di:391`'s `_hero(scene, "pack_bond")` can never match (the id is `pack`); `test_batch_cp`'s
  `PASSIVE_OF` maps the Beastmaster to `"loyalty"`; `check_cy`'s sweep always casts from the first living hero, so its
  two-party reason is never exercised.
### GZ's RULINGS OWED — **ONE LEFT, AND IT IS A GATE THAT PASSES WHEN IT SHOULD NOT; THE SECOND IS RULED AND TAKEN AT HA §4**

Full working: `docs/reports/GZ.md`, NEEDS A RULING.

1. **`check_dv` §4's HEADER ARM IS SATISFIED BY THE RECORD OF A CUT RATHER THAN BY THIS CUT, AND IT ALWAYS WILL
   BE.** The live header names **every** cut in its own history, so `contains("Batch FG</b> at EP/EQ")` was still
   true on a tree where FG's boundary had stopped being the boundary — **measured, not argued: four of the five
   boundary literals failed against the cut tree and this one passed.** DV's version was an alternation whose weak
   member was always true; FG replaced it with a pin on the cutting batch's own clause, **which asks its question
   for exactly one batch and is then satisfied by the record again**. The difference is only that it takes a cut
   rather than a rename to break it. **`check_ec` §1 cannot report it** — it reads alternations, and this is a
   single `contains` that resolves. **The repair is a pin on the header's LAST cut clause, or on the boundary its
   opening sentence states**, either of which is a different arm owing a two-armed control on a real cut, so it is
   its own batch by FZ's pricing rule. Re-pointed to `Batch GZ</b> at FS/FT` here and not repaired.

### GY's RULINGS OWED — **THREE; NONE IS PLAYER-VISIBLE, AND THE FIRST SHAPES THE NEXT BATCH**

Full working: `docs/reports/GY.md`, NEEDS A RULING.

2. **SEVENTY-THREE DESIGN-NOTES ENTRIES ARE OUT OF THE STATED ORDER, AND THE FILE IS TWO BLOCKS.** §2b above. The
   top 111 entries are newest-first but for one inversion; the bottom 75 are a second, oldest-first chronological
   log. **Moving 73 entries is a file rewrite and nothing asserts on position**, so it is free whenever it is ruled
   and it will not decay further now the instruction is repaired. **The two entries GY moved kept the heading form
   they were written in** (`## Batch GW — <title>`, no date) rather than the top block's `## <Title> (Batch XX) —
   <date>`; only position was ruled, so only position moved.
3. **FOUR ARMS FIND THEIR SUBJECT BY THE PROPERTY THEY TEST, AND TWO OF THE FOUR PASS VACUOUSLY.** §3b above and
   `docs/reports/GY.md` §3c. `check_gx:412` and `check_gx:769` fail by absence where they should fail by
   measurement — a red naming the wrong cause, with the assertions behind the locate skipped. **`test_batch_as:900`
   and `check_ct_map:96` do not fail at all**: both filter by a rendered value and assert the result is empty or
   unreached, so a reformat makes the filter match nothing and the arm passes. **Repairing them is its own batch** —
   two need a re-point onto a stable key and two need a liveness arm, which is a different repair again, and each
   owes a two-armed control on a live drive. FZ's pricing rule is why it was not taken here. **The cure for the
   third is twelve lines below it in its own file**: `_live_turn_bar` runs the identical filter and asserts a
   positive count before it asserts a zero one.

### FOUND AT GY AND NOT FIXED

- **THE §2 REPAIR IS A RULE WITH NO INSTRUMENT, AND THAT IS THE REASON THE DRIFT LASTED SIX BATCHES.** Nothing
  asserts on an entry's position in `docs/design-notes.md` — the three suites that read the file (`test_batch_bn`,
  `test_batch_bs`, `test_batch_ce`) ask only that their own batch is named — so GK, GM, GN, GO, GV and GW each wrote
  to the foot and every battery stayed green. **A gate is buildable and was not built**: the file's top block has a
  boundary only a reader can see, and an arm asserting order over the whole file would red on the 75-entry tail this
  batch deliberately left standing. **It is ruling 2 that decides whether that arm can exist.**
- **GR's RULING 1 IS STILL OWED AND WAS NOT TAKEN WITH RULING 2.** `docs/combat-rules.md` has no stated ceiling; EE's
  method on its own record gives it 70 KiB (GR §5c). It sits beside this batch's subject and is a different file and
  a different ruling.

### GX's RULINGS OWED — **ONE LEFT; THE SECOND AND THIRD ARE BOTH CLOSED AT GY**

Full working: `docs/reports/GX.md`, NEEDS A RULING.

1. **THE BATTLE LOG'S ROLL CALL WAS A FOURTH SURFACE AND THE BRIEF NAMED THREE.** The brief's §1 listed the pouch,
   the hero sheet, the Peddler and a cache offer. The census found a fifth thing that shows a held rune — the
   `Rune:` lines the spawn writes into the combat log — and **a rune that sits out was named there in the log of a
   fight it paid nothing in**. It says so now. **This is the one place GX went past what the brief named**, on the
   brief's own instruction that *every* surface says it, and the asymmetry is real: a card that sits out is absent
   from the fight, so GT had nothing to mark; a rune is still equipped and its payload is still applied. Whether a
   log line should carry it, or the screens are enough, is the designer's.

### GW's RULINGS OWED — **FOUR; THE FIRST TWO CHANGE WHAT A RUNE IS WORTH**

Full working: `docs/reports/GW.md`, NEEDS A RULING.

3. **§2's NINETY OTHER HAND-SETS ARE REPORTED AND RULED ON BY NOBODY.** Ninety-two sites in nine files arrange a rune,
   an engine or a talent field rather than letting the game write it; two were the defect and are repaired, and the
   other ninety are on the body the game writes it to. Repairing them is a change to ninety checks across nine files.
   `check_gw` §2 holds the count at a ceiling of 90 so it cannot grow in silence. **Whether that batch is worth taking
   is the designer's**, and FZ's pricing rule applies.
4. **`check_ez` §4's WRITER SWEEP WAS REPAIRED TO INTENT RATHER THAN EXEMPTED.** It accused the new copy — a script
   writing a `rune_` field — and the charter it enforces is that `runes.json` decides a rune's MAGNITUDE, which a carry
   between two units does not. The sweep now separates a propagation (a right-hand side that reads the same field off
   another unit) from a decision, and **asserts the carries by name**, so a second one reds and the batch that writes
   it says why. The alternative was an exemption for one file, which `check_ds` already ruled against.

### GV's RULINGS OWED — **THREE LEFT; THE FIRST AND THE FOURTH ARE ANSWERED AT GW**

Full working: `docs/reports/GV.md`, NEEDS A RULING.

2. **THE GATE READS WHAT HE HAS EQUIPPED, AND THAT IS THE ONLY READING THAT GATES ANYTHING.** *(Its reason was the
   spec scope, which went at HC §1: a row reaches every hero of its class now, most of whom do not own its engine, so
   the equipped reading withholds far more than it did; the ruling asked for stands.)* A spec rune is offered by
   LINEAGE, the lineage is the engine taken at class selection, and nothing sells or discards an engine rune — so every
   hero who can be offered a row owns its engine all run, and an ownership gate would withhold nothing. **What the
   designer asked to be told**: a hero who unequips his engine is sold different runes at the Peddler (rolled as he
   stands, re-equipping before the visit restores them), a cache or bargain ROLLED while it was out never contains its
   rows at all, and an elite fought with it out drops a cache without them — the same reading the card draft already
   takes at a victory.

### GU's RULINGS OWED — **THREE, ALL PLAYER-VISIBLE**

Full working: `docs/reports/GU.md`, NEEDS A RULING.

1. ~~**WHAT "THE BASELINE" IS FOR A FORMER BASIC**~~ — **RULED IN GV's BRIEF: a former basic is priced against what it
   competes with NOW.** Fireball's and Frostbolt's price is Magic Missiles' already (GT); **Arcane Explosion's and
   Shadowrend's is RULED, NOT BUILT** — each still costs what the class basic it replaced costs, and what it competes
   with is the pool's card of its role (below). Recorded in `CLAUDE.md`'s EB block.
   **WHAT "THE BASELINE" WAS FOR A FORMER BASIC, AS GU LEFT IT.** Fireball and Frostbolt are at Magic
   Missiles' 15 Mana and cooldown 2 (GT, ruled); Arcane Explosion and Shadowrend are at the class basic's price, free
   with no cooldown (untouched — the brief grouped them and asked for no ruling). The two readings: the basic it
   replaced (all four free), or the nearest card of its role — for the two with no kit card of their role, the pool's
   **Arcane Barrage** (20 Mana, cooldown 2, 2.5; or Killing Frost, 20, cooldown 3, at AE's own 2.0) and **Chastise**
   (15, cooldown 2, 2.0). Nothing moved.
2. **GUARD CHANGE: NONE OF ITS THREE AXES MOVED.** Against Mocking Blow only its initiative is under, and that is the
   swap's point (AK priced it a bargain on purpose). At a strike's price it would be Crushing Blow's 20 / 2 / 3.0 or
   Pommel Strike's 20 / 3 / 2.0 — and a longer cooldown also slows Battle Poise's free pivot, which respects it.
3. **SWEEPING STRIKES IS THE ONE MAGNITUDE GU MOVED** — cooldown 0 → 2, Crushing Blow's — on the batch's judgment that
   it is a genuine mispricing (the brief delegated the grouping). The groupings of the other ten are the batch's
   reading, reported and ruled on by nobody, per the brief.

### FOUND AT GU AND NOT FIXED

- **`check_da` §3b CANNOT SEE A WALK BUILT ON THE MERGED POOL.** Its source families predate GP: `Classes.draft_pool(`
  is in none of them, so a function RETURNING the merged pool plus the boss pools — every card a hero can earn — counts
  one family and is not accused. **Proved with a probe planted in a control copy**: that walk returned from a function
  read `check_da` 43 / 0, and the same walk through the class-wide shelf's accessor was accused, 44 / 2. Widening the
  families moves that gate; not taken.
- **AGAINST THE ENABLERS RATHER THAN THE KIT**, the same shape finds **19 cards under an enabler (27 pairs)** — Arcane
  Explosion under the Pyromancer's Flamewave and Shadowrend under the Occultist's Hex of Ruin on all three axes, and
  most of the rest 5 Mana or Rage under, several of them against the Beastmaster's three summons. An enabler is only
  its engine's holder's, so none is in the population the brief named; `docs/reports/GU.md` §2 lists them.
### GT's RULINGS OWED — **TWO LEFT; THE THIRD RULED AND THE FOURTH ANSWERED AT GU**

Full working: `docs/reports/GT.md`, NEEDS A RULING.

1. **FIREBALL'S AND FROSTBOLT'S MOVES ARE LARGE, AND NOT FOR THE REASON THE BRIEF EXPECTED.** Free with no cooldown to
   15 Mana and cooldown 2 — both were basic attacks until GS, and a basic is free by construction, so the size measures
   the change of job the merge gave them, not a price that was wrong before it. Aimed Shot moved by 5 Mana and one
   turn. **Parity on both axes is what was built** (the baseline read off the kit card); the smallest move that ends
   EB's inversion is one axis — Fireball and Frostbolt free with cooldown 2, or 15 Mana with none — and is priced in
   the report.
2. **A CARD THAT SITS OUT KEEPS ITS SLOT.** Built as GM §2 left a dropped bound card's: it is still carried and still
   counted, and benching frees the slot. Freeing it automatically would let the player fill it, and the engine's
   return would then leave the kit over its cap — which is the ruling this would need.

### FOUND AT GS AND NOT FIXED

- **TWO CARDS' SECOND CLAUSES NOW NEED A DRAFTED CARD** — Battle Poise's free Guard Change and Shatterpoint's free
  Overpower. **GT drove both and reports them a separate case** (GT's ruling 3). The talent branches that also answer
  with Overpower or Pommel Strike read fields nothing writes since FX.
- **FOUR ENGINE RULE TEXTS NAME CARDS THAT NO LONGER TRAVEL WITH THEM**, and every rune surface shows those texts now:
  Seasoned Fighter's *"Guard Change swaps"*, Glacial Hold's Ice Lance, Shatter and Blizzard, Mercy's *"Stacks pay for
  Hymn of Hope"*, Conviction's *"doubled under Blessing of Zeal"*. No engine text moved (§4). **IJ §2 moved six core-rune
  texts**: Mercy's now names Hymn of Hope, Resurrection and Divine Plea; Seasoned Fighter's, Glacial Hold's and Conviction's
  clauses stand.
- **THE SIM BOT CANNOT CAST MOST OF THE 29 OUTSIDE THEIR OWN ROTATIONS.** `_bot_drafted_pick` casts a card only if
  `Classes.draft_ability` resolves it, and none of the 29 is defined there (their one definitions are the lineages' and
  `basic_override_ability`'s) — GM's Mana Shield finding, twenty-nine cards wide. The four drafted basics are never
  cast: the rotations that used them read slot 0, which is the class basic now (the Cryomancer's *"Frostbolt the
  mark"* casts Magic Bolt). Sims only.
- **THE FOUR DRAFTED BASICS RUN THE BAR NOW, AND ONE HAS NO PERFECT BEHIND IT.** In slot 0 they resolved at a fixed
  Good; drafted, they sit past it. Fireball's, Frostbolt's and Shadowrend's Perfect lines — unreachable since CN — are
  reachable, and **Arcane Explosion's bar has no Perfect** (a `CHECK_WITHOUT_PERFECT` name since DW, live now).
- **POMMEL STRIKE'S CARD RESTATES ITS PERFECT** — *"unless the strike is PERFECT"* beside a Perfect line saying the
  same — a second copy the standard does not want. Not authored at GS; the kit took the card as it stood.
- **THE RETIRED RUNE OF THE LAST RITES STILL SAYS *"She already knows Resurrection"***; since GS a Holy who has not
  drafted it is granted it. It is never offered.
### GR's RULINGS OWED — **ONE LEFT; THE SECOND IS CLOSED AT GY §1**

Full working: `docs/reports/GR.md`, NEEDS A RULING.

1. **`docs/combat-rules.md` HAS NO STATED CEILING**, like `docs/instrument-rules.md`. EE's method on its own record —
   the file as split, 29.73 KiB, plus ten of the largest single-batch growth its nine blocks have ever had (+4,340 B,
   the crit rule's birth at EW) — gives 72.11 KiB, stated **70 KiB**. It has grown +19.5 B a batch since FF, so the
   figure is the designer's to adopt or not, not a wall anyone is near.

### FOUND AT GR AND NOT FIXED

- **A POINTER INSIDE A MOVED RULE HAS POINTED AT THE WRONG PLACE SINCE EF.** *A status is applied with its `src`*
  says *"see the second standing rule below, which DJ earned from this"* — DJ §3's *a number quoted from one document
  into another stops being a measurement*, which EF moved to `docs/instrument-rules.md`. Moved byte for byte: a
  pointer correction is a rule edit, and GR edits none.
- **`docs/ways-of-working.md`'s HEADER STILL NAMES TWO RULE FILES** — *"`CLAUDE.md` and `docs/instrument-rules.md`
  bind what a batch DOES"*, and *"a third file and not a third seam"*. True of what it names and silent on the third.
  Not edited: the brief did not list the file, and `check_fr` reads it line by line.
- **`claude_md_census.py` CENSUSES `CLAUDE.md` ALONE**, so the nine moved blocks have left its population and its
  asserted / quoted / neither shares move by composition rather than by citation. A tool, not a gate; nothing in the
  battery runs it.
### GQ's RULINGS OWED — **TWO LEFT, BOTH PLAYER-VISIBLE; THE THIRD RULED AND TAKEN AT GR**

Full working: `docs/reports/GQ.md`, NEEDS A RULING.

1. **THE CLASS-SELECTION SCREEN'S NEW WORDS ARE PROPOSED.** On a card, *"Also opens with: …"* and *"(in place of
   Magic Bolt)"* — **the second went at GS §1, which left no engine replacing a basic, and the first now names an
   enabler alone**; under the cards, *"With no engine, the Warrior opens every fight with these. A rune adds what its card
   names."*; and on a Warrior's screen dealt the Rune of the Warden, *"Figures are for the Warrior with no engine: the
   Rune of the Warden sets Attack to 75, and they move with it."* **Since GS the same line names the Rune of the
   Occultist on a Cleric's screen** (Attack 100): an Occultist opens on Smite now, and Smite reads his Attack.
2. **THE CARD'S TEXT WINDOW IS FIXED AT 280 PIXELS**, so a deal of three short rules shows empty card space. Sized so no
   rune's text scrolls and the kit fits the screen, with the kit and the buttons in one place on every deal; cards fitted
   to the tallest text on the screen would move both from deal to deal, and were not taken.

### FOUND AT GQ AND NOT FIXED

- **PLAYER-FACING, MET ON THIS SCREEN FIRST: FOUR KIT TEXTS BREAK THE TEXT STANDARD.** Ministration's *"No stacks, no
  shields, no marks — it simply works"* and Magic Missiles' *"Cheap, certain, and it never needs anything to be true
  first"* are design rationale on a card; Magic Missiles restates *"12% of Attack each"* beside the line that prints it;
  **Nexus Ward's and Ministration's 20% are plain text, not tokens**, so no surface resolves either to a number. A kit
  card's text was outside GQ.
- **`Classes.ARCHETYPE_DESC` AND THE TWELVE `SPEC_INFO` BLURBS HAVE NO READER IN THE GAME.** Kept: a structure orphaned
  by a ruling is a design question (`CLAUDE.md`, DV §1). The archetype field itself is live — it sets a lineage's Attack.
- **THE HUNTER'S CLASS PASSIVE AND A HUNTER RUNE ARE BOTH *TRACKER*,** and on a deal holding the Rune of the Tracker the
  two stand one above the other on this screen. GO's ruling 2, re-observed.
### GP's RULINGS OWED — **THREE; THE FIRST TWO ARE PLAYER-VISIBLE**

Full working: `docs/reports/GP.md`, NEEDS A RULING.

1. **THE CLASS-WIDE CARDS ARE NOW THE WORST CARDS IN EACH POOL, AND THAT IS A REBALANCE OWED — THE RULE THAT MADE
   THEM SO IS RETIRED AT HD §1; THE REBALANCE IS STILL OWED.** EB §1 ruled the
   protected core is the baseline, and `CLASS_DRAFT_POOLS`' own authoring header says class-wide cards are written
   **weaker than spec cards** — deliberately, because they feed no passive and at equal power would be a safe default
   that diluted every build. **The merge removes the reason and keeps the cards:** six for the Warrior and the Hunter,
   five for the Mage, three for the Cleric. Accepted, not repaired, and the same item as GN's ruling 7 from the kit's
   side.
2. **THIRTY-FOUR CARDS BECOME UNREACHABLE TO A HERO WHO HOLDS NO ENGINE — THIRTY-SEVEN SINCE GS**, whose three
   (Death Ray, Hymn of Hope, Resurrection) had been opening-kit cards and entered the pool gated. Before the merge they
   were offered and did nothing; a Mage who drops Runaway Resonance now loses seven cards from his offers at once. That is the ruling
   working, and a player feels it.
3. **THE ENGINE GATE IS THE HOLDER'S AND THE CODE'S PRODUCERS ARE PARTY-LEVEL.** Five of the eight —
   `_living_hero_passive("permafrost")`, `_living_devout`, `_living_occultist`, the Mercy holder, the Focus holder.
   The party is one hero per class, so the two readings coincide today; **they part the day two heroes of one class can
   be seated**, and the gate would then be stricter than the code.

### FOUND AT GP AND NOT FIXED

- **PLAYER-FACING, AND FP's `block_chance` FINDING ARRIVING AS A CARD: COVERING GUARD LENDS A 0% BLOCK TO A WARRIOR WHO
  IS NOT A WARDEN.** `_live_block_chance` is `block_chance + _plating_slice`, only the Warden declares 0.10, and the
  slice is Heavy Plating's — so a spine-taker who drafts Covering Guard covers an ally with nothing, and a Warden who
  dropped Heavy Plating covers with 10%. **It is NOT in the engine table**, because it reads a STAT and not an engine;
  gating on it would be a second mechanism, and `PROTECTED_CORES`' own header already records that *the enabler concept
  has to cover STATS, not only abilities*. **The merge makes it reachable by three times as many heroes.**
- **BATTLE POISE AND COUNTER TIME NEED THE DEFENSIVE GUARD, AND NO WARRIOR ENGINE GIVES HIM ONE.** Four cards in the
  same merged pool reach it — Formless satisfies both gates outright; Precision Strike, Feint and Wheeling Cut flip the
  stance — so they are conditional on a CARD and are not gated. **A Warrior who drafts Battle Poise and nothing that
  switches guard can never cast it.**
### GO's RULINGS OWED — **TWELVE; ALL BUT THE LAST TWO ARE PLAYER-VISIBLE**

Full working: `docs/reports/GO.md`, NEEDS A RULING.

1. **FOUR PROPOSED MAGNITUDES** — the Reaver's +10% a kill (uncapped, as ruled), the Leech's 25% returned and 1 Mana
   a point, the Arbiter's 5% of the damage, and the Skirmisher's +200% (*enormous*, read as triple). The ruled
   numbers are in: every third cast, half strength, 25%, 5% and halved.
2. **THE NAMES, SWEPT OVER 1,432.** **Rune of the Tracker is the Hunter's class passive's exact name**, so a Hunter
   holding it wears two chips labelled *Tracker*. *Leech* is a retired Occultist rune's lane, which no screen shows.
   Near-misses: the retired Rune of the Reaper (Reaver, Weaver), the retired Rune of the Binding Oath (Oathkeeper,
   Oathbound), the live Long Leash (Leech), the Survivalist's own engine id `trapper` (Tracker), the glossary's
   Bound (Oathbound), and several mechanical ones. Bastion, Skirmisher and Judged met nothing.
3. **THE NINE RULE TEXTS AND THE THREE CHIPS** (*Tracked*, *Judged*, *Oathbound*) are the batch's words.
5. **THE WEAVER REPEATS DAMAGE, NOT THE CARD** — half of what each enemy took, no status, heal, summon, Break damage
   or second consumption. His basic attack counts as a cast; a counter does not.
6. **THE LEECH** pays after a barrier and before Conversion, falls through to health at zero Mana, and books nothing
   as Mana spent.
7. **THE OATHKEEPER'S BOND** is chosen by the game — the other hero with the lowest maximum health — and never by the
   player; it is HERO by choice; it passes on the bound hero's death, ends on the Cleric's, and binds again when a
   revived Cleric takes a turn. Self-inflicted damage and Break damage are not shared; ticks are. A heal into a full
   bar is spent there.
8. **THE ARBITER** judges the first enemy the Cleric damages, heals every ally (companions included) and not on the
   judging blow, and **moves to the healthiest enemy when the judged one falls — not in the brief**.
9. **THE TRACKER** marks the first enemy the Hunter damages; the mark pays in the strike loop and on a companion's
   blow, not on ticks or self-computed damage (Exposed's coverage), and moves to the healthiest enemy.
10. **THE SKIRMISHER** is spent by the first damaging cast through the strike loop (a counter and a miss keep it) and
    re-arms after two turn-starts no blow reached him; a block or a parry is a blow that reached him.
11. **THE ENGINE NAMES OF THE FIFTEEN STILL REACH THE PLAYER.** Their rule texts open with them (*Momentum:*, *Blood
    Frenzy:*…). The ruling was built for the nine; whether it reaches the fifteen is a question of its scope.
12. **THE BOT'S BASTION CASE** (`_bot_redoubt_pick`: spend a bank at least one basic's worth) is an implementation
    call that moves simulated figures only.

### GN's RULINGS OWED — **EIGHT; THE FIRST FIVE ARE PLAYER-VISIBLE**

Full working: `docs/reports/GN.md`, NEEDS A RULING.

1. **MAGIC BURST'S UNRULED NUMBERS.** The ruling gave 40% of Attack in arcane and Elemental Weakness. Proposed, and
   live until ruled: **25 Mana, cooldown 2, initiative 3.0, 15 Break damage, a 46% Perfect (the generic x1.15), tagged
   DEBUFF and BREAK**, and its card text.
2. **ELEMENTAL WEAKNESS IS A RESISTANCE CUT, NOT A MULTIPLIER.** The ruling said *+15% damage taken*; the retired
   status cut resistance, and that mechanism was taken at the ruled 15 points. **They agree where an enemy resists
   nothing** (x1.148–x1.150 measured, rounding) **and part where it does**: x1.212 at +30% resistance, x1.124 at
   −20%. Which is meant is the designer's.
3. **ITS COVERAGE IS THE STRIKE LOOP'S ALONE**, as Exposed's is. Seventeen other non-physical reads do not see it —
   the poison and burn ticks, Arcane Arrows' splash, Arcane Echo's repeat, the Ruin detonation, Cinderfall, Winter's
   Toll, Killing Frost, Pyre Wake, Requiem, Cull, Harvest, Wildfire, Reprisal, Suffering, a sprung trap and a shadow
   payout in the damage door — and Unmaking's zeroed resistance ignores it.
4. **THE FOUR REWORDINGS** — Nexus Ward *"20% of the Mage's maximum health"*, Tripwire *"another ally"*, Consecration
   *"the ground underfoot"*, Powershot *"allies break them"* — are the batch's words, for confirmation.
5. **NEXUS WARD CONTAINS THE `Ward` STATUS LABEL.** The BR §1 sweep over 1,309 names: Nexus Ward — 0 exact, 2
   contained (the `ward` status id and its `Ward` label), 3 sharing a word (the Ironbark Ward relic and the retired
   Triage Ward rune, id and name). Magic Burst — 0 exact, 0 contained, 2 sharing a word (Magic Bolt, Magic Missiles).
   A label collision ships and is flagged; renaming is one string.
6. **THE CLERIC'S CLASS POOL IS THREE** — Chastise, Exhortation and Undying Vigil are the whole draft of a Cleric who
   took Sanctity, and an Occultist can no longer stack five cards on any tag but DEBUFF (`check_fn` §4 reads two).
7. **A KIT OF CLASS-WIDE CARDS HANDS THE BASELINE ROLE TO CARDS AUTHORED WEAKER** (GL's item 3): the Mage's two and
   all three of the Cleric's were authored as draft fallbacks.

### FOUND AT GN AND NOT FIXED

- **PLAYER-FACING: THE VICTORY CARD LEAVES OUT THE TOLLKEEPER'S BELL.** Both victory cards print
  `Run.award_gold`'s figure, and the Bell's +20 is paid beside it (`battle.gd`, the `victory_gold` hook), so the card
  says 20 less than the purse gained. **`check_gj` §4 is red because of it**: GN's code moved what the gate's seeded
  run draws, and that run now holds the Bell (card +178, purse +198). **HEAD's code with the Bell forced reds the same
  arm** (card +157, purse +177). One expression in `battle.gd`; not in the brief. The red is sanctioned in
  `baselines.json` until it is fixed.
- **TRIPWIRE ANSWERS A BLOW ON A COMPANION.** The brief said *a hero*; the block reads any hero-side body, and every
  Hunter held Tripwire from GN to HB (a drafted card since, off the Survivalist's shelf) — measured, a melee blow on
  his bear is answered for 75%. The card's *ally* is
  the code's.
- **MANA SHIELD IS STILL NEVER CAST BY THE BOT** (GM's item below); the class branch covers the kit cards only.
### GM's RULINGS OWED — **SEVEN, ALL PLAYER-VISIBLE**

Full working: `docs/reports/GM.md`, NEEDS A RULING.

1. **WHAT ELSE LEAVES WITH AN ENGINE.** Built: the three opening-kit cards the usability door refuses without it.
   **Not built, and each is its own question:**
   - **the lineage cards that half-work without their engine** — eight opening-kit cores by GL's test (Wildfire,
     Arcane Cannon, Renewal, Blessing of Zeal, Hunter's Instinct, Aimed Shot, Hold Breath, Shrapnel Charge). GL's
     five whose payload sits in the engine's block are a different cut, and four of those five are EARNED zone-boss
     cards. **MOOT FOR THE EIGHT SINCE GS §1: none opens a kit now.** All eight are drafted off their lineages'
     shelves, offered to any hero of the class (GP's HALF-WORKS group is not gated), and earned, so they stay;
4. **THE SPLIT SHIELD ASKS FOR A HERO, AND ITS HALF IS CALLED "BULWARK LINE".** With the rune Shieldwall names another
   living hero; the rune says *ally*, and a companion never rolls Block. The half is EZ's `bulwark_line` status, whose
   chip and block log read *Bulwark Line*, a node deleted at FX; the chip's own line reads *"Split Shield: …"*.
5. **DISPEL WAS REPAIRED ON THE CARD TEXT'S AUTHORITY.** It strips beneficial effects from an enemy, and the heroes'
   marks and Rime are not that. Read as a cost instead, it is three ids in `DISPEL_NEVER`. **Rime is tagged an
   affliction and sits outside `DEBUFF_IDS`**; listing it there would let a mender's rite take it and a Survivalist
   count it.
6. **A LETHAL AIM HOLDER'S AREA CASTS, CALLED VOLLEY AND DRUMFIRE SPEND THE BREATH NOW.** They were paid the promised
   shot on every target and kept it. The repair closes it as the same defect; a Sharpshooter player can feel it.
7. **THE BARE-NUMBER LABEL SURVIVES, ON DIVINE PLEA.** An engine-less Holy who drafted it sees *"Divine Plea   2"*;
   Resurrection's bare "1" left with the card. The brief kept it out of GM. **It came back at GS on Resurrection and
   Hymn of Hope**, for a Holy who drafts either and then drops Mercy (FOUND AT GS, above).

### FOUND AT GM AND NOT FIXED

- **A COUNTER SWING UNDER A HELD BREATH IGNORES ARMOR AND SPENDS NOTHING.** The critical read and the spend both skip
  counters; the armor-bypass read does not. Bounded — the next real attack spends it — and it was true of every Lethal
  Aim holder before GM.
- **HOLD BREATH'S "+40 Focus" IS INERT WITHOUT LETHAL AIM**, and its text says *"your"*. One card more for GL's
  card-text queue below.
- **NOTHING LISTS WHICH STATUSES THE HEROES LAY ON AN ENEMY.** GM's census of them was static and read by hand, and
  `check_gm` §4 drives the three it found; a fourth authored in neither list would pass until it was played into.
- **THE SIM BOT'S DRAFT WRAPPER CANNOT SEE MANA SHIELD.** It casts a card only if `Classes.draft_ability` resolves it,
  and Mana Shield — a vault card re-homed into the Mage's class pool at DY — does not.

### FOUND AT GL AND NOT FIXED — **FOUR CLOSED AT GM: HOLD BREATH, THE DEAD BUTTONS, SPLIT SHIELD AND DISPEL; THE BOT'S KIT CARDS AT GN**

- **PLAYER-FACING: LINEAGE CARDS THAT HALF-WORK WHEN THE ENGINE IS DROPPED — STILL OPEN; GM's RULING 1, EXCEPT FOR VENOM
  COATING, WHICH HF §7 ANSWERED AT THE OFFER** (a RULED card-gate row on Trapper; its payload stays in the block, and a
  copy carried without Trapper stays seated — FOUND AT HF). Only
  Shrapnel Charge was in an opening kit, and since GS §1 none is — it is drafted off the Survivalist's shelf; Hamstring, Venom Coating, Pinning Shot and Called Shot are EARNED zone-boss
  cards. Their payload sits inside the engine's block: Shrapnel Charge's Poison, Hamstring's Slow and Exposed and Venom Coating's poison inside Trapper's
  (`battle.gd:12059-12079`); Pinning Shot's Daze and Called Shot's rider inside Lethal Aim's (12214-12227).
- **DIVINE SHIELD'S RECAST PROPOSAL IGNORES THE BARE ALTAR RUNE**, which halves the cast (`battle.gd:17157-17158`); the
  table proposes the full 35% (6064), so a wasted recast reads as an improvement. CR §3's rule, one live rune along.
- **PLAYER-FACING: QUICK SHOT ADVERTISES A PERFECT ONLY A LETHAL AIM HOLDER CAN REACH** — slot 0 resolves at a fixed Good
  (`battle.gd`), so a Beastmaster's or a Mystic's Quick Shot never pays its *+10 bonus Mana*; the Sharpshooter's bar is real, and
  the card is one object the three share. **IJ §2 cleared the other three class basics' Perfect lines** (Strike, Magic Bolt,
  Smite), which no hero could reach. `test_batch_bo` §5 passes them, because it asks `runs_skill_check()` and the cast path asks
  slot 0.
- **PLAYER-FACING: CARD TEXTS THE CODE CONTRADICTS**, each in its class section of the recon: Charge's one-turn Daze
  never acts (it ticks off at the target's turn start, `battle.gd:3295`, before any miss roll) and its Perfect has no
  code; Cleave's Perfect has no code; Battle Trance and Mana Well pay three turns in four (their ticks run after
  `tick_statuses`); Chastise's Perfect says 30 Break damage and pays 25; Frostbolt's, Razor Ice's and Blizzard's
  "hold" is the engine's; Divine Shield names "the Devout's" health and Dark Pact "the Occultist"; Hymn of Hope, Dark
  Pact and Resurrection say *ally* and reach heroes only; Renewal and Undying Vigil on a companion do nothing; Kill
  Command's "both companions" names a mode nothing writes (`the_pack`); Arcane Explosion's "Builds 1 Resonance". **IJ §2
  repaired Cleave's and Chastise's Perfects, Frostbolt's hold, Dark Pact's *the Occultist* and the *ally* of Hymn of Hope, Dark Pact,
  Resurrection, Renewal and Undying Vigil. IJ's census read the rest as agreeing** — each an engine's own rule (HO §0), or, for
  Kill Command, *The Pack* talent's name — a reading that differs from GL's, owed a look.
- **A PARTY DAMAGE BUFF PAYS ON ORDINARY STRIKES ONLY.** Warcry, Exhortation, Blessing of Zeal and Hunter's Mark are
  read in the strike path (`battle.gd:9689, 8423-8425, 9240, 9892`); a card resolving in its own `special` handler
  reads none of them. True of all four; recorded once.
- **ONE SYNC LINE, AS AT FW:** `CLAUDE.md`'s must-stay-selected list does not name `docs/kit-recon.html` (nor
  `systems-recon.html`). GL added no `CLAUDE.md` line (the brief forbade rules); **selecting it in the picker is the
  designer's**.

### GK's RULINGS OWED — **NINE; THE NAMES, THE WORDS AND THE THIN KIT ARE PLAYER-VISIBLE**

Full working: `docs/reports/GK.md`, NEEDS A RULING.

1. **The three spine runes' names** — the Rune of the Vanguard, the Invoker, the Hierophant.
2. **The three spines' rule texts** (`Classes.SPINE_INFO`), which no player read before GK.
3. **The class-selection words** — *"Take one of three engine runes — a second can join it later, and either can be
   dropped"*. Since IJ §2: *"Take one of three core runes — 2 more can join it later, and any can be dropped"* (the count read
   off `Run.ENGINE_SLOTS`).
4. **An engine rune's cost** — the flat rune price until one is set: 150 gold since HK §3, 100 until then.
5. **The lineage interim** — a hero who drops his lineage's engine keeps its name, stats and pools. **GL found what
   else he keeps**: Death Ray, Resurrection and Kill Command, which can then never be cast, a Hold Breath that never
   runs out, and five lineage cards that half-work (GL's findings above). **GM closed the first two** — the three
   leave with the engine (ruled) and the breath is spent — **and the rest is GM's ruling 1.** **Since GS §1 the
   interim holds its name, stats and boss pool and no card at all**: a lineage opens with its enablers alone, and they
   leave with the engine.
6. **Heavy Plating's base is a stat** — the Warden's 0.10 Block stays with the lineage, so another Warrior's plating
   climbs from zero plus its own slice.
9. **No engine rune carries a tag** — `check_ek` exempts all twenty-four as a set.

### FOUND AT GK AND NOT FIXED

- **`save-backups/` is untracked and not ignored.** Every batch's player-save backup since FR sits there; each batch
  staged by path, so none was ever committed, and a `git add -A` would commit them all. One `.gitignore` line.
- **Two comments in `battle.gd`** (DT's companion census) still name a companion's `passive_id`; it is `engines` that is
  empty now, and the arithmetic they describe is unchanged.
- **Five four-hero parties in the instruments seat a lineage on another class's seat** — all artificial; none reaches a class-keyed draw (a static sweep at GK), and the one that did is repaired.
### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT — **RE-MEASURED AT GJ, BOTH WAYS**

- **Until GJ the sim ended every run at the third zone boss**, so a "completion" was a run that killed the third zone
  boss — encounter 48 of 49, never the end boss. **That is what EN's 97 / 3 / 0, EO's and EP's arms and every
  completion quoted since measured.** They stay readable as that: they are not wrong, they are a different count.
- **RE-MEASURED AT GJ, UNTALENTED, 150 RUNS A RUNG, BOTH COUNTS OFF THE SAME RUNS: THE DELTA IS ZERO.** The end boss
  stopped none of the runs that reached it at rungs 1 and 2, and no run reached it at rung 3, so counting the final fight
  moves no rung's completion by a run. The table, HEAD's control and the rung-1 split are `docs/reports/GJ.md` §1b–§1e.
- **NOT RE-MEASURED, BY THE BRIEF'S SCOPE:** EP's rows-3 and rows-9 arms, EV's, FV's and every other arm. Each stays a
  third-zone-boss figure until a batch re-reads it.

### GJ's RULINGS OWED — **THREE, ALL PLAYER-VISIBLE**

1. **WHICH READING OF "THE END BOSS IS NOT SCALED BY THE DIFFICULTY MULTIPLIER".** Built: the rung may not DISCOUNT
   it (`maxf(mult, 1.0)`), which keeps rungs 2 and 3 bit-identical as the brief required. The other reading — the
   rung term taken off outright, rung 2's values at every rung — would take rung 3's x1.30 off the end boss (1,910
   health against 2,490, Attack 334 against 434). It is one line either way (`Run.end_boss_mult`).
2. **THE RUNG-1 WORDS ARE PROPOSED.** The draft screen's Wanderer tooltip reads *"Enemies at 50% strength, the end
   boss at full."* where it read *"Enemies at 50% strength."*, and the glossary's road entry *"its enemies hit half
   as hard - all but the END BOSS - "*. Each was a claim §3 made false. **IJ §2 moved the tooltip to *Enemies strike at 50%
   strength*** — the rung discounts the attack path, never health (`Run.zone_base_mult` against `maxf(mult, 1.0)`).
3. **THE END BOSS'S TOOLTIP AND ITS READOUT NAME (GI) ARE STILL OWED A CONFIRMATION.** GJ's brief confirmed the END
   BOSS label; it said nothing of the tooltip or of the readout's *"— the Hollow Crown waits"*.

### FOUND AT GJ AND NOT FIXED

- **THE DESIGNER'S, AND PLAYER-VISIBLE: THE END BOSS'S FIGHT IS TOO SHORT TO TEST A PARTY, AND §3 DID NOT CHANGE THAT.**
  Driven to the end boss at rung 1 and set to 1 health a hero before the step, the party won 7 of 7 on GJ's code and
  7 of 7 on HEAD's; at full health 7 of 7; with the Devout already down as well, 3 of 4. In every fight the Crown
  opens with Regalia — a ward, no damage — and casts one to four abilities in all before it dies, Broken once or
  twice and, Broken, open to a freeze that takes its turn. The multiplier §3 lifted doubles each blow it lands
  (Crown of Thorns 49 → 98 on the same hero, same seed) and it lands few. What would make the last fight able to
  kill a party on the floor — its opening, its health, whether a Broken end boss can be held — is content, and the
  end boss is a placeholder by the designer's decision (`docs/master.html` §13). Tables: `docs/reports/GJ.md` §3.
- **THE SCREEN PRIMITIVES ARE IN THREE DRIVERS AND AUTHORED ONCE FOR ONE.** `gate_fixture.gd` holds them since GJ
  and `check_gj` reads them there; `check_fh` and `check_gf` still carry their own copies, which is DA §3's tell.
  Moving the two onto the fixture is a consolidation owed to a test batch.
- **THE SIM'S OTHER FIGURES MOVED WITH IT AND WERE NOT RE-READ.** A run now pays three zone-boss ability awards (the
  report's ceiling reads 3.00, not 2.00), its slot ladder reaches 10, the end boss's fight joins the `boss` rounds
  bucket, and a full clear is depth 49 in the report and the Matrix row.
### ~~THE END BOSS HAS NO BUTTON~~ — **CLOSED AT GI ON `class-merge` ONLY; ITS LABEL CONFIRMED AND ITS INSTRUMENT GAP CLOSED AT GJ; TWO WORDINGS STILL OWED**

- **THE LABEL *END BOSS* IS CONFIRMED** — GJ's brief calls it confirmed. **Its tooltip** (*"The END BOSS. Nothing goes
  around it."* over *"It is always the Hollow Crown, and the road ends here."*) **and the readout's *"— the Hollow
  Crown waits"* are still owed a confirmation** (GJ's rulings item above).
### FOUND AT GF AND NOT FIXED

- **A PEDDLER OR A FORGE QUIT IN THE MIDDLE OF A VISIT IS STILL WALKED PAST.** Both roll their stock in their own
  `_ready`, so re-entering one on resume would make a quit a reroll of the shop, and freezing the stock is a change to
  two screens, which GF's brief ruled out. Driven at GF: the node is visited and saved at the step, and Continue opens
  the map past it.
- **`docs/master.html`'s debug paragraph** still says *"a summoned rest really heals"* (the Rest summon went with the
  rest nodes) and names *"Jump to Boss Tier"* (the item is *Jump to Boss Slot*). Outside GF's surfaces.
- **A MINI-BOSS CAN AWARD AN UPGRADE THE FORGE ALREADY PUT ON THE SAME ABILITY.** `roll_upgrade_offer` drops an
  upgrade only through `has_upgrade`, which ignores a bought entry on purpose (the forge is not the mini-boss's pool),
  and then pairs it with any ability it fits, the forged one included; `upgrade_choice` re-asks the same question. The
  forge's own roll refuses a pairing the hero already carries, so the rule its comment states (*never twice on one
  ability*) holds from one side only, and six of the eight upgrades stack when stamped twice (FE §2: Honed 25 → 38
  → 57). Read in the code at GF, not driven.
- **COPIES OF TWO CLAIMS THE GLOSSARY CORRECTED ARE LEFT IN A RULE AND IN COMMENTS.** `CLAUDE.md`'s governor table
  still calls Resonance uncapped with two removers and Ruin never-clearing; `battle.gd`'s comment above the Arcanist's
  `second_max = 99` says Resonance has no ceiling at all, and the header of Runaway Resonance's first clause says
  nothing removes it. Arcane Arrows' handler comment says five is what the card promises, beside an
  `ARCANE_ARROW_CHARGES` of 5 that nothing reads; the card and the handler pay six, and so does the glossary now. None
  of these is player-facing. IJ §2's player-facing words name the three removers (Arcane Bolt, Stabilize, Threshold).
- **WHAT THE GLOSSARY CENSUS LEFT AS IT IS.** Nine claims no code can settle (intent, such as the class-wide cards
  being weaker on purpose) stand as written — that one *as written* since IJ §2. **Decay and Elemental Weakness were RETIRED at GG**, by the designer's
  ruling (`docs/reports/GG.md` §3). **Melted Armor and Caught Fast are the same case and are OWED A RULING**:
  nothing applies either (`melt_ranks` and `caught_fast` have no writer), their entries annotate themselves, and
  the ruling named two. Card and chip text still uses group
  words the hero/ally rule retires (*"the line"*, *"everyone"*); the glossary no longer says otherwise, and the cards
  are authored text. No spec plays the Rush archetype, which `Classes.ARCHETYPE_DESC` and `docs/master.html` §6's
  table still define.

### FOUND AT GG AND NOT FIXED — **NONE IS PLAYER-FACING**

- **Nothing asserts the glossary's retirement.** `check_et` §1 asserts every retired rune carries its string; no gate
  reads a glossary entry's `retired` key or drives the panel's two doors. GG was IMPLEMENT ONLY and proved it with a
  scratch probe (28 checks, a control arm among them — `docs/reports/GG.md`, VERIFICATION). A gate is owed to a test
  batch.
- **`classes.gd`'s SYNERGY comment above Penance still says *"DECAY and ENTROPY grind the same enemy's clock"***, and
  both are dormant (`entropy_ranks` has no writer either). `docs/master.html`'s copy of it is corrected; the comment is
  not player-facing.
### FOUND AT GH AND NOT FIXED

- **A hero who fell plays the death animation as the restarted fight opens.** `_die()` is the one way down and it plays
  it; nothing else of a death fires.
### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S — **OWED A RULING**

**FX BUILT THE LAYER AND LEFT EIGHT THINGS FOR THE DESIGNER** (`docs/reports/FX.md`, under NEEDS A RULING). Three
are ruled since, two at FY and one at GB, and five are open:

1. **`TIER_SPEND_MIN` is a candidate at 3**, and the brief made it the designer's. FX §1 prices 1 and 9.
2. **Five magnitudes are PROPOSED**, each against a stated reference (FX §3): More Attack +10, More Armor +5%,
   A Bigger Resource Pool +20, More Damage Dealt +10% and Less Damage Taken 10%.
3. **Four of the brief's nodes are swapped for alternates**, because none is TODAY for a tree four classes buy:
   regenerate more resource, debuffs expire sooner, a Perfect pays, and Elusive while afflicted. Each would need
   a hook (FX §2). **FY §1 re-read the four:** two are the currency shape FW had flagged, and two were never TODAY
   in FW's own costing.
   - *Debuffs expire sooner* is FW's SMALL item.
   - *Elusive while afflicted* is FW's TODAY item with its trigger reversed. That TODAY item pays the Survivalist
     alone, measured.
4. **Two names deviate from the brief's labels**, each for a stated reason: Cleanse Debuffs Each Turn, and
   Breaking Heals a Hero.
5. **The playtest save cannot feel the spend gate.** Its folded purses (65–68) exceed the tree's 54.

**FW's list below is kept as the record. FX ruled two of its nine (the DO charter and the trees' size).** The
other seven bind the NEXT node authored rather than this tree, because no node of the 27 reaches a relic hook, a
spine, a class passive, the basic attack or a spec status.

**Full evidence: `docs/systems-recon.html`** — every system in its own `SR-` section; §3 (`SR-LINE`) holds the
edges and §4 (`SR-COUNT`) the count. The brief said the designer rules on the edges; FW ruled on none. **These are
the things a later batch must not re-derive:**

2. **EN §4's RELIC SEAM.** *"If it sets the run up — the purse, the pouch, the shop, the spawn line, what a victory
   pays, what an elite drops — it is a RELIC."* The brief lists those systems as fair game; **15 of the recon's 32
   ruling-gated things wait on this seam alone**, and the rule has no tiebreak for a per-hero run effect, which
   passes both of its tests.
3. **THE CLASS SPINES — TWO READINGS OF "TOUCH".** Momentum, Channel, Sanctity and Focus are engines by the letter,
   and as class spines all four are **RULED, NOT BUILT**: the three are machinery on nobody (FT), and Focus is the
   Sharpshooter's meter, built off his own attacks and cards rather than off universal traffic. The other three read
   universal traffic (Mana spent, exchanges, every status event). **GK: the three are engine runes now, held by
   whoever takes one — no class carries a spine.** "May not touch an engine" means
   either "may not read or write one" or "may not change what one reads" — **and the second excludes most of the
   recon for three classes.**
4. **THE FOUR CLASS PASSIVES** — Threatening Presence, Holy Conduit, Tracker, Evocation — are passives by the
   letter, and two of them assign over the fields a stat node would naturally write.
5. **THE BASIC ATTACK HAS THREE DEFINITIONS IN THE CODE** — `abilities[0]`; `cost == 0`; `damage > 0 and cost == 0
   and not is_counter`. A ruling that a node may touch "the basic attack" also has to say which.
6. **SPEC STATUSES AFTER THE MERGE** are legal by the line and bets by the DO/DP charter unless every spec of a
   class can apply them. Reading statuses **by count** (`DEBUFF_IDS`) is the shape that touches no owner.
8. **ENEMY INTERFERENCE WITH THE SKILL CHECK** — priced in `SR-INTERFERE`: two flavours are profile keys, all four
   need one hero-to-bar hook, and no instrument could measure any of them because the bot never reads a profile.
   Built, it would be a third, non-opt-in exception to the standing profile rule.
9. **AND ONE SYNC LINE:** `CLAUDE.md`'s must-stay-selected list names `spec-recon.html` and `merge-recon.html` but
   not `systems-recon.html`, which is what the talent authoring reads. FW added no `CLAUDE.md` line (the brief
   forbade rules); **selecting it in the picker is the designer's**.

### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS — **RULED AT GA; THE REPLACEMENT TAKEN AT GB, ITS NAME CONFIRMED AT GC**

**The designer ruled three of the four at GA and confirmed the floor under the fourth** (`docs/reports/GA.md` §1 and
§2); GB's replacement took the cell (`docs/reports/GB.md` §1) and its name was confirmed at GC (`docs/reports/GC.md`
§4). One wording is still owed:

4. **Deepening Hex's card** reads *"every 8th instead of every 10th, and never sooner than every 8th"*. Its
   *"whatever the threshold is"* holds at the one live step only. **The floor stays at 8 (confirmed at GA). The
   wording is still the designer's, and GA did not touch it.**

### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED — **FOUND AT FY §5b; DEFERRED BY RULING AT GA UNTIL THE GAME CAN BE TEST-PLAYED**

**RULED AT GA: DEFERRED, TO BE REVISITED ONCE THE GAME RUNS AND CAN BE TEST-PLAYED. THE MEASUREMENT TRAVELS WITH
THE DEFERRAL.**
- **Four gates reach `Relics.unlock_random()` 14 times in one battery**: `check_ea` 2, `check_eg` 4, `check_eh` 3 and
  `check_fh` 5 (FY §5b's pre-pass). `check_fh`'s share moves with how far its autoplay run gets.
- **It is harmless only because every relic is unlocked.** GA checked that again: all 25 of the pool's 25 are in the
  player's file.
- **The first locked relic makes it permanent.** Each reach then unlocks one relic at random in the player's file,
  until none is left locked, so up to 14 a battery.

**The same shape FX found in the profile, one file over.** `battle._resolve_boss` opens with
`Relics.unlock_random()`, and that function calls `Relics.save_data()`, which writes `Relics.SAVE_PATH`, the constant
`user://relics.json`. **There is no redirect**: the path is a `const`, unlike `Run.save_path` (FI) and
`Profile.save_path`. `check_ea`, `check_eg` and `check_eh` call `_resolve_boss` directly, and `check_fh` reaches it
through the boss kills of its live run. **FY's pre-pass counted 14 reaches in one battery** (2, 4, 3 and 5), and
`check_fh`'s share moves with how far its autoplay run gets. **The designer's file has all 25 relics unlocked**, so
`unlock_random()` returns before it saves. That is why the census saw no relic write,
and why the file has not been written since 2026-08-30.
- **The day any relic is locked** — a fresh profile, a relic added to the pool by the merge, a reset — every battery
  would permanently unlock relics at random in the player's file, one for each reach while any is still locked.
- `docs/reports/FY.md` §5b carries the census and the pre-pass reading of which targets reach the call.
- **Nothing is broken today. GJ ADDED THE VAR AND NOT THE RULE:** `Relics.save_path` (default `SAVE_PATH`) exists
  since GJ, and `check_gj` points it at a scratch file of its own before its end boss dies, so the gate that presses
  the end boss is not a fifth reacher. **The four gates FY §5b counted still write the default** — the deferral stands,
  and closing it is now one redirect line in each of the four, or FI's harness rule given to the var.

### FOUND AT FY AND NOT FIXED — **INSTRUMENT HYGIENE FROM THE §5c AUDIT; NONE CHANGES A VERDICT TODAY**

- **About 108 checks pass by default:** 81 *"single rank"* checks (`test_batch_ar`, `as`, `at`) read
  `n.get("ranks", 1)` off a tree with no `ranks` key, and 27 `exclusive_with` checks (`at`) read a field that is
  always empty.
- **`check_dk`'s four surviving *"no text still says ally"* needles cannot fail** (they look for deleted nodes'
  texts or a `{v}` the tree never uses) and still count toward its 60.
- **`test_batch_ay`'s `_worn_tree` silently skips an unknown id**, against FX's *"fails loudly"*.
- **`test_batch_ba`'s FX header says 52 deleted (690 → 638)**; the truth is 55 (690 → 635).
- **About 80 design numbers on dormant fields are asserted nowhere in their suites.** Pressure Cooker's `+25` Break
  was never measured at either commit.
- **`check_fx` §4 lands the payloads on one spec per class and drives most read sites on one hero** (Deflection's,
  since GB, on all four). FY's probe landed all 27 on all twelve specs. A twelve-spec arm would close the gap for
  the next node.

### FOUND AT GA AND NOT FIXED — **THREE OF THE FOUR CLOSED AT GB §4; NONE IS PLAYER-FACING**

- **Two claims in `docs/instrument-rules.md` are dated readings that GA did not re-derive, and it says so rather than
  passing them:** DX §1's *"THIRTY-FIVE ASSERT A FLOOR NOW"* and EU's *"ALL FIVE ARE CORRECT TODAY"*. GB's brief
  did not include that file either.
### FOUND AT GE AND NOT FIXED — **LONG DRAW IS STILL A GAIN ON THE PLAYER'S MODEL (OWED A RULING), AND ITS NEW WORDS AWAIT CONFIRMATION**

- **OWED A RULING: THE DRAIN MADE LONG DRAW'S GAIN SMALLER, NOT A TRADE, ON `check_cs`'s OWN MODEL.** With the rune
  held, a missed press drains 16 Focus (GE §1). Priced in Focus a basic, the rune against the bare chain, on the model
  `check_cs` §7 prints every battery:

  On that model the drain leaves the rune a gain at every stage (+6.5 to +8.0 Focus a basic); on the sim bot's flat 85%
  roll it is a loss at every stage, and at a timing SD of 100 ms rather than 60 a trade at 150+ only. `docs/reports/GE.md`
  §1 carries the tables.
  Which model the rune should answer to is the designer's. Rune content is written with the designer, so no number
  moved beyond the ruled 16 and no alternative is offered here.
- **LONG DRAW'S NEW WORDS ARE PROPOSED, NOT CONFIRMED:** *"His basic attack runs one EXTRA press at every stage — but a
  missed press drains 16 Focus."* `check_ez` §5 reads the number off `SS_SEQ_MISS_DRAIN`, so a confirmed rewording that
  keeps *"drains 16 Focus"* needs no gate edit, and one that drops the phrase moves that arm.
- **`relics.gd`'s header still says every hook is read at exactly one site and names rest nodes** — FW's item below,
  unchanged; `docs/master.html`'s copy of the same claims was corrected at GE §2.
- **THE §2 SWEEP'S RESIDUE, ALL OF IT ALREADY QUEUED UNDER GC:** `docs/master.html` still says *"the talent trees"* in
  two places (the rune-condition door and EM's charter line), still prices talent points the pre-BM way in §2, and
  still carries DO's move of twenty-two cards as history; `CLAUDE.md`'s name-sweep block still cites deleted Warden
  nodes. None of them says a talent is tied to a spec; each is the census's other direction.

### FOUND AT GC AND NOT FIXED — **THE CARD AND THE SEVENTH RULE CLOSED AT GE; THE CENSUS'S OTHER DIRECTION IS STILL QUEUED**

**GC's §3 census read 881 claims resting on a merge ruling** — in `CLAUDE.md`, this file, `docs/instrument-rules.md`,
`docs/ways-of-working.md`, `docs/master.html` and the game's own source — and found ten stating an unbuilt ruling as
built. **It found 138 pointing the other way**: text still describing what the merge has already moved. Eleven of those
closed at GC (seven with §1's retirements, four in this file). The rest are below by kind, counted by file as the
census found them, and the tables are in `docs/reports/GC.md` §3.

- **DELETED THINGS NAMED AS LIVE — THE CENSUS'S OTHER DIRECTION, AND MOSTLY FX's:**
  - `CLAUDE.md`, 66: deleted talent nodes, lanes, rows and capstones cited in rules. FX's block tells the reader to take
    each as the record, and GB kept them on that ground; its list says *"Among them"*, and most are not on it.
  - this file, 38: the Loyalty item and the block that declares *"NONE OF IT IS STALE"* still price nodes FX deleted
    (Kindred, Quick Whistle, Ancient Pact, Feral Momentum); `Talents.LANES` and the lane-build sim policy are cited as
    live; DN §8 is called open though DO ruled it.
  - `docs/master.html`, 28: the talent-point economy in §2, §3 and §5 still reads as it did before BM (a point on
    awakening, on every elite, mini-boss and boss); a builds-with cell names the Poise lane; Harvest is said to sit in
    the Hunter class pool (it is only in the Survivalist's boss pool); "the talent trees" stays plural in three places (the one in the relic paragraph corrected at GE §2).
    It also carries the per-hero relic ruling as unbuilt, a plan in the one document that holds none.
  - `docs/instrument-rules.md`, 3: a talent granting an ability (none has since DO), *"A LANE ROW IS ONE FULLY-BUILT
    HERO"*, and Battered Not Broken removing banked Break (the node is gone).
  - the game's source, 3, all wording: `battle.gd`'s zone-boss comment banks *"PER SPEC"*, and two comments call
    `talents` an equipped loadout.
- **`docs/systems-recon.html` still lists the bar-swap relic as the second opt-in exception** (it already says the relic
  does not exist). A recon is regenerated, never hand-edited.
- **THE CATEGORY HAS NO INSTRUMENT.** A gate could assert, for each marked claim, the fact that makes it unbuilt — only
  the Sharpshooter carries Focus, the three `*_active` switches are unassigned, no engine rune exists — so the day one
  is built the gate reds and says the marker is owed its removal. Nothing does today. **GK ended two of those three
  facts** (the switches have one writer; engine runes exist) **and nothing redded, which is this item's point.**
- **`docs/ways-of-working.md`'s conflict table says this file "has no reader"**; `check_es` §4 reads it.

### FOUND AT GB AND NOT FIXED — **THE §4 CENSUS'S FINDINGS OUTSIDE ITS THREE FILES; THE THREE PLAYER-FACING TEXTS, THE RECAP GAP AND THE QUIT/RESUME SKIP CLOSED AT GF; THE SIX RULES CLOSED AT GC**

The census that swept `CLAUDE.md`, `scripts/run_state.gd`'s comments and this file read every claim against the
code, and some of what it found lives elsewhere. **The tables are in `docs/reports/GB.md` §4.**

- **A FORFEIT BOOKS A SUMMONED NODE.** `Run.debug_summon` switches off the run ledger and the wipe branch's Profile
  booking, and `_do_forfeit`'s `Profile.note_forfeit` is not guarded. Debug-only.
- **THE FIXED MODIFIER NEVER REACHES A MINI-BOSS.** At rung 3 `arm_fixed_modifier` arms the mini-boss on entry, and
  the bargain that always follows overwrites it (`accept_offer`); RunSim takes the bargain first, so the guard skips
  arming. The mini-boss entry in the fixed list is dead in both flows.
- **NOTHING STOPS `DOD_SIM_RUNES` CHANGING A REAL GAME.** `runes_mode()` reads the environment with no `sim_run` gate,
  and the `test_runes` assertion a `run_state.gd` comment claimed for it never existed: the purity arm covers the
  economy and power flags only. *Stats* or *off* left exported in a player's shell changes a real run.
- **STALE COMMENTS AND PRINTS OUTSIDE THE THREE FILES.** Each is an asserted surface, so each owes the source literal
  sweep:
  - `battle.gd`: two comments cite *"CLAUDE.md's hang mode (1)"*, which no longer exists; one says
    `check_cm_live.gd` sets both flags by hand (it sets none); one still counts EIGHTY-FOUR terms and 78 absent; and
    others cite deleted content as live (the Madness lane, the Resonant Hymn node, `wd_hold_line`) or say
    *"clearing ANY slot heals"*, *"offers precede fights and elites"* and *"spec pool only"*. Its sequence comment
    gives 89.7–90.0% where `check_cs` computes 97.7–98.8% from the constants; the inputs may differ, so that one is
    a disagreement rather than a known error.
  - `classes.gd`: the Swordmaster's `why` says *"the two drafted ones"* where four drafted cards swap now; it and
    `map_screen.gd` name `Runes.loadout_tag_census`, which does not exist; the boss-award dict's header says it is
    read and nothing else is, beside a three-tier chain; and the draft's header still lists merchants as a source.
  - `runes.gd`: DEBUFF *"for SEVEN"* (it is five) and *"five per hero"* (it is four to six).
  - `relics.gd`'s header says relics come *"one per zone-boss kill"* (the end boss unlocks one too).
  - `unit.gd`'s Resonance header names *"Conduit and Singularity"*.
  - `docs/master.html`'s two Guard Change sentences name Precision Strike and Feint as the other swaps;
    Wheeling Cut and Battle Poise's free pivot swap too.
  - Gates and suites: `check_fh` prints that the save is *"redirected in `_ready()`"* (it is `_init()`); `check_es`
    §3 still calls `anchor` *"the one common in the file"* and §2 *"all sixty-five"*;
    `check_eg`'s header calls itself the only thing in the project that drives the third zone-boss grant,
    which `check_fh` §1 drives too; `check_em`'s header says `UNIT_MATH` holds NINE and not `armor`
    (it holds eight, `armor` among them); `check_ea` says *"exactly 3 for seven specs"* over a
    table showing six; `check_ez`'s header says 21 authored where §0 asserts 60; `check_fi` says *"those four
    lines"* over six; `check_da` prints Glacial Prison as a talent grant where `check_cz` counts none; `check_dr` §3
    prints three deleted nodes as live cooldown sites; `check_du` §4's message calls the `tinderbox` modifier *"the
    kindling bargain"*; and `test_batch_cp`'s comment counts six and five where its table names eight.
- **DORMANT BRANCHES THAT ONLY SUITES DRIVE.** `free_swap`, `layered_faith`, `communion_ranks`, the talent half of
  `spread_ranks` and `crushing_blows_ranks` have no writer in `scripts/` or `data/`; suites set them by hand, so they
  exercise code no player can reach, and `master.html` still documents Crushing Blows.
### FOUND AT FX AND NOT FIXED — **NONE BLOCKS A BATCH; THE FIRST TWO ARE PLAYER-FACING WORDING**

- **THE STATUS NAMES KEEP THEIR PRECEDENTS' WORDS.** The `iron_will` chip reads "Iron Will" and the `undying_rage`
  chip reads "Undying Rage", while the log lines beside them name the node of the one tree. Renaming a chip after its
  applier is the designer's call.
- **THE "BUILDS WITH" LINES IN master.html §6 WHOSE EVERY PARTNER WAS A DELETED NODE WERE REFILLED WITH LIVE CARDS**
  (for example Hoarfrost Armor → Killing Frost, Alms ↔ Divine Presence). That is card copy nobody chose.
- **275 of the 304 fields the twelve trees wrote are dormant**: their read sites stand and nothing writes them. What a
  player could meet:
  - the Devout's Faith lane has only the Binding Oath rune's opening Faith;
  - the two-companion mode (`the_pack`) is unreachable;
  - the Mercy line sits at half health always;
  - nothing buys the Bared Guard's cost back.
- **154 log labels and about a dozen status chips on dormant read sites still name deleted nodes.** They cannot fire
  today. `docs/reports/FX.md` §9 says where the list is. **GB adds one:** `_evade_source` still labels the
  `ghillie` read, dormant since GB, as *Enemies Look Past You*.
- **About 349 comment lines in `scripts/` carry the retired vocabulary**:
  - the SYNERGY and AXIS lines in `classes.gd`;
  - `unit.gd`'s field headers;
  - the `DOD_SIM_TALENTS` example at `battle.gd:1205`;
  - `Run._migrate_trees`' "are refunded";
  - "Richocet" at `battle.gd:8647` and `unit.gd:457`.
- **Suite checks that cannot fail, all older than FX:**
  - `test_batch_bw`'s kit sweep runs 0 checks;
  - two of `test_batch_bs`'s Forge Body checks;
  - `test_batch_al`'s Toughness check;
  - `test_batch_av`'s no-Mercy raise;
  - `test_batch_aw`/`ax`'s exclusive-reference loop, which is empty.
- **master.html inconsistencies the sweep found and left, all older than FX:**
  - §3's elite talent point contradicts §8;
  - §4.3's Seasoned Fighter half-health wording;
  - the Parry Up row credits the retired Still Wrist;
  - Overcharge is "half" in one place and "FULL" in another;
  - §12's "talent-gated abilities".
### FOUND AT FW AND NOT FIXED — **A REPORT TOUCHES NO CODE; THE FIRST TWO ARE PLAYER-FACING (THE SIM's POTION CLOSED AT IP §2)**

- **`relics.gd`'s header says every hook is read at exactly one site** — `gold_find_mult` is read at two,
  `shop_discount` at four, and **`rest_heal_add` at none**, so Cairnmoss Poultice pays nothing and
  neither does Martyr's Knucklebone's *"rest nodes restore 10% more"* (GB). **`docs/master.html`'s copy of the claim was
  corrected at GE §2**, where six hooks read at more than one site were counted; this header still owes its own. **IJ §2
  dropped the rest clause from Martyr's Knucklebone's words**; **Cairnmoss Poultice is suspended from every draw since IK §6**
  (`Relics.is_suspended`), its entry and the player's unlock kept, until its re-cut ships.
- **`CLAUDE.md`'s "four death-refusals"** are four call lines holding six refusals, with four more lethal refusals
  above the subtraction that ticks never reach. **~~Its CV §1 cites `tick_statuses` at `unit.gd:2171`~~ — CLOSED AT
  GB §4: the line number is dropped.**
- **Stale comments:** three still call the skill-check profile five fields or `_run_skill_check` three call sites
  (`battle.gd:23`, `:919-920`, `:929-935`); FT's own say all 23 `next_time` writes divide by `effective_speed()` —
  14 do.
- **Never-applied content:** the `ward`, `focus`, `rampage`, `seeding` and `melted` statuses; Weight of Ruin's
  "half speed" has no read site; White Heat and Fuse have no writer; the "Focus" resource drip cannot run.
- **A tick that kills skips `_on_enemy_death`** (`battle.gd:2782-2784`), so nothing that pays on a kill sees a
  Burn or Poison kill.
### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED — **A PROJECT ON ITS OWN BRANCH SINCE FQ; STEPS 1–5 BUILT (3's NINE ENGINES AT GO, 4's POOL MERGE AT GP, 5 AT GP AND GV), AND THE RUNE SCOPES MERGED AT HC; STEP 6 CENSUSED AT HA, ITS FIRST HALF TAKEN AT HD, ITS RETIREMENTS AT HH AND ITS RE-POINTS AT HI AND HJ — **EVERY STEP OF THE RUNNING ORDER IS DONE** (BELOW)**

**Full evidence: `docs/merge-recon.html`, written to be read section by section across many
batches. `docs/reports/FP.md` is the batch's own working.** FP authored nothing and proposed
nothing: it measured what dissolving the twelve specs into their four classes would cost, and the
ruling was the designer's, taken at FQ. **Nothing below is a recommendation about whether to do it.** These are
the things a later batch must not re-derive from scratch:

- **THE SIZE, IN BATCHES: TWELVE TO FOURTEEN, AND THE GAME IS BROKEN THROUGH ROUGHLY EIGHT OF
  THEM.** Not degraded — broken. From the moment the engines move, **52 battery targets carrying
  71.6% of the project's asserted checks are red** for as long as it takes. **This project has
  never worked in that condition**: every red it has carried has been the one sanctioned
  `check_cm_live` red with a note in `baselines.json`, and **a tree with fifty reds has no
  differ.** **GK MEASURED IT: the engine move read 67 of 104 targets red against the unmodified
  battery, and GK repaired its own damage inside the same batch** (`docs/reports/GK.md` §3).
- **THE ENGINE MOVE CANNOT BE STAGED PER SPEC, AND THIS IS THE STRUCTURAL ANSWER.** The unit of
  the merge is a **class** — three specs collapse into one pool, one tree and one stat line
  simultaneously, because there is no state in which the Berserker has merged and the Warden has
  not: they would need one tree and two. **So "merge one class as a pilot" is not a pilot** — it
  is four batches, eight to thirteen nodes salvaged out of 81, and a battery whose engine-bound
  targets do not care that only a quarter of the game moved. **FX has since merged the TREE on its own, ahead
  of the pools and the stat lines, so the tree half of *simultaneously* did not hold and the pilot's salvage out
  of 81 is moot; the engine half stands.**
- **THE ONE PART WORTH BUILDING WHETHER OR NOT THE MERGE HAPPENED WAS THE THREE SPINES AS MACHINERY
  ON NOBODY, AND FT BUILT THEM** (the spines item below). **Sanctity's status-potency layer is still
  the single largest unbuilt system the recon found — the one a merged tree needs independently, and
  the one any future batch wanting a status to be worth more to one hero than to another also needs.**
- **AND THE ONE OPEN QUESTION INSIDE CHANNEL IS A RULING, NOT MACHINERY: there is no `is_spell`
  flag on `Ability`.** The available partition is `dmg_type` — *arcane / nature / shadow / holy /
  physical / fire / frost* — so *spell damage* has to mean *not physical*, or Channel pays into
  `dmg_bonus` and buys the basic attack with it.
- **WHAT THE RECON DID NOT REACH, SO IT IS NOT READ AS CLEAN:** **no balance judgement and not one
  magnitude** — *survives* means *still does what its text says*, never *is still correctly
  priced*; the **enemy, event and relic layers** were swept for spec literals only (2 sites, both
  in `relics.gd`); and the **card classification in §4c is coarse, with both of its instrument
  faults reported in place** — a card that FEEDS an engine without READING it counts as
  engine-free there, which under-states the Pyromancer and the Survivalist most.

### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED — **OWED A RULING (FT)**

**GK MADE THEM REACHABLE, AS RUNES.** Each spine is an engine rune — the Rune of the Vanguard, the Invoker and the
Hierophant, names proposed — and `BattleUnit._sync_engine_switches` is the three switches' one writer, so a hero
holding one has its switch on and no class carries a spine.

**None of it blocks the next batch.** The machinery is drivable and every number is a named
constant, so each ruling is a one-line change. Full working and the measurements:
`docs/reports/FT.md`, for Channel's rate `docs/reports/FU.md` §2, and for Momentum's and Sanctity's
`docs/reports/FV.md`.

- **CHANNEL'S PARTITION.** *Spell damage* = **not physical** (implemented,
  `CHANNEL_SPARES_PHYSICAL`), or Channel pays all damage and buys the basic attack with it. There
  is **no `is_spell` flag on `Ability`** and the only available partition is `dmg_type`, so those
  are the two readings that exist.
- **~~CHANNEL'S RATE~~ — RULED AND BUILT AT FU §2**: every CAST books `max(net, CHANNEL_CAST_FLOOR)`, the floor **10** and
  the step **42** — the figures, and the correction to FT's own economy (a Mage regenerates 22, not 12), are
  `docs/reports/FU.md` §2. **The spread one rate cannot close is a ruling only if it matters** (the Cryomancer near 3.4
  steps a trash fight, the Arcanist near 2.6): a per-spec rate would make a class core a spec engine.
- **~~MOMENTUM'S RATE~~ — SET AT FV §2, AND ITS TAKEN HALF REPAIRED AT FV §1.** One step an exchange,
  now `MOMENTUM_EXCHANGES_PER_STEP` = 1 — the rate is at its stop, because a normal fight already ends
  around a third of the cap and an exchange books at most once a turn. **The taken half counts a blow
  MET as well as health lost**, so a Block, an absolute parry and a shield that eats a blow whole all
  book now. The cap (8 steps × 4% = −32%) is flagged, not tuned, and is a long-fight event.
  - **ONE CONSEQUENCE FV STATES AND DOES NOT RULE: HEALTH A WARRIOR TAKES FROM HIMSELF BOOKS THE TAKEN
    HALF**, because the health door books any health lost. In rung-1 trash no span booked on it alone;
    in elite fights 5–9% of spans did. Whether paying your own health is half of an exchange is the
    designer's; `docs/reports/FV.md` §1 carries the reading and its caveat.
- **AND THE ONE THAT IS NOT A NUMBER: HOW A SECOND METER DISPLAYS.** The nameplate bar is ONE fill,
  ONE colour chosen by a ternary on the NAME and ONE label, and it breaks by construction under two
  currencies. **The game already answered this three times and never widened the bar** — Faith,
  Loyalty and Ruin all display as chips. **A chip costs nothing and cannot show a fill**, which is
  what a ramping meter most wants to show. That is the trade.
- **AND THE THING TO WATCH RATHER THAN RULE:** all three are LEDGERS — they accumulate, pay while
  held, and are never consumed, which is `faith_peak`'s shape and the repair BI §1 prescribes.
  **The day a card or rune SPENDS one of the three, BI §1's antagonism arrives with it**, silently,
  because a spender reads exactly like a payer until somebody asks what the held half is worth.
  The rule is in `CLAUDE.md`.

### FIVE DRAFTED ABILITIES ARE NAMED AND DESCRIBED NOWHERE — **FOUR FOUND AT FR §2, ONE AT GB; OWED**

**`Arcane Surge`, `Divine Wrath`, `Mana Shield` and `Reality Fracture` appear in `master.html`
ONLY inside §6b's draft-pool list.** They are live, drafted, working cards with no row in the
drafted-abilities table and no description anywhere in the document.

- **All four are Batch DY vault re-homes** — DY moved seven finished abilities out of the deleted
  `CLASS_POOLS` container into live pools, and four of them never got their rows written.
- **The other entries absent from that table ARE described**, beside their spec's kit in
  §6.1–§6.4 — **all but one: Rallying Shout, a Warden draft card, found at GB**, appears only in §6b's
  pool list and a §7 aside, with no row and no description.
- **NOT FIXED AT FR because writing their rows is AUTHORING**, which a document batch may not do.
  **The gap is now stated in the document itself** (§6b's table heading names FR's four, not the
  fifth), so a
  reader meets it rather than assuming the list is complete.

### `master.html` §6b's "66 DAMAGING ABILITIES" RESOLVES AGAINST NO POPULATION — **FR §2, NOT FIXED**

*"30 of the 66 damaging abilities never state their damage in prose."* **The whole corpus gives 75
with `damage > 0`; the draft pools give 39.** Neither is 66. The denominator is a past batch's own
classification and is not recoverable from the tree, so **the figure was reported and deliberately
not corrected** — correcting it would mean inventing a population.

### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE

- **`scripts/events.gd:8–12`'s comment carries the same false worked example the document did** —
  *"Health for a rune, gold for maximum health, health for talent points"* — and `talent_points`
  has never been an event verb. **It is code, FR's brief forbade touching code, and
  `docs/instrument-rules.md` records that a `.gd` comment is an asserted surface.** Two-line fix.
- **`master.html` reads *"clearing any encounter heals **the every hero** 15% of max HP"*.**
  One word. It is outside a NUMBER sweep's scope, and by the time it was noticed the tree was
  frozen for the battery — a post-run edit would have made the shipped tree differ from the
  verified one.

### TWO SYNC DESELECTIONS ARE DISPUTED BETWEEN THE REPO AND A BRIEF — **OWED A ONE-LINE RULING (FS §3)**

**The picker's selection state is not in the repo and no instrument can read it**, so this is the
one class of question where the tree cannot settle a disagreement. The first is recorded on
`CLAUDE.md`'s own deselection lines rather than only here, because a rule contradicted by a ruling
that lives in a report is a rule a future batch follows.

- **`docs/reports/` — growing by one every batch.** `CLAUDE.md` listed it as MUST STAY SELECTED
  from EE until FS moved it to a disputed line of its own, and this file declined to move it on exactly
  that ground; **FS's
  brief opens §3 with *"Reports are already deselected."*** It is the largest single item still in
  question. **Do not read the absence of a change as agreement.**
- **`docs/talent-audit.html` — 165.03 KiB of the 207.63 the two audit documents carry.** FS's brief
  lists it and `docs/text-audit.html` as *"both ruled and applied"*; this file records that the
  talent audit **cannot** leave while DN §8 is open, and §8.1.1's own heading reads *"THE CHARTER
  CONTRADICTS ITSELF ABOUT THOSE 75, AND SOMEBODY HAS TO RULE."* The text audit is genuinely ruled
  and applied and is not in question.
- **AND THE DESELECTION PATTERN ITSELF NEEDS ONE WORD CHANGING.** *"Every `test_batch_*.gd` and
  `check_*.gd` at the repo ROOT"* leaves **five** suite files selected — `test_runes.gd`,
  `test_rune_battle.gd`, `test_run_harness.gd`, `gate_fixture.gd` and `suite_fixture.gd`.
  ***All root `.gd` files*** is the same set with no exception list to remember. This half is a
  wording fix rather than a ruling.

### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` — **FOUND AT FS, RECORDED, NOT CLOSED**

`build_pin_manifest.py` binds a holder off a literal `"res://…"` **inside the `var` statement**, so
`const DOC := "res://docs/master.html"` followed by `var doc := FileAccess.get_file_as_string(DOC)`
binds nothing — and a needle written as a named constant is not a literal at the call site either.
**`check_fr` contributes four pins and NONE of them is into `ways-of-working.md`, the file it exists
to read; `check_fs` contributes zero.** Two document gates, and `check_ed` is blind to everything
either of them asserts.

- **Closing it is a change to the generator's binding rule and is a batch of its own.**

### THE MERGE'S RUNNING ORDER — **RECORDED AT FQ §3 SO THE SEQUENCE SURVIVES A COMPACTION**

**Ruled: the merge is a PROJECT, not a batch — twelve to fourteen batches — and it is developed on
its own branch with `main` staying playable** (`docs/ways-of-working.md`). **None of the below was
done at FQ.** The order is recorded so it is not re-litigated batch by batch:

1. **~~THE THREE SPINES, ON NOBODY~~ — DONE AT BATCH FT; CHANNEL'S RATE SET AT FU, MOMENTUM'S AND
   SANCTITY'S AT FV.**
   Momentum, Channel and Sanctity built and tested **before a
   single spec dissolves**. FP measured that this touches **none of the 400 authored things**.
   **Sanctity's potency layer is still the largest
   unbuilt system in the game and is wanted independently of the merge**: its reading half is the
   cheapest of the three (`add_status` is a single funnel), and its PAYOUT does not exist anywhere,
   because `STATUS_INFO` holds 156 ids and carries **no magnitude at all**.
3. **~~ENGINES TO RUNES, each with its enabler~~ — BUILT AT BATCH GK; THE NINE ENGINES THE CHARTER'S SIX A CLASS
   OWED BUILT AT GO**, the designer's nine, transcribed. **THE ENABLER RULE NARROWED AT GS**, ruled: an engine brings
   only what it cannot run without.
   - **~~AND A CLASS KIT OF THREE, RULED IN GL's BRIEF~~ — BUILT AT GN.** Its recon is `docs/kit-recon.html` (GL); GN's
     brief names the Crown's Break and freeze resistance as the batch after the kits. No step number was ruled for it.
4. **~~POOL MERGING~~ — BUILT AT BATCH GP.** One pool a class (38 / 41 / 34 / 36; **43 / 51 / 43 / 41 since GS §1**, **43 / 51 / 43 / 42 since HB §2**, Tripwire on
   the Survivalist's shelf; **42 / 51 / 43 / 42 since HL §1**, Guard Change travelling with the Stances; **42 / 52 / 43 / 42 since IF §2**,
   Smoulder on the Pyromancer's shelf;
   which put the 29 cards that stopped travelling on their shelves), the class-wide cards ordinary cards in it, the
   class-wide share and EH §1's third zone-boss tier deleted, and **a card that reads an engine offered only to its
   holder** — 34 of the 149, derived at the read site and driven both ways; **37 of the 178 since GS, of the 179 since HB,
   of the 178 again since HL §1, and of the 179 since IF §2** (Lunge a ruled 38th; Guard Change's ruled row went when it began
   travelling; Smoulder reads none).
5. **~~THE 43 ENGINE-READING RUNES AND THE ENGINE-READING CARDS~~ — THE CARDS AT GP, THE RUNES AT GV.** GP took the
   CARDS half at the offer door; **GV took the RUNES half at every rune door and at a queued cache's answer**, and the
   population is **35 of the 60 live ordinary runes** rather than FP's 43 (a rune that half-works, or reads a card, a
   status, the stance or nothing, is not gated — GP's own groups). GM's standing item — *ten live spec runes are read
   only under their lineage's engine, and a rune's scope is the lineage, so he is still offered them* — is closed by
   it; **what the scope itself should be was GV's ruling 5, answered at HC: the CLASS**, with the engine gate (36 rows
   since Layered Aegis), the card a rune names and a companion present deciding what a hero is offered.

### **AND FP's `block_chance` FINDING TRAVELS WITH IT — RE-VERIFIED AT FQ, AND THE CODE SAYS IT OUT LOUD**

**`block_chance` has NO universal baseline.** It defaults to **0.0** (`unit.gd:142`) with no
sentinel, the **Warden alone** declares it at **0.10** (`classes.gd`), and the only other
unconditional source is `_plating_slice`, which opens on `u.has_engine("heavy_plating")` (GK). **The contrast is `parry_chance`**, which defaults to **−1.0** — a
*use-the-role-baseline* sentinel — against `PARRY_CHANCE := 0.05` for every hero. **So `sm_sword_mastery` (+parry%) genuinely survives a merge and
`wd_unkillable` (on a Block) genuinely does not, and the two are indistinguishable from the
payload.** Three surviving Warden nodes died to this at FP.

- **AN ENGINE RUNE CARRYING HEAVY PLATING INSTALLS A CLIMB ON A BASE OF ZERO — BUILT AT GK, AND OWED A RULING**
  (GK's rulings item), and `PROTECTED_CORES` cannot see it **because the enabler table names ABILITIES and
  this is a STAT**.
- **THE TABLE SAYS SO ITSELF, WHICH IS THE PART TO KEEP.** `PROTECTED_CORES["warden"]` carries
  `"enablers": []` with the `why` *"Heavy Plating is a Block-chance rule; it reads no ability."*
  **The gap is not an oversight the merge discovers — it is documented in the table that has the
  hole.** **The enabler concept has to cover STATS, not only abilities**, and that is a change to
  `PROTECTED_CORES`' shape rather than to its contents.
- **AND ONE NODE ALREADY INSTALLS THE STAT.** `wd_mountain` (Immovable, the Plate capstone) grants
  `block_chance: 0.20` in its own payload, so a merged Warden node can partially self-enable —
  which makes the survivor question *"does it reach a non-zero base"* rather than
  *"does it name the engine"*.
- **AT FX ALL THREE NODES WENT WITH THEIR TREES** (`sm_sword_mastery`, `wd_unkillable`, `wd_mountain`). The one
  tree writes `parry_bonus` (Parry More, at Sword Mastery's number) and no `block_chance`, so the finding binds the
  engine move, not the tree.

### FN HANDED OVER THREE DESIGN QUESTIONS — **FO TOOK TWO. ONE IS STILL OPEN.**

**FN flagged and did not retune, which is what its brief required. FO ruled on the two that were
worth EXACTLY ZERO and left the pricing question alone.**

- **AND TWO OF THE EIGHT JUST GOT MUCH STRONGER, WHICH IS THE OTHER SIDE OF THE SAME MEASUREMENT —
  STILL OPEN, AND FO DID NOT TOUCH IT.** The Wide Rite went from **1.4%** of an Occultist's build
  space to 100%, and Heavy Bolts from **2.6%** to 100%. **Neither magnitude was retuned and neither
  should be re-read as a bug**; whether they are now correctly priced at 100g is a design question
  and it is the designer's.

### THE SHARED MARK'S MAGNITUDE IS PROPOSED, NOT RULED — **OWED A DECISION (FO §2)**

**`SHARED_MARK_FOCUS := 5`, and the batch claims the DERIVATION rather than the number.** It is
priced against the **20** a consecutive attack on his own mark pays him (`20 + muscle_memory_ranks`,
both terms zero untalented). **The ally population in a legal run is the three other heroes**, so a
quarter pays **15 against his own 20** and keeps his own shot the largest single source under every
composition; a half would pay 30 and the rune would stop supplementing his patience and start
replacing it, which BI §1 says a single meter cannot afford. **One authored copy in `battle.gd` and
one string on the card**, so a re-tune is two lines — and `check_fo` §2c asserts the two agree, so
they cannot part.

### THE RUNE OF THE STANDING GROUND IS NOT AUTHORABLE, AND THE RULING IS THE PART TO KEEP

**Its whole clause has been the BASE KIT since Batch AW §2** — `cons_ground` applies to every
living non-companion hero and `_ground_faith_tick` grants Faith at every unit's turn start — so the
rune as written would install, log nothing and change nothing. **A rune that ships inert is worse
than one that does not ship**, and inventing a different payload for it is what a batch may not do,
so FK reported it and shipped 39 of 40. **THE RULING, WHICH IS THE HALF A REPORT CANNOT CARRY: the
day a batch narrows that ground to its caster, the rune becomes AUTHORABLE.** `check_fk` §6 asserts
the absence AND the two code facts that cause it, so the battery says so rather than the
opportunity being rediscovered. **Two alternatives are priced in `docs/reports/FK.md` §7 — the
ground kindling deeper, or kindling the Devout's own count at a second rate — and neither is
recommended over the other, because rune content is written with the designer one rune at a time.**
**The Devout's fifth is the open item; this is the reason his fourth is where the set stops.**

### TWO INSTRUMENT OBSERVATIONS FROM FM — **ONE REPAIRED, ONE NOT**

- **`test_batch_cb` FLAKES UNDER BATTERY LOAD AND IT IS NOT REPAIRED.** FM's reconnaissance run
  read **1721 checks / 1 failure** — *"the bank is emptied rather than skimmed (got 9)"*, the Pyre
  Wake / Overburn deep-stack arm — and **three standalone re-runs read 1721 / 0**, matching the
  baseline exactly. It is nothing to do with runes; the arm awaits frames, and the battery was
  running four Godots wide at the time. **Recorded rather than repaired**, because a flake diagnosed
  from one observation is a guess: the next batch that sees it has two, and `baselines.json` says
  `fails_obs: 2` for that row, which is thin.

### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS — **NAMED AT FL §3, NOT FIXED**

**Fourteen suites read the stamp and every one asks the same durable question**: that
`docs/master.html` carries a `Last updated:` line, and that its batch code sorts **no older than
the reading suite's own**. That shape is CN's and it is deliberate — the alternative was a literal
that had to be hand-bumped every batch, which *"will be red most batches"* and stops carrying
information. **The cost is that the newest of the fourteen is `ce`**, so any stamp from CE forward
passes all fourteen. **FI's stamp survived FJ's and FK's edits to the document untouched**, and
nothing went red. **Repairing it is not a matter of bumping the pin** — a suite that asserts the
CURRENT batch code is the shape CN removed on purpose. **The question a fix has to ask is whether
the stamp moved when the FILE moved**, which is a different instrument from the fourteen and needs
git or an mtime, neither of which a `--script` gate has today. **Recorded with its reasoning so
the priced alternative is not re-proposed as a discovery.**

### THE SKILL CHECK'S DIFFICULTY IS RULED AND BUILT — **ONE OBSERVATION IS OWED FORWARD (EY)**

**Full evidence: `docs/reports/EY.md`.** The designer ruled the checks too hard, `sweep_time` moved
0.72 → 1.00 and the half-widths were deliberately left alone. **Nothing about the ruling is open.**
This item carries the two things a later batch must not re-derive from scratch:

- **THE SHARPSHOOTER'S FOUR-PRESS OPENING GOOD WINDOW IS 97.3% OF THE TRACK** — a miss band of
  6.9 ms at each end of his 520 ms pass. It is the arithmetic working as designed (`SS_SEQ_OPEN`
  holds his SEQUENCE risk flat, and a flatter sequence at an easier base is a wider opening), and
  nothing in EY touched it. **But there is no tolerance left to spend on him**, and `check_cs` §4's
  flat-difficulty assertion now passes at **0.011 against its 0.02 bound** where it used to pass at
  0.003. **The next batch to widen a window is the one that finds out.**

### THE CRIT SURPLUS IS RULED END TO END — **NOTHING IS OPEN. EX CLOSED THE LAST NUMBER.**

- **`check_ew` §6's last assertion is vacuous** (`ok(step == step, …)`) and is owed a repair by
  whichever batch next has reason to touch that gate. It is one of the 38, so repairing it in place
  keeps the count.

### `BOND_MITIGATION_MAX` STAYS AT 0.75 — **RULED AT EW §3. NOT A QUESTION ANY MORE.**

**EV measured and priced it; the designer has ruled it stays.** The guard forces some value below
1.0 and does not force 0.75 — 0.85 or 0.90 would satisfy it identically and would push the bear's
saturation point from a boon of 7.50 to 8.50 or 9.00, which is one to two more stacks of real cover
at the deep step and five to seven at the untalented one. **But that constant is a 75% damage
reduction and 0.90 would make it 90%**, which is a large survivability change wearing a saturation
fix's clothes, and **EV's fallback already answers the waste**. **Recorded with its reasoning so the
priced alternative is not re-proposed as a discovery.** (Savage Presence's taunt ceiling of 1.0 was
never in this question: it is `minf(..., 1.0)` on a probability, so it is arithmetic.)

### THE LADDER — WHAT RUNG 2 SHOULD ASK. **RULED BY THE DESIGNER AFTER EP. UNBUILT.**

**Full evidence: `docs/reports/EP.md` §2.** Rung 2 is the same fight as rung 1 in the same number
of turns with the damage doubled — enemy health is bit-identical between the two rungs and every
ability field is unchanged. **Five options were costed and the designer has ruled on all five.**

- **TAKE C, OR C+D.**
  - **C — RUNG-TAGGED ABILITIES.** *"The only option that gives rung 2 a question rung 1 doesn't
    have, and it's the ladder's own stated principle: stat inflation alone is a wall, a named twist
    is a ladder."* **Zero code** — `Enemies.config` already filters on `rung` and defaults an
    untagged ability to 1, so a third tag is one field in `data/enemies.json`. **The cost is pure
    authoring**, and every new ability owes `master.html`, `text-standard.html` and a card row in
    the same batch. Today **2 of 50 authored abilities carry a rung tag and both are the end
    boss's.**
  - **D — THE ENCOUNTER SHAPE, AND IT IS THE ONE TO PAIR WITH C.** *"It moves the axis §1 proved
    rung 2 doesn't touch at all."* A wider warband at the same per-enemy strength makes AoE, cleave
    and Break-spreading real decisions rather than incidental ones. **THE BK §5 TRAP IS NAMED AND
    AVOIDABLE**: the budget ramp was rescaled precisely because slot 15 would otherwise collide
    with the boss's own 10–12 band, and `compose` floors elite and mini-boss rosters at 6 so an
    elite cannot degrade to a plain mob. A rung-aware budget must respect both.
- **A IS THE ONE TO AVOID**, exactly as EP warns: not to be stacked on an unplayed ×0.50.

**WHAT IS STILL THE DESIGNER'S INSIDE C:** which abilities, on which enemies, at which rung.
**Rune and ability content is content and this file does not invent it.**

### THE RUN REPORT'S WIPE TABLE IS BANDED FOR A TWELVE-SLOT ZONE — **NAMED AT EP §1c, NOT FIXED; GJ GAVE THE END BOSS ITS OWN COLUMN**

`run_sim.gd` bands `tier >= 11` as **"boss"** and its per-tier table loops `for ft in range(1, 12)`
labelling `ft == 11` as the boss. **A zone has held SIXTEEN slots since BATCH BK; the zone boss is
slot 16 and the mini-boss slot 8.** So the band is six slots and the per-tier table **silently
drops slots 12–16**, which is where most wipes happen — its printed win rates are optimistic by
construction. (`_finish_run`'s comment said the ladder was *"(zone-1)\*11 + tier, so a full clear is 33"*;
GJ corrected it to the code's `(zone-1)*16 + slot` and a full clear of 49.) **Reading the printed table literally reverses
this batch's own answer** (it says 57 wipes at "boss" where 7 are at the zone boss). **The true
distribution is available today from the per-run progress line, which carries the exact slot** —
which is why EP measured rather than repaired, and why repairing it is a small, clearly-scoped
instrument batch rather than an emergency.
- **GJ added an `end boss` column** for slot 17, which only the final board carries, so the end boss's wipes — no run
  reached it before GJ — never fall into the band. The band, the per-tier table's range and the queued repair are
  untouched.

### THE ARCHETYPE TAGS — READABLE AT ES, KEYED TO NOTHING, AND EVERY DESIGN QUESTION STILL OPEN

**Full evidence: `docs/reports/EK.md` (the derivation), `docs/reports/EL.md` (the names and the
seventh) and `docs/reports/ES.md` §4 (the reading machinery).** The vocabulary is
`DEBUFF · DEFENSE · BREAK · RESOURCE · OFFENSE · TEMPO · MARK`, it is on every ability in the corpus
and every authored rune but the core runes (the glossary's words since IJ §2), and the draft card shows it.

- **FROM BATCH EZ UNTIL FN THE INERTNESS WAS OVER AND THE CLAIM BELOW WAS SUPERSEDED. EIGHT RUNES
  ASKED.** Deepening Hex, Bracing Line, Heavy Bolts and the Answering Pack read a THRESHOLD; the
  Wide Rite, the Long Watch, the Wide Watch and the Shared Scent read BREADTH. **They asked through
  a DIFFERENT shape from the one ES built**: EZ §0's conditions were FRACTIONS of the hero's
  DRAFTED cards counting the PRIMARY tag only (`Runes.threshold_met` / `breadth_met_fraction` over
  `Classes.primary_tag_*`), where ES's are absolute counts over the whole bar counting both tags.
  **The ES shape is right for a screen and the EZ shape is right for a condition** — see
  `CLAUDE.md`'s standing rule for why a condition needs a partition. **`check_ek` §3's file
  population grew a THIRD CATEGORY rather than losing a claim**:
  `talents.gd` was a CONSUMER until FN, asserted to name exactly the one door and no tag word at
  all, and `battle.gd` still holds zero.
  *The original bullet follows, unedited, because its door and its measurement are unchanged.*
- **THE INERTNESS ENDED AT ES §4 AND WHAT REPLACED IT IS NARROW: a rune CAN ask how many equipped
  cards of a tag its holder carries, and NO RUNE ASKS.** The door is
  `Run.loadout_ability_names` → `Classes.tag_census` / `tag_count` / `tag_breadth`, with
  `Runes.tag_threshold_met` and `Runes.breadth_met` as the two shapes a clause comes through.
  **`check_ek` §3's game-side population is FOUR now** — two files defining, two displaying — and
  its claim is unchanged: **nothing reads a tag for anything but display.** The rule that a display
  surface may not BRANCH on one is asserted directly over `TAG_ORDER` rather than by proxy.
- **AND THE FIRST THING THE MACHINERY MEASURED IS THE CONSTRAINT ON EVERY FUTURE THRESHOLD RUNE.**
  The protected cores ALONE meet a 2+ threshold on **BREAK for ten of the twelve specs** and on
  **DEBUFF for five** — five until GN, whose class kits put Crushing Blow and Mocking Blow on every
  Swordmaster and Snare Trap on every Beastmaster, seven from GN to GS, six from GS §1, which took every card but the
  enablers out of the lineages' kits, and five since HB, when the Beastmaster's Summon Canis became a call of the
  kit's one OFFENSE / BREAK card (FR §2 had corrected an earlier *seven* here that
  was the OFFENSE column), while **MARK and TEMPO are zero for all twelve** — Blessing of Zeal, the one TEMPO core,
  is drafted since GS.
  `check_es` §4 prints the per-spec table every battery run rather than this
  file carrying a second copy of it.

- **WHETHER THE SET IS RIGHT IS STILL THE WHOLE QUESTION AND IT IS STILL THE DESIGNER'S.** The
  alternative — six STATUS names — is measured rather than described: **40 of 154 covered, 114
  under no tag, and six of the sixteen pools reading a single value.** The seven shipped cover 154
  of 154. **EL proved the rename is cheap**: 292 rows, two files
  and a `sed`, because no reader outside the tables names a tag word. **Changing the set after the
  runes are re-keyed is the rune layer, and that is still true.**
- **TWO WORDS SHIP COLLIDING AND EITHER CAN BE OVERTURNED FOR ONE ROW.** **MARK** meets Hunter's
  Mark, Quarry's Mark, Mark of the Hunt and the `party_mark` chip; **DEFENSE** meets the Defense
  Potion. Both were shipped on the rule that **a same-meaning collision ships and is named**.
  **BRAND, PREY, TETHER, BOUNTY and TARGET are all swept clean** and would carry MARK's ten cards
  without one. The cost is one row of `TAG_ORDER`, one of `TAG_INFO`, and a `sed` over two tables.
- **SEVEN IS RECORDED AS THE CEILING AND AN EIGHTH NEEDS AN ARGUMENT.** Much of the draft is
  already the only card in its pool with its combination, and one pool of sixteen is fully unique.
- **57 PRIMARIES WERE A JUDGEMENT AT EK AND EIGHT MORE MOVED AT EL.** EK's 57 are listed in its
  report with the alternative beside each; **nine were flagged as genuinely arguable** — the stance
  cards, the companion cards, the marks, Anointing, Immolate, Emberkeep, Divine Presence, Fault
  Line and the three consume-cards. **EL's eight are the marks, and they are no longer arguable:
  each had been tagged for what its mark PAYS.** **Two remain arguable and are named**: Snare Line
  (MARK second because it marks the FIELD) and Feint (MARK second because it marks on one branch).
- **PET AND STANCE ARE THE TWO CANDIDATES LEFT, AND SEVEN IS THE STATED CEILING.** **PET** would
  carry the Beastmaster's whole **10-card pool** plus his three summons and Kill Command;
  **STANCE** would carry 3. Both are cards tagged today for what their payoff does rather than for
  what they are — **which is exactly the argument that MARK won on**, so the ceiling is what stands
  between them and a row, not the strength of the reading.
- **THE HERO SHEET IS RECOMMENDED AND NOT TAKEN.** It is the cheapest of the four remaining
  surfaces and the only screen where a player reads a whole loadout at once. **The rune offer wants
  its own surface** rather than `map_screen._pick_button`, which CK deliberately keeps on the
  mid-combat tier. **The battle tooltip and the blacksmith are recommended AGAINST.**
- **THE WORD "ARCHETYPE" STILL NAMES TWO UNRELATED THINGS AND ONLY THE CODE SIDE IS SEPARATED.**
  `ARCHETYPE_ROLE` / `ARCHETYPE_DESC` and `master.html` §6 use it for a SPEC's role, which decides
  base Attack. The constants are `CARD_TAGS` and `RUNE_TAGS` deliberately, and `master.html` §6c
  states the two are unrelated — **but the document still uses one word for both.** Renaming the
  nine spec archetypes is a design decision with a stat table under it.
- **WHAT THE TAGGING STILL HAS NOT REACHED, STATED SO IT IS NOT READ AS CLEAN.** No sim and no
  balance judgement; not one magnitude was measured. **The tags were not compared against relics,
  items, enemy abilities or events**, none of which carries one. **AND EIGHT RUNES WERE KEYED TO A
  TAG FROM BATCH EZ UNTIL FN** (the sentence that stood here — *no rune is keyed to a tag; ES built
  the machinery and authored nothing* — was superseded for that span and is kept only in the shape
  of this correction). EM took the rune charter's MECHANICAL half (56
  clauses off the talent counters onto fields of their own) and keyed nothing to a tag; ES gave a
  rune the QUESTION to ask and no rune asks it. **The differential mechanism — a rune worth more to
  a hero pointed the same way — is now buildable and is still unbuilt**, and the first rune that
  keys off a tag is content and is the designer's.
- **AND TWO CLOSED AUDIT REPORTS STILL SAY `Tempo`.** `docs/talent-audit.html` and
  `docs/rune-audit.html` were deliberately not edited: both are CLOSED (CV / DN) and kept *"as
  written — it is the evidence of which way each disagreement pointed"*. **A reader searching
  either file for the Sharpshooter's lanes finds the old name.** A header note on each is one line
  and is the designer's call.

### THE DRAFT AUDIT — TWO FINDINGS RULED AT DR, THE REST STILL OPEN

**Full evidence: `docs/draft-audit.html` (both grade-2 findings now carry a RESOLVED banner) and
`docs/reports/DQ.md`.** Everything below is still open and **no gate encodes any of it**, because
a gate encodes a ruling.

**ITS ARITHMETIC WAS RE-DERIVED AT DY §5 BY DQ's UNCHANGED METHOD** — the pool rows that moved, the Warden's ten decisions
across ten cards and the Mage class pool's six across seven, and the two counts made by different methods, labelled — and
the figures are `docs/reports/DY.md` §5.
- **`test_batch_cd.PER_SPEC_DEPTH` IS STILL THE ONE AUTHORITATIVE DEPTH TABLE** — this page is not
  an instrument and nothing re-derives it, which is exactly the hazard DJ recorded a rule about.
  **The Beastmaster's 8-of-8 engine binding reads 10-of-10** and is if anything tighter.

- **AND THE SAME QUESTION WAS OPEN IN THE BOSS-PICK CHANNEL, AS TWO QUESTIONS — SWEEPING STRIKES' HALF IS CLOSED AT
  GU §2**: it takes Crushing Blow's cooldown of 2, a genuine mispricing retuned to the kit card it sat under. Ashes of
  Al'ar's half stands as DU left it. DU's record:
  **ASHES OF AL'AR RATE-LIMITS ITSELF** — `ashes_used` makes it once a battle by construction and
  its card text says so, so cooldown 0 costs nothing there. **SWEEPING STRIKES DOES NOT**: 20 Rage a
  cast at cooldown 0 while BUILDING 10, two swings, 12 Break, and a 3-turn Daze a repeatable card
  keeps permanently refreshed. **20 of a 100 bar at 3.0 delay is ordinary on both axes, which is
  LUNGE's profile and not Pyroblast's** — so DU §1's ruling does not obviously cover it. **Reported
  at DU §5 and ruled on nowhere.**
- **THE CENSUS BLIND SPOT DT FOUND IS CLOSED AT DU §4 AND THE CORPUS IS 227** (228 since GN's Magic Burst; GS §1
  deleted `apply_kit_overrides` and the four basics are reached on their lineages' shelves). DU's record:
  `apply_kit_overrides` built FOUR SPECS' `abilities[0]` at spawn (**THREE Mage and ONE CLERIC — DV §5 corrected DU's "four Mage specs"; Shadowrend is the OCCULTIST's and overrides Smite out of `kit("cleric")`, so TWO class kits were misread, not one**) — **Shadowrend,
  Fireball, Frostbolt and Arcane Explosion** — and none sits in any pool, so the walk read
  `kit("mage")` and carried the **unoverridden Magic Bolt, which is nobody's live basic attack.**
  It applies the overrides now, using `protected_names`'s own idiom one function up. **RE-RUN
  THROUGH ALL FIFTEEN GATES THAT READ IT, ALMOST NOTHING MOVED** — CN's population goes 223 → 227
  with its no-bar count unchanged at 121 (all four attack, so all four correctly run a bar), and
  CO's, CY's and nine others do not move at all. **`check_cz` §0's agreement is a derived SET
  IDENTITY now rather than an equality** (133 → 134), so a fifth override is covered by doing
  nothing, and an ability outside every kit and pool would be in NEITHER walk and cannot hide inside
  the difference. **`check_du` §5 asserts every spec's LIVE basic is reachable, derived and never
  listed.**
  - **TWO OF THE FIVE CRITERIA DU's BRIEF NAMED ARE NOT DERIVED THROUGH THE CORPUS AT ALL.**
    `check_dp`'s rune-field sweep walks `runes.json` against the comment-stripped source of five
    scripts, and **`check_dr` §5's cooldown-zero census walks the DRAFT POOLS directly.** Neither
    moved and neither could have.
  - **THE ONE THING THE FIX SURFACED IS A TEXT-STANDARD OVERRUN NO WIDTH SWEEP COULD EVER REACH:
    Shadowrend's `perfect_text` renders at 45 against a 44-character ceiling**, one over. All twelve
    new description lines are inside it. **Pre-existing, it joins a standing population of authored
    overruns `check_cl_width` already reports, and it is reported rather than fixed.** That gate
    reports **neither a check count nor a failure count**, so its movement is invisible to the
    differ and `docs/reports/DU.md` §4 is the only record of it: description 4300 → 4348 rendered
    lines with 8 over either way, `perfect_text` 380 → 392 with 52 → 56 over.
- **THE HUNTER CLASS GAP IS RULED AT DS AND ITS DRAFT HALF IS CLOSED.** All three pools are 10
  now and the class has its first heal and its first hero-side mitigation. **ONE HALF OF THE
  FINDING IS DELIBERATELY STILL OPEN AND THE AUDIT'S BANNER SAYS SO**: the Sharpshooter still has
  **no defensive node in his 27**, because DS moved no talent cell — a cell that changes row
  mis-prices the ledger. Only the DRAFT half of "both halves of his progression offer him nothing"
  is answered. **The talent half went with the twelve trees at FX (GB §4 census): the one tree every
  hero wears carries defensive nodes, Deflection among them since GB.** `docs/draft-audit.html`'s
  banner still calls that half open.
- **THE OTHER CONCENTRATION FINDINGS ARE DESIGN AND ARE UNRULED.** The Cryomancer's remaining
  **11-of-11** ice and the Pyromancer's 12-of-13 Burn are reported with their card lists.
  **THE BEASTMASTER'S 8-OF-8 IS NOW 10-OF-10 AND THAT IS NOT THE SAME FINDING WEAKENED** — DS's
  two cards both read the companion, so the ENGINE binding is untouched and is if anything tighter;
  what moved is the AXIS breadth, from 5 decisions to 7. **Whether a total engine binding is a
  problem at all is still unruled**, and DR's framework says it is not by itself.
### THE RUNE CHARTER — MECHANICS TAKEN AT EM, EVERY DESIGN QUESTION IN IT STILL OPEN

**Full evidence: `docs/rune-audit.html` (EJ's audit of all 65 runes and all 135 clauses, generated
from the data), `docs/reports/EJ.md` (the sizing) and `docs/reports/EM.md` (what was done).**
**The charter is the designer's:** *runes are disconnected from talents; they are run-specific items
only, and their purpose is to modify stats and resources, and the mechanics and values of core
abilities, draft abilities and passives.*

**THE MECHANICAL HALF IS DONE AND `check_em` HOLDS IT.** 56 of the 59 clauses were re-keyed onto
rune-owned fields; the property *no rune writes a live talent node's counter* is asserted every
battery, derived from `Talents.tree()` and `runes.json` rather than from a list. **`master.html`,
`design-notes.md` and `CLAUDE.md` all say so now.** What follows is what is NOT done.

- **WHAT SEVERING THE LANE RULE DELETES, RECORDED BECAUSE IT WAS MEASURED — AND ES §5 ANSWERED THE
  SPLASH HALF OF IT.** 36 lane runes and 12 splashes — **48 of the 65** — were authored to *"one rune
  per talent lane, plus one splash"*, whose point was that a rune is *"worth more to a hero whose
  points went elsewhere."* **A rune with its own field is worth the same to every hero of its spec**,
  which is the power increment the rule existed to prevent. **The 36 `lane` fields are still
  authored** and now describe where a rune came from rather than what it reaches.
  - **THE SPLASH HALF IS RULED AT ES §5: A SPLASH PAYS FOR BREADTH ACROSS TAGS.** EJ's finding was
    that with the lanes severed *"a little of every bond"* had nothing left to reach across; **tags
    are the thing to reach across.** The machinery is `Runes.breadth_met`, **no splash is authored**,
    and `check_es` §5 prints the live census every battery. At ES §5 it read **SEVEN of the twelve
    alive, not six retired as the brief said — FIVE were retired at EO**, and they fell along class
    lines: **all three Warriors kept theirs and the whole CLERIC class had none.**
  - **THE LANE-RUNE HALF IS STILL THE OPEN DESIGN QUESTION.** What replaces the variance mechanism
    for the 36 is unruled; **the archetype tags are now not merely the candidate but a BUILT one** —
    a threshold rune is worth more to a hero whose loadout points the same way, which is exactly the
    asymmetry the lane rule provided. **Nothing is authored.**
- **WHAT IS STILL NOT MEASURED, STATED SO THIS IS NOT READ AS CLEAN.** No sim and no balance
  judgement; **not one magnitude was measured in play, before or after.** Runes were not compared
  against each other, nor against relics, items or enemy abilities. Rune PRICING was not opened —
  and it is now a live question, because a rune whose value no longer depends on the holder's build
  is a different object to price.
### THE BOSS-PICK POOLS — AUDITED AT DU §5, RULED ON NOWHERE

**Full tables and working in `docs/reports/DU.md` §5.** DQ dumped them and did not audit them; this
is the audit, and like DQ's it changed nothing. **`SPEC_POOLS` is 44 entries across twelve specs,
42 distinct names** (DY §2 added Dawnbreak and Sanctuary to Holy's). A zone boss awards ONE pick per hero from that hero's spec pool first, there
are THREE zone bosses, and **both channels write the same `bm_abilities` list — so a drafted card
removes itself from the boss offer and vice versa.**

- **THE FALLBACK IS BUILT AT EA §1, WIDENED TO THREE TIERS AT EH §1, AND THIS WHOLE BLOCK IS NOW
  HISTORY WITH ONE LIVE HALF.** **NO ZONE-BOSS AWARD CAN PAY NOTHING UNDER A FULLY-HELD LOADOUT** —
  an exhausted boss pool falls back to the hero's own spec DRAFT pool and then to his CLASS-WIDE
  draft pool, three offered and announced like any other award. **What is still
  true, and is why the block below is kept rather than cut:** the boss POOLS are as thin as they
  ever were, eight specs can still empty one, and the Devout's is still 2 with both entries
  draftable. **Deepening a boss pool is still a live design option; it is no longer a defect.**
  `check_ea` §1 derives the depth table every run and `check_dv` §2 still measures the eight.
- **ONE POOL IS STILL THINNER THAN THE AWARD COUNT AND EIGHT SPECS CAN BE SHORT ONCE DRAFTING IS
  ACCOUNTED FOR — RE-MEASURED AT DY §2 AFTER HOLY'S FIX.** **The award count is THREE**, derived from
  `Run.SLOT_COUNT`. **HOLY'S HALF IS CLOSED** (1 → 3, Dawnbreak and Sanctuary), **AND THE GENERAL
  PROBLEM SURVIVED IT, WHICH IS THE HALF A READER WOULD OTHERWISE ASSUME WAS CLOSED.**
  - **THE DEVOUT IS THE SHARPEST CASE IN THE GAME NOW AND IS WORSE OFF THAN HOLY EVER WAS.** His pool
    is **2** — the only structural shortfall left — and **BOTH of his two are also draftable**, so
    all three of his zone-boss awards can pay nothing. Holy's was visible because it was
    structurally short; his is invisible because it depends on what the player drafted.
  - **EIGHT OF THE TWELVE CAN BE SHORT.** Devout 3 awards at risk; Berserker, Pyromancer, Cryomancer
    and Occultist 2 apiece; Swordmaster, Arcanist and Holy 1 apiece. **Only the Warden and the three
    Hunter specs cannot lose an award.** That population did not move — DY changed Holy's severity,
    not the count.
  - **THE SLOT ARGUMENT HAS MOVED AND IT NOW POINTS AT ONE SPEC RATHER THAN AT THE FIX.** DV's
    *"the card-shaped options are worth least exactly where the hole is worst"* was true while
    Holy's pool was ONE. **She can now lose ONE award of three and the Devout can lose ALL THREE,
    and the Devout carries more earnable slots than she does.** The objection
    applies to Holy's single award, not to the fallback in general.
  - **AND "the only spec that carries FOUR protected cores" IS HALF RIGHT.** `core_slots("holy")`
    is 4 and is the only 4 in the table; **`protected_names("holy")` returns FIVE names and the
    Devout's returns FOUR.** `slots` is authored and deliberately not a name count — the
    Beastmaster's three summons are five abilities in three slots. **The slot claim holds; the
    phrase does not, and it is the phrase that travels.**
  - **AND DY §1 RECOMMENDS ONE MOVE THAT WOULD CLOSE THE DEVOUT'S HALF AND THE SANCTUARY OVERLAP AT
    ONCE — PUTTING SANCTUARY IN HIS BOSS POOL RATHER THAN HOLY'S. It is not taken.**
  - `check_dv` §2 derives every end of this every run and prints the table.
- **28 of the 44 are boss-only; 16 are also in the same spec's draft pool** (DY's two are boss-only). The only name in more
  than one spec pool is **Ashes of Al'ar** (pyromancer, cryomancer, arcanist), which is coherent —
  it is a Mage-wide death-save rather than a spec piece. Lunge and Execute are two of the sixteen.
- **AXIS COVERAGE: the Beastmaster's five deal no damage and no Break at all** — every one is a
  `special`. Coherent with the spec (the companion is the damage) rather than obviously wrong,
  which is why it is reported and not ruled on.
- **AND THE REVERSE COMPARISON IS DONE AND RULED ON NOWHERE BEYOND `ashes` (DV §3).** Every bot
  guard of the form *"only when the target does not already hold it"* was read against the player's
  door. **Seven are already covered by the general rule.** **Four look identical and are NOT no-ops
  — the bot's guard there is POLICY**: Hold Breath also pays +40 Focus, Renewal's Perfect pays a
  burst, Snare Trap also fires `_hit_and_run`, and a Fortified Spirit recast genuinely unwinds and
  re-lays the loan. **TWO ARE REAL CANDIDATES AND ARE UNRULED**: `mark_hunt` (a flat 7-turn mark,
  `rime`'s shape) and `intercession` (a window on every living hero, `cons_ground`'s shape). **AND
  ONE NARROW GAP**: Deadfall SETS `deadfall_armed`, so recasting a FULL one writes the same number,
  and **under Deadfall Network (cap 3) the door permits it** — the exact condition is
  `armed == DEADFALL_CHARGES + 1 and dormant == 0 and deadfall_network >= 2`, because a recast on a
  part-spent or DORMANT deadfall genuinely restores charges and clears the rest. **Dormant since FX (GB
  §4 census): no node and no live rune writes `deadfall_network` now, so the gap cannot open.**
- **`ASHES_RETURN` (25) IS A DEAD CONSTANT, AND IT HAD ALREADY COST A DOCUMENTATION DEFECT.** The
  handler writes `ASHES_RETURN_PERFECT` (40) unconditionally — `FIREDRAW_TAKE`'s shape exactly.
  **`master.html` said the phoenix returns at 25% where the card and the code both pay 40**;
  corrected toward the code at DV. **Collapsing the constant moves a magnitude and was not taken.**
- **`icy_resolve_ranks` IS ANOTHER READ-ONLY-ZERO FIELD AND DO's COMMENT NAMES NINE WITHOUT IT.**
  Correcting the count is one line in `classes.gd`; deleting the field is a mechanic deletion and
  is not proposed. **Nothing is wrong at runtime.**
- **WHAT THE AUDIT DID NOT REACH, STATED SO IT IS NOT READ AS CLEAN.** No sim was run and no balance
  was judged. **Enemy abilities, relics, runes and items were not compared against draft cards at
  all**, and the rune half is a live question — two runes granted a card their own hero could
  draft until ET §1 retired both. **The boss-pick pools were dumped but not audited.**
  `perfect_id` bonuses were read but not compared as a population.

### THE THREE PRICING QUESTIONS — THE LAYER-WIDE ONE IS **RULED AT EB §1**; THE OTHER TWO ARE STILL THE DESIGNER'S

**RULED AT EB §1: THE PROTECTED CORE IS THE BASELINE AND THE DRAFT CARD PAYS FOR ITS SLOT.** The
13-of-17 is the design working, not a mispricing, and `CLAUDE.md` carries the ruling with its
reasoning AND its counter-reading. **`check_eb` §1 asserts the INVERSION — over every card a hero can earn, paired by class, since GU** — a draft card cheaper on
resource AND shorter on cooldown than a comparable core — **with exactly one crossover named
(Divine Plea against Renewal), in both directions.** **GS dissolved that one — Renewal is a draft card now —
and its returning cards brought three: Fireball and Frostbolt against Magic Missiles, Aimed Shot against
Powershot — ruled and RETUNED TO THE BASELINE AT GT §2, so `check_eb` §1 reads no crossover now.** The cap's 29.5%-against-12.8% is the same
relationship through the cap and is not a second finding. **`Ability.PURE_BUFFS` was not widened
and no magnitude moved.** The measurement below is kept because the ruling is *about* it.

**AND EA §3 ANSWERED THE QUESTION DZ's §2 RAISED: IT IS NOT ONE CARD, IT IS THE LAYER** — the pairs, the counts and the
cap's reach are `docs/reports/EA.md` §3. **EB §1 RULED IT: the first reading is intended**, and `CLAUDE.md` carries the
ruling with the counter-reading beside it; `check_ea` §4 pins the direction and `check_eb` §1 the per-pair inversion.

**Full working: `docs/reports/DZ.md` §2 (the first two) and `docs/reports/DY.md` §1 (all three as
first raised).** DZ measured and ruled on nothing.

- **(1) DIVINE WRATH AGAINST BLESSING OF ZEAL — AND THE QUESTION AS ASKED HAS NO ANSWER, BECAUSE
  ONLY ONE OF THE TWO HAS A PRICE.** `divine_wrath` is in `Ability.PURE_BUFFS`, so
  `Ability.make()` clamps it to `BUFF_DELAY_CAP` and the definition writes the constant.
  **Both memberships are CORRECT, driven live**: Zeal moves the target's cooldowns at cast and
  Arcane Surge moves the caster's Resonance — the two exclusions `ability.gd`'s own header already
  names for Blink and Stabilize — while Divine Wrath writes one status to four heroes and nothing
  else. **The structural finding is that the cap is the only instrument in the project that prices
  an initiative and it binds by membership**, so a card excluded for a second payload is priced
  against nothing.
  - **THE FAMILY IS WHAT PRICES THEM, AND ARCANE SURGE IS THE CARD THAT BREAKS THE PATTERN.** Across
    the eleven second-payload exclusions the header names, Mana rises with initiative — and Arcane
    Surge carries the family's TOP initiative (3.0) on **15 Mana / cooldown 3**, against Hold the
    Line's **30 / 6** at the same 3.0. **Blessing of Zeal sits ON the line on initiative and UNDER
    it on cost and cooldown**, so **if either of the two is mispriced it is the protected core and
    it is mispriced LOW.**
  - **AND THE TWO DAMAGE TERMS STACK: a Devout who drafts Divine Wrath and casts Zeal on the same
    hero pays both**, 1.3225. Measured at 1.3333 over twelve seeded blows, with the three chipped
    arms byte-identical across both orders.
  - **NOTHING WAS RETUNED AND `PURE_BUFFS` WAS NOT WIDENED.**
- **(2) ARCANE SURGE'S 3.0 IS THE SAME QUESTION, AND IT IS ANSWERED BY THE FAMILY RATHER THAN BY THE
  CAP.** It is legitimately outside `PURE_BUFFS` — the Resonance bank is a real second cast-time
  payload, measured — so *"three times the cap"* is not the comparison that means anything. **The
  comparison that does is Hold the Line at the same initiative for double the Mana and double the
  cooldown.** For scale, the corpus holds 37 abilities at 3.0 and 19 above it.
- **(3) SANCTUARY OVERLAPS HYMN OF HOPE, HOLY'S PROTECTED CORE PARTY-HEAL, AND THAT IS UNTOUCHED
  SINCE DY.** Hymn: 0 Mana + 1 Mercy, all heroes 20% of max (35% empowered; *heroes* on the card since IJ §2), initiative 3.5,
  cooldown 2. Sanctuary: 30 Mana, no Mercy, every ally 12% (18% on a Perfect), initiative 3.5,
  cooldown 4. **It clears the LETTER of the no-duplication rule** — that rule forbids a strictly
  BETTER card in the same pool, and Sanctuary is strictly worse on magnitude and pays a different
  currency — **and raises the question the rule exists for.** DY recommended moving it to the
  DEVOUT's boss pool, which would answer this and shorten the Devout's shortfall at once.
  **It is not taken, and DZ did not revisit it.**

### THE TALENT CHARTER — SETTLED AT DO, ITS STATUS HALF RULED AT DP

**The charter question is closed and so is its status half.** Full evidence:
`docs/talent-audit.html` §8, `docs/reports/DO.md` and `docs/reports/DP.md`.
**THE STANDING RULE, IN `CLAUDE.md`:** *a talent may not read a status the spec has no guaranteed
way to apply. The ability rule and the status rule are the same rule.*

- **RUINED MIND AND LINGERING TORMENT ARE NO LONGER IN TENSION, AND THAT WAS NEVER WRITTEN DOWN.**
  `oc_torment` fires on an EXPIRING madness effect; the old Permanent Delusion made his madness
  never expire, so the row-7 and row-8 cells cancelled each other. **That is gone now** — worth
  knowing, because nobody had recorded that they collided.
- **THE `owns_ability` PAYLOAD CONDITION HAS NO USER LEFT.** Kept and still tested; deleting a
  condition kind is a design change and it is the natural mechanism for a rune.
- **TWO ABILITIES RUN A SKILL CHECK AND ADVERTISE NO PERFECT, INSIDE A DRAFT POOL FOR THE FIRST
  TIME.** `Rampage` and `Pyroblast` are two of the `test_batch_cp.CHECK_WITHOUT_PERFECT` names
  — a population that predates CN — and DO brought them into `test_batch_bo` §5's reach without
  creating them. **Both are NAMED exemptions there rather than suppressed**, and authoring a
  Perfect bonus for either is a design decision. **A THIRD name reaching that loop still trips.**

### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT

**A TEXT THAT UNDER-STATES ITS OWN PAYLOAD.** An absent clause does not mis-say, so DM §1's test
does not reach it, and **adding a clause to a card is authoring while correcting a wrong word is
repair.** Both are reported and neither was taken.

- **NO SYSTEMATIC SWEEP FOR EITHER WAS RUN.** DM found both by reading six cards, not by sweeping,
  and the thread stops there on purpose.

### Small, and still owed



- **THREE ASSERTIONS PASS VACUOUSLY IN `as`, `at` AND `aw`, AND THEY ARE NAMED AT THEIR SITES.**
  Each reads text that no longer holds the list it asks about, left over from the exclusive-pair
  list DG deleted the red half of. **A check that passes for no reason is worse than a red**, so
  this is owed rather than settled.
- **`_apply_status`'s `src` COVERAGE IS PARTIAL, AND THE REST ARE OWED.** DI stamped the
  36 sites that can apply a status **Harvest reads** and DJ added the seven companion sites; the
  rest apply buffs, marks and hero-side wards, so **nothing currently mis-credits off them** —
  **but Sanctity's payout reads the source too (FT), and IL §1 partitioned the 104 sourceless calls
  by whether a Cleric can be their source and passed him at the seventeen he can; the partition is
  `docs/reports/IL.md` §1, and the 87 left are another class's, an enemy's, a companion's, no actor's,
  dormant, or kept apart by DI's rule (`check_il` §1a).**
  **Do not quote coverage without re-deriving it** — `check_di` §1 walks the file and PRINTS the
  live count on every battery run. **DP MOVED THE DENOMINATOR AND NOT THE NUMERATOR**: the
  re-pointed Spread of Madness deleted `_apply_status(infected, "psychosis", 3)`, an UNSTAMPED
  site, so coverage improved without a single `src` being added. **`check_di`'s `CALL_SITES`
  equality caught it and that is what the equality is for** — a tripwire saying the ground has
  moved, where its sibling `SRC_FLOOR` is deliberately a ratchet because that one measures
  progress. **IT CAUGHT DR TOO, AND DR PREDICTED IT**: `CALL_SITES` went to **205** and
  `with_src` stayed at 106, so the unstamped remainder went to **99**. Net +2 — the retired card's
  STAMPED `chilled` application went with it, and three arrived (Wheeling Cut's two grants, which
  are hero self-buffs and correctly unstamped, and Counter Time's Stun, which passes its
  `attacker` and exactly replaces the stamped site the retirement took). **The reason is in the
  gate's own comment, which is what that const's header demands of a batch that moves it.**
- **`_companion_hit` READS 5 OF THE HERO STRIKE LOOP'S MULTIPLIER TERMS, AND THE TWO IT GAINED AT
  DU WERE THE ONLY TWO THAT WERE LIVE.** The attacker-side block is the run of `raw`-mutation sites
  in `battle.gd`'s `_resolve`; the five it reads are **Mark of the Hunt, the ownerless Hunter's
  Mark, Necrosis, `cripple` and `chilled` (both terms)**. **MOST OF THE REMAINING MISSES ARE
  UNREACHABLE BY SHAPE RATHER THAN BY OVERSIGHT, AND THE SHAPE IS IN THE SIGNATURE**: the function
  takes a FLOAT, not an `Ability`, so all 26 ability-keyed terms cannot apply; a companion's
  `engines` is empty — its `passive_id` was `""` until GK — (10 more) and **every talent-rank field on it is zero, always** (20 more).
  **Of the 76 still absent, all 76 fail the brief's own test — a term no companion can receive is a
  non-issue.**
  - **THE TWO THAT WERE LIVE ARE FIXED AND MEASURED.** **`cripple`** — enemies target
    `_hero_side()`, which holds the living companion, and `_apply_status` lands the rider with no
    companion filter; **two enemy abilities carry it** (Ride-by Slash, Grasping Roots). **40 seeded
    blows: 30268 in both arms before, ratio 1.0000; 30268 against 22703 after, ratio 0.7501.** And
    **`chilled`** — the frost modifier stamps a summoned companion deliberately and its branch
    carries no `inherited` guard. **Both terms read; all four arms land exactly** (1.0000 / 0.8500 /
    0.9700 / 0.7735).
  - **ONE STACK IS THE CEILING AND THE `>= 3` ARM IS UNREACHABLE IN PLAY.** The frost stamp is the
    only application that reaches a companion; every other one in the file targets an enemy. **The
    stack count was NOT raised to make the arm reachable** — that would be authoring. `check_du` §3
    asserts the stamp lands 1, so the day the ceiling moves the gate says this line is stale.
  - **`cripple` AND `chilled` ARE INSTRUMENTED NOW, WHICH THEY WERE NOT.** `check_du` §1 and §2
    measure the ratios every battery run beside `check_dk` §4's `empower` and `check_dm` §2's
    `wrath` and `battle_shout`. **Before DU, removing either read would have been silent.**
  - **AND ONE IS STILL INERT TWICE OVER, DELIBERATELY.** `type_dmg_bonus` CAN reach a companion —
    the kindling modifier writes `{"fire": 0.25}` onto one, measured — but **a companion's blow
    carries no `dmg_type` at all**, so adding the read would find nothing to apply. `check_du` §4
    drives a stamped companion through forty blows and requires the total unchanged, so the day a
    companion's blow grows a type the gate says the second reason is gone. **`dmg_bonus` cannot
    reach one**: the summon copies Attack, armour, speed, crit and `companion_power` off the hunter
    and not that, measured at 0.000.
  - **NOTHING FURTHER WAS WIDENED AND THAT IS THE RULING, NOT AN OMISSION.** `CLAUDE.md` carries the
    line: **a player effect that lands and pays nothing costs the player a card; an ENEMY effect
    that lands and pays nothing costs the player nothing.** The first is a dead card, the second is
    an exploit — and **a general widening would hang visible chips on a companion that change
    nothing, which is worse than the narrow miss because it reads as working.**
- **WE DO NOT BREAK AND HEAL MORE WHEN LOW ARE RECEIVABLE AND ARE NOT RECEIVED**, because both are
  stamped once in the party-spawn block before any companion exists. **Measured: a beast wearing
  `devotion` at 20 banks 32 Break from a 40-BD blow.** Reaching a beast summoned later wants a
  **re-stamp on summon** — a second write site for one node's worth of effect.
- **NO SIM HAS RUN SINCE THE FIVE WIDENINGS, SO EVERY CARRIED SIM FIGURE IN THIS FILE IS STALE.**
  Sanctuary, Hold the Line, Rally and the Field Medic (DK) and Rallying Shout's Pressure clause
  (DL) all reach a fifth body in a Beastmaster party. **THE HEALING AND BREAK FIGURES AT THE FOOT
  OF THIS FILE ARE MARKED STALE RATHER THAN LEFT TO BE QUOTED AS CURRENT.** They are DA's, they
  predate DK and DL, and **correcting them means running the sim, which no batch since has done.**
  **DM moves no magnitude and adds nothing to that staleness.**
- **`FIREDRAW_TAKE` (4) IS DEAD, AND WAS DEAD BEFORE DH.** `firedraw` uses
  `FIREDRAW_TAKE_PERFECT` (6) unconditionally. **DH deliberately did not collapse it** — that would
  move a magnitude — but it is a real dead symbol that `test_batch_cd`'s sweep does not catch.
- **`shared_grief`'s SOURCE COMMENT SAYS THE CARD PAYS "EXACTLY 3" AND `sg_grant` IS 4.**
  Pre-existing stale prose. One line.
- **DZ'S COPIED-HELPER ITEM IS HALF-CLOSED AT FI, AND THE OTHER HALF IS A ONE-BATCH JOB.**
  **The `_had_save` SAVE-BACKUP half no longer exists anywhere** — it came out of all 41 files that
  carried it, because `Run.save_path` is redirected for the whole process and because the restore
  itself was a destruction path (`FileAccess.open(..., WRITE)` TRUNCATES before `store_buffer`).
  **The `Profile.save_path` half is untouched and still owed**: `_run` is 39 bodies in 39 suites and
  is correctly 39 — each suite's own driver — and **all but `test_runes` swap `Profile.save_path`
  to a per-suite file, 33 of them swapping it back**; `bn`, `bo`, `bp`, `bq` and `br` do not.
  (FI corrected this row: it read 38, and the brief that quoted it read 37.) **The same `_init()`
  mechanism would close it in about six lines of `profile.gd`** — deliberately not done at FI,
  because **seven battery suites do not swap it at all** and would newly get a scratch profile
  instead of the designer's, which is a behaviour change to seven suites and belongs to its own
  batch.
- **`CLAUDE.md` IS PRUNED AT DZ §3 AND CW's TARGET IS MET ON BOTH HALVES FOR THE FIRST TIME.**
  CW set *"under 3% of the knowledge sync and roughly flat over time"*; the ratio had risen every
  batch from 3.25% at DI to **3.639%** at DY, and **DG through DY all declined the prune.** It is
  taken. **The live figures are printed by `check_fg` §2 every battery and are not restated here.**
  **THE ARITHMETIC OF THE TARGET IS NOT THE OBVIOUS ONE AND IS WORTH KEEPING**: pruning this file
  shrinks the sync's DENOMINATOR too, so clearing 3% needed **more than 47.8 KiB**, not the 46.4
  a naive subtraction gives. **AND THE PRUNE IS BOUNDED BY ASSERTIONS RATHER THAN BY JUDGEMENT** —
  **60 literals must survive verbatim** across the **26 targets that actually read the file** (9
  gates and 17 suites — a grep for the filename over-reports that population by two thirds, because
  18 more name it only in a comment), several of which read as history because a suite reads them. **THE BATCH-CODE PINS ARE CLOSED AT
  EA §2 AND THERE WERE SIX, NOT THREE** — the four bare ones (`BATCH BN`, `BATCH BS`, `BATCH CE`
  and `BATCH CG`, the fourth DZ predicted, one line under the third) plus two whose LITERAL merely
  carried a code. **All six re-pointed at the rule each was reaching for; none deleted.**
  `check_ea` §3 sweeps for a seventh every run, by the VARIABLE holding the document.
- **TEN HAND-BUILT BATTLE BOARDS REMAIN, IN SIX FILES** — `al` (2), `an`, `ax`, `bl`,
  `test_rune_battle` (3), `test_run_harness` (2). **None is a copied helper.** `check_da` §3
  carries them as a **named ratchet** (by file AND by count), so a new copy cannot hide among them.

### Carried, and still awaiting a ruling

- **~~WHETHER THE ZONE-BOSS FALLBACK NEEDS A THIRD TIER~~ — RAISED BY EG, RULED AND BUILT AT
  EH §1.** Closed. The chain is boss pool → spec draft pool → class-wide draft pool; the
  loadout-bound floor runs 8–13 where it ran 2–6. **What is NOT closed, and is stated here so
  nobody reads this line as a guarantee: under a fully-held POOL the chain still floors at zero**,
  and that is a design decision nobody has taken rather than an oversight. Full working in
  `docs/reports/EH.md` §1.
- **WHAT A CEILING SHOULD BE FOR EACH HALF — `CLAUDE.md`'s HALF RULED AT FU §1 (340 KiB); THE
  REFERENCE HALF STILL RULED ON NOWHERE.** EE's 290 KiB was derived for one file and its FLOOR term
  held both halves. **FU re-derived `CLAUDE.md`'s own ceiling by EE's method off FF's post-split
  reading (261.03 + ten × EZ's 8.10 = 342.03, stated as 340)**, which is the per-half move for that
  file. `docs/instrument-rules.md` has no stated ceiling and deriving one is still the designer's.
  - **BOTH OF EF'S NUMBERS ARE NOW STALE IN OPPOSITE DIRECTIONS, WHICH IS WHY THIS ITEM MATTERS
    MORE THAN IT DID.** EF's **220 KiB for `CLAUDE.md` is BELOW the live file** and always
    would have been within four batches at the measured rate — it was derived off a +6.30 KiB worst
    batch when the file was 175 KiB. EF's **95 KiB for the reference is now below it**, and
    it was derived off a +5.00 KiB worst batch (DX) that was itself building that
    file. **Neither number should be adopted as written; the METHOD is what survives.**
  - **AND FF MEASURED THAT THE ALTERNATIVE — ANOTHER SPLIT — IS GONE.** Three quarters of
    `CLAUDE.md` is rule about what the game may contain, held here by EF's one-way tiebreak, and
    the residue is spent. **FF named two moves and FU took the first; at 340 the one left is to
    overturn the tiebreak for a SUBJECT** — see the subject-seam item above — and accept that a batch
    may have to open two files to find a rule about the game. Working: `docs/reports/FF.md` §1 and
    `docs/reports/FU.md` §1, and the ceiling block in `CLAUDE.md` says so. **GR TOOK IT**, on the designer's
    ruling: combat law is `docs/combat-rules.md`, a THIRD rule file, and like the instrument reference it has no
    stated ceiling (GR's ruling 1).



### Carried, with measurements attached

- **THE FRENZY RATE IS `FRENZY_RAGE_PER_STEP` = 5** and is a rule rather than a constant (five Rage
  is 5% of a full bar, the health term's own rate). Peak Frenzy 13.4 → 20.9 of 40 at rung 2 under
  CZ, and **DA re-measured it unchanged at 20.7**. **Reckless Abandon dumping a full bar books all
  twenty steps at once** — named, not discovered later.
- **THE FAITH LANE IS SETTLED, THE SUITES AGREE WITH IT, AND AS OF DG THE PROSE DOES TOO.**
  Numbers in `docs/reports/DA.md`: threshold 3, builders 2 and 1, releases **1.93 / 2.60 / 2.48 /
  3.62** across the four arms. **Elevation (2 of 3) and Blessing of the Faithful (3 of 3) were
  reported at both CZ and DA and deliberately changed at neither.** If either is revisited,
  Elevation is the one with a history of being moved by accident (CG set 2, CN's fold pushed 3, CQ
  reverted it).
  - **THE DERIVED BAND IS WHAT THE FAITH SUITES ASSERT ON SINCE DC:** the deepest an ally can
    **HOLD is 7** since HL §3 (`FAITH_RELEASE - 1`; 2 at three); **Communion's eligible band is 1–7** (the walk skips
    `faith_stacks >= FAITH_RELEASE`) and its roll `0.01 * 15 * stacks` **tops out at 105% — a certainty — on a node
    nothing writes** (`test_batch_be` §6 asserts the dormancy and prints the top; the suites measure 30% at two);
    **four absorbs are a release** (two at three). **DC gave five suites `const RELEASE := 3` and
    `const HELD_MAX := RELEASE - 1`; DF added the same two to `bu` and `ce`**, and HL moved all seven to 8 — one line
    each; `aw`, `ay` and `bc`, which only DRIVE a release, read the threshold off `battle.gd` since HL.
  - **AND WHEN A BATCH REVERTS A CONSTANT, SWEEP THE PROSE FOR THE NUMBER IT REVERTED — INCLUDING
    THE ABILITY'S OWN CARD.** DA reverted TWO constants in one batch. DC swept the ABSORB one and
    fixed both its surfaces (the `passive_desc` and the `faith` chip); **the GROUND DRIP's card was
    the surface nobody swept, and it stood wrong from DA to DG.** **When a batch reverts two
    constants at once, sweep them as two sweeps** — the one with fewer surfaces looks finished
    because the other one was. **Grep the NUMBER, not the field**: a card says "2 Faith" and never
    says `FAITH_PER_GROUND_TURN`.
### Named by the designer, carried from CX

- **Enemy interference as a status.** Not yet specified.
- **RELICS PER-HERO — RULED, SCOPED, AND NOT STARTED.** The ruling stands (a relic is assigned to
  one hero at pickup); CX reported the scope and stopped. **VERIFIED AT EN: NOT ONE LINE OF IT
  LANDED**, and neither `master.html` nor the code was wrong about the other — they agree, and what
  was missing is that the ruling points elsewhere and is unbuilt, which `master.html` now says.
  **It is a SAVE-FORMAT change: the run save would go v12 → v13** (this block recorded v10 → v11,
  written when the save was v10; CT took it to v11 and EG to v12).** `Run.active_relics` is a flat `Array` read back as a hard key
  (`data["active_relics"]`, no default), so every existing save breaks without a migration. It
  also touches **25 read sites** (`battle.gd` 12, `run_state.gd` 8, `run_sim.gd` 4,
  `shop_screen.gd` 1), the two aggregators (`Relics.hook_add` / `hook_dict`), the two accessors
  (`Run.relic_add` / `relic_dict`) — **all four change signature** — both acquisition sites, and
  **13 of the 25 relic descriptions**, which are worded party-wide. **It can be split; it should
  not be started casually.**
  - **FOUR HOOKS NEED A RULING BEFORE ANY OF IT.** Party-wide by nature and staying that way:
    `start_items`, `start_gold`, `gold_find_mult`, `shop_discount`, `loot_extra`, `victory_gold`.
    Per-hero already: the battle-spawn hooks. **Genuinely ambiguous:**
    `victory_heal_pct` (Chalice of Dawn, Cracked Hourglass, Martyr's Knucklebone),
    `victory_mana_pct` (Cracked Hourglass), `rest_heal_add` (Cairnmoss Poultice, Martyr's
    Knucklebone), and `resource_floor_pct` (Bottled Storm).
  - **The draft assigns relics BEFORE specs are chosen**, which is the point at which "which hero
    gambles" has the least information behind it. Worth deciding whether assignment moves.
- **Rune content.** The rune economy is measured and the system is built; the content pass has
  not been authored. **AND THE CHARTER DECISION COMES FIRST — see the RUNE CHARTER block above.**
- **The enemy debuffs whose duration exceeds their own cooldown.** Reported by the fold census.
- **The design review.**
- **Browser playtesting with friends.**

### Carried from the code, reported and deliberately not fixed

- **THE "a held rune for two of lower rarity" EVENT NEEDS RE-SPECIFYING NOW, NOT JUST BUILDING
  (ES §1).** It was already blocked on a surrender path that has never existed (the pouch only
  grows). **With no tiers there is no "lower rarity" to trade down to**, so
  the idea needs a new statement before it can be costed. `master.html` and `events.gd` both say so.
- **THE `scarred_runes` GLOSSARY ENTRY KEEPS ITS `id` AND NO LONGER MATCHES IT (ES §3).** It is
  rewritten as *"Runes That Charge"* and teaches the mechanic rather than the retired name; the `id`
  is kept so the runes entry's `see_also` edge still resolves. **Nothing outside `glossary.json`
  names that id** — checked. Renaming the id is a one-line change in two places and is cosmetic.


- **THE RUN REPORT'S SHOP CONFOUNDER IS A VACUOUS READING THAT PRINTS LIKE A REAL ONE (EQ §6).**
  `run_sim.gd` reads `type_taken.get("shop")` / `type_offered.get("shop")` where the node
  type is `"merchant"` — the key is never written, so *"it takes 0.0 of 0.0 shops offered per run"*
  is **structurally zero**. The same report prints **4.57 merchants walked, 6.98 runes bought and
  3.44 runes acquired per hero per run** four blocks lower, off the correct key. **Its prose is
  reversed as well**: it claims every route policy *"puts combat first"* and `ROUTE_ORDER` puts
  `fight` **at or near the END**, with `blacksmith` and `merchant` first and second in two of them —
  which the comment twenty lines above says itself (*"balanced: trade nodes first"*). **This is the
  wrong-key shape recorded below arriving through a REPORT rather than through a check, and
  `docs/reports/EP.md` §3 quoted the false zero into its own table of what the bot cannot do.**
  **Repairing it is a small instrument batch; EQ did not, because fixing an instrument mid-batch
  describes an instrument that produced none of the batch's numbers.**
- **`devoted_fury` IS A READ-ONLY-ZERO FIELD WITH A LIVE READ SITE (EQ §6).** It stretches Bestial
  Wrath by a turn per Loyalty stack in `battle.gd` and **nothing writes it** — Batch DO
  re-authored `bm_devoted_fury` onto Kill Command's cost and cooldown, and `test_batch_ay`
  asserts the counter absent. **Same family as `icy_resolve_ranks` above.** Deleting a read site is
  a mechanic deletion and is not proposed.

- **SEVEN TARGETS STILL CANNOT REPORT A CHECK COUNT, AND IT IS A RATCHET RATHER THAN A SENTENCE.**
  `check_flow`, `check_map`, `check_cl_resolver`, `check_cl_width`, `check_cm`, `check_cn` and
  `check_map_screen` read `checks=none`. **`check_parse` LEFT THE SET AT EI**, and its number is its
  COVERAGE rather than an assertion tally — pinned with the floor asserted, because a
  failure total reads zero whether that gate walks every file or 41. **Two of them —
  `check_cl_width` and `check_map_screen` — report `fails=none` as well**.
  **A count that reads `?` is the one thing a count-diffing rule cannot compare.** DE
  records that state as `null` in `baselines.json` and asserts the SET in both directions: **a
  target that LOSES its count is an error, and one that GAINS a count is a notice telling the next
  batch to record the number.** `check_map_screen`'s whole verdict is the single line
  `check_map_screen: OK`, so that line is pinned as its `expect` field.
- **`_recast_refusal_note` SAYS "FROZEN" WHERE THE NAMEPLATE SAYS "HELD".** The refusal on a held
  enemy reads *"Frozen already stands at full strength"*; Batch AS §4 renamed that chip to **HELD**
  deliberately. **The note is accurate and the vocabulary is inconsistent.** One string, and it is
  the designer's call.
- **`check_cu` AND `check_cv` ARE NOT IN `run_battery.sh`'s `GATES` ARRAY.** They are audit REPORTS
  rather than pass/fail gates, so what a failure means there is a decision rather than a detail.
- **THE CODE IDENTIFIERS STILL READING "beast", AND THE PROSE PASS IS NOW FINISHED.** DG closed the
  last prose site (`data/glossary.json`'s hero/ally entry). **The FIELDS were deliberately not
  renamed** — a missed rename in prose is a typo, a missed rename in a field is a bug, so the two
  want separate passes with separate tests. **`beastmaster` / `Beastmaster` / `BEASTMASTER` are
  NOT on the list and must not be renamed.** Live identifiers: `unit.gd` `beasts`,
  `beast_committed`, `no_beast_left`, `no_beast_left_loyalty`; `battle.gd` `_beasts`,
  `_free_beast`, `_on_beast_death`, `_beast_cap`; battle
  locals `bot_beasts`, `cw_beasts`, `kc_beasts`, `sb_beast`, `sb_beasts`, `tm_beasts`.
- **THE BASE-KIT CHECK IS DONE AS OF DQ AND THIS LINE RECORDS THE RESULT RATHER THAN THE DEBT.**
  All twelve spec pools were compared against their protected core kits. **No draft card shares a
  NAME or a `special` id with any core ability** — asserted, not assumed. **The overlaps are all at
  the behaviour level**, and the sharpest is **Killing Frost against Blizzard**: the drafted card is
  cheaper, faster, shorter on cooldown, higher in damage, lays a flat 2 Chilled against Blizzard's
  1–2 roll, and is gated in `_ability_usable` where Blizzard is not. **Mind Flay against Hex of
  Ruin**, **Rampage against Hack and Slash**, **Divine Plea against Heal**, **Cinderfall against
  Wildfire** and **Arcane Bolt / Unmaking against Death Ray** are the rest. **Reported in
  `docs/draft-audit.html` §6, ruled on nowhere.**
- **~~Two specs still take the generic talent fallback~~ — MOOT AT FX (GB §4 census):** no node of the one
  tree grants an ability, so none can collide and take the fallback.
- **`docs/text-audit.html` holds findings that have been ruled on and applied.** Once the designer
  confirms, it can leave the knowledge sync. **`docs/talent-audit.html` CANNOT: DN's §8 is an open
  question, not a closed one**, and the file went 37 → 165 KiB carrying it. **`docs/draft-audit.html`
  is NEW at DQ and cannot leave either** — every finding in it is open.

---

## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND

*Re-derive these before quoting them in a brief; they move.*

- **THE TEMPO LADDER HAS THREE RUNGS AND EACH IS WRITTEN AGAINST THE ONE ABOVE.**
  `Ability.BASIC_DELAY` = **2.0** (the one authored copy in the project; `battle.BASIC_DELAY` is an
  alias) → `Ability.BUFF_DELAY_CAP` = `BASIC_DELAY * 0.5` = **1.0** → `Ability.DELAY_FLOOR` =
  `BUFF_DELAY_CAP * 0.5` = **0.5**, the cheapest an ability UPGRADE can buy.
- **THE CAP BINDS 61 ABILITIES IN TWO POPULATIONS.** `Ability.PURE_BUFFS` holds **55** specials
  (DS added `bear_brunt`, `dug_in`, `thick_hide`) and `Ability.SHIELD_SPECIALS` holds **6**.
  **BRING IT DOWN IS A PURE BUFF BY SHAPE AND IS DELIBERATELY NOT A MEMBER** — it is the strongest
  of DS's six, a party-wide amp scaling off an uncapped meter, and is priced at initiative 2.0 for
  that on PREPARATION's precedent; membership would have clamped it to 1.0 as a side effect.
  **AND A PURE BUFF ADVERTISES NO PERFECT**: `Ability.runs_skill_check()` gives it no bar and
  `test_batch_bo` §5 asserts the biconditional, which is what four of DS's six tripped on before
  losing theirs. SALVE kept its by joining `HEAL_SPECIALS` — its heal rides a status it applies,
  which is RENEWAL's shape. **`Ability.takes_delay_cap()` is the one function that
  unions them** and `Ability.make()` applies the clamp.
- **THE ABILITY CORPUS IS 231 AT IF's CLOSE** (`Classes.ability_corpus()`, probed at IF §2; Smoulder the latest) — **228 at GN, whose
  Magic Burst was the one card added; it grew past that without this line moving, which is HY's count rule's reason.** `ability_corpus()` walks
  `Classes.class_kit` beside the class pools, and the five cards that moved into the kits are reached
  there. **DY did not move it** — seven names reached it through `class_pool()` and no other route;
  re-homing them before deleting the container is why it read 227 on both sides of DY. **`Classes.vault_ability()` HOLDS TEN DEFINITIONS** and every
  one of them is now named by a live pool.
- **AND THE TWO WALKS DELIBERATELY DO NOT AGREE.** DR moved it
  net +1 (one card retired, two authored), **DS moved it +6, and DU §4 moved it +4 WITHOUT
  AUTHORING ANYTHING** — `apply_kit_overrides` built FOUR SPECS' `abilities[0]` at spawn until GS §1 deleted it (**THREE Mage and ONE CLERIC — DV §5 corrected DU's "four Mage specs"; Shadowrend is the OCCULTIST's and overrides Smite out of `kit("cleric")`, so TWO class kits were misread, not one**)
  and none of them sits in any pool, so the walk read `kit("mage")` and carried the **unoverridden
  Magic Bolt, which is nobody's live basic attack.** The walk applies the overrides now. The Batch
  CL enumeration reached **211** for as long as talents granted abilities (and `test_batch_cp`'s
  copy of it **returned 207**, because four class basics it names do not resolve through
  `pool_ability` — DW §1); the five it missed —
  Backdraft, Pyroblast, Glacial Prison, Cryoclasm, Intercession — were talent grants living in no
  pool. **DO put all twenty-two into `SPEC_DRAFT_POOLS`, which the CL walk reads, so it reaches all
  of those and `Classes.talent_granted_names()` is EMPTY.**
  **`check_cz` §0 ASSERTS A SET IDENTITY NOW RATHER THAN AN EQUALITY, WHICH IS NOT A LOOSENING**:
  the names the complete walk reaches and the CL walk cannot must be **exactly** the overridden
  basics and the class-kit cards no pool or lineage holds (six since GN), **derived off
  `apply_kit_overrides` and `CLASS_KITS` themselves** so a fifth override or a new kit card is
  covered by doing nothing. **Since GS §1 the override half is EMPTY and asserted so**: the four basics
  are on their shelves, which the CL walk reads, and the difference is the six class-kit cards alone. **The control's job is intact** — an ability falling outside every kit and pool would be
  in NEITHER walk and cannot hide inside the difference. **`check_da` §3 asserts that no gate
  hand-rolls the walk**, with `check_cz`'s `_cl_only_corpus` named as the one deliberate exemption
  (its REASON string has now been corrected twice, at DO and at DU, for the same reason both times:
  the exemption stood while the sentence explaining it went stale).
- **`RECAST_GATED` HOLDS 64 ABILITIES** — DS added four (Bear the Brunt, Dug In, Thick Hide,
  Salve), each of them entirely a status on the caster. **BRING IT DOWN DELIBERATELY DID NOT
  JOIN**: its number is snapshot off the deepest bond's Loyalty, which is uncapped, so a recast on
  a deeper bond genuinely buys a bigger amp and can never do nothing. **HEADS DOWN is not in the
  system at all**, because it deals damage. DR's COUNTER TIME joined for the same reason the four
  did.
- **AND A PROPOSAL MUST EQUAL WHAT A *GOOD* CAST WRITES, WHICH DS LEARNED FROM A RED.**
  `check_co` saturates by casting at grade `"good"`, so a `_recast_writes` entry proposing the
  PERFECT's duration improves on what is standing every time and the card never refuses. Salve did
  exactly that on the first run. `emberkeep` is not a counter-example — its handler writes
  `EMBERKEEP_TURNS + 1` unconditionally. **A `special` carrying a POWER needs its own arm rather
  than a `RECAST_SELF_PLAIN` row**, because that table writes `power: 0`.
  **WHEELING CUT DELIBERATELY DID NOT JOIN**: it deals real AoE damage and Break, so a recast is
  never wasted, which is why no damaging card is in that list. `check_co` refuses all but
  Interpose after saturation;
  Interpose is additive and correctly never refuses. **Glacial Prison's membership is the
  reason its name appears in THREE tables in `battle.gd`** — `_recast_targets`, `_recast_writes`
  and the effect handler, DA §2's "three edits and no fourth". `test_batch_as` pins the count at 3.
- **BLOOD FRENZY: TWO TERMS, ONE BAND.** `BattleUnit.FRENZY_MAX_STEPS` = **20** and
  `FRENZY_RAGE_PER_STEP` = **5**. Steps are summed then clamped.
- **FAITH: `battle.FAITH_RELEASE` = 8 (HL §3, ruled; 3 from CZ)**, **`FAITH_PER_ABSORB` = 2**, **`FAITH_PER_GROUND_TURN` = 1.**
  `JUBILEE_MIN_FAITH` is **3**, which was the whole bar and is three eighths of it since HL. `ELEVATION_STACKS` is **2**,
  which is **25% of a release** (67% at three). **An absorbed hit pays LESS than a release costs, and `check_da` asserts that
  RELATIONSHIP.** **`_gain_faith` doubles under `zeal` and under nothing
  else** — not Fervor, not Apostle. **ALL NINE PLACES THAT SPEAK EITHER MAGNITUDE NOW AGREE**, as
  of DG §1: the two cards, the `passive_desc`, the `faith` chip, the glossary, two `master.html`
  sites and two source comments.
- **The ability draft is COMPLETE at 179 of 179** — `SPEC_DRAFT_POOLS` is **159** and
  `CLASS_DRAFT_POOLS` is **20**, counted out of `classes.gd` (**154 and 25 until GN moved five
  class-wide cards into the class kits; 129 and 20 until GS §1 put the 29 cards that stopped travelling on their
  lineages' shelves; 158 until HB put Tripwire on the Survivalist's; 159 until HL §1 took Guard Change off the
  Swordmaster's to travel with the Stances; 158 until IF §2 put Smoulder on the Pyromancer's**). **NEITHER HALF IS A FLAT MULTIPLE ANY
  MORE.** DO's twenty-two took nine spec pools past eight, DR moved two of those nine (Swordmaster to
  TWELVE, Cryomancer down to ELEVEN), DS took the last three at eight to TEN, and **DY took the
  Warden to TEN, the Arcanist to TWELVE and the Devout to ELEVEN**. **THE SHALLOWEST SPEC POOL IN THE
  GAME WAS TEN FROM DY TO GS** — the Warden's nine was the floor from DS to DY — **and is ELEVEN since GS §1** (the
  Warden and the Survivalist until HB, the Warden alone since; the Pyromancer and the Arcanist are the deepest at
  sixteen).
  **AND THE CLASS HALF STOPPED BEING 4 × 6 AT DY, AND GN THINNED IT: the Warrior and Hunter pools draw
  six, the MAGE's FIVE and the CLERIC's THREE**, so `CLASS_TARGET` is a summed table (`test_batch_cd.PER_CLASS_DEPTH`) exactly as
  `SPEC_TARGET` has been since DO. **Do not write `12 * 8` or `4 * 6` again.**
  The asserted FLOORS are **8** (spec) and **3** (class — six until GN); they stay
  there because they catch a pool that EMPTIES rather than tracking the deepening.
  **The one authoritative tables are `test_batch_cd.PER_SPEC_DEPTH` and `PER_CLASS_DEPTH`; every
  other suite asserts a FLOOR and the TOTAL.**
- **Ability slots are a LADDER: `ABILITY_SLOTS_BY_BOSS` = [7, 8, 9, 10]**, one rung per zone boss
  cleared, read through `Run.ability_slot_cap()` and never off a constant. **A hero's opening is
  `Classes.lineage_slots(spec)` (GK: the lineage's slots less its engine's enablers) plus
  `Classes.kit_slots(class, spec, engines)` (GN: the class kit less what the lineage already counts; HB: and less the
  pet where an engine held dismisses it)**, and
  `Run.ability_slots_used` adds the carried half. **Since GS §1 every hero opens at 3** — the class kit — because a
  lineage opens with its enablers alone and an enabler sits outside the count, so every hero has four slots to draft
  into at the first rung — **and since HB a Sharpshooter opens at 2**, Lethal Aim dismissing the kit's Summon
  Companion, so he has five. (GN to GS: Berserker 5, Warden 4, Swordmaster 5, Pyromancer 5, Cryomancer 5, Arcanist 6,
  Holy 5, Devout 4, Occultist 5, Beastmaster 5, Sharpshooter 5, Survivalist 4, and a spine-taker 3.) **`protected_names` is a NAME count and
  counts the kit too** (four to seven a spec since GS); `core_slots` is the lineage's SLOT count before its
  enablers come out, and `lineage_slots` is built from it — equal since GS, so zero. **`check_ea` §1 priced a
  hero's earnable slots as `cap - core_slots` until GS**, which no opening had read since GK; it reads the
  opening `Run.ability_slots_used` counts now (`lineage_slots` + `kit_slots`).
- **The pouch: 4 → 5 → 6 slots by zone** (`ITEM_SLOTS_BY_ZONE`), a slot holding one item TYPE and
  its whole stack. **Default per-type stack cap `ITEM_CAP` = 6**, with three exceptions
  (`ITEM_STACK_CAPS`): Cleansing Draught **4**, Cursed Visage **2**, Resonating Hourglass **2**.
  Sale returns `SELL_FRACTION` = **0.4** of listed price.
- **The skill check's default profile** — `battle.SC_PROFILE_DEFAULT`: `perfect_half` **0.045**,
  `good_half` **0.16**, `centre` **0.5**, `sweep_time` **1.00** (EY; it was 0.72), `presses` **1**,
  `press_taper` **1.0**. Perfect window **90.0 ms**, Good window **320.0 ms**. **Every caller uses
  it except the Sharpshooter's basic attack — which RESTATES `sweep_time` (a flat 0.52 s) and
  INHERITS both half-widths through it**, so a change to the base sweep reaches him as tolerance
  and not as pace: his Perfect window is **76.5 ms**, still ×0.85 of the default's.
  **`check_cn.gd`'s `WANT_PROFILE` pins all six by number — moving one here is two edits.**
- **Save versions: the run save is v15** (a pre-**v10** save is REFUSED and cleared — the version
  and the threshold are different numbers). **v11 (CT), v12 (EG), v13 (GF), v14 (HK) and v15 (HR) are all
  TOLERANT and none moved the threshold; GH, IA and IB moved no version.** A save from a NEWER build is refused and kept (HL §5).
  **THE ASYMMETRY, FINDABLE (IB §0.2, ruled — not a defect, not refused)**: an IA save opened in HZ's build reads *3 of 2 slots
  filled*, seats three engines, refuses a fourth, and round-trips whole — a bump is for a key an older build writes away, never a
  value it reads generously (`CLAUDE.md`'s VERSIONS bullet). IB's pick order rides the members, which an older build keeps. Talent cells cost 1/2/3 by tier — **27 cells = 54
  points a class.**
- **Relics: 25 in the pool** — 17 common, 8 rare. **Up to 3 are assigned per run**, party-wide —
  **confirmed at EN as the code's behaviour, not just this file's memory of it.** The per-hero
  ruling stands and is unbuilt. **`CLAUDE.md` now carries the division of labour:** every relic
  hook is read at run start, battle SPAWN, the victory screen, gold awards, shop prices or elite
  spoils — **not one while a turn resolves** — so a relic sets up the RUN and a talent changes what
  a SPEC does in a fight. Its rest-node hook is read nowhere; that is queued above.

### THE TEST TREE, AS OF EF

- **47 `test_*.gd` files**: 44 `test_batch_*` spanning `ah` to `cp` (with gaps — they are NOT one
  per batch), plus `test_run_harness`, `test_runes` and `test_rune_battle`. **They live at the repo
  ROOT, not in `scripts/`.**
- **`_spawn` IS AUTHORED ONCE, IN `suite_fixture.gd`, AND 37 SUITES GO THROUGH IT.** `_kill` too, in
  14. Each suite keeps its OWN `_spawn` SIGNATURE and delegates, so **every call site is
  untouched.**
- **`run_battery.sh` RUNS 46 SUITES AND MISSES NONE.** The `GATES` array's size is
  **COUNTED OUT OF THE SCRIPT ITSELF RATHER THAN CARRIED FORWARD: it read "thirty-six" through ES,
  ET, EU and EV, which is the shape `CLAUDE.md`'s own rule warns about (a number quoted from one
  document into another stops being a measurement).**
  **EV ADDED `check_ev` BECAUSE THE FALLBACK'S TWO FAILURE MODES ARE INVISIBLE IN THE SOURCE**: a
  fallback that never fires and one that fires for every converted stack would BOTH pass a static
  check, and they are simply the two ways one line of arithmetic goes off by one. Every section is
  live; §0 drives the disjointness invariant over 240 readings; §1 pins Loyalty 9 by name because it
  is the one depth where a converted stack still buys the clamp; §3 asserts the OPPOSITE of
  `check_eu` §1c with the same instrument at a saturated depth. **Seven negative controls, all seven
  bit**, the first of them HEAD's own `battle.gd`.
  Before it, **ES ADDED `check_es` BECAUSE THAT BATCH CARRIES FOUR RULINGS AND THREE OF THEM DECAY SILENTLY.**
  §1 is the one a source sweep cannot reach: a re-invented tier is a new table and a new roll, and
  the OFFER DISTRIBUTION is the only place it shows, so it is MEASURED at three zone slots —
  against a 4.5-point band until FG — where the old weights spread it by 29.
  §3 is the dangerous one: with the `scarred`
  flag gone, `Runes.is_cost` is the only thing that knows a rune charges anything and it is what the
  power arm holds a cost by, so the costed population is derived and pinned as a NAMED SET with
  `exsanguination` named as the one whose cost is a behaviour rather than a term. §4 is DS's Heads
  Down shape outright and is DRIVEN through the real equip/unequip doors. **§2 DELIBERATELY ENCODED
  NO RULING** while the five universals' classes were unmade; **ET §1 retired the five and
  RE-POINTED §2 onto a wider question** — every entry a spec cannot draw must be undrawable BECAUSE
  IT IS RETIRED, over every rune rather than the five — so a retirement wearing an eligibility rule
  still goes red, and the depth table it prints now reads zero across all twelve. Before it,
  **EM ADDED `check_em` BECAUSE EJ §5 NAMED THIS BATCH AS ITS HOME**: *the property a future gate
  wants — that no rune writes a live node's counter — belongs in the batch that takes the charter.*
  §1 derives that property from `Talents.tree()` and `runes.json` rather than from a list of names,
  and its unit-math exemptions are an EQUALITY. **§2 is the one that earns the gate**: splitting a
  counter is safe in the arithmetic and lethal in the GUARD, so it sweeps STATEMENTS and fails if
  any statement reads one half without the other. §3 holds the AA type trap on the `rune_` side; §4
  pinned the three clauses with no home as an EQUALITY until EN.
  **Five negative controls, all five bit.**
  **EL ADDED `check_el` BECAUSE THAT BATCH CARRIES THREE RULINGS**: that MARK's population is
  DERIVED from the marks the game itself names rather than listed, that `master.html` §6c's tag
  table is the code's table, and that the widest tag line is MEASURED rather than transcribed
  (DJ §3). **The first is the one that decays silently** — the day an eleventh mark is authored,
  nothing else in the tree would notice its card going untagged — so §1 pins the STATUS half from
  outside (`DISPEL_NEVER.size()`, DW's idiom) and DERIVES the CARD half live out of
  `battle.gd`'s apply sites, through both anchors, agreeing in both directions.
  **EK ADDED `check_ek` BECAUSE THAT BATCH CARRIED TWO RULINGS**: that the vocabulary is
  MECHANICS rather than status names, and that the tags are MECHANICALLY INERT. **Inertness
  is the one property nothing else in the tree would notice losing**, so §3 asserts it as a
  POPULATION — every `.gd` swept comment-stripped, and **EL SPLIT THAT ASSERTION IN TWO** because
  it was two claims: the files in the SHIPPED GAME naming a tag are pinned by name,
  the TARGETS that check one are listed separately, and ZERO is still
  asserted separately in the six files a mechanic would have to live in.
  **EH ADDED `check_eh` BECAUSE §1 IS A RULING AND BECAUSE THE THIRD TIER CAN ONLY BE PROVED
  LIVE.** A tier that resolves correctly and announces nothing passes every static check in the
  tree, and silence is the exact defect EA existed to end. **EG ADDED `check_eg` BECAUSE §1 AND §2
  ARE BOTH RULINGS, AND BECAUSE §1 DRIVES THE THIRD
  ZONE-BOSS GRANT.** A slot ladder that never grants would pass every static check in the tree,
  which is DS's Heads Down arriving at a new mechanic.
  **EF AND EE EACH ADDED NONE, ED ADDED `check_ed`**, and before it EC added `check_ec`, EB `check_eb`, EA `check_ea`, DW
  `check_dw`, DV `check_dv` and DU `check_du`; **DZ AND DY EACH ADDED NONE.** **ED ADDED ONE BECAUSE
  §2 IS A RULING** — the manifest is the answer to the coverage question EC priced and left open,
  and a gate encodes a ruling. **§1 ADDED NOTHING, because its ruling is that nothing should
  change.** **EC ADDED ONE BECAUSE §1 IS AN
  INSTRUMENT REPAIR THAT HAS TO SURVIVE THE BATCH** — the scratchpad sweep is rebuilt every batch
  and a boundary fixed only there is a fix that expires. **§2 AND §3 ADDED NOTHING**, because both
  are measurements the brief forbids ruling on and a gate encodes a ruling. **EB ADDED ONE BECAUSE
  ITS §1 IS A RULING** — a gate
  encodes a ruling, and EB §1 is the ruling on the measurement EA handed over. **EA §3 WAS STILL A
  MEASUREMENT AND RODE IN `check_ea` PINNING A DIRECTION RATHER THAN A COUNT**, which is the
  shape that does not encode a ruling nobody made; `check_eb` §1 is the shape that does, now that
  the ruling exists. **`check_ec` IS A THIRD SHAPE: A PROPERTY OF THE INSTRUMENTS THEMSELVES**, and
  it carries its own discrimination control on synthetic input because the repair it encodes is
  dangerous in the opposite direction. **`check_dw` ASSERTS
  THE CONSEQUENCES, NOT THE SOURCE**: §1 and §2 re-derive both of `test_batch_cp`'s named
  populations LIVE and require the suite's table to equal them, because a named population is only
  useful while it is still the real one — which is what stopped being true between CN and DW. **It
  also pins `check_da`'s exemption table at ONE from outside**, so a batch adding a second has to
  move a line in another file and say why. **Seven
  `check_*.gd` files are not in `GATES`** — `check_ck_width`,
  `check_cu`, `check_cv`, `check_dn`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the four that run nowhere are `check_ck_width`, `check_cu`, `check_cv` and `check_dn`.
  **SINCE EI THOSE FOUR ARE PARSE-COVERED AND NAMED IN `check_parse`'s OUTPUT EVERY RUN** as its
  RESIDUE — in the tree, spawned by nothing, reached by nothing. They are still not in `GATES`,
  because what a failure in an audit REPORT means is a ruling rather than a detail.
- **`check_ds` NEEDS NO `check_da` §3 EXEMPTION AND IT TOOK A RED TO ESTABLISH THAT.** It calls
  neither draft-pool accessor; its **header comment named both of them** while explaining that it
  does not, and §3's fingerprint is a substring match over the whole source. **The names came out of
  the prose rather than an exemption being granted** — an exemption granted to a sentence would
  blind §3 to a real walk arriving in that file later, which is worse than the violation it covers.
  **`check_du` NEEDED NO EXEMPTION EITHER AND DID NOT TRIP §3 AT ALL**, because that lesson was
  applied rather than re-learned: it reads neither draft-pool accessor and its comments name
  neither. **`check_dv` NEEDED NONE EITHER**, for the same reason, and was run standalone before the
  battery to prove it: `check_da` reads **37/0 over 32 gates**.
  - **AND §3's BLIND SPOT IS CLOSED AT DW §1, WITH ONE MORE HOLE THAN DV DIAGNOSED.** Its walk
    sweep read **`check_*.gd` ONLY** and its fingerprint matched the two pool **ACCESSORS** where
    `test_batch_cp._corpus()` reads the **CONSTANTS** — both real. **THE THIRD WAS LARGER AND SAT
    INSIDE THE POPULATION IT ALREADY SWEPT**: the fingerprint assumed a corpus walk touches the
    DRAFT pools at all, and `check_cl_resolver._every_ability()` read only `Classes.kit()` and
    `Classes.spec_abilities()` until DW and reached **43 of 227**.
    **THREE WALKS: 43, 91 and 207.** A SECOND
    sweep runs over gates AND suites now, matching constants as well as accessors, and asks whether
    a function **RETURNS** a collection built from two or more ability-source families. **37 → 39,
    one exemption, and the old sweep is untouched.**
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND ITS ROWS ARE THE SUITES, THE GATES, THE
  SCENE RUNS AND THE HARNESS GATES**. **FF ADDED
  `check_ff` AT [55, 55] AND MOVED EXACTLY ONE OTHER ROW — `check_parse` 169 → 170 — BOTH WRITTEN
  BEFORE THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS.** **A new gate owes TWO rows**, its
  own and `check_parse`'s, because that gate's count IS its coverage and a target joining the
  battery raises it the same day. **The row count below is the historical reading and is kept for
  the reasoning attached to each move.** **ES ADDED `check_es` AT [42, 42] AND MOVED EXACTLY THREE OTHER ROWS —
  `test_runes` 3101 → 3118, `check_ek` 43 → 45 and `check_parse` 161 → 162 — ALL FOUR WRITTEN BEFORE
  THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS EACH.** **The `test_runes` +17 was COUNTED OFF
  THE DIFF rather than guessed**: `_schema` goes 472 → 585 (two absence pins and a no-prefix pin
  replace one tier check and one conditional price check, over 65 entries) and `_scarred` → `_costs`
  goes 102 → 6, called twice as before; +113 − 96 = +17. **`check_parse`'s move is that row working
  as designed** — its count IS its coverage, so a target joining the battery raises it the same day. **EM ADDED `check_em` AT [210, 210]; EN MOVED IT TO [223, 223] AND MOVED `av` AND `ax` BY ONE AND TWO. EM MOVED FIVE OTHER ROWS —
  `check_dp` 43 → 48, `check_parse` 160 → 161, `test_batch_ak` 495 → 496, `test_batch_ax`
  348 → 350 and `test_runes` 3121 → 3125 — ALL SIX WRITTEN BEFORE THE BATTERY**, three of them
  off three identical standalone readings apiece. **`check_parse` read 163 first**, and the extra
  two were scratch measurement probes sitting in the repo root that its RESIDUE walk found — the
  walk working, and they were moved out of the tree. Before it, **EL ADDED `check_el` AT [23, 23]
  AND MOVED EXACTLY TWO OTHER ROWS —
  `check_ek`, 39 → 43, and `check_parse`, 159 → 160 — ALL THREE WRITTEN BEFORE THE BATTERY OFF
  STANDALONE READINGS**, so `check_de` certified on pass one. **`check_ek`'s move is itemised in
  its own row**: §3 splits one assertion into two, §4 adds two population assertions and one more
  tag to sweep. Before it, **EK ADDED `check_ek` AT [39, 39] AND MOVED EXACTLY ONE OTHER ROW —
  `check_parse`, 158 → 159**. **The `check_parse` move is that row working
  as designed rather than drifting**: its count IS its coverage, so a target joining the battery
  raises it the same day. **EI ADDED NO ROW AND MOVED EXACTLY ONE — `check_parse`, `checks: null`
  → `[158, 158]`** — written before the battery off three identical standalone readings, so
  `check_de` certified on pass one. **THAT ROW IS A DIFFERENT KIND OF NUMBER FROM EVERY OTHER ONE
  IN THE TABLE: it is a COVERAGE count, not an assertion tally**, and it is pinned for the reason
  the batch exists — a failure total reads zero whether that gate walks 158 files or 41, which is
  how it was found short three times with nothing going red.
  **EH ADDED `check_eh` AND MOVED EXACTLY ONE OTHER ROW — `check_ea`
  62 → 86 — BOTH WRITTEN BEFORE THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS**, so
  `check_de` certifies on pass one. **EG ADDED `check_eg` AND MOVED FOUR ROWS, ALL FIVE WRITTEN BEFORE THE
  BATTERY OFF STANDALONE READINGS** — `test_batch_bo` 1131 → 1140, `test_batch_bx` 157 → 161,
  `check_ea` 60 → 62, `test_batch_bp` 275 → 276, and its own row off THREE identical readings of 68,
  so `check_de` certified on pass one. **THE `bo` DELTA WAS COUNTED OFF THE DIFF RATHER THAN
  GUESSED** — +20 `ok(` against −11, every one linear. **EF ADDED NO ROW AND MOVED EXACTLY ONE — `check_ec` 22 → 23, the fifth
  tracked document, written off three identical standalone readings BEFORE the battery so
  `check_de` certified on pass one.** **ED ADDED `check_ed` AND MOVED THREE ROWS, ALL THREE PREDICTED AND ALL
  THREE CONFIRMED STANDALONE BEFORE THE BATTERY** — `check_dr` 79 → 80, `test_batch_bm`
  1888 → 1889 and `test_batch_bs` 266 → 267, one locator guard each. **Its own row was written off
  three identical standalone readings of 18**, so `check_de` certified on pass one and reported
  **ZERO NOTICES**. **EB ADDED `check_eb` AND MOVED NOTHING ELSE** — its row was written
  BEFORE the battery off three identical standalone readings of 12, so `check_de` certified on pass
  one instead of reporting an unwatched target, and it reported **ZERO NOTICES**. Before it, **EA
  ADDED `check_ea` AND MOVED EXACTLY ONE OTHER ROW** — `test_batch_ah`, which asserted the OLD
  award behaviour outright and was inverted in place rather than deleted. **DZ ADDED NO ROW AND MOVED NONE — IT WAS THE FIRST BATCH IN THIS
  FILE'S RECORD TO PREDICT A COMPLETELY FLAT TABLE AND GET ONE.** It edits no `.gd` file and no data file,
  and **every assertion against the documents it does edit is a `contains` whose COUNT is fixed**,
  so `CLAUDE.md` can lose 51 KiB without moving a single check count. **DY ADDED NO ROW EITHER AND
  MOVED MANY** — a batch that grows two pools and deletes a third moves every loop that walks one,
  which is what its prediction table is for.
  **THE `flake` FIELD IS GONE FROM `test_batch_at`'S ROW.**
  Before it, **DX ADDED NO ROW AND MOVED EXACTLY ONE FIELD** — `harness_2`'s failure
  band, `[0,1]` → `[0,0]`, with its `flake` field REMOVED because the flake is repaired rather than
  quiet. **A BATCH THAT MOVES A FAILURE BAND DOWN IS THE ONLY KIND THAT SHOULD**, and DE's polarity
  rule is why: a FALLING failure count is a notice, a rising one is an error. DV added `check_dv`
  and moved nothing else; DU added `check_du` and moved `check_cz`. **`check_de` HAS NO ROW OF ITS
  OWN, SO ITS OWN +4 FOR A NEW GATE IS REPORTED BY NOTHING** — **EB adds `check_eb` and moves it
  325 → 329, and EA moved it 321 → 325, for exactly that reason**, and DX added no target so it did not move at all; and the battery's first pass after a new gate necessarily reads one `check_de`
  failure — a target that ran with no row is UNWATCHED, which is that assertion working — so the row
  is added and `check_de` re-run over the same log directory, which is what it is built for. **DR ADDED `check_dr` AND MOVED FIVE ROWS** — `test_batch_bt`, `check_co`,
  and the three its own first battery NOTICED and it had not predicted (`bo`, `cb`, `ce`). **IT IS
  `indent=1` AND MUST BE RE-DUMPED THAT WAY** — Python's default churns the whole file for a
  four-line change. **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
  number is this project's oldest recurring defect, and **DG found five live copies of one figure
  and two disagreeing copies of another.** Per target it carries the expected check count (a number
  or a band), **the expected FAILURE count**, **how many readings the row rests on**, any known
  flake and its rate, and an optional verdict string. **Every red row carries the reason it is red.**
- **DR MOVED `test_batch_cd`'S TABLE WITHOUT MOVING ITS COUNT** —
  `PER_SPEC_DEPTH` is the ONE authoritative per-spec table and DR's two movements (Swordmaster
  10 → 12, Cryomancer 12 → 11) cost one edit there and none in the suites that assert only
  the FLOOR and the TOTAL, which is exactly what that centralisation is for. **ITS COUNT IS IN `baselines.json` AND IS NOT RESTATED HERE — THIS PROSE HAS BEEN WRONG TWICE**:
  it read 72 from DG until DP corrected it to 85, and 85 was stale again by EA. **A number this
  file restates is a second copy by construction.** It is the hygiene suite: the dead-symbol sweep, the
  draft-target sweep and the pool measurement. **DG repaired its §2 anchor guard and added the
  assertion that the guard RESOLVED**, which is the +1.
- **`check_de.gd` IS THE DIFFER, IT SPAWNS NOTHING, AND IT HAS NO ROW OF ITS OWN** — it excludes
  itself from its own sweep, which is why its count moving 289 → 293 at DM (four assertions per
  target, and DM adds one gate) is reported by nothing. **DI's report made the same movement
  and did not predict it; DJ's, DK's, DL's and DM's prediction tables all carry it.** It runs last, reads the logs and the
  baseline file, and reports. **It is re-runnable in seconds over a log directory that already
  exists**, which is what lets a batch write `docs/state.md` and its report AFTER the battery and
  still certify the tree — neither is read by any suite, and `check_de` reads neither.
- **`run_battery.sh`'s check-count grep is GENERAL and must stay that way.** It matches three
  shapes because the suites print several between them. **The `grep -E "checks,"` in the
  battery's header is a comment recording a scar CP already fixed — it is not live code.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts are in `baselines.json`** — EE's locator guard moved gate 2 from 165.
  **Before it, EI, EF and EE each moved the stamp and nothing else in that document; EG moved it
  and three prose blocks** — the draft column's cap and ledger bullets, the seven-slot-cap
  paragraph and the take-one-and-bench-one paragraph. **EA moved the stamp and four prose sites; DZ
  moved the stamp and nothing else.**
  - **THE FOURTEEN STAMP GATES COMPARE AGAINST THEIR OWN BATCH CODE, NOT AGAINST THE PREVIOUS
    STAMP, AND THAT IS WHY DY'S RECORDED SORTING DEBT IS NOT ONE.** Each reads
    `substr(_code_at + 7, 2)` and asserts `>=` its own code — every one of them `CE` or older.
    **`EA` and `EZ` both pass all fourteen**, checked in GDScript rather than reasoned about.
    **What would break it is a THREE-letter code**, because the compare reads exactly two
    characters.
### HOW LONG A FIGHT IS
**STALE SINCE DK. NOT ONE FIGURE BELOW HAS BEEN RE-MEASURED SINCE FIVE PARTY-WIDE EFFECTS BEGAN
REACHING A FIFTH BODY.** Quote none of them as current — re-run the sim first.
- **FU RE-MEASURED ONE CELL, THE ONE ITS BRIEF QUOTED: RUNG-1 UNTALENTED TRASH.** `DOD_SIM_ROWS=0`,
  rung 1, `--run 100` per party, the default party with its Mage swapped: **7.48 / 8.23 / 8.04
  rounds** for the Pyromancer / Cryomancer / Arcanist parties (n = 1,144 / 1,162 / 1,102 trash fights);
  elite 7.27 / 7.79 / 7.33, boss 10.87 / 10.07 / 10.50. **The Cryomancer party IS the default party,
  and EO read 9.1–9.2 on it** — so the "~9 rounds since EO" a brief quoted is about a round long now.
  The ROWS=3 and ROWS=9 tables below were not re-run.
- **FV READ THE SAME CELL ON FIVE PARTIES** (`DOD_SIM_ROWS=0`, rung 1, `--run 100` each): trash rounds ran from about 6 to
  about 10.5 across them, the default party's about a quarter-round from FU's reading — **a fight's length is a property of the
  PARTY**, so a rounds figure travels only beside the party it was taken on. The five figures are `docs/reports/FV.md`'s premise
  table (IM §0.7).
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims **after DA**: three to six turns per hero at every rung and kind. **DA's table is
  `docs/reports/DA.md`'s (IM §0.7), and EN's below supersedes it.**
  - **RE-MEASURED AT EN, `--run 30` A RUNG ON THE LIVE TREE, AND DA's ROUNDS TABLE IS
    SUPERSEDED BY THIS ONE:**

    | party / rung | trash | elite | boss |
    |---|---|---|---|
    | 1 wanderer | **4.4** (n=367) | **3.8** (n=358) | **4.1** (n=90) |
    | 2 warden | 4.3 (n=240) | **3.7** (n=246) | 4.4 (n=57) |
    | 3 ruin | 4.4 (n=235) | **4.0** (n=225) | 5.4 (n=55) |

    **EP ADDED THE ROWS-3 PAIR AND IT IS THE ONE THAT ANSWERS "IS RUNG 2 A DIFFERENT FIGHT".**
    Measured `DOD_SIM_ROWS=3`, `--run 100` a rung — the loadout a single rung-1 clear buys:

    | party / rung, rows 1-3 | trash | elite | boss |
    |---|---|---|---|
    | 1 wanderer | **7.8** (n=1138) | **7.3** (n=1246) | **10.0** (n=297) |
    | 2 warden | **7.4** (n=871) | **6.9** (n=946) | **10.1** (n=177) |

    **The rung-2 fight is not longer, not shorter and not different.** Enemy health is
    bit-identical between the two rungs, `stability` is a flat 100 on all 21 kinds and hero
    `pressure` is untouched, so the Break gate costs the same hero turns and the fight runs the
    same length — the enemy simply hits twice as hard while it happens. **Rung 2 untalented reads
    7.5 / 7.4 / 10.9 and fully talented 4.4 / 3.7 / 4.8**, so talents SHORTEN the fight and the
    rung does not.

    **THE RUNG-1 ROW BELOW IS EO's AND THE OTHER TWO ARE EN's.** EO §2 stopped the rung discounting
    enemy HEALTH, which lengthens a rung-1 fight and no other; re-measured at `--run 30`,
    `DOD_SIM_ROWS=9`, it moves 3.9 / 3.4 / 3.8 → **4.4 / 3.8 / 4.1**. **Rungs 2 and 3 did not move
    and were not re-measured** — the health multiplier floors the rung at 1.0, which is
    bit-identical above rung 1 on 6 of 6 products. **The fully talented party still completes rung
    1 at 100%** (30 of 30), which is the point EN made: a party that has already been through the
    door the rung is finds it a formality either way. **The elite is still the shortest of the
    three kinds at rung 1**, so EN §5's acceptance is unaffected.

- **THE SIM'S OWN `Avg rounds/battle` LINE DIVIDES BY THREE AND THE PARTY IS FOUR.** It has been
  reading a third high since the class draft. `cy_report_line` is the one to read instead.
- **RAMP ARRIVAL, per-battle peak against what the spec is built around, AFTER DA:**

  | spec | meter | rung 1 | rung 2 | rung 3 | SS party |
  |---|---|---|---|---|---|
  | Berserker | Blood Frenzy (of 40) | 17.1 | **20.7** | 22.6 | 26.2 |
  | Devout | Faith (of 3) | 2.2 | **2.2** | 2.0 | 2.3 |
  | Devout | releases/battle | 1.93 | **2.60** | 2.48 | 3.62 |
  | Beastmaster | Loyalty (of 5) | 19.3 | 21.2 | 19.9 | — |   *(DA's, and see EQ below)*
  | Sharpshooter | Focus (of 100) | — | — | — | 128.2 |

  **Loyalty and Focus still over-arrive and have not been touched.**
  - **THE LOYALTY ROW WAS RE-MEASURED AT EQ AND AGAIN AT ER; THE 21.2 IS A `rows=9` FIGURE.** ER's arms (the per-battle
    deepest bond, rung 2, untalented / rows 1–3 / fully talented, each reproducing EQ within its standard error) are
    `docs/reports/ER.md`'s, EQ's rung-1 arm `docs/reports/EQ.md`'s (IM §0.7); the two the Loyalty curve was priced on stand in
    its own section above. **The rung makes the meter SHALLOWER**, because its governor is the companion's death and rung
    2 kills companions three times as often. **Do not quote 21.2 as the meter's level — quote the loadout with it.**
- **THE FAITH DECOMPOSITION AT RUNG 2, AFTER DA — AND STALE SINCE DK for the healing row**: its figures (absorbs, the ground's
  drip, what lands on the Devout's own meter, the ground's uptime and the Devout's healing a battle across four arms) are
  `docs/reports/DA.md`'s (IM §0.7). **Faith per absorb ACTUALLY LANDED was 1.56 against the 2 the constant promises.** The
  healing row is stale: Sanctuary, Rally and the Field Medic now reach a fifth body, so every arm of it will rise.
- **TWO CONFOUNDERS ON EVERY FIGURE ABOVE: the sim party is FULLY TALENTED (`rows=9 of 9`)**, and
  **it wears each tree's FIRST lane — 24 of 36 lanes have never been measured at all.**
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` is the row that does.

### The changelog
- **THE LIVE FILE WAS CUT AT GZ, AT THE FS/FT BOUNDARY.** It starts at **Batch FT** and the archive ends at
  **Batch FS**. **DO NOT COUNT THIS BY HAND AND DO NOT TRUST THIS LINE**: `check_dv` §4
  prints the live figure every battery and `check_fg` §1 prints the SIZE beside the bar, and this
  sentence **has arrived stale at EE, at EO and again at FF** — three times, each time in the
  direction of reading low. **DV ASSERTED THE COUNT AS AN EQUALITY AND IT COULD ONLY PASS FOR ONE
  BATCH** (`live_span == 16`, red on DW's own entry); **it asserts a FLOOR** now — GZ's cut left 31
  plus its own = **32**, and entries are only ever added, so an entry VANISHING still fails — **and the ARCHIVE
  keeps its equality, at 214 since this cut**, because that file only moves when a cut moves it. **DX generalised
  that repair into a construction rule**; see `docs/instrument-rules.md` (DX §1).
- **THE THRESHOLD IS WATCHED, AND AT GZ THE WATCHER WORKED END TO END FOR THE FIRST TIME.** The bar is **400 KB**, the
  decimal and stricter reading; `check_fg` §1 warned on GY and GZ took the cut at the next boundary, the sequence FG
  designed. GZ's figures are `docs/reports/GZ.md` §2; the live size and headroom are `check_fg` §1's print.
- **`check_fg` §1 HOLDS NO COPY OF THE BAR AND THAT WAS RE-CONFIRMED BY READING THE GATE**, not its header
  comment: its only route to the number is a pattern over `docs/instrument-rules.md` that finds the FORM whatever
  the number is, collects every occurrence and asserts the set has one member. **FU's red was §2's** — the defect
  was shared by both form checks, but the number that moved was `CLAUDE.md`'s ceiling.
- **`DoD-archive/changelog-archive.html` holds 214 entries** (Batch 1 → **FS**) and is **1,907,462 B**; the folder,
  with the retired `addendum.html`, is **1,941,173 B**. **IT IS IN THE REPO AS OF BATCH FH, SO IT IS IN VERSION
  CONTROL AND BACKED UP BY GITHUB, AND THAT EXPOSURE IS CLOSED** — **GZ is the first cut to add to it since**, so
  it is the first addition whose recovery does not depend on a named commit. It is kept out of the knowledge sync
  by **DESELECTION in the file picker**, which is a different act from keeping it out of the repo — and the two
  were being done with the same lever for four cuts. **The header pointer is
  `res://DoD-archive/changelog-archive.html`**, not an absolute path, so the fifteen readers that follow it work
  on any machine.
- **THE VERIFICATION IS THE THING TO REPEAT, NOT THE CUT.** A SECOND script reading untouched
  frozen copies, sharing nothing with the splitter: headings counted two independent ways on all
  four files (60 / 185 / 31 / 214), counts summing with zero overlap, order preserved on both
  sides, every heading exactly once, none invented, none dropped, no entry edited, and **the two
  bodies rejoined BYTE-IDENTICAL to the original**, confirmed again by sha256. **NO FILE SIZE WAS
  ASSERTED ANYWHERE** — sizes agreeing is consistent with a duplicated entry and a dropped one.
  **AND THE PROOF WAS PROVED AGAIN AT GZ**: an entry dropped → **11** failures, an entry in both halves → **11**,
  **one word misspelt inside a kept entry → 3, every one of them a byte arm**, on a file that is byte-for-byte the
  same LENGTH and whose every heading count reads clean.
- **SEVENTEEN FILES OPEN THE LIVE CHANGELOG AND FIFTEEN RESOLVE THE ARCHIVE THROUGH ITS OWN HEADER** — the
  fourteen suites bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, cb, ce, **plus `check_dv` §4** for the archive,
  and **`check_fg` §1 and `check_ec` §2** for the live file alone; **0 hardcode the archive path**, and two tools
  read the live file by relative name (`docs/build_docs.py`, which is why the live file must never move, and
  `build_pin_manifest.py`). **NO `.gd` FILE IN THE TREE NAMES THE ARCHIVE BY PATH**, which is why FH's move was
  one header edit and none of the fifteen was touched. **NONE OF THEM NEEDED RE-POINTING AT DV, AT FG, AT FH OR AT
  GZ, AND THAT IS CX's WORK**: every live-changelog assertion in the tree is either the archive-path anchor or a
  **negative** `not contains("<h2>… Batch XX")` on a batch archived at BZ's or CX's cut, which a cut can only make
  more true. **The anchor was armed at a directory that does not exist to prove they follow it rather than pass
  regardless: `check_dv` 83 / 4, `test_batch_bb` 177 → 173 with 2 failures and a throw — FH's reading, taken
  before FX moved that suite's baseline to 173 for an unrelated reason.**
- **THE TWO GATES THAT DO NEED RE-POINTING ARE `check_dv` §4 AND — SECOND-HAND — `check_ec` §2**,
  which verifies that every document pin in the tree resolves. **A boundary literal has two
  readers**, so a cut is not done until the gate that reads the gates has been re-run. **And at GZ a third
  instrument joined them before either ran**: `build_pin_manifest.py`'s residency field, which read `"unresolved"`
  on a re-pointed needle the header had wrapped across a newline.

### Knowledge sync, re-measured at EG
*Measured over `.gd .md .html .json .py .sh`, excluding `assets/`, `.git/` and `.godot/`.
**THE SET IS STATED RATHER THAN DESCRIBED**: it is every tracked file outside `assets/` with one of
those six extensions. **IT IS THE CENSUS SCRIPT'S DEFINITION NOW, NOT A DESCRIPTION** —
`claude_md_census.py` prints the file count and the byte total for any commit, so these figures are
re-derivable rather than recorded. **ALL SIZES BELOW ARE KiB (1024 bytes)**, and all are measured on
the CERTIFIED tree — before this file and `docs/reports/EF.md` were written, because both are inside
the number.*
- **THE FIGURE IS NOT RESTATED HERE ANY MORE, AND THAT IS THE POINT.** This line has carried a
  file count and a byte total since EG and **it has been stale on arrival for three batches running**
  (EP found it four batches out, EQ recorded its own as one file stale). **`claude_md_census.py`
  prints both for any commit and reads `git ls-files`**, so a new file is outside the number until it
  is staged — which is exactly why a copy written into this file is wrong the moment the batch that
  wrote it adds its own report. **Run the census; do not quote a number from here.** **EV adds two
  files (`check_ev.gd`, `docs/reports/EV.md`) and deletes none**, and the STAGED tree reads
  **198 files / 9.0299 MiB** with both of them in it. **THE BYTE TOTAL IS MEASURED IMMEDIATELY
  BEFORE THIS LINE IS WRITTEN AND THIS LINE IS INSIDE IT** — that is the same caveat EG's block
  has always carried, and it is why the FILE COUNT is the durable half and the byte total is not.
  **AND THIS LINE WAS STALE AGAIN ON ARRIVAL, WHICH IS FOUR BATCHES RUNNING**: it recorded EU's tree
  at 194 files and the census reads **196 at that very commit** (`--rev HEAD`), so the recorded
  figure was two files short before EV touched anything. **196 + EV's own two = 198**, which is the
  whole of the delta and is the only way to read this row that stays true.
- **LIVE SIZES ARE PRINTED, NOT CARRIED.** `check_fg` §1 and §2 print `docs/changelog.html` and `CLAUDE.md`
  against their bars, `check_fr` §5 prints `docs/instrument-rules.md`, `CLAUDE.md`, `docs/ways-of-working.md` and, since GR,
  `docs/combat-rules.md`,
  and `claude_md_census.py` prints the file count and the byte total for any commit. **The archive is the
  heaviest file the census counts, and it is deselected from the sync**, so what the connector ingests does not
  move with it. **THE THRESHOLD ESTIMATE IS NOT IN THIS BLOCK AND THAT IS DELIBERATE**: it read seventeen →
  thirteen → eight → seven batches away as it was re-measured, **each re-measurement shortening it — the
  direction a carried-forward number never moves on its own** — and then the threshold was crossed four
  batches before anyone noticed. **`check_fg` §1 prints the live figure and the headroom against the bar every
  battery. Read that.**
- **THE SHARE OF THE SYNC IS RETIRED AS A TARGET (EE §1) AND IS NOT TRACKED.** `CLAUDE.md` is
  measured in KiB against **the ceiling its own block states** (EE's 290, re-derived at FU, GY and HN) whose procedure
  was a SPLIT, **and EF, FF and GR each took one**; since HN §1 the next move is a recon on the file's shape. **NO LIVE READING IS CARRIED HERE ANY MORE**: `check_fg` §2 prints the size, the bar
  and the headroom every battery, and the two figures this bullet used to carry (EP's 217.17 and
  EU's 235.11, "about twelve batches") are exactly the kind of number that was stale by the time
  anybody read it. **The current reading is `check_fg` §2's print, and each batch report carries its own.**
  **EP's BATCH ADDED NO RULE; THE DESIGNER'S RULINGS AFTERWARDS ADDED TWO, +3,529 B (3.45 KiB)** —
  the rung-lever rule and the Scarred-rune refund rule, both of which settle with no implementation
  and would have been lost from this file's next rewrite. **EK grew it by 3,713 B (3.63 KiB)**, which is one
  standing reference: the three vocabularies, the tables and their one accessor each, the
  inertness ruling, and the rule that a new ability or rune is owed a row in the same batch.
  **`docs/instrument-rules.md` has no stated ceiling**; the arithmetic for one is in
  `docs/reports/EF.md` §2 and taking it is a ruling. **It is therefore the one document of the
  three with no bar for an instrument to hold it to** — `check_fr` §5 prints its size every battery
  against nothing, because FG's rule says a bar worth stating is a bar something must read, and the
  converse is that a file with no bar has nothing to read against.
  - **THE SPLIT COST ABOUT A BATCH AND THREE QUARTERS OF GROWTH, TO BUY THIRTEEN, AND THE TWO HALVES DO NOT GROW AT THE SAME
    RATE** — measured, not assumed; the bytes and the per-batch rates over DK→EE and DZ→EE are `docs/reports/EF.md` §2's (IM §0.7).
    The recent rate is what five instrument batches in a row look like.
  - **FOR THE RECORD, AND NOT AS A TARGET: the retired ratio has not been re-derived at EF and is not
    worth re-deriving.** Its numerator is now spread over two files and its denominator gained both,
    which is the third way the same measurement can move without anything about density changing.
- **THE DESELECTION LIST FOR THE FILE PICKER. THE ONE FH ADDS IS `DoD-archive/`, BOTH FILES.**
  It is **1,680,660 B**, larger than every `check_*.gd` in the tree put together. **Deselect `pin-manifest.json`** too — it stays in the repo and
  `check_ed` goes on reading it off disk. Already standing and unchanged: the 47 suite files,
  `docs/build_docs.py`, the archived changelog, and any audit document whose findings have been
  ruled on and applied. **`docs/reports/` grows by one every batch and is the largest block still in
  question** — NOT recommended, because `CLAUDE.md` records the dispute over it rather than resolving
  it (FS §3), and moving it is a ruling. **`claude_md_census.py` IS A
  CANDIDATE TOO** by the same argument that deselects `build_pin_manifest.py` — it is a tool Claude
  Code runs off disk — **but it is 11.34 KiB and the saving is not worth a second entry to remember.**
  **WHAT MUST STAY SELECTED NOW INCLUDES `docs/instrument-rules.md` AND, SINCE GR, `docs/combat-rules.md`** and is listed in `CLAUDE.md`:
  **a split ADDS a file to that list and never removes one from the sync.**
- **The 47 suite files cannot be archived (they must be in the repo to run) but they CAN be
  deselected from the sync.**
  **MEASURED AT FH RATHER THAN CARRIED: 53 `check_*.gd` files existed then, 46 of them in the
  battery's GATES list, and the battery ran 46 suites out of 47 `test_*.gd` (44 of those
  `test_batch_*`).** The seven `check_*.gd` files outside the GATES list are `check_ck_width`,
  `check_ct_map`, `check_cu`, `check_cv`, `check_de`, `check_dn` and `check_map_screen`; `check_de` runs
  as the battery's post-pass and `check_map_screen` as a scene target, so five are outside the battery. The line below is the
  history of that count and **it read 42 when FH arrived** — **EM ADDED `check_em` AND THIS LINE STILL READ 41 WHEN EP ARRIVED**; before it
  **EL ADDED `check_el`**, EK `check_ek`, EH `check_eh`, EG `check_eg`; EF and EE added none, ED added `check_ed`,
  EC `check_ec`, EB `check_eb`, EA `check_ea`, and DZ and DY each added none.
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED

**DB measured 72 across 26 suites. DC repaired 23. DF sorted all 47 and repaired the 37 that were
STALE. DG closed the remaining ten.** **THERE WERE FOUR UNSEEDED FLAKES IN THE PROJECT'S HISTORY AND
ALL FOUR ARE NOW REPAIRED RATHER THAN QUIET.** `test_rune_battle`'s pierce was seeded at DF §0 at
the site that flakes; **`bo`'s NULL FIELD flake is seeded and closed at DT**, settling at ZERO over
six readings; **`test_run_harness` gate 2 is seeded and closed at DX §2**, settling at zero over
thirty; and **`test_batch_at`'s §1 ratio is seeded and closed at DY §4**, six seeded readings all
reading 2.1799 against six unseeded ones spanning 2.1189–2.2463. **EVERY ONE OF THE FOUR SETTLED AT
ZERO, SO ALL FOUR WERE FLAKES AND NONE WAS A FINDING** — which is worth stating as a pattern rather
than four times separately: **a band that has held over hundreds of readings is not usually hiding a
defect, and the way to establish that is to seed it, not to widen it.**
**AND NO SWEEP OF THE SOURCE CAN CERTIFY THERE IS NO FIFTH** — twenty suites draw without seeding
and are stable, and `at` itself calls no RNG at all. **`baselines.json`'s `flake` fields are the
census; one row carries one, `test_rune_battle`'s, kept after its seeding.**

**THE RETIRED-WORD SWEEP CAUGHT DU TOO, AND IT WAS CAUGHT BEFORE THE BATTERY RATHER THAN BY IT.**
`test_batch_bx` §4 keeps *beast* out of player-facing prose and §4b keeps *party* out; both read
`master.html`. **DU's new companion paragraph called Hunter's Mark "party-wide"** and would have
failed §4b. It says "the ownerless Hunter's Mark" now — the phrase the card's own row already used.
**A BATCH WRITING COMPANION PROSE IS THE BATCH THAT REINTRODUCES A RETIRED WORD**: DS hit the same
trap with *beast* on all four of its battery-1 reds. **The cheap defence is to run the sweep's own
strip over the edited document before the battery**, which is what turned this one into a
five-minute fix instead of a second thirty-five-minute run.

**AND DR's BATTERY 1 FOUND `test_batch_bp` §7's LATENT DRAW COLLISION, WHICH IS REPAIRED AND IS
RECORDED HERE BECAUSE THE SHAPE RECURS.** §7 hand-builds a Warrior kit and then TAKES `cands[1]`,
a card drawn from his live draft pool, and two of the three hand-written fillers were IN that pool.
It is fixed with boss-pick names no draw can reach. **DS RE-DERIVED THE UNDERLYING RULE AND IT IS
ABOUT ORDER, NOT FILLER CHOICE**: `bp` §7 stuffed `bm_abilities` *after* `award_draft_pick` had
already rolled, and `draft_pool_left` filters owned names — so a kit built BEFORE the roll can never
collide. `test_batch_bx` §2 and `check_map_screen` already do that and are safe, and
`test_batch_bo` §2's Sharpshooter block uses boss-pick names. **DS's three growing pools could not
reach `bp` §7 at all: it is a Warrior flow.**

**THE COUNTS AND THE BANDS ARE IN `baselines.json` AND ARE NOT REPEATED HERE.**

### THE REST

- **`check_gj` reports 1 failure SINCE GN, AND IT IS ON PURPOSE: THE ARM IS RIGHT AND THE GAME IS WRONG.** §4 asserts
  the victory card's gold is the gold that arrived, and the card leaves out the Tollkeeper's Bell (FOUND AT GN, above);
  GN's code moved the gate's seeded run onto the Bell. HEAD's code with the Bell forced reds the same arm. It goes back
  to zero the batch that fixes the card, and its row in `baselines.json` says so.
- **`check_cm_live` reports 4 failures — 4 TO 5 SINCE IE. THIS IS THE OLDER OF THE TWO REDS THAT ARE ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the gate consolidation; DC through DR confirm them again.** It is the only thing
  that presses the defensive bar.
  **AND FH NAMED THE CAUSE: THE FOUR ARE ONE FACT, NOT FOUR DEFECTS.** `_defensive_brace` chooses
  between the bar and a bot roll on `_nobody_can_press()`, which is
  `sim or autoplay or DisplayServer.get_name() == "headless"` — so under **every** gate in this
  project the bot branch is taken and **the bar can never open through an attack**. CQ §1 made it
  that way deliberately, to stop four suites deadlocking on a modal nobody could press. The four
  reds are `the bar appeared`, `the bar's top line names the incoming blow`, `the brace lands near
  x0.85` and `the brace's Break half lands near x0.75` — the first two are the bar not opening and
  the last two are two bot rolls being compared. **The only way to press that bar is a run with a
  display server**, and `check_fh` §7 drives the bar itself instead (`_run_skill_check(false,
  "defensive")` grades, says INCOMING and carries no Cancel) while asserting `_nobody_can_press()`
  is TRUE, so the day that stops being true the gate says so and these four are re-derived.
  **AND THE FACT REACHES A FIFTH ARM AS A COIN FLIP (IE)**: *a Perfect brace takes less damage than no brace* compares the same two
  bot rolls, so it passes whenever the dice make the braced total the smaller — ID's 911 against 926, and not IE's 924 against 911,
  once the engine chips stopped spending a die at every spawn. Its row carries the failures as a band, 4 to 5.

### FIVE MORE THINGS FH FOUND AND DID NOT FIX — **THE SIXTH WAS THE SAVE, AND FI TOOK IT**

- **`battle._break_impact()` RESTORES `Engine.time_scale` TO THE LITERAL `1.0`** rather than to
  what it was. Invisible in play, where the scale is always 1.0; it cost `check_fh` **546 seconds a
  run** (561 s for ten battles set once, 15 s for the same ten re-asserted every frame) before it
  was found.
- **THE HERO SHEET DRAWS 27 ENABLED BUTTONS THAT DO NOTHING WHEN PRESSED.** Deliberate —
  `party_screen._make_tree_node` says they are the cheapest hover surface and `disabled` must stay
  false or the tooltip stops firing — and the same silhouette as the 604 dead buttons that shipped
  once. `check_fh` §9 exempts them **by SIGNATURE, never by name**.
- **`Run.grant_rune` RETURNS A RUNE IT DOES NOT FIT.** Its callers put it down themselves, at `Run.hold_rune`
  (since GK), which holds whatever is not worn on the hero of its class, or in the bag for a crest rune (since HR §1;
  the bag took every kind from HK). Not a defect today; exactly the shape that goes wrong on the next caller.
- **NO BOSS AWARDS A RUNE.** The live doors are the Peddler, the elite cache, the bargain's `rune`
  reward, the event verb `rune_grant` and, since HK §1, a normal fight's drop (`Run.drop_after_fight`). `check_fh` §3 asserts
  `_resolve_boss` reaches none of the first four and `check_hk` §1e that it reaches no drop, so the day one is added the
  claim is re-derived rather than left standing.
- **`build_pin_manifest.py` BINDS A HOLDER OFF `var x :=` AND NEVER OFF `var x: String =`**, so a
  gate written with explicit types pins nothing the manifest can see and `--check` reports
  `current`. `check_fh` contributed **0 pins typed and 5 inferred**; the manifest went 1412 → 1417
  once two declarations were rewritten. Now a rule in `docs/instrument-rules.md`.
- **AND CHECKS THAT PASS BY ACCIDENT ARE STILL WORSE THAN A RED.** `bs`'s bare `CLAUDE.md` pin was
  the one on record; **EA §2 repaired it and found five siblings**, all of them passing off a
  standing rule that named the batch in passing rather than off the block their message claimed.
  **The three vacuous exclusive-pair siblings in `as`, `at` and `aw` are the remaining live
  instances**, named at their sites and in the open queue above.
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT, AND THE OBSERVATION COUNT EACH BAND RESTS ON.**
  **The bands are in `baselines.json`, with the observation count beside each.**
  **THE RULE, ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling = the highest PLUS the
  observed spread** — the floor is the half that catches a real fault, so it stays tight and the
  ceiling takes the headroom. **`check_de` RUNS on that asymmetry: it asserts the floor and reports
  a rise as a notice**, and **DR's battery 1 is the case that shape exists for** — three rows rose
  because their own loops walk the draft pool, and the differ said so as NOTICES rather than reds.
  - **`an` read 6053 then 6051 across DR's two batteries**, comfortably inside its band, and DR
    moved nothing there.
- **`check_map` is NOT a hang** — 99% CPU for ~5 minutes. The battery gives it a 600s bound.
- **`check_parse` COVERS THE GATES, THE SUITES, BOTH FIXTURES AND THE DATA JSON SINCE EI**, off a
  population derived from `run_battery.sh` rather than from a directory list. **It still does not
  cover the two `.py` instruments, the shell scripts, `shaders/outline.gdshader` or the `assets/`
  binaries no dependency edge reaches** — printed in its own output every run, so the gap is stated
  rather than assumed away. **Its verdict is still read off stderr and never off the tally**: DR's
  control idiom (a deliberate `func _dr_negative_control(:`, restored **from a scratchpad backup
  rather than by `git checkout`**) is what EI's ten arms use.
- **A GATE THAT EXITS 0 IS NOT A GATE THAT PASSED.** **A `--script` target whose base class does not
  resolve prints `Parse Error`, runs not one line, and exits 0.** Grep the stderr; never trust the
  tally and never trust `$?`. **`run_battery.sh`'s `throws=` column is the only thing standing
  between this fault and a green report.**
- **The `_hint_done` / `_skill_done` deadlock is real and is NOT currently biting.** Both
  skill-check orientation cards `await` a signal only a real click or key press emits. **A future
  headless modal will hit this again** — `_nobody_can_press()` is the one place the question is
  asked, and a Profile flag is not a bot guard.
