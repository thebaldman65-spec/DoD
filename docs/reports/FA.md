# BATCH FA — TWO RULINGS EZ LEFT OPEN

Small batch, and both items are the designer's rulings on things Batch EZ **built literally and
reported rather than patching**. Nothing here is a discovery about what the game should be; the
two decisions were made before the batch started. What the batch owed was the implementation, the
measurement EZ flagged and did not take, and an honest account of where the reasoning behind a
ruling does not survive contact with the code.

**Two of the brief's own premises did not survive that check, and both are recorded at the point
they bite.** Neither changed what was built.

---

## THE BRIEF'S PREMISES, RE-DERIVED

The brief opens by telling me to verify every premise, because EZ found six of its own predecessor's
wrong. Here is that pass. **Nine premises, seven confirmed, two false.**

| premise | verdict |
|---|---|
| `threshold_met([])` is `0 * 2 >= 0` and passes | **CONFIRMED** — `Classes.primary_tag_count([], t)` is 0, `[].size()` is 0 |
| `breadth_met_fraction([])` is `0 * 3 <= 0` and passes | **CONFIRMED** — `primary_tag_peak([])` returns 0 (`top` starts at 0 over an all-zero census) |
| a player can bench everything | **CONFIRMED** — `Run.unequip_earned_ability` has no floor; it refuses only a card not carried or not earned |
| `check_ez` §1 asserts the vacuity in the direction it is true | **CONFIRMED** — line 250, and its comment says why |
| Hex of Ruin is 20% of Attack against three chosen enemies | **CONFIRMED** — `{"damage": 20, … "choose_three": true}` |
| the rune already pays 1 Ruin a target instead of 2 | **CONFIRMED** — `battle.gd`, the Wrath branch: `if attacker.rune_split_tongue > 0 and ab.display_name == "Hex of Ruin": _gain_ruin(strike_target, 1)` |
| Bracing Line stands at 32 | **CONFIRMED** — `const BRACING_LINE_LEVEL := 32` |
| **"four on the fixture's warbands, six or more on the elite and mini-boss rosters `compose` floors"** | **FALSE.** See §2b. `compose` floors the **budget** at 6, not the count. Elite rosters are **three enemies** at tiers 1 and 4, on every draw. |
| **"the fix is one clause"** | **FALSE, and the reason is the ruling.** It is two, in two functions, and putting it in one would have left both screens drawing a ✓ on a bar the rune was refused for. See §1a. |

---

## §1 — AN EMPTY DRAFTED LOADOUT MEETS NEITHER CONDITION

**Ruled: both conditions require at least one drafted card. Built.**

`Runes.threshold_met` and `Runes.breadth_met_fraction` each gain `if drafted.is_empty(): return false`.

### **§1a — THE GUARD'S PLACE WAS THE DECISION, AND THE BRIEF'S "ONE CLAUSE" IS THE WRONG SHAPE**

There are two places the clause could go, and they are not equivalent.

**`loadout_condition_met` is the cheaper one and it is wrong.** It is the one door a rune's payload
comes through, so a single clause there closes the rune. But it is **not** the door the screens come
through: `party_screen._draw_detail` and `map_screen._open_loadout_panel` call `threshold_met` and
`breadth_met_fraction` **directly**, for the tick they draw beside the `RUNE CONDITIONS` line. A
guard at the door alone would refuse the rune while both screens went on showing a ✓ on an empty
bar — **one fact rendered two ways**, which is precisely what the ONE BUILDER rule written above
`threshold_line` exists to prevent, one layer down.

So it is two clauses, in the two predicates, and **the screens and the condition cannot disagree.**

**And the now-redundant line at the door is kept, labelled, rather than deleted.**
`loadout_condition_met` already had `if member.is_empty(): return false`. That line was load-bearing
only while the arithmetic read generously — it was the one thing between a member-less caller and an
unconditional payload. Both predicates now refuse an empty list themselves, so it is redundant. It
stays because **a caller with no member is a different fault from a hero who benched his bar**, and
because its old comment claimed the emptiness *"is checked here and not left to the arithmetic"* —
a rationale that would have outlived its reason. The comment says what is now true instead.

### **§1b — THE REACHABILITY IS WIDER THAN THE BRIEF SAYS, AND THE SECOND ROUTE IS THE ORDINARY ONE**

The brief and EZ both name benching as the way in. There is a second and it needs no player action
at all.

`Run.equipped_ability_names` is the **earned** subset, and its own comment says what that means:
*"a hero who has drafted nothing carries a full bar through it that reads EMPTY."* A hero at the
start of a run has his protected core and nothing else, so **`drafted_names` returns `[]` for him
exactly as it does for a hero who benched everything.**

**For a THRESHOLD rune, the degenerate state was the opening state of every run** — not an exotic
configuration a player had to construct. That does not change the ruling; it raises how much the
ruling was worth.

### **§1c — HEAD'S OWN GATE FOUND A DEPENDENCY NOTHING ELSE WOULD HAVE, AND THIS IS THE BATCH'S MOST TRANSFERABLE FINDING**

`check_ez` §1 asserted the vacuity deliberately, in the direction it was then true, *"so the day it
is changed the gate says so."* **Before editing a single assertion, I ran that gate unmodified
against the new code.**

```
HEAD's check_ez (96 checks) vs FA's runes.gd  ->  96 checks / 3 failures
  FAIL: §1: an EMPTY drafted list meets both, vacuously — the literal reading, on the record
  FAIL: §4: every payload lands its field (["answering_pack: rune_answering_pack did not land",
        "bracing_line: …", "deepening_hex: …", "heavy_bolts: …", "long_watch: …",
        "shared_scent: …", "wide_rite: …", "wide_watch: …"])
  FAIL: §4: 13 of 21 landed
```

**The first red is the one EZ predicted. The second and third are not, and they are the batch's
real work.** §4's *condition MET* arm was `_member("mage", "occultist", [])` — **an empty drafted
list, for all twenty-one payloads** — and its comment said so: *"An empty drafted list meets both
vacuously (§1), which is exactly what makes it the right MET arm here."* It worked only because of
the thing this batch closes. Close the vacuity and **all eight gated runes stop landing**, and the
gate reports twenty-one payloads as broken.

**Nothing in the diff points at it.** The arm reads as an ordinary `_member(...)` call and §4 does
not mention emptiness anywhere. The first thing that would otherwise have found it is a
forty-five-minute battery, after the freeze — the exact position DL discarded two runs from.

**It is a standing rule in `CLAUDE.md` now**: run HEAD's own gate against the new tree before
re-pointing it, and the reds you did not predict are the dependencies.

### **§1d — WHAT §4's ARM IS NOW, AND WHY IT IS TWO ARMS RATHER THAN ONE**

`_met_drafted(cond)` builds a real loadout per rune. **The two shapes cannot share one**, which is
worth stating because it looks like duplication: "at least half carry the tag" and "no tag holds
more than a third" are opposite statements about the same peak, so no single list satisfies both.

- **THRESHOLD** → four cards whose primary is the named tag. Four of four is past half at every
  loadout size. §1 owns the boundary, on both sides, at 4, 5 and 7 drafted cards; this arm is about
  the payload landing.
- **BREADTH** → a 2/2/2 six across DEBUFF, DEFENSE and BREAK. A peak of **exactly** a third, which
  §1 asserts passes — so the arm sits **on** the boundary rather than comfortably inside it.
- **UNGATED** → still the empty list, deliberately: a payload with no `condition` must land for a
  hero with no drafted cards at all, and that is the arm that says so.

The corpus supplies all of it — 68 DEBUFF / 56 DEFENSE / 54 BREAK / 17 RESOURCE / 16 OFFENSE /
8 MARK / 8 TEMPO primaries across 227 tagged names — including the four MARK cards Heavy Bolts needs.

**And the arm is checked before it is used.** One assertion per gated rune says the loadout just
built really does meet the condition. Without it, a wrong `_met_drafted` would report twenty-one
broken payloads rather than one broken arm — a rebuilt arm is new code in the gate and gets no more
trust than the code it is testing.

### **§1e — THE ASSERTION INVERTS, IT IS NOT DELETED**

EZ's one-line vacuity check becomes five:

- the empty list does **not** meet the threshold, and does **not** meet breadth — **two assertions,
  because FA rules BOTH closed** and one compound check would go green on either half;
- a hero benched to zero drafted cards, driven through **the live door**
  (`loadout_condition_met`), refused for both shapes — because the door is what a rune is actually
  gated on, and the arithmetic passing is not the same claim;
- and **one arm on the other side of the new clause**: a single drafted card of the named tag is
  1 of 1 and still meets the threshold. That one exists so the guard is proved to test **emptiness**
  and not to have quietly changed the rule.

---

## §2 — SPLIT TONGUE'S DAMAGE GOES 20% → 12% OF ATTACK

**Ruled: 12%, on the `aoe` version only. Built.**

```json
"payload": {"ability": "Hex of Ruin", "set": {"aoe": true, "damage": 12},
            "also": [{"stat": {"rune_split_tongue": 1}}]}
```

**The reduction rides the same `set` the widening does**, which is what makes it the rune's version
rather than the card's. `Talents.apply_payload` matches on `display_name` and assigns; an Occultist
without the rune never reaches it and keeps 20% against three.

**The base is confirmed untouched by assertion rather than by inspection.** `check_ez` §5 finds
Hex of Ruin on the live spawned Occultist and asserts `damage == 20 and not aoe and choose_three`
**first**, then applies the rune's own payload and asserts 12 and `aoe`. `data/classes.gd` was not
edited; the card's authored description still reads *"Curse THREE chosen enemies: 20% of Attack…"*,
which is the same convention the Pandemonium talent already ships under — that talent also makes
Hex of Ruin `aoe` while the card text says three, and the talent's own text is where the change is
stated. **A hero with Pandemonium but no rune keeps 20%.**

**`choose_three` survives on the rune's Ability and is DEAD, and that is pinned.** `_resolve` reads
`if ab.aoe: … elif ab.choose_two or ab.choose_three`, so `aoe` wins the branch and the flag beside
it never runs. It is asserted as surviving-and-dead so a later batch reading the field does not
conclude the card still picks three.

### **§2a — THE MEASUREMENT, AND IT DOES NOT SUPPORT THE REASON GIVEN FOR 12% OVER 10%**

The brief asked for damage per cast with and without the rune, at a four-enemy warband and at an
elite roster, because *"neither number exists yet."* Here they are.

**Method.** Attack 100 for a clean denominator. Twenty casts an arm. **Each arm on its own board**,
and every trial resets hp, statuses, Break and Broken before the cast. **Both are load-bearing:**
`ruin` and `exposed` are statuses, so Hex of Ruin softens the board it is measuring — the first
reading of this probe ran WITHOUT first and handed WITH an already-Exposed, already-Ruined board,
and reported ×1.15 at four enemies where the truth is ×0.79. **Every size was then run in both
orders as a control**, and the two agree to within 0.01.

| board | without | with | **damage** | Break without | Break with | **Break** |
|---|---|---|---|---|---|---|
| 3 enemies | 50.6 over 3 | 30.9 over 3 | **×0.61** | 45 | 45 | ×1.00 |
| 4 enemies | 51.1 over 3 | 40.5 over 4 | **×0.79** | 45 | 60 | ×1.33 |
| 5 enemies | 51.0 over 3 | 51.8 over 5 | **×1.02** | 45 | 75 | ×1.67 |
| 6 enemies (the board cap) | 51.6 over 3 | 60.9 over 6 | **×1.18** | 45 | 90 | ×2.00 |

*Order control, the same arms run the other way round: ×0.80 / ×1.00 / ×1.19 / ×0.61.*

**The ruling's stated reason for 12% rather than 10% was that halving *"risks making it a downgrade
against the four-enemy warbands a player meets most."* At 12% it is already that downgrade** — a
21% loss in damage per cast at four enemies, and a 39% loss at three.

**The break-even is arithmetic, not noise**: N × 12 = 3 × 20 at **N = 5**, and the measurement lands
on ×1.02 there. To be an upgrade at four the field would need to be **15**; to be an upgrade at
three it cannot be done by lowering damage at all, because the rune strikes the same three enemies
there and any reduction is a pure loss.

**Break pressure moves the other way, and it is the half nothing has priced.** The rune spreads 15
Break **and an Exposed** to every enemy instead of three — ×1.33 at four, ×2.00 at six. Whether that
plus the halved Ruin cost pays for a 21% damage loss at the commonest board is a play question with
a real number under it now.

**No magnitude was changed on this finding.** 12% is the designer's ruling, it is built exactly as
ruled, and the number is put beside it. A magnitude is the designer's; a measurement is the batch's.

### **§2b — AND THE BOARD THE NERF WAS PRICED FOR IS NOT THE BOARD THE GAME FIELDS**

The brief's reason for the nerf is that the rune makes Hex of Ruin `aoe` — *"four on the fixture's
warbands, six or more on the elite and mini-boss rosters `compose` floors."*

**`compose` floors the BUDGET, not the count.**

```gdscript
if node_type in ["elite", "miniboss"]:
    budget = maxi(budget, 6)
```

Six *points of budget*. A budget of 6 buys three power-2 enemies, and `_theme_combos` is what
actually decides the count. Measured over **200 compositions at each of six tiers**:

| tier | elite | mini-boss |
|---|---|---|
| 1 | **3.00** (200×3) | **3.00** (200×3) |
| 4 | **3.00** (200×3) | **3.00** (200×3) |
| 8 | 3.12 (176×3, 24×4) | 3.12 (177×3, 23×4) |
| 11 | 3.40 (140×3, 41×4, 19×5) | 3.37 (137×3, 53×4, 10×5) |
| 14 | 3.67 (96×3, 82×4, 13×5, 9×6) | 3.81 (75×3, 94×4, 24×5, 7×6) |
| 16 | 4.87 (1×3, 81×4, 61×5, 57×6) | 4.79 (94×4, 54×5, 52×6) |

**Elite and mini-boss rosters are three enemies at tiers 1 and 4 — every single draw.** They reach
a mean of 4.87 only at the last tier of a zone.

**So the large board the rune was nerfed for is mostly the small board where the nerf costs the
most** — ×0.61 at three. **And the board itself caps at six**:
`ENEMY_LAYOUTS[clampi(composition.size(), 1, 6)]`, so a seventh enemy would index past the layout
array. **×1.18 is the ceiling this rune can ever reach**, at a roster the game fields on roughly a
fifth of tier-16 elite draws.

Both of those are standing rules in `CLAUDE.md` now, because a floor on a budget reading as a floor
on a count is a mistake anything pricing an AoE magnitude will make again.

---

## §3 — WHAT IS DELIBERATELY NOT DONE, READ OUT OF THE TREE AFTER THE BATCH

- **Bracing Line stays at 32.** `const BRACING_LINE_LEVEL := 32`, unmoved.
- **The Shared Hide's named list stands.** The batch that extracts the ~84-term hero block into a
  callable is the one that re-points that rune. The list did not grow.
- **No other rune, magnitude, constant or ability moved.** `SC_PROFILE_DEFAULT`,
  `CRIT_EXCESS_STEP` (0.50), `BOND_CONVERT` (8), `BOND_MITIGATION_MAX` (0.75), `SHIELDWALL_BLOCK`
  (25), `SS_SEQ_OPEN` (four entries) and `SS_SEQ_TAPER` (0.85) — all read back unchanged.
- **No new rune is authored.** The pool is 86 entries: 65 retired, 21 live. Eight specs and the
  class runes are still unwritten.
- **`data/runes.json` moved one payload and one desc.** No other entry moved a byte.

---

## §4 — THE CONTROLS, AND ALL THREE BIT

**Every one is armed on something a target demonstrably reads, and the disarmed state was confirmed
red before the armed state was trusted.**

| control | what it does | result |
|---|---|---|
| **A — the §1 guard** | both `is_empty()` clauses removed, restoring EZ's exact predicates | `check_ez` **113 / 3** — the three §1 assertions by name |
| **B — the §2 damage** | HEAD's `data/runes.json`, which **is** the disarmed payload, against FA's gate | `check_ez` **113 / 1** — `§5: Split Tongue takes it to 12% of Attack (reads 20)` |
| **C — HEAD's gate vs FA's code** | the second arm of A: the same change, judged by the assertion written before it | `check_ez` **96 / 3** — §1c above |

**A and C are one repair armed in both directions**, which is the shape this project has been caught
by before: A alone proves the new code satisfies the new gate, which is not the same claim as the
behaviour having changed. C is the arm that says the behaviour moved, and it is judged by an
assertion written before the change existed.

**Every file was restored from a pre-control copy and the restore was md5-verified rather than
assumed** — `scripts/runes.gd`, `check_ez.gd` and `data/runes.json`, all three matching their
pre-control digests, and `check_ez` re-run to 113 / 0 afterwards.

---

## §5 — THE INSTRUMENTS

**The literal sweep — 16,218 needles from 125 `.gd` files.** Every string literal of four characters
or more written anywhere in the corpus, extracted with backslash escapes resolved (a `.gd` literal
`"he said \"no\""` is the text `he said "no"` in a document — the hole EZ's own scan-window census
fell into), format-bearing literals separated out so they do not inflate the denominator.

**LOST 0 in every document.** 1,338 needles in `changelog.html`, 1,301 in `CLAUDE.md`, 1,811 in
`master.html`, 1,245 in `design-notes.md`, 952 in `state.md`, and the five other surfaces unmoved.

**25 GAINED across four documents — 14 distinct — and no negative assertion anywhere touches one.**
303 negative `contains` assertions were swept out of the corpus (flattened first, so one split
across a line continuation is still seen). Zero match a gained needle exactly. **One matches by
containment**: `test_batch_bd.gd:165` asserts `not ab.perfect_text.to_lower().contains("choose")`,
and `choose_two` contains `choose` — but that is **an Ability's `perfect_text`, not a document**,
so no document edit can reach it. Exact-match sweeps are blind to containment, which is why the
containment direction is swept separately.

**AND THE SWEEP WAS ARMED BOTH WAYS BEFORE IT WAS BELIEVED.** A green sweep over prose nothing reads
is indistinguishable from a green sweep over prose everything reads. `THE ABILITY DRAFT` was chosen
**out of the needle list**, replaced in `master.html`, and:

- the sweep read **LOST 1**, naming it; and
- `test_batch_bo` §6 went **red** on it — `...and carries the draft's own section`.

The second half matters because that assertion is an **OR-group**
(`master.contains("THE ABILITY DRAFT") or master.contains("The Ability Draft")`), and a needle
inside an or-group can be inert. It was not: both arms were false and the suite failed.
`master.html` was then restored and md5-verified.

**AND THE SWEEP HAD A GAP OF ITS OWN, WHICH IS RECORDED RATHER THAN QUIETLY CLOSED.** The
`LOST 0` above is the comparison across the changelog, `CLAUDE.md`, `master.html` and
`design-notes.md`. **`docs/state.md` was rewritten AFTER that second snapshot was taken**, so its
rewrite was never inside the before/after pair — the sweep would have reported a clean zero for a
file it had not compared, which is the exact shape of a check that prints like a clean one while
measuring nothing. Re-run **before-all-edits against final**, `state.md` reads **LOST 10**:
`Empower`, `Shieldwall`, `map_screen.gd`, `party_screen.gd`, `the block roll`, `unreachable`,
`docs/text-standard.html`, `FREE`, `final`, `party_screen`.

**All ten are EZ's WHERE block, replaced by FA's, in the one document whose contract is that it is
rewritten every batch and never appended to** — and **nothing reads that file.** Every mention of
`docs/state.md` anywhere in the corpus is inside a comment; no `FileAccess`, `_src`, `load(` or
`open(` call in any `.gd` file opens it. The empirical half is stronger than the grep: **the battery
ran on the rewritten `state.md` and all 93 targets were green.**

**THE POST-RUN EDIT IS ONE FILE AND IT IS PROVED HARMLESS RATHER THAN ASSUMED.** The only thing
added to the tree after the battery is this report. The 337 frozen files are byte-identical to their
pre-battery stamp *after* it was written. Its 272 gained needles were swept against all 303 negative
assertions: **eleven match**, and every one of the eleven is an assertion against something that is
not a document — a `.gd` function body, an Ability's `description` or `perfect_text`, a statement
inside a source scan. **None of the eleven needles was gained in any document a target opens**;
all eleven landed in this report alone.

**The measurement probe was written, run, and deleted before the freeze**, so it is not in the tree
and does not appear as `check_parse` residue.

---

## §6 — THE VERIFICATION RUN

### **§6a — THE FREEZE**

An md5 stamp of **337 files, absolute paths, tracked and untracked**, taken before the run and
re-taken after it over **the same path list**: **zero differ.** A relative-path stamp is worthless
here — a moved working directory between the two reads the whole tree as drifted — and a list built
from `git ls-files` alone would have missed anything untracked, which is how a report file has
escaped a freeze before. The tree carried no untracked file during the run, and the measurement
probe was deleted before the stamp was taken rather than after.

**Nothing was repaired while the battery ran.** There was nothing to repair: the run was clean.

**TWO EDITS LANDED AFTER THE RUN AND BOTH ARE NAMED RATHER THAN FOLDED INTO THE "ZERO DIFFER".**
Re-stamped once more at the end of the batch, **336 of the 337 are still byte-identical** and
exactly one is not: **`docs/state.md`**, whose §5 bullet was extended to record the sweep gap below
so the next batch does not have to re-find it. Measured against the copy the battery actually read,
that edit is **LOST 0, GAINED 1** — and the gained needle is `final`, one of the ten the same file
had lost. The other post-run addition is this report. **Neither file is opened by any target**, and
the claim about the run itself is the first stamp pair, not this one: **zero differ across all 337
while the battery was running.**

### **§6b — THE BATTERY**

**93 targets. `sort .ran | uniq -d` → ZERO duplicates. 0 `Parse Error`, 0 `SCRIPT ERROR` and 0
timeouts across all 93 logs**, swept by grepping every log rather than by reading any target's own
tally — a suite that throws is not a suite that passed, and an exit code says nothing about either.

| target | result |
|---|---|
| `check_ez` | **113 / 0** |
| `test_runes` | **3804 / 0** |
| `test_rune_battle` | 97 / 0 |
| `check_es` | 44 / 0 |
| `check_et` | 24 / 0 |
| `check_ek` | 46 / 0 |
| `check_parse` | 167 / 0 |
| `check_ed` | 18 / 0 |
| `check_de` (the count differ) | **382 / 0 / 0 notices** |

**Two lines in the run are not `fails=0`, and neither is a fault:**

- **`check_cm_live` 13 / 4** — the sanctioned red. Its four FAIL lines are the four its baseline row
  names (*"the only thing pressing the defensive bar"*, `fails: [4, 4]`): the bar appearing on the
  enemy's attack, its top line naming the incoming blow, and the brace's two magnitudes. **This
  batch touched nothing in that area**, and the lines are compared rather than the count.
- **`check_cl_width` `checks=? fails=?`** — its baseline row carries `checks: null, fails: null`. It
  reports no readable count by design, which is what its row records.

**AND THE COUNT DIFFER IS NOT VACUOUS ON THE TWO ROWS THAT MOVED**, which matters because a
baseline edited to match whatever the code happens to do is worse than no baseline. `check_de`
names them both:

```
  check_ez                    113 checks /   0 failures   (recorded 113 / 0)   obs 3/3
  test_runes                 3804 checks /   0 failures   (recorded 3804 / 0)   obs 3/9
  92 of 92 recorded targets swept, 0 off their recorded line
```

**Both rows were written BEFORE the battery**, off three identical standalone readings and with the
delta counted off the diff rather than guessed — `check_ez` +17 as §1 +4 / §4 +8 / §5 +5, and
`test_runes` +1 as the single `_int_restore` assertion Split Tongue's new `set` field creates.

---

## §7 — WHAT MOVED

**TWO GAME FILES, ONE TARGET, ONE TABLE AND SIX DOCUMENTS.**

- **`scripts/runes.gd`** — the two `is_empty()` guards, and three comment blocks. One of those is a
  **stale rationale corrected rather than left standing**: `loadout_condition_met`'s comment said
  the emptiness *"is checked here and not left to the arithmetic"*, which was true only while the
  arithmetic read generously.
- **`data/runes.json`** — Split Tongue's payload gains `"damage": 12` inside the `set` it already
  carried, and its `desc` names the new number. **One entry; no other moved a byte.**
- **`check_ez.gd`** — **96 → 113.** §1 +4 (the inversion, split in two because both conditions are
  ruled, plus the live door and the one-card arm), §4 +8 (the MET arm checked, once per gated
  rune), §5 +5 (Split Tongue's damage, base first). Two helpers added: `_cards_of`, `_met_drafted`.
- **`baselines.json`** — two rows, `check_ez` 96 → 113 and `test_runes` 3803 → 3804, each with its
  arithmetic in the note. **Zero line churn**: the file is `indent=1` and was edited surgically.
- **`docs/changelog.html`**, **`CLAUDE.md`** (one standing rule inverted, two added),
  **`docs/master.html`** and its stamp, **`docs/design-notes.md`**, **`docs/state.md`** (the WHERE
  block rewritten, not appended to), and this file.

**`test_runes` 3803 → 3804 is one check in one section, counted off the diff.** `_int_restore` loops
`["add", "set"]` asserting that every field in `Runes.AB_INT_KEYS` survived JSON as an INT rather
than a float. `damage` is one of those keys, so the new field is one new assertion — **and it
passes**, which is the half worth recording: the int-restore machinery already covered a `set` field
and needed no extending.

**`UNSCALABLE` did not move, deliberately.** `split_tongue` is still a member for `comet`'s reason —
a `set` is an absolute assignment the power arm correctly refuses to scale, and 12 is no more
scalable than the flag beside it. Its comment quotes the payload and now quotes the current one.

---

## §8 — WHAT IS OWED, AND TO WHOM

**TO THE DESIGNER — one number, with a measurement under it.**

**Split Tongue's 12% is built as ruled and it is a damage downgrade on every board below five
enemies**, which is most of them: ×0.61 at three, ×0.79 at four. The reason given for choosing 12%
over 10% — that halving *"risks making it a downgrade against the four-enemy warbands a player meets
most"* — is not met by 12%. **15% is the field that breaks even at four**; at three enemies no
damage reduction can avoid being a pure loss, because the rune strikes the same three targets there.
**Against that sits the Break, which nothing has priced**: ×1.33 at four and ×2.00 at six, plus an
Exposed on every enemy instead of three, plus the halved Ruin cost. **That is a play question and
the numbers for it now exist.**

**And the roster premise is worth carrying forward on its own.** Anything that prices an AoE
magnitude against "the elite board" is pricing it against **three enemies** up to tier 8. The board
caps at six. `compose`'s `maxi(budget, 6)` will read as a count again.

**NOT OWED, AND SAID SO:**

- **Nothing about §1 is open.** Both conditions are closed, the guard is in the place the screens
  read, and the gate asserts the new direction.
- **The base Hex of Ruin is untouched and asserted so**, on the live Ability, before the payload.
- **`choose_three` is dead on the rune's version and is pinned as such**, so it does not read as a
  live target-selection rule to the next batch that meets it.
