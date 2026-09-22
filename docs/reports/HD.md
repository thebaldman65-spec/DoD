# BATCH HD — THE TWENTY HOLES, AND THE POOL FLOORS FOLDED

**On `class-merge`, from `3c0af2b` (HC). IMPLEMENT ONLY.** HA's census found forty-two targets asking the merged game
pre-merge questions; **twenty of their arms could not fail as written, or passed while the game did the opposite.**
Those twenty are repaired or retired here — every repair broken on purpose in an isolated copy and seen to go red,
beside HEAD's version of the same target on the same defect, which never reads that arm red (it stays green, or reds
only on an older arm of its own that sees the same defect): the hole, shown. **The thirty-six
per-shelf pool floors are one per-class floor**, asserting both the whole pool and what a hero holding no engine can
be offered. **One game change was built, by ruling: Guard Change and Lunge are offered only to a hero holding the
Stances engine.** No rune was authored; no engine, kit, pool or node moved beyond that one gate. `main` is untouched.
HE takes the other seventy-three.

**THE FIGURES.** **One game change** — two RULED rows of the card gate; a Warrior holding no engine is offered 38 of
his 43 cards where he was offered 40. **The twenty: sixteen repaired, four retired.** **The fold: thirty-six arms,
158 checks, into one helper** — eight checks in each of eleven suites. **The rune floor** is `check_gv` §3's: three
classes floored and the Cleric owed. **One new gate**, `check_hd` (28). **Twenty-six controls**, one defect a copy,
each read by its FAIL text: twenty-four break a repaired or new arm and read it red, HEAD's copy never red on that
arm; c17 never reached its arm and was replaced (c17b); c18c measures the fold's premise. **Rows: twenty-four counts
moved and one row added**, and five more notes at unchanged counts. **The acceptance run: 123 of 123 launched (with `check_hd`), `check_de` 509 checks / 0 failures / 0 notices, the tree frozen and the player's saves byte-identical to the backup** (§7).

---

## NEEDS A RULING

1. **LUNGE IS STILL OFFERED AT A SWORDMASTER'S ZONE BOSS WITHOUT THE STANCES (§1c).** Lunge is on the Swordmaster's
   boss pool as well as his shelf, and the boss's first tier asks the PET half of `offerable` and not the engine half —
   HC §5's ruling, because the engine half would move every engine's boss offer. So a Warrior of that lineage who
   unslots the Stances is offered it there: **280 times in 400 rolls, exactly as with the Stances slotted**
   (`check_hd` §2, printed and not asserted). Shatter, Overcharge and Divine Plea already had this shape. Ask the engine
   half at that door (it moves those four boss offers), take Lunge off the boss pool (a pool change), or let it stand.
2. **A DRAFT'S ANSWER RE-ASKS NO ENGINE, AND THE STANCE PIECES REACH IT NOW (§1c).** HC recorded that the draft's answer
   (`take_draft_ability`) refuses only a card the hero owns; driven here, a Guard Change rolled with the Stances slotted
   is handed over after they are unslotted. The rune cache and the zone boss filter at the answer; the draft does not.
3. **`test_batch_br`'s CHARGE-AGAINST-STRIKE ARMS WERE LEFT LIVE (§1b).** They measure a class card against the free
   basic — the retired rule's floor, *"BQ's rule: the floor for a class card is the free core attack"* — and they pin
   the designer's reprice of Charge (20 BD, 30 Rage) rather than re-verifying *weaker*, which is why they stand. Every
   other comparison in the two "weaker" sections is retired and printed. Retire these too, or keep them as the
   reprice's pins.
4. **THE BRIEF'S §3 FIGURES WENT TO THE RUNES; THE FOLD TOOK THE CARDS' OWN (§3).** The thirty-five floors are card-pool
   floors and the figures are HC's rune table — a Cleric holding no engine can be offered no rune but 29 cards. Both
   were built. Confirm that is what was meant.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `3c0af2b` = `origin/class-merge` before anything moved |
| 2 | *"HA … found 42 targets — 130 assertions … Twenty of those are HOLES"* | **HELD** | HA §1d: 42 targets, 130 arms, 20 tier-1 |
| 3 | *"with the 35 per-spec pool floors folded … HB found that is what HA's original plan carried"* | **HELD** | HB §0 premise 2: HA's HB was the twenty and the thirty-five FOLD arms |
| 4 | *"The other 110 are HE"* | **DID NOT HOLD** | 130 − 20 = 110 counts the fold into HE; the fold is this batch's. **HE is HA's seventy-five tier-2 arms, less `test_batch_bq`'s two retired here by ruling: seventy-three** |
| 5 | *"`test_batch_bu`'s check loops over CLASS names instead of spec names, so its assertion never runs"* | **HELD** | `Classes.SPEC_IDS` is keyed by class; `spec_abilities("warrior")` is empty, so the loop body never ran |
| 6 | *"`test_batch_bx` passes whenever the Swordmaster's enabler list is empty — and it has been empty since GS"* | **HELD** | `… != "" or protected.is_empty()`, and `PROTECTED_CORES["swordmaster"]["enablers"]` is `[]` |
| 7 | *"`test_batch_br` passes because `CLAUDE.md` still describes the 'one-in-four class seam' GP deleted"* | **HELD** | `CLAUDE.md:3534` (HA said `:3421`; the file has grown), pinned at `test_batch_br:1566` |
| 8 | *"HA asked five game calls before the repair could proceed"* | **HELD** | HA's ruling 2 (a)–(e). (c), summoning, was already ruled and built at HB |
| 9 | *"HA found a check asserting they reach one spec while every Warrior is offered them"* | **HELD** | `test_batch_ak:354` asked the class-wide shelf, which never held either card; every Warrior drew the Swordmaster's shelf since GP |
| 10 | *"Summoning belongs to the Hunter class. HB made every Hunter summon"* | **ONE WORD SHORT** | every Hunter but the one holding Lethal Aim, which dismisses the pet (HB). `check_dr` §1 was re-pointed at HB; HD repaired `check_fo` §2g, two stale messages in `check_dr`, and three copies of the claim in `master.html` |
| 11 | *"[the weaker rule] existed because class cards were a fallback for when an engine was not online"* | **HELD IN SUBSTANCE** | `CLAUDE.md` gave the reason as *"they feed no passive, so at equal power they would be a safe default that dilutes every build"*; `classes.gd`'s header added *"the pick you take when your spec's engine is not online yet"* |
| 12 | *"retire the check that re-verified it"* | **THERE WERE TWO** | `test_batch_bq` §2 and `test_batch_br` §4 are both titled *THE "WEAKER" HALF, VERIFIED RATHER THAN TRUSTED*; HA's list named `bq:344`/`:349` alone. Both retired |
| 13 | *"Thirty-five per-spec pool floors"* | **ONE WORD SHORT, AND ONE SHORT** | twenty-three lineage-shelf floors and twelve class-wide-shelf floors; and a thirty-sixth of the same shape HA did not list (`test_batch_bq:204`), folded with them |
| 14 | *"Derive the floor values from HC's measured table … Warrior 5 / 9, Mage 3 / 7, Cleric 0 / 0, Hunter 5 / 7"* | **DID NOT HOLD** | HC §3 is the RUNE offer (at spawn / at the ceiling, both with no engine); the thirty-five are CARD-pool floors, whose halves are the whole pool and the no-engine offer. §3 says what was built |
| 15 | *"the rune design pass is authoring five Cleric runes that read no engine"* | **RECORDED, NOT CHECKABLE** | nothing in the tree yet; `check_gv` §3 notices the day the Cleric's no-engine offer rises |
| 16 | *"HC's five follow-ups … are additions to `ENGINE_READ`"* | **TWO OF FIVE** | HC's rulings 1 (gate the six status runes) and 5 (gate Mark of the Hunt) would touch a gate table; 2 is a price, 3 and 4 are words |

---

## §1 — THE RULINGS, AND THE ONE GAME CHANGE

### §1a — Guard Change and Lunge are the Stances holder's

**Built as two RULED rows of GP's card gate.** `Classes.ENGINE_READ` gains `"Guard Change"` and `"Lunge"` on
`seasoned`, each carrying `"ruled": "HD §1"`, and `Classes.engine_read_ruled` answers whether a row is the designer's
ruling rather than the cast test's finding. `offerable` gates both kinds with the same test, so the draft, the stored
triple and the zone-boss fallback withhold both from a hero without the Stances.

**Why "ruled" and not simply two more rows.** GP built the table by casting every card with its engine and without,
and gated only what CANNOT work without it. **Both of these half-work** — Guard Change still lands its 15 Break damage
and flips a guard only a card reads; Lunge still strikes, always down its Aggressive branch — so the derivation would
never have gated them, and `check_gp` §2's pair test would read them as a mistake. The row says what it is.

**Driven (`check_hd` §1), 400 rolls an arm at every door the gate stands at:**

| the Warrior | the elite draft | the zone boss's fallback | the stored triple |
|---|---|---|---|
| no lineage, no engine | 0 · 0 | 0 · 0 | 0 · 0 |
| the Swordmaster's lineage, the Stances OWNED and unslotted | 0 · 0 | 0 · 0 | 0 · 0 |
| no lineage, Heavy Plating slotted | 0 · 0 | 0 · 0 | 0 · 0 |
| the Berserker's lineage, Bloodrage slotted | 0 · 0 | 0 · 0 | 0 · 0 |
| no lineage, the Stances slotted | **28 · 27** | **28 · 27** | **3 · 5** |
| the Berserker's lineage, Bloodrage and the Stances slotted | **32 · 31** | **32 · 31** | **7 · 8** |

Guard Change · Lunge. The draft and the fallback are 400 seeded rolls an arm; the stored triple is 100
`award_draft_pick` calls, what the overlay will show. **The first four rows are the negative anchors and the last two
their positive arms**, each Warrior built the same way, so a roll wired shut or a gate that withheld from everybody
reads red. The draft and the fallback read the same figures because they ask the same answer, `Classes.offerable`
(GP). `test_batch_ak` asks the gate by name at `draft_pool_left` (no engine, Heavy Plating, the Stances), and
`check_gp` §2b asks every row's offer both ways.

### §1b — Immolate and Pyroblast; summoning; the "weaker" rule

- **Immolate and Pyroblast stay as GP left them** (every Mage is offered both). `test_batch_ar`'s two arms asked the
  class-wide shelf for their absence — green, while every Mage was offered both — and now assert what the game does:
  each is in the Mage's one pool, reads no engine, and is offered to a Mage holding none.
- **Summoning is the Hunter class's** (HB). `check_fo` §2g recorded the unreachability of a companion beside a Focus
  holder by asking whether both lineages were the Hunter's — true, and not the reason: from GK to HB one Hunter could
  slot Lethal Aim and Pack Bond together and field a companion beside his own Focus. It asks the door now (§2).
- **The "class-wide cards are weaker" rule is RETIRED**, struck and kept in `CLAUDE.md` with its reason, and in the
  `classes.gd` comments that stated it. The two checks that re-verified it keep every comparison computed and printed
  as the record (`_retired`), assert none of them, and assert instead that `CLAUDE.md` records the rule struck and no
  longer states it live. What was never that rule stays asserted: Mirror Image against Nexus Ward (one pool, no strict
  upgrade), Smite as the Cleric's basic, the Camouflage finding (a node's) and Charge's reprice (ruling 3).

### §1c — What the stance ruling does not reach

**Two doors the gate does not stand at, both driven (`check_hd` §2) and PRINTED rather than asserted** — asserting
either way would rule on them, which is rulings 1 and 2:

| door | driven | reading |
|---|---|---|
| the zone boss's first tier (`roll_spec_ability_offer`) | a Swordmaster-lineage Warrior, 400 rolls with the Stances slotted and 400 with them unslotted | **Lunge 280 in 400 both ways** — Execute 306, Sweeping Strikes 315, Shatterpoint 299, identical — because the tier asks the pet half of `offerable` and not the engine half (HC §5) |
| a draft's answer (`take_draft_ability`) | a triple rolled with the Stances slotted, answered after they are unslotted | **Guard Change handed over** — the answer refuses only a card the hero owns (HC's finding) |

The positive arm beside each is asserted: the boss tier offers Lunge to the Stances holder, and the draft stores a
stance piece for him.

**And three of HEAD's gates read the ruled rows as mistakes** (§5). Each derives the card gate from a cast, and each
took a row to be a card the door refuses without its engine: HEAD's `check_gm` §2 read *"with no engine,
swordmaster's Guard Change stays on the bar — drafted — and the door refuses it: it reads seasoned"*, `check_gp` §2
*"Guard Change does exactly the same thing with seasoned and without it — the row is wrong"*, and `check_gs` §2
*"Guard Change is gated on seasoned and a warrior holding none can cast it"* and *"4 returning cards are gated — GS
derived three"*. **The rows are right and the premise was the derivation's.** Each gate now drives a ruled row as a
ruling — its offer both ways, and its premise asserted: with no engine the card is still usable and still moves the
board — so the day the cast test finds it, the gate says `ruled` is no longer why it is gated (control c22).
`check_gm` and `check_gs` meet Guard Change alone (it is a lineage card and a returning one; Lunge is neither), and
`check_gp` §2e drives both.

---

## §2 — THE TWENTY

**Each arm is repaired to what it was FOR (CQ §3), or retired with the fact that retired it asserted in its place, so
the day that fact stops holding the old question comes back on its own.** Every one was broken on purpose (§4).

| # | HA's arm | what it was FOR | HD | where it is now | control (§4) |
|---|---|---|---|---|---|
| 1 | `check_dr:179` | no card but Resurrection revives | **REPAIRED** — the set of cards carrying `resurrection`, wherever each is defined, is exactly Resurrection. It asked Holy OWNERSHIP, so a second reviver on the Holy table passed | `check_dr:224` | c01 |
| 2 | `check_du:405` | DU's protected-core census counts more instances than names | **RETIRED** — true by construction since GS §1; printed, and the fact that retired it asserted: every lineage opens on its class's basic | `check_du:426` | c02 |
| 3–4 | `check_eg:257`, `:259` | a protected card can never be benched, nor carried out through the bench door | **REPAIRED** — it named Guard Change, protected for nobody since GS, so both doors refused a card never earned. It names the Warrior's first class-kit card, asserts it in the loadout and out of the pool, and asks the door with the name carried | `check_eg:272` | c12 |
| 5 | `check_fo:654` | no companion can stand beside a Focus holder | **REPAIRED** — it asked whether both lineages were the Hunter's (true, and not the reason). Lethal Aim dismisses the pet, both ways; the kit's pet card follows the dismissal; and the summon door refuses the Focus holder and opens for a Pack Bond Hunter | `check_fo:677`–`:691` | c04 |
| 6 | `check_ft:1298` | a free cast books the Channel floor in every school | **REPAIRED** — all three drives cast Magic Bolt, so fire and frost were never cast. Three plain cards, one a school, drawn from the Mage's pool and cast off an empty bar | `check_ft:1332` | c05 |
| 7 | `test_batch_ah_battle:345` | the hero sheet shows an earned card | **REPAIRED** — Crushing Blow is every Warrior's class-kit card since GN. It earns Cleave, a card in no kit, and asserts it in no opening kit | `test_batch_ah_battle:356` | c06 |
| 8 | `test_batch_ak:345` | the stance pieces are not offered to a Warrior without the stance | **REPAIRED WITH THE GAME** (HA: retire; the ruling built the gate) — the two ruled rows, and `draft_pool_left` with no engine, with Heavy Plating, and with the Stances | `test_batch_ak:357`, `:372` | c07 |
| 9–10 | `test_batch_ar:684`, `:686` | Immolate and Pyroblast are offered where they work | **REPAIRED TO THE GAME NOW** (HA: retire; ruled: they stay as GP left them) — each in the Mage's one pool, reading no engine, and offered to a Mage holding none | `test_batch_ar:696`, `:699` | c08 |
| 11 | `test_batch_ar:712` | the Pyromancer's defence is earned rather than opened | **RETIRED** — the Mage kit holds Nexus Ward since GN; asserted instead that he opens with a DEFENSE card of the class kit | `test_batch_ar:739` | c09 |
| 12 | `test_batch_az:618` | no class-wide Hunter rune writes a Sharpshooter counter | **RETIRED** — every such rune is retired or payload-less; asserted instead that no live Hunter rune is written for no lineage, and the record printed | `test_batch_az:648` | c10 |
| 13 | `test_batch_ba:534` | the Survivalist's base kit is not a trophy | **RETIRED** — the base kit dissolved at GS; asserted instead: Snare Trap is the Hunter class kit's, Tripwire and Shrapnel Charge are drafted off the Survivalist's shelf, and none is a trophy | `test_batch_ba:545`, `:548` | c11 |
| 14–15 | `test_batch_bo:507`, `:510` | a protected enabler is not in the drop list and cannot be benched | **REPAIRED** — the member held no engine, so he never held Flamewave and the door refused a card he did not carry. He seats Overburn, and a positive arm asserts Flamewave in his loadout | `test_batch_bo:478`, `:484` | c12, c16 |
| 16 | `test_batch_bo:627` | an owned card is not offered again | **REPAIRED** — the card gate refused Winter's Toll to an engine-less member whether he owned it or not. He seats Permafrost, and a twin who does not own it is offered it | `test_batch_bo:598` | c13 |
| 17 | `test_batch_br:1566` | `CLAUDE.md` carries the class-seam rule | **REPAIRED** — the document still carried the seam GP deleted. The merged sentence is pinned, the seam asserted absent as a live rule, and the game making it true asserted (the class-wide cards in the one pool) | `test_batch_br:1569` | c14 |
| 18 | `test_batch_bu:385` | no NINE name is authored into a kit | **REPAIRED** — it walked the four CLASS keys, so it never ran. It walks the twelve lineages' definition tables and every class basic and kit card — 55 abilities — and asserts it walked | `test_batch_bu:356` | c15 |
| 19 | `test_batch_bx:410` | a protected card cannot be named as the bench | **REPAIRED** — `or protected.is_empty()`, and the Swordmaster's enablers are empty since GS. It names the Warrior's class-kit card, asserts it carried, and asserts the refusal spends nothing | `test_batch_bx:418` | c12 |
| 20 | `test_run_harness:404` | an un-awakened hero banks nothing | **REPAIRED** — it read the purse under the empty key, which nothing writes. It reads the whole purse, every key, before and after the bank, and asserts it moved by exactly the classes that played | `test_run_harness:413` | c17b |

**Sixteen repaired, four retired.** HA's action column is followed but for three arms the rulings moved: `ak:345`
and `ar:684`/`:686` were marked RETIRE, and the designer's §1 rulings made each a repair to what the game does now.

---

## §3 — ONE POOL FLOOR A CLASS, BOTH HALVES

**The fold.** Thirty-six arms in eleven suites asked a lineage's shelf for eight or a class-wide shelf for three (six,
in one) *"so a pool that quietly empties trips"*. A shelf is where a card was authored since GP, not what a hero is
offered, so those arms could go red on a card moved between two shelves of one class — which moves nothing a hero is
offered — and stay green while the gate thinned what he is offered. **They fold into one helper,
`suite_fixture.class_pool_floors`, which every one of the eleven calls once**, asking per class:

| class | whole pool (`draft_pool`) | no engine (`offerable(draft_pool, [])`) |
|---|---|---|
| Warrior | 43 | **38** (40 until HD §1) |
| Mage | 51 | 38 |
| Cleric | 43 | 29 |
| Hunter | 42 | 35 |

**At the reading, and never an equality**: a pool that grows passes; the first card that leaves either half reds all
eleven, through one table (`CLASS_POOL_FLOOR`) that the batch thinning a pool moves and says why. **A floor of zero is
refused** (`maxi(…, 1)`): it asserts nothing, so the helper reds the day a class can be offered nothing.

**The brief's figures.** *Warrior 5 / 9, Mage 3 / 7, Cleric 0 / 0, Hunter 5 / 7* are HC §3's RUNE offer — no engine,
at spawn and at the ceiling. Applied to the card pools they would have floored a 43-card pool at 5. **They are the
per-class RUNE floor now, where HC's table is derived** (`check_gv` §3, `RUNE_FLOOR`): a floor, never an equality.
**The Cleric's 0 / 0 is OWED, not passed** — his row prints it as owed, prints a NOTICE the day it rises (the design
pass's Cleric runes), and asserts instead that some engine he can slot opens a rune at spawn, which goes red the day a
Cleric can be offered nothing at all.

**What the fold moved, suite by suite** — the shelf-floor CHECKS each loop made, and the eight the helper makes in their
place (the ok() trace attributes every one):

| suite | where | shelf checks | → | net |
|---|---|---|---|---|
| `test_batch_bo` | §5 | 19 | 8 | −11 |
| `test_batch_bp` | §5 | 4 | 8 | +4 |
| `test_batch_bq` | §0 | 4 | 8 | +4 |
| `test_batch_br` | §0 | 20 | 8 | −12 |
| `test_batch_bt` | pools | 16 | 8 | −8 |
| `test_batch_bu` | pools | 16 | 8 | −8 |
| `test_batch_bv` | pools | 19 | 8 | −11 |
| `test_batch_bw` | pools | 16 | 8 | −8 |
| `test_batch_cb` | pools | 16 | 8 | −8 |
| `test_batch_ce` | pools | 16 | 8 | −8 |
| `test_batch_cp` | §2 | 12 | 8 | −4 |
| **eleven** | | **158** | **88** | **−70** |

`test_batch_bq`'s four include `:204`, a class-wide floor of three HA's list did not carry. `test_batch_ce`'s
per-shelf duplicate arm, in the same loop, asks a different question and is kept, as is `test_batch_bo`'s
`CLASS_DRAFT_POOLS.size() == 4`.

---

## §4 — THE CONTROLS

**One defect per isolated copy** (each copy renamed in `project.godot` before anything ran, its `user://` seeded from
the backup), **two arms per target**: NEW is the repaired target on the tree with the defect, which must go red; HEAD
is HEAD's version of the same target on the same tree and defect, dropped in beside it. **Read by the FAIL text, never
the count.**

| control | the defect (one per copy) | target | NEW — the repaired target | HEAD — HEAD's target, same copy |
|---|---|---|---|---|
| c01 | Hymn of Hope carries `resurrection`, on the Holy table | `check_dr` | 83 / 1 — *cards carrying `resurrection`: ["Hymn of Hope", "Resurrection"] — exactly one, Resurrection, wherever it is defined* | 83 / 0 |
| c02 | the Pyromancer opens on Fireball again | `check_du` | 35 / 2 — *a lineage opens on something other than its class's basic (pyromancer) — … its instances/distinct arm is owed again (retired at HD §2)*, and the older *a spec replaces its class basic at spawn again* | 35 / 1 — the older arm alone |
| c04 | nothing dismisses the pet | `check_fo` | 90 / 3 — §2g: *the Focus engine no longer dismisses the pet*; *the pet card is not where the dismissal says*; *the summon door — a Focus holder ADMITTED* | 88 / 0 |
| c05 | a fire cast books nothing for Channel | `check_ft` | 147 / 1 — *§5f: … books { "fire": 0, "frost": 10, "arcane": 10 } — every school the floor, 10* | 146 / 0 |
| c06 | the hero sheet drops the second earned card | `test_batch_ah_battle` | 71 / 1 — *the Party sheet shows the earned Cleave* | 68 / 0 |
| c07 | the two stance rows removed | `test_batch_ak`, `check_hd` | ak 338 / 4 — the two rows, and *a Warrior holding no engine is offered ["Guard Change", "Lunge"] — the stance pieces are the Stances holder's (HD §1)*, and the same for Heavy Plating; hd 28 / 13 — every negative anchor | ak 334 / 0; `check_hd` has no HEAD |
| c08 | Pyroblast gated on Overburn | `test_batch_ar` | 508 / 1 — *Pyroblast is an ordinary card of the Mage's pool, offered to every Mage with any engine or none (HD §1: stays as GP left it)* | 510 / 0 |
| c09 | Nexus Ward out of the Mage class kit | `test_batch_ar` | 508 / 1 — *the Pyromancer opens with no DEFENSE card of the Mage class kit … the retired AR/BS question … is live again* | 510 / 0 |
| c10 | Wolf's Hunger un-retired | `test_batch_az` | 449 / 1 — *a LIVE Hunter rune written for no lineage exists (["wolfs_hunger"] of 9 walked) — … (retired at HD §2)* | 450 / 0 |
| c11 | Tripwire back in the Hunter kit | `test_batch_ba` | 773 / 1 — *Tripwire is drafted off the Survivalist's shelf — not a kit card, not a trophy* | 773 / 0 |
| c12 | the bench door stops asking the pool | `check_eg`, `test_batch_bo`, `test_batch_bx` | eg 69 / 1 — *a protected ability can never be benched — Crushing Blow, named in the loadout, was benched*; bo 1300 / 6, among them *…and benching one is REFUSED* (Flamewave); bx 159 / 5 — *a protected ability cannot be named as the bench (Crushing Blow was accepted)* | eg 68 / 0; bo 1308 / 5 — not the Flamewave arm; bx 157 / 0 |
| c13 | the draft roller stops filtering what a hero owns | `test_batch_bo` | 1300 / 2 — *§3: …and the same hero who OWNS it cannot*, and the older roller arm | 1308 / 1 — the older roller arm alone |
| c14 | the seam sentence put back in `CLAUDE.md` in place of the merged one | `test_batch_br` | 1486 / 2 — *…carries the class-seam rule … in its merged form*; *…no longer carries the seam GP deleted as a live rule* | 1534 / 0 |
| c15 | Recant put in the Cleric kit | `test_batch_bu` | 493 / 1 — *Recant is also an opening-kit ability — the cleric basic or class kit* | 444 / 0 |
| c16 | an engine stops bringing its own lineage's enabler | `test_batch_bo` | 1300 / 10 — every line HEAD reads, and *Flamewave is in this Pyromancer's loadout — he holds Overburn, so its enabler travels with him* | 1308 / 9 — every line but that one |
| c17 | an un-awakened hero banks under a key the purse drops | harness gate 2 | PASS — **the defect never reached the purse, so the control tested nothing**; kept as that and replaced by c17b | PASS |
| c17b | an un-awakened hero's point is paid to another class | harness gate 2 | FAIL — *the bank moved the whole purse by exactly the three classes that played: got { "mage": 1, "cleric": 2, "hunter": 1 }* | PASS |
| c18a | Wheeling Cut leaves the Warrior's pool | the eleven | all eleven red on both halves — *the warrior pool holds 42 cards, below its floor of 43*; *can be offered 37 of the pool, below its floor of 38* | bo, bp, bq, bt, cp green; the other six red on `master.html`'s stated draft count (178), `br` on its seam pin too — none on a floor |
| c18b | Counter Time gated on the Stances | the eleven | all eleven red on the no-engine half — *can be offered 37 of the pool, below its floor of 38* | all eleven green but `br`'s seam pin |
| c18c | four cards moved from the Warden's shelf to the Berserker's | the eleven | **the floors stay green, by design** — nothing a hero is offered moved; `bo` §4 and `bw` red on arms that pin where a card was authored | nine of eleven red on *warden drafts at least EIGHT* — a floor reading a shelf, not an offer |
| c19a | Long Watch gated on Bloodrage | `check_gv` | 919 / 5 — among them *§3 floor: a warrior holding no engine is offered 4 at spawn and 8 at the ceiling, below HC's 5 / 9 — the no-engine half thinned (HD §3)* | 912 / 4 — every line but the floor: an unruled row is already HEAD's §0 census red, so the floor's own ground is a thinning that adds no row (a retirement, a scope move) |
| c19b | every live Cleric rune retired | `check_gv` | 797 / 22 — twenty-one lines HEAD reads too (the retired runes leave §0's sorted groups), and *§3 floor: no engine a cleric can slot opens a single rune at spawn — a hero of the class can be offered nothing (HD §3)*; his OWED line printed | 790 / 21 — every line but that one |
| c21 | the weaker rule unstruck in `CLAUDE.md` | `test_batch_bq`, `test_batch_br` | both red on both — *does not record the class-wide 'weaker' rule as retired (HD §1)*; *still states the class-wide 'weaker' rule as a live rule* | bq 822 / 0; br red on its seam pin alone |
| c22 | Guard Change refused without the Stances | `check_gm`, `check_gp`, `check_gs` | gm 150 / 1 — *…a RULED row (HD §1), gated at the offer — stays on the bar and castable*; gp 443 / 1 — *§2e: Guard Change is refused, or moves nothing, without seasoned — the cast test finds it now*; gs 733 / 1 — *…a RULED row (HD §1) and a warrior holding no engine can no longer cast it* | gm 150 / 0; gp 442 / 0; gs 733 / 1 — *4 returning cards are gated*, the red it also reads with no defect (§5) |
| c23 | the two rows point at an engine no hero can slot | `check_hd`, `test_batch_ak` | hd 28 / 7 — the positive arms: *the Stances slotted was never offered Guard Change (draft 0, fallback 0, stored 0) — the Stances holder is offered both*; ak 338 / 3 — *a Warrior holding the Stances engine is offered both stance pieces (offered [])* | ak 334 / 0 |
| c24 | the Cleric's pool emptied and his floor row zeroed | `test_batch_cp` | 693 / 2 — *the cleric pool holds 0 cards, below its floor of 1*; *can be offered 0 of the pool, below its floor of 1* — **a floor of zero refused** | 697 / 0 |

**c03 was superseded by c12 before it ran** (the same bench-door defect, cut at the loadout), and there is no c20.
**c16's defect is wider than its arm** — it takes every lineage's own enabler away, so both arms red on the older
protected-core census and the one line NEW reads and HEAD does not is the positive arm HD added. **c18c is the fold's
premise measured rather than a hole**: HEAD's shelf floors red in nine suites on a move that changes nothing a hero is
offered.

---

## §5 — THE UNMODIFIED GATES AGAINST THE NEW TREE

**HEAD's battery ran first, unmodified, against HD's game code** — an isolated copy of the tree taken the moment the
two rows were written and before any gate or suite was touched, renamed and seeded from the backup.

**HEAD's battery on HD's game code, unmodified — 122 of 122 launched.** `check_de` read **505 checks, 3 failures, 3 notices**:

| target | HEAD's reading (row) | FAIL | why |
|---|---|---|---|
| `check_gm` | 150 / 1 (149 / 0) | *§2: with no engine, swordmaster's Guard Change stays on the bar — drafted — and the door refuses it: it reads seasoned* | a ruled row taken for a row the door refuses |
| `check_gp` | 442 / 1 (431 / 0) | *§2: Guard Change does exactly the same thing with seasoned and without it — the row is wrong* | the same |
| `check_gs` | 733 / 2 (732 / 0) | *§2: Guard Change is gated on seasoned and a warrior holding none can cast it*; *§2: 4 returning cards are gated — GS derived three* | the same |

**Every other target read its row**, `check_cm_live` (13 / 4) and `check_gj` (70 / 1) at their sanctioned reds, and no
stream carried a `Parse Error` or a `SCRIPT ERROR`. The three counts ROSE because each walks the gate's rows and the
rows grew by two. **They were repaired, not re-pointed** (§1c).

---

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **The other seventy-three arms are HE's**, HA §1d their list.
- **No rune was authored.** The Cleric's no-engine runes ride the rune design pass, and so do HC's five rulings.
- **No engine, kit, pool or node changed** beyond the two ruled rows; Lunge stays on the Swordmaster's boss pool
  (ruling 1).
- **Immolate and Pyroblast were not gated** — ruled: see how it plays first.
- **The class-wide cards were not rebalanced** — the rule that held them weaker is retired; the rebalance stays owed.

---

## §7 — VERIFICATION

**THE BACKUP, FIRST.** The player's four saves were copied to `../save-backups/HD-20260921-144901` before anything
ran, and verified by md5 — byte-identical to HC's backup, since nothing was played between (`profile.json`
`ed4144e1…`, `relics.json` `fdc12ffa…`, `run_save.bin` `25582edd…`, `settings.cfg` `0c1b39c3…`).

**THE PARSE FLOOR, READ OFF STDERR.** No `Parse Error` in any stream of any run — the recon, the pre-passes, both
arms of every control, the traces and both batteries — never read off a tally or an exit code.

**HEAD'S GATES FIRST** (§5): 122 of 122 launched on HD's game code; `check_de` 505 / 3 failures / 3 notices, all
three the ruled rows read as mistakes.

**THE PRE-PASS: THE WHOLE BATTERY ON AN ISOLATED COPY OF THE LANDED TREE**, rows written, the copy proved the tree
by hashing its 429 files against the repo: **123 of 123 launched, `check_de` 509 checks / 1 failure / 0 notices** —
every moved row and `check_hd`'s new one held — and no `Parse Error` or `SCRIPT ERROR` in any of its 123 logs.
**Its one red was one the batch had not predicted: `check_ek` 47 / 1**, because `test_batch_ar` checks a tag now (the
DEFENSE card of the Mage class kit, §2) and was not on `TAG_CHECKERS`. It is listed, and on the landed tree `check_ek`
read 47 / 0 standalone, with `check_ed` 18 / 0 on the manifest rebuilt behind the edit. The pre-pass caught it
because it ran every gate.

**THE ACCEPTANCE RUN**, in the repo, on a frozen tree: **123 of 123 launched (with `check_hd`), `check_de` 509 checks / 0 failures / 0 notices**, no `Parse Error` and
no `SCRIPT ERROR` in any of its 123 logs, **the tree hashed at the start and the end — 430 paths, none moved** —
and the two sanctioned reds at their counts: `check_cm_live` 13 / 4, and `check_gj` 70 / 1, *"the card says +178
gold and the purse moved 198"*, whose figures moved from HC's +174 / 194 on HD's game code alone (HEAD's gate read
them in the recon, §5), the gap the same twenty. It ran from 17:36:59 to 18:44:51. **The player's four saves are
byte-identical to the backup after everything ran.**

---

## §8 — WHAT MOVED

**The game:** `scripts/classes.gd` — two RULED rows of `ENGINE_READ`, `engine_read_ruled`, and the comments that
stated the retired rule. Nothing else in the game moved.

**The instruments:** `suite_fixture.gd` (`CLASS_POOL_FLOOR`, `class_pool_floors`); the gates `check_dr`, `check_du`,
`check_eg`, `check_ek` (`test_batch_ar` joins `TAG_CHECKERS`), `check_fo`, `check_ft`, `check_gm`, `check_gp`, `check_gs`
and `check_gv`; the suites
`test_batch_ah_battle`, `ak`, `ar`, `az`, `ba`, `bo`, `bp`, `bq`, `br`, `bt`, `bu`, `bv`, `bw`, `bx`, `cb`, `ce`, `cp`
and `test_run_harness`; **`check_hd.gd` (NEW)** and `run_battery.sh` (GATES); `pin-manifest.json` (rebuilt: 1,501 →
1,506 pins, residency unchanged — one pin out and six in: the seam needle is asserted absent where it was asserted
present, and the merged sentence and the weaker rule's struck and live halves, in both suites, arrived); `baselines.json`.

**The documents:** `CLAUDE.md` (368,259 B = 359.63 KiB, +3,652 B), `docs/master.html` and its stamp,
`docs/changelog.html`, `docs/design-notes.md`, `docs/state.md` and this report (**NEW**).

**The rows** — every move attributed by an ok() trace (HEAD's target on HEAD's tree against HD's on HD's, the message
multisets diffed) or, for `check_gv`, off a diff that adds seven `ok()` calls and removes none:

| target | HEAD | HD | why |
|---|---|---|---|
| `check_eg` | 68 | 69 | the protected-bench arm names a card that is protected, and asks the door with it carried |
| `check_fo` | 88 | 90 | §2g: one arm became three — the dismissal both ways, the kit's pet card, the summon door |
| `check_ft` | 146 | 147 | §5f casts a card of each school and asserts the schools are three |
| `check_gm` | 149 | 150 | Guard Change is a row, so the engine-held pass walks it |
| `check_gp` | 431 | 443 | §2e drives the two ruled rows as rulings (+3); §2b asks their offer both ways (+2); §4's seeded road draws other cards once two more are gated (+7, a drawn measurement) |
| `check_gs` | 732 | 733 | Guard Change driven as a ruled row: its premise, and its offer both ways |
| `check_gv` | 911 | 918 | the rune floor: three floored classes, and four single-engine arms |
| `check_hd` | — | 28 | **NEW** |
| `check_parse` | 196 | 197 | `check_hd` joined GATES |
| `test_batch_ah_battle` | 68 | 71 | Cleave, and each earned name asserted out of the opening kit |
| `test_batch_ak` | 334 | 338 | one arm became five: two ruled rows, and the door three ways |
| `test_batch_ar` | 510 | 508 | Immolate and Pyroblast repaired two for two; the all-fire walk's three arms became one |
| `test_batch_az` | 450 | 449 | the class-wide Hunter rune walk's two arms became one |
| `test_batch_bo` | 1,308 | 1,300 | the fold (−11), Flamewave's positive arm (+1), the owned card's twin and pool arm (+2) |
| `test_batch_bp` | 441 | 445 | the fold (+4) |
| `test_batch_bq` | 822 | 818 | the fold (+4); the weaker half's twelve arms became four (−8) |
| `test_batch_br` | 1,534 | 1,486 | the fold (−12); the seam pin became three (+2); the weaker half's forty-five became seven (−38) |
| `test_batch_bt` | 373 | 365 | the fold (−8) |
| `test_batch_bu` | 444 | 492 | the fold (−8); the NINE sweep runs, over 55 abilities (+56) |
| `test_batch_bv` | 562 | 551 | the fold (−11) |
| `test_batch_bw` | 503 | 495 | the fold (−8) |
| `test_batch_bx` | 157 | 159 | the protected-bench arm became three |
| `test_batch_cb` | 1,970 | 1,962 | the fold (−8) |
| `test_batch_ce` | 946 | 938 | the fold (−8) |
| `test_batch_cp` | 697 | 693 | the fold (−4) |

**Repaired at an unchanged count**, and each row's note says so: `check_dr` (83), `check_du` (35), `test_batch_ba`
(772) and the run harness's gate 2 (382) — and `check_ek` (47), whose list of targets that check a tag gained
`test_batch_ar`, which the pre-pass caught (§7).
