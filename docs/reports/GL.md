# Batch GL — What the four class kits could be made of

*Branch `class-merge`, from `02b1002` (GK); `git ls-remote origin class-merge` read `02b1002` before the push. `main` is
untouched. **REPORT ONLY**: no code, gate, baseline row, manifest entry, `CLAUDE.md` rule or `master.html` edit. The
deliverable is **`docs/kit-recon.html`** (NEW).*

## NEEDS A RULING

**Only what blocks the ruled kit, or what a player meets, is here** (`docs/ways-of-working.md`). Everything else is in
`docs/state.md`'s queue.

1. **WHICH THREE, FOR EACH CLASS.** The recon puts every candidate to one test and prints, per class, what the passing
   cards could guarantee (part 6 of each class section). **What no passing card guarantees** — the only places a kit
   would need authoring:
   - **Warrior:** a heal, a shield or a cleanse for another hero. Mocking Blow's taunt is his only way of guarding the
     others.
   - **Mage:** anything for another hero except Dispel's cleanse. No heal of any kind, no buff, no shield on an ally.
   - **Cleric:** a revive (Resurrection costs Mercy), a taunt or avoidance card, a tempo or resource card.
   - **Hunter:** a heal, a shield or a cleanse for another hero, and a tempo or resource card.
2. **WHERE A PICK COMES FROM — BOTH SOURCES MOVE SOMETHING.**
   - **A class-wide card** taken into a kit leaves every hero's class draw. **It is also a spine-taker's whole
     supply**: a hero with no lineage draws every card of his run — the drafts and the zone-boss awards — from that pool
     alone (`run_state.gd:2202-2214`, `3801-3810`). Six cards, the Mage's seven; three once three leave, the Mage's
     four.
   - **A protected core** taken into a kit is already in its lineage's opening kit until the pool merge. A kit builder
     owes an answer for the hero who would hold it twice.
3. **THE CLASS-WIDE CARDS WERE AUTHORED WEAKER THAN SPEC CARDS, ON PURPOSE** (the header over `CLASS_DRAFT_POOLS`,
   `classes.gd:518-526`), and EB §1 ruled that the protected core is the baseline. **A kit made of class-wide cards
   gives the baseline role to the cards written as the fallback.** Whether that is intended is the designer's.
4. **THE CLERIC'S ONLY REVIVE AND ONLY PARTY BURST HEAL ARE PRICED IN MERCY ALONE.** Resurrection and Hymn of Hope cost
   0 Mana and 1 Mercy, and a Cleric without the Mercy engine has no Mercy. **Cut the Mercy and each is free**, so
   salvaging either is choosing a price — authoring, not a cut.
5. **GK's LINEAGE INTERIM (its ruling 5) NOW CARRIES A LIVE EXPLOIT AND THREE DEAD BUTTONS.** A hero who unslots his
   lineage's engine keeps his lineage kit. For a Sharpshooter that kit holds **a Hold Breath that never runs out**; an
   Arcanist, a Holy and a Beastmaster keep **Death Ray, Resurrection and Kill Command, which can then never be cast**.
   Fixing Hold Breath's countdown is a code batch; **whether a dropped engine should also drop the cards that need it is
   the designer's**.

## THE SHORT VERSION

- **THE ANSWER: TWELVE TO PICK, NOT TO WRITE.** Of **64** slot candidates — the 25 class-wide draft cards, the 28
  protected cores that are not enablers, and the 11 enablers that are not basic attacks — **44 pass clean, 13 pass
  with one clause cut, 7 are bound**. Every class holds at least nine clean: Warrior 14, Mage 11, Cleric 10, Hunter 9.
  The four basic-attack overrides are tested apart, and all four pass.
- **§1 — WHAT EXISTS.** Four class basics: the Warrior's and the Hunter's are one ability each, the Mage's is one slot
  with four definitions and the Cleric's one slot with two. Sixteen enablers across nine lineages. Twenty-five
  class-wide cards, not twenty-four. Twenty-eight protected cores that are not enablers, across all twelve lineages.
- **§2 — THE TEST**, applied the way FY's SR-REACH says a reach must be taken: every card read for a hero of its class
  **holding no engine at all**. Read by hand, then read again by four independent census passes, one a class. They
  disagreed on three cards; the report records all three.
- **§3 — THE COUNT AND THE COVER.** Nothing has to be authored, and the pick is not free (the rulings above). **No
  Hunter opens thin today** — the Hunter has no spine.
- **FOUND, AND LIVE TODAY:** the Hold Breath exploit, three dead buttons, five lineage cards that half-work without
  their engine, **a live rune that does nothing (Split Shield)**, Dispel stripping the party's own marks, and a dozen
  card texts the code contradicts.

---

## §0 — THE BRIEF'S PREMISES

Read before anything was quoted: `CLAUDE.md`, `docs/state.md`, `docs/ways-of-working.md`, `docs/reports/GK.md`,
`docs/reports/FY.md`, `docs/reports/FW.md`, and the code each premise names. **Seventeen checked. Seven held, one held
as a ruling, and nine did not hold as written.**

| The brief says | Verdict | What the repo says |
|---|---|---|
| A hero who takes Momentum, Channel or Sanctity opens with his class's basic attack alone | **HELD** | GK's ruling 7; `Classes.opening_kit(class, "", [])` returns the basic alone for the Warrior, the Mage and the Cleric (the probe, §VERIFICATION) |
| The other twelve engines bring enablers; those three bring a rule | **HALF FALSE** | **Nine** of the twelve bring enablers. Blood Frenzy, Heavy Plating and Trapper bring none, and their holders still open with three abilities. **What the twelve bring is a lineage** and its opening kit, and that is what a spine lacks |
| Three of fifteen engine runes produce a materially worse opening | **HELD** | For the Warrior, the Mage and the Cleric. **The Hunter has no spine**, so no Hunter opens with Quick Shot alone today |
| A player cannot know that at the draft | **FALSE AS WRITTEN** | The class-selection card lists every ability the rune opens with, off `Classes.opening_kit` (`spec_choice_screen.gd:141-152`), so a spine's card lists one line. **What no card says** is that a spine-taker's every later card comes from his class pool alone |
| THREE abilities, INSIDE the slot count; a protected core took a slot and this is the same object | **HELD** | `core_slots` is 3 for eleven lineages and 4 for Holy, and the basic sits outside it (`Classes.lineage_slots`; `Run.ability_slots_used`, `run_state.gd:2116-2121`). Three kit abilities are three slots |
| Remove the specs and a hero's entire kit is drafted | **HELD, AS A RULING** | The pool merge is RULED, NOT BUILT; today a lineage hero keeps his kit with no engine (GK's ruling 5) |
| GK found 67 of 104 targets red, 42 throwing, 38 on `passive_id` alone | **HELD** | `GK.md` §3a |
| DV found `apply_kit_overrides` builds the four Mage specs' `abilities[0]` and the corpus returned the unoverridden Magic Bolt | **MISATTRIBUTED — AND IT IS THE ERROR DV CORRECTED** | **DU §4** found the corpus blind spot. **DV §5** corrected DU's "four Mage specs": there are three, and **the fourth override is Shadowrend, the Occultist's — a Cleric** (`DoD-archive/changelog-archive.html`, DV's entry). **CLAUDE.md's EI §2 shape: a false precedent survives being caught.** So the Mage's slot 0 has four definitions and the Cleric's two |
| `PROTECTED_CORES` names sixteen enablers across nine specs | **HELD** | `classes.gd:580-613`; the probe |
| Six cards per class in the class-wide pools | **FALSE FOR THE MAGE** | **Seven** (Mana Shield joined at DY §1), so **25** in all (`classes.gd:527-545`; `test_batch_cd.PER_CLASS_DEPTH`) |
| Nine specs had three or more cores and only sixteen are enablers | **FALSE COUNT** | **All twelve** lineages open with three or more abilities beside the basic (Holy four; the Beastmaster five in three slots); **nine** name enablers. The remainder is **28**: Warrior 8, Mage 7, Cleric 5, Hunter 8 |
| The remainder were guaranteed abilities that no engine needs | **PARTLY FALSE** | Of the 28, **17 CLEAN, 8 ALMOST, 3 BOUND** — Death Ray (Resonance), Resurrection (Mercy), Kill Command (a companion only the Pack Bond summons bring) |
| The engines to test for include Rage | **RAGE IS NOT AN ENGINE** | It is the Warrior's class resource (`classes.gd:61`). Blood Frenzy is the engine and reads Rage **spent** (CZ §1), so a card that builds or spends Rage feeds it without reading it. **Burn and Chilled** are statuses cards lay, read by Overburn and Glacial Hold |
| FY's SR-REACH found TODAY meant *works for some hero* | **HELD** | `FY.md` §1d. This batch applies the correction: *works* means for every hero of the class, with any engine or none |
| Two of FX's 27 nodes shipped against items that were never what they were written from | **MISSTATED** | The two were among the four of FX's **brief**'s nodes that failed, and FX swapped all four for alternates before it shipped (`docs/state.md`, FX's ruling item 3). None of the 27 that shipped rests on them |
| DN priced a restructure at 97 new nodes | **HELD** | DN's text in `docs/state.md`; FX's one tree superseded it |
| FO found searches return the wrong spec's section; FW fixed it with `SR-` prefixes | **NOT FOUND, AS AT FW** | Nothing in `FO.md` or FO's changelog entry (FW §0 found the same). The prefixes are FW's, and the recon follows them |

---

## §1 — WHAT EXISTS TODAY, PER CLASS

**Every figure here is in `docs/kit-recon.html`, one self-contained section a class, with a line citation on every
row.** In short:

| | Warrior | Mage | Cleric | Hunter |
|---|---|---|---|---|
| **The basic** | Strike: free, 23% of Attack, 18 Break damage, +20 Rage — **one ability** | Magic Bolt: free, 25%, 14 Break — **one slot, four definitions** (Fireball, Frostbolt, Arcane Explosion while their engine is held) | Smite: free, 44% (22 at 50 Attack), 16 Break — **one slot, two definitions** (Shadowrend under the Old Gods) | Quick Shot: free, 20%, 14 Break — **one ability, whose behaviour forks** under Lethal Aim |
| **Engines / spine** | four / the Vanguard (Momentum) | four / the Invoker (Channel) | four / the Hierophant (Sanctity) | three / **none** |
| **Enablers** | 1 (Guard Change) | 5 (three are the basic overrides) | 6 (one is the basic override) | 4 (three summons, and Quick Shot, which is the basic) |
| **Class-wide pool** | 6 | **7** | 6 | 6 |
| **Cores that are not enablers** | 8 | 7 | 5 | 8 |

- **EVERY BASIC RESOLVES AT A FIXED GOOD** (`battle.gd:4118-4119`) — **except a Lethal Aim holder's Quick Shot** —
  **so every basic's Perfect is advertised and unreachable** (FOUND below).
- **THE SIXTEEN ENABLERS, EACH AGAINST ITS ENGINE.**
  - **Six pass clean.** Four are basic overrides (Fireball, Frostbolt, Arcane Explosion, Shadowrend). The other two,
    Hex of Ruin and Divine Shield, feed their engines and read nothing of them.
  - **Five are a clause away:** Guard Change, Detonation, Ice Lance, Heal, Consecrated Ground.
  - **Four are bound:** Hymn of Hope and the three summons.
  - **Quick Shot** is the Hunter's basic.
  - **An enabler that passes and moves into a kit stops needing to travel**: its engine would find it already held.

---

## §2 — THE TEST, AND HOW IT WAS TAKEN

**What counts as reading an engine:** `has_engine`, a spine switch, the engine's own meter (the second resource,
Faith, Ruin, Loyalty, a Glacial Hold, a stance's effect), or an enabler's presence (a living companion, Consecrated
Ground standing). **What does not:** the class resource; a status any card of the class lays; **an engine's payout on
the card's number** — Overburn's damage term, Mercy's +5% a stack on every heal — which is the engine reading the card.

**The method:**

1. **A probe** in an isolated copy (its own `user://`, project renamed) dumped the four populations through the game's
   own accessors — 80 rows — and every opening kit, engine held and dropped.
2. **An extractor** pulled every candidate's read sites into one file each: its `_resolve_special` arm, every line
   naming its display name or special id, and the read and write sites of each status it lays. 72 files, 6,183 lines.
3. **Read by hand**, following the helpers and both gates a cast meets (`_ability_usable`, `_eff_cost`).
4. **Read again by four read-only census passes**, one a class, briefed with the same test and the same extracts.
   They cost 1,875,559 tokens and about 15 to 20 minutes each (Warrior 616,759 / 999 s; Mage 450,928 / 1,086 s; Cleric
   425,531 / 1,172 s; Hunter 382,341 / 869 s). **The Cleric pass's summary line (9 / 7 / 2) disagreed with its own
   table (10 / 6 / 2)**; the table was used.

**The two readings disagreed on three cards, and each is recorded in the recon (KR-TEST):**

- **Arcane Explosion — resolved toward the census pass: CLEAN, with a WORDING note.** Its "Builds 1 Resonance" is the
  build every damaging cast pays a Resonance holder (`battle.gd:12418-12457`). Cutting the words cuts no mechanic.
- **Ministration — kept CLEAN; the Cleric pass read ALMOST**, because `_healing_done_mult` adds Mercy's +5% a stack
  (`battle.gd:14727`). That term is the engine's payout on every heal. Without Mercy the card pays exactly its own 20%.
- **Divine Shield — kept CLEAN; the Cleric pass read ALMOST**, because the barrier stamps a hidden `divine` rider that
  only Faith and two Devout cards read, and the recast table counts it as an improvement (`battle.gd:6069`,
  `6104-6106`). Without Conviction it pays nothing and harms nothing, and the card's text never names it. **It feeds
  Faith.**

**On the stricter reading the Cleric holds eight clean, not ten.** No count that decides anything moves.

**Where a verdict rests on a mechanism, it was read at its line, and the four the verdicts lean on hardest were
re-read by hand against the census passes:**

- **Chilled works without Glacial Hold.** Four stacks freeze for one turn and drop the pile to one
  (`battle.gd:13300`, `12737-12741`); only the hold is the engine's (`12668`, `12742`).
- **The Pack Bond gates.** A companion strikes beside the Hunter only under the engine (`battle.gd:12282`); its boon
  and Loyalty are refused without it (`14336`, `14533`).
- **Mercy is set up only under its engine** (`battle.gd:1183-1186`), and a `faith_cost` card is refused without it
  (`6152`).
- **A one-turn Daze never acts.** It ticks off at the target's own turn start (`battle.gd:3295`), before any miss roll
  reads it (`7981`).

---

## §3 — THE COUNT, AND THE HONEST ANSWER

| Class | Slot candidates | CLEAN | ALMOST (one clause to cut) | BOUND | To author for three |
|---|---|---|---|---|---|
| Warrior | 15 | **14** | 1 | 0 | **0** |
| Mage | 16 | **11** | 4 | 1 | **0** |
| Cleric | 16 | **10** | 4 | 2 | **0** |
| Hunter | 17 | **9** | 4 | 4 | **0** |
| **All four** | **64** | **44** | **13** | **7** | **0** |

Beside them, the four basic-attack overrides are tested apart, because they sit outside the slot count. All four are
CLEAN, Frostbolt and Arcane Explosion with a WORDING note. The table is computed from the recon's own rows, and the
page refused to write unless each class section's table agreed with it.

**NOT SOFTENED: IT IS NOT TWELVE TO WRITE AND NOT FOUR. IT IS ZERO TO WRITE AND TWELVE TO PICK.** The supply was never
the problem. The pick has three costs, and the report does not choose between them (NEEDS A RULING 2 and 3):

- a class-wide card leaves a spine-taker's whole supply;
- a lineage core is already in its lineage's kit;
- the class-wide cards were written weaker on purpose.

**AND WHAT EACH CLASS'S KIT COULD COVER.**

- **Warrior** — the widest candidate set.
  - Clean cards reach damage, Break, a stun, a sunder, his own mitigation, sustain and control immunity, a taunt, a
    party damage buff, and a tempo card for an ally.
  - **Nothing heals, shields or cleanses another hero.**
- **Mage.**
  - Clean cards reach damage and area damage, Chilled control, his own shield and avoidance, a cleanse, cooldowns and
    Mana.
  - **Nothing lifts another hero**, and Dispel's cleanse is his only card for the others.
- **Cleric** — the richest "guard the others" set: two single-target heals, two party heals, a shield, a cleanse with
  mitigation, and a party damage buff. Every ally-targeted card can also be cast on the Cleric himself, and Bewitch is a
  charm.
  - Damage is thin: Chastise, and Hex of Ruin.
  - **No working revive, no taunt, no tempo card.**
- **Hunter.**
  - Clean cards reach damage, Break, two controls, a debuff, a self-heal with a cleanse, avoidance, a party mark and
    retaliation.
  - **Nothing heals, shields or cleanses another hero, and no tempo or resource card.**

**THE PARTY DAMAGE BUFFS PAY ON ORDINARY STRIKES ONLY.** Warcry, Exhortation, Blessing of Zeal and Hunter's Mark are
read in the strike path (`battle.gd:9689`, `8423-8425`, `9240`, `9892`). A card resolving in its own `special`
handler reads none of them.

**"SALVAGE CLEANLY" MEANS THE CARD WORKS FOR EVERY HERO OF ITS CLASS. IT DOES NOT MEAN IT IS PRICED RIGHT AS A
GUARANTEED CARD.** Mocking Blow is free on a one-turn cooldown. No balance was measured.

---

## §4 — NOT DONE, AS RULED

- Nothing authored, moved, cut or reworded; no card proposed as a pick.
- The nine missing engine runes are not addressed.
- The Crown's Break and freeze resistance is not addressed — the brief makes it the batch after the kits.
- No pool merge, no talent node, no rune cost.
- No `CLAUDE.md` rule, no gate, no code.

---

## FOUND AND NOT FIXED

**All of it is in `docs/state.md`'s queue. The first three are reachable in play today through GK's drop-to-nothing.**

1. **PLAYER-FACING, AND AN EXPLOIT: HOLD BREATH NEVER RUNS OUT FOR A HUNTER WITHOUT LETHAL AIM.**
   - The countdown that spends `held_breath` sits inside `battle.gd`'s `has_engine("lethal_aim")` block
     (`12186` → `12228`).
   - So after one cast, every damaging attack for the rest of the fight is a guaranteed critical that ignores armor
     (`9155`, `10452-10456`).
   - A Sharpshooter who unslots his rune keeps Hold Breath; GK §5's own table shows its chip standing on exactly that
     hero.
   - Found by the hand reading and by the Hunter census pass independently, then **driven** (VERIFICATION): six Quick
     Shots after one cast, the status standing after every one, the mean hit 15.0 → 26.2. The control is a Sharpshooter
     holding Lethal Aim, whose first shot spends it.
2. **PLAYER-FACING: THREE BUTTONS THAT CAN NEVER BE PRESSED.** Each stays in its lineage's kit when the engine is
   dropped (GK §5's table lists all three):
   - **Death Ray** — refused below 8 Resonance (`battle.gd:6469`);
   - **Resurrection** — refused without 1 Mercy (`6152`), and its button label reads a bare "1" (`6572-6573`);
   - **Kill Command** — refused with no companion (`6157-6159`).

   **Driven:** each was refused in an engine-less kit, Resurrection with a hero down.
3. **PLAYER-FACING: LINEAGE CARDS THAT HALF-WORK WITHOUT THEIR ENGINE**, because their payload sits inside the engine's
   block:
   - inside Trapper's block (`battle.gd:12059-12079`): Shrapnel Charge's Poison, Hamstring's Slow and Exposed, and
     Venom Coating's poison;
   - inside Lethal Aim's block (`12214-12227`): Pinning Shot's Daze and Called Shot's rider.
4. **PLAYER-FACING: THE SPLIT SHIELD RUNE DOES NOTHING IN A FIGHT.**
   - A live, 100-gold, Warden-scoped rune. `rune_split_shield` is read only by the recast table
     (`battle.gd:5945`); Shieldwall's cast (`20902`) never reads it.
   - **`check_ez` §5 drives `_recast_writes` and says in its comment that it is "the same answer the cast itself
     uses". It is not.** A gate that has stopped asking its question.
   - Found by the Warrior census pass, confirmed by grep and by reading the cast, then **driven**: the cast laid 25 on
     the Warden and covered no ally, while the table proposed 12.
5. **DISPEL STRIPS THE PARTY'S OWN MARKS.**
   - `party_mark` (Hunter's Mark), `rime` and `arcane_echo` are in neither `DEBUFF_IDS` nor `DISPEL_NEVER`.
   - So `_dispellable_buffs` (`battle.gd:7763-7770`) offers them to a Mage's Dispel cast on an enemy.
   - That is the trap `DISPEL_NEVER`'s own comment describes. Found by the Mage census pass, confirmed, and **driven**:
     a Hunter's Mark laid, a Mage's Dispel cast on that enemy, and the mark gone.
6. **DIVINE SHIELD'S RECAST PROPOSAL IGNORES THE LIVE BARE ALTAR RUNE.**
   - The rune halves the cast (`battle.gd:17157-17158`); the table proposes the full 35% (`6064`).
   - So a wasted recast reads as an improvement. CR §3's rule, one rune along. Found by the Cleric census pass and
     confirmed.
7. **PLAYER-FACING: EVERY CLASS BASIC ADVERTISES A PERFECT IT CANNOT REACH.**
   - Strike, Magic Bolt, Smite and Quick Shot, and the overrides in slot 0, resolve at a fixed Good.
   - The battle tooltip and the hero sheet print their Perfect lines anyway. A Lethal Aim holder's Quick Shot is the
     one exception.
   - **`test_batch_bo` §5 passes them**: it asks `runs_skill_check()`, and the cast path asks slot 0.
8. **PLAYER-FACING: CARD TEXTS THE CODE CONTRADICTS.** Each was confirmed at its line, and each is in its class
   section's part 7:
   - Charge's one-turn Daze never acts, and its Perfect has no code; Cleave's Perfect has no code;
   - Battle Trance and Mana Well pay three turns in four;
   - Chastise's Perfect says 30 Break damage and pays 25;
   - Frostbolt's, Razor Ice's and Blizzard's "hold" is the engine's;
   - Divine Shield names "the Devout's" health, and Dark Pact "the Occultist";
   - Hymn of Hope, Dark Pact and Resurrection say *ally* and reach heroes only;
   - Renewal and Undying Vigil cast on a companion do nothing;
   - Kill Command's "both companions" names a mode nothing writes (`the_pack`);
   - Arcane Explosion's "Builds 1 Resonance".
9. **THE SIM BOT CASTS FIVE CANDIDATES ONLY INSIDE ENGINE BRANCHES** (`battle.gd:4656-4760`). A class kit owes it a
   class-level branch.
10. **ONE SYNC LINE, AS AT FW.** `CLAUDE.md`'s must-stay-selected list does not name `docs/kit-recon.html`. The brief
    forbade rules, so **selecting it in the picker is the designer's**.
11. **SEEN, NOT CONFIRMED, NOT QUEUED AS FACT.** The census passes reported more text mismatches, among them Mocking
    Blow's taunt forcing fewer attacks than its turns, and Magic Barrier's "a share of EVERYTHING". They were not
    re-read by hand, so they are not listed above.

---

## VERIFICATION

### The saves

**Backed up before anything was written** — `save-backups/GL-20260916-143312/` — and verified by hash, each matching
the live file and GK's backup: `profile.json` `b05e329b…`, `relics.json` `fdc12ffa…`, `run_save.bin` `c44d45da…`,
`settings.cfg` `0c1b39c3…`. **Re-hashed after the pre-pass and after the acceptance run: identical both times — all
four, byte for byte.**

### The parse floor

**No code moved**, so the floor could only break by a stray write, and the freeze below is what shows there was none.
- **`check_parse`, standalone on the final tree, with its stderr captured on its own: 0 bytes.** No `Parse Error`,
  `Compile Error`, `SCRIPT ERROR` or `Failed to load`; stdout reads 184 / 0.
- **Across both batteries' 110 logs each** (stdout and stderr together): zero of each of those, and zero
  `Invalid access`.
- **It runs:** three gates in each battery walk whole runs through the real screens (`check_fh`, `check_gf`,
  `check_gj`), and all three are green in both.

### The documents, before the battery

- **THE LITERAL SWEEP, AGAINST HEAD.** Every string literal of four characters or more in every root and `scripts/`
  `.gd` — **16,792 needles from 142 files**, comments stripped with the pin-manifest generator's own stripper and
  unescaped with its own unescaper — read raw, lowered and whitespace-flattened against HEAD's copy and the edited copy
  of each document. **Proved to bite first**: on unchanged copies it read 0 / 0 / 0, and deleting one `check_dv` needle
  in memory read LOST 1 in all three forms.
  - **`docs/changelog.html`: LOST 0 / 0 / 0**; gained 15 / 15 / 15, none inside a negative check anywhere.
  - **`docs/state.md`: LOST 13 / 13 / 13** — every one a word of GK's WHERE block, which the rewrite replaces (file
    paths, `awakened`, `spec_choice`). **The only instrument that opens `state.md` is `check_es`**, and it reads the
    "2+ threshold" windows alone: **two windows and four figures before, the same two and four after**. Gained
    38 / 40 / 40; two sit inside negative checks (`check_eh` §3 and `test_batch_al`), and both read other files
    (a slice of `battle.gd`, the talent tooltips).
  - **`docs/kit-recon.html` and this report are read by nothing**: no instrument names either file and no directory
    walk reaches `docs/` (`check_ec`, `check_ff`, `check_fm`, `check_eh`, `check_fi`, `check_ft` and `check_parse`
    walk the root, `scripts/` or `data/`).
- **`build_pin_manifest.py --check`: current at 1,467 pins** with the edited documents in place.
- **THE SIX GATES THAT READ THESE DOCUMENTS, STANDALONE, WITH THE BATTERY'S OWN COMMAND:** `check_ec` 23 / 0,
  `check_dv` 83 / 0, `check_es` 57 / 0, `check_fg` 22 / 0, `check_el` 23 / 0, `check_fr` 25 / 0. Each is on its
  `baselines.json` row, with 0 throws.

### Two batteries: a pre-pass, then the acceptance run

**THE FIRST FULL BATTERY BECAME A PRE-PASS, AND THE REASON IS A DOCUMENT, NOT A RED.**
- It was launched as the acceptance run over the landed documents (predictions written at 15:11:31; 15:11:56 to
  15:59:17).
- While it ran, the scratch probe drove four of the findings. The landed documents still called the first of them
  *read, not driven*, and said nothing of the other three being driven.
- Correcting those words afterwards would have been a document edit behind the certifying run.
- So the run was finished and kept as a pre-pass, the two documents were corrected (`docs/state.md`, four findings;
  `docs/kit-recon.html`, its coverage row and four findings), and a second battery certified the final tree.
- **The changelog did not change between the two.**

**THE PRE-PASS** read every prediction as written:
- 110 targets, 110 unique, 0 timeouts, 0 incomplete.
- **Suites 46 of 46 green; gates 57 of 58 green, with `check_cm_live` at 13 / 4** and its four FAIL lines word for
  word GK's acceptance run.
- Harness 22 / 382 / 8 PASS, 0 throws. Both scene runs complete (`check_ct_map` 83 / 0).
- **`check_de` 457 / 0 / 0.** `check_parse` 184 / 0.
- **Zero** `Parse Error`, `SCRIPT ERROR`, `Compile Error`, `Failed to load` or `Invalid access` lines across the 110
  logs.
- Frozen at 481 stamps before and after: **identical**.

**BETWEEN THE TWO:**
- The corrected documents were swept again: the same LOST 0 and LOST 13, and no new negative use.
- `build_pin_manifest.py --check` read current at 1,467 pins.
- The six document readers ran standalone again: `check_es` 57, `check_ec` 23, `check_dv` 83, `check_fg` 22,
  `check_el` 23 and `check_fr` 25, all with 0 failures and 0 throws. `state.md` still showed two windows and four
  figures to `check_es`.

**THE ACCEPTANCE RUN** was predicted in writing before its launch (at 16:00:59) and ran from 16:01:07 to 16:48:32. It
was frozen before and after at 481 md5 stamps with absolute paths, covering every tracked and untracked file and the
four saves.

| | read |
|---|---|
| what was in the tree | HEAD's code, gates, suites, `baselines.json` and `pin-manifest.json`; the final `docs/changelog.html`, `docs/state.md` and `docs/kit-recon.html` |
| targets / timeouts / incomplete | **110 / 0 / 0** — 110 lines in `.ran`, 110 unique, 110 logs |
| suites | **46 of 46 green**, every one at its row; `test_batch_an` read **6,051**, inside its band |
| gates | **57 of 58 green**; **`check_cm_live` 13 / 4**, its four FAIL lines word for word GK's acceptance run (the control on HEAD's side) |
| run harness (gates 1 / 2 / 3) | **22 / 382 / 8 PASS**, 0 throws |
| scene runs | both complete; `check_ct_map` **83 / 0** |
| `check_de` | **457 checks / 0 failures / 0 notices** — no row moved |
| `check_parse` | **184 / 0** |
| error lines across the 110 logs | **0** `Parse Error`, **0** `SCRIPT ERROR`, **0** `Compile Error`, **0** `Failed to load`, **0** `Invalid access` |
| the document readers | `check_es` 57 (`state.md`: 2 claim windows, 4 figures, as HEAD's), `check_fg` 22, `check_ec` 23, `check_dv` 83, `check_el` 23, `check_fr` 25 — all 0 failures |
| the ceilings, as `check_fg` printed them | the changelog at **339,425 B** against the 400,000 B bar (GL's entry is 4,463 B; 60,575 B of headroom); `CLAUDE.md` untouched, **12,677 B** under its 340 KiB ceiling |
| the freeze | **481 stamps before and after — identical**, the four saves among them |

**Every prediction held.**

### The drive — a scratch probe in the isolated copy, not in the tree

**`probe_gl_drive.gd`, in the isolated copy** (its own `user://` under a renamed project). It seats parties through the
battery's own fixture (`gate_fixture.gd`'s `spawn`, deterministic rolls) and resolves casts through `_resolve` and
`_resolve_special` directly. **Exit 0, no script error, 13 checks / 0 failures.**

- **Hold Breath, no Lethal Aim.** A Sharpshooter lineage seated with `engines` emptied holds no engine and no Focus,
  and keeps Quick Shot and Hold Breath.
  - Three Quick Shots before the cast hit 14, 15 and 16.
  - After one cast, six hit 25–28 (mean 26.2 against 15.0, ×1.74).
  - `held_breath` was standing after every one of the six.
  - **The control** — the same seat holding Lethal Aim: the first shot hit 39 and spent the status, and the second hit
    16.
- **The dead buttons.** An engine-less Arcanist's Death Ray and an engine-less Beastmaster's Kill Command (no beast on
  the field) are refused by `_ability_usable`. An engine-less Holy's Resurrection is refused with a hero down:
  `faith_cost` 1 against a second resource named `''` holding 0.
- **Split Shield.** A Warden holding the rune casts Shieldwall. The cast laid `shieldwall` 25 on him and covered no ally,
  while `_recast_writes` proposed 12 for him.
- **Dispel.** A Hunter's Mark laid on an enemy is that enemy's only dispellable status (`["party_mark"]`). A Mage's Dispel
  cast on it removed the mark.
- **The probe's first launch threw.** It called the fixture before the tree was ready. It then hung until its
  240-second alarm killed it (exit 142), which is the known shape of a throwing probe; nothing had been driven. The
  second launch waits a frame first, as every gate does.

### The push

**Committed and pushed to `class-merge` only**; `main` is untouched. The remote read `02b1002` (GK) before the push.
The post-push reading of `git ls-remote origin class-merge` against local HEAD is reported with the delivery rather
than here — written into this file, it would change the commit it names.

---

## WHAT MOVED

`docs/kit-recon.html` (**NEW**), `docs/changelog.html` (one entry, at the top), `docs/state.md` (rewritten), and this
file (**NEW**).
- **Rewritten in `state.md`:** the WHERE block (replaced), two queue sections (added), GK's rulings 5 and 7
  (annotated), the running order's step 3 (a line added) and the last-measurements section.
- **NOTHING ELSE MOVED:** no `.gd`, no `.json`, no `CLAUDE.md`, no `master.html`, no gate, no baseline row, no
  manifest entry.
- **One incidental write, and it changed nothing.** `build_pin_manifest.py` takes no `--help` flag, so a call meant to
  print its usage regenerated `pin-manifest.json` in place. `git` read the file unchanged, and `--check` read it
  current at 1,467 pins.

## THE FOLDERS THIS BATCH LEFT

- **`Dawn of Decay GL probe`** under Godot's `app_userdata`: the probe's isolated copy, renamed so its `user://` could
  not reach the player's save folder. It can be deleted.
- **The probe copy, the extracts, the verdict table and the recon's builder** are in this session's scratchpad, outside
  the repo.
