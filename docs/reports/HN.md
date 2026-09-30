# BATCH HN — THE CEILING, SEVEN RULINGS, AND WHAT A CREST PAYLOAD CAN WRITE

**On `class-merge`, from `d24efed` (HL). IMPLEMENT ONLY.** `CLAUDE.md`'s ceiling is re-derived a third time, to
**470 KiB**, before any other section wrote a byte, and the ruling that a fourth is not the answer stands beside the
figure (§1). HL's seven rulings are answered — **five confirm what HL built, two move code**: the Fourth Stack rune is
**Forbearance**, and the empty rune pouch says where core runes are found (§2). **The census the crest runes are
authored against is taken, every answer driven with fixture runes that never reach the file** (§3). Ordination's two
stale comments are fixed; **the 461 spent user-data folders are not deleted** — the session's permission check refused
the move, and the choice is the designer's (§4). **No rune was authored and no magnitude moved.** A new gate,
`check_hn`, drives all of it.

**VERDICT:** **DONE, AND PUSHED — WITH ONE RED IN THE ACCEPTANCE RUN THAT IS NOT THIS BATCH'S.** The ceiling is 470 KiB with the ruling beside it, written first; HL's seven rulings are answered — five confirmed, two built and driven both ways; the census is taken and every answer driven with fixture runes that never reach the file; Ordination's two comments are fixed. **HEAD's unmodified gates read every target at its count on HN's game**, so no existing check was re-pointed, and **fourteen controls, one defect each, bit every arm of the new gate.** **The pre-pass read `check_de` 533 / 0 / 0 over 129 targets, the prediction exactly; the acceptance run in the repository read 533 / 1** — every target at its pre-pass value but `test_batch_bk` §3, a latent 1-in-54 flake in HEAD's own suite, found, characterised and reproduced by seed on HEAD's tree and on HN's, and recorded rather than absorbed (§7). The tree was byte-identical after it and the player's files untouched. **The 461 spent user-data folders were not deleted — the move was refused — and the choice is the designer's.** Three rulings are owed.

## NEEDS A RULING — THREE; THE FIRST TWO ARE PLAYER-VISIBLE

1. **FORBEARANCE SHIPPED BARE (§2a).** The brief names it *RUNE OF FORBEARANCE*. The live pool is bare-named — FK §2a's
   standing rule, and `check_fd` §3 reds any live ordinary rune whose name begins *Rune of* — and FK bare-named all
   thirty-nine runes its brief wrote in the long shape, **this one among them**: the brief's *Rune of the Fourth
   Stack* has been `Fourth Stack` since FK. So it ships as **`Forbearance`**, beside the pool's other one-word runes
   `Clarity` and `Abundance`. If the long shape is meant, it is one string in `data/runes.json`, one arm of
   `check_fd` §3 and one line of FK §2a's rule.
2. **ELEVATION'S CARD STILL DESCRIBES THE RELEASE AT THREE (§6).** *"Raise them up: every ally gains 2 stacks of Faith.
   An ally already holding 3 crosses the cap and RELEASES on the spot — and their peak does not fall for it."* Since HL
   §3 moved the threshold to eight, an ally holding 3 reaches 5 and does not release; an ally needs 6 or 7. HL spoke the
   new number in four places and this card was a fifth. **The card's words are the designer's and were not touched**
   (the brief keeps card text as authored). A wording that cannot go stale again would say it relative to the
   threshold — *an ally within two stacks of the threshold crosses it and RELEASES* — and it is offered only as that.
   `master.html`'s Elevation and Blessing of the Faithful rows said the same and are corrected (§6).
3. **THE REPLACE-NOT-ADD TRAP, BEFORE ANY CREST IS AUTHORED (§3a).** A `stat` payload on a field the spawn does not give
   every hero REPLACES that field's default rather than adding to it: a crest adding +0.20 healing received leaves every
   hero but the Cleric at 0.20 — a heal of 100 lands 20 — and a crest adding parry chance replaces the 5% role baseline
   on every hero whose lineage sets none. **Either the spawn carries the defaults** (priced at §3a: small, but it changes
   what three retired runes pay on a saved run, which is a magnitude) **or crest runes are authored around those
   fields.** The designer's.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`, after HL"* | **HELD** | HEAD `d24efed` = `origin/class-merge` = `git ls-remote origin class-merge` before anything moved; the tree clean but the untracked `save-backups/` |
| 2 | *"`CLAUDE.md` reads 393.67 KiB against 410"* | **HELD** | 403,114 B |
| 3 | *"HL's own rule says the batch that finds it within one record batch of the ceiling raises the ruling before it writes. This is that batch."* | **TWO RECORD BATCHES, NOT ONE; AND THE RULE LIVES ONLY IN A CLOSED REPORT** | 16.33 KiB of headroom is 2.02 of EZ's +8,293 B. The sentence is `docs/reports/HL.md` §7's and nothing in `CLAUDE.md` carries it. The ruling was the designer's to take either way, and it was taken first (§1) |
| 4 | *"393.67 + 80.99 = 474.65 KiB, stated as 470 and rounded down"* | **HELD** | 403,114 + 82,930 = 486,044 B = 474.65 KiB |
| 5 | *"EZ's record +8,293 B"* | **HELD, RE-MEASURED** | per-batch deltas of `CLAUDE.md` over EE's window — the 105 batches DK–HL — the largest is still EZ's +8,293 B; HK's +8,085 B is the largest since FF and since GR. The whole history's largest is CB's +30,385 B, a batch that wrote a narrative block before CW's split, and not the record the method reads |
| 6 | *"it has been right twice"* | **HELD** | FU §1 (340) and GY §1 (410) |
| 7 | *"this is the third re-derivation"* | **HELD** | EE derived 290; FU, GY and HN re-derived |
| 8 | *"GY's rejection of the reasoning-split stands"* | **HELD** | kept in the ceiling block and named apart from the shape recon |
| 9 | Ruling 1: *"the one unconditional swap; the other three cost Rage and switch as a side effect"* | **HELD** | Guard Change 0 Rage, 1-turn cooldown; Precision Strike 20, Feint 25, Wheeling Cut 30, each a 3- or 4-turn cooldown and each strikes |
| 10 | Ruling 2: *"Aggressive +30%; Defensive −15%; downsides 10%; Formless +30%"* | **HELD** | `SEASONED_AGG_DEALT` 0.30; `FORMLESS_DEALT` 1.30; 0.85; 0.90 and 1.10 |
| 11 | *"it halves what the Bared Guard's price takes back"* | **HELD, AND THE BARED GUARD IS RETIRED** | its −0.15 would take back half of a 0.30 cut; the rune has been retired since ET §1, so the consequence reaches only a saved run holding it |
| 12 | Ruling 3: *"16% mitigation and +12% damage at the top"*; *"the Devout's own count never releases"* | **HELD** | HL §3d's table |
| 13 | *"`test_batch_be` §6 already reds the day a writer arrives"* | **HELD** | its §6 arm: *"something writes `communion_ranks` again — … a certainty"* |
| 14 | Ruling 4: *"Its text is the proposed wording, unchanged"* | **HELD** | *"Allies hold one more stack of Faith before releasing."* |
| 15 | *"Its name becomes RUNE OF FORBEARANCE"* | **SHIPPED BARE** | NEEDS A RULING 1 |
| 16 | *"the Cleric register BQ set"* | **HELD** | BQ's Cleric six: names chosen for register — *"priestly and old: rites, offices, practices"* |
| 17 | §6: *"a save holding *Rune of the Fourth Stack*"* | **THE LONG SHAPE OF THE NAME THE SAVE HOLDS** | the rune has been `Fourth Stack` since FK; both names are driven loading as today's (§2a) |
| 18 | Ruling 5: *"Confirmed as built"* | **HELD** | `Run.hold_rune` slots an engine rune only when asked, and the cache answer never asks (HL §1a) |
| 19 | Ruling 6: the empty-pouch line *before* | **HELD** | `map_screen.gd`'s one literal |
| 20 | Ruling 7: *"the condition keys count the standing"* | **HELD** | `Talents.party_condition_met` counts `hp > 0` |
| 21 | §3: *"Both fixtures it drove were maximum health"* | **HELD** | HL §6: +9 on the crest, +7 on the hero rune |
| 22 | §3d: *"HL §6 calls it possible in principle and says it has never been driven with a card"*; *"HK's door #8 says there is no card every class holds"* | **HELD** | HL §6's two lists |
| 23 | §3c: *"a hero cannot un-fall mid-fight"* | **FALSE** | `BattleUnit.revive()` is reached in a fight by the Revive Potion and by Resurrection; a hero down at the opening can stand again before it ends (§3c) |
| 24 | §4: *"461 isolated user-data folders … every one a spent working, probe, control, trace or battery copy"* | **461 HELD; 460 ARE COPIES** | 455 *"Dawn of Decay …"*, five *"DoD …"*, and *"[unnamed project]"* — one log line from a launch with no project, 10 July |
| 25 | §4: *"two comments in Ordination's handler say five (`battle.gd:23240`, `:23245`) — stale since CZ"* | **HELD, AND THE FIRST ONE'S EXAMPLE WAS STALE TWICE** | *"three granted to an ally already on four throws two away"* held only at a cap of five and a grant of three; the grant is `od_grant := 4` |
| 26 | §6: *"HL's backup … all four files were byte-identical to HK's"* | **HELD** | and the live files are byte-identical to both |
| 27 | §6: *"HL read 128 targets in 73 min 21 s"* | **HELD** | `docs/reports/HL.md` §10 |

**THE ORDER WAS KEPT.** The player's four files were backed up and hashed, the tree copied whole before the first edit,
and then **§1's ceiling was the first byte written** — `CLAUDE.md`'s two parsed statements and the derivation beside
them, and the two stale copies of the figure in `docs/instrument-rules.md`.

---

## §1 — THE CEILING IS 470 KiB, AND A FOURTH RE-DERIVATION IS NOT THE ANSWER

**WRITTEN FIRST.** The heading and the rule sentence — the two statements `check_fg` §2 parses — read **470 KiB**; the
derivation bullet reads *"393.67 + 80.99 = 474.65, stated as 470 and rounded DOWN"*; the largest-batch figure the gate
also parses stays **+8.10 KiB**, re-measured (premise 5). **Beside the figure**, as its first sub-bullet: *this is the
ceiling's third re-derivation, and a fourth is not the answer (ruled by the designer at HN §1)* — the ceiling exists
because every batch pays the full read, so one that only rises measures nothing; **the next move is a recon on the
file's SHAPE, queued in `docs/state.md` and not run here** (whether an index plus subjects read on demand beats one
file with a moving ceiling); **GY's rejection of splitting the reasoning out stands, and it is not the seam that recon
reconsiders.** GY's own bullets are kept as the record and say where HN changed them: *"the next one is the same
arithmetic"* now says HN ran it and ruled the one after not; the rounding bullet adds HN's (474.65 discards 4.65,
**9.4** worst batches of headroom off the day's reading, where GY's carried 9.1); *"A FOURTH IS EXPECTED"* became what
the fourth run found — **fourteen batches after GY's, where GY said 24 to 31**, because the file grew 1.32 times GY's rate
(HL §7) — and *"re-derived **twice**"* became three times.

**TWO COUNTS IN GY's BULLET WERE RE-MEASURED.** *"The 92 batches since DK"* reproduces (DK to GY, inclusive).
*"EZ's has stood for thirty-two batches"* does not: it had stood through **50** at GY and stands through **63** now.
The bullet carries HN's figures, each with its definition.

**AND TWO COPIES OF THE FIGURE STOOD OUTSIDE THE BLOCK, STALE SINCE GY.** `docs/instrument-rules.md` carried *"340 since
FU §1"* in FG's table and *"names what is left at 340"* under it; both now point at the ceiling block rather than carry
a number (DJ §3: fewer copies, not a better number). `docs/state.md` carried two more, rewritten the same way.

**THE HEADROOM AFTER THIS BATCH'S OWN WRITING** — **`CLAUDE.md` IS 406,914 B = 397.38 KiB, WITH 72.62 KiB UNDER ITS 470 KiB CEILING** (+3,800 B at HN, measured after this batch's own writing): **about 14.1 batches at HL's +5,269 B** and **about 9.2 at HK's +8,085 B** (9.0 at the record, EZ's +8,293 B). The shape recon is owed before then — the ceiling's next arrival is not answered by the arithmetic.

---

## §2 — THE SEVEN RULINGS: FIVE CONFIRMATIONS, TWO THAT MOVED CODE

| # | ruling | kind | what HN did |
|---|---|---|---|
| 1 | Guard Change travels with the Stances; Battle Poise's free pivot for every Stances holder accepted | **CONFIRMATION** | the PROPOSED marker off `PROTECTED_CORES["swordmaster"]` (its comment and its `why`) and off `CLAUDE.md`; the reason recorded beside the rule |
| 2 | The stances' headline reading | **CONFIRMATION** | recorded in `CLAUDE.md`'s stance block: the other reading rejected and why, and Defensive the weaker stance a playtest question |
| 3 | Faith pays on the full peak | **CONFIRMATION** | the reason recorded in the Faith block; the Devout at 16% / +12% for the fight once he tops out recorded in `docs/state.md` to watch in play; Communion's 105% stays dormant and flagged |
| 4 | The Fourth Stack is renamed | **MOVED CODE** | `data/runes.json`'s one name, and the three comments that named it (§2a) |
| 5 | A core rune from a cache goes to the bag | **CONFIRMATION** | the reason recorded beside HL §1's rule |
| 6 | The words, with one change | **MOVED CODE** | the empty pouch's line (§2b); the PROPOSED WORDS markers off the cache toast and the roll call's tail |
| 7 | The condition keys count the standing | **CONFIRMATION** | the roster reading's rejection and its consequence recorded in the crest block, and the consequence in `docs/state.md` |

**AND ONE MARKER HL LEFT BEHIND.** The crest block's heading still said *"the word PROPOSED"* and its first bullet *"the
designer's to confirm … NEEDS A RULING"*, though HL's brief confirmed the word — *the batch that builds the thing takes
the marker off*, pointed at a ruling: both now say the word was confirmed in HL's brief.

### §2a — FORBEARANCE

`data/runes.json`: `"name": "Fourth Stack"` → `"name": "Forbearance"`, and nothing else in the entry — the id
`fourth_stack`, the field `rune_fourth_stack` its payload writes, the price, the scope and the words are unchanged, so
no save, no read site and no gate keyed on the id moves. **Every surface that speaks the name reads it off the data**
(the Peddler, the pouch, the bag, a cache, the hero sheet, the roll call); the only literal copies were three comments —
the release's in `battle.gd`, the tag table's in `runes.gd` and the field's in `unit.gd` — and they say Forbearance now.
The release comment also said *"a fourth stack"* twice, true only at a threshold of three; it says *"the one more stack"*.

**SWEPT BEFORE IT WAS AUTHORED (BR §1).** *forbear* appears nowhere in the tracked tree or the archive, in any case; at
run time `check_hn` §2a reads **429 names** — every rune live and retired, the generated family, every card in
`Classes.ability_corpus()` and every node of the tree — and **32 script and data files**, and the word stands in the
one entry alone.

**THE SAVE CARRIES IT (driven, `check_hn` §2a).** A Cleric wearing the rune saved under `Fourth Stack` (HL's name), and
the bag holding it saved under `Rune of the Fourth Stack` (the brief's long shape): after `save_run` and `load_run`,
**both read `Forbearance`** through `Run._refresh_rune_names`; the control arm — a rune the data does not hold, saved as
*Rune of Might* — keeps its own name.

### §2b — THE EMPTY POUCH

`map_screen.gd`: *"No core rune held. Core runes are found in play, alongside the others."* The reason is recorded at
the line without spelling HL's words (a comment naming a removed string reads like the removal not happening).
**Driven on the real screen (`check_hn` §2b):** the Mage's core runes taken off, the map opened, his rune panel opened —
the label reads the ruled line, HL's is absent, and **the line needs 404 px of the 1,000 px the pouch's scroller gives
it** (measured off the label, not counted), so it does not wrap or widen the panel; the panel's own Close pressed; the
Warrior's panel opened — his core-rune header shown and no empty line.

---

## §3 — THE CENSUS: WHAT A CREST PAYLOAD CAN WRITE

**Fixtures only.** Every drive builds a crest rune (scope `party`) — and for one arm a hero rune — into the loaded table,
wears it through `Run.party_runes`, enters the real battle for the run in hand (`Gate.enter_battle`) and reads the
four heroes the spawn built, **against the same party without it**. The table is left as found, and `check_hn` asserts
`data/runes.json` holds no crest entry. **Nothing a drive measures is set by hand on a unit**: every field arrives
through the crest's payload at the spawn (GW §2).

### §3a — WHICH STAT FIELDS A `stat` PAYLOAD CAN WRITE

**THE DOOR.** `Talents.apply_payload` does `cfg[field] = cfg.get(field, 0) + value × ranks` for **every key the payload
names, and checks none**. `BattleUnit.setup` then `set()`s every config key onto the unit. The crest's payload is
stamped after the hero's own runes and **before** the relic hooks, the percentage-health multiplier and node scaling,
which is why two rows below say *before* and *after*.

**THE POPULATION.** The unit declares **698** fields — every one a key `setup` can land. **184** are written by an
authored payload today (the tree's 28, the runes' live and retired, the generated family's 6), and every one of the
184 is a declared field **except `max_hp_pct`**, the one the spawn consumes before the unit exists (`check_hn` §3a
asserts exactly that, so an authored field the unit does not declare — dropped in silence — goes red).

**1 · EVERY HERO — what a crest can put on all four.** Twenty-four of the rows are the one talent tree's fields — FX's
*a node must pay every class that can buy it*, driven on all four classes by `check_fx` §4 — and four are the class
stat block every hero carries (`max_hp`, `constitution`, `stability`, `block_chance`); the tree's other four fields are
the two one-currency fields and the two stamps below. **The plumbing drive put twenty-eight fields — every row but the
two health fields, and the two one-currency fields — on all four heroes at exactly the crest's figure: 112 of 112.**
The *read* column names what reads each.

| field | what it does to a hero | shape | read | driven |
|---|---|---|---|---|
| `max_hp` | flat maximum health | additive, **before** the percentage (so multiplied by it) and outside node scaling (+2% of the lineage's BASE a win) | the spawn | exact on all four: (base + 9) × 1.10 |
| `max_hp_pct` | % maximum health | **multiplicative** on `max_hp`, additive with every other % (the tree's, the relic hook's); consumed, not a field | the spawn | the same drive |
| `attack` | flat Attack | additive into the stat every blow reads, **then** × (1 + 2% a combat win) and × an event's % | the spawn's value, every blow dealt | **+400 against +300: 136 against 109, ×1.248** (1.25 before rounding) |
| `armor` | fraction of damage blocked | additive into `effective_armor()` | every blow taken | plumbing |
| `crit_bonus` | + crit chance | additive into the roll (and a heal's crit) | every roll | plumbing |
| `speed` | Speed | additive; × Frenzied, Slowed, Chilled in `effective_speed()` | every turn's scheduling | plumbing |
| `parry_bonus` | + parry chance | additive on the parry base | every melee blow taken | plumbing |
| `max_resource` | + maximum Rage or Mana | additive (the bar) | the spawn; the cap on every gain | plumbing |
| `dmg_bonus` | + damage dealt | a term in the strike's (1 + … ) with Channel and type bonuses — **multiplicative** on the blow | every blow dealt | **+10%: 77 against 70, ×1.100** |
| `dmg_taken_bonus` | ± damage taken (negative is less) | multiplicative, × (1 + x) | every blow taken | plumbing |
| `broken_will_ranks` | +x% Break damage dealt | multiplicative, (1 + x/100) | every blow dealt | plumbing |
| `blood_communion` | heals the lowest hero x% of the Break dealt | a payout per point | every blow dealt | plumbing |
| `follow_through` | a crit ticks every cooldown x | a count | on a crit | plumbing |
| `bonecracker_ranks` | +x% damage to a Broken enemy | multiplicative | every blow on a Broken enemy | plumbing |
| `field_medic` | cleanses x debuffs from allies at turn start | a count | every turn | plumbing |
| `iron_will_ranks` | 12% less damage a debuff carried, × ranks, floor 10% | multiplicative | every blow taken | plumbing |
| `pierce_bonus` | ignores x of the target's armor | additive with the ability's pierce | every blow dealt | plumbing |
| `deflection` | parry works against ranged blows | a flag | every ranged blow taken | plumbing |
| `whetstone` | +x Attack on each crit, for the fight | additive, compounding | on a crit | plumbing |
| `undying_rage` | refuses death once; +50% damage below 25% | a flag | the lethal blow; every blow dealt below 25% | plumbing |
| `no_cover` | cannot miss | a flag | every blow dealt | plumbing |
| `sundering_shot` | a crit deals x Break damage | additive | on a crit | plumbing |
| `no_quarter_ranks` | Breaking an enemy grants 45 Rage or Mana a rank | a count | on a Break | plumbing |
| `rapid_fire` | x% chance a cast starts no cooldown | a probability | every cast | plumbing |
| `snap_shot` | the first x casts that cost anything are free, each fight | a count | every cast until spent | plumbing |
| `constitution` | Break resistance | additive (Break taken × 100 / constitution) | every blow taken | plumbing |
| `stability` | the Break bar's size | additive | every Break | plumbing |
| `block_chance` | chance to negate an attack outright | additive, beside the Warden's plating slice | every blow taken | plumbing |

**2 · ONE CURRENCY — it lands on all four and pays one kind.** `last_rites` (Rage: below 25%, damage paid from Rage
first) and `conversion_ranks` (Mana: a share of damage taken paid as Mana) — the tree's one node that writes both, FX's
worked example — arrived on all four (plumbing above) and each pays one resource. **`mana_regen_bonus`** (+x Mana a
turn): driven — the read (`_mana_regen`) moved **+5 on all four**, and the turn's drip is behind
`if u.resource_name == "Mana":`, so the Warrior, on Rage, is paid nothing. `resource` is the opening Rage for a
Warrior and is overwritten by the saved Mana for a Mana hero in a run.

**3 · PARTY-WIDE STAMPS — MAX-MERGED: THE BEST HOLDER'S FIGURE, ONCE.** `devoutness_ranks` (We Do Not Break: every hero
takes x% less Break damage), `last_hope_pct` (Heal More When Low) and `guardian_step`, each with its `rune_` twin, are
read once at the spawn: the battle takes the largest figure any hero holds and stamps it on all four. **Driven:** a
party with no source carries no stamp; the crest's +5 on all four stamps **5, not 20** (`[5, 5, 5, 5]`) — four copies are
one; and the crest's 5 beside a hero rune worn by the Cleric (his field 12) stamps **12 on every hero, the best holder's
and never the sum**.

**4 · REPLACE-NOT-ADD — A FIELD THE SPAWN DOES NOT GIVE EVERY HERO.** The add starts from nothing where the config
carries no key, so on a field whose declared default is not zero **the payload REPLACES the default**. The population
(`check_hn` §3a prints it): `healing_received_mult`, `parry_chance`, `second_max`, `mercy_threshold`,
`overcharge_mult`, the three battle-modifier multipliers, and `hp` (which `setup` overwrites with `max_hp` anyway).
**Driven:** a crest adding +0.20 healing received reads **0.20, 0.20, 1.35, 0.20** on the Warrior, Mage, Cleric and
Hunter (1.00, 1.00, 1.15, 1.00 without) — **a heal of 100 on the Warrior lands 20 with the crest and 100 without**;
and +0.10 parry chance replaced the role baseline on **4 of 4** heroes (their base reads 0.10 where the baseline plus
the crest would be 0.15). **The price of closing it**: the spawn config carries every numeric default that is not zero
before any payload (hero_config, or one seed step at the spawn and the sheet), the Cleric's Holy Conduit adds +0.15
rather than setting 1.15, and `parry_chance`'s −1 is resolved to the role baseline before a payload adds to it — two
small code changes and an arm; **and it changes what three retired runes pay on a saved run** (§6), which is a
magnitude.

**5 · NOT A NUMBER.** Measured with a probe outside the battery: on a Dictionary or bool field the config already
carries (`resists` on a lineage whose block sets resistances, `is_ranged`), the add **throws a SCRIPT ERROR inside
`apply_payload`** (*"Invalid operands 'Dictionary' and 'float'"*, *"'bool' and 'int'"*); where the config carries no such
field the payload's number reaches `setup` and the typed field **refuses it in silence** (`resists`, `stance`). Of the
698, 515 are written by no payload today — 368 ints, 29 floats, 47 bools, 10 Strings, 9 Dictionaries, 5 Arrays, 25
Callables and 21 object references: meters, ledgers, statuses, callbacks and the fight's state — **and none of them is
in the census's tables**: a field outside them has not been read at its read site, and is read there before a crest
writes it.

**6 · DROPPED.** A key the unit does not declare reaches the config and goes no further: driven, `hn_no_such_field`
landed on none of the four and the spawn finished.

**7 · ONE ENGINE OR ONE CARD — 148 FIELDS.** Every other authored field pays one hero at most: the one whose class and
core rune open its read site. On a crest the other three carry a number nothing reads. **Seventy-eight are written by
live runes**, by class and the core rune whose read site gates them (*none* = a no-engine rune, which reads a class's
kit):

| class · core rune | fields (the rune that writes each) |
|---|---|
| Warrior · none | 11 — Blood Debt, Butcher's Bill, Goading Roar, Grudge (two fields), Last Word, Long Blade, Long Watch, Open Line, Rending Blows, Split Shield |
| Warrior · Blood Frenzy | 2 — Slaughterhouse, Open Vein |
| Warrior · Heavy Plating | 4 — Bared Plate (two fields), Bracing Line, Standing Wall |
| Warrior · the Stances | 4 — Whetstone (two fields), Mirror Guard, Naked Blade |
| Mage · none | 9 — Ashfall, Chain Fire, Clarity, Cold Snap, Detonating Ward, Glass Prison, Profligate, Seeking Missiles, Unravel |
| Mage · Overburn | 3 — Ember Leap, Long Fuse, Pyre Debt |
| Mage · Permafrost | 3 — Deep Cold, Killing Cold, Second Winter |
| Mage · Arcane Resonance | 5 — Dissonance, Half Note, Overflow, Overtone, Resonant Core |
| Cleric · none | 5 — Abundance, Burning Ground, Eleventh Hour, Returned Burden, Vow of Silence |
| Cleric · Conviction | 4 — Bare Altar, Deep Absorb, **Forbearance**, Layered Aegis |
| Cleric · Mercy | 5 — Grace, Carried Mercy, Martyr, Open Hand, Vigil |
| Cleric · Wrath of the Old Gods | 5 — Deepening Hex, Open Wound, Standing Mark, Shared Ruin, Wide Rite |
| Hunter · none | 9 — Answering Pack, Bared Fang, Carrion, Full Board, Long Poison, Opportunist, Second Whistle, Shared Hide, Tusk and Bristle |
| Hunter · Lethal Aim | 5 — Ambush, Heavy Bolts, Keen Focus, Long Draw, Shared Mark |
| Hunter · Pack Bond | 2 — Long Leash, Shared Scent |
| Hunter · Trapper | 2 — Second Barb, Thin Blood |

**Seventy are written only by retired runes** (Warrior 8, Mage 21, Cleric 21, Hunter 18, universal 2), each read where
its retired rune's engine or card reads it. The field names are in the generated listing this section was built from,
kept with the batch's working; the per-field read sites of the `rune_` family are GW §1b's trace.

### §3b — A CONDITION HOLDS SEVERAL KEYS, AND EVERY ONE MUST HOLD

**YES.** `Talents.condition_met` asks each key a condition carries and refuses on the first that fails, so the keys of
one condition are an **AND**. *"No Mage and two Warriors"* is `{"heroes_lack_class": "mage", "heroes_class_count":
{"class": "warrior", "min": 2, "max": 2}}`. **Driven both ways, each half failing on its own party:** two Warriors,
a Cleric and a Hunter — **paid on 4 of 4**; two Warriors beside a Mage — **0, and the roll call says why**; one Warrior
and no Mage — **0, told**; and *no Mage* alone on that last party — **4**, so the refusal is the AND's and not a dead key's.

**WHAT IT CANNOT SAY, AND WHAT EACH COSTS.** **The same key twice** (two Warriors AND two Clerics): a condition is one
dictionary, and a JSON object with a repeated key keeps the last — a list form for the key (`heroes_class_count` taking
an array of `{class, min, max}`, every entry to hold) is about five lines in `party_condition_met` and a drive. **An OR**
has no form at all: a key holding a list of conditions, any one to hold, re-entering `condition_met`, is about six
lines and a drive; the roll call's tail is unchanged, since a condition still answers once.

### §3c — `heroes_all_standing: false` DOES NOT INVERT

**IT IS READ AS *NOT ASKED*.** The key is tested as `if bool(cond.get(k, false)) and …`, so `false` skips the test and
the condition holds whatever the party. **Driven:** `false` with all four standing — **paid on 4**; `false` with the
Mage fallen — **paid on 4** (the fallen hero's stamp lands before he is laid down); and the positive arm, `true` with
the Mage fallen — **0, told**.

**THE PREMISE THAT MAKES IT SHARP IS FALSE (§0, 23).** A hero down at the opening **can stand again before the fight
ends**: the Revive Potion and Resurrection both reach `BattleUnit.revive()` in a fight. So *someone has fallen*, read
once at the spawn, goes stale the moment he is revived — the same staleness as `true`'s, pointed the other way; it is
not the one key where once-at-spawn is exact. **What `false` would cost to invert:** two lines — the key present, and
whether every hero stands compared with its value — and a drive both ways.

### §3d — A CARD A CREST GRANTS

**IT WORKS, ON THE BATTLE'S COPY.** A fixture crest granting two cards — one free, one at 20 — through `new_ability`
(the payload defines the card; no card every class holds exists to name, HK's door #8): **both on all four bars**;
cast off the Warrior's bar the free card **struck for 24 and started its cooldown**, and stayed; **no hero owns it**
afterwards (`bm_abilities` and `Run.owned_ability_names`); the next fight's spawn **grants it again to all four with
the crest worn, and to none without**. It is never written to the member, so it survives a fight only by being granted
again, every fight, while the crest is worn.

**WHAT A CLASS-NEUTRAL CARD IS ON A WARRIOR'S BAR.** It is priced in **his own resource**, and the Warrior opens a fight
at 0 Rage: at the opening **his free card is lit and his 20-cost card is dark, while the Mage's 20-cost card is lit**
(100 Mana). A card that deals damage runs the skill bar like any other. **Three costs of the door, read off the code**:
it sits outside the slot count (it is not in the loadout); **the bot never casts it** — `_bot_drafted_pick` skips any
card `Classes.draft_ability` does not know, which a card defined in a payload is not (a crest card owes the bot a case,
as a kit card does); and the hero sheet shows it, because the sheet stamps the crest's payload exactly as the spawn does.

### §3e — `heroes_class_count` READS A NAMED CLASS

**IT SUPPORTS A NAMED CLASS AND NOTHING ELSE.** `"class": "any"` counts heroes whose class is the literal *any* — none.
**Driven:** two Warriors seated, `{"class": "any", "min": 2}` — **paid on 0, told**; `{"class": "warrior", "min": 2}` on
the same party — **4**. **A rune that pays for a doubled party of any kind is one rune; under this key it is four**, one a
class. **What *any* costs:** a reserved value read as the largest count of any one class — about three lines and a
drive.

---

## §4 — HOUSEKEEPING

**THE USER-DATA FOLDERS WERE NOT DELETED.** Counted before: **461** folders under Godot's `app_userdata` besides the live
game's own — 455 *"Dawn of Decay …"* copies (FX 1 … HL 36), five *"DoD …"* (FY census, FY probe, G2 curcopy, G2
headcopy, G6 ctlcopy) and *"[unnamed project]"* — **142,436 KiB**. The move was made into the Trash rather than a
permanent delete, so it could be undone; one folder (the 4 KiB *"[unnamed project]"*) moved as a test, and **the move
of the other 460 was refused by the session's permission check** as a destructive action. It was not pursued any other
way: the one folder was put back, so **after: 461**, and **no disk was recovered**. An empty folder named *"DoD spent
user-data folders (Batch HN, 2026-09-29)"* is left in the Trash. **This batch added its own** — eighteen folders — *"Dawn of Decay HN work"*, *"… HN recon"*, the fourteen controls *"… HN ctl K1"* to *"… HN ctl K14"*, *"… HN prepass"* and *"… HN bkhead"* (HEAD's tree, made at 00:21 while the flake was replayed, after the run) — so **479** such folders stand beside the live game's own — kept,
as the brief asks. `../save-backups/` was not touched but for this batch's backup, `HN-20260929-195624`.

**ORDINATION'S TWO COMMENTS** say the threshold, `FAITH_RELEASE`, where they said five — and the example in the first
(three granted to an ally on four, two thrown away) went with it, since it held only at a cap of five and a grant of
three; the grant is `od_grant`, four. **Comments only**, proved by a comment-stripped diff (zero code lines moved in
`battle.gd`), and no suite's needle lost (the literal sweep over every edited file). `check_hn` §4 asserts the window is
Ordination's comment, that it names the constant and that it says no *five*. **This is the two, not the sweep**:
Elevation's handler comment (*"holding 3 reaches 5"*) is stale too and is left (§6).

---

## §5 — WHAT WAS DELIBERATELY NOT DONE

- **No rune is authored** — crest, class or core. §3's runes are fixtures of `check_hn`, erased from the loaded table.
- **`CLAUDE.md` is not split and no seam is taken**; the shape recon is queued, not run.
- **The continuous half of door #3 is not built**; nor are HK's doors #1, #2 and #4–#8.
- **Volley, Ambusher and Channel's tempo payout are not built.**
- **The crest cap stays at one.**
- **The three card texts that use *engine* for a rule stay as authored**, and so does Elevation's (NEEDS A RULING 2).
- **The thirteen combat-log literals stay literals.**
- **None of §3's missing shapes is built** — the list form, the OR, `false` inverted, *any* — each is priced.
- **The replace-not-add trap is not closed** (NEEDS A RULING 3).

## §6 — FOUND AND NOT FIXED

- **ELEVATION'S CARD DESCRIBES THE RELEASE AT THREE** (NEEDS A RULING 2), and its handler comment (*"An ally already
  holding 3 reaches 5 and pays out"*) is stale since CZ. **`master.html`'s Elevation row** (*"reaches the threshold of
  3"*) **and its Blessing of the Faithful row** (*"Needing 3 held is now the WHOLE bar … an ally reaching 3 releases"*)
  are corrected, threshold-relative, because that document states what the game is.
- **THREE RETIRED RUNES WOULD STOP A NON-CLERIC'S HEALING** on a saved run still holding one: the healing price of
  Vampiric (universal, −0.3) and of the Rune of the Killing Cold (Mage, −0.25) lands on a config with no healing key,
  so it REPLACES the 1.0 with a negative figure, which the heal pipeline clamps to nothing — 0% healing where the rune
  says 70% or 75%. **`unit.gd`'s comment beside that clamp says *"No reachable loadout gets there today"*, which is false
  for such a save.** The Cleric-scoped two (Martyr, the Hollow Chalice) land on his 1.15 and pay what they say. None is
  on disk.
- **`test_batch_bk` §3 IS A 1-IN-54 FLAKE, AND IT FIRED IN THIS BATCH'S ACCEPTANCE RUN** (§7): its blacksmith arm buys
  the first pairing unseeded, and when that is Widened on Magic Missiles — the one card Widened fits in §3's party — the
  type can never be offered on another card. HEAD's tree and HN's reproduce it seed for seed. **The repair is the arm's**
  (buy a pairing whose type fits another card, or seed the roll), and it is owed; its row was not widened.
- **A CREST CARD IS INVISIBLE TO THE BOT** (§3d) — a sim party would never cast one.
- **THE USER-DATA FOLDERS** (§4) and the empty Trash folder.

---

## §7 — VERIFICATION

**THE PLAYER'S SAVES, FIRST.** Backed up to `../save-backups/HN-20260929-195624` before anything ran and verified by
hash: all four live files byte-identical to the backup, to HL's and to HK's — `profile.json` `2892470f…`,
`relics.json` `fdc12ffa…`, `run_save.bin` `fa85daa9…`, `settings.cfg` `0c1b39c3…`. The whole tree was copied before
the first edit, and every isolated copy renamed `config/name` before it ran.

**EVERY EDIT WAS SWEPT AS IT WAS MADE.** Every string literal of every root `.gd` (16,010 needles in 132 readers, both
quote styles, unescaped in one pass) looked for in HEAD's and the new copy of every edited file: **no needle lost** in
any file whose reader opens it — `CLAUDE.md`, `docs/instrument-rules.md`, `docs/master.html`, `docs/changelog.html`,
`docs/design-notes.md`, `docs/state.md`, `data/runes.json`, and the five edited scripts; the sweep was armed on a
needle `check_fg` reads and bit (*LOST 1*). The script edits are comment-only but the two ruled strings, proved by a
comment-stripped diff.

**THE RECON — HEAD's UNMODIFIED GATES AGAINST HN's GAME AND DOCUMENTS, BEFORE ANY GATE WAS EDITED.** A copy
holding HEAD's suites, gates, fixtures, runner and `baselines.json` with HN's `scripts/`, `data/`, `docs/` and `CLAUDE.md`
(`check_hn` removed), taken after the documents were written — **128 targets in 73 min 39 s** (20:35:03 to 21:48:42,
beside the controls). The prediction was written before the launch (`PREDICTION_RECON.md`) and **held exactly**: every
target green but the two sanctioned reds, **`check_cm_live` 13 / 4 and `check_gj` 70 / 1**, each with the same FAIL lines as
HL's acceptance run (digits normalised; `check_gj` still *+151 against +171*); **`check_de` 529 / 0 / 0** — every row HEAD
recorded read at its value, so **no count moved**; the harness 22 / 382 / 8 PASS; **0 `Parse Error` lines** over every
stream; `.ran` 128 names, no duplicate. **The two risks the prediction named did not arrive**: no target orders runes by
name and draws by index, and no reader of the changelog pins *Elevation* or *Ordination* absent.

**THE CHECKS THAT MOVED: NONE WAS RE-POINTED, AND NONE HAD TO BE.** The recon read every HEAD target at its
count, so the only instrument edits are the new gate and what a new gate owes: `run_battery.sh`'s GATES ends with
`check_hn`; `baselines.json` gains `check_hn`'s row (74) and moves `check_parse` 202 → 203 (its population is the
runner's target list); `check_de` reads four more checks for the new row; and `pin-manifest.json` is rebuilt, 1544 →
1560 — `check_hn`'s sixteen pins and nothing else (ten into sources, six into `CLAUDE.md`; the one unresolved source pin is
HEAD's). **The gates that read other gates' source were run standalone on the final tree before the pre-pass** —
`check_parse` 203, `check_gw` 76 at 96 sites against its ceiling of 96 (`check_hn` sets no field a rune or the tree
writes), `check_da` 41, `check_dw` 35, `check_ek` 47, `check_ff` 68, `check_ed` 18, `check_ec` 24, `check_fg` 22 and
`check_fd` 53, every one at its row but `check_parse`.

**THE CONTROLS — ONE DEFECT EACH, IN ITS OWN COPY OF THE CURRENT TREE, READ BY FAIL TEXT** (predicted before any ran,
`PREDICTION_CONTROLS_HN.md` in the batch's scratchpad; each injection asserted its needle was in the copy once and gone
after). `check_hn` reads **74 checks / 0 failures** clean.

| ctl | the defect | target | checks / failures | the first FAIL line |
|---|---|---|---|---|
| K1 | the rename reverted — the data reads `Fourth Stack` | `check_hn` | 74 / 5 | §2a: the rune reads 'Fourth Stack' |
| K2 | `Run._refresh_rune_names` returns before renaming anything | `check_hn` | 74 / 2 | §2a: a saved rune named 'Fourth Stack' loaded as 'Fourth Stack', not 'Forbearance' |
| K2 | the same | `check_hl` | 168 / 1 | §2e: a saved core rune named 'Rune of the Pyromancer' loaded as 'Rune of the Pyromancer', not today's '… (core)' |
| K3 | the pouch's line back to HL's | `check_hn` | 73 / 4 | §2b: map_screen.gd does not carry the ruled line |
| K4 | Guard Change's `why` back to *PROPOSED* | `check_hn` | 74 / 2 | §2c: Guard Change's row still reads as proposed |
| K5 | one of Ordination's comments says *five* again | `check_hn` | 74 / 1 | §4: Ordination's comment still says five |
| K6 | the first key, when it holds, short-circuits the rest | `check_hn` | 74 / 1 | §3b: one Warrior and no Mage were paid on 4 — the count failed and the absence alone paid |
| K7 | `heroes_all_standing: false` inverted | `check_hn` | 74 / 1 | §3c: `false` paid 0 with all standing and 4 with the Mage fallen — it now reads something |
| K8 | *any* read as the largest class | `check_hn` | 74 / 1 | §3e: a class named 'any' paid 4 with two Warriors seated |
| K9 | the We Do Not Break stamp SUMS its holders | `check_hn` | 74 / 2 | §3a: four heroes each carrying the crest's 5 were stamped [20, 20, 20, 20] |
| K10 | the spawn seeds healing received at 1.0 (the trap closed) | `check_hn` | 74 / 2 | §3a: +0.20 healing received read [1.2, 1.2, 1.35, 1.2] against [1.0, 1.0, 1.15, 1.0] |
| K11 | the crest's payload not applied at the spawn | `check_hn` | 74 / 19 | §3a: every-hero fields that did not arrive at their delta: attack, armor, crit_bonus, speed … |
| K11 | the same | `check_hl` | 168 / 6 | §6 a class is present: the party that satisfies it was paid on 0 of 4 heroes |
| K12 | a payload's `also` half not applied | `check_hn` | 74 / 2 | §3d: the crest's cards reached 0 of the four bars |
| K13 | the ruling taken out of the ceiling block | `check_hn` | 74 / 1 | §1: the ceiling block does not say that a fourth re-derivation is not the answer |
| K14 | a live rune writes a field the unit does not declare | `check_hn` | 74 / 2 | §2a: its payload moved — the ruling moved no magnitude (and §3a: authored fields the unit does not declare) |
| K14 | the same | `check_dp` | 33 / 2 | `fourth_stack/rune_hn_ghost` writes a field nothing reads |

**EVERY CONTROL BIT ON EVERY TARGET IT WAS RUN AGAINST.** **Three predictions were wrong, and none about whether it
bit.** K6 read one failure where two were predicted: the injected OR short-circuits only when its first key HOLDS, so
the party with a Mage still fails that key and is refused by the real check — the one-Warrior party is the arm that
sees an OR, and it went red. K14 read two on `check_hn` (§2a's payload arm saw the injected field too, since it went into
Forbearance's own payload) and two on `check_dp`. K3 read 73 checks, not 74: §2b's width arm runs only when the label is
found. **K2's first build was refused by its own injection** — the needle named the function's return type as `void`;
it returns an `int` — and re-run with the right needle.

**THE PRE-PASS** (an isolated copy of the final tree, prediction first): **isolated copy *"Dawn of Decay HN prepass"*, proved byte-identical to the repository — 445 files hashed against the tree, `project.godot` aside, at launch; the prediction written before the launch (`PREDICTION_PREPASS.md`).** **129 targets in 73 min 45 s** (21:51:36 to 23:05:21). **`check_de` 533 checks / 0 failures / 0 notices — the prediction exactly** (the recon's 529 and four for `check_hn`'s row): every row read at its value. The two sanctioned reds at their counts and FAIL lines: `check_cm_live` 13 / 4 and `check_gj` 70 / 1 (*+151 against +171*, the Tollkeeper's Bell's 20 gold). The three harness gates PASS (22 / 382 / 8); `check_parse` 203 with **0 `Parse Error` lines on any stream**; `check_hn` 74 / 0; `check_gw` 76 / 0 at 96 sites against its ceiling of 96; `check_gp` 441 / 0 in **225.1 s against its 240 s watchdog**; `test_batch_an` 6050 and `test_batch_bk` 130, inside their bands; `.ran` 129 names, no duplicate.

**THE ACCEPTANCE RUN, IN THE REPOSITORY, THE TREE FROZEN**: every tracked and untracked (non-ignored) file hashed before and after — 445 files, `save-backups/` aside, first proved byte-identical to the tree the pre-pass read — and the player's four files hashed before and after; the prediction written before the launch (`PREDICTION_ACCEPT.md`). **129 targets in 73 min 39 s** (23:06:07 to 00:19:46). **It read `check_de` 533 / 1 / 0 — NOT the pre-pass exactly, and the one failure is not this batch's.** Every target line matched the pre-pass's but two: `test_batch_bk` read **130 / 1** — *"§3: the same upgrade type is still offered on a DIFFERENT ability — AP's once-per-run rule does not reach the blacksmith"* — and `check_de`'s one failure is that row going redder.

**CHARACTERISED BEFORE IT WAS NAMED.** The arm buys the blacksmith's first pairing and then asks 200 more rolls to offer the same upgrade type on a DIFFERENT card. A probe listed the blacksmith's pool for §3's party (the four classes, lineages set, no core rune): **54 pairings, and one type — Widened — fits exactly one card, Magic Missiles**; every other type fits at least six, so only a first pick of Widened can never recur. **Replayed under chosen seeds, on HEAD's tree and on HN's alike**: 43 of 2,000 seeds put Widened first (2.15%, against 1 in 54), and the arm under seed 98 (Widened on Magic Missiles) fails while under seed 0 (Piercing on Pommel Strike) it passes — identical on both trees, seed for seed. **So it is a latent 1-in-54 flake in HEAD's own suite**, unseeded, and its fourteen recorded readings were all green (about a 77% chance at that rate). **Its row was not widened after the run** — a band written from the red would be bookkeeping, not a check — and **it is recorded where the next batch meets it**: `docs/state.md`'s *THE FLAKES* (whose heading said there were none) and its found-and-not-fixed, with the repair owed to the arm (§6).

**The rest read as predicted**: the same two sanctioned reds at their counts and FAIL lines (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *+151 against +171*); the harness 22 / 382 / 8 PASS; `check_parse` 203 with **0 `Parse Error` lines**; `check_hn` 74 / 0; `check_gp` 441 in **225.1 s**; `test_batch_an` 6050 and `test_batch_bk` 130 checks, inside their bands; `.ran` 129 names, no duplicate. **TREE UNCHANGED (445 files), and PLAYER FILES UNCHANGED** — `profile.json` `2892470f…`, `relics.json` `fdc12ffa…`, `run_save.bin` `fa85daa9…`, `settings.cfg` `0c1b39c3…`. **The brief's figure: 129 targets, 73 min 39 s** (HL: 128 in 73 min 21 s).

**THE PUSH**: committed on `class-merge` by name (never `git add -A`: `save-backups/` stays untracked) and pushed to `origin/class-merge`; `git ls-remote origin class-merge` is compared with local HEAD after the push. A commit cannot carry its own hash, so the confirmation — the two hashes side by side — is in the batch's closing message, as HL's was. After the acceptance run this report and `docs/state.md` were written — the verification line, the folder count and the flake — and **`check_es`, the one gate that opens `docs/state.md`, was re-run against the shipped tree: 57 / 0**, its row. **And `CLAUDE.md` changed by ONE WORD after the run, so the committed file is not byte-for-byte the certified one**: its ceiling block said the fourth run came *fifteen* batches after GY's, and it is **fourteen** — thirteen commits from GZ to HL, and HN the fourteenth — so *FIFTEEN* became *FOURTEEN* there and in §1 above (+1 B; the figures above are the file as committed). The literal sweep against the certified copy lost and gained no needle, and the two gates that open that file were re-run on the committed tree: **`check_fg` 22 / 0 and `check_hn` 74 / 0, each its row** — HL's precedent for a one-word edit after the run. **The batch is two commits**: the batch, and a second correcting §4's count of this batch's own folders — eighteen, not seventeen, since the replay of the flake on HEAD's tree made one after the run (`check_es` re-run on it: 57 / 0).

## §8 — WHAT MOVED

**THE GAME.** `data/runes.json` (the one name); `scripts/map_screen.gd` (the pouch's line, and the cache toast's marker);
`scripts/classes.gd` (Guard Change's row: its `why` and its comment); `scripts/battle.gd`, `scripts/runes.gd`,
`scripts/unit.gd` (comments only: the name, Ordination's threshold, the roll call's marker).

**THE INSTRUMENTS.** `check_hn` (new); `run_battery.sh`'s GATES ends with it; `baselines.json` — `check_hn`'s row and `check_parse` 202 → 203; `pin-manifest.json` rebuilt, 1544 → 1560. **No existing gate or suite was edited.**

**THE DOCUMENTS.** `CLAUDE.md` (the ceiling and its ruling; the confirmations' reasons and markers; the census bullet
in the crest block; FK §2a's long-shape clause); `docs/instrument-rules.md` (two stale copies of the ceiling);
`docs/master.html` (the stamp; the Elevation and Blessing rows; the crest paragraph's two census facts);
`docs/changelog.html`; `docs/design-notes.md`; `docs/state.md` (rewritten); this report.
