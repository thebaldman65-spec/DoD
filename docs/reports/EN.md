# BATCH EN — THE LAST THREE CLAUSES, AND THE RUNG THAT IS A DOOR

**§1 is built and measured. §3 is a STOP. §2 derives a split and presents both halves without
authoring anything. §4 establishes what the code does and writes down what a relic is FOR.
§5 records two acceptances and retires one stale caveat.**

**The floor was run the way the brief specifies** — `grep -cE 'Parse Error|SCRIPT ERROR'` over
every log, off the streams, never a tally and never an exit code.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*The brief said to verify every premise. Five of nine did not survive as written.*

| the brief said | re-derived here | verdict |
|---|---|---|
| the three clauses "exist only as their node, so there is nothing beneath them to re-point onto" | true — no passive, stat, core ability or draft card writes any of the three | **holds** |
| EM measured a rune-only Occultist spreading a mark 0 in 400 against 55–66 summed | true, and it is EM's `spread_ranks` case | **holds** |
| all 56 re-keyed clauses were payouts and AL's MAX rule had zero applications | true | **holds** |
| Beastmaster 8-of-9 against Warden 0-of-7 | true — those are CLAUSES. In RUNES it is 3-of-4 against 0-of-4 | **holds, and the unit matters** |
| exactly one of the sixteen is Scarred — Bared Guard, 75g | true, derived: `scarred=true` on `bared_guard` alone | **holds** |
| **"Bot completion at that rung was 100% where the next two read 52–84% and 12–36%"** | CY's arms are **before → after** pairs of one change, not ranges — 52%→84% and 12%→36%. **And every one is a FULLY TALENTED party** (`rows=9 of 9`, CY's own named confounder) | **misread, and the confounder is the whole of §3** |
| **"Elite fights stay the shortest at every rung. 3.0 / 3.3 / 3.6 measured at CY"** | those are CY's and are superseded. DA re-measured 3.4 / 3.6 / **4.4** and `state.md` records the claim as **NO LONGER HOLDING AT RUNG 3** | **stale — and the re-measurement at EN restores it** |
| **`master.html` "still reads 'up to 3 equipped per run at the draft', which sounds party-wide"** | it does not merely sound party-wide — **it IS**, and the sentence is accurate. Neither document nor code is wrong about each other | **the framing does not hold; see §4** |
| **"CX §2 carried it with a stop clause, and its report was never read"** | unverifiable here — **no CX report exists in the repo** (`docs/reports/` begins at DJ) and CX appears in the changelog only as the batch that archived the older entries. What IS verifiable is the code, and the code never moved | **cannot be confirmed; the code answers the question anyway** |

**THE ONE THAT WOULD HAVE COST SOMETHING.** §3's case for removal rests on a bot completion
figure taken on a party that has already cleared the meta layer the rung exists to open. The
population that actually plays rung 1 has never been sampled by that figure — and when it is
sampled, the answer inverts.

---

## §1 — THE THREE HOMELESS CLAUSES GET RUNE-OWNED FIELDS

**Ruled: each gets its own implementation, owned by the rune.** That is EM §2's option A, and
what shipped is smaller than option A's own description — deliberately.

| clause | rune | new field | type |
|---|---|---|---|
| `divine_presence_pct` | Rune of the Sleepless Vigil (75g SCARRED, Holy) | `rune_divine_presence_pct` | **int**, and in `Runes.STAT_INT_KEYS` — the name does not end `_ranks`, which is the AA float-into-int trap |
| `entropy_ranks` | Rune of the Deepening Ruin (100g, Occultist) | `rune_entropy_ranks` | int; the `_ranks` suffix arm covers it, no registry row |
| `pleasure_pct` | Rune of the Whispering Dark (100g, Occultist) | `rune_pleasure_pct` | **float**, and deliberately absent from `STAT_INT_KEYS` — 0.5 would coerce to 0 outright |

### THERE IS NO SECOND TICK, AND THAT IS THE ONE PLACE THIS DEPARTS FROM EM'S WORDING

EM priced option A as *"three new fields and three new per-turn read sites in `battle.gd`'s turn
loop, each a small copy of the node's own tick."* **A second tick is wrong.** A hero holding the
rune AND the node would run both and be paid twice — the node's magnitude plus the rune's, twice
over — and a magnitude moving is the one thing a re-key forbids. What "owned by the rune" has to
mean is what it meant for all 56: **the rune has a field of its own, and the effect's existing
tick sums the pair**, so the rune pays alone, the node pays alone, and a hero with both is paid
exactly once for each.

### THE ARITHMETIC, READ AT EACH SITE RATHER THAN TAKEN BY ANALOGY

The brief was explicit that EM's finding must not be assumed to carry. It was read three times:

| clause | what the value IS | the guard beside it | verdict |
|---|---|---|---|
| `divine_presence_pct` | `dp_t.max_hp * 0.01 * pct` — a **percentage of max HP** | `if dp_pct > 0` | **PAYOUT**, presence test |
| `entropy_ranks` | `u.take_hit(0, rank)` — a **flat Break figure** | `if ent_occ != null and ent_rank > 0` | **PAYOUT**, presence test |
| `pleasure_pct` | `u.max_hp * 0.01 * pct * uniques` — a **percentage per unique debuff** | `if pp_pct > 0.0` | **PAYOUT**, presence test |

**So the answer is the same as EM's and it is now uniform across all 59: every clause is a payout,
every `> 0` beside one is a presence test, and AL's MAX rule has ZERO applications anywhere in the
rune layer.** On the Edge remains the only threshold any rune shares, and it is still AL's.

**Each guard sums into a LOCAL rather than testing the pair inline**, which is AX's shape for
Spread of Madness and is the shape `test_batch_ax` already pins: the local's definition and its
use are two separate assertions, so a repair that widens one and forgets the other is caught.

### THE MEASUREMENT — SEEDED, PAIRED, AND IT REPRODUCED EXACTLY

`_player_turn` and `_run_battle` cannot be driven headlessly (the AR trap), so the instrument is a
real autoplay battle read back off the battle's own combat log. **Seeded, so before and after are
the same battles** — a re-key that moves no magnitude must reproduce the readings *exactly*, and
"about the same" is the resolution at which a dropped clause hides. 24 battles an arm.

| drip | arm | fires | total | mean/fire |
|---|---|---|---|---|
| **divine_presence** | rune-only | 81 | 255 | 3.15 |
| | node-only *(control)* | 99 | 1329 | 13.42 |
| | both | 82 | 1409 | 17.18 |
| **entropy** | rune-only | 130 | 694 | 5.34 |
| | node-only *(control)* | 108 | 2300 | 21.30 |
| | both | 119 | 3151 | 26.48 |
| **pleasure** | rune-only | 76 | 166 | 2.18 |
| | node-only *(control)* | 79 | 846 | 10.71 |
| | both | 77 | 966 | 12.55 |

**BEFORE AND AFTER ARE BYTE-IDENTICAL — all nine rows, all three columns.** The re-key moved which
field each clause writes and nothing else, and the readings say so rather than the diff saying so.

### THE NEGATIVE CONTROL BIT IN THREE DIRECTIONS AT ONCE

A zero on a rune-only arm proves nothing on its own — a drip that stopped firing for an unrelated
reason reads identically. So the control was armed as the exact mistake a re-key makes: all three
read sites reading the node's half alone, on the same seeds.

| drip | rune-only | node-only | both (mean/fire) |
|---|---|---|---|
| divine_presence | 81 → **0** | 99 → **99** *(unmoved)* | 17.18 → **13.39** |
| entropy | 130 → **0** | 108 → **108** *(unmoved)* | 26.48 → **21.37** |
| pleasure | 76 → **0** | 79 → **79** *(unmoved)* | 12.55 → **10.66** |

**The rune dies, the node is untouched, and the hero holding both loses precisely the rune's share
of the sum.** The middle column is what makes the outer two mean something: the control is
specific to the rune's half rather than breaking the drip.

### WHAT MOVED, BY FILE

| file | what |
|---|---|
| `data/runes.json` | 3 payload keys renamed `X` → `rune_X`; **no value changed** |
| `scripts/unit.gd` | 3 `rune_` declarations beside their partners; the header's "three deliberately not here" block replaced with EN's closure |
| `scripts/runes.gd` | `rune_divine_presence_pct` into `STAT_INT_KEYS`; the AV block's stale sentence corrected (**no rune writes any of those three bare names any more** — EM took two of them and EN the third) |
| `scripts/battle.gd` | 3 read sites, each summing into a local above its guard |
| `check_em.gd` | §4 inverted; §1's `NO_HOME` exemption arm deleted with the set; a header error corrected |
| `test_batch_av.gd`, `test_batch_ax.gd` | 6 assertions repaired to intent (the same question, of the field the rune now owns) — and each now also asserts the BARE name **absent**, because a payload writing both halves would pay a node-holder twice |

---

## §2 — THE SIXTEEN: SPLIT, DERIVED AND PRESENTED

**Nothing here was authored.** Both halves are options.

### THE DERIVATION REPRODUCES THE SIXTEEN, AND THE INSTRUMENT MATTERS

Derived from `Talents.LANE_TREES` and `data/runes.json`, not taken from the brief: a rune is
*wholly talent-keyed* when every one of its stat clauses names a field a live talent node writes.
**With `check_em.UNIT_MATH` excluded** — the nine fields that are the unit's own math, where a
node writing one is a coincidence of target rather than a coupling — the derivation returns
**exactly the sixteen EM names**. *Without* that exclusion it returns twenty-six, sweeping in the
Colossus and the Glass Rune, which are universal runes that touch no tree at all. **The exemption
table is what makes this measurable, and a derivation that skipped it would have retired ten runes
for riding `max_hp_pct`.**

### THE POOL ARITHMETIC — AND THE FIRST SURPRISE IS THAT IT IS FLAT

| spec | spec runes | of those, retired | **spec-scoped left** | drawable now | drawable after |
|---|---|---|---|---|---|
| **Beastmaster** | 4 | **3** | **1** | 12 | **9** |
| Cryomancer | 4 | 2 | 2 | 12 | 10 |
| Inquisitor (Devout) | 4 | 2 | 2 | 12 | 10 |
| Occultist | 4 | 2 | 2 | 12 | 10 |
| Mystic (Survivalist) | 4 | 2 | 2 | 12 | 10 |
| Berserker | 4 | 1 | 3 | 12 | 11 |
| Swordmaster | 4 | 1 | 3 | 12 | 11 |
| Arcanist | 4 | 1 | 3 | 12 | 11 |
| Holy Cleric | 4 | 1 | 3 | 12 | 11 |
| Sharpshooter | 4 | 1 | 3 | 12 | 11 |
| **Warden** | 4 | **0** | **4** | 12 | **12** |
| **Pyromancer** | 4 | **0** | **4** | 12 | **12** |

**Every spec has exactly 4 spec runes and 12 drawable** (4 spec + 3 class-wide + 5 universal), so
the retirement is entirely a spec-scoped question — the 5 universal and 12 class-wide runes carry
no talent clause at all and none of them is touched.

**AND A RETIREMENT CANNOT BLANK AN OFFER, WHICH REMOVES THE OBVIOUS OBJECTION.** `Runes.generate`
rolls a rarity and draws inside it; an exhausted rarity **widens to every rarity**, and then falls
back to the generated Common family. All sixteen are Rare, and the rare shelf's floor after
retirement is **6** (Occultist and Beastmaster) against **3 rune slots a hero**. **No spec can run
out.** Depth of choice is the whole of what is at stake.

### THE THRESHOLD, STATED — AND IT IS CONTENT, NOT A COUNT

> **A spec is GUTTED when the retirement leaves it with no surviving rune — spec, class-wide or
> universal — that touches the spec's own engine. It is THINNED when the engine keeps at least
> one.**

**A count cannot carry this ruling and it is worth saying why.** The obvious line — "gutted below
N spec runes" — has no defensible N: the drawable pool never falls under 9 against 3 slots, and
the offer can never blank, so no count-based line has a consequence behind it. What a retirement
can actually destroy is a spec's ability to buy a rune that is *about that spec*. That is a
property of what the survivors DO, and it is checkable.

**Exactly one spec fails it.**

| spec | what survives | engine represented? |
|---|---|---|
| **Beastmaster** | `loosened_straps` alone — a SCARRED rune whose upside is **Quick Shot** (a Hunter-class card the Sharpshooter is built around) bought with −8% armor his companions share | **NO.** And no class-wide or universal rune touches a companion either — two of the three Hunter class-wide runes are Quick Shot again. **After a blanket retirement there is not one rune in the game that touches a companion, and the companion IS the spec.** |
| Cryomancer | `honed_lance` (Ice Lance), `killing_cold` (Chilled ×2) | yes |
| Inquisitor | `binding_oath` (Faith), `burning_censer` (Consecrated Ground) | yes |
| Occultist | `flayed_mind` (grants Mind Flay), `hollow_chalice` (Ruin lifesteal) | yes |
| Mystic | `quick_spring` (Snare Trap), `carrion_wake` (afflictions) | yes |
| the other seven | 3–4 apiece, all engine-facing | yes |

**THE LINE IS VISIBLE AND IT IS MOVABLE.** If the threshold is set at "keeps fewer than 2
spec runes" it catches the same one spec. If it is set at "loses half or more", it catches
**five** — the Beastmaster plus the Cryomancer, Inquisitor, Occultist and Mystic — which is 10
runes to re-author and 6 to retire. **The count-based lines are the ones without a consequence
behind them; the engine line is the one that names a thing a player loses.**

### HALF ONE — RE-AUTHOR (3 runes, all Beastmaster)

*The axis and the tradeoff for each. Nothing authored.*

| rune | price / lane | the axis it could take | the tradeoff |
|---|---|---|---|
| **Rune of the Deep Bond** | 100g, devotion | **DEPTH.** Its two clauses both scale on Loyalty; a rune-owned version could pay off the deepest bond rather than every bond — the row-8 shape (read an accumulated quantity, pay its depth) applied to an item | Depth-scaling on an uncapped meter is the Loyalty over-arrival `state.md` already reports (21.2 peak of a nominal 5). It would make the strongest bond stronger, which is the direction the meter is already too far in |
| **Rune of the Turning Pack** | 100g, pack | **BREADTH.** Its clauses reward *different* companions fielded; a rune-owned version could pay for the swap itself — tempo rather than damage | The Beastmaster's boss pool already deals no damage and no Break at all (`state.md`); another non-damaging item deepens a concentration finding rather than answering one |
| **Rune of the Shared Wild** | 100g, *splash* | **THE COMPANION'S BODY.** It already carries `rune_companion_hp_pct`; a rune-owned version could be about the companion surviving rather than hitting | This is the only splash of the three and splashes are the half the charter hurt most — with no lanes to reach across, "a little of every bond" has nothing to reach. Re-authoring it as one idea makes it a lane rune wearing a splash's name |

**AND THE HONEST NOTE ON ALL THREE:** re-authoring is content, it is the designer's, and the
standing rule applies. What the code can say is that these three are the only ones whose
retirement removes a mechanic from the game rather than an item from a shelf.

### HALF TWO — RETIRE (13 runes), AND WHAT EACH LOSES

*Retired the way Melted Armor is retired — **kept, and SAID to be kept.** Melted Armor's glossary
entry states outright that nothing in the game applies it, and `docs/text-audit.html` calls that
"the most honest string in the game". A retired rune keeps its entry and says it is not offered;
it is not deleted from `runes.json`.*

| rune | spec | what is lost |
|---|---|---|
| **Rune of the Bared Guard** | Swordmaster | **SEE THE SEPARATE FLAG BELOW — it is the one Scarred rune and it cannot be read as a straight loss.** |
| Rune of the Bitter Grip | Cryomancer | the only item pairing Chilled's slow with a crit window on HELD enemies — the Deep Freeze lane's two halves in one object |
| Rune of the Long Winter | Cryomancer | a splash across three cold terms; `killing_cold` still covers Chilled, so the loss is breadth rather than the engine |
| Rune of Boiling Blood | Berserker | one clause. `broad_path` already carries a Blood Frenzy term, so this is the thinnest loss of the thirteen |
| Rune of the Deep Sight | Sharpshooter | the Focus conversion point moving — the one item that changes *when* his patience converts rather than how much it pays. `level_aim` and `long_draw` both pay Focus; neither moves the point |
| Rune of the Open Hand | Holy Cleric | a splash of three graces; `triage_ward` covers the healing term and `sleepless_vigil` the wounded-ally term, so the opening Mercy is the piece with no other home |
| Rune of the Standing Vow | Devout | a splash of three vows, and **the one whose behaviour DO quietly narrowed** (EM §5): its holy-ground drip fires on Consecrated Ground alone. Retiring it closes that thread by removing it |
| Rune of the Warded Robes | Devout | Divine Shield's absorb-to-healing conversion — `burning_censer` reflects and mends, but nothing else turns an absorb into a heal |
| Rune of the Long Hunt | Mystic | a splash across poison, traps and Tripwire; `carrion_wake` covers afflictions and `quick_spring` traps |
| Rune of the Weeping Wound | Mystic | the only item that changes what his **basic attack** leaves behind. Nothing else in his pool touches the basic |
| Rune of the Deepening Ruin | Occultist | **one of the two runes §1 just re-keyed.** Its Entropy half is the per-turn Break tick EN gave a field to; retiring it retires that field on the same day it was authored |
| Rune of the Whispering Dark | Occultist | **the other.** Four clauses, the widest payload in the game, and the case EM and DP both used as the worked example of a rune going silently dead |
| Rune of the Resonant Core | Arcanist | the first-cast Resonance grant. `wide_current` pays crit and Mana, `seventh_bolt` a bolt — nothing else touches the build rate, which AT §3 measured as beating per-stack value quadratically |

**THE OVERLAP THAT HAS TO BE READ TOGETHER.** The Deepening Ruin and the Whispering Dark are the
only two runes where §1 and §2 meet, and they are both the Occultist's. A ruling that retires them
retires two of the three fields this batch authored. **That is not an argument against either
decision — it is the reason they cannot be taken independently.**

### THE SCARRED ONE, FLAGGED SEPARATELY AS THE BRIEF REQUIRED

**The Rune of the Bared Guard (Swordmaster, 75g, lane Blade) is the only Scarred rune among the
sixteen** — derived, not assumed: `scarred=true` on it and on none of the other fifteen.

**Its two clauses ARE the trade.** `rune_seasoned_off_bonus` +0.10 (Aggressive Stance deals 10%
more) is bought with `rune_seasoned_def_bonus` −0.15 (Defensive Stance stops reducing damage
taken). **Retiring it removes the cost with the upside**, so it cannot be priced as a loss the way
the other twelve can:

- **As a loss** it is the only item in the game that lets a Swordmaster buy *commitment* — trading
  a defensive posture away for an aggressive one is a decision no other rune in his pool offers
  (`still_wrist`, `shattered_guard` and `duelist` are all pure upside).
- **As a gain** the Swordmaster's pool goes from one Scarred rune to none, and every remaining spec
  set has exactly one. **He would be the only spec in the game with no Scarred rune**, which is a
  set-shape change rather than a content change and is a different decision from the other twelve.
- **`Runes.is_cost()` already handles its negative term correctly** under the sim's rarity lever
  — it refuses to scale a cost — so nothing mechanical depends on the retirement either way.

---

## §3 — THE RUNG GATES META-PROGRESSION. **STOPPED, AND NOTHING WAS REMOVED.**

**The brief's stop clause fired.** It said to stop and report if the rung gates meta-progression.
It does, and it gates the *first* of it.

### THE CHAIN, EVERY LINK IN THE CODE

1. `battle.gd:_resolve_boss` → **`Profile.note_end_boss(Run.difficulty_rung())`**
2. `profile.gd:note_end_boss` → `talent_tier = clampi(rung, 0, Talents.MAX_TIER)`, monotonic
3. `Talents.TIER_ROWS = [0, 3, 6, 9]` → **tier 0 unlocks NO rows at all**; tier 1 unlocks rows 1–3
4. `Talents.can_buy` refuses any cell in a locked row, with the reason string
   *"Locked: beat the end boss on difficulty %d"*

**So clearing the starter rung is the only thing in the game that opens rows 1–3 of all twelve
talent trees, and it opens them for every spec at once.** Before it, a profile can bank points and
buy nothing.

### THE MEASUREMENT THAT DECIDES IT

BN's own instrument, re-run on the live tree — `DOD_SIM_ROWS=0`, `--run 30` a rung, balanced
route, the standard four specs:

| rung | mult | **untalented completion** |
|---|---|---|
| **1 Wanderer** | ×0.50 | **97%** (29 of 30) |
| **2 Warden** | ×1.00 | **3%** (1 of 30) |
| **3 Ruin** | ×1.30 | **0%** (0 of 30) |

**Removing rung 1 moves a new player's first talent row from a one-attempt clear to roughly a
thirty-attempt one.** That is worse than the state BN §2 measured at ×0.70 (13% — "eight attempts
before the first unlock, with nothing banked in between") and deliberately fixed by choosing ×0.50.

### WHY THE CASE FOR REMOVAL LOOKED SOUND, AND WHAT IT MISSED

The 100% bot completion is real. It is also a **fully talented** party (`rows=9 of 9`) — CY's own
named confounder, re-confirmed here: at `rows=9 of 9` the three rungs read **100% / 80% / 80%**
(n=20), so for that party rung 1 genuinely is a formality. **But a fully talented party has
already been through the door the rung is.** The population that plays rung 1 is the one with no
rows at all, and for that population the next rung is not 80% — it is 3%.

**"A player who takes it never sees the game" is the same reading.** A player who takes it sees
the game at ×0.50 and then has rows 1–3 and can take rung 2. A player who cannot take it does not
see the game at all.

### RELICS ARE NOT BEHIND IT — the half a reader would guess wrong

`Relics.unlock_random()` is called at the top of `_resolve_boss`, **before the `is_end` branch**,
so every zone boss and the end boss award a relic at every rung. The relic ladder is
difficulty-independent and would have survived a removal intact. **Only the talent ladder reads
the rung.**

### EVERY SITE THAT READS A RUNG BY INDEX

*Comment-stripped sweep over every `.gd` in the tree. A removal renumbers, and these are what a
renumbering moves.*

**THE LADDER ITSELF (`run_state.gd`)** — `DIFFICULTIES` (the table, 3 rows each carrying `rung`,
`mult`, `severity_floor`, `fixed_modifier`), `DIFFICULTY_ORDER` (`["wanderer", "warden", "ruin"]`,
the draft screen's iteration order), `LEGACY_DIFFICULTY` (`{"standard": "warden"}`, Batch Y's id),
`difficulty_id` (unknown ids fall back to **`"wanderer"`** — a removal makes that fallback name a
rung that does not exist), `difficulty_def`, `difficulty_rung`, `difficulty_mult`,
`zone_base_mult`, and the save load at `run_state.gd:1959` which defaults a missing key to
`"wanderer"`.

**THE READERS OF THE RUNG AS A NUMBER — there are three and they are the whole surface:**

| site | what it does with the index |
|---|---|
| `battle.gd:1078` | `Enemies.config(kind, Run.difficulty_rung())` — drops any authored ability tagged `"rung": N` above the rung played |
| `battle.gd:23186` | `Profile.note_end_boss(Run.difficulty_rung())` — **the meta gate** |
| `run_sim.gd:240` | `diff_rung = run.difficulty_rung()`, printed in the run report's header |

**THE INDEX IS ALSO THE TALENT TIER, AND THAT COUPLING IS THE RENUMBERING RISK.**
`draft_screen.gd:147-148` advertises each rung's unlock as
`Talents.rows_unlocked(int(def["rung"]) - 1) + 1 .. Talents.rows_unlocked(int(def["rung"]))`.
**It reads `def["rung"]` as a tier index directly.** If the ladder were renumbered so today's
middle rung became rung 1, `note_end_boss` would open rows 1–3 for a clear the button advertises
as opening rows 4–6 — or, if the rungs kept their numbers with the first row deleted, tier 1 would
become unreachable as a step and the first clear would open rows 1–6 at once while the button said
4–6. **Both are wrong in the announcement rather than in the ledger, which is the failure mode
that ships.**

**AND THE ENEMY DATA CARRIES TWO INDICES.** `data/enemies.json` has exactly two `"rung"` tags —
one at 2 and one at 3, both on the end boss, which `Enemies.config` filters. A renumbering makes
both mean a different fight.

**NO SECOND REFUSAL PATH WAS INVENTED.** `run_state.gd` already refuses and clears a pre-v10 save;
the brief was explicit that a removal must not add a second, and since nothing was removed,
nothing was added. **`Run.difficulty` is a saved String and every id still resolves.**

### WHAT THIS BATCH DOES NOT DECIDE

Whether the rung is boring is a real question and this does not answer it. **What it says is that
the rung cannot be removed without re-homing the first talent tier, and re-homing an unlock is a
design decision rather than a batch's.** If the intent survives the numbers above, the options are
each a design ruling in their own right: open tier 1 on a zone boss rather than the end boss;
open it on the FIRST end-boss clear at any rung; or retune rung 2 downward toward the ×0.50 the
untalented sweep says a first clear needs. **None of them is a removal.**

---

## §4 — DID RELICS PER-HERO EVER LAND? **NO.**

### WHAT THE CODE DOES

| site | what it says |
|---|---|
| `run_state.gd:210` | `var active_relics: Array = []  # up to 3 relic ids chosen at the draft` — **a flat list of ids. No hero key anywhere.** |
| `run_state.gd:451-457` | `relic_add(hook)` / `relic_dict(hook)` — **both take a hook and nothing else.** No hero parameter, so no read site could name one |
| `run_state.gd:464` | `active_relics = relics.slice(0, 3)` at `new_run` |
| `run_state.gd:1916 / 1956` | saved as `"active_relics": active_relics`, read back as a hard key with no default — **the save format never moved** |
| the 25 read sites | `battle.gd` 12, `run_state.gd` 8, `run_sim.gd` 4, `shop_screen.gd` 1 — every one aggregates over the whole list and applies the result to the whole party |

**The run save is v12 and is tolerant. Per-hero relics would take it to v13** — which is itself the
proof that the work never started, because a per-hero `active_relics` cannot be read back by
`data["active_relics"]` without one.

### NEITHER DOCUMENT NOR CODE IS WRONG, AND THAT IS THE FINDING

The brief expected one of the two to be wrong. **`master.html`'s "up to 3 equipped per run at the
draft" is ACCURATE** — it does not merely *sound* party-wide; the relics *are* party-wide, and the
sentence describes what the code does. **What was missing is that a ruling points the other way
and has never been built**, and a reader of `master.html` had no way to know that.

**So the correction is the EM shape rather than a factual repair**: the document now states that
relics are party-wide **today**, that the per-hero ruling stands and is unbuilt, what it would
cost (v12 → v13, four signatures, both acquisition sites, 13 of 25 descriptions), that four hooks
are still unruled, and that the draft assigns relics **before specs are chosen** — which is the
moment when "which hero" has the least information behind it.

**The code was NOT moved toward the ruling**, and the reason is on the record rather than
implied: `state.md`'s own relic block says four hooks — `victory_heal_pct`, `victory_mana_pct`,
`rest_heal_add` and `resource_floor_pct` — **need a ruling before any of it**. Building per-hero
relics while those four are open means choosing four designs by implementation, which is the guess
AR §4 forbids and which this batch spent §1 avoiding.

### THE DIVISION OF LABOUR, DERIVED FROM THE READ SITE

*Written into `CLAUDE.md`. It is derived rather than asserted, and the derivation is the useful
half.*

**Every one of the 19 relic hooks is read at exactly one site**, and `relics.gd`'s own header
names them: `new_run` (the opening purse and pouch), **battle spawn** (base stats, written before
turn one), the victory screen, `award_gold`, rest nodes, shop prices, elite spoils. Swept over all
25 read sites of `relic_add` / `relic_dict`, they land in exactly `_spawn_units`, `_check_end`,
`new_run`, `award_gold` and the three shop-price copies. **NOT ONE IS READ WHILE A TURN IS
RESOLVING.** And the header's own *"NEEDS PLUMBING (declared out for now)"* list — on-kill and
per-turn procs, revive-on-death, enemy-side auras, DoT-tick and Break-damage multipliers — **is
precisely the in-combat category.**

A talent counter, by contrast, is a `BattleUnit` field read inside `battle.gd`'s combat math.
**The talent trees are the only meta layer that reaches a turn as it resolves.**

> **A RELIC SETS UP THE RUN. A TALENT CHANGES WHAT A SPEC DOES INSIDE A FIGHT.**
> A relic is party-wide by construction — it is chosen at the draft, *before specs exist*, so it
> cannot be about a spec. A talent is copied off `Profile` when a spec is confirmed, so it can
> only be about that spec. **And a RUNE is the layer between them**: run-scoped, per-hero, bought,
> and by the charter it modifies stats, resources, and the mechanics and values of core abilities,
> draft abilities and passives.

**The tell for a future author is the read site**, and it decides all three cases without a
judgement call.

---

## §5 — TWO ACCEPTANCES, AND A STALE CAVEAT RETIRED

### ELITE FIGHTS ARE THE SHORTEST — ACCEPTED, AND THE FIGURES ARE RE-MEASURED

**Ruled: accepted. Elites are burst checks by design, and a ramp spec having least room exactly
where difficulty spikes is the intended tension.** Recorded in `CLAUDE.md` beside CY's cap so it
is not rediscovered as a finding a third time.

**But the brief's figures could not be recorded as given.** 3.0 / 3.3 / 3.6 are CY's, DA
superseded them at 3.4 / 3.6 / 4.4, and `state.md` carries an explicit caveat that the claim
**"NO LONGER HOLDS AT RUNG 3"**, where DA read all three kinds at 4.4. So it was re-measured —
`--run 30` a rung on the live tree, same specs, same route:

| rung | trash | **elite** | boss |
|---|---|---|---|
| 1 Wanderer | 3.9 (n=206) | **3.4** (n=256) | 3.8 (n=60) |
| 2 Warden | 4.3 (n=240) | **3.7** (n=246) | 4.4 (n=57) |
| 3 Ruin | 4.4 (n=235) | **4.0** (n=225) | 5.4 (n=55) |

**The elite is shortest at all three rungs again, by 0.4–0.5 rounds. DA's rung-3 flat row does not
reproduce, and the caveat is retired.** The acceptance is recorded against these numbers rather
than CY's. **The confounders ride with them exactly as they did at CY**: the sim party is fully
talented (`rows=9 of 9`), it wears each tree's first lane, and companions are excluded from both
halves of the ratio.

### THE TAGS STAY MECHANICALLY INERT

**Ruled: accepted.** Whether runes read a tag waits until the designer has played with tags on a
real draft screen. **`check_ek` §3's game-side population stays at THREE** — `classes.gd` and
`runes.gd` define the tables, `map_screen.gd` displays them — and this batch keyed nothing to a
tag while re-keying the last three clauses past them. Recorded in `CLAUDE.md` so that touching the
rune layer is not read as owing a differential mechanism.

---

## §6 — THE GATE, AND ONE CORRECTION IT WAS OWED

### `check_em` §4 WAS INVERTED, NOT DELETED

EM's `NO_HOME` table said: *"the day one of them is answered this gate reds and the answer is to
delete its row, not to widen the set."* **All three were answered at once, so the instruction's
literal reading empties the table** — and a section looping over an empty table asserts nothing
while printing exactly like a clean run.

**So the table inverted.** `RE_KEYED_AT_EN` names the same three fields with the rune each landed
on, and §4 now asserts:
1. **the closure** — not one clause in `runes.json` writes a live node counter, with no drip
   exemption (the arm EN's three used to sit behind);
2. **each pair, in both directions** — a live node still writes the bare name (or the pair is not
   a pair), the rune writes `rune_X`, and the rune does **NOT** write the bare `X` (which would
   pay a node-holder twice);
3. **`CHECKED n of m`**, printed, so a walk that reached nothing cannot read as a pass.

**§1's `or NO_HOME.has(field)` exemption arm was deleted with the set**, so the three are now
asserted by the charter property itself rather than exempted from it.

### AND THE GATE'S OWN HEADER CARRIED EJ'S OFF-BY-ONE

`check_em`'s §1 header read *"`crit_bonus`, `speed`, `armor` and seven others"* and *"the TEN
fields it clears are `UNIT_MATH`"*. **`UNIT_MATH` holds NINE and `armor` is not one of them.**
That is EJ's own miscount arriving in the gate whose §1 found it — `armor` is the tenth name in
EJ's list *precisely because* no live talent node writes it, so it needs no exemption and was
correctly left out of the table. **The table was right and the sentence describing it was wrong**,
which is the direction that survives a battery, because nothing asserts on a comment. `CLAUDE.md`
had it right all along and is unchanged on this point.

### AND A SENTENCE IN `runes.gd` HAD GONE STALE AT EM

`STAT_INT_KEYS`'s Batch AV block said *"These three are what the four Holy runes write today"* of
`triage_heal`, `divine_presence_pct` and `last_hope_pct`. **EM re-keyed two of them and EN the
third, so no rune writes any of the three.** All three stay listed — that is the durability rule
AW and AX list their unwritten entries under — but the sentence now says so.

---

## WHAT THIS BATCH DID NOT DO, STATED SO IT IS NOT READ AS CLEAN

- **No rune was authored, re-authored or retired.** §2 is options.
- **No balance judgement.** §1 moved no magnitude, and the seeded before/after is the proof.
- **The difficulty rung was not touched**, and neither was the talent tier ladder.
- **Per-hero relics were not built**, and four hooks are still unruled.
- **The elite figures are a sim measurement with CY's confounders**, not a play judgement.
- **`check_ek` §3's population did not move** and nothing was keyed to a tag.

---

## THE VERIFICATION RUN

**The floor first, the way the brief specifies.** `grep -cE 'Parse Error|SCRIPT ERROR'` over every
one of the 87 logs: **0 files matched, and 0 matched `Parse Error` alone.** Never a tally, never an
exit code.

| | |
|---|---|
| targets run | **87** (51 suites, 35 gates, plus the harness and scene runs) |
| checks | **41,445** |
| throws | **0** |
| `Parse Error` | **0** |
| the differ | **`check_de`: 358 checks / 0 failures / 0 notices** — every target matches its baseline |

**THE TREE WAS FROZEN AND THE FREEZE WAS PROVED**, not assumed: 186 files md5'd by absolute path
before the run and again after, and the two lists are identical. `.ran` holds 87 names with **no
duplicate**, so no second battery wrote into the same directory.

**THREE ROWS MOVED IN `baselines.json` AND ALL THREE WERE PREDICTED FROM WHAT THE TARGET READS:**
`check_em` 210 → **223** (§4 rewritten, §1's exemption arm removed), `test_batch_av` 350 → **351**
and `test_batch_ax` 350 → **352** (each gained one pinned local beside the assertion it already
made). **No other row moved**, and `check_de` confirms it.

**THE TWO STANDING REDS ARE STANDING, AND THE DIFFER SAYS SO RATHER THAN THIS REPORT.**
`test_rune_battle` reads 97 / 1 against a recorded band of 97 / 0–1, and `check_cm_live` reads
13 / 4 against a recorded 13 / 4. Neither moved.

### ONE REGRESSION, AND IT IS THE ONE THIS PROJECT HAS A MEMORY OF

**`test_batch_bx` §4b went red on new `master.html` prose: "PARTY-WIDE" and "the whole party".**
That section is DL §2's retired-word rule — *hero* means the four and *ally* means heroes and
companions, and **"party" reads as either**, which is how Rallying Shout's clause paid four bodies
for the life of the project while its card promised the shed to everyone standing.

**The pre-check that was run missed it for a structural reason worth recording.** Ten
document-reading GATES were run before the battery and all ten were green — but §4b lives in a
SUITE, not a gate. **The rule is not "pre-check the gates", it is "pre-check every target that
reads the document you edited"**, which here is 25 targets, six of them gates and nineteen suites.

**The repair and its proof:**
- Both phrases replaced with the project's vocabulary — *"every equipped relic applies to all four
  heroes"* and *"reaches every hero"*. **No claim changed**; only the words the standard retired.
- **A NEEDLE SWEEP AGAINST THE EXACT FILE THE BATTERY READ**, reconstructed by reversing the two
  replacements: over 13,146 literals harvested from every target, **1 LOST (`the whole party`) and
  0 GAINED.** The one lost needle resolves only inside a comment in `check_dl.gd` and is asserted
  nowhere.
- **AND THE SWEEP IS NOT THE PROOF, BECAUSE IT HAS A HOLE A RUN FINDS.** §4b tests
  `contains("party")` after stripping five marked identifiers, and `master.html` legitimately still
  contains `party_screen` and `<code>party</code>` — so the raw needle `party` never flips and the
  sweep cannot see this assertion at all. **Every one of the 25 targets that reads `master.html`
  was re-run**: all nineteen suites green (bx **161 / 0**, its exact baseline) and all six gates
  green. `check_de` was then re-run over the updated logs and reads **358 / 0 / 0**.

### THE NEGATIVE CONTROLS, AND ALL OF THEM BIT

- **§1's, which is the batch's load-bearing one, bit in THREE directions at once** — see §1. It was
  armed on the exact mistake a re-key makes rather than on something adjacent, and the middle arm
  (the node-only reading not moving a single fire) is what makes the other two mean anything.
- **`check_em` §4's own construction is the second.** Inverting the table rather than emptying it
  is what stops the section passing vacuously, and it prints `CHECKED 3 of 3` so a walk that
  reached nothing cannot read as clean.
- **The five controls EM built into `check_em` all still bite** — the gate reads 223 / 0 with its
  populations printed: 116 stat clauses across 65 runes, **69 rune-owned**, **50 re-keyed counters,
  101 reading statements, 0 taking only one half.**

### WHAT THE INSTRUMENTS COULD NOT SEE, NAMED RATHER THAN DISCOVERED LATER

- **The pin manifest does not carry a needle written inside a `for x in [[...]]` list**, which is
  where all six of this batch's repaired assertions live. `build_pin_manifest.py --check` reports
  **current at 1350 pins** and `check_ed` reads 18 / 0 — both correct, and both blind to this
  shape. It is a **pre-existing, uniform** hole (`0.01 * occ.grim_ranks` and
  `var sp_chance := occ.spread_ranks`, both long-standing, are equally absent), documented at
  `check_ed` §2 itself. **Nothing regressed; the population simply never included these.**
- **`test_batch_ax`'s `oc_fields` guard is an exact-match list**, so a class-wide rune writing
  `rune_pleasure_pct` would pass where one writing `pleasure_pct` fails. **True of all 56 of EM's
  re-keyed fields already** and not introduced here — reported, not changed, because widening it is
  a question about what the charter makes that assertion mean.
- **The §5 rounds figures are a sim measurement with CY's confounders**, not a play judgement.
- **The §3 completion figures are the bot's**, at `route=balanced`, on the standard four specs.
