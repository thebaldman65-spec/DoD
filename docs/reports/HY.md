# BATCH HY — THE ATTRIBUTION FRAME, AND THE CEILING MOVES

**On `class-merge`, from `d3773d3` (HX). IMPLEMENT ONLY.** **§0: HX's four rulings are taken.** **§1: the attribution frame
is put back** — the five callbacks save the frame, set their own and restore it (Forge Body's shape), and so does the Killing
Cold's bite, which HY's re-derived census found doing the same thing at a cast's own line; the frameless turn-start sites —
Snare Line's spring (now its own function), an armed Deadfall's, a Ruin detonation — carry their owner's frame, and so does a
bomb, the fourth frameless site the census found (its owner is nobody: it credits no hero); and GO's and HF's items are the same
repair, taken — a Tripwire, a Feint's return, a Mirror Guard return and Consecrated Ground's reflect (its layer's), with Spite
and the Whole Forest's bite, two more of their shape the census found, deal under their owner's frame inside the enemy's swing. **`check_hy`, new, is HX's drive built for real**,
with a census of every function that deals damage — whose restore test its own control found file-wide, repaired before the
pre-pass. **§2: `CLAUDE.md`'s ceiling is 510 KiB** — EE's method on today's floor gives
518.18, rounded down to HV's 510 — and HN §1's ruling is recorded as superseded, not deleted. **§3: `docs/state.md`'s ceiling is
380 KiB**, a sentence in its preamble that `check_fg` §4 reads. **§4: HG–HJ's two blocks moved to the reference, byte for byte,
and the doctrine was read off twenty batches' practice.** **§5: the four two-file passages stay — `check_hx` §1b reads four.**
**§6: two rules — the per-batch re-read, and a live count points at its instrument — and 31 of the 87 standing stale claims are
counts.**

**VERDICT: LANDED.** The frame is put back at all sixteen sites — HX's five callbacks and three frameless sites, the two HY's
census added (the Killing Cold's bite and the bomb), and six retaliations inside an enemy's swing — GO's three and HF's reflect,
and Spite and the Whole Forest's bite — and `check_hy` drives every one: 161 / 0 on HY's code, 161 / 69 on HEAD's. HEAD's whole
battery read the repaired code at HX's readings. Both ceilings moved by ruling (510 KiB and 380 KiB), the two blocks moved byte
for byte, the doctrine was read off twenty batches (26 to 3: HG's stands, DG §2's exception struck), and the two claims rules
are written. The pre-pass and the acceptance run read `check_de` 573 / 0 / 0, and the final tree's readers each read their
acceptance reading. **Three rulings owed, all player-visible, none blocking — each is one line if it goes the other way.**

## NEEDS A RULING

1. **THE VOW'S CARRIED HALF — THE VOW'S OWN PRICE, OR THE ENEMY'S WOUND ON A SECOND BODY (§1a).** Built as the brief prescribed
   (Forge Body's shape for all five): the share the Devout carries is billed under his own frame, as it has been since BO — his
   taken ledger books it *themself / Vow of Suffering*, and **Penance's mirror pays on the part of the blow the struck ally kept**
   (4–6 a blow at power 50 in the drive), not on the whole blow (8–11 in the drive's arms with no share; HX's control read 9–11). The other reading is Covenant's shape — the carried half
   is the enemy's wound landing on a second body: the mirror would pay on the whole blow, the Devout's ledger would book the raider, and
   a Devout bound by a Covenant would share it. `docs/master.html`'s Penance row (*50% of the damage it deals, whoever it hits*)
   reads closer to the second. **Keep it, or bill the carried half under the dealer's frame** (one line: the share keeps the
   frame it found).
2. **A BOMB'S FRAME NAMES NOBODY (§1b).** It credits no hero's dealt ledger and never has, so the frame agrees with the ledger:
   no vow blanks it and no Penance, rule engine or Reaver reads it. **The other reading** is the hero whose turn it is: his own
   Vow of Silence would blank his bomb, and his Siphon, Judgment, marks and Reaver would be paid off it. Keep it, or name the
   thrower.
3. **CONSECRATED GROUND'S REFLECT IS ITS LAYER'S (§1c).** Read off the status's `src_name` (DI's rule: a status's effect is its
   applier's), so a Cleric wearing Vow of Silence silences his own ground's reflect on whoever stands on it — HF's item, closed.
   **The other reading** is the struck hero's: a teammate on a vowed Cleric's ground would keep his reflect. Keep it, or read
   the struck hero.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HX | **Held**: HEAD `d3773d3` = `git ls-remote origin class-merge` (`d3773d3b6e007a1e5c8f5103421c0a389fcfa020`), read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | §0.1: 460 KiB *"sits above the 455.8 KiB the file stood at"* | **Held**: HW's close 466,775 B = 455.83 KiB (`git cat-file -s d7c0a98:docs/state.md`) |
| 3 | §1: three blows read *26, 27, 24 → 0, 0, 0*; the spring *15 after an enemy's Slash and 0 after the Devout's Smite* | **Held as HX's figures** (HX §4b, §4c) |
| 4 | §1a: the five callbacks *each set `_dmg_frame` and never put it back*; Forge Body's shape is *already used by the ward, Frostbind, Penance and `_book_self_cost`* | **Held, each at its line** (and `_on_blight_heal` sets it inside `heal_amount`, as HX said). *About three lines a site*: four — three saves and the restore |
| 5 | §1a: *`_on_vow_share` is the one that fires on EVERY blow* | **Held**: `unit.take_hit`'s vow block, every blow over 1 on a vowed ally |
| 6 | §1b: *derive the census again — a site added since, or one it missed, is the same defect* | **Derived: 74 sites in 30 functions in `battle.gd`, HX's own figure, and One Soul's split in `unit.gd` — 75 in 31.** No site was added since. **It found two HX did not name**: the BOMB (`_use_item`, thrown on a hero's turn before any action — a fourth frameless site) and the KILLING COLD (`_killing_cold_cast`, at a cast's own line — a sixth site that borrows the frame and never puts it back) |
| 7 | §1c: GO's and HF's items — *a Tripwire, a Feint reflect and a Mirror Guard return*; *the reflect slips past the vow* | **Held**, and the census of retaliations inside an enemy's swing found two more of the shape — **Spite and the Whole Forest's bite**, each behind a field no node or rune writes since FX (`spite_ranks`, `whole_forest`) |
| 8 | §1d: *all four arms read the control's figures* | **Not as figures, and under §1a's prescribed shape they cannot**: the share moves half the blow onto the Devout under his own frame, so the mirror pays on what the Warden keeps; and the reflect is its layer's (§1c), so the vowed Devout's own ground reflects nothing. **What every arm reads is the control's FUNCTION of its own blow** — the mirror on what the Warden kept, the wire on the whole blow, the reflect unless its layer wears the vow — asserted per blow by `check_hy` §1 (the table, §1d) |
| 9 | §1d: *the spring reads about 15 whatever the last action was* | **Held in substance**: one roll reads the same in all three arms — 19 at the gate's seed (HX's 15 was another roll) |
| 10 | §1d: *the Penance mirror is 9–11 a blow at power 50 and was lost on every blow that paid the share — report it restored* | **Restored on every blow — at 4–6, half the blow**: the mirror pays on what the struck Warden kept; the Devout's carried half is the vow's own price (ruling 1) |
| 11 | §2: *the read fell 124,894 B — 890.84 KiB to 768.87 KiB, −13.7% — and `docs/state.md` is 108 KB under* | **Held** (HX §2d) |
| 12 | §2: *HX left it at 447,684 B* | **Held** (`git cat-file -s d3773d3:CLAUDE.md`) |
| 13 | §2: *ten of the largest single-batch growth on record* | **Re-measured**: EZ's +8,293 B over EE's window — the 106 batch commits DK to HX — standing through the 74 batches since |
| 14 | §2: *HV priced it at 510 KiB* | **Held** (HV's ruling 1, archived at HX: *a fourth re-derivation: 510 KiB*); today's floor gives 518.18, and 510 stands |
| 15 | §3: HO–HW's mean *+5,528 B* and ES's *+13,700 B* | **Held, re-measured from git**: +5,528.4 B over the nine; ES's +13,700 B the record over 134 commits |
| 16 | §4: the two blocks, *1,503 B and 5,650 B, 7,153 B* | **Held to the byte** |
| 17 | §4: *7,153 B … leave the rules file, which §1c of HX's gate checks both ways* | **Half**: §1c red on a block written IN; a block that LEFT printed nothing, though its header and HX §1c said a gone block prints a notice. **Repaired** (a notice, never a red) |
| 18 | §5: *`check_hx` §1b holds them at four* | **Held**: 13 shared runs and 6 shared statements, every one known — the four passages among them; no fifth |
| 19 | §6: *counts rotting at 29% against values at 4% — a sevenfold difference* | **Held**: 31 of 106 (29.2%) against 3 of 75 (4.0%), 7.3 times |
| 20 | §7: *the current good case is 84 for 40 Rage* | **Held** (HW §1a: with the Berserker's core the blow took 84) |
| 21 | §7: *`last_rites` pays damage from Rage below 25% health* | **Held**: `unit.take_hit`'s Last Rites block; the field is written by a LIVE tier-3 node, *Pay a Lethal Hit out of Your Resource Pool* (`tn_resource_ward`, `talents.gd`); the Last Rites RUNE is retired (ET §1) |
| 22 | §8: *HX's is the last* backup | **Held**: `../save-backups/HX-20261008-181721`, and all four player files byte-identical to it — md5, size and modification time — so nothing was played since HX |
| 23 | §8: *CLEAR HX'S COPIES by its prefix* | **Held**: eight folders, 1,048 KiB — HX's own count |
| 24 | §8: *HX read 138 targets in 75 min 26 s* | **Held** (HX's pre-pass); not taken as a runtime |
| 25 | §8: *§1 touches `take_hit`, `heal_amount` and the turn loop* | **The turn loop, yes** (Snare Line's block became `_snare_line_tick`); **`take_hit` and `heal_amount` did not move** — `unit.gd` is unchanged: the five callbacks they call live in `battle.gd` |
| 26 | §8's file list: *`master.html` … and the stamp* | **The stamp**: player-visible behaviour moved (§1), and `docs/master.html`'s text already describes what the repair restores (the vow silences only its wearer's damage; a retaliation, a spring and a bomb land; the Reaver and the Arbiter count damage by who dealt it) |

## §0 — HX's FOUR RULINGS, TAKEN

1. **`docs/state.md`'s ceiling is 380 KiB, not EE's 460** — *an alarm set above the failure level is not an alarm.* Built at §3.
2. **HG–HJ's two written-back blocks move to the reference, and the doctrine is settled by reading the practice.** Built at §4.
3. **The four two-file passages stay, named.** §5.
4. **The claims audit is the per-batch re-read, and the references are held to HO §0's rule for counts.** Written at §6.

## §1 — THE ATTRIBUTION FRAME, PUT BACK

Since HF the frame is not bookkeeping: Vow of Silence refuses what it credits to a vowed hero, Penance bills the dealer it names,
the rule engines pay and mark off it, the Reaver counts kills by it, and the recap books by it. HX §4 drove it wrong in two
shapes. **HY repairs both, and the census that found the sites is a gate now** (`check_hy` §6). The rule is written where a
fight's rules live — `docs/combat-rules.md`'s recap-ledger block, *THE FRAME NAMES WHOEVER THE SITE CREDITS, AND ONLY WHILE IT
DEALS*, in two halves: **a site that borrows the frame inside another unit's action puts back the one it found; a site outside
every action sets its own.**

### §1a — THE FIVE CALLBACKS, AND A SIXTH BORROWER THE CENSUS FOUND

Each of `_on_rite_return`, `_on_vow_share`, `_on_bloodbond_guard`, `_on_brunt_guard` and `_on_blight_heal` saves the three
fields of the frame, sets its own, deals, and puts back the frame it found — Forge Body's shape, which the ward, Frostbind,
Penance and `_book_self_cost` already used. **Four lines a site, not the brief's three**: three saves and the restore. Blight the
Well restores after its death handling, so a kill it makes is the Occultist's.

**The census found a sixth borrower HX's list did not name: the Killing Cold's bite** (`_killing_cold_cast`, a cast's own line,
before its strike). It set the rune's frame and left it, so the cast's own strike was booked under *Rune: the Killing Cold*
— and the Weaver's tally, which keys on the caster AND the cast's label, never saw the strike it exists to repeat. It saves and
restores now, after its death handling. **Driven** (`check_hy` §4): the Cryomancer's ledger books 30 under the rune and 29 under
*Magic Bolt*, and the Weaver repeats the cast.

### §1b — THE FRAMELESS SITES, AND THE FOURTH

- **Snare Line's spring is a function now, `_snare_line_tick(u)`**, called where the block stood in the turn loop, so a gate can
  call it as the loop calls it; its first line is `test_batch_bo`'s pinned `if` unchanged. It deals under the frame of the
  Hunter who laid the line (the status's power is his slot), under Snare Line's own label, and puts the frame back.
- **An armed Deadfall's spring** (`_deadfall_tick`) deals under the arming Hunter's frame, as *Deadfall*.
- **A Ruin detonation** (`_detonate_ruin`) deals under the Occultist's frame, as *Ruin* — so his own Vow of Silence silences it
  whoever acted last, where at HEAD it leaked past the vow whenever an enemy had acted last.
- **The bomb — the fourth frameless site, which the census found** (`_use_item`): thrown on a hero's turn before any action, it
  dealt under whatever the last action left, so a bomb thrown after the vowed Devout's Smite was blanked by his vow. **Its frame
  names nobody**: it credits no hero's dealt ledger and never has, so a frame naming the thrower would hand his vow, his Siphon
  and his Reaver a bomb nothing else credits him with (ruling 2).

### §1c — GO's AND HF's ITEMS, TAKEN: THE RETALIATIONS ARE THEIR OWNERS'

A retaliation is dealt inside the enemy's swing, so at HEAD it took the enemy's frame: self-inflicted by identity, so the
Reaver counted no kill, the Arbiter judged nobody and no mark was laid — and a reflect off a vowed
Cleric's ground slipped past his vow. **Six sites, each now saving the swing's frame, dealing under its owner's and restoring
the swing's after its death handling**:

| site | where | the owner's frame |
|---|---|---|
| the Tripwire | `_resolve` | the trapper |
| a Feint's return | `_resolve` | the struck hero |
| Consecrated Ground's reflect | `_resolve` | **the ground's LAYER**, read off the status's `src_name` (DI's rule; ruling 3) |
| Spite | `_resolve` | the struck hero — **dormant**: `spite_ranks` has had no writer since FX |
| a Mirror Guard return | `_mirror_guard_return` | the struck hero, under the rune's own name |
| the Whole Forest's bite | `_forest_bite` | the trapper — **dormant**: `whole_forest` has had no writer since FX |

GO measured 7 of 74 kills filed to an enemy's frame in a party with no lineage; that filing is what moved.

### §1d — `check_hy`: HX's DRIVE, BUILT FOR REAL

**The party** is the brief's — Warden, Pyromancer, Devout, Survivalist — seated by the deterministic fixture (Block and crit
zeroed) with the dice seeded. **The board**: Consecrated Ground laid on the Warden by the Devout, the Survivalist's Tripwire up,
Penance on the Orc Raider from the Pyromancer at power 50, Vow of Suffering in the Devout's kit. **The raider's own `_resolve`
Slash, three blows an arm; the share and the Devout's Vow of Silence each on and off — four arms.** The springs are called as the
turn loop calls them, after a real action. Every blow, `check_hy` §1 asserts **the frame after the swing is the raider's Slash**,
and that the raider loses exactly the mirror, the wire and the reflect the control's function gives for that blow:

| arm | blow 1 | blow 2 | blow 3 |
|---|---|---|---|
| A0 — no share, the Devout vowed | 16 + 0 → 20 (8 / 12 / 0) | 22 + 0 → 27 (11 / 16 / 0) | 17 + 0 → 21 (9 / 12 / 0) |
| A1 — the share, the Devout vowed | 8 + 8 → 16 (4 / 12 / 0) | 10 + 10 → 20 (5 / 15 / 0) | 10 + 9 → 19 (5 / 14 / 0) |
| A2 — the share, no vow | 8 + 8 → 18 (4 / 12 / 2) | 9 + 9 → 20 (5 / 13 / 2) | 11 + 10 → 23 (6 / 15 / 2) |
| A3 — no share, no vow | 16 + 0 → 22 (8 / 12 / 2) | 18 + 0 → 24 (9 / 13 / 2) | 19 + 0 → 26 (10 / 14 / 2) |

*The Warden's loss + the Devout's carried share → the raider's loss (Penance's mirror / the Tripwire / the reflect).*

**THE FOUR ARMS READ WHAT THE CONTROL READ — AS A FUNCTION, NOT AS FIGURES (premise 8).** Under §1a's prescribed shape they
cannot read the control's figures: the share moves half the blow onto the Devout under his own frame, so **the mirror pays on
what the Warden kept** — 4–6 a blow, half the blow, where the no-share arms read 8–11 — and the reflect is the ground's layer's,
so the vowed Devout's own ground reflects nothing whether or not the share fires. **What every arm reads is the control's
function of its own blow**: the mirror on what the Warden kept, the wire on the whole blow, the reflect unless its layer wears
the vow. That is asserted, blow by blow, as an equality, and **the vow's carried half is ruling 1**.

**HEAD's code under the same drive (H01, §8d) reads 161 / 69, red at every site, and its §1 is HX's finding with the figures
under it.** With the share and the Devout's vow (A1) the raider lost **0, 0, 0**: the share left the Devout's frame on the rest of
the swing, so his vow blanked the Survivalist's wire, and the mirror, reading the Devout as the dealer, paid nothing. With the
share and no vow (A2) the wire landed but was booked under *Vow of Suffering*, and the mirror still paid nothing (14, 17, 17).
With no share (A0, A3) the wire landed booked under the raider's own *Slash* — self-inflicted by identity, GO's item — and in A0
the vowed Devout's own ground reflected 2 a blow past his vow, HF's item.

**EVERY READER OF THE FRAME, BEFORE AND AFTER** — before is HEAD's `battle.gd` under the same drives (H01, §8d, and the readers
probe), after is HY's:

| reader | before (HEAD's code) | after (HY's) |
|---|---|---|
| **Vow of Silence** (`_deal_gate`) | A1, every blow: the raider lost **0** — the wire and the mirror read as the Devout's and were silenced or lost; A0: the vowed Devout's own ground still reflected 2 a blow (HF's leak) | A1: the wire lands (12–15 a blow) and the mirror pays; the reflect is silenced by its own layer's vow in A0 and A1, and lands (2) without it |
| **the springs** (`_snare_line_tick`, `_deadfall_tick`) | Snare Line's spring is no function a gate can call as the loop does; the Deadfall dealt **0** after the vowed Devout's Smite and 20 after the raider's Slash or an unvowed Smite, booked 0 under its name | Snare Line **19** and the Deadfall **20** after every last action — one roll, booked under their own names, the frame put back |
| **a Ruin detonation** | the vowed Occultist's detonation after an enemy's Slash took **98** — his vow could not see it — and booked 0 under Ruin | **0** after an enemy's Slash and after his own cast (his vow silences his own damage whoever acted last); no vow, **85**, booked under Ruin |
| **a bomb** | 50 on **0 of 3** enemies after the vowed Devout's Smite | 50 on **3 of 3**; no ledger moved |
| **Penance's mirror** | A1, A2: **0** on every blow the share paid | **4–6** a blow on what the Warden kept; 8–11 with no share, as before |
| **the Weaver's tally** | the Killing Cold's frame kept the cast's strike: **0** booked under *Magic Bolt*, and the repeat never fired | 29 under *Magic Bolt*, 30 under the rune, and the Weaver repeats the cast |
| **Siphon** (the Leech; readers probe) | A1, A2: **0** Mana back on every blow — the mirror it reads was lost | **1–2** back a blow off the mirror; 3 with no share, as before |
| **Judgment** (the Arbiter) | Consecrated Ground's reflect: **not judged** | judged, by the Cleric who laid the ground |
| **the marks** (the Tracker) | the Tripwire and the Whole Forest's bite: **no mark** | the raider tracked by the Survivalist |
| **the Reaver's kill credit** | a kill by Feint's return, a Mirror Guard return or Spite: **0** | **1** each |
| **the recap's dealt ledger** | the Survivalist's wire booked under *Slash* (A0, A3) or *Vow of Suffering* (A1, A2) — in A1 booked as dealt (40) while the vow had blanked every point of it | under *Tripwire*, and what it books is what landed |
| **the recap's taken ledger and kill record** | A1, A2: the Warden's wounds booked *Devout / Vow of Suffering* | *Orc Raider / Slash*; the Devout's carried share *themself / Vow of Suffering* (ruling 1) |
| **Covenant's share** (readers probe) | a second wound on the Devout inside the same raider action, once the share had fired: read as his own price — he took **30** and his partner **0** | he takes 15 and his partner carries **15** |
| **the other four callbacks** | the frame left on the payer: *Holy / Rite of Return*, *Beastmaster / Bloodbond*, *Canis / Answering Pack*, *Occultist / Blight the Well* | the raider's Slash again (the mender's rite after Blight the Well) |

### §1e — THE CENSUS, HELD

**Every function of the game that deals damage — 31, at 75 sites — is a known one in `check_hy`'s table, with the frame it deals
under**: 74 sites in 30 functions of `battle.gd`, HX's own figure re-derived, and `unit.take_hit`'s One Soul split. Eleven
BORROW (the five callbacks, the Killing Cold, Forge Body, the ward's detonation, the Mirror Guard return, the Whole Forest's bite
and the damage door's two mirrors), four set their OWN (the DoT pass, the bomb, the detonation, Burning Ground's tick), eleven
deal inside their dealer's own ACTION, two deal Break and no health, two are the DEALER's by design (the Covenant share, One
Soul) and one, `_spring_trap`, is a CALLER whose three callers frame it. **§6 asserts the shape off the source, comments
stripped**: a function not on the table that calls the damage door reds until its frame is said; every borrower's saves are
read back by the restore in its own body (21 borrowed frames; function by function since control C19, §8d); every OWN site sets a frame before it deals; every trap caller frames the spring.
**What it cannot see is whether the owner it names is the right one** — that is the drives' work, and they reach the sites above.

## §2 — `CLAUDE.md`'S CEILING IS 510 KiB, OVER HN §1's OWN RULING

**Derived by EE's method, on its fifth run.** The floor is HX's close, read at HY before it wrote a byte: **447,684 B =
437.19 KiB**. The headroom is ten of the largest single-batch growth on record, re-measured over EE's window — the 106 batch
commits from DK to HX — and it is still **EZ's +8,293 B (8.10 KiB)**, standing through the 74 batches since it: ten are
80.99 KiB. **437.19 + 80.99 = 518.18, stated as 510 and rounded down**, which discards 8.18 and carries 9.0 worst batches.
**510 stands**: HV priced it on HU's floor, HX's trim moved the floor, and the rounding still lands there.

**HN §1's ruling is recorded as SUPERSEDED beside its reversal, never deleted.** HN's objection — a re-derivation grows what
every batch reads, so a ceiling that only rises measures nothing — still stands as the reason a ceiling exists; HX's trim
answered it by measurement, and that is what the record now says, where the ruling stood.

**THE ROOM IS FINITE, SAID PLAINLY.** The two files at their two ceilings — `CLAUDE.md` at 510 KiB, `docs/state.md` at 380 KiB —
are a read of **911,360 B: 857 B under the read at HW's close** (912,217 B: `docs/state.md` 466,775 B and `CLAUDE.md` 445,442 B),
the read the trim was taken to relieve. **The whole of the trim's relief is spent the day both files reach their ceilings**; when
it is, the re-measure decides the shape, not a sixth run of this arithmetic. `CLAUDE.md` closes HY at **442,894 B = 432.51 KiB**
(−4,790 B: the two blocks' 7,153 B left, HY's own writing put 2,363 B back), **77.49 KiB under 510: about 9.6 batches at the
record and 19.5 at HO–HX's mean of +4,077 B**.

## §3 — `docs/state.md`'S CEILING IS 380 KiB

**A sentence in the file's preamble** — *AND THIS FILE'S CEILING IS 380 KiB — AN ALARM ON THE CLOSING PRACTICE ABOVE, NOT A BAR
THE FILE IS SPLIT AT* — with the closing practice beside the number: what a batch closes goes to the archive; **reaching the
number means the practice has failed, and the answer is to archive what is closed, never to split this file.** The number is
ten batches of the file's mean growth over HO–HW (+5,528 B) above HX's close (339,639 B) — 394,923 B = 385.67 KiB — rounded down.

**`check_fg` §4 reads it, `check_fg`'s shape**: the ceiling and the record growth (ES's +13,700 B = +13.38 KiB) parsed out of the
sentence itself, never held in the gate; over the ceiling a printed WARNING, past it by more than one batch at the record a
failure. **It reads the file whitespace-flattened**: the file is rewritten and reflowed every batch, and on its first run a
needle wrapped across a line break hid from it. Eight arms, `check_fg` 22 → 30.

**At HY's close `docs/state.md` is 337,425 B = 329.52 KiB — 50.48 KiB under 380: about 9.4 batches at HO–HW's +5,528 B, and
3.8 at ES's +13,700 B** — measured on the file as committed. **HY took it 2,214 B below HX's close**: what HY closed went to the
archive (8,676 B — HX's four rulings, the frame item, HF's reflect and GO's item, Boil Over's ruling and the roadmap's done line),
and HY's own sections and the ceiling's sentence came in. The practice held for one more batch; the number is what says the
day it stops.

## §4 — THE TWO BLOCKS MOVED, AND THE DOCTRINE READ OFF THE PRACTICE

**Moved byte for byte**: *RE-VERIFYING A CENSUS ENTRY MEANS DIFFING WHAT FEEDS THE ARM, NOT THE ARM'S OWN LINE* (HG §1b, 1,503 B)
and *A SUPERSESSION IS A CLAIM, AND IT IS DRIVEN LIKE ONE* (HG §2a with HH's, HI's and HJ's bullets, 5,650 B) — 7,153 B out of
`CLAUDE.md`, appended to `docs/instrument-rules.md` unchanged, each with its index row; `check_hx` §1c's known population lost
their keys, and §1c now prints a notice for a known block that has gone (its header said it did, and it did not — premise 17).

**THE DOCTRINE, READ OFF HD TO HX.** The two texts disagreed about a check whose subject was deleted: DG §2 deletes it, with the
fall predicted and a note where it stood; HG §2a retires it onto the fact that deleted it and keeps it. Four read-only readers
classified every gate or suite arm the twenty batches edited whose subject had been deleted — **R**: retired onto the fact
(**R+** with a record line printed beside it), **D+**: deleted with the fall predicted and a note at the site, **D−**: deleted
without, **X**: a hybrid or a re-point. Excluded: a value or count that moved, a re-point onto a live subject, a new gate.

| batches | R+ | R | D+ | D− | X | the instances |
|---|---|---|---|---|---|---|
| HD | 2 | 3 | 0 | 0 | 2 | R+ `check_du` §5's protected-core census, `test_batch_az`'s class-wide Hunter rune; R `test_batch_ar`'s opening kit, `test_batch_ba`'s Survivalist base kit, `test_batch_br` §5's one-in-four seam sentence; X `test_batch_bq` §2 and `test_batch_br` §4 (the retired *weaker* rule, printed as the record) |
| HE | 0 | 1 | 0 | 0 | 0 | R `check_hc` §1 (`shown_scope`, `SCOPE_INFO` and the band fields) |
| HF | 0 | 3 | 0 | 0 | 1 | R `check_he` §0–§2 (Long Poison's row) and §0/§3 (Mark of the Hunt's rows), `check_gt` §3; X `check_gv` (Long Poison moved into a group) |
| HG | — | — | — | — | — | documents only; it ruled *a retirement is inverted onto the ruling that removed its subject and kept, never deleted* |
| HH | 5 | 0 | 0 | 0 | 0 | R+ `check_eh` §3 (the ladder's `core_slots`), `test_batch_au` (twelve trees), `test_batch_az` (the tree's lanes), `test_batch_bo` §4 (shelf against sibling boss pool), `test_batch_br` §4 (the seam roll) |
| HI | 0 | 0 | 0 | 0 | 0 | — |
| HJ | 0 | 0 | 1 | 0 | 1 | D+ `check_da`'s `WALK_EXEMPT` entry; X `check_eh` §1 arm C |
| HK | 0 | 0 | 0 | 0 | 0 | — |
| HL | 1 | 5 | 1 | 0 | 3 | R+ `test_batch_be` §6 (Communion's writer); R `check_hd` §0/§1, `check_he` §0, `check_hf` §0, `test_batch_ak`, `check_gs` §2 (Guard Change's ruled row); D+ `check_gu`'s `BELOW` row; X `check_gp` §2b/§2e and `check_gm` §2 (arms stopped firing, untouched), `check_he` §5 |
| HN | 0 | 0 | 0 | 0 | 0 | — |
| HO | 0 | 0 | 0 | 0 | 0 | — |
| HP | 0 | 3 | 1 | 0 | 0 | R `check_ez` §4, `check_fd` §2, `check_fn` §1b (FN's retired tag conditions); D+ `check_gv`'s `GROUPS` row (Fellowship) |
| HQ | 0 | 0 | 0 | 0 | 1 | X `check_hp` §2e (a read-once clause's `elif`) |
| HR, HS, HT, HU, HV | 0 | 0 | 0 | 0 | 0 | — |
| HW | 0 | 3 | 0 | 0 | 3 | R `check_ho` §1d, `check_fd` §1d, `test_runes`' crest arm (a crest rune in a hero's cache); X `check_hr` §0a, `test_batch_an`'s reward table, `check_dr`'s Counter Time message |
| HX | 0 | 0 | 0 | 0 | 0 | — |
| **HD–HX** | **8** | **18** | **3** | **0** | **11** | |

**Retired onto the fact 26 times (8 with a record line), deleted with the fall predicted 3 times, never deleted without; 11
hybrids.** Left out of the table: HD's fold of the eleven suites' shelf floors (a re-point by HD's own account), HH's sixteen
arms sorted *superseded* rather than subject-gone, and `test_batch_bw`'s arm that fires zero times; counted, R+ is 24 and X 13. **The practice is not
split, and HG's doctrine stands**: DG §2's exception is struck where it stands, kept as a record, with what the practice kept of
it written beside the strike — **all three deletions were a ROW of an instrument's own table** (`check_da`'s walk exemption at
HJ, `check_gu`'s `BELOW` row at HL, `check_gv`'s `GROUPS` row at HP), an instrument's own data going with its subject, each with
its fall predicted and a note where it stood, and never an assertion about the game. `check_hy` §7 holds the strike, its stale
marker and the live doctrine's heading in the reference.

**What the readers flagged as doubtful**, and the totals do not lean on any of it: `test_batch_ar` (R or R+: its record prints
the new reading); HD's shelf fold (left out as HD's re-point; D+ if *the shelf as a pool* is the deleted subject); HL's `check_gp` and `check_gm`
(X — in effect deletions with no note, found by the recon's differ after the run); HP's `GROUPS` row (D+, its fall netted
inside a +10); and **R retirements still drop checks** — HH fell 521 across thirteen rows, each fall predicted in a note.

## §5 — THE FOUR TWO-FILE PASSAGES STAY

CT's autoload rule, EV §5's passage on a comment that names a banned string, the sentence that RunSim calls Profile nowhere, and
THE TRAPS' preamble — named in `check_hx`, left where they stand until the re-measure decides where rule text lives. **`check_hx`
§1b reads four, and no fifth**: 108,494 twelve-word runs across the four rule files, 13 shared and every one known, and 6 shared
statements, every one known.

## §6 — THE CLAIMS: RE-READ PER BATCH, AND A COUNT POINTS AT ITS INSTRUMENT

**Two rules, written into `docs/instrument-rules.md` with their rows:**

- ***A BATCH RE-READS THE REFERENCE CLAIMS THAT NAME WHAT IT TOUCHED*** — every present-tense claim in either reference that names
  a symbol, file or rule the batch changed is re-read against the tree, and repaired or reported, in that batch.
- ***A LIVE COUNT IN A REFERENCE POINTS AT THE INSTRUMENT THAT PRINTS IT, OR CARRIES ITS BATCH*** — HO §0's rule for a count,
  held to the references.

**31 OF THE 87 STALE CLAIMS STANDING AFTER HX ARE COUNTS — 26 in the instrument file, 5 in the combat file**; 41 are names, 12
files and 3 values. **The 87 are not repaired**, by ruling (§7): a batch of their own.

**HY's own re-read**, over the claims that name what HY touched — the frame and its readers, the five callbacks and the sites,
`check_fg`, `check_hx`, the two ceilings — **repaired the one its own change falsified**: the instrument rules' list of
`docs/state.md`'s readers, which now names `check_fg` §4. **It reported four** (FOUND AT HY): three are among HX's 87 —
`docs/combat-rules.md`'s header, *every block below is byte-identical to what stood in `CLAUDE.md`* (HU §3b's bullet, and now
HY's, were written there after the split); `_book_self_cost` *reaches the recap's ledger and nothing else* (it writes the save
through `_bank_party_losses` since GH); the crit total's *twelve statements carrying thirteen terms* (thirteen and fourteen since
HB's pity meter) — and the fourth stands inside a block moved byte for byte: HG's supersession block cites *HD §2's four* as
retirements that print what they used to read, and only `check_du` and `test_batch_az` do (§4's readers).

## §7 — DELIBERATELY NOT DONE

- **HX's 87 standing stale claims are not repaired** (§6).
- **The re-measure does not run**: two batches since HV are too few to measure.
- **No conjunction is authored**; `CONJUNCTIONS` keeps its one row and `RUPTURE_BREAK_PER_TICK` stays at 10, still unfelt.
- **A copied Frostbind is still carried** — the refusal is game code and is still RULED, NOT BUILT.
- **Boil Over and the Sharpshooter's toast are HZ's.** Boil Over becomes a Rage dump — RULED, NOT BUILT, and recorded in
  `docs/state.md` whole: the whole bar, no separate Rage cost, a minimum to cast; the Blood Frenzy term and the two-turn recovery
  go; the rate measured before it is authored, against the current good case of 84 for 40 Rage; and **`last_rites` checked: it
  is live** — the tier-3 node *Pay a Lethal Hit out of Your Resource Pool* (`tn_resource_ward`) writes it, and below a quarter's
  health `unit.take_hit` pays damage out of Rage first, 1 Rage a point, so a dump turns that protection off at the worst moment.
- **The roadmap's letters shift by one, recorded**: HZ the eyes with Boil Over and the toast, IA the bag and the three core
  slots, IB the draft flow, IC resources and fire. **Mana stays, and Channel's tempo payout is owed** (both already in the file).
- Standing, unchanged: a meter is not a conjunction half; Marrowfire becomes Sunder + Burn; the Occultist's Break card is CE §3's
  ask; the Skirmisher and the Tracker are ruled and unbuilt; whether a fallen hero stays down between fights; Tithe's read site.

## §8 — THE VERIFICATION

### §8a — THE SAVES, BEFORE ANYTHING

Backed up to `../save-backups/HY-20261009-091100` before any edit, and **all four player files were byte-identical to HX's backup**
(`HX-20261008-181721`) — md5, size and modification time — so nothing was played since HX. No Godot was running: the rows of `ps`,
read by executable.

### §8b — HEAD's GATES AGAINST THE NEW CODE, BEFORE ANY INSTRUMENT MOVED

**HY changed game code, so the recon was the whole battery**: HEAD's 138 targets, unmodified, against an isolated copy holding
HY's `battle.gd` and nothing else (*"Dawn of Decay HY recon"*, proved equal to the tree but that file and the held-out
`check_hy.gd`), predicted before the launch — most targets at HX's acceptance readings, and any target that drives a fight
through a repaired site and reads a frame reader expected to move, each move to be attributed by an `ok()` trace rather than
assumed. **138 targets, 09:42:06 to 10:57:31 — 75 min 25 s — read `check_de`
569 / 0 / 0 against HX's rows: every target at its HX acceptance reading, every FAIL line word for word** (`check_cm_live`
13 / 4 and `check_gj` 70 / 1, each its own row), the run harness PASS 22 / 382 / 8, and no Parse Error, SCRIPT ERROR, TIMED OUT
or NO VERDICT line in any of the 138 logs. The copy was proved to hold HY's `battle.gd` (md5 `670568fe…`, sixteen HY markers)
and HEAD's copy of every gate, the runner, `baselines.json` and the documents.

**THE REPAIR MOVED NO COUNT, AND THE PREDICTION NAMED MOVES THAT DID NOT COME.** No target of HEAD's battery drives a fight
through a repaired site and counts what a frame reader does with it — which is the gap `check_hy` closes, not a sign the repair
is idle: HEAD's code reads `check_hy`'s drives red at every site (H01, §8d). **The two counts that move with a draw moved inside
their bands, and each was traced, not assumed**: `test_batch_an` 6050 → 6054 in [6044, 6066] — its `ok()` trace on HEAD's code
and on HY's, twice each (6051 and 6056 on HEAD's, 6051 and 6053 on HY's), differs only in the fires of *zone N slot N is not a
rest*, one check per node of freshly generated maps, HEAD against HEAD as much as against HY, and the message sets are
identical; `test_batch_bk` 131 → 130 in [129, 131] — it loads no scene and spawns no battle, so no line of `battle.gd` reaches
it, and its trace agrees: 130 then 131 on HEAD's code and 130 then 131 on HY's, the one line whose fires
differ being *column 7 converges on the mini-boss alone* — an arm a generated map fires in some runs, HEAD against HEAD as much as
against HY.

### §8c — WHAT IS NEW

`check_hy` (live drives on scratch user files; §9 asserts the player's untouched) joins `run_battery.sh`'s GATES and
`baselines.json` at 161 / 0, deterministic; `check_parse` 212 → 213, one more battery target; `check_fg` 22 → 30, its §4;
`check_hx` re-tuned to HY's two moves with its count unmoved (39). The pin manifest was regenerated after the gates landed —
**1,728 → 1,733 pins**: `check_hy`'s five, three into the instrument rules and two into the combat rules (§6 reads `battle.gd`
function by function, through no holder the manifest binds) — and its eleven unresolved pins are HEAD's eleven.
**The new gate's own wrapped needle was the twelfth on the first regeneration**: `check_hy` §7 read the instrument rules flattened and passed, while the manifest reads the text as written; the needle was re-pointed at the
line it sits on and the assertion split in two (a compound `and` names neither half when it fails), 160 → 161.

**The literal sweep, across every document HY edited** — 24,280 gate literals, single- and double-quoted, read as written and
with whitespace collapsed — **lost no needle any gate asserts in the file it was lost from**: `CLAUDE.md` lost three (the moved
supersession block's heading, which only `check_hy` reads, and against the reference; and two literals no pin reads), `docs/state.md`
eight and `docs/combat-rules.md` one, none of them a pin's needle on that file; and **no literal any document gained is one a gate
requires absent from it**.

### §8d — THE CONTROLS

Each in its own copy of the landed tree, the defect patched in with its count asserted (every patch was dry-checked against the
copy before a lane ran), the gate run there and its FAIL lines read — the line, not the count. **Thirty-four: every defect red
on the line it aimed at; the baseline, the three re-tunes and the gone-block notice green; HEAD's code red at every site
`check_hy` drives; HEAD's `check_fg` green over the new documents and HEAD's `check_hx` red only where HY moved a known block —
and one control that did not bite on its first run, which found a defect in the gate.**

| control | the defect | the reading | its FAIL line (or notice), abridged |
|---|---|---|---|
| C00 | baseline: the landed tree, no patch | `check_hy` 161 / 0 · `check_hx` 39 / 0 · `check_fg` 30 / 0 | — |
| C01 | the vow share does not put the frame back | `check_hy` 161 / 15 | §1 (A1 the share, the Devout vowed) blow 1: the frame after the raider's Slash is Devout / Vow of Suffering / — it should be the raider's… (+14 more) |
| C02 | Rite of Return does not put the frame back | `check_hy` 161 / 2 | §4: after the rite answered, the frame is Holy / Rite of Return / — it should be the raider's Slash (+1 more) |
| C03 | Bloodbond does not put the frame back | `check_hy` 161 / 2 | §4 (Bloodbond): after the guard paid, the frame is Beastmaster / Bloodbond / — it should be the raider's Slash (+1 more) |
| C04 | Bear the Brunt does not put the frame back | `check_hy` 161 / 2 | §4 (Bear the Brunt): after the guard paid, the frame is Canis / Answering Pack / — it should be the raider's Slash (+1 more) |
| C05 | Blight the Well does not put the frame back | `check_hy` 161 / 2 | §4: after Blight the Well turned the heal, the frame is Occultist / Blight the Well / Occultist — the mending's own should be back (+1 more) |
| C06 | the Killing Cold does not put the frame back | `check_hy` 161 / 3 | §4: the cast's strike is booked 0.0 under Magic Bolt against 19 dealt — the rune's frame kept it (+2 more) |
| C07 | Snare Line's spring sets no frame | `check_hy` 161 / 5 | §2 (after an enemy's Slash): the spring dealt 19 and the Survivalist's ledger books 0 under Snare Line (+4 more) |
| C08 | the Deadfall's spring sets no frame | `check_hy` 161 / 5 | §2 (after an enemy's Slash): the Deadfall dealt 20 and is booked 0 under its name (+4 more) |
| C09 | a Ruin detonation sets no frame | `check_hy` 161 / 3 | §3 (vowed, after an enemy's Slash): the vowed Occultist's detonation took 98 — it is his damage, whoever acted last (+2 more) |
| C10 | the bomb sets no frame | `check_hy` 161 / 2 | §3: the bomb landed its 50 on 0 of 3 enemies after the vowed Devout's Smite (+1 more) |
| C11 | the Tripwire deals under the attacker's frame | `check_hy` 161 / 29 | §1 (A0 no share, the Devout vowed) blow 1: the Survivalist's wire booked 0, the whole blow's wire is 12 — silenced or mis-booked (+28 more) |
| C12 | Feint's return deals under the attacker's frame | `check_hy` 161 / 1 | §5 (Feint): the return killed the raider and the Reaver counted 0 — it was filed to the raider |
| C13 | a Mirror Guard return deals under the attacker's frame | `check_hy` 161 / 1 | §5 (Mirror Guard): the return killed the raider and the Reaver counted 0 — it was filed to the raider |
| C14 | Consecrated Ground's reflect deals under the attacker's frame | `check_hy` 161 / 8 | §1 (A0 no share, the Devout vowed) blow 1: the raider lost 22 — the mirror 8, the wire 12 and the reflect 0 make 20 (+7 more) |
| C15 | Spite deals under the attacker's frame | `check_hy` 161 / 1 | §5 (Spite): the return killed the raider and the Reaver counted 0 — it was filed to the raider |
| C16 | the Whole Forest's bite deals under the enemy's frame | `check_hy` 161 / 1 | §5: the forest bit the raider and the Tracker's mark did not land |
| C17 | a new function deals damage and is not in the census | `check_hy` 161 / 1 | §6: 1 function(s) deal damage and are not in the census — say what frame each deals under: battle.gd::_hy_ctl_new_site |
| R01 | **re-tune**: the new damage function with its census row | `check_hy` 161 / 0 | — |
| C19 | Forge Body does not put the frame back (a borrower §1-§5 never drive) | `check_hy` 161 / 0 → **161 / 1** (the gate before and after its repair) | §6: a borrowed frame is never put back by the function that borrowed it: _forge_body_throw (was_src) |
| H01 | **HEAD**: the new gate over HEAD's battle.gd | `check_hy` 161 / 69 | §1 (A0 no share, the Devout vowed) blow 1: the Survivalist's wire booked 0, the whole blow's wire is 12 — silenced or mis-booked (+68 more) |
| C18 | the combat rules lose the frame's rule | `check_hy` 161 / 1 | §7: docs/combat-rules.md does not state the frame's rule |
| C26 | DG §2's exception un-struck in the instrument rules | `check_hy` 161 / 1 | §7: the instrument rules do not strike DG §2's exception |
| C27 | the strike loses its stale marker | `check_hy` 161 / 1 | §7: the struck exception does not say it is stale on the practice |
| C20 | docs/state.md states a second, different ceiling | `check_fg` 27 / 1 | §4: docs/state.md states 2 DIFFERENT ceilings [380.0, 400.0] — the copies disagree |
| C21 | the ceiling's sentence loses never-split | `check_fg` 30 / 1 | §4: the ceiling's sentence no longer says the answer is the archive, never a split |
| C22 | docs/state.md grown past its deadline (ceiling + one batch at the record) | `check_fg` 30 / 1 | §4: docs/state.md is 395.92 KiB, past its ceiling by more than the largest single batch on record (13.38 KiB) — what was closed stayed; a… (+1 more) |
| R02 | **re-tune**: docs/state.md over its ceiling but inside the deadline | `check_fg` 30 / 0 | *** CEILING WARNING *** docs/state.md is 384.30 KiB against a 380 KiB ceiling. |
| R03 | **re-tune**: the ceiling's sentence reflowed across a line break | `check_fg` 30 / 0 | — |
| H02 | **HEAD**: check_fg over the new tree | `check_fg` 22 / 0 | — |
| H03 | **HEAD**: check_hx over the new tree | `check_hx` 39 / 1 | §1c: 1 block(s) in CLAUDE.md are not in the known population: THIS FILE IS MEASURED IN KiB, AND THE CEILING IS 510 KiB |
| C23 | a known CLAUDE.md block removed (gone) | `check_hx` 39 / 0 | [notice] §1c: the known block `THE POUCH IS SLOT-LIMITED` is gone from CLAUDE.md — delete its line |
| C24 | a moved block written back into CLAUDE.md | `check_hx` 39 / 3 | §1b: 1 run(s) of twelve words stand in two rule files and are not known: CLAUDE.md ~ instrument-rules.md: standing rule a supersession is… (+2 more) |
| C25 | one of HY's two new index rows removed | `check_hx` 39 / 1 | §1a: docs/instrument-rules.md has a block the instrument index does not point at: ## STANDING RULE — A BATCH RE-READS THE REFERENCE CLAIM… |

- **C19 WAS GREEN ON ITS FIRST RUN, AND THE GATE WAS WHAT WAS WRONG.** Forge Body's restore taken out read 161 / 0: §6's restore
  test was FILE-WIDE, and Forge Body and `_book_self_cost` both save the frame under the bare `was_` names, so the second's
  restore line answered for the first. **Repaired: a function that saves the frame restores it in its own body.** **Two-armed**:
  C19 read 161 / 0 under the gate before the repair and 161 / 1 after it, on its own line, and C00 read
  161 / 0 under both. **Round 2 re-ran every control whose patch takes a restore out (C01–C06 and C19), with the baseline, C10,
  C17, R01 and H01, under the repaired gate**: each read its first reading but C19, and C01–C06's §6 line now names the function.
  The rest take out only a frame's set and leave its saves and its restore, so the repaired arm reads them as it did.
- **C12, C13, C15 AND C16 RED AT §5 ALONE, AND THAT IS THE GATE'S STATED LIMIT, NOT A HOLE**: a retaliation stripped of its
  frame deals inside `_resolve` under the swing's own, which §6 cannot tell from an ACTION site — only the drive reads whose kill
  the Reaver counts and whose mark lands. **C14 reds §1 too**: the vowed Devout's reflect landing in A0 is HF's leak, back.
- **H01 — HEAD's `battle.gd` under the gate — reads 161 / 69** (§1 39, §2 10, §5 7, §4 6, §6 4, §3 3), red at every site: the frame left on the Devout through the rest of
  the raider's swing (A1, A2), the wire booked under the swing's label, Snare Line's spring no function a gate can call, the
  Deadfall, the detonation and the bomb silenced or leaking with the last action's frame, the four callbacks leaving the payer's
  frame standing, the Killing Cold's strike booked under the rune, and every retaliation filed to the raider — and §6 naming
  every borrower that never borrows and every frameless site.
- **H02 — HEAD's `check_fg` over the new tree — reads 22 / 0**: it parses 510 out of the new `CLAUDE.md` and has no §4. **H03 —
  HEAD's `check_hx` — reads 39 / 1**, red only on the ceiling block re-headed at 510, a block its known population has never
  seen: the re-tune HY made. It printed nothing for the two blocks that left (premise 17); C23 is the repaired gate printing the
  notice for a block gone.

### §8e — THE SUBSET, THE PRE-PASS AND THE ACCEPTANCE RUN

**The subset** — thirty-one targets: the gates HY added or edited, every gate that walks every gate file or the manifest, and
the readers of `docs/state.md` and the two references — ran first, in an isolated copy proved equal to the tree (*"Dawn of Decay
HY subset"*), predicted before its launch: **11:06:02 to 11:19:35, every target as predicted** — `check_hy` new at 161 / 0,
`check_fg` 30, `check_parse` 213, `check_hx` 39, and every other target at its HX acceptance reading, the gate walkers over the
new gate file included; no red, no throw, no target cut off. `check_hy`'s §6 was repaired after that copy was taken (C19, §8d),
and the pre-pass read the repaired gate.

**The pre-pass** — the tree's own runner in an isolated copy (*"Dawn of Decay HY prepass"*, user data seeded from HY's backup),
proved equal to the tree file by file before the launch (518 files, every one identical but `project.godot`'s renamed line).
Predicted before it and launched at 11:20:04: **139 targets, 11:20:04 to 12:35:50 — 75 min 46 s — read
`check_de` 573 / 0 / 0, exactly as predicted.** Every target read its row in `baselines.json` — `check_hy` new at 161 / 0,
`check_fg` 22 → 30, `check_parse` 212 → 213, `check_de` 569 → 573 — and the two counts that move with a draw sat inside their
bands (`test_batch_an` 6052 in [6044, 6066]; `test_batch_bk` 131 in [129, 131]). `check_cm_live` 13 / 4 and `check_gj` 70 / 1
with HX's FAIL lines word for word; the run harness PASS 22 / 382 / 8; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line
in any of the 139 logs; the run's own list 139 names, each once. **Every other target read its HX acceptance reading: HY moved
no count but its own three.**

**The acceptance run in the repository** — the repository's own runner and the live user folder, predicted before it and launched at 12:36:20, the
tree frozen before it (518 files; `.git`, `.godot` and `save-backups` aside) with the player's four files hashed beside it, and
`ps` read by rows every 15 s, each Godot named by its executable — **139 targets, 12:36:20 to 13:52:03 — 75 min 43 s — read
`check_de` 573 / 0 / 0, as predicted.** **The watcher's 302 readings found no Godot without `--headless`**: the designer's game
was not opened. Every target read its pre-pass reading but `test_batch_an`, which moved with its draw inside its band (6050 in
[6044, 6066]); `check_cm_live` 13 / 4 and `check_gj` 70 / 1 with the pre-pass's FAIL lines word for word; the run harness PASS
22 / 382 / 8; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any of the 139 logs; the run's own list 139 names,
each once. **The tree was byte-identical before and after (518 files), and the player's four files were untouched** — the same
hash, size and modification time before and after, and identical to HY's backup.

### §8f — THE FINAL TREE

`docs/state.md`'s verification line was written after the acceptance run — the only change to the tree since its freeze,
beside this report, which no gate opens. The literal sweep across that edit (24,281 gate literals, read as written and with
whitespace collapsed) lost nothing and gained nothing. **Every target that names `docs/state.md`, with the document instruments
and `check_hx`, re-read the final tree in an isolated copy** (*"Dawn of Decay HY final"*, proved equal to the tree; 13:53:02 to
13:56:04, predicted before it): `test_batch_aj` 213, `as` 273, `at` 359, `aw` 212, `check_dm` 93, `check_ec` 24, `check_ed` 18,
`check_ek` 47, `check_es` 57, `check_ff` 68, `check_fg` 30 (§4: `docs/state.md` 337,425 B, 50.48 KiB under its ceiling),
`check_fr` 25, `check_hp` 171 and `check_hx` 39 — each its acceptance reading, 0 failures, no throw.

## §9 — HOUSEKEEPING

- **HX's copies are cleared, by prefix (HO §5)**: its eight folders — HX's own count — 1,048 KiB, moved to the Trash as *DoD
  spent user-data folders (Batch HX's eight, cleared at HY 2026-10-09)*; `app_userdata` read 472 folders and 143,836 KiB before
  and 464 and 142,788 KiB after. The live *Dawn of Decay* folder, the older copies and `../save-backups/` were not touched.
- **HY's own folders stay for HZ to clear**: ten, 2,704 KiB — *Dawn of Decay HY probe* (`check_hy`'s first runs and the readers probe), *HY recon*,
  *HY trhead* and *HY trnew* (the drifters' traces), *HY ctlA*, *HY ctlB* and *HY ctlC* (the control lanes), *HY subset*,
  *HY prepass* and *HY final*.
- **The older copies are the designer's to clear**, outside HO §5's policy: HX's ready command stands (`docs/reports/HX.md` §7),
  and HY moved none of them.
- **Two tools of this batch's own, kept in its scratchpad and never in the tree**: a readers probe for Siphon and the Covenant
  share (§1d), run once on HEAD's `battle.gd` and once on HY's in an isolated copy, and the drifters' `ok()` traces (§8b), whose
  traced copies were deleted from their clones after the run.
- **Nothing is left running**: the rows of `ps` at the close name no Godot, no runner and no watcher.
