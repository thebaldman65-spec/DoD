# BATCH FP — RECONNAISSANCE FOR THE CLASS MERGE

**REPORT ONLY. NOTHING WAS AUTHORED, MERGED, CHANGED, RETIRED OR RETUNED.** No spec was
collapsed, no engine moved, no node cut, no rune re-scoped, no card changed pool, and not one
constant or magnitude moved. **No code moved, no gate was written, no `CLAUDE.md` rule was added
and no data file was touched** — the brief forbade all four.

**The deliverable is `docs/merge-recon.html`**, written on `spec-recon.html`'s pattern with
self-contained sections. This file is the batch's own working: what was measured, how, what the
instruments got wrong on the way, and what the report does not cover.

---

## §0 — THE BRIEF'S TWENTY-FOUR PREMISES

**Nineteen held. Three are FALSE, one is stale, and one is true in substance but names the wrong
mechanism.** The full table with evidence is `docs/merge-recon.html` §0. What follows is only the
five that did not hold and what each cost.

| # | Premise | Verdict | What it cost |
|---|---|---|---|
| 6 | `second_resource` is Mercy, Faith, Focus and Resonance — **one field, four currencies** | **FALSE — three currencies** | Changed the shape of §2's hardest question |
| 12 | The class kit and **the three class-wide draft cards** | **FALSE — 25 cards at 6/7/6/6, share 0.25 per card** | Made the class-shared floor thinner than the brief assumes |
| 15 | There are **103 targets** | **FALSE — 97 in the battery, 105 files on disk** | Nothing; §1e is written against 97 |
| 11 | The three summons are **8 of 8** Beastmaster cards | **STALE — it is 10 of 10** | Nothing; the finding is tighter than the premise |
| 9 | **Trapper is the precedent** for counting statuses from any source | **RIGHT IN SUBSTANCE, WRONG MECHANISM** | Would have sent Sanctity's reading half to a state reader instead of an event funnel |

### PREMISE 6 IS THE ONE THAT CHANGED THE ANSWER, AND IT CHANGED IT FOR THE BETTER

`second_resource_name` is written in **exactly three places** — `"Resonance"` (arcanist),
`"Mercy"` (holy), `"Focus"` (sharpshooter). **Faith is `faith_stacks`, a separate int carried by
every ally.**

**The confusion is real and it is in the code, not in the brief.** `Ability.faith_cost` reads
`u.second_resource`, and `classes.gd:1291` states it flatly: *"`faith_cost` IS MERCY EVERYWHERE IT
APPEARS"* — the field is a misnamed **Mercy** cost, and the only three abilities that carry one
(Resurrection, Divine Plea, Hymn of Hope) are all the Holy Cleric's.

**The consequence is the opposite of what the brief expects.** The brief calls two meters at once
*"the state that does not exist today and the merge creates it everywhere."* **It exists. The
Devout is it** — and so are the Beastmaster and the Occultist, whose Loyalty and Ruin also live
outside that field. **All three display through STATUS CHIPS rather than through the bar**, which
means the game already answered *"a meter that is not the bar"* three times and never widened the
bar to do it.

### PREMISE 9's CORRECTION IS SMALL AND LOAD-BEARING

Trapper's breadth term reads **the target's status LIST** at strike time (`+8% per DIFFERENT
status afflicting the target`). Sanctity counts **application EVENTS**. Those are different
instruments and the brief's word *"precedent"* would have pointed an implementer at the wrong one.
**The event funnel turned out to be narrower and better than the state reader** — see §2 — so the
correction improves the answer rather than only tidying it.

---

## §1 — WHAT WAS MEASURED, AND HOW

Every population below was dumped from a **running headless engine** through the game's own
accessors rather than parsed out of source text, or swept over **comment-stripped** source. Six
throwaway probes were written, run and deleted.

| Question | Method | Result |
|---|---|---|
| The tables | `Classes.all_specs`, `SPEC_INFO`, `SPEC_IDS`, `PROTECTED_CORES`, both pools, `CLASS_DRAFT_POOLS`, `Talents.LANE_TREES` | 12 specs, 4 classes, **16 enablers on 9 specs**, **324 nodes**, 60 live runes, **154 cards (129 spec + 25 class)** |
| Game-side spec reads | comment-stripped line sweep, eleven kinds, `scripts/*.gd` | **368 sites in 17 files** |
| Tree-wide spec literals | same sweep, whole repo | **1,554**, of which **1,419 (91%) are in instruments** |
| Battery targets | `run_battery.sh`'s own arrays, then the same eleven kinds per target | **97 targets, 87 touched**, banded 10 / 14 / 21 / **52** |
| Checks at risk | `baselines.json` check floors summed per band | **45,248 total; 32,393 in band 3 (71.6%)** |
| Rune dependency | every payload field traced to **every** read site in six scripts, classified on the guard chain | **43 engine / 2 enabler / 8 spec-status / 7 neither** |
| Node dependency | payload field read sites + granted abilities + `desc`, then **every survivor hand-verified** | **192 / 17 / 60 / 55 → 50 after five hand removals** |
| Card dependency | bounded `special`-handler window + card text | **83 / 4 / 17 / 25** spec; **0 of 25** class |
| Status machinery | argument-level parse of all 214 `_apply_status` calls | **110 pass a source, 104 do not**; 67 pass a power |
| The profile migration | **CONSTRUCTED AND DRIVEN** in a scratch file | see §3 |

---

## §2 — THE THREE THINGS THE INSTRUMENTS GOT WRONG, AND HOW EACH WAS CAUGHT

**All three are in `docs/merge-recon.html` in place rather than smoothed out**, because a coverage
table that hides its own error bar is the CJ failure the document opens by naming.

### §2a — A FIXED 40-LINE WINDOW OVER-READ THE CLASS CARDS BY THIRTEEN

The first card pass took **40 lines from each `special` match** as the handler. It read **13 of 25
class-wide cards as engine-bound** — against an authoring rule that says class cards *"feed no
passive"*, which was the signal something was wrong.

**The window ran past its own match arm into the next arm, and into `STATUS_INFO`'s const table**,
which is 156 rows of prose full of engine words. That is the greedy-window shape: it fails toward
MORE results, so it reads like a finding rather than like a fault.

**Replaced with a window bounded at the next arm at the same indent**, and with a check that the
match is inside a `func` at all rather than in a const table. **13 → 3.**

### §2b — AND THE BOUNDED WINDOW STILL OVER-READ, BY THREE

Rally, Consecration and Exhortation all matched `/companion/`. **Hand-checked: every one is an
ally loop asking whether a beast may receive a payload**, which is not the Pack Bond engine — it is
the DK/DL widening question those cards have been through twice already.

**Corrected figure: 0 of 25 class-wide cards read an engine.** That is now a measurement rather
than a quotation of the authoring rule.

**The remaining hole is named and not closed.** A card that **FEEDS** an engine without
**READING** it is counted engine-free. Every Pyromancer card that applies Burn feeds Overburn
without reading it. **So the spec-card figure of 83 of 129 UNDER-states the dependency, and it
under-states it worst exactly where the engine is a status** — which is why the report gives the
rune figures (hand-read from every read site) as firm and the card figures as ±a handful.

### §2c — THE MECHANICAL NODE SORT RETURNED FIVE SURVIVORS THAT DO NOT SURVIVE

**A survivor list nobody checked is worth nothing**, so all 55 were hand-verified against their
read sites. Five were cut:

- **Unkillable, Ricochet, Bruising Guard** (Warden) — all three fire **on a BLOCK**. They never
  name Heavy Plating, so no sweep for the engine's name can see them. But `block_chance` defaults
  to **0.0** and is declared by the Warden alone at 0.10, and the only other unconditional source
  is `_plating_slice`, which opens `if u.passive_id == "heavy_plating"`. **All three are worth
  exactly zero to a hero holding neither.**
- **Brittle Ice** (Cryomancer) — its read site is `if _is_held(strike_target)`, and **Held IS
  Glacial Hold**. It looked universal because the node is *party-wide* (`_max_hero_rank`), so the
  crit bonus really does go to every hero — it just needs a Cryomancer to have frozen something
  first.
- **Set and Forget** (Survivalist) — re-arms a sprung **trap**, and traps are his alone.

**The parry/block asymmetry is what made the first three findable.** `parry_chance` defaults to
**−1.0**, a sentinel meaning *use the role baseline*, and `PARRY_CHANCE := 0.05` is that baseline
for every hero. `block_chance` has no such sentinel and no baseline. **So `sm_sword_mastery`
(+parry%) genuinely survives and `wd_unkillable` (on a Block) genuinely does not, and the two look
identical from the payload.**

---

## §3 — THE PROFILE COLLISION WAS CONSTRUCTED RATHER THAN WAITED FOR

**Reading `cells_spent` tells you it skips ids the tree does not hold. It does not tell you what
the player sees.** So the collision was built.

A scratch profile (`Profile.save_path` redirected, as the suites do) with the tier at 3, six
points awarded to the Berserker, three cells bought — `bz_savagery`, `bz_hemorrhage`,
`bz_crushing_blows` — and one equipped.

| Asked against | `cells_spent` | `talent_points_available` | `equipped_learned` | `owns_cell` |
|---|---|---|---|---|
| **The real Berserker tree** | 3 | 3 of 6 | `{"1": "bz_savagery"}` | true |
| **An empty tree** | **0** | **6 of 6** | **`{ }`** | **still true** |
| **The Warden's tree** | **0** | **6 of 6** | — | **still true** |

**And `Talents.has_tree("warrior")` is `false`; `generate_tree("warrior")` returns 0 nodes.**

**Three separate silent failures, and none of them errors or logs:**

1. **The points come back.** Every spent point reads as available again.
2. **The ledger keeps cells that now cost nothing.** `owns_cell` is true for all three while
   `cells_spent` prices them at zero. There is no second accounting anywhere to disagree.
3. **The equipped loadout empties**, because `equipped_learned` skips unknown ids too.

**`Profile._load()` has no version branch at all.** It merges every key it finds over the
defaults and writes `data["version"] = VERSION` unconditionally, reading the old value nowhere.
`VERSION := 2`'s own comment says why that was right when it was written: *"Nothing migrates
because nothing could."*

**AND THE WRITE IS THE UNRECOVERABLE PART.** `_save()` writes the merged dictionary back over the
file **on the next point earned** — so a wrong first load is not a bad read, it is a bad WRITE,
and the original twelve purses are gone the first time the player beats a zone boss. **There is one
backup and it is the player's own filesystem.**

---

## §4 — WHAT THE REPORT SAYS, IN FIVE LINES

Everything below is worked in `docs/merge-recon.html`; these are the conclusions only.

- **50 of 324 talent nodes survive** *"no node may depend on an engine"*, two of them
  conditionally. **Four specs contribute ZERO.** The **Sharpshooter alone supplies 12 of the 50**,
  for exactly the reason the brief picks Focus as the Hunter core.
- **43 of 60 live runes read the engine they sit beside**, and only **7** read neither an engine
  nor an enabler. **Eight more read a spec-exclusive STATUS rather than the engine** — a dependency
  `PROTECTED_CORES` does not track.
- **FM's `requires_ability` problem is the one place the merge is cheaper than the brief fears.**
  7 of 17 in the spawn kit, 10 already conditional — and **five of the seven name an ENABLER the
  proposal makes travel with its engine**, so **exactly two degrade**. The reason is that
  `requires_ability` is a **declared** dependency the offer filter reads; the 43 engine-reading
  runes declare nothing.
- **87 of 97 battery targets read a spec concept**, banded 14 renames / 21 re-derivations /
  **52 rewrites carrying 71.6% of the project's asserted checks.**
- **Channel is cheapest, Momentum middling, Sanctity dearest — and Sanctity's READING half is the
  cheapest of the three.** Its payout is the wall: `STATUS_INFO` holds 156 status ids and carries
  no magnitude at all, so every status magnitude in the game is authored per site.

**AND THE SENTENCE THE BRIEF ASKED FOR, NOT SOFTENED: DN priced its restructure at 97 new nodes
and the designer did not take it. This one is 274 — plus 43 runes and 83 cards, so 400 authored
things stop meaning what they mean today, to move a choice the player already makes.**

---

## §5 — THE FLOOR, AND HOW IT WAS PROVED

**The brief's floor is that it parses and it runs. No code moved, so parse is trivially clean —
the real risk was a doc edit taking a suite literal red.** That was measured rather than assumed.

- **193 needles snapshotted BEFORE the edit.** Every string literal of 4+ characters in the **18
  files that read `docs/changelog.html`** that was present in the live file. Swept after:
  **0 LOST.**
- **A TWO-ARMED CONTROL, because a sweep that cannot bite reads the same as a clean one.** The
  needle `Batch FG</b> at EP/EQ` — chosen off the needle list itself, and one `check_dv` §4
  genuinely asserts — was removed from the shipped copy and, separately, from HEAD's copy.
  **Both arms read LOST = 1.** The zero on the real arm is therefore not vacuous.
- **`check_dv` §4's entry count is a FLOOR (`>= 17`) and not an equality**, which is DW's own
  repair of exactly this hazard, so the new entry (25 → 26 headings) cannot red it. Its
  `live_line == live_span` arm is satisfied because the new heading is on one line.
- **All four changelog gates were run and every one matched its baseline exactly:**
  `check_dv` **83 / 0**, `check_ec` **23 / 0**, `check_el` **23 / 0**, `check_fg` **22 / 0**.
  Parse Error count in stderr: **0** on all four.
- **`check_fg`'s own report:** changelog **236,260 B = 230.72 KiB against the 400 KB bar**, 163 KB
  of headroom; `CLAUDE.md` **untouched at 289,255 B** against the 290 KiB ceiling.
- **No baseline row moved and no manifest entry moved**, because no gate was written and no pinned
  source changed. `docs/merge-recon.html` joins no gate's file list — `check_ec`'s is an explicit
  five-file table and `docs/spec-recon.html` is not in it either.

**WHAT WAS NOT RUN: the full battery.** Nothing in `scripts/`, `data/`, `CLAUDE.md` or
`master.html` moved, and the only asserted surface this batch touched was `docs/changelog.html`,
whose complete reader population — 18 files — was swept and whose four gates were run. **That is
stated here rather than left implicit, because "the battery was not run" is a fact a later batch
needs and not a thing to discover from a commit.**

---

## §6 — WHAT MOVED

`docs/merge-recon.html` (**NEW**), `docs/changelog.html`, `docs/state.md` (rewritten — the FO
WHERE block is replaced, not appended to, and its absence was checked), and this file.

**NOTHING ELSE.** No `.gd`, no `.json`, no `CLAUDE.md`, no `master.html`, no gate, no baseline row,
no manifest entry. Six probe scripts were written, run and deleted.
