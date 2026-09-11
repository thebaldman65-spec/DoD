# BATCH FW — WHAT THE MERGED TALENT LAYER CAN REACH

**REPORT ONLY, AND THE FOURTH BATCH ON `class-merge`. NOTHING WAS AUTHORED, BUILT, MERGED OR CHANGED.** No node
was proposed, named or reserved; no system was extended; no constant or magnitude moved; **no code moved, no gate
was written, no baseline row or manifest entry moved and no `CLAUDE.md` rule was added** — the brief forbade all
four. `docs/master.html` is not edited and its stamp is not bumped.

**The deliverable is `docs/systems-recon.html`**, on `spec-recon.html`'s pattern: one self-contained section per
system, and **every heading carries its section's identifier in its own text** (`SR-CHECK`, `SR-BREAK`,
`SR-POUCH`…) so a search for a sub-heading lands in the right section. This file is the batch's own working.

**THE LINE, AS THE DESIGNER RULED IT:** *"A talent may not touch a rune, an ability, a passive or an engine.
Everything else is fair game."*

---

## THE SHORT VERSION

1. **TWENTY-ONE SYSTEMS** belong to no rune, ability, passive or engine outright — the brief's ten, and eleven its
   list missed (the base stats and damage pipeline, healing and shields, the class resource, cooldowns, enemy
   intent, threat and targeting, accuracy and avoidance, damage over time, the trigger sites, battle modifiers, and
   a section on the systems out of reach and why).
2. **274 IS REACHABLE AS A COUNT AND NOT AS A NUMBER OF DIFFERENT THINGS.** About **159** distinct things a node
   could say under the line; **127** need no ruling — **50 today**, 63 small builds (one field and one read line
   each), 14 large — and **32** wait on a ruling. **A tree of 81 has about fifty things to say today, so at least
   31 nodes a tree — 124 of 324, 38% — are a second magnitude of something the same tree already says.** With every
   small hook built, a tree can be distinct within itself, and **any two trees of 81 drawn from ~113 ideas still
   share at least 49**.
3. **THE BILL IS 281, NOT 274.** Re-sorted under the designer's line, **43 of FP's 50 survivors survive**; the bill
   is Warrior 63, Mage 78, Cleric 77, Hunter 63 (282 not counting the inert Overpressure). **Both figures assume four
   trees of 81, and nothing in the repo rules the size** — at 27 a tree, today's machinery alone would fill every
   tree with distinct nodes.
4. **A NODE IS READ ONLY INSIDE A BATTLE.** Its payload is added to the hero's config at spawn and nothing outside a
   fight reads it — so the pouch's structure, gold, the shop, the map and the loadout are unreachable today. **Seven
   silent traps** in that machinery are written down (SR-PLUMB).
5. **§3: THE LINE RUNS INTO TWO STANDING RULES** — the DO charter, which permits modifying the protected core
   (*"worth 83 nodes"*), and EN §4, which puts the purse, the pouch, the shop, a victory's pay and an elite's drop on
   the RELIC side. **15 of the 32 ruling-gated things wait on EN §4 alone.**
6. **§2: ENEMY INTERFERENCE IS PRICED, NOT RULED.** Two of the four flavours are already profile keys; all four need
   one hero-to-bar hook; no instrument the project owns could measure any of them.

---

## §0 — THE BRIEF'S PREMISES

**Twenty-six checkable claims. Eight held outright and five held with a qualifier; one is stale, five are half true,
four are false, and three are recorded nowhere in the repo.** The full table with evidence is
`docs/systems-recon.html` §0. The ones that did not simply hold:

| Premise | Verdict | What the repo says |
|---|---|---|
| FV just added an initiative write and named the constraint | **FALSE** | **FT** (`97577a1`) wrote Momentum's initiative payout and the "NOT A SECOND WRITER OF TURN ORDER" comment; `next_time` writes are **23 before FT and 23 now**; FV added a blow-met door and a rate constant. "A second set of rules for one question" is `check_ft.gd:601`, FT's. The constraint is real. |
| Poison is nobody's in particular | **FALSE FOR HEROES** | every hero-side path is the Survivalist's, and `CLAUDE.md` BA §1 says so as a standing rule; four enemy kinds apply it too |
| The loadout has a swap cost | **FALSE** | benching is free and reversible since EG |
| The party has downed heroes | **FALSE** | no "downed" state exists anywhere in the repo |
| CT built the whole item system | **FALSE** (the second half, "no talent has touched it", holds) | items predate the changelog — git `a98618e` (2026-07-03, "shared party items"), potions `ca16ad0`; CT made the pouch slot-limited |
| What a rest does | **FALSE PREMISE** | there are no rests (AN §6); `rest_heal_add` has no read site |
| The basic attack is `abilities[0]` | **PARTLY** | one of three definitions in the code (`cost == 0`; `damage > 0 and cost == 0 and not is_counter`) |
| An item has a handler and a cost | **PARTLY** | the cost is gold and one use a turn — no turn, no resource; an item is never an `Ability` |
| Fault Line, Turn the Blade and Bring It Down all generate Break | **TWO OF THREE** | Bring It Down is a damage buff (`battle.gd:9610-9611`) |
| CN made the profile a five-field dict | **STALE** | five at CN (`8c3c676`), six since CS (`5d43b07`); `check_cn` pins six |
| Interference queued since CM | **NOT SUPPORTED** | earliest record is CT's comment (`battle.gd:5337-5341`); `state.md`'s line arrived at CW |
| Four flavours from Shadow Hearts; the "adds to the loop" test | **NOT IN THE TREE** | both are the brief's own account |
| FO found searches return the wrong spec's section | **NOT FOUND** | nothing in `FO.md`, its changelog entry or `docs/`; the instruction was followed anyway |
| 50 survivors / 274 is the target | **HELD FOR FP'S RULE** | **43 and 281 under the designer's line** (§3 G) |
| Break: every hero generates it, no engine owns it | **HELD, WITH A QUALIFIER** | the Devout's only Break is Smite and Chastise; four engines are wired to the meter |
| Burn is the Pyromancer's | **HELD, WITH EXCEPTIONS** | Choking Smoke, Umbral Mirror's reflections, two enemies |
| FD found 54 rows / DV one walk where DW found three | **HELD (FD); NOT RE-CHECKED (DV, DW)** | `CLAUDE.md` FD §2 |

**None changed what had to be measured; two change the answer** — the survivors (so the bill is 281) and Poison (so
the free status set is four, not five).

---

## §1 — WHAT WAS MEASURED, AND HOW

| Question | Method | Result |
|---|---|---|
| The node population | `Talents.LANE_TREES` parsed with comments stripped outside strings, then a literal evaluation | 324 nodes (12 × 27, every id unique); 291 stat payloads and 33 ability payloads at the top level (34 nodes at any depth, 36 ability edits); 304 distinct stat fields, 301 of them written by exactly one node |
| The 21 systems | seven read-only surveys over comment-stripped source, string literals kept (this code's reads are string-keyed) | one section each in the recon |
| **Every load-bearing claim** | **re-read against the code by hand before it was written** — the grade multipliers, Holy Light's guard, the spawn-only application, the sim potion, the victory floor, the relic header, the zero-start trap and the class passives' order, the special branch before the strike loop, the four class passives, Overpressure, the tick-kill path, the heal-done coverage, the threat literal, the miss constants, the Momentum door, the DoT table, the intent readers, the payload census, `add_status`'s branches, `check_em`'s rune walk, the four hand census rows | each as the recon states it |
| Provenance | `git blame` and `git log -S` | FT wrote the "second writer" comment; CN shipped five profile fields, CS the sixth, EY the 1.00 sweep; items predate CT |
| FP's 50 survivors | each followed to every read site and the guard chain above it | 43 CLEAN, 3 ability, 1 passive, 3 spec status |
| Statuses | 156 registry ids, 34 `DEBUFF_IDS`, 214 funnel sites and 35 direct writes; an ownership census of every application site | 172 rows; 165 a hero can apply: 23 engine-owned, 112 spec-exclusive, 26 shared, 4 free |
| The count | a rule applied by hand in every section — a distinct thing is a different dial or condition, never a magnitude | 159; §4 of the recon, cross-checked by script against every section's own list |

**NOT MEASURED, AND SAID SO IN THE RECON'S COVERAGE:** balance (not one magnitude, no sim run); anything driven (no
probe, no fight — three claims are inferences and are marked); the enemy side beyond where a system touches it.

---

## §2 — WHAT THE INSTRUMENTS GOT WRONG ON THE WAY, AND HOW EACH WAS CAUGHT

- **THE CENSUS'S PROSE AND ITS SAVED TABLE DISAGREED, AND MY FIRST CONVERTER MADE IT WORSE.** The status survey's
  message quoted 172 rows (113 spec-exclusive, 25 shared, 4 free); its saved table held 168 rows with **no header
  line**, so my first converter took the first data row as the header and dropped the second. **Caught by counting
  the same thing two ways**: the parse read 166 rows where 168 lines began like data. The final table is the saved
  168 plus the four rows the survey's message added by hand (`bleed`, `broken`, `enraged`, `unrelenting`), **each
  verified against `unit.gd` before it went in** — and **the totals the recon prints are computed from the printed
  table (23 / 112 / 26 / 4 = 165), not quoted from the survey's prose.**
- **THREE SURVEYS COUNTED ABILITY PAYLOADS THREE WAYS** (33, 34, 36). Resolved from the parsed tree: 33 nodes at the
  top level, 34 at any depth, 36 ability edits across them. The recon says 33 (34 counting sub-payloads).
- **ONE SURVEY COUNTED 21 SINGLE-SLOT CALLBACKS ON THE UNIT; A DECLARATION GREP FINDS 20.** The recon says 20 and
  names the method.
- **THE ZERO-START TRAP WAS CHECKED FOR A LIVE VICTIM, AND THERE IS NONE.** Only six RETIRED runes write a trapped
  field; no node does. It is a hazard for authoring, not a bug in the game.
- **THE ASSEMBLY SCRIPT'S OWN VALIDATION CAUGHT A STRAY LABEL** and refused to write the page. It also cross-checks
  §4's table against every section's own list before writing, so the count cannot drift from the sections.

---

## §3 — WHAT THE RECON SAYS, IN SIX LINES

- **21 systems, 159 things, 127 without a ruling, 50 today.** The richest today: Break (9), the class resource (7),
  statuses read by count (7), cooldowns (6), the base stats (5) — most of them the survivors' own words.
- **The most untouched room:** the trigger sites (7, all small), intent (5, nothing reads it), the skill check (7
  clear), the timeline (5 small). **The pouch, gold and the shop, the map and the loadout hold 28 things, none
  reachable today, 16 waiting on a ruling.**
- **Seven silent traps** — an undeclared name pays nothing; a payload adds to zero, not the unit's default; two
  class passives assign over the tree; dictionaries cannot be written; "party-wide" is the best living holder; the
  strike loop misses the 70% of abilities that carry a `special`; `check_em` walks every rune, retired included.
- **The status census:** 23 engine-owned, 112 spec-exclusive, 26 shared, 4 free — and reading statuses **by count**
  is the shape a merged tree can use without touching any owner.
- **The class spines read universal traffic**, so "may not touch an engine" has two readings, and the second
  excludes most of the recon for three classes.
- **The survivors:** 43 of 50 under the line; Overpressure never fires; five of FP's claims about them are wrong
  and recorded (`merge-recon.html` is regenerated, not hand-edited).

---

## §4 — THE COUNT

| System | Things | TODAY | SMALL | LARGE | RULING |
|---|---|---|---|---|---|
| SR-CHECK | 9 | 1 | 5 | 1 | 2 |
| SR-BREAK | 15 | 9 | 5 | 0 | 1 |
| SR-STATUS | 14 | 7 | 4 | 2 | 1 |
| SR-TIMELINE | 9 | 2 | 5 | 0 | 2 |
| SR-POUCH | 7 | 0 | 6 | 0 | 1 |
| SR-CRIT | 10 | 3 | 6 | 0 | 1 |
| SR-LOADOUT | 8 | 0 | 0 | 2 | 6 |
| SR-GOLD | 7 | 0 | 1 | 0 | 6 |
| SR-MAP | 6 | 0 | 1 | 2 | 3 |
| SR-PARTY | 8 | 3 | 1 | 0 | 4 |
| SR-STATS | 8 | 5 | 1 | 2 | 0 |
| SR-HEAL | 7 | 2 | 3 | 1 | 1 |
| SR-RESOURCE | 11 | 7 | 4 | 0 | 0 |
| SR-COOLDOWN | 8 | 6 | 2 | 0 | 0 |
| SR-INTENT | 5 | 0 | 4 | 1 | 0 |
| SR-THREAT | 5 | 1 | 2 | 0 | 2 |
| SR-EVADE | 8 | 4 | 3 | 0 | 1 |
| SR-DOT | 3 | 0 | 2 | 0 | 1 |
| SR-TRIGGER | 7 | 0 | 7 | 0 | 0 |
| SR-MODIFIER | 1 | 0 | 1 | 0 | 0 |
| SR-INTERFERE | 3 | 0 | 0 | 3 | 0 |
| **TOTAL** | **159** | **50** | **63** | **14** | **32** |

**The 32 by cause:** 15 on EN §4's relic seam; 7 on standing mechanical rulings (CN's profile rule, CR §1, EX's
rate, EG's ledger, the rung's rules); 5 on an engine's or a passive's gate; 3 on a class passive; 2 on an ability
or a card the hero must draw.

**AND THE SENTENCE THE BRIEF ASKED FOR, NOT SOFTENED:** DN priced a restructure at 97 nodes. **The merged talent
layer is being asked for 281 nodes in four trees of 81, and it has about 127 things to say without a ruling — 50 of
them today. With today's machinery, 124 of the 324 are a second magnitude of something their own tree already says;
with every small hook built, the four trees are one list of about a hundred ideas, dealt four times.**

---

## §5 — VERIFICATION

**THE FLOOR.** It parses — `Parse Error`, `SCRIPT ERROR` and `Compile Error` grepped from every log, never a tally and
never the exit code — and it runs. **Zero across all 107 battery logs**, and zero in the four gates run standalone
before the battery. **No code moved**, so the floor could only have been broken by a stray write; the freeze below is
what proves there was none.

### 5a. THE DOCUMENTS, BEFORE THE BATTERY

- **THE LITERAL SWEEP, AGAINST HEAD, IN ONE PASS.** Every string literal of four characters or more in every `.gd` in
  the repo — **17,035 needles from 139 files**, comments stripped with the pin-manifest generator's own stripper and
  unescaped with its own unescaper — read raw, lowered and whitespace-flattened against HEAD's copy and the edited
  copy of each document.
  - **`docs/changelog.html`: LOST 0 in all three forms**; gained 16 / 19 / 17, and **no gained needle sits in a
    negative pin anywhere in the tree** (read with the generator's own polarity reader).
  - **`docs/state.md`: LOST 11 / 9 / 11** — every one a word from FV's WHERE block, which the rewrite replaced by
    design. **The only file that opens `state.md` is `check_es`** (one non-comment read, by regex), **and none of the
    lost needles is held by `check_es` or `check_fr`.** Its two `2+ threshold` claim windows are intact.
  - **THE SWEEP WAS PROVED TO BITE BEFORE IT WAS TRUSTED**: on the unchanged tree it read 0 / 0 / 0; deleting
    `Batch FG</b> at EP/EQ` (a `check_dv` needle) from the changelog in memory read **LOST 1**, and deleting
    `exsanguination` (a `check_es` needle) from `state.md` read **LOST 1 raw, 2 lowered**.
- **`build_pin_manifest.py --check`: current at 1,452 pins** before and after the edits — no pin moved.
- **THE FOUR GATES THAT READ THESE DOCUMENTS, STANDALONE, WITH THE BATTERY'S OWN COMMAND:** `check_ec` 23 / 0,
  `check_dv` 83 / 0, `check_es` 57 / 0, `check_fg` 22 / 0 — every one on its row, 0 errors.
- **`docs/systems-recon.html` IS READ BY NOTHING**: no gate walks `docs/` as a directory and none names the file —
  `merge-recon.html`'s and `spec-recon.html`'s position too. **Its assembly script refused to write** until every
  heading carried an `SR-` identifier, every id was unique, every anchor resolved, the tags balanced, no placeholder or
  stray label was left, **and §4's table equalled what every section's own list says** (159 / 50 / 63 / 14 / 32). It
  refused once, on a stray label, which is the check working.

### 5b. THE ACCEPTANCE RUN OVER THE FINISHED TREE

| | read |
|---|---|
| what was in the tree | the three documents final — `systems-recon.html`, `changelog.html`, `state.md`; every gate, suite, `baselines.json` and `pin-manifest.json` HEAD's |
| targets / throws / timeouts / incomplete | **107 / 0 / 0 / 0** — one `.ran` sequence in the battery's own order, 107 unique, 107 logs |
| `Parse Error` + `SCRIPT ERROR` + `Compile Error`, grepped from every log | **0** |
| `check_cm_live` (the sanctioned red) | **13 / 4 — the four FAIL lines word for word the previous run's** |
| the document readers | `check_ec` **23**, `check_dv` **83**, `check_es` **57** (`state.md`: 2 claim windows, 4 figures read), `check_fg` **22**, `check_el` **23**, `check_fr` **25** — all 0 failures |
| the gates that read gate source or the manifest | `check_parse` **181**, `check_da` **43**, `check_dw` **35**, `check_ea` **86**, `check_ek` **45**, `check_ed` **18**, `check_ff` **55**, `check_ft` **140** — all 0 failures |
| `check_de` (checks / failures / notices) | **445 / 0 / 0** — no count moved anywhere |
| run harness (gates 1 / 2 / 3) | **22 / 166 / 8**, 0 throws |
| the freeze | **407 files md5-stamped with absolute paths before and after — zero differ**, the designer's four save files among them |
| wall clock | 40 m 38 s |

**THE CEILINGS, AS `check_fg` PRINTED THEM:** the changelog at **288,933 B** against the 400,000 B bar (FW's entry is
5,229 B; 111,067 B of headroom); `CLAUDE.md` **untouched at 302,395 B = 295.31 KiB** against 340 KiB (44.69 KiB of
headroom).

### 5c. AFTER THE RUN, AND SAID SO

**One file was written behind the certifying battery: this report**, which no gate reads. `docs/state.md` was finished
BEFORE the run, which is why its verification bullet points here instead of quoting this table — a cell written
behind the battery would have owed the post-run proof FV had to give. **The freeze, re-stamped after this file was
written, differs from the battery's closing stamp in exactly one file, and it is this one.**

**THE SAVE BACKUP:** the designer's four files were copied to `save-backups/FW-20260910-173706` and md5-verified against
the originals and FV's backup before anything else happened; all four match FV's exactly and were byte-identical at
every freeze stamp this batch took.

---

## §6 — WHAT MOVED

`docs/systems-recon.html` (**NEW**), `docs/changelog.html` (one entry, at the top), `docs/state.md` (rewritten — the
WHERE block replaced wholesale, two queue sections added, the running order's step 2 and the last-measurements
section updated) and this file (**NEW**). **NOTHING ELSE** — no `.gd`, no `.json`, no `CLAUDE.md`, no
`master.html`, no gate, no baseline row, no manifest entry. The designer's four save files were copied to
`save-backups/FW-20260910-173706` before anything else happened, md5-identical to the originals and to FV's backup.

---

## §7 — WHAT NEEDS A RULING

**Only what blocks a decision already made, or what a player sees, is here** (`docs/ways-of-working.md`); every
other finding is in `docs/state.md`'s queue.

1. **THE EDGES OF THE LINE, BEFORE A NODE IS WRITTEN** (the recon's §3):
   - **the DO charter against the line** — a node modifying its spec's protected core was ruled permitted and
     *"worth 83 nodes"*; the line forbids touching an ability;
   - **EN §4's relic seam** — whether the purse, the pouch, the shop, a victory's pay and an elite's drop are open to
     talents at all, and the tiebreak for a per-hero run effect;
   - **the class spines' two readings** of "touch";
   - **the four class passives**;
   - **which of the three "basic attack" definitions**, if the basic attack is open;
   - **spec statuses after the merge** (legal by the line, bets by the charter);
   - **the trees' size** — the one variable that decides how much stat creep is forced.
2. **ENEMY INTERFERENCE** — whether to build it; priced in `SR-INTERFERE`, and a third, non-opt-in exception to the
   standing profile rule if it is.
3. **PLAYER-FACING TEXT THAT IS WRONG TODAY** (found, not fixed — a report touches no code):
   - the first-bar orientation card says every action runs a timing check (`battle.gd:24398`);
   - the map's help says elites pay a talent point (`map_screen.gd:158`);
   - **Cracked Hourglass promises every hero 30% Mana and the Hunter gets none** (`run_state.gd:1356-1360`).
4. **THE KNOWLEDGE SYNC:** `docs/systems-recon.html` is what the 281 nodes will be authored against, and
   `CLAUDE.md`'s must-stay-selected list does not name it (FW added no `CLAUDE.md` line). Selecting it is the
   designer's.
