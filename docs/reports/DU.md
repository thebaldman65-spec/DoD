# BATCH DU — TWO TERMS A COMPANION SHOULD READ, AND A HOLE IN THE ONE AUTHORIZED WALK

*2026-08-29. Five items. **One magnitude moved and it was an enemy's**, one blind spot closed in
the enumeration every gate is built on, one open ruling closed by declining to change anything, and
one audit that changes nothing on purpose. No card was authored.*

---

## THE BRIEF'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because two of them changed the work.

1. **§4 said "re-run every criterion derived through the corpus … DP's rune-field sweep". IT IS NOT
   DERIVED THROUGH THE CORPUS.** `check_dp` §4 walks `data/runes.json` and greps the comment-stripped
   source of five `scripts/` files for a live read site. It calls `Classes.ability_corpus()` nowhere,
   and `check_dp` does not appear in the fifteen-gate list of consumers at all. **It did not move and
   it could not have.**
2. **§4 said the same of "DR's cooldown-zero census". IT IS NOT DERIVED THROUGH THE CORPUS EITHER.**
   `check_dr` §5's census loops `Classes.spec_draft_pool(spec)` and resolves each name through
   `Classes.draft_ability` — the draft pools directly. **That is deliberate and worth keeping**: a
   census that silently changed population would make every earlier reading of that printed line
   incomparable, which is why DU §5 audited the boss-pick pools separately instead of folding them
   in. Its comment now says so.
3. **§5 said `check_dr` §5 "walks `SPEC_DRAFT_POOLS` only". TRUE**, and it is the same line as (2).
4. **Everything else in the brief held exactly**, including all of DT's measurements, which were
   re-derived here rather than quoted: 30268 in every arm before the change, the frost bargain's
   single Chilled stack, the kindling bargain's `{"fire": 0.25}` on a companion, `dmg_bonus` at
   0.000, and `_hero_side()` holding the companion where `heroes` does not.

---

## §1 — PYROBLAST KEEPS COOLDOWN ZERO

**NOTHING WAS AUTHORED AND NO FILE UNDER `scripts/` WAS TOUCHED FOR THIS SECTION.** DT presented the
question with options; this is the ruling, and it is the option DT's own derivation supported.

**THE RULING:** *a repeatable draft card is a legitimate shape when it is priced elsewhere.*
It is in `CLAUDE.md` beside DR's engine/axis framework, **with its reasoning**, which is the half
that matters — without it the next batch reads Lunge and Pyroblast as an inconsistency and "fixes"
the wrong one.

| | Pyroblast | Lunge (DR's precedent) |
|---|---|---|
| cost | **45 — second-highest in the game** | 25 |
| delay | **6.0 — longest in the project, nothing above it** | 3.5 |
| cooldown | **0, and it stays 0** | 3 (was 0) |

**THE PROVENANCE IS IDENTICAL AND THE PREMISE IS NOT.** Both were talent grants DO moved wholesale
into `SPEC_DRAFT_POOLS`, both walked in carrying the cooldown a gated lane-end ability never needed.
DR's argument was *at the end of a talent lane the price was the node, and in a pool there is no
price* — and Lunge was **ordinary on both axes**, so that was literally true of it. Pyroblast is
three times `Ability.BASIC_DELAY` on tempo and second only to Death Ray on mana; **Death Ray costs
more and carries cooldown 3.** A full Pyromancer bar buys two casts with ten to spare.

**AND COOLDOWNS TICK IN THE UNIT'S OWN TURNS.** A 6.0-delay cast has already spent three basic
attacks' worth of tempo before a cooldown would begin counting down, so a cooldown of 3 would
roughly halve the frequency of a card whose whole identity is the one enormous slow blow.
**If one is ever taken anyway it is on the uniqueness argument and it is 2, not 3** — 3 would price
Pyroblast strictly above the strictly heavier card.

`check_dr` §5 keeps printing the live cooldown-zero draft list on every battery run, unchanged.
The finding's home in `docs/draft-audit.html` carries a **RESOLVED** banner naming both halves —
DR's Lunge and DU's Pyroblast — and stating why the same question got opposite answers.

---

## §2 — A CRIPPLED COMPANION BIT AT FULL STRENGTH

### WHAT IT WAS

`_choose_enemy_action` picks its target from `_hero_side()`, which holds the living companion.
`_apply_status` lands the rider on whatever was struck **with no companion filter**. And
`_companion_hit` never read the status. **Two enemy abilities carry Cripple** — derived from
`data/enemies.json` on every gate run rather than listed: the Wolfrider's **Ride-by Slash** and the
Grave Totem's **Grasping Roots**. In the hero strike loop Cripple is a flat `raw *= 0.75`.

So an enemy debuff attached, hung a chip, wrote a log line, and did nothing — **in the player's
favour.**

### THE MEASUREMENT, WHICH IS THE ONLY THING THAT SETTLES IT

Forty seeded blows down the companion damage path, both arms on the same seed so the variance roll
and the crit coin are identical and the status is the only difference. DK §4's method exactly.

| arm | 40 seeded blows | ratio |
|---|---|---|
| plain | 30268 | — |
| **crippled, BEFORE** | **30268** | **1.0000** |
| **crippled, AFTER** | **22703** | **0.7501** |

**30268 in both arms is DK's 34392-against-34392 repeating**, and it is why this is measured rather
than asserted from a read site: a gate that checked `battle.gd` *contains* a cripple read would have
passed on every one of the nine statuses DT drove onto a live companion at ratio 1.0000.

### WHY THIS WAS WIDENED WHERE DK REFUSED TO WIDEN

DK found Empower attaching to a companion and paying nothing and ruled the **card's text** narrow
rather than teaching the read, because widening a damage loop moves a balance number. That was
right. The line that separates the two cases is now in `CLAUDE.md`:

> **A player effect that lands and pays nothing costs the player a card.**
> **An ENEMY effect that lands and pays nothing costs the player nothing.**

The first is a dead card and narrowing the words fixes it honestly. The second is an exploit, and
narrowing the words would amount to writing down that the enemy's debuff is not supposed to work.

### AND THE LOOP IS NOT WIDENED GENERALLY

DT enumerated the attacker-side block at **84 multiplier terms**; `_companion_hit` read three.
**76 of the 78 genuinely absent terms are unreachable BY SHAPE, and the shape is in the signature**
— the function takes a float and not an `Ability` (26 ability-keyed terms), a companion's
`passive_id` is always `""` (10 more), and every talent-rank field on one is always zero (20 more).
All three premises are re-asserted live in `check_du` §0 rather than inherited from DT's report.
**A general widening would hang visible chips on a companion that change nothing, which is worse
than the narrow miss because it reads as working.**

---

## §3 — CHILLED, BOTH TERMS, AND THE HALF THAT IS UNREACHABLE

The HOARFROST battle modifier stamps a summoned companion deliberately (AQ §4 — a companion joining
a fight already under a bargain) and its branch carries no `inherited` guard, so a companion can
hold Chilled. The hero loop has **two** chilled terms and both are read now.

| arm | ratio | wanted | what it isolates |
|---|---|---|---|
| 1 stack, no node | **1.0000** | 1.0000 | the threshold arm must NOT fire below its floor |
| 3 stacks, no node | **0.8500** | 0.8500 | the threshold arm alone |
| 1 stack, node rank 3 | **0.9700** | 0.9700 | **the per-stack arm alone** — the threshold cannot fire here |
| 3 stacks, node rank 3 | **0.7735** | 0.7735 | **both at once** — the only arm that catches one of the two missing |

The node's rank is **read off `Talents.LANE_TREES` at run time**, not typed into the gate: writing 3
in both places would make the expectation agree with itself instead of with the game.

### WHAT A COMPANION CAN ACTUALLY REACH — AND THE STACK COUNT WAS NOT RAISED

**MEASURED: the frost bargain stamps exactly ONE stack, and one is the ceiling in play.** Every
other application of Chilled in `battle.gd` targets an enemy — the retaliation branch is gated `not
attacker.is_hero` and a companion is built `is_hero`, Frostbolt and Blizzard aim at enemies, and
both spread mechanisms (Frostbind's partner and Downwind) walk `enemies`. **So the threshold arm is
UNREACHABLE on this path today, and saying so is the finding.**

It is written anyway, and the reasons are two: the hero loop's two chilled terms are one rule, and
**half a rule here is the next thing to diverge**; and the gate can force three stacks on a fixture,
so the arm is measured rather than asserted. `check_du` §3 asserts the stamp lands **1** and prints
that the threshold arm is unreachable, so the day something changes the ceiling the gate says the
report is stale.

### TYPED RELIC DAMAGE IS STILL NOT READ, AND IT IS INERT TWICE OVER

The Tinderbox modifier really does write `{"fire": 0.25}` onto a summoned companion — measured. But
**a companion's blow carries no `dmg_type` at all**; `_companion_hit` resolves against
`resists["physical"]` outright. `check_du` §4 drives the stamped companion through forty blows and
requires the total **unchanged** — so the day a companion's blow grows a damage type, the gate says
the second reason is gone. `dmg_bonus` cannot reach a companion at all: measured at 0.000.

### THE GATE IS PART OF THE RULING

`check_du.gd` — **32 checks, 0 failures.** `check_dk` §4 and `check_dm` §2 already re-measure
`empower`, `wrath` and `battle_shout` every battery run, so those three rulings say when they go
stale. **Cripple and Chilled had no instrument in either direction**, which is why the day the read
was added there was nothing to notice it — and why removing it again would have been silent.

### FOUR NEGATIVE CONTROLS, ALL FOUR BIT, AND THEY BIT ON DIFFERENT ARMS

`scripts/battle.gd` and `scripts/classes.gd` were backed up to the scratchpad and restored by `cp`
after each, **never by `git checkout`**; both md5s were verified identical afterwards.

| control | what it did | result |
|---|---|---|
| 1 | deleted the `cripple` read | **1 failure — ratio back to 1.0000**, DK's defect exactly |
| 2 | deleted the chilled THRESHOLD arm | **2 failures** — the 3-stack arm and the both-terms arm |
| 3 | deleted the chilled PER-STACK arm | **2 failures** — the node arm and the both-terms arm |
| 4 | reverted the corpus walk (§4) | **5 failures in `check_du`, 2 in `check_cz`**, naming all four |

**Controls 2 and 3 failing DIFFERENT assertions is the point of running both**: it is what proves
each of the two chilled arms is separately load-bearing rather than one covering for the other.

---

## §4 — THE CORPUS WALK HAD A HOLE, AND FIFTEEN GATES INHERITED IT

### WHAT IT WAS

`apply_kit_overrides` replaces `abilities[0]` for each of the four mage specs at spawn —
**Shadowrend, Fireball, Frostbolt and Arcane Explosion**, all cost 0 and cooldown 0. **None of the
four sits in any pool and none is returned by `spec_abilities()`**, so `Classes.ability_corpus()`
read `kit("mage")` and got the unoverridden **Magic Bolt, which is nobody's live basic attack.**

Nothing was wrong at runtime. What was wrong is that **DA §3 makes this the one authorized walk**
and fingerprints anything hand-rolled, so every gate built on it inherited the blind spot.

**THE FIX IS `protected_names`'s OWN IDIOM, one function up**: build a cfg off the class kit, apply
the overrides, read what comes out. `kit()` returns fresh `Ability` objects on every call, so
replacing an element mutates nothing shared, and the eight specs that override nothing re-offer
names the walk has already deduplicated. **The corpus goes 223 → 227.**

### WHAT MOVED, RE-RUN THROUGH EVERY CRITERION DERIVED FROM IT

**Fifteen gates read `Classes.ability_corpus()`**: `check_cl_width`, `check_cm`, `check_cn`,
`check_co`, `check_cy`, `check_cz`, `check_da`, `check_di`, `check_dj`, `check_dk`, `check_dl`,
`check_dm`, `check_dn`, `check_do`, `check_dr`. All fifteen were run before and after.

| criterion | before | after | what it means |
|---|---|---|---|
| **CN — the timing-bar population** | 223 abilities, **121 run no bar** | 227, **121** | all four attack, so all four correctly run a bar. **The criterion already answered them right; only the printed population was short** |
| **CO — the refusal population** | 321 / 0 | **321 / 0** | none of the four is in `RECAST_GATED`, and correctly: a basic attack is never a wasted recast |
| **CY — the delay-cap population** | 2857 / 0 | **2857 / 0** | none is a pure buff or a shield, so the cap's two tables do not reach them |
| **DR — the cooldown-zero census** | 79 / 0 | **79 / 0** | **it never read the corpus** — see the brief-claims section above |
| **DP — the rune-field sweep** | 43 / 0 | **43 / 0** | **it never read the corpus either** |
| **CZ — the two-walk agreement** | 133 / 0 | **134 / 0** | the one real movement; see below |
| di, dj, dk, dl, dm, do, da, cm, dn | — | **unmoved, 0 failures** | their loops filter to populations the four are not in |

**THE HONEST SUMMARY IS THAT ALMOST NOTHING MOVED, AND THAT IS THE RESULT RATHER THAN AN
ANTICLIMAX.** The four are free basic attacks; every criterion that could have had an opinion about
them already had the right one. **The value is that the sweeps can now be believed** — and that the
one thing which did surface had never been reachable at all.

### THE ONE THING THE FIX MADE VISIBLE

`check_cl_width` reports no check count and no failure count, so **its movement is invisible to the
differ** and is recorded here because nothing else can record it.

| field | before | after |
|---|---|---|
| description | 4300 rendered lines · 8 over · 8 authored-over | **4348 · 8 · 8** |
| perfect_text | 380 rendered lines · 52 over · 44 authored-over | **392 · 56 · 48** |

**All twelve new description lines are inside the 44-character ceiling. One `perfect_text` is not:
Shadowrend's renders at 45 with the "Perfect: " label every surface supplies** — one character
over. It is **pre-existing**, it joins a standing population of authored overruns the gate already
reports, and it is **reported rather than fixed**: §4's instruction was to report what moves and
rule on nothing.

### `check_cz` §0 — THE EQUALITY BECAME A SET IDENTITY, NOT A LOOSENING

`_cl_only_corpus` is the Batch CL walk kept as §0's negative control, and it reads the class kit
**unoverridden** — so it structurally cannot reach the four. The assertion `cl.size() ==
corpus.size()` went red at 223 vs 227, correctly.

**A bare `!=` would have said nothing about WHICH four, and a hard `+ 4` would rot the day a fifth
override is authored.** So the difference is **derived off `apply_kit_overrides` itself** and
asserted as a set: the names in the complete walk and not in the CL walk must be exactly the
overridden basics. **The control's job is intact** — an ability falling outside every kit and pool
would be in neither walk, so it cannot hide inside the difference. `check_cz` goes 133 → **134**.

`check_da`'s exemption reason for `check_cz` was corrected for the same reason DO corrected it once
already: it said *"since DO it asserts the two walks agree"*, which stopped being true here. **The
exemption itself is untouched** — the reason it exists is the direct pool reads, and those have not
moved. `check_da` reads 37/0.

### THE RECORDED FIGURE, CORRECTED IN THREE PLACES

*"All twelve cooldown-zero abilities in the protected cores are the free basic attack"* is **twelve
INSTANCES across twelve specs and only SEVEN distinct names** — Strike ×3, Quick Shot ×3, Smite ×2,
and the four overrides. **The claim is true either way; the number was the misleading half**, and
the reason the seven were hard to count is exactly the hole above. Corrected in `classes.gd`, in
`check_dr`'s comment and in `docs/draft-audit.html`. **`check_du` §5 now derives both numbers on
every run and asserts they disagree**, so the correction cannot be un-learned by a batch that
re-reads the old sentence. The changelog and the DQ/DR/DT reports keep it as written — they are the
record of what each batch believed (CA's rule).

---

## §5 — THE BOSS-PICK POOLS, AUDITED AND RULED ON NOWHERE

**REPORT ONLY. NOTHING WAS CHANGED, NO RULING WAS TAKEN, AND THAT INCLUDES THE TWO COOLDOWNS THE
BRIEF NAMED.** DQ's value was that it changed nothing and DR then ruled on what it found; this is
the same sequence one channel over. **It lives in this report rather than in a new HTML audit**
deliberately — `docs/state.md` already records that `talent-audit.html` and `draft-audit.html`
cannot leave the knowledge sync because their findings are open, and a third permanent audit
document is a cost this section does not need to incur to hold four tables.

### WHAT THE CHANNEL ACTUALLY IS

A **zone boss** awards one ability pick to every hero, from that hero's `SPEC_POOLS` entry alone.
There are **three zone bosses** (the end boss awards none — nothing follows it), so a hero sees **up
to three picks in a run**. `roll_spec_ability_offer` filters names the hero already owns and offers
`slice(0, 3)` of what is left; `award_ability_pick` returns false when nothing remains, and that
hero is **silently skipped** — they do not even appear on the victory card.

**`SPEC_POOLS` IS 42 ENTRIES ACROSS TWELVE SPECS, 40 DISTINCT NAMES.**

### FINDING 1 — `CLASS_POOLS` IS DEAD, AND IT IS THE BIGGEST THING IN THIS SECTION

Batch AN §4 re-pointed the award at the spec pool alone. `run_state.gd`'s own comment says it
plainly: *"nothing in the run reads them any more, so re-opening the class draw is a one-line
change if the designer wants it back."*

**`CLASS_POOLS` holds 61 entries across four classes — every one of them authored, resolving, and
unreachable by any run.** It is not a defect (the abilities are all reachable by other channels or
are deliberately parked), and it is not on any list. **It is the single largest population in the
project that no run can touch**, and the audit's job is to say so.

### FINDING 2 — THE DEPTHS ARE THE DRAFT'S SHAPE INVERTED, AND TWO POOLS CAN EMPTY

Both channels write the same `bm_abilities` list, so **a drafted card removes itself from the boss
offer** and vice versa.

| spec | pool | also in his own draft pool | boss-only | picks that can land | picks that roll EMPTY |
|---|---|---|---|---|---|
| **holy** | **1** | **1** | **0** | **0–1 of 3** | **2, or 3 if he drafted it** |
| **inquisitor** | **2** | **2** | **0** | **0–2 of 3** | **1, up to 3** |
| berserker | 3 | 2 | 1 | 1–3 | up to 2 |
| pyromancer | 3 | 2 | 1 | 1–3 | up to 2 |
| cryomancer | 3 | 2 | 1 | 1–3 | up to 2 |
| occultist | 3 | 2 | 1 | 1–3 | up to 2 |
| warden | 4 | 1 | 3 | 3 | 0 |
| swordmaster | 4 | 2 | 2 | 2–3 | up to 1 |
| arcanist | 4 | 2 | 2 | 2–3 | up to 1 |
| **beastmaster** | **5** | **0** | **5** | **3 of 3, always** | **0** |
| **sharpshooter** | **5** | **0** | **5** | **3 of 3, always** | **0** |
| **mystic** | **5** | **0** | **5** | **3 of 3, always** | **0** |

**THE HOLY CLERIC'S ENTIRE BOSS-PICK POOL IS ONE CARD, AND THAT CARD IS ALSO IN HIS DRAFT POOL.**
Two of his three zone-boss awards always roll empty; if he ever drafted Divine Plea, all three do,
and the reward the other eleven specs get three of he gets none of.

**AND THE SHAPE IS THE EXACT INVERSE OF THE DRAFT'S.** DS deepened the three Hunter pools because
they were **the shallowest in the game**; in this channel those same three specs hold the **deepest**
pools, with **no overlap at all**, and the two Cleric specs are the shallowest. **Nobody has ever
looked at the two channels together**, which is the structural half of this finding.

### FINDING 3 — DUPLICATION, AND THE ONE CROSS-SPEC REPEAT

**26 of the 42 entries are boss-only; 16 are also in the same spec's draft pool.** The only name in
more than one spec pool is **Ashes of Al'ar** (pyromancer, cryomancer, arcanist — and
`CLASS_POOLS["mage"]`), which is coherent: it is a Mage-wide death-save rather than a spec piece.

### FINDING 4 — AXIS COVERAGE

Derived from the DATA (`damage`, `pressure`, `heal`, `aoe`/`random_hits`/`multi_hits`, the
`special`, `applies_status`) and never from the card text — DS §1's rule.

- **The Beastmaster's five deal no damage and no Break at all.** Every one is a `special`: Bestial
  Wrath, Spirit Bond, Primal Surge, Call of the Wild, Mark of the Hunt. **It is the only pool in
  the game with no damaging card**, and it is coherent with the spec (the companion is the damage)
  rather than obviously wrong — which is why it is reported and not ruled on.
- **The two Cleric pools carry no damage either**, but at depths 1 and 2 that is the depth finding
  again rather than an axis one.
- **The Sharpshooter's five are four damaging cards and one buff**, the narrowest axis spread of
  any pool with real depth. **It is not a domination** — see below.
- **The Warden's four are one damaging card and three defensive `special`s**, which is the widest
  spread relative to depth.

### FINDING 5 — NO DOMINATION, AND THE NEAREST MISS IS INSTRUCTIVE

**Called Shot and Coup de Grâce are the closest pair in any boss pool** — same cost (25), same
damage (25%), same Break (10). On the raw numbers **Called Shot strictly dominates**: cooldown 3
against 4, delay 3.0 against 3.5.

**It does not dominate, and only the read site says so.** Coup de Grâce *consumes all Focus* and
adds 1% of the target's missing health per point spent, reading up to 200 — an uncapped meter cashed
into one blow. Called Shot buys a three-way choice (Sunder 35%, 30 BD, or Exposed 3 turns). **The
worse base numbers are the price of the conditional**, which is DQ's own discipline: an audit that
scored the two by their fields would have reported a domination that is not there.

### FINDING 6 — THE TWO COOLDOWN-ZERO CARDS ARE NOT THE SAME CASE

The brief named both as one finding. **They are two different findings and neither is ruled on.**

- **ASHES OF AL'AR RATE-LIMITS ITSELF.** `unit.gd`'s guard sets `ashes_used` when the phoenix
  fires, and it is `false` only once a battle. **Its card text says "Once per battle" and the code
  makes that true**, so cooldown 0 costs nothing: a second cast can never buy a second life.
- **SWEEPING STRIKES DOES NOT.** 20 Rage a cast, cooldown 0, and it **builds 10 Rage** — a net 10
  Rage a turn for two swings at 15% of Attack, 12 Break, and a **3-turn Daze that a repeatable card
  keeps permanently refreshed**. It is the boss-pick channel's Pyroblast question, and the answer
  DU §1 gave for Pyroblast does not obviously transfer: 20 of a 100 bar at 3.0 delay is **ordinary
  on both axes**, which is Lunge's profile and not Pyroblast's.

### FINDING 7 — A CO-SHAPED DEFECT NOBODY HAD LOOKED FOR

**`ashes` is not in `RECAST_GATED`**, and `_resolve_special` writes `attacker.ashes_return =
ASHES_RETURN_PERFECT` unconditionally. So a hero who has already armed it can recast it — **30 Mana
and a turn, writing the same constant, changing nothing** — and at cooldown 0 they can do it every
turn. There is no bespoke gate in `_ability_usable` either.

**THE AUTOPLAY HEURISTIC ALREADY KNOWS NOT TO.** `battle.gd`'s bot picker requires
`u.ashes_return <= 0 and not u.ashes_used` before offering it. **The bot has the refusal and the
player's door does not**, which is precisely CO's criterion sitting in the wrong place.

**AND `check_co` COULD NOT HAVE FOUND IT.** It saturates and re-casts the **members** of
`RECAST_GATED` — 64 of them, 63 refusing. **It measures the list, not the candidates for it**, so a
card that should be in the list and is not is invisible to it in both directions. That is a
structural observation about the gate rather than a defect in it, and it is the second thing this
section found that the brief did not ask for.

---

## §6 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`,
`docs/draft-audit.html` and this report all landed **before** the run started, because roughly
thirty-five suites assert on the first three. Only `docs/state.md`, `baselines.json` and this
section's numbers were written after; **no suite reads any of the three**, and `check_de` is
re-runnable over an existing log directory, which is what that design is for.

### ONE RETIRED WORD WAS REINTRODUCED AND CAUGHT BEFORE THE BATTERY, NOT BY IT

The new `master.html` paragraph called Hunter's Mark **"party-wide"**. *"Party"* is retired from
player-facing text (DL §2) and `test_batch_bx` §4b sweeps `master.html` for it. **This is exactly
what `docs/state.md` warns about** — a batch writing companion prose is the batch that reintroduces
a retired word. It reads "the ownerless Hunter's Mark" now, which is the phrase the card's own row
already used, and `bx` reads **157 / 0**.

### THE PARSE CHECK

Grepped from **stderr** for `Parse Error` after every edit, never from the tally and never from the
exit code — a `--script` target whose base class does not resolve prints `Parse Error`, runs not one
line, and **exits 0**.

### THE LITERAL SWEEP

**10,547 literals at a floor of 4**, from all 80 suites, gates and fixtures, counted against 37
documents and sources and diffed against `git show HEAD` in one pass.

- **0 LOST in any document a suite asserts on.** Every loss was in `docs/state.md`, which is
  rewritten every batch and which **no suite reads** — verified rather than assumed.
- **17 GAINED in asserted documents, and the dangerous kind is zero.** Three are in `CLAUDE.md` and
  are `check_du` §6's own new needles. The other fourteen were cross-referenced against every
  `contains` / `find` / `count` call in the tree: **no match.** They sit in `changelog.html`,
  `design-notes.md` and `draft-audit.html`, and the only assertions any suite makes against those
  files are the archive-path anchor and a batch heading.
- **`docs/master.html` — the most-asserted document in the project — gained and lost nothing.**

### THE COMMENT-STRIPPED DIFF

Taken against `HEAD`, with every line-leading `#` stripped from both sides.

| file | code lines | what they are |
|---|---|---|
| `scripts/battle.gd` | **+7** | the cripple read and the two chilled arms, and nothing else |
| `scripts/classes.gd` | **+6** | the corpus fix |
| `check_cz.gd` | **+25** | the set identity replacing the equality |
| `check_da.gd` | **0**, one line changed | the exemption reason |
| `check_dr.gd` | **0, and zero lines changed** | **the proof its edit really was comments-only** |
| `run_battery.sh` | **0**, one line changed | `check_du` added to `GATES` |

**Nothing was swallowed.**

### PREDICTED BASELINE MOVEMENT — AND BOTH PREDICTIONS WERE EXACT

| row | from | to | measured |
|---|---|---|---|
| `check_cz` | 133 | **134** | **134 / 0** |
| `check_du` | — | **NEW: 32 / 0** | **32 / 0** |
| `check_de` | 309 | **313** | **313 / 0 failures / 0 NOTICES** |
| everything else | | **unmoved** | **unmoved** |

**THE PREDICTION WAS CHEAP BECAUSE THE FIFTEEN CORPUS-READING GATES WERE EACH RUN BEFORE AND AFTER
THE CHANGE, ONE AT A TIME, BEFORE THE BATTERY STARTED.** That is the method that would have caught
DS's unpredicted `check_cy` movement as well.

**AND THE ROW WENT IN BEFORE THE RUN, SO `check_de` CERTIFIED ON ITS FIRST PASS.** DT and DS each
took a necessary first-pass failure — a target that ran with no baseline row is UNWATCHED — because
they added the row afterwards. The count for a new gate is knowable from a standalone run, so there
is no reason to spend a differ pass discovering it.

### THE ACCEPTANCE BATTERY — ONE RUN, AND IT CERTIFIED CLEAN

**46 suites, 24 gates, 3 harness gates, 2 scene runs, and the differ. ZERO unexpected failures and
ZERO throws.**

- **Every one of the 46 suites read 0 failures and 0 throws.** `test_batch_at` **467**,
  `test_batch_bo` **1106**, `test_rune_battle` **97**, `test_batch_bx` **157** — none moved.
- **The only red is `check_cm_live`'s 4**, which is red on purpose and recorded as owed in the gate
  itself.
- **`check_du` read 32 / 0 in the battery, matching its standalone run exactly**, and printed the
  same five ratios: 0.7501 for Cripple, then 1.0000 / 0.8500 / 0.9700 / 0.7735.
- **`check_cz` read 134 / 0** and printed *"the Batch CL walk reaches 223; the complete walk reaches
  227 … the complete walk reaches 4 the CL walk cannot: Arcane Explosion, Fireball, Frostbolt,
  Shadowrend."*
- **`check_dr` printed "cooldown-zero draft cards remaining: 1 — Pyroblast (pyromancer)"**, which is
  §1's ruling standing in the census it was ruled out of.
- **`check_da` read 37 / 0** — its baseline — confirming `check_du` needed no §3 exemption.
- **76 targets ran and the manifest names all 76. 0 `Parse Error` and 0 `SCRIPT ERROR` in every
  log**, grepped from the stream. `check_map_screen: OK`; the harness reads 22 / 165 / 8.

**THE TREE WAS FROZEN FOR THE DURATION.** **165 files were MD5-stamped before the run and
re-compared after: NOT ONE MOVED.** Only `docs/state.md`, this section of this report and
`baselines.json`'s post-run confirmation were written afterwards, and no suite reads any of them.

---

## §7 — DOCUMENTATION AND THE PUSH

- **`CLAUDE.md`** — two sub-blocks beside DR's engine/axis framework: DU §1's ruling *with its
  reasoning*, and DU §2's player-card/enemy-debuff distinction. **No new top-level section**: the
  file is still over CW's 3% target and DG through DT have all declined the prune, so a rule that
  belongs beside an existing one goes beside it.
- **`docs/master.html`** — the stamp, and **two real changes** because DU moves a magnitude: a new
  bullet stating what a companion's blows read and what they cannot, and the Cripple row saying a
  companion pays it.
- **`docs/changelog.html`** — the DU entry. **IT CROSSES THE 400 KiB THRESHOLD**: 395.4 → **406.0
  KiB**, exactly as `docs/state.md` predicted five batches running. The cut point CX used was CN/CO;
  **cutting again is a repo-structure decision and is not this batch's.**
- **`docs/design-notes.md`** — two *why* entries: the dead-player-card / dead-enemy-debuff line, and
  the cost of a blind spot in a shared enumeration.
- **`docs/draft-audit.html`** — a **RESOLVED** banner on the cooldown-zero finding naming both
  halves, and the "twelve" count corrected in place. **The stale axis tables were left marked and
  not refreshed**, as DT left them.
- **`docs/state.md`** — rewritten.
- **`baselines.json`** — re-dumped at `indent=1`.
