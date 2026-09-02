# BATCH EL — THE TAGS GET THEIR REAL NAMES, AND `Tempo` IS FREED

**IMPLEMENT-ONLY.** §1 freed a word; §2 renamed six of the seven and added the seventh; §3 re-ran
the name sweep and found the sweep itself was the thing that was wrong. **Nothing in the game reads
a tag, no card's behaviour changed and no magnitude moved.**

---

## THE BRIEF'S CLAIMS, RE-DERIVED

**Three were wrong and one of the three changed what §1 had to do.**

| the brief said | the code says |
|---|---|
| `Tempo` is a status chip and **three talent nodes** | **and the Sharpshooter's third talent LANE, in nine nodes, and one rune's lane.** Six surfaces, not four. EK's sweep collects `"name"` keys out of `LANE_TREES`; a lane lives under `"lane"`, so it was invisible |
| the constants are the only thing that moves — **292 rows reference `TAG_ORDER` and `TAG_INFO` rather than the strings** | **FALSE, and the brief asked to be told.** `CARD_TAGS` and `RUNE_TAGS` hold the words as literals: 227 + 65 = **292 rows, 459 tag slots**, every one of them moved |
| **`test_batch_bl` pins a literal inside `battle.gd`** for the `Tempo` rename | **It holds no `Tempo` literal.** It reads `battle.gd`'s source for its own §1 (enemy intent) and names nothing this batch touched |
| MARK is the strongest candidate at **9 draft cards and 16 of 227** | **9 draft cards is right and 16 of 227 is not reproducible.** Derived from the read site the population is **10 cards, 9 of them in the draft** — and it is not EK's 10, which counted four bleedout cards and missed three that lay a mark |
| `check_ek` §3 asserts the file population is exactly five, **and this batch must not change it** | **It changed, by one gate, and the section is now two assertions instead of one.** See §4 |

---

## §1 — `Tempo` IS FREE

**THE CHEAP SIDE MOVED, AS RULED.** The tag lands on 292 rows; the chip and the nodes are six
strings.

**CK's PRECEDENT WAS CHECKED BEFORE ANY WORD WAS INVENTED, AND IT PAID ONCE OUT OF FOUR.** CK
renamed the Iron Will *ability* to Ironclad because `ironclad` was already its internal status id,
so no new vocabulary entered the game. The four things renamed here carry these internal names:

| thing | internal id / counter | does the id give a free word? |
|---|---|---|
| the status chip | `tempo` | **No** — the id IS the word |
| `sm_deep_thrust` | `tempo_ranks` (id `sm_deep_thrust`, ex-"Deep Thrust") | **No** |
| `cr_icy_veins` | `shattered_tempo` (id `cr_icy_veins`, ex-"Icy Veins") | **No** |
| `dv_crusade` | **`crusade_ranks`** | **YES — CK's precedent exactly** |

**WHAT SHIPPED:**

| was | is | why this word |
|---|---|---|
| chip `Tempo` (`T+`) | **Pivot** (`Pv`) | The chip's own legend already read *"The pivot's momentum"*, and two `battle.gd` comments call it the pivot. Swept clean. `T+`'s replacement is `Pv` because `P+` is taken by `parry_up` |
| node `Tempo` (`sm_deep_thrust`) | **Pivot** | Same mechanic as the chip — the node grants the status, so they are one name |
| node `Shattered Tempo` (`cr_icy_veins`) | **Shockwave** | `battle.gd`'s own log line already read *"the shockwave sets the field back"*. Swept clean |
| node `Crusader's Tempo` (`dv_crusade`) | **Crusade** | **The name its `crusade_ranks` counter always carried.** No new word entered the game |
| Sharpshooter lane `Tempo` (9 nodes) | **Pace** | A third P beside Precision and Penetration; the lane's own comment calls it *"speed, cooldowns, Focus acceleration"*. Swept clean |
| rune lane `Tempo` (Rune of the Long Draw) | **Pace** | Follows the lane it names |

**THE STATUS IDS DID NOT MOVE** — `tempo`, `shattered_tempo`, `crusade_ranks`. The collision is a
LABEL collision: no player reads an id, and moving one is the expensive side (`tempo` alone has
apply sites, a chip stamp and a restamp in `_swordmaster_switch`). **Each declaration in `unit.gd`
now names its display word**, so the id stays traceable rather than becoming an orphan — the
"a suspension outlives its reasons" shape, closed at the declaration.

### EVERY SITE THE OLD NAME TOUCHED

**Read out of the pin manifest first, as the brief required — and the manifest holds ZERO pins on
`Tempo`.** `build_pin_manifest.py` records the literals suites pin into files; no suite pins one
here, so the manifest was the wrong instrument for this rename and a whole-tree grep was the right
one. **That is worth recording: a manifest of PINS cannot see a name that suites assert through a
table lookup**, which is how `test_batch_ak`, `as`, `aw` and `az` all reach these four names.

| file | sites | what |
|---|---|---|
| `scripts/battle.gd` | 5 code + 15 comments | the chip row; the `update_status` text; three `_log` lines; fifteen comment blocks |
| `scripts/talents.gd` | 3 nodes + 9 lane fields + 3 comments | |
| `scripts/unit.gd` | 3 | the counter declarations, annotated rather than renamed |
| `scripts/classes.gd` | 1 | Preparation's synergy comment naming Shattered Tempo |
| `data/runes.json` | 1 | the Rune of the Long Draw's lane |
| `test_batch_ak` `as` `aw` `az` `bn` `br` | 13 | re-pointed **in place** with the reason (CG's rule) |
| `check_co` `check_cy` `check_dr` | 3 | descriptive tables |
| `CLAUDE.md` | 4 | |
| `docs/master.html` | 6 | §7 lane tables, three node rows, the lanes line, and Blink's *"Tempo, not damage"* → *"Timing, not damage"* |
| `docs/talent-audit.html`, `docs/rune-audit.html` | **deliberately untouched** | both are CLOSED reports (CV / DN) kept *"as written — it is the evidence of which way each disagreement pointed"*. Editing a closed report destroys the evidence it exists to be |

**A COMMENT-STRIPPED DIFF PROVED THE COMMENT EDITS ATE NO CODE.** Fifteen comment blocks moved in
`battle.gd`; the stripped diff against `HEAD` shows **exactly five changed code lines**, all five
of them the intended strings.

**`Tempo` NOW RESOLVES TO NOTHING IN THE GAME'S OWN VOCABULARY** — no ability, node, lane, status
label, rune, rune lane, item or relic carries it — which is what §2 required before it could begin.

---

## §2 — THE SEVEN

| shipped at EK | shipped at EL | the one-line meaning, rewritten |
|---|---|---|
| AFFLICTION | **DEBUFF** | Lands a harmful effect on an enemy, or spends one. |
| SHELTER | **DEFENSE** | Answers damage coming in: heals, absorbs or reduces it. |
| BREAK | **BREAK** | Moves a Break meter. *(unchanged)* |
| METER | **RESOURCE** | Moves Mana, Rage or a class meter. |
| AMP | **OFFENSE** | Raises the damage the holder deals. |
| CLOCK | **TEMPO** | Moves the initiative timeline or a cooldown. |
| — | **MARK** | Lays a lasting mark on one enemy. |

**EVERY MEANING WAS REWRITTEN, NOT CARRIED.** *"Puts a harmful effect on the enemy, or spends
one"* was written for AFFLICTION, a word that needed the sentence to explain it. **Two were
circular under the new names** — a RESOURCE tag reading *"moves a resource"* and a DEFENSE tag
reading *"mitigates"* define the word with the word — and both now name the thing instead.
`text-standard.html` governs them: state the effect, no rationale, no second person, keywords
capitalised.

### THE RENAME COST 292 ROWS, AND THE BRIEF ASKED TO BE TOLD IF IT DID

**It did, and the design was never what the brief believed.** `CARD_TAGS` and `RUNE_TAGS` hold the
words as literals — 227 rows and 65 rows, **459 tag slots** — so every row moved.

**BUT THE PROPERTY THAT MATTERED DID HOLD, AND IT IS THE ONE WORTH KEEPING.** *No reader outside
those two tables names a tag word.* Every gate reads `Classes.TAG_ORDER` and derives; `map_screen`
calls `card_tag_line` and nothing else. **So the rename was two files and a `sed`, and not one
clause in the game had to be read to do it.** A future rename is the same shape. **The one-accessor
/ one-builder design bought exactly what it was supposed to buy; the "rows reference the constant"
claim was never true and is not what saved this.**

### MARK — DERIVED FROM THE READ SITE, WHICH THE GAME HAD ALREADY WRITTEN DOWN

**`battle.DISPEL_NEVER`'s own comment names the marks**, because Dispel had to be told not to strip
them: *"`DEBUFF_IDS` deliberately does NOT hold the five MARKS the party applies — covenant,
quarry, snare_line, feinted, hunt_mark"*, then *"`blood_debt` and `vendetta` are the party's OWN
MARKS, laid on an enemy"*, then *"`reacquire` is the Sharpshooter's own named quarry"*. The same
comment excludes three entries by name: `ruin_primed` is *"the primer rather than the mark"*,
`charging` is *"a declared blow, not a boon"*, `spec_passive` is a hero's own. **Two more marks are
in neither list** — `party_mark` and `arcane_echo` — because each card clears its own predecessor
(*"one mark at a time"*), so Dispel never needed telling.

**TEN CARDS LAY ONE. NINE ARE IN THE DRAFT.**

| card | status laid | EK's tags | EL's tags | primary moved? |
|---|---|---|---|---|
| **Hunter's Mark** (class:hunter) | `party_mark` | AMP · BREAK | **MARK · OFFENSE** | ✔ |
| **Quarry's Mark** (sharpshooter) | `quarry` | METER | **MARK · RESOURCE** | ✔ |
| **Reacquire** (sharpshooter) | `reacquire` | METER | **MARK · RESOURCE** | ✔ |
| **Mark of the Hunt** (boss:beastmaster) | `hunt_mark` | METER · AMP | **MARK · OFFENSE** | ✔ |
| **Blood Debt** (berserker) | `blood_debt` | BREAK · SHELTER | **MARK · DEFENSE** | ✔ |
| **Vendetta** (warden) | `vendetta` | AFFLICTION | **MARK · DEBUFF** | ✔ |
| **Arcane Echo** (arcanist) | `arcane_echo` | BREAK · AMP | **MARK · OFFENSE** | ✔ |
| **Covenant of Ash** (occultist) | `covenant` | AFFLICTION · METER | **MARK · DEBUFF** | ✔ |
| **Snare Line** (mystic) | `snare_line` | AFFLICTION | **DEBUFF · MARK** | ✘ |
| **Feint** (swordmaster) | `feinted` | BREAK | **BREAK · MARK** | ✘ |

**EIGHT PRIMARIES MOVED, AND THAT IS A FINDING RATHER THAN A RELABEL** — exactly as the brief
predicted. **The pattern in all eight is one thing: each was tagged for what its mark PAYS.**
Quarry's Mark was METER because the mark doubles Focus. Hunter's Mark was AMP because the mark
grants party damage. Blood Debt was BREAK because the strike carries pressure and SHELTER because
the mark heals. **All of those are readings of the payoff, and the payoff is not what the card is.**
That is the exact failure the tags exist to make visible, sitting inside the tag table.

**EK MISSED THREE AND COUNTED FOUR THAT DO NOT BELONG.** EK's ten were six that *say* "one mark at
a time" plus **Call the Wilds, Gut Rip, Rampage and Savage Sweep**, which *"reach one through the
bleedout path"*. Those four cause bleedouts; **Blood Debt's mark is what pays on a bleedout.**
Tagging them MARK tags a card for another card's mark, which CN's rule forbids — they keep
DEBUFF/BREAK. And EK never reached **Covenant of Ash, Snare Line or Feint**, because none of the
three says "mark" in its own text. **A vocabulary derived from what cards SAY is the vocabulary of
the cards that were written well.**

**THE TWO ARGUABLE ONES, WITH THE ALTERNATIVE STATED:**

- **Snare Line keeps DEBUFF.** `snare_line` is applied to **every** enemy on the field for two
  turns, not to one. **A tag meaning *"one enemy is named"* should not be led with by a card that
  names everyone.** The alternative — MARK primary, on the strength of `DISPEL_NEVER` listing it
  with the other four — is not worse, and it is one row.
- **Feint keeps BREAK.** Its Aggressive branch marks; its Defensive branch banks parry charges and
  marks nothing. **A card that marks half the time should not lead with it.** The alternative is
  the same one row.

**NO RUNE GAINS MARK, AND THAT IS MEASURED.** Not one rune payload field reads `covenant`,
`quarry`, `snare_line`, `feinted`, `hunt_mark`, `party_mark`, `blood_debt`, `vendetta`, `reacquire`
or `arcane_echo`. The Rune of the Whispering Dark says *"each mark of Ruin"* in its `desc` — the
ordinary English word for a stack, and reading a rune's `desc` is exactly what `RUNE_TAGS`'s own
header forbids.

### SEVEN IS THE CEILING, AND IT IS RECORDED SO AN EIGHTH NEEDS AN ARGUMENT

**A tag only means something if holding two is notable.** Measured over the sixteen draft pools at
seven words:

| | |
|---|---|
| distinct tag combinations per pool | **4 to 10**, against **6 to 13** cards |
| cards that are the ONLY card in their pool with their combination | **65 of 154 — 42%** |
| pools where EVERY card reads differently | **1 of 16** (the Warrior class pool, 6 of 6) |

**That 42% is the number the ceiling rests on.** Every word added divides the corpus finer, and the
point at which a pool stops producing a repeated combination is the point at which a second card on
a tag stops being a signal. **One pool is already there.** An eighth word takes more of them there,
and a vocabulary in which everybody holds a different pair is a vocabulary that has stopped
grouping anything. `check_ek` §2 pins the count as an **equality** so an eighth is a decision
somebody made, and **prints the spread** so this claim can be re-tested rather than taken.

### THE SPREAD, AS SHIPPED

**The 154 draft cards:**

| tag | primary | either |
|---|---|---|
| DEBUFF | 42 | 51 |
| DEFENSE | 41 | 49 |
| BREAK | 30 | 54 |
| RESOURCE | 15 | 42 |
| OFFENSE | 12 | 20 |
| TEMPO | 7 | 8 |
| MARK | 7 | 9 |

**79 of the 154 carry a second tag** (74 before MARK). **The corpus of 227**: DEBUFF 68, DEFENSE
56, BREAK 54, RESOURCE 17, OFFENSE 16, TEMPO 8, MARK 8 by primary. **The 65 runes**: DEFENSE 25,
DEBUFF 17, OFFENSE 10, RESOURCE 9, BREAK 3, TEMPO 1, MARK 0.

---

## §3 — THE SWEEP, ON ALL SEVEN — AND THE INSTRUMENT WAS THE THING THAT WAS WRONG

**RUN AGAINST 1,551 AUTHORED STRINGS**: every ability display name (227), every talent node (324),
every talent lane (39), every status id (34), every status LABEL (184), every rune name (65) and
rune lane (36), every item id and name (16), every relic id and name (50), every archetype role
(18), every spec id and name (24), every enemy and enemy-ability name (50), and every glossary id
and term (196). **Word-boundary matched, with near-misses reported separately** — "Berserk" inside
"Berserker" is not a collision and a bare `contains` says it is.

| word | verdict |
|---|---|
| **DEBUFF** | **CLEAN** — nothing, on any surface |
| **RESOURCE** | **CLEAN** |
| **OFFENSE** | **CLEAN** |
| **TEMPO** | **CLEAN, and only because §1 freed it.** Before §1 it read 14 hits |
| **BREAK** | **CLEAN on every name surface.** One glossary TERM, *"Pressure & Break"* — which is the mechanic the tag is named for, not a second thing wearing the word |
| **DEFENSE** | **2 HITS — `defense` (item id) and "Defense Potion".** Shipped, named |
| **MARK** | **4 HITS — Hunter's Mark, Quarry's Mark, Mark of the Hunt, and the `party_mark` chip labelled "Hunter's Mark".** Shipped, named |

### WHY THE TWO COLLISIONS SHIP WHERE WARD AND TEMPO DID NOT

**THE LINE IS WHETHER THE TWO THINGS MEAN THE SAME THING.** `Ward` meant *takes 50% less Break
damage* — one narrow thing a SHELTER card might do — so a player reading a SHELTER tag beside a
`Ward` chip learns something false. **Hunter's Mark IS a mark and CARRIES the MARK tag.** The word
on the card and the word under it agree, and a reader who conflates them is right. **A same-meaning
collision ships and is named; a different-meaning one is renamed.**

**DEFENSE's is narrower still and is measured rather than argued.** `map_screen._draw_footer`
prints `ITEM_INFO[id][0].replace(" Potion", "")`, so the pouch button reads `Defense` — on the same
screen as the draft card, 1,200 lines away in the same file. **They are never in one visible
frame**: the draft is a full-rect overlay dimming the map at 0.86 alpha, and the tag line is inside
it. **And an item carries no tag**, so nothing can ever render `DEFENSE` and `Defense` on one row.
That is narrower than `Ward`'s exposure (a chip and a tag both inside the battle screen) and wider
than a talent node's.

**THE EXEMPTION IS A LIST COMPARED AS AN EQUALITY, NOT A SKIP.** `check_ek` §4's `CLASH_EXEMPT`
names all six strings; a fifth collision on either word — a new card, node, lane, item or rune —
turns the section red. A `continue` would have hidden a new collision behind an old one.

### THREE HOLES IN THE SWEEP, FOUND AND CLOSED

**THIS IS THE PART OF §3 WORTH READING.** EK reported four clean words and two collisions, and the
sweep it ran could not have seen three whole classes of collision.

1. **LANES.** `_collect_names` walks `LANE_TREES` for `"name"` keys. A lane is a `"lane"` key. So
   `Tempo` sat in **nine** Sharpshooter nodes and one rune while the gate called the tag clean.
   **Talent lanes and rune lanes are both in the population now, and both arms assert their own
   size** (EA §5).
2. **ITEMS.** Absent entirely. `defense` is an item id and its button renders on the draft screen.
   **Items and relics are in the population now.**
3. **THE STATUS-LABEL ARM ASKED THE WRONG QUESTION, AND THIS IS THE ONE THAT MATTERS.** It tested
   `battle_src.contains("[\"Ward\",")` — an **exact whole label equal to the capitalised tag**.
   That catches `Ward` and `Tempo`, whose labels ARE the word, and is **blind to every label that
   merely contains it.** The chip for `party_mark` is labelled *"Hunter's Mark"*. **Under the old
   arm the MARK sweep reported the status half clean while a chip rendered the word.** Every label
   is extracted out of `STATUS_INFO`'s own source block now and word-boundary matched like every
   other population, and the extractor asserts it read ≥150 labels.

**A CHECK WRITTEN AGAINST THE TWO EXAMPLES IN FRONT OF IT PASSES ON BOTH AND ANSWERS NO GENERAL
QUESTION.** That is the whole of hole 3, and it is the same shape as EC's greedy window and DL's
forward `find`.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **THE TAGS STAY MECHANICALLY INERT.** No clause reads a tag count. Zero is still asserted
  separately in `battle.gd`, `unit.gd`, `talents.gd`, `run_state.gd`, `run_sim.gd` and `ability.gd`.
- **NO RUNE IS RE-KEYED.** EJ sized that at 59 clauses across 32 runes; it is the next batch.
- **NO CARD'S BEHAVIOUR CHANGED AND NO MAGNITUDE MOVED.** The only `.gd` code lines that changed
  outside the tag tables are five display strings in `battle.gd`.
- **THE TWO CLOSED AUDIT REPORTS WERE NOT EDITED.** `docs/talent-audit.html` and
  `docs/rune-audit.html` still name Tempo. Both are CLOSED (CV / DN) and kept *"as written — it is
  the evidence of which way each disagreement pointed"*; a rename applied to a closed report
  rewrites the evidence.

### AND `check_ek` §3's POPULATION DID CHANGE, WHICH THE BRIEF FORBADE

**IT CHANGED BY ONE GATE, AND THE FIX WAS NOT AN EXEMPTION.** `check_el.gd` reads `CARD_TAGS` to
derive MARK's population, so it names the tag surface and lands in the sweep. Five became six.

**THE REAL PROBLEM IS THAT ONE NUMBER WAS ANSWERING TWO QUESTIONS.** *"How many files in the
shipped game know what a tag is"* is a claim about the game and is the assertion EK wrote the
section for. *"How many targets check one"* is a claim about the instruments and grows with the
tree. **Rolled into one number, writing a new gate is indistinguishable from breaking the rule** —
the brief's instruction could only have been obeyed by refusing to write a gate, or by weakening
the population to a `>=`.

**THE SECTION IS TWO ASSERTIONS NOW AND THEY FAIL SEPARATELY.** `TAG_DEFINERS` is pinned at
**THREE** — `classes.gd` and `runes.gd` define, `map_screen.gd` displays — and **that number did
not move.** `TAG_CHECKERS` lists the targets and went from two to three. Both are AUTHORED lists,
not a `check_*.gd` glob, so a gate that started doing something else would still have to be
declared here.

---

## §5 — VERIFICATION

### THE NEW GATE, AND THE THREE RULINGS IT ENCODES

**`check_el` — 23 checks.**

- **§1 — MARK IS DERIVED, NOT LISTED.** The small stable half is pinned: the mark STATUSES are
  `battle.DISPEL_NEVER` minus the three its own comment excludes, plus the two the card texts name,
  and `DISPEL_NEVER`'s size is asserted **from outside** so an eleventh mark has to move a line
  here (DW's idiom). **The large drifting half is derived live**: every `_apply_status` site
  writing a mark is found in `battle.gd`'s source, back-walked to its owning card through **both**
  anchors — a `_resolve_special` arm and an `ab.display_name ==` block, because Blood Debt's whole
  payload is the second shape — and the tag table is required to agree **in both directions**.
  *A named list cannot audit itself*, so the card side is not one.
  **The derivation independently reached exactly the ten cards authored in §2.**
- **§2 — `master.html` §6c IS THE CODE'S TABLE.** The section is parsed and its words, their order
  and their meanings are required to equal `TAG_ORDER` and `TAG_INFO` word for word, and the five
  retired words are required to be absent from it. **EH proved that document's factual prose is
  asserted by nothing**, with a two-armed control; this is the one part of §6c that is
  machine-comparable, so it is compared.
- **§3 — THE WIDEST TAG LINE IS MEASURED HERE.** DJ §3: a number quoted from one document into
  another stops being a measurement. `text-standard.html` §4.8a's arithmetic moved when the words
  did — longest word `AFFLICTION` (10) → **`RESOURCE` (8)**, widest possible line 20 → **18**
  (`RESOURCE · DEFENSE`), widest actually produced **18** (`DEFENSE · RESOURCE`). The gate measures
  all three off the live table and fails if the document disagrees.

### THE DISPLAY WAS DRIVEN LIVE

**`check_map_screen` builds the real party draft and walks the drawn tree**: **12 tag lines for 12
offered cards**, every part validated against `Classes.TAG_ORDER`, first line rendered `RESOURCE`.
**A renamed tag that still drew the old word would pass every static check in the tree** — DS's
Heads Down shape — and this is the only thing in the project that would notice.

### PREDICTIONS

| target | before | predicted | **measured** | why |
|---|---|---|---|---|
| `check_ek` | 39 / 0 | 43 / 0 | **43 / 0** ✔ | §3 splits one assertion into two (+1); §4 adds two population assertions (+2) and one more tag to sweep (+1) |
| `check_el` | — | 23 / 0 | **23 / 0** ✔ | new |
| `check_map_screen` | OK | OK | **OK**, 12 for 12, first line `DEBUFF · BREAK` ✔ | the count is 12 for 12 either way |
| `test_batch_ce` | 1114 / 0 | 1114 / 0 | **1114 / 0** ✔ | the glossary entry was rewritten, not added — 98 entries either way |
| `test_batch_ak` `as` `aw` `az` `bn` `br` | green | green, same counts | **green, same counts** ✔ | re-pointed in place; no assertion added or removed |
| **`check_parse`** | 159 / 0 | **not predicted** | **160 / 0 ✘** | **THE ONE MISS.** Its population is derived from `run_battery.sh`'s `GATES`, so its count IS its coverage and `check_el` joining raised it. **The row was not written before the run**, so `check_de` returned one NOTICE where it should have certified silent. Moved after; `check_de` re-reads 354 / 0 / **0** |
| everything else | | unchanged | **unchanged** ✔ | no clause moved |

**THE RULE THAT MISS PAYS FOR, AND IT IS THE SECOND TIME: A BATCH THAT ADDS A GATE OWES TWO
BASELINE ROWS.** The new gate's own, and `check_parse`'s — because that gate's population is
derived from the battery script itself, so **a target joining the battery moves it the same day**.
EK moved it 158 → 159 for exactly this reason and EL wrote the other two rows before the run and
not this one.

### THE BATTERY

**ONE RUN, FROZEN, CLEAN.** 198 files MD5-stamped with absolute paths before and re-compared after:
**ZERO drift** — the tree the battery read is byte-for-byte the tree that ships. **86 targets ran,
the manifest names all 86, there are 86 logs, and no name is duplicated.** **0 `Parse Error` and 0
`SCRIPT ERROR` grepped from every one of the 86 log streams** — never off a tally and never off an
exit code. The only failures anywhere are `check_cm_live`'s four, which are the standing deliberate
reds. **`check_de`: 354 checks / 0 failures / 1 notice → 0 after the `check_parse` row moved.**

### THE CONTROLS — EIGHT ARMED, EIGHT BIT, DISARMED GREEN BEFORE AND AFTER

| control | target | armed |
|---|---|---|
| Covenant of Ash loses MARK | `check_el` §1 | `every card that lays a mark carries MARK (Covenant of Ash)` |
| Fireball gains MARK | `check_el` §1 | `no card carries MARK without laying one (Fireball)` |
| one word of `master.html` §6c drifts | `check_el` §2 | `every meaning is the code's, word for word (RESOURCE: doc … vs code …)` |
| `text-standard.html`'s figure drifts to 20 | `check_el` §3 | `§4.8a states the live widest possible line (18)` |
| `battle.gd` gains a function reading `card_tags` | `check_ek` §3 | **two reds** — the game-half population AND `battle.gd reads no tag` |
| the draft card stops drawing its tag line | `check_map_screen` | `0 for 12 (MISMATCH)`, and **the `OK` verdict withheld** |
| **a status label takes a tag word inside a longer label** (`High Guard` → `High Defense`) | **two-armed** | **HEAD's `check_ek` never named it**; EL's caught `status label:High Defense` |
| **a talent lane takes a tag word** (`Pace` → `Tempo`) | **two-armed** | **HEAD's `check_ek` has no lane arm and reported nothing**; EL's caught `lane:Tempo` |

**THE LAST TWO ARE THE ONLY ONES THAT PROVE ANYTHING ABOUT THE REPAIR.** A one-armed control on a
new arm proves the new code runs. **Arming the same injection against `HEAD`'s copy is what proves
the old code was blind**, which is the claim §3 actually makes.

### THE NEEDLE PROOF ON THE DOCUMENT EDITS

**A RAW SWEEP OF ALL 11,010 GATE-AND-SUITE STRING LITERALS (≥4 chars, comment-stripped) AGAINST
THIRTEEN TRACKED DOCUMENTS, DIFFED HEAD-VS-NOW IN ONE PASS.** **18 LOST, every one traced to its
site and none of them read by the document it left**: 17 are in `docs/state.md` — six `.gd` files
name that path and **all six mentions are comments; nothing opens it** — and the eighteenth is
`spec_draft` leaving a `baselines.json` **`note`** field, which only `check_de` opens and only as
parsed JSON. **0 LOST in `master.html`, `text-standard.html`, `CLAUDE.md`, `data/glossary.json` or
`docs/changelog.html`.**

**AND `check_ed` WAS RUN AGAINST HEAD's OWN MANIFEST BEFORE REGENERATING IT.** It caught **eight
unrecorded `check_el` pins** on that run — the gate working, and the reason the manifest is
regenerated rather than hand-edited.

### THE POST-BATTERY EDITS, AND THEIR PROOF

**FOUR FILES CHANGED AFTER THE FROZEN RUN AND ALL FOUR ARE ACCOUNTED FOR.** Three `.gd` COMMENTS
that still carried retired tag words — `classes.gd`'s *"AFFLICTION · BREAK"* example, `runes.gd`'s
*"SHELTER · METER"*, and `test_batch_ce`'s justification naming AFFLICTION and CLOCK — plus
`baselines.json`'s `check_parse` row.

- **PROVED COMMENT-ONLY**: a comment-stripped diff of `classes.gd` against the copy the battery
  read shows **0 changed code lines**.
- **PROVED NEEDLE-FREE**: no `.gd` in the tree holds any of the removed strings, and the only pin
  on `classes.gd`'s separator is `" · "`, which `check_ek` §5 reads off the **comment-stripped**
  source.
- **RE-RUN**: `check_parse` 160/0, `check_ek` 43/0, `check_el` 23/0, `check_ed` 18/0, `check_ec`
  23/0, `check_da` 41/0, `test_batch_ce` 1114/0, and then a **subset battery — 15 suites and
  ALL 34 GATES** (a named-subset invocation replaces `SUITES` and leaves `GATES` whole).
  **No failures and no throws** except `check_cm_live`'s standing four and `check_de`'s one,
  which is that gate refusing to certify a subset run — *"31 DID NOT (a subset run cannot
  certify the tree)"* — and is it working rather than a regression.

**THE REASON THIS IS WRITTEN OUT RATHER THAN WAVED AT: a comment is an asserted surface in this
project.** A comment-only edit has broken a suite here before, and *"looks harmless"* is not the
standard — a stripped diff plus a needle search plus a re-run is.

---

## §6 — WHAT IS OWED, AND WHAT IS THE DESIGNER'S

- **THE TWO NAMED COLLISIONS ARE A RULING AND CAN BE OVERTURNED FOR ONE WORD EACH.** BRAND, PREY,
  TETHER, BOUNTY and TARGET are all swept clean and would carry MARK's ten cards without a
  collision. DEFENSE's alternatives are the same shape. **Both are one row of `TAG_ORDER`, one row
  of `TAG_INFO`, and a `sed` over the two tables** — the same cost the six renames were.
- **SNARE LINE AND FEINT ARE ONE ROW EACH.** Both are argued above with the alternative.
- **THE HERO SHEET IS STILL RECOMMENDED AND STILL NOT TAKEN** (EK §3's pricing is unchanged). It is
  the one screen where a player reads a whole loadout at once.
- **`docs/talent-audit.html` AND `docs/rune-audit.html` STILL SAY TEMPO.** Deliberate, and it means
  a reader searching those two files for the Sharpshooter's lanes finds the old name. **If the
  designer would rather they carry a header note than be silently stale, that is one line each.**
