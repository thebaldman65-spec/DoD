# BATCH ES — THE RUNE LAYER'S NEW SHAPE

**Structure only. Not one rune is authored, re-authored or retuned** — every `payload`, `price`,
`desc`, `lane` and `scope` in `data/runes.json` is byte-unchanged; the two keys the batch removes
(`rarity`, `scarred`) are the whole data diff. **The one magnitude that moved is the GENERATED stat
family's**, and only because its ×1/×2/×3 ladder was literally a rarity field.

**What shipped: rarity removed entirely, the Scarred label removed with every cost clause kept,
scope made the surviving axis, and the machinery for a rune to read ARCHETYPE TAGS on its holder's
EQUIPPED cards.** Plus one new gate, `check_es`, at 42 checks.

**Three of the brief's premises were wrong and all three are corrected below**, one of them in the
reassuring direction. **Five negative controls were armed and all five bit.**

---

## THE BRIEF'S CLAIMS, RE-DERIVED

| claim | verdict |
|---|---|
| *"It means KIND — common is flat stats, rare alters an ability's numbers, epic grants an ability or inverts a rule"* (§1) | **HOLDS AS A DESCRIPTION AND IT WAS NEVER A BEHAVIOUR.** The kind lives in the payload; the label named it and did nothing. Removing the tier therefore removes no behaviour, and each rune was checked to still do what it does — `test_rune_battle` drives all 65 through a live battle and reads **97 / 0**. **The one place the tier WAS mechanical is `TEMPLATES`**, whose `base` was multiplied by `RARITIES[rk]["mult"]`. |
| *"It drives the offer odds … that is the only thing making a late rune differ from an early one"* (§1) | **HOLDS, AND IT IS BIGGER THAN THE SENTENCE SUGGESTS.** Measured on the live pool at 4,000 draws a cell: the generated stat family was **49.8% / 33.1% / 21.1%** of a Berserker's offers at zone slots 1 / 2 / 3, and is **29.9% / 29.6% / 30.3%** now. **The early game improves and the late game worsens**; that is what the ruling costs and it is paid on purpose. §1b. |
| **"`Runes.is_cost()` refuses to scale a negative term under the sim's rarity lever. That reads rarity."** (§1) | **THE SECOND SENTENCE IS FALSE, IN THE REASSURING DIRECTION.** `is_cost` reads a **field name and a sign** and has never read rarity — it is `PENALTY_FIELDS.has(field) or INVERTED_STAT_FIELDS.has(field)` then `value < 0.0`. And **`DOD_SIM_RUNE_POWER` is a POWER lever, not a rarity lever**; the phrase *"the sim's rarity lever"* has been copied through EO §3, EP §4 and EQ. **Removing rarity therefore cannot make a cost clause start scaling**, which was the inverse defect the brief was right to ask about. §1c. |
| *"100g rares and a 75g Scarred are priced against a tier that will not exist"* (§1) | **HOLDS AND NOTHING WAS INVENTED.** Authored runes have always carried their own `price` in the data and `build()` has always read it — **not one price moved.** The 53 offerable carry **50 / 75 / 100 / 120 / 160**, and the distribution is in §1d. **No pricing rule is proposed.** |
| *"The five universals are authored and working, and losing five runes to a scoping rule is waste"* (§2) | **HOLDS, AND THE SIZE OF THE MOVE IS LARGER THAN THE BRIEF STATES.** Measured through the live door on an empty pouch, **the five are 5 of every spec's 9–12 offerable runes — 42% to 56% of the drawable pool.** §2a. |
| *"Two of the five are Scarred — glass and vampiric"* (§2) | **HOLDS.** Both are universal and both carry a payload cost (`dmg_taken_bonus: +0.15` and `healing_received_mult: -0.30`). **Which specs lose access: all nine outside whichever class each lands on.** §2b. |
| *"`Runes.is_cost()` and the `scarred` flag are separate things and only one of them is being retired"* (§3) | **HOLDS, AND THEY HAD NEVER AGREED.** Both populations are **17** and they are **different 17s** — `exsanguination` carried the flag and has no payload cost term at all, and `anchor` carries a real −10 Speed and never carried the flag. §3a. **This is the batch's sharpest finding.** |
| *"A cost clause that stops being recognised as a cost is a rune that quietly became pure upside — measure at least one before and after"* (§3) | **MEASURED, ON TWO SHAPES AND AT THE ARM'S OWN ×3.** Upside moves, cost held, on `glass` (a positive number that IS the cost) and `anchor` (a negative on an ordinary field). **No clause became pure upside.** §3b. |
| *"The Bared Guard is kept, ruled at EP"* (§3) | **HOLDS AND IS UNTOUCHED.** `rune_seasoned_def_bonus: -0.15` is byte-unchanged and it is still one of the 17. The `CLAUDE.md` standing rule is **relabelled, not weakened** — it was written about "a Scarred rune" and is about a rune that charges. |
| **"`check_ek` §3 asserts the game-side tag population at three and that number moves here"** (§4) | **HOLDS. IT MOVES TO FOUR** and the fourth is `scripts/party_screen.gd`, the hero sheet — the surface `docs/state.md` has recommended since EK. §4d. |
| *"A hero's pool is everything drafted; his loadout is the 7–10 equipped and freely swappable"* (§4) | **HOLDS WITH ONE CORRECTION THAT DECIDES A DESIGN QUESTION.** The **7–10 is `ability_slot_cap()`, which counts the PROTECTED CORE as well** — `ability_slots_used` is `core_slots(spec) + equipped_ability_names().size()`. So the cores are inside the brief's own number, and **only the earned half is "freely swappable"**. The census counts the whole bar. §4a. |
| *"Thresholds are the default shape"* (§4) | **BUILT** — `Runes.tag_threshold_met(loadout_names, tag, need)`. |
| **"Six of twelve splashes were retired"** (§5) | **WRONG BY ONE: FIVE were retired and SEVEN remain.** Derived off `runes.json` (a splash is a spec rune with no `lane`), cross-checked against EO §3's own retirement table. §5a. |
| *"`inquisitor` is the Devout, `mystic` the Survivalist"* (§7) | **HOLDS** — every spec table below carries both. |

---

## §1 — RARITY IS REMOVED

### §1a — EVERY SITE THAT READ IT, REPORTED BEFORE REMOVAL

**Fifteen sites in the shipped game and seven in the targets.** The whole surface:

| what | where | what it did | where it went |
|---|---|---|---|
| `Runes.RARITIES` | `runes.gd` | label, prefix, price, `mult`, colour | **deleted** |
| `Runes.RARITY_WEIGHTS` | `runes.gd` | 60/30/10 → 40/40/20 → 25/45/30 by zone slot | **deleted** |
| `Runes.rarity_weights()` / `_roll_rarity()` | `runes.gd` | rolled a tier per offer | **deleted** |
| `Runes.SCARRED_PREFIX` / `SCARRED_COLOR` | `runes.gd` | the crimson name | **deleted (§3)** |
| `eligible_ids(member, rarity_key, owned)` | `runes.gd` | filtered the pool to one tier | **parameter dropped** — all four callers passed `""` |
| `display_name()` | `runes.gd` | prepended the tier or Scarred prefix | **returns the authored name** |
| `template_rune(class_key, rarity_key, …)` | `runes.gd` | `base × mult`, tier price, tier prefix in the name | **parameter dropped; `base`, `TEMPLATE_PRICE`, no prefix** |
| `build()` → `rarity`, `rarity_color` | `runes.gd` | two display fields on every instance | **`scope_label`, `scope_color`** |
| `rune["rarity"]` | `map_screen.gd:895`, `shop_screen.gd:213` | the word on the offer button and the shop row | **`scope_label`** |
| `rune["rarity_color"]` | `map_screen.gd` ×3, `party_screen.gd`, `shop_screen.gd` | the tint on five surfaces | **`scope_color`** |
| `"rarity"`, `"scarred"` keys | `data/runes.json` ×65 / ×17 | the authored tier and flag | **removed** |
| `RARITY_KEYS` + the schema check | `test_runes.gd` | required a valid tier | **inverted to an absence pin** |
| the scarred-undercuts-its-peer price check | `test_runes.gd` | compared price to `RARITIES[…]["price"]` | **no peer left; replaced by §3's derived census** |
| `wrist["rarity"]` | `test_batch_ak.gd:593` | copied into a hand-built rune dict | **dropped — nothing read it** |
| prose | `run_sim.gd:471`, `events.gd:69`, `master.html` ×5, `CLAUDE.md`, `design-notes.md`, `glossary.json` | | **corrected or annotated** |

**WHAT REPLACED THE LABEL AND THE COLOUR: SCOPE.** It is the axis §2 makes the only one, it is
derived from a field that decides eligibility, and **it drives no odds, no price and no magnitude**
— which is the test that distinguishes it from rarity under a new name. The palette is carried over
unchanged from the three tiers, so nothing on the screens moves except what the words mean.

**AND EVERY RUNE STILL DOES WHAT IT DID.** `test_rune_battle` drives all 65 through a live battle
asserting on named clauses and values; it reads **97 checks / 0 failures**.

### §1b — THE OFFER ODDS, MEASURED BEFORE AND AFTER

*`Runes.generate()` through the live door, empty pouch, 4,000 draws a cell, four specs one per
class. The "before" arm was taken on unmodified `HEAD`.*

| spec | zone slot | stat-stick share BEFORE | AFTER | distinct authored runes reachable |
|---|---|---|---|---|
| berserker (Warrior) | 1 | **49.8%** | | 11 |
| berserker | 2 | 33.1% | | 11 |
| berserker | 3 | 21.1% | | 11 |
| cryomancer (Mage) | 1 | 50.6% | | 10 |
| cryomancer | 3 | 22.3% | | 10 |
| occultist (Cleric) | 1 | 51.1% | | 9 |
| occultist | 3 | 22.1% | | 9 |
| beastmaster (Hunter) | 1 | 51.9% | | 12 |
| beastmaster | 3 | 20.8% | | 12 |
| **berserker, all three slots** | 1 / 2 / 3 | 49.8 / 33.1 / 21.1 | **29.9 / 29.6 / 30.3** | 11 |

**HALF OF EVERY ZONE-1 OFFER WAS A GENERATED STAT STICK**, because 60% of the roll landed in the
"common" bucket and that bucket holds **one** authored rune (`anchor`) plus the six templates. **It
is a flat ~30% at every slot now** — the templates' share of the whole eligible pool, which for a
Warrior is 5 of 16 (`max_resource` is excluded for the class).

**THE EARLY GAME IMPROVES AND THE LATE GAME WORSENS. That is the ruling's price and it is stated
rather than buried.** `check_es` §1 measures the spread at three zone slots on every battery run and
fails if it exceeds 4.5 points; the old weights spread it by **29**.

### §1c — `is_cost` NEVER READ RARITY, AND THE PHRASE THAT SAID IT DID HAS TRAVELLED THREE BATCHES

```
static func is_cost(field: String, value: float) -> bool:
	if PENALTY_FIELDS.has(field) or INVERTED_STAT_FIELDS.has(field):
		return value > 0.0
	return value < 0.0
```

**A field name and a sign.** The lever it serves is `DOD_SIM_RUNE_POWER`, gated on `Run.sim_run`,
which scales authored payload **UPSIDE** and holds every cost — a POWER lever. The phrase *"the
sim's rarity lever"* appears in `docs/reports/EO.md` §3, `docs/reports/EP.md` §4 and was copied into
this brief. **Nothing about rarity's removal reaches it**, and §3b measures that rather than
asserting it.

### §1d — HOW PRICE IS SET AFTERWARDS, AND THE FLAG ON IT

**Authored runes: unchanged, per entry, straight out of the data.** `build()` has always read
`int(e["price"])` and never `RARITIES[…]["price"]`. **Not one price moved.**

**The generated family: `Runes.TEMPLATE_PRICE` = 50** — the Common floor those six already sat on,
carried over so nothing moves. **That is not a pricing rule; it is the absence of one.**

**THE OPEN QUESTION, WITH ITS DISTRIBUTION.** The 53 offerable runes carry:

| price | count | what it used to mean |
|---|---|---|
| 50g | 1 | the one Common (`anchor`) |
| 75g | 14 | a Rare that charged for its upside — *priced below its clean peer* |
| 100g | 27 | a clean Rare |
| 120g | 6 | an Epic that charged |
| 160g | 5 | a clean Epic |

**Every one of those numbers was written against a tier table that no longer exists**, and the
75/120 rows exist *specifically* to undercut a peer price that is gone. **This is a design decision
and it is the designer's. Nothing was invented and no price moved.**

---

## §2 — THE FIVE UNIVERSALS

**They are NOT retired and they are NOT re-scoped here.** The ruling is that scope becomes spec and
class only; **the class each lands on is content, the brief says the designer chooses it, and the
standing rule forbids a batch presenting rune content as options.** So the five keep `scope:
"universal"`, `_scope_ok` still resolves it, and `check_es` §2 **asserts all five still roll for all
twelve specs** — so a stealth retirement through an eligibility rule goes red rather than quiet.
**Flipping the five is one string each in `data/runes.json` on the day the designer rules**, and the
day `universal` has no members the branch can go too.

### §2a — WHAT EACH DOES, AND WHICH CLASS ITS FIELDS ALREADY BELONG TO

*The "who else writes this field" column is derived off `runes.json` over the offerable pool — it is
evidence about where a rune already lives, not a recommendation dressed as one.*

| rune | what it does | its fields | who else writes them |
|---|---|---|---|
| **Anchor Rune** (50g) | +12% armor, −10 Speed | `armor`, `speed` | `armor`: hunter class-wide, Beastmaster. `speed`: cleric class-wide, Warden, Holy, Sharpshooter |
| **Glass Rune** (75g, charges) | +8% crit chance, +15% damage taken | `crit_bonus`, `dmg_taken_bonus` | `crit_bonus`: **Swordmaster only**. `dmg_taken_bonus`: **nothing else in the file** |
| **Rune of the Reaper** (100g) | +15% damage below 35% health | `rune_execute_bonus` | **nothing else in the file** |
| **Rune of the Colossus** (100g) | +8% max health | `max_hp_pct` | mage class-wide, Warden, Pyromancer, Devout, Survivalist |
| **Vampiric Rune** (120g, charges) | drinks 10% of damage as health, heals 30% weaker | `rune_lifesteal`, `healing_received_mult` | `rune_lifesteal`: **nothing else**. `healing_received_mult`: cleric class-wide, Cryomancer, Occultist |

**THE HONEST READING OF THAT TABLE IS THAT IT DOES NOT DECIDE ANYTHING**, and saying so is the
point. Two of the five (`reaper`, and half of `glass` and `vampiric`) write fields **no other rune
touches at all**, so field-neighbourhood cannot place them. The three that can be placed by it point
in different directions from each other. **The decision is thematic and it is the designer's.**

### §2b — THE SIZE OF THE MOVE, AND WHO LOSES ACCESS

*Offerable depth per spec, empty pouch, through `Runes.eligible_ids`. Printed by `check_es` §2 every
battery run.*

| spec (id — display name) | total | universal | class | spec |
|---|---|---|---|---|
| berserker — Berserker | 11 | 5 | 3 | 3 |
| warden — Warden | 12 | 5 | 3 | 4 |
| swordmaster — Swordmaster | 12 | 5 | 3 | 4 |
| pyromancer — Pyromancer | 12 | 5 | 3 | 4 |
| cryomancer — Cryomancer | 10 | 5 | 3 | 2 |
| arcanist — Arcanist | 11 | 5 | 3 | 3 |
| holy — Holy Cleric | 11 | 5 | 3 | 3 |
| inquisitor — **Devout** | 10 | 5 | 3 | 2 |
| occultist — Occultist | **9** | 5 | 2 | 2 |
| beastmaster — Beastmaster | 12 | 5 | 3 | 4 |
| sharpshooter — Sharpshooter | 11 | 5 | 3 | 3 |
| mystic — **Survivalist** | 10 | 5 | 3 | 2 |

**THE FIVE ARE 42% TO 56% OF EVERY SPEC'S DRAWABLE POOL.** Re-scoping them is the largest single
movement the rune pool has taken. **Every spec outside the chosen class loses that rune** — nine of
the twelve for each, since a class holds three specs. If all five landed on one class, the other
nine specs would fall to **4–7 offerable against 3 rune slots**, and the Occultist — already
thinnest at 9 — would fall to **4**.

**AND THE SPECIFIC LOSS EP MEASURED.** `glass` and `vampiric` are the Swordmaster's fallback if the
Bared Guard is ever retired (`CLAUDE.md` carries that reasoning). **Re-scoping either to a non-Warrior
class removes that fallback outright**; re-scoping both to Warrior keeps it and takes it from the
other nine.

---

## §3 — SCARRED GOES, THE COSTS STAY

### §3a — THE LABEL AND THE BEHAVIOUR HAD NEVER AGREED, AND BOTH SETS ARE 17

*Derived by walking every payload through `Runes.is_cost` and comparing with the retired flag.*

**17 flagged. 17 derived. Fifteen in common, one each way.**

| id | flagged? | cost term `is_cost` recognises |
|---|---|---|
| anchor | **no** | `stat.speed = -10.0` |
| bared_guard | yes | `stat.rune_seasoned_def_bonus = -0.15` |
| burning_censer | yes | `stat.max_hp_pct = -0.12` |
| carrion_wake | yes | `stat.max_hp_pct = -0.12` |
| glass | yes | `stat.dmg_taken_bonus = +0.15` (a PENALTY_FIELD) |
| hollow_chalice | yes | `stat.healing_received_mult = -0.30` |
| iron_promise | yes | `stat.speed = -10.0` |
| killing_cold | yes | `stat.healing_received_mult = -0.25` |
| long_draw | yes | `stat.speed = -10.0` |
| loosened_straps | yes | `stat.armor = -0.08` |
| martyr | yes | `stat.speed = -8.0` |
| reckless_channeling | yes | `stat.max_hp_pct = -0.10` |
| sleepless_vigil | yes | `stat.speed = -10.0` |
| unquiet_mind | yes | `stat.mana_regen_bonus = -8` |
| vampiric | yes | `stat.healing_received_mult = -0.30` |
| white_flame | yes | `stat.max_hp_pct = -0.12` |
| wolfs_hunger | yes | `stat.armor = -0.08` |
| **exsanguination** | **yes** | **none — see below** |

**`exsanguination` IS THE ONE THE FLAG WAS THE ONLY RECORD OF.** Its entire payload is
`{"stat": {"blood_pact": -15}}`. `blood_pact` is in `INVERTED_STAT_FIELDS`, where a **negative is
the rune's PROMISE** — enemy veins pop at 85 instead of 100. Its price is at the same read site:
`battle._add_bleed_with_burst` (`battle.gd:21876`), where the presence of a negative `pact` makes the
bleedout tear **15% of max health instead of 20%**. **One field, two behaviours, one read site, and
nothing for any sweep to find.** It is NAMED in `test_runes.COST_WITHOUT_A_TERM` and in
`check_es` §3 with its reason rather than suppressed — the project's own idiom.

**`anchor` IS THE ONE A RARITY RULE WAS HIDING.** It carries a real −10 Speed and never carried the
flag, because `test_runes` asserted *"scarred commons are not a thing"* and it is the one common in
the file. **The schema forbade the label on grounds of TIER, not of behaviour** — so §1 removing
rarity is what makes this cost visible to a derived population for the first time. It is a small
argument for §1 that §1 did not have to make for itself.

**THE `check_es` §3 POPULATION IS PINNED AS A NAMED SET, NOT A COUNT.** A count would let one entry
lose its term while another gained one and read green.

### §3b — MEASURED BEFORE AND AFTER, WHICH IS WHAT §3 ASKED FOR

*Through `Runes.scale_payload` at the power arm's own ×3, on one entry of each shape.*

| entry | shape | upside | before → after | cost | before → after |
|---|---|---|---|---|---|
| `glass` | positive number IS the cost | `crit_bonus` | 0.08 → **0.24** | `dmg_taken_bonus` | 0.15 → **0.15** |
| `anchor` | negative on an ordinary field | `armor` | 0.12 → **0.36** | `speed` | −10.0 → **−10.0** |

**And on a live hero config:** `Talents.apply_payload` with the Anchor Rune's payload lands
**−10 Speed** on a real `warrior` config. **No cost clause became pure upside.**

**THE `_coverage` PROPERTY SURVIVED THE INSTRUMENT CHANGE.** `test_runes` asserted *"exactly one
scarred lane rune per spec, and never the splash"*; derived through `is_cost` (with
`exsanguination` named), that is still **exactly one per spec and zero splashes**, on all twelve.

---

## §4 — RUNES READ TAGS

### §4a — WHAT IS BUILT, AND THE ONE CORRECTION TO THE BRIEF'S OWN NUMBER

```
Run.loadout_ability_names(member)          # the list: protected core + equipped earned
  -> Classes.tag_count(names, tag)         # the arithmetic
  -> Classes.tag_census(names)             # every tag at once, with ZERO rows
  -> Classes.tag_breadth(names)            # how many different tags at all
Runes.tag_threshold_met(names, tag, need)  # the default shape a rune asks through
Runes.breadth_met(names, need)             # §5's shape
```

**THE BRIEF SAYS "the 7–10 equipped and freely swappable" AND THOSE ARE TWO DIFFERENT SETS.** The
7–10 is `Run.ability_slot_cap()`, and `ability_slots_used` is `Classes.core_slots(spec) +
equipped_ability_names().size()` — **so the protected core is inside the brief's own number**, while
only the earned half is swappable. **The census counts the whole bar**, for three reasons:

1. **The cores ARE equipped.** They are what `battle.gd`'s spawn puts on the bar, and
   `check_es` §4 re-derives the spawn's own non-earned kit for all twelve specs and requires it to be
   `Classes.protected_names(spec)` name for name — **identical on all twelve**. A census over names
   the fight does not use is a number about nothing.
2. **A hero with no earned cards would census to ZERO on every tag**, so a rune bought at the
   Peddler in zone 1 could never be on. The mechanic would be dead for the first third of a run.
3. **`protected_names` and `core_slots` are different units and the census wants NAMES.**
   `core_slots("beastmaster")` is 3 and he holds **six** protected names (three summons are one bar
   entry). This is `check_eh` §3's own distinction applied rather than violated, which is why that
   gate's named reader set gains `run_state.gd` with that reason.

**THE `Runes` HELPERS TAKE THE NAME LIST, NOT THE MEMBER, AND THAT IS A CONSTRAINT RATHER THAN A
PREFERENCE.** They are static on a `class_name` script and **a static function cannot see an
autoload** — `Run` from there is `Compile Error: Identifier not found: Run`, found by running it. The
split is also what keeps `run_state.gd` free of every tag word, which `check_ek` §3 asserts at zero
for that file by name.

### §4b — THE CORE-KIT BASELINE, WHICH IS THE FINDING A THRESHOLD HAS TO BE AUTHORED AGAINST

*Every protected core of every spec, through `Classes.card_tags`. Printed by `check_es` §4 every
battery run.*

| spec (id — display name) | DEBUFF | DEFENSE | BREAK | RESOURCE | OFFENSE | TEMPO | MARK | cards | breadth |
|---|---|---|---|---|---|---|---|---|---|
| berserker — Berserker | 2 | 1 | 4 | 1 | 0 | 0 | 0 | 4 | 4 |
| warden — Warden | 2 | 1 | 3 | 1 | 0 | 0 | 0 | 4 | 4 |
| swordmaster — Swordmaster | 1 | 1 | 3 | 2 | 1 | 0 | 0 | 4 | 5 |
| pyromancer — Pyromancer | 4 | 0 | 4 | 0 | 0 | 0 | 0 | 4 | 2 |
| cryomancer — Cryomancer | 4 | 0 | 4 | 0 | 0 | 0 | 0 | 4 | 2 |
| arcanist — Arcanist | 0 | 0 | 4 | 4 | 0 | 0 | 0 | 4 | 2 |
| holy — Holy Cleric | 0 | 4 | 1 | 1 | 0 | 0 | 0 | 5 | 3 |
| inquisitor — **Devout** | 0 | 2 | 1 | 1 | 1 | 1 | 0 | 4 | 5 |
| occultist — Occultist | 3 | 1 | 2 | 1 | 0 | 0 | 0 | 4 | 4 |
| beastmaster — Beastmaster | 2 | 1 | 5 | 1 | 1 | 0 | 0 | 6 | 5 |
| sharpshooter — Sharpshooter | 0 | 0 | 3 | 3 | 1 | 0 | 0 | 4 | 3 |
| mystic — **Survivalist** | 3 | 0 | 3 | 1 | 0 | 0 | 0 | 4 | 3 |
| **specs meeting 2+ on the CORE ALONE, of 12** | **7** | **2** | **10** | **3** | **0** | **0** | **0** | | |

**A "hold 2+ BREAK" RUNE WOULD BE ON FROM THE FIRST FIGHT FOR TEN OF THE TWELVE SPECS AND NO SWAP
COULD TURN IT OFF.** That is the flat increment the equipped/owned distinction exists to prevent,
arriving through the cores instead of through the pool. **At the other end, MARK is zero for all
twelve and TEMPO reaches 1 on exactly one** (the Devout) — a MARK threshold is off for everyone at
run start and only the draft can move it, which is the shape the design wants.

**THE TABLE IS PRINTED, NOT TRANSCRIBED INTO A GATE.** What a rune may ask for is content and is the
designer's; what the gate owes is the measurement, re-taken on every run so the day a core kit moves
nobody has to remember this.

### §4c — WHERE THE COUNT IS COMPUTED AND HOW OFTEN

**ON DEMAND, UNCACHED, AND THAT IS THE RIGHT SHAPE TODAY.** The census is one dictionary lookup per
carried card — **7 to 10 of them** — and it has exactly **two callers, both screen draws**: the
loadout panel (`map_screen._open_loadout_panel`) and the hero sheet (`party_screen._draw_detail`).
They run once per open and once per swap. **There is nothing to invalidate, so there is no cache to
go stale**, which is the failure mode a cached count would add.

**WHEN A RUNE FINALLY READS IT IN A FIGHT, THE PLACE IS THE SPAWN AND NOT THE STRIKE LOOP.** The
loadout cannot change during a battle — benching is a map screen — so the count is a per-hero
constant for the whole fight and belongs on the unit beside every other rune field. **A per-hit
recount would be 84 multiplier terms' worth of work for a number that cannot move.** This is
recorded in `CLAUDE.md` so the batch that authors the first threshold rune does not have to derive
it.

### §4d — VISIBILITY, DRIVEN, AND THE NEAR-MISS THAT NEARLY MADE THE DRIVE VACUOUS

**A silent threshold is a stat nobody knows they have.** The census line is drawn on the **loadout
panel**, where the swap happens, and on the **hero sheet**, the one screen where a whole loadout is
read at once. `_toggle_loadout` re-opens the panel after every bench and carry, so the line is
rebuilt from the live loadout each time.

**IT IS DRIVEN IN TWO PLACES BECAUSE THIS IS DS's HEADS DOWN SHAPE.** A count that is correct in the
source and never recomputes passes every static check in the tree.

- **`check_es` §4 drives the ARITHMETIC through the real doors.** A tagged card off the hero's own
  draft pool is held, benched through `Run.unequip_earned_ability` and carried again through
  `Run.equip_earned_ability`; the census must move by **exactly the swapped card's own tags** and
  come back. It also asserts the benched card left the LOADOUT and stayed in the POOL.
- **`check_map_screen` drives the SCREEN**, which only a scene run can reach: the drawn Label's text
  must change across a real toggle.

**AND THE SECOND DRIVE NEARLY PASSED VACUOUSLY.** `queue_free()` is **deferred** — for the rest of
the frame the old overlay is still a child of the map and comes FIRST in the walk — so a finder
taking the first match compared a panel against itself and reported **`ES census moved on the swap:
false`** while the count was in fact moving. It skips a node queued for deletion now. **The reading
that caught it was the two lines being byte-identical, not a failing assertion**, which is why the
verdict prints both.

**THE POPULATION MOVES FROM THREE TO FOUR AND THE FOURTH IS `party_screen.gd`.** `check_ek` §3's
`TAG_DEFINERS` was two files defining the tables and one displaying them; it is now two defining and
**two displaying** — `map_screen.gd` (the draft card's line and the panel's census) and
`party_screen.gd` (the sheet's census). **The claim EK asserted is unchanged**: nothing reads a tag
for anything but display. The rule that a display surface may not BRANCH on a tag is **re-pointed
rather than loosened** — it used to forbid `map_screen.gd` naming anything but the line builder,
which was a proxy that a census makes wrong without making the property wrong. It is asserted
directly now, over `TAG_ORDER` itself: **a display surface may not name a tag WORD**, so an eighth
tag is covered by doing nothing. `TAG_SURFACE` grows by the five new names, because a sweep that did
not grow with them would report the population it was written for.

---

## §5 — A SPLASH PAYS FOR BREADTH

**The machinery is `Runes.breadth_met(loadout_names, need)` over `Classes.tag_breadth`. No splash is
authored.** A splash asks for cards spanning `need` or more DIFFERENT tags where a normal rune asks
for depth in one — the inverse shape, and the pick for a hero who is spread rather than deep.

### §5a — THE BRIEF'S COUNT IS OFF BY ONE: FIVE WERE RETIRED, SEVEN REMAIN

*A splash is derived as a spec rune with no `lane` field — the definition `test_runes._coverage` has
always used. Cross-checked name for name against EO §3's retirement table.*

| spec (id — display name) | splash | state |
|---|---|---|
| berserker — Berserker | Rune of the Broad Path | **LIVE** |
| swordmaster — Swordmaster | Rune of the Duelist | **LIVE** |
| warden — Warden | Rune of the Sentinel | **LIVE** |
| pyromancer — Pyromancer | Rune of the Long Burn | **LIVE** |
| cryomancer — Cryomancer | Rune of the Long Winter | retired (EO §3) |
| arcanist — Arcanist | Rune of the Wide Current | **LIVE** |
| holy — Holy Cleric | Rune of the Open Hand | retired (EO §3) |
| inquisitor — **Devout** | Rune of the Standing Vow | retired (EO §3) |
| occultist — Occultist | Rune of the Whispering Dark | retired (EO §3) |
| beastmaster — Beastmaster | Rune of the Shared Wild | **LIVE** |
| sharpshooter — Sharpshooter | Rune of the Level Aim | **LIVE** |
| mystic — **Survivalist** | Rune of the Long Hunt | retired (EO §3) |

**SEVEN LIVE, FIVE RETIRED — and they fell unevenly along class lines, which is the part worth
knowing.** **All three WARRIORS keep theirs. The whole CLERIC class has none** — Holy, the Devout
and the Occultist were all retired. The Mages and Hunters keep two of three each. So the class with
no splash at all is the one that would gain most from the category being given an identity, and the
class that keeps all three is the one that needs it least. **Nothing is authored here.**

---

## §6 — WHAT WAS DELIBERATELY NOT DONE

- **No rune authored, re-authored or retuned.** ER's three Beastmaster re-authors are untouched.
- **No pool expansion.** 65 authored, 12 retired, 53 offerable — unmoved.
- **No pricing rule invented.** §1d reports; the designer rules.
- **No class chosen for any of the five universals.** §2 reports; the designer rules.
- **The `scarred_runes` glossary entry was REWRITTEN, NOT DELETED**, so its `see_also` edge from the
  runes entry still resolves. It teaches what the mechanic is rather than what it used to be called.
- **`events.gd`'s relic-tier comment was NOT touched.** It reads *"tiering exists exactly so events
  can promise rarity"* and it is about **RELIC** tiers (17 common, 8 rare), which this batch does not
  reach. Naming it here because it looks like a missed site and is not.

---

## §7 — VERIFICATION

### The five negative controls, and all five bit

| # | control | armed on | armed reading | disarmed |
|---|---|---|---|---|
| **1** | the literal sweep, POSITIVE arm | `"bounded by how many distinct debuffs exist"` broken in `master.html` — a needle `test_batch_ba` demonstrably reads | **LOST 1**, naming the suite | LOST 0 |
| **2** | the literal sweep, DISCRIMINATION arm | `"Companions have HP, can be targeted by enemies"` broken — prose no target names | **LOST 0 — unmoved** | LOST 0 |
| **3** | the live suite, against the same needle | `test_batch_ba` standalone | **690 / 1**, naming the assertion | **690 / 0** |
| **4** | §4's swap drive — the loadout made to read the POOL | `Run.loadout_ability_names` | `check_es` **42 / 2** (*"a BENCHED card is still in the loadout list"*, *"moved the census by [], expected [RESOURCE +1]"*); `check_map_screen` **TAG MISMATCH** | 42 / 0, `OK` |
| **5** | §1's flatness — a zone quality ladder re-invented | `Runes.generate` reading the zone slot | `check_es` **42 / 2**, share **57.6 / 49.3 / 31.1**, spread 26.4 points | 42 / 0, share **29.9 / 29.6 / 30.3** |
| **6** | §3's cost recognition — `is_cost` made blind to a negative `speed` | `Runes.is_cost` | `check_es` **42 / 2** (*"anchor's COST (speed) was scaled — it became pure upside (-10.0 → -30.0)"*); `test_runes` **3118 / 6** | 42 / 0; 3118 / 0 |

**CONTROL 6 IS THE ONE THAT MATTERS AND IT PRINTS THE DEFECT IN §3's OWN WORDS.** With the flag
gone, `is_cost` is the only thing that knows a rune charges anything; the control makes it forget
one field and both instruments say so, one of them naming the rune that became pure upside.

**EVERY RESTORE WAS FROM A SCRATCHPAD COPY AND COMPARED BYTE-FOR-BYTE, NEVER BY `git checkout`.**
`scripts/runes.gd`, `scripts/run_state.gd` and `docs/master.html` all restored byte-identical.

### The literal-flip sweep

**11,356 distinct needles ≥ 4 characters from 92 targets, against every tracked document at
`HEAD` and in the working tree. SIX LOST, and every one is traced to its assertion rather than
waved through:**

| needle | document | why it left | is it asserted there? |
|---|---|---|---|
| `rarity` | `data/runes.json` | the key is removed | **YES, AS AN ABSENCE.** `check_es` §1 and `test_runes._schema` pin it absent — the removal IS the assertion |
| `scarred` | `data/runes.json` | the flag is removed | **YES, AS AN ABSENCE**, same two |
| `rarit` | `data/runes.json` | substring of the above | same |
| `SCARR` | `CLAUDE.md` | the standing rule's heading is relabelled | **NO.** It is `check_es`'s own fingerprint half (`"SCARR" + "ED_"`), swept over `.gd` files and never against this document |
| `scope` | `data/glossary.json` | the runes entry now says `SCOPE` in caps | **NO.** Fourteen targets carry the needle; all fourteen read it out of `runes.json` scope keys, and none asserts it against the glossary |
| `stats` | `data/glossary.json` | *"common runes are flat stats"* is gone with the tiers | **NO.** Only `check_dn` carries the needle and **`check_dn` does not read the glossary at all** |

**0 LOST in `docs/master.html`, `docs/changelog.html`, `docs/text-standard.html`,
`docs/design-notes.md` and `baselines.json`.**

### The retired-word pre-check, run before the battery

Reproducing `test_batch_bx` §4's and §4b's own strips against the EDITED files: **`beast` absent
from `master.html` after both casings of `beastmaster` are removed; `party` absent from
`master.html`, `glossary.json` and `runes.json` after the five `PARTY_IDENTS`; zero stray `party`
string literals across the thirteen `.gd` files §4b sweeps.**

### The pin manifest

**Run against `HEAD`'s manifest BEFORE regenerating**, which is what surfaced both findings rather
than burying them: a negative pin NOW PRESENT (`check_eh.gd → scripts/run_state.gd:
protected_names`) and an unrecorded pin (`check_ek.gd: "%s"`). The first is a real assertion that
had to move and did, with its reason; the second is the manifest needing a regeneration.
**Regenerated: 1350 → 1353 pins, 3 GAINED and 0 LOST**, and `check_ed` reads **18 / 0**.

### Baseline rows

**FOUR ROWS, ALL WRITTEN BEFORE THE BATTERY OFF THREE IDENTICAL STANDALONE READINGS EACH.**

| row | before | after | why |
|---|---|---|---|
| `test_runes` | [3101, 3101] | **[3118, 3118]** | +17, **counted off the diff**: `_schema` 472 → 585 (+113 — two absence pins and a no-prefix pin replace one tier check and one conditional price check, ×65 entries), `_scarred` → `_costs` 102 → 6 (−96, called twice) |
| `check_ek` | [43, 43] | **[45, 45]** | +2 — the display-surface rule is asserted directly over two files now instead of by proxy over one |
| `check_parse` | [161, 161] | **[162, 162]** | +1 — **its count IS its coverage**, so a target joining the battery raises it the same day. RESIDUE unchanged at 4 |
| `check_es` | — | **[42, 42]** | new |

**`check_de` HAS NO ROW OF ITS OWN**, so its own +4 for a new gate is reported by nothing; it is
predicted here at **358 → 362**.
