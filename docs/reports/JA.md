# Batch JA — the shares, before the four

**On `class-merge`, after IZ (`1a276cd`). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `1a276cd6`, IZ's push and local
HEAD, before anything ran (2026-10-29 22:04). **The designer's files were backed up first** (`../save-backups/JA-20261029-220449`,
22:04:49, byte-identical to IZ's backup by `diff -r`) and read only through copies — md5s at the open and the close, §6.

**What shipped.** **Frenzied is Leaden** (§1): the card states what it does, *Everyone acts about 30% more slowly, and the slower a
body already is the more it loses. Cooldowns are unchanged.*, its constant is `LEADEN_SPEED_ADD`, its figure and floor are unmoved, IZ's
drive reads 23 of the first 48 turns again, and the id stays `frenzied` because the project has no rename path for a modifier id and
this batch was told not to invent one. **Fleeting takes three turns off and is a 2** (§2): sixty runs paired against a re-driven
baseline read +2.29 ± 0.26, and its words are the code's by the designer's choice, *Every status applied lasts 3 turns less (never
below one).* **The census grade 4 waits on is taken** (§3): what each side produces of every quantity a rule can key on, on both
parties, over 80 runs and 2,217 fights, with its fidelity stated and the practice written beside IP's rule. **The axis table** (§4)
crosses the deck with it: grade 4 holds health alone, and healing, resource and recoil reach 5 with no 4. **`test_batch_cb`'s coin
flip is repaired** (§5): the arm reads the bank, 2107 / 0 five runs of five on one tree, and it reds on a skim where HEAD's arm did
not. **No modifier was authored and no other grade moved.**

**Three findings reach past this batch, each in NEEDS A RULING or FOUND AT JA**: a share is not a sign (every one of the deck's 21
modifiers costs the party, those keyed on what the warband holds more of among them, so IP §0.2's sentence over-reads); Thin Air and
Encumbered bind the party alone as the deck plays; and the party is the faster side of the field, not the slower, so IZ's drive and
the brief's reading of it need a different explanation. **Six of the brief's premises did not hold** (§0, FOUND AT JA).

**THE VERDICT**: **SHIPPED, AND VERIFIED. The card says what it does, Fleeting's grade 2 is paid for, and the inputs grade 4 waits on are in.** The acceptance reads `check_de` 685 / 0 / 0 with only the two sanctioned reds, recon 2 and the acceptance each held every line of their predictions, and all twelve controls bit. **Leaden's id stays `frenzied`**: the project has no rename path for a modifier id. **Three rulings are owed** (NEEDS A RULING), and grade 4's four remain the designer's. **`docs/state.md` grew faster than the archive cut**, 2.9 batches of room at the honest rate.

## §0 — THE BRIEF's PREMISES, VERIFIED (`CLAUDE.md`: verify the brief against the repo)

Read against `docs/state.md`, `docs/reports/IZ.md`, `IZ-reread.tsv`, `IZ-rekey.tsv`, `IZ-grades.tsv` and `IZ-fire.tsv`, IY's and IX's reports where they are cited, and the code, before anything ran — and where a premise is a measurement, against JA's own.

| # | the brief says | verdict |
|---|---|---|
| 1 | the deck is whole: twenty-one, every one graded — 1×7, 2×4, 3×4, 4×2, 5×4 | **True** — `Run.MODIFIERS` holds 21, `IZ-grades.tsv` grades each, the tally IZ's. |
| 2 | *nine batches ago* eleven of twenty-three cost nothing the instrument could read | **The count is IX's, three batches back** (IX → IY → IZ → JA): `IX-scale.tsv`'s *costs nothing* is eleven of twenty-three. |
| 3 | one hole is left, grade 4, the two modifiers every Warden offer deals as its gambles | **True** — Warden's gamble band (4–4) holds Rot and Overgrown. |
| 4 | three have failed the same test — the Dark, Tinderbox and Dull Edge — each binding both sides and paying one | **Two paid the party** — the Dark (0.989 against 0.951, IO) and Dull Edge at its floor (-0.54 ± 0.24, IY §2); **Tinderbox read a tie** on its own population (+0.24 ± 0.23) and left by the stop condition. They failed different tests: a gift, a slope worth 0.15 points per ten points of crit, and no reach. |
| 5 | IZ's drive says *the subtraction costs the party, the addition pays it, so the party is on the slow side of the field* | **The first half is IZ §4's; the inference does not hold**: JA §3's census reads the heroes FASTER at their turns — 98.5 against the warband's 90.8 on the reference party, 116.8 against 92.2 on the incumbent — so a flat amount takes the larger share of the warband's speed, and the subtraction costs the party anyway (FOUND AT JA). The card's words are true of the mechanic. |
| 6 | a save carries a modifier's id, not its display name | **True** — `pending_modifier` and an offer's options name ids; `Run._drop_stale_offer_options` drops an id the deck does not hold. |
| 7 | *if the project has a rename path for a modifier id* | **It has none**: the load door's one rename map is `Run.RENAMED_CARDS` (cards), and nothing maps a modifier id. **The id stays `frenzied`** and the display name moved alone (§1) — no path invented. |
| 8 | IT §2a: a constant's name says what the figure is, named for its card; IJ's rule: the figure reads its constant | **True** — `CLAUDE.md`'s text-standard bullets; the card's `desc` formats `LEADEN_SPEED_ADD` inside its `const` (*a table the code holds formats its figure inside its const*). |
| 9 | IZ reverted Fleeting to 1 by the revert rule; Fleeting at 3 reads +3.10 ± 0.32, a grade 2 | **True** — IZ §2; IZ's stage B (`A_fleeting3`, +3.0962 ± 0.3160), inside 1.78–3.74. |
| 10 | at -3, with the same floor, *every effect lasts one turn* | **Does not hold** (JA §3's census of the status door): of the statuses that pay the party, laid for a positive count, **8.2% on the reference party and 6.1% on the incumbent ran five turns or more** and keep all but three; the battle-long ones (Chilled from a hold, a barrier, Snared, Ruin) are untouched. **The designer chose, asked in conversation: the value 3, the card's words the rule's** — *Every status applied lasts 3 turns less (never below one).* |
| 11 | the deck becomes 1×6, 2×5, 3×4, 4×2, 5×4 | **True on JA's reading** — Fleeting a 2 in the deck (§2). |
| 12 | IZ's slopes put grade 4's 8.84 at 83 Bleed, eight turns off every status or +34 initiative | **83 and eight are IZ's two-point arithmetic** (82.7 Bleed off 15 → 45; 8.3 turns off 1 → 3); **initiative reads +30 off IZ's 0.5 and IY's 1.5** (+36 off IY's own pair) — the order of magnitude, not 34. |
| 13 | Warden's band: Wanderer's bands end its bargain fights +5.78 ± 2.16 kinder (z 2.68), the gambles over six instead of two | **True** — `IZ-band.tsv`; six on IZ's deck. |
| 14 | §0.5's six premises that did not hold at IZ | **Each is IZ's report §0, word for word** (rows 2, 5, 6, 4, 9, 10). |
| 15 | IZ's gate drives a real board: 23 of the first 48 turns change hands, where a factor moved none | **True** — `check_iz` §4, IZ's C05; re-driven on the renamed tree by `check_ja` §1 and `check_iz` §4. |
| 16 | IO measured damage at 6.06:1; IZ fire at about 12:1 | **6.06 is IO's feed probe** (the Dark fed the heroes 117,266, the warband 19,336 — healing in proportion to damage dealt); **12:1 is the fire party's** (11.7; the reference party's was 5.2). JA's door reads 6.30 and 7.10 (§3). |
| 17 | Tinderbox *fed them* | **It read a tie** (+0.24 ± 0.23): *fed* is IZ's reading after the verdict (the heroes dealt about twelve times the fire), not a measured gift. |
| 18 | the Dark was a gift *and IX §2d found a second mechanism — a longer fight pays the side with sustain* | **IX §2d PRE-REGISTERED that shape and found it on none of fourteen halves**; what it found instead, not pre-registered, was the party's healing taking up what a tempo half costs — and IY §3 did not confirm that either. |
| 19 | grade 4 holds health alone (Rot's halved maximum, Overgrown's 70% opening), *every other axis stops at 3 or below* | **The first half is true; the second is not**: healing (Bloodless), resource (Thin Air) and recoil (Mirrorbound) reach 5 with no 4 (§4). |
| 20 | IZ added no folder; `CLAUDE.md` 485.08 KiB with 24.92 under, `docs/state.md` 350.33 with 29.67 | **True** — 611 user-data folders at IZ's open and close, 611 at JA's open; both sizes IZ's close's. |

## §0 — THE RULINGS, AND WHERE EACH IS WRITTEN

- **§0.1 — FRENZIED BECOMES LEADEN**: built (§1), the card's words as the brief gave them, the constant renamed with the card. **The id:
  no rename path exists for a modifier id** (IR §2's map renames cards in a save), so the id stays `frenzied`, as the brief said to do
  in that case, and a line beside the row says why. **The chip tag** moved to `Ld`, the designer's answer in conversation, since the
  old tag no longer spelt the card.
- **§0.2 — FLEETING GOES TO 3**: built and measured in the deck (§2), the deck 1×6, 2×5, 3×4, 4×2, 5×4. **The designer's second answer
  in conversation**: the brief's *every effect lasts one turn* is true only of a status of four turns or fewer, the floor being one, so
  the card states the rule the code keeps, *Every status applied lasts 3 turns less (never below one).* (§2 says how many statuses each
  reading covers.)
- **§0.3 — GRADE 4's FOUR ARE THE DESIGNER's**: none authored; §3 and §4 are the inputs, `docs/state.md`'s THE SHARE CENSUS and JA's
  RULINGS OWED 3.
- **§0.3's practice, *A NEW MODIFIER NAMES THE TWO SIDES' SHARES OF ITS QUANTITY BEFORE IT IS BUILT***: `CLAUDE.md`'s ladder block,
  beside IP's two-sidedness rule (`check_ja` §0).
- **§0.4 — WARDEN's BAND STAYS**: not touched (`check_ja` §0 holds the bands).

## §1 — LEADEN

**Built as §0.1 gave it** (`edits/apply_leaden.py`): the display name **Leaden**; the card's two clauses, *Everyone acts about 30% more
slowly, and the slower a body already is the more it loses. Cooldowns are unchanged.*, its figure formatted off the constant inside
its `const` at the average speed of 100 (IJ's rule, IZ's convention); **`FRENZIED_SPEED_ADD` → `LEADEN_SPEED_ADD`** (IT §2a); the
stamp writes it; five comments in `battle.gd` and `unit.gd` and the glossary's initiative entry (*a fight that starts with everyone
Chilled or Leaden*) name the card as it is. **The id: the project has no rename path for a modifier id** — the load door's one map is
`Run.RENAMED_CARDS`, the cards', and a save's offer and `pending_modifier` name a modifier by id — **so the id stays `frenzied`** and the
display name moved alone, the branch §0.1 gave for this case; no path was invented, and the id is the old name's one live survivor
(FOUND AT JA). **The chip's letters**: the brief moved no other word, and the card's chip still read Frenzied's `Fr`; **asked in
conversation, the designer moved it to `Ld`** (swept: no status or modifier chip wears Ld in any case, `check_hu` §4a's walk green).
**No magnitude moved**: -30, the floor at a tenth of a unit's own speed (`MOD_SPEED_FLOOR`), the severity 1 and its source
(*the default four — IZ §4*). **IZ's drive, again on the renamed tree** (`check_ja` §1, through `turn_order`, the model `check_iz`
§4 wrote, made a static function there and read by preload so both drives read one copy — not moved into the fixture, because
touching `gate_fixture.gd` would oblige repairing a MISSES row the brief leaves standing (`check_iu` §5)): **23 of the first 48 turns change hands**, as IZ read them; and a
subtraction past every speed leaves each unit at a tenth of its own, never a stall. **The old name swept** (`check_ja` §1, its needle
built at run time so the gate holds no copy): every file of the game's code and data, every gate and suite, the rule files and the
living documents names it only on a line that names Leaden beside it — the rename's own record — or as the warband whelp's *Frenzied
Nip*, an enemy ability that shares the word and is not the card. Records keep it: the changelog, the design notes, the reports, the
archive, the recon and audit documents and `baselines.json`'s notes.

## §2 — FLEETING AT 3

**Built** (`edits/apply_fleeting.py`): `FLEETING_TURNS` 1 → 3; the severity the in-deck reading gives (2) and its source, *the default
four — JA §2*. **The words are the code's, by the designer's choice in conversation** (§0): the template has always formatted the rule
at its value, and at 3 it reads *Every status applied lasts 3 turns less (never below one).* — the brief's *every effect lasts one
turn* was its reading of three off with a floor of one, and **§3's census of the status door says it is not the rule**: of the
statuses that pay the party, laid for a positive count, **8.2% on the reference party and 6.1% on the incumbent ran five turns or
more** (Mocked, Hunter's Mark, Unity, Renewal, Primal Surge, Consecration) and keep all but three of them, and the battle-long ones —
Chilled from a hold, a barrier, Snared, Ruin — are untouched (`docs/reports/JA-durations.tsv`). The designer was asked with the
census in hand and chose the true sentence over the short one.

**Measured in the deck** (`s1/PREDICT_S2.md`, md5 `ccf8d8e9…`, written before): JA's code tree with IX's four probe parts byte for byte,
the reference party untalented at Wanderer, block 38, fight-seeded, sixty runs an arm, every bargain forced, paired by seed against a
re-driven *none* arm (`docs/reports/JA-fleeting.tsv`):

| the arm | runs (completed) | reading | the cost | z | ratio | the lever point (IZ, IY's deck) | the tie | band |
|---|---|---|---|---|---|---|---|---|
| *none*, re-driven | 60 (58) | 0.940645 ± 0.004130 | — | — | — | — | — | — |
| Fleeting at 3 | 60 (58) | 0.917791 ± 0.004734 | **+2.29 ± 0.26** | +8.75 | 0.416 | +3.10 ± 0.32 | **z -1.98** | **2** |

**A 2, as the lever point said**, and **a tie with it by the test — at its edge** (z -1.98): two readings of one quantity, on two
decks (IZ's lever point was taken on IY's tree, with Dull Edge and Tinderbox still in it and the re-key not yet built), **and the
in-deck one is the grade's** (§0.1's rule at IZ). The *none* arm reads 0.941, a tie with IZ's 0.934 (z 0.93) — the deck since IZ moves
what the offers pay, so a re-driven baseline was owed and taken. A bargain fight under Fleeting at 3 runs 1.97 hero turns longer and
the party heals 37.7 less in it. **The deck holds none 0; 1 6; 2 5; 3 4; 4 2; 5 4** (`docs/reports/JA-grades.tsv`, the grades of
record — IZ's carried forward but for Fleeting's row and the renamed card's name and constant; `check_iz` §2 re-derives it). **The
prediction**: 5 of 6 — the cost under the predicted +2.4 to +3.8, the grade, the tie, the ratio, the completions and the baseline right.

## §3 — THE SHARE CENSUS

**The method is IZ's probe five, over every ledger a rule could key on** (`tools/ja_probe6.py`, part six over IX's four parts — md5s
as IZ's): BL's damage door (the source off the attribution frame), the tick door, the hero strike loop (blows, hits, crits, fire,
armor's cut), its two miss rolls and its Block, the heal door, a barrier's absorb, Break at `take_hit`, Bleed, deaths, the status door
— before Fleeting's term, each application's turns bucketed, sorted by whom it pays off the game's own `DEBUFF_IDS` and
`DISPEL_NEVER` — cooldowns started, the line every cast pays at, the turn-start drip, every turn the loop hands out (the actor's speed
and maximum health), and the bodies standing as a fight opens. **Read-only, no modifier stamped** (`DOD_IV_FORCE=none`): a sum a side,
printed once a fight. **Fidelity**: a census-on, census-off pair (three reference runs) read 4,054 probe lines identical; 0 Parse Error
or SCRIPT ERROR in any log. **The parties**: the reference four, untalented, Wanderer, 20 runs, block 38, fight-seeded — 559 fights,
234 of them bargain fights; the incumbent — IG's three parties, talented, Ruin, 20 runs each, block 21, fight-seeded — 1,658 fights,
698. **The population is derived**: every quantity a live modifier keys on (each of the 21 is named on its row, `check_ja` §3 holds it
to the deck) and the doors' others. Kept: `docs/reports/JA-shares.tsv`, `JA-durations.tsv`.

**What the ledgers cannot see, stated**: the strike ledger is the blow computed — before a barrier (the party's ate 60,507 on the
reference party, most of the 68,140 between the warband's strike damage and its damage at the door), a death refusal or the vow — and
holds no companion's blow (`_companion_hit`) and no special that resolves outside the loop; the armor row is the loop's site alone
(about twenty other sites in the specials take armor off their own figures); the door's source is the frame's, and an unframed blow
(3,263 on the reference, 452 on the incumbent) and own-side damage (a health cost, the warband's on itself) are apart; a status is
sorted by the two lists, so a hero-laid enemy status in neither would be filed as the warband's; and every figure is the bot's play.

**Heroes : warband, what each produced, every fight** (bold: inside 2:1 or the warband's; the bargain fights alone read the same way but for three on the reference party, hits 2.30, turns taken 2.09 and misses 2.03, which cross 2:1, `JA-shares.tsv`):

| quantity | keyed by | reference party | incumbent |
|---|---|---|---|
| damage dealt (the damage door) | Feverish, the Thin Veil | 6.30 | 7.10 |
| strike damage (the hero strike loop) | Mirrorbound | 3.42 | 4.67 |
| tick damage, dealt | — | 4.34 | 4.53 |
| hits landed | Bloodletting | **1.89** | 2.89 |
| crits | — | 3.07 | 10.48 |
| fire-typed strike damage | — | 5.44 | 14.16 |
| armor's cut, held | Brittle | **0.31** | **0.57** |
| healing received | Bloodless, Miasma | 7.93 | 15.36 |
| barrier absorbed | — | heroes alone | heroes alone |
| Break damage, produced | Muffled | **1.26** | 4.26 |
| Breaks, produced | Deadened | 2.07 | 25.29 |
| Bleed built, produced | Bloodletting | heroes alone | heroes alone |
| bleedouts, produced | — | heroes alone | heroes alone |
| kills | — | 21.09 | 25.72 |
| turns taken | Slick Footing, Hoarfrost | **1.88** | 2.05 |
| mean speed at a turn | Leaden | **1.08** | **1.27** |
| turns weighted by maximum health | Wasting | **1.20** | **1.07** |
| maximum health standing as a fight opens | Rot | **0.67** | **0.59** |
| health standing as a fight opens | Overgrown | **0.65** | **0.56** |
| resource held as a fight opens | Parched | 189.82 | 310.47 |
| resource returned at turn start | Thin Air | heroes alone | heroes alone |
| resource paid for casts | Warded | 41.97 | 49.11 |
| cooldown turns started | Encumbered | heroes alone | heroes alone |
| casts not of slot 0 | the Long Silence | 4.21 | 6.02 |
| casts | Slick Footing | 2.07 | 2.82 |
| misses, made | — | **1.62** | **warband alone** |
| Blocks, made | — | 2.19 | 3.32 |
| status-turns, paying each side | Fleeting | 8.25 | 13.95 |
| status-turns Fleeting at 3 takes | Fleeting | 9.56 | 13.46 |

**THE PREDICTION, GRADED** (`s1/PREDICT_S3.md`, md5 `0e565f06…`, written before the drive; two fights' lines of a one-run smoke seen):
**16 of 27 right on both parties, 8 on one, 3 wrong** — wrong: Wasting's clock (1.20 / 1.07, near even, not heroes 2–5×), the Blocks on
the reference party (the heroes block more, 2.19), and the share of five-turn statuses (8.2% / 6.1%, under the 10–40% predicted — the
conclusion it carried, that *every effect lasts one turn* is false, held); right on one party only: strike damage, healing, Break
damage, Breaks, the speed (the incumbent's 27% past 20%), casts not of slot 0, armor, misses. **The questions**: the first predicted
*nothing a bargain could charge the party for without feeding it* and **was wrong** — health, armor, tempo and turn order are near
even or the warband's; the second partly right; the third — that a bonus on damage costs the party though the heroes produce it six
times over — **right**; the Dark — its sign follows its share — **right**.

**THE THREE QUESTIONS, ANSWERED.**
1. **What the warband produces more of, or as much of**: **the health on the field** — it fields 1.5 to 1.8 times the party's maximum
   and opening health on both parties (Rot's and Overgrown's quantities); **the armor that takes off blows** — 3.2 times the party's on
   the reference party, 1.8 on the incumbent (Brittle's); and inside 2:1, **the turns, the speed at a turn and the turns weighted by
   health** (Slick Footing's, Hoarfrost's, Leaden's and Wasting's), and on the reference party **the hits and the Break damage**
   (Bloodletting's, Muffled's). **Everything else the heroes produce twice over or more** — damage 6.3 / 7.1 times at the door, healing
   7.9 / 15.4, crits 3.1 / 10.5, fire 5.4 / 14.2, statuses that pay them 8.3 / 14.0 — **and four quantities a live modifier keys on the
   warband produces none or nearly none of**: the turn-start drip (none — the drip is `_player_turn`'s), cooldowns (none — no enemy
   ability carries one), the resource held (190 / 310 times) and paid (42 / 49 times). **Thin Air and Encumbered bind the party alone as
   the deck plays**, and Parched and Warded nearly so — AQ's rule reads their words, the census their effect (NEEDS A RULING 1).
2. **Inside 2:1**: on both parties, the speed at a turn (1.08 / 1.27), Wasting's clock (1.20 / 1.07), the health on the field (0.67 /
   0.59, 0.65 / 0.56) and, on the incumbent, the armor (0.57); on the reference party, the turns (1.88), the hits (1.89), the Break
   damage (1.26) and the misses (1.62).
3. **Does the sign matter the way the three failures suggest — A SHARE IS NOT A SIGN.** Every one of the 21 live modifiers costs the
   party. The penalties on what the heroes produce most of cost it, as the failures suggested — Bloodless, Miasma, Thin Air, Parched,
   Warded, Encumbered, the Long Silence, Fleeting, and Muffled and Deadened on the party whose plan is Break (Muffled reads free on the
   reference party, whose Break damage is inside 2:1 — the pattern's own confirmation). **But so do the penalties on what the warband
   holds more of** (Rot, Overgrown, Brittle) **and both bonuses on the damage the heroes deal six times over** (Feverish, the Thin
   Veil). The two rules ever recorded paying the party were **a payout landing on the party's health in proportion to what it produces
   more of** (the Hungering Dark: healing off damage dealt, 6:1) and **a penalty taking more of the warband's damage into the party than
   of the party's out** (Dull Edge at its floor: the warband's crits were costing the party more than its own paid it). **The pattern,
   stated as a prediction a later batch can break**: *on the party's health at a fight's end, a two-sided rule costs the party when it
   adds to the warband's damage into the party, or takes from what the party absorbs it with, whatever the shares; the share sets how
   much of that the party's own output offsets — and the offset is weak: a bonus to both sides' damage costs the party about a tenth of
   a point a percent of it (Feverish 3.15 at 25%, the Thin Veil 4.75 at 50%, blows and ticks).* **What it means for the four**: a grade-4 rule costs the
   party by what it does to the warband's pressure on the party's health; the shares say whom it touches, and a rule keyed on a
   quantity only the heroes produce is one-sided whatever its words say.

**THE DARK IS NOT THE CENSUS's LIMIT; FEVERISH IS.** The Dark's sign follows its share — healing proportional to damage dealt lands on
the very quantity the instrument reads, and the heroes produce six times the damage — so the census predicts it. **IX §2d is not the
second mechanism the brief named**: it pre-registered *a slower fight pays the side with sustain* and found it on none of fourteen
halves. **The limit is Feverish's**: by shares alone a bonus on a quantity the heroes produce six times over is a gift, and it costs.
A share is a fact about who produces a quantity; the instrument reads what the quantity does to one side's health, and the census
cannot read that.

## §4 — THE AXIS TABLE

**Derived from the deck** (`tools/ja_axes.py`, each grade read off `Run.MODIFIERS` in the code tree; `docs/reports/JA-axes.tsv`, held
by `check_ja` §4 to the deck and to the census): one row an axis, every modifier on one.

| axis | the modifiers at their grades | top | holds a 4 | its quantity: reference / incumbent | a two-sided candidate |
|---|---|---|---|---|---|
| health | Overgrown 4, Rot 4, Wasting 5 | 5 | yes | maximum health standing as a fight opens: 0.67 / 0.59 | yes |
| healing | Miasma 3, Bloodless 5 | 5 | no | healing received: 7.93 / 15.36 | no |
| resource | Parched 2, Warded 2, Thin Air 5 | 5 | no | resource held as a fight opens: 189.82 / 310.47 | no |
| damage | Bloodletting 1, Brittle 2, Feverish 2, the Thin Veil 3 | 3 | no | damage dealt (the damage door): 6.30 / 7.10 | no |
| recoil | Mirrorbound 5 | 5 | no | strike damage (the hero strike loop): 3.42 / 4.67 | no |
| Break | Muffled 1, Deadened 3 | 3 | no | Break damage, produced: 1.26 / 4.26 | yes |
| status duration | Fleeting 2 | 2 | no | status-turns, paying each side: 8.25 / 13.95 | no |
| tempo | Hoarfrost 1, Slick Footing 1 | 1 | no | turns taken: 1.88 / 2.05 | yes |
| the turn order | Leaden 1 | 1 | no | mean speed at a turn: 1.08 / 1.27 | yes |
| the hand (the draft's cards) | Encumbered 1, the Long Silence 3 | 3 | no | casts not of slot 0: 4.21 / 6.02 | no |

**Confirmed and corrected**: **grade 4 holds health alone** (Overgrown, Rot) — the brief's expectation; **but not every other axis
stops at 3 or below**: healing (Bloodless), resource (Thin Air) and recoil (Mirrorbound) reach 5 with no 4; damage, Break and the hand
top out at 3, status duration at 2, tempo and the turn order at 1. **The axes with room at 4** are every axis but health. **Crossed with
§3**: an axis is a candidate for a two-sided rule only where the warband produces its quantity too — **health and the turn order on
both parties, tempo and Break on the reference party, and inside damage its armor on both and its hits on the reference party**; **healing, resource, status duration
and the hand are the party's quantities** (the warband produces a quarter to none of them), so a rule there binds one side whatever
its words. On §3's pattern, a candidate is where a rule touches both sides; whether it costs the party a 4 is what it does to the
warband's damage into the party, which the census cannot price and a drive will. **The crossing reads every fight**: on the bargain
fights alone the reference party's tempo (turns taken 2.09) and hits (2.30) sit just past 2:1, so those two candidates are the thinnest.

## §5 — `test_batch_cb`'s COIN FLIP

**Repaired by the first of IZ's two options — the bank, asserted where the card reads it** (`edits/apply_cb.py`). Pyre Wake reads the
target's Burn turns, removes the Burn whole, scatters one fresh fire a turn consumed onto a random living enemy, and refunds one Mana a
turn consumed through Overburn's one door (`_overburn_refund`, read off the bank before a fire is laid). **The arm read `deep`'s Burn
after the scatter and asked it be under nine** — every one of the nine fires the dice sent back to `deep` (one cast in 512 on two
bodies) read nine and red it on a correct card. **It now reads the refund**: the bar given room (40 of 100, so the refund is never
clamped), nine back less the card's 25 — *the bank is emptied rather than skimmed: all nine turns consumed, refunded a Mana each*. The
total arm beside it (all nine landed again, on the two bodies) stays: it counts the scatter's landings, and it cannot tell a skim from
an emptying, which is why the bank needed its own arm. **One `ok()` for one, so the count holds at 2107.**

**Driven both ways** (`s1/PREDICT_S5.md`, md5 `beb52dc5…`, written before; every prediction held): **five standalone runs on one
tree** with the repaired arm, 2107 / 0 each — the one proof a flake has; the repaired arm on a card made to **skim** (at most five
turns consumed, the rest left standing — `edits/ctl_skim.py`) **2107 / 1**, the one red the bank arm (*want -16, got -20*), the total
arm green; and **HEAD's arm on the skimming card, three runs, green on all three** — it reds a skim only when all five scattered fires
land back on the deep body (one in 32): **the arm could not see the defect it was named for.** `check_ja` §5 holds the predicate (C09).

## §6 — HOUSEKEEPING

- **THE MOVE IS NOT ATTEMPTED** (IB §4). `./lane.sh spent` prints the one clearing command. **User-data folders: 611 at the open, 611 at the close** — every lane JA launched ran under a name a folder already held. One lane was first made under a name with no project prefix, which would have made a new folder; it was caught before any launch, set aside and remade. `./lane.sh strays` names *IT const probe* and *[unnamed project]*, IY's two.
- **`lane.sh` for every launch, one process a lane** — the census's lanes (*IG p1*–*p3*, *IH A*), §2's two arms (*IE probeA2*, *IE probeA3*), the work lanes (*IC recon2*, *IC work*, *IA probe6*), §5's flake proof (*IA probe*, *IA docsub*, *IE probeA1*), the code tree and pre-check (*IA pre1*), recon 1 (*IC final*), the stand-ins (*IC docsubA*, *IC docsubB*), HEAD's side-by-side (*IC prepass*), the pre-run's tree (*IC recon1*), the final tree (*IC recon2*, after the work lane of that name stopped) and the controls' clones (*IC ctlA*, *IC ctlB*, *IB ctlC*). **Every drive job was bound to a lane of its own.** The acceptance ran in the repository as the live project, through `./run_battery.sh`.
- **The designer's files** — backed up first (`../save-backups/JA-20261029-220449`, 22:04:49, byte-identical to IZ's backup by `diff -r`) and read only through copies. Read again at the close through fresh copies, the backup holding the open's bytes: `run_save.bin` `fcb20c91…`, `profile.json` `608d89c0…`, `relics.json` `fdc12ffa…`, `settings.cfg` `0c1b39c3…`, **each unmoved**. **The clean readout, md5 at the open and the close**: `latest.txt` `e43f2d0a…`, `run-20261014-134942.jsonl` `2b0f0212…`, `run-20261018-194229.jsonl` `610bcd8c…`, **three files at both, unmoved**.
- **BOTH CEILINGS**: **`CLAUDE.md`** 496,724 → 498,257 B (+1,533 B, nothing cut): 486.58 of 510 KiB, **23.42 KiB under**, the ladder block's one new bullet. **`docs/state.md`** 358,738 → 369,654 B (+10,916 B net, +327 B of it inside the index's fence): 360.99 of 380 KiB, **19.01 KiB under**, 2.9 batches at the honest rate IT measured (6,712 B). **The archive's cut did not keep pace**: the archive took 3,641 B and JA wrote 14,557 B, the census and its findings the new writing. Both files state these figures themselves, the size lines a fixed point. The report is not in either figure.
- **Nothing of the playthrough**: a sim is not a playthrough, and the second run with a different party stays on the LOOK-LIST.
- **The machine slept** from about 00:30 to 09:30 on 2026-10-30 with the pre-check and a stand-in run suspended; both resumed on wake, nothing in either tree changed, and keep-awake was granted for the rest. **The stamps read 2026-10-30**, the day the batch closed; the brief came in on 2026-10-29.
- **The close's timestamp** — **2026-10-30 16:07:56 PDT**.

## §7 — WHAT IS DELIBERATELY NOT DONE

No new modifier authored — grade 4's four are the designer's, §3 and §4 their inputs; no grade moved but Fleeting's, on its in-deck
reading; Warden's band unmoved; no modifier's words moved but Leaden's and Fleeting's (Fleeting's are the code's, by the designer's
choice); **Thin Air's and Encumbered's one-sidedness found and not touched** (NEEDS A RULING 1); IP §0.2's sentence not narrowed
(NEEDS A RULING 2); no rename path for a modifier id invented; the reference party unchanged and no second ladder (§3 is a census);
no POLICY row changed, RULE stays 0, the ally pools untouched; IX's absorption reading read, not proved; the latent offer defect left
latent; `check_hk`'s unseeded band; `CLAUDE.md` takes no index; the 188 cheap gates, the 438 pins, the thirteen positional picks,
`check_it` §2c, `check_hn` §2a, the Chilled row's *4*, the latent floor shapes and the Cryomancer's route — untouched; nothing of the
playthrough; the standing list.

## FOUND AT JA AND NOT FIXED

- **THE PARTY IS THE FASTER SIDE, AND LEADEN's SUBTRACTION STILL COSTS IT** (JA §3): the heroes' effective speed at their turns reads 98.5 against the warband's 90.8 on the reference party and 116.8 against 92.2 on the incumbent, so a flat amount off every speed takes the larger share of the warband's — and IZ's -30 costs the party +0.60 ± 0.26. The brief's reading (*the party is on the slow side of the field*) does not hold; the card's words are true of the mechanic (*the slower a body already is the more it loses*) and why the subtraction costs the party is not a share of speed. Not driven further.
- **THE ID THE RENAMED CARD KEEPS** (JA §1): `frenzied`, because a save names a modifier by its id and the project has no rename path for one — the load door's map is the cards' (`Run.RENAMED_CARDS`). The id is the old name's one live survivor; a rename map for modifiers is owed only if the designer wants the id to follow the name.
- **THE STRIKE LEDGER IS NOT THE DOOR** (JA §3's fidelity): the hero strike loop's `final` is the blow computed, before a barrier, a death refusal or the vow, and it holds no companion's blow (`_companion_hit`) and no special that resolves outside the loop — so the warband's strike damage reads 1.6 times its damage at the door on the reference party. A census of what a rule keys on reads the door for damage and the loop for blows, crits and armor; the armor row is the loop's site alone (about twenty other sites in the specials take armor off their own figures).
- **A CARRIED ITEM NAMES ENEMY COOLDOWNS, AND NO ENEMY HAS ONE** (JA's close-read): *Named by the designer, carried from CX* still lists *the enemy debuffs whose duration exceeds their own cooldown*, while none of the 50 abilities in `data/enemies.json` sets a `cooldown` — the loader reads the key and no row writes it — and the census read 0 warband cooldown turns over 2,217 fights. The item predates JA and may mean how often an enemy re-casts; JA left it standing and read Encumbered off the data.
- **THE BATTERY's 240-SECOND WATCHDOG SAT ON `test_batch_bk` ON A SLOW DAY, AND THE CODE WAS NOT WHY** (JA's recon 1): `test_batch_bk` and `check_ez` timed out on the pre-check and again on recon 1, reading like a hang. Run alone they pass, at 243 s and 207 s against about 135 s and 126 s at every acceptance through IZ; run side by side, HEAD and JA's code read 366 s and 361 s, 385 s and 388 s, so JA costs nothing and the machine was slower that day, for a reason nothing read (on mains, no thermal warning recorded, memory free). Recon 2 and the acceptance ran under the battery's own override, `DOD_SUITE_TIMEOUT=480`, its 240 s default retained. **A timeout on either gate is a question for HEAD's copy first.**
- **THE BRIEF's PREMISES THAT DID NOT HOLD** (JA's report §0): *nine batches ago* eleven of twenty-three cost nothing — it was IX, three batches back; *three failed the same test, each paying one side* — the Dark and Dull Edge at its floor paid the party, Tinderbox read a tie (+0.24 ± 0.23) and left by the stop condition; *IX §2d found a second mechanism, a longer fight pays the side with sustain* — IX §2d pre-registered that shape and found it on none of fourteen halves; *the party is on the slow side of the field* — the faster (above); *at -3 every effect lasts one turn* — 6–8% of the party's positive-count statuses run five turns or more and the battle-long ones are untouched (the designer chose the true words); *every other axis stops at 3 or below* — healing, resource and recoil reach 5.

## NEEDS A RULING


1. **THIN AIR AND ENCUMBERED BIND THE PARTY ALONE AS THE DECK PLAYS (JA §3's census).** The warband takes no turn-start drip (the drip is `_player_turn`'s alone) and no enemy ability carries a cooldown, so over 80 runs and 2,217 fights the warband produced **none** of either quantity; Parched's and Warded's it produced nearly none of (the heroes 190 to 310 times the resource held, 42 to 49 times the resource paid — the warband's two Rage kinds). AQ's rule (IO §0.2) and the glossary's *nothing in the deck binds one side* read the words, and these read the effect: each is a difficulty slider by AQ's own test. Re-cut, accept, or rule what *binds both sides* means — the designer's; nothing moved (JA §7).
2. **A SHARE IS NOT A SIGN (JA §3).** IP §0.2's rule reads *a rule keyed on a quantity the two sides do not produce equally pays the side that produces more of it*; on the instrument the scale is set on, both damage bonuses (Feverish, the Thin Veil) — keyed on a quantity the heroes produce 6.3 to 7.1 times more of — cost the party, and so do penalties on what the warband holds more of (Rot, Overgrown, Brittle). The census's pattern is written beside IP's rule in `CLAUDE.md`, the batch's reading and not a ruling; **whether IP's sentence is narrowed to the shape it was written for (a payout landing on the party's health) is the designer's.**
3. **GRADE 4's FOUR ARE THE DESIGNER's, AND THE INPUTS ARE IN (JA §3, §4).** The share census (`docs/reports/JA-shares.tsv`, two parties, 29 quantities) and the axis table (`docs/reports/JA-axes.tsv`, ten axes): **grade 4 holds health alone**; healing, resource and recoil reach 5 with no 4; damage, Break and the hand top at 3, status duration at 2, tempo and the turn order at 1. **An axis is a candidate for a two-sided rule only where the warband produces its quantity too** — health, turn order, armor; reference party: Break, tempo, hits — and Warden's gambles stay Rot and Overgrown until one is authored (IZ §0.4).

## §8 — VERIFICATION

**IN THE BRIEF's ORDER (§8)**: the routing first (22:07, before any edit or measurement); §3's census and §4's table read-only, before any edit, the census's fidelity stated; §5's repair and its flake proof; the code and its parse; §2's arm against a re-driven baseline; the literal sweep before recon 1's prediction; recon 1 with its prediction written first; the documents as scratch copies, a hash guard between them and the repository; `check_ja` into the battery; the pre-run; the close-read; the positional re-run; the controls; recon 2 with its prediction; the acceptance; the push check; the two readings. **The close-read and the positional re-run ran ahead of recon 2**, not after it, so that anything either found could land in the tree recon 2 read. **A prediction was written before every drive and both recons; each is graded beside its reading.** Every Godot process ran through `lane.sh`, one a lane, every drive job bound to its lane; **0 `Parse Error` and 0 `SCRIPT ERROR` in every log** of every drive, recon, stand-in and control, grepped, never a tally. **The pre-check's one script error is the predicted one**: HEAD's `test_batch_an` reading the renamed constant.

**THE PREDICTIONS, GRADED**: §3 — **16 right, 8 right for one party, 3 wrong**; §5 — **3 of 3**; §2 — **5 of 6** (the cost +2.29, under the predicted +2.4 to +3.8); the pre-check — **every red it named but two, and three timeouts it did not name** (below); recon 1 — **two reds it named stayed green and three it did not name reddened** (below); the two gates' slowness — **the branch I named as likely held**; recon 2 — **every line held**; the acceptance — **every line held**; the corrections after the acceptance — **one line wrong, then amended, and every amended line held** (below).

**THE PRE-CHECK (FA §1b: HEAD's gates against JA's code, before re-pointing any)** — HEAD's whole battery on the code tree, 166 targets: the reds were the arms JA moves — `check_iz` 172 / 5, `check_iy` 133 / 2, `check_ix` 124 / 1, `check_iw` 127 / 1, `check_in` 92 / 1, `check_io` 120 / 2, `check_ip` 48 / 1, `check_iq` 88 / 1, `test_batch_an` 5,724 / 2 and its one throw on the old constant, each re-pointed to its intent, every re-point carrying `RE-POINTED AT JA` where it is a gate's arm. **Wrong**: `test_batch_bb` and `check_ed` were named and stayed green. `check_gp` 455, `check_hk` 166 and the harness 22 / 382 / 8 held. **The census needles held**: 12 rows on 15 gates, 0 lost.

**THE LITERAL SWEEP, BEFORE RECON 1's PREDICTION** (HEAD against recon 1's tree, 22 files): 26,096 literals — 201 MOVED, 372 GAINED, 10 LOST. All ten were walked to their holders and none is read: `FREN` and `ZIED_SPEED` are the split parts of the old constant's needle, held by `check_iz`'s own absence arm; `fast`, `owns` and `seven` are the same word in other files' tables. **`check_ed` named in the prediction, and the prediction was wrong**: it stayed 18 / 0 on recon 1's tree, the stand-in's *UNRECORDED* rows having been `check_ja`'s alone. **The manifest's floor**: HEAD 2,114; regenerated on the final tree 2,124 — it rises, so no `--fall` is owed.

**RECON 1** (166 targets and the harness, the code tree with every gate re-point and HEAD's documents; `JA-work/s1/PREDICT_R1.md`, md5 `a29a199c…`): named and red, `check_io` 120 / 1 (§1f) and `check_iq` 88 / 1 (§2c); `check_de` 681 / 11. **Named and green, wrong**: `check_ed`, and `check_in` 92 / 0. **Red and not named, three arms that read the documents**: `check_iw` §1, `check_iy` §2 and `check_iz` §2 each 1 fail against HEAD's table, every one green on the stand-in, none a re-point's fault. **The seeded roads, attributed against HEAD's rows**: `check_gp` 455 **unmoved**; the harness **unmoved**; `check_hk` 168, inside its band; `test_batch_an` 6,019, inside its band; `check_gj`'s sanctioned figures +159 / 179 → **+160 / 180**, the same 20-gold gap.

**TWO TIMEOUTS THAT READ LIKE A HANG, AND WERE NOT JA's** (`JA-work/s1/PREDICT_SLOW.md`, written before the side-by-side): `test_batch_bk` and `check_ez` timed out at the battery's 240 s on the pre-check and again on recon 1, with the same log tails, and `check_map` once at its 600. Load was my first reading, and the repeat undid it, so it was measured. **The history, from the logs' own timestamps**: about 135 s and 126 s at every acceptance through IZ. **Alone, on recon 1's tree**: 243 s (131 / 0) and 207 s (135 / 0). **Side by side, so both read one machine**: HEAD 366 s and 385 s, JA's code 361 s and 388 s, the same verdicts. **JA's code costs nothing; the machine ran slower that day**, on mains with no thermal warning recorded and memory free, and why is not known. Recon 2 and the acceptance ran under the battery's own override, `DOD_SUITE_TIMEOUT=480`, its 240 s default retained, `check_ja` the one line JA adds to `run_battery.sh`. A hang is still caught at 480. FOUND AT JA carries it.

**THE COUNTS**: `check_parse` 242 → 243, `check_ja.gd`. `check_ja` 101, new. No other count moved: every re-point was one for one. `test_batch_an` read 6,019 and `test_batch_bk` 130–131, inside their bands, and each carries the map's unseeded wander its row records.

**THE DOCUMENTS — SCRATCH COPIES, BEHIND A HASH GUARD.** Every document edit is a script run on a scratch tree (`JA-work/edits/apply_docs.py`, `apply_state.py`, `fill_tokens.py` — the two size lines a fixed point — and `route/render_routing.py`), never on the repository. **The stand-ins** read the fixed reds first: `check_iy` §2 on the card's new words and `check_iw` §1 on the state row's name, both re-pointed; three index rows over 400 B, trimmed; and **`check_iu` §5, which is why `gate_fixture.gd` is untouched**: moving IZ's turn-order model into the fixture would have touched a target carrying a MISSES row the brief says stays, so the model stayed in `check_iz` as a static function `check_ja` reads by preload. **The pre-run** on the final tree: 40 gates and suites, the gates of gates and the document readers among them, all green. **The needle proof** (the manifest regenerated over the same gate sources on the code tree with HEAD's documents and on the final tree, entry by entry): **7 needles satisfied**, all `check_ja`'s, **0 taken red, 0 moved otherwise**; all 10 of `check_ja`'s pins resolve.

**THE CLOSE-READ** (the routing record's third list): 62 unrouted blocks, 112,451 B, read whole by a reader outside the working read. **None states anything JA made false; 4 bore, all ROUTED, so no row was repaired.** **One of the four tested a headline before it stood**: the carried CX item *the enemy debuffs whose duration exceeds their own cooldown* against JA's first ruling, *no enemy ability carries a cooldown*. Read in the data: none of the 50 abilities of the 21 enemies sets one, and the census read 0 warband cooldown turns over 2,217 fights. The ruling stands, and the item, older than JA, is in FOUND AT JA.

**THE POSITIONAL AND SUPERLATIVE RE-RUN** (IT's census of 489 reads, re-derived against JA's tree; IZ's tools, overlaid with IZ's verdicts): **every one of the 489 settled — 355 SAME, 8 LINE-SHIFT, 30 IN-PLACE, 0 OFF-SUBJECT, and 96 unchanged by construction; no verdict moved, and the thirteen standing MISSES still miss**, none gaining an instance. The mechanical pass sent 364 reads to review, mostly because the census gives their anchor in words. **A pass new at JA**, `tools/pos_hunks.py`, cleared 286 of them: JA's edits to the game's code are a handful of lines (comments stripped, `unit.gd` is identical, `battle.gd` differs in `_stamp_modifier` alone, and no function body of `run_state.gd` moved), so a read can move only if a needle it holds sits on a changed line. **That pass was thin and I tested it**: 79 of its 286 held one needle, the census's own anchor, because a census's line numbers go stale. Re-run stricter, every literal of six or more characters anywhere in the gate against every changed line, 234 cleared outright; of the 52 that hit, 29 were a message's word, 15 the word `modifier` in an event's dictionary, and 8 were read by hand, each landing where it did. The reader (a subagent outside the working read, `JA-work/route/positional_ja.tsv`, 103 rows) took the 78 the pass could not clear and the 25 wide reads: 67 SAME, 30 IN-PLACE, 6 LINE-SHIFT. **Five of those are runtime reads cleared from their writers, not run**, and marked so. Only two wide reads walk files, and `check_ja.gd` joined their corpus without moving a landing.

**THE CONTROLS — TWELVE, ALL BIT** (`JA-work/tools/ctl_ja.py`, IZ's driver: one clone of the final tree each, the break's anchor dry-checked on the final tree and asserted once in the clone, `check_ja` run through `lane.sh`, read by its FAIL text, never its count; 0 throws in any, run on the tree recon 2 read):

| | the break | what reddened (FAIL text) |
|---|---|---|
| C01 | the old name put back in one file | §1 *1 live lines still name the old card without the new* |
| C02 | `LEADEN_SPEED_ADD` renamed without its card | §1 *Run carries no LEADEN_SPEED_ADD — the constant is not named for its card*; *the stamp does not write the card's constant once* |
| C03 | the speed floor removed with the rename | §1 *DRIVEN — a subtraction past every speed stalls a unit or leaves it off its floor* |
| C04 | Leaden's multiplication restored | §1 *DRIVEN — under the card 0 of the board's first 48 turns change hands, where IZ's drive read 23* |
| C05 | Fleeting left at 1 with a grade 2 | §2 *fleeting: its reading was taken at FLEETING_TURNS 3 and the deck holds 1* |
| C06 | Fleeting's words left as one turn off | §2 *Fleeting's words are not its rule at the value* |
| C07 | a live modifier's quantity missing from the census | §3 *1 live modifiers' quantities have no row in the census: ["muffled"]* |
| C08 | an axis row naming a grade the deck does not hold there | §4 *health: overgrown is written at 3, the deck holds it at 4* |
| C09 | `test_batch_cb`'s arm put back on the scatter | §5 *the deep-stack arm does not read the bank at Overburn's door*; *reads where the scatter's fires fell again*, **over several runs**: the same two lines five runs of five, on a clone of the tree the commit carries |
| H01 | HEAD's code under the final gate | 11: the name, the constant, the words, Fleeting's value, the cb arm |
| H02 | HEAD's documents under the final gate | 16: the practice, the rulings, every kept table *not in the tree*, the master row, the census's record |
| R01 | a re-tune at the source (-30 → -40) | `check_ja` §1 *the constant reads -40.0 — the rename moves no magnitude*, the drive 26 of 48 and the master row, which states the figure; `check_iz` §2 *its reading was taken at LEADEN_SPEED_ADD -30.0* and §4 *Leaden ships -40.0*; the card's words **held**, following the constant |

**RECON 2** (the final tree, frozen by md5 of every file, tracked and untracked, before launch: 627 files, freeze `a704d9f4…`; `JA-work/s1/PREDICT_R2.md`, md5 `14e002f5…`): **167 targets** (the `.ran` file's lines, 164 scripts and the harness's three, IZ's way of counting; the prediction's *and the harness* reads as though it were extra, and is not), **0 `Parse Error`, 0 `SCRIPT ERROR`, no target timed out, the freeze unmoved across the run**, alone, 12:22:57 to 14:02:18 under `DOD_SUITE_TIMEOUT=480`. **Every line of the prediction held.** `check_ja` 101 / 0, `check_parse` 243 / 0, `check_iq` 88 / 0 (cured by the documents), `check_ed` 18 / 0 (2,124 pins), and at their rows `check_iz` 176, `check_iy` 133, `check_iw` 127, `check_ix` 124, `check_in` 92, `check_io` 120, `check_ip` 48, `check_ho` 179, `check_ij` 49, `check_iu` 185, `test_batch_cb` 2,107. The bands: `test_batch_an` 6,025 inside [6,013, 6,035], `check_hk` 168 inside [166, 170], `test_batch_bk` 131 inside [129, 131]. The roads: `check_gp` 455, `check_ez` 135, the harness 22 / 382 / 8. **Nothing red but the two sanctioned**: `check_cm_live` 13 / 5, `check_gj` 70 / 1 at *+160 gold and the purse moved 180*. `check_de` **685 / 0 / 0 notices**.

**C09, OVER SEVERAL RUNS, AND WHY THE SUITE CANNOT BE WHAT BITES.** The brief's row asks for several runs, and the first pass gave it one, so it was run again: `check_ja` 101 / 2 five of five. `test_batch_cb` itself, with the arm put back, read 2107 / 0 three of three, as predicted: the old arm reds only when all nine fires land back on one body, one cast in 512, so runs of the suite cannot show it. That is what §5's predicate is for.

**EVERY NEGATIVE ANCHOR PAIRED WITH A POSITIVE ARM** (§8). **The brief's two absences**: §1's sweep (no live line names the old card without the new) stands beside `files.size() > 100 and leaden_in >= 4`, so a sweep that read nothing reds; §3's *every live modifier's quantity has a row* is derived from the deck's own keys and printed (*of the deck's 21 modifiers placed*), with `rows.size() >= 20` in the same section and the sibling arm that reds a row naming a modifier the deck lacks. C01 and C07 show each absence biting. **No re-point added a bare absence**: the one left among the re-pointed gates, `check_iz` §4's, reads `add != null` beside it.

**THE ACCEPTANCE** (the repository, the game shut, `./run_battery.sh` under `DOD_SUITE_TIMEOUT=480`, after the landing behind the hash guard, 32 files, the report held back to the close; 14:04:17 to 15:43:19): 167 targets, **0 `Parse Error` and 0 `SCRIPT ERROR`** in any log, no target timed out, the repository's 627 files unmoved by md5 across the run; **`check_de` 685 / 0 failures / 0 notices**, the harness 22 / 382 / 8, **the sanctioned reds alone** — `check_cm_live` 13 / 5 and `check_gj` 70 / 1 (*+160 gold and the purse moved 180*); `check_ja` 101, `check_parse` 243, `check_iu` 185, `check_ed` 18, `check_iq` 88, `check_iz` 176, `check_gp` 455, `check_ez` 135, `check_hk` 168, `test_batch_an` 6,020, `test_batch_bk` 130 and `test_batch_cb` 2107 / 0 — **every figure its prediction named** (`JA-work/s1/PREDICT_ACCEPT.md`, md5 `b295fd48…`, written before the landing).

**AFTER THE ACCEPTANCE: A FRESH READ, AND FOUR PLACES IN `docs/state.md`** (`JA-work/s1/PREDICT_POST.md`, md5 `50f3f506…`, its first part written before the first drive and its amendment before the second). A reader outside the working read went through the assembled report against the brief and the repository, and each thing it found was checked against its source first. **In the report alone**, corrected: *four comments* is five; *the bargain fights alone read the same way* holds but for three quantities on the reference party (§3, and §4 now says what that does to two candidates); a tenth of a point a percent is *about* a tenth (the Thin Veil's 0.095); *an eighth to none* is a quarter to none; the head's *three things the brief assumed* read as if it counted the six premises; C09 and the negative anchors, above, were missing. **Two reached `docs/state.md`, which the acceptance had read**: *`run_battery.sh` unchanged* in FOUND AT JA (JA adds `check_ja` to it; what stayed is the 240 s default) and ruling 3's candidate list, narrower than §4's. Each was replaced by a phrase of the same byte length, so both size lines stay true. **My prediction was wrong on one line**: `check_it` §5 read 44 / 3, because an index row carries its block's stamp, and the gate was right. `index_stamp.py` moved those two stamps, six hex digits each. **The file is still 369,654 B, differing from what the acceptance read at exactly four places: two phrases and two stamps.** **The proof, on the final tree with that one file changed**: the manifest regenerated byte-identical, 2,124 pins; all 18 gates that open `docs/state.md`, and `check_ed`, at their acceptance rows; 0 `Parse Error`, 0 `SCRIPT ERROR`. It landed behind the same hash guard. **The whole battery was not run again**, so `docs/state.md` is the one file in this commit whose exact bytes the acceptance did not read.

**THE PUSH CHECK AND THE TWO READINGS.** **The push check**: before anything ran, `git ls-remote origin class-merge` read `1a276cd6`, IZ's push and local HEAD (22:04); JA's commit is pushed to `class-merge` and the remote read back against local HEAD after it. **The two readings** (IQ's method — each file against its own ceiling, at the open and the close): **`CLAUDE.md` 496,724 → 498,257 B** (+1,533, nothing cut — the ladder block's one new bullet; 486.58 KiB of its 510, 23.42 under); **`docs/state.md` 358,738 → 369,654 B** (+10,916 net, +327 of it inside the index's fence; the archive took 3,641 B, so JA wrote 14,557 B; 360.99 KiB of its 380, 19.01 under, 2.9 batches at the honest rate). **The cut did not keep pace.** The changelog 146,569 → 150,042 B, JA's entry, no cut at JA.
