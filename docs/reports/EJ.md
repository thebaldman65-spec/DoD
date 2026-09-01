# BATCH EJ — THE RUNES AGAINST A CHARTER THEY WERE NOT WRITTEN FOR

**A REPORT. No rune was re-keyed, re-authored, retuned or retired; no `lane` field was removed; no
magnitude moved; no document was corrected and none needed to be.** The deliverable is
`docs/rune-audit.html` plus this report, and the question is how much of the rune layer the
designer's new charter removes.

**The answer: 59 of 135 clauses, across 32 of the 65 runes. It is a RE-KEY of 59 clauses rather
than a rewrite of the layer — 56 of the 59 already modify a passive, a stat, a core ability or a
draft card at their read site and need only a field of their own, and Batch AL shipped exactly that
repair three times. Three clauses need an effect invented. And 16 runes are WHOLLY talent-keyed, so
those are emptied rather than trimmed.**

**The larger cost is not the code.** 48 of the 65 runes are built on an authoring rule that both
design documents state as current, and the charter deletes the rule rather than the machinery.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*Derive, do not recall — and EI §2's rule says a brief's precedent is a claim that gets checked.*

| the brief said | re-derived here | note |
|---|---|---|
| **65 authored runes** | **true** | 5 universal + 12 class-wide + 48 spec |
| **`master.html` and `design-notes.md` both state "one rune per talent lane, plus one splash" as current** | **true** | with the "worth more to a hero whose points went elsewhere" reasoning, in both |
| **`battle.gd`'s comment says most spec runes ride an existing talent counter** | **true**, `battle.gd:1259` | *"Batch AA roll call: most spec runes ride an EXISTING talent counter"* — and it is right: 59 of 109 spec-rune clauses do |
| **`check_dp` §4 asserts every rune stat field has a live read site — 116 fields, 0 dead** | **true**, run live: `116 rune stat fields across 65 runes; 0 read nowhere` | and the brief is right that it is a different question — see §2 |
| **DP proved one rune's fields would have been orphaned; nobody checked the other 64** | **half true** | `check_dp` §4 *did* check all 65 for DEAD fields. What nobody checked is whether a live field still buys what it was authored to buy |
| **25 cells re-authored** | **true** | `docs/reports/DO.md` §2's table is exactly 25 rows, and all 25 reproduce against the trees |
| **22 granting nodes moved into the draft** | **true, and exact** | 22 nodes granted an ability before DO and 0 do after; the other 3 of the 25 were re-authored for other reasons |
| **DN through DP rebuilt the layer** | **FALSE for DN** | **DN changed ZERO nodes.** Its own changelog entry says so: *"A REPORT. NOTHING WAS RE-AUTHORED, NO TREE WAS RESTRUCTURED, NO NODE MOVED."* DO changed 34 nodes and DP 4 |
| **`master.html` carries two contradictory descriptions of the rune system, both live** | **FALSE** | it carries only the flat one, in all four places. See §3 — this is the fourth brief to get the ladder wrong |

**TWO OF THE NINE DID NOT HOLD, AND THE SECOND ONE IS THE SAME ERROR EI WROTE THE RULE ABOUT.**
That is worth stating plainly rather than burying: EI §2 recorded *a brief's precedent is a claim
and gets checked* eleven days after EH blamed `master.html` for a claim it never carried, and the
very next brief asserted the claim again in a stronger form — quoting the document as holding both
halves of a contradiction. **The rule caught it on its first application.**

---

## §1 — WHAT EACH RUNE ACTUALLY MODIFIES

**Derived from the read site in `scripts/`, never from the rune's description and never from its
`lane` field.** Full tables in `docs/rune-audit.html`.

**65 runes carry 135 clauses**: 116 `stat` fields across 84 distinct names, 15 `ability`
`add`/`set` terms, and 4 grants.

| category | clauses | runes | charter |
|---|---|---|---|
| **STAT or RESOURCE** | **46** | 31 | permitted |
| **A CORE ABILITY's values** (`ability` add/set) | **15** | 9 | permitted |
| **A CORE ABILITY's mechanics** (stat field read at a core's site) | **5** | 4 | permitted |
| **A PASSIVE's mechanics** | **5** | 3 | permitted |
| **A DRAFT ABILITY's** | **0** as a non-talent clause | — | permitted |
| **A TALENT — its counters** | **59** | **32** | **removed** |
| a GRANT (the charter names it neither way) | 4 | 4 | unruled |
| DEAD — written, read nowhere | 1 | 1 | see §5 |

**THE TWO FIGURES DIFFER BECAUSE A RUNE SITS IN SEVERAL CATEGORIES AT ONCE.** 59 clauses live in
32 runes; the counts are 27 apart because the splash runes carry three or four clauses each. **16
runes are WHOLLY talent-keyed** — every clause they own writes a counter — **16 are partly, and 33
are not talent-keyed at all.** A rune-level count alone would say "half the runes"; a clause-level
count says "44% of the work". Both are true and neither is the whole answer, which is why the audit
page gives both in every row.

**ALL 15 `ability` CLAUSES NAME A PROTECTED CORE OR A CLASS KIT ABILITY** — Strike, Smite, Quick
Shot, Ice Lance, Arcane Barrage, Hack and Slash, Snare Trap, Resurrection — resolved live against
`PROTECTED_CORES` and the kits rather than read off the names. **That whole family is already
exactly what the charter asks for.**

### THE UNEVENNESS IS THE FINDING, AND IT IS DO's SHAPE AGAIN

**The 5 universal and the 12 class-wide runes carry ZERO talent clauses between them.** Every one
of the 59 lives in the 48 spec runes.

| class | clauses | TALENT | share | | spec | clauses | TALENT |
|---|---|---|---|---|---|---|---|
| Warrior | 27 | 5 | 19% | | **warden** | 7 | **0** |
| Mage | 33 | 11 | 33% | | pyromancer | 10 | 2 |
| Cleric | 33 | 21 | 64% | | berserker | 7 | 2 |
| Hunter | 34 | 22 | 65% | | **inquisitor** | 10 | **8** |
| | | | | | **occultist** | 10 | **8** |
| | | | | | **beastmaster** | 9 | **8** |

**The Warden's four runes would not be touched at all. The Beastmaster's are 8-of-9 and would be
re-authored almost entire.** The Cleric and Hunter halves of the roster carry twice the Warrior's
share. Nobody had measured this and nothing would have surfaced it.

### THE TEST, STATED, BECAUSE IT IS WHERE THIS AUDIT COULD BE WRONG

**A talent node writing the same field does not by itself make a rune talent-keyed.** `crit_bonus`,
`speed`, `armor`, `max_hp_pct`, `block_chance`, `parry_bonus`, `dmg_bonus`, `dmg_taken_bonus`,
`pierce_bonus` and `bleed_bonus` are the unit's own math — read in the global damage, crit, parry
and turn-order pipelines, several of them written by relics too — and a node adding to one is a
coincidence of target, not a coupling. **Nine such fields are classed STAT despite having a node.**
The clauses classed TALENT are the ones whose field is the node's mechanism: zero without the node
or the rune, and read at a site that implements the node's own advertised effect.

---

## §2 — DID THE TALENT REBUILD BREAK ANY OF THEM?

**`check_dp` §4's 116-fields-0-dead is a real property and it is not this question.** A live read
site proves the field is read. It does not prove the rune still buys what it was authored to buy.

**So all 84 fields were compared at their READ SITE and at their ENCLOSING GUARD CHAIN against the
tree as it stood at `DN~1`. Five moved.**

| field | rune | what moved | batch | verdict |
|---|---|---|---|---|
| `hungering_ranks` | Long Winter | a SECOND read site added — companions read it too | DU | a **widening** |
| `max_hp` | Broad Path | an unrelated new site (the Salve heal) | DS | incidental; a universal stat |
| `spread_ranks`, `spread_ruin` | **Whispering Dark** | read site moved 7,225 lines (`:6783` &rarr; `:14008` at DP) and from `_max_hero_rank` to `occ.` — Psychosis spreading between minions became **a mark of Ruin leaping to another enemy** | **DP** | **known and handled** |
| `pulse_ranks` | **Standing Vow** | read LINE byte-identical; the `if` above it lost its `unity` half | **DO** | **recorded nowhere** |

**THE WHISPERING DARK IS THE CASE DP FOUND AND CLOSED.** It kept both fields deliberately and
rewrote the rune's description with the node — **the single line `data/runes.json` changed in the
entire DN→DP window.** The rune sells what it now buys.

### THE RUNE OF THE STANDING VOW IS ON NO RECORD

DO cut Sacred Resolve's banner out of Healing Pulse's trigger for a stated and good reason: Sacred
Resolve became a draft card at DO, so a node reading its banner would be a bet. **DO reported the
node cut in its own §3 table** — the row `dv_pulse | "or Sacred Resolve" | none | same condition,
one site`. **What appears in no report, no changelog entry, no gate and no line of `state.md` is
that a 100g rune rides that counter.** A grep for *"Standing Vow"* and for `pulse_ranks` across
every batch report, the changelog and `state.md` returns **zero hits**.

**IT IS A QUIET WEAKENING RATHER THAN A MIS-SALE, AND THE DISTINCTION MATTERS.** The rune's
description reads *"holy ground mends 2% each turn"* and is byte-identical before and after DO — it
never sold the Sacred Resolve half. **The code moved TOWARD the card.** The rune was
over-delivering against its own text and now delivers exactly what it says. Nobody was mis-sold;
the rune got worse than it was, and no instrument in the project could see it.

### `oc_spread` IS THE SHARPEST LESSON IN THE BATCH

**Its node dictionary changed by DESCRIPTION ONLY at DP.** Id, lane, row, `scale` and both payload
fields are byte-identical across the whole rebuild — while `battle.gd`'s read site moved **7,225
lines** — `:6783` to `:14008`, measured at DP itself rather than against HEAD — and changed which
unit it reads from. **A diff of the talent trees, which is the obvious
instrument and the one this audit reached for first, would have filed `oc_spread` as a
documentation edit.** What found it was diffing the read site. What found the Standing Vow beside
it was diffing the enclosing guard chain, **because that read line never changed at all** — a
read-line diff returns four fields and misses it.

### AND AN EXTRACTOR HOLE, FOUND AND CLOSED RATHER THAN SHIPPED

The first sweep masked string literals to find identifier reads and reported **eight of the 84
fields as read by nothing.** Seven are read through a string key — `_max_hero_rank("frigid_ranks")`,
`cfg.get("max_hp_pct")` — which masking had deleted. **The eighth is real** and is `pyromaniac_ranks`
(§5). A sweep that had stopped at the first number would have reported eight dead rune clauses,
seven of them fiction.

---

## §2b — THREE RUNE-ONLY EFFECTS ANNOUNCE THEMSELVES TO THE PLAYER AS TALENTS

**25 of the 84 fields are written by no live talent node.** Most are deliberate and labelled: six
carry a `rune_` prefix and `unit.gd` marks a block *"RUNE-ONLY"* with AR §4's reasoning. **But
three still call themselves talents in the combat log, and no node of any of those names exists in
any of the twelve trees** — checked against `LANE_TREES`, not assumed.

| field | only writer | what the player is shown |
|---|---|---|
| `beacon_ranks` | Rune of the Sleepless Vigil | *"→ Talent: Beacon — the light finds …"* (the node became Hour of Need at AV) |
| `capacitor_ranks` | Rune of the Triage Ward | *"→ Talent: Holy Capacitor banks …"*, **plus a status chip on the hero's bar reading Holy Capacitor** |
| `mindfulness_ranks` | Rune of the Unquiet Mind | *"→ Talent: Mindfulness"*, a float of the same name, and a source comment still reading *"(Arcanist talent)"* |

**The convention already exists and these three predate it** — Exsanguination, Critical Mass, the
Reaper and the Cinder Trail all say *"→ Rune:"*. **Three more are a softer version**: Grudge,
Shared Vigil and On the Edge each have a live node AND a separate `rune_` term, so a hero holding
only the rune is told a talent fired. **All six reported, none fixed** — a log line is
player-facing text and this batch changes none. They are listed because the charter makes them
worse: a rune *disconnected from talents* should not announce itself as one.

---

## §3 — WHAT THE DOCUMENT SAYS, AND THE LADDER THAT HAS NOW BEEN WRONG FOUR TIMES

**THE SLOT COUNT IS THREE, FLAT, FROM RUN START, AND IT DOES NOT GROW.** Established from the code:
`Run.rune_slots()` returns a literal `3`. Its only other arm is `RICH_SLOTS = 4`, reached only when
`sim_run` is true **and** `DOD_SIM_RUNE_ECON=rich` is in the environment — a sim lever whose own
comment reads *"every slot open from tier 1"*. **A flat 4, not a ladder, and unreachable in a
played run.**

**`master.html` HAS NEVER CARRIED THE GROWTH LADDER.** Swept on UNWRAPPED text, which is the method
EI had to invent for this exact document. The file says **"Three equip slots, flat, from run start
— no growth ladder"** at line 2444, and **four further mentions agree with it — five sites in
all, of which a line-anchored grep sees only THREE**: one is broken by inline `<b>` tags (line 32)
and one wraps mid-phrase (`three rune` / `slots`, lines 351–52). **Zero hits** for
*"Equip slots"*, for *"2 → 3 → 4"*, and for *"starts the run choosing a rune"*. **No correction is
owed and none was made** — which is also why §5's standing rule does not fire.

**THE LINEAGE IS FOUR DEEP NOW.** CT was told the ladder existed and caught it; EG's brief asserted
it eleven batches later; EH's brief blamed `master.html`; **EJ's brief quoted two contradictory
descriptions as both live in a document that carries only one.** `battle.gd:23066-67` has read *"Batch AN §9
deleted the rune ladder outright and rune_slots() has been flat 3 ever since"* the whole time —
and **that comment WRAPS, so a line-anchored grep for it returns nothing.** The refutation has been
as hard to find as the claim.

**AND THE CONFUSION HAS A SOURCE, WHICH IS WORTH NAMING BECAUSE IT WILL OTHERWISE CAUSE A FIFTH.**
There IS a live growth ladder here: **the ITEM pouch** (`ITEM_SLOTS_BY_ZONE`), which grows by zone
and announces itself on the zone-boss card. `docs/design-notes.md` sets the two side by side under
*"Why the ladder is the pouch's shape and not the runes'"* — AN deleted the rune ladder because a
run that dies in zone 2 never owns the last slot; CT kept the pouch ladder because a pouch slot is
filled the moment you reach a merchant. **Two ladders, one deleted and one kept, one paragraph
apart.**

**WHAT THE DOCUMENTS DO SAY ABOUT THE SYSTEM IS THE OLD RULE, STATED AS CURRENT, AND ACCURATE.**
`master.html`: *"Each set is built to one rule: one rune per talent lane, plus one splash"*;
*"talent-counter runes STACK with the talent"*; *"The per-lane rule is what makes a rune a build
decision rather than a power increment."* **All three describe the code correctly.** The charter
contradicts them, which is a decision rather than a defect.

---

## §4 — HOW BIG IT IS

### MECHANICALLY IT IS A RE-KEY, AND IT HAS A SHIPPED PRECEDENT

| the node's effect rides on | clauses | what a re-key costs |
|---|---|---|
| a spec **PASSIVE** (Ruin, Burn, Chill, Resonance, Pack Bond, Poison, Break, Blood Frenzy, Seasoned Fighter) | **31** | a `rune_` field beside the node's, summed at the existing site |
| a **STAT or RESOURCE** (Focus conversion, Mercy, Faith release, Break cut, resource on a kill) | **15** | the same; several could re-point at an existing general stat instead |
| a **PROTECTED CORE** (Divine Shield, Consecrated Ground, Guard Change, Quick Shot) | **8** | cheapest — `apply_payload`'s `{"ability": …, "add"/"set": …}` branch already does this, the shape DO chose for 25 cells |
| a **DRAFT** card (the Survivalist's traps) | **2** | permitted as written; a field of its own |
| **the NODE and nothing else** | **3** | **an effect must be INVENTED** — `divine_presence_pct`, `entropy_ranks`, `pleasure_pct` are per-turn drips with nothing underneath them |

**BATCH AL DID THIS THREE TIMES ALREADY, FOR THE SAME REASON.** `rune_grudge_bonus`,
`rune_vigil_bonus` and `rune_on_edge_ranks` are rune terms split out of a node's counter and read
beside it, and the source comments carry the method and the reason: *"it used to add a rank to this
counter, and re-pricing the node from 6% to 25% would have quadrupled the rune's number without
anyone touching the rune."*

**AND AL RECORDED THE ONE NON-OBVIOUS RULE, WHICH ANY RE-KEY WILL NEED:** *"a threshold cannot be
summed the way a magnitude can (35 + 25 = 60% is not both effects, it is a third effect neither one
asked for). THE THRESHOLD TAKES THE MAX; THE PAYOUT SUMS."* **A re-key that sums a threshold will
ship a magnitude nobody authored.**

**THE COUPLING IS ADDITIVE AND NEVER CONDITIONAL, WHICH IS WHAT MAKES THIS TRACTABLE.** Derived
rather than assumed: **no rune payload in the file carries a `condition` or a `has_node` gate**, and
**every one of the 59 talent clauses rides a node in the equipping hero's OWN spec tree — zero
cross-spec.** No rune is dead without a talent and none reaches into another spec's tree.

### THE COST THAT IS NOT THE CODE

**36 of the 48 spec runes are lane runes and 12 are splashes.** The lane runes hold 36 of the 59
talent clauses; the splashes hold 23. **The authoring rule is what they were built on**, and both
documents state it as current: one rune per lane, writing that lane's own counters, *"worth taking
precisely because it is off-build, and worth less to the player already deep in that lane."*

**Re-key them and that asymmetry is gone.** A rune with its own field is worth the same to every
hero of that spec — the definition of the power increment the rule exists to prevent. **The splash
runes lose more than the lane runes**: a splash *"carries a term from every lane and pays for
reaching outside one"*, and with no lanes to reach across it is three unrelated numbers in a
bundle. **And 16 runes are wholly talent-keyed**, so the charter does not trim them, it empties
them: Boiling Blood, the Bared Guard, the Bitter Grip, the Deep Bond, the Deep Sight, the Deepening
Ruin, the Long Hunt, the Long Winter, the Open Hand, the Resonant Core, the Shared Wild, the
Standing Vow, the Turning Pack, the Warded Robes, the Weeping Wound, the Whispering Dark.

### THE HONEST ANSWER

**It is not a small batch and a document correction, and it is not a rewrite of the rune layer
either. It is a re-key of 59 clauses in 32 runes — of which 3 need new mechanics and 16 runes need
new concepts — and a deliberate abandonment of the authoring rule that 48 of the 65 were designed
around.**

The engineering is small and well-precedented. **The design question is not.** Nothing in the code
decides whether a rune set with no relationship to the talent trees is better than one built
against them. What the code can say is that the current sets are built on that relationship
deliberately, that both design documents say so, that the machinery to sever them already exists
and has been used three times, and that **the Warden's set would not move while the Beastmaster's
would move almost entirely.**

---

## §5 — WHAT IS DELIBERATELY NOT DONE

- **No rune re-keyed, re-authored, retuned or retired; no `lane` field removed.** The charter is
  ruled and not implemented.
- **No document corrected.** §3 looked for `master.html` contradicting the code and found the
  opposite. The standing rule requires a correction where there is a contradiction; there is none.
- **The White Flame's middle clause stays inert.** `pyromaniac_ranks` is the one rune field in the
  game written by a rune and read by nothing — Inferno Master's per-turn step stopped existing at
  AR. `unit.gd:515` already flags it *"INERT: the White Flame writes it, nothing reads it"*, and
  inventing a read site is the guess AR §4 forbids. **It is the 135th clause and it pays nothing
  today**, on a 120g scarred Epic whose other two clauses are live.
- **The six "→ Talent:" log lines are not changed.** Player-facing text.
- **No gate.** A gate encodes a ruling and nothing here is ruled. The property a future gate would
  want — that no rune writes a live node's counter — is about twenty lines from `LANE_TREES` and
  `runes.json`, and belongs in the batch that takes the charter. **Writing it now would encode
  today's 59 as an expectation.**
- **No `CLAUDE.md` rule.** Nothing is settled until the audit is read.
- **No sim, no balance judgement, no rune-against-rune or rune-against-relic comparison.** Stated in
  the audit's own coverage table so the page is not read as clean.

---

## §6 — VERIFICATION

### THE INSTRUMENTS, AND THE CONTROL THAT LICENSES THEM

**The talent trees were read two independent ways and the readings agree on all 324 nodes.** Dumped
live from `Talents.LANE_TREES` through a running engine, and re-parsed from the source text with a
Python reader. **That agreement is what licenses using the source parse on historical commits**,
where no engine can be run against a tree that no longer exists — the DN~1 and DO comparisons all
rest on it.

**Comment-stripping and string-masking were written for this batch and both preserve line count and
byte length exactly** (verified on all five game scripts). The 665 `#` characters that survive
stripping in `battle.gd` were checked and are all hex colour literals inside strings.

### THE FIRST BATTERY RUN WAS DISCARDED, AND WHY

**A run was launched, stopped five targets in, and thrown away.** A line-number pass over this
report's own claims — run while that battery was in flight — found **three wrong figures in it**,
and the tree must not move behind a battery (DL's rule). Stopping a run five targets in is cheap;
correcting an asserted document behind one is the fault that cost DL two runs.

**All three were the same species, and it is the species this project keeps paying for:**

1. **"the read site moved 7,700 lines"** was measured from `DN~1` to **HEAD**, which folds DQ–EI's
   growth into DP's move. **DP's own move is 7,225** (`:6783` to `:14008`). A figure derived
   against the wrong endpoint.
2. **"`battle.gd:23067`"** — the grep that was supposed to confirm that citation **returned
   nothing**, because the comment WRAPS across `:23066`–`:23067`. **The refutation of the slot
   ladder is itself invisible to a line-anchored grep**, which is EI's `master.html` lesson
   arriving in a source file.
3. **"three further mentions"** of the flat slot count in `master.html` — there are **four**, five
   sites in all, **and a line-anchored grep sees only three of them**: one is broken by inline
   `<b>` tags and one wraps mid-phrase (`three rune` / `slots`). The unwrapped sweep found all
   five; the line-anchored confirmation pass found three and I wrote down the number I had checked
   least carefully.

**The third is the one worth keeping.** §3 of this report argues that a line-based sweep cannot see
this document, and the count in that same paragraph was produced by a line-based sweep.

### WHAT WAS RUN

| target | result |
|---|---|
| `check_dp` standalone | **43 checks / 0 failures**, §4 printing `116 rune stat fields across 65 runes; 0 read nowhere` |
| talent-tree dump probe | `EJ_DUMP_OK specs=12`, 324 nodes |
| source parse vs live dump | **identical on 324 / 324** |

### PREDICTIONS

Nothing in the tree reads `docs/state.md`, `docs/reports/` or `docs/rune-audit.html` — verified by
a comment-stripped grep across every `.gd` and `.py`, not recalled. The only source edits this batch
makes are **none**: no `.gd`, no `.json`, no `.tscn`, no `project.godot`. The only document a suite
asserts against that moved is `docs/changelog.html`, and it gained an entry and lost nothing.

| target | reads | predicted | read |
|---|---|---|---|
| `check_dv` §4 | the changelog's `<h2>` count | **pass** — the assertion is a FLOOR (`>= 16`, repaired at DW after DV pinned an equality) and the file goes 29 → 30 | **pass** |
| every target reading a document | `contains` on a fixed literal | **unchanged** — 0 LOST needles anywhere | **unchanged** |
| `check_ed` / the pin manifest | recorded pins | **unchanged** — no `.gd` edited | **18 / 0**, manifest current at 1335 |
| `check_parse` | the derived population | **unchanged at 158** | **158 / 0** |
| everything else | — | **unchanged**: no ability, magnitude, pool, node or constant moved | **unchanged** |

### THE BATTERY

**ONE CLEAN RUN, PRECEDED BY TWO DISCARDED ONES.**

| | result |
|---|---|
| targets run / named in the manifest | **84 / 84**, and **0 duplicate names** |
| suite failures | **0** |
| suite throws | **0** |
| `Parse Error` / `SCRIPT ERROR`, grepped from all 84 streams | **0** |
| `check_cm_live` (the recorded deliberate red) | 4 |
| `check_parse` | **158 / 0** |
| `check_de` | **346 / 0 / 0 notices** |
| MD5 drift across 195 tracked files | **1 — `baselines.json`** (below) |

**THE FLOOR WAS RUN THE WAY THE BRIEF SPECIFIES**: `grep -E 'Parse Error|SCRIPT ERROR'` across the
84 log files, off the streams — never a tally and never an exit code. **0 matching logs.**

### THE SECOND DISCARDED RUN, WHICH IS A FAULT THIS PROJECT HAS ALREADY WRITTEN DOWN

A run reported 84 targets and looked clean. **Its `.ran` manifest held 138 lines for 84 unique
names** — two batteries had written one log directory, which `run_battery.sh`'s own header
describes as *"a silent data fault"* and which its lock exists to prevent. The lock was gone
because the FIRST battery's `EXIT` trap removed it on its way out, after a `pkill` that did not
take immediately. **Every count that run printed was trustworthy** (stdout is per-process) **and
every LOG was not**, so the floor grep — which reads the logs — was reading a mixture. Discarded,
processes verified dead by `ps` rather than by `pgrep`, directory removed, re-run. **The clean run
was checked for the same fault before it was believed: 84 names, 84 logs, 0 duplicates.**

### THE ONE RED, AND WHY IT IS NOT THIS BATCH

**`check_de` read `test_batch_bk FELL to 128 checks, recorded 129-130`.** It is not a regression and
that is proved two ways rather than argued.

1. **THE INPUT SURFACE IS PROVABLY UNCHANGED.** This batch changed four files, all under `docs/`.
   `test_batch_bk` reads seven `res://` paths and every one is under `scripts/` or `scenes/`.
   **The intersection is empty**, so the suite ran against a tree byte-identical to HEAD's.
2. **THE COUNT IS STOCHASTIC BY CONSTRUCTION.** `run._generate_map()` is **never seeded anywhere in
   the tree** — no `seed(`, no `randomize()`, no `RandomNumberGenerator` in `run_state.gd` — and
   the suite's assertions loop over the nodes the roll produced. **A fall here is a thinner map,
   not a lost assertion**, which is why the failure count is the half that matters: it read **0**.

**Two standalone re-runs on the frozen tree read 129**, so the observed spread is 128/129/130.

**THE ROW WAS WIDENED TO 128–130, WHICH IS WHAT ITS OWN NOTE SAID TO DO** — *"headroom goes where a
reading demands it."* A reading demanded it. **`baselines.json` has exactly ONE reader in code**,
proved comment-stripped rather than by grep: `check_de.gd`. The four other files that name it
(`check_dp`, `check_parse`, `test_batch_cd`, `run_battery.sh`) mention it only in comments. **So
re-running `check_de` alone against the frozen logs is a complete re-verification, and it reads
`346 checks / 0 failures / 0 notices`** — the same figure EI certified on.

**THE EDIT IS THE ONLY MD5 DRIFT FROM THE CERTIFIED TREE**, made after the run and named here for
that reason. The diff is **4 lines changed**, `indent=1` preserved.

### THE POST-RUN CHANGELOG EDIT, AND WHY IT IS NOT A FREE ONE

The `baselines.json` widening is a thing that happened, so it was written into the changelog — and
**the changelog is asserted against by 17 targets**, derived comment-stripped rather than grepped.
The edit is additive text inside this batch's own entry, and it was proved harmless in the order
this project requires rather than argued:

- **THE NEEDLE PROOF FIRST.** All 11,584 four-character-plus literals in the 39 gates, 47 suites
  and both fixtures, counted against the document before and after: **0 LOST, 27 GAINED.** A
  `contains` cannot flip on a gain.
- **THE NEGATIVE ASSERTIONS WERE READ, NOT ASSUMED.** A `not contains` CAN flip on a gain, so
  every negative assertion against the changelog was found: there is one — `check_dv` §4's pair
  pinning the DF/DG cut boundary — and it names `<h2>` headings this edit does not touch.
- **AND ALL 17 WERE RE-RUN ANYWAY**, into a separate log directory so the certified run stayed
  intact. **Every one reads 0 failures and every check count is identical to the certified
  battery's** — `bb` 177, `bn` 81, `bo` 1140, `bp` 276, `bq` 883, `br` 1592, `bs` 267, `bt` 375,
  `bu` 444, `bv` 864, `bw` 515, `bx` 161, `cb` 1172, `ce` 1114, `dv` 83, `ec` 23, `de` 346.

**AND THE EXTRACTOR THAT READ THOSE RESULTS WAS WRONG TWICE BEFORE IT WAS RIGHT**, which is worth
recording because it is `run_battery.sh`'s own scar: **the suites print their verdict in THREE
different shapes** — `N checks / M failures`, `checks: N   failures: M`, and
`BATCH XX: N checks, M FAILED`. A regex written for the first reads **blank** for eleven of the
seventeen, and a blank is indistinguishable from a suite that did not run. The battery script
carries a comment about exactly this (*a `grep -E "checks,"` that missed every suite printing
"N checks / M failures" without a comma*). **A hand-rolled extractor is an instrument and gets the
same scepticism as any other.**
