# Batch GP — The pools merge

*Branch `class-merge`, from `3197154` (GO). `main` is untouched. **IMPLEMENT ONLY.** The three spec pools and the
class-wide pool of a class become one pool, the class-wide cards become ordinary cards in it, and a card that reads an
engine is offered only to a hero who holds it. Two game scripts and the sim, one new gate, fourteen instruments
and the battery runner moved with the code, one standing rule, and the documents.*

## NEEDS A RULING

**Only what a player meets, or what blocks the ruled work, is here** (`docs/ways-of-working.md`). The rest is in
`docs/state.md`'s queue.

1. **THE CLASS-WIDE CARDS ARE NOW THE WORST CARDS IN EACH POOL, AND THAT IS A REBALANCE OWED** (§1b). EB §1 ruled the
   protected core is the baseline, and `classes.gd`'s own authoring rule says class-wide cards are **written weaker
   than spec cards** — deliberately, because they feed no passive and at equal power would be a safe default that
   diluted every build. **The merge removes the reason and keeps the cards**: six for the Warrior and the Hunter, five
   for the Mage, three for the Cleric. Accepted and not repaired here. GN's ruling 7 is the same item from the kit's
   side.
2. **THIRTY-FOUR CARDS BECOME UNREACHABLE TO A HERO WHO HOLDS NO ENGINE** (§2). Before the merge they were offered and
   did nothing; a Mage who drops Runaway Resonance now loses seven cards from his offers at once. That is the ruling
   working, and it is listed because a player feels it.
3. **THE GATE IS THE HOLDER'S AND THE CODE'S PRODUCERS ARE PARTY-LEVEL** (§2d). Five of the eight producers are
   party-level — `_living_hero_passive("permafrost")`, `_living_devout`, `_living_occultist`, the Mercy holder, the
   Focus holder. The party is one hero per class, so the two readings coincide today. **They part the day two heroes
   of one class can be seated**, and the gate would then be stricter than the code.

## THE SHORT VERSION

- **One pool a class, derived and not taken from the brief: Warrior 38, Mage 41, Cleric 34, Hunter 36 — 149 in all.**
  No card is in two shelves and no card was authored, retuned or deleted.
- **A hero drew from 13 to 18 before and draws from 34 to 41 now**; a hero who took a spine drew from **3 to 6** and
  draws the whole pool. **The brief's "~24 instead of 8–10" is wrong on both sides** (§0).
- **Thirty-four cards read an engine and are offered only to its holder.** The population was derived at the read site
  and driven both ways: every one of the 149 cast on a hero holding nothing, then each candidate cast again with the
  engine held.
- **What a hero holding NO engine can be offered: 35 of 38, 29 of 41, 22 of 34, 29 of 36** (§2e). The merge did not
  move the narrowness — the thinnest case is a Cleric at 22, against the 13 a Holy Cleric drew from and the **three** a
  Sanctity-taker drew from.
- **The class-wide tier is gone**: `CLASS_DRAFT_SHARE`, `Run.draft_card_is_class` and EH §1's third zone-boss tier are
  deleted, and the award chain is two tiers.
- **The offer rate did not move, and the HEAD control is why that is a finding** (§3c): 74% / 76% at cap after,
  against **73% / 74% on HEAD the same day**. EG's 53–55% is stale and GP is not what made it stale.
- **New gate `check_gp`, 389 checks**, with a six-card control. **Fourteen instruments moved with the code**, every
  one of them found by running the battery against the new tree — thirteen by the census, the fourteenth (`check_da`)
  by the pre-pass (§4).

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md`, `docs/state.md`, `docs/reports/GN.md`, `docs/reports/GO.md`,
`docs/kit-recon.html` and the code each premise names. **Eleven claims checked: nine held, two did not.**

| The brief says | Verdict | What the repo says |
|---|---|---|
| **"a hero draws from ~24 cards instead of 8–10"** | **DID NOT HOLD, on both sides** | A lineage hero drew from his lineage shelf plus his class shelf — **13 to 18**; a hero who took a spine from **3 to 6**. After the merge, **34 to 41**. The 8–10 is the CI-era spec shelf read alone, before DO/DR/DS/DY deepened them and without the class shelf beside it. |
| the class-wide pool existed **because spec pools were narrow** | **DID NOT HOLD as written** | `CLASS_DRAFT_POOLS`' own authoring header gives a different reason: a class-wide card is untied, general, weaker and unconditional — *"the pick you take when your spec's engine is not online yet, which is a real role and a different one."* The merge does remove that role; it is not the reason recorded. |
| GN found the Hunter pool was six not seven and the Cleric went six to three not seven to four | Held | `docs/reports/GN.md` §0. |
| my opening-slot figures were GL's projections, not measurements | Held | GN §3c: GL's fifteen were `lineage_slots + 3, no overlap`, and four of them are wrong after the dedupe. |
| EB ruled the protected core is the baseline and class cards were written deliberately weaker | Held | EB §1, and the `CLASS_DRAFT_POOLS` header. |
| CN found 137 abilities a field-level test misjudges | Held | `docs/reports/CN.md`. |
| GL found eight kit cards and about twenty earned cards half-work | Held, and outside this population | `docs/state.md`'s GM ruling 1. **None of the eight is a draft card.** |
| GM narrowed the ruling to the three that cannot be cast at all | Held, and outside this population | Death Ray, Resurrection, Kill Command — `Classes.ENGINE_BOUND`. **None of the three is a draft card.** |
| GL found Shadowrend, Hex of Ruin and Divine Shield each feed their engine and read nothing of it | Held, and outside this population | `docs/kit-recon.html` KR-CLERIC 2. All three are ENABLERS, which travel with the engine and are in no draft pool. |
| GK's census found 67 of 104 targets red, 42 throwing, 38 on `passive_id` alone | Held | `docs/reports/GK.md` §3. |
| EG measured 63% of offers arriving at a hero already at cap and brought it to 53–55% | Held as a record, **false as a current figure** | `docs/reports/EG.md`. Re-measured at §3c: **HEAD reads 73–74%** on the same day and policy, so the 53–55% went stale before this batch. |

## §1 — ONE POOL PER CLASS

### 1a. What was built

- **`Classes.draft_pool(class_key)` is THE pool**, and it is DERIVED — the three lineage shelves in `SPEC_IDS` order
  then the class-wide shelf — rather than being a fifth container to curate. `Run.draft_pool_left` and the zone-boss
  fallback are its only readers, and `check_gp` §1 asserts the draw names it and neither shelf accessor.
- **`SPEC_DRAFT_POOLS` and `CLASS_DRAFT_POOLS` keep their names, their contents and their authoring headers, and they
  are SHELVES now** — where a card was authored, not a channel it is drawn from. That is what kept the merge from
  orphaning every authoring rule in those blocks, and it is why `check_gp` §1 asserts the draw reads the pool: **a
  reader that takes `spec_draft_pool(his spec)` for "what this hero can be offered" is wrong and still passes.**
- **`draft_pool_left` returns an ARRAY where it returned `{"spec": [], "class": []}`.** The type change is deliberate:
  a caller still reading `["spec"]` breaks loudly instead of reading an empty side as an empty pool. It broke nine
  instruments, which is the census in §4.
- **The class-wide cards lost their tier.** `Classes.CLASS_DRAFT_SHARE` and `Run.draft_card_is_class` are deleted —
  one pool has no sides to weight — and so is EH §1's third zone-boss tier, `Run.roll_class_fallback_offer`.
  `roll_spec_fallback_offer` is renamed **`roll_draft_fallback_offer`** and reads the whole class pool: keyed through
  the SPEC it returned nothing at all for a hero who took a spine (`spec == ""` → `[]`), so the merge would otherwise
  have left the second tier silent for exactly the heroes GK created.
- **The boss pools are untouched.** `SPEC_POOLS` stays spec-keyed and `roll_spec_ability_offer` still reads it.

### 1b. The depths, derived

| class | the three lineage shelves | the class-wide shelf | **the pool** | a lineage hero drew | a spine-taker drew |
|---|---|---|---|---|---|
| Warrior | berserker 10 + warden 10 + swordmaster 12 | 6 | **38** | 16 / 16 / 18 | 6 |
| Mage | pyromancer 13 + cryomancer 11 + arcanist 12 | 5 | **41** | 18 / 16 / 17 | 5 |
| Cleric | holy 10 + inquisitor 11 + occultist 10 | 3 | **34** | 13 / 14 / 13 | 3 |
| Hunter | beastmaster 10 + sharpshooter 10 + mystic 10 | 6 | **36** | 16 / 16 / 16 | 6 |

**149 in all — 129 spec plus 20 class-wide, which is where GN left it — and no name is in two shelves** (`check_gp`
§0 derives all of it every battery and asserts the pool IS the shelves, in order).

**WHAT THE MERGE COSTS, RECORDED RATHER THAN DISCOVERED.** The class-wide cards were authored *"weaker than spec
abilities, and unconditional"* on purpose. In a merged pool that reason is gone and they are simply the worst cards in
it. **Accepted, not repaired, and a rebalance owed.** No card was authored, retuned or rebalanced at the merge.

## §2 — A CARD THAT READS AN ENGINE IS ONLY OFFERED TO A HERO WHO HOLDS IT

### 2a. How the population was derived

**Not from a field.** CN found 137 abilities a field-level test misjudges because they resolve inside a special
handler. The derivation was three passes, and the third found what the first two could not:

1. **The read sites, read.** Every `has_engine` call in `battle.gd` mapped to its enclosing function and split into
   the card's own resolution and the shared machinery around it; every status a draft card lands, checked for whether
   its read sites all sit inside an engine's block; every gate in `_ability_usable`, and what produces the board state
   it asks for.
2. **All 149 cast on a hero holding NO engine**, on a board dressed so that a no-op could only be the engine's fault:
   enemies at half health, burning, chilled and poisoned; allies at half health and afflicted; a companion standing
   for the Hunter. Sixteen were refused at the door, eleven resolved and said in the log that they did nothing, two
   were silent.
3. **Each candidate cast again with the engine held**, with the engine's own state built through the game's doors —
   `_hold_freeze` for Permafrost, `_gain_ruin` for the Old Gods, `_gain_faith` and `_grant_divine_shield` for
   Conviction, `Call the Wilds` and `_gain_loyalty` for Pack Bond, the meters `_spawn_units` installs for the rest.

### 2b. The table — 34 cards

| engine | cards | what the no-engine arm does |
|---|---|---|
| **Permafrost** (5) | Winter's Toll, Rimebinding, Cryoclasm, Shatter, Deep Winter | Four refused at the door; Deep Winter resolves — *"he holds nothing, so there is no prison to copy"*. `_holds` is filled only by `_hold_freeze`, and `_freeze_holds` refuses to fill it unless a Glacial Hold holder lives. |
| **Runaway Resonance** (7) | Arcane Bolt, Unmaking, Threshold, Null Field, Inner Arcane, Overcharge, Resonant Field | Two refused; five resolve and pay zero — *"he holds no Resonance to set"*, *"+0 Resonance (now 0)"*, *"damage taken falls 5% per Resonance stack (0 now: -0%)"*, *"he holds no Resonance, so there is nothing to share"*. |
| **Mercy** (5) | Divine Plea, Shared Grief, Divine Presence, Alms, Intercession | Divine Plea refused (`faith_cost` 2 against an absent bar); three say they hold no Mercy; **Shared Grief pays 30 health for it anyway**. Intercession is §2d. |
| **Conviction** (5) | Blessing of the Faithful, Aegis Reversal, Elevation, Mantle, Ordination | Two refused; three resolve — *"no Devout stands, so Faith pays nothing"*, *"Mantle finds nobody to lay it on"*, *"Ordination finds nobody to ordain"*. |
| **Wrath of the Old Gods** (2) | Transference, Requiem | Both refused: `_gain_ruin` returns at once with no Occultist standing, so no enemy carries a mark to move or consume. |
| **Pack Bond** (5) | Unleash, Bring It Down, Last Howl, Succession, Ghostpack | Unleash and Ghostpack refused; Bring It Down — *"no bond deep enough to call on, so the horn buys nothing"*. Last Howl and Succession are §2d. |
| **Lethal Aim** (2) | Quarry's Mark, Reacquire | Each lands a mark whose WHOLE payload is Focus, and both `_sharpshooter_focus` call sites sit inside `has_engine("lethal_aim")`. |
| **Heavy Plating** (2) | Anvil, Recompense | §2c. |
| **Blood Frenzy** (1) | Unslaked | §2c. |

**THE COMPANION IS NOT THE GATE; THE BOND IS.** Twin Hunt, Savage Sweep, Bloodbond and Call the Wilds all work at 0
Loyalty for a Hunter holding no engine — Call the Wilds summons with no Pack Bond, which is what makes them reachable.
Only what reads the BOND is gated.

### 2c. The three whose payout is a later strike, and why a board test cannot see them

Each lands its status and moves nothing else, with the engine and without, because what it buys is arithmetic on a blow
that has not happened yet. **They were found by reading the site and are driven as pairs of blows:**

| | without the engine | with it |
|---|---|---|
| **Unslaked** — a seeded Strike after a dive | 17 with the card, 17 without | **24 with the card, 20 without** |
| **Recompense** — Rage after a blocked blow | 0 | **24**, against 0 with the engine and no card |
| **Anvil** — the plating climb after a blocked blow | 24% (the block branch never runs) | **24%**, against **0%** with the engine and no card |

**Unslaked is the row a batch would most easily miss.** All it changes is `keep` inside `BattleUnit.frenzy_bonus()`,
so the floor ratchets either way; it is inert because **every caller of that function that uses its return sits inside
a `has_engine("bloodrage")` block, the nameplate chip included.** The first draft of its drive read 24 against 24 and
was wrong: `frenzy_bonus()` sums a health term and a RAGE term and clamps the sum, so a Warrior left holding 99999 Rage
stands at the cap on both arms and the floor is invisible under it.

### 2d. The three whose payout waits on an event

| | without the engine | with it |
|---|---|---|
| **Intercession** — the hero a lethal blow lands on | **FELL** | **stood** |
| **Last Howl / Succession** — a companion's Loyalty, which is all either reads | **0** | **5** |

Intercession's hook is stamped at `_spawn_units` only when a hero carries Mercy, and `_on_intercession_save` needs one
to pay — so the engine has to be held before the board is built, which is how the arm seats it. `_gain_loyalty` returns
at once without Pack Bond, so one drive settles both of the others.

### 2e. What a hero holding no engine can actually be offered

| class | the pool | offerable holding NO engine | the most two engines can reach |
|---|---|---|---|
| Warrior | 38 | **35** | 38 — Heavy Plating (2) and Blood Frenzy (1) are his only gating engines |
| Mage | 41 | **29** | 41 — Permafrost (5) and Runaway Resonance (7) |
| Cleric | 34 | **22** | **32** — Mercy (5), Conviction (5) and the Old Gods (2) are THREE, and `ENGINE_SLOTS` is 2 |
| Hunter | 36 | **29** | 36 — Pack Bond (5) and Lethal Aim (2) |

**THE CLERIC IS THE ONE CLASS NO HERO CAN REACH THE WHOLE POOL OF.** Three of his six engines gate cards and a hero
holds two, so his best pair opens 32 of 34 and the other two stay shut for that run. The other three classes have at
most two gating engines each, so a hero holding both is offered everything. That is a consequence of the ruling rather
than a decision anybody took, and it is recorded here for the batch that prices it.

**The merge did not move the narrowness.** The thinnest case is a Cleric holding nothing, at 22 — against the 13 a Holy
Cleric drew from before the merge and the **three** a Sanctity-taker drew from. `check_gp` §2b asserts every row of the
table is absent from a no-engine hero's offers and present the moment he holds the engine, in both directions, and
prints these four numbers.

### 2f. The control, and what it caught

The pair test would pass a table listing every card in the game if holding an engine changed every cast. **Six
engine-free cards are cast on the same two arms and must come back identical** — and the first control set did not:
**Chastise separated under Conviction**, rightly, because Faith raises the damage of every cast. That is the engine
reading the CARD, which is the thing §2 exists to tell apart from the card reading the engine. **A control card may not
be one the engine buffs in passing**, and the controls are six cards no engine beside them can touch.

## §3 — WHAT THE MERGE BREAKS

### 3a. The census, taken before a gate was edited

**The unmodified battery, run against the new tree: 113 targets, 16 moved.** Against GK's 67 of 104 this is small, and
the reason is structural — the shelves survived as shelves, so every depth, flatness and no-card-in-two-shelves
assertion in the battery went on reading exactly what it read before.

| target | what the merge did to it | why |
|---|---|---|
| `test_batch_ah` | 1 throw | calls `roll_spec_fallback_offer` |
| `test_batch_bo` | **parse error** | `draft_card_is_class`, `CLASS_DRAFT_SHARE` |
| `test_batch_bq` | **parse error** | the same two |
| `test_batch_bp` | 4 fails | *"every card is his own spec's or his CLASS's"* — the assertion the merge is |
| `test_batch_br` | 2 throws | the `Dictionary` shape, `draft_card_is_class` |
| `test_batch_bx` | 2 throws, 2 fails | `["spec"]`, and *"no hero was ever offered a card outside their own pools (1159 strays)"* |
| `check_ea` | 10 fails, 1 throw | §0's assertions on the chain's shape and order |
| `check_eb`, `check_et`, `check_fh`, `check_fn` | 1 throw each (`check_fn` 4) | `var pools: Dictionary = draft_pool_left(...)` |
| `check_eg` | 1 throw | `draft_pool_left(m)["spec"]` |
| `check_eh` | 4 throws | `roll_spec_fallback_offer` |
| `check_parse` | 2 fails | the two suites that would not parse |
| `check_de` | 34 fails | the differ, reporting all of the above |

**Two were already red and are unchanged:** `check_cm_live` 13 / 4, the standing sanctioned red; `check_gj` §4, GN's
sanctioned Tollkeeper's Bell red (the figures moved from +178/+198 to +177/+197 because GP's code moves what the
gate's seeded run draws — the same defect, one gold apart).

### 3b. Every reader of the two constants, swept

`SPEC_DRAFT_POOLS` / `CLASS_DRAFT_POOLS` and their two accessors are read by **50 files: 47 instruments and three
game scripts** (`battle.gd`'s debug grant, `classes.gd`, `run_state.gd`). **Thirty-six of the 47 instruments needed no
repair at all**, because they ask where a card was AUTHORED — pool depth, pool flatness, no card in two shelves, every
entry resolves — and the shelves answer that exactly as before. **Eleven needed repair**, and every one of them asked
what a HERO CAN DRAW, which is the question that moved. (Two more instruments were repaired that read neither
constant: `check_et` and `check_fn`, both through `draft_pool_left`.) **That split is the whole argument for keeping
the shelves**, and it is why the census reads 16 targets and not GK's 67.

### 3c. The offer logic, re-measured — WITH A HEAD CONTROL, AND THE CONTROL IS THE FINDING

Four `--run 25` sims at rung 2 (`DOD_SIM_DIFFICULTY=warden`), same policy line, same day; HEAD run from an out-of-repo
copy at `3197154`:

| | HEAD s1 | HEAD s2 | GP s1 | GP s2 |
|---|---|---|---|---|
| draft offers / run | 35.52 | 33.12 | 34.88 | 37.28 |
| cards shown | 105.84 | 98.92 | 104.64 | 111.84 |
| cost a bench | 26.44 | 24.08 | 25.88 | 28.28 |
| **at cap when offered** | **74%** | **73%** | **74%** | **76%** |
| short offers (pool under 3) / run | 0.40 | 0.24 | **0.00** | **0.00** |
| nothing left to offer / run | 0.08 | 0.04 | **0.00** | **0.00** |

- **THE MERGE MOVES THE AT-CAP RATE BY NOTHING** — 73–74% before, 74–76% after, inside the spread of two samples a
  side.
- **AND EG's 53–55% IS STALE, WHICH IS THE HALF WORTH KEEPING: IT IS NOT GP THAT MADE IT STALE.** HEAD reads 73–74%
  on the same day. The figure EG's whole batch rested on has drifted since EG for reasons that predate this branch —
  the class kits take three of seven slots from GN, so a hero reaches his cap far sooner. **A batch pricing work
  against 53–55% would be pricing it against a number the game stopped producing.**
- **WHAT THE MERGE DOES MOVE IS THE TWO SHORT-OFFER FIGURES, AND IT TAKES THEM TO ZERO.** A pool that came up short
  0.24–0.40 times a run, and had nothing left to offer 0.04–0.08 times a run, now never does either.

### 3d. What is left broken at the end

**Nothing is left unplayable.** The repaired battery is green but for the two standing sanctioned reds. What is left
UNDONE is listed in FOUND AND NOT FIXED below, and none of it is a card a player cannot use.

## §4 — INSTRUMENTS

### 4a. The new gate

**`check_gp.gd`, 389 checks** — §0 the pool derived off the shelves, §1 the draw, §2 the engine gate on both arms with
its control, §2b the gate at the offer door in both directions, §2c and §2d the six a board test cannot see, §3 the
zone-boss fallback, §4 two whole runs on the real screens, §5 the player's three files byte for byte.

**§4 IS THE MEASUREMENT THAT SAYS WHETHER THE MERGE WORKED**, and it is played rather than reasoned about: a whole run
on a party holding NO engine and a whole run on a party holding TWO apiece, drafting at every offer, 49 maps and 30
battles for the first, 36 for the second. **A run seats one hero of each class**, so the two runs are a full run per
class on both arms rather than eight runs. **The offers the engine-less party received, by name:**

- **Warrior (11):** Battle Poise, Battle Shout, Blood Debt, Blood Offering, Cleave, Covering Guard, Formless, Gut Rip,
  Rallying Shout, Rampage, Reckless Abandon
- **Mage (8):** Dispel, Ember Debt, Firestorm, Glacial Prison, Kindled Mind, Magi's Wrath, Mirror Image, Pyre Wake
- **Cleric (9):** Breaking Darkness, Bulwark of Fortitude, Chastise, Covenant of Ash, Exhortation, Fortified Spirit,
  Reprisal, Rite of Return, Second Wind
- **Hunter (12):** Arcane Arrows, Called Volley, Camouflage, Crossfire, Downwind, Fault Line, Heads Down, Loaded Shot,
  Snare Line, Stalking Horse, Thick Hide, Twin Hunt

**Forty cards, and not one of them reads an engine.** Each hero was shown cards from at least two of his three lineage
shelves, which is the merge itself. The two-engine party was shown 69 cards, **12 of them engine-readers** — the
positive arm, without which the gate would pass a door that refused everyone.

### 4b. The fourteen instruments moved, and what three of them found

Repaired to intent, every one of them found by running the battery against the new tree — thirteen by the census
(§3a), the fourteenth by the pre-pass (§4c): `test_batch_ah`, `bo`, `bp`, `bq`, `br`, `bx`; `check_da`, `check_ea`,
`check_eb`, `check_eg`, `check_eh`, `check_et`, `check_fh`, `check_fn`; and `run_battery.sh`.

**THREE OF THEM CAUGHT SOMETHING THE MERGE BROKE THAT THE MERGE'S OWN AUTHOR WOULD NOT HAVE LOOKED FOR** — the
third is `check_da` §3, in §4c below:

- **`check_eb` §2 caught `test_batch_bp`'s fillers.** §7 fills a Swordmaster's kit with cards that must be
  unreachable by his own draw; the merge made two of them — **Rallying Shout** (the Warden's shelf) and **Gut Rip**
  (the Berserker's) — reachable, which is DR's one-in-eight flake returning through the merge. **The durable property
  is "in NO draft pool anywhere", not "in another lineage's"**: both are replaced with War Stomp and Interpose,
  `SPEC_POOLS` boss-pick cards of the Warden that are in no draft pool at all.
- **`check_fn` §4's `SHORT_BAR` exception is EMPTY now, and GN's equality is what made it visible.** GN pinned
  `{"occultist": 2}` — the one spec whose pool could not stack five cards of one tag — *as an equality, so the day the
  pool deepens this gate says so*. The merge deepened it and the gate said so: the Occultist stacks a full five again,
  and the exception is emptied rather than re-pinned, because an equality against 5 for every spec is the stronger
  statement.

Three assertions were **INVERTED rather than deleted**, because what a later batch could get wrong is putting them
back: `test_batch_bp` §5 and `test_batch_bx` §2 asserted a hero is never offered a sibling lineage's card and now
assert he IS (with the CLASS boundary kept as the thing that must never break), and `test_batch_bo` / `bq` / `br`'s
one-in-four seam checks became "a class-wide card still reaches a hero, through the door the game asks".

## §5 — WHAT IS DELIBERATELY NOT DONE

- **No card is authored, retuned or rebalanced**, including the twenty class-wide cards that are now the weakest in
  each pool.
- **Boss pools are untouched**, and `check_gp` §0 asserts the shelves still return their own dict entries.
- **No engine, kit, rune, talent node or magnitude moves.**
- **THE CLERIC'S POOL-OF-THREE PROBLEM IS ANSWERED BY THIS BATCH, AND IT IS CONFIRMED.** A Cleric who took Sanctity
  drew his whole run from Chastise, Exhortation and Undying Vigil. He draws from **34** now, and **22 of them holding
  no engine at all** — driven, not derived: `check_gp` §4's engine-less Cleric was offered nine distinct cards across
  a whole run, from all three lineage shelves and the class-wide one. **His merged pool is not thin.**

## VERIFICATION

**THE ACCEPTANCE RUN IS GREEN.** 113 targets, `check_de` reading **473 checks / 0 failures / 0 notices** — so every
row this batch moved is recorded with its reason and no count drifted unrecorded. **The only two reds are the standing
sanctioned ones:** `check_cm_live` 13 / 4, unchanged since before GK, and `check_gj` §4's Tollkeeper's Bell, sanctioned
at GN.

**THE ORDER, AND WHERE IT HAD TO BE RESTARTED.**

1. **The four player saves backed up and verified by hash** before a line was written —
   `save-backups/GP-20260917-210002`, and read back byte for byte after the acceptance run.
2. **The unmodified battery against the new tree, before a gate was edited** (§3a): 16 targets moved, enumerated as a
   census and not as failures.
3. **The instruments repaired to intent**, then re-run one at a time until each was green.
4. **Every document written**, then the five document-reading gates pre-checked (`check_ec`, `check_ed`, `check_fr`,
   `check_ff`, `check_fg`) — all green — and the pin manifest regenerated: **1470 pins, and the before/after diff is
   pure line drift, 182 pins moved by line number with ZERO residency changes.**
5. **THE ACCEPTANCE BATTERY WAS STARTED THREE TIMES AND THE FIRST TWO ARE NOT THE ACCEPTANCE RUN.** The first was
   killed at 43 targets because `test_batch_cd` went red and the repair was an edit to `CLAUDE.md` — **an edit behind
   a running battery makes a mixed-tree reading**, and the run was restarted rather than patched. The second ran to
   the end as a PRE-PASS and found `check_da` §3's three, which are §4c below. Only the third, over a tree stamped by
   hash before it started and verified unchanged after, is the acceptance run.
6. **`ps` rows read after it, not a count**: no Godot and no battery running.

### 4c. What the pre-pass found, and it is `check_da` §3 doing exactly its job

- **`check_gp` trips the two-draft-pool fingerprint, and the two reads are its SUBJECT.** §0 asserts
  `Classes.draft_pool(cls)` IS the three lineage shelves plus the class-wide shelf, in order — **a gate asserting that
  relation cannot be written without naming both sides of it.** It enumerates one class's pool and never the corpus,
  and calls `ability_corpus()` nowhere, so it is not the defect the rule catches. An exemption with that reason.
- **AND THE SAME RULE CAUGHT `check_eh`'s EXEMPTION GOING STALE**, which is the half worth keeping. Its reason was
  *"drives the AWARD CHAIN's three tiers live — it reads both draft pools because the chain does"*; the merge made the
  chain two tiers reading one pool, so the gate stopped reading the class-wide accessor and the exemption stopped
  being needed. **An exemption whose reason has expired is a suppression waiting to hide the next real walk**, so it
  is DELETED rather than reworded.

## FOUND AND NOT FIXED

- **PLAYER-FACING, AND FP's `block_chance` FINDING ARRIVING AS A CARD: COVERING GUARD LENDS A 0% BLOCK TO A WARRIOR
  WHO IS NOT A WARDEN.** `_live_block_chance` is `block_chance + _plating_slice`, only the Warden declares 0.10, and
  the plating slice is Heavy Plating's — so a spine-taker who drafts Covering Guard covers an ally with nothing, and a
  Warden who dropped Heavy Plating covers with 10%. **It is NOT in the engine table**, because it reads a STAT and not
  an engine: gating on it would be a second mechanism, and `PROTECTED_CORES`' own header already records that *"the
  enabler concept has to cover STATS, not only abilities"*. The merge makes it reachable by three times as many heroes.
- **BATTLE POISE AND COUNTER TIME NEED THE DEFENSIVE GUARD AND A WARRIOR HAS NO ENGINE THAT GIVES HIM ONE.** Four
  cards in the same merged pool reach it — Formless satisfies both gates outright, Precision Strike, Feint and
  Wheeling Cut all flip the stance — so they are conditional on a CARD, not on an engine, and are not gated. **A
  Warrior who drafts Battle Poise and nothing that switches guard can never cast it.**
- **THE DEBUG "ALL SPEC ABILITIES UNLOCKED" TOGGLE STILL GRANTS A LINEAGE SHELF** (`battle.gd`'s `granted_pool`), not
  the class pool. Its scope was the spec and still is; outside the brief.
- **`check_gj` §4's SANCTIONED RED MOVED BY ONE GOLD** — card +177 against a purse of +197, where GN recorded
  +178/+198. GP's code moves what the gate's seeded run draws; the Tollkeeper's Bell defect is unchanged.
- **ONE CONTROL COPY LEFT A USER-DATA FOLDER** under Godot's `app_userdata`: "Dawn of Decay GP head". It was renamed
  before it ran so its `user://` could not reach the player's saves. It can be deleted.
