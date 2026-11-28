# Batch KJ — Enemy Tiers, Moves to Play Around, and a Combo for Every Recipe

**THE RECORD IS THE DESIGNER's WORDS, ANSWERS AND PICKS, NOT A DECISION RECORD, SAID HERE FIRST**: the enemy half of the ask KI
recorded (*"id like to see the enemies abilites have some more depth, mechanics that the player has to play around. i think all
enemies should be categorized in tiers that determine their power and ability count ... lets also make sure the enemies within
the packets share synergy across their abilities"*), its four shape answers at KI (*Combos per recipe*, *Spends count*, *Cost and
stat band*, *Above the tiers*), the 44 picks the designer saved on the options page — every one the option the page marked
recommended, checked programmatically; the designer: *"i saved my picks, your recommendations were awesome"* — and seven figures
the page did not set, each put to the designer with its options and each answered with the recommended one (`RECORD_KJ.md` in
KJ's work folder, verbatim). **Every figure KJ built is one of those**; no balance figure is KJ's own (§0).

**THE VERDICT: DONE — GREEN BUT FOR THE TWO CARRIED REDS, AFTER TWO REPAIR ROUNDS: THE LATE NEW TEXT's READER's, AND THE ACCEPTANCE's, WHOSE ONE RED (`check_hz` §1a) WAS REPAIRED AND READ GREEN BY ITS READERS' REPLAY AND `check_de` OVER THE BATTERY's LOGS, NOT BY A SECOND WHOLE BATTERY.**
- **Every ordinary enemy has a tier, and its tier is its cost to the fight builder and its count of moves**: nine kinds at
  tier 1 (a basic attack alone, five of them biting), twenty at tier 2 (a basic and one move), seven at tier 3 (a basic, one move
  and a Malice spend); the Orc Totemist and the Rotfiend moved up to 2; seven healths moved into their tier's band; elites and
  bosses stand above the tiers (§1).
- **Sixteen new moves, each with a way to play around it**: four Flank moves, three guards (a Break ends a guard), two braces,
  four hex moves (Silence, Brand, Doom), Skullsplitter, Frost Fury and War Cry on every elite (§2).
- **Every one of the twelve recipes carries a combo**, named on a row beside MALICE with its rule on hover, The Rite's count and
  Static Charge's charges on that row (§3).
- **Twenty-nine gates repaired to their intent** — twenty off the census of enemy-data readers, six the pre-runs found and three
  the recon found, and one of the twenty repaired again when the acceptance found it (`check_hz` §1a); one row of the rules census
  built and re-read HELD (every enemy self-cast tagged *ally*); one new gate, `check_kj`, holds the rework (§1, §5).
- **The routing of record was taken after the work, not before it** — Lane A's step, skipped, and found missing by the recon
  battery; taken then, its 55 blocks and the 109 others read against the finished work, and every claim they found KJ had made
  stale — 66 in the routed blocks (seven already mended), 16 in the others — mended in `docs/state.md`, one by building the gate it
  named (FOUND AT KJ).
- **The new text's reader was taken after the pre-run of record** — Lane A's step, skipped like the routing: three readers on the
  new words found 40 claims the code does not bear out, three of them picked words it did not keep (a brace struck by an area
  blow beside its target, Flank's span on a companion, Frost Fury's *"The first time"*); each built or mended, and the
  acceptance run on the repaired tree (FOUND AT KJ, §5).
- **Back to the designer**: eleven rulings owed — the three hexes left with no carrier by the picks first, seven readings, none a
  figure, and **three questions no answer settled, each put with its options**: the figures kept from the moves replaced (War
  Cry's price, the recoveries), War Cry's damage type and Brand's length (NEEDS A RULING, items 9–11); and the rework wants
  the designer's play.

## THE RECORD's FACTS, CHECKED AT SOURCE

*Read on HEAD `16002ae` before any edit reached a lane (`recon/hooks.md` in KJ's work folder holds the map).*
- **A kind's `power` is read by the fight builder alone**: `scripts/run_state.gd`'s composer spends a budget on it and the Swarm
  recipe counts its weak units off it; `Enemies.config` erases `power` and `roles` before a body is built, so at fight time a
  body's roles are read off `Enemies.roles(u.enemy_kind)`. **So a tier that IS the `power` field is one field and one answer.**
- **A fight is one of `Run.THEMES`' twelve role recipes filled from its zone's kinds**, and the theme reaches the battle as
  `Run.encounter["theme"]`, which the battle read only for a log line and a snapshot: **no hook a recipe could reach existed.**
- **A support cast is found by its display name** in `_enemy_support_action`; **an enemy move carries one status**
  (`applies_status`); **a status ticks at the start of its holder's turn**, so a status meant to bind the next turn is laid for
  two; **a wind-up is cancelled by a Stun, a Freeze or a Break** in `_run_battle` (Batch V's `_cancel_charge`), and Skullsplitter
  rides that wind-up.
- **The options page's figures are the picks' own words** (Flank's 50%, Brand's 6%, Doom's 25%, Frost Fury's half health and
  30%, the twelve combos' figures); the seven it did not set — Flank's numbers, Skullsplitter's, the hex moves' blow, the brace's
  strike back, the guards' cooldown, War Cry's blow and the bites' turns — were asked, and answered.

## §0 — WHAT THE PICKS DECIDE, AND WHAT KJ READ

**Built as picked**: A1 *Today's power, with two moved up*; A2 *Bands around today's figures*; A3 *The tougher enemies* spend
Malice; B1–B12 one combo a recipe; C1 *A basic with a bite*; D, one move for each of the twenty tier-2 kinds; E, a move and a
spend for each of the seven tier-3 kinds; F1 *War Cry instead of the Maul*. **The seven figures**, each the recommended option:
Flank at its kind's basic numbers, every 2 turns; Skullsplitter 84 damage and 50 Break damage, every 3 turns; a hex move a light
blow at its basic's damage, every 3 turns; a brace strikes back for half its basic, every 3 turns; a guard every 4 turns; War Cry
the Maul's blow (34 damage, 56 Break damage), every 3 turns; a bite's turns as its old move's (Sunder 2, Poison 3, Slow 2, Daze 2).

**KJ's readings, none a figure** (NEEDS A RULING, items 2–8): The Rite heals free and counts its menders' turns; the new cuts
and boosts read strikes only, as Shielded does; the moves no kind carries keep their code; a guard, a brace and a roar can be
dispelled; Silenced, Branded and Doomed are afflictions, not hexes; two picked combos' play words name Gall, which no hero lays,
as a counter; and four picked words read — a strike back halves Break damage too, Static Charge counts the heals Healing Wave, Wild Growth
and Dark Vigil cast, Flank's *struck* counts a blocked blow, and War Cry aims the blows readied while it holds. **Three questions
no answer settled** (items 9–11), each put with its options: the figures kept from the moves replaced (War Cry's 20 Rage and slow
recovery, Skullsplitter's and the hex moves' recovery), War Cry's damage type (physical, where three Mauls struck in the zone's)
and Brand's length (laid for 3, it charges two of the hero's turns). **Seven of the picks' words the code did not yet keep, built before the close**: the page's *"Breaking it ends the guard"* (a
Break takes Guarding off, and a Broken body guards nothing) and Bodyguards' *"Kill the guards first, or Break them"* (a Broken
tank guards the elite no more) — found reading the picked options' own words against the code, the first build having kept
neither; and the brace's *"or use spells"* (a melee hero's spell, a blow that is not physical, is not struck back) and Compounding
Curse's *"two or more debuffs from this warband"* (a debuff counts only if a body of the warband laid it) — found by the fresh
reader, the build having struck back at every melee blow and counted every debuff; and three the new text's reader found after
the pre-run of record — the brace's *"strikes back at each hero who hits it in melee"* (an area blow that strikes the braced
body beside its target is struck back too), Flank's *"since that hero's last turn"* (a companion's span closes with its
master's turn) and Frost Fury's *"The first time"* (a Fury a Dispel lifts does not come back).

## §1 — THE TIERS AND THE KITS

**`data/enemies.json`** (`edits/data_kj.py`): a kind's tier is its `power`. **Tier 1** (nine): the Orc Raider, the Orc Whelp,
the Orc Slinger, the Orc Archer, the Thornling, the Spore Lobber, the Frostbitten Thrall, the Hailcaster and the Grave Husk —
each its basic attack alone; five bite, a 30% chance of their old move's status (the Raider's Sunder, the Archer's and the
Spore Lobber's Poison, the Thrall's Slow, the Hailcaster's Daze). **Tier 2** (twenty): each its basic and one move — the
Flank moves, the guards, the Icebound Bulwark's brace, five healers' Healing Wave, the Ritual Chanter's and the Grave Totem's
Raise, the hex moves, the Bloodcaller's Blood Tribute and the Rotfiend's Corpse Explosion. **Tier 3** (seven): each its basic, one
move and its spend — the Orc Brute (Skullsplitter, Rally), the Bog Troll (Bog Guard, Entrench), the Rot Behemoth (Wretched
Bellow, Rally), the Ash Hurler (Siege Stone, Rally), the Rimehorn (Frost Fury, Rally), the Mossback (Moss Shell, Entrench) and
the Fen Lurker (Submerge, Rally). **The bands** (A2): tier 1 85–110, tier 2 110–160, tier 3 250–300; seven healths moved into
theirs — the Raider 140 → 110, the Totemist 90 → 110, the Chanter 105 → 110, the Hurler 190 → 250, the Grave Totem 80 → 110,
the Icebound Bulwark 190 → 160, the Rotfiend 90 → 110. **The elites**: War Cry takes the Maul's place on all four. The 45 kinds
held 157 moves and hold 107.

**The pre-KJ warband is kept** (`edits/fixture_kj.py`): `docs/reports/KJ-warband-before.json` is HEAD's `data/enemies.json`, and
`Gate.warband_before_kj()` reads it, so a gate about the warband its batch left reads that warband.

**The gates the rework moved, each repaired to its intent** — twenty off the census of the data's readers, run on the reworked
data before any repair (`logs/cen1` in KJ's work folder), in four scripts replayed from HEAD by `edits/rebuild.sh`:
- **`check_jk`, `check_jl`, `check_jq`, `check_jj`** (`edits/repair_A.py`): a spend's premises re-pointed to the kinds that carry
  one (the Chanter, the Brute, the Bog Troll; C01 on the Orc Chief); the hexes no move lays, `KJ_NO_CARRIER`.
- **`check_ji`, `check_jn`, `check_jo`, `check_jm`, `check_jr`** (`edits/repair_B.py`): the cooldowns the designer set by hand held
  beside the line as `TUNED` is (`KJ_RULED`), each printed with the band the line gives; the carrierless hexes and the hex blows.
- **`check_hz`, `check_ds`, `check_ik`, `check_kf`, `check_jw`, `check_kg`, `check_kh`, `check_ij`, `check_jp`, `check_js`**
  (`edits/repair_C.py`): each reads the kept warband where its subject is the warband its batch left, or the live one where it is
  the game today; `check_ik` 241 → 232, `check_kg` 98 → 95 and `check_kh` 207 → 159, the moves that left taking their checks.
- **`check_ht`** (`edits/repair_D.py`): §1's rite read from the kept warband; and §2's function window, `_bodies`, **repaired at
  KJ §1** — IT's STANDING census row on it (`check_iu` §5) was owed by KJ's touch: a window now ends at its function's last
  indented line, so a top-level declaration below it is no function's text (`check_kj` §5 holds it).
- **Six the pre-runs found and three the recon found** (`edits/repair_E.py`, `edits/repair_F.py`; §5 and FOUND AT KJ): `check_gn`
  §1, `test_batch_bw`, `check_go` §6 and `check_hl` §3b–§3c (a tier-1 basic's bite, laid by one measured blow, armed the next: what
  an enemy's blow laid comes off before the next reading), `check_hn` §3a and `test_batch_bu` (a band's cut let the larger of two
  blows outrun a body's health), `check_io` §1e (the fixture's warband holds no second attack, and the one foe given one fell to the
  bot's picks), `check_di` (KJ's four status-door calls, 225 → 229) and `test_batch_ce` (the glossary's count); and `test_batch_bu`
  §1's block window, IT's second STANDING row KJ's touches owed, **repaired at KJ §1** — the block ends at the next tranche's
  header (C19).
- **And one the acceptance found** (`edits/repair_G.py`; §5 and FOUND AT KJ): `check_hz` §1a, one of the twenty, held the Orc
  Hexer's Choking Hex to *Applies Silenced for 2 turns*; since the new text's reader's repair a Silence's intent line says *on
  that hero's next turn*, as its chip and its description do, and the want follows the line's own rule — a Silence names the
  next turn, any other status its turns (C26).
- **One row of IU's rules census built** (THE RULES A GATE COULD CHEAPLY HOLD: a batch whose work touches a listed rule's subject
  builds its gate): S2-046, *every enemy self-cast is tagged ally*, NONE → HELD — KJ wrote six self-casts (three guards, two
  braces, Frost Fury), and `check_kj` §1 reads every move's target, reddening on any value but *ally* (C20). The standing list
  185 / 74 → 184 / 73.

## §2 — THE MOVES TO PLAY AROUND

**`scripts/battle.gd`** (`edits/game_kj.py`), each figure the designer's, each behind a constant:
- **Flank** (`FLANK_PCT`): 50% more on a hero another body of the warband struck since that hero's last turn (`_kj_struck`); a companion's span closes with its master's turn (`_kj_close_span`).
- **A guard** (`special: bodyguard`, Guarding for `BODYGUARD_TURNS`): in each turn the first single blow aimed at another body
  lands on the guard; an area attack gets past it; **a Break ends it** (`unit.gd`, where the Break is laid) and a Broken body guards
  nothing (`_kj_guard_for`).
- **A brace** (`special: brace`, Hunkered until its next turn): takes `BRACE_TAKEN` of each strike, and strikes back at each hero
  who hits it in melee with a physical blow, aimed at it or striking it beside its target (`kj_braced`), with half its basic, damage and Break damage alike (`_kj_strike_back`, a counter); a
  spell — a blow that is not physical, the project's one reading of the word (`CHANNEL_SPARES_PHYSICAL`) — is spared.
- **Silenced** (two turns, binding the next): the basic attack and nothing else, at the hero's door (`_kj_silenced_from` in
  `_ability_usable`); a debuff, so a cleanse lifts it. **Branded**: each ability costs the hero `BRAND_PCT` of its maximum health.
  **Doomed**: every enemy blow on the hero deals `MARK_PCT` more. The four, War Cry's Singled Out with them, are `DEBUFF_IDS`
  (`unit.gd`) and none is in `HEX_IDS`, so an aimed cleanse takes each by its turns left (NEEDS A RULING, item 6).
- **Skullsplitter** (the Brute): a single-target wind-up, landing next turn on the hero it was raised at; a Stun, a Freeze or a
  Break cancels it. **Frost Fury** (the Rimehorn): the first time it falls to `ENRAGE_AT` of its health or under it roars, `ENRAGE_PCT`
  more for the fight unless a Dispel lifts it, and never again (`_on_damage_taken`, `_kj_roared`). **War Cry** (every elite): a blow that Singles Out a hero for two turns — every blow
  the warband readies while it holds aims there, below a taunt (`_kj_aim`, read as a body declares).
- **The telegraph**: a status move that is no crush (more Break than damage, as War Cry) reads Afflict on its body's plate
  unless it is that body's hardest blow alone (`_intent_category`, read against the body's other moves since KJ), so a hex move —
  as hard as its basic — warns of its status where it would otherwise have read as a plain Strike.

## §3 — A COMBO FOR EVERY RECIPE

**`KJ_COMBOS`** keys each of `Run.THEMES`' twelve names to its combo's label and its hover words, set in `_spawn_units` from the
encounter's theme; **`_draw_combo_row`** stands it on its own row left of the MALICE row, with The Rite's count and Static
Charge's charges on it. Combined Arms (Warband), Pack Tactics (Swarm), Alpha (Monster Den: the last brute's fall Dazes the rest),
Compounding Curse (Cursed Company: two debuffs the warband laid), Bodyguards (Honor Guard: a Broken tank guards no elite), The Rite (Ritual: a count of healers'
turns, at zero the warband heals whole, free), Focus Fire (Poison Volley), Static Charge (Lightning Storm: at three heals the next
single blow strikes every hero), Blood in the Water (Rage Company), Interlocked Shields (Guardian Circle), Field Medic (Elite
Patrol) and Loyal Retinue (Boss Escort). **A recipe filled with an odd mix can miss its combo's condition** — fewer kinds, no tank —
and the combo then does nothing; the fixture's warband — two Orc Raiders and an Orc Archer under the Warband recipe, seated by 82
gates — holds two kinds, so it never meets Combined Arms, and a gate that seats three kinds under that recipe does.

## §4 — THE SIM, RUN TO TEST THE CODE

**The designer's rule (KA): the sim tests the batch's code and decides no figure**, and KJ read no figure off it. **The probes**
(`tools/combo_probe.sh`, `tools/zone_probe.sh`, KJ's work folder; `logs/probeR`, `logs/probeRZ`; the prediction
`logs/probeR.pred`), 21:43 to 21:44 on `lanes/c1`, byte for byte the tree that lands (the repair round's code, as the acceptance
ran it): ten sim battles of each of the eleven recipes other than Boss Escort, all in zone 2 (the tool's zone key for Monster Den
and Lightning Storm does not take, here or at the earlier probes, so they fought there too), and eight battles of four recipes in
the Forest, the Frozen Plains and the Drowned Barrow, with Boss Escort at a budget of 12 in each of four zones — **no script
error, and no engine error but the composer's own**: *no Guardian Circle warband fits budget 8 in zone 6* (the Barrow cannot seat
three tanks at that budget, as before KJ), and *no Boss Escort warband fits budget 6 in zone 1* — the first probe's Boss Escort
keys, its budget and its zone, both do not take (they did not at the earlier probes either), so its ten fights fell back to budget
6 in zone 1 and composed no Boss Escort warband; the second probe's ran at 12 in four zones and composed it each time. **Every new
move printed its line in a sim fight** — the four Flank moves and Flank's own, the guards, Skullsplitter, War Cry and Singled Out,
Silenced, Branded, Doomed, Raise, Corpse Explosion, the brace's strike back, Frost Fury's roar (seventeen roars, each ending
*unless a Dispel lifts it* now), Healing Wave — **and so did the three combos that keep a count or act once**, The Rite, Static
Charge and Alpha; **the other nine multiply or aim a blow and print no line of their own**, so the sim shows them nowhere and
`check_kj` §3 drives each in a fight of its recipe. (The earlier probes ran on trees before the code that lands: `logs/probeF` and
`logs/probeZ` at 17:42 on the pre-run of record's, at the same counts, with every line above but the roar's new end; `logs/probeD`
and `logs/probeDZ` at 20:05 on the repair round's code at six battles a recipe; `logs/probe4` and `logs/probe5` at 14:58, before
the telegraph's tie and the fresh reader's two builds. The counts of each line move between them with the fights the dice composed
— the Ashblade, Cinder Flank's caster, came up in fewer — and none is read as a figure.)

**The composer's least budgets moved with the two tiers the designer raised** (the close-read; the real composer read on both
warbands, `logs/probe_min.log`): with the Orc Totemist and the Rotfiend at a cost of 2, roster 2's Ritual needs 6 where it needed
4, its Lightning Storm 4 where 2 and its Elite Patrol 8 where 7, and roster 6's Warband 5 where 4; the Barrow's Guardian Circle
needed 9 before KJ and needs 9 since. A fight composed under those budgets draws another recipe — the picks' consequence,
reported in FOUND AT KJ, no figure set.

**Every sim figure recorded before KJ was taken on the warband KJ replaced** (the population *the sim's recorded figures* in
`docs/state.md`), and none was re-taken: a re-take would set figures, which is the designer's.

## WHAT ELSE MOVED

**THE TREE THAT LANDS** differs from HEAD in 50 files and this report: **the game** — `data/enemies.json`,
`scripts/battle.gd`, `scripts/unit.gd`; **the gates** — `check_kj.gd` (new) and the twenty-nine repaired (§1), with
`gate_fixture.gd` (`warband_before_kj`) and `run_battery.sh` (`check_kj` after `check_kh`); **the records** — `baselines.json`
(`check_kj` 62, `check_parse` 274, `check_ik` 232, `check_kg` 95, `check_kh` 159, `check_gp` 431, `test_batch_bu` 472, and notes
on `check_di` and `check_gj`), `pin-manifest.json` (regenerated), `docs/reports/KJ-warband-before.json` (new),
`docs/reports/KJ-routing.md` (new, the routing of record), `docs/reports/KF-cuts.tsv` and `docs/reports/JW-picks.tsv` (rewritten by
their gates' repairs), `docs/reports/IT-positional-census.tsv` (`check_ht`'s and `test_batch_bu`'s rows repaired) and
`docs/reports/IU-rules-census.tsv` (S2-046 re-read HELD); **the words** — `docs/master.html` (§4's statuses and enemy AI, §9's
tiers, kits, roster table, budget and recipes with their combos, §10's combo row, the stamp), `data/glossary.json` (thirteen false
clauses mended, Gall, Sap and Mire retired by the glossary's own rule, four new entries — `test_batch_ce` 116 → 120), `CLAUDE.md`
(the self-cast list, the rite's rule, the copies' cooldown sentence), `docs/combat-rules.md` (the hexes' carriers),
`docs/changelog.html`, `docs/design-notes.md` and `docs/state.md` (KJ's rulings, FOUND AT KJ, the WHERE, and the 75 standing claims the
routing's two readers found, 74 written and one built). **No save version moved; no rule was written.**

## §5 — VERIFICATION

**Lane A's floor** (`docs/instrument-rules.md`, *LANE A, STRUCTURAL — THE WHOLE FLOOR*; KJ is Lane A by
`docs/ways-of-working.md`'s reading — a tier replaces what the builder spends, every kit but seven moved and every recipe gained a
combo), each step and where it stood — **two taken out of their order, said first**:
- **The routing of record, late** (`docs/reports/KJ-routing.md`): taken at 16:13 from HEAD's state after the recon found it
  missing; the blocks' reader on its 55 blocks (`report/blocks_reader.md`, 66 findings) and the close-read on the other 109
  (`report/close_read.md`, 16 entries in 19 blocks); their repairs written into `edits/state_kj_blocks.py`,
  `edits/state_kj_close.py` and `edits/records_kj.py`, each checked at the code and against the gates' needles before it was
  written (`report/blocks_agent.md`: twelve corrected, the pin manifest's 55 literal pins on the state none lost). The
  close-read's composer figures read again on the real composer (`logs/probe_min.log`).
- **The new text's reader, late** (`report/newtext/` in KJ's work folder): found skipped as §5 was assembled, after the pre-run of
  record, and taken then — three readers on the new words in the documents (`CLAUDE.md`, the changelog, the combat rules, the
  design notes, the master document: 4 MEDIUM, 6 LOW), the state (1 HIGH, 9 MEDIUM, 6 LOW) and the player's (the data's
  descriptions, the glossary, the chips, the combo row and the log: 7 MEDIUM, 7 LOW), each against the candidate's code. Every
  finding read at source before it was mended (FOUND AT KJ): three picked words built (`edits/fix_kj.py`), three questions put
  with their options (NEEDS A RULING, items 9–11), the rest mended in the words (`edits/newtext_kj.py`,
  `edits/newtext_sources.py`, `edits/report_newtext_kj.py`); left as they stand, the LOW items that follow the cards' own
  convention (*hero* where a companion can be reached) and two the designer's (a combo's role words, the two *Branded*). **What it
  cost**: an edit landing after the pre-run, so the acceptance the floor retires otherwise was owed (below).
- **The push check**: `origin/class-merge` at `16002ae`, local HEAD, read before the landing (the open's own check was not
  recorded apart).
- **The premises at source**: THE RECORD's FACTS, read on HEAD before any edit reached a lane.
- **The documents replayed from HEAD** by `edits/rebuild.sh` and `edits/build_final.sh`, every anchor asserted once, the tree
  built fresh for every run; the landing behind the hash guard (below).
- **It parses**: `check_parse` 274 / 0 in every pre-run that ran it from `logs/s3` on, in the pre-run of record, in the acceptance
  and in its repair round (273 / 0 at `logs/B_gog`, 13:16, on an early tree), no `Parse Error` or `SCRIPT ERROR` in its stream.
- **The literal sweep**, before the prediction (`tools/litsweep.py`; `logs/litsweep_f1.tsv`): the 30,573 literals the instruments
  hold, counted in the 50 files the candidate changes and its `project.godot`, at HEAD and in `lanes/f1`: **116 LOST** — 54 of
  them the cut moves' names in `data/enemies.json`, 27 in the master document and 7 in the state (the moves, the WHERE's script
  paths, the enemy half's RULED, NOT BUILT marker, which `check_kj` §4 holds absent), the rest each gate's own repaired literals
  but six — the cut moves' names in `docs/combat-rules.md`, `CLAUDE.md` and the glossary, and *every cooldown* in `CLAUDE.md`;
  **2,011 GAINED**, the new words of the data, the scripts, `check_kj` and the documents. Every gate that holds one ran on the
  candidate in the pre-runs, and none redded on a literal.
- **The recon** (`logs/b1.out`, KJ's work folder; the prediction `logs/b1.pred` written before the launch): the whole battery
  14:50 to 16:11 on `lanes/c1`, the candidate built at 14:49 — before the Break-ends-a-guard, Broken-guard and Afflict-tie edits,
  so those three are proved by the pre-run of record alone. **As its prediction said, a battery run on a tree with known holes is
  reconnaissance, run to the end with every red collected**: ten targets red, two of them carried bands at their rows
  (`check_cm_live` 13 / 5, the brace bar; `check_gj` 70 / 1, *the card says +179 gold and the purse moved 199* — the Bell's
  20-gold gap on a road KJ's kits re-rolled), and `check_de` 809 / 9. **Each red, read at its FAIL text and repaired to its
  intent:**
  · `test_batch_bl` §1 — *the shipped roster produces the afflict category*: no kind telegraphed Afflict. **A game fix** (§2): a
    status move that ties its body's hardest blow is the status's. On the repaired tree, in the pre-run `logs/s2` (16:18): 88 / 0.
  · `check_go` §6 (four) and `check_hl` §3b, §3c (three) — a 118 blow measured unbound and the same blow bound read 125; a
    Defensive hero took ×0.770 against the ×0.85 it is. **A tier-1 basic bites since KJ** (the Raider's lays Sunder at 30%), and
    the bite one measured blow laid made the next a harder one. Each gate's blow helper now takes off what the foe's blow laid on
    its victim (by its source), so each reading is one bare blow; a hero's blow keeps what it laid (`edits/repair_F.py`). 369 / 0
    and 170 / 0.
  · `check_io` §1e — *no enemy on the board holds an attack beside its basic*: the one foe given the Wolfrider's kit died to the
    bot's own picks, a death the put-back cannot undo. The warband is made deep for the arm. 120 / 0 (the four checks back).
  · `check_di` — *the call-site population is 229, not the 225*: KJ's four status-door calls. Three pass their body as the source;
    **Alpha's Daze passes none, and stays so**: the brute that fell and the hero who felled it are both its cause, and DI's rule
    is to report an ambiguous source, never to pick (FOUND AT KJ). `CALL_SITES` 229; 44 / 0.
  · `check_iu` §5 — *a batch touched a target carrying a MISSES row*: KJ's deep foe in `test_batch_bu` touched a file IT's
    positional census holds a STANDING row on (§1's block window ran to the end of `classes.gd`). **The touch owed the repair**:
    the block ends at the next tranche's header, REPAIRED AT KJ §1 in the census and in the source; `test_batch_bu` 471 → 472.
    Control C19 bites on the repaired gate (*Recant sits inside the BU block*) and HEAD's gate, on the same arm, does not print
    it; the arm renames the card's key and writes its name below the next tranche's header, which leaves the card undefined, so
    both arms also throw seven times (451 checks on the repaired gate, 453 on HEAD's).
  · `check_iu` §8 — *docs/reports/KJ-routing.md is not in the tree*. **KJ had not taken its routing of record**, a Lane A step
    before the first lane edit. Taken at 16:13, after the recon, from HEAD's state; its 55 blocks read by the blocks' reader and
    the 109 others by the close-read, against the finished work (FOUND AT KJ; `docs/reports/KJ-routing.md`).
  · `check_is` §5 — *the core is … KI's RULINGS OWED …*: KJ's rulings took the core's role and KI's kept it too. KI's moves to an
    ordinary row, as KH moved KG's.
  · `check_gp` 482 → 431, no fail — every section printed as before, and §4's seeded road re-rolled: 27 and 33 battles where KI's
    walked 30 and 27, each to zone 3 slot 17. The row moves with its reason.
- **The fresh reader**, before the freeze (`report/fresh_read.md`): 4 HIGH, 6 MEDIUM, 12 LOW, each read at source and mended — the
  two picked words it found unbuilt built (the brace spares a spell; the curse counts the warband's debuffs), the two readings and
  the one figure it found unlisted put in NEEDS A RULING (items 8 and 9; its third reading, the curse's count, built), the sim
  probes re-run on the code that lands, and the counts and wordings corrected in this report, the routing record and the state's
  scripts.
- **The pre-runs** on the candidate, each on clones of it (`tools/subset_kj.sh`): `lanes/D` (built 16:57, the routing's mends in)
  — 108 targets, every reader of `docs/state.md`, every gate that reads gates' source or the reports, and the gates that walk a
  seeded road (`logs/s4`): **every one at its row**, `check_gj` 70 / 1 its carried band; then `lanes/f1`, the final candidate with
  the fresh reader's builds in — 37 targets that read what changed since D (`logs/s5`): every one at its row but `check_jw` 62 /
  1, *1 sites of the battle read the warband and the census does not classify them*: the curse's count walks the warband for its
  names, a site `docs/reports/JW-picks.tsv` did not hold. **Its row added** (class R, a read: no body chosen;
  `edits/repair_C.py`), the candidate rebuilt, and `check_jw` with the fifteen readers of gates' source run again (`logs/s6`): all
  sixteen at their rows. `check_gp` 431 / 0 on both trees, its road the recon's (27 and 33 battles, zone 3 slot 17); `check_gj`'s
  card the recon's (+179 / 199). **And after the repair round** (below), on `lanes/D` — 31 targets: the seeded roads, the readers
  of `battle.gd`'s text, of the glossary, the documents and the rulings, and the carried bands (`logs/s8`; the prediction
  `logs/s8.pred`): **every one at its row**, `check_kj` 62 / 0, `check_gp` 431 / 0 on the same road, `check_cm_live` 13 / 5 and
  `check_gj` 70 / 1 as before.
- **The controls**, on the repaired candidate (`tools/ctl_kj.sh`, `logs/ctlD2`; every anchor dry-checked on it first): **all
  twenty-five bite**, each on its own copy, each read at its FAIL text — C01–C18 on `check_kj`'s rework (C15–C17 the Break's
  three, C18 the telegraph's tie), C19 on `test_batch_bu` §1's repaired window (its HEAD arm, HEAD's gate on the same defect, the
  want absent: `logs/ctlF`; both arms throw seven times, the arm leaving the card undefined), C20 the self-cast tag (*shieldmaster
  Shield Guard: self*), C21 the spell spared (re-anchored on the brace's new condition), C22 the curse's source (*x1.250 against
  x1.000*), and the late reader's three: C23 a companion's span (*does not close with its master's turn*), C24 the area brace
  (*drew no strike back*), C25 the Fury lifted (*roared again*). **And the other arm**: the new `check_kj` on a copy of the tree
  before the repair round reads 62 / 3, at those three checks' words and no other (`logs/oldarm`) — its first try threw at the
  missing helper and stopped §2, so the check asks `has_method` and reds at its words.
- **The sim** (§4): both probes on `lanes/c1`, byte for byte the tree that lands, at ten and eight battles (`logs/probeR.pred`
  written before the launch at 21:43): no script error, the composer's two known messages and no other engine error, every new
  move's line, all four Flank moves among them, and every roar ending *unless a Dispel lifts it* — every line of the prediction
  held but one word of its second: the first probe's Boss Escort composed no warband, as at `logs/probeF`, where the line said it
  composed at its tool's budget; its message was the one the line named.
- **The new gate**: `check_kj`, 62 checks (59, and three the late reader's builds owed), its row written before each run
  (`edits/newgate_kj.py`); the pin manifest regenerated (2,466 pins; 2,463 on the pre-run of record's tree); `baselines.json`'s
  moved rows each with its reason (`edits/newgate_kj.py`, `edits/baselines_kj.py`).
- **The pre-run of record** (`logs/a1.out`, KJ's work folder; the prediction `logs/a1.pred` written 17:44:29, the launch at
  17:44:32): the whole battery 17:44:32 to 19:05:51 on `lanes/f1`, frozen at 17:44:20 (9,497 files, `.godot/` aside;
  `lanes/f1.md5`), the user's game not running, exit 0. **Every line of its prediction held**: every recorded target at its row,
  no throw, and no `Parse Error` or `SCRIPT ERROR` in any stream; the two carried reds and no other — `check_cm_live` 13 / 5 (the
  brace bar, its coin; its row 4–5) and `check_gj` 70 / 1 (*the card says +179 gold and the purse moved 199*); `check_kj` 59 / 0,
  `check_gp` 431 / 0 (27 and 33 battles, each to zone 3 slot 17; about 201 s from `check_go`'s log to its own, inside its 480),
  `check_go` 369 / 0, `check_io` 120 / 0, `check_di` 44 / 0, `check_hl` 170 / 0, `check_jw` 62 / 0, `check_iu` 185 / 0, `check_is`
  96 / 0, `check_parse` 274 / 0, `test_batch_bu` 472 / 0, `test_batch_bl` 88 / 0 (the timing read the prediction named likeliest
  to flake) and `test_batch_ce` 934 / 0; `check_de` **809 / 0 / 0, 197 of 197 recorded targets swept, none off its recorded
  line**.
- **The repair round, the late reader's** (`edits/rebuild.sh`, `fix_kj.py` after the game's script and `newtext_kj.py` after the
  state's, with `newtext_sources.py`'s mends in the sources; `lanes/D`, built 19:46:24): the literal sweep against the pre-run of
  record's tree, before any prediction (`logs/litsweep_D2.tsv`, on the 19:40 build; the 19:46 build added `check_kj`'s
  `has_method` guard, whose string, `_kj_close_span`, names the helper the gate asserts present): **2 LOST** — `stunned` and
  `_kj_add_charge`, words the rulings' items 2 and 8 gave up — and **30 GAINED**, `check_kj`'s three checks and the mended words;
  `check_parse` 274 / 0 (`logs/s7`, the 19:40 build) and `check_kj` 62 / 0 (`logs/s7b`, the 19:46 build; `check_parse` 274 / 0 on
  it again in `logs/s8`); the sim probes again (§4).
- **The acceptance** (`logs/a2.out`; the prediction `logs/a2.pred` written 20:06:34, the launch at 20:07:19), owed because the
  repair round landed edits after the pre-run of record: the whole battery 20:07:19 to 21:28:37 on `lanes/D`, frozen at 20:06:00
  (9,497 files, `.godot/` aside; `lanes/D.md5`), the user's game not running, exit 0. **Read against its prediction, three of its
  five lines failed, all on one red.** What held: no throw, and no `Parse Error` or `SCRIPT ERROR` in any stream; the two carried
  reds at their rows — `check_cm_live` 13 / 5 and `check_gj` 70 / 1 (*the card says +179 gold and the purse moved 199*); and every
  named line (its third) — `check_kj` 62 / 0, `check_gp` 431 / 0 (about 201 s from `check_go`'s log to its own, inside its 480),
  `check_go` 369 / 0, `check_hl` 170 / 0, `check_io` 120 / 0, `check_jw` 62 / 0, `check_iu` 185 / 0, `check_is` 96 / 0,
  `check_parse` 274 / 0, `check_ed` 18 / 0, `test_batch_ce` 934 / 0, `test_batch_bl` 88 / 0 and `test_batch_bu` 472 / 0. **The
  red**: `check_hz` 106 / 1, §1a — *the hover does not say `Applies Silenced for 2 turns`* — on the Orc Hexer's Choking Hex, whose
  hover line the repair round made say *on that hero's next turn* (`edits/fix_kj.py`, the new text's reader's P-02). It broke the
  first line (every recorded target at its row), the second (no red but the two carried) and the fourth (`check_de` 809 / 1,
  *check_hz went REDDER*, 197 of 197 recorded targets swept, `check_hz` the one off its row). The fifth line named the likeliest
  red as a target the repair round's pre-run had not run — a seeded count, where the red was a text: that pre-run, `logs/s8`, took
  31 targets chosen by what each reads, and `check_hz` names no file — it reads the hover live, through the line's own tooltip.
- **The acceptance's repair round** (`tools/repair1_kj.sh`; the prediction `logs/r1.pred` written before the launch at 21:34:55,
  done 21:42:48; `logs/r1.out`): `check_hz` §1a's want follows the hover line's own rule — a Silence names that hero's next turn,
  any other status its turns (`edits/repair_G.py`, replayed by `edits/rebuild.sh`) — and the FOUND entry on the late reader says
  what the acceptance found (`edits/found_kj.md`). The candidate rebuilt from HEAD into `lanes/c1` (21:31:51) and its three moved
  files — `check_hz.gd`, `docs/state.md` (527,735 B) and `pin-manifest.json` (2,466 pins) — installed into `lanes/D`, the
  battery's copies kept (`logs/r1_battery/`): **0 files differing** between the two trees, and the tree re-stamped
  (`logs/D_post.md5`, the landing's) differing from the freeze in those three and no other. The literal sweep on the three against
  the battery's copies, before the prediction (`logs/litsweep_r1.tsv`): **0 LOST, 4 GAINED** — `check_hz`'s own want; *silenced*
  and *bind* in `check_hz.gd`, which no holder counts in that file (`check_jp` reads every gate's text for its own attacks-off
  line; `check_jb` builds its *bind* needles at run time over `scripts/`, `data/` and the documents); *for 2 turns* in the state,
  `check_ij`'s card-text needle, read against the cards — and 31 counts moved, none by more than two. **The 60 targets whose code
  names `check_hz`, `docs/state.md` or the pin manifest, or lists the root's gate files** (`logs/r1_run.txt`, `check_fi` and
  `check_parse` among them; a reader of the state by a split literal sought and none found but `check_de`), run on three clones of
  `lanes/D` (`logs/r1`): **every one at its recorded row, no fail**, no `Parse Error` or `SCRIPT ERROR` — the battery's rows for
  all but `check_hz`, 106 / 0 where the battery read 106 / 1; `check_ed` 18 / 0, `check_parse` 274 / 0, `check_kj` 62 / 0,
  `test_batch_aj` 213 / 0 (its own *checks, FAILED* form, read off its log); `check_de` over the battery's logs with those 60
  replaced (`logs/r1de`, its reading `logs/r1_de.log`): **809 / 0 / 0, 197 of 197 recorded targets swept, 0 off their recorded
  line**. **And control C26** (`logs/ctlR1`, its anchor dry-checked on `lanes/c1` first): the Silence's line put back on its turns
  on a clone of `lanes/D`, the repaired `check_hz` reds at *the hover does not say `Applies Silenced on that hero's next turn`* —
  BIT; the other arm is the acceptance's own red, the gate before this repair (its §1a want HEAD's line, unchanged) on the new
  code. Every line of the prediction held.
- **The fresh reader of the assembled report, and its round** (`report/fresh_read2.md` in KJ's work folder): a second reader, on
  the report as assembled after the acceptance's repair round, against the logs, `lanes/D` and HEAD — 1 HIGH, 7 MEDIUM, 5 LOW,
  each read at source before it was mended. The HIGH was this report's: the acceptance's paragraph said every line of its
  prediction held but one, where three of its five failed on the one red. One stood in landed text: the state's FOUND clause said
  the repair round's pre-run *took the readers of `scripts/battle.gd`'s text*, where it took 31 targets chosen by what each reads
  and `check_hz` names no file. The rest were this report's counts and citations — the pins (2,466), the first probe's recipes
  (eleven in zone 2; Boss Escort's keys empty, its fights composing none), the recon's `test_batch_bl` reading (`logs/s2`, not
  `lanes/k1`), the fresh reader's readings (two and a figure), C19's throws, the verdict's ground, the sweeps' wording and the
  builds behind `logs/s7` and `logs/s7b` — each mended where it stands. **The state's round** (`tools/repair2_kj.sh`; the
  prediction `logs/r2.pred` written 22:01:57, the launch at 22:01:59, done 22:07:40; `logs/r2.out`): the clause corrected in
  `edits/found_kj.md`, the candidate rebuilt into `lanes/c1` (22:01:02) and its `docs/state.md` (527,754 B) installed into
  `lanes/D`, r1's copy kept (`logs/r2_battery/`): **0 files differing** between the two trees, the re-stamp (`logs/D_post.md5`;
  r1's kept as `logs/D_post_r1.md5`) differing from r1's in the state alone. The literal sweep against r1's copy
  (`logs/litsweep_r2.tsv`): **0 LOST, 0 GAINED**, ten counts moved by one. **The 46 targets whose code names the state**
  (`logs/r2_run.txt`), on three clones of `lanes/D` (`logs/r2`): **every one at its row in r1's merged logs, no fail**, no `Parse
  Error` or `SCRIPT ERROR`; `check_de` over r1's merged logs with those 46 replaced (`logs/r2de`, its reading `logs/r2_de.log`):
  **809 / 0 / 0, 197 of 197 recorded targets swept, 0 off their recorded line**. Every line of the prediction held.
- **The read-backs**: at 19:06:16, after the pre-run of record (`tools/readback_kj.sh`; `logs/readback_a1.txt`): the frozen tree
  at its 9,497 md5s, none differing; the player's 87 files at the md5s taken at 15:02, none differing; 623 user-data folders then
  and now; the boot time unchanged. **At 21:30:00, after the acceptance and before its repair** (`tools/readback2_kj.sh`;
  `logs/readback_a2.txt`): `lanes/D` at its 9,497 md5s, none differing; the player's 87 files, none differing; 623 user-data
  folders; the boot time unchanged. **And at 21:46:33, after the repair round and the probes** (`logs/readback_r1.txt`): `lanes/D`
  differs from its freeze in three files — `check_hz.gd`, `docs/state.md` and `pin-manifest.json`, the three the repair round
  installed — and equals its re-stamp then (`logs/D_post_r1.md5`); the player's 87 files, none differing; 623 user-data folders;
  the boot time unchanged. **And at 22:07:56, after the state's round** (`logs/readback_r2.txt`): `lanes/D` differs from its
  freeze in the same three files and equals the re-stamp the landing reads (`logs/D_post.md5`); the player's 87 files, none
  differing; 623 user-data folders; the boot time unchanged.
- **The listing gates, on a clone with this report in** (`tools/listing2_kj.sh`, `lanes/lst`; `logs/lst`; the prediction
  `logs/lst.pred` written 22:08:34, the launch in the next second, done 22:10:43; `logs/lst.out`), on the tree that lands with
  this report as assembled, its listing sentence not yet filled: **every gate at its row, as predicted** — `check_jt` 4 / 0 (*194
  reports listed, CW to KJ*, the newest KJ.md, its closing block naming the four sections), and `check_jc` 70, `check_is` 96,
  `check_iu` 185, `check_jr` 87, `check_hx` 42, `check_jo` 54, `check_jp` 33, `check_fr` 25, `check_jv` 92, `check_jw` 62,
  `check_jx` 37, `check_di` 44, `check_jl` 62 and `check_kj` 62, each with no fail, and no `Parse Error` or `SCRIPT ERROR` in any
  log. This sentence, filled after the run, swept against the copy they read (`logs/litsweep_lst.tsv`): **0 LOST, 0 GAINED**, 34
  counts moved by its own words.
- **The two ceiling readings**: `CLAUDE.md` 529,305 B at the open and 529,587 B at the close (+282, the copies' sentence and the
  self-cast list; KJ wrote no rule), 62.83 KiB under its 580; `docs/state.md` 505,312 B at the open and 527,754 B at the close
  (+22,442: KJ's rulings, FOUND AT KJ, the WHERE, the 75 stale claims mended, the late reader's mends and the acceptance's FOUND
  clause, corrected by the fresh reader), 4.62 KiB under its 520, nothing archived.
- **The landing**: `tools/land_kj.py`, behind IW's hash guard: the 50 files of the frozen tree's own diff from HEAD
  (`tools/land_list_kj.txt`, `project.godot` aside, asserted equal to the diff, listed before the freeze; the acceptance's repair
  round moved three of them and added none), each copied only where the repository held HEAD's bytes and the tree's bytes were
  those the last re-stamp recorded (`logs/D_post.md5`: the freeze's md5s but for `check_hz.gd`, `docs/state.md` and
  `pin-manifest.json`, as the acceptance's repair round and the state's round left them); no gate's code names this report by its
  path; and this report last, after its landing check — no unsubstituted token, the last heading WHAT THE NEXT DECISION RECORD
  OWES, the four sections named.

## FOUND AT KJ

- **THE ROUTING OF RECORD WAS TAKEN AFTER THE WORK, AND WHAT THAT COST IS MEASURED.** Lane A takes it before the first lane edit;
  KJ built its rework, its repairs, its documents and its recon first, and the recon battery found the record missing (`check_iu`
  §8). It was taken at 16:13 from HEAD's state (`docs/reports/KJ-routing.md`) and its blocks read against the finished work: the
  blocks' reader found 66 claims KJ had made false or stale in the 55 routed blocks, 23 of them HIGH and 17 of those still
  standing in KJ's state (WHAT STANDS saying no kind's figures moved, the spends' and cooldowns' holders and bands, the Malice
  block's *it cannot out-heal the party* beside The Rite, the Frozen Plains' and the Barrow's old kits); the close-read found 16
  more in 19 of the other 109. **Every one is mended in `docs/state.md`** (`edits/state_kj_blocks.py`, `edits/state_kj_close.py`),
  fifty-eight of the blocks' reader's fifty-nine standing (the fifty-ninth, S2-046, built rather than written) and all sixteen of the close-read's, twelve of the readers' own repairs corrected at the code before they were written (`docs/reports/KJ-routing.md`, NEEDED; the readers' files in KJ's work folder). **What it shows**: KJ's own state edits had reached only the blocks it thought to open; the step is a check
  on that, and skipping it left KJ's state false where a later batch would read it. `check_iu` §8 holds that the record exists and
  has its shape, never when it was taken, so nothing reds on the order.
- **THE NEW TEXT's READER WAS TAKEN AFTER THE PRE-RUN OF RECORD, AND WHAT IT FOUND IS MENDED.** Lane A reads a batch's new
  words before the pre-run; KJ ran the pre-run of record first (every line of its prediction held) and found the step skipped
  as it assembled §5. Three readers then read the new text (`report/newtext/` in KJ's work folder): the documents (4 MEDIUM,
  6 LOW), the state (1 HIGH, 9 MEDIUM, 6 LOW) and the player's words (7 MEDIUM, 7 LOW). **Three were picked words the code did
  not keep, now built** (`edits/fix_kj.py`), each held by a new `check_kj` check that reds on the code before it (62 / 3, at
  each check's words) and by a control (C23–C25): the brace strikes back at an area blow that strikes it beside its target, a
  companion's Flank span closes with its master's turn, and Frost Fury roars once a fight. The HIGH — War Cry's damage type,
  which no answer set — and Brand's length went to NEEDS A RULING (items 10, 11), the kept recoveries to item 9; the rest are
  mended in the documents, the state, the hovers and the data's descriptions (`edits/newtext_kj.py`, `edits/newtext_sources.py`).
  Being late cost a repair round and the acceptance run, KJ's second order slip after the routing.
- **The page's play-around words were not all built by the first pass**: *"Breaking it ends the guard"* and Bodyguards' *"or
  Break them"* — found reading the picked options' words against the code, built before the close (§0), each held by `check_kj`
  and each by a control that bites (C15–C17).
- **The fresh reader found two more of the picks' words unbuilt**: the brace's play, *"Hit something else that turn, or use
  spells"* — the build struck back at a melee hero's every blow, a Cleric's Smite among them — and Compounding Curse's does, *"two
  or more debuffs from this warband"* — the build counted every debuff. Both built before the freeze (§0), each held by a new
  `check_kj` check and a control that bites (C21, C22).
- **The recon battery found that no enemy telegraphed Afflict** (`test_batch_bl` §1: the roster no longer produced the
  category): every hex move hits as hard as its basic, and a status move that tied its body's hardest blow read as a Strike.
  **Repaired in the game, not the gate**: the rule reads the body's other moves, so a tie is the status's (§2), held by `check_kj`
  §2 and a control (C18) — a player meeting Silence, Brand or Doom sees it coming.
- **The pre-runs found six gates and the recon three more that the census of data readers did not name** (§1): a tier-1 basic's
  bite armed the second of two measured blows (`check_gn`, `test_batch_bw`, `check_go`, `check_hl`), a band's cut let a blow outrun
  a body (`check_hn`, `test_batch_bu`, and `check_io` §1e's foe, felled by the bot's picks), KJ's four status-door calls
  (`check_di`) and the glossary's count (`test_batch_ce`) — each repaired to its intent (`edits/repair_E.py`, `edits/repair_F.py`).
- **The acceptance found a gate the repair round's pre-run did not run**: `check_hz` §1a held a Silence's hover line to its
  old *"for 2 turns"*, which the new text's reader's repair changed. That pre-run (`logs/s8`) took 31 targets
  chosen by what each reads in the source; `check_hz` names no file and reads the line live, through the intent label's
  tooltip, so a choice by source could not see it — JC's *a sweep cannot see a drive*, met again (`docs/reports/JC.md`). Repaired to its intent
  (`edits/repair_G.py`), the readers of the three files the repair moved replayed and `check_de` run over the battery's logs
  with theirs in place (§5).
- **KJ's touch of `test_batch_bu` owed IT's STANDING row on it** (`check_iu` §5, in the recon): repaired at KJ §1, with a control
  that bites on the repaired gate and not on HEAD's (C19); IT's standing picks are eight of twenty since KJ.
- **KJ's glossary called Silenced, Branded and Doomed *a hex*** (the blocks' reader), where the code keeps them out of `HEX_IDS`
  and the master document calls each an affliction: the glossary says *an affliction* now, and whether they should be hexes is
  NEEDS A RULING item 6.
- **A rule the cheap-gate list holds sat on KJ's subject**: S2-046, every enemy self-cast tagged *ally*, which KJ wrote six of.
  Built in `check_kj` §1 and re-read HELD (C20), as the list's own rule asks of the batch that touches it.
- **Not fixed, reported**: the glossary's *Chilled* says only an enemy mender's Cleansing Rite thaws it, and no kind casts that
  rite since KJ — its arm stands (item 4) and `check_ij` §2e pins the text, so it moves with item 4's answer; Alpha's Daze carries
  no source, its cause ambiguous (`check_di`; DI's rule reports it); the designer's two tier moves raised four recipes' least budget
  (§4), and the Barrow cannot compose a Guardian Circle at a budget of 8, as before KJ; a combo's role words (*archer*, *healer*,
  *brute*, *tank*) name tags a fight never shows — the master document defines them against its roster table's Role column; two
  statuses answer to *Branded* (Rot Brand's, and the Umbral Sigil's chip text), a name the designer's; and the new text's
  reader's LOW items that follow the cards' convention stand (*hero* where a companion can be reached).

## NEEDS A RULING — THREE HEXES WITHOUT A CARRIER; SEVEN OF KJ's OWN READINGS, TAKEN, NONE A FIGURE; THREE QUESTIONS NO ANSWER SETTLED, EACH PUT WITH ITS OPTIONS

1. **GALL, SAP AND MIRE HAVE NO CARRIER (the designer's tier picks).** Every move that laid them was cut: the Orc Archer's and the
   Spore Lobber's Gall (tier 1), the Hexer's, the Blightcap's and the Stillwrought's Sap moves and the Grave Totem's Mire (not
   picked); Fester keeps the Rot Behemoth's Wretched Bellow. Their code stands. **Taken**: as picked. **The alternative**: give one
   back as a tier-1 bite or a tier-2 kind's move. **Reversing it**: the data, and the carrierless tables of `check_jl`, `check_jo`
   and `check_jr` (`check_jm`'s Gall and Sap), which red the day a carrier returns.
2. **THE RITE HEALS FREE, AND COUNTS ITS MENDERS' TURNS.** *"Every enemy heals to full"* is read as no Malice paid, and the 4-turn
   count as the turns of the page's *healers*, the `mender` role — the Ritual Chanter and the Grave Totem among them, which carry
   a Raise and no heal — one Stunned, Frozen or Broken on its turn adding one (a Glacial Hold pauses the count). **The
   alternative**: paid from the pool like every heal; counting every body's turn; or only a body that carries a heal. **Reversing it**: `battle._kj_rite_turn`.
3. **THE NEW CUTS AND BOOSTS READ STRIKES ONLY, AS SHIELDED DOES.** Hunkered, the guards' recipes, Flank, Doomed, Fury and the
   combos multiply a blow in the strike loop; a tick and a companion's blow pass them. **The alternative**: through the damage door,
   as Rootbound is. **Reversing it**: `_kj_out_mult` and `_kj_in_mult` moved to the doors.
4. **THE MOVES NO KIND CARRIES STAND IN THE CODE.** Shielding, Regenerate, Cleansing Rite and Dark Vigil keep their arms, a lost
   feature rather than scaffolding, so a kind may carry one again. **The alternative**: delete them. **Reversing it**: the arms in
   `_enemy_support_action` and `_resolve_special`.
5. **A GUARD, A BRACE AND A ROAR CAN BE DISPELLED.** Guarding, Hunkered and Fury are beneficial statuses on an enemy and none is in
   `DISPEL_NEVER`, so a Dispel strips each, as it strips a Rally. **Taken**: dispellable, as every warband buff is. **The
   alternative**: list them in `DISPEL_NEVER`, so only a Break ends a guard, only time a brace, and nothing a Fury
   (a Fury lifted does not come back: the page's *"The first time"*). **Reversing it**: that
   constant.
6. **SILENCED, BRANDED AND DOOMED ARE AFFLICTIONS, NOT HEXES.** The moves that lay them are the page's *hex moves*, but the three
   stand in `DEBUFF_IDS` and not in `HEX_IDS`, so a cleanse lifts each and an aimed one (Dispel on an ally, Field Dressing, the Rune
   of the Medic) takes it by the turns it has left, after any hex, as Sunder is taken. **Taken**: as built; KJ's glossary said *a
   hex* of the three (the blocks' reader) and says *an affliction* now. **The alternative**: list the three in `HEX_IDS`, so an
   aimed cleanse takes them before any other. **Reversing it**: that list, and `check_jq` §2's copy of it.
7. **TWO PICKED COMBOS' PLAY WORDS NAME A COUNTER NO HERO HAS.** The page's Static Charge (*"Gall, kill or silence the healers"*)
   and Field Medic (*"Kill or Gall the healer before the elite"*): no hero lays Gall (the blocks' reader). **Taken**: as built — the
   answers are the kill, and a hold (a Stun, a Freeze, a Break) that costs a healer its turn, which stops its heal and puts The Rite
   back a turn; no shipped text names Gall. **The alternative**: give the heroes a way to lay Gall — a card or a rune, the
   designer's to author. **Reversing it**: that content.
8. **FOUR PICKED WORDS, READ.** A brace *"strikes back for half its basic"* (answer 4) is half its basic's damage and half its
   Break damage alike; Static Charge's *"each heal the warband casts"* counts Healing Wave, Wild Growth and Dark Vigil — only
   Healing Wave reaches a Lightning Storm fight, and the Rotfiend's Corpse Explosion heals a neighbour there and adds none; Flank's
   *"struck"* counts a blow the hero Blocked or parried; War Cry's *"every enemy aims its blows at that hero"* aims each blow a
   body readies while the mark holds, as a taunt does, and re-aims none already readied. **The alternative**: the damage alone;
   Corpse Explosion counted; a blow that lands; the readied blows re-aimed. **Reversing it**: `_kj_strike_back`;
   `KJ_HEAL_SPECIALS`; `_kj_note_struck`'s place; `_kj_aim`'s caller.
9. **FIGURES NO ANSWER SET — PUT WITH THEIR OPTIONS.** War Cry has the Maul's blow (34 damage, 56 Break damage, every 3 turns,
   answer 6) and, which no question asked, the Maul's **20 Rage a cast and slow recovery (4.0, where a basic is 2.0)**;
   Skullsplitter keeps Overhead Crush's 3.5; the four hex moves recover in 2.5, their basics in 2.0. **The options**: (a) each as
   built (the recommendation: the elites paid that for the Maul, and a hex move costs a little more than the blow it rides);
   (b) War Cry at no Rage and 2.0, the hex moves at 2.0; (c) War Cry at 20 Rage and 2.0, the rest as built. **Reversing it**:
   keys in `data/enemies.json`.
10. **WAR CRY's DAMAGE TYPE, WHICH NO ANSWER SET — PUT WITH ITS OPTIONS.** Every War Cry is physical (`check_kj` §1 holds it).
   The Mauls it replaced struck in the zone's type — the Huntmaster's nature, the Warlord's frost, the Thane's shadow (KG's
   *"The zone's"*, KH's *"Each copies its Orc"*) — and answer 6's *"the Maul's blow"* named no type. **The options**: (a) each in
   its Maul's type (the recommendation: KG's ruling kept); (b) physical on all four, as built. **Reversing it**: a key each.
11. **BRAND's LENGTH, WHICH THE PAGE's WORDS LEAVE OPEN — PUT WITH ITS OPTIONS.** *"Brands a hero for 3 turns"*: Rot Brand lays
   Branded for 3, as every status is laid, and a clock ticks at its bearer's turn start, so the hero pays on two turns (a
   Silence, meant for one, is laid for 2). **The options**: (a) laid for 4, three turns paid, as the words read (the
   recommendation); (b) laid for 3, two, as built. **Reversing it**: one key.

## THE CHECKS THIS REPORT NAMES FOR RETIREMENT

**None new.** **What found KJ's findings, by step**: the census of the data's readers found twenty gates; the pre-runs found six
more; reading the picked options' words against the code found two play-around rules unbuilt; the recon battery found three gates more, the Afflict telegraph and the routing of record missing; the routing's two readers, taken late, found 75 claims in the state KJ's edits had made stale; the fresh reader found two picked words unbuilt (the brace's spells, the curse's source), two readings and one figure unlisted, and four false claims in this report; the pre-run on the final candidate found one census row owed (`check_jw` §4, the curse's walk); the new text's reader, taken late, found 40 claims in the new words, three of them picked words unbuilt and two questions no
answer settled; the acceptance found one gate its repair round's pre-run had not run (`check_hz` §1a, a Silence's hover line); and the controls proved each new check reds on the defect it names.

**Named apart, whose silence is their work** (JT §2): the push check, the two readings, the freeze and the hash guard.

## WHAT THE NEXT DECISION RECORD OWES

1. **The lane, declared** — A, B or C (`docs/ways-of-working.md`); **KJ ran Lane A** by its own reading: a tier replaces what the
   builder spends, every kit but seven moved and every recipe gained a combo — a change to how the game is shaped.
2. **What was decided, and what is out of scope** — the enemy half, built as the designer picked it. **Out of scope at KJ**: every
   figure outside the picks and the seven answers, and any re-take of a sim figure. **Still open, the designer's**: KJ's eleven
   rulings owed, items 9–11 put with their options; KI's item 1 (Escape's walk-away); the two look-list rows left NOT YET (FOUND AT KF, carried).
3. **What it was written from** — `RECORD_KJ.md` and the options page (`enemy-rework-options.html`, `picks_designer.json`) in KJ's
   work folder; `data/enemies.json` read whole; `Run.THEMES` and the composer; the code map `recon/hooks.md`; every fact about the
   code read on HEAD `16002ae` (THE RECORD's FACTS).
4. **The open questions, both branches decided** — items 2–8 of NEEDS A RULING; **the designer's**: item 1, the three hexes, and
   items 9–11, the questions no answer settled, each with its options.
5. **Not to get wrong**: **a tier is the `power` field** — a kind moved between tiers moves its cost, its count of moves and its
   band together, and `check_kj` §1 reds any one alone; **a support cast is found by its display name** — Healing Wave keeps its
   name; **a gate about the warband its batch left reads `Gate.warband_before_kj()`**, never the live data; **a status's clock ticks
   before its bearer acts: one meant to bind the next turn is laid for two, and Brand's 3 binds two**; **a companion's turn is its
   master's**; **the fixture's warband (`Gate.spawn`, 82 gates) holds two kinds under
   the Warband recipe, so it never meets Combined Arms**; **a brace spares a spell — a blow that is not physical**.
