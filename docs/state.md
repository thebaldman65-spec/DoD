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

**AND THIS FILE'S CEILING IS 520 KiB — AN ALARM ON THE CLOSING PRACTICE ABOVE, NOT A BAR THE FILE IS SPLIT AT (HY §3, ruled
by the designer; raised at JJ §1 and again at JS §0, the designer's).** **THE CEILING's JOB WAS TO BOUND WHAT A BATCH READS, AND THE ROUTING DOES THAT
NOW**: a batch's working read is the index, the core and the blocks its triggers name, so a ceiling on the whole file prices a
working read nobody takes (JI opened 166,750 B of 365,181; JJ 203,915 B of 379,111; JR 286,191 B of 449,926, and derived which part); the rest is read once, at the close, outside it.
**JS's raise is that reason grown stronger**: this file is the living record of every batch since the merge began and goes on growing, and
520 KiB is about 5.6 batches at JG's 14,605 B written above the 440 KiB JJ set — about five batches at JG's rate, which bought the warband's
arc, kept as the record JS's raise superseded. **The archive's method is untouched**: a closed block still goes, because the record is better for it, not
because the room needs it. The practice is what holds this file: what a batch closes goes to the archive. **Reaching the number
means the practice has stopped working — what was closed stayed — and the answer is to archive what is closed, never to
split this file**: a split is `CLAUDE.md`'s answer at its own ceiling, not this file's. HY's number, 380 KiB, was ten batches of this file's mean growth over HO–HW (+5,528 B) above HX's close (339,639 B), rounded
down — kept as the record JJ's raise superseded. EE's method, ten of one batch's record
growth above the same close, gave 460 KiB — above the 455.8 KiB this file stood at when the trouble was met, so it would
never have fired: **an alarm set above the failure level is not an alarm.** `check_fg` §4 reads the number out of this
sentence every battery: over it is a warning, and past it by more than one batch at the record is a failure — the largest
single-batch growth on record is **+13.38 KiB** (ES's +13,700 B). **A batch's fenced structure is not its writing (IT §4, the
designer's)**: IS's +36,759 B net held **36,315 B of fenced structure** (fence `INDEX (IS §5)`: the index pilot's section, revertible by
deleting it), so IS grew this file +444 B outside it and the record stays ES's; IV's +17,741 B net held **10,159 B of fenced structure** (fence `INDEX (IS §5)`: the nine population rows and the pilot's close), so IV grew this file +7,582 B outside it and the record stays ES's; `check_fg` §4b holds each claim to its fence. *In the
preamble for the archive pointer's reason.*

*Last rewritten: 2026-11-09 (Batch JS).*

---

<!-- INDEX:BEGIN (IS §5) -->
## THE INDEX — READ THE CORE WHOLE; OPEN ANY OTHER BLOCK ONLY WHEN ITS ROW's TRIGGERS, OR A POPULATION ROW's, MATCH YOUR WORK (THE INDEX PILOT IS IS's, AND IT ENDED AT IV)

**THE ROUTING (IS §5, the designer's pilot).** A batch reads this file's preamble, this section and the CORE below whole. For every
other block it reads the row, and opens the block — by the heading the row names — when a trigger matches its brief or its work.
**Every block stays in the file, in full, where it stood**: nothing was moved, merged, summarised or struck, and **to read the file
whole again, delete this section** — that is the whole revert.

**WHAT THE PILOT WAS FOR, AND HOW IT ENDED.** THE CEILING WAS ON THE FILE BECAUSE THE READ *WAS* THE FILE; THE INDEX MAKES THE READ
SMALLER THAN THE FILE. THE PILOT ASKED WHETHER A BOUNDED READ IS A SUFFICIENT READ, **AND IT ENDED AFTER THREE REPORTS (IS, IT, IU) ON
ONE ANSWER** (IV §0.1, the designer's): no wrong premise out of a bounded read in three batches, every miss a stale entry the close-read
caught — a fourth report would add nothing. **The index stays**, and the routing stays a step. **`CLAUDE.md` takes none** — closed by
IU §2's derivation, in the shape recon's block below — and **no ceiling moved** at IV: the ceiling stays on this file (380 KiB then, 440 since JJ §1, 520 since JS §0), its restatement on
the read never ruled.

**THE FOUR CONDITIONS (the designer's).** Reversible by construction. Every row carries its triggers — a row without them is
unroutable, and the index fails at that row. The core keeps every block seven of the last nine batches needed — derived, never chosen
(IS's report §5 names the nine and prints the derivation); the newest RULINGS OWED is the core's by role. **And each report says which
blocks it opened and which it needed, and reads every block it did not open at its close** — the pilot's fourth condition, kept after
it as THE CLOSE-READ, the batch's own obligation (`docs/instrument-rules.md`'s block of that name): *a batch's work changes what this
file says is true, and reading the file against the finished work is how the batch finds out.*

**A NEW BLOCK GETS ITS ROW IN THE BATCH THAT WRITES IT; A BLOCK THAT CLOSES TAKES ITS ROW WITH IT** (`check_is` §5 reds on a block
with no row, a row naming nothing, a row with no triggers, and a core that is not the nine batches' seven-of-nine).

**A BATCH THAT AMENDS A BLOCK AMENDS ITS INDEX ROW IN THE SAME BATCH. AN INDEX THAT DRIFTS FROM ITS FILE IS A STALE CLAIM WITH A
ROUTING TABLE's AUTHORITY** (IT §5, the designer's). Every entry carries its block's stamp — `#` and the first six hex digits of the
md5 of the block's text, whitespace runs collapsed — and `check_it` §5 reds on an entry whose block changed under it. **Re-read the
row against the block, mend its label and triggers, then re-stamp** (`python3 index_stamp.py docs/state.md --write`). The stamp proves
the row was touched when its block changed, not that it was read: that half is the batch's, and its report names the rows it mended.

**THE ROUTING IS A STEP WITH A WRITTEN OUTPUT (IU §0.5, the designer's).** IS and IT each read a window and a grep while
the thing being piloted sat unused, and IT's ad-hoc bounded read missed nine blocks that bore on its work, six of which the
triggers would have routed. **THE INDEX DOES NOT BOUND THE READ. IT MAKES THE BOUNDING CORRECT**: the value is accuracy, not
bytes. So before the work begins a batch writes `docs/reports/<code>-routing.md` — the brief's subjects, the rows whose
triggers name them (each with the trigger that matched, verbatim), and the core — and opens that list and the core, the core
whole. At its close it adds the three lists: opened, needed, and found at the close to have borne on the work and not opened
(the close-read paid in full, outside the working read), **each miss marked ROUTED** (the triggers named the subject and the
batch did not follow them) **or NOT ROUTED** (no row's triggers name it, and that row is repaired in the batch), and the
upkeep as rows touched of the total. A read outside the matched list is data, not a failure: the record says what was
opened and what led there, which is how a trigger gets written. `check_iu` §8 holds the last batch's record to that shape;
whether its rows were read is the batch's. **IV's routing (`docs/reports/IV-routing.md`) was the first written with the population rows
below unavailable to it, and the last.** **THE KNOWN LIMIT, RESTATED SO THE RULING DOES NOT ASSUME IT AWAY**: every batch
of this pilot is read by a reader that already carries the project's practices, so a reader who does not know a practice
has no instance, and more batches of the same reader will not make one.

**THE CORE — READ WHOLE:**
- **CORE** `` ## WHERE THE PROJECT IS `` `#261a03`
- **CORE** `` ## THE OPEN QUEUE `` `#17e1f1`
- **CORE** `` ### JS's RULINGS OWED `` `#a19815`
- **CORE** `` ### THE CLERIC's MANA RATE `` `#045567`
- **CORE** `` ### SANCTITY's STEP `` `#8c6773`
- **CORE** `` ### BOIL OVER'S RATE `` `#c3c9c3`
- **CORE** `` ### THE CREST POOL `` `#989eb9`
- **CORE** `` ### FOUND AT IA AND NOT FIXED `` `#0b3b3f`
- **CORE** `` ### RULED AND NOT BUILT `` `#90a9d9`
- **CORE** `` ### FOUND AT HX AND NOT FIXED `` `#c91933`
- **CORE** `` ### THE PLAYTEST'S OTHER FINDINGS `` `#d97c4e`
- **CORE** `` ### THE FOUR OTHER CONJUNCTIONS `` `#dc1281`
- **CORE** `` ### THE SKIRMISHER AND THE TRACKER `` `#b3c93d`
- **CORE** `` ### THE SHAPE RECON ON `CLAUDE.md` `` `#77b69a`
- **CORE** `` ### TO WATCH IN PLAY `` `#5b4f4e`

**THE POPULATION ROWS — ONE A KIND (IV §6, the designer's).**
A TRIGGER NAMES A SUBJECT. A BRIEF WHOSE SUBJECT IS A KIND OF THING MATCHES NO TRIGGER, BECAUSE THE KIND's MEMBERS ARE SCATTERED ACROSS BLOCKS THAT EACH NAME THEIR OWN — the claims, every rule, every
figure a text states (IU's close-read: *the brief's populations matched no trigger*). **So each kind a brief asks for as a population
has a row**: where its members live below (the core, read whole, holds others), its records outside this file, and its triggers.
**Derived, not chosen**: the last ten briefs' subjects (IL–IU), each sorted a thing or a kind, and every kind more than one brief asked
for has a row — nine, and *every rule* is not one of them, one brief having asked (IV's report §6; the derivation is kept,
docs/reports/IV-populations.tsv). **A batch whose brief names a kind opens the row's blocks as it opens a matched row's.** A
population row carries a stamp over its member blocks, in their order, and reds when a member's block changes (`check_iv` §6;
`python3 index_stamp.py docs/state.md --write` re-stamps it as it re-stamps a row); a new kind gets its row when a second brief asks.
+ **POPULATION** **the claims** `#cb419c` — Every present-tense claim a rule file or this file makes about the code, each with its disposition. *lives in:* `` ### FOUND AT IU AND NOT FIXED `` · `` ### FOUND AT HV AND NOT FIXED `` · `` ### FOUND AT HY AND NOT FIXED `` · `` ### FOUND AT GA AND NOT FIXED `` · `` ### FOUND AT GF AND NOT FIXED `` · `` ### FOUND AT GC AND NOT FIXED `` · `` ### FOUND AT FW AND NOT FIXED `` · `` ### FOUND AT GR AND NOT FIXED ``; the core, read whole, holds others (FOUND AT HX, FOUND AT IA, the WHERE block). *records:* docs/reports/IU-claims.tsv (the ledger of record, a disposition a row); docs/reports/IR-claims-census.md; check_hx §1d; check_iu §1; check_iv §4. *triggers:* the claims, stale claims, every claim, claims ledger, claim disposition, claims ratchet, reference claims, claims census
+ **POPULATION** **the figures behind doors** `#e280de` — Every figure or fact a player-facing text states, and the door or constant it reads. *lives in:* `` ### FOUND AT IT AND NOT FIXED `` · `` ### FOUND AT IK AND NOT FIXED `` · `` ### FOUND AT IJ AND NOT FIXED `` · `` ### FOUND AT IQ AND NOT FIXED `` · `` ### FOUND AT HL AND NOT FIXED ``. *records:* docs/reports/IJ-census.tsv; docs/reports/IQ-master-census.tsv; docs/reports/IT-catalogue-figures.tsv; check_ij §2 and §3; check_iy §2 and §5 (the nine handles' constants and the glossary's count); check_iq §2f; check_it §2; check_iu §3. *triggers:* every figure a text states, figures behind doors, a figure with no door, name the constants, literals get names, fact sweep, typed figure, pinned figures
+ **POPULATION** **the closed matter** `#60404e` — Items and blocks closed and left standing: history, measurement tables, struck against their record. *lives in:* `` ### FOUND AT IS AND NOT FIXED `` · `` ### FOUND AT HO AND NOT FIXED `` · `` ### FOUND AT GL AND NOT FIXED `` · `` ### FOUND AT GF AND NOT FIXED `` · `` ### THE CRIT SURPLUS IS RULED END TO END `` · `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED ``; the core, read whole, holds others (the WHERE block, FOUND AT IA, THE SHAPE RECON). *records:* docs/reports/IQ-state-census.tsv; docs/reports/IS-claude-census.tsv; DoD-archive/state-archive.md (where closed matter goes, newest cut first); check_iq §1; check_it §1; check_hx §2; check_fg §4. *triggers:* the closed matter, closed blocks, closed items, closed-block census, history clauses, strike what is closed, measurement tables, archive what is closed
+ **POPULATION** **the positional picks** `#1480c1` — A gate's selection of its subject by position or superlative, and whether it still names it. *lives in:* `` ### FOUND AT IT AND NOT FIXED `` · `` ### FOUND AT IQ AND NOT FIXED `` · `` ### FOUND AT IM AND NOT FIXED `` · `` ### GY's RULINGS OWED ``; the core, read whole, holds others (the WHERE block). *records:* docs/reports/IT-positional-census.tsv (the census of record); docs/reports/IO-census.tsv; check_it §3; check_iu §5 (the MISSES ceiling); check_in §4; check_io §6. *triggers:* positional picks, superlative picks, positional census, MISSES ceiling, fixed window, names its pick, re-selects its subject, a gate's pick
+ **POPULATION** **the bot's divergences** `#d704b5` — Every place the bot's game differs from the player's: RULE (a defect), POLICY (a choice, with its reason), MODEL. *lives in:* `` ### FOUND AT JQ AND NOT FIXED `` · `` ### FOUND AT JF AND NOT FIXED ``; `` ### THE BARGAIN DECK's GRADES `` · `` ### FOUND AT GS AND NOT FIXED `` · `` ### FOUND AT IE AND NOT FIXED `` · `` ### FOUND AT IF AND NOT FIXED `` · `` ### FOUND AT IM AND NOT FIXED `` · `` ### FOUND AT GE AND NOT FIXED `` · `` ### THE ARC, READ WHOLE `` · `` ### FOUND AT JM AND NOT FIXED `` · `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS ``. *records:* docs/reports/IU-bot-divergence.tsv (the census of record, RULE 0 since IV); check_iu §4; check_iv §3b (the ceiling at zero); check_in §3; check_il §3. *triggers:* the bot's divergences, divergence census, bot plays a different game, the bot's rules, POLICY or RULE, sim bot, the bot pays, bot asks the player's door, DOD_SIM_RELICS, relic default, relic in a sim, crest default, DOD_SIM_TIERS, DV36
+ **POPULATION** **the latent shapes** `#2e18d3` — Defects that need a writer, a second member or a field nothing sets yet, each armed to red when it arrives. *lives in:* `` ### FOUND AT IX AND NOT FIXED `` · `` ### FOUND AT IR AND NOT FIXED `` · `` ### FOUND AT IS AND NOT FIXED `` · `` ### FOUND AT IC AND NOT FIXED `` · `` ### FOUND AT IL AND NOT FIXED `` · `` ### FOUND AT IM AND NOT FIXED `` · `` ### FOUND AT HY AND NOT FIXED `` · `` ### FOUND AT HZ AND NOT FIXED `` · `` ### FOUND AT FX AND NOT FIXED `` · `` ### FOUND AT JP AND NOT FIXED `` · `` ### FOUND AT JQ AND NOT FIXED ``; the core, read whole, holds others (TO WATCH IN PLAY). *records:* docs/reports/IR-floor-census.md (the floor census of record); check_ir §1d; check_is §3a and §3b; check_il §1a; check_hy §5. *triggers:* latent shapes, latent defect, dormant field, no writer, floor of a zero, floor census, read-only-zero field, reds when the writer appears
+ **POPULATION** **the save's keys** `#6f0724` — Every key a run save carries and every read of one: the load door, its rename and removal maps, its floor. *lives in:* `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` · `` ### FOUND AT HL AND NOT FIXED ``; the core, read whole, holds others (the WHERE block). *records:* check_iq §4; check_ir §2 (the rename map); check_is §2 (the load door's five answers); run_state.gd's RENAMED_CARDS and REMOVED_CARDS. *triggers:* the save's keys, every save read, load door, rename map, removal map, a key off a save, stale payload, save floor
+ **POPULATION** **the target picks** `#ba7c5e` — Every pick of a card's or a door's target from a side: who is offered, and whether the cast pays there. *lives in:* `` ### FOUND AT IJ AND NOT FIXED `` · `` ### FOUND AT HF AND NOT FIXED `` · `` ### FOUND AT GN AND NOT FIXED `` · `` ### FOUND AT IM AND NOT FIXED ``. *records:* docs/reports/IR-ally-census.md; check_ir §1b; check_is §4; check_il §3; check_im §3b. *triggers:* target picks, pick pool, every pick, hero-side pick, a pick that produces nothing, the pick population, ally-target cards, _hero_side
+ **POPULATION** **the sim's recorded figures** `#5ba05f` — Every figure taken through the sim or its bot, and which a bot or instrument repair moved (SUPERSEDED-PENDING). *lives in:* `` ### FOUND AT JG AND NOT FIXED ``; `` ### FOUND AT JF AND NOT FIXED ``; `` ### THE BARGAIN DECK's GRADES `` · `` ### THE SHARE CENSUS `` · `` ### THE WARBAND's COOLDOWNS `` · `` ### THE WARBAND's MALICE `` · `` ### THE WARBAND's SPENDS `` · `` ### THE WARBAND's HEXES `` · `` ### THE ARC, READ WHOLE `` · `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` · `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` · `` ### THE FIRST CLEAN PLAYTHROUGH `` · `` ### Carried, with measurements attached `` · `` ### Small, and still owed `` · `` ### FOUND AT IE AND NOT FIXED `` · `` ### FOUND AT IF AND NOT FIXED `` · `` ### FOUND AT GJ AND NOT FIXED `` · `` ### Carried from the code, reported and deliberately not fixed `` · `` ### FOUND AT JE AND NOT FIXED `` · `` ### FOUND AT JC AND NOT FIXED `` · `` ### FOUND AT HP AND NOT FIXED `` · `` ### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED ``; the core, read whole, holds others (SANCTITY's STEP, THE CLERIC's MANA RATE, BOIL OVER'S RATE, the WHERE block). *records:* docs/reports/IV-drive.tsv (IV's paired drive: every default-sim figure, HEAD against IV, and its mark); docs/reports/IW-retake.tsv (IW's re-takes); docs/reports/IW-ladder.tsv and IW-screen.tsv (IW's ladder and screen); check_iw §1 and §3; docs/reports/IX-scale.tsv, IX-onesided.tsv and IX-swing.tsv (IX's baseline, scale, one-sided arms and swing); check_ix §1–§4; docs/reports/IY-seeding.tsv, IY-reach.tsv, IY-handles.tsv and IY-grades.tsv (IY's seeding, reach arms, nine handles and every grade's readings); check_iy §1–§4; docs/reports/IZ-reread.tsv, IZ-scale.tsv, IZ-rekey.tsv, IZ-fire.tsv, IZ-populations.tsv, IZ-band.tsv and IZ-grades.tsv (IZ's re-reads and re-derived scale, Leaden's (Frenzied's) re-key, the fire derivation, the two populations, Warden's arms and every grade); check_iz §1–§6; docs/reports/JI-cooldowns.tsv (JI's before figure, HEAD against JI); docs/reports/JJ-malice.tsv (JJ's reading, JI against JJ); check_jj §6; docs/reports/JK-drain.tsv (JK's reading, JJ against JK); check_jk §3; docs/reports/JL-drive.tsv (JL's reading, JK against JL); check_jl §3; docs/reports/JM-arc.tsv, JM-played.tsv and JM-grades.tsv (JM's readings: the tree before the arc against the tree that lands, the game as played, the five cards); check_jm §1–§3; docs/reports/JN-arc.tsv, JN-played.tsv and JN-thinair.tsv (JN's readings: what §1 did, the game with talents, Thin Air after the cut); check_jn §0, §2; check_ji §3; docs/reports/IU.md §4; docs/reports/IP.md §2; docs/reports/IO.md §2 and §3; check_iv §1c. *triggers:* recorded sim figures, sim figures, measurements affected, which figures move, re-take, SUPERSEDED-PENDING, instrument fidelity, figures a fix could move, one seed block, shared seeds, correlated tie, magnitude times uptime, worth rule, conditional effect worth, DOD_ZONE_ROTATION

**THE ROWS — ONE A BLOCK, IN FILE ORDER:**
- `` ### THE FIRST CLEAN PLAYTHROUGH `` `#a11aa7` — First clean playthrough (2026-10-18 Warden run). *triggers:* playtest readout, Rupture unreachable, RUPTURE_BREAK_PER_TICK, Sanctity events, SANCTITY_PER_STEP, vow 2.2 to 1, Cleric driest hero, Boil Over undrafted, Sharpshooter damage share, second playthrough, bot sim figures Sanctity steps dry turns, playtest, zone one
- `` ### THE BARGAIN DECK's GRADES `` `#d7c552` — Grades: the scale, the four, JM's five. *triggers:* bargain modifier severity grades, re-grade, grade scale, reference party, no severity, the test binds, highest cost measured, sharper reading, pooled, covariance, fight seed, Leaden, Fleeting, Warden band, Ambushed, Outpaced, Fractured, Porous, Inverted, Encumbered, deck closed, opening_burst
- `` ### THE SHARE CENSUS `` `#f239c4` — Each side's share of every quantity a rule keys on (JA §3); the axes, re-derived at JB §4; the two prices. *triggers:* share census, heroes vs warband, binds one side, one-sided in effect, axis table, grade 4 axes, a share is not a sign, status door durations, what a share prices, census divisor, gross not cost, Encumbered, warband cooldowns
- `` ### THE WARBAND's COOLDOWNS `` `#98aa87` — Cooling enemy moves: the line, its Break price, the ten, the held bands, dial 2's reversal. *triggers:* enemy cooldown, JN-population, 1.4x line, enemy picker, CD chip, JI-cooldowns, Wretched Bellow, TUNED, second damaging move, Break price, line_blow, HELD, JO-break, JO-held, meter size, Chieftain's Maul, dial 2, Read the Tell, JP-dials, Entomb
- `` ### THE WARBAND's MALICE `` `#b554e0` — The warband's one pool: its fill, its cap, the heals it pays, the policy, the strip, a Forsaken kill denied, JJ's reading. *triggers:* Malice, warband pool, warband heal, heal cost, overkill, kill fill, past_last, spend policy, MALICE_CAP, malice strip, JJ-malice, Forsaken, Forsake, kill denied, FORSAKE_TURNS
- `` ### THE WARBAND's SPENDS `` `#10760a` — The warband's three spends: who holds what, prices, cooldowns, Overrun's absence, JK's reading. *triggers:* Malice spend, warband_rally, warband_entrench, MALICE_ENTRENCH_MULT, effective_armor, MALICE_RALLY_TURNS, Overrun, _warband_spend, _raise_holds, raised body, spend cooldown, Dispel an enemy buff, Fleeting Rally, JK-spends, JK-drain, free spend
- `` ### THE WARBAND's HEXES `` `#94fcf8` — The warband's four hexes: the blows they ride, doors, prices, cooldowns, cleanses, JL's reading. *triggers:* hex, aimed cleanse, Gall, Sap, Mire, Fester, GALL_HEAL_CUT, SAP_CUT, MIRE_SLOW, fester_grow, healing received door, resource setter, hex uptime, Orc Hexer, JL-drive, Orc Archer, Bone Rattle, JO-hexes, rides a blow, hex on a companion, check_jo
- `` ### THE ARC, READ WHOLE `` `#90e734` — JM's readings: the tree before the arc against the tree that lands, the game as played, the five cards. *triggers:* what the arc did, tree before the arc, 141b0be, JM-arc, impurities, game as played, DOD_SIM_RELICS, draw3, crest not closed, JM-played, JM-grades, Fleeting, Encumbered, Miasma, Thin Air, Bloodless, grades moved
- `` ### WHAT THE RAISE DID, AND THE GAME WITH TALENTS `` `#5120ae` — JN's readings (its record since JO §1): the raise, Arm A, Breaks, Thin Air, Arm B; dial 3's reversal. *triggers:* what the raise did, JN-arc, JN-played, JN-thinair, game with talents, DOD_SIM_TIERS, hero Breaks, Skull Crack, Withering Hex, Swampy Grasp, dial 3, JN's ten raises, nineteen keys, HEAD-before-JN, JP-dials
- `` ### THE SIM's FIGURES, RE-TAKEN AT IW `` `#ee7ad8` — IV's marked sim figures re-taken at IW; Rupture and Boil Over's Rage read. *triggers:* SUPERSEDED-PENDING, re-take, rune supply figures, IV's drive, recorded sim figures, runes bought per run, Hierophant completion, Tinderbox Miasma completion, Hourglass bars, Rupture rate in sim, Rage a turn, DOD_ZONE_ROTATION
- `` ### THE FROZEN PLAINS `` `#dc1284` — JS's zone: the draw, the rosters, the six kinds, the Titan's freeze, Sap's second carrier. *triggers:* Frozen Plains, SLOT_POOLS, ZONE_DEFS, draw_zones, DOD_ZONE_ROTATION, player's zone draw, roster 4, roster 5, universal core, Icewrought Titan, Entomb, frozen on a hero, Sap carrier, Sleetveil Matron, reference board, Events.failed_reason
- `` ### FOUND AT JS AND NOT FIXED `` `#83c058` — JS's findings: an old build's save; re-rolled gates, the sim's road; the freeze's cleanse, parry, Feint, companion; names; unbound needles; two cheap rows. *triggers:* older build save, Enemies.config fallback, seeded gates re-rolled, sim road, cleanse aim, parried Entomb, Feint, companion, name sweep, wrought, pin manifest, S2-046, S2-090
- `` ### FOUND AT JR AND NOT FIXED `` `#17701b` — JR's findings: the battery's fights cannot see the draw; line numbers left in the closed records. *triggers:* the draw, how often a kind appears, fixed boards, line-number citation, state-archive citations, JR-citations, citation ceilings, unresolved citation
- `` ### FOUND AT JQ AND NOT FIXED `` `#9c7a04` — JQ's findings: the punish reading the declaration as it stands, the bot's aim, a sticky status. *triggers:* Read the Tell, Encumbered cooldown, declared move, punish, Forsaken turns, bot aims Forsake, sticky status, dispel_one_debuff
- `` ### FOUND AT JP AND NOT FIXED `` `#c83759` — JP's findings: a fight with no theme, Umbral Mirror dormant, a drain meeting a spend (the premises and the attacking fights' reach archived at JQ; the ledger comment at JR). *triggers:* DOD_ENEMIES_OFF, count denominator, JP-count, theme, check_hp, Hallowed, hero declares, Break discards, mirror_ranks, drain meets a spend, reserve bug
- `` ### FOUND AT JO AND NOT FIXED `` `#72d1c7` — JO's findings: what the Break price assumes, unpriced statuses, the Break share, the Decree, a DoT tick, a window (the carriers archived at JP; the premises at JQ). *triggers:* Break price, meter size, unpriced statuses, Sundering Decree, Break share, Fester growth, DoT tick rounding, Encumbered window
- `` ### FOUND AT JN AND NOT FIXED `` `#887181` — JN's findings: glyph, debuff, Encumbered, the cut's reach, content hole (its premises, Break damage and later moves archived at JO). *triggers:* intent glyph, debuff longer than cooldown, Blood Tribute band, Parched Warded tie, the cut's reach, Siphon, check_ic 1c, content hole, one damaging move, Honed, DATA_REST, MOVED_SINCE
- `` ### FOUND AT JM AND NOT FIXED `` `#fd05a0` — JM's findings: relics, aoe on a special (the premises and the probe anchor archived at JN; Gall leaning easier at JO; the grades' readings and the crest's ranking at JP). *triggers:* relic grant gold, aoe special, hover every hero, Gall leaning easier
- `` ### FOUND AT JL AND NOT FIXED `` `#7f50df` — JL's findings: Returned Burden, Fleeting, the bot's Unburden, a spend's delay (the fallback's reach and the premises archived at JN; the hex uptime and the unpriced debuffs at JO). *triggers:* hex uptime, Returned Burden hex, Fleeting hex, unpriced enemy debuffs, Unburden bot, spend cooldown re-derive, float_text die
- `` ### FOUND AT JK AND NOT FIXED `` `#08c010` — JK's findings: Fleeting, the raise cap, Bloodless, a second kill, Called Shot (the fallback's reach archived; the content hole closed for eight of eleven at JN). *triggers:* Fleeting Rally, Brittle Entrench, raise cap, Bloodless raise, second kill, Reaver kill count, Blood Tribute fallen, Called Shot armor, check_jg 3h
- `` ### FOUND AT JJ AND NOT FIXED `` `#62b3f1` — JJ's findings: the heal's timing, the figures the descriptions state (the routing's share archived; the content hole closed for eight of eleven at JN). *triggers:* heal timing, warband healing a fight, heal float, enemy descriptions literal, credit nobody, kill term
- `` ### FOUND AT JI AND NOT FIXED `` `#166b74` — JI's findings: the support fallback's target, the twentieth chip, what goes unpriced, the WHERE block's pins (the debuff item's read archived at JN). *triggers:* support cast fallback, Heads Down support, CD chip, display chip census, unpriced ward, Blood Tribute, WHERE block pins, PROJECTED FOR
- `` ### FOUND AT JH AND NOT FIXED `` `#aac042` — JH's findings: the chip's long line, the save's rebuild, the door no rune carries, the census gap, the cut's next block. *triggers:* Communion rune, heroes_all_hold_cores, rune_core_strike, chip condition line, stale payload rebuild, JH-uptimes, JH-fight, JH-crest, census since IT, check_jc, next closed block
- `` ### FOUND AT JG AND NOT FIXED `` `#9f4db9` — JG's findings left: a core no rune carries reads an empty noun; the list's rows on its subject. *triggers:* Runes.core_noun, empty noun, heroes_hold_core, standing list rows, S4-001, cheap gates
- `` ### FOUND AT JF AND NOT FIXED `` `#07ac98` — JF's findings: the crest none, the hunk pass, finishers at Warden, Tithe's uptime. *triggers:* crest none, JE-crest, the bot wears a crest, JF-crest, pos_hunks width, fixed-width read, Tithe uptime, Fellowship uptime, JF-uptimes, Gate.within, inline _doc pin
- `` ### FOUND AT JE AND NOT FIXED `` `#b26f3d` — JE's findings: the fall's cost, the Cairn, the text standard's overlap, the crest arm. *triggers:* fall's cost truncation, fallen_heal_pct, SLOT_HEAL_PCT, Cairn weight 12, crest arm, text-standard 4.9 overlap
- `` ### FOUND AT JD AND NOT FIXED `` `#3c0831` — JD's findings: a verb with no user, an empty door, a corpse struck. *triggers:* fell_last_fight, clearing_heal, clearing heal, RETURN_FLOOR_PCT, return floor, sync_victory_state, heal_party, Cairn of the Fallen, Cairnmoss Poultice, revive_pct, is_suspended, strike on a corpse, oath death, KNOWN_STRAYS
- `` ### FOUND AT JC AND NOT FIXED `` `#293971` — JC's findings: the span undriven, the readout's fall, Watchtower, the seat at a boundary (the premises and the edits beyond the brief archived at JN). *triggers:* OUTPACED_SPAN value, seat at a span boundary, Wasting not capacity, Watchtower, _watchtower_check, second seed block
- `` ### FOUND AT JA AND NOT FIXED `` `#080956` — JA's findings: the kept id; the strike ledger (the enemy-cooldown item archived at JI). *triggers:* kept id, modifier id rename, strike ledger vs door, every effect lasts one turn, DOD_SUITE_TIMEOUT, battery watchdog
- `` ### FOUND AT IX AND NOT FIXED `` `#af65b0` — IX's findings: a saved offer can deal a modifier at its old reward; the party's headroom; healing; check_hk's walk. *triggers:* saved offer no severity, SEVERITY 0, headroom, pays the party, severity of 1 to 5, healing takes up a tempo half, reference party healing, check_hk walk not seeded
- `` ### FOUND AT IW AND NOT FIXED `` `#7615e7` — IW's findings: what the screen and the ladder found. *triggers:* single-party ladder, resolution against breadth, screen populations
- `` ### THE RULES A GATE COULD CHEAPLY HOLD `` `#147b81` — The 187 cheap gates IU's census found (76 NONE): a standing list, two ceilings. *triggers:* cheap gate, rules census, NONE rule, PARTLY rule, a rule no gate holds, standing list, build the gate a rule names, HO §0, crest rune figures, ruled figures held
- `` ### FOUND AT IU AND NOT FIXED `` `#b42225` — IU's findings: rules the code breaks, gates holding less than their rule, stale claims. *triggers:* 12 * 8, Blood Price note_resource_spent, Shared Ruin contagion, HEALS_STAY, check_if fixed-fps, gates holding less, cheap gate, stale claims outside the census, comment copies
- `` ### FOUND AT IT AND NOT FIXED `` `#fa621c` — IT's findings: two constants pay one less, dead constants, typed figures, 13 picks. *triggers:* BATTLE_TRANCE_TURNS, MANA_WELL_TURNS, dead constant, VENDETTA_CUT, Powershot per point, typed figure, Chilled status row, catalogue structure words, positional census MISSES ceiling, iu_disposition stamp
- `` ### FOUND AT IS AND NOT FIXED `` `#0e8f9f` — IS's findings: the Cryomancer's upkeep, closed items left standing. *triggers:* Eternal Winter, Winter's Grasp, Shatter, Winter's Toll, same-turn hold, leftover closed items, check_is 3b, Cryomancer's route, Cryomancer turn-start upkeep
- `` ### FOUND AT IR AND NOT FIXED `` `#25860c` — Found at IR: latent floor shapes. *triggers:* floor census, Sacred Covenant Faith floor, Slow Acting Thin Blood, temporal rift, latent floor of a zero
- `` ### FOUND AT IQ AND NOT FIXED `` `#442f50` — Found at IQ: Formless chip, stale code comments, check_hn 2a. *triggers:* Formless chip recoil, stale code comments, check_hn 2a worn arm, Fourth Stack rename, talents.gd rung 1 comment
- `` ### FOUND AT IO AND NOT FIXED `` `#b98990` — Found at IO: _cheapest_attack returns the first free attack. *triggers:* _cheapest_attack, Long Silence enemy exemption, Heads Down, enemy 0-cost attack, enemy kit order, bargain modifier
- `` ### FOUND AT IN AND NOT FIXED `` `#490d16` — Found at IN: r3 sample, run_sim safe slot comment, check_fh 7. *triggers:* enemies_alive_r3 sample, round three, ROUND_TICKS, Cruel Order, run_sim _take_offer safe slot comment, safe_band, check_fh 7 fallback comment, false run_sim comment, DV30 bargain policy
- `` ### FOUND AT IM AND NOT FIXED `` `#ba6e07` — Found at IM: Execute upgrade dormant, st/b split, gate defects. *triggers:* execute_upgraded, check_im 3a, Execute price, st/b sim report split, Sanctity figures, check_gn 4 hp_top, check_ew 4 vacuous ok, Firedraw drafted hook, lone burning enemy, _enemy_pick_pool
- `` ### FOUND AT IL AND NOT FIXED `` `#c982d1` — Found at IL: sourceless dormant Cleric clauses. *triggers:* Dark Pact Invigoration invigoration_ranks, Blessed Vestments vestments_pct, status src, Cleric as source, check_il 1a
- `` ### FOUND AT IK AND NOT FIXED `` `#258fbd` — Found at IK: other Sunders lay their own durations. *triggers:* Sunder duration, SUNDER_TURNS, Called Shot Armor, Mass Hysteria, Sundering Strike, Tyrant's Verdict, Consecrated Ground Judgement, enemies.json, handler literal, check_ij 3 pins
- `` ### FOUND AT IJ AND NOT FIXED `` `#8c93ba` — Found at IJ: unsure master.html rows, Siege Stone, readout key. *triggers:* Vespers mercy_window glossary companion, master.html repair rows, Parry Up, Poison row, Answering Steel, Firedraw, Mercy, Siege Stone ally, readout debug action 12 Full Heal, check_ih, enemy description
- `` ### FOUND AT II AND NOT FIXED `` `#f9d4fb` — Found at II: check_dr deleted nodes, Chain Ignition. *triggers:* check_dr TICK_SITES deleted nodes, Chain Ignition Burn no source, ember_wind, _update_talent_chips, attribution frame, frame names nobody, credit nobody
- `` ### FOUND AT IH AND NOT FIXED `` `#b7d22b` — Found at IH: background art sizing, spawn's own live prologue. *triggers:* full-screen art expand mode, map and event background, TextureRect sizing, hero_live_config, battle spawn live Attack prologue, CK 1 owed helper, _spawn_units
- `` ### FOUND AT IG AND NOT FIXED `` `#8917c1` — Found at IG: DEBUFF_IDS keeps melted, first fight resource max. *triggers:* DEBUFF_IDS melted, Melt Armor display chip, melt_ranks, first fight opens at 100, max resource node +20, bar maximum, live prologue helper, opening bar, tier 1 whole
- `` ### FOUND AT IF AND NOT FIXED `` `#768dfb` — Found at IF: sim bot Smoulder (Rupture re-read at IW), readout dealt, fire policy arms. *triggers:* sim bot Smoulder drafted hook, Rupture rate in sim, Cryomancer chill, readout dealt excludes companion, fixed-draft fire policy, Chilled 0%
- `` ### FOUND AT IE AND NOT FIXED `` `#e50a34` — Found at IE: sim bot skips drafted Fireball, DISPEL_NEVER residue. *triggers:* sim bot Fireball Stoke Cinderfall, drafted hook, Mage Burn sim figures, DISPEL_NEVER spec_passive, Ember Leap Ember Debt, Firedraw comment, seeded road
- `` ### FOUND AT ID AND NOT FIXED `` `#aa93e5` — Found at ID: Mirrorbound recoil scope, check_fh draft half. *triggers:* Mirrorbound recoil, attack vs special handler, DAMAGE_SPECIALS, _resolve_special, bargain modifier card words, check_fh draft half, Gate.answer_boss_and_upgrade
- `` ### FOUND AT IC AND NOT FIXED `` `#ac4707` — Found at IC: five dormant fields in the vow's refusal partition. *triggers:* Overkill, Temporal Rift temporal_ranks, Spite spite_ranks, Blowback, Forge Body forge_body_pct, dormant field no writer, refused crit, Vow of Silence partition
- `` ### FOUND AT HY AND NOT FIXED `` `#037abe` — Found at HY: HG's HD 2 four, framed dormant retaliation sites. *triggers:* HG supersession block, retaliation sites, Spite, Whole Forest whole_forest, check_hy 5, attribution frame, HD 2 four retirements print
- `` ### FOUND AT HZ AND NOT FIXED `` `#dc1096` — Found at HZ: boil_over status has no writer. *triggers:* boil_over status, unit.frenzy_bonus, STATUS_INFO row, check_hw 1a, Boil Over, dormant status kept
- `` ### HW's RULINGS OWED `` `#fe0dfc` — HW's rulings owed: Counter Time, proposed words, class rune draft. *triggers:* Counter Time vs Pommel Strike, stun length, Charge Dazed, Snare Line card, glossary Runes Peddler Severity, partner-spec table, class rune draft, crest rune in elite cache, roll_rune_candidates
- `` ### FOUND AT HW AND NOT FIXED `` `#9fa7b1` — Found at HW: click zones, venom lane, Thin Blood chip. *triggers:* HERO_SLOTS click zone overlap, companion summon fit, Venom lane, Trapper barb, Explosive Shot, _apply_poison, Long Poison, Thin Blood chip text
- `` ### FOUND AT HV AND NOT FIXED `` `#639adc` — Found at HV: Open Line row, refused-rune re-ask, two stale lines. *triggers:* Open Line ENGINE_READ Stances, check_gv HALF, Run.rune_choice is_refused, copied Elemental Weakness, _apply_elem_weak, stale CLAUDE.md lines, one choice never two things, Pommel Strike Stun kit list
- `` ### FOUND AT HT AND NOT FIXED `` `#f6a11b` — Found at HT: battery vs open game, rite ruin_primed, HT census. *triggers:* run_battery.sh game open, player-file arm, battery kill trap lock, rite ruin_primed, Reckoning, HT 2f census, Poison clock reset, purge Bleed chip Cull Harvest, Downwind copies, Frostbind partner
- `` ### FOUND AT HS AND NOT FIXED `` `#6d15b0` — Found at HS: Tithe and Rupture Break, top-level-only readers. *triggers:* Tithe on Rupture Break, tick has no attacker, log_bleed_chip, set_ruin_stacks, conjunction ingredient lookup, Contagion, Reckoning, Bleed Ruin ingredients
- `` ### FOUND AT HR AND NOT FIXED `` `#dae9b7` — Found at HR: the fire/ice doc-vs-code census (the sim's cache closed at IV). *triggers:* Shatter, Glacial Hold, Firedraw, Emberkeep, Overburn refund, Burn crit snapshot, stale code comments
- `` ### FOUND AT HP AND NOT FIXED `` `#5a5f2e` — Found at HP: Tithe's read site owes a talent rebalance. *triggers:* Tithe read site, Tithe crest rune, Breaking Heals a Hero talent, Break pay gap, Warden Long Watch, talent rebalance, widen read site, tree procs
- `` ### FOUND AT HO AND NOT FIXED `` `#6d92b4` — Found at HO: crest shapes, Tithe's floor. *triggers:* Tithe floor, Cleanse Debuffs talent, check_gv 4 event door, crest card grant, check_gf bag quit, stale gate comments check_ct_map
- `` ### FOUND AT HN AND NOT FIXED `` `#a3c756` — Found at HN: missing party-condition shapes. *triggers:* Talents.party_condition_met, condition key twice, OR condition, any class twice, crest rune conditions, heroes_ keys, HN 3 census, crest design pass, condition on, condition_met
- `` ### FOUND AT HL AND NOT FIXED `` `#894d9d` — Found at HL: engine word on cards, Guard Change twice, log literals. *triggers:* card text says engine not core rune, classes.gd card text, old save Swordmaster Guard Change twice, slot cost, combat-log literals, read names off data, line-number citation
- `` ### HJ's RULINGS OWED `` `#2e2e10` — HJ's ruling owed: debug toggle name. *triggers:* debug grant-all toggle name, All Class Abilities Unlocked, debug_grant_all, map burger debug menu, class draft pool, lineage boss pool, DOD_SIM_GRANT_ALL, sim experiment arm
- `` ### THE CROSS-TARGET SUPERSESSIONS `` `#4f68c2` — Cross-target supersessions: retired arms and what stands. *triggers:* supersession table, test_batch_bp 5, test_batch_cp 2, test_batch_bv, test_batch_bw, check_dv 2, test_batch_ah 1, test_batch_cd 2, class_pool_floors, check_gs, retiring a superseder, check_jj 5, check_jp 3, AUTHORED_SINCE, MOVED_SINCE, ADDED_SINCE, ROSTERS_SINCE
- `` ### HF's RULINGS OWED `` `#f61857` — HF's rulings owed: Burning Ground, Aper, Abundance, Mark of the Hunt. *triggers:* Burning Ground rune_burning_ground, Aper body charge boon, Tusk and Bristle, Pack Bond boon, Abundance shield ceiling, Mark of the Hunt text, Kill Command Aper, Ghostpack, Call of the Wild
- `` ### FOUND AT HF AND NOT FIXED `` `#b012bf` — Found at HF: companion text, Venom Coating seat, Returned Burden. *triggers:* Summon Companion text three companions, Aper picker, Venom Coating seated without Trapper, seat row, Returned Burden src_name by name, Detonating Ward removals, Burning Ground fallen Cleric, barrier absorb
- `` ### HD's RULINGS OWED `` `#3815ee` — HD's ruling owed: section 3 floors went to runes, not cards. *triggers:* class pool floors CLASS_POOL_FLOOR, rune floor RUNE_FLOOR, check_gv 3, Cleric no-engine rune offer, card-pool floors, HD 3
- `` ### FOUND AT HA AND NOT FIXED `` `#a6b725` — Found at HA: hand-seated lineages, slot and engine-text gates. *triggers:* hand-built seat without engine rune, check_et, check_fm _member, test_batch_bo, ability_slots_used, kit_slots, check_cl_resolver, check_cl_width, check_do 4 engine texts, check_di pack_bond, check_di
- `` ### GZ's RULINGS OWED `` `#fa034c` — GZ's ruling owed: check_dv 4 header arm passes on any cut record. *triggers:* check_dv 4 header arm, changelog cut boundary pin, check_ec 1 alternations, last cut clause, two-armed control on a real cut, changelog archive
- `` ### GY's RULINGS OWED `` `#dcf7e6` — GY's rulings owed: design-notes order, arms that locate by value. *triggers:* design-notes.md entry order, newest first, two blocks, check_gx _label_with locate, test_batch_as _live_boss, check_ct_map _process, vacuous filter arm, liveness arm, _live_turn_bar, arm locates its subject by the value it asserts
- `` ### FOUND AT GY AND NOT FIXED `` `#d1ae6c` — Found at GY: design-notes position unasserted, combat-rules ceiling. *triggers:* design-notes.md position gate, newest-first order, test_batch_bn bs ce, combat-rules.md ceiling 70 KiB, GR ruling 1, design-notes entry
- `` ### GX's RULINGS OWED `` `#741538` — GX's ruling owed: battle log roll call names a sitting-out rune. *triggers:* battle log roll call Rune lines, rune sits out, GX sentence, Run.note_first_sentence, sits_out surfaces, worn rune pays nothing, spawn log
- `` ### GW's RULINGS OWED `` `#a50d7c` — GW's rulings owed: ninety hand-sets, check_ez 4 writer sweep. *triggers:* hand-set rune engine talent fields, check_gw 2 ceiling 90, check_ez 4 writer sweep, rune_ field carry propagation, runes.json magnitude, exemption vs repair, new gate
- `` ### GV's RULINGS OWED `` `#63bc86` — GV's ruling owed: rune gate reads equipped engines, not owned. *triggers:* Runes.ENGINE_READ, equipped vs owned engine, unequip engine Peddler, cache rolled with engine out, Runes.offerable, rune gate, Peddler roll
- `` ### GU's RULINGS OWED `` `#b4f490` — GU's rulings owed: former basic price, Guard Change, Sweeping Strikes. *triggers:* former basic price, Arcane Explosion, Shadowrend, Fireball, Frostbolt, Magic Missiles, Arcane Barrage, Chastise, Guard Change cost, Sweeping Strikes cooldown, EB crossover
- `` ### FOUND AT GU AND NOT FIXED `` `#46deab` — Found at GU: check_da 3b blind to merged pool, cards under enablers. *triggers:* check_da 3b source families, draft_pool corpus walk, cards under an enabler, Arcane Explosion vs Flamewave, Shadowrend vs Hex of Ruin, Beastmaster summons, crossover pairs
- `` ### GT's RULINGS OWED `` `#c6cd62` — GT's rulings owed: Fireball/Frostbolt price move, sitting-out slot. *triggers:* Fireball Frostbolt price, Magic Missiles baseline, Aimed Shot, EB inversion parity, card sits out keeps slot, benching, kit over cap, SITS_OUT
- `` ### FOUND AT GS AND NOT FIXED `` `#fd1e77` — Found at GS: second clauses, engine texts, bot, drafted basics. *triggers:* Battle Poise free Guard Change, Shatterpoint Overpower, engine texts name cards, sim bot _bot_drafted_pick, drafted basics Perfect, Arcane Explosion no Perfect, Pommel Strike text, Last Rites
- `` ### GR's RULINGS OWED `` `#2c3ddf` — GR's ruling owed: combat-rules.md has no stated ceiling. *triggers:* combat-rules.md ceiling, 70 KiB, EE ceiling method, KiB ceiling, instrument-rules.md ceiling, reference file size, check_fr 5, GR ruling 1, the two readings
- `` ### FOUND AT GR AND NOT FIXED `` `#4fc1fe` — Found at GR: ways-of-working header, census. *triggers:* ways-of-working.md header two rule files, check_fr, claude_md_census.py population, moved combat blocks, which file a rule lives in, combat-rules.md third rule file, IR01
- `` ### GQ's RULINGS OWED `` `#e7a912` — GQ's rulings owed: class-selection words, fixed card text window. *triggers:* class-selection screen spec_choice words, Also opens with, Rune of the Warden Attack 75, Occultist Smite, card text window 280 px, deal of three engine runes
- `` ### FOUND AT GQ AND NOT FIXED `` `#7c2c4c` — Found at GQ: kit texts break standard, orphaned blurbs, Tracker. *triggers:* Ministration text, Magic Missiles text, design rationale on card, ARCHETYPE_DESC, SPEC_INFO blurbs no reader, Tracker class passive vs Rune of the Tracker
- `` ### GP's RULINGS OWED `` `#ceb407` — GP's rulings owed: weakest class-wide cards, gated cards, holder. *triggers:* class-wide cards rebalance, CLASS_DRAFT_POOLS weaker, ENGINE_READ unreachable cards, Death Ray, Hymn of Hope, Resurrection, Runaway Resonance, holder vs party gate, two heroes one class
- `` ### FOUND AT GP AND NOT FIXED `` `#dc26c7` — Found at GP: Covering Guard 0% block, Defensive-gated Warrior cards. *triggers:* Covering Guard block_chance, _live_block_chance, _plating_slice Heavy Plating, Warden 0.10, Battle Poise, Counter Time Defensive guard, stance-switch cards, Formless, can be blocked
- `` ### GO's RULINGS OWED `` `#c6fa58` — GO's rulings owed: nine rule engines (magnitudes, names, rules). *triggers:* rule engines RULE_ENGINES, Reaver, Leech, Arbiter, Skirmisher, Weaver repeat, Oathkeeper bond, Tracker name, Bastion bot, Tracked Judged Oathbound chips, engine names in rule text, second kill, kill count, raised body
- `` ### GN's RULINGS OWED `` `#2a403a` — GN's rulings owed: Magic Burst, Elemental Weakness, kit wording. *triggers:* Magic Burst numbers, Elemental Weakness resistance cut, ELEM_WEAK_PCT, strike loop coverage, Nexus Ward Ward label, Tripwire, Consecration, Powershot wording, Cleric class pool three, class kit, label collision, name sweep
- `` ### FOUND AT GN AND NOT FIXED `` `#afc4c9` — Found at GN: victory card omits Tollkeeper's Bell, Tripwire, bot. *triggers:* Tollkeeper's Bell victory card gold, award_gold, victory_gold hook, check_gj 4 sanctioned red, baselines.json, Tripwire on companion, Mana Shield never cast by bot
- `` ### GM's RULINGS OWED `` `#691d7a` — GM's rulings owed: engine-bound cards, Split Shield, Dispel. *triggers:* cards leaving with an engine, half-working lineage cards, Split Shield Bulwark Line, Shieldwall, Dispel DISPEL_NEVER, Rime DEBUFF_IDS, Hold Breath, Called Volley, Drumfire, Divine Plea label, enemy buff, beneficial status on an enemy, warband status, _dispellable_buffs
- `` ### FOUND AT GM AND NOT FIXED `` `#c2d5b8` — Found at GM: Held Breath counter, Focus inert, enemy status census. *triggers:* Hold Breath counter armor bypass, Lethal Aim, +40 Focus inert, enemy-side status list, check_gm 4, DEBUFF_IDS, DISPEL_NEVER, sim bot draft wrapper Mana Shield, draft_ability
- `` ### FOUND AT GL AND NOT FIXED `` `#d57ed7` — Found at GL: half-working lineage cards, card texts vs code. *triggers:* Shrapnel Charge, Hamstring, Venom Coating, Pinning Shot, Called Shot, Divine Shield recast Bare Altar, Quick Shot Perfect slot 0, Battle Trance, Mana Well, Arcane Explosion Resonance, party damage buffs, kit-recon.html, test_batch_bo 5 blind to slot 0
- `` ### GK's RULINGS OWED `` `#fb38f9` — GK's rulings owed: spine rule texts, class-selection words (the names confirmed at IW). *triggers:* SPINE_INFO, spine rule texts, Rune of the Vanguard Invoker Hierophant, class-selection words ENGINE_SLOTS, engine rune price, lineage interim, Heavy Plating base stat, engine runes untagged check_ek, Sanctity's step
- `` ### FOUND AT GK AND NOT FIXED `` `#b62732` — Found at GK: save-backups untracked, passive_id comments. *triggers:* save-backups untracked, .gitignore, git add -A, battle.gd passive_id comments, engines field
- `` ### GJ's RULINGS OWED `` `#4239cf` — GJ's rulings owed: end boss rung multiplier, rung-1 words, tooltip. *triggers:* end_boss_mult, end boss rung floor, rung 3 x1.30, Wanderer tooltip, glossary road entry, end boss tooltip, Hollow Crown readout, zone_base_mult
- `` ### FOUND AT GJ AND NOT FIXED `` `#066e00` — Found at GJ: end boss fight too short, screen primitives, sim. *triggers:* end boss Hollow Crown fight length, Regalia, Broken end boss freeze, end boss content, gate_fixture screen primitives, check_fh, check_gf, sim zone-boss awards, slot ladder 10, recorded sim figures, re-take owed
- `` ### FOUND AT GF AND NOT FIXED `` `#f68233` — Found at GF: shop quit skipped, upgrade stacking, glossary. *triggers:* Peddler forge quit resume, upgrade stacks on forged card, roll_upgrade_offer has_upgrade, Resonance uncapped claim CLAUDE.md governor table, Melted Armor, Caught Fast
- `` ### FOUND AT GG AND NOT FIXED `` `#766f65` — Found at GG: glossary retirement unasserted, Penance comment. *triggers:* glossary retired key, Glossary.in_category, glossary retirement gate owed, check_et 1, Penance SYNERGY comment, Decay, Entropy entropy_ranks
- `` ### FOUND AT GH AND NOT FIXED `` `#a42bae` — Found at GH: fallen hero replays death animation on restart. *triggers:* quit fight restart, fallen hero death animation, _die, _lay_down_the_fallen, resumed battle, party losses carry across quit
- `` ### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S `` `#0974e6` — Talent layer: five rulings, FW's edges. *triggers:* TIER_SPEND_MIN, talent node, swapped nodes, spend gate, relic seam, class spines, class passives, basic attack, spec statuses, bot never reads a skill profile, systems-recon, crest money, enemy interference, Cleanse Debuffs
- `` ### FY §1: THREE NODES PAID BY WHO ELSE HELD THEM, AND TODAY'S COUNT DOUBLES FOUR ITEMS `` `#0151cb` — Deepening Hex wording still owed (FY 1, ruled at GA-GC). *triggers:* Deepening Hex card wording, RUIN_FLOOR 8, every 8th, Ruin step, avatar_ruin, node paid by who else holds it, Deflection, Enemies Look Past You, name sweep
- `` ### FOUR GATES CAN WRITE THE PLAYER'S `relics.json` THE DAY A RELIC IS LOCKED `` `#1d592e` — Four gates can write player's relics.json (deferred to playtest). *triggers:* relics.json, Relics.unlock_random, Relics.save_path, _resolve_boss, check_ea, check_eg, check_eh, check_fh, locked relic, save redirect, relics unlocked, relic assignment at the draft
- `` ### FOUND AT FY AND NOT FIXED `` `#667003` — Found at FY: instrument hygiene, checks that pass by default. *triggers:* test_batch_ar as at ranks, exclusive_with, check_dk ally needles, test_batch_ay _worn_tree, test_batch_ba count, dormant field numbers, Pressure Cooker, check_fx 4 one spec per class
- `` ### FOUND AT GA AND NOT FIXED `` `#de0bed` — Found at GA: a dated claim in instrument-rules.md. *triggers:* instrument-rules.md dated claims, EU all five correct, re-derive reference claims, stale claims
- `` ### FOUND AT GE AND NOT FIXED `` `#6174e1` — Found at GE: Long Draw drain still a gain, its words. *triggers:* Long Draw rune, SS_SEQ_MISS_DRAIN, miss drains 16 Focus, check_cs 7 model, bot 85% press roll, check_ez 5
- `` ### FOUND AT GC AND NOT FIXED `` `#6f4593` — Found at GC: merge-claims census, deleted things named live. *triggers:* merge-ruling claims census, RULED NOT BUILT marker gate, deleted talent nodes cited, Talents.LANES, master.html talent-point economy, systems-recon.html bar-swap relic, ways-of-working table
- `` ### FOUND AT GB AND NOT FIXED `` `#4ebfa4` — Found at GB: forfeit, stale comments (DOD_SIM_RUNES gated at IV). *triggers:* debug_summon forfeit note_forfeit, stale comments in scripts and gates, dormant free_swap layered_faith crushing_blows, _companion_hit comment, kindling bargain, clearing heal comment, communion_ranks, Communion talent
- `` ### FOUND AT FX AND NOT FIXED `` `#6450f9` — Found at FX: chip names, dormant fields, retired vocabulary. *triggers:* iron_will chip, undying_rage, dormant fields 275 of 304, the_pack, deleted-node log labels, _evade_source ghillie, retired vocabulary, vacuous suite checks
- `` ### FOUND AT FW AND NOT FIXED `` `#a926c4` — Found at FW: relic hook sites, death refusals, unapplied content. *triggers:* relics.gd hook read sites, death refusals, stale comments, effective_speed, never-applied statuses, tick kill skips _on_enemy_death, combat-rules.md four death-refusals
- `` ### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED `` `#d09cc4` — Class merge project (FP): size, staging, spines, spell partition. *triggers:* class merge, merge-recon.html, class-merge branch, specs to classes, battery reds during merge, engine move, merge pilot, Sanctity potency layer, is_spell flag, dmg_type, recon coverage, Sanctity's step
- `` ### THE THREE SPINES ARE BUILT AND ALL THREE RATES ARE SET (FU, FV); WHAT IS STILL FLAGGED `` `#784aaf` — Three spines (Momentum, Channel, Sanctity): still flagged. *triggers:* CHANNEL_SPARES_PHYSICAL, CHANNEL_CAST_FLOOR, MOMENTUM_EXCHANGES_PER_STEP, Momentum cap, self-damage taken half, second meter display, ledger spender BI 1, _sync_engine_switches, spine runes, note_blow_met
- `` ### FIVE DRAFTED ABILITIES ARE NAMED AND DESCRIBED NOWHERE `` `#87b6b9` — Five drafted abilities undescribed in master.html. *triggers:* Arcane Surge, Divine Wrath, Mana Shield, Reality Fracture, Rallying Shout, master.html 6b drafted-abilities table, DY vault re-homes, card rows
- `` ### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE `` `#b76e97` — The doc repair FR left: events.gd comment. *triggers:* events.gd comment talent_points verb, event worked example, health for talent points, line-number citation, events.gd
- `` ### TWO SYNC DESELECTIONS ARE DISPUTED BETWEEN THE REPO AND A BRIEF `` `#e21560` — Disputed sync deselections: reports, talent-audit, root .gd. *triggers:* knowledge sync picker deselection, docs/reports selected, talent-audit.html, text-audit.html, DN 8, root .gd pattern, test_runes.gd, gate_fixture.gd, suite_fixture.gd, must stay selected, docs/reports growth
- `` ### THE PIN MANIFEST IS BLIND TO A GATE THAT HOLDS ITS PATH IN A `const` `` `#e4710a` — Pin manifest blind to a gate holding its path in a const. *triggers:* build_pin_manifest.py, pin-manifest.json, check_ed, const path holder, needle constant, check_fr pins, check_fs, ways-of-working.md, document gates
- `` ### **AND FP's `block_chance` FINDING TRAVELS WITH IT `` `#df7020` — block_chance has no universal baseline (FP, re-verified FQ). *triggers:* block_chance default 0, Warden 0.10, parry_chance sentinel, PARRY_CHANCE, Heavy Plating _plating_slice, PROTECTED_CORES enablers as stats, wd_mountain, Covering Guard, can be blocked
- `` ### FN HANDED OVER THREE DESIGN QUESTIONS `` `#b578e6` — FN's open question: Wide Rite and Heavy Bolts now always on. *triggers:* Wide Rite, Heavy Bolts, rune conditions retired FN, rune price 100g/150g, conditioned rune worth, Occultist, threshold breadth
- `` ### THE SHARED MARK'S MAGNITUDE IS PROPOSED, NOT RULED `` `#2e365f` — Shared Mark magnitude proposed, not ruled (FO 2). *triggers:* Shared Mark rune, SHARED_MARK_FOCUS 5, Sharpshooter Focus, ally strikes his mark, check_fo 2c, muscle_memory_ranks, Focus gain
- `` ### THE RUNE OF THE STANDING GROUND IS NOT AUTHORABLE, AND THE RULING IS THE PART TO KEEP `` `#b67ac5` — Rune of the Standing Ground is not authorable (base kit already). *triggers:* Standing Ground rune, Consecrated Ground cons_ground, _ground_faith_tick, Faith to allies, Devout fifth rune, check_fk 6, inert rune, narrow ground to caster
- `` ### THE `master.html` STAMP CAN SIT MANY BATCHES STALE AND PASS `` `#89f640` — master.html stamp can sit many batches stale and pass. *triggers:* master.html Last updated stamp, stamp gates fourteen suites, test_batch_ce, stamp freshness, file moved vs stamp moved, mtime, git
- `` ### THE SKILL CHECK'S DIFFICULTY IS RULED AND BUILT `` `#54b1f2` — Skill-check difficulty ruled (EY): Sharpshooter window has no slack. *triggers:* skill check difficulty, sweep_time 1.00, half-widths, Sharpshooter Good window 97.3%, SS_SEQ_OPEN, check_cs 4 0.02 bound, widen a window, bot 85% press vs player window
- `` ### THE CRIT SURPLUS IS RULED END TO END `` `#f40ba3` — Crit surplus ruled; check_ew 6 has a vacuous assertion. *triggers:* crit surplus, crit chance above certainty, crit multiplier, check_ew 6 vacuous ok, lethal_crit_mult, crit rule, vacuous assertion repair, EX
- `` ### THE LADDER `` `#31fc95` — Ladder: what rung 2 should ask (ruled C or C+D, unbuilt). *triggers:* rung 2 Warden question, rung-tagged enemy abilities, enemies.json rung tag, wider warband encounter shape, budget ramp BK 5, compose floor, difficulty ladder options, enemies.json
- `` ### THE RUN REPORT'S WIPE TABLE IS BANDED FOR A TWELVE-SLOT ZONE `` `#19a80e` — Run report wipe table banded for a 12-slot zone. *triggers:* run_sim.gd wipe table, tier >= 11 boss band, per-tier table range(1, 12), slots 12-16 dropped, end boss column, per-run progress line, wipe distribution, run completion rate
- `` ### THE ARCHETYPE TAGS `` `#412ffe` — Archetype tags: open design questions (set, collisions, surfaces). *triggers:* card tags, TAG_ORDER, CARD_TAGS, RUNE_TAGS, tag-reading rune, threshold, breadth, check_ek 3, check_es 4, MARK DEFENSE collisions, PET STANCE tags, archetype word, tag on hero sheet, rune-audit.html
- `` ### THE DRAFT AUDIT `` `#c986a4` — Draft audit (DQ): open findings, boss-channel repeatables. *triggers:* draft-audit.html, PER_SPEC_DEPTH, Sweeping Strikes, Ashes of Al'ar, apply_kit_overrides corpus, Shadowrend perfect_text width, Hunter class gap, Cryomancer ice concentration, Beastmaster engine binding, PER_CLASS_DEPTH, ability corpus
- `` ### THE RUNE CHARTER `` `#5f56ff` — Rune charter (EM): open design questions (lane runes, splash). *triggers:* rune charter, rune-audit.html, check_em, lane runes, splash runes, breadth_met, check_es 5, rune variance mechanism, rune pricing, tags as variance, crest choice
- `` ### THE BOSS-PICK POOLS `` `#ab5e62` — Boss-pick pools (SPEC_POOLS) audit: thin pools, bot guards. *triggers:* SPEC_POOLS, zone-boss award fallback, Devout boss pool 2, Sanctuary to Devout, Ashes of Al'ar, bot guards mark_hunt intercession, Deadfall Network, ASHES_RETURN dead constant, constant read nowhere, icy_resolve_ranks, class-wide draft pool, SLOT_COUNT
- `` ### THE THREE PRICING QUESTIONS `` `#a7ea0a` — Three pricing questions: core baseline, Divine Wrath, Sanctuary. *triggers:* protected core baseline EB 1, check_eb 1 crossover, check_ea 4, Divine Wrath vs Blessing of Zeal, PURE_BUFFS, BUFF_DELAY_CAP, Arcane Surge initiative, Hold the Line, Sanctuary vs Hymn of Hope, the Cleric's Mana gain, new draft card price, kit card baseline
- `` ### THE TALENT CHARTER `` `#b95279` — Talent charter (DO/DP) residue: Torment, owns_ability, no-Perfect. *triggers:* talent charter, Ruined Mind, Lingering Torment oc_torment, owns_ability condition, CHECK_WITHOUT_PERFECT, Rampage, Pyroblast, test_batch_bo 5, talent-audit.html 8
- `` ### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT `` `#b78fa5` — Seventh family: card text under-states its payload (DM, unswept). *triggers:* card text under-states payload, absent clause, DM 1 test, authoring vs repair, card text sweep, enemy description, enemies.json description
- `` ### Small, and still owed `` `#7cd3f7` — Small, still owed: src coverage, companion terms, stale sims. *triggers:* vacuous as/at checks, _apply_status src coverage, check_di CALL_SITES, _companion_hit terms, We Do Not Break companion, stale sim figures, shared_grief exactly 3 comment, Profile.save_path swap, hand-built boards, fixed boards, attacks off
- `` ### Carried, and still awaiting a ruling `` `#2cff14` — Carried rulings: zone-boss fallback floor, per-file ceilings. *triggers:* zone-boss fallback fully-held pool, EH 1, CLAUDE.md ceiling, instrument-rules.md ceiling, combat-rules.md ceiling, EE method, subject seam split
- `` ### Carried, with measurements attached `` `#02ab0b` — Carried measurements: Frenzy rate, Faith lane band, revert sweeps. *triggers:* FRENZY_RAGE_PER_STEP, Blood Frenzy peak, Reckless Abandon, Faith lane, FAITH_RELEASE, HELD_MAX, Communion band, Elevation, Blessing of the Faithful, revert constant prose sweep, recorded sim figures, sim readings carried, re-tune, every text that states it
- `` ### Named by the designer, carried from CX `` `#49f8f1` — Named by the designer (CX): relics per hero, rune content. *triggers:* relics per-hero ruling, active_relics save format, victory_heal_pct, fallen_recover, resource_floor_pct, relic read sites, enemy interference status, rune content pass, enemy debuff duration vs cooldown
- `` ### Carried from the code, reported and deliberately not fixed `` `#01cc1d` — Carried from code: shop key, counts, beast ids. *triggers:* rune trade event, scarred_runes id, shop confounder merchant key, devoted_fury, checks=none targets, _recast_refusal_note Frozen vs Held, beast identifiers, Killing Frost vs Blizzard, SUPERSEDED-PENDING, runes bought per run, new draft card, RECAST_GATED
- `` ## LIVE COUNTS AND CONSTANTS WORTH HAVING AT HAND `` `#ddb916` — Live counts and constants (delays, corpus, pools, saves). *triggers:* BASIC_DELAY, BUFF_DELAY_CAP, PURE_BUFFS, ability corpus 233, RECAST_GATED 65, FRENZY_MAX_STEPS, FAITH_RELEASE, draft pools 181, ABILITY_SLOTS_BY_BOSS, pouch slots, SC_PROFILE_DEFAULT, save v15, relics, EMBERKEEP_TURNS recast proposal, LIVE COUNTS
- `` ### THE TEST TREE, AS OF EF `` `#5b4d14` — Test tree as of EF: suites, battery, baselines, differ. *triggers:* suites at repo root, suite_fixture _spawn, run_battery.sh GATES, gates outside GATES, .ran manifest, baselines.json rows, new gate rows, check_parse coverage, check_de differ, stamp gates, check_da 3 walk
- `` ### HOW LONG A FIGHT IS `` `#2c05b2` — How long a fight is: the sim's rounds line and the conviction row's caveat (the figures, stale since DK, archived at JO). *triggers:* fight length rounds, turns per hero, rung 2 same fight, DOD_SIM_ROWS, elite shortest, Avg rounds/battle bug, cy_report_line, ramp arrival Frenzy Faith Loyalty Focus, sim confounders
- `` ### The changelog `` `#58e9f4` — The changelog: live cut at IZ (HR/HS), archive, threshold, cut verification. *triggers:* changelog cut, changelog-archive.html, check_dv 4, check_fg 1 400 KB, check_ec 2, cut verification byte-identical, changelog readers, build_docs.py, archive boundary, build_pin_manifest.py reads the changelog, changelog headroom, next changelog cut owed, folder size
- `` ### Knowledge sync, re-measured at EG `` `#2a8901` — Knowledge sync (EG): census, live sizes, deselection list. *triggers:* knowledge sync, claude_md_census.py, file count byte total, check_fg 1/2 sizes, check_fr 5, CLAUDE.md ceiling, sync share retired, deselect DoD-archive pin-manifest.json, suite files
- `` ## KNOWN-BROKEN AND DELIBERATELY UNFIXED `` `#250eeb` — Known-broken and deliberately unfixed (section head). *triggers:* known-broken, deliberately unfixed, sanctioned reds, suite reds, check_cm_live, check_gj, flakes
- `` ### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED `` `#b178d7` — Suite reds: the flake census, the fifth flake, the retired-word sweep. *triggers:* suite reds history, unseeded flakes seeded, baselines.json flake field, test_rune_battle, retired-word sweep beast party, test_batch_bx 4, counts not repeated here
- `` ### THE REST `` `#b10bce` — The rest: sanctioned reds check_gj and check_cm_live. *triggers:* check_gj 4 red Tollkeeper's Bell, check_cm_live 4-5 failures, defensive bar, _defensive_brace, _nobody_can_press, check_fh 7, sanctioned red baselines.json, coin-flip arm
- `` ### FIVE MORE THINGS FH FOUND AND DID NOT FIX `` `#f0f36b` — Five FH found: time_scale, dead buttons, grant_rune. *triggers:* _break_impact Engine.time_scale, hero sheet dead buttons, check_fh 9, Run.grant_rune, no boss awards a rune, manifest typed var, check_map not a hang, exit 0 Parse Error, _skill_done deadlock, vacuous as/at siblings, an band drift, check_parse .py gap, new gate
<!-- INDEX:END -->

## WHERE THE PROJECT IS

- **Last batch: JS — THE FROZEN PLAINS.** IMPLEMENT ONLY, under the designer's floor — **balance is the designer's, judged by playing; a batch's only job is making sure its code works** (`docs/ways-of-working.md`): no balance drive ran. **Difficulty is deferred by the designer's call, so the three dials stay written down and unpulled.** **JR's five rulings were answered in JS's brief — all accepted as taken — and went to the archive**, struck. **JS's own choices are owed with their reversals** (JS's RULINGS OWED). Full working: **`docs/reports/JS.md`**.
- **THE DESIGNER's FILES, READ THROUGH COPIES AND UNTOUCHED.** The readout holds IH's first run, the clean one, `readout/run-20261018-194229.jsonl` (md5 `610bcd8c2b43f97703e63053e86728fa`), and the 9 November play's two, `readout/run-20261109-035107.jsonl` and `readout/run-20261109-044309.jsonl` (the second is the one `latest.txt` names). **Both 9 November runs are debug-touched** (`debug_used` true), **so the second clean run with a different party is still asked for, and it is the oldest thing on the LOOK-LIST.** JS backed every file up at its open (`../save-backups/JS-20261109-115706`) and held each at its open md5 to its close.
- **§0 — THIS FILE's CEILING IS 520 KiB** (the preamble, where HY set it and JJ raised it): the routing bounds what a batch reads, so a ceiling on the whole file prices a read nobody takes — JR read 286,191 B of 449,926 and derived which part; the 80 KiB the raise adds is about 5.6 batches at JG's 14,605 B written. The archive's method is untouched.
- **§1 — THE FROZEN PLAINS, A SECOND CANDIDATE AT SLOTS 1 AND 3** (THE FROZEN PLAINS): roster 4 as the opener and roster 5 as the finale, the Icewrought Titan its boss, sixteen slots like every zone; the Scarlands keeps slot 2 alone and the run stays three zones. **Every run draws a slot of two at random — a player's and a sim's alike** — so a run is one of four shapes (JS's ruling 1); `DOD_ZONE_ROTATION=0` holds a sim to each pool's first. **The twelve kinds tagged for all three old rosters take both new ones**; roster 4 holds 16 kinds and roster 5 19, and each fields four to six bodies in about two fight nodes of three, as the old rosters do. **The Frozen Plains wears the Forest's backdrop**, a placeholder named on the LOOK-LIST.
- **§2 — SIX KINDS**: the Frostbitten Thrall, the Icebound Bulwark and the Hailcaster in both rosters; the Rimehorn, the Sleetveil Matron and the Stillwrought in the finale's — each resisting frost, soft to fire, slower and more armoured than the kind it stands for; each second move the least whole damage that clears JI's line, every cooldown its band; Slowed, Dazed over every ally and Sap their riders, no status new. **The Stillwrought is Sap's second carrier** and **the Sleetveil Matron heals and Raises** on the warband's Malice. The line's reference board stands, so no existing kind's band moved.
- **§3 — THE ICEWROUGHT TITAN** freezes one hero with Entomb, a frost blow at the line: the hero loses a turn; a Block or a miss lays nothing, Ironclad and Hallowed refuse it, and a cleanse lifts it. No rung tag.
- **§4 — THE COUNT**: 62 fights where the warband attacks, of the 342 the battery's logs hold (`docs/reports/JS-count.tsv`): every JS kind fielded, Healing Wave and Frozen at nought and each driven by `check_js` — THE FROZEN PLAINS says which and why.
- **§5 — WHAT STANDS, UNTOUCHED** (`check_js` §5 holds it, beside `check_jr` §1 and §5, `check_jq` §5 and `check_jp` §3): no drain rides a blow and no field joined `Ability`, so **the reserve bug JP found stands as found** (FOUND AT JP); **the Break price**, a point at a hero turn's damage over the Break meter (35.15 over 101.25, 0.3471), and the nine bands held at the data's figure; **the hexes, as they stand**: Gall cuts the healing every hero receives by 50% for 3 turns; Sap cuts what a hero's resource bar gains by 50% for 3 turns; Mire makes a hero act 25% slower for 3 turns; Fester deals 3% of its applier's Attack a stack at each of the hero's turn starts and gains a stack each turn, until it is cleansed. **Malice's three terms and its cap** stand, and **the spends' prices stand: a Raise the health it stands a body up with, a Rally 40 and an Entrench 30, flat.** **Communion stands as JH left it** — *While every hero who stands wears 2 or more core runes, every hero deals 37% more strike damage*. Forsake, Read the Tell and the aiming cleanse stand as JQ built them. No dial pulled; no existing kind moved but its two roster tags; the deck is closed at twenty-five.
- **THE ROUTING** (`docs/reports/JS-routing.md`): the brief's seven subjects matched 65 rows, 4 population rows and one block the brief named by its words — with the core's 15 and the 16 blocks the population rows add, 97 blocks, 291,772 B of HEAD's 448,127.
- **THE INSTRUMENTS.** `check_js` is new (§0–§6). **Twelve gates that read the warband its batch left are re-pointed at their own intent**: the digests (`check_ji` §4, `check_jn` §1, `check_jo` §1, `check_jp` §3, `check_jq` §5, `check_jr` §1) and the counts and kept tables (`check_jj` §7, `check_jk` §1 and §4, `check_jl` §2 and §4, `check_jm` §0 and §4, `check_jp` §1, `check_jo` §1's kit rows) each name JS's seven kinds and two rosters (`ADDED_SINCE`, `ROSTERS_SINCE`) and read them apart; `check_jr` §1 names Sap's second carrier and the Titan; `check_ji` §1f reads a name two cooling moves share at every place the record states it; `check_jj` §1 holds the ceiling at 520 KiB; and `check_iv` §2's latent arm and `check_iw` §0.3 ask the player's door. The digests' and the counts' are recorded at both ends (THE CROSS-TARGET SUPERSESSIONS); the rest where each rule stands.
- **THE VERIFICATION** — `docs/reports/JS.md` §6.
- **`CLAUDE.md`, READ AT JS's OPEN AND ITS CLOSE**: 511,021 B at the open and 511,063 B = 499.08 KiB at the close, against its 510 KiB ceiling — **10.92 KiB UNDER** (+42 B written at JS): 2.1 batches at JG's +5,329 B.
- **`docs/state.md`, READ AT JS's OPEN AND ITS CLOSE**: 448,127 B at the open and 461,660 B = 450.84 KiB at the close, against its 520 KiB ceiling — **69.16 KiB UNDER** (+13,533 B net at JS, this line included; **the archive took 4,657 B** — JR's answered rulings, and FOUND AT IW's item the door closed — so JS wrote 18,190 B): 4.8 batches at JG's 14,605 B written.
- **JR's PROJECTED FOR JS, CHECKED**: JR read that at JG's writing JS would close with 5.75 KiB of room in `CLAUDE.md`, and in this file 11.89 KiB past its 440 KiB ceiling; **JS closes with 10.92 and 69.16, the second against 520 KiB**. JS stated its own writing before any document edit (`s1/EXPECTED_WRITING.md`): +0 KiB for `CLAUDE.md` within 0.5 KiB, and for this file about +14 KiB written and about 4 KiB archived; it wrote +0.04 KiB there, and here 17.76 KiB written and 4.55 KiB archived, +13.22 KiB net, against about +14, 4 and +10.
- **PROJECTED FOR JT**: the room at JS's close, less what JT expects to write, against each bar (the condition's rule, `docs/instrument-rules.md`): `CLAUDE.md` 10.92 KiB of room, 2.1 batches at JG's +5,329 B; `docs/state.md` 69.16 KiB, 4.8 batches at JG's 14,605 B written. At JG's writing JT would close with 5.71 KiB of room in `CLAUDE.md`, and in this file 54.90 KiB of room under its 520. **JT's brief states its expected writing, or JT states its own before the work; its condition reads the room less that.**
- **No save version moved**: a run saved in the Frozen Plains carries `frozen_plains` in its `zone_draw` and the new kinds' ids in its map — values a build that knows them reads, and a key no older build writes away (IB §0.2's rule); an older build reads the zone as its slot's first candidate and an unknown kind as an Orc Raider (`Enemies.config`'s fallback), so a JS save opened there plays the Forest with raiders where the frost kinds stood (FOUND AT JS).
- **Phase.** The merge's running order stays complete; the branch is not merged. **Do not open a `class-merge` save in a build older than HL**: HL's ceiling refuses a newer save from HL's build on — HR's v15 is the first bump it has guarded — and HJ's and HK's builds, and `main`, carry no ceiling. **Tag `b722cc4` before merging** if the pre-merge game should stay one checkout away; nothing tags it today (HA's advice, its block archived at JH §3).
- **Next: the rulings below, and the Frozen Plains in play** — its four shapes, its placeholder backdrop and the Titan's freeze are on the LOOK-LIST. A Forest→Scarlands→Forest run still meets the Withered Warden twice, and a Frozen→Scarlands→Frozen run the Icewrought Titan twice — named and left (a second boss for a zone that hosts two slots is the next cheap fix). The content hole is closed for eight of its eleven kinds (FOUND AT JN); the Orc Shaman, Shieldmaster and Ritual Chanter still attack with a basic alone, and the Sleetveil Matron is a fourth by construction; the Hollow Crown's Sundering Decree sits under the line (FOUND AT JO).

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION
### JS's RULINGS OWED — **SEVEN; THE BATCH's CHOICES FOR THE DRAW, THE SIX KINDS, THE TITAN, THE BACKDROP, THE CORE THAT TRAVELS AND THE FOREST's EVENTS, EACH TAKEN ON THE RECOMMENDATION, NONE HOLDING ANYTHING UP**

Full working: `docs/reports/JS.md`, NEEDS A RULING.

1. **THE DRAW IS THE GAME's: A SLOT OF TWO DRAWS FOR EVERY RUN (JS §1).** Since IW §0.3 the flag was the sim's and a player's run took each pool's first, so the Frozen Plains would be a zone no player draws (`check_iv` §2's latent arm reds the day a pool holds two). **Taken**: `Run.draw_zones` draws within a pool of two for a player's run and a sim's alike; a pool of one takes its zone with no die; the flag's one arm left is a sim's `DOD_ZONE_ROTATION=0`, holding it to each pool's first, which a player's run never reads. The draw spends two dice at a new run, so every seeded gate that starts one rolls its fights anew. **The alternatives**: the fixed order for the player (the Frozen Plains never met), or the Frozen Plains first in its pools (the Forest never met). **Reversing it** is `rotation_enabled`'s line and `draw_zones`' condition, and `check_iv` §2's and `check_iw` §0.3's arms.
2. **THE SIX KINDS' FIGURES AND NAMES (JS §2).** Health, armour, speed, tint and scale set against the kind each stands for (the Whelp, the Shieldmaster, the Slinger, the Orc Brute, the Orc Shaman, the Orc Hexer) — by one rule, `check_js` §2's: the first kind in data order of its role, power and enemy role that the Forest's opener roster fields, one that does not travel (not tagged for every old roster) before one that does; against every kind of its role it is not so (the Orc Raider beside the Thrall is slower and more armoured still, the Orc Archer as armoured as the Hailcaster); each basic off its role's Attack; each second move the least whole damage that clears JI's line; every cooldown the line's band; the riders' turns after the moves that already lay them; the moves' names, swept with no exact hit. **The healths and basics straddle the line's reference board** (its median body 127.5, its median basic 36.595), so no existing heal or spend is priced anew. **The Matron heals with the warband's Healing Wave**, the name `_enemy_support_action` casts by, and **holds an Entrench beside its Raise**, as the other Raise holders do — the brief's *Raise* alone reds `check_jk` §1, which every kind's Rally or Entrench answers. **The alternative**: figures that move the medians, and existing bands with them. **Reversing it** is the seven blocks of `data/enemies.json`.
3. **THE RIMEHORN's *TELEGRAPHED CHARGE* IS A DECLARED BLOW, NOT A WIND-UP (JS §2).** Every warband move is declared on the plate a turn ahead, and one whose Break exceeds its damage is declared a *crush*: Trampling Charge is one. **The alternative**: the Ash Hurler's `windup`, whose chip says *heavy damage to every ally*, false on a single blow without a handler line changed. **Reversing it** is the move's `special` and the chip's line.
4. **THE TITAN's FIGURES (JS §3).** A freeze of one turn, the ordinary freeze's, on Entomb, a single frost blow at JI's line (cooldown 2); Glacier Fist its basic, Entrench its spend; 460 health, armour 0.32, speed 75, Attack 100, the tank's role as the Withered Warden's — slower than it and less armoured (0.32 against 0.35): the six's signature is theirs, not the boss's — scale 4.4 as the zone bosses'. **The alternatives**: a longer freeze, or a heavier Entomb in a longer band. **Reversing it** is the Titan's block.
5. **THE FROZEN PLAINS WEARS THE FOREST's BACKDROP (JS §1).** No art exists; the battle's, the map's and the event screen's dicts name the zone against the Forest's art — the cooler of the two, and each dict's fallback — with a comment saying it is a placeholder. **The alternative**: the Scarlands' red. **Reversing it** is three strings; the art is the designer's.
6. **THE CORE THAT TRAVELS IS EVERY KIND TAGGED FOR ALL THREE OLD ROSTERS, THE ORC CHIEF AND THE HOLLOW CROWN AMONG THEM (JS §1).** The brief's derivation read literally: twelve kinds. The Orc Chief is fielded by the elite themes from any roster that tags him, so the Frozen Plains' elites field him; the Hollow Crown is never composed, so its two tags read nothing. **The alternative**: the ten drawn kinds alone, which leaves the Frozen Plains' elite nodes no elite, so `compose` falls to its plain fallback at an elite's pay. **Reversing it** is two `zones` arrays — and JR's ruling 1's reversal now takes rosters 4 and 5 off the Grave Totem and the Rot Behemoth too.
7. **THE FOREST's TWO EVENTS NAME THEIR ZONE (JS §1, the fifth thing a zone keys on).** The Old Spring and the Echo of the Warden were dealt by slot because a slot was a zone. **Taken**: a `zone` requirement in `Events.failed_reason`, read off the run's own draw (`zone_draw`), the two keyed to the Forest beside their slots. **The alternative**: the Forest's words dealt in the Frozen Plains. **Reversing it** is the clause and the two `zone` keys.

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
  and the Hunter 0 of 65** — the opposite of IE's and IF's sim (THE CLERIC's MANA RATE, below). The rate is unmoved (since JN §0 a Cleric gains 50% less in a fight).
- **BOIL OVER WAS NEVER DRAFTED**, so its rate is still unfelt; the question is its availability, not its figure (BOIL OVER'S
  RATE, below).
- **FOUND, UNASKED — RECORDED, NOTHING CHANGED (one run, one party):** **the Sharpshooter dealt 42.2% of the run's damage**
  (3,396 of 8,053; at the boss 988 of 1,955, his best turn 339); **the Berserker dealt 18.2%** (1,468), his `low_water` 0.00 in all
  ten fights and **22.9% of his costed turns hard-dry** (11 of 48).

### THE BARGAIN DECK's GRADES — **THE SHARPER READING OF ONE POPULATION REPLACES THE BLUNTER, SINCE IZ, AND TWO OF ONE INSTRUMENT ARE POOLED, SINCE JE; EVERY MODIFIER CARRIES A SEVERITY, TWO LEFT THE DECK, FOUR JOINED IT AT JB, GRADE 4 HOLDS THREE, AND THE DECK IS CLOSED AT TWENTY-FIVE**

**THE MODIFIERS THAT COST NOTHING ARE THE WORK; THE REST ARE A SCALE, NOT A RE-CUT (IX §0.1, the designer's).** IW's ladder showed the deck's costs a step a little under double the last above its cheapest level; so a grade is a band of cost, and only the ones with no cost to band are design work. **Since IZ none is left**: three had never been free (the price, below), Leaden's (Frenzied's then) re-key costs, Muffled costs its own population, and Dull Edge and Tinderbox left the deck.

**THE SCALE (IX §3, RE-DERIVED AT IZ §1; the rule is `CLAUDE.md`'s ladder block, and the comment above `Run.MODIFIERS` states it too).** What a modifier costs the reference party's health at a bargain fight's end, against the same party with no modifier, in points of its maximum health: **no severity under 0.48; 1 to 1.78; 2 to 3.74; 3 to 6.88; 4 to 12.22; 5 from 12.22**, centred at **1.00 / 2.56 / 4.92 / 8.84 / 15.59 or more**. **The reference party**: the sim's default four — the Berserker, the Cryomancer, the Devout and the Beastmaster — untalented, at Wanderer, seed block 38. **The test binds** (IY §0.1): a cost inside two of its paired standard errors is no cost. **The grade is the highest cost measured, on any population** (IY §0.3), each test-bound, and only a reading of the modifier as it stands; every row of `Run.MODIFIERS` names the population and the batch its grade came from (`graded`). **THE SHARPER READING OF ONE POPULATION REPLACES THE BLUNTER (IZ §0.1, the designer's)**: two populations are two facts and the grade takes the higher; two readings of one population are two estimates of one fact, and the fight-seeded reading replaces the run-seeded one. The derivation takes them the same way: ten of the levels' twenty-three readings are sharper ones now, levels 1–3 cost -0.04 / 1.00 / 2.56 (IX: 0.04 / 0.93 / 2.48), and the cut between 1 and 2 moved +0.08, between 2 and 3 +0.04, the rest not at all — no grade crossed a moved cut (`docs/reports/IZ-scale.tsv`). **Two readings of one population on one seed block are named as correlated (JF §0.1, in JG §0.1's words): the eight read the old way are named in `CLAUDE.md`'s ladder block, all settled.** **Two readings of one quantity on one instrument are pooled, not chosen between (JE §0.3, the designer's, a refinement beside that rule in `CLAUDE.md`).**

**A POINT IS A PERCENT OF THE HEALTH OF A PARTY THAT OPENED WITH NO RELIC (JF §2; `CLAUDE.md`'s ladder block).** Every grade is a modifier against *none* on one tree, so the grades stand; what rests on the default is the absolute scale (row DV34). The bot also wears the first crest rune it draws (row DV35), on the same answer.

**THE PRICE OF THE TWENTY-SEVENTH NOTE (IZ §1): 4 OF THE 11 MODIFIERS IX CALLED FREE WERE UNDER THE OLD INSTRUMENT's REACH** — Slick Footing (+0.71 ± 0.28), Fleeting (+0.92 ± 0.26), Bloodletting (+0.80 ± 0.30, IY's control C02d) and Brittle on the reference party (+2.00 ± 0.35), each re-read at IX's own value on the fight-seeded instrument. Three stayed free — Hoarfrost (-0.45 ± 0.32), Deadened (+0.40 ± 0.29) and Frenzied at 1.3 (Leaden's multiplier then; -0.05 ± 0.05, IY §1) — and four could not be re-read at IX's values, their handles moved at IY (Dull Edge, Parched, Tinderbox, Muffled). The brief counted three; the fourth is Brittle, whose grade was already the incumbent's.

**THE BASELINE IS AN ARM (IX §1).** Run-seeded, IX's *none* arm read 0.944 ± 0.005; fight-seeded it reads **0.934 ± 0.006** on IZ's re-driven arm (60 runs, 52 completed) — a tie with IY's 0.934. The incumbent's *none* arm (IG's three, talented, Ruin) reads 0.953 ± 0.004 and the fire party's 0.935 ± 0.006; every arm is paired against its own population's baseline.

**THE RE-READS (IZ §1)** — the old values and the cheap end, sixty runs each, fight-seeded, paired (the ratio is the paired error over the unpaired):

| modifier — the value read | the reading it replaces | IZ's reading (fight-seeded, paired) | z | ratio | the tie | band |
|---|---|---|---|---|---|---|
| Slick Footing — 0.5 | +0.75 ± 0.71 (IX §1, run-seeded) | **+0.71 ± 0.28** | +2.52 | 0.351 | z -0.06 | **1** |
| Fleeting — 1 | +0.41 ± 0.62 (IX §1, run-seeded) | **+0.92 ± 0.26** | +3.57 | 0.302 | z +0.76 | **1** |
| Hoarfrost — 3 | +0.51 ± 0.60 (IX §1, run-seeded) | **-0.45 ± 0.32** | -1.39 | 0.433 | z -1.41 | **—** |
| Encumbered — as it stands | +0.74 ± 0.32 (IY §1, fight-seeded) | **+1.09 ± 0.31** | +3.48 | 0.412 | z +0.79 | **1** |
| Feverish — as it stands | +2.42 ± 0.75 (IX §1, run-seeded) | **+3.15 ± 0.38** | +8.39 | 0.395 | z +0.88 | **2** |
| Warded — as it stands | +2.54 ± 0.88 (IX §1, run-seeded) | **+1.96 ± 0.31** | +6.36 | 0.336 | z -0.62 | **2** |
| Deadened — as it stands | +0.54 ± 0.58 (IX §1, run-seeded) | **+0.40 ± 0.29** | +1.38 | 0.373 | z -0.21 | **—** |
| Brittle — as it stands | +0.75 ± 0.66 (IX §1, run-seeded) | **+2.00 ± 0.35** | +5.75 | 0.380 | z +1.67 | **2** |

**TURNING NINE HANDLES TO ONE TARGET MEASURES NINE SLOPES (IY §0.2, the designer's)** — IY's slopes are its record (archived with its grades block). **The placing (IZ §2) used them and §1**: a handle §1 found never free went back to its old value, the measurement kept (Slick Footing 0.5, Fleeting 1, Bloodletting 15); a handle that stayed free at its old value kept IY's (Hoarfrost 9, Parched no resource, Muffled half). Each is a `Run` constant its words format.

**A HANDLE WITH NO REACH CANNOT BE TURNED INTO A COST AT ANY VALUE (IY §3)** — Leaden's multiplication (Frenzied's, then) was one: a factor on every speed rescales the timeline and moves no turn's order. **RE-KEYED AT IZ §4 TO AN AMOUNT**, which moves the order (`check_iz` §4 drives a real board), and which way it cuts was measured, not derived:

| the arm | the amount on every speed | the cost | z | the verdict |
|---|---|---|---|---|
| the add | +30 | **+0.02 ± 0.28** | +0.08 | tie |
| the add at ten times, to read its sign past the noise | +300 | **-0.70 ± 0.29** | -2.46 | pays |
| the subtraction | -30 | **+0.60 ± 0.26** | +2.32 | costs |

**THE POPULATIONS THEIR RULES NAME (IZ §5, §0.3).** A modifier keyed on what only some builds do is graded on a build that does it; one keyed on what every build does that still costs nothing leaves the deck. **The fire party is derived** (probe part five, ten runs each, `docs/reports/IZ-fire.tsv`): the reference party lands 5.3% of its strike damage as fire, the default four with the Pyromancer for the Cryomancer 15.9% — the most of the two, three times — and the warband 3.6% and 4.5%.

| modifier | the population its rule names | its *none* arm | the cost | z | the verdict | in the deck |
|---|---|---|---|---|---|---|
| Muffled | the incumbent (talented, Ruin, 60 runs) | 0.953 ± 0.004 | **+1.66 ± 0.34** | +4.84 | reach | yes |
| Tinderbox | the fire party (untalented, Wanderer, 60 runs) | 0.935 ± 0.006 | **+0.24 ± 0.23** | +1.01 | no reach | no |

**EVERY GRADE (IZ §2): THE HIGHER OF TWO POPULATIONS' READINGS, EACH THE SHARPEST OF ITS POPULATION, TEST-BOUND.** IW's reading beside each; the reading graded, the incumbent's (IV's, unless named) where it measures the modifier as it stands, the grade, IY's beside it, and the source:

| modifier | IW's reading | the default four's reading graded | the incumbent's | **grade** (IY's) | its population and batch |
|---|---|---|---|---|---|
| Parched | 0.945 | IY §2 +1.90 ± 0.40 (z +4.80) | +0.40 ± 0.66 (z +0.60), not the modifier as it stands | **2** (2) | the default four — IY §2 |
| Leaden | 0.943 | IZ §4 +0.60 ± 0.26 (z +2.32) | -0.55 ± 0.21 (z -2.62), not the modifier as it stands | **1** (—) | the default four — IZ §4 |
| Muffled | 0.943 | IY §2 -0.24 ± 0.22 (z -1.07) | IZ §5 +1.66 ± 0.34 (z +4.84) | **1** (—) | the incumbent — IZ §5 |
| Fleeting | 0.940 | JA §2 +2.29 ± 0.26 (z +8.75) | +0.15 ± 0.61 (z +0.24), not the modifier as it stands | **2** (1) | the default four — JA §2 |
| Hoarfrost | 0.939 | IY §2 +1.03 ± 0.29 (z +3.62) | -0.88 ± 0.58 (z -1.51), not the modifier as it stands | **1** (1) | the default four — IY §2 |
| Deadened | 0.938 | IZ §1 +0.40 ± 0.29 (z +1.38) | +5.23 ± 0.92 (z +5.71) | **3** (3) | the incumbent — IV, graded at IY §4 |
| Brittle | 0.936 | IZ §1 +2.00 ± 0.35 (z +5.75) | +3.34 ± 0.89 (z +3.75) | **2** (2) | the incumbent — IV, graded at IY §4 |
| Slick Footing | 0.936 | IZ §1 +0.71 ± 0.28 (z +2.52) | -0.38 ± 0.57 (z -0.66) | **1** (1) | the default four — IZ §1 |
| Bloodletting | 0.935 | IY's control C02d +0.80 ± 0.30 (z +2.65) | -0.54 ± 0.64 (z -0.84) | **1** (3) | the default four — IY's control C02d |
| Encumbered | 0.927 | IZ §1 +1.09 ± 0.31 (z +3.48) | +0.04 ± 0.58 (z +0.07) | **1** (2) | the default four — IZ §1 |
| Feverish | 0.920 | IZ §1 +3.15 ± 0.38 (z +8.39) | +2.42 ± 0.65 (z +3.72) | **2** (2) | the default four — IZ §1 |
| Warded | 0.918 | IZ §1 +1.96 ± 0.31 (z +6.36) | +0.21 ± 0.53 (z +0.40) | **2** (2) | the default four — IZ §1 |
| The Thin Veil | 0.896 | IX §1 +4.75 ± 0.70 (z +6.78) | +4.85 ± 0.81 (z +5.98) | **3** (3) | the incumbent — IV, graded at IY §4 |
| The Long Silence | 0.895 | IX §1 +4.88 ± 0.56 (z +8.76) | +2.13 ± 0.61 (z +3.51) | **3** (3) | the default four — IW, graded at IX §3 |
| Miasma | 0.892 | IX §1 +5.14 ± 0.72 (z +7.19) | +5.46 ± 0.78 (z +7.03) | **3** (3) | the incumbent — IV, graded at IY §4 |
| Rot | 0.857 | IX §1 +8.66 ± 0.83 (z +10.43) | +3.40 ± 0.69 (z +4.92) | **4** (4) | the default four — IW, graded at IX §3 |
| Overgrown | 0.854 | IX §1 +9.03 ± 0.92 (z +9.80) | +10.54 ± 1.11 (z +9.48) | **4** (4) | the incumbent — IV, graded at IY §4 |
| Mirrorbound | 0.788 | IX §1 +15.59 ± 0.98 (z +15.86) | +25.72 ± 1.66 (z +15.49) | **5** (5) | the incumbent — IV, graded at IY §4 |
| Thin Air | 0.734 | IX §1 +21.03 ± 1.38 (z +15.21) | +2.31 ± 0.74 (z +3.12) | **5** (5) | the default four — IW, graded at IX §3 |
| Bloodless | 0.702 | IX §1 +24.22 ± 1.02 (z +23.70) | +21.26 ± 1.19 (z +17.89) | **5** (5) | the default four — IW, graded at IX §3 |
| Wasting | 0.579 | IX §1 +36.53 ± 1.51 (z +24.14) | +26.26 ± 1.66 (z +15.78) | **5** (5) | the default four — IW, graded at IX §3 |
| Fractured | — | JB §3 +0.86 ± 0.29 (z +2.95) | JB §3 +0.33 ± 0.21 (z +1.54) | **1** (—) | the default four — JB §3 |
| Porous | — | JB §3 +2.09 ± 0.31 (z +6.69) | JB §3 +0.57 ± 0.19 (z +3.05) | **2** (—) | the default four — JB §3 |
| Outpaced | — | JB §3 +1.13 ± 0.30 (z +3.72) | JB §3 +2.10 ± 0.51 (z +4.11) | **2** (—) | the incumbent — JB §3 |
| Ambushed | — | JB §3 +6.67 ± 0.67 (z +9.89) | **pooled +12.149 ± 1.23** (JE §2, of JB §3 +12.02 ± 1.20 and JD §5 +12.34 ± 1.46, one seed block, r 0.77) | **4** (—) | the incumbent — JB §3 and JD §5, pooled at JE §2 |

- **THE GRADES STAND ON A RETURN THAT MOVED AT JD, AND ONE ARM ANSWERS FOR THE DECK (`docs/reports/JD-arm.tsv`)**: Ambushed at 8, a tie on both populations (+7.23 ± 0.77 against +6.67 ± 0.67; +12.34 ± 1.46 against +12.02 ± 1.20), so no grade moved, the second printing over its cut inside the test, and pooled at JE (below in the table). **JE moved the return again, by a relic's share and the third boss, and read it**: Ambushed on JE's tree is +7.27 ± 0.77 and +12.16 ± 1.41, a tie with JD's arms by seed (+0.04 ± 0.09, -0.18 ± 0.14), 21 of 1,209 bargain fights moved, none past the cut (`docs/reports/JE-ambushed.tsv`). It is not pooled, JE's tree being another instrument, and it moved no grade. **The completion figures were not re-taken**: every completion in this file before JD's was read on the old return, and every one before JE's with no restore at the third boss. JD's arms finished 55 and 58 of 60 with no modifier (JB 57 and 59) and 46 and 32 under Ambushed at 8 (JB 50 and 36): 202 to 191 of 240, every arm down. **On JE's tree they read 55, 58, 46 and 37**, 196 of 240: under Ambushed the end boss took none of the incumbent's runs where it took five on JD's tree; four of the five finished, the fifth fell a fight sooner, and a run JD lost at the third boss finished.
- **THE GRADES HOLD** none 0; 1 7; 2 7; 3 4; 4 3; 5 4, **AND THE DECK IS CLOSED AT THAT TALLY (JC §0.1, the designer's)**: nothing comes off, nothing more goes on, and the shape it was first aimed at is retired (`CLAUDE.md`'s ladder block; `docs/design-notes.md` keeps it). **Moved since JA**: the four joined, each by its readings (JB §3, below); no other grade moved, and Fleeting at 3 stands (JA §2, below). **Grade 4 holds health and tempo** — the axes (THE SHARE CENSUS, below). Every reading and the bands each gives: `docs/reports/JB-grades.tsv` (JA's `JA-grades.tsv` its record).
- **ENCUMBERED BINDS BOTH SIDES SINCE JI (JI §2).** Its branch stamps every unit on the field, and sixty-three of the warband's moves cool now (JI's eleven, the Bellow, JK's spends, JN's nine raises, JO's three, JS's fifteen), so it lengthens theirs too. Its three readings — +0.74 ± 0.32 (IY §1), +1.09 ± 0.31 (IZ §1) and the incumbent's +0.04 ± 0.58 — were read on a warband with no cooldowns, as every grade here was, **and as every sim figure this file holds from before JI was**: the crest pool's uptimes and Communion's 37%, which stands by a hair (JH's ruling 3, accepted at JJ §0), Sanctity's step, the Cleric's mana rate, Boil Over's rate, the IW re-takes and every completion figure among them. They stand as they were taken, and are stale — and every figure before JJ was read on a warband whose heals cost nothing, and every one before JK on a warband that bought nothing else; and every one before JS on a run of one shape, Forest, Scarlands, Forest, which `DOD_ZONE_ROTATION=0` replays. **Its new half lengthens the warband's best moves, so on the share census's own prediction it takes from the pressure on the party, and re-read it could fall toward free.** No grade moves here: the arc's fifth batch re-reads the deck with everything the warband gains (JI's ruling 5, accepted at JJ §0) — **JM's brief narrowed it to the five cards the arc reaches by name, and JM §3 read them on the tree that lands** (THE ARC, READ WHOLE; JM's rulings 7 and 8, accepted at JN §0): None of the five reads a band other than its grade on the tree that landed at JM, so by the brief's own argument the twenty not read hold too, and the deck survives the arc; the arc moved Fleeting's cost by −0.80 ± 0.39 (z −2.07) past two errors, inside its band; Fleeting at 1.78 and Encumbered at 1.78 read at a tie with a cut, named and not resolved; and on its own arms Thin Air's completions fell 23 → 14 of 60 (paired −0.150 ± 0.052 (z −2.87)) across the arc, the one card arm past two errors on completions — its cost read over fewer bargain fights a run, named and not a grade. The twenty not read keep their stale marker.
- **THE FOUR, EACH ON BOTH POPULATIONS (JB §3).** Sixty runs an arm, fight-seeded, each paired against its own re-driven *none* (the default four 0.939501 ± 0.004768, 57 of 60 completed; the incumbent 0.953368 ± 0.004352, 59 of 60), the grade the higher reading (IY §0.3). **Ambushed at 8**: +6.67 ± 0.67 and +12.02 ± 1.20, **a 4**, 0.20 under the cut to 5, the pooled reading 0.068 under it (JE §2) (at 9, +9.03 and +15.07, a 5; at 11, +15.47). **Outpaced**: +1.13 ± 0.30 and +2.10 ± 0.51, **a 2**. **Porous at 0.4**: +2.09 ± 0.31 and +0.57 ± 0.19, **a 2**. **Fractured at 0.0**: +0.86 ± 0.29 and a tie, +0.33 ± 0.21, **a 1**. **Inverted paid, -1.08 ± 0.32**, and left the deck for §2b's reserve (its shape and reading in `docs/design-notes.md`). Every arm: `docs/reports/JB-arms.tsv`.
- **FLEETING AT 3, IN THE DECK (JA §2).** Sixty runs, the reference party, fight-seeded, paired against a re-driven *none* arm on JA's deck (0.941 ± 0.004, 58 of 60 completed; a tie with IZ's 0.934, z 0.93): **+2.29 ± 0.26 points** (z 8.75, ratio 0.416) — **a 2**; IZ's lever point, taken on IY's deck, read +3.10 ± 0.32 — **a tie by the test, at its edge** (z -1.98) — and the in-deck reading is the grade's (`docs/reports/JA-fleeting.tsv`). A bargain fight under it runs 1.97 hero turns longer and the party heals 37.7 less in it. **Its words are the code's, by the designer's choice**: *Every status applied lasts 3 turns less (never below one).* — the brief's *every effect lasts one turn* is not the rule (THE SHARE CENSUS: 8.2% of the party's statuses laid for a positive count run five turns or more, and the battle-long ones are untouched).

**THE BANDS, READ AND NOT RE-SET (IZ §0.4).** Wanderer's safe band (1–2) holds 14; Wanderer's gamble band (3–4) holds 7; Warden's safe band (1–3) holds 18; Warden's gamble band (4–4) holds 3; Ruin's safe band (3–4) holds 7; Ruin's gamble band (5–5) holds 4; Ruin's fixed encounters draw from 6: the 7 of severity 3–4 less Ambushed, which carries `opening_burst` (JC §0.6) — Deadened, the Long Silence, the Thin Veil, Miasma, Rot and Overgrown. **Warden's gamble band held 2 — Rot, Overgrown — when IZ kept it, and holds 3 since JB, so an offer deals two of Rot, Overgrown and Ambushed**: IZ's two arms, driven on the deck of two, the reference party at Warden, natural, sixty runs each, fight-seeded, paired:

| the arm | Warden safe / gamble | holds | its reading (60 runs, bargain fights) | against *now* |
|---|---|---|---|---|
| the bands as they stand | 1–3 / 4–4 | 15 / 2 | 0.655 ± 0.019 (370) | — |
| Wanderer's bands | 1–2 / 3–4 | 11 / 6 | 0.713 ± 0.015 (372) | **+5.78 ± 2.16** (z +2.68): milder |

**A tie would have moved the band; materially milder keeps it.** Under Wanderer's bands the gambles the bot took at Warden spread over six (Rot 100, Overgrown 97, Deadened 42, the Long Silence 38, Miasma 31, the Thin Veil 27; 372 bargain fights), where now they are two (Rot 158, Overgrown 143; 370). One run of sixty completed in each arm.

**THE SWING BETWEEN THESE TWO (IX §4)** is IX's and IY's record, archived with IY's grades block; its words were not rewritten (IY §0.3). On IZ's readings the widest is Deadened: free on the default four, 3 on the incumbent.

**WHAT THE GRADES ARE, SAID WHERE THEY ARE READ.** One party's, or the incumbent's where it pays more, through the bot — which books 2.2 times a player's status events (THE FIRST CLEAN PLAYTHROUGH) and whose ally pools are heroes-only (a constant bias every figure here was taken through, IS §4). Every figure: `docs/reports/IZ-reread.tsv`, `IZ-scale.tsv`, `IZ-rekey.tsv`, `IZ-fire.tsv`, `IZ-populations.tsv`, `IZ-band.tsv` and `IZ-grades.tsv`; IY's, `docs/reports/IY-seeding.tsv`, `IY-reach.tsv`, `IY-handles.tsv` and `IY-grades.tsv`; IX's scale and arms, `docs/reports/IX-scale.tsv`, `IX-onesided.tsv` and `IX-swing.tsv`.

**THIN AIR, RE-READ AFTER THE CLERIC's CUT, STANDS WITH JN's READINGS** (WHAT THE RAISE DID, AND THE GAME WITH TALENTS; JN's ruling 8, accepted at JO §0): +17.86 ± 1.14, band 5, its grade 5 — recorded, not repaired; **the deck's own *none* fell beside it**, so every other grade is stale on the tree that lands.
### THE SHARE CENSUS — **WHAT EACH SIDE PRODUCES OF EVERY QUANTITY A RULE CAN KEY ON (JA §3), AND THE DECK's AXES CROSSED WITH IT (JA §4); A SHARE SAYS WHOM A RULE TOUCHES, NOT WHETHER IT COSTS**

**What it is.** IZ's probe five read the strike ledger's fire against all; JA's part six reads every ledger a rule could key on — BL's damage door (the source off the frame), the tick door, the hero strike loop (blows, hits, crits, fire, armor's cut), the miss rolls and Block, the heal door, a barrier's absorb, Break at `take_hit`, Bleed, deaths, the status door (before Fleeting's term, sorted by whom a status pays off `DEBUFF_IDS` and `DISPEL_NEVER`), cooldowns, the line every cast pays at, the turn-start drip, every turn handed out (its actor's speed and maximum health) and the bodies standing as a fight opens — **read-only, no modifier stamped** (`DOD_IV_FORCE=none`), a sum a side printed once a fight, inert by a census-on, census-off pair (4,054 probe lines identical). **Both parties the project measures on**: the reference party (untalented, Wanderer, 20 runs, 559 fights, 234 of them bargain fights) and the incumbent (IG's three parties, talented, Ruin, 60 runs, 1,658 fights, 698). **The population is derived**: every quantity a live modifier keys on — each of the 21 has its row — and the doors' others. Kept: `docs/reports/JA-shares.tsv` (one row a quantity, both sides, both parties, all fights and bargain fights), `JA-durations.tsv` (the status door's durations, Fleeting's population) and `JA-axes.tsv`. **What it cannot see**: the strike ledger is the blow computed (before a barrier — the party's ate 60,507 on the reference — a death refusal or the vow), it holds no companion's blow and no special resolved outside the loop; the armor row is the loop's site alone; the door's source is the frame's (an unframed blow, 3,263 on the reference, is apart); and every figure is the bot's play, on a party that opened with no relic and wore the first crest rune it drew (DV34, DV35).

**Heroes : warband, what each produced, every fight** (bold: inside 2:1 or the warband's):

| quantity | keyed by | reference party | incumbent |
|---|---|---|---|
| damage dealt (the damage door) | Feverish, the Thin Veil | 6.30 | 7.10 |
| strike damage (the hero strike loop) | Mirrorbound | 3.42 | 4.67 |
| tick damage, dealt | — | 4.34 | 4.53 |
| hits landed | Bloodletting | **1.89** | 2.89 |
| crits | — | 3.07 | 10.48 |
| fire-typed strike damage | — | 5.44 | 14.16 |
| armor's cut, held | Brittle | **0.31** | **0.57** |
| healing received | Bloodless, Miasma | 7.93 | 15.36 |
| barrier absorbed | — | heroes alone | heroes alone |
| Break damage, produced | Muffled | **1.26** | 4.26 |
| Breaks, produced | Deadened | 2.07 | 25.29 |
| Bleed built, produced | Bloodletting | heroes alone | heroes alone |
| bleedouts, produced | — | heroes alone | heroes alone |
| kills, a companion's death counted | — | 21.09 | 25.72 |
| turns taken | Slick Footing, Hoarfrost | **1.88** | 2.05 |
| mean speed at a turn | Leaden | **1.08** | **1.27** |
| turns weighted by maximum health | Wasting | **1.20** | **1.07** |
| maximum health standing as a fight opens | Rot | **0.67** | **0.59** |
| health standing as a fight opens | Overgrown | **0.65** | **0.56** |
| resource held as a fight opens | Parched | 189.82 | 310.47 |
| resource returned at turn start | Thin Air | heroes alone | heroes alone |
| resource paid for casts | Warded | 41.97 | 49.11 |
| cooldown turns started | Encumbered (both sides since JI; JA's reading, read on a warband with no cooldowns) | heroes alone | heroes alone |
| casts not of slot 0 | the Long Silence | 4.21 | 6.02 |
| casts | Slick Footing | 2.07 | 2.82 |
| misses, made | — | **1.62** | **warband alone** |
| Blocks, made | — | 2.19 | 3.32 |
| status-turns, paying each side | Fleeting | 8.25 | 13.95 |
| status-turns Fleeting at 3 takes | Fleeting | 9.56 | 13.46 |

**THE THREE QUESTIONS, ANSWERED.** **1. What the warband produces more of, or as much of**: the health on the field (it fields 1.5 to 1.8 times the party's maximum health and opening health, both parties), the armor that takes off blows (its armor takes 3.2 times the party's off the other side's blows on the reference, 1.8 on the incumbent), and — inside 2:1 — the turns, the speed at a turn, the turns weighted by health (Wasting's clock), and on the reference party the hits and the Break damage. Everything else the heroes produce twice over or more, and four quantities a live modifier keys on the warband produces none or nearly none of: the turn-start drip (none — Thin Air binds the party alone as the deck plays, JA's RULINGS OWED 1) and cooldowns (none on this census, read on a warband with no cooldowns: since JI eleven of its moves carry one, twelve since JJ and its twenty-four Malice spends since JK and two of its four hexes since JL, three since JM §0 (Gall), and since JO §2 all four ride cooling blows, and since JS §2 the Frozen Plains' seven second moves and eight spends more, and Encumbered binds both sides), the resource held and paid (two Rage kinds; and since JJ a pool, Malice, which no modifier keys on, and which buys a Raise, a Rally or an Entrench since JK). **2. Inside 2:1**: Leaden's speed, Wasting's clock, Rot's and Overgrown's health and Brittle's armor on both parties; Slick Footing's and Hoarfrost's turns, Bloodletting's hits and Muffled's Break on the reference. **3. The sign — A SHARE IS NOT A SIGN**: every one of the 21 live modifiers costs the party. The penalties on what the heroes produce most of cost it, as the three failures suggested (Bloodless, Miasma, Thin Air, Parched, Warded, Encumbered, the Long Silence, Fleeting, Muffled and Deadened on the party whose plan is Break — and Muffled reads free on the reference party, whose Break is inside 2:1); **so do the penalties on what the warband holds more of** (Rot, Overgrown, Brittle) **and both bonuses on the damage the heroes deal six times over** (Feverish, the Thin Veil). The two rules ever recorded paying the party were a payout landing on the party's health in proportion to what it produces more of (the Hungering Dark) and a penalty taking more of the warband's damage into the party than of the party's out (Dull Edge at its floor). **The prediction a later batch can break**: on the party's health at a fight's end, a two-sided rule costs the party when it adds to the warband's damage into the party or takes from what the party absorbs it with, whatever the shares; the share sets how much the party's own output offsets. **The Dark is not the census's limit** — its sign follows its share, because its payout is the instrument's own quantity; Feverish is: the shares alone call it a gift.

**THE AXES (JA §4), RE-DERIVED AT JB §4.** One row an axis, every modifier of the deck on one (`docs/reports/JB-axes.tsv`, `JA-axes.tsv` its record): **health** 4, 4, 5 (Overgrown, Rot, Wasting); **tempo** 1, 1, 4 (Hoarfrost, Slick Footing, Ambushed); **healing** 3, 5 (Miasma, Bloodless); **resource** 2, 2, 5 (Parched, Warded, Thin Air); **damage** 1, 2, 2, 3 (Bloodletting, Brittle, Feverish, the Thin Veil); **recoil** 5 (Mirrorbound); **Break** 1, 1, 3 (Fractured, Muffled, Deadened); **status duration** 2 (Fleeting); **the hand** 1, 3 (Encumbered, the Long Silence); **a barrier** 2 (Porous, new); **the turn order** 1, 2 (Leaden, Outpaced). **Grade 4 holds health and tempo**; healing, resource and recoil reach 5 with no 4; the turn order tops at 2. A share says whom a rule touches: healing, resource, status duration (the warband's Rally and Entrenched aside, since JK, and the hexes it lays on the heroes since JL, on the companions too since JO §2), the hand and a barrier are the party's quantities, so a rule there binds one side whatever it says, which §0.1 permits and the card must not deny — **the hand's cooldowns excepted since JI**, when eleven of the warband's moves took one (twelve since JJ, and its twenty-four spends since JK) and Encumbered came to bind both sides (this census still reads JA's warband).

**THE DIVISOR (JC §0.3, the designer's; the rule is `CLAUDE.md`'s ladder block): THE GROSS, ON THE RIGHT POPULATION, RUNS ABOUT TWO AND A HALF TIMES THE READING.** Each turn of Ambushed's run landed 18.9 at the door, read at nine turns and taken for the other two; Porous's figure is what a barrier stopped eating. Points of the reference party's 821.1 maximum health:

| card | the gross | points | ÷ 2.5 | the gross less the arm's own healing | it read |
|---|---|---|---|---|---|
| Ambushed at 8 | 151 | 18.4 | 7.4 | 6.71 | **6.67** |
| Ambushed at 9 | 170 | 20.7 | 8.3 | 10.01 | **9.03** |
| Porous at 0.4 | 39.1 | 4.8 | 1.9 | 3.86 | **2.09** |
| Ambushed at 11 | 208 | 25.3 | 10.1 | 14.21 | **15.47** |

**THE DIVISOR IS A PRIOR, NOT A RULE (JD §0.4, the designer's; the correction stands beside the rule in `CLAUDE.md`'s ladder block)**: ×1.5 to ×3.8 raw, ×2.3 to ×2.8 once the gross is read on the right population, and it breaks where the healing saturates. **The gross less the arm's own healing is the better account**, Ambushed reading 6.71, 10.01 and 14.21 against 6.67, 9.03 and 15.47, within 0.04 at the value that shipped, and Porous worse, 3.86 against 2.09. **It needs the arm, which is the thing the price was to replace**, so it is a post-hoc account. Porous's extra fifth is unexplained and stays so.

**The last row is where it stops**: at eleven turns the gross is only 1.64 times the reading, because the healing had saturated (+91, as at eight and nine) and past what it can answer nothing is left to divide by. **Three readings behind one divisor, so it is written to be tested, not believed.** Why the axes stop where they stop is the same ladder block (JC §0.4): what the party absorbs with reaches 5, what only adds to the blows stops short, and tempo's one 4 is a burst.

**THE TWO PRICES (JB §3): THE CENSUS NAMES WHO A RULE TOUCHES, AND IT DOES NOT PRICE ONE.** Written from the census's table before the code existed: Ambushed at eight, 10.2 points (it read +6.67 on the party the price was written for); Porous at 0.4, 7.9 (it read 2.09, 26%). **A read-only drive says why** (JA's probe six on the shipping deck, 20 runs an arm, about 230 bargain fights each): **each turn of the run landed almost twice the every-fight mean the price used** (under Ambushed at nine, 170 more at the door over the nine turns, 18.9 a turn against 10.47, though a warband's every turn in those fights landed 13.12 against 9.53), **and the party heals back half to two-thirds of it** (healing +87.8 on the sixty-run arm, +115 on this drive); **and a barrier rarely fills**, so holding two-fifths took 37% off what barriers absorbed (104.6 → 65.5), not 60%, and the party healed some of the rest. A share is what is produced; a cost is the margin left after what the party absorbs.


### THE WARBAND's COOLDOWNS — **JI's LINE, AND SINCE JO §1 A MOVE's BREAK DAMAGE PRICED IN IT ON BOTH SIDES; TWENTY-ONE BLOWS COOL AT ITS BAND (SINCE JS SIX MORE AND A HEAL), AND NINE BANDS IT WOULD MOVE — THREE HEALS', FIVE SPENDS' AND CHIEFTAIN's MAUL's — ARE HELD; AT JI FIGHTS GOT A LITTLE EASIER, AND THE PARTY's FALLS CARRY IT (JI §3) — THE BEFORE FIGURE THE ARC's FIFTH BATCH STARTED FROM**

**THE RULE** (`docs/combat-rules.md`'s intent block; `check_ji` §1a derives it off the data every battery): a move worth 1.4 times its own enemy's basic attack or more takes a cooldown of that enemy's own turns — **2 under 2x, 3 under 3x, 4 past** — and a basic, its kind's first free damaging move (`_cheapest_attack`'s), never one. A blow is priced at its damage and the Burn, Poison or Fester it lays — a Burn's every tick, a Poison's one fewer, since it skips the turn it lands, a Fester's one stack over its clock's three ticks, its growth unpriced — at its kind's Attack, **and since JO §1 its Break damage, a point at a hero turn's damage over the Break meter: 35.15 (JA's census, the heroes' damage dealt over their turns taken) over 101.25 (the reference four's stability × Constitution / 100), 0.3471, never scaled by Attack, as the strike line scales none** (`check_ji.line_blow`, the one blow every gate on the line prices through; JO's ruling 1, accepted at JP §0) — times the heroes it reaches, four for an area blow (a companion standing is not counted); a heal at the health it restores, a whole-warband heal on four bodies; nothing a move denies is priced — a hex, Sunder, Exposed, Cripple, Slowed or Dazed. **The eleven** JI named, the ten JN raised and three that carry a hex since JO §2 — twenty-one blows at the line's band, as it prices them: Siege Stone 9.45 (4), Immolating Wave 3.39 (4), The Long Dark 3.34 (4), Wretched Bellow 2.50 (3), Roots of Wrath 2.16 (3), Hollow Wail 1.94 (2), Heavy Strike 1.83 (2), Skull Crack 1.53 (2), Tyrant's Verdict 1.51 (2), Gall 1.51 (2), Overhead Crush 1.44 (2), Poison Arrow 1.43 (2), Reckless Lunge 1.42 (2), Flame Lick 1.42 (2), Blood Tribute 1.42 (2), Swampy Grasp 1.42 (2), Withering Hex 1.41 (2), Mire 1.41 (2), Ride-by Slash 1.41 (2), Sundering Strike 1.41 (2) and Bone Rattle 1.41 (2); since JS §2 the Frozen Plains' seven, each at the line's band: Hailstorm 1.43 (2), Trampling Charge 1.42 (2), Leaching Stillness 1.41 (2), Entomb 1.41 (2), Glacier Press 1.41 (2), Hobbling Bite 1.41 (2) and the Sleetveil Matron's Healing Wave 1.58 (2); and three heals held at the data's figure, Regenerate 1.96 (3), Dark Vigil 1.92 (4) and the Totemist's Healing Wave 1.66 (3), the line giving each 2. **The ten JN raised, re-derived with their Break priced** (`docs/reports/JO-break.tsv`; JN's raise, `docs/reports/JN-population.tsv`): seven fell under the line at JN's figure and were brought to it — Sundering Strike 48 → 53, Poison Arrow 26 → 29, Withering Hex 62 → 69, Ride-by Slash 51 → 55, Flame Lick 38 → 44, Swampy Grasp 56 → 64, Blood Tribute 42 → 44 — and three still clear where JN put them, Skull Crack 34, Overhead Crush 56 and the Bellow 15, whose band is 3 since Fester rides it; and **the line under them** is the Hollow Crown's Sundering Decree, 0.88, a later move on a kind whose second is at the line (the Shaman's Healing Wave, a heal, sits under it too), while Chieftain's Maul clears at 1.44 once its Break is priced. **Every band the repaired line moves on a move no brief named is held at the data's figure** (`docs/reports/JO-held.tsv`; `check_ji`'s `HELD`): Chieftain's Maul 0, the three heals above, and five spends (JO's ruling 2, accepted at JP §0). **Every kind opens its kit with a free damaging move, so no basic was added.** **Since JK every Malice spend cools by the same line**, priced on its worth against its own kind's basic (`check_jk` §2; THE WARBAND's SPENDS), five of them held since JO. **Since JO §2 every hex rides a blow the line prices** (THE WARBAND's HEXES). The selection reads each counter as it will stand on the turn the move resolves, and the plate's `CD` chip counts it down (JI's rulings 1, 2 and 4, accepted at JJ §0).

**DIAL 2 — JO's SEVEN RAISES, RECORDED, NOT PULLED (JP §0; `docs/reports/JP-dials.tsv`).** **Its exact reversal** is seven keys of `data/enemies.json`, each move's `damage` back to JN's figure: Sundering Strike 53 → 48, Poison Arrow 29 → 26, Withering Hex 69 → 62, Ride-by Slash 55 → 51, Flame Lick 44 → 38, Swampy Grasp 64 → 56, Blood Tribute 44 → 42. At JN's figure each prices under the line (1.26 to 1.36, `docs/reports/JO-break.tsv`) while its cooldown 2 stands, so one of two things goes with it: the seven cooldown keys — the line's band, none, and with them Read the Tell's payoff against the seven (JQ §3) — or the line's half of the reversal JO's ruling 1, accepted at JP §0, names — the basic's Break term out of `check_ji.line_blow` — under which the seven clear and four other bands rise one (the Wretched Bellow, Heavy Strike, Mire and Hollow Wail), with every heal's and spend's multiple (JP's ruling 4, accepted at JQ §0), and Read the Tell's payoff against the four (JQ §3). `check_ji` §1a and §4, `check_jo` §1, `check_jn` §1 and `check_jp` §0 move with it.

**THE READING (`docs/reports/JI-cooldowns.tsv`).** Sixty runs an arm, the reference four untalented at Warden, fight-seeded on block 38, no modifier laid and no crest worn, HEAD against JI by seed, the run the unit. **The eleven were 10.4 of every hundred enemy moves on HEAD and are 6.9 on JI**: Reckless Lunge 1,199 → 705 casts, the Totemist's Healing Wave 233 → 147 (The Long Dark is Ruin's alone, so the drive met ten of the eleven), Dark Vigil 102 → 52, Roots of Wrath 90 → 57; the moves a Rage bar or a wind-up already bounds fell least (Heavy Strike 236 → 208, Siege Stone 32 → 28). No declared move fell back, on either arm. **So fights get a little easier, and the falls carry it**: falls a run 7.30 → 6.27 (-1.03 ± 0.41, past two errors), all of it in the fights a run won (3.48 → 2.50, -0.98 ± 0.39) and next to none in the fight that ended it (3.82 → 3.77, -0.05 ± 0.12), so it is no artefact of a run's length; a paired fight's falls 0.325 → 0.288 (-0.043 ± 0.037); health at a fight's end, paired fights 0.8211 → 0.8279 (+0.62 ± 0.87 points, a tie); completed 3 → 4 of 60 (+0.017 ± 0.029); fights won a run 17.47 → 17.17 (-0.30 ± 0.68). The run's first fight reads a tie, 0.9381 → 0.9367 (-0.13 ± 0.11 points). *A paired level is the mean over the 987 paired fights; its difference is the mean of each run's own, the run the unit, so the two need not subtract exactly.* **The before figure for the arc's fifth batch is HEAD's column** — completed 3 of 60, health at a fight's end 0.8211, falls 7.30 a run. **Why the move is small**: the nine kinds that own one of the eleven threw a third of the warband's moves, and chose one of the eleven 31.3 times in a hundred on HEAD, where nothing held them back, and 20.2 on JI; two-thirds of the warband's moves come from kinds that own none, so a third of the eleven's casts taken away moved little.


### THE WARBAND's MALICE — **ONE POOL FOR THE WHOLE WARBAND, FILLED BY WHAT THE HEROES DO TO IT, AND THE HEALS IT PAYS FOR (JJ §2, §3); FIGHTS ARE NO LONGER AND NOT MEASURABLY HARDER, AND THE POOL BINDS BY WHEN, NOT BY HOW MUCH (JJ §4)**

**THE SENTENCE** (`scripts/battle.gd`, its four constants; `check_jj` §2 drives each term): Malice fills by a point for every 10 points of damage the heroes deal the warband, by 25 when one of its bodies falls, and by a point for every point of damage spent past a body's last. It holds 150. **And the rule it pays**: A HEAL THE WARBAND CASTS COSTS A POINT OF MALICE FOR EVERY POINT OF HEALTH IT RESTORES — so the warband heals a tenth of what is dealt it, 25 a kill (none for a body that dies Forsaken, JQ §1) and the waste, and never more: **it cannot out-heal the party; it can only tax it.**

- **ITS DOORS ARE BL's.** The damage door (`_on_damage_taken`) is read by the frame's side, the share census's: a hero's blow, a companion's, a tick or a mirror the frame credits to one fills it, the remainder of a ten carried; the warband's blow on itself does not. **The door hands on what a blow spends past a body's last since JJ** (`unit._report_taken`'s `past_last`: what it carried less what it removed, when it left the body at zero below every death refusal — the field `overkill` was taken, the Berserker's). Every death of the warband fills a kill's worth at the death door (`_on_unit_died`), whoever dealt it. **Unless the body dies Forsaken (JQ §1)**: the Cleric's Forsake marks one body for 3 turns, and its death fills neither the kill's worth — read at the death door every death passes, a strike's, a tick's, the debug kill's — nor what the killing blow spent past its last, read at the damage door every blow a hero is credited with passes, each while the body still wears its statuses; the damage term stands; a death clears the mark, so a Raised body stands up unmarked. A new damage source that passes neither door fills nothing.
- **IT IS THE FIGHT's.** A battle var, empty at every opening; a quit fight restarts it empty, as it restarts the warband at full strength (GH): nothing the warband or the battle holds rides the save (the party's losses do, GH). What the cap refuses is counted as wasted.
- **THE PRICE IS THE HEALTH THE HEAL WOULD RESTORE ON THE BODY IT NAMES, AND THE CAST PAYS WHAT ITS BODIES GAINED** (JJ's ruling 1, accepted at JK §0). The figures stay the handlers' — 25% of a body for Healing Wave and Regenerate, 20% for Wild Growth, 6% of every body for Dark Vigil — lifted unchanged into one door (`_warband_heal_figure`) that the heal and its price both read. **A heal on a body under Blight the Well restores nothing, so it is priced at nothing** and asked for whole: the card's payout never waits on the pool. The five heals are derived through the intent's own classifier, never listed (`check_jj` §3).
- **THE SELECTION ASKS THE POOL WHERE IT ASKS THE COOLDOWN** (`_enemy_ready`, JI's door widened, no second gate); **a declared heal sets its price aside** (`intent.malice`), so a second healer cannot spend it; re-validation asks no pool (JJ's ruling 2, accepted at JK §0). A psychotic heal lands on the heroes and pays nothing.
- **THE HEALERS HEAL WHENEVER THE POOL ALLOWS AND A BODY IS HURT** — missing at least half of what the heal would restore it (`MALICE_HEAL_WORTH`): Healing Wave the most wounded hurt body, tanks and supports first; Regenerate itself; Wild Growth the most wounded, with no coin; Dark Vigil two hurt bodies (JJ's ruling 3, accepted at JK §0).
- **THE BAR**: a strip above the warband's stack, MALICE, its bar and its count out of 150, its hover the rule and the spends' prices off the constants, and every body that spends it by name (`_draw_malice_strip`). Driven headless, never seen: on the LOOK-LIST.

**THE READING (`docs/reports/JJ-malice.tsv`).** Sixty runs an arm, the reference four untalented at Warden, fight-seeded on block 38, no modifier laid and no crest worn, JI's tree against JJ's by seed, the run the unit; JI's column replays JI's own JI arm, all 60 runs line for line, 67,334 lines. **The pool**: given 282.5 a fight, taken 157.6 (what it took in, a refill after a heal counted, so past 150 where a heal spent), wasted 124.9 at the cap, spent 13.2 — 37.9 in the fights the warband opened with a healer, 192 of whose 367 spent anything. **In those fights it sits at its cap for 16.0% of the turns and at 79.6% of their ends; over every fight, at the cap for 20.5% of the turns, and at 87.5% of fights' ends** — most of them fights with no healer to spend it, which reach it late: the median such fight sits at its cap for a fifth of its turns. **The warband heals less and later**: 18.5 → 13.2 health a fight over all fights (paired, −5.03 ± 1.94, past two errors; 53.9 → 37.9 where a healer stood), its heals cast 0.319 → 0.290 a fight (paired, −0.034 ± 0.020, a tie), a heal's place in its fight 0.68 → 0.79, 19% → 6% of its heals in a fight's first half, a healer's turns healing there 5.3% → 1.5% and in the second half 17.4% → 18.2%. **The pool binds by when, not by how much**: two of its three terms arrive with a death, so it is too low to pay a heal while the warband used to heal for nothing — the first fights show it: 27 of the 60 runs' first fights play differently, every one with a healer on the field — in 16 the first move to part is a Totemist that healed on JI's tree jabbing on JJ's, in 5 JJ's Totemist heals where JI's jabbed, and in 6 it is no heal — and 33 play line for line alike — and at its cap once the bodies that wanted healing are gone; a healer that cannot pay attacks instead. **So the fights are no longer, and not measurably harder — every outcome the brief named is a tie**: health at a fight's end, paired fights 0.8279 → 0.8187 (−1.03 ± 0.54 points), a hair inside two errors, leaning harder; hero turns a fight, paired fights 33.36 → 32.93 (−0.42 ± 0.22), leaning shorter; falls a run 6.27 → 6.47 (+0.20 ± 0.32); completed 4 → 3 (−0.017 ± 0.029); fights won a run 17.17 → 16.62 (−0.55 ± 0.59). **Beyond the brief's list, falls a fight rose 0.295 → 0.343 (+0.065 ± 0.026, past two errors), and the fights holding a loss carry it**: a run's paired fights run to its first parting, so its last is a wipe wherever either arm wiped — 33 lost by both, 17 by JJ alone, 8 by JI alone, +0.052 ± 0.023 of the rise; in the fights both arms won, falls +0.015 ± 0.010, health −0.28 ± 0.32 points and hero turns −0.17 ± 0.17, ties; the first fight, one board on both, health +0.11 ± 0.23 points. Healed equals spent in all 1,054 of JJ's fights; no re-validation fallback on either arm. *(JJ's ruling 4, accepted at JK §0: nothing is tuned for it.)* *A paired level is the mean over the 999 paired fights, each weighted alike; its difference is the mean of each run's own, the run the unit, so the two need not subtract exactly.*


### THE WARBAND's SPENDS — **THREE, EACH A MOVE ON ITS KIND's LIST, AND EVERY KIND HOLDS ONE (JK §1, §2); BOUGHT FREE BESIDE ITS BODY's ACTION SINCE JL §1, A RALLY WHILE TWO STAND; JK's READING BELOW, JL's IN THE HEXES' BLOCK**

**THE SENTENCE** (`scripts/battle.gd`'s spend constants, `scripts/unit.gd`'s `MALICE_ENTRENCH_MULT`; `check_jk` §1 drives each): A Raise stands a fallen body of the warband back up at 40% of its maximum health, once a body a fight, for the health it stands it up with; a Rally makes every standing body of the warband deal 30% more damage with its blows for 3 turns, for 40 Malice; an Entrench multiplies their armor by 2 for 3 turns, for 30 Malice. **The pool buys health at one Malice a point; everything else has a flat price** (JK §2).

- **A SPEND IS A MOVE ON ITS KIND's LIST, NEVER A SIDE's ACTION — AND SINCE JL §1 A FREE ONE. A spend costs its body no turn**: it rides the body's own declaration beside its action (`intent.spend`), chosen after the action — so after every heal and ward, JK's order (`_warband_spend`, asked by `_declare_intent`) — and only where the pool can pay it beside the action's own reserve (`_enemy_ready`'s `held`); it sets its own price aside there (`_malice_free` reads it), and it is bought first on the body's turn (`_warband_free_spend`): the door's refusals asked again — the list, its cooldown, Heads Down, the Long Silence — a Raise's body asked still down, its cooldown started, its arm in `_resolve_special` paying, **and no delay charged**, so the body then acts as it declared, at its own action's delay. **One rides a declaration, so one a turn.** A stun, a freeze, a hold, a Break or a hijack discards both; a wind-up's turn declares none; a taunt keeps a body from buying, as it kept it from the support half (JL's ruling 4, accepted at JM §0). **The policy** (JK's ruling 4, accepted at JL §0; its bodies JL's): a Raise on the largest fallen body the pool can pay for; a Rally while two or more bodies stand and none is rallied or about to be; an Entrench while none is entrenched or about to be. **The plate names both, the spend first** — *▲ Rally · → Slash* — and its hover says *First, free* (JL's ruling 1, accepted at JM §0). **A hero's Dispel strips a body's Rally and Entrenched**, as it strips a ward — it takes three beneficial effects; the rest of the warband keep theirs, and the policy waits for them. **A buyer strikes rallied three times**, since it buys first on its own turn, every other body twice. **In JL's drive the Ash Hurler and the Rot Behemoth still bought no Rally** — slow bodies that act once or twice a fight (the Hurler in 26 fights, the Behemoth in 7), whose first declaration is made on an empty pool; in 13 of the Hurler's 26 fights no body rallied at all, and in the rest a faster body bought it — and the Orc Brute two.
- **EVERY KIND HOLDS ONE** (`docs/reports/JK-spends.tsv`, derived off the data by `check_jk` §1, which also drives each kind's own selection to one on a board that wants it): a Rally on thirteen — the Orc Raider, Whelp, Slinger, Archer, Hexer, Brute, Chief and Bloodcaller, the Wolfrider, the Ashblade, the Rot Behemoth, the Ash Hurler and the Ash-Wrought Tyrant; an Entrench on five — the Orc Shieldmaster and Shaman, the Bog Troll, the Withered Warden and the Hollow Crown; a Raise and an Entrench on three — the Orc Totemist, the Orc Ritual Chanter and the Grave Totem; and since JS a Rally on the Frostbitten Thrall, the Hailcaster and the Rimehorn, an Entrench on the Icebound Bulwark, the Stillwrought and the Icewrought Titan, a Raise and an Entrench on the Sleetveil Matron. **Of the eleven kinds that owned no cooling move, all eleven hold a spend now**, and every spend cools.
- **RAISE.** `revive`, as the two hero revivals use it, and the body's first turn comes a basic swing after it rises, at its own speed, as a Resurrection's body's does; the declaration it died with goes (it carried a reserve), and its plate shows what is still cooling. **It rises un-Broken**: `_die()` lays its Break down with it (JD §3) and `take_hit` lays none on a body that is down, so Raise needs nothing beyond them for that. A body the pool cannot pay to stand up — over 377 health, its price past the cap — is never raised (FOUND AT JK).
- **RALLY** is read in the strike loop beside Divine Wrath and Zeal, which no heal passes: a warband heal's figure is a share of the body healed, so the pool's one-for-one and the reserve stand (`check_jk` §1 drives a rallied heal). It reaches the warband's blows, not the Burn, Poison or Fester it lays. **Its clock counts down at each of a body's turn starts, before the body acts, as every buff's does but Eye of the Storm's** — so a clock of 3 gives every rallied body two rallied turns, the brief's *two of its turns* — and since JL §1 the body that bought it three, since it buys first on its own turn (JK's ruling 5, accepted at JL §0).
- **ENTRENCH** is read at `effective_armor()`, the one door every blow's armor passes, under its 0.85 ceiling (the highest warband armor doubled is 0.80, the Icebound Bulwark's since JS; 0.70 before it).
- **There is no Overrun.** No new body joins the warband once a fight has opened: the warband is laid out once, by its size, and nothing puts a new body into the turn order mid-fight on either side — a companion joins off it (`next_time` INF), and a Raise and a Resurrection put a fallen one back. *The brief's Overrun — a whelp at the back of the order, for the whelp's health — is RULED, NOT BUILT.* The Orc Whelp exists; an Overrun would need a place in the turn order, a plate and a layout slot past the six the field holds, the spawn's scaling, the bargain's and the runes' stamps, a declaration and the turn bar (JK's ruling 1, accepted at JL §0). Priced as the brief wrote it, its whelp would cost its health — more than the cap from zone two's fifth slot at Warden (the blocks' reader).
- **THE COOLDOWNS, BY JI's LINE** (`check_jk` §2, the line read out of `check_ji`): a spend is priced at its worth on the reference board against its own kind's basic — a Raise the health it stands the median composable body up with (51.0); a Rally what it adds to four bodies' rallied blows — two a body, its clock less the turn it runs out on — at the warband's median basic (87.8 since JO §1 priced the basics' Break, 69.6 at JK; so five of the bands below — the Totemist's Raise, the Wolfrider's Rally and the three Entrenches — are held at the data's figure, JO's ruling 2, accepted at JP §0, `docs/reports/JO-held.tsv`); an Entrench the armor cut it takes again on four bodies for its clock's turns — the caster's three intervals, which every other body covers two and part of a third of — the cut a warband turn read off JA's census (93,066.9 over 10,508 turns; 106.3) (JK's ruling 2, accepted at JL §0). Raise cools 4 on all three; Rally 2 on the Wolfrider, Brute and Rot Behemoth, 4 on the Archer and Hexer, 3 on the rest; Entrench 2 on the Orc Shaman and the Withered Warden, 3 on the Hollow Crown, 4 on the rest — JK's population; JS's seven cool at their own bands (`docs/reports/JS-kinds.tsv`).

**THE READING (`docs/reports/JK-drain.tsv`).** Sixty runs an arm, the reference four untalented at Warden, fight-seeded on block 38, no modifier laid and no crest worn, JJ's tree against JK's by seed, the run the unit; JJ's column replays JJ's own JJ arm line for line, 66,078 lines (the probe's `[JKS]` lines and the lane's banner aside); JK's column is the arm on the code that lands. **The pool**, JJ's figure beside JK's: given 282.5 → 283.1 a fight, taken 157.6 → 180.8, wasted 124.9 → 102.3, spent 13.2 → 38.0 (heals 9.4, the spends 28.6); at the cap for 20.5% → 14.4% of the turns, and 87.5% → 84.6% of the fights end there. **The spends a fight**: Raises 0.063, Rallies 0.420, Entrenches 0.254. **NOT MEASURABLY HARDER — EVERY OUTCOME THE BRIEF NAMED IS A TIE**: completions 3 → 4 (+0.017 ± 0.044), falls a run −0.38 ± 0.39 (a tie), health at a fight's end +0.94 ± 0.84 points, hero turns a fight +0.37 ± 0.28 (a tie); a paired fight's falls −0.030 ± 0.038. **In the fights both arms won the heroes end a hair healthier, +0.81 ± 0.39 points, after a hair longer, hero turns +0.32 ± 0.15, with falls −0.020 ± 0.010 — each just past two errors**; the fights holding a loss — 19 lost by both arms, 19 by JK alone, 20 by JJ alone — carry +0.18 ± 0.70 points of the health, a tie, and the fights both arms won +0.76 ± 0.37 points. **Split by what JK's warband bought in a fight** (run-clustered; the groups are made by JK's own play, so the split says where a difference sits, not what caused it): nothing, +0.38 ± 0.34 points (453 fights, the short ones — JJ's hero turns there 28.2, against 37.7 in the Rally fights); a Rally, −0.65 ± 2.37 points (355); an Entrench and no Rally, +5.01 ± 2.28 points (106), past two errors toward easier — but every fight with an Entrench, a Rally beside it or not, +4.57 ± 3.16 points (193), a tie. The warband's blows a fight −0.68 ± 0.24: every spend is a body's turn and a support cast's delay. One declared move fell back at re-validation, where JJ's arms had none — a Rally under the Beastmaster's Heads Down, the fallback's blow aimed at the Raider that declared it (FOUND AT JK, archived at JN). **The pool spends 38.0 a fight, under the brief's 50 — by the brief's own test the buyers are still not hungry, a finding about the picker**: a Rally waits for three standing bodies with none rallied, an Entrench for none entrenched, a Raise for a fallen body the pool can stand up, and what the spends take, the heals no longer get (the warband healed 13.2 → 9.4 a fight). Nothing is tuned, as the brief ordered (JK's ruling 6, accepted at JL §0).


### THE WARBAND's HEXES — **FOUR, EACH READ AT ITS ONE DOOR (JL §2); SINCE JO §2 EACH RIDES A BLOW — SAP ON BONE RATTLE, FESTER ON THE WRETCHED BELLOW, GALL AND MIRE GIVEN DAMAGE; WITH THE FREE SPEND, FIGHTS WERE HARDER PAST TWO ERRORS AT JL, AND THE HEXES CARRIED ALMOST NONE OF IT (JL §3)**

**THE SENTENCE** (`scripts/unit.gd`'s `GALL_HEAL_CUT`, `SAP_CUT` and `MIRE_SLOW`, `scripts/battle.gd`'s `DOT_STATUSES`, the clocks on the moves that lay them in `data/enemies.json`; `check_jl` §2 drives each door, `check_jm` §0 Gall's reach, `check_jo` §2 each blow): Gall cuts the healing every hero receives by 50% for 3 turns; Sap cuts what a hero's resource bar gains by 50% for 3 turns; Mire makes a hero act 25% slower for 3 turns; Fester deals 3% of its applier's Attack a stack at each of the hero's turn starts and gains a stack each turn, until it is cleansed.

- **A HEX RIDES A BLOW** (JO §2, the designer's: no warband move lays a status on a hero unless it deals damage, so each hex rides a blow): each is a damaging move's own `applies_status`, laid through the status door on a hit, at the move's chance, with the enemy that struck as its source — **Sap on the Orc Hexer's Bone Rattle (and since JS the Stillwrought's Leaching Stillness) and Fester on the Rot Behemoth's Wretched Bellow**, each folded onto a damaging move of its carrier's that laid nothing, and **Gall on the Orc Archer's Gall and Mire on the Grave Totem's Mire**, each given the damage that clears JI's line (`docs/reports/JO-hexes.tsv`; `check_jo` §2 drives each, §3 counts each laid in its carrier's own turns). Each is chosen as the attacks are, aimed through the draws and the evasions, and a single blow rolls its miss; an area blow — Gall, the Bellow — strikes every ally, a companion among them, and lays its hex on each, though on a companion only Gall pays (it takes no turn: Fester never ticks there, Mire delays nothing, Sap finds no bar) (JO's rulings 5 and 6, accepted at JP §0; JM's ruling 3, *a companion never takes one*, superseded). The hex special JL built went with its code (JO's ruling 7, accepted at JP §0). The plate, the glossary and the master document call each *a hex*, beside the status Hexed and the Hexer (JL's ruling 12, accepted at JM §0).
- **EACH AT ITS ONE DOOR** (`check_jl` §2, each door driven on its own line): **Gall** in `heal_amount`, beside Frostbite's half — a cast's heal, a heal the warband casts on a hero and the door itself each land halved; **Sap** at the bar's own setter, the one place every write to a hero's `resource` passes — a write of the shape fifty lines share, a cast's own gain at the price line and a Rage hero's blow taken each rise by half; **Mire** at `effective_speed()`, the speed every delay is divided by — an action's delay and a Sloppy cast's each a third longer; **Fester** in `_dot_pass`, a stack's share of its applier's Attack at its bearer's turn start, then a stack and its full clock back. Gall multiplies with Frostbite and Miasma, Mire with Slowed (JL's rulings 8, 10, accepted at JM §0).
- **EVERY HEX IS AN AFFLICTION** (`DEBUFF_IDS`), none sticky, so every cleanse the party owns reaches it — the Cleric's Unburden, a kit card every run holds; the Cleansing Draught where bought; a Dispel or Field Dressing where drafted, the Medic where worn, Cleanse Debuffs Each Turn where taken — and a hero's Iron Will counts it. **Fester grows until it is cleansed**: the Cleric's Unburden is the answer every run owns, at its cooldown, and the bot casts it only when no ally is under half. Returned Burden casts a lifted hex back onto the warband (FOUND AT JL). **Hallowed refuses all four before they land** — an Empowered Divine Plea's (JP's readout, `docs/reports/JP-answers.md`). **A cleanse that takes one aims (JQ §2)**: Dispel on a hero, Field Dressing, the Medic and Cleanse Debuffs Each Turn take a hex if the hero carries one, else the harmful effect with the most turns left, the Bleed chip last (`BattleUnit.HEX_IDS`, a written list).
- **THE PRICES AND THE COOLDOWNS** (`check_ji` §1a, JI's line; `check_jl` §2; `check_jm` §0 for Gall): each hex's blow is priced on the line by its damage, its Break and the DoT it lays — Fester's tick is one — and what a hex denies is not priced (JO's ruling 3, accepted at JP §0): **Gall 10 on every ally, 1.51 of the Orc Archer's basic, 2; Bone Rattle 52 with Sap, 1.41, 2; Mire 45, 1.41, 2; the Wretched Bellow 15 with Fester, 2.50, 3.** JL priced each standalone hex move by what it denied, off JA's census — Gall 42.5, Sap 35.1, Mire 23.4, Fester 18.0 (`docs/reports/JL-hexes.tsv`, JM's re-take `docs/reports/JM-hexes.tsv`) — the record of the moves that convention priced. On a Cleric Sap takes half of what the cut leaves (JN's ruling 4, accepted at JO §0).

**THE READING (`docs/reports/JL-drive.tsv`).** Sixty runs an arm, the reference four untalented at Warden, fight-seeded on block 38, no modifier laid and no crest worn, JK's tree against JL's by seed, the run the unit; JK's column replays JK's own JK arm line for line, 71,000 lines (the probe's lines and the lane's banner aside). **HARDER, PAST TWO ERRORS**: health at a fight's end 84.51% → 80.87% (−4.33 ± 1.02 points), falls a fight 0.234 → 0.334 (+0.136 ± 0.042), fights won a run 17.52 → 14.82 (−2.70 ± 0.95); in the fights both arms won, health −2.73 ± 0.58 points, falls +0.051 ± 0.016 and hero turns +0.44 ± 0.18 — harder and longer. These levels are each arm's mean over the 865 paired fights (the same node, in order; 59 of 60 runs on one road throughout) and the difference each run's own, averaged over runs, so the two need not subtract exactly. **Falls a run 6.08 → 6.00 (−0.08 ± 0.31), hero turns a fight 32.49 → 32.91 (+0.09 ± 0.32) and completions 4 → 3 are ties** — a run ends sooner and falls the same. **The warband's blows a fight 14.63 → 15.76 (+1.13 ± 0.26)**: they no longer fall. **The pool and the spends are read over all fights** (1107 and 946; JL's runs are shorter), their differences paired: given 283.1 → 278.6 a fight, taken 180.8 → 192.1, wasted 102.3 → 86.5, **spent 38.0 → 52.8** (heals 8.3, the spends 44.5) — under the brief's 120; 76.8% of fights end at the cap (84.6%). **The spends a fight**: Rallies 0.420 → 0.699, Entrenches 0.254 → 0.338, Raises 0.063 → 0.097 — 1.134 a fight, every one bought free beside its body's action. **Each hex's uptime on hero turns** (a hero turn taken with it standing), all fights: Gall 0.00% → 0.22%, Sap 0.00% → 0.18%, Mire 0.00% → 0.41%, Fester 0.00% → 0.06%; in the fights its carrier acted in, what a player who meets it sees, Gall 4.99%, Sap 3.96%, Mire 7.55%, Fester 7.91% — cast 0.041, 0.041, 0.093 and 0.005 times a fight. **So the hexes carry almost none of it** — the paired fights a hex was cast in carry −0.32 ± 0.29 points of the health difference: the difficulty is the spends', which no longer cost a blow, and the Rally's two bodies; split by what JL's warband bought (run-clustered, the groups made by JL's own play), a Rally's fights carry −6.07 ± 1.56 points (517 fights in 60 runs; JK's hero turns there 35.1) and the fights it bought nothing in −0.82 ± 0.44 points (207 fights in 59 runs; JK's hero turns there 24.9). The Ash Hurler and the Rot Behemoth still bought no Rally: slow bodies that act once or twice a fight — the Hurler in 26 fights, the Behemoth in 7 — whose first declaration is made at the fight's opening on an empty pool; in 13 of the Hurler's 26 no body rallied at all, and in the rest a faster body bought it first (§1).


### THE FROZEN PLAINS — **A SECOND CANDIDATE AT SLOTS 1 AND 3, SIX KINDS AND A BOSS THAT FREEZES (JS §1–§3); EVERY RUN DRAWS A SLOT OF TWO, SO A RUN TAKES ONE OF FOUR SHAPES**

**THE ZONE** (`Run.ZONE_DEFS`' `frozen_plains`): the Icewrought Titan its boss, roster 4 at slot 1 and roster 5 at slot 3, as the Forest
carries 1 and 3; `Run.SLOT_POOLS` holds it beside the Forest at slots 1 and 3, the Scarlands keeps slot 2 alone, `Run.SLOT_COUNT` stays 3,
and every zone runs `Run.SLOTS_PER_ZONE`'s sixteen slots (the third board's seventeenth is the end boss's, whichever zone holds it). **Every run draws a pool of two** (`Run.draw_zones`, JS's ruling 1); a pool of
one takes its zone with no die; a sim's `DOD_ZONE_ROTATION=0` holds it to each pool's first. **What keys on a zone**: the four things
`run_state.gd`'s comment names, and a fifth in two parts — the event screen's background dict, and two Forest events dealt by slot, which
now name their zone (`Events.failed_reason`'s `zone`, JS's ruling 7). The save keeps the zone's id and name; the wipe table, the zone
multipliers and the pouch key on the slot's place; the profile's boss tally takes the Titan as a new key. **The Frozen Plains wears the
Forest's backdrop** in all three dicts, a placeholder named in each and on the LOOK-LIST (JS's ruling 5).

**THE KINDS THAT TRAVEL, DERIVED** (JS's ruling 6): the twelve kinds tagged for all three old rosters — the Orc Raider, Archer, Shieldmaster,
Shaman, Hexer, Brute, Ritual Chanter and Bloodcaller, the Rot Behemoth, the Grave Totem, the Orc Chief and the Hollow Crown — take both new
ones; no kind tagged for fewer travels. **Roster 4 holds 16 kinds and roster 5 19**, and each fields four to six bodies in 66.0% and 65.1%
of fight nodes, beside rosters 1, 2 and 3's 69.6%, 61.4% and 66.6% (`check_js` §1, through `Run._theme_combos`).

**THE SIX** (`docs/reports/JS-kinds.tsv`): **the opener's three, in both rosters** — the Frostbitten Thrall (skirmisher, power 1), the
Icebound Bulwark (bulwark, 2, the highest armour in the game) and the Hailcaster (sniper, 1, ranged); **the finale's, in roster 5** — the
Rimehorn (brute, 3, the most health of the six), the Sleetveil Matron (mender, 2) and the Stillwrought (hexer, 2, ranged). Each resists
frost, falls to fire, and is slower and more armoured than the kind it stands for (JS's ruling 2's rule); each basic is its role's Attack. **Their second moves —
Hobbling Bite 46, Glacier Press 38, Hailstorm 8, Trampling Charge 52 and Leaching Stillness 58, and the Titan's Entomb 60 — each the least
whole damage that clears the line with its Break in the sum**, each cooling 2; the Matron's heal is the warband's Healing Wave, 1.58 of
its basic, cooling 2. Their riders stood before JS: Slowed, Dazed on every ally, Sap; Glacier Press and Trampling Charge are Break moves the
plate declares a *crush* (JS's ruling 3). Spends: a Rally the Thrall, the Hailcaster and the Rimehorn; an Entrench the Bulwark and the
Stillwrought; a Raise and an Entrench the Matron, a content-hole kind by construction (FOUND AT JN). **The six straddle the line's reference
board** — three healths and three basics under its medians (127.5 and 36.595), three over — **so no existing kind's heal or spend is
priced anew** (JS's ruling 2). A fight node fields the Hailcaster in 36.3% of roster 4's and 35.8% of roster 5's, the Thrall 35.1% and
34.0%, the Bulwark 20.7% and 19.5%, and in roster 5 the Matron 16.1%, the Stillwrought 8.1% and the Rimehorn 5.1%.

**SAP's SECOND CARRIER, BESIDE JR's TAG**: with JR's *sniper* tag the Orc Hexer is in 16.8%, 16.3% and 19.2% of rosters 1, 2 and 3's
fight nodes (9.6%, 9.1% and 10.2% without it); the Stillwrought shares its *hexer* role in roster 5 alone, where a fight fields a carrier in 22.4% (the Hexer 15.6%, the
Stillwrought 8.1%). **Neither makes the other redundant**: the tag reaches every roster, the Stillwrought half the runs' finales.

**THE ICEWROUGHT TITAN** (boss, power 7, 460 health, armour 0.32; JS's ruling 4): Glacier Fist, **Entomb — a single frost blow that lays
`frozen` on one hero for one turn** — and an Entrench; no rung tag. **On a hero `frozen` costs one turn**: the loop passes the turn by
before the turn's own tick, *is frozen solid and loses their turn*. **A Block and a miss lay nothing, Ironclad and Hallowed refuse it, and a
cleanse lifts it** (JO's ruling 5's shape; `frozen` is in `BattleUnit.DEBUFF_IDS`); a boss's immunity is a target's, never in its way.

**THE COUNT, OFF THE BATTERY**, taken only on fights where the warband attacks (`docs/reports/JS-count.tsv`): 62 such fights of the 342 the battery's logs hold (`check_js`'s one fight, whose Entombs its own hand casts, set apart). In them each JS kind was fielded in — the Frostbitten Thrall 2, the Icebound Bulwark 1, the Hailcaster 1, the Rimehorn 1, the Sleetveil Matron 1, the Stillwrought 1, the Icewrought Titan 1; their second moves cast — Hobbling Bite 4, Glacier Press 2, Hailstorm 3 (15 lines), Trampling Charge 4, Healing Wave 0, Leaching Stillness 3, Entomb 1; Sap was laid 2 times by the Orc Hexer and 3 by the Stillwrought; a hero or a companion was Frozen 0 times. **The two zeros**: the Matrons' one fight (`check_jq` §4) declared no heal on its bodies' turns, and the Titan's one Entomb missed — `check_js` drives both, the heal's choice (§2) and the freeze and its lost turn (§3). **A count, nothing compared**: how often a player meets a kind is the derivation above.

### THE ARC, READ WHOLE — **THE TREE BEFORE THE ARC AGAINST THE TREE THAT LANDS (JM §1); THE GAME AS IT IS PLAYED, WITH ITS RELICS AND ITS BARGAINS (JM §2); THE FIVE CARDS THE ARC REACHED, RE-READ (JM §3)**

**§1 — WHAT THE ARC DID** (`docs/reports/JM-arc.tsv`, `JM-impurities.tsv`; `check_jm` §1). Sixty runs an arm on the arc's own line — the reference four untalented at Warden, fight-seeded on block 38, no modifier laid, no crest worn, no relic — **the tree before the arc, JH's commit `141b0be`, driven as it stands** (every tracked file of it and none added since, its lane named for itself, the thirteen print-only probes JI drove it with; every one of its sixty runs reproduces JI's own arm on it line for line), **against the tree that lands** (JL's and JM §0's two edits to Gall), the run the unit, paired by seed; the levels each arm's mean over the 936 paired fights (each run's fights to the shorter run of the pair; 59 of 60 runs on one road throughout), the difference each run's own, so the two need not subtract exactly. **Health at a fight's end 0.8322 → 0.8109 (−2.88 ± 1.00 points (z −2.89), past two errors, toward harder). Falls a fight 0.286 → 0.341 (+0.094 ± 0.044 (z +2.12), past two errors, toward harder). Falls a run 7.30 → 5.95 (−1.35 ± 0.45 (z −2.97), past two errors, fewer — a run ends sooner). Fights won a run 17.47 → 15.67 (−1.80 ± 0.69 (z −2.62), past two errors, toward harder). Completions 3 → 5 (+0.033 ± 0.033 (z +1.00), a tie). Hero turns a fight 33.27 → 33.24 (−0.25 ± 0.32 (z −0.77), a tie). The warband's blows a fight 15.33 → 15.39 (+0.23 ± 0.27 (z +0.88), a tie)** (over every fight, 15.77 → 15.50). In the fights both arms won: health −1.57 ± 0.68 points (z −2.31), falls +0.016 ± 0.024 (z +0.65), hero turns +0.25 ± 0.22 (z +1.11); the paired fights holding a loss: 22 lost by both arms, 27 by the landing tree alone, 8 by the tree before the arc alone; the first fight's health −1.15 ± 0.64 points (z −1.80) (60 of 60 the same node). **Split at JL's tree** (HEAD's code, its arm reproducing JL's own arm of record line for line): **the arc alone, JH → JL** — health at a fight's end −3.82 ± 0.93 points (z −4.13) (past two errors, toward harder); falls a fight +0.131 ± 0.038 (z +3.40) (past two errors, toward harder); fights won a run −2.65 ± 0.81 (z −3.29) (past two errors, toward harder); the warband's blows a fight +0.84 ± 0.26 (z +3.23) (past two errors, more); **JM §0's Gall alone, JL → the tree that lands** — health at a fight's end +1.77 ± 0.90 points (z +1.96) (a tie at the edge, leaning easier); falls a fight −0.074 ± 0.037 (z −1.99) (a tie at the edge, leaning easier); fights won a run +0.85 ± 0.71 (z +1.19) (a tie); the warband's blows a fight −0.51 ± 0.30 (z −1.70) (a tie). **Gall on the tree that lands** is up on 5.95% of the heroes' turns over every fight (cast 330 times), where on JL's tree, on the Hexer and one hero, it was up on 0.22% (cast 39). **Every impurity of the pairing, named and signed** (`JM-impurities.tsv`): the runner and the bot, none (byte-identical across the arc; the bot plays what each tree hands it); the probes, none (the landing tree with the thirteen alone reads line for line beside the full chain over twenty runs); the dice, neither way (one seed block on two trees parts at the first difference the arc made, which thins the pairing and biases nothing); and the tree that lands carries §0, toward easier (a tie at the edge), sized by the split — so the whole reads a little milder than the arc alone. **These four readings — JI's −1.03 falls a run, JJ's tie, JK's −0.38 and JL's −4.33 points of health, each against the batch before on its own population — are the arc's steps; this is the arc.**

**§2 — THE GAME AS IT IS PLAYED** (`docs/reports/JM-played.tsv`; `check_jm` §2). One arm on the tree that lands, the reference four untalented at Warden, sixty runs, fight-seeded on block 38, with the two divergences the brief named closed or named: **relics as the game hands them** (`DOD_SIM_RELICS=draw3`: three a run, drawn without replacement from the 25 a draw can reach, as the boss's unlock draws them and the draft's three slots take them; 60 of 60 runs opened holding three; 25 distinct relics held — JM's ruling 4, accepted at JN §0), **the crest as the bot wears it** (the first it draws, never swapped; not closed, JM's ruling 5, accepted at JN §0; 43 of 60 runs end wearing one) and **the bargains dealt and taken as the bot takes them** (367 taken, 15 kinds; JM's ruling 6, accepted at JN §0). **Completion rate 1.7% (1 of 60) (± 1.7 points); falls a run 7.02 ± 0.34; health at a fight's end 0.7306 (over 804 fights; run-clustered 0.7114 ± 0.0101); fights won a run 12.42 ± 0.78.** (The levels are over every fight; a paired difference is over the paired fights, run by run.) Beside it, the same line with the relics at the default, paired by seed: completions 0.0% (0 of 60) (+0.017 ± 0.017 (z +1.00) (a tie)), falls a run 6.58 (+0.43 ± 0.34 (z +1.26) (a tie)), health 0.7128 (688 fights) (+4.21 ± 1.04 points (z +4.05) (paired fights) (past two errors, toward easier)), fights won 10.47 (+1.95 ± 0.71 (z +2.76) (past two errors, toward easier)). **These are the project's first absolute figures that describe the game someone plays** — its relics drafted and its bargains dealt, at the rung a player meets after the first — **and they describe it through the bot**: untalented, its timing bar rolled at fixed odds, its rotation, potions and drafted cards its own, the gamble taken nearly every time, the crest worn as drawn (JM's ruling 6, accepted at JN §0 names what still separates them). *Untalented: JN §2's Arm B reads the same line wearing tier 1 (WHAT THE RAISE DID, AND THE GAME WITH TALENTS).* JE's three-relic arms held relics before (no bargain laid, `docs/reports/JE-spiral.tsv`). **No figure taken before these is re-derived from them**: every older figure stands where it stood, stale where it is marked stale.

**§3 — THE FIVE CARDS THE ARC REACHED** (`docs/reports/JM-grades.tsv`; `check_jm` §3; JM's rulings 7 and 8, accepted at JN §0). Each read as the deck is read — the reference four untalented at Wanderer, sixty runs, fight-seeded on block 38, every bargain forced to the card, the crest the bot's, no relic — against its own re-driven *none* on the tree that landed at JM (0.9348 (54 of 60 completed); JN's tree 0.8430 (27 of 60 completed), WHAT THE RAISE DID, AND THE GAME WITH TALENTS; the tree before the arc 0.9454 (56 of 60 completed)), the cost in points of the party's health at a bargain fight's end; the band read off the point estimate on the scale's cuts, the test binding, a tie at a cut named and never resolved upward; and **the arc's move**, each run's own cost on the tree that lands less the same run's on the tree before the arc, the run the unit:

| card | its grade | the reading the grade rests on | on the tree that lands (points) | the band its point falls in | a cut inside two errors | the cut it falls against | on the tree before the arc | the arc's move, run by run |
|---|---|---|---|---|---|---|---|---|
| Fleeting | 2 | JA §2 +2.29 ± 0.26, the default four, fight-seeded | **+2.15 ± 0.33** | 2 | a tie at 1.78 | 1.78, 1.12 errors over it | +2.94 ± 0.36 | **−0.80 ± 0.39** (past two errors) |
| Encumbered | 1 | IZ §1 +1.09 ± 0.31, the default four, fight-seeded | **+1.20 ± 0.33** | 1 | a tie at 1.78 | 1.78, 1.75 errors under it | +1.33 ± 0.20 | **−0.13 ± 0.34** (inside two errors) |
| Miasma | 3 | IY §4 +5.46 ± 0.78, the incumbent at Ruin (the default four IX §1 +5.14 ± 0.72, run-seeded) | **+4.74 ± 0.43** | 3 | none | 3.74, 2.33 errors over it | +4.92 ± 0.34 | **−0.18 ± 0.39** (inside two errors) |
| Thin Air | 5 | IX §1 +21.03 ± 1.38, the default four, run-seeded | **+21.86 ± 1.10** | 5 | none | 12.22, 8.76 errors over it | +20.97 ± 1.17 | **+0.89 ± 1.01** (inside two errors) |
| Bloodless | 5 | IX §1 +24.22 ± 1.02, the default four, run-seeded | **+23.38 ± 0.87** | 5 | none | 12.22, 12.84 errors over it | +23.47 ± 0.86 | **−0.09 ± 0.62** (inside two errors) |

**Whether the arc moved grades**: none of the five reads a band other than its grade on the tree that landed at JM, so by the brief's own argument the twenty not read hold too, and the deck survives the arc; the arc moved Fleeting's cost by −0.80 ± 0.39 (z −2.07) past two errors, inside its band; Fleeting at 1.78 and Encumbered at 1.78 read at a tie with a cut, named and not resolved; and on its own arms Thin Air's completions fell 23 → 14 of 60 (paired −0.150 ± 0.052 (z −2.87)) across the arc, the one card arm past two errors on completions — its cost read over fewer bargain fights a run, named and not a grade. **No grade is re-authored and the deck stays closed at twenty-five** (JM's ruling 7, accepted at JN §0); the readings are the arc's, every severity in `Run.MODIFIERS` as it stood.


### WHAT THE RAISE DID, AND THE GAME WITH TALENTS — **EVERY KIND's SECOND DAMAGING MOVE AT THE LINE (JN §1); WHAT IT DID AT WARDEN (JN §2, ARM A); THE GAME WITH TALENTS (ARM B); THE BREAKS AND THE RAGE JN's PROBE READ**

**JN's RECORD, ON JN's TREE.** Since JO §1 the line prices a move's Break and seven of the ten stand where it puts them (THE WARBAND's COOLDOWNS; `docs/reports/JO-break.tsv`); the figures below are JN's raise and JN's readings, and since JO no batch re-reads them — balance is the designer's, judged by playing (`docs/ways-of-working.md`) — and the untalented line is retired as an instrument: it read 0 of 60 on JN's tree, and nothing can be read against a floor.

**THE RAISE (JN §1; `docs/reports/JN-population.tsv`, the before and the after; `check_jn` §1 holds it to JN's kept kit, JI's line read out of `check_ji`).** Every kind's second damaging move — the first move after its basic, in the data's order, that deals damage — prices at 1.4× its own basic or better, and cools by the rule. 10 did not, and each rose to the least whole damage that clears: the Orc Raider's Sundering Strike 23 → 48 (2); the Orc Slinger's Skull Crack 12 → 34 (2); the Orc Archer's Poison Arrow 16 → 26 (2); the Orc Hexer's Withering Hex 24 → 62 (2); the Wolfrider's Ride-by Slash 28 → 51 (2); the Ashblade's Flame Lick 22 → 38 (2); the Orc Brute's Overhead Crush 28 → 56 (2); the Bog Troll's Swampy Grasp 26 → 56 (2); the Rot Behemoth's Wretched Bellow 14 → 15 (2); the Orc Bloodcaller's Blood Tribute 20 → 42 (2). **Only the damage moved, and the band beside it**: each move's status, its chance, its delay, its Break damage and its reach stand, and no basic moved; the 6 kinds whose second move already cleared are untouched; the 5 whose other moves deal nothing keep one damaging move, and no move was authored (JN's ruling 1, accepted at JO §0; FOUND AT JN names them). Each prices 1.40 to 1.46, band 2, none past 2×; three sit exactly on the line (Overhead Crush, Swampy Grasp, Blood Tribute). **The Bellow needed one point**, an area blow on four heroes, and its hand-tune went with its reason (JN's ruling 3, accepted at JO §0). **At JN the line's price read neither Break damage nor delay** (JN's ruling 2, accepted at JO §0 and superseded for Break by JO §1 — THE WARBAND's COOLDOWNS; its item archived at JO).

**DIAL 3 — JN's TEN RAISES, RECORDED, NOT PULLED (JP §0; `docs/reports/JP-dials.tsv`).** **Its exact reversal is nineteen keys of `data/enemies.json`, not ten**: each move's `damage` back to HEAD-before-JN's figure — Sundering Strike 53 → 23, Skull Crack 34 → 12, Poison Arrow 29 → 16, Withering Hex 69 → 24, Ride-by Slash 55 → 28, Flame Lick 44 → 22, Overhead Crush 56 → 28, Swampy Grasp 64 → 26, Wretched Bellow 15 → 14, Blood Tribute 44 → 20 — and the cooldown key JN added beside the raise on nine of them — all but the Wretched Bellow — each 2 and absent before JN (the Bellow's 3 is Fester's since JO §2, and stays). Pulled, it takes dial 2's seven keys with it, and Read the Tell's payoff against the nine (JQ §3); the Bellow at 14 still clears the line with Fester riding it. `check_jn` §1, `check_jo` §1, `check_ji` §1a and `check_jp` §0 hold the figures.

**ARM A — WHAT §1 DID (`docs/reports/JN-arc.tsv`; `check_jn` §2).** JM's arc line — the reference four untalented at Warden, sixty runs, block 38 and its fight seed, no modifier laid, no crest worn, no relic — on JM's tree (`994f747`; its sixty runs reproduce JM's own arm line for line) and on HEAD with §1's raise alone, paired by seed (724 paired fights; §0 alone 504, the whole 506): **health at a fight's end −9.14 ± 1.06 points (z −8.65) (past two errors, toward harder); falls a fight +0.334 ± 0.041 (z +8.06) (past two errors, toward harder); fights won a run −4.13 ± 0.78 (z −5.30) (past two errors, toward harder); falls a run +0.65 ± 0.48 (z +1.35) (a tie); completions −0.067 ± 0.032 (z −2.05) (past two errors, toward harder); hero turns a fight −1.12 ± 0.35 (z −3.21) (past two errors, shorter); the warband's blows a fight +0.45 ± 0.31 (z +1.44) (a tie).** **The raise made fights harder past two errors on health, falls a fight, fights won and completions; falls a run and the warband's blows a fight are a tie, and hero turns a fight fell — the fights got shorter** — every raised move was a blow before and is one now, each a stronger one cast less often (the ten moves 3,564 → 1,933 casts over every fight, over fewer fights): the arc's law holds, a change that costs the warband no turn presses. The run ends sooner (fights fought 995 → 751), so its falls a run are a tie. **§0 alone** (HEAD with §1 → the tree that lands; the reference four's Devout is a Cleric, so the cut reaches every arm): health at a fight's end −15.72 ± 1.15 points (z −13.64) (past two errors, toward harder); falls a fight +0.403 ± 0.048 (z +8.42) (past two errors, toward harder); fights won a run −3.97 ± 0.72 (z −5.49) (past two errors, toward harder). **The whole** (JM's tree → the tree that lands): health at a fight's end −21.93 ± 1.11 points (z −19.73) (past two errors, toward harder); falls a fight +0.604 ± 0.047 (z +12.93) (past two errors, toward harder); fights won a run −8.10 ± 0.92 (z −8.80) (past two errors, toward harder); completions −0.083 ± 0.036 (z −2.32) (past two errors, toward harder). *A level is each arm's mean over the paired fights; a paired difference each run's own, averaged over runs — the two need not subtract.*

**THE BREAKS AND THE RAGE (JN's print-only probe, on Arm A's three trees — JM's / §1 alone / the tree that lands).** Hero Breaks a fight: 1.23 (1228 over 995 fights) / 1.23 (926 over 751 fights) / 1.09 (562 over 514 fights); of them, by one of the ten raised moves: 327 (26.6%) / 115 (12.4%) / 78 (13.9%) — a raise in damage leaves a move's Break damage where it stood. The Rage a Warrior holds at his turn's start: mean 49.6 / 49.2 / 42.0; turns at 40 or more 57.8% / 56.9% / 47.6%; at 100 or more 13.6% / 13.3% / 6.9%; Boil Overs poured 13 (Rage poured: min 40, median 65, max 100) / 4 (Rage poured: min 40, median 82.5, max 100) / 2 (Rage poured: min 40, median 40.0, max 40) (BOIL OVER'S RATE).

**ARM B — THE GAME WITH TALENTS (`docs/reports/JN-played.tsv`; `check_jn` §2; the census's DV36, JN's ruling 7, accepted at JO §0).** JM's played line — three relics a run drawn as the unlock draws, the bargains dealt and taken as the bot takes them, the crest worn as it wears it — on the tree that lands, at Warden, sixty runs, untalented and wearing talents, paired by seed. **The bot cannot choose cells**: it wears every cell of the first N tiers (`DOD_SIM_TIERS`, read off each arm's banner). **The policy**: tier 1 whole, every cell the first rung's end boss opens — the most a player at Warden holds before Warden's own end boss falls; tiers 1 and 2 beside it. **Untalented**: completion rate 0.0% (0 of 60) ± 0.0, falls a run 6.77 ± 0.37, health at a fight's end 0.5982 (510 fights), fights won a run 7.50 ± 0.42. **Tier 1 whole**: 35.0% (21 of 60) ± 6.2 (+0.350 ± 0.062 (z +5.64) (past two errors, toward easier)); falls a run 6.95 ± 0.48 (+0.18 ± 0.53 (z +0.35) (a tie)); health 0.7283 (1301 fights) (+20.53 ± 0.86 points (z +23.76) (past two errors, toward easier), paired fights); fights won a run 21.03 ± 0.98 (+13.53 ± 1.00 (z +13.56) (past two errors, toward easier)). **Tiers 1 and 2**: 68.3% (41 of 60) ± 6.0 (+0.683 ± 0.061 (z +11.28) (past two errors, toward easier)); fights won a run 26.20 ± 0.69 (+18.70 ± 0.81 (z +23.21) (past two errors, toward easier)). **These are the project's first absolute figures of the game as played with the talents a player would have taken**, through the bot; **JM's 1 of 60 was the missing talents, not the game**: on the tree that lands — harder than JM's by §1 and the Cleric's cut — the untalented line finishes none, and the nine cells of tier 1 take it to 21 of 60, every fight's health up past two errors and fights won a run nearly trebled.

**THIN AIR, RE-READ AFTER THE CLERIC's CUT (JN §0.1; `docs/reports/JN-thinair.tsv`; `check_jn` §0; JN's ruling 8, accepted at JO §0).** JM's grade line (the reference four untalented at Wanderer, sixty runs, fight-seeded on block 38, every bargain forced to the card) on the tree that lands: **+17.86 ± 1.14**, band 5 (a cut inside two errors: none), against JM's +21.86 ± 1.10 (band 5) on JM's tree; the move, run by run, −4.00 ± 1.35 (z −2.97) — §1 and §0 together, not the cut alone. **Its grade stays 5: recorded, not repaired.** **The deck's own *none* fell beside it**: 0.9348 (54 of 60 completed) on JM's tree, 0.8430 (27 of 60 completed) on the tree that lands, paired by seed health −9.18 ± 0.78 points at a bargain fight's end (z −11.83); completions −0.450 ± 0.065 (z −6.95); 60 runs paired — so every grade but Thin Air's was read against a reference this tree no longer gives, and is stale here. Parched and Warded, the other two grades keyed on hero resource, stand at a tie with the 1.78 cut and were not re-read.

### THE SIM's FIGURES, RE-TAKEN AT IW — **EVERY MARK IV SET IS TAKEN (IW §3); THE RECORD IS IW's FIGURE NOW**

**What it is.** IV marked eleven figures its drive showed moved SUPERSEDED-PENDING (WHAT IV's DRIVE MOVED, archived at IW). **IW re-drove IV's twelve arms on HEAD on IV's own seeds** — the ten natural arms on IG's three parties and the incumbent's two forced arms, through IV's probe — and **every one of the 36 logs reproduced IV's second arm line for line** (363,651 probe lines): HEAD is IV's tree for these figures, so each re-take is that arm's figure, and it is the record's now. Its instrument is IV's rebuilt one, not the records' original probes (IV §1c: the levels differ), so **these figures replace the records rather than checking them**. The kept table: `docs/reports/IW-retake.tsv`; §1b's ladder reached none of the eleven (each is a natural run's figure; IW's report §3).
- **THE RUNE SUPPLY** (HR §1c's supply table): a hero on the default build ends a run holding **8.57 runes at Wanderer, 8.64 at Warden, 8.34 at Ruin**, **2.92 / 2.88 / 2.70 of them unworn** at the three rungs.
- **THE RUN REPORT's SHOP LINE** (EQ's 4.57 merchants walked, 6.98 runes bought and 3.44 acquired per hero per run, Carried from the code): over the ten natural arms' thirty party blocks, **4.82 merchants walked, 3.36 runes bought, 6.36 acquired per hero per run**.
- **UNTALENTED COMPLETION ON IG's HIEROPHANT POPULATION** (IO §3's 70 of 180): **30 of 60** completed, depth 42.8 of 49.
- **RUNS COMPLETED UNDER TINDERBOX AND UNDER MIASMA** (IP §1b's 59 and 51 of 60), the incumbent's forced arm: **60 and 60 of 60**. *Tinderbox left the deck at IZ §5; its figure is the record of what it cost then.*
- **THE SIM's BARS AT A TURN's START, THE RELIC HELD, DEFAULT** (IF §0.1b's 91 / 97 / 95 of 120, Cleric / Mage / Hunter): **107.0 / 109.8 / 105.9 of 120**.
- **AND THE TWO IV's DRIVE COULD NOT READ, READ.** **Rupture** (IF §2's 3.2% on IF's tree; FOUND AT IF): a Rupture stands on a living enemy at the start of a Cryomancer's turn on **1.7% of his turns** — sixty default-build runs at Wanderer, IV's repaired bot (per run 1.64 ± 0.47). **Boil Over's Rage** (HZ §2's about 20 a turn, median 15; BOIL OVER'S RATE): about 21 Rage a turn on the same build and rung, twenty runs a lineage — the Berserker 23.1 (median 15), the Warden 19.8 (median 15), the Swordmaster 21.4 (median 15); holding 100 or more, what he dealt between two of his turns ran a median 43% / 46% / 57% of his Attack (that reading includes what his statuses dealt in the span, so it bounds the bot's dump from above).
### THE CLERIC's MANA RATE — **12, UNMOVED (IE §1), AND SINCE JN §0 A CLERIC KEEPS HALF OF EVERY GAIN IN A FIGHT; THE TUNING HANDLE AND THE FIGURES IT WAS MEASURED AGAINST**

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
Hunter never dry — THE FIRST CLEAN PLAYTHROUGH, above. With the relic, at a turn's start the bars read 91 / 97 / 95 of 120 (default) on IF's instrument; *re-taken at IW on IV's: 107.0 / 109.8 / 105.9 (THE SIM's FIGURES, RE-TAKEN AT IW).* **THE RATE STAYS 12, CONFIRMED (IG's brief §0.2)** — superseded for the Cleric at JN §0, the designer's, recorded and not deleted (THE CUT, below; no dry figure was read on the tree that lands); **IG's reason, as taken:**
untalented — the designer's build — the Cleric is dry 11.5% of his turns with the relic, below the Mage's and the Hunter's, and the
caveat the sim cannot close (the bot heals when hurt, a player when it matters) is the readout's. These figures were taken while the
member's maximum was a fixed 100 (IG §4 changes that for a node-holder; the untalented rows hold no node) — re-read at IG §4c
on the default build with the relic held: dry 0.7 / 2.9 / 0.3%, opening a fight full 39.2 / 42.5 / 35.6% (24.1 / 36.5 / 15.4% before).

**THE CUT (JN §0.1; `check_jn` §0; JN's ruling 4, accepted at JO §0).** `BattleUnit.CLERIC_MANA_CUT`, 50%, read at **the bar's own setter** — the one place every rise of a hero's bar in a fight passes, Sap's door — on a Cleric (`mana_gain_cut`, armed by `battle._spawn_units` once his opening bar is settled): the drip, a card's gain, a potion drunk in the fight, a refund, each cut on what it would add, rounded in his favour; the bar he carries in, the Bottled Storm's floor and the spawn's loads are no gain. Outside a fight — the map's potion, an event, the Hourglass, a zone's restoring — nothing passes the setter and nothing is cut. **Holy Conduit's line states it** (the class passive, the hero sheet and the class-selection card), and the master document's §5.0 and §5.1 and the glossary's Mana. **Every dry figure above was taken before it**, through the IV probe's full-bar what-if, which the cut now reads short on a Cleric.

**DIAL 1 — THE CLERIC's CUT, RECORDED, NOT PULLED (JP §0; `docs/reports/JP-dials.tsv`).** The first the designer would reach for: on JN's §0 arm (ARM A, WHAT THE RAISE DID: the reference four untalented at Warden, 504 paired fights) health at a fight's end fell 15.72 ± 1.15 points with the cut, beside Boil Over's flat rate, poured 2 times in 514 fights. **Its exact reversal**: `BattleUnit.CLERIC_MANA_CUT` 0.5 → 0.0 in `scripts/unit.gd` — the setter cuts nothing at 0.0 — and the five texts that state the cut lose their clause: Holy Conduit's line (`scripts/classes.gd`), the master document's §5.0 and §5.1, the glossary's Mana and the hero sheet's Mana tip (`scripts/party_screen.gd`), the last two of which would print *0% less*. `check_jn` §0 asks a cut above 0, and `check_jo` §0 and `check_jp` §0 hold 0.5: each moves with it. The state's and the design notes' records of the cut are its history and stay.

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

**READ OUT AT JN §0.3 (the designer's question; nothing changed, `check_jn` §0 holds the three constants).** **What it is**: the Hierophant's engine — the one thing the **Rune of the Hierophant** (core) carries, its payload empty — dealt at the class selection to a Cleric. **What it steps**: one ledger for the whole fight, every status landing on a body or actively taken off one, from any source, once a turn for each body and status (a status running out does not count); every 13 such changes is a step, up to 5. **What it pays**: each step adds a turn to every status that Cleric applies — duration only, read at `battle._apply_status` off the applier, and mirrored in the recast gate's `_status_write_improves`. **What reads it**: those two, the playtest readout (events and steps a fight) and the engine's words. **And what waits on it**: the potency half FT §3 staged and never built (`CLAUDE.md`'s rule: its rate is set against half a payout, and the batch that builds the other half re-measured it until JO §0's floor — it now builds the half and names the rate as set against the duration payout alone); IP §0.1's re-rule from play — a normal fight booked 1.17 steps where the sim read 2.56; IL §1's source partition and IM's parked split, which read its figures through its door; the merge recon's measure — its status-potency layer is the single largest unbuilt system the recon found, the one a merged tree needs (THE CLASS MERGE); and the spines' rule texts, owed the designer since GK (GK's RULINGS OWED), whose words count every change where the ledger counts one a body and status a turn. **So it is not retired** (JN's ruling 6, accepted at JO §0): retiring it would orphan the Hierophant's rune, the readout's field and fourteen gates. **Every figure above was taken before JI's cooldowns and before JN's cut**, and the Hierophant is a Cleric who pays Mana for every status he lays.
### FOUND AT JS AND NOT FIXED

- **A JS SAVE OPENED IN AN OLDER BUILD PLAYS THE FOREST, WITH RAIDERS WHERE THE FROST KINDS STOOD** (JS §1): no version moved — the zone's
  id and the new kinds' ids are values an older build reads generously (IB §0.2's rule), taking the zone as its slot's first candidate
  (`_drop_stale_save_keys`) and an unknown kind as an Orc Raider (`Enemies.config`'s fallback). Nothing crashes; the run reads wrong.
- **A SEEDED GATE THAT STARTS A RUN ROLLS ITS FIGHTS ANEW, AND A SIM's ROAD IS NOT THE FOREST's** (JS's ruling 1): the draw spends two
  dice at `new_run` — a seeded road reads them anew and can follow the draw into the Frozen Plains — `check_gf`'s, `check_gp`'s, `check_gv`'s and `check_gj`'s did at JS's recon, and `check_gp`'s count rose 458 → 484 (HEAD's code with JS's data reads 458); every other seeded row held its count. A sim meets the Frozen Plains in three runs of four and `run_sim`'s per-slot tables mix the two zones,
  so a figure compared against one of record, taken on the Forest's road, is retaken with `DOD_ZONE_ROTATION=0`.
- **A SINGLE-PICK CLEANSE TAKES SAP BEFORE THE FREEZE, A PARRY DOES NOT STOP IT, A FEINT CAN SEND IT TO AN ESCORT, AND A COMPANION
  SPENDS IT** (JS §3): JQ §2's aim takes a hex first, so a hero sapped and frozen in the Titan's fight (its escort can draw the Orc Hexer,
  a sniper since JR) keeps the freeze; the strike loop lays a status on any blow that did not kill, so a parried Entomb freezes, where a
  Block and a miss do not; a Swordmaster's Feint redirects the declared Entomb onto a fellow of the Titan's, which freezes for a turn
  (`_recast_writes`' comment); and Entomb and Hailstorm reach a hero's companion — a frozen beast ticks with its master and has no turn to
  lose, so the blow's freeze is spent for nothing.
- **THE SIX's NAMES NEAR-MISS LIVE ONES, AND THE SWEEP IS BLIND TO A COMPOUND's STEM** (JS §2, §3; the list in `docs/reports/JS.md`):
  no exact hit; the healer, seen in play as the Withered Warden, is the *Sleetveil Matron* (once *Hoarfrost Warden*);
  *Rimehorn* holds the Cryomancer's *Rime*; the sweep never met *Icewrought* against *Ash-Wrought* or the Gravewrought Coin.
  Labels in the warband's namespace ship and are flagged (BR §1); a rename is one string.
- **MOST OF `check_js`'s DOCUMENT NEEDLES BIND TO NO HOLDER IN THE PIN MANIFEST** (as JR named its four): the three backdrop needles (their path built at run time, so the file reads as missing), §0's ceiling sentence, its reason and its record and the rulings' reversal word, §6's readings and projection, §2's reads of `docs/master.html`'s enemy rows and of `JS-kinds.tsv`, and §4's of `JS-count.tsv` — a needle sweep
  through the manifest misses them, so it sweeps `check_js.gd` itself.
- **TWO CHEAP ROWS OF JS's SUBJECT ARE NOT BUILT** (THE RULES A GATE COULD CHEAPLY HOLD, the close-read): S2-046 (an enemy's self-cast is
  tagged `"ally"`) and S2-090 (a zone boss node fields `boss_kind()`, never a roster's `boss`-tagged kind — the Titan is one in rosters 4
  and 5). The brief keeps the cheap gates standing; both stay rows on the standing list, unbuilt, as FOUND AT JG records its own.

### FOUND AT JR AND NOT FIXED

- **THE BATTERY's ATTACKING FIGHTS ARE MOSTLY BOARDS A GATE SETS, SO A COUNT OVER THEM SEES THE DRAW ONLY THROUGH ONE ROAD** (JR §1): `check_jq` §4 fields each kind once by hand and most others are boards; only `check_fh`'s twenty, one seeded road, come off the composer (at JR the Hexer in 6, the Behemoth in 2, the Totem in 1). How often the game fields a kind is a property of the data, and `check_jr` §1 derives it through `Run._theme_combos` for every roster and budget; the count says what the gates' fights held, never how often a player meets a kind.
- **LINE-NUMBER CITATIONS STAND IN THE CLOSED RECORDS JR DID NOT SWEEP, AND IN SPELLINGS NO PATTERN HOLDS** (JR §2): the state's archive (738), the changelog's (25) and the recon and audit pages (544), and the reports' rarer spellings, each held at its count by `check_jr` §2; 64 of the reports' cited numbers JR could not settle, each said so where it stood (`docs/reports/JR-citations.tsv`). **A file's name, a space and a number** (about twenty in the reports, `IR-floor-census.md` most) and a bare number range in brackets after a citation cannot be told from a size or a figure by a pattern, so no gate holds them.
- **`check_jr` READS FOUR PLACES BY THEIR WORDS, UNLISTED IN `pin-manifest.json`** (FOUND AT JF's inline-pin shape): the WHERE block's readings lines (*at the open* and *at the close*, beside each file's name), a `**PROJECTED FOR**` line naming any batch, FOUND AT JD's strays count (*names in `check_iu`*, while the state states one) and `docs/ways-of-working.md`'s rule; a batch rewriting the WHERE keeps the first two, and its archive of JR's rulings or of an owed trigger's block is read where it went.
- **TWO CLOSED CORE BLOCKS CANNOT GO TO THE ARCHIVE** (§4): THE SHAPE RECON ON `CLAUDE.md` and FOUND AT IA are core by `check_is` §5's seven-of-nine derivation, which reds when the core moves; archiving either is a gate's repair first.

### FOUND AT JQ AND NOT FIXED

- **THE PUNISH READS THE DECLARATION AS IT STANDS** (JQ §3): **Encumbered adds 2 to every cooling move's cooldown on both sides** (`_spawn_units`), so under it the punish pays two turns' more; a declaration re-validation will refuse — a support cast falling back to the basic, Heads Down holding it to the basic — still pays; and a Break, a stun or a freeze discards a declaration only at the body's own turn, so until then the punish reads the move it held; it reads the declared action, never a spend beside it (a cooling Rally beside a basic pays nothing); and Encumbered lengthens Read the Tell's own cooldown too, 3 to 5. Forsaken's 3 turns are the card's: Sanctity lengthens a Hierophant's, and Fleeting cuts 3 from the body's, to 1 unless Sanctity lengthened it. Each is the card reading what the plate shows, not a defect; the designer's to judge in play.
- **THE BOT AIMS BOTH NEW CARDS AT THE LOWEST-HEALTH BODY** (`_bot_drafted_pick`, the default, no case written): for Forsake that is the body about to fall, which suits it; Read the Tell pays only where that body has declared a cooling move, so a smoke reads it met less often than a player would make it. A best-cooldown aim, Hunt's shape, is the policy to copy if one is wanted; the bot plays by the player's door either way.
- **`dispel_one_debuff` SKIPS NO STICKY STATUS, WHERE `purge_debuffs_taken` DOES** (FOUND AT HO's Bleed chip, the same shape): no hero can carry a sticky status today, so it is latent and unarmed — no gate reds the day one can; the aim ranks the Bleed chip last, and its filter is untouched (the brief: change only what picks one).

### FOUND AT JP AND NOT FIXED

- **A FIGHT WHOSE ENCOUNTER CARRIES NO THEME IS INVISIBLE TO A COUNT READ OFF THE LOGS**: the battle prints *Enemy warband:* only for a themed encounter in an active run, so a gate's hand-built encounter with no theme opens no fight a count can see (`check_hp`'s fights, attacks off, print their combat lines with no opening line, and so do `check_hk`'s and `check_ho`'s fixed boards before their first themed fight). The count's population is the fights that print their opening, and a fight quit and resumed opens again.
- **UMBRAL MIRROR's REBOUND IS DORMANT**: the strike loop would turn a warband debuff back onto its caster at `mirror_ranks`, and nothing writes that field — so JO's ruling 6's *Umbral Mirror can rebound a hex* holds of the code and of no game (`docs/reports/JP-answers.md`, the second answer).
- **A DRAIN WOULD MEET A DECLARED SPEND** (a latent shape, its writer the drain the next brief may build): a spend's price is set aside at its declaration, but `_warband_free_spend` buys it at the body's turn asking only the list, the cost and the cooldown, and it pays its flat price through `_malice_pay`'s floor — so a drain between the two lets a Rally or an Entrench land underpaid, the ledger booking its full price as spent and nothing saying so. A heal is bounded at resolution by `_malice_free`; a drain built to respect the reserve, or a spend asked its price at the buy, closes it (`docs/reports/JP-answers.md`, the first answer).

### FOUND AT JO AND NOT FIXED

- **THE PRICE ASSUMES EVERY POINT FILLS A METER THAT BREAKS** (the blocks' reader): JA's census (the reference party untalented at Wanderer, 559 fights) laid 180,544 applied Break damage for 733 hero Breaks, 246.3 a Break, about 2.4 meters of the price's 101.25 — Break laid on a Broken hero is wasted and a meter unfilled at a fight's end is lost. And a Break costs more than the turn: until it, armour ×0.7, +25% crit chance against him, no Block or parry; the lost turn is a basic's interval. Named, not priced; the rule is the designer's.
- **UNPRICED BY THE LINE, NAMED FOR THE NEXT PASS** (§1 premise 2, of the ten JN raised, with Dazed's two carriers): Sundering Strike's Sunder (−35% armour, 2 turns, 60%), Withering Hex's Exposed (+15% damage taken, 2 turns, 70%), Ride-by Slash's Cripple (−25% damage dealt, 2 turns, 50%), Swampy Grasp's Slowed (−25% speed, 2 turns, 70%); Dazed (+20% miss) is laid by the Withered Warden's Timber Slam and the Hollow Crown's Hollow Wail; and on their blows Gall, Sap and Mire. Beyond the ten, Tyrant's Verdict and the Sundering Decree lay a Sunder and the Grave Totem's Grasping Roots a Cripple; and Fester's growth past its flat tick, and the clock it takes back each turn, are unpriced too.
- **THE BREAK SHARE FALLS THROUGH A RUN**: an enemy's damage and DoT scale with its Attack, by slot and zone, and its Break damage never does, so the line's Break term is a larger share of a weak-Attack kind's worth (seven kinds stand under Attack 100: the Orc Totemist, Shaman, Hexer, Ritual Chanter and the Grave Totem at 50, the Bog Troll and the Shieldmaster at 75) and a smaller one deeper in a run. The census and the meter are read once, at the line's source.
- **THE SUNDERING DECREE STILL SITS UNDER THE LINE** (0.88 priced) on the Hollow Crown, whose second clears; Chieftain's Maul's damage is unmoved and its band held (JO's ruling 2, accepted at JP §0).
- **THE LINE PRICES A DoT TICK UNROUNDED** (the new text's reader): `check_ji.line_blow` takes a tick at its share of Attack, where `_dot_tick` rounds it and floors it at 1; only The Long Dark at Attack 115 differs (3.45 a tick against the 3 it deals), and no band moves.
- **`check_ji` §2 READS 400 CHARACTERS PAST *ENCUMBERED BINDS BOTH SIDES*** for *read on a warband with no cooldowns*, and JO's list of the moves that cool stands at 397: a longer list there reds it (JN met the same window at 402).

### FOUND AT JN AND NOT FIXED

- **THE PLATE's INTENT GLYPH CHANGES ON EIGHT MOVES** (the blocks' reader): `_intent_category` reads a move whose damage is under the unit's hardest as *afflict* and one whose Break damage exceeds its damage as *crush*; at the raised figures Sundering Strike, Poison Arrow, Withering Hex, Ride-by Slash, Flame Lick and Swampy Grasp read *strike* where they read *afflict*, and Overhead Crush and Blood Tribute *strike* where they read *crush*. On the LOOK-LIST.
- **POISON ARROW NOW LAYS A DEBUFF ONE TURN LONGER THAN ITS COOLDOWN** (*Named by the designer, carried from CX*): six of the ten moves that laid a debuff and carried no cooldown carry one now — Sundering Strike, Poison Arrow, Withering Hex, Ride-by Slash, Flame Lick and Swampy Grasp — each its debuff's length but Poison Arrow's (3 against 2); since JO §2 Gall, Mire and Bone Rattle's Sap lay 3 against a cooldown of 2 too (JO's ruling 5, accepted at JP §0).
- **BLOOD TRIBUTE's BAND IS ITS FRESH FIGURE's**: at 42 it priced 1.40 at JN, and since JO §1 at 44, its Break priced, 1.42, with none of its warband fallen and 3.15 with five; JI's line bands it 2 off the fresh blow, as it banded it 0 before.
- **ENCUMBERED BINDS NINE MORE COOLING MOVES** (the Bellow cooled since JJ), and **PARCHED AND WARDED, BOTH KEYED ON HERO RESOURCE, STAND AT A TIE WITH THE 1.78 CUT** (the blocks' reader): neither re-read; the Cleric's cut presses where they bite.
- **THE CLERIC's CUT PRINTS THE UNCUT FIGURE ON SOME GAINS' OWN LINES** (FOUND AT JL's shape, for Sap): on a Cleric's own cards and talents, a gain that prints its own figure states what it hands over — Conviction's release, Divine Plea's Perfect (*Restores 10 Mana*, 5 kept), Dark Pact's Perfect (*Restores 5 Mana*, 3 kept) and Font of Light — and one that reads the bar before and after states what the setter kept — Siphon and the Mana Potion drunk in a fight; the bar shows what was kept. `check_ic` §1c(b) read Siphon's line on a Devout and was re-pointed to the cut.
- **RALLY's WORTH ROSE WITH THE BLOWS IT MULTIPLIES**: JK priced it off the median basic, which JN's raise did not move, so `check_jk` §2 stayed green while the price it read went stale; since JO §1 every basic carries its Break, so the median moved, and the Wolfrider's Rally is one of the nine bands held (JO's ruling 2, accepted at JP §0).
- **THE CONTENT HOLE IS CLOSED FOR EIGHT OF ITS ELEVEN** (the close-read; JN's ruling 1, accepted at JO §0): of the eleven kinds the hole named, the eight whose second move deals damage attack with a basic and a move at the line since JN §1; **the Orc Shaman, the Orc Shieldmaster and the Orc Ritual Chanter still attack with a basic alone** — the Shaman's Healing Wave prices under the line as a heal (0.53 at JN; lower since JO §1 priced Chain Lightning's Break) and does not cool, Shielding and Cleansing Rite are unpriced — and the Orc Totemist, outside the eleven, holds one damaging move too — and the Grave Totem, outside them, two since JO §2 gave Mire damage. No move was authored (the brief's §3). Since JS the Sleetveil Matron, a basic beside a heal and two spends, is a fourth by construction (JS's ruling 2).
- **THE CUT REACHES EVERY RISE OF A CLERIC's BAR IN A FIGHT, THE EDGES TOO** (the new text's reader): Resurrection raising a fallen Cleric lands his bar cut — a quarter of it or the whole, as the card reads, is cut on the rise — and so does the debug full restore. **And Boil Over meets one door that pays it nothing**: Honed fits it (`upgrade_fits` reads `damage > 0`, and its `damage` holds 150 so it keeps its bar), and the flat strike never reads the field — since HZ, unchanged by JN.
- **TIER 1 WHOLE WEARS THE +20 POOL NODE** (the close-read; FOUND AT IG): every Arm B Mana hero opens his first fight at 100 of 120 (Rage carries nothing between fights), and a Cleric refills it at half since the cut; Boil Over's top of range there is 120 Rage, 180 before armour. Both bias against the talented arm, so Arm B's answer stands.
- **`check_ea` §3's BATCH-CODE PATTERN WANTS THE WORD *BATCH*** (the new text's reader): a needle pinning *JN §0* against a rule file passes it; JN's one such needle (`check_hz` §2) is re-pointed to the rule's own words, and the pattern is left as it stands. `check_jn` §1's kit walk and its digest of the warband were staleness tripwires as its Thin Air digest was; since JO the kit walk (JN's kit against JM's) and the Thin Air digest (the record naming JN's tree) are JN's record and cannot red, and the warband's digest (`check_jn`'s `DATA_REST`) stays the tripwire — a later enemy tune re-points it, as JR's three appearance tags did through `MOVED_SINCE` — beside `check_jo` §1's digest of the rest of the data against JN's; and no rule file states JI's line as the rule a later kind is authored to.


### FOUND AT JM AND NOT FIXED

- **A RUN THAT OPENS HOLDING THREE RELICS LOSES THE COLLECTOR's GRAVE's RELIC** (`scripts/events.gd`'s `relic_grant`: with three held it pays 40 gold instead) — the game's own rule for a player holding three, so §2's arm carries it as a player would; the two relic sources are not additive.
- **A `special` READS NO REACH** (the blocks' reader): `_resolve` sends every `special` to `_resolve_special` before the strike loop, the one place `aoe` widens a move, so a data `aoe` on a special changes the plate (⇉) and the hover (*Hits every ally*) and nothing that lands. **The hex arm read it from JM §0 until JO §2 put every hex on a blow** — the strike loop widens Gall now, and the arm and its hover went with the special; any other special that should reach every hero needs its own arm and its own hover line.


### FOUND AT JL AND NOT FIXED

- **A HEX LIFTED BY RETURNED BURDEN LANDS ON THE WARBAND** (the blocks' reader; FOUND AT HF): Sap then cuts a Rage body's bar, Mire slows it, Gall halves its heals and Fester grows on it, found by name; nothing priced it.
- **FLEETING CUTS EVERY HEX TO ONE TURN** (`max(3 − 3, 1)`), and the selection still casts them, reading no modifier: Fester ticks once and goes; **a one-turn Mire slows nothing** (its clock runs out at its bearer's next turn start, before the action whose delay it would lengthen); a one-turn Sap cuts only what the bar gains before that turn start, the drip coming after the clock; a one-turn Gall halves the heals between.
- **THE BOT CASTS UNBURDEN ONLY WHEN NO ALLY IS UNDER HALF** (the blocks' reader): Ministration first, so a festering hero waits on the Cleric's other card.
- **A SPEND's COOLDOWN WAS PRICED AGAINST A TURN NO SPEND GIVES UP NOW** (JL §1 premise 3; JL's ruling 3, accepted at JM §0): not re-derived, as the brief ordered.
- **THIRTY-TWO SPENDS KEEP A `delay: 2.5` NOTHING CHARGES NOW** (the close-read; JS's eight copied the key): a spend is never the declared action, so `_resolve`'s delay tail never meets one. A dead key, named; deleting it moves `check_ji`'s and `check_jk`'s digests, a later batch's.
- **UNDER SAP A GAIN's OWN LINE PRINTS THE UNCUT FIGURE** (the new text's reader): the setter is the door, so no caller knows — Overburn's refund, Holy Light, Font of Light and every `+%d Mana` float print what the card meant, not what the bar took. Recant books what landed and is the shape to copy. And the IV probe's full-bar what-if writes the bar too, so on a sapped hero's turn its *dry* reading misreads — at most 54 sapped hero turns in 946 fights (every hero's; the what-if reads the Mana heroes').
- **A FLOATING TEXT DRAWS THE GAME's OWN DIE** (found by JL's third drive arm, `docs/reports/JL.md` §3): `BattleUnit.float_text` places every floater with `randf_range`, in a sim as on screen, and every status a spend lays floats its name over each body it lands on — so moving a body's buy ahead of its re-validation (the fresh reader's repair, JL's ruling 2, accepted at JM §0) moved those draws ahead of a re-aim's random pick, and 13 of sixty seeded runs parted on that alone, a blow whose declared target was gone re-aimed at random at another hero, with no rule changed (8 more parted on the repair itself, a Raise bought beside its body's heal). A cosmetic draw belongs on a generator of its own: one line, but every seeded reading and baseline parts once, so it is a batch's own.
- **`CLAUDE.md` STILL PLACES A SUPPORT CAST's TARGET IN `_enemy_support_action`** (the close-read): since JL §1 the spends' targets are chosen in `_warband_spend`, which `_declare_intent` asks, and its list of every self-cast omits the Rally and the Entrench since JK. One clause, the next time that file is opened; `CLAUDE.md` takes nothing this arc.
- **TWO GATES READ A LITTLE LESS SHARPLY** (the positional readers): `check_in` §3's needle `_eff_cost(u, a) <= u.resource` stood twice in `_choose_enemy_action`, the hexes' filter beside the attacks', until JO §2 deleted the hexes' filter — it stands once again, on the attacks' line; and `check_hu` §4a's counter walk reads unit.gd's `P%d`, `C%d`, `R%d` and `Bl%d` and not Fester's `Fr%d` — its letters are its own status's `Fr`, so nothing is shared today. And `check_hz` §1a builds its intents by hand with no spend, so the hover's *First, free* is held by `check_jl` §1 alone.


### FOUND AT JK AND NOT FIXED

- **UNDER FLEETING A RALLY BUYS NOTHING AND AN ENTRENCH ONE TURN, AND THE POLICY STILL BUYS BOTH** (the close-read): Fleeting takes 3 off every status, floored at 1, on both sides, so a Rally's clock runs out before a body strikes and an Entrench covers one interval; `_warband_spend` reads no modifier. **Since JL §1 its buyer strikes rallied once under Fleeting**: it buys and acts before any tick. **And Brittle zeroes an Entrench**: `effective_armor()` returns none first.
- **A BODY OVER 377 HEALTH IS NEVER RAISED** (the blocks' reader; the fresh reader's bound): its price, the health it stands up with, passes the cap of 150 — every boss, and at Warden the larger bodies of zones two and three. The brief's 51 and 120 are zone one's unscaled bodies.
- **RAISE SKIPS BLOODLESS** (the blocks' reader; the new text's reader): `revive` sets health, so the no-heals modifier stands a body up, as it lets a hero's Revive Potion and Resurrection stand one up.
- **A RAISED BODY's SECOND FALL IS A SECOND KILL**: Malice's kill term fills again and every hero rider a kill pays pays again — the Reaver's uncapped count among them (GO's ruling 1), which can pass the warband's size now. **And Blood Tribute counts the bodies down now**, so a raised body that fell this fight stops feeding it, where its words say *fallen this battle*.
- **CALLED SHOT's MODE READS A BODY's OWN ARMOR, NOT ITS ENTRENCHED ONE** (`ss_t.armor > 0.05`), the bot's choice of a hero card's mode, not a blow; **and the sim's warband reading** (`run_sim.gd`'s effective-health term) reads the raw armor too. **RALLY REACHES THE WARBAND's BLOWS, NOT THE BURN AND POISON IT LAYS.**
- **`check_jg` §3h's SWEEP COUNT FOLLOWS THE GAME, ITS RULING's FIGURE DOES NOT**: JK's three moves and two statuses grew the names past JG's 1,392, so the arm reads the archived figure as the floor the sweep stood on. **FOUND AT IT's reason for the Chilled row's literal does not hold**: `STATUS_INFO`'s Sunder row and JK's Entrenched row each name a `BattleUnit` constant and parse. **The brief's process note 37 is nowhere in the tree** — answered at JL §0: a brief cites only what the repository holds.


### FOUND AT JJ AND NOT FIXED

- **A HEAL IN A FIGHT's FIRST HALF IS THE ONE THE POOL CANNOT PAY** (JJ §4): the timing behind JJ's ruling 4, accepted at JK §0, read off the drive's cast order (the work folder's *jj_timing.py*, outside the repository, folded into the kept table).
- **THE WARBAND HEALED 18.5 A FIGHT AT WARDEN ON JI's TREE**, where the share census reads 31.6 at Wanderer on a warband with no cooldowns (the blocks' reader); the census stays JA's record: **the arc's fifth batch, JM, priced Gall off it as it stands and did not re-take it**, its brief ordering no census (THE WARBAND's HEXES).
- **A HEAL's FLOAT AND ITS LOG LINE PRINT WHAT THE HEAL PIPELINE RETURNED**, an overheal included, as they did before JJ; the pool pays the health the body gained. **The intent's hover names a declared heal and not its price.**
- **THE ENEMY DESCRIPTIONS STATE THEIR SHARES AS LITERALS** (Healing Wave's 25%, Wild Growth's 20%, Dark Vigil's 6%), pinned by `check_ij` §3 to `_warband_heal_figure`; none names Malice but Healing Wave's, whose *under 40%* went with its policy. The strip's hover states the rule.
- **DAMAGE THE FRAME CREDITS TO NOBODY FILLS NO MALICE BUT ITS KILL** (the close-read): the Bomb's blast, a spread Burn laid with no source (FOUND AT II) and the Wasting bargain's tick on the warband (the fresh reader) are no hero's by the frame, so they fill nothing until a body falls (JJ's ruling 6, accepted at JK §0).
- **THE IN-GAME GLOSSARY HAS NO ENTRY FOR MALICE** (the close-read): the strip's hover is the player's word for it, and the master document's keyword list carries one; a glossary entry moves the file's count, a batch of its own.
- **THE PRICE THE SELECTION ASKS IS THE HEAL's FIGURE, NO MORE THAN THE BODY IS MISSING** (the new text's reader): it does not read Frostbite's half, Miasma's or a refusal (Bloodless), so it can ask more than the heal will restore; the heal pays only what it restored. **Two healers can each set aside a price for one wound**, and the second then restores and pays less. **A heal multiplier that ever reaches the warband** (none does; JK's Rally multiplies the warband's blows and never a heal, `check_jk` §1) would let a heal restore past what was set aside, and the pool's floor at zero would hide it.
- **WILD GROWTH's COIN IS GONE, SO THE WITHERED WARDEN's FIGHTS SPEND ONE DIE FEWER A CHOICE** (the new text's reader); seeded fights against it read differently from that choice on.


### FOUND AT JI AND NOT FIXED

- **A DECLARED SUPPORT CAST THAT RE-VALIDATION REFUSES FALLS BACK TO THE BASIC AND KEEPS ITS ALLY TARGET** (the blocks' reader, read in the code and driven nowhere): `_revalidate_intent` swaps in `_cheapest_attack`, clears `support`, and re-targets only a target that is gone or held, so the basic lands on the enemy's own ally. Reachable at HEAD through Heads Down on an enemy that declared a support cast; JI's selection never declares a move that will still be cooling, so a cooldown cannot reach it. The Long Silence's declaration (`_declare_intent`) is the shape a repair copies: re-aim at the hero side.
- **THE `CD` CHIP IS THE TWENTIETH DISPLAY CHIP**, outside IE's kept census of nineteen and `check_ig`'s list: that gate carries one of the thirteen standing picks, and touching it reds `check_iu` §5. Its tag is walked by `check_hu` §4a with every other; `check_ji` §1e drives it.
- **WHAT THE RULE DOES NOT PRICE** (JI §1): a ward (Shielding, Regalia), the cleanse (Cleansing Rite), and the debuffs a move lays beyond Burn, Poison and, since JO §1, Fester's tick (Sunder, Exposed, Cripple, Slowed, Dazed, and since JO §2 a hex on its blow); since JO §1 a move's Break is priced — each needs the party's own figures to be priced as damage. **Blood Tribute is priced fresh** (0.67 of its basic) and grows to 1.5 with five fallen; it carries none, being the kill-order question itself. *At JI; since JN §1 it dealt 42 — 1.40 fresh, 3.15 with five fallen — and since JO §1 44, 1.42 fresh with its Break priced, cooling 2 off the fresh blow (FOUND AT JN).*
- **THE COMMENT OVER THE SELECTION's FILTER SAID *OFF-COOLDOWN* AND THE FILTER DID NOT ASK** (the blocks' reader): false at HEAD, true since JI §1.
- **TWO GATES PIN THE WHERE BLOCK's BATCH-SHAPED TEXT** (the blocks' reader): `check_jh` §3d asks it for *PROJECTED FOR JI* and `check_jg` §3c for Communion's card. JI's block carries both — it checks JH's projection, and Communion stands — but the next batch that rewrites the block without them reds two closed batches' gates. Left: a gate re-pointed at its own batch's record is the repair, owed by whichever batch meets it. *JJ met it: `check_jh` §3d asks for a projected figure for the next batch, whichever it is; `check_jg` §3c's card stands in JJ's block.*


### FOUND AT JH AND NOT FIXED

- **THE CHIP's CONDITION LINE IS ONE TOOLTIP LINE OF 65 CHARACTERS** (JH §1, the blocks' reader's): `battle._rune_chip_for` writes *Pays only …* without `_wrap_words`, and a tooltip does not wrap. JG's ran 61, so the overflow predates the re-key; the effect line under it wraps at 44. Left: one call, and the look-list row says so.
- **A SAVE WEARING JG's COMMUNION IS REBUILT AT THE LOAD DOOR** (JH §1, IS §2b's door, driven by `check_jh` §1h): its payload names `stat.rune_core_strike` and `condition.heroes_hold_core`, paths today's definition does not, so `Run._rebuild_stale_payloads` rebuilds it from today's and the map says so. **Its card is rebuilt with it since JH**: the door replaced the payload and kept the saved words, so a JG save would have paid the re-key while its panel read JG's card (the new-text reader's finding; `check_jh` §1h drives both). No save version moved. **A payload field changed what it means**, as the rule asks a batch to record: the flag is gone, and `dmg_bonus` carries the figure.
- **`heroes_hold_core` AND `Runes.core_noun` STAND WITH NO LIVE RUNE ON THEM** (JH §1): the key's door, its words and its noun are kept for the next rune that names a core; `Runes.core_noun` still reads empty for a core no rune carries (FOUND AT JG).
- **CLAUDE.md's CUT CAME IN UNDER 6 KiB (JH §3)**: 5,094 B. The next-nearest closed block, named and not cut: `## STANDING DESIGN RULE — A RUNE'S COST MAY BE BOUGHT BACK, AND PAYING FOR THAT IS THE DECISION` (2,246 B), its case retired at ET §1 and its node deleted at FX; its ES §3 bullet holds live facts (`test_runes.COST_WITHOUT_A_TERM`, `anchor`'s −10 Speed), which travel with it.
- **THE POSITIONAL CENSUS HOLDS NO READ OF A GATE WRITTEN SINCE IT, AND JH's ONE UNPREDICTED RECON RED WAS SUCH A READ** (recon 1): `check_jc` §4 took the first `### THE CREST POOL` block in `DoD-archive/state-archive.md`, and the archive takes the newest cut first, so JH's closed crest items stood above JE's, where its record is. Repaired to intent, every block of the name (`check_jc`'s `_blocks`; JH's controls C20 and C20b drive both arms). The 489 reads of `docs/reports/IT-positional-census.tsv` are gates' up to IT; a positional pick in a gate from IU on is read by no re-run. Left: growing the census is a census's cost, named here.


### FOUND AT JG AND NOT FIXED

- **`Runes.core_noun` RETURNS EMPTY FOR A CORE NO RUNE CARRIES** (JG §3, the new-text reader's): a chip on such a key would read *while a hero wearing the  stands*. No live rune names a core since JH's re-key, so nothing shows it; the next rune that names one owes the arm.
- **FIVE ROWS OF THE STANDING LIST SIT ON JG's SUBJECT AND WERE NOT TAKEN** (JG's brief §5, which keeps the list): S4-001, S4-017, S4-026, S4-028 and S4-031. The list's block says the batch that touches a rule works its row through; the brief says otherwise, and the brief is later.


### FOUND AT JF AND NOT FIXED

- **JE's CREST *NONE* WORE A CREST RUNE** (JF §4, `docs/reports/JF-crest.tsv`): the bot wears the first crest rune it draws (`RunSim._sim_take_drop`), in 55 of 60 runs at Wanderer, 44 at Warden, 38 at Ruin and 166 of 180 on the incumbent, so *paired by seed against the same party with no crest* is false of `docs/reports/JE-crest.tsv`, and since a crest rune entered the drop (HO §3) a default sim's party ends most runs wearing one (row DV35). Against a true none, on JE's arms: at Warden depth +1.62 ± 1.14, +2.42 ± 1.09 and +1.22 ± 1.04 for Dirge, Dead Air and Empty Pulpit, finishes 9 of 60 against 5 on each; at Ruin flat. **Dead Air's depth reads past two errors at Warden, and so do the default arm's finishes; a kept report is not rewritten, and no figure moved.**
- **THE HUNK PASS CLEARS A FIXED-WIDTH READ TOO** (JF §6): `pos_seq.py`'s control found a fixed-width read pushed by lines that hold no needle, and `pos_hunks.py` clears such a read one pass earlier, because it reads needles and no width. At JF the extra pass, `tools/pos_width.py`, sent such reads to the positional reader with the population reads, and none left its subject. The next batch copies it.
- **AT WARDEN THE REFERENCE FOUR FINISH 5 RUNS OF 60 WITH NO CREST WORN** (JF §4): so that rung's *runs that finish* row, 14.3% for Dirge, rests on five runs; 9 on the default arm. The incumbent finishes 60 of 60 at Wanderer and Warden, and its rows are the ones to read there.
- **TITHE's UPTIME IS A BLOW's, NOT A CONDITION's** (JF §4, `docs/reports/JF-uptimes.tsv`): it has no condition, so the table reads a hero turn whose attack lands Break with a hero below full: 43 to 45% of hero turns on the reference four, about 2.8 health a hero turn; 33 to 35% on the incumbent, 2.9 to 3.5. Fellowship's condition reads 24 to 29% and 5%.
- **AN INLINE `_doc("res://…").contains(…)` PIN SITS OUTSIDE `check_ed`'s SCAN** (JF §6, the positional reader's side finding): the shape stands in `check_iv`, `check_jb`, `check_jc`, `check_jd` and `check_je`, and `check_jf` adds two; most have no manifest entry. A pin with no entry is asserted and unlisted. Not repaired.
- **THE TOOL THE CONTROL PROVED BLIND HAD CLEARED 54 READS AT JD AND JE** (JF §6, the fresh reader's replay): each re-read on the tree that lands, `docs/reports/JF-backread.tsv`: 50 stand on their subject, 4 stand tight, slack under a tenth of their width, and none is off it or unread. Three of the four red loudly if pushed. **`test_batch_bm` §9 is the one that would not**: its 1,400-character window reads 18% of the branch its message names, 60 characters of slack, comments filling the rest. And `Gate.within(x, at, Gate.block(x, at))` is true of any non-empty block, so it shows nothing about what a block covers, and a column-0 comment ends a block silently: `test_batch_bs`'s read of `take_tick_damage` is negative-only.
- **THREE THINGS NAMED AT THE CLOSE AND NOT TAKEN**: two census sentences stale at HEAD (*no scope swallows a static func*, on rows 31, 34 and 304, and rows whose selection predates `Gate.block`); three blocks the close-read found nearly closed after the cut was done (`### ~~THE END BOSS HAS NO BUTTON~~`, which still owes two wordings, `### THE MERGE'S RUNNING ORDER`, `### HA's RULINGS OWED`); and three partly closed items (FOUND AT HO's Tithe line, FOUND AT GC's *28*, FOUND AT GL's Renewal). *The three blocks went to the archive at JH §3; the census sentences and the FOUND AT lines left whole stand.*


### FOUND AT JE AND NOT FIXED

- **THE FALL's COST IS THE BASE WITHIN A POINT, NOT THE BASE** (JE §1): each share truncates apart, so on one maximum of 135 it reads 20 or 21 by relic set. The card and the rule say the base; the odd point is arithmetic.
- **THE CAIRN AT 12 IS STILL RARE** (JE §2, `docs/reports/JE-pool.tsv`): 5 draws in 240 three-relic runs where 8 drew 1 on the same seeds, and it moved no fight of the 120 runs JD read. It wants a fall in the fight before an event, and the bot walks past most events.
- **THE TEXT STANDARD's §4.9 AND §4.9b OVERLAP** (JE §3): §4.9 is the account of how each failure was found and §4.9b the shorter statement, and §4.9b's head says the later wins. A rewrite into one is a words batch nobody asked for.
- **A CREST ARM CANNOT TELL A RUNE THAT SAVES A RUN FROM ONE THAT LENGTHENS IT** (JE §4): falls rise with each rune at Warden and depth with them, and falls a fight move 0.336 to 0.346–0.354. Sixty paired runs read neither past 1.6 errors; *its *none* wore a crest rune, and against a true none Dead Air's depth reads past two (FOUND AT JF).*


### FOUND AT JD AND NOT FIXED

- **`revive_pct` AND `fallen_hero` HAVE NO USER LEFT** (JD §4): the Cairn was the only event that named either, and §0.1 means neither can ever fire. The brief's §7 leaves the events as they stood, so both stand; the recommended next step is deleting both, on §0.2's own *delete dead code rather than prop up a feature to justify it*.
- **`Relics.is_suspended` STANDS WITH NOTHING IN IT** (JD §4): Cairnmoss Poultice was the one relic it held. The door and its four readers stay for the next relic that loses its hook; `POOL` is a `const`, so `check_ik` §6 can no longer drive a suspended relic.
- **A STRIKE LANDS ON A CORPSE ITS OWN BOND FELLED** (JD §3): the second death's road. A Sacred Resolve share under the Oathkeeper's bond comes back on the struck hero as a tick; the strike then lands on the body. No Break and no second callback now, but the log prints its damage line on a hero already down. `battle._resolve` could stop there; not asked.
- **AN OATH DEATH IS BOOKED ONLY BY THE BLOW THAT FOLLOWS IT** (JD §3): `_on_covenant_share` books no `hero_deaths`, so a hero the oath fells outside a strike is on no tally. The sim's stat, not a grade.
- **THE MARK IS A HERO DOWN AT THE END, AND THE READOUT's `fell` IS A HERO WHO WENT DOWN** (JD §2): two different counts under one word, 3 of 290 apart in JC's table; and a hero laid down in a resumed fight carries the mark with `fell` false (FOUND AT JC).
- **EIGHT USER FOLDERS OF JD's STAND OUTSIDE THE SPENT PATTERNS** (JD's report §6): lanes made under a report's short name (*IC work*, not *Dawn of Decay IC work*), which lost the project prefix. `check_iu` §7 names each with how it came, on IT's precedent — ten names in `check_iu`'s `KNOWN_STRAYS` with IT's probe and the unnamed project — and THE MOVE IS NOT ATTEMPTED, so they stand until the designer clears them; the report carries the command, and `check_iu` prints a notice for each one gone, whose line a later batch deletes.


### FOUND AT JC AND NOT FIXED

- **THE READOUT COUNTS A FALL AND NEVER ITS LENGTH, NOR WHAT RAISED HIM** (JC §4): the one real run's two falls stood at the fight's end, and the file does not say by what; and it is built after the spawn, so a hero laid down in a resumed fight books `standing` false with `fell` false.
- **`OUTPACED_SPAN` IS A VALUE, AND IT WAS NEVER DRIVEN** (JC §0.2): the brief calls Outpaced a rule with no value to turn. A wider span hands the warband more turns ahead of the heroes, so its ceiling was not read as Fractured's and Porous's were. The deck is closed, so nothing follows.
- **OUTPACED's *CLEARLY FASTER* IS A SPAN's WIDTH MOST OF THE TIME AND A HAIR AT ITS EDGE** (JC §0.7): the test is which span a clock stands in, so 0.02 across a boundary passes. The words are the designer's and they stand.
- **OVERGROWN AND WASTING ARE NOT CAPACITY, AND WASTING IS THE HARD CASE** (JC §0.4): Overgrown leaves `max_hp` whole and Wasting is a tick, and healing answers both, so *healing cannot restore what a body cannot hold* is Rot's shape alone, and the ladder block says what each does. **Wasting, the deck's top reading at +36.53, is a drain**: it stands with the rule only because it is sized on the body and not on the blow.
- **WATCHTOWER HAS NO WRITER** (JC §2): nothing in `scripts/` or `data/` sets `watchtower` and no text names it, so `_watchtower_check` cannot fire. The brief's five seats are four live and one dormant, and the glossary's line holds of all five.
- **A HERO SEATED DURING AMBUSHED's RUN LANDS ON HIS SLOWEST OPENING WHEN IT ENDS** (JC §2): `_ambush_moved_on` caps what moves on, so a free action taken inside the run, Last Word's or Slaughterhouse's, sits behind the heroes who rolled earlier. JB's comment says so. That is why the glossary's line promises no place among the heroes.


### FOUND AT JA AND NOT FIXED

- **THE ID THE RENAMED CARD KEEPS** (JA §1): `frenzied`, because a save names a modifier by its id and the project has no rename path for one — the load door's map is the cards' (`Run.RENAMED_CARDS`). The id is the old name's one live survivor; a rename map for modifiers is owed only if the designer wants the id to follow the name.
- **THE STRIKE LEDGER IS NOT THE DOOR** (JA §3's fidelity): the hero strike loop's `final` is the blow computed, before a barrier, a death refusal or the vow, and it holds no companion's blow (`_companion_hit`) and no special that resolves outside the loop — so the warband's strike damage reads 1.6 times its damage at the door on the reference party. A census of what a rule keys on reads the door for damage and the loop for blows, crits and armor; the armor row is the loop's site alone (about twenty other sites in the specials take armor off their own figures).
- **THE BATTERY's 240-SECOND WATCHDOG SAT ON `test_batch_bk` ON A SLOW DAY, AND THE CODE WAS NOT WHY** (JA's recon 1): `test_batch_bk` and `check_ez` timed out on the pre-check and again on recon 1, reading like a hang. Run alone they pass, at 243 s and 207 s against about 135 s and 126 s at every acceptance through IZ; run side by side, HEAD and JA's code read 366 s and 361 s, 385 s and 388 s, so JA costs nothing and the machine was slower that day, for a reason nothing read (on mains, no thermal warning recorded, memory free). Recon 2 and the acceptance ran under the battery's own override, `DOD_SUITE_TIMEOUT=480`, its 240 s default retained. **A timeout on either gate is a question for HEAD's copy first.**


### FOUND AT IX AND NOT FIXED

- **AN OFFER SAVED BEFORE A RE-GRADE DEALS A MODIFIER AT ITS OLD REWARD.** A save frozen on an offer holds the ids it was dealt and the reward rolled for each: an id the deck no longer holds (Dull Edge and Tinderbox since IZ) is dropped at the load door (IQ §4), and one whose grade moved shows today's severity — the card reads it off the deck — beside the reward rolled at its old one. **No modifier carries severity 0 since IZ**, so the *SEVERITY 0* card this item named at IX can no longer be dealt. The designer's save holds no offer (read through the backup copy). Latent; a guard on the door is the fix if it is wanted.
- **THE REFERENCE PARTY's HEADROOM CAPS A GIFT** — it ends a bargain fight at 0.944, so a modifier that pays it can read at most 5.6 points above the baseline: *pays the party* (§1) is a verdict this population can barely give.
- **THE REFERENCE PARTY's HEALING TAKES UP WHAT A TEMPO HALF COSTS** (§2d) — Frenzied's (Leaden's since JA) and Hoarfrost's halves move the healing a bargain fight takes by 35 to 58 of 233, in mirrored pairs, and the party's health at the fight's end does not move. A tempo handle turned to cost a severity is turned against that healing on this party, and a party without it would read the same handle differently — §0.2's one party, met at the repair. Read, not pre-registered; not proved. **IY §3 read it at an extreme and did NOT confirm it**: on the two-sided arms the healing moved with the cost (Hoarfrost) or not at all (Frenzied) — FOUND AT IY, archived at JO.
- **`check_hk`'s LIVE WALK IS NOT SEEDED, SO ITS COUNT IS A COIN FLIP** — 166 or 168, as the walk meets 26 normal fights or 28 (HEAD's own gate on HEAD's own tree read 166 alone; IW took it for load). Its row is the readings' band since IX ([166, 170]); seeding the walk is the repair, not built.

### FOUND AT IW AND NOT FIXED

- **RESOLUTION AND BREADTH PULLED APART, MEASURED** (IW §1a): the screen's winner is one party — the sim's default lineup, untalented,
  at Wanderer, R5 20.1 — while IG's three parties under the same terms read 11.0: their party-to-party spread is noise to a
  ladder, so a population broad enough to speak for every lineage resolves the deck about half as well. IW's ladder is four lineages'
  (THE BARGAIN DECK's GRADES says so where the grades are read); a ladder for the whole roster at this resolution wants about three
  times the runs ((20.1 / 11.0)² ≈ 3.3), which is what the screen exists to avoid.
### THE RULES A GATE COULD CHEAPLY HOLD — **A STANDING LIST (IV §5, the designer's): 187 RULES, 76 OF THEM HELD BY NOTHING; BOTH COUNTS ARE CEILINGS**

**What it is.** IU §2's rules census of record (docs/reports/IU-rules-census.tsv, one row a standing rule in `CLAUDE.md`, or a rule that left it, read where it went)
read every rule against the gate that holds it, and its cheap column marks the PARTLY and NONE rows a gate could cheaply
hold: **187, 76 of them NONE** — the highest-value instrument work left, because a rule nothing holds is one a batch breaks
with the whole file in front of it (IT broke HO §0 162 times while no gate held it).
**A STANDING LIST, WORKED THROUGH BY THE BATCH THAT TOUCHES EACH RULE's SUBJECT** — not a batch, and not urgent, because
the queue the deck displaced comes first. A batch whose work touches a listed rule's subject builds the gate the row names and re-reads
the row in place, HELD with its gate and section; `check_iv` §5 holds both counts as ceilings that do not rise, the practice
of `check_gw`'s hand-sets, IU §5's MISSES and the divergence census's RULE rows (`docs/instrument-rules.md`, `check_gw`'s
block). **IV re-read one row and the list did not move**: S3-009, NONE and not cheap (a ruling was owed before any gate),
re-read HELD where the code decided between the rule and its gate (IV §0.4) — the census reads HELD 311, PARTLY 232, NONE
284 since, and the list 187 and 76: JF re-read S4-003, the crest runes' figures, HELD with `check_jf` §4a.
### FOUND AT IU AND NOT FIXED

- **RULES THE CODE BREAKS AT HEAD, FOUND BY IU §2's READERS AND VERIFIED IN THE CODE BY EACH**: the draft block's *do not write
  `12 * 8` again* (`test_batch_ce` and `test_batch_cd` still assert `> 12 * 8`); *the ledger books what left the bar* (the
  Blood Price rune's `note_resource_spent` books a Rage-equivalent of health that never left it); HO §0 (`battle.gd`'s comment
  over Faith's mitigation speaks the threshold as five, which neither `check_hp` §6's phrases nor `check_it` §2c can see); and
  the contagion reservation may be breached by the live Shared Ruin rune, which moves Ruin stacks between enemies when a mark
  detonates — **the designer's to rule**, and no claim was recorded.
- **GATES THAT HOLD LESS THAN THEIR RULE CITES THEM FOR** (each a PARTLY or NONE row of the census, and a gate could hold most
  cheaply — the census's `cheap` column): `check_cs` §5 tests its own copy of the bot's roll, not the bot's; `check_cz` §3's
  `HEALS_STAY` holds 14 of `Ability.HEAL_SPECIALS`' 18 (Salve unchecked); `check_cl_width` only reports; `check_co` never fails
  on an inert member and its `MUST_NOT_GATE` misses the four power-not-magnitude cards; `check_if` §1b runs on the free clock
  (`run_battery.sh` passes `--fixed-fps` to `test_batch_bl` alone); the debug table's *not for deletion* is a notice in
  `check_hx` §1c, never a red; the flat 150g is asserted over 80 of the 104 live runes; ~~`check_is` §6 reads batch codes A–I
  only~~ (**widened after JB, and at JC it holds every code the reports carry; its other half, the rule's word list, is still PARTLY**); `check_is` §4 checks two of the three bot ally pools; `test_batch_bx` §4b's file set omits `scripts/runes.gd`; and
  `test_batch_bo` §5 is blind to slot 0 (FOUND AT GL's Quick Shot), so its row reads PARTLY.
- **STALE CLAIMS OUTSIDE THE CLAIMS POPULATION, MET AT IU's ROUTING AND ITS CLOSE-READ**, each on record where it stands:
  FOUND AT HV's two `CLAUDE.md` lines, HY's *HD §2's four*, GA's EU reading, GF's Resonance half, FW's *four death-refusals*
  (now `docs/combat-rules.md`'s) and GR's ways-of-working header. **And the copies IU's repairs left in comments** — each an
  asserted surface, repaired with its subject: `check_ec.gd`'s header, `check_ea.gd`'s, `run_battery.sh`'s `check_de` comment,
  `gate_fixture.gd`'s window note, `test_batch_bi.gd`'s, `check_fo.gd`'s Overkill note, `check_gs.gd`'s *PROPOSED at HL §1*,
  and three `battle.gd` comments (the `_book_self_cost` header and two more).

### FOUND AT IT AND NOT FIXED

- **TWO CONSTANTS HOLD THEIR CARD's FIGURE AND PAY ONE LESS** (on record at FOUND AT GL, owed a look; IT met them beside the nine
  IU re-valued): `BATTLE_TRANCE_TURNS` and `MANA_WELL_TURNS` hold their card's *4 turns*, applied bare, and their ticks run after
  `tick_statuses`, so each pays three.
- **SIX CONSTANTS ARE DECLARED AND READ NOWHERE**: `VENDETTA_CUT`, `SPITE_CAP`, `FIREDRAW_TAKE`, `PYRE_SHARE`,
  `THRESHOLD_LOCK_TURNS` and `ASHES_RETURN` (each named once in the comment-stripped game code; each one's `_PERFECT` twin is read
  where there is one). Two were on record before IT — `FIREDRAW_TAKE` at FOUND AT IE and Small, and still owed, `ASHES_RETURN` at
  THE BOSS-PICK POOLS — and the pilot's close-read found both (IT's report, §5). A dead name reads as a decider; each is deleted
  or read in the batch that touches its card.
- **FIGURES A TEXT STILL TYPES, OUTSIDE THE CATALOGUE AND THE PINS IT MOVED**: Battle Trance's cast log types *3%*
  (`BATTLE_TRANCE_FLOOR`); `formless_recoil`'s status row types *two turns* (`FORMLESS_RECOIL_TURNS`), beside `formless`'s *no recoil
  follows* (FOUND AT IQ); and Reality Fracture's Perfect *+1 Resonance* is `res_gain += 1`, a literal no constant names.
- **POWERSHOT's *EVERY POINT OF THE TARGET's BREAK BAR* IS EVERY PERCENT OF IT**: the strike multiplies `POWERSHOT_PCT_PER_POINT` by the
  meter's fraction full (pressure over stability, times 100), which is per point only because every stability is 100 today.
- **THE CHILLED STATUS ROW CANNOT READ ITS CONSTANT**: `STATUS_INFO`'s *4 stacks FREEZE* is `BattleUnit.CHILLED_FREEZE_STACKS`, and a
  `const` in `battle.gd` naming a `BattleUnit` constant does not parse under the battle/unit cycle (measured at IT: `STATUS_INFO` failed
  to parse, and `check_parse` read it). The row keeps its *4*; `check_it` §2 pins it to the constant.
- **THE CATALOGUE's WORDS THAT COUNT ITS STRUCTURE ARE HELD BY NOTHING**: 40 of its 94 word figures — *one mark at a time*, *a second
  enemy*, *the four* — count a card's own shape, which the code's structure decides and no figure does; `check_iq` §2f holds the 54 a
  constant or a field decides (the kept table, `docs/reports/IT-catalogue-figures.tsv`, marks the 40).
- **THIRTEEN OF THE TWENTY REPORTED PICKS STAND, HELD BY A CEILING** (IU §5): each is repaired by the batch that next touches
  its target — the census of record's `iu_disposition` column stamps each row with its file, and `check_iu` §5 reds a touched
  target whose row still stands.

### FOUND AT IS AND NOT FIXED

- **THE CRYOMANCER's TURN-START UPKEEP IS THE ONE SAME-TURN HOLD ROUTE** (IS §3b): Eternal Winter and Winter's Grasp would lay a
  hold at the top of his own turn, before he acts, and Shatter and Winter's Toll would pay that hold one turn for none. Nothing
  writes either field; `check_is` §3b reds the day one is written, and then the floor is the designer's.
- **ITEMS IR CLOSED AND LEFT STANDING HERE** (the pilot's needs census read them): FOUND AT HO's *Tithe pays at least 1* half (its
  full-health half stands); FOUND AT GL's *Renewal and Undying Vigil on a companion do nothing*; FOUND AT IA's *86 stand* (87 since
  IR's recount); THE SHAPE RECON's *building it is IQ's ruling 2* (repaired at IS). The one wholly closed — FOUND AT GB's *fixed
  modifier never reaches a mini-boss* — is archived at IS. **And the close-read (IS §5) found two more closed earlier and standing**:
  FOUND AT GN's *renaming Nexus Ward is one string* (a rename is a row of the rename map since IR §2), and FOUND AT GF's two
  `master.html` debug-paragraph claims (neither phrase is in the file since IQ §2; the second archived at JF).

### FOUND AT IR AND NOT FIXED

- **THREE LATENT FLOOR SHAPES NOTHING WRITES TODAY** (IR §1d's census; the fourth, Sacred Resolve's RECOIL split, is
  closed by IS §3a's rule — a recoil of nothing splits to nothing): Sacred Covenant's Faith floor is gated on the heal
  field, not the Faith; Slow Acting would lift Thin Blood's zero poison tick back to 1; and the temporal rift reads a blow's
  damage with no zero test. Each pays the floor of a zero the day its field gets a writer — different shapes from §3a's, and
  §3a does not reach them.

### FOUND AT IQ AND NOT FIXED

- **THE FORMLESS CHIP SAYS NO RECOIL FOLLOWS, AND ONE DOES** — `battle.gd`'s `formless` status text against the recoil its expiry
  applies: a player-facing sentence the census found beside `master.html`, not repaired here.
- **CODE COMMENTS REPEATING WHAT THE CENSUS FOUND FALSE** — an asserted surface (DF §1), each repaired with its subject: `talents.gd`'s
  head (*rung 1 is the only door*), `run_state.gd`'s *an event pays no gold* and *`pending_event` is not saved*, *35% → 52%* (Honed
  makes 53%), Mark of the Hunt named as an engine-gated boss card, `battle.gd`'s *59* recast-gated abilities (63 refuse), Blood
  Offering's *40* Rage (60), Berserk's *4 on a perfect* and *spends all three* (four charges, always), and *converts depth into width*
  in two places.
- **`check_hn` §2a's WORN ARM READS THE BAG's RUNE** (IQ's position census, read and not driven): `got_worn` keeps the last *Fourth
  Stack* on the Cleric's list, and since HR §1's hand-out the bag's copy lands there after the worn one, so the worn rune's rename is
  asserted by no arm — an instrument defect older than IQ.

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
  Magic Missiles are both unavailable. A Cryomancer's Rupture reads 3.2% of his turns in the sim's default-build runs on IF's code (**1.7% re-read at IW**, sixty runs on IV's repaired bot — THE SIM's FIGURES, RE-TAKEN AT IW) and
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
- **THE CENSUS's OWN, READ AND NOT DRIVEN**: Ember Leap's half-the-turns fires on Ember Debt's refund, which consumes nothing;
  and two stale comments (`battle.gd`'s *Frostbolt the mark* — slot 0 is Magic Bolt — and Firedraw's *UP TO 4*, which takes 6).
  (Its third finding, eight Cleric arms testing `ab.cost`, was closed at IN §3 — IU's divergence census, DV04.)

### BOIL OVER'S RATE — **1.5 DAMAGE A POINT OF RAGE, FLAT, SINCE JN §0 (the designer's), AND THE 40% FLOOR STANDS; 0.8% OF ATTACK STOOD FROM HZ TO JM; THE TENSION IS RECORDED HERE**

**Since JN §0 it deals 1.5 damage a point of Rage, flat** (`Classes.BOIL_OVER_DMG_PER_RAGE`, read through `rage_dump_damage`): never scaled by the caster's Attack, still met by armour, resistance, a crit and every multiplier a strike meets — on `check_hz` §2's board 118, and 150 there with the Berserker's core — 2.62 and 2.88 of the best ordinary turn, Rampage, where 0.8% of Attack dealt 63 and 88 — and a cast at its floor 47 and 55, past Crushing Blow's 30 and 31; 1.18 a point of Rage on that board, about the median Rage card's rate, where at 0.8 a full bar converted 0.63 a point, worse than every Rage card but the two that buy something besides damage (JN's ruling 5, accepted at JO §0; `CLAUDE.md`'s dump rule records its shape superseded for this card). **From HZ to JM it was 0.8% of the caster's Attack for every point of Rage poured out** — a share of the caster, never of the target — **and a floor of 40% of the bar**, the least it may be cast with (`Classes.BOIL_OVER_MIN_BAR`), which stands. **The Rage a Warrior holds** (JN's probe, Arm A's three trees): at a Warrior's turn's start 49.6 Rage on average on JM's tree and 42.0 on the tree that lands, 100 or more on 13.6% and 6.9% of his turns; the bot poured it 13 (Rage poured: min 40, median 65, max 100) on JM's tree, 4 (Rage poured: min 40, median 82.5, max 100) on HEAD with §1 alone and 2 (Rage poured: min 40, median 40.0, max 40) on the tree that lands, over sixty runs each — it drafts the card rarely. **Two lower rates failed the shape at HZ and the card has never been cast in a real fight**, so it
shipped at 0.8 from HZ to JM, and the change came from the designer's hands at JN §0, not from arithmetic — and so does a Perfect, which it does
not carry (IA §0.5: the grade's harder blow lands, and a Sloppy loses the cast and keeps the bar). **The first clean playthrough never drafted it** (IP §0.1),
so its rate is still unfelt and the question is its availability. **The figures it was chosen
against**, each HZ's:
- **Maximum Rage**: 100 for every Warrior lineage; 120 with the tier-1 node that raises the pool (the sim's full build carries it). At 1.5 a point a bar of 120 deals 180 before armour, and Arm B's tier 1 wears the node (FOUND AT JN).
- **Rage a turn, in real fights** (20 sim runs a lineage, the default rung): a Warrior gains **about 20 a turn** (median 15) in every
  zone and lineage, so a bar of 100 fills in **about five of his turns** — about a fight. Holding 100 or more, the bot's damaging
  actions dealt a median 35–54% of his Attack. **Re-read at IW on IV's repaired bot** (the default build at the default rung, twenty runs a lineage): about 21 a turn — the Berserker 23.1 (median 15), the Warden 19.8 (median 15), the Swordmaster 21.4 (median 15) — so a bar of 100 fills in about 4.7 of his turns; holding 100 or more, what he dealt between two of his turns ran a median 43% / 46% / 57% of his Attack (THE SIM's FIGURES, RE-TAKEN AT IW).
- **The census, on one deterministic board at Attack 100** (`check_hz` §2 prints it every battery, each card on its own board):
  the best ordinary turn is **Rampage, 45 for 40 Rage (52 with the Berserker's core)**; Execute 38, Cleave 35, Crushing Blow 30
  (31 with the core) — about 1.0 to 1.6 a point of Rage.
- **The dump on the same board, at 0.8**: **a full bar dealt 63 without the core and 88 with it** (the core's band is filled by the dump's
  own spend, so 88 is its figure at any health); **a cast at the floor dealt 25 and 29**, against Crushing Blow's 30 and 31.
  HW's good case for the old card was **84 for 40 Rage** with the core at half health; a full bar with the core is 88.
**The shape the designer set as the pass condition held both ways at 0.8**: a full bar beat the best ordinary turn and did not beat
two; a floor cast was worse than an ordinary card. **Since JN §0 it holds neither**: the dump rule is superseded for this card (`CLAUDE.md`).

**THE TENSION, RECORDED BECAUSE IT IS THE DESIGNER'S OWN AND IT IS REAL.** At 0.8 a full bar dealt 63, **0.63 of Attack a point
of Rage**, and the census's median Rage card converts **1.09 a point**. Only Shatterpoint (0.47) and Overpower (0.40) convert
worse, and **both buy something besides damage**. **A capstone that is the least efficient converter in the kit is backwards**,
and the pass condition is why it cannot be fixed by a rate: *not two of the best ordinary turn* compares one dump against two
Rampages and ignores that the bar cost about five turns to fill. **Both cannot hold.** *Recorded at HZ, of 0.8; JN §0's flat figure answers it toward the payoff and gives up the shape.*
- **THE MISSING FIGURE IS ENEMY HEALTH, AND IT IS NOT MEASURED HERE EITHER.** 63 against a zone-one body and 63 against a zone-three
  elite are two different cards: **the rate is read against what it kills when it is next ruled** — a fight, not a census.
- **THE LEVER, NOT AUTHORED: a rate that rises with the fraction poured.** One constant, not a mechanic — the floor cast stays bad,
  a full bar becomes a payoff, and the median stops being an indictment. It is what to try if play says a full bar is not worth
  its five turns.

### THE CREST POOL — **RULED AT JG §1: THREE PARTS INSURANCE AND ONE PART A RUNE, THE CAP AT ONE, A FLOOR OF 5%; COMMUNION, ITS FIFTH LIVE RUNE, RE-KEYED AT JH §1 ONTO WHAT EVERY HERO WEARS**

**Empty Pulpit, Dead Air and Dirge are COMEBACK runes, confirmed and kept**: every fight opens with all four standing, so each pays
only after a fall — Dirge less for any hero fallen and Dead Air more for the Mage alone, a frequency-against-magnitude pair, and
Empty Pulpit the defensive one and the best of the three (*your healer is down, you are harder to kill*). **They pay because HP
§1's live re-read reads the condition again at every death**: load-bearing for the pool, and recorded so in `CLAUDE.md`'s crest
block.
- **THE POOL, RULED (JG §1; the rulings stand in `CLAUDE.md`'s crest block).** Three parts insurance and one part a rune: three of the four key on a hero being down, which is rare in a run that finishes, and they keep their figures. The cap stays at one. Tithe's read site waits on the talent's own batch. **The floor**: a new crest rune's magnitude × uptime clears 5% on the population that finishes runs (the designer's bar, a reading no batch takes since JO §0 — `CLAUDE.md`'s crest block), past 75% the answer is a different condition, and the floor does not replace HP §5's relation.
- **COMMUNION, RE-KEYED (JH §1; the key the designer's, JH §0.1, and its figure the worth rule's).** Communion at 37%: *While every hero who stands wears 2 or more core runes, every hero deals 37% more strike damage.* It writes `dmg_bonus` in its payload, as Dirge and Dead Air do, its count and its figure each read off its own entry. **On the shipped key, read at its door with no crest worn (`docs/reports/JH-uptimes.tsv`), on the runs that finish: 18.6% on the reference four at Wanderer, 13.5% on the incumbent at Ruin, by zone 2.2, 9.2 and 38.2% on the first** — the door and jg_probe14's own count agree on every row, and JG's table read the same turns. 5 ÷ the lower is 36.92, a whole percent up 37. **It pays every party that builds for it and rises through a run** — 16.6, 15.9 and 6.7% by party on the incumbent's runs that finish, 6.1, 5.9 and 2.5% at 37, where JG's named core read 19.6, 99.7 and 14.7% — **and in about half the runs it pays nothing**: worn from the first fight, it paid on 15.0, 8.9 and 3.9% of the reference four's hero turns at the three rungs and 11.7% of the incumbent's at Ruin (16.0% and 11.9% on the runs that finish, 5.94% and 4.41% at 37, the incumbent's under the floor: the fights it pays in end sooner, JH's ruling 3, accepted at JJ §0), and it never paid a hero turn in 27 of 60 at Wanderer, 29 of 60 at Warden and 40 of 60 at Ruin on the reference four, and in 34 of the incumbent's 60 at Ruin, 11, 9 and 14 of 20 by party. **It waits on every hero who stands slotting a second core, and in about half the runs one never does — on the two rows the worth rule names nearly every such run finishes** (27 of 27 at Wanderer, 33 of 34 on the incumbent; at Warden and Ruin most die first, 1 of 29 and 0 of 40): a dead card in those runs, which the brief's first reason said it would not be (JH's ruling 6, accepted at JJ §0). *With Communion in the pool and not worn, the shipped key reads 15.8% and 14.8% on the two rows: the die shift moves an uptime too, so a worn rune is priced on its wearer's union (JH's ruling 3, accepted at JJ §0).* **Its one impurity**: it switches on when the one hero short of a second core falls, about 1.0 of its 18.6 points, where all four standing and each wearing two read 17.5: 5.6% of its uptime there, and up to a third at Warden and Ruin (3.32 of 9.97 points and 1.42 of 4.53 over every run), 0.24 of 13.54 on the incumbent (JH's ruling 7, accepted at JJ §0). *Every hero holds a core* holds on every hero turn of every run on every cell, which is why the card counts two. **The writers of its condition are the map's**: `Run.awaken`, `Run.toggle_engine` and the swaps, and in a sim `Run.hold_rune` when its bot asks; inside a fight only a fall and a rise move it.
- **ITS PRICE, AT THE FIGHT FIRST (JH §2, `docs/reports/JH-fight.tsv`, `JH-crest.tsv`; the arm wears it from the first fight, the none is HEAD with Communion's entry struck, the same seeds).** **THE READING THAT DECIDES IS THE FIGHT, and the run is read for the record** (JH's; no batch takes it since JO §0). **The first fight reads nothing by construction**: no hero wears two core runes there, so the arm plays it line for line as the none does on every cell. **The first fight it pays in**, the same history on both sides up to it: Wanderer, 33 of 60 of its runs have one, hero turns -6.03 ± 1.01 (-14.9%) and damage a hero turn +10.44 ± 1.34 (+22.9%); Warden, 31 of 60 of its runs have one, hero turns -3.77 ± 1.11 (-11.4%) and damage a hero turn +5.28 ± 1.09 (+14.4%); Ruin, 20 of 60 of its runs have one, hero turns +0.70 ± 0.82 (+2.5%) and damage a hero turn +3.04 ± 1.00 (+10.1%); the incumbent at Ruin, 26 of 60 of its runs have one, hero turns -5.04 ± 1.10 (-15.7%) and damage a hero turn +26.01 ± 4.32 (+29.1%). **The run, for the record**: none of twelve readings of falls, depth and finishes passes two errors against HEAD's struck none; against HEAD's plain none, which rolls one entry more, falls at Warden read -1.53 ± 0.49, past three errors, and that is the die shift. **The die shift by itself**, HEAD's none as it stands against the struck one, neither wearing a crest: the reference four rung 1 falls -0.45 ± 0.27, depth -0.07 ± 0.33; the reference four rung 2 falls +1.30 ± 0.48, depth +1.35 ± 1.01; the reference four rung 3 falls +0.35 ± 0.31, depth +0.38 ± 0.73; the incumbent rung 3 falls +0.12 ± 0.30, depth -0.05 ± 0.24. **Ambushed, re-read because what a worn Communion pays moved**: +6.62 ± 0.63 on the default four and +11.77 ± 1.30 on the incumbent, a tie with JG's and no grade moved.
- **THE FINDING IS THE POOL, NOT THE RUNES (IA §0.2)**: three of the four live crest runes were disaster insurance and the fourth, Tithe, is
  unconditional — a narrow design for the one slot the party shares. **The direction out**: `heroes_hold_core` has been live since
  HQ and is a condition that is not a death, so a crest rune keyed on what the party CARRIES is buildable today against HO §3's
  census. **The designer authored one at JG and re-keyed it at JH onto what every hero wears, above.**
- **WHETHER A FALLEN HERO STAYS DOWN BETWEEN FIGHTS IS RULED: A FALL STAYS INSIDE ITS FIGHT (JD §0.1, `CLAUDE.md`'s block of that name), AND THE TRACE IS THE BASE CLEARING HEAL (JE §0.1).** **Dirge's question closes with it**: HQ §1 read *Dirge farms nothing* inside a fight only, and since a hero cannot be held down across fights there is nothing to farm; JE's arm reads a fight with a hero down no longer under it (30.4 hero turns left to 29.2, first fall of a won fight, Warden). **The Cairn of the Fallen** stands at 12, the pool's top, and makes whole each hero a fight left down. **Cairnmoss Poultice** buys back the base and adds no figure of its own. **The relics on the hook** reach a hero who fell. **The map's Revive Potion** path is deleted; the potion works in a fight.
- **HOW LONG EACH PAYS (JE §4, `docs/reports/JE-turns.tsv`)**, hero turns from the fall to the fight's end, the median in a won fight, the default four at Wanderer, Warden and Ruin, then the incumbent at Ruin: **any hero's first fall, Dirge's stretch: 29, 30, 33, 17.5** (lost fights 13, 14, 14, 12); **the Mage, Dead Air's: 32, 31, 33, 27**; **the Cleric, Empty Pulpit's: 17, 17, 20, 16.** Of all hero turns that is **Dirge 1.4%, 12.1%, 17.7%, 0.8%; Dead Air 0.8%, 7.7%, 9.1%, 0.4%; Empty Pulpit 0.4%, 2.2%, 2.2%, 0.4%** on the default sim; *the same conditions read at their own door with no crest worn are in `docs/reports/JF-uptimes.tsv`.* **The Cleric takes 20–28% of the default four's falls and 35% of the incumbent's; the Mage 30–36% and 23%.** So the stretch is long, and what is rare is the condition: where runs finish in numbers, a rune keyed on a fall holds for about one turn in a hundred. **HP and HQ priced on shares of their own parties**: against a bare 10%, Dirge 0.72–0.86, Empty Pulpit 0.77–0.81, Dead Air 0.35–0.61.
- **WORTH WHAT IT REPLACES (HQ §1's method).** Its rate stands: while no Mage stands the three at 1.75 do about the work of four. **Only Dead Air's share reproduces HQ's** (7.7 and 9.1% against 7.8 to 14.4%); Dirge's reads about half HP's (12.1 and 17.7% of all fights, 10.8 and 14.4% of normal ones, against 19.5 to 25.5%), on another party, and Empty Pulpit's 2% sits under HP's 2.8 to 4.4%, so HP's and HQ's worth figures for those two are their parties' and were not re-read. **Over the turns they get, one arm a rune against a true none (`docs/reports/JF-crest.tsv`; JE's own *none* wore the first crest rune the bot drew)**: at Warden depth +1.62 ± 1.14, +2.42 ± 1.09 and +1.22 ± 1.04 for Dirge, Dead Air and Empty Pulpit, finishes 9 of 60 against 5 on each, at Ruin flat and none of 60. **Dead Air's depth (2.22 errors) and the bot's default arm's finishes (+0.067 ± 0.032, 2.05) are read past two at Warden and nothing else is, two readings of about two dozen, which is near what chance hands**, and the rule that prices them is the worth rule (`CLAUDE.md`'s crest block): nothing is re-cut (JF §0.3).
- **THE POOL, READ OUT (JF §4, ruled at JG §1).** `docs/reports/JF-pool.tsv` is every rune of the scope at JF, its figure and where its condition is read: **each has a reader**, and none is a Watchtower. `docs/reports/JF-draw.tsv` is how one arrives: the fight drop, 4 of a flat union of 55 to 60 at a run's spawn on the four parties driven, nothing in the roll asking whether the crest is filled; the Peddler; the event verb; never a hero's own pick. `docs/reports/JF-deps.tsv` is what names or waits on the pool, read off the records: **17 rows, 9 waiting on the ruling, 3 play questions it would reopen and 5 that bound it; RULED AND NOT BUILT holds none, and the roadmap states no count.** `docs/reports/JF-uptimes.tsv` reads every condition the pool held at JF by rung and population, **with no crest worn**.

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

- **HG's SUPERSESSION BLOCK CITES *HD §2's FOUR* AS RETIREMENTS THAT PRINT WHAT THEY USED TO READ** (HY's re-read, reported): only
  `check_du`'s and `test_batch_az`'s do — `test_batch_ar` prints the new reading, and `test_batch_ba` prints nothing. The block
  was moved byte for byte. The other three claims HY's re-read met were repaired at IU §1 (CR02, CR09, CR10).
- **TWO OF §1c's SIX RETALIATION SITES ARE FRAMED AND DORMANT**: Spite (`spite_ranks`) and the Whole Forest's bite
  (`whole_forest`) have had no writer since FX, so no fight reaches either; each now deals under its owner's frame and puts the
  swing's back, and `check_hy` §5 drives both with the field set by hand. A batch that writes either field again inherits the
  frame already in place.

### FOUND AT HZ AND NOT FIXED

- **THE `boil_over` STATUS HAS NO WRITER SINCE HZ §2** — `unit.frenzy_bonus()` still reads it, `STATUS_INFO` keeps its row and
  `check_hw` §1a prints it; kept, the `spite_ranks` and `whole_forest` shape.

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
   are right* meant the elite's cache keeps crest runes, the scope comes off that roll and the defect has no other door. *JG §3 kept the three routes for the fifth crest rune, as its brief ordered, and `check_jg` §3f drives the cache.*

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
### THE PLAYTEST'S OTHER FINDINGS — **LATER BATCHES BY RULING (HW's brief §5); THE ROADMAP HOLDS THE ORDER**

- **THE RE-MEASURE RAN AT IQ §3, ON BOTH FILES — PRICED, NOT BUILT (IC §5's schedule, kept)**: HV §3b's census over the twenty
  batches HW–IP, and HV §3f's shape priced on today's files — `CLAUDE.md` read at about 245 KiB of 472 a batch (48% less, where
  HV found 38%), this file at about 85 KiB of HEAD's 361 (77% less) — with what building it re-points (`docs/reports/IQ.md` §3).
  **Whether to build the block index, for which file, or HV's pilot first, is IQ's ruling 2: nothing waits on another
  measurement.**
  **THE ORDER:**
- **MANA STAYS (ruled)** — **superseded for the Cleric at JN §0, the designer's: a Cleric gains 50% less in a fight** (THE CLERIC's MANA RATE). The finding was that the Mage and the Hunter run dry and only the Cleric is always full; **measured at IE
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
  the Skirmisher and the Tracker are ruled and unbuilt, with Volley's and Ambusher's core slots and both names owed; Tithe's read site; **the strike
  payouts' widening, a measurement — and whether Profligate's price narrows with its payout, a magnitude (both IK §5)**; **no page key and no targeted debug card pick** — each available if
  the designer asks (HU; recorded nowhere in this file until HX).
- **THE PILOT ENDED AT IV, AND `CLAUDE.md` TAKES NO INDEX (IV §0.1, the designer's)**: three reports, one answer — a bounded read
  was a sufficient one — and the other file's question closed by IU §2's count (THE SHAPE RECON, below). The close-read is kept as
  the batch's own (the index section). **The ceiling stays on this file — 520 KiB since JS §0, 440 from JJ §1 — and its restatement on the read was never ruled.**
- **THE DECK IS CLOSED AT TWENTY-FIVE (JC §0.1), AND THE QUEUE IT DISPLACED COMES BACK**: Ambushed a 4, Outpaced and Porous 2s, Fractured a 1, the deck 1×7, 2×7, 3×4, 4×3, 5×4, every one graded. **The fallen hero is ruled and built at JD and sized at JE, and the crest pool is read out at JF and ruled at JG** (THE CREST POOL, above).
- **THE LOOK-LIST — WHAT A GATE CANNOT READ: WHETHER A SCREEN READS WELL (IS's brief §0.1, the designer's).** A gate reads a rect;
  it cannot read whether what is drawn reads right. **Every batch that moves something on screen adds a row here**, so the rows are
  cleared in one sitting rather than one message at a time. Nothing waits on a row. **THE DESIGNER PLAYED JI THROUGH JQ ON 9 NOVEMBER AGAINST A TWELVE-ITEM LIST AND EVERY ITEM PASSED** (JR's brief; JR's ruling 5, accepted at JS §0, reads the eight rows from JI to JQ as the surfaces it cleared): six went to the archive, the two `check_jj` §6 reads by name say so in place, and the rows before JI stand.
  · **A SECOND RUN, WITH A DIFFERENT PARTY** (IQ's ruling 1, carried through IR's and IS's): every figure in THE FIRST CLEAN
    PLAYTHROUGH (above) is one run and one party. *Play.*
  · **THE FIRST RUN's FRAMING CARD** (IR's ruling 6): placed by its own height at IR, its foot at y=690 — measured headless, never
    seen. *One look, no play*: a new profile, the first map.
  · **THE MAP's ARRIVAL TOAST WRAPS** (IS §2a): a toast longer than the screen takes a second line, where it ran off both ends. *One
    look*: load a run whose save names a removed card, or take a drop whose line runs long.
  · **THE FALL's WORDS ON THREE SCREENS** (JD §2, §4): the framing card's heal line is a character wider than the card's widest was, and names no owner for its percentage, which would widen it further; the victory card adds its sentence on a hero left down (the next row); the pouch's Revive Potion refuses on the map. Read in the code, never
    seen. *One look*: a new profile's first map, a won fight with a hero down, the pouch on the map.
  · **THE RELIC CARDS AND THE VICTORY CARD** (JE §1): three relics read *every hero* again, and the victory card reads *A hero left down recovers N%.* or *does not.* Read in the code, never seen. *One look*: a won fight with a hero down and a relic held, and one with none.
  · **COMMUNION ON THE CREST STRIP** (JG §3, re-keyed at JH §1): its chip ARMED and PAYING, the words *while every hero who stands wears 2 or more core runes* on one tooltip line FOUND AT JH names, the Peddler's row *for the crest* and the bag's; driven headless, never seen. *One look*: a fight wearing it with every hero on two cores, and one with a hero on one.
  · **THE WARBAND's MALICE STRIP** (JJ §2): MALICE, its bar and its count out of 150 above the warband's stack, between the combat log's foot and the stack's top; its hover the rule and the warband's healers by name; driven headless, seen and passed in the designer's play of 9 November. *One look*: a fight against an Orc Totemist, the pool filling and spent.
  · **COMMUNION's COUNT ON THE CREST STRIP** (JJ §5): *n of m* beside the chip, the heroes who stand wearing two core runes; driven headless, seen and passed in the designer's play of 9 November. *One look*: a fight wearing it with two heroes on two cores, and one where one of them falls.
  · **THE TURN BAR UNDER AMBUSHED AND OUTPACED** (JB §2): eight warband turns and then the heroes, and the warband first in each span, drawn off the order the loop keeps and driven headless, never
    seen. *One look*: a fight under each.
  · **THE FROZEN PLAINS** (JS §1–§3): **its map, its events and its battles wear the Forest's backdrop**, a placeholder named in each
    dict, so the zone reads as the Forest under another name until art lands; its six kinds are tinted orcs, under the themes' old names
    (a Hailcaster in a *Poison Volley*); the Glacier Press and the Trampling Charge declare a *crush* on the plate; the Hailcaster's
    Hailstorm lays Dazed on every ally; the Titan's Entomb, declared a plain strike, freezes a hero, whose plate reads Frozen — its chip
    names the Cryomancer's hold — and whose turn passes by; the Hailcaster and the Warden are both frost white, so whether the six read
    apart is a look, and so is whether the Rimehorn, at speed 68, ever buys its Rally (JL found the slow bodies bought none). Driven headless, never seen. *One look*: a new run whose first or third zone is the Frozen Plains
    (each draws it half the time), a fight there, an event there (the Forest's two no longer deal; the Withered Shrine's *warden of the
    woods* and Ashfall still deal everywhere, as before JS) and its boss.
### FOUND AT HV AND NOT FIXED

- **OPEN LINE OWES AN `ENGINE_READ` ROW (the Stances).** It requires Guard Change, which only the Stances bring since HL §1, and
  HC §2's clause makes such a rune a row; `check_gv` still sorts it HALF. Worn with the Stances unslotted it pays nothing and says
  nothing, and a queued cache can hand it over without Guard Change. HL had the rune-scope block open and missed the clause.
- **`Run.rune_choice` NEVER ASKS `Runes.is_refused`** (FD §1's re-ask at a queued offer's answer; HR withheld a refused rune at
  the roll only). Reachable only by a saved queued offer of a now-refused rune.
- **A COPIED ELEMENTAL WEAKNESS SKIPS ITS DOOR'S LAST STEP**: `_apply_elem_weak` rewrites the chip to the value, the copy wears
  the table's *EW* and pays the same — display only, the hold's shape a fourth time, one line to route.
- **TWO STALE LINES IN `CLAUDE.md`, OUTSIDE IU's CENSUS**: the drop block's *HO's rule that one choice is never two things*
  (HL §1's, by HV's reading), and the no-engine block's kit list, which omits Pommel Strike's Stun. The rest of HV's — the
  rune-scope block's entries, the governor table's Ruin and the combat file's six — were repaired at IU §1.
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
  `max()`~~ — **BOTH CORRECTED AT HS §1**; the combat file's *BURN MAGNITUDE* was repaired at IU §1 (CR12); and six code
  comments are stale (§4h names them). None is player-facing; each is a sweep for the batch that
  touches it.
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
- **TWO STALE THINGS THE CENSUS MET, NEITHER THE CREST'S**: `check_ct_map.gd`'s *supplies end above the draft
  header* arm (`_process`: `ok(lowest <= draft_top,`) has been vacuous since FD §1 took the draft off the Peddler, and the comment above `check_gp.gd`'s `func _unslot_engines()` says `hold_rune`
  slots an engine while a slot is free, false since HL §1.
### FOUND AT HN AND NOT FIXED

- **THE CENSUS'S MISSING SHAPES, PRICED FOR THE DESIGN PASS** (`docs/reports/HN.md` §3b, §3c, §3e): one key twice, an OR,
  and *any class twice* — each a few lines in `Talents.party_condition_met` and a drive. None is built.
### THE SHAPE RECON ON `CLAUDE.md` — **QUEUED AT HN §1, RUN AT HV §3, RULED AT HX §0, AND CLOSED AT IV §0.1: `CLAUDE.md` TAKES NO INDEX**

The question it asked: **whether an index plus subjects read on demand beats one file with a moving ceiling.** It is not GY's
reasoning split, which stays rejected. The figures, the two natural experiments and the recommendation are in
`docs/reports/HV.md` §3. **Ruled at HX §0 (the designer's)**: the checks first — built, `check_hx` §1 — then this file's
trim — taken, HX §2 — then a re-measure, one section of the next batch: §3b's census over the batches since HV, the read this
trim left, and the checks' record. **HV's nine-unit pilot and the block index both waited on it, and it ran at IQ §3**, over the twenty batches HW–IP and on both
files: the block index beats one file with a moving ceiling on the read — `CLAUDE.md` 48% less a batch, where HV found 38%, and
this file 77% less. **The index pilot ran on this file from IS to IU (the index, above)**, and the decision for `CLAUDE.md` was
taken at IV by derivation.
- **CLOSED AT IV §0.1 (the designer's): `CLAUDE.md` IS NOT INDEXED, AND NOTHING IS STRUCK FROM IT** (a rule of what a census may do; JE §3 moved six closed blocks out at the designer's order). IU §2 read every standing rule
  in it against the gate that holds it — **817 rules, HELD 299, PARTLY 229, NONE 284** (five not rules) — and
  **112 of its 120 blocks hold at least one rule no gate fully holds**. The census's own rule makes those numbers an
  answer: *a rule with a gate is a reference and can be routed around; a rule with none must be read, so its block is
  core* — and **AN INDEX WHOSE CORE IS 112 OF 120 BLOCKS ROUTES AROUND NOTHING.** Queued at HN, priced at HV and IQ, piloted at IS, closed by a count rather than by a preference.
  **This file keeps its index** and gains the population rows three batches of the pilot showed it lacked (the index, above). The
  live headroom is in the WHERE block.

### TO WATCH IN PLAY — **RULED AT HN §2; EACH IS ONE CONSTANT OR ONE LINE IF IT READS WRONG**

- **WARDEN's GAMBLE POOL (JC §0.10, the designer's: accepted as the deck's closing cost).** Its gamble band, 4–4, holds three modifiers for a whole rung (Rot, Overgrown, Ambushed), which is thin, and the measured alternatives are worse (IZ §0.4). **Whether it feels repetitive is a question for play, not for the sim.**
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
  `data/runes.json`. Fellowship is retired (HP §3). **THEIR UPTIMES, WITH NO CREST WORN, ON RUNS THAT FINISH (JF §0.3, `docs/reports/JF-uptimes.tsv`): at Wanderer Dirge 1.7%, Dead Air 0.8%, Empty Pulpit 0.3%; on the incumbent at Ruin Dirge 0.8%, Dead Air 0.4%, Empty Pulpit 0.3%. For those three this row is the block's one exception: no constant fixes an uptime, so what reads wrong here is the pool's, not a figure's.**
- **COMMUNION AT 37% (JH §1).** Whether a party that builds for it feels it, and whether it reads as a payoff that grows: one row of data, its figure and its count in the payload. The sim reads the rise, because its bot slots every core it draws and never unslots one; it cannot read the choice the rune asks for.
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

- **THREE CARD TEXTS USE *ENGINE* AS A WORD FOR A RULE** (`classes.gd`'s Chastise, *the engine is not ready*; Downwind, *His engine*; Shrapnel Charge, *the engine of the hunt* — IJ tokenised two of the three and kept the word) — card text, left as
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
| `check_jg` §3d, a real fight through its named core's holder's fall and rise | `check_jh` §1f, through the short hero's fall and rise, since Communion's re-key | C02 |
| `test_batch_cd` §2, the per-shelf floor (half) | `Fixture.class_pool_floors`, asserted in eleven other suites **and in `cd` itself since HI folded its class-wide floor** (the other half is `cd`'s own depth table) | c6 |
| `check_jl` §2, the Orc Hexer carrying two hexes and its selection laying two — the Gall half of each, narrowed to one at JM §0 | `check_jm` §0: Gall's carrier off the kept drive table, its reach of every ally an area blow strikes since JO §2, and its carrier's selection | C01 |
| `check_jj` §5, the Bellow's 2 as the cooldown rule's hand-tune (`check_ji`'s `TUNED`) — retired at JN §1 with its reason | `check_jj` §5 re-pointed: the Bellow's band the rule's — 3 since JO §2 put Fester on it, read off `docs/reports/JO-hexes.tsv` — and no hand-tune standing; `check_jn` §1 the raise | C05 |
| `check_hz` §2, Boil Over's shape — a full bar under two of the best ordinary turn, a floor cast under an ordinary card — superseded for Boil Over at JN §0 by the designer | `check_hz` §2 prints the shape; `CLAUDE.md`'s dump rule records the supersession; `check_jn` §0 Boil Over's flat figure | C09 |
| the five warband digests (`check_jq` §5, `check_jp` §3, `check_ji` §4, `check_jn` §1, `check_jo` §1), narrowed at JR: each puts back the three appearance tags in its `MOVED_SINCE` before it digests | `check_jr` §1: the three tags (`AS_JR`), the rates they give (derived), and the rest of the data with the tags put back at JQ's digest | C01, C15c |
| `check_jl` §2, the hex moves — their carriers by the special, JL's what-it-denies prices, the Hexer's selection laying a hex only at a hero who lacks it — retired at JO §2 with the special | `check_jl` §2 re-pointed: a hex's carrier the kind whose move lays it, each priced on JI's one line by its blow, the selection taking the blow as an attack; `check_jo` §2 the rule and each blow driven | C05–C10 |
| `check_jm` §0, §4 and §5, Gall a hex on every hero and never on a companion, priced by what it denies; the kept kit JN's | `check_jm` §0, §4, §5 re-pointed: Gall a blow on every ally, priced and cooled on the line, the kit JO's; `check_jo` §2 | C07, C08 |
| `check_jp` §3, nothing authored — its content digests over the tree as it stands | `check_jp` §3 re-pointed at JQ: the digests over what JP landed, JQ's two cards and its status named as a later batch's (`AUTHORED_SINCE`); `check_jq` §1–§3 the three answers built | C20, C20h |
| `check_jn` §1's walk of the live data, and §0's Thin Air tripwire on the tree that lands | `check_jn` §1 on JN's kept kit against JM's, its raise off its own table; §0 the record naming JN's tree; `check_jo` §1 the data from JN's kit on | C03, C04 |
| the warband's digests and counts (`check_ji` §4, `check_jn` §1, `check_jo` §1, `check_jp` §1 and §3, `check_jq` §5, `check_jr` §1, `check_jj` §7, `check_jk` §1 and §4, `check_jl` §2 and §4, `check_jm` §0 and §4), narrowed at JS: each reads the warband its batch left, JS's seven kinds and two rosters named (`ADDED_SINCE`, `ROSTERS_SINCE`) and read apart | `check_js` §1, §2, §3 and §5: the seven kinds, their rosters and figures, the line's reference board, and the rest of the data at JQ's digest with JS's additions out | C14, R_jih–R_jrh |
| `check_iv` §2's latent arm, a pool of two holding a zone no player can draw — retired at JS §1 with the door it waited for | `check_iv` §2 re-pointed: the door, driven — a player's run meets every zone of every pool; `check_js` §1 the draw, a player's and a sim's | C01d, R_ivh |

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

### FOUND AT HA AND NOT FIXED

- **AT LEAST TWENTY-THREE TARGETS SEAT A LINEAGE BY HAND WITH NO ENGINE RUNE**, against GK's *"a hand-built seat must
  too"*. Harmless in most; not in `check_et` (every `Runes.ENGINE_READ` rune withheld from its retirement walks —
  `check_fd`'s identical helper was repaired at GV and this one never was), `test_runes`' exhaustion and start-pool
  members, `check_fm`'s `_member`, and `test_batch_bo` §2/§3, where it is what makes three arms vacuous. The list is in
  the report's §1g.
- **`Run.ability_slots_used` IS LINEAGE-KEYED, AND SINCE HB IT READS ONE ENGINE QUESTION** — whether one held dismisses
  the pet (`Classes.kit_slots(class, spec, engines)`) — so one gate arm is still a near-tautology against its
  lineage half (`check_gm`'s `_s2_bound_cards`: `ok(run.ability_slots_used(m_held) == run.ability_slots_used(m_drop) - freed`); `check_gn`'s, the other at HA, asks the door against `Classes.opening_kit` since HJ's re-point. Correct while `lineage_slots` is zero for every lineage.
- **THREE GATES CHECK TWELVE ENGINES' TEXT WHERE THERE ARE TWENTY-FOUR** (`check_cl_resolver`, `check_cl_width`,
  `check_do` §4), reaching it through `SPEC_INFO[s]["passive_desc"]`; the spines' and the rule engines' texts are never
  checked. None carries CL's value token; since IJ §2 their figures are `{=…}` tokens `Classes.engine_desc` resolves
  (`check_cl_width` reads them resolved, and so does `check_cl_resolver` since IT §2 — corrected at IY's close-read; `check_do` §4 the raw text).
- **SMALL AND DEAD:** `check_di`'s `_hero(scene, "pack_bond")` can never match (the id is `pack`); `test_batch_cp`'s
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
   its own batch by FZ's pricing rule. Re-pointed to `Batch GZ</b> at FS/FT` here, and to `Batch IZ</b> at HR/HS` at IZ's cut, and not repaired.

### GY's RULINGS OWED — **THREE; NONE IS PLAYER-VISIBLE, AND THE FIRST SHAPES THE NEXT BATCH**

Full working: `docs/reports/GY.md`, NEEDS A RULING.

2. **SEVENTY-THREE DESIGN-NOTES ENTRIES ARE OUT OF THE STATED ORDER, AND THE FILE IS TWO BLOCKS.** §2b above. The
   top 111 entries are newest-first but for one inversion; the bottom 75 are a second, oldest-first chronological
   log. **Moving 73 entries is a file rewrite and nothing asserts on position**, so it is free whenever it is ruled
   and it will not decay further now the instruction is repaired. **The two entries GY moved kept the heading form
   they were written in** (`## Batch GW — <title>`, no date) rather than the top block's `## <Title> (Batch XX) —
   <date>`; only position was ruled, so only position moved.
3. **FOUR ARMS FIND THEIR SUBJECT BY THE PROPERTY THEY TEST, AND TWO OF THE FOUR PASS VACUOUSLY.** §3b above and
   `docs/reports/GY.md` §3c. `check_gx`'s two `_label_with(ov, "%s — %s" % [..., GT_HEAD])` locates (`_s3_the_three_surfaces`, `_s4b_the_panels_worst_case`) fail by absence where they should fail by
   measurement — a red naming the wrong cause, with the assertions behind the locate skipped. **`test_batch_as`'s `_live_boss`
   (`if slot.get_child(0).tooltip_text.begins_with(boss.unit_name):`) and `check_ct_map`'s `_process` (`if n is Label and String(n.text).begins_with("THE DRAFT"):`) do not fail at all**: both filter by a rendered value and assert the result is empty or
   unreached, so a reformat makes the filter match nothing and the arm passes. **Repairing them is its own batch** —
   two need a re-point onto a stable key and two need a liveness arm, which is a different repair again, and each
   owes a two-armed control on a live drive. FZ's pricing rule is why it was not taken here. **The cure for the
   third stands below it in its own file**: `_live_turn_bar` runs the identical filter and asserts a
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
   `check_gw` §2 holds the count at a ceiling — 90 at GW, `SHAPE_CEILING` 96 since (the gate prints the live count; corrected at IY's close-read) — so it cannot grow in silence. **Whether that batch is worth taking
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
  *(Nexus Ward's and Ministration's 20% read their constants since IT §2 — archived at IT.)* A kit
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
   five for the Mage, three for the Cleric *(the Warrior's seven and the Cleric's four since JQ)*. Accepted, not repaired, and the same item as GN's ruling 7 from the kit's
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
  dropped Heavy Plating covers with 10% — *since JP's readout, read at source: Shieldwall and a Split Shield's Bulwark Line widen the slice with no engine, so such a caster lends their share.* **It is NOT in the engine table**, because it reads a STAT and not an engine;
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
6. **THE CLERIC'S CLASS POOL IS THREE** — Chastise, Exhortation and Undying Vigil are the whole draft (Forsake the fourth since JQ) of a Cleric who
   took Sanctity, and an Occultist can no longer stack five cards on any tag but DEBUFF (`check_fn` §4 reads two).
7. **A KIT OF CLASS-WIDE CARDS HANDS THE BASELINE ROLE TO CARDS AUTHORED WEAKER** (GL's item 3): the Mage's two and
   all three of the Cleric's were authored as draft fallbacks.

### FOUND AT GN AND NOT FIXED

- **PLAYER-FACING: THE VICTORY CARD LEAVES OUT THE TOLLKEEPER'S BELL.** Both victory cards print
  `Run.award_gold`'s figure, and the Bell's +20 is paid beside it (`battle.gd`, the `victory_gold` hook), so the card
  says 20 less than the purse gained. **`check_gj` §4 is red because of it**: GN's code moved what the gate's seeded
  run draws, and that run now holds the Bell (card +178, purse +198 at GN — the figures move with what the deck deals that run, and
  each batch's reading is the note on `check_gj`'s row in `baselines.json`). **HEAD's code with the Bell forced reds
  the same arm** (card +157, purse +177, at GN). One expression in `battle.gd`; not in the brief. The red is sanctioned in
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
4. **THE SPLIT SHIELD's HALF IS CALLED "BULWARK LINE".** The half is EZ's `bulwark_line` status, whose chip and block
   log read *Bulwark Line*, a node deleted at FX; the chip's own line reads *"Split Shield: …"*. *(The item's first half,
   the rune's word, is answered at IS §4 — it says* hero *— and archived.)*
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
  (`battle.gd` `_resolve`'s block opening `if attacker.is_hero and attacker.has_engine("trapper") \`); Pinning Shot's Daze and Called Shot's rider inside Lethal Aim's (its block opening `if ab.display_name == "Pinning Shot" and not target.dead:`).
- **DIVINE SHIELD'S RECAST PROPOSAL IGNORES THE BARE ALTAR RUNE**, which halves the cast (`battle.gd` `_resolve_special`: `if attacker.rune_bare_altar > 0:` then `ds_pct *= 0.5`); the
  table proposes the full 35% (`_recast_writes`: `base = int(round(u.max_hp * (0.35 + 0.01 * u.stalwart_step)))`), so a wasted recast reads as an improvement. CR §3's rule, one live rune along.
- **PLAYER-FACING: QUICK SHOT ADVERTISES A PERFECT ONLY A LETHAL AIM HOLDER CAN REACH** — slot 0 resolves at a fixed Good
  (`battle.gd`), so a Beastmaster's or a Mystic's Quick Shot never pays its *+10 bonus Mana*; the Sharpshooter's bar is real, and
  the card is one object the three share. **IJ §2 cleared the other three class basics' Perfect lines** (Strike, Magic Bolt,
  Smite), which no hero could reach. `test_batch_bo` §5 passes them, because it asks `runs_skill_check()` and the cast path asks
  slot 0.
- **PLAYER-FACING: CARD TEXTS THE CODE CONTRADICTS**, each in its class section of the recon: Cleave's Perfect has no code; Battle Trance and Mana Well pay three turns in four (their ticks run after
  `tick_statuses`); Chastise's Perfect says 30 Break damage and pays 25; Frostbolt's, Razor Ice's and Blizzard's
  "hold" is the engine's; Divine Shield names "the Devout's" health and Dark Pact "the Occultist"; Hymn of Hope, Dark
  Pact and Resurrection say *ally* and reach heroes only; Renewal and Undying Vigil on a companion do nothing; Kill
  Command's "both companions" names a mode nothing writes (`the_pack`); Arcane Explosion's "Builds 1 Resonance". **IJ §2
  repaired Cleave's and Chastise's Perfects, Frostbolt's hold, Dark Pact's *the Occultist* and the *ally* of Hymn of Hope, Dark Pact,
  Resurrection, Renewal and Undying Vigil. IJ's census read the rest as agreeing** — each an engine's own rule (HO §0), or, for
  Kill Command, *The Pack* talent's name — a reading that differs from GL's, owed a look.
- **A PARTY DAMAGE BUFF PAYS ON ORDINARY STRIKES ONLY.** Warcry, Exhortation, Blessing of Zeal and Hunter's Mark are
  read in the strike path (`battle.gd` `_resolve`: `if attacker.has_status("warcry"):`, `if attacker.status_power("exhorted") > 0 and ab.damage > 0 \`, `if attacker.has_status("zeal"):`, `raw *= _party_mark_mult(strike_target)`); a card resolving in its own `special` handler
  reads none of them. True of all four; recorded once.
- **ONE SYNC LINE, AS AT FW:** `CLAUDE.md`'s must-stay-selected list does not name `docs/kit-recon.html` (nor
  `systems-recon.html`). GL added no `CLAUDE.md` line (the brief forbade rules); **selecting it in the picker is the
  designer's**.

### GK's RULINGS OWED — **SIX LEFT; THE NAMES CONFIRMED AT IW §0.1; THE WORDS AND THE THIN KIT ARE PLAYER-VISIBLE**

Full working: `docs/reports/GK.md`, NEEDS A RULING.

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
### FOUND AT GF AND NOT FIXED

- **A PEDDLER OR A FORGE QUIT IN THE MIDDLE OF A VISIT IS STILL WALKED PAST.** Both roll their stock in their own
  `_ready`, so re-entering one on resume would make a quit a reroll of the shop, and freezing the stock is a change to
  two screens, which GF's brief ruled out. Driven at GF: the node is visited and saved at the step, and Continue opens
  the map past it.
- **A MINI-BOSS CAN AWARD AN UPGRADE THE FORGE ALREADY PUT ON THE SAME ABILITY.** `roll_upgrade_offer` drops an
  upgrade only through `has_upgrade`, which ignores a bought entry on purpose (the forge is not the mini-boss's pool),
  and then pairs it with any ability it fits, the forged one included; `upgrade_choice` re-asks the same question. The
  forge's own roll refuses a pairing the hero already carries, so the rule its comment states (*never twice on one
  ability*) holds from one side only, and six of the eight upgrades stack when stamped twice (FE §2: Honed 25 → 38
  → 57). Read in the code at GF, not driven.
- **COPIES OF TWO CLAIMS THE GLOSSARY CORRECTED ARE LEFT IN A RULE AND IN COMMENTS.** `CLAUDE.md`'s governor table
  still calls Resonance uncapped with two removers (its Ruin half repaired at IU §1, S3-C08); `battle.gd`'s comment above the Arcanist's
  `second_max = 99` says Resonance has no ceiling at all, and the header of Runaway Resonance's first clause says
  nothing removes it. *(Arcane Arrows' constant is the six the card pays, and read, since IT §2, and its comment names
  it — archived at IT.)* None
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

- **A CLAIM IN `docs/instrument-rules.md` IS A DATED READING GA DID NOT RE-DERIVE**: EU's *"ALL FIVE ARE CORRECT TODAY"*. DX §1's
  *"THIRTY-FIVE ASSERT A FLOOR NOW"*, the other, was repaired at IU §1 (IR10).
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
    prints three deleted nodes as live cooldown sites; and `test_batch_cp`'s comment counts six and five where its table names eight.
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
  - the `DOD_SIM_TALENTS` example in `battle.gd`'s `_spawn_units`;
  - `Run._migrate_trees`' "are refunded";
  - "Richocet" in `battle.gd`'s `_resolve` (`→ Talent: Richocet — the block staggers`) and `unit.gd`'s `var ricochet_ranks`.
- **Suite checks that cannot fail, all older than FX:**
  - `test_batch_bw`'s kit sweep runs 0 checks;
  - two of `test_batch_bs`'s Forge Body checks;
  - `test_batch_al`'s Toughness check;
  - `test_batch_av`'s no-Mercy raise;
  - `test_batch_aw`/`ax`'s exclusive-reference loop, which is empty.
### FOUND AT FW AND NOT FIXED — **A REPORT TOUCHES NO CODE (THE SIM's POTION CLOSED AT IP §2)**

- **`relics.gd`'s header says every hook is read at exactly one site** — `gold_find_mult`, `fallen_recover` and `victory_heal_pct` are read at two and `shop_discount` at five, one of them the sim's. **`docs/master.html`'s copy of the
  claim was corrected at GE §2**, where six hooks read at more than one site were counted; this header still owes its own.
- **`CLAUDE.md`'s "four death-refusals"** are four call lines holding six refusals, with four more lethal refusals
  above the subtraction that ticks never reach.
- **Stale comments:** three still call the skill-check profile five fields or `_run_skill_check` three call sites
  (`battle.gd`'s CN §1 header, *every one of the five fields is read from it*; `var sc_profile`'s, *the same / five numbers*; `var sc_sequence`'s, *the function has three / call sites*); FT's own say all 23 `next_time` writes divide by `effective_speed()` —
  14 do.
- **Never-applied content:** the `ward`, `focus`, `rampage`, `seeding` and `melted` statuses; Weight of Ruin's
  "half speed" has no read site; White Heat and Fuse have no writer; the "Focus" resource drip cannot run.
- **A tick that kills skips `_on_enemy_death`** (`battle.gd` `_dot_pass`: `if dot_died:` then `_log("† %s dies" % u.unit_name, "#e05050")`), so nothing that pays on a kill sees a
  Burn or Poison kill.
### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED — **A PROJECT ON ITS OWN BRANCH SINCE FQ; STEPS 1–5 BUILT (3's NINE ENGINES AT GO, 4's POOL MERGE AT GP, 5 AT GP AND GV), AND THE RUNE SCOPES MERGED AT HC; STEP 6 CENSUSED AT HA, ITS FIRST HALF TAKEN AT HD, ITS RETIREMENTS AT HH AND ITS RE-POINTS AT HI AND HJ — **EVERY STEP OF THE RUNNING ORDER IS DONE** (its record archived at JH §3)**

**Full evidence: `docs/merge-recon.html`, written to be read section by section across many
batches. `docs/reports/FP.md` is the batch's own working.** FP authored nothing and proposed
nothing: it measured what dissolving the twelve specs into their four classes would cost, and the
ruling was the designer's, taken at FQ. **Nothing below is a recommendation about whether to do it.** These are
the things a later batch must not re-derive from scratch:

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
Hierophant, names confirmed at IW §0.1 — and `BattleUnit._sync_engine_switches` is the three switches' one writer, so a hero
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


### TWO SMALL DOC REPAIRS FR FOUND AND DID NOT TAKE — **ONE CLOSED AT JD**

- **`scripts/events.gd`'s header comment (*EVENTS ARE RESOURCE CONVERSIONS NOW*) carries the same false worked example the document did** —
  *"Health for a rune, gold for maximum health, health for talent points"* — and `talent_points`
  has never been an event verb. **It is code, FR's brief forbade touching code, and
  `docs/instrument-rules.md` records that a `.gd` comment is an asserted surface.** Two-line fix.

### TWO SYNC DESELECTIONS ARE DISPUTED BETWEEN THE REPO AND A BRIEF — **OWED A ONE-LINE RULING (FS §3)**

**The picker's selection state is not in the repo and no instrument can read it**, so this is the
one class of question where the tree cannot settle a disagreement. The first is recorded on
`CLAUDE.md`'s own deselection lines rather than only here, because a rule contradicted by a ruling
that lives in a report is a rule a future batch follows.

- **`docs/reports/` — growing every batch.** `CLAUDE.md` listed it as MUST STAY SELECTED
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

### **AND FP's `block_chance` FINDING TRAVELS WITH IT — RE-VERIFIED AT FQ, AND THE CODE SAYS IT OUT LOUD**

**`block_chance` has NO universal baseline.** It defaults to **0.0** (`unit.gd`'s `var block_chance := 0.0`) with no
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
    boss's.** *(74 since JK's spends, 78 since JL's hexes, which carry none, 76 since JO §2 folded two of them onto blows, and 98 since JS §2's seven kinds, which carry none.)*
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
- **THE CENSUS BLIND SPOT DT FOUND IS CLOSED AT DU §4 AND THE CORPUS IS 227** (228 since GN's Magic Burst, 233 since JQ's two cards; GS §1
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
  judgement; **not one magnitude was measured in play, before or after** *(of the lane runes: HP and HQ measured the crest's four, and the worth rule prices a crest rune, JF §0.3)*. Runes were not compared
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



- **TWO ASSERTIONS PASS VACUOUSLY IN `as` AND `at`, AND THEY ARE NAMED AT THEIR SITES.**
  Each reads text that no longer holds the list it asks about, left over from the exclusive-pair
  list DG deleted the red half of. *(`aw`'s, the third, is repaired to its intent at IT §3b.)* **A check that passes for no reason is worse than a red**, so
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
- **WE DO NOT BREAK AND HEAL MORE WHEN LOW ARE RECEIVABLE AND ARE NOT RECEIVED**, because both are
  stamped once in the party-spawn block before any companion exists. **Measured: a beast wearing
  `devotion` at 20 banks 32 Break from a 40-BD blow.** Reaching a beast summoned later wants a
  **re-stamp on summon** — a second write site for one node's worth of effect.
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
- **WHAT A CEILING SHOULD BE FOR EACH HALF — `CLAUDE.md`'s HALF RULED AT FU §1 (340 KiB, 510 SINCE HY §2); THE
  REFERENCE HALF STILL RULED ON NOWHERE.** EE's 290 KiB was derived for one file and its FLOOR term
  held both halves. **FU re-derived `CLAUDE.md`'s own ceiling by EE's method off FF's post-split
  reading (261.03 + ten × EZ's 8.10 = 342.03, stated as 340)**, which is the per-half move for that
  file. `docs/instrument-rules.md` has no stated ceiling and deriving one is still the designer's.




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

- **Enemy interference as a status.** Not yet specified. On the record it is interference with the skill check (SR-INTERFERE, `docs/systems-recon.html` §2; THE TALENT LAYER's edge 8), which none of JL's hexes touches.
- **RELICS PER-HERO — RULED, SCOPED, AND NOT STARTED.** The ruling stands (a relic is assigned to
  one hero at pickup); CX reported the scope and stopped. **VERIFIED AT EN: NOT ONE LINE OF IT
  LANDED**, and neither `master.html` nor the code was wrong about the other — they agree, and what
  was missing is that the ruling points elsewhere and is unbuilt, which `master.html` now says.
  **It is a SAVE-FORMAT change: the run save would go v12 → v13** (this block recorded v10 → v11,
  written when the save was v10; CT took it to v11 and EG to v12).** `Run.active_relics` is a flat `Array` read back as a hard key
  (`data["active_relics"]`, no default), so every existing save breaks without a migration. It
  also touches **28 read sites** (`battle.gd` 12, `run_state.gd` 11, `run_sim.gd` 4,
  `shop_screen.gd` 1), the two aggregators (`Relics.hook_add` / `hook_dict`), the two accessors
  (`Run.relic_add` / `relic_dict`) — **all four change signature** — both acquisition sites, and
  **13 of the 25 relic descriptions**, which are worded party-wide. **It can be split; it should
  not be started casually.**
  - **FOUR HOOKS NEED A RULING BEFORE ANY OF IT.** Party-wide by nature and staying that way:
    `start_items`, `start_gold`, `gold_find_mult`, `shop_discount`, `loot_extra`, `victory_gold`.
    Per-hero already: the battle-spawn hooks. **Genuinely ambiguous:**
    `victory_heal_pct` (Chalice of Dawn, Cracked Hourglass, Martyr's Knucklebone),
    `victory_mana_pct` (Cracked Hourglass), `fallen_recover` (Cairnmoss Poultice), and
    `resource_floor_pct` (Bottled Storm).
  - **The draft assigns relics BEFORE specs are chosen**, which is the point at which "which hero
    gambles" has the least information behind it. Worth deciding whether assignment moves.
- **Rune content.** The rune economy is measured and the system is built; the content pass has
  not been authored. **AND THE CHARTER DECISION COMES FIRST — see the RUNE CHARTER block above.**
- **The enemy debuffs whose duration exceeds their own cooldown.** Reported by the fold census. *Read at JI: of the five moves that carry a debuff and a cooldown none lays one longer than its cooldown, and ten lay one and carry none (FOUND AT JI, archived at JN). Since JN §1 six of the ten carry a cooldown, and the Orc Archer's Poison Arrow lays 3 and cools 2 (FOUND AT JN). Since JL the Orc Hexer's Sap lays 3 turns and cools 2, one longer; since JM §0 the Orc Archer's Gall lays 3 on every hero and cools 3, equal; since JO §2 Gall, Mire and Bone Rattle's Sap each lay 3 and cool 2, a turn longer, and the Bellow's Fester takes its full clock back each turn (THE WARBAND's HEXES). Since JS §2 the Stillwrought's Leaching Stillness lays Sap 3 and cools 2, a turn longer; the Frostbitten Thrall's Slowed and the Hailcaster's Dazed lay 2 and cool 2, equal; the Icewrought Titan's Entomb lays Frozen 1 and cools 2.*
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
  3.44 runes acquired per hero per run** four blocks lower, off the correct key. *(Re-taken at IW over the ten natural arms' thirty party blocks: 4.82 merchants walked, 3.36 runes bought, 6.36 acquired per hero per run — THE SIM's FIGURES, RE-TAKEN AT IW.)* **Its prose is
  reversed as well**: it claims every route policy *"puts combat first"* and `ROUTE_ORDER` puts
  `fight` **at or near the END**, with `blacksmith` and `merchant` first and second in two of them —
  which a comment above it said itself when this was written (*"balanced: trade nodes first"*, no longer in `scripts/run_sim.gd`). **This is the
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
- **THE ABILITY CORPUS IS 233 AT JQ's CLOSE** (`Classes.ability_corpus()`, which `check_ek` §1 and `check_fe` §1 read against `CARD_TAGS`; Forsake and Read the Tell the latest, 231 from IF §2's Smoulder) — **228 at GN, whose
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
- **`RECAST_GATED` HOLDS 65 ABILITIES** (Forsake joined at JQ) — DS added four (Bear the Brunt, Dug In, Thick Hide,
  Salve), each of them entirely a status on the caster. **BRING IT DOWN DELIBERATELY DID NOT
  JOIN**: its number is snapshot off the deepest bond's Loyalty, which is uncapped, so a recast on
  a deeper bond genuinely buys a bigger amp and can never do nothing. **HEADS DOWN is not in the
  system at all**, because it deals damage. DR's COUNTER TIME joined for the same reason the four
  did.
- **AND A PROPOSAL MUST EQUAL WHAT A *GOOD* CAST WRITES, WHICH DS LEARNED FROM A RED.**
  `check_co` saturates by casting at grade `"good"`, so a `_recast_writes` entry proposing the
  PERFECT's duration improves on what is standing every time and the card never refuses. Salve did
  exactly that on the first run. `emberkeep` is not a counter-example — its handler writes
  `EMBERKEEP_TURNS` unconditionally (the card's figure since IU §3). **A `special` carrying a POWER needs its own arm rather
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
- **The ability draft is COMPLETE at 181 of 181** — `SPEC_DRAFT_POOLS` is **159** and
  `CLASS_DRAFT_POOLS` is **22**, counted out of `classes.gd` (**20 until JQ put Forsake on the Cleric's shelf and Read the Tell on the Warrior's; 154 and 25 until GN moved five
  class-wide cards into the class kits; 129 and 20 until GS §1 put the 29 cards that stopped travelling on their
  lineages' shelves; 158 until HB put Tripwire on the Survivalist's; 159 until HL §1 took Guard Change off the
  Swordmaster's to travel with the Stances; 158 until IF §2 put Smoulder on the Pyromancer's**). **NEITHER HALF IS A FLAT MULTIPLE ANY
  MORE.** DO's twenty-two took nine spec pools past eight, DR moved two of those nine (Swordmaster to
  TWELVE, Cryomancer down to ELEVEN), DS took the last three at eight to TEN, and **DY took the
  Warden to TEN, the Arcanist to TWELVE and the Devout to ELEVEN**. **THE SHALLOWEST SPEC POOL IN THE
  GAME WAS TEN FROM DY TO GS** — the Warden's nine was the floor from DS to DY — **and is ELEVEN since GS §1** (the
  Warden and the Survivalist until HB, the Warden alone since; the Pyromancer and the Arcanist are the deepest at
  sixteen).
  **AND THE CLASS HALF STOPPED BEING 4 × 6 AT DY, AND GN THINNED IT: the Warrior's pool draws SEVEN since JQ and the Hunter's
  six, the MAGE's FIVE and the CLERIC's FOUR since JQ (THREE from GN)**, so `CLASS_TARGET` is a summed table (`test_batch_cd.PER_CLASS_DEPTH`) exactly as
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
  a SPEC does in a fight.

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
  **Seven
  `check_*.gd` files are not in `GATES`** — `check_ck_width`,
  `check_cu`, `check_cv`, `check_dn`, `check_ct_map`, `check_map_screen` and `check_de`. **`check_ct_map` and
  `check_map_screen` run in the SCENE RUNS section and `check_de` runs in its own post-pass section
  AFTER them**, so the four that run nowhere are `check_ck_width`, `check_cu`, `check_cv` and `check_dn`.
  **SINCE EI THOSE FOUR ARE PARSE-COVERED AND NAMED IN `check_parse`'s OUTPUT EVERY RUN** as its
  RESIDUE — in the tree, spawned by nothing, reached by nothing. They are still not in `GATES`,
  because what a failure in an audit REPORT means is a ruling rather than a detail.
- **THE BATTERY WRITES A MANIFEST, `$OUT/.ran`, AND THE DIFFER TRUSTS IT RATHER THAN THE DIRECTORY
  LISTING.** `run_battery.sh` does NOT clear `$OUT` between runs, so a target that failed to launch
  would otherwise be blessed by its PREVIOUS run's log. A name is appended immediately before its
  target is launched and `run_one` truncates the log at spawn, so **a log named in the manifest is
  always this run's**. A subset invocation (`./run_battery.sh bo bp`) writes a short manifest and
  **the differ reports the rest as DID NOT RUN instead of certifying a clean tree.**
- **`gate_fixture.gd` AND `suite_fixture.gd` ARE NOT GATES AND ARE DELIBERATELY NOT NAMED
  `check_*`/`test_*`** — `test_batch_cd` and `check_da` both glob those prefixes.
- **THE BASELINE TABLE IS `baselines.json` AND ITS ROWS ARE THE SUITES, THE GATES, THE
  SCENE RUNS AND THE HARNESS GATES**. **A new gate owes TWO rows**, its
  own and `check_parse`'s, because that gate's count IS its coverage and a target joining the
  battery raises it the same day. **IT IS
  `indent=1` AND MUST BE RE-DUMPED THAT WAY** — Python's default churns the whole file for a
  four-line change. **DO NOT RESTATE ITS NUMBERS HERE OR IN `CLAUDE.md`** — a second copy of a
  number is this project's oldest recurring defect, and **DG found five live copies of one figure
  and two disagreeing copies of another.** Per target it carries the expected check count (a number
  or a band), **the expected FAILURE count**, **how many readings the row rests on**, any known
  flake and its rate, and an optional verdict string. **Every red row carries the reason it is red.**
- **`check_de.gd` IS THE DIFFER, IT SPAWNS NOTHING, AND IT HAS NO ROW OF ITS OWN** — it excludes
  itself from its own sweep, which is why its count moving 289 → 293 at DM (four assertions per
  target, and DM adds one gate) is reported by nothing. **DI's report made the same movement
  and did not predict it; DJ's, DK's, DL's and DM's prediction tables all carry it.** It runs last, reads the logs and the
  baseline file, and reports. **It is re-runnable in seconds over a log directory that already
  exists**, which is what lets a batch write `docs/state.md` and its report AFTER the battery and
  still certify the tree — `check_de` reads neither, though the gates that open `docs/state.md` do, so a batch writes its documents before the run (HX §3).
- **`run_battery.sh`'s check-count grep is GENERAL and must stay that way.** It matches three
  shapes because the suites print several between them. **The `grep -E "checks,"` in the
  battery's header is a comment recording a scar CP already fixed — it is not live code.**
- **The master.html stamp gate is duplicated across 14 suites** (ah, bb, bn, bo, bp, bq, br, bs,
  bt, bu, bv, bw, bx, ce), all on the self-comparing pattern — no bump is owed on a re-stamp.
- **Run harness gate counts are in `baselines.json`** — EE's locator guard moved gate 2 from 165.
  - **THE FOURTEEN STAMP GATES COMPARE AGAINST THEIR OWN BATCH CODE, NOT AGAINST THE PREVIOUS
    STAMP, AND THAT IS WHY DY'S RECORDED SORTING DEBT IS NOT ONE.** Each reads
    `substr(_code_at + 7, 2)` and asserts `>=` its own code — every one of them `CE` or older.
    **`EA` and `EZ` both pass all fourteen**, checked in GDScript rather than reasoned about.
    **What would break it is a THREE-letter code**, because the compare reads exactly two
    characters.
### HOW LONG A FIGHT IS
**ITS FIGURES ARCHIVED AT JO** — the rounds tables, ramp arrival, the Loyalty and Faith rows and their confounders, stale since DK and read by no batch since the floor (`DoD-archive/state-archive.md`, ARCHIVED AT JO; the reports keep each table). Two instrument facts stand:
- **THE SIM'S OWN `Avg rounds/battle` LINE DIVIDES BY THREE AND THE PARTY IS FOUR.** It has been
  reading a third high since the class draft. `cy_report_line` is the one to read instead.
- **AND THE INSTRUMENT'S OWN CAVEAT: the `conviction` row samples the DEVOUT'S OWN meter, which
  HOLDS at the threshold and never releases by rule.** It has never measured release frequency —
  `releases/battle` is the row that does.

### The changelog
- **THE LIVE FILE WAS CUT AT IZ, AT THE HR/HS BOUNDARY** (GZ's was FS/FT). It starts at **Batch HS** and the archive ends at
  **Batch HR**. **DO NOT COUNT THIS BY HAND AND DO NOT TRUST THIS LINE**: `check_dv` §4
  prints the live figure every battery and `check_fg` §1 prints the SIZE beside the bar, and this
  sentence **has arrived stale at EE, at EO and again at FF** — three times, each time in the
  direction of reading low. **DV ASSERTED THE COUNT AS AN EQUALITY AND IT COULD ONLY PASS FOR ONE
  BATCH** (`live_span == 16`, red on DW's own entry); **it asserts a FLOOR** now — IZ's cut left 33
  plus its own = **34**, and entries are only ever added, so an entry VANISHING still fails — **and the ARCHIVE
  keeps its equality, at 263 since this cut**, because that file only moves when a cut moves it. **DX generalised
  that repair into a construction rule**; see `docs/instrument-rules.md` (DX §1).
- **THE THRESHOLD IS WATCHED, AND AT GZ THE WATCHER WORKED END TO END FOR THE FIRST TIME.** The bar is **400 KB**, the
  decimal and stricter reading; `check_fg` §1 warned on GY and GZ took the cut at the next boundary, the sequence FG
  designed. GZ's figures are `docs/reports/GZ.md` §2; the live size and headroom are `check_fg` §1's print. **IZ took the next cut a batch before the bar, by its brief's order** (CW §4's procedure, ahead of its documents): IY's close-read found the live file at 387,694 B before IY's entry, and IZ's own entry would not have crossed 400,000 (390,847 B at IY's close); IZ's figures are `docs/reports/IZ.md` §6.
- **`check_fg` §1 HOLDS NO COPY OF THE BAR AND THAT WAS RE-CONFIRMED BY READING THE GATE**, not its header
  comment: its only route to the number is a pattern over `docs/instrument-rules.md` that finds the FORM whatever
  the number is, collects every occurrence and asserts the set has one member. **FU's red was §2's** — the defect
  was shared by both form checks, but the number that moved was `CLAUDE.md`'s ceiling.
- **`DoD-archive/changelog-archive.html` holds 263 entries** (Batch 1 → **HR**) and is **2,155,950 B**; `python3 claude_md_census.py` prints the folder's size. **IT IS IN THE REPO AS OF BATCH FH, SO IT IS IN VERSION
  CONTROL AND BACKED UP BY GITHUB, AND THAT EXPOSURE IS CLOSED** — **GZ was the first cut to add to it since, and IZ the second**, so
  neither addition's recovery depends on a named commit. It is kept out of the knowledge sync
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
  same LENGTH and whose every heading count reads clean. **AND AT IZ BY A SCRIPT OF ITS OWN** (`verify_cut.py`, a line walk with a hash per entry, sharing nothing with the splitter): 0 failures, the two bodies rejoined byte-identical (sha256 `35cd0ef8…`), and its proof proved on scratch pairs — an entry dropped → **6**, an entry in both halves → **7**, one word misspelt at the same length → **2**, the byte arms alone.
- **TWENTY FILES OPEN THE LIVE CHANGELOG AND FIFTEEN RESOLVE THE ARCHIVE THROUGH ITS OWN HEADER** (IZ's census: this line said
  seventeen, and named two of the five that read the live file alone) — the
  fourteen suites bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, cb, ce, **plus `check_dv` §4** for the archive,
  and **`check_fg` §1, `check_ec` §2, `check_el`, `check_es` and `check_fr`** for the live file alone; **0 hardcode the archive path**, and two tools
  read the live file by relative name (`docs/build_docs.py`, which is why the live file must never move, and
  `build_pin_manifest.py`). **NO `.gd` FILE IN THE TREE NAMES THE ARCHIVE BY PATH**, which is why FH's move was
  one header edit and none of the fifteen was touched. **NONE OF THEM NEEDED RE-POINTING AT DV, AT FG, AT FH, AT
  GZ OR AT IZ, AND THAT IS CX's WORK**: every live-changelog assertion in the tree is either the archive-path anchor or a
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
- **LIVE SIZES ARE PRINTED, NOT CARRIED.** `check_fg` §1 and §2 print `docs/changelog.html` and `CLAUDE.md`
  against their bars, `check_fr` §5 prints `docs/instrument-rules.md`, `CLAUDE.md`, `docs/ways-of-working.md` and, since GR,
  `docs/combat-rules.md`,
  and `claude_md_census.py` prints the file count, the byte total and the archive folder for any commit. **The archive is the
  heaviest file the census counts, and it is deselected from the sync**, so what the connector ingests does not
  move with it. **THE THRESHOLD ESTIMATE IS NOT IN THIS BLOCK AND THAT IS DELIBERATE**: it read seventeen →
  thirteen → eight → seven batches away as it was re-measured, **each re-measurement shortening it — the
  direction a carried-forward number never moves on its own** — and then the threshold was crossed four
  batches before anyone noticed. **`check_fg` §1 prints the live figure and the headroom against the bar every
  battery. Read that.**
- **THE DESELECTION LIST FOR THE FILE PICKER. THE ONE FH ADDS IS `DoD-archive/`, ALL THREE FILES.**
  `python3 claude_md_census.py` prints its size, which moves at every cut. **Deselect `pin-manifest.json`** too — it stays in the repo and
  `check_ed` goes on reading it off disk. Already standing and unchanged: the 47 suite files,
  `docs/build_docs.py`, the archived changelog, and any audit document whose findings have been
  ruled on and applied. **`docs/reports/` grows every batch and is the largest block still in
  question** — NOT recommended, because `CLAUDE.md` records the dispute over it rather than resolving
  it (FS §3), and moving it is a ruling. **`claude_md_census.py` IS A
  CANDIDATE TOO** by the same argument that deselects `build_pin_manifest.py` — it is a tool Claude
  Code runs off disk — **but it is 11.34 KiB and the saving is not worth a second entry to remember.**
  **WHAT MUST STAY SELECTED NOW INCLUDES `docs/instrument-rules.md` AND, SINCE GR, `docs/combat-rules.md`** and is listed in `CLAUDE.md`:
  **a split ADDS a file to that list and never removes one from the sync.**
- **The 47 suite files cannot be archived (they must be in the repo to run) but they CAN be
  deselected from the sync.**
- **`scripts/` contains ZERO test suites.** All game code.

---

## KNOWN-BROKEN AND DELIBERATELY UNFIXED

### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED

**FOUR UNSEEDED FLAKES WERE SEEDED AND CLOSED AT DF, DT, DX AND DY, EACH SETTLED AT ZERO**, the record archived at JH.
**AND NO SWEEP OF THE SOURCE CAN CERTIFY THERE IS NO FIFTH** — twenty suites draw without seeding
and are stable, and `at` itself calls no RNG at all. **`baselines.json`'s `flake` fields are the
census; one row carries one, `test_rune_battle`'s, kept after its seeding.**
**THE FIFTH SURFACED AT JB, AND IT WAS NOT THE BATCH'S.** `test_batch_bk` §9 took the one map its section opened with and wanted two adjacent three-wide columns, which about one map in a hundred lacks, at the same rate on JA's generator as on JB's, so JB's first acceptance read it red with nothing wrong. **It draws until it has the shape now, sixty-four at most, and it is not seeded**: the arm wants a shape, and a seed is a dice sequence the next generator change takes away.

**THE RETIRED-WORD SWEEP CAUGHT DU TOO, AND IT WAS CAUGHT BEFORE THE BATTERY RATHER THAN BY IT.**
`test_batch_bx` §4 keeps *beast* out of player-facing prose and §4b keeps *party* out; both read
`master.html`. **DU's new companion paragraph called Hunter's Mark "party-wide"** and would have
failed §4b. It says "the ownerless Hunter's Mark" now — the phrase the card's own row already used.
**A BATCH WRITING COMPANION PROSE IS THE BATCH THAT REINTRODUCES A RETIRED WORD**: DS hit the same
trap with *beast* on all four of its battery-1 reds. **The cheap defence is to run the sweep's own
strip over the edited document before the battery**, which is what turned this one into a
five-minute fix instead of a second thirty-five-minute run.

**THE COUNTS AND THE BANDS ARE IN `baselines.json` AND ARE NOT REPEATED HERE.**

### THE REST

- **`check_gj` reports 1 failure SINCE GN, AND IT IS ON PURPOSE: THE ARM IS RIGHT AND THE GAME IS WRONG.** §4 asserts
  the victory card's gold is the gold that arrived, and the card leaves out the Tollkeeper's Bell (FOUND AT GN, above);
  GN's code moved the gate's seeded run onto the Bell. HEAD's code with the Bell forced reds the same arm. It goes back
  to zero the batch that fixes the card, and its row in `baselines.json` says so.
- **`check_cm_live` reports 4 failures — 4 TO 5 SINCE IE. THIS IS THE OLDER OF THE TWO REDS THAT ARE ON PURPOSE.** Identical on
  unmodified HEAD, recorded as owed in the gate itself. **DB confirmed the four are byte-identical
  before and after the gate consolidation; DC through DR confirm them again.** It drives an attack at
  the defensive bar; `check_fh` §7 presses the bar itself.
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
  **The two vacuous exclusive-pair siblings in `as` and `at` are the remaining live
  instances** (`aw`'s was repaired at IT §3b), named at their sites and in the open queue above.
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
