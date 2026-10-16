# BATCH IK — WHAT THE CENSUS FOUND IN THE CODE

**On `class-merge`, from `739ef88` (IJ). IMPLEMENT ONLY.** **The designer has not played since IH, and no newer file has appeared**:
`run_save.bin` is IH's 40,284 B at 14:30 on 2026-10-14 and `readout/` holds IH's one debug-touched file, both md5-identical to
IJ's backup; both backed up again first (`../save-backups/IK-20261016-102016`, 10:20).

**What IK did.** IJ's census found nine places where the code, not the words, was at fault. **The small ones are repaired.**
**§1** — Blood Debt fires: with the rune worn, Blood Price's cost is the enemy with the most health's, chosen with no die, under the
Berserker's own frame, and he pays nothing. **§2** — Execute's picker offers only the enemies below the line or Broken, and a body
it will not name says why on its hover; the door, the picker and the bot ask one answer. **§3** — Sever's Perfect lays Sunder at
its own step and for its own duration (one constant, which Crushing Blow reads too); Reality Fracture's banks the engine's grant a
second time. **§4** — the talents are Iron Will and Undying Rage again, FX's labels the first line of their words. **§5** — the
glossary defines *Strike Damage*, and eight texts and the ward's chip say it; no payout widened. **§6** — Cairnmoss Poultice is
suspended from every door that draws or lists a relic, kept everywhere else; the bomb's line is in the items entry. **§0** — the
three rulings are written where each binds. **The two that move a measured figure — Sanctity's source gap and the Ruin rung's
severity — are IL's.** **No dice spender moved** (`randf` 37, `randf_range` 30, `randi` 2, `pick_random` 30 in `battle.gd`, as at
HEAD); **no save version moved.**

**VERDICT: **GREEN. The acceptance and the pre-pass both read `check_de` 621 / 0 / 0** — 151 targets, `check_ik` 251 / 0 new, the two standing sanctioned reds unchanged to the character (`check_cm_live` 13 / 5, `check_gj` 70 / 1). Every item of the brief's §0–§7 is built as ruled; §8's are not done, on purpose. **Two things the verification found and repaired before the acceptance**: the census of readers missed `check_hf` §0, which holds Clarity's and Profligate's words (recon 1 read it; re-pointed), and `check_ik` set the vow's field on a built Warrior, which `check_gw` §2 counts (recon 2 read it; seated through the spawn). **One finding left owed**: IJ §0.4's derivation of the gate-source readers leaves out `check_gw` (FOUND AT IK). **Seven rulings are owed** (below).**

## NEEDS A RULING

1. **PLAY ONE ZONE WITHOUT THE DEBUG MENU, AND SEND THE FILE** (IH's ruling 1, carried — II §0.1, IJ §0.1, IK §0.1: four batches
   old). Its first Hierophant confirms Sanctity's step — on IL's repaired code once IL lands; it prices Boil Over's rate, Rupture's
   number, the vow's worth and the Cleric's Mana.
2. **EIGHT OTHER CARDS GATE ON THE BOARD AND OFFER EVERY ENEMY, AS EXECUTE DID** (§2). Cull, Requiem, Funeral Pyre and Pyre Wake
   consume what the TARGET carries, and Hunt reads the target's afflictions, so a pick of a bare enemy is a dud or a floor;
   Firedraw, Transference and Cryoclasm move something ONTO the target from elsewhere, so a pick of the one body holding it moves
   nothing. **None of their words names a target**, which is why Execute's fix did not reach them; narrowing any is that card's
   change.
3. **THE BOT AIMS A DRAFTED EXECUTE AT THE LOWEST-HEALTH ENEMY** (`battle._bot_drafted_pick`), which can be above the line and not
   Broken; the Swordmaster's own rotation picks a legal victim. A sim policy — narrowing it moves sim figures.
4. **EXECUTE's DARKENED BUTTON SAYS NOTHING**, where every other gate on the board adds its reason to the button (*Nothing is
   Burning*, *No Ruin on the field to consume*). One line of new wording.
5. **TWO MORE CENSUS ROWS OF THE STRIKE's SHAPE** (§5's re-read): N077 Empty Pulpit's *50% less damage* and N078 Dead Air's *75%
   more damage* are read in the strike loop alone. Crest runes, left untouched by the brief (§8).
6. **WHICH TWO RELICS THE FALLEN-HERO RULING PRICES** — the brief: *three crest runes and two relics*. IK reads them as Cairnmoss
   Poultice and Martyr's Knucklebone, the two whose hooks carry `rest_heal_add`; the brief names only the first.
7. **THE BLOOD DEBT RUNE's WORDS DO NOT SAY WHICH ENEMY PAYS** (*Costs the ENEMY's health instead of his*) — literally true once it
   fires, as the brief ruled, and standing; naming *the enemy with the most health* is one clause if wanted.

## THE BRIEF's PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §9: IJ's push hash, read before anything runs | **Held**: `git ls-remote origin class-merge` read `739ef885…`, local HEAD the same — the batch's first git read (10:19) |
| 2 | §9: back up the saves and the readout first; IJ's is `../save-backups/IJ-20261015-105653` | **Held, done first** (`../save-backups/IK-20261016-102016`, md5-identical to the live folder and to IJ's): **nothing moved since IH, and no newer file** |
| 3 | §1: Blood Price's cost is health — *if it is Rage, or nothing, say so and stop* | **Held**: 7.5% of current health, never lethal (`maxi(int(round(attacker.hp * 0.075)), 1)`); the card runs no skill check |
| 4 | §1: the +25% chip (S041) and the bleedout mark (S120) are paid by the same cast | **Half.** S041 — the `blood_price` status, +25% damage dealt for 2 turns — is Blood Price's own. **S120 is the Blood Debt CARD's mark** (`blood_debt`, laid by that card's strike): a different card sharing the rune's name (BR §1's FK collision). **The redirect moves neither**; only the cost moved, and the chip's words now say whose blood paid |
| 5 | §1: the bill goes through `battle._dmg_frame` on the Berserker, *so it marks, feeds Siphon, can be the Reaver's killing blow and lands in the recap's ledger* | **Held for the frame, and read per payout**: `_resolve`'s entry sets the frame on him and the bill deals inside it, so every reader of the frame reads him as the dealer. Of the payouts, the Reaver, Momentum's dealt ledger, the recap and a judged enemy's heal reach a Berserker — each driven (§1c). **Siphon, the Weaver's tally and the two marks pay or mark for their holder, and no Warrior holds them** (`Classes.class_engines("warrior")`, asserted) |
| 6 | §1: *this is the family IJ closed; do not open a new site outside it* | **Held**: the bill deals in `_resolve_special`'s Blood Price arm, under the cast's frame — a function `check_hy` §6's census of damage sites already names; no new site |
| 7 | §1: ask `battle._landed` before the door (IC's rule, II's three sites) | **Held and built**: the float, the credit and the line read what the vow lets land; a vowed Berserker's bill lands nothing and says so (§1e — no Warrior is offered the vow, so it is worn on his member and seated by the spawn) |
| 8 | §1: `check_gv`'s arm called `_resolve` with an enemy directly | **Held**: `_cast(s, u, "Blood Price", f0)`. Re-pointed to the target the player's turn hands the card — its caster (§9) |
| 9 | §2: the gate asks whether ANY enemy qualifies; the picker offers every enemy | **Held** (`_ability_usable`; `_player_turn`'s pool was every living enemy, narrowed only for the upgraded copy he cannot pay for) |
| 10 | §2: *the hover is already the place every other refusal is explained* | **For a button, not a body.** Every darkened button explains itself on its hover; a target had no refusal hover at all, so IK built one (`BattleUnit.set_target_refusal`: a hover zone with the reason and no press). **Execute's own darkened button has no reason line** (ruling 4) |
| 11 | §2: other cards that gate on a condition and offer a pool read the same code | **Held: eight** (§2; ruling 2) |
| 12 | §3a: `BattleUnit.SUNDER_STEP` is 35% and the status stacks (Rending Blows deepens it) | **Held** |
| 13 | §3a: *its duration is Sunder's own — do not type 3* | **No constant held it.** Crushing Blow — every Warrior's kit card, the base application — typed 3 in its data, and the Perfect arm `sunder` (no card named it) typed 2. **IK named it once — `BattleUnit.SUNDER_TURNS`, 3, Crushing Blow's — and both read it**; the arm's 2 became 3 with no card moving. Other Sunders keep their own figures (FOUND AT IK) |
| 14 | §3a: *a Warrior who Perfects a Sever is now an ingredient the party can bring* | **He already was**: Crushing Blow lays Sunder for 3 turns on every Warrior, so Sunder and Burn on one body were reachable before IK. Reported: reachable; **no conjunction of them is built** (`CONJUNCTIONS` holds Rupture alone) |
| 15 | §3b: *An Arcanist also banks 1 Resonance* was the engine's own grant, paid at every grade; BJ pinned it as a later decision | **Held**: the Resonance block's base (`… if any_crit else 1`); `test_batch_bj` §2 pinned the inert clause and is re-pointed to the decision |
| 16 | §3: the class basics stay Perfectless — slot 0 resolves at a fixed Good (IJ, for Strike, Magic Bolt and Smite) | **Held for the words**: all three carry no `perfect_text`. Each still carries a `perfect_id` (rage, mana, self_heal) that never fires, since slot 0 never grades — recorded, unchanged |
| 17 | §4: the table — Iron Will (U1296, B0020) beside `talents.gd:180`; UNDYING RAGE (U1329, U1349) and S044 beside `talents.gd:211-213` | **Held** (IJ's census rows; the lines are HEAD's 181 and 211–213) |
| 18 | §4: `test_batch_br` pins the node's name | **In the inverse form**: since FX it asserted that NO node is called Iron Will. Re-pointed: the node is Iron Will, and no node is Ironclad |
| 19 | §4: *if FX's report gives a reason the name was replaced, say so and stop* | **It gives none**: FX took its brief's own labels for the names and recorded a rename as the designer's call (FX's ruling 8 and §9 — *whether a chip should be renamed after the node that applies it is the designer's*). So IK proceeded |
| 20 | §5: `type_dmg_bonus` and the ×0.75 are read at the strike and nowhere else | **Held**: one read each, in `_resolve`'s strike loop (Tinderbox's stamp WRITES the bonus) — `check_ik` §5c holds both read sites |
| 21 | §5: *the game already uses the word in its own log lines* | **Held** — a companion *strikes*, Last Howl pays *strike damage*, Loyalty's chip and the glossary say *companion strike damage* |
| 22 | §5: *A STRIKE — damage an ability deals as its blow lands* | **Taken, with one clause the code needs**: the definition as worded includes a card's own-rule blow — the glossary's *Missing* entry already calls those *strikes* — which no bonus to strike damage reaches (a Killing Frost: §5c). And the game calls a companion's blow a strike, which the ward does not lessen. The entry says both (§5) |
| 23 | §5: `check_gt` §2 read 477 px in 470 at IJ, tightened to 454 | **Held**: 454 at IJ's close; **454 after IK's words**, with Profligate now the Mage's longest |
| 24 | §5: re-read the census for any other row of the shape, and report the count | **Two** (N077, N078, crest runes — ruling 5), beside IJ's two already repaired (B0718, C125) |
| 25 | §6: `rest_heal_add` has no reader; R079's relic kept its other effects | **Held** (R079 is Martyr's Knucklebone) |
| 26 | §6: suspend it *exactly as The Cairn of the Fallen cannot be drawn* | **The Cairn is undrawable by its requirement** (`fallen_hero`, which nothing between fights holds), not by a flag. Cairnmoss had no requirement, so the pool gained a suspension — a `suspended` string on the entry, `Relics.is_suspended`, read at the four doors (§6) |
| 27 | §6: *say what suspending it does to the pool: the relic draft's weight total, and which weight it frees* | **No relic carries a weight**: every door draws flat (`pick_random`). §6 says what moves at each door instead |
| 28 | §6: the items glossary entry is G073L | **Held** (`consumables`'s long text) |
| 29 | §6: HZ ruled a bomb nobody's — it never marks, never feeds Siphon, cannot be a Reaver's killing blow | **Held**, and driven again beside the line (§6) |
| 30 | §7: IJ read 602 folders and 260,624 KiB; the spent prefixes 600 and 260,072 KiB | **Held at IJ's close**; IK's first reading: 602 folders, 260,548 KiB, the spent prefixes 600 / 259,996 KiB (§7) |
| 31 | §8: the claims stand at 86 | **86** (IN's; the figure only) |
| 32 | §9: the gate-source readers are twenty, 230 s at IJ | **Twenty-one** with `check_ik` (`check_ij` §0.4's derivation, the targets that open the root), 286 s — **and the derivation misses `check_gw`**, which reads every battery target's source through `run_battery.sh` and read recon 2 red (§9d; FOUND AT IK) |
| 33 | §9: IJ read 147 in 83 min 27 s | **Held** (IJ §9g) |
| 34 | §9: IJ closed at `CLAUDE.md` 461.69 KiB and `docs/state.md` 349.04 KiB | **Held** (472,766 B and 357,414 B at `739ef88`) |
| 35 | §0.10: 104 of the 214 `_apply_status` calls pass no source | **Not re-derived** — IL's partition is the census; IJ's ruling 9 read 110 of 214 passing one, the same split |

## §0 — IJ's RULINGS, ANSWERED

### §0.1 — PLAY ONE ZONE WITHOUT DEBUG

Carried, unchanged: IK's ruling 1.

### §0.2 — THE SEVEN THE CENSUS OVER-READ STAND, AND ○ IS WHY

**Written beside GX's sentence in `CLAUDE.md`** — the block *A CARD OR A RUNE THAT CANNOT PAY WITHOUT ITS ENGINE SITS OUT*, a bullet
headed *A RUNE WHOSE BRANCH NEEDS AN ENGINE IS NEVER DRAFTED DEAD, AND WORN WITHOUT IT, IT WEARS ○*: `Runes.ENGINE_READ` gates the
offer, a rune whose engine leaves its slot sits out and wears ○, so a text false only without its engine is not false. It names
N010, N026, N027, N030, N033, N036 and N043, which stand as written. `check_ik` §0.2 holds the sentence once, in that block, naming
all seven.

### §0.3–§0.10 — BUILT, OR RULED AND MOVED

Blood Debt (§1), Cairnmoss Poultice (§6), Execute (§2), the two Perfects (§3), the two names (§4) and the strike's word (§5) are
built below. **The Ruin rung and Sanctity's source gap are IL's** — each a magnitude, measured before and after — and both
conditions are written into `docs/state.md`'s roadmap word for word: Ruin's mean severity above Warden's by at least a full step at
the census's own sample, the lever Ruin's offer pool and never the severity values; Sanctity's 104 sourceless calls partitioned by
whether a Cleric can be the source, the ones that can repaired, the step re-measured on the repaired code. R016's, R091's and
G080L's words are untouched.

### §0.11 — THE WRITING RULE

**In the text standard**, as §4.9a beside the hero/ally section: *ALLY IS A HERO OR A COMPANION. A TEXT THAT MEANS THE FOUR MEANS
HERO; A TEXT THAT MEANS AN ENEMY'S OWN SIDE MEANS WARBAND.* — recorded as a writing rule, with the family it comes from (IJ's
largest). `check_ik` §0.11 holds it once, in the text standard and in neither rule file.

### §0.12 — AN INSTRUMENT THAT CANNOT READ A DEFECT IS NOT AN INSTRUMENT

**In `docs/instrument-rules.md`, with its row in `CLAUDE.md`'s index** (`check_hx` §1a holds the pair; `check_ik` §0.12 holds the
block, the row, and both halves of the rule). Its third case is `check_gv`'s Blood Debt arm, re-pointed at §1 and reported at §9.
**Applied to IK's own instruments** (§9b): the literal sweep's first run was read for a planted hit before its zero was believed,
and every needle `check_ik` writes is one phrase — the one `or` it grew while being written (a fallback over two slot-0 readings)
was deleted before any run.

## §1 — BLOOD DEBT FIRES

**The premise held**: Blood Price's cost is health, 7.5% of current health, never lethal. **The shape held too**: the card stays a
self-cast with no picker. With the rune worn, `battle._blood_debt_payer` names the living enemy with the most health — the first
in the warband on a tie, the order a moving mark already uses (`_mark_destination`) — and **the payer's 7.5% of its own current
health** is dealt to it through `take_hit`; the Berserker pays nothing. FK's arm had read the cast's `target`, which a self-cast is
always its caster, so the rune never fired (IJ's N023). **No magnitude moved**: the share is FK's formula, and the Frenzy steps the
rune books off the payer's missing health are FK's too.

- **NO DIE.** `_blood_debt_payer` names no dice spender, and the gate seeds the stream around a call to it and reads the same next
  roll (§1b). The integer pins on every dice spender are unmoved (§9b).
- **HIS DAMAGE, UNDER HIS FRAME.** `_resolve`'s entry sets the frame on the Berserker and the bill deals inside it — no new site. **What
  it reaches, each driven by `check_ik` §1c**: the recap books it under his Blood Price; Momentum's dealt ledger moves by the share;
  the Reaver counts its kill (the bill's floor of 1 on an enemy at 1 health); a judged enemy's wound heals every ally (Judgment reads
  the dealer, and he is a hero). **What it cannot reach**: Siphon, the Weaver's tally and the Tracker's and Arbiter's marks pay or
  mark for their holder, and no Warrior can hold any of the four (`Classes.class_engines("warrior")`, asserted).
- **NOT A STRIKE.** `take_hit` takes the share as computed: no school bonus, no general damage bonus, no armor, and not the +25% the
  same cast lays — §1d stacks all of them on him and the share is the payer's 7.5% to the point.
- **THE VOW.** The float, the credit and the line read `_landed`, asked before the door; a vowed Berserker's bill lands nothing,
  credits nothing and its line says *silenced* (§1e — no Warrior is offered the vow, so the gate wears it on his member and
  the spawn seats it; it writes no field it reads, `check_gw` §2's rule).
- **A KILL** is his: `_stat("kills")`, the kill hooks every hero's kill pays (`_on_enemy_death`), the Reaver's count off the frame at
  `_die()`, and a moving mark's move.
- **THE WORDS THAT FOLLOWED THE CODE.** The +25% chip's *paid in his own blood* now names the payer's blood when the rune paid (the
  status's own words, the one name swapped); Blood Price's line says *the payer pays the debt* rather than *bleeds N HP*; FK's
  comment says *the PAYER's* current health. **`master.html`'s Blood Price row** said *15% of current health* and *Perfect: the
  health cost is halved* — the card takes 7.5% and runs no check — and is repaired with the rune's paragraph beside it.
- **WHAT `check_gv` READ.** HEAD's arm passed an enemy to `_resolve`; on IK's code the rune bills the fullest enemy whatever the
  target, and every foe on that board stands at 50,000, so the tie goes to `f0` and HEAD's arm reads green on IK's code — which is
  why the re-point matters: **the arm now casts on the card's real target and reads every enemy's loss**, so on HEAD's code it reds
  (§9e, H01), and on IK's it drives a cast the game produces.

**Live, through the Berserker's own turn** (`check_ik` §1a, the player's real `_player_turn`, no picker): an Orc Raider at 87,000,
the fullest of three, paid 6,525; the two others lost nothing; he paid 0.

## §2 — EXECUTE OFFERS ONLY WHAT QUALIFIES

**One answer**: `battle._execute_line` (0.35 for the upgraded copy, else 0.2) and `_execute_qualifies` (below the line or Broken),
asked by the door (`_ability_usable`), the picker (`_player_turn`'s pool), its refusal hover (`_target_refusals`) and the bot's
Swordmaster rotation. The upgraded copy he cannot pay for still narrows to the Broken alone, after the line.

**The hover.** A living enemy the picker will not name gets a hover zone over its body for as long as the pick is open
(`BattleUnit.set_target_refusal`) — the reason as its tooltip, no press, no marker, outside the keyboard's pool and the plate's click —
saying *Execute: X is not below 20% health and not Broken, so it cannot be chosen.* (the line read off `_execute_line`), or, for the
copy he cannot pay for, that only a Broken enemy is free. `_pick_target` takes the refusals beside its pool and clears them as the pick
closes; every other caller passes none.

**Driven, in the fullest room the board holds** (`check_ik` §2, six enemies, the real turn): two below the line and one Broken were
offered and the three others refused, each saying its line; one qualifier was struck with no picker; none left the button dark; the
upgraded line offered the enemy at 30%, and with no Rage only the Broken one.

**THE CENSUS OF THE PATH** (II §0.7). The pool every single-target enemy card reaches is one line in `_player_turn`, and **eight
other cards gate on the board as Execute does and offer the whole living warband** — Cull, Requiem, Funeral Pyre, Pyre Wake and Hunt
read the target's own Burn, Ruin, yield or afflictions; Firedraw, Transference and Cryoclasm move a thing onto the target. **Each still
offers every living enemy** (the narrowing is keyed on Execute's name, and `_target_refusals` returns nothing for any other card — both
asserted; Requiem driven in the same six-enemy room offered all six). Their words promise no target, so none is narrowed; ruling 2.
Area cards (Killing Frost, Shatter), the field-wide gates (Backdraft, Wildfire) and the caster-resource gates (Arcane Bolt, Unmaking,
Death Ray) do not reach the pool.

## §3 — TWO PERFECTS, AUTHORED

### §3a — SEVER's PERFECT LAYS SUNDER

`"perfect_id": "sunder"` — the Perfect arm that already existed (`_apply_perfect_bonus`) and that no card had named. It lays Sunder
**one deep** (power 0, a base application's depth) for **`BattleUnit.SUNDER_TURNS`**, a constant IK names beside `SUNDER_STEP`: 3,
the turns Crushing Blow — the base application — lays, and Crushing Blow's data reads it too (`applies_status.turns`), so one figure
answers both. The arm's typed 2 became that 3; no card had named the arm, so nothing else moved. The Perfect's words read both
constants through `Ability.make`: *Sunders armor by 35% for 3 turns* (32 characters; 41 with the *Perfect:* label, under the 44
ceiling). Driven: a Perfect Sever lays Sunder one deep for `SUNDER_TURNS`; a Good one lays none; a deeper Sunder stays deep.

**What it opens, reported**: Sunder and Burn stand on one body — and already did, since Crushing Blow lays Sunder on every Warrior.
No conjunction of them is built (`CONJUNCTIONS` holds Rupture alone); Marrowfire's re-cut stays the design pass's.

### §3b — REALITY FRACTURE's PERFECT BANKS THE SECOND RESONANCE

In the Resonance block, beside Kindled Mind's line: on this card's Perfect, `res_gain += 1` — **the engine's own grant, the block's
`else 1`, banked a second time**; nothing above it moved, and `_gain_resonance` refuses a hero without the meter as it always did.
The words: *An Arcanist banks +1 Resonance* (39 characters with the label). Driven: an Arcanist banks 1 / 2 / 1 on a Good, a Perfect
and a Sloppy cast; Stoke's Perfect, the control card, banks 1; a Pyromancer's Perfect banks nothing. **No new figure and no magnitude
elsewhere**; the class basics' words carry no Perfect, as IJ left them.

## §4 — THE TWO TALENT NAMES COME BACK

FX's report gives no argument for the names: they were its brief's own labels, and it recorded a rename as the designer's (premise
19). **So the name wins**: `tn_iron_will` is **Iron Will** and `tn_refuse_death` is **Undying Rage**, and each node's words open with
FX's label as the line under the name — *Mitigation per debuff you carry.* and *Refuse death once.* — the rest of each text unmoved
(`check_fx` §1's phrases stand). **The readers, censused first**: the tree and every surface that lists it read the name off the node
(the board, the sheet, the build screen); the two chips already wore the names (`iron_will`'s *Iron Will*, `undying_rage`'s *Undying
Rage*); three log lines named the labels and name the nodes now (`battle.gd`'s mitigation line, `unit.gd`'s two refusal lines);
`master.html`'s talent table, its Iron Will chip row, its debuff paragraph and the Berserk row's *Builds with*; `CLAUDE.md`'s FX node
list and BR §1's Iron Will example; and five gates (`test_batch_br` §1 re-pointed, `check_ek` §4's DEBUFF row removed, comments in
`check_fx`, `test_batch_ar` and `test_batch_cp`). The glossary names neither. No ability answers to either name, and each is one node.

## §5 — A STRIKE, NAMED ONCE

**The glossary's *Strike Damage*** (combat; the hundred and first entry, `test_batch_ce`'s pin bumped with its reason): *A strike is
the damage an ability deals as its blow lands. A status's tick, a detonation, a bleedout burst, a reflection and a bomb are not
strikes, and a bonus to strike damage does not reach them. Nor does such a bonus, or a ward against strikes, reach a strike a card
deals by a rule of its own, as a Killing Frost does; and a ward does not lessen a companion's blow.* The last two clauses are IK's
beside the brief's words, for the two cases the code needs (premise 22).

**The eight, and the ward's chip**: Emberheart, the Frostbound Sigil and the Nightbloom Charm say *strike damage +20%*; Tinderbox *All
fire strike damage +25%, whoever deals it* (the clause kept); Clarity *more strike damage*; Profligate *more strike damage and cost
twice the Mana: a Killing Frost costs double and is paid nothing*; Shielding and the Regalia *25% less strike damage taken*; and the
Shielded chip, a copy of the wards' fact, *Takes 25% less strike damage*. **Clarity's log line** said *the spell lands 50% harder* at
the spend line for every spell at full Mana — a Killing Frost and a heal included — and says *its strikes land* now, printed only for
a cast that reaches the strike. `master.html`'s copies (the Tinderbox row, the Shielded row, the two runes, the relic trio) say it, and
its damage section defines the strike.

**Read off the fight** (`check_ik` §5c): Profligate's Killing Frost dealt 57 with the rune and 57 without, at a price of 40 against 20;
Stoke, a spell that strikes, ×1.409 — the rune's ×1.40; the ward lessened a hero's strike ×0.75, the chip's figure; and the source
holds each claim's read site — the school bonus read once, at the strike; the ward's 0.75 at the strike, and nowhere in
`_companion_hit`.

**Width first** (the brief's loudest instrument, run before anything else): `check_gt` §2 read **454 px in 470**, unscrolled, as at
IJ — Profligate is the Mage's longest ordinary rune now; `check_cl_width` read HEAD's 48 / 40 Perfect lines once the two Perfects of
§3 were cut to fit (a first draft of each ran 45–46 with the label and was shortened before any recon).

**The census re-read** (the set closed by it): beyond the eight, **two** rows state all damage where the code reads the strike loop —
N077 Empty Pulpit and N078 Dead Air, crest runes (ruling 5); IJ had already repaired B0718's Hold window and C125's Arcane Echo.

## §6 — CAIRNMOSS POULTICE CANNOT BE DRAWN, AND THE BOMB's LINE

**Suspended, not deleted.** The entry carries a `suspended` string naming what is lost and what brings it back, and
`Relics.is_suspended` is read at the four doors a relic is drawn or listed by: the boss's `Relics.unlock_random`, an event's
`relic_grant`, the draft's assignment, and the relic shelf. The entry resolves, its words stand, and an unlock of it survives a load —
**the designer's `relics.json`, which holds all 25, is untouched**. **What moves at each door** (no relic has a weight — premise 27):
a fresh profile's boss unlock draws one of 24 where it drew one of 25; an event's common grant one of 16 commons where it drew one of
17 (less those held); the draft lists 24 of the designer's 25 and the shelf shows 24. The designer's boss unlock returns nothing either
way (all 25 are unlocked). `master.html`'s pool reads 24 — 16 common, 8 rare — and its hook paragraph names Martyr's Knucklebone alone.
**The re-cut is ruled and waits**: it rides the post-fight recovery at the number the fallen-hero ruling sets, beside the Cairn of the
Fallen and the map's Revive Potion (`docs/state.md`).

**The bomb's line**, in the items entry, word for word: *No one deals a bomb's damage — it marks nothing, feeds nothing, and claims no
kill.* Read through `Glossary._load`, and true on a board holding a Reaver, a Leech and a Tracker (`check_ik` §6): the bomb's kill was
no Reaver's, the Leech's Mana stayed 0, no mark was laid, no dealt ledger moved — and the same Leech's and Tracker's own blows fed him
and laid the mark (the positive arms). A Frostbind mirror a bomb sets off is the bond's own damage, not the bomb's.

## §7 — HOUSEKEEPING

**THE MOVE IS NOT ATTEMPTED** (IB §4). **Read at IK's start: 602 folders, 260,548 KiB**; **at its close 602 folders, 260,668 KiB** — the three reused lanes grew by their gates' scratch files. **IK made no folder**:
every lane reused one of IJ's three — *II K* (the probe lane, the gate-source readers, the controls), *II S* (recon 1, recon 2),
*II R* (the pre-pass). **The spent prefixes** — every *Dawn of Decay* copy from FX to IJ and the five *DoD …* copies — are
**600 folders, 260,108 KiB** at the close (259,996 KiB at the start). **ONE command clears them**, leaving the live *Dawn of Decay* folder and `[unnamed project]`:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IJ)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-J]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IJ)/"
```

Each pattern was listed before it was written here — 470, 125 and 5 folders — and none reaches the live folder. **IB's caution, kept**:
zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from the paste first.

**THE LIVE FOLDER's `readout/`**, read and not changed: `latest.txt` (40 B) and `run-20261014-134942.jsonl` (16,291 B, IH's one file),
backed up with the four player files, md5-identical to the backup before and after the acceptance. **No newer file.**

## §8 — WHAT IS DELIBERATELY NOT DONE

- **SANCTITY's SOURCE GAP AND RUIN's SEVERITY ARE IL's**, each a magnitude measured before and after; R016's and R091's words stand.
- **THE RE-MEASURE IS IM's**, with IJ §0.3's sentence as its first input. **The two readings** (§9h): `CLAUDE.md` 473,839 B = 462.73 KiB, 47.27 KiB under its 510 (5.8 batches at EZ's record, 29.7 at the IG–IK mean); `docs/state.md` 359,525 B = 351.10 KiB, 28.90 KiB under its 380 (5.1 at IA's worst case, 19.6 at the honest rate) — **`docs/state.md` runs out first at both rates.**
- **THE CLAIMS STAND AT 86** (IN's).
- **NO PAYOUT WIDENS AND NO SEVERITY MOVES**: the school relics, Tinderbox, Clarity, Profligate, Shielding and the Regalia keep their
  reach; only the words changed. The widening is a measurement, and whether Profligate's price narrows with its payout a magnitude —
  both parked in `docs/state.md`'s roadmap.
- Every other standing item of the brief's §8 is unchanged: no crest rune re-cut or authored, the crest cap at one; Boil Over, the
  vow, the recoil floor and Anointing untouched; the third slot ungated; Rupture waits on a clean file; the art is not commissioned; a
  copied Frostbind's refusal RULED, NOT BUILT; Mana stays; Marrowfire's re-cut, Contagion's and Reckoning's, the Occultist's Break card,
  the Skirmisher and the Tracker, Channel's tempo payout, the fallen-hero ruling (now pricing three crest runes and two relics), Tithe's
  read site and the block index.

## §9 — THE VERIFICATION

### §9a — THE PUSH CHECK AND THE SAVES, FIRST

`git ls-remote origin class-merge` read `739ef885…`, local HEAD the same, before anything ran (10:19). **The player's four files and
`readout/` were backed up at 10:20** (`../save-backups/IK-20261016-102016`), each md5-identical to the live folder and to IJ's backup:
nothing moved since IH, and no newer file.

### §9b — THE SWEEPS AND THE INTEGER PINS, BEFORE EACH PREDICTION

**The literal sweep** (IG's `litsweep_ig.py`, both quotes, every gate's and suite's literals at HEAD and in the tree) ran twice, each
before the prediction it fed: over the code and data before recon 1's — **10 lost, 42 gained, 7 short flips** — and with the documents
before recon 2's — **39 lost, 170 gained, 8 short flips, 95 count pins moved**, against IJ's 361 / 439: a batch of repairs, not of
conversions. **The lost literals a gate's current source still holds** (`litsweep_live.py`) are `check_ik`'s own absence needles (the
two FX labels, the ward's and Tinderbox's old words, Profligate's old clause, Cairnmoss on the shelf and the picker), `check_ij`'s
rows for the old words (re-pointed), `check_dn`'s and `test_batch_ar`'s *less damage* (still in other enemy texts; both green in recon
1), and words another surface carries (*Carry*, *school*, *Abundance*). **The short flips** — *any*, *who*, *pos*, *set*, *map*, *6*,
*ru*, *El* — are fragments of IK's new words and code in files their holders do not read them in; every holder read green in recon 1.

**The integer pins at the doors IK touched** (comment-stripped, HEAD → IK): `battle.gd` `randf()` 37, `randf_range(` 30,
`randi_range(` 2, `pick_random(` 30, `shuffle(` 3 — **no dice spender moved** — and `_apply_status(` 222, `add_status(` 14,
`float_text(` 301, `set_display_chip(` 18, `take_hit(` 55, `_stat(` 165, `_on_enemy_death(` 41, all unmoved; **`update_status(` 57 →
58** (the chip names the payer), **`_log(` 749 → 750** (the bill's line), **`_landed(` 10 → 11** (the bill asks it). `unit.gd`,
`relics.gd` (`pick_random(` 1), `events.gd` (3) and `run_state.gd` unmoved: the suspension filters before the die, so a draw is still
one draw.

**The census of readers of what IK moved** (II §0.7): Blood Price's cost, chip and line (`check_gv` §1, `check_ik` §1); Execute's
gate, now `_execute_qualifies` (`check_ij` §3's pin, re-pointed to `_execute_line`) and the picker's one door, `_pick_target`; the two
Perfects (`check_ij` §2e, `test_batch_bj` §2); the two talent names (`test_batch_br` §1, `check_ek` §4, `check_fx`'s comment, and
`test_batch_bs` §5, which reads `master.html` §7 against the nodes); the eight strike texts and the ward (`check_ij`'s rows); Cairnmoss
(the four doors and the draft's header count, `check_ik` §6); the glossary (`test_batch_ce`'s count, `test_batch_an`'s walk). **It
missed one, and recon 1 read it: `check_hf` §0 holds HF's fifteen class runes in the designer's words, and Clarity's and Profligate's
moved** — re-pointed to the brief's (§9f).

### §9c — RECON 1: HEAD's BATTERY ON IK's CODE

**HEAD's battery — gates, suites, documents, baselines — on IK's code and data**, in a clone with its own folder (*II S*), the
prediction written at 11:08:25 and the battery launched at 11:08:55. **150 targets in 81 min 31 s** (the `ps` rows: the first Godot
at 11:09:05, the last at 12:30:36). **Predicted and read red**: `check_ij` 6 (§2e, Sever's and Reality Fracture's Perfects and the
ward; §3, Execute's needle and the two wards), `test_batch_bj` 2, `test_batch_br` 1, `check_ek` 1, `test_batch_ce` 1. **Predicted green
and read green**: `check_gv` 1057 / 0 — HEAD's arm hands the card an enemy (f0), the bill goes to the fullest, and on a board at one
health the tie goes to f0, so the arm reads what it read **on both codes: the §0.12 defect, and why the arm is re-pointed** (§9e, H01);
`check_fx`, `test_batch_cp`, `check_gt` (454 px in 470), `check_cl_width` at HEAD's widths. **Not predicted, each read for its cause**:
**`test_batch_bs` §5** (HEAD's `master.html` §7 names FX's labels where IK's code names Iron Will and Undying Rage — the lane carried
HEAD's documents; IK's §7 names both), **`check_ed`** (HEAD's manifest holds `test_batch_bj`'s negative pin that `battle.gd` never names
Reality Fracture — IK's handler does; the manifest is rebuilt off IK's `test_batch_bj`), and **`check_hf` §0** (2 — Clarity's and
Profligate's words; the census's one miss, re-pointed). **The two standing sanctioned reds were unchanged** (`check_cm_live` 13 / 5,
`check_gj` 70 / 1, FAIL lines identical to IJ's acceptance). `check_de` read 617 / 8 — each a red above, read as *went redder* — and
one notice, `check_ij` 48 → 54 (§9f). **Against IJ's acceptance, target by target, nothing else moved** but `test_batch_an`, inside its
band (§9f): every seeded whole-run gate read its IJ count with Blood Debt firing, a Perfect Sever's Sunder and Reality Fracture's
second Resonance in play.

### §9d — RECON 2: THE COMPLETE TREE

**The complete tree** — every repair and re-point, `check_ik` in `run_battery.sh`, the documents landed (`docs/state.md` filled
and its archive cut, `CLAUDE.md`, the instrument rules, the combat rules, the changelog, the design notes, `master.html`, the text
standard), the baseline rows and the pin manifest rebuilt — in a fresh clone in *II S*, after the twenty-one gate-source readers
(§0.4), with the prediction written at 12:34:39 and the battery launched at 12:41:31. **151 targets in 82 min 2 s** (the `ps` rows:
the first Godot at 12:41:46, the last at 14:03:48). **Read as predicted, but for one**: every recon-1 red green — `check_ij` 48 / 0,
`test_batch_bj` 70 / 0, `test_batch_br` 1486 / 0, `test_batch_bs` 246 / 0, `check_ek` 47 / 0, `test_batch_ce` 931 / 0, `check_ed`
18 / 0, `check_hf` 314 / 0 — with `check_ik` 251 / 0, `check_parse` 227 / 0 and `check_gv` 1057 / 0; the two standing sanctioned
reds unchanged (`check_cm_live` 13 / 5, `check_gj` 70 / 1); `test_batch_an` 6053 and `test_batch_bk` 129, each inside its band
(§9f). **The one not predicted: `check_gw` §2, 76 / 1** — *the shape GREW to 97 sites against a ceiling of 96*, the 97th
`check_ik`'s: §1e set the vow's field on the built Warrior, because no Warrior can be offered the vow — a gate writing the state its
assertion is about, GW §2's shape exactly. **Repaired, not raised**: the vow is worn on his member and seated by the spawn (the
spawn applies a worn rune whatever its class), and the assertion prints the seated figure as its premise, still one `ok()`;
`check_gw` reads 96 again, `check_ik` 251 / 0, and C04 still bites (*the spawn seated the vow at 0.5; … credited 7125*).
**`check_gw` reads every battery target's source, and IJ §0.4's derivation — the targets that open the root — leaves it out**:
FOUND AT IK in `docs/state.md`, owed to `check_ij`. `check_de` read 621 / 1 / 0 — that red, and 617 + 4 for `check_ik`'s row (it
asserts four things a target: its floor, its ceiling, a log with content, no throw).

**What moved after its launch, and how each was read**: `check_ik`'s vow seated and eleven of its FAIL lines reworded (§9e), and
`docs/state.md` filled again with the finding above. **On the final tree**: the twenty-one gate-source readers, `check_gw`,
`check_hf` and `check_fg` read green at their rows (`check_ik` 251 / 0, `check_gw` 76 / 0 at 96 sites, `check_parse` 227 / 0), and
the thirteen gates that read `docs/state.md` — `check_dm`, `check_ek`, `check_es`, `check_fg`, `check_fr`, `check_hp`,
`check_hx`, `check_ii`, `check_ij`, `test_batch_aj`, `as`, `at` and `aw` — read green on its last fill — and the acceptance reads the tree they landed in.

### §9e — THE CONTROLS

**Each control is a count-asserted patch on its own clone of the tree** (`controls_ik.py`; one clone a control, all in *II K*, one
after another, launched at 11:33:23, done at 12:20:06), and each FAIL line was read, never a count. **C00, the unpatched tree, read
green on every gate the controls use** (`check_ik` 251 / 0, `check_gv` 1057 / 0, `check_ij` 48 / 0, `test_batch_bj` 70 / 0,
`test_batch_br` 1486 / 0, `check_ek` 47 / 0, `test_batch_ce` 931 / 0, `check_hx` 39 / 0).

| # | The defect planted | What read it (the FAIL text, abridged) |
|---|---|---|
| C01 | Blood Debt bills the cast's target again — HEAD's read | `check_ik` §1a *the fullest enemy (Orc Raider, 87000) lost 0, want its 7.5% (6525)*, *the Berserker's health read 175 before the bill and 162 after*, *Blood Price's own line does not say the fullest enemy (Orc Raider) pays the debt ('… bleeds 13 HP …')* (251 / 12); **`check_gv` §1, re-pointed: *blood_debt_rune moved nothing with its engine equipped either — the drive does not reach it*** (1057 / 2) |
| C02 | the payer chosen by a die | `check_ik` §1b *choosing the payer spent a die*, *`_blood_debt_payer` read 304 chars, naming a dice spender: true* (251 / 11 to 13 — the die picks another payer each run, so §1a and §1c fail with it as it lands) |
| C03 | the payer is the emptiest enemy | `check_ik` §1a *1 enemies who are not the fullest lost health to the bill*; §1b *one more point of health does not make an enemy the payer* (251 / 8) |
| C04 | the bill read above the vow's gate — prints and credits what it computed | `check_ik` §1e *the spawn seated the vow at 0.5; the vowed Berserker's bill landed 0 and was credited 7125*, *the silenced bill's line does not say it was silenced* (251 / 2) |
| C05 | Execute's picker offers every enemy again | `check_ik` §2a *the picker offered 6 … want the three that qualify*, §2b *with one enemy below the line the cast opened a picker (true), and that enemy stands at 9000 of 9000*, §2e *the picker does not ask `_execute_qualifies`* (251 / 6) |
| C06 | the narrowing reaches every enemy-target card | `check_ik` §2f *the pool's narrowing is not keyed on Execute alone*, *Requiem's pick prompted false, offered 0 of six and refused 0* (251 / 13 — the other heroes' basics lose their targets too, so §1 and §2 fail with it) |
| C07 | a refused body says nothing on its hover | `check_ik` §2a *the three it refuses do not each say, on their hover, the 20% line they are above* (251 / 1) |
| C08 | Sever's Perfect names no arm | `check_ik` §3a *does not name the Sunder arm*, *a Perfect Sever laid {  }*, *Sunder and Burn did not stand together* (251 / 3) |
| C09 | the Sunder arm types its duration (2) | `check_ik` §3a *does not lay one deep for `SUNDER_TURNS`*, *a Perfect Sever laid … "turns": 2* (251 / 2) |
| C10 | Reality Fracture's Perfect banks nothing of its own | `check_ik` §3b *an Arcanist banked { good 1, perfect 1, fail 1 } — want 1 / 2 / 1* (251 / 2) |
| C11 | the second Resonance on every card's Perfect | `check_ik` §3b *Stoke's Perfect banked 2 — the second Resonance reached another card* (251 / 2) |
| C12 | the Iron Will node wears FX's label again | `check_ik` §4 (251 / 3); `test_batch_br` §1 (1486 / 1); `check_ek` §4 *the tag DEBUFF collides … [node:Mitigation per Debuff You Carry]* (47 / 1) |
| C13 | Profligate's asymmetry unnamed | `check_ik` §5b *Profligate does not name its asymmetry* (251 / 1) |
| C14 | Emberheart says damage, not strike damage | `check_ik` §5b *relic emberheart does not say strike damage* (251 / 3) |
| C15 | the glossary's ward clause gone | `check_ik` §5a *the entry does not say: a ward does not lessen a companion's blow* (251 / 1) |
| C16 | Cairnmoss no longer suspended | `check_ik` §6 *the boss's unlock drew Cairnmoss 9 times in 300*, *an event granted Cairnmoss 22 times in 300* (250 / 6 — one row a suspended relic) |
| C17 | the draft assigns a suspended relic | `check_ik` §6 *the draft's assignment draws Cairnmoss: ["Gravewrought Coin", "Cairnmoss Poultice"]* (251 / 1) |
| C18 | the bomb's line gone | `check_ik` §6 *the items entry does not carry the bomb's line once* (251 / 1) |
| C19 | §0.2's reasoning gone from GX's block | `check_ik` §0.2 nine times — *does not say once*, *does not stand in GX's block*, and each of the seven unnamed (251 / 9) |
| C20 | the new instrument rule's index row gone | `check_ik` §0.12 *CLAUDE.md's index has no row for the rule* (251 / 1); `check_hx` §1a *a block the instrument index does not point at* (39 / 1) |
| C21 | the writing rule written a second time, in `CLAUDE.md` | `check_ik` §0.11 *does not stand once in the text standard alone* (251 / 1) |
| R01 | **RE-TUNE**: Sunder's own duration 3 → 4 | `check_ik` **251 / 0** — it reads the constant |
| R02 | **RE-TUNE**: Profligate pays 50% | `check_ik` **251 / 0** — it reads the payload |

**C06 found a fault in `check_ik` itself**: its first run read 227 / 8 with a script error — a turn that never reached the board
left §1a's record empty, and the next read threw, cutting §1 short. **The failing path is bounded now** (an empty record reads the
board as it stands, and says so); re-run, C06 reads 251 / 13 with no error and C00 251 / 0. **And reading every FAIL line whole found eleven that
said less than they read**: under C03 the bill's line was reported as *still says he bleeds* where it named the wrong payer, and
two knock-on lines named a cause that was not the defect planted; under C06 the Berserker's health was printed as a payment off a
reading never taken; seven more joined two claims with *or* and printed only one
half. **Each now prints what it read** — the line quoted, both halves' values — and each is still one `ok()`, so the count is 251;
C01, C02, C03, C04, C05, C06, C12 and C17, re-run on the final gate, read the same failures in the new words (the table quotes them), and the gate-source readers read
the final source (§9d).

**And the two HEAD arms.** **H02 — HEAD's documents under IK's gates**: `check_ik` 251 / 22, every documents arm: §0.2 nine times (the
reasoning, its block, each of the seven), §0.11 twice (the rule, its warband half), §0.12 four times (the block, its row, its needle
half, its zero-read half), §4 four times and §5b three (`master.html`'s talent rows and strike words); `check_hx` 39 / 0 — HEAD's
indexes agree with HEAD's rule files. **H01 — HEAD's game code and data**: **`check_ik` cannot parse** against HEAD
(*Cannot find member "SUNDER_TURNS" in base "BattleUnit"*, *Static function "is_suspended()" not found in base "Relics"*), so C01–C18
are its evidence; **every re-point reds on HEAD's code** — `check_gv` §1 (1057 / 2: *moved nothing with its engine equipped either*
— **the longest case, opened: the arm now drives the player's own cast and HEAD's rune never fires through it**), `check_ij` (54 / 6),
`test_batch_bj` (70 / 2), `test_batch_br` (1486 / 1), `check_ek` (47 / 1), `test_batch_ce` (931 / 1), each on the clause it moved to.

### §9f — THE MOVED COUNTS, ATTRIBUTED

- **`check_parse` 226 → 227**: its own population line reads *A battery 148* at IJ and *149* on IK's tree — `check_ik` joining
  `run_battery.sh`.
- **`check_ik` 251, new**: one `ok()` a row; §6 asserts once per suspended relic (C16 reads 250 with none).
- **`check_ij` 48 → 54 in recon 1, 48 on IK's tree**: a row that fails adds an `ok()` (its row's note), and HEAD's gate had six failing.
- **`test_batch_an` 6052 → 6053 in recon 1** — **not IK's**: an `ok()` trace (the fixture's `ok()` printing its caller's line, two
  clones, HEAD's code and IK's) put the whole difference on line 135, one `ok()` a node of an unseeded map (*no rest slot … in any
  zone*). HEAD's code read 6051 and IK's 6056 back to back; the row's band is [6044, 6066], so nothing moves.
- **`check_hf` 314, re-pointed and unmoved**: its two rows compare words for equality; the count is the population's.
- **`test_batch_bk` 131 → 129 in recon 2** — **not IK's**: traced on the final tree (three runs, 131 each, line for line the same),
  the only lines a map moves are 270 and 272, one `ok()` a node of columns 7 and 14 of a fresh, unseeded `_generate_map()` —
  two or three nodes each (no column is pruned to one), so the count is 129 to 131 by construction, the row's band.
- **`check_de` 617 → 621**: four assertions a target (its floor, its ceiling, a log with content, no throw), and `check_ik`'s row
  is one more.

### §9g — THE ACCEPTANCE

**The pre-pass and the acceptance, launched together at 14:17:58** — the pre-pass in a clone carrying `.git` (*II R*), proved
the tree (545 files each, md5 by absolute path, untracked included, differing only in the clone's `project.godot` name), the
acceptance in the repository and the live folder — after the tree was frozen, the player's files read and `ps` logging started,
the prediction written at 14:18 before any target read. **Both read `check_de` 621 / 0 / 0, as predicted.** The acceptance: **151
targets, 14:17:58 to 15:43:36 — 85 min 38 s** with the pre-pass sharing the machine (the `ps` rows: the first Godot at 14:18:13, the
last at 15:43:32). Its reds are the two standing sanctioned ones, inside their bands and their FAIL lines IJ's to the character
(`check_cm_live` 13 / 5, `check_gj` 70 / 1); `check_ik` 251 / 0, `check_gw` 76 / 0, `check_parse` 227 / 0, `check_ij` 48 / 0,
`check_hf` 314 / 0, `check_gv` 1057 / 0; `test_batch_an` 6050 (the pre-pass 6052) and `test_batch_bk` 131, inside their bands; no
notice. **No red of my own**, because the gate-source readers and `check_gw` had read `check_ik`'s final source before either began.

### §9h — THE CLOSE

**The tree was byte-identical before and after the run** (545 files, tracked and untracked, absolute paths). **The player's four
files and `readout/` are md5-identical to `../save-backups/IK-20261016-102016`**: `run_save.bin` 40,284 B, last written 2026-10-14
14:30; `readout/` IH's one file. **The documents were written before recon 2 and the acceptance; `docs/state.md` was filled again
before the acceptance, to carry recon 2's finding, and none was edited after it**; only this report was written after it — from a
draft kept in the scratchpad until its verdict was in, and grepped for an unsubstituted template token before it was written out.
The commit is pushed to `class-merge`, and its push check (`git ls-remote origin class-merge` against local HEAD) is the
hand-back's, after the commit this report is part of.

**THE TWO READINGS (§8; IM's first input)**: `CLAUDE.md` 473,839 B = 462.73 KiB (+1,073 at IK; 47.27 KiB under its 510 — 5.8
batches at EZ's record, 29.7 at the IG–IK mean of 1,631 B); `docs/state.md` 359,525 B = 351.10 KiB (+2,111 at IK; 28.90 KiB under
its 380 — 5.1 at IA's worst case, 19.6 at the honest mean of 1,508 B). **`docs/state.md` runs out first at both rates** (5.1
against 5.8 at the worst; 19.6 against 29.7 at the honest).

