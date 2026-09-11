# BATCH FY — WHY FOUR NODES COULD NOT PAY EVERY CLASS

**THE SIXTH BATCH ON `class-merge`.** Three rulings were implemented and two things FX left were checked:
- **§1: a report.** It covers why four of FX's brief nodes could not pay every class, and whether FW's **TODAY**
  costing can be trusted. The correction to that costing is written into `docs/systems-recon.html` itself, as a new
  section, **SR-REACH**.
- **§2: Deepening Hex's floor, re-derived** against the live game. It is **8** now.
- **§3: the Wide Watch stays retired.** Its retirement string now records the reason that still holds.
- **§5: FX's two loose ends.** The screen gates' scratch profiles are confirmed, and the first census of which targets
  write the player's `profile.json` has been taken. FX's 1,864 deleted checks were also audited independently.

**What did not happen:** no node was swapped, no magnitude moved, the five tag-word names and the spend gate of 3
stand, and no spine was attached (`check_ft` §0 holds). `main` is untouched.

---

## NEEDS A RULING

1. **CONFIRM THE FLOOR'S READING.** FY set `RUIN_FLOOR` to **8** by FO's method: the lowest threshold reachable
   today is 10 − 2, and nothing else lowers it (§2). The brief's second clause (*"if nothing lowers the threshold any
   more … it would need the designer"*) was read as not applying, because the rune itself still lowers it. If the
   clause was meant to apply once the capstone was gone, the revert is small (the constant, the card's number,
   two gates' pins and the prose) and nothing in play changes either way. **And know what 8 does:** it sits on the rune's own result, so the first effect that lowers the base
   step below 10 shrinks the rune, then zeroes it, then (below 8) makes it detonate LATER. `check_fo` §1c goes red
   that day.
2. **THREE SHIPPED NODES PAY A BUYER BY WHO ELSE HOLDS THEM** (§1b). **Heal More When Low** and **We Do Not Break**
   pay the whole party from the best holder, so the second, third and fourth class to buy one is paid nothing.
   **Enemies Look Past You** is relative, and **its card is false whenever other heroes hold it**: measured with all
   four holding it, three of four heroes were targeted MORE than with nobody holding it. The designer's save can buy
   all 27 on every class on day one. None of this is a defect in the code; it is what these read sites do in a tree
   every class buys. Whether *"a node must pay every class that can buy it"* is about recipients or about buyers is
   the question.
3. **THREE NODES ARE ONE IDEA BY FW'S OWN COUNT** (§1c, §1e): A Cooldown Ticks on a Crit, A Crit Pays and Your
   Crits Crack Guards. The FX brief's premise that 27 against 50 makes every node distinct does not hold for them,
   and by the same rule the distinct TODAY count is at most 46. This is a queue item, not a defect.
4. **DEEPENING HEX'S CARD WORDING** at the new floor (§2). The number is the code's; the sentence is yours.

5. **A REDIRECT FOR `relics.json` IS OWED A BATCH, AND WHEN IS YOURS TO SAY** (§5b). Four gates reach the handler
   that saves the player's relic file, 14 times in one battery. Today it never saves, because every relic is
   unlocked. The first locked relic changes that, on every battery, permanently. The fix is FI's shape (a `save_path` var that points
   anywhere else in a harness process), and it is a code change this brief did not ask for.

## THE SHORT VERSION

1. **TODAY IS NOT A RELIABLE COSTING FOR A TREE EVERY CLASS BUYS.** It means *a field exists and a read site
   reads it, for some hero*, and it was written for four class trees. **Only two of FX's four failures were the
   class shape**, and FW had flagged both. The other two were never TODAY: one was FW's SMALL item, and one was a
   TODAY item with its trigger reversed. **That TODAY item pays the Survivalist alone** (measured on all twelve
   specs), and the recon never said so. Of the fifty: 37 pay every class, 6 are class-conditional, 1 is one spec,
   5 pay the party once and 1 is relative. **The reach is now in `docs/systems-recon.html` as SR-REACH.** By the
   page's own counting rule, at most 46 of the fifty are distinct.
2. **AMONG THE 27 THAT SHIPPED, THE CURRENCY SHAPE IS NEUTRALISED WHEREVER IT APPEARS.** No passive assigns over
   any field on any of the twelve specs, and every spec's basic reaches the eleven ordinary-blow nodes. **But three
   nodes pay a buyer by who else holds them**: two party-wide stamps, and Enemies Look Past You, whose card is false
   when the whole party wears it. The four alternates pass the class test. One of them, A Crit Pays, is by FW's rule
   the same idea as two other nodes.
3. **DEEPENING HEX'S FLOOR IS 8**, re-derived by FO's method (`10 − 2`; nothing else lowers the step). Nothing in
   play moves. `check_fo` §1c pins the relation. The floor now sits on the rune's own result, which is named
   wherever it will be met.
4. **THE WIDE WATCH STAYS RETIRED.** Its string records the reason that holds: the Shared Mark fills its place.
   FO's reason is kept and marked void. `check_fo` §2a asserts it, with a negative anchor paired with two positive
   arms.
5. **NO TARGET WRITES THE PLAYER'S `profile.json`.** All 108 targets were censused by measuring the act, and
   twelve write their own scratch profiles. **But `relics.json` has FX's shape**: four gates reach the boss-victory
   handler, which saves `user://relics.json` (a constant path) the day any relic is locked. Reading the source
   found three of them; measuring the act found the fourth. That has not happened only because every relic is
   unlocked. Reported, not fixed.
6. **FX'S 1,864 DELETIONS REPRODUCE EXACTLY AND NONE MEASURED AN OUTCOME.** About 202 read a deleted node's
   payload content, which FX's summary left out. About 80 design numbers on dormant fields are now unasserted.
7. **THE RECONNAISSANCE BATTERY HAD NO UNPREDICTED RED** (`check_fo` 9, `check_ez` 3, as written down before it
   ended). Every re-pointed arm bit under its control.
8. **THE ACCEPTANCE BATTERY IS GREEN, AND IT MOVED NOTHING.** It ran in the real tree with every file frozen. All
   108 targets read their baselines: `check_fo` 87 / 0, `check_de` 449 / 0 with no notice, and no parse error in
   any log. `check_fx` took 353.5 s against its 720 s bound. Afterwards the tree and the four save files, md5s and
   modification times alike, were identical to the freeze taken before.

---

## §0 — THE BRIEF'S PREMISES

Each premise was checked against the repo before anything was edited.

| # | Premise | Verdict | What the repo says |
|---|---|---|---|
| 1 | FX found two screen tests re-saving `profile.json` on every run | **HELD** | FX §6: `check_ct_map` and `check_map_screen` called `Profile.set_flag` with no redirect |
| 2 | FI's census moved 67 targets off the RUN save and could not see this | **HELD** | FI §1: 67 targets destroyed the save during a run; its census was of `run_save.bin` alone |
| 3 | FW costed 50 things as TODAY | **HELD** | SR-COUNT: 50 TODAY |
| 4 | TODAY is *"a field exists and this system already reads it"* | **HELD WITH A CLAUSE LEFT OFF** | FW's definition also says *"with none of the seven traps in the way"*, and FW marks two items TODAY with a trap in the way (§1d) |
| 5 | 27 were drawn from that list on the strength of that costing | **PARTLY FALSE** | 25 of the 27 map to a TODAY item. *Debuffs on you expire sooner* is FW's **SMALL** item SR-STATUS 8. *Elusive while you carry an affliction* is FW's TODAY item SR-EVADE 4 with its trigger **reversed** |
| 6 | Four turned out class-conditional | **HALF FALSE** | Two did, by currency, and FW's own cost cells flagged both. The other two were never the TODAY item they came from (§1a) |
| 7 | FO chose 3 as the exact bottom of the live tree, 5 − 2, because Avatar of Ruin installed 5 | **HELD** | FO §1. FO also argued 3 as the smallest number that keeps a cadence (1 and 2 do not) |
| 8 | The floor now binds nothing and its derivation names something that does not exist | **HELD** | Nothing writes `avatar_ruin` since FX; `maxi(10 − 2, 3)` is 8 |
| 9 | `check_fo` §1c pins 10, 5 and 2 | **STALE** | FX re-pointed §1c to **10, 2 and 3** plus two arms (nothing writes `avatar_ruin`; the floor binds no live build). The 5 lived on in §1d–§1g, and in `check_ez` §5, as a constructed state |
| 10 | The Wide Watch was retired because it duplicated a Sharpshooter node word for word | **HELD, WITH FO's OWN QUALIFIER** | The rune's clause duplicated Overkill's by a different route. FO found the two texts do not match word for word: the longest shared phrase is *"rather than"* |
| 11 | That node is deleted | **HELD** | `ss_overkill` went with the twelve trees at FX; nothing writes `overkill` |
| 12 | The Shared Mark replaced it and the Sharpshooter's fifth slot is full | **HELD** | The Sharpshooter has five live runes, and the Shared Mark took the Wide Watch's place one-for-one at FO (`check_fo` §2c pins the live pool at 60). There is no slot mechanism: "slot" is the authored set |
| 13 | FO's string records *"it was authored against a base a node already provided"* | **HELD** | Verbatim, in capitals, in `data/runes.json` |
| 14 | The two screen tests now use a scratch profile | **HELD** | Confirmed by source and by the census (§5a) |
| 15 | FX deleted 1,864 checks, all about the deleted trees | **COUNT HELD; THE CATEGORY LIST IS INCOMPLETE** | The audit reproduces 1,864, file by file. None measured an outcome. But about 202 asserted a deleted node's **payload content** (a magnitude, a field, an ability-edit shape) — a static read of the node's data — which FX's list of deleted categories leaves out (§5c) |
| 16 | `check_fx` needed its own measured time limit at about six minutes | **HELD** | FX measured **354 s** and set `TMO[check_fx]` to **720 s**. About six minutes is the measurement, and the bound is twice it (§6) |

## §1 — THE FAILURE MODE, ACROSS ALL 27

**The answer first.** Only two of the four failures were the class shape, and FW's own cost cells had flagged
both. The other two were never the TODAY item they were written from. **TODAY is still not a reliable costing
for a tree every class buys**, because it means *some hero* and never said which. Of FW's fifty TODAY items:
- 37 pay every class;
- 6 are class-conditional;
- 1 pays a single spec, and FW did not flag it;
- 5 pay the party once, from its best or first holder;
- 1 pays a holder only relative to the other heroes.

That reach column is now written into `docs/systems-recon.html` as **SR-REACH**, and each unflagged row carries a
local note.

### 1a. What made the four fail, precisely

| The brief's node | FW's item and cost cell | What made it fail | Class-conditional? |
|---|---|---|---|
| **Regenerate more resource** | SR-RESOURCE 3, *"TODAY (Cleric, Hunter; replaced on Mages)"* | **Two shapes at once.** (1) **A field that exists for one currency and not the other.** The drip is `12 + mana_regen_bonus`, read only under `resource_name == "Mana"` (`_mana_regen`, `battle.gd` turn start). Rage's drip is the literal `+5` in the same block, with no field. (2) **A class passive assigning over the field.** Evocation writes `cfg["mana_regen_bonus"] = 10` on every Mage, after the tree (`_spawn_units`). So it pays the Cleric and the Hunter only. | **YES**, by currency and by class passive. FW flagged it. |
| **A Perfect pays** | SR-CHECK 1, *"TODAY for Mana users; one field and one line for any other currency"* | **A read site gated on the currency.** `holy_light_pct` is read in `_resolve` under `grade == "perfect" and … resource_name == "Mana"`, so it never pays a Warrior. **And a trigger that depends on the card:** only a cast that runs the bar can grade Perfect. Basics resolve at a fixed Good (except the Sharpshooter's), pure buffs, shields and debuff appliers run no bar, and the sim bot rolls grades rather than pressing. | **YES**, by currency. FW flagged it. |
| **Debuffs on you expire sooner** | FW's matching item is SR-STATUS 8, *"Debuffs shorter, buffs untouched — SMALL"* | **It was never TODAY.** FW costed exactly this item as SMALL: it needs a `DEBUFF_IDS` test inside `add_status`. The nearby TODAY item (SR-STATUS 1, `mod_status_turns`) moves buffs as well as debuffs, and the Fleeting bargain assigns over it. FX's §2 re-found FW's own cost. | **NO.** The brief drew a SMALL item as TODAY. |
| **Elusive while you carry an affliction** | FW's matching item is SR-EVADE 4, *"Elusive when you afflict — TODAY"* | **It was FW's item with its trigger reversed.** No field grants Elusive for carrying an affliction. FX's §2 found the reverse field (`hit_and_run`) and rejected it for being the opposite trigger. | **NO, as written.** But the item it reversed would have failed anyway (next paragraph). |

**THE REVERSED ITEM IS THE COSTING'S REAL BLIND SPOT, AND IT IS ONE SPEC WIDE.** FW's SR-EVADE 4 says `hit_and_run`
means *"applying a status grants Elusive"*, and marks it TODAY with no qualifier. The read site is `_hit_and_run`,
and every path into it belongs to the Survivalist:
- Hamstring's on-hit block, under `attacker.passive_id == "trapper"`;
- Snare Trap's handler;
- his poison, through `_apply_poison`;
- his traps, through `_spring_trap`.

**This was measured, not read.** A scratch probe set `hit_and_run = 2` on a hero of each of the twelve specs and
landed a debuff through the generic `_apply_status` funnel with that hero as the source. Nobody became Elusive,
the Survivalist included. His own Snare Trap did make him Elusive, which is the positive arm. The Warden's basic
did not. **Had the brief transcribed the item correctly, the node would still have paid one spec of twelve.** It is
the one TODAY in the recon whose reach is a single spec, and the recon never says so.

### 1b. Whether the same shapes are in the other twenty-three, hidden

Each of the 27 read sites was followed to its guard chain in the FY tree. The plumbing half was **driven on all
twelve specs**: all 27 fields land at their payload value on every spec, and both party stamps reach every hero.
`check_fx` §4a measures one spec per class. `check_fx` §4b drives 24 of the 27 read sites on one hero (the
Warrior, or the Mage as the cleanse's recipient), two on the Warrior and the Mage, and measures More Health at the
spawn on all four. So a read site that pays the Berserker and not a sibling spec would be invisible to it.

| Shape | Present in the 23 (and the 4 alternates)? | Why it did not bite |
|---|---|---|
| **A currency-keyed read site** (what sank *Regenerate* and *A Perfect*) | **Yes, in Pay a Lethal Hit out of Your Resource Pool** (`last_rites` is read under `resource_name == "Rage"`; `conversion_ranks` under `== "Mana"`). **Neutralised by construction**: the node writes both fields, so each hero is paid in the pool he holds. The two forms differ in kind: Rage pays only below 25% health and only while Rage is banked; Mana pays on all damage. | FX wrote both fields. `check_fx` §4b drives both halves (Warrior and Mage). |
| **A pool clamp hiding the magnitude** | **Yes, in A Bigger Resource Pool and Breaking an Enemy Refuels You.** Both pay whichever pool the hero holds, but a refuel onto a full Mana bar pays nothing, and +20 maximum Rage matters only above 100. A Mana hero opens a fight at his carried Mana: **measured at 100 of 120** for the Mage and the Cleric, and **112 of 120** for the Hunter, whose first turn's +12 drip had already landed (Tracker gives him the opening move). So the +20 is headroom that fills by regeneration, not a bigger opening. | Class-blind. The node text says "maximum", which is true. |
| **A class or spec passive assigning over the field** | **No.** Driven on all twelve specs: every field lands at its payload value. The only assigning passives write `healing_received_mult` (Holy Conduit) and `mana_regen_bonus` (Evocation), and no node of the 27 writes either. | Absent. |
| **A read site only one spec's code reaches** (the SR-EVADE 4 shape) | **No.** No read site among the 27 names a spec, a passive, a class key or a currency, except the two currency guards above. | Absent. |
| **A system a spec takes part in only partly** | **Yes, in the 11 nodes read only in `_resolve`'s ordinary strike branch**, which an ability carrying a `special` never reaches (FW's trap 6). Those 11 are More Crit Chance, More Damage Dealt, Armor Penetration, You Break Harder, Kill What Is Down, A Cooldown Ticks on a Crit, A Crit Pays, Your Crits Crack Guards, Breaking Heals a Hero, Breaking an Enemy Refuels You (plus Guard Change's own copy), and Refuse Death Once's damage rider. You Cannot Miss is narrower again: single-target ordinary blows only. | **None pays a spec zero, because every spec's basic attack is an ordinary blow**, driven on all twelve. But the share varies by spec. Of the damaging cards each spec can reach beyond its basic: **the Beastmaster has 1 ordinary card of 8**, and his companions' blows reach none of the 11 except crit chance; **the Holy has 1 of 2, and the Devout 1 of 1**, beside Smite. The Arcanist's basic hits two random enemies and never rolls a miss, so You Cannot Miss pays him only on his single-target cards. Break participation is the EP §2 shape again: the Devout's Break is Smite's 16 and one card. |
| **Party-wide by its read site** | **Yes, in Heal More When Low and We Do Not Break** (a spawn stamp taking the best holder's figure). | **Every hero is paid, so it reads as every class.** But only one holder's copy does anything, so in any party the second, third and fourth class to buy one of these is paid nothing. FX recorded the shape as *"the read site's shape and not a defect"*. `check_fx` §4a asserts the stamp reads 40 with all four holding, which is the non-stacking itself. Read as a rule about RECIPIENTS, *"a node must pay every class that can buy it"* holds for these two. Read as a rule about BUYERS, it fails. |
| **Relative (paid only against other heroes)** | **Yes, in Enemies Look Past You** (`ghillie`). The re-pick is one step: a blow aimed at a holder moves to a random other hero, and the new target is not re-rolled. | `check_fx` §4b measured `_evade_chance` on one unit (0.65 against 0). That shows the read site moving, not the promise holding. **Measured here** over 4,000 paired draws, with heroes at 90 / 50 / 70 / 80% health. With no holder, the Warrior, Mage, Cleric and Hunter drew 16.9 / 54.6 / 14.6 / 13.9% of the targeting. With the Mage alone holding it, the Mage drew 19.9%, which keeps the promise. **With all four holding it: 22.9 / 30.4 / 23.7 / 22.9%**, so three of the four heroes are targeted MORE than with no holder at all. |

**So the shape that sank two of the four is present in three of the twenty-seven that shipped and neutralised in
all three** (Pay a Lethal Hit by writing both currencies; the Pool and the Refuel by paying whichever pool the hero
holds). **The shapes that were NOT class-conditional, and bit nobody in a check, are the ones worth a ruling**:
- two nodes pay one buyer per party;
- one node's text is false whenever other heroes hold it.

In the designer's own save every class can buy all 27 on day one (FX §4). That is the case where every hero holds
all three.

### 1c. Whether the four alternates were checked the same way

**For class reach, yes, and they pass.** FX's §2 says every node the brief listed was checked for a field that
pays every class that can buy it. It gives no per-class verdict for the four alternates it used, and says the two
unused alternates were not assessed. The four went through the same gate as the 23: `check_fx` §4, which lands the
payload on one spec of each class and drives the read site on the Warrior. **Traced independently here, all four
are class-blind at their read sites:**
- Breaking Heals a Hero, Kill What Is Down and A Crit Pays read in the ordinary strike branch (1b);
- We Do Not Break is a party stamp (1b).

**For distinctness, no: A Crit Pays was accepted on the strength of the list.** By FW's own counting rule (*"one
trigger paying in two currencies is one thing"*), SR-CRIT 2, *"A crit pays (a cooldown tick, Break, a status,
Attack, a refund)"*, is ONE thing. The shipped tree now holds three nodes on it: A Cooldown Ticks on a Crit, A Crit
Pays and Your Crits Crack Guards. They write three different fields, so `check_fx` §1's rule (no two nodes write
one field) passes. **The FX brief's premise that 27 nodes against 50 things makes every node a distinct idea does
not hold for these three by FW's rule**, though it holds by the project's field rule. The alternate came from the
approved list and was not checked against the tree it joined.

### 1d. Is TODAY a reliable costing? No, for a tree every class buys, and the correction is in the recon

**TODAY is a statement about a field and a read site, and it means some hero.** FW wrote it for four class trees,
where a Mana-only idea goes in a Mana class's tree. FW's own tally says so: *"The fifty are class-blind except for a
handful that belong to one currency, so every tree can use nearly all of them"*. When the designer ruled one tree
that every class buys, the unit of reach changed from *the class whose tree holds it* to *every class that buys the
tree*. The costing had no column for that. Its class qualifiers sat in free text inside the cost cells, applied
inconsistently:

| Reach | Items | Flagged by FW? |
|---|---|---|
| **Every class** | **37**: 23 read at a site no hero's kit decides, and 14 through the hero's own ordinary blows | n/a |
| **Class-conditional** | **6**: A Perfect pays (Mana); open the fight with more (Rage); regenerate more (Cleric, Hunter); damage paid from the pool, and pay a lethal hit (one currency per field); resource from damage dealt (Mana) | **5 of 6** in the cost cell; the sixth only through its field list |
| **One spec** | **1**: Elusive when you afflict (the Survivalist) | **No** |
| **The party, once** | **5**: they do not get their guard back, we do not break, enemy debuffs rebound, heal more when low, when an ally falls low I answer | In a few TODAY tables' notes; never in a cost cell |
| **Relative** | **1**: enemies look past this hero | **No** |

**Two more inconsistencies with FW's own definition.** FW defines TODAY as *"none of the seven traps in the way"*,
yet two TODAY items carry a trap it names:
- SR-STATUS 1, `mod_status_turns`, which the Fleeting bargain assigns over;
- SR-RESOURCE 3, `mana_regen_bonus`, which Evocation assigns over.

**The correction is written into `docs/systems-recon.html`**, as the brief ordered, and in three places:
- **SR-REACH**, a new section after SR-HOWTO: the definition, the reach of all fifty, how it was taken, and how to
  read a TODAY from here.
- **A pointer in each place the unqualified figure appears**: the header, SR-HOWTO's TODAY definition, SR-ANSWER's
  table and SR-COUNT's tree-of-81 paragraph.
- **A local FY note on each of the nine rows whose section did not already carry its reach.** The page is built so
  each section stands alone, so a reader who opens only SR-EVADE meets the correction there.

**On `docs/ways-of-working.md`'s rule to REGENERATE A RECON RATHER THAN HAND-EDIT IT:** the brief asked for the
correction in the document itself. It is written as a re-derivation from the tree, marked FY's throughout, and
FW's cells are left as they stood. It adds a column; it does not rewrite a finding. A full regeneration was not
attempted.

### 1e. And the count double-counts, by the page's own rule

FW's rule is *"one trigger paying in two currencies is one thing; each thing is counted in exactly one section"*.
By that rule:
- SR-CRIT 2 already contains SR-COOLDOWN 1 (a tick on a crit) and SR-BREAK 2 (crits crack guards);
- SR-BREAK 6 is the Break half of SR-RESOURCE 4;
- SR-PARTY 3 and SR-RESOURCE 6 name the same two fields.

**So the distinct TODAY things are at most 46, not 50.** Nothing else in the count was re-taken. This is recorded in
SR-REACH and routed to the queue. It changes no node, and whether three crit nodes in one tree are one idea too
many is the designer's.

## §2 — DEEPENING HEX'S FLOOR IS RE-DERIVED: 8

**`RUIN_FLOOR := 3` became `RUIN_FLOOR := 8`.** The relation it rests on is `RUIN_FLOOR == RUIN_THRESHOLD − (the
rune's subtraction)`, which is `8 == 10 − 2`.

**What lowers the threshold today, derived rather than remembered.** `_ruin_threshold()` starts from
`RUIN_THRESHOLD` (10). It takes `avatar_ruin` when that is above zero, then applies
`maxi(step − rune_hex_deepen, RUIN_FLOOR)`. The writers were swept:
- **`avatar_ruin` has none.** Not one node of the one tree writes it (a talent may not touch an engine), and not
  one rune payload does, retired entries included. Its only writer was Avatar of Ruin, deleted at FX.
- **`rune_hex_deepen` has exactly one:** Deepening Hex, at 2.
- Nothing else in `scripts/` or `data/` moves the step. `DOD_SIM_TALENTS` can only force-learn ids of the one tree,
  and a pre-FX saved run's dead talent ids resolve to nothing at the spawn.

**So the lowest threshold reachable today is 10 − 2 = 8**, reached by an Occultist holding the rune, and FO's
method puts the floor at the bottom of it. Like FO's 3, it changes nothing today: `maxi(10 − 2, 8)` and
`maxi(10 − 2, 3)` are both 8, which the gates drive. And like FO's 3, it refuses everything below.

**THE BRIEF'S SECOND CLAUSE, AND HOW I READ IT.** The clause reads: *"If nothing lowers the threshold any more, say
so — the floor then exists only to stop `st % step` throwing … it would need the designer."*
- **Nothing lowers the BASE step any more.** Avatar of Ruin was the only thing that did.
- **The rune itself still lowers the threshold**, so there is a live bottom to set the floor at. It is not the
  arithmetic-only floor (1), which FO ruled is a different mechanic.

I read the clause as the case where nothing at all reaches below 10, and that is not today's case. **If the
designer meant the other reading** (that with the capstone gone the floor should go back to them), reverting it
moves nothing in play either way. It touches:
- the constant;
- the card's number;
- the pins in `check_fo` §1 and `check_ez` §5;
- the prose that states the floor (`battle.gd`'s comment, `CLAUDE.md`'s FO §1 rule and `master.html`).

It is listed under NEEDS A RULING as a confirmation, not a question.

**THE CONSEQUENCE, WRITTEN DOWN WHERE IT WILL BE MET.** FO's 3 sat on the capstone build's result, and a
shallower step would have met it only below 5. **The new floor sits exactly on the rune's own result**, so the next
thing that lowers the base meets it at once:

| A base step of | The rune reads | So the rune is worth |
|---|---|---|
| 10 (today) | 8 | 2 stacks |
| 9 | 8 | 1 stack |
| 8 | 8 | nothing |
| below 8 (for example the retired capstone's 5) | 8 | **worse than nothing: the floor RAISES the step, so the holder detonates LATER with the rune than without it.** That is the fault EZ's `mini` existed to stop. |

**Nothing does that today.** `check_fo` §1c goes red the day anything writes `avatar_ruin`, and that is the day the
floor is owed a ruling rather than an arithmetic slide. The same text sits beside the constant in `battle.gd` and
in `CLAUDE.md`'s FO §1 rule.

**THE CARD.** Deepening Hex's desc states the floor, because FO put it there as a rule the player meets. It read
*"never sooner than every 3rd"*, and it reads *"never sooner than every 8th"* now. That is the number the code
floors at, and it is the one token that changed. **The wording is the designer's**, and two things in it are worth
their eye:
- the sentence now reads *"every 8th instead of every 10th, and never sooner than every 8th"*;
- *"whatever the threshold is"* now holds at the one live step only.

**`check_fo` §1c IS RE-POINTED, NOT DELETED.** The brief's premise that it pinned 10, 5 and 2 was stale: FX had
already moved it to 10, 2 and 3 plus two arms (§0 #9). It now pins:
- **10, 2 and 8**, each against the source or the payload;
- **the relation as one equation**, `FLOOR == BASE_THRESHOLD − HEX_SUBTRACTS`;
- FX's arm that nothing writes `avatar_ruin`, kept.

FX's *"the floor binds no live build"* arm is replaced by the relation: the floor binds the live build exactly, by
design.

**The rest of `check_fo` §1 was repaired to intent:**
- **§1b** reads the ordinal off the floor constant, so the card and the gate cannot part.
- **§1d** keeps the arithmetic on the live board. It now also asserts the dormant `avatar_ruin` read still installs
  its step, because the next writer reaches that read.
- **§1e** asks EZ's property of every step a live payload can install. That is the base step plus every
  `avatar_ruin` value any node or rune writes, derived from the data at run time. It asserts never shallower,
  strictly deeper, and the same two stacks, and prints `CHECKED n of m`. FO asked it of two builds; the capstone
  build is gone, and a population arm asks it of the next writer without an edit.
- **§1f** drives the floor at both edges and below it, including the retired capstone's 5.

**And §1c's absence anchor got its positive arm.** *"Nothing writes `avatar_ruin`"* would pass just as well on a
walk that reached no payload, so the same walk, pointed at the field the rune DOES write, must find exactly the
Deepening Hex rune. `check_fo` goes **85 → 87**. `check_ez` §5's three capstone arms were re-pointed one-for-one at
the live step and at the floor's upper edge, so it stays **98**.

## §3 — THE WIDE WATCH STAYS RETIRED, AND ITS STRING SAYS WHY NOW

**Ruled by the designer and recorded, not reinstated.** The retirement string in `data/runes.json` now leads with
the reason that holds: **its place is filled.** The Shared Mark holds the place the Wide Watch held in the
Sharpshooter's set, taken one-for-one at FO, and it builds the meter where the Wide Watch defended it. The string
also says:
- **LOST:** the Focus carry through a kill. Since FX, nothing live keeps his Focus whole through one.
- **FO's reason is VOID.** It is named, and marked void. The Overkill node went with the twelve trees and
  `check_fo` §3 asserts no node or rune carries the clause, so the rune duplicates nothing live.
- The kept half: the `rune_wide_watch` read site still pays a saved run holding it.

**Why FO's reason is kept in the string at all.** FN's zero measurement is the history a future author needs, and
erasing it would leave the next person to re-derive why the rune was retired in the first place. What the brief
forbade was the string *misleading* someone into thinking the collision is still there, so the old reason is
marked void and does not lead.

**`check_fo` §2a is re-pointed.** It used to require the string to name Overkill, *"the NODE the rune duplicated"*.
It now requires three things:
1. the string names the Shared Mark;
2. the restated reason is dated `BATCH FY`;
3. FO's sentence (*"AUTHORED AGAINST A BASE A NODE ALREADY PROVIDED"*) is absent.

The third is the negative anchor, and the first two are its positive arms. **The first arm alone would not be
enough, and the control proved it** (§6): FO's own string ends *"Replaced by the Shared Mark"*, so "names the
Shared Mark" passes on the old string. The date arm and the anchor are what tell the two strings apart.

`check_et` §1 still sees a later retirement that names its batch and its loss. `check_fn`'s `RETIRED_BY_RULING`
still names it. `master.html`'s paragraph and `CLAUDE.md`'s FO §2 bullet now state the current reason.

## §4 — WHAT WAS DELIBERATELY NOT DONE

- **No node was swapped and no magnitude moved.** §1 reports three shipped nodes whose worth depends on who else
  holds them, and a TODAY count that double-counts. It rules on none of it. `scripts/talents.gd` is byte-unchanged.
- **The five tag-word node names stand**, as ruled. `check_ek`'s `CLASH_EXEMPT` still records them.
- **The spend gate stays at 3**, as ruled (`TIER_SPEND_MIN := 3`, unchanged).
- **No spec dissolved, no pool merged, no engine became a rune.** No `Classes` table moved.
- **No spine was attached.** Nothing under `scripts/` or `data/` assigns `momentum_active`, `channel_active` or
  `sanctity_active`, and `check_ft` §0 reads green in the battery (§6).
- **The floor's change moves nothing in play.** On the one live step, `maxi(10 − 2, 3)` and `maxi(10 − 2, 8)` are
  both 8, and `check_fo` §1g still primes the mark on the eighth stack and not the seventh.
- **No rune was authored, re-authored or retuned.** Deepening Hex's card changed one number, to state the floor the
  code now applies. The Wide Watch's `desc` and payload are untouched; only its `retired` string changed, as ruled.

## §5 — TWO THINGS FX LEFT

### 5a. The two screen gates write a scratch profile — confirmed

**By source.** `check_ct_map` and `check_map_screen` each point `Profile.save_path` at their own scratch file
(`user://check_ct_map_profile.json`, `user://check_map_screen_profile.json`) in `_ready`. They reset the cache
(`loaded = false`, `data = {}`) **before their first `Profile.set_flag`**, and then open the map screen, whose own
`set_flag` therefore lands on the scratch file too. On the way out, `_drop_scratch_profile()` deletes the scratch
file and points the path back, and the next line is `quit`.

**By measurement.** In the census below, each gate made exactly one profile write, to its own scratch path, and
neither ever wrote `user://profile.json`.

### 5b. Which targets write the player's `profile.json` — the census that had never been taken

**NO TARGET WRITES IT.** Twelve of the 108 write a profile, and every one writes its own scratch file.

**How it was taken: the act was measured, not the residue.** That is FI §1's rule, and the population is every
target rather than a derived candidate list, which is FI's correction to FH. Every battery target ran once, in an
out-of-repo copy whose `config/name` was renamed so its `user://` was its own:
- 46 suites;
- 56 gates;
- the harness's three gates;
- the two scene runs;
- `check_de`.

The copy's `user://` was **seeded with the designer's four files from the verified backup**, so each target met
the state it meets in the real tree. Three writers were instrumented, each with one `printerr` naming the path it
was about to write:
- `Profile._save` — every profile write in the game goes through it;
- `Relics.save_data`;
- `Settings.save`.

A second, independent reading came off the seeded files afterwards. That battery was also the reconnaissance run
(§6b), so it ran HEAD's instruments, unmodified, against FY's game and data.

| Target | Profile writes | Path |
|---|---|---|
| `test_batch_bm` | 124 | `user://test_bm_profile.json` |
| `check_fx` | 96 | `user://check_fx_profile.json` |
| `check_fh` | 29 | `user://fh_profile.json` |
| `check_eg` | 15 | `user://profile_check_eg.json` |
| `check_eh` | 9 | `user://profile_check_eh.json` |
| `check_ea` | 6 | `user://profile_check_ea.json` |
| `check_fm` | 3 | `user://fm_profile.json` |
| `harness_2` | 3 | `user://gate2_profile.json` |
| `check_fq` | 2 | `user://check_fq_profile.json` |
| `test_batch_bx` | 1 | `user://profile_batch_bx_test.json` |
| `check_map_screen` | 1 | `user://check_map_screen_profile.json` |
| `check_ct_map` | 1 | `user://check_ct_map_profile.json` |
| **the other 96** | **0** | — |

- **Writes to `user://profile.json`: zero.** Writes to `relics.json`: zero. Writes to `settings.cfg`: zero.
- **The residue agrees.** After the whole battery the copy's seeded `profile.json`, `relics.json`, `settings.cfg`
  and `run_save.bin` were md5-identical to the backup, **and their modification times had not moved**. That catches
  a write of identical bytes, and a write that bypassed the three instrumented functions.
- **Outside the battery:** the four root scripts no battery runs were swept by source. Only `check_dn` reaches a
  profile writer, and it redirects to its own probe path first (`Profile.save_path = PROBE`).

**AND THE SAME CENSUS FOUND THE PROFILE'S SHAPE ONE FILE OVER, IN `relics.json`.**
- `battle._resolve_boss` opens with `Relics.unlock_random()`, which calls `Relics.save_data()` and writes
  **`Relics.SAVE_PATH`: the constant `user://relics.json`, with no redirect of any kind**. That is unlike
  `Run.save_path` (FI) and `Profile.save_path`.
- `check_ea`, `check_eg` and `check_eh` call `_resolve_boss` directly. **That is the source reading, and it is
  one gate short** (the pre-pass reading below).
- **The census saw no relic write because the designer's file has all 25 relics unlocked**, so `unlock_random()`
  returns before it reaches `save_data()`. The file has not been written since 2026-08-30.
- **The day any relic is locked, every battery unlocks relics at random in the player's file, one for each reach
  while any is still locked.** That could happen with a fresh profile, a relic the merge adds to the pool, or a reset.
- It is FX's finding exactly: a write that does nothing until the state under it changes, then does something
  permanent.

**THE PRE-PASS MEASURED THE REACH, AND THE POPULATION IS FOUR, NOT THREE.** The final tree's pre-pass (§6d) ran in
a copy with one more `printerr`, at the top of `Relics.unlock_random()`, over the same seeded files:

| Target | Reaches of `unlock_random()` | How it gets there |
|---|---|---|
| `check_ea` | 2 | calls `_resolve_boss` directly |
| `check_eg` | 4 | calls `_resolve_boss` directly |
| `check_eh` | 3 | calls `_resolve_boss` directly |
| **`check_fh`** | **5** | **the boss kills of its live autoplay run**: zone bosses and The Hollow Crown |
| every other target | 0 | — |

- **`check_fh` was not in the source reading, because it never calls `_resolve_boss` itself.** It drives the real
  battle scene, and the battle calls it when a boss dies. A sweep for the call finds three gates, and measuring the
  act finds four. It is FI §1's lesson one step along: measure the act, not a proxy for it. FI's proxy was the file
  left behind, and this one was the source.
- **Every reach returned before saving.** No relic write was printed, and the seeded `relics.json` kept its md5
  and its modification time.
- With relics locked, each reach unlocks one until none is left, so one battery could unlock up to 14.
  `check_fh`'s share moves with how far its autoplay run gets.
- None of the four touches the relic file in any other way. No gate backs it up, redirects it or restores it.
- **The pre-pass also re-read the profile census, and reproduced the table above exactly**: the same twelve
  targets, the same counts and the same paths, with no write to `profile.json`, `relics.json` or `settings.cfg`.

**Reported, not fixed.** The brief asked for the profile census, and making `Relics.SAVE_PATH` redirectable is a
code change to `scripts/relics.gd` that is owed a batch (FI's `save_path` shape). It is queued in `docs/state.md`.
Nothing is broken today.

### 5c. FX's 1,864 deleted checks, audited independently

**CONFIRMED: none of them measured how an effect pays out.** No deleted check read a unit, drove a read site or
measured an outcome.

**How it was checked.** Seven read-only agents between them read every removed line of the FW → FX diff
(`5504e26` → `59491e3`) for all 51 targets, and matched each to its replacement on the `+` side. Each deleted
check was classified with its runtime multiplicity, and each file's count was reconciled against FX's table and
`baselines.json` at both commits. **The totals reproduce FX exactly, file by file:**

| Group | Targets | Deleted |
|---|---|---|
| 1 | ai, aj, ak, al | 515 |
| 2 | ar, as, at, au | 513 |
| 3 | av, aw, ax, ay | 449 |
| 4 | az, ba, bb, bc, bd, be, bf, bg | 148 |
| 5 | bh, bi, bj, bm | 32 |
| 6 | bn, bp, br, bs, bt, bv, bw, bx, cb, ce, cp, ah_battle, test_runes, test_rune_battle, the harness | 103 |
| 7 | the ten gates | 104 |
| | **Total** | **1,864** |

The audit also confirmed that every `RETIRED` payload a suite now carries is a byte-for-byte copy of the FW node,
and that the fixture's `patch` option puts it on the unit through the real spawn.

**BUT FX'S DESCRIPTION OF WHAT WAS DELETED IS INCOMPLETE.** FX §5 lists the deleted categories as *"a node's id,
row, lane, name, capstone flag, tooltip text or scale, the one-per-row exclusivity, or the grid's shape"*. **About
202 of the 1,864 asserted something outside that list: a deleted node's PAYLOAD CONTENT.** That covers its
magnitude, its field, the shape of its ability edit, or whether it granted or carried a fallback — for example
`necrosis == 35`, *"Singularity builds 2 per crit"*, *"Communion pays %d, not 40"*. Each is a static read of the
deleted tree's data, never an outcome. FX's site comments mostly say so ("per-node magnitudes and payload
shapes"), and only the summary sentence leaves the category out.
- **Most are asked again live**, through the `RETIRED` copy of the same payload and the real spawn, at the same
  number.
- **About 80 design numbers are now asserted nowhere in their suites.** All of them sit on DORMANT fields that no
  node and no rune writes (for example Sanctum, `covenant_faith` and eight Beastmaster fields). Most still have
  their read site pinned. **Nothing a live node or rune writes lost a check.**

**Found by the audit, not FX's to have predicted, and not fixed here:**
- `test_batch_at` §1: one surviving `ok(` line's guard was narrowed to one id, which dropped 14 of its 15 runs
  with no removed line. FX did count them, but a grep of removed lines cannot see them.
- **About 108 kept checks now pass by default.** 81 *"single rank"* checks (27 each in ar, as and at) read
  `n.get("ranks", 1)`, and no node of the one tree has a `ranks` key. `test_batch_at`'s 27 `exclusive_with` checks
  read a field that is always empty.
- `check_dk`: 4 of its 7 surviving *"no text still says ally"* needles look for texts of deleted nodes, or for a
  `{v}` the one tree never uses. They cannot fail, and they still count toward its 60.
- `test_batch_ay`'s `_worn_tree` silently skips a learned id that is neither live nor `RETIRED`, which contradicts
  FX §5's *"fails loudly"* (av, aw and ax do fail loudly). No spawn hits it today.
- `test_batch_ba`'s FX header says *"FX DELETED 52 CHECKS HERE (690 -> 638)"*. The truth is 55, 690 → 635.
- Pressure Cooker's `+25` Break (`battle.gd`'s `pr += 25`) was named by one deleted tooltip check and has never
  been measured at either commit. After FX, no suite names it. Its field has no writer.
- `aj`: one deleted check, *"Overkill no longer modifies Battle Shout's cooldown"*, asked about payload
  composition. FX's site comment files it under ids and names. `check_fx` §1 covers the property tree-wide.

## §6 — VERIFICATION

### 6a. The saves, backed up and hashed before anything ran

`save-backups/FY-20260911-134456/` holds all four save files. Each is md5-identical to the live file and to FX's
backup:

| File | md5 | Last written |
|---|---|---|
| `profile.json` | `b05e329b4d9c40cb1745602ab6d6ddb3` | 2026-09-10 21:01 (still v2, not yet folded) |
| `run_save.bin` | `c44d45da3d06b316717f82354816ce4c` | 2026-09-08 13:45 |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` | 2026-08-30 17:42 |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` | 2026-08-21 11:43 |

**Every Godot run before the acceptance battery ran in an out-of-repo copy renamed so that its `user://` could not
reach the player's folder.** That covers the reconnaissance-and-census battery, the probes, the controls and the
pre-pass. The census copy's `user://` was seeded from the backup, so the targets met the same state they meet in
the real tree.

### 6b. HEAD's instruments, unmodified, against FY's game and data — before any gate was edited

**The reconnaissance battery.** The tree carried FY's two game and data changes (`RUIN_FLOOR` and `runes.json`) and
**HEAD's 108 targets exactly as committed**. It ran in the census copy (§5b), and its predictions were written to
the scratchpad before it finished.

| Target | Predicted | Read | The FAIL lines |
|---|---|---|---|
| `check_fo` | 9 | **85 / 9** | §1b (the card's *"every 3rd"*), §1c (`RUIN_FLOOR` is not 3), §1d (rune and capstone reads 8, not 3), §1e ×3 (the capstone build SHALLOWER 8 > 5, worth zero, pays −3), §1f ×3 (the three floor edges read 8) |
| `check_ez` | 3 | **98 / 3** | §5 ×3: the three constructed-capstone arms |
| `check_de` | its two rising-failure errors | **449 / 2** | *"check_ez went REDDER"*, *"check_fo went REDDER"* |
| `check_cm_live` | the sanctioned red | **13 / 4** | the defensive bar, as recorded |
| every other target | at its baseline | **at its baseline, 0 failures, 0 throws**, harness 22 / 382 / 8 | — |

**No red was unpredicted, so no dependency hid.** Two things predicted green stayed green:
- `check_fo` §1c's *"floor below the live step"* arm compares only the gate's own constants.
- §2a's *"names Overkill"* arm still resolved in the new retirement string.

That second one is why §2a was re-pointed deliberately rather than left alone: it would have stayed green while
asserting the retirement's old reason. **§1e's first FAIL is the consequence §2 names, measured**: at a
constructed step of 5, the floor of 8 made the rune's holder detonate LATER.

The manifest (`.ran`) held 108 names, no duplicates, in one sequence in the battery's own order (suites, gates, the harness, the scene runs, then `check_de`). **`check_fx` completed inside its
own bound**: its log's creation and final write put it at **353 seconds** against the 720-second
`TMO[check_fx]`. FX measured 354 standalone, so *"about six minutes"* holds.

### 6c. The negative controls, each read by its FAIL text

They ran in the probe copy. Each injection was asserted to land exactly once, the file was restored by copy after
each, and each restore was proved by md5 against the pristine copy.

| # | The injection | `check_fo` | `check_ez` | What the FAIL text says |
|---|---|---|---|---|
| C0 | none | **86 / 0** | **98 / 0** | — |
| C1 | `RUIN_FLOOR` back to 3 (the repair reverted) | 86 / **5** | 98 / **1** | §1c *"`RUIN_FLOOR` is not 8 in the source"*; §1f *"at a threshold of 9 the subtraction reached 7"*, *"at the floor itself … read 6"*, *"the retired capstone's step (5) … read 3 rather than the floor 8"*, *"a threshold BELOW the floor was not raised to it (3)"*; `check_ez` §5 *"the floor holds a 9-threshold at 8 rather than letting the subtraction reach 7"* |
| C2 | the card back to *"every 3rd"* | 86 / **1** | — | §1b *"the card no longer states the FLOOR of 8"* |
| C3 | the Wide Watch's string back to FO's | 86 / **2** | — | §2a *"does not date the restated reason"*, and *"still offers FO's reason as live"*. **The "names the Shared Mark" arm PASSED on FO's string**, because FO's ends *"Replaced by the Shared Mark"*. That is why the date arm and the anchor exist |
| C4 | the string without *"Shared Mark"* | 86 / **1** | — | §2a *"does not record the CURRENT reason"*, the positive arm alone |
| C5 | the string with FO's sentence appended | 86 / **1** | — | §2a *"still offers FO's reason as live"*, the negative anchor alone |
| C6 | a rune payload writing `avatar_ruin: 6` (a live shallower step) | **89** / **4** | — | §1c *"["rune:deepening_hex"] write `avatar_ruin` … below 8 the floor RAISES the step"*; §1e at a step of 6: *"made the hex SHALLOWER (8 > 6)"*, *"worth ZERO"*, *"pays -2"*. The population arm grew by three checks on its own |
| C7 | none | **86 / 0** | **98 / 0** | — |

**Every re-pointed arm bit, and each bit in the direction its repair changes.** C1 reverts the floor, and C3
reverts the string. C6 is the case §1e was rebuilt for, a live payload installing a step, and the arm found it
without an edit.

**AND THEN §1c'S ABSENCE ANCHOR WAS PAIRED, WHICH IS WHY THE GATE IS 87 AND NOT 86.** C0–C7 ran on the 86-check
gate. Writing them up showed that FX's *"nothing writes `avatar_ruin`"* arm, which FY kept, had no positive arm of
its own. The brief's rule is that every negative anchor gets one. One was added (§2), and the pair was controlled
in a second copy on the final 87-check gate:

| # | The injection | `check_fo` | What the FAIL text says |
|---|---|---|---|
| D0 | none | **87 / 0** | — |
| D1 | the writer walk blinded (`_writes_key` returns false at once) | 87 / **1** | §1c *"the writer walk found [] writing `rune_hex_deepen`, not exactly the Deepening Hex rune"*. **The absence anchor PASSED on the blinded walk**, and only the new arm caught it. That is the whole case for the pair |
| D2 | a rune payload writing `avatar_ruin: 6` | **90** / **4** | as C6 |
| D3 | none | **87 / 0** | — |

Every restore was proved by md5 against its pristine copy.

### 6d. The pre-pass: the final tree, every target, in the probe copy

**All 108 targets ran once more before the real tree ran anything**, in the renamed probe copy (`DoD FY probe`),
with `user://` seeded from the backup and the census instrumentation in place, plus the relic reach print. A file
diff names the copy's three differences from the final tree:
- `check_fo` without §1c's pairing arm: 86 checks, with that copy's baseline row at 86, so internally consistent;
- the census `printerr` lines in `profile.gd`, `relics.gd` and `settings.gd`, and the renamed `config/name`;
- two untracked scratch probes at the root (`fy_probe_kits.gd`, `fy_probe_reach.gd`).

It also ran BEFORE four document edits that its reach reading caused: `docs/changelog.html`,
`docs/instrument-rules.md`, `docs/state.md` and this report.

| Reading | Result |
|---|---|
| Suites and gates | every target at its baseline with 0 failures and 0 throws, except `check_cm_live` at 13 / 4 (the sanctioned red) |
| `check_fo`, `check_ez` | 86 / 0, 98 / 0 |
| Harness | 22 / 382 / 8 |
| `check_de` | 449 / 0, with **one notice**: `check_parse` ROSE to 184 against a recorded 182 |
| Truncation | none: no target timed out and none reported NO VERDICT |

**The notice is the copy, not the tree.** `check_parse` walks every root `.gd`, and the copy held the two scratch
probes. The real tree reads 182 (a standalone reading in a copy synced from it), and the acceptance battery below
is the reading of record.

**The six targets that read the later-edited documents were re-run on them**, in the census copy after a sync from
the real tree with `diff -rq` empty. The five readers of `docs/instrument-rules.md` read `check_ec` 23 / 0,
`check_fg` 22 / 0, `check_ff` 55 / 0, `test_batch_ce` 1114 / 0 and `check_fr` 25 / 0; the one reader of
`docs/state.md`, `check_es`, read 57 / 0. Each is its baseline. The literal sweep over the edits moved four needles,
all in `docs/instrument-rules.md`, and none is owned by a file that reads it.

### 6e. The acceptance battery: the final tree, in the real tree, frozen

**It ran once, in the real repository, after the last edit to any file a target reads.** Every file was frozen
first: the md5 of each of the 383 tracked and untracked files by absolute path, plus the four save files with their
modification times. The process table was read by rows before the launch and after the finish, and nothing else was
running either time.

| Reading | Result |
|---|---|
| Manifest (`.ran`) | 108 names, 108 unique, in the battery's own order; 108 logs, each created after the one before it |
| Parse floor | `Parse Error` on 0 lines across all 108 logs, and `SCRIPT ERROR` on 0 |
| Truncation | no TIMED OUT, no NO VERDICT and no INCOMPLETE; the seven targets that print no count each printed their end marker |
| Suites and gates | every target at its baseline, with 0 failures and 0 throws, except `check_cm_live` at 13 / 4 (the sanctioned red) |
| `check_fo` | **87 / 0**, its new row |
| `check_ez` | **98 / 0** |
| `check_ft` | 140 / 0, so §0 holds and no spine is attached |
| `check_parse` | **182**, its recorded count |
| Harness | 22 / 382 / 8 |
| `check_de` | **449 / 0, with no notices** |
| `check_fx`'s time | **353.5 s** from its log's creation to its last write, against `TMO[check_fx]` = 720 s. FX measured 354 and the reconnaissance battery 353, so *"about six minutes"* holds |
| Wall clock | 15:58:04 to 16:44:14, 46 minutes |

`test_batch_an` read 6050 here and 6054 in the pre-pass. It is `baselines.json`'s named drifter, with a band of 6046
to 6063, and both readings sit inside it.

### 6f. After it, the tree and the saves had not moved

**The freeze taken after the battery is identical to the one taken before it, line for line.** That covers all 383
files and the four save files' md5s and modification times.
- **No target wrote the player's `profile.json`, `run_save.bin`, `relics.json` or `settings.cfg`**, not even with
  identical bytes, because their modification times did not move either. Each is still md5-identical to the
  backup and still carries the modification time in §6a.
- No tracked or untracked file in the repository changed. The freeze does not cover ignored files, such as
  Godot's `.godot/` cache.

This is the census's third reading of the same fact (§5b's copy, the pre-pass copy, and now the real files). It is
the only one taken on the player's own files.

## §7 — WHAT MOVED

**GAME AND DATA.**
- `scripts/battle.gd`: `RUIN_FLOOR := 3` → `8`. The comment above it and the comment in `_ruin_threshold` state the
  new relation and its consequence.
- `data/runes.json`:
  - Deepening Hex's `desc`, where *"every 3rd"* became *"every 8th"*: the floor the code applies. No payload or
    price moved.
  - The Wide Watch's `retired` string, rewritten to lead with the current reason and to mark FO's void. Its `desc`,
    payload, scope and price are untouched.

**DOCUMENTS.**
- **`docs/systems-recon.html`:**
  - SR-REACH, new.
  - Pointers in the header, SR-HOWTO, SR-ANSWER and SR-COUNT.
  - Local FY notes on nine unflagged rows (SR-BREAK 7 and 9, SR-STATUS 2, SR-TIMELINE 2, SR-HEAL 1, SR-RESOURCE 6,
    SR-THREAT 1, and SR-EVADE's TODAY table row and item 4).
- **`CLAUDE.md`:**
  - The FX block's line on the two FO reasons.
  - FO §1's relation bullet, and a new bullet on the floor sitting on the rune's result.
  - The retired-content rule's FO §2 bullet.
- **`docs/master.html`:** the floor sentence, the Wide Watch paragraph and the stamp.
- **`docs/instrument-rules.md`:** one bullet. It said the battery destroys the player's run save (untrue since FI's
  redirect) and that the meta layer (`profile.json`, `relics.json`) is safe. It now says both as FY measured them:
  the run save is unreachable, the profile has no writer, and the relic file is safe only while every relic is
  unlocked. The claim is corrected where it stood, per the rule that a corrected claim is swept for every copy.
  **Written before the acceptance battery**, and its five readers were pre-checked green on it (§6d).
- **`docs/changelog.html`**, **`docs/design-notes.md`**, **`docs/state.md`**, and this report (**new**).

**INSTRUMENTS.**
- `check_fo.gd`: §1 re-pointed at the re-derived floor, with a positive arm paired to §1c's absence anchor; §2a at
  the current reason; and §3's message and comment. 85 → 87.
- `check_ez.gd`: §5's three capstone arms re-pointed one-for-one at the live step and the floor. Stays 98.
- `baselines.json`: the `check_fo` row, 85 → 87, with its reason.
- `pin-manifest.json`: regenerated.

**NOT COMMITTED.** `save-backups/FY-20260911-134456/` holds the four save files, like every batch's backup. It is
untracked, as that folder has always been.

**ONE INCIDENT, RECORDED.** `build_pin_manifest.py` takes no `--help`: it rewrites the manifest whatever it is
passed, so asking it for help regenerated `pin-manifest.json` from the tree as it stood mid-batch. The rewrite was
the correct regeneration of that tree, and the only change was six statement indices in `check_ez`. It was
regenerated again after the last gate edit, and `--check` reads *current (1460 pins)*. It is the shape of the
memory note about a dry run that executes the module.

## §8 — FOUND AND NOT FIXED

**PLAYER-FACING, OR ABLE TO BECOME SO.**
- **Enemies Look Past You's text is false whenever other heroes hold it** (§1b): three of four heroes are targeted
  more when all four hold it. This is under NEEDS A RULING.
- **Deepening Hex's card**, at the new floor, reads *"every 8th … and never sooner than every 8th"*. Its *"whatever
  the threshold is"* holds at the one live step only. The wording is the designer's.
- **Three float texts name one currency and pay any pool.** Bloodied Momentum floats *"+40 Rage"*, Second Wind
  *"+60 Rage"* and Scavenger *"+N Mana"*, whatever pool the hero holds (SR-RESOURCE 4, SR-COOLDOWN 5). All three
  fields are dormant (no node writes them, and Scavenger's only rune is retired), so none can fire today. A node
  that wrote one would pay every class correctly and tell three of them the wrong currency.

**INSTRUMENTS** (from the §5c audit; all older than FY, and none changes a verdict today):
- About 108 checks that now pass by default: 81 *"single rank"* checks (ar, as, at) and 27 `exclusive_with`
  checks (at).
- `check_dk`'s four needles that cannot fail, and still count toward its 60.
- `test_batch_ay`'s `_worn_tree` skips an unknown id silently.
- `test_batch_ba`'s stale header count.
- `test_batch_at` §1's narrowed guard (14 runs dropped, and counted by FX).
- Pressure Cooker's `+25` Break, never measured at either commit.
- About 80 design numbers on dormant fields, now asserted nowhere in their suites.
- **`check_fx` §4 drives 24 of 27 read sites on one hero, and lands the payloads on one spec per class.** FY's
  scratch probe showed all 27 land on all twelve specs and drove the three reach shapes. A twelve-spec landing arm
  in `check_fx` would close the gap for the next node, but that is an instrument change this batch did not take.

**IN THE RECON, NOT RE-DERIVED.** SR-REACH adds the reach and the double count and re-takes nothing else. In
particular, the SMALL, LARGE and RULING costs have not been checked for the same blind spot. A SMALL item priced
as *"one field and one read line"* may still need one field per currency to pay every class.
