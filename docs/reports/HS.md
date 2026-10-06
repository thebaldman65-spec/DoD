# BATCH HS — CONJUNCTIONS: THE MECHANISM, AND ONE OF THEM

**On `class-merge`, from `d85abfa` (HR). IMPLEMENT ONLY.** HR's five rulings are taken (§0), two of them built: **no event
and no bargain-bought merchant in the run's first three nodes**. **`CLAUDE.md`'s two wrong status rules are corrected (§1)**,
the same false sentence is swept out of three other copies, and the derivation over every status claim in the file finds and
corrects a third. **The mechanism (§2)**: two afflictions in `battle.CONJUNCTIONS` meeting on one body become one status
that carries both — components are presence, tier is weight, nothing runs twice, the clock is the shorter ingredient's, a
cleanse takes it whole, a re-applied ingredient runs its own rule. **One ships (§3): Rupture**, Burn + Chilled, tier 2,
its Burn tick carrying Break. **§4** records why one and not five; **§5** makes the combat log the instrument; **§6** shows
the bot making them by accident and not choking.

**VERDICT: SHIPPED.** The acceptance run in the repository — 133 targets in 73 min 46 s, the tree frozen — read `check_de`
549 / 0 / 0, every target at its row and at its pre-pass reading but `test_batch_an`'s unseeded count (6056, inside its band; the pre-pass read 6055); the two sanctioned reds at their counts and
FAIL text; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any log. The tree was byte-identical after it (506
files), and the player's four files are byte-identical to HS's backup. Thirty-three controls, every one red on its arm.
Six rulings are owed, five of them player-visible.

## NEEDS A RULING — SIX; THE FIRST FIVE ARE PLAYER-VISIBLE

1. **RUPTURE'S FIGURE (§3a): 10 BREAK A TICK, PROPOSED — THE DESIGNER TUNES IT FROM PLAY.** One constant,
   `battle.RUPTURE_BREAK_PER_TICK`, pinned in one place (`check_hs` §3a). It was set against HR §4f's clash, about two
   turns of Burn at 9.5 a tick, so a tick pays its Burn and a figure of the same order in Break. **My read**: it is of the
   right order and on the cautious side — a Rupture lives as long as its shorter ingredient, which in play is one to three
   ticks, so 10 a tick is 10–30 Break against a meter of 100, about one strike's worth; it matters most where a Glacial Hold's
   permanent chill lets a long Burn carry it (the sim's end boss carried a 40-turn one, §5). In the sim the Pyromancer party's
   Ruptures added 872 Break over 420 fights and Broke nine enemies. **Not changed.**
2. **§2g, AS BUILT (§2g): EACH INGREDIENT KEEPS ITS OWN CLOCK AND RUNS ITS OWN RULE, AND THE RUPTURE'S CLOCK IS ALWAYS THE
   SHORTER.** This is the brief's lean (the component's own rule), built so *the shorter of the two* holds at every moment
   rather than once at forming. Read literally — the rule applied to ONE composition clock — a second Fireball would carry
   the Chill inside a Rupture past its own end, and a Glacial Hold's permanent chill re-applied would reset a Rupture to
   permanent: an endless Burn and Break. Confirm.
3. **THE SURVIVOR (§2e): WHEN THE SHORTER INGREDIENT RUNS OUT, OR A CARD CONSUMES ONE, THE OTHER STANDS ALONE WITH WHAT IT HAD
   LEFT.** So composing never costs the longer ingredient's tail, which is the additive rule applied to time. The other
   reading ends the composition whole and loses that tail. Confirm.
4. **A CLEANSE TAKES IT WHOLE — AND THE RITUAL CHANTER'S RITE IS THE ONE CLEANSE THIS CHANGES IN SUBSTANCE (§2f).** The rite's
   own rule is *Chilled loses one stack, never the pile* (Batch V), and it is written against the id `chilled`; a Rupture
   is one status with its own id, so the rite lifts it whole — the Burn and every stack of the chill. Confirm, or carve the
   rite to thaw a stack of a Rupture's chill.
5. **IT FORMS ON HEROES TOO (§2b).** The rule says *one body*, and it is built symmetric: an Ashblade's Burn on a hero chilled
   by the Hoarfrost bargain makes a Rupture on the hero, each tick adding Break to the hero's meter. HR §4g found the case
   needs a Scarlands elite or mini-boss under Hoarfrost with an Ashblade in the warband; none was seen in 300 runs. Confirm.
6. **THE WORDS, PROPOSED (§3b, §3c, §5)**: the chip `Ru`; the chip's tooltip built from the ingredients; the glossary's
   *Conjunctions* and *Rupture*; the log's lines (§5 pastes them). **And one collision reported rather than renamed (§3d)**:
   the conjunction's word *tier* is also the talent tree's (*Tier Costs*, *Tier Gates*) and the zones' (*Zones & Tiers*).

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HR | **Held**: HEAD `d85abfa` = `git ls-remote origin class-merge`, the tree clean but the untracked `save-backups/` |
| 2 | *"HR's is the last; the designer has played since"* | **Not so**: the player's four files are byte-identical — md5, size and mtime — to HR's backup (§8a) |
| 3 | HR §4f: the bot casts fire before ice, so chill-then-burn is the rarer clash | **Held**, and measured again (§6): 38 of 40 and 99 of 117 Ruptures formed by a Chill landing on the bot's own Burn |
| 4 | HR §4c: a cancellation would take Firedraw's best case, Overburn's burn-turns, a breadth affliction, Snare Line's chilled target | **Held** (`_other_spec_debuff`, `_total_burn_turns`, `_status_count`, the Snare Line arm) |
| 5 | HR §4h: DR §1 lists Burn and Chilled among exclusives; the recast block says `max()` | **Held**, both (§1) |
| 6 | HR §4f: Burn ADDS its turns, Chilled RESETS its clock | **Held** (`unit.add_status`'s branches), and Poison and Ruin have branches of their own too |
| 7 | HR §4c's breadth readers: the Trapper engine, Hunt, Thick Hide, Salve, Cull, Harvest, Iron Will, Sanctity's events | **Held, and the derived set is larger** (§2c): Overwhelm, Cocktail, Vulture, Loaded Shot, Firedraw's deep case, the field's unique afflictions; two read `DEBUFF_IDS` against `has_status`, which components-as-presence would have over-counted |
| 8 | HR §4c's presence readers (25 named) | **Derived: 99 call sites in 36 functions and card arms** (§2d), 13 of them writes |
| 9 | HR found `dispel_one_debuff` takes the Bleed chip `_cleansable_debuffs` refuses | **Held** (it filters only `broken`) |
| 10 | *"No save version moves: a status on an enemy does not outlive its fight"* | **Held**: `save_run` writes no status; `SAVE_VERSION` stays 15 |
| 11 | WHY BREAK: *"Tithe heals the hero furthest from full off it"* | **Not for a Rupture's tick**: Tithe pays inside the strike loop on a hero's landed blow, and a tick has no attacker (§3a) |
| 12 | *"the Occultist's Madness lane is gated on Broken and his pool has nothing that grinds it"* | **Held**: Decay's two appliers are the Empowered Hex and Lingering Torment fields, both dormant since FX, and the Deepening Ruin rune is retired |
| 13 | *"Bonecracker and Breaking Darkness already amplify it"* | **Breaking Darkness does** — its multiplier sits in `take_hit`'s Break block, which the tick's Break passes through; Bonecracker pays damage against a Broken target, not Break |
| 14 | HR §4f: two turns of Burn at 9.5 a tick | **Held** (HR's table: 2.45 turns at 9.5, party A) |
| 15 | *"HR's widened population (1,019 names in fourteen)"* | **1,026 names in fourteen** at HS (§3d) — `check_hp` §2f's populations, grown by this batch's own two glossary entries and one status |
| 16 | HO §3d: the bot skips what `Classes.draft_ability` does not know — the same shape | **Not met**: nothing the bot reads is keyed by a status id it does not know; it reads `has_status`, which sees a Rupture's ingredients (§6) |
| 17 | *"confirm 131 targets still run"* | **HR's recon figure**: HR's pre-pass and acceptance ran 132; HS's run 133 with `check_hs` |
| 18 | *"HR read 132 targets"* | **Held** |
| 19 | HR §3c: events kept out lift node 4 to 100% | **Held on HS's map** (§0b): 99.7% / 100% at the first trade node |
| 20 | `CLAUDE.md` 417.56 KiB of 470 | **Held** at HR's close (§8) |

## §0 — HR'S FIVE RULINGS

### §0a — THE CAPS: RULED, NOTHING CHANGES
`Run.HERO_HOLD_CAP` 8 and `Run.BAG_CAP` 6 stand; the PROPOSED markers on their comments (`run_state.gd`) and on `check_hr`
§1's two messages come off. A net, not a constraint: eight never fills from what a run hands a hero (HR §1c).

### §0b — NO EVENT IN THE FIRST THREE NODES, BUILT
`Run.GATED_NODE_TYPES` = merchant, blacksmith **and event**, read by the one line in `_assign_node_types`; `Run.shop_gated`
is unchanged (zone 1, columns 1–3). **Recorded with the ruling: the first three nodes now teach combat before they offer
shopping** — fights and elites only. `check_hs` §0a, 80 boards a zone: zone 1's first three columns held **621 fights and
77 elites** and nothing else; **no board short of a kind** (six elites, six smiths, five merchants, five events every
time); later zones keep events in their first columns.

**Re-measured** with HR's own probe (`hr_m3d.gd`, 1,000 maps a policy, the rung-2 opening purse):

| | first trade node at | can pay 150 there (events as the sim plays them / declined) |
|---|---|---|
| HR's gate (three, events free) | node 4 in 43%, 5 in 30% | 86% / 89% |
| **HS (events kept out too)** | **node 4 in 43.2%, 5 in 33.1%, 6 in 10.4%, 7 in 7.3%; none by 7 in 6.0%** | **99.7% / 100%** (greedy 100% / 100%) |

### §0c — THE BARGAIN'S BOUGHT MERCHANT, GATED
`Run.roll_offer` drops the `shop` reward from a severity's list where `shop_gated(slot_idx + 1)` holds. **What the bargain
offers there instead: the same option, paying from what is left of its severity's list** — at severity 4, its 220 gold or a
rune. `check_hs` §0b over 300 offers a column: **0 merchants at columns 1–3; 184 at column 4 and 199 at zone 2's column 2**;
a gated severity-4 option paid gold 293–316 and a rune 284–307 times in 600. On HR's probe the merchant now follows an elite
at nodes 4–7 only (it followed one at node 2 in 8.4% of runs and node 3 in 2.6% at HR).

### §0d — THE WORDS
Accepted as proposed, *held, not worn*; nothing moved.

### §0e — THE CENSUS
Answered by §2: the cancellation is rejected, and its reasons (HR §4c) are recorded in `CLAUDE.md`'s conjunction block and
`docs/design-notes.md`.

## §1 — `CLAUDE.md` STATES THE STATUS RULES THE CODE KEEPS

### §1a — THE DR §1 ENGINE LIST
It read *stances, Loyalty, Focus, Resonance, Ruin, Faith, Mercy, Burn, Chilled, Frenzy, Block*. **It names engines, and
Overburn and Glacial Hold are the engines** — Burn and Chilled are statuses a Hunter's Choking Smoke and Downwind, a
Cleric's Returned Burden and an Ashblade all put on bodies. A bullet now says so, and that **Ruin**, the Old Gods' mark, is
the same: Downwind carries it (`_apply_status` copies any `DEBUFF_IDS` status a hero lays, Ruin included).

### §1b — THE RECAST BLOCK
*"`add_status` resolves a re-application as `max()` on duration and power"* is true of the DEFAULT branch only. **Four
statuses have branches of their own**: Burn adds its turns; Chilled adds a stack (cap four) and resets its clock; Poison
adds a stack and resets its clock; Ruin adds a stack and leaves its permanence alone. The refusal's reasoning is untouched —
one `RECAST_GATED` member writes one of the four (Glacial Prison's Chilled) and proposes it only where no Chilled stands.
**Swept as one claim across every copy (EH §2)**: the glossary's *Recasting a Standing Effect* (player-facing), `master.html`
§4.2's recast paragraph and the comment above `battle.gd`'s recast gate said the same, and all three are corrected.
`check_hs` §1 drives the four rules on bodies standing alone.

### §1c — THE DERIVATION: EVERY STATUS CLAIM IN THE FILE
Every line of `CLAUDE.md` naming a status, a status door or a status rule (108 lines matched on the status names and
`add_status`, `tick_statuses`, `DEBUFF_IDS`, cleanse, purge, Dispel, stacks) was read against the code:

| claim | verdict |
|---|---|
| CV §1: `tick_statuses` decrements at the start of a unit's turn | **holds** (the turn loop: the DoT pass, then the clock, then the action) |
| CT §5: Cripple −25%, Hexed −15% battle-long, the two multiply | **holds** (`raw *= 0.75`, `raw *= 0.85`) |
| CO: a negative turn count is permanence | **holds** (`add_status`'s Fleeting guard) |
| DA §2: Glacial Prison guards its own Chilled write | **holds** |
| CP §0: `update_status` assigns power where `add_status` maxes | **holds for the default branch** (Burn maxes too; Chilled and Poison leave power alone) |
| GN: Elemental Weakness and Exposed are read in the strike loop alone | **holds** |
| FT: Momentum's term compounds with Chilled, Slowed, Quick Draw and Wrath | **holds** (`effective_speed`) |
| HF §0: the kits lay Elemental Weakness, a taunt and Sunder, a stun and Poison | **holds** |
| HF: Sunder's depth, floored at zero | **holds** |
| DS §2 / GM §3: an affliction in `DEBUFF_IDS`, a mark in `DISPEL_NEVER` | **holds**, Rupture listed |
| DH: a feeder's status must be in `DEBUFF_IDS` | **holds** |
| **the meter table: Ruin *detonates every 10th stack — Avatar installs 5*** | **stale**: `avatar_ruin` is read and written by nothing since FX; corrected in place |

## §2 — THE MECHANISM

### §2a — THE TABLE
`battle.CONJUNCTIONS := {"rupture": ["burn", "chilled"]}` — the composed id and its unordered pair; one row. The
composed status's words are its `STATUS_INFO` row. Its tier is never written: `BattleUnit.tier_of` counts the ingredients
in the entry. `rupture` is in `DEBUFF_IDS` (a cleanse may take it; a Dispel may not), not in `DOT_STATUSES` (it has no tick
of its own) and not in `DISPEL_NEVER`.

### §2b — COMPOSING
`_apply_status` — the status door, where `src` is known — calls `_conjoin` the moment the arriving status has taken hold
and before any hook copies it onward (Frostbind's mate, a Downwind carry and a Rime echo each meet their own body's
partner through the same line). `BattleUnit.compose` replaces the two entries with one, in the earlier one's place: **one
chip**, its ingredients whole inside it (`parts`). Both orders compose; a pair not in the table (Poison and Burn) stands as
two. Burn and Chilled reach a body only through `_apply_status` (the one variable-id `add_status` call), so no direct write
bypasses it. **Symmetric**: a hero carrying an enemy's Burn and the bargain's Chill composes too (`check_hs` §2f drives it).

### §2c — TIER IS WEIGHT: THE BREADTH READERS, DERIVED
Every reader that counts distinct afflictions, found by walking every `DEBUFF_IDS` read, every `statuses` walk and every
caller of the two counting helpers:

| reader | what it pays | as HR found it | at HS |
|---|---|---|---|
| `_status_count` | the Trapper engine (+8% a status), Hunt, Thick Hide, Overwhelm, Cocktail, Cull's and Harvest's before/after, Vulture, the bot | `DEBUFF_IDS` × `has_status` | **ingredients** — the old form would have counted a Rupture AND both its ingredients, three |
| Salve's field walk (turn start) | a heal per different affliction on the enemies | `DEBUFF_IDS` × `has_status` | **ingredients**, for the same reason |
| `count_debuffs` | the Iron Will talent and its chip | walked `statuses` | **ingredients** |
| `_harvest_yield` | what Harvest and Cull reap, and the bot's bar | walked `statuses` | **a composition's tier** (sticky refuses whole) |
| Harvest's ally share | the bonus for wounds an ally opened | walked `statuses` | **each ingredient's own `src_name`** |
| `_unique_enemy_debuffs` | Pleasure from Pain (dormant: its node and rune are retired) | walked `statuses` | **ingredients** |
| `_other_spec_debuff` | Firedraw's deep draw | walked `statuses` | **ingredients** — the Chilled inside a Rupture is the case its comment names |
| `_loaded_shot_refresh` | resets each affliction to full | walked `statuses` | **each ingredient**, the clock re-derived |
| Sanctity's events | the Hierophant's ledger | per landing / removal | **per ingredient**: forming books the arriving one only; a cleanse books each |

**Driven** (`check_hs` §2c): a Rupture and its unmerged twin both read **2** on `_status_count`, `count_debuffs` and
`_harvest_yield`; the field reads Burn and Chilled, two; and **the Survivalist's own Quick Shot, the same seed into each, paid
19 into a Rupture, 19 into its unmerged twin and 17 into a lone Burn**.

### §2d — COMPONENTS ARE PRESENCE: THE READERS, DERIVED
`has_status`, `get_status`, `status_power`, `status_stacks`, `update_status`, `remove_status` and `set_chilled_stacks` find
an ingredient inside a composition (`_find_status`), and `get_status` returns its own live entry, so a reader that writes
its turns writes the ingredient's. **The derived set: 99 calls on `burn` or `chilled` in 36 functions and card arms, 13 of
them writes** — every one through those seven doors; no game script walks `statuses` for either id outside `unit.gd`.
*(The full table, by function and line, is in the session record; the brief's list is inside it.)* The readers that WRITE:

| writer | what it does to a Rupture |
|---|---|
| Detonation, Pyre Wake, Funeral Pyre (unruned), Cinderfall / Wildfire / Firedraw taking the last turn | `remove_status("burn")`: the Rupture dissolves; the Chill stands alone |
| Cinderfall, Wildfire, Firedraw skimming | `update_status("burn", …, turns)`: the Burn's own clock; the Rupture's re-derives |
| Flamewave on a burning body, Stoke, Backdraft | the same, lengthening |
| a freeze, a release, the rite, Cryoclasm | `set_chilled_stacks`: the pile inside it |

**Positive arms driven** (`check_hs` §2d): the five fire gates (Wildfire, Backdraft, Funeral Pyre, Firedraw, Pyre Wake)
open on a field burning only inside Ruptures, and shut with nothing alight; Overburn's field reads every burn-turn inside
them; Firedraw's deep case finds the Chilled; a live Detonation into a Rupture leaves the Chill standing.

**THE NEGATIVE, DRIVEN HARDEST**: `_dot_pass` — the DoT pass, extracted from `_run_battle` byte for byte so a pass can be
called on a body (BB's and BD's precedent) — on a ruptured Raider and its unmerged twin: **−6 HP and +10 Break, against −6
HP and +0**, the ruptured body's pass logging one tick with its Burn and its Break apart and no plain Burn line; and one slow
(both bodies at the same effective speed). Broken through the live door, the same body's next pass deals its Burn alone
(−6 HP, +0 Break) and logs that no Break landed.

### §2e — THE CLOCK
Each ingredient counts down its own clock in `tick_statuses` (a Slow Burn or a Long Fuse holds the Burn's inside it as it
does alone), and the composition's is derived: the shorter, a permanent one counting as endless. When an ingredient runs out
the composition dissolves (`_dissolve`) and the other goes back on the bar with what it had left. Driven: Burn 2 + Chilled 3
→ a clock of 2, then 1, then the Burn runs out and the Chilled stands alone with its last turn; Chilled 2 + Burn 4 → the Burn
keeps its two; a held Burn inside a Rupture does not count down while the Chill does; a Cryomancer's permanent Chill + Burn 2
→ a clock of 2, and the permanent Chill stands alone after.

### §2f — A CLEANSE TAKES IT WHOLE
`dispel_one_debuff`, `purge_debuffs_taken` and `_cleansable_debuffs` read the top level, so a Rupture is one candidate and
leaves whole; each ingredient books its own Sanctity event, as two chips lifted would; `purge_debuffs_taken` hands it back
whole, and **Returned Burden casts its ingredients**, each to whoever laid it (a bare composed id is never cast). **Does a
cleanse reader need its tier?** Only the two that are PAID for what a purge takes — Harvest and Cull — and both already read
`_status_count` before and after, which counts ingredients; the counts the others print (*cleansed 1 harmful effect*) count
statuses, which is what a cleanse removes. **The one cleanse changed in substance is the Ritual Chanter's rite** (NEEDS A
RULING 4). **A consumer eating one ingredient** dissolves it: the other stands alone, one Sanctity event.

### §2g — A RE-APPLIED INGREDIENT
**What each answer costs.** *The ingredient's own rule*: Burn adds its turns, Chilled adds a stack and resets its clock — the
two rules disagree, so a second Fireball lengthens the Rupture only if the Burn was the shorter, and a second Frostbolt
deepens the chill and restarts its clock; no card goes dead. Its cost here was small — the doors find the ingredient and the
branches run on its entry unchanged, plus a log line — so it is a batch, not a project. *Refusal*: clean to state, but a
second Fireball on a Rupture would do nothing with its Burn, on the target the player had just improved, and the refusal
would need its own door and its own tooltip. **Built: the ingredient's own rule**, with each ingredient keeping its own clock
(NEEDS A RULING 2 says why that differs from one composition clock). A card that writes an ingredient's clock directly is the
same rule and logs the same way. Driven: Burn 2 + Chilled 3, a second Burn 3 → Burn 5, Rupture 3 (the Chill's); a turn, a
second Chill → x2, its clock 3, Rupture 3.

### §2h — NO SAVE VERSION
`save_run` writes the party's member dictionaries, the items, the gold and the map — no unit's statuses — and a quit fight
restarts with every status opened as at any fight's start (GH). `SAVE_VERSION` stays 15.

## §3 — RUPTURE

### §3a — ITS ONE FIGURE, AND WHY BREAK
`RUPTURE_BREAK_PER_TICK` = 10, PROPOSED. The tick is the Burn's, once: the DoT pass deals the Burn's damage (fire resists
apply) and `_dot_tick_rider` adds the Break through `take_hit(0, 10)` — Decay's shape, so every Break-taken term applies
(Breaking Darkness amplifies it, Muffled and Deadened mute it, constitution divides it) and, as Decay's, it is skipped while
the body is Broken — and the log says so (§5). It is credited to whoever made the composition. **Why Break**, as the brief gives it and as checked: it
is the currency the Mage class has no lever for; the Occultist's madness waits on a Broken target and nothing live in his
pool grinds the meter (Decay's appliers are dormant fields); Breaking Darkness amplifies it. **Tithe does not**: its read
site is a hero's landed blow, and Tithe's read site is §7's owed work.

### §3b — THE CHIP
`Ru` — no other status row uses it, and it is not `BD`. Its nearest neighbours are Ruin's `R1`…`R9` (a digit always follows
the R), Rampage's `Rp` and Rime's `Ri`. The tooltip is rebuilt off the ingredients as they stand: *Burn + Chilled, joined
(tier 2). / Each Burn tick also deals 10 Break damage. / Burn: 3 turns / Chilled: 3 turns / Ends when the shorter one would.*
— the figure computed from the constant (CL §1), every line under 44 characters.

### §3c — THE GLOSSARY
`conjunctions` (combat) — the rule, tiers, presence and weight, nothing twice, the shorter clock, a cleanse whole, an
ingredient's own rule, *one is known so far* — and `status_rupture` (statuses) — the recipe; each points at the other, and
**neither carries the figure** (`check_hs` §3c counts digits: none), because the designer is about to move it. The chip's
glossary line resolves. 100 entries (`test_batch_ce`'s pin bumped, not loosened).

### §3d — THE BR §1 SWEEP
Over `check_hp` §2f's fourteen populations — **1,026 names**: *Rupture* is the name of this batch's three entries and of
nothing else, with no near-miss; *Conjunction(s)* only of the glossary entry. **Reported, not renamed: *tier*** near-misses
the glossary's *Tier Costs*, *Tier Gates* and *Zones & Tiers* — the talent tree's tiers and the zones', one more meaning for a
word the player already reads twice. The four designed names were swept too: *Seize* and *Reckoning* clean; *Breach*
near-misses the BREAK tag and the Break nodes by its stem; **_Blight_ is the id of a live status** (Blight the Well's
*Blighted*, chip `Bl`) — found and queued.

### §3e — NO DRAFT LABEL YET
The draft entry naming which conjunction a card touches is load-bearing for the decision the designer wants, but **with
one recipe and four heroes there is nothing to look up** (the brief's reason, recorded in `docs/design-notes.md`). It ships
with the second and third conjunctions — RULED, NOT BUILT (`CLAUDE.md`'s conjunction block).

## §4 — ONE, NOT FIVE

Recorded in `CLAUDE.md`'s conjunction block and `docs/state.md`: *unpriced content ships in the smallest unit that can be
FELT*. **Designed, RULED, NOT BUILT** — with the class pair each needs as designed, and their appliers uncensused:

| conjunction | recipe | the pair | what is owed first |
|---|---|---|---|
| Seize | Chilled + Cripple → the target loses its turn | the Mage's chill, a card that cripples | the Cripple census |
| Breach | Broken + Burn | any class that Breaks, a Burn | the census; **Broken is a meter state, not an applied status** |
| Blight | Poison + Bleed | the Hunter's Poison, the Warrior's Bleed | the census; **the name is a live status id** |
| Reckoning | Ruin + Broken | the Occultist's Ruin, any class that Breaks | the census; Broken as above |

**The census owed**: who lays Cripple, Poison, Bleed, Sunder and Dazed on the enemy side (HR §4a covered Burn, Chilled and
Frozen only). **A tier 3 owes its rule**: it must do something no card can do. The draft label ships with the second and
third.

## §5 — THE LOG IS THE INSTRUMENT

Every conjunction event writes a line, every name off the data (the `STATUS_INFO` row, each ingredient's label):

- **it forms** — `→ Rupture forms on Orc Raider: Beastmaster's Chilled lands on its Burn — tier 2, 2 turns (the Burn's, the
  shorter)`: which two, who landed the second, its tier, its clock and whose clock that is.
- **it ticks** — `Orc Raider's Rupture ticks — the Burn: 6 damage` and `→ Orc Raider's Rupture ticks — the Break: +10 Break
  damage`: the old half and the new half on lines of their own.
- **an ingredient is re-applied** — `→ Arcanist's Burn re-applied inside Orc Raider's Rupture: its own rule — its turns 2 → 4;
  Rupture 3 turns (was 2)`; **a card writes its clock** — `→ Burn inside Orc Raider's Rupture: its turns 3 → 5; Rupture 3 turns`.
- **it ends** — `the clock: its Chilled ran out; Burn stands alone (1 turn)`, `a consumer: its Burn is consumed; Chilled
  stands alone (2 turns)`, `lifted whole (Burn and Chilled)` for a cleanse, `the body died`.

**A whole fight's conjunction log**, out of `check_hs` §5's running fight (one Raider's, formed and re-applied by hand at
the opening and left to the turns as they came):

```
→ Rupture forms on Orc Raider: Beastmaster's Chilled lands on its Burn — tier 2, 2 turns (the Burn's, the shorter)
→ Arcanist's Burn re-applied inside Orc Raider's Rupture: its own rule — its turns 2 → 4; Rupture 3 turns (was 2)
Orc Raider's Rupture ticks — the Burn: 6 damage
→ Orc Raider's Rupture ticks — the Break: +10 Break damage
Orc Raider's Rupture ticks — the Burn: 6 damage
→ Orc Raider's Rupture ticks — the Break: +10 Break damage
Orc Raider's Rupture ticks — the Burn: 6 damage
→ Orc Raider's Rupture ticks — the Break: +10 Break damage
!! Orc Raider BREAKS (Rupture)
→ Rupture ends on Orc Raider — the clock: its Chilled ran out; Burn stands alone (1 turn)
```

**And one the bot made by accident**, out of the sim (§6, party B): the Pyromancer's own Chill landing on
his own Burn, a card lengthening the Burn inside it, the Break meter emptied, and the end by the clock. The 10 a tick goes
through `take_hit`'s Break block, so the body's constitution divides it — +7 on this Withered Warden, +12 and +14 on two
of the sim's Orcs:

```
→ Rupture forms on Withered Warden: Pyromancer's Chilled lands on its Burn — tier 2, 2 turns (the Burn's, the shorter)
Withered Warden's Rupture ticks — the Burn: 13 damage (WEAK!)
→ Withered Warden's Rupture ticks — the Break: +7 Break damage
→ Burn inside Withered Warden's Rupture: its turns 1 → 3; Rupture 2 turns
Withered Warden's Rupture ticks — the Burn: 13 damage (WEAK!)
→ Withered Warden's Rupture ticks — the Break: +7 Break damage
Withered Warden's Rupture ticks — the Burn: 13 damage (WEAK!)
→ Withered Warden's Rupture ticks — the Break: +7 Break damage
!! Withered Warden BREAKS (Rupture)
→ Rupture ends on Withered Warden — the clock: its Chilled ran out; Burn stands alone (1 turn)
```

**And a line the sim showed was missing, added after it**: the end boss's Rupture (a 40-turn Burn under a permanent
chill) ticked with no Break line, because a Broken body takes no Break — Decay's shape — and the log said nothing. A tick
on a Broken body now writes `→ The Hollow Crown's Rupture ticks — the Break: none, while The Hollow Crown is Broken`
(`check_hs` §2 drives it, and control S33 takes it out).

## §6 — THE BOT

**Measured**: the sim with an instrument patch in isolated copies (every Rupture line printed, and every hero cast at a
ruptured target), 15 full runs a party at rung 2, fully talented, HR's two parties.

| | A: Berserker, Cryomancer, Devout, Beastmaster | B: Swordmaster, Pyromancer, Holy, Sharpshooter |
|---|---|---|
| fights | 416 | 420 |
| Ruptures formed | **40 (0.10 a fight)** | **117 (0.28 a fight)** |
| order | Chilled onto Burn 38, Burn onto Chilled 2 | Chilled onto Burn 99, Burn onto Chilled 18 |
| the second lander | the Cryomancer 39, the Beastmaster 1 | the Pyromancer 117 |
| its clock at forming | the Burn's in all 40 (his chill is permanent) | the Burn's 81, the Chill's 9, equal 21, permanent chill 6 |
| ticks a Rupture | 0.10 | 0.72 — 84 Break ticks, 872 Break, 9 enemies Broken by one |
| how it ended | the body died 38, a cleanse 1, the clock 1 | the body died 73, the clock 43, a cleanse 1 |
| an ingredient re-applied | the Chill 76 times, the Burn 4; a card wrote the Burn's clock once | the Chill 67, the Burn 3; written twice |
| hero casts at a ruptured target | 108 | 300 |

**What the bot does when one forms by accident**: nothing different. It is not taught a ladder policy (ruled), and it reads
the board through `has_status`, which sees the ingredients, so its rotation goes on as before — Pommel Strike, Snare Trap,
Powershot, Magic Burst, Glacial Prison and Smite top both lists — and the ruptured enemy mostly dies first. No script error in
either lane; the fight `check_hs` §6 hands it, a Rupture standing from the first turn and the enemies acting, runs to its end.
*(Targets run: §8.)*

## §7 — DELIBERATELY NOT DONE

- **The other four conjunctions, the tier-3 rule's first use, and the draft label** (§4, §3).
- **The applier census for Cripple, Poison, Bleed, Sunder and Dazed.**
- **`master.html`'s seven fire-and-ice disagreements** (HR §4h) and its other stale rows — only the recast sentence was swept
  (§1b), because it is a copy of the rule §1 corrects.
- **The Skirmisher and the Tracker** are still ruled and unbuilt, with Volley's and Ambusher's core slots and both names owed.
- **Channel's tempo payout. Whether a fallen hero stays down between fights. Tithe's read site, and the talent rebalance it
  owes.** No rune is authored; the crest stays at one slot. **`CLAUDE.md` is not split**; the shape recon stays queued.

## §8 — THE VERIFICATION

### §8a — THE SAVES, BEFORE ANYTHING
Backed up first and verified by hash: `../save-backups/HS-20261005-202947`, the four files byte-identical to the live ones
at 20:29:47. **Against HR's backup (`../save-backups/HR-20261005-102217`) nothing moved** — `profile.json` (09:16:35),
`run_save.bin` (10:13:06), `relics.json` and `settings.cfg`, md5, size and mtime all equal. No Godot process was running.

### §8b — HEAD'S GATES AGAINST THE NEW GAME, BEFORE ANY GATE WAS EDITED
**The recon**: HEAD's suites, gates, runner, count table, pin manifest and documents, with HS's four game files laid over
(`scripts/unit.gd`, `scripts/battle.gd`, `scripts/run_state.gd`, `data/glossary.json`), in an isolated copy seeded from
HS's backup — **131 targets, 21:16:16 to 22:29:19, 73 minutes**, the prediction stamped before the launch. **Six read red**
and the count differ named five rows:

| target | read | what it was | disposition |
|---|---|---|---|
| `test_batch_ce` | 930 / 1 | the glossary's pinned 98, now 100 — **predicted** | pin bumped to 100, not loosened |
| `check_fo` | 90 / 1 | §2d: *an ally striking the mark paid 0 Focus, not 5* — the opening blow missed | **a coin flip** (below); spawn made deterministic |
| `check_hk` | 167 / 3 | §3c: the Warrior's full holding walled nothing — the counter dealt him a crest rune | **a coin flip** (below); crest runes held first, one arm added |
| `check_cm_live` | 13 / 4 | the bar on the enemy's attack and the brace | **sanctioned**: the four FAIL lines word for word HR's |
| `check_gj` | 70 / 1 | §4: *the card says +169 gold and the purse moved 189* | **sanctioned**: HR's red (+174 / 194), its figures moved by the dice |
| `check_de` | 545 / 5 | the five rows below | — |

**Two green rows fell**: `check_gp` 469 → 454 and `test_batch_an` 6046, one under its floor of 6047. Nothing else moved:
`check_parse` read HEAD's list green, `check_ed` and `check_ec` HEAD's documents green, both harness gates 22 / 382 / 8.

**THE TWO COIN FLIPS ARE HR §6's SHAPE, AND EACH WAS PROVED TO BE THE DICE BEFORE IT WAS TOUCHED.** HS's map change keeps
events out of zone 1's first three columns, so `_assign_node_types` draws a different sequence and every fresh run is
dealt different dice. A **stub** — HS's game with that one line set back to HR's two trade kinds — read HEAD's `check_fo`
90 / 0 and HEAD's `check_hk` 167 / 0, so nothing else HS changed reached either arm. **`check_gp`'s fall was attributed by
an ok() trace with two stub arms**: HEAD's gate read 469 on HEAD's tree; on HS's tree with the first-nodes gate and the
bargain filter stubbed **and `CONJUNCTIONS` emptied, 469 message for message HEAD's, in order**; with the gate alone stubbed
468 (a conjunction alone moves a fight's dice); on HS's tree 454. Every difference sits in §4's dice-driven families (the
fallback offers and the engine-less OFFERED lines). **`test_batch_an`'s was attributed by four ok() traces a side**: in all
eight runs the count less the fires of §1's per-node `is not a rest` arm is exactly 5,926, so only the number of nodes on
three freshly generated, unseeded maps moves it — and a 400-run node-count probe reads HEAD min 119, median 126, max 132
and HS min 118, median 126, max 133: **drift, not HS**.

### §8c — WHAT WAS RE-POINTED, AND WHY
Every repair is written at its site with its reason (`docs/instrument-rules.md`), and each was run against the copy it was
built for and against the stub:

- **`test_batch_ce`**: the glossary pin 98 → **100** — bumped, not loosened; the pin is an equality on purpose.
- **`check_fo` §2**: the Shared Mark's board is the fixture's **deterministic** seat, so §2d's blow lands: 90 / 0 on HS's
  game and on the stub. **Control**: the Shared Mark's payout cut — **90 / 3** (§2d, §2f, §2g).
- **`check_hk` §3c**: every live crest rune is **held first**, so the counter cannot deal the Warrior one (HR's `check_fh`
  §9b construction), and **a new arm asserts his row is a class rune** — so the full-holding arm asks its question, and the
  day it cannot, it says so. 168 / 0 on both. **Control**: the full-holding wall lifted (`Run.buy_refusal`) — **168 / 3**.
- **`check_hr` §1**: the two cap messages say *RULED at HS §0*; the pins did not move.
- **`run_battery.sh`**: `check_hs` joins GATES — 133 targets.
- **`baselines.json`** (indent 1: four rows moved, one new, three notes): `test_batch_an`'s floor 6047 → **6044**, the measured
  minimum, and only the floor; `check_gp` **[454, 454]**; `check_parse` **207** (one more target); `check_hk` **168**;
  `check_hs` **83**, new; notes on `check_fo`, `test_batch_ce` and `check_hr`, whose counts did not move.
- **One instrument rule written straight into `docs/instrument-rules.md`**: *A STRIKE A/B COMPARES ONE KIND OF BODY* (HS
  §2c) — `check_hs`'s first Trapper comparison set a ruptured Raider against an unmerged Brute, and the armour term between
  two enemy kinds hid the term under test; the index row in `CLAUDE.md` names it.

### §8d — THE CONTROLS
**Thirty-three controls on `check_hs`, one defect each, each in a fresh clone of the final tree with a user-data folder of
its own, every anchor dry-checked before the run, read by FAIL text and never by the count: every one went red on the arm it
aimed at, and none threw** (two lanes, 22:47:30 to 23:00:45 — 13 minutes; 42–46 s a control).

| # | the defect | fails | the FAIL line it was aimed at |
|---|---|---|---|
| S01 | the conjunction never forms (`_conjoin` returns at once) | 28 | §2b: Burn and Chilled met and did not become one entry |
| S02 | the table pairs Burn with Poison instead | 29 | §2b: a pair not in the table composed |
| S03 | components are not presence (the lookup stops at the top level) | 20 | §2d: the ingredients not read as standing; a fire card's gate stayed shut |
| S04 | `_status_count` asks `DEBUFF_IDS` against `has_status` again | 2 | §2c: `_status_count` reads a Rupture as 3; the Trapper paid a Rupture… |
| S05 | `count_debuffs` counts the top level | 1 | §2c: `count_debuffs` reads a Rupture as 1 |
| S06 | `_harvest_yield` pays a Rupture as one | 1 | §2c: `_harvest_yield` reads a Rupture as 1 |
| S07 | the field's unique afflictions read the top level | 1 | §2c: the field's unique afflictions read 3 |
| S08 | the Burn inside a Rupture ticks twice | 1 | §2: …the Burn ticks ONCE |
| S09 | the Break rides no tick | 4 | §2: the Break rode the wrong tick; §5: …0 for its Break |
| S10 | the clock is the LONGER ingredient's | 6 | §2e: Burn 2 and Chilled 3 made a clock of 3 |
| S11 | the shorter runs out and the composition ends whole | 3 | §2e: when the Burn ran out the Chilled did not stand alone |
| S12 | a cleanse takes one ingredient | 2 | §2f: one cleanse took… |
| S13 | a Rupture lifted books one Sanctity event | 1 | §2f: a Rupture lifted booked 1 Sanctity events |
| S14 | Returned Burden casts the composed id bare | 1 | §2f: Returned Burden cast a bare composed status (1) |
| S15 | a re-applied Burn keeps the larger instead of adding | 6 | §2g: …read Burn 3, clock 3; §1: a Burn re-applied did not ADD its turns |
| S16 | an ingredient refuses re-application (the other §2g answer) | 6 | §2g: …read Burn 2; …Chilled re-applied inside a Rupture read x1 |
| S17 | a log line names the composition by a literal | 2 | §5: the log did not read forms, re-applied, ends in that order |
| S18 | events back in the run's first three nodes | 2 | §0a: the first 3 nodes keep out…; zone 1's first 3 columns held… |
| S19 | the bargain's merchant not gated | 1 | §0b: the bargain offered a merchant at the run's first nodes |
| S20 | the bargain's merchant gated everywhere | 1 | §0b: the bargain never offered a merchant from node 4 on |
| S21 | `CLAUDE.md`'s engine list says Burn, Chilled again | 1 | §1a: the engine list still names Burn and Chilled |
| S22 | `CLAUDE.md`'s recast block says `max()` of every status again | 1 | §1b: the recast block still says every re-application resolves as `max()` |
| S23 | Rupture's figure moved (12) | 1 | §3a: Rupture's Break a tick is 12 |
| S24 | the glossary authors the figure | 1 | §3c: the glossary's conjunction entries carry 2 digits |
| S25 | the chip reads `BD` | 1 | §2a: Rupture's chip reads… |
| S26 | Rupture out of `DEBUFF_IDS` | 6 | §2a: Rupture is not an affliction a cleanse takes… |
| S27 | a consumer eating the Burn takes the whole Rupture | 3 | §2f: the Burn eaten out of a Rupture did not leave the Chilled alone |
| S28 | a card writing an ingredient's clock goes unlogged | 1 | §2g: a card writing the Burn's clock inside a Rupture went unlogged |
| S29 | the chill slows twice inside a Rupture | 1 | §2: …once each |
| S30 | a held Burn's clock moves inside a Rupture | 1 | §2e: a held Burn's clock moved inside the Rupture |
| S31 | a permanent ingredient makes the composition permanent | 1 | §2e: a permanent Chilled and a 2-turn Burn made a clock of -1 |
| S32 | the end is never logged (`_dissolve` logs nothing) | 4 | §2e: the clock's end was not logged; §5: …in that order |
| S33 | a Rupture ticking on a Broken body says nothing of its Break | 1 | §2: on a Broken body… its log did not say why no Break landed |

**What the controls found.** A first round of thirty-two, on a copy of the tree taken before the gate was finished, read
31 of 32: **S03 left the fire-gate arm green** — with the lookup stopped at the top level the five gates still read open,
because a third body's lone Burn was standing on the field. The arm now clears every other body first and asserts its premise
(with nothing alight, all five are shut), and S03 reds it. A second round was stopped part-way when the Broken-tick line went
into the code (§5), S33 was added for it, and all thirty-three ran again on the tree as it now stands. **The two repaired
gates have controls of their own** (§8c): the Shared Mark's payout cut reds `check_fo` 90 / 3, and the full-holding wall
lifted reds `check_hk` 168 / 3.

### §8e — THE PRE-PASS AND THE ACCEPTANCE RUN
**The pre-pass**: the finished tree in an isolated copy, **proved equal to the tree file by file** (506 files: 505
byte-identical and `project.godot` differing on its `config/name` line alone), its user data seeded from HS's backup, the
prediction stamped at 23:01:05 and the run launched at once — **133 targets, 23:01:05 to 00:14:54, 73 min 49 s**. It read
`check_de` **549 / 0 / 0**, every target at its predicted row: `check_hs` 83, `check_hk` 168, `check_fo` 90, `check_gp`
454, `check_parse` 207, `test_batch_ce` 930, `test_batch_an` 6055 (inside its band, unseeded); `check_cm_live` 13 / 4 with
the recon's four FAIL lines word for word and `check_gj` 70 / 1 at *+169 gold and the purse moved 189*; the run harness PASS
22 / 382 / 8; and no Parse Error or SCRIPT ERROR line in any of the 133 logs.

**Between the two runs** only the documents moved: the changelog's verification paragraph and this report. The pin
manifest was regenerated after the paragraph and came back byte-identical, and the gates that read the changelog —
`check_fg`, `check_ec`, `check_ed`, `test_batch_bx`, `test_batch_ce`, `test_batch_bb` — read green standalone.

**The acceptance run in the repository**: the repo's own runner, the live user folder, the tree and the player's four files
hashed before and after (absolute paths), the prediction stamped at 00:17:10 — **133 targets, 00:17:10 to 01:30:56,
73 min 46 s**. It read `check_de` **549 / 0 / 0**: every target at its row and at its pre-pass reading but `test_batch_an`'s unseeded
count (6056, inside its band; 6055 in the pre-pass); `check_cm_live` 13 / 4 and `check_gj` 70 / 1 with the same FAIL lines; the
run harness PASS 22 / 382 / 8; and no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any of the 133 logs. **The tree
was byte-identical after it** (506 files — hash, size and mtime), **and the player's four files were byte-identical** —
hash, size and mtime — before and after, and to `../save-backups/HS-20261005-202947`. Nothing was left running: the `ps`
rows were read after the controls and after each run.

**After it**, only `docs/state.md`'s verification line and this report moved. The pin manifest was regenerated and came back
byte-identical, and every gate that opens `docs/state.md` — `check_es`, `check_hp` and `check_fr` — with `check_ed` and
`check_ec` read their rows (57, 171, 25, 18, 24, no failure) in an isolated copy proved equal to the final tree.

## §9 — HOUSEKEEPING AND THE RULES FILE

- **HR's fifty-three isolated copies are in the Trash**, selected by the *"Dawn of Decay HR "* prefix, under *"DoD spent
  user-data folders (Batch HR's fifty-three, cleared at HS 2026-10-05)"*: 53 folders, 11,056 KiB (HR recorded 11,152).
  `app_userdata` went from 520 folders and 154,176 KiB to 467 and 143,120 KiB, HS's own copies in both readings; the older
  folders, the live *Dawn of Decay* folder and `../save-backups/` were not touched.
- **HS's own copies: 17 user-data folders, 8,724 KiB**, every one named *"Dawn of Decay HS …"* — the recon, the pre-pass, the
  needle proof, two control lanes, the sim's two lanes, and the copies that attributed every moved count (HEAD, the stubs and
  the traces). They are HT's to clear by that prefix (HO §5's rule).
- **`CLAUDE.md` is 434,586 B = 424.40 KiB, 45.60 KiB under its 470 KiB ceiling** — +7,000 B at HS (HR left it at 427,586
  B = 417.56 KiB): the conjunction block, the two §1 corrections and their bullets, the first-nodes block's two bullets, the
  meter table's Ruin row and one index row. **About 5.6 batches at the record (EZ's +8,293 B)**, 5.9 at HP's +7,935 B, 6.7
  at HS's own rate. The shape recon stays owed before then.
