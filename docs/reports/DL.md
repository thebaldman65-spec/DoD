# BATCH DL — RALLYING SHOUT'S PRESSURE, AND "PARTY" IS RETIRED

**One card carried two clauses of different shape under one word, and that is how it hid from two
consecutive sweeps.** DJ §2 swept every broad ally-worded text in the project. DK §2 ruled on
eleven of them. **Rallying Shout was in both passes — named, read and ruled — and the clause that
was actually broken was never looked at.**

Not overlooked. **Not visible.** Both sweeps were sweeping for the word *ally*; the broken clause
said *"the whole party"*, which is neither of the two words.

---

## §1 — THE PRESSURE CLAUSE WIDENS. THE RESOURCE CLAUSE DOES NOT.

The card reads:

> *"Raise the line: the whole party sheds 30 Pressure, and every other ally regains 30% of their
> resource."*

**It does two things and only the second was ally-worded.** DK moved that one to *hero* for the
right reason — a companion has no resource bar. **The Pressure half is a different question: a
companion HAS a Break meter**, `pressure` against its own `stability`, and Hold the Line already
widened Break relief to companions on that exact meter one batch ago. So this is consistency with
DK's own precedent rather than a new principle.

**The site takes `_hero_side()`** — the authored name, not a fifth hand-rolled predicate — and
`dead` is excluded for Hold the Line's reason exactly: a corpse has no meter running. The loop
already filtered `not he.dead`; the filter is kept, by name.

### MEASURED ON A LIVE COMPANION, BEFORE AND AFTER

| | beast | hero (the caster) |
|---|---|---|
| **before** | **0** Pressure shed | 30 |
| **after** | **30** Pressure shed | 30 |

**A widening that changes no measurement did not land**, and DK's Tank and Spank is why that
sentence exists in the rule file at all: `empower` attaches to a companion perfectly cleanly and
pays it nothing. So the evidence here is a number off a summoned Ursus, not an assertion about a
collection.

### THE CLAUSES ARE TWO LOOPS NOW, NOT ONE LOOP WITH A FILTER

The old body was a single walk over `heroes` doing both jobs. It is two walks: the Pressure walk
over `_hero_side()`, the resource walk over bare `heroes`. **Each clause's collection is visible
where the clause is read.** A filter hung off a shared union would have put the resource clause's
answer somewhere the resource clause is not — which is the shape DJ §5 counted twenty-three of.

### AND THE RESOURCE CLAUSE GAINED THE GUARD ITS TWO SIBLINGS ALREADY HAD

`resource_name == ""`. Rallying Cry and War Stomp both carry it, and **DK cited its presence as the
evidence for their ruling**. Rallying Shout was the one of the three that lacked it.

**AND DK'S RECORDED REASON WAS HALF WRONG, WHICH IS WHY THE GUARD MATTERS.** It reads:

> *"a companion is built with no `resource_name` and `max_resource` 0, so a refuel restores nothing"*

**`max_resource` is not 0 on a companion.** It is `unit.gd`'s default **100**, never overridden at
the summon — measured on a live Ursus. Nothing depended on it being zero, so nothing failed, and
the sentence sat there reading as an explanation. It would have become load-bearing the first time
somebody widened that loop *"because a beast's bar is zero anyway"* — which would have paid a beast
30 points of a bar it cannot spend and rendered a resource number on a plate that draws none.
**Corrected at the site, in `CLAUDE.md`, and pinned as an assertion in `check_dl` §4** rather than
merely fixed in prose.

---

## §2 — "PARTY" IS RETIRED

**HERO means the four. ALLY means heroes and companions. There is no third word.**

**This is instrumental, not tidy.** A word that means either cannot be swept for, cannot be
checked, and cannot be wrong in a way anybody notices — a text saying "the whole party" is
*unfalsifiable* against its read site, because whichever collection the code walks, the word was
arguably right. **Retiring it is what converts a judgment call into a check.**

Every player-facing use is now *hero* or *ally*, decided by its read site — **and where the group
is the ENEMY side, *warband***, which the game already used in the glossary, the sim and the
encounter themes.

### THE RULES APPLIED, IN ORDER

- **The read site's collection is the test**, not the sentence's rhythm. A walk over bare `heroes`
  says *hero*, with or without an `is_companion` clause.
- **Three further exclusions mean *hero* however the collection is spelled**: stamped once where
  the four are built; per-turn; Faith-flavoured.
- **A clause whose payload a companion structurally cannot receive says *hero*, with its reason
  beside it.**

### WHAT WAS SWEPT

Ability `description` and `perfect_text`, talent node text, status chips, `passive_desc`, class
blurbs, battle-log and `_message` lines, the run summary and the wipe banner, the glossary, the
rune, item, relic and event texts, the map, shop and blacksmith strings, the sim console tables,
and `master.html`.

**The survivors are identifiers and are named**: `party_mark` (a status id), the `party` event
target, `spec_in_party` (an event condition), `party.tscn`. Nothing else.

**Prose ABOUT the game is exempt and history was not swept**: `CLAUDE.md`, the changelog, the
design notes and the batch reports. `docs/text-standard.html` §4.9 keeps the word only where it
NAMES the retired word, which is what a rule statement has to do.

### THE CHECK, AND IT WAS SHOWN TO BITE

`test_batch_bx` §4b — **same place and same construction as §4's "beast" sweep**, which caught
seven live uses in DK before its battery. String literals only, comments skipped, identifiers
stripped by exact token. Its file list is wider than §4's, because "party" reached `relics.gd`,
`events.gd`, `shop_screen.gd`, `blacksmith_screen.gd` and `relics_screen.gd`, which "beast" never
did.

**An instrument added without a control is an instrument nobody has tested.** Three controls, one
per surface class, each reverted clean:

| control | result |
|---|---|
| "party" planted in a live ability description (`classes.gd`) | **1 failure**, naming the string |
| "party" planted in the glossary | **1 failure** |
| "party" planted in `master.html` | **1 failure** |

### THREE FALSE "ALLY"S WERE CORRECTED IN THE SAME PASS, AND THE LINE IS ADMITTED

Aegis Wall's, Exhortation's and Requiem's log lines all say *ally* and all walk `heroes`.
Consecrated Ground's card said *"every ally is kindled 1 Faith"* and `_gain_faith` refuses
companions outright. **Each sat in the same card, or one screen from a text §2 was moving** — and
leaving them would have made those cards *newly* misleading rather than merely imprecise:
"every hero takes 15% less damage … and every ally is kindled 1 Faith" reads as a real distinction
that does not exist.

**Texts with a false *ally* and no "party" near them were reported instead, not ruled.** That line
is arbitrary in the small and defensible in the large; every departure from the batch's one-word
remit is named here.

---

## §3 — THE OTHER CARDS WITH TWO CLAUSES OF DIFFERENT SHAPE

**The brief asked for the list and for no rulings. This is the list.** Every read site below was
derived from the source; none was moved.

| card | the clauses, and why they differ |
|---|---|
| **Bulwark of Fortitude** | **THREE shapes in one sentence.** Break immunity (`unit.take_hit` — a companion has a meter, *receivable*), armor +50% (`unit.effective_armor` — *receivable*), the 10%-a-turn heal (turn-start block — **a companion never takes a turn**), and the cast's instant 5% (*receivable*). Its loop skips companions, so all four are hero today. |
| **Consecrated Ground** | mitigation and reflect are receivable in principle; the Faith kindle is **two exclusions deep** — per-turn *and* `_gain_faith` refuses companions. Its *ally* word was false and §2 corrected it; the mitigation half remains a live question. |
| **Divine Wrath** | +15% damage and +15% speed, and **both die for two DIFFERENT reasons**: the damage term is read at `battle.gd`'s hero strike loop, which `_companion_hit` never enters, and the speed term is read in `effective_speed()`, which only matters to a turn order a companion is never in. **Tank and Spank's finding, twice over in one card.** |
| **Battle Shout** | a group clause (+12% damage, already ruled *hero*) and a **self** clause (+5 Rage to the caster) under one word. |
| **Hold the Line** | the same shape: two ally clauses (DK widened both) and a self clause, "Refunds 5 Rage". |

**AND ONE THAT LOOKS LIKE IT AND IS NOT**, checked rather than assumed: **Sacred Resolve**. Its
split walks bare `heroes` *and* its trigger gates on `is_hero and not is_companion`, so both halves
are hero and the Break carve-out already says *hero* in the card. **One shape, two words, and the
words are right.**

### FOUND IN PASSING, NOT BY A SYSTEMATIC SWEEP

These are texts saying *ally* whose read sites exclude companions. **Each read site is named so the
next batch does not have to re-derive it; none was ruled on.**

| text | read site |
|---|---|
| the Warrior's **Rally** — *"Shout one ALLY forward"* | its picker filters `not a.is_companion` at **three** sites, so it cannot even be aimed at one |
| **Health / Mana / Revive Potion** descriptions — *"one ally's maximum health"*, *"a fallen ally"* | `_use_item` picks from `heroes.filter(not dead)` |
| **Shared Grief**'s log — *"%d ally below half"* | walks `heroes`, skips companions |
| the **Mercy** `passive_desc` and the glossary's `mercy_window` — *"an ally falls below 50%"* | `unit._check_below_half` gates on `is_hero and not is_companion` |
| **Glacial Hold**'s *"+15% damage from EVERY source"* | `_hold_window_mult()` has **one** caller, in the hero strike loop — a companion's jaws never read it. The glossary called it "party-wide"; §2 corrected that half. |

---

## §4 — VERIFICATION

**The documentation was written BEFORE the verification run** — `CLAUDE.md`, `docs/changelog.html`,
`docs/master.html`, `docs/text-standard.html`, `docs/talent-audit.html`, `data/glossary.json` and
`baselines.json` were complete before the battery started. `docs/state.md` and this report are
written after, which is what `check_de`'s re-runnability buys.

### THE NEGATIVE CONTROL ON §1

`check_dl` §3 empties `companions` for the length of one cast — **precisely the pre-DL collection
at this site** — and the beast sheds **0** against **30** with the union standing. And the widening
was reverted in the source as a second control:

| control | result |
|---|---|
| Pressure walk reverted to `heroes.filter(not dead)` (DK's state) | `check_dl` **3 failures**: the source pin, the adjacency pin, and the live measurement reading **0** |

### AND THE HALF THAT DID NOT MOVE IS MEASURED TOO

§4 reads the beast's resource after a cast — **0**, off a **100** bar it cannot spend — and asserts
`max_resource` is NON-zero. **A ruling of the form "we left this narrow BECAUSE the payload cannot
arrive" is a claim about a code path, and a claim about a code path rots.** The day a companion is
built with a real bar, the gate says the ruling is stale instead of staying quietly true.

### THE LITERAL SWEEP CAUGHT TWO BREAKS BEFORE THE BATTERY

Every string literal in the 47 suites and 23 gates was evaluated against the documents and the
sources, before the edits and again after — 9,400 literals, 10,825 present pairs.

| break | what it was, and which way it was fixed |
|---|---|
| `test_batch_bj` §2's `"kindled 1 Faith"` | a **line wrap** split the needle. **The CARD was rewrapped, not the suite** — a cosmetic reflow must not move an assertion. |
| `test_batch_bf` §1's pin on the contribution table's disclaimer | the string genuinely moved (§2 swept the sim console too, so the check needs no exclusion list beyond the identifiers). **The needle followed it.** |

**Nine (literal, document) pairs were LOST in all, and the other seven are accounted for**: five
were prose in `baselines.json`'s own note (nothing asserts on it), and two were `check_dk`'s pins,
re-pointed deliberately — see below.

### `check_dk`'s TWO REFUEL PINS WERE NOT DISCRIMINATING AND WERE EXTENDED

`check_dk` §1's `NARROW` entry for Rallying Shout **pinned the PRESSURE loop as evidence the card
was correctly narrow — while the ruling it was recording was about the RESOURCE loop.** A pin on
the wrong clause of a two-clause card certifies the thing you did not check. Re-pointed at the
resource walk, which is what DK actually ruled.

**And that created a second fault immediately.** Giving Rallying Shout's resource loop War Stomp's
guard made the two loops share their first two lines — **so one fragment matched both, and either
loop could have been deleted with both entries still green.** `check_dl` hit the same thing: a
`find` on the short fragment returned War Stomp's site, 200k characters earlier in the file. All
three pins now carry the line below the guard, which is the one that names the clause.

**Two copies of one fact in two gates is DJ §3's rule**, so the Pressure widening is pinned in
`check_dl` §1 and nowhere else.

### §4a — THE BASELINE PREDICTION, WRITTEN BEFORE THE BATTERY

| target | before | predicted | measured |
|---|---|---|---|
| `check_dl` | — | **24 / 0** | **24 / 0** ✓ |
| `test_batch_bx` | 147 / 0 | **157 / 0** | **157 / 0** ✓ |
| `check_de` | 285 | **289** | **289** ✓ |
| `check_dk` | 64 / 0 | **64 / 0** unmoved | **64 / 0** ✓ |
| every other row | — | unchanged | unchanged ✓ |

**All four movements were predicted and all four landed exactly.**

**`check_dk` staying at 64 is the interesting one**, because two of its entries were rewritten. Its
`NARROW` table changed WHAT it pins, not HOW MANY things it pins — one entry re-pointed from the
Pressure clause to the resource clause, and two entries lengthened so they discriminate. A count
that does not move is the correct outcome, and predicting it is how a silent off-by-one in a pinned
table would have been caught.

**Why nothing else moved, derived rather than assumed.** The literal sweep is the instrument: every
string literal in the 47 suites and 24 gates was evaluated against every document and every edited
source, before and after, over **9,400 literals and 10,825 present pairs**. **Nine pairs were LOST
and every one is accounted for** — two were the suite needles repaired above, two were
`check_dk`'s deliberately re-pointed pins, and five were prose inside `baselines.json`'s own note
field, which nothing asserts on (`check_de` reads its structured fields; `test_batch_cd` names the
file only in a comment). **Nothing else in the tree stopped matching.**

`test_batch_ce` pins the glossary at **97 entries** and one entry's TEXT was rewritten, none added
or removed. The `master.html` stamp moved DK → DL on the self-comparing pattern across 14 suites,
so **no bump is owed**. `check_cl_width` reports rather than gates, and every rewrapped card was
measured against it directly: across `classes.gd` and `talents.gd` the count of `description` and
`perfect_text` lines over the 44-character ceiling is **3 and 0 before, 3 and 0 after**, and the
widest such line is **55 characters before and after**. **Not one card gained a line over the
ceiling, and not one existing overflow got wider.** (The `passive_desc` blocks sit well over 44 by
design — the gate records them as "not draft-card text" — and the widest line DL touched in one got
*shorter*, 52 to 48.)

### §4b — THE BATTERY

**Seventy targets ran and the manifest names all seventy** — sixty-nine at DK, plus `check_dl`.

- **Zero suite failures** across all 46.
- **`throws=0` on every target**, and **0 `Parse Error` and 0 `SCRIPT ERROR` across all 70 logs**,
  grepped from the logs rather than read off a tally or off `$?`.
- **The only red is `check_cm_live`'s four**, which is the standing deliberate one.
- **`check_de` reports 289 checks / 0 failures / 0 NOTICES** — every row matched its baseline in
  both directions.

**NONE OF THE THREE KNOWN FLAKES FIRED**, which is now **seven consecutive quiet readings** on rows
that red about one in eighteen. `test_batch_at` read 467/0, `test_batch_bo` 1025/0,
`test_rune_battle` 97/0. **That is the flake being quiet, not the flake being fixed** — all three
are still open, still unseeded and still banded, and a red from any of them is not this batch's.

**THREE RUNS HAPPENED AND ONLY THE THIRD CERTIFIES ANYTHING.** **Battery 1 completed and is
MIXED** — a cosmetic line-rewrap landed in `classes.gd` after it had started. Every count in it is
honest and all four predictions landed in it, so it is quoted as evidence rather than as
certification. **Battery 2 was killed mid-run**, at `test_batch_bh`, the moment a correction to the
glossary's `hero_vs_ally` entry went in behind it — the entry still listed FIVE effects that say
*ally* and there are six now. **Battery 3 ran against a tree frozen before it began and unedited
until it finished.**

**Killing a run costs twenty minutes; reporting a run whose tree moved under it costs the next
batch its baseline.** A count taken against a tree that changed halfway is not a reading of either
tree, and the manifest exists precisely because "the log says 157" is worth nothing without "and it
was this tree's log". The same rule the manifest enforces per-target applies to the run as a whole.

---

## §5 — WHAT THIS DELIBERATELY DOES NOT DO

- **It rules on none of the six cards in §3.** The brief asked for the list. Ruling on six cards
  inside a batch scoped to one is how a sweep becomes a rewrite, and each of the six wants its own
  measurement on a live body — which is DK's rule, and it is not free.
- **It does not correct the five *ally*-worded texts in §3's second table.** They carry no "party"
  anywhere near them, so they are outside a batch whose remit was that one word. The four that WERE
  corrected are named, with the reason, in §2.
- **It does not give `_companion_hit` an `empower` read**, which is still the one thing that would
  let Tank and Spank say "ally" truthfully. `check_dk` §4 re-measures the 1.0000 every run.
- **It does not re-stamp Devoutness or Last Hope on summon.**
- **It runs no sim.** Five party-wide effects now reach a fifth body in a Beastmaster party, so
  every carried healing and Break figure in `docs/state.md` is stale — **marked as stale there
  rather than left to be quoted as current**, because a number quoted from a document has stopped
  being a measurement.
- **It does not prune `CLAUDE.md`**, which reads 209 KiB of a 6.04 MiB sync (**3.39%**), still over
  CW's own target and still roughly flat rather than rising.
