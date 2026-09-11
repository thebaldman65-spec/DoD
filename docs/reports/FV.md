# BATCH FV — MOMENTUM'S RATE AND SANCTITY'S

**THE THIRD BATCH ON `class-merge`.** The two spine rates FU left open — and, first, the hole the brief
said to look for before setting either. **Nothing is attached to any hero**: `check_ft` §0 still asserts
the three spines are reachable by nobody and is still the section that inverts. **`docs/master.html`
is not edited and its stamp is not bumped** (FT's ruling). **The potency layer is not built and the
subject seam is not taken.**

**THE SHORT VERSION.**
1. **THE HOLE WAS REAL, SO IT IS THE BATCH.** A blocked blow, a blow an Interpose charge blocks, an
   absolute parry and a barrier that eats the whole blow each booked NOTHING toward Momentum's taken
   half. The repair is a second door that books every blow that reaches a body. **It was 61% of the
   Warden's meter.**
2. **MOMENTUM'S RATE DOES NOT MOVE, AND THE BRIEF'S PREMISE WAS THE REVERSE OF THE MEASUREMENT.** At
   FT's one step an exchange a normal fight already ends around a third of the cap; the rate is at its
   stop, and it is a named constant now.
3. **SANCTITY'S RATE GOES 6 → 16.** FT's 6 was a full meter, not a slow one. 16 centres the three
   Cleric parties on half the cap — and what the missing potency half would be worth is measured per
   spec, and it is nearly nothing for two of the three.
4. **AND IT DOES NOT COMPOUND.** Driven with the payout live against stubbed, the payout buys turns but
   not exchanges — a hastened turn closes a shorter span — so the meter moves by at most two tenths of a
   step and falls in long fights. **No lower cap is needed; the table is reported because the brief
   asked.**

---

## §0 — THE BRIEF'S PREMISES, CHECKED BEFORE ANYTHING WAS EDITED

| Premise | What the repo says |
|---|---|
| *"FU found `check_fg` held a copy of the ceiling and went red on a correct file"* | **TRUE** — FU §1b: HEAD's gate read 22 / 1 on its form arm's literal against a correct rule. |
| *"a Mage regenerates 22 Mana a turn, not 12"* | **TRUE** — FU's correction; Evocation still sets `mana_regen_bonus = 10` for the whole Mage class. |
| *"rung-1 trash runs 8.2 rounds, not 9"* | **TRUE AS FU's READING OF ONE PARTY, AND RE-READ HERE ON THAT PARTY.** FU's 8.23 was the default party; FV's Berserker arm IS that party and reads **8.47** over 1,206 trash fights (SD 2.62) — 0.24 rounds away, about 2.3 combined standard errors at FV's spread, with nothing that plays changed between the two batches. **Rounds are a property of the party**: 10.44 with the Warden in that seat, 9.11 with the Swordmaster, 7.71 with the Holy in the Devout's, 6.10 with the Occultist. |
| *"Momentum needs BOTH halves in one window: he deals damage and he takes damage"* | **TRUE** — `note_momentum_turn` (FT), and the window is the span between his turns. |
| *"A WARDEN WHO BLOCKS A HIT MAY NOT HAVE TAKEN DAMAGE AT ALL"* | **TRUE** — a Block negates the whole hit and `continue`s out of the strike loop before `take_hit` is reached. |
| *"If a blocked or parried blow does not count, the spec that stands in front builds nothing"* | **THE HOLE IS REAL; "PARRIED" IS HALF RIGHT AND "NOTHING" OVERSTATES IT.** A blocked blow books nothing. **An ORDINARY parry does book** — it lands a quarter of the blow — and only the ABSOLUTE parries (Feint, Untouchable) read zero. The Warden did not build nothing under FT's rule: **1.08 exchanges a trash fight against 2.77 once a turned blow counts — the hole was 61% of his meter, not all of it**, because not every blow is turned. |
| *"that is FT's `battle_turn` failure in a new place: ships, runs, reads zero forever, with no error"* | **TRUE BLOW BY BLOW.** Each of the four turned blows reads zero with no error. |
| *"initiative compounds where damage does not ... it feeds itself hardest late in a fight"* | **THE FIRST HALF IS TRUE AND THE SECOND IS THE REVERSE OF THE MEASUREMENT.** The payout buys a quarter of a turn to a whole turn a fight — initiative is real — but the meter moves by −0.01 to +0.12 steps in trash, and **late in a fight the share of spans booking an exchange FALLS with the payout live**: a hastened turn closes a shorter span that the enemy reaches less often. §2b. |
| *"duration is a flat benefit and does not compound"* | **TRUE, DRIVEN LIVE** — with Sanctity's payout on, the three Cleric meters move by −0.10 to +0.07 steps, and the one clear movement is DOWN. §3a. |
| *"FU ... declined to fix it with a per-spec rate, because that turns a class core into a spec engine"* | **TRUE** — FU §2d, and `CLAUDE.md`'s *A CLASS CORE IS A LEDGER*. Held here for both rates. |
| *"duration is a parameter at all 249 authoring sites, potency at 81, and 93 of 156 declared ids carry no magnitude anywhere"* | **TRUE, RE-DERIVED INDEPENDENTLY OF FT's INSTRUMENT.** 214 `_apply_status` sites and 36 direct `add_status` sites, one of them `_apply_status`'s own, are **249**; **67 + 14 = 81** pass a non-zero POWER and 25 + 1 = 26 a non-zero tick. **Counting a tick as a magnitude too, 99 of the 249 carry one** — "potency at 81" is the power figure. 156 ids declared, 65 carry a magnitude somewhere, **93 carry none**. |
| *"so a general multiplier reaches a third and reads as working"* | **TRUE** — 81 of 249 is 32.5% by site (99 is 39.8%). |
| *"Holy heals, the Devout shields, the Occultist curses"* | **TRUE AS A DESCRIPTION OF THE KITS, AND IT IS NOT WHAT REACHES THE LEDGER.** The Holy's Heal is not a status, so her own casting drives **5.5%** of her meter; the Devout's shields are statuses (4,472 barriers over his arm's trash fights) applied without a source; the Occultist's curses — Ruin, Exposed, Cripple, the Madness charms — are most of what his casting books. §3 has the census. |
| *"Sanctity counts application events from any source on anyone"* | **TRUE** — one static ledger per battle, every body, every applier. |
| *"FU's pre-pass caught two reds — one predicted, one not — and the unpredicted one was a document pin belonging to a different gate"* | **TRUE** — `check_fg` predicted, `check_ec` §2 not. |

---

## §1 — THE WARDEN HOLE, ESTABLISHED BEFORE ANY NUMBER MOVED

### 1a. EACH CASE, DRIVEN ON HEAD AND THEN ON THE REPAIR

**One enemy blow at a time, through the real `_resolve` path, from a live Orc Raider (`Slash`, 34% of
Attack) into a live Warden — and a Swordmaster for the one case only he owns.** The fixture's
deterministic board turns every random defence off; each row turns ONE on by hand, so the blow's fate
is the row's. `taken` is the health ledger FT built; `met` is the door this batch adds; *exchange* is
the engine's own answer — `note_momentum_turn()` called with a deal beside the blow.

| the blow | health lost | HEAD: taken | HEAD: exchange | FV: taken | FV: met | FV: exchange |
|---|---|---|---|---|---|---|
| lands (the control) | 20 | 20 | yes | 20 | 1 | yes |
| **BLOCKED — base Block** | 0 | **0** | **NO** | 0 | 1 | yes |
| **BLOCKED — an Interpose charge** | 0 | **0** | **NO** | 0 | 1 | yes |
| PARRIED — ordinary, −75% | 5 | 5 | yes | 5 | 1 | yes |
| **PARRIED — Feint, absolute** | 0 | **0** | **NO** | 0 | 1 | yes |
| **ABSORBED — a barrier eats the whole blow** | 0 | **0** | **NO** | 0 | 1 | yes |
| absorbed — a barrier eats part of it | 22 | 22 | yes | 22 | 1 | yes |
| MISSED — a blinded attacker | 0 | 0 | no | 0 | **0** | **no** |
| **PARRIED — Untouchable, absolute (Swordmaster)** | 0 | **0** | **NO** | 0 | 1 | yes |
| lands on the Swordmaster (the control) | 22 | 22 | yes | 22 | 1 | yes |

**THE ANSWER TO THE BRIEF'S THREE QUESTIONS:**

- **A BLOCKED HIT — NO, IN BOTH FORMS.** The Block branch negates the whole hit and `continue`s out of
  the strike loop before `take_hit` is reached, so no health leaves and the only door FT built never
  opens.
- **A PARRIED ONE — IT DEPENDS WHICH PARRY, AND THE BRIEF'S WORD COVERS TWO MECHANISMS.** An ORDINARY
  parry still lands a quarter of the blow (and a quarter of its Break), so it books — 5 of 20 here. The
  two ABSOLUTE parries, a Feint charge and Untouchable in the Defensive stance, zero the damage, the
  floor of one and the Break together, and book NOTHING. **Both absolute parries book the DEALT half
  instead** — Feint's reflect (24) and Untouchable's answer (17) are credited to him — so on HEAD they
  left exactly the lopsided span the rule refuses.
- **A FULLY MITIGATED ONE — NO.** A barrier that eats the whole blow leaves `take_hit` nothing to
  subtract, so `_report_taken` returns before it books. A barrier that eats PART of it books the rest.
- **AND A MISS, WHICH THE BRIEF DID NOT ASK ABOUT — NO, BEFORE AND AFTER, AND DELIBERATELY.** A miss
  never reached him; there is no exchange in it. §6 flags the call.

**FOUR OF THE CASES READ ZERO, SO BY THE BRIEF'S OWN RULE THIS IS THE BATCH.**

### 1b. THE REPAIR — A SECOND DOOR, ONE LINE, ABOVE THE BLOCK ROLL

**`note_blow_met()` is called at ONE line in `_resolve`'s strike loop, below both miss rolls and above
the Block roll.** The single-target miss is a branch ABOVE the loop and the per-hit miss `continue`s
just above the door, so no missed blow can reach it; a blocked blow `continue`s just BELOW it, so every
blocked blow has already booked. Every blow that reaches a body — blocked, parried, absorbed or landed —
books `momentum_met`, and `note_momentum_turn` reads the taken half as
`momentum_taken > 0 or momentum_met > 0`.

- **A SECOND FIELD, NOT A FLOOR ON THE HEALTH LEDGER, AND THIS IS THE ONE PLACE IT DIFFERS FROM
  CHANNEL'S SHAPE.** FU's floor could be one term because a free cast and a costed cast are one
  population differing in amount. A blow turned aside and a Burn tick taken are two populations; a
  count folded into `momentum_taken` would make a health figure lie to the first thing that reads its
  size. `momentum_taken` still books exactly what it booked.
- **THE HEALTH DOOR STAYS, BECAUSE IT CARRIES WHAT NO BLOW DOES.** A Burn tick, a retaliation, a share
  of an ally's wound (Unity, Steadfast, One Soul) and a self-inflicted cost all remove health without a
  blow meeting him, and all of them still book the taken half exactly as they did.
- **THE CODE THAT MOVED:** in `battle.gd`, one call (and one comment's wording at the turn loop); in
  `unit.gd`, the field, the two-door read, the three-field clear, the named rate and its ledger, and the
  door itself. **Every fight in the tree plays identically** — the door is a counter and the switch
  that would let a meter pay is still written nowhere.

### 1c. THE WARDEN'S ACTUAL BUILD RATE, ACROSS DRIVEN FIGHTS — AND THE OTHER TWO BESIDE IT

**The instrument.** A temporary, env-gated probe printed every Warrior span as it closed — dealt,
health lost, blows met, blocks, blows that landed and removed nothing, absolute parries — and each
fight's end state. **It was self-checking three ways**: every span's dealt, taken and met had to sum,
with the open span at the fight's end, to the per-hero totals the two doors booked; the exchanges it
reconstructed had to equal `momentum_exchanges`; and the meter had to equal the game's own `momentum`.
**13,714 fights across the five arms, 0 disagreements.** `battle.gd` and `unit.gd` were backed up
before the probe, and the probe was removed by restoring those copies — **md5-identical** — before the
next edit. Untalented (`DOD_SIM_ROWS=0`), rung 1, `--run 100` a spec, beside the Cryomancer, the Devout
and the Beastmaster; **payout switched off**, so a meter builds and the fight is untouched by it.

| rung-1, untalented | trash fights | rounds | his turns / trash fight | exchanges / trash fight, FT's rule | + a blow met | | elite, FT → FV | boss, FT → FV |
|---|---|---|---|---|---|---|---|---|
| Berserker | 1,206 | 8.47 | 6.74 | 1.32 | **1.84** | +40% | 1.60 → 1.98 | 2.20 → 2.75 |
| **Warden** | 1,154 | 10.44 | 10.20 | **1.08** | **2.77** | **+157%** | 1.73 → 3.01 | 1.84 → 3.56 |
| Swordmaster | 1,187 | 9.11 | 8.53 | 1.75 | **2.28** | +30% | 2.10 → 2.42 | 2.69 → 3.17 |

- **THE WARDEN'S METER UNDER FT's RULE ENDED A NORMAL FIGHT AT ONE STEP.** With a turned blow counting
  it ends near three. **16.6% of his trash spans were "he dealt, he lost no health, and a blow met him"**
  — every one an exchange FT's rule threw away.
- **AND THE LARGER CAUSE IS NOT HIS OWN BLOCK.** In those spans a blow that LANDED AND REMOVED NOTHING —
  a Devout's Divine Shield eating it whole — appears in **73.7%**, his own Block in **36.6%** (a span can
  hold both). The same shield is the whole of the Berserker's hole (7.8% of his spans) and nearly all
  the Swordmaster's (6.2%, of which 0.2% an absolute parry).
- **THE ABSOLUTE PARRY THE BRIEF NAMED BARELY OCCURS UNTALENTED**: Untouchable is a talent, which a rung-1
  arm cannot hold, and a Feint charge is a drafted card. **It is real, driven above, and asserted in the
  gate; it is simply not where the meter was being lost.**

### 1d. STATED PLAINLY, AS THE BRIEF ASKED: WHAT A HERO WHO TAKES NO DAMAGE BUILDS

- **NOTHING. A hero no blow reaches and who loses no health books no exchange, however much he
  deals.** The spine reads the exchange, not the output. It is in `CLAUDE.md`'s class-core block and
  `check_ft` §6d asserts it: 100,000 dealt, nothing met, nothing lost — no exchange.
- **AND WHAT "TAKES NO DAMAGE" NO LONGER MEANS.** A Warrior whose every blow is blocked is not taking no
  damage any more — the fight reached him, and he builds. **A miss still builds nothing.**
- **AND ONE CONSEQUENCE THE REPAIR DOES NOT TOUCH AND NOBODY HAS RULED ON: HEALTH HE TAKES FROM HIMSELF
  BOOKS THE TAKEN HALF**, because the health door books any health lost. In rung-1 trash no Warrior span
  booked an exchange on self-inflicted health alone; in elite fights **5.0–8.5%** of spans did. **Read
  that as an upper bound**: "self-inflicted" is decided by the recap's attribution frame, and a frame can
  be stale at a turn-start drain. §6 carries the question.
- **AND WHY THE EXCHANGE IS RARE, WHICH §2 DEPENDS ON.** The span closes at the top of his turn, so **the
  first span of every fight holds no action of his** (100% of fights, by construction), and **his last
  action lands in a span the fight never closes** (81–85% of fights end with damage in it). In the spans
  between, the enemy reaches him — a blow met or health lost — in only **38–47%**. A trash fight of
  seven to ten turns has perhaps three chances to book, and takes two or three.

---

## §2 — MOMENTUM'S RATE: AT ITS STOP

### 2a. THE READING — THE METER AT THE END OF A FIGHT, AT N EXCHANGES A STEP

| rung-1 trash, untalented (mean / median / at the cap) | 1 exchange a step — FT's | 2 | 3 |
|---|---|---|---|
| Berserker | **1.84 / 2 / 0.2%** | 0.68 / 1 / 0% | 0.28 / 0 / 0% |
| Warden | **2.75 / 3 / 1.7%** | 1.14 / 1 / 0% | 0.58 / 1 / 0% |
| Swordmaster | **2.27 / 2 / 0.5%** | 0.89 / 1 / 0% | 0.44 / 0 / 0% |

Elite: 1.98 / 2.99 / 2.41. Boss: 2.73 / 3.53 / 3.13. **The target: roughly a THIRD of the cap, 2.67 of
8.**

- **THE RATE STAYS ONE STEP AN EXCHANGE, AND THAT IS THE MEASUREMENT, NOT A REFUSAL.** The brief ruled a
  third and asked for the rate that lands it, on the premise that the meter would run away from it. **It
  does the reverse**: at FT's rate a normal fight ends at 1.84 / 2.75 / 2.27 — two of the three under
  the third, the three together at 2.29 — and the cap is reached in under 2% of any kind of fight. **An
  exchange books at most once a turn**, so there is no faster rate in this shape, and two exchanges a
  step would put every spec near one step. **The constant is named now (`MOMENTUM_EXCHANGES_PER_STEP`
  = 1) with its exchange ledger (`momentum_exchanges`)**, so a later ruling is one line.
- **STATED PLAINLY: THE THREE DO NOT LAND TOGETHER, AND THE SPREAD IS STRUCTURAL.** The Warden's party
  fights longest (10.44 rounds; he takes 10.2 turns a trash fight to the Berserker's 6.7) and he is
  reached in the most spans; the Berserker's party kills fastest and he deals in fewer spans than the
  Swordmaster. **A per-spec rate would close it and would make a class core a spec engine** — FU's rule,
  held — so it is reported and not closed.
- **IF THE METER IS EVER WANTED FASTER, THE LEVER IS WHAT COUNTS AS AN EXCHANGE, NOT THE RATE** — and
  that is a ruling on the rule. `CLAUDE.md` says so.

### 2b. THE COMPOUNDING — PAYOUT LIVE AGAINST PAYOUT STUBBED, AND IT BARELY FEEDS ITSELF

**The pair the brief asked for.** The same probe on the shipped rate, with `momentum_active` switched
on for the Warrior by the probe — and only there; the switch left with it — 100 runs a spec: **8,026
live fights against phase 1's 8,066 stubbed ones**, every one passing the same three self-checks. The
stubbed arm IS phase 1's: with the switch off neither rate constant can touch a fight, and phase 1 ran
the same Momentum code. The meter read here is the game's own `momentum` at the fight's end.

| rung-1, untalented | his turns a fight, stubbed → live | METER at the end, stubbed → live | difference (± one standard error) |
|---|---|---|---|
| Berserker, trash | 6.74 → 6.99 (+0.24 ±0.10) | 1.84 → 1.91 | **+0.07 ±0.05** |
| Warden, trash | 10.20 → 11.19 (+0.99 ±0.19) | 2.76 → 2.88 | **+0.12 ±0.06** |
| Swordmaster, trash | 8.53 → 9.12 (+0.60 ±0.13) | 2.27 → 2.26 | **−0.01 ±0.07** |
| Berserker / Warden / Swordmaster, elite | +0.20 / +0.71 / +0.46 turns | 1.98 → 2.00 / 2.99 → 3.20 / 2.41 → 2.56 | +0.02 ±0.06 / **+0.21 ±0.07** / +0.15 ±0.08 |
| Berserker / Warden / Swordmaster, boss | +0.19 / +0.73 / +0.97 turns | 2.73 → 2.45 / 3.53 → 3.22 / 3.13 → 2.99 | **−0.28 ±0.12** / **−0.31 ±0.13** / −0.13 ±0.15 |

- **THE PAYOUT BUYS TURNS AND NOT EXCHANGES.** It hands the Warrior a quarter of a turn to a whole turn
  more a fight — the initiative is real — and the end-of-fight meter moves by **+0.07, +0.12 and −0.01
  steps** in trash, no spec past two standard errors. The one clear rise is the Warden's elite, +0.21
  at three; **in boss fights the meter FALLS**, by 0.28 and 0.31 for the Berserker and the Warden.
- **WHY: A HASTENED TURN CLOSES A SHORTER SPAN.** An exchange is booked per span, and a span is the
  stretch of timeline between his turns; haste shortens it, so fewer enemy actions land inside each
  one. More spans, each less likely to hold both halves, and the product barely moves. **It shows
  exactly where the brief expected the opposite**: the share of LATE spans — the second half of each
  fight, where the meter and its haste are highest — that booked an exchange FELL with the payout live,
  **0.250 → 0.236 (Berserker), 0.243 → 0.218 (Warden), 0.198 → 0.155 (Swordmaster)** in trash, and
  further in boss fights. **The meter does not feed itself hardest late in a fight; late in a fight it
  starves itself hardest.**
- **SO IT DOES NOT COMPOUND HARD, AND A LOWER CAP IS NOT THE BRAKE IT NEEDS TODAY.** §2c is reported
  because the brief asked; nothing in the live pair argues for it.
- **ONE READING THAT LOOKS LIKE A LONGER FIGHT AND IS NOT.** "Rounds" is hero turns over party size, so
  the Warrior's extra turns raise it by about a quarter of themselves (Warden +0.32, Swordmaster +0.26):
  the instrument counting the turns the payout bought, not the fight lasting longer.
- **AND WHAT WOULD MAKE IT COMPOUND.** The thinning is a property of what counts as an exchange. A later
  ruling that makes one easier to book — §2a's lever — weakens the brake, so **the live pair is owed
  again by that batch**, and `CLAUDE.md` says so.

### 2c. WHAT A LOWER CAP WOULD LOOK LIKE

**A cap only clips the top of the distribution, so it can be read straight off the same exchanges**: the
meter at one step an exchange under a cap of C is `min(exchanges, C)`, and the payout AT the cap is
C × 4% off the delay.

| rung-1 trash, mean steps (fights at the cap) | cap 8 — FT's (−32%) | cap 6 (−24%) | cap 5 (−20%) | cap 4 (−16%) | cap 3 (−12%) |
|---|---|---|---|---|---|
| Berserker | 1.84 (0.2%) | 1.84 (0.3%) | 1.83 (2.3%) | 1.81 (9.0%) | 1.72 (27.0%) |
| Warden | 2.75 (1.7%) | 2.72 (3.7%) | 2.68 (10.6%) | 2.57 (26.0%) | 2.31 (53.0%) |
| Swordmaster | 2.27 (0.5%) | 2.26 (3.5%) | 2.22 (9.6%) | 2.12 (21.1%) | 1.91 (39.9%) |

| boss, mean steps (fights at the cap) | cap 8 | cap 6 | cap 5 | cap 4 | cap 3 |
|---|---|---|---|---|---|
| Berserker | 2.73 (1.0%) | 2.70 (3.4%) | 2.67 (9.9%) | 2.57 (29.6%) | 2.28 (54.4%) |
| Warden | 3.53 (1.7%) | 3.48 (9.2%) | 3.39 (23.5%) | 3.15 (46.3%) | 2.69 (76.5%) |
| Swordmaster | 3.13 (1.7%) | 3.06 (9.4%) | 2.96 (20.6%) | 2.76 (38.0%) | 2.38 (61.3%) |

- **DOWN TO 6 A CAP CHANGES ALMOST NOTHING IN A NORMAL FIGHT** — a trash fight's mean meter moves by at
  most 0.03 steps — **and what it removes is the payout AT the top**, from −32% to −24%. It bites the
  long fights: a boss's share at the cap goes from under 2% to about one in ten.
- **AT 4 IT STARTS TO SHAPE THE NORMAL FIGHT** — a quarter of the Warden's trash fights sit at it — and
  at 3 the meter is a switch more than a ramp for him.
- **THE MOST EXCHANGES ANY WARRIOR BOOKED IN ONE FIGHT WAS 15** (the Warden, trash and boss alike), so the
  present cap of 8 is reachable, just rare.
- **AND NONE IS NEEDED TODAY.** §2b measures the payout feeding the meter by at most two tenths of a
  step, and starving it late in long fights. A cap is the honest brake on a self-feeding meter; this
  one is not feeding itself.

---

## §3 — SANCTITY: THE RATE, ON THE HALF THAT EXISTS

### 3a. THE RATE IS 16 EVENTS A STEP — THE MEASUREMENT

**The same probe, the same fights.** Sanctity's ledger is one static count per battle fed by every body
and every applier, so the meter a Cleric holds is the battle's. The three Cleric arms are the default
party with its Cleric swapped — **the Devout (the default party itself), the Holy and the Occultist** —
each beside the Berserker, the Cryomancer and the Beastmaster; switch off. **Every fight's probed
events were required to equal the ledger it ended on.**

| rung-1, untalented | trash fights | rounds | events / trash fight (median) | elite | boss |
|---|---|---|---|---|---|
| Devout party | 1,206 | 8.47 | **56.60 (55)** | 50.22 | 65.74 |
| Holy party | 1,141 | 7.71 | **40.42 (39)** | 34.46 | 45.22 |
| Occultist party | 878 | 6.10 | **44.02 (42)** | 38.76 | 48.17 |

**The target: roughly HALF the cap by the end of a normal fight — 2.5 of 5 steps.**

| events a step | trash, mean steps (Devout / Holy / Occultist) | across the three | medians | trash fights at the cap |
|---|---|---|---|---|
| 6 — FT's placeholder | 4.97 / 4.66 / 4.80 | 4.81 | 5 / 5 / 5 | **97 / 78 / 84%** |
| 15 | 3.24 / 2.24 / 2.44 | 2.64 | 3 / 2 / 2 | 15.8 / 2.1 / 3.6% |
| **16 — SHIPPED** | **3.03 / 2.06 / 2.28** | **2.46** | **3 / 2 / 2** | **10.4 / 1.2 / 2.2%** |
| 17 | 2.82 / 1.92 / 2.12 | 2.29 | 3 / 2 / 2 | 7.0 / 0.7 / 1.1% |

- **WHY 16:** it is the rate that centres the three means on the target — 2.46 across the specs, against
  2.64 at 15 and 2.29 at 17. **Half of five is not a whole step**, so no rate can put a median ON the
  target; at 16 the medians straddle it.
- **FT's 6 WAS NOT A SLOW RATE, IT WAS A FULL METER.** Every Cleric party reached the cap in 78–97% of
  trash fights. That is FT's *"very wide door"*, measured.
- **STATED PLAINLY: THE THREE DO NOT LAND TOGETHER, AND THE SPREAD IS THE PARTY's, NOT THE CLERIC'S.**
  The Devout's party generates 40% more events a fight than the Holy's, and the Devout's own casting is
  only 30% of that traffic. **A per-spec rate would make a class core a spec engine**, so it is reported
  and not closed.
- **AND THE WARRIOR IN THE PARTY MOVES IT TOO**: the same Devout beside the Warden reads 70.25 events a
  trash fight and beside the Swordmaster 58.49, because the fight is longer. The meter reads the fight
  it is in.
- **AND THE PREMISE THAT DURATION DOES NOT COMPOUND HOLDS — DRIVEN LIVE.** With `sanctity_active` on
  the Cleric (in the probe only; 7,378 live fights), the trash meter reads **Devout 3.03 → 2.93 (−0.10
  ±0.04), Holy 2.06 → 2.08 (+0.02 ±0.04), Occultist 2.29 → 2.35 (+0.07 ±0.04)** — across the three,
  2.46 before and after. **The one clear movement is DOWN, and it is the Devout's**: a longer status
  lands again less often, so lengthening his applications thins the very traffic his meter counts, by
  about two events a fight. Where duration moves its own meter at all, it damps it.

### 3b. WHAT THE TRAFFIC IS

| trash, share of events | landing | removal | purge | on a hero | on a companion | on an enemy | inside the Cleric's own cast | another hero's | an enemy's | no frame |
|---|---|---|---|---|---|---|---|---|---|---|
| Devout party | 89.6% | 10.4% | 0.0% | 67.2% | 6.4% | 26.5% | **30.0%** | 42.2% | 13.1% | 14.7% |
| Holy party | 86.2% | 13.8% | 0.1% | 50.9% | 9.8% | 39.4% | **5.5%** | 61.2% | 13.1% | 20.2% |
| Occultist party | 87.6% | 12.4% | 0.0% | 36.3% | 7.8% | 55.9% | **22.2%** | 44.3% | 15.1% | 18.4% |

**The "frame" is `_resolve`'s attribution frame at the moment the event booked** — the unit whose cast
was resolving — so a turn-start application can carry a stale one; read the column as the share the
Cleric's own casting drives, not as exact authorship. **The Holy drives one event in twenty of her own
meter.**

### 3c. WHAT EACH HALF OF THE PAYOUT CAN REACH — AND WHAT THE MISSING POTENCY HALF WOULD BE WORTH

**Both halves are keyed on the APPLIER**: the duration half reads `src.sanctity_active` at
`_apply_status`, and a potency half built at the same funnel could read nothing else. So the question is
not "what statuses exist" but **what this Cleric applies through `_apply_status` with himself as
`src`**. Counted per trash fight on the same fights:

| trash, per fight | through `_apply_status` WITH him as `src` | a positive duration (the duration half reaches) | carrying a power or tick (a potency half would reach) | through it with NO `src` | direct `add_status` |
|---|---|---|---|---|---|
| **Devout** | **10.29** — Consecrated Ground, all of it | **100%** | **0%** | **7.65** — his Divine Shield barrier (4,472 of them), Zeal, Unity, Bulwark, the Vow | 1.27 — Faith |
| **Holy** | **1.30** — Renewal, Vespers | **100%** | **100%** | 0.59 — Intercession, Consecration, Divine Presence, Exhortation, Alms | 0.16 |
| **Occultist** | **19.60** — Ruin (12,302), Exposed, Cripple, the three Madness charms, Renewal | **25.3%** | **1.5%** | 0.28 | 0.46 |

**SO THE MISSING HALF IS WORTH A DIFFERENT THING TO EACH OF THE THREE, AND TWO OF THE THREE ANSWERS ARE
"ALMOST NOTHING" FOR REASONS NO MULTIPLIER FIXES:**

- **THE HOLY: EVERYTHING HER PAYOUT REACHES CARRIES A MAGNITUDE** — Renewal's heal and Vespers' absorb
  — so a potency half would add a second kind of value to every one of her reachable applications.
  **But there are 1.3 of them a fight**: her Heal is not a status, and her other statuses pass no source.
- **THE DEVOUT: ZERO.** Every application his payout reaches is Consecrated Ground, which carries no
  magnitude; **the one that does — the Divine Shield's barrier, whose power IS the absorb — is applied
  without a `src`, so neither half reaches it at all.** The potency half is worth nothing to him until
  that call site learns its source.
- **THE OCCULTIST: ABOUT 1.5%.** His engine is Ruin, and Ruin is BATTLE-LONG — `turns` −1, a permanence
  flag the duration half deliberately never touches — and its bite lives in the handler's stack count,
  not in a power at the funnel. **Three quarters of what he applies is already out of the duration
  half's reach, and 98.5% is out of a potency half's.**
- **AND THE RE-READING THIS OWES.** 16 was set so a meter of two or three steps buys two or three turns
  on the applications the duration half reaches. **The day the potency half lands, a step buys more on
  every application that carries a magnitude** — for the Holy, all of hers — and the rate will be set
  against half a spine. **It is owed a re-reading, not trust, that day**, and `CLAUDE.md` binds the batch
  that builds potency to re-measure it in the same batch.

### 3d. FT's TWO CONSTRAINTS STILL HOLD — DRIVEN ON A REAL COMPANION, AND COUNTED IN LIVE TRAFFIC

- **A STATUS THE BEAST WEARS IS NOT DOUBLE-COUNTED — AND IT IS DRIVEN NOW, WHERE FT ARGUED IT BY
  CONSTRUCTION.** `check_ft` §6f summons a real Ursus and applies one status to it: ONE event. The same
  status on its Beastmaster is a second body and a second event; re-applying it to the beast is a
  refresh and books nothing. **Read 1, 2 and 2 on all three readings of the new gate.**
- **A STATUS APPLIED AND IMMEDIATELY REMOVED DOES NOT FARM THE METER — ON THE BEAST TOO.** Eight
  apply-and-remove cycles on the companion in one turn book ONE event, beside FT's §3c arm on a hero,
  which still reads one.
- **AND IN LIVE TRAFFIC THE DEDUPE IS NEARLY IDLE.** Across all five arms and all three fight kinds it
  refused **0.08–0.24 calls a fight**. Nothing in the shipped game churns a status on a body inside a
  turn; the rule guards against a card that does not exist yet, which is what it was built as.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **Nothing is attached to any hero.** `check_ft` §0 still holds and is still the section that inverts —
  the probe's live switch lived only in the probe and left with it.
- **The potency layer is not built.** §3c measures what it would be worth; it is its own batch.
- **No spec dissolved, no pool merged, no engine became a rune, no talent node moved.**
- **`docs/master.html` is not edited and its stamp is not bumped**, per FT's ruling.
- **The subject seam is not taken.** `CLAUDE.md` reads **302,395 B = 295.31 KiB** against 340 KiB —
  **+3,835 B this batch, 45,765 B = 44.69 KiB of headroom**, about ten batches at FF's mean.
- **Momentum's cap is not changed**, and neither is the step's haste; both stay flagged.
- **The Devout's barrier still passes no source.** It is the one call site that decides what potency is
  worth to him, and changing it would reach the live duration payout's population too — a batch of its
  own, owed only when potency is.

---

## §5 — VERIFICATION

**THE FLOOR.** It parses — **`Parse Error` and `SCRIPT ERROR` grepped from every log, never a tally and
never the exit code** — and it runs. **Zero across all 107 pre-pass logs**, `check_parse` 181 / 0, and
zero in every probe arm, drive and smoke this batch ran. **The code change is proved by a
comment-stripped diff against HEAD, because a comment insert has eaten a live line in this project
before**: `unit.gd` moves −3 / +11 code lines — the named rate, the exchange ledger, the met field,
Sanctity's 6 → 16, the two-door read, the met clear, the rate-gated step and `note_blow_met` itself —
and `battle.gd` moves +1, the door call. **Every other line either file gained is a comment.**

### 5a. THE PRE-PASS — EVERY UNMODIFIED GATE AGAINST THE NEW TREE, BEFORE ANY GATE WAS EDITED

**The prediction, written to the scratchpad before the launch, as the brief and FA §1b require.** The
tree held the engine (the met door, the two-door read, the named rate and its ledger, Sanctity's rate)
and every document edit; every gate, suite, `baselines.json` and `pin-manifest.json` was HEAD's, and the
probe was out, restored byte-exactly.

| target | predicted | why |
|---|---|---|
| targets / throws / timeouts / incomplete | 107 / 0 / 0 / 0 | no target added or removed |
| `Parse Error` + `SCRIPT ERROR` over every log | 0 | the drive and both smokes read 0 |
| `check_cm_live` | 13 / 4, FAIL lines word for word FU's | the sanctioned red |
| `check_ft` (HEAD's gate, new code) | **112 / 0** | the rate is 1, so §2a's `momentum == 1` and §2c's still hold; §3g reads `SANCTITY_PER_STEP` by name; §2g still counts 3 reads; §0b finds no switch write |
| `check_ed` | 18 / 0 | the engine edit loses 0 of 17,987 needles over its 104 readers |
| `check_ec` | 23 / 0 | the document sweeps lose 0 needles, and no negative pin's needle was gained |
| `check_fg` | 22 / 0 | `CLAUDE.md` stays far under 340 KiB |
| `check_es` | 57 / 0 | the `state.md` rewrite keeps the core-kit census phrases it reads |
| `check_de` | 445 / 0 / 0 | no count moves anywhere |
| everything else | on its row | nothing else reads the edited lines |

**THE RISK NAMED AND NOT RULED OUT:** a census gate that walks `BattleUnit`'s declarations or
`unit.gd`'s functions and that a new field or a new function joins by existing — the shape of FU's
unpredicted red, which belonged to a gate nobody would have named.

**THE PRE-PASS READ EXACTLY THE PREDICTION, AND THAT IS THE READING WORTH RECORDING AFTER FU's.**

| | predicted | read |
|---|---|---|
| targets / throws / timeouts / incomplete | 107 / 0 / 0 / 0 | **107 / 0 / 0 / 0** — one `.ran` sequence, 107 unique |
| `Parse Error` + `SCRIPT ERROR`, grepped from every log | 0 | **0** |
| `check_cm_live` | 13 / 4 | **13 / 4** — the four FAIL lines word for word the recorded four: the bar appeared on the enemy's attack, its top line names the incoming blow, the brace near x0.85, its Break half near x0.75 |
| `check_ft` (HEAD's gate, new code) | 112 / 0 | **112 / 0** — §1e x1.1799, §2h x0.6800, §3i 214 of 214, §5h 227 corpus cards: FU's own readings |
| `check_ed` / `check_ec` / `check_fg` / `check_es` | 18 / 23 / 22 / 57 | **18 / 23 / 22 / 57**, all green; `CLAUDE.md` 302,395 B = 295.31 KiB |
| the gates that read gate source (`check_da` / `check_dw` / `check_ea` / `check_ek` / `check_ff`) and `check_parse` | on their rows | **43 / 35 / 86 / 45 / 55 and 181**, all green |
| `check_de` | 445 / 0 / 0 | **445 / 0 / 0** — no count moved anywhere |
| run harness | 22 / 166 / 8 | **22 / 166 / 8** |
| the freeze | zero differ | **403 files md5-stamped with absolute paths before and after, the designer's four saves included — zero differ** |

**No red I did not predict.** The risk named in advance — a census gate that walks `BattleUnit`'s
declarations and that a new field joins by existing — did not materialise, and the manifest dry run
had already said so: regenerated against the pre-pass tree, it reproduced the tracked file byte for
byte, 1,446 pins, nothing added, removed or moved.

### 5b. THE NEW GATE, READ BEFORE ANYTHING ELSE MOVED — AND ITS OWN FIRST DEFECT

**The first three readings of the new `check_ft` were 140 / 1, identically — and the red was the gate,
not the engine.** Every driven §6 arm passed; §6c's *"and nowhere else under `scripts/`"* counted the
text `note_blow_met()`, and the door's own `func note_blow_met()` declaration in `unit.gd` carries it.
**A declaration is not a call site** — the same shape as a comment naming a banned string, one step
along. The arm now counts lines that carry the call and do not declare a function. **Repaired, it reads
140 / 0 on three readings identical in every line but Godot's exit bookkeeping** — and the repair is
two-armed the way `docs/instrument-rules.md` asks: the first-draft arm red on the correct tree, the
repaired arm green on it, and control C10 below proving the repaired arm still bites.

### 5c. THE PIN MANIFEST AND THE BASELINE ROW, BOTH MOVED FOR ONE REASON

- **`pin-manifest.json`: 1,446 → 1,452 pins, 0 removed, 0 residency changes.** Every regeneration was
  run into the scratchpad first — the repo's own generator, its one write redirected — and diffed before
  anything was blessed. **The six new pins are §6c's own reads into `battle.gd`**: `note_blow_met()`
  (twice, by the count and by the position), `strike_target.float_text("MISS"` (twice, by the position
  and the uniqueness count), `var block_source` and `continue`. **It was blessed twice** — at 1,451 with
  the first draft's `_stat("attack_miss")` read, and at 1,452 once C2 retired that read — **and the
  second time the expected change (that one pin out, the per-hit miss's line in, nothing else) was
  asserted by script BEFORE the write.** Nothing else moved, which the pre-pass tree had already shown
  from the other side: the engine and document edits alone regenerate the tracked manifest byte for byte.
- **`baselines.json`: `check_ft` 112 → 140, and only that row.** Written off three identical standalone
  readings of the repaired gate, BEFORE the acceptance battery, by a script that refuses to write unless
  the untouched file round-trips byte for byte in its own form and then proves every other row and key
  unchanged. **§2a–§2c were re-pointed one assertion for one**, so the whole +28 is §6.

### 5d. EVERY GATE THAT READS THE MANIFEST OR ANOTHER GATE'S SOURCE, AGAINST THE NEW GATE, BEFORE THE CONTROLS

**FU's reconnaissance red came from exactly this population, chosen too narrowly — so all of them,
with the new `check_ft` and the regenerated manifest in the tree:** `check_ed` 18 / 0, `check_ec` 23 / 0,
`check_da` 43 / 0, `check_dw` 35 / 0, `check_ea` 86 / 0, `check_ek` 45 / 0, `check_ff` 55 / 0,
`check_parse` 181 / 0, `check_fg` 22 / 0 — every one on its row, 0 errors, and
`build_pin_manifest.py --check` current at 1,451. **`check_da` stays 43** because §6 walks no pool;
**`check_ek` stays 45** because §6 names none of the fifteen tag-surface words, which was pre-screened
statically before the gate was installed; **`check_parse` stays 181** because no file was added.

### 5e. THE NEGATIVE CONTROLS — AND THE ONE THAT FOUND A SECOND DEFECT IN THE GATE

**Ten controls, each an exact-once injection into the real tree with its prediction written into the
runner before it ran, the gate run standalone the way the battery runs it, the file restored from a
scratchpad copy and its md5 required to match the pre-control stamp.** The tree was compared to the
backups after every set: the engine files byte-identical to the shipped copies, the gate to the
installed one.

| control | injected into | predicted | read |
|---|---|---|---|
| **C1** — the door removed (`pass` where the call stood) | `battle.gd` | every §6b met arm, §6c's count and both position arms | **140 / 11 — exactly those, on both armings**: eight §6b arms reading *met 0* (the landed blow still books its 23 lost, so FT's health door is untouched), *called at exactly 1 site in battle.gd (found 0)*, and both position arms — the repaired below-the-miss arm reds here because there is no door to be below anything |
| **C2** — the door MOVED above the per-hit miss | `battle.gd` | first arming: §6c's below-the-miss arm alone; re-armed on the repaired arm: both position arms | **first arming 140 / 1 — the WRONG arm** (the distance arm; the below-the-miss arm stayed green — see below). **Re-armed: 140 / 2 — both**, *831 characters before the Block roll* and *...and below the per-hit miss* |
| **C3** — FT's rule back: the step reads health lost only | `unit.gd` | §6b's five turned-blow exchange arms and nothing else | **140 / 5 — exactly those**: blocked, Interpose, Feint, the whole-blow barrier, Untouchable, each reading *met 1, exchange false* |
| **C4** — the met door writes the HEALTH ledger | `unit.gd` | landed, parried and the five turned-blow arms | **140 / 7 — exactly those**: a turned blow reads *taken 1, met 0*; the landed blow *taken 24* against 23 lost |
| **C5** — the step on every SECOND exchange, whatever the rate says | `unit.gd` | §2a, §6a's first-step arm, §6a's cap arm | **140 / 3 — exactly those**: *the first step lands on exchange 2, want 1*; *past the cap the meter reads 5, want 8* |
| **C6** — a MISS books a blow met (a call added to the single-target miss branch) | `battle.gd` | first arming: the miss arm and §6c's count; re-armed: those and both position arms | **140 / 4 on both armings**: *a MISS reads met 1, taken 0, exchange true*, *found 2*, and both position arms — they read the FIRST call, which is the injected one, 6,106 characters above the Block roll |
| **C7** — a status on a companion booked twice | `unit.gd` | §6f's beast, hunter, refresh and farming arms | **140 / 4 — exactly those**: *one status on the BEAST books 2 event, want 1* |
| **C8** — the (turn, body, status) dedupe removed | `unit.gd` | FT's §3a and §3c ×3, and §6f's beast farming arm | **140 / 5 — exactly those**: FT's churn loop reads 16 again, and so does the beast's |
| **C9** — POSITIVE: the rate constant set to 2 | `unit.gd` | **GREEN**, same count | **140 / 0** — the gate reads the constant and holds no copy of it |
| **C10** — a second CALL of the door, in a function nothing runs | `unit.gd` | §6c's nowhere-else arm alone | **140 / 1 — exactly that, on the repaired arm**: *called nowhere else under scripts/ (found 1 call sites)*; every driven arm green, because nothing executes the new function |

- **C9 IS THE ARM A RATE OF ONE MADE NECESSARY.** At one exchange a step, a control that simply ignored
  the rate would read green — the arithmetic cannot tell the two apart. So the rate is proved two ways:
  C5 breaks the step in a way a rate of one CAN see, and C9 moves the constant and requires the gate to
  follow it, which is the property that makes a later ruling a one-line change.
- **THE FIRST ARMING OF C2 FOUND A SECOND DEFECT IN THE GATE — AND IT WAS NOT THE ARM THAT RED.** C2
  moves the door ABOVE the per-hit miss. Predicted: §6c's *below the per-hit miss* arm, alone. Read
  **140 / 1 — but on the DISTANCE arm** (*831 characters before the Block roll*), while the below-the-miss
  arm stayed green. **The arm searched back for the nearest `_stat("attack_miss")`, found the
  SINGLE-TARGET miss above the loop, and a `continue` sat between** — so it would have passed on a door
  above the per-hit miss that happened to stay near the Block roll. **The count of that run was right
  and the FAIL text was not the one predicted, which is the whole reason the text is read.** The arm
  now anchors on the per-hit miss's own line, `strike_target.float_text("MISS"`, asserted to occur once.
  **Re-armed on the repaired arm, C2 reads 140 / 2 — the distance arm and the below-the-miss arm both —
  and that is the repair's two-armed proof**: the first draft's arm green on this injection, the
  repaired arm red on it and green on the correct tree across three readings.
- **C6 READ MORE THAN PREDICTED, FOR A REASON THAT IS NOT A DEFECT.** Predicted: the miss arm and the
  count. Read **140 / 4** — the two position arms too, because they measure the FIRST call and the
  injected one sits above the loop. With one call site that is exactly the behaviour wanted, and the
  prediction was re-written before the re-run.

### 5f. THE ACCEPTANCE RUN OVER THE SHIPPED TREE

**The prediction was written to the scratchpad before the launch, in the same shell command, so the
order is not a matter of memory.** The tree: the engine as shipped, the repaired `check_ft` (140), its
row at 140, the manifest at 1,452, every document final, and the stray `.orig` gone.

| | predicted | read |
|---|---|---|
| targets / throws / timeouts / incomplete | 107 / 0 / 0 / 0 | **107 / 0 / 0 / 0** — one `.ran` sequence, 107 unique, 107 logs |
| `Parse Error` + `SCRIPT ERROR`, grepped from every log | 0 | **0**, over all 107 logs |
| `check_cm_live` (deliberate) | 13 / 4, the four FAIL lines word for word | **13 / 4** — the same four FAIL lines as the pre-pass, word for word |
| `check_ft` | 140 / 0, on its new row | **140 / 0** |
| `check_ed` / `check_ec` / `check_da` / `check_fg` / `check_es` | 18 / 23 / 43 / 22 / 57 | **18 / 23 / 43 / 22 / 57**, all 0 failures |
| `check_de` (checks / failures / notices) | 445 / 0 / 0 | **445 / 0 / 0** |
| run harness (gates 1 / 2 / 3) | 22 / 166 / 8 | **22 / 166 / 8**, 0 throws |
| the freeze | 402 files — the pre-pass's 403 less the removed `.orig` — zero differ, the four saves identical | **402 files md5-stamped with absolute paths before and after, zero differ** — the four saves among them, byte-identical to the backup |

**Every target row read what the pre-pass read except three, and one of the three was predicted.**
`check_ft` 112 → 140 is the new gate on its new row. **`test_batch_an` 6055 → 6054 and `test_batch_bk`
129 → 130 were not named in advance, and both are drift the baselines already carry**: `test_batch_an`
is the row `baselines.json` calls the known drifter, and 6054 is inside its [6046, 6063];
`test_batch_bk` walks zone maps rolled by `_generate_map()`, which nothing in the tree seeds, so its
count is the topology it drew, and 130 is inside its [128, 130]. Both read 0 failures. **And neither
moved because the tree did**: between the pre-pass's opening freeze stamp and this run's, the whole
tree differs in exactly the five files moved on purpose after the pre-pass — `check_ft.gd`,
`baselines.json`, `pin-manifest.json`, this report and `docs/state.md` — and the removed `.orig`, and
neither suite names any of them, so both rolled again on byte-identical inputs. `check_de` reads both
rows in band, which is why it prints no notice. `build_pin_manifest.py --check`, run after the battery,
reads the manifest current at 1,452 pins.

**AFTER THE RUN, AND SAID SO: TWO FILES WERE WRITTEN BEHIND THE CERTIFYING BATTERY** — this section, and
`docs/state.md`'s acceptance cells. This report is read by no gate. **`docs/state.md` is read by one**,
`check_es`, and it was treated that way: the post-run edit was swept against the copy the battery READ
(snapshotted during the run and md5-matched to the freeze stamp), and `check_es` was re-run against the
shipped copy with the battery's own command. **The proof, in order.** The edit to `docs/state.md` is the Last-measurements table's acceptance
column, one new harness row carrying the pre-pass's own 22 / 166 / 8, and one sentence closing the
WHERE block's verification bullet. **Swept against the copy the battery read**, over every `.gd` that
names the file (11 readers, 2,694 needles of four characters or more, raw, lowered and
whitespace-flattened), it **lost 0** and gained 0. **The sweep's control arm ran on the same pair and
bit**: `exsanguination`, which `check_es` and `test_batch_aj` both read, deleted in memory from the
edited copy, reads **LOST 2**. **Only `check_es` opens the file** — nine of the other ten name it only
in comments, and the tenth, `check_fr`, checks that the name appears in `ways-of-working.md` — and its
§4 extraction finds the same two `2+ threshold` windows with the same figures in both copies.
**Re-run standalone with the battery's own command, it reads 57 / 0**, with `Parse Error` and
`SCRIPT ERROR` at 0, **and its log is byte for byte the one the battery wrote.** **And the freeze,
re-stamped after both edits, differs from the acceptance run's closing stamp in exactly two files:
`docs/state.md` and this report.**

**THE SAVE BACKUP:** the designer's four files were copied to `save-backups/FV-20260910-133633` and
md5-verified against the originals and against FU's backup **before anything else happened**. All four
match FU's exactly, and all four were still byte-identical at every freeze stamp this batch took.

---

## §6 — WHAT NEEDS A RULING

1. **SELF-INFLICTED HEALTH BOOKS MOMENTUM'S TAKEN HALF.** The health door books any health lost, so a
   Warrior paying his own health is "taking damage". Rare in trash, 5–9% of elite spans at most. Whether
   paying your own health is half of an exchange is the designer's; nothing was changed.
2. **A MISS DOES NOT BOOK THE TAKEN HALF — THE BATCH'S CALL, FLAGGED.** The brief's three cases are all a
   defence the Warrior or his party performs; a miss is the attacker's failure and never reached him. If
   a swing that missed him should count, it is one line — the door moves above the per-hit miss — and
   the base miss chance is 5%, so it would move the meter little.
3. **NO CAP RULING IS OWED.** The brief made a lower cap conditional on hard compounding, and there is
   none; §2c shows what 6, 5, 4 and 3 would do. **Owed later, and written into `CLAUDE.md`: the batch
   that changes what counts as an exchange re-runs the live pair**, because the thinning of the span is
   what holds this meter still.
4. **STILL OPEN FROM FT:** Channel's partition, and how a second meter displays.
