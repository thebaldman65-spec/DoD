# BATCH IP — THE DECK's LAST CUT, AND THE INSTRUMENT's OWN DEFECT

**On `class-merge`, from `9f9154d` (IO). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `9f9154d`, IO's push and local
HEAD, before anything ran. **The designer played, clean**: `readout/run-20261018-194229.jsonl` (24,340 B, md5 `610bcd8c…`), ten
fights at Warden, zone one through its boss, no debug action anywhere — the first clean file in the project's history — and
`run_save.bin` (55,264 B, 23:21) at zone two's start; both backed up first with the player's files (`../save-backups/IP-20261019-095709`,
09:57), the readout untouched and md5-identical at the open and the close; **no newer file appeared.** **Both readings are comfortable at the honest rate** — `CLAUDE.md` 19.8 batches and `docs/state.md` 9.1 at the mean of
IL–IP (THE TWO READINGS, below).

**What IP did.** **§1a — the Hungering Dark is removed, not disabled**: its row, `Run.HUNGERING_DARK_PCT`, its feed at BL's damage
door (`_dark_feeds`) and the heal door's `unowned` parameter — which nothing else reached — are gone; `heal_amount` is IN's body byte
for byte and `_on_damage_taken` IM's. Its shape and IO's figures are in `docs/design-notes.md`, and the rule it taught, *two-sidedness
does not make a rule even*, is in `CLAUDE.md`'s ladder block beside AQ's. **§2 — the sim's bot drinks the player's potion**
(`Run.health_potion_heal` of its own maximum, where it drank a flat 40 from CT to IP), and **the five arms the potion could move were
re-taken on it, both builds, BEFORE the cut**: the Thin Veil (0.887 → 0.908) and Wasting (0.658 → 0.684) moved past their noise,
Bloodless, Miasma and the baseline inside it. **§1b — severity 5 is the cliff, three deep**: twenty-three modifiers cut 6 / 6 / 4 / 4 / 3
by the measured order, **built on the repaired figures and on a second seed block for the six either side of the cuts** — **six moved**
(Overgrown 5 → 4, Parched 2 → 1, Brittle 3 → 2, Deadened 4 → 3, the Thin Veil 4 → 3, Rot 3 → 4), where the brief's table moved four,
and **two cuts are still ties** (Parched | Slick Footing, Deadened | Rot), named arbitrary in `docs/state.md`. EP's sample: **Wanderer
2.82, Warden 3.28, Ruin 4.50** against IO's 2.84 / 3.29 / 4.49 (the drift −0.019 / −0.007 / +0.005), merchants 117 / 87 / 67. In
natural play every road's bargain fights get harder — Warden's end at 0.908 of the party's health against 0.936. **§0 — the playthrough's
six findings and the deck's grade table with its two limitations are in `docs/state.md`**; four rules are recorded (two-sidedness in
`CLAUDE.md`; the tie, the site test and the instrument's fidelity in `docs/instrument-rules.md`, with their rows). **No save version
moved.**

**VERDICT: GREEN**

## NEEDS A RULING

1. **A SECOND RUN, WITH A DIFFERENT PARTY** (the brief's §3). The first clean file answered four of IH's five questions and found two
   more (§0.1); every figure in it is one run and one party. Nothing waits on it.
2. **TWO CUTS ARE STILL TIES AFTER A SECOND SEED BLOCK** (§1b): Parched | Slick Footing (1 | 2), 0.003 apart against two standard
   errors of 0.007; Deadened | Rot (3 | 4), 0.0006 apart against 0.011. Named arbitrary beside the grade table; the sort's order
   stands. A third block, or your choice of order, is yours.
3. **THE PAIRS RE-MEASURED WERE THE CUTS' OWN, NOT THE BRIEF's LIST** (premise 14). On the brief's own table none of its three pairs
   stood at a cut; IP re-measured the six either side of the cuts on the repaired instrument. Confirm.
4. **THE REPAIRED POTION MOVED A GRADE, SO SIX MOVED WHERE THE BRIEF's TABLE MOVED FOUR** (§1b): the Thin Veil 4 → 3 on the player's
   potion, and Rot 3 → 4 by 0.0006 behind it — a tie. The brief's four stand, the cliff of three holds, and Warden's gambles are
   Overgrown, Miasma, Thin Air and Rot. Built as the brief said (*build the measured order, not my table*); confirm.
5. **WHAT THE RE-CUT DOES TO PLAY** (§1c): Wanderer's bargain fights end at 0.956 of the party's health (0.971 at IO), Warden's at
   0.908 with heroes down five times as often (0.936), Ruin's at 0.687 (0.741); the potion alone moves none. Warden has more teeth
   than IO left it; whether it reads right is the middle of the deck's question, which is yours to author (§0.12).
6. **A STORED OFFER THAT NAMES A REMOVED MODIFIER WOULD BREAK THE OFFER SCREEN** (FOUND AT IP): `offer_screen._draw_option_parts`
   reads `Run.MODIFIERS[id]` unguarded, and a save frozen mid-offer before IP can name `hungering_dark` (IO's two removals carried the
   same exposure). **The live save holds none** — decoded, it stands at zone two's start with no encounter. A bargain already TAKEN
   under the id is fought under no modifier (`_active_modifier` reads the deck, driven: `check_ip` §1a). Whether a removal owes the
   save a re-ask (FD §1's rule) is yours.

## THE BRIEF's PREMISES, CHECKED

Every claim the brief makes about the tree, the file or a prior batch, read before anything was edited. **Seven do not hold as
written** (3, 8, 14, 15, 19, 22 and 23); the rest hold.

| | the brief's claim | what the tree says |
|---|---|---|
| 1 | §5: IO's push hash; `ls-remote` against HEAD before anything runs | **Held**: `9f9154d` both, read before anything ran |
| 2 | head / §0.1: the playthrough, ten fights, `debug_used` false, zone one through the boss | **Held**: ten `fight` lines, the header's `debug` empty and `debug_used` false, every fight's `debug` empty; nine of zone one's fights and its boss (slot 15) |
| 3 | head: *it arrived after IO started*, and is in `docs/reports/` | **It is in the live folder's `readout/`, not `docs/reports/`** (its mtime 23:21 on 2026-10-18, after IO's 10:53 backup); nothing in the repo holds it, and IP does not copy it in (§3: *do not touch it*) |
| 4 | §0.1: Rupture formed turn 20, its body died turn 29, stood 0, ticks 0, break 0 | **Held** |
| 5 | §0.1: *the Chill came from a Cryomancer* | **Held, with the reading said**: the Mage was dealt the Invoker's spine and slotted the Cryomancer's core THIRD at fight 7 (the Weaver's second at fight 5) — so the chill came from a Cryomancer by his core rune, and Razor Ice, the Cryomancer's enabler, came with it |
| 6 | §0.1: *both Ruptures ever recorded ground nothing* | **Held**: IH's (debug-touched) stood one turn and ground its tick on a 13-Constitution body (`docs/state.md`'s record); IP's stood none |
| 7 | §0.1: Sanctity 18.33 events and 1.17 steps a normal fight; IO's 2.56 at 13; the bot books 2.2× | **Held** (110 events and 7 steps over six normal fights; 40.43 / 18.33 = 2.21) — **on two different roads**: the player at rung 2 with his own party, the bot at rung 1 beside the default lineages, both untalented |
| 8 | §0.1: the boss read 51 events, 2.78× a normal fight, *not FV's 1.55* | **The 2.78 held; the 1.55 is not FV's**: it is II's brief's ratio of STEPS (IG's boss 4.04 against 2.58); FV's boss-to-trash ratio of EVENTS read 1.09–1.16 (`docs/reports/FV.md` §3a). The playthrough's steps ratio is 2.57. The conclusion — half the cap in a normal fight puts a boss at 1.4× the cap — holds on either |
| 9 | §0.1: the vow, 322 refused for 707 added, seven fights | **Held** (the seven fights it was worn, fights 4–10) |
| 10 | §0.1: the Cleric 3 hard-dry and 6 soft-dry of 58; the Mage 0 of 56, the Hunter 0 of 65 | **Held** |
| 11 | §0.1: Boil Over never drafted | **Held**: no Warrior bar in the file holds it, and `boil_over` is empty in all ten |
| 12 | §0.1: the Sharpshooter 42.2% (988 of 1,955 at the boss, peak 339); the Berserker 18.2%, `low_water` 0.00 all ten, 22.9% of costed turns hard-dry | **Held**: 3,396 of 8,053; 1,468; 11 of 48 |
| 13 | §0.2: *the heroes deal about six times what a warband does* | **Held**: IO's feed probe fed the heroes 117,266 and the warband 19,336 — 6.06 to 1 |
| 14 | §0.4 / §1b: three tie pairs, *two of the three sit at a grade boundary in the table above* | **None of the three sits at a cut of the brief's table** — Warded and Parched are both 1, Fleeting and Brittle both 2, Rot and Deadened both 3: the Dark's removal shifted every cut one place. **IP re-measured the pairs that straddle the cuts** — Parched / Slick Footing, Brittle / Feverish, Rot / Deadened — the rule's direction (ruling 3) |
| 15 | §1b: *the table's own original counts with a three-deep top*; the table | **The counts held; the table is the measurement's, not the brief's** — the repaired potion moved the Thin Veil to 3 and Rot to 4 (ruling 4) |
| 16 | §1b: the arithmetic 2.83 / 3.29 / 4.50 | **Held**: the bands' arithmetic reads 2.833 / 3.292 / 4.500 |
| 17 | §1b: Ruin's two gambles draw from three without replacement | **Held**: 800 severity-5 options in 400 Ruin offers, every offer two distinct (`check_ip` §1b) |
| 18 | §1a: `heal_amount`'s door *was built for it*; say whether anything else reaches it | **Held, and nothing else did**: `_dark_feeds` was its one caller in the game and `check_io` §1c its one reader in the battery (the census) |
| 19 | §2: *the bot drinks one Health Potion, only below 35% health, at a flat 40* | **One a TURN, not one a fight**: a hero who opens a turn below 35% drinks one carried potion before acting, and may drink again on his next turn (`battle._player_turn`). The flat 40 and the 35% held |
| 20 | §2: the five arms — Bloodless refuses healing, Miasma halves it, Wasting and the Veil decide how often a potion is drunk | **Held**, read at each door: `mod_no_heals` refuses at the heal door's top, `healing_received_mult *= 0.5`, and the drink fires on the 35% line those two drive bodies across |
| 21 | §2: *two of the five are severity 5, so the cliff is at stake* | **Held, and it held**: Bloodless 0.640 and Wasting 0.684 stay below Mirrorbound's 0.706; the cliff to Overgrown's 0.857 is 0.151 |
| 22 | §0.5: the eight that grade differently untalented | **IO's list, at IO's cut.** At IP's cut, seven grade differently: Parched and Warded (2), Muffled and Deadened (1), Brittle (3), Overgrown (3), the Thin Veil (4) (`docs/state.md`) |
| 23 | §0.2: record the two-sidedness rule in *`docs/instrument-rules.md`'s design section with AQ's own rule* | **That file has no design section and AQ's rule is not in it**: AQ's rule is `CLAUDE.md`'s ladder block, and a rule about what the deck may contain is `CLAUDE.md`'s by the seam (IO's premise 59, the precedent). Written there, beside AQ's; §5's list of instrument rules otherwise held |
| 24 | §3: *the archive takes the newest cut first — IO asserted it; keep the assertion* | **Held and kept**: `check_io` §7's order arm untouched; its top arm re-pointed from *IO* to *IO or later*, and `check_ip` §7 holds IP's at the top |
| 25 | §4: IO closed at 22.7 and 18.2 batches at the honest rate | **Held** (IO's report) |
| 26 | §5: IO read 155 targets | **Held**; IP reads 156 (`check_ip` joins the gates) |
| 27 | §5: IO's `check_gp` moved a row and stopped an acceptance | **Held** (IO §9) |
| 28 | §5: `check_gw`'s ceiling is 96 | **Held**; `check_ip` writes none of its fields (§9) |

## §0 — IO's TWELVE RULINGS, ANSWERED

1. **The play** — arrived, clean (§0.1). 2. **The Dark** — removed (§1a). 3. **Overgrown** — severity 4 (§1b). 4. **The ties** — measured
again (§1b; two stay ties). 5. **The default build grades** — its two limitations beside the table in `docs/state.md`. 6. **The Thin
Veil** — confirmed; a rule of its own owed, the designer's. 7. **The Long Silence's readings** — confirmed. 8. **A filler is not a site** —
the test recorded beside the superlative note; the 321 stay listed. 9. **The potion** — repaired, and what it could move re-taken
(§2). 10. **Through and Through's refund** — noted and left: nothing has written `tt_refund` since FX, the read-only-zero shape DO
named, and whether a node or rune returns it is the designer's. 11. **The Cleric's share under the Dark** — folded into the Dark's
record (§1a). 12. **The bands and the grades stand**; the deck has no middle, and the four or five modifiers at 0.78–0.86 that would
give Warden one are the designer's to author; no count moved to chase it.

### §0.1 — THE FIRST CLEAN PLAYTHROUGH, READ

Every figure the brief quotes was re-derived off the file; all hold, two premises aside (8, the 1.55's source; 5, said with its
reading). The party: a Berserker on his own core (Grudge worn from fight 4), a Mage on the Invoker's spine (the Weaver's core second
from fight 5, the Cryomancer's third from fight 7), a Cleric on the Hierophant's spine (the vow from fight 4; the Holy's core second at
the boss), a Sharpshooter (Long Draw, Shared Mark, Keen Focus); no talents, no relics. Recorded in `docs/state.md` (THE FIRST CLEAN
PLAYTHROUGH) and nothing built (§4):

| finding | the file says |
|---|---|
| Rupture is unreachable, not mis-tuned | one Rupture, by the Mage on the Orc Chief at the mini-boss, formed turn 20, its body dead turn 29: stood 0, ticks 0, Break 0 |
| Sanctity | normal fights 8 / 16 / 14 / 26 / 18 / 28 events — 18.33, steps 1.17; elites 19 and 25; the mini-boss 33; the boss 51 (3 steps) |
| the vow | refused 46 / 21 / 67 / 43 / 57 / 35 / 53 = 322; added 103 / 109 / 86 / 86 / 90 / 104 / 129 = 707 |
| the Cleric's Mana | hard-dry 0 ×8, 1, 2 = 3; soft-dry 6; of 58 turns. The Mage 0 of 56, the Hunter 0 of 65 |
| Boil Over | never drafted |
| the damage | Sharpshooter 3,396, Mage 3,018, Berserker 1,468, Cleric 171 of 8,053; the Berserker's `low_water` 0.00 in all ten, hard-dry 11 of 48 costed turns |

## §1 — THE DECK's LAST CUT

### §1a — THE HUNGERING DARK, REMOVED

**Every row, door and word** — the `MODIFIERS` row, `Run.HUNGERING_DARK_PCT`, `battle._dark_feeds` and its call at BL's damage door,
`_stamp_modifier`'s arm (Wasting's arm stands alone now), the comment legend, master.html's row and its sentence about the Cleric,
and `heal_amount`'s `unowned` parameter with its three lines. **Whether anything else reached that door: nothing.** `_dark_feeds` was
the one call passing a third argument in the game's code (71 heal calls read, none with one — `check_ip` §1a), and `check_io` §1c the
one reader in the battery. So it goes, and the two functions the Dark had edited went back to their older bodies **md5 for md5**:
`heal_amount` with its comment block to IN's (`c111dcce…`), `_on_damage_taken` to IM's. **Comments stripped, no word of it is left
in `scripts/` or `data/`** (`check_ip` §1a, 34 files read). **Its shape, IN's and IO's figures, the 6.06-to-1 feed and ruling 11's
Cleric split** are in `docs/design-notes.md`, newest entry; the rule is in `CLAUDE.md` (§0).

**The save.** A save written before IP can carry `hungering_dark` two ways: as the bargain in force (`pending_modifier`, and the
step in flight's `encounter.bargain`) — `_active_modifier` asks the deck, so the fight is fought under no modifier, and a blow under it
feeds nobody (driven both ways, `check_ip` §1a, `check_io` §1c, `check_in` §1g) — **and as an option of a stored offer, which the
offer screen would fail on** (ruling 6). The live save carries neither.

### §1b — SEVERITY 5 IS THE CLIFF, THREE DEEP

**The order the work ran in, as the brief asked: §2's five arms first, on the unchanged tree with the repaired potion (10:02–10:22);
then the second seed block on the six either side of the cuts that the repaired figures drew (10:19–10:38); then the cut, built on
both.** The forced arm is IO's instrument unchanged (IN's `DOD_IN_FORCE` probe, IG's three parties, the default build), seed block
21; the second block is block 41, on IP's bot.

| | modifier | health at a bargain fight's end | runs completed | source | IO → IP |
|---|---|---|---|---|---|
| 1 | Hoarfrost | 0.963 ± 0.003 | 56 of 60 | IO | 1 |
| 2 | Dull Edge | 0.957 ± 0.003 | 59 of 60 | IO | 1 |
| 3 | Frenzied | 0.954 ± 0.003 | 58 of 60 | IO | 1 |
| 4 | Tinderbox | 0.951 ± 0.003 | 59 of 60 | IO | 1 |
| 5 | Warded | 0.949 ± 0.003 | 56 of 60 | IO | 1 |
| 6 | Parched | 0.948 ± 0.003 | 113 of 120 | pooled | 2 → **1** |
| 7 | Slick Footing | 0.945 ± 0.002 | 108 of 120 | pooled | 2 |
| 8 | Muffled | 0.941 ± 0.003 | 56 of 60 | IO | 2 |
| 9 | Encumbered | 0.941 ± 0.004 | 55 of 60 | IO | 2 |
| 10 | Bloodletting | 0.938 ± 0.004 | 55 of 60 | IO | 2 |
| 11 | Fleeting | 0.931 ± 0.004 | 54 of 60 | IO | 2 |
| 12 | Brittle | 0.921 ± 0.004 | 104 of 120 | pooled | 3 → **2** |
| 13 | the Long Silence | 0.910 ± 0.004 | 53 of 60 | IO | 3 |
| 14 | Feverish | 0.910 ± 0.004 | 108 of 120 | pooled | 3 |
| 15 | the Thin Veil | 0.908 ± 0.005 | 52 of 60 | **IP's bot** | 4 → **3** |
| 16 | Deadened | 0.899 ± 0.004 | 102 of 120 | pooled | 4 → **3** |
| 17 | Rot | 0.899 ± 0.004 | 103 of 120 | pooled | 3 → **4** |
| 18 | Thin Air | 0.897 ± 0.006 | 50 of 60 | IO | 4 |
| 19 | Miasma | 0.875 ± 0.005 | 51 of 60 | **IP's bot** | 4 |
| 20 | Overgrown | 0.857 ± 0.006 | 55 of 60 | IO | 5 → **4** |
| 21 | Mirrorbound | 0.706 ± 0.008 | 47 of 60 | IO | 5 |
| 22 | Wasting | 0.684 ± 0.008 | 46 of 60 | **IP's bot** | 5 |
| 23 | Bloodless | 0.640 ± 0.008 | 48 of 60 | **IP's bot** | 5 |

**THE SECOND BLOCK, PAIR BY PAIR** (block 1 IO's bot, block 2 IP's):

| | block 1 | block 2 | pooled |
|---|---|---|---|
| Parched | 0.942 ± 0.004, 56 of 60 | 0.953 ± 0.003, 57 of 60 | 0.948 ± 0.003 |
| Slick Footing | 0.942 ± 0.004, 55 | 0.948 ± 0.003, 53 | 0.945 ± 0.002 |
| Brittle | 0.922 ± 0.005, 51 | 0.920 ± 0.005, 53 | 0.921 ± 0.004 |
| Feverish | 0.912 ± 0.005, 51 | 0.907 ± 0.005, 57 | 0.910 ± 0.004 |
| Rot | 0.901 ± 0.005, 52 | 0.897 ± 0.006, 51 | 0.899 ± 0.004 |
| Deadened | 0.898 ± 0.005, 51 | 0.901 ± 0.005, 51 | 0.899 ± 0.004 |

**Every cut, read against two standard errors of the difference**: **1 | 2, Parched | Slick Footing — 0.0026 apart, 2 SE 0.0071: A
TIE** (and Warded | Parched inside grade 1 at 0.45 SE, Slick | Muffled inside 2 at 0.98 — the cut sits in a cluster); **2 | 3,
Brittle | the Long Silence — 0.0113 apart, 2 SE 0.0111: measured, at 2.02 SE**; **3 | 4, Deadened | Rot — 0.0006 apart, 2 SE 0.0105:
A TIE** (Rot | Thin Air inside 4 at 0.17 SE); **4 | 5, Overgrown | Mirrorbound — 0.151 apart, 2 SE 0.020: the cliff.** The ties are
named arbitrary beside the grade table in `docs/state.md` (the rule, `docs/instrument-rules.md`). **Mixing two instruments**: the six
pooled arms ran block 1 on the flat 40 and block 2 on the player's potion. The potion moved the baseline −0.004 (−0.9 SE), and none of
the six turns on healing by its door, so the brief's model — the repair moves only the arms behind its door — is the one the pooling
rests on; each block is shown, so a reader can take block 2 alone (Parched 0.953 against Slick 0.948, Rot 0.897 against Deadened 0.901 —
a different order at 3 | 4, inside one block's noise, which is the tie said another way).

**What moved, and why each**: Overgrown, Parched, Brittle and Deadened are the brief's four — the Dark's removal shifting each cut one
place (Overgrown leaves the top the count of four had reached down to take). **The Thin Veil** rose to 3 on the repaired potion
(0.887 → 0.908, §2) — **beside Feverish's 0.910, so the dial's two settings now cost the same and share a grade**, which is
§0.6's point measured. **Rot** fell to 4 behind it, 0.0006 below Deadened — the 3 | 4 tie.

**The bands, after**: Wanderer's safe band (1–2) the same twelve but the Dark, Brittle in; its gambles (3–4) and Ruin's safe band
Overgrown, Feverish, Deadened, Miasma, Thin Air, Rot, the Thin Veil and the Long Silence (Brittle out, Overgrown in); **Warden's
gambles Overgrown, Miasma, Thin Air and Rot** (Deadened and the Thin Veil out); **Ruin's gambles the three**. The fixed encounters draw
Ruin's safe band's eight. **EP's sample** (400 offers a rung, seed 4004, past the shop gate): Wanderer **2.821** (its bands' arithmetic
2.833; IO 2.84, drift −0.019), Warden **3.283** (3.292; IO 3.29, −0.007), Ruin **4.495** (4.500; IO 4.49, +0.005) — by severity 1–5
216 / 184 / 399 / 401 / 0, 152 / 156 / 92 / 800 / 0, 0 / 0 / 206 / 194 / 800 — **merchants 117 / 87 / 67** (IO 113 / 82 / 71). No
severity 5 at Wanderer or Warden; every Ruin offer two distinct gambles of the three. `check_ip` §1b asserts each against its bands'
arithmetic and IO's reading within 0.05.

**Untalented, cut the same way** (IO's figures, IP's re-taken four): severity 5 holds the same three, and seven grade differently —
Parched and Warded 2, Muffled and Deadened 1, Brittle 3, Overgrown 3, the Thin Veil 4. The grades are the default build's (IO's
ruling 5, answered), the untalented standard errors three to ten times as wide and no untalented run completing.

### §1c — WHAT THE CUT DOES TO PLAY

**Natural play**, the bot choosing every bargain, IG's three parties 20 runs a party, seeded per run on IO's blocks: **H** IO's tree
(IO's own F arms), **P** HEAD with the repaired potion alone, **F** IP's tree.

| a bargain fight's end, 60 runs an arm | H — IO | P — the potion alone | F — IP |
|---|---|---|---|
| **Wanderer** (block 1) — runs completed; health; heroes down | 60; 0.971; 0.001 | 60; 0.970; 0.001 | 60; **0.956**; 0.000 |
| **Warden** (block 11) | 60; 0.936; 0.003 | 60; 0.938; 0.000 | 59; **0.908**; 0.014 |
| **Ruin** (block 21) | 50; 0.741; 0.104 | 54; 0.747; 0.089 | 51; **0.687**; 0.122 |
| **Ruin, untalented** (block 22) | 0; 0.381; 1.527 | 0; 0.374; 1.621 | 0; **0.280**; 2.100 |

**The potion alone moves no road** (every P inside its H's noise); **the cut moves all of them harder**: Wanderer's gambles now hold
Overgrown, Warden's hold Overgrown and Rot (the 0.857 and 0.899 of the table), and Ruin's gambles are the cliff alone, Overgrown no
longer among them to soften a draw. **Warden** — the designer's question at IO's ruling 12 — ends a bargain fight at 0.908 where IO
left it at 0.936 and where it stood at 0.846 before IO's re-grade. Ruling 5.

## §2 — THE INSTRUMENT's HEALING DEFECT

**The repair**: `battle._player_turn`'s drink reads `u.heal_amount(Run.health_potion_heal(u.max_hp), true)`, the function the
player's use path reads (`_use_item`'s `Run.health_potion_heal(heal_target.max_hp)`), where it read `heal_amount(40, true)`. The
policy is the bot's and unchanged: a hero opening a turn below 35% drinks one carried potion before acting (premise 19). **It reaches
no battery target**: `RunSim.active` is set by `RunSim.begin` alone, which a sim run calls and no gate does — so `check_ip` §2 drives
it by turning the sim's two switches on around a real turn loop, every hero below the line, and reads off the log who drank and what
(*the Pyromancer drank 200 of a 1,000 maximum* — the player's figure; the flat 40 cannot coincide).

**What it was worth.** On the default build the player's potion asks 42–44 a drink (the drinker's maximum ~215 late in a run) and
lands 45–49 through the healing multipliers; untalented it asks 32.6 (maximum ~163) — **smaller than the flat 40 early in a run and
larger late**, as IO's ruling 9 said.

**THE FIVE ARMS, BOTH BUILDS** (seed block 21 default, 22 untalented, paired run by run with IO's arm on the same seeds):

| arm | IO (flat 40) | IP (the player's) | moved | paired, run by run |
|---|---|---|---|---|
| **no modifier**, default | 0.951 ± 0.003, 58 of 60 | 0.947 ± 0.004, 57 | −0.004 (−0.9 SE) | −0.007 ± 0.005 |
| **Bloodless**, default | 0.656 ± 0.008, 47 | 0.640 ± 0.008, 48 | −0.016 (−1.5 SE) | −0.015 ± 0.012 |
| **Miasma**, default | 0.881 ± 0.004, 56 | 0.875 ± 0.005, 51 | −0.006 (−0.9 SE) | −0.005 ± 0.008 |
| **Wasting**, default | 0.658 ± 0.009, 44 | **0.684 ± 0.008**, 46 | **+0.027 (2.3 SE)** | +0.037 ± 0.018 |
| **the Thin Veil**, default | 0.887 ± 0.006, 52 | **0.908 ± 0.005**, 52 | **+0.021 (2.7 SE)** | +0.022 ± 0.010 |
| no modifier, untalented | 0.535 ± 0.031, 0 | 0.552 ± 0.029, 0 | +0.017 (0.4 SE) | +0.009 ± 0.027 |
| Bloodless, untalented | 0.226 ± 0.022 | 0.213 ± 0.022 | −0.013 (−0.4 SE) | −0.013 ± 0.008 |
| Miasma, untalented | 0.376 ± 0.026 | 0.372 ± 0.028 | −0.003 (−0.1 SE) | −0.015 ± 0.020 |
| Wasting, untalented | 0.231 ± 0.021 | 0.202 ± 0.018 | −0.028 (−1.0 SE) | −0.012 ± 0.014 |
| the Thin Veil, untalented | 0.330 ± 0.029 | 0.364 ± 0.031 | +0.033 (0.8 SE) | +0.015 ± 0.021 |

**Two moved past their noise, both default and both the arms where a hero drinks most** (the Veil's bodies cross the 35% line fastest,
Wasting's every turn): the Thin Veil crossed a grade (§1b) and Wasting stayed in the cliff. **Bloodless and Wasting are two of the cliff's
three, and the cliff held**: Bloodless 0.640, Wasting 0.684 against Mirrorbound's 0.706, Overgrown at 0.857. **Untalented nothing moved.**
**Which grades turn on statuses laid** (the brief's second case, unrepairable — the bot books 2.2× a player's status events): **Fleeting**,
by its door (every status applied lasts a turn less); recorded beside the grade table. The fidelity rule is in `docs/instrument-rules.md`
with its row.

## §3 — HOUSEKEEPING

**THE MOVE IS NOT ATTEMPTED** (IB §4). **At IP's close 602 folders, 262,952 KiB** (IO's close: 602, 271,388 — Godot rotates each folder's last five process logs, so the
reading falls between runs as well as rising). **IP made no folder — the ninth batch running.** It reused thirteen: II's three
(*II K*, *II R*, *II S*), five of IB's (*IB work*, *IB ctlA*, *IB ctlB*, *IB probe*, *IB recon*), IA's three (*IA probe*, *IA probe6*,
*IA trhead*) and IC's two (*IC ctlA*, *IC alone*, the pre-pass); they stay, named here (HO §5). **The spent prefixes** — every
*Dawn of Decay* copy from FX to IN, the thirteen among them, and the five *DoD …* copies — are **600 folders, 262,352 KiB** at the
close. **ONE command clears them**, leaving the live *Dawn of Decay* folder and `[unnamed project]` — IO's command, unchanged,
because IP made no folder its patterns miss:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IN)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-J]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IN)/"
```

Each pattern was listed at the close before it was written here — 470, 125 and 5 folders — and none reaches the live folder.
**IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from
the paste first. **And clearing them ends the reuse**: the next batch makes its lanes again.

**The archive takes the newest cut first**: IP's cut is at the top (`check_ip` §7),
IO's assertion kept (`check_io` §7's order arm untouched, its top arm re-pointed to *IO's own or a later batch's*). **The live folder's
`readout/`**: `latest.txt` and the two files, backed up with the player's files at 09:57 and **never touched**; the clean file's md5
`610bcd8c2b43f97703e63053e86728fa` at the open and `610bcd8c2b43f97703e63053e86728fa` at the close; **no newer file appeared.**

## §4 — WHAT IS DELIBERATELY NOT DONE

- **Nothing from the playthrough is built**: Rupture, Sanctity's target and cap, the vow's price, the Cleric's regen, Boil Over's
  availability, the Sharpshooter's share and the Berserker's Rage are recorded in `docs/state.md` and left (§0.1).
- **The middle of the deck is not authored**; **the Thin Veil keeps Feverish's rule**; **no band reaches a grade it does not, and no
  count moved but §1b's** (the measurement's cut).
- **The documents and the claims are the last two batches** — IQ and IR (`docs/state.md`'s roadmap). Both readings are below.
- **A stored offer naming a removed modifier is not repaired** (ruling 6). **The 321 weak picks stay listed** (§0.8).
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; the vow, the recoil floor and Anointing; the third slot
  ungated; the art; a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire's re-cut
  and `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the Occultist's Break card; the Skirmisher and the
  Tracker; Channel's tempo payout; the fallen-hero ruling; Tithe's read site; the block index.

## FOUND AT IP AND NOT FIXED

- **A stored offer naming a removed modifier would break the offer screen** — ruling 6.
- **The brief's *FV's 1.55* is II's brief's steps ratio** — premise 8.

## THE TWO READINGS

**`CLAUDE.md` is 483,594 B = 472.26 KiB against its 510 KiB ceiling — 37.74 KiB under** (+1,908 B at IP: the two-sidedness
rule, the cut's sentence and the two index rows): 4.7 batches at EZ's record (8,293 B), **19.8 at the mean of IL–IP** (1,951 B).
**`docs/state.md` is 370,043 B = 361.37 KiB against its 380 KiB ceiling — 18.63 KiB under** (+5,787 B at IP, its own reading
included: the playthrough's record, the grade table with its two limitations and IP's rulings, less the cut to the archive): 3.3
batches at IA's +5,860 B, the worst case; the honest rate is IL +5,587, IM −4,046, IN +1,476, IO +1,714, IP +5,787 — a mean of 2,104 B,
**9.1 batches at it**. **Both are comfortable at the honest rate** (above eight), and **neither is urgent** — but `docs/state.md`'s
fell from IO's 18.2 because IP's own growth entered the window: the documents batch (IQ) is the next, and its census is the one that
takes this file down. `docs/state.md`'s reading is a fixed point: the file's size is inside its own line, so the figures were filled and
the file re-measured until they agreed (`readings_ip.py`, re-run after the last edit to it).

## §9 — THE VERIFICATION

**THE PUSH CHECK AND THE BACKUP, FIRST.** `git ls-remote origin class-merge` read `9f9154d`, IO's HEAD and local HEAD, before
anything ran; the four player files and `readout/` were backed up to `../save-backups/IP-20261019-095709` before the first edit — the
player's files md5-identical to the live ones (`profile.json`, `run_save.bin` and the readout newer than IO's backup, as the
playthrough left them).

**THE SUPERLATIVE CENSUS RAN FIRST** — a reader over every battery target and both fixtures, the files that name the deck, its bands,
its rewards, the strip, the heal door or a sim road read whole, IO's census file the starting list (§0.10's rule: the patterns a
checklist, not the population): **52 picks whose population IP moves — 12 sites, 40 fillers; 14 in IO's census**, the five road gates'
bargain presses and `check_ih`'s longest-name pick new to it; and 41 pins on what IP moves (the reader census of §1a's deletion and
§1b's cut: `check_io`, `check_in`, `test_batch_an` and `test_batch_bb` red by name, the rest unmoved). **The potion moves no
battery pick** — `RunSim.active` is set by a sim run alone. **IO's test applied (§0.8): a pick is a site when its verdict depends on
the member.** **Driven on HEAD's tree and IP's, the two SITES whose pick moves name it in every FAIL line**: `check_gf` §3 takes
*'hoarfrost' paying gold* at HEAD and *'muffled' paying potion* at IP (index 0, the first not paying a merchant — Warden's re-cut
safe band deals another first card); `check_ih` §6's bargain strip is drawn at its longest name, *The Hungering Dark (18 characters)*
at HEAD and *The Long Silence (16)* at IP. Both gates read their rows on both trees (104, 98). **The fillers whose pick moves** — the
bargain presses of `check_gj` §1, `check_fh` §1, `check_gp` §4, `check_hk` §7 and `check_gv` §4, and `check_ih`'s card walk — are
fillers by the test (any bargain serves the road) and are listed, not repaired; their roads move, and recon 1 read what that moved.
**IP's own new code was read the same way**: `check_ip` picks the board's first hero and the warband's first body as fillers, and its
one site — §2's drinker — is the loop's pick, read off the log and named in its FAIL line.

**THE LITERAL SWEEPS RAN BEFORE EACH PREDICTION.** **Over the code and data** (before recon 1): 20 lost — every one a word of the Dark
or its door that `check_in`, `check_io`, `check_ip` or `test_batch_an` holds, but three held for another file (`check_ic`'s *drink* is
a dictionary key, `check_ij`'s *heal_amount* names a function in `unit.gd`, whose two needles stand); 6 gained (each a re-pointed
gate's own, or a common word another gate holds for another file); no short flip; 19 counts moved, each a count over a gate's own
slice or a bracket balance. **Over the documents** (before the acceptance's prediction, and again after the last edit to them):
21 lost — the
code names in `docs/state.md`'s rewritten WHERE block and IO's archived rulings, none held by a gate that opens it (`check_es`,
`check_fg`, `check_hp`, `check_hx` hold none of them: `check_es`'s *COLOR* is a piece of a code needle), and `master.html`'s *The
Hungering Dark*, an absence needle of `check_in`, `check_io` and `check_ip` — 57 gained (`check_ip`'s needles, the re-pointed gates'
own, or a common word another gate holds for another file), five short flips (*A5*, *B2* and *-40* moved into the archive with IO's
rulings: `check_in`'s census ids and `check_go`'s figure, neither read there) and 41 counts moved, each a count over a gate's own slice,
a bracket balance, or one of `check_ip`'s three headings going 0 → 1.

**`check_hf`, WHICH HOLDS THE DESIGNER's WORDS, WAS READ AGAINST §1's TEXTS**: it holds the fifteen no-engine runes' words and none
of the modifier texts, the glossary's severity, modifier or ladder entries, or `master.html`'s ladder; the two glossary sentences
IP changed and the Dark's removed text are read by `check_ip` and `check_io` alone.

**THE TWO MEASURED THINGS, EACH AGAINST THE UNCHANGED TREE.** **§2 first**: the five arms on both builds on HEAD's tree with the one
line of the potion changed (lanes cloned from it before §1's edits landed), against IO's figures on IO's tree, paired run by run on
the same seeds (10:02–10:22). **Then the tie block**, on the same tree (10:19–10:38). **Then §1b's cut**, built on both, and EP's
sample against IO's (the bands' measurement). The natural-play table (§1c) carries the third reading: H against P (the potion
alone) against F (the tree). **The two interact by construction** — the cut is built on the repaired instrument's figures — and
nothing else in IP meets a fight: §1a's removal moves no fight that does not carry the id.

**RECON 1 — HEAD's BATTERY ON IP's CODE AND DATA** (HEAD's runner, gates, documents, baselines and manifest; `check_ip` not in it;
*IB recon*), the prediction written before launch: **155 targets, 11:01:48 to 12:26:16 — 84 min 28 s**, most of it beside the controls and the traces. **As predicted**: `check_io`
103 / 5 and two SCRIPT ERRORs (the deck's size, the Dark's RECUT row, the stamp arm's string, §2's counts, §5's 46 strips; §1c and §1f
throwing at the deleted constant and row, so their arms did not run and the count fell below 126), `check_in` 81 / 3 and two SCRIPT
ERRORs (§1a's FOUR row and counts, §1e's 24 terms; §1g and §1i throwing), `test_batch_an` 6,056 / 2, `test_batch_bb` 167 / 1, the two
standing sanctioned reds (`check_cm_live` 13 / 5, its five lines; `check_gj` 70 / 1, **its figures moved as predicted**: *+175 gold and
the purse moved 195*, IO's +153 / 173 — the same 20-gold gap, its road dealt other bargains), the harness 22 / 382 / 8, `check_parse`
231, `check_gw` 76, `check_ed` 18, `check_dj` 45, `check_hu` 106, `check_ih` 98, `check_gf` 104, `check_fh` 167, `check_hk` 168,
`check_gv` 1,057; `check_de` 637 / 8 and one notice, every red one of these. **One reading the prediction named as possible**:
`check_gp` **439 against its 438 row** — a rise, `check_de`'s notice — **traced** (HEAD's gate, every `ok()` printed, on HEAD's code
and on IP's: 438 / 0 and 439 / 0, the only moved section §4, 59 → 60): its per-card arm asserts once for each distinct card the
no-engine road offers an engine-less hero, and IP's deck deals that road another bargain from its fifth on, so it meets other fights
and other drafts — 46 distinct cards offered before, 47 after. No arm stopped running. **The row moved 438 → 439 with its trace,
before anything was frozen** (IO's lesson: a recon row found late stops an acceptance).

**THE GATE-SOURCE READERS, OVER `check_ip`'s FINAL SOURCE — TWENTY-SEVEN, BY THE TWO ROUTES, AND NO THIRD.** `check_ij` §0.4 derives
them: the 26 that open the root (`check_ip` among them) and the three that read the battery's list (`check_gw`, `check_ij`,
`check_parse`). **A third route was looked for and is not there** — IO's
search stands (the variable-path walkers open `res://scripts`, `res://data` or a readout folder; `check_ed` and `check_fr` read the
manifest, regenerated; a gate that loads another gate by path reads a named file), and `check_ip` adds none. **Read after the last edit
to `check_ip`** (md5 `0f38e918…`, the frozen tree's), in a copy of the final tree, with the document gates and the gates that read what
§1 touched: **all at their rows, no parse or script error** — `check_ip` 48 / 0, `check_parse` 232 / 0, `check_ij` 49 / 0, `check_ed`
18 / 0 (the manifest regenerated, its last regeneration byte-identical to the one before it), `check_gw` 76 / 0 with *96 sites in 10
targets (ceiling 96)* unmoved (`check_ip` writes none of its fields), `check_hx` 39, `check_ea` 396, `check_da` 41, `check_ek` 47,
`check_es` 57, `check_hp` 171, `check_ik` 251, `check_io` 119, `check_in` 91, `test_batch_cd` 92; the document gates at their rows
(`check_fg` 30, `check_fr` 25, `test_batch_bx` 163, `test_batch_ce` 931, `check_dv` 84, `check_hy` 185), `test_batch_an` 6,053 inside
its band, `test_batch_bb` 167, `check_hu` 106, `check_ih` 98, `check_hf` 314, `check_gp` 439.

**EVERY MOVED COUNT, ATTRIBUTED BY AN `ok()` TRACE** — HEAD's gate on HEAD's code and IP's on IP's, every assertion printed with its
verdict, the two lists diffed: **`check_io` 126 → 119** — §1c 12 → 8 (the four arms that fed both sides, the tick and Caught Fast arms
and the rider pair became two dealers fed nothing, the id read as no modifier, IO's positive arm on an ordinary heal kept, the door
and the heal door), §1f 14 → 12 (the Dark's figure and pronoun arms and its both-sides arm out, its `master.html` row's absence in),
§1h 3 → 2 (the deleted door's arm, which had passed on its empty body); §1a's count unmoved (one more removed, one fewer re-cut).
**`check_in` 94 → 91** — §1g 7 → 6, §1i 10 → 8 (the Dark's text arms). **`check_parse` 231 → 232** (one target more), **`check_de`
637 → 641** (four checks for it), **`check_ip` new (48)**. **`check_gp` 438 → 439** (recon 1, traced above). **Every other count is unmoved** — `test_batch_an` and
`test_batch_bb` re-pointed in place, each arm replacing the arm it repaired.

**THE CONTROLS — 15 on what IP built, two re-tunes, two HEAD arms**, each a fresh copy of the tree with one change and the gates it aims
at (`controls_ip.py`, every anchor count-asserted and every one dry-run first), each read by its FAIL text, four lanes at once.
**IN §0.7's note binds them**: each breaks the door the gate's own predicate drives — the deck the stale id is read against, the door a
blow feeds through, the heal door's parameters, the drink's figure — never a body the gate named.

| | the defect | what reds |
|---|---|---|
| C01 | the Dark's row and constant back, no door (disabled, not removed) | `check_ip` 48 / 6 — the row, the constant, the words, *a save's stale `hungering_dark` is read as the modifier in force*, *the deck holds 24*, the counts; `check_io` 119 / 6; `check_in` 91 / 3; `test_batch_an` 3; `test_batch_bb` 1 |
| C02 | the Dark's feed back at BL's door, reading a save's id rather than the deck | `check_ip` 48 / 3 — the words, the door, *Warden … dealing 200 to Orc Raider … was fed 100*; `check_io` 119 / 4 (both dealers fed); `check_in` 91 / 3 (both dealers fed) |
| C03 | the heal door's third parameter back, unused | `check_ip` 48 / 2 — *not the two-parameter door*, *still names the `unowned` door*; `check_io` 119 / 1; `check_in` 91 / 1 |
| C04 | the fight reads a save's id without asking the deck | `check_ip` 48 / 1 and `check_io` 119 / 1 — *read as the modifier in force ('hungering_dark')* |
| C05 | the bot's flat 40 back | `check_ip` 48 / 2 — *Pyromancer (the first hero whose turn opened below the line — the loop's pick) drank 40 — want 200*, and the source |
| C06 | the player's figure typed inline at the drink (right today, a second copy) | `check_ip` 48 / 1 — the source arm alone; the drive passes, as it must |
| C08 | the counts broken (Mirrorbound 5 → 4, its row with it) | `check_ip` 48 / 4 — the counts, *Ruin's gamble band … holds ["bloodless", "wasting"]*, the fixed band nine, *the ladder does not say 'two bargains …'*; `check_io` 119 / 1; `check_in` 91 / 1; `test_batch_bb` 2 |
| C09 | a severity-5 modifier reaches Warden | `check_ip` 48 / 3 — *warden's bands reach …*, *warden dealt 348 severity-5 options*, its sample against IO's; `check_io` 119 / 4; `check_in` 91 / 4 |
| C10 | the fixed encounters reach severity 5 | `check_ip` 48 / 1 — *the fixed band [3, 5] holds 11*; `check_io` 119 / 1; `check_in` 91 / 2 |
| C11 | `master.html`'s ladder types the old count | `check_ip` 48 / 1 — *does not say 'three bargains no other rung deals'* |
| C12 | the glossary types a count no constant holds | `check_ip` 48 / 1 — *severity: types 'three'* |
| C13 | the Dark's record loses IO's figures | `check_ip` 48 / 1 — *the newest entry does not carry the Dark's shape and IO's figures* |
| C14 | the two-sidedness rule written into the instrument rules too | `check_ip` 48 / 1 — *stands in the instrument rules too*; `check_hx` 39 / 2 — a run of twelve words and a rule statement in two rule files |
| C15 | the tie rule's heading renamed | `check_ip` 48 / 1; `check_hx` 39 / 2 — its row names no block, and a block no row points at |
| C16 | IP's cut at the archive's foot | `check_ip` 48 / 1 — *the archive's first cut is IO*; `check_io` 119 / 1 — *not newest first: ["IP after HX"]* |
| R01 | **re-grade**: Hoarfrost 1 ↔ Slick Footing 2, the counts kept, `master.html`'s two rows moved with them | **every one of sixteen grade readers green** — `check_ip` 48, `check_io` 119, `check_in` 91, `check_im` 122, `check_il` 86, `check_hw` 65, `check_hs` 83, `check_ih` 98, `check_hu` 106, `test_batch_an` 6,046, `test_batch_bb` 167, `test_batch_bn` 80, `check_ij` 49, `check_fh` 167, `check_gf` 104, and `check_gj` 70 / 1, its sanctioned red (*+175 gold and the purse moved 195*, its road re-dealt) |
| R02 | **re-tune**: the potion's figure 20% → 25% | `check_ip` 48 / 0 (the drink follows the function); `check_ct` 114 / 2 — CT's own pin of the 20% figure, by design |
| H01 | HEAD's `scripts/` and `data/` under IP's gates | `check_ip` 48 / 17 (every arm of §1a, §1b's counts and words, §2's drive and source), `check_io` 119 / 11, `check_in` 91 / 6, `test_batch_an` 2, `test_batch_bb` 1 — **every gate IP re-pointed reds on HEAD's code by what it re-pointed** |
| H02 | HEAD's documents under IP's gates | `check_ip` 48 / 7 (the ladder's count, the four rules, the Dark's record, the archive's top), `check_io` 119 / 2 (the rows at the new grades, the Dark's row), `check_in` 91 / 1; `check_hx` green |

**THE LANES, AND ONE SLIP THAT WAS CAUGHT.** Every measurement, control and trace ran in a scratch copy that reused a spent user-data
folder (IP made none). **Three trace copies restored HEAD's tracked files with `git checkout HEAD -- .`, which put back
`project.godot`'s live name**, so their first trace runs — `check_gf` and `check_ih` twice, `check_io` and `check_in` once — ran in the
player's own folder, two at once, and read failures neither tree has (two processes on one save). **The player's four files and the
readout were md5-identical to the backup when it was found, their mtimes untouched** (each gate reads the harness's save path and
restores what it found, §9 of each); the three copies were renamed back and every trace run again in its own folder, all green. The
figures above are the clean runs'.

**THE ACCEPTANCE**, on the frozen tree, in the repo, every row of `ps` logged every 15 s, **the pre-pass beside it in a fresh copy**,
each predicted before launch: **156 targets each — the acceptance 12:39:32 to 14:06:53, 87 min 21 s; the pre-pass (*IC alone*) 12:39:32 to 14:07:00, 87 min 28 s**
(IO: 155 in 86 min 6 s). **Both read `check_de` 641 / 0 / 0**, as predicted, every target at its row to the check — `check_ip` 48,
`check_io` 119, `check_in` 91, `check_parse` 232, `check_gp` 439, `check_im` 122, `check_hu` 106, `check_ih` 98, `check_gf` 104,
`check_hf` 314, `check_gw` 76 (*96 sites in 10 targets (ceiling 96)*), `check_ed` 18, `check_dj` 45, `check_hx` 39, `check_ij` 49,
`test_batch_bb` 167, the two banded suites inside their bands (`test_batch_an` 6,052 and 6,056, `test_batch_bk` 131 and 131), and the
two runs identical row for row but `test_batch_an` — the two standing sanctioned reds to the character in both runs (`check_cm_live`
13 / 5, inside its 4–5 band, the owed bar's five lines; `check_gj` 70 / 1, *the card says +175 gold and the purse moved 195*), the harness 22 / 382 / 8.
**Stderr was grepped for `Parse Error` and `SCRIPT ERROR` over both runs' 312 logs: none.** **The tree did not move**: 557 files
md5'd before and after, identical. **The player's files did not move**: md5-identical before and after, and to IP's backup. **Every
row of `ps` was read** — 349 samples, 12:39:32 to 14:06:51, 667 Godot rows: 665 a headless battery target of the two runs, and two
rows reading `(Godot)`, two seconds old, at 13:04:53 — one per run, each run's `check_cl_width` at its exit (its log written that
second, `check_cm`'s by 13:04:55): `ps` drops an exiting process's arguments. No game window and no stray process.
