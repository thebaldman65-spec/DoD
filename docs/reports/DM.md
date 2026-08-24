# BATCH DM — THE SIX SPLIT-CLAUSE CARDS, AND THE ALLY/HERO THREAD CLOSES

*2026-08-23. One new gate (`check_dm`, 92 checks). **No game code moved** — the diff to
`battle.gd` and `classes.gd` is comments, proved below. Save version unchanged (v10).*

**DL listed six cards carrying clauses of two different shapes under one word and ruled on none of
them. DM read all six clause by clause — sixteen clauses, fourteen of which carry a collection —
and ALL FOURTEEN COLLECTIONS WERE ALREADY CORRECT.** The two clauses that mis-said were of a third
scope this thread had no word for. The thread is closed.

---

## §1 — THE SIX, CLAUSE BY CLAUSE

**Every read site below was derived from the source at its own line.** The question asked of each
clause is the brief's: what does its text say, what collection does its read site walk, do they
agree.

### Bulwark of Fortitude — FOUR clauses, ONE collection, and they do not share a reason

> *"The unbreakable stand: for 3 turns every **hero** takes NO Break damage, has their armor
> increased by 50%, and heals 10% of max health each turn. The cast heals them 5% at once."*

Read site `battle.gd`'s `bulwark` arm: `for h in heroes.filter(func(he): return not he.dead and
not he.is_companion)`. **Word HERO, collection the four. AGREE.**

| clause | read site | receivable? |
|---|---|---|
| Break immunity | `unit.take_hit`'s Break block | **YES** — a companion has `pressure` against its own `stability`, and DK already cuts Break for one on that meter |
| armor +50% | `unit.effective_armor()` | **YES** — every unit on the field runs it |
| the cast's instant 5% | `heal_amount` on the body in hand | **YES** |
| **10% of max health each turn** | the turn-start block | **NO.** `_next_unit()` walks `heroes + enemies`; a summon is built with `next_time = INF` |

**THIS IS THE SHARPEST OF THE SIX: WIDENING THE LOOP WOULD SHIP THREE QUARTERS OF A CARD**, and the
quarter that could never arrive is the sustain the card is named for. A partial arrival reads as
working — Tank and Spank's failure in a new shape. Three of the four are narrow **by choice**, and
the source now says so rather than implying an impossibility.

### Consecrated Ground — THREE clauses, and the Faith one is two exclusions deep

> *"Holy ground blooms underfoot: every **hero** takes 15% less damage and reflects 10% of damage
> taken, for 3 turns — and each is kindled 1 Faith at the start of their turn while it holds."*

Read site: `for h in heroes.filter(func(he): return not he.dead and not he.is_companion)`.
**Word HERO, collection the four. AGREE.** Mitigation (`strike_target.has_status("cons_ground")`)
and reflect are receivable and narrow by choice. **The Faith kindle is refused twice over**: it is
paid in `_ground_faith_tick` inside the turn-start block (per-turn), and `_gain_faith`'s first line
is `if devout == null or u.dead or u.is_companion or not u.is_hero: return`.

### Divine Wrath — TWO clauses that die for two different reasons

> *"The light answers: every **hero** deals +15% damage and acts 15% faster for 4 turns."*

Read site: `for h in heroes.filter(func(he): return not he.dead)`. **Word HERO, collection the
four. AGREE.** The damage term is `raw *= 1.15` inside `_resolve` — the hero strike loop, which
`_companion_hit` never enters. The speed term is `s *= 1.15` in `unit.effective_speed()`, which
only matters to a turn order a companion is not in. **Tank and Spank's finding twice over in one
card, and widening the collection would deliver neither.**

### Sacred Resolve — TWO words, ONE shape, and the words are right

> *"Bind the **heroes'** souls — all damage received is split evenly among them for 4 turns (Break
> damage still lands on the struck **hero**)."*

Apply: `for h in heroes.filter(func(he): return not he.dead)`. **And all three trigger sites gate
again**: the strike split and the bleedout split both test `is_hero and not is_companion`, and the
recoil split reads a status only `heroes` can hold. **AGREE.** DL's read was right and this
confirms it at four sites rather than one.

### Battle Shout — a group clause and a SELF clause, and the card put the self one inside the group

> before: *"A roar every **hero** answers: +12% damage, plus 1% per 20 blood buildup on the
> warband, **and 5 Rage**. Lasts 3 turns."*
> after: *"A roar every hero answers: +12% damage, plus 1% per 20 blood buildup on the warband.
> Lasts 3 turns. **Refunds 5 Rage.**"*

The group clause walks `for h in heroes: if h.dead: continue` and its power is read at `raw *= 1.0
+ status_power("battle_shout") / 100.0` — the same strike loop, the same reason. **HERO, and it
agrees.**

**THE RAGE IS PAID TO `attacker` AND TO NOBODY ELSE.** It sat inside the colon-list of "every hero
answers", so one surface a player reads promised four heroes a payload that reaches one unit — and
only a Rage user at that. **This is the batch's one real disagreement, and it is a scope neither of
this thread's two words covers.** `check_co` and `check_cy` have both recorded it as *"hands the
caster +5 Rage"* since CO; **the card was the only surface that disagreed.**

**THE FIX COPIES THE SIBLING CARD.** Hold the Line carries the identical payload and already words
it correctly, as its own sentence: `Refunds 5 Rage.` A refund returns to whoever paid, so the
sentence needs no subject. **Nothing was invented.**

### Hold the Line — TWO group clauses and a SELF clause

> *"Embolden every **ally**: 50% less Break damage for 2 turns, and no one can die for 2 turns.
> Refunds 5 Rage."*

Both group clauses walk `for h in _hero_side()`. **Word ALLY, collection heroes + companions.
AGREE**, and measured: the beast holds `undying` and survives a lethal blow at 1 HP. The self
clause was already correct.

**AND ONE THING WAS WRONG HERE, ON A DIFFERENT AXIS.** CV §1 ruled that *a duration is stated as
APPLIED*, and CV's own record says it moved `wd_hold_line`'s no-death window **1/2 → 2/3**. It
moved the NODE text. **The `description` inside that node's own payload still said "for a turn"
and "for two turns" against the 2 and 3 the code applies** — `cr_rime`'s shape exactly, the one CU
found: the node and the description inside its payload disagreeing. Both card lines now state the
applied number. **No code moved and no sweep was opened**; this is CV's binding ruling reaching the
one surface it missed, on a card this batch was reading clause by clause anyway.

### AND FOUR PROSE COPIES OF ONE CLAUSE WERE STILL SAYING *ally*

DL §2 corrected Consecrated Ground's Faith kindle **on the card**. It left:

| surface | before | after |
|---|---|---|
| `master.html` (Faith status row) | "(1 an ally a turn)" | "(1 a hero a turn)" |
| `master.html` (Conviction passive) | "(1 per ally per turn)" | "(1 per hero per turn)" |
| `master.html` (the Devout's kit) | "every ally gains 1 Faith at the start of their turn" | "every hero …" |
| `data/glossary.json` `res_faith` | "every ally standing on Consecrated Ground gains one" | "every hero standing on …" |

**The DA/DC/DG shape for the third time: one surface of a clause gets fixed and the rest are
carried.** text-standard §4.9 has said since CV that *nothing Faith-flavoured can ever say ally*,
so these were violations of a standing rule rather than open questions. **When a clause moves,
sweep the CLAUSE across every surface, not the card across one.**

Two stale **Perfect** claims sat in the same two `master.html` sentences and went with them: Battle
Shout's +5 Rage and Consecrated Ground's third turn are both unconditional since the fold, and
Consecrated Ground's duration there read **2** against the **3** applied. `master.html` is
corrected toward the code by standing rule, so this is not a new ruling either.

### AND THE DK COMMENT ON RALLYING SHOUT DESCRIBED A STATE DL ENDED

`classes.gd`'s `vault_ability` still carried DK's *"THE PRESSURE HALF IS A SEPARATE QUESTION AND IS
DELIBERATELY NOT ANSWERED HERE"*, pointing at `docs/state.md` for an item DL closed. **Replaced,
not appended to.** DL wrote *"a reason recorded beside a decision is a good practice that creates a
new place to be wrong"* about DK's `max_resource` slip; **this is the same file's second
instance.**

### THE FIVE DL LISTED SEPARATELY — REPORTED, RULED ON NOWHERE

**None is a clause-level scope disagreement of the kind §1 rules on.** Each is a single-shape text
saying *ally* where its read site means *hero*, on an effect that already behaves correctly. Every
read site below was re-derived; not one was moved.

| text | read site |
|---|---|
| the Warrior's **Rally** — *"Shout one ALLY forward"* | its picker filters `not a.is_companion` at **three** sites, so it cannot even be aimed at one. It also carries two clauses of different shape (a turn hand-off and a resource refill) |
| **Health / Mana / Revive Potion** — *"one ally's maximum health"*, *"a fallen ally"* | `_use_item` picks from `heroes.filter(not dead)` |
| **Shared Grief**'s log — *"%d ally below half"* | walks `heroes`, skips companions |
| the **Mercy** `passive_desc` and the glossary's `mercy_window` | `unit._check_below_half` gates on `is_hero and not is_companion` |
| **Glacial Hold**'s *"+15% damage from EVERY source"* | `_hold_window_mult()` has one caller, in the hero strike loop |

---

## §2 — A PIN MUST NAME ITS CLAUSE: THE AUDIT

**Every pin on all six cards was audited.** The collection pins live in `check_dk` and `check_dl`
only — the suites that touch these cards (`al`, `aw`, `ax`, `bc`, `bh`, `bi`, `bq`, `br`, `ce`,
`cu`, `cv`, `cy`) pin talent structure, durations and Faith arithmetic, not collections. **Two of
`check_dk`'s eleven were faulty and both moved.**

| pin | the fault | what it is now |
|---|---|---|
| `wd_hold_line Hold the Line` | pinned the `hold_bd` clause and stopped. **`undying` is a SECOND group clause in the same loop, ruled *ally* by the same DK decision, and could have been moved onto bare `heroes` with this entry still green.** A pin covering a card's first clause reads exactly like a pin covering the card | renamed to name its clause; `undying` is pinned by its own read line in `check_dm` §1 (two copies of one fact in two gates is DJ §3's rule) |
| `dv_waters Cleansing Waters` | pinned `if zl_dv.waters_ranks > 0 and randf() < …` — **the rank-and-roll gate, which keeps nothing narrow.** The table's own heading is *"each by the read line that keeps them narrow"*, and that fragment would have stayed green with the whole turn-start block deleted | re-pointed at `_next_unit()`'s `(heroes + enemies)` walk, which is what actually excludes a companion — **and which serves Bulwark's regen and the Faith drip too, so one pin replaces three copies** |

**AND THE SEARCH DIRECTION WAS THE DEEPER FAULT.** DL fixed two pins that matched two loops each by
*lengthening the fragments*. The general repair is to change the **direction**: the clause line is
the unique half and the walk is often shared, so `check_dm` §1 anchors on the clause and `rfind`s
the walk above it. **FIVE sites in `battle.gd` spell
`heroes.filter(func(he): return not he.dead and not he.is_companion)` byte for byte** — Bulwark and
Consecrated Ground among them — so a forward `find` from the walk reads the wrong site four times
in five.

**AND THAT NUMBER CAUGHT ITS OWN AUTHOR.** `check_dm` asserted the count was **two**, because two
is how many of them this batch was looking at. **The gate failed on its first run** — the
count-in-a-brief fault landing inside the instrument written to prevent it. The assertion is now
the property the reasoning rests on (`> 1`) and the live count is **printed**.

---

## §3 — WHAT CLOSES

**The ally/hero thread is CLOSED**, recorded in `CLAUDE.md` and in `docs/text-standard.html` §4.9:

> **Rule on clauses, not on abilities.** A card can carry two clauses of different shape under one
> word, and a sweep that reads the ability will not see it. **"Party" is retired**; hero means the
> four, ally means heroes and companions, and every *hero* ruling carries the structural reason a
> companion cannot receive it.

**There are five reasons and no sixth, and each was re-derived at its site rather than recalled:**

| reason | derived at |
|---|---|
| no resource bar to refuel | `unit.gd:111` — `resource_name := ""`; the summon `cfg` sets no `resource_name` and no `max_resource` (default 100) |
| `_companion_hit` reads none of the hero strike loop's multiplier block | `_companion_hit` (`battle.gd:19873`) is its own path; the multipliers live in `_resolve` |
| stamped once at party spawn, before a companion exists | `heroes.append` is reached at exactly one site; `companions.append` is the summon |
| per-turn: `_next_unit()` walks `heroes + enemies` | and the summon carries `comp.next_time = INF` |
| `_gain_faith` refuses companions outright | its first line: `if devout == null or u.dead or u.is_companion or not u.is_hero: return` |

### A SEVENTH FAMILY WAS FOUND. IT IS REPORTED AND THE THREAD STOPS.

**A text that UNDER-states its own payload.** An absent clause does not mis-say, so §1's test does
not reach it — and **adding a clause to a card is authoring while correcting a wrong word is
repair.** Both are recorded as owed and neither was taken:

- **Both UPGRADED cards drop "Refunds 5 Rage" while the code still pays it.** Battle Shout's
  upgraded description and Hold the Line's both omit it; `attacker.resource = mini(attacker.resource
  + 5, …)` is outside every branch in both handlers.
- **The pool-pick Battle Shout shows the NODE's numbers.** `pool_ability` falls through to
  `Talents.granted_ability`, so **there is one `description` in the project for three magnitudes**:
  a pick pays **+8% for 2 turns** (`shout_base[0]`, `shout_turns[0]`) while the card promises +12%
  for 3.

---

## §4 — VERIFICATION

**The documentation was written BEFORE the verification run.** `CLAUDE.md`, `docs/changelog.html`,
`docs/master.html`, `docs/text-standard.html`, `docs/design-notes.md`, `data/glossary.json` and
`baselines.json` were complete before either battery started. **`docs/state.md` and this report are
the only files written after**, and no suite and no gate reads either.

### §4a — THE PREDICTION, WRITTEN BEFORE THE RUN

| target | before | predicted | measured |
|---|---|---|---|
| `check_dm` | — | **92 / 0** | **92 / 0** ✓ |
| `check_de` | 289 | **293** (four assertions per target, DM adds one gate) | **293** ✓ |
| `check_dk` | 64 / 0 | **64 / 0 unmoved** — two entries renamed and one re-pointed, table sizes unchanged | **64 / 0** ✓ |
| `test_batch_bx` | 157 / 0 | **unchanged** — nothing DM writes reaches a swept surface | **157 / 0** ✓ |
| `test_batch_al` | 559 / 0 | **559 / 0** — the needle re-points, the count does not move | **559 / 0** ✓ |
| every other row | — | unchanged | unchanged ✓ |

`check_da` and `test_batch_cd` both walk the gate directory and were checked against the new gate
before the run: neither emits a per-file `ok()` except on a violation, and `check_dm` hand-rolls no
corpus, authors no `_spawn` and instantiates no battle scene. **Both read 36 and 72, unmoved.**

### §4b — TWO BATTERIES, AND THE FIRST ONE FOUND A REAL BREAK

**BATTERY 1 RAN ON A FROZEN TREE AND IS AN HONEST READING — of a tree with a defect in it.** It
reported `check_de` **293 / 1**: `test_batch_al went REDDER: 1 failures, recorded 0`. `al` §3
asserted the UPGRADED Hold the Line description `contains("two turns")`, and DM had moved that
string to "for 3 turns".

**THE NEEDLE FOLLOWED THE STRING** — `test_batch_bf`'s case at DL, not `test_batch_bj`'s. The
string did not move for a cosmetic reflow; it moved because CV §1 rules that a duration is stated
as APPLIED. **And the new needle names its clause** (`"die\nfor 3 turns"`), which is §2's own rule:
`"3 turns"` alone would also match the Break-cut line if that number ever changed. `al`'s two
failure messages and two comments still spoke the abolished convention beside CV-correct
assertions, and were corrected with it. **`al` is 559 checks either way.**

**MY LITERAL SWEEP MISSED IT, AND THE INSTRUMENT WAS AT FAULT, NOT THE DISCIPLINE.** Its minimum
needle length was **12 characters** and `"two turns"` is nine. The sweep was rebuilt to evaluate
every literal ≥ 4 characters against **both** the `git show HEAD` version and the working version
of each document in one pass — 13,781 literals. **Eleven pairs were LOST and all eleven are
accounted for**: eight are `check_dm`'s own negative assertions (LOST by design — the strings are
meant to be gone), one is `check_dk`'s deliberately re-pointed `dv_waters` pin, one is
`test_batch_ax`'s `"per ally per turn"` (a NEGATIVE assertion reading a talent node's `desc`, not
`master.html` — `ax` read 345/0), and one is `test_batch_bx`'s `"party"` data-file strip literal
co-occurring with the DK comment that was replaced (`bx` read 157/0). **The twelfth was the real
one and the battery caught what the instrument did not.**

**BATTERY 2 RAN AGAINST A TREE FROZEN BEFORE IT BEGAN AND UNEDITED UNTIL IT FINISHED, AND IT IS THE
ACCEPTANCE RUN.** Fourteen files were MD5-stamped at the freeze and re-compared after: **identical.**

| | before (DL's acceptance) | DM battery 1 (found the break) | DM battery 2 (acceptance) |
|---|---|---|---|
| **suite failures** | 0 | 1 (`al`, repaired) | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 289 / 0 / 0 | 293 / 1 / 0 | **293 / 0 / 0** |

**SEVENTY-ONE TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-ONE** — seventy at DL, plus
`check_dm`. **0 `Parse Error` and 0 `SCRIPT ERROR` across every log**, grepped from the logs rather
than read off a tally or off `$?`. `test_batch_an` read **6050**, inside its `[6046, 6063]` band
over 16 observations; `check_de` reported **0 notices**, so nothing rose unexpectedly either.

### §4c — SEVEN NEGATIVE CONTROLS, AND ALL SEVEN BIT

| control | result |
|---|---|
| restore Battle Shout's pre-DM Rage wording | `check_dm` **2 failures** |
| restore Hold the Line's pre-CV translated durations | `check_dm` **3 failures** |
| put *ally* back in `master.html`'s Faith drip | `check_dm` **2 failures** |
| put *ally* back in the glossary's Faith drip | `check_dm` **2 failures** |
| **WIDEN Bulwark's loop to `_hero_side()`** | `check_dm` **2 failures** — the §1 gap check (3512 characters, ceiling 120) and the live measurement, the beast now wearing `bulwark` |
| **NARROW Hold the Line's `undying` back to bare `heroes`** | `check_dm` **2 failures** — the chip does not reach the beast, and **the beast dies at 0 HP** instead of holding at 1 |
| restore the pre-DM upgraded wording after the `al` repair | `test_batch_al` **1 failure**, on the re-pointed needle |
| *(and, separately)* a deliberate syntax error in `scripts/relics.gd` | the `check_parse` **stderr** grep reports **19 `Parse Error`**, and **0** once reverted |

**THE SIXTH IS THE ONE THAT MATTERS.** Hold the Line's `undying` clause is *ally* on the card and
was pinned by nothing anywhere — `check_dk`'s entry covers `hold_bd` alone. Narrowing it reds
`check_dm` twice, on the chip and on a body that dies. **A clause that nothing pins is a clause
that can be un-ruled silently**, which is §2's whole subject.

### §4d — NO GAME CODE MOVED, AND THAT IS PROVED RATHER THAN CLAIMED

`git diff` on `scripts/battle.gd` and `scripts/classes.gd`, with comment and blank lines stripped
from both sides, is **empty**. **The check was worth running**: the first pass of it showed one
removed line — `_sfx("heal", -5.0, 0.6)`, dropped from the `cons_ground` arm by a comment insertion
that swallowed it. Restored before either battery. **A comment-only claim is a claim, and this one
was false for about twenty minutes.**

### §4e — THE CARD WIDTHS

Measured directly over `classes.gd` and `talents.gd`, before and after, on the authored
`description` and `perfect_text` lines: **1284 lines, 3 over the 44-character ceiling, widest 55 —
identical on both sides.** Not one card gained a line, gained an overflow, or widened an existing
one. The three edited cards keep their line counts (4, 3 and 3) and their widest lines are 36, 38
and 38.

### §4f — THE THREE FLAKES

**NONE FIRED, WHICH IS NOW EIGHT CONSECUTIVE QUIET READINGS** on rows that red about one in
eighteen. `test_batch_at` 467/0, `test_batch_bo` 1025/0, `test_rune_battle` 97/0. **That is the
flake being quiet, not the flake being fixed** — all three are still open, still unseeded and still
banded, and **a red from any of them is not this batch's.**

---

## §5 — WHAT THIS DELIBERATELY DOES NOT DO

- **It rules on none of the five ally-worded texts in §1's last table.** None is a clause-level
  scope disagreement; each is a single-shape text on an effect that already behaves correctly.
- **It does not sweep for the seventh family.** Both under-stating upgrade cards and the
  three-magnitudes-one-description Battle Shout are reported and left.
- **It does not widen anything.** Bulwark's three receivable clauses and Consecrated Ground's two
  are narrow **by choice**, and moving them is a magnitude change on beast survivability — new
  PLAY, which is DK's rule and not this batch's remit.
- **It does not sweep `res_faith`'s other *ally* uses.** The glossary's Faith entry says *ally* in
  four more places (the Devout's allies, Binding Oath's releases, an ally's release at 3, a
  shielded ally holding). §4.9's rule reaches them; **DM corrected only the Consecrated Ground
  clause, because that clause was in scope and the others are a sweep.**
- **It runs no sim.** Every carried sim figure in `docs/state.md` has been stale since DK and stays
  marked so. DM moves no magnitude, so it adds nothing to that staleness.
