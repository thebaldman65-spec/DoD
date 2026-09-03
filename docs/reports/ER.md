# BATCH ER — LOYALTY CONVERTS, IT DOES NOT FLATTEN

**The ruling is taken and recorded. The currency is NOT chosen and nothing was authored.** §1
prices four currencies, §2–§4 price the three Beastmaster runes, and **no rune, node, constant or
magnitude moved.** What shipped is §5: **five corrections to the record**, four of them copies of a
wrong claim an earlier sweep had missed.

**THE RULING'S OWN ARGUMENT NEEDED TESTING, AND IT DOES NOT SURVIVE INTACT.** The case for
converting rather than flattening is that its loss column is zero. **On Focus that is true for two
reasons Loyalty has neither of**, and measured at the site the payout is read, **a conversion at
nominal costs the companion strike step 20.35%** at the loadout a single rung-1 clear buys. That
does not overturn the ruling — it prices it, and it is what every currency in §1 is quoted against.

**Six documents moved and five source lines. Every measurement below is live**, taken on an
out-of-repo instrumented copy: **not one executable byte of the shipped tree carries a probe.**

---

## THE BRIEF'S CLAIMS, RE-DERIVED

| claim | verdict |
|---|---|
| *"EQ priced its loss column at zero … above nominal depth pays in a different currency rather than more of the same"* | **TRUE OF FOCUS, NOT INHERITED BY LOYALTY, AND THIS IS THE BATCH'S MAIN FINDING.** Focus's zero rests on two unstated preconditions: its first half **SATURATES** (crit chance stops paying at +50%, so converted points bought nothing) and its **RATE IS UNTOUCHABLE** (`FOCUS_STEP` is a const no node modifies; Deep Focus moves the *split point*). **Loyalty's first half never saturates and every one of its rates carries a node.** Measured cost of converting at nominal: **20.35% of the companion strike step**, blow-weighted at the read site. See §1a/§1b. |
| *"Focus … past 100 it stops adding crit chance and starts adding crit multiplier"* | **HOLDS, AND IS SHARPER THAN STATED.** `focus_crit_chance()` is `mini(second_resource, focus_convert()) * FOCUS_STEP`, `focus_crit_mult()` is `maxi(second_resource - focus_convert(), 0) * FOCUS_STEP` (`unit.gd:840/846`). **The threshold is NOT a fixed 100** — `focus_convert()` is `maxi(FOCUS_CONVERT - deep_focus - rune_deep_focus, 1)`, so a node and a rune move it. That movable point is §2's whole answer. |
| *"21.2 was a rows=9 figure; Loyalty reads 10.13 ± 0.11, and untalented 6.61 ± 0.09"* | **REPRODUCES ON ALL THREE ARMS.** Live: **10.08 ± 0.12** (n=1947), **6.64 ± 0.09** (n=1391), **18.98 ± 0.17** at rows 1–9 (n=2649). A fourth arm read **10.2** (n=2030). See §1c. |
| *"A meter arriving twice over, not four times"* | **HOLDS.** 10.08 / 5 = **2.02×** nominal at the first-clear loadout; 3.80× fully talented. |
| *"the rung already suppresses [it] by killing companions three times as often at rung 2"* | **NOT RE-MEASURED HERE — EQ's rung-1 arm was not re-run**, so this batch neither confirms nor disturbs it. Stated so it is not read as verified. |
| **"His boss pool is the only one in the game with no damaging card"** (§1) | **WRONG, FOR THE THIRD TIME, AND EQ ALREADY CORRECTED IT.** Re-derived independently through `Classes.pool_ability` over all twelve pools: **THREE carry no card with a `damage` field — Beastmaster 5, Holy 3, Devout 2** — and all three also carry no `pressure`. See §3a for the full table by id and display name. **The Break option survives on a different and better fact** (§1e). |
| *"Nine payout sites take the conversion; the raw-stack readers do not"* | **HOLDS**, and re-verified at the two spender sites: Unleash reads `int(attacker.loyalty.get(ul_kind, 0))` and Primal Surge `int(attacker.loyalty.get(ps_comp.companion_kind, 0))` — **neither calls `_bond_mult` at all.** §1d states which side each falls on. |
| *"The game already flattens Loyalty three times … Bring It Down's hard cap binds on 41.5% of casts at rows 1–3"* | **NOT RE-MEASURED — quoted from `docs/reports/EQ.md` §1b with its loadout attached**, as the standing rule requires. What IS re-derived is the consequence: §1f. |
| *"No cap below 8, ever … Kindred is a row-8 node"* | **HOLDS, AND A CONVERSION SATISFIES IT BY CONSTRUCTION** rather than by care — it writes nothing into the accrual, so Kindred at 8, Lone Bond at 6 and None Left Behind at 5 all keep firing. §1f. |
| *"Today it buys 20–21% of a node in rows 1–3"* (§2) | **HOLDS** — `rune_wild_communion_step` 1.5 against Wild Communion's 7 is 21%, `rune_absolute_step` 3.0 against Absolute Devotion's 15 is 20% (`docs/reports/EP.md` §4's table, re-checked against `talents.gd` and `data/runes.json`). |
| *"`SWAP_COOLDOWN` is 3, Quick Whistle shaves 3, and the read site floors at 0"* (§3) | **HOLDS AT THE LINE.** `battle.gd:20366` is 3; the read site is `maxi(SWAP_COOLDOWN - hunter.quick_whistle_ranks - hunter.rune_quick_whistle_ranks, 0)` at `:20520`. |
| *"swaps fall 0.38 → 0.21 → 0.02"* (§3) | **THE DIRECTION REPRODUCES; THE UNTALENTED END DOES NOT.** Live per trash fight: **0.28** (rows 0, n=1295), **0.22 / 0.23** (rows 1–3, n=1777 / 1854), **0.01** (rows 1–9, n=2360). The untalented arm has now read 0.35 (EP), 0.38 (EQ) and 0.28 (ER). |
| **"Tempo is the axis his kit is thinnest on"** (§3) | **TRUE INSIDE HIS KIT AND EQ'S OWN COUNT IS OFF BY ONE.** EQ recorded *"eight of the twelve specs carry ZERO TEMPO"*; re-derived over EQ's own population it is **SEVEN**, and over the pool a player can actually reach since EH §1 opened the class-wide tier it is **THREE**, with **two** specs beating his one. §3b. |
| **"0.22 companion deaths a trash fight and 0.39 at a boss"** (§4) | **THE TRASH FIGURE IS SOLID; THE BOSS FIGURE IS NOT A MEASUREMENT AT ITS n.** Trash reproduces four times over: **0.22 / 0.22 / 0.23 / 0.22**. The boss figure at the untalented arm has read **0.39 (EP), 0.48 (EQ) and 0.26 (ER)** on n ≈ 95 each time. **The brief quotes EP's 0.39, which EQ had already superseded with 0.48 — and neither reproduces.** §4a. |
| *"Two in-game strings still say the swap cooldown is 2"* (§5) | **HOLDS, AND THERE WERE FOUR COPIES, NOT TWO.** The two strings, plus a source comment one screen above, **plus a third copy in `master.html` 750 lines below the one EQ corrected**. §5. |
| *"`master.html` carried the same error from BB until EQ fixed it"* | **HALF RIGHT — EQ FIXED ONE COPY OF TWO.** §5(4). |
| *"`inquisitor` is the Devout, `mystic` the Survivalist"* (§6) | **HOLDS** — `classes.gd:5289` and `:5317`. Every spec table below carries both. |

---

## §1 — WHAT LOYALTY CONVERTS INTO. **OPTIONS ONLY; NOTHING AUTHORED.**

### §1a — **THE PORT OF FOCUS'S SHAPE IS NOT A PORT OF FOCUS'S SAFETY**

This is the finding the section turns on, and it is a property of the code rather than a judgement.

**Focus's conversion has a zero loss column for two reasons, and Loyalty has neither:**

| | Focus | Loyalty |
|---|---|---|
| **does the first half saturate?** | **YES.** `focus_crit_chance()` buys crit CHANCE, which stops paying at +50%. The points that convert were already buying nothing. | **NO.** `_bond_mult` is `1 + step × Loyalty` and climbs for ever; `_comp_dmg_mult`'s strike step likewise. **Every converted stack was still paying full rate.** |
| **is the rate untouchable?** | **YES.** `FOCUS_STEP := 0.005` is a const **no node and no rune modifies**. What Deep Focus and the (retired) Rune of the Deep Sight move is `focus_convert()` — **the SPLIT POINT.** | **NO.** `_bond_step` = `BOND_STEP + 0.01 × (absolute_step + rune_absolute_step)`, **doubled by Ancient Pact**. The strike step = `0.05 + 0.01 × (wild_communion_step + rune_wild_communion_step)`. **Two nodes and two runes, on the two rates.** |

**THE CONSEQUENCE, AND IT IS THE ONE RULE THIS BATCH WOULD ASK FOR IF IT WERE BUILDING:** the half
of the precedent that transfers is **move the split point, never the rate.** A node that steepens
the converted half re-creates the over-arrival on the other side of the split, which is the thing
the ruling exists to stop. It is recorded in `CLAUDE.md`.

**AND NOMINAL IS NOT A LIVE NUMBER TODAY.** The 5 is a literal in `battle.CY_METERS`, whose own
header calls it *"where the Pack Bond curve reads x2 (`BOND_STEP`)"* — an instrument's reference
point, and the only one of that table's four denominators that is not a live constant. A conversion
needs a **`BOND_CONVERT` beside `BOND_STEP`**, which is `FOCUS_CONVERT`'s exact counterpart.

### §1b — **WHAT THE CONVERSION COSTS, MEASURED AT THE SITE THE STEP IS READ**

**ARM B: `_comp_dmg_mult` instrumented directly — one sample per companion blow, at the read
site**, so what is banked is the number the multiplier was actually computed from. `--run 100`,
`DOD_SIM_DIFFICULTY=warden` (rung 2), `DOD_SIM_ROWS=3`, `DOD_SIM_ROUTE=balanced`, specs
`berserker,cryomancer,inquisitor,beastmaster`.

```
n = 2,030 battles          6,283 companion blows carrying the strike step
mean Loyalty at the blow                          7.44
mean stacks ABOVE nominal at the blow             3.17
share of the blow's own meter above nominal      42.6%
```

| what is being asked | answer |
|---|---|
| **conversion at nominal, strike step lost — POOLED over blows** | **20.35%** |
| conversion at nominal, strike step lost — **mean over battles** | **15.50 ± 0.27%** (n=1906 battles) |
| **what each converted stack must return for the loss column to be zero** | **6.42% of a companion blow** |

**THE TWO SUMMARY FIGURES DIFFER BECAUSE THEY WEIGHT DIFFERENTLY AND BOTH ARE PRINTED**: the
pooled figure weights a battle by how many blows it contained, the per-battle mean does not. **The
pooled one is the honest answer to "what does the Beastmaster lose"**; the per-battle one carries
the standard error.

**AND THE WEIGHTING IS NOT A DETAIL — IT MOVES THE ANSWER BY A FACTOR OF THREE.** The same
counterfactual, same arm, three weightings:

| weighting | what it prices | rows 0 | rows 1–3 | rows 1–9 |
|---|---|---|---|---|
| **per-battle PEAK** (the report's historic figure) | every blow at the fight's deepest moment | 8.1% | **17.9%** | 35.9% |
| **meter-time** (every hunter-turn sample) | the meter's own time-average | 2.4% | **6.0%** | 18.0% |
| **per BLOW, at the read site** (arm B) | **the population that is actually paid** | — | **20.35%** | — |

**Only the third is a measurement of the thing being lost.** The other two are printed so that a
later batch reading a different number knows which question it answered.

### §1c — **AND EQ's LOSS TABLE IS PRICED AT A STEP THE MEASURED ARM DOES NOT WEAR**

`docs/reports/EQ.md` §2 states its own pricing: *"the strike step is priced as `1 + 0.05 L`"*.
**0.05 is the BASE step.** Every arm at rows ≥ 1 holds **Wild Communion — devotion row 1, the
first node the sim's Beastmaster takes** — which raises it to **0.12**. Re-priced at the live step
the loss is **roughly double** what that table prints: its **9.7%** for the cap at nominal is
**20.35%** measured.

**THIS IS A CORRECTION TO A FIGURE, NOT TO A METHOD.** EQ named its own assumption in the text; it
simply does not describe the arm the histogram came from. **Every row of that table is affected in
the same direction**, so its ORDERING between shapes stands and its MAGNITUDES do not.

### §1d — **WHICH SIDE EACH READER FALLS ON. THE BRIEF ASKS; THIS IS THE ANSWER.**

**A conversion above nominal is a change to the PAYOUT ONLY. Nothing is written into
`_gain_loyalty` or `_loyalty_cap`, so the accrual is untouched by construction.**

| reader | class | takes the conversion? |
|---|---|---|
| `_bond_mult` — the Pack Bond boon | payout | **YES** (or receives it — §1e option 3) |
| `_comp_dmg_mult` — the companion strike step | payout | **YES** |
| `_ghost_hit`'s step — the bodiless blow | payout | **YES** |
| Canis's wounded bonus (`× _bond_mult`) | payout | **YES** |
| Ursus's mitigation (`× _bond_mult`, clamp 0.75) | payout | **YES** |
| Savage Presence's taunt pull (`× _bond_mult`, clamp 1.0) | payout | **YES** |
| `_party_crit_bonus` — Aguila (`0.10 × _bond_mult`) | payout | **YES** |
| `_bond_step` | payout (rate) | **it IS the rate — see §1a: move the point, not this** |
| the Loyalty chip's own text | display | **must show it — §1g** |
| **Unleash** — `0.20 × stacks × Attack` | raw stack | **NO** |
| **Primal Surge** — `0.15 × stacks × Attack` per companion | raw stack | **NO** |
| **Last Howl** — `3 × the meter the fallen companion held` | raw stack | **NO** |
| **Bring It Down** — `min(stacks × 2, 20)` points, party-wide | raw stack | **NO** |
| Kill Command's Bleed, Aguila's pierce, Ursus's gift, Succession | raw stack | **NO** |
| **Kindred (8), the two spender doors (1), the bot's gate (4)** | threshold | **NO** |
| **Lone Bond (6), None Left Behind (5), Wild Rotation's cap (3)** | writes a floor | **NO** |

**So the four cards the brief names all keep paying exactly what they pay today**, and the
conversion's whole cost lands on the seven live payout readers plus the chip.

### §1e — **THE FOUR CURRENCIES, PRICED. NONE AUTHORED.**

**Every one is quoted against the same price tag: a converted stack must return ~6.4% of a
companion blow, and at the first-clear loadout there are 3.17 of them at every blow.**

| # | currency | read site & build cost | what it teaches | what it costs |
|---|---|---|---|---|
| **1** | **BREAK on the companion's own blow.** Each converted stack adds Break to the strike. | **ZERO NEW MACHINERY — and this is new.** `_companion_hit(comp, victim, dmg, pr)` already takes a Break argument, and **six of its eight call sites pass `pr = 0`**, including *every* ordinary companion strike and Primal Surge. Only Kill Command's Ursus branch (40) and Unleash (`UNLEASH_BREAK` 12) pass anything. | **The companion's routine blow Breaks nothing today, at every one of its sites** — which is a real hole, and a better fact than the one the brief offers. It also makes the party's shared lever the thing depth buys. | **IT MEETS A STANDING REFUSAL WRITTEN INTO THIS CODE.** `UNLEASH_BREAK`'s own header: *"FLAT, and it must stay flat. The stack count it spends is uncapped, so a per-stack Break term is the squaring trap Arcane Bolt, Requiem and Pyre Wake each refused from their own side."* **The converted half is also uncapped, so this is that refusal restated.** A FLAT Break above the point is not a conversion — it is a threshold bonus. |
| **2** | **COMPANION DURABILITY.** Converted stacks buy the companion's survival. | **A NEW FIELD AND A NEW READ SITE.** `rune_companion_hp_pct` is read **once, at the summon**, into `base_hp` (`battle.gd:~20542`) — a conversion pays continuously and `base_hp` is fixed at the summon, so this needs a mitigation term or a shield, both new. | Companion durability is the one Beastmaster number no rune and few nodes touch, and the event is real: **0.22–0.23 companion deaths a trash fight**, measured four times. | **IT PAYS INTO THE METER'S ONLY GOVERNOR.** `CLAUDE.md`'s uncapped-meter table names Loyalty's governor as **the companion's death**. Buying survival with depth is **positive feedback on the one thing bounding the meter**: deeper bond → longer-lived companion → deeper bond. **The brief states this as the currency's virtue (*"makes the meter defend itself"*); it is the same fact and the sign is the question.** **And it collides with §4** — see there. |
| **3** | **THE PACK BOND BOON'S OWN GROWTH.** Below the point the meter buys `_comp_dmg_mult`'s strike step (the hunter's damage); above it, `_bond_mult` (the beast's presence — Ursus's mitigation, Canis's wounded bonus, Aguila's party crit). | **THE ONLY ONE OF THE FOUR THAT NEEDS NO NEW FIELD AND NO NEW READ SITE.** Both halves already exist and both are already payout readers. **This is Focus's structure exactly** — two existing halves of one passive, split at a point. | It is the only option where the meter genuinely changes **KIND**: *"my beast hits harder"* becomes *"my beast's presence changes the fight."* It also **pays the party rather than the hunter**, since Aguila's half is party-wide crit. | **THE RECEIVING HALF IS THE STEEPEST TERM IN THE SYSTEM.** `_bond_step` is raised by Absolute Devotion and **doubled by Ancient Pact**, so this hands the uncapped half to the term two nodes multiply — §1a's trap, from the inside. **It also makes the two existing clamps bind HARDER, not less** (§1f), which is the opposite problem to the other three and may be the point. |
| **4** | **PARTY-WIDE.** The deepest bond pays every hero. | **Machinery exists.** `_party_crit_bonus` is already a party-wide read of `_bond_mult` (best among pack heroes), and **Bring It Down is already a party-wide card reading the raw meter**. | It answers the 10-of-10 engine binding directly: it makes the other three heroes care what the meter reads, which is the stated reason Bring It Down exists. | **BRING IT DOWN ALREADY IS THIS, AND IT IS ALREADY HARD-CAPPED** at 20 points = 10 stacks, binding on 41.5% of casts at rows 1–3 (EQ). A party-wide conversion duplicates the card that exists and doubles down on a term already flattened. **And `_party_crit_bonus` requires Aguila specifically**, so a general party-wide payout is a new term, not that one. |

**IF THE DESIGNER WANTS A RECOMMENDATION IT IS OPTION 3, AND THE REASON IS STRUCTURAL RATHER THAN
NUMERIC**: it is the only one whose two halves already exist as live payout readers, which is the
property that makes Focus's conversion cheap, legible and un-drifting. **Its cost is real and is
stated above.** Nothing is authored either way.

### §1f — **THE THREE EXISTING FLATTENERS, RECONCILED RATHER THAN LAYERED**

**The brief asks for this explicitly. A conversion does not sit on top of them; it changes two of
them and leaves the third alone.**

- **BRING IT DOWN's hard cap of 20 points is UNTOUCHED** — it is a raw-stack reader, so a payout
  conversion never reaches it. It keeps binding exactly as often as it does today.
- **`BOND_MITIGATION_MAX` 0.75 AND THE TAUNT CLAMP OF 1.0 GO ONE WAY OR THE OTHER, AND WHICH WAY
  DEPENDS ON §1e's CHOICE.** Both read `_bond_mult`. Derived at the deepest live step
  (`BOND_STEP` 0.20 + Absolute Devotion 15 + the rune 3, doubled by Ancient Pact = **0.76 a
  stack**):
  - **If `_bond_mult` is the half that CAPS at nominal**, it reaches `1 + 0.76 × 5 = 4.80`. Ursus's
    mitigation reads `0.10 × 4.80 = 0.48` against a clamp of **0.75**, and the taunt pull
    `0.15 × 4.80 = 0.72` against **1.0**. **Both become unreachable at every talent depth** —
    which by AR §4's rule makes them dead constants rather than governors. **This is the same
    consequence EQ flagged for a hard cap at 10, arriving through a conversion.**
  - **If `_bond_mult` is the half that RECEIVES** (§1e option 3), both bind **harder** than today,
    and the clamps do more work rather than less.
- **SO THE HONEST STATEMENT IS: A CONVERSION AT NOMINAL EITHER KILLS TWO GOVERNORS OR PROMOTES
  THEM, AND THE BATCH THAT BUILDS IT OWES THAT SENTENCE.** It is recorded in `CLAUDE.md`.
- **AND THE CONSTRAINT THAT KILLED FOUR OF EQ's FIVE SHAPES IS SATISFIED FOR FREE.** *No cap below
  8, ever.* A conversion writes nothing into the accrual, so **Kindred still fires at 8, Lone Bond
  still seats at 6, None Left Behind still seats at 5, and Wild Rotation's cap of 3 is the only
  ceiling in the system** — exactly as today. **That is the ruling's strongest property and it is
  structural, not careful.**

### §1g — **THE CHIP, AND WHAT LEGIBILITY COSTS**

**Focus's phase change is visible because the nameplate prints both halves side by side**:
`"Focus %d (+%d%% crit / x%s)"` (`unit.gd:~2011`), feeding `focus_crit_chance()` and
`lethal_crit_mult()`. **`battle._stamp_loyalty_chip` (`battle.gd:13432`) is the counterpart
surface and it already builds a two-line chip** — `"Loyalty %s: +%d%% strike damage\nand %s."`
plus `"\nPack Bond boon x%.1f (+%d%% a stack)."` — **so the structure to carry a second phase is
already there and the cost is one format string, exactly as Focus's was.**

**AND THE TEXT COST IS THE NINE SURFACES EQ COUNTED, MINUS THE PROMISE.** A conversion does **not**
break the *"NO MAXIMUM"* / *"no ceiling"* / *"it never plateaus"* promises — **the meter really does
stay uncapped** — so the nine surfaces need the second phase NAMED rather than the first phase
retracted. **That is a smaller text change than any of EQ's four shapes required**, and it is the
second real advantage of the conversion over them.

---

## §2 — DEEP BOND READS THE CONVERSION. **OPTIONS ONLY; NOTHING AUTHORED.**

**Held until §1's currency is picked, as the brief directs — and the batch can now say WHY that is
forced rather than cautious.**

### §2a — **THE SHAPE IS ALREADY IN THIS GAME, AND IT WAS RETIRED EIGHT BATCHES AGO**

**`Rune of the Deep Sight`** — 100g rare, `spec:sharpshooter`, lane *Precision* — carried
`rune_deep_focus: 8`, and `focus_convert()` reads it: `maxi(FOCUS_CONVERT - deep_focus -
rune_deep_focus, 1)`. **Its `retired` string in `data/runes.json` names the loss exactly:**

> *"RETIRED at BATCH EO §3 — kept, and said to be kept. LOST: the Focus conversion POINT moving —
> the one item that changes WHEN his patience converts rather than how much it pays."*

**So the class of item a re-authored Deep Bond would be is proven, is precedented on a rune of the
same rarity and price, and the slot for it is currently empty.**

### §2b — **WHY IT PROTECTS THE IDENTITY THE BRIEF SAYS TO PROTECT**

The identity is *"the only one of the three that rewards NOT swapping"*, which is what makes it the
Turning Pack's exact opposite. **A split-point rune keeps that intact and does not merely preserve
it — it sharpens it:**

- **DEPTH is still the axis.** The rune's value is entirely a function of how deep the meter runs,
  because it changes when depth changes kind.
- **A held bond is what reaches the point.** A swap evicts the shallower bond and Succession carries
  only half; **a rune that pays for crossing a threshold pays most to the player who never resets.**
- **It mirrors NO node.** No Beastmaster node moves a Loyalty conversion point, because there is no
  point to move. **That is the charter's own complaint answered** — today the rune buys **20–21% of
  a node the player already owns** (`rune_wild_communion_step` 1.5 against Wild Communion's 7;
  `rune_absolute_step` 3.0 against Absolute Devotion's 15).
- **And it obeys §1a's rule**: it moves the POINT, never the rate.

### §2c — **THE DIRECTION IS UNDECIDABLE UNTIL §1 IS ANSWERED, AND THAT IS THE PROOF THE BRIEF IS RIGHT**

**Moving the split point DOWN is a buff if and only if the converted half is worth more than the
half it takes from.** On Focus that is settled — the first half saturates — so down is always a
buff and Deep Focus moves it down by 40. **On Loyalty nothing is settled**, because §1's currency
is unchosen:

| if §1 picks… | then the Deep Bond should move the point… | and it reads as |
|---|---|---|
| a currency worth **more** than the strike step at depth | **DOWN** (convert sooner) | *"his bond turns into the other thing sooner"* — Deep Focus's exact shape |
| a currency worth **less**, priced as a governor | **UP** (convert later) | a rune that **partially undoes the ruling**, which is a different object and probably not this one |
| a currency worth **the same** (a true zero loss column) | either — **and the rune has no axis at all** | the re-author fails and a different one is owed |

**A depth rune authored against an unchosen currency is authored twice, and this table is why.**

### §2d — **THE THREE OTHER SHAPES, PRICED SO THE SPLIT POINT IS NOT THE ONLY OPTION**

| # | shape | build cost | keeps the not-swapping identity? | what it costs |
|---|---|---|---|---|
| **1** | **Move the conversion point** (§2a–§2c). | One field + one read site inside `_bond_convert()`, the `focus_convert()` pattern. | **YES, strongly.** | Its direction waits on §1; and if §1's loss column really is zero, the rune has no axis. |
| **2** | **Pay a share of the CONVERTED half only** — the rune multiplies what depth-above-nominal buys, and nothing below it. | One field read at whichever site §1 chooses. | **YES** — it is worth nothing to a player who never gets deep. | **It is §1a's trap by name**: a rune that steepens the converted half re-creates the over-arrival on the far side of the split. **Recommended against on the rule this batch is writing.** |
| **3** | **Pay for the meter's AGE rather than its depth** — a bond that has stood N turns unbroken pays. | New field + a turn counter; no existing site has one. | **YES, and most literally of the four** — it is the only shape that a swap resets outright. | Largest build of the four, and it is a second meter on a spec that already has one. |
| **4** | **Keep depth and re-price it** (today's clauses, larger numbers). | **Zero — a JSON edit.** | Yes, but unchanged. | **This is what the charter complained about**, and at 20–21% of a node the complaint is a magnitude rather than an opinion. A re-price that lands near that figure has not answered it. |

---

## §3 — THE TURNING PACK. **OPTIONS ONLY; NOTHING AUTHORED.**

### §3a — **HALF OF IT IS STILL WORTH ZERO, CONFIRMED AT THE LINE**

`battle.gd:20520`:

```gdscript
hunter.cooldowns["Swap Companion"] = maxi(
    SWAP_COOLDOWN - hunter.quick_whistle_ranks
        - hunter.rune_quick_whistle_ranks, 0)
```

`SWAP_COOLDOWN` is **3** (`:20366`), Quick Whistle shaves **3**, and Quick Whistle is **pack row
1** — inside the rows a single rung-1 clear opens. **A Beastmaster holding it is already at the
floor and the rune's +1 pays exactly nothing.** Wild Rotation skips the block outright
(`if was_swap and hunter.wild_rotation == 0`).

**AND THE VERB IT CHEAPENS FALLS AS THE BUILD DEEPENS — RE-MEASURED, FOUR ARMS:**

| arm | rows | swaps / trash fight | n | swaps / boss fight | n |
|---|---|---|---|---|---|
| C | 0 | **0.28** | 1295 | 0.51 | 96 |
| A | 1–3 | **0.22** | 1777 | 0.42 | 170 |
| B | 1–3 | **0.23** | 1854 | 0.40 | 176 |
| D | 1–9 | **0.01** | 2360 | 0.02 | 289 |

**The direction is the finding and it reproduces cleanly; the untalented magnitude does not** — it
has now read 0.35 (EP), 0.38 (EQ) and 0.28 (ER). **A cooldown shave on an action taken 0.01 times a
fight is priced against a behaviour that does not happen.**

### §3b — **THE CONCENTRATION ARGUMENT FOR BREAK, RE-DERIVED. IT IS WRONG FOR THE THIRD TIME.**

**Derived through `Classes.pool_ability` over all twelve boss pools — by id AND display name:**

| spec id | display name | pool | with `damage` | with `pressure` |
|---|---|---|---|---|
| arcanist | Arcanist | 4 | 1 | 0 |
| **beastmaster** | **Beastmaster** | 5 | **0** | **0** |
| berserker | Berserker | 3 | 1 | 1 |
| cryomancer | Cryomancer | 3 | 1 | 1 |
| **holy** | **Holy** | 3 | **0** | **0** |
| **inquisitor** | **Devout** | 2 | **0** | **0** |
| mystic | Survivalist | 5 | 2 | 2 |
| occultist | Occultist | 3 | 1 | 1 |
| pyromancer | Pyromancer | 3 | 1 | 1 |
| sharpshooter | Sharpshooter | 5 | 4 | 4 |
| swordmaster | Swordmaster | 4 | 4 | 4 |
| warden | Warden | 4 | 1 | 1 |

**THREE POOLS, NOT ONE**, and all three carry no `pressure` either. **And by TAG the Beastmaster is
mid-pack on Break, not empty** — six BREAK-tagged cards across both his pools, against a range of
0 to 11:

| spec id | display name | TEMPO | BREAK | cards (spec draft + boss) |
|---|---|---|---|---|
| arcanist | Arcanist | 1 | 6 | 14 |
| beastmaster | Beastmaster | **1** | **6** | 15 |
| berserker | Berserker | 0 | 3 | 11 |
| cryomancer | Cryomancer | 0 | 5 | 12 |
| holy | Holy | 0 | 1 | 12 |
| inquisitor | **Devout** | 0 | **0** | 11 |
| mystic | Survivalist | 1 | 6 | 15 |
| occultist | Occultist | 0 | 4 | 11 |
| pyromancer | Pyromancer | 0 | 7 | 14 |
| sharpshooter | Sharpshooter | 1 | 11 | 15 |
| swordmaster | Swordmaster | 3 | 8 | 14 |
| warden | Warden | 0 | 5 | 13 |

**THE SPEC WITH NO BREAK AT ALL IS THE DEVOUT**, and he is also one of the three with no damaging
boss card and holds the thinnest boss pool in the game at 2. **If a concentration finding is what
a re-author should answer, his is sharper than the Beastmaster's on every axis measured here.**

**AND EQ's TEMPO COUNT IS OFF BY ONE.** EQ recorded *"eight of the twelve specs carry ZERO TEMPO
cards"*. Over EQ's own population (spec draft + boss) it is **SEVEN**. Over the population a player
can actually reach — **spec draft + boss + the class-wide draft pool EH §1 opened as the third tier
of the award chain** — it is **THREE**, and the Beastmaster's one is beaten by **two** specs
(Swordmaster 4, Arcanist 2), not one.

**WHAT SURVIVES, AND IT IS BETTER THAN WHAT WAS CLAIMED:** the Beastmaster's **companion** blow
carries no Break at any of its ordinary sites — six of `_companion_hit`'s eight call sites pass
`pr = 0`, and the two that do not are Kill Command's Ursus branch and Unleash. **That is a real
hole, it is about the companion rather than the pool, and it is the fact a Break re-author should
be argued from.**

### §3c — **THE OPTIONS, PRICED**

**`runes.gd`'s own header: adding a rune is a JSON edit; there is NO new payload machinery.** A
`stat` payload needs an existing `rune_*` field and a read site; a new field needs both authored
plus a line in `Runes.STAT_INT_KEYS` if it is an int not ending `_ranks`.

| # | shape | build cost | what it answers | what it costs |
|---|---|---|---|---|
| **1** | **Pay the swap in BREAK** — the arriving companion's next strike carries Break. | **ZERO NEW MACHINERY.** `_companion_hit`'s `pr` argument already exists and the arrival path already calls it. | The companion's real Break hole (§3b), and it makes the swap worth taking rather than cheaper. **Genuinely opposite to Deep Bond**: it never reads the meter. | It is **flat per swap**, so `UNLEASH_BREAK`'s refusal does not bind — but it also does not scale, which is what makes it a tempo item rather than a depth one. That is the point, and it should be said out loud. |
| **2** | **Pay the swap in a DAMAGE WINDOW** — the arriving companion strikes harder for N turns. | New field + one read site in `_comp_dmg_mult`, or a status. | Tempo, and it stacks with the arrival effects the pack lane already fires. | **A fourth multiplier on companion damage**, which three of his runes and four of his nodes already push — and `_comp_dmg_mult` is the exact function §1's conversion would cap. **Priced against a moving target.** |
| **3** | **Pay the swap in LOYALTY** — the arriving companion enters holding N. | **ZERO NEW MACHINERY** — `no_beast_left_loyalty`'s read site is the exact shape; Succession is the draft-card precedent. | Makes rotation stop costing depth, which is the measured reason the bot stops swapping. | **NOT opposite to Deep Bond** — it makes turning over a way to build the meter Deep Bond deepens, and the pair collapses from the other direction. **AND §1 now makes it worse**: under a conversion, seating an arriving companion above the point hands it the converted currency for free. |
| **4** | **Remove the swap's TURN cost instead of its cooldown.** | `free_swap` exists (Instinctive Rotation, pack row 8) and `_swapped_free` is read once. **Zero new machinery.** | The measured cost of a swap is a turn, not a cooldown. | Duplicates a row-8 node outright — the charter's complaint about these three runes, restated. |
| **5** | **Keep the clause and fix the collision** — shave the FLOOR rather than the term. | One read-site change. | Only that half the rune stops being worth zero. | A repair, not a re-author, and the brief asked for a re-author. |

**KEEPING THE OPPOSITION EXPLICIT.** Deep Bond pays for *holding one companion*; the Turning Pack
must pay for *turning them over*. **Options 1, 2 and 4 are genuinely opposite — none reads the
meter. Option 3 is not, and §1's ruling makes it less opposite than it was at EQ.**

---

## §4 — THE SHARED WILD. **OPTIONS ONLY; NOTHING AUTHORED.**

### §4a — **THE EVENT IS REAL, AND ONE HALF OF IT IS NOT A MEASUREMENT AT ITS n**

| arm | rows | deaths / trash fight | n | deaths / boss fight | n |
|---|---|---|---|---|---|
| C | 0 | **0.22** | 1295 | **0.26** | 96 |
| A | 1–3 | **0.23** | 1777 | 0.39 | 170 |
| B | 1–3 | **0.22** | 1854 | 0.30 | 176 |
| D | 1–9 | 0.06 | 2360 | 0.10 | 289 |

**THE TRASH FIGURE IS ROCK STEADY** — 0.22 / 0.23 / 0.22 here, 0.22 at EP and 0.22 at EQ. **Five
independent readings, one number.**

**THE BOSS FIGURE IS NOT, AND THREE BATCHES HAVE QUOTED IT AS IF IT WERE.** At the untalented arm
it has read **0.39 (EP), 0.48 (EQ) and 0.26 (ER)** — three samples of n ≈ 95 boss fights, spread
almost two to one. **A Poisson standard error at that n is ±0.05, and the readings are 2.5σ apart,
so the per-fight distribution is over-dispersed** — deaths cluster, because the fight that kills a
companion is usually the fight that kills several. **n ≈ 95 cannot resolve this rate to better than
about ±0.1.**

- **THE BRIEF QUOTES EP's 0.39, WHICH EQ HAD ALREADY SUPERSEDED WITH 0.48, AND NEITHER
  REPRODUCES.** The figure is not wrong so much as not yet measured.
- **THE RECOMMENDATION IS TO PRICE THE RUNE AGAINST THE TRASH FIGURE AND READ THE BOSS HALF AS A
  BAND (0.26–0.48).** A boss figure that means anything needs `--run 400` or better, which is a
  measurement batch rather than a line in this one.
- **AND `docs/state.md` CARRIED 0.48 AS A FLAT FIGURE.** Corrected there to a band with its n.

### §4b — **THE CLAUSE IT OWNS, AND WHY IT CANNOT BE WORTH NOTHING**

`rune_companion_hp_pct` 0.05 is read **once**, at the summon, purely additive into `base_hp`:
`stats[0] * (1.0 + hunter.companion_hp_pct + hunter.rune_companion_hp_pct)`. **No node drives it to
a floor** and The Wild Within's +0.40 adds rather than saturates — **unlike the Turning Pack's first
clause it can never be worth zero.** Its two other clauses are the other two runes'
(`rune_wild_communion_step` 1.5 and `rune_momentum_ranks` 8).

### §4c — **THE OPTIONS, PRICED**

| # | shape | build cost | what it answers | what it costs |
|---|---|---|---|---|
| **1** | **Keep all three clauses; re-price nothing.** | **Zero.** | Nothing — but it is the only option that does not spend the splash. | The charter's complaint stands: three unrelated numbers in a bundle. |
| **2** | **Deepen the health clause alone and drop the other two.** | **Zero — a JSON edit.** | Companion durability, against a trash figure measured five times at 0.22. | **This is the splash's death** — see §4d. **And if §1 picks currency 2, this rune and the passive are answering the same question** (§4e). |
| **3** | **Pay on the DEATH rather than before it** — a share of the fallen meter survives, or the next summon is free. | `steadfast_bond` and `no_beast_left_loyalty` are both existing read sites. **Zero new machinery.** | It acts on the measured event directly rather than on the chance of it. | Duplicates two devotion/pack nodes — the charter's complaint again. **And under a conversion it writes into the meter**, so it inherits §1's open question. |
| **4** | **Heal or shield the companion in flight.** | New field + a read site; `spirit_heal` and `bloodbond_cb` are the shapes. | The same event on a different axis from The Wild Within, so rune and node stop being one idea. | Largest build of the four, **and Ancient Pact makes a companion unhealable by ANY source** — so the clause is dead for exactly the build with the deepest bond. |

### §4d — **THE SPLASH'S LOSS, PRICED AS EP ASKED**

**It is the only splash of the three** — no `lane` field, against Deep Bond's *devotion* and the
Turning Pack's *pack*. **48 of the 65 authored runes were written to the lane rule** (36 lane runes,
12 splashes), whose point was that a rune is *"worth more to a hero whose points went elsewhere."*
The charter severed that, and **the splashes lost most: with no lanes to reach across, "a little of
every bond" has nothing to reach.** Re-authoring it as one idea makes it **a lane rune wearing a
splash's name** — and the sim's own policy makes it concrete: `_pick_rune_candidate` prefers a
candidate whose `lane` matches the build's target lane, **so a splash is already the last thing the
bot reaches for.** That is a real loss and it is the designer's to weigh before taking 2, 3 or 4.

### §4e — **IF §1 PICKS COMPANION DURABILITY, THIS RUNE AND THE PASSIVE COLLIDE — AND THE BRIEF ASKS**

**They would be answering the same question, and one of them should change.** Concretely:

- The rune's clause is read **once, at the summon**, into `base_hp`. A conversion pays
  **continuously**. So they would not share a read site and would not double-count — **but they
  would share an axis**, and the rune's whole remaining claim is *"companion durability is the one
  Beastmaster number no other rune touches."* **A conversion into durability makes that false by
  construction**, and the rune becomes a smaller copy of the passive.
- **The recommendation in that branch is to take §4 option 3 or 4 instead of 2** — pay on the death
  or heal in flight — because both act on an axis the conversion does not, and both keep the rune
  distinct from a passive that now buys raw survivability.
- **And the feedback objection in §1e option 2 applies to the rune too, at a much smaller
  magnitude**: 5% of a companion's base health against a governor the whole design leans on.

---

## §5 — THE RECORD. **THIS IS THE ONLY THING THAT SHIPPED.**

**Five corrections. Four of them are copies of a claim a previous sweep had already corrected
somewhere else** — which is `CLAUDE.md`'s EH §2 rule firing three times in one batch.

### (1) and (2) — **THE TWO IN-GAME STRINGS, CORRECTED TOWARD THE CODE**

| where | was | now |
|---|---|---|
| `battle.gd:6398` — the swap picker card's own `description` | *"Shared cooldown: 2 turns."* | *"Shared cooldown: 3 turns."* |
| `battle.gd:5306` — the group-button tooltip | *"shared 2-turn cooldown"* | *"shared 3-turn cooldown"* |

**`SWAP_COOLDOWN` is 3.** Both replacements are the same width as what they replace, so the
44-character ceiling is not in the way. **Swept first: no suite or gate contains `Swap the pack`,
`Shared cooldown`, `shared 2-turn`, `shared 2cd` or `Swap the active companion`** — the two
`2-turn cooldown` hits in the suite tree are Detonation's and Chastise's.

### (3) — **THE SOURCE COMMENT ONE SCREEN ABOVE, WHICH SAID THE SAME WRONG 2**

`battle.gd:5296` read *"(10 Mana, shared 2cd)"*. Corrected, and pointed at `SWAP_COOLDOWN` so the
next reader has the constant rather than a copy of its value. **This is `CLAUDE.md`'s "A COMMENT
NAMING CODE IS A CLAIM" rule; the comment is the copy nobody greps.**

### (4) — **`master.html` CARRIED A THIRD COPY, 750 LINES BELOW THE ONE EQ CORRECTED**

EQ corrected `master.html`'s swap block at what is now line 2039 (*"shared 3-turn cooldown
(`SWAP_COOLDOWN`; Quick Whistle shaves all…")*) **and left the identical error at line 2789**, in
the keyboard/picker walkthrough: *"(10 Mana, shared 2-turn cooldown; the active companion is greyed
out)"*. **Corrected.**

**THIS IS THE RULE FIRING ON THE BATCH THAT WROTE IT.** EQ §6(1) invoked EH §2 — *when a claim of
fact is corrected, sweep for every copy of it* — corrected two surfaces, and missed the second copy
in the very document it was correcting. **A sweep that stops at the section being edited is the
failure that rule names**, and `master.html`'s factual prose is asserted by nothing, so nothing
caught it.

### (5) — **THE UNLEASH CLAIM, WHICH LIVED IN TWO PLACES**

*"the curve it empties is what every other card of his reads"* appeared in **`master.html`'s Unleash
row AND in a `classes.gd` comment**, near-verbatim. **Unleash reads the raw stack count**
(`int(attacker.loyalty.get(ul_kind, 0))`, paid at `ul_pct * ul_stacks * attacker.attack`) **and
never calls `_bond_mult`.** Both corrected to *meter*, both carrying the fact that the read is raw,
and **the code comment carries a do-not-restore note naming the other copy** — because the same
conflation has now been written twice and would read as a natural "fix" to a later batch.

### AND TWO MORE THINGS THE SAME SWEEP TURNED UP

- **`master.html` QUOTED THE METER'S LEVEL WITH NO LOADOUT ATTACHED.** Bring It Down's row said
  *"Loyalty is uncapped and over-arrives (measured near 20), so the cap binds about where the meter
  actually sits."* **That is a rows=9 reading presented as the meter's level** — the exact thing
  `docs/state.md` warns against. **Corrected to name both loadouts**: 10.1 stacks with the rows a
  first rung-1 clear opens, 19.0 fully talented. **The sentence it supports turns out to be true
  early and false late**, and now says so.
- **THE GOVERNOR TABLE'S ADDRESSES FOR THIS METER WERE STALE BY TEN THOUSAND LINES.** `CLAUDE.md`
  cited `_on_beast_death` at *"battle.gd ~10790"* (it is **21732**) and the clamp const at
  *"~7370-7385"* (it is **13300–13345**). **Reported at EQ, corrected here.** The table's content
  was right throughout — **a citation is a claim and rots the same way a number does.**

### **WHAT WAS NOT CORRECTED, AND WHY**

- **THE KINDRED / SUCCESSION CONFUSION WAS NEVER RECORDED OUTSIDE THE BRIEF.** Swept:
  `master.html:2370` describes Kindred correctly (*"At 8 or more Loyalty the companion's arrival
  effect fires again"*), `:1558` describes Succession correctly (*"half the Loyalty of the one it
  replaces… raises, never lowers"*), and `docs/state.md` already classes the half-carry as
  Succession's. **There was nothing to sweep**, and `CLAUDE.md`'s EI §2 rule says explicitly not to
  sweep past briefs.
- **THE 21.2 IS IN THREE CLOSED REPORTS** (`EN.md`, `EO.md`, `EP.md`) **and is left there.** Those
  are history and the project's own precedent — the two closed audit HTMLs kept *"as written — it is
  the evidence of which way each disagreement pointed"* — governs. **The live records are corrected:
  `docs/state.md` is rewritten and `master.html`'s copy is fixed.**
- **`scripts/classes.gd:5305`'s `passive_desc` says the boon *"grows 20% a stack — x2 at five"*,
  which is CORRECT** and describes the curve, not a cliff. Left alone. **It is the sentence that
  looks like the wrong premise and is not.**

---

## §6 — VERIFICATION

### **THE MEASUREMENTS, WITH THEIR ARMS**

All four arms: `--run 100`, `DOD_SIM_DIFFICULTY=warden` (**rung 2**), `DOD_SIM_ROUTE=balanced`,
`DOD_SIM_SPECS=berserker,cryomancer,inquisitor,beastmaster`. **The sim's Beastmaster wears the
DEVOTION lane** (`_target_lane` returns `tree[0].lane`), so these are the steepest-curve readings
the default harness can produce at each depth. Arms A/C/D carry a per-battle probe; **arm B carries
a probe inside `_comp_dmg_mult` itself.**

**PER-BATTLE DEEPEST SINGLE BOND — every battle a Beastmaster stood in:**

| arm | rows | mean peak | sd | median | >5 | >8 | >10 | >15 | >20 | deepest | n | EQ read |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **C** | 0 | **6.64 ±0.09** | 3.23 | 6 | 61.2 ±1.3 | 25.2 ±1.2 | 11.2 ±0.8 | 1.4 ±0.3 | 0.1 ±0.1 | 22 | 1391 | 6.61 ±0.09 |
| **A** | 1–3 | **10.08 ±0.12** | 5.17 | 10 | 80.7 ±0.9 | 60.4 ±1.1 | 43.8 ±1.1 | 13.9 ±0.8 | 3.4 ±0.4 | 34 | 1947 | 10.13 ±0.11 |
| **D** | 1–9 | **18.98 ±0.17** | 8.86 | 18 | 99.6 ±0.1 | 92.4 ±0.5 | 77.6 ±0.8 | 57.3 ±1.0 | 40.8 ±1.0 | **90** | 2649 | 18.45 ±0.17 |

**Every arm reproduces EQ within its standard error, and the deepest single bond ever observed rose
from 60 to 90.** Arm B read the same meter at **10.2** (n=2030), a fourth reproduction.

**BY ENCOUNTER KIND:**

| arm | trash | elite | boss |
|---|---|---|---|
| C (rows 0) | 6.65 ±0.12 (n=621) | 6.24 ±0.12 (n=674) | **9.50 ±0.40** (n=96) |
| A (rows 1–3) | 9.76 ±0.17 (n=853) | 9.63 ±0.16 (n=924) | **14.21 ±0.49** (n=170) |
| D (rows 1–9) | 20.11 ±0.27 (n=1150) | 17.73 ±0.24 (n=1210) | 19.71 ±0.56 (n=289) |

**AND THE NUMBER NOBODY HAD TAKEN — HOW MUCH OF THE METER IS ABOVE NOMINAL AT ALL**, which is what
a conversion actually spends:

| arm | rows | share of the meter's own mass above nominal | hunter turns with a beast above nominal | converted stacks per hunter turn | per-battle share |
|---|---|---|---|---|---|
| C | 0 | **15.7%** | 18.4% of 61,215 | 0.55 | 8.9 ±0.3% |
| A | 1–3 | **32.7%** | 29.2% of 78,557 | 1.48 | 21.7 ±0.4% |
| D | 1–9 | **54.6%** | 89.2% of 61,027 | 5.38 | 47.1 ±0.3% |

**The conversion is nearly inert at the bottom of the tree and continuous at the top — the same
six-to-one asymmetry EQ found for the shapes it replaces.** The ruling changes what depth buys; it
does not change how unevenly depth arrives.

### **§6a — THE NEGATIVE CONTROLS. ALL FOUR BITE.**

Every needle was taken **out of `pin-manifest.json`** — a string the named suite demonstrably reads
— rather than chosen and hoped for, which is the EB §3 rule. **Each was BROKEN by replacement, never
by extension** (a `contains` needle that is merely extended still matches), the disarmed state was
confirmed green first, and each restore was by `cp` from a scratchpad backup and verified
**byte-identical** — never by `git checkout`.

| file edited this batch | needle | suite | disarmed | **armed** | restored |
|---|---|---|---|---|---|
| `docs/master.html` | `6c. ARCHETYPE TAGS` | `check_el` | 23 / 0 | **14 / 1** | 23 / 0 |
| `CLAUDE.md` | `THE ALLY/HERO THREAD IS CLOSED` | `check_dm` | 93 / 0 | **93 / 1** | 93 / 0 |
| `scripts/battle.gd` | `SHATTER_BOT_TURNS := 5` | `test_batch_at` | 467 / 0 | **467 / 1** | 467 / 0 |
| `scripts/classes.gd` **(comment-resident)** | `BATCH BV: TRANCHE 2, THE HUNTER NINE` | `test_batch_bv` | 864 / 0 | **837 / 1** | 864 / 0 |

**The fourth is the one that matters most for this batch**, because the `classes.gd` edit was
comment-only: it proves a comment in that file **is** an asserted surface, so "it was only a
comment" is not a reason to skip verification.

### **§6b — THE FLOOR, AND THE BATTERY**

`check_parse` — **grepped from stderr for `Parse Error`, never a tally and never the exit code** —
**clean**, and the tally read separately as a coverage ratchet: **161 checks / 0 failures** against
its `[161, 161]` band. `check_ed`: **948 of 1041 source pins verified, 0 failures.**

**Full battery green apart from two rows, and `check_de` — the count differ — reported 358 checks /
0 failures / 0 NOTICES**, meaning every count and every band held.

### **§6c — AND ONE OF THOSE TWO ROWS WAS NOT THE RED ITS BASELINE RECORDS**

`check_cm_live` read **13 / 4**, which is its band exactly and its recorded reason exactly
(*"THE ONE RED THAT IS ON PURPOSE… it is the only thing pressing the defensive bar"*): the four
FAIL lines are the defensive-bar assertions. **That one is the recorded cause.**

**`test_rune_battle` read 97 / 1, inside its `fails: [0, 1]` band — AND THE FAILURE WAS NOT THE
FLAKE THAT BAND EXISTS FOR.**

- The row's `flake.what` names **`§ pyromancer: rune_resist_pierce never fired against a resistant
  warband`**. The actual FAIL line was **`§ occultist: the Deepening Ruin grinds 0 Break damage,
  expected 5`** — a different spec, a different rune, a different assertion.
- **A TWO-ARMED CONTROL SETTLED IT: SIX OF SIX, ON BOTH TREES.** Run three times against the working
  tree and three times against a copy of **unmodified HEAD** (proved to be HEAD by diff, and proved
  *not* to be the working tree by the same diff, so the comparison could not come back vacuously
  clean). **Identical failure on all six.** So it is **deterministic, not a flake, and not this
  batch's.**
- **THE BAND HAD ADMITTED IT IN SILENCE SINCE EN.** With a deterministic red the row can never read
  0, so the floor of `[0, 1]` was unreachable and nothing could ever contradict the label. **This is
  `CLAUDE.md`'s own rule — *A KNOWN FLAKE IS A PLACE A SECOND RED CAN HIDE* — paid a second time**,
  and it is why that rule says to check the red in front of you is the cause you were told about.
- **THE RED WAS THE ASSERTION, NOT THE RUNE.** EN §1 moved the Deepening Ruin's Break clause onto a
  rune-owned field, and `battle.gd:2699` sums the pair: `ent_occ.entropy_ranks +
  ent_occ.rune_entropy_ranks`. **The suite line still read the NODE's `entropy_ranks` alone**, which
  the rune correctly stopped writing — while **its sibling one line above had been re-pointed
  through this same file's `_paid()` helper** (`u.get(field) + u.get("rune_" + field)`). One clause
  of two was carried across; the other was not.
- **RE-POINTED IN PLACE, WITH THE REASON IN THE FILE** — DC's repair-to-intent rule: the same
  question, asked against the field that now carries it. **`test_rune_battle` now reads 97 / 0 on
  three consecutive runs.**
- **AND NO NUMBER IN `baselines.json` MOVED.** `checks` stays `[97, 97]`, `fails` stays `[0, 1]` —
  which is now **the pyromancer flake's contribution alone, as it always claimed to be.** The row's
  prose gained the record; **the floor was deliberately NOT raised to 1**, because a failure floor
  above zero is a promise that a red is *known, named and deliberate*, and this one was a defect.

### **§6d — THE PREDICTED BASELINES, WRITTEN BEFORE THE RUN**

**Prediction: NOT ONE ROW IN `baselines.json` MOVES** — two-sided, with a per-edit reason, written
before `run_battery.sh` was invoked once.

**THE PREDICTION HELD.** `check_de` read **0 notices**; `check_parse` 161 against `[161, 161]`;
`harness` 22 / 166 / 8 against `[22,22] / [166,166] / [8,8]`; both red rows inside their bands. **The
only edit to `baselines.json` is one line of PROSE on the `test_rune_battle` flake note** recording
§6c — **one line changed in the whole file, no number touched, and the file re-parses with all 86
targets intact.**

**THE ONE THING THE PREDICTION DID NOT ANTICIPATE IS §6c ITSELF**, and it could not have: the
prediction was about what this batch's edits would move, and §6c is a red that was already there.
**It is stated here rather than folded in**, because a prediction that quietly absorbs whatever
turned up is the bookkeeping the DF rule exists to prevent.

---

## §7 — WHAT MOVED, AND WHAT DELIBERATELY DID NOT

| file | what |
|---|---|
| `scripts/battle.gd` | §5(1)(2)(3) — two in-game strings and one comment, 2 → 3 |
| `scripts/classes.gd` | §5(5) — the Unleash claim, comment-only, with a do-not-restore note |
| `docs/master.html` | §5(4)(5) and the loadout-less figure, and the stamp |
| `CLAUDE.md` | the ER standing rule; the governor table's stale addresses |
| `docs/changelog.html` | this batch's entry |
| `docs/design-notes.md` | the "why" |
| `docs/state.md` | rewritten |
| `docs/reports/ER.md` | this file |
| `test_rune_battle.gd` | §6c — one stale assertion re-pointed in place, with the reason in the file |
| `baselines.json` | **one line of prose** on the `test_rune_battle` flake note. **No number moved** — see §6d |

**NOT DONE, STATED SO THE BATCH IS NOT READ AS CLEAN:**

- **NO CONVERSION WAS BUILT.** No `BOND_CONVERT`, no second read site, no chip change. §1 is
  options and the currency is the designer's.
- **NO RUNE WAS TOUCHED.** Not one byte of `data/runes.json` moved. §2, §3 and §4 are options.
- **NO MAGNITUDE MOVED ANYWHERE** — no node, no constant, no `.json` value.
- **NO GATE.** A gate encodes a ruling, and the ruling here is that a conversion is *coming*, not
  what it is. **There is nothing yet whose absence a gate could assert.**
- **EQ's RUNG-1 ARM WAS NOT RE-RUN**, so the *"rung 2 kills companions three times as often"*
  premise is neither confirmed nor disturbed here.
- **NOTHING WAS MEASURED AT RUNG 3, AND NOTHING ON A NON-DEVOTION BEASTMASTER LANE.** 24 of 36
  lanes remain unmeasured; the Turning Pack's own lane is still reached only by arithmetic.
- **THE BOSS-SIDE COMPANION-DEATH RATE IS STILL NOT MEASURED** (§4a) and is reported as a band.
- **EQ's §2 LOSS TABLE IS NOT REGENERATED**, only its pricing corrected in §1c. Re-deriving all
  fourteen rows at the live step is a measurement batch.
- **`devoted_fury`, the Bloodbond registry string and the run report's vacuous shop key** are all
  still reported-and-left, exactly as EQ left them. **This batch added no repair to that list.**
- **§6c's SWEEP IS CLOSED RATHER THAN OWED, AND IT WAS RUN OVER THE POPULATION AND NOT OVER THE
  THREE NAMES.** The defect's shape is *a rune assertion reading the NODE's counter instead of the
  summed pair*, so the population is **every field in `unit.gd` that has a `rune_` twin — 50 of
  them** — and not just EN §1's three. Swept comment-stripped over `test_rune_battle.gd` for a bare
  `x.<field>` read that does not go through `_paid()`: **zero remaining.** The one repaired was the
  only one. (EN's other two clauses, `divine_presence_pct` and `pleasure_pct`, are asserted in
  `test_batch_av` and `test_batch_ax` on the **node** side, where reading the node's own counter is
  correct.)
