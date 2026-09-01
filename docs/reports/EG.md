# BATCH EG — THE DRAFT STAYS LIVE ALL RUN

**Four draftable slots against thirty-seven draft offers a run, 63% of them arriving at a hero
already at the cap.** The draft was effectively over after zone one, and every offer after it was
refuse-or-swap with a swap costing the card for the rest of the run. **Two changes: a hero gains an
ability slot after every zone boss (7 → 10 across a run), and a drafted card is never lost —
benching one is free and reversible.**

**The protected core does not change and does not become benchable. No ability magnitude moved, no
card was authored, the spec passive is untouched, and DO's talent charter holds unchanged** —
*"a talent modifying the spec's PROTECTED CORE is guaranteed and permitted"* rests on the hero
owning its core in every run, and the core is still not in the pool that benching reads.

---

## THE BRIEF'S FIGURES, RE-DERIVED

*Derive, do not recall.* **Ten of the brief's claims move when re-derived, and one of them is a
named precedent that does not exist for the second time in eleven batches.**

| the brief said | re-derived here | why |
|---|---|---|
| follow **two ladders that already exist** — the pouch's and **the rune equip ladder** | **there is ONE.** `rune_slots()` has returned a flat **3** since AN §9 deleted the 2/3/4 ladder | and this is the SECOND brief to name it: CT §1's header records its own brief making the identical claim, eleven batches ago |
| **~34 offers** a run | **37.28** at HEAD, 25 runs at rung 2 | route-dependent; 34.40 on the same policy after the batch |
| **62%** of offers arrive at a hero at cap | **63%** (23.36 of 37.28) | reproduced |
| **one spec's** two numbers disagree | **all twelve disagree** | `core_slots` is 3 for eleven specs and 4 for Holy; `protected_names` returns 4 for ten, **5 for Holy and 6 for the Beastmaster** |
| Holy carries **five `protected_names` against THREE `core_slots`** | five against **FOUR** | `PROTECTED_CORES["holy"]["slots"]` is 4 and is the only 4 in the table |
| a hero goes from **4 draftable to 7** | true for eleven; **Holy goes 3 to 6** | she is the only spec at four core slots |
| the three summons are **8 of 8** Beastmaster cards | his spec draft pool is **10** | DS took it to 10-of-10; the ENGINE binding is unchanged and if anything tighter |
| **Heal is Mercy's only outlet** | **one of five**, four of them protected | `_consume_empower` accepts `holy_heal`, `renewal`, `hymn`, `resurrection` and `divine_plea`; `PROTECTED_CORES`'s own `why` names Hymn as the other core outlet |
| **Quick Shot is the Sharpshooter's only Focus generator** | **every single-target attack he makes generates Focus** | `_sharpshooter_focus` gates on the resource name and `not _focus_safe(ab)`. Quick Shot is his only FREE, every-turn generator and the only one paying the sequence bonus — which is what `PROTECTED_CORES`'s `why` already says |
| `run_state.gd`'s save is **v10** (`docs/state.md`) | **v11** at HEAD, v12 here | the refusal threshold is `< 10` and has been since BK; the two are different numbers and this file conflated them |

**THE ONE THAT MATTERS MOST IS THE FIRST.** §1 said to follow *"the two ladders that already exist
— the pouch's `ITEM_SLOTS_BY_ZONE` (4 → 5 → 6) and the rune equip ladder"*. **The rune equip ladder
was deleted at AN §9** and `rune_slots()` has returned a flat 3 ever since. **Batch CT's brief made
the identical claim about the same ladder**, and CT wrote the correction into its own source header
— where it has sat for eleven batches while the design document went on carrying the false
precedent. **A false precedent survives being caught**, because it is caught in a batch report and
briefs are written from the document. That is now a rule in `CLAUDE.md`: when one is found, correct
the document it came from, not only the batch.

**AND THE DELETION'S REASON READS LIKE AN OBJECTION TO THIS BATCH, WHICH IS WHY §1 ANSWERS IT
RATHER THAN IGNORING IT.** AN §9 killed the rune ladder because *"a run that died in zone 2 never
owned a third slot"* and an empty rune slot is dead weight you cannot fill on demand. CT kept the
POUCH ladder against the same objection, on the ground that a pouch slot is filled the moment you
reach a merchant. **An ability slot is the pouch case and not the rune case**: a draft offer lands
at every elite and a boss award at every zone boss, so a slot opened here is filled almost
immediately and is never dead weight.

### THE PER-SPEC TABLE THE BRIEF ASKED FOR, DERIVED LIVE

**Both numbers per spec, and they disagree on all twelve rather than on one.** `core_slots` is
authored and is a SLOT count; `protected_names` is read off the live kit and is a NAME count. They
are different units by construction — the Beastmaster's three summons are one bar entry — so a
ladder written against one and a cap written against the other diverge everywhere, not on Holy.

| spec | `core_slots` | `protected_names` | draftable at 7 | draftable at 10 | spec draft pool |
|---|---|---|---|---|---|
| Berserker | 3 | 4 | 4 | 7 | 10 |
| Warden | 3 | 4 | 4 | 7 | 10 |
| Swordmaster | 3 | 4 | 4 | 7 | 12 |
| Pyromancer | 3 | 4 | 4 | 7 | 13 |
| Cryomancer | 3 | 4 | 4 | 7 | 11 |
| Arcanist | 3 | 4 | 4 | 7 | 12 |
| **Holy** | **4** | **5** | **3** | **6** | 10 |
| Devout (`inquisitor`) | 3 | 4 | 4 | 7 | 11 |
| Occultist | 3 | 4 | 4 | 7 | 10 |
| **Beastmaster** | 3 | **6** | 4 | 7 | 10 |
| Sharpshooter | 3 | 4 | 4 | 7 | 10 |
| Survivalist (`mystic`) | 3 | 4 | 4 | 7 | 10 |

**THE LADDER AND THE CAP ARE BOTH WRITTEN AGAINST `core_slots`, WHICH IS THE ONE THE CAP HAS ALWAYS
USED** (`ability_slots_used` = `core_slots(spec)` + the loadout). `protected_names` is used for what
it is for: the list of names that cannot be benched, and the CORE rows on the new loadout panel.
**Nothing in this batch compares the two.**

---

## §1 — SLOTS GROW ON A ZONE BOSS

**`ABILITY_SLOTS_BY_BOSS := [7, 8, 9, 10]`, and `Run.ability_slot_cap()` is its only reader.** The
old `const ABILITY_SLOT_CAP := 7` is gone rather than kept beside it — a constant that equals the
ladder's first rung is a second copy of a number, which this project's own record calls its oldest
recurring defect. Every reader was re-pointed: `map_screen` (four sites), `shop_screen`,
`party_screen`, and four suites and gates.

### THE LADDER IS INDEXED BY ZONE BOSSES CLEARED, AND `zone_idx` CANNOT DO IT

**This is the finding that shaped the implementation, and it is not visible from the brief.** The
pouch ladder is indexed by `zone_idx` and holds three values for three zones. Copying that shape
here grants **twice, not three times**: BM §6 made the end boss a seventeenth slot on the third
zone's OWN board, so `has_next_zone()` is already false when the third ZONE boss dies,
`advance_zone()` never runs, and `zone_idx` stays at 2 for the rest of the run. **A ladder read off
the zone stops at nine.**

So the run carries `zone_bosses_cleared`, written only by `Run.note_zone_boss_cleared()`, which
`battle._resolve_boss` calls on the zone-boss branch. **It is reset where `zone_idx` is reset**, and
that is CT's own scar arriving at a second ladder: CT found that a second run in one session sized
its opening pouch off the previous run's zone, and without the reset a second run here would open
every hero at ten.

### WHERE THE SLOT IS GRANTED — SEPARATELY FROM THE AWARD, AND BEFORE IT

**The brief asked. The answer is separately, and the order is load-bearing.** It is granted by the
boss dying rather than by the award being offered, so a hero whose boss pool AND fallback pool are
both empty still gains the slot. And it is granted **two lines above `_award_ability_picks()`**,
which is what makes *a hero at cap can still receive both* true: the award queues a pick the map
screen resolves later through `Run.take_draft_ability`, which reads `ability_slots_full` off
`ability_slot_cap()` — and that cap has already moved by the time the player clicks.

**It is announced from the ladder rather than from a written number**, beside the pouch line CT
wrote in the same function, so it cannot drift from `ABILITY_SLOTS_BY_BOSS`.

### DRIVEN LIVE, BECAUSE A LADDER THAT NEVER GRANTS PASSES EVERY STATIC CHECK

`check_eg` §1 resolves **three real zone bosses** through `battle._resolve_boss` and reads the cap
off the run after each, on a party seated at the cap so every rung is measured against a hero it
binds:

| stage | cap | hero 0 slots used |
|---|---|---|
| run start | **7** | 7 |
| after zone boss 1 | **8** | 7 |
| after zone boss 2 | **9** | 8 |
| after zone boss 3 | **10** | 9 |
| after the END boss | **10** | — |

**Identical on three standalone readings.** The end boss grants nothing and does not count as a
zone boss, both asserted.

**AND THE SIM CANNOT SEE THE THIRD GRANT AT ALL — PRE-EXISTING, REPORTED, NOT FIXED.**
`run_sim`'s boss branch gates the award on `has_next_zone()`, so the THIRD zone boss — which pays a
pick in the real game — sets `run_over` instead, the `endboss` node is never walked, and the bot
plays a 48-encounter run against the game's 49. The report line reading `ceiling 2.00 (zone bosses
only)` was that same assumption written as a literal. **Closing it moves every sim baseline in the
project**, so this batch corrected the line's wording, gave the sim the two grants it does play,
and left the walk alone. **`check_eg` §1 is the only thing in the project that reaches the third
grant.**

---

## §2 — DRAFTED CARDS ARE FREELY SWAPPABLE

### WHERE EACH SET LIVES, AND WHAT WAS READING ONE WHERE IT MEANT THE OTHER

**The brief asked, and the answer is that `bm_abilities` was doing both jobs and only one of them
had a second reader.**

- **`bm_abilities` KEEPS ITS NAME AND IS THE POOL.** Everything the hero has earned; nothing ever
  leaves it. It rides the member dict, so it is saved with the party.
- **`bm_equipped` IS NEW AND IS THE LOADOUT**, and **it defaults to the whole pool.** That default
  is why every pre-EG member dict means exactly what it meant before — a v11 save, and the ninety-odd
  suite fixtures that stuff `bm_abilities` directly.

**THE READERS SPLIT CLEANLY INTO TWO QUESTIONS AND THERE ARE ONLY TWO.**

| reader | question | set |
|---|---|---|
| `battle.gd`'s spawn (1156) | what can he CAST | **loadout** |
| `party_screen._draw_detail` | what does the sheet SHOW | **loadout** |
| `Runes.kit_names` → `Talents.ability_names` → `Run.owned_ability_names` | what does he OWN | **pool** |
| ...and through it `draft_pool_left`, `roll_spec_ability_offer`, `roll_spec_fallback_offer` | may he be OFFERED this | **pool** |
| `Runes.eligible_ids`'s `requires_ability` | does he own the card this rune sharpens | **pool** |
| `battle.gd`'s run summary | what did he EARN | **pool**, with the benched half named |

**`owned_ability_names` IS THE ONE THE BRIEF NAMED AND IT IS CORRECT BY DOING NOTHING** — it reaches
`bm_abilities` three layers down in `Runes.kit_names`, and `bm_abilities` is the pool. **Reading the
loadout there would re-offer a benched card as if it were new**, which is the exact defect
`owned_ability_names` exists to prevent. Control E arms that mis-read and `check_eg` §2 catches it.

**AND DZ'S RUNE FINDING IS UNCHANGED AND STILL LIVE:** `owned_ability_names` cannot see an ability a
rune grants, because the grant lands on the battle `cfg` and never on the member dict. That is
pre-existing, shared by every channel, and `check_ea` §1 still derives the drain off `runes.json`.

### THE LEDGER STILL BITES, AND IT HAS ONE WRITER NOW INSTEAD OF TWO

`drop_earned_ability` did two things at once — it took the card out of the kit AND wrote
`draft_refused` — because a drop was permanent. **`unequip_earned_ability` replaces it and writes no
ledger.** The guarantee the old write protected is unchanged and is reached through the set that is
actually true of it: **a benched card is still OWNED, so `owned_ability_names` keeps it off every
offer.** `decline_draft` is now the ledger's only writer, asserted at the site.

**Confirmed: swapping does not reopen the ledger**, in `check_eg` §2 and in the inverted assertions
of `test_batch_bo` §2, `test_batch_bp` §7 and `test_batch_bx` §2 — each of which now asserts the
bench, the keep, the absent ledger entry AND the still-absent offer, where before it asserted the
ledger entry alone.

### EVERY NAMED ENABLER IS PROTECTED — CONFIRMED, NOT ASSUMED

Derived live off `Classes.protected_names`, per spec:

| enabler | spec | in `protected_names` |
|---|---|---|
| Quick Shot | Sharpshooter | **yes** |
| Consecrated Ground | Devout (`inquisitor`) | **yes** |
| Heal | Holy | **yes** |
| Summon Ursus / Canis / Aguila | Beastmaster | **yes** (all three) |
| Guard Change | Swordmaster | **yes** |

**No live brick.** Two of the brief's *reasons* are wrong and are corrected above — Heal is one of
five Mercy outlets and four of the five are protected; every single-target attack the Sharpshooter
makes generates Focus, and what Quick Shot is uniquely is his free every-turn generator and the only
card paying the sequence bonus. **Neither correction weakens the protection claim**, and both are
already stated correctly in `PROTECTED_CORES`'s own `why` column.

---

## §3 — WHAT THIS TOUCHED THAT IS NOT THE DRAFT

### THE OFFER LOGIC — RE-MEASURED, AND THE FIGURE IS THE WHOLE JUSTIFICATION FOR THE BATCH

Four `--run 25` sims at rung 2 (`DOD_SIM_DIFFICULTY=warden`), one at HEAD and two after, same
policy line:

| | HEAD | after, sample 1 | after, sample 2 |
|---|---|---|---|
| draft offers / run | 37.28 | 34.40 | 35.36 |
| cards shown | 111.80 | 103.16 | 106.08 |
| **cost a drop / a bench** | **23.36** | 18.40 | 19.32 |
| **at cap when offered** | **63%** | **53%** | **55%** |
| nothing left to offer | 0.00 | 0.00 | 0.00 |
| runs completed | 21 / 25 | 24 / 25 | 22 / 25 |

**THE RATE FALLS BY ABOUT NINE POINTS AND IT HOLDS ACROSS BOTH SAMPLES.** The absolute offer count
is route-dependent and moves either way; the RATIO is the statistic, it is taken over ~860–930
offers a sample, and it reads 53% and 55% against 63%.

**AND THE SIM ONLY EVER REACHES A CAP OF NINE**, because of the `has_next_zone()` gate above — so
**53–55% is the ladder's two-thirds effect, not its whole one.** The real game's third grant is
measured in `check_eg` §1 instead.

**A COMPLETION-RATE SCARE, RAISED AND THEN RESOLVED RATHER THAN LEFT IN THE TABLE.** Sample 1 read
24/25 against HEAD's 21/25, which would have been a real unmeasured power increase — more slots is
more abilities carried. **Sample 2 reads 22/25, which straddles HEAD.** At n=25 the difference is
ordinary variance and **nothing here establishes a completion change in either direction.** It is
worth a bigger sample if the designer wants one; this batch does not claim it. The `Awards taken`
and `Upgrades taken` rows moving to their ceilings track the same completion spread and are not
evidence of anything about the draft.

### THE SAVE FORMAT — IT MOVES, AND IT IS TOLERANT

**v11 → v12, and the refusal threshold is deliberately unmoved at pre-v10.** Two new pieces of
state, and the existing refusal path is followed rather than a new one invented:

- **`zone_bosses_cleared`** is run state, so it is written and read explicitly. **Its tolerated
  default is `zone_idx`, not zero** — zero would take a resumed zone-3 run back to a cap of seven,
  where `zone_idx` is correct for both earlier zones and one rung low only in the window between the
  third zone boss and the end boss. **No tolerated default can put a hero OVER the cap**, because
  seven is the ladder's floor and every v11 kit was built against seven.
- **`bm_equipped`** rides the member dict exactly as `draft_refused` has since BO, so it needs no key
  of its own; a member without it reads its whole pool as its loadout.

**`docs/state.md` recorded the run save as v10 and it has been v11 since CT.** Corrected in
`CLAUDE.md` in both places it was written, with the rule that a tolerant bump does not move the
refusal threshold — the threshold is a claim about a structure this build cannot walk.

**`check_eg` §3 drives it rather than reading the literal**: v12 written and read back with the
ladder and the bench intact; a v11 save loaded with the counter defaulting to `zone_idx` and every
hero carrying his whole pool; a pre-v10 save still refused and cleared.

### THE PARTY SCREEN AND THE DRAFT CARD — AND AN OVERFLOW OLDER THAN THIS BATCH

**The swap happens on the MAP CARD, not the party sheet**, because that is where `equipped` already
has its one writer: `party_screen.gd`'s own rune block says *"equipping happens on the map card, so
there is one place that writes `equipped`"*, and a loadout with two writers is the same defect
wearing a different field name. The new `_open_loadout_panel` / `_toggle_loadout` are the rune
pouch's shape line for line, with two differences that are stated at the site: the title counts the
PROTECTED CORE as well as the loadout, and **the core is listed and cannot be toggled** — a hero who
could not see his own core would read the panel as "three of ten used" with nothing accounting for
the missing seven.

**THE HERO SHEET'S ABILITY CHIPS ARE IN A SCROLLER NOW, AND THE OVERFLOW PREDATES EG.** They were
laid out absolutely at `324 + (i / 2) * 46`, which puts a fifth row at y=508 — through the RUNES
header at 520 and into its scroller at 544. **A Beastmaster already reached five rows at HEAD**: his
protected core is SIX display names in three slots, so six plus four earned is ten chips at the old
flat cap, before a rune or a talent grants an eleventh. EG makes it ordinary rather than creating
it. The fix is the runes' own, quoted from their block: a list that can outgrow the page lives in a
scroller. **The header now states the live cap and the bench count**, because the cap is not a
constant any more and this is the screen a player compares builds on.

The draft card, the boss-pick step and the party-wide draft screen keep their shape: at the cap you
still choose what the incoming card replaces. **What changed is that the choice is no longer
permanent**, which is the complaint the batch answers — not that the choice existed.

### `test_batch_bp` §7 — DR's CONDITION, MET AGAIN AND FROM A DIFFERENT DIRECTION

**It went red, and not for the reason DR's did.** DR repaired §7 with boss-pick fillers because
three pools grew under a hand-built kit. **EG's condition is the SPLIT, not the pool.** §7 takes a
card through `take_draft_ability` and then re-stuffs `bm_abilities` by hand to reach the cap;
`bm_equipped` defaults to the whole pool **only while it is absent**, and the take had already
materialised it with one name. So the hand-built kit HELD four and CARRIED one,
`ability_slots_used` read 4 of 7, and five checks went red on a kit §7 thought it had filled. **It
erases the key, with the reason at the site.** **It is the only fixture in the tree that needed it**
— every other one stuffs `bm_abilities` on a member that has never taken a card, where the default
already means what the line means. The boss-pick fillers DR chose are untouched and still correct.

---

## §4 — WHAT IS DELIBERATELY NOT DONE

- **NO ABILITY MAGNITUDE MOVED.** No card is retuned for the wider loadout. `git diff` touches no
  `damage`, `cost`, `cooldown` or `delay` field.
- **THE SPEC PASSIVE IS UNTOUCHED** and is not an ability; nothing in this batch reaches it.
- **TALENTS ARE UNTOUCHED.** DO's charter holds because the core stays fixed and stays unbenchable.
- **THE PROTECTED CORE DID NOT CHANGE SIZE.** `PROTECTED_CORES` is byte-unchanged.
- **THE SIM'S END-BOSS WALK IS NOT FIXED**, per §1 — it moves every baseline in the project.
- **THE FALLBACK IS NOT WIDENED TO A CLASS-WIDE THIRD TIER**, per the ruling below.
- **`master.html` CARRIES ONE FALSE CLAIM THIS BATCH DID NOT TOUCH.** Its protected-core table says
  Guard Change *"is the only stance swap in the game"*; BP corrected that in `PROTECTED_CORES` and
  the document was never swept. Reported rather than fixed — it is one string, in a table two lines
  from what EG rewrote, and correcting a claim the batch did not make is the designer's call.

---

## §5 — THE RULING THIS BATCH OWES THE DESIGNER

### THE ZONE-BOSS FALLBACK'S FLOOR MOVED, AND ONE ASSERTION WAS ASKING TWO QUESTIONS

**EA §1 guaranteed that a zone-boss award always pays, and its arithmetic was that a hero holds at
most `ABILITY_SLOT_CAP - core_slots(spec)` earned abilities against spec draft pools of ten to
thirteen — a floor of SIX, twice the three an offer wants. EG breaks both terms.**

- **The cap is a ladder to ten**, so the loadout alone reaches seven earned.
- **And decisively, the POOL is unbounded.** A benched card stays in the pool and
  `owned_ability_names` reads the pool, so what drains the fallback's filter is everything a hero has
  ever taken — which the cap does not bound at all.

**Measured, under the loadout bound alone, `check_ea` §1 went RED on the first run:**

| | floor at cap 7 | floor at cap 10 |
|---|---|---|
| seven specs (10-deep pools) | 6 | **3** |
| Occultist (10-deep, one rune collision) | 5 | **2** |
| deepest (Pyromancer, 13) | 9 | 6 |

**SO THE ASSERTION WAS SPLIT RATHER THAN LOOSENED, WHICH IS DC's REPAIR-TO-INTENT RULE.** EA wrote
`floor_now >= awards` and worded it *"it can be paid nothing"*. **Those are two different claims**:
the RULE in `CLAUDE.md` is *an award always pays*, which is `floor >= 1`; `>= awards` is the
stricter claim that every award offers a full three. At a flat cap of seven the floor was six
everywhere and both held, so nobody had to separate them. `check_ea` §1 now asserts `floor >= 1` per
spec — **still green on all twelve** — and pins **the specs that can fill SHORT as a named set
(`[occultist]`)**, on `emptiable`'s own shape, so a thirteenth trips and the Occultist LEAVING the
set trips too.

**AND THE POOL BOUND IS PRINTED RATHER THAN ASSERTED, BECAUSE CLOSING IT IS A RULING.** The true
worst case — a hero who drafts his whole spec pool — floors the fallback at **zero**.

**THE OPTION EA ALREADY PRICED IS A CLASS-WIDE THIRD TIER**, and EA recorded that it *"closes the
table completely"* and that it *"is not the thing DY §3 forbade"* because it reads
`CLASS_DRAFT_POOLS`. **This batch did not take it**, for two reasons: EA chose the spec-draft card
deliberately and taking the class-wide option now overturns that choice rather than repairing this
batch's damage; and **the sim measured `nothing left to offer` at 0.00 per run in both samples**, so
the hole is reachable in principle and was not reached in fifty runs. **It is the designer's.**

---

## §6 — THE CODE CHANGE

- **`scripts/run_state.gd`** — `ABILITY_SLOTS_BY_BOSS` and `ability_slot_cap()` replace
  `ABILITY_SLOT_CAP`; `zone_bosses_cleared` and `note_zone_boss_cleared()`, reset in `new_run`;
  `equipped_ability_names`, `benched_ability_names`, `equip_earned_ability`,
  `unequip_earned_ability` and `hold_ability` replace `drop_earned_ability`; `take_draft_ability`
  benches instead of dropping; save v12 with both tolerated defaults.
- **`scripts/battle.gd`** — the grant and its announcement in `_resolve_boss`, before the award; the
  spawn reads the LOADOUT; the run summary names the benched half.
- **`scripts/map_screen.gd`** — the cap readers; the boss pick goes through `hold_ability`; the
  bench step lists the LOADOUT rather than the pool (a benched card cannot be benched again); the
  loadout panel and its card button.
- **`scripts/party_screen.gd`** — the sheet reads the LOADOUT; the header states the live cap and the
  bench; the chips move into a scroller.
- **`scripts/run_sim.gd`** — the bot grants the slot before its award, benches a CARRIED card rather
  than an earned one, writes the pool through `hold_ability`, and its two stale report literals.
- **`scripts/shop_screen.gd`**, **`scripts/runes.gd`** — one cap reader, one comment recording which
  set `kit_names` is asking about and why nothing changed there.
- **`check_eg.gd`** — NEW, in `run_battery.sh`'s `GATES`.
  **`check_ea.gd`** — §0 against the ladder, §1 split. **`check_map_screen.gd`** — drives the loadout
  panel. **`test_batch_bo` / `bp` / `bx`** — the inversions and re-points.
- **`baselines.json`** — one new row and four moved, at `indent=1`, 28 insertions.
  **`pin-manifest.json`** — regenerated, 1313 → 1327.
- **`test_batch_bm.gd`**, **`test_run_harness.gd`** — the 2400-character window becomes the
  function body, in both copies. **`check_ct.gd`** — the save-version pin reads `>=`.
  **None of the three moves a check count.**
- **`CLAUDE.md`**, **`docs/master.html`**, **`docs/changelog.html`**, **`docs/design-notes.md`**.

---

## §7 — VERIFICATION

### THE DOCUMENTATION WAS WRITTEN BEFORE THE BATTERY

`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`, `baselines.json`,
`pin-manifest.json`, `run_battery.sh` and every `.gd` file were final before the certification run.
**`docs/state.md` and this report are read by nothing** — no `.gd` file opens either, and every
target that names `docs/state.md` names it in a comment — so both were written after, which is what
lets a batch certify the tree that ships.

### THE PREDICTION, WRITTEN BEFORE THE FIRST READING

**PREDICTION: ONE NEW ROW AND FOUR MOVED — `check_eg` at 68, `test_batch_bo` 1131 → 1140,
`test_batch_bx` 157 → 161, `check_ea` 60 → 62, `test_batch_bp` 275 → 276 — AND `check_de` READS
341 / 0 / 0.**

Predicted from what each target **READS**, not from what this batch writes:

- **`test_batch_bo` +9**, counted off the diff rather than guessed: **+20 `ok(` against −11**, every
  one of them linear (nothing in §2 or §3 sits in a loop). Read standalone: **1140 / 0.**
- **`test_batch_bx` +4** and **`test_batch_bp` +1**, the same way. Read standalone: **161 / 0** and
  **276 / 0.**
- **`check_ea` +2**: §0's one cap assertion becomes two against the ladder, and §1 gains the named
  short-set. Its twelve per-spec floor checks stay twelve — the assertion was split in MEANING, not
  in count. Read standalone: **62 / 0.**
- **`check_de` +4** — four assertions per target, and exactly one target arrived. This is the term
  EF's prediction did not have and ED's did.
- **`check_de` HAS NO ROW OF ITS OWN**, so its own movement is reported by nothing; the row for
  `check_eg` is written BEFORE the run so `check_de` certifies on pass one instead of reporting an
  unwatched target.
- **Nothing else moves.** No pool grew, no ability moved, `PROTECTED_CORES` is byte-unchanged, and
  the corpus is untouched — so every loop that walks a pool or the corpus reads what it read.
- **The fourteen stamp gates** compare `>=` their own batch code, every one `CE` or older, and
  `EG >= CE` holds lexically. **`check_dv` §4's changelog span is a FLOOR of 16**; the live file
  goes to 27 entries.
- **Five document and fingerprint gates were read standalone against the edited tree** before the
  battery and every one matched its baseline at zero failures: `check_ec` **23 / 0**, `check_ed`
  **18 / 0**, `check_eb` **12 / 0**, `check_dv` **83 / 0**, `check_dm` clean.
- **`check_da` 39 / 0** with `check_eg` in the tree — **38 gates and 47 suites swept, 352 returning
  bodies, 0 hand-rolled walks, 1 exempt.** `check_eg` reads only the SPEC side of the draft pools and
  every section returns void, so it trips neither §3 fingerprint and needs no exemption.

### THE PRE-BATTERY INSTRUMENTS

- **THE DOCUMENT PIN SWEEP, RUN BOTH WAYS.** Every document pin in the manifest re-resolved against
  the edited tree, and the same sweep run against `git show HEAD`'s documents: **219 pins either
  side, the same 19 unresolved, the same list.** Eight runtime format strings, the documented
  vacuous carriers, and alternation members whose sibling carries the group. **This batch moved
  nothing into or out of that set.**
- **THE LITERAL-FLIP SWEEP over the five tracked documents**, **15,218 distinct literals at a floor
  of 4** taken over all 115 `.gd` files, against `git show HEAD`:

  | document | gained | lost |
  |---|---|---|
  | `CLAUDE.md` | 7 | **0** |
  | `docs/instrument-rules.md` | 0 | **0** |
  | `docs/master.html` | 1 | **0** |
  | `docs/changelog.html` | 11 | **0** |
  | `docs/design-notes.md` | 2 | **0** |

  **NOT ONE LITERAL LEFT ANY DOCUMENT**, and cross-checked both ways: **0 gained literals are
  negatively pinned against the file they landed in, and 0 lost literals are positively pinned into
  it.** The floor is 4 and not 12, because a 12-character floor once missed `"two turns"`.
- **THE SOURCE-SIDE FLIP SWEEP over the fifteen edited `.gd`/`.py`/`.json`/`.sh` files: 762 source
  pins re-resolved live and at HEAD, and EXACTLY FOUR FLIPPED — the four needles this batch
  deliberately re-pointed** (`Run.drop_earned_ability(` twice, `bm_abilities = kept`, and
  `map_screen`'s `drop_name ==` guard). **No unintended flip.**
- **THE RETIRED-WORD PRE-CHECK.** **0 *party* and 0 *beast* in every line this batch added to
  `docs/master.html`**, the one player-facing file the sweep reads — and the whole-file counts are
  **identical to HEAD, 3 and 28**, so `test_batch_bx` §4 and §4b see exactly the population they saw.
  The three hits in `CLAUDE.md` and `docs/changelog.html` are `Run.party`, `party_screen.gd` and
  `Beastmaster` — two identifiers on the named-survivor list and one name the rule explicitly
  exempts, in two files the rule exempts outright.
- **THE MANIFEST DIFF: 1313 → 1327 pins**, which is this batch's new assertions and nothing else.

### THE NEGATIVE CONTROLS — SIX, AND TWO OF THEM ARE A PAIR

**Each armed on something a target demonstrably reads, with the clean tree confirmed GREEN first**,
and every file restored by `cp` from a scratchpad backup with the md5 compared (all three restored
byte-identical).

| # | armed on | result |
|---|---|---|
| **A** | `Run.note_zone_boss_cleared()` removed from `_resolve_boss` — **the ladder never grants** | **`check_eg` 68 / 11**, and `cap by stage: [7, 7, 7, 7]` |
| **A2** | the grant moved **AFTER** `_award_ability_picks()` — ordering only | **68 / 1**, and **`cap by stage` is IDENTICAL at [7, 8, 9, 10]** |
| **B** | `unequip_earned_ability` made to call `_refuse_draft` — a bench writes the ledger | **68 / 2**, naming the ledger and the one-writer rule |
| **C** | `equipped_ability_names` defaults to `[]` instead of the pool | **68 / 8** |
| **E** | `Runes.kit_names` made to read the LOADOUT — the ownership question reads the wrong set | **68 / 1**: *a benched card is still OWNED* |
| **D** | `func ability_slot_cap(: -> int:` inside `check_parse`'s real scope | **24 `Parse Error` lines in stderr**, tally 7; clean tree **0 and 0** |

**A AND A2 ARE THE PAIR THAT MATTERS, AND A2 IS THE ONE WORTH KEEPING.** A is the DS Heads Down
control: a slot ladder that never grants would pass every static check in the project — the constant
right, the accessor right, the announcement string right — and §1 catches it at the same check
count, with the cap sequence flat at seven. **A2 breaks only the ORDER, and the cap sequence comes
back byte-identical**: the ladder still works, one hero at the cap can no longer receive both, and
**only §0's ordering assertion sees it.** Together they prove §1 catches an inert ladder and §0
catches a mis-ordered one, and that neither assertion is decorative.

**AND D IS ARMED IN `check_parse`'S REAL SCOPE ON PURPOSE.** EB §3's rule stands: `check_parse` does
not cover the gates or the suites, so a parse control armed on `check_eg.gd` would read clean for
the wrong reason. **The five edited gates and suites were each launched directly instead** —
`check_eg` five times, `check_ea` twice, `test_batch_bo` twice, `test_batch_bp`, `test_batch_bx`, and
`check_map_screen` through its own scene — which is the only proof that bites for a target
`check_parse` cannot see.

### THE BATTERY FOUND FOUR INSTRUMENT DEFECTS, AND TWO OF THEM ARE ONE DEFECT IN TWO COPIES

**BATTERY 1 IS THE ONE WORTH READING. It found three reds and the sweep it prompted found a fourth
— and every count prediction above held exactly, including `check_de` at 341 with ZERO NOTICES.**

**(1) AND (2) — A FIXED WINDOW, DUPLICATED.** `test_batch_bm` §6 and `test_run_harness` gate 2 each
slice `battle.gd` from `func _resolve_boss` for **2400 characters** and look for the
`# The end boss.` anchor inside it. §1's comment block pushed that anchor from character **2130 to
2955**, and both went red. **This is ED §2's rule met in the wild** — a scan that captures a WINDOW
is blind to what the window swallowed — arriving as a window COPIED between two targets, which is
the copied-helper rule one layer along: it inherited its blind spot twice. **Both slices run to the
next top-level `func ` now**, which is the function itself and cannot be outgrown by anything
written inside it, with a fall back to the old window if that search ever fails.

**AND EE §4's GUARD IS THE ONLY REASON EITHER SURFACED.** Without its `half_at >= 0` check the slice
would have been EMPTY, the negative assertion under it would have held for every needle, and the
alternation beside it would have been satisfied by its `body` sibling — **both targets green while
neither read anything.** In the harness it is worse: the negative is the ONLY assertion on that
slice. **That guard was written one batch ago and earned its keep on the first behaviour batch
after it.**

**(3) `check_ct` PINNED THE SAVE VERSION LITERAL, WHICH IS THE RULE CT ITSELF SET.**
*A suite must not pin the save version literal* (BK §6 / CT) is a standing rule in
`docs/instrument-rules.md`, and `check_ct` asserted `== 11` — so it reddened the first time anybody
bumped the version. `test_batch_bm` already obeys the rule (`bm_ver >= 10`, with the reason beside
it) and passed v12 without complaint.

**(4) AND THE SWEEP THAT FOUND IT FOUND ONE MORE — IN THE GATE THIS BATCH WAS WRITING.**
**The pin manifest could never have warned anyone**: `build_pin_manifest.py` indexes STRING
literals, and a version pin written as an INTEGER comparison is invisible to it — which is why the
pre-battery source sweep resolved 762 pins with exactly four intended flips and read straight past
this file. So the whole population was swept instead of the instrument trusted, and **it was TWO:
`check_ct` at `== 11` and `check_eg` at `== 12`.** **A named list cannot audit itself.** Both read
`>=` now, because what each section claims is that the fields survive a round trip and the older
save still loads — the number is incidental to both, and a later tolerant bump must not red either.

**NO CHECK COUNT MOVED ON ANY OF THE FOUR**, and each was re-read standalone at its exact baseline:
`test_batch_bm` **1891 / 0**, `check_ct` **113 / 0**, `check_eg` **68 / 0**, the harness
**22 / 166 / 8, all PASS.**

### THE ACCEPTANCE RUN

**BATTERY 2, ON THE REPAIRED TREE, AND IT FOUND NOTHING.** No suite failure, no throw, no notice,
no timeout, and the only red is the one that is on purpose.

| | EE's acceptance | EF's acceptance | **EG's battery 1** | **EG's acceptance** |
|---|---|---|---|---|
| **suite failures** | 0 | 0 | **1** (`bm`) | **0** |
| **throws, grepped from the stream** | 0 | 0 | **0** | **0** |
| `check_cm_live` (deliberate) | 4 | 4 | 4 | **4** |
| check counts outside their band | 0 | 0 | **0** | **0** |
| `check_de` | 337 / 0 / 0 | 337 / 0 / 0 | **341 / 3 / 0** | **341 / 0 / 0** |
| run harness | 22 / 166 / 8 | 22 / 166 / 8 | **GATE 2 FAIL** | **22 / 166 / 8, all PASS** |
| targets in the manifest | 82 | 82 | 83 | **83** |

**EIGHTY-THREE TARGETS RAN AND THE MANIFEST NAMES ALL EIGHTY-THREE**, compared both ways: no log on
disk the manifest does not name, and none named that is not on disk. **0 `Parse Error` and 0
`SCRIPT ERROR` in every one of the 83 logs** — grepped from the streams rather than read off a tally
or an exit code, and **not one of the 83 logs contains either marker.** `check_map_screen: OK`;
`check_ct_map` 83 / 0.

**AND BATTERY 1'S THREE REDS ARE EXACTLY WHAT `check_de`'s POLARITY RULE IS FOR.** All three were
reported as *went REDDER* — a rising failure count is an error, a falling one a notice — and the
differ named each target rather than reporting an aggregate. **Its own count moved 337 → 341 and
that movement is reported by nothing**, because `check_de` has no row of its own; it is four
assertions per target and exactly one target arrived.

### THE TREE WAS FROZEN AND IT IS PROVEN, NOT CLAIMED

**188 files were MD5-stamped before battery 2 and re-compared after: EVERY ONE IS BYTE-IDENTICAL.**
`CLAUDE.md`, `docs/master.html`, `docs/changelog.html`, `docs/design-notes.md`, `baselines.json`,
`pin-manifest.json`, `run_battery.sh` and every `.gd` file are unchanged across the run, **so the
battery certified what ships.**

**BATTERY 1 WAS FROZEN TOO, AND THAT IS WHAT MAKES ITS THREE REDS ATTRIBUTABLE**: of the same 188
files, the only four differing from its pre-run stamp are the four repaired after it finished.

**EXACTLY TWO FILES DIFFER FROM THE CERTIFIED TREE NOW, AND BOTH ARE READ BY NOTHING**:
`docs/state.md` and this report. No `.gd` file opens either, and the seven that name
`docs/state.md` all name it in a comment — checked individually rather than counted.
