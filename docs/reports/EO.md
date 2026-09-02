# BATCH EO — THE STARTER RUNG TEACHES THE REAL GAME

**Ruled: rung 1 keeps the full game and softens only its blows. It already kept the full game;
what it did not keep was the TIME to use it.**

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*The brief said to verify every premise. Four were checked and one of them was wrong in a way
that would have retired the wrong runes.*

| claim | verdict |
|---|---|
| `TIER_ROWS [0,3,6,9]`, tier 0 opens no rows, clearing rung 1 is the only thing that opens rows 1–3 | **holds** — `Talents.TIER_ROWS` reads `[0, 3, 6, 9]` and `Profile.note_end_boss` clamps the rung into `talent_tier` |
| untalented completion reads **97 / 3 / 0** | **97 / 0 / 0 re-measured** (n=30 a rung). Rung 1 reproduces exactly at 29 of 30; rung 2 read 0 of 30 against EN's 1 of 30, which is one run at an n the report's own header says cannot distinguish a small change from noise. **Read it as 0–3%.** |
| the sixteen runes the charter empties | **reproduced, name for name against EM §3** — but see below |
| EN's threshold: only the Beastmaster is gutted | **holds** |

**AND THE ONE THAT BIT.** A first re-derivation of the sixteen — *every clause writes a `rune_`
field mirroring a live node, excluding `check_em.UNIT_MATH`* — returned **twenty-two**, and the
six extra are runes EN's own threshold table names as SURVIVORS (`burning_censer`, `carrion_wake`,
`level_aim`, `long_draw`, `narrow_gap`, `still_wrist`). **A `UNIT_MATH` clause is not exempt from
the count — it is exactly what makes a rune survive the charter.** `still_wrist` carries
`parry_bonus` 0.04 beside its one talent-keyed clause, so it is still an item that does something
no node does, and it is not *your lane, but more*. With the nine counted as surviving clauses the
derivation returns **exactly sixteen**, matching EM §3 name for name. **Retiring on the first
derivation would have retired six runes that had an argument for existing.**

---

## §1 — WHAT A RUNG ACTUALLY CHANGES. **IT ONLY SCALES NUMBERS.**

**Derived from the code, not from `master.html`.** The ladder is a table of three rows carrying
four fields with a consequence, and every reader of each was swept.

| field | who reads it | what it does |
|---|---|---|
| `rung` | `battle.gd:1078`, `battle.gd:23186`, `run_sim.gd:240` | the enemy-ability filter, the meta gate, the run-report header |
| `mult` | `run_state.zone_base_mult` only | the spawn multiplier |
| `severity_floor` | `run_state.roll_offer` | the guaranteed mild bargain gets less mild |
| `fixed_modifier` | `run_state.arm_fixed_modifier` | rung 3 only: the unduckable nodes carry a modifier |

**`Run.difficulty` outside that block is display and save only** — the victory-screen lines, the
run snapshot and the save dict. Nothing else in the game reads the difficulty.

### THE ANSWER: NO ABILITIES ARE STRIPPED

*Config-diffed through `Enemies.config` at rung 1 against rung 3, all 21 kinds.*

```
KINDS THAT DIFFER BY RUNG: 1 of 21
  hollow_crown : rung1 3 abilities [Crown of Thorns, Hollow Wail, Regalia]
  hollow_crown : rung3 5 abilities [... + Sundering Decree, The Long Dark]
      stats identical: true
```

**`data/enemies.json` carries 50 authored abilities and exactly 2 rung tags**, both on the end
boss. **`Enemies.config` defaults an untagged ability to rung 1** (`if int(d.get("rung", 1)) >
rung: continue`), so **rung 1 is the BASELINE kit and the higher rungs ADD to it.** That is the
ladder working, not the starter rung being gutted, and `enemies.gd`'s own comment has said so
since BM §6: *"THE END BOSS IS THE ONLY USER … it is a filter over authored content rather than a
second kit."*

**Everything else the brief asked about is flat at every rung:** intents (ability `delay`),
statuses and their chances, `pressure` (the Break payload), `stability` (the Break threshold),
`armor`, `speed`, `constitution`, encounter counts (49 at every rung), elite and boss composition
(`compose` and `battle_budget` read no rung), gold (`award_gold` reads no rung) and the relic
ladder (EN §3 established `Relics.unlock_random()` fires above the `is_end` branch).

**So the brief's first branch is the true one: the rung already keeps the full game, and the
boredom is a magnitude problem.**

### BUT THE MAGNITUDE IS ON THE WRONG AXIS, AND THAT IS THE FINDING

**The multiplier applies to `max_hp` AND `attack` together** (`battle.gd:1604-1608`).

**Health is not forgiveness. It is the fight's LENGTH, and length is the only thing that lets an
enemy ask its question.** Because `stability` is a flat 100 at every rung and `ab.pressure` is
flat, **the Break gate needs the SAME number of hero turns at rung 1 as at rung 3** — while the
enemy has half the health to survive them. The same half took the 2.5–4.0 delay telegraphs, the
statuses worth cleansing, and the turn of pressure an item is for.

**Measured untalented, before any change** (`DOD_SIM_ROWS=0`, `--run 30` a rung):

| rounds to resolution | trash | elite | boss |
|---|---|---|---|
| **rung 1** | **5.7** | **5.5** | **7.8** |
| rung 2 | 7.8 | 7.3 | 10.7 |

**Two rounds of questions the rung never got to pose.**

---

## §2 — THE RUNG SCALES DAMAGE, NOT HEALTH

**One multiplier became two, and the only thing they disagree about is the rung.**

```gdscript
func _zone_ladder(slot: int) -> float:      # position, not identity, no rung in it
func zone_base_mult(slot: int) -> float:    # ATTACK — the rung's forgiveness. Unchanged.
	return _zone_ladder(slot) * difficulty_mult()
func zone_base_mult_hp(slot: int) -> float: # HEALTH — the rung floored out of it.
	return _zone_ladder(slot) * maxf(difficulty_mult(), 1.0)
```

`battle.gd` takes both and points `max_hp` at the second. **Ability sets, intents, statuses and
Break gates were already whole — this is what makes them reachable.**

### RUNGS 2 AND 3 ARE UNTOUCHED BY CONSTRUCTION, AND IT IS PROVED RATHER THAN ARGUED

`maxf(mult, 1.0)` returns rung 2's ×1.00 and rung 3's ×1.30 unchanged.

```
BIT-IDENTITY ABOVE RUNG 1: rungs 2-3, 6 of 6 products bit-identical, 0 moved
AND THE ATTACK PATH:       all rungs, 9 of 9 bit-identical, 0 moved
```

**The brief said not to touch rungs 2 and 3. This is an implementation in which touching them is
impossible, rather than one where it merely did not happen.**

### THE SPAWN TABLE AT RUNG 1

*Zone 1, slot 8. The attack column is the rung's forgiveness and is UNCHANGED.*

| enemy | old hp | new hp | attack | stability |
|---|---|---|---|---|
| raider | 90 | **170** | 58 | 100 |
| archer | 70 | **140** | 58 | 100 |
| shaman | 70 | **140** | 29 | 100 |
| brute | 160 | **320** | 58 | 100 |
| withered_warden | 300 | **600** | 58 | 100 |
| hollow_crown | 380 | **750** | 67 | 100 |

### THE VERIFICATION — A LIVE UNTALENTED MEASUREMENT, WHICH IS THE WHOLE BATCH

*`DOD_SIM_ROWS=0`, `DOD_SIM_ROUTE=balanced`, `--run 30` a rung, the standard four specs. Same
seedless conditions before and after.*

| rung | completion BEFORE | completion AFTER |
|---|---|---|
| **1 Wanderer** | **97%** (29/30) | **77%** (23/30) |
| 2 Warden | 0% (0/30) | **0%** (0/30) |
| 3 Ruin | 0% (0/30) | **0%** (0/30) |

**AND AT n=100, BECAUSE n=30 CANNOT CARRY THIS CLAIM AND THE HARNESS SAYS SO IN ITS OWN REPORT.**
At n=30 a completion figure has a ±12-point 95% band, so 97 → 77 is barely more than one band and
is not on its own conclusive. **The two arms were therefore re-run at n=100 against each other** —
the BEFORE arm is this tree with the floor removed from the health path, run in an out-of-repo
copy so the frozen tree was never armed:

| rung 1, untalented, n=100 | completion | trash rounds | elite | boss |
|---|---|---|---|---|
| **BEFORE** — rung in the health path | **92%** (92/100) | 5.7 (n=1130) | 5.5 | 8.0 |
| **AFTER** — damage only | **73%** (73/100) | **9.1** (n=1128) | **8.5** | **12.1** |

**19 points at 3.7 standard errors on the difference — p < 0.001.** And the rounds figure is
measured over ~1,130 fights an arm rather than 30 runs, which is why **it, not the completion
percentage, is the number this batch rests on.** The n=30 BEFORE (97%) and the n=100 BEFORE (92%)
are the same population read twice; both bands overlap.

| rounds, rung 1 (n=30) | trash | elite | boss |
|---|---|---|---|
| BEFORE | 5.7 | 5.5 | 7.8 |
| **AFTER** | **9.2** | **8.5** | **12.3** |

**The rung moved and it moved on the axis the ruling names.** A careless player now loses roughly
one run in four; a first clear is about 1.3 attempts against rung 2's ~30. **The fights are 60%
longer, which is the texture: the enemy now lives long enough to telegraph, to land what it
applies, and for the Break bar to be worth filling.**

**A caveat stated rather than hidden.** Rung 1's 9.2 rounds is a full-length fight; rung 2's 7.6
is an average over fights many of which ended in a wipe, so the two are not like for like. **The
comparison that IS like for like is rung 1 before against rung 1 after**, and that is the pair
above.

### FLAGGED, NOT TUNED: THE DAMAGE SCALE

**`DIFFICULTIES["wanderer"]["mult"]` is still ×0.50 and was not touched.** What changed is what
the multiplier applies to. **77% is reported, not defended** — it is the figure the ruling
produces at the scale the designer already set. If a first clear should be nearer one attempt the
lever is that number upward toward ×0.40; if the rung should bite harder it is downward. **The
lever is the designer's and this batch did not move it.**

### THE ONE PLACE THE RULING'S WORDING AND THE AUTHORED LADDER DISAGREE

§2 says *rung 1 enemies keep their full ability sets*. Read to the letter that would give the
rung-1 end boss all five abilities — **and it would delete the only genuine mechanical escalation
in the ladder**, leaving rungs 2 and 3 differing from rung 1 by numbers alone, which is the very
thing §1 was written to test for. §1's own conditional says that when nothing is stripped *"the
ruling is then nearly already implemented and the batch is a tuning pass."* Nothing is stripped:
the two abilities are an ADDITION above rung 1, not a removal below it. **They were left alone
and this is reported rather than decided.** Giving the rung-1 Crown its full five is a one-line
change to `data/enemies.json` and it is the designer's.

---

## §3 — THE SIXTEEN: THREE HELD BACK, ONE FLAGGED, TWELVE RETIRED

**The split, and where the brief's own two sentences had to be read together.** §3 rules *retire
the rest* and then rules that the Bared Guard is *reported separately and ruled on nowhere.* The
second is the more specific instruction and it governs: **the Bared Guard is NOT retired.**

| | count | what happened |
|---|---|---|
| re-author (Beastmaster) | **3** | presented as options below. **Nothing authored.** |
| flagged, ruled on nowhere | **1** | the Rune of the Bared Guard |
| **retired** | **12** | kept, and said to be kept |

### HALF ONE — THE THREE RE-AUTHORS, AS OPTIONS. NOTHING WAS AUTHORED.

*The standing rule applies: rune content is content and it is the designer's. Each is given theme,
balance, synergy and mechanical interest, and none is written.*

**Rune of the Deep Bond** — 100g, lane *devotion*. Both clauses scale on Loyalty.
· *Theme.* The bond that deepens rather than the bond that spreads: the longest-standing companion
  is the one that has earned something.
· *Axis.* **DEPTH** — read the accumulated meter and pay its depth, the row-8 shape applied to an
  item.
· *Balance.* This is the risk: Loyalty is the meter `state.md` already reports over-arriving at a
  21.2 peak against a nominal 5, so depth-scaling pushes the direction that is already too far.
  A cap, or a payout that flattens above the nominal, is the obvious counterweight.
· *Synergy / interest.* It is the only one of the three that rewards NOT swapping, which makes it
  the natural opposite of the Turning Pack and gives the pair a real decision between them.

**Rune of the Turning Pack** — 100g, lane *pack*. Its clauses reward different companions fielded.
· *Theme.* The handler who never shows the same animal twice.
· *Axis.* **BREADTH / TEMPO** — pay for the SWAP itself rather than for what the swapped-in beast
  hits for.
· *Balance.* The Beastmaster's boss pool already deals no damage and no Break at all (`state.md`),
  so a second non-damaging item deepens a concentration finding rather than answering one. A
  version that pays the swap in Break or in a damage window would answer it instead.
· *Synergy / interest.* Tempo is the axis his kit is thinnest on, and a swap-priced rune makes
  Quick Whistle a decision rather than a formality.

**Rune of the Shared Wild** — 100g, *splash*. Already carries `rune_companion_hp_pct`.
· *Theme.* The beast that comes home. The only one of the three about the companion's body.
· *Axis.* **SURVIVAL** — the companion living through the fight rather than hitting harder in it.
· *Balance.* Safest of the three: it adds no damage to a spec whose damage is already concentrated,
  and companion durability is the one Beastmaster number no other rune touches.
· *Synergy / interest.* **It is the only splash of the three, and splashes are the half the charter
  hurt most** — with no lanes to reach across, "a little of every bond" has nothing to reach.
  Re-authoring it as one idea makes it a lane rune wearing a splash's name, and that is a real
  cost the designer should price before choosing this one.

**And the honest note on all three:** these are the only runes among the sixteen whose retirement
would remove a MECHANIC from the game rather than an item from a shelf. **After a blanket
retirement there would not be one rune in the game touching a companion** — no class-wide or
universal rune does either — **and the companion IS the spec.**

### HALF TWO — THE TWELVE RETIRED, AND WHAT EACH LOSES

**Each carries a `retired` string in `data/runes.json` naming what is lost.** The full text is in
the data; the summary:

| rune | spec | what is lost |
|---|---|---|
| Resonant Core | Arcanist | the first-cast Resonance grant — nothing else touches the BUILD RATE |
| Boiling Blood | Berserker | one clause; `broad_path` already carries a Blood Frenzy term. **The thinnest loss.** |
| Bitter Grip | Cryomancer | the only item pairing Chilled's slow with a crit window on HELD enemies |
| Long Winter | Cryomancer | breadth across three cold terms; `killing_cold` still covers Chilled |
| Open Hand | Holy Cleric | a splash of three graces; the opening Mercy has no other home |
| Standing Vow | Devout | a splash of three vows — **and the thread DO quietly narrowed (EM §5) closes by removal** |
| Warded Robes | Devout | Divine Shield's absorb-to-healing conversion; nothing else turns an absorb into a heal |
| Long Hunt | Survivalist | a splash across poison, traps and Tripwire |
| Weeping Wound | Survivalist | the only item that changes what his BASIC ATTACK leaves behind |
| Deepening Ruin | Occultist | **one of EN §1's two** — its Entropy half is the tick EN gave a field to |
| Whispering Dark | Occultist | **the other** — four clauses, the widest payload in the game |
| Deep Sight | Sharpshooter | the Focus conversion POINT moving; `level_aim` and `long_draw` pay Focus but neither moves the point |

**THE OVERLAP THAT CANNOT BE READ APART.** The Deepening Ruin and the Whispering Dark are both
the Occultist's and are the only two runes where EN §1 and this §3 meet. **Retiring them retires
two of the three fields EN authored the day before.** They were retired because the ruling is a
blanket one and both are squarely inside it; **that they are inside it is the reason they cannot
be reversed independently of each other.**

### RETIRED MEANS KEPT, AND SAID TO BE KEPT

**The Melted Armor contract**, whose glossary entry says outright that nothing applies it —
`docs/text-audit.html` calls it the most honest string in the game.

· The entry **stays in `data/runes.json`** with a `retired` string naming what is lost.
· `Runes.config`, `build` and `display_name` **all still resolve it**, so a saved run holding one
  keeps working and a later batch can point something at it again.
· **One `continue` in `Runes.eligible_ids`** stops it being offered. That is the only door: both
  offer paths — `Runes.generate` and `run_state.grant_rune` — reach the authored pool through it
  and nothing else.

**AND THE CONTRACT PAID FOR ITSELF IMMEDIATELY.** `pin-manifest.json` pins five literals into
`data/runes.json` from `test_batch_bj`, and one of them — `"which catches 1 Ruin"` — is the
Whispering Dark's own description. **A retirement that DELETED the entry would have taken that pin
red.** All 13 runes.json pins were verified unmoved.

### THE RETIREMENT CANNOT BLANK AN OFFER

*Measured through the game's own door, every spec, empty pouch. 65 authored, 12 retired, **53
offerable**.*

```
FLOORS — drawable 9, spec-scoped 2, rare shelf 5, against 3 rune slots
```

The Occultist is thinnest at 9 drawable / 2 spec-scoped. An exhausted rarity widens to every
rarity and then to the generated Common family; `grant_rune` falls back to `generate_rune`.
**The Beastmaster is the only spec whose pool did not shrink at all** — 4 of 4 spec runes survive,
because his three went to the re-author half. **EN's threshold did exactly the job it was written
for.**

### THE SCARRED ONE, REPORTED APART AND RULED ON NOWHERE

**The Rune of the Bared Guard — Swordmaster, 75g, lane Blade, `scarred=true`, and the only Scarred
rune among the sixteen** (derived, not assumed).

**Its two clauses ARE the trade:** `rune_seasoned_off_bonus` +0.10 (Aggressive Stance deals 10%
more) bought with `rune_seasoned_def_bonus` −0.15 (Defensive Stance stops reducing damage taken).
**Retiring it removes the cost with the upside**, so it cannot be priced as a loss the way the
other twelve can.

· **As a loss:** it is the only item in the game that lets a Swordmaster buy *commitment*. Trading
  a defensive posture for an aggressive one is a decision no other rune in his pool offers —
  `still_wrist`, `shattered_guard` and `duelist` are all pure upside.
· **As a gain:** his pool would go from one Scarred rune to none, and **he would be the only spec
  in the game with no Scarred rune.** That is a set-shape change, not a content change.
· **Nothing mechanical depends on it either way:** `Runes.is_cost()` already refuses to scale its
  negative term under the sim's rarity lever.

**It is live, offerable and untouched. The designer should see it alone.**

---

## §4 — THE TWO EN LEFT ON THE RECORD

### RUNG 2's GAP DOES NOT CLOSE WHEN ROWS 1–3 OPEN

**This is the measurement the brief asked for**: rung 1 unlocks rows 1–3, so the question is what
rung 2 reads for a player wearing exactly those.

| rows equipped | rung 2 | rung 3 |
|---|---|---|
| 0 (untalented) | 0–3% | 0% |
| **3 (what rung 1 unlocks)** | **7%** (2/30) | **0%** (0/30) |
| 9 (fully talented, EN) | 80% | 80% |

**It does not close.** A player who clears rung 1 and spends everything it unlocked arrives at a
rung they clear roughly one time in fourteen. **The curve is not working between rungs 1 and 2,
and by the brief's own instruction that is reported and stopped — the second rung is the next
problem and it is not this ruling.** The jump is ×0.50 → ×1.00 in one step, against a talent
ladder that opens a third of itself at a time.

### PER-HERO RELICS

**Not this batch, as the brief directs.** EN confirmed code and document agree — `Run.active_relics`
is a flat list of up to 3 ids with no hero key, party-wide at all 25 read sites — and that the
ruling points elsewhere and is unbuilt. **It belongs to the relic family's batch, which is queued.**

---

## §5 — WHAT MOVED, AND THE SUITES THAT MOVED WITH IT

| file | what |
|---|---|
| `scripts/run_state.gd` | `_zone_ladder` factored out; `zone_base_mult` unchanged in value; `zone_base_mult_hp` added |
| `scripts/battle.gd` | a second spawn multiplier; `max_hp` points at it |
| `scripts/runes.gd` | `is_retired`; `eligible_ids` skips a retired entry |
| `data/runes.json` | 12 `retired` strings, inserted textually — **12 insertions, 0 other bytes moved** |
| `test_runes.gd` | the retirement asserted in BOTH directions; the grant loop derives its count |
| `test_rune_battle.gd` | `_equip_all` walks `Runes.ids()`, not `eligible_ids` |

### WHY EACH SUITE MOVED THE WAY IT DID

**`test_runes` — 3125 → 3101 checks.** Two changes. Its eligibility arm asserted *every authored
spec rune rolls for its own spec*; that is now **two-armed** — a retired entry must roll for
NOBODY, a live one must still roll for its spec. **An exemption arm instead would read green on
the day the whole file stopped rolling**, which is the shape `check_em` §4 was inverted to avoid
at EN §6. And its `_rich_grant` loop asked for the literal **4** spec runes every spec was
authored; the retirement leaves some specs 2 or 3, `grant_rune` then correctly falls back to the
ordinary roll, and that read as nine failures. **It asks for the number that survives now**, so a
further retirement or a restored re-author needs no edit there. The 24-check drop is that loop
running 2–4 times a spec instead of 4.

**`test_rune_battle` — unmoved at 97, inside its recorded 0–1 fail band.** `_equip_all` walked
`Runes.eligible_ids`. **The negative control corrected this batch's first statement of the
reason, and the corrected one is sharper.** Walking the offer pool does NOT fail silently: armed,
it reads **17 failures**, because the clause assertions name specific runes and specific values —
the Deepening Ruin paying 0 per stack is loud. **What it is is BROKEN, and there are exactly two
repairs that make it green again:** walk the authored set, or delete the twelve runes' clause
assertions. **The second is the silent one and it is the tempting one** — smaller diff, and the
same shape as the repair this batch made one file over, where `_rich_grant`'s hard-coded 4 became
a derived count. **The coverage loss is one obvious repair away, not zero.** It walks
`Runes.ids()` filtered by scope now — including the Deepening Ruin's Break tick, which EN had
authored a field for the day before. **Whether a rune is OFFERED is `test_runes`' question;
whether its clauses PAY is this file's, and the retirement does not change the second.**

---

## WHAT THIS BATCH DID NOT DO, STATED SO IT IS NOT READ AS CLEAN

· **The ×0.50 damage scale was not tuned.** 77% is reported, not defended.
· **Nothing was authored for the three re-authors.** They are options.
· **The Bared Guard was not ruled on.**
· **Rungs 2 and 3 were not touched**, and rung 2's 7%-with-rows-3 is reported and left.
· **The rung-1 end boss keeps 3 of 5 abilities.** The disagreement between §2's wording and the
  authored escalation is reported and not decided.
· **No Break-count telemetry was added.** The mechanism is evidenced by rounds-to-resolution and
  by the flat `stability` / `pressure` arithmetic, not by a direct Break tally in run mode — the
  run report does not print one and adding output to `run_sim.gd` during a freeze was not worth
  the risk.
· **Nothing was measured with talents on.** Every completion figure here is `DOD_SIM_ROWS=0`
  except the §4 table, which is `DOD_SIM_ROWS=3`.

---

## THE VERIFICATION RUN

**The floor first, the way the brief specifies.** `grep -lE 'Parse Error'` over every one of the
87 battery logs: **0 files matched.** `SCRIPT ERROR`: **0 files matched.** Never a tally, never an
exit code.

| | |
|---|---|
| targets run | **87** |
| checks | **41,421** |
| throws | **0** |
| `Parse Error` | **0** |
| the differ | **`check_de`: 358 / 0 / 0 after the one predicted row moved** |

**THE TREE WAS FROZEN AND THE FREEZE WAS PROVED**, not assumed: **202 files md5'd by absolute
path** before the run and again after — identical. `.ran` holds **87 names with no duplicate**, so
no second battery wrote into the same directory.

**ONE BASELINE ROW MOVED AND IT WAS PREDICTED BEFORE THE RUN:** `test_runes` 3125 → **3101**.
`check_de`'s first pass named exactly that row and nothing else; the row was moved with its
reason and the differ re-run over the same logs reads **358 / 0 / 0**.

**THE TWO STANDING REDS ARE STANDING, AND THE DIFFER SAYS SO RATHER THAN THIS REPORT.**
`test_rune_battle` reads 97 / 1 against a recorded band of 97 / 0–1, and `check_cm_live` reads
13 / 4 against a recorded 13 / 4. **Neither moved.**

### THE PRE-CHECK THAT PAID FOR ITSELF, AND IT IS THE ONE EN WROTE THE RULE ABOUT

**`master.html` prose written for §2 said "before the party could reach it".** That is DL §2's
retired word, and `test_batch_bx` §4b reads `master.html` — one of nineteen SUITES among its 25
readers. **It was caught before the battery by reproducing §4b's own strip** (lower-case, five
marked identifiers removed, then `contains("party")`) rather than by a literal sweep, which could
never have seen it. **Repaired to `heroes` with no claim changed.**

**THE POPULATION WAS DERIVED BY GREPPING THE PATH, NOT BY REASONING ABOUT IT** — `master.html` 25
readers (6 gates, 19 suites), `CLAUDE.md` 27, `changelog.html` 16, `design-notes.md` 4,
`data/runes.json` 11. **All 41 deduped targets were run before the battery: 0 red, 0 blank, 0
parse errors** — and *blank* had to be counted separately, because **the verdict line has three
shapes** (`N checks / M failures`, `N checks, M FAILED`, and `checks: N   failures: M`) and a
one-shape grep read five of them blank, which looks exactly like "did not run".

### THE PRE-CHECK ON `runes.json`, WHICH FOUND THE §3 REGRESSIONS BEFORE THE BATTERY DID

Running the eleven `runes.json` readers ahead of the run caught **`test_runes` at 24 failures and
`test_rune_battle` at 17** — both the retirement's intended effect meeting assertions that pinned
the pre-retirement offer. Both were repaired to the new ruling before the frozen run, which is why
the battery cost one row rather than a second thirty-five-minute pass.

### THE NEGATIVE CONTROLS, AND ONE OF THEM CORRECTED THE REPORT

**Every control was armed on something a suite demonstrably reads, and every one bit.**

| control | armed | result |
|---|---|---|
| **1 — the retirement's only door** | `eligible_ids`' `continue` neutered | **12 failures**, one per retired rune. Disarmed: 3101 / 0. |
| **2 — `_equip_all`'s walk** | pointed back at `eligible_ids` | **17 failures** |
| **2b — and the repair that WOULD hide it** | the count assertion relaxed as well | still **15 failures** |
| **3 — the health path** | the floor removed from `zone_base_mult_hp` | rounds returned to **5.8 / 5.4 / 8.1** against the disarmed 9.2 / 8.5 / 12.3 |
| **the needle sweep itself** | a live pin deleted from a scratch copy | **LOST=1** — the sweep is not vacuous |

**CONTROL 2 CORRECTED A CLAIM THIS REPORT HAD ALREADY MADE IN FIVE PLACES.** The first draft said
walking the offer pool *"would have silently stopped driving all twelve retired runes while still
printing green."* **It is not silent — it reads 17 failures**, because the clause assertions name
specific runes and specific values. The corrected claim is sharper: **there are exactly two ways
to make that file green again, and the second one — deleting those twelve runes' clause
assertions — is the silent one, the smaller diff, and the same shape as the repair this batch made
one file over.** The coverage loss is one obvious repair away, not zero. **All five documents and
the source comment were corrected.**

**CONTROL 3 IS THE TWO-ARMED ONE AND IT IS WHY THE n=100 RE-RUN HAPPENED.** Armed, the rounds
returned to the HEAD baseline (5.8 / 5.4 / 8.1 against HEAD's 5.7 / 5.5 / 7.8) — so the health
path is unambiguously what sets the fight length. But its completion read **87%**, between HEAD's
97% and the fix's 77%, which exposed that **a completion figure at n=30 has a ±12-point band and
cannot carry this batch's claim.** Both arms were therefore re-run at **n=100** against each
other, the BEFORE arm in an out-of-repo copy so the tree was never armed: **92% → 73%, 19 points
at 3.7 standard errors**, and rounds **5.7 → 9.1 over ~1,130 fights an arm.**

### THE POST-RUN EDITS, AND THE PROOF THEY COST NOTHING

Six files were edited after the frozen run — `CLAUDE.md`, `docs/changelog.html`,
`docs/design-notes.md`, `docs/state.md`, `docs/reports/EO.md`, `baselines.json` and
`test_rune_battle.gd`'s comment. **A needle sweep of all 230 document pins in the manifest flipped
0 LOST / 0 GAINED**, and **the sweep instrument was itself armed on a live pin and bit.**
**But the sweep is not the proof**, because a `contains("party")`-shaped assertion never flips a
needle — so **all 41 doc-reading targets were re-run: 0 red, 0 blank, 0 parse errors.**
`check_ed` reads 18 / 0 and `build_pin_manifest.py --check` reads *current*.

### WHAT THE INSTRUMENTS COULD NOT SEE, NAMED RATHER THAN DISCOVERED LATER

· **No Break-count telemetry exists in run mode.** `breaks_on_enemies` accumulates in `sim_stats`
  but the run report never prints it. **The Break claim is evidenced by fight LENGTH plus the flat
  `stability` / `pressure` arithmetic, not by a Break tally** — adding output to `run_sim.gd`
  during a freeze was not worth the risk, and it is the obvious next instrument.
· **The completion sweep cannot distinguish "easy" from "short"**, which is exactly how the health
  half survived this long. Rounds-to-resolution can, and is the number this batch rests on.
· **The rung-1 rounds figure is not comparable with rung 2's** — rung 2's average is truncated by
  wipes. Only the rung-1 before/after pair is like for like.
· **Nothing was measured on the real difficulty a human plays at.** Every figure is the bot's, with
  the harness's standing exclusions (no offensive item use, severity-extreme bargains only).
