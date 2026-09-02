# BATCH EK — ARCHETYPE TAGS

**A shared vocabulary that names what a card is FOR, carried by every ability in the corpus and
every authored rune, and shown to the player on the draft card. Mechanically inert as shipped.**

**THE VOCABULARY WAS MEASURED OUT OF THE CORPUS RATHER THAN PROPOSED, AND THE MEASUREMENT
OVERTURNED THE BRIEF'S OWN EXAMPLE.** The brief named a status vocabulary in passing — *"the
Pyromancer's Fireball is a Burn card"* — and then ruled that the distribution decides the set.
**The distribution does not support six status names**: they reach 40 of the 154 draft cards and
leave 114 with nothing, and the brief's own test says a large remainder means the vocabulary is
wrong. The six that shipped are **AFFLICTION · SHELTER · BREAK · METER · AMP · CLOCK**, they cover
**154 of 154**, and the status-family option is priced below so the ruling can be overturned on the
numbers rather than on a preference.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*EI §2's rule: a brief's precedent is a claim, and a claim gets checked.*

| the brief said | re-derived | note |
|---|---|---|
| **154 draft cards** | **true** | 129 spec + 25 class-wide, counted live off the pools |
| **65 runes** | **true** | 5 universal, 12 class-wide, 48 spec |
| **"Nine synergy clauses at DH couple specs through statuses"** | **true** | `CLAUDE.md`'s DH rule and `master.html` §6b both carry the nine, and the coupling is named on every card |
| **"CK taught the draft card to render a computed block"** | **true** | `map_screen._draft_column` calls `Classes.computed_block(ab, 0, res_name)`; the hero sheet is the other caller |
| **"the draft card is the narrow surface at 258px"** | **true** | `DRAFT_COL_W` less the padding; CK measured the column at 557–671px against a 388px viewport |
| **"CK's five added lines already put eight cards over the column"** | **NOT WHAT CK RECORDED** | CK measured **12–14 block lines over three cards** and a column running ~1.5 viewports. Nothing in CK, `CLAUDE.md` or `text-standard.html` says *eight cards*, and no card is CLIPPED — the column scrolls. The cost CK recorded is that a screen built for comparing three cards shows about two |
| **"the Hunter's vocabulary already holds Hunt, Hunter's Mark, Quarry's Mark and Mark of the Hunt"** | **true**, all four resolve | and the sweep found the collisions that mattered somewhere else entirely — see §1b |
| **"a tag names a STATUS or MECHANIC, not an effect type"** | **taken, and the corpus disagreed** | see §1. The set shipped is mechanics; the status set is priced |
| **"EJ found the rune layer's variance mechanism is differential value"** | **true** | `docs/reports/EJ.md` §4: 36 lane runes and 12 splashes are built on *"worth more to a hero whose points went elsewhere"* |

**ONE OF THE NINE DID NOT HOLD**, and it is the layout figure. It is reported rather than acted on,
because the direction it points — *the column is already too full* — is right even though the
number is not.

---

## §1 — THE VOCABULARY, MEASURED

### THE MEASUREMENT THAT DECIDED IT

**Every status and mechanic in the game was counted against the three carriers before a word was
authored.** The result that settles the question is this: **no single status in the game is touched
by more than fourteen of the 154 draft cards** (Burn, the widest, reaches 14; Chilled reaches 9). Grouping them generously into the six biggest
systems — Burn, Frost, Bleed, Poison, Ruin, Mark — still leaves the head of the distribution
almost flat:

| status family | draft cards | protected cores |
|---|---|---|
| BURN | 17 | 6 |
| FROST | 12 | 7 |
| MARK | 9 | 3 |
| BLEED | 6 | 6 |
| RUIN | 6 | 3 |
| POISON | 3 | 3 |
| **covered** | **40 of 154** | **15 of 46** |
| **UNDER NO TAG** | **114** | **31** |

**114 IS LARGE, AND THE BRIEF'S OWN TEST SAYS THAT MAKES THE VOCABULARY WRONG.** But the count is
not the interesting half.

### WHY IT IS STRUCTURAL RATHER THAN A MATTER OF PICKING BETTER WORDS

**A status system in this game belongs to ONE spec, and that is deliberate** — DR's standing rule
is that an engine is exclusive and an axis is shared. So a status tag is **constant inside the only
pool a player is ever choosing from.** Measured over the sixteen pools, a six-status vocabulary
gives:

| | status families | the six shipped |
|---|---|---|
| pools where every card reads the same | **6 of 16** (Cleric, Mage and Warrior class pools, Holy, Inquisitor, Swordmaster) | **0 of 16** |
| distinct tag combinations per pool | **1 to 5**, median 2 | **4 to 9**, median 5.5 |
| draft cards covered | 40 of 154 | **154 of 154** |

The Pyromancer's pool is twelve Burn cards out of thirteen. **A label carried by twelve of the
thirteen cards on offer is not a decision aid.** The tag has to vary where the choice happens, and
a spec's own system never does.

**What varies inside a pool is what a card does to the machinery every hero shares.** That is the
set that shipped.

### THE SIX

| tag | what it means | draft primary | draft either | cores | runes |
|---|---|---|---|---|---|
| **AFFLICTION** | Puts a harmful effect on the enemy, or spends one. | 44 | 51 | 18 / 21 | 17 / 24 |
| **SHELTER** | Answers damage coming in: heals, absorbs or mitigates. | 41 | 49 | 8 / 11 | 25 / 30 |
| **BREAK** | Moves a Break meter. | 32 | 57 | 16 / 32 | 3 / 6 |
| **METER** | Moves a resource or a class meter. | 17 | 43 | 1 / 12 | 9 / 15 |
| **AMP** | Raises what the holder deals. | 13 | 20 | 3 / 4 | 10 / 23 |
| **CLOCK** | Moves the initiative timeline or a cooldown. | 7 | 8 | 0 / 1 | 1 / 8 |

**74 of the 154 draft cards carry a second tag**, and 35 of the 46 cores do.

### THE TEST THE BRIEF SET — DOES HOLDING TWO OF THEM MEAN SOMETHING

**Yes, and it is measured rather than argued.** Under the six, the sixteen pools give **4 to 9
distinct tag combinations against 6 to 13 cards** — so a second card on a tag is notable everywhere,
and no pool is a single colour. Under the status vocabulary six pools give exactly ONE combination:
every card in them reads the same, and a second card on the tag means nothing at all.

### §1b — THE NAME SWEEP, AND TWO RENAMES TAKEN BEFORE SHIPPING

**BR §1 run against every ability, every talent node, every status LABEL and every rune name.**

| candidate | ability | talent node | status label | rune | verdict |
|---|---|---|---|---|---|
| AFFLICTION | — | — | — | — | clean |
| BREAK | — | — | — | — | clean |
| METER | — | — | — | — | clean |
| AMP | — | — | — | — | clean |
| ~~WARD~~ | — | — | **`Ward`** | **Rune of the Triage Ward** | **RENAMED → SHELTER** |
| ~~TEMPO~~ | — | **Tempo, Crusader's Tempo, Shattered Tempo** | **`Tempo`** | — | **RENAMED → CLOCK** |

**BOTH RENAMES ARE CJ's IRON WILL PRECEDENT, TAKEN A BATCH EARLIER THAN CJ TOOK IT.** BR §1 says a
label collision ships and is flagged, and that is right for a card meeting a node. **It is not
right for a tag**: a tag and a status chip are rendered on the same screens, in the same
vocabulary, for the same reader — `Ward` means *takes 50% less Break damage*, which is one narrow
thing a SHELTER card might do. CJ paid to rename Iron Will after the collision had shipped.
**Renaming a tag today costs a sweep; renaming it after the runes are keyed onto it costs the rune
layer.**

**CLOCK IS THE GLOSSARY'S OWN WORD** for what it names: *"Turn order is a clock, not a queue."*
**SHELTER IS COINED**, and that is stated rather than buried — every existing word for the idea
(ward, guard, aegis, bulwark, shield) already names something else in this project.

### AND THE ENGINE CHECK THE BRIEF ASKED FOR IS CLEAN — BUT IT IS NOT THE CHECK THAT BOUND

**None of the six is one of DR's ENGINE names** (stance, Loyalty, Focus, Resonance, Ruin, Faith,
Mercy, Burn, Chilled, Frenzy, Block), so an engine and a tag can never collapse into one word.
**Three of the six ARE DR AXIS words** — Break, tempo and meter manipulation are all in DR's axis
list — and that is reported rather than fixed. The brief ruled that a tag is not an effect type
and named the ENGINE list as the thing to check against; the axis overlap is a real observation
about the vocabulary the corpus offered, and **the alternative is the status set that covers a
quarter of the draft.** The designer has both numbers.

### WHAT THE WORD "ARCHETYPE" ALREADY MEANS, WHICH IS THE COLLISION NOBODY ASKED ABOUT

**`Classes.ARCHETYPE_ROLE`, `Classes.ARCHETYPE_DESC` and `master.html` §6 already use ARCHETYPE for
a SPECIALIZATION's role** — Ramp, Rush, Nuker, Pressure, Bruiser, Control, Healer, Warder, Tank,
one per spec, and it decides base Attack. **That is a different thing from a card's tag and they
share a word.** The code side is kept apart deliberately — the constants are `CARD_TAGS` and
`RUNE_TAGS`, not `ARCHETYPE_TAGS` — and `master.html` §6c says outright that the two are
unrelated. **The document-side collision is reported and not resolved**, because renaming the spec
archetypes is a design decision with nine names and a stat table under it.

---

## §2 — EVERY CARD TAGGED, AND HOW

**227 abilities and 65 runes. At most two tags each, the first is the primary.**

### THE READ SITE, AND WHY THE FIELDS ARE USELESS HERE

**CN's rule bites harder on this corpus than anywhere it has been applied.** Over the 154 draft
cards: **`heal` is 0 on all 154**, `bleed_build` is non-zero on **one**, `armor_pierce`,
`lifesteal` and `heal_missing` on **none**, and **123 of the 154 carry a `special`.** A
field-level reading of the draft produces almost nothing, and everything it does produce is wrong
about the cards that matter.

**A CARD'S READ SITE IS FOUR THINGS, AND THE LAST TWO ARE WHERE THE WORK WAS:**

1. its arm in `battle._resolve_special`;
2. **every block keyed on its `display_name` in the hero strike loop** — **58 abilities carry one**,
   133 sites in all, and **Blood Debt's entire payload is one of them**: no `special`, no
   `applies_status`, and an arm extractor returns EMPTY for it;
3. the card-specific helpers those call — **defined as a helper reached from no more than three
   arms**, derived rather than curated, because `_apply_status` names six statuses of its own
   (its interaction rules) and descending into it made every card in the game that applies
   anything read as a `sanctified` card;
4. **for a setup card that resolves nothing at cast, whatever reads the status it lays.** Aegis
   Wall applies `aegis_wall` and does nothing else; its healing is in the BLOCK handler. **Without
   this hop 40 cards read as untagged**; with it, 19 do.

### WHAT THE DERIVATION GOT RIGHT, AND WHERE IT WAS OVERRULED

**The automated reading was taken as the first pass and 109 rows were then hand-read against the
code. 57 of those moved the PRIMARY** — 37 of them in the draft. **They are the judgement calls the
brief asked to see rather than to have decided silently**, and every one is a design decision the
designer can move by editing one row of `Classes.CARD_TAGS`.

**THE PATTERN IN THEM IS ONE THING, AND IT IS WORTH MORE THAN THE LIST**: **29 of the 57 are cards
the derivation could not tag at all** — their payload is entirely deferred, so the card lays a
status and the status pays later, and the remaining 28 are cards where it reached the payoff and
reported every mechanic the payoff touches. **What it cannot do in either case is say which of
them the card is FOR.** Bear the Brunt, Bloodbond, Camouflage, Dug In, Spite, Thick
Hide, Hoarfrost Armor, Null Field, Sacred Resolve, Rite of Return and Intercession are all
mitigation cards that resolve nothing at cast, and all eleven are SHELTER by reading rather than by
derivation.

**THE ARGUABLE ONES, STATED WITH THE ALTERNATIVE** — these are where a designer could reasonably
disagree, and the alternative is not worse:

| card | shipped | the alternative, and why it is arguable |
|---|---|---|
| **Feigned Guard**, **Discipline**, **Formless** | AMP | The Swordmaster's stance cards have no home in the six. They are tagged for what the stance BUYS (his aggressive guard's damage), which is a reading of the payoff rather than of the card. **A seventh tag named for the stance is the honest alternative** and it would carry three cards |
| **Bloodbond**, **Ghostpack**, **Last Howl**, **Succession**, **Call the Wilds** | SHELTER / AMP / CLOCK | **The companion has no home in the six either.** Five Beastmaster cards are tagged for what the companion then does. A PET tag would carry ten |
| **Hunter's Mark**, **Blood Debt**, **Quarry's Mark**, **Reacquire**, **Vendetta**, **Arcane Echo** | AMP / BREAK / METER / AFFLICTION | **A MARK tag would reach 10 of the 154 and 16 of the 227** — these six lay one outright and four more (Call the Wilds, Gut Rip, Rampage, Savage Sweep) reach one through the bleedout path. **The most defensible seventh word in the game**: the marks are a real shared mechanic, currently split across four tags |
| **Anointing** | AFFLICTION | It generates Ruin through the party's attacks; METER is the derivation's answer and DQ's audit calls it METER-GEN. Shipped as AFFLICTION because what it DOES to the enemy is apply Ruin |
| **Immolate**, **Emberkeep** | SHELTER / AFFLICTION | Both are Burn cards by their spec's reading and neither is a Burn APPLIER. Immolate mitigates and burns attackers; Emberkeep changes how Burn lands |
| **Divine Presence** | METER | DQ reads it METER-GEN and so does this; the derivation reached BREAK through a strike-loop block that is not what the card is for |
| **Fault Line** | BREAK | The derivation said METER (it reads the Focus conversion point); DQ says BREAK and the card's whole payload is Break damage |
| **Reprisal**, **Harvest**, **Cull** | BREAK | All three consume something and deal damage; AFFLICTION is arguable for the consuming half |

**THE THREE SPECS WHOSE CORE POINTS ONE WAY AND WHOSE POOL POINTS ANOTHER**, which the brief asked
to have stated:

- **The Warden.** His four cores are 2 AFFLICTION (Mocking Blow, Crushing Blow), 1 BREAK, 1
  SHELTER; **his pool is 3 SHELTER, 3 BREAK, 2 METER, 2 AFFLICTION.** The core says *stop them*,
  the pool says *be paid for stopping them*. Coherent.
- **The Beastmaster.** His six cores are 4 BREAK (the three summons and Quick Shot), 1 AFFLICTION,
  1 AMP; **his pool is 3 BREAK, 3 AMP, 2 SHELTER, 1 AFFLICTION, 1 CLOCK.** The core is the
  companion hitting things and the pool is the companion being improved.
- **The Holy Cleric.** Five cores, **four of them SHELTER**; her pool is 6 SHELTER, 3 METER, 1 BREAK.
  **The tightest agreement in the game** and the one spec where the tag adds least, because every
  card she can draft points the same way. That is a finding about her pool rather than about the
  vocabulary — DQ's audit records the same thing as *6 of 10 bound to Mercy*.

---

## §3 — SHOWN

**The tag line renders on the draft card**, one 11px line under the card's own button and above the
description, in its own tint. Built by `Classes.card_tag_line` — CK §1's one-builder rule, one
layer down, so the second surface that takes tags on cannot draw them a different way.

**DRIVEN LIVE, NOT ASSERTED STATICALLY.** `check_map_screen` builds the real party draft, walks the
drawn tree for Labels whose whole text is a tag line built out of `Classes.TAG_ORDER`, and requires
one per offered card: **12 drawn for 12 offered.** **A vocabulary that renders on nothing passes
every static check in the tree** — DS's Heads Down shape — and that target reports neither a check
count nor a failure count, so it now **withholds its `check_map_screen: OK` verdict on a mismatch**.
That line is pinned as its `expect` field in `baselines.json`, so taking it away is what turns the
report into an assertion `check_de` can read.

### THE LAYOUT COST, MEASURED

**+42px**: one 11px line a card, three cards a column, against a **388px** viewport on a column CK
measured at **557–671px**. Nothing is clipped — it is a `ScrollContainer` with horizontal scrolling
disabled and autowrap on. **The font was not shrunk and the computed block was not truncated.** The
cost is that the column runs a little further past one viewport than it already did, and **that
cost is real**: CK's own note says the screen built for comparing three cards already shows about
two.

### WHERE ELSE THEY SHOULD APPEAR, AND WHAT EACH COSTS — REPORTED, NOT DONE

| surface | cost | recommendation |
|---|---|---|
| **The hero sheet** (`party_screen._draw_detail`) | **One line per ability row.** The sheet already renders the same `computed_block` and has vertical room the draft column does not | **TAKE IT.** It is the one screen where a player reads their whole loadout at once, which is exactly where *"is a build forming"* is answered. Cheapest of the four |
| **The rune offer** (`map_screen._pick_button`) | **One line, and it needs `Runes.rune_tag_line` rather than the card builder.** But that function is the MID-COMBAT tier — CK §1's note says it renders `description` alone BY DESIGN, because it is read in the same breath as a fight | **NOT YET, AND NOT HERE.** It is the surface the tags were built for (EJ's re-key keys runes onto them), but adding a computed line to `_pick_button` breaks the tier split CK deliberately kept. **It wants its own rune-offer surface, which is the rune batch's work** |
| **The battle tooltip** (`battle._ability_tooltip`) | One line, and it is the THIRD COPY CK deliberately did not fold in — it reads a live `BattleUnit` | **NO.** A tag is a drafting aid, not a mid-combat one; the player has already chosen. It would add a line to every tooltip in the game for a decision that is over |
| **The blacksmith** (`blacksmith_screen._draw_pairing`) | One line per pairing row | **NO.** The blacksmith upgrades an ability the hero already holds; the tag is not part of that decision |

### THE 44-CHARACTER CEILING — DECIDED AND RECORDED

**A tag line does not count against it, and `text-standard.html` §4.8a now says so.** The reasoning
is §4.8's own: the ceiling exists because an authored line is hand-wrapped with a literal `\n` and
overruns get clipped where the author put the break. **A tag line carries no authored break** — it
is composed at render time from a table of six fixed words into an autowrapping label, which is the
same reason §4.8 already records that `perfect_text` has never been held to the ceiling. **And the
arithmetic says it could not bind anyway: the widest line the table can produce is 20 characters**
(`AFFLICTION · SHELTER`), and the widest one it actually produces is Dispel's, also 20.

---

## §4 — MECHANICALLY INERT, AND THE INERTNESS IS ASSERTED

**No clause reads a tag count. No card's behaviour changes. No magnitude moves.** Not one line of
`battle.gd`, `unit.gd`, `talents.gd`, `run_state.gd`, `run_sim.gd` or `ability.gd` was touched.

**INERTNESS IS THE ONE PROPERTY NOTHING ELSE IN THE TREE WOULD NOTICE LOSING**, so `check_ek` §3
asserts it as a POPULATION rather than as a shape: every `.gd` in the repo is swept
comment-stripped for the ten names in the tag surface, and **the set of files that mention it must
be exactly five** — `classes.gd` and `runes.gd` (the definitions), `map_screen.gd` (the one display
surface), and the two targets that check them. **ZERO is asserted separately in the six files a
mechanic would have to live in**, because *the set is these five* and *`battle.gd` holds none* fail
in different ways and the second is the one that matters. A rule forbidding `if tag ==` would be
blind to every other way of reading one.

**AND THE DISPLAY SURFACE ONLY DISPLAYS**: `map_screen.gd` names `card_tag_line` exactly once and
does not reach past the builder to `CARD_TAGS`, `card_tags(`, `TAG_INFO` or `card_tag_primary`.

---

## §5 — VERIFICATION

### THE INSTRUMENTS, AND WHERE THIS MEASUREMENT COULD HAVE BEEN WRONG

**The comment stripper agrees with EJ's independently**: 665 `#` characters survive stripping in
`battle.gd` and **all 665 are hex colour literals inside strings** — the same figure EJ reported
from a different implementation, which is what licenses using it.

**THE READ-SITE EXTRACTOR WAS WRONG TWICE BEFORE IT WAS RIGHT, AND BOTH FAULTS ARE THIS PROJECT'S
OWN SHAPES:**

1. **A transitive closure that descends into shared machinery reports the machine's couplings as
   the card's.** The first sweep read **`chilled` on 243 abilities and `sanctified` on 119** —
   `_apply_status` names six statuses in its own interaction rules, `_on_enemy_death` names
   `hunt_mark`, and `_gain_resonance` names `threshold_lock`. Every damaging card in the game read
   as a Hunter's-Mark card. **The criterion that fixed it is DERIVED — a helper reached from more
   than three arms is shared machinery — rather than a hand-written exclusion list**, which is the
   thing that would have gone stale.
2. **An arm extractor cannot see a card whose payload is keyed on its NAME.** 58 abilities carry a
   `display_name ==` block in the hero strike loop; **Blood Debt has no `special` at all**, so it
   read as touching nothing. That is *self-flag payloads live at the read site* arriving in a new
   place.

### THE CONTROLS — FIVE ARMED, FIVE BIT, DISARMED GREEN BEFORE AND AFTER

| control | armed on | disarmed | armed |
|---|---|---|---|
| `battle.gd` gains a function reading `Classes.card_tags` | §3's population sweep | 39 / **0** | 39 / **2** |
| a seventh word added to `TAG_ORDER` | §2's vocabulary pin | 39 / **0** | 40 / **4** |
| Pyroblast's row deleted from `CARD_TAGS` | §1's coverage walk | 39 / **0** | 39 / **2** |
| the `Ward` status label renamed `Shelter` | §4's live BR §1 sweep | 39 / **0** | 39 / **1** |
| the draft card's tag label suppressed | **the LIVE draw** | `12 for 12 (OK)` | **`0 for 12 (MISMATCH)`**, and `check_map_screen: OK` disappears |

**THE LIVE CONTROL WAS ARMED TWICE, BECAUSE ONE ARM PROVES LESS THAN IT LOOKS**: rendering a tag
line that contains a word which is not a tag also reads `0 for 12 (MISMATCH)`, so the check is
measuring the VOCABULARY rather than counting labels. And it was re-armed after each, green both
times, with `map_screen.gd` restored from a scratchpad backup rather than by `git checkout`.

### WHAT WAS RUN BEFORE THE BATTERY, AND WHY

**`check_da` §3 CAUGHT THIS GATE ON ITS FIRST STANDALONE RUN, AND THE FIX WAS NOT AN EXEMPTION.**
`check_ek` §1 originally read `Classes.spec_draft_pool` and `Classes.class_draft_pool` to assert
that every DRAFT card carries a tag — which is exactly the fingerprint DA §3 exists to catch, and
it was right to catch it. **The corpus is a superset of the draft, the boss pools and the cores**,
so one walk of `Classes.ability_corpus()` answers all four questions. `WALK_EXEMPT` stays at two,
and `check_da` reads **41 / 0** over 40 gates. `check_do`, `check_dp` and `check_dr` each record
that needing no exemption is better than having one; this is the fourth time.

**`check_ed` WAS RUN AGAINST HEAD's MANIFEST BEFORE THE MANIFEST WAS REGENERATED**, which is the
only order in which it is an instrument rather than a formality. It reported **exactly one
unrecorded pin** — `check_ek.gd`'s `["%s",` — and nothing else. The manifest then went 1335 → 1340
pins, a 62-insertion diff, and `check_ed` reads 18 / 0 against it.

**THE RETIRED-WORD SWEEP WAS RUN OVER THE EDITED DOCUMENTS BEFORE THE BATTERY**, using
`test_batch_bx` §4's `Beastmaster` strip and §4b's `PARTY_IDENTS` strip: **0 *beast* and 0 *party*
in `master.html` and in `glossary.json`.** `bx` reads 161 / 0.

**THE LITERAL SWEEP: 0 LOST, 23 GAINED**, over all **10,868** four-character-plus literals in the
39 gates, 47 suites and both fixtures, counted against nine documents before and after. A
`contains` cannot flip on a gain; **every negative assertion in reach of a tracked document was
enumerated (63 of them) and read**, and none names a literal this batch introduced.

**AND A 30-TARGET SUBSET WAS RUN BEFORE THE FULL BATTERY, WHICH IS WHERE THE ONE RED WAS FOUND.**
The literal sweep and the retired-word sweep were both green and **`test_batch_ce` still went red**:
it pins the glossary at **exactly 97 entries**, and the new `archetype_tags` entry made it 98.
**The pin was BUMPED, NOT LOOSENED** — that is what CV did to it and the comment says why: this
category's test is *one entry per thing a player cannot learn anywhere else*, every entry is a
decision, and the equality exists so that adding one is a decision somebody made. **DX §1's rule
against an equality on a growing collection does not apply, because this collection does not grow
on its own.** `ce` reads 1114 / 0 either way — a bumped literal is not a new assertion.

### PREDICTIONS

| target | reads | predicted | read |
|---|---|---|---|
| `check_ek` | itself | **NEW — 39 / 0**, off three identical standalone readings | **39 / 0** |
| `check_parse` | the battery's own `SUITES`/`GATES` arrays | **158 → 159**, one new target | **159 / 0** |
| `check_ed` | the pin manifest | **1335 → 1340**, one gate added | **18 / 0** |
| `check_da` | the walk fingerprint over 40 gates | **41 / 0** — no new exemption | **41 / 0** |
| `test_batch_ce` | the glossary size | **red until the pin is bumped**, then 1114 / 0 | **1114 / 0** |
| `check_dv` | the changelog `<h2>` count | **pass** — a FLOOR since DW; 30 → 31 | **83 / 0** |
| `check_map_screen` | the drawn draft column | **`OK`, and 12 tag lines for 12 cards** | **OK, 12 / 12** |
| `test_batch_bx` | `master.html`, `glossary.json` | **unchanged at 161** — 0 *beast*, 0 *party* | **161 / 0** |
| everything else | — | **unchanged**: no ability, magnitude, pool, node or constant moved | see the battery |

---

## §6 — WHAT IS DELIBERATELY NOT DONE

- **No clause reads a tag.** Ship the vocabulary, let the designer see it on a card, then build on
  it. Unwinding a wrong vocabulary today costs a table and a label; unwinding it after the rune
  re-key costs the rune layer.
- **No seventh tag for STANCE, PET or MARK**, though the measurement says MARK is the strongest
  candidate at **10 of the 154 draft cards and 16 of the 227**. **Five or six was the ruling and six is what shipped**; the three are
  reported in §2 with the cards they would carry.
- **The spec ARCHETYPE collision is reported, not resolved.** Renaming nine spec archetypes is a
  design decision with a stat table under it.
- **The tags are not on the hero sheet**, which §3 recommends taking and which is the cheapest of
  the four remaining surfaces.
- **No sim, no balance judgement.** Not one magnitude was measured or moved.
- **No rune was re-keyed.** EJ sized that at 59 clauses in 32 runes and it is the batch after this
  one.

---

## §7 — THE BATTERY

**ONE RUN, FROZEN, AND CLEAN ON THE FIRST PASS.**

| | result |
|---|---|
| targets run / named in the manifest / logs on disk | **85 / 85 / 85**, and **0 duplicate names** |
| suite failures | **0** |
| suite throws | **0** |
| `Parse Error` / `SCRIPT ERROR`, grepped from all 85 streams | **0 matching logs** |
| `check_cm_live` (the recorded deliberate red) | 4 |
| `check_ek` | **39 / 0** |
| `check_parse` | **159 / 0** |
| `check_de` | **350 / 0 / 0 notices** |
| `check_map_screen` | **OK**, and **12 tag lines drawn for 12 offered cards** |
| `check_ct_map` | 83 / 0 |
| run harness | 22 / 166 / 8 |
| MD5 drift across 313 tracked files | **ZERO** |

**THE FLOOR WAS RUN THE WAY THE BRIEF SPECIFIES**: `grep -lE 'Parse Error|SCRIPT ERROR'` across the
85 log files, off the streams — never a tally and never an exit code.

**`check_de` READ 350 AND THE +4 OVER EI's 346 IS EXACTLY `check_ek` JOINING THE BATTERY** — that
gate makes four assertions per target. It is stated because **`check_de` has no baseline row of its
own**, so its total moving is reported by nothing.

**ZERO MD5 DRIFT MEANS THE TREE THE BATTERY READ IS THE TREE THAT SHIPS.** 313 files were stamped
with **absolute** paths before the run and re-compared after — a moved working directory between
the two stamps reports the whole tree as drifted, which is how that check goes wrong. `docs/state.md`
and this file were written afterwards; neither is read by anything in the tree, verified by grep.

**ONE RUN WAS ENOUGH BECAUSE THE REDS WERE FOUND BEFORE IT**, which is the half worth keeping:
`check_da` §3 caught the new gate on its first standalone run, `check_ed` caught an unrecorded pin
against HEAD's own manifest, and **a thirty-target subset run caught `test_batch_ce`'s glossary pin
while both sweeps were green**. Three faults, none of them found by the battery.
