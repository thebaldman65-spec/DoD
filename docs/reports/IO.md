# BATCH IO — THE BARGAIN DECK, MEASURED AND RE-CUT

**On `class-merge`, from `c986583` (IN). IMPLEMENT ONLY.** **The designer has not played since IH, and no newer file has appeared**:
`run_save.bin` is IH's 40,284 B at 14:30 on 2026-10-14 and `readout/` holds IH's one debug-touched file, both md5-identical to IN's
backup; both backed up again first (`../save-backups/IO-20261018-105321`, 10:53). **Both readings are comfortable at the honest rate** — `CLAUDE.md` 22.7 batches and `docs/state.md` 18.2 at the mean of IK–IO
(THE TWO READINGS, below).

**What IO did.** **§1 — nothing in the deck binds one side** (AQ's rule, the designer's at §0.2): **Famine and Cruel Order are
removed, not disabled** — no row, no door, no word left in the game's code or data; their built shape and IN's measurements are in
`docs/design-notes.md`. **Wasting binds both sides at 8%** (from 5%, heroes only): every unit's turn's end, five places a turn ends,
through the tick door, and a body it fells was killed by nobody. **The Hungering Dark feeds every dealer half** (from a quarter,
enemies only) by a new door — `heal_amount`'s `unowned` — a heal nobody performed, which meets every refusal and multiplier a heal
meets and reaches no rider and no ledger. **Two new two-sided bargains**: **the Thin Veil** (everyone deals 50% more, on Feverish's
Attack door) and **the Long Silence** (nobody may use the same ability twice; the basic exempt), refused at every door that chooses a
card — the hero's button, the bot's every pick, the enemy's declaration and its re-validation, and a Psychosis turn's support pick; in
the sim the bot and the warband cast a spent ability **0 times in 26,320 uses** on the default build, and 0 in 5,809 untalented. **§2 — every grade is a measurement**: the twenty-four
forced one at a time on every bargain of a Ruin run, sorted by the party's health at a bargain fight's end and cut at the counts the
bands are built on (6 / 6 / 4 / 4 / 4). **Nineteen moved**; severity 5 is **Bloodless, Wasting, Mirrorbound and Overgrown**, and **the
Hungering Dark is severity 1**. **The brief's diagnosis held**: inside the old severities 4 and 5 the party's health ranged 0.282 and
0.332 against 0.134 across all five grade means; inside the new grades 0.011–0.040 for 1–4. EP's sample: **Wanderer 2.84, Warden
3.29, Ruin 4.49** (IN 2.82 / 3.28 / 4.49), merchants **113 / 82 / 71** (112 / 78 / 76). Severity 5 pays **320** gold or a rune.
**§3 — Sanctity's step stays 13** on the repaired bot, and the measurement now asks for it outright (2.56 at 13, 2.37 at 14).
**§4 — the button and the summon picker print `_eff_cost`**, and Through and Through refunds what the cast paid (dormant). **§5 — a
bargain's chip**: a strip at the top of the battle screen. **§6 — the superlative census re-run** over all 152 targets by reading
every file in full: 481 picks in 102 of its targets — 121 sites and 360 weak fillers; **the 53 sites that named their pick in some FAIL lines or none, and IN's I5 and I6, name it in every line now** (`check_io` §6, 57 rows), and the 321 weak picks are listed, not repaired. **§7** — the archive takes the newest cut first, asserted. **No save version moved.** No dice
spender was added or removed in `battle.gd` or `run_state.gd`: the Long Silence's and the chip's doors read state, and `roll_offer`
keeps its draws.

**VERDICT: GREEN.** **The acceptance and the pre-pass both read `check_de` 637 / 0 / 0** — 155 targets, `check_io` 126 / 0 new,
`check_in` 94, `check_hu` 106, `check_ih` 98, `check_parse` 231, `check_gp` 438 (§2's seeded road, traced), the two standing
sanctioned reds unchanged in kind (`check_cm_live` 13 / 5 to the character; `check_gj` 70 / 1, its figures the re-grade's). **Every
item of the brief's §0–§7 is built, measured, or reported against a premise that did not hold (twelve did not, below); §8's are not
done, on purpose.** **Two findings of the verification were repaired before the acceptance** — recon 1's `check_dj` (a no-op filter
IO had written) and the re-tune control R02 (`check_io`'s rider arm tuned to the Dark's figure) — and recon 1's `check_gp` moved a
row with its trace and stopped the first acceptance. **The re-grade's largest effect is on play, not on a dealt mean**: Warden's
bargains much milder for the bot and Ruin's much harder (ruling 12). **Twelve rulings are owed** (below).

## NEEDS A RULING

1. **PLAY ONE ZONE WITHOUT THE DEBUG MENU, AND SEND THE FILE** (IH's ruling 1, asked at II through IO — seven batches). It prices
   Boil Over's rate, Rupture's number and clock, the vow's worth and the Cleric's Mana, and confirms Sanctity's 13. Nothing in the
   queue waits on it.
2. **THE HUNGERING DARK HELPS THE HEROES, SO IT IS SEVERITY 1** (§2b). Two-sided at a half it feeds them about six times what it
   feeds the warband — the heroes deal far more damage than a warband does — and a bargain under it ends at **0.989** of the party's
   health against **0.951** with no modifier (untalented 0.748 against 0.535). The figure was left (the brief: do not tune it in this
   batch). **Whether its figure or its shape moves is yours**; as it stands, Wanderer's and Warden's safe slot deals a bargain that
   is a gift.
3. **OVERGROWN IS SEVERITY 5 BY THE PARTY's HEALTH, NOT BY ITS RUNS** (§2c). It ends a bargain fight at 0.857 — the fifth costliest
   — yet completes 55 runs of 60, with severity 1's and 2's; its whole cost is paid at the fight's start, and the measure reads it
   whole. Untalented it sorts to severity 3. The rule takes health first; whether the measure stands is yours.
4. **THREE CUTS SIT INSIDE TWO STANDARD ERRORS** — Warded | Parched (severity 1 | 2), Fleeting | Brittle (2 | 3), Rot | Deadened
   (3 | 4): the measurement cannot tell those pairs apart. A second seed block would; the cut stands as the sort put it.
5. **THE UNTALENTED READING GRADES EIGHT DIFFERENTLY** (Overgrown 3, Deadened 1, Muffled 1, the Thin Veil 5, Warded 3, the Long
   Silence 4, Frenzied 2, Rot 4): the grades are the default build's — IN's table's build, its standard errors a tenth to a third of
   the untalented's (where no run completes, so runs completed cannot break a tie). **Which build grades is yours.**
6. **THE THIN VEIL IS FEVERISH's RULE AT TWICE THE FIGURE**, on Feverish's Attack door (the ladder Miasma and Bloodless already
   are); it measures one grade harsher (4 against 3). Confirm the reading, or name a rule of its own.
7. **THE LONG SILENCE's READINGS**: a summon's calls count as separate abilities (a cooldown keys the same way); a counter, a
   wind-up's release and Blood Tribute's strike are the cast completing, not a second use; a Psychosis turn's support pick obeys it;
   an enemy's declared move names its basic a turn ahead once the move is spent; an enemy's basic is its cheapest attack. Confirm.
8. **THE CENSUS's WEAK PICKS ARE LISTED, NOT REPAIRED** (321 — filler picks whose verdict holds for nearly any member, IN's
   *four weaker* shape; §6). Every SITE is repaired. **Whether a filler pick is a site is yours.**
9. **THE BOT's POTION IS STILL A FLAT 40** (owed, not repaired — an instrument does not move in the batch that reads it): it is why
   Famine read as nothing, and it distorts every measurement that turns on healing received — Bloodless refuses it, Miasma halves it,
   Wasting and the Thin Veil decide how often it is drunk — and early in a run it heals more than the player's 20% while late it
   heals less. **§2's grades were taken with it**; the grades that turn on healing (Bloodless, Miasma, Wasting, the Dark) are the ones
   it could move.
10. **THROUGH AND THROUGH's REFUND IS REPAIRED AND DORMANT** (§4): nothing writes the field since FX. Whether a node or rune returns
    it is yours.
11. **THE CLERIC GAINS LEAST UNDER THE DARK** (his heals are not damage): over the same runs he was fed 5,349 health where the
    Pyromancer was fed 17,982 — a tax on his share of the party's healing, not on his kit, which still works whole. Reported, the
    figure left.
12. **THE RE-GRADE MAKES WARDEN's BARGAINS MUCH MILDER AND RUIN's MUCH HARDER** (§2e). In natural play a Warden bargain fight now
    ends at 0.936 of the party's health against 0.846, heroes down a sixth as often; Wanderer's 0.971 against 0.916; Ruin's 0.753
    against 0.876. The four costliest are severity 5 now, so they are Ruin's alone, and Warden's gambles are four the bot fights at
    0.92–0.96. The dealt means barely move (the counts did not). **Whether Warden should keep one of the costliest four** — a count
    of five at severity 4, say, or a Warden band that reaches 5 — **is yours**; the brief's constraint 1 held the counts, so nothing was
    moved.

## THE BRIEF's PREMISES, CHECKED

Every claim the brief makes about the tree, read against it before anything was edited. **Twelve do not hold as written**
(3, 4, 5, 16, 22, 26, 35, 37, 40, 46, 49 and 59); the rest hold.

| | the brief's claim | what the tree says |
|---|---|---|
| 1 | §9: IN's push hash; `git ls-remote origin class-merge` against HEAD before anything runs | **Held**: `c986583` both, read before anything ran |
| 2 | §9: IN's backup is `../save-backups/IN-20261017-195752` | **Held**; IO's is `../save-backups/IO-20261018-105321`, md5-identical to it file for file and to the live files |
| 3 | head: *I authored it verbatim eighteen letters later* | **Two hundred and five letters later**: AQ is the 17th code and IN the 222nd. AQ's ruling and IN's build of it hold as the brief says |
| 4 | head: *a severity-4 Bloodless lands a bargain fight at 0.667; a severity-4 Rot costs more runs than anything I wrote* | **Two instruments**: 0.667 is IN's reading of the bot's own fights under Ruin's gambles (IN §1b's prose) and Rot's runs are IN's forced arm (its table). On ONE instrument — IO's forced arm — Bloodless reads 0.656 and Rot 0.901, so the comparison the brief draws holds (premise 40) |
| 5 | head: *my four severity-5s land at 0.807 to 0.952* | **The natural-play reading again** (Wasting 0.807 at an elite … the Dark 0.952); the forced arm read them at 0.830–0.952 |
| 6 | head: *the felt range inside one grade is wider than the range between grades* | **Held, measured** (§2c): inside the old 4 and 5, 0.282 and 0.332; the five grade means span 0.134 |
| 7 | §0.2: Wasting and the Dark have a two-sided reading; Famine and Cruel Order do not | **Held** |
| 8 | §0.2: the glossary and `master.html` go back to AQ's sentence | **Done**: the glossary's modifier entry says *every modifier binds both sides … nothing in the deck binds one side*, and `master.html`'s table head says *both sides* |
| 9 | §0.3: 1,112 names in 19 populations; *that hero* over *his* | **Held** (IN premise 7); the re-cut text says *whoever took it* |
| 10 | §0.4: `FIXED_MODIFIER_BAND` stays; say what the fixed encounters draw after the re-grade | **Held**: the eight of severity 3–4 are now Brittle, Deadened, Feverish, the Long Silence, Miasma, Rot, the Thin Veil and Thin Air (§2d) |
| 11 | §0.5: take `ROUND_TICKS` out with Cruel Order unless something else reads it | **Nothing else read it**: deleted with its one reader, `_turn_before` and the bar's ordering with it |
| 12 | §0.5: `enemies_alive_r3` is written for 100 ticks a round and never samples round three; check whether the two are the same confusion | **Held, and they are not the same confusion**: `ROUND_TICKS` read a round as one basic swing at the average speed — the timeline's own unit — while the sample assumes 100 ticks a round, a scale the timeline never had (a swing moves a unit 2). The deletion did not touch it; standing |
| 13 | §0.5: the Tracker's opening turn was right; record *a class passive outranks a modifier* | **Recorded** — in `CLAUDE.md`'s ladder block, not `docs/instrument-rules.md` (premise 59) |
| 14 | §0.6: Wasting is the only one of the four that moves the party's health (0.952 → 0.830) | **Held** (IN's table) |
| 15 | §0.6: *5% over a 6.8-turn fight is about a third of a maximum* | **Held**: IN's natural fight ran 6.80 hero turns and its forced arm 6.65 — 33% |
| 16 | §0.6: *8% is the smallest step with a chance of reaching Bloodless's 0.667* | **It reached it** — forced, Wasting reads **0.658** against Bloodless's **0.656** — **but two things moved together**: the figure and the side. The two-sided tick also fells the warband, so the arm cannot say what 8% alone costs, nor whether a smaller step would have reached it |
| 17 | §0.6: the Dark's quarter *cost one point of health* | **Held** (0.952 → 0.943) |
| 18 | §0.6: the bot drinks one Health Potion, below 35% health, at a flat 40 | **Held** (FOUND AT IN; ruling 9) |
| 19 | §0.6: Cruel Order was the hardest by runs completed — *six of sixty* | **Held as six fewer** than the *none* arm's 58: 52 of 60 |
| 20 | §0.7: steps 40, 60, 80 → the next is 100, the row 320 | **Held**; what the sample pays after is §2d |
| 21 | §0.8: 76 of 1,200 | **Held at IN**; IO's sample reads **71**: the re-grade moved which modifiers Ruin's safe slot deals at each seed, and the merchant rides severity 3's reward one time in three |
| 22 | §0.12: *Sanctity's 13 is the one number in this game set from a sim measurement* | **Not the one**: Wanderer's x0.50 was chosen by a sim sweep (BN §2 — *the only thing on this ladder chosen by measurement*), Momentum's rate was set at its stop against a sim target (FV §2), and since IO every severity is. **What is true is the rest of the sentence**: 13 is the one figure set twice off the sim (FV §2, IG §2), both times on the bot IN §3 repaired |
| 23 | §0.12: *79 of 180 untalented runs moved and 48 changed outcome* | **Held** (IN §3a) |
| 24 | §1a: *every unit loses 8% at the end of its turn* | **Built**, and a turn a stun, a freeze or a Break costs is a turn: five call sites in `_run_battle`. **A companion takes no turn, so it never wastes** — said in `master.html` |
| 25 | §1a: IN's list of what reads Wasting on the hero side | **Held**; the enemy side is censused in §1a |
| 26 | §1a: *say what it does to a Cleric (his heals are not damage, so he gains nothing from it)* | **Not nothing**: his damaging cards feed him like anyone's. **He gains least** — fed 5,349 health over the runs where the Pyromancer was fed 17,982 (§1a; ruling 11) — and that is a tax on his share of the party's healing, which the brief asked to be reported and left |
| 27 | §1a: *a unit that dies to Wasting was killed by nobody — the bomb's rule and the attribution frame's* | **Held**: the bomb deals under `_dmg_frame(null, "Bomb")`; Wasting deals under `_dmg_frame(null, "Wasting", "Wasting")`, asserted both ways (`check_io` §1b) |
| 28 | §1b: *it must not feed a Cleric's Sanctity, a heal-triggered rune, or any ledger that counts healing done* | **Sanctity reads no heal at all** — its ledger counts status events, and the feed lays none. The rest held: named in §1b |
| 29 | §1c: Famine 0.952 and 59 runs; Cruel Order 0.932 and 52 runs | **Held** (IN's table), written into `docs/design-notes.md` |
| 30 | §1d: the Thin Veil is *instant to price* | **Held**: Feverish's door at its own figure, one constant |
| 31 | §1d: the Long Silence wants per-unit bookkeeping, a card that looks spent, and a bot that respects it | **All three built** with no UI state beyond the refusal tooltip every dark button already carries; the out was not taken |
| 32 | §1d: *Ruin's gamble band at three modifiers draws two without replacement exactly as four does* | **Moot**: both shipped, and after the re-grade the band holds four |
| 33 | §1e: Ruin's mean at EP's sample; Wanderer and Warden 400 of 400 against IM's re-pointed model | **Held**: 4.49; 400 of 400 each against the model re-pointed onto the grades in force (`check_in` §1b) |
| 34 | §1e: *They are the control and they do not move* | **Held for §1, and §2 says the opposite of the re-grade**: with §1 alone Wanderer and Warden deal byte for byte as IN dealt them (the S1 arm, §1f); the re-grade then moves them, which §2's constraint 2 expects. The later instruction governs |
| 35 | §2: *IN's own table extended from five rows to twenty-five* | **IN's table had six rows** (*none*, the four, and Rot for scale); IO's has twenty-five |
| 36 | §2 constraint 1: six, six, four, four, four | **Held** (`check_io` §2 asserts it) |
| 37 | §2 constraint 5: *the sort may put Bloodless in severity 5 and move two of mine down* | **It put Bloodless in 5 and moved THREE of the four down** — the Dark to 1, the Long Silence to 3, the Thin Veil to 4; Wasting stays at 5 |
| 38 | §2: *a modifier promoted into severity 5 leaves Warden's gamble band* | **Held**: Bloodless and Mirrorbound (4) and Overgrown (1) left Wanderer's and Warden's bands for Ruin's gambles |
| 39 | §2: the bot takes the gamble in 96–98.5% of bargain fights | **Held** (IN §1a, Warden's and Ruin's) |
| 40 | §2: *Bloodless at 0.667 and Rot at 0.906 are both severity 4* | **Two instruments again** (premise 4); on the forced arm, 0.656 and 0.901, and the finding holds |
| 41 | §3: IG's population and probe, IL's seeds and shape; IL's §1c table | **Held** |
| 42 | §3: IM's strike probes are percentages over 36 full runs | **Held** (IM §3b) |
| 43 | §4: under Warded the button reads *30 Rage* for a cast charged 38, and is dark at 30–37 | **Held in shape**: a 30-cost card is charged 38. The card `check_io` drives is Crushing Blow, listed at 20 and charged 25 — dark at 20–24 with *20 Rage* on its face until IO |
| 44 | §4: `_open_summon_picker` the same | **Held** |
| 45 | §4: Through and Through refunds `ab.cost` | **Held** |
| 46 | §4: *a refund of the list price after a higher charge is a free lunch* | **The other way round**: after a HIGHER charge (Warded) the list price gave back LESS than the cast paid; the free lunch was a cast that paid LESS than its list — Twin Hunt's waiver, a discount — whose refund paid back what was never paid. **And it was worth nothing in play**: nothing writes the field since FX (§4) |
| 47 | §4: IM's 58 were choices; these are displays and a payout; do the two exhaust the file? | **They do**: every `.cost` read left in `battle.gd` is the door's own (3), a call priced off its card (2) or a test of whether a card has a price (8) |
| 48 | §5: *the same hover every other chip has carried since HZ* | **Held**: the rune chips' hover (HZ §1) |
| 49 | §5: *`check_ih` §6's gate arm covers it — run it* | **It could not**: §6 walks the plates, strips and cards that exist, and the strip did not. **§6 was extended to walk it** at its widest line on every board (`check_ih` §6), and `check_io` §5 draws it under every modifier |
| 50 | §6: nine more of the shape and four weaker, inside the 23 gates the repair read | **Held** (IN §4) — and all thirteen were found again (§6) |
| 51 | §7: IM put its cut at the foot and IN moved it | **Held** (IN's FOUND AT) |
| 52 | §7: *eight batches have asked* for the readout | **Held**: IH through IO each read it (the play itself, IH's ruling 1, has been asked seven times, II–IO). The file is unmoved |
| 53 | §8: neither reading is urgent — 52.7 batches and 15.7 at the honest rate | **Held** at IN's close; IO's are below |
| 54 | §8: the claims stand at 86 | **Held** |
| 55 | §8: the bot's potion, a flat 40 below 35% health | **Held**; owed (ruling 9) |
| 56 | §8: `enemies_alive_r3`, `run_sim._take_offer`'s comment and `check_fh` §7's comment stand unless §0.5 touches the first | **Held**: the deletion did not touch it (premise 12); all three standing |
| 57 | §9: twenty-five gate-source readers at IN, two routes, no third | **Held**; twenty-six at IO (`check_io` opens the root), and no third route (§9) |
| 58 | §9: IN read 154 targets | **Held**; IO read 155 — the acceptance 86 min 6 s (§9) |
| 59 | §9: `docs/instrument-rules.md` holds §0.5's class-passive rule | **It binds what the game contains**, which by `CLAUDE.md`'s seam is `CLAUDE.md`'s — written there, in the ladder block beside the rules it qualifies (IN's premise 34 the precedent). §0.10's note and §7's order are in `docs/instrument-rules.md`, with their rows |
| 60 | §9: IN's two readings — 467.61 KiB (42.39 under) and 354.04 KiB (25.96 under) | **Held** |

## §0 — IN's RULINGS, ANSWERED

1. **Play** — still owed (ruling 1).
2. **AQ's rule stands** — Famine and Cruel Order are removed (§1c), and the glossary's modifier entry, `master.html`'s table head and
   `CLAUDE.md`'s ladder block say nothing in the deck binds one side. IN's *the four bind ONE side* is struck, kept, in `CLAUDE.md`.
3. **Wasting** — the name stands; its text says *whoever took it*.
4. **The fixed encounters stay at 3–4** — `FIXED_MODIFIER_BAND` untouched; after the re-grade they draw a different eight (§2d).
5. **`ROUND_TICKS` is deleted with Cruel Order** (its one reader); `enemies_alive_r3` is not the same confusion and stands (premise
   12). **A class passive outranks a modifier where they contradict** is recorded in `CLAUDE.md`.
6. **Wasting 8%, the Dark a half** — `Run.WASTING_PCT` and `Run.HUNGERING_DARK_PCT`, read by the texts through a token (§1a).
7. **320** — `REWARDS[5]` (§2d).
8. **One in three** — unchanged; 71 of 1,200 at IO's sample.
9. **The three player-side reads** — repaired (§4).
10. **The re-census** — run after the repair, over every target read in full (§6); the note is in `docs/instrument-rules.md`.
11. **The chip** — built (§5).
12. **Sanctity's step** — re-taken on the repaired bot; it stays 13 (§3).

## §1 — THE DECK RE-CUT TO AQ's RULE

### §1a — WASTING AND THE HUNGERING DARK BIND BOTH SIDES

**Wasting** — *at the end of every turn, whoever took it loses 8% of maximum health — heroes and enemies alike* — is
`battle._wasting_tick`, called at the five places a turn ends in `_run_battle`: a hero's turn, an enemy's (below its declaration, so
the declaration stays the first thing after the turn — BL §1), and the three lost turns either side meets (stunned, frozen, Broken).
It deals through the tick door (`take_tick_damage`) under a frame naming nobody (`_dmg_frame(null, "Wasting", "Wasting")`), restores
the frame it found, and stops when the other side has no body standing — a turn that decided the fight ends nothing. **A companion
takes no turn and never wastes.** The figure is `Run.WASTING_PCT` (0.08), and the text reads it through a token.

**What an enemy's tick reaches — the census of the enemy side** (II §0.7), read at every line the tick door and the death door reach
from an enemy body: the tick door's own refusals (the Vow's gate refuses only a tick framed to a Vow-wearer, and this one names
nobody); **the Oathkeeper's covenant**, which splits a tick on a bound enemy with its partner as it splits any (a hero's rule engine
binding two enemies — so Wasting on one bound enemy reaches the other, by the covenant's own text); **a Glacial Hold's shatter** on a
held body; the recap (booked to nobody); **and the death door**, where a body Wasting fells is **killed by nobody**: no Reaver kill,
no killing-blow proc, the way a bomb's kill already is (`_dmg_frame(null, "Bomb")`). **Nothing that pays a hero for damage he dealt
reads it** — the Weaver's tally, the Leech's return, the Arbiter's heal and the marks all read the frame's dealer, and the frame
names none. `check_io` §1b drives it: under Wasting a hero and an enemy each wearing a barrier, 60% armor and Less Damage Taken lose
exactly 8% of 1,000 with the barrier untouched; an enemy at 3 felled with a Reaver standing in the frame before it is credited to
nobody, and the same Reaver framed as the dealer of a tick that fells the other enemy is credited one — the positive arm, so the
credit door is live.

**The Hungering Dark** — *whoever deals damage heals 50% of it — heroes and enemies alike* — feeds the dealer BL's damage door names
(`_frame_dealer`), at the door, off a blow's damage and never a tick's (a tick's frame names a layer and no live unit, on either
side). The figure is `Run.HUNGERING_DARK_PCT` (0.5). **What it does to a Cleric** (the brief's question): his heals are not damage, so
he is fed only off his damaging cards, and over the Dark's forced runs he was fed **5,349** health where the Pyromancer was fed
**17,982** — the least of the four classes, a tax on his share of the party's healing and not on his kit, which works whole
(ruling 11). Reported, the figure left.

### §1b — THE DARK's HEAL IS NOBODY's HEALING, AND IT HAS A DOOR OF ITS OWN

**The census of every reader of a heal**, read at `BattleUnit.heal_amount` and every caller's ledger:
- **the absolute refusals** — Bloodless, the Pact, Caught Fast, Unmaking, Weight of Ruin, Blight the Well, the Martyr's price;
- **the multipliers** — healing received, Rally, Frostbite, Last Hope, and the clamp that keeps a heal from inverting;
- **the riders** — the Covenant's healing half (a heal passed to the bound partner), Undying Vigil's fork to a lower hero, the Last
  Word's re-arm, the Vigil's Mercy;
- **the ledgers** — `_stat_heal` (the recap, the readout, Reprisal's `_book_healing`, Abundance's overheal shield) and every
  caller-side tally a heal books.

**What the Dark's heal reaches: the refusals and the multipliers, and nothing else.** A heal nobody cast must not pay what reads a
heal as someone's work, and must still be answerable the ways a heal is answered (Bloodless refuses it, Miasma halves it). **The
honest answer was a new door**: `heal_amount(amount, external, unowned)` — with `unowned` true the Covenant's half is skipped and the
function returns after the bars refresh, above every rider; and the Dark's caller books no `_stat_heal`. `check_io` §1c drives it
both ways: the Dark's drink of a Warrior below the Mage's share and under his Last Word's quarter forks nothing to her, re-arms
nothing and moves no ledger, while an ordinary heal of the same size forks and re-arms (the positive arm, so the riders are live);
and a Caught Fast hero is fed nothing.

### §1c — FAMINE AND CRUEL ORDER LEAVE THE DECK

**Removed, not disabled.** Famine's `_pouch_sealed` and every reader of it (the Items button, the picker, the use path, the bot's
drink), Cruel Order's `_turn_before`, `ROUND_TICKS` and the bar's ordering — every word — are gone from `scripts/` and `data/`
(`check_io` §1a asserts none of the seven names stands in either, comments stripped). The functions they had edited went back to
IM's bodies md5 for md5 where IN had only added a branch. **Their built shape and IN's measurements** are in `docs/design-notes.md`:
Famine 0.952 and 59 runs of 60 (the bot's potion), Cruel Order 0.932 and 52.

### §1d — THE THIN VEIL AND THE LONG SILENCE

**The Thin Veil** — *everyone deals 50% more damage, blows and ticks alike, on both sides* — is Feverish's door (every unit's
Attack, a companion's as it is called) at its own figure, `Run.THIN_VEIL_PCT`. The deck holds one rule at two severities already —
Miasma halves healing and Bloodless ends it — and the Veil is the same shape, which ruling 6 asks to confirm. **Which it is harder
for, by the figures**: the figures are the bot's, and they say where the room goes — a bargain fight 20% shorter (5.34 hero turns
against 6.66), heroes down more than five times as often (0.091 against 0.016), and 0.887 of the party's health at the end. **They cannot say it
is harder for a player than for the bot**, and the report does not claim it: the bot heals on a threshold and does not see a threat
coming, so a player loses room the bot never had.

**The Long Silence** — *nobody may use the same ability twice this fight; basic attacks are exempt* — is per-unit bookkeeping:
`BattleUnit.mod_silence` stamped at the fight's start, `silence_spent` booked at the one spend line every cast passes (`_resolve`'s
`not is_counter`), and `silence_basic` — a hero's slot 0, an enemy's cheapest attack (`_cheapest_attack`). **`BattleUnit.silenced(ab)`
is the one answer**, and every door that chooses a card asks it: `ability_ready` (which the button, the tooltip and the hotkeys read),
`_ability_usable` (above the free-summon bypass, so a free call is refused too), the enemy's declaration and its re-validation
(`_intent_ability_usable`, so a spent move falls back to its basic and the declared intent says so a turn ahead — BL §1), and a
Psychosis turn's support pick. **A spent card's button goes dark with the reason on its hover.** In the sim — the default build's
forced arm and the untalented one — **the bot cast a spent ability 0 times and the warband 0 times in 32,129 uses booked**
(26,320 and 5,809). The readings are ruling 7.

**Neither zeroes a class's kit** (IN's rule): the Veil changes no card, and under the Silence every card works once and the basic
always. **Which class each comes closest to**: Wasting the Mage (the smallest health, no heal of his own), the Dark the Cleric
(above), the Veil the hero who heals (least room to answer a blow), and the Silence the Cleric's heals and the Stances' one swap —
each a single decision rather than a dead hand, because the basic stands (`check_io` §1h spends every card of every hero and finds
the basic still usable).

**The texts** are read against the text standard: no pronoun, every figure off its constant (`{=Run.WASTING_PCT*100}` and its two
siblings), *whose* named, both sides said.

### §1e — THE SAMPLE

EP's sample (400 offers a rung through the real `roll_offer`, seeded, past the shop gate), on the finished tree: **Ruin 4.49**,
Wanderer 2.84, Warden 3.29; **Wanderer and Warden 400 of 400 each** against IM's reference model re-pointed onto the grades in force,
and **no severity-5 modifier reaches either — asserted directly over the bands** (`check_io` §1g, `check_in` §1b). **With §1 alone**
(the S1 arm, before the re-grade), Wanderer's and Warden's offers are IN's byte for byte; the re-grade then moves them (§2d).

### §1f — WHAT §1 DOES TO PLAY, ON ITS OWN

**Each change against the unchanged tree on its own** — natural play, the bot choosing every bargain, IG's three parties (the default
lineages) 20 runs a party, seeded per run: **H** HEAD (IN's code), **S1** HEAD with §1 alone (the re-cut deck at IN's grades), **R** §1
and §2 (the re-grade, severity 5 at 300), **F** the finished tree (§0.7's 320 beside them). §4's refund is dormant and §5's strip is
drawn, so neither moves a sim figure; §3's arms are HEAD's own (§3).

| natural play, 60 runs an arm | H | S1 — §1 alone | R — §1 and §2 | F — the tree |
|---|---|---|---|---|
| **Wanderer** (seed block 1) — runs completed; a bargain fight's health at its end | 60; 0.916 | **60; 0.916, every run byte for byte** | 60; **0.971** | 60; 0.971 (R byte for byte) |
| **Warden** (block 11) | 60; 0.846 | **60; 0.846, every run byte for byte** | 60; **0.936** | 60; 0.936 (R byte for byte) |
| **Ruin** (block 21) | 54; 0.901 | 52; **0.876** | 50; **0.753** | 50; 0.741 |
| **Ruin, untalented** (block 22) | 0; 0.462 | 0; **0.378** | — | 0; 0.381 (§1 and §2 together) |

**§1 alone touches Ruin and nothing else, as it must**: Wanderer's and Warden's runs are HEAD's byte for byte in every battle line,
because neither road deals a severity-5 bargain and §1 changed only the four. **On Ruin it makes the bargains harder** — a bargain
fight ends at 0.876 against 0.901, and two runs fewer complete (14 outcomes moved of 60) — **where IN's four made them milder than the
band they replaced** (IN §1b): Wasting two-sided at 8% costs the bot 0.728 at an elite against IN's 0.807, the Thin Veil 0.880, the Long
Silence 0.921, and only the Dark is a gift (0.990). Untalented the same, more so (0.462 → 0.378); there the re-grade adds almost nothing (0.381), because an untalented party rarely lives to meet more than a zone's bargains.

## §2 — THE SEVERITY LADDER, MEASURED

### §2a — THE INSTRUMENT

**IN's forced arm** (`probe_in_patch.py`'s `DOD_IN_FORCE`): every bargain of a Ruin run carries the one modifier, and the fixed
encounters carry it too, so *none* is a run with no modifier anywhere. IG's three parties (the default lineages), seed block 21 on
the default build and 22 untalented, twenty runs a party. **Why this arm is the measure, said for the next person to measure a band**:
the bot takes the gamble in 96–98.5% of bargain fights (IN §1a), so a modifier in a safe slot is nearly invisible to every figure a
natural run prints — the forced arm is immune to that, because nothing is chosen. **The default build's table is the grade**; the
untalented one stands beside it.

### §2b — THE TABLES

**The default build** (60 runs an arm; *length* is hero turns a hero, *health* the party's share of its maximum at a bargain fight's
end, ± one standard error):

| forced on every bargain | old grade | runs completed | length | health at a fight's end | heroes down | bargain fights won |
|---|---|---|---|---|---|---|
| *none* | — | 58 of 60 | 6.66 | 0.951 ± 0.003 | 0.016 | 100.0% |
| Overgrown | 1 | 55 of 60 | 5.64 | 0.857 ± 0.006 | 0.032 | 99.9% |
| Parched | 1 | 56 of 60 | 6.72 | 0.942 ± 0.004 | 0.026 | 99.9% |
| Slick Footing | 1 | 55 of 60 | 6.61 | 0.942 ± 0.004 | 0.025 | 99.9% |
| Dull Edge | 1 | 59 of 60 | 6.68 | 0.957 ± 0.003 | 0.006 | 100.0% |
| Muffled | 1 | 56 of 60 | 6.85 | 0.941 ± 0.003 | 0.014 | 99.9% |
| Hoarfrost | 1 | 56 of 60 | 6.33 | 0.963 ± 0.003 | 0.016 | 99.7% |
| Tinderbox | 2 | 59 of 60 | 6.37 | 0.951 ± 0.003 | 0.013 | 100.0% |
| Frenzied | 2 | 58 of 60 | 6.60 | 0.954 ± 0.003 | 0.015 | 100.0% |
| Fleeting | 2 | 54 of 60 | 6.66 | 0.931 ± 0.004 | 0.040 | 99.7% |
| Feverish | 2 | 51 of 60 | 5.92 | 0.912 ± 0.005 | 0.057 | 99.3% |
| Deadened | 2 | 51 of 60 | 7.93 | 0.898 ± 0.005 | 0.051 | 99.9% |
| Miasma | 2 | 56 of 60 | 6.69 | 0.881 ± 0.004 | 0.020 | 100.0% |
| Brittle | 3 | 51 of 60 | 6.05 | 0.922 ± 0.005 | 0.054 | 99.3% |
| Warded | 3 | 56 of 60 | 6.72 | 0.949 ± 0.003 | 0.012 | 100.0% |
| Thin Air | 3 | 50 of 60 | 6.55 | 0.897 ± 0.006 | 0.066 | 99.7% |
| Encumbered | 3 | 55 of 60 | 6.68 | 0.941 ± 0.004 | 0.014 | 99.8% |
| Bloodless | 4 | 47 of 60 | 6.72 | 0.656 ± 0.008 | 0.226 | 99.0% |
| Bloodletting | 4 | 55 of 60 | 5.80 | 0.938 ± 0.004 | 0.029 | 99.9% |
| Mirrorbound | 4 | 47 of 60 | 6.61 | 0.706 ± 0.008 | 0.176 | 99.4% |
| Rot | 4 | 52 of 60 | 4.34 | 0.901 ± 0.005 | 0.058 | 99.9% |
| Wasting | 5 | 44 of 60 | 5.54 | 0.658 ± 0.009 | 0.206 | 98.4% |
| the Hungering Dark | 5 | 55 of 60 | 6.55 | 0.989 ± 0.001 | 0.010 | 100.0% |
| the Thin Veil | 5 | 52 of 60 | 5.34 | 0.887 ± 0.006 | 0.091 | 99.3% |
| the Long Silence | 5 | 53 of 60 | 7.04 | 0.910 ± 0.004 | 0.030 | 99.9% |

*Long Silence: hero casts of a spent ability 0, enemy 0, of 26320 uses booked*

**Untalented** (60 runs an arm; no run completes on Ruin untalented, in any arm):

| forced on every bargain | old grade | runs completed | length | health at a fight's end | heroes down | bargain fights won |
|---|---|---|---|---|---|---|
| *none* | — | 0 of 60 | 8.30 | 0.535 ± 0.031 | 1.326 | 79.3% |
| Overgrown | 1 | 0 of 60 | 6.58 | 0.492 ± 0.024 | 1.129 | 85.0% |
| Parched | 1 | 0 of 60 | 8.24 | 0.525 ± 0.029 | 1.353 | 79.9% |
| Slick Footing | 1 | 0 of 60 | 8.06 | 0.517 ± 0.030 | 1.360 | 77.0% |
| Dull Edge | 1 | 0 of 60 | 8.22 | 0.541 ± 0.030 | 1.298 | 78.6% |
| Muffled | 1 | 0 of 60 | 8.42 | 0.596 ± 0.028 | 0.994 | 84.1% |
| Hoarfrost | 1 | 0 of 60 | 8.09 | 0.621 ± 0.027 | 0.973 | 85.3% |
| Tinderbox | 2 | 0 of 60 | 8.30 | 0.540 ± 0.030 | 1.314 | 78.8% |
| Frenzied | 2 | 0 of 60 | 8.25 | 0.538 ± 0.031 | 1.319 | 78.5% |
| Fleeting | 2 | 0 of 60 | 8.91 | 0.511 ± 0.028 | 1.344 | 82.8% |
| Feverish | 2 | 0 of 60 | 6.71 | 0.456 ± 0.030 | 1.570 | 75.8% |
| Deadened | 2 | 0 of 60 | 8.64 | 0.571 ± 0.028 | 1.100 | 85.7% |
| Miasma | 2 | 0 of 60 | 7.59 | 0.376 ± 0.026 | 1.750 | 72.7% |
| Brittle | 3 | 0 of 60 | 7.01 | 0.407 ± 0.031 | 1.881 | 68.6% |
| Warded | 3 | 0 of 60 | 7.92 | 0.497 ± 0.029 | 1.401 | 77.4% |
| Thin Air | 3 | 0 of 60 | 7.44 | 0.380 ± 0.032 | 1.835 | 61.5% |
| Encumbered | 3 | 0 of 60 | 8.26 | 0.520 ± 0.027 | 1.293 | 83.5% |
| Bloodless | 4 | 0 of 60 | 7.09 | 0.226 ± 0.022 | 2.442 | 56.7% |
| Bloodletting | 4 | 0 of 60 | 6.91 | 0.531 ± 0.027 | 1.238 | 82.5% |
| Mirrorbound | 4 | 0 of 60 | 7.13 | 0.347 ± 0.025 | 1.761 | 72.6% |
| Rot | 4 | 0 of 60 | 4.51 | 0.392 ± 0.028 | 1.909 | 72.7% |
| Wasting | 5 | 0 of 60 | 5.48 | 0.231 ± 0.021 | 2.000 | 69.9% |
| the Hungering Dark | 5 | 0 of 60 | 9.62 | 0.748 ± 0.024 | 0.859 | 88.7% |
| the Thin Veil | 5 | 0 of 60 | 5.33 | 0.330 ± 0.029 | 2.147 | 63.3% |
| the Long Silence | 5 | 0 of 60 | 7.84 | 0.394 ± 0.026 | 1.772 | 74.8% |

*Long Silence: hero casts of a spent ability 0, enemy 0, of 5809 uses booked*

### §2c — THE SORT, THE CUT, AND THE BRIEF's DIAGNOSIS

Sorted by the party's health at a bargain fight's end, runs completed breaking a tie, cut at 6 / 6 / 4 / 4 / 4:

| | modifier | health at a bargain fight's end | runs completed | old → new |
|---|---|---|---|---|
| 1 | the Hungering Dark | 0.989 ± 0.001 | 55 of 60 | 5 → **1** |
| 2 | Hoarfrost | 0.963 ± 0.003 | 56 of 60 | 1 → 1 |
| 3 | Dull Edge | 0.957 ± 0.003 | 59 of 60 | 1 → 1 |
| 4 | Frenzied | 0.954 ± 0.003 | 58 of 60 | 2 → **1** |
| 5 | Tinderbox | 0.951 ± 0.003 | 59 of 60 | 2 → **1** |
| 6 | Warded | 0.949 ± 0.003 | 56 of 60 | 3 → **1** |
| 7 | Parched | 0.942 ± 0.004 | 56 of 60 | 1 → **2** |
| 8 | Slick Footing | 0.942 ± 0.004 | 55 of 60 | 1 → **2** |
| 9 | Muffled | 0.941 ± 0.003 | 56 of 60 | 1 → **2** |
| 10 | Encumbered | 0.941 ± 0.004 | 55 of 60 | 3 → **2** |
| 11 | Bloodletting | 0.938 ± 0.004 | 55 of 60 | 4 → **2** |
| 12 | Fleeting | 0.931 ± 0.004 | 54 of 60 | 2 → 2 |
| 13 | Brittle | 0.922 ± 0.005 | 51 of 60 | 3 → 3 |
| 14 | Feverish | 0.912 ± 0.005 | 51 of 60 | 2 → **3** |
| 15 | the Long Silence | 0.910 ± 0.004 | 53 of 60 | 5 → **3** |
| 16 | Rot | 0.901 ± 0.005 | 52 of 60 | 4 → **3** |
| 17 | Deadened | 0.898 ± 0.005 | 51 of 60 | 2 → **4** |
| 18 | Thin Air | 0.897 ± 0.006 | 50 of 60 | 3 → **4** |
| 19 | the Thin Veil | 0.887 ± 0.006 | 52 of 60 | 5 → **4** |
| 20 | Miasma | 0.881 ± 0.004 | 56 of 60 | 2 → **4** |
| 21 | Overgrown | 0.857 ± 0.006 | 55 of 60 | 1 → **5** |
| 22 | Mirrorbound | 0.706 ± 0.008 | 47 of 60 | 4 → **5** |
| 23 | Wasting | 0.658 ± 0.009 | 44 of 60 | 5 → 5 |
| 24 | Bloodless | 0.656 ± 0.008 | 47 of 60 | 4 → **5** |

**The diagnosis holds.** Under the old grades the range of health inside a grade was 0.106 / 0.073 / 0.052 / **0.282** / **0.332**
for severities 1–5, and the five grade means spanned **0.134** — and ran out of order (2 below 3, 4 below 5). Under the new grades the
ranges are **0.040 / 0.011 / 0.022 / 0.017 / 0.202** and the means span **0.241**, in order, each step 0.020–0.028 but the last
(0.171): **severity 5 is a cliff** — the four end a bargain fight near 0.72 of the party's health, a quarter below no modifier's 0.951. Untalented the same (old means span 0.175 and out
of order; new 0.319, in order).

**No modifier is exempted.** The near-baseline readings — Hoarfrost 0.963, Dull Edge 0.957, Frenzied 0.954, Tinderbox 0.951 — each
change a number the sim applies to the bot exactly as to a player (a chill, a crit chance, a speed, a fire multiplier); none takes away
something the bot never uses, which is Famine's shape and the exemption's test. **Three cuts sit inside two standard errors**
(ruling 4); **the measure itself is ruling 3** (Overgrown) and **the build is ruling 5**.

### §2d — WHAT MOVED

**Nineteen of the twenty-four**: Overgrown 1 → 5, Parched, Slick Footing and Muffled 1 → 2, Tinderbox and Frenzied 2 → 1, Feverish
2 → 3, Deadened and Miasma 2 → 4, Warded 3 → 1, Thin Air 3 → 4, Encumbered 3 → 2, Bloodless and Mirrorbound 4 → 5, Bloodletting
4 → 2, Rot 4 → 3, the Hungering Dark 5 → 1, the Thin Veil 5 → 4, the Long Silence 5 → 3. Hoarfrost, Dull Edge, Fleeting, Brittle and
Wasting stay.

| EP's sample, 400 offers a rung | IN | IO | by severity 1–5, IO |
|---|---|---|---|
| Wanderer — mean, merchants | 2.82, 112 | **2.84, 113** | 197 / 203 / 397 / 403 / 0 |
| Warden — mean, merchants | 3.28, 78 | **3.29, 82** | 148 / 151 / 101 / 800 / 0 |
| Ruin — mean, merchants | 4.49, 76 | **4.49, 71** | 0 / 0 / 207 / 193 / 800 |

**The means barely move because the counts did not** — a band's mean is its grades' mean, and the counts keep it; **what moves is
which bargain each slot deals.** **Neither rung's own text becomes false**: Wanderer's *the Decay is thin here — no twist*, Warden's
*the guaranteed mild bargain gets less mild* (its safe band still reaches severity 3, Wanderer's stops at 2) and Ruin's *harsher
bargains, and fixed encounters carry a modifier*. **Ruin's fixed encounters now draw** Brittle, Deadened, Feverish, the Long Silence,
Miasma, Rot, the Thin Veil or Thin Air — two of the brief's own four among them, by their grades. **Severity 5 pays 320 gold or a
rune**: of Ruin's 800 severity-5 options at EP's sample 402 pay gold and 398 a rune, so the twenty more moves the sample's gold from 150,520 to **158,560** over its 1,200 options (125.4 → 132.1 an option); Wanderer and Warden deal no severity 5 and pay as they did.

### §2e — WHAT THE RE-GRADE DOES TO PLAY, ON ITS OWN

**The re-grade moves every road, and it moves Wanderer and Warden the other way from Ruin** (the table in §1f, columns S1 → R).
**Wanderer's and Warden's bargains get markedly milder for the bot**: a Warden bargain fight ends at **0.936** of the party's health
against 0.846 and heroes go down a sixth as often (0.003 against 0.018); Wanderer's 0.971 against 0.916. **Ruin's get much harder**:
0.753 against 0.876, two runs fewer complete. **The cause is the band contents, read off the bot's own fights**: Warden's gamble band
was Bloodless, Mirrorbound, Rot and Bloodletting — the bot fought Bloodless at 0.781 and Mirrorbound at 0.757 — and is now Deadened,
Miasma, Thin Air and the Thin Veil, which the bot fights at 0.92–0.96 on Warden's multiplier; the four costliest are Ruin's alone, which
is constraint 5 doing what the brief said it would. **The dealt means barely move (2.84, 3.29) because a mean of grades is a mean of
the counts, and the counts did not move — what moved is what each grade costs.** No rung's own text becomes false. **Whether
Warden's middle rung should keep one of the costliest four is yours** (ruling 12): the rule put severity 5 where the cost is, and
Warden's offers lost their teeth by it. **§0.7's 320 moves only Ruin** (22 runs of 60 moved, four outcomes, all by the gold a
severity-5 bargain pays); Wanderer and Warden are R's byte for byte.

## §3 — SANCTITY's STEP, RE-TAKEN ON THE REPAIRED BOT: IT STAYS 13

**IG's probe and population, IL's seeds and shape** — a Hierophant beside the default lineages, rung 1, the default build 20 runs a
party and untalented 60, every run seeded from its index — on HEAD (IN's code: the bot pays the door's price). **§3 shares no run with
§2**: its arms are rung 1 with no modifier forced, on HEAD's tree; §2's are Ruin with one forced, on IO's.

| | IL §1c (IL's code) | IO, on IN's repaired bot |
|---|---|---|
| **Untalented: a normal fight — events, steps at 13 (at 14)** | 41.55 — **2.62** (2.43) | 40.43 ± 0.50 — **2.56** ± 0.03 (2.37) |
| Untalented: a boss — steps at 13, at the cap | 3.97, 40.8% | 3.95, 38.9% |
| Untalented: his first / second step, by his turn | 2.96 (92.7%) / 5.02 (70.2%) | 2.97 (92.6%) / 5.03 (70.1%) |
| **Default: a normal fight — events, steps at 13** | 38.34 — **2.47** | 38.19 — **2.46** |
| Default: a boss — steps at 13, at the cap | 3.29, 15.0% | 3.38, 16.7% |
| **Applications the door lengthened, a fight (turns added)** — untalented | 5.32 (12.70) | 5.12 (12.00) |
| — default | 5.16 (10.84) | 5.03 (10.33) |
| Unit turns a fight — untalented / default | 51.36 / 31.50 | 51.10 / 31.62 |
| Untalented: runs completed | 76 of 180 | 70 of 180 |

Fights: untalented 3,984, default 1,679. **The step stays 13, and the measurement now asks for it outright**: IG's rule — the step
whose reading is nearer 2.5 — reads 13 at 0.06 against 14 at 0.13, where IL's arm tipped to 14 by 0.05. **The brief's expected shape
held**: the repair moved what the bot chose and not how a status is credited, and every figure moved inside its noise but the
untalented events (−1.1, two standard errors) and the runs completed (76 → 70, not significant at this n). **13 is not reached for
because it is written down; it is what the reading asks.**

**IM's strike probes are named, not re-run**: percentages over 36 full runs, unseeded, taken on the bot that paid less than the door
charged on 0.35% of its costed casts on the default build and about 2% untalented (IN §3a) — so the error they could carry is of
that order, a few tenths of a point of a share, below the run-to-run noise of an unseeded 36-run arm. **EP's sample plays no fight**
and carries none.

## §4 — THE THREE PLAYER-SIDE LIST PRICES

- **`_ability_popup_button`** prints `_eff_cost(u, ab)` — so under Warded Crushing Blow (listed at 20) reads *25 Rage*, dark at
  20–24 and lit at 25, the number and the lit state agreeing with each other and with the door (`check_io` §4 drives both).
- **`_open_summon_picker`** prints each call's `_eff_cost` (every call under Warded, driven).
- **Through and Through** refunds `io_paid`, the `_eff_cost` the cast was charged, read once above the spend. **What it was worth**:
  the field (`through_and_through`) has had no writer since FX deleted the trees, so in play the refund was worth **nothing** on either
  side of the repair. Set by hand and isolated as the difference between one cast with the field off and on, the same dice: under
  Warded it now pays back the door's dearer price, and a free cast pays back nothing — where the list price would have given back 20
  of 25, and a full list price on a waived cast. **Dormant, and ruling 10 asks whether anything returns it.**

**The sweep for the same shape** — every place a cost is printed or refunded rather than charged — over every `.cost` read left in
`battle.gd`: **3 are the door's own** (inside `_eff_cost`), **2 a call priced off its card** (the summon's definition), **8 a test of
whether a card has a price at all** — none prints one or pays one back (`check_io` §4 asserts the partition). **The two populations —
IM's 58 choices and these three — now exhaust the file.**

## §5 — A BARGAIN's CHIP

**The battle screen says which bargain is in force, all fight.** `battle._draw_bargain_strip()` lays a strip at the top of the
screen, between the turn strip and the combat log: **BARGAIN** (a bargain the party took) or **IMPOSED** (Ruin's fixed encounters),
then one chip in the modifier's own letters, its pips in `Run.SEVERITY_COLORS` (moved off the offer screen so both draw one table),
and its name — **the rule on the hover**, the hover every chip carries. **The letters are each modifier's own** — `Run.MODIFIERS`'
`tag`, two letters a modifier, walked by `check_hu` §4a beside every status's tag and counter, case set aside (HU §4, HV §1): no
modifier's letters are a status's. **It wears none of the four glyphs** (◆ ↑ ✦ ○): a bargain is not a decision waiting, an upgrade, a
rune or a thing paying nothing. **What marks it instead is its word and its pips** — BARGAIN or IMPOSED, and the severity's colours —
and its place: the strip is the fight's, not a plate's. **The layout rule binds**: `check_ih` §6 walks the strip at its widest line —
the longest modifier name (*The Hungering Dark*), bought — on each of its four boards, and finds nothing drawn over anything and
nothing past its container; `check_io` §5 draws all 48 (the twenty-four bought and imposed) clear of the turn strip and the log.

## §6 — THE SUPERLATIVE CENSUS, RE-RUN AFTER ITS REPAIR

**THE CENSUS WAS RE-RUN WITH THE PATTERNS THE REPAIR TAUGHT, AND IT READ EVERY FILE WHOLE** — so the patterns were a checklist and
not the population, which is §0.10's note answered at the method rather than by a longer pattern list. A pre-pass over every target,
comments stripped and strings masked, flagged 8,009 lines in the classes IN's repair met and IM's sweep did not (an index into a rolled
offer or a data order, a first-found `break` or `return` inside a loop, an outer variable kept by a loop — the last holder it meets —
argmax by comparison, `max`/`min`, sorts, `pick_random` and `shuffle`, `keys()[`, and superlative words in identifiers); **fourteen
readers then took eleven files each and read every one in full** — all 152 targets (the 46 suites, 103 gates, the harness, the two
scene scripts and `check_de`) and the two shared fixtures — and decided every candidate, logging **2,592 rejects** each with its reason
(the gate's own order, already named, every member asserted, a limit, not a pick, the only one, a source anchor, a walker, a value the
gate set itself). A coverage pass then found 811 strong-class lines with no row or reject within eight lines and triaged every one.
The census is kept, not just counted (ID §0.6's rule): `docs/reports/IO-census.tsv`, one row a pick.

**What a row is.** One pick. **A SITE** is a pick the assertions are about — its words, its cost, what casting it did; **a WEAK row**
is a filler: the gate needs *some* member and the verdict would very nearly hold for any, though a data change still swaps it
silently (IN's *four weaker*: slot 0 by design, the first two of six slotted, a walk to the nearest node).

| | SITE | WEAK | all |
|---|---|---|---|
| **picks in battery targets** | **121** | **360** | **481** (in 102 of the 152 targets) |
| every FAIL line names the pick | 68 | 39 | 107 |
| some do | 26 | 18 | 44 |
| none do | 27 | 303 | 330 |

**THE COUNT THREE WAYS** (the brief's):
- **IM's 57** — all 57 found again (68 picks): **50 name their pick in every FAIL line and 7 in some only** — A5 (`check_gt` §1), A13
  (`check_go` §6), A14 (`check_ik` §1a), B6 (`check_es` §4), B17 (`check_gx` §3c), B28 (`check_ho` §1d), B30 (`check_hu` §1f) — **so IN's
  *57 sites, 57 name their pick in every FAIL line* was short by seven**, and `docs/instrument-rules.md`'s superlative block says so now.
  Six of the seven are among the 23 IM marked named and IN did not touch; A5 is one of IN's 34.
- **IN's 57 + 13** — the thirteen all found (19 picks): one names its pick (I2 — `check_fe` prints `both["upgrades"]`, which holds
  exactly the two picks, so IN's *unnamed* was wrong for it), two in some lines, ten in none; **I5 and I6 are graded weak** (I5's three
  picks rest on the data giving each engine to one seated lineage; I6's on any three owned cards) and were repaired anyway, because IN
  named them.
- **IO's total — 121 sites and 360 weak picks.** Beyond IM's and IN's: **44 site picks no census had** (7 named, 17 in some lines, 20
  in none) and 351 weak ones.

**THE REPAIR.** Every site naming its pick in no FAIL line or in some — **53 of them, in 27 gate files** — and IN's I5 and I6, by IN
§4's shape: one string built from values the gate already holds, right after the pick, naming the subject and the order or measure
it won by, appended to every FAIL line about the pick; no condition, control flow, printed line, order of computation or die moved,
and the number of `ok(` calls in every file unchanged. Four agents each repaired a group in a lane of its own, ran every edited gate
on its lane before and after (Parse Error and SCRIPT ERROR 0, the verdict line unchanged to the count), and forced every repaired
FAIL line false after its condition (`ok((COND) and false, MSG)`) in a scratch copy to read the line it prints: every forced line printed names the subject the gate picked and the order or measure it won by — from 3 printed lines a gate to 98 where a forced arm sits in a loop (`check_gx` §3b's per-engine walk), and the forced copies were deleted after. A
sample, one a group: `check_ft` *Death Ray (damage 150, arcane), the hardest-hitting non-physical card on the Arcanist bar, first on a tie in bar order*; `check_hy` *Orc Raider's Slash, its first ability in data/enemies.json order* (it typed *Slash* before); `check_es` *'Stabilize' ["DEFENSE", "RESOURCE"], the first two-tag card in CARD_TAGS order*; `check_ik` *Orc Raider at 87000, the fullest of the warband's 3, the first in the warband on a tie*. **Every edited gate read its count unchanged before and after, and every file holds the `ok(` calls it held at HEAD** (`test_run_harness`'s `_check` and `_check_range` gained an optional last argument the FAIL print appends, so its passing lines are byte for byte). **`check_io` §6 holds the 57 rows** — each site's builder and the function whose
lines carry it — and asserts the table's size. **The shape that carries the most risk is now gone from every site**: a FAIL line that
typed today's pick (*Slash*, *Smite*, *Magic Bolt*, *a Strike*, *Blood Frenzy:*, *the Mage*) reads the pick now wherever the row is a
site; where the row is weak it stays (ruling 8).

**THE WEAK PICKS ARE LISTED, NOT REPAIRED** — 321 that name their pick in no line or in some, in five families (a first or last in a
data order, an enemy kit's first ability used as *the swing*, the first of a rolled offer, a hero's slot-0 basic, a ranked measure),
the census's own split of them approximate. **Whether a filler is a site is ruling 8.**

**WOULD THE NEXT CENSUS FIND NOTHING?** **Of sites, nothing this census did not see** — and §0.10's note asks the repair pass
itself, so each group was asked afterwards what it met that was not its row. **They read the stretches around their sites, not
whole files**, and met **21 picks outside their rows: every one a weak filler or the gate's own order, and all but four already the census's rows or logged rejects** (a walker, the only one, the gate's own order, not a pick). The four it had not logged — `check_hk` §2f's drop of the holding's row 0, `check_hr` §2's press of the first *Continue*-family button, `check_hz` §1's read of the kill record the blow just wrote, and `check_gx` §4b's first seat — are fillers, none a site. **So a census of this shape run now would find the 321 weak picks again (ruling 8 decides whether
it should) and, as far as four repair passes and one whole read can say, no unrepaired site.** IO's own new code was read the same
way before the recons: `check_io`'s picks are a warband's first body as a filler and the Warrior's slot 0, and both FAIL lines now
name the body and the card.

**IO's DIFF AGAINST IM's AND IN's SITES, BEFORE THE FIRST PREDICTION** (§9's order): the sites whose population is the bargain deck
are `check_gf` §3 (B14 — the first option of Warden's rolled offer not paying a merchant), `check_ih` §6's probe and `test_batch_an`
§3's first option (both weak). **Driven, `check_gf` §3 picks the same bargain on HEAD's code and IO's** — *'hoarfrost' paying gold, index
0 of 3* — because Hoarfrost stays at severity 1 and the same dice deal it; the re-grade moved none of the sites' picks that the gates
read. `check_ih` §6's pick of the longest modifier name (*The Hungering Dark*, 18 characters) is unmoved by the four new names.

## §7 — HOUSEKEEPING

**THE MOVE IS NOT ATTEMPTED** (IB §4). **Read during IO's measurements: 602 folders, 278,736 KiB** (IN's close: 602, 258,872 —
the growth is logs: Godot keeps each folder's last five process logs, and IO ran its sim arms and its gates through sixteen reused
folders). **At IO's close 602 folders, 271,388 KiB** — Godot rotates each folder's logs, so the reading falls between runs as well as rising. **IO made no folder — the eighth batch running.** It reused sixteen: II's three (*II K*, the HEAD clone; *II R*;
*II S*), five of IB's (*IB work*, *IB ctlA*, *IB ctlB*, *IB probe*, *IB recon*), IA's three (*IA probe*, *IA probe6*, *IA trhead*)
and IC's five (*IC ctlA*, *IC ctlB*, *IC alone*, *IC work*, *IC final*). **The spent prefixes** — every *Dawn of Decay* copy from FX
to IN, the sixteen among them, and the five *DoD …* copies — are **600 folders, 270,864 KiB** at the close (277,972 during the measurements). **ONE command clears them**, leaving
the live *Dawn of Decay* folder and `[unnamed project]` — IN's command, unchanged, because IO made no folder its patterns miss:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IN)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-J]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IN)/"
```

Each pattern was listed before it was written here — 470, 125 and 5 folders — and none reaches the live folder. **IB's caution,
kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the paste
first. **And clearing them ends the reuse**: the next batch makes its lanes again.

**THE ARCHIVE TAKES THE NEWEST CUT FIRST, ASSERTED** (`check_io` §7): IO's cut — `docs/state.md` as IN left it — is at the top of
`DoD-archive/state-archive.md`, and every cut's code reads newest first below it (IO IN IM IL IK IJ II …); the rule is
`docs/instrument-rules.md`'s, with its row.

**THE LIVE FOLDER's `readout/`**, read and not changed: `latest.txt` (40 B) and `run-20261014-134942.jsonl` (16,291 B, IH's one
file), backed up with the four player files, md5-identical to the backup before and after the acceptance, and again at the close. **No newer file.**

## §8 — WHAT IS DELIBERATELY NOT DONE

- **The documents are the next batch's**: `docs/state.md`'s closed-block census, `master.html`'s fact sweep and the re-measure, IP's
  together. Both readings are below.
- **The claims stand at 86.**
- **No one-sided modifier entered the deck**, and **no grade moved but by §2's measurement** — none by feel, none to make a rung read
  better; the three noisy cuts stand as the sort put them (ruling 4).
- **The bot's potion is not repaired** (ruling 9): an instrument does not move in the batch that reads it.
- **`enemies_alive_r3`, `run_sim._take_offer`'s comment and `check_fh` §7's comment are not repaired**; the first is untouched by
  `ROUND_TICKS`' deletion (premise 12). All three stand in `docs/state.md`.
- **The Dark's figure and the Cleric's share under it are not tuned** (rulings 2 and 11).
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; Boil Over, the vow, the recoil floor and Anointing
  untouched; the third slot ungated; Rupture's number and clock wait on a clean file; the art is not commissioned; a copied
  Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire's re-cut unbuilt and `CONJUNCTIONS`
  holds Rupture alone; Contagion's and Reckoning's re-cuts; the Occultist's Break card; the Skirmisher and the Tracker with Volley and
  Ambusher owed their slots and their names; Channel's tempo payout; the fallen-hero ruling and its seven things; Tithe's read site
  and its talent rebalance; the block index.

## FOUND AT IO AND NOT FIXED

- **IN's CLAIM THAT ALL 57 OF IM's SITES NAME THEIR PICK WAS SHORT BY SEVEN** (A5, A13, A14, B6, B17, B28, B30 named it in some FAIL
  lines only): IO's census found them, §6 repaired them, and `docs/instrument-rules.md`'s superlative block says so.
- **A FAIL LINE THAT TYPES TODAY's PICK** (*Slash*, *Smite*, *Magic Bolt*, *a Strike*, *Blood Frenzy:*, *the Mage*) names nothing:
  it goes stale the moment the pick moves. Repaired where the row is a site; the rest are among the weak picks (ruling 8).
- **`battle._cheapest_attack` RETURNS THE FIRST FREE DAMAGING ABILITY, NOT THE CHEAPEST** — its name says *cheapest*, and every enemy
  kit's free attack comes first today, so the two agree on the live roster. The Long Silence's enemy exemption and Heads Down read it.
- **WASTING's 8% CANNOT BE PRICED APART FROM ITS SECOND SIDE** (premise 16): the forced arm moved both at once.

## THE TWO READINGS

**`CLAUDE.md` is 481,686 B = 470.40 KiB against its 510 KiB ceiling — 39.60 KiB under** (+2,851 B at IO, the three rulings it
records; IN 467.61 KiB): 4.9 batches at EZ's record (8,293 B), **22.7 at the mean of IK–IO** (1,784 B). **`docs/state.md` is 364,256
B = 355.72 KiB against its 380 KiB ceiling — 24.28 KiB under** (+1,714 B at IO, its own reading included; IN 354.04 KiB): 4.2
batches at IA's +5,860 B, the worst case; the honest rate is IK +2,111, IL +5,587, IM −4,046, IN +1,476, IO +1,714 — a mean of
1,368 B, **18.2 batches at it**. **Both are comfortable at the honest rate** (above eight), and **neither is urgent** — the brief's
own reading of IN's (52.7 and 15.7) holds in kind: `CLAUDE.md`'s rate rose with the window (IJ's −1,947 left it), `docs/state.md`'s
fell. `docs/state.md`'s reading is a fixed point: the file's size is inside its own line, so the figures were filled and the file
re-measured until they agreed (`tools/readings.py`, re-run after the last edit to it).

## §9 — THE VERIFICATION

**THE PUSH CHECK AND THE BACKUP, FIRST.** `git ls-remote origin class-merge` read `c986583`, IN's HEAD and local HEAD, before
anything ran; the four player files and `readout/` were backed up to `../save-backups/IO-20261018-105321` (md5-identical file for
file to IN's backup and to the live files) before the first edit. A clone of the untouched tree (*II K*) was kept as HEAD's for the
variants, the traces and recon 1.

**THE SUPERLATIVE CENSUS RAN FIRST** (§6), **then IM's and IN's sites were read against IO's diff** — two modifier rows out and two in,
nineteen grades moved, `REWARDS[5]`, the strip, three cost displays, the four doors of §1. **The sites whose population is the deck**
(`check_gf` §3, and two weak picks) **were driven on HEAD's code and IO's and pick the same bargain**; no site ranks a modifier's
words, the reward row or the strip. **Prediction: no site re-selects.**

**THE LITERAL SWEEPS RAN BEFORE EACH PREDICTION** (both quote styles, every length, the short literals at their own length, and every
literal a gate reads with `.count(`). **Over the code and data** (before recon 1): 29 lost — every one `check_in`'s, `check_io`'s or
`test_batch_an`'s (the two removed ids and their doors, the old text of the modifier entry), but two whose readers read another file
(`test_batch_bx`'s *all four heroes* is a `master.html` needle, and *turn order* is `check_dn`'s and `check_em`'s vocabulary for a
talent's text) — 50 gained (each `check_io`'s or a common word another gate holds for another file), five short flips (`○` in
`battle.gd`, which `check_id` §3a and `check_io` §5 both hold to their own lines; `offer_screen.gd`'s *two*, *IO*, `45` and `\n}`, read
by no gate in that file) and 36 counts moved, every one a count over a gate's own slice. **Over the documents** (before the acceptance's prediction, and again after its last edit): 23 lost — the two removed names in `master.html`, fifteen in `docs/state.md`'s rewritten WHERE block and archived rulings, none held by a gate that opens it (`check_es`, `check_fg`, `check_hp`, `check_hx` hold none of them), and the glossary's old modifier sentences — 74 gained, six short flips (*A5*, *B2*, *Rot*, `  (`, none read in these files) and 41 counts moved, each a count over a gate's own slice or a needle `check_io` itself holds.

**`check_hf`, WHICH HOLDS THE DESIGNER's WORDS, WAS READ AGAINST §1's TEXTS BEFORE THE RECONS**: it holds the fifteen no-engine runes'
words and none of the four modifier texts, the modifier, severity or bargain entries; the Vow of Silence, whose words name *Silence*,
is a rune and the Long Silence a modifier, two namespaces no reader resolves by name; and it read its row (314) on IO's tree.

**THE FOUR MEASURED THINGS, EACH AGAINST THE UNCHANGED TREE, AND WHERE THEY INTERACT.** `var/` holds four snapshots of the four
scripts IO touched — HEAD, §1 alone, §1 and §2, the tree — each read off the diff by hand and the last md5-identical to the tree but for the one no-op filter recon 1 found and IO
dropped after the arms ran (`heroes` holds no companion, so no figure moves).
**§1's re-cut and §2's re-grade interact by construction**: §2 grades the deck §1 made, so §2 has no arm on HEAD's deck and is read as
§1-then-§2 (§1f, §2e). **§3 shares no arm with §2** — rung 1, no modifier forced, on HEAD's tree — and **§4's refund moves no sim
figure** (dormant). Natural play on three rungs and untalented Ruin, every arm on its own seed block, and the forced arms on IO's tree;
§1f carries the table. **No two of §1's four meet in one fight**: a bargain carries one modifier, so their doors cannot interact.

**RECON 1 — HEAD's BATTERY ON IO's CODE AND DATA** (HEAD's runner, gates, documents, baselines and manifest; `check_io` not in it,
*IB recon*), the prediction written before launch: **154 targets, 16:30:38 to 17:55:30 — 84 min 52 s, most of it beside the controls and the readers**. As predicted: `test_batch_an` 6,020 / 34 (§3's pins — fifteen
*is severity N*, Rot twice, sixteen *ignores party composition*, *the test knows all of them*), `test_batch_bb` 167 / 1 (*Rot at
severity 4*), `check_in` 77 / 10 and three SCRIPT ERRORs (Famine's and Cruel Order's doors gone; the four of severity 5 by IN's names; *an existing modifier's severity moved*, all nineteen named; Wanderer's and Warden's offers against IN's model of the twenty, which the re-grade moved — §2's constraint 2; *300*; Wasting's enemy tick and the Dark's hero feed, both IN's one-sided arms), the two standing sanctioned reds (`check_cm_live` 13 / 5, its five lines; `check_gj` 70 / 1); the
harness 22 / 382 / 8; `check_parse` 230 / 0, `check_gw` 76 / 0; `check_de` 633 / 8, every red one of these. **Three readings the prediction did not carry, each read**:
- **`check_dj` 45 / 1 — the finding of this recon.** *The `is_companion`-over-`heroes` population is 28, not the 27 after GO*:
  Wasting's tick walked `heroes.filter(func(h): return not h.is_companion)` for the warband's foes, a filter over an array that holds
  no companion (DJ §1) — it records intent and does nothing, and `check_dj` §5 holds that population at 27 so a new one is seen. **A
  literal sweep cannot see it**: it is a count over a pattern, not a literal. **Dropped** (`ws_foes` is `heroes`); `check_dj` 45 / 0
  after, with `check_io`, `check_in` and `check_parse` at their rows; no figure moves.
- **`check_gp` 438 / 0, recorded 459 — a FALL, unpredicted** (the prediction named its road as uncertain). **Traced** — HEAD's gate,
  every `ok()` printed, on four trees: HEAD's code 459, §1 alone 459, §1 and §2 438, the tree 438. **§2's**: §4's per-card arm asserts
  once for each distinct card the no-engine road offers an engine-less hero, and the seeded road's bargains are dealt from the
  re-graded bands, so it meets other fights and other drafts — 67 distinct cards offered before, 46 after (and the two-engine road
  87 shown where it showed 70). No arm stopped running. **The row moved 459 → 438**, with the trace in its note — and **the first
  acceptance was stopped for it** (below).
- **`check_ed` 18 / 0, predicted red** — the prediction expected HEAD's manifest to hold the needles of Famine's and Cruel Order's
  doors; it never did: `check_in` reads them through `_body()`, a holder the manifest does not bind (FH §2's rule), so nothing was
  recorded to go missing.

**THE GATE-SOURCE READERS, OVER `check_io`'s FINAL SOURCE — TWENTY-SIX, BY THE TWO ROUTES, AND NO THIRD.** `check_ij` §0.4 derives
them: the 25 that open the root (`check_io` among them) and the three that read the battery's list (`check_gw`, `check_ij`,
`check_parse`). **A third route was looked for and is not there** (the variable-path walkers open `res://scripts`, `res://data` or a
readout folder; `check_ed` and `check_fr` read the manifest, regenerated; the gates that load another gate by its own path read a named
file). **Read after the last edit to `check_io`** (C11's and R02's arms; its md5 taken before and after the pass), with the document
gates `check_fg`, `check_fr`, `test_batch_bx`, `test_batch_ce`, `check_dv`, `check_hy` and `test_batch_an`: **all thirty-three read
0 failures, with no parse or script error** — `check_io` 126 / 0, `check_parse` 231 / 0, `check_ij` 49 / 0, `check_ed` 18 / 0 and
`check_gw` 76 / 0 with §2's *96 sites in 10 targets (ceiling 96)* unmoved (`check_io` hand-sets nothing `check_gw` counts), the
document gates at their rows (`check_hx` 39, `check_fg` 30, `check_fr` 25, `test_batch_bx` 163, `test_batch_ce` 931, `check_dv` 84,
`check_hy` 185), `test_batch_an` 6,054 inside its band. **The pre-run before it found one**: `test_batch_bx` §4b — *master.html says
hero or ally everywhere it is prose* — IO's severity paragraph said *what a modifier costs a party*; it says *the heroes* now.

**EVERY MOVED COUNT, ATTRIBUTED BY AN `ok()` TRACE** — HEAD's gate on HEAD's code and IO's on IO's, every assertion printed with its
verdict, the two lists diffed: **`check_in` 103 → 94** — §1e's nine arms (four source arms and five that drove Famine through the
button, the picker and the use path) became four (its door absent, the use path's guard, the bot's drink, the pouch open under every
modifier's terms); §1h's five (the Tracker's turn, three driven Cruel Order arms, the source) became three (the door absent, the hero
due first acting first under every modifier, the loop and the bar on the timeline alone); §1i lost Famine's and Cruel Order's text
arms; every other arm was replaced one for one. **`check_hu` 105 → 106**: §4a's *24 of 24 modifiers carry chip letters*. **`check_ih` 94 → 98**: §6's strip premise,
once for each of the four boards the walk lays it on. **`check_parse` 230 → 231**: one target more, `check_io`. **`check_de` 633 →
637**: four checks for that target. **`check_io` is new (126)**. **Every other count is unmoved** — the 28 files §6 edited hold the
`ok(` calls they held at HEAD and each read its row alone in its lane, before and after; `test_batch_an` and `test_batch_bb` were
re-pointed in place, each arm replacing the arm it repaired.

**THE CONTROLS — 33 on what IO built, four re-tunes, two HEAD arms**, each a fresh copy of the tree with one change and the gates it
aims at (`tools/controls_io.py`, every anchor count-asserted before it is written, every one dry-run first), each read by its FAIL
text, four lanes at once (`ctlrun.sh`). **§0.7's note binds them**: each breaks the door the gate's own predicate drives — the side a
tick reads, the door a heal goes through, the line a use is booked at — never a body the gate named; **§1's two-sided rules each get
a control that inverts the side, both ways** (C01–C04, C12).

| | the defect | what reds |
|---|---|---|
| C01 | Wasting on heroes only | `check_io` 126 / 3 — *Orc Raider (1,000, …) lost 0 — want 80*, the felled-by-nobody arm, the source; `check_in` 94 / 1 |
| C02 | Wasting on enemies only | `check_io` 126 / 2 — *Warden … lost 0 — want 80*, *a hero at 3 … did not fall*; `check_in` 94 / 2 |
| C03 | the Dark feeds enemies only (IN's door back) | `check_io` 126 / 4 — *Warden dealing to Orc Raider: 200 lost, the dealer fed 0 — want 100*, the drink arm and its positive arm (a drink of 0), the source; `check_in` 94 / 1 |
| C04 | the Dark feeds heroes only | `check_io` 126 / 2 — *Orc Raider dealing to Warden … fed 0 — want 100*, the source; `check_in` 94 / 1 |
| C05 | the Dark's heal through the riders (an owned heal) | `check_io` 126 / 2 — *the Mage 100 → 250 (Vigil's fork), the Last Word armed true, Reprisal's ledger 0 → 150*, the source |
| C06 | the Dark's heal booked as healing | `check_io` 126 / 2 — *Reprisal's ledger 100 → 400*, the source |
| C07 | Wasting as a strike (`take_hit`) | `check_io` 126 / 5 — both sides *lost 0 — want 80* and *ate into the barrier*, the tick door; `check_in` 94 / 3 |
| C08 | no tick where a Broken turn ends | `check_io` 126 / 1 and `check_in` 94 / 1 — *calls the tick 4 times, want 5* |
| C09 | Wasting deals under the frame it found | `check_io` 126 / 3 — *Orc Raider … fell true and the Reaver standing in the frame before it was credited 1 kill(s)* |
| C10 | Wasting ticks on the turn that decided the fight | `check_io` 126 / 2 — *took 80 from a hero on the turn that won the fight*, *from an enemy on the turn that lost it*; `check_in` 94 / 1 |
| C11 | a companion wastes | `check_io` 126 / 1 — *Pyromancer, read as a companion, wasted 11* (the arm rebuilt first: below) |
| C12 | the Thin Veil on the heroes only | `check_io` 126 / 2 — *the Attack moved wrong on ["Orc Raider 102→102 (want 153)", …]*, the source |
| C13 | `ability_ready` does not ask the Silence | `check_io` 126 / 1 — *Crushing Blow cast under the Silence: booked ["Crushing Blow"], ready true* (the usability door still asks, so the bot's picks stay clean: defence in depth) |
| C14 | the enemy's re-validation does not ask | `check_io` 126 / 2 — *Orc Raider's spent Sundering Strike is usable at re-validation*, the source |
| C15 | the basic not exempt | `check_io` 126 / 3 — *the basic attack (Strike, the Warrior's slot 0) was refused*, the bot's picks, *0 of 12 heroes kept their basic* |
| C16 | a Psychosis support pick does not ask | `check_io` 126 / 1 — *Orc Raider's Psychosis support pick read ["IO Probe Wave", "Warden"] … after (spent true)* (the arm added before the controls: below) |
| C17 | the declaration does not ask | `check_io` 126 / 1 — *Orc Raider declared a spent ability 13 times in 20* |
| C18 | the spend line books nothing | `check_io` 126 / 4 — the hero's booking, the hover, the enemy's re-validation and the Psychosis pick |
| C19 | Famine back in the deck | `check_io` 126 / 6 and `check_in` 94 / 3 — *`famine` (Famine) is still in the deck*, the counts *{ …, 5: 5 }*, the name in `run_state.gd`, `master.html`'s row |
| C20 | `ROUND_TICKS` back as a dead constant | `check_io` 126 / 1 — *the removed pair is still named: ["ROUND_TICKS in scripts/battle.gd"]* |
| C21 | the button prints the list price | `check_io` 126 / 4 — *Crushing Blow's button reads 'Crushing Blow   20 Rage' (disabled true) — want the door's 25*, the partition, the source |
| C22 | the summon picker prints the list price | `check_io` 126 / 3 — *'Summon Ursus   20 Mana' (want 25)* ×3, the partition, the source |
| C23 | Through and Through refunds the list price | `check_io` 126 / 3 — *{ "warded": [20, 25], "free": [20, 0] } (refund, paid)*, the partition, the source |
| C24 | the chip wears ◆ | `check_io` 126 / 1 — *overgrown: words ["◆ BARGAIN", …], wears ◆* … |
| C25 | the strip runs into the combat log | `check_io` 126 / 1 — *over the turn strip or the log [P: (849, 29), S: (260, 16)]*; `check_ih` 98 / 1 — *The Hungering Dark, the modifier with the longest name (18 characters) … runs past its container* |
| C26 | Wasting wears Bleed's letters | `check_hu` 106 / 1 — *two statuses wear one tag: ["bl: [\"modifier:wasting=Bl\", \"bleed=Bl\"]"]* (`check_io` §5 holds the modifiers' letters among themselves and the walk to `check_hu`: 126 / 0, as designed) |
| C27 | the counts broken (Hoarfrost 1 → 2, its row with it) | `check_io` 126 / 1, `check_in` 94 / 1, `test_batch_an` 2 — *six severity-1 modifiers (got 5)*; `test_batch_bb` 167 / 0 (it holds severity 4's four) |
| C28 | a severity-5 modifier reaches Warden | `check_io` 126 / 4, `check_in` 94 / 4 — *warden dealt 397 severity-5 options*, *0 of 400 dealt as IM dealt them*, *Ruin reads 4.49 against Warden's 3.62* |
| C29 | the fixed encounters reach severity 5 | `check_io` 126 / 1, `check_in` 94 / 2 — *400 fixed draws at Ruin read [… "wasting"]* |
| C30 | severity 5 back at 300 | `check_io` 126 / 1, `check_in` 94 / 2 — *the steps are [40, 60, 80], growing by 20, so the next is 100 and the row 320*, the entry |
| C31 | the Dark's row in `master.html` at 5 | `check_io` 126 / 1, `check_in` 94 / 1 — *no row at its grade for ["The Hungering Dark 1"]* |
| C32 | Wasting's text types 6% | `check_io` 126 / 1 — *`wasting` does not state 8% off `WASTING_PCT`* |
| C33 | IO's cut at the archive's foot (IM's error) | `check_io` 126 / 2 — *the archive's 18 cuts are not newest first: ["IO after HX"]*, *the first cut is IN* |
| R01 | **re-tune**: Wasting at 6% | `check_io` 126 / 0, `check_in` 94 / 0, `test_batch_an` 6,055 / 0, `check_ih` 98 / 0, `check_hu` 106 / 0 |
| R02 | **re-tune**: the Dark at 30% | **`check_io` 126 / 1 at first — the finding of this pass, below**; after the repair 126 / 0; `check_in` 94 / 0 |
| R03 | **re-tune**: the Veil at 40% | `check_io` 126 / 0 |
| R04 | **re-grade**: Hoarfrost 1 ↔ Parched 2, the counts kept, `master.html`'s two rows moved with them | **every one of fifteen grade readers green** — `check_io` 126, `check_in` 94, `check_im` 122, `check_il` 86, `check_hw` 65, `check_hs` 83, `check_ih` 98, `check_hu` 106, `test_batch_an` 6,056, `test_batch_bb` 167, `test_batch_bn` 80, `check_ij` 49, `check_fh` 167, `check_gf` 104, and `check_gj` 70 / 1, its sanctioned red to the character (*+153 gold and the purse moved 173*) |
| H01 | HEAD's `scripts/` and `data/` under IO's gates | `check_io` 93 / 26 and five SCRIPT ERRORs (the constants, the strip and the doors absent), `check_in` 94 / 15, `check_hu` 106 / 1 (the letters), `check_ih` 94 / 1 and four (the strip), `test_batch_an` 1 (the four by name) — **every gate IO re-pointed reds on HEAD's code by what it re-pointed**; `check_ie` and `test_batch_bb` green (named, not re-pointed; a grade the ladder holds holds at HEAD too) |
| H02 | HEAD's documents under IO's gates | `check_io` 126 / 7 — `master.html`'s rows and the two removed, the archive's top, the three rulings' headings; `check_in` 94 / 1; `check_im`, `check_ij`, `check_hx`, `check_hu`, `test_batch_bb` green |

**R02 IS THE FINDING OF THIS PASS.** `check_io` §1c's rider arm set the Warrior at 20% of his health, so the Dark's drink crossed the
Last Word's quarter only at a half: at 30% the drink of 180 stopped short of the line and the positive arm read the riders dead — the
arm was tuned to the figure it reads. **It sits one point under the line now, read off `BattleUnit.LAST_WORD_AT`**, so any heal at all
crosses it; R02 and the clean tree both read 126 / 0 after. **And C11 first bit through a throw**: the companion arm built a bare
`BattleUnit` with no bars, so a broken guard threw before its FAIL printed; it reads a body on the board as a companion for the tick
now, and C11 reds by its line alone. **And before the controls ran**, §1e's Psychosis door had no arm that drove it (C16 would have
read green) and the enemy's spent move was marked by hand (a gate arranging its own subject): the first is a driven arm now, the
second a real cast through the spend line — C16 and C18 bite on both.

**THE ACCEPTANCE**, on the frozen tree (`freeze.sh`, every file md5'd before and after, `.godot`, `.git` and `save-backups/` aside),
in the repo, every row of `ps` logged every 15 s (`pslog.sh`), **the pre-pass beside it in a fresh copy** (*IB work*), each predicted
before launch. **The first launch was stopped at 50 targets** (every one at its row) when recon 1 read `check_gp` 438 against its 459
row; the row moved with its trace, the tree was frozen again and both were relaunched. ****155 targets each — the acceptance 18:02:20 to 19:28:26, 86 min 6 s; the pre-pass 18:02:20 to 19:28:33, 86 min 13 s (IN: 154 in 84 min 27 s).**** **Both read `check_de`
637 / 0 / 0**, every target at its row to the check — `check_io` 126, `check_in` 94, `check_hu` 106, `check_ih` 98, `check_parse` 231, `check_gp` 438, `check_dj` 45, `check_ed` 18, `check_gw` 76 (*96 sites in 10 targets, ceiling 96*), the 28 files §6 edited at their rows, the two banded suites inside their bands (`test_batch_an` 6,052 and 6,049, `test_batch_bk` 131 and 130), and the two runs identical row for row but those two — the two standing sanctioned reds to the character in both runs
(`check_cm_live` 13 / 5, its five lines HEAD's; `check_gj` 70 / 1, *+153 gold and the purse moved 173*, HEAD's gate on HEAD's code
reading *+168 … 188* beside it — the re-grade's), the harness 22 / 382 / 8. **The tree did not move**: 555 files md5'd before and after, identical. **The
player's files did not move**: md5-identical before and after, and to IO's backup. **Every row of `ps` was read** — 344 samples, 18:02:20 to 19:28:22, 651 Godot rows: every one a headless battery target of the two runs, no game window and no stray process.

**AFTER THE ACCEPTANCE, TWO COMMENTS** — a gate's words are an asserted surface — **were corrected and read again**: `check_hy` §6's census row and `check_in`'s header still described Wasting as a hero's tick (HY's rule: a present-tense claim naming what IO touched). Neither is a needle (the manifest current, unchanged); `check_hy`, `check_in` and the twenty-five other gate-source readers read them at their rows, 27 of 27, no parse or script error.
