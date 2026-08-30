# BATCH DY — THE VAULT IS EMPTIED

*2026-08-30. Six sections. **Seven finished abilities that no run could reach are re-homed into
live pools, `CLASS_POOLS` is retired, Holy's empty boss awards close as a consequence, the last
unseeded flake is seeded, and the draft audit's arithmetic is re-derived.** Not one card was
authored and not one magnitude moved. The draft goes 149 → 154; **the ability corpus reads 227 on
both sides of the batch.***

---

## THE BRIEF'S AND THE RECORD'S CLAIMS THAT DID NOT SURVIVE MEASUREMENT

Recorded first, because four of them changed the work.

1. **§1 says Divine Wrath and Bring It Down "will sit in sibling pools". THEY WILL NOT, AND THE
   COMPARISON THAT MATTERS IS A DIFFERENT ONE.** Bring It Down is a **BEASTMASTER** card — Hunter
   class, added by DS — and Divine Wrath goes to the **Devout**, a Cleric spec. They are in
   different classes and can never appear in one offer. **The live comparison is sharper than the
   brief's: BLESSING OF ZEAL IS THE DEVOUT'S OWN PROTECTED CORE**, +15% damage on ONE ally at
   initiative **2.0**, and Divine Wrath is that card made party-wide at **1.0**, landing in the same
   hero's kit. Derived from `protected_names("inquisitor")`, not recalled.
2. **DX §3 and `docs/state.md` both say `vault_ability()` holds 38 definitions, of which later
   batches re-homed 31. THE LIVE FUNCTION HOLDS TEN.** Counted mechanically off its own `match`
   arms: Rallying Shout, Retaliation, Mana Shield, Ashes of Al'ar, Arcane Surge, Reality Fracture,
   Dawnbreak, Sanctuary, Divine Wrath, Umbral Sigil. **Seven were the orphans and the other three
   were already in `SPEC_POOLS`.** The vault's own header has said "ten" since Batch AH. Nothing
   about the work changes — the seven were derived live and are exactly the seven — but a figure
   quoted twice in the record was wrong by 28.
3. **DX §1 reports that its sweep left exactly SIX equalities against the draft, all in
   `test_batch_cd`. A SEVENTH SURVIVED, AND IT IS THE ONE THIS BATCH WOULD TRIP.**
   `test_batch_bq:184` reads `ok(live.size() == 6, …)` where `live` was assigned from
   `class_draft_pool(cls)` two lines above — so a sweep matching the pool ACCESSOR inside the `ok()`
   condition could not see it. Mana Shield takes the Mage class pool to seven. **A condition reading
   a local is still a condition reading the pool.**
4. **§6 says the draft's movement is "one edit in `test_batch_cd`, not twelve files". THE FLOOR HALF
   HELD EXACTLY; A SECOND POPULATION DX's SWEEP NEVER LOOKED AT DID NOT.** All twelve floor files
   stayed silent, which is the payoff and it is real. But **six more files carried a hard-coded
   `"149 of"` needle against `master.html`** — `bu`, `bv`, `bw`, `br`, `ce` and `check_do` — and
   every one would have gone red on the document changing. They are not equalities against a pool;
   they are `contains` assertions against a DOCUMENT, so DX's sweep was pointed elsewhere. **They
   are rendered from the live pool count now**, so the next batch to move the draft edits none of
   them.
5. **DX §3 prices the retirement as moving "six sites at once". EIGHTEEN FILES READ IT**, and a grep
   for the constant found only some of them — `class_pool()`, its accessor, had callers whose lines
   never mention `CLASS_POOLS` at all.
6. **Everything else held**, including DX's homes (each re-verified against the live pool before it
   was taken), the seven-name orphan list (re-derived live, exactly those seven), `CLASS_POOLS` at
   61 entries, `pool_ability()` never reading it, and DV's boss-pool depths for every spec DY did
   not touch.

---

## §0 — THE ORDER, AND IT IS THE RULE THIS BATCH LEAVES BEHIND

**Re-home first, retire the container second.** All seven reached `ability_corpus()` through
`class_pool(key)` and no other route, so deleting `CLASS_POOLS` first would have dropped the corpus
**227 → 220 mid-batch** and moved the printed population of roughly fifteen gates for no reason at
all — every one of which would then have had to be moved back.

**Done in this order the corpus never moved, and that was stated as the expected result before the
run rather than discovered after it.** Measured at three points: 227 at HEAD, 227 after §1 and §2
with the container still standing, 227 after §3 deleted it.

**The transferable half is not the ordering but why the wrong order is expensive.** It does not
fail; it fills the batch with expected movement, and a real movement hiding among fifteen expected
ones is indistinguishable from bookkeeping. It is in `CLAUDE.md` under DV §1's block.

---

## §1 — THE FIVE DRAFT CARDS, EACH VERIFIED AGAINST THE LIVE POOL

| ability | home | pool | what it brings |
|---|---|---|---|
| **Rallying Shout** | Warden draft | 9 → 10 | RESOURCE / PARTY — a decision his pool did not hold |
| **Mana Shield** | Mage CLASS draft | 6 → 7 | nothing else in the game converts damage taken into Mana |
| **Arcane Surge** | Arcanist draft | 10 → 12 | AMP-SELF / SELF; the Resonance bank is his own engine |
| **Reality Fracture** | Arcanist draft | (same) | **the only ability in the 227-card corpus with a non-zero `delay_push`** |
| **Divine Wrath** | Devout draft | 10 → 11 | AMP-TEAM / PARTY — an axis that pool did not have |

**THE DUPLICATION CHECKS WERE RE-DERIVED, NOT TAKEN ON RECORD, AND TWO CAME OUT SHARPER THAN THE
BRIEF'S VERSION.**

- **Rallying Shout's overlap is with the TALENT TREE, not the draft pool.** Its Break-shed clause is
  Battered Not Broken (`wd_immovable`) and its refuel clause is Rallying Cry (`wd_stomp_drill`) —
  **both are Warden talent nodes, not cards** — and War Stomp, which also refuels, is a BOSS-pool
  entry. **Nothing in his draft pool does either**, so the card brings two axes that draw space has
  never offered.
- **Reality Fracture's uniqueness is total and is derived rather than argued.** Walking all 227
  abilities, exactly one carries a non-zero `delay_push`, and it is this card.
- **Mana Shield's is too.** Walking the corpus for anything converting damage taken into Mana
  returns one card.

### THE THREE PRICING QUESTIONS — SHIPPED AS AUTHORED, FLAGGED, WITH OPTIONS

**Nothing was retuned. All three come back to the designer.**

**(1) ARCANE SURGE SITS AT INITIATIVE 3.0, THREE TIMES `BUFF_DELAY_CAP`.** It is legitimately
outside `PURE_BUFFS` — its Resonance bank is a second, cast-time payload, so the clamp does not
apply — but *legitimately outside the cap* is not the same as *priced against it*, and it never has
been. For scale: 3.0 is not extreme in absolute terms (Pyroblast is 6.0, Death Ray 5.0), but every
other card whose payload is a self-amp is at or under the cap.
- **A. Ship as is.** The Resonance clause is a real second payload and 3.0 pays for both.
- **B. Bring it to `BUFF_DELAY_CAP` (1.0)** and let `PURE_BUFFS` membership do it, accepting that
  the Resonance bank then rides free.
- **C. Split the difference at `BASIC_DELAY` (2.0)**, PREPARATION's price, on the reading that a
  two-clause self-buff costs a basic attack's tempo.

**(2) DIVINE WRATH IS PARTY-WIDE +15% DAMAGE AND +15% SPEED FOR 4 TURNS AT INITIATIVE 1.0 — AND IT
LANDS IN THE KIT OF A HERO WHO ALREADY HOLDS THE SINGLE-TARGET VERSION AT DOUBLE THE PRICE.**
Blessing of Zeal is the Devout's **protected core**: +15% damage on ONE ally, initiative **2.0**,
20 Mana, cooldown 2, plus a cooldown tick and doubled Faith gain. Divine Wrath is 25 Mana,
cooldown 4, initiative **1.0**, party-wide, and adds a speed term. DS's Bring It Down is priced at
**2.0** on PREPARATION's precedent that party-wide costs more — **it is a Beastmaster card, so it
is a precedent rather than a sibling.**
- **A. Ship as is.** Cooldown 4 against Zeal's 2 is the real limiter, and the Devout is a support
  spec whose party-wide cards are his identity.
- **B. Price it at 2.0**, matching Bring It Down and the PREPARATION precedent. **This is the one
  the precedent points at.**
- **C. Price it at 2.0 AND drop the speed clause**, if the two terms together are the objection
  rather than the initiative.

**(3) SANCTUARY OVERLAPS HYMN OF HOPE, HOLY'S PROTECTED CORE PARTY-HEAL. Different shape, same
job.** Hymn: 0 Mana + **1 Mercy**, heals ALL allies 20% of max (35% empowered), initiative 3.5,
cooldown 2. Sanctuary: **30 Mana**, no Mercy, heals every ally 12% of max (18% on a Perfect),
initiative 3.5, cooldown 4. **Whether that clears the standing no-duplication rule is a ruling and
it is not taken here.** The rule as written forbids *a strictly better version of another card in
the same pool*, and **Sanctuary is not that — it is strictly worse on magnitude and pays a
different currency.** The honest reading is that it clears the letter of the rule and raises the
question the rule exists for: does the Holy Cleric need a second party-heal at all?
- **A. Ship as is.** The currencies differ, so the two cards are played at different moments — Hymn
  when Mercy is banked, Sanctuary when it is not. That is a real decision.
- **B. Move Sanctuary to the INQUISITOR's boss pool instead.** DX named him as an alternative home;
  it also closes the shortfall §2 leaves open on that spec, and removes the overlap outright.
- **C. Retire Sanctuary** and leave Holy's pool at two, accepting one empty award in three.
**Recommendation, since one is asked for: B.** It answers §2's surviving finding and §1's
duplication question with one move — but it is a design call and it is the designer's.

---

## §2 — HOLY'S BOSS POOL GOES 1 → 3, AND THE GENERAL PROBLEM SURVIVES IT

**Dawnbreak and Sanctuary join Divine Plea.** Both are Cleric heals out of the vault with live
handlers, card text and a Perfect apiece, so this closes the shortfall **without authoring
anything**, and the four fallback candidates DV priced are no longer needed for Holy.

**BUT THE QUESTION IS NOT CLOSED, AND EVERY SPEC WAS RE-MEASURED RATHER THAN ASSUMED.** The award
count is **three**, derived from `Run.SLOT_COUNT`. Two measures matter and they disagree, which is
the finding:

| spec | boss pool | of them draftable | awards that can pay nothing |
|---|---|---|---|
| **Devout (inquisitor)** | **2** | **2** | **3 — every one** |
| Berserker | 3 | 2 | 2 |
| Pyromancer | 3 | 2 | 2 |
| Cryomancer | 3 | 2 | 2 |
| Occultist | 3 | 2 | 2 |
| Swordmaster | 4 | 2 | 1 |
| Arcanist | 4 | 2 | 1 |
| **Holy** | **3** | **1** | **1** |
| Warden | 4 | 1 | 0 |
| Beastmaster / Sharpshooter / Survivalist | 5 | 0 | 0 |

- **THE DEVOUT IS THE SHARPEST CASE IN THE GAME NOW, AND HE IS WORSE OFF THAN HOLY EVER WAS.** He is
  the only spec left with a *structural* shortfall — two cards against three awards — and **both of
  his two are also draftable**, so a run in which he drafts them leaves all three of his zone-boss
  awards paying nothing.
- **EIGHT OF THE TWELVE SPECS CAN BE SHORT ONCE DRAFTING IS ACCOUNTED FOR.** Only the Warden and the
  three Hunter specs cannot. That figure did not move: DY changed Holy's severity, not the
  population.
- **SO THE FALLBACK QUESTION STAYS OPEN AND IS RECORDED AS OPEN IN `docs/state.md`**, rather than
  being quietly closed by Holy's fix. `check_dv` §2 derives the whole table every run and prints it.
- **THE SHARP POINT, RECORDED:** `ABILITY_SLOT_CAP` is 7 and **the Holy Cleric carries FOUR
  protected cores, the only spec that does** — so she has three earnable slots, the fewest in the
  game. **The spec with the emptiest pool also had the least room to receive a card**, which is why
  the card-shaped fallbacks DV priced were worth least exactly where the hole was worst.

**AND THE GATE WENT RED ON THE FIX, WHICH IS WHAT IT IS FOR.** `check_dv:185` pinned Holy's pool at
ONE as a staleness tripwire on an open finding; DX examined it in its sweep and left it standing on
exactly that reasoning. It failed the moment DY §2 landed and said the report was stale. It reads
`== 3` now, beside a derived count of the specs that can still be emptied.

---

## §3 — `CLASS_POOLS` IS DELETED, NOT ZEROED

61 entries across four classes, every one authored and resolving, feeding an award **Batch AN §4
re-pointed away eighteen batches ago**. `pool_ability()` never read it, so all seven of its
exclusive entries still resolve with it gone; what was lost is the **manifest**, and that is the
point — they are no longer a group.

### WHAT READ IT, REPORTED BEFORE ANYTHING WAS DELETED

**EIGHTEEN FILES, AND A GREP FOR THE CONSTANT FOUND ONLY ELEVEN OF THEM.**

| how it was reached | files |
|---|---|
| `Classes.CLASS_POOLS` by name | `ah`, `ar`, `at`, `av`, `bb`, `bq`, `br`, `bt`, `bu`, `bv`, `bw`, `cb`, `ce`, `check_ck_width`, `check_dv` |
| `Classes.class_pool()` — the ACCESSOR, on lines that never name the constant | `ah`, `ah_battle`, `ak`, `an`, `au`, `bb`, `bo`, `bp`, `check_cz`, `check_dn` |
| a COMMENT naming it | `classes.gd` ×9, `battle.gd`, `run_state.gd`, `unit.gd`, `au`, `bp`, `bj` |
| the SOURCE, as a string | `bj` (`contains("const CLASS_POOLS")`) |

**THE ACCESSOR IS THE LESSON: THE SYMBOL YOU DELETE AND THE SYMBOL PEOPLE CALL ARE NOT THE SAME
SYMBOL.** Seven files would have survived a constant-name sweep untouched and failed to parse.

**EVERY READER IS RE-POINTED OR INVERTED — NONE IS LEFT TO PASS VACUOUSLY.** Where the question
survives the structure it is asked of the live one: AH's CURATION RULE (nothing offered class-wide
may cost a spec-exclusive resource) now binds `CLASS_DRAFT_POOLS`, which is the live class-wide
offer and which DY §1 just added a card to; the leak controls in `bq`, `br`, `bt`, `bu`, `bv`,
`bw`, `cb` and `ce` ask about `SPEC_POOLS`, which is the whole boss channel now; and `test_batch_bo`
§4's sibling-collision guard compares against the sibling specs' own boss pools, **derived live at
zero collisions**, rather than against an empty dict. Where the question does not survive, the
assertion is INVERTED to pin the container's absence off the source — `test_batch_an`'s idiom for
`roll_ability_offer`. **A check that survives a deletion by asking an empty dict a question is worse
than a red.**

### THE COMMENTS, INCLUDING THE ONE THAT RECORDED THE KEEP

**`test_batch_bj` is the sharpest artefact this thread produced and it is worth more than the
deletion.** BJ swept for dead symbols and deliberately KEPT `CLASS_POOLS`, writing the keep's reason
into its own failure message — *"stands ready for the day the class draw reopens (AN §4)"* — and
directly beneath it asserted the seven vault entries with the message *"reachable only through the
dead class draw"*. **The suite recorded both halves of the problem in adjacent lines and neither
line could see the other.** A keep is a decision and it can expire; the assertion is inverted rather
than deleted, so the file still records what happened to a symbol it once protected, and each of the
seven is now pinned to its actual home.

`run_state.gd`'s comment said re-opening the class draw was *"a one-line change if the designer
wants it back"*. **True of the code, and the smallest part of the price** — 56 of the 183
hero-and-entry pairs a reopened draw could offer duplicated something that hero can already reach,
and 27 of those were the hero's own protected core. The comment says so now.

### `vault_ability()`'s HEADER IS HISTORY RATHER THAN A PLAN

It promised for eighteen batches that its entries *"return as earnable picks without a line of new
mechanics"*. **The promise was true and the exit was shut.** All ten have returned now, and the
header records that, plus the rule it leaves: **a new vault entry is owed a pool in the same batch.**
The function is KEPT and is not a holding pen — it is the single-source definition table those ten
live cards resolve through.

### ONE DERIVED FIGURE MOVED FOR A REASON THAT IS NOT ABOUT THE GAME

`check_dv` §5 counts the abilities the corpus reaches that sit **outside every pool and every class
kit** — 16 on record. **It reads 43 now, and nothing became less reachable.** `CLASS_POOLS` was the
only structure in the project that named the SIBLING SPECS' KIT ABILITIES as pool entries: Bloodlust,
Mocking Blow, Hex of Ruin and twenty-four more were "in a pool" only because the class-wide boss pool
listed them. Every one of them is in its own spec's opening kit, which `spec_abilities()` returns and
that deliberately narrow walk does not read. **The old sentence beside it — that this population is
invisible to a walk built the old way — is corrected rather than left to rot:** the Batch CL walk
reads `spec_abilities()` too, reaches **223 of 227**, and misses exactly the four kit overrides,
which is `check_cz` §0's set identity and is asserted there once rather than twice.

**AND `check_cz`'s SET IDENTITY HELD THROUGH THE DELETION, MEASURED RATHER THAN HOPED.** Its
`_cl_only_corpus()` lost its `class_pool` arm; the walk still reaches 223 and the difference is still
exactly `Fireball`, `Frostbolt`, `Arcane Explosion` and `Shadowrend`. The difference is derived off
`apply_kit_overrides` at the assertion site, so a deletion that changed it could not have been
silent.

---

## §4 — THE LAST UNSEEDED FLAKE, SEEDED, AND IT SETTLED AT ZERO

**`test_batch_at` §1's live damage-curve ratio is seeded per-pair and it settled at zero, so it was
a flake and not a finding.**

**WHAT IT WAS.** The check sums ten casts of Arcane Explosion at 0 Resonance against ten at 12 and
asserts the ratio is `> 2.0 and < 2.35` against a table value of 2.17. It read **2.40** at DG and
has read clean in every battery since — twenty consecutive quiet readings at an observed rate of
about one in eighteen, which proves nothing. **The file calls `seed()` in four places and every one
of them is downstream of this check**, so the one measurement in it that most needed determinism was
the one running on whatever the startup RNG happened to be.

**THE FIX IS TWO LINES AND THEY ALREADY EXISTED TWELVE LINES BELOW.** The TAKEN half of the same
function has called `_seeded(_i)` immediately before each of its two compared blows since DD. The
DAMAGE half never did. Both arms of a pair now draw one identical stream, so the ±10% variance roll
cancels between them and the only difference left is the stack count; `_i` varies the draw across
the ten pairs, so the sum is still an average of ten different variances rather than one measurement
taken ten times.

**MEASURED, NOT ASSERTED — SIX READINGS EACH WAY, WITH THE STARTUP STREAM VARIED BETWEEN TRIALS:**

| | ratios |
|---|---|
| **unseeded** | 2.1736, 2.1489, 2.1469, 2.2463, 2.1189, 2.2391 |
| **seeded** | **2.1799, 2.1799, 2.1799, 2.1799, 2.1799, 2.1799** |

**Exactly repeatable, and it lands at 2.1799 against the table's 2.17.** The band is not widened —
DD's rule, and the reason is the same here as there: **the band IS the question.** 2.0–2.35 is what
separates a compounding curve from one that is not, and opening it to swallow a 2.40 would delete
the check rather than repair it.

**THE CHECK COUNT DID NOT MOVE — 467, three readings — because a seed is not an assertion.**

**THERE ARE NO UNSEEDED FLAKES LEFT IN THE PROJECT.**

**AND THE CENSUS WAS TWO ROWS, NOT ONE — A SIXTH RECORD CLAIM THAT DID NOT SURVIVE MEASUREMENT.**
`docs/state.md` says *"`baselines.json`'s `flake` fields are the census; `test_batch_at` is the one
row still carrying one."* **`test_rune_battle` carries one too.** Its field is KEPT deliberately and
correctly: DF §0 seeded that suite at the exact site that flakes, but what the field records is a
**race under machine load** — 2 red in 15 readings, both under load — and **a seed does not fix a
race**, so the field and its `[0,1]` band both stand. **One row carries a `flake` field now and it
is a SEEDED one.**
**AND THAT ROW'S OWN TEXT WAS STALE IN THE WAY DT ALREADY CORRECTED ELSEWHERE.** It read *"the proc
has to actually land; test_rune_battle calls `seed()` ZERO times"* — false since DF §0. DT
re-derived that and corrected `docs/state.md`; **the `baselines.json` record was the copy nobody
swept.** Corrected here, toward the code, which is the standing direction.

---

## §5 — THE DRAFT AUDIT, RE-DERIVED

`docs/draft-audit.html` §2 and §2b were marked STALE at DT — deliberately, because refreshing them
means assigning an axis to every card authored since, which is that page's own judgement call. **DY
was asked to do it and did.**

**THE METHOD IS DQ's, UNCHANGED, AND THAT IS A DECISION.** Each card carries ONE primary axis and one
target shape, taken from the per-card appendix; the eleven cards authored since DQ were assigned
inside that same vocabulary, and nothing was re-cut. A refresh that also moves the definitions cannot
be compared with what it replaced.

**NINE OF THE SIXTEEN POOL ROWS MOVED AND SEVEN DID NOT.** Moved: Swordmaster and Cryomancer (DR),
Beastmaster, Sharpshooter and Survivalist (DS), Warden, Arcanist, Devout and the Mage class pool
(DY). Unchanged: Berserker, Holy Cleric, Occultist, Pyromancer, and the Cleric, Hunter and Warrior
class pools.

**DQ'S QUESTION — "HOW MANY CARDS BEFORE THE POOL STOPS OFFERING ANYTHING NEW?" — ANSWERED AGAIN.**
The floor is the **Cleric class pool at FIVE**; the ceiling is **TEN**, held jointly by the Warden
and the Pyromancer.

- **THE WARDEN IS THE SHARPEST RESULT AND IT IS NOT THE ONE THIS BATCH SET OUT TO GET.** He was the
  shallowest pool in the game at nine cards. He now holds the **joint-widest decision spread in it —
  ten decisions across ten cards, the only pool in the game where every card makes a different
  decision.** One vault card did that, because RESOURCE / PARTY was a shape nothing in his pool had.
- **THE MAGE CLASS POOL IS THE OPPOSITE RESULT AND IS REPORTED AS SUCH.** Mana Shield is
  RESOURCE / SELF, which Mana Well already is: **that pool gains a card and NOT a decision** — seven
  cards, six decisions. It is still the right home (it meets the class-wide authoring rule where
  nothing else in the vault does), and it is honest to say the breadth did not move.
- **Reality Fracture adds an axis the Arcanist did not have** (TEMPO) and **Divine Wrath adds one the
  Devout did not** (AMP-TEAM). Arcanist 6 → 7 axes and 7 → 9 decisions; Devout 5 → 6 and 8 → 9.
- **§2b's shares are re-derived over 154.** DT predicted from the shape of DS's six, without counting
  them, that **MIT** and **AMP** would be the two most understated rows; they were, and they are the
  two that moved most — 12 → 15 each. **DMG-ST fell 22 → 21 and is still the largest axis**, because
  DR moved Lunge onto BREAK and nothing joined it. **DOT is still one card in 154.**

**AND ONE DISAGREEMENT IS RECORDED RATHER THAN SMOOTHED OVER.** DR reported its own repair as taking
the Swordmaster *"four → eight decisions"*; by DQ's one-primary-axis method it is **seven**, because
DR counted Wheeling Cut's self-mitigation as a second axis on one card. **Neither is wrong, and both
were in the same document without labels.** A per-card table exists so a later pass can disagree with
a row rather than with a conclusion, and it cannot do that while two counting rules are unlabelled.

**REPORTED, RULED ON NOWHERE** — DQ's value was that it changed nothing and DR then ruled.

---

## §6 — VERIFICATION

### THE DOCUMENTS WERE WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`,
`docs/draft-audit.html` and `baselines.json` all landed **before** the acceptance run — 26 suites
read `master.html`, 15 read the changelog and **3 read `design-notes.md`**, which is the one people
forget. `docs/state.md` and this report were written during it: no suite reads either, and
`check_de` reads neither.

### THE PRE-BATTERY DEFENCES

- **THE PARSE CHECK WAS GREPPED FROM STDERR AFTER EVERY EDIT**, never from a tally and never from an
  exit code — and it was **shown to bite** before it was trusted: a deliberate
  `func _dy_negative_control(:` appended to `test_batch_cp.gd` produced one `Parse Error` line where
  the clean tree produces zero. **The file was restored by `cp` and its md5 verified identical**,
  never by `git checkout`.
- **AND THE DELETION ITSELF PRODUCED A SECOND, UNPLANNED CONTROL.** The first probe run after
  `CLASS_POOLS` went produced six `Parse Error` lines — from the probe, which still read the
  constant. **A deleted `const` is a compile error at every reader**, which is the proof that no
  reader was left silently passing.
- **THE RETIRED-WORD SWEEP**, using `test_batch_bx` §4b's own `PARTY_IDENTS` strip and §4's
  `Beastmaster` strip over the edited `master.html`: **0 occurrences of *party* and 0 of *beast*,
  in the edited file and at HEAD alike.**
- **THE LITERAL SWEEP: 10,427 literals at a floor of 4**, from all 81 suites, gates and fixtures,
  evaluated against all five edited documents. **33 needles GAINED presence and 2 were LOST**, every
  one cross-referenced against the **220** `not <x>.contains(L)` assertions in the tree. **Five
  gained literals are the subject of a negative assertion and all five were run down and cleared**:
  `earnable` (read against a `passive_desc`, not a document), `class_pool` (read against a
  400-character slice of `run_state.gd` taken FORWARD from `func award_ability_pick` — the comment
  that names it sits above the function), and `Reality Fracture` (read against `battle.gd`, which is
  comment-only in this batch).
- **AND THE LITERAL SWEEP IS WHAT FOUND THE SIX HARD-CODED `"149 of"` NEEDLES**, which no other
  instrument in this batch would have caught before the run.
- **THE COMMENT-STRIPPED DIFF AGAINST `HEAD`.** **`scripts/battle.gd` (14,132 code lines),
  `scripts/run_state.gd` (1,370) and `scripts/unit.gd` (1,759) are +0/−0** — comment-only, proven
  rather than claimed. **`scripts/classes.gd` is 1935 → 1917 with +8/−26**, and the 26 are exactly
  `CLASS_POOLS`' 22 body lines, `class_pool()`'s 2 and `ability_corpus()`'s 2-line loop; the 8 are
  the five re-homed names and Holy's row. **Nothing was swallowed by a comment insert.**

### THE ACCEPTANCE RUN

**SEVENTY-EIGHT TARGETS RAN AND THE MANIFEST NAMES ALL SEVENTY-EIGHT.** **0 `Parse Error` and 0
`SCRIPT ERROR` in every log** — grepped from the streams rather than read off a tally or an exit
code, and **not one of the 78 logs contains either marker.**

| | DW's acceptance | DX's acceptance | DY's acceptance |
|---|---|---|---|
| **suite failures** | 0 | 0 | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** |
| `check_de` | 321 / 0 / 0 | 321 / 0 / 0 | **321 / 0 / 0** |
| targets in the manifest | 78 | 78 | **78** |

`check_map_screen: OK`; `check_ct_map` 83 / 0; the run harness reads **22 / 165 / 8**, all three
gates passing seeded.

**169 FILES WERE MD5-STAMPED BEFORE THE RUN AND RE-COMPARED AFTER — ALL 37 EDITED FILES ARE
BYTE-IDENTICAL ACROSS IT.** The tree was frozen for the whole reading, which is DL's lesson and the
one DX had to re-learn.

**TWO BATTERIES WERE RUN AND THEY AGREE ON EVERY TARGET BUT TWO.** Battery 1 measured the movements;
the baselines were then moved with a reason on every row; the acceptance run certified them. Of 72
comparable targets, **70 read byte-identical figures across the two runs**. The two that differ are
`test_batch_an` (**6046 → 6052**, the known drifter, comfortably inside its recorded [6046, 6063]
band) and `check_de` itself (**10 failures → 0**, which is the baselines being moved between the
runs and is the whole point of the second one).

### THE BASELINE PREDICTION, AND WHERE IT WAS WRONG

**The prediction was written before any suite was run against the edited tree.** Its falsifiable
content was the DIRECTION of every touched row and the claim that nothing else moves.

| row | predicted | read |
|---|---|---|
| `ability_corpus()` | **227 both sides** | **227 / 227 / 227** at all three measurement points |
| `test_batch_at` | **467, unchanged** | **467** — three standalone readings and both batteries |
| `check_cm_live` | **4** | **4** |
| `check_de` | **321, unchanged** | **321** |
| `GATES` / manifest / rows | **26 / 78 / 77** | **26 / 78 / 77** |
| UP: `bo`, `bq`, `br`, `bj`, `ah`(part) | direction | **all UP** — `bq` +141 predicted, +141 read; `br` +141 predicted, +142 read |
| DOWN: `ak`, `ar`, `bt`, `bu`, `bv`, `bw`, `cb`, `ce`, `check_dv` | direction | **all DOWN** |
| UNCHANGED: `av`, `bb`, `bp`, `ah_battle`, `check_do`, `check_cz`, `check_di`, `bx`, `an`, `check_da`, `check_dw` | no movement | **none moved** |

**TWO PREDICTIONS WERE WRONG AND BOTH ARE RECORDED RATHER THAN QUIETLY CORRECTED.**

1. **`test_batch_al` was predicted UNCHANGED and read 561 against 559.** The prediction's own reason
   was *"nothing they read was touched"* — and `al` §5 walks `SPEC_POOLS`, which §2 grew from 42 to
   44. **The row was in the list of files I had not edited, so I reasoned about the EDIT and not
   about the WALK**, which is precisely the mistake DX's sweep made one level up.
2. **`test_batch_au`'s direction was recorded as uncertain and it rose by 57** — the sibling-spec set
   its control now walks is wider than the class pool it replaced.

**Both are the same shape: a batch that grows a shared structure moves every loop that walks it, and
the set of those loops is not the set of files the batch edited.**

### THE NEGATIVE CONTROLS

| control | result |
|---|---|
| **The parse check** (`func _dy_negative_control(:` in `test_batch_cp.gd`) | 1 `Parse Error` line against 0 clean; file restored by `cp`, md5 verified |
| **Deleting `CLASS_POOLS`** (unplanned) | every remaining reader became a compile error — 6 `Parse Error` lines from one probe. **A deleted `const` cannot be read silently.** |
| **`check_dv` §2's Holy tripwire** | **went red on DY's own fix**, naming the moved pool. DX examined that equality in its sweep and left it standing on exactly this reasoning. |
| **`test_batch_at` §1, seeded vs unseeded** | six unseeded readings spanned 2.1189–2.2463; six seeded readings all read **2.1799** |

### WHAT IS DELIBERATELY NOT DONE

- **No ability magnitude moved and no card was authored.** All seven re-homed cards keep their
  vault definitions byte-for-byte — proven by the comment-stripped diff, which shows no change
  inside `vault_ability()`.
- **The three pricing questions are shipped as authored** and are the designer's. §1 has the
  options; a recommendation is given for Sanctuary because one was asked for, and it is not taken.
- **The boss-pool fallback question is still open** and is recorded as open in `docs/state.md`. §2
  closed Holy's instance, not the problem.
- **No gate was added.** §2's re-measurement and §3's absence pins landed in `check_dv`, the gate
  that already owns both questions; a second gate asserting the same thing is the duplication this
  project keeps paying for.
- **`CLAUDE.md`'s prune is declined for the tenth batch running**, and DY is the second in a row to
  move the ratio while declining it — 3.63% → **3.65%** of a 7.01 MiB sync against CW's "under 3%".
  **It is now the oldest untouched item in `docs/state.md`.**
