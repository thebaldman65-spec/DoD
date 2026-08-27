# BATCH DN — THE TALENT NODES AGAINST THE NEW CHARTER

**A REPORT. NOTHING WAS RE-AUTHORED, NO TREE WAS RESTRUCTURED, NO NODE MOVED.** One new
instrument, `check_dn.gd`, read-only and not in `run_battery.sh`'s `GATES` array — the same
standing `check_cu` and `check_cv` have, and for the same reason: it reports, it does not gate.

```
DOD_DN_DUMP=/tmp/dn.json /Applications/Godot.app/Contents/MacOS/Godot \
    --headless --path . --script check_dn.gd
```

**The audit itself is a new §8 inside `docs/talent-audit.html`** rather than a second document, so
both readings of the same 324 nodes sit together — CU's (does the text match the code?) and DN's
(does the node depend on something guaranteed, or something drawn?).

---

## §0 — TWO OF THE BRIEF'S COUNTS ARE WRONG AGAINST THE REPO

### 1. "The twelve capstones" — THERE ARE THIRTY-SIX

`Talents.CAPSTONE_ROW` is **9** and `Talents.LANES` is **3**. Row 9 is a full row like every other,
so it holds **three capstone cells per spec, one per lane** — **36 across twelve trees.** The
dump confirms it directly: `CAPSTONE CELLS: 36`.

The three the brief names are all real capstones and all in row 9 — `bm_the_pack` (The Pack) is the
Beastmaster's *pack* capstone, `cr_absolute` (Absolute Zero) the Cryomancer's *Deep Freeze*
capstone, `dv_apostle` (Apostle) the Inquisitor's *Faith* capstone. **Each of those specs has two
more.** Both build screens label the row *"CAPSTONE · ONE PER HERO, EVER · any lane"* — the SHELF is
three wide and the PICK is one, which is the most likely origin of a count of twelve.

**Why it matters here:** §2 asks for "each capstone's dependency". That is a 36-row table, not a
twelve-row one, and a third of it would have been missing.

### 2. "CV cut four dead Perfect clauses" — IT CUT THREE

`docs/talent-audit.html`'s own disposition table, written by CV:

> **§1.1 — four dead Perfect clauses → CUT THREE; `dv_bulwark` IS NOT ONE OF THEM.**

CU **found** four. CV cut `dv_resolve`, `oc_hysteria` and `wd_shieldwall`, and ruled
`dv_bulwark`'s 5% party heal **UNCONDITIONAL** (CR §7) rather than dead — its text now says the
heal *happens*.

**Why it matters here:** §3 asks which of CV's rulings a restructure puts back in play.
`dv_bulwark` is a **capstone** (inquisitor / Bulwark / 9), so it is exactly the kind of node a
re-author would touch — and a re-author working from "CV cut four" would re-commit the error CV
ruled against.

*Everything else the brief asserts checked out.* `runes.json` does carry a `lane` field on spec
runes — **36 of them, every lane name exactly once**. The party screen does render live lane-point
headers (`party_screen.gd:518-525`). CV did correct six nodes. CU's three named cross-row
conditionals are all live, and all three read the spec's own mechanics.

---

## §1 — THE SORTING AXIS: GUARANTEED, OR DRAWN?

**The distinction cannot be read off the node text,** which is the whole reason this is an
instrument and not a reading. "Deep Freeze deals +30%" says nothing about whether Deep Freeze is
guaranteed. Every ability name each node mentions is resolved against the LIVE tables —
`Classes.protected_names()`, `spec_draft_pool()`, `class_draft_pool()`, `spec_pool()`,
`class_pool()`.

**ONE MATCHING RULE EARNED ITS PLACE THE HARD WAY: same-tree names beat the corpus.** The Warden
node `wd_spiked` is *named* **Spite**, and the Berserker has a *drafted ability* called **Spite**.
A matcher without that rule reports a cross-spec bet on a card the Warden can never be dealt — the
first pass did exactly that, for `wd_shatter_guard`, and it is not a real finding. The same pass
also matched "Berserk" (a drafted ability) inside "Berserker" seven times, and "Heal" inside
"Health"; **word boundaries and same-tree precedence removed all nine false bets.**

| What the node depends on | Count | Charter verdict |
|---|---|---|
| No ability at all — a stat, its own passive, its own resource | **235** | **Clean.** The charter's own definition of general. |
| An ability in the spec's **PROTECTED CORE** | **75** | Guaranteed by §1 — but see below. |
| Another node in its **OWN TREE** | **17** | Not luck. A build choice. Reported, not ruled. |
| Something **DRAWN** | **6** | **These are the bets.** |

*The rows overlap — a node can name a core ability and a tree node both — so they sum past 324.*

### §1.1 — THE CHARTER CONTRADICTS ITSELF ABOUT 75 NODES

The brief says two different things and they do not agree:

- **§0:** "A node may be general in two ways only: **a STAT, or the spec's OWN resource and
  passive**." Under that sentence, a node modifying *Frostbolt* is out.
- **§1:** "A node modifying a **CORE KIT** ability is guaranteed." Under that sentence, it is in.

**The gap is 75 nodes — 23% of the layer.** Under §1 the trees are **318 / 324** clean; under §0
they are **235 / 324**. This is the largest single number in the audit and it is a **wording
question, not a code question**. §1's reading is the one this report uses, because it is the one
with a mechanical test behind it.

### §1.2 — PER SPEC

| spec | guaranteed | tree-internal | **drawn** |
|---|---|---|---|
| arcanist | 25 | 2 | 0 |
| beastmaster | 21 | 3 | **3** |
| berserker | 24 | 3 | 0 |
| cryomancer | 26 | 1 | 0 |
| holy | 27 | 0 | 0 |
| inquisitor | 23 | 4 | 0 |
| mystic | 27 | 0 | 0 |
| occultist | 27 | 0 | 0 |
| pyromancer | 27 | 0 | 0 |
| sharpshooter | 27 | 0 | 0 |
| swordmaster | 24 | 2 | **1** |
| warden | 24 | 1 | **2** |

**The work is NOT evenly distributed, but not in the direction §1 expected.** Six of twelve trees
are 27/27 guaranteed. The Beastmaster and the Warden hold five of the six bets between them, and
both for the same reason: **they are the two specs whose `SPEC_POOLS` entries are large** (5 and 4)
and whose talent trees were written to interact with them.

---

## §2 — THE SIX DRAWN NODES, AND A SEVENTH THE ABILITY PASS CANNOT SEE

**Every one of the six depends on a `SPEC_POOLS` ability — the zone-boss pick.** Not one depends on
a draft-pool ability, an item, a rune, a relic, or a status another spec produces. Those searches
were run and returned **zero**: the trees mention no item, no rune, no relic and no trophy at all.

| Node | Spec / lane / row | Depends on | Whole node? |
|---|---|---|---|
| `bm_devoted_fury` *Devoted Fury* | beastmaster / devotion / 4 | **Bestial Wrath** | **YES → RE-AUTHOR** |
| `bm_reserves` *Deep Reserves* | beastmaster / handler / 3 | **Spirit Bond** | **YES → RE-AUTHOR** |
| `sm_blade_dance` *Sunder Guard* | swordmaster / Breaker / 2 | Shatterpoint | No → **REWORD** |
| `wd_stomp_drill` *Rallying Cry* | warden / Banner / 3 | War Stomp | No → **REWORD** |
| `wd_bannerman` *Bulwark Line* | warden / Banner / 5 | Interpose | No → **REWORD** |
| `bm_ancient_pact` *Ancient Pact* | beastmaster / devotion / 6 | Spirit Bond | No → **REWORD** |

**TWO NODES ARE DEAD WITHOUT THE DRAW AND FOUR CARRY A BONUS CLAUSE THAT IS.** `bm_devoted_fury`
is one sentence and Bestial Wrath is its subject; `bm_reserves` is *"Spirit Bond restores +30% more
maximum Mana"* and nothing else. The other four stand up on their own — Guard Change and Shieldwall
are PROTECTED CORE, the Rallying Cry drip is a stat, and the Ancient Pact doubling is the passive.

### §2.1 — THE SEVENTH: `sm_precision`

> *"+20% critical strike chance against Dazed, Crippled, and Exposed targets."*

It names no ability, so the ability pass calls it clean. **But the Swordmaster cannot apply Dazed
from anything guaranteed.** The only two appliers in the game are **Charge**
(`CLASS_DRAFT_POOLS["warrior"]`) and **Sweeping Strikes** (`SPEC_POOLS["swordmaster"]`); his core
kit's only status is `stunned`, off Pommel Strike. **Crippled and Exposed he gets only from Lunge**,
which is a tree node (`sm_lunge`). **Take neither Lunge nor a Dazed source and the node does
nothing whatsoever.**

**This is the shape a text-only search cannot find**, and it is why the status question was asked
separately. The rest of that pass came back quiet: every other status a node reads is either the
spec's own passive mechanic (Chilled, Burn, Poison, Ruin, Loyalty, Mercy, Faith, Resonance, Focus),
a universal system (Break / Broken), or one its own core applies — the Occultist's `oc_channeling`
reads *Crippled*, which **Shadowrend**, a core enabler, applies for 2 turns.

*One caveat stated rather than hidden: the `applies_status` map `check_dn.gd` prints covers only
DECLARATIVE appliers. Statuses applied inside `battle.gd` handlers and by passives do not appear in
it, which is why the status pass was a hand-read of the node texts and the map is a cross-check
rather than the answer. Building the core kit through `apply_kit_overrides` rather than through a
name lookup was necessary even for that much — resolving "Shadowrend" by name returns the base
cleric ability, not the Occultist's override, and under-reports the core every time.*

---

## §3 — DO THE THREE LANES FILL? NO. NOT ONE SPEC. NOT AT ANY SIZE.

**This is the finding, and it is the opposite of §1's.**

*Method: a weighted keyword classifier over each node's rendered text (the rule table is in
`check_dn.gd`), then **all 324 read by hand**. 261 cells were left where the rule put them and
**63 were moved**, each with its reason recorded in the audit's own table. The corrections are
systematic rather than scattered — "Burning" scored Offense, so the Pyromancer's entire DEFENSIVE
`Inferno` lane landed wrong; "heal" beside "critical" scored Offense, so most of the Cleric's did.*

| spec | Offense | Defense | Utility | shortfall against 9 / 9 / 9 |
|---|---|---|---|---|
| arcanist | 14 | **4** | 9 | DEF short 5 |
| beastmaster | 8 | **2** | 17 | OFF short 1, DEF short 7 |
| berserker | 16 | **5** | 6 | DEF short 4, UTL short 3 |
| cryomancer | 11 | **1** | 15 | DEF short 8 |
| holy | **0** | 15 | 12 | OFF short 9 |
| inquisitor | **1** | 20 | 6 | OFF short 8, UTL short 3 |
| mystic | 18 | **4** | 5 | DEF short 5, UTL short 4 |
| occultist | 12 | 11 | **4** | UTL short 5 |
| pyromancer | 16 | 8 | **3** | DEF short 1, UTL short 6 |
| sharpshooter | 18 | **0** | 9 | DEF short 9 |
| swordmaster | 16 | 10 | **1** | UTL short 8 |
| warden | 5 | 20 | **2** | OFF short 4, UTL short 7 |
| **TOTAL** | **135** | **100** | **89** | **97 new nodes** |

**ZERO OF TWELVE SPECS CAN FILL THREE NINE-CELL LANES. A 27-CELL TREE AT 9 / 9 / 9 NEEDS 97 NEW
NODES AUTHORED — 30% OF THE ENTIRE TALENT LAYER.**

### §3.1 — TWO STRUCTURAL ZEROES

- **The Cleric has NO offensive node. Not one of 27.**
- **The Sharpshooter has NO defensive node. Not one of 27.**
- The Inquisitor has **one** offensive node (`dv_judgement`, its Zeal capstone); the Cryomancer has
  **one** defensive node (`cr_hungering`).

### §3.2 — SHRINKING THE TREE DOES NOT RESCUE IT

§3 of the brief asks what the tree looks like at a smaller size. The shortfall falls, but it never
reaches zero, because two of the holes are structural rather than numeric:

| rows per lane | cells | points to fill | specs that fill all three | new nodes needed |
|---|---|---|---|---|
| **9** *(today)* | 27 | 54 | **0 of 12** | 97 |
| 7 | 21 | 42 | 0 of 12 | 63 |
| 5 | 15 | 30 | 1 of 12 | 33 |
| 4 | 12 | 24 | 4 of 12 | 22 |
| 3 | 9 | 18 | 5 of 12 | 14 |
| 2 | 6 | 12 | 7 of 12 | 7 |
| 1 | 3 | 6 | **10 of 12** | 2 |

**EVEN AT ONE ROW PER LANE — A THREE-CELL TREE — TWO SPECS STILL CANNOT FILL.** The Cleric would
have an empty Offense cell and the Sharpshooter an empty Defense cell. **No amount of shrinking
sorts this; it can only be authored.**

*Reported, not ruled: a smaller tree is worth considering on its own merits, and 4 rows per lane is
where the curve bends — 22 nodes and eight specs short, against 97 and twelve.*

---

## §4 — THE THIRTY-SIX CAPSTONES

**The brief expects these to be the problem. They are the cleanest part of the layer.**

**33 of 36 are GUARANTEED, 3 are tree-internal, and NOT ONE IS DRAWN.** Twenty-five read nothing
but a stat or the spec's own passive; eight name a PROTECTED CORE ability; three name another node
in their own tree (`ar_wrath` → Conduit, `bm_the_pack` → Lone Bond, `dv_apostle` → Fervor). **Nine
grant a new ability outright**, which makes them the *most* guaranteed nodes in the game rather
than the least — the talent IS the source.

Their landing splits **Offense 19 / Defense 10 / Utility 7**, so the capstone shelf is itself
lopsided in the same direction as the trees beneath it.

**Ruling on none, as instructed.** The observation the designer may want is that **the sanctioned
exception the brief was preparing to grant does not appear to be needed.** The full 36-row table —
each capstone's dependency, axis and landing — is in `docs/talent-audit.html` §8.4.

---

## §5 — WHAT BREAKS OUTSIDE THE TREES

**36 distinct lane names in the trees; the charter replaces them with three.** Six live code sites
read a lane name.

| Site | What three names does to it |
|---|---|
| `data/runes.json` — **36 `lane` fields** | **THE COUPLING THE DESIGN REMOVES.** 36 unique values collapse to 3, repeated twelve times. The rune stays identifiable because `scope: "spec:berserker"` already disambiguates — but **the field stops naming the rune's THEME and names only its category.** "Rune of Exsanguination, Berserker, Offense" says strictly less than "Rune of Exsanguination, Bloodletting" did. |
| `scripts/runes.gd:353,373` | Carries the value onto the live record. Unchanged mechanically. |
| `scripts/run_sim.gd:86,943,962,971` | **EVERY `DOD_SIM_BUILDS` VALUE EVER TYPED BECOMES INVALID** (`cryomancer:Deep Freeze` and the rest). And `_target_lane` falls back to `tree[0].lane` — today twelve DIFFERENT lanes, after the change "Offense" twelve times, so **the default sim build stops being twelve distinct arms.** |
| `scripts/talents_screen.gd:186-191, 199-209, 243` | **Keeps working, and gets simpler.** `_lane_order` derives three columns from first appearance; three repeated names still resolve to three columns. |
| `scripts/party_screen.gd:470-475, 518-525, 541` | The live lane-point headers. Keep working, and **read better**: "OFFENSE 4 / DEFENSE 2 / UTILITY 1" is a build summary; "BLOODLETTING 4 / FURY 2 / WARPATH 1" is a lane tally. |
| `scripts/battle.gd:23281-23293` | The party log line's lane-count summary. Keeps working. |
| `Talents.LANE_NAMES` *(talents.gd:30)* | **Becomes dead, or becomes the whole mechanism.** It exists today only to translate the Beastmaster's three lowercase keys; the other eleven specs store display names directly. |

**THE TEST TREE IS THE LARGER SURFACE AND IS NOT COUNTED ABOVE.** **Twenty-five** `test_batch_*`
files reference a lane, several with hard-coded name tables — `test_batch_ak.gd`'s per-node fixture
carries the lane string beside every id (`"sm_punish": [6, "Breaker", "Punishment", ...]`). **Those
are assertions, not collateral**: a rename moves them all, and each is a place a wrong new value
would go unnoticed.

---

## §6 — SAVED ALLOCATIONS, MEASURED

**Measured by `check_dn.gd` against a scratch profile, not reasoned about.** `Profile.save_path` is
a `var` precisely so a headless check can redirect it.

- **`Profile.talent_cells`** — `spec → {node id: true}`. **Keyed by NODE ID.**
- **`Profile.talent_equipped`** — `spec → {row (as String): node id}`. **Keyed by ROW NUMBER.**
  One-node-per-row is enforced by the KEY, not by a check.
- **`Profile.talent_points`** — points EARNED, ever. There is no second accounting:
  available = earned − `Talents.cells_spent(tree, cells)`, and **`cells_spent` prices each owned
  cell off the row it CURRENTLY sits in.**
- **`Profile.VERSION` is 2 and the load is TOLERANT** — keys merged over defaults,
  `data["version"] = VERSION` stamped unconditionally. **There is no migration step in the file,
  and no version a restructure could bump to trigger one.**

A Berserker with all 27 cells bought — spent 54 of 54, available 0 — then three edits a restructure
makes:

| the edit | spent | available | what the player sees |
|---|---|---|---|
| *(before)* | 54 | 0 | — |
| one row-1 id **DELETED** | 53 | **1** | The point is silently refunded and **the dead cell stays in the save forever** — `cells_spent` skips ids the tree no longer holds, so it stops being charged for and is never cleaned up. |
| one row-1 node **MOVED to row 9** | 56 | **−2** | **A NEGATIVE PURSE. Nothing refuses it, nothing clamps it, nothing logs it.** |
| one row-9 node **MOVED to row 1** | 52 | **2** | Two points gifted. |

**NOTHING ABOVE THROWS AND `version` IS STAMPED 2 EITHER WAY.** That is the whole danger: **meta
progression is the one thing in this game that cannot be re-earned quickly** — 1 point per spec per
ZONE BOSS — and every failure mode here is silent.

**What a migration would have to do:**

1. **Bump `Profile.VERSION` to 3.** There is currently nothing to hang a migration on, because a
   tolerant merge cannot tell a v2 save from a v3 one.
2. **Re-price, not re-key.** Ids are stable across a re-sort — the trees' own convention since
   Batch AJ is *"every node keeps its id so saved trees migrate"*. **The ROWS are what move, and
   the row IS the price.** A migration must recompute `cells_spent` under the new rows and grant or
   reclaim the difference explicitly.
3. **Rebuild `talent_equipped` from its VALUES.** Its keys are stale row numbers the moment a node
   changes row. `equipped_talents()` already drops ids the tree no longer holds, so a DELETION is
   survivable; **a MOVE is not**, because the id validates fine under the wrong row key.
4. **Decide what happens to a CUT node.** Today its point is refunded by accident, as a side effect
   of `cells_spent` skipping unknown ids. That is the right outcome reached by the wrong mechanism.

**Two node ids cannot be renamed without moving the save format regardless:** `bm_beast_within` and
`bm_no_beast_left`, already on the standing list.

---

## §7 — CU'S CROSS-ROW CONDITIONALS, AND CV'S RULINGS

**THE BRIEF NAMES THREE. THERE ARE FIVE ENFORCED BY A PAYLOAD, AND SIXTEEN CROSS-NODE DEPENDENCIES
ALTOGETHER.**

The five with a `condition: {has_node: …}` in the payload — the count is checkable:
`grep -c '"has_node":' scripts/talents.gd` returns **6**, of which **five are payload clauses** and
the sixth is the doc comment above `Talents.condition_met`:

| node | reads | named by the brief? |
|---|---|---|
| `bz_crushing_blows` *Crushing Blows* | `bz_savagery` | yes |
| `bz_frenzied_edge` *Scar Tissue* | `bz_unstoppable` | yes |
| `bz_measured` *Measured Rage* | `bz_reckless` | yes |
| `sm_guarded` *Off Balance* | `sm_punish` *(Punishment)* | **no** |
| `wd_shatter_guard` *Bruising Guard* | `wd_spiked` *(Spite)* | **no** |

Eleven more state a cross-node interaction in text with the mechanism living in `battle.gd` —
`ar_conduit` ↔ `ar_wrath`, `dv_apostle` ↔ `dv_fervor`, `bm_the_pack` ↔ `bm_lone_bond`,
`sm_seasoned_node` → Lunge, `cr_icy_resolve` → Rime, `dv_waters` and `dv_pulse` → Sacred Resolve,
`bm_absolute` → The Pack, and the rest.

**ALL SIXTEEN SURVIVE.** Every one reads a node in its OWN tree — the spec's own mechanics, which
the charter explicitly permits. **Reported, not ruled.** The one observation worth having: **a
cross-row conditional is a bet on a node the player CHOOSES, not on a card they are DEALT**, so it
is not the defect this audit was looking for even though it looks like one.

### §7.1 — WHICH OF CV'S RULINGS A RESTRUCTURE PUTS BACK IN PLAY

| CV ruling | back in play? |
|---|---|
| **A duration is stated as APPLIED** — 5 node texts | **NO.** A convention about what a number MEANS survives any re-sort. |
| **HERO = the four party members; ALLY = heroes and companions** — 32 texts, extended by DJ, DK, DL, DM | **NO, and it must be kept that way.** Five batches of work, and it is about WORDING, not placement. **The risk is not that a restructure re-opens it; it is that authoring 97 new nodes writes 97 new chances to get *ally* wrong.** `docs/text-standard.html` §4.9 is the test. |
| **Four dead Perfect clauses — CUT THREE**; `dv_bulwark`'s heal is UNCONDITIONAL | **YES, and this is the one to watch.** `dv_bulwark` is a capstone. See §0. |
| **Six wrong nodes corrected toward the code** | **Only if those nodes are re-authored.** Four of the six are mid-tree and would be re-sorted rather than rewritten; `py_rebirth` and `dv_resolve` carry granted abilities and are the two most likely to be touched. |
| **Undeclared caps and exclusions declared** — 8 nodes | **NO for the existing eight. YES for anything new** — the sweep was over all 324, so a 325th node is outside it. |
| **Four read-site comments corrected** | **NO.** Comments sit beside the code, and no code moves in a re-sort. |

---

## §8 — THE HONEST ANSWER

**THIS IS NOT A RE-SORT AND A RENAME. IT IS A RE-AUTHOR OF ROUGHLY A THIRD OF THE TALENT LAYER, AND
THE DESIGNER SHOULD KNOW THAT BEFORE STARTING RATHER THAN HALFWAY THROUGH.**

**The two halves of the audit disagree, and that disagreement IS the answer.**

- **THE CONTENT IS ALMOST CLEAN.** Of 324 nodes, **six** depend on something drawn and only **two**
  are dead without the draw. **318 need no charter-driven change at all** under §1's reading. The
  trees were purpose-authored against their specs' own mechanics and it shows. The repair bill on
  the existing text is **two re-authors and four clause cuts.**
- **THE SHAPE CANNOT BE BUILT FROM THEM.** **Zero of twelve specs** can fill three nine-cell lanes.
  **97 new nodes** — 30% of the layer — would have to be written, and **two specs hold a lane at
  zero**, which no shrinking of the tree can rescue.

**The cost is not in the 324. It is in the 97.** And 97 new nodes is a *larger* authoring job than
the original twelve-tree pass, because those were written to a THEME the spec already had, and
these must be written to a CATEGORY the spec demonstrably has no material for — nine offensive
nodes for a Cleric who has never had one, nine defensive nodes for a Sharpshooter who has never had
one.

**Three things fall out, and none is a ruling:**

1. **Settle §0-versus-§1 first** (§1.1). It is the difference between 235 clean and 318 clean, and
   it is one sentence in the charter.
2. **Fix the saved-allocation drift BEFORE the restructure ships**, not after (§6). It is real,
   silent, cheap, and there is currently no version a migration could hang on.
3. **A smaller tree is worth considering on its own merits and does not solve this one.** Four rows
   per lane takes the shortfall from 97 to 22 — a real improvement, and still 22 nodes and eight
   specs short.

**No `CLAUDE.md` rule is added. The charter is not settled until the audit is read.**

---

## §9 — THE BATTERY, AND THE ONE RED IT FOUND

**Two batteries. The first found a real red and it was the new instrument's own fault.**

**Battery 1** ran frozen and reported **`check_da` 37 checks / 2 failures** against a recorded
36 / 0. `check_da` §3's fingerprint for a hand-rolled corpus walk is the pair
`Classes.class_draft_pool(` + `Classes.spec_draft_pool(`, and **`check_dn.gd` carries both** —
because the membership tables ARE the audit.

**It is a false positive, and the fix records why rather than suppressing it.** The mark stands in
for the defect *"this gate re-derived the corpus and is therefore missing the five talent grants
that live in no pool"*. `check_dn.gd` calls **`Classes.ability_corpus()` outright** — that is the
216-name list it matches node text against — and reads the pools for a different question the
corpus cannot answer: **which BUCKET a named ability sits in.** A flat 216 with no membership
cannot say whether Frostbolt is core or drafted, and that distinction is §1 of the brief.

So `check_dn.gd` joins `check_cz.gd` in `WALK_EXEMPT`, with the reason written at the site. **The
count lands at 37 either way**, but the +1 is now the loop that asserts each exempt file *still*
carries the marks, rather than an `ok(false)` accusing a gate. `baselines.json` moved 36 → 37 with
`checks_obs` reset to 1, **in a five-line diff** — the file is `indent=1` and re-dumping it with
library defaults churns seventeen hundred lines for nothing.

**BATTERY 2 IS THE ACCEPTANCE RUN.** The tree was MD5-stamped before it began and was byte-identical
after — **153 files, unchanged across the whole run.**

- **Seventy-one targets ran and the manifest names all seventy-one.**
- **`check_de` (the differ): 293 checks / 0 failures / 0 NOTICES.**
- **Zero throws anywhere.**
- The only red is **`check_cm_live`'s four**, which `baselines.json` records as *"THE ONE RED THAT
  IS ON PURPOSE. Identical on unmodified HEAD."*

**`check_dn` itself is not in `GATES` and owes no baseline row** — it writes no battery log, so the
differ never sees it, which is why `baselines.json` is still 70 rows after a batch that added a
`check_*.gd` file. **Its floor was checked the way the brief asks: `grep` for `Parse Error` on
STDERR, never a tally and never the exit code. Zero, on the final tree.**

### What moved, in full

| file | change |
|---|---|
| `check_dn.gd` | **NEW.** The audit's instrument. Read-only, not in `GATES`. |
| `check_da.gd` | `WALK_EXEMPT` gains `check_dn.gd` with its reason. **No other line moved.** |
| `baselines.json` | `check_da` 36 → 37, `checks_obs` → 1, note added. Five lines. |
| `docs/talent-audit.html` | **NEW §8** — the second reading, 37 → 158 KiB. Nothing existing was edited except the stamp line. |
| `docs/changelog.html` | The DN entry. |
| `docs/state.md` | Rewritten. |
| `docs/reports/DN.md` | This file. |

**NO GAME CODE MOVED. NO TALENT NODE MOVED. NO SAVE VERSION MOVED** (run save still v10, `Profile`
still v2). **`master.html` did not move and its stamp is still `(Batch DM)`** — DN changes nothing
about what the game IS, so the fourteen self-comparing stamp gates are correct to read DM.
**No `CLAUDE.md` rule is added: the charter is not settled until the audit is read.**
