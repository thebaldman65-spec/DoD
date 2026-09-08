# BATCH FJ — RECONNAISSANCE ON THE EIGHT UNAUTHORED SPECS

*2026-09-07. Full working. `docs/state.md` carries the summary; this file carries the evidence.
The deliverable itself is `docs/spec-recon.html`.*

**A REPORT.** No rune was authored, proposed, sketched, named or reserved. **No card, ability,
talent, constant or magnitude moved; no `.gd` file, no `.json` data file and no gate was touched;
no `CLAUDE.md` rule was added.** Four documents moved and one of them is new.

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

Five were checked. **Four held. One was a naming trap that would have wasted a rune set.**

| Premise | Verdict |
|---|---|
| The eight are Berserker, Pyromancer, Cryomancer, Holy, **Devout**, Arcanist, Swordmaster, **Survivalist** | **Two are DISPLAY names, not code keys** — see below |
| `Classes.protected_names` and `core_slots` "disagree for all twelve specs" | **HELD.** 12 of 12, and `check_eh` §3 already asserts the count is 12 |
| Twenty-one live runes across four authored specs | **HELD.** Warden 5, Occultist 5, Sharpshooter 5, Beastmaster 6; 66 retired |
| `master.html` may hold claims that contradict the code | **HELD.** Two found, both corrected — §4 |
| "CN found 137 abilities that field-level reads misjudge" | **NOT REPRODUCED, and not re-derived.** My own population is different: **160 of the 227-card corpus carry a `special`.** Stated as my number, not as CN's |

**THE NAMING TRAP.** **Devout is `inquisitor` and Survivalist is `mystic`.** `classes.gd:373-374`
and `:412-414` record that the docs and the code disagree **by design**, and that a `"devout":`
entry "would raise nothing, resolve nothing". `Runes._scope_ok` matches on the spec key, so **a
rune scoped `spec:devout` or `spec:survivalist` would roll for nobody, silently.** Two of the eight
rune sets were one string away from being unreachable.

---

## §1 — WHAT EACH SPEC ACTUALLY HAS

**Derived from a running headless engine, not from `master.html` and not by parsing source.** A
throwaway probe called the game's own accessors — `protected_names`, `core_slots`,
`core_enablers`, `spec_draft_pool`, `spec_pool`, `class_draft_pool`, `SPEC_INFO`,
`Talents.LANE_TREES`, `ability_corpus` — and dumped every `Ability` field off the built object.
**Zero `Parse Error` in the probe's stderr** (grepped, not read off the exit code). The probe was
deleted before the commit.

### THE POPULATION IS THREE CHANNELS, AND THAT CHANGES EVERY CONDITION SUM

`hold_ability()` (`run_state.gd:1975`) is **the one place a card enters the pool from either
channel** — `take_draft_ability` for the elite draft, `map_screen._pick_ability` for the zone-boss
pick. Both write `bm_abilities`. **`Runes.drafted_names()` reads that list**, so a boss-pick card
counts toward a THRESHOLD exactly as a drafted one does.

| Spec | boss (`SPEC_POOLS`) | spec draft | class draft | **distinct reachable** |
|---|---|---|---|---|
| berserker | 3 | 10 | 6 | **17** |
| pyromancer | 3 | 13 | 7 | **21** |
| cryomancer | 3 | 11 | 7 | **19** |
| holy | 3 | 10 | 6 | **18** |
| inquisitor | 2 | 11 | 6 | **17** |
| arcanist | 4 | 12 | 7 | **21** |
| swordmaster | 4 | 12 | 6 | **20** |
| mystic | 5 | 10 | 6 | **21** |

**Reading only `SPEC_DRAFT_POOLS` understates the population by 5 to 9 cards a spec.** Seven of the
eight also have **two cards in both the boss pool and the draft pool**, so taking one through
either channel removes it from the other.

### `core_slots` VS `protected_names` — BOTH ARE LIVE, AND THE GAME READS BOTH

The disagreement is **systematic, not arbitrary**: `protected_names` = the class basic (after
`apply_kit_overrides`) + the spec's opening abilities; `core_slots` counts only what occupies a
slot, and **the basic attack occupies none**. For the Beastmaster the three summons also share one
bar entry, which is why he reads 3 against six names.

- **`core_slots` is a SLOT count** and the CAP reads it — `run_state.ability_slots_used()` is
  `core_slots(spec) + equipped`, and `map_screen` uses it for the earned-slot arithmetic.
- **`protected_names` is a NAME count**, read by exactly three files (`classes.gd`,
  `map_screen.gd`, `run_state.gd`), and `check_eh` §3 asserts that reader list by name.

**This was already settled at EH §3 and is re-derived here rather than quoted.**

### THE ENGINES

Every passive's mechanic, constants by name and value, accrual, spend, cap and clear, and **every
read site as a LINE, labelled the raw meter / a payout / a threshold** — the full tables are in
`docs/spec-recon.html`. Three structural findings worth carrying here:

- **Only `permafrost` is looked up party-wide** through `_living_hero_passive()` (4 call sites).
  Every other engine of the eight is read off `attacker.passive_id ==` at the strike site.
- **`second_resource` is shared machinery** — Mercy (Holy), Resonance (Arcanist), Focus
  (Sharpshooter). A rune written against the field rather than against `second_resource_name`
  reaches three specs.
- **Faith is not a bar.** `faith_stacks`/`faith_peak` live on **every hero** as a status. The
  Devout's engine is party-wide status plumbing.

---

## §2 — WHAT A RUNE COULD NOT DO

**This is the half that would have saved EZ.** Full per-spec lists in the document; the four
findings that generalise:

### (1) A BREADTH RUNE CAN NEVER BE SATISFIED BY A DEVOUT

`breadth_met_fraction(drafted)` is `primary_tag_peak(drafted) * 3 <= drafted.size()`. At *n* cards
the peak must be at or under `floor(n/3)`, which needs **three distinct primary tags at six cards
and four at seven**. The Devout's entire reachable pool — all 17 cards, all three channels —
carries **two**: DEFENSE (14) and OFFENSE (3). **Impossible at every bar size from 3 to 7.**

### (2) AND HIS DEFENSE THRESHOLD IS AUTOMATIC FROM SIX CARDS ON

`threshold_met` needs `count(tag) * 2 >= n`. With only **three** non-DEFENSE cards in his reach, at
n≥6 he cannot hold enough off-tag cards to fail. At n=3–5 it is a genuine choice; from 6 it is a
free clause. **Only OFFENSE is a real threshold for him, and it dies at n=7.**

### (3) TWO CONDITIONS ARE LIVE AT ONE RUNG OF THE LADDER AND DEAD AT THE NEXT

The bar is `ability_slot_cap()` (`[7,8,9,10]` by zone bosses cleared) minus `core_slots`, so a
3-slot spec carries 4→7 and the Holy Cleric 3→6.

- **Holy BREADTH is satisfiable at exactly n=6.** Three tags; at 6 the limit is 2 and 3×2=6 exactly
  reaches. At 4, 5 and 7 it needs four or more tags, which do not exist.
- **Swordmaster BREADTH fails at exactly n=5** and holds at 4, 6 and 7. Four tags; n=5 wants five.

### (4) `BREAK` CANNOT CARRY A THRESHOLD ANYWHERE IN THE GAME

**Zero of the 227 tagged cards carry a BREAK primary; 99 carry it as a secondary.** FD made BREAK
secondary-only deliberately, and `master.html` records that ruling correctly. **The consequence
nobody had written down** is that `primary_tag_count(drafted, "BREAK")` is always zero, so a
THRESHOLD rune gated on BREAK is inert for **every hero in every build, in all twelve specs**.

### THE BARE LITERALS — WHERE THE NEXT EZ WOULD HAPPEN

| Spec | Term | Line | Has a bonus field? |
|---|---|---|---|
| Swordmaster | aggressive **dealt** `1.15 + …` | `battle.gd:9507` | **yes** — node + rune + Discipline |
| Swordmaster | defensive **taken** `maxf(0.85 - …)` | `battle.gd:10015` | **yes** — node + rune + Discipline |
| Swordmaster | aggressive **taken** `raw *= 1.10` | `battle.gd:10013` | **NO** |
| Swordmaster | defensive **dealt** `raw *= 0.90` | `battle.gd:9510` | **NO** |
| Survivalist | +8% per distinct status | `battle.gd:9227` | **NO** |
| Survivalist | 25% poison barb | `battle.gd:10964` | **NO** |

**Both of the Swordmaster's UPSIDES are reachable and both of his DOWNSIDES are not.** *"Your
Defensive guard no longer blunts your blade"* is the natural sentence and it is unimplementable
from data. And **Force of Nature REPLACES Trapper's own term** — the branch is
`if force_of_nature != null: … elif passive_id == "trapper": …` — so a rune written against the 8%
is silently worth nothing to a Survivalist holding that capstone.

### 58 IDLE `rune_*` FIELDS, AND EVERY ONE IS STILL WIRED

80 `rune_*` fields are declared on `BattleUnit`. **22 are written by a live rune; 58 belong to the
66 retired ones and are written by nothing** — yet all 58 still have read sites. That is the
plumbing an author reaches **with no new code**, and it is wildly uneven:

| Spec | Idle fields | | Spec | Idle fields |
|---|---|---|---|---|
| inquisitor | **7** | | pyromancer | 4 |
| mystic | 6 | | swordmaster | 3 |
| cryomancer | 5 | | **berserker** | **1** |
| arcanist | 4 | | holy | 4 |

**The Cryomancer's four are a special case.** `rune_frigid_ranks`, `rune_frostbite_ranks`,
`rune_hungering_ranks` and `rune_hypothermia_ranks` all arrive through
`_max_hero_rank(field, rune_field)` (`battle.gd:7614`), which takes the highest `node + rune`
**across living heroes**. A rune written against one **competes with the talent node on a different
hero rather than stacking with it**, and it pays for the whole party's cold rather than the
wearer's. No other spec's rune plumbing is read that way.

---

## §3 — WHAT THE FOUR AUTHORED SPECS DID, AS A PATTERN

**21 live runes: 14 PASSIVE, 5 ABILITY, 2 STAT. 4 THRESHOLD, 4 BREADTH, 4 TRADEOFF, 9 bare.**

**The invariant, which nobody had written down: each of the four sets got EXACTLY ONE THRESHOLD,
EXACTLY ONE BREADTH and EXACTLY ONE TRADEOFF, with the rest bare.** 4 × 3 gated + 9 bare = 21.
THRESHOLD and BREADTH always sit on a `PASSIVE`; the TRADEOFF is on a `STAT` twice (Warden,
Beastmaster) and an `ABILITY` twice (Occultist, Sharpshooter). The Beastmaster is the only set of
six and his extra is a bare `PASSIVE`.

**This is a description of what was done, not a rule that binds the eight** — the designer's
standing rule is that the combination follows the spec.

**Tags gated by a live rune:** DEFENSE ×2, DEBUFF ×1, MARK ×1. **Gated by none:** BREAK, RESOURCE,
OFFENSE, TEMPO — and BREAK never can be. BREADTH is tag-agnostic; four runes carry it.

All 21 are priced at **100g** — price is not yet a lever. **3 of 21** carry `requires_ability`
(Open Wound→Shadowrend, Split Shield→Shieldwall, Ambush→Called Volley). **None carries a `lane`**;
ES §5 severed that rule and `check_ez` asserts a live rune carrying one is the rule coming back.

---

## §4 — TWO FALSE CLAIMS IN `master.html`, CORRECTED TOWARD THE CODE

The brief's §4 permits exactly this and nothing else. Both claims sat in the rune-condition
section, **four lines below a paragraph that states the rule correctly** — EI's hazard exactly.

1. **"The protected core is in the count, because it is carried: it is half to two thirds of the
   bar."** **False.** `Runes.drafted_names()` reads `bm_equipped`, falling back to `bm_abilities` —
   the EARNED cards. Both surfaces that draw the tick (`party_screen.gd:425`, `map_screen.gd:1763`)
   call it. **The denominator is 4–7, or 3–6 for the Holy Cleric — not the 7-to-10 bar.** The
   whole-bar figure belongs to a different question: `Run.loadout_ability_names()` is core + earned,
   and that is what the on-screen tag census walks.
2. **"THE DEFAULT SHAPE IS A THRESHOLD — hold 2+ of a tag."** **False.** That is the charter's
   opening shape. The live rule is `primary_tag_count(drafted, tag) * 2 >= drafted.size()` and has
   been since ES §4, which moved the conditions to drafted-only counting precisely because a
   protected core alone met a 2+ threshold on BREAK for ten of twelve specs.

### THE EDITS WERE PROVED BY NEEDLE SWEEP, AND THE SWEEP WAS ARMED FIRST

Every string literal of 4+ characters in every file that reads the document, against the copy at
HEAD and against the copy now.

| Document | Reader files swept | Needles | LOST | GAINED |
|---|---|---|---|---|
| `docs/master.html` | 34 | 12,371 | **0** | 18 |
| `docs/changelog.html` | 18 | 4,854 | **0** | 33 |

**A sweep that reads 0/0 on an unchanged file has proved nothing** — so it was armed before it was
believed. A **same-length** one-character edit to a real needle
(`"…receive 40% more healing."` → `41%`, `check_dk.gd`) moved the count to **1 LOST**. Same length
on purpose: a drop or a duplication moves the file size and a weaker check would catch it.

**Every GAINED was checked** against the pin manifest and against whether any target uses it
negatively. All are common identifiers (`bm_equipped`, `bm_abilities`, `core_slots`, `inquisitor`,
`mystic`, `devout`). The only negative use of any of them is `check_eh.gd:255`, and it is against a
substring of `run_state.gd`, not against a document. The changelog's negative assertions are all of
the form *"this old batch's `<h2>` is not in the live file"*, and FJ's heading matches none.

**The populations were deliberately over-broad** — `grep -l` on the filename rather than on the
`res://` path — which fails toward MORE needles. The true reader counts are 25 and 17.

### AND NOTHING READS `docs/state.md`

The same sweep over state.md reported 3 LOST, and **all three are false positives**: no `.gd` file
opens `res://docs/state.md` at all. The nine "readers" mention it only in prose comments. The
strings (`"Control"`, `"/root/Run"`) appear in those files for unrelated reasons and happened to
also appear in the old text. **The file has zero readers and nothing can assert against it.**

---

## §5 — ONE INSTRUMENT FAULT, CAUGHT BEFORE IT SHIPPED AS A FINDING

The read-site extractor masked string literals before matching — the ordinary way to stop a sweep
matching its own name inside a comment or a colour literal.

**Half this codebase's field reads are string-keyed.** `_max_hero_rank("frigid_ranks",
"rune_frigid_ranks")`, `cfg.get("rune_opening_volley", 0)`, `_stat("cz_rage_spent", …)`. The masked
sweep reported **five idle `rune_*` fields as having ZERO read sites, four of them the
Cryomancer's** — which reads as *a rune written against these would install and do nothing*, and
would have been the report's most alarming headline.

**It is false. All five are read.** The stripper now cuts only the comment, tracking quotes so a
`#` inside `"#e05050"` does not truncate the line, and it was verified on three cases first — a
string-keyed read, a colour literal, and a bare mention inside a comment. **Two-armed against the
same population: the masking version reads 5 dead, the fixed one reads 0.** The correct number of
dead rune fields is **zero**.

**It fails toward the alarming answer**, which is the half worth recording.

---

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **Nothing was authored.** No rune proposed, sketched, named or reserved.
- **The generated stat family stays.** It comes out once the eight specs are authored; the order is
  the designer's and it is deliberate.
- **No card, ability, talent, constant or magnitude moved.** No `.gd` file and no `.json` data file
  was touched, so `pin-manifest.json` reads **current at 1,423** unchanged.
- **No `CLAUDE.md` rule was added and no gate was written**, per the brief. **Nothing here is
  settled until the document is read.**

### AND WHAT THIS PAGE DOES NOT COVER, STATED RATHER THAN IMPLIED

- **Balance.** Nothing says whether a magnitude is right or a pool well-priced.
- **The enemy side.** No enemy ability, boss script or encounter table was read.
- **Talent node read sites.** All 324 nodes were dumped with lane, row, desc and payload, and lane
  themes are reported — but node read sites in `battle.gd` were followed only where a node collides
  with something the page names. **A rune duplicating a node's payload FIELD would be caught; one
  duplicating a node's EFFECT through a different field might not.** This is the page's widest
  edge and it is stated at the top of the document as well as here.

---

## §7 — VERIFICATION

The brief's floor: **it parses, it runs.**

- **`grep 'Parse Error'` over the probe's stderr: 0.** Never a tally, never the exit code.
- **The four documents are HTML and Markdown.** No `.gd` file changed, so no gate's behaviour
  could have moved except through a document, and the two document edits with readers were swept
  to **zero LOST**.
- **`build_pin_manifest.py --check`: current at 1,423 pins.**
- The acceptance run is recorded below the line in the commit.

## §8 — WHAT A LATER BATCH SHOULD NOT RE-DERIVE

- **`Devout` is `inquisitor` and `Survivalist` is `mystic`.** A rune scoped to the display name
  rolls for nobody, silently.
- **A rune condition counts the EARNED cards, never the protected core**, and the denominator moves
  with the ladder — so a condition can be live at one rung and dead at the next. Two of the eight
  already have that shape.
- **`BREAK` can never carry a THRESHOLD.** Zero primaries, game-wide.
- **58 idle `rune_*` fields are still wired**, and the Cryomancer's four are read party-wide with a
  MAX rather than per-wearer.
- **A read-site sweep that masks strings cannot see this codebase.** Half the reads are
  string-keyed, and the failure is a false "this is dead".
