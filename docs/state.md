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

*Last rewritten: 2026-09-21 (Batch HD).*

---

## WHERE THE PROJECT IS

- **Last batch: HD — THE TWENTY HOLES, AND THE POOL FLOORS FOLDED. IMPLEMENT ONLY, AND THE THIRTY-SIXTH BATCH ON
  `class-merge`.** HA's twenty tier-1 arms are repaired or retired, the shelf floors are one per-class floor, and one
  game change is built: the stance pieces are the Stances holder's. `main` is untouched. Full working:
  **`docs/reports/HD.md`**.
- **THE SEQUENCE: HE IS NEXT — THE OTHER SEVENTY-THREE.** HA's middle group was 130 arms: the twenty holes and the
  thirty-five fold arms are HD's, and `test_batch_bq`'s two "weaker" arms were retired here by ruling, so HE is HA's
  seventy-five tier-2 arms less those two. **The brief's *"the other 110 are HE"* counted the fold family into HE**; the
  fold is this batch's. HA §1d is still HE's work list, arm by arm.
- **§1 — THE ONE GAME CHANGE: GUARD CHANGE AND LUNGE ARE OFFERED ONLY TO A HERO HOLDING THE STANCES** (`seasoned`), as
  two RULED rows of GP's card gate (`Classes.ENGINE_READ`, each carrying `ruled: "HD §1"`, read by
  `Classes.engine_read_ruled`). Both half-work without the engine, so the cast test never gated them; the ruling does.
  **A Warrior holding no engine is offered 38 of his 43, a Stances holder 40.** Driven (`check_hd` §1, 400 rolls an
  arm): **no stance piece** at the elite draft, the stored triple or the zone-boss fallback for a Warrior with no
  engine, with the Stances owned and unslotted, or with Heavy Plating or Bloodrage; **both at every door** for the
  Stances first or second. **Immolate and Pyroblast stay as GP left them** (every Mage is offered both, and the checks
  say so). **The "class-wide cards are weaker" rule is RETIRED** — struck and kept in `CLAUDE.md` with its reason;
  `test_batch_bq` §2 and `test_batch_br` §4, the two checks that re-verified it, print their comparisons as the record
  and assert the retirement. The cards are unchanged, and GP's rebalance stays owed.
- **§2 — THE TWENTY: SIXTEEN REPAIRED TO INTENT, FOUR RETIRED WITH THE FACT THAT RETIRED THEM ASSERTED IN THEIR PLACE**
  (`check_du`'s census, `test_batch_ar`'s all-fire kit, `test_batch_az`'s class-wide Hunter runes, `test_batch_ba`'s
  base kit). Every one was broken on purpose in an isolated copy: the repaired arm read red, and HEAD's version of the
  same target, on the same defect, never read that arm red — green, or red only on an older arm of its own that sees
  the same defect — the hole, shown. `docs/reports/HD.md` §2 and §4 have each arm, its defect and both FAIL texts.
- **§3 — ONE POOL FLOOR A CLASS, BOTH HALVES.** Thirty-six shelf-floor arms in eleven suites — HA's thirty-five and
  `test_batch_bq`'s class-wide floor of three, the same shape and not on HA's list — are one helper,
  `suite_fixture.class_pool_floors`: per class, the whole pool and what a hero holding no engine can be offered, at the
  reading — **Warrior 43 / 38, Mage 51 / 38, Cleric 43 / 29, Hunter 42 / 35** — and a floor of zero refused. **The
  brief's figures (5 / 9, 3 / 7, 0 / 0, 5 / 7) are HC's RUNE table**, so they are the per-class RUNE floor where that
  table is derived (`check_gv` §3's `RUNE_FLOOR`): the Cleric's zero is OWED, and his row asserts instead that some
  engine he can slot opens a rune.
- **THE VERIFICATION.** HEAD's unmodified battery ran first against HD's game code — **122 of 122 launched, no `Parse Error`;
  `check_de` 505 / 3 failures / 3 notices, the three gates that read the two ruled rows as mistakes**
  (`docs/reports/HD.md` §5). The pre-pass — the whole battery on an isolated copy of the landed tree, rows written —
  read `check_de` 509 / 1, and its one red was `check_ek`: `test_batch_ar` checks a tag now, and joined
  `TAG_CHECKERS`. The acceptance run: **123 of 123 (with `check_hd`), `check_de` 509 checks / 0 failures / 0
  notices, no `Parse Error` and no `SCRIPT ERROR` in any log, the tree hashed at the start and the end — 430 paths,
  none moved — and the two sanctioned reds at their counts** (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *"+178
  gold and the purse moved 198"*, moved from HC's +174 / 194 by HD's game code, the gap the same twenty). Twenty-six controls, one defect a copy, each read by its FAIL text beside HEAD's copy of
  the same target. The player's four saves were backed up to `../save-backups/HD-20260921-144901` and are
  byte-identical to it after everything ran.
- **`CLAUDE.md` IS 368,259 B = 359.63 KiB, WITH 50.37 KiB UNDER ITS 410 KiB CEILING** (+3,652 B this batch: the retired rule, struck; the ruled rows; the per-class floor; the
  merged seam sentence; the rune floor).
- **WHAT MOVED:** `scripts/classes.gd` (two ruled rows, `engine_read_ruled`, and the comments stating the retired
  rule); `suite_fixture.gd` (`class_pool_floors`); the gates `check_dr`, `check_du`, `check_eg`, `check_ek`, `check_fo`,
  `check_ft`, `check_gm`, `check_gp`, `check_gs` and `check_gv`; the suites `test_batch_ah_battle`, `ak`, `ar`, `az`, `ba`, `bo`, `bp`, `bq`, `br`, `bt`,
  `bu`, `bv`, `bw`, `bx`, `cb`, `ce`, `cp` and `test_run_harness`; **`check_hd.gd` (NEW)** and `run_battery.sh`;
  `pin-manifest.json`, `baselines.json`; `CLAUDE.md`, `docs/master.html` and its stamp, `docs/changelog.html`,
  `docs/design-notes.md`, this file and `docs/reports/HD.md` (**NEW**).
- **Phase.** Steps 1–5 of the merge's running order are done and the rune layer is merged; **step 6's first half is
  HD, and HE is its second**. The Crown's Break and freeze resistance, Sanctity's potency layer and the engine-card
  texts stay queued; the rune design pass (companion runes, a new companion, the Cleric's no-engine runes, and HC's
  five rulings) is its own.
- **Next letter: HE.**

## THE OPEN QUEUE — OWED, AND AWAITING A DECISION
### HD's RULINGS OWED — **FOUR; THE FIRST TWO ARE WHERE THE STANCE RULING DOES NOT REACH**

Full working: `docs/reports/HD.md`, NEEDS A RULING.

1. **LUNGE IS STILL OFFERED AT A SWORDMASTER'S ZONE BOSS WITHOUT THE STANCES.** It is on the Swordmaster's boss pool as
   well as his shelf, and the boss's first tier asks the PET half of `offerable` and not the engine half (HC §5's
   ruling: the engine half would move every engine's boss offer). So a Warrior of that lineage who unslots the Stances
   is offered it there — **280 times in 400 rolls, the same as with them slotted** (`check_hd` §2, printed). It is the
   shape Shatter, Overcharge and Divine Plea already had. Ask the engine half at that door (moves four boss offers),
   take Lunge off the boss pool (a pool change), or let it stand.
2. **A DRAFT'S ANSWER RE-ASKS NO ENGINE, AND THE STANCE PIECES REACH IT NOW.** HC's finding, driven for them: a Guard
   Change rolled with the Stances slotted is handed over after they are unslotted (`check_hd` §2, printed). The rune
   cache and the boss offer filter at the answer; the draft does not. Whether it should is the designer's.
3. **`test_batch_br`'s CHARGE-AGAINST-STRIKE ARMS MEASURE A CLASS CARD AGAINST THE FREE BASIC — THE RETIRED RULE'S
   FLOOR — AND WERE LEFT LIVE**, because they pin the designer's reprice of Charge (20 BD, 30 Rage) rather than
   re-verifying *weaker*. Every other comparison in the two "weaker" sections is retired and printed. Retire these too,
   or keep them as the reprice's pins.
4. **THE BRIEF'S §3 FIGURES WENT TO THE RUNES, AND THE FOLD TOOK THE CARDS' OWN.** The thirty-five floors are card-pool
   floors; the figures were HC's rune table (a hero holding no engine is offered no Cleric rune, but 29 Cleric cards).
   Built both ways (`docs/reports/HD.md` §3); confirm that is what was meant.

### FOUND AT HD AND NOT FIXED

- **THE CLERIC'S NO-ENGINE RUNE FLOOR IS OWED, NOT PASSED.** `check_gv` §3 prints it as owed and notices the day it
  rises; the design pass is authoring Cleric runes that read no engine, and the batch that lands them owes
  `RUNE_FLOOR` its reading.
- **`master.html` STILL SAYS *"All twelve specs draft from at least ten"*** — HA's second document-and-pin pair
  (`test_batch_cb:1246`, tier 2), HE's. HD corrected the first pair (`CLAUDE.md`'s seam and `test_batch_br`'s pin)
  and swept that claim's two copies out of `master.html` §6b, and the HB-era *"the Beastmaster's"* Summon Companion
  in its interface section.
- **THE FOLD'S FLOOR SITS AT THE READING**, so the next batch that gates a card, moves one into a kit or retires one
  reds eleven suites at once through one table (`CLASS_POOL_FLOOR`) — by design; that batch moves the table and says
  why.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (HD §0): *"the other 110 are HE"* (seventy-three); *"derive the floor
  values from HC's measured table"* (HC's table is runes); *"35 per-spec pool floors"* (twenty-three lineage-shelf and
  twelve class-wide, and a thirty-sixth HA did not list); *"HB made every Hunter summon"* (every Hunter but the Lethal
  Aim holder); *"HC's five follow-ups … are additions to ENGINE_READ"* (two of the five would touch a gate table);
  and *"retire the check that re-verified it"* (there were two copies of it).
- **THIRTY-SIX ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named **"Dawn of Decay HD
  …"**: the recon of HEAD's gates (**"HD recon"**), this tree's pre-passes (**"ctl pre"**, **"pre2"**, **"pre3"**,
  **"pregv"** and the whole-battery **"prepass"**), the ok() traces (**"trace head"**, **"trace new"**, **"trace3
  head"**, **"trace3 new"**) and the twenty-six controls (**"ctl c01"** to **"c24"**, with **"c17b"**). Each was renamed
  in `project.godot` before anything ran in it and seeded from the backup; they can be deleted. **There are 173
  such folders now**, counting every folder there but the live game's own. **The untracked `save-backups/` folder
  inside the repo is not this batch's**; this batch's backup is `../save-backups/HD-20260921-144901`.

### HC's RULINGS OWED — **FIVE, ALL PLAYER-VISIBLE; THE FIRST DECIDES WHAT THE RUNE DESIGN PASS STARTS FROM**

Full working: `docs/reports/HC.md`, NEEDS A RULING.

1. **SIX RUNES FALL THROUGH ALL THREE GATES AND CAN BE USELESS TO THE HERO THEY REACH.** Long Fuse (Burn), Killing
   Cold and Deep Cold (Chilled), Long Poison (his own Poison), Mirror Guard (the Defensive guard) and Slaughterhouse (an
   enemy bleeding out). **No class kit lays any of the five**, so each pays once a drafted card, an engine's enabler or
   an ally supplies it; at the spec scope each reached one lineage, and now it reaches the class. Driven on a full road,
   the bot was offered them while carrying nothing that could pay them. **Gate them (and on what), or leave them as a
   draft to build toward.** No fourth gate was built.
2. **BARED PLATE'S PRICE COSTS MOST WARRIORS NOTHING.** Its price refuses the Block roll, and a Warrior who is not of
   the Warden's lineage and holds no Heavy Plating opens at a Block chance of 0.000 (driven) — FP's `block_chance`
   finding below, arriving through a rune: at `spec:warden` every buyer had the Warden's 10%. **The one costed rune the
   scope change made free.** Not retuned.
3. **THE SCOPE BAND DISTINGUISHES NOTHING A PLAYER IS OFFERED.** Every offered rune reads `[Class]`; the band only tells
   a retired universal from the rest. Keep it, drop it, or show something else — the lineage is `written_for`, which
   the game may not read.
4. **THE EMPTY-OFFER SENTENCE SAYS *"that class"* WHERE IT SAID *"that awakening"*** — one door, four sites.
   Player-visible; confirm the word.
5. **MARK OF THE HUNT PAYS BESIDE LETHAL AIM, AND PAYS NOTHING WITHOUT PACK BOND.** Of Pack Bond's ten reads, the two
   that need no companion are both Mark of the Hunt's — the hunter's +25% on the marked prey and 3% of his Mana a strike
   on it — and both sit inside `has_engine("pack")`: **15 → 18 damage and 0 → 3 Mana with Pack Bond (beside Lethal Aim
   or alone), 15 and 0 without.** The card's text says *"Works with or without a companion"* and never names Pack Bond,
   and it is a boss pick, so no engine gate asks about it. So the tell that Pack Bond *sits out* beside Lethal Aim is one
   card short of true, and the card is dead to a Beastmaster-lineage Hunter who drops Pack Bond. Move the payload out
   of the block, gate the card, or let the tell stand.

### FOUND AT HC AND NOT FIXED

- **THE CLERIC IS THE CLASS THE RUNE MERGE DID NOT REACH.** All fourteen of his runes are `ENGINE_READ` rows (Mercy,
  Conviction, Ruin), so a Cleric holding a spine, a rule engine, any pair of the three non-lineage engines, or nothing,
  is offered no ordinary rune at spawn or ever — the designer's own Cleric (Sanctity) among them. **That is the input
  the rune design pass needs, stated here so it is not re-derived**: the Warrior's, the Mage's and the Hunter's classes
  each hold at least three runes that read no engine; the Cleric's holds none.
- **A CARD DRAFT'S ANSWER RE-ASKS NEITHER THE ENGINE NOR THE PET.** `draft_candidates` are rolled at the elite through
  `Classes.offerable` and answered on the party draft screen by `take_draft_ability`, which refuses only a card the hero
  already owns — so a card rolled while its engine was slotted is still handed over after the engine is unslotted (it
  then sits out, GT §3). The rune cache and, since HC, the zone boss's first tier filter at the answer; the draft does
  not. **Read at the source, not driven**; pre-existing, and not the rune layer's.
- **THE EVENT VERB'S EMPTY LINE IS FALSE MORE OFTEN NOW.** When no hero can take a rune, `events.gd` prints *"RUNE:
  nothing answers — every hero already carries every rune written for them."* — its own sentence, not the door the
  four other sites share (`Runes.empty_offer_reason`). It was already false whenever a pool was empty for want of a card
  or an engine; at the class scope that is the ordinary case (a hero's class holds rows for engines he has not
  slotted). Player-visible; not reworded — a new phrasing is the designer's.
- **`check_gv`'s DRIVE CAST AN ENABLER OFF THE DEFINITION TABLE.** Its `_card` falls back to `Classes.pool_ability` when
  the hero does not hold a card, so the Layered Aegis drive cast Divine Shield on a hero whose bar could not hold it —
  which is how GV read the rune as a CARD rune. Repaired for that drive (off the bar only); every other drive seats the
  card it casts, so the fall-back reaches nothing else today, and it is left standing.
- **`requires_ability` READS WHAT HE OWNS, NOT WHAT HE CARRIES**, so a rune whose card is benched is still offered and
  pays once the card is carried again. Recorded as the loadout lever EG built, not as a defect.
- **HEAVY PLATING'S CLIMB IS PER STRIKE, NOT PER ATTACK** — the brief's reason for the per-cast pity ruling (*"it mirrors
  Heavy Plating, which counts per incoming attack"*) holds for an enemy's area attack and not for its multi-hit, which
  climbs the Warden once a hit. The ruling does not depend on it; nothing moved.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (HC §0): *60 spec-scoped runes* is 110 with the retired; *35* engine rows
  is 36 now; FM's *10 of 17* is 16 of 17; *a dead engine in a live slot* is one card short (ruling 5); *"§6 already
  drives three doors"* is the brief's §7.
- **THIRTY-TWO ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named **"Dawn of Decay HC
  …"**: the designer's-save drive (**"HC save probe"**, seeded from the backup), the recon of HEAD's gates (**"HC recon1
  probe"**), HEAD's trees (**"HC head probe"**, **"head2"**, **"ctlhead"**, **"trace_head"**, **"trace_head2"**), this
  tree's probes and repair runs (**"HC new probe"**, **"probe2"**, **"rep1"**–**"rep3"**, **"trace_new"**,
  **"trace_new2"**) and the eighteen controls (**"HC ctl c01_…"** to **"c18_…"**). Each was renamed in `project.godot`
  before anything ran in it; they can be deleted. **There are 138 such folders now.** **The untracked `save-backups/`
  folder inside the repo is not this batch's**; this batch's backup is `../save-backups/HC-20260921-093502`.

### ~~HB's RULINGS OWED~~ — **ALL SEVEN CLOSED AT HC: THREE RULED AND BUILT THERE (2, 5, 6), FOUR RULED TO STAND AS BUILT (1, 3, 4, 7)**

HC's brief ruled all seven. **2**: the pity meter counts per CAST, uncapped, the reset its bound — built at HC §5a.
**5**: the zone boss's first-tier offer filters companion cards — built at HC §5b, the pet half of `offerable` only.
**6**: Pack Bond beside Lethal Aim is legal and sits out, visibly — built at HC §5c (and HC's ruling 5 is what it
found). **1** (×2.5), **3** (no companion by any route), **4** (the refused unequip) and **7** (OFFENSE / BREAK) stand
as HB built them. The working below is HB's, kept as the record of what was ruled.

#### HB's seven, as HB recorded them

Full working: `docs/reports/HB.md`, NEEDS A RULING.

1. **"+50% CRIT MULTIPLIER" WAS READ AS +0.50 ON THE MULTIPLIER — ×2 BECOMES ×2.5**, in the unit EW's surplus
   conversion uses (0.50 of multiplier). The other reading, ×2 × 1.5 = ×3, is one line: `unit.gd`'s
   `SHARPSHOOTER_CRIT_MULT`. Focus rides on top either way (×3 at 200, ×3.5 at 300).
2. **THE PITY METER HAS NO CAP, AND IT COUNTS HITS.** The brief gave no cap and Heavy Plating's has one (+40%).
   Uncapped, the reset governs: a deep Sharpshooter at turn 10 and the odds of a streak reaching certainty are in the
   report's §4. *"Per landed attack"* was read as BR §1 reads a charge — per HIT — so an area attack climbs it once per
   enemy struck; per CAST is the other reading.
3. **A SHARPSHOOTER FIELDS NO COMPANION BY ANY ROUTE, AND THAT INCLUDES CALL THE WILDS.** An earned Call the Wilds
   is the one card that summons, and *dismisses the pet* was read as no companion at all: it is withheld from his
   offer and sits out if he carries it. The other reading lets the drafted summon through.
4. **UNEQUIPPING THE RUNE OF THE SHARPSHOOTER IS REFUSED WHILE EVERY SLOT IS FULL**, because it returns Summon
   Companion to the kit and the kit would overfill the bar. The refusal names the reason and asks for a card to be
   benched first. The alternatives — bench one for him, or let the kit overfill — are the designer's.
5. **THE ZONE BOSS'S TIER-1 OFFER STILL ASKS NO DOOR**, so a Beastmaster-lineage Hunter holding Lethal Aim can be
   offered Bestial Wrath, Spirit Bond or Primal Surge off his boss pool — companion cards that sit out for him — and
   Call of the Wild, whose absent companions strike bodiless. GP ruled the boss pools untouched and the brief says no
   pool changes; asking `Classes.offerable` there is one line.
6. **A HUNTER MAY STILL HOLD PACK BOND AND LETHAL AIM TOGETHER**, and then Pack Bond does nothing at all: every read of
   it needs a companion and he has none. Nothing withholds either engine from the other's holder; whether it should
   is the designer's.
7. **SUMMON COMPANION IS TAGGED OFFENSE / BREAK — TWO OF ITS THREE CALLS — AND THE CORE-KIT CENSUS MOVED WITH IT.**
   The Beastmaster's core no longer carries Summon Canis's DEBUFF, so DEBUFF is met at 2+ by **five** lineages'
   cores alone, not six (`check_es` §4, and the three documents that state it). Tagging the card DEBUFF / BREAK, for
   the wolf, is the other reading and moves the OFFENSE column instead.

### FOUND AT HB AND NOT FIXED

- **THE BOSS-POOL DOOR (ruling 5) IS GP's, NOT NEW**: `roll_spec_ability_offer`'s tier-1 draw has never asked
  `offerable` — GP left the boss pools as they were — so it reads no engine at all. HB adds the negative case to
  what it does not ask. **Since HC it asks the PET half (`Classes.pet_withholds`) and still no engine** — ruled that
  way, because the engine half would move every engine's boss offer.
- **TWO BRIEF PREMISES DID NOT HOLD** (HB §0): Tripwire never was in the Hunter pool, so it went to it rather than
  *back*; and *cards and runes that need a companion were gated on Pack Bond* held at neither layer — GP and GV gated
  the BOND readers and left every card that needs only a companion ungated, because an earned Call the Wilds gave any
  Hunter one. **The Shared Hide is a companion reader, not a Pack Bond one.**
- **THE THREE SUMMONS WERE ONE BUTTON IN A FIGHT BEFORE HB** — *Summon Companion ▸* on W, opening the picker — and
  three rows everywhere else. HB made them one card everywhere, and the fight's button did not change.
- **FOUR ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: **"Dawn of Decay HB head probe"** (the
  HEAD arm of §1's swap drive and of the traces), **"HB trace new"** (the `ok()` traces), **"HB probe new"** (the probes)
  and **"HB ctl"** (the controls). Each was renamed in `project.godot` before anything ran in it; they can be deleted.
  **There are 106 such folders now.** **The
  untracked `save-backups/` folder inside the repo is not this batch's**; this batch's backup is
  `../save-backups/HB-20260921-045412`.

### HA's RULINGS OWED — **TWO LEFT, BOTH ABOUT `main`; THE FIRST IS ANSWERED BY HB's SEQUENCE AND ALL FIVE OF THE SECOND WERE RULED FOR HD**

Full working: `docs/reports/HA.md`, NEEDS A RULING.

1. **THE REPAIR OF THE MIDDLE GROUP IS PROPOSED AS TWO BATCHES — ANSWERED WITH HB's BRIEF: THEY ARE HD AND HE, BEHIND
   HB's PET AND HC's RUNE SCOPES.** **HD (HA's HB): the twenty tier-1 arms first** — each cannot
   fail as written or passes while the merged game contradicts it — **then the thirty-five FOLD arms** in eleven
   suites, whose per-shelf and class-wide-shelf floors become one per-class floor through one shared helper (55 arms,
   23 targets). **HE (HA's HC): the other seventy-five tier-2 arms in 36 targets**, with `check_ea` §1's four-arm
   re-derivation over class × engines held and `check_dp` §1's status table re-keyed by class as the two that are more
   than a re-point. **The report's §1d is the work list, arm by arm: file, line, relation, action and cost.**
2. **~~FIVE CALLS ONLY THE DESIGNER CAN MAKE BEFORE THOSE ARMS ARE REPAIRED~~ — ALL FIVE RULED IN HD's BRIEF AND TAKEN
   AT HD:** (a) Guard Change and Lunge are the Stances holder's (built, two ruled rows); (b) Immolate and Pyroblast stay
   as GP left them, the checks repaired to that; (c) summoning is the Hunter class's (HB); (d) the "weaker" rule is
   retired, and the checks that re-verified it with it; (e) the floor is both. HA's working, as it stood: (a) **Guard Change and Lunge** — every
   Warrior is offered both since GP; retire `test_batch_ak:345`, or rule them holder-only (two `ENGINE_READ` rows);
   (b) **Immolate and Pyroblast** — every Mage is offered both and neither reads an engine; retire
   `test_batch_ar:684`/`:686`, or rule them holder-only; (c) **~~summoning~~ — RULED AT HB: THE HUNTER CLASS**, every
   Hunter but the Sharpshooter, through the class kit's Summon Companion (`check_dr` §1 re-pointed, and `CLAUDE.md`'s
   DR §1 block and FO §2 bullet with it); (d) **EB §1's "class-wide cards are weaker"** — GP recorded the
   rebalance as owed; retire `test_batch_bq:344`/`:349` or re-point them over every Cleric who can draft Heal; (e) **the
   floor the FOLD family asserts** — on `Classes.draft_pool(k)` (43 / 51 / 43 / 42 since HB), on the engine-free
   `Classes.offerable(draft_pool(k), [])` (40 / 38 / 29 / 35 since HB), or both.
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

- ~~**A HERO WITH NO LINEAGE CAN BE OFFERED NO ORDINARY RUNE AT ALL — GV's RULING 5, AT ITS SHARPEST.**~~ **CLOSED AT
  HC FOR THREE CLASSES OF FOUR**: every rune is class-scoped, and a no-engine Warrior, Mage or Hunter is offered 5, 3 and
  5 at spawn; **the Cleric's is 0, because every Cleric rune reads a lineage engine** (HC's finding). HA's working: all
  60 live ordinary runes were `spec:`-scoped and `Runes._scope_ok` passed one only for a matching lineage.
- **TWO DOCUMENTS STATE A PRE-MERGE FACT AND A PIN KEEPS EACH GREEN — THE FIRST CLOSED AT HD** (`CLAUDE.md`'s seam
  sentence corrected and `test_batch_br`'s pin repaired with it; the second is HE's), and both were left for the repair batch because the
  sentence and its pin move together: `CLAUDE.md:3421` still says *"THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY FOR
  EVERY HERO IN THE GAME"* (the seam GP deleted; `test_batch_br:1566` pins it), and `docs/master.html` still says *"All
  twelve specs draft from at least ten"* (`test_batch_cb:1246` pins it).
- **AT LEAST TWENTY-THREE TARGETS SEAT A LINEAGE BY HAND WITH NO ENGINE RUNE**, against GK's *"a hand-built seat must
  too"*. Harmless in most; not in `check_et` (every `Runes.ENGINE_READ` rune withheld from its retirement walks —
  `check_fd`'s identical helper was repaired at GV and this one never was), `test_runes`' exhaustion and start-pool
  members, `check_fm`'s `_member`, and `test_batch_bo` §2/§3, where it is what makes three arms vacuous. The list is in
  the report's §1g.
- **`Run.ability_slots_used` IS LINEAGE-KEYED, AND SINCE HB IT READS ONE ENGINE QUESTION** — whether one held dismisses
  the pet (`Classes.kit_slots(class, spec, engines)`) — so two gate arms are still near-tautologies against its
  lineage half (`check_gm:378`, `check_gn:197`). Correct while `lineage_slots` is zero for every lineage.
- **THE DEBUG PRE-GRANT *"All Spec Abilities Unlocked"* STILL GRANTS ONE LINEAGE'S BOSS POOL AND SHELF** (`battle.gd`
  ~1322), not the class pool a draw reads.
- **THREE GATES CHECK TWELVE ENGINES' TEXT WHERE THERE ARE TWENTY-FOUR** (`check_cl_resolver`, `check_cl_width`,
  `check_do` §4), reaching it through `SPEC_INFO[s]["passive_desc"]`; the spines' and the rule engines' texts are never
  checked. None carries a token today.
- **SMALL AND DEAD:** `check_di:391`'s `_hero(scene, "pack_bond")` can never match (the id is `pack`); `test_batch_cp`'s
  `PASSIVE_OF` maps the Beastmaster to `"loyalty"`; `check_cy`'s sweep always casts from the first living hero, so its
  two-party reason is never exercised.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (HA §0): *"most have been repaired incidentally, batch by batch"* (GK
  repaired every red its own move caused, deliberately and inside GK); *"every batch since has moved some of them"*
  (nine of the sixteen batch commits since GK moved none of FP's 52 rows); *"FG's finding recurring for the third
  time"* (GZ's *third* counts the bare-`contains` shape, whose first two instances are BZ→BB and CD→BO; FG's finding
  was DV's always-true alternation); and *"two defects"* on `main` (GI's line names a third, the zone boss that could
  field the Hollow Crown).
- **TWO ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: **"Dawn of Decay HA main probe"** and
  **"Dawn of Decay HA head probe"**, the two arms of §3c's drive. **Each was renamed in `project.godot` before
  anything ran in it** and seeded from byte-identical copies of the player's saves; they can be deleted. **There are 102 such folders now.** **The
  untracked `save-backups/` folder inside the repo is not this batch's** — it holds FR to GT's backups and was left as
  it was; this batch's backup is `../save-backups/HA-20260921-002123`.

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
2. ~~**NOTHING IN THE TREE OPENS `README.md`, AND IT SAT THREE CUTS STALE BECAUSE OF IT.**~~ — **RULED AND TAKEN AT HA §4:
   STRIPPED TO WHAT CANNOT GO STALE, AND NO GATE.** The rule and its reason are in `CLAUDE.md`'s *WHAT THIS FILE IS* block. The
   original finding: it named **Batch BP** as
   the live file's first entry — the boundary BZ's first split left, written at `06e382c` and carried unchanged
   through CX, DV and FG, **126 batches**. Corrected here, but **the class of defect is not**: the re-point debt
   has always been counted over the files that OPEN the changelog, and a file no instrument reads is a file whose
   claims can never go red. **GZ wrote the lesson into `docs/instrument-rules.md` under CW §4 and did not build the
   instrument.** Whether `README.md` — and any other file in that class — is worth a gate that reads its factual
   claims against the tree is the designer's; it is a different shape from every document gate now standing, all of
   which read files something already asserts on.

### FOUND AT GZ AND NOT FIXED

- **THE ARCHIVE HAS NEVER GROWN INSIDE VERSION CONTROL UNTIL NOW, AND THE BRIEF'S COUNT WAS WRONG IN THE SAFE
  DIRECTION.** It was created by **BZ**'s split and added to by **CX**, **DV** and **FG** — three additions, four
  cuts — and **FH did not grow it**; FH moved the folder into the repo and edited one sentence of its header, which
  is the 268 B between FH's recorded 1,646,681 B and the 1,646,949 B it actually shipped. **This batch is its first
  growth as a tracked file**, so it is also the first addition whose recovery does not depend on a named commit.
- **`check_fg` §1 HAS NEVER HELD A COPY OF THE CHANGELOG BAR, AND FU's RED WAS §2's.** Confirmed by reading the
  gate rather than its header comment: the only route to the number is a pattern over
  `docs/instrument-rules.md` that finds the FORM whatever the number is, collects every occurrence and asserts the
  set has one member. **The defect FU repaired was shared by both form checks; the number that moved was
  `CLAUDE.md`'s ceiling, so §2 is what went red** against a correct rule and a correct file.
- **THE LIVE FILE'S OWN HEADER CARRIED TWO CLAIMS THIS CUT FALSIFIED, AND NEITHER IS A BOUNDARY NUMBER.** *"See the
  **Batch FH** entry below"* pointed at an entry that is one of the 29 that moved, and the archive's *"EVERYTHING
  BELOW WAS WRITTEN WHILE THIS FILE WAS NOT BACKED UP"* became false for the 15 newest entries in it the moment
  they arrived. Both re-scoped. **A cut moves entries out from under prose that points at them**, and nothing
  asserts on that class of pointer at all.
- **TWO ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata` — **"Dawn of Decay GZ ctl head"**
  and **"GZ ctl new"**, the two arms of `check_gj`'s HEAD control. **Each was renamed in `project.godot` before
  anything ran in it**, so its `user://` could not reach the player's saves, and each was seeded from a
  byte-identical copy of the live folder so the two arms started from the same state. They can be deleted.
  **There are 100 such folders now**, GY's four among them; nothing prunes them and each batch adds a few.
  **The player's four save files are byte-identical to the backup taken as this batch's first action**, checked
  by md5 before the battery and again after everything had run.
- **THE CUT LEFT 32 ENTRIES, WHICH IS THE LARGEST LIVE HALF ANY CUT HAS LEFT, AT THE SMALLEST BYTE SIZE.** CX left
  10 at 162.1 KB, DV left 16 at 150.0 KiB, FG left 17 at 147,929 B, GZ leaves 32 at 144,740 B. **Entry size
  is falling** — the newest 7 average 3,669 B against a 5,863 B/batch realised growth rate over FG's whole window —
  so the entry COUNT and the byte figure are drifting apart, and `check_dv` §4's floor is on the count while
  `check_fg` §1's bar is on the bytes. Neither is wrong; they will simply answer different questions from here.

### GY's RULINGS OWED — **THREE; NONE IS PLAYER-VISIBLE, AND THE FIRST SHAPES THE NEXT BATCH**

Full working: `docs/reports/GY.md`, NEEDS A RULING.

1. **~~`docs/changelog.html` HAS CROSSED ITS OWN THRESHOLD, AND THE CUT IS OWED AT THE NEXT BATCH BOUNDARY~~ —
   TAKEN AT GZ, AT THE FS/FT BOUNDARY: 29 entries moved, 400,021 B → 144,527 B, and `check_fg` §1 stopped
   warning.** The
   file is **400,021 B against CW §4's 400,000 B bar — 21 bytes over** — and `check_fg` §1 printed its CEILING
   WARNING on the acceptance run: *"The cut is owed AT THE NEXT BATCH BOUNDARY and this gate FAILS if it is not
   taken."* **It is a WARNING and not a red by the gate's own design** (the file WITHOUT this batch's entry is
   396,730 B, under the bar), which is FG's rule that the red never lands on a batch with no warning in front of it.
   **GY is the batch that crossed it, so the next one owes the cut** and the one after that fails without it. The cut
   is a batch of work by CW §4's procedure — a byte-for-byte split with a rejoin proof, which this project's rule
   says must not share a diff with anything else — and it has been taken four times before (BZ at BO/BP, CX at
   CN/CO, DV at DF/DG, FG at EP/EQ). **The entry was not trimmed to sit under the bar**: GY's is 3,291 B against a
   2,871–4,838 B range over the last seven batches, so shrinking it to clear 21 bytes would have been writing to the
   instrument rather than to the reader. Whether the next batch takes the cut or defers it is the designer's.
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
- **THE SWEEP'S FIRST POPULATION WAS `check_gw` §2's AND IT MISSED ONE OF THE FOUR FINDINGS.** `check_gw` §2 reads
  its targets out of `run_battery.sh`'s `SUITES` and `GATES` — 115 files — and the runner launches four more from
  arrays of its own (`check_de`, `check_map_screen`, `check_ct_map`, `test_run_harness`). **`check_ct_map:96` lives
  in one of the four**, and it is the second of the two arms that pass vacuously. The population is the 121 files the
  battery launches now, plus the two fixtures whose locators every target calls. **A population inherited from a
  neighbouring sweep inherits its boundary**, and this one's boundary is an array in a shell script rather than
  anything about what a target is.
- **AND THE SWEEP'S LOCATOR SET WAS HAND-LISTED UNTIL THE LAST PASS.** A written-out list of selector names missed
  `check_gt`'s own `_buttons_from` and missed a whole family — lambda `filter`/`any`/`all` predicates reading a drawn
  value, which is where `check_gq`'s six sites and the closest near-miss live. The set is derived now: any function
  that takes a needle, compares or searches with it, and returns what matched. **Three widenings, and each one moved
  the count and the findings** — 109 → 289 → 384 sites, and 3 → 4 findings.
- **A DOC EDIT WHOSE ANCHOR SPANNED A LINE BREAK BROKE `check_fg`'s PARSE, AND WAS CAUGHT BEFORE THE RUN.** The
  re-written derivation put *"the largest single-batch growth on record is"* at the end of one line and
  **+8.10 KiB** at the start of the next; the gate's regex does not cross a newline, so it read **zero** growth
  figures and would have failed. Found by re-running both of §2's regexes over the edited file immediately after
  writing it, and repaired by re-wrapping the sentence. **The two statements of a bar are asserted to agree; nothing
  asserts that either is on one line.**
- **FOUR ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata` — "Dawn of Decay GY disagree", "GY
  low", "GY grow" and "GY raise". **Each was renamed before anything ran in it**, so its `user://` could not reach
  the player's saves, and each holds only a `logs` directory. They can be deleted. **There are 95 such folders now**,
  GX's nine among them; nothing prunes them and each batch adds a few.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (GY §0), all four in the same block of argument and none changing what
  was built: ***"EF forbade that"*** (EF's *there are not two files a batch must read* was **retired at GR §2** and a
  batch must not refuse a subject split on its strength — what rules rune law out is GR's own test, *the subject a
  batch reads least*, and rune law is the one batches read most); ***"DL found the resulting contradiction"*** (DL's
  contradiction is about **summarising a rule into the other file**, not about a batch opening two files);
  ***"GQ found it held a COPY"*** (**the finding is FU's**, and GR §0's premise table already corrected this exact
  sentence once); and ***"+138% needs four buffs"*** (four damage effects, of which **three** are buffs and the
  fourth is a stance-switch status — GX §2's own words). **And one quote is misattributed without being wrong**:
  *"benching has no tell; sitting out does"* is GX's report's wording; `CLAUDE.md`'s is ***"Sitting out is not
  benching"***, wrapped across a line break at `CLAUDE.md:1961` and invisible to a one-line sweep.
- **`check_fg`'s OWN COMMENTS STILL NARRATE THE MOVE TO 340.** Two of them (`check_fg.gd:46`, `:181`) say *"moving
  the ceiling to 340 took it red"*, which is true as history — it is FU's event — but they are the only remaining
  `340`s in the instrument layer and a later reader could take them for the live bar. Left as written: the gate holds
  no copy of the number that it reads, and a comment is not a copy.
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
2. **~~`CLAUDE.md` IS AT 336.31 KiB WITH 3.69 KiB OF HEADROOM~~ — CLOSED AT GY §1: THE CEILING IS 410 KiB.** *(The figure in this item was GX's mid-write reading; its own FOUND section and `docs/reports/GX.md` §6 both carry the landed 336.63.)* GX
   added 1.62 KiB by extending GT's sits-out block rather than opening a second one. `check_fg` §2 reads the file
   under its ceiling and prints no warning. **The file's own FU §1 / GR §2 block says the next batch at this ceiling
   is not looking for a seam**: what is left is card law, engine law and rune law, each written into by more batches
   than combat law was, so both remaining moves are the designer's — split a subject batches read often (rune law is
   named as the one that would come away cleanly) or re-derive the ceiling a second time. **The largest single-batch
   growth on record is +8.10 KiB, which is more than the headroom**, so the batch that meets this is the one that
   discovers it mid-write. Raised here rather than at the wall.
3. **~~GV'S AND GW'S DESIGN-NOTES ENTRIES ARE AT THE BOTTOM~~ — CLOSED AT GY §2, AND THE INSTRUCTION THAT SENT THEM THERE IS REPAIRED.** *(GY's census found the number is 73 others, not four: see GY's ruling 2.)*
   `docs/design-notes.md` carries two conventions: GP through GU sit at the top under `## <Title> (Batch XX) — <date>`,
   while GK, GM, GN, GO, GV and GW were appended at the foot under `## Batch XX — <title>`, below 9,000 lines of
   older notes. **The two instructions genuinely conflict** — the file's header says newest first and `CLAUDE.md`'s
   working agreement says *append* — so this is a ruling rather than a slip. GX's entry is at the top, per the
   header. **Moving the six is a pure block move and was not taken**: the brief asked for a small batch and said what
   was deliberately not done. Nothing asserts on position (the three suites that read this file ask only that their
   own batch's name is present), so the move is free whenever it is ruled.

### FOUND AT GX AND NOT FIXED

- **NINE ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GX head" (the
  rebuild of `07c6b99` the two sanctioned reds were diffed against) and eight named for their control — pouch,
  sheet, slot, slotword, note, predicate, unworn, rollcall. **Each was renamed before anything ran in it**, so its
  `user://` could not reach the player's saves. They can be deleted.
- **`docs/changelog.html` CARRIED THREE UNRESOLVED PLACEHOLDERS IN GW's ENTRY, AND THEY ARE REPAIRED.** The line
  describing the Shared Hide's three measured swings read *"THIN_SWING, MID_SWING and DEEP_SWING more damage from the
  same seeded blows"* — template tokens that resolve to nothing anywhere in the tree. They carry GW's own figures now
  (+26.5% / +57.6% / +138.3%, `docs/reports/GW.md` §1c), which is the intent the line was written to hold. **The
  sweep that found them is the population**: every `ALL_CAPS_WITH_UNDERSCORES` token in the nine tracked documents
  that resolves to nothing in `scripts/`, `data/`, the shell scripts or any other document, and appears in one
  document only — **three, all on that one line, and nothing else**. This is GS's twenty-four placeholder
  descriptions arriving in a document instead of in data, and **no instrument reads for the shape**.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (GX §0): ***"a benched card's tell"*** (a benched card has no tell; the
  tell GX copies is the SITS-OUT one, and `CLAUDE.md` states the distinction in those words — *"Sitting out is not
  benching"*); ***"+138% … needs a Warcry, an Empower and a Battle Shout"*** (it needs those three **and the Pivot** —
  four, GW §1c's table, which makes the ruling's own argument stronger); and ***"Sanctity's honest text"*** (no such
  queue item — what is queued for Sanctity is its **status-potency layer**, the largest unbuilt system the recon
  found; the Crown's Break and freeze resistance is owed, and the engine-card text items are GQ's rulings 1 and 2).
- **`CLAUDE.md` IS AT 336.63 KiB WITH 3.37 KiB OF HEADROOM** — GX added 1.62 KiB by extending GT's block rather than
  opening a second one, and `check_fg` §2 reads it under the ceiling with no warning. **The largest single-batch
  growth on record is +8.10 KiB, more than the headroom**, and the file's own block says there is no seam left; see
  ruling 2 above.
- **THE POUCH'S WORST CASE NOW MEASURES 543 px IN A 583 px SCROLLER.** GT sized the panel for a class's six engine
  rules; GX put a two-line sentence into rune rows that were one line. It still does not scroll and Close never
  moves, but **40 px is what is left**, and a further row of text on that panel is the thing to measure before it is
  added.
- **A GATE ARM OF GX's OWN WENT VACUOUS, AND ONE OF ITS OWN CONTROLS FOUND IT.** The map slot was read by the face
  it EXPECTED (`_button(mp, "○ " + name)`), so a button carrying the WRONG face was not found at all — the arm
  reported the absence and **the width assertion beside it never executed**. The `slotword` control, which puts back
  the face the §2 measurement ruled out, printed FAIL lines byte-identical to the control that simply deletes the
  tell: a control proving nothing. **The slot is found by the door it opens now** — every button bound to
  `_open_rune_panel(seat)` — and its drawn width is asserted **in both arms and on whatever it drew**, before its
  face is read. Proved two-armed on the same injection: *"the map's slot does not mark the rune as sitting out"*
  before, *"the slot drawing `Ambush — sits out` is 99 px wide, over the 96-px pitch"* after. The live widths (99,
  108, 118 px) also confirm §2's string measurement independently. **The general shape: an arm that locates a thing
  by the value it is about to assert can only ever fail by absence.** The gate went 955 → **1130** checks on the repair.
- **GX's OWN FIRST DRAFT SHIPPED A FUNCTION WITH NO CALLER AND A GATE CONSTANT WITH NO USE**, both written by this
  batch and both removed before the verification run: `Run.rune_id_by_name` (the screens read the id off the rune
  instance directly, so it was never needed) and `check_gx`'s `NO_LINEAGE`. Found by sweeping every name GX declared
  for a use beyond its own declaration, with comments stripped so prose naming a function did not count as a call.
- **AND ITS FIRST DRAFT OF THE LOG LINE WAS A FOURTH PHRASING.** It read *"— sits out, the Rune of the Occultist is
  not equipped"* — the same two facts in different words from the sentence the three screens show, which is exactly
  the thing this batch's own rule forbids. The tail is built from `Run.rune_sits_out_note`'s first two lines now, and
  `check_gx` §3c asserts it against that function, so the log cannot drift from the screens.

### GW's RULINGS OWED — **FOUR; THE FIRST TWO CHANGE WHAT A RUNE IS WORTH**

Full working: `docs/reports/GW.md`, NEEDS A RULING.

1. **THE SHARED HIDE IS NOW WORTH WHAT EZ PRICED IT AT, AND NOTHING HAS EVER PAID THAT.** The brief ruled the copy, so
   it is built — but what the ruling moves is a MAGNITUDE no player has ever felt. Driven in a real fight across EZ's
   own three buff loadouts, a companion's blow reads **+26.5% / +57.6% / +138.3%**, against a rune that has paid
   **+0.0%** since it shipped. The rune's text, price, terms and multiplier are byte-unchanged; a 100g rune has gone
   from dead to the largest single damage swing a Beastmaster can buy, and whether that is the intended price is the
   designer's.
2. **THE TWO PRICES ARE OFF WITH THE ENGINE OUT, WHICH MAKES AN UNEQUIPPED ENGINE STRICTLY BETTER THAN IT WAS.** Ruled
   by the brief and built. At the table: a Holy Cleric who unequips Mercy while wearing the Martyr can now be healed by
   his party, and a Survivalist who unequips Trapper while wearing Thin Blood keeps his poison's damage. Neither buys
   anything back — the payouts stay off — so each rune is **inert rather than negative**. Of GV's ruling 3's alternatives,
   **the second is taken at GX §1** — four surfaces say it is sitting out — and unequipping the rune with
   the engine is still untaken.
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

### FOUND AT GW AND NOT FIXED

- **`docs/master.html` HAD NOT LISTED THE TWO RUNES A COMPANION'S BLOW READS SINCE EZ.** Its companion bullet named
  Mark of the Hunt, Hunter's Mark, the Tracker's mark, Cripple and Chilled, and neither the Bared Fang nor the Shared
  Hide. Repaired. **That document's factual prose is asserted by nothing** (EH §2), and this is another instance.
- **GV's REPORT AND `docs/state.md` BOTH CALLED `check_ez`'s HAND-SET ARM "§4"; IT IS §5.** §4 is the payload section
  and its arms are sound. A closed report is a file class no instrument reads (FL §2c), so the misnumbering would have
  stood; it is corrected here rather than in GV's report, which is closed.
- **THE §2 SWEEP'S WRONG-BODY ARM IS A PIN ON TWO SITES, NOT A GENERAL RULE**, and the gate says so in its own words.
  *"Is this receiver a companion?"* is not a question a source sweep can answer — the receiver is a local bound three
  statements away — so the needle is the exact spelling the repair removed and the general guard beside it is the
  count ceiling. **Its first draft read 2 on a repaired tree** because `check_ez`'s new arm COMPARES that same
  spelling, and a substring needle cannot tell `==` from `=`.
- **A COMPANION'S DAMAGE CANNOT BE MEASURED OFF A WOLF OR AN INFLATED BODY**, and both were found by building the arm
  twice. A foe given a million health reads every percentage-of-health term at a million's scale (400,198 damage over
  twelve blows, a +0.0% swing); a Canis lays Bleed whose burst lands inside the same `await` and which the rune does
  not multiply (×1.19 against a multiplier of ×1.2500). **The bear is the one companion whose blow can be read alone.**
- **`rune_split_tongue` LOOKS LIKE AN ORPHAN AND IS NOT.** A first pass over `payload.stat` reported one of the 120
  fields written by no rune; it is Split Tongue's, written from inside an `also` block, which is the nested form
  `Talents.apply_payload` re-enters at the top. The rune is retired (FC §3) and its read site is deliberately kept and
  reachable by nothing.
- **ONE ISOLATED COPY PER CONTROL LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, each named "Dawn of Decay GW
  …" before anything ran in it so its `user://` could not reach the player's saves. They can be deleted.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (GW §0): *`check_ez` §4* (it is §5); and *this is the shape FA §1b already
  earned a rule for, pointed at gates rather than at briefs* — FA §1b is already about gates, and the §2 shape is
  adjacent to it but distinct, so it is written as its own block pointing at FA §1b.

### GV's RULINGS OWED — **THREE LEFT; THE FIRST AND THE FOURTH ARE ANSWERED AT GW**

Full working: `docs/reports/GV.md`, NEEDS A RULING.

1. ~~**A QUEUED ROW SITS OUT OF A CACHE'S ANSWER RATHER THAN BEING REPAIRED AWAY**~~ — **RULED AT GW §4, AS GV BUILT IT**, and the reasoning now stands beside it on the player-facing side too (`docs/master.html`): a retirement can never be undone, an unequipped engine is one press from being undone, and a state the player can undo is not a state to destroy. The working that follows is kept because it is the pricing of the alternative. FD's rule is that a
   frozen offer is re-asked at the answer and the repair is WRITTEN BACK; that is right for a candidate that can only
   get worse (retired, owned). An unequipped engine is the player's own reversible choice, so the row is kept in the
   stored triple, filtered out of the answer while the engine is out, and offered again when it is back — and
   `map_screen._pick_rune` indexes the list the buttons were built from. **The alternative is FD's literal form**: drop
   the row, top the triple up, store that — under which one toggle before answering a cache costs it those runes for
   good, and can spend the pick on nothing.
2. **THE GATE READS WHAT HE HAS EQUIPPED, AND THAT IS THE ONLY READING THAT GATES ANYTHING.** *(Its reason was the
   spec scope, which went at HC §1: a row reaches every hero of its class now, most of whom do not own its engine, so
   the equipped reading withholds far more than it did; the ruling asked for stands.)* A spec rune is offered by
   LINEAGE, the lineage is the engine taken at class selection, and nothing sells or discards an engine rune — so every
   hero who can be offered a row owns its engine all run, and an ownership gate would withhold nothing. **What the
   designer asked to be told**: a hero who unequips his engine is sold different runes at the Peddler (rolled as he
   stands, re-equipping before the visit restores them), a cache or bargain ROLLED while it was out never contains its
   rows at all, and an elite fought with it out drops a cache without them — the same reading the card draft already
   takes at a victory.
3. ~~**A BOUGHT RUNE WHOSE ENGINE IS DROPPED KEEPS ITS SLOT AND PAYS NOTHING**~~ — **ANSWERED AT GX §1, AND THE
   SECOND OF THE FOUR OPTIONS IS THE ONE TAKEN**: it sits out with a note, the way a card does. It still keeps its
   slot and still pays nothing — GX moved no magnitude — but four surfaces now say so and name the engine rune that
   brings it back, in GT's own sentence. **The other three stay untaken and stay priced below.** The original
   finding: GT ruled it for a CARD: it sits out and
   returns. A rune is bought with gold, and nothing was built for it here (§3 of the report): it stays equipped in one
   of the three ordinary slots, pays nothing (measured), and nothing on any screen says why. **Two are worse than
   nothing** — the Martyr still refuses every ally's heal and Thin Blood still stops his poison biting. The options,
   priced and not taken: leave it (the player unequips it himself, free, on the map), sit it out with a note the way a
   card does, unequip it automatically, or let it be sold.
4. ~~**THE SHARED HIDE PAYS NOBODY ANYTHING, ENGINE OR NONE**~~ — **WIRED AT GW §1**, and `check_gv` §1 said so exactly as GV promised it would: the row read 18 against 15 on BOTH engine arms in GW's pre-pass, which is also what moved it out of the table's `DEAD` group and into `CARD`. What GW §1 now owes a ruling on is the MAGNITUDE it turned on — see GW's ruling 1. The original finding: Found by driving it: the rune's field
   lands on the HUNTER and `_shared_hide_mult` reads the COMPANION, which never receives it, so a 100g rune multiplies
   a companion's blow by exactly 1.0000 for every hero who has ever bought it. Not repaired: the fix moves a magnitude
   (CQ §6). `check_gv` §1 asserts it dead in both arms, so the day it is wired the gate says so.
5. ~~**THE RUNE LAYER HAS THE NARROWNESS THE CARD LAYER AVOIDED.**~~ **RULED AND BUILT AT HC: THE RUNES MERGED THE WAY
   THE DRAFT POOLS DID** — class scope, three gates — and a second engine's runes arrive with it. The finding was: a
   hero who unequips his engine is offered none of his own five runes on four lineages of twelve, and a hero holding
   TWO engines is offered nothing of the second's lineage, because a rune's scope was the lineage.

### FOUND AT GV AND NOT FIXED

- **THE SIM BOT NEVER SEES THE GATE AT A CACHE'S ANSWER.** `run_sim` answers a rolled triple from the member's own
  array rather than through `Run.rune_choice`, so a sim measures the roll's gate and not the answer's. Sims only, and
  every sim party keeps its engine equipped.
- **`check_ez`'s SHARED HIDE ARM COULD NOT SEE THE DEFECT ABOVE**: it writes `rune_shared_hide` onto the BEAST by hand
  and then reads the multiplier, which is the one path a real run never takes. An arm that seats a rune on the hero and
  summons is what would have caught it.
- **FOUR HAND-BUILT LINEAGE HEROES CARRIED NO ENGINE RUNE**, which GK's rule already forbids, and the gate exposed all
  four at once (`check_es` §2, `check_fd`'s `_member` and §1e, `check_fo` §2b, `test_runes`' `_eligibility` and
  `_rich_grant`). Each is repaired; **five more hand-built seats in the same files carry none and ask questions the
  gate does not reach** (`check_fd` §1d's collision measurement, `check_et`'s, `check_fe`'s, `test_runes`' `_exhaustion`
  and `_start_rune_pool`), and they are left as they are rather than swept.
- **`check_gj`'s SANCTIONED RED MOVED ITS FIGURES AGAIN** — card +158 against a purse of +178, where GU recorded
  +169 / +189. The gap is still the Tollkeeper's Bell's 20 gold and the counts row did not move; what the gate's seeded
  run draws moves with the rune offers.
- **TWELVE ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GV copy", "Dawn of
  Decay GV head" and ten "Dawn of Decay GV ctl <name>", each renamed before anything ran in it so its `user://` could
  not reach the player's saves. They can be deleted.
- **THE BRIEF'S PREMISES THAT DID NOT HOLD** (GV §0): *the eleven old engines became runes* (fifteen — twelve lineage
  engines and three spines, GK); *a Deepening Hex offered to a Cleric without the Occultist rune* (only a Cleric of that
  lineage is ever offered it, and he owns the rune for the whole run — "without" can only mean unequipped); and FP's
  *43* is the population FP measured rather than today's.

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
- **TWO SHAPES THE SWEEP SET ASIDE, REPORTED WITH THEIR COUNTS.** 47 same-role pairs trade (under on one axis, dearer
  on another), which EB's ruling allows; 34 pairs read under on cost or cooldown against a card whose initiative is the
  buff cap, which EB leaves out. Among the second, **Mirror Image** sits 5 Mana under the kit's **Nexus Ward** at the
  same cooldown — both class-wide shields before GN, so it is GP's ruling 1 (the class-wide rebalance), not this one.
- **AGAINST THE ENABLERS RATHER THAN THE KIT**, the same shape finds **19 cards under an enabler (27 pairs)** — Arcane
  Explosion under the Pyromancer's Flamewave and Shadowrend under the Occultist's Hex of Ruin on all three axes, and
  most of the rest 5 Mana or Rage under, several of them against the Beastmaster's three summons. An enabler is only
  its engine's holder's, so none is in the population the brief named; `docs/reports/GU.md` §2 lists them.
- **QUICKENED NOW FITS SWEEPING STRIKES**, as it fits Crushing Blow: the upgrade takes two turns off a cooldown, so an
  upgraded copy is back at 0. Parity with the kit card holds; the upgrade layer is unchanged.
- **THE SIM BOT'S SWORDMASTER ROTATION** casts Sweeping Strikes whenever it is ready at three foes or more, so a
  Swordmaster sim holding it casts it at most one turn in three now. Sims only.
- **SIX OF THE BRIEF'S STATEMENTS DID NOT HOLD AS WRITTEN** (GU §0), none of them changing what was built: *Shadowrun*
  (Shadowrend); *GT did not retune them for that reason* (it did not retune them because the ruling named three); *three
  ways under* (against the kit's Mocking Blow it is one); *neither was a sweep* (`check_eb` §1 found GS's three and GT
  §2c swept the 29 returning cards — neither swept all 204); *`check_eb` is asking about the merged pools* (it asked the
  lineage shelves, repaired); and *GT drove its three* (`check_gt` §4 compared their data; `check_gu` §4 drives them).
- **FOUR SAVE FILES EXIST NOW, WHERE GT FOUND THREE**: a run is in progress (`run_save.bin`, written after GT), and
  `profile.json` changed since GT's backup. All four were backed up and hashed before anything ran.
- **TWO CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GU copy" and "Dawn of Decay
  GU ctl", each renamed before anything ran in it so its `user://` could not reach the player's saves. They can be
  deleted.

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
3. ~~**BATTLE POISE AND SHATTERPOINT ARE A SEPARATE CASE, NOT THIS RULING'S.**~~ **RULED IN GU's BRIEF: both stay
   as they are**, and `CLAUDE.md`'s sits-out block carries it. Both are cards (not runes), both cast and
   do their own work with no engine, and only a second clause needs another card: driven on a Warrior with no engine,
   Shatterpoint breaks its target either way and adds its free Overpower (68 damage against 16) only with Overpower
   carried; Battle Poise, reached through a drafted Feint, pivots on a parry only with Guard Change carried. A card that
   half-works is GM's untouched group. Paying the clause without the card would change what the card gives.
4. ~~**THE SAME SHAPE ON THREE MORE RETURNING CARDS, OUTSIDE EB's CONTROL.**~~ **ANSWERED AT GU §1** — two former
   basics and a swap whose quickness is its point, none retuned; what is still owed is GU's rulings 1 and 2. Under EB's control (same role, same
   initiative) only the three are inverted. Dropping the role control, the other two former basics are cheaper and
   shorter than a kit card at the same initiative — **Arcane Explosion** against Magic Missiles (an area attack against
   a single-target one) and **Shadowrend** against Ministration (a strike against a heal); dropping the initiative
   control, **Guard Change** (0 Rage, cooldown 1, 1.5) is cheaper, shorter and faster than Crushing Blow and Pommel
   Strike. Not retuned — the ruling named three.

### FOUND AT GT AND NOT FIXED

- **PLAYER-FACING: A ZONE BOSS CAN OFFER A CARD THAT WILL SIT OUT.** The boss pick draws the hero's LINEAGE pool with no
  engine filter (`Run.roll_spec_ability_offer`), so an Arcanist who dropped Resonance can be offered Stabilize, which
  sits out until the rune is back. The draft's engine gate never offers one (`Classes.offerable`); the boss pools were
  never merged or gated (GP).
- **ENGINE-HEAVY PEDDLER DEALS SCROLL.** Four offers of every class's shortest engine rule stack 500 pixels in the
  470-pixel column and the longest 799; every Buy button is reachable and none is covered. Widening the column further
  would push it off the screen's edge.
- **SIX OF THE BRIEF'S PREMISES DID NOT HOLD, AND ONE CHANGED WHAT WAS MEASURED** (GT §0): *a hero holds two* (he slots
  two and can hold six, and the pouch shows all); *GS did not sweep for the shape* (`check_eb` §1 sweeps every shelf
  card under EB's control every battery and read three); *a rune granting a free cast* (Battle Poise and Shatterpoint
  are cards); *the Peddler spills* (worse: all four Buy buttons unusable at the longest); *three cards* named for §3
  (seventeen cannot be cast without their engine); *four saves* (three exist; no run was in progress).
- **TWO CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GT ctl" and "Dawn of Decay
  GT probe", each renamed before anything ran in it so its `user://` could not reach the player's saves. They can be
  deleted.

### ~~GS's RULINGS OWED~~ — **ALL FIVE CLOSED AT GT**

1. ~~Three enablers proposed~~ — **ruled: Razor Ice, Divine Shield and Hex of Ruin stand** (GT's brief §4).
2. ~~Bloodlust costs the Berserker no slot~~ — **ruled: it stays outside the slot count** (GT's brief §4).
3. ~~The rule text fits neither the Peddler nor the pouch, and the pouch can strand the player~~ — **built at GT §1.**
4. ~~Four basics changed under four lineages~~ — **ruled: the changes stand** (GT's brief §4).
5. ~~Three returning cards invert EB §1's baseline~~ — **ruled and built at GT §2.**

### FOUND AT GS AND NOT FIXED

- ~~**A CARD THE ENGINE GATE OFFERS ONLY TO ITS HOLDER STAYS WHEN THE ENGINE IS DROPPED, REFUSED.**~~ **BUILT AT GT §3**:
  it sits out while the engine is gone, and the population is seventeen, not three.
- **TWO CARDS' SECOND CLAUSES NOW NEED A DRAFTED CARD** — Battle Poise's free Guard Change and Shatterpoint's free
  Overpower. **GT drove both and reports them a separate case** (GT's ruling 3). The talent branches that also answer
  with Overpower or Pommel Strike read fields nothing writes since FX.
- **FOUR ENGINE RULE TEXTS NAME CARDS THAT NO LONGER TRAVEL WITH THEM**, and every rune surface shows those texts now:
  Seasoned Fighter's *"Guard Change swaps"*, Glacial Hold's Ice Lance, Shatter and Blizzard, Mercy's *"Stacks pay for
  Hymn of Hope"*, Conviction's *"doubled under Blessing of Zeal"*. No engine text moved (§4).
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
- **SIXTEEN OF THE SEVENTEEN LIVE RUNES THAT NAME A CARD NAME ONE OUTSIDE THE SPAWN KIT** (ten until GS): Open Wound,
  the Split Shield, Butcher's Bill, Cold Snap, Open Line and Grace are offered only once their card is drafted. Only
  Layered Aegis (Divine Shield) is reachable at spawn.
- **THE CLASS-SELECTION SCREEN FITS, AT 711 OF 720** on a Warrior's (GQ's lowest was 691): the kit below the cards
  prints Pommel Strike where it printed Bloodlust. The figure note GQ built is owed on 20 of 80 deals now — the Warden's
  ten and, new, the Occultist's ten.
- **INSTRUMENTS, NONE A VERDICT CHANGE:** `check_gp` §4's engine-less road picked up engine runes on GS's seeded walk
  (it answers every rune pick with the first button) and read the game working as a leak — it unslots them through
  the pouch's door now; `test_batch_bp` §7's bench pair named two cards a Swordmaster can now be dealt, a red about
  one run in twenty, re-pointed at his protected opening; and `test_batch_bw`'s *"against every opening kit"* loop
  walks the four class keys, which define nothing, so it has checked nothing since it was written (not repaired).
- **THE RETIRED RUNE OF THE LAST RITES STILL SAYS *"She already knows Resurrection"***; since GS a Holy who has not
  drafted it is granted it. It is never offered.
- **SEVEN OF THE BRIEF'S PREMISES DID NOT HOLD, AND ONLY ONE CHANGED WHAT WAS BUILT** (GS §0): *fifteen* lineage
  engines (twelve), *most will come down to one card* (six carry one, eighteen none), *twelve and fifteen* placeholder
  texts (twelve and twelve), *Flame Wave* (Flamewave), *the screens show nothing more* (they showed the placeholder and
  then the rule), *Heavy Plating and the stances bring nothing already* (each brought cards), and *pay one slot* (not
  built — ruling 2). **And GK's sixteen enablers were the smaller half**: a lineage also opened with its whole kit.
- **ELEVEN CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GS ctl", "GS head", "GS
  trace", "GS rep G1" to "G5", "GS rep G4probe", "GS rep G5 ctl" and "GS rep G5 head", each renamed before anything ran
  in it so its `user://` could not reach the player's saves. They can be deleted.

### GR's RULINGS OWED — **ONE LEFT; THE SECOND IS CLOSED AT GY §1**

Full working: `docs/reports/GR.md`, NEEDS A RULING.

1. **`docs/combat-rules.md` HAS NO STATED CEILING**, like `docs/instrument-rules.md`. EE's method on its own record —
   the file as split, 29.73 KiB, plus ten of the largest single-batch growth its nine blocks have ever had (+4,340 B,
   the crit rule's birth at EW) — gives 72.11 KiB, stated **70 KiB**. It has grown +19.5 B a batch since FF, so the
   figure is the designer's to adopt or not, not a wall anyone is near.
2. **~~THE NEXT CEILING, AND BOTH MOVES LEFT FOR IT~~ — RULED AND TAKEN AT GY §1: THE CEILING IS RE-DERIVED, RUNE LAW STAYS.** At FF's +4,315 B a batch `CLAUDE.md` meets 340
   again in about 5.1 batches, at the +2,247 B its main half has grown since FF in about 9.8. There
   is no fourth seam that batches read rarely: card, engine and rune law are what is left, and each is written into by
   more batches than combat law was. **Rune law would come away cleanly** — 14 of its 15 blocks, 34.25 KiB, bind
   nothing else — **and the merge's rune step reads it every batch.** The other move is a second re-derivation of the
   ceiling, which `CLAUDE.md` says moves with the file. **Better ruled with headroom than at the wall** (EF §2).

### FOUND AT GR AND NOT FIXED

- **SIX OF THE BRIEF'S ATTRIBUTIONS NAME THE WRONG BATCH, AND NONE WAS LOAD-BEARING** (GR §0): the 340 KiB ceiling
  is FU's raise of EE's rule; the one-way tiebreak and *what a rule binds, not what it is about* are EF §2's, which FF
  applied; the nine blocks that stayed on it were EF's nine; *rewording the rule reds, rewording the index does not*
  was EF's control pair; the instrument half growing twice as fast over five batches was EF's reading, and **FF had
  already settled it over twenty-five** (EF→FE); and **`check_fg` holding a copy of the last figure was FU's finding
  (FU §1b), not GQ's.** The measurements the brief asked for were taken either way.
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
- **ONE CONTROL COPY LEFT A USER-DATA FOLDER** under Godot's `app_userdata`: "Dawn of Decay GR ctl", renamed before
  anything ran in it so its `user://` could not reach the player's saves. It can be deleted.

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
3. ~~**`CLAUDE.md` IS PAST ITS CEILING**~~ — **RULED BY THE DESIGNER AND TAKEN AT GR**: the subject seam, and combat
   law moved to `docs/combat-rules.md` (GR's block above).

### FOUND AT GQ AND NOT FIXED

- ~~**`CLAUDE.md` CROSSED ITS 340 KiB CEILING AT GP: 348,868 B = 340.69 KiB**~~ (GP added 3,894 B, from 344,974). `check_fg`
  §2 prints its CEILING WARNING and passes; **it FAILS past 356,454 B — 7,586 B away**, less than one large batch's
  rules. The subject seam below was carried as *"owed a ruling before the file reaches 340 KiB"*, and the file has
  reached it. GQ added nothing to the file. **CLOSED AT GR by the subject seam: the file is 318.54 KiB.**
- **PLAYER-FACING, MET ON THIS SCREEN FIRST: FOUR KIT TEXTS BREAK THE TEXT STANDARD.** Ministration's *"No stacks, no
  shields, no marks — it simply works"* and Magic Missiles' *"Cheap, certain, and it never needs anything to be true
  first"* are design rationale on a card; Magic Missiles restates *"12% of Attack each"* beside the line that prints it;
  **Nexus Ward's and Ministration's 20% are plain text, not tokens**, so no surface resolves either to a number. A kit
  card's text was outside GQ.
- **`Classes.ARCHETYPE_DESC` AND THE TWELVE `SPEC_INFO` BLURBS HAVE NO READER IN THE GAME.** Kept: a structure orphaned
  by a ruling is a design question (`CLAUDE.md`, DV §1). The archetype field itself is live — it sets a lineage's Attack.
- **THE HUNTER'S CLASS PASSIVE AND A HUNTER RUNE ARE BOTH *TRACKER*,** and on a deal holding the Rune of the Tracker the
  two stand one above the other on this screen. GO's ruling 2, re-observed.
- **FOUR OF THE BRIEF'S PREMISES DID NOT HOLD, AND ONE HELD ONLY IN EFFECT** (GQ §0): *the one paragraph that differs*
  (half the runes add cards); *Vanguard, Invoker, Hierophant and the Hunter's three bring no enabler* (the rule-alone
  cards are the spines and all nine rule engines, and the test is the lineage, not the enabler); *the class passive
  that is already there* below the cards (it is above them); *`check_map_screen` reads this surface* (it never draws it);
  and *Heavy Plating changes his stats* (the Warden lineage's stat block does).
- **`check_gj` §4's SANCTIONED RED READS CARD +172 AGAINST A PURSE OF +192**, on GP's own commit and on GQ's code alike —
  once on GP's, four times on GQ's, identical every time — and this gate never draws the class-selection screen. **GP's recorded +177 / +197 does
  not reproduce on the commit that recorded it.** The gap is still the Bell's 20 gold and the counts row did not move;
  the figure is corrected where it was written (`baselines.json`, and GP's bullet below).
- **ONE CONTROL COPY LEFT A USER-DATA FOLDER** under Godot's `app_userdata`: "Dawn of Decay GQ ctl", renamed before
  anything ran in it so its `user://` could not reach the player's saves. It can be deleted.

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
- **EG's 53–55% OFFER-AT-CAP FIGURE IS STALE, AND GP IS NOT WHAT MADE IT STALE.** Re-measured at rung 2 over four
  `--run 25` sims the same day: **74% and 76% after the merge, against 73% and 74% on HEAD.** The merge moves it by
  nothing. The drift predates this branch — the class kits take three of seven slots since GN, so a hero reaches his
  cap far sooner. **A batch pricing work against 53–55% would be pricing it against a number the game stopped
  producing.** What the merge DOES move is the two short-offer figures, and it takes them to zero: a pool that came up
  short 0.24–0.40 times a run and had nothing left to offer 0.04–0.08 times a run now never does either.
- **THE DEBUG "ALL SPEC ABILITIES UNLOCKED" TOGGLE STILL GRANTS A LINEAGE SHELF** (`battle.gd`'s `granted_pool`), not
  the class pool. Its scope was the spec and still is; outside the brief.
- **`check_gj` §4's SANCTIONED RED MOVED BY ONE GOLD** — card +177 against a purse of +197, where GN recorded
  +178/+198. GP's code moves what the gate's seeded run draws; the Tollkeeper's Bell defect itself is unchanged.
  **CORRECTED AT GQ: it reads +172 / +192 on GP's own commit** (FOUND AT GQ, above).
- **ONE CONTROL COPY LEFT A USER-DATA FOLDER** under Godot's `app_userdata`: "Dawn of Decay GP head", renamed before it
  ran so its `user://` could not reach the player's saves. It can be deleted.
- **TWO OF THE BRIEF'S PREMISES DID NOT HOLD** (GP §0): *"a hero draws from ~24 cards instead of 8–10"* is wrong on
  both sides, and *the class-wide pool existed because spec pools were narrow* is not the reason the code records.

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
4. **WHAT THE BASTION BANKS.** Every cut the prevented-damage ledger books while the strike names him, the block (the
   whole nominal blow), any barrier's absorb, armor and resistance — whoever's work it was. A miss banks nothing; a
   blow cut to nothing, an absolute parry and an absorbed blow each bank the whole blow. The bank lasts the fight, and
   only a basic attack that lands spends it, after armor.
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

### FOUND AT GO AND NOT FIXED

- **A KILL, A WOUND OR A RETURN MADE INSIDE AN ENEMY'S OWN SWING IS FILED TO THAT ENEMY.** Tripwire's retaliation, a
  Feint's reflect and a Mirror Guard return deal their damage under the enemy's attribution frame, so the Reaver does
  not count the kill, the Leech returns no Mana, the Arbiter heals nobody and no mark is laid off them. Measured: in a
  party with no lineage, 7 of 74 kills were filed to an enemy's frame (GO §1a).
- **"QUARRY" IS ALREADY A PLAYER-FACING WORD** — Quarry's Mark's chip reads it. The engine name stays internal; a
  player reading *Quarry* sees the Sharpshooter's card.
- **EIGHT OF THE BRIEF'S PREMISES DID NOT HOLD** (GO §0) — among them *none accrues anything* (Heavy Plating's climb
  does), *the only engine that reads kills* (Lethal Aim's kill branch, outside the Warrior's six), *nothing repeats a
  cast* (Rampage and four more), and *Rune of Ambush … FK authored* (it is EZ's, and live).
- **FOUR CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GO probe", "Dawn of
  Decay GO inject", "Dawn of Decay GO head" and "Dawn of Decay GO trace". Each was renamed so its `user://` could not
  reach the player's saves. They can be deleted.

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
8. **CRUSHING BLOW IS ON EVERY WARRIOR NOW, AND THE ORC CHIEF'S ABILITY SHARES ITS NAME** (`docs/text-audit.html`
   §CK, a designer question since CK). Its dormant Elemental Weakness rider (`elem_weak_ranks`, no writer) stays
   dormant.

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
- **THE WARRIOR'S OTHER ENGINE-ONLY BOT CASTS STAY** — Wildstrikes, Shieldwall and Guard Change are not kit cards.
- **`check_fh` §3's cache can deal an ENGINE rune**, which takes an engine slot rather than the pouch; the gate counted
  the pouch alone and read "no rune arrived" on GN's seed (repaired to count both).
- **THREE CONTROL COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`: "Dawn of Decay GN new", "Dawn of Decay
  GN head" and "Dawn of Decay GN ctl". Each was renamed so its `user://` could not reach the player's saves. They can
  be deleted.

### GM's RULINGS OWED — **SEVEN, ALL PLAYER-VISIBLE**

Full working: `docs/reports/GM.md`, NEEDS A RULING.

1. **WHAT ELSE LEAVES WITH AN ENGINE.** Built: the three opening-kit cards the usability door refuses without it.
   **Not built, and each is its own question:**
   - **the lineage cards that half-work without their engine** — eight opening-kit cores by GL's test (Wildfire,
     Arcane Cannon, Renewal, Blessing of Zeal, Hunter's Instinct, Aimed Shot, Hold Breath, Shrapnel Charge). GL's
     five whose payload sits in the engine's block are a different cut, and four of those five are EARNED zone-boss
     cards. **MOOT FOR THE EIGHT SINCE GS §1: none opens a kit now.** All eight are drafted off their lineages'
     shelves, offered to any hero of the class (GP's HALF-WORKS group is not gated), and earned, so they stay;
   - ~~**the earned cards the door refuses without their engine**~~ — **RULED AND BUILT AT GT §3: such a card SITS
     OUT while its engine is gone.** GT asked the door about all 204 earnable cards: **seventeen** cannot be cast
     without their engine (`Classes.SITS_OUT`), and GM's list was wider than that — Battle Poise and Counter Time open
     on a drafted Guard Change, and the Beastmaster's companion cards on an earned Call the Wilds, so neither sits
     out.
2. **~~"EXACTLY AS ITS ENABLER DOES" HAS TWO MORE HALVES, AND NEITHER IS BUILT~~ — MOOT AT GS §1.** No lineage opens
   with a bound card and no lineage takes a slot: Death Ray is a draft card offered to a Resonance holder of any
   lineage, and an Arcanist opens at three slots like every hero. GM's record: an enabler travels to another hero who
   takes the engine and sits outside the slot count, and a bound card did neither.
3. **~~KILL COMMAND CAN BE CAST WITHOUT PACK BOND~~ — ANSWERED AT GS §1, BY THE SAME FACT.** An earned Call the Wilds
   summons a companion with no engine, which opens Kill Command's door; GM sent it out with the engine because the
   ruling named it. **It is a Beastmaster-shelf card now and is NOT gated**, so any Hunter can be offered it —
   conditional on a card, GP's Battle Poise shape.
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
- **TEN LIVE SPEC RUNES ARE READ ONLY UNDER THEIR LINEAGE'S ENGINE** — Ember Leap, Pyre Debt, Half Note, Overtone,
  Resonant Core, Carried Mercy, Keen Focus, Standing Wall, Naked Blade and Whetstone — so each pays nothing to a
  lineage hero who dropped the engine, **and a rune's scope is the lineage, so he is still offered them.**
- **NOTHING LISTS WHICH STATUSES THE HEROES LAY ON AN ENEMY.** GM's census of them was static and read by hand, and
  `check_gm` §4 drives the three it found; a fourth authored in neither list would pass until it was played into.
- **THE SIM BOT'S DRAFT WRAPPER CANNOT SEE MANA SHIELD.** It casts a card only if `Classes.draft_ability` resolves it,
  and Mana Shield — a vault card re-homed into the Mage's class pool at DY — does not.

### ~~THE CLASS KIT~~ — **BUILT AT GN; RECON'D AT GL (`docs/kit-recon.html`); WHAT THE RECON LEFT OPEN**

Full working: `docs/reports/GL.md` and `docs/reports/GN.md`.

1. **~~WHICH THREE, FOR EACH CLASS~~ — PICKED WITH THE DESIGNER AND BUILT AT GN** (the WHERE block above). What the
   recon said no passing card guarantees still stands of the twelve: the Warrior guards the others only with Mocking
   Blow's taunt, and the Hunter kit carries no heal, shield or cleanse for another hero.
2. **~~WHERE A PICK COMES FROM~~ — MEASURED AT GN.** The five class-wide picks left their pools: the Mage's reads five
   and the Cleric's three. The six cores are still in their lineages' opening kits, held once — **until GS §1, which
   left every lineage opening with its enablers alone, so no kit card is in one now.**
3. **THE CLASS-WIDE CARDS WERE AUTHORED WEAKER THAN SPEC CARDS** (`classes.gd`'s pool header), and EB §1 ruled the
   protected core is the baseline — **the Mage's and the Cleric's kits hand that role to fallback cards.** GN's
   ruling 7.
4. **~~SALVAGE THAT IS AUTHORING~~ — MOOT:** none of Hymn of Hope, Resurrection, Arcane Cannon or Hold Breath was
   picked.
5. **~~TWO VERDICTS HAVE TWO READINGS~~ — MOOT FOR THE KIT:** Ministration was picked and heals 20% of its target's
   maximum on a Cleric holding no engine (driven, `check_gn` §1). Divine Shield was not picked.
6. **~~THE BOT NEVER CASTS THREE OF THE 64~~ — TWO CLOSED AT GN:** Powershot is the Hunter kit's and the class branch
   casts it; Tripwire was the kit's until HB, and the drafted hook casts it since. **Mana Shield is still never cast** (GM's item above).

### FOUND AT GL AND NOT FIXED — **FOUR CLOSED AT GM: HOLD BREATH, THE DEAD BUTTONS, SPLIT SHIELD AND DISPEL; THE BOT'S KIT CARDS AT GN**

- **~~PLAYER-FACING, AND AN EXPLOIT: HOLD BREATH NEVER RUNS OUT FOR A HUNTER WITHOUT LETHAL AIM~~ — CLOSED AT GM §1:
  the spend sits under the payout's gate, and `check_gm` §1 drives it with the engine and without.** GL's record: The countdown that
  spends `held_breath` sits inside `battle.gd`'s `has_engine("lethal_aim")` block (12186 → 12228), so after one cast
  every damaging attack is a guaranteed critical that ignores armor for the rest of the fight (9155, 10452-10456). A
  Sharpshooter who unslots his rune keeps Hold Breath (GK §5's table shows its chip standing). **Driven in a scratch
  probe** (`docs/reports/GL.md`): six Quick Shots after one cast, the status standing after every one, the mean hit
  15.0 → 26.2; with Lethal Aim held, the first shot spends it.
- **~~PLAYER-FACING: THREE LINEAGE CARDS BECOME BUTTONS THAT CAN NEVER BE PRESSED WHEN THE ENGINE IS DROPPED~~ —
  CLOSED AT GM §2: they leave with the engine (the designer's ruling); the bare label survives on Divine Plea. REOPENED
  FOR TWO OF THE THREE AT GS, BY A DIFFERENT DOOR**: no lineage opens with any of them, and a Death Ray or a Resurrection
  DRAFTED under its engine stays when the engine is dropped, refused (FOUND AT GS, above). GL's
  record: — Death Ray
  (below 8 Resonance, `battle.gd:6469`), Resurrection (1 Mercy, 6152; its label reads a bare "1", 6572-6573) and Kill
  Command (no companion, 6157-6159). GK's lineage interim keeps all three in the kit. Driven: each refused in an
  engine-less kit, Resurrection with a hero down. It widens GK's ruling 5.
- **PLAYER-FACING: LINEAGE CARDS THAT HALF-WORK WHEN THE ENGINE IS DROPPED — STILL OPEN; GM's RULING 1.** Only
  Shrapnel Charge was in an opening kit, and since GS §1 none is — it is drafted off the Survivalist's shelf; Hamstring, Venom Coating, Pinning Shot and Called Shot are EARNED zone-boss
  cards. Their payload sits inside the engine's block: Shrapnel Charge's Poison, Hamstring's Slow and Exposed and Venom Coating's poison inside Trapper's
  (`battle.gd:12059-12079`); Pinning Shot's Daze and Called Shot's rider inside Lethal Aim's (12214-12227).
- **~~PLAYER-FACING: THE SPLIT SHIELD RUNE DOES NOTHING IN A FIGHT~~ — CLOSED AT GM §3: the cast reads the table,
  and `check_ez` §5 casts the card.** GL's record: A live 100-gold Warden rune:
  `rune_split_shield` is read only by the recast table (`battle.gd:5945`), and Shieldwall's cast (20902) never splits
  the wall — driven: the cast laid 25 on the Warden and covered no ally, the table proposed 12. **`check_ez` §5 drives
  the table, not the cast**, and its comment says the two are one answer — a gate green over a dud since the rune was
  authored.
- **~~DISPEL STRIPS THE PARTY'S OWN MARKS~~ — CLOSED AT GM §3, ON THE CARD TEXT'S AUTHORITY (GM's ruling 5).**
  GL's record: `party_mark` (Hunter's Mark), `rime` and `arcane_echo` are in neither
  `DEBUFF_IDS` nor `DISPEL_NEVER`, so `_dispellable_buffs` (`battle.gd:7763-7770`) hands them to a Mage's Dispel on an
  enemy — the trap `DISPEL_NEVER`'s own comment describes. Driven: a Hunter's Mark laid, a Mage's Dispel on that
  enemy, and the mark gone.
- **DIVINE SHIELD'S RECAST PROPOSAL IGNORES THE BARE ALTAR RUNE**, which halves the cast (`battle.gd:17157-17158`); the
  table proposes the full 35% (6064), so a wasted recast reads as an improvement. CR §3's rule, one live rune along.
- **PLAYER-FACING: THE CLASS BASICS ADVERTISE A PERFECT NONE OF THEM CAN REACH** — Strike, Magic Bolt, Smite, Quick Shot
  and the overrides in slot 0 (none since GS §1: the four are drafted, sit past slot 0 and run the bar) resolve at a fixed Good (`battle.gd:4118-4119`), while the battle tooltip and the hero
  sheet print their Perfect lines. A Lethal Aim holder's Quick Shot is the one exception. **`test_batch_bo` §5 passes
  them**, because it asks `runs_skill_check()` and the cast path asks slot 0.
- **PLAYER-FACING: CARD TEXTS THE CODE CONTRADICTS**, each in its class section of the recon: Charge's one-turn Daze
  never acts (it ticks off at the target's turn start, `battle.gd:3295`, before any miss roll) and its Perfect has no
  code; Cleave's Perfect has no code; Battle Trance and Mana Well pay three turns in four (their ticks run after
  `tick_statuses`); Chastise's Perfect says 30 Break damage and pays 25; Frostbolt's, Razor Ice's and Blizzard's
  "hold" is the engine's; Divine Shield names "the Devout's" health and Dark Pact "the Occultist"; Hymn of Hope, Dark
  Pact and Resurrection say *ally* and reach heroes only; Renewal and Undying Vigil on a companion do nothing; Kill
  Command's "both companions" names a mode nothing writes (`the_pack`); Arcane Explosion's "Builds 1 Resonance".
- **THE SIM BOT CASTS SEVERAL CANDIDATES ONLY INSIDE ENGINE BRANCHES — THE KIT CARDS CLOSED AT GN:** the class
  branch (`_bot_class_kit_pick`) casts Mocking Blow and Pommel Strike for any Warrior (Bloodlust until GS §2, and the
  Berserker rotation casts it again), and Powershot for any Hunter (Summon Companion too since HB, for any Hunter who
  holds it; Tripwire until HB, cast by the drafted hook since); **Wildstrikes, Shieldwall and Guard Change are not kit cards and stay engine-only.** GL's record: (Bloodlust,
  Wildstrikes, Mocking Blow, Shieldwall, Guard Change — `battle.gd:4656-4760`). A class kit owes the bot a class-level
  branch, or a sim never plays the kit. **GM SHARPENED IT:** those five are the only candidates the bot casts solely inside an engine
  branch, all of them the Warrior's — the Mage, Cleric and Hunter branches key on the card, not the engine — and
  **Powershot, Tripwire and Mana Shield are never cast by the bot at all.**
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
   dropped"*.
4. **An engine rune's cost** — the flat 100 gold until one is set.
5. **The lineage interim** — a hero who drops his lineage's engine keeps its name, stats and pools. **GL found what
   else he keeps**: Death Ray, Resurrection and Kill Command, which can then never be cast, a Hold Breath that never
   runs out, and five lineage cards that half-work (GL's findings above). **GM closed the first two** — the three
   leave with the engine (ruled) and the breath is spent — **and the rest is GM's ruling 1.** **Since GS §1 the
   interim holds its name, stats and boss pool and no card at all**: a lineage opens with its enablers alone, and they
   leave with the engine.
6. **Heavy Plating's base is a stat** — the Warden's 0.10 Block stays with the lineage, so another Warrior's plating
   climbs from zero plus its own slice.
7. **~~A hero who takes a spine opens with his class's basic attack alone~~ — BUILT AT GN:** he opens with his basic
   and his class kit of three, four abilities (`check_gn` §3 drives it from class selection into the first battle).
8. **~~The Hunter is dealt all three of his three~~ — CLOSED AT GO:** every class deals three of six.
9. **No engine rune carries a tag** — `check_ek` exempts all twenty-four as a set.

### WHAT GK LEFT BROKEN

- **Nothing it broke.** The repaired battery reads green but for `check_cm_live`'s standing sanctioned red (13 / 4, unchanged since before GK). Every row GK moved is in `baselines.json` with its reason.
- **What GK left undone is not broken:** the nine engines, the pool merge, the engine-reading runes and cards, engine rune costs — `docs/reports/GK.md` §4 — and the rulings above.

### FOUND AT GK AND NOT FIXED

- **`save-backups/` is untracked and not ignored.** Every batch's player-save backup since FR sits there; each batch
  staged by path, so none was ever committed, and a `git add -A` would commit them all. One `.gitignore` line.
- **`check_fm` §2a's second arm is inert**: it names *"wait on cards they have not drafted"*, which the game no longer
  prints (*"wait on abilities they have not earned"*); the check is an OR, so it passes on the other arm or on neither.
- **Two comments in `battle.gd`** (DT's companion census) still name a companion's `passive_id`; it is `engines` that is
  empty now, and the arithmetic they describe is unchanged.
- **Five four-hero parties in the instruments seat a lineage on another class's seat** — all artificial; none reaches a class-keyed draw (a static sweep at GK), and the one that did is repaired.
- **`test_batch_an` read its band's floor exactly (6,046)** on GK's repaired tree; the band is unchanged.

### EVERY COMPLETION FIGURE DATED BEFORE GJ EXCLUDED THE FINAL FIGHT — **RE-MEASURED AT GJ, BOTH WAYS**

- **Until GJ the sim ended every run at the third zone boss**, so a "completion" was a run that killed the third zone
  boss — encounter 48 of 49, never the end boss. **That is what EN's 97 / 3 / 0, EO's and EP's arms and every
  completion quoted since measured.** They stay readable as that: they are not wrong, they are a different count.
- **The three rungs untalented, 150 runs a rung** (`DOD_SIM_ROWS=0`, the balanced route, the standard four specs —
  EO's method), both counts off the same runs:

  | rung | to the third zone boss (what "completion" meant before GJ) | to the end boss (GJ) | end boss met / stopped the run |
  |---|---|---|---|
  | 1 Wanderer | 93% (±4.0) | 93% (±4.0) | 140 / 0 |
  | 2 Warden | 5% (±3.6) | 5% (±3.6) | 8 / 0 |
  | 3 Ruin | 0% (±0.9) | 0% (±0.9) | 0 / 0 |

- **THE DELTA IS ZERO, AND THAT IS THE FINDING.** The end boss stopped none of the 140 runs that reached it at rung 1 and none of the 8 at rung 2, and at rung 3 no run reached it — so counting the final fight moves no rung's completion by a run. Every pre-GJ untalented figure also reads as a completion to the end boss at these rungs; what it never measured was a question an untalented party could fail at the end, and there is none. The drives say why (the finding under GJ below): the end boss acts once or twice before it is Broken and held.
- **THE CONTROL:** HEAD's sim, which stops at the third zone boss, read **89%** at rung 1 over 150 runs
  on the same day, beside GJ's 93% to the third zone boss — the old count reads the same through the new sim.
- **THE RUNG-1 SPLIT:** with only §3's floor taken back out of GJ's code, rung 1 reads **94%** to the end
  boss (met 141, stopped 0). The gap to 93% is what the end boss's full strength costs on the
  first rung; the gap to the third-zone-boss count is the final fight itself.
- **NOT RE-MEASURED, BY THE BRIEF'S SCOPE:** EP's rows-3 and rows-9 arms, EV's, FV's and every other arm. Each stays a
  third-zone-boss figure until a batch re-reads it.

### GJ's RULINGS OWED — **THREE, ALL PLAYER-VISIBLE**

1. **WHICH READING OF "THE END BOSS IS NOT SCALED BY THE DIFFICULTY MULTIPLIER".** Built: the rung may not DISCOUNT
   it (`maxf(mult, 1.0)`), which keeps rungs 2 and 3 bit-identical as the brief required. The other reading — the
   rung term taken off outright, rung 2's values at every rung — would take rung 3's x1.30 off the end boss (1,910
   health against 2,490, Attack 334 against 434). It is one line either way (`Run.end_boss_mult`).
2. **THE RUNG-1 WORDS ARE PROPOSED.** The draft screen's Wanderer tooltip reads *"Enemies at 50% strength, the end
   boss at full."* where it read *"Enemies at 50% strength."*, and the glossary's road entry *"its enemies hit half
   as hard - all but the END BOSS - "*. Each was a claim §3 made false.
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
- **TWO OF THE BRIEF'S PREMISES DID NOT HOLD** (GJ §0): a whole run is not longer than anything in the battery
  (`check_gj` plays one in under a minute; `check_fx` and `check_map` run five to six), and no gate reads the sim's
  output — sixteen targets read `run_sim.gd`'s source text and `test_run_harness` calls two of its setup functions,
  and none runs a `--run`.

### ~~THE END BOSS HAS NO BUTTON~~ — **CLOSED AT GI ON `class-merge` ONLY; ITS LABEL CONFIRMED AND ITS INSTRUMENT GAP CLOSED AT GJ; TWO WORDINGS STILL OWED**

- **Fixed, on this branch only (ruled).** `map_screen._draw_lattice`'s width and both loops read `Run.map.size()`, so
  the final board draws its seventeenth column (`docs/reports/GI.md` §7). `main` still carries the defect, and its
  note says so.
- **THE LABEL *END BOSS* IS CONFIRMED** — GJ's brief calls it confirmed. **Its tooltip** (*"The END BOSS. Nothing goes
  around it."* over *"It is always the Hollow Crown, and the road ends here."*) **and the readout's *"— the Hollow
  Crown waits"* are still owed a confirmation** (GJ's rulings item above).
- **~~OWED TO A TEST BATCH: NOTHING IN THE BATTERY PRESSES THE END BOSS'S BUTTON~~ — CLOSED AT GJ.** `check_gj` walks a
  whole run through the real screens and presses it every battery; with GI's lattice fix reverted it reads 25 / 3,
  all three at the missing button.

### A QUIT FIGHT RESTARTS AGAINST A RESET WARBAND, AND THE PARTY'S LOSSES CARRY — **GG's OPTION C, RULED AND BUILT AT GH; RAGE RULED AND THE TWO REMAINDERS ACCEPTED AT GI**

- **~~RAGE RESETS; THE BRIEF LISTED IT AS CARRYING. OWED A RULING~~ — RULED BY THE DESIGNER, RECORDED AT GI: RAGE
  RESETS.** Every fight opens it at nothing, plus First Blood's and Bottled Storm's floors, and carrying it through a
  quit would hand the quitter the Rage the abandoned fight built.
- **ACCEPTED, NOT OPEN — WHAT A QUIT STILL BUYS (RULED BY THE DESIGNER, RECORDED AT GI).** Both were driven at GH
  (`docs/reports/GH.md` §4b):
  - **A quit before anything is lost rolls the opening again**: the turn order and every enemy's declared first action.
  - **A quit clears the heroes' cooldowns, once-a-fight refusals and statuses** along with the warband's, and every
    meter — Rage, Focus, Faith and the rest — opens at nothing.

  **The reason, kept with the ruling so neither is rediscovered as a defect:** closing either needs the fight itself
  captured — GG's A or B, a project of several batches (`docs/reports/GG.md` §2d) — and a quit already costs health,
  Mana, items and a death, which is the substance. **An accepted consequence and an open defect read identically in a
  queue; these two are accepted.** `CLAUDE.md`'s GH block says the same where a batch reads the rule.
- **Everything else is as it stood**: health, Mana, the pouch, a fallen hero, a standing companion's health.

### FOUND AT GF AND NOT FIXED

- **A PEDDLER OR A FORGE QUIT IN THE MIDDLE OF A VISIT IS STILL WALKED PAST.** Both roll their stock in their own
  `_ready`, so re-entering one on resume would make a quit a reroll of the shop, and freezing the stock is a change to
  two screens, which GF's brief ruled out. Driven at GF: the node is visited and saved at the step, and Continue opens
  the map past it.
- **~~THE ZONE BOSS FOUGHT IS NOT ALWAYS THE ONE THE GAME NAMES~~ — CLOSED AT GI, AT THE SITE WHERE THE TWO PARTED.**
  `Run.compose("boss")` fills the escort's `boss` role with the zone's named boss (`ZONE_DEFS`), no longer with every
  `boss`-tagged kind the roster allows. Measured on HEAD through the composer: the Hollow Crown in 286, 309 and 335 of
  2,000 zone-boss warbands in zones 1, 2 and 3; after, in 0 of 6,000. **The roster tags did not move** — whether the end
  boss's kind belongs in them is still content — and the one reader that still fills a boss from them is the
  `DOD_SIM_THEME` hook, which ignores run state by design.
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
  of these is player-facing.
- **WHAT THE GLOSSARY CENSUS LEFT AS IT IS.** Nine claims no code can settle (intent, such as the class-wide cards
  being weaker on purpose) stand as written. **Decay and Elemental Weakness were RETIRED at GG**, by the designer's
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
- **Frostbind's `partner` is stored as a `unit_name`**, so two units of one name would make `_frostbind_partner`
  ambiguous. Nothing has shown it happening; it matters to any capture that re-points units by name.

### FOUND AT GH AND NOT FIXED

- **An item is spent the moment it is pressed.** The save takes the count before a target is picked, so a quit inside
  the target picker loses the item; cancelling the picker hands it back through `_refund_item`, which writes the save
  again. A quit can only cost, and that is the direction this errs in.
- **A loss reaches the save at once and a gain at the next door.** A heal, or a drip of Mana, that lands after the last
  loss of a turn is lost to a closed-window quit taken before the next turn boundary; the battle's own *Exit to Main
  Menu* writes everything. By design, for the same reason.
- **Two health losses at a turn's start pass no door**: Fortified Spirit's loan running out, and a companion's Bestial
  Wrath or Vigor fading. The next door writes them, and a restart's spawn clamps to a maximum without the loan anyway,
  so neither can be refunded by a quit. A new effect that takes health at a turn start WITHOUT that clamp would owe
  `_bank_party_losses` a call.
- **A hero who fell plays the death animation as the restarted fight opens.** `_die()` is the one way down and it plays
  it; nothing else of a death fires.
- **`check_gf`'s health arms read the party at the instant `load_run` returns.** The resumed fight writes the live
  member as it goes, so a read taken after its first frames reads that fight rather than the disk — found while
  re-pointing, and stated at the arm.

### FOUND AT GI AND NOT FIXED — **ALL THREE CLOSED AT GJ**

- **~~PLAYER-FACING: THE MINI-BOSS'S NODE IS LABELLED *WARDEN*~~ — CLOSED AT GJ, RULED BY THE DESIGNER: IT READS
  *MINI-BOSS*,** on the node and in its bargain's opener, the two surfaces the old word reached. A census of every
  string in `scripts/` and `data/` that carries *warden* finds the Warden spec, the second rung, and the Withered
  Warden with its forest's lore, and no mini-boss. The label fits the button at 66 px of 68 closed and 76 of 76 open,
  and a BR §1 sweep over 1,249 live names finds nothing called it (GJ §4).
- **~~PLAYER-FACING, SMALL: THE END BOSS'S SUMMARY LINE NAMES IT TWICE~~ — CLOSED AT GJ:** a lineup that is only the
  creature its theme names prints the name once — *"The END BOSS — The Hollow Crown."*
- **~~THE SIM NEVER FIGHTS THE END BOSS~~ — CLOSED AT GJ:** it does, and prints both counts (the first item of the
  queue).

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
6. **~~The Wide Watch's retirement has lost its reason~~ — RULED AT FY §3: it stays retired, because the Shared
   Mark holds its place.** The retirement string says so and marks FO's reason void. `check_fo` §2a asserts the
   current reason, the date, and FO's sentence absent.
7. **~~Deepening Hex's floor has lost its derivation~~ — RULED AT FY §2: re-derived against the live game to 8**
   (`10 - 2`, since nothing installs a shallower step). **FY read the brief's *"if nothing lowers the threshold"*
   clause as not applying**, because the rune itself still does, and recorded that reading for confirmation.
   **CONFIRMED AT GA: the floor stays at 8**, and its card wording is not touched. `check_fo` §1c pins the relation.
8. **~~Five node names use a tag word~~ — RULED AT GB: ACCEPTABLE** (BREAK, RESOURCE, DEBUFF). All five stay
   recorded in `check_ek`'s `CLASH_EXEMPT`, and the DEBUFF one uses the word differently.

**FW's list below is kept as the record. FX ruled two of its nine (the DO charter and the trees' size).** The
other seven bind the NEXT node authored rather than this tree, because no node of the 27 reaches a relic hook, a
spine, a class passive, the basic attack or a spec status.

**Full evidence: `docs/systems-recon.html`** — every system in its own `SR-` section; §3 (`SR-LINE`) holds the
edges and §4 (`SR-COUNT`) the count. The brief said the designer rules on the edges; FW ruled on none. **These are
the things a later batch must not re-derive:**

1. **~~THE DO CHARTER AGAINST THE LINE~~. RULED AT FX: THE LINE SUPERSEDES DO's PERMITTED LIST**, and
   `CLAUDE.md`'s DO block now opens with that. FW's text: `CLAUDE.md` records as settled that a node may modify its spec's protected
   core — *"worth 83 nodes"*, *"DO NOT RE-OPEN THIS AS AN OPEN QUESTION"* — and the line forbids touching any
   ability. The 33 node payloads that edit an ability today were legal under DO and are all out under the line.
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
7. **~~THE TREES' SIZE~~. RULED AT FX: ONE TREE OF 27, KEYED TO THE CLASS.** FW's text: 274 (281 under the line) assumes four trees of 81. At 81 a tree, today's machinery forces
   at least 124 of the 324 nodes to be magnitude repeats; at 27 a tree it forces none. Nothing rules it.
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

1. **~~Heal More When Low and We Do Not Break are party-wide by their read site~~ — RULED AT GA: BOTH STAY.** They
   are redundant when stacked, not false, and that is a different problem. FY's text: in any party, the second, third
   and fourth class to buy one is paid nothing.
2. **~~ENEMIES LOOK PAST YOU~~ — RULED AT GA: REPLACE IT. REPLACED AT GB BY *DEFLECTION* (SR-EVADE 2), AND THE NAME
   CONFIRMED BY THE DESIGNER AT GC**, with GB's sweep recorded beside the ruling in `CLAUDE.md`'s name-sweep block so
   the name is not revisited: it met nothing in 746 names, and the brief's label *Parry Ranged Blows* near-misses five. The node is retired outright and `tn_deflection` takes its cell, writing
   `deflection` 1: the deleted Swordmaster precedent's own magnitude, and all of it, because the parry gate asks
   `deflection > 0`. **Its read site asks about the defender and nobody else**, so its card is true however many
   heroes hold it — the property the old card lacked (FY measured three of the four heroes targeted MORE with all
   four holding it). **The `ghillie` field and both its read sites stand, and nothing writes the field now.**
3. **~~Three of the 27 are one idea by FW's own count~~ — RULED AT GA: ALL THREE STAY.** A Cooldown Ticks on a Crit, A
   Crit Pays and Your Crits Crack Guards are three purchases, and a player meets them as three.
   - **The counting rule is how `docs/systems-recon.html` counts distinct things, not a limit on what a tree may
     contain.** The limit is `CLAUDE.md`'s field rule, which `check_fx` §1 asserts. The reasoning is in
     `docs/design-notes.md` (GA).
   - **The brief named More Crit Chance and Armor Penetration as two of the three.** Those are SR-CRIT's other two
     rows, counted as distinct things, at tiers 1 and 2. FY's three sit at tiers 2, 3 and 3.
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

### ~~`docs/instrument-rules.md` STILL DESCRIBES DD's DIFFER IN THE PRESENT TENSE~~ — **CLOSED AT GA §3, WITH SIXTEEN MORE**

**Both of FZ's bullets are deleted**: *"`test_batch_cd` §1 is what diffs them"*, and *"AND IT COSTS 22 MINUTES …
`TMO[test_batch_cd]=2400`"*. That is DR's rule: the thing they describe is gone, so the claim goes rather than being
re-tensed. **A sweep of the whole file found sixteen more**, and the census was written before the first correction
(`docs/reports/GA.md` §3).

**The half worth keeping:** FZ found two by reading, and a population sweep of the same file found eighteen.
- Nine described something gone.
- Four named something that had only moved, and were corrected under the file's own EB §2 rule.
- Five were stale figures.

### FOUND AT GA AND NOT FIXED — **THREE OF THE FOUR CLOSED AT GB §4; NONE IS PLAYER-FACING**

- **~~`CLAUDE.md`'s index lists three rows whose rule is not over there~~ — CLOSED AT GB §4.** The three rows are
  deleted (their rules live in `CLAUDE.md` itself), the FR §5a / FS §1 block has its row, and the paragraph above the
  rows no longer names the last rows by batch or counts the blocks.
- **~~`scripts/run_state.gd`'s FI header says *"decided once in `_ready()`"*~~ — CLOSED AT GB §4:** it says
  `_init()`, which is what the code does.
- **Two claims in `docs/instrument-rules.md` are dated readings that GA did not re-derive, and it says so rather than
  passing them:** DX §1's *"THIRTY-FIVE ASSERT A FLOOR NOW"* and EU's *"ALL FIVE ARE CORRECT TODAY"*. GB's brief
  did not include that file either.
- **~~This file's *Knowledge sync* section carries EG's 104.70 KiB~~ — CLOSED AT GB §4:** the heaviest-files list and
  its figures are gone, and the section names the instruments that print the live sizes.

### FOUND AT GE AND NOT FIXED — **LONG DRAW IS STILL A GAIN ON THE PLAYER'S MODEL (OWED A RULING), AND ITS NEW WORDS AWAIT CONFIRMATION**

- **OWED A RULING: THE DRAIN MADE LONG DRAW'S GAIN SMALLER, NOT A TRADE, ON `check_cs`'s OWN MODEL.** With the rune
  held, a missed press drains 16 Focus (GE §1). Priced in Focus a basic, the rune against the bare chain, on the model
  `check_cs` §7 prints every battery:

  | Focus | presses, bare → rune | chain lands, bare → rune | worth before GE | worth now |
  |---|---|---|---|---|
  | 0–49 | 1 → 2 | 97.7% → 98.5% | +8.22 | +7.98 |
  | 50–99 | 2 → 3 | 98.5% → 98.7% | +8.06 | +7.86 |
  | 100–149 | 3 → 4 | 98.7% → 98.8% | +8.01 | +7.82 |
  | 150+ | 4 → 5 | 98.8% → 96.0% | +7.14 | +6.50 |

  - **A chain breaks too rarely on that model for a per-miss price to reach a trade.** Break-even is about 180 Focus a
    miss at 150+, more than the meter holds at the bottom of that stage, and over 550 below it.
  - **The sim bot prices it the other way.** It lands a flat 85% of presses, and on its roll the rune with the drain
    is a LOSS at every stage (−1.2 / −3.4 / −5.3 / −6.9 Focus a basic).
  - **The model's one assumption decides it.** At a timing SD of 100 ms rather than 60, the rune is a trade at 150+
    only (−3.6) and stays a gain below it. `docs/reports/GE.md` §1 carries the tables.
  Which model the rune should answer to is the designer's. Rune content is written with the designer, so no number
  moved beyond the ruled 16 and no alternative is offered here.
- **LONG DRAW'S NEW WORDS ARE PROPOSED, NOT CONFIRMED:** *"His basic attack runs one EXTRA press at every stage — but a
  missed press drains 16 Focus."* `check_ez` §5 reads the number off `SS_SEQ_MISS_DRAIN`, so a confirmed rewording that
  keeps *"drains 16 Focus"* needs no gate edit, and one that drops the phrase moves that arm.
- **BATCH GD's BRIEF WAS NEVER BUILT, AND GE's SUPERSEDES BOTH ITS SECTIONS.** No GD commit exists on either branch.
  Its §1 ruled GC's second fix — the added press takes no widening at any stage — which GE's brief priced as only a
  smaller gain (+6.3 / +7.0 / +7.1 / +7.1 on the same model); its §2 restated the relic/talent seam, which GE §2
  replaced with the ruling above. Recorded so the letter is not read as a lost batch.
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

- **~~PLAYER-FACING: LONG DRAW'S CARD IS TRUE AT ONE STAGE OF FOUR~~ — CLOSED AT GE §1, BY A RULING ON THE RUNE'S
  COST RATHER THAN EITHER FIX BELOW:** with the rune held a missed press drains 16 Focus, and the card's new words await
  confirmation (under GE's findings). GC's text: *"… the added press buys no widening, so the
  sequence is harder to hold."* `_sharpshooter_basic_profile` takes the opening widening off the press count with the
  rune's press included, so below 150 Focus the added press DOES buy the widening the table gives the longer chain, and
  on `check_cs`'s model the chain holds as well or marginally better with the rune (98.5 / 98.7 / 98.8% against
  97.7 / 98.5 / 98.7%). Only at 150+ is it harder (96.0% against 98.8%). `check_ez` §5 asserts the cost at 300 Focus
  only. **Owed a ruling: the fix is either the card's words or the rune's shape** (GC §2b).
- **~~A SEVENTH RULE WHOSE FACTS MOVED UNDER IT~~ — CLOSED AT GE §2, RULED BY THE DESIGNER:** the rule sends an effect
  that must know the spec to the RUNES and says no permanent layer is spec-specific, and `docs/master.html`'s relic
  paragraph is rewritten with it. That paragraph made the claim in other words rather than carrying the sentence. GC's
  text: `CLAUDE.md`'s EN §4 block is headed *"A
  TALENT CHANGES WHAT A SPEC DOES IN A FIGHT"*, and its first rule bullet says an effect that *"must know which spec the
  hero is … is a TALENT"*. Since FX a talent is a stat payload every class buys and every hero of the class wears, so an
  effect that must know the spec cannot be one. One clause of the block was updated for FX; the rule was not.
  `docs/master.html`'s relic paragraph carries the same sentence.
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
- **`test_batch_ba` §1 still sweeps the one class tree for the words BA §1 reserved**, which the rule no longer asks of
  the tree. It asserts something stricter than the rule and is harmless.
- **THE CATEGORY HAS NO INSTRUMENT.** A gate could assert, for each marked claim, the fact that makes it unbuilt — only
  the Sharpshooter carries Focus, the three `*_active` switches are unassigned, no engine rune exists — so the day one
  is built the gate reds and says the marker is owed its removal. Nothing does today. **GK ended two of those three
  facts** (the switches have one writer; engine runes exist) **and nothing redded, which is this item's point.**
- **`docs/ways-of-working.md`'s conflict table says this file "has no reader"**; `check_es` §4 reads it.

### FOUND AT GB AND NOT FIXED — **THE §4 CENSUS'S FINDINGS OUTSIDE ITS THREE FILES; THE THREE PLAYER-FACING TEXTS, THE RECAP GAP AND THE QUIT/RESUME SKIP CLOSED AT GF; THE SIX RULES CLOSED AT GC**

The census that swept `CLAUDE.md`, `scripts/run_state.gd`'s comments and this file read every claim against the
code, and some of what it found lives elsewhere. **The tables are in `docs/reports/GB.md` §4.**

- **~~PLAYER-FACING: a zone boss's victory text says each spec banks a talent point~~ — CLOSED AT GF §3:** it says
  each class banks it, and the card's *"one of three"*, and the mini-boss's, lost the figure: both offers can be
  short.
- **~~PLAYER-FACING: the run summary prints "Tier N of 10"~~ — CLOSED AT GF §3:** it prints *"encounter N of M"* off
  the zone's own slot count, and the summary's surface was swept with it (`docs/reports/GF.md` §3).
- **~~PLAYER-FACING: the glossary's item entry says "Five items" and the old flat figures~~ — CLOSED AT GF §3,** with
  every other entry of the glossary read against the code (`docs/reports/GF.md` §3).
- **~~THE RECAP LEDGER MISSES FIVE HEALTH COSTS~~ — CLOSED AT GF §3:** each of the five books the health it takes
  through `_book_self_cost`, which reaches the recap's ledger and none of the on-damage riders. A swept census of
  every direct health write in `battle.gd` and `unit.gd` found these five and no sixth.
- **A FORFEIT BOOKS A SUMMONED NODE.** `Run.debug_summon` switches off the run ledger and the wipe branch's Profile
  booking, and `_do_forfeit`'s `Profile.note_forfeit` is not guarded. Debug-only.
- **THE FIXED MODIFIER NEVER REACHES A MINI-BOSS.** At rung 3 `arm_fixed_modifier` arms the mini-boss on entry, and
  the bargain that always follows overwrites it (`accept_offer`); RunSim takes the bargain first, so the guard skips
  arming. The mini-boss entry in the fixed list is dead in both flows.
- **~~QUITTING AT AN ELITE'S OR MINI-BOSS'S OFFER, OR MID-FIGHT, WALKS PAST THE FIGHT~~ — CLOSED AT GF, DRIVEN AND
  REPAIRED.** GB's reading of the mechanism held; driving it found it wider — a zone boss and the end boss strand the
  party, and an event is walked past too — and live on `main`, where it predates the merge (`docs/reports/GF.md`
  §1).
- **NOTHING STOPS `DOD_SIM_RUNES` CHANGING A REAL GAME.** `runes_mode()` reads the environment with no `sim_run` gate,
  and the `test_runes` assertion a `run_state.gd` comment claimed for it never existed: the purity arm covers the
  economy and power flags only. *Stats* or *off* left exported in a player's shell changes a real run.
- **DEBUG: FREE TRAVEL OPENS ONLY THE NEXT SLOT**, while its toast says every slot is clickable.
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
- **~~`CLAUDE.md`, REPORT-ONLY: RULES WHOSE FACTS MOVED UNDER THEM~~ — ALL SIX RULED BY THE DESIGNER AND CLOSED AT
  GC** (`docs/reports/GC.md`). BH §2's block is deleted and BM §2's says where it went; BA §1 no longer reserves the
  Survivalist's tree; CN's relic clause is deleted; the second copy of CQ §1 left `docs/instrument-rules.md`; CS's cap
  is amended (four, and a rune may raise it); and FT §1's Focus claim is marked `RULED, NOT BUILT`, the first entry of
  a category.

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
- **~~`CLAUDE.md`'s EM block says the rune `lane` fields are "STILL SHOWN"~~ — CLOSED AT GB §4:** it says nothing
  shows them now.
- **Control copies left user-data folders under Godot's `app_userdata`**: "DoD G2 curcopy", "DoD G2
  headcopy", "DoD G6 ctlcopy", "Dawn of Decay FX ctl", and FY's "DoD FY census" and "DoD FY probe". Each was
  renamed so that its `user://` could not reach the player's save folder. They can be deleted.

### FOUND AT FW AND NOT FIXED — **A REPORT TOUCHES NO CODE; THE FIRST THREE ARE PLAYER-FACING**

- **PLAYER-FACING:** the first-bar orientation card says *"Every action runs a timing check"* (`battle.gd`)
  — false since CN took the bar off basics, pure buffs, shields and debuff appliers.
- **PLAYER-FACING:** the map's help text says *"ELITES pay a talent point and a rune"* (`map_screen.gd:158`) —
  nothing in a run has awarded a talent point since BM.
- **PLAYER-FACING:** Cracked Hourglass says *"every hero recovers 30% Mana"*, and `Run.restore_mana` refills only
  the mage and cleric keys — the Hunter, a Mana user, gets nothing.
- **The sim bot's Health Potion heals a flat 40** (`battle.gd:3778-3788`), not `Run.health_potion_heal`'s 20% of
  maximum — against `CLAUDE.md`'s CT §6 (*"battle and map both CALL them"*), so every sim item-economy figure
  measures a different potion from the player's.
- **MOOT AT FX** (the node is deleted with its tree, and no magnitude came from it). **Overpressure
  (`sm_overpressure`) never fired**: its read is the enemy's own field and nothing copies the node's
  value onto an enemy.
- **`relics.gd`'s header says every hook is read at exactly one site** — `gold_find_mult` is read at two,
  `shop_discount` at four, and **`rest_heal_add` at none**, so Cairnmoss Poultice pays nothing and
  neither does Martyr's Knucklebone's *"rest nodes restore 10% more"* (GB). **`docs/master.html`'s copy of the claim was
  corrected at GE §2**, where six hooks read at more than one site were counted; this header still owes its own.
- **`CLAUDE.md`'s recast block says `add_status` resolves a re-application as the max of duration and power** —
  true only of its default branch: Poison and Chilled reset the timer (so Poison can shorten), Burn adds turns,
  Ruin adds a stack (`unit.gd:2685-2736`).
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
- **The Survivalist's passive barb calls `_apply_status`, not `_apply_poison`**. **This is moot for the nodes at FX**:
  the poison lane is deleted, though the call itself is unchanged. FW's text: — an inference: his poison-lane
  nodes would not reach it.
- **`merge-recon.html` carries five claims FW corrects** (a recon is regenerated, never hand-edited): Overpressure
  counted live; Grudge and The Whole Room's reason; Cackling Mirror counted engine-free; the Arcanist's "one idea";
  the Swordmaster's "six Break nodes".
- **MOOT AT FX.** All three nodes are deleted, and none of the one tree's 27 names collides with anything (swept for
  exact and contained matches against `scripts/` and `data/`). The names a merge would have made collide: Spite (a Warden node and a Berserker card), Whetstone (a Swordmaster node and a
  live rune), Second Wind (a Berserker node and a Holy card).

### THE CLASS MERGE ~~IS MEASURED AND UNRULED~~ WAS MEASURED AT FP AND IS RULED — **A PROJECT ON ITS OWN BRANCH SINCE FQ; STEPS 1–5 BUILT (3's NINE ENGINES AT GO, 4's POOL MERGE AT GP, 5 AT GP AND GV), AND THE RUNE SCOPES MERGED AT HC; STEP 6 CENSUSED AT HA, ITS FIRST HALF TAKEN AT HD AND ITS SECOND OWED TO HE (THE RUNNING ORDER BELOW)**

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
- **THE PROFILE MIGRATION IS WRITTEN ONCE AND CANNOT BE ITERATED ON LIVE**, and the one part that
  is a ruling rather than a programming step is **how twelve purses fold into four**: a player with
  3 points on each of three Warrior specs has 9, and **sum rewards breadth while max rewards
  mastery** — with the merged trees three times shallower, summing may hand a full tree on day one.
  FP did not choose; **the designer ruled MAX at FX**, and `docs/reports/FX.md` §4 carries the driven probe.
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
- **~~CHANNEL'S RATE~~ — RULED AND BUILT AT FU §2.** Free casts build: every CAST books
  `max(net, CHANNEL_CAST_FLOOR)`, the floor is **10** (Blink's price, the cheapest a Mage can pay, so
  it lifts no card he pays for) and the step is **42**, which puts every Mage spec's MEDIAN
  end-of-trash-fight meter at three steps. **The half worth keeping is the correction to FT's own
  figures**: a Mage regenerates **22**, not 12 — Evocation is the Mage class passive — and free casts
  are **8.6–14.6%** of his casts in rung-1 trash, not FT's one-fight 2 of 6. The picture of a Mage
  who runs dry and falls back to his basic came from one fight priced at the wrong economy.
  - **THE SPREAD ONE RATE CANNOT CLOSE — A RULING ONLY IF IT MATTERS.** The Cryomancer ends a trash
    fight near **3.4** steps and the Arcanist near **2.6**, because he takes 7.39 casts a fight to
    the Arcanist's 5.57 at the same 24.6 Mana a costed cast. A floor widens the gap slightly; a
    per-spec rate would close it and would make a class core a spec engine.
- **~~MOMENTUM'S RATE~~ — SET AT FV §2, AND ITS TAKEN HALF REPAIRED AT FV §1.** One step an exchange,
  now `MOMENTUM_EXCHANGES_PER_STEP` = 1 — the rate is at its stop, because a normal fight already ends
  around a third of the cap and an exchange books at most once a turn. **The taken half counts a blow
  MET as well as health lost**, so a Block, an absolute parry and a shield that eats a blow whole all
  book now. The cap (8 steps × 4% = −32%) is flagged, not tuned, and is a long-fight event.
  - **ONE CONSEQUENCE FV STATES AND DOES NOT RULE: HEALTH A WARRIOR TAKES FROM HIMSELF BOOKS THE TAKEN
    HALF**, because the health door books any health lost. In rung-1 trash no span booked on it alone;
    in elite fights 5–9% of spans did. Whether paying your own health is half of an exchange is the
    designer's; `docs/reports/FV.md` §1 carries the reading and its caveat.
- **~~SANCTITY'S RATE~~ — SET AT FV §3: 16 EVENTS A STEP, AGAINST HALF A PAYOUT.** FT's 6 put every
  Cleric party at the cap in 78–97% of trash fights; 16 ends a normal fight at 3.03 / 2.06 / 2.28
  steps (Devout / Holy / Occultist). **Owed a re-reading the day the potency half lands** — `CLAUDE.md`
  binds the potency batch to re-measure it in that same batch.
  - **AND TWO THINGS THAT ARE NOT RATES DECIDE WHAT POTENCY WOULD BE WORTH, BOTH FOUND AT FV §3:** the
    Devout's Divine Shield barrier is applied WITHOUT a `src`, so no payout keyed on the applier reaches
    his shields; and the Occultist's Ruin is battle-long and magnitude-free at the funnel. **Neither is
    owed until a potency half exists; both are what that batch meets first.**
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

### `check_ed` READS SOURCE PINS ONLY; THE DOCUMENT HALF IS `check_ec` §2's — **FOUND AT FU §1c, A PROCEDURE NOTE, NOTHING OWED**

**`check_ed` read 18 / 0 against HEAD's manifest while `check_fg`'s `CLAUDE.md` pin was already
unresolvable**, because its §0 takes pins whose haystack ends in `.gd`. **`check_ec` §2 reads every
`contains`-group member against the five tracked documents and caught the same pin at 24 / 2** — the
pre-pass's one unpredicted red, because the prediction had named `check_ed` as the only pin gate.

- **SO THE PROCEDURE BATCHES HAVE USED FOR A DOCUMENT EDIT — *"run `check_ed` against HEAD's
  manifest with the edited documents in place"* — CANNOT SEE A DOCUMENT PIN. `check_ec` CAN**, and so
  can `build_pin_manifest.py --check` with a regeneration diff written to the scratchpad (the module's
  `open` patched, so the tracked file is never touched), which named the pin exactly.
- **Nothing is broken and nothing is owed**: each gate's header says what it reads. **The half worth
  keeping is the shape of the mistake** — a finding about one gate's population was written up as a
  finding about the tree's, and the other gate that owns the half was one pre-pass away.

### ~~THE SUBJECT SEAM IN `CLAUDE.md`~~ — **RULED BY THE DESIGNER AND TAKEN AT GR: COMBAT LAW IS `docs/combat-rules.md`. NOTHING IS OWED FROM IT.**

**What is left is recorded in `CLAUDE.md`'s ceiling block, where the next batch at the ceiling will read it**, and
the move that comes next is GR's ruling 2 above. Working: `docs/reports/GR.md` §1 and §5.
### THE RUN-SAVE FIGURES ARE FIXED — **AND "IT IS A TWO-NUMBER EDIT" WAS WRONG (CLOSED AT FR §1)**

**Struck through rather than deleted, because the reasoning is what a later queue item should
inherit.** `master.html` now says the save is **v12** and refuses below **v10**.

- **~~It is a two-number edit~~ — FALSE, AND THIS IS THE HALF WORTH KEEPING.** The clause giving
  the REASON for the refusal (*"holds a flat 12-slot line and a single slot index, which has no
  honest place on a lattice"*) is **BK's v8** reason. The live threshold is **BM's v10**, whose
  reason is different: the final zone gained a **seventeenth slot**, so a v9 save's final-zone map
  has no position to walk onto after its boss. **A v9 save HAS the lattice.** Changing only the
  digits would have produced a sentence that was newly false rather than merely stale — and it
  would have read as freshly checked.
- **THE GENERAL FORM: WHEN A QUEUE ITEM PRICES A DOC REPAIR, IT IS PRICING THE NUMBERS AND NOT THE
  SENTENCE.** Read the reason as well as the figure before quoting a cost.
- **`CLAUDE.md` CARRIED THE CORRECT REASON THROUGHOUT**, which is why the two rule files did not
  drift together: the one with an instrument reading it stayed right.

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

### ~~THE INSTRUMENT RECOMMENDATION FR OWES~~ — **BOTH HALVES BUILT AT FS §2. NOTHING IS OWED.**

**A gate checking that every number `master.html` states matches the constant it names is NOT
worth building, and that answer is on the record rather than left as "nobody built one".** It
would have caught **zero of the fourteen** defects FR found, because the part of the document that
names constants is already right: 1,265 mechanical comparisons across the talent tables, the
ability stat lines, the bestiary and the pool tables returned **3 raw flags and 0 true defects**.
EB declined the header sweep at 118 rows for 16 defects; this is ~1,265 rows for 0.

**WHAT IS WORTH BUILDING IS DOC-vs-DOC, AND IT IS SMALL:**

- **A heading/table pairing check** — *the spec a §7 heading names must be the spec whose lanes the
  table beneath it lists*, and *a count in a table's heading must equal the rows in that table*.
  That reaches FR's largest finding (8 mis-paired headings) plus two more, needs no code at all,
  and its failure mode is noise rather than silence.
- **One arm on `check_es` §4(2).** That gate already PRINTS the per-spec core-kit tag census every
  battery and its own comment says *"It is a REPORT."* FR's "DEBUFF for seven" (it is five) is that
  printed table's figure, copied into THREE documents (`master.html`, `CLAUDE.md` and this file)
  and drifted in all three. **One arm comparing the
  document's sentence to the census the battery already computes would have caught it the day it
  moved.**

**AND THE FAILURE MODE IS THE ARGUMENT AGAINST THE BIG GATE.** Every hole FR's own instruments had
— a regex needing a closing paren, a curly apostrophe, a line break inside "Speed\n125", a
fixed-width window running into the next card's numbers, a name matching inside another name —
**printed a clean zero**. A document gate fails toward FEWER findings, and a gate that has quietly
stopped asking reads exactly like a clean one.

**BOTH ARE BUILT AND BOTH BIT.** `check_fs.gd` is the pairing check and it found the
**Arcanist heading naming CONTROL over a table listing Entropy** — renamed at Batch AT, and FR's
own fourteen-defect read had missed it. `check_es` §4(2b) is the census arm, and it found
**`CLAUDE.md` and this file both still saying "DEBUFF for seven"** after FR reported that sweep
clean; this file's copy wraps the phrase across a newline. **The transferable half, which is why
this item is kept:** *the failure mode above is real and this gate's own first draft demonstrated
it* — a line-anchored heading match read 9 of 12 and printed four confident FALSE mismatches, which
**looks like a finding rather than like a broken instrument.** The population was asserted at twelve
until FX deleted the twelve spec trees and their headings. **The big value gate is still not built and that answer is unchanged.**

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

- **THE DANGEROUS HALF IS THAT REGENERATION THEN REPORTS SUCCESS**, which is FH's own tell one step
  along: not the typed-holder shape, the named-constant one. It is in `docs/instrument-rules.md`
  beside FH's rule.
- **THIS IS NOT AN ARGUMENT FOR INLINING THE PATH.** Named constants are how a gate states a
  boundary once; the sweep that actually protects a document edit is the reader-pool needle sweep,
  which reads `check_fs.gd` like any other reader. **It is an argument for knowing which instrument
  you are trusting** — a clean `check_ed` over a new document gate means nothing at all.
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
2. **~~THE TALENT LAYER~~. DONE AT BATCH FX: ONE TREE OF 27, KEYED TO THE CLASS, NOT 274 NODES.** The old plan
   read: **THE TALENT LAYER — 274 new nodes by FP's count, 281 under the designer's line (FW)**, authored by the
   designer and the assistant together. **The long pole. Its recon is `docs/systems-recon.html` (FW), and the
   rulings in that document's §3 come before a node is written.**
3. **~~ENGINES TO RUNES, each with its enabler~~ — BUILT AT BATCH GK; THE NINE ENGINES THE CHARTER'S SIX A CLASS
   OWED BUILT AT GO**, the designer's nine, transcribed. **THE ENABLER RULE NARROWED AT GS**, ruled: an engine brings
   only what it cannot run without.
   - **~~AND A CLASS KIT OF THREE, RULED IN GL's BRIEF~~ — BUILT AT GN.** Its recon is `docs/kit-recon.html` (GL); GN's
     brief names the Crown's Break and freeze resistance as the batch after the kits. No step number was ruled for it.
4. **~~POOL MERGING~~ — BUILT AT BATCH GP.** One pool a class (38 / 41 / 34 / 36; **43 / 51 / 43 / 41 since GS §1**, **43 / 51 / 43 / 42 since HB §2**, Tripwire on
   the Survivalist's shelf;
   which put the 29 cards that stopped travelling on their shelves), the class-wide cards ordinary cards in it, the
   class-wide share and EH §1's third zone-boss tier deleted, and **a card that reads an engine offered only to its
   holder** — 34 of the 149, derived at the read site and driven both ways; **37 of the 178 since GS, and of the 179 since HB**.
5. **~~THE 43 ENGINE-READING RUNES AND THE ENGINE-READING CARDS~~ — THE CARDS AT GP, THE RUNES AT GV.** GP took the
   CARDS half at the offer door; **GV took the RUNES half at every rune door and at a queued cache's answer**, and the
   population is **35 of the 60 live ordinary runes** rather than FP's 43 (a rune that half-works, or reads a card, a
   status, the stance or nothing, is not gated — GP's own groups). GM's standing item — *ten live spec runes are read
   only under their lineage's engine, and a rune's scope is the lineage, so he is still offered them* — is closed by
   it; **what the scope itself should be was GV's ruling 5, answered at HC: the CLASS**, with the engine gate (36 rows
   since Layered Aegis), the card a rune names and a companion present deciding what a hero is offered.
6. **THE GATES — CENSUSED AT HA; HD TOOK THE TWENTY HOLES AND THE FOLD, AND HE OWES THE OTHER SEVENTY-THREE** (HB was the pet and HC the rune scopes). FP counted **52 engine-bound targets** carrying
   71.6% of the battery's asserted checks, and GK repaired every red its own move caused. **HA read all 119 launched
   targets arm by arm**: of FP's 52, **twenty are repaired and correct, thirty-one still ask a pre-merge question and one
   is red on purpose** — and **the middle group is 42 targets and 130 arms, eleven of its targets outside FP's 52**,
   because FP's band was the engine half of the merge and the middle group is mostly the offer, the kit and
   ownership. **Twenty arms in fifteen targets cannot fail as written or pass against a false claim.** Priced, not
   repaired: **HD takes the twenty and the fold family, HE the other seventy-five** — HA priced them as HB and HC
   (`docs/reports/HA.md` §1–§2).

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
- **AND AT HC IT REACHED A RUNE: BARED PLATE'S PRICE IS THE BLOCK ROLL** (*"he can no longer Block"*), and since the
  rune is `class:warrior` a Warrior with no Warden lineage and no Heavy Plating pays it on a Block chance of 0.000
  (driven) — HC's ruling 2.

### THE RUNE LAYER'S OWED ITEMS — **NONE. FN CLOSED THE LAST THREE.**

**All four items in this section were recorded only in the WHERE block above until FL moved them
here, which is the mechanism that let them survive a rewrite.** FM answered the generated stat
family; **FN answered the other three**, and they are struck through rather than deleted so the
reasoning is not re-derived.

- **~~THE EIGHT SHIPPED GATED RUNES NEED RE-READING~~ — CLOSED AT FN. THE DESIGNER RULED AND THE
  CONDITIONS CAME OFF.** The count was **EIGHT** (four THRESHOLD — Deepening Hex, Bracing Line,
  Heavy Bolts, Answering Pack; four BREADTH — Wide Rite, Long Watch, Wide Watch, Shared Scent), the
  eleven lines that said six are corrected, and `check_fk` §2's assertion inverted rather than
  being deleted. **Nothing is owed from this item.** What FN measured on the way is in
  `docs/reports/FN.md` §1.
- **~~BRACING LINE'S 8.98% PRICES THE LEVEL, NOT THE CONDITION~~ — STILL TRUE AND NO LONGER A
  WARNING.** It priced Heavy Plating's +32% level **with the tag threshold assumed met**; the
  threshold is gone, so **8.98% of incoming hits (11.91% with the Standing Wall) is simply the
  rate now.** `BRACING_LINE_LEVEL` is untouched at 32 and the plating clause is still on the card —
  it was always a SECOND gate and never the retired secondary.
- **~~THE `.docx` EXPORTS: A DESIGNER'S RULING AND A STANDING RULE DISAGREE~~ — CLOSED AT FN §3.**
  `CLAUDE.md`'s *Working agreement* step (3) carries the ruling and its reason now. **The
  transferable half, which is why this item is kept:** a rule contradicted by a ruling that lives
  only in a closed batch report is a rule a future batch follows, because `docs/reports/` is a
  file class no instrument reads and no sweep covers.

### FN HANDED OVER THREE DESIGN QUESTIONS — **FO TOOK TWO. ONE IS STILL OPEN.**

**FN flagged and did not retune, which is what its brief required. FO ruled on the two that were
worth EXACTLY ZERO and left the pricing question alone.**

- **~~DEEPENING HEX IS WORTH EXACTLY ZERO TO AN OCCULTIST HOLDING AVATAR OF RUIN~~ — CLOSED AT
  FO §1. IT SUBTRACTS 2 NOW, UNDER A FLOOR OF 3 — RE-DERIVED TO 8 AT FY §2, THE BOTTOM OF THE LIVE GAME.** **The transferable half, which is why this item
  is kept:** the `mini` was CORRECT and was written for a real reason, and **the correct behaviour
  was what made the rune inert** — there was nothing to repair in the handler, only a decision to
  take. **And the fix's own shape is the new hazard**: a subtraction is OPEN at the bottom where an
  assignment is not, so at the floor the rune is worth zero again. `check_fo` §1e asserts a STRICT
  inequality on every live step beside its property arm, because *never shallower* is satisfied by
  `mini` itself.
- **~~THE WIDE WATCH IS WORTH EXACTLY ZERO TO A SHARPSHOOTER HOLDING OVERKILL~~ — CLOSED AT FO §2.
  RETIRED, KEPT, AND REPLACED BY THE SHARED MARK. FY §3 restated why it stays retired: its place is filled,
  because FX deleted the node it duplicated.** **The transferable half:** the brief said the
  two texts match *word for word* and they do not — **the longest shared phrase is `rather than`**
  and the node's clause appears in zero rune `desc` strings. **The duplication was in the CODE and
  is invisible to a text sweep**, which is FK §7's Standing Ground shape. Its read site, field,
  payload and entry are all KEPT: a saved run holding it is still paid.
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

### TEN OF FK'S RUNES HAVE NO SUITE COVERAGE — **REPORTED AT FK §3, RECORDED HERE AT FM §5, OWED**

**`test_rune_battle` DRIVES NINE OF THE TWELVE SPECS AND NOT THE THREE WARRIORS.** Its passes are
pyromancer/holy, cryomancer/occultist, arcanist/inquisitor and the three Hunter specs — and
**FK put ten new runes on two of the three warriors.**
FK's own throwaway probe covered them and was deleted; the SUITE
does not. **It is a small, clearly-scoped instrument change and it is owed** — a fourth pass, or a
rotation, in a batch that is allowed to spend a suite's runtime on it. Recorded here because a
report is not a queue: FK named it in `docs/reports/FK.md` §3 and nothing carried it forward.

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
- **A GATE'S NEEDLE CAN BE COARSER THAN THE DEFECT IT GUARDS, AND `check_fh` §3's WAS.**
  `_has_text(shop, "draft")` swept every Label on the shop screen for a bare substring, and **eight
  live runes carry *"his drafted cards"* in their own `desc`.** It is SCOPED now — text a rune
  brought with it is the rune's — with a second arm on BUTTONS that no rune text can excuse, and
  **both arms were driven** (the excused text was really on the counter; an injected draft Label is
  caught). **The source-level pins were never the loose ones** and are untouched: `check_fd` §1f and
  `test_batch_bo` §3 hold three needles each. Repaired at FM; recorded because the SHAPE recurs —
  a screen-level proxy for a source-level rule goes stale when the screen's content grows.
  **AND AT FN THE REPAIR WENT DORMANT WITHOUT BEING WRONG.** The eight *"his drafted cards"*
  clauses FM scoped around were the eight retired conditions, so **zero live runes name a draft
  now** and the excusal has nothing to excuse. **It is not reverted**: the BUTTON arm is
  unaffected, and the day a rune's text names a draft again the scoping is what stops a false red.
  **A repair whose occasion disappears is not a repair that was wrong.**

### AN OUT-OF-REPO HEAD REBUILD NEEDS THE IGNORED FILES — **FOUND AT FN, RECORDED, NOT A RULE EDIT**

**`git archive HEAD | tar -x` IS TRACKED FILES ONLY, AND `.godot/` AND `*.import` ARE BOTH
GITIGNORED.** A copy built that way cannot resolve `res://scenes/battle.tscn`, so **every
fixture-driven gate throws `Cannot call method 'get' on a null value` inside `gate_fixture.spawn`
and then sits at ~1% CPU instead of exiting** — which reads as a hang, not as a broken copy.
**THE METHOD THAT WORKS:** `rsync` the whole working tree (ignored files included), then
`git --work-tree=<copy> checkout HEAD -- .`, which puts HEAD's tracked content into a tree that
still has its import cache. **Verified both ways at FN**: the archive copy hung on
`check_cm_live`; the rsync copy ran it in 70 seconds and reproduced the sanctioned red's four FAIL
lines byte-for-byte. **Recorded here rather than in `docs/instrument-rules.md` because writing a
rule is a rule edit** — but a batch that needs a HEAD control needs this before it needs anything
else.

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

### THE CHANGELOG CUT AND THE FOUR FALSE CLAIMS ARE BOTH TAKEN — **NOTHING IS OWED FROM EITHER**

**Full evidence: `docs/reports/FG.md`.** FF left both and FG took both. This item records that they
are closed, and carries the two things a later batch must not re-derive from scratch:

- **THE CUT IS NOT A JUDGEMENT CALL ANY MORE AND NOBODY HAS TO REMEMBER IT.** `check_fg.gd` §1
  reads `docs/changelog.html` against CW §4's threshold **every battery**, prints both the decimal
  and binary figures beside the bar, WARNS over it and FAILS if a second batch passes without the
  cut. `check_fg.gd` §2 does the same for `CLAUDE.md` against its ceiling — EE's 290 KiB, 340 since
  FU §1. **A threshold with no
  instrument is a note, not a gate** — that is now a standing rule in
  `docs/instrument-rules.md`, beside the changelog block itself.
- **A SAMPLE IS PART OF AN ASSERTION'S TERRITORY, AND A VACUITY THAT IS ONLY PRINTED IS ONE NOTHING
  CAN GO RED ON.** `check_es` §1 announced its own dormancy and then failed to wake for four
  batches because its sample member was a Berserker. **Both halves of that are now assertions**
  rather than a `print`.

### FD'S TWO QUESTIONS ARE BOTH ANSWERED — **NOTHING IS OWED FROM THEM**

**Full evidence: `docs/reports/FE.md`.** FD asked whether the two live primary-BREAK rune rows
should follow the cards, and whether the two unguarded frozen queues were reachable. **The designer
ruled the first and FE drove the second.** This item records that both are closed, and carries the
two things a later batch must not re-derive from scratch:

- **`RUNE_TAGS` IS NOT A MECHANISM AND MEASURING THAT WAS THE USEFUL HALF.** `rune_tag_line` has
  ZERO callers, so *any* future change to those rows is
  a consistency change until the rune-offer surface EK deferred is actually built. **`check_fe` §1b
  asserts it in both directions**, so the day that surface arrives the gate says so rather than four
  documents quietly becoming false.
- **A GUARD THAT REFUSES BY RETURNING IS NOT A REPAIR, AND THAT IS THE TRANSFERABLE FINDING.**
  `_pick_ability` had the right test and the wrong response: it declined the illegal pick without
  removing it from the offer, so the button stayed on screen doing nothing and — where every option
  was illegal — the pick could never be answered at all. **Reading a table of resolution doors tells
  you whether a check exists; it does not tell you what happens when the check fires.** Recorded as a
  standing rule in `CLAUDE.md`, inside FD's own block.

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
- **AND GC §2 READ CS's CAP AGAINST IT.** On the same model the capped chain lands 98.8% of the time, so the cap
  no longer rests on four being hard; a nine-press chain still lands 49.5%, so the bound is what it keeps. The cap is
  amended — four, and a rune may raise it — and `CLAUDE.md`'s sequence block says why.
- **DIFFICULTY IS BOUGHT WITH `sweep_time`, NOT WITH THE HALF-WIDTHS**, and the reason is a standing
  rule in `CLAUDE.md` now: a half-width is a fraction of the TRACK, so widening it redraws what the
  player is aiming at, while the sweep buys the same seconds and leaves every zone where it was.
  **The alternative was priced and rejected — it is not a discovery.**

### THE CRIT SURPLUS IS RULED END TO END — **NOTHING IS OPEN. EX CLOSED THE LAST NUMBER.**

**Full evidence: `docs/reports/EW.md` (mechanism) and `docs/reports/EX.md` (rate).** EW built the
conversion and flagged the rate; **the designer ruled 0.50 and EX built it.** The mechanism, the
scope (assembled total, never a source), the enemy question (§2 of EW, structurally moot) and the
rate are all settled. **This item is here to record that it is closed, and to carry the two things a
later batch must not re-derive from scratch:**

- **THE WORST-BLOW FIGURE IS NOT A BOUND** and must never be quoted as one — four arms, 7.20 to
  18.09. Quote the ratio and the band instead.
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

### AGUILA'S BOON IS NO LONGER WASTED — **BUILT AT EW. THIS ITEM IS CLOSED.**

EV reported that the eagle's party crit overshoots an implicit ceiling harder than either of the
bear's clamps binds, and that `_bond_fallback` deliberately could not reach it because **the ceiling
is shared with every other crit source** — so whether a stack is wasted depends on the attacker, the
ability and the target. **EW answers it at the ceiling instead of at the boon**: the assembled total
converts its own surplus into crit multiplier, so no source has to be told what share of the ceiling
belongs to it. **The eagle needed no special case and got none.** **CANIS WAS NEVER A QUESTION** —
its term is genuinely unbounded, measured at ×30.16 at rows 1–9 and still climbing.

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
- **B IS REJECTED, ON ITS OWN MEASUREMENT.** A rung-aware Break gate becomes a **spec** gate.
  **This is now a `CLAUDE.md` standing rule** — a rung may only scale a system every spec can
  participate in — because it settles with no implementation and would otherwise be lost when this
  file is next rewritten.
- **A IS THE ONE TO AVOID**, exactly as EP warns: not to be stacked on an unplayed ×0.50.
- **E IS REAL BUT IT IS RUNG 3's.** *"Fix E separately whenever convenient."* See the item below.

**WHAT IS STILL THE DESIGNER'S INSIDE C:** which abilities, on which enemies, at which rung.
**Rune and ability content is content and this file does not invent it.**

### RUNG 3'S BARGAIN TWIST INVERTS — **MEASURED AT EP §1, AND IT IS NOT THIS BRIEF'S RUNG**

`roll_offer` draws one option from the pool at or below `severity_floor` and two from above it.
At rung 3's floor of 4 there is nothing above it, both gambles fall through the guard clause, and
all three options come from the whole twenty-modifier table. **Measured over 400 offers a rung,
mean severity offered is 2.83 / 3.29 / 2.31 — the top rung's bargains are MILDER than the starter
rung's.** The high pool holds **8 / 4 / 0**. **The stale comment that said otherwise is corrected;
the behaviour is untouched.** **RULED AFTER EP: it is a real defect and it is rung 3's — *"fix E
separately whenever convenient."* It is not bundled into the rung-2 work above.**

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

### THE THREE DESIGN QUESTIONS ES HANDS OVER — **ALL THREE ARE CLOSED NOW (ET, EZ, AND FN'S RETIREMENT OF TAG CONDITIONS)**

**BATCH EZ §0 ANSWERS PRICING AND OPENS THE POOL, AND THE READING BELOW IS KEPT AS THE RECORD OF
WHAT THE OLD POOL CHARGED.** (1) **PRICING IS RULED: 100g, FLAT, EVERY AUTHORED RUNE** — rarity is
gone and price no longer signals power, so the player pays for FIT rather than magnitude; the
retired runes keep their authored prices unmoved as history and the generated family keeps
`TEMPLATE_PRICE` = 50, and **neither is a second pricing rule.** `check_ez` §0 asserts the flat 100
as an equality over the live pool. (3) **THE FIRST RUNE TO KEY OFF A TAG WAS BUILT — eight of
them were, until FN** — and what was left of that item was the eight unauthored specs, until FK
authored them. **(2) is still closed.**

**BATCH ET §1 RETIRED ALL 53 OFFERABLE RUNES, AND THAT MOVES ALL THREE OF THESE.** They are kept in
full below because they are the measurements the NEXT pool is authored against, and because two of
the three are not answered — only postponed:

- **(1) RUNE PRICING is DEFERRED, not answered.** Flat pricing is ruled; the number is not, and
  **with the pool empty there is nothing left to price.** The 53 still carry their authored prices in
  the data, unmoved, so the distribution below is still readable — but it is a record of what the
  retired pool charged rather than a question anyone owes an answer to today. **It comes back with
  the first authored rune.**
- **(2) THE FIVE UNIVERSALS' CLASSES IS CLOSED.** ET retires the five with the other forty-eight, so
  there is no class left to choose. **The scope AXIS survives and the next pool is authored against
  it**; `check_es` §2 was re-pointed rather than deleted and now watches every entry in the file.
- **(3) THE FIRST RUNE TO KEY OFF A TAG is unchanged and is now the whole of the rune queue.** The
  machinery is untouched and still reads nothing; the core-kit baseline it must be authored against
  is printed by `check_es` §4 every battery run.

**Full evidence: `docs/reports/ES.md` and `docs/reports/ET.md`.** ES built machinery and authored
nothing, and the standing rule it recorded is why: *a batch may build machinery, re-scope, retire or
repair; it never authors a rune and never presents rune content as options.* **ET is that rule taken
to its end.** Each question below has its measurement attached and none has an option list,
deliberately.

- **(1) RUNE PRICING, WHICH RARITY LEFT BEHIND — NEW AT ES §1 AND THE SHARPEST OF THE THREE.** The
  53 offerable runes carry **50g ×1, 75g ×14, 100g ×27, 120g ×6, 160g ×5**, every one written against
  a tier table that no longer exists. **The 75 and 120 rows exist SPECIFICALLY to undercut a clean
  peer price that is gone** (the old schema asserted a costed rune must be cheaper than its clean
  rarity peer; there is no peer). **Not one price moved and no rule was invented.** The generated stat
  family sits on `Runes.TEMPLATE_PRICE` = 50 — the Common floor it already had, which is the absence
  of a rule rather than a new one. **This joins the three pricing questions below rather than
  replacing them**; it is about the rune layer's own prices, where EB §1's ruling was about cores
  against draft cards.
- **(2) WHICH CLASS EACH OF THE FIVE UNIVERSALS LANDS ON — RULED TO MOVE AT ES §2, UNMADE.** Scope is
  spec-and-class only; the five are **re-scoped, not retired**, and until the classes are named they
  keep `scope: "universal"` with `check_es` §2 asserting they still roll for all twelve. **They are 5
  of every spec's 9–12 offerable runes — 42% to 56% of the drawable pool — so this is the largest
  single movement the pool has ever taken.** If all five landed on one class the other nine specs
  would fall to **4–7 offerable against 3 rune slots**, and the Occultist (thinnest at 9) to **4**.
  **The field-neighbourhood evidence does not decide it**: `reaper`, `glass`'s cost term and
  `vampiric`'s upside term are written by no other rune in the file, and the three that CAN be placed
  point in different directions. Table in `docs/reports/ES.md` §2a. **And re-scoping `glass` or
  `vampiric` outside Warrior removes the Swordmaster's fallback EP measured.**
- **(3) THE FIRST RUNE THAT ACTUALLY KEYS OFF A TAG — MACHINERY BUILT AT ES §4/§5, NOTHING
  AUTHORED.** A rune can ask **how many equipped cards of tag X its holder carries**
  (`Runes.tag_threshold_met`) or **how many different tags it spans** (`Runes.breadth_met`).
  **Thresholds are the default shape and a splash pays for breadth**, both ruled. **The one hard
  constraint on whoever authors the first is measured and printed every battery run**: the protected
  cores ALONE meet a 2+ threshold on **BREAK for ten of the twelve specs** and on **DEBUFF for
  five** (the class kits count, since GN; six until HB), so those two magnitudes are already spent; **MARK and TEMPO are zero for all
  twelve** (since GS §1 a lineage's cores are its enablers and the class kit), so those two are the ones a draft can
  actually move. **And the place a rune
  reads it in a fight is the SPAWN, not the strike loop** — the loadout cannot change during a
  battle. `CLAUDE.md` carries all of that as a standing rule.

### THE ARCHETYPE TAGS — READABLE AT ES, KEYED TO NOTHING, AND EVERY DESIGN QUESTION STILL OPEN

**Full evidence: `docs/reports/EK.md` (the derivation), `docs/reports/EL.md` (the names and the
seventh) and `docs/reports/ES.md` §4 (the reading machinery).** The vocabulary is
`DEBUFF · DEFENSE · BREAK · RESOURCE · OFFENSE · TEMPO · MARK`, it is on every ability in the corpus
and every authored rune, and the draft card shows it.

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

**ITS ARITHMETIC WAS MARKED STALE AT DT AND IS RE-DERIVED AT DY §5. §2 AND §2b ARE CURRENT OVER
THE LIVE 154.** The audit measured the draft at **142**; DR was net +1, DS +6 and DY +5.
**NINE OF THE SIXTEEN POOL ROWS MOVED AND SEVEN DID NOT** — Swordmaster and Cryomancer (DR),
Beastmaster, Sharpshooter and Survivalist (DS), Warden, Arcanist, Devout and the Mage class pool
(DY); Berserker, Holy Cleric, Occultist, Pyromancer and the Cleric, Hunter and Warrior class pools
did not. **THE METHOD IS DQ's, UNCHANGED AND DELIBERATELY SO** — one primary axis per card, and the
eleven cards authored since were assigned inside that vocabulary rather than a re-cut one, because a
refresh that also moves the definitions cannot be compared with what it replaced.
- **THE WARDEN IS THE SHARPEST RESULT: his pool now holds the JOINT-WIDEST decision
  spread in the game — ten decisions across ten cards, the only pool where every card makes a
  different decision.** **THE MAGE CLASS POOL IS THE OPPOSITE**: seven cards, six decisions.
- **AND TWO COUNTS IN THAT DOCUMENT WERE PRODUCED BY DIFFERENT METHODS, WHICH IS NOW LABELLED.**
  DR reported its own repair as taking the Swordmaster *"four → eight decisions"*; by DQ's method it
  is **seven**, because DR counted Wheeling Cut's self-mitigation as a second axis on one card.
  Neither is wrong and both were in the page unlabelled.
- **`test_batch_cd.PER_SPEC_DEPTH` IS STILL THE ONE AUTHORITATIVE DEPTH TABLE** — this page is not
  an instrument and nothing re-derives it, which is exactly the hazard DJ recorded a rule about.
  **The Beastmaster's 8-of-8 engine binding reads 10-of-10** and is if anything tighter.

- **THE TWO GRADE-2 FINDINGS ARE CLOSED.** Flash Freeze ← Glacial Prison was answered by
  **retirement**; Battle Poise ← Answering Steel by **differentiation**. `check_dr` §4 and §6 pin
  both, and §4 asserts the SURVIVOR of the pair is still there — retiring the wrong half would
  pass every other assertion.
- **THE COOLDOWN-ZERO QUESTION IS CLOSED AT DU §1, IN THE DRAFT CHANNEL ONLY.** **PYROBLAST KEEPS
  COOLDOWN ZERO** and the rule is in `CLAUDE.md` **with its reasoning**, which is the half that
  stops a later batch reading Lunge and Pyroblast as an inconsistency: *a repeatable draft card is a
  legitimate shape when it is priced elsewhere.* **6.0 delay is the longest in the project and 45
  mana the second-highest cost in the game; Death Ray costs more and carries cooldown 3.** DR's
  reasoning did not transfer because Lunge was ordinary on both axes and Pyroblast is ordinary on
  neither. **If a cooldown is ever taken anyway it is on the UNIQUENESS argument and it is 2, not
  3.** `check_dr` §5 still prints the live draft list every run and still walks the DRAFT POOLS
  ONLY, deliberately. `docs/draft-audit.html` carries the RESOLVED banner naming both halves.
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
### THE LOYALTY CURVE — **BUILT AT EU, REPAIRED AT EV. IT CONVERTS AT 8, AND A CONVERTED STACK NEVER PAYS NOTHING.**

**Full evidence: `docs/reports/EU.md` (the build, the measurements and the census), with
`docs/reports/ER.md` §1 (the ruling priced) and `docs/reports/EQ.md` §1/§2 (the read-site census
and the six shapes) behind it.** **The rule is in `CLAUDE.md`, `check_eu` is the gate, and the
figures live in the EU report — do not quote a number from this file.**

- **THE SHAPE, IN ONE LINE.** `BOND_CONVERT := 8` beside `BOND_STEP`. **The first 8 stacks buy the
  companion's strike step; every stack past 8 stops adding to it and feeds the Pack Bond boon
  instead**, so the boon climbs at double its step above the point. `_bond_convert()` is the one
  place the split is decided (`focus_convert()`'s counterpart, taking the hunter so a later rune
  moves one line); `_bond_paid` and `_bond_converted` are its two halves, and they are disjoint and
  sum to the whole meter.
- **BELOW THE POINT NOTHING MOVED, AND THAT IS ASSERTED RATHER THAN CLAIMED.** `test_batch_ay`'s
  x2.0-at-five arm is unchanged and is the arm that proves it.
- **WHY 8 AND NOT THE NOMINAL 5 — THE ONE MAGNITUDE THIS BATCH CHOSE.** Loyalty arrives at
  10.08 ±0.12 at a first-clear loadout and 6.64 ±0.09 untalented (ER §6). A split at 5 converts
  most of a typical meter; **a split at 8 bites only the tail that over-arrives.** **And 8 is
  Kindred's own threshold**, so no lower point could put a row-8 node on the far side of a phase
  change the player never chose.
- **THE RATE NEVER MOVED.** `BOND_STEP` 0.20, the strike step 0.05, Wild Communion, Absolute
  Devotion and Ancient Pact are all untouched. That is `CLAUDE.md`'s standing rule — move the
  point, never the rate — and `check_eu` §0 asserts both rates at their source.
- **THE ACCRUAL IS UNTOUCHED, WHICH IS THE PROPERTY THE SHAPE WAS RULED FOR.** Nothing is written
  into `_gain_loyalty` or `_loyalty_cap`, so **Kindred still fires at 8, Lone Bond still seats at 6,
  None Left Behind still seats at 5, Wild Rotation's cap of 3 is still the only ceiling** — and
  **Unleash, Primal Surge, Last Howl and Bring It Down pay exactly what they paid before EU**,
  because all four COUNT stacks and the split changes what a stack PAYS. `check_eu` §2 CASTS all
  four on a live board rather than reading them, because a converted Unleash still fires, still
  logs, still empties the meter and simply pays less.
- **FIVE PAYOUT SITES CONVERT, AND ER'S OWN TABLE LISTED FOUR.** `_comp_dmg_mult` and
  `_ghost_hit`'s strike step read the paid half; `_bond_mult` receives, carrying Ursus's
  mitigation, Canis's wounded bonus, Savage Presence's taunt and Aguila's party crit with it.
  **`_bot_boon_worth` is the fifth** — it recomputes the same curve so the bot can price a swap —
  **and ER §1d omits it** (EQ §1's census has it). Left behind, it would have made the bot
  under-value exactly the deep bonds the conversion pays most for.
- **TWO FUNCTIONS HOLD BOTH KINDS OF READ IN ONE VARIABLE, AND THAT IS THE SHAPE TO LOOK FOR NEXT
  TIME.** `_ghost_hit` pays its strike step off the paid half while Aguila's armor pierce beside it
  reads the whole meter; `_companion_strike` likewise for Canis's Bleed. **The read site is the
  line, not the function.**
- **THE CLAMPS BIND HARDER, AND THAT SENTENCE WAS OWED.** `BOND_MITIGATION_MAX` 0.75 and Savage
  Presence's taunt clamp of 1.0 both read `_bond_mult`, and EU feeds it. **Neither becomes a dead
  constant**, which is what capping that half at nominal would have done. Binding rates before and
  after, at three loadouts, are in the EU report.
- **AND "BIND HARDER" HAS A FAR SIDE THE SENTENCE DID NOT CARRY, WHICH IS WHAT EV REPAIRS.** A clamp
  that binds on *every* stack has stopped governing and started confiscating: at rows=9 both of
  Ursus's were already full, so a converted stack bought nothing at all. **`_bond_fallback()` sits
  beside `_bond_convert()` and hands those stacks back to the strike step**, and both halves read it
  from ONE call so they remain disjoint and still sum to the meter. **It is per stack, it declines
  the one-stack window at Loyalty 9, and the boon loses nothing to it** — over 228 measured ursus
  blows the boon itself fell on 183 and the two terms it feeds differed on none. `check_ev` is the
  gate; the figures are in `docs/reports/EV.md`.
- **ONLY URSUS HAS A SATURATION POINT AND THAT IS A MEASUREMENT, NOT AN OMISSION.** Canis's
  wounded-prey bonus and Aguila's shared crit are spent UNCLAMPED, so no stack of theirs can ever
  pay nothing and nothing of theirs falls back. **Aguila's boon WAS wasted harder than the bear's is
  clamped, and BATCH EW ANSWERED IT AT THE CEILING RATHER THAN AT THE BOON** — the assembled crit
  total converts its own surplus into crit multiplier, so the eagle needed no special case and got
  none. `_bond_fallback` is byte-unchanged.
- **THE TEXT COST WAS SMALLER THAN ANY FLATTENING'S, EXACTLY AS ER PREDICTED**, because the meter
  stays uncapped: the surfaces needed the second phase NAMED, not the *"no ceiling"* promise
  retracted. Chip, status tooltip, Pack Bond passive text, `master.html`'s Beastmaster block and
  chip row, and both glossary entries.
- **`CY_METERS`' 5 WAS DELIBERATELY NOT REPOINTED AT `BOND_CONVERT`.** It means *where the boon
  reads x2*, which is still true and is the denominator every arrival figure from EQ, ER and EU is
  quoted against. The two numbers answer different questions and the header there now says so.
- **~~WHAT IS STILL OPEN, AND IT IS THREE THINGS NOW: TWO CLAMP QUESTIONS (above) AND THE RUNE THAT
  MOVES THE POINT~~ — ALL THREE ARE CLOSED (GB §4 census):** both clamp questions are answered above,
  and the Long Leash rune moves the point UP, 8 to 11, which `_bond_convert` records as the
  designer's direction. ER §2 established that the item a
  re-authored Deep Bond would be is `Rune of the Deep Sight`'s exact shape and that its direction
  was undecidable until the currency was chosen. **The currency is chosen now**, so the table in
  ER §2c resolves: the converted half is worth MORE than the strike step at depth, so a Deep Bond
  moves the point DOWN — Deep Focus's exact shape. **EU authors no rune** (ET §1 retired the pool
  and rune content is written with the designer), and `_bond_convert`'s signature is the slot.

### THE FOUR RUNE ITEMS — **THE THREE RE-AUTHORS ARE MOOT AT ET §1. THE MEASUREMENTS ARE KEPT.**

**BATCH ET §1 RETIRED ALL 53 OFFERABLE RUNES, AND THE DEEP BOND, THE TURNING PACK AND THE SHARED
WILD ARE ALL `spec:beastmaster`. ALL THREE RE-AUTHORS ARE MOOT AND THE QUEUE NO LONGER CARRIES THEM
AS OWED.** The Bared Guard is retired with them and its standing rule in `CLAUDE.md` survives it —
that rule is about **a rune that CHARGES**, which is what `Runes.is_cost` recognises, and `check_es`
§3 still asserts the costed population over every entry.

**EVERYTHING BELOW IS KEPT AND NONE OF IT IS STALE**, because every figure in it is a fact about a
SYSTEM rather than about a rune: the Turning Pack's first clause being worth zero to any Beastmaster
holding Quick Whistle is a fact about `SWAP_COOLDOWN` and a floor at 0; Feral Momentum's +8% being
worth about +9.9% is a fact about how many different companions are fielded at a blow; the
companion-death event at 0.22 a trash fight is a fact about companion durability. **The next pool is
authored against the same systems, so these are the numbers it starts from.**

*The original block follows, unedited.*

**ER ADDED THE SHAPE THE DEEP BOND'S RE-AUTHOR FALLS OUT OF, AND BROKE TWO MORE OF THE PREMISES.**
- **THE ITEM A RE-AUTHORED DEEP BOND WOULD BE IS ALREADY IN THIS GAME AND WAS RETIRED AT EO §3.**
  **`Rune of the Deep Sight`** — 100g, and it was the same price and the same tier as the Deep Bond
  when both had one (**ES §1 removed the tiers; both prices are unmoved**) — carried `rune_deep_focus: 8`
  into `focus_convert()`, and its `retired` string names the loss exactly: *"the one item that
  changes WHEN his patience converts rather than how much it pays."* **A Deep Bond that moves the
  Loyalty split point keeps DEPTH as its axis, keeps rewarding NOT swapping, and mirrors no node.**
  **Its DIRECTION cannot be chosen until the conversion's CURRENCY is** — down is a buff only if the
  converted half is worth more — **which proves EQ's and ER's hold on this rune by construction.**
  Four shapes are priced in `docs/reports/ER.md` §2d and none is authored.
- **THE TURNING PACK'S CONCENTRATION PREMISE IS WRONG FOR THE THIRD TIME, RE-DERIVED.** Over all
  twelve boss pools, **THREE carry no card with a `damage` field — Beastmaster 5, Holy 3, Devout 2
  — and all three carry no `pressure` either.** By TAG the Beastmaster holds **six BREAK cards**,
  mid-pack of twelve against a range of 0–11; **the spec with no Break at all is the Devout**, who
  also holds the thinnest boss pool in the game at 2. **What survives is a better fact:
  `_companion_hit` takes a Break argument and SIX OF ITS EIGHT CALL SITES PASS `pr = 0`**, including
  every ordinary companion strike — so the companion's routine blow Breaks nothing, which is what a
  Break re-author should be argued from.
- **AND EQ'S TEMPO COUNT IS OFF BY ONE.** *"Eight of the twelve specs carry ZERO TEMPO cards"* is
  **SEVEN** over EQ's own population, and **THREE** over the pool a player can reach since EH §1
  opened the class-wide tier — with **two** specs beating the Beastmaster's one, not one.

**Full evidence: `docs/reports/EP.md` §4 (the presentation) and `docs/reports/EQ.md` §3/§4
(the measurements and the priced options).** The floors those batches measured were **65 authored,
12 retired, 53 offerable; drawable 9 (Occultist), spec-scoped 2 (Cryomancer), against 3 rune slots**
— **and ET §1 took every one of them to zero: 65 authored, 65 retired, 0 offerable.** They are kept
as the record of what the pool was. **Nothing is authored here — rune content is content and it is
the designer's.**

- **EQ ADDED THE NUMBERS ALL THREE ARE PRICED AGAINST, AND ONE OF THEM CHANGES A RUNE'S VALUE TO
  ZERO.** **The Turning Pack's first clause pays nothing to any Beastmaster holding Quick Whistle**
  — `SWAP_COOLDOWN` is 3, the node shaves 3, and the read site floors at 0 — **and Quick Whistle is
  pack row 1.** Swaps fall **0.38 → 0.21 → 0.02** a trash fight as the build deepens. **Feral
  Momentum's own term reads a mean of 1.235 different companions at a blow**, so the +8% clause both
  the Turning Pack and the Shared Wild carry is worth about **+9.9%**, not +24%. **The Shared Wild's
  event is real** — 0.20–0.22 companion deaths a trash fight and 0.35–0.48 at a boss with rows 1–3
  — and **its health clause is the only one of the six that can never be worth nothing.**
- **AND THE CONCENTRATION FACT THE TURNING PACK'S RE-AUTHOR WAS AIMED AT IS WRONG IN BOTH
  READINGS** — see the WHERE block. **Three boss pools carry no `damage` field, not one**, and on
  the behaviour reading his does not qualify at all.

- **RUNE OF THE DEEP BOND — THE DESIGNER RULED AFTER EQ'S BRIEF THAT IT KEEPS DEPTH, AND EQ
  DID NOT AUTHOR IT.** The earlier ruling was *"its axis is the one thing measurement says not to
  lean on: Loyalty already over-arrives at a 21.2 peak against a nominal 5"*; **the reasoning that
  overturned it is that DEPTH is the rune's identity — it is the only one of the three that rewards
  NOT swapping, which is what makes it the Turning Pack's exact opposite.** **EQ's measurement
  says the meter is fixed rather than avoided, and that the two are one decision**: both its clauses
  are PAYOUT readers sitting on the two steepest terms in the system, one of which Ancient Pact then
  doubles. **21.2 was `rows=9`; live at that loadout it is 18.45 and at rows 1–3 it is 10.13.**
  **AND THE REPLACEMENT AXIS IS NOT NAMED, WHICH IS THE OPEN HALF OF THIS RULING.** EP's argument
  for authoring the pair at all was that **Deep Bond is the only one of the three that rewards NOT
  swapping**, which makes it the exact opposite of the Turning Pack and gives the two a real
  decision between them — and DEPTH was how it expressed that. **Dropping depth without replacing
  the not-swapping identity collapses the pair into one idea**, so the axis that replaces it should
  be chosen with the Turning Pack in view rather than on its own.
- **RUNE OF THE TURNING PACK — RE-AUTHOR, AND EQ SHARPENED BOTH HALVES OF THE CASE AND BROKE
  ONE OF ITS PREMISES.** The ruling was *"tempo is his thinnest axis, and his boss pool is the only
  one in the game with no damaging card — so a version paying the swap in Break or a damage window
  answers a concentration finding instead of deepening it."* **The swap figure's DIRECTION reproduces and its
  MAGNITUDE does not** — per trash fight ER reads **0.28 (rows 0) → 0.22 / 0.23 (rows 1–3) → 0.01
  (rows 1–9)**, against 0.35 at EP and 0.38 at EQ for the untalented arm. **The pool claim does not
  survive: three pools carry no `damage` field and his holds the game's largest Loyalty payout by
  volume.** And
  **Tempo is his thinnest axis only inside his own kit** — eight of the twelve specs carry ZERO
  TEMPO cards against his one. **Five options are priced in `docs/reports/EQ.md` §3 and none is
  authored**; three of the five keep the opposition to the Deep Bond explicit and **one (paying the
  swap in Loyalty) collapses the pair from the other direction.**
- **RUNE OF THE SHARED WILD — SAFEST, KEPT CLOSEST TO AS-IS, AND EQ MEASURED THE EVENT.**
  *"Companion durability is the one Beastmaster number nothing else touches, and 0.22 deaths a trash
  fight is a real event."* **THE TRASH FIGURE IS ROCK STEADY ACROSS FIVE INDEPENDENT READINGS —
  0.22 / 0.22 / 0.23 / 0.22 / 0.22.** **THE BOSS FIGURE IS NOT A MEASUREMENT AT ITS n AND THREE
  BATCHES HAVE QUOTED IT AS IF IT WERE**: at the untalented arm it has read **0.39 (EP), 0.48 (EQ)
  and 0.26 (ER)**, on **n ≈ 95 boss fights** each time, 2.5σ apart — the per-fight distribution is
  over-dispersed and n ≈ 95 cannot resolve it to better than about ±0.1. **Read it as a band,
  0.26–0.48, and price the rune against the trash figure.** The event nearly vanishes fully
  talented (0.06/0.10 at ER). **Four options are priced in `docs/reports/ER.md` §4c and four more in
  `docs/reports/EQ.md` §4; none is authored. The honest cost is stated and accepted:**
  re-authoring a splash as one idea makes it a lane rune wearing a splash's name — **and the sim's
  own rune policy makes that concrete, since `_pick_rune_candidate` prefers a candidate whose `lane`
  matches the build's target lane, so a splash is already the last thing the bot reaches for.**
- **RUNE OF THE BARED GUARD — KEPT, AND THE 80% REFUND IS ACCEPTED.** This one settles with no
  implementation, so **it is a `CLAUDE.md` standing rule** rather than a queue item: paying a point
  and a lane to soften a COSTED rune is a decision, which is what the cost is for. (**ES §3
  relabelled that rule and did not weaken it** — there is no Scarred label; `Runes.is_cost` is what
  recognises a cost, and the Bared Guard's −0.15 is byte-unchanged and still one of the 17.)

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

- **THE THREE CLAUSES WITH NO HOME ARE ANSWERED AT EN AND THIS QUESTION IS CLOSED.** EM priced
  four options and authored none; **EN took option A** — `divine_presence_pct`, `entropy_ranks` and
  `pleasure_pct` each have a `rune_` field of their own and each drip's EXISTING tick sums the
  pair. **No second tick, because a hero holding both would be paid twice.** All three are payouts
  with presence tests, read at their own sites; **AL's MAX rule has zero applications across all
  59.** Driven live and seeded, before and after: **every reading reproduced exactly**, and the
  control taking the node's half alone took all three to zero. `check_em` §4 asserts the CLOSURE
  now, in both directions, over a live population of three. **Nothing else in the rune layer is
  mechanically outstanding.**
- **THE SIXTEEN THE CHARTER EMPTIED ARE RULED AT EO. TWELVE ARE RETIRED; FOUR WERE OPEN AS DESIGN
  UNTIL ET §1 RETIRED THEM TOO.** The sixteen reproduce EM §3 **name for name** off `LANE_TREES` and
  `runes.json` — **but only once a `UNIT_MATH` clause counts as a rune SURVIVING.** (EN recorded
  this as *"with `check_em.UNIT_MATH` excluded"*; EO's first re-derivation read that as
  *excluded from the denominator*, returned **twenty-two**, and swept in six runes EN's own
  threshold table names as survivors. `still_wrist` carries `parry_bonus` beside its one
  talent-keyed clause and is therefore still an item that does something no node does.)
  **THE WHOLE POOL WAS RETIRED BY ET §1** (it was 12 retired and 53 offerable when the
  reading below was taken, and the reading is kept because it is about the CLAUSES rather than about
  what is drawable).
  - **CLOSED AT ET §1: the three Beastmaster re-authors and the Bared Guard are all retired**, so
    none is owed. The reasoning below is kept because the next pool is argued against the same
    systems.
  - **WHAT WAS OPEN, AND IS NOW THE NEXT POOL'S TO ANSWER:**
    `docs/reports/EO.md` §3 carries all four — theme, axis, balance and synergy for each of the
    three, and the Bared Guard's loss-and-gain reading — **and nothing is authored.** The Deep
    Bond's axis is DEPTH and its risk is a Loyalty meter already over-arriving; the Turning Pack's
    is BREADTH/TEMPO and its risk is a second non-damaging item in a pool with no boss damage; the
    Shared Wild's is the companion's BODY and it is the only splash of the three, which is the half
    the charter hurt most. **Retiring the three would leave no rune in the game touching a
    companion, and the companion IS the spec.**
  - **THE BARED GUARD WAS LIVE AND OFFERABLE UNTIL ET §1, AND RULED ON NOWHERE UNTIL EP.** §3's
    brief ruled *retire the rest* and then ruled this one *reported separately and ruled on
    nothing*; the specific instruction governs. Its two clauses ARE the trade (+10% Aggressive
    Stance bought with −15% off Defensive Stance), so **retiring it removes the cost with the
    upside** — it was the only item that let a Swordmaster buy commitment, and losing it would have
    made him **the only spec in the game with no rune that charged for its upside.** (**ES §3
    re-derived that population and it is a different 17 from the flag's** — see the WHERE block —
    but the Warrior arithmetic is unaffected: `exsanguination` is the Berserker's and `anchor` is
    universal.)
  - **RETIRED MEANS KEPT — AND THE CONTRACT PAID FOR ITSELF IMMEDIATELY.** Each of the twelve keeps
    its `runes.json` entry with a `retired` string naming what is lost; `config` / `build` /
    `display_name` still resolve it. **`test_batch_bj` pins the Whispering Dark's own description
    into that file, so a retirement that DELETED the entry would have taken a pin red.**
  - **AND THE DISTRIBUTION EXPLAINS THE SHAPE OF THE RESULT.** All 59 clauses sat in the 48 spec
    runes; the 5 universal and 12 class-wide carried none. Measured floors after the retirement are
    **9 drawable, 2 spec-scoped, 5 on the rare shelf, against 3 rune slots** — the Occultist is
    thinnest, and **the Beastmaster is the only spec whose pool did not shrink at all**, because his
    three went to the re-author half.
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
- **THREE RUNE-ONLY EFFECTS STILL ANNOUNCE THEMSELVES AS TALENTS** — `beacon_ranks`,
  `capacitor_ranks`, `mindfulness_ranks`, none of which has a node of that name in any tree — **and
  three more share a label with a node the holder may not own** (Grudge, Shared Vigil, On the Edge).
  The *"→ Rune:"* convention already exists. **Reported at EJ §2b, not fixed; player-facing text,
  and the charter makes it worse rather than better.** **GB's census: FX deleted Grudge, Shared Vigil
  and On the Edge, and every writer of the six fields is a retired rune, so none of the six labels
  can print in a new run.**
- **`pyromaniac_ranks` IS STILL THE ONE CLAUSE THAT PAYS NOTHING.** The White Flame writes it and
  nothing reads it — Inferno Master's per-turn step stopped existing at AR. `unit.gd` flags it and
  AR §4 forbids inventing a read site. **A 120g rune with two live clauses of three.** It
  was NOT in the 59 (nothing reads it, so no node counter is involved) and EM did not touch it.
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

- **`CLASS_POOLS` IS DELETED AT DY §3 AND THE THREAD IS CLOSED.** DV ruled it a lost feature and
  deleted nothing; DX priced the options and authored nothing; **DY took option B — re-home the
  seven, retire the container.** 61 authored entries feeding an award AN §4 re-pointed eighteen
  batches ago. **`pool_ability()` never read it, so nothing stopped resolving**; what was lost is
  the manifest, and that is the point — they are no longer a group.
  - **THE SEVEN WERE THE VAULT, AND ALL SEVEN HAVE HOMES NOW.** `Classes.vault_ability()` holds the
    ONE definition of **TEN** live cards (not the 38 this file and DX §3 both recorded — counted off
    its own `match` arms). Five went to draft pools and two to Holy's boss pool; the other three
    were already in `SPEC_POOLS`. **Its header's promise — that its entries *"return as earnable
    picks without a line of new mechanics"* — is history rather than a plan, and it cost exactly
    that: not a line.**
  - **THE STANDING RULE IT LEAVES, IN `CLAUDE.md`: A NEW VAULT ENTRY IS OWED A POOL IN THE SAME
    BATCH.** A definition no pool names is reachable by nothing, which is the state that cost this
    project eighteen batches of silent audit and three batches of measured engineering — DK widened
    `sanctuary` and drove it on a live bear, DL widened Rallying Shout's Pressure clause and authored
    a new guard for it, DM read Divine Wrath's two clauses. **Not one of them was wrong and not one
    could have known.**
  - **AND THE DELETION'S REAL COST WAS THE READERS.** **EIGHTEEN FILES read it and a grep for the
    CONSTANT found only eleven** — `class_pool()`, its accessor, had callers whose lines never name
    it. **Sweep for the accessor as well as the constant.** Every reader is re-pointed or inverted;
    none was left to pass vacuously.
  - **ONE DERIVED FIGURE MOVED FOR A REASON THAT IS NOT ABOUT THE GAME.** `check_dv` §5 counts the
    abilities outside every pool and every class kit: **16 → 43**, because `CLASS_POOLS` was the only
    structure naming the SIBLING SPECS' KIT ABILITIES as pool entries. **Nothing became less
    reachable** — all of them were in their own spec's opening kit (since GS §1, on its shelf, or an enabler). `check_cz`'s set identity held
    through the deletion, measured: the CL walk still reaches **223 of 227** and still misses exactly
    the four kit overrides.
- **AND EG §1/§2 MOVED THE ARITHMETIC UNDER ALL OF IT — THE ONE LIVE RULING THIS BATCH LEAVES.**
  EA's guarantee rested on a hero holding at most `cap − core_slots` earned cards against pools of
  ten to thirteen: a floor of SIX. **Both terms moved.** The cap is a ladder to ten, so the LOADOUT
  bound alone takes the floor to **3 for several specs and 2 for the Occultist** — measured, and
  `check_ea` §1 went RED on it. **And the POOL is unbounded**, because a benched card is kept and
  `owned_ability_names` reads the pool, so the true worst case floors at **zero**.
  - **THE ASSERTION WAS SPLIT RATHER THAN LOOSENED, WHICH IS DC's REPAIR-TO-INTENT RULE.** EA's one
    check was asking two questions: the RULE is *an award always pays* (`floor >= 1`, still green on
    all twelve) and `>= awards` is the stricter *every award offers a full three*. At a flat cap of
    seven the floor was six everywhere and both held. **`check_ea` §1 asserts the first per spec and
    pins the specs that can fill SHORT as a NAMED SET (`[occultist]`)**, so a thirteenth trips and
    the Occultist leaving trips too. **The Occultist left it at GS**: every hero opens at three slots, so the
    set is empty, and a spec that can fill short trips it again. **The POOL bound is PRINTED, not asserted.**
  - **THE OPTION EA PRICED IS A CLASS-WIDE THIRD TIER, AND EH §1 TOOK IT.** EG did not, and the
    sim read `nothing left to offer` at **0.00 per run in both samples** — reachable in principle
    and not reached in fifty runs. **The chain is boss pool → spec draft pool → class-wide draft
    pool now, the loadout-bound floor runs 8–13 across the twelve, and EA's second tier is
    byte-unchanged.** **What EH did NOT take from EA's pricing is the word "completely"**: EA
    recorded a class-wide card as closing the table, and it does so only under the LOADOUT bound.
    See the WHERE block at the top of this file.
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
  - **THE FIGURE NOBODY HAD PUT A NUMBER ON, DERIVED AT DZ §1: 14 OF THE GAME'S 36 ZONE-BOSS
    AWARDS COULD PAY NOTHING**, in a run where every hero drafts against their own boss pool.
    **EA §1 TOOK IT TO 0**, and the thinnest fallback pool in the game is the Occultist's.
  - **WHAT HAPPENED BEFORE EA WAS NOT A WEAK REWARD, IT WAS NO ACKNOWLEDGEMENT AT ALL.**
    `award_ability_pick` returned false and `_award_ability_picks` **silently skipped that hero**,
    so the victory card did not name them. **That was the baseline the fallback was measured
    against, and closing it is why EA's control reads the announcement off the end card's own
    Label rather than asserting that `battle.gd` contains a line.**
  - **THE FALLBACK QUESTION IS CLOSED AT EA §1: OPTION A WAS TAKEN.** The four candidates were
    priced at 154 in `docs/reports/DZ.md` §1 (DV §2 priced them at 149, against a game that has
    moved); **EA built the spec-draft card.** The pricing is kept because it records why the other
    three were not taken:
    - **A spec-draft card or a class-wide card closes the table completely** — 8 emptiable specs →
      **0**, 14 lost awards → **0**. **THE FLOORS QUOTED HERE (SIX AND TWO) WERE DERIVED AT A FLAT
      CAP OF SEVEN AND AGAINST A LOADOUT THAT WAS ALSO THE POOL. EG BROKE BOTH TERMS** — see the
      live block above; they are kept as EA's working, not as current figures.
    - **A rune has the lowest build cost of the four and it is measured rather than asserted** —
      the grant is the same two fields the ability pick already uses (`rune_candidates` /
      `rune_picks_owed` against `bm_candidates` / `bm_picks_owed`) and the map's owed-pick overlay
      resolves both. **But `roll_rune_candidates` returns `[]` when runes are off or the pool is
      exhausted, so this option needs its own fallback.** 3 rune slots a hero, 65 in the pool.
    - **Gold does not move the table at all** — all fourteen are still lost as ABILITY awards. A
      zone boss already pays `randi_range(110, 130)`.
    - **AND A CLASS-WIDE CARD IS NOT THE THING DY §3 FORBADE.** That rule says do not re-create
      `CLASS_POOLS`; its own next sentence says a re-opened class draw reads `CLASS_DRAFT_POOLS`,
      which is what this option reads. **Worth naming, because it looks like a violation and
      is not.**
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
- **NO DOMINATION, AND THE NEAREST MISS IS THE INSTRUCTIVE PART.** Called Shot and Coup de Grâce
  share cost, damage and Break, and Called Shot wins cooldown AND delay. **It does not dominate, and
  only the READ SITE says so**: Coup de Grâce cashes the whole Focus meter for up to 200% of the
  target's missing health. **An audit that scored them by their fields would have reported a
  domination that is not there** — DQ's own discipline.
- **THE CO-SHAPED DEFECT IS FIXED AT DV §3, AND IT IS NOT IN `RECAST_GATED`.** `ashes` writes an
  integer FIELD, and that system reasons about STATUS writes — **driven live on a fully-armed Mage,
  `_recast_targets` returns `[]` and `_recast_refused` returns FALSE**, so membership would have
  been a string in a table and nothing else. It is a bespoke condition at `_ability_usable`, the one
  door, with the reason on the darkened button. **`check_co` could not have found it: it saturates
  the MEMBERS of `RECAST_GATED`, so it measures the list rather than the candidates for it.**
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
- **~~THREE OF THE FIVE NODES NAMED AFTER LIVE ABILITIES SHARE A DRAW SPACE WITH THEIR NAMESAKE~~ —
  MOOT AT FX** (GB §4 census): Killing Frost, Divine Presence and Rally went with the twelve trees, and
  no node of the one tree carries a card's name.
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

**AND EA §3 ANSWERED THE QUESTION DZ's §2 RAISED: IT IS NOT ONE CARD, IT IS THE LAYER.** Every
protected core was compared against the draft cards that do comparable work, controlled for spec
(one currency), role (derived from the fields) and initiative, with `PURE_BUFFS` members excluded
from both sides because a clamped initiative is not a price anyone chose. **17 comparable pairs;
13 of the 17 have the core cheaper on an axis and dearer on neither. Resource: cheaper 10, dearer
2. Cooldown: shorter 13, longer 1. Both counter-cases are the same draft card — Divine Plea, at 0
Mana — against Holy's Heal and Renewal.** Cores are SLOWER in every role bucket, which is why the
equal-initiative control is the comparison that counts. **`BUFF_DELAY_CAP` binds 29.5% of the draft
layer against 12.8% of the cores.** **THE COUNTER-ARGUMENT TRAVELS WITH THE NUMBER**: a core
arrives free with the spec and a draft card costs a pick, so "cheaper to cast" is what a designer
would author on purpose if the core is the baseline — and nothing in the code distinguishes the two
readings. **EB §1 RULED IT: the first reading is intended, and `CLAUDE.md` carries the ruling with
the counter-reading beside it.** `check_ea` §4 pins the DIRECTION rather than the counts, so a pool
growing does not red it, and **`check_eb` §1 pins the per-pair INVERSION the ruling does not
cover** — with the one crossover named in both directions then, and none since GT §2.

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
  SINCE DY.** Hymn: 0 Mana + 1 Mercy, all allies 20% of max (35% empowered), initiative 3.5,
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

- **DO's SIX PAIRS ARE RULED AND GONE.** All four Occultist Madness cells were re-pointed onto
  Ruin, and FX deleted all four. **`check_dp` §1 asserts the property on every
  battery run and prints the live count.**
- **~~SIX PRE-EXISTING PAIRS REMAIN, REPORTED AND RULED ON NOWHERE~~ — FOUR WENT WITH THEIR NODES AT
  FX, AND NO COVER'S TWO MOVED ONTO `tn_no_miss` (GB §4 census). FOUR WERE NOT BETS.**
  `sm_guarded` (Crippled, Exposed) is the only real one and is a bonus clause gated on a
  tree-internal node, beside an unconditional base clause. `sv_virulence` and `ss_exposed_nerve`
  each APPLY the Exposed they read. `ss_no_cover` reads Blind and Dazed **on the hero**, applied by
  enemies — an immunity, not a payoff. **Each is in `check_dp.KNOWN_PAIRS` with its reason**, so
  the next batch reads why rather than re-deriving it.
- **~~THE MAGNITUDES ARE THE ONE THING DP AUTHORED AND THEY ARE UNMEASURED~~ — MOOT AT FX (GB §4
  census): the three nodes went with the twelve trees and no node writes their fields.** DP's text:
  Spread of Madness
  keeps 60/2 and Delirium keeps 3, so the Whispering Dark's +15/+1 keeps its proportion; Whispers's
  +2 doubles a base of 2 as its old +45 nearly doubled a base of 50. **Spread and Whispers BOTH
  feed generation and a player can hold both** (rows 1 and 2 of one lane), which is **the number
  most worth a sim** — and no sim has run since DK, so every sim figure below was already stale.
- **~~RUINED MIND IS SCOPED TO BEWITCH ALONE, AND WIDENING IT IS A DECISION~~ — DORMANT SINCE FX (GB §4
  census): the node is gone and nothing writes `broken_mind`; the Bewitch-only gate stands.** Extending the boss
  exception to Psychosis and Hysteria would be a BONUS rather than a bet (Bewitch carries the node
  on its own) — but a clause the text does not state is DM's seventh family.
- **TWO RUNE DESCS ARE OWED A SENTENCE.** Binding Souls and the Flayed Mind both open
  "Grants …", which is wrong whenever the card was drafted. **The Rune of the Last Rites is the one
  that says so honestly** ("She already knows Resurrection, so this hones it instead"), and it is
  the model for the other two. One line each.
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
- **~~FIVE NODES ARE NAMED AFTER LIVE ABILITIES AND DO ADDED NO SIXTH~~ — MOOT AT FX (GB §4 census): all
  five went with the twelve trees.** DN's list: Second Wind, Spite, Rally,
  Killing Frost, Divine Presence. That is the `wd_spiked`/Spite trap DN documented, and it is why
  the Arcanist's row-4 Resonance cell is **Overdraw** rather than Overcharge. Renaming the existing
  five is a save-format question and a separate pass.
- **~~DN'S OTHER TWO FINDINGS ARE UNTOUCHED AND STILL OPEN~~ — BOTH CLOSED AT FX (GB §4 census): the one
  tree superseded the three-lane restructure, and `Profile` carries a version, a refusal floor and a
  migration now.** DN's text: (1) **The three-lane restructure needs
  97 NEW nodes** — 30% of the layer — and **two specs hold a lane at zero** (the Cleric has no
  offensive node in 27, the Sharpshooter no defensive one), which no shrinking of the tree rescues.
  (2) **The saved-allocation drift is real, silent and cheap**: `Profile` is v2, the load is
  TOLERANT, and there is no version a migration could hang on. **DO needed neither, because nothing
  moved a cell** — but a restructure would need both.

### THE FLAKES — **AND THERE ARE NONE. DY SEEDED THE LAST ONE.**

**`test_batch_at` §1 IS SEEDED AND CLOSED AT DY §4, AND IT SETTLED AT ZERO — SO IT WAS A FLAKE AND
NOT A FINDING.** **THERE ARE NO UNSEEDED FLAKES LEFT IN THE PROJECT.**
**AND THE CENSUS WAS TWO ROWS, NOT ONE — THIS FILE SAID ONE AND WAS WRONG.** DX recorded
*"`test_batch_at` is the one row still carrying a `flake` field"*; **`test_rune_battle` carries one
too**, and it is KEPT ON PURPOSE. DF §0 seeded that suite at the site that flakes, but its recorded
rate is a RACE UNDER MACHINE LOAD — 2 red in 15, both under load — and **a seed does not fix a
race**, so the field and the `[0,1]` band both stand. **ONE ROW CARRIES A `flake` FIELD NOW AND IT
IS A SEEDED ONE.** Its own `what` text still read *"test_rune_battle calls `seed()` ZERO times"*,
which DF made false and DT corrected in this file but not there; **DY corrected the record itself.**

- **WHAT IT WAS.** §1's live damage-curve check sums ten casts of Arcane Explosion at 0 Resonance
  against ten at 12 and asserts the ratio is `> 2.0 and < 2.35` against a table value of **2.17**. It
  read **2.40** at DG and clean in every battery since — **twenty consecutive quiet readings at an
  observed rate of about one in eighteen, which proves nothing.** **The file calls `seed()` in four
  places and every one of them is DOWNSTREAM of this check.**
- **THE FIX IS TWO LINES AND THEY ALREADY EXISTED TWELVE LINES BELOW.** The TAKEN half of the same
  function has called `_seeded(_i)` before each of its two compared blows since DD; the DAMAGE half
  never did. Per-PAIR, not per-loop: both arms draw one identical stream so the ±10% roll cancels,
  and `_i` varies the draw across the ten pairs so the sum is still an average of ten variances.
- **MEASURED, WITH THE STARTUP STREAM VARIED BETWEEN TRIALS: six unseeded readings spanned
  2.1189–2.2463; six seeded readings all read 2.1799.** Exactly repeatable, and it lands on the
  table's 2.17.
- **THE BAND WAS NOT WIDENED — the band IS the question** (DD's rule). Opening it to swallow a 2.40
  would delete the check rather than repair it.
- **THE CHECK COUNT DID NOT MOVE: 467.** A seed is not an assertion.

### **AND NO SWEEP OF THE SOURCE CAN CERTIFY THERE IS NO NEXT ONE — ONLY READINGS CAN (DX §2)**

**A source sweep fails in BOTH directions and this is worth more than the answer it was asked for.**
**TWENTY suites and gates make unseeded random draws and are perfectly stable** (`bk` and `an`
generate whole maps), so `seed()`-count is not evidence of a flake. And **`test_batch_at` calls no
RNG function at all** — the noise was `battle.gd`'s `randf_range(0.9, 1.1)` in the strike loop, which
nothing in the suite tree can see. **THE INSTRUMENT THAT ANSWERS THIS QUESTION IS `baselines.json`:
the rows carrying a `flake` field are the answer, and nothing else is.** Four rows have carried one
in the project's history and **all four have been seeded** — `test_rune_battle` at DF §0, `bo` at
DT, `harness_2` at DX and `test_batch_at` at DY. **THREE SETTLED AT ZERO AND HAD THEIR FIELD
REMOVED; `test_rune_battle` KEEPS ITS FIELD AND ITS `[0,1]` BAND** because what it records is a race
under machine load rather than an unseeded draw.

### THE SEVENTH FAMILY, FOUND AT DM AND DELIBERATELY NOT SWEPT

**A TEXT THAT UNDER-STATES ITS OWN PAYLOAD.** An absent clause does not mis-say, so DM §1's test
does not reach it, and **adding a clause to a card is authoring while correcting a wrong word is
repair.** Both are reported and neither was taken.

- **BOTH *UPGRADED* CARDS DROPPED "Refunds 5 Rage" WHILE THE CODE PAID IT; NEITHER EXISTS NOW.**
  Battle Shout's and Hold the Line's upgraded `description`s both omitted it; `attacker.resource =
  mini(attacker.resource + 5, …)` is outside every branch in both handlers.
- **THE POOL-PICK BATTLE SHOUT HALF IS CLOSED AT DO, BY SUBTRACTION RATHER THAN BY AUTHORING.**
  It read: one `description` in the project for three magnitudes, a pick paying +8% for 2 turns
  while the card promised +12% for 3. `battle_shout_node` indexed `[8, 12, 18]`, and **no talent
  grants any more, so it is read-only-zero — there is ONE magnitude and the card states it.**
  The Hold the Line half of this family is closed the same way: its UPGRADED card was written by a
  collision that can no longer happen, and `check_dm` asserts it ABSENT.
- **NO SYSTEMATIC SWEEP FOR EITHER WAS RUN.** DM found both by reading six cards, not by sweeping,
  and the thread stops there on purpose.

### THE FIVE ALLY-WORDED TEXTS, RE-DERIVED AT DM AND RULED ON NOWHERE

**None is a clause-level scope disagreement**; each is a single-shape text saying *ally* where its
read site means *hero*, on an effect that already behaves correctly. **Every read site was
re-derived from the source at DM; not one was moved.**

- **The Warrior's Rally** — *"Shout one ALLY forward"*. Its picker filters `not a.is_companion` at
  **three** sites, so it cannot even be aimed at one. It also carries **two clauses of different
  shape**: a turn hand-off and a resource refill.
- **Health / Mana / Revive Potion** — `_use_item` picks from `heroes.filter(not dead)`.
- **Shared Grief's log** — *"%d ally below half"*. Walks `heroes`, skips companions.
- **The Mercy `passive_desc` and the glossary's `mercy_window`** — `unit._check_below_half` gates
  on `is_hero and not is_companion`.
- **Glacial Hold's *"+15% damage from EVERY source"*** — `_hold_window_mult()` has **exactly one
  caller**, in the hero strike loop. DL corrected the glossary's "party-wide"; the card's own claim
  is still owed.
- **AND THE GLOSSARY'S `res_faith` SAYS *ally* IN FOUR MORE PLACES** — the Devout's allies, the
  shielded allies in its `short`, an ally's release at 3, a shielded ally holding. **Faith is
  heroes-only outright by text-standard §4.9's binding rule**, so all four are wrong; **DM corrected
  only the Consecrated Ground clause, because that clause was in scope and the rest are a sweep.**

### Small, and still owed

- **~~`master.html` SAYS GUARD CHANGE IS "the only stance swap in the game"~~ — CLOSED BY EH §2's SWEEP
  (GB §4 census): both sites call it *his only unconditional stance swap* now. BP CORRECTED IT IN THE
  CODE FIRST.** `PROTECTED_CORES`'s own `why` has read *the only UNCONDITIONAL stance swap* since BP —
  Precision Strike and Feint both switch — and the document's protected-core table was never swept.
  **One string, in a table two lines from what EG rewrote, and reported rather than fixed**: the
  standing rule is that master.html is corrected TOWARD the code, so this is a correction the
  designer should see rather than one a batch makes in passing.

- **~~ONE PRE-EXISTING NAME NEAR-MISS IS REPORTED AND NOT FIXED~~ — MOOT AT FX (GB §4 census): the node
  went with the twelve trees.** The Beastmaster's draft card **Ghostpack** and his own row-8 talent
  node **Ghost Pack** differed by one space, on the same spec — a sixth member of the "five nodes
  named after live abilities" list above, which records only exact matches. Found at DS.

- **THREE ASSERTIONS PASS VACUOUSLY IN `as`, `at` AND `aw`, AND THEY ARE NAMED AT THEIR SITES.**
  Each reads text that no longer holds the list it asks about, left over from the exclusive-pair
  list DG deleted the red half of. **A check that passes for no reason is worse than a red**, so
  this is owed rather than settled.
- **`_apply_status`'s `src` COVERAGE IS PARTIAL, AND THE REST ARE OWED.** DI stamped the
  36 sites that can apply a status **Harvest reads** and DJ added the seven companion sites; the
  rest apply buffs, marks and hero-side wards, so **nothing currently mis-credits off them**.
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
- **AND ONE SITE IS OUT OF REACH BY SHAPE RATHER THAN BY SCOPE.** `melted` is applied through
  `unit.add_status`, which **accepts no source argument at all** — stamping it is a signature
  change. **It is a Harvest-readable status applied outside `_apply_status`.**
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
- **SITES WHOSE TRUE SOURCE IS AMBIGUOUS ARE DELIBERATELY UNSTAMPED**, and all of them are
  named in `docs/reports/DI.md` §2. **Getting the source wrong is worse than leaving it absent.**
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
- **`test_rune_battle` IS SEEDED AND THE BAND IS NOT TIGHTENED — AND DT'S BRIEF ASSERTED THE
  OPPOSITE, SO THIS LINE IS LOAD-BEARING.** DT §3 was briefed to seed it as an unseeded suite
  *"with `seed()` never called"*. **IT IS SEEDED**: DF §0 put `_seeded()` immediately before the
  forced White Flame hit — **the exact site that flakes** — and nowhere else, and this row and the
  `baselines.json` note both already said so. **Nothing was owed and nothing was done.** The one
  stale artefact is a comment in `test_rune_battle.gd` still reading *"`seed()` zero times"*,
  four lines above the fix that answers it; it is pre-DF prose inside DF's own header and was left
  alone. **The check count is unchanged at 97.**
  **Readings cannot retire a rate measured over fifteen on this evidence.** **The seed cannot fix a
  race**, and the failure message now carries the state the forced hit happened in.
- **`bo`'s FLAKE IS CLOSED AT DT, AND IT SETTLED AT ZERO RATHER THAN AT A RED — SO IT WAS A FLAKE
  AND NOT A FINDING.** `test_batch_bo.gd` called `seed()` zero times; **`_nf_seeded()` is now called
  immediately before EACH of §5's two compared blows with the same constant**, so both arms draw one
  identical stream and the only difference left between them is the Resonance stack count. **The
  other checks keep their own draw** — per-pair, not per-suite, which is DF's idiom and DD's
  method, and the reason the band was not touched: **the band is the question.**
  - **THE PAIR IS EXACTLY REPEATABLE NOW.** Six readings before the seed: shallow 18/16/23/18/28/17
    against deep 10/10/11/11/9/10. Six after: **17 against 10, every time.** 1106 checks / 0
    failures on all six.
  - **AND THE DOCUMENTED CAUSE WAS INCOMPLETE, WHICH IS WORTH MORE THAN THE FIX.** The recorded
    reason was the ±10% roll alone. **It spans 16.4–19.8 on a mean of 18 and cannot reach 28; a crit
    is ×1.5 and reaches exactly there.** A second and larger coin was hiding behind a variance roll
    that was taking all the blame — `at`'s shape precisely.
  - **The change is FOUR lines of code**, proven with a comment-stripped diff against `HEAD`: a
    two-line helper and its two call sites. The check count does not move.

### Carried, and still awaiting a ruling

- **~~WHETHER THE ZONE-BOSS FALLBACK NEEDS A THIRD TIER~~ — RAISED BY EG, RULED AND BUILT AT
  EH §1.** Closed. The chain is boss pool → spec draft pool → class-wide draft pool; the
  loadout-bound floor runs 8–13 where it ran 2–6. **What is NOT closed, and is stated here so
  nobody reads this line as a guarantee: under a fully-held POOL the chain still floors at zero**,
  and that is a design decision nobody has taken rather than an oversight. Full working in
  `docs/reports/EH.md` §1.
- **~~WHAT COVERS THE 915 SOURCE PINS — REPORTED AT EC §2, RULED ON NOWHERE~~ — RULED AT ED §2 (GB §4
  census): the ruling is the manifest, `pin-manifest.json`, which `check_ed` enforces every battery.**
  EC's text: Every document
  instrument watches the four tracked documents; **915 assertions across 52 suites pin a literal
  into a `.gd` file instead**, and **37 of them resolve only inside a COMMENT**, which is the
  haystack EB reworded with four instruments green. Three options with their costs are in
  `docs/reports/EC.md` §2: **extend the sweep to the edited sources** (it exists, it takes seconds,
  it fires only on files a batch edits and cannot tell a needle from prose); **a manifest of pinned
  literals** (a second place for the truth to rot); or **a rule forbidding source pins** (costs
  nothing to run, **invalidates all 915**, and is a rewrite rather than a rule). **The decision is
  the designer's, and the general shape is already in `CLAUDE.md` either way.**
- **WHETHER 3% IS THE RIGHT TARGET — CLOSED. THE TARGET IS RETIRED (EE §1) AND THE SPLIT IS TAKEN
  (EF §2), WHICH WAS THE FOURTH OF EC §3's FOUR OPTIONS.** This bullet is kept only because the
  arithmetic behind the other three is still in `docs/reports/EC.md` §3 and a later batch reading
  that page needs to know which one was taken. **The live ceiling and the per-half growth rates are
  in the knowledge-sync section, and `check_fg` §2 and `check_fr` §5 print the live sizes every
  battery; do not re-derive the ratio.**
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

- **THE ARITHMETIC PROBES IN `bg`, `bh` AND `bi` STILL SIT ABOVE THE REACHABLE BAND.**
  `STACKS := 4` is a **direct-write probe depth**, not a carry ceiling — those checks write
  `faith_stacks`/`faith_peak` onto the unit, bypass `_gain_faith`'s clamp, and measure a per-stack
  rate against **fixed percentage-point tolerances** (`< 2.0`, `< 2.5`, `> 2.5`). **Halving the
  depth halves the effect size against tolerances that do not move with it**, across roughly thirty
  currently-green live measurements. **Moving them down is a re-derivation of tolerances, which is a
  ruling, not a repair.** **DF's eight threshold repairs in `bu` and `ce` were NOT this case** — they
  involve no tolerances, only counts — which is why those could be taken and these cannot.


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
    **HOLD is 2** (`FAITH_RELEASE - 1`); **Communion's eligible band is 1–2** (the walk skips
    `faith_stacks >= FAITH_RELEASE`) and its roll `0.01 * 15 * stacks` **peaks at 30%**, measured
    at **29.8% over 1200 trials**; **two absorbs are a release.** **DC gave five suites
    `const RELEASE := 3` and `const HELD_MAX := RELEASE - 1`; DF added the same two to `bu` and
    `ce`**, so the next threshold ruling costs one line in each of seven.
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

- **`events.gd`'s RELIC-TIER COMMENT LOOKS LIKE A SITE ES §1 MISSED AND IS NOT ONE.** It reads
  *"(Batch 39 tiering exists exactly so events can promise rarity)"* in `events.gd` and it is
  about **RELIC** tiers — 17 common and 8 rare — which ES does not touch. **Named here because a
  grep for `rarity` finds it and the next reader will assume it was overlooked.**
- **THE "a held rune for two of lower rarity" EVENT NEEDS RE-SPECIFYING NOW, NOT JUST BUILDING
  (ES §1).** It was already blocked on a surrender path that has never existed (the pouch only
  grows). **With no tiers there is no "lower rarity" to trade down to**, so
  the idea needs a new statement before it can be costed. `master.html` and `events.gd` both say so.
- **THE `scarred_runes` GLOSSARY ENTRY KEEPS ITS `id` AND NO LONGER MATCHES IT (ES §3).** It is
  rewritten as *"Runes That Charge"* and teaches the mechanic rather than the retired name; the `id`
  is kept so the runes entry's `see_also` edge still resolves. **Nothing outside `glossary.json`
  names that id** — checked. Renaming the id is a one-line change in two places and is cosmetic.


- **~~THE SWAP CARD A PLAYER READS SAYS THE COOLDOWN IS 2 AND `SWAP_COOLDOWN` IS 3 (EQ §6)~~ — CLOSED (GB
  §4 census): the card and the group button's tooltip both say 3 turns now.** EQ's text: Two
  authored strings: `battle.gd:6397`, the swap picker card's own `description` (*"Shared cooldown:
  2 turns."*), and `battle.gd:5305`, the group-button tooltip (*"shared 2-turn cooldown"*). A source
  comment at `:5296` repeats it and one at `:16296` gets it right. **`docs/master.html` carried the
  same 2 and is corrected toward the code at EQ; the two in-game strings are not, because that is a
  source edit EQ's brief did not ask for.** Both replacements are the same width, so the 44-character
  ceiling is not in the way. **It lands on the mechanism the Rune of the Turning Pack is priced
  against.**
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
- **`STATUS_INFO["bloodbond"]`'s REGISTRY TEXT SAYS *HALF* WHERE THE CARD, THE DOCUMENT AND THE
  CODE ALL SAY A QUARTER (EQ §6).** The cast in `battle.gd` passes its own computed
  description (`bb_pct = 25`), so the registry string has no live consumer today. **It is a trap
  rather than a defect**: the next batch that adds a second `add_status("bloodbond", …)` without a
  custom description ships the wrong number.
- **~~`CLAUDE.md`'s UNCAPPED-METER GOVERNOR TABLE HAS STALE ADDRESSES FOR LOYALTY~~ — CLOSED AT GB §4:**
  the table names the function and the constant and cites no line numbers now.

- **`test_batch_bk`'s BASELINE ROW WAS WIDENED AT EJ, 129-130 -> 128-130, WHICH IS WHAT ITS OWN
  NOTE SAID TO DO.** EJ's battery read **128 checks / 0 failures** there. **It is not a regression
  and it is proved twice rather than argued:** EJ changed four files, all under `docs/`, and that
  suite reads seven `res://` paths all under `scripts/` and `scenes/` — **the intersection is
  EMPTY**; and **the count is stochastic by construction**, because `run._generate_map()` is
  **never seeded in that suite** and the assertions loop over the nodes the roll produced.
  **A FALL there is a thinner map, not a lost assertion** — which is why the failure count is the
  half that matters and it read 0. Two standalone re-runs on the frozen tree read 129.
  **`baselines.json` HAS EXACTLY ONE READER IN CODE** — `check_de.gd`, proved comment-stripped —
  **so `check_de` alone re-certifies it**, and it read 346 / 0 / 0 after the widening.
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
- **~~THE DEFAULT SIM BUILD HAS NEVER MEASURED A NON-FIRST LANE, FOR ANY OF THE TWELVE SPECS~~ — MOOT AT
  FX (GB §4 census): there are no lanes, and a full-depth sim wears all twenty-seven nodes of the one
  tree.**
  `Talents.LANES` is **3** and there are twelve specs, so **24 of the project's 36 lanes have never
  appeared in any measurement taken here** — Glacial Prison, Second Prison, Cold Snap, Glacial
  Economy and Absolute Zero among them. Not a defect (a fixed default party is what makes arms
  comparable across batches), but **no sim figure can be quoted about a card in a non-default lane**
  and several have been. **DB made the sim print the count beside `builds=` so the caveat arrives
  with the number.** DA ran one arm on `cryomancer:Deep Freeze`.
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
- **~~`master.html` credits "the Warden's Crushing Blow talent"~~ — CLOSED (GB §4 census):** the phrase is
  gone from the document, and the Crushing Blows node went with the twelve trees.
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
- **THE ABILITY CORPUS IS 228 — GN'S MAGIC BURST IS THE ONE CARD ADDED.** `ability_corpus()` walks
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
- **FAITH: `battle.FAITH_RELEASE` = 3**, **`FAITH_PER_ABSORB` = 2**, **`FAITH_PER_GROUND_TURN` = 1.**
  `JUBILEE_MIN_FAITH` is **3**, which is the WHOLE bar. `ELEVATION_STACKS` is **2**, which is **67%
  of a release**. **An absorbed hit pays LESS than a release costs, and `check_da` asserts that
  RELATIONSHIP.** **`_gain_faith` doubles under `zeal` and under nothing
  else** — not Fervor, not Apostle. **ALL NINE PLACES THAT SPEAK EITHER MAGNITUDE NOW AGREE**, as
  of DG §1: the two cards, the `passive_desc`, the `faith` chip, the glossary, two `master.html`
  sites and two source comments.
- **The ability draft is COMPLETE at 179 of 179** — `SPEC_DRAFT_POOLS` is **159** and
  `CLASS_DRAFT_POOLS` is **20**, counted out of `classes.gd` (**154 and 25 until GN moved five
  class-wide cards into the class kits; 129 and 20 until GS §1 put the 29 cards that stopped travelling on their
  lineages' shelves; 158 until HB put Tripwire on the Survivalist's**). **NEITHER HALF IS A FLAT MULTIPLE ANY
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
- **Save versions: the run save is v13** (a pre-**v10** save is REFUSED and cleared — the version
  and the threshold are different numbers). **v11 (CT), v12 (EG) and v13 (GF) are all TOLERANT and
  none moved the threshold; GH moved no version.** Talent cells cost 1/2/3 by tier — **27 cells = 54
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
- **DM DID NOT MOVE `test_batch_bx`'S COUNT**: §4b keeps the retired word "party"
  retired, over a WIDER file list than §4's "beast" sweep (it adds `relics.gd`, `relics_screen.gd`,
  `events.gd`, `shop_screen.gd` and `blacksmith_screen.gd`, which "beast" never reached).
- **DM RE-POINTED ONE OF `test_batch_al`'S NEEDLES WITHOUT MOVING ITS COUNT.**
  Its §3 asserted the UPGRADED Hold the Line card contains "two turns"; DM's CV §1 correction moved
  that string, **and the needle followed it** — to `"die\nfor 3 turns"`, which names its clause
  rather than matching a bare number that also appears on the Break-cut line.
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
- **master.html stamp: `Last updated: 2026-09-01 (Batch EL — the tags get their real names, and
  MARK is the seventh)`.** **EL MOVED THE STAMP AND EDITED SEVEN SITES IN THAT DOCUMENT**: §6c's
  tag table (all seven rows rewritten and a new paragraph on MARK and the ceiling), §7's
  Sharpshooter lane header and the lanes line (`Tempo` → `Pace`), the three node rows (`Tempo` →
  `Pivot`, `Shattered Tempo` → `Shockwave`, `Crusader's Tempo` → `Crusade`), and **Blink's *"Tempo,
  not damage"* → *"Timing, not damage"***, which is the ordinary English word colliding with a tag
  rather than a mechanic naming itself.
  - **§6c IS ASSERTED NOW AND IT WAS NOT BEFORE.** `check_el` §2 parses the tag table and requires
    its words, their order and their meanings to be `TAG_ORDER` and `TAG_INFO` word for word, and
    the five retired words to be absent from the section. **EH proved with a two-armed control that
    this document's factual prose is asserted by nothing** — that is one table's worth of it closed.
  - **THE LITERAL-FLIP SWEEP READ 18 LOST AND EVERY ONE WAS TRACED.** 11,010 gate-and-suite string
    literals against thirteen tracked documents: **17 of the 18 are in `docs/state.md`, which
    NOTHING READ until FS** — every `.gd` mention of that path was a comment — and the
    eighteenth is `spec_draft` leaving a `baselines.json` **`note` field**, which only `check_de`
    opens and only as parsed JSON fields, never as prose. **0 LOST in `master.html`,
    `text-standard.html`, `CLAUDE.md`, the glossary or the changelog.** `bx` reads green.
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
- **FV READ THE SAME CELL ON FIVE PARTIES (`DOD_SIM_ROWS=0`, rung 1, `--run 100` each).** Trash rounds
  **8.47** on the default party itself (Berserker / Cryomancer / Devout / Beastmaster, n = 1,206, SD
  2.62) — FU's 8.23 on the same party is 0.24 rounds away, about 2.3 combined standard errors at FV's
  spread, with nothing that plays changed between the two batches — and **10.44** with
  the Warden in the Berserker's seat, **9.11** with the Swordmaster, **7.71** with the Holy in the
  Devout's and **6.10** with the Occultist. **A fight's length is a property of the PARTY**, so a
  rounds figure travels only beside the party it was taken on.
- **Rounds to resolution, measured as TURNS PER LIVING PARTY MEMBER** (companions excluded from
  both halves), over four `--run 25` sims, **after DA** — **DB through DG ran no sim and these are
  carried unchanged**:

  | party / rung | trash | elite | boss |
  |---|---|---|---|
  | 1 wanderer | 3.8 | 3.4 | 4.0 |
  | 2 warden | 4.4 | 3.6 | 5.3 |
  | 3 ruin | 4.4 | 4.4 | 4.4 |
  | 2 warden, Sharpshooter | 5.5 | 4.9 | 6.0 |

  **A fight is still three to six turns per hero** — the ROUNDS column is the half DK and DL do not
  move, because companions are excluded from both halves of that ratio. **The healing and Break
  columns are the stale ones.**
  - **RE-MEASURED AT EN, `--run 30` A RUNG ON THE LIVE TREE, AND THE ROUNDS TABLE ABOVE IS
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

  - **DA's "NO LONGER HOLDS AT RUNG 3" CAVEAT IS RETIRED — IT DOES NOT REPRODUCE.** DA read all
    three kinds at 4.4; on the live tree the elite is **shortest at all three rungs again**, by
    0.4–0.5 rounds. **And the finding is now ACCEPTED rather than open** (EN §5): elites are burst
    checks by design and a ramp spec having least room where difficulty spikes is the intended
    tension. It is recorded in `CLAUDE.md` beside CY's cap so it is not rediscovered a third time.
    **The confounders are CY's, unchanged**: fully talented (`rows=9 of 9`), each tree's first
    lane, companions excluded from both halves.
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
  - **THE LOYALTY ROW WAS RE-MEASURED AT EQ AND AGAIN AT ER; THE 21.2 IS A `rows=9` FIGURE.**
    Live at ER, per-battle deepest single bond over every battle a Beastmaster stood in, rung 2:
    **untalented 6.64 ±0.09 (n=1391), rows 1–3 10.08 ±0.12 (n=1947), fully talented 18.98 ±0.17
    (n=2649)** — **every arm reproducing EQ within its standard error**, and a fourth arm reading
    the rows 1–3 meter at 10.2 (n=2030). EQ's rung-1 arm (11.26 ±0.10, n=2674) was not re-run.
    **The rung makes the meter SHALLOWER**, because its governor is the companion's death and rung
    2 kills companions three times as often. **Do not quote 21.2 as the meter's level — quote the
    loadout with it.** **The deepest single bond ever observed is 90** (ER, rows 1–9).
- **THE FAITH DECOMPOSITION AT RUNG 2, AFTER DA — AND STALE SINCE DK for the healing row:** absorbs **3.90**, ground drip **8.01**, total
  **12.27** a battle, of which **2.21** lands on the Devout's own held meter. **Faith per absorb
  ACTUALLY LANDED is 1.56 against the 2 the constant promises.** Ground up on **49% of hero turns**
  (8.1 of 16.5). Devout healing a battle: **74 / 133 / 130 / 184** across the four arms — **STALE: Sanctuary, Rally
  and the Field Medic now reach a fifth body, so every one of those four will rise.**
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
- **THE THRESHOLD IS WATCHED, AND AT GZ THE WATCHER WORKED END TO END FOR THE FIRST TIME.** The bar is **400 KB**
  in the rule's own words — **the decimal reading, and the stricter of the two by 9,600 B**. `check_fg` §1 warned
  on **GY**, the batch that crossed it at 400,021 B, and **GZ took the cut at the next boundary, which is exactly
  the sequence FG designed**: the previous crossing at FB/FC ran four batches with a green tree because nothing
  read the file against the number. The live file is **144,740 B = 144.74 KB = 141.35 KiB** with **255,260 B of
  headroom** — **44 batches at the 5,863 B/batch the file actually grew at over FG's whole window, 62 to 70 at the
  rate of the last 7 to 20 entries.** Use the first.
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
- **IT HAS NO CEILING AND DOES NOT NEED ONE (GZ §5, REPORTED NOT RULED).** **A ceiling is a number with an answer
  behind it.** The changelog's answer is *move it to the archive*; `CLAUDE.md`'s is *split it*; **the archive's
  only possible answer is DELETE**, which CW §4 forbids in the same block that would state the bar. Its sync cost
  is zero at any size because it is deselected by name, and its repo cost is git's. **It is a different kind of
  file from the two that do have ceilings — they are read, and it is only ever reached.** What it is owed is a
  READING in a file something asserts on, and it has one: the folder figure is in `CLAUDE.md`'s sync block and the
  file figure is above.
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
- **AND THE POPULATION THAT HAS NEVER BEEN COUNTED IS THE FILES THAT *STATE* THE BOUNDARY WITHOUT OPENING
  ANYTHING.** `README.md` named **Batch BP** — BZ's boundary, never re-pointed through CX, DV or FG, **three cuts
  and 126 batches stale** — plus a second claim one cut old; `CLAUDE.md` carried the count of cuts and the archive
  folder's byte size. **All four corrected at GZ.** **Nothing in the tree opens `README.md`**: a file no instrument
  reads is a file whose claims can never go red. Written into `docs/instrument-rules.md` under CW §4 as **sweep by
  the CLAIM, not by the reader.**

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
  measured in KiB against a **340 KiB ceiling** (EE's 290 until FU §1) whose procedure is a SPLIT, **and EF, FF and GR
  each took one.** **NO LIVE READING IS CARRIED HERE ANY MORE**: `check_fg` §2 prints the size, the bar
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
  - **THE SPLIT COST 7,984 B OF ITS OWN** — the index block, the new file's header, two section
    headings and four repairs to blocks that stayed. **The two halves together read 245.30 KiB
    against 237.50 before.** About one and three quarter batches of growth, to buy thirteen.
  - **AND THE TWO HALVES DO NOT GROW AT THE SAME RATE, WHICH IS NOW MEASURED RATHER THAN ASSUMED.**
    Over the nineteen prune-free steps DK→EE the MAIN half grew **+2,867 B/batch** (median +3,214,
    max +6,448 at DR) against the instrument half's **+1,630** (median +653, max +5,118 at DX). Over
    the five post-prune batches DZ→EE it is **+1,890 against +3,623.** **Both are real and they point
    opposite ways; the recent one is what five instrument batches in a row look like.**
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
- **`check_cm_live` reports 4 failures. THIS IS THE OLDER OF THE TWO REDS THAT ARE ON PURPOSE.** Identical on
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

### THE BATTERY CANNOT REACH THE PLAYER'S RUN SAVE — **REPAIRED AT FI. THIS ITEM IS CLOSED.**

**Full evidence: `docs/reports/FI.md`.** FH found it, ruled it not-a-crash and listed it; FI took it.
This entry records that it is closed and carries the three things a later batch must not re-derive:

- **THE NUMBER WAS 24 AND IS 67, AND BOTH READINGS ARE RIGHT.** FH ran every candidate alone against
  a fresh save and checked the FILE afterwards; FI ran all 98 targets with `Run`'s four save
  functions PRINTING and counted the CALLS. **67 destroy it; 43 restore it; 42 therefore end
  byte-identical and read as harmless.** 24 never restore, `check_ct` restores and then destroys it
  again, and that is the 25 that end absent. **An end-state census cannot see a target that puts it
  back** — the standing rule is in `docs/instrument-rules.md`.
- **THE MECHANISM IS `Run.save_path` + `Run._init()`, AND IT MUST STAY IN `_init()`.**
  Targets that `load("res://scripts/run_state.gd").new()` drive an instance that never
  enters a tree, so `_ready()` never fires for them; a control that moved the redirect back to
  `_ready()` lost a real save again. **`Run.SAVE_PATH` is still a `const` and still the player's
  file** — gates read it to mean exactly that, and `check_fi` §1 asserts it.
- **`check_fi` IS THE INSTRUMENT AND `check_fi` §5 IS THE RATCHET.** Every `.gd` in the tree is
  swept for the player's path with `CHECKED n of m` printed and **exactly one file exempt by name**
  (`scripts/run_state.gd`, where it is defined). A new target that names it reds the same day.

### FIVE MORE THINGS FH FOUND AND DID NOT FIX — **THE SIXTH WAS THE SAVE, AND FI TOOK IT**

- **`battle._break_impact()` RESTORES `Engine.time_scale` TO THE LITERAL `1.0`** rather than to
  what it was. Invisible in play, where the scale is always 1.0; it cost `check_fh` **546 seconds a
  run** (561 s for ten battles set once, 15 s for the same ten re-asserted every frame) before it
  was found.
- **THE HERO SHEET DRAWS 27 ENABLED BUTTONS THAT DO NOTHING WHEN PRESSED.** Deliberate —
  `party_screen._make_tree_node` says they are the cheapest hover surface and `disabled` must stay
  false or the tooltip stops firing — and the same silhouette as the 604 dead buttons that shipped
  once. `check_fh` §9 exempts them **by SIGNATURE, never by name**.
- **`Run.grant_rune` RETURNS A RUNE IT DOES NOT FIT.** Its callers append to `member["runes"]`
  themselves. Not a defect today; exactly the shape that goes wrong on the next caller.
- **NO BOSS AWARDS A RUNE.** The live doors are the Peddler, the elite cache, the bargain's `rune`
  reward and the event verb `rune_grant`. `check_fh` §3 asserts `_resolve_boss` reaches none of
  them, so the day one is added the claim is re-derived rather than left standing.
- **`build_pin_manifest.py` BINDS A HOLDER OFF `var x :=` AND NEVER OFF `var x: String =`**, so a
  gate written with explicit types pins nothing the manifest can see and `--check` reports
  `current`. `check_fh` contributed **0 pins typed and 5 inferred**; the manifest went 1412 → 1417
  once two declarations were rewritten. Now a rule in `docs/instrument-rules.md`.
- **AND CHECKS THAT PASS BY ACCIDENT ARE STILL WORSE THAN A RED.** `bs`'s bare `CLAUDE.md` pin was
  the one on record; **EA §2 repaired it and found five siblings**, all of them passing off a
  standing rule that named the batch in passing rather than off the block their message claimed.
  **The three vacuous exclusive-pair siblings in `as`, `at` and `aw` are the remaining live
  instances**, named at their sites and in the open queue above.
- **`test_batch_at` IS SEEDED THROUGHOUT AS OF DY §4** — §1's damage loop was the last unseeded
  compared pair in the file, and every `_seeded()` call in it used to sit DOWNSTREAM of that check.
  Its check count holds steady from run to run.
- **`test_batch_bo`'s FLAKY ASSERTION IS FIXED AT DT AND THAT FIX MOVED NO COUNT. THE NUMBER THIS
  LINE USED TO RESTATE (1106) WAS STALE BY FOUR BATCHES; the live figure is in `baselines.json` and
  is not repeated here.**
  §5's NULL FIELD check still requires `deep < shallow`; both blows are seeded per-pair now, so the
  pair reads 17 against 10 on every run. **`test_batch_bo.gd` called `seed()` zero times before DT
  and calls it twice now, both in `_nf_seeded()` at that one site.**
- **THE SUITES THAT DRIFT IN THEIR CHECK COUNT, AND THE OBSERVATION COUNT EACH BAND RESTS ON.**
  **The bands are in `baselines.json`, with the observation count beside each.**
  **THE RULE, ASYMMETRIC ON PURPOSE: floor = the lowest observation, ceiling = the highest PLUS the
  observed spread** — the floor is the half that catches a real fault, so it stays tight and the
  ceiling takes the headroom. **`check_de` RUNS on that asymmetry: it asserts the floor and reports
  a rise as a notice**, and **DR's battery 1 is the case that shape exists for** — three rows rose
  because their own loops walk the draft pool, and the differ said so as NOTICES rather than reds.
  - **`an` read 6053 then 6051 across DR's two batteries**, comfortably inside its band, and DR
    moved nothing there.
  - **`bk` is NOT widened**, because it has not been exceeded: headroom goes where a reading demands
    it. It read **129**.
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

### Last measurements

**HC's verification is in `docs/reports/HC.md` §8, written after the acceptance run.** HC moved every rune's scope,
so HEAD's unmodified gates and suites were run against the new code before any instrument moved, the offers were
driven on a whole road per arm at all four doors on this tree and on HEAD's, and the designer's save was driven in an
isolated copy seeded from the backup. **The figures live in the report and not here**, because this file is read by
`check_es` §4 and a cell written behind the run would owe a post-run proof of its own.
