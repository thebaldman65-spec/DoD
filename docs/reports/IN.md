# BATCH IN — THE SEVERITY-5 BAND, AND TWO BLIND SPOTS

**On `class-merge`, from `0743d15` (IM). IMPLEMENT ONLY.** **The designer has not played since IH, and no newer file has appeared**:
`run_save.bin` is IH's 40,284 B at 14:30 on 2026-10-14 and `readout/` holds IH's one debug-touched file, both md5-identical to IM's
backup; both backed up again first (`../save-backups/IN-20261017-195752`, 19:57). **Both readings are comfortable at the honest
rate** — `CLAUDE.md` 52.7 batches and `docs/state.md` 15.7 at the mean of IJ–IN (THE TWO READINGS, below).

**What IN did.** **§1 — four bargains only Ruin ever sees**: Famine (no item this fight), Wasting (each hero loses 5% of maximum
health at the end of his turn, through the tick door — the brief's ROT, renamed: Rot is the severity-4 modifier's name), the
Hungering Dark (each enemy heals a quarter of the damage it deals) and Cruel Order (the warband first in every round of the
timeline), **all severity 5, and Ruin's gambles are dealt from 5 alone**. **At EP's sample Ruin reads 4.49, a full step above
Warden's 3.28**; Wanderer and Warden are dealt offer for offer as IM dealt them, and no severity-5 modifier reaches either.
Severity 5 pays 300 gold or a rune; Ruin's fixed encounters keep the eight of severity 3–4. **§2 — the merchant is the reward of a
rung's mildest dealt severity** (`Run.rewards_for`): Wanderer's and Warden's 112 and 78 unmoved to the option, **Ruin 76 of 1,200**.
**§3 — the bot pays the price the door charges**: all 58 list-price reads read `_eff_cost`. **§4 — the 34 superlative sites name
their pick** in every FAIL line, so all 57 of IM's census do. **§0** — §0.7's note in `docs/instrument-rules.md`, the merchant's rule
in `CLAUDE.md`. **No existing modifier's severity moved; no payout widened. No save version moved.** No dice spender moved in
`battle.gd` (no `randf`, `randf_range`, `randi_range`, `pick_random` or `shuffle` call added or removed); `run_state.gd`'s
`roll_offer` keeps its draws, its rewards read through `rewards_for`.

**VERDICT: GREEN, WITH ONE PASS CONDITION NOT MET.** **The acceptance and the pre-pass both read `check_de` 633 / 0 / 0** — 154 targets,
`check_in` 103 / 0 new, `check_gp` 459 (§3's road, traced), the two standing sanctioned reds unchanged to the character
(`check_cm_live` 13 / 5, `check_gj` 70 / 1). **Ruin reads 4.49 at EP's sample, a full step above Warden; Wanderer and Warden are
dealt offer for offer as IM dealt them; Ruin pays merchants (76 of 1,200); the bot pays the door's price; all 57 superlative sites
name their pick.** **The brief's fourth condition is NOT met on the default build: measured, the four leave Ruin's bargains
milder for the sim's bot than the severity-4 band they replaced** — a bargain fight ends at 0.911 of the party's health against
0.794, and Ruin completes 58 runs of 60 against 50 — said, not tuned (§1b, ruling 6). Every other item of the brief's §0–§5 is
built, measured, or reported against a premise that did not hold (thirteen did not, below); §6's are not done, on purpose. **One
finding of the verification was repaired before the acceptance**: control C08 found `check_in` §1g never driving a hero's blow
under the Dark (§9). **Twelve rulings are owed** (below).

## NEEDS A RULING

1. **PLAY ONE ZONE WITHOUT THE DEBUG MENU, AND SEND THE FILE** (IH's ruling 1, asked at II through IN — six batches). It prices
   Boil Over's rate, Rupture's number and clock, the vow's worth and the Cleric's Mana, and confirms Sanctity's 13. Nothing in the
   queue waits on it.
2. **RUIN's FOUR BIND ONE SIDE — AQ's RULE IS OVERTURNED FOR SEVERITY 5, AND IT IS YOURS TO CONFIRM** (premise 9). Until IN every
   modifier bound both sides, by a ruling: AQ named *"no items this fight"* — Famine, word for word — as a shape *deliberately not
   authored* (*a difficulty slider wearing a bargain's clothes*), and the glossary's modifier entry said *that symmetry is the
   whole design*. Built as briefed, and both texts now say the twenty every road deals bind both sides and Ruin's four bind one.
   **Confirm that severity 5 is the exception, or say which of the four should bind both** (Wasting and the Dark have a
   two-sided reading; Famine and Cruel Order do not).
3. **ROT IS WASTING** (premise 7). Rot is the severity-4 modifier that halves maximum health, and on Ruin both would be dealt —
   one offer could hold two cards called Rot. **Wasting** met nothing in a sweep of 1,112 names in 19 populations; the name is
   yours.
4. **RUIN's FIXED ENCOUNTERS DRAW FROM SEVERITY 3–4, NOT 5** (premise 31). The mini-boss and the bosses drew *severity 3 and up*,
   which would have put the four on them with no reward; `Run.FIXED_MODIFIER_BAND` keeps the eight they always drew. **Should
   Ruin's fixed encounters reach the severity-5 four?**
5. **CRUEL ORDER's ROUND, AND THE TRACKER** (premises 12 and 13). The game has no rounds; a round is read as one basic swing at
   the average speed (`ROUND_TICKS`), and the warband's turns come first in each. **The Hunter's class passive — always attacks
   first — keeps its opening turn**, placed before the first round. Confirm both readings, or say a round is something else.
6. **WASTING's 5% AND THE DARK's QUARTER, MEASURED** (§1b). **Neither is unsurvivable**: forced on every bargain of a Ruin run,
   Wasting takes twelve points off the party's health at a fight's end (0.952 → 0.830) and the Dark about one (→ 0.943), each
   winning more than 99.5% of its fights. **But the four as a band leave Ruin's bargains milder for the sim's bot than the
   severity-4 band they replaced** — a bargain fight ends at 0.911 of the party's health against 0.794 before, and Ruin completes
   58 runs of 60 against 50 (a second seed block: 0.917 against 0.789, 58 against 47) — **so the brief's fourth condition is not
   met on the default build**, and nothing was tuned. Whether the figures rise, and which, is yours. Famine cannot be priced by
   this bot, which drinks one potion, below 35% health.
7. **SEVERITY 5 PAYS 300 GOLD OR A RUNE** (premise 16): the steps are 40, 60 and 80, not one slope, so the row took the largest,
   80. The steps grow by 20 each, which would make the next 100 and the row 320. Which slope the table has is yours.
8. **RUIN's MERCHANT IS A THIRD CHOICE AT SEVERITY 3** (§2): Ruin's mildest severity pays 140 gold, a rune or the merchant — one
   in three each — where severity 1 on Wanderer and Warden pays its gold or the merchant, one in two. The rule *the merchant
   joins the mildest severity's rewards* gives that; *the merchant replaces one of them* would not. 76 of Ruin's 1,200 options pay
   one.
9. **THE PLAYER's SIDE STILL PRINTS THE LIST PRICE** (FOUND AT IN): the ability button and the summon picker show a card's listed
   cost, so under Warded a button reads *30 Rage* for a cast the door charges 38 — and is dark at 30–37. Through and Through
   refunds the list price. Not in the brief's 58 (each is a display or a payout, not a choice); repairing the two labels is one
   argument each.
10. **IM's CENSUS MISSED SITES OF ITS OWN SHAPE** (§4): the agents that repaired the 34 found nine more first-found or
    last-found picks whose FAIL lines name nothing, and four weaker, in the 23 gates they read. A census hit list is only the
    names it was given; **whether the rest of the battery is censused again and repaired as a batch is yours** — §0.6's own
    reasoning (*an unrelated batch re-selects them*) applies to them unchanged.
11. **NO MODIFIER HAS A CHIP** (premise 15). A bargain shows its pips, name and rule on its card and the fight opens with a line
    naming it; nothing on the battle screen says which is in force. Whether a bargain wants a chip — and HU §4's rule would want
    its own letters — is yours.
12. **§3 WAS MATERIAL, AND THREE MEASUREMENTS RAN ON THE BOT IT REPAIRED** (§3a). The bot paid less than the door charges on
    0.35% of its costed casts on the default build and about 2% untalented — mostly a Mage wearing Profligate — and §3 alone moves
    79 of IG's 180 untalented runs (48 to another outcome). **IG's Sanctity step, IL §1c's re-measure of it and IM's strike probes
    were taken on that bot**; named, not re-run. Whether IO's re-measure re-takes Sanctity's step (13) on the repaired bot is yours.

## THE BRIEF's PREMISES, CHECKED

Every claim the brief makes about the tree, read against it before anything was edited. **Thirteen do not hold as written**
(3, 7, 9, 12, 13, 15, 16, 17, 21, 24, 25, 31 and 34); the rest hold.

| | the brief's claim | what the tree says |
|---|---|---|
| 1 | §7: IM's push hash; `git ls-remote origin class-merge` against HEAD before anything runs | **Held**: `0743d15` both, read before anything ran |
| 2 | §7: IM's backup is `../save-backups/IM-20261017-105223` | **Held**; IN's is `../save-backups/IN-20261017-195752`, md5-identical to it file for file and to the live files |
| 3 | §0.4: *IJ's census found* ally *in my prose 283 times over* | **283 is IJ's count of literal facts that disagreed with the code** (in 249 player-facing strings), not of *ally*, and not in the designer's prose; *ally where the code reaches heroes only* is the largest FAMILY among them (IJ §2c). The lesson the brief draws from it holds |
| 4 | §0.7: `check_im` §3b's arms cast on bodies the gate named; C10 left both driven arms green, C10b read both | **Held** (IM §9) |
| 5 | §0.7: *beside the third note (a gate may not arrange its own subject)* | **The file numbers no notes**; that rule is GW §2's block (*a gate that writes the state its assertion is about cannot fail when the door that writes it breaks*). The new note stands directly beneath it |
| 6 | §0.8: the fallen-hero list is seven; `docs/state.md` has had it right since IL | **Held** |
| 7 | §1: *ROT — every hero loses 5% of his maximum health* | **Rot is already a modifier's name** — `rot`, severity 4, *maximum health halved* (BB §5) — and on Ruin both would be dealt (its safe band holds the old, its gambles the new): one offer could hold two cards called Rot. **Renamed WASTING** (a sweep of 1,112 names in 19 populations met nothing); ruling 3. The sentence's *his* is a pronoun the text standard does not use: *that hero* |
| 8 | §1: 8 modifiers in Ruin's safe band at a mean of 3.5; (3.5 + 2 × 5) / 3 = 4.50 | **Held** |
| 9 | §1: the four as one-sided rules (*every hero*, *every enemy*) | **Every modifier binds BOTH sides until now, and that was a ruling**: AQ named *'no items this fight'* — Famine — as a shape *deliberately not authored* (*a difficulty slider wearing a bargain's clothes*), and the glossary's modifier entry and `master.html` said so. Built as briefed; both texts now say the twenty bind both sides and Ruin's four one; ruling 2 |
| 10 | §1: *Famine — the pouch belongs to all four heroes, so no class loses its own cards* | **Held** |
| 11 | §1: *Wasting is not a strike, so no ward, no armor and no* Less Damage Taken *reaches it* | **Held** through the tick door (`take_tick_damage`), which no barrier, armor or `dmg_taken_bonus` reads. **What does read it** is what reads every tick: the recap, the save, Second Wind's, Battle Trance's and Momentum's ledgers, and two rule engines that split or pay for damage taken (the Oathkeeper's covenant, the Leech's siphon) |
| 12 | §1: *Cruel Order — every enemy acts before any hero, each round* | **The game has no rounds**: turns come up on a timeline. A round is read as `ROUND_TICKS` — one basic swing at the average speed — and in each the warband's turns come first (`_turn_before`, asked by the loop and the bar); ruling 5 |
| 13 | §1: *Cruel Order … touches no kit at all* | **The Hunter's class passive is a turn-order clause** (the Tracker: always attacks first). His opening turn, placed before the first round, keeps its place; ruling 5 |
| 14 | §1: *the magnitudes are starting values and they are measured* | Measured (§1b) |
| 15 | §1: *each modifier needs its chip* | **No modifier has a chip**: a bargain shows its pips, name and rule on its card, and the fight opens with a log line naming it. None was added; ruling 11 |
| 16 | §1: *severity 4 pays 220 gold or a rune*; extend the ladder | **Held**; the steps are 40, 60, 80 — **not one slope** (each 20 more than the last, which would give 100 and 320) — so the row takes the largest, **80: 300 gold or a rune**; ruling 7 |
| 17 | §1: pass condition 2's *IM dealt them offer for offer against a reference model* | **Held at IM; IM's model now deals the four too**: its `rest` was every modifier above the floor, so it read *0 of 400* on IN's table until re-pointed to the twenty (`check_im` §1, re-pointed) |
| 18 | §1: R091's *harsher bargains*, the severity entry, the ladder entry, `master.html`'s ladder table and dealing paragraph | Read and moved (§1's words) |
| 19 | §2: Wanderer's and Warden's merchants 112 and 78 at EP's sample (IM §1) | **Held** |
| 20 | §2: *is the merchant a row in `REWARDS` keyed by severity, or a reward kind the severity row names?* | **A reward KIND (`{"kind": "shop"}`) in the row `REWARDS` keys by severity 1** — data, keyed by severity, attached by no special case; nothing in the code named severity 1 for it. The shape the rule assumes: built (§2) |
| 21 | §2: *HW's intent was that the merchant rides the mildest bargain on offer* | **HW built severity 1 absolutely** (*an easy fight is a severity-1 bargain*) and **PRICED AND DID NOT TAKE** *it pays the mild slot at any severity up to the rung's floor* (HW's ruling 3) — the nearest precedent to this ruling, which answers that ruling |
| 22 | §3: 58 reads: 55 in the rotation (the Cryomancer's `prison.cost + lance.cost` among them) and 3 enemy-side | **Held**: 58 by IM's expression, every one repaired |
| 23 | §3: *what fraction of the sim's fights run under a modifier that scales a cost?* | Measured: Warded is the only modifier that scales one (§3) |
| 24 | §3: *EP's severity sample* among the measurements a material error would touch | **EP's sample deals offers and plays no fight** — no bot pick is in it, so it cannot carry this error |
| 25 | §3: *if an enemy's cost is never scaled by a modifier, the three are dead reads* | **They are live**: an enemy pays at `_resolve`'s one spend line through `_eff_cost`, Warded stamps the warband too, and two enemies carry priced abilities (the Chief's and the Ash Tyrant's, 30 and 20) |
| 26 | §4: 57 sites; 23 / 11 / 23; the five blind ones A2, A3, A6's layout arm, A7's, A8 | **Held** (IM §0.8's table) |
| 27 | §4: *`check_ia` was not being touched when IL's Blood Debt sentence re-selected it* | **Held** (IL recon 1) |
| 28 | §5: IM read 602 folders and 260,768 KiB; the spent prefixes 600 and 260,208 KiB | **Held** (IM §4) |
| 29 | §5: the three lanes are II's, made 2026-10-14 21:41–22:17 | **Held** |
| 30 | §6: the claims stand at 86 | **Held** |
| 31 | §6: *the table's twenty keep their grades* | **Held** — and **Ruin's fixed encounters would have reached the four**: `arm_fixed_modifier` drew from *severity 3 and up*, so severity 5 would have joined Ruin's mini-boss and bosses, which pay no reward. Held to the eight it always drew (`FIXED_MODIFIER_BAND`); ruling 4 |
| 32 | §7: twenty-four gate-source readers at IM, two routes | **Held**; twenty-five at IN (`check_in` opens the root), and no third route |
| 33 | §7: IM read 153 targets in 85 min 51 s | **Held** |
| 34 | §7: `docs/instrument-rules.md` *(§0.7's note, §2's merchant rule)* | **The merchant's rule binds what the game contains**, which by `CLAUDE.md`'s seam is `CLAUDE.md`'s; it is written there, in the shop-gate block beside HW §2's. §0.7's note is in `docs/instrument-rules.md` |
| 35 | §7: IM's two readings — 466.00 KiB (44.00 under; 5.4 and 93.4) and 352.60 KiB (27.40 under; 4.8 and 27.9) | **Held** |

## §0 — IM's RULINGS, ANSWERED

**§0.1 — PLAY ONE ZONE WITHOUT DEBUG.** Carried as ruling 1. **No file has appeared**: `readout/` holds IH's one debug-touched
file (`run-20261014-134942.jsonl`, 16,291 B) and `latest.txt`, md5-identical to IM's backup and to IN's.

**§0.2 — THE SEVERITY-5 BAND.** §1.

**§0.3 — RICHER REWARDS STAY; RUIN's MERCHANT COMES BACK.** §2. `REWARDS` still reads severity, so Ruin's bargains pay 140, 220 or
300 gold or a rune — and its mildest severity, 3, may now pay the merchant.

**§0.4 — THE POUCH's WORDS.** Confirmed; nothing changed. **One premise of the brief's own account did not hold** (premise 3): the
283 of IJ's census are literal facts that disagreed with the code, in 249 player-facing strings; *ally where the code reaches heroes
only* is the largest family among them. The four new modifier texts were read against the text standard's vocabulary before they
were written (§1c).

**§0.5 — THE 58, AND WHAT THEY WERE EVER WORTH.** §3.

**§0.6 — THE 34, AS A BATCH, THE FIVE BLIND ONES FIRST.** §4.

**§0.7 — THE FOURTEENTH NOTE.** Recorded in `docs/instrument-rules.md` — *A DRIVE IS A PROOF OF THE PREDICATE ONLY WHEN THE PREDICATE
CHOOSES WHAT IT DRIVES* (IN §0.7) — with its row in `CLAUDE.md`'s index. **The file numbers no notes** (premise 5): the rule the brief
calls *the third note* is GW §2's block (*a gate that writes the state its assertion is about cannot fail when the door that writes it
breaks*), and the new block stands directly beneath it, saying they are one family seen from two sides. It binds §4's own controls,
and they were built to it (§4).

**§0.8 — THE FALLEN-HERO LIST IS SEVEN.** Read off `docs/state.md`'s crest-pool section: three crest runes, two relics, the Cairn
event, the map's Revive Potion. Nothing changed.

## §1 — FOUR BARGAINS ONLY RUIN EVER SEES

### §1a — THE BAND, AND THE SAMPLE

**Ruin's safe slot stays 3–4 and its gambles are severity 5 alone** (`Run.DIFFICULTIES`); no other rung's bands reach 5, so a
severity-5 modifier is one Wanderer and Warden are never offered — **asserted directly over the data** (`check_in` §1a: no
modifier in either band of either rung has severity 5) **and in the sample** (§1b: 0 of their 1,200 options each). Ruin's gamble
band holds four, two drawn without replacement off the same shuffle Warden's four use; no band falls back, none can be empty, and
Ruin's two bands share nothing.

| rung | safe | gambles | arithmetic | **EP's sample** (400 offers, seed 4004, slot 7) | by severity 1 / 2 / 3 / 4 / 5 | merchant |
|---|---|---|---|---|---|---|
| Wanderer | 1–2 | 3–4 | 2.83 | **2.82** — dealt as IM dealt it, 400 of 400 | 207 / 193 / 412 / 388 / 0 | 112 |
| Warden | 1–3 | 4 | 3.29 | **3.28** — dealt as IM dealt it, 400 of 400 | 158 / 147 / 95 / 800 / 0 | 78 |
| **Ruin** | 3–4 | **5** | **4.50** | **4.49** (IM: 3.82) | 0 / 0 / 211 / 189 / 800 | **76** |

**The pass conditions.** (1) **Ruin 4.49 against Warden 3.28 — 1.21 above it, past a full step** (the arithmetic 4.50). (2)
**Wanderer and Warden did not move at all**: IM's counts to the option, and `check_in` §1b deals all 400 offers of each through a
reference model of IM's roll — the twenty, the merchant behind severity 1's gold — from one seed, 400 of 400; **and no
severity-5 modifier reaches either**, asserted over the data and the sample. (3) **No band falls back and none is empty**. (4) —
§1b, below.

**THE REWARD ROW** (premise 16): the gold reads 40 → 80 → 140 → 220, **steps of 40, 60 and 80 — not one slope** (each 20 more than
the last; continued, the next would be 100 and the row 320). **By the brief's rule the row takes the largest existing step, 80:
severity 5 pays 300 gold or a rune**, the kinds severity 4 pays (`check_in` §1c derives the figure from the table's own steps;
ruling 7).

**AND RUIN's FIXED ENCOUNTERS KEEP THE EIGHT THEY DREW** (premise 31): `arm_fixed_modifier` drew from *severity 3 and up*, so the
four would have joined Ruin's mini-boss and bosses — modifiers priced with a 300-gold reward on a node that pays none. The band is
stated now (`Run.FIXED_MODIFIER_BAND`, 3–4), and the same eight are drawn in the same order off the same die (`check_in` §1d: 400
draws, the eight, no severity 5). Ruling 4.

### §1b — WHAT THE FOUR DO TO A FIGHT, MEASURED

**How it was measured** — the brief's three figures, Warden against Ruin, before and after. The sim's bot over IG's
population (the Hierophant beside the default lineages, three parties), 20 runs a party an arm, **every run seeded from its
index** (IL's formula), so two arms on one seed block play the same draws until their code parts. **§1 was built alone onto
HEAD** (`battle.gd` and `run_state.gd` with §1's hunks only — with §2's and §3's they rebuild the tree byte for byte), so
*before* is HEAD and *after* is §1 and nothing else. A bargain fight is the elite's or the mini-boss's. Warden is seed block 11,
Ruin block 21, and a second Ruin block (23) repeats the pair.

**What the sim measures of a rung is its gamble band**: the bot takes the gamble — 96% of Warden's bargain fights and 98.5% of
Ruin's after §1 were fought under one.

| default build | Warden | Ruin before (HEAD) | **Ruin after (§1)** | Ruin, block 23: before → after |
|---|---|---|---|---|
| runs completed | 60 of 60 | 50 of 60 | **58 of 60** | 47 → 58 of 60 |
| a bargain fight's length (hero turns a hero) | 4.99 | 5.91 | **6.82** | 5.94 → 6.57 |
| party health at a bargain fight's end | 0.844 | 0.794 | **0.911** | 0.789 → 0.917 |
| heroes down, a bargain fight | 0.016 | 0.095 | **0.030** | 0.103 → 0.029 |

| untalented (`DOD_SIM_TIERS=0`) | Warden | Ruin before | **Ruin after** |
|---|---|---|---|
| runs completed | 1 of 60 | 0 of 60 | **0 of 60** |
| bargain fights won | 86.9% | 71.1% | **73.8%** |
| a bargain fight's length | 6.80 | 6.51 | **7.68** |
| party health at its end | 0.597 | 0.366 | **0.448** |
| heroes down | 0.891 | 1.876 | **1.516** |

**CONDITION (4) IS NOT MET ON THE DEFAULT BUILD, AND IT IS SAID RATHER THAN TUNED.** After §1 Ruin's bargain fight is longer
than Warden's and completes no more often, but **it ends with the party healthier than Warden's — 0.911 against 0.844** — and
**against Ruin before §1 it is easier on every figure but length, on both seed blocks** (health 0.794 → 0.911 and 0.789 → 0.917;
runs 50 → 58 and 47 → 58). Untalented, Ruin stays harder than Warden on every figure, and still eased against itself (health
0.366 → 0.448, heroes down 1.88 → 1.52). **The cause is the band, read off the bot's own fights**: before §1 Ruin's gambles were
the severity-4 four, and the bot fought Bloodless (0.667 at a fight's end) and Mirrorbound (0.698) half the time; the four new
ones cost it less — Wasting 0.807 at an elite, Cruel Order 0.932, Famine 0.941, the Dark 0.952. **So by the sim's figures the
four, at their starting values, are milder for this bot than the band they replaced**: a full step up the dealt mean did not
carry into the fight. Ruling 6.

**EACH OF THE FOUR, FORCED** — every bargain of a Ruin run carries it, one seed block, §1's code; *none* keeps the fixed modifier
off those two nodes too, and the severity-4 Rot is forced the same way for scale (its health is a share of its halved maximum):

| forced on every bargain | runs completed | length | health at a fight's end | heroes down | bargain fights won |
|---|---|---|---|---|---|
| none | 58 of 60 | 6.58 | 0.952 | 0.009 | 100% |
| **Famine** | 59 | 6.66 | 0.952 | 0.006 | 100% |
| **Wasting** (5%) | 56 | 6.65 | **0.830** | 0.040 | 99.6% |
| **the Hungering Dark** (a quarter) | 58 | 6.66 | 0.943 | 0.027 | 99.9% |
| **Cruel Order** | **52** | 6.57 | 0.932 | 0.038 | 99.7% |
| Rot (severity 4) | 49 | 4.52 | 0.906 | 0.053 | 99.7% |

**None is unsurvivable** — each wins more than 99.5% of the bargain fights it rides. **Wasting is the hardest by the party's
health** (twelve points off a fight's end), **Cruel Order by runs completed** (six fewer of 60), the Dark costs about one point,
and **Famine reads as nothing because this bot barely uses the pouch**: it drinks only a Health Potion, only below 35% health, at
a flat 40 (FOUND AT IN), so sealing the pouch takes almost nothing from it. **The instrument cannot price Famine for a player,
and says so.** And **the severity-4 Rot, forced the same way, costs more runs than any of the four**.

### §1c — THE FOUR, BUILT

| modifier | its door | what reaches it, and what does not |
|---|---|---|
| **Famine** | `battle._pouch_sealed()`, asked by the Items button (dark, its hover the modifier's own words), the picker, `_use_item` and the bot's drink | Every route into the pouch in a fight. The map's pouch is untouched: the modifier binds the battle |
| **Wasting** | `battle._wasting_tick(u)`, at the four places a hero's turn ends — the turn he takes, and a turn a stun, a freeze or a Break costs him (*a lost turn still counts*, the loop's own words) | **Through the tick door** (`take_tick_damage`): no barrier, no armor, no *Less Damage Taken* — the last says *strike damage* since IM, so the player can read why. What reads every tick reads it: the recap (as *Wasting*, sourced to no one), the save, Second Wind's, Battle Trance's and Momentum's ledgers, and the covenant and the siphon. It can fell a hero. **It does not tick on the turn that won the fight** — the clock stops with the last enemy (found while measuring, and guarded before the Ruin arms ran) |
| **The Hungering Dark** | `battle._dark_feeds(victim, lost)`, at BL's one damage door, reading the dealer as Penance does | Every blow an enemy deals — strike, splash, its handler's own damage, on a hero, a companion or a charmed ally of its own — feeds it its share of the health that left, through `heal_amount`, so Bloodless, Caught Fast and Unmaking refuse it. **An enemy's damage-over-time feeds nothing**: a tick's frame names its layer and no live unit |
| **Cruel Order** | `battle._turn_before`, asked by `_next_unit` and the turn bar | **The timeline read in rounds of `ROUND_TICKS`** — one basic swing at the average speed — and in each the warband first, each side in its own order; speed still counts across rounds. The Tracker's opening turn (-0.01) stands before the first round |

**THE WORDS.** Each has its name and its one-line rule; **every figure is formatted inside `MODIFIERS`' const off its own constant**
(`WASTING_PCT`, `HUNGERING_DARK_PCT` — the table the code holds formats its figure there, IJ §2; no resolver door reads a
modifier's text). The four were read against the text standard's vocabulary before they were written: *hero*, *enemy*, no *ally*,
no *party*, and no pronoun for a hero (the brief's *his* became *that hero*); `check_in` §1i holds both. **No chip** (premise 15).
**The names were swept against the game's 1,112 names in 19 populations**: Famine and Cruel Order meet nothing; the Hungering Dark
near-misses ten (the closest an enemy move, *The Long Dark*), which ships as a named near-miss; Rot meets the severity-4 Rot
exactly — hence Wasting, which meets nothing.

**THE RUNG TEXTS, READ AGAINST THE BAND** (IM's discipline). **Moved**: the severity entry (five severities, severity 5's reward, the
merchant at the road's mildest severity, Ruin's gambles the four no other road deals); the modifier entry (the twenty bind both
sides, Ruin's four one — its *'no items this fight' is not a modifier that exists* was false the moment Famine shipped); the ladder
entry (Ruin's gambles at severity 5, its fixed encounters at 3–4); the merchant entry; `master.html`'s ladder table, its dealing
paragraph, the modifier section's *binds both parties*, the pool's count, the four rows and the reward table. **Held**: R091,
Ruin's *Harsher bargains* (4.49 now); Warden's *The guaranteed mild bargain gets less mild*; Wanderer's *No twist*; the *difficulty*
entry's *its bargains harsher*; the bargain entry.

### §1d — NONE OF THE FOUR ZEROES A CLASS's KIT

| modifier | the class it comes closest to | why it does not cross |
|---|---|---|
| **Famine** | **the Mana classes** — the Mana Potion is their refill — and a party with no Holy, whose Revive Potion is then its only way to stand a fallen hero up | The pouch belongs to all four heroes: no card, rune, engine or talent reads it (no live rune names an item; the two item relics stock the opening pouch, before any fight). Every hand is whole |
| **Wasting** | **the Mage** — the smallest health pool and no heal in his kit | It is a share of each hero's own maximum, so it costs every hero alike; every card works; the Cleric's heals, a Rage hero's sustain and a short fight answer it |
| **The Hungering Dark** | **the damage-over-time builds** — a Pyromancer's Burn, a Survivalist's poison — whose chip an enemy heals back, and **the Warrior**, whose job is to be hit | Their damage still lands whole; the enemy heals a share of what IT deals, not of what it takes, and a ward that absorbs a blow feeds nothing. Burst and mitigation answer it — the build question the brief names |
| **Cruel Order** | **the Hunter**, whose class passive is a turn-order clause; and the shields and taunts a Cleric or Warrior lays before a blow | No card changes; the Tracker's opening turn keeps its place before the first round; a shield laid this round still meets next round's blows |

## §2 — THE MERCHANT IS THE REWARD OF A RUNG's MILDEST DEALT SEVERITY

**The premise that decides the shape, checked first** (premise 20): the merchant was `{"kind": "shop"}`, a reward KIND in the row
`REWARDS` keys by severity 1 — data in the severity-keyed table, attached by no special case; nothing in the code named severity 1
for it. **So the rule's shape is buildable without a special case**, and it is built that way:

- **The table holds the merchant at no severity.** `REWARDS[1]` is its 40 gold alone.
- **`Run.mildest_dealt_severity()`** is the lowest severity of any modifier inside the rung in play's safe band or gamble band —
  read off the bands, never off the rung's name (`check_in` §2 asserts neither function names a rung; control C14, the merchant keyed
  on `"ruin"`, reds it).
- **`Run.rewards_for(sev)`** is that severity's row with `MERCHANT_REWARD` behind it where `sev` is the mildest dealt, and
  `roll_offer` reads its rewards there. **On Wanderer and Warden the mildest is 1 and the list is `[40 gold, merchant]` in IM's
  order**, so the roll picks from the same two in the same order off the same die.

| rung | mildest dealt | merchants in EP's 1,200 options (IM → IN) | in the run's first three nodes |
|---|---|---|---|
| Wanderer | 1 | **112 → 112** | 0 |
| Warden | 1 | **78 → 78** | 0 |
| Ruin | **3** | **0 → 76** | 0 |

**The pass conditions.** (1) Wanderer's and Warden's counts did not move, to the option — every one of their 800 offers is dealt as
IM dealt it (`check_in` §1b's reference model). (2) Ruin deals merchants: **76 of its 1,200 options**, all at severity 3. (3) The
merchant pays nowhere else: at each rung `rewards_for` names it at exactly one severity (`check_in` §2 walks 1–5), and the shop gate
still holds it out of the run's first three nodes at every rung (`check_in` §2, the gated sample: 0 / 0 / 0).

**A reading the rule left open, taken and said** (ruling 8): Ruin's severity 3 pays 140 gold, a rune or the merchant — one in three
each — where Wanderer's and Warden's severity 1 pays two ways. *The merchant joins the mildest severity's rewards*, as it joined
severity 1's gold at HW, gives that; replacing one of them would have been a second change. **Measured on its own** against HEAD
(IL's seeds, IG's population): at Wanderer and Warden it plays HEAD's runs byte for byte (rung 1: 60 of 60; Warden: 60 of 60); at Ruin
it moves 17 of HEAD's 60 runs, 8 to another outcome — the merchant is a third reward of Ruin's safe slot, which the bot takes in 31 of HEAD's 698 Ruin bargains — and on top of §1 it moves 2 of 60 and no outcome, the bot taking that slot in 10 of 670 (§3c).

**The rule is written in `CLAUDE.md`**, beside HW §2's in the shop-gate block — not in `docs/instrument-rules.md`, where the brief
placed it (premise 34): it binds what the game contains, which by `CLAUDE.md`'s seam is that file's.

## §3 — THE 58 LIST-PRICE READS

### §3a — WHAT THEY WERE EVER WORTH, MEASURED FIRST

**The fraction the brief asked for first: the sim's fights under a cost-scaling modifier** — Warded, the one that scales a
price (+25%) — **are 2.26% at rung 1 on IG's population (38 of 1,683; untalented 1.5–2.7% a seed block), 0.12% at Warden (2 of
1,703) and 2.01% at Ruin (33 of 1,641, 24 of them a zone boss's fixed modifier).** Small — **but Warded is not all that made the
58 reads wrong.** `_eff_cost` prices a card off its list for more than the ward — a free summon, Snap Shot, Twin Hunt, the
upgraded Execute, Lone Hunter, and **Profligate's doubled Mana (a Mage's rune since HF)** — and over the same runs **48% of the
bot's costed casts on the default build were priced off their list (7–8% untalented)**. Where the door's price is cheaper, a
list-price test can refuse a card the door would let him pay; **where it is dearer, the defect the brief named** — the bot cast a
card its resource no longer paid for, and the spend line took what it held. **That was 0.35% of its costed casts on the default
build (99 of 28,516), about 2% untalented (529–594 a seed block), 0.29% at Warden and 0.87% at Ruin** — mostly a Mage wearing
Profligate. **So the share is not near zero, and the measurements it touched are named, not re-run** (the brief):

- **IG's Sanctity step, and IL §1c's re-measure of it** — IG's population exactly (rung 1, the Hierophant, the default build 20 runs
  a party and untalented 60), where §3 moves 55 of the 60 default runs and 79 of the 180 untalented (§3c). **Affected**: the step,
  13, was read off a bot paying less than the door charges on about 2% of its costed casts untalented. Ruling 12.
- **IM's strike probes** (IM §2, *what they visibly do not touch*): rung 1, every lineage rotated, unseeded — a Mage wearing
  Profligate is in it. **Affected the same way**, and less than the spread between its own two readings.
- **EP's severity sample, IL §2's and IM §1's: not affected** — each deals offers and plays no fight (premise 9).

**The enemy-side three are live, not dormant** (§3b): Warded stamps the warband, and the Ash Tyrant — the Scarlands' zone boss —
carries priced abilities (30 and 20), as does the Chief, an elite. At Ruin Warded is one of the eight fixed modifiers, and on
HEAD's Ruin runs it stood on 24 zone-boss fights in 60 runs.

### §3b — THE REPAIR

**All 58 read the effective price** (`_eff_cost`): the rotation's 55 arms `u.resource >= _eff_cost(u, X)` — the Cryomancer's
prison-and-lance pair `_eff_cost(u, prison) + _eff_cost(u, lance)` — and the enemy's three (`_intent_ability_usable`,
`_choose_enemy_action`, `_psychotic_support`). **No arm needed the body**: `_eff_cost`'s one body-dependent price is the upgraded
Execute against a Broken target, which is not a rotation arm (IM §3a aims it through the pick pool, which already prices each body).
**The enemy-side three are live, not dormant** (premise 25): an enemy pays at `_resolve`'s one spend line through `_eff_cost`, the
ward stamps the warband, and the Chief and the Ash Tyrant carry priced abilities (30 and 20) — so under Warded those two could
declare and swing a move the price no longer allowed, and paid it down to nothing. **Driven** (`check_in` §3): under Warded, every
lineage's whole pick at every resource level from empty to full in steps of two — **612 picks, every one payable** (C17, HEAD's 55
reads put back, reds it); an enemy holding 30 for a 30-cost move cannot use it warded and can unwarded.

**A broader sweep found three more list-price reads, on the player's side** (FOUND AT IN, ruling 9): the ability button and the
summon picker print `ab.cost`, and Through and Through refunds it. None is a choice — two displays and a payout — so none is in the
58, and none was repaired.

### §3c — WHAT THE REPAIR MOVED, ON ITS OWN

**§3 alone against HEAD, on IG's population and seeds** (HEAD's `battle.gd` with the 58 hunks only):

| arm | runs identical in every battle line | runs moved | outcomes moved | runs completed (HEAD → §3) |
|---|---|---|---|---|
| rung 1, default build (60 runs) | 5 | **55** | 0 | 60 → 60 |
| rung 1, untalented (180 runs, three seed blocks) | 101 | **79** | **48** | 75 → 70 |
| Warden, default (60) | 2 | 58 | 0 | 60 → 60 |
| Ruin, on top of §1 and §2 (60) | 0 | 60 | 8 | 58 → 54 |

**The bot now pays below the door's price on no cast** (0 of 29,388 at rung 1, and none at Warden or Ruin). Untalented, the
outcomes moved both ways and net five runs fewer of 180 — inside that arm's noise; on the default build no outcome moved at rung 1
or at Warden.

**DO ANY TWO INTERACT.** At rung 1 and at Warden **§1 alone and §2 alone play HEAD's runs byte for byte** (60 of 60 each: neither
rung's bands reach 5, and their mildest severity is 1, so the merchant sits where it sat), and the full code is §3 alone there
(rung 1: 60 of 60 identical to §3 alone, default and untalented). **At Ruin they interact.** §2 alone moves 17 of HEAD's 60 runs,
8 to another outcome — the merchant is a third reward of Ruin's severity 3, its safe slot's, and the bot takes the safe slot in 31
of HEAD's 698 Ruin bargains — while on top of §1 it moves 2 runs and no outcome, because §1 leaves the bot taking the safe slot in
10 of 670. §3 on top of both moves all 60 (8 outcomes; completed 58 → 54).

## §4 — THE 34 GATES THAT DID NOT NAME THEIR PICK

**THE FIVE BLIND ONES FIRST**, by hand, and their FAIL lines read before the rest were taken (§9's controls D1–D4 and the forced
arms): **A2** `check_ia` §3d — the Mage's eight longest shown ordinary runes beside his six core runes, *with the length the eighth
won its place by* (`cap_pick`, in all four lines); **A3** `check_ia` §6 — the widest three core-rune titles and their width
(`widest`, all four); **A6's layout arm** `check_gt` §1's bag of twenty — the runes worn, held and in the bag, in the label every
line of that loop carries; **A7** `check_gt` §2 — each deal named by its four runes (`dl`, twelve lines); **A8** `check_ib` §4 — the
Cleric's longest ordinary runes, worn and held, with the length range (`longest_pick`, both lines). A5, in `check_gt` §1 beside
A6, was taken with them.

**THEN THE OTHER 28**, in four groups by gate file, so no two hands touched one file: the 20 that named none and the 8 that named
some. **Every site builds one string right after its pick — the subject's name and the measure or order it won by — and appends it
to every FAIL line about the pick.** No condition, control flow, printed line or order of computation moved; nothing is rolled
again to name a roll's pick. The strings read only values the gate already holds.

**THE COUNT DID NOT MOVE.** Every one of the 34 gates was re-run alone on the final tree and read at its baseline row, to the check
(§9 lists each reading). Before and after, each file holds the same number of `ok()` calls; the one gate whose shape changed —
`check_ih`, which gained a member list to carry `_walk_field`'s pick to the one verdict that reads it — moved no count.

**THE CONTROLS, AND HOW THEY WERE GROUPED** (§0.7's note applies to them). **Each of the 34 was made to fail ON THE SUBJECT IT
PICKED**: in a fresh clone, every FAIL line IN §4 gave a pick string had its verdict forced false AFTER its condition was evaluated
(`ok((COND) and false, MSG)`), so the arm still chose its own subject, still computed everything it computes, and printed the line it
would print for that subject. **Grouped one clone a gate file — 23 clones for 34 sites — and the grouping is safe**: forcing a
verdict changes no state and no flow (`ok()` returns nothing a gate reads), so two forced arms in one gate cannot reach each other.
**And for the five blind sites, a real defect each gate met on its own pick**: the rune panel's Close inside its scroller (D1 —
A2, A6), the card's Runes count reworded (D2 — A3), the Peddler's offers overlapping (D3 — A7), the rune panel's scroll bar hidden
(D4 — A8). **Every FAIL line read names the subject the gate picked** (§9).

**THE CENSUS AGAIN AT THE CLOSE: 57 sites, 57 name their pick in every FAIL line about it** — IM's 23 untouched, IN's 34 repaired.
`check_in` §4 holds the 34 (each site builds its string and reads it again).

**AND THE CENSUS's OWN POPULATION WAS SHORT** (ruling 10). Reading the gates around the 34, IN found nine more sites of the shape
IM's census did not list — each a first- or last-found pick whose FAIL lines name nothing:

| gate and section | the pick | its unnamed FAIL lines |
|---|---|---|
| `check_fe` §2c | `head = offer[0]` and its upgrade | *repair was not WRITTEN BACK*, *a second call repaired again*, *names the same upgrade twice* |
| `check_fe` §2c (3) | `live[0]` | arm (3)'s lines |
| `check_fh` §4 | the seeded draft hand's first card, and the last carried card benched to make room (they feed B9's tag) | B9's lines name the tag, not these |
| `check_fh` §5 | the first button matching *Health* and *Sell +* | the shop presses' lines |
| `check_fh` §7 | `ss` and `warden`, the LAST-found holders; `other`, the first hero not the Warden | *a hero with no defensive passive qualifies to brace* |
| `check_ie` §5a | `owned3`, the first three owned cards, stored as the boss's offer; `taken[0]`, the first non-spare upgrade | the refill's premise lines |
| `check_gx` §5 | `_gated[0]`'s sit-out note | *has lost the line*, *does not open with GT's clause*, *carries the card's own nouns* |
| `check_hk` §1h, §3e | `held_engines(mage)[0]`, the Mage's first engine as the deal rolled it | five lines in §3e |
| `check_hk` §2e | `worn_before[0]` | *the swap did not put a held rune on…* |

**Four more are weaker** — `check_ft` §2f's slot 0 (the basic, by design), `check_gx` §4b's first two of the Mage's six slotted,
`check_gf`'s walk to the nearest reachable node, `check_hk`'s `_most_held` (it names the count, not the hero) — and are listed so
the next census reads them.

They were not repaired: the brief's specification is IM's census, and a census hit list is only the names it was given — these
were found only in the 23 gate files IN read, so the rest of the battery is unread for them.

## §5 — HOUSEKEEPING

**THE MOVE IS NOT ATTEMPTED** (IB §4). **Read during IN's measurements: 602 folders, 259,152 KiB** (IM's close: 602, 260,768);
**at IN's close 602 folders, 258,872 KiB**. **IN made no folder — the seventh batch running.** It reused seven: II's three
(made at II on 2026-10-14, 21:41–22:17) — *II K* (HEAD's clone, the HEAD-side traces, lane m1), *II R* (lane m2, recon 2) and
*II S* (lane m3) — and four of IB's (made 2026-10-12): *IB recon* (recon 1, C08b), *IB work* (the pre-pass), *IB ctlA* and *IB ctlB*
(the two control streams). **What it costs, said again**: a reused folder is never clean, and Godot keeps each folder's last five
process logs in its `logs/`, which is where a reused folder's size moves; the sims write no save and no profile. **The spent
prefixes** — every *Dawn of Decay* copy from FX to IN, the seven above among them, and the five *DoD …* copies — are **600
folders, 258,312 KiB** at the close. **ONE command clears them**, leaving the live *Dawn of Decay* folder and `[unnamed project]`
— IM's command, whose second pattern already covers IN's seven:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IN)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-J]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IN)/"
```

Each pattern was listed before it was written here — 470, 125 and 5 folders — and none reaches the live folder. **IB's caution,
kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the paste
first. **And clearing *II K/S/R* and *IB …* ends the reuse**: the next batch makes its lanes again.

**THE LIVE FOLDER's `readout/`**, read and not changed: `latest.txt` (40 B) and `run-20261014-134942.jsonl` (16,291 B, IH's one
file), backed up with the four player files, md5-identical to the backup before and after the acceptance, and again at the close. **No newer file.**

## §6 — WHAT IS DELIBERATELY NOT DONE

- **`master.html`'s SWEEP, `docs/state.md`'s CLOSED-BLOCK CENSUS AND THE RE-MEASURE ARE IO's, ONE BATCH.** The two readings
  (below) say whether the room holds.
- **THE CLAIMS STAND AT 86.**
- **NO EXISTING MODIFIER's SEVERITY MOVED**: the twenty keep their grades (`check_in` §1a asserts each). **Only four rows were
  added.**
- **NO PAYOUT WIDENED**, the `st/b` tally stays renamed and unsplit, and **no severity-5 modifier zeroes a class's kit** — each
  against the class it comes closest to, §1d.
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; Boil Over, the vow, the recoil floor and
  Anointing untouched; the third slot ungated; Rupture's number and clock wait on a clean file; the art is not commissioned; a
  copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire's re-cut unbuilt and
  `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the Occultist's Break card; the Skirmisher and the
  Tracker with Volley and Ambusher owed their slots and names; Channel's tempo payout; the fallen-hero ruling, whose seven things
  `docs/state.md` names; Tithe's read site and its talent rebalance; the block index.

## FOUND AT IN AND NOT FIXED

- **THE PLAYER IS SHOWN THE LIST PRICE**: `battle._ability_popup_button` and `_open_summon_picker` print `ab.cost`, where the door
  charges `_eff_cost` — under Warded a button reads *30 Rage* for a cast the door charges 38, and is dark at 30–37; Through and
  Through refunds `ab.cost`. Outside the brief's 58 (displays and a payout, not a choice); ruling 9.
- **THE SIM MEASURES A RUNG's GAMBLE BAND, NOT ITS OFFER**: the bot takes the gamble in 96% of Warden's bargain fights and 98.5% of
  Ruin's (§1b), so a modifier in a safe slot is nearly invisible to every sim figure — a fact about the instrument, said so the next
  measurement of a band reads it.
- **THE BOT's HEALTH POTION HEALS A FLAT 40** (`_player_turn`'s drink, `heal_amount(40, true)`, and only below 35% health), where the
  player's heals `Run.HEALTH_POTION_PCT` of maximum (CT §6) — the bot plays another potion, and it is why Famine reads as nothing.
- **THE `enemies_alive_r3` SAMPLE NEVER SAMPLES ROUND THREE**: it fires at `next_time >= 200`, written for 100 ticks a round, and a
  swing at the average speed moves a unit 2 ticks (`BASIC_DELAY`), so it reads the fight's end state nearly always.
- **`run_sim._take_offer`'s COMMENT SAYS THE SAFE SLOT IS ALWAYS A 1 OR A 2**: false on Warden (1–3) since BM and on Ruin (3–4)
  since IM.
- **IM PUT ITS ARCHIVE CUT AT THE FOOT** of `DoD-archive/state-archive.md`, against that file's *newest cut first*; IN's cut is at
  the top and IM's stands beneath it, moved whole (every line accounted for; IM's cut byte-identical).
- **IM's CENSUS MISSED SITES OF ITS OWN SHAPE** (§4) — ruling 10.
- **`check_fh` §7's COMMENT SAYS THE FALLBACK PICKS *the card's own spec owner***; the code takes the first non-companion hero.

## THE TWO READINGS

**`CLAUDE.md` is 478,835 B = 467.61 KiB against its 510 KiB ceiling — 42.39 KiB under** (+1,654 B at IN; IM 466.00 KiB): 5.2
batches at EZ's record (8,293 B), **52.7 at the mean of IJ–IN** (824 B). **`docs/state.md` is 362,542 B = 354.04 KiB against its
380 KiB ceiling — 25.96 KiB under** (+1,476 B at IN, its own reading included; IM 352.60 KiB): 4.5 batches at IA's +5,860 B, the worst
case; the honest rate is IJ +3,355, IK +2,111, IL +5,587, IM −4,046, IN +1,476 — a mean of 1,697 B, **15.7 batches at it**. **Both
are comfortable at the honest rate** (above eight). `docs/state.md`'s reading is a fixed point: the file's size is inside its own
line, so the figures were filled and the file re-measured until they agreed.

## §9 — THE VERIFICATION

**THE PUSH CHECK AND THE BACKUP, FIRST.** `git ls-remote origin class-merge` read `0743d15`, IM's HEAD and local HEAD, before
anything ran; the four player files and `readout/` were backed up to `../save-backups/IN-20261017-195752` (md5-identical file for
file to IM's backup and to the live files) before the first edit. A clone of the untouched tree was kept as HEAD's for the
variants, the traces and recon 1.

**§0.8's CENSUS, READ AGAINST IN's DIFF BEFORE THE FIRST PREDICTION.** Each of the 57 sites' populations was read against what IN
moves — four modifier rows and their texts, `REWARDS`, two bands, the fixed band, the bot's 58 reads, the four doors, the offer
card's pips, four glossary entries. **None ranks what IN moved**: no text-ranked site reads a modifier's words (`check_ih` §6 walks
every bargain card whole, not a pick), no data-ranked site reads the bands or `REWARDS`, and the one roll-order site on a bargain
(`check_gf` §3, rolled at Warden) is dealt the same option from the same dice. **Prediction: no site re-selects** — and none
did: every one of the 34 read its row alone on the final tree, and both recons left every site's gate at its row.

**THE LITERAL SWEEPS RAN BEFORE EACH PREDICTION** (both quote styles, every length, and every literal a gate reads with
`.count(`). **Over the code and data** (before recon 1): 3 lost — `check_in`'s two absence needles for *no items this fight* (the
modifier entry's old sentence) and `test_batch_bb`'s *There are twenty*, re-pointed — 56 gained (each `check_in`'s, or a common
word another gate holds for another file), three short flips in `offer_screen.gd` (` / `, `top`, `3.0` — no gate reads that
file for them) and 28 counts moved. **Over the documents** (before recon 2): 19 lost — sixteen in `docs/state.md`'s rewritten
WHERE block and archived rulings, none held by a gate that opens it (`check_es`, `check_fg`, `check_hp`, `check_hx` hold none of
them), and the glossary's three above — and 104 gained. **The 64 counts that moved are counts over a gate's own slice** — a
statement's brackets (`check_dj`, `check_ec`, `check_em`), a log's lines (`check_if`), a line's stops (`check_id`), a pool array
(`check_ct`), a body's `func` heads (`test_batch_ax`) — **never a whole document**, and HEAD's gates read all of them green on IN's
code in recon 1. The regenerated manifest's residency matches HEAD's — the same eleven unresolved needles, none new.

**`check_hf`, WHICH HOLDS THE DESIGNER's WORDS, WAS READ AGAINST §1's TEXTS BEFORE THE RECONS**: it holds none of the four new
modifier texts, nor the severity, modifier, ladder or merchant entries IN rewrote, and read its row on recon 1's tree.

**THE THREE MEASURED CHANGES, EACH AGAINST THE UNCHANGED TREE.** `tools/variants_in.py` splits `battle.gd`'s diff into §1's hunks
(19) and §3's (58, one line each) and asserts the two rebuild the tree byte for byte; `run_state.gd`'s §1 and §2 are built by
explicit edits onto HEAD's, and the two together deal exactly as the tree's. So *§1 alone*, *§2 alone* and *§3 alone* are each
HEAD plus one change, on IG's population and IL's seeds — §1b, §2 and §3c carry the readings and the interactions.

**RECON 1 — HEAD's BATTERY ON IN's CODE AND DATA** (HEAD's runner, gates, documents, baselines and manifest; `check_in` not in
it), the prediction written at 20:57 and launched at 20:57:42: **153 targets, 20:57:42 to 22:29:02 — 91 min 20 s**. As predicted:
`check_im` 122 / 7, `check_il` 86 / 3, `check_hw` 65 / 2, `test_batch_an` 3,948 / 2 and one SCRIPT ERROR (`by_sev[5]`),
`test_batch_bb` 164 / 1 and one SCRIPT ERROR; the two standing sanctioned reds to the character (`check_cm_live` 13 / 5,
`check_gj` 70 / 1); the run harness 22 / 382 / 8; `check_parse` 229 / 0. **Four readings the prediction did not carry, each read**:
- **`check_hy` 185 / 1** — §6's damage census: `_wasting_tick` deals damage and HEAD's census has no row for it. Missed by the
  prediction; the tree's `check_hy` carries the row (*BORROWS*, IN §1).
- **`check_ij` 50 / 1, predicted 49 / 1** — the one extra check is the red itself: §2e's arm adds a check for each repaired clause
  that is gone (traced: HEAD's gate on HEAD's code 49, on IN's code 50 with *a repaired clause is gone … severity:long*). The
  tree's re-pointed `check_ij` reads 49 / 0.
- **`check_ed` 18 / 0, predicted 18 / 1** — the prediction expected HEAD's manifest to miss *There are twenty* in the glossary;
  the manifest pins it, and `check_ed` resolves source needles only, so the data needle's absence reds nothing there.
- **`check_gp` 459 / 0, recorded 444 — a notice, unpredicted** (the prediction named its road as uncertain). **Traced** — three
  copies of HEAD's gate with every `ok()` printed: HEAD's code 444, HEAD with §3 alone **459**, HEAD with §1 and §2 alone 444; all
  fifteen are §4's per-card arm, the no-engine road showing the party 80 distinct cards where it showed 65 — none engine-reading.
  **§3's**: the bot now prices a cast off the door, so the road's fights play differently. The row moved 444 → 459.
`check_de` 629 / 11 and two notices — every red one of the above.

**RECON 2 — THE COMPLETE TREE, A FRESH CLONE** (IN's runner, 154 targets, everything IN's), the prediction written at
22:53, before anything of it ran, and launched at 22:53:34: **154 targets, 22:53:34 to 00:16:37 — 83 min 3 s. Every target at its row, as predicted**: `check_in` 103 / 0,
`check_gp` 459 / 0, `check_parse` 230 / 0, the seven re-pointed at theirs, `check_ed` 18 / 0, `check_gw` 76 / 0 (*96 sites in 10
targets (ceiling 96)*), the two standing sanctioned reds to the character, the harness 22 / 382 / 8 — **`check_de` 633 / 0 / 0**.
Against IM's acceptance, target by target, four rows moved and no other: `check_in` new, `check_parse` 229 → 230, `check_gp`
444 → 459, `check_de` 629 → 633; `test_batch_an` 6,057 and `test_batch_bk` 130 read inside their bands (an unseeded map, an
unseeded counter; IM's acceptance read 6,056 and 131). **The sanctioned reds' FAIL lines are HEAD's to the character**: HEAD's
`check_cm_live` and `check_gj`, run on HEAD's code beside it, print the same lines (*the card says +168 gold and the purse moved
188*, and `check_cm_live`'s five).

**EVERY MOVED COUNT, ATTRIBUTED.** `check_in` is new (103). `check_parse` 229 → 230: one target more, and `check_in` is it.
`check_de` 629 → 633: four checks a target, one target more. `check_gp` 444 → 459: §3's road, traced above. **Every other count
is unmoved** — the seven re-pointed gates' included (`check_im` 122, `check_il` 86, `check_hw` 65, `check_ij` 49, `check_hy` 185,
`test_batch_an` inside its band, `test_batch_bb` 167): each re-pointed arm replaced the arm it repaired one for one, and H01 reads
each red on HEAD's code by exactly what it re-pointed. **The 34 §4 sites moved no count** — each of the 23 gate files holds the
same number of `ok()` calls as at HEAD, and each read its row alone on the final tree:

| gate | read alone | | gate | read alone | | gate | read alone |
|---|---|---|---|---|---|---|---|
| `check_ia` | 83 / 0 | | `check_ew` | 38 / 0 | | `check_ho` | 176 / 0 |
| `check_gt` | 6,816 / 0 | | `check_fe` | 79 / 0 | | `check_hz` | 107 / 0 |
| `check_ib` | 119 / 0 | | `check_fh` | 167 / 0 | | `check_id` | 213 / 0 |
| `check_ih` | 94 / 0 | | `check_ft` | 147 / 0 | | `check_ie` | 70 / 0 |
| `check_hu` | 105 / 0 | | `check_gf` | 104 / 0 | | `test_batch_ai` | 228 / 0 |
| `check_fn` | 83 / 0 | | `check_gx` | 1,355 / 0 | | `test_batch_bk` | 129 / 0 (band 129–131) |
| `check_ds` | 57 / 0 | | `check_hk` | 168 / 0 | | `test_batch_bs` | 246 / 0 |
| `check_eh` | 310 / 0 | | `check_hl` | 169 / 0 | | | |

**THE GATE-SOURCE READERS, OVER `check_in`'s FINAL SOURCE — TWENTY-FIVE, BY THE TWO ROUTES, AND NO THIRD.** `check_ij` §0.4
derives them: the twenty-four that open the root (`check_in` among them) and the three that read the battery's list (`check_gw`,
`check_ij`, `check_parse`). **A third route was looked for and is not there** (IM's reading, re-run: the variable-path walkers open
`res://scripts`, `res://data` or a readout folder; `check_ed` and `check_fr` read the manifest, regenerated; the gates that load
another gate by its own path read a named file). **Read after the last edit to `check_in` (C08's arm)**, with the document gates
`check_fg`, `check_fr`, `test_batch_bx`, `test_batch_ce`, `check_dv`, `check_hy` and `test_batch_an`: **all thirty-two read 0 failures, with no parse or script error** — `check_in` 103 / 0, `check_parse` 230 / 0, `check_ij` 49 / 0,
`check_ed` 18 / 0 and `check_gw` 76 / 0 with §2's *96 sites in 10 targets (ceiling 96)* unmoved (`check_in` hand-sets nothing
`check_gw` counts), the document gates at their rows (`check_hx` 39, `check_fg` 30, `check_fr` 25, `test_batch_bx` 163,
`test_batch_ce` 931, `check_dv` 84, `check_hy` 185), `test_batch_an` 6,051 inside its band.

**THE CONTROLS — twenty on what IN built, two re-tunes, two HEAD arms, four real defects and the 23 forced clones of §4**, each a
fresh clone of the tree with one change and the gates it aims at (`tools/controls_in.py`, every anchor count-asserted before it
is written), each read by its FAIL text. **§0.7's note binds them**: every C control breaks what the gate's own predicate chooses
— the band the sample deals, the door the drive goes through — never a body the gate named.

| | the defect | what reds |
|---|---|---|
| C00 | the clean clone | `check_in` 102 / 0 (before C08's arm; recon 2's clone reads the final 103 / 0) |
| C01 | Ruin's gambles back at 4 | `check_in` 102 / 5 — §1a the bands and their overlap, §1b *3.82 … not a full step*, §1i both entries; `check_im` 122 / 4 — Wanderer's and Warden's floor split and offers; `check_il` 86 / 2 — the band below the table's top, the mean |
| C02 | Warden's gambles reach 5 | `check_in` 102 / 4 — *warden's bands reach a severity-5 modifier*, *381 severity-5 options*, *0 of 400 dealt as IM dealt them*, Ruin no longer a step above; `check_im` 122 / 3; `test_batch_bn` 80 / 1 |
| C03 | severity 5 pays 320 | `check_in` 102 / 2 — §1c *the ladder's steps are [40, 60, 80], the largest 80, so 300*; §1i the entry |
| C04 | the fixed band reaches 5 | `check_in` 102 / 2 — §1d *400 fixed draws … a fixed encounter drew a severity-5 modifier* |
| C05 | `_use_item` does not ask the pouch | `check_in` 102 / 2 — §1e *under Famine `_use_item` spent a Health Potion (2 → 1)*, the source |
| C06 | Wasting as a strike (`take_hit`) | `check_in` 102 / 3 — §1f *lost 0 — want 50*, *ate into the barrier*, the tick door |
| C07 | no tick where a Broken turn ends | `check_in` 102 / 1 — §1f *calls the tick 3 times, want 4* |
| C08 / C08b | the Dark feeds a hero dealer too | **C08: `check_in` 102 / 0 — the finding of this pass, below**; **C08b, once §1g drove a hero's blow: 103 / 1** — *Warden dealt 200 to an enemy under the Dark and was fed 50* |
| C09 | the Dark heals around the heal door | `check_in` 102 / 2 — §1g *a Caught Fast enemy was fed 50*, the source |
| C10 | the loop ignores Cruel Order | `check_in` 102 / 2 — §1h *the hero acts before an enemy due in the same round*, the source |
| C11 | the bar ignores it (HEAD's line) | `check_in` 102 / 1 — §1h *the loop and the bar do not both order turns through `_turn_before`* |
| C12 | the merchant back in severity 1's row | `check_in` 102 / 4; `check_im` 122 / 3; `check_il` 86 / 1; `check_hw` 65 / 1 — *291 of 400* and *312 of 400 dealt as IM dealt them*, *on ruin the merchant pays at severity [1, 3]* |
| C13 | the merchant at severity 1 absolutely | `check_in` 103 / 3 — *on ruin the merchant pays at severity [1]*, *the mildest severity pays [gold, rune]*, *Ruin paid no merchant in 1,200 options*; `check_im` 122 / 1 |
| C14 | the merchant keyed on `"ruin"` | `check_in` 103 / 1 — §2 *`rewards_for` names a rung* |
| C15 | one rotation arm at the list price | `check_in` 103 / 1 — §3 *{ "_autoplay_pick_kit": 1 }* |
| C16 | the enemy's usability at the list price | `check_in` 103 / 3 — the source, and *an enemy holding 30 for a 30-cost ability: warded usable true (the ward's price 38)* |
| C17 | HEAD's 58 reads (§1 alone) | `check_in` 103 / 7 — every source arm, and *under Warded 34 of 612 bot picks were cards the door would not let him pay* |
| C18 | the severity entry says 1 to 4 | `check_in` 103 / 1 — §1i |
| C19 | Wasting's text types its figure (6%) | `check_in` 103 / 1 — §1i *does not state 5% off `WASTING_PCT`* |
| C20 | Wasting ticks on the winning turn | `check_in` 103 / 1 — §1f *took 50 on the turn that won the fight* |
| R01 | **re-tune**: Wasting at 8% | `check_in` 103 / 0, `test_batch_an` 6,053 / 0 |
| R02 | **re-tune**: the Dark at 30% | `check_in` 103 / 0 |
| H01 | HEAD's `scripts/` and `data/` under IN's gates | `check_in` 44 / 19 and six SCRIPT ERRORs (the four rows, the bands, the sample, the reward row, the doors' functions absent); `check_im` 111 / 3 and two; `check_il` 86 / 2; `check_hw` 55 / 0 and one (`rewards_for` absent); `check_ij` 50 / 1; `test_batch_an` 4,032 / 2 and one; `test_batch_bb` 167 / 2 — **every gate IN re-pointed reds on HEAD's code by what it re-pointed** |
| H02 | HEAD's documents under IN's gates | `check_in` 103 / 3 — `master.html`'s four rows, §0.7's heading, the merchant's rule; `check_im` 122 / 0, `check_ij` 49 / 0, `check_hx` 39 / 0, `test_batch_bb` 167 / 0 |
| D1 | the rune panel's Close inside its scroller | `check_ia` 83 / 3 (A2's three lines name *the Mage's eight longest shown ordinary runes (81 to 113 characters: Profligate, …)*); `check_gt` 6,816 / 746 (A5's and A6's lines name their configurations and runes) |
| D2 | the card's Runes count reworded | `check_ia` 83 / 1 — A3: *the widest three core-rune titles, Beastmaster + Sharpshooter + Skirmisher (442 px)* |
| D3 | the Peddler's offers overlap | `check_gt` 6,816 / 12 — A7: *every seat's longest ordinary rune (Blood Debt, Profligate, Deepening Hex, Shared Hide) — offers 0 and 1 overlap* |
| D4 | the rune panel's scroll bar hidden | `check_ib` 119 / 1 — A8: *at its longest (826 px in 583) … the Cleric's longest ordinary runes, 83 to 127 characters (worn [Deepening Hex, Shared Ruin, Layered Aegis]; held [Martyr, Open Wound])* |

**C08 IS THE FINDING OF THIS PASS.** `check_in` §1g's third arm set the hero as the dealer of a blow on *himself*, which the feed
refuses as self-dealt, so no arm ever had a hero deal a blow to an enemy — and a feed that forgot the heroes' side read green on all
of them. The baseline note even said *none off a hero dealer*. §1g now drives a Warden's blow on an enemy under the Dark and
asserts he is not fed, and C08b reds it with the subject named; the gate went 102 → 103, its row with it, before the readers and
the recons.

**THE 23 FORCED CLONES OF §4, ONE A GATE FILE.** In each, every FAIL line IN §4 gave a pick string had its verdict forced false
after its condition was evaluated (`ok((COND) and false, MSG)`), so the arm still chose its own subject. **All 34 sites forced at
least one line** (the tool refuses a site with none), and **every forced line read names the subject the gate picked and the
measure or order it won by** — 1 to 29 lines a gate, 5,765 in `check_gt` alone where a forced arm sits inside the pouch's
combination walk. A sample, one a gate: `check_ds` *Orc Raider's first zero-cost ability in kit order other than its basic
attack, Slash*; `check_eh` *Blood Offering, the first on the Berserker's shelf*; `check_fe` *Crushing Blow, the first card in corpus
order Weighted fits*; `check_fh` *pulling on BREAK, the first tag in TAG_ORDER two carried cards hold (2 of them)*; `check_gf` *'hoarfrost'
paying gold (index 0 of 3 in the roll's order, the first not paying a merchant)*; `check_hu` *the walk's widest normal menu, 13
entries (berserker ["bloodrage", "seasoned"], 7 earned)*; `check_ih` *the longest enemy ability name set as every intent … 'Sundering
Strike' (16 characters)*; `test_batch_bs` *Magic Bolt, the first damaging card in the Pyromancer's kit order*. **The grouping is safe**:
forcing a verdict changes no state and no flow — `ok()` returns nothing a gate reads — so two forced arms in one gate cannot reach
each other.

**THE ACCEPTANCE**, on the frozen tree (`freeze.sh`, every file md5'd before and after, `.godot`, `.git` and `save-backups/`
aside), in the repo, every row of `ps` logged every 15 s (`pslog.sh`), **the pre-pass beside it in a fresh clone** (*IB work*):
**154 targets each — the acceptance 00:20:01 to 01:44:28, 84 min 27 s; the pre-pass 00:19:56 to 01:44:16, 84 min 20 s
(IM: 153 in 85 min 51 s). Both read `check_de` 633 / 0 / 0**, every target at recon 2's row to the check — the two banded suites
inside their bands (`test_batch_an` 6,052 and 6,053, `test_batch_bk` 131) — the two standing sanctioned reds to the character in
all three runs, the harness 22 / 382 / 8. **The tree did not move**: 552 files md5'd before and after, identical. **The player's
files did not move**: md5-identical before and after, and to IN's backup. **Every row of `ps` was read** — 364 samples, 00:19:56 to
01:51: every Godot row a headless battery target, one `(Godot)` row a process caught exiting, no game window and no stray process.
