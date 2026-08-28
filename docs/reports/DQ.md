# BATCH DQ — DO THE DRAFT POOLS ACTUALLY CONTAIN DIFFERENT BUILDS?

*Written after the acceptance battery. Every number here was derived from the repo or read off a
battery log; none is quoted from the brief. The audit itself is `docs/draft-audit.html`; this is
the batch report.*

**REPORT ONLY. NOT ONE `.gd` FILE WAS TOUCHED.** No card was retired, differentiated, merged or
retuned; no gate was written; no `CLAUDE.md` rule was added. Four documents changed and nothing
else.

---

## §0 — WHAT THE BRIEF ASKED FOR THAT THE REPO ANSWERS DIFFERENTLY

**The brief expected "sustained damage over time" to be a build axis and it is not one.**
Exactly **one** of the 142 draft cards has a damage-over-time effect as its primary payload
(Penance). In this game the DoTs are the *engines* — Burn, Bleed, Poison and Ruin are what the
passives read — so a card that touches one is doing **meter manipulation**, not damage over time.
It appears as a secondary property on 13 cards and as the whole point of one.

**And five axes the brief did not name carry 16 cards between them.** Damage amplification is the
third-largest axis in the game at **12 cards** and is absent from the brief's list entirely;
Break/Pressure (3), death denial (3), cleanse (2) and the companion (3 primary) are the others.
**Mitigation had to be split three ways** — self, one ally, and the whole hero side are three
different cards, and the Devout's pool holds all three.

**The brief's twelfth expectation was right and is the finding:** a pool of nine cards where six
make the same decision has no duplicates in it and still holds one build. **That is what four of
the twelve spec pools look like.**

**One thing the brief did not ask for and the derivation forced:** the pool sizes are not just
uneven, **the unevenness lands on class lines**. See §3.

---

## §1 — TWO GRADE-2 FINDINGS, AND THE STANDING RULE ALREADY FORBIDS BOTH

`classes.gd` carries the rule in its own words — *"NO ABILITY MAY BE A STRICTLY BETTER VERSION OF
ANOTHER IN THE SAME POOL — Batch BD found Deadfall had duplicated Snare Trap for fourteen batches."*
**Both findings below are that rule not being enforced**, so they are correctness rather than taste.
Everything else in this batch is a design question.

### FINDING 1 — GLACIAL PRISON AND FLASH FREEZE ARE ONE CARD AT TWO PRICES

Comments and cosmetics stripped, **both handlers are the same three steps in the same order**:
apply 3 turns of Chilled if the target has none, `_note_debuff_applied`, `_hold_freeze`. Flash
Freeze computes one extra local (`ff_boss`) and **uses it only inside its log string**. The boss
rule both cards advertise lives inside `_hold_freeze` and belongs to neither.

| | Mana | cooldown | initiative | `RECAST_GATED`? |
|---|---|---|---|---|
| **Glacial Prison** | **25** | **4** | **2.5** | **yes** |
| Flash Freeze | 30 | 5 | 3.0 | no |

**Glacial Prison is better on all four columns**, and the fourth is the one that is easy to miss and
is not cosmetic: `RECAST_GATED` is what makes the game *refuse* a cast that would do nothing.
**Flash Freeze can be spent on an enemy already held and the turn is gone.**

**Batch DO created this and nothing else did.** Glacial Prison was a talent grant living in no pool
until DO moved it into the pool Flash Freeze had held since CB. Neither batch was wrong on its own
terms — the collision exists only once both are draftable, which is the whole reason this audit was
scoped to the pools rather than to the cards.

**AND THE SOURCE ALREADY SAYS ALL OF IT, IN A COMMENT WHOSE BOTH REASONS HAVE SINCE BEEN RETIRED.**
This finding was not discovered. It was recorded, deliberately suspended, and left standing while
the two things holding it up were removed by other batches. `classes.gd`, above Flash Freeze:

> *REPORTED, NOT RE-TUNED: on every number this is a strictly worse GLACIAL PRISON (Deep Freeze row
> 4 — 25 Mana, 2.5, 4cd for the same outright freeze). The distinction is the ACQUISITION CHANNEL,
> which is real: the node is a bought cell in ONE lane of ONE tree, so a Winter or Thaw Cryomancer
> can never have it, while this is drafted by any of them. Its PERFECT is what keeps it from being
> dominated outright — see `_hold_freeze`'s `force` argument, which no node buys.*

| the defence | what happened to it |
|---|---|
| **1. The acquisition channel** | **DIED AT DO.** Glacial Prison is a draft card in the Cryomancer's own pool, available whatever lane he allocates. **Deep Freeze row 4 is `cr_numbing` "Numbing Cold"** — the cell the comment points at grants nothing any more, because no node does. |
| **2. The Perfect / the `force` argument** | **DIED AT CR, AND A SUITE PINS IT SHUT.** `test_batch_ax` asserts the absence of `_hold_freeze(target, attacker, true)` with the message *"Flash Freeze no longer FORCES the freeze"*; all four `_hold_freeze` call sites pass two arguments. **And the card carries `perfect_id ""` / `perfect_text ""` with no `is_perfect` branch in its handler — it has no Perfect at all.** |

**The rule was consciously suspended for two stated reasons and both were later removed by batches
that had no cause to look at this card.** That is a more useful finding than "two cards are the
same": **the mechanism that failed is a justification outliving its premises**, which is the same
species as the stale `~96` denominator CD swept and the `53 of 204` figure DJ pinned. **Correcting
the comment is one edit and is owed whatever the designer rules on the cards.**

### FINDING 2 — BATTLE POISE'S ENTIRE PAYLOAD IS A SUBSET OF ANSWERING STEEL'S

**This one would have been invisible to a handler comparison**, because both cards' handlers are one
line — `_apply_status(attacker, <flag>, N)` — and the payload is at the read site. **Twenty-seven of
the 142 draft cards are that shape**, and following their read sites is what found it.

Both fire at the same parry site in `battle.gd`, eleven lines apart, and both call `_tick_cooldowns`
with a constant of **1** (`ANSWERING_TICK` and `BATTLE_POISE_TICK`).

| | Rage | cd | turns | stance required | parry chance | per parry |
|---|---|---|---|---|---|---|
| **Answering Steel** | **20** | 4 | **6** | **none** | **+20%** | **1 turn off every cooldown, +15 Rage** |
| Battle Poise | 25 | 4 | 4 | **Defensive** | — | 1 turn off every cooldown |

**Cheaper, longer, unconditional, and two clauses more — one of which makes its own payoff fire more
often.** There is no board state in which Battle Poise is the better pick.

**The source anticipates the pairing and answers a different question.** Its comment reads *"The two
cards are DELIBERATE STACKING PARTNERS rather than rivals — a single parry held under both takes TWO
turns off everything he holds."* That is a good reason to hold both once you own both. **It is not a
reason for the pool to offer both**: in a three-card offer you take one, and the stacking argument
only starts paying after the domination has already decided the pick.

**This one predates DO** and neither card is one of the twenty-two; no batch moved the pair
together. **The source shows why it was missed, and the reason generalises.** Answering Steel's own
comment names Battle Poise explicitly — *"BATTLE POISE is the deliberate stacking partner rather
than a rival: both pay per parry, so a single turned blade takes TWO turns off every cooldown he
holds."* **The author asked whether the two stack and never asked which of the two you take.**
Those are different questions, and **a three-card offer only ever asks the second one** — the
stacking question does not arise until after a pick Answering Steel always wins.

### AND TWO GRADE-1 PAIRS THAT NEVER COMPETE

**Aimed Volley (Hunter class) and Magic Missiles (Mage class) are the same card** — both are pure
field vectors with zero bespoke code, both are three strikes at one enemy for 12% of Attack each.
**Hoarfrost Armor (Cryomancer) and Immolate (Pyromancer)** are one card wearing two elements: a
4-turn self-mitigation flag that puts the caster's element on anything that strikes them.
**Neither pair is a live collision** — no hero is offered both — and both are reported because a
designer counting how many *different* things the game holds should know the 142 hold fewer than 142
ideas.

---

## §2 — THE ANSWER TO THE QUESTION THAT MATTERS

Two measures, and **they disagree on the Pyromancer, which is itself the finding**:

- **DISTINCT DECISIONS** — how many *(effect axis × target shape)* pairs a pool covers. This is
  "how many cards before the pool stops offering anything new": once a player holds one per
  decision, the rest is variation on what they own.
- **ENGINE-BOUND** — how many cards read or write the spec's own system. A pool can offer ten
  decisions and still hold one build if all ten are made with the same fuel.

| pool | cards | decisions | largest single decision | engine-bound |
|---|---|---|---|---|
| **Swordmaster** | 10 | **4** | 4 × single-target strike | 9 of 10 — stance 7, parry 2 |
| Beastmaster | 8 | 5 | 3 × companion logistics | **8 of 8 — companion** |
| Sharpshooter | 8 | 5 | **4 × single-target strike** | 6 of 8 — Focus |
| Arcanist | 10 | 7 | 3 × gain Resonance | 9 of 10 — Resonance |
| Berserker | 10 | 7 | 3 × single-target strike | 10 of 10 — Frenzy 5, Bleed 4, Rage 1 |
| Cryomancer | 12 | 7 | 3 × area damage | **12 of 12 — hold 6, Chilled 6** |
| Holy Cleric | 10 | 7 | 2 × heal one ally | 6 of 10 — Mercy 5, healing 1 |
| Survivalist | 8 | 7 | 2 × single-target strike | 7 of 8 — statuses 6, traps 1 |
| Devout | 10 | 8 | 2 × grant Faith to allies | 7 of 10 — Faith 5, Divine Shield 2 |
| Occultist | 10 | 9 | 2 × generate Ruin | 7 of 10 — Ruin 6, Break 1 |
| **Warden** | 9 | **9** | **1 — no two cards agree** | 8 of 9 — Block 5, taunt 2 |
| **Pyromancer** | 13 | **10** | 3 × area damage | **12 of 13 — Burn** |
| *class: cleric* | 6 | 5 | 2 × heal one ally | **0 of 6** |
| *class: hunter* | 6 | 6 | 1 | **0 of 6** |
| *class: mage* | 6 | 6 | 1 | **0 of 6** |
| *class: warrior* | 6 | 6 | 1 | **0 of 6** |

**THE MOST CONCENTRATED POOL IN THE GAME IS THE SWORDMASTER'S: TEN CARDS, FOUR DECISIONS.**
Strike one enemy, change or hold a stance, buy tempo off a parry, or execute. **Four cards see all
of it** — and one of the four is Finding 2, so it is really three and a half. His healing, area
damage, control and party buff are all in the Warrior class pool; his own spec pool holds none of
the four.

**THE MOST CONCENTRATED BY ENGINE IS THE BEASTMASTER'S AND IT IS ABSOLUTE: 8 OF 8.**
**Not one card in his pool does anything for the hunter himself** — no mitigation, no heal, no
shield, no control, no Break, no tempo. His whole defensive option set for a run is two of the six
Hunter class cards. **He received none of DO's twenty-two**, so nothing has been added to his pool
since CI.

**THE CRYOMANCER IS 12 OF 12 ON THE ICE, AND NONE OF DO's FOUR OPENED A NEW DECISION.**
Rime spreads Chilled (Rimebinding, Deep Winter and Killing Frost already did), Glacial Prison
freezes (Flash Freeze already did, identically), Cryoclasm relocates a freeze, Shatter cashes the
holds (Winter's Toll already did). **Four cards added, four decisions the pool already had.**

**THE PYROMANCER IS WHERE THE MEASURES DISAGREE AND BOTH READINGS ARE TRUE.** Ten decisions, the
widest in the game — and 12 of 13 read or write Burn, the narrowest binding in the game. Overburn's
multiplier is literally `_total_burn_turns()`, so **five of the thirteen are the same lever on the
passive's own input at five prices**: Ember Debt, Backdraft, Stoke, Slow Burn, Emberkeep. **Ten
things to decide and one currency to decide them in.** Whether that reads as a rich pool or as one
build is a judgement this audit cannot make for the designer, but the ten should not be read as ten
builds.

**THE HEALTHIEST IS THE WARDEN'S: NINE CARDS, NINE DECISIONS — no two make the same one**, the only
pool in the game of which that is true. **The second measure catches what the first misses**: four
of the nine hang off one trigger (a block), and two of those four (Anvil, Recompense) cancel each
other by design and both cards say so.

**AND THE CLASS POOLS ARE THE HEALTHIEST THING IN THE DRAFT.** The authoring rule — *untied and
general, feeds no passive* — is honoured at **0 of 24**: not one class card reads any spec's engine.
Three of the four cover six decisions with six cards, which no spec pool does.

---

## §3 — THE TWENTY-TWO, SEPARATELY

Derived from the `# BATCH DO` markers in `classes.gd` rather than counted by hand. **The spec half
went 96 → 118 and the class half never moved.** `test_batch_cd.PER_SPEC_DEPTH` agrees with the
derivation row for row, which is the independent confirmation.

| class | added | pools now |
|---|---|---|
| **Mage** | **9** | Pyromancer **13**, Cryomancer **12**, Arcanist 10 |
| Cleric | 6 | Holy 10, Devout 10, Occultist 10 |
| Warrior | 5 | Berserker 10, Swordmaster 10, Warden 9 |
| **Hunter** | **0** | Beastmaster **8**, Sharpshooter **8**, Survivalist **8** |

**THE DISTRIBUTION LANDS ON CLASS LINES AND NOBODY ASKED FOR IT.** The deepest pool is **62% deeper
than the shallowest**, and the three shallowest are the three Hunter specs. A Pyromancer's spec draw
spreads over thirteen cards and a Sharpshooter's over eight, so the Pyromancer sees more of the game
per run and repeats himself less — from a change that was never about the draft.

**AND THE HUNTER'S SHALLOWNESS COMPOUNDS WITH SOMETHING ALREADY ON RECORD.** Not one of the
twenty-four Hunter spec cards is a heal, a shield, or damage mitigation for the hero. `docs/state.md`
already carries that **the Sharpshooter has no defensive node in his 27**. **Both halves of his
progression offer him nothing defensive at all**, and the only two cards that can change that are
Field Dressing and Camouflage, from a pool that is one card in four.

### A COOLDOWN OF ZERO MEANS SOMETHING IN THIS GAME, AND TWO OF THE TWENTY-TWO HAVE ONE

**All twelve cooldown-zero abilities in the protected core kits are the hero's free basic attack.**
Nothing else in the game is repeatable every turn. **Of the 142 draft cards, exactly two have no
cooldown, and both are DO's: Pyroblast and Lunge.**

That is not an oversight in DO. **It is the shape of a talent grant arriving intact**: at the end of
a lane the price was the node — nine rows of points — so no cooldown was needed to bound it. In a
pool where every other card pays one, a repeatable card is a different kind of object, and the
player is choosing between two objects that are not the same kind. **Pyroblast is simultaneously the
dearest card in the draft (45), the slowest (6.0, three basic swings), joint-hardest-hitting (55,
half again against a Burning target) and repeatable.**

**THE CHOICE:** price them as draft cards (a retune, therefore the designer's), or rule that a
repeatable card is a legitimate draft shape and write that down. **What should not happen is that it
stays undecided**, because the next batch that adds a card will copy whichever precedent it reads.

### NINE READ-ONLY-ZERO FIELDS WERE RECORDED AT DO AND THERE ARE TEN

DO recorded its nine honestly in `classes.gd`: an `upgrade` arm fires only where a node's grant
collides with an earned copy, no node grants, so `battle_shout_node`, `lunge_upgraded`,
`execute_upgraded`, `hold_line_upgraded`, `rampage_upgraded`, `overcharge_extra`,
`intercession_long`, `resolve_extra_turns` and `bulwark_extra_turns` are read-only-zero. **Leaving
the fields and their read sites standing was the right call and is not the finding.**

**The finding is the tenth.** `icy_resolve_ranks` is read twice — Rime's duration is
`4 + attacker.icy_resolve_ranks`, and the recast-refusal preview quotes the same expression — and
**nothing in the project writes it**: not `talents.gd`, not `runes.gd`, not `relics.gd`, not
`events.gd`. `cr_icy_resolve` still exists and still carries that id, and **DO re-pointed it onto
Blizzard for exactly the right reason**, written into its own comment: *"became a bet on a card the
hero may never be dealt."* The re-point was correct; the field it used to write was left behind.

**Nothing is wrong at runtime** — zero is the base, so Rime lasts its authored 4 turns. It is
reported because it is a dead read of exactly the species DO enumerated as nine, **no gate catches
it** (`test_batch_cd`'s dead-symbol sweep does not reach it, the same way it does not reach
`FIREDRAW_TAKE`), and **the number "nine" will be quoted by the next batch that opens this thread.**

### WHERE THE TWENTY-TWO LANDED ON A SLOT THE POOL ALREADY HAD

**Nine of the twenty-two opened something their pool did not have** — Pyroblast, Firestorm, Magi's
Wrath, Mass Hysteria, Execute, Lunge, Phoenix Rebirth, Cryoclasm and Hold the Line — and **Immolate
is the clearest single win**: nothing in the Pyromancer's pool mitigated damage before it.

The rest landed on covered ground: **Glacial Prison** on Flash Freeze (Finding 1), **Battle Shout**
on Warcry in the class pool it shares an offer with, **Sacred Resolve and Bulwark of Fortitude** on
Vow of Suffering (three party-mitigation cards in a pool of ten, two of them DO's), **Overcharge** as
the fourth "gain Resonance" card in a pool of ten, **Backdraft** as the fifth Burn-lengthener,
**Rime** and **Shatter** on verbs the Cryomancer's pool already had, **Intercession** as the third
card that refuses a blow, and — the three that land on the *protected core* rather than on another
card — **Mind Flay** on Hex of Ruin, **Rampage** on Hack and Slash, **Divine Plea** on Heal.

---

## §4 — THE THREE PLACES A COLLISION HIDES

### 1. CLASS POOL AGAINST SPEC POOL — TWO LIVE, ONE STRUCTURAL

**Battle Shout ↔ Warcry (Berserker).** Both apply a flat damage-percentage status to every hero for
N turns and nothing else; same target shape, same effect type, same cost bracket, and a Berserker is
offered both. Warcry is +20% for 4 turns on cd 5; Battle Shout is +8% for 2 turns on cd 2, scaling
+1% per 20 Bleed buildup across the enemy team. **Battle Shout needs 240 buildup on the board to
match Warcry's magnitude** and still lasts half as long. Not dominated — far more castable — but the
same turn spent on the same thing. **Battle Shout is one of DO's twenty-two**; before DO it lived in
the boss-pick pool and never met Warcry in an offer.

**Drumfire ↔ Aimed Volley (Sharpshooter).** Three strikes at one enemy, no condition, same cooldown,
adjacent cost and initiative. Drumfire's three hits each count separately for Focus, which is a real
spec payoff bought at +5 Mana, +0.5 initiative and −2 Break a shot.

**And the structural one: the Cleric class pool is 3 of 6 healing** (Ministration, Consecration,
Undying Vigil), landing on top of two Cleric spec pools that already heal. **The Devout's sixteen-card
offer space holds six healing cards — the largest single-axis cluster anywhere in the game.** The
Occultist is the one Cleric spec that wants none of them, and for him the class pool is a quarter of
every offer.

### 2. THE PROTECTED CORE KIT — THE CHECK THAT HAD NEVER BEEN RUN

`docs/state.md` has carried *"No spec pool has ever been checked for redundancy against its own base
kit"* as an open item. **It has now been run, and it is the second-largest crop** — because a core
ability can never be dropped, a draft card that duplicates one can never be a meaningful pick.

**The sharpest is KILLING FROST against BLIZZARD.** Blizzard: 30 Mana, cd 4, init 3.5, 15% of Attack
to all, `randi_range(1, 2)` Chilled each. Killing Frost: 20 Mana, cd 3, init 2.0, 20% of Attack, a
flat 2 Chilled each. **Cheaper, faster, shorter cooldown, more damage and more stacks than the
ability the Cryomancer can never drop.** Its one limitation is that it touches only already-Chilled
enemies — and his free basic attack applies Chilled, so after turn one the drafted card is better on
every column. **`_ability_usable` also gates Killing Frost so it cannot be wasted on an unchilled
field, which is a protection Blizzard does not have.**

**Mind Flay against Hex of Ruin** is the same story one spec over: pick N enemies, shadow damage
each, a 3-turn debuff each — and the *core* card is cheaper (20 v 25), faster (2.5 v 3.0) and hits
one more (three v two). The whole difference is Exposed against Psychosis.

**Arcane Bolt, Unmaking and Death Ray are three cards on one decision** and one of the three cannot
be dropped. **Resonance has no maximum**, so Unmaking (10% per stack, ignoring armour *and*
resistances, consuming nothing, 30 Mana) matches Death Ray's flat 150% at 15 stacks and passes it
after — sooner in effect, because it ignores both mitigations.

**Cinderfall against Wildfire** and **Rampage against Hack and Slash** and **Divine Plea against
Heal** are three more of the same shape. **Snare Line against Snare Trap** and **Mantle against
Divine Shield** are widenings rather than repeats and are recorded as such.

**One was checked and is NOT a finding, recorded so the next pass does not re-derive it.** Lunge
against Overpower: same cost, same Break, same Rage build, more than twice the damage, no cooldown
against Overpower's 1 — **but Lunge pays a full extra swing of initiative (3.5 against 2.5)** and
Overpower's damage scales with the target's Break meter. They converge on a Broken target and
diverge on a fresh one, which is a decision.

### 3. THE TALENT NODES — CLEAN ON THE SHAPE THAT MATTERED, DERIVED RATHER THAN ASSUMED

**Thirty-six nodes carry an `"ability"` payload and ZERO of them point at a drafted card.** All
thirty-six name a PROTECTED CORE ability. **DO's re-point was complete on this shape**, and it holds
even where the node's id says otherwise: nine node ids still name a now-drafted ability —
`wd_hold_line`, `bz_rampage`, `cr_shatter`, `ar_overcharge`, `py_firestorm`, `sm_execute`,
`oc_hysteria`, `cr_rime`, `bz_warcry` — and every one of their payloads points elsewhere. Braced
buys Shieldwall, not Hold the Line. Bloodstorm buys Wildstrikes, not Rampage. Shardfall buys Razor
Ice, not Shatter.

**The finding there is smaller and is player-facing.** `docs/state.md` carries five nodes named after
live abilities as a rename question. **Two of the five are harmless** — the "Second Wind" node is
the Berserker's and the card is the Holy Cleric's; the "Spite" node is the Warden's and the card is
the Berserker's, so no hero can hold both. **The other three share a draw space with their namesake
and do something different from it:** a Cryomancer can hold a talent called *Killing Frost* (raises
the held-enemy damage bonus) and a card called *Killing Frost* (hits every Chilled enemy) at the same
time; likewise *Divine Presence* for the Holy Cleric and *Rally* for the Warden. **Renaming the node
ids is a save-format question; renaming their display names is not, and it is one line each.**

**The other direction is not a defect and is reported as scale rather than as a fault.** The
Sharpshooter's is the strongest instance: **six of his eight cards and ten of his twenty-seven nodes
are the same subject** — how to get more Focus and keep it — and neither half of his progression
answers anything else. **Sixteen purchases of one idea, and not a duplicate among them.** The
Cryomancer (four cards, ten nodes on Chilled) and the Occultist (four cards, thirteen nodes on Ruin)
are the same shape. A tree and a pool are *allowed* to serve one theme; it is reported because the
two systems were sized independently and nobody has ever looked at them together.

---

## §5 — WHAT WAS NOT CHECKED

**Stated because an audit that overstates its reach is worse than a narrow one that admits its
edges, and because CJ reported 120 of 120 clean and was later found to have had no check for the
failure mode it missed.**

- **No balance judgement and no simulation.** "Too strong" appears only where it means *strictly
  dominates another card in its own pool*. **No sim has run since DK** and every carried sim figure
  in `docs/state.md` was already stale before this batch.
- **The two Grade-2 findings were confirmed by reading code. The Grade-3 and Grade-4 findings were
  not measured** — they are structural claims about what a card decides, argued from the payload.
  A sim could refute one.
- **The axis vocabulary is this audit's own.** It was derived from the corpus rather than taken from
  the brief, and a different cut would move some cards by one column. **The clusters are robust to
  that; the exact per-pool axis counts are not.**
- **Enemy abilities, relics, runes and items were not compared against draft cards at all.** The
  rune half is a live question — `docs/state.md` already records that two runes grant a card their
  own hero can now draft.
- **The boss-pick pools (`SPEC_POOLS` / `CLASS_POOLS`) were dumped but not audited.** Separate offer,
  separate population, out of scope.
- **`perfect_id` / `perfect_text` bonuses were read but not compared as a population.** Two cards
  could differ only in their Perfect and this audit would call them the same decision — which is
  arguably correct, but it is a choice and it is stated.

---

## §6 — THE BATTERY, AND WHAT CERTIFIED THE DOCUMENTS

**ONE BATTERY, ON A FROZEN TREE, AND IT IS THE ACCEPTANCE RUN BECAUSE IT CAME BACK CLEAN.**
**158 files were MD5-stamped before the run and re-compared after: not one moved.**

| | DP's acceptance | DQ battery 1 (acceptance) |
|---|---|---|
| suite failures | 0 | **0** |
| throws, grepped from the stream | 0 | **0** |
| `check_cm_live` (the deliberate red) | 4 | **4** |
| check counts outside their band | 0 | **0** |
| `check_de` | 301 / 0 / 0 | **301 / 0 / 0** |
| targets in the manifest | 73 | **73** |

**73 targets ran and the manifest names all 73. 0 `Parse Error` and 0 `SCRIPT ERROR` in every log.**
`test_batch_an` read 6055 (band 6046–6063); `test_batch_bk` read 130 (band 129–130); harness gates
22 / 165 / 8; `check_ct_map` 83 / 0. **The same eight targets still report no check count.**

**`check_de` READ 301 AND WAS PREDICTED TO** — four assertions per target and DQ adds no target.
**This is the first batch since DI whose report gets that row right by predicting no change at all**,
which is the correct prediction for a batch that writes no gate.

### THE THREE THINGS THAT WERE WRITTEN AFTER THE RUN, AND HOW EACH IS CERTIFIED

- **`docs/state.md` and this report are read by no suite and no gate**, and `check_de` reads
  neither. That is the allowance DP used and it is stated rather than assumed.
- **`docs/draft-audit.html` is a new file that nothing globs.** No suite or gate walks `docs/`;
  the only directory walks in the tree glob `check_*.gd` and `test_*.gd` at the repo root.
- **`docs/changelog.html` WAS edited after the run, and that one needed proving.** Fourteen suites
  read it — **and all fourteen read only the archive path out of its header**, plus their own
  `<h2>2026-…` needle. **The literal sweep was taken a third time after the edit and diffed against
  the pre-edit reading: 0 LOST and 0 GAINED in every watched document.** A LOST literal is the only
  way a positive assertion could flip and a GAINED one the only way a negative could; both are zero,
  so every `contains` in the tree reads exactly what it read during the battery.

### THE LITERAL SWEEP, ACROSS THE WHOLE BATCH

**10,478 literals at a floor of 4**, from all 75 suites and gates, evaluated against fifteen
documents. **0 LOST** — nothing this batch wrote removed a string any test looks for. **482 GAINED,
all in `docs/changelog.html` (10) and `docs/draft-audit.html` (472)**, and **the dangerous kind is
zero**: all 271 negative `contains` assertions in the tree were located and scoped, and every one
reads `classes.gd`, `talents.gd`, `battle.gd`, `master.html`, `glossary.json`, `runes.json`,
`CLAUDE.md`, `text-standard.html` or `talent-audit.html`. **None reads the changelog's body and none
reads the new document** — `check_dj` says so in its own comment: *"The changelog and the batch
reports are HISTORY and are deliberately not swept."*

**Two needles were checked by hand because a documentation batch is exactly what would trip them:**
`test_batch_cd`'s ban on `"~96"` and on `"9 ARE OWED"`, both scoped to `master.html`, `classes.gd`
and `CLAUDE.md` — **none of which this batch touched** — and `test_batch_bx`'s retired-word sweeps
for *beast* and *party*, scoped to `scripts/*.gd` string literals, the data files and `master.html`.

### NO NEGATIVE CONTROLS, AND THAT IS THE BATCH'S SHAPE RATHER THAN AN OMISSION

**A control proves a check bites. DQ wrote no check.** The two Grade-2 findings were confirmed the
way a report must be — by reading both handlers, both card definitions, all four `_hold_freeze` call
sites, the two stance gates in `_ability_usable`, the `RECAST_GATED` membership, and the suite that
already pins the retired `force` argument shut. **Every claim in `docs/draft-audit.html` names the
file and the mechanism it came from**, so a later batch can refute a specific row rather than the
conclusion.

### WHAT DID NOT MOVE, STATED BECAUSE IT IS THE POINT

**No `.gd` file. `baselines.json` is byte-identical — the first batch since DE to leave it so.**
No `CLAUDE.md` rule, no gate, no `GATES` entry, no baseline row, no `master.html` stamp. **The
parse floor is met by construction**, and the battery is a regression check on the documentation
rather than on the code.
