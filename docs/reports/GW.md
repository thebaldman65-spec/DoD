# Batch GW — Three runes, and a gate that wrote what it tested

*Branch `class-merge`, from `ed35334` (GV). `main` is untouched. **IMPLEMENT ONLY.** GV drove all
sixty live ordinary runes through the real door and came back with three findings it did not
repair: one rune that pays nobody anything, and two that charge a price for a payout their engine
withholds. GW wires the first, gates the other two's costs with their payouts, re-points the gate
that had been arranging its own subject, and sweeps every gate in the battery for that shape. No
rune was retuned, re-authored or retired; no engine, kit, pool, card or node moved.*

## NEEDS A RULING

**None of the four is player-visible on its own; the first two change what a rune is worth.**

1. **THE SHARED HIDE IS NOW WORTH WHAT EZ PRICED IT AT, AND NOTHING HAS EVER PAID THAT** (§1). The
   brief ruled the copy, so it is built. What the ruling moves is a MAGNITUDE that no player has
   ever felt: driven in a real fight, a companion's blow reads **+26.5% / +57.6% / +138.3%** across
   EZ's own three buff loadouts, against a rune that has paid **+0.0%** since it shipped. EZ's
   +25.0% / +56.2% / +133.6% were the multiplier function's returns on a field the gate had set by
   hand; these are damage. **The rune is unchanged in text, price and terms** — but a 100g rune has
   just gone from dead to the largest single damage swing a Beastmaster can buy, and whether that
   is the intended price is the designer's.
2. **THE TWO PRICES ARE OFF WITH THE ENGINE OUT, WHICH MAKES AN UNEQUIPPED ENGINE STRICTLY BETTER
   THAN IT WAS** (§3). Ruled by the brief and built. It is worth saying what it does at the table:
   a Holy Cleric who unequips Mercy while wearing the Martyr can now be healed by his party, and a
   Survivalist who unequips Trapper while wearing Thin Blood keeps his poison's damage. Neither
   buys anything back — the payouts stay off — so the rune is inert rather than negative. **The
   alternative nobody took**: unequip the rune with the engine, or say on a screen that it is
   sitting out (GV's ruling 3, still owed).
3. **§2's NINETY OTHER HAND-SETS ARE REPORTED AND RULED ON BY NOBODY** (§2). Ninety-two sites in
   nine files arrange a rune, an engine or a talent field rather than letting the game write it.
   Two were the defect and are repaired; the other ninety are on the right body, and repairing them
   is a change to ninety checks. `check_gw` §2 holds the count at a ceiling so it cannot grow in
   silence. **Whether that batch is worth taking is the designer's**, and FZ's pricing rule applies.
4. **`check_ez` §4's WRITER SWEEP WAS REPAIRED TO INTENT RATHER THAN EXEMPTED** (§1a). It accused
   the new copy — a script writing a `rune_` field — and the charter it enforces is that
   `runes.json` decides a rune's MAGNITUDE. A carry between units decides nothing. The sweep now
   separates the two and asserts the carries by name, so a second one reds. **The alternative was
   an exemption for one file**, which is the shape `check_ds` already ruled against.

## THE SHORT VERSION

- **THE SHARED HIDE PAYS SOMEBODY NOW** (§1). `Talents.apply_payload` writes `rune_shared_hide`
  onto the HUNTER and `_shared_hide_mult` reads it off the COMPANION; `_do_summon` carried it in
  neither the cfg nor the hunter's-own-terms copies below it, so a 100g rune multiplied a beast's
  blow by exactly 1.0000 for everyone who ever bought it. One line, beside `crit_bonus` and
  `companion_power`.
- **AND IT IS THE ONLY `rune_` FIELD THAT HAS TO CROSS** (§1b). All 120 declared on `BattleUnit`
  traced to every line that reads them: **one** has a read site whose receiver is a companion, 2
  more could reach one but sit behind `has_engine("trapper")` which a companion can never satisfy,
  10 are read off the HUNTER by construction, 10 more are read off a body a companion can be but
  for runes no Hunter can hold, 25 are read off the ACTING unit (a companion never acts), and 72
  are reached only through a walk of `heroes`, which a companion is not in.
- **THE GATE WROTE WHAT IT TESTED** (§1a, §2). `check_ez` §5 set `rune_shared_hide` on the BEAST by
  hand and read 1.25 back — the one path a real run never takes — so it could not fail however
  badly the rune was wired. Re-pointed to equip; **breaking the copy on purpose takes it red**, and
  it did not before. `check_gv` §1 drove the same rune through the real door in the same tree,
  measured 15 damage in all four arms, and recorded that as EXPECTED: two instruments, one rune,
  opposite readings, both green.
- **THE SWEEP: 92 SITES IN 9 FILES, AND ONLY THE BODY SEPARATES THEM** (§2). Ninety set the field
  on the same unit the game writes it to; **two set it on a body the game never writes it to**, and
  those two are the ones that hid a dead rune. `check_fx` §4 is the legitimate pattern and says so
  in its own header — a PLUMBING half through the real door beside a READ-SITE half off a hand-set
  value.
- **THE MARTYR AND THIN BLOOD DID NOT SLIP GV's CENSUS** (§3). Both are `Runes.ENGINE_READ` rows
  already and the table's own header names them as the two. The offer door has never offered either
  to a hero with his engine out; what it cannot reach is a rune he has already BOUGHT. **So the fix
  is the cost, not the table** — each price now reads its payout's own predicate.
- **AND NO OTHER RUNE HAS THE SHAPE** (§3b). Swept over the 25 ungated runes and re-derived over
  the other 33 gated ones: every other price is inside its engine's block, reads a meter only the
  engine installs, or lands on a card that sits out with the engine. GV's "exactly two" holds.
- **THE WITHHELD CACHE ROW IS RULED AS GV BUILT IT** (§4), and the reasoning was already recorded
  in two of the three places it belongs — `run_state._engine_seated`'s header and `CLAUDE.md`'s
  FD §1 block, both written at GV. `master.html` described the behaviour without the reason; it
  carries it now.
- **VERIFICATION:** **120 targets, `check_de` 497 / 0, harness 22 / 382 / 8 throws=0**, on a tree
  stamped by md5 before and after (367 files, one moved and named below), with no `Parse Error` or
  `SCRIPT ERROR` in any of the 120 logs. **The only reds are the two standing sanctioned ones, and
  both are byte-identical to HEAD's own** — `check_cm_live` 13 / 4 and `check_gj` 70 / 1 at
  +158 / 178. **Six injected defects across five isolated copies, each bit and each named its own
  defect**; the player's four saves are byte-identical to the backup taken before any Godot process
  ran.

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `docs/state.md` whole, `docs/reports/GV.md`, `CLAUDE.md`'s working
agreement, ceiling, rune and instrument blocks, `docs/instrument-rules.md`'s index and the blocks
this batch writes into, `docs/ways-of-working.md`, and the code the brief names —
`Talents.apply_payload`, `_do_summon`, `_shared_hide_mult`, `_companion_hit`, `check_ez` §5,
`Runes.ENGINE_READ`, and the read site of every field the sixty live ordinary runes write.

| The brief says | Verdict | What the repo says |
|---|---|---|
| GV found FP's 43 was 33 rows plus two it never counted | Held | GV §3a: of FP's 43, thirty-three are rows, ten are not, and two outside it are (Grace and Open Hand). |
| the slots-versus-owns question had no observable answer — 111 identical FAIL lines | Held | GV's verification: the ownership injection and the no-gate injection printed the same 111 FAIL lines byte for byte, because nothing sells or discards an engine rune. |
| `Talents.apply_payload` writes `rune_shared_hide` on the HUNTER | Held | `data/runes.json`'s `{"stat": {"rune_shared_hide": 1}}` lands on the hero cfg at the spawn. |
| `_do_summon`'s cfg never copies it to the COMPANION | **Held, and wider than the cfg** | The cfg is the BODY the beast is built from (health, sheet, stats). The hunter's own terms are copied AFTER `_make_unit` — `crit_bonus`, `companion_power` — and the field was in neither. The repair is in the second group, and the report says why. |
| The rune has been dead since it shipped | Held | Shipped at EZ §4; `_shared_hide_mult` has read `comp.rune_shared_hide` since the day it was written. |
| `check_ez` **set the field on the beast directly** | **Held; the section is §5, not §4** | `check_ez.gd:888`, inside `_s5_the_read_sites`. GV's report and `docs/state.md` both call it "§4"; §4 is the payload section and its arms are sound. |
| the rune looked alive for batches while paying nobody | **Held, and sharper than stated** | `check_ez` §5 asserted **1.25**; `check_gv` §1, in the same tree, drove the same rune through the real door, measured **15 damage in all four arms** and asserted it DEAD. The tree held both readings, green. |
| the summon path is the only place a hero's fields have to cross onto another unit | **Held, and now derived** | §1b traces all 120 `rune_` fields to every line that reads them: `_shared_hide_mult` is the only read site whose receiver is a companion. |
| the Martyr and Thin Blood each take their price with no engine equipped while the payout is gated | Held | GV §3b measured both (a heal of 40 landing 0 against 46; a poison ticking 0 against 3). The price sites are `unit.heal_amount`'s absolute refusals and `battle._apply_poison`, neither of which read an engine. |
| **FIRST CHECK WHETHER THEY SHOULD SIMPLY BE IN THE 35** — if they slipped the census, that is the finding | **They did not slip it** | `Runes.ENGINE_READ` carries `martyr_fk` → `mercy` and `thin_blood` → `trapper`, and the table's own header names them as the two that are *worse than nothing*. **The fix is the cost, not the table.** |
| sweep the other 25 ungated runes | Held as a population | 60 live ordinary runes − 35 rows = 25, which is exactly `check_gv`'s `GROUPS`. |
| the withheld cache row: **record the reasoning with it** | **Already recorded, in two of three places** | `run_state._engine_seated`'s header and `CLAUDE.md`'s FD §1 block both carry it, written at GV. `docs/master.html` described the behaviour and not the reason; GW adds it there. |
| **this is the shape FA §1b already earned a rule for** — *run the unmodified gates against new code* — pointed at gates rather than at briefs | **Only in part** | FA §1b is already about GATES (`docs/instrument-rules.md`), not about briefs; the brief that rule was learned on is a different block (`CLAUDE.md`'s *verify the brief against the repo*). The §2 shape is adjacent to FA §1b but distinct — that rule is about WHEN to run a gate, this one is about what a gate may ARRANGE — so it is written as its own block, pointing at FA §1b. |
| GU found four save files — a run is in progress | Held | Four files. All backed up and hashed before any Godot process ran (§6a). |
| the 52 engine-bound gates are the next stage | Held | Step 6 of the merge's running order, untouched. |

## §1 — THE SHARED HIDE PAYS SOMEBODY

### §1a — The defect, the repair, and where it goes

**THE RUNE'S FIELD LANDS ON ONE UNIT AND IS READ OFF ANOTHER.** `Talents.apply_payload` writes
every `rune_` field onto the hero's cfg at the spawn, which is what every rune in the game does.
`_companion_hit` multiplies its `raw` by `_shared_hide_mult(comp)`, whose first line is
`if comp == null or comp.rune_shared_hide <= 0: return 1.0` — **read off the COMPANION**. Nothing
carried it across, so the function returned exactly 1.0 for every hunter who has ever bought the
rune.

**THE COPY GOES BESIDE `crit_bonus` AND `companion_power`, NOT IN THE CFG.** `_do_summon` builds a
`cfg` and then calls `_make_unit`; the cfg is the BODY (name, sheet, sprite scale, max health, and
the five stats a beast inherits), and the three lines under `_make_unit` are the hunter's own terms
handed across. A rune flag is the second kind. Putting it in the cfg would also mean declaring it
on every other `_make_unit` caller, which builds heroes and enemies.

**AND THE REPAIR MOVES A MAGNITUDE, WHICH IS WHY GV DID NOT TAKE IT** (CQ §6). The brief ruled it;
§1c prices what the ruling is worth.

### §1b — Every other `rune_` field the summon cfg does not carry

**THE POPULATION IS THE 120 `rune_` FIELDS DECLARED ON `BattleUnit`**, every one of them written by
a rune's payload. **A first pass read only `payload.stat` and reported one orphan** —
`rune_split_tongue`, whose rune writes it from inside an `also` block, which is the nested form
`Talents.apply_payload` re-enters at the top. It is Split Tongue's, retired at FC §3, and its read
site is deliberately kept and reachable by nothing (the `rune_entropy_ranks` contract). Each field
was traced to every
line in `scripts/` that reads it, with the receiver at that line, and each receiver traced to what
can be bound to it. **A field needs to cross only if a read site can take a COMPANION as its
receiver.**

| why it does not have to cross | count |
|---|---|
| **IT DOES** — `_shared_hide_mult(comp)` reads it off the companion | **1** |
| a companion CAN be the receiver, and a Hunter CAN hold the rune — **but the read sits behind `has_engine("trapper")`, and a companion holds no engine** | 2 |
| a companion CAN be the receiver, but **no Hunter can hold the rune**, and a companion's `pack_master` is always a Hunter | 10 |
| read off the **HUNTER** (or `comp.pack_master`), so there is nothing to carry | 10 |
| read off the **ACTING** unit, and a companion never acts | 25 |
| reached only through a walk of `heroes`, which a companion is not in, or another receiver proven not to be one | 72 |

**THE ONE THAT DOES**: `rune_shared_hide`. Repaired.

**THE TWO THAT COULD AND CANNOT**: `rune_thin_blood` and `rune_second_barb`, both read at
`_resolve`'s counter-hit off `strike_target` — which IS a companion whenever an enemy strikes one,
because `_hero_side()` includes living companions. Both sit inside
`if strike_target.has_engine("trapper")`, and a companion's `engines` is empty for the life of the
fight (`check_gw` §1b asserts it on a live board). **Carrying either would pay exactly nothing**,
and carrying it "for completeness" is the widening `CLAUDE.md`'s companion block already rules
against: a term the beast cannot use, hung on a chip, reads as working.

**THE TEN READ OFF THE HUNTER** are the ones that make the summon path look like the place a
Beastmaster rune lives: `rune_bared_fang` (read at `_companion_hit` off `comp.pack_master`),
`rune_second_whistle`, `rune_shared_scent`, `rune_companion_hp_pct`, `rune_quick_whistle_ranks`
(all four read at `_do_summon` off `hunter`), `rune_long_leash`, `rune_absolute_step`,
`rune_wild_communion_step`, `rune_momentum_ranks` and `rune_answering_pack`. **Every one of them
is about a companion and none of them belongs on one.**

**THE STRUCTURAL FACTS THE OTHER EXEMPTIONS REST ON, ASKED OF A LIVE BOARD** (`check_gw` §1b), not
read off the source: a companion is **not in `heroes`** (so every `for h in heroes` walk misses
it); it is in **neither array `_next_unit` picks from** — that function walks `heroes + enemies`
and a companion is in neither, which its permanent `next_time` of INF says a second way — so it
never takes a turn and `_resolve`'s `attacker` is never one; it **IS in `_hero_side`**, which is
what makes `strike_target` the receiver worth checking at all; and it **holds no engine**.

### §1c — What the wiring is worth, driven

**EZ MEASURED THE MULTIPLIER FUNCTION; THIS MEASURES THE BLOW.** EZ's three loadouts, rebuilt at
the powers that reproduce its own products exactly (Warcry 25, Empower's flat 1.25, Battle Shout 15
and the Pivot at 30 — Battle Shout's power is Bleed-derived and the Pivot's is the stance's, so
neither has a default), on a Beastmaster wearing the rune through the real door, forty seeded blows
an arm:

| loadout | multiplier, GW | EZ's multiplier | 40 blows, rune worn | not worn | swing | EZ's swing |
|---|---|---|---|---|---|---|
| thin — Warcry alone | ×1.2500 | ×1.2500 | 406 | 321 | **+26.5%** | +25.0% |
| mid — Warcry + Empower | ×1.5625 | ×1.5625 | 506 | 321 | **+57.6%** | +56.2% |
| deep — Warcry + Empower + Battle Shout + Pivot | ×2.3359 | ×2.3359 | 765 | 321 | **+138.3%** | +133.6% |

**THE MULTIPLIERS ARE EZ's TO FOUR PLACES AND THE DAMAGE RUNS A LITTLE ABOVE THEM**, because a blow
is an integer: `maxi(int(round(raw * (1.0 - armor))), 1)` rounds a bear's ten-point blow up slightly
more often than down. **The "not worn" column is 321 at every loadout**, which is EZ's own finding
restated in damage — four party buffs standing on the beast and paying nothing.

**AND THE MEASUREMENT HAD TO BE BUILT TWICE, WHICH IS WORTH RECORDING.** The first draft gave the
foe a million health so the blows would have room, and read **400,198 damage over twelve blows with
a +0.0% swing**: at a million's scale every percentage-of-health term in the file swamped the
companion's ten-point blow. The second draft dropped the inflation and used a **Canis**, and read
×1.19 against a multiplier of ×1.2500 — the gap was the wolf's own **Bleed**, whose burst lands
inside the same `await` and which this rune does not multiply. **The bear is the one companion
whose blow can be read alone**: Ursus's only rider strikes the bodies BESIDE the target. Both
readings are in `check_gw`'s own comments so the next batch does not rediscover them.

## §2 — A GATE THAT WRITES WHAT IT TESTS

**REPORT ONLY. NOTHING THE SWEEP FOUND WAS REPAIRED** except the two sites that are this batch's
own subject.

**THE POPULATION** is every battery target that is a `.gd` file (115 names read out of
`run_battery.sh`'s own `SUITES` and `GATES` arrays, 117 files with both fixtures), and the fields
are the **120 `rune_` fields** declared on `BattleUnit`, **`engines`**, and the **16 talent-only
stat fields** `talents.gd` writes — the twelve that are also base stats (`attack`, `armor`,
`speed`, `crit_bonus`, `max_hp_pct`, `max_resource`, `no_cover`, `parry_bonus`, `deflection`,
`dmg_bonus`, `dmg_taken_bonus`, `pierce_bonus`) are named and excluded, because a gate setting
`attack = 5000` on a dummy is dressing a board and not arranging a talent. Comments are stripped
first (`check_ds`'s ruling).

**92 SITES IN 9 FILES AT THE RECON, AND 90 ON THE LANDED TREE** — the two that came out are the
two this batch repaired. The table below is the recon's reading, with `check_ez` at 29; it is 27
now, and `check_gw` §2 holds the total at a ceiling of 90.

| file | kind | sites | what it arranges | what it would therefore miss |
|---|---|---|---|---|
| `check_ez` | RUNE | **29** → **27** | each rune's own field on the hero it drives, and **twice on the BEAST** | the payload failing to reach a live unit; and, for the two on the beast, the field failing to CROSS — which is exactly what happened |
| `check_fx` | TALENT | **28** | each node's own field on the hero | nothing it does not also ask: **§4a is a PLUMBING half** that reads the same fields off a spawn through the real door, per class |
| `check_fo` | RUNE | **12** | `rune_hex_deepen` and `rune_shared_mark` on their own holders | the payload failing to reach a live unit — covered since GV by `check_gv` §1, which drives all sixty through the party dict |
| `check_gp` | ENGINE | **8** | `h.engines = []` / `u.engines = [eng]` after the spawn, to make the two arms | `Runes.held_engines` or the spawn's own `cfg["engines"]` failing — a hero who equipped his engine rune arriving in a fight without it |
| `check_go` | ENGINE | **6** | the same, per arm | the same |
| `check_cs` | RUNE | **4** | `rune_long_draw_presses` on the Sharpshooter | the same as `check_fo` |
| `check_gt` | ENGINE | **2** | `h.engines = []` for the sits-out arm | the same as `check_gp` |
| `test_batch_bp` | ENGINE | **2** | `wd.engines = []` / `["heavy_plating"]` | the same as `check_gp` |
| `check_gs` | ENGINE | **1** | `h.engines = []` for a bare cast | the same as `check_gp` |

**THE BODY IS WHAT SEPARATES A LEGITIMATE ARRANGEMENT FROM THE DEFECT, AND IT IS THE HALF A SWEEP
CAN FIND.** Ninety of the ninety-two set the field on the same unit the game writes it to, so the
question they ask about the READ SITE is real; what they cannot see is the field failing to arrive.
**Two set it on a body the game never writes it to at all** — `check_ez`'s
`beast.rune_shared_hide`, twice — and those are the two that hid a dead rune for batches.

**THE LEGITIMATE CASE, NAMED.** `check_fx` §4 is the pattern, and its own header states the rule
this batch is writing down: *"§4 HAS TWO HALVES AND BOTH ARE NEEDED. (a) PLUMBING: the node's value
is on the unit after the spawn, per class … (b) THE READ SITE: the attached field moves the thing
it is read into. Neither half proves the other: a field can land and be read nowhere, and a read
site can be live while the spawn never writes it."* **That header names EZ's Shared Hide as the
defect it was built against**, one batch before anybody found it. Its twenty-eight hand-sets are
half an instrument whose other half is fifty lines up.

**THE NINETEEN ENGINE SITES ARE THE SAME SHAPE ON A DIFFERENT SUBJECT** and are reported rather
than ruled on. `h.engines = []` after the spawn arranges the very contrast the assertion is about;
the honest form is `Runes.engine_pouch_for_spec(spec)` with `equipped` set in the party dict before
the scene instantiates, which is what `check_gv` and `check_gw` use. What they would miss is a
break in `Runes.held_engines` or in the spawn's reading of it — covered since GV, but by another
gate rather than by their own pairing.

**WHY IT IS NOT REPAIRED HERE.** It is a change to ninety checks across nine files, and a batch
that rewrites ninety checks while changing the game is a batch nobody can read. `check_gw` §2
re-derives the count off the battery's own target list every run and fails only when it GROWS.

## §3 — THE MARTYR AND THIN BLOOD

### §3a — They did not slip the census

**BOTH ARE `Runes.ENGINE_READ` ROWS ALREADY**, and the table's header names them: *"TWO OF THE
THIRTY-FIVE ARE WORSE THAN NOTHING WITHOUT THEIR ENGINE … the Martyr's price (no heal but his own)
and Thin Blood's (his poison stops biting) are read with no engine at all, while what each pays for
is read only under it."* `martyr_fk` → `mercy`; `thin_blood` → `trapper`. `check_gw` §3 asserts both
rows before it drives anything, because the brief's first question decides whether the fix is the
table or the cost.

**SO THE OFFER DOOR IS NOT THE HOLE.** Neither rune is offered to a hero whose engine is out, at
the Peddler, a cache, a bargain or an event verb. **What the door cannot reach is a rune he has
already BOUGHT** — GV's ruling 3 — and that is the whole of §3.

### §3b — The repair, and the predicate

**THE COST READS THE PAYOUT'S OWN PREDICATE, COPIED RATHER THAN RE-DERIVED.**

| rune | the price, and where it is read | the payout, and where it is read | the gate now |
|---|---|---|---|
| **the Martyr** | `unit.heal_amount` — an absolute refusal beside Weight of Ruin's and Blight the Well's: an ally's heal returns 0 | `_on_martyr_struck`, a Mercy stack, and Mercy is the Holy Cleric's ENGINE — installed at the spawn only for a holder | `has_engine("mercy")` |
| **Thin Blood** | `battle._apply_poison` — the tick is overridden to 0 | `_resolve`'s counter-hit barb, inside `if strike_target.has_engine("trapper")` | `has_engine("trapper")` |

**`has_engine("mercy")` RATHER THAN THE BAR ITSELF.** `second_resource_name == "Mercy"` is written
at the spawn off exactly that set, so the two agree by construction; what they do **not** agree
about is a FULL bar, which refuses the stack for one blow and must not take the price off with it.
The engine is also what the rune's own `ENGINE_READ` row names.

**DRIVEN, BOTH RUNES, BOTH ARMS, PRICE AND PAYOUT TOGETHER** (`check_gw` §3):

| arm | the Martyr: an ally's heal of 40 | its payout | Thin Blood: his poison's tick | its payout |
|---|---|---|---|---|
| engine EQUIPPED, rune worn | lands **0** | the rune's own log line fires | **0** | the striker is poisoned after twelve blows |
| engine merely OWNED, rune worn | lands **46** | nothing | **3** | the striker is clean |
| engine equipped, no rune | lands | — | bites | — |
| engine owned, no rune | lands | — | bites | — |

The 46 and the 3 are GV's own figures, reproduced.

### §3c — The sweep for the same shape, and it found nothing else

**THE 25 UNGATED RUNES.** Four carry a cost at all — `Runes.RUNE_SHAPES`' `TRADEOFF` secondary —
and in each the cost is either ungated beside an ungated payout, or is itself unreachable without
the engine:

| rune | its cost | verdict |
|---|---|---|
| **Bared Plate** | he can no longer Block (`rune_no_block`) | both halves ungated: the +25% Break damage is read at the strike line with no engine either. **No shape.** |
| **Bared Fang** | the companion can no longer be healed (`no_heals` at the summon) | both halves read `hunter.rune_bared_fang` with no engine gate. **No shape.** |
| **Blood Debt** | none of his — the TARGET pays | the rune removes a cost; without the engine he keeps that and loses the Frenzy steps. **No shape, and the inverse.** |
| **Glass Prison** | both cells are glass: any damage shatters them | `_on_glass_shatter`'s first line is `if not _is_held(victim): return`, and nothing is held without Permafrost. **The cost is refused without the engine.** |

**Ashfall is the inverse case and is named because it reads like the shape**: its cost is *"and so
refunds no Mana"*, and the Overburn refund it taxes does not exist without the engine — so the rune
is worth MORE to a hero without one, which is what GV recorded.

**AND THE OTHER 33 GATED RUNES WERE RE-DERIVED, BECAUSE GV's "EXACTLY TWO" IS A CLAIM.** Six carry
a `TRADEOFF` besides the Martyr and Thin Blood, and every one of their costs is unreachable with the
engine out: **Open Wound**'s decay needs `_living_occultist()` *and* a Ruin stack, and `_gain_ruin`
lays none without the engine; **Long Draw**'s miss drains Focus, which only Lethal Aim installs;
**Pyre Debt**'s recoil is inside `_overburn_refund`, whose first line refuses a hero without
Overburn; **Dissonance**'s taken curve reads a Resonance meter that is not installed; **Naked
Blade**'s doubled downside is inside `if strike_target.has_engine("seasoned")`; and **Bare Altar**'s
halved absorb lands on Divine Shield, which is Conviction's own enabler and leaves the kit with the
engine (GT's sits-out rule). **GV's two is two.**

## §4 — THE WITHHELD CACHE ROW

**RULED AS GV BUILT IT.** A queued cache row whose engine is unequipped sits out of the answer,
stays in the stored triple, and is offered again the moment the engine is back.
`map_screen._pick_rune` indexes the list the buttons were built from, and the overlay names the rune
it waits on.

**THE REASONING WAS ALREADY BESIDE IT IN TWO OF THE THREE PLACES**, both written at GV, which is
the premise this section was asked to check rather than to assume:

- `scripts/run_state.gd`, above `_engine_seated`: *"An unequipped engine is the player's own
  reversible choice: repairing its runes out of the triple would let one toggle before an answer
  cost the cache for good, and store that loss."*
- `CLAUDE.md`'s FD §1 block: *"A RE-ASK FOR A STATE THE PLAYER CAN UNDO FILTERS; IT DOES NOT
  REPAIR (GV)."*

**WHAT WAS MISSING IS THE PLAYER-FACING DOCUMENT.** `docs/master.html` described the behaviour —
*"it keeps them stored instead, names the rune they wait on, and offers them again the moment it is
equipped"* — and gave no reason, so the obvious-looking fix (FD's literal write-back) reads as an
oversight there. The reason is in it now: **a retirement and an already-owned rune can never come
back, and an unequipped engine is one press from being undone — a state the player can undo is not
a state to destroy.** The block is also marked RULED in `CLAUDE.md` rather than *owed*.

## §5 — WHAT IS DELIBERATELY NOT DONE

- **NO RUNE IS RETUNED, RE-AUTHORED OR RETIRED.** The Shared Hide's text, price, terms and
  multiplier are byte-unchanged; what moved is a copy at the summon.
- **§2 IS A REPORT.** Ninety of the ninety-two hand-sets stand. Repairing them is its own batch.
- **THE CROWN's RESISTANCE, SANCTITY's HONEST TEXT AND THE ENGINE CARDS** are ruled and queued.
- **THE 52 ENGINE-BOUND GATES** are the next stage.
- **NO ENGINE, KIT, POOL, CARD OR NODE CHANGED.**
- **GV's RULINGS 3 AND 5 ARE STILL OWED** — a bought rune whose engine is dropped keeps its slot
  and says nothing on any screen, and the rune layer's lineage narrowness. §3 makes the first of
  those *inert* rather than *negative* for the two runes it names; the shape is unchanged.

## §6 — VERIFICATION

### §6a — The player's files

**FOUR SAVE FILES, BACKED UP AND HASHED BEFORE ANY GODOT PROCESS RAN**, as GU found them and as GV
left them, into `save-backups/GW-20260920-093448/`:

| file | md5, before and after |
|---|---|
| `profile.json` | `ed4144e1db2b21943929491378192680` |
| `relics.json` | `fdc12ffa02bf6e18289928bd6998a673` |
| `run_save.bin` | `25582edd0b040f7fd2e487037090c65d` |
| `settings.cfg` | `0c1b39c343382611fd6e340673ae5580` |

**All four are byte-identical afterwards.** Every gate refuses to start against the player's run save
(`check_gw` §0 and `check_gv` §0 assert `save_path != SAVE_PATH` and stop if it is), and every
isolated copy had `config/name` changed before anything ran in it, so its `user://` could not reach
them.

### §6b — The unmodified gates against the new tree, before one assertion was edited (FA §1b)

**THE WHOLE BATTERY, 115 TARGETS, ON THE REPAIRED CODE WITH EVERY GATE AS HEAD LEFT IT.** Four reds,
three of them predicted:

| target | reading | predicted? |
|---|---|---|
| `check_gv` | 874 / **3** | **yes, all three**: §1's `DEAD` row now pays, and §1b's two prices are off |
| `check_ez` | 106 / **1** | **NO** |
| `check_cm_live` | 13 / 4 | the standing sanctioned red |
| `check_gj` | 70 / 1, `+158 / 178` | the standing sanctioned red, and **its figures did not move** |

**THE ONE THAT WAS NOT PREDICTED IS THE ENTRY WORTH HAVING, AND IT IS NOT THE ONE ANYBODY WOULD
GUESS.** `check_ez` §5 — the section written FOR the Shared Hide — **stayed green while the rune was
wired for the first time in its life**, because it supplies the field itself. What went red was §4's
writer sweep, a different section accusing the repair for a different reason: a script assigning a
`rune_` field, which its charter reads as `runes.json` losing its monopoly on a rune's magnitude. **A
carry between two units decides no magnitude**, so the sweep is repaired to intent (a right-hand side
that reads the same field off another unit is a propagation) and asserts the carries by name, so a
second one reds.

**AND `check_gv` §1's LINE IS THE MEASUREMENT GV PROMISED.** It read
`shared_hide DEAD equipped {dealt: 18} / {dealt: 15}  owned {dealt: 18} / {dealt: 15}` — against the
15 in all four arms GV recorded. **It pays on BOTH engine arms**, which is independently what moves
the rune into `CARD` rather than into the gated table.

### §6c — The acceptance run

**120 TARGETS.** `check_de` **497 / 0** over every log, the run harness **22 / 382 / 8** with
`throws=0`, `check_parse` **194 / 0**, and **no `Parse Error` or `SCRIPT ERROR` in any of the 120
logs**. Every predicted baseline was met exactly: `check_parse` 194, `check_ez` 114, `check_gv` 877,
`check_gw` 76, `check_de` 497 — all written into `baselines.json` **before** the run.

**THE ONLY REDS ARE THE TWO STANDING SANCTIONED ONES, AND BOTH WERE DIFFED AGAINST HEAD'S OWN
READING** in an isolated rebuild of `ed35334`: `check_cm_live` 13 / 4 and `check_gj` 70 / 1, with
their FAIL lines **byte-identical** to HEAD's. `check_gj`'s gold figures did not move — GV recorded
+158 / +178 and this tree reads the same, so none of GW's three repairs reaches its seeded run.

**THE TREE WAS STAMPED BY md5 BEFORE AND AFTER — 367 files, and ONE MOVED, WHICH IS THE NEXT
PARAGRAPH.**

### §6d — The doc edit the battery caught, and the re-run that proves it

**THE FIRST ACCEPTANCE RUN WAS 120 TARGETS WITH THREE REDS RATHER THAN TWO**: `test_batch_bx` 157 / 1,
`§4: master.html reads companion everywhere it is prose`. **It was this batch's own doc edit.** BX §4
bans the common noun *beast* from that document — the spec name and *Bestial Wrath* are the two
exceptions — and the companion bullet GW added used it twice.

**REPAIRED, AND THE RULE REPRODUCED RATHER THAN ASSUMED**: the gate's own strip (`Beastmaster` and
`beastmaster` removed, then a case-insensitive search for `beast`) run over the edited file reads
**0 strays**.

**THE RE-RUN'S POPULATION IS EVERY TARGET THAT READS THAT FILE, NOT THE ONE THAT CAUGHT IT.** Thirty-
five of the battery's targets open `docs/master.html` — twenty-three suites and twelve gates — and a
one-word change to a text corpus can move any of them. **The md5 stamp is what bounds it**: of the
367 files stamped before the acceptance run, exactly one differs, and it is `docs/master.html`. The
thirty-five were re-run against the repaired file through a copy of the runner (`./run_battery.sh a b`
replaces SUITES only and would have run every gate as well), and **thirty-seven targets came back and exactly ONE reads differently from the acceptance run:
`test_batch_bx`, 157 / 1 → 157 / 0.** Every other count and every other failure count is identical,
which is the proof the word moved what it was meant to move and nothing else. `check_de` refuses a
subset run on principle — *a subset run cannot certify the tree*, naming all 79 targets that did
not run — and that refusal is the differ doing its job rather than a red.

**AND THREE FILES DIFFER FROM THE ACCEPTANCE FREEZE, NOT ONE, WHICH IS SAID HERE RATHER THAN
ROUNDED DOWN.** `docs/master.html` is the fix above; `docs/reports/GW.md` and `docs/state.md` are
this batch's RECORD of the run, which cannot be written before it. Neither is opened by any target —
`res://docs/reports` appears in no `FileAccess` call in the tree, and `docs/state.md` is opened by
exactly one (`check_es`'s `CENSUS_DOCS_SWEPT`, which sweeps it if it carries the claim and does not
require it to). **Asserted rather than argued**: the five document instruments were re-run against
the final tree and every one reads exactly what the acceptance run read — `check_es` 57 / 0,
`check_ec` 24 / 0, `check_ed` 18 / 0, `check_fg` 22 / 0, `check_fr` 25 / 0.

**THE ISOLATED COPIES LEFT USER-DATA FOLDERS**, six of them, each renamed before anything ran in it
so its `user://` could not reach the player's saves: "Dawn of Decay GW head", "… GW probe", "… GW
nocopy", "… GW martyr", "… GW thin", "… GW writer" and "… GW body". They can be deleted.

### §6e — The controls

**SIX INJECTED DEFECTS ACROSS FIVE ISOLATED COPIES, EACH ON ITS OWN COPY, EACH NAMING ITS OWN
DEFECT.** The Martyr's and Thin Blood's are split rather than combined, because two reverts in one
copy print one FAIL line each and a single copy cannot say which assertion caught which.

| the injection | gate | reading | what its FAIL line said |
|---|---|---|---|
| **the copy at `_do_summon` deleted** — the brief's own control | `check_gw` | **76 / 13** | the companion's copy `0 against the hunter's 1`; the multiplier `1.0000`; the blow `+0.0%` over 40 seeded strikes, *under 12.5%, half the multiplier's own swing* |
| the same | `check_ez` | **114 / 3** | `§5b: …and _do_summon carried it onto the companion (0)`, `§5b: …and the hide multiplier reads 1.0000 against 1.2500`, and §4's named-carry list emptied |
| the Martyr's cost gate reverted | `check_gw` | **76 / 1** | `§3: [engine merely owned] the price is OFF — an ally's heal lands 0` |
| Thin Blood's cost gate reverted | `check_gw` | **76 / 1** | `§3: [engine merely owned] the price is OFF — his poison ticks for 0` |
| a script DECIDING a rune magnitude (`comp.rune_bared_fang = 0.5`, beside the carry) | `check_ez` | **114 / 1** | `§4: a script DECIDES a rune-owned field … ["scripts/battle.gd writes rune_bared_fang"]` |
| a gate setting the field on the BEAST again | `check_gw` | **76 / 2** | `§2: the shape GREW to 91 sites against a ceiling of 90`, and `1 of the two sites GW repaired still set … on the BEAST` |

**THE FIRST ROW IS THE ONE THE BRIEF ASKED FOR AND IT HAS A SECOND HALF.** `check_ez` goes to
114 / 3 on a tree where the Shared Hide is dead. **HEAD's `check_ez` reads 106 / 0 on a tree where
the Shared Hide is equally dead** — that is what HEAD is. A gate that could not see this defect
demonstrably sees it now.

**AND THE LAST ROW CAUGHT A DEFECT IN THE INSTRUMENT ITSELF BEFORE IT WAS ARMED.** §2's wrong-body
arm read **2 on a repaired tree**, because `check_ez`'s new §5b COMPARES `beast.rune_shared_hide`
against what it expects and a substring needle cannot tell `==` from `=` — the gate was accusing the
repair for being written about. It counts a write now, and its needle is taken from the gate's own
list rather than invented, because a receiver spelled any other way would not arm it.

