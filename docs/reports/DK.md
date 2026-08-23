# BATCH DK — THE ELEVEN ALLY-WORDED EFFECTS, RULED

**DJ §2 swept every broad ally-worded card and node and found eleven besides Harvest walking bare
`heroes`, which holds no companion — and ruled on none of them**, because an exclusion that is
INTENDED wants its TEXT corrected and one that is ACCIDENTAL wants its CODE corrected, and that is
a designer's call rather than a sweep's.

**DK is that ruling. The eleven split FOUR and SEVEN.**

**AND THE BRIEF'S §1 WAS WRONG ABOUT ONE OF THEM, WHICH IS THE CARE OF THIS BATCH.** It listed
five to widen. **Tank and Spank was measured rather than assumed and it does not widen** — the
status lands on a companion perfectly cleanly and pays it *nothing*. Its text moved instead.

---

## §1 — THE FOUR THAT WIDEN

**Rally, Hold the Line, Sanctuary and Field Medic read `_hero_side()`.**

Every one was verified to ARRIVE on a live summoned bear rather than asserted to be reachable.
`check_dk` §2 measures all four on every battery run:

| effect | what a beast receives | before |
|---|---|---|
| **Sanctuary** | healed **1200** of a 10000 body — the 12% the card promises | **0** |
| **Hold the Line** | a 40-BD blow banks **20** (the base 50% cut; 8 under the upgraded 80%), and `undying` holds it at **1 HP** through a lethal blow | **40**, and it died |
| **Rally** | a 1000 heal becomes **1300** | 1000 |
| **Field Medic** | a poisoned beast is in his pool, and the wash takes the affliction off | not in the pool |

**KNOWN AND ACCEPTED: under The Pack this reaches six units instead of four**, so four party-wide
effects get roughly 50% more coverage in that build alone. That is a deliberate buff to one build.
*"Your bear doesn't get healed by the party heal"* is a rule players discover by being confused.

### THE `dead` DECISION, TAKEN AT EACH SITE ON ITS OWN TERMS

**All four exclude the dead, and all four say so by NAME rather than by a fifth hand-rolled copy of
the predicate.** `_hero_side()` is the project's authored name for "the union, living only", and
its own comment already reads *"everything enemies can target / allies can help"* — which is
precisely what a receive-site is.

The reasons are not one reason four times:

- **Sanctuary** — a corpse is *revived*, not healed. Different verb, different ability.
- **Hold the Line** — a corpse has no Break meter running, and cannot be held from a death it has
  already taken.
- **Rally** — the `if not h.dead` guard was already inside the loop; it is kept, not dropped,
  because there is no healing to deepen on a body that takes none.
- **Field Medic** — the sharpest of the four, and not the same reason at all: **the pick is
  RANDOM out of the pool**, so a dead body in it would spend one of his two washes on nobody.

**HARVEST IS THE COUNTER-CASE AND WAS DELIBERATELY NOT DRAGGED ALONG.** It asks who *opened* a
wound, and a hero who has since fallen still opened it — so it keeps its union spelled out and
filters nothing. Both shapes are `heroes + companions`; only one filters `dead`. `check_dk` §1
re-asserts that Harvest still spells its union out, because a receive-site's answer is not
Harvest's answer. (DI proposed `_hero_side()` *for Harvest* one batch ago; it would have dropped a
fallen opener's board to 0.6664.)

**The rule that falls out of this is now in `CLAUDE.md`:** a site asking who RECEIVES an effect
takes `_hero_side()`; a site asking who *did* something takes `heroes + companions`.

---

## §2 — THE SEVEN THAT CHANGE ONLY THEIR WORDS

**No read site moves. The texts say "hero", and the REASON is recorded beside each one in the
source** — "hero" alone is a decision the next author re-litigates.

| effect | reason recorded at the site |
|---|---|
| **Rallying Cry**, **War Stomp** | a companion is built with no `resource_name` and `max_resource` 0, so a refuel restores nothing — both loops already carried a `resource_name == ""` guard, and the word now agrees with it |
| **Rallying Shout** | same, for its resource clause — **and see below, because this card is not the pure refuel the other two are** |
| **Cleansing Waters** | it rolls per-TURN on the acting unit; `_next_unit()` walks `heroes + enemies` and a companion is summoned with `next_time = INF`. **Structural** — no collection anywhere reaches it, so "fixing the code" means moving the effect off turns entirely |
| **Devoutness**, **Last Hope** | stamped ONCE in the party-spawn block, before any companion exists. **Both effects are receivable** — a beast wearing `devotion` at 20 banks 32 Break from a 40-BD blow — so the obstacle is the stamp's TIMING, and reaching it wants a re-stamp on summon |
| **Tank and Spank** | §3 |

### ONE THING THE BRIEF GROUPED WRONG, AND IT IS RECORDED RATHER THAN RULED

**Rallying Shout is not a pure resource refuel.** The brief listed it beside Rallying Cry and War
Stomp under *"a beast has no resource bar, so including it would restore nothing"*. Its card reads:

> *"Raise the line: the whole party sheds 30 Pressure, and every other ally regains 30% of their
> resource."*

**It does two things and only the second was ally-worded.** The resource half is a hero's for the
stated reason. **The Pressure half is a different question**: a companion HAS a Break meter and can
plainly shed it, so *"the whole party"* is arguably false today — but **"party" is not one of the
two words DJ §2 swept**, and ruling on it is a new ruling rather than this batch's. Only the
ally-worded clause moved. **Recorded as owed.**

Writing "hero because a beast has no resource bar" beside this card without that caveat would have
been a rule the next author could apply *and get wrong*, which is the whole point of recording
reasons rather than words.

---

## §3 — TANK AND SPANK WAS THE FIFTH TO WIDEN, AND IT WAS MEASURED INSTEAD

**It says "Empowers a random ally", it walked bare `heroes`, and `CLAUDE.md` cited it as the proof
the hero/ally distinction is worth having.** It was the most obvious of the five.

**WIDENING IT WOULD HAVE BEEN A NO-OP.**

`empower` attaches to a companion perfectly cleanly — the status applies, the chip renders, the
tooltip reads. **The payout never arrives.** A beast's blows resolve through `_companion_hit`,
which is its own damage path and reads none of the hero strike loop's multiplier block.
`battle.gd` already said so from the other side, 180 lines below the `empower` read, at the
`last_howl_dmg` site:

> *"a beast's blows go through `_companion_hit`, which never reads this block, so the companions
> are correctly untouched."*

**MEASURED over 40 seeded blows with the chip standing: 34392 damage against 34392 — ratio exactly
1.0000.** (The battery's own run reads 30771 against 30771 on its board; the ratio is the claim,
not the total.)

**So the brief's §1 premise — *"nothing in the code ever said it shouldn't"* — was false for this
one.** Something in the code said exactly that, in a comment, in the same function.

### THE RULING IS PINNED AS A MEASUREMENT, NOT AS AN ASSERTION

`check_dk` §4 re-reads that ratio on every battery run. **A ruling of the form "we left this narrow
BECAUSE widening would pay nothing" is a claim about a code path, and a claim about a code path
rots.** Pinned this way, the day somebody gives `_companion_hit` an `empower` read, the gate says
the ruling is stale instead of staying quietly true.

### AND THE WORKED EXAMPLE IS REPAIRED AS LOUDLY AS THE RULE

`CLAUDE.md` cited `wd_tank_spank` as the proof the distinction works. **The distinction IS worth
having; this was simply never the proof of it.** The proof is now **Hold the Line** — it says
"ally", it reads `_hero_side()`, and a summoned bear measurably banks 20 Break where it used to
bank 40.

---

## §4 — CV §4 IS CORRECTED, NOT JUST SUPPLEMENTED

**CV moved four texts TO "ally" on the stated test that *"their read sites genuinely include
companions"*. It was false for all four** (DJ §2). After this batch:

| text | CV said | DK ruled |
|---|---|---|
| `wd_rally` | ally | **ally** — code corrected |
| `wd_hold_line` | ally | **ally** — code corrected |
| `dv_devoutness` | ally | **hero** — text corrected |
| `dv_waters` | ally | **hero** — text corrected |

**All four land correctly for the first time, and by a different route than CV recorded.**

**THE TEST ITSELF IS WHAT A FUTURE AUTHOR WOULD APPLY, SO THE TEST IS WHAT WAS CORRECTED** — in
`CLAUDE.md`, `docs/text-standard.html` §4.9 and `docs/talent-audit.html` §4.1.

**The new test is not "does the collection reach one". It is "does the effect ARRIVE".** There are
**three places a widening dies and only the first is the collection**:

1. the loop walks bare `heroes`;
2. a filter downstream removes it — **never actually the mechanism**, since all 23 `is_companion`
   filters walk `heroes` and remove nothing;
3. **the read site below simply never runs for that body** — invisible to every source grep and to
   every check that asserts on a collection.

**The glossary was the one actively misleading a player.** Its `hero_vs_ally` entry named five
effects as examples of what "ally" pays — *Tank and Spank's Empower, Rally's healing bonus, Hold
the Line, Devoutness, Cleansing Waters* — and **four of the five were false when it was written.**
Rewritten to the live split with the reason attached to each. `master.html`'s Hold the Line flag,
which DJ left reading "companions NOT included", now says they are; and `master.html` gained a
compact statement of the whole split beside the talent-tree rules.

**The changelog and the batch reports are history and were deliberately not swept.**

---

## §5 — THE FILTERS THAT REMOVE NOTHING, AND THE QUESTION DK ASKED OF THEM

**All 23 `is_companion` filters walk `heroes`, which never holds one**, so not one of them excludes
anything. They record intent and are kept as such.

**DK asked the question that count exists for: does any of them now sit on a collection that DOES
hold a companion?** A filter on one of the four widened sites would have stopped being decoration
and started removing the beast — **the widening would have done nothing and the batch would have
shipped a no-op wearing a fix's clothes.**

**NONE of the four carried one, so none of the 23 changed meaning.** The count holding at 23 across
DK is how that is checkable rather than merely stated, and `check_dj` §5 keeps it for exactly that
reason.

**The real no-op risk turned out to be somewhere else entirely** — a missing READ SITE rather than
a surviving filter, which is §3. The brief pointed at the filters; the filters were innocent.

---

## §6 — VERIFICATION

**The documentation was written BEFORE the verification run** — `CLAUDE.md`, `docs/changelog.html`,
`docs/master.html`, `docs/text-standard.html`, `docs/talent-audit.html`, `data/glossary.json` and
`baselines.json` were all complete before the battery started. `docs/state.md` and this report are
written after, which is what `check_de`'s re-runnability buys.

### THE NEGATIVE CONTROL, AND IT IS NOT OPTIONAL

**The failure DK repairs was invisible in every battery ever run.** Four effects paid four units
instead of five for the life of the project and no log, no suite and no battery ever said so — so a
check that passes on the fixed tree proves nothing on its own.

`check_dk` §2 **empties `companions` for the length of one arm**, which is precisely the pre-DK
collection at these sites, and asserts the beast is untouched:

- **Sanctuary heals it 0** against 1200 with the union.
- **Hold the Line leaves it the full 40 Break** against 20 with the union.
- **The Field Medic's pool does not hold it** when poisoned.

The control arm's 40 is asserted as an *exact* number rather than as "more", because a fixture that
had stopped landing the blow at all would otherwise pass the comparison.

### A SECOND CONTROL THE LITERAL SWEEP CAUGHT, BEFORE THE BATTERY

**The doc edits first broke `test_batch_bx` §4** — its prose sweep forbids the word "beast" in
`data/glossary.json` and `docs/master.html`, and the first draft of both additions used it seven
times. Caught by diffing the set of doc literals that suites assert on, taken **before** the doc
edits and again after; reworded to "companion"; `test_batch_bx` re-run clean at **147 / 0**. A
battery run would have caught this too — the point is that the same diff also surfaces the
*opposite* fault, where a doc GAINS a literal and turns a red assertion green with a false message,
which a battery cannot see.

### §6a — THE BASELINE PREDICTION, WRITTEN BEFORE THE BATTERY

| target | before | predicted | measured |
|---|---|---|---|
| `check_dk` | — | **64 / 0** | **64 / 0** ✓ |
| `check_dj` | 54 / 0 | **43 / 0** | **43 / 0** ✓ |
| `check_de` | 281 | **285** | **285** ✓ |
| every other row | — | unchanged | unchanged ✓ |

**All three movements were predicted and all three landed exactly.**

`check_dj` 54 → 43 is its §5 site ratchet **retired into `check_dk` §1** rather than updated: DJ
pinned the eleven with a message asking the next batch to RULE, DK ruled, and keeping both would be
**two copies of one fact in two gates** — which is DJ's own §3 rule. Its `is_companion` count stays,
because that is DJ's own finding and nothing else asserts it.

**Why nothing else moved, derived rather than assumed:** thirteen files summon a companion or name
`companions`, and **not one of them touches any of the four widened effects except in prose**
(`bj`, `ce`, `cy`) — so the widening could not move an existing measurement. No suite pins any of
the seven changed texts (checked before editing). `test_batch_al`'s `PROSE_NUMBERS` entry for
`wd_tank_spank` is `["ALWAYS"]`, which survives the reword, and its live check counts over `heroes`,
whose collection did not move. `test_batch_ce` pins the glossary at 97 entries and one entry's TEXT
was rewritten, none added. The `master.html` stamp moved DJ → DK on the self-comparing pattern
across 14 suites, so no bump is owed.

### §6b — THE BATTERY

**Sixty-nine targets ran and the manifest names all sixty-nine.** The only red is **`check_cm_live`'s
four, which is the standing deliberate one**. `check_de` reports **285 checks / 0 failures /
0 NOTICES** — every row matched its baseline in both directions.

**None of the three known flakes fired.** `test_batch_at` §1, `test_batch_bo` and
`test_rune_battle` all read clean, which is now **six consecutive quiet readings** on rows that red
about one in eighteen. **That is the flake being quiet, not the flake being fixed** — all three are
still open and still unseeded, and one flake at a time is how the effect stays attributable.

`src` coverage is re-derived live by `check_di` §1 on every run and reads **106 of 204** — unchanged
by DK, which adds no `_apply_status` call site.

---

## §7 — WHAT THIS DELIBERATELY DOES NOT DO

- **It does not give `_companion_hit` an `empower` read.** That is a magnitude change on beast
  damage — new PLAY — and this batch was scoped to a vocabulary ruling. It is recorded as the one
  thing that would let Tank and Spank say "ally" truthfully.
- **It does not re-stamp Devoutness or Last Hope on summon.** That is a second write site for one
  node's worth of effect, and it is a design call rather than a repair.
- **It does not rule on Rallying Shout's Pressure clause**, which says "the whole party" and pays
  four. "Party" is not one of the two words DJ §2 swept.
- **It runs no sim.** The four widenings will move the Devout's healing-per-battle and the Break
  columns the *next* time a sim runs with a Beastmaster in the party — the carried figures in
  `docs/state.md` predate DK and are flagged there.
- **It does not prune `CLAUDE.md`**, which is still over CW's own target.
