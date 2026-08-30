# BATCH DZ — THE FALLBACK, THE PRICING, AND THE PRUNE

*2026-08-30. Three sections. **The zone-boss fallback is priced as options and nothing is
authored; Divine Wrath, Blessing of Zeal and Arcane Surge are measured against each other and
ruled on nowhere; and `CLAUDE.md` is pruned to CW's own rule.** No code moved, no magnitude moved,
no card was authored. `CLAUDE.md` goes **261.77 KiB → 210.56 KiB**, and the knowledge-sync ratio
**3.639% → 2.948%** — under CW's 3% for the first time since the target was set.*

---

## THE BRIEF'S AND THE RECORD'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because two of them changed the work.

1. **§1 SAYS "Holy carries four protected cores, so the spec most likely to need a fallback also
   has the fewest slots to receive one." THAT COUPLING BROKE AT DY AND THIS IS THE FIRST DOCUMENT
   TO SAY SO.** It was DV's, and it was true when Holy's boss pool was ONE. **After DY §2 Holy can
   lose ONE award of three and the Devout can lose ALL THREE** — and the Devout carries the normal
   **four** earnable slots, not Holy's three. **The hole is deepest on a spec with as much room as
   anybody**, so "a fallback that hands over a card is worth least to exactly the hero who needs it
   most" is no longer true of the worst case. It is true only of Holy's single award.
   `docs/state.md` still carried the coupling as current; corrected there.
2. **`docs/state.md` AND DV BOTH CALL THE HOLY CLERIC "the only spec that carries FOUR protected
   cores". THE SLOT FIGURE IS FOUR AND THE NAME COUNT IS FIVE.** `Classes.core_slots("holy")` is 4
   and is genuinely the only 4 in the table, but `protected_names("holy")` returns **five** names
   (Smite, Heal, Renewal, Hymn of Hope, Resurrection) and the Devout's returns **four**. `slots` is
   authored and deliberately not a name count — the Beastmaster's three summons are five abilities
   in three slots. **The slot claim holds; the phrase "four protected cores" does not, and it is
   the phrase that travels.**
3. **§2 SAYS DIVINE WRATH IS "a draft card doing a protected core's job at half the cost". THE
   INITIATIVE IS NOT A PRICE — IT IS A CLAMP.** `divine_wrath` is in `Ability.PURE_BUFFS`, and
   `Ability.make()` clamps every member to `BUFF_DELAY_CAP`. Its `delay` is literally written
   `Ability.BUFF_DELAY_CAP`. **Whatever number anyone typed there, the card would read 1.0.** So
   Divine Wrath was never priced against Blessing of Zeal — it was never priced at all, and
   "which of the two is wrong" has no answer in that form.
4. **§2 ALLOWS THAT "a protected core priced too high is as likely as a draft card priced too
   low". MEASURED AGAINST ITS OWN FAMILY, BLESSING OF ZEAL IS PRICED *LOW*, NOT HIGH** — see §2's
   table. It is the cheapest card at its initiative and carries by far the shortest cooldown there.
5. **§3 SAYS `CLAUDE.md` "grows a block per batch by construction".** It grows a **rule section**
   per batch; there is not one `### BATCH XX` heading left in the file. **What it actually carries
   is a batch NARRATIVE under a STANDING heading** — narrative in every way but its formatting,
   which is the exact thing CW's split could not see and which this file already records as having
   survived that split once.
6. **`docs/state.md` RECORDS A "real, dated debt" THAT DOES NOT EXIST.** DY wrote: *"AFTER DZ THE
   TWO-LETTER SEQUENCE ENDS AT `EA`, WHICH SORTS BEFORE `DZ`"*, and concluded that the batch rolling
   past `DZ` must move the `>=` stamp comparison in fourteen suites or change the scheme.
   **`EA` SORTS AFTER `DZ`** — `'E'` is one code point above `'D'`, so `"EA" >= "DZ"` is **true**,
   checked in GDScript rather than reasoned about. **And the comparison is not against the previous
   batch at all: each of the fourteen compares against ITS OWN code**, every one of which is `CE` or
   older. `EA` passes all fourteen; so does `EZ`. **The scheme is fine and nothing is owed.** The
   real constraint is narrower and worth keeping: the codes are UPPERCASED on both sides of the
   compare, and `substr(_code_at + 7, 2)` reads exactly **two** characters — **so a THREE-letter
   batch code is what breaks it**, which is a long way off.
7. **§5 SAYS "~35 suites assert against `CLAUDE.md`". TWENTY-SIX TARGETS READ IT** — **9 gates and
   17 suites** — and **18 more name it in prose only**, almost all of them the same one-line comment
   about parking a scene spawn on the first `process_frame`. **A grep for the filename over-reports
   the population by two thirds**, which is the shape this file already records about counting the
   stamp gate. The prune was scoped to the 26, and the needle list was built from them.
8. **Everything else held**, including the award count of 3 off `Run.SLOT_COUNT`, the one shared
   `bm_abilities` list, and every spec's boss-pool depth as DY §2 left it.

---

## §1 — A ZONE-BOSS AWARD NEVER GIVES NOTHING: FOUR OPTIONS, NOTHING AUTHORED

**Nothing was authored. This section is the pricing and the measurement behind it.**

### WHAT HAPPENS TODAY, WHICH IS NOT "a bad reward"

`Run.award_ability_pick` returns `false` when the offer is empty, and `battle._award_ability_picks`
**silently skips that hero** — its comment says so deliberately: *"A hero whose SPEC pool is
exhausted is silently skipped."* The victory card does not name them. **The baseline is not a weak
reward, it is no acknowledgement at all**, and that is what the four options are being compared
against.

### EVERY SPEC, DERIVED LIVE, AT 154

**The award count is THREE** (`Run.SLOT_COUNT`). A boss offers up to three candidates from the
hero's spec pool minus what they already own; **both channels write the same `bm_abilities` list**,
so a drafted card removes itself from the boss offer. Worst case, a hero drafts every boss card
that is also draftable, and the awards that can pay nothing are `3 − min(3, safe)`.

| spec | boss pool | of them draftable | safe | awards that can pay nothing | draft pool | earnable slots |
|---|---|---|---|---|---|---|
| **Devout (inquisitor)** | **2** | **2** | **0** | **3 — every one** | 11 | 4 |
| Berserker | 3 | 2 | 1 | 2 | 10 | 4 |
| Pyromancer | 3 | 2 | 1 | 2 | 13 | 4 |
| Cryomancer | 3 | 2 | 1 | 2 | 11 | 4 |
| Occultist | 3 | 2 | 1 | 2 | 10 | 4 |
| Swordmaster | 4 | 2 | 2 | 1 | 12 | 4 |
| Arcanist | 4 | 2 | 2 | 1 | 12 | 4 |
| **Holy** | 3 | 1 | 2 | **1** | 10 | **3** |
| Warden | 4 | 1 | 3 | 0 | 10 | 4 |
| Beastmaster | 5 | 0 | 5 | 0 | 10 | 4 |
| Sharpshooter | 5 | 0 | 5 | 0 | 10 | 4 |
| Survivalist (mystic) | 5 | 0 | 5 | 0 | 10 | 4 |

**44 boss entries; EIGHT of the twelve specs can lose an award; and the figure nobody had put a
number on — 14 OF THE GAME'S 36 ZONE-BOSS AWARDS CAN PAY NOTHING**, in a run where every hero
drafts against their own boss pool.

### THE FOUR CANDIDATES, RE-PRICED AGAINST THE GAME AS IT STANDS

| candidate | build cost | can it itself pay nothing? | what it feels like as the boss dies | balance cost |
|---|---|---|---|---|
| **A — a card from the hero's own SPEC DRAFT pool** | none; `bm_abilities` already takes both channels and the site is `award_ability_pick`'s `return false` | **NO, and it is measured: the floor is SIX cards** | closest to what the screen promises — an ability, which is what the award is for | **dissolves the two channels.** The boss starts offering what the next elite would have; a boss pick and a draft card stop being different kinds of reward |
| **B — a class-wide card** | small; `CLASS_DRAFT_POOLS` is live at **25** (Mage 7, the rest 6) | **NO, but the floor is TWO** | a consolation prize, and reads as one | **class-wide cards are authored WEAKER than spec cards on purpose**, so the fallback is deliberately worse than what the other eleven specs get from the same boss |
| **C — a rune** | **lowest of the four, and now measured rather than asserted**: `roll_rune_candidates` returns three, and the grant is the same two fields the ability pick already uses (`rune_candidates` + `rune_picks_owed` against `bm_candidates` + `bm_picks_owed`); the map's owed-pick overlay resolves both | **YES — `roll_rune_candidates` returns `[]` when runes are off or the pool is exhausted**, so this option needs its own fallback or a stated "nothing" case | **changes what the reward IS** — either the point or the objection | costs **no ability slot**; rune power is a separate economy, so it does not touch the draft's balance at all. 3 slots a hero, 65 runes in the pool |
| **D — gold** | none | no | **weakest** — a zone boss already pays `randi_range(110, 130)`, so this is more of what he just handed over, in the same breath | nearly nil, and that is the problem: a reward the player will not remember |

**THE SLOT ARGUMENT HAS MOVED AND IT NOW POINTS AT ONE SPEC RATHER THAN AT THE FIX.** `ABILITY_SLOT_CAP`
is 7. Holy is the only spec at four core slots, so she has **three** earnable slots against
everybody else's four — but she can now lose only ONE award. **The Devout, who can lose all three,
has four.** Gold and a rune still cost no slot; that is now an argument about Holy's single award,
not about the fallback in general.

**AND OPTION B LOOKS LIKE A RULE VIOLATION AND IS NOT.** DY §3 deleted `CLASS_POOLS` and left the
standing rule **DO NOT RE-CREATE IT** — but that rule's own next sentence says that if the class
draw is ever re-opened it reads `CLASS_DRAFT_POOLS`, which is live and curated. **B reads exactly
that.** Worth naming, because a later reader would otherwise refuse B on sight.

### THE MEASUREMENT §1 ASKS FOR: EVERY SPEC'S DEPTH AGAINST THE AWARD COUNT *AFTER* THE FALLBACK

Derived, not assumed. A hero holds at most `ABILITY_SLOT_CAP − core_slots` earned abilities — **4,
or 3 for Holy** — so the deepest a fallback pool can be drained is that many.

- **UNDER A: no spec can lose an award, and the fallback pool's worst case is SIX cards.** Per
  spec, `draft pool − earnable`: Pyromancer 9, Swordmaster and Arcanist 8, Cryomancer, Devout and
  Holy 7, the other six 6. **8 emptiable specs → 0; 14 lost awards → 0.**
- **UNDER B: no spec can lose an award, and the worst case is TWO cards** — Warrior, Cleric and
  Hunter pools are 6 against 4 earnable; Mage's 7 leaves 3. Never empty, but thin enough that a
  three-card offer fills short on the last award of a long run.
- **UNDER C: no spec can lose an award in a normal run**, and every spec is identical because the
  rune pool is not spec-scoped. **In a runes-off run every one of the 14 is still lost.**
- **UNDER D: all 14 are still lost as ABILITY awards** — gold replaces the reward rather than
  filling the pool. The table above does not move at all under D, which is the honest way to state
  what D buys.

**So the fix is general under A and B, general-with-one-hole under C, and not a fix to this table
under D.**

---

## §2 — DIVINE WRATH, BLESSING OF ZEAL, AND ARCANE SURGE

**Measured. Ruled on nowhere.**

### THE TWO CARDS, SIDE BY SIDE

| | **Blessing of Zeal** | **Divine Wrath** |
|---|---|---|
| where | the Devout's **protected core** | the Devout's **draft pool** (DY §1) |
| cost | 20 Mana | 25 Mana |
| cooldown | **2** | 4 |
| initiative | **2.0** | **1.0** |
| target | one ALLY | every living hero |
| damage clause | **+15%** | **+15%** |
| second clause | cooldowns tick down 1 **NOW** | +15% speed |
| third clause | Faith gain **doubled** while it burns | — |
| Perfect / timing bar | none / none | none / none |
| in `Ability.PURE_BUFFS` | **no** | **YES** |

### THE FINDING: THE INITIATIVE IS NOT A PRICE

`Ability.make()` runs `if takes_delay_cap(a.special): a.delay = minf(a.delay, BUFF_DELAY_CAP)`.
**`divine_wrath` is a member, so its 1.0 is a clamp rather than a decision** — and the definition
writes it as the constant, not as a literal. **Divine Wrath has never been priced against anything.**

### AND BOTH MEMBERSHIPS ARE CORRECT, DRIVEN LIVE RATHER THAN ARGUED

Each card cast in a real battle on a Berserker / Arcanist / Devout / Sharpshooter party, with every
enemy's and hero's health, resource, Faith, initiative, statuses **and cooldowns** snapshotted
either side. `ability.gd`'s own criterion requires a pure buff to move *"no resource, no Pressure,
no cooldown and no initiative"*:

| card | what it moved at cast | verdict against the criterion |
|---|---|---|
| **Blessing of Zeal** | the target's `zeal` status **AND the target's COOLDOWNS** (3→2, 2→1) | **correctly OUTSIDE** — the same exclusion the header already names for Blink, *"Blink eats cooldowns"* |
| **Divine Wrath** | the `wrath` status on all four living heroes, **and nothing else** | **correctly INSIDE** |
| **Arcane Surge** | the caster's `surge` status **AND the caster's second resource, 0 → 2** | **correctly OUTSIDE** — the same exclusion as *"Stabilize vents Resonance"* |

**So there is no membership error and no magnitude error to name.** What there is, is that **the
cap is the only instrument in the project that prices an initiative, and it binds by table
membership** — so a card excluded for carrying a second payload gets no price at all. **That is why
§2's two questions are one question, exactly as the brief says.**

### THE FAMILY THAT SHOULD PRICE THEM, DERIVED LIVE

`ability.gd`'s PURE_BUFFS header names eleven cards as the second-payload exclusions. Read off the
live corpus, with the two cards in question placed among them:

| card | initiative | Mana | cooldown |
|---|---|---|---|
| Blink | 1.00 | 10 | 3 |
| Battle Shout | 1.50 | 15 | 2 |
| Dispel | 1.50 | 15 | 3 |
| Hold Breath | 1.50 | 15 | 3 |
| Quarry's Mark | 1.50 | 15 | 3 |
| Stabilize | 1.50 | **0** | 3 |
| Unburden | 1.50 | 20 | 4 |
| **Blessing of Zeal** | **2.00** | **20** | **2** |
| Ordination | 2.00 | 25 | 4 |
| Preparation | 2.00 | 25 | 5 |
| Elevation | 2.50 | 35 | 5 |
| **Arcane Surge** | **3.00** | **15** | **3** |
| Hold the Line | 3.00 | 30 | 6 |

- **MANA RISES WITH INITIATIVE ACROSS THE WHOLE FAMILY, AND ARCANE SURGE IS THE ONE CARD THAT
  BREAKS IT.** Every other card at 2.0 or above costs 20–35. **Arcane Surge carries the family's
  TOP initiative on 15 Mana and cooldown 3, against Hold the Line's 30 and 6 at the same 3.0.**
  It is priced like a 1.5 card on Mana and a 3.0 card on tempo. (Stabilize's 0 is not a
  counter-example: it VENTS a resource, so the cast pays itself.)
- **BLESSING OF ZEAL SITS ON THE FAMILY'S LINE ON INITIATIVE AND UNDER IT ON THE OTHER TWO AXES.**
  At 2.0 it is the cheapest card (20 against 25 and 25) and carries **by far the shortest cooldown
  in the family, 2 against 4 and 5.** **If either of the two is mispriced it is ZEAL, and it is
  mispriced LOW** — which is the opposite of the direction the brief allowed for.
- **FOR SCALE, THE CORPUS' OWN DISTRIBUTION:** of 227 abilities, 64 sit at 1.0, 21 at 1.5, 47 at
  2.0, 39 at 2.5, 37 at 3.0 and 19 above it. **3.0 is not extreme in the corpus** — it is the
  ceiling *of this family*, which is the comparison that means anything.

### IS THE DIFFERENCE A GENUINE DISTINCTION?

**On the payload, yes.** Zeal is single-target and buys **tempo** (a cooldown tick now) and
**engine** (doubled Faith on the carrier) alongside its +15%; Divine Wrath is party-wide and buys
**speed** alongside its +15%. Those are different cards, and a Devout would play them at different
moments. **On the initiative, no — because only one of the two has one.**

### AND THE TWO STACK, MEASURED

The two damage terms are **adjacent `if` blocks in the hero strike loop**, `battle.gd:8712` and
`battle.gd:8715`, `raw *= 1.15` each, with no `elif` between them. Twelve seeded blows on a Warden,
run in both orders:

| arm | forward order | reversed order |
|---|---|---|
| none | 151 | **159** |
| zeal | 183 — ratio 1.2119 | 183 — ratio **1.1509** |
| wrath | 183 — ratio 1.2119 | 183 — ratio **1.1509** |
| **both** | 212 — ratio 1.4040 | 212 — ratio **1.3333** |

**THE THREE CHIPPED ARMS READ BYTE-IDENTICAL IN BOTH ORDERS (183 / 183 / 212); ONLY THE UNCHIPPED
ARM MOVED.** The drift is entirely in whichever arm runs first — a Block roll on the Warden's basic
— so the reversed order, where *none* ran last, is the honest reading. Against the arithmetic
**1.15 / 1.15 / 1.3225**, the measurement says the two terms are **exactly equal**, and that
**a Devout who drafts Divine Wrath and casts Blessing of Zeal on the same hero pays both — a
1.3225 multiplier out of one hero's kit.** Speed: **95.000 → 109.250, ×1.1500 exactly.**

**Reported. Nothing was retuned, no membership moved, and `Ability.PURE_BUFFS` was not widened.**

---

## §3 — `CLAUDE.md` PRUNED

**261.77 KiB → 210.56 KiB, a cut of 51.21 KiB (19.6%). The knowledge-sync ratio goes 3.639% →
2.948%** over a sync of 157 files / 6.98 MiB. **CW's "under 3%" is met for the first time since it
was set**, and the arithmetic of the target is worth stating because it is not obvious: pruning
`CLAUDE.md` shrinks the denominator too, so clearing 3% needed **more than 47.8 KiB**, not the
46.4 KiB the naive subtraction gives.

### THE RULE APPLIED IS CW'S OWN, AND IT WAS APPLIED TO THE FILE CW CREATED

*Does this line tell a future session what to do or not to do?* Every rule stayed. Every batch
narrative attached to a rule went, and **the reason each rule exists is kept to one sentence.**

### WHAT WAS GATHERED BEFORE ANYTHING WAS CUT — THE SAME TRAP, AND IT DID APPLY AGAIN

**Twelve rules were stated inside a narrative and would have gone with it.** They are now in the
file's own voice:

1. **A STANDING BLOCK STATES A NUMBER ONCE.** It was buried in the paragraph explaining how a
   superseded snapshot survived CW's split — inside the very block that then restated the draft
   total in six places at four different historical values.
2. **Write a suite's refusal setup RELATIVE TO THE LIVE POOL SIZE**, never against a hardcoded
   count of the hero's own cards — the hardcoded shape stops measuring the fill-short rule the
   moment a pool deepens under it.
3. **A construction that has to relocate is how a paid debt announces itself; one that can no
   longer relocate is how a finished one does.**
4. **Verify a class-wide card's "weaker" half against the LIVE spec kits AND against the free core
   attack** — it was written as *"BQ ADDS A THIRD RULE, LEARNED BY BREAKING IT"*.
5. **To find the next hole in a fingerprint, ask what the rule IS about and re-derive the
   fingerprint from it** — not patch the holes you were told about.
6. **An exemption is keyed `file::func`, never by file.**
7. **Characterise a failure before naming it** — a flake recorded as one thing at one rate turned
   out to be a different thing at a different rate once measured at scale.
8. **Where a generated walk is the subject, seed at every generation** — the guarantee is per-BOARD.
9. **The criterion decides whether an ability grades; it does not decide what an orphaned bonus
   becomes.**
10. **A gate that reds on a repair teaches the next batch to leave the defect alone** — the reason a
    known-pair ratchet is asymmetric.
11. **Moving a talent cell owes a save migration; not moving one owes nothing.**
12. **Never write `12 * 8` or `4 * 6`** — it was two paragraphs from two batches saying it
    separately.

### AND TWO THINGS THE GATHER FOUND THAT THE BRIEF DID NOT NAME

**(1) THE FILE STATED SIX RULES TWICE, AND DUPLICATION IS THE DEFECT IT RECORDS AS THIS PROJECT'S
OLDEST.** "Verify before shipping" and "THE TRAPS" both carried the `--fixed-fps 12` trick, the
battery destroying the run save, `class_name` files needing `--headless --import`, the GDScript
gotchas, the tab-indented JSON rule, and the two run-harness gate rules. **The file enforcing
"one authored copy" was carrying six second copies of its own rules.** Each is now stated once.

**(2) IT CARRIED LIVE COUNTS THAT HAD GONE STALE, AGAINST ITS OWN RULE THAT LIVE COUNTS BELONG IN
`docs/state.md`.** Found and **removed rather than corrected**, because correcting them creates the
second copy again: the ability corpus at **216** (live **227**), the CL walk at **211**,
`RECAST_GATED` at **59** (live **64**), *"113 of the 211 drafted abilities run no bar"*,
*"211 abilities → 134 → 58"*, `CLASS_DRAFT_POOLS` *"live at 24 (4 × 6)"* (live **25**), the run
harness at *"22 / 165 / 8"*, and the skill-check profile's six values. **Every one is now a pointer
to `baselines.json` or `docs/state.md`.**

### HOW IT WAS PROVED SAFE, BECAUSE 26 TARGETS ASSERT AGAINST THIS FILE

**Nine gates and seventeen suites read it** (18 more only name it in a comment). Three
instruments, all run **before** the certification battery:

- **A NEEDLE VERIFIER, BUILT FROM THE TREE AND GREEN AT HEAD BEFORE A LINE WAS CUT.** Every literal
  any suite or gate asserts against `CLAUDE.md` — **57 needles** plus `test_batch_cd`'s structural
  slice (the anchor resolves, the END anchor resolves, the slice is >500 chars, it carries
  *154 of 154*, and it states none of the five stale-target phrases). It was re-run after every
  edit. **IT CAUGHT TWO REAL BREAKS**: `THE WARRIOR POOLS WERE OWED AND ARE PAID` and
  `THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY FOR EVERY HERO IN THE GAME` had each been split
  across a line wrap in the rewrite. **A needle broken by a line break is invisible to reading and
  fatal to a `contains`.**
- **A LITERAL SWEEP AT A FOUR-CHARACTER FLOOR**, 10,948 distinct literals from all 81 suites, gates
  and fixtures, diffed against the file before and after: **174 LOST, 0 GAINED.** The zero is the
  half that matters — a GAINED literal is what turns a negative assertion green with a false
  message. Every one of the 174 was cross-referenced and none is the subject of a positive
  assertion against this file; they are incidental words (spec keys, card names,
  `user://profile.json`) that happened to appear in the narrative that went.
- **AND THE VERIFIER'S OWN EXTRACTOR HAD A HOLE THAT ONLY A RUN COULD FIND. THIS IS THE MOST
  USEFUL RESULT IN §3.** A 17-suite subset battery was run over the pruned file **before** the
  certification run, and **`test_batch_ce` came back 1114 / 1** while the needle verifier was green
  and the literal sweep showed nothing gained. **The extractor took only the FIRST literal out of
  each `contains(` call**, and `ce`'s assertion is an **AND of two**:
  `cm.contains("THE CLERIC SECOND") and cm.contains("ALL FOUR ARE COMPLETE")`. The first survived
  the rewrite and the second did not. Restored; `ce` re-reads **1114 / 0**.
  · **A RE-EXTRACTION THAT TAKES EVERY `contains(` ARGUMENT IN A WHOLE STATEMENT FINDS SEVEN MORE
    NEEDLES, AND SIX OF THE SEVEN ARE HARMLESS** — four are the unused half of an `or` whose other
    half is present, and two are `not contains(...)` halves whose ABSENCE is the passing state.
    **Exactly one was real, and it was the one three green instruments could not see.**
  · **THE LESSON IS THE ONE THIS FILE ALREADY RECORDS ABOUT FINGERPRINTS: A SWEEP IS ONLY AS WIDE
    AS THE CONVENTION IT MATCHES.** A literal-presence pass cannot see an assertion that lowercases
    the file first — `test_batch_ba`'s `to_lower().contains("self-propagating")`, found only by
    grepping for **method calls on the variable holding the file** rather than for literals — and a
    first-literal extractor cannot see a compound. **Neither hole is knowable from inside the
    instrument. THE RUN IS WHAT FINDS THEM**, and a 17-suite subset costs minutes against the
    thirty-five a full battery costs.

### WHAT REMAINS, AND WHY IT COULD NOT GO

The target is met, so this is the more useful half of the answer.

- **THE TEST TREE PINS THIS FILE'S PROSE, SO THE PRUNE IS BOUNDED BY ASSERTIONS RATHER THAN BY
  JUDGEMENT.** 57 strings must survive verbatim, and several of them read as history —
  `TRANCHES 2 AND 3 ARE BOTH PAID`, `THE WARRIOR POOLS WERE OWED AND ARE PAID`, `THE CLERIC
  SECOND`. **They are kept because a suite reads them, not because they are rules.**
- **THREE OF THOSE ASSERTIONS PIN A BATCH CODE — `BATCH BN`, `BATCH BS`, `BATCH CE` — WHICH IS THE
  EXACT SHAPE CW'S SPLIT WAS MEANT TO END.** `docs/state.md` already records `bs`'s as passing by
  accident. **They are the reason a batch-code mention cannot leave this file**, and re-pointing
  them at rules is a suite edit rather than a document edit. **Owed, and not taken here.**
- **THE REFERENCE TABLES STAY IN FULL** — the debug surfaces and env flags, the uncapped-meter
  governor table, the computed-block reference, the architecture map. Every line of those tells a
  future session what to do, and they are the largest thing left.
- **`test_batch_cd` REQUIRES THE ABILITY-DRAFT BLOCK NOT TO BE THE LAST `## STANDING` HEADING IN
  THE FILE**, because it slices from that anchor to the next one. That is a structural constraint
  on reordering, and it is recorded here because nothing else states it.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **No card was authored and no fallback was implemented.** §1 is options.
- **No ability magnitude moved and no `PURE_BUFFS` membership moved.** §2 is a measurement.
- **`Ability.PURE_BUFFS` is not widened to take Arcane Surge**, and §2 measured the reason rather
  than inheriting it: its Resonance bank is a real second cast-time payload.
- **`docs/state.md` is not pruned.** It is rewritten every batch and cannot grow by construction.
- **The three vacuous assertions in `as`, `at` and `aw` are untouched**, and the prune neither
  created nor closed one — all three search for strings that were already absent at HEAD.

---

## §5 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html` and `docs/design-notes.md` were all final
before the certification run, because roughly thirty-five suites read the first three and one reads
the fourth. **`docs/state.md` and this report are written after it and are read by nothing**, which
is why this project writes them last.

### THE BASELINE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: NOT ONE ROW IN `baselines.json` MOVES, AND `check_de` READS 321 / 0 / 0.**

DY's lesson is applied while predicting — **the set of loops a batch moves is not the set of files
it edits, so predict from what each suite READS** — and here it is what makes the prediction
confident rather than what threatens it. **DZ edits no `.gd` file and no data file.** Every edit is
a document, and every assertion against those documents is a `contains` whose COUNT is fixed:

- **`CLAUDE.md`** — around twenty-five suites and gates read it, and **not one of them loops over
  its content**; each runs a fixed number of `contains` calls. Its size can change by 51 KiB
  without moving a single check count. Pass/fail could move, and three instruments say it does
  not (see §3).
- **`docs/master.html`** — only the stamp moved, DY → DZ. The fourteen stamp gates parse the code
  out of `Last updated:` and assert it is **no older** than their own batch code; `DZ` sorts after
  every code from `ah` to `ce`. The retired-word sweep was run over the edited file first and reads
  **0 *party* / 0 *beast* both before and after.**
- **`docs/changelog.html`** — one entry added, 19 → 20. **`check_dv` §4 counts headings into an
  integer and asserts a FLOOR of 16**, printing the live figure; it does not assert per entry, so
  the +1 costs no check. Every other changelog assertion in the tree is either the archive-path
  anchor or a negative that an added entry cannot make false.
- **`docs/design-notes.md`** — appended to, never rewritten, so every `contains` on it still holds.
- **`docs/reports/DZ.md`** — read by nothing.
- **`baselines.json`** — read by `check_de` alone, which asserts four per target. **DZ adds no
  target and no gate, so `check_de` does not move either.**

**If a row moves, it is a finding and not bookkeeping** — which is the whole reason for predicting
a flat table rather than an approximate one.

### THE PRE-BATTERY DEFENCES, ALL RUN BEFORE THE CERTIFICATION RUN

1. **The needle verifier**, green at HEAD before a line was cut and re-run after every edit —
   60 needles plus `test_batch_cd`'s structural slice. **Caught two line-wrapped breaks.**
2. **The literal-flip sweep** over all four edited documents, 10,948 literals at a floor of 4, with
   every GAINED literal cross-referenced against the tree's **246** negative assertions:
   **`CLAUDE.md` 0 gained / 173 lost; `master.html` 0 / 0; `changelog.html` 9 gained / 0 lost;
   `design-notes.md` 0 / 0.** **None of the nine gained literals is negatively asserted anywhere** —
   they are ordinary card and word names (`Blessing of Zeal`, `Blink`, `Stabilize`, `divine_wrath`,
   `gold`) that arrived with the changelog entry.
3. **The retired-word sweep** over the edited `master.html`, using `test_batch_bx` §4b's own
   `PARTY_IDENTS` strip and §4's `Beastmaster` strip: **0 and 0, in the edited file and at HEAD
   alike.**
4. **A 17-suite subset battery over the pruned `CLAUDE.md`**, which is the one that found something
   the other three could not. See §3.

### THE ACCEPTANCE RUN

**One battery, and it found nothing.** No suite failure, no throw, no notice, and the only red is
the one that is on purpose.

| | DX's acceptance | DY's acceptance | **DZ's acceptance** |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 321 / 0 / 0 | 321 / 0 / 0 | **321 / 0 / 0** |
| targets in the manifest | 78 | 78 | **78** |

**SEVENTY-EIGHT TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-EIGHT.** **0 `Parse Error` and 0
`SCRIPT ERROR` across all 78 logs** — grepped from the streams rather than read off a tally or an
exit code, and **not one of the 78 logs contains either marker.** The run harness reads
**22 / 165 / 8**, all three passing; `check_map_screen: OK`; `check_ct_map` 83 / 0.

### THE PREDICTION HELD EXACTLY, AND THAT IS THE RESULT

**`check_de` reported 321 checks, 0 failures and ZERO NOTICES — not one row in `baselines.json`
moved, which is what was predicted before the first reading.** The file was not edited at all.
**This is the first batch in the record to predict a completely flat table and get one**, and the
reason is worth keeping rather than the fact: **DZ edits no `.gd` file and no data file**, and
every assertion against the documents it does edit is a `contains` whose COUNT is fixed. **A
51 KiB cut to `CLAUDE.md` moves no check count**, because nothing loops over its content.
`test_batch_an` read **6050**, inside its recorded [6046, 6063] band, and the differ said so by
saying nothing.

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**174 files were MD5-stamped before the acceptance run and re-compared after. EXACTLY TWO
DIFFER: `docs/state.md` and `docs/reports/DZ.md`** — the two written during it — **and both are
read by nothing**, which is precisely why this project writes them last. `CLAUDE.md`,
`docs/master.html`, `docs/changelog.html` and `docs/design-notes.md` are **byte-identical across
the run**, so the battery certified the documents that shipped.

### THE NEGATIVE CONTROLS

1. **THE NEEDLE VERIFIER WAS PROVEN TO BITE, IN THE EXACT FAILURE MODE IT EXISTS FOR.** With the
   tree restored and certified, `TRANCHES 2 AND 3 ARE BOTH PAID` was split across a line wrap —
   **not one character deleted** — and **both instruments went red: the verifier reported the
   violation by name, and `test_batch_bo` failed with `§6: ...and CLAUDE.md records both depth
   tranches as PAID, not as owed`.** Restored **by `cp` from a scratchpad backup, never by
   `git checkout`**, and `CLAUDE.md`'s md5 is byte-identical to the certified run
   (`0ef0d3f373a594a49279e61073bded4e`); `test_batch_bo` re-reads **1131 / 0**.
2. **AND TWO CONTROLS FIRED WITHOUT BEING ASKED, WHICH IS WORTH MORE THAN THE ARMED ONE.** The
   verifier caught **two** genuine line-wrap breaks during the rewrite, and the 17-suite subset
   battery caught the compound assertion in `test_batch_ce` that the verifier and the literal
   sweep were both structurally unable to see. **Three instruments, and each one caught something
   the others could not.**
3. **NO PARSE CONTROL WAS RUN AND NONE WAS OWED.** DZ edits no `.gd` file, so there is no parse to
   break; `check_parse` and the 78-log stderr grep cover the tree as it stands.
