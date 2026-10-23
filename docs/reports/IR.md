# BATCH IR — THE SEVEN THE CENSUS FOUND IN THE CODE, AND THE RENAME MAP

**On `class-merge`, from `11ef9fa` (IQ). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `11ef9fa`, IQ's push and local
HEAD, before anything ran. **The designer's files were backed up first** (`../save-backups/IR-20261022-151943`, 15:19:43) and read
only through copies: `run_save.bin` (55,264 B, md5 `fcb20c91…`) and the clean readout `run-20261018-194229.jsonl` (24,340 B, md5
`610bcd8c…`) at the open, **the readout still the one run — it has not grown**, and the same two md5s at the close (§3).

**What IR did.** **§1 — every one of IQ's seven code findings is changed in the code, and each family was censused before its two
were fixed**: Ruin's mini-boss fights its fixed modifier and offers no bargain (§1a; a Ruin run loses 3.0 offers); ten ally-target
cards whose words say *hero* offer only the heroes, where the brief named two (§1b); Aegis Wall and Hunter's Mark say *the heroes* and
*every ally* (§1c); Tithe pays nothing for a blow that landed no Break — 29.9% of its blows on HEAD, each healing 1 — and the family's
census found one more of the shape, Sacred Resolve billing a parried blow, fixed with it (§1d); the seven statuses have glossary
entries, Frostbind's chip finds its own, and the population is read every battery (§1e); a bow user's blocked shot plays
`bow_blocked` (§1f); a choose-three card rolls one miss a target (§1g). **§2 — the rename map**: five rows, where the brief named two,
every card name a save carries read by today's, a name never a card kept and said out loud. **§0** — the rulings recorded where each
binds; **the claims counted: 87 stand, not 88**. **No save version moved.**

**VERDICT: GREEN**

## NEEDS A RULING

1. **A SECOND RUN, WITH A DIFFERENT PARTY** (carried from IQ's ruling 1). The readout's clean file is md5-identical at IR's open and
   close: every figure in THE FIRST CLEAN PLAYTHROUGH (`docs/state.md`) is still one run and one party.
2. **MANTLE's PICK NAMES NOBODY** (§1b). Its words name no target for the first shield, so it is sorted ALLY: the shield lands on a
   companion and works there. But its pass walks the heroes, and *every one of them builds Faith like the first* is false when a
   companion holds the first (Faith is heroes-only). Keep it an ally card, or narrow it to the heroes.
3. **A CARD REMOVED SINCE THE SAVE FLOOR HAS NO ROW** (§2). Flash Freeze (retired at DR) and Observance (deleted at CG; Vespers took its
   slot) have no name today to be read by, so a save from before either still holds a card the game does not have — a slot taken, a
   blank button. It is loud now (the load names it). Drop it at the load, freeing the slot, or keep it loud.
4. **A SAVED RUNE's PAYLOAD THAT NAMES A RENAMED FIELD** (§2; IQ's latent WRONG, found live). Deepening Hex wrote
   `rune_hex_threshold: 8` from EZ until FO renamed the field `rune_hex_deepen` **and changed its meaning** — it installed a threshold
   of 8; it now subtracts 2 — so no name map can repair a save from that window, and the rune pays nothing there (`set()` drops an
   unknown field). Rebuild a stale payload from today's data at the load, or keep HR §0's rule that a payload rides the save as built.
5. **SPLIT SHIELD's WORDS SAY *THE ALLY HE SETS IT IN FRONT OF*** (§1b, beside the family): its picker offers the heroes alone
   (`_split_shield_allies`; a companion makes no Block roll), so the word is *hero*. Rune text is yours.
6. **THE FRAMING CARD's BUTTON STOOD BELOW THE SCREEN** (§1a). The first run's framing card measured 660 px tall from y=150 on a 720-px
   screen, so *Take the road* — the one way past it — was drawn at y≈780 on a fresh profile's first map. IR places the card by its own
   height (foot at y=690; GT §1's rule: make room, shrink nothing). Measured headless, not seen in play: confirm it on screen.

## THE BRIEF's PREMISES, CHECKED

| # | the brief | what the repository says |
|---|---|---|
| 1 | §5: premise 1 is IQ's push hash | **True** — `git ls-remote origin class-merge` read `11ef9fa`, IQ's push and local HEAD, before anything ran. |
| 2 | §0.2: 47.4–48.6% off `CLAUDE.md`, 71.2% off `docs/state.md`; 4 targets with 7 pins against 46 with 144 in 42 gates; 14.4%, 35.4% | **True** (IQ §3). |
| 3 | §0.2: `CLAUDE.md` 36.21 KiB under, 19.6 batches at the IM–IQ mean | **True** (IQ's two readings). |
| 4 | §0.6: 185 units and 117 batch names | **True** (IQ §2, ruling 6). |
| 5 | §0.6: *twenty of the thirty-one false facts were was / now and since clauses* | **Not found.** IQ's report and its census count 171 disagreements; no figure of 31 false facts appears in either. The ruling does not rest on it. |
| 6 | §0.7: IJ converted 402 player-facing figures; about eighty constants; `check_iq` §2 holds 695 | **True** (IJ's report; IQ §2c). |
| 7 | §0.8: the batteries finished at 23:37 and the script sat | **True** (IQ §9). |
| 8 | §1a: `accept_offer` overwrites the armed modifier; the sim takes the bargain first and the never-stack guard skips it | **True**, read in `map_screen._on_node_pressed`, `run_state.accept_offer` / `arm_fixed_modifier` and `run_sim`. |
| 9 | §1a: *the band IM and IP built has never been fought* | **Half.** The fixed band is IN §1's (`FIXED_MODIFIER_BAND`, confirmed at IO §0.4; IO and IP re-graded what it holds). Never fought by a mini-boss: **true** — the sim's mini-boss took a bargain, and no gate walked a Ruin mini-boss through the map until `check_ir` §1a. The bosses fought it all along. |
| 10 | §1b: Covering Guard and Rally narrow the same pool | **Half.** Rally's pool left out the caster and every companion; **Covering Guard's left out only the caster** — a companion could be picked and the Block roll skips companions, so it did nothing. It is one of the ten (§1b). |
| 11 | §1b: Fortified Spirit's loan decays at its bearer's turn start; the Vigil's fork is wired on the four | **Both true** (`_fortified_tick`, `vigil_cb` at the spawn's hero loop). |
| 12 | §1c: both cards say *everyone* beside a *hero* or *ally* | **True** — and their chip and battle line too (Aegis Wall). |
| 13 | §1d: four ways to reach the floor — Broken, Bulwark, Immovable, Ironclad's cap | **One of four.** Tithe fires only on an enemy target, and Bulwark, Immovable and Ironclad are heroes': laid on the four, a hero capstone, laid on the caster. **On an enemy the ways are a Broken body, the Deadened bargain and a blow its Constitution (or Muffled) rounds to nothing** (`unit.take_hit`). |
| 14 | §1d: ID found one, IQ found this one | **The census: 323 literal floors, two live of the shape** — Tithe, and Sacred Resolve's split. ID's Mirrorbound is FLOOR-BY-DESIGN now: ID repaired its words (*at least 1, even when it deals none*). |
| 15 | §1e: Slow Burn, Heads Down, Unmaking, Breaking Darkness, Penance, Suffering, Blighted — of 35 in `DEBUFF_IDS` | **True, and an eighth**: Frostbind's entry stood under `status_bound`, an id the chip's door (`"status_" + id`) never reads. |
| 16 | §1e: each *applied to a player's hero* and *named nowhere he can read* | **Applied BY a hero, to an enemy** — every one is laid by a hero's card on an enemy (`_apply_status(target / foe, …, attacker)`). Each chip carries its own text; what was missing was the glossary entry. |
| 17 | §1g: Cleave and Hex of Ruin | **True** — the two `choose_three` cards. |
| 18 | §2: Iron Will → Ironclad (CK), Magic Barrier → Nexus Ward (GN), both after BM's v10 floor; four reads take it straight | **True, and the population is five.** `classes.gd`'s history since BM (`8e822fe`) holds seven display names gone today: CK's and GN's, **CG's three renames — Matins → Divine Presence, Jubilee → Blessing of the Faithful, Anathema → Breaking Darkness** — and two removals, Flash Freeze (DR) and Observance (CG). The four reads: IQ §4b's census. |
| 19 | §2: the two latent WRONGs — a stat payload naming a renamed field, a payload naming a renamed card | **The card half has no live case** — 35 revisions of `data/runes.json` since BM: no payload ever named a renamed card (the map reaches the shape anyway). **The field half has one**, which no name map can repair (ruling 4). |
| 20 | §3: IQ closed at 602 folders, 261,904 KiB; spent prefixes 600 and 261,348 KiB | **True** at IQ's close; read again at IR's (§3). |
| 21 | §4: the claims stand at 86 plus two IQ found | **87 stand** — HX's 87 less IA §5's (IR06) and **one HY §4 made true** (CR01: *a rule about how a batch verifies itself is in `docs/instrument-rules.md`* — HX's evidence was the two HG blocks, and HY §4 moved them there), plus IQ's two. |
| 22 | §5: twenty-eight gate-source readers at IQ; IQ read 157 in 86 min 15 s | **True** (IQ §9). **Twenty-nine at IR** — `check_ir` opens files at the root. |
| 23 | §5: IQ closed at `CLAUDE.md` 473.79 KiB (36.21 under) and `docs/state.md` 278.17 KiB (101.83 under) | **True** (IQ's two readings). |

## §0 — IQ's SEVEN RULINGS, ANSWERED

1. **The second run is carried** (IR's ruling 1). The clean file has not grown: md5 `610bcd8c…` at the open and the close.
2. **The index pilot is IS's, on `docs/state.md` alone** — its reasons and its four conditions recorded in that file (THE INDEX PILOT IS
   IS's), so IS has them: reversible by construction; every row carrying its triggers and the core keeping every block seven of nine
   batches needed; each report saying which blocks it opened and needed; `CLAUDE.md` waiting.
3. **The class refusal is confirmed**, written beside the guard in `CLAUDE.md`'s FD §1 block with the designer's reason.
4. **The rename map is built** (§2).
5. **All seven code findings are changed in the code** (§1).
6. **The history strip is ruled and IS's**: *`master.html` says what the game is; a clause about what it was, or why, goes to
   `design-notes.md` or goes* — recorded in `CLAUDE.md`'s working agreement beside the user rule it extends. Nothing stripped here.
7. **The eighty constants are a later batch's** — on the roadmap, after IS, before the claims.
8. **The close note** (§0.8) is a standing rule beside the lane rule in `docs/instrument-rules.md`, with its index row, and **this report
   carries the close's own timestamp** (§9).

## §1a — RUIN's MINI-BOSS: A FIXED MODIFIER AND NO BARGAIN

**The meeting is removed, not arbitrated (the designer's).** `Run.arms_fixed_modifier(node)` — the rung arms one and the node is one
the route cannot duck — and `Run.offers_bargain(node)` — a bargain node that does not arm one — are the one question asked at every
door that decided the order: the map's press, the sim's walk and `resume_scene` (so a resumed Ruin mini-boss goes back to its fight,
not to an offer). `arm_fixed_modifier` keeps its never-stack guard; nothing can have armed one before it now. **The predicate, every
rung and every node that can carry either**: the two never meet; the mini-boss is the one node in both lists, and only on Ruin.

**Driven through the real map, which nothing had done**: on Ruin the party stood before the mini-boss and its button pressed — the
fight opened with no offer, no bargain and no reward on the step, under a modifier of the fixed band, the fight reading it as its own
and its log naming it; on Warden the mini-boss and on Ruin an elite still opened the offer screen.

**WHAT IT COSTS THE PLAYER, MEASURED AGAINST THE UNCHANGED TREE** (`--run 40` on Ruin, the default party, fully talented — lanes
*IB recon* on HEAD and *IB work* on IR): **HEAD 11.3 bargains a run, IR 8.3 — 3.0 fewer, one for each mini-boss reached**; completion
37 of 40 and 38 of 40, depth 48.85 and 48.83 of 49 — unmoved inside n=40. **What becomes false and was repaired**: the map's hover
(*A bargain is offered before it*) now says what the node does on Ruin; the first run's framing card (*Before every elite and mini-boss
… one of the three is always a mild one* — the second half false on Ruin already, which deals no mild option) names Ruin's mini-boss and
says the safer deal; the glossary's bargain entry (*before every elite and mini-boss*) and ladder entry; `master.html`'s ladder row,
§3, §3a, the loop and the offer screen. **The rung's own blurb stays true** (*Harsher bargains, and fixed encounters carry a modifier*).
**The offer screen counts nothing** — it draws the offer it is handed — so no count on it became false.

**AND THE FRAMING CARD WAS OFF THE SCREEN, FOUND WHILE ITS SENTENCE WAS REWRITTEN.** Measured headless (a probe reads the card's rect on
a fresh profile's first map): 494 × 660 px at y=150, its foot at y=810 on a 720-px screen, on HEAD and on IR's first draft alike — so
*Take the road*, the card's one button, was drawn below the screen. IR held the new sentence to HEAD's three lines and placed the card
by its own height: foot at y=690. `check_ir` §1a reads both (ruling 6).

## §1b — A CARD WHOSE WORDS SAY *HERO* OFFERS ONLY THE HEROES

**The family, censused before its two were fixed** (II §0.7; `docs/reports/IR-ally-census.md`, one row a pick): every ally-target card
in the game — twenty — read for the words that name its pick and for whether its effect can arrive on a companion; every one of the
twenty `_hero_side()` call sites classed PICK or WALK; and the bot's pool for every card.

| | cards |
|---|---|
| **HERO, the pick took a companion and gave it nothing — narrowed** | Fortified Spirit (the loan sheds at a turn a companion never takes), Undying Vigil (the fork is wired on the four), **Covering Guard** (the Block roll skips a companion), **Rite of Return** and **Vow of Suffering** (their callbacks are wired on the four), **Aegis Reversal** (it spent a companion's shield for an attack the companion never takes — worse than nothing), **Renewal** (it pays at a turn start a companion never has; only its Perfect burst arrived), **Blessing of Zeal** (damage, cooldowns and Faith, none of which a companion reads) |
| **ALLY word, hero-only effect — word and pick both moved** | **Recant** (*one ally regains 40% of their Rage or Mana* — a companion has no bar), *one hero* now |
| **HERO, already narrowed** | Rally |
| **ALLY, the effect arrives** | Ministration, Unburden, Heal, Divine Plea, Dawnbreak, Second Wind, Vespers, Divine Shield; and **Mantle**, whose pick names nobody (ruling 2) |
| **its own pool** | Resurrection (the fallen) |

**Ten narrowed where the brief named two** — the same ruling, the same reason and no magnitude moved: each was a cast on a body that
could take nothing from it, and the bot had never aimed one there. **IJ's writing rule and IK's census passed over all ten**: IJ read a
card's words against its constant and IK the read site's collection, and neither asked who the PICKER offers. `battle._ally_pick_pool`
is the one answer now — the player's picker, the recast refusal (`_recast_targets`, whose pool must be the picker's) and two buttons
(Aegis Reversal's and Covering Guard's, which lit for a companion the picker would refuse) — with `HERO_PICKS` the list. **Every
surface that said *ally* for these moved with them**: the Vow's, the Rite's, the Vigil's and Fortified Spirit's chips, the glossary's
`lent_health` and `hero_vs_ally` (*a hand-aimed support card CAN be aimed at a companion, Rally excepted* is false now) and
`master.html`'s three rows. **`check_ir` §1b holds the twenty as the population** — a new ally-target card reds until sorted — reads
every pool with a companion standing, and drives Undying Vigil through the Cleric's real turn and real picker: it offered the four.

## §1c — NO CARD SAYS *EVERYONE*

**Each to the word the code reaches**: Aegis Wall's heal walks `heroes` — the four — so it *answers for the heroes* (card, chip and
battle line); Hunter's Mark is read by the strike loop and by `_companion_hit` alike, so *every ally strikes the same thing*. **Was
*everyone* hiding the §1b defect?** Not here: Aegis Wall is a walk, not a pick, and its words already said *every hero* for the heal;
Hunter's Mark reaches a companion as its *EVERY ALLY* said. `check_ir` §1c sweeps every card's words and every chip: none says
*everyone*. (The deck's modifiers say *everyone* and mean both sides — a different scope, not a card, and left.)

## §1d — A FLOOR PAYS ONLY WHEN WHAT IT IS A SHARE OF IS THERE

**Tithe** (`rune_blood_communion`, the crest's and the tree's *Breaking Heals a Hero*) took its share of `result.bd` — the Break the
meter took — floored at 1, behind a gate on `pr`, the Break the blow carried. **It is gated on the Break that landed now**; the floor
stays for a blow that lands a little. **The four ways the brief named are one** (premise 13): on an enemy the meter takes nothing from
a Broken body, under Deadened, or from a blow its Constitution or Muffled rounds away.

**MEASURED AGAINST THE UNCHANGED TREE** (Tithe forced into the crest every fight, Warden `--run 20`, the default party — two lanes,
*IB tracehead* on HEAD and *IB tracenew* on IR, a print at the read site): **HEAD — 12,099 Tithe blows, 3,614 (29.9%) landed no
Break and each healed 1: 3,614 health, 4.4% of the 82,722 Tithe healed, about 3.7 a fight. IR — 12,356 blows, 3,769 (30.5%) landed
none, and none paid.**

**THE FAMILY, CENSUSED** (`docs/reports/IR-floor-census.md`, one row a floor): **323 literal floors in the shipped game** — 152 not a
payout, 158 guarded, 11 floor-by-design, **2 of the shape**: Tithe, and **Sacred Resolve's split**, which divided a blow's damage over
the bound heroes floored at 1 a share — so a blow parried outright (a Feint charge, an Untouchable parry) billed every bound hero 1,
against *all damage received is split evenly* and a parry that *lands nothing*. **Fixed with it**: a split of nothing is nothing.
**ID's Mirrorbound is floor-by-design now** — ID repaired its words. Four latent shapes nothing writes, a rounding-up on a non-zero split
and three uncertain floors are FOUND AT IR. `check_ir` §1d drives Tithe on the four boards and the split on a parried blow.

## §1e — EVERY AFFLICTION HAS ITS GLOSSARY LINE AT THE CHIP's DOOR

**The seven are written** — Slow Burn, Heads Down, Unmaking, Breaking Darkness, Penance, Suffering, Blighted — each from its read sites
(the chip, the handler, the door that reads it), every figure that has a door through it (`{=Battle.BREAKING_DARKNESS_BD_PCT}`,
`{=Battle.PENANCE_MIRROR*100}`, `{=Battle.UNMAKING_LOCK_TURNS}`) and the three that have none — Suffering's 2 and 3, Slow Burn's window —
left to the card that states them, and read against the text standard first: *hero*, *warband*, no *everyone*, no *you*. **The
glossary is 109** (`test_batch_ce`'s count moves with its reason). **And an eighth, which the population found and the seven did not**:
a chip finds its glossary line at `"status_" + its id` (`Glossary.status_short`), and Frostbind's entry stood at `status_bound` — so the
Frostbind chip never surfaced it. Re-keyed to `status_frostbind`, words unchanged (`test_batch_cb` re-pointed). **The repair is the
instrument**: `check_ir` §1e reads every id in `DEBUFF_IDS` — 35 — through the chip's own door, the term named for the chip, no raw
token.

## §1f — `bow_blocked`

**Played, not deleted**, because the comment's promise was a set of three — attack, impact, blocked — and two were already played:
`_block_sfx(attacker)` gives a bow user's blocked blow its own sample and everyone else's the parry's, at the one block line. One `_sfx`
call either way, so no die moves. Driven: an Orc Archer's arrow and a Hunter's shot into an Interpose charge play `bow_blocked`; a
raider's blocked blow rings the parry.

## §1g — THE CHOOSE-THREE MISS

`choose_three` joins the single-target guard beside `choose_two`. **The population is `Ability`'s own targeting fields** — `aoe`,
`multi_hits`, `random_hits` and every `choose_*` — five, and every one is named now; `check_ir` §1g reads the `choose_*` fields off
`ability.gd`, so a sixth reds. **No fourth kind waits**: two widenings are not fields — the Cold Snap rune's Ice Lance (one roll on the
aimed target decides it, as a single-target card's should) and Kill Command's Aguila pair (a special, resolved outside the strike
loop). Driven: Cleave with its first target unhittable — that target logs one miss, and the other two are each struck or roll their own.
**One die fewer a choose-three cast**, which re-selects `check_gv` §4's seeded road where the Occultist casts Hex of Ruin (§9). (Mirror
Image no longer spends a charge on a choose-three cast's first target — none reaches the Mage.)

## §2 — THE RENAME MAP

**The rows are derived, not taken from the brief**: every `display_name` removed from `classes.gd` since BM's v10 floor and absent
today — seven — read at the commit that removed it: **five renames** (CK's Iron Will → Ironclad; GN's Magic Barrier → Nexus Ward; CG's
Matins → Divine Presence, Jubilee → Blessing of the Faithful and Anathema → Breaking Darkness — CG's own commit wrote each as an arrow)
and **two removals** (Flash Freeze at DR; Observance at CG, Vespers in its slot). `Run.RENAMED_CARDS` holds the five, append-only.

**`_rename_saved_cards` runs at `load_run` beside IQ's guards**, over every place a save carries a card's name: a hero's pool and
loadout, both queued offers, the draft's refusals, the upgrades queued and held (a pair the map makes twice keeps one), and a saved
rune's payload (`ability`, `grant_ability`, an `owns_ability` condition). **A name no row maps and no card holds** (`Classes.ability_corpus`,
the one enumeration — the class basics a rune names are in it and in no pool) **is kept as saved and said out loud** (`push_error`,
and `Run.load_unknown_cards` for the instruments). **Driven through the real save and the real load**: every family holding an old
name loads it as today's, the four reads resolve it (the offer's card and the spawn through `pool_ability`, `apply_upgrades` lands the
upgrade, `upgrade_choice` answers on Ironclad), no die is spent, a never-a-card name is kept and named, and a clean save loads untouched.
**The two latent WRONGs**: the card half the map reaches (no live case — premise 19); the field half it cannot (ruling 4).

## §3 — HOUSEKEEPING

**THE MOVE IS NOT ATTEMPTED** (IB §4). **At IR's close 602 folders, 262,872 KiB** (IQ's close: 602, 261,904). **IR made no folder — the eleventh batch running**; the lanes it reused are named below. **The spent prefixes** — every *Dawn of Decay* copy from FX to IN and the five *DoD …* copies — are **600 folders, 262,316 KiB**. **ONE command clears them**, leaving the live *Dawn of Decay* folder and `[unnamed project]` — IP's command, unchanged, because IR made no folder its patterns miss:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IN)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-J]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IN)/"
```

Each pattern was listed at the close before it was written here — 470, 125 and 5 folders — and none reaches the live folder. **IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the paste first. **And clearing them ends the reuse**: the next batch makes its lanes again.

**`lane.sh` FOR EVERY LAUNCH, AND IT IS SO.** Every Godot process IR started ran in a lane through the driver — the probes (*IB
probe*), recon 1 (*IB recon*), the measurements (*IB recon* and *IB work*; *IB tracehead* and *IB tracenew*), the pre-run, recon 2 and the
needle proof (*IB work*), the controls (*IB ctlA*, one clone at a time), the traces and the pre-pass — and the acceptance in the repository, through
`./run_battery.sh`, as the driver's own rule says. **IR made no user-data folder**: every lane wore an IB name whose folder existed.

**THE DESIGNER's FILES.** Backed up first (`../save-backups/IR-20261022-151943`, 15:19:43), read only through copies, touched by
nothing: `run_save.bin` (55,264 B) `fcb20c91…` and the clean readout `run-20261018-194229.jsonl` (24,340 B) `610bcd8c…` at the open (15:19:43), when the first acceptance was stopped (18:18) and at the close (19:52:20), with `profile.json`, `relics.json`, `settings.cfg`, IH's first readout and `latest.txt` byte-identical to their backup each time. **The readout has not grown and no newer file has appeared**: the clean file is still the one run (ruling 1).

## §4 — WHAT IS DELIBERATELY NOT DONE

- **The index pilot and the history strip are IS's** (§0.2, §0.6); the eighty constants a later batch's (§0.7).
- **The claims are counted, not repaired: 87 stand** — HX's 85 standing and IQ's two (`docs/reports/IR-claims-census.md`, every row
  against today's file and code). Two of the 87 are the starter-rung block's *clearing rung 1 is the only door* and the relic block's 25
  read sites (22 in the game, 26 with the sim's). The recount's notes for the repair batch are FOUND AT IR.
- **Nothing from the playthrough and nothing of the deck's middle.** **No grade, count or band moved**; the two ties keep the sort's
  order; the Thin Veil keeps Feverish's rule in Feverish's grade.
- **The instrument defects IQ found stand, not repaired and not forgotten**: `check_hn` §2a's worn arm reads the bag's rune, and `check_ho`
  §8's fixed 2,400-character window runs past its 2,288-character block — the *fixed window runs past its arm* shape, still waiting for
  a needle that notices.
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; the vow, the recoil floor and Anointing untouched; the
  third slot ungated; the art not commissioned; a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction
  half; Marrowfire's re-cut and `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the Occultist's Break card;
  the Skirmisher and the Tracker; Channel's tempo payout; the fallen-hero ruling and its seven things; Tithe's read site (its gate moved,
  not its site).

## FOUND AT IR AND NOT FIXED

- **The claims' own notes** (the recount): CR04 is false for a new reason — four of its six named banks are display chips since IG §1 —
  so its population is re-derived, not re-counted; CR12's count grew (five sites store Burn's power since IE §3b); eleven rows are a
  batch's measurement in the present tense (IR03, IR04, IR14–IR20, IR58, IR62), where HY §6's rule may want the past tense; two claims
  have copies outside the references (`baselines.json`'s `check_cm_live` note, IR41; `check_fg.gd`'s header, IR05).
- **Four latent floor shapes nothing writes today**: Sacred Covenant's Faith floor gated on the heal field, not the Faith; Slow Acting
  would lift Thin Blood's zero tick back to 1; Sacred Resolve's RECOIL split would bill 1 each if Blowback ever zeroed a recoil; the
  temporal rift reads a blow's damage with no zero test.
- **Sacred Resolve's split rounds a small blow up**: a 1-damage blow on four bound heroes bills 4 — each share floored at 1. Not the
  zero shape; the designer's if it matters.
- **The combat file's Mirror Image bullet is incomplete since §1g** (HY's re-read, §9): it names *a chosen pair* among the kinds
  that spend no image, and a chosen three spends none either now. True as far as it goes; a reference edit for the claims batch.
- **Three floors read, not driven**: Shatter's and Winter's Toll's `maxi(hold_turns, 1)`; Cull's and Harvest's guard and payout counted
  two ways around the purge; Returned Burden re-laying an effect lifted at 0 turns for 1.

## THE TWO READINGS

**`CLAUDE.md` is 488,879 B = 477.42 KiB against its 510 KiB ceiling — 32.58 KiB under** (+3,723 B at IR: the rename rule and the class refusal's confirmation in the FD §1 block, the no-bargain bullet in the ladder block, the hero-pick bullet in the hero/ally block, Tithe's sub-bullet in the crest block, the glossary-door sentence beside `DEBUFF_IDS`, the history clause in the working agreement, and the index's row and sentence): 4.0 batches at EZ's record (8,293 B), **14.3 at the mean of IN–IR** (2,340 B: IN +1,654, IO +2,851, IP +1,908, IQ +1,562, IR +3,723).
**`docs/state.md` is 286,737 B = 280.02 KiB against its 380 KiB ceiling — 99.98 KiB under** (+1,888 B at IR: IR's own writing +8,273, the archive's cut −6,385 — IQ's rulings and nine closed items, word for word): **12.4 batches at IR's own writing, now the worst case** (IA's +5,860 B was, until IR); **22.6 at the honest rate** (4,535 B: IN +1,476, IO +1,714, IP +5,787, IQ +5,424, IR +8,273). **IR's own writing is the largest in the window**: the six rulings with their reasons, the pilot's four conditions, FOUND AT IR and the WHERE block — and it is why the honest rate fell from IQ's 50.3. *The file's first fill of this line took IR's net delta for its own writing, and read 31.6; corrected before the acceptance (§9).*

## §9 — THE VERIFICATION

**WHAT WENT IN BEFORE WHICH RUN.** In order: the code (§1, §2) and its parse (`check_parse` 233 / 0 in a lane); **the two measured
things**, each against the unchanged tree on its own (§1a's offers, §1d's floor); the censuses (§1b's family, §1d's floors, the claims);
**the literal sweep over the code, before recon 1's prediction** — six lost literals, each one of HEAD's pins on a line IR moved
(`check_ij` ×2, `check_hp`, `test_batch_bp`, `test_batch_br`, `test_batch_cb`), no gained literal an absence pin, every moved count a
bracket balance or a function separator; **recon 1** (HEAD's battery on IR's code alone); then **every document** — `docs/state.md`
(its WHERE block, IQ's rulings and nine items moved to the archive word for word, IR's rulings, the pilot's conditions, the roadmap),
the archive's cut, `CLAUDE.md`'s six additions and its index row, the instrument rules' block and bullet, `master.html`'s repairs and
stamp, the changelog, the design notes, the glossary, and three kept censuses — built as scratch copies, swept, and landed behind a
hash guard; then `check_ir` joined the battery, the re-pointed pins went in, the baselines rows were written and the manifest
regenerated (1,897 → 1,905: eleven new needles, three gone, every one IR's own, none unresolved); then **the pre-run**; then **recon 2**
(IR's own battery on IR's tree); then the controls, the traces and the acceptance. **After the code sweep, one code edit** — the
framing card's sentence and its placement (§1a) — swept again before recon 2: one lost literal, `check_ij`'s framing row, re-pointed.
**And after recon 2, one document edit**: `docs/state.md`'s own reading, whose honest rate had taken IR's net delta for its
own writing — IQ's method is the net plus the cut, and IR cut 6,385 B to the archive — found while this report was written, with
the acceptance six minutes in. **It was stopped** (the launcher, its `ps` logger, both runners and both Godot processes, by pid;
the player's seven files read against their backup, all the same), the line re-filled at its fixed point — three lines, nothing
else — the manifest read current (1,905), and **the sixteen targets that name the file run on the edited tree in a lane — `check_es` 57, `check_fg` 30, `check_hp` 171, `check_hx` 39, `check_iq` 83, `check_ir` 134, `check_ed` 18, `check_dm` 93, `check_ek` 47, `check_fr` 25, `check_ij` 49, `check_ii` 97, `test_batch_at` 359, `test_batch_aj` 213, `test_batch_as` 273 and `test_batch_aw` 212, each / 0 and each at recon 2's count** (`check_de` names it too, and is a post-pass over a battery's logs: the acceptance reads it). Then the acceptance ran from the start.

**THE SUPERLATIVE CENSUS RAN FIRST**, with IO's site test, IO's census the checklist and not the population: a read-only reader over all
157 targets and both fixtures, every reader of the glossary, the chip texts, the descriptions, the ally picker, the recast pool, Ruin,
Tithe, `load_run`, Cleave and Hex of Ruin. **18 picks whose population IR touches — 5 SITE, 9 WEAK, one positional read, one sampler,
one group of seeded roads and `check_ir`'s own — and IR re-selects two**: `check_gv` §4's two-engine road (seed 20260919), every
roll-order filler after the Occultist's first Hex of Ruin, because a choose-three cast spends one die fewer; and `check_hz` §2's ranked
figure for Cleave (re-rolled; the pick, Rampage, holds). **No verdict flips on either**, as the census predicted: recon 2 read `check_gv` §4's two-engine road at **27 battles, stopped at zone three's slot 17** (33 in IQ's log), every arm green at 1,057 / 0; and `check_hz` §2's Cleave at **34 / 37** (HEAD's 35 / 39), its pick Rampage at 45 / 52 on both trees, 107 / 0. **The
longest-text picks the brief named do not move**: `check_ih` §5's longest description is Harvest's (346 characters) on both trees — IR's
three are 162 to 166 — and `check_cl_width`'s widest line is Stabilize's; the glossary has no pick by superlative or position, only
`test_batch_bx` §5's 3,000-character window, byte-identical on both. About thirty positional reads over the files IR changed were
emulated on both trees and none flips; `test_batch_bw`'s Vendetta window now ends in Aegis Wall's reworded line, both its asserts holding.
**No gate walks a Ruin road through a mini-boss**, so §1a re-selects nothing.

**RECON 1 — HEAD's battery, IR's code alone**, in a lane (*IB recon*), 15:58:33 to 17:23:09: predicted *reds in `test_batch_ce` (the
glossary's count), `test_batch_cb` (the bond's id; short), `check_ij` (two), `check_hp`, `test_batch_bp` and `test_batch_br` — each a pin
on a line IR moved — everything else at its row, the two sanctioned reds as IQ read them* — **read 157 targets; exactly those six red
(`test_batch_cb` 2,100 against 2,107), the sanctioned two with IQ's FAIL text, the run harness PASS 22 / 382 / 8, no `Parse Error` —
and one red the prediction did not name: `check_ed` 18 / 1**, the manifest's view of the same three pins (`check_hp`'s, `test_batch_bp`'s
and `test_batch_br`'s, on HEAD's manifest). The literal sweep had found them; the prediction should have named the instrument that
indexes them too (II §0.7's rule names `check_ed` for exactly this). **No other count moved**: the choose-three die moved nothing in
HEAD's battery.

**THE PRE-RUN — 34 targets that read gates, rule files, the glossary or the save door**, on IR's tree in a lane (*IB work*): every one
green but `check_ij` §2e, the framing card's row (re-pointed, then 49 / 0). `check_gw` 76 / 0, **96 sites in 10 targets, ceiling 96, not
risen**; `check_ed` 18 / 0 on the regenerated manifest; `check_hx` 39 / 0 with every backticked name IR wrote resolving; `check_parse` 234
/ 0; `check_ir` 134 / 0; `check_gv` 1,057 / 0.

**RECON 2 — IR's own battery on IR's tree**, in a lane (*IB work*): predicted *every target at its row — `check_parse` 234 and `check_ir` 134 the two new rows — `check_de` 649 / 0 / 0, the two sanctioned reds as IQ read them, `check_gv` §4's road re-selected at its count, `check_hz` §2's Cleave re-rolled with its pick holding, the banded suites in their bands, the run harness PASS 22 / 382 / 8* — **read 16:46:03 to 18:11:17, 157 targets: `check_de` 649 / 0 / 0, every one of the 157 on its recorded line**; `check_cm_live` 13 / 5 and `check_gj` 70 / 1 with IQ's FAIL text (*the bar appeared on the enemy's attack*; *the card says +175 gold and the purse moved 195*); `check_gw` 76 / 0, **96 sites, ceiling 96**; `check_gv` 1,057; `check_hz` 107; `test_batch_an` 6,053; `test_batch_bk` 130; the harness PASS 22 / 382 / 8, no throw; **no `Parse Error` and no `SCRIPT ERROR` in any of its 158 logs.** It ran beside recon 1's last 37 minutes — two batteries in two lanes.

**THE CONTROLS — one clone of the final tree each, its anchor asserted once before the edit, read by its FAIL text:**

| | the break | the arm | read |
|---|---|---|---|
| C01 | the map press asks BARGAIN_NODES again | §1a: the map press | 5 red — *the map's press does not ask `Run.offers_bargain` before the offer screen* |
| C02 | offers_bargain forgets the fixed modifier | §1a: the predicate | 8 red — *a node that arms a fixed modifier is also offered a bargain: ["ruin/miniboss", "ruin/miniboss"]* |
| C03 | Fortified Spirit leaves HERO_PICKS | §1b: the HERO rows | 2 red — *`HERO_PICKS` is not the HERO rows' specials — missing ["fortified_spirit"], extra []* |
| C04 | the pool never narrows to heroes | §1b: the pool | 2 red — *read 19 of 19 cards' pools with a companion standing — ["Rally offers the companion", "Covering Guard offers the companion", "Undying Vigil offers …* |
| C05 | Aegis Wall's card says everyone again | §1c | 2 red — *a card or chip says everyone, where the words are hero or ally: ["Aegis Wall"]* |
| C06 | Tithe pays on the Break carried | §1d: Tithe | 3 red — *a blow that landed no Break (broken) healed 1* |
| C07 | the Unity split bills a zero | §1d: the split | 1 red — *a blow parried outright billed the bound heroes: ["Warrior -1", "Mage -1", "Cleric -1", "Hunter -1"]* |
| C08 | Penance's entry deleted | §1e: the population | 2 red — *an affliction the game lists has no glossary line at the chip's door: ["penance"]* |
| C09 | Frostbind's entry back at status_bound | §1e: the chip's door | 2 red — *an affliction the game lists has no glossary line at the chip's door: ["frostbind"]* |
| C10 | a block always rings the parry | §1f | 2 red — *Orc Archer's blocked blow played bow_blocked false and parry true — want the bow's* |
| C11 | choose_three leaves the single-target guard | §1g | 2 red — *a targeting kind the single-target miss guard does not name, so it rolls a whole-cast miss first: ["choose_three"]* |
| C12 | a rename row dropped (Matins) | §2: the rows | 7 red — *the load door's rename map is { "Iron Will": "Ironclad", "Anathema": "Breaking Darkness", "Jubilee": "Blessing of the Faithful", "Magic Barrier": "…* |
| C13 | an unknown name is dropped, not kept | §2: never a card, dropped | 1 red — *a name that was never a card was dropped or rewritten — ["Heal"]* |
| C14 | the map is never read at the load | §2: the load door | 13 red — *the rename map is not read at the load door* |
| C15 | the framing card back at y=150 | §1a: the framing card | 1 red — *the framing card runs to y=810 on a 720-px screen — its one button is off it* |
| C16 | the ladder rule's words gone from CLAUDE.md | §0 | 1 red — *CLAUDE.md does not hold 'A NODE THAT ARMS A FIXED MODIFIER OFFERS NO BARGAIN'* |
| C17 | an unknown name translated to a guess | §2: never a card, guessed | 2 red — *a name that was never a card was dropped or rewritten — ["Heal"]* |
| **H01** | HEAD's code under the final gate | every arm on the code | **41 red** — *`Run.offers_bargain` / `Run.arms_fixed_modifier` — the one question — is not in the game* |
| **H02** | HEAD's documents under the final gate | §0 | **5 red** — *CLAUDE.md does not hold 'A RENAME THAT CROSSES THE SAVE FLOOR ADDS A ROW TO THE LOAD DOOR's RENAME MAP, IN THE BATCH THAT RENAMES'* |
| **R01** | re-tune: Breaking Darkness 25% -> 30% at its constant | §1e: a figure through its door | **134 / 0, green** |

**Seventeen breaks, each red with the FAIL text of the arm it breaks. H01 — HEAD's game scripts and data under the final gate — reads 106 / 41, red in every section that reads the code** (§1a 1, §1b 9, §1c 4, §1d 4, §1e 3, §1f 2, §1g 2, §2 16) and green in §0 and §9, which read the documents and the player's files; **H02 — HEAD's documents — reds §0 alone, 5.** **R01, the re-tune, stays green**: Breaking Darkness's figure moved at its constant reaches its glossary line through the token, so §1e asks the door, not the number. `check_gw` 76 / 0 at 96 sites: **the ceiling does not rise.**

**THE OK() TRACES** (moved counts attributed; IR spends a die fewer only on a choose-three cast, and no traced target casts one, so no
stub was needed): **`check_parse` 233 → 234** — the gate printed every file it verified on HEAD's tree and on IR's, and the two lists
differ by one line, `res://check_ir.gd`; **`check_de` 645 → 649** — one row more, its four checks; **`check_ir` new at 134**: §0 6, §1a 29, §1b 41, §1c 7, §1d 7, §1e 6, §1f 4, §1g 5, §2 26 and §9 3 — **134**, each section's `ok()` lines counted off the gate's own print in recon 2, and the sum is the row.
**`check_ij` stays at 49**: read 50 / 1 in the pre-run, 49 / 0 once its framing row was re-pointed — a failing list adds a check per
failure, so a red run is not a row. **No other count moved**: `check_de` read every one of the 157 targets on its recorded line in recon 2, so no other trace is owed. In recon 1, on HEAD's battery, `test_batch_cb` read 2,100 against its 2,107 — its Frostbind section returned at `status_bound`'s absence, seven checks short — and 2,107 again once re-pointed; `check_ij` read 51 / 2, a failing list adding a check per failure.

**THE GATE-SOURCE READERS READ `check_ir`'s FINAL SOURCE BEFORE THE ACCEPTANCE**: **twenty-nine by `check_ij` §0.4's derivation** — 28 open
the root and 3 read the battery's list — **`check_ir` among them because it opens files at the root** (`CLAUDE.md`, the instrument rules,
`docs/state.md`); it reads no gate's source. **Every one green in recon 2, on `check_ir`'s final source** (md5 `85c81ecb…` in the repository and in the lane): `check_da` 41, `check_dw` 36, `check_ea` 396, `check_ec` 24, `check_ed` 18, `check_eg` 69, `check_ek` 47, `check_es` 57, `check_ez` 135, `check_fd` 60, `check_fe` 79, `check_ff` 68, `check_fi` 27, `check_fn` 83, `check_gw` 76, `check_hc` 75, `check_hp` 171, `check_hx` 39, `check_ij` 49, `check_ik` 251, `check_il` 86, `check_im` 122, `check_in` 91, `check_io` 119, `check_ip` 48, `check_iq` 83, `check_ir` 134, `check_parse` 234 and `test_batch_cd` 92 — each / 0.

**HY's TWO RULES.** **The re-read**: every name IR's diff touches — its functions, constants, fields, statuses, files and gates — matched against both references: seventy lines, each read against the new tree. **None is falsified by IR.** The combat file's three idioms and DK's four widenings stand — Rally's is the talent's receive site, which still walks `_hero_side()` and which IR did not touch (§1b narrowed the card's pick, another site); the recoil's *a single-target miss does not* pay it holds; the glossary's whitespace holds (one space, no trailing newline — round-tripped after IR's entries); `test_batch_ce`'s pin was bumped with its reason, as its bullet asks. **One is met and is incomplete**: the combat file's Mirror Image bullet names *a chosen pair* among the kinds that spend no image, and since §1g a chosen three spends none either — true as far as it goes; reported here, not edited. **The live counts**: IR wrote two blocks into `docs/instrument-rules.md` — the rename map's arms and the close — and neither states one.

**THE ACCEPTANCE**, on the frozen tree, in the repository, the pre-pass beside it in its lane (*IB prepass*, re-synced after the stop), every row of
`ps` logged every 15 s: **18:24:48 to 19:52:16 — 87 min 28 s, 157 targets each** (IQ: 157 in 86 min 15 s). **The battery: `check_de` 649 / 0 / 0, every one of the 157 on its recorded line; the pre-pass: 649 / 0 / 0, the same.** In both: `check_cm_live` 13 / 5 and `check_gj` 70 / 1 with IQ's FAIL text; `check_parse` 234; `check_ir` 134; `check_gv` 1,057, its two-engine road at 27 battles; `check_gw` 76; `check_hz` 107; the run harness PASS 22 / 382 / 8, no throw. `test_batch_an` read 6,054 and 6,049 and `test_batch_bk` 131 and 130, each inside its recorded band. **158 logs each, and no `Parse Error` and no `SCRIPT ERROR` in any.** **`ps`, read row by row — 349 samples**: every row a Godot process whose parent is one of the two runners; two at once in 327 samples, one in 17 (a target ending), none in 5 (the first sample and the gaps between targets); no third Godot, no orphan, no other command. **The first launch, at 18:11:59, is the one stopped six minutes in** (above); its partial logs stay in the scratchpad and are read as nothing.

**THE CLOSE RAN, AND THIS IS ITS STAMP** (§0.8's rule). The launcher waited on the two batteries by their pids, stopped its `ps` logger,
and then ran the close itself: **`=== CLOSE RAN 2026-10-22 19:52:20`**, four seconds after the batteries' last (19:52:16). The tree — every file in the repository, tracked or not — was hashed as the acceptance started and again at the close: **identical**. The player's seven files against their backup: `run_save.bin` `fcb20c91…`, `profile.json` `608d89c0…`, `relics.json` `fdc12ffa…`, `settings.cfg` `0c1b39c3…`, the clean readout `610bcd8c…`, IH's first file `2b0f0212…` and `latest.txt` `e43f2d0a…` — **all seven the same**; the readout folder holds those three files and no other.

