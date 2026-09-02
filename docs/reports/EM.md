# BATCH EM — THE RUNES GET THEIR OWN FIELDS

**IMPLEMENT-ONLY, and the implementing is §1.** 56 of the 59 clauses that wrote a live talent
node's own counter now write a rune-owned field, read beside the node's at the same site.
**Not one magnitude moved.** §2 and §3 present options and author nothing; §4 corrects both design
documents toward the code and records what severing the lane rule deletes; §5 puts the Rune of the
Standing Vow on the record.

**The floor was run the way the brief specifies** — `grep -E 'Parse Error|SCRIPT ERROR'` across
every log, off the streams, never a tally and never an exit code.

---

## THE BRIEF'S CLAIMS, RE-DERIVED

*The brief said to verify every premise here, including EJ's 59 and 32.*

| the brief said | re-derived here | note |
|---|---|---|
| **59 clauses across 32 runes write a live talent node's own counter** | **true, and reproduced two ways** | EJ's audit page parses to exactly 59 TALENT clauses in 32 runes; an independent derivation off a LIVE `LANE_TREES` dump agrees clause-for-clause |
| **56 of the 59 need only a field of their own** | **true** | 59 − the 3 with no home = 56, and all 56 re-keyed with the read site summing the pair |
| **AL shipped this repair three times** | **true** | `rune_grudge_bonus`, `rune_vigil_bonus`, `rune_on_edge_ranks`, all three live, with the method and the MAX/SUM rule in the source comments at `battle.gd:9267` and `:10244` |
| **the rule any re-key needs: a threshold takes the MAX, a payout SUMS** | **true, and it has ZERO applications here** | every one of the 56 is a payout. The `> 0` tests beside them are presence tests, not thresholds — see §1 |
| **16 runes are wholly talent-keyed** | **true** | the same sixteen EJ names, reproduced from the data |
| **all 59 sit in the 48 spec runes; the 5 universal and 12 class-wide carry none** | **true** | |
| **the Warden is 0-of-7 and the Beastmaster 8-of-9** | **true** | and three of the Beastmaster's four runes are among the sixteen, against none of the Warden's |
| **`master.html` and `design-notes.md` both state the lane rule as CURRENT** | **true** | and EJ is right that both were accurate descriptions of the authored pool |
| EJ §1: **"nine such fields are classed STAT despite having a node"** | **the sentence says NINE and the list beside it names TEN** | the tenth is `armor`, and **no live talent node writes it at all** — it is an ordinary stat needing no exemption. `check_em` §1's equality found this on its first run |

**ONE PREMISE IN NINE DID NOT HOLD, AND IT IS A COUNTING ERROR RATHER THAN A WRONG READING.**
EJ's *test* is right and its list is right; only the number in the prose is off by one, and it is
off in the safe direction — an extra name in a list of things that need no exemption.

---

## §0 — THE TAGS ARE INERT AND THE POPULATION DID NOT MOVE

**No rune keys to a tag.** `check_ek` §3's game-side population is still THREE, asserted and
unchanged, and `check_ek` and `check_el` both read 43 / 0 and 23 / 0 standalone after every edit in
this batch. The differential mechanism — a rune worth more to a hero pointed the same way — is the
design half and waits until the tags have been seen on a real draft screen.

---

## §1 — THE 56 GET THEIR OWN FIELDS

**Each clause writes `rune_X` instead of the node's `X`, and every read site sums the pair.**
47 new `BattleUnit` fields; **97 reading statements across nineteen scripts**, a figure
`check_em` §2 derives every battery run rather than one anybody typed.

### THE SPLIT: 56 PAYOUTS, 0 THRESHOLDS

**AL's rule was applied and its answer here is uniform.** A threshold is a value that decides
*whether* an effect fires — On the Edge's health window, which is the case AL actually faced. Every
one of these 56 is a value that decides *how much*: a percentage point on a multiplier, a Focus
figure, a turn on a firewall, a step on a drip. **Summing them is what makes each half pay its
advertised number alone and stacked, which is the property AL wrote the rule to protect.**

**The `> 0` tests beside them are PRESENCE tests, not thresholds**, and the distinction is the
whole of §1's risk: `if attacker.vulture > 0` asks *does this hero have Vulture at all*, and the
answer for a hero holding the rune and not the node has to be yes.

**FOUR ARE ARGUABLE AND NONE OF THEM WAS DECIDED QUIETLY.**

| clause | rune | why it is arguable | what shipped |
|---|---|---|---|
| `spread_ranks` | Whispering Dark | it is a **probability**. Node 60% + rune 15% = **75%**; two independent rolls would be 66% | **SUM.** The game rolls once, so summing is the only shape that pays both — but it is not the only defensible reading and a MAX here would silently delete the rune's clause for any Occultist holding the node |
| `deep_focus` | Deep Sight | it moves the **Focus conversion point**, which reads like a threshold | **SUM**, and it is authored: `unit.gd`'s own comment says *"the counter holds the DROP, which is what makes it additive: the node pays 40 and the Rune of the Deep Sight pays 8 on top."* The field is the MOVEMENT of a threshold, not the threshold |
| `quick_whistle_ranks` | Turning Pack | a cooldown **shave with a floor at 0** | **SUM.** The node alone can already reach the floor, so on that hero the rune's turn is swallowed. That is the ordinary case of a rune being worth less to a build that went the same way — but it is now the *only* case of it left, since the lane rule is gone |
| `seasoned_def_bonus` | Bared Guard | the value is **NEGATIVE** (−0.15), the scarred half of a trade | **SUM**, which is right — two costs compose — but "payout" is an odd word for it, and `is_cost()` correctly refuses to rarity-scale it under the sim lever |

### THE GUARD IS THE DANGEROUS HALF, AND IT WAS MEASURED RATHER THAN ARGUED

**The read site decides, not the field name** — and at these read sites the decision is made by the
`if` above the arithmetic, not by the arithmetic. `if not _ruin_spreading and occ.spread_ranks > 0`
is FALSE for an Occultist holding the Rune of the Whispering Dark and not the node. Nothing throws.

**Driven live on a rune-only Occultist, 400 marks laid:**

| the guard reads | marks that spread, of 400 |
|---|---|
| the node's counter alone | **0** |
| the pair summed (four readings) | **55, 58, 59, 61, 63, 66** — the rune's advertised 15% |

**This is DP's Whispering Dark case arriving through the repair for it.** DP found a re-pointed
NODE leaving a rune's clauses paying nothing; a re-keyed RUNE opens the same door from the other
side. It is why `check_em` §2 asserts that every *statement* reading `X` also reads `rune_X`,
rather than asserting that `rune_X` exists somewhere.

### WHAT MOVED, BY FILE

| file | what |
|---|---|
| `data/runes.json` | 56 payload keys renamed `X` → `rune_X`; **no value changed** |
| `scripts/unit.gd` | 47 `rune_X` declarations, each beside its partner and each naming the runes that write it, plus the rule as a header block |
| `scripts/runes.gd` | **13** `rune_` names added to `STAT_INT_KEYS` — the int fields whose names do not end `_ranks`. **The 8 floats are deliberately absent and the comment says so** |
| `scripts/battle.gd` | the read sites, and `_max_hero_rank(field, rune_field := "")` — the party-wide max now sums the pair PER HERO before taking the best, which is the arm a string key would otherwise have hidden |
| `scripts/party_screen.gd` | 3 `cfg.get` readouts on the hero sheet |

**`_max_hero_rank` is worth naming.** Four counters — `frigid_ranks`, `frostbite_ranks`,
`hungering_ranks`, `hypothermia_ranks` — are read through a STRING key across the living party. A
rename there fails at no compile step and at no read site; the function simply returns 0 for the
rune's half forever.

---

## §2 — THE THREE WITH NO HOME: OPTIONS, AND NOTHING AUTHORED

**`divine_presence_pct`, `entropy_ranks` and `pleasure_pct` still write the node's counter.**
Each is a per-turn drip that exists *only* as its node — no passive, no stat, no core ability and no
draft card underneath it — so a re-key means inventing an effect, which is the guess AR §4 forbids.
**`check_em` §4 names all three as an EQUALITY**, so the day one is answered the gate reds and the
answer is to delete its row rather than widen the set.

### WHAT EACH RUNE IS WORTH BEFORE AND AFTER

| rune | price | its clauses today | if the clause is DROPPED |
|---|---|---|---|
| **Rune of the Sleepless Vigil** | 75g **SCARRED**, Vigil | `divine_presence_pct` 2 (the drip), `beacon_ranks` 1 (**already rune-only**), `speed` −10 (the scar) | **one of three, and the survivor is one effect.** A scarred rune paying a single turn-start heal for a real Speed cost — the thinnest object in the set |
| **Rune of the Deepening Ruin** | 100g, Ruin | `rune_deep_hex_step` 1 (live), `entropy_ranks` 5 (the drip) | **one of TWO. Dropping it halves the rune** and leaves a 100g Rare paying +1% damage per Ruin stack and nothing else |
| **Rune of the Whispering Dark** | 100g, splash | `rune_broken_will_ranks` 5, `rune_spread_ranks` 15, `rune_spread_ruin` 1 (all live), `pleasure_pct` 0.5 (the drip) | **one of four, and the cheapest of the three to lose.** Its desc would need the most surgery — the clause is the last sentence of a four-clause sale |

### THE OPTIONS, PRICED

**A. Give each drip a rune-owned implementation of its own.** Cost: three new fields and three new
per-turn read sites in `battle.gd`'s turn loop, each a small copy of the node's own tick. It is the
only option that keeps all three runes exactly as sold. **It is also the one that invents mechanics
the designer has not seen** — a rune-owned per-turn party heal is a new thing in the game even when
its number matches a node's.

**B. Re-point each clause onto something adjacent the rune already touches.**
- Sleepless Vigil → deepen `beacon_ranks`, which it already owns and which is already rune-only.
  **Cheapest of all three and changes no vocabulary**; the cost is that the rune becomes one effect
  bought twice rather than two effects.
- Deepening Ruin → deepen `rune_deep_hex_step`, its only other clause. Same objection, harder: the
  rune's whole sale is *two* different things Ruin does.
- Whispering Dark → it has three live clauses to choose from and the desc would carry it.

**C. Drop the clause and say what the rune loses.** The table above is that statement. **The
Deepening Ruin is the one where this is a real loss** and the Whispering Dark the one where it is
nearly free.

**D. Leave them.** They are three clauses of 135 and the gate names them. **The cost is that the
charter is 98% true rather than true**, and a partial rule is the shape this project has paid for
before.

**No recommendation is made between A, B, C and D.** What the code can say is that B is cheapest,
C is the only one that needs no new mechanics *and* no new fields, and A is the only one that leaves
all three runes selling what they sell today.

---

## §3 — THE SIXTEEN THE CHARTER EMPTIES

**Every clause these sixteen own was talent-keyed.** After §1 they are mechanically whole — each
pays exactly what it paid — and each has lost the argument for existing, because each was
*your lane, but more.* **The charter does not trim them; it deletes their reason.**

**EXACTLY ONE IS SCARRED: the Rune of the Bared Guard.** Its two clauses ARE the trade
(+10% Aggressive Stance bought with −15% off Defensive Stance's mitigation), so **retiring it
removes both halves at once** — there is no upside left standing when the cost goes. None of the
other fifteen has that property.

| rune | spec | price | lane | what it does now |
|---|---|---|---|---|
| **Rune of the Resonant Core** | Arcanist | 100g | Resonance | `rune_resonant_core_ranks` 1 → Resonant Core<br>`rune_conduit_step` 0.5 → Conduit |
| **Rune of the Deep Bond** | Beastmaster | 100g | devotion | `rune_wild_communion_step` 1.5 → Wild Communion<br>`rune_absolute_step` 3.0 → Absolute Devotion |
| **Rune of the Shared Wild** | Beastmaster | 100g | *splash* | `rune_wild_communion_step` 1.5 → Wild Communion<br>`rune_momentum_ranks` 8 → Feral Momentum<br>`rune_companion_hp_pct` 0.05 → The Wild Within |
| **Rune of the Turning Pack** | Beastmaster | 100g | pack | `rune_quick_whistle_ranks` 1 → Quick Whistle<br>`rune_momentum_ranks` 8 → Feral Momentum |
| **Rune of Boiling Blood** | Berserker | 100g | Fury | `rune_bloodrage_step_bonus` 0.5 → Unstoppable |
| **Rune of the Bitter Grip** | Cryomancer | 100g | Deep Freeze | `rune_frigid_ranks` 3 → Frigid Grip<br>`rune_frostbite_ranks` 2 → Brittle Ice |
| **Rune of the Long Winter** | Cryomancer | 100g | *splash* | `rune_frigid_ranks` 3 → Frigid Grip<br>`rune_crystal_edge_ranks` 5 → Crystal Edge<br>`rune_hungering_ranks` 1 → Hungering Cold |
| **Rune of the Open Hand** | Holy Cleric | 100g | *splash* | `rune_triage_heal` 3 → Triage<br>`rune_zealous_mercy` 1 → Zealous Light<br>`rune_last_hope_pct` 5 → Last Hope |
| **Rune of the Standing Vow** | Devout | 100g | *splash* | `rune_blessed_barrier_ranks` 4 → Blessed Barrier<br>`rune_devoutness_ranks` 5 → Devoutness<br>`rune_pulse_ranks` 2 → Healing Pulse |
| **Rune of the Warded Robes** | Devout | 100g | Bulwark | `rune_blessed_barrier_ranks` 4 → Blessed Barrier<br>`rune_warded_ranks` 10 → Warded Robes |
| **Rune of the Long Hunt** | Survivalist | 100g | *splash* | `rune_potent_ranks` 1 → Potent Toxins<br>`rune_cruel_ranks` 15 → Cruel Devices<br>`rune_wire_ranks` 10 → Reinforced Wire |
| **Rune of the Weeping Wound** | Survivalist | 100g | Venom | `rune_coated_blades` 1 → Coated Blades<br>`rune_potent_ranks` 2 → Potent Toxins |
| **Rune of the Deepening Ruin** | Occultist | 100g | Ruin | `rune_deep_hex_step` 1 → Deeper Hex<br>`entropy_ranks` 5 → Entropy |
| **Rune of the Whispering Dark** | Occultist | 100g | *splash* | `rune_broken_will_ranks` 5 → Broken Will<br>`rune_spread_ranks` 15 → Spread of Madness<br>`rune_spread_ruin` 1 → Spread of Madness<br>`pleasure_pct` 0.5 → Pleasure from Pain |
| **Rune of the Deep Sight** | Sharpshooter | 100g | Precision | `rune_deep_focus` 8 → Deep Focus<br>`rune_perfect_form` 20 → Perfect Form |
| **Rune of the Bared Guard** | Swordmaster | 75g **SCARRED** | Blade | `rune_seasoned_off_bonus` 0.1 → Aggressive Stance<br>`rune_seasoned_def_bonus` -0.15 → Defensive Stance |

**TWO OF THE SIXTEEN STILL CARRY A NODE-KEYED CLAUSE** and it is one of §2's three each: the
Deepening Ruin's `entropy_ranks` and the Whispering Dark's `pleasure_pct`. They are the only two
runes in the game where §2 and §3 overlap, and any ruling on one has to be read against the other.

### THE DISTRIBUTION, AND WHY IT MATTERS TO A RETIREMENT PASS

**All 59 clauses sat in the 48 spec runes. The 5 universal and the 12 class-wide carried none.**

| spec | talent clauses of its total | runes among the sixteen |
|---|---|---|
| **Beastmaster** | **8 of 9** | **3 of 4** |
| Devout (Inquisitor) | 8 of 10 | 2 of 4 |
| Occultist | 8 of 10 | 2 of 4 |
| Survivalist (Mystic) | 7 of 10 | 2 of 4 |
| Sharpshooter | 7 of 10 | 1 of 4 |
| Cryomancer | 6 of 10 | 2 of 4 |
| Holy Cleric | 5 of 9 | 1 of 4 |
| Arcanist | 3 of 9 | 1 of 4 |
| Swordmaster | 3 of 8 | 1 of 4 |
| Berserker | 2 of 7 | 1 of 4 |
| Pyromancer | 2 of 10 | 0 of 4 |
| **Warden** | **0 of 7** | **0 of 4** |

**A retirement pass would take three of the Beastmaster's four runes and none of the Warden's.**
That is not a balance judgement — it is the shape of the authored pool, and it is the reason a
blanket ruling on the sixteen is a different decision from sixteen individual ones.

---

## §4 — WHAT THE DOCUMENTS SAY, AND WHAT IS LOST

**Both documents stated the lane rule as CURRENT and EJ confirmed both were accurate.** They are
corrected toward the code, per the standing rule.

- **`master.html`** now says the sets were *authored* to that rule and that **the rule no longer
  describes what the runes do**, states the charter and the 59/56/3 split, and carries the loss
  beside it. Its rarity paragraph no longer says *"talent-counter runes STACK with the talent"* as
  the mechanism; a rune's counter is its own and stacks where a hero holds both.
- **`docs/design-notes.md`** gains an EM section at the top (newest-first, the file's own order) and
  **the two AA-era paragraphs are kept in place and annotated rather than rewritten** — they are the
  argument the charter overrules, and deleting them would delete the record of what was traded away.
  One of them predicted this batch's cost almost exactly, and is annotated with what it got right.

### WHAT IS LOST, WHICH IS THE HALF A LATER READER WILL NEED

**48 of the 65 runes — 36 lane runes and 12 splashes — were built on the variance mechanism**, and
the mechanism is one sentence: *the same rune is worth more to a hero whose points went elsewhere
than to one already deep in that lane.* **A rune with its own field is worth the same to every hero
of its spec.** That is the power increment the rule was written to prevent, and it is now the
default.

**The splashes lose most.** A splash *"carries a term from every lane and pays for reaching outside
one"*; with no lanes to reach across, **a splash is three unrelated numbers in a bundle.** **SIX of
the twelve splashes are among §3's sixteen, against ten of the thirty-six lane runes** — so the
splashes are half-emptied where the lane runes are barely a quarter, which is the same finding EJ
reached from the clause side (36 talent clauses in the 36 lane runes, **23 in the 12 splashes**).

**The 36 `lane` fields are still authored, still shown, and now describe history** — where a rune
came from, not what it reaches. **That is the reason the tag work exists**, and a reader finding
flat runes later needs to know the cost was measured rather than overlooked.

---

## §5 — THE RUNE OF THE STANDING VOW, ON THE RECORD

**DO cut the `unity` half of Healing Pulse's trigger. It appears in no report, no changelog entry
and no state file; EJ found it by grepping.** This is the record.

**CONFIRMED TWO WAYS.**

1. **The guard chain, read off `battle.gd`.** The drip is inside `if u.has_status("cons_ground")`
   and there is no `unity` arm anywhere in the block: measured
   `guard_cons_ground=true guard_unity=false`. `battle.gd`'s own comment at the site says so —
   *"BATCH DO: the `unity` half is CUT WITH THE CLAUSE THAT PROMISED IT"* — **which is the whole
   point: the code recorded it and no document did.**
2. **Live, on an Inquisitor holding the rune and no talents.** Its three clauses read
   **`pulse=2 barrier=4 devoutness=5`**, which is exactly what the rune advertises.

**WHAT IT PAYS TODAY:** while Consecrated Ground holds, every non-companion hero regains **2% of
the Devout's maximum health** at the start of its turn, credited to him. Before DO it also fired
while the party held `unity`.

**IT IS A QUIET WEAKENING RATHER THAN A MIS-SALE**, and the distinction is the reason no repair is
proposed here. The rune's description reads *"holy ground mends 2% each turn"* and is byte-identical
before and after DO — **it never sold the `unity` half.** The code moved TOWARD the card. Nobody was
mis-sold; the rune got worse than it was, and no instrument in the project could see it.
**Whether to restore it, re-key it or leave it is unruled**, and it is in `docs/state.md`.

---

## §6 — VERIFICATION

### THE ORDER

**Documentation was written BEFORE the verification run**, and the baseline rows before it as well
— three of the six off three identical standalone readings apiece. `docs/state.md` and this report
were written before the run too; nothing in the tree reads either, verified comment-stripped rather
than recalled (the only two hits are a message STRING in `check_eb.gd` and `claude_md_census.py`,
neither of which reads the file).

### THE LIVE MEASUREMENT, BEFORE AND AFTER

**Six readings on five runes, taken on HEAD before any edit and again on the finished tree.**

| reading | BEFORE | AFTER |
|---|---|---|
| Still Wrist — a perfect Guard Change's parry grant, rune only | 15 | **15** |
| Whispering Dark — `broken_will` / `spread_ranks` / `spread_ruin` / `pleasure` | 5 / 15 / 1 / 0.5 | **5 / 15 / 1 / 0.5** |
| Whispering Dark — marks that spread, of 400 | 61 | **59** (unseeded 15% roll; 55–66 over six runs) |
| Bitter Grip — `_max_hero_rank` on both counters | 3 / 2 | **3 / 2** |
| Open Hand — triage / last_hope_pct / the party stamp / opening Mercy | 3 / 5 / 5 / 1 | **3 / 5 / 5 / 1** |
| Long Draw — opening Focus / muscle memory / Speed | 60 / 10 / 95 | **60 / 10 / 95** |

**Every deterministic reading is byte-identical. The one that moved is a 15% `randf()` with no
seed**, and it was re-run six times to say so rather than asserted to be noise.

**And a cfg-level census over ALL 116 stat clauses**, applied through `Talents.apply_payload` on
HEAD and again after: **56 clauses moved to a rune-owned key, 0 value mismatches, 0 unexpected
keys.**

### THE NEGATIVE CONTROLS

**Eight armed, and three of them did not bite the first time — which is the part worth recording.**

| control | armed on | disarmed reads |
|---|---|---|
| the DP dud, live | the spread guard reading the node's counter alone | **0 spreads in 400** (armed: 55–66) |
| `check_em` §1 | one clause re-keyed back onto the node | **2 failures** |
| `check_em` §2 | one **dotted** read site disarmed | **2 failures** |
| `check_em` §3 | a float `rune_` field added to `STAT_INT_KEYS` | **2 failures** |
| `check_em` §4 | one of the three with no home re-keyed | **red in §4 AND §2** |
| `check_em` §1's equality | an eleventh `UNIT_MATH` row | **1 failure** |
| the literal sweep | a needle both trees carry, broken | **LOST 1** |
| the literal sweep, second arm | the same injection against HEAD's copy | **LOST 0, GAINED 185** — directional, not noisy |
| the negative-pin pre-check | a retired string put back into `master.html` | **1 violation, named** |

**THE THREE THAT DID NOT BITE, AND WHY EACH IS A REAL LESSON.**

1. **The unpaired-read sweep read a clean ZERO while it was blind to 80 of its 85 sites.** Its
   regex excluded a match preceded by a word character **or a dot** — written that way to avoid
   matching `rune_X` — and `attacker.vulture` has a dot in front of it. **A control armed on the
   one `cfg.get("…")` site DID bite, and proved nothing**; the control that found the hole was
   armed on a dotted read. The guard that is actually wanted is *not already prefixed by `rune_`*
   and nothing else. `check_em` §2's header carries this.
2. **The literal sweep's first control was armed on a needle that was itself NEW**, so breaking it
   moved the GAINED count and left LOST at zero. A differential sweep can only be controlled on a
   needle **both** trees carry.
3. **Its second control replaced the needle with a string that CONTAINED the needle**
   (`aegis_ranks` → `aegis_ranks_X`), so `contains` stayed true. **A `contains` control has to
   break the substring, not extend it.**

**And one instrument was vacuous before it was right.** The negative-pin pre-check first read the
manifest's file field under the wrong key name, so every entry was skipped and it reported
**0 violations over 0 pins checked** — indistinguishable from a clean reading. It reports
**346 of 346 checked** now, and the control confirms it.

### THE INSTRUMENTS, AND WHERE THE PIN MANIFEST COULD NOT HELP

**The pin manifest was run against HEAD's copy BEFORE it was regenerated**, and `check_ed` read
**18 / 0**. Regenerating moved **three line-number references and nothing else: 0 pins lost, 0
gained.** That is not this batch being small — **it is the manifest not covering these pins.** The
26 assertions this batch actually broke live in array literals read through a variable
(`for pair in [...]` → `bsrc.contains(String(pair[0]))`), which the extractor classes as having no
static needle. **The instrument that found them was the literal sweep**, and it agreed exactly with
the set the suites reported when run.

**The literal sweep, both arms:** 11,249 needles from 88 targets against 38 haystacks.
**Current needles: 0 LOST, 220 GAINED.** **HEAD's needles: 26 LOST**, every one of them an
additive-units pin in `battle.gd`, every one repaired in place with the reason.

### THE TARGET REPAIRS, ALL IN PLACE AND ALL TO INTENT

**`check_dp` §4 is the one that mattered.** Two rows pinned the Whispering Dark as still writing
`spread_ranks` and `spread_ruin` — **the fields it SHARED with the node, which is exactly what the
charter removes.** Left standing they would have called a live rune dead. The repair asserts the
rune's own fields, **asserts their VALUES** (a rename that dropped the number would pass a name
check), and asserts the node's two fields are absent from the rune. §3's two read-site rows moved
with the code, and both the summing locals and the lines that define them are pinned.

**`check_dp` §4's GENERAL property did not move and could not have**: `code.contains(field)` is a
substring test and `rune_spread_ranks` contains `spread_ranks`. Worth knowing about that instrument.

**Two repairs in `test_runes` would have gone VACUOUS rather than red** and are the reason that file
was read line by line rather than trusted to its own verdict: `ceiling_writers` counted the old
field names and would have fallen 2 → 0 against a floor of 2, and `BOOLEAN_READ_FIELDS`' payload
lookup returned `null` on the bare name and `continue`d past its own assertion.

**And `test_batch_as` was reading 375 with a THROW**, not 394: `pool["bitter_grip"]["payload"]["stat"]["frigid_ranks"]`
raised on a missing key and the suite printed *"375 checks / 0 failures"* while nineteen assertions
never ran. **That is CD's lesson exactly** — a suite that throws is not a suite that passed — and it
is why the throw count is read beside the check count on every target in this batch.

### PREDICTIONS

**Predicted from what each target READS, not from what this batch writes.**

| target | reads | predicted | read |
|---|---|---|---|
| `check_em` | `LANE_TREES`, `runes.json`, the scripts | **NEW, 210 / 0** | *(below)* |
| `check_dp` | the Whispering Dark's payload + `battle.gd` read sites | **48 / 0** after the repair (was 43) | |
| `check_parse` | the battery's own target list | **161 / 0** — `check_em` joins `GATES` | |
| `test_batch_ak` | the Still Wrist's payload, live and applied | **496 / 0** (one assertion added) | |
| `test_batch_ax` | Spread of Madness's read-site literals | **350 / 0** (two pins became four) | |
| `test_runes` | `cfg.get` ordering, the boolean gate, the int restore | **3125 / 0** (two probes added) | |
| `test_batch_as` | the Cryomancer runes' payload keys | **394 / 0** — the baseline, restored from a THROWING 375 | |
| `check_ed` / the pin manifest | recorded pins | **18 / 0**, 0 pins lost or gained | |
| `check_da` | the corpus-walk fingerprint | **unchanged** — `check_em` reads ONE ability-source family and returns no corpus, so it needs no exemption | |
| `check_ek` / `check_el` | the tag population | **unchanged, 43 / 0 and 23 / 0** — §0 moved nothing | |
| `check_dv` §4 | the changelog's `<h2>` count | **pass** — a FLOOR (`>= 16`); the file goes 32 → 33 | |
| every target reading a document | `contains` on a fixed literal | **0 LOST needles**, proved by the sweep before the run | |
| everything else | — | **unchanged**: no ability, pool, node, magnitude or constant moved | |

### THE BATTERY

**ONE RUN, AND IT CERTIFIED ON PASS ONE.**

| | result |
|---|---|
| targets run / named in the manifest / logs on disk | **87 / 87 / 87**, and **0 duplicate names** |
| suite failures | **0** |
| suite throws | **0** — `throws=0` on all 87 lines |
| `Parse Error` / `SCRIPT ERROR`, grepped from all 87 log files | **0 matching logs** |
| `check_cm_live` (the recorded deliberate red) | **4** |
| `check_parse` | **161 / 0** |
| `check_em` | **210 / 0** |
| `check_de` | **358 checks / 0 failures / 0 NOTICES** |
| run harness gates 1/2/3 | **22 / 166 / 8**, throws 0 |
| `check_map_screen` | **OK**, 12 tag lines for 12 offered cards |
| `check_ct_map` | **83 / 0** |
| MD5 drift across 198 tracked files, absolute paths both times | **ZERO** |

**`check_de` READ 0 NOTICES**, which is the half worth naming: every one of the six baseline rows
this batch moved was written BEFORE the run, so the differ had nothing to report in either
direction. **EL's own record says that is what it missed** — it wrote two rows before its battery
and left `check_parse`'s until after, and the differ said so.

**THE FLOOR WAS RUN THE WAY THE BRIEF SPECIFIES**: `grep -lE 'Parse Error|SCRIPT ERROR'` across the
87 log files, off the streams — never a tally and never an exit code. **0 matching logs.**

**AND THE FREEZE HELD.** 198 files md5'd with ABSOLUTE paths before the run and re-compared after
with the same absolute paths: **zero drift.** The tree the battery read is byte-for-byte the tree
that ships.

### WHAT `check_em` PRINTS EVERY RUN

```
§1  116 stat clauses across 65 runes; 66 rune-owned; 304 node fields in the trees
    UNIT_MATH: 9 fields, all still node-written, 23 rune clauses riding them
§2  47 re-keyed counters, 97 reading statements, 0 taking only one half
§3  48 int clauses and 18 float clauses, each loading as its declaration
§4  3 clause(s) still writing a node's counter, all three named with their reason
```

**Every one of those is a population, printed and not asserted** — a rune added or retired moves
them and neither is a defect. **What is asserted is the property**, plus the two tables that are
judgements (`UNIT_MATH` and `NO_HOME`), both as EQUALITIES.

---

## §7 — WHAT IS DELIBERATELY NOT DONE

- **No rune retired, re-authored or retuned; no `lane` field removed; no magnitude moved.** §2 and
  §3 present options and author nothing, which is what the brief asked for.
- **The three clauses with no home still write the node's counter.** Named in the gate as an
  equality rather than left to be rediscovered.
- **No rune keys to a tag** (§0), and `check_ek` §3's population did not move.
- **The Rune of the Standing Vow is recorded and not repaired.** Whether to restore the `unity`
  half, re-key it or leave it is a design decision.
- **`pyromaniac_ranks` is still inert.** It was never in the 59 — nothing reads it, so no node
  counter is involved — and AR §4 still forbids inventing a read site.
- **The six "→ Talent:" log lines are unchanged.** Player-facing text, and the charter makes them
  worse rather than better (EJ §2b).
- **No sim, no balance judgement, no magnitude measured in play.** The live measurements in §6 prove
  the numbers did not MOVE; they say nothing about whether they were right.
- **`docs/rune-audit.html` and `docs/talent-audit.html` are untouched.** Both are CLOSED reports
  kept as written, which is the standing convention — and this batch read the rune audit as
  evidence rather than editing it.
