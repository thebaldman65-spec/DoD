# Batch GM — Hold Breath, and cards that outlive their engine

*Branch `class-merge`, from `a93112e` (GL); `git ls-remote origin class-merge` read `a93112e` before the push. `main` is
untouched. **IMPLEMENT ONLY.** Four repairs in two game scripts, one new gate, three gates moved, four standing rules,
and the documents.*

## NEEDS A RULING

**Only what a player meets, or what blocks the ruled work, is here** (`docs/ways-of-working.md`). Everything else is in
`docs/state.md`'s queue.

1. **WHAT ELSE LEAVES WITH AN ENGINE — "ITS CARDS" IS THREE POPULATIONS, AND ONLY ONE IS DROPPED** (§2b).
   - **Dropped (built):** the three opening-kit cards the usability door refuses without their engine — Death Ray,
     Resurrection, Kill Command.
   - **Not dropped — the cards that half-work without their engine.** By GL's own test that is **eight opening-kit
     cores** (Wildfire, Arcane Cannon, Renewal, Blessing of Zeal, Hunter's Instinct, Aimed Shot, Hold Breath, Shrapnel
     Charge). **GL's "five" is a different cut** — cards whose payload sits inside the engine's block — and **four of
     those five are EARNED zone-boss cards** (Hamstring, Venom Coating, Pinning Shot, Called Shot); only Shrapnel Charge
     is in a kit. Taking a half-working card away takes something the hero can use.
   - **Not dropped — the earned cards that need an engine.** About twenty draft and zone-boss cards are refused at the
     door with their engine gone (§2b's table). **An earned card is never lost (EG)**, so for these "leaves" could only
     mean "sits out the fight", which is a new rule rather than the enabler's.
   **The honest answer is that the three populations need different treatment**, and the batch did not pick for the
   other two.
2. **"EXACTLY AS ITS ENABLER DOES" HAS TWO MORE HALVES, AND NEITHER IS BUILT** (§2c). An enabler travels to another
   hero of the class who takes the engine, and sits outside the slot count. A bound card does neither: a Pyromancer who
   takes Resonance second gets no Death Ray, and an Arcanist with no Resonance still has three of his slots counted
   for the two cards left. Both would move something a player can count; the ruling named only the leaving.
3. **KILL COMMAND IS NOT QUITE "NEVER USABLE" WITHOUT PACK BOND** (§2d). Call the Wilds, a Beastmaster draft card,
   summons a companion through `_do_summon` with no engine check, and a living companion is all Kill Command's door
   asks. It leaves with the engine anyway, because the ruling names it — so an engine-less Beastmaster who earned Call
   the Wilds loses a card he could have cast. `check_gm` §2 pins the exception.
4. **THE SPLIT SHIELD ASKS FOR A HERO, AND ITS HALF IS CALLED "BULWARK LINE"** (§3a). The rune's text gives half the
   wall to "the ally he sets it in front of", which is a choice, so **Shieldwall with the rune now opens a target
   picker** over the other living heroes (a companion never rolls Block, so none is offered; the rune says *ally*). The
   half is EZ's `bulwark_line` status — the table's choice — so the ally's chip and the block log read ***Bulwark
   Line***, the name of a talent node FX deleted. The chip's own line reads *"Split Shield: +12% Block chance…"*.
   Renaming the chip is a player-facing word. **And, as with every rune, Shieldwall's own card is not rewritten by it**:
   its text still says +25% to a Warden whose wall is split.
5. **DISPEL WAS REPAIRED, ON THE CARD TEXT'S AUTHORITY** (§3c). The brief asked whether Dispel should remove any mark
   the heroes laid, and said the card text decides. **It does not**: Dispel strips *"three beneficial ones from an
   ENEMY"*, and a mark on an enemy is the heroes' work against it. `DISPEL_NEVER`'s own comment already ruled the same
   for eight marks. Hunter's Mark, Arcane Echo and Rime were in neither list, so a Mage's Dispel took all three; they
   are in `DISPEL_NEVER` now. **If the designer reads it as an unstated cost instead, it is three ids to take back.**
   **And Rime is tagged an affliction but sits outside `DEBUFF_IDS`** — listing it there would also let a mender's
   Cleansing Rite take it and a Survivalist count it, which is a magnitude.
6. **A LETHAL AIM HOLDER'S AREA CASTS, CALLED VOLLEY AND DRUMFIRE NOW SPEND THE BREATH** (§1c). They were paid the
   guaranteed critical on every target and kept the breath, because the engine block left all three out. It is the same
   defect inside the engine and the repair closes it, but a Sharpshooter player can feel it.
7. **THE BARE-NUMBER LABEL SURVIVES — ON DIVINE PLEA, NOT RESURRECTION** (§2f). An engine-less Holy no longer holds
   Resurrection, so its *"1"* is gone with the card; one who drafted **Divine Plea** (Mercy 2) sees
   *"Divine Plea   2 "* — driven. The label reads `second_resource_name`, which is empty without Mercy. Not fixed, as the
   brief said.

## THE SHORT VERSION

- **§1 — HOLD BREATH IS SPENT WHERE IT PAYS.** The countdown left the Lethal Aim block and sits under the payout's own
  gate. **Seeded, same dice both sides: with no engine, six Quick Shots after one cast read 27.0 on HEAD — the status
  standing after all six — and 17.3 on GM, the first shot 26 and the other five 15.6.** GL's reading was 15.0 → 26.2.
  With Lethal Aim both read 18.5, identical. **The sweep for the shape found one**: of 171 status ids, 45 have a spend
  site, six have every spend gated, and only Hold Breath is laid and paid outside that gate; no charge-like field is.
- **§2 — AN ENGINE'S BOUND CARDS LEAVE WITH IT (RULED, BUILT).** `Classes.ENGINE_BOUND` names three;
  `Classes.opening_kit` takes them out beside the enablers. What "its cards" means is three populations (ruling 1). **No
  path drops an engine inside a fight** — every writer of an engine's slot is on the map or in `run_state.gd`, and a
  drop written mid-fight moved nothing in that fight (driven).
- **§3 — THE SPLIT SHIELD WORKS, AND ITS GATE CASTS THE CARD.** Shieldwall's handler reads `_recast_writes`; with the
  rune it names a hero and splits the wall 12 / 12. **Dispel leaves the heroes' three.**
- **THE BRIEF'S PREMISES:** 32 checked — 20 held, 7 held with a correction, 3 did not hold as written, and 2 are
  readings of the brief's own words (§0).
- **HEAD'S UNMODIFIED INSTRUMENTS AGAINST GM'S CODE, BEFORE ANY OF THEM MOVED:** 46 of 46 suites green, and three
  gates red — `check_el` (predicted: fifteen ids where it pins twelve), `check_cm_live` (the sanctioned red, its four
  lines word for word GL's) and **`check_di`, which nobody predicted: its call-site tripwire read 215 against 214,
  because the Split Shield's half is a new `_apply_status` site.** **Every other count in all 110 targets is GL's
  acceptance reading, target for target.**
- **NEW GATE `check_gm`: 101 checks.** Against HEAD's game code it reads **101 / 23**, every red on a repaired
  behaviour; against GM's, 101 / 0. **Three gates moved**: `check_ez` §5 casts the card (104 → 106), `check_el` counts
  fifteen (23, unchanged), `check_di` pins 215 (44, unchanged).
- **VERIFICATION:** three batteries — HEAD's unmodified instruments against the new code first, then a pre-pass and an
  acceptance run over the landed tree, the last predicted in writing: **`check_de` 461 / 0 / 0, 46 of 46 suites, 58 of
  59 gates with only the sanctioned red, zero error lines, and the tree and the saves identical before and after.**

---

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md`, `docs/state.md`, `docs/reports/GL.md`, `docs/kit-recon.html`,
`docs/ways-of-working.md`, `docs/reports/GK.md`, and the code each premise names.

| The brief says | Verdict | What the repo says |
|---|---|---|
| GL found four defects live today, reproduced in real battles on an isolated copy | **HELD** | GL's probe: 13 checks / 0 failures, on Hold Breath, the three dead buttons, Split Shield and Dispel (GL's log, recovered from its scratchpad) |
| Two are ruled here; the rest are reported | **READ, NOT CLEAR** | §1 and §2 carry instructions; §3 says "repair both" for Split Shield and "report whether" for Dispel. GM repaired Split Shield on that instruction and **Dispel on the card text's authority** (ruling 5) |
| GL found nine of seventeen premises did not hold | **HELD** | GL §0: seven held, one held as a ruling, nine did not hold as written |
| Only nine engines bring enablers, not twelve | **HELD** | Sixteen enablers across nine lineages |
| Rage is not an engine; Blood Frenzy is | **HELD** | `classes.gd`'s Warrior config; GL §0 |
| The Mage pool holds seven class cards, not six | **HELD** | Mana Shield joined at DY §1 |
| After one cast every hit is a guaranteed crit that ignores armour; six shots kept the status; the mean went 15.0 → 26.2 | **HELD** | GL's log: three shots before the cast (14, 15, 16), six after (25–28), the status standing after each. GM's seeded re-run on HEAD: 15.0 → 27.0 |
| With Lethal Aim held, the first shot consumes it as intended | **HELD FOR A SINGLE-TARGET SHOT, NOT FOR ALL** | A Lethal Aim holder's area casts, Called Volley and Drumfire were paid the promised shot and kept it — the engine block excluded all three (§1c) |
| The consumption is written into the node rather than the status | **HELD, ONE WORD CORRECTED** | It sat in the **engine's** block — Lethal Aim, a rune since GK — not in a talent node |
| After the merge nobody is guaranteed any node at all | **CORRECTED** | A talent cell a class has bought is worn by every hero of that class (FX). What nobody is guaranteed is an **engine**: any can be dropped (GK) |
| GL found this one by driving it | **CORRECTED** | GL found it by reading — its hand reading and its Hunter census pass, independently — and then drove it |
| A status whose expiry lives in a talent never expires for anyone without that talent | **HELD AS A SHAPE** | The census (§1d) found one instance, and its gate was an engine |
| GK's interim keeps the lineage kit, leaving three buttons that can never be used and an exploit | **HELD, ONE CORRECTION** | GK §5's own table lists all three. **Kill Command can be used** by an engine-less Beastmaster who earned Call the Wilds (§2d) |
| The enabler travels already | **HELD** | `Classes._carry_enablers`, and the enabler leaves with the engine in `opening_kit` |
| GL found five lineage cards that only half-work | **HELD IN COUNT, MISREAD IN KIND** | Four of the five are **earned zone-boss cards**; only Shrapnel Charge is a kit card. GL's recon counts **eight** kit cores that half-work (§2b) |
| That is a different population from the three | **HELD** | Disjoint |
| Dropping is done from the map's rune pouch | **HELD, ONE MORE** | `Run.toggle_engine` from the pouch; the map's debug reroll also clears every engine, before a new class selection |
| Confirm no path drops an engine while its cards are cooling down, queued or mid-cast | **CONFIRMED** | Static census and a drive (§2e) |
| Resurrection's button shows a bare "1", which survives the fix | **HELD, ON ANOTHER CARD** | Resurrection leaves with Mercy; **Divine Plea** keeps the bare number (§2f) |
| Split Shield does nothing in a fight: the cast lays the full 25 on the Warden and nothing on the allies | **HELD** | The rune names ONE ally, "the ally he sets it in front of" |
| `check_ez` §5's comment says the table "is the same answer the cast itself uses" — it is not | **HELD** | Verbatim: *"driving it is driving the same answer the cast itself uses"* |
| The comment is the shape found in a comment, a header, a document and a manifest | **HELD** | EB §2's rule, in `docs/instrument-rules.md` |
| Dispel removes the heroes' own Hunter's Mark | **HELD, AND TWO MORE** | Rime and Arcane Echo too (§3c) |
| A class card moved into a kit leaves the class pool, a spine-taker's whole supply | **HELD** | GL ruling 2 |
| EB ruled the core the baseline; class cards are deliberately weaker | **HELD** | EB §1; the header over `CLASS_DRAFT_POOLS` |
| The nine missing engine runes | **HELD** | Fifteen of the charter's twenty-four exist |
| Divine Shield's recast check ignores the Bare Altar rune | **HELD** | The cast halves the absorb under the rune; the table proposes the full 35% — the Split Shield gap pointed the other way (queued, as ruled) |
| Every class basic advertises a Perfect it can never reach | **HELD** | GL item 7 (queued) |
| About a dozen card texts say what the code does not do | **HELD** | GL item 8 names sixteen cards; GM adds Hold Breath's inert *"+40 Focus"* for a hero with no Lethal Aim |
| The bot casts only five of the 64 candidates inside its engine-specific logic | **AMBIGUOUS, AND LOW** | Five are cast **only** inside an engine branch — all five the Warrior's; the Mage, Cleric and Hunter branches key on the card. **Three are never cast at all**: Powershot, Tripwire and Mana Shield (§5) |
| GL's drive: 13 checks, 0 failures, on an isolated copy | **HELD** | GL's probe log |
| "…and the stamp" | **READ AS `master.html`'s** | GM changes what a player meets, so `master.html` moved and its stamp with it |

**Tally: 32 — 20 held (the confirmed instruction and the shape among them), 7 held with a correction, 3 did not hold
as written** (the guarantee a node gives, GL's "found by driving", the bot's count), **and 2 are readings of the
brief's own words** ("two are ruled", "the stamp").

---

## §1 — HOLD BREATH IS SPENT WHERE IT PAYS

### 1a. The repair

The payout is two reads in `_resolve`'s strike loop: the guaranteed critical (`held_breath and ab.damage > 0 and not
is_counter`) and the ignored armor. **The countdown sat inside `if attacker.is_hero and attacker.has_engine("lethal_aim")
and ab.damage > 0 and not is_counter and not _focus_safe(ab) and ab.display_name != "Drumfire" and target is an
enemy`.** A hero without the engine was paid on every attack and never spent it.

**Moved, not rewritten**: the same countdown now sits just after the Lethal Aim block, under the payout's own gate —
`attacker.has_status("held_breath") and ab.damage > 0 and not is_counter`. **Repaired where the status is spent, not
where the engine reads it**: the other available fix, gating the payout on Lethal Aim as well, would have turned the
card into a button that does nothing for a Sharpshooter without the rune.

`_resolve` sends specials, heals and whole-cast misses down other branches, so the new block has exactly the
reachability the old countdown had: a cast that reaches the strike loop spends one shot; a whole-cast miss spends none,
as before.

### 1b. The drive — six shots with the engine and without

**`gmprobe/drive_gm.gd`, run in an isolated copy of HEAD and one of GM** (each its own `user://`), seated through
`gate_fixture.spawn` with the fixture's deterministic rolls, and the damage roll **seeded identically in both copies**
(4242 before the three base shots, 777 before the six), so HEAD and GM draw the same dice.

| Sharpshooter lineage, Quick Shot at a full-health enemy | three shots before the cast | six after one Hold Breath | the first of the six | the other five | the status after each |
|---|---|---|---|---|---|
| **GL** (HEAD, unseeded, no engine) | 14, 15, 16 — **15.0** | 25, 26, 25, 28, 28, 25 — **26.2** | 25 | 26.4 | standing after all six |
| **HEAD, no engine** | 15, 15, 15 — **15.0** | 26, 27, 28, 26, 27, 28 — **27.0** | 26 | 27.2 | standing after all six |
| **GM, no engine** | 15, 15, 15 — **15.0** | 26, 15, 15, 16, 17, 15 — **17.3** | **26** | **15.6** | **spent by the first** |
| HEAD, Lethal Aim | 15, 15, 16 — 15.3 | 34, 14, 15, 16, 15, 17 — 18.5 | 34 | 15.4 | spent by the first |
| GM, Lethal Aim | 15, 15, 16 — 15.3 | 34, 14, 15, 16, 15, 17 — **18.5** | 34 | 15.4 | spent by the first |

**With no engine the mean falls from 27.0 to 17.3**, and the one shot that is still a critical is the promised one.
**With Lethal Aim nothing moved** — the two rows are the same shots.

### 1c. The three casts the engine block left out

The old block also excluded `_focus_safe(ab)` (area casts and Called Volley) and Drumfire. **So a Lethal Aim holder's
area cast took the promised critical on every target and kept the breath.** Driven, a breath laid before each cast:

| Lethal Aim holder casts | HEAD: breath after | GM: breath after |
|---|---|---|
| Drumfire | **standing** | spent |
| Called Volley (area) | **standing** | spent |
| Wildstrikes (an area card from the corpus) | **standing** | spent |

**A counter swing spends nothing on either side** — the critical is not paid to a counter, and the spend's gate is the
payout's. (The armor read does not skip counters: FOUND AND NOT FIXED.)

### 1d. THE SWEEP — THE SAME SHAPE ELSEWHERE

**The question:** is there a status, charge or bank a card lays whose consumption or expiry sits behind a gate the card
does not require — an engine, a spine switch, a talent's guard — while its payout is read outside that gate?

**The method** (scripts in the session's scratchpad, not the tree):

1. `battle.gd` and `unit.gd` read as logical lines — continuations joined, comments stripped with quote tracking and
   **string contents kept**, because this codebase's reads are string-keyed.
2. **Every site's EFFECTIVE gates**: its enclosing `if`/`elif`/`else` chain (an `elif` carries its earlier siblings,
   negated); the early `if …: return` guards above it in its own function; and **the gates every caller of its function
   carries**, intersected, recursively. A negated `or` guard is a hard gate on each term; a positive `or` is a weak one.
3. Gates tokenised: `has_engine("x")`, the spine switches, `second_resource_name ==`, a living engine holder, a talent's
   `*_ranks > 0`, a companion's presence.
4. **For every status id: where it is LAID, where its payout is READ, where it is SPENT** (`remove_status`, or an
   `update_status` writing a decremented power). **A suspect**: every spend carries a gate that some lay site and some
   read site do not.
5. **The same over unit FIELDS that behave as charges** (decremented or zeroed outside a reset function).

**The instrument was proved before its result was trusted**: its first version marked a negated `or` guard as weak and
missed `_gain_faith`'s guard; both were repaired, and Hold Breath — the known case — is flagged by every version.

| Population | Censused | With a spend site | Every spend gated | **Laid and paid outside that gate** |
|---|---|---|---|---|
| Status ids (literal) | **171** | **45** | **6** | **1 — `held_breath`** |
| Charge-like unit fields | — | **68** | **10** | **0** (two flagged, both read by hand as false: `healed_externally` is read only inside the Endurance talent's block; `faith_peak` is laid and spent only while a Conviction holder lives) |

The other five every-spend-gated statuses are a talent's own chip laid under its own gate (`bracing`, `deathwish`,
`endurance`, `killing_edge`) and the companion's `loyalty` chip, which is read only where a companion stands.

**THE RELATED SHAPE — A CARD'S OWN PAYLOAD INSIDE AN ENGINE'S BLOCK.** A card-keyed census (`ab.display_name ==` or
`ab.special ==` sites whose effective gates carry an engine) returns fourteen names. Ten are cards whose payload IS the
engine's own — Focus, Resonance, Ruin, Blood Frenzy, the Pack Bond strike — the card reading the engine, GL's
ALMOST/BOUND. **The other four are GL's five less Venom Coating, which is keyed on its status rather than its name and
reads the same way**: Shrapnel Charge's Poison and Slow, Hamstring's Slow, Exposed and hit-and-run, and Venom Coating's
poison inside Trapper's block; Pinning Shot's Daze and Called Shot's rider inside Lethal Aim's. **Not
repaired** — the brief asked for the sweep to be reported, and moving each is a card's behaviour for every hero without
the engine (ruling 1). BV moved Loaded Shot out of the Survivalist's block and Crossfire out of the Sharpshooter's
for this reason.

**AND ONE LAYER OVER — RUNES.** Ten live spec-scoped runes are read only under their lineage's engine or its second
resource — Ember Leap, Pyre Debt, Half Note, Overtone, Resonant Core, Carried Mercy, Keen Focus, Standing Wall, Naked
Blade, Whetstone — so each pays nothing to a lineage hero who dropped the engine, **and a rune's scope is the lineage,
so he is still offered them** (FOUND AND NOT FIXED).

**Coverage, stated:** literal status ids only (a removal by variable — the dispels and cleanses — is left out, which
can only make the census stricter); a caller's gate counts only if every caller carries it; `battle.gd` and `unit.gd`
only.

---

## §2 — AN ENGINE'S BOUND CARDS LEAVE WHEN THE ENGINE LEAVES

### 2a. What was built

- **`Classes.ENGINE_BOUND`** — `{"arcanist": ["Death Ray"], "holy": ["Resurrection"], "beastmaster": ["Kill
  Command"]}` — and `Classes.engine_bound(spec)`. **Authored, as the enablers are**, and checked in both directions
  live (`check_gm` §2).
- **`Classes.opening_kit`**: `gone` is `core_enablers(spec) + engine_bound(spec)` when the lineage's engine is not
  held. **One line, at the line that already took the enablers out**, so every reader of the kit — the battle spawn,
  the hero sheet, `Runes.kit_names`, the loadout panel — moves with it.
- **Its own table, not more names in `enablers`.** An enabler is what the engine needs; a bound card is what needs the
  engine. `enablers` also drives travel, the slot count and `test_batch_bo`'s no-pool assertion, and a bound card does
  none of those.

**Driven** — every lineage's kit, engine held and dropped (the probe's arm B):

| Lineage | Leaves with the engine |
|---|---|
| Arcanist | Arcane Explosion *(enabler)*, **Death Ray** |
| Holy | Heal, Hymn of Hope *(enablers)*, **Resurrection** |
| Beastmaster | the three summons *(enablers)*, **Kill Command** |
| Swordmaster, Pyromancer, Cryomancer, Devout, Occultist | their enablers only, as before |
| Berserker, Warden, Sharpshooter, Survivalist | nothing, as before |

### 2b. WHAT "ITS CARDS" MEANS — THREE POPULATIONS

| Population | Members | What they do with the engine gone | Treatment |
|---|---|---|---|
| **Bound opening-kit cards** | Death Ray, Resurrection, Kill Command | **refused at the door** — Resonance, Mercy, a companion | **DROPPED (built)** |
| **Half-working opening-kit cards** (GL's ALMOST) | Wildfire, Arcane Cannon, Renewal, Blessing of Zeal, Hunter's Instinct, Aimed Shot, Hold Breath, Shrapnel Charge | cast, and do part of what their text says | kept — ruling 1 |
| **GL's five** (payload in the engine's block) | Shrapnel Charge *(kit)*; Hamstring, Venom Coating *(Survivalist boss pool)*; Pinning Shot, Called Shot *(Sharpshooter boss pool)* | cast, and lose the rider | kept — ruling 1; four are earned |
| **Earned cards the door refuses** | see below | refused at the door | kept — ruling 1; **an earned card is never lost** |

**The earned population, read live** (`gmprobe/earned_bound.gd`): every lineage seated with its engine gone and its
whole draft and zone-boss pool on the bar, on a board built to allow everything no engine gives — full resource, no
cooldowns, a burning, a chilled and poisoned and a low-health enemy, and a fallen hero for each check:

| Lineage | Refused with the engine gone |
|---|---|
| Arcanist | Arcane Bolt, Unmaking, Stabilize — Resonance |
| Holy | Divine Plea — Mercy |
| Devout | Blessing of the Faithful — Faith; Aegis Reversal — a divine barrier, which only the enabler Divine Shield lays |
| Beastmaster | Twin Hunt, Savage Sweep, Ghostpack, Bestial Wrath, Spirit Bond — a companion (**Call the Wilds opens all five**); Unleash, Primal Surge — Loyalty |
| Swordmaster | Battle Poise, Counter Time — the Defensive guard (**an earned Precision Strike, Feint or Wheeling Cut can reach it**) |
| Cryomancer | Winter's Toll, Rimebinding, Cryoclasm, Shatter — a Glacial Hold |
| Occultist | Transference, Requiem — Ruin on the field |
| Warden, Berserker, Pyromancer, Sharpshooter, Survivalist | none |

**Twenty-one cards across seven lineages.** Reprisal was refused too and is not engine-bound (it needs healing landed
in the last two turns). **Coverage:** the engine-held arm confirmed the meter-gated ones open with the engine; the
hold-, Ruin-, guard- and barrier-gated ones it did not build, and those are read, not driven.

### 2c. What "exactly as its enabler does" leaves unbuilt

- **Travel.** An enabler comes with the rune to any hero of the class. A bound card does not — the ruling names only the
  leaving, and travelling would put Death Ray in a Pyromancer's kit.
- **The slot.** `Run.ability_slots_used` counts `Classes.lineage_slots(spec)`, which is not engine-aware. **So the slot
  a bound card held stays counted and no magnitude moved** — `check_gm` §2 pins it for all three lineages. An Arcanist
  with no Resonance opens with two lineage cards in three counted slots.

### 2d. Kill Command's earned exception

`_do_summon` checks no engine, and Call the Wilds calls it. **Driven** (`check_gm` §2): an engine-less Beastmaster
carrying an earned Call the Wilds casts it, a companion stands, and `_ability_usable` would pass Kill Command — which is
off his bar all the same.

### 2e. Mid-fight — no path drops an engine while its cards are live

**Every writer of an engine's slot state**, derived by census (`engines =`, `["equipped"] =` across `scripts/`):
`Run.awaken` (class selection), `Run.hold_rune` (a rune taken — it only ADDS, slotted if a slot is free, and overrides
the `equipped` its caller set), `Run.toggle_engine` (the map's rune pouch), the map's debug reroll (clears every
engine, then class selection), and the fixtures and the sim. **None is in `battle.gd`**, and no battle path reaches the pouch.

**The battle reads the member's engines once, at the spawn** — into `BattleUnit.engines` and the opening kit — and
`has_engine` reads the unit. **Driven** (`check_gm` §2; the probe's arm F): an Arcanist's engine dropped through
`Run.toggle_engine` in the middle of a fight, with Death Ray cooling down — the fight kept its engine, its bar and the
cooldown; the member's next fight opened with *Magic Bolt, Arcane Cannon, Arcane Barrage*. A quit fight restarts
straight into the battle (GF), so no pouch sits between a quit and its restart either.

### 2f. The bare label — driven

| | Button text |
|---|---|
| Holy with Mercy, Resurrection | `Resurrection   1 Mercy` |
| Holy with no engine, Resurrection | *(not on the bar)* |
| Holy with no engine, an earned Divine Plea | **`Divine Plea   2 `** |

`_ability_popup_button` appends `faith_cost` and `second_resource_name`, which is empty without Mercy. Not fixed
(ruling 7).

---

## §3 — THE SPLIT SHIELD, AND DISPEL

### 3a. The Split Shield works in a fight

**The defect** (GL, re-driven): the rune lives in `_recast_writes` only — the table proposed 12 for the Warden and 12 of
`bulwark_line` for an ally — while Shieldwall's handler laid `SHIELDWALL_BLOCK` on the Warden and never read the rune.

**The repair:**
- **The handler reads the table.** Its own write is `_recast_writes(attacker, ab, attacker)[0]`, and with the rune the
  hero it was set in front of takes `_recast_writes(attacker, ab, target)`. **One answer by construction**: the next
  rune that moves Shieldwall moves the cast in the same line. The chip prints what stands after `add_status` took the
  larger power and never assigns a smaller one (CP §0).
- **The target.** Shieldwall is a self-cast; with the rune it names a hero. `_player_turn` offers
  `_split_shield_allies(u)` — the other living heroes — in the picker (auto-picked when there is one), the bot takes
  the weakest of them, and **a Warden standing alone sets it in front of nobody: the target is himself and he keeps his
  half.**
- **The node's pass.** Bulwark Line's loop skips the hero the split already covered, who holds the larger of the two
  (EZ's `maxi`). No talent writes `bulwark_ally_block` since FX, so that path is dormant either way.

**Driven** (probe arm C/G; `check_gm` §3):

| | Warden's wall | Hero he set it in front of | Other heroes |
|---|---|---|---|
| HEAD, with the rune | 25 | nothing | nothing |
| **GM, with the rune** | **12** (the table's) | **12 Bulwark Line, 3 turns** (the table's) | nothing |
| GM, without it | 25 | nothing | nothing |
| **GM, a whole bot turn with the rune** | **12** | **12** (the bot chose the Arcanist) | nothing |
| GM, alone with the rune | 12 | — | — |

The half reaches the Block roll: `_plating_slice(ally)` reads 0.12.

### 3b. `check_ez` §5 casts the card

Its arm drove `_recast_writes` and its comment called that the cast's answer. **Repaired both**: the comment says what
was true from EZ to GM and why it is true now, and **two arms cast Shieldwall with the rune and assert what landed
equals the table** — the Warden's half and the ally's. **104 → 106.** The instrument rule it earns is in
`docs/instrument-rules.md` beside EB §2's: *a gate that drives a stand-in drives the thing as well.*

### 3c. Dispel — the card text decides, and it decides "bug"

- **The text:** *"strip THREE harmful effects from an ALLY, or THREE beneficial ones from an ENEMY."* A mark the heroes
  laid is not beneficial to the enemy wearing it.
- **The project had already ruled it** — `DISPEL_NEVER`'s comment: *"left to the derived rule they read as 'beneficial
  effects on an enemy', and DISPEL WOULD STRIP THE PARTY'S OWN WORK"* — for eight marks.
- **Whether ANY party-applied status is taken — the population.** `_dispellable_buffs` is everything on an enemy in
  neither `DEBUFF_IDS` nor `DISPEL_NEVER`. **116 of the 156 status ids are in neither**; read by where each is applied,
  every one is hero-side except four: `shielded` (an enemy's own ward — rightly taken) and **`party_mark`,
  `arcane_echo` and `rime`**, the heroes' work. `ward`, `high_guard` and `roar` looked enemy-side by their apply
  expression and are not (a heal's Perfect on an ally, a parrying hero, the bear).
- **The repair:** all three into `DISPEL_NEVER`, with the reason at the site. **Rime is not a mark** — its card is tagged
  an affliction — and it goes there rather than into `DEBUFF_IDS` because that list also moves a Survivalist's breadth
  and a mender's rite.
- **Driven** (probe arm D; `check_gm` §4): HEAD — Dispel may take all three and does; GM — it may take none and all
  three stand; **an enemy's own ward is still taken on both.**

### 3d. `check_el`'s stale comment, behind the same defect

`check_el` §1 derives MARK's cards from `DISPEL_NEVER`, and carried the two outside marks in
`MARKS_OUTSIDE_DISPEL_NEVER` with the comment *"so `Dispel` never had a reason to be told about them"* — **the
reasoning that left the defect in place.** Repaired: the constant is gone (both marks are read out of the list),
`NOT_A_MARK` gains `rime` with its reason, and **the size pin moves 12 → 15 with its reason**. MARK's population is
still ten. **Its count stays 23.**

### 3e. `check_di`'s call-site tripwire — the one unpredicted red

`check_di` §1 walks every `_apply_status(` call in `battle.gd` with a balanced-paren parser and asserts the population
**equals** `CALL_SITES` — deliberately a tripwire, and its comment block asks any batch that moves it to say why. **The
Split Shield's half is a new call site**, so the unmodified gate read 215 against 214 in the reconnaissance battery.
The site passes the Warden as its source, so `with_src` read 111 against GL's 110 and the unstamped remainder stayed
104 — exactly one arrival, stamped. **Moved to 215 with its paragraph**; its count stays 44.

---

## §4 — NOT DONE, AS RULED

- No kit pick; the kits are built from protected cores, and the picks are a conversation.
- The nine missing engine runes are not authored.
- The Crown's Break and freeze resistance is not addressed.
- No pool merge, no talent node, no rune cost.

## §5 — THE QUEUE GL LEFT, CONFIRMED NOT REOPENED

Divine Shield's recast check and the Bare Altar (re-read: the cast halves, the table does not); the basics'
unreachable Perfect; the card texts; the sim bot. **The bot's item, sharpened** (a census of the bot's pickers over the
64): **five candidates are cast only inside an engine branch, and all five are the Warrior's** — Bloodlust, Wildstrikes
(Blood Frenzy), Guard Change (the stances), Shieldwall, Mocking Blow (Heavy Plating) — because the Mage, Cleric and
Hunter branches find a card by name whatever the hero holds. **Three are never cast by the bot at all: Powershot,
Tripwire and Mana Shield** — the last because the bot's draft wrapper asks `Classes.draft_ability`, which does not
resolve a vault card re-homed into a class pool. **A kit sim holding any of the eight measures a hero who does not use
it.**

---

## FOUND AND NOT FIXED

All of it is in `docs/state.md`'s queue.

1. **A COUNTER UNDER A HELD BREATH IGNORES ARMOR AND SPENDS NOTHING.** The critical read and the spend skip counters; the
   armor-bypass read does not. Bounded by the next real attack; true of every Lethal Aim holder before GM.
2. **HOLD BREATH'S "+40 Focus" IS INERT WITHOUT LETHAL AIM**, and the card says *"your"*.
3. **TEN LIVE SPEC RUNES ARE READ ONLY UNDER THEIR LINEAGE'S ENGINE**, and are still offered to a lineage hero who
   dropped it (§1d).
4. **NOTHING LISTS WHICH STATUSES THE HEROES LAY ON AN ENEMY.** GM's census was static and read by hand; `check_gm` §4
   drives the three it found.
5. **THE BOT'S DRAFT WRAPPER CANNOT SEE MANA SHIELD** (§5).
6. **DIVINE SHIELD'S TABLE AND ITS CAST DISAGREE UNDER THE BARE ALTAR** — GL's, re-read; the mirror of §3a.

---

## VERIFICATION

### The saves

**Backed up before anything was written** — `save-backups/GM-20260916-183755/` — and verified by hash, each matching the
live file and GL's backup: `profile.json` `b05e329b…`, `relics.json` `fdc12ffa…`, `run_save.bin` `c44d45da…`,
`settings.cfg` `0c1b39c3…`. **Re-hashed after the reconnaissance battery, the pre-pass and the acceptance run:
identical every time.** The probes and controls ran in copies whose `user://` was renamed away from the player's.

### The parse floor

- **`check_parse`, standalone, over the new code before any instrument landed: 184 / 0, its stderr 0 bytes**, and
  zero `Parse Error`, `Compile Error`, `SCRIPT ERROR` or `Failed to load` in either stream.
- **Over the landed tree: 185 / 0, stderr 0 bytes** — `check_gm.gd` joined the population it parses.
- **Across the three batteries' logs** (110, 111 and 111): zero of each of those, and zero `Invalid access`.
- **It runs:** the three gates that walk whole runs through the real screens (`check_fh`, `check_gf`, `check_gj`) are
  green in every battery, and `check_gm` §3 plays a whole bot turn with the rune and without.

### The drive — every repair in a real battle

**`gmprobe/drive_gm.gd`**, run in an isolated copy of HEAD and one of GM, each with its own `user://`, the parties
seated through `gate_fixture.spawn` and the damage roll seeded the same in both: **19 checks — HEAD 19 / 10, GM 19 / 0**,
every HEAD red on a repaired behaviour (§1b–§1c, §2a, §3a, §3c). The same drive is kept as **`check_gm`** and runs in
every battery.

### HEAD's unmodified instruments against the new code — the reconnaissance battery

**Run before any instrument was edited** (19:05:25–19:52:47, frozen before and after at 450 stamps: identical), over
GM's two game scripts and nothing else:

| | read |
|---|---|
| targets | 110 / 110 unique / 0 timeouts / 0 incomplete |
| suites | **46 of 46 green** |
| gates | 55 of 58 green; **`check_cm_live` 13 / 4** (its four FAIL lines word for word GL's acceptance run); **`check_el` 23 / 3** — the three predicted (twelve ids, ten marks, the Rime card untagged); **`check_di` 44 / 1 — not predicted**: `the call-site population is 215, not the 214 this gate was written against` (§3e) |
| harness, scenes | 22 / 382 / 8 PASS; both scene runs complete, `check_ct_map` 83 / 0 |
| `check_de` | 457 / 2 / 0 — the two reds above, **and no count moved** |
| against GL's acceptance run, target by target | **identical in all 110 but `check_de`, `check_di` and `check_el`** |

### The new gate, armed against HEAD before it was trusted

`check_gm` in an isolated copy of HEAD's code carrying only the new names it references (`Classes.ENGINE_BOUND`,
`engine_bound`, `_split_shield_allies` — nothing reads them there): **101 / 23**, every red a repaired behaviour — the
no-engine breath (three), the three casts the engine block left out (three), the three bound cards in the kit (three)
and on the bar (three), the earned exception's "off the bar" arm, the next fight's kit, the Split Shield (seven) and
Dispel (two). **Every positive arm stayed green on HEAD.** On GM's code: **101 / 0**, in 36 seconds.

### Before the documents and instruments landed

- **Recorded pins on the two edited game scripts**, re-resolved raw and comment-stripped against HEAD's copies: **757
  static pins, zero flips**; thirty pins carry no static needle and were left to the batteries.
- **The literal sweep** (every string literal of four characters or more in every root and `scripts/` `.gd`, single-
  and double-quoted, comments stripped and unescaped with the pin manifest's own functions; raw, lowered and flattened;
  **proved first** — deleting a needle `check_dv` holds read LOST 1 in all three forms, and unchanged copies read 0):
  - `scripts/battle.gd`, `scripts/classes.gd`: **LOST 0**. Gained: the new log line, a message tag of `check_gm`'s, and
    `DEATH_RAY_STACKS` (which `test_batch_au` reads as a property, not a needle).
  - **`CLAUDE.md`, `docs/instrument-rules.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`: LOST 0.**
    `docs/state.md`: LOST 1 — `lowered`, a dictionary key in `check_ec`, which does not read that file.
  - **Two gained needles sit inside negative checks, and neither reads these documents**: `test_batch_al`'s
    `not tips.contains("Shieldwall")` reads talent tooltips, and `check_eh`'s `not sbody.contains("Quick Shot")` reads a
    slice of `battle.gd`'s Focus function.
- **`check_es` §4, reproduced on every copy it reads**: `state.md` 2 claim windows / 4 figures, `CLAUDE.md` and
  `master.html` 1 / 2 each — the same on HEAD and the edited copies.
- **The retired words**, with `test_batch_bx`'s own strip: `master.html` carries neither.
- **`check_ed` against HEAD's manifest with everything landed: 18 / 1, naming exactly `check_gm`'s three new pins as
  unrecorded** — so the manifest can see the new gate. Regenerated: **1,467 → 1,470 pins, none lost**; `--check`
  current; `check_ed` 18 / 0.
- **Sixteen gates standalone on the landed tree, all green**: `check_gm` 101, `check_ez` 106, `check_el` 23, `check_di`
  44, `check_ec` 23, `check_da` 43, `check_dw` 35, `check_ek` 47, `check_ea` 86, `check_ff` 55, `check_fr` 25,
  `check_fg` 22, `check_es` 57, `check_dv` 83, `check_ed` 18, `check_co` 321 — **each equal to GL's acceptance reading
  but `check_ez`**, so the new gate moved no census gate.

### The pre-pass — the unmodified gates a second time, with the new gate in the tree

19:57:52–20:45:43, frozen before and after at 451 stamps: **identical**.

| | read |
|---|---|
| targets | 111 / 111 unique / 0 timeouts / 0 incomplete |
| suites | **46 of 46 green**; `test_batch_an` 6,052, inside its band |
| gates | **58 of 59 green**, `check_gm` **101 / 0**; `check_cm_live` 13 / 4, its FAIL lines word for word GL's |
| harness, scenes | 22 / 382 / 8 PASS; both complete, `check_ct_map` 83 / 0 |
| `check_de` | **461 / 0 / 0** |
| error lines across the 111 logs | 0 of each |
| against GL's acceptance run | only `check_ez` 104 → 106, `check_parse` 184 → 185, `check_gm` new, `check_de` 457 → 461, and `test_batch_an` 6,051 → 6,052 |

### Between the two

**One sentence of `CLAUDE.md` changed**: the §1 rule said BV moved Loaded Shot and Crossfire out of "the Survivalist's
block", and Crossfire's was the Sharpshooter's. Landed only after its copy matched the swept one; **swept v1 against
v2: LOST 0 and GAINED 0 in all three forms**; `pin-manifest.json` still current; the eight `CLAUDE.md` readers green
standalone (`check_ec` 23, `check_fg` 22, `check_ea` 86, `check_es` 57, `check_fr` 25, `check_ed` 18, `check_ff` 55,
`check_dv` 83).

### The acceptance run

**Predicted in writing before its launch (20:47:27)** and run from 20:47:34 to 21:35:22, frozen before and after at 451
md5 stamps with absolute paths — every tracked and untracked file but `.git`, `.godot` and `save-backups/` — with the
four saves stamped beside them.

| | read |
|---|---|
| what was in the tree | GM's code, instruments, `baselines.json` and `pin-manifest.json`, and the final documents |
| targets / timeouts / incomplete | **111 / 0 / 0** — 111 lines in `.ran`, 111 unique, 111 logs |
| suites | **46 of 46 green**, every one at its row; `test_batch_an` read **6,057**, inside its band |
| gates | **58 of 59 green**: `check_gm` **101 / 0**, `check_ez` **106 / 0**, `check_el` 23 / 0, `check_di` 44 / 0, `check_parse` **185 / 0**; **`check_cm_live` 13 / 4**, its four FAIL lines word for word GL's acceptance run |
| run harness (gates 1 / 2 / 3) | **22 / 382 / 8 PASS**, 0 throws |
| scene runs | both complete; `check_ct_map` **83 / 0** |
| `check_de` | **461 checks / 0 failures / 0 notices** |
| error lines across the 111 logs | **0** `Parse Error`, **0** `SCRIPT ERROR`, **0** `Compile Error`, **0** `Failed to load`, **0** `Invalid access` |
| the documents, as the gates read them | `check_fg`: the changelog at **346,181 B**, 53,819 B under the 400,000 B bar; `CLAUDE.md` at **339,968 B = 332.00 KiB**, 8,192 B under its 340 KiB ceiling. `check_es`: `state.md` 2 claim windows, 4 figures |
| the freeze | **451 stamps before and after — identical**; the four saves `b05e329b` / `fdc12ffa` / `c44d45da` / `0c1b39c3` before and after |
| against the pre-pass | identical in every target but `test_batch_an` (6,052 → 6,057) |
| against GL's acceptance run | only `check_ez` 104 → 106, `check_parse` 184 → 185, `check_gm` new, `check_de` 457 → 461, and `test_batch_an` |

**Every prediction held.**

### The push

**Committed and pushed to `class-merge` only**; `main` is untouched. The remote read `a93112e` (GL) before the push.
The post-push reading of `git ls-remote origin class-merge` against local HEAD is reported with the delivery rather
than here — written into this file, it would change the commit it names.

---

## WHAT MOVED

- **Game code:** `scripts/battle.gd` (the breath's spend moved; Shieldwall reads `_recast_writes` and names a hero
  with the rune; `_split_shield_allies`; the bot's Warden pick; three ids in `DISPEL_NEVER`) and `scripts/classes.gd`
  (`ENGINE_BOUND`, `engine_bound`, one line of `opening_kit`, one comment corrected) — **87 non-comment lines** across
  the two.
- **Instruments:** `check_gm.gd` (**NEW**, 101 checks); `check_ez.gd` (§5 casts the card, 104 → 106); `check_el.gd`
  (fifteen ids, `rime` in `NOT_A_MARK`, the false comment and its constant gone; 23); `check_di.gd` (`CALL_SITES`
  214 → 215, with its paragraph; 44); `run_battery.sh` (`check_gm` in `GATES`); `baselines.json` (three rows —
  `check_ez`, `check_parse` 184 → 185, `check_gm` new — a pure text edit, 24 lines in and 10 out); `pin-manifest.json`
  (regenerated, 1,467 → 1,470).
- **Documents:** `CLAUDE.md` (four rules: the bound cards and the fight that keeps what it opened with, in the engine
  rune charter; a block for §1; a bullet in the recast block; a bullet in the three doors), `docs/instrument-rules.md`
  (one bullet under EB §2's rule), `docs/master.html` (§6.0's drop bullet and a new bound-cards bullet; the Held
  Breath, Shieldwall and Bulwark Line status rows; Shieldwall's kit line; the Dispel row; the stamp),
  `docs/changelog.html` (one entry), `docs/design-notes.md` (one entry), `docs/state.md` (rewritten: the WHERE block,
  GM's rulings and findings, GL's four closed items, GK's ruling 5, the class kit's sixth item, the last measurements),
  and this file (**NEW**).
- **Nothing else**: no talent, rune, relic, pool, glossary or save format moved; no save version.

## THE FOLDERS THIS BATCH LEFT

- **Three Godot `app_userdata` folders** — `Dawn of Decay GM head`, `Dawn of Decay GM new`, `Dawn of Decay GM ctl`
  (the isolated copies' `user://`, renamed so none could reach the player's). All can be deleted.
- **`save-backups/GM-20260916-183755/`**, untracked, beside every earlier batch's.
- **The copies, the probes, the sweep scripts, the staged documents and the battery logs** are in this session's
  scratchpad, outside the repo.
