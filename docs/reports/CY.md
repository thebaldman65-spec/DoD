# BATCH CY — A BUFF COSTS HALF A SWING

*2026-08-21. One systematic rule, applied to 52 abilities. No save version moves (still v10).
Nothing else about any of those abilities changed — no cost, no cooldown, no duration, no
magnitude.*

---

## THE HEADLINE

| | |
|---|---|
| **A fight is 3.0 – 5.5 turns per hero.** Trash 3.5 / 3.8 / 4.1 rounds at the three difficulty rungs. | **Elite fights are the SHORTEST of the three kinds**, at every rung. |
| Blood Frenzy reaches **31%** of its band in an average fight (rung 2). | Faith reaches **1.6 of the 5** a release needs — **32%**. |
| Loyalty reaches **400%** of its reference point. | Focus reaches **131%** of its conversion point. |
| **52 pure buffs found**, of 216 abilities. | **51 came down to 1.0; one was already there.** |
| **28 of the 52 are also on CR's duration list.** | **None of them changed.** |

**The brief's hypothesis is confirmed, and the measurement adds something it did not ask for: two
of the four ramps arrive and two do not.** Loyalty and Focus both over-shoot the number their spec
is built around — they tick automatically, every turn, and are uncapped. Blood Frenzy and Faith
both under-shoot by roughly two thirds, and they are the two that have to be *earned* out of what
the fight does to you. **The cap is aimed at all four and only two of them needed it.**

---

## §0 — MEASURE FIRST, AND REPORT IT

**Both measurements were taken before a line of §1 was written**, on unmodified HEAD plus the
instrument itself. Four `--run 25` sims — a run is the only instrument that meets trash, elite and
boss.

### How long is a fight?

Rounds are counted as **turns per living party member**, not as the standing report's
`hero_actions / 3`: that line divides by three and the party has been **four** since the class
draft, so it has been reading a third high for a long time. Companions are excluded from both
halves of the fraction — a summoned beast takes turns the hero did not spend.

| party | rung | trash | elite | boss |
|---|---|---|---|---|
| Berserker / Cryomancer / Devout / Beastmaster | 1 wanderer | **3.5** (n=280) | **3.0** (n=299) | **3.8** (n=75) |
| Berserker / Cryomancer / Devout / Beastmaster | 2 warden | **3.8** (n=257) | **3.3** (n=304) | **4.3** (n=64) |
| Berserker / Cryomancer / Devout / Beastmaster | 3 ruin | **4.1** (n=179) | **3.6** (n=227) | **4.5** (n=40) |
| Berserker / Cryomancer / Devout / **Sharpshooter** | 2 warden | **5.0** (n=247) | **4.5** (n=260) | **5.5** (n=57) |

**This is the number the whole fix is aimed at, and it is worse than the brief guessed.** A hero
gets between three and five turns in a fight. **Spending one on setup is 20–33% of everything he
will do**, and the buff he bought has to pay that back inside the two to four turns that are left.
Most of them run four turns or six, so on paper they have the room — but only if the fight lasts
long enough to spend it, and it does not.

**Elite fights are the shortest of the three kinds at every rung**, which is the finding nobody
would have predicted. The elite node is where a run's difficulty is supposed to spike; it is
instead where the ramp specs have the least room of all.

**Confounder, named rather than buried: every party above is FULLY TALENTED** (`rows=9 of 9`), which
is the sim's default and is *stronger* than a real player at zone 1. The rung-1 row is the closest
thing here to an under-equipped party and it is the **shortest** fight in the table. Weakening the
party does not lengthen the fight — it shortens it, because the enemy budget falls with the rung.

### Does the ramp arrive?

Each meter is banked as a **per-battle peak** and reported **against the number its spec is built
around**, which is the only way the figure means anything. Sampled once per unit turn and
**read-only** — `frenzy_bonus()` is deliberately not called, because it ratchets the floor as a
side effect and an instrument that moves what it measures is not an instrument.

| spec | meter | built around | peak in an average fight | arrives |
|---|---|---|---|---|
| Berserker | Blood Frenzy | **40 points** (2% a step × 20 steps, the band at zero health) | 8.4 / **12.2** / 14.4 (rungs 1/2/3) | **21% / 31% / 36%** |
| Devout | Faith | **5 stacks** (the release threshold) | 1.4 / **1.6** / 1.7 | **28% / 32% / 35%** |
| Beastmaster | Loyalty | **5 stacks** (where the Pack Bond curve reads ×2) | 18.8 / **20.0** / 19.6 | **375% / 400% / 392%** |
| Sharpshooter | Focus | **100 points** (`FOCUS_CONVERT`, where chance stops and multiplier starts) | **131.3** (rung 2) | **131%** |

**Read the two halves of that table against each other.** Loyalty and Focus are uncapped meters
that gain on a timer — a stack per hunter turn per beast, Focus on every shot — so they arrive
before the fight ends and then keep going (deepest Loyalty observed: 66; deepest Focus: 460, at a
×4.04 critical multiplier). Blood Frenzy and Faith are **conditional**: Frenzy pays for health
already lost, Faith for absorbs and ground drip. Both land near a third of what they are built
around, **and a third of a Faith release is nothing at all — 1.6 of 5 means the average fight ends
without one ever firing.**

**FLAGGED FOR THE DESIGNER: the cap is the right fix for two of these four and probably not the
whole fix for the other two.** A Devout who peaks at 1.6 Faith does not reach 5 because he spent
half a swing less on setup. §3's reserved option — starting a fight with meter on the clock — is
still available and this measurement is the argument for it.

---

## AND WHAT IT DID — THE SAME FOUR SIMS, RE-RUN AFTER THE CAP

**§0 asked for the before, and this is beyond that ask.** It is here because "half is the
designer's first guess" is a decision that wants evidence, and the four sims cost ten minutes.
**Read it with the run report's own warning attached: at n=25, completions are a noisy secondary
and depth reached is the primary with an SE of 0.5–2.8 slots.** The runs are not seed-paired.

| | rung | completions before → after | depth reached before → after |
|---|---|---|---|
| A | 1 wanderer | 100% → **100%** | — |
| B | 2 warden | 52% → **84%** | 46.32 ±0.52 → **46.80 ±0.80** |
| C | 3 ruin | 12% → **36%** | 33.16 ±2.79 → **39.88 ±2.14** |
| D | 2 warden, Sharpshooter | 48% → **52%** | 41.12 ±2.10 → **42.60 ±1.86** |

**Depth rose in all three measurable arms and only rung 3's move is bigger than the combined
standard error.** Completions rose in three of four and the rung-3 arm tripled, but that column is
the one the harness explicitly says never to quote on its own. **The honest summary is: the change
helps, it helps most where the party was losing, and n=25 cannot size it more precisely than
that.**

### The three things the after-run says that the before-run could not

**FIGHTS GOT LONGER, NOT SHORTER.** Trash at rung 2 went **3.8 → 4.4** rounds, rung 3 **4.1 → 4.3**,
the Sharpshooter party **5.0 → 5.3**. A cheaper buff does not end fights faster — it buys a party
that survives to take more turns, and it buys a bot that spends more of them buffing. **That is the
cap partly paying for itself: the denominator §0 measured moves in the direction that makes the
numerator affordable.**

**FAITH IS THE METER THAT ANSWERED.** Peak Faith rose at every rung — **1.4 → 1.9** (rung 1),
**1.6 → 2.1** (rung 2), **1.7 → 2.1** (rung 3), **2.2 → 2.8** (Sharpshooter party). Roughly a third
more. **It is still short of the 5 a release needs**, which is the measurement §3's reserved option
was waiting for.

**BLOOD FRENZY WENT THE OTHER WAY, AND THAT IS NOT A BUG.** Peak Frenzy fell at every rung —
**8.4 → 7.4**, **12.2 → 11.8**, **14.4 → 12.7**, **14.6 → 12.7**. Blood Frenzy pays for health
already lost, and the cap made Spite, Ironclad, Battle Trance and every other mitigation buff
cheaper to hold, **so the Berserker takes less damage and his own band gets shallower.** Cheaper
defence is a nerf to the one passive that is paid in damage taken. **Flagged for the designer: this
is a real interaction, it is the opposite of what the batch was aimed at for that spec, and no
number was changed to hide it.**

---

## §1 — THE RULE

> **A pure buff's initiative delay is capped at half the basic attack's delay.**
> Setting up costs less tempo than swinging.

**Written against `BASIC_DELAY`, never as the 1.0 it evaluates to.** `Ability.BUFF_DELAY_CAP` is
`BASIC_DELAY * 0.5`, and `BASIC_DELAY` itself moved onto `Ability` (battle.gd now aliases it) —
**the delay is an ability's property, and `Ability.make` is where the cap has to be applied**, so
that is where the one authored `2.0` lives. All twelve of battle.gd's `BASIC_DELAY` sites read the
alias and there is still exactly one 2.0 in the project.

**HALF IS THE DESIGNER'S FIRST GUESS AND IS SHIPPED AS WRITTEN, NOT TUNED.** §0's measurement is
the evidence for and against it.

### Where the cap is applied, and why in two places

- **`Ability.make()` clamps it.** Every ability in the game is built through that one function, so
  there is exactly one answer to *what does this buff cost* and the draft card, the tooltip, the
  timeline preview and the cast itself all get the same one.
- **The 52 authored definitions were rewritten to `Ability.BUFF_DELAY_CAP`**, so the data does not
  lie about what the card costs. CR's own rule: *a change to a value is not finished when every
  site that computes it is updated; it is finished when every site that QUOTES it is updated.* An
  authored literal is a quoting site.
- **The two cannot disagree, and `check_cy.gd` asserts they do not.** The clamp is a no-op on
  today's data. It is not redundant: it is what makes the rule true for content a later batch adds,
  including content added by somebody who has not read the header.

### How the population was derived

**By walking `battle._resolve_special`'s call graph — not by reading `damage` and `pressure`.**
Those two fields are **zero on 137 of the 216 abilities in the corpus**, Feint, Guard Change and
Kill Command among them, and every one of those hits hard from inside its handler. A field test
would have halved the price of all of them. CN paid for that lesson on the timing bar, CO paid for
it again on the recast refusal, and this is the third table derived the same way.

> **A PURE BUFF is an ability whose ENTIRE cast-time payload is one or more statuses (or
> status-backed flags) written to the CASTER or to LIVING ALLIES.** At cast it deals no damage and
> no Break damage, heals nobody, moves no resource, no Pressure, no cooldown and no initiative,
> summons and revives nobody, strips nothing, and writes **nothing at all** to any enemy.

**Cast time is the whole of it, because the delay is paid at cast.** What the status goes on to do
afterwards — Venom Coating poisoning every later hit, Tripwire springing on an enemy's turn, Arcane
Arrows striking a second body — is what the buff *is*, not a second payload. The other reading
would put half the list outside the rule for doing its job.

**`check_cy.gd` re-walks it live**: it spawns two real battles across two different parties, casts
every one of the 52 through `_resolve_special`, and asserts that every enemy's health, resource and
status set and every hero's health, resource, second resource and Faith are **exactly where they
were**. 104 casts, 0 failures. The derivation is executed, not read.

### A CORRECTION TO THE CORPUS ITSELF, AND IT CHANGED THE ANSWER

**The Batch CL enumeration that `check_cn.gd` and `check_co.gd` both walk misses five abilities**,
and has always missed them. It walks the kits, the class pools and the spec pools; a talent node
that **grants** an ability which is in no pool is invisible to it. The five are **Backdraft,
Pyroblast, Glacial Prison, Cryoclasm and INTERCESSION**.

**Intercession is a pure buff** — a party-wide death-save whose whole payload is a status on every
living hero — and a CL-only sweep would have left it at 2.0 while its fifty-one neighbours came
down to 1.0. `check_cy.gd` walks `Talents.LANE_TREES` through `Talents.granted_ability` (the one
resolver both grant shapes go through) on top of the CL enumeration, so the corpus it checks is
**216, not 211**.

**This is reported, not fixed elsewhere.** CN's and CO's tables were derived over the smaller
corpus and neither has been re-derived here; whether either needs re-running against 216 is a
decision, not a detail. Of the five, four are enemy-facing and cannot join either table.

---

## THE FULL BEFORE/AFTER TABLE

Read from the ability definitions. **Cap = `BASIC_DELAY` × 0.5 = 1.00.**

|---|---|---|---|
| Aegis Wall | `aegis_wall` | 2.0 | **1.0** |
| Alms | `alms` | 2.0 | **1.0** |
| Anointing | `anointing` | 2.5 | **1.0** |
| Answering Steel | `answering_steel` | 1.5 | **1.0** |
| Anvil | `anvil` | 2.0 | **1.0** |
| Arcane Arrows | `arcane_arrows` | 2.0 | **1.0** |
| Ashes of Al'ar | `ashes` | 2.5 | **1.0** |
| Battle Poise | `battle_poise` | 2.0 | **1.0** |
| Battle Trance | `battle_trance` | 1.5 | **1.0** |
| Berserk | `berserk` | 2.0 | **1.0** |
| Bloodbond | `bloodbond` | 2.0 | **1.0** |
| Camouflage | `camouflage` | 1.5 | **1.0** |
| Consecrated Ground | `cons_ground` | 3.0 | **1.0** |
| Consecration | `consecration` | 2.5 | **1.0** |
| Covering Guard | `covering_guard` | 2.5 | **1.0** |
| Deadfall | `deadfall` | 2.0 | **1.0** |
| Discipline | `discipline` | 2.0 | **1.0** |
| Divine Presence | `divine_presence` | 2.0 | **1.0** |
| Divine Wrath | `divine_wrath` | 2.5 | **1.0** |
| Downwind | `downwind` | 2.0 | **1.0** |
| Emberkeep | `emberkeep` | 1.5 | **1.0** |
| Exhortation | `exhortation` | 2.5 | **1.0** |
| Fault Line | `fault_line` | 1.5 | **1.0** |
| Feigned Guard | `feigned_guard` | 1.0 | **1.0** *(unchanged — already at the cap)* |
| Formless | `formless` | 2.5 | **1.0** |
| Ghostpack | `ghostpack` | 2.5 | **1.0** |
| Hoarfrost Armor | `hoarfrost_armor` | 2.0 | **1.0** |
| Hunter's Instinct | `instinct` | 2.5 | **1.0** |
| Immolate | `immolate` | 1.5 | **1.0** |
| Intercession | `intercession` | 2.0 | **1.0** |
| Ironclad | `ironclad` | 1.5 | **1.0** |
| Last Howl | `last_howl` | 1.5 | **1.0** |
| Mana Shield | `mana_shield` | 2.0 | **1.0** |
| Mana Well | `mana_well` | 1.5 | **1.0** |
| Null Field | `null_field` | 2.0 | **1.0** |
| Quick Draw | `quickdraw` | 1.5 | **1.0** |
| Recompense | `recompense` | 1.5 | **1.0** |
| Resonant Field | `resonant_field` | 2.0 | **1.0** |
| Retaliation | `retaliate` | 2.0 | **1.0** |
| Rite of Return | `rite_of_return` | 3.0 | **1.0** |
| Sacred Resolve | `unity` | 2.5 | **1.0** |
| Shieldwall | `shield_block` | 1.5 | **1.0** |
| Spite | `spite` | 1.5 | **1.0** |
| Stalking Horse | `stalking_horse` | 2.0 | **1.0** |
| Succession | `succession` | 1.5 | **1.0** |
| Tripwire | `tripwire` | 2.0 | **1.0** |
| Turn the Blade | `turn_the_blade` | 2.0 | **1.0** |
| Undying Vigil | `undying_vigil` | 2.0 | **1.0** |
| Unslaked | `unslaked` | 2.0 | **1.0** |
| Venom Coating | `venom_coat` | 1.5 | **1.0** |
| Vow of Suffering | `vow_suffering` | 2.0 | **1.0** |
| Warcry | `warcry` | 2.0 | **1.0** |

**The distribution: 2 fall by 2.0, 10 by 1.5, 24 by 1.0, 15 by 0.5, and 1 does not move.** The
largest single moves are **Consecrated Ground** and **Rite of Return**, both 3.0 → 1.0 — each was
a turn and a half of tempo on top of a swing and is now half of one.

---

## §1's EXCLUDED POPULATIONS — REPORTED, UNTOUCHED

### HEALS — 15, and **not one of them changed**

*"A heal is a response to what just happened, not setup."* The answer to **is this card a heal** is `Ability.HEAL_SPECIALS`, plus the `heal` fields, plus a cast-time heal in the handler. CN §2 authored that question once and this batch does not ask it a second way. (`healing_wave`, `totem_pulse` and `wild_growth` are named in `HEAL_SPECIALS` and reach no drafted ability — `check_cn.gd` already WARNs on all three.)

| ability | special | delay | cd |
|---|---|---|---|
| Blessing of the Faithful | `jubilee` | 2.0 | 4 |
| Bulwark of Fortitude | `bulwark` | 3.0 | 3 |
| Dark Pact | `dark_pact` | 3.0 | 3 |
| Dawnbreak | `dawnbreak` | 3.0 | 2 |
| Divine Plea | `divine_plea` | 3.0 | 2 |
| Field Dressing | `field_dressing` | 2.0 | 3 |
| Fortified Spirit | `fortified_spirit` | 2.0 | 4 |
| Heal | `holy_heal` | 3.0 | 1 |
| Hymn of Hope | `hymn` | 3.5 | 2 |
| Ministration | `ministration` | 2.0 | 2 |
| Reliquary | `reliquary` | 2.5 | 5 |
| Renewal | `renewal` | 3.0 | 3 |
| Sanctuary | `sanctuary` | 3.5 | 4 |
| Second Wind | `second_wind_holy` | 2.5 | 4 |
| Spirit Bond | `spirit_bond` | 1.5 | 3 |

### SHIELDS — 6, reported for a ruling and **not one of them changed**

The criterion is mechanical: a shield is a **consumable absorb pool or charge count that eats incoming attacks**. Percentage mitigation running for N turns is not one — it has no pool — which is why Immolate, Ironclad, Camouflage and Consecrated Ground are buffs and these six are not.

| ability | special | delay | cd |
|---|---|---|---|
| Divine Shield | `divine_shield` | 2.5 | 2 |
| Interpose | `interpose` | 2.0 | 4 |
| Magic Barrier | `magic_barrier` | 2.0 | 4 |
| Mantle | `mantle` | 2.5 | 4 |
| Mirror Image | `mirror_image` | 2.0 | 4 |
| Vespers | `vespers` | 2.0 | 4 |

### DOES MORE THAN BUFF — 66, and **not one of them changed**

Damage, a status on an enemy, or a second payload that moves other state — resource, Pressure, cooldowns, initiative, a summon, a revive, a purge. Derived from the same walk; the `damage` and `pressure` fields are **zero on every one of them**.

| ability | special | delay | cd |
|---|---|---|---|
| Aegis Reversal | `aegis_reversal` | 2.5 | 4 |
| Arcane Surge | `surge` | 3.0 | 3 |
| Backdraft | `backdraft` | 2.0 | 3 |
| Battle Shout | `battle_shout` | 1.5 | 2 |
| Bestial Wrath | `bestial` | 3.5 | 3 |
| Bewitch | `bewitch` | 3.5 | 4 |
| Blessing of Zeal | `zeal` | 2.0 | 2 |
| Blight the Well | `blight_well` | 2.5 | 4 |
| Blink | `blink` | 1.0 | 3 |
| Blood Offering | `blood_offering` | 1.5 | 3 |
| Blood Price | `blood_price` | 1.5 | 3 |
| Bola | `bola` | 1.5 | 3 |
| Call of the Wild | `call_wild` | 4.0 | 4 |
| Call the Wilds | `call_wilds` | 2.0 | 5 |
| Choking Smoke | `choking_smoke` | 2.5 | 4 |
| Covenant of Ash | `covenant_ash` | 2.0 | 4 |
| Cryoclasm | `cryoclasm` | 2.0 | 3 |
| Cull | `cull` | 3.0 | 5 |
| Deep Winter | `deep_winter` | 2.5 | 4 |
| Dispel | `dispel` | 1.5 | 3 |
| Elevation | `elevation` | 2.5 | 5 |
| Ember Debt | `ember_debt` | 2.0 | 4 |
| Eye of the Storm | `eye_of_storm` | 2.0 | 4 |
| Feint | `feint` | 2.0 | 4 |
| Firedraw | `firedraw` | 2.5 | 4 |
| Flash Freeze | `flash_freeze` | 3.0 | 5 |
| Frostbind | `frostbind` | 2.5 | 4 |
| Funeral Pyre | `funeral_pyre` | 2.5 | 4 |
| Glacial Prison | `glacial_prison` | 2.5 | 4 |
| Guard Change | `guard_change` | 1.5 | 1 |
| Harvest | `harvest` | 3.0 | 4 |
| Hold Breath | `hold_breath` | 1.5 | 3 |
| Hold the Line | `hold_the_line` | 3.0 | 6 |
| Hunter's Mark | `hunters_mark` | 1.5 | 4 |
| Inner Arcane | `inner_arcane` | 1.0 | 3 |
| Kill Command | `kill_command` | 4.0 | 3 |
| Mark of the Hunt | `mark_hunt` | 2.0 | 3 |
| Mass Hysteria | `hysteria` | 4.0 | 4 |
| Ordination | `ordination` | 2.0 | 4 |
| Overcharge | `overcharge` | 1.5 | 5 |
| Penance | `penance` | 2.5 | 4 |
| Phoenix Rebirth | `phoenix` | 2.0 | 4 |
| Precision Strike | `precision_strike` | 2.0 | 3 |
| Preparation | `preparation` | 2.0 | 5 |
| Primal Surge | `primal_surge` | 3.0 | 2 |
| Quarry's Mark | `quarrys_mark` | 1.5 | 3 |
| Rally | `rally_ally` | 1.5 | 4 |
| Rallying Shout | `rally` | 2.5 | 3 |
| Reacquire | `reacquire` | 1.5 | 4 |
| Recant | `recant` | 2.0 | 4 |
| Reckless Abandon | `reckless_abandon` | 1.5 | 4 |
| Resurrection | `resurrection` | 4.0 | 3 |
| Rime | `rime` | 3.0 | 3 |
| Rimebinding | `rimebinding` | 2.0 | 3 |
| Savage Sweep | `savage_sweep` | 2.5 | 4 |
| Shared Grief | `shared_grief` | 2.0 | 4 |
| Slow Burn | `slow_burn` | 1.5 | 4 |
| Snare Line | `snare_line` | 2.5 | 4 |
| Snare Trap | `snare_trap` | 2.0 | 3 |
| Stabilize | `stabilize` | 1.5 | 3 |
| Summon Ursus | `summon` | 3.0 | 3 |
| Threshold | `threshold` | 1.5 | 5 |
| Transference | `transference` | 2.0 | 3 |
| Umbral Sigil | `umbral_sigil` | 3.0 | 4 |
| Unburden | `unburden` | 1.5 | 4 |
| Vendetta | `vendetta` | 1.5 | 4 |

**Enemy abilities are the fourth excluded population and are not tabled**: this is a hero tempo
problem, and no enemy ability was read, let alone changed.

### TWO JUDGEMENT CALLS, RECORDED RATHER THAN BURIED

Both are the designer's to overturn, and both are written into `ability.gd` beside the table so a
later reader finds the reasoning where the decision is.

- **THE DEATH-SAVES ARE IN** — Rite of Return, Bloodbond, Intercession, Ashes of Al'ar and Undying
  Vigil. Each is armed **before** the blow it answers, which is setup by every test §1 states, and
  none of them is an absorb pool. **If the designer rules them shields they leave as one group.**
- **THE HEAL-OVER-TIME BUFFS ARE IN** — Consecration, Aegis Wall and Battle Trance heal through a
  status they set. `HEAL_SPECIALS` says none of the three is a heal card, and none heals a point at
  cast, so the authored answer stands rather than being second-guessed here.

---

## §2 — THE CONSEQUENCE THAT REACHES BACK INTO CR

**CR accepted 40 buffs whose duration meets or exceeds its own cooldown**, on the explicit
reasoning that holding one costs an action and its resource every cycle — a real maintenance
tradeoff rather than a vanished decision. **At half delay that maintenance is half price.**

**28 of those 40 are in §1's population. NONE OF THEM CHANGED beyond the delay every other member
got.** This is the fold's shape — a systematic change quietly moving decisions made earlier — and
the whole point is that it surfaces now rather than in an audit five batches from now.

| ability | duration | cd | new delay | slack |
|---|---|---|---|---|
| Alms | 4 turns | 4 | 1.0 | = cd *(CR reverted this one to `= cd` in §3)* |
| Answering Steel | 6 turns | 4 | 1.0 | +2 |
| Battle Poise | 4 turns | 4 | 1.0 | = cd |
| Battle Trance | 4 turns | 4 | 1.0 | = cd |
| Consecrated Ground | 3 turns | 3 | 1.0 | = cd |
| Covering Guard | 4 turns | 4 | 1.0 | = cd |
| Discipline | 7 turns | 5 | 1.0 | +2 |
| Divine Presence | 4 turns | 4 | 1.0 | = cd *(CR reverted this one to `= cd` in §3)* |
| Divine Wrath | 4 turns | 4 | 1.0 | = cd |
| Emberkeep | 4 turns | 4 | 1.0 | = cd |
| Fault Line | 6 turns | 4 | 1.0 | +2 |
| Feigned Guard | 3 turns | 3 | 1.0 | = cd |
| Hoarfrost Armor | 4 turns | 4 | 1.0 | = cd |
| Immolate | 4 turns | 2 | 1.0 | **+2 on a 2cd** |
| Ironclad | 4 turns | 4 | 1.0 | = cd |
| Null Field | 4 turns | 4 | 1.0 | = cd |
| Quick Draw | 6 turns | 5 | 1.0 | +1 |
| Recompense | 6 turns | 4 | 1.0 | +2 |
| Resonant Field | 4 turns | 4 | 1.0 | = cd |
| Retaliation | 4 turns | 3 | 1.0 | +1 |
| Shieldwall | 3 turns | 2 | 1.0 | +1 |
| Spite | 6 turns | 4 | 1.0 | +2 |
| Stalking Horse | 4 turns | 4 | 1.0 | = cd |
| Succession | 6 turns | 4 | 1.0 | +2 |
| Tripwire | 6 turns | 4 | 1.0 | +2 |
| Turn the Blade | 4 turns | 4 | 1.0 | = cd |
| Undying Vigil | 4 turns | 4 | 1.0 | = cd |
| Vow of Suffering | 4 turns | 3 | 1.0 | +1 |

The twelve of CR's forty that are **not** in §1's population are excluded for reasons unchanged by
this batch: `blight_well`, `bola`, `ember_debt`, `frostbind`, `hunters_mark`, `mark_hunt`,
`penance`, `rime`, `slow_burn` and `umbral_sigil` all write to enemies; `zeal` ticks cooldowns;
`vespers` is a shield.

**THE SHARPEST ROW IS IMMOLATE**: a 4-turn window on a 2-turn cooldown that now costs half a swing
to hold. CR's maintenance argument was already thinnest there and this batch halves what was left
of it.

**A SECOND, SMALLER FOLD, FOUND WHILE APPLYING THIS ONE.** The **`up_speed` ability upgrade** reads
`ab.delay = maxf(ab.delay * 0.75, 1.0)` (`run_state.gd`). Its floor is 1.0, which is now exactly the
cap — **so `up_speed` on any of the 52 is a dead pick, and it was live on all of them yesterday.**
Reported, changed in no way. That floor being a literal 1.0 rather than the cap is worth a look the
next time either number is touched.

**AND CO'S RECAST REFUSAL WILL FIRE MORE**, which is correct behaviour and needs no change. Cheaper
buffs get recast more often, so the gate that refuses a recast which would not improve gets asked
more often. **A later reader should not read that increase as a regression.**

---

## §3 — WHAT THIS DELIBERATELY DOES NOT DO

Recorded so a later batch does not reach for them without a ruling:

- **Buffs are not free and do not stack onto another action.** The cost is reduced, not removed:
  every one still spends its resource, its cooldown and half a swing.
- **No ramp spec starts a fight with meter on the clock.** Still available, and **§0's Faith
  measurement is now the argument for it** — 1.6 of the 5 a release needs.
- **No enemy health changes.** The designer's call — it busts flow and balance to fix tempo with
  bulk.
- **The turn structure does not change.** The initiative timeline stays.
- **No cost, cooldown, duration or magnitude moved on any of the 52.**

---

## ONE MECHANICAL CONSEQUENCE THAT HAD TO BE TAKEN

**Mana Shield's flat discount is now clamped rather than assigned.** CN §3 made it unconditional —
`eff_delay = 1.5` at the cast site — and §1 brings its authored 2.0 down to 1.0. Left alone, the
"discount" would have been a **penalty dressed as a bonus**: the one card in the game where *it is
quick to cast* made it slower. It reads `minf(eff_delay, 1.5)` now, which is what the discount
always claimed to do. Its description still says "It is quick to cast" — true, but no longer
distinguishing, since all 52 are.

---

## §4 — GATES, AND WHAT WAS RUN

**`check_cy.gd` is new and joins the battery's gate list.** It asserts the rule against
`BASIC_DELAY`, the table's shape, the four excluded populations **by name** (CO's lesson: a gate
that can only pass is a gap), the mechanical half against each ability's own fields, CN's criterion
from the other side (a pure buff runs no timing bar), and then the live half.

| gate | result |
|---|---|
| `check_parse` | 0 failures |
| `check_cn` | 0 failures |
| `check_co` | 0 failures |
| `check_cs` | 104 checks, 0 failures |
| `check_ct` | 113 checks, 0 failures |
| `check_cu` | 0 failures |
| `check_cv` | 0 failures (324 nodes) |
| `check_flow` | 0 failures |
| **`check_cy`** | **0 failures**, 104 live casts across 2 fixtures |

**Eight full runs of the game completed end to end** — four before the change and four after,
25 runs each, three difficulty rungs, ~2,300 battles per pass. Battles resolve.

**NO FULL BATTERY WAS RUN.** CT, CU, CV, CW, CX and now CY are implement-only under the standing
convention. **The next dedicated test batch still owes one**, and it now owes it against a
`CLAUDE.md` that ten assertions no longer match (CW's damage, unrepaired) **and** against 52
abilities whose initiative cost moved.
