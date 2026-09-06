# BATCH FE — THE RUNE ROWS FOLLOW THE CARDS, AND THE OTHER TWO QUEUES ARE DRIVEN

*2026-09-06. Two items, both handed forward by FD. §1 is a consistency ruling on five table rows;
§2 is the reachability question FD opened and did not answer — and the answer moved both of its
findings.*

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

**Three did not survive, and one of them decided how §2 was written.**

| Premise | What the repo says |
|---|---|
| *"`long_watch` and `bared_plate` … and any other rune row with BREAK first"* | **TRUE, and the population is FIVE.** Derived off the table: the two live rows plus `comet`, `seventh_bolt` and `shattered_guard`, all retired. The brief's own instruction to derive rather than take is what found the other three. |
| *"EZ §0c already established that the two conditions count PRIMARIES, so a rune's primary is not merely descriptive"* | **FALSE.** Both conditions count **CARD** primaries over the hero's DRAFTED CARDS (`Classes.primary_tag_count` / `primary_tag_peak`). **Neither reads `RUNE_TAGS` at all.** A rune's own primary is merely descriptive — and §1b measures that it is weaker than that. |
| *"`bm_candidates` … unguarded"* | **FALSE, and this is the one that mattered.** `_pick_ability` already refused `pool_name in member["bm_abilities"]`. The fault is real but it is a **different fault**, and repairing the one the brief describes would have left the one that exists. §2b. |
| *"`inquisitor` displaying as Devout has misled a brief at CE, CF and again in FD's own pressure table"* | **MIS-ATTRIBUTED.** It misled **EQ §3 and ER §1** — both the claim that his boss pool is the only one with no damaging card — and is recorded at CW §84 as a name that looks wrong and is right. **FD's pressure table is correct**: its row reads `inquisitor` and the numbers are the Devout's. The underlying point stands; the three citations are two, and neither is CE or CF. |

**And the brief's file list names `data/runes.json`, which this batch has no reason to touch.** No
rune entry carries a tag field — the fields are `desc`, `lane`, `name`, `payload`, `price`,
`requires_ability`, `retired`, `scope`. §1 lives entirely in `scripts/runes.gd`.

---

## §1 — `RUNE_TAGS` FOLLOWS THE CARDS

### THE POPULATION, DERIVED OFF THE TABLE

**Five rows carried BREAK first. All five now read `["OFFENSE", "BREAK"]`.**

| Row | Was | Now | Live? |
|---|---|---|---|
| `long_watch` | `["BREAK"]` | `["OFFENSE", "BREAK"]` | **LIVE** |
| `bared_plate` | `["BREAK", "DEFENSE"]` | `["OFFENSE", "BREAK"]` | **LIVE** |
| `comet` | `["BREAK"]` | `["OFFENSE", "BREAK"]` | retired |
| `seventh_bolt` | `["BREAK"]` | `["OFFENSE", "BREAK"]` | retired |
| `shattered_guard` | `["BREAK"]` | `["OFFENSE", "BREAK"]` | retired |

**FOUR OF THE FIVE CARRIED BREAK AS THEIR ONLY TAG** — the brief asked for those to be reported,
and they are the cheap half: one tag becomes two and nothing is displaced, exactly as the 20
single-tag cards among FD's 54 did. **BREAK stays on all four**, because the ruling FD wrote is
that BREAK is *demoted, never removed*, and no standing ruling owns any of their second slots.

**`bared_plate` IS THE ONE PER-RUNE JUDGEMENT AND IT IS NOT A FEINT.** It read
`["BREAK", "DEFENSE"]`, and two tags is the ceiling (`check_ek` §2 asserts it), so retaining BREAK
displaces DEFENSE. **That DEFENSE was recording a DRAWBACK** — the rune spends the hero's Block for
+25% Break damage, and the row's own comment said *"it SPENDS defense"*. **The drawback is already
recorded one table down**: `RUNE_SHAPES["bared_plate"]` reads `["STAT", "TRADEOFF"]`. Nothing is
lost that is not written elsewhere, which is why this is a displacement rather than the collision
Feint was. It is the rune-side equivalent of FD's 30 displaced secondaries, and it is one row
rather than thirty.

**THE RETIRED THREE MOVE WITH THE LIVE TWO, DELIBERATELY.** The reason for the ruling is that one
vocabulary with two rules is the defect; a retired entry is kept precisely so it can be read, and a
row left behind is the second rule arriving by a different door.

**The primary spread**: BREAK 5 → 0, OFFENSE 14 → 19, and DEBUFF 23 / DEFENSE 29 / RESOURCE 15 /
TEMPO 1 / MARK 0 are untouched — the transform moved rows between exactly two columns, and
`check_fe` §1 asserts every other column rather than only the two.

**Rune rows carrying BREAK at all: 9 before, 9 after.** That number not moving is what says this
was a demotion and not a removal, and it is asserted.

### AND NOTHING READS A RUNE'S PRIMARY AS A CONDITION — WHICH IS WEAKER THAN "DISPLAY-ONLY"

**The brief asked for this to be confirmed and said to say so plainly if nothing does. Nothing
does, and the true statement is stronger than the one four documents carry.**

FD, `CLAUDE.md`, `docs/state.md` and `master.html` all call `RUNE_TAGS` *"display-only
(`rune_tag_line`)"*. **The table reaches no surface at all.** The whole chain is:

```
RUNE_TAGS  ->  Runes.rune_tags()  ->  Runes.rune_tag_line()  ->  NOTHING
```

**`rune_tag_line` has ZERO callers** in `scripts/` and in `scenes/`; its only mention anywhere
outside its own definition is its NAME inside `check_ek`'s `TAG_SURFACE` list. `docs/reports/EK.md`
is where that was deferred — the rune offer *"wants its own rune-offer surface, which is the rune
batch's work"* — and that surface has not been built. `rune_shape_line` is in the same position.

**And neither rune CONDITION reads the table.** `Runes.threshold_met` counts
`Classes.primary_tag_count` and `Runes.breadth_met_fraction` counts `Classes.primary_tag_peak`,
both over the hero's DRAFTED CARDS. **So this change is purely for consistency and has no
mechanical effect whatsoever** — not a small one, none. `check_fe` §1b asserts the inertness from
the source, in both directions, so the day a rune condition reads `RUNE_TAGS` the gate says so
rather than four documents quietly becoming false.

---

## §2 — THE TWO FROZEN QUEUES, DRIVEN

### 2a. THE IDIOM'S POPULATION IS FIVE, NOT FOUR

Derived off **what a rolled offer is STORED on**, rather than off a list of screens — the same
derivation-from-the-write FD used for the offer sites.

| Queue | Rolled at | Answered at | Saved? | Re-asked? |
|---|---|---|---|---|
| `rune_candidates` | elite cache / bargain | `map_screen._pick_rune` | yes | **YES** — `Run.rune_choice` (FD §1) |
| `draft_candidates` | elite victory | `Run.take_draft_ability` | yes | **YES** — refuses a card the hero knows |
| **`pending_item_offers`** | loot / relic / event | `map_screen._check_item_offers` | yes | **YES** — re-asks the POUCH |
| `bm_candidates` | **zone boss** | `map_screen._pick_ability` | yes | **NO** |
| `up_candidates` | **mini-boss** | `map_screen._pick_upgrade` | yes | **NO** |

**`pending_item_offers` IS THE FIFTH AND FD DID NOT HAVE IT.** It is already guarded and says so in
its own comment — *"The pouch may have changed since the offer was queued"* — and it re-asks with
`if not Run.needs_slot(id)`, taking the item silently when the room now exists. **Three of five
were guarded, not one of three.**

**THE SHOP AND THE BLACKSMITH ARE NOT IN THE POPULATION**, and that is asserted rather than
assumed: both roll into a screen-local `offers` in `_ready` and neither is saved, so neither can go
stale. A census that quietly included them would report a population that never had the fault.

### 2b. REACHABILITY IS STRUCTURAL, AND IT IS THE WHOLE QUESTION

`MINI_SLOT` (7) and `BOSS_SLOT` (15) are **fixed slots**, one of each per zone, three zones —
**three mini-boss awards and three zone-boss awards per run**, and the mini-boss is where the first
half of the map converges, so no route avoids either. Both award to **every** member. **Nothing
forces the answer**: the pick waits on the hero card behind a badge, and no travel is blocked on
`bm_picks_owed` or `up_picks_owed`. Three of each can be queued before one is answered.

### 2c. `bm_candidates` — THE BRIEF'S FAULT IS NOT THE REAL ONE

**A DUPLICATE ABILITY IS NOT REACHABLE, AND THE REASON IS WORTH WRITING DOWN.** `_pick_ability`
already refused `pool_name in member["bm_abilities"]`, and `bm_abilities` is **the only term of
`owned_ability_names` that moves during a run**: the kit is fixed, kit overrides are fixed, BM's
ruling locks `talents` for the run, and `Runes.kit_names` does not read a rune's granted ability
(no live rune grants one in any case). A drafted card also lands in `bm_abilities`, because
`take_draft_ability` calls `hold_ability`. **So the one field that moves is the one field the guard
reads.**

**BUT IT REFUSED BY RETURNING**, which pops nothing and decrements nothing — and the overlay drew
its buttons off the raw stored triple. Driven, 240 runs, three picks queued and answered in order:

| | |
|---|---|
| two queued triples share a name, back to back | **400 / 400** |
| …with a whole zone of drafting in between | **240 / 240** |
| dead buttons drawn across the drive | **604** |
| runs where a queued pick became **UNANSWERABLE** | **20 / 240 — and all 20 are the Inquisitor, which is 20 of 20 of his** |

**THE COLLISION IS CERTAIN RATHER THAN LIKELY, AND THE POOL SIZE IS WHY.** The boss pool is 2 to 5
entries (`spec_pool`: inquisitor 2; berserker, pyromancer, cryomancer, holy, occultist 3; warden,
swordmaster, arcanist 4; beastmaster, sharpshooter, mystic 5) and an offer is `slice(0, 3)` — so
where the pool is three or fewer, **two triples are the same set**. And drafting in between does
not help: a draft comes out of `spec_draft_pool` (10–13 entries), **a different pool**, so it never
depletes the boss pool.

**THE INQUISITOR IS THE SHARP CASE.** His boss pool is two. Defer all three picks and the first
two answers empty it; the third triple is then two names he holds, **both buttons dead**, and
`bm_picks_owed` sits at 1 with no way to bring it down for the rest of the run.

### 2d. `up_candidates` — NO GUARD AT ALL, AND IT IS A BALANCE FAULT

`_pick_upgrade` indexed the stored offer and appended it, with no check of any kind. **AP's
ONCE-PER-RUN rule has exactly one enforcement point and it is the ROLL's `has_upgrade` filter.**

| | |
|---|---|
| two queued triples share an upgrade ID (breaks once-per-run) | **376 / 400** |
| two queued triples share the SAME (ability, upgrade) PAIR | **247 / 400** |

**AND `_stamp_upgrade` IS NOT IDEMPOTENT FOR SIX OF THE EIGHT.** Measured on abilities the two
queues actually offer:

| Upgrade | Field | raw → once → **twice** |
|---|---|---|
| Honed (`up_damage`) | `damage * 1.5` | 25 → 38 → **57** |
| Weighted (`up_break`) | `pressure *= 2` | 25 → 50 → **100** |
| Quickened (`up_cooldown`) | `-2 turns` | 3 → 1 → **0** |
| Widened (`up_wide`) | `+1 hit` | 6 → 7 → **8** bolts |
| Piercing (`up_pierce`) | `+0.5`, capped | 0.00 → 0.50 → **1.00** (full) |
| Swift (`up_speed`) | `* 0.75` | 3.00 → 2.25 → **1.6875** |
| Effortless (`up_free`) | `cost = 0` | **idempotent** |
| Certain (`up_certain`) | `chance = 1.0` | **idempotent** |

A duplicate here is not a cosmetic repeat — it is a second application of the same multiplier.
Real pairs were reached on **all twelve specs**.

### 2e. THE REPAIR IS FD'S REPAIR, TWICE, AND NEITHER IS A REROLL

`Run.ability_choice(member)` and `Run.upgrade_choice(member)` each take the head of the queue, drop
only what is no longer legal, top back up **through the same door the roll uses**, and **write the
repair back**. Both call sites — the overlay's render and the handler — come through them, which is
what keeps a button's index and the handler's index the same offer. **A queue with nothing wrong
with it is returned untouched**, which is BATCH X's no-reroll rule and is asserted on both.

- **`ability_choice` PRESERVES THE THREE-TIER CASCADE RATHER THAN FLATTENING IT.**
  `award_ability_pick` reads the spec draft pool only when the BOSS pool is empty and the class
  pool only when both are. A top-up that walked all three would hand a hero a draft-pool card while
  his boss pool still held one — a different offer from the one the roll would make today. **So a
  repaired triple can be SHORTER than three, and that is correct**, on `roll_upgrade_offer`'s own
  stated principle: *the picker shows what exists rather than padding*. For the Inquisitor at his
  third deferred pick, tier 1 is empty and the top-up comes out of his 11-card spec draft pool —
  **the stranded pick becomes answerable.**
- **`upgrade_choice` DOES NOT RE-ASK THE PAIRED ABILITY, DELIBERATELY.** An entry names an
  `ability` as well as an `id`, and a hero can BENCH that ability between the roll and the answer.
  `apply_upgrades` skips such an entry **in silence** and its own header says that is not an error —
  the card stays in the pool and the upgrade returns with it. Dropping the candidate would destroy
  a pick over a reversible state, so the pairing stands and only the once-per-run rule is enforced.
- **`_pick_ability`'s OLD GUARD IS REMOVED RATHER THAN LEFT BESIDE THE NEW ONE**, and `check_fe`
  §2 asserts its absence — a refuse-and-return sitting behind a repair would go on drawing the dead
  button it drew before.

---

## §3 — WHAT IS DELIBERATELY NOT DONE

- **The Peddler's ability draft stays withdrawn** (FD §1e, BO §3, ruled by the designer).
- **The Shared Ruin's magnitude stands** at ×2.67 on detonations, to be judged in play.
- **No card's tags move.** FD's 54 are done and Feint's `["OFFENSE", "MARK"]` stands; `check_fe` §1
  asserts the card table from this side as its positive arm.
- **No new rune is authored.** Eight specs and the class runes are still unwritten.
- **`_stamp_upgrade` IS NOT MADE IDEMPOTENT.** It would be a second way to reach the same
  guarantee, and the guard belongs at the answer with the rest of the idiom. `check_fe` §2c asserts
  the stack IS still real, so the day that changes the gate says the guard has become
  belt-and-braces.

---

## §4 — VERIFICATION

### THE ORDERING RULE PAID, AND THIS TIME IT PAID BY RETURNING NOTHING

HEAD's unmodified gates were run against the new code **before a single gate was edited** (FA §1b).
**Six reds across two targets, and every one predicted**: `check_fd` §2's `rune_break.size() == 5`
reading 0 — **the pin FD placed for the day this was ruled on, doing exactly its job** — plus
`check_de` noticing that gate had gone redder, and `check_cm_live`'s four recorded ones. **Nothing
unpredicted**, where FD's own first run returned two. That is a weaker result for the rule than
FD's and it is recorded as such: the rule earns its place on the batches where it bites, and this
was not one of them.

`check_fd` §2's pin was then **re-pointed in place, with its reason**, from `== 5` to `is_empty()` —
one `ok()` out and one in, so its count is unchanged at 87. `check_fe` §1 owns the population and
the retention; that arm stays deliberately narrow, on the one claim FD's own section made.

### SIX NEGATIVE CONTROLS, EACH DISCRIMINATING — AND ONE READ GREEN ON ITS FIRST ARMING

| Control | Result |
|---|---|
| `ability_choice` neutered to HEAD's behaviour | **6 reds** |
| `upgrade_choice` neutered to HEAD's behaviour | **3 reds** |
| **`ability_choice` turned into a REROLL** (survivors discarded) | **exactly 3** — the three no-reroll arms and nothing else |
| one rune row restored to BREAK-first (`long_watch`) | **3 in `check_fe`, 1 in `check_fd`** |
| **`_pick_ability`'s old refuse-and-return restored** | **6 reds**, including the stranded pick reproduced through the real screen: *"1 picks are still owed after three were answered"* |
| a caller added for `rune_tag_line` | **exactly 1**, the arm it aims at |

**§2c's THIRD ARM READ GREEN ON ITS FIRST ARMING, AND THE REASON GENERALISES.** It asserted that
two queued upgrade picks answered in sequence never write one id twice — but two *real* queued
offers share an (ability, upgrade) pair in only **247 of 400** trials, so on a fixed seed the arm
was a coin flip, and against a fully neutered `upgrade_choice` it caught **one** failure of the
three it aims at. **Re-armed by CONSTRUCTING the collision** — the second queued offer is made a
copy of the first, a state the game reaches in roughly five runs in eight — it bit all three. **An
assertion that waits for a 62%-likely state is not an assertion.**

**Every control file was restored from a pre-control copy and `md5`-verified identical** across all
five files.

### THE INSTRUMENT'S OWN TWO FAULTS, BOTH FOUND BY RUNNING IT

- **§2d FIRST READ RED BECAUSE IT WALKED THE WHOLE SCREEN FOR BUTTONS.** The map screen is covered
  in buttons of its own — map nodes, hero cards — so `_button_labels(screen, …)` read one of those
  as an offer and pressed it. It is scoped to the overlay's own `z_index = 60` Control now, and
  queue-freed overlays are skipped rather than counted, because a freed node is still in the tree
  for a frame.
- **THE GATE'S PINS WERE INVISIBLE TO THE MANIFEST, AND IT READ GREEN LIKE A GATE WITH NO PINS.**
  `build_pin_manifest.py` binds a source holder off `var NAME … "res://…"` with `[^\n]*` in the
  middle, so **both** a two-step read (open, then strip into a second variable) **and a wrapped
  call** hide every needle below it. `check_ed` read **18 / 0** through two separate armings before
  the holders were put on one line with their literal; then it went red naming eight unrecorded
  pins, and the manifest was regenerated **after** that reading — **1380 → 1400 pins, 19 added, 0
  removed**, all of them `check_fe`'s.

### THE DOC EDITS' NEEDLE PROOF

Every string literal of four characters or more in every `check_*.gd` and `test_*.gd` — **16,800
needles** — was swept against the before and after copies of all five edited documents. **51 GAINED,
20 LOST, and every one of the 20 is in `docs/state.md`.** That file is asserted on by nothing, and
that is re-derived here rather than inherited: **the pin manifest records 230 pins whose haystack is
one of these documents — 110 in `master.html`, 66 in `CLAUDE.md`, 51 in `changelog.html`, 3 in
`design-notes.md` and ZERO in `state.md` or `docs/reports/`.** Checked the way that matters:
**every one of those 230 pins resolves identically before and after — zero flipped**, in either
direction. This section and the tables above were added to this file after the acceptance run, and
that is safe for the same measured reason.

### THE BATTERY

**95 targets, `sort .ran | uniq -d` ZERO duplicates, 95 names and 95 logs compared both ways, and
0 `Parse Error`, 0 `SCRIPT ERROR`, 0 timeouts across every log** — grepped from the log FILES,
never from a target's own tally.

`check_fe` **79 / 0** (new), `check_fd` **87 / 0**, `check_parse` **169 / 0**, `check_ek` 46 / 0,
`check_ed` 18 / 0, `check_ez` 133 / 0, `check_el` 23 / 0, `check_es` 44 / 0, `check_et` 25 / 0,
`check_eh` 175 / 0, `check_ea` 86 / 0, `test_batch_bo` 1140 / 0, `test_batch_an` 6055 / 0,
`test_runes` 3839 / 0, harness gates **22 / 166 / 8 PASS**, `check_ct_map` 83 / 0.
**`check_de` reads 390 / 0 failures / 0 NOTICES** — every count on its recorded line.

**THE ONLY FOUR `FAIL:` LINES IN THE WHOLE RUN ARE `check_cm_live`'s** — 13 / 4 against a recorded
`fails: [4, 4]`, and **diffed line for line against the same gate's output on the first run:
identical.** The bar on the enemy's attack, its top line naming the incoming blow, and the brace's
two magnitudes. **This batch moved no UI code.**

**THE FREEZE HELD EXACTLY.** An md5 stamp of **344 files, absolute paths, tracked AND untracked**,
before and after over the same path list — **zero differ, and no path added or removed.**

### WHAT MOVED

`scripts/runes.gd` (5 `RUNE_TAGS` rows + the header block), `scripts/run_state.gd`
(`ability_choice`, `upgrade_choice`, two top-up helpers and the idiom's header),
`scripts/map_screen.gd` (four call sites); **`check_fe.gd` is NEW at 79 checks**, `check_fd` §2
re-pointed in place with no count change, `check_ek`'s `TAG_CHECKERS` 6 → 7, `check_parse`
168 → 169; `pin-manifest.json` (1380 → 1400), `baselines.json` (two rows), `run_battery.sh`,
`CLAUDE.md` (**two existing blocks extended rather than a third written**),
`docs/master.html` (**the stamp is bumped to FE — FD left it reading FC**), `docs/changelog.html`,
`docs/design-notes.md`, `docs/state.md` and this file.

**`scripts/battle.gd`, `scripts/classes.gd`, `scripts/talents.gd`, `scripts/unit.gd`,
`scripts/shop_screen.gd`, `scripts/run_sim.gd`, `scripts/events.gd` and `data/runes.json` are
byte-unchanged.**

### TWO THINGS OWED FORWARD

- **`CLAUDE.md` IS AT 284 KiB AGAINST EE §1's 290 KiB CEILING.** This batch added ~4 KiB by
  extending two existing blocks rather than writing a third. **There is roughly one batch of
  headroom left, and the next one to add a block is the one that has to cut.**
- **THREE STALE CLAIMS FD NAMED IN `master.html` ARE STILL THERE**, one paragraph from where this
  batch wrote: *"with the pool empty there is nothing left to price"*, *"the 53 ET retires"* and
  *"Spec coverage: 65 authored runes"* — all superseded at EZ. And the `merchant` glossary entry
  still says the Peddler offers a rune *"to each hero who has a free slot"* when `_roll_offers`
  checks no slot. **Left deliberately**: they are a different mechanism from this batch's, and
  CLAUDE.md's rule is to sweep for the mechanism rather than for the section.
