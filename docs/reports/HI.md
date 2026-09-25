# BATCH HI — HALF THE RE-POINTS, AND A CHECK NOBODY EVER WROTE

**On `class-merge`, from `b05907c` (HH). IMPLEMENT ONLY.** The brief's population is **fifty, not fifty-one**: it
counts `check_gn:208` twice (§0 row 3). **Priced, it is two batches** — by the designer's own yardstick, HD's whole
batch and HH's — **so it is split by TARGET, as the brief directs** (§1): **HI re-points the twenty-seven arms in
sixteen suites** — every arm the brief names but `check_gn`'s, the ruled fiftieth among them — **and HJ takes the
twenty-three in the eight gates, `test_batch_ah` and `test_run_harness`**, where both of the LARGER re-derivations
sit. **Every one of HI's twenty-seven was shown to bite** by a defect injected into an isolated copy, read by its
FAIL text: the repaired arm goes red and HEAD's copy of the same arm, on the same defect, does not — **except two
arms whose repair NARROWS what they call a defect**, where HEAD's copy bites too by construction and the reversed
control is what shows the repair was needed (§3b). **§3's check is written** (`check_hi`): every ability name the
game defines is defined at one site, every route that hands a hero a card hands him one definition, and a spawn's
bars agree; **it finds nothing today**, and every planted duplicate reads it red (§4). `check_gs` §1's message names
a second definition as one. No card, rune, engine, kit, pool or node moved; `main` is untouched, and what stands
between it and `class-merge` is unchanged (§5).

## NEEDS A RULING — ONE, AND IT DOES NOT BLOCK HJ

1. **THE DEBUG GRANT STILL GRANTS A LINEAGE, NOT A CLASS.** The testing toggle (`battle.gd`, BO's *"All Spec Abilities
   Unlocked"*) hands a hero his lineage's boss pool and his lineage's SHELF — `Classes.spec_pool(spec) +
   Classes.spec_draft_pool(spec)` — and its comment says the class-wide shelf is left out *"for exactly AU §5's
   reason, and is empty today besides"*. Neither half holds under one pool a class: every class-wide shelf holds cards
   today (Rally and Field Dressing among them), and a hero drafts every shelf of his class, so the aid grants less
   than a hero can hold. `test_batch_au`'s named-complaint arm (`:986`–`:996`, *"the Arcanist holds no Pyromancer
   ability"*) pins the lineage scope, and **under HI's control K14r — the grant handed the class's pool — it reds in
   both copies, eleven lines, Firestorm and Rime among them**, cards `au:682` asserts are in the Mage pool. It is in
   no census, and HI moved nothing under `scripts/`. **Whether the grant should be the class pool is the designer's
   call** — a dev tool, not a player surface; if it should, the comment and that arm move with it.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `b05907c` = `origin/class-merge` before anything moved; the tree clean but for the untracked `save-backups/` |
| 2 | *"HH retired twenty-one of twenty-two and found the twenty-second had never checked anything — `test_batch_bw:417` fires zero times … the same broken loop HD fixed in `test_batch_bu`"* | **HELD** | HH §2a (an ok() trace: zero fires); `test_batch_bu`'s HD §2 note is the same walk over the four class keys |
| 3 | *"HI takes 49 by HH's count, plus two more ruled below: 51"* | **FIFTY: `check_gn:208` IS ALREADY ONE OF THE FORTY-NINE** | HG's forty-eight carried it as a FLAGGED re-point; HH §3 ruled it a re-point and HH §4's table lists it (`check_gn:216`, HEAD line 208). **49 + the class-wide floor = 50**, in twenty-six targets |
| 4 | *"HH's 49 … each already mapped to its current line with its text unchanged, and all 48 confirmed to fire"* | **HELD, AND RE-VERIFIED** | HEAD is HH's tree, so each line HH mapped is the line today: all 49 were read at it, byte-identical to HG's line, before anything was edited |
| 5 | *"`test_batch_cd`'s CLASS-WIDE SHELF FLOOR … is in no census. Ruled: it is the fiftieth"* | **HELD, AND TAKEN** | `cd` §2's per-class-wide-shelf `>= CLASS_FLOOR`; folded onto the class floors (§2) |
| 6 | *"`check_gn:208`, which HA contradicts itself about — §1d says retire, §1g says keep. Ruled at HH: §1g"* | **HELD AS HH READ IT** | HH §0 row 11: §1g does not say *keep* in words; HH §3 recorded the ruling. It is HJ's (§1) |
| 7 | *"HG found `check_fk:368`'s `ok(` line byte-identical … while HC had repaired it two batches ago"* | **AS HH §0 ROW 5 CORRECTED IT** | HC came two batches after HA and four before HG; the brief repeats HG's phrase |
| 8 | *"29 of 71 arms sat in moved code and 28 of those were a neighbour's repair"* | **HELD** | HG §1b |
| 9 | *"HD's rule … break what it guards, confirm the re-pointed arm goes red, and confirm HEAD's version does NOT"* | **HELD** | `docs/reports/HD.md` §6: each control beside HEAD's version of the same target on the same defect |
| 10 | *"HG measured this half at 48 arms in 25 targets — bigger than HD's whole batch — and ~40 two-armed controls"* | **HELD** | HG §1a and §3: 48 in 25, *"≥ 40"* controls, against HD's 56 arms and 26 controls |
| 11 | *"FZ's rule: if it is two batches, report the count and the method and stop"* | **THE BRIEF'S READING OF FZ's RULE** | FZ wrote *A BRIEF PRICES WHAT IT ASKS FOR* (`docs/ways-of-working.md`): ask the size first and defer. Applied here as the brief's own §2 directs: priced, split by target, the first half done, the second half's count and method reported (§1) |
| 12 | *"`test_batch_br` passed on a `CLAUDE.md` sentence GP had deleted from the game"* (GZ's shape) | **HELD IN SUBSTANCE** | The instance is HA's (its census row `test_batch_br:1566`, *"the seam GP deleted; the document still carries it"*), repaired at HD; GZ named the shape |
| 13 | *"across all 125 targets, nothing asserts that an ability name resolves to exactly one definition"* | **HELD, AND MEASURED** | HH wrote *may be asked by nothing*; §4b plants a second definition and reads HEAD's readers of it: nothing asks the question, and the two that go red misname it |
| 14 | *"CJ's Iron Will"* | **HELD** | `CLAUDE.md`'s text-standard block: CK renamed the Warrior ability `Ironclad` because a node, a status and a card shared *Iron Will* |
| 15 | *"FN found ten exact collisions where a brief named five"* | **THE BATCH IS FK** | `docs/reports/FK.md`: *"Five collisions were named in the brief; the sweep found TEN EXACT hits"*; `CLAUDE.md` BR §1 says the same of FK |
| 16 | *"FK found a retired rune's name is not free because `test_runes` pins uniqueness file-wide"* | **HELD** | `CLAUDE.md`, *A RETIRED RUNE'S NAME IS NOT FREE* (FK §2a) |
| 17 | *"HH found `check_gs` §1 sending the reader to the wrong problem when a card is defined twice"* | **HELD** | HH §2a, control c9a: *"31 cards returned to a pool"* |
| 18 | *"DV found `apply_kit_overrides` builds four Mage basics at spawn and the corpus returned the unoverridden card"* | **TWO CORRECTIONS** | **DU found the hole** (DU §4, *"the four mage specs"*), and **DV §5 corrected it: three Mage basics and one CLERIC basic** — Shadowrend, the Occultist's, out of Smite. And **`apply_kit_overrides` no longer exists**: GS §1 deleted it; the four are defined once in `basic_override_ability` and drafted by name. §4 covers them as the overrides population, and a spawn's bars as the place an override would be built (§1b) |
| 19 | *"merge base FS, one conflict in `docs/state.md`, `main` losing nothing of its own. Confirm it still holds"* | **HELD, AT HEAD AND ON HI's TREE** | §5 |
| 20 | *"HF's open rulings stay open"* | **HELD** | `docs/state.md`: five |
| 21 | *"The queue stands: the Crown's Break and freeze resistance, Sanctity's potency layer, the engine cards, the class-wide rebalance, and the sim bot's blind spot on the 29 returned cards"* | **HELD** | all five are in `docs/state.md`'s queue, untouched |
| 22 | *"HH moved 13 rows for a net −521 checks and every one traced to a retired line"* | **HELD** | HH §6f |
| 23 | *"The battery runs about 71 minutes. HH measured it twice at that"* | **HELD — THREE TIMES** | HH's recon 71 m 12 s, pre-pass and acceptance 71 m 00 s each |
| 24 | *"and the stamp"* | **`docs/master.html`'s `Last updated` IS BUMPED**, and `docs/state.md`'s *Last rewritten* | this batch edits `master.html`: `test_batch_cb`'s pin moved, and the sentence it pins moved with it (§2) |

---

## §1 — THE PRICE, AND THE SPLIT

**THE POPULATION IS FIFTY IN TWENTY-SIX TARGETS**: HH's forty-nine and `test_batch_cd`'s class-wide shelf floor
(`check_gn:208` is already inside the forty-nine, §0 row 3). **Every one owes a re-point and a two-armed control**,
and several owe more than a one-line door: `check_ea`'s four award floors share one re-derivation over class × engines
held, and `check_do`/`check_dp` need their guaranteed-status table re-keyed by class — HG's two LARGER items.

**THE YARDSTICK IS THE DESIGNER'S OWN.** HD was one batch at 56 arms and 26 controls; HH was one batch at 21
retirements, 15 controls and 108 runs. HG priced the re-point half at *"≥ 40"* controls. **Fifty re-points is two
batches**, so the brief's rule applies: **the first half is done, and the second half's count and method are below**.

**SPLIT BY TARGET, SO NO FILE IS LEFT HALF-REPAIRED:**

| | targets | arms | what it is |
|---|---|---|---|
| **HI** (this batch) | 16 suites: `test_batch_ah_battle`, `aj`, `an`, `at`, `au`, `av`, `aw`, `ay`, `bb`, `bo`, `bp`, `br`, `bw`, `bx`, `cb`, `cd` | **27** | the shelf-to-pool family, the definitions-versus-opening family, `bw:417` (the check that never ran), the ruled fiftieth, `cb`'s `master.html` pin (the brief's constraint 3) and `bp`'s Quick Shot (constraint 1) |
| **HJ** (owed) | 8 gates — `check_do`, `check_dp`, `check_dr`, `check_dv`, `check_ea`, `check_eh`, `check_es`, `check_gn` — and `test_batch_ah`, `test_run_harness` | **23** | both LARGER re-derivations (`check_ea` ×4 with `:400`, `check_do:475` with `check_dp:191`/`:200`), the award chain's un-awakened hero (`ah:324`/`:326`, `run_harness:432`), `check_gn`'s ruled door (constraint 2) |

**WHY THIS HALF FIRST.** Every arm the brief names but one is in it, the half's controls share a small family of
defects (a pool that stops reading a shelf, a gate row deleted, a card put where every hero opens), and the two LARGER
re-derivations get a batch of their own. **HJ's method, measured here**: the same shape as §2 and §3. Each arm is
re-read at its line with the lines that feed it, re-pointed to what it was for, and shown to bite with one defect per
isolated copy, HEAD's copy of the target beside it, read by FAIL text; a repair that narrows takes the reversed
control too (§3b). **HI's twenty-five controls took 93 Godot runs and thirty-nine minutes of wall clock** (§3c). HJ's
ten targets each ran in 4 to 32 seconds in HI's reconnaissance battery, so its controls are cheap to RUN; **its cost
is the two re-derivations** — the award floors over class × engines held (`check_ea` ×4 with `:400`,
`check_dv:251`/`:260`), and the guaranteed-status table re-keyed by class (`check_do:475`, `check_dp:191`/`:200`) —
which is why they were kept together in one batch rather than split across two.

---

## §2 — THE TWENTY-SEVEN, RE-POINTED TO WHAT THEY WERE FOR

**Each was re-read at its line, with the lines that feed it, before it was edited** (HG §1b's rule), and each is
recorded at its own site with what it asked and what it asks now. *(Lines after HI's edits.)*

| arm (HEAD → now) | what it asked | what it asks now | control | NEW / HEAD's copy |
|---|---|---|---|---|
| `test_batch_ah_battle:207` → 211 | 8 fillers off the class-wide + Berserker shelves; "new" = not in `spec_abilities` | 8 fillers **offered off `draft_pool("warrior")`** to a Berserker holding his engine; "new" = not in his **live opening** | K1 | red (*"got 6"*) / silent |
| `test_batch_aj:409` → 420 | Hack and Slash *"is in the Berserker kit"* (`spec_abilities`) | **defined** in his table, **drafted** off the Warrior pool, in **no** opening | K1, K8 | red (*"drafted: false"*) / silent |
| `test_batch_aj:552` → 570 | Battle Shout *"drafts from the Berserker"* (his shelf) | Battle Shout in **`draft_pool("warrior")`** | K1 | red / silent |
| `test_batch_aj:584` → 603 | Rampage, the same | Rampage, the same | K1 | red / silent |
| `test_batch_an:824` → 829 | the siblings hold spec-foreign entries (boss pools **and shelves**) | the siblings hold **boss cards only a sibling can reach** (not in his boss pool, not in the Warrior pool) | K11 | red (*"[]"*) / silent |
| `test_batch_an:829` → 838 | no zone-boss offer returns a sibling-spec entry (that mixed set) | no zone-boss offer returns a card **only a sibling can reach** | K12f, **K12r** | **narrowing** (§3b): forward both red; reversed HEAD alone red |
| `test_batch_at:603` → 608 | Stabilize *"OUT of the opening three"* (`spec_abilities`) | Stabilize out of his **live opening** | K4b | red / silent |
| `test_batch_at:628` → 641 | Stabilize *"spec-only"* — absent from the class-wide shelf | Stabilize's **`ENGINE_READ` row** names Resonance's engine; the door refuses it bare and offers it held | K3 | red (*"row: ''"*) / silent |
| `test_batch_au:679` → 682 (×2) | Firestorm / Rime *"drafts from the <spec> instead"* | each in **`draft_pool("mage")`** | K1 | red ×2 / silent |
| `test_batch_au:799` → 803 | Magi's Wrath *"drafts from the Arcanist"* | in **`draft_pool("mage")`** | K1 | red / silent |
| `test_batch_au:968` → 980 | the debug grant holds no sibling-spec entry (siblings' **shelves** counted as theirs) | the grant holds no **sibling boss card no hero of the class can draft**; the set asserted non-empty | K14f, **K14r** | **narrowing** (§3b): forward both red; reversed HEAD alone red |
| `test_batch_av:303` → 316 | Resurrection / Intercession not on the Cleric class-wide shelf | both are **`ENGINE_READ` rows** on Mercy: refused bare, offered held | K3 | red (*"rows: '', ''"*) / silent |
| `test_batch_aw:466` → 470 | Sacred Resolve *"drafts from the Devout"* | in **`draft_pool("cleric")`** | K1 | red / silent |
| `test_batch_aw:468` → 472 | Bulwark of Fortitude, the same | the same | K1 | red / silent |
| `test_batch_ay:403` → 415 | a retired payload edits Kill Command *"which every Beastmaster owns"* | the payload lands on Kill Command **as a Hunter gets it — off his class's one pool** | K1, K9 | red (*"found false"*) / silent |
| `test_batch_ay:410` → 422 | Hunter's Instinct, the same | the same | K1, K9 | red / silent |
| `test_batch_bb:765` → 772 | no Mage lineage's `spec_abilities` holds Ashes of Al'ar (nine checks) | no Mage lineage **opens** with it (three) | K4b | red / silent |
| `test_batch_bo:190` → 198 (×3) | the Warrior shelf is NAMED (*"one of four heroes had no draft"*) | each shelf NAMED — **an authoring location** — and **wholly inside the Warrior pool** | K1 | red ×3 / silent |
| `test_batch_bo:369` → 386 | `CAP - core_slots` ≥ 3 (the enablers' bar entries, which take no slot) | `CAP - (lineage_slots + kit_slots)` ≥ 3 — **what the opening uses inside the count** | K7 | red (*"2 of 7; 5 used"*) / silent |
| `test_batch_bp:280` → 289 | an enabler absent from its **own** shelf | absent from the **class's one pool** — Quick Shot still asked; a walk guard beside it | K6 | red on Bloodlust **and Quick Shot** / silent |
| `test_batch_br:289` → 293 (×3) | each Warrior can draw Rally (class-wide shelf) | Rally in **`draft_pool("warrior")`** | K2 | red ×3 / silent |
| `test_batch_br:294` → 298 (×3) | each Hunter can draw Field Dressing | Field Dressing in **`draft_pool("hunter")`** | K2 | red ×3 / silent |
| `test_batch_bw:417` → 475 | *"kit does not already hold"* a NINE card — **fired zero times** | **repaired**: the twelve lineages' definitions (a NINE name drafted off its own shelf), every class's basic and kit, and the walk asserted | K5, K5b | red (*"also an opening-kit ability"*; *"defined by berserker"*) / **silent — it never ran** |
| `test_batch_bx:251` → 258 | the Warden shelf ≥ 8 *"spec cards to be offered"* | the Warden's shelf ≥ 8 **and wholly inside the Warrior pool** | K1 | red / silent |
| `test_batch_cb:1239` → 1251 | `master.html`: *"All twelve specs draft from at least ten"* | `master.html`: **the pool a hero draws, per class, rendered from the live pools** — the sentence moved with it | K10 | red / silent (it pins the old sentence) |
| `test_batch_cd:453` → 463 | the thinnest SHELF (`PER_SPEC_DEPTH`) ≥ DY's ten | the thinnest POOL — a no-engine hero's offer, the half that thins — against its class floor | K1, K13 | red / silent |
| `test_batch_cd:466` (§2's class-wide floor, **the fiftieth**) → 494 | each class-wide SHELF ≥ `CLASS_FLOOR` (three) | **folded**: `Fixture.class_pool_floors`, four classes × two halves | K1, K13 | red / silent |

**THE CHECK COUNT EITHER SIDE, PER SUITE** (CQ §3's audit — a repair moves the count only where it changes what
fires):

| suite | HH | HI | move | where it comes from (the ok() trace, §7d) |
|---|---|---|---|---|
| `test_batch_au` | 285 | 181 | **−104** | `au:968` fired 121 — every sibling SHELF card counted foreign — and `:980` fires 16, the siblings' boss cards no hero of the class can draft; the new guard `:984` fires once |
| `test_batch_bb` | 173 | 167 | **−6** | `bb:765` fired 9, each Mage definition table card by card; `:772` fires 3, each Mage lineage's opening once |
| `test_batch_bp` | 429 | 430 | **+1** | `bp:289` fires 6 as `:280` did; the walk guard `:292` fires once |
| `test_batch_bw` | 455 | 512 | **+57** | `bw:417` fired **0**; `:475` fires 40 (the twelve lineages' definitions), `:482` 16 (every class's basic and kit), and the guard `:486` once |
| `test_batch_cd` | 88 | 92 | **+4** | `cd:466`, the class-wide shelf floor, fired 4; the class floors at `:494` fire 8; `:453` → `:463` one for one |
| the other eleven of the sixteen | — | — | **0** | each re-pointed line fires exactly as the line it replaced — `bo:369` → `:386` twelve times, `br`'s six, `an:829` → `:838` nine hundred — and `ay`'s two arms moved inside the helper they call, not on their `ok(` lines |
| the six comment-only suites | — | — | **0** | every line fires as on HEAD |

`test_batch_an`'s band FLOOR moved as well (6049 → 6047), for a reading and not for an edit: §7c and §7d.

---

## §3 — EVERY RE-POINT SHOWN TO BITE

**HD's rule, run over every one of the twenty-seven.** One defect per isolated copy of the landed tree (renamed in
`project.godot`, its `user://` seeded from the backup, `.git` left out because no control target reads it); **two
arms per copy**: NEW is the landed target, HEAD is HEAD's (`b05907c`) copy of the same file dropped into the same
injected copy. **Read by the FAIL text, never the count** — a script prints, per control and target, the FAIL lines
only NEW printed and only HEAD printed, and every line below is one it printed.

### §3a — THE CONTROLS, AND WHAT EACH SEPARATED

| ctl | the defect | arms it reads | only NEW red (the repaired arm, by its own FAIL text) | only HEAD red |
|---|---|---|---|---|
| **K1** | every class's pool stops reading its lineage shelves (the class-wide shelf alone) | `ah_battle`, `aj`, `au`, `aw`, `ay`, `bo`, `bx`, `cd` | **all fourteen of HI's arms there that ask the one pool** (twenty-four FAIL lines) — *"offers a Berserker 8 … (got 6)"*, *"Hack and Slash … drafted: false"*, the two Warrior, three Mage and two Cleric *"drafted off the … one pool"*, *"Kill Command … found false"* and Hunter's Instinct, the three NAMED shelves *"12 of 12 outside it"*, the Warden's *"every one is in the one Warrior pool"*, and `cd`'s thinnest pool and eight class floors | **none** |
| **K2** | every class's pool stops reading its class-wide shelf | `br` | the six *"can draw Rally / Field Dressing off the … one pool"* | none |
| **K3** | three `ENGINE_READ` rows deleted — Stabilize, Resurrection, Intercession | `at`, `av` | `at:628` *"(row: '')"*, `av:303` *"(rows: Resurrection '', Intercession '')"* | none |
| **K4b** | Stabilize and Ashes of Al'ar put in the Mage class kit, where every Mage opens | `at`, `bb` | `at:603` *"STABILIZE IS OUT of the kit he opens with … (opens: [… "Stabilize" …])"*; `bb:765` for all three Mage lineages | none |
| **K5** | = HH's c9c: Aegis Wall in the Warrior class kit | `bw` | *"Aegis Wall is also an opening-kit ability — the warrior basic or class kit already holds a NINE name"* | none — HEAD's arm never ran |
| **K5b** | = HH's c9b: Aegis Wall defined in the Berserker's table | `bw` | *"Aegis Wall is defined by berserker but not drafted off its shelf"* | none |
| **K6** | Quick Shot on the Beastmaster's shelf, Bloodlust on the Warden's — a SIBLING's shelf | `bp` | *"berserker's enabler 'Bloodlust' is still NOT draftable"* and **the Sharpshooter's Quick Shot** — the case constraint 1 keeps | none |
| **K7** | the Berserker's authored slots 1 → 3, so his lineage opens two slots INSIDE the count | `bo` | *"berserker keeps at least 3 draftable slots after what it opens with inside the count (2 of 7; 5 used)"* | none |
| **K8** | Hack and Slash off every shelf — defined, drafted by nobody (DY §3's shape) | `aj` | `aj:409` *"drafted: false"* | none |
| **K9** | Kill Command and Hunter's Instinct off every shelf | `ay` | both, *"found false"* | none |
| **K10** | `master.html`'s old floor paragraph put back | `cb` | *"master.html records the pool a hero draws …"* | none — HEAD pins the old sentence |
| **K11** | the five sibling boss cards only a sibling reached, put on the Warrior class-wide shelf | `an` | *"the Warrior siblings hold boss cards only a sibling can reach ([])"* | none |
| **K13** | = HH's c6: the Warden's shelf emptied | `cd` | *"the thinnest pool is the warrior's no-engine offer at 29 — below its floor of 38"*, and the Warrior's two class floors | none |

**Every control put the repaired arm red and left HEAD's copy of it silent, and in no control did HEAD's copy print
a line NEW did not.** The other red lines in each log — the class floors, the one-pool fact, the merge's own tells —
are printed by both arms identically, which is what the per-line comparison exists to show.

**ONE CONTROL WAS WRONG AS FIRST WRITTEN, AND IT IS RECORDED.** K4 made Stabilize the Resonance engine's enabler and
Ashes of Al'ar the Pyromancer's, to put each in a lineage's opening. **Both arms read green**, because
`Classes.lineage_opening` opens an enabler only if the lineage also DEFINES it — so the injection put nothing in any
opening and tested nothing. K4b put both cards in the Mage class kit instead, where every Mage opens and
`spec_abilities` cannot see them, and separated the arms at once.

### §3b — THE TWO REPAIRS THAT NARROW, AND THE CONTROL RUN REVERSED

`test_batch_an:829` (the zone-boss offer) and `test_batch_au:968` (the debug grant) each called a SIBLING's draft
shelf foreign to the hero. **Under one pool a class it is his own pool**, so the repair takes those cards out: what
only a sibling reaches now is a card in a sibling's BOSS pool that is in neither the hero's boss pool nor his class's
one pool. **A narrower set sees nothing the wider one missed, so HD's second arm cannot hold for these two** — HEAD's
copy goes red on every defect the new arm sees. The forward control shows the repaired arm still bites; the reversed
control shows the repair was needed.

| ctl | the defect | NEW (the repaired arm) | HEAD's copy |
|---|---|---|---|
| **K12f** | the zone-boss roller draws the Warden's and the Swordmaster's boss pools too | red on exactly the five a sibling alone reaches — War Stomp, Interpose, Retaliation, Sweeping Strikes, Shatterpoint | red on those five **and on Hold the Line and Execute**, which a Berserker can draft |
| **K12r** | the roller draws the hero's own class DRAFT pool | **silent** — every card is his own | **red on 21 of his own pool's cards** (Aegis Wall, Answering Steel, Covering Guard …) |
| **K14f** | the debug grant adds the siblings' boss pools | red on the sixteen sibling boss cards no hero of the class can draft | red on twenty-seven, the eleven more all cards of the hero's own class pool |
| **K14r** | the debug grant adds the hero's class draft pool | **silent** | **red 105 times**, every one a card of his own pool |

**The old arms' rival reading is the one GP ruled out**: that a Warrior holding a Warden card is holding a sibling's
card. (Both `an`'s own "is in the spec pool" arm and `au`'s "named complaint" arm read the same in both copies and are
not HI's.)

### §3c — WHAT IT COST, AS THE PRICE FOR HJ

**Twenty-five controls — eighteen K (K4 among them, recorded above as wrong), six P plants (§4b), and K5b run again
for `check_gs`'s message — took 93 Godot runs with 0 throws, and thirty-nine minutes of wall clock**: the first log
landed at 20:35:17 and the last at 21:13:50, in two chains running beside the reconnaissance battery. Every injection's
anchor was count-checked, and the injected text re-read from disk, before a run.

**ONE CHAIN RE-EXECUTED ITS OWN TAIL, AND IT IS RECORDED.** `ctl.sh` was patched while an instance of it was running,
and zsh reads a script as it goes: the running instance picked up the edited bytes (a second *"CTL K5 DONE"* and a
*"command not found: 00"*). K5's two arms had already written complete logs; they were re-read, both are whole, and
they are the ones in §3a.

---

## §4 — ONE NAME, ONE DEFINITION (`check_hi`), AND `check_gs` §1's MESSAGE

**THE BRIEF'S QUESTION HAD NO INSTRUMENT, AND NOW HAS ONE.** `Classes.pool_ability` walks a CHAIN of definition
tables and answers the first that holds the name; its own comment says *"no name lives in two of these"*, and nothing
asserted it. A card written into two tables leaves a SHADOWED copy that drifts on its own while every instrument that
reads the pools reads the first. **`check_hi` (NEW) asks it of every card, and finds nothing today.**

### §4a — WHAT `check_hi` ASSERTS: ELEVEN CHECKS IN FOUR SECTIONS

- **§0 THE CENSUS, READ OFF THE SOURCE (four checks).** `Gate.definition_sites()` (added to `gate_fixture.gd`,
  additive) strips comments from `classes.gd`, `talents.gd`, `runes.gd`, `run_state.gd`, `battle.gd` and `unit.gd`
  and records every `"display_name": "<literal>"` by the function that writes it (and the match arm, where the function
  matches on the name), and walks `data/runes.json` for every ability a rune builds — `new_ability`, and inside `also`
  and `upgrade`. A `display_name` built from anything but a whole literal is recorded as DYNAMIC. **Today: 231 names
  at 231 sites** — 230 in `classes.gd` across fourteen functions (`draft_ability` 143, `spec_abilities` 39,
  `vault_ability` 10, `pending_talent_ability` 7, `trimmed_kit_ability` 6, the three Hunter trophy tables 5 each,
  `basic_override_ability` 4, `class_kit_ability` 2, the four class `kit()` functions 1 each) and one in `runes.json`,
  the retired Comet rune's own ability; `talents.gd`, `runes.gd`, `run_state.gd` and `unit.gd` write none, and
  `battle.gd` writes five dynamic ones. **It asserts** no name at two sites; that the census read something (at least
  200 names, `draft_ability` at least 100); that no `classes.gd` site is dynamic — a card built under a name it does not
  write is the kit-override shape DU found and DV corrected; and that **every table `pool_ability` walks holds a census
  site, with the chain read off `pool_ability`'s own body** (nine tables today), so a table added to the resolver and
  not to the census reds at once.
- **§1 THE ROUTES (three checks).** Every route that hands a hero a card by name, each read the way the game reads it:
  the class basics (`kit()`), the class kits (`class_kit()`), the drafted pools (`draft_pool` → `pool_ability`), the
  overrides, the twelve lineage definition tables (`spec_abilities`), the lineage openings (`lineage_opening`) and the
  whole opening (`opening_kit`), the twelve boss pools (`spec_pool` → `spec_pool_ability`), the companion calls (the
  class's kinds and the rune companions'), a rune's own ability (built as the rune builds it), the grants
  (`grant_ability` → `pending_talent_ability`), the talent grants (`talent_granted_names` → `Talents.granted_ability`)
  and the corpus (`ability_corpus`). Every card each route hands out is FINGERPRINTED on seventeen fields — the name,
  cost, damage, pressure, heal, delay, cooldown, special, damage type, faith cost, area, the two hit counts, target, the
  status it applies, its perfect text and its description. **It asserts** that no name carries two fingerprints across
  the routes; that every name resolves through `pool_ability` except the class basics and a name only a rune's own
  payload builds (Comet); and that the routes read something (at least 200 names, 150 of them reached twice, one rune
  route). **Today: 231 names, 230 reached by two or more routes, 4 through a rune.**
- **§1b A REAL SPAWN (two checks).** `Gate.spawn` seats a Berserker, a Pyromancer, an Inquisitor and a Sharpshooter
  with their lineage cards, and every card on their bars must carry the fingerprint the resolver hands out (a basic's,
  `kit()`'s). **Today: 27 cards across 4 heroes.**
- **§2 THE LABEL NAMESPACE (two checks).** The enemy abilities, built per kind from `data/enemies.json`, never pass
  through a hero resolver, so a word shared there is a LABEL collision (BR §1), not a duplicate: the hero card names an
  enemy ability wears must EQUAL a named set, and the enemy walk must read something. **Today: 48 enemy ability names;
  the set is `["Strike"]`, the Warrior's basic and an enemy's swing.**

**It is not a corpus walk and returns none**: every walk sits in a function that asserts and returns nothing, which is
`check_da` §3b's line, and the enumeration itself is still `Classes.ability_corpus()`, read by §1 as one route among
the others. `check_da`, `check_ek` and `check_gw` read it clean (§7).

### §4b — SIX PLANTS: EACH SHAPE OF SECOND DEFINITION, AND WHAT HEAD's READERS SAID

One plant per isolated copy, run as §3's controls are; HEAD's readers of the planted table ran in the same copy.

| plant | the second definition | `check_hi` | HEAD's readers |
|---|---|---|---|
| **P1** | an **IDENTICAL** Aegis Wall in the Warden's definition table | §0 red — *"Aegis Wall at 2 sites (classes.gd:draft_ability/Aegis Wall, classes.gd:spec_abilities/warden)"*; **§1 GREEN**, because every route hands out the first copy | twelve run: `check_gs` §1 *"31 cards returned to a pool"* (a returning card); `test_batch_al` *"the Warden still DEFINES exactly 3 lineage abilities (has 4)"* (a count); the rest said nothing about it (`test_batch_cb`'s HEAD copy reds on every HI tree, planted or not, because it pins the `master.html` sentence HI moved — §7d) |
| **P2** | = HH's c9a: a **DRIFTED** Aegis Wall in the Warden's table | §0 red, and **§1** — *"resolve to two different definitions depending on the route: Aegis Wall: pool_ability → … \| ability_corpus → …"* | `check_gs` §1 *"31 cards returned"*; `test_batch_al` *"has 4"* |
| **P3** | the kit-only Summon Companion **also written as a drafted card** | §0 red; §1 green — `draft_ability` answers first in the chain, so every route, the kit's own included, hands out the drafted copy | `check_gs`, `check_cz`, `check_ek`: silent |
| **P4** | the retired Comet rune's own ability **renamed Fireball** | §0 (*"Fireball at 2 sites (classes.gd:basic_override_ability/Fireball, runes.json:comet/payload)"*) and §1 red | `check_et` §4 *"the rune-only ability population is ["comet -> Fireball"], not the recorded [comet -> Comet]"* — a changed population, not a duplicate; `check_cz`, `check_gs`, `test_runes` silent |
| **P5** | the override Shadowrend **also written in the vault** | §0 red; §1 green — the overrides answer before the vault | `check_gs`, `check_cz`: silent |
| **P6** | **the kit-override shape at the spawn**: `battle.gd` seats a Pyromancer a second Fireball | §0 (*"battle.gd:_spawn_units"*) and **§1b** red — *"Pyromancer's Fireball (…cost 0\|dmg 99…) against Fireball\|cost 15\|dmg 20…"* | `check_gs`, `check_cz`: silent |

**What the plants show.** A second copy that is IDENTICAL, or that sits BEHIND the first in the chain, is invisible to
every comparison of what the game hands out — P1, P3 and P5 read §1 green — and only the count at the source sees it;
that is why §0 exists. A drifted copy, a rune's own ability and a card built at the spawn are seen by the routes as
well. **None of HEAD's readers named a second definition as one**: the two that went red counted it as something else.

### §4c — THE POPULATIONS THE BRIEF NAMED, COVERED AND NOT

| population | where it is written | a second copy anywhere (§0) | a drifted copy where a hero is handed it (§1, §1b) |
|---|---|---|---|
| **abilities** — the drafted cards | `draft_ability` (143); the vaulted, trimmed and pending tables (10, 6, 7) | covered | the four pools, the grants, the corpus |
| **kit cards** | the four class basics (`kit()`); the twelve kit cards — two kit-only (`class_kit_ability`), five in lineage definition tables, five in the drafted table | covered | `kit()`, `class_kit()`, `opening_kit`, the spawn |
| **pool cards** | as the drafted cards, and the shelves name nothing the census does not hold | covered | `draft_pool` → `pool_ability` |
| **boss cards** | the drafted table, the trimmed table (the four sibling boss cards), the three Hunter trophy tables (5 each) | covered | `spec_pool` → `spec_pool_ability` |
| **enablers** | the twelve lineage definition tables (`spec_abilities`, 39 names, with the companion calls) | covered | `spec_abilities`, `lineage_opening`, `opening_kit`, `companion_call`, the spawn |
| **the overrides** | `basic_override_ability` (4: Shadowrend, Fireball, Frostbolt, Arcane Explosion) | covered | the pools they are drafted from, and the spawn — where DU found the unoverridden card |
| rune-built abilities | `data/runes.json` (1: Comet) | covered | the rune's own `new_ability` |
| **NOT COVERED — enemy abilities** | `data/enemies.json` (48 names) | a namespace of their own: §2 holds the one shared word as a named equality | — |
| **NOT COVERED — runtime copies** | `battle.gd`, five dynamic sites: the pet picker's swap entries, two copies in the enemy turn, the free copy, Blood Tribute's | printed by §0, not asserted: each takes the name of a card it copies | — |

### §4d — `check_gs` §1's MESSAGE NAMES A SECOND DEFINITION AS ONE

Both of §1's FAIL lines now read the same census (`Gate.definition_sites()`): where the name is written at more than
one site, the line appends *"— and Aegis Wall is DEFINED 2 TIMES (classes.gd:draft_ability/Aegis Wall,
classes.gd:spec_abilities/berserker): a second definition, not a card that lost its home (check_hi §0)"*, and the count
line names every doubled card the same way. **No assertion moved** — `check_gs` reads 749 / 0 standalone, as at HH.
Under K5b (= HH's c9b, a drifted Aegis Wall in the Berserker's table), HEAD's two lines read *"Aegis Wall (the
berserker's) has 0 homes among enabler, kit, shelf and the pet's calls — one"* and *"31 cards returned to a pool …"*
and stop there; the repaired lines say the same and then name the second definition and both its sites. Under P1 and
P2 the count line does the same.

---

## §5 — WHAT STANDS BETWEEN `class-merge` AND `main`

**Measured on HI's own tree, without touching a ref, the index or the working tree** (HH's method): a temporary index
takes HEAD and HI's thirty-four changed and new files, a commit object is written with no ref, and `git merge-tree`
merges it with `main`.

| | at HEAD (before HI moved anything) | on HI's tree (the probe) |
|---|---|---|
| merge base | `3b80fbe` (FS) | `3b80fbe` (FS) |
| commits on `class-merge` only | 41 | 42 (HI's probe the forty-second) |
| commits on `main` only | 2 (GG's and GI's, documents only) | 2 |
| conflicts | one: `docs/state.md` | one: `docs/state.md` |
| the merged tree against the branch's | `docs/state.md` alone | `docs/state.md` alone |
| `main`'s own changes since the base | `docs/state.md` alone | `docs/state.md` alone |

**So `main` loses nothing of its own**: the only file it changed since the base is the one file that conflicts, and
everything else it would take is `class-merge`'s. HEAD named the same commit and the index hashed the same, before and
after, and the probe matched the working files blob for blob (34 of 34). **Not merged**; `main` = `origin/main` =
`b722cc4`, read off the remote with `git ls-remote`, untouched.

---

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **HJ's twenty-three are not touched** — the eight gates, `test_batch_ah` and `test_run_harness` are byte-identical
  to HEAD, so every line in `docs/state.md`'s HJ table is the line HH mapped.
- **No rune, engine, card, kit, pool or node changed.** Nothing under `scripts/` or `data/` moved.
- **No merge to `main`**, and `main` is untouched.
- **HF's five open rulings stay open**, and the queue the brief names stands.
- **The debug grant's scope is not touched** — neither `battle.gd`'s stale comment nor `test_batch_au`'s
  named-complaint arm that rests on it. Both wait on the one ruling this batch asks for (NEEDS A RULING).
- **The `.docx` exports are not rebuilt** (ruled at FG).

---

## §7 — VERIFICATION

*Written before the acceptance run, per the brief's §6; the figures only the runs can give are filled after them.*

### §7a — THE PLAYER'S FILES, FIRST

Backed up to `../save-backups/HI-20260924-195954` before anything ran, and verified by md5 byte-identical to the live
folder: `profile.json` `ed4144e1…`, `relics.json` `fdc12ffa…`, `run_save.bin` `25582edd…`, `settings.cfg` `0c1b39c3…`
— the four sums HH recorded. **After both runs, and after everything else this batch ran, the four are byte-identical
to the backup again**: the same four sums, off the live folder.

### §7b — THE INSTRUMENTS, EACH SHOWN TO BITE FIRST

- **The parse floor.** Every log is grepped for `Parse Error` and `SCRIPT ERROR` — never a tally, never an exit code.
  **Armed with HI's own first mistake**: `check_hi`'s first draft declared `var na := Ability.make(…)`. Put back into
  an isolated copy, the run printed *"SCRIPT ERROR: Parse Error: Cannot infer the type of "na" variable because the
  value doesn't have a set type."* and no verdict line at all.
- **The ok() trace** (HH's `trace_ok.py`): in an isolated copy every `ok(` call site is rewritten to print its own
  line, line numbers kept. **Its self-check is the ledger**: in every traced suite the fires sum to the count the
  suite printed, 21 of 22 exactly on HEAD and on HI, and `test_batch_bx` one over on both — a call it takes back on
  the next line (§7d). **Its bite is `bw:417`**, which fired zero times on HEAD (HH §2a) and fires on HI's tree (§7d).
- **The code-only diff.** Comments stripped quote-aware, blank lines dropped: the six suites whose only edit is the
  helper's population word (`bq`, `bt`, `bu`, `bv`, `ce`, `cp`) are **identical to HEAD's**, and the trace reads every
  one of their lines firing as on HEAD (§7d).
- **The injections.** Each anchor count-checked, the file re-read and the injected text asserted present; P4 also
  asserts exactly one `runes.json` entry moved and the file still parses. **K4's injection was the one that tested
  nothing** (§3a) — the arms read green in both copies, which is what showed it.
- **The row move.** `baselines.json` is edited as text, so its indent-1 layout stands: **eight rows** (seven moved,
  `check_hi`'s new), numstat 35 / 21, and the file parses equal to HEAD's except those rows' `checks`, `checks_obs`
  and `note`.

### §7c — HEAD's UNMODIFIED GATES AGAINST THE NEW TREE, BEFORE ANY GATE WAS EDITED

**HEAD's gates ran against every suite as HI edited it**, with `check_hi` and `gate_fixture.definition_sites` added
and no existing gate touched, in an isolated copy (`Dawn of Decay HI recon`, proved identical to the tree but for its
name, its `user://` seeded from the backup): **20:31:03 to 21:42:28, 71 min 25 s**, with the controls, the plants and
both traces running beside it. **All 126 launched, and none of the 126 logs holds a `Parse Error` or a `SCRIPT
ERROR`** (grepped per log). Every suite read the count it read standalone; every gate read HH's, but for `check_parse`
200 (+1: `check_hi` joins GATES), `check_hi` 11 / 0, and `check_ed` 18 / 1, whose one FAIL line names exactly the two
`check_hi` pins the manifest did not hold yet (*"UNRECORDED: ["check_hi.gd: static func pool_ability(", "check_hi.gd:
\nstatic func "]"*). The two sanctioned reds sat at their recorded counts: `check_cm_live` 13 / 4, and `check_gj` 70 /
1 with *"+167 gold and the purse moved 187"*. **`check_de`, reading HEAD's rows, read 517 checks / 5 failures / 4
notices, and every line but one was predicted**: `au` and `bb` FELL, `check_ed` went REDDER and `check_hi` was
UNWATCHED; `bp`, `bw`, `cd` and `check_parse` ROSE. **The one it missed is `test_batch_an`, which FELL to 6047**, two
below the band the prediction put it inside — drift, attributed line by line in §7d. The prediction was written at
20:30:57, six seconds before the launch. **The one existing gate HI then edited, `check_gs`, read 749 in the recon and
749 / 0 after its edit.**

### §7d — THE COUNT, ATTRIBUTED LINE BY LINE

**An ok() trace of HI's twenty-two edited suites beside HEAD's copies of them, in one isolated copy** (`Dawn of
Decay HI trace all`), HEAD's lines mapped onto HI's through a diff of the two sources:

- **Apart from `an`'s drifting map line (below), the only lines whose fires moved are HI's re-pointed arms and their
  guards.** Every HEAD line that lost fires is one of the twenty-seven, and every line only HI's copy fires is its
  replacement or a guard beside it (the table in §2's count audit). **TOTAL 17,477 → 17,432 (−45)**: `au` −104, `bb`
  −6, `bp` +1, `bw` +57, `cd` +4, and `an` +3, which is drift (below).
- **The six comment-only suites move no line**: `bq`, `bt`, `bu`, `bv`, `ce` and `cp` fire line for line as on HEAD.
  So does `ay`, whose two re-points sit inside the helper its `ok(` lines call.
- **`bw:417` is the trace's bite**: zero fires on HEAD, as HH found (§0 row 2); on HI's tree the repaired arm fires 57.
- **The ledger holds, with one known exception**: in every traced run the fires sum to the count the suite printed,
  **but `test_batch_bx` reads one over, on HEAD and on HI alike**, and the one is `bx:572`, a call the suite takes
  back on the next line with `checks -= 1` (*"keep the count honest"*).
- **HEAD's `test_batch_cb` read one failure in HI's tree**, *"master.html records the FLOOR, which DS and DY moved to
  ten"*: HEAD's copy pins the `master.html` sentence HI moved (§2), which is K10's control run the other way.

**`test_batch_an` — the reconnaissance battery read 6047, two below its band, and it is drift, attributed by line.**
`an`'s own trace, HI's file and HEAD's each run twice in one isolated copy (`Dawn of Decay HI trace an`), read 6051,
6055, 6054 and 6051; the 22-suite trace read 6050 on HEAD and 6053 on HI. **In all six runs the only line whose fires
differ is §1's `is not a rest` check** — one per node of three freshly generated zone maps, 124 to 129 fires — which HI
did not touch; HI's two re-pointed lines fire 1 and 900 in every run, as the lines they replaced did. The band's floor
moved to the reading (6049 → 6047) and the ceiling stayed: a band widens where a reading demands it and nowhere else,
as DF moved it for 6046 on unmodified HEAD.

### §7e — AFTER THE DOCUMENTS LANDED: THE READERS OF WHAT MOVED

**Every reader of a document HI changed** — fourteen gates and twenty-two suites open `CLAUDE.md`, the changelog,
the design notes or `state.md` by their `res://` paths, and `check_ed` opens the manifest — **with `check_gs`,
`check_hi`, `check_parse` and the census gates (`check_ek`, `check_da`, `check_dw`, `check_gw`): forty-four targets
in an isolated copy of the landed tree, every one on its landed row, 0 throws.** `check_ed` reads 18 / 0 now that the
manifest holds `check_hi`'s two pins, and `check_fg` reads `CLAUDE.md` at 387,342 B = 378.26 KiB, 31.74 KiB under its
ceiling, and the changelog at 180,747 B against its 400 KB bar.

- **The literal sweep over the four document drafts** — every string literal of four characters or more in every root
  `.gd`, at HEAD and in the tree, searched in each draft and in HEAD's blob, raw and whitespace-flattened: `CLAUDE.md`
  GAINED one needle, the changelog three, `state.md` LOST seven, the design notes none. **No reader of any of those
  documents owns one of them**: the changelog's `Sever` is the start of *Several*, and `state.md`'s seven are the card
  names (and `mixed`) the retired population table carried, none of them `check_es`'s, the one gate that opens it.
- **The pin manifest, regenerated**: 1,519 pins, two more than HH's — `check_hi`'s two source pins on `classes.gd` —
  and `test_batch_cb`'s `master.html` pin is now a RUNTIME pin, because the sentence it checks is rendered from the
  live pools; the manifest records it as composed at runtime, so the suite is its reader. `--check` reads it current,
  and its one `unresolved` source pin is HEAD's.
- **The merge, measured on this tree** (§5): unchanged.

### §7f — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass** — the full battery in an isolated copy of the landed tree (`Dawn of Decay HI prepass`, proved file
for file before the run: 488 files, only `project.godot` differing, by its rename; and after it, when the copy had
gained no file), its `user://` seeded from the backup: **22:05:24 to 23:16:39, 71 min 15 s.** 126 of 126 launched and
none of the 126 logs holds a `Parse Error` or a `SCRIPT ERROR` (grepped per log); every target on its landed row,
`test_batch_an` at 6055; the two sanctioned reds at their counts, `check_cm_live` 13 / 4 and `check_gj` 70 / 1 with
*"+167 gold and the purse moved 187"*; the run harness's three gates PASS at 22 / 382 / 8 with no throw. **`check_de`
read 521 checks / 0 failures / 0 notices.**

**ONE PREDICTED FIGURE WAS WRONG, AND IT IS RECORDED.** The pre-pass prediction said 519: it counted the new row's
FELL and REDDER arms and took its log and throw arms as already inside the recon's 517. `check_de` runs all four of
its per-row arms only for a target that HAS a row, and `check_hi` had none in the recon, so the row adds four. The
acceptance prediction was written off the pre-pass, 521 / 0 / 0, before its launch.

**The acceptance run, in the repository, frozen**: every file on disk under the repo but `.git/`, `.godot/` and the
untracked `save-backups/`, on absolute paths — `check_hi.gd` and this report among them — hashed before and after:
**488 files, and NOT ONE MOVED.** **23:17:45 to 00:28:49, 71 min 04 s.** 126 of 126 launched and none of the 126 logs
holds a `Parse Error` or a `SCRIPT ERROR`; every target on its landed row, `test_batch_an` at 6055; the sanctioned
reds at their counts, with the same text; the harness PASS at 22 / 382 / 8. **`check_de` read 521 checks / 0 failures
/ 0 notices — the prediction exactly.** Nothing in the tree was edited from the before-hash to the after-hash; the
edits after it are this report's run figures and `docs/state.md`'s verification line.

**The two post-run edits, proved against what reads them.** No target opens `docs/reports/`. `docs/state.md` has
one reader, `check_es`: every string literal of every root `.gd` (15,578) was searched in the `state.md` both
batteries read — its hash is in the after-freeze — and in the edited one, raw and whitespace-flattened: **0 LOST, 0
GAINED**, the sweep armed first by breaking one of `check_es`'s own literals in a copy, which it reported LOST.
`check_es` then read **57 / 0** on the final tree in an isolated copy, with `check_ed` 18 / 0 and `check_ec` 24 / 0.

---

## §8 — WHAT MOVED

- **Sixteen suites, the twenty-seven arms** (§2): `test_batch_ah_battle`, `aj`, `an`, `at`, `au`, `av`, `aw`, `ay`,
  `bb`, `bo`, `bp`, `br`, `bw`, `bx`, `cb`, `cd` — each arm with a note at its site saying what it asked and what it
  asks now.
- **Six more suites by one comment word each** — `bq`, `bt`, `bu`, `bv`, `ce`, `cp`: *eleven* → *twelve*, the
  population of the class-floor helper `cd` joined (`bo`, `bp`, `br`, `bw`, `cb` and `cd` carry the same word).
  **Proved comments only**: with comments stripped, each file is identical to HEAD's.
- **`check_hi.gd` (NEW)** and its one entry in `run_battery.sh`'s GATES.
- **`gate_fixture.gd`**: `definition_sites()` and its two walkers, additive — no existing function changed.
- **`check_gs.gd`**: §1's two FAIL messages name a second definition; no assertion moved.
- **`docs/master.html`**: the draft-floor paragraph (§2, `cb`'s pin) and the `Last updated` stamp.
- **`baselines.json`, eight rows**: five suite rows and `check_parse` move to their readings, `test_batch_an`'s
  floor moves to the reconnaissance battery's reading (§7), and `check_hi`'s row is new — every one attributed by an
  ok() trace, not a subtraction.
- **`pin-manifest.json`**, regenerated.
- **`docs/reports/HI.md` (NEW)**, `docs/changelog.html`, `CLAUDE.md`, `docs/design-notes.md` and `docs/state.md`.
- **Nothing under `scripts/` or `data/`.** No card, rune, engine, kit, pool or node moved.
