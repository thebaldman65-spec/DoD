# BATCH FM — THE FILLER COMES OUT

*2026-09-08. Full working. `docs/state.md` carries the summary; this file carries the evidence.*

**THE GENERATED STAT FAMILY IS OUT OF EVERY OFFER PATH, AND THE REMOVAL IS FOUR LINES.** What the
removal *reached* was five places that had never once executed in a real run — three of which paid
the player nothing and said nothing, and one of which **strands an owed rune pick for the rest of
the run.**

---

## §0 — THE PREMISES, CHECKED FIRST

The brief carried **nine checkable premises**. **Six held. Three did not**, and one of the three
changed what had to be built.

| # | Premise | Verdict |
|---|---|---|
| 1 | Four offer sites, all reaching the pool through `Runes.eligible_ids` | **HELD** — and the derivation finds something better; §1 |
| 2 | A fifth site added since would be invisible to a list | **HELD, AND MOOT** — there is one producer, not four; §1 |
| 3 | Every rune is spec-scoped | **HELD** — 60 of 60 |
| 4 | There are no class or universal runes | **HELD** — 0 of 60 |
| 5 | **Five per hero** | **FALSE, IN BOTH DIRECTIONS** — authored depth is **4 to 6**; §2 |
| 6 | **A hero who has seen his five gets an empty offer** | **FALSE AS ARITHMETIC** — reachable-at-spawn depth is **3 to 6**, so the Pyromancer's empty offer arrives at THREE; §2 |
| 7 | Each of the four sites shows something now | **FALSE** — at HEAD every empty branch in all four is unreachable in a real run; §2 |
| 8 | `Run.rune_choice` re-asks at resolution and repairs in place | **HELD** — and the repair is what opens the hole; §3 |
| 9 | `check_es` §1 measured the family at a flat ~30% of offers | **HELD** — and it is the assertion that inverts; §6 |

**PREMISE 6 IS THE ONE THAT CHANGED THE BUILD.** "Five, minus what he holds" is a slow slide to
empty across a whole run. **Three, minus what he holds** is reached by buying one rune from the
first Peddler — and it lands on a code path that discarded a reward without a word (§5).

---

## §1 — THE POPULATION, DERIVED — AND IT IS ONE, NOT FOUR

**The brief forbade taking FD's four, and the derivation finds something sharper.** FD's population
came from the WRITE to `member["runes"]`, which is where a rune *lands*. What governs a REMOVAL is
where a rune is *produced*, and a census over `scripts/` answers it in one line:

```
$ grep -rhno "Runes\.[a-z_]*(" scripts/ | sort | uniq -c
   1 Runes.template_rune(
   1 Runes.generate(
```

**ONE of each, in the whole directory, and both inside `run_state.generate_rune`.** Every offer
site — the Peddler, the elite cache, the bargain's rune reward, the event verb `rune_grant`, and
`rune_choice`'s top-up, which FD's list does not carry — reaches the pool through that one
function. **So the removal is one function, and a fifth offer site is closed by construction rather
than by a list somebody has to keep current.** `check_fm` §1a asserts the census rather than the
four names, so the day a second producer appears it is red without an edit here.

The four sites are still real and are still each other's own business: what each one *does* with an
empty offer is §2, and that is four separate pieces of work.

### WHAT WAS REMOVED

Two lines in `Runes.generate`:

```gdscript
	pool.append_array(_template_markers(member, owned))   # the markers, beside the authored ids
	if pool.is_empty():
		return template_rune(String(member["key"]))       # the exhaustion floor
```

It returns `{}` instead. **That is the whole of §1.**

### WHERE IT REMAINS REACHABLE — THE BRIEF ASKED, AND THE ANSWER IS ONE FLAG

**`DOD_SIM_RUNES=stats`, and nothing else.** `run_state.generate_rune`'s `"stats"` branch hands back
a `Runes.template_rune` directly, and that arm's whole documented purpose is to run the sim on
exactly this family. **Closing it would delete a measurement rather than an offer**, so it stands,
is named in the source, and is asserted in both directions by `check_fm` §1d — **which is also §1b's
control**: the same member through the same door yields a stat stick under the flag and never
without it. Without that pairing, "no stat stick came out" is what a broken driver prints.

### THE GENERATOR IS KEPT, AND SAID TO BE KEPT

ET's own retirement contract, the one `data/glossary.json` gives Melted Armor. `TEMPLATES` (six
entries), `TEMPLATE_PRICE` (50), `template_rune` and `_template_markers` all stand and all resolve.
**`_template_markers` has ZERO callers and that is the point** — restoring a floor is one
`append_array` coming back, not a family being re-authored. `check_fm` §1c asserts both halves: the
function is still there, **and** it is still uncalled.

---

## §2 — AN EMPTY OFFER LOOKS DELIBERATE AT ALL FOUR SITES

### (a) THE POOL, MEASURED — FOUR TO SIX AUTHORED, THREE TO SIX REACHABLE

**60 live entries, every one `spec:`-scoped** (0 universal, 0 class), which confirms the brief's
ruling. The per-spec depth is not five:

| Spec | Authored | Reachable at spawn | Held back, and by what |
|---|---|---|---|
| Berserker | 5 | 4 | Blood Debt (Blood Price) |
| Warden | 5 | **5** | — |
| Swordmaster | 5 | 4 | Long Blade (Sever) |
| **Pyromancer** | 5 | **3** | Ashfall (Funeral Pyre), Chain Fire (Firedraw) |
| Cryomancer | 5 | 4 | Glass Prison (Glacial Prison) |
| Arcanist | 5 | 4 | Half Note (Arcane Bolt) |
| Holy | 5 | 4 | Open Hand (Divine Plea) |
| Devout (`inquisitor`) | **4** | **4** | — (the fifth is owed; FK §7) |
| Occultist | 5 | **5** | — |
| Beastmaster | **6** | **6** | — |
| Sharpshooter | 5 | 4 | Ambush (Called Volley) |
| **Mystic** | 5 | **3** | Full Board (Cull), Carrion (Downwind) |

**SEVENTEEN LIVE ENTRIES CARRY `requires_ability` AND TEN OF THEM NAME SOMETHING OUTSIDE THE SPAWN
KIT.** `Runes.kit_names` reads the core kit, the spec abilities, the kit-override renames and
`bm_abilities` — where a drafted card *and* a boss trophy both land — **so a hero's rune pool
DEEPENS as he earns abilities.**

That is what made the empty-offer message a two-sentence problem rather than a one-sentence one:
telling a Pyromancer at three-of-five that *"he carries every rune written for that awakening"* is a
lie, and the true sentence — *"the rest wait on abilities he has not earned"* — is also the
actionable one. `Runes.empty_offer_reason` is that fork, in **one** place, because four sites print
it; its input `Runes.locked_by_kit` is `eligible_ids`' own filter chain with the `requires_ability`
clause **inverted** — the exact complement, so no rune can be missing from both lists or present in
both.

**AND THE WORD IS "EARNED", NOT "DRAFTED", FOR TWO REASONS.** `bm_abilities` holds boss trophies as
well as drafted cards, so "earned" is the more accurate of the two — and `check_fh` §3 asserts the
Peddler's screen carries no `"draft"`, on a bare substring that `"drafted"` satisfies. See §6.

### (b) WHAT EACH SITE SHOWED, AND WHAT IT SHOWS NOW

**THE ANSWER TO "WHAT DOES IT SHOW NOW" IS: NOTHING, AND IT NEVER GETS THE CHANCE.** At HEAD every
empty branch in all four sites is **unreachable in a real run**. `Runes.generate` returned a stat
stick on an exhausted pool and `generate_rune` returned `{}` only under `DOD_SIM_RUNES=off`, so each
site's empty handling was a runes-off guard wearing an ordinary `if`. **This is not inferred from
reading: `check_et` §2 at HEAD drives 540 draws through five doors and asserts that not one comes
back empty** — and it did exactly that against the FM tree in the reconnaissance run, printing
*"540 draws through five doors; none empty, none retired"*. That gate is the empirical proof of its
own obsolescence.

| Site | At HEAD | At HEAD, if the pool could empty | After FM |
|---|---|---|---|
| **The Peddler** | always offers | a header over white space, per hero, with no line | one line per hero: *"The Peddler has nothing for Pyromancer 2 — the runes left for that awakening wait on abilities they have not earned."* |
| **The elite cache** | always three | `roll_rune_candidates` returns `[]`, **the spoils line is omitted entirely** and no pick is owed | *"RUNE CACHE: nothing in it for the Pyromancer — …"*, and a SHORT cache reads *"one of 2"* instead of promising three |
| **The bargain (a rung)** | always three | `return {"text": ""}` — **a reward the player fought a modifier for, paid as a blank line** | *"RUNE (the bargain): nothing left to hand over — …"*, and the recipient is drawn from heroes it can pay |
| **The event verb** | always grants | `break` then `return ""`, and with `amount > 1` the break discarded every LATER grant too | *"RUNE: nothing answers — every hero already carries every rune written for them."*, and the taker pool is filtered first |
| **`rune_choice` (the answer)** | tops up to three | `[]` — the overlay draws a heading over nothing and **the pick can never be answered**; §3 | an explanation, and a `Let it go` button that spends the pick |

**RUNES-OFF KEEPS ITS SILENCE AT ALL FIVE.** That is CO §3's own rule — two genuinely different
causes get two sentences — where the second sentence is deliberately nothing, because under
`DOD_SIM_RUNES=off` there is no rune layer to explain.

### (c) EVERY ONE OF THEM IS DRIVEN LIVE, AT BOTH ENDS

`check_fm` §2 opens the **real shop scene** at a full pool and at an exhausted one, **wins two real
elite fights** and reads the victory card at each, and calls `Run.claim_reward` and `Events.apply`
directly for the other two. Both elite cards, read off the drive:

```
full pool:   VICTORY / ELITE SPOILS / THE DRAFT: … / RUNE CACHE: the Warrior may choose one of 3 / on their card.
exhausted:   VICTORY / ELITE SPOILS / THE DRAFT: … / RUNE CACHE: nothing in it for the Cryomancer — /
             the runes left for that awakening wait on abilities they have not earned.
```

**THE FULL-POOL ARM IS NOT DECORATION.** A message printed unconditionally passes every "the screen
says so" check ever written and replaces a silent panel with a permanent lie.

---

## §3 — THE CACHE'S RE-ASK, AND THE STRANDED PICK

**FD REPAIRED THE CACHE'S ANSWER AND FM MADE THAT REPAIR ABLE TO RETURN NOTHING.**
`roll_rune_candidates` rolls at the DROP and stores its triple on the member, where it rides the
save. `Run.rune_choice` re-asks at resolution: it drops candidates that are now retired or now
owned, and **tops the triple back up through `generate_rune`**. That top-up returned a stat stick
forever. It returns `{}` now.

**SO THE TRIPLE CAN REPAIR TO NOTHING, AND THE OVERLAY DREW A HEADING OVER IT:**

> **Warden 2 — RUNE, choose one**
>
> *[Not yet]*

**AND `rune_picks_owed` NEVER CAME DOWN.** `_pick_rune` refuses an empty triple — correctly — and
returns, so the card keeps its purple border and its CHOOSE button **for the rest of the run**, and
the pick can never be answered. **This is FE's finding with the button removed instead of left
behind**, and it is worse: `_pick_ability` left 604 dead buttons that at least *looked* wrong.

**IT IS REACHABLE BY PLAYING NORMALLY.** Roll a cache; buy those runes from the next Peddler; open
the card. Driven live at `check_fm` §3, where the re-ask returns 0 and is asserted idempotent at 0.

**THE PICK IS SPENT RATHER THAN HELD, AND THAT IS THIS BATCH'S RULING.** Holding it strands the run:
a hero's pool only ever *shrinks*, except through what he earns — which is exactly why the reason
line says which of the two states he is in. The overlay now reads:

> **Warden 2 — RUNE, choose one**
> The cache holds nothing this hero can take — they already carry every rune written for that
> awakening.
> The pick is spent rather than held: nothing can arrive to fill it.
>
> *[Let it go]  [Not yet]*

`_dismiss_rune_pick` asks `Run.rune_choice` **first**, for `_pick_rune`'s own reason: a dismiss that
did not ask could eat a live pick if it were ever reached from anywhere but the empty overlay. It
cannot be today, and the guard is there anyway. **`check_fm` §3's control drives a hero whose pool
still holds something and asserts he gets buttons, no `Let it go` and no explanation** — without
that arm the section passes on a build that had simply stopped offering runes to anybody.

**THE NODE IS NOT STRANDED AND THE RUN IS NOT BLOCKED**, which is what §3 of the brief asked:
travel was never gated on `rune_picks_owed`, so the defect was a permanently-lit card rather than a
softlock — and after the press the card's own CHOOSE door opens nothing, which is asserted.

---

## §4 — WHAT WAS DELIBERATELY NOT DONE

- **The eight shipped gated runes are not repaired.** Next batch, as ruled. *(Eight, not six — FL
  §2a's count, and the eleven lines that say six are still owed as one scoped repair.)*
- **No class or universal rune is authored.**
- **No authored rune moved**, and the 39 + 21 stand exactly as FK and EZ–FC left them.
- **The generated entries are not deleted** — removed from the offer, kept in the data.
- **No card, ability, talent, constant or magnitude moved.**
- **`Runes.TEMPLATE_PRICE` did not move** and neither did any of the six templates' magnitudes.

---

## §5 — THE THREE IMPLEMENTATION CALLS THIS BATCH TOOK, FLAGGED AS ITS OWN

None is a card, ability, talent, constant or magnitude, so §4 does not forbid them — and in each
case the alternative was to ship a message that is false.

### (1) A SHORT TRIPLE IS OFFERED RATHER THAN DISCARDED

**`roll_rune_candidates` HELD `return []` ON THE FIRST EMPTY DRAW.** Correct while the family
floored every draw — the loop could not fail to reach three, so the line was unreachable. FM makes
it ordinary, **and it fires on a pool that is NOT empty.** Measured:

| Pyromancer owns | Eligible left | HEAD's `return []`, against FM's pool | Now |
|---|---|---|---|
| 0 of 3 | 3 | 3 | 3 |
| 1 of 3 | 2 | **0** | **2** |
| 2 of 3 | 1 | **0** | **1** |
| 3 of 3 | 0 | 0 | 0 |

**ONE RUNE BOUGHT FROM THE FIRST PEDDLER AND THE NEXT ELITE CACHE PAID NOTHING, PRINTED NOTHING AND
OWED NOTHING** — indistinguishable from an elite that never carried a cache. `return []` became
`break`; the fully-empty case is unchanged and still returns `[]` on the first draw, including under
`DOD_SIM_RUNES=off` where nothing is ever queued. `check_fm` §4 pins the histogram across every spec
at every pouch depth: `{3: 26, 2: 12, 1: 12, 0: 12}`.

*(The HEAD column is arithmetic, not a second measurement: draws are without replacement, so at `k`
eligible the first `min(k, 3)` succeed and the next is empty — which returns `[]` for every `k < 3`.)*

### (2) THE COUNT IS READ OFF THE OFFER

*"may choose one of three"* was unconditional in the elite spoils and in the bargain's line. A
number in a reward line is a promise, and a short cache made both of them false. Both read the
offer now.

### (3) A RANDOM RECIPIENT IS DRAWN FROM THOSE WHO CAN RECEIVE

The bargain's `party.pick_random()` was exhaustive while every hero could always take one; it can
now land on the one exhausted hero in a party of four and throw a bought reward away. It prefers a
hero it can pay and falls back to the random pick so the empty case still names somebody — **the
idiom `events.gd`'s own rune verb already used one function over.** The event verb's taker pool
gained the same filter *ahead of* its existing free-slot preference, so the two orderings compose
rather than fight, and its `break` is exact again: with the pool filtered, `grant_rune` can only
return `{}` when the rune layer is switched off entirely.

---

## §6 — VERIFICATION: THE GATES, AND THE ONE THAT HAD STOPPED ASKING

**THE UNMODIFIED GATES WERE RUN AGAINST THE NEW TREE BEFORE ANY OF THEM WAS EDITED**, per the brief.
That run is reconnaissance and is discarded; its red list is the one repaired here.

| Target | Recon | Verdict |
|---|---|---|
| `test_runes` | 5068 checks, **15 fails, 1 throw** | Repaired to intent; the throw aborted `_exhaustion` and cost 178 checks |
| `check_es` | 46 / **1** | Repaired to intent |
| `check_fh` | 161 / **1** | A coarse needle, scoped to intent |
| `test_batch_cb` | 1721 / **1** | **A FLAKE** — three clean standalone re-runs at 1721 / 0. Under battery load, `_burn_turns(deep)` read 9. Not caused by this batch and not repaired. |
| `check_cm_live` | 13 / **4** | **THE BASELINE.** *"The one red that is on purpose. Identical on unmodified HEAD."* |
| `check_de` | 410 / **6** | All six downstream of the four above |
| **`check_et`** | **25 / 0** | **GREEN AND VACUOUS — the sharpest finding of the verification** |

### `check_et` §2 PASSED WHILE `test_runes` WENT RED FIFTEEN TIMES OVER THE SAME PROPERTY

**Its "exhausted" member was never exhausted.** The arm filled the pouch with the six TEMPLATE
names — exact while the generated family *was* the whole pool at ET — and **those six names match
nothing `eligible_ids` returns against FK's authored pool**, so the member was drawing from a full
spec set. The gate that exists to assert "the offer never comes back empty" could not see the batch
that made it come back empty.

**A SAMPLE IS PART OF AN ASSERTION'S TERRITORY** — `check_es` §1's own lesson, four batches later
and one file over. The pouch is built from `eligible_ids` now.

**AND IT WAS SITTING ON A BOUNDARY.** Its cache arm asserted `triple.size() != 3`. The Pyromancer
and the Mystic reach **exactly three** eligible entries at spawn, so a pool one rune thinner would
have turned that arm red for the right reason by luck. It is derived as `mini(eligible, 3)` now.

### THE FOUR REPAIRS, AND WHY EACH IS TO INTENT RATHER THAN TO CODE

- **`test_runes._exhaustion` (5246 → 5318, +72).** It asserted *"an offer list can never come back
  empty"*, which is now the opposite of the ruling. **The question it was really asking — is the
  offer WELL FORMED at every depth — is asked at both ends now**: one short of exhausted, something
  whole must arrive; exhausted, nothing may. 180 → 252 checks, and the +72 is exactly that.
- **`test_runes._rich_grant` (no count move, twelve reds).** *"The grant died once the spec set ran
  out"* asserted `not extra.is_empty()`. **The property it guarded is that the FALLBACK IS TAKEN**,
  and that is asserted directly: `extra.is_empty() == Runes.pool_empty_for(member)` — two-armed by
  construction, and it requires a rune again on its own the day a class-scoped rune is authored.
- **`test_runes`' cache-triple band (no count move): 70–95 → an equality at 100.** **The gate's own
  failure message predicted this in writing** — *"the template family being removed… drives it to
  100."* **The band is not widened to swallow the move, it is replaced by what is now true**, and
  the replacement is stricter: all sixty live entries are `spec:`-scoped, so a candidate that is not
  the holder's own is a scope leak and reds on the first triple rather than after a drift.
- **`check_es` §1 (46 → 47).** One arm was doing two jobs. The family's share becomes the equality
  it now is (the line this gate has printed since ES still reads the same instrument, and reports a
  flat **0.0%** where it read ~30%); the VACUITY GUARD it was really providing is asserted directly,
  on DISTINCT ids drawn rather than on the presence of a second family.
- **`check_et` §2 (25 → 26).** Subject becomes *"the offer is empty exactly when the pool is"*, and
  the new `floored` arm is what a restored floor turns red.

### `check_fh` §3's `"draft"` NEEDLE WAS COARSER THAN THE DEFECT IT GUARDS

`_has_text(shop, "draft")` is a bare substring over every Label, Button and RichTextLabel on the
shop screen — and **eight of the sixty live runes carry the words *"his drafted cards"* in their own
`desc`** (the gated pair FK left owed). With the family out of the offer the counter is
authored-only, which raised the chance of one landing there, and the seeded draw put **Deepening
Hex** on it.

**IT IS SCOPED, NOT WEAKENED.** The claim is that the screen names a draft *on its own account*, so
the offers' own `desc` strings are subtracted and everything else is still swept; a second arm
asserts no BUTTON names one, which no rune's text can ever excuse. **The source-level pins are
untouched and are the real fence** — `check_fd` §1f and `test_batch_bo` §3 hold three needles each
on `Run.draft_price()`, `Run.award_draft_pick(` and `draft_pool_left`, and both re-derive the price
is KEPT with no caller.

**BOTH ARMS OF THE REPAIR WERE DRIVEN, AND THAT MATTERS BECAUSE A NEEDLE ARMED ON NOTHING READS
GREEN.** Instrumented and run:

```
FMCTL excused=1 flagged=0 :: ["Heavy Bolts  [Spec]  (for Hunter 4)\nHis patience turns into force at 8…"]
FMCTL injection caught by the scoped needle: true
```

The excused text was **really on the counter** — so the green is not vacuous — and an injected
`ABILITY DRAFT — one card, 120g` Label **is** caught. The instrumentation was removed from a
scratchpad backup rather than by reverting the file.

### `check_da` CAUGHT THE NEW GATE TWICE, AND BOTH TIMES IT WAS RIGHT

**THE VERIFICATION BATTERY CAME BACK WITH TWO REDS: `check_cm_live` (4, the sanctioned baseline,
identical on unmodified HEAD) AND `check_da` (2, this batch's).**

`check_fm`'s first elite arm named the battle scene by path and drove the autoplay bot through a
single whelp. It worked — and **it was a second battle fixture**, which is precisely what DB §1
consolidated seven divergent copies of, and what `check_da` §3's `_fixture_marks()` exists to catch.
**THE FIX IS THE FIXTURE, NOT AN EXEMPTION.** The arm goes through `gate_fixture.spawn` now and
short-circuits at `_check_end`'s own opening line, `victory := enemies.all(func(e): return e.dead)`
— so the real `Run.claim_reward`, the real `Run.roll_rune_candidates`, the real spoils assembly and
the real `_show_end` all run, and **the only thing skipped is the combat, which is not an offer
site.** It is also now deterministic rather than dependent on a bot winning, which is what the
20,000-frame watchdog it replaced was really guarding against.

**AND IT TRIPPED A SECOND TIME ON THE COMMENT EXPLAINING THE FIRST.** `check_da` §3 reads the RAW
source, not a comment-stripped one, so a paragraph describing the removed call reads to that gate
exactly like the call still being there — **CLAUDE.md's EV §5 rule, arriving twice in one batch in
one file.** The prose names the scene without naming its path.

**`check_da` went 42 → 43 → 42** (its count rises by one per violating file, so the NOTICE in
`check_de` was the violation and not a coverage change), and **`check_de` read 414 / 1**: the +4 is
the four checks a new target adds to its sweep, exactly as predicted from the loop before the
battery, and the 1 was `check_da` going redder.

### `check_fm` IS NEW — 81 CHECKS, THREE IDENTICAL STANDALONE READINGS

Its four sections and why each ruling decays silently are in the gate's own header and in its
`baselines.json` row. The two things worth repeating here: **the population is a CENSUS, not a
list**, so a fifth offer site moves it without an edit; and **§2 presses real buttons on real
screens**, because an empty panel is a draw-time fact and a spoils line that is simply absent looks
exactly like an elite that never carried a cache.

### THE CONTROL: THE FLOOR PUT BACK, AND THE GATE GOES RED IN EVERY SECTION THAT MATTERS

**A GATE THAT PASSES IS NOT A GATE THAT ASKED — this batch found that out in `check_et` §2, so it
is not left as an assumption here.** After the clean battery, the **exact two lines FM removed** were
put back into `Runes.generate` and `check_fm` was run against the restored floor:

```
check_fm: 81 checks / 22 failures
  §1b: a generated stat stick came out of an offer — [berserker@0, berserker@1, … 270 of them]
  §1b: an exhausted pool still produced an offer — the floor is back: [berserker@exhausted -> tpl_swiftness, …]
  §1c: `_template_markers` has a caller again — the floor is back in the pool
  §1d: the ordinary path handed back a stat stick — tpl_swiftness
  §2a: the Peddler still offered 4 runes to a party holding every one
  §2a: THE COLUMN IS A HEADER OVER WHITE SPACE — no line says why it is empty
  §2a: the empty column names 0 of 4 heroes
  §2a: the empty column gives no reason — a refusal with no reason reads as a bug (CO §3)
  §2a: a Buy button survived an empty rune column — FE's dead button, on the shop
  §2b: AN ELITE AT AN EXHAUSTED POOL SAID NOTHING — the cache simply vanishes
  §2c: the bargain's empty payout does not say what happened — `RUNE (the bargain): the Warrior may choose one of 3.`
  §3:  the re-ask handed back 3 runes the hero already wears
```

**Twenty-two failures across §1b, §1c, §1d, §2a, §2b, §2c and §3** — every section whose subject is
the removal, from four different angles: the draw itself, the dead function gaining a caller, the
sim-arm control, three screens, and the re-ask. **The injection is the real one and not a weaker
proxy**: it is the removed code restored verbatim, so it is the exact change a later batch would
make on meeting an empty offer.

`scripts/runes.gd` was restored from a scratchpad backup and **md5-verified against the frozen
copy**, and a whole-tree re-freeze over all 412 files confirms the committed tree is byte-identical
to the one the battery read.

### THE ROWS THAT MOVED, AND THE TWO A NEW GATE OWES

`check_parse` 174 → **175** (its count IS its coverage: it walks every `.gd` and `.tscn` under
`res://`, and `check_fm.gd` is not in its RESIDUE list, which is the half that says the gate is
actually wired into `run_battery.sh`). `check_fm` **81 / 0**, new. `test_runes` **5318**, `check_es`
**47**, `check_et` **26**, `check_fh` **162**. **`check_de` has no baseline row** — it is `SELF` in
its own sweep — so the four checks it gains for the new target move no pin.

**`pin-manifest.json` REGENERATED: 1432 → 1437 pins.** `check_ed` was run against HEAD's manifest
BEFORE regenerating (18 / 0) and again after (18 / 0). Two of the five new pins carry `missing-file`
residency because their haystack is built as `"res://scripts/" + f` in a directory census; that is
an established category with twenty pre-existing members, `check_dp` among them, and the gate reads
it.

### THE LITERAL SWEEP

Every line the `scripts/` diff removed was swept against all 90 gates and suites, plus
`pin-manifest.json` and `baselines.json`. **Nothing removed is pinned.** The two that looked like
hits were not: `"may choose one of three"` is pinned by `check_ea` §0 and the manifest, but on
`boss_text += "\n\nNEW ABILITY: %s may choose one of three` — the BOSS award, which is untouched;
and `return []` appears in `check_ez.gd` as that gate's own code. The `runes.gd` comment CLAUDE.md
quotes — *"THE FILTER LIVES HERE BECAUSE THIS IS THE ONLY DOOR … one `continue` retires a rune
everywhere it could be offered"* — is preserved verbatim; only the sentence after it moved, and that
sentence is what FM reversed.

### AND THE DOCUMENTS WERE WRITTEN BEFORE THE VERIFICATION RUN

`docs/master.html` carried three claims this batch makes false — *"the generated family survives as
the filler and as the exhaustion floor"*, *"an exhausted pool falls back to the generated family —
the offer list never comes back empty"*, and the retirement bullet's *"an exhausted pool falls back
to the generated stat family"*. All three are corrected and the stamp is bumped to FM.
`docs/text-standard.html` gains **§4.12**, because every one of these messages is player-facing text
and CJ's standing rule binds every batch including this one; §4.11's claim that the long-form
template names *"mark them as such on a shop row"* is corrected to say the exception is now dormant.
