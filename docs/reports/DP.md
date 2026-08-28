# BATCH DP — THE MADNESS LANE COMES OFF THE DRAW

*Written after the acceptance battery. Every number here was derived from the repo or read off a
battery log; none is quoted from the brief.*

---

## §0 — THREE CLAIMS IN THE BRIEF ARE WRONG AGAINST THE REPO, AND TWO ARE COUNTS

**The brief said "the other eight" and there are six.** `check_do` §4 printed **twelve node/status
pairs across eight NODES**, and the Occultist's four cells account for **six** of the twelve, not
four — `oc_delirium` and `oc_permanent` each read TWO un-guaranteed statuses (Psychosis *and*
Hysteria). Twelve minus six is six. **`docs/state.md` had it right** ("AND SIX MORE PAIRS ARE
PRE-EXISTING") and the brief did not.

**The brief said the ruling is four design decisions; it is four DIFFERENT KINDS of decision.**
Two of the four (`oc_delirium`, `oc_permanent`) needed no new mechanic at all — one needed no code
whatsoever — and the other two needed a helper and a re-entry guard respectively.

**And "confirm … that no rune now duplicates a draft card's grant" confirms the opposite.** Two do.
See §4.

---

## §1 — THE SIX PRE-EXISTING PAIRS, AND FOUR OF THEM ARE NOT BETS

Reported, ruled on nowhere, as instructed. **The finding the brief did not anticipate is that the
instrument over-reports by two thirds**: it matches a rendered WORD, so it cannot distinguish three
different things a node can do with a status name.

| node | spec / lane / row | status | guaranteed applier? |
|---|---|---|---|
| `sm_guarded` Off Balance | Swordmaster / Breaker / 7 | cripple, exposed | **NO — the only real bet in the six.** His core declares `stunned` alone (Pommel Strike). **But the clause is gated on `sm_punish`, a TREE-INTERNAL condition the charter permits**, and sits beside an unconditional "against Broken targets" base clause. **The node cannot go dead; only that clause can.** |
| `sv_virulence` Distillate | Mystic / Venom / 3 | exposed | **YES — the node is its own source.** *"Your Poison applications add +2 extra stacks and apply Exposed for 3 turns."* |
| `ss_exposed_nerve` Exposed Nerve | Sharpshooter / Penetration / 5 | exposed | **YES — the node is its own source.** Clause one applies Exposed on a crit; clause two pays out against Exposed. |
| `ss_no_cover` No Cover | Sharpshooter / Penetration / 6 | dazed, blind | **N/A — read on the HERO, applied by ENEMIES.** It is an IMMUNITY, not a payoff. "Does his spec apply it" is the wrong question. |

Each is carried in `check_dp.KNOWN_PAIRS` **with its reason**, so the next batch reads why a pair
is tolerated rather than re-deriving it. **A pair outside that set is an error; a known pair going
quiet is a notice** — a gate that reds on a repair teaches the next batch to leave the defect
alone.

**One more node was checked by hand and is NOT a bet, though nothing in the sweep says so.**
`oc_torment` (Lingering Torment, Madness 7) reads *"an expiring madness effect"*, which names no
status word — but its read site fires on `["psychosis", "bewitch", "hysteria"]`, and **bewitch is
PROTECTED CORE**, so it works without the draw. The sweep never flagged it because "madness" is not
a status form; it would have been missed by an instrument and found by reading, which is the same
shape as `sm_precision`.

---

## §2 — THE FOUR, AND WHAT EACH ONE READS

**Four cells all reading "stacks of Ruin" would flatten a lane authored as a theme into one idea
with four price tags.** The constraint that produced the spread below was not aesthetic: nearly
every quantity Ruin exposes was **already spoken for**, and finding four unclaimed ones is most of
the design work. **None of the four reads a DETONATION** — Grim Focus (Ruin 5), Unraveling (Ruin 7)
and Avatar of Ruin (Ruin 9) already own that event. `check_dp` §2 asserts the four are distinct.

### `oc_spread` — Spread of Madness (Madness 1) — reads an APPLICATION, probabilistically

> *"Each mark of Ruin the Occultist lands has a 60% chance to leap to another enemy, which catches
> 2 Ruin."*

**It fires on a mark LANDING where Unraveling fires on a DETONATION**, so the lane's two
propagation nodes never read the same event. The spread goes THROUGH `_gain_ruin`, which is the
point — a caught mark arms the threshold, deepens the chip and books the AX depth reading exactly
as a directly-applied one does.

**BOTH PAYLOAD FIELDS WERE KEPT AND THAT WAS THE WHOLE DESIGN CONSTRAINT — see §3.**

### `oc_whispers` — Whispers (Madness 2) — reads that application's MAGNITUDE

> *"Every debuff the Occultist applies marks 4 Ruin instead of the base 2."*

Was: +45 percentage points on Psychosis's 50% seize chance. **The field keeps its `_step` name
because it keeps its SHAPE** — an increase on a base the kit already pays — so its
`Runes.STAT_INT_KEYS` entry stays honest. Only the base moved, from 50% to `OLD_GODS_MARK`.
This is the lever **AY §8** identified as the real constraint: *"THE THRESHOLD WAS NOT THE PROBLEM
— GENERATION WAS."*

### `oc_delirium` — Delirium (Madness 5) — reads an EVENT, and not one line of code changed

> *"When an enemy strikes a fellow, the victim is marked with 3 Ruin."*

**The bet was three words of prose over a correct implementation.** Its text named Psychotic and
Hysterical enemies; **its read site names no status and never has** —
`not attacker.is_hero and not strike_target.is_hero`, with the code's own comment explaining that
every enemy-on-enemy strike is madness-driven by construction.

**It was deliberately NOT narrowed to "Bewitched", which was the obvious minimal edit.** That would
UNDER-state the payload the moment Mind Flay is drafted — DM's seventh family — and *an absent
clause does not mis-say*, so no test in the project would ever catch it. **The cheapest correct
edit and the smallest edit were not the same edit.** It takes `oc_cackling`'s words, one row down,
because the same trigger deserves the same sentence.

### `oc_permanent` → **Ruined Mind** (Madness 8, renamed) — reads the STACK COUNT as a threshold

> *"A boss bearing 10 or more Ruin can no longer resist the Occultist's Bewitchment."*

Was: Psychosis, Bewitchment and Hysteria never expire — **two thirds of it a bet**. The row-8 rule
is *read an accumulated quantity, REMOVE a constraint the lane has worked around all game, or
convert the lane's currency*. This does the middle one against the constraint stated in the lane's
own header: **every effect in the Madness lane is refused by a boss until it is Broken.**

**IT IS SELF-ENABLING BY CONSTRUCTION AND NOTHING HAD TO BE ADDED TO MAKE THAT TRUE.** The boss
refuses the charm inside `_apply_status`, but the `bewitch` handler calls `_gain_ruin` **on the very
next line, regardless** — so a REFUSED cast still deepens the mark that eventually opens the gate.

**Scoped to `bewitch` alone, matching the text word for word.** Widening it to Psychosis and
Hysteria would be a BONUS rather than a bet (Bewitch carries the node on its own) — but a clause
the text does not state is the seventh family again, so it is a decision, not a freebie. **Owed,
not taken.**

**RENAMED because the old name described the old mechanic.** No ability in the 216-card corpus is
called "Ruined Mind", so DP adds no sixth node-named-after-a-live-ability to DN's five.

---

## §3 — THE COST THE BRIEF DID NOT NAME: A RUNE WRITES TWO OF THESE FIELDS

**The Rune of the Whispering Dark** (100g, `spec:occultist`) writes `spread_ranks` **and**
`spread_ruin`, and its card sells both clauses. **Re-pointing Spread of Madness onto a fresh field
name would have left two of that rune's four clauses paying nothing, in silence** — the exact dud
`battle.gd`'s own rune comment says the schema exists to prevent.

**Both fields were KEPT and their MEANING re-pointed instead.** Cost: one line of card text, no
payload edit, and the rune's +15/+1 keeps its proportion to the node's 60/2.

**The general property is asserted now**, because the next batch to re-point a node will not
remember this one: `check_dp` §4 walks every rune's stat fields and requires a live read site in
`scripts/`, comments stripped — **116 fields across 65 runes, 0 dead.** This is
"cutting a clause means cutting its payload term" read backwards: **a field is a contract with
everything that writes it, not just with the node that named it.**

---

## §4 — THE GRANTS: TWO DUPLICATIONS RESOLVED, AND A STATE THE GAME COULD NOT PREVIOUSLY REACH

**Both duplications are resolved.** `dv_resolve` and `oc_mind_flay` no longer grant; the runes keep
their grants.

**And all four rune grants still resolve — which was not guaranteed.** A rune's grant goes through
`Classes.pending_talent_ability`, **not** through the draft resolver. DO moved twenty-two card
NAMES into `SPEC_DRAFT_POOLS` while the six `grant_ability` DEFINITIONS stayed where they were, and
that is the only reason nothing went dead. **Had a definition moved with its name, its rune would
grant nothing, silently.** `check_dp` §5 asserts this every run.

**But "no rune now duplicates a draft card's grant" is FALSE.** Measured:

| rune | grants | draftable by |
|---|---|---|
| `comet` | Comet | nobody |
| `binding_souls` | Sacred Resolve | **inquisitor** |
| `last_rites` | Resurrection | nobody |
| `flayed_mind` | Mind Flay | **occultist** |

**What happens when a hero holds both — measured, not reasoned.** The grant collides;
`Talents._collided` finds no authored `upgrade` arm and no `no_fallback`, so the rune **owes its
generic**, and `Run.apply_upgrades` — which runs last, after everything that could overwrite it —
turns it into an upgrade on the very card it would have granted:

- **Flayed Mind + drafted Mind Flay → Honed** (`up_damage`, ×1.5 damage)
- **Binding Souls + drafted Sacred Resolve → Quickened** (`up_cooldown`, −2 cooldown)

**So the rune is not wasted.** This is **the Rune of the Last Rites' shipped behaviour since AV** —
Resurrection is in the Holy opening kit, so that rune has ALWAYS collided, and its card says so
outright: *"She already knows Resurrection, so this hones it instead: the rite comes back 2 turns
sooner"* — which is exactly what `up_cooldown` pays.

**OWED AND NOT TAKEN:** Binding Souls and the Flayed Mind both still open **"Grants …"**, which is
wrong whenever the card was drafted. The Last Rites is the model. One line each.

---

## §5 — WHAT IS DELIBERATELY NOT DONE

- **No cell moves row or lane**, so **no migration is needed and `Profile` is still v2** —
  `Talents.cells_spent` prices a cell off the row it CURRENTLY sits in, and DN measured a move
  driving a full Berserker ledger to **−2 available points**, silently, with nothing to refuse,
  clamp or log it. `check_dp` §2 asserts all four cells are in their original lane and row.
- **The 97-node restructure is not taken.** Three-ways-playable remains separate and undecided.
- **`sm_lunge` is not restored.** It left the tree at DO; `sm_precision` was re-pointed onto
  Stunned, which Pommel Strike applies.
- **The six pre-existing pairs are reported and ruled on nowhere.**
- **No magnitude was derived by measurement.** Spread keeps 60/2, Delirium keeps 3, and Whispers's
  +2 doubles a base of 2 as its old +45 nearly doubled a base of 50. **Spread and Whispers BOTH
  feed generation and a player can hold both** — rows 1 and 2 of one lane — which is the number
  most worth a sim. **No sim has run since DK**, so every sim figure in `docs/state.md` was already
  stale before this batch touched anything.

---

## §6 — VERIFICATION

**Two batteries, both on a frozen tree. 156 files were MD5-stamped before EACH run and re-compared
after; not one moved in either.**

| | DO's acceptance | DP battery 1 | DP battery 2 (acceptance) |
|---|---|---|---|
| suite failures | 0 | **0** | **0** |
| throws | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| `check_di` | 0 | **1** | **0** |
| check counts outside band | 0 | 0 | **0** |
| `check_de` | 297 / 0 / 0 | 297 / 2 / 0 | **301 / 0 / 0** |
| manifest targets | 72 | 73 | **73** |

**0 `Parse Error` and 0 `SCRIPT ERROR` in every log, both runs**, grepped from stderr rather than
read off a tally or an exit code.

### The prediction, and the one movement it missed

| target | predicted | actual |
|---|---|---|
| `check_dp` | new row, 43 / 0 | **43 / 0** ✓ |
| `check_de` | 297 → 301 | **301** ✓ |
| manifest | 72 → 73 | **73** ✓ |
| `test_batch_ax` | unmoved at 348 | **348** ✓ |
| `test_batch_bj` | unmoved at 67 | **67** ✓ |
| `check_di` | unmoved | **0 → 1 — MISSED** |

**The miss is the interesting one.** The re-pointed Spread of Madness **deleted** an
`_apply_status` call site — `_apply_status(infected, "psychosis", 3)` — and it was an **unstamped**
one, so `src` coverage went 106-of-204 to **106-of-203** and improved without a single `src` being
added. `check_di`'s `CALL_SITES` equality caught it. **That equality is the one assertion in
`check_di` that is a number rather than a property, and it earned its keep**: its sibling
`SRC_FLOOR` is deliberately a ratchet because that one measures *progress*, while this one measures
*the ground the progress is against*. It moved to 203 with the reason written into the const's own
comment.

### Nine negative controls, and all nine behaved

| control | failures | what it proves |
|---|---|---|
| `oc_spread`'s old text restored | 5 | §1 catches a re-introduced bet |
| `oc_whispers`'s old text restored | 5 | ditto |
| `oc_delirium`'s old text restored | 6 | ditto, two statuses |
| `oc_permanent`'s old text restored | 6 | ditto, two statuses |
| Ruined Mind's read site defeated | 3 | §3's read-site needles bite |
| the Whispering Dark's `spread_ruin` renamed | 5 | §4 catches a rune left paying nothing |
| a sixth `_gain_ruin` quoting `OLD_GODS_MARK` | 3 | §3's helper property bites |
| `permanent_delusion` added **as a comment** | **0** | **comments ARE stripped** |
| `permanent_delusion` added **as code** | **3** | **and the sweep still catches real code** |

**The last two are one control run from both sides, and that is DO's scar repeated on purpose.**
Prose recording a removal necessarily NAMES what was removed, so a bare substring search cannot
tell a record of a cut from the cut not having happened — DO's third control found exactly that. A
one-sided control proves only half of it: strip too eagerly and the gate goes blind. **Every probed
file was restored from a scratchpad copy and re-compared by MD5, never `git checkout`.**

### The literal sweep

**10,518 literals at a floor of 4**, from all 75 suites and gates, evaluated against **both** the
`git show HEAD` and working versions of fourteen documents in one pass.

- **16 LOST pairs, all accounted for** — the four removed read sites, the retired
  `permanent_delusion`, and the words the card texts stopped using (`newly maddened`, `Psychotic`,
  `Hysterical`, `Psychosis`, `spreads`).
- **100 GAINED pairs, and the dangerous kind is ZERO**: all **225** negative `contains` assertions
  in the tree were cross-checked against every gained literal and **none collides**.
- **The sweep found the one real risk before the battery did.** `test_batch_ba` §1 bans the words
  *"spreads"* and *"leaps"* from node text, to keep a retired contagion design reserved — and the
  new Spread of Madness text says "leap to another enemy". **It scopes to the Mystic tree, not the
  Occultist's**, so it is out of reach; `ba` read 690 / 0. Without the sweep this would have been
  found by a battery rather than by reading.

### The three flakes

`test_batch_at`'s unseeded §1 ratio (467), `bo`'s §5 NULL FIELD flake (1064) and
`test_rune_battle`'s pierce (97) were quiet in **both** DP runs — the **twelfth** consecutive quiet
reading. **All three are still open, still unseeded and still banded.** At about one red in
eighteen, twelve quiet readings is the common case and proves nothing. **A red from any of them is
not the next batch's.**
