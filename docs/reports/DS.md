# BATCH DS — THE HUNTER CLASS GAP

*2026-08-29. Acceptance battery: 74 targets, 0 suite failures, 0 throws, 0 `Parse Error`,
`check_de` 305 / 0 / 0 — exactly the prediction. 161 files MD5-stamped before the run and
re-compared after; not one moved.*

---

## §0 — WHAT THE BRIEF GOT RIGHT, DERIVED RATHER THAN QUOTED

Every figure below was re-derived from `classes.gd` and `talents.gd`, not taken from the brief
or from `docs/draft-audit.html`.

- **The three Hunter pools held 8 apiece and were the three shallowest in the game.** Next
  shallowest was the Warden's 9. Confirmed by summing `SPEC_DRAFT_POOLS`.
- **None carried a `BATCH DO` marker** — they received none of DO's twenty-two, because their
  trees granted nothing to move.
- **Not one of the twenty-four spec cards was a heal, a shield or hero-side mitigation.** Read
  all twenty-four. Bloodbond is the closest and it points the other way.
- **The Sharpshooter has no defensive node in his 27.** His three lanes are Precision,
  Penetration and Tempo — all offensive.
- **8 → 10 matches the Cleric class**: holy 10, inquisitor 10, occultist 10.
- **The per-spec axis figures reproduce**: Beastmaster 5 of 8, Sharpshooter 5 of 8 with four
  single-target strikes, Survivalist 7 of 8.

## §1 — FOUR CLAIMS THAT DID NOT SURVIVE, AND THREE CHANGED THE WORK

### 1. "The Hunter class has no Break generation anywhere" — FALSE, AND IT KILLED A CARD

`pressure` **is** Break (`battle.gd`'s pressure block is named as the one place Break is applied).
**Twelve of the thirty Hunter draft cards generate it:**

| pool | Break generators |
|---|---|
| Beastmaster | Twin Hunt (12), **Unleash (12, and its text names Break)** |
| Sharpshooter | Called Volley 8, Crossfire 10, Calibrating Shot 8, Trophy Shot 12, Drumfire 6×3, **Fault Line — whose entire payload is 20 Break an attack** |
| Survivalist | Loaded Shot 8, Hunt 10, Snare Line ("teeth, Break and all") |
| class-wide | Aimed Volley 8×3 |

"Break through the beast" would have been a **second copy of Unleash's own clause on the same
pool** — the BD §4 fault — and roughly the class's thirteenth Break source. **AMP-TEAM was
authored instead**, an axis genuinely absent from all twenty-four.

**Why it was invisible: the field is not called what the mechanic is called.** A card carries
Break without its description using the word. A careful reading of all thirty *descriptions* —
which is what a brief is written from — returns the wrong answer confidently.

### 2. "The Survivalist is the second-healthiest pool in the game" — IT IS THIRD

By decisions-per-card: Warden 9 of 9, Occultist 9 of 10, **Survivalist 7 of 8**. DQ's own report
names the Warden as the healthiest. Does not change the work — §2's "do not touch it" stands
either way — but the figure should not be re-quoted.

### 3. "Any status a new card applies must be in `DEBUFF_IDS`" — OVER-BROAD, AND FOLLOWING IT WOULD HAVE BROKEN FIVE CARDS

That rule governs **enemy-side afflictions**. Five of the six new statuses sit on a HERO, and
`DEBUFF_IDS` membership is what keeps a status *out* of the derived `_dispellable_buffs` set —
listing a hero-side buff puts the party's own work inside the cleansable set for a mender's
Cleansing Rite. `unit.gd`'s own list names five existing deliberate absences for exactly this
reason (`emberkeep`, `resonant_field`, `threshold_lock`, `anointed`, `fortified`).
**Only `heads_down` was listed** — and being listed is what makes it feed a Survivalist's
Trapper breadth, which is the shared-axis rule working.

### 4. "`test_batch_bp` §7's shape against the new pools" — THAT FLOW CANNOT REACH THIS BATCH

§7 is a **Warrior/Swordmaster** flow drawing from Warrior pools. Growing the Hunter pools cannot
touch it. The whole tree was swept for the same shape and **no Hunter-side collision exists**.
The durable rule is about **order, not filler choice**: `bp` §7 stuffed `bm_abilities` *after*
`award_draft_pick` had already rolled, and `draft_pool_left` filters owned names — so the fix that
matters is building the kit *before* the roll. `test_batch_bx` §2 and `check_map_screen` already
do that and are safe; `test_batch_bo` §2's Sharpshooter block uses boss-pick names and is safe.

## §2 — THE SIX

Two per spec, each reading its own engine. Four carry a `special`; **HEADS DOWN does not**, because
it is an ordinary attack with a status rider and needs the crit, armour read, parry roll and Break
that `_resolve_special` would have thrown away — Crossfire's shape exactly.

| card | spec | axis | what it does |
|---|---|---|---|
| **Bear the Brunt** | Beastmaster | MIT-SELF | the next blow that would fell HIM is refused; his deepest bond takes all of it, and it can kill the beast. Battle-long, waits until it fires. |
| **Bring It Down** | Beastmaster | AMP-TEAM | 4 turns, every hero +2% damage per Loyalty stack on his deepest bond, cap +20%, snapshot at cast, bond not spent. |
| **Dug In** | Sharpshooter | MIT-SELF | 4 turns, damage taken cut by a quarter of whatever Focus stands **at the blow**, cap 25%. |
| **Heads Down** | Sharpshooter | CTRL | 20 dmg / 8 BD, and 3 turns (Perfect: 4) in which that enemy can bring nothing but its basic attack to bear. |
| **Thick Hide** | Survivalist | MIT-SELF | 4 turns, 6% less damage per DIFFERENT affliction on **whoever is striking him**, cap 30%. |
| **Salve** | Survivalist | HEAL | 3 turns (Perfect: 4), heals 2% max health a turn per DIFFERENT affliction on the enemies, cap 10%. Nothing consumed. |

**BEAR THE BRUNT IS BLOODBOND INVERTED, CLAUSE FOR CLAUSE** — same placed-guard shape, same
battle-long duration, same "waits until it is needed", same "and it can kill the payer", opposite
direction. The pair is meant to read as opposites on the draft screen.

**SALVE IS HARVEST'S INVERSE.** Harvest burns the whole board for one burst and strips his own
Trapper bonus doing it; this drinks and leaves every affliction standing, so Vulture, Hunt and Cull
keep paying. **The heal counts the UNION across the field, not the sum** — so Downwind copying a
poison onto a second body does not pay him twice for the same poison.

**HEADS DOWN IS THE FIRST SILENCE IN THE PROJECT.** Nothing else in the game stops an ability being
used. It is written as a **downgrade rather than a lost turn**, which is what keeps it from being a
fourth Stun beside Bola, Deadfall and Pommel Strike — and is why it needs no boss carve-out.
**The refusal is ONE CONDITION in `_intent_ability_usable` and NOTHING in `_choose_enemy_action`**:
BL §1's header states that a diff touching the selection policy is a diff that broke the promise,
so the enemy still chooses freely a turn ahead and the downgrade lands at re-validation, where the
shipped fallback log and the `intent_fallback` counter already say what happened.

## §3 — THE SHARPSHOOTER RE-AUTHOR WAS MEASURED AND DECLINED

Compared **at the read site**, as instructed, rather than by target shape:

| card | hook | what it actually does |
|---|---|---|
| Crossfire | post-hit rider + `_crossfire_splash` | grants a 3-turn self status; crits then rake 2 more enemies. **Reads no Focus at all.** |
| Calibrating Shot | pre-loop snapshot → Focus block | **gains** Focus = 10% of the target's missing health |
| Trophy Shot | inside `_sharpshooter_focus`'s `victim.dead` branch | **keeps** Focus through a kill — a decay-RULE change |
| Drumfire | hit loop, **excluded by name** from the post-loop call | **gains** Focus once per landed arrow instead of once per cast |

**The two most alike are Calibrating Shot and Drumfire** — the only two whose payload is *more
Focus per cast*, and the only two at cooldown 3. **They are not a domination**: Drumfire wins
damage (42 vs 20) and raw Focus (~60 vs 20–40), Calibrating Shot wins cost (20 vs 25) and
initiative (**1.5 vs 3.0** — one is faster than a basic attack, the other slower). Under BD §4
neither is a strictly better version of the other.

**Nothing was re-authored**, which is what §2's own escape clause asked for if the four turned out
to be distinct decisions sharing a target shape. They are.

**AND ONE THING THE AUDIT'S `DMG-ST` LABEL HIDES, RECORDED HERE:** **Trophy Shot and Reacquire are
near-siblings** — both are "do not lose Focus when the target changes", one keyed on a kill and one
on a named mark. That adjacency is inside the pool and is not what the audit measured.

## §4 — TWO STALE CLAIMS CORRECTED, BOTH FOUND BY THIS BATCH'S OWN WORK

**FIELD DRESSING said "The only self-heal a Hunter can get" and it was already false when BR wrote
it.** HARVEST heals for the same amount it deals, and it sits in `SPEC_POOLS["mystic"]` **and** in
`CLASS_POOLS["hunter"]` — a Survivalist can be offered it by a zone boss. Salve would have made the
sentence wrong a third way. Corrected on the card, in `classes.gd`'s AXIS comment and in
`master.html`. **The tree half of the claim is TRUE and is kept**: no Hunter talent node heals in
any of the three trees — Field Medic *cleanses*, which is a different thing.

**AND THE "SIX DESIGNED ABILITIES NOT YET WRITTEN" LIST IS FOUR, NOT SIX.** `master.html` and
`sharpshooter_pool_ability`'s header record Disengage, Suppressing Fire, Piercing Arrow, Blight,
Smoke Bomb and Field Dressing as owed to the **boss** pools. **Field Dressing was written at BR —
as a HUNTER CLASS-WIDE DRAFT card**, so the name is spent and the boss pool still has nothing by
it; **Smoke Bomb's function shipped at BO as Choking Smoke**. Blight is the only Survivalist entry
genuinely still unwritten.

**DS DELIBERATELY DID NOT SPEND THE SHARPSHOOTER'S THREE NAMES.** The brief asked for a
Sharpshooter "DISENGAGE" and a Sharpshooter "suppression" card — two thirds of that list by name.
Spending them on draft cards would have paid one debt by opening another and left the header lying.
The draft got **Dug In** and **Heads Down**; all three names are still free.

## §5 — WHAT THE GATES CAUGHT BEFORE THE ACCEPTANCE RUN, AND IT IS THE MOST USEFUL PART

**FIVE FAULTS, EVERY ONE FOUND BY AN EXISTING CHECK OR BY DRIVING THE CARDS LIVE.**

1. **Four of the six were authored with a Perfect and could not have one.**
   `Ability.runs_skill_check()` gives a bar to damage, Break damage, healing, a `gated` card and
   the named `DAMAGE_SPECIALS`/`HEAL_SPECIALS` — and to nothing else. `test_batch_bo` §5 asserts
   the **biconditional**. Bear the Brunt, Bring It Down, Dug In and Thick Hide are pure buffs, so
   all four lost their Perfect — which is the rule every pure buff in these three pools already
   follows. **SALVE KEPT ITS PERFECT BY JOINING `HEAL_SPECIALS`**, which is honest rather than a
   workaround: its heal rides a status it applies, which is RENEWAL's shape, and that list is the
   answer to *"is this card a heal"*.
2. **`check_co` went red on Salve.** Its `_recast_writes` proposed the PERFECT's four turns while
   **`check_co` saturates by casting at grade `"good"`**, which writes three — so the proposal
   improved on what was standing every time and the card would never have refused a wasted recast.
   `emberkeep` looks like a counter-example and is not: its handler writes `EMBERKEEP_TURNS + 1`
   unconditionally. **The rule is now in `CLAUDE.md`: a proposal must equal what a GOOD cast
   writes.**
3. **`check_di`'s `CALL_SITES` equality tripped, and DS had predicted it.** 205 → **210**, net +5,
   all arrivals. `SRC_FLOOR` moves **106 → 107** and the reason is the rule working rather than a
   coincidence: **`heads_down` is the only one of the five that lands on an ENEMY**, so it is the
   only one that passes `attacker`; the other four are hero-side buffs nothing Harvest-shaped reads.
   Bear the Brunt is not a site at all — it goes through `add_status` directly, Bloodbond's shape.
4. **`test_batch_bx` went 0 → 4 and every one was DS's own — the retired-word sweep biting exactly
   as designed.** "beast" is retired from player-facing prose and **Bear the Brunt's card text, its
   live chip and its cast message all used it**, as did two of the six new `master.html` rows
   ("beast" for §4, "party" for §4b). The fourth was §3's `_deepest_bond` caller count, re-pointed
   3 → 5. **A batch adding Beastmaster content is precisely the batch that reintroduces the retired
   word, and nothing else in the tree would have said so.**
5. **HEADS DOWN WOULD HAVE SHIPPED VIRTUALLY INERT, AND ONLY DRIVING IT LIVE FOUND IT.** The first
   version refused any ability with `cost > 0`, on the assumption that an enemy's better options
   are the ones it pays for. **46 of the 50 enemy abilities in `data/enemies.json` cost zero** —
   Chain Lightning, Healing Wave, Sundering Strike and Poison Arrow among them — so it would have
   refused four abilities in the whole game while reading as working. A live fixture put a
   suppressed enemy at **"0 refused, 2 kept"**. The criterion is identity against
   `_cheapest_attack` now, which is what the card text always said, and it cannot starve the
   fallback because the one ability it never refuses **is** the one the caller falls back to.

**THE LIVE EXERCISE, AND WHAT IT LEAVES OWED.** All six were driven through a real battle in a
scratch fixture — 19 checks, 0 failures: the guard fires and the companion pays and the guard is
spent; Bring It Down stamps every hero at the right price without spending the bond; the
suppression refuses and then lifts; the three buffs land carrying the right number. **That fixture
is NOT in the repo.** `check_co`'s sweep exercises four of the five specials as a side effect, so
**`bring_it_down` and `heads_down` have no permanent live coverage** — a gate is the obvious next
step and was left out because §5 of the brief enumerated the deliverables and a new gate is a
scope decision (it also risks `check_da` §3, which refuses a gate that hand-rolls the corpus walk).

## §6 — WHAT IS DELIBERATELY NOT DONE

- **NO TALENT NODE MOVES, AND THIS IS SAID OUT LOUD AS THE BRIEF ASKED.** The Sharpshooter's
  missing defensive node is real and is **not this batch's** — a cell that changes row mis-prices
  the ledger, and nothing here moves one. **Only the DRAFT half of "both halves of his progression
  offer him nothing" is answered**; the tree half is still open, and the audit's resolution banner
  says so rather than implying the whole finding is closed.
- **Pyroblast's cooldown of zero stays open**, DO's last loose end.
- **No other pool is touched.** The Cryomancer's 11-of-11 and the Pyromancer's one-currency
  finding are reported and unruled.
- **One correction in passing, because the pair would otherwise be unreadable:** Bloodbond's
  `master.html` row contradicted itself, saying the hunter takes **a QUARTER** in one clause and
  "**the half** he takes can kill him" in the next. The code pays a quarter (`bb_pct := 25`). The
  sentence is fixed. Bear the Brunt sits directly beside it as its inverse, so the disagreement
  would have read as a difference between the two cards.

## §7 — BASELINE MOVEMENT: THREE PREDICTED EXACTLY, TWO NOT

**The method: derive the per-card rate from DR's own movement rather than guessing.** DR moved the
draft by a net +1 and moved `bo` +6, `cb` +1, `ce` +1 — so those are the per-card rates, and six
cards give +36 / +6 / +6.

| row | predicted | read | verdict |
|---|---|---|---|
| `test_batch_bo` | 1070 → **1106** | 1106 | **exact** |
| `test_batch_cb` | 1197 → **1203** | 1203 | **exact** |
| `test_batch_ce` | 1139 → **1145** | 1145 | **exact** |
| `check_co` | 301 → rise | 321 | direction predicted, size not |
| `check_cy` | — | 2704 → **2857** | **NOT PREDICTED** |
| `check_de` | 305 / 0 / 0 | 305 / 0 / 0 | **exact** |
| `check_di` | `CALL_SITES` +5, `SRC_FLOOR` +1 | 210 / 107 | **exact** |

**`check_cy` IS THE MISS AND IT IS WORTH NAMING.** Three of the six join `Ability.PURE_BUFFS` and
that gate runs its whole per-ability rule over every member. DS predicted the three draft-pool
loops and did not think about the buff table. **`bp`, `bq`, `br` and `cp` were correctly predicted
NOT to move** — they iterate per-*spec* or class×spec, so pool depth does not reach them.

**BRING IT DOWN IS DELIBERATELY NOT IN `PURE_BUFFS`.** It is a pure buff by shape, but it is the
strongest of the six — a party-wide amp scaling off an **uncapped** meter — and is priced at
initiative 2.0 for that, on PREPARATION's precedent. Membership would have clamped it to 1.0 as a
side effect of a table it joined for bookkeeping reasons.

## §8 — VERIFICATION

- **`check_parse` clean, with a negative control proving it bites.** A deliberate
  `func _ds_negative_control(:` produced `Parse Error: Expected parameter name.`; removing it
  restored a **byte-identical** file (verified by `diff` against a scratchpad copy, not by
  `git checkout`), and the tree read 0 again.
- **THE LITERAL SWEEP: 10,589 literals at a floor of 4**, from all 76 suites and gates, evaluated
  against twenty documents and sources and diffed against `git show HEAD` in one pass.
  **0 LOST.** **5 GAINED, and the dangerous kind is zero** — `125 spec`, `149 of`, `149 of 149`,
  `149 OF 149`, `A TARGET 149`, every one of them a needle this batch re-pointed itself, and every
  one cross-referenced against the negative `contains` assertions in the tree with no match.
- **THE COMMENT-STRIPPED DIFF WAS TAKEN.** With every line-leading `#` stripped, `battle.gd` lost
  **2** code lines and `classes.gd` **4**; all six are accounted for — the two `RECAST_GATED` array
  lines rewritten to take four new entries, the three pool arrays rewritten to take six cards, and
  Field Dressing's deliberately corrected description. `unit.gd` and `ability.gd` lost none.
  **Nothing was swallowed.**
- **THE NAME SWEEP RAN FIRST, over every ability, talent node, status and rune** — 794 display
  strings. All six names are clean, and near-misses were treated as hits: *Field Kit* was dropped
  for Field Dressing / Field Medic, *Bitter Harvest* for Harvest (same spec), *Poultice* for
  Cairnmoss Poultice, *Suppressing Fire* for the live Arcanist node, *Braced* for an exact
  collision. **One pre-existing near-miss was found and is reported, not fixed:** the Beastmaster's
  draft card **Ghostpack** and his own row-8 talent node **Ghost Pack** differ by one space, on the
  same spec — a sixth member of `docs/state.md`'s "five nodes named after live abilities" list,
  which records only exact matches.
- **THE THREE OLD FLAKES WERE QUIET AGAIN — the SIXTEENTH consecutive quiet reading.**
  `test_batch_at` read 467, `bo` 1106, `test_rune_battle` 97. **All three are still open, still
  unseeded, and a red from any of them is not this batch's.**
