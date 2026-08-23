# BATCH DJ — HARVEST READS `companions`

**DH's Harvest clause pays more for a wound an ALLY opened, and its loop walked `heroes` — which
does not carry the companions.** A wound Aguila opened therefore paid the base rate however it was
stamped, measured live at **exactly 1.0000** of a self-opened board. DI found it, correctly refused
to close it, and **deliberately left seven companion call sites unstamped so the sweep would not
look complete while the wound still paid nothing.**

**DJ closes both halves.** The loop reads `heroes + companions`; the seven sites are stamped;
**a companion-opened board now pays 1.5000, which is what a hero's wound pays.** `src` coverage
goes **99 → 106 of 204**. No save version moves (still v10).

**One new gate: `check_dj`, 54 checks.** It is in `run_battery.sh`'s `GATES` array and in
`baselines.json`.

---

## §1 — THE ALLY LOOP READS `companions` TOO

CV §4's standing convention is that **HERO** means the four and **ALLY** means heroes and
companions together. Harvest's clause says *ally*, so it must resolve a companion's work. It could
not, and the failure was invisible by construction: **an unstamped status and a companion-stamped
one are the same value to that loop.**

### THE FIX IS NOT THE ONE DI PROPOSED, AND THAT IS THE CARE OF THIS BATCH

`docs/reports/DI.md` §3 wrote the fix as *"one word in DH's loop (`heroes` → `_hero_side()`)"*.

**That word would have been wrong.** `_hero_side()` filters `dead`:

```gdscript
func _hero_side() -> Array:
	var side: Array = heroes.filter(func(h): return not h.dead)
	...
```

and this loop deliberately does not — DH's own comment says *"a hero who has since DIED still
opened the wound, so neither is filtered on `dead`"*. Taking the suggested fix would have closed
the companion gap and **silently opened a second one, in the same loop and in the same shape.**

**Measured, not argued.** With the loop reading `_hero_side()`:

| arm | result |
|---|---|
| companion-opened vs self-opened | **1.5005** — passes |
| opened by a hero who has since FALLEN | **0.6664** — a fresh 33% under-payment |

The union is written out as `heroes + companions` and hoisted above the status loop (it is the same
array for every status on the body, and `+` allocates). `check_dj` §4 is the control that catches
the substitution; it is the section this batch exists to have.

**`battle.gd:17821` / `:17831`.**

### THE SEVEN WITHHELD SITES ARE STAMPED

| site | what | source now passed |
|---|---|---|
| 15155 | Kill Command's Blind (aguila) | `comp` |
| 17922 | Bestial Wrath's taunt (ursus) | `bw_comp` |
| 19618 | Guardian's Roar, beast-encoded taunt | `body if body != null else hunter` |
| 19620 | Guardian's Roar, hunter-encoded taunt | same |
| 19672 | the arrival dive's Daze | same |
| 19756 | the eagle's strike lays Exposed | `comp` |
| 19758 | the eagle's Wrath Blind | `comp` |

**THE TAUNT'S `power` AND ITS `src` ARE DIFFERENT QUESTIONS AND ARE NOT CONFLATED.** `mocked`
encodes `100 + the hunter's index` as its power, which is who the taunt **pulls to**. That is not
who applied it, and both sites keep the encoding untouched while naming the roarer as the source.

**GUARDIAN'S ROAR AND THE DIVE RESOLVE `body if body != null else hunter`, WHICH IS NOT A GUESS.**
`body` is null exactly when a bodiless spirit answers Call of the Wild; the same two lines already
choose between `_companion_hit(body, …)` and `_ghost_hit(hunter, …)` on that test. The source
follows the blow.

**Coverage 99 → 106 of 204**, and `check_di`'s ratchet moved with it (99 → 106).

### THE MEASURED RATIO, BEFORE AND AFTER

On a board of four plain afflictions (`exposed`, `sunder`, `slow`, `dazed` — all in `DEBUFF_IDS`,
none sticky), **seeded on both blows of the compared pair** so the arms differ only in whose name is
on the statuses:

| arm | before DJ | after DJ |
|---|---|---|
| companion-opened vs self-opened (hand-stamped) | **1.0000** | **1.5005** |
| one of four wounds opened by a real `_companion_strike` | **1.0000** | **1.1254** |
| opened by a hero who has since FALLEN | 1.0000 | **1.0000** (unmoved, deliberately) |

1.5 is the card's own 18%/12%. 1.125 is one wound in four being the ally's — `0.12 + 0.06/4`
against `0.12` — so the second row is the *plumbing* measured, not the arithmetic: it can only read
1.0 if `_companion_strike` stamped nobody.

**It landed where a hero's does**, which is what the brief said it must, and there is nothing here
that is a rounding.

**The 1.0000 "before" figure is not quoted from DI.** It was re-measured on this batch's own
instrument by reverting the loop and re-running `check_dj` — negative control 1 below.

### DH'S COMMENT IS CORRECTED, AND SO ARE THE THREE OTHER LIVE PLACES THE BELIEF WAS WRITTEN DOWN

A comment is not evidence — CU's method — and this one was asserted in **four live places at
once**:

| where | what it said |
|---|---|
| `battle.gd` Harvest block | *"`heroes` CARRIES THE COMPANIONS, which is correct rather than incidental"* |
| **`CLAUDE.md` §"HERO AND ALLY ARE NOT SYNONYMS"** | *"A Beastmaster's beast stands in `heroes`"* |
| `docs/text-standard.html` §4.9 | the same sentence |
| `docs/talent-audit.html` §4.1 | the same sentence |

**The rule file contradicted itself.** DI had already recorded the correct fact 1900 lines further
down, in the `src` standing rule, and CV §4's convention block above it still said the opposite.
All four are corrected; `check_dj` §6 asserts their absence.

**The changelog and the batch reports are HISTORY and were deliberately not swept** — they record
what was believed when they were written. `check_di.gd` quotes the belief in order to refute it and
is correct as it stands.

### AND THE MECHANISM IN THAT BELIEF WAS WRONG TOO

CV §4 recorded that **23** nodes are *"shorted by an explicit `is_companion` filter in
`battle.gd`"*. Re-derived here: **there are exactly 23 such filters, and all 23 walk `heroes`,
which never holds a companion — so not one of them removes anything.**

The exclusion CV measured is real. **The COLLECTION is what does it.** The filters still read as
the author's intent, which is worth having — they are simply not the mechanism, and the corollary
is the one that matters going forward: **a walk with no such filter is not thereby including
companions.** `check_dj` §5 ratchets the population at 23.

### AND ONE STALE FIGURE, WHICH IS §3'S SECOND RULE MET IN THE WILD

DH's Harvest comment carried *"53 of 204 single-line `_apply_status` calls"* and, one line above
it, *"a signature change across 244 call sites"*. **DI corrected the 53 in `docs/state.md` and left
this copy standing**; the 244 had been 204 since before DH. Both are deleted rather than
re-numbered — the comment now points at `check_di` §1, which walks the file and prints the live
count on every battery run.

---

## §2 — EVERY OTHER SITE THAT LOOPS "ALLIES"

**Harvest is the one that was caught and it is not the only one.** Every broad ally-worded card and
node was swept against its read site. **Only Harvest is changed.**

### The eleven that walk bare `heroes`

| effect | text says | read site | shape |
|---|---|---|---|
| `wd_tank_spank` **Tank and Spank** | "Empowers a random **ally**" | `10156` `heroes.filter(func(h): return not h.dead)` | **cited in `CLAUDE.md` as the proof the distinction works** |
| `wd_rally` **Rally** | "grants every **ally** +30% healing received" | `8083` `for h in heroes:` | CV moved this text TO *ally* |
| `wd_hold_line` **Hold the Line** | "every **ally** takes 50% less Break damage" | `18265` `heroes.filter(… not he.dead)` | CV moved this text TO *ally*; `master.html` says "companions included" |
| `dv_devoutness` **Devoutness** | "Every **ally** takes {v}% less Break damage" | `1343` + `1348` `for h in heroes:` | CV moved this text TO *ally*; **and it is stamped once at party spawn**, so a beast summoned later could not receive it even if the collection were widened |
| `dv_waters` **Cleansing Waters** | "each **ally** has {v}% chance each turn" | `2665`, per-turn on the acting unit | CV moved this text TO *ally*; **structurally unreachable** — `_next_unit()` walks `heroes + enemies` and a companion takes no turns |
| `wd_stomp_drill` **Rallying Cry** | "every **ally** regains {v}% of their maximum resource" | `2955` `for rc_h in heroes:` | — |
| **War Stomp**'s rider | "**Allies** regain 10% of their resource" | `10689` `for h in heroes:` | an ability description, not a node — **abilities were never in CV's sweep** |
| `rally` **Rallying Shout** | "every other **ally** regains 30% of their resource" | `14775` `heroes.filter(… not he.dead)` | ability |
| `sanctuary` **Sanctuary** | "every **ally** heals 12% of their max health" | `14932` `heroes.filter(… not he.dead)` | ability |
| `sv_medic` **Field Medic** | "cleanse {v} debuffs from random **allies**" | `2765` `heroes.filter(…)` | — |
| `hl_last_hope` **Last Hope** | "**Allies** under 25% … receive 40% more healing" | `1389` + `1393` `for h in heroes:` | battle-start stamp, same shape as Devoutness |

**THE FOUR TEXTS CV §4 MOVED *TO* "ALLY" ARE ALL ON THIS LIST**, and the reason given for moving
them was *"their read sites genuinely include companions"*. None of them does. **And
`wd_tank_spank` — cited in `CLAUDE.md` as the proof the distinction is worth having — is on it
too.**

### The eight that carry an `is_companion` clause

| effect | text says | read site |
|---|---|---|
| `hymn` **Hymn of Hope** | "heal **ALL allies**" | `14910` |
| `cons_ground` **Consecrated Ground** | "every **ally** is kindled 1 Faith" | `14956` |
| `dark_pact` **Dark Pact** | "every OTHER **ally** heals 15%" | `15037` |
| `resonant_field` **Resonant Field** | "every **ALLY** deals bonus damage" | `17213` |
| `elevation` **Elevation** | "every **ally** gains 2 stacks of Faith" | `17370` |
| `interpose` **Interpose** | "**EVERY ally**, the Warden included" | `18234` |
| `shared_grief` **Shared Grief** | "+1 for every OTHER **ally** already below half" | `18870` |
| `reliquary` **Reliquary** | "every **ally** is healed" | `19003` |

Three of these are Faith-flavoured (`cons_ground`, `elevation`, `reliquary`) and `_gain_faith`
refuses companions outright, so they are doubly excluded and could never say *ally* under CV's own
test. `resonant_field`'s comment states the exclusion of the CASTER deliberately and says nothing
about companions.

### WHICH EACH ONE LOOKS LIKE — AND NOTHING HERE IS RULED ON

**That distinction is the whole point of the sweep**: an exclusion that is *intended* needs its
**text** corrected to say "hero"; one that is *accidental* needs its **code** corrected. Reading
each site's own comment and the shape of its effect:

- **Looks INTENDED** (an explicit clause, a comment that says why, or a party-wide buff that would
  reach six units under The Pack): all eight of the filtered set, plus **Rallying Cry** and **War
  Stomp** (both resource refuels, which a beast has no resource bar to receive) and **Cleansing
  Waters** (structurally unreachable — the code cannot be "fixed" without moving the effect off
  turns entirely).
- **Looks ACCIDENTAL** (the text says "ally", nothing in the code or comments says companions are
  meant out, and the effect is one a beast could plainly receive): **Tank and Spank**, **Rally**,
  **Hold the Line**, **Sanctuary**, **Field Medic**, **Last Hope**, and **Devoutness** — though
  Devoutness and Last Hope have a second obstacle, which is that both are stamped once at party
  spawn, before any companion exists.
- **`master.html` states Hold the Line's as "(companions included)"**, which is false today. It is
  flagged in place, pointing at this section, rather than corrected in either direction.

**Harvest was different from all eleven and that is why it was taken alone**: its clause does not
merely *reach* allies, it is *about* whose work a wound is — the word "ally" is the mechanic, not
the flavour, so reading it narrowly is not a scope choice but a wrong answer.

---

## §3 — THE TWO RULES THIS EARNS

Both are in `CLAUDE.md`.

> **`heroes` does not contain the companions. `companions` does.** Any loop implementing the *ally*
> convention must read both. **A loop over `heroes` alone silently excludes companions and reports
> nothing** — it looks like a balance quirk, not a bug.

Carried with it: the three idioms and that they are not interchangeable (`heroes + companions` is
dead or alive, `_hero_side()` is the living only, bare `heroes` is the four); the fourth exclusion
nobody writes down (a per-turn effect can never reach one); **that picking the union is a decision
about `dead` and not only about companions**, with the 0.6664 measurement under it; and that the
cost of getting it wrong is silence.

> **A number quoted from one document into another stops being a measurement.** DI's 53/204 was a
> single-line grep that missed 25 wrapped calls; the true figure was 63, and it had been quoted into
> three documents without re-derivation. **Re-derive a figure at the point of use, or cite where it
> was measured and when.**

Carried with it: **the copy in the source comment outlived the batch that corrected the others**,
and the fix is fewer copies rather than a better number.

---

## §4 — VERIFICATION

**The documentation was written BEFORE the verification run** — `CLAUDE.md`, `docs/changelog.html`
and `docs/master.html` all landed first, because roughly 35 suites assert on their contents and a
battery run before them proves the wrong tree.

### The negative controls, all run

| control | result |
|---|---|
| revert the loop to bare `heroes` (DH's state) | `check_dj` **54 / 4 failures**; the ratio reads **1.0000**, reproducing DI's measurement on a second instrument |
| take DI's proposed `_hero_side()` fix | `check_dj` **54 / 3 failures**; §2 passes at 1.5005 and the fallen opener drops to **0.6664** |
| un-stamp ONE of the seven (the eagle's Exposed) | `check_dj` **54 / 2 failures** — caught by the live arm and by the driven site |
| un-stamp Kill Command's Blind | `check_di` **44 / 1 failure** — the coverage ratchet reds at 105 of 204 |
| widen one of §2's eleven (Tank and Spank → `_hero_side()`) | `check_dj` **54 / 1 failure**, worded as a NOTICE to re-derive DJ §2's table rather than as a regression |

**Without the first two this batch would have proven nothing**, since the failure it fixes was
invisible in every battery ever run — and the second is the one that matters, because it is the
control that rejects the fix the previous batch recommended.

**The parse check was read off a stderr grep for `Parse Error`, never off a tally and never off the
exit code** — `CLAUDE.md`'s rule, and the trap DI hit live. `battle.gd` reports **0** `Parse Error`
lines; the one `SCRIPT ERROR: Compile Error: Identifier not found: Run` is the autoload, unreachable
under `--check-only`, and is present on unmodified HEAD too.

### The literal sweep

Every string literal in **all 47 suites and 22 gates** was evaluated against `battle.gd` before and
after, with both of DI's holes closed (single quotes as well as double, indirect literals as well as
inline inside `.contains(...)`), at a 5-character floor over **20,092** literals.

**Zero flipped in the 47 suites and the other 21 gates. Five flipped, and all five are `check_dj`'s
own needles pointing the way they were written**: three GAINED (`var hv_party: Array = heroes +
companions`, `hv_party`, and Guardian's Roar's `gr_src` line — §1 and §3 assert these are present)
and two LOST (`` `heroes` CARRIES THE COMPANIONS `` and `53 of 204 single-line` — §6 asserts these
are gone). **A gate that changes the source it reads should flip exactly its own needles and
nothing else, and that is what the instrument reports.**

The same sweep was run against the **documents** (`CLAUDE.md`, `master.html`, `changelog.html`,
`design-notes.md`, `state.md`, both audits, `text-standard.html`, `README.md`) over 20,092
literals: **two flips, both accounted for** — `check_dj`'s own negative needle, which is supposed to
be LOST, and `test_batch_br`'s `"_next_unit"`, which is a `scene.call()` method name that reads no
document and flipped only because DJ put the identifier into `CLAUDE.md`'s prose.

**THE INSTRUMENT WAS POSITIVE-CONTROLLED RATHER THAN TRUSTED.** Replaying DI's own change through
it (`HEAD~1` against `HEAD`) it correctly reports `test_batch_ax`'s needle — the one DI's first
sweep missed for being single-quoted.

### §4a — THE BASELINE PREDICTION, WRITTEN BEFORE THE BATTERY

| row | predicted | why |
|---|---|---|
| `check_dj` | **NEW: 54 / 0** | the gate this batch adds |
| `check_di` | **44 / 0, UNMOVED** | §4's third assertion changed its VALUE (1.0 → 1.5), not the count; §1's floor moved 99 → 106 |
| `check_de` | **277 → 281** | four assertions per baseline row and DJ adds one row. **It has no row of its own**, so nothing reports it as a movement — which is exactly why DI said a predicted table should carry it |
| `check_cm_live` | **4 failures** | the one deliberate red, identical on unmodified HEAD |
| `test_batch_at` | 467, failures **0 or 1** | its unseeded §1 ratio is still open and still banded — **a red there is not this batch's** |
| `test_batch_bo` | 1025, failures **0 or 1** | its §5 NULL FIELD flake is still open and still banded — **not this batch's** |
| `test_rune_battle` | 97, failures **0 or 1** | banded at DF and deliberately not tightened — **not this batch's** |
| **every other row** | **UNMOVED** | DJ adds no ability, no status and no assertion to any existing suite, and the literal sweep flipped nothing |

### §4b — THE BATTERY

**TWO FULL BATTERIES RAN AND BOTH WERE CLEAN.**

| | DJ battery 1 | DJ battery 2 (acceptance) |
|---|---|---|
| suite failures | **0** | **0** |
| `check_cm_live` (deliberate) | 4 | **4** |
| throws, grepped from the stream | 0 | **0** |
| `Parse Error` / `SCRIPT ERROR` across all 68 logs | 0 / 0 | **0 / 0** |
| `check_de` | 281 / 0 failures / 0 notices | **281 / 0 / 0** |
| `check_di` | 44 / 0 | **44 / 0** |
| `check_dj` | 43 / 0 | **54 / 0** |

**THE PREDICTION WAS RIGHT ON EVERY ROW IT NAMED, INCLUDING `check_de`** — which DI's own table
missed for exactly this reason, and which nothing reports as a movement because the differ has no
row of its own.

**`check_dj` MOVED BETWEEN THE TWO RUNS AND THAT IS NOT A FLAKE.** It read **43** in battery 1;
§5's eleven-site ratchet was added afterwards, taking it to **54**. **Battery 2 is the acceptance
run against the final tree and is the only battery reading that supports the 54**, which is why
`baselines.json` records `checks_obs: 3` and `fails_obs: 2` rather than counting the batch's eight
total runs. A row rests on readings of the shape it records.

**`check_di` DID NOT MOVE**, which is the point of how DI wrote its §4: the ruling changed an
assertion's VALUE (1.0 → 1.5) and not the count, so the gate says the belief changed without the
baseline table saying anything at all.

**AND THE ZERO IN THE FAILURE ROW IS NOT A REPAIR.** `test_batch_at`'s unseeded §1 ratio, `bo`'s §5
NULL FIELD flake and `test_rune_battle`'s pierce were quiet in both runs, as they were in both of
DI's. **All three remain open, unseeded and banded, and four consecutive quiet readings on a row
that reds about one time in eighteen is the expected outcome rather than evidence.**


---

## §5 — WHAT THIS DELIBERATELY DOES NOT DO

- **Eleven other ally-worded effects still walk bare `heroes`** — §2. Reported, classified, ruled
  on nowhere. Changing any of them moves a magnitude or moves a card's text, and both are the
  designer's call. **`check_dj` §5 pins all eleven**, so the table cannot rot into prose nobody
  re-checks.
- **THE THREE UNSEEDED FLAKES ARE STILL OWED** — `test_batch_at`'s §1 live damage-curve ratio,
  `test_batch_bo`'s §5 NULL FIELD flake and `test_rune_battle`'s pyromancer pierce. **One flake at
  a time is how the effect stays attributable**, and DJ took none of them. Their bands and readings
  are in `baselines.json`.
- **98 `_apply_status` call sites still pass no source**, recorded as owed. They apply buffs, marks
  and hero-side wards, so nothing currently mis-credits off them.
- **`melted` is still out of reach by SHAPE** — applied through `unit.add_status`
  (`battle.gd:2553`), which accepts no source argument at all. Stamping it is a signature change.
- **The seven remaining ambiguous sites** are unchanged and still named in `docs/reports/DI.md` §2:
  Umbral Mirror's rebound, Chain Ignition, the Cursed Visage, Spread of Madness, the bewitched
  strike, Hemorrhage, and the Hoarfrost modifier stamp. Getting the source wrong is worse than
  leaving it absent.
- **No card text was rewritten and no other magnitude moved.** Harvest's clause is the only
  behaviour that changed, and it changed toward what its own card already promised.
