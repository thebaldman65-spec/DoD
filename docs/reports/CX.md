# BATCH CX — THE CHANGELOG CUT, AND THREE RULINGS

*2026-08-20. Four items; **one of them deliberately not implemented**. No save version moves
(still v10). One enemy ability renamed, one enemy ability made castable for the first time, and
the live changelog cut by two thirds.*

---

## THE HEADLINE

| | before | after |
|---|---|---|
| `docs/changelog.html` | **494.2 KB**, 32 entries | **162.1 KB**, 10 entries |
| `DoD-archive/changelog-archive.html` | 696.2 KB, 108 entries | **1042.0 KB**, 131 entries |
| entries, both files | **140** | **140** |
| suites reading the archive | 3 | **14** |

**23 entries moved, nothing deleted, nothing edited, and the two halves rejoin byte for byte.**

---

## §0 — WHAT RUNNING THE SUITES FOUND FIRST

Before touching anything I ran the fifteen suites this batch could plausibly disturb. **Eleven assertions across eight suites were already red, and none of them is mine.**

**CW's `CLAUDE.md` split dropped every batch narrative, and seven suites assert against text that
went with it.** CT, CU, CV and CW were all implement-only, and **no battery has run since CS**, so
nothing caught it for four batches.

| suite | red assertion |
|---|---|
| `bb` | `BATCH BB`; `rot_hp_lost` |
| `bn` | "rungs 2 and 3 were not touched"; `_releasing` |
| `bo` | `TRANCHES 2 AND 3` |
| `bq` | `BATCH BQ` |
| `br` | `BATCH BR`; "naming the twelve" |
| `bx` | `BATCH BX` |
| `ce` | `SECOND CLASS COMPLETE` |
| `cd` | **knock-on** — `test_batch_bb.gd reports zero failures`, because bb is red |

**And two that pass by accident, which is the worse half.** `contains("BATCH BN")` and
`contains("BATCH BS")` still match — not a batch block, but a passing mention inside two of the
surviving rules. **That is the "check that has stopped asking its question" pattern**, arriving
through a document this time instead of through the changelog, and with no red to announce it.

**Not repaired here.** Deciding what those assertions should ask *instead* — the rule that
survived? the report in `docs/reports/`? nothing at all? — is CW's decision, not a detail to guess
at while doing something else. All ten are recorded in `docs/state.md`.

An eleventh red is older and unrelated: **`data/glossary.json` still reads "beast" once in prose**
— "pay the four and not the beast", inside CV's own hero/ally entry — which `test_batch_bx` §4
catches. One word, belonging to the prose rename pass. Reported, not taken.

---

## §1 — THE CHANGELOG IS CUT AT CN/CO

**486 KB was the figure on record. Re-derived it was 494.2 KB.** Against CW's 400 KB threshold
either way, but the brief's own instruction was to derive rather than recall, and it was right to
insist.

**Cut at a batch boundary; no entry edited; the live file does not move**, which is why
`docs/build_docs.py` keeps working.

- **Live: Batch CO forward, 9 entries at the cut** (CO → CW), **148.7 KB** — the ~150 KB the rule
  asks for, chosen from a table of every candidate boundary so the next cut is many batches away.
  With this batch's own entry it stands at **162.1 KB / 10 entries**.
- **Archive: 23 entries prepended**, BP → CN, taking it from 108 to **131**.
- **140 entries before, 140 after.**

### The verification, which is the point

- Every `<h2>` extracted from the original and from both halves. **Counts sum (9 + 23 = 32), zero
  overlap, order preserved.**
- **The two bodies rejoined are byte-identical to the original.** Asserted directly, and by sha.
- **A second script re-derived all of it from untouched backups** rather than from the splitter,
  and asserted that each of the 140 headings appears **exactly once** across the two files, that
  none was invented, that the pre-existing archive body was undisturbed, and that the live
  header's path still resolves to the archive.
- **No file size is asserted anywhere in either script.** Sizes agreeing is entirely consistent
  with a duplicated entry and a dropped one.

### The one that nearly got through

**Batch BF's `<h2>` wraps across two lines.** A `^<h2>.*</h2>$` extractor counts 107 where the
archive holds 108. It surfaced only because `grep -c '^<h2>'` and the regex disagreed by one —
**which is exactly the size of the error the byte-for-byte rule exists to catch.** The extractor
reads across lines now, and the lesson is in `CLAUDE.md`: count the same thing two different ways.

### Eleven suites re-pointed, and eight would have gone on passing

bp, bq, br, bs, bt, bu, bv, bw, bx, cb and ce each asserted their own entry against the **live**
file. **Eight did it with a bare `contains("Batch XX")` — satisfied by a later entry naming the
batch in prose, so it passes with its subject in a different file entirely.**

That failure has now happened three times in this project: BZ caused it in `test_batch_bb`, CD
found the same shape in `test_batch_bo` two batches later. **This time it was repaired in the same
batch that caused it**, which is the only version of this that is cheap.

CD's pattern throughout, unchanged: **anchor on the `<h2>` heading**, which a later entry's prose
cannot reproduce, and **reach the archive by following the path out of the live file's own
header**, never by hardcoding it — so the next cut moves all eleven with it. Each suite gained
exactly **+3** checks (`ce` +4).

`test_batch_ce` got one thing more. Its `contains("102")` ran against the whole file, and
**against a 1 MB archive three digits turn up in any document with enough numbers in it** — a
check that can only pass. It reads inside the CE entry now.

### Headers

Both rewritten to name each other with full paths, and **the bare filename still comes before the
full path**, because eleven suites anchor on `/changelog-archive.html</code>` with the leading
slash and walk backwards to the opening `<code>`. The live header's "see the Batch BZ entry below"
pointed at an entry this cut moved out; it points at CX now.

---

## §2 — RELICS PER-HERO: SCOPED, AND STOPPED

**The brief said to report the scope before doing it, and to stop if it is large. It is large.**

**Relics are party-wide throughout.** `Run.active_relics` is a flat `Array` of ids, and every
consumer reads it through two aggregators that take that array and nothing else.

| surface | what per-hero costs |
|---|---|
| **the save** | `data["active_relics"]` is read as a **hard key with no default**. A shape change breaks every existing save. **v10 → v11.** |
| **read sites** | **25** — `battle.gd` 12, `run_state.gd` 8, `run_sim.gd` 4, `shop_screen.gd` 1 |
| **the API** | `Relics.hook_add` / `hook_dict` and `Run.relic_add` / `relic_dict` — **all four change signature**; none currently knows which hero is asking |
| **acquisition** | the draft screen's 3-slot toggle needs a per-relic hero picker; the `relic_grant` event verb appends mid-run and would have to choose one |
| **content** | **13 of 25 relic descriptions** are worded party-wide — "All heroes", "Every hero", "The party", "party recovers", "Heroes open every battle" |

**It can be split. It should not be started casually, and it is not started here.**

### The ambiguous hooks, reported rather than guessed

Clearly party-wide and staying so, as ruled: `start_items`, `start_gold`, `gold_find_mult`,
`shop_discount`, `loot_extra`, `victory_gold`. Clearly per-hero: the eleven battle-spawn hooks,
which already run once per hero and are where "which hero gambles" becomes readable.

**Four sit in between:**

- **`victory_heal_pct`** (Chalice of Dawn, Cracked Hourglass, Martyr's Knucklebone) and
  **`victory_mana_pct`** (Cracked Hourglass) — the party heals after a victory. Does the owner
  heal, or does everyone?
- **`rest_heal_add`** (Cairnmoss Poultice, Martyr's Knucklebone) — a rest node heals the party,
  not a hero.
- **`resource_floor_pct`** (Bottled Storm) — reads per-hero naturally, was authored as all of
  them.

### One thing the ruling should probably decide with it

**The draft assigns relics before specs are chosen.** That is the point at which "which hero
gambles" has the least information behind it — the player is choosing a hero who has no
kit yet. Worth deciding whether assignment moves later, or whether the pickup-time rule means
event grants only.

---

## §3 — REGALIA POINTS AT ITSELF, AND CAN FINALLY BE CAST

**Both halves changed, because either alone leaves it broken — which the brief said and was right
about.**

**It is selectable now, and that was the actual fix.** `_enemy_support_action` names its six
candidates **literally** and Regalia was not among them; the attack list filters on `damage > 0`
and Regalia has none. **Re-pointing the target alone would have changed nothing.** It enters that
list, gated on the caster not already carrying the ward.

**It wards the caster — and the JSON still says `"target": "ally"`, which is correct.**
This is the trap in the section and it is worth stating plainly: `Ability.Target` is
`{ENEMY, ALLY}` only, `Enemies.config` maps the literal string `"ally"` and nothing else, and
**"ally" means OWN SIDE**. A caster is on its own side. Regenerate, Cleansing Rite and Dark Vigil
are all self-casts tagged `"ally"` for exactly this reason. **An unmapped `"self"` would fall
through to `Target.ENEMY` and the boss would ward a hero.** The re-point belongs in the chooser,
not in the data.

**The description named a mechanic the payload does not implement.** "Wards an ally against the
next blow" is `shield_charges`; the payload is `enemy_shield`. It reads **"The Crown wards itself:
25% less damage taken for 3 turns"** now.

**And the payload logged the wrong ability's name.** The shared `enemy_shield` branch printed the
literal string "Shielding", so the moment a second ability used it, a Regalia cast announced
itself as the Shieldmaster's card — and a self-ward said the caster's name twice. It reads
`ab.display_name` now. **Same fault as the description, one layer down**, and it is in `CLAUDE.md`
as a rule.

**`battle.gd`'s Dispel comment claimed Regalia as a live shield source and it never was** — "two
of nineteen kinds" should have read one. **Annotated rather than quietly corrected**: it is true
only as of this batch, and a comment that believes something the code does not do is the trap CU
exists to avoid. `master.html` carried the same claim in the Dispel row and now carries the same
correction.

### It costs the turn

A support cast returns instead of attacking, and the ward runs 3 turns, so **the Crown trades
roughly one turn in four for 25% less damage taken** — not a free buff to the end boss. A taunt
still forces it to attack; a Dispel still strips the ward.

**Verified in a real battle, not by reading.** The chooser returns `Regalia @ The Hollow Crown`,
the target is the caster, it declines to re-pick while warded, the fight resolves, and the log
reads:

```
The Hollow Crown: Regalia — it takes 25% less damage (3 turns)
```

The Shieldmaster's ally branch was re-checked on the same payload and is unchanged
(`Orc Shieldmaster: Shielding — Orc Raider takes 25% less damage (3 turns)`).

**One thing found on the way:** `_psychotic_support` matches on `special` rather than on the
display name, so a **maddened** Crown could always cast Regalia on the party. The normal fight was
the only place it could not happen.

---

## §4 — THE ORC CHIEF'S CRUSHING BLOW IS **CHIEFTAIN'S MAUL**

Three things shared the stem: the Orc Chief's ability (damage 34, BD 56), the Warrior's earnable
ability (damage 43), and the Warrior talent **Crushing Blows**. **The enemy one is renamed** —
least invested, no draft pool, no talent node, no player expectation. What remains is an
ability-against-node label collision, which BR §1 says ships and is flagged; **the
ability-against-ability half is gone.**

### The sweep

**Run against 700 names** — every ability (enemy and hero), every talent node, every status and
every rune. **"Chieftain's Maul" is clean: no exact match, no stem match, no shared word.**

**It rejected three candidates, and a near-miss was treated as a hit every time:**

- **Bonebreaker** — collides exactly with the talent node **Bone Breaker**.
- **Chieftain's Wrath** — collides with Magi's Wrath, Bestial Wrath, Divine Wrath, Roots of
  Wrath, Rune of Old Wrath and the `wrath` status.
- **Skull Splitter** — shares "Skull" with the Goblin Slinger's **Skull Crack**. And
  **Skullsplitter** as one word *slips past a word-level sweep while reading identically in a
  combat log*, which is the near-miss the rule is actually about.

**The sweep found a fourth sharer the brief did not name:** the Ash Brute's **Overhead Crush**.
Left alone — it shares the stem and nothing else.

### The brief was wrong about one thing

**"The log line is the only place any of them is named" is not true.** `master.html`'s Orc Chief
row lists the ability by name and magnitude. It is renamed there too.

### Reported, not fixed

**`master.html` already confuses the surviving two.** The Elemental Weakness row credits "the
**Warden's Crushing Blow talent**", and there is no such talent: **Crushing Blows** is a
**Berserker** node, and **Crushing Blow** is an ability. That is the collision doing damage in the
documentation already — and it is about the two things this batch did **not** rename, so it wants
the designer rather than a guess.

---

## VERIFIED

- **`check_parse`: 0 Parse Errors in the stream, 0 failures.** Grepped from stderr, per the rule,
  never from the tally — **and the gate was proved able to fail first**, with a deliberate syntax
  error in a throwaway copy (`Parse Error: Expected closing ")" after function parameters`).
- **All 11 edited suites parse clean** (`--check-only`, stderr grepped individually).
- **28 targets run — 20 suites and 8 gates — ZERO THROWS, zero timeouts.**
  ah 5625/0, bb 177/2, bn 81/2, bo 1025/1, bp 275/0, bq 742/1, br 1450/2, bs 266/0, bt 458/0,
  bu 480/0, bv 900/0, bw 551/0, bx 147/2, cb 1184/0, ce 1116/1, ah_battle 65/0, aj 418/0,
  bm 1891/0, bl 88/0, cd 86/1. Gates: `check_parse` 0, `check_cs` 104/0, `check_ct` 113/0,
  `check_cn` 0, `check_co` 0, `check_cu` 0, `check_cv` 0 (324 nodes), `check_flow` 0.
  **Every one of the twelve failures is a `CLAUDE.md` content assertion from CW, its knock-on in
  cd, or the glossary "beast" prose from CV. None is a changelog check, and every re-pointed
  assertion passes.** Every suite that did not inherit CW's damage matches its CS baseline.
- **The suites were run TWICE**, before and after the documentation was written — identical counts
  and identical failures both times.
- **A battle resolves**, twice: the Hollow Crown alone, and Shieldmaster + Raider, both to
  `battle_over`.
- **The split verified from backups by a second script**: 140 headings, each appearing exactly
  once, byte-identical rejoin, no size assertions.
- `data/enemies.json` re-parsed after both edits; 21 kinds intact.

## NEEDS A RULING

1. **The eleven red assertions CW left.** What should they ask instead — the surviving rule, the
   report in `docs/reports/`, or nothing? Two of them currently pass by accident.
2. **The four ambiguous relic hooks** (§2), before per-hero relics can start.
3. **Whether relic assignment moves later than the draft**, given the draft runs before specs.
4. **`master.html`'s "Warden's Crushing Blow talent"** — which of the two surviving names is
   wrong there, and does either want renaming.
5. **`test_batch_cp` is not in `run_battery.sh`'s `SUITES` array.** CP was the first dedicated
   test batch and its own suite has never run in the battery. One line; flagged rather than added,
   because adding a suite to the battery changes the baseline every count-diffing rule reads.
