# BATCH DO — TALENTS STOP GRANTING ABILITIES, AND STOP BETTING ON THE DRAW

**THE CHARTER IS SETTLED AND IMPLEMENTED.** No lane is renamed, no tree is restructured, **no node
changes row or lane**. DN's 97-node restructure is not taken.

**TWO SCOPE DECISIONS WERE PUT TO THE DESIGNER BEFORE ANY CODE MOVED, AND BOTH CAME BACK MAXIMAL.**
The brief said *"present options rather than authoring values"* for the nine capstones and *"present
replacement options for both; do not author values"* for §2's two — and also said IMPLEMENT ONLY.
Those cannot both ship: a cell whose grant is removed with no replacement is a dead three-point
cell. **The ruling was AUTHOR THEM NOW.** The second question was scope: the charter's own sentence
catches **22** granting nodes and the brief's list names **9**. **The ruling was ALL TWENTY-TWO.**

---

## §0 — THREE THINGS THE BRIEF GOT WRONG, AND ONE IT GOT EXACTLY RIGHT

### 1. "The nine grant-capstones" — THERE ARE TWENTY-TWO GRANTING NODES

`Talents.LANE_TREES` holds **22** nodes with a `grant_ability` or `new_ability` payload. **Nine are
capstones (row 9); thirteen sit in rows 2, 3 and 4.**

DN's §4 said *"Nine grant a new ability outright"* — a statement about **the 36 capstones**, and
correct as such. The brief generalised it to the whole layer, and §5's own property assertion (*"no
talent node carries a `grant_ability` or `new_ability` payload"*) could not have passed with only
nine moved.

| spec | granting nodes | rows |
|---|---|---|
| pyromancer | 5 | 4, 4, 4, **9**, **9** |
| cryomancer | 4 | 4, 4, 4, **9** |
| arcanist | 2 | 4, **9** |
| berserker | 2 | 3, **9** |
| holy | 2 | 4, 4 |
| inquisitor | 2 | 3, **9** |
| occultist | 2 | 3, **9** |
| swordmaster | 2 | 2, **9** |
| warden | 1 | **9** |
| beastmaster / sharpshooter / mystic | 0 | — |

### 2. "Does a rune grant one of the nine?" — NO, AND IT MISSES BY ONE ROW

**Checked and reported before anything moved, as instructed.** The brief names all four
ability-granting runes correctly (`comet` carries a `new_ability`; the other three a
`grant_ability`).

| rune | grants | one of the nine? |
|---|---|---|
| Rune of the Comet | **Comet** | no — its own definition, in no tree |
| Rune of the Last Rites | **Resurrection** | no — Holy kit since AV; the rune's own text says so |
| **Rune of Binding Souls** | **Sacred Resolve** | **no — but `dv_resolve` (inquisitor/Zeal/3) granted it** |
| **Rune of the Flayed Mind** | **Mind Flay** | **no — but `oc_mind_flay` (occultist/Madness/3) granted it** |

**TWO LIVE DUPLICATIONS, BOTH IN THE THIRTEEN THE BRIEF'S LIST DOES NOT REACH.** The Flayed Mind's
own `lane` field reads **"Madness"** — the lane its twin sits in. Both are resolved by the move:
**the rune keeps its grant, the talent does not.**

### 3. "Eight of the nine were already earnable" — and the ninth was not earnable at all

`SPEC_POOLS` already held Rampage, Hold the Line, Execute, Firestorm, Shatter, Magi's Wrath,
Bulwark of Fortitude and Mass Hysteria. **Phoenix Rebirth was in `CLASS_POOLS["mage"]` only** — and
the class draw was retired at Batch AN, so **`py_rebirth` was its only source in the game.** The
move is what makes it earnable.

### 4. What the brief got exactly right

`dv_bulwark` is a capstone, CV ruled its 5% party heal **UNCONDITIONAL**, and a re-author would
have reached straight for it. **The ruling is preserved by not being touched:** it lives in the
ABILITY'S text, in `Classes.pending_talent_ability`, which this batch does not open. The card moved
into the draft **by name only**; the cell became something else entirely.

---

## §1 — THE MOVE: WHAT ACTUALLY HAD TO HAPPEN

**"Move the ability into the draft pool" is not one line.** `Classes.pool_ability()` ends with
`return Talents.granted_ability(display_name)` — a fall-through into `LANE_TREES` — and its own
comment says *"no name lives in two of these"*, so a pool entry can never drift from the copy the
talent hands out.

**SIXTEEN DEFINITIONS LIVED INSIDE THE NODE PAYLOAD AND SIX DID NOT.** The six `grant_ability`
nodes named a card defined in `Classes.pending_talent_ability` already — outside the tree — so they
needed no move at all. The sixteen `new_ability` nodes carried their whole `Ability` dict in the
payload, and **eight of those were reachable ONLY through that fall-through.** Deleting a payload
would have silently emptied a `SPEC_POOLS` entry the zone boss offers.

They were lifted out **verbatim** into `Classes.draft_ability()` — not one number, `special`,
`perfect_id` or line of `description` re-typed. **The ability corpus is still 216.**

### Pool depth after the move

| spec | before | after | | spec | before | after |
|---|---|---|---|---|---|---|
| pyromancer | 8 | **13** | | inquisitor | 8 | **10** |
| cryomancer | 8 | **12** | | occultist | 8 | **10** |
| berserker | 8 | **10** | | warden | 8 | **9** |
| swordmaster | 8 | **10** | | beastmaster | 8 | 8 |
| arcanist | 8 | **10** | | sharpshooter | 8 | 8 |
| holy | 8 | **10** | | mystic | 8 | 8 |

**`SPEC_DRAFT_POOLS` 96 → 118. `CLASS_DRAFT_POOLS` unchanged at 24. THE DRAFT IS 142 OF 142.**
The floor is still eight and **no pool lost anything**; the three specs still at eight are the
three whose trees granted nothing to move.

---

## §2 — THE TWENTY-FIVE RE-AUTHORED CELLS

**Every replacement modifies the spec's PROTECTED CORE, its PASSIVE or its RESOURCE, and not one
needed a new `battle.gd` read site.** `apply_payload`'s `{"ability": …, "add"/"set": …}` branch has
existed since Batch AI and nine nodes already used it, so a re-author that points at a core ability
is a data change with no mechanics behind it. **That is the reason the shape was chosen** — 25 new
battle mechanics would have been 25 new places to be wrong.

| id | spec / lane / row | was | is now |
|---|---|---|---|
| `bz_battle_shout` | berserker / Fury / 3 | granted Battle Shout | **Battle Roar** — Bloodlust costs 10 less Rage, +8% of Attack |
| `bz_rampage` | berserker / Warpath / **9** | granted Rampage | **Bloodstorm** — Wildstrikes +10% of Attack, cooldown → 1 |
| `sm_lunge` | swordmaster / Blade / 2 | granted Lunge | **Committed Thrust** — Overpower costs 10 less, builds 10 Rage |
| `sm_execute` | swordmaster / Blade / **9** | granted Execute | **Finisher** — Pommel Strike +30% of Attack, cooldown → 1 |
| `wd_hold_line` | warden / Banner / **9** | granted Hold the Line | **Braced** — Shieldwall costs no Rage, cooldown → 1 |
| `py_melt` | pyromancer / Kindling / 4 | granted Backdraft | **Melt** — Wildfire's cooldown → 1 |
| `py_flame_shield` | pyromancer / Inferno / 4 | granted Immolate | **Emberwall** — Flamewave costs 10 less, +15 Break |
| `py_focused` | pyromancer / Detonation / 4 | granted Pyroblast | **Concussion** — Detonation +15% of Attack |
| `py_firestorm` | pyromancer / Kindling / **9** | granted Firestorm | **Sky Ablaze** — Flamewave +10% of Attack, cooldown → 1 |
| `py_rebirth` | pyromancer / Inferno / **9** | granted Phoenix Rebirth | **Rekindled** — Detonation costs no Mana |
| `cr_rime` | cryomancer / Winter / 4 | granted Rime | **Snowblind** — Blizzard costs 10 less, cooldown → 2 |
| `cr_numbing` | cryomancer / Deep Freeze / 4 | granted Glacial Prison | **Numbing Cold** — Ice Lance costs 10 less, cooldown → 1 |
| `cr_lance_focus` | cryomancer / Thaw / 4 | granted Cryoclasm | **Focused Lance** — Ice Lance +15% of Attack, +15 Break |
| `cr_shatter` | cryomancer / Thaw / **9** | granted Shatter | **Shardfall** — Razor Ice +3 strikes, cooldown → 1 |
| `ar_overcharge` | arcanist / Resonance / 4 | granted Overcharge | **Overdraw** — Arcane Cannon costs 10 less, cooldown → 1 |
| `ar_wrath` | arcanist / Overload / **9** | granted Magi's Wrath **+ the step-doubling** | **Unchained** — the step-doubling, unchanged, as the whole node |
| `hl_divine_plea` | holy / Radiance / 4 | granted Divine Plea | **Benediction** — Hymn of Hope costs no Mercy |
| `hl_inner_faith` | holy / Vigil / 4 | granted Intercession | **Inner Faith** — Renewal's cooldown → 1 |
| `dv_resolve` | inquisitor / Zeal / 3 | granted Sacred Resolve | **Unshaken** — Blessing of Zeal costs 10 less |
| `dv_bulwark` | inquisitor / Bulwark / **9** | granted Bulwark of Fortitude | **Wardstone** — Divine Shield costs no Mana |
| `oc_mind_flay` | occultist / Madness / 3 | granted Mind Flay | **Bedlam** — Bewitch costs 10 less |
| `oc_hysteria` | occultist / Madness / **9** | granted Mass Hysteria | **Pandemonium** — Hex of Ruin curses EVERY enemy, Break 15 → 40 |
| `bm_devoted_fury` | beastmaster / devotion / 4 | read **Bestial Wrath** | **Devoted Fury** — Kill Command costs 10 less, cooldown → 2 |
| `bm_reserves` | beastmaster / handler / 3 | read **Spirit Bond** | **Deep Reserves** — Hunter's Instinct costs 10 less |
| `cr_icy_resolve` | cryomancer / Winter / 5 | read **Rime** | **Icy Resolve** — Blizzard +10% of Attack |

**`ar_wrath` IS THE ONE THAT LOST ALMOST NOTHING.** Its step-doubling was an `also` payload beside
the grant and is the whole node now. `wrath_step_double` keeps its name, its unit and its single
read site in `unit.resonance_dmg_step()` — **nothing there moved, so AU §4's negative control still
bites.** `no_fallback` went with the grant it opted out of.

**FIELD COLLISIONS WERE CHECKED BEFORE ANYTHING WAS AUTHORED.** Nine talent payloads already point
at an ability by name; the fields they claim are Hack and Slash (`multi_hits`, `cost`), Detonation
(`cooldown`), Arcane Barrage (`random_hits`), Heal (`cost`, `cooldown`), Renewal (`cost`),
Hymn of Hope (`cooldown`), Resurrection (`cooldown`, `faith_cost`), Divine Shield (`cooldown`) and
Snare Trap (`cooldown`). **Not one replacement writes a field another node already writes** — the
order two nodes apply in is tree order, and an `add` landing after a `set` is a silent
order-dependence nobody would find.

### The naming trap, avoided rather than hit

A node named **"Overcharge"** beside a **draft card** called Overcharge is the `wd_spiked`/Spite
collision DN documented, in a new place. The Arcanist's cell is **Overdraw**. **Five nodes were
already named after live abilities before DO** — Second Wind, Spite, Rally, Killing Frost, Divine
Presence — **and DO adds no sixth.** Verified by walking all 324 node names against the live 216.

---

## §3 — THE EIGHT CLAUSE-CUTS, AND THE ONE WHERE THE BRIEF'S RULE DOES NOT APPLY

**The brief's rule — "cutting a clause changes what the node DOES, so remove the payload term with
the text" — is right four times out of five and wrong once, and the exception is worth stating.**

| node | clause cut | payload term removed | read site |
|---|---|---|---|
| `sm_blade_dance` | *"If he also owns Shatterpoint…"* | **`sunder_guard_bd`** | `battle.gd` block deleted |
| `wd_stomp_drill` | *"If he owns War Stomp…"* | **`rallying_stomp_ranks`** | `stomp_pct` term + log deleted |
| `wd_bannerman` | *"If he owns Interpose…"* | **`bulwark_line_ranks`** | two sites + log deleted |
| `bm_ancient_pact` | *"Spirit Bond and Hunter's Instinct included"* | **NONE — see below** | unchanged |
| `dv_waters` | *"or Sacred Resolve"* | none (one term, both banners) | `has_status("unity")` half cut |
| `dv_pulse` | *"or Sacred Resolve"* | none | same condition, one site |
| `sm_seasoned_node` | *"and Lunge too, if he has it"* | none | `in ["Lunge","Overpower"]` → `== "Overpower"` |
| `ar_conduit` | **RE-POINTED, not cut** | none | none — its partner is still in the tree |

**`bm_ancient_pact` IS THE EXCEPTION AND IT IS NOT A LOOPHOLE.** Its payload is a single
`ancient_pact` flag carrying **both** halves (the boon doubling and the no-heal), and `battle.gd`
refuses **all** healing rather than naming a source. Spirit Bond appeared in an **illustrative
list** — and Hunter's Instinct beside it is PROTECTED CORE. So the text is corrected and **there is
no payload term to remove.** Removing `ancient_pact` would have deleted the node.

**FOUR OF THE EIGHT ARE THIS BATCH'S OWN CASCADE.** `dv_waters`, `dv_pulse` and `sm_seasoned_node`
named an ability that was in their own tree until DO moved it; `ar_conduit` names `ar_wrath`, which
is still in its tree and is simply renamed. **A dependency's category is a property of where the
thing it names lives, not of the node** — moving a card converts every reader of it from
tree-internal (permitted) to drawn (forbidden), without a character of their text changing.

---

## §4 — `sm_precision`, WHICH GOT WORSE BEFORE IT GOT FIXED

> *"+20% critical strike chance against Dazed, Crippled, and Exposed targets."*

**The brief asks which of the three the Swordmaster can reach through guaranteed means. The answer
is NONE, and it is none partly because of this batch.**

- **Dazed** — only Charge (`CLASS_DRAFT_POOLS["warrior"]`) or Sweeping Strikes
  (`SPEC_POOLS["swordmaster"]`). Both drawn, and both already were.
- **Crippled and Exposed** — only `sm_lunge`, a tree node. **That was a build CHOICE, which the
  charter permits.** `sm_lunge` moved into the draft in this batch, so **the last non-drawn source
  went with it.**

**So the brief's guess that "cutting Dazed may be the whole repair" was correct when written and
false by the time the repair was made.** Re-pointed onto **Stunned**, which **Pommel Strike**
applies and Pommel Strike is PROTECTED CORE. The `battle.gd` read site moved with the text, and
`check_do` §4 pins both halves.

---

## §5 — THE STATUS SWEEP: TWELVE PAIRS, AND SIX ARE DO'S OWN

**`check_do` §4 prints this on every battery run. Reported; ruled on nowhere, as §3 instructs.**

| spec | node | status | this batch's? |
|---|---|---|---|
| swordmaster | `sm_guarded` | Crippled, Exposed | no — pre-existing |
| mystic | `sv_virulence` | Exposed | no — pre-existing |
| sharpshooter | `ss_exposed_nerve` | Exposed | no — pre-existing |
| sharpshooter | `ss_no_cover` | Dazed, Blind | no — pre-existing |
| occultist | `oc_spread` | **Psychosis** | **YES** |
| occultist | `oc_whispers` | **Psychosis** | **YES** |
| occultist | `oc_delirium` | **Psychosis, Hysteria** | **YES** |
| occultist | `oc_permanent` | **Psychosis, Hysteria** | **YES** |

**PSYCHOSIS AND HYSTERIA HAVE NO APPLIER IN THE GAME BUT MIND FLAY AND MASS HYSTERIA.** Both moved
into the draft, so four Madness-lane nodes went from **tree-internal (permitted)** to **drawn
(forbidden)** with no edit of their own. `oc_delirium` and `oc_permanent` also name **Bewitched**,
which IS core, so both still work — they are the §3 "cut the bonus clause" shape. `oc_spread` and
`oc_whispers` are whole-node bets and would need re-authoring.

**NOT TAKEN, DELIBERATELY.** §3 says *"Report the list; rule on nothing"*, and re-pointing a lane's
whole subject off Psychosis and onto Bewitchment is a design decision with a designer attached to
it. **A cost you created and named is a decision waiting to be made; a cost you created and quietly
repaired is a decision you made on someone else's behalf.** It is in the open queue as DO's.

---

## §6 — WHAT THE MOVE COSTS, RECORDED RATHER THAN HIDDEN

**NINE ABILITIES LOST THEIR UPGRADED VARIANT.** An `upgrade` arm fires only where a node's grant
COLLIDES with an earned copy (`Talents._collided`, Batch AU §1). No node grants, so no collision
happens, so **`battle_shout_node`, `lunge_upgraded`, `execute_upgraded`, `hold_line_upgraded`,
`rampage_upgraded`, `overcharge_extra`, `intercession_long`, `resolve_extra_turns` and
`bulwark_extra_turns` are read-only-zero.**

**THE FIELDS AND THEIR READ SITES ARE LEFT STANDING**, and that is a decision rather than an
oversight: every one of them reads a BASE beside it (`[8, 12, 18][clampi(node, 0, 2)]` and its
siblings), deleting a branch is deleting a mechanic, and two are already in `runes.gd`'s
`STAT_INT_KEYS` against the day a rune writes them.

**ONE CARD TEXT MOVED, AND IT CLOSES A DEFECT `docs/state.md` HAS CARRIED SINCE DM.** Battle
Shout's `description` promised *"+12% … Lasts 3 turns"* — index **1** of `[8, 12, 18]`, the
magnitudes the NODE paid. A pool pick has always paid **+8% for 2 turns**. There is one magnitude
now, and **the card states it.** The "one description for three magnitudes" thread is closed by
subtraction rather than by authoring.

**AND THE COLLISION MACHINERY IS NOT DELETED.** `apply_payload`'s two grant branches and
`_collided` are how **runes** grant, and four do. The tidy-looking edit is the wrong one.

---

## §7 — A HOLE OPEN SINCE BATCH CL, CLOSED AS A SIDE EFFECT

`check_cz` §0 has asserted for eight batches that the **Batch CL enumeration reaches 211 of 216**,
and that the five it misses — **Backdraft, Pyroblast, Glacial Prison, Cryoclasm, Intercession** —
are talent grants living in no pool.

**ALL FIVE ARE IN A DRAFT POOL NOW.** `_cl_only_corpus()` reads the draft pools, so **the two walks
agree**. The assertion's own failure message read *"%s IS in the CL walk — §0's premise has changed
and the report is stale"*; it had never fired. **It is INVERTED rather than deleted**, so a batch
that puts one of the five back outside every pool is still caught, and the agreement itself is now
asserted as one line.

---

## §8 — WHAT IS DELIBERATELY NOT DONE, AND THE MIGRATION THAT IS NOT NEEDED

- **NO NODE MOVED ROW OR LANE, SO NO SAVE MIGRATION IS NEEDED AND `Profile` IS STILL v2.** DN
  measured that a MOVE mis-prices a cell — `Talents.cells_spent` prices each owned cell off the row
  it CURRENTLY sits in — and drives a full Berserker ledger to **−2 available points**, with
  nothing to refuse, clamp or log it. **Every one of the 25 re-authored cells keeps its id, its
  lane and its row, and `check_do` §3 asserts all 25.** *Saying so explicitly, as §4 asks.*
- **The 97-node restructure is not taken, and no tree changes size.**
- **The 17 tree-internal dependencies stay.** A cross-row conditional bets on a node the player
  CHOOSES, not on a card they are DEALT.
- **The six status bets §5 reports are not ruled on**, per §3.
- **The five pre-existing "node named like an ability" collisions are not renamed** — that is a
  save-format question for `bm_beast_within`-class ids and a separate pass.

---

## §9 — THE BATTERY

**TWO BATTERIES. THE FIRST WAS THE DIAGNOSTIC AND IT FOUND 245 FAILURES ACROSS 30 TARGETS; THE
SECOND IS THE ACCEPTANCE RUN AND IT IS CLEAN.** Both ran on a frozen tree. **140 files were
MD5-stamped before battery 2 began and re-compared after: the only two that moved are
`baselines.json` and `docs/state.md`**, and no suite reads either — `baselines.json` is read by
`check_de` alone (`test_batch_cd` mentions it in a comment and does not open it), which is exactly
what makes the differ re-runnable over a frozen log directory.

| | DN's acceptance | DO battery 1 (diagnostic) | DO battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | **245 across 30 targets** | **0** |
| **throws, grepped from the stream** | 0 | **3** (`ak`, `al`, `as`) | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | many | **0** |
| `check_de` | 293 / 0 / 0 | 293 / 45 / 6 | **297 / 0 / 0** |
| targets in the manifest | 71 | 72 | **72** |

**SEVENTY-TWO TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-TWO. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log**, grepped from the logs rather than read off a tally or off `$?`.
`test_batch_an` read **6049**, inside its band. The three standing flakes — `test_batch_at`'s
unseeded §1 ratio, `bo`'s §5 NULL FIELD flake and `test_rune_battle`'s pierce — were **all quiet
again, and that is not a repair**: it is the tenth consecutive quiet reading on rows that red about
one in eighteen. **A red from any of them is not this batch's.**

### The three throws battery 1 found, and they were all one fault

`test_batch_ak`, `test_batch_al` and `test_batch_as` threw on `display_name`/`special` of a `Nil`
and on `Array[0]`. **All three were the same shape: a suite that applies a granting node's payload
and then reads the ability out of `cfg["abilities"]`.** With nothing granted the array is empty.
They are the loudest possible signal that the charter landed, and they are the reason a suite that
needs a moved card now EARNS it — through `suite_fixture`'s existing `bm` option, which is what a
player does.

### The one row that moved after the run, and why the code did not

**`check_de` read 297 / 1 in the battery itself: `test_batch_bm FELL to 1888 checks, recorded
1891`.** Zero failures — a fall, not a red. **`test_batch_bm.gd` is byte-unedited by DO**, so the
question is what stopped running, and the answer is that nothing did.

Its §1 row-8 duplicate-detector walks every rows-1-to-7 node in a row-8 node's **own lane** and
emits one check per **TOP-LEVEL `payload.stat` field** it finds — the instrument behind *"a row-8
node must not re-write a field an earlier node in its lane already writes"*. **Three mid-tree cells
stopped writing a top-level stat because DO re-authored them onto a PROTECTED CORE ability
instead**: `cr_icy_resolve` (cryomancer / Winter / 5), `bm_devoted_fury` (beastmaster / devotion /
4) and `bm_reserves` (beastmaster / handler / 3). All three sit below row 8 in a lane that has one.

**MEASURED RATHER THAN REASONED:** the loop transcribed against the live tree reads **238**, and
**241** with the three fields restored — a delta of exactly **3**. The `also`-borne terms DO also
cut (`sunder_guard_bd`, `rallying_stomp_ranks`, `bulwark_line_ranks`) do **not** appear here,
because this loop reads the top-level `stat` only and all three of those nodes keep theirs.
**The row was moved with that reason written into it, and the differ re-run over the same frozen
logs reads 297 / 0 / 0** — the 0.63-second post-pass the differ exists to be.

### The sanctioned movements, predicted before the run

Every prediction landed except `test_batch_bm`, which was not predicted at all — **that is the
miss, and it is recorded as one.**

| target | before | after | movement |
|---|---|---|---|
| `check_do` | — | **131 / 0** | **NEW: DO's gate.** In `GATES`, with a baseline row |
| `check_de` | 293 | **297** | +4, four assertions per target, and DO adds one gate. Predicted |
| `check_cz` | 131 | **133** | §0's eight-batch-old premise INVERTED — the two walks agree now |
| `check_dm` | 92 | **93** | three needles followed their text into `classes.gd`; the upgraded card asserted ABSENT |
| `check_dk` | 64 | **64** | **unmoved, and predicted** — one needle re-pointed, no assertion added |
| `check_da` | 37 | **37** | **unmoved.** `check_do` reads only the SPEC draft pool, so §3's two-call fingerprint does not match |
| `test_batch_au` | 336 | **231** | **a FALL of 105**, and the row moved with its reason: three loops asserted per-node over a population that is now empty |
| `test_batch_av` | 324 | **350** | +26 |
| `test_batch_bo` | 1025 | **1064** | +39 |
| `test_batch_ce` | 1116 | **1138** | +22 |
| `test_batch_cd` | 72 | **85** | +13 |
| `test_batch_cb` | 1185 | **1196** | +11 |
| `test_batch_ar` | 735 | **740** | +5 |
| `test_batch_ax` | 345 | **348** | +3 |
| `test_batch_ah_battle` / `ai` / `aj` / `aw` / `ay` | — | — | +2 each |
| `test_batch_ah` / `ak` | — | — | +1 each |
| **`test_batch_bm`** | 1891 | **1888** | **−3, NOT PREDICTED. The acceptance run caught it.** |
| every other row | — | unchanged | unchanged |

### Eight negative controls, and all eight bit

| control | result |
|---|---|
| restore Sunder Guard's Shatterpoint rider | `check_do` **4 failures** (the term, plus §1's ability-outside-core check), `test_batch_ak` **3** |
| restore Rallying Cry's War Stomp term | `check_do` **1 failure** |
| restore Bulwark Line's Interpose term | `check_do` **1 failure** |
| **put a GRANT back on `ar_wrath`** | `check_do` **2 failures** — the property AND `talent_granted_names()` |
| **MOVE `dv_resolve` from row 3 to row 7** | `check_do` **1 failure** — *"cells_spent prices off the ROW"* |
| restore `sm_precision`'s Dazed / Crippled / Exposed | `check_do` **4 failures** |
| **pull Backdraft out of its draft pool** | `check_do` **1**, and `check_cz` **4** — its §0 premise comes back |
| a deliberate syntax error in `relics.gd` | the `check_parse` **stderr** grep reports **26 `Parse Error`**, and **0** once reverted |

**Every probed file was restored from a scratchpad copy and re-compared byte-for-byte** — never
`git checkout`, which wiped a batch's uncommitted work at CT.

**AND THE THIRD CONTROL FOUND A FAULT IN THE GATE RATHER THAN IN THE CODE.** Arming the first
control made `check_do` §3 report **all three** cut terms as surviving, not one. The other two were
matching my own **comments** — the prose that RECORDS a cut necessarily NAMES what was cut. It is
`check_da`'s self-accusation trap in a second place, and the gate strips comment lines before the
sweep now, with the reason written at the site. **The gate had a hole and only a negative control
could have shown it.**

### The literal sweep

**9,948 literals at a floor of 4**, extracted from all 74 suites and gates (comment-only lines
skipped, both quote styles), evaluated against **both** the `git show HEAD` version and the working
version of thirteen documents and sources **in one pass**.

- **52 LOST pairs, and every one is accounted for.** Almost all are definitions that moved from
  `scripts/talents.gd` into `scripts/classes.gd` — `'Embolden every ally: 50% less Break'`,
  `'Every enemy takes an even share.'`, `'Frostbite'`, `'LESS damage'` and the payload keys around
  them all appear in the GAINED list against `classes.gd`. The rest are the three cut terms (LOST
  by design, and `check_do` §3 asserts their absence), the nine read-only-zero flags whose payloads
  are gone, and `'UPGRADES'` and `'A roar every hero answers: +12%'`, both of which are pins this
  batch deliberately **inverted**.
- **181 GAINED pairs — and the dangerous kind is zero.** A gained pin is only a fault if some
  existing assertion pins that text ABSENT, which is how a check goes green carrying a false
  message. **All 254 negative `contains` assertions in the tree were cross-checked against all 181
  gained pairs: no collisions.**

### The card widths did not move

The width census counts `description` and `perfect_text` lines over `classes.gd` and `talents.gd`
together, and DO moved sixteen `description` blocks from one file to the other **verbatim** — so
the population is identical and the count is unchanged by construction.
