# BATCH DV — THREE THINGS DU FOUND, AND THE CHANGELOG CUT

*2026-08-29. Four items. **One thing changed in the game** — a door that let the player waste a
turn the bot had refused since BB — and the other three resolved to measurement, because the brief
withheld the ruling each of them needed. No card was authored and the draft is untouched at 149.*

---

## THE BRIEF'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because two of them changed the work.

1. **§3's title says `ashes` JOINS `RECAST_GATED`. MEMBERSHIP THERE IS INERT AND WOULD HAVE SHIPPED
   AS A CHANGE TO NOTHING.** That system reasons about STATUS writes: `_recast_refused` asks
   `_recast_targets` for a pool and `_recast_writes` for the chips a cast would lay, and `ashes`
   writes an integer FIELD. Driven live on a fully-armed Mage, `_recast_targets` returns **an empty
   array**, the loop never runs, and `_recast_refused` returns **false**. Adding the string to the
   list changes no behaviour whatever. The refusal is a bespoke condition in `_ability_usable` —
   which is what the brief's own operative sentence asks for (*"through `_ability_usable`, the same
   door every other refusal uses"*) and is not a second path: `_recast_refused` is itself one
   condition inside that function.
2. **§5 says Shadowrend's `perfect_text` is 45 characters. RENDERED IT IS 49.** The two numbers
   measure different things and the report needs the second one. Authored 23; resolved with no
   context 36; wearing the `"Perfect: "` label every surface supplies **45**; rendered against a
   real Cleric — which is what `check_cl_width` counts and what a player sees — **49**.
3. **§1's premise held and its conditional fired.** `CLASS_POOLS` is a **lost feature**, not
   scaffolding, so per the brief nothing was deleted.
4. **§2's fallback could not be implemented, and the brief says so itself.** *"What that fallback is
   is a design decision — present options; author nothing."* The fallback's DESTINATION is the whole
   of the change; there is nothing to build until it is chosen. §2 is measured and priced.
5. **Everything else in the brief held**, including DU's `CLASS_POOLS` count of 61, its `SPEC_POOLS`
   42/40, its per-spec depth table, and the 400 KiB threshold (406.0 KiB measured).

**AND ONE OF DU'S OWN CLAIMS DID NOT SURVIVE, IN THREE PLACES.** DU records the kit overrides as
*"the four MAGE specs"*. **There are only three Mage specs.** See §5.

---

## §1 — `CLASS_POOLS` IS A LOST FEATURE, AND NOTHING WAS DELETED

**The brief made the deletion conditional on establishing WHY the structure is dead, and that
condition is the whole value of the section.** It presents as textbook dead code: 61 authored,
resolving entries no run can reach, with `run_state.gd`'s own comment saying nothing reads them.

### IT WAS WIRED, AND IT WAS LIVE — THREE INDEPENDENT SOURCES

| source | what it says |
|---|---|
| `classes.gd:148-151` | the Batch AH award offered *"1 from its SPEC_POOLS entry and 2 from its class's CLASS_POOLS entry (`Run.roll_ability_offer`)"* |
| `run_state.gd:1417-1421` | *"BATCH AN §4 re-pointed this at the SPEC POOL ONLY — the 1-spec-plus-2-class draw Batch AH built is dropped … nothing in the run reads them any more"* |
| `test_batch_an.gd:126` | asserts **`roll_ability_offer()` is DELETED**, in the list of AN's deletions |

The Batch AN changelog entry in the archive agrees in its own words: *"drawn from the hero's spec
pool only — the class-pool draw Batch AH added is dropped, abilities are spec-locked now."*

**THE READER WAS DELETED AND THE POOLS WERE LEFT STANDING ON PURPOSE.** That is an orphaning, not
scaffolding — **so per the brief this is a design question about whether the feature comes back,
and this batch has no ruling on it. Nothing was deleted.**

### AND A SECOND, INDEPENDENT REASON THE BRIEF DID NOT ANTICIPATE

**Ask what is reachable ONLY through the dead structure.** Of the 61 distinct names:

| where else the name lives | count |
|---|---|
| some spec's **opening kit** (Heal, Blizzard, Shieldwall, …) | **27** |
| a **live pool** — a spec pool or either draft pool | **27** |
| **NOWHERE ELSE AT ALL** | **7** |

**THE SEVEN: Rallying Shout, Mana Shield, Arcane Surge, Reality Fracture, Dawnbreak, Sanctuary,
Divine Wrath.** Each is authored, resolves through `pool_ability`, and is fully implemented down to
its handler, its status chip and its glossary prose. **`CLASS_POOLS` is the only list in the game
that names any of them** — checked against every other channel: `runes.json` grants none of them,
and `Classes.talent_granted_names()` is empty. **Deleting the container would have deleted the
record of the contents, and nothing would have reported it.**

- **AND THE CORPUS COUNTS ALL SEVEN.** `Classes.ability_corpus()` walks `class_pool(key)`, so the
  population of 227 that fifteen gates are built on includes seven abilities no run can reach.
- **THE 27 KIT ENTRIES ARE WHAT AN ACTUALLY RETIRED.** A Devout could once earn the Holy Cleric's
  Heal; spec-locking is what ended that. The feature was **cross-spec acquisition inside a class**,
  which is a larger thing than the structure looks like from outside.
- `check_dv` §1 **derives the seven rather than listing them**, so the day one is given a home the
  gate says this section is stale instead of a hard-coded list quietly rotting.

---

## §2 — TWO OF HOLY'S THREE ZONE-BOSS AWARDS ROLL EMPTY

**THE AWARD COUNT IS DERIVED FROM BOTH ENDS AND IS THREE.** `Run.SLOT_COUNT` is 3, and
`_resolve_boss`'s own header reads *"THREE ZONE BOSSES, THEN A FOURTH BOSS AFTER ZONE 3 … The END
BOSS … awards a relic, always; NO ability pick (nothing follows it)."*

### EVERY SPEC'S BOSS POOL AGAINST THE AWARD COUNT

| spec | pool | also draftable | boss-only | structural shortfall | can roll empty |
|---|---|---|---|---|---|
| **holy** | **1** | 1 | 0 | **2** | **2, or 3 if he drafts Divine Plea** |
| **inquisitor** | **2** | 2 | 0 | **1** | 1, up to 3 |
| berserker | 3 | 2 | 1 | 0 | up to 2 |
| pyromancer | 3 | 2 | 1 | 0 | up to 2 |
| cryomancer | 3 | 2 | 1 | 0 | up to 2 |
| occultist | 3 | 2 | 1 | 0 | up to 2 |
| warden | 4 | 1 | 3 | 0 | **0** |
| swordmaster | 4 | 2 | 2 | 0 | up to 1 |
| arcanist | 4 | 2 | 2 | 0 | up to 1 |
| beastmaster | 5 | 0 | 5 | 0 | **0** |
| sharpshooter | 5 | 0 | 5 | 0 | **0** |
| mystic | 5 | 0 | 5 | 0 | **0** |

**42 entries, 40 distinct.** Both channels write the same `bm_abilities` list, so a drafted card
removes itself from the boss offer. **The shortfall column is structural** — it is the hole before a
single card is drafted; the last column is what drafting can widen it to.

**THE SIZE OF THE PROBLEM IS MEASURED RATHER THAN ASSUMED, AND HOLY IS NOT ALONE.** Two specs carry
a structural shortfall and six more can be emptied by drafting.

### THE FALLBACK IS A DESIGN DECISION — FOUR CANDIDATES, PRICED

| candidate | build cost | feel | balance cost |
|---|---|---|---|
| **a card from the spec's own draft pool it does not hold** | **none** — `bm_abilities` already takes both channels, and the pools are 10-deep for both thin specs | closest to what the award promises; the player gets an ability, which is what the screen says | **dissolves the distinction between the two channels** — the boss starts doing the draft's job, and a spec-pool card and a draft-pool card stop being different kinds of reward |
| **a class-wide card** | small — `CLASS_DRAFT_POOLS` is live at 24 (4 × 6) | a consolation prize, and reads as one | **class-wide cards are authored WEAKER than spec cards on purpose** (BQ's rule), so the fallback is deliberately worse than what the other eleven specs get. **It is the only candidate that touches §1**: it would give the class channel a live purpose for the first time since AN |
| **a rune** | **lowest of the four** — `roll_rune_candidates` and `rune_picks_owed` exist, and the map's owed-pick overlay already resolves them | changes what the reward IS; either the point or the objection | costs **no ability slot**; rune power is a separate economy, so it does not touch the ability draft's balance at all |
| **gold** | none | weakest — a zone boss already pays `randi_range(110, 130)`, so this is more of what he just got | nearly nil, and that is the problem: a reward the player will not remember |

**AND ONE THING THE PRICING TURNED UP THAT MAKES THE CARD-SHAPED OPTIONS WORTH LEAST EXACTLY WHERE
THE HOLE IS WORST.** `ABILITY_SLOT_CAP` is 7 and **the Holy Cleric carries FOUR protected cores —
the only spec that does** — so he has **three earnable slots, the fewest in the game**. The spec
whose boss pool is emptiest has the least room to put a card in. **Gold and a rune cost no slot;
both card options do.**

**AUTHORING NOTHING IS THE BRIEF'S OWN INSTRUCTION AND IT IS THE RIGHT ONE HERE**: the fallback's
destination is the entire change, and there is nothing to implement until it is chosen. Fixing it
for Holy alone was refused for the brief's reason — the Inquisitor has the same defect one card
shallower, and six more specs reach it through drafting.

---

## §3 — THE PLAYER MAY NO LONGER RECAST AN ARMED PHOENIX

### WHAT IT WAS

`_resolve_special` writes `attacker.ashes_return = ASHES_RETURN_PERFECT` **unconditionally**. A hero
who had already armed Ashes of Al'ar could recast it for **30 Mana and a turn**, write the same
constant, and change nothing — **every turn, at cooldown 0**. `battle.gd`'s bot picker has required
`u.ashes_return <= 0 and not u.ashes_used` since BB. **The bot has been playing better than the
player was permitted to.**

### WHY IT IS NOT IN `RECAST_GATED`, MEASURED RATHER THAN ARGUED

| driven live, phoenix fully armed | result |
|---|---|
| `_recast_targets(mage, ashes)` | **`[]`** |
| `_recast_refused(mage, ashes)` | **false** |

That system reasons about status writes; `ashes` writes a field. **Membership would have changed no
behaviour at all**, and its one visible effect would have been `check_co` reporting the card as
never exercised — which reads like coverage. Inventing a pseudo-status to carry the field would put
a name in `_recast_refusal_note` that `STATUS_INFO` cannot render and the player holds no chip for.
**Both facts are asserted in `check_dv` §3**, so the day the recast system grows a field arm this
ruling says it is stale.

### THE TEST IS EXACT AND COMPUTED AT CAST TIME

```gdscript
if ab.special == "ashes" \
        and (u.ashes_used or u.ashes_return >= ASHES_RETURN_PERFECT):
    return false
```

Four states, driven on a real cast:

| state | door | why |
|---|---|---|
| unarmed | **OPEN** | the cast arms the phoenix |
| armed by a real cast (`ashes_return` = 40) | **REFUSED** | writes the same constant |
| armed **below** what the cast writes (25 of 40) | **OPEN** | that cast would genuinely improve it |
| spent (`ashes_used`) | **REFUSED** | `unit._ashes_guard()` returns early forever once used |

**THE THIRD ROW IS CO §1's WHOLE RULE AND IT IS THE ONLY THING SEPARATING THIS FROM THE CHEAP
VERSION.** Written `ashes_return > 0` the refusal is shorter and refuses a genuine 25 → 40
improvement. The two forms agree in every state the game can currently produce, **because
`ASHES_RETURN` has no caller at all** — so the difference is invisible today and the cheap version
rots the day that changes.

- **REPORTED, NOT COLLAPSED: `ASHES_RETURN` (25) IS A DEAD CONSTANT**, exactly `FIREDRAW_TAKE`'s
  shape. Collapsing it moves a magnitude and is not this batch's.
- **AND IT HAD ALREADY COST A DOCUMENTATION DEFECT.** `master.html` said the phoenix *"returns you
  at 25% of maximum health"* — the dead constant's value. The card and the code both say **40**.
  Corrected toward the code, per the standing rule.
- **THE BUTTON SAYS WHY, IN TWO SENTENCES RATHER THAN ONE.** CO §3's rule. An armed phoenix is a
  resource the player still holds; a spent one is gone for the battle — different states, different
  lines.

### THE REVERSE, ACROSS THE WHOLE POPULATION

Every guard in `_autoplay_pick_kit` and `_bot_drafted_pick` of the form *"only when the target does
not already hold it"*, read against the player's door. **`check_co` structurally could not have
found any of this: it saturates the MEMBERS of `RECAST_GATED`, so it measures the list rather than
the candidates for it.**

**COVERED BY THE GENERAL RULE — the rule working, and the largest group:** Immolate, Rime, Hunter's
Instinct, Venom Coating, Consecrated Ground, Divine Shield and Mantle are all gated; bot and door
agree.

**NOT A NO-OP, SO CORRECTLY UNGATED — the bot's guard there is POLICY, and promoting it would be the
strictly-worse bug arriving through the fix for the first one:**

| card | bot's guard | what the handler ALSO does |
|---|---|---|
| Hold Breath | `not u.has_status("held_breath")` | `_gain_focus(attacker, 40)` — **+40 Focus every cast** |
| Renewal | `not weakest_ally.has_status("renewal")` | the Perfect pays a burst heal; the tick power is recomputed off the caster |
| Snare Trap | `not target_foe.has_status("snared")` | `_hit_and_run(attacker)` |
| Fortified Spirit | `not h.has_status("fortified")` | a recast genuinely unwinds the standing loan and lays a fresh one |

**UNGATED, ALL-ZERO ON THEIR OWN FIELDS, AND REAL CANDIDATES — ruled on nowhere, per the brief:**

- **Mark of the Hunt** (`mark_hunt`) — a flat 7-turn `hunt_mark` and nothing else. Same shape as
  `rime`, which is gated. The general rule would handle it correctly: refuse only when the standing
  mark is already at 7. **The bot's guard is STRICTER than the rule would be** — it refuses whenever
  the mark stands at all, even at one turn left, where a recast would genuinely refresh it.
- **Intercession** (`intercession`) — a window on every living hero, `2 + intercession_long
  (+1 perfect)` turns. Same shape as `cons_ground` and `divine_shield`, both gated.

**AND ONE NARROW GAP THE BOT POINTS AT WITHOUT MATCHING: Deadfall.** Its handler **SETS**
`deadfall_armed = DEADFALL_CHARGES + 1`, so recasting a full one writes the same number. The trap
cap in `_ability_usable` already refuses it at a cap of 1 — **but under Deadfall Network (cap 3) the
door permits it.** The bot's `deadfall_armed <= 0` is not an exact oracle either: it also refuses a
**part-spent** deadfall and a **DORMANT** one, and a recast on either genuinely restores charges and
clears `deadfall_dormant`. **The exact condition is `armed == DEADFALL_CHARGES + 1 and dormant == 0
and deadfall_network >= 2`. Reported, not taken.**

---

## §4 — THE CHANGELOG CUT

**406.0 KiB against CW's 400 KiB threshold, re-derived rather than quoted.** DU predicted *"the next
batch of any size crosses it"* and it had already crossed.

With DV's entry in place the live file held **34 entries**. **Cut at the DF/DG boundary: 16 stay, 18
move.** The live file runs **DV → DG at 150.0 KiB**; the archive runs **DF → Batch 1 at 1314.3 KiB
and 149 entries.** Both headers name the other with its full path. **Nothing was deleted.**

### THE VERIFICATION, WHICH IS THE POINT

**A SECOND SCRIPT, READING THE UNTOUCHED BACKUPS, SHARING NOTHING WITH THE SPLITTER** — the splitter
asserting its own arithmetic proves the splitter self-consistent, not the split correct. **21 checks,
0 failures:**

- **Headings counted TWO INDEPENDENT WAYS** on all four files — line-anchored `^<h2>` and a
  cross-line span match. They agreed everywhere (CX caught Batch BF's wrapping heading only because
  two counts disagreed by one).
- **The counts SUM: 16 + 18 = 34 of 34.**
- **ZERO OVERLAP** — no heading in both halves.
- **ORDER PRESERVED** — kept-then-moved is the original sequence exactly.
- Every heading appears **exactly once** across the halves; none was invented.
- **THE TWO BODIES REJOINED ARE BYTE-IDENTICAL TO THE ORIGINAL** — matching sha256.
- **NO ENTRY WAS EDITED**: all 34 appear verbatim in one half or the other.
- The new archive still **ENDS with the old archive byte for byte**.
- The live header's `<code>` path still yields
  `/Users/zipples/Documents/DoD-archive/changelog-archive.html` under the suites' own extraction.

**NO FILE SIZE WAS ASSERTED ANYWHERE**, in the verifier or in `check_dv` §4 — sizes agreeing is
entirely consistent with a duplicated entry and a dropped one. The sizes above are reported, never
checked.

### EVERY CHANGELOG-READING TARGET, ENUMERATED BEFORE THE CUT

**FOURTEEN, AND NONE NEEDED RE-POINTING** — bb, bn, bo, bp, bq, br, bs, bt, bu, bv, bw, bx, cb, ce.
Every live-changelog assertion in the whole tree is one of exactly two shapes:

1. `live_log.find("/changelog-archive.html</code>")` — the path anchor, still present and still
   resolving; and
2. `not live_log.contains("<h2>DATE &mdash; Batch XX")` — a **negative**, which a cut can only make
   more true.

Their content assertions (`chlog.contains(n)`) read the **archive**, which only grew. **All fourteen
were driven through their own extraction against the freshly cut files before the battery: 0
failures.** **THE REASON THIS CUT COST NOTHING IS CX's WORK, NOT THIS BATCH'S** — CX re-pointed all
eleven of its own and gave them the `<h2>`-anchor-plus-follow-the-header pattern.

---

## §5 — WHAT DU MADE VISIBLE, AND THE RULE THAT STILL CANNOT SEE IT

Four abilities entered the corpus at DU. **Three findings, and the largest is not the one the brief
named.**

### 1. DU'S "THE FOUR MAGE SPECS" IS WRONG, IN THREE PLACES, AND IT IS NOT COSMETIC

Derived off `apply_kit_overrides` itself:

| override | spec | **class kit** | what it replaces |
|---|---|---|---|
| Fireball | pyromancer | mage | Magic Bolt |
| Frostbolt | cryomancer | mage | Magic Bolt |
| Arcane Explosion | arcanist | mage | Magic Bolt |
| **Shadowrend** | **occultist** | **cleric** | **Smite** |

**There are only three Mage specs.** The sentence stands in `docs/reports/DU.md`, `docs/state.md`
and `classes.gd`'s own comment. **TWO class kits were being misread, not one** — a later reader
re-deriving the hole from DU's sentence checks `kit("mage")`, finds it fixed, and never learns that
`kit("cleric")` was in it too. **Corrected in the source comment and in `docs/state.md`; DU's report
is left as the record of what that batch believed** (CA's rule).

### 2. SHADOWREND'S OVERRUN IS 49, NOT 45

| measured as | length |
|---|---|
| authored (`"Cleric recovers {mhp:5}"`) | 23 |
| resolved, no context | 36 |
| + the `"Perfect: "` label every surface supplies | **45** |
| **RENDERED against a real Cleric — what `check_cl_width` counts, and what a player sees** | **49** |

**Five over the ceiling, not one.** The four extra characters are the computed `(6)`, so **this
overrun is caused by CL §1's parenthetical doing its job.** Reported, not fixed — it joins the
standing population of authored overruns. Pinned in `check_dv` §5 as a measurement, so the day it
is fixed the gate says this section is stale.

### 3. AND THE FINDING THAT OUTRANKS BOTH — THE RULE IS BLIND

**`test_batch_cp` §3's literal-digit rule still cannot see any of the four, and it never could see
twelve more.** That suite carries its own hand-rolled Batch CL walk: the four pool tables plus
`Classes.kit(cls)`, **with the overrides never applied and `Classes.spec_abilities` never read.**

| walk | reaches |
|---|---|
| `test_batch_cp._corpus()` | **211** |
| `Classes.ability_corpus()` | **227** |

**The 16 it misses are every spec-kit ability that lives in no pool**: Arcane Cannon, Arcane
Explosion, Death Ray, Detonation, Fireball, Frostbolt, Guard Change, Hex of Ruin, Hymn of Hope,
Kill Command, Resurrection, Shadowrend, Summon Aguila, Summon Canis, Summon Ursus, Wildfire.

**AND ONE OF THEM BREAKS THE RULE.** Arcane Explosion's description carries
**`(2 on a critical strike)`** — an ability-level authored parenthetical digit — and §3 pins that
population as an **equality**: `ability_hits == ["Shatter"]`. **Run over the whole corpus the true
figure is EIGHT**: Arcane Explosion, Detonation, Hymn of Hope, Resurrection, Shatter, Summon Aguila,
Summon Canis and Summon Ursus.

**So the answer to the brief's question is yes — and nothing went red at DU because the rule that
would catch it is blind.** Seven of the eight were always invisible; DU's fix added the eighth and
the walk could not see that either.

**THIS IS DA §3's PROPAGATION-BY-COPY DEFECT IN THE ONE PLACE THAT RULE CANNOT LOOK.** `check_da`
§3 misses it **twice over**: its walk sweep reads `check_*.gd` **only** — the suite half of §3 is
about `_spawn`, not the walk — and its fingerprint matches the two pool **ACCESSORS**, where this
walk reads the **CONSTANTS**. `check_da` reads 37/0 with the violation sitting in the tree.

**REPORTED AND DELIBERATELY NOT FIXED.** Repointing that walk turns a green equality red on **seven
pre-existing offenders**, and rewriting shipped player-facing text is authoring. **The ruling is the
designer's; the rule is in `CLAUDE.md` and pinned in `check_dv` §5 by its consequence** — the count
of abilities outside every pool and class kit — so the day that population empties, a short walk and
the real one agree and this finding is stale.

### ALSO REPORTED, NOT FIXED

**`RECAST_GATED` HOLDS 64 AND TWO DOCUMENTS SAY 59.** `battle.gd`'s own header (*"THE QUALIFYING
SET: 59 abilities"*) and `CLAUDE.md`'s CO block (*"59 abilities since DA §2"*) both stopped being
true when DR added one and DS four. **Nothing in this batch moved that list**, so neither copy is
corrected here — the second-copy rule cuts both ways, and `check_co` prints the live count every
battery run.

---

## §6 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY, AND §4 IS WHY THE ORDER MATTERED MORE HERE

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md` and
`docs/draft-audit.html` all landed **before** the run, because roughly 35 suites assert against the
first three and **§4 edits the changelog**. `docs/state.md` and this report are written after: no
suite reads either, `check_de` reads neither, and the differ is re-runnable in seconds over a log
directory that already exists.

### THE PRE-BATTERY DEFENCES, ALL FOUR PAID

- **THE RETIRED-WORD SWEEP WAS RUN OVER THE EDITED PROSE BEFORE THE BATTERY, USING `bx`'s OWN
  STRIP.** `test_batch_bx` §4 keeps *beast* out of player-facing text and §4b keeps *party* out;
  both read `master.html`. Running §4b's `PARTY_IDENTS` strip over the file now and at HEAD gives
  **0 surviving occurrences either way**, and the *beast* sweep with `Beastmaster` removed gives 0
  either way. DU was caught by this sweep and DS took four reds from it; this cost five minutes.
- **THE LITERAL SWEEP: 10,828 literals at a floor of 4**, from all 81 suites, gates and fixtures,
  evaluated against every changed document and source and diffed against `git show HEAD` in one
  pass. **436 LOST, every one of them in `docs/changelog.html`, and NONE of them asserted there** —
  proved mechanically rather than assumed: every live-changelog assertion in the whole tree is
  either the archive-path anchor (still present) or a **negative** `not contains("<h2>… Batch XX")`,
  which a cut can only make more true. **58 GAINED, and the dangerous kind is ZERO**: every
  `not <doc>.contains(L)` in the tree was cross-referenced against the gained literals and the
  edited documents, with **one** hit — `bx`'s `not master.contains("party")`, which is the
  identifier-stripped sweep already cleared above.
- **THE COMMENT-STRIPPED DIFF WAS TAKEN AGAINST `HEAD`.** With every comment-only line stripped,
  **`battle.gd` GAINED exactly 8 code lines and LOST 0** (the three-line refusal and the five-line
  tooltip block), **`classes.gd` GAINED 0 AND LOST 0** — which is the proof its edit really was
  comments-only — and `run_battery.sh` changed one line. **Nothing was swallowed.**
- **THE PARSE CHECK WAS GREPPED FROM STDERR AFTER EVERY EDIT**, never from the tally and never from
  the exit code.

### FOUR NEGATIVE CONTROLS, ALL FOUR BIT, AND ALL FOUR BIT ON DIFFERENT ASSERTIONS

| control | `check_dv` | which assertions |
|---|---|---|
| the door's condition **deleted** | **2 failures** | the ARMED arm and the SPENT arm |
| the test **loosened to `ashes_return > 0`** | **1 failure** | **the BELOW-VALUE arm alone** |
| a heading **duplicated across the two halves** | **3 failures** | the archive count, the boundary check, and the disjointness sweep |
| one homeless ability **given a live home** | **4 failures** | §1's derived seven, and three in §2 |

**THE SECOND ONE IS THE ONE WORTH HAVING.** It is a one-character loosening that no other assertion
in the project would notice, it agrees with the exact form in every state the game can currently
produce, and it fails exactly one check — which is what proves the exactness arm is separately
load-bearing rather than decorative.

`battle.gd`, `classes.gd` and the changelog archive were backed up to the scratchpad and **restored
by `cp`, never by `git checkout`**, and all three md5s were verified identical afterwards.

### PREDICTED BASELINE MOVEMENT — AND BOTH PREDICTIONS WERE EXACT

Written into `baselines.json` **before** the run.

| row | predicted | read |
|---|---|---|
| `check_dv` | **NEW at 128 / 0** | **128 / 0** |
| `check_de` (no row of its own) | **313 → 317**, four assertions for one new target | **317 / 0 / 0** |
| everything else | **no movement** | **none** |

**`check_de` CERTIFIED ON ITS FIRST PASS**, because the row was added before the battery from three
identical standalone runs of the new gate. **AND IT READ ZERO NOTICES**, which is the half worth
saying: not one check count in the tree moved outside its band, including the fourteen suites the
changelog cut passes through.

### THE ACCEPTANCE BATTERY — ONE RUN, AND IT CERTIFIED CLEAN

| | DT's acceptance | DU's acceptance | **DV's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 309 / 0 / 0 | 313 / 0 / 0 | **317 / 0 / 0 — exactly the prediction** |
| targets in the manifest | 75 | 76 | **77** |

**SEVENTY-SEVEN TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-SEVEN. 0 `Parse Error` and 0
`SCRIPT ERROR` in every log**, grepped from the streams rather than read off a tally or an exit
code. `check_map_screen: OK`; the run harness reads **22 / 165 / 8**.

**THE TREE WAS FROZEN AND PROVED FROZEN: 151 files were MD5-stamped before the run and re-compared
after, and NOT ONE MOVED.**

**THE FLAKE ROW IS STILL NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio read **467 / 0**, the
**eighteenth** consecutive quiet reading. It is still open, still unseeded and still banded, and a
red from it is not the next batch's. `bo` read **1106** and `test_rune_battle` **97**, both seeded
and both closed.

---

## §7 — DOCUMENTATION AND THE PUSH

`docs/changelog.html` (DV's entry, then cut at DF/DG), `CLAUDE.md` (three new standing rules and an
addendum to the propagation-by-copy block), `docs/state.md` **rewritten**, `baselines.json`
(`check_dv` added at `indent=1`, 14 lines and no churn), this report, `docs/design-notes.md`,
`docs/draft-audit.html` (a banner pointing at the boss-pick channel, which that page does not
audit), `docs/master.html` (the phoenix's refusal, the 25% → 40% correction, and the stamp), plus
`run_battery.sh` and the new `check_dv.gd`.

**`DoD-archive/changelog-archive.html` is OUTSIDE THE REPO and this batch grew it by 18 entries.**
It is not in version control and not backed up by GitHub. CLAUDE.md already records that as the
designer's call; **this cut makes the exposure larger**, and the entries it moved — Batch CO through
Batch DF — are recoverable only from the commit of Batch DU until someone acts on it.

**THE KNOWLEDGE SYNC FELL FOR THE FIRST TIME IN THE PROJECT'S HISTORY.** 152 files, **6.77 MiB**,
down from DU's 6.97 — the cut moved 256 KiB out of the repo, and `docs/changelog.html` went from the
**second-heaviest** file in the sync to the **ninth** (406 → 150 KiB). **`CLAUDE.md` is 247 KiB =
3.56%, up from 3.38%**, and the ratio rose for two reasons at once: this batch added three rules,
**and the denominator shrank underneath it.** CW's target is *"under 3% and roughly flat"*; the
second half is met and the first is not, and **DG through DV have now all declined the prune.** DV
declined it while being in the file, for the same reason DT and DU gave — the rules belong beside
the blocks they extend rather than in a pass of their own — but **the fall in the denominator means
the next batch that opens this file cannot decline it on the old arithmetic.**
