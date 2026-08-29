# BATCH DT — LOOSE ENDS

*2026-08-29. Four items, no new play. Two were mechanical, one came back as options, one is a
report. **Two of the brief's premises were wrong under measurement and both changed the work.***

---

## THE TWO BRIEF CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because both changed what this batch did.

1. **§3 said `test_rune_battle` is unseeded, "with `seed()` never called". IT IS SEEDED.** DF §0 put
   `_seeded()` immediately before the forced White Flame hit — **the exact site that flakes** — and
   nowhere else, which is the per-site idiom §3 itself asks for. Its own `baselines.json` row says
   so in as many words, and so does `docs/state.md`. **Nothing was owed there and nothing was done.**
   The one stale artefact is a comment inside the file (`test_rune_battle.gd:23`) that still reads
   *"`seed()` zero times"* — pre-DF prose describing the defect the seed below it fixed. It is left
   alone deliberately: it sits inside DF's own explanatory header, four lines above the fix, and
   editing prose inside a suite is not this batch's business.
2. **§3 said DD's per-pair method "settled `at`". IT DID NOT, AND `at` IS STILL OPEN.** DD fixed
   **two other checks of that species in that suite and did not reach §1's damage-curve ratio**,
   which is the flake. `baselines.json` carries `test_batch_at` at `fails: [0, 1]` — a zero floor
   and a one ceiling — not a row that settled at 3. The method is right; the precedent named for it
   is not. **The method was applied to `bo` on its own merits.**

**The brief's third premise held exactly:** `test_batch_bo` calls `seed()` zero times, and its §5
NULL FIELD check is the real unseeded flake.

---

## §1 — `check_ds.gd`, FOR THE TWO SPECIALS NOTHING COVERED

**57 checks, 0 failures, ~25s (measured while a stray process from the DS session was still
holding CPU — see §5). Added to `run_battery.sh`'s `GATES`, which goes 22 → 23.**

DS authored six Hunter cards and added no gate, and named the cost rather than hiding it:
`check_co`'s saturation sweep reaches four of the six as a side effect, and **`bring_it_down` and
`heads_down` were covered by nothing at all.** Both were driven through a real battle at DS in a
scratch fixture that is not in the repo — and that throwaway run is what found the `cost > 0`
fault. This is the permanent copy of it.

**IT SPAWNS TWICE, AND THAT IS FORCED RATHER THAN CONVENIENT.** `Gate.spawn` fields one hunter
slot and the two cards belong to two different Hunter specs: a Beastmaster cannot hold Heads Down
and a Sharpshooter cannot hold Bring It Down. `check_di` is the precedent.

### §1a — BRING IT DOWN IS MEASURED, NOT ASSERTED

The card is **stamped in one place and read three thousand lines away**, off each wearer's own
status power. That is precisely the shape that produced DK's Empower defect — a status that
attaches perfectly, hangs a chip, and moves no number — so the amp is measured on real strikes
through `_resolve` rather than asserted.

| arm | 10 seeded Warden strikes | ratio |
|---|---|---|
| plain | 8526 | — |
| under the capped +20% | 10233 | **1.2002** (want 1.2000) |
| amp on the PARTY, not on him | 8526 | **1.0000** |

**THE THIRD ARM IS NOT DECORATION AND THE NEGATIVE CONTROL PROVED IT.** Replacing the per-wearer
read with a party-wide global **passed both of the first two arms** and failed only the third. Without
it, "read off each wearer's own status power" — the source comment's claim, and what makes the class
card and this one compose additively rather than one winning — would have had no assertion behind it.

Also pinned: the **snapshot** (deepening the bond after the cast moves nothing), the **cap** at 15
Loyalty, the **no-bond refusal** (a +0% amp stamped on four heroes is a chip that reads as working),
that **the bond is not spent**, and that **the beast does not wear the amp it earned** — the walk is
`heroes` and not `_hero_side()`, which is the one property the card text does not state and the
handler does.

### §1b — HEADS DOWN, AND THE ASSERTION A STATIC CHECK COULD NOT MAKE

The brief asked for an assertion the mana premise could not pass. This is it.

**The discriminator is not "the refusal works".** Both versions of the card refuse abilities, both
name a criterion, both log a fallback, and both would satisfy a source-string check. The only thing
that separates them is a live count: **how many of the abilities actually refused on a real kit cost
nothing.**

- Under the shipped identity test against `_cheapest_attack`, that count is positive.
- Under `cost > 0`, it is **zero on every kit in the game but two**.

So the assertion is `free_refused.size() > 0` — *the refusal reached something free* — evaluated by
walking a live enemy's live kit through `_intent_ability_usable`. On the fixture's raider:
**2 abilities, 1 kept, 1 refused, and the refused one (Sundering Strike) costs ZERO.**

**THE CORPUS FIGURES ARE DERIVED ON EVERY RUN, NOT WRITTEN DOWN.** §0 walks `data/enemies.json`:
**50 abilities across 21 kits, 46 of them free**, and — the number that actually matters —
**14 of the 21 kits carry a zero-cost DAMAGING ability that is not the basic**, which are exactly
the kits where a cost test suppresses nothing while the chip says it did. The assertion is a
**ratio** (≥90% free) rather than a literal, so it stays true as enemies are authored and goes red
if the mana premise ever becomes live.

Beside it: the silence leaves **exactly one** ability usable and it **is** `_cheapest_attack`, so
the fallback cannot be starved (that is what keeps this a downgrade and not a Stun); the downgrade
is driven for real through `_revalidate_intent`, which returns the basic and increments
`intent_fallback` by exactly 1; an **unbroken boss** still receives it, driven live rather than
pinned as a literal, because two suites already pin `_apply_status`'s carve-out and a third copy of
one fact is DJ §3's rule; and `_choose_enemy_action` is asserted to contain no `heads_down` read at
all, which is BL §1's promise kept in the direction that can break it.

### §1c — FOUR NEGATIVE CONTROLS, ALL FOUR BIT

A check that passes on the fixed tree proves nothing until it is shown to fail on the broken one.
**`scripts/battle.gd` was backed up to the scratchpad and restored by `cp` after each, never by
`git checkout`; the md5 was verified identical after all four.**

| control | what it did | result |
|---|---|---|
| 1 | identity test → `cost > 0` | **6 failures**; the raider read "2 kept, 0 refused" |
| 2 | `for bid_h in heroes` → `_hero_side()` | 1 failure — the beast wore the amp |
| 3 | strike-site read deleted | 1 failure — **ratio 1.0000**, DK's defect exactly |
| 4 | per-wearer read → party-wide global | 1 failure — **only the third arm caught it** |

### §1d — IT TRIPPED `check_da` §3 ON THE FIRST RUN, AND THE FIX WAS NOT AN EXEMPTION

**`check_da` §3 went red naming `check_ds` as a hand-rolled corpus walk.** The brief warned this
might happen and required that a real violation be told from a false positive before anything was
exempted. **It is a false positive, and a self-inflicted one.**

`check_ds` calls neither draft-pool accessor. Its **header comment** named both of them — in the
course of explaining that the gate does not use them — and §3's fingerprint is a substring match
over the whole source, so the paragraph denying the walk *is* the walk as far as the match is
concerned. `check_da`'s own header records this trap for its own source and solves it by splitting
the literals at runtime; **a comment cannot concatenate**, so the names came out of the prose and
the paragraph now says why they are absent.

**AN EXEMPTION HERE WOULD HAVE BEEN AN EXEMPTION GRANTED TO A SENTENCE**, and it would have blinded
§3 to a real walk arriving in that file later — which is the brief's own point, and worse than the
violation it would have covered. `check_da` reads 37/0 again, its baseline exactly.

The mirror of the comments-record-removals rule is now in `CLAUDE.md` beside it: **before writing a
comment that names a banned string, ask whether anything greps for it.**

---

## §2 — PYROBLAST'S COOLDOWN: PRESENTED, NOT DECIDED

**NOTHING WAS AUTHORED. No file under `scripts/` was touched for this section.**

### WHAT IT IS, DERIVED

| | Pyroblast | Lunge (DR's precedent) |
|---|---|---|
| cost | **45** | 25 |
| damage | 55% of Attack, **×1.5 vs a Burning target** | 30% |
| delay | **6.0** | 3.5 |
| cooldown | **0** | 3 (was 0) |
| type | fire | physical |
| Perfect | **none advertised, and it runs a skill check** | — |

Its text: *"The long cast: 55% of Attack in fire, and HALF AGAIN against a target that is already
Burning. It consumes nothing — it simply asks you to have lit the fire first."*

### WHERE THOSE NUMBERS SIT IN THE PROJECT — THE PART THAT DECIDES THE QUESTION

Derived across all **223** abilities in the corpus:

- **6.0 is the LONGEST DELAY IN THE PROJECT. Nothing is above it.** Second is Death Ray at 5.0;
  third is Wildstrikes at 4.5. It is **three times `Ability.BASIC_DELAY` (2.0)**.
- **45 is the SECOND-HIGHEST COST IN THE GAME.** Exactly one ability costs more — **Death Ray at
  55, and Death Ray carries cooldown 3.**
- A Pyromancer's bar is **100**, so a full bar buys **two casts** with 10 to spare.

**So the two heaviest casts in the game sit side by side and exactly one of them is repeatable.**

### DOES LUNGE'S REASONING APPLY? NO — AND THAT IS THE SECTION'S FINDING

DR's reasoning was *"at the end of a talent lane the price was the node, and in a pool there is no
price."* **The provenance is identical**: both were talent grants living in no pool, both were moved
wholesale into `SPEC_DRAFT_POOLS` by DO, and both walked in still carrying the cooldown a gated
lane-end ability never needed. **The reasoning still does not transfer.**

Lunge cost 25 of a 100 bar at 3.5 delay — **ordinary on both axes**, so "in a pool there is no
price" was literally true of it once the node was gone. **It is false of Pyroblast, which is priced
twice and simply not with a cooldown**: hardest in the game on tempo, second-hardest on mana.

**A cooldown is not this project's only rate limiter, and cooldowns tick in the unit's own turns.**
A 6.0-delay cast has already spent three basic attacks' worth of tempo before a cooldown would
begin counting down. **What a cooldown of 3 would take from it** is three further turns of his own
between casts, each one a real action he would rather have spent on Pyroblast — roughly halving its
frequency, on a card whose entire identity is the one enormous slow blow.

### THE OPTIONS, AS OPTIONS

1. **Leave it at 0 and write down that a repeatable card is a legitimate draft shape when it is
   priced elsewhere.** Closes the open queue item without moving a magnitude. The argument is above:
   it is already the most tempo-expensive and second most mana-expensive cast in the game. **The
   cheapest option and the one the measurement supports.**
2. **Give it a cooldown anyway, on the uniqueness argument rather than the price argument.** DQ's
   finding was that it is the *only* repeatable draft card; that stands regardless of what it costs,
   and consistency across a draft has value the arithmetic does not capture. **If taken, 2 rather
   than DR's 3** — Death Ray at a higher cost and a shorter delay carries 3, so 3 here would price
   Pyroblast strictly above the card that is strictly heavier.
3. **Leave the cooldown and price the conditional instead.** The ×1.5-vs-Burning clause is the real
   ceiling and it is the half nobody has measured; a Pyromancer keeps the field lit by construction,
   so the multiplier is closer to always-on than the text implies. **This is the only option that
   needs a sim first, and no sim has run since DK.**

**Option 1 is what the derivation supports. It is not taken, because it is a ruling.**

### EVERY OTHER COOLDOWN-ZERO ABILITY

**Seven in the 223-ability corpus, and FOUR MORE THE CORPUS CANNOT SEE.**

| ability | cost | dmg | where it lives | is zero correct? |
|---|---|---|---|---|
| **Strike** | 0 | 23 | CORE — berserker, warden, swordmaster | **yes — free basic attack** |
| **Quick Shot** | 0 | 20 | CORE — beastmaster, sharpshooter, mystic | **yes — free basic attack** |
| **Smite** | 0 | 44 | CORE — holy, inquisitor | **yes — free basic attack** |
| **Magic Bolt** | 0 | 25 | the Mage class base kit — **overridden for all four mage specs** | **yes — free basic attack** |
| **Ashes of Al'ar** | 30 | 0 | **BOSS-PICK** — pyromancer, cryomancer, arcanist + mage class | **not a basic attack** |
| **Sweeping Strikes** | 20 | 15 | **BOSS-PICK** — swordmaster + warrior class | **not a basic attack** |
| **Pyroblast** | 45 | 55 | **SPEC DRAFT** — pyromancer | the open question |

**FIVE OF THE SEVEN ARE FREE BASIC ATTACKS AND ZERO IS CORRECT ON ALL FIVE.**

### AND A BLIND SPOT IN THE CENSUS ITSELF, WHICH IS THIS SECTION'S SECOND FINDING

**FOUR LIVE PROTECTED-CORE BASIC ATTACKS ARE NOT IN `Classes.ability_corpus()` AT ALL.**
`apply_kit_overrides` replaces `abilities[0]` for each of the four mage specs at battle spawn:

| spec | its live basic | cost | cooldown |
|---|---|---|---|
| occultist | **Shadowrend** | 0 | **0** |
| pyromancer | **Fireball** | 0 | **0** |
| cryomancer | **Frostbolt** | 0 | **0** |
| arcanist | **Arcane Explosion** | 0 | **0** |

**None of the four sits in any pool and none is returned by `spec_abilities()`**, so the corpus walk
— which reads `kit("mage")` and gets the *unoverridden* Magic Bolt — never reaches them. Their
NAMES are reachable through `Classes.protected_names()`, which does apply the overrides; their
`Ability` objects, and therefore their cooldowns, are not reachable anywhere.

**This is why the recorded figure is "twelve cooldown-zero abilities in the protected cores".**
It is **twelve instances across twelve specs but only seven distinct names** — Strike ×3,
Quick Shot ×3, Smite ×2, and the four mage overrides — and **Magic Bolt, the one the corpus does
carry, is nobody's live basic.**

**Nothing is wrong at runtime**, and the answer about Pyroblast does not change: all four are free
basic attacks where zero is correct. **What is worth knowing is that `check_dr` §5's census — and
any sweep built on `ability_corpus()` — has four live cards it structurally cannot see.** Reported,
not fixed: widening the corpus walk is a change to the one authored enumeration this project has a
standing rule about, and it belongs to whoever rules on it.

### AND TWO BOSS-PICK CARDS THAT WERE ON NOBODY'S LIST

`check_dr` §5 walks `SPEC_DRAFT_POOLS` only, so **Ashes of Al'ar and Sweeping Strikes have never
appeared in the cooldown-zero census** — both are repeatable, both cost real mana, and neither is a
basic attack. This is not a new defect; it is the **boss-pick pools were dumped but not audited**
thread, and it is the second thing that thread has produced (`SPEC_POOLS` still holding Lunge and
Execute was the first). **Reported, not ruled on.** Whether the boss-pick channel wants the same
answer the draft channel gets is part of the same decision.

---

## §3 — THE FLAKES

### `test_batch_bo` — SEEDED, AND IT SETTLED AT ZERO

`test_batch_bo.gd` called `seed()` **zero** times. Its §5 NULL FIELD check resolves the same enemy
attack against the Arcanist at 2 Resonance and at 14 and requires `deep < shallow`.

**The seed is per-pair and not per-suite** — DF §0's idiom, and DD's method. `_nf_seeded()` is
called immediately before **each of the two compared blows with the same constant**, so both arms
draw one identical stream and the only difference left between them is the stack count. The other
**1104 checks keep their own draw**, which is the whole reason not to seed the suite: widening the
seed changes what the rest of the file measures, and **the band is the question**.

**IT SETTLED AT ZERO, NOT AT A RED** — so it was a flake and not a finding.

| | before the seed (6 readings) | after (6 readings) |
|---|---|---|
| shallow | 18, 16, 23, 18, **28**, 17 | **17 every time** |
| deep | 10, 10, 11, 11, 9, 10 | **10 every time** |
| checks / failures | 1106 / 0 | **1106 / 0, six for six** |

**AND THE DOCUMENTED CAUSE WAS INCOMPLETE, WHICH IS WORTH MORE THAN THE FIX.** The recorded reason
was *"the damage carries a ±10% roll so both can land on the same integer"*. **A ±10% roll on a mean
of 18 spans 16.4 to 19.8 and cannot reach 28. A crit is ×1.5 and reaches exactly there.** So this is
`at`'s shape — **a second and larger coin hiding behind a variance roll that was taking all the
blame** — and it is precisely why a per-pair seed was the right instrument: it neutralises every
coin at once without anyone having to identify which one was biting. A widened band would have had
to be widened to fit a crit, and that band is the assertion.

**The change is four lines of code and nothing else**, proven with a comment-stripped diff against
`HEAD`: the two-line helper and its two call sites. The check count does not move.

### `test_rune_battle` — NOTHING OWED

Seeded at DF §0, at the exact site that flakes. See the top of this report. **Deliberately not
seeded a second time**: DF's header states that if it still reds when seeded, the cause is not the
draw, and `_pierce_why` is already in place to say what it was instead. A second seed would fix the
draw for 96 checks that never asked for it.

### `test_batch_at` IS NOW THE LAST ONE, AND IT IS DELIBERATELY NOT TAKEN

With `bo` closed and `test_rune_battle` already done, **`at`'s §1 unseeded damage-curve ratio is the
only flake left in the project.** It is not taken here, for the standing reason `docs/state.md`
repeats: **one flake at a time is how the effect stays attributable.** `bo` is this batch's one.
Its repair is the same four lines — seed both blows of the compared pair — and the same
second-coin diagnosis almost certainly applies, since the suite's own `_spawn` already names the
crit as the candidate.

---

## §4 — WHAT ELSE `_companion_hit` MISSES

**REPORT ONLY. NOTHING WAS FIXED. No file under `scripts/` was touched for this section.**

### THE COUNT

The hero strike loop's **attacker-side multiplier block** — `scripts/battle.gd` **8613–9299**, from
the `var raw :=` that opens it to the last dealt-damage term before the taken-side block begins —
runs **84 `raw`-mutation sites**.

**`_companion_hit` reads THREE of them.**

| the three it reads | site |
|---|---|
| **Mark of the Hunt** (`hunt_mark`, via `pack_master`) | 9284 |
| **Hunter's Mark**, party-wide, through `_party_mark_mult` | 9298 |
| **Necrosis** | 8972 |

It also carries its **own** copies of the base roll and the crit — a fixed ×1.5 against the hero
loop's talent-deepened `crit_mult` — and it has no parry roll at all.

### WHY MOST OF THE 81 ARE A NON-ISSUE, WHICH IS THE HONEST HALF

**The signature is the answer: `_companion_hit(comp, victim, dmg: float, pr, pen)` takes a FLOAT,
not an `Ability`.** A companion's blow has no card behind it, so every term keyed on one cannot
apply — and a beast carries no `passive_id` (measured: `''`) and **no talent rank fields at all**
(measured: every one of thirteen sampled reads zero, because a companion is never allocated a tree).

| category | count | can a companion be given the term? |
|---|---|---|
| **read by `_companion_hit`** | **3** | — |
| its own copies (base roll, crit, parry) | 3 | — |
| **ability-keyed** (`display_name` / `dmg_type` / `special` / grade) | **26** | **no — there is no `Ability`** |
| **passive-gated** (`passive_id`, stance) | **10** | **no — a beast's `passive_id` is `""`** |
| **talent-rank / node counter on the attacker** | **20** | **no — all zero on a beast, always** |
| **attacker STATUS** | **19** | **two of them, yes — see below** |
| target/party reads (Grudge) | 1 | no — needs `grudge_ranks` |
| helper-based (`exhort_mult`, `_overburn_mult`) | 2 | no — both read hero-only state |

**A term no companion can receive is a non-issue**, which is the brief's own test. Of the 81 terms
`_companion_hit` does not read, **3 it carries its own version of**, leaving **78 genuinely absent —
and 76 of those 78 fail the brief's test by shape rather than by oversight.** Two do not.

### THE FINDING: TWO TERMS A BEAST CAN WEAR TODAY, AND BOTH PAY NOTHING

Of the 19 attacker-status terms, **seventeen cannot reach a companion** — every party-wide buff in
the block walks bare `heroes` (`empower`, `wrath`, `battle_shout`, `warcry`, `bring_it_down`,
`seeding`), two exclude companions explicitly (`zeal`, `resonant_field`), five are self-buffs on a
hero (`surge`, `wheeling_edge`, `reckless_abandon`, `blood_price`, `tempo`), `hexed` is applied only
to enemies, and two are gated `not attacker.is_hero` — which excludes a beast, since a companion is
built with `is_hero = true`.

**Two get through, and neither goes through a door anybody was watching.**

- **`cripple` — an ENEMY'S.** `_choose_enemy_action` picks its target from `_hero_side()`, which
  **holds the living beast** (measured: `_hero_side()` true, `heroes` false), and `_apply_status`
  lands the rider on whatever was struck with no companion filter. **Two enemy abilities carry it**
  — the Wolfrider's Ride-by Slash and the Grave Totem's Grasping Roots. In the hero loop Cripple is
  `raw *= 0.75`. **A Crippled beast bites at full strength.**
- **`chilled` — the HOARFROST battle modifier's.** `_stamp_modifier` is called on a summoned
  companion on purpose (AQ §4: a beast joining a fight already under a bargain), and its `hoarfrost`
  branch carries no `inherited` guard. **Measured: a beast so stamped holds 1 Chilled stack.** One
  stack does not reach the hero loop's `>= 3` threshold, but it **does** reach the Hungering Cold
  term, which is gated `atk_chill > 0`. So a beast under Hoarfrost, in a party holding that node,
  takes a malus in the hero loop and none here.

**MEASURED, NOT ARGUED — 40 seeded blows down the companion damage path, DK's method exactly:**

| status attached to a live summoned bear | holds? | damage | ratio |
|---|---|---|---|
| plain | — | 30268 | — |
| `cripple` | **yes** | 30268 | **1.0000** |
| `chilled` | **yes** | 30268 | **1.0000** |
| `hexed`, `battle_shout`, `warcry`, `reckless_abandon`, `blood_price`, `tempo` | **yes, all** | 30268 | **1.0000** |

**Every one of them attaches perfectly and moves nothing. 30268 in every arm.** That is DK's
34392-against-34392 repeating, seven more times.

### ONE MORE, AND IT IS INERT FOR A SECOND INDEPENDENT REASON

Line **9299** is the block's only ungated term and it is really two: `attacker.dmg_bonus` (the
relic global, from `hero_attack_mult`) and `attacker.type_dmg_bonus[ab.dmg_type]` (typed relic
damage).

- **`dmg_bonus` cannot reach a beast at all.** The summon copies Attack, armour, speed, stability,
  constitution, crit and `companion_power` off the hunter and **not `dmg_bonus`**; the relic hooks
  are applied at hero spawn, where no companion exists. Measured: **0.000 on the beast**.
- **`type_dmg_bonus` CAN reach a beast** — the **Tinderbox** modifier writes `+0.25` fire through
  `_stamp_modifier`, which runs on a summoned companion. Measured: `{"fire": 0.25}` on the beast.
  **But a companion's blow carries no `dmg_type`** — `_companion_hit` resolves against
  `resists["physical"]` outright — so even if the read were added, a fire bonus would find nothing
  to apply to. **It attaches and would pay nothing even if it were read**, which is a different and
  weaker case than Cripple's.

### THE RULING THIS WANTS, AND WHY IT IS NOT TAKEN HERE

**Each of the two live misses is a design question, exactly as DK's was.** A companion is an
extension of the hunter's action, and a malus that lands on it and does nothing is a promise the
chip makes that the arithmetic refuses. But **teaching `_companion_hit` to read Cripple is a
magnitude change on beast damage** — the same reason DK ruled Empower to *text* rather than
teaching the read — and DS has since given the Beastmaster an interception card and Bring It Down,
so companions carry more of the party's output than they did at DK. **That makes the stakes higher
and the decision more clearly the designer's, not less.**

**Nothing here is currently instrumented.** `check_dk` §4 re-measures `empower` and `check_dm` §2
re-measures `wrath` and `battle_shout` every battery run, so those three say when their ruling goes
stale. **`cripple` and `chilled` have no such gate**, and adding one is the natural companion to
whatever ruling is taken.

---

## §5 — DOCUMENTATION, THE BATTERY, AND THE PUSH

### THE ACCEPTANCE BATTERY — ONE RUN, AND IT CERTIFIED CLEAN

**46 suites, 23 gates, 3 harness gates, 2 scene runs. ZERO unexpected failures and ZERO throws.**

- **Every one of the 46 suites read 0 failures and 0 throws**, `test_batch_bo` at **1106** and
  `test_batch_at` at **467**, both unmoved.
- **The only red is `check_cm_live`'s 4**, which is the one that is red on purpose and is recorded
  as owed in the gate itself.
- **`check_ds` read 57 / 0 in the battery, matching its standalone run exactly.**
- **`check_da` read 37 / 0** — its baseline — confirming the §1d comment fix and no §3 exemption.
- **`check_de` read 305 / 1 on the first pass, and the one failure was predicted:**
  `every target the battery ran has a row (UNWATCHED: check_ds)`. **That is the assertion working**
  — a target that ran with no baseline row certifies nothing. The row was added and the differ
  re-run over the same log directory, which is what it is built to allow.
- **`check_de` then read 309 / 0 failures / 0 NOTICES.** 309 = 305 + 4, **exactly the
  four-assertions-per-target prediction** for one new gate. It has no row of its own, so that
  movement is reported by nothing but this line.

**`baselines.json` moved 17 lines added and 7 removed** — no churn. The `indent=1` /
`ensure_ascii=False` dump settings were verified by a round-trip diff against the untouched file
**before** writing, and came back byte-identical.

**The tree was frozen for the duration of the battery** — every code and document edit landed
before it started, and only `docs/state.md`, `docs/reports/DT.md` and `baselines.json` were written
after, none of which any suite reads.


### DOCUMENTS

- **`CLAUDE.md`** — one clause appended to the existing comments-and-absence-checks block (§1d's
  rule). **No new section**: the file is still over CW's 3% target and DG through DS have all
  declined the prune, so a rule that belongs beside an existing one goes beside it.
- **`docs/master.html`** — the stamp, `(Batch DS)` → `(Batch DT)`. **One line; nothing else moved**,
  because DT adds no card, moves no magnitude and retires nothing.
- **`docs/changelog.html`** — the DT entry.
- **`docs/design-notes.md`** — two *why* entries: the tempo-is-a-price note (§2) and the
  second-damage-path note (§4).
- **`docs/draft-audit.html`** — **the axis-coverage numbers are MARKED STALE, not refreshed.** They
  measured the draft at **142**; eight cards have been authored and one retired since, and the draft
  is **149**. Five of the twelve pool rows have moved and three of those grew. **Refreshing them
  means re-assigning an axis to each of the nine new cards, which is that audit's own judgement call
  and is authoring rather than repair** — so both tables carry a banner naming DR and DS as the
  batches that superseded them, and pointing at `test_batch_cd.PER_SPEC_DEPTH` as the one
  authoritative depth table. The banner also corrects one thing outright: **the Beastmaster's
  8-of-8 engine binding is not weakened by the row being stale — it reads 10-of-10 now.**
- **`docs/state.md`** — rewritten.
- **`baselines.json`** — re-dumped at `indent=1`.

### THE LITERAL SWEEP, BEFORE AND AFTER THE DOC EDITS

**10190 string literals of 4+ characters** were extracted from all 47 suites, all 30 gates and the
two fixtures, and counted against all eight docs before and after the edits. **Zero literals were LOST.** Ten were GAINED
(0 → n) — the dangerous class, because a gained literal can turn a red assertion green with a false
message. **All ten were checked against the suites individually and none is asserted on the document
that gained it**: four landed in `changelog.html` (`raider`, `Magic Bolt`, `Smite`, `Necrosis`) and
no suite does `changelog.contains()` on any of them; four landed in `design-notes.md`, which is only
ever asserted on for its own batch heading; and two landed in `draft-audit.html`, **which no suite
reads at all**. The one near-miss is `"125 spec"`: `test_batch_cd.gd:245` asserts it, but against
**`master.html`**, whose only change this batch is the stamp.


### THE STRAY PROCESS, WHICH IS §1's ARGUMENT MADE BY ACCIDENT

**A headless Godot running `--script ds_live.gd` was still alive 98 minutes into DT**, started
11:44 on the same day. **`ds_live.gd` is not in the repo and never was** — it is DS's throwaway
fixture, the one `docs/state.md` records as missing and the one this batch replaced. The process
was holding CPU against a script that no longer exists on disk, and it was still doing so while
`check_ds` was being measured (hence the ~25s reading).

**It was left alone rather than killed**, because it belongs to another session. It is reported
here because it is the same fact §1 exists for, arriving from the other direction: **the evidence
for the two newest specials was a file nobody could re-run and a process nobody could read.**

### THE PUSH

`git ls-remote origin main` was confirmed to match local HEAD before this batch began work
(`017dd7a`, tree clean) and again after the commit. Both readings are in the session log.
