# BATCH FO — TWO RUNES FN FLAGGED, RULED

**Deepening Hex subtracts 2 from the Ruin threshold instead of setting it to 8, under a floor of
3 that is a ruling rather than an arithmetic consequence. The Wide Watch is retired — kept, and
said to be kept — and the Shared Mark replaces it. The `Overkill` collision is confirmed and ruled
on by nothing.**

**Both runes were worth exactly zero to a hero holding one talent node.** Both now pay every
build, and the two ways that could quietly come back — a composition walking the threshold onto
the floor, and a repair deleting a retired rune's read site — are what `check_fo` exists to catch.

---

## §0 — THE BRIEF'S PREMISES, CHECKED FIRST

**Twenty-two checkable claims. Eighteen held. One held in substance and is wrong as worded, one
is partly sourced elsewhere, and TWO ARE MISATTRIBUTIONS — both of them to FN, and both are
really FK's or CX's.** None of the four changed what had to be built; three changed what could be
written down, and the fourth is the reason §2's headline sentence is not repeated anywhere in
this batch's documents.

| # | Premise | Verdict |
|---|---|---|
| 1 | Both runes were worth exactly zero to a holder of one talent node | **HELD** — `mini(5, 8)` is 5, and `_sharpshooter_focus`'s rune arm sits above the arm Overkill would otherwise reach |
| 2 | FN reported them without retuning, which its brief required | **HELD** — `docs/reports/FN.md` §1: *"ALL THREE ARE DESIGN QUESTIONS AND ALL THREE ARE THE DESIGNER'S"* |
| 3 | FN measured two of the eight as unreachable at a full bar | **HELD** — Heavy Bolts needs four MARK primaries against a pool of three; the Wide Rite is dead at n=5 and n=7 |
| 4 | The spread across the eight is 55x wide at one price | **HELD** — 77.8% (Deepening Hex) against 1.4% (Wide Rite) is 55.6x, and all eight are `"price": 100` |
| 5 | Deepening Hex is `mini(step, 8)` today | **HELD** — `battle.gd`, `_ruin_threshold`, at HEAD |
| 6 | Avatar of Ruin installs 5 | **HELD** — `talents.gd`, `oc_avatar_ruin`, `{"avatar_ruin": 5}` |
| 7 | EZ chose the `mini` so the rune could never make a capstone holder SHALLOWER | **HELD** — the source comment at the site says exactly that, in those words |
| 8 | `check_ez` §5 asserts both directions | **HELD** — three arms: 10 by default, 8 with the rune, 5 with the capstone held |
| 9 | 10 -> 8 without the capstone, 5 -> 3 with it — the same magnitude | **HELD, AND NOW DRIVEN** — §1 |
| 10 | **Wide Watch duplicates the Sharpshooter's Overkill WORD FOR WORD** | **TRUE IN SUBSTANCE, WRONG AS WORDED — and the wording is the half that matters.** See below |
| 11 | The rune sits one `elif` above the arm that clamps | **HELD** — the rune's arm, then `elif attacker.overkill <= 0`, which is what clamps |
| 12 | With the rune held the Overkill log line can never print | **HELD** — an `elif` chain, and the rune's arm is above it |
| 13 | His meter is lost three ways and all three are covered | **HELD, RE-DERIVED** — Overkill on a kill, Metronome on a payout (`metronome: 50`, so `second_resource * 50 / 100` really is a half), Keen Focus on a switch (`second_resource / 2`) |
| 14 | It reads `last_attack_target`, which `_focus_mark` already uses | **HELD** — and `_focus_mark`'s own comment calls it *"the enemy he is already working"* |
| 15 | `_gain_focus` is the only way in, and `battle.gd` says so at the site | **HELD** — the comment above `_pay_sequence_focus`, naming the three readers |
| 16 | Spray of Arrows caps Focus at 50 | **HELD** — `_focus_cap` returns 50 when `spray > 0`, and §2 uses it as an instrument |
| 17 | `docs/spec-recon.html` lists `Overkill` in the Berserker's Warpath lane **at row 7** | **HELD IN PART** — that document names it in the Warpath lane and gives NO row; the row 7 is `talents.gd`'s, for both nodes |
| 18 | FN names a SHARPSHOOTER node by the same word | **HELD** — FN §1's second-gate table, *"Overkill (Penetration row 7)"* |
| 19 | **It is the Crushing Blow shape DR ruled on** | **MISATTRIBUTED** — the shape is CJ/CK's and it was **RULED AT CX**, which renamed the enemy ability. DR ran the BR §1 sweep over 1,127 labels and rejected `Stop Thrust` as a near-miss; it ruled on nothing named Crushing Blow |
| 20 | FN measured the Wide Rite 1.4% -> 100% and Heavy Bolts 2.6% -> 100% | **HELD** — FN §1's earnable-pool means |
| 21 | **FN's sweep found ten exact collisions where a brief named five** | **MISATTRIBUTED — THAT IS FK's.** `docs/changelog.html`: *"THE BR §1 NAME SWEEP RAN ON ALL FORTY AGAINST 708 NAMES ... TEN EXACT COLLISIONS; the brief named five."* **FN ran no name sweep at all** |
| 22 | `Standing Mark`, `Shared Hide`, `Shared Ruin` and `Shared Scent` are all live | **HELD — AND THE SWEEP FOUND FIFTEEN MORE.** §2 |

### PREMISE 10 IS THE ONE THAT CHANGED WHAT COULD BE WRITTEN DOWN

**The two texts share the effect and not the sentence.** The node reads *"the carry keeps your
Focus in FULL rather than dropping it to the usual 50"*; the rune reads *"Focus carries in FULL
through a kill rather than the 50 retained."* **Measured rather than eyeballed: the longest phrase
the two texts share is `rather than`, two words**, and the shared vocabulary is
`50 / focus / full / in / rather / than / the` and nothing else.

**THIS IS NOT PEDANTRY AND IT IS WHY THE RETIREMENT STRING SAYS WHAT IT SAYS.** *"Word for word"*
tells a future author to go looking for a literal duplicate, and there is none to find: **a text
sweep for the node's clause across `data/runes.json` returns ZERO.** What made the rune worth
nothing was the CODE — one `elif` above the arm the node reaches — and only a read of
`_sharpshooter_focus` shows it. **A duplication that is invisible to a string search is exactly
the class FK §7 named on the Standing Ground**, where the name was clean and the CLAUSE was the
base kit. The retirement string therefore records *"authored against a base a node already
provided"* and names the node, rather than claiming a wording that does not exist.

### AND BOTH MISATTRIBUTIONS POINT AT FN

**Premises 19 and 21 both credit FN with work that is CX's and FK's**, and both are the shape
CLAUDE.md already names: *"A brief's account of WHAT a name collides with is a premise like any
other."* Neither cost anything — the METHOD each named is correct and both were run — but a batch
that had taken either on trust would have cited the wrong report in four documents.

---

## §1 — DEEPENING HEX SUBTRACTS 2, UNDER A FLOOR OF 3

**`mini(step, 8)` becomes `maxi(step - 2, RUIN_FLOOR)`.** The payload writes `rune_hex_deepen: 2`
where it wrote `rune_hex_threshold: 8`, and the field is RENAMED rather than re-valued.

| Build | Before | After | The rune is worth |
|---|---|---|---|
| No capstone | 10 -> **8** | 10 -> **8** | **2 stacks** (unchanged) |
| Avatar of Ruin (installs 5) | 5 -> **5** | 5 -> **3** | **0 before, 2 now** |

**Every figure above is DRIVEN, not derived** — `check_fo` §1d reads `_ruin_threshold()` on a live
board at each rung, and §1g walks real stacks onto a real enemy and reads the primer, with the
seventh stack as its control.

### THE FIELD IS RENAMED, AND BOTH DIRECTIONS ARE ASSERTED

**`rune_hex_threshold` holding `2` would have been a name that lies**, and EM's charter is
explicit that *"the field name is the rule."* The rename touches six sites and every one of them
was being edited anyway: `unit.gd`'s declaration, `runes.gd`'s `STAT_INT_KEYS` row, the payload,
the read site, `check_ez` §5 and `check_fn`'s `FIELD` table. **`pin-manifest.json` holds no pin on
either spelling**, which was checked before the rename rather than after.

· **THE SILENT HALF IS THE OLD FIELD SURVIVING, AND `check_fo` §1a ASSERTS ITS ABSENCE.** A
  `rune_hex_threshold` left declared on `BattleUnit` would accept the payload of a saved run and be
  read by nothing — the rune installs, logs nothing and changes nothing. **That is the Standing
  Ground failure arriving through a rename instead of through an author**, and it is the one shape
  a rename can introduce that the rename's own reason cannot see.

### THE FLOOR IS 3, AND THE NUMBER IS THE PART THAT NEEDED DECIDING

**THE BRIEF ASKED FOR THE MINIMUM AND WHY, AND THE WHY IS NOT "SO IT CANNOT REACH ZERO."**

· **WHAT ZERO WOULD ACTUALLY DO.** `_gain_ruin` arms on `st % step == 0` and `_stamp_ruin_chip`
  prints `int(stacks / step)`. Both are DIVISIONS, so a threshold of 0 is a runtime error rather
  than a balance question — **and any floor at all answers that.** A floor chosen to answer only
  that would be 1.
· **WHY NOT 1.** At a threshold of 1 every single stack detonates. That is not a deeper hex; it is
  **a different mechanic wearing the same name** — the detonation stops being a payoff the mark is
  earned toward, and the whole Ruin lane accumulates against a period that no longer exists. 2 is
  the same objection one step along. **A detonation every stack and a detonation every third are
  not the same game**, which is the brief's own sentence and it is right.
· **WHY 3.** **It is the exact bottom of the live tree.** Avatar of Ruin installs 5 and the rune
  subtracts 2, so `maxi(5 - 2, 3)` is 3: the floor changes nothing today, refuses everything below,
  and forces the next batch that wants a shallower period to take that decision on purpose rather
  than inherit it from an arithmetic slide. **`check_fo` §1c asserts all three numbers together**
  — 10, 5 and 2 — because the floor's reason is a RELATION between them, and a floor of 3 under a
  capstone that had moved to 4 would be answering a question nobody was asking.

### AND THE HAZARD THE FLOOR CREATES IS NAMED RATHER THAN LEFT TO BE FOUND

**A subtraction is OPEN at the bottom where the `mini` was CLOSED.** Nothing could compose with
`mini(step, 8)` to push the result below the capstone's own 5. A subtraction composes with
everything: two more effects like this one and the threshold sits on the floor, **and at the floor
Deepening Hex is worth EXACTLY ZERO again — FN's hole, arriving by a new route.**

**THAT IS WHY §1e IS A STRICT INEQUALITY AND NOT A PROPERTY ARM.** The property EZ asserted —
*never shallower* — is kept and restated (`runed <= base`, `both <= cap_only`), because that is
what the brief required and it is still true. **But a property arm alone passes on `mini` again:**
`mini` satisfies *never shallower* perfectly and pays a capstone holder nothing. So the gate also
asserts `runed < base` and `both < cap_only`, and prints the size of the gap. **The day anything
else lowers the threshold onto the floor, that arm goes red and names the rune.**

### `check_ez` §5 IS RE-POINTED, NOT DELETED

Its three arms read 10 / 8 / 5 at HEAD. They read **10 / 8 / 3** now, and the third carries the
same sentence it always did with the arithmetic corrected — *the rune never makes it SHALLOWER* —
plus a fourth arm the `mini` never needed: **the floor, driven.** **A gate that stops asking is
the failure this project has spent forty batches removing**, and the brief is explicit that these
two assertions do not get deleted. They did not.

---

## §2 — THE WIDE WATCH IS RETIRED; THE SHARED MARK REPLACES IT

**Retired on the Melted Armor contract: the entry is KEPT, the payload is kept, the field is kept
and the read site in `_sharpshooter_focus` is kept.** Retirement means it stops being OFFERED.
`eligible_ids` skips it; `config`, `build` and `display_name` all still resolve it, so a saved run
holding the rune keeps working and keeps being paid.

**THE RETIREMENT STRING RECORDS WHY, AND THE WHY IS NOT "IT WAS WEAK."** It names Overkill, names
the `elif`, names FN's measurement of exactly zero, names the cosmetic tell, and names the thing
that makes the space closed: **his meter is lost three ways and all three were already covered.**
It is modelled on Split Tongue's, which is the closest precedent in the file — *"IT WAS AUTHORED
AGAINST A BASE THAT DID NOT EXIST"* — and it ends the same way, with the read site declared kept
and the replacement named.

### THE REPLACEMENT

> **SHARED MARK** · 100g · `spec:sharpshooter` · **PASSIVE**
> *"An ally attacking the enemy he last attacked builds him 5 Focus."*

**THE NAME IS BARE AND THE BRIEF'S IS NOT, AND THAT IS A RULING RATHER THAN A TRIM.** The brief
heads it *RUNE OF THE SHARED MARK*. **All sixty live entries in `data/runes.json` are bare** —
`Deepening Hex`, `Keen Focus`, `Heavy Bolts` — **and every `Rune of the …` in the file is
retired**, 61 of them. `check_fd` §3 pins that split in both directions with a floor on the retired
side. **A live rune wearing the long shape would red an existing gate**, so the authored name is
`Shared Mark` and `check_fo` §2c asserts the CONVENTION over the whole live pool rather than
pinning this one string.

### THE MAGNITUDE IS PROPOSED, NOT RULED — AND THIS IS WHAT IT IS PROPOSED AGAINST

**WHAT A CONSECUTIVE SELF-ATTACK GRANTS TODAY IS 20.** `_sharpshooter_focus` pays
`20 + muscle_memory_ranks + rune_muscle_memory_ranks` when the victim is the hero's own
`last_attack_target`; both those terms are zero on an untalented hero, so **20 is the base and it
is the number a ratio has to be priced against.** (Unwavering's ramp and Quarry's Mark's doubling
ride on top of it and are node and card magnitudes, not the base.)

**THE PROPOSAL IS 5 — A QUARTER — AND THE DERIVATION IS THE ALLY POPULATION.** The allies who can
reach his mark in a legal run are **the three other heroes** (see below), so:

| Ratio | An ally's blow | A full round of party fire | Against his own 20 |
|---|---|---|---|
| a half | 10 | **30** | **more than his own shot** |
| **a quarter** | **5** | **15** | **less than his own shot** |
| a fifth | 4 | 12 | less, and thin against a 100-point conversion |

**A QUARTER IS THE LARGEST SHARE THAT KEEPS HIS OWN SHOT THE BIGGEST SINGLE SOURCE UNDER EVERY
PARTY COMPOSITION.** At a half the rune stops supplementing his patience and starts replacing it,
which is what BI §1 says a single meter cannot afford — held value and spend frequency are
antagonistic, and a meter somebody else fills is a meter he is not paying for. At a quarter a full
round of party fire is worth roughly three quarters of one of his own attacks, and the conversion
point at 100 arrives about 40% sooner on a board where the party focuses.

**IT IS `const SHARED_MARK_FOCUS := 5` IN `battle.gd` AND IT IS ON THE CARD.** One authored copy,
so a re-tune is one line and one string, and `check_fo` §2c asserts the two agree. **The number is
the designer's and this batch does not claim it** — what it claims is the derivation.

### WHAT A COMPANION COUNTS AS: **ALLY**, AND THE ARM IS UNREACHABLE IN A LEGAL RUN

**THE WORD IS SETTLED AND THE CODE IMPLEMENTS IT.** *HERO* is one of the four; *ALLY* is heroes
AND companions (CV §4, closed at DM §3). The card says ALLY, so `_shared_mark_focus` is called
from the hero ability path **and from `_companion_hit`** — one function, both paths, so they cannot
disagree. **A hook written only at the ability site would have implemented the narrow word while
the card said the wide one, and DJ §1's whole finding is that this reports NOTHING when it
happens**: a companion-opened board paid exactly 1.0000 of a hero-opened one and no log, no test
and no battery said so.

· **NONE OF THE FIVE RECORDED REASONS A COMPANION CANNOT RECEIVE SOMETHING APPLIES HERE**, and the
  reason is structural: **the companion is the ATTACKER, not the receiver.** The Focus goes to the
  Sharpshooter, who has a bar. No resource bar, `_companion_hit` reading none of the strike loop,
  stamped-at-spawn, per-turn and `_gain_faith`'s refusal are all reasons about a RECIPIENT, and
  this clause has none.
· **BUT A COMPANION CANNOT STAND BESIDE A SHARPSHOOTER, BY TWO INDEPENDENT STRUCTURES.** A run's
  party is **one of each class** (`draft_screen.ROSTER` and `run_state.new_run`), the Sharpshooter
  IS the Hunter, and the Beastmaster is the other Hunter spec — so the two can never be in one
  party. And **companion summoning is the Beastmaster's exclusive axis** (DR §1; `check_dr` reds a
  `special: "summon"` ability authored onto the Sharpshooter). `_do_summon` has exactly two callers
  and both are Beastmaster content.
· **SO THE ARM IS UNREACHABLE IN PLAY AND DRIVABLE IN A FIXTURE, AND IT IS DRIVEN.** DK §1's rule
  is that a widening is done when the EFFECT ARRIVES — *measure it on a live body* — and a widening
  that changes no measurement is worse than the narrow word. **`check_fo` §2g seats both Hunter
  specs, summons a real Canis, and reads 5 Focus arriving on the Sharpshooter off the beast's
  blow.** The party is illegal and the gate says so; the measurement is real.
· **WHY NOT WRITE `hero` AND RECORD THE REASON.** Because the reason would be a SIXTH kind, and
  CLAUDE.md says there are five and no sixth. The five are reasons a companion cannot RECEIVE;
  this would be a reason a companion cannot BE PRESENT, which is a fact about the party and not
  about the beast — **and it evaporates the day any other class fields one.** Writing ALLY costs
  one call, promises a player nothing his party cannot deliver, and needs no exception at all.

### TWO SMALLER DECISIONS THE HOOK MAKES, NAMED RATHER THAN LEFT IMPLICIT

· **IT FIRES ONCE PER CAST AND DOES NOT ASK WHETHER THE BLOW LANDED**, which is the gate the
  Sharpshooter's own engine sits behind one line below — a damaging, non-counter cast at a live
  enemy. **His own shot and an ally's are therefore counted by ONE rule** and cannot drift apart
  about what *attacked the mark* means. The AZ precedent is explicit that the Focus engine is per
  CAST, not per hit.
· **`_focus_safe` IS DELIBERATELY NOT APPLIED TO AN ALLY'S BLOW.** That predicate exists to stop
  an AoE or a Called Volley reading as the HOLDER breaking his own bond — it is a rule about his
  streak, and an ally has no streak to protect. **An ally's AoE whose PRIMARY target is the mark
  pays**, once; one aimed at another body pays nothing, which is the same targeting rule as a
  single-target blow and is what §2d's control drives.

### `_gain_focus` IS THE ONLY WAY IN, AND THAT IS PROVED BEHAVIOURALLY

`_shared_mark_focus` computes WHO and HOW MUCH and hands the number to the engine, exactly as
`_pay_sequence_focus` does. **A source read would only say the call is SPELLED there.** So the
gate proves it with an instrument the meter already has: **Spray of Arrows caps Focus at 50 inside
`_gain_focus` and nowhere else.** §2f parks the meter on the cap with `spray` held and an ally
works the mark — through the engine it cannot move, and around it, it would. **Then it lifts the
cap and drives the same blow, which must pay**; without that positive arm the first one passes on
a rune that pays nothing at all.

### THE BR §1 NAME SWEEP — 1,363 LABELS, DUMPED FROM A RUNNING ENGINE

Every ability `display_name`, every talent node **name, id and lane**, every rune name and id, and
every `STATUS_INFO` id and label. **`Shared Mark` comes back clean on both hard tests: ZERO exact
matches and ZERO containments either way.** Under BR §1 that ships — an ability-vs-ability
duplicate is the only real break, `Classes.pool_ability` is the only name-keyed resolver, and
nothing resolves a rune by name at all.

**THE SWEEP FOUND NINETEEN SHARED-WORD NEAR-MISSES WHERE THE BRIEF NAMED FOUR**, which is the
brief's own point about a sweep beating a reading, arriving against the brief's own list:

| The brief named | The sweep also found |
|---|---|
| `Standing Mark`, `Shared Hide`, `Shared Ruin`, `Shared Scent` | **`Quarry's Mark`**, `Hunter's Mark`, `Mark of the Hunt`, `Rune of the Shared Wild`, `Shared Grief`, `Shared Vigil`, `Shared Devotion`, `bm_shared`, `hunt_mark`, `party_mark`, and the five ids of the runes it did name |

· **`Quarry's Mark` IS THE SHARPEST AND IT IS THE ONE A READING WOULD MISS.** It is a **live
  SHARPSHOOTER card, in his own reachable pool**, and it is read by the very function this rune
  sits beside — `_sharpshooter_focus` doubles Focus gained from an enemy wearing `quarry`. **Same
  spec, same mechanic, same meter.** That is the `Stop Thrust` / `Committed Thrust` shape DR
  rejected a name for, and it is worse, because these two would appear in one combat log.
· **IT SHIPS, AND THE REASON IS MECHANICAL RATHER THAN A JUDGEMENT.** The card's status id is
  `quarry`, not `mark`, so no chip can read the same word twice; nothing resolves a rune by name;
  and `test_runes`' schema walk — which refuses duplicate `display_name`s across all 127 entries,
  retired included — passes, because there is no duplicate. **REPORTED, NOT RESOLVED**, which is
  BR §1's own disposition for a label collision, and it is recorded in `CLAUDE.md` beside FK's.

---

## §3 — THE `Overkill` COLLISION: CONFIRMED, AND RULED ON BY NOTHING

**BOTH NODES EXIST. IT IS A LIVE COLLISION IN THE TALENT TREES.**

| Node | Tree | Lane | Row | What it does |
|---|---|---|---|---|
| `bz_warcry` | **berserker** | Warpath | **7** | Killing an enemy clears the cooldowns of Hack and Slash and Wildstrikes |
| `ss_overkill` | **sharpshooter** | **Penetration** | **7** | A killing blow's excess carries to another enemy at full value — and the carry keeps his Focus in FULL |

**Two nodes, two trees, two ids, one word, and the same row number in both.** They can appear in
one combat log and in one glossary; nothing resolves a talent node by name, so nothing breaks.
**Under BR §1 that is a LABEL collision and its disposition is *ships as specified and is
flagged*** — the BO Second Wind / BP Precision Strike / AV Shared Vigil precedent. **This batch
rules on nothing here**, as the brief requires.

· **IT WAS ALREADY KNOWN AND ALREADY WRITTEN DOWN — IN THE SOURCE, NOT IN A DOCUMENT.**
  `talents.gd` carries a *"NOTE for the designer"* beside `bz_warcry` naming the collision. **It
  is the record, and it is the shape state.md's own queue warns about**: a finding whose only home
  is a comment beside one of the two things it is about.
· **AND THE NOTE HAS THE LANE WRONG.** It says the Sharpshooter's *"Precision lane"*; his Overkill
  is in **Penetration**. One word, in the one place a designer reading the Berserker's tree would
  meet the collision. **CORRECTED HERE, AND THAT IS A CORRECTION OF THE RECORD RATHER THAN A
  RULING** — the same disposition FN gave the eleven lines that said *six*. `check_fo` §3 asserts
  the lane off the tree and asserts the note no longer says `Precision lane`, so it cannot drift
  back.
· **THE SHAPE IS CJ/CK's AND IT WAS RULED AT CX, NOT DR** (premise 19). CX renamed the ENEMY half
  of `Crushing Blow` and left the node/ability pair standing. **The two are not the same
  disposition**: Crushing Blow was ability-vs-ability across the field, which BR §1 calls a real
  break; this is node-vs-node, which it calls a label. **That distinction is why this one can be
  reported and left**, and it is worth having straight before anyone reaches for a rename.
· **§3's ARMS ARE IN THE GATE RATHER THAN ONLY IN THIS REPORT**, because `docs/reports/` is the
  one file class no instrument reads and no sweep covers — state.md's own standing item. The gate
  asserts both nodes exist, that their ids differ, that they sit in the two trees named, and that
  **the Sharpshooter's node still carries the Focus clause** — because the day it does not, the
  Wide Watch's retirement string stops being true.

---

## §4 — WHAT WAS DELIBERATELY NOT DONE

- **NO OTHER RUNE IS RETUNED.** The Wide Rite went from 1.4% of an Occultist's build space to 100%
  at FN and Heavy Bolts from 2.6% to 100%; **whether either is correctly priced at 100g is a design
  question and it is still open.** Neither is touched here.
- **NO CLASS OR UNIVERSAL RUNE IS AUTHORED.** The Shared Mark is `spec:sharpshooter`, which is what
  the Wide Watch was.
- **THE GENERATED STAT FAMILY STAYS OUT OF THE OFFER PATH**, per FM.
- **NO CARD, ABILITY, TALENT OR CONSTANT MOVES** beyond §1's threshold arithmetic and §2's new
  `SHARED_MARK_FOCUS`. `BRACING_LINE_LEVEL` is still 32, `RUIN_THRESHOLD` still 10, `FOCUS_CONVERT`
  still 100, and `avatar_ruin` still installs 5.
- **THE `Overkill` COLLISION IS NOT RESOLVED.** Neither node is renamed. Only the lane word in
  `talents.gd`'s note is corrected.
- **`docs/spec-recon.html`'s RUNE TABLE IS NOT REWRITTEN.** It records the layer as it stood before
  FN — every one of the eight still shows a THRESHOLD or BREADTH secondary — and rewriting a recon
  document into a current one is a different job from this batch's. **A dated note is added at that
  table instead**, naming FN's retirement and FO's two moves, because state.md says that document
  *"is still the document authoring reads"* and it now lists a RETIRED rune among the
  Sharpshooter's five.
- **THE WIDE WATCH'S READ SITE IS NOT REMOVED.** Kept, and said to be kept.

---

## §5 — VERIFICATION

**THE DOCUMENTATION WAS WRITTEN BEFORE THE VERIFICATION RUN**, per the brief and per the standing
rule: roughly thirty-five suites assert on `CLAUDE.md`, `docs/master.html` and
`docs/changelog.html`, so a document edited after the battery is a document the battery never read.
`docs/state.md` and this report are the two the battery cannot see and they are written last.

### THE UNMODIFIED GATES WERE RUN AGAINST THE NEW TREE FIRST

**A full battery on the changed code with EVERY gate still at HEAD**, before a single assertion was
touched. The brief asks for it because `check_ez` §5's subject changes here; what it actually
bought was a complete list of what the change moves, taken in one pass instead of discovered one
red at a time.

**SIX TARGETS MOVED AND FIVE OF THEM WERE PREDICTED. THE SIXTH IS THE ONE WORTH HAVING.**

| Target | Reading | Predicted? |
|---|---|---|
| `check_es` §1 | 47 / **1** — *"the authored pool is 127 entries, expected 126"* | yes |
| `check_ez` §0 | *"the authored pool is 127 entries, expected 126"* | yes |
| `check_fe` §1 | 78 / **2** — *"RESOURCE 28!=27"* and *"the table is 127 rows"* | yes |
| `check_fn` §1a / §4 | the retired arm and the `deepening_hex` field | yes |
| `test_batch_cb` | **1721 → 1730**, a rising count | yes |
| **`check_ek` §4** | 45 / **1** — the `MARK` clash census | **NO** |
| **`check_ez` §5** | **34 checks / 1 failure / 1 THROW** against a baseline of 96 / 0 | **NO — and this is the finding** |

### THE +1 ENTRY MOVES FOUR CENSUSES AND A SUITE, AND ONE OF THEM IS NOT A COUNT

**A one-out-one-in replacement leaves the LIVE pool at sixty and grows the FILE by one** — the FC
Split Tongue / Shared Ruin shape, and `check_es` §1's own comment already describes it. What that
moves is every walk over the whole file: `check_es` §1 and `check_ez` §0 pin the total, `check_fe`
§1 pins `RUNE_TAGS`' row count, and **`test_batch_cb` walks `Runes.ids()` asserting nine names are
not rune names — 9 checks per entry, so its count went 1721 → 1730 exactly.** A rising count is a
notice rather than an error and the row moves with the reason attached.

· **AND THE ONE THAT IS NOT A COUNT IS `check_fe`'s RESOURCE COLUMN.** The Shared Mark's primary
  tag is RESOURCE and the Wide Watch's row is **kept** (a retired entry still resolves, and
  `RUNE_TAGS` is keyed by id), so a replacement that leaves the live pool at sixty **grows a tag
  column by one.** That is the single place those two counts disagree, and it is exactly why that
  table is asserted column by column rather than derived.

### `check_ek` §4 CAUGHT THE NAME, AND IT IS A THIRD INSTRUMENT SAYING THE SAME THING

**The tag `MARK` ships with named collisions and the exemption is compared as a SET, not
subtracted** — EL's own note says a skip *"would hide a NEW collision behind an old one"*. So the
day `Shared Mark` was authored, that equality went red and named it:

> found [ability:Hunter's Mark, ability:Mark of the Hunt, **ability:Quarry's Mark**, **rune:Shared
> Mark**, rune:Standing Mark, status label:Hunter's Mark]

**THREE INDEPENDENT INSTRUMENTS REACHED THE SAME NAME**: FO's own BR §1 sweep (0 exact, 0
containment, 19 near-misses), BR §1's standing rule, and this equality — **and only the equality
made it a decision that had to be taken rather than a note that could be skipped.** It is the EZ
case again, and the sixth entry carries the same reasoning: the mark the rune names is a lasting
mark on ONE enemy, so the word is doing the same work, **while the rune's own tag row is
`["RESOURCE"]` and not MARK, because what the rune DOES is build a meter.**

### AND `check_ez` §5 DID NOT GO RED — IT WENT SILENT, AND THAT IS THE SHARPEST THING IN THE RUN

**Renaming `rune_hex_threshold` did not fail an assertion. It THREW:**

> `SCRIPT ERROR: Invalid assignment of property or key 'rune_hex_threshold' with value of type
> 'int' on a base object of type 'Node2D (BattleUnit)'.` — `_s5_the_read_sites (check_ez.gd:437)`

**The throw aborted the function, and the gate printed `check_ez: 34 checks / 1 failures` against
a baseline of 96 / 0.** **SIXTY-TWO ASSERTIONS NEVER RAN AND THE VERDICT LINE SAID NOTHING ABOUT
IT.** The one failure it did report was §0's count — the rename's own consequence was invisible.

· **ONLY THE `throws=` COLUMN SAID SO.** `run_battery.sh` prints it beside the check count for
  exactly this reason (CD's rule, and CT's scar: *"GATE 2 reporting 57 checks against its
  documented 165 — it ran barely a third of itself and said PASS"*). **The falling check count is
  the other tell**, and `baselines.json`'s polarity rule is right about which direction is the
  error: 34 against a floor of 96 is an error; 1730 against 1721 is a notice.
· **A FIELD RENAME IS THEREFORE NOT A RED, IT IS A HOLE**, and the hole is silent in both
  directions: a gate that stops running its own assertions, and a batch that reads *"1 failure"*
  and fixes the count. **This is why the brief asks for the unmodified gates first** — the throw is
  visible on a HEAD gate against new code, and it is invisible once the gate has been re-pointed.

### THE SIX CONTROLS, AND EVERY ONE BIT ON THE ARM IT AIMED AT

**Each arms ONE injection against `battle.gd`, runs `check_fo`, and reverts. The tree is md5-identical
before and after, and the gate reads 93 / 0 at both ends.**

| # | Injection | Result |
|---|---|---|
| **C1** | **the `mini` put back** — the repair itself, reverted | **6 failures**, incl. *"§1e: the rune is worth ZERO to a capstone holder (5 == 5) — FN's hole is OPEN again"* |
| **C2** | `RUIN_FLOOR := 1` | **4 failures** — the source pin and BOTH floor edges (*"at a threshold of 4 the subtraction reached 2"*) |
| **C3** | the `_companion_hit` call removed | **1 failure** — *"a COMPANION striking the mark paid 0 Focus, not 5 — the card says ALLY and the code implements HERO"* |
| **C4** | `h.second_resource += …` instead of `_gain_focus` | **1 failure** — *"pushed the meter to 55 THROUGH the Spray ceiling"* |
| **C5** | the retired Wide Watch read site deleted | **1 failure** — *"a saved run holding it now pays NOTHING"* |
| **C6** | the holder no longer excluded | **1 failure** — *"paid 25 holding the rune against 20 without it — one event, paid twice"* |

· **C1 IS THE ONE THAT PROVES THE BATCH.** Reverting to `mini` satisfies EZ §5's property perfectly
  and pays a capstone holder nothing, and the gate says so **in the sentence that names the fault**.
  A property arm alone would have read green on it. **That is why §1e is a strict inequality.**
· **C4's NUMBER IS THE PROOF, NOT THE VERDICT.** 55 through a 50-point ceiling is the meter being
  written from outside `_gain_focus`; it could not be produced by a rune paying the wrong amount.
· **C6 READS 25 AGAINST 20**, which is the engine's own payment plus the rune's — one event paid
  twice, and the arm compares the same blow with the rune off rather than pinning a talent's value.

### THE LITERAL SWEEP OVER EVERY EDITED FILE

**Every 4+ character string literal in every `.gd` that NAMES each edited file, escape-aware, both
quote kinds, on RAW source — which fails toward MORE needles — against HEAD's copy and the copy now.**

| File | Readers | Needles | LOST | GAINED |
|---|---|---|---|---|
| `scripts/battle.gd` | 73 | 11,536 | **1** | 0 |
| `scripts/runes.gd` | 9 | 1,356 | **1** | 0 |
| `scripts/unit.gd` | 30 | 6,405 | 0 | **1** |
| `data/runes.json` | 18 | 4,481 | **1** | **6** |

· **ALL THREE LOSSES ARE `rune_hex_threshold`**, the rename, and both files that pin it —
  `check_ez` and `check_fn` — are re-pointed here deliberately.
· **THE GAINED NEEDLES WERE THE ONES THAT NEEDED PROVING, BECAUSE A GAINED LITERAL TURNS AN
  ASSERTION GREEN.** `RETIRED` (unit.gd) appears in exactly one reader, `test_runes`, **in a
  comment**. `Overkill` and `Metronome` (runes.json, from the retirement string) appear in **ZERO**
  strict readers. `base` appears once, in `test_batch_ar`'s `sc.get("base", …)` — a talent scale
  key, not a claim about the rune file. **Nothing was flipped green.**

### THE PARSE FLOOR, AND IT IS GREPPED RATHER THAN TALLIED

`check_parse` reads **177 checks / 0 failures**, `A battery 101 (0 missing)`, and **`check_fo.gd`
is not in the RESIDUE list** — the half that says it is actually reached rather than merely present.
**The floor is the stderr grep, not the tally** (CN's scar: the gate once reported 0 failures on a
tree with a real Parse Error in it): `grep -cE "Parse Error|SCRIPT ERROR"` over the whole stream
reads **0**.

### THE ACCEPTANCE RUN

**103 targets. Two non-clean rows and both are the ones that are always non-clean.**

| | |
|---|---|
| **`check_fo`** | **93 checks / 0 failures / 0 throws** |
| `check_ez` | **98 / 0** — the re-point, at its new baseline |
| `check_fn` | 80 / 0 · `check_fe` 78 / 0 · `check_es` 47 / 0 · `check_ek` 45 / 0 |
| `check_de` (the differ) | **422 checks / 0 failures / 0 NOTICES** |
| `check_cl_width` | reports no readable count **by design** (its baseline is `null` on both axes) |
| `check_cm_live` | **13 / 4**, the sanctioned red, and the four FAIL lines are byte-identical to HEAD's |
| run harness | GATE 1 **22** · GATE 2 **166** · GATE 3 **8**, all PASS, 0 throws |

**ZERO NOTICES IS THE FIGURE WORTH READING.** Eight baseline rows moved in this batch and the
differ agreed with every one of them to the check: `check_parse` 177, `check_ez` 98, `check_em`
412, `test_batch_al` 623, `test_batch_bh` 295, `test_batch_cb` 1730, `test_runes` 5354, and
`check_fo` 93. **A row moved without its cause understood shows up here as a notice**, and there
are none.

### THE TREE WAS FROZEN ACROSS THE RUN

**366 paths — `git ls-files` PLUS `git ls-files --others --exclude-standard`, so `check_fo.gd` and
this report are both inside it — md5'd by ABSOLUTE path so a moved cwd cannot report the tree as
drifted.** Re-frozen after the run: **ZERO paths differ.**

### AND THE RUN BEFORE THIS ONE WAS RECONNAISSANCE FOR ONE WORD

**The first acceptance attempt came back with exactly one red, and it was this batch's own prose.**
`test_batch_bx` §4b caught **the retired word *party*** in a sentence FO added to
`docs/master.html` — the CV §4 rule this very report quotes. Everything else in that run was clean,
including all eight moved baselines and `check_fo` at 93 / 0.

· **THE LITERAL SWEEP COULD NOT HAVE SEEN IT, AND THAT IS THE POINT.** §4b strips four named
  identifiers and then asks whether the WORD survives on a boundary; a per-literal LOST/GAINED
  sweep asks whether a needle some `.gd` pins is still present. **Two different instruments, and
  the prose rule is the one a batch writing prose has to run FIRST.** The pre-check is to reproduce
  `_strip_idents` and search the result — which is what proved the fix.
· **THE FIX WAS ONE SENTENCE AND IT WAS NEEDLE-PROVED BEFORE THE RE-RUN.** Every 4+ character
  literal in every `.gd` that names `master.html` — **34 readers, 32 of them gates or suites,
  9,635 needles** — tested against the copy the battery had READ and the copy after: **ZERO LOST
  and ZERO GAINED.** `test_batch_bx` then read **161 / 0** standalone, and 161 / 0 again in the
  acceptance run.
· **THE BATCH DID NOT PATCH AND RE-RUN AT THE FIRST RED.** The run was allowed to finish so every
  red arrived in one pass — which is how `check_de`'s own count was confirmed at 422 and the eight
  baselines were confirmed together. **A doomed battery is reconnaissance; the freeze is already
  broken, so the cost of finishing it is zero and the information is the whole point.**

### A PROCESS FAULT THIS BATCH COMMITTED, RECORDED BECAUSE IT NEARLY COST THE RECONNAISSANCE

**A "dry run" of the gate-edit script was built by `exec`-ing it with a stub `patch()` function.
The module's own `def patch` executes first and rebinds the name in that globals dict, so every
call reached the REAL function and the edits landed — mid-battery, on four gates whose unmodified
reading was the entire purpose of the run.**

· **IT WAS CAUGHT BY READING THE OUTPUT.** `ok check_ez.gd (2 edits)` is the real function's print;
  a stub would have printed the dry-run line. The battery was still on `check_du`, the four files
  were backed up to the scratchpad, restored with `git checkout HEAD --` on exactly those paths
  (verified first with `git diff --stat` that they held no other uncommitted work), and **the
  exposure window was then checked rather than assumed**: `check_du` reads none of the five, and
  `check_dk` / `check_dm` — the only already-run targets that read `talents.gd` — had finished
  before the edit landed. **The reconnaissance evidence held.**
· **THE TRANSFERABLE RULE: to dry-run an apply script, PARSE it or give it a real `--dry-run`
  flag.** Pre-seeding a stub in an `exec` globals mapping supplies a value the module is free to
  rebind, and a module-scope `def` always rebinds.
