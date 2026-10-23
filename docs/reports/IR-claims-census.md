> **KEPT AS IR's CENSUS OF RECORD (ID §0.6: a census a later batch will be priced against is kept). IR's report §4 — HX's 87 reference claims and IQ's two, recounted at HEAD: 87 stand. Nothing repaired.** Written by a read-only reader; its scratch paths are not in the repository.

# HX's stale reference claims, recounted at HEAD 11ef9fa (Batch IQ)

**Read-only.** Every verdict is checked against the committed HEAD (`11ef9fa`). The documents were read with `git show HEAD:` and the
five scripts the working tree is editing right now (battle, classes, map_screen, run_sim, run_state; uncommitted, presumably IR's)
were checked from HEAD snapshots. Nothing in the tree was edited.

**What HX audited.** HX's §1d census covered **only the two references**, `docs/instrument-rules.md` and `docs/combat-rules.md`, as
they stood at HW's HEAD (`d7c0a98`). It did not cover `CLAUDE.md` or `docs/ways-of-working.md`. The appendix (HX.md:639-747) has
**94 rows**: 74 in the instrument file and 20 in the combat file. Of those, 90 are mechanical claims and 4 are intent claims.
Three mechanical rows (IR71-73) were repaired at HX. **HX's "87" is the other 87 mechanical rows**, and HY's breakdown matches:
31 counts + 41 names + 12 files + 3 values. The 4 intent rows (IR02, IR23, IR28, IR34) are outside the 87. They are listed below,
marked "intent", and kept out of the totals.

**Method.** For each row I took the claim's exact words from HW's file and searched for them in HEAD's four rule files. The search
used unwrapped text with emphasis stripped (`cc/locate.py`). Then I read the lines around each hit for any amendment, and checked
the claim against the code again myself. Row ids number the appendix in order (IR01-74, CR01-20).

**Result in one line:** the claims' text was found in place, unchanged, for all 87 rows except IR06. **No claim has moved to
another file.** IR06 (IA §5) is repaired. **CR01 is also repaired, by HY §4**: its text is unchanged, but the tree now matches it.
No report has counted that repair.

## The table — HX's 87 mechanical rows and its 4 intent rows (IR71-73, repaired at HX, omitted)

| HX row (id · HW line) | kind | claim (short) | where it is today (HEAD 11ef9fa) | verdict | evidence |
|---|---|---|---|---|---|
| IR01 · 10 | file | A rule governing what the game may contain is in CLAUDE.md | instrument-rules.md:10 | STILL-FALSE | line-10 sentence unchanged; game rules about fight resolution live in `docs/combat-rules.md` (GR §2). Qualified 3 lines on (IR:13-16) exactly as at HW — HX counted it anyway; borderline |
| IR02 · 56–57 | intent | The sync ratio holds its own numerator, so a batch could meet its target with an unrelated c… | instrument-rules.md:56-57 | STILL-FALSE | intent; text unchanged. The sync-share target is retired (CLAUDE.md ceiling block, EE §1), so no target exists to meet |
| IR03 · 101 | count | `^<h2>.*</h2>$` counts 107 | instrument-rules.md:101 | STILL-FALSE | `grep -cE '^<h2>.*</h2>$' DoD-archive/changelog-archive.html` = 211 (CX's dated figure) |
| IR04 · 101 | count | The archive holds 108 entries | instrument-rules.md:101 | STILL-FALSE | cross-line `<h2>` count = 214; `check_dv.gd:432` pins 214 |
| IR05 · 175–176 | file | This file says elsewhere that the cut must not share a diff with anything | instrument-rules.md:175-176 | STILL-FALSE | no rule file states it (unwrapped sweep of CLAUDE.md, both references, ways-of-working: only this sentence); `check_fg.gd:23` repeats the pointer |
| IR06 · 234–237 | count | Five battle.gd sites spell the companion-excluding `heroes.filter` walk byte for byte | gone (reworded in place, instrument-rules.md:233-235) | REPAIRED (IA §5, ae4ee06) | now *More than one site … `check_dm` §1 prints the live count* (IR:233-235); 9 sites spell the walk at HEAD — true |
| IR07 · 266–267 | count | Two other `if Run.sim_run:` lines exist elsewhere in that file | instrument-rules.md:267-268 | STILL-FALSE | map_screen.gd (HEAD) holds 2 `if Run.sim_run:` lines in all (:1363, :4155), so ONE besides the guard, not two |
| IR08 · 267–268 | count | That file is about 2,000 lines | instrument-rules.md:268-269 | STILL-FALSE | `scripts/map_screen.gd` is 4,559 lines at HEAD |
| IR09 · 341–342 | file | docs/state.md does not restate the live counts; it points at baselines.json | instrument-rules.md:342-343 | STILL-FALSE | `docs/state.md:3135` (check_gj 1 failure) and `:3139` (check_cm_live 4 to 5) restate baselines rows |
| IR10 · 433–434 | count | The six equalities that stay are all in test_batch_cd | instrument-rules.md:434-435 | STILL-FALSE | seven pool-total equalities in `test_batch_cd.gd`: :422, 446, 481, 501, 508, 514, 517 |
| IR11 · 456–457 | count | test_batch_cd holds six such assertions and is one instrument | instrument-rules.md:457-458 | STILL-FALSE | same seven (see IR10) |
| IR12 · 486–487 | name | test_batch_bq §3/§4 reads `live.size() == 6`, with `live` from class_draft_pool() | instrument-rules.md:487-488 | STILL-FALSE | no `live.size() == 6` in `test_batch_bq.gd`; `live` (:204) feeds a membership check |
| IR13 · 520 | count | Two of those four collide with a spec draft pool | instrument-rules.md:521 | STILL-FALSE | 4 rune grants (Comet, Sacred Resolve, Resurrection, Mind Flay, all retired); THREE sit on SPEC_DRAFT_POOLS shelves (classes.gd:438, 443, 467) |
| IR14 · 521–523 | count | There are 95 asserted literals (EA's verifier read 32) | instrument-rules.md:522-524 | STILL-FALSE | dated EA figure in the present tense; HX's port read 156; the pin population has grown since (pin-manifest 1,728 → 1,897 pins HX→HEAD); not re-ported |
| IR15 · 528–530 | count | The tree holds 124 distinct asserted literals, 90 positive and 34 negative | instrument-rules.md:529-531 | STILL-FALSE | dated EB figure (124/90/34); HX's port read 158 (115/43); population grown since; not re-ported |
| IR16 · 530–531 | count | Unmasked, 73 positive groups become 45 and 30 negative become 25 | instrument-rules.md:531-532 | STILL-FALSE | dated EB figure (73→45, 30→25); not re-ported; population grown since |
| IR17 · 537–538 | name | Every assertion in this tree is wrapped in `ok(...)` | instrument-rules.md:538-539 | STILL-FALSE | `test_batch_bm.gd:57` `_check` (145 calls) and `test_run_harness.gd:104` `_check` (46 calls) |
| IR18 · 541 | count | A literal census reads the same 125 members either way | instrument-rules.md:542 | STILL-FALSE | dated EC figure (125); HX's port read 168; population grown since |
| IR19 · 555 | count | Six of the nine alternations have a legitimately absent member | instrument-rules.md:556 | STILL-FALSE | dated EC figure (6 of 9); HX's port read 7 alternations; not re-ported |
| IR20 · 556 | count | All ten conjunctions hold in full | instrument-rules.md:557 | STILL-FALSE | dated EC figure (ten); HX's port read 11; not re-ported |
| IR21 · 576 | count | There are four tracked documents | instrument-rules.md:577 | STILL-FALSE | SIX tracked documents: `check_ec.gd:52-57`, `build_pin_manifest.py` DOCS (6) |
| IR22 · 672 | count | needle verifier and literal-flip sweep track needles into the FOUR tracked documents | instrument-rules.md:673 | STILL-FALSE | six, as IR21 |
| IR23 · 679-680 | intent | the edited-source literal sweep takes seconds and is the only instrument that can see this | instrument-rules.md:680-681 | STILL-FALSE | intent; text unchanged. `check_ed` §1 re-resolves every manifest pin, comment-resident ones included (check_ed.gd:9-13) |
| IR24 · 683-684 | count | a chip tag is two or three characters | instrument-rules.md:684-685 | STILL-FALSE | STATUS_INFO (battle.gd:181) holds 6 one-character tags: burn F, sunder D, ward W, poison P, exposed E, loyalty L |
| IR25 · 793-794 | value | under the new threshold the fourth gain cannot lift the peak | instrument-rules.md:802-803 | STILL-FALSE | `RELEASE := 8` (test_batch_bi.gd:51), `FAITH_RELEASE := 8` (battle.gd:18883): the fourth gain lifts the peak to 4 |
| IR26 · 805-807 | name | [NP] the eight read `w.faith_peak == 5`, `m.faith_stacks == 4`, `1 + ELEVATION_STACKS_TEST` | instrument-rules.md:814-816 | STILL-FALSE | none of `w.faith_peak == 5`, `m.faith_stacks == 4`, `1 + ELEVATION_STACKS_TEST` in test_batch_bu.gd / test_batch_ce.gd |
| IR27 · 812-813 | value | at RELEASE = 3 two of the three now release | instrument-rules.md:821-822 | STILL-FALSE | `RELEASE := 8` (test_batch_ce.gd:80), not 3 |
| IR28 · 813-814 | intent | the release is a better discriminator than the old one | instrument-rules.md:822-823 | STILL-FALSE | intent; text unchanged. At 8 nobody in ce's probe releases |
| IR29 · 819 | name | a talent can grant an ability that lives in no pool | instrument-rules.md:828 | STILL-FALSE | talents.gd TREE (:84-255, 27 nodes) carries no `grant_ability`/`new_ability` payload |
| IR30 · 845-848 | count | the gates that walk the gate files are these ten | instrument-rules.md:854-857 | STILL-FALSE | list still ten; `check_fi` §5 walks every .gd under res:// (check_fi.gd:212) — eleven at least |
| IR31 · 849-850 | name | the real differences became named arguments: deterministic, items, run | instrument-rules.md:868-869 | STILL-FALSE | `gate_fixture.spawn` reads deterministic, items, run, lineage_cards, party, party_runes (gate_fixture.gd:73ff) |
| IR32 · 886-887 | name | [NP] check_da §3 was authored to catch exactly what test_batch_cp does | instrument-rules.md:905-906 | STILL-FALSE | `test_batch_cp.gd:694-695` `_corpus()` returns `Classes.ability_corpus()` — the hand walk is gone |
| IR33 · 908-910 | file | three game traps, including the shell/engine gotchas, stayed in CLAUDE.md under that title | instrument-rules.md:927-929 | STILL-FALSE | CLAUDE.md:1567 keeps TWO game traps; *the shell, the engine and the files* is an instrument-rules block (CLAUDE.md:163 row) |
| IR34 · 966 | intent | `throws=` is the only thing standing between this fault and a green report | instrument-rules.md:985 | STILL-FALSE | intent; text unchanged. run_battery.sh:274 prints NO VERDICT — INCOMPLETE; check_de.gd:275-277 asserts zero throws per log |
| IR35 · 993-994 | name | naming `Run` in a file compiled under --script is a parse error | instrument-rules.md:1012-1013 | STILL-FALSE | `check_ek.gd:691, 694` name `Run.ITEM_IDS` / `Run.ITEM_INFO` in live code of an `extends SceneTree` --script gate (check_ek.gd:31); baselines.json check_ek 47 checks |
| IR36 · 995 | name | every gate obeys this by fetching the node instead | instrument-rules.md:1014 | STILL-FALSE | as IR35: check_ek does not fetch the node |
| IR37 · 1009 | file | and relics.json by nobody | instrument-rules.md:1028 | STILL-FALSE | `Relics.save_path` static var since GJ (relics.gd:137); 35 files reference it (e.g. check_gj.gd:36) |
| IR38 · 1046 | file | events.json matches no simple json.dumps form | instrument-rules.md:1065 | STILL-FALSE | `data/events.json` == `json.dumps(obj, indent=4)` byte for byte (runes.json matches no form — that half holds) |
| IR39 · 1052 | count | sixteen of twenty sprite files are named nowhere in source | instrument-rules.md:1071 | STILL-FALSE | 18 of 20 sprite files named nowhere in scripts/ or scenes/; only Berserker_Portrait.png and Soldier_Idle.png are |
| IR40 · 1077-1078 | file | pre-CE VERIFIED blocks live in docs/changelog.html and its archive | instrument-rules.md:1096-1097 | STILL-FALSE | `docs/changelog.html` holds 0 VERIFIED blocks; all 19 are in DoD-archive/changelog-archive.html |
| IR41 · 1092 | name | check_cm_live.gd is the only thing that presses the defensive bar | instrument-rules.md:1111 | STILL-FALSE | check_fh §7 drives `_run_skill_check(false, "defensive")` (check_fh.gd:1836, 1851-1854) |
| IR42 · 1093-1094 | name | so `_run_skill_check`'s defensive path is exercised nowhere else | instrument-rules.md:1112-1113 | STILL-FALSE | as IR41 |
| IR43 · 1095 | name | and presses the bar by hand | instrument-rules.md:1114 | STILL-FALSE | headless: the bar never opens, so check_cm_live's press code (check_cm_live.gd:133-141) never runs — baselines.json's own check_cm_live note says so |
| IR44 · 1106-1107 | file | check_map_screen.tscn is the only thing that executes the lattice draw | instrument-rules.md:1125-1126 | STILL-FALSE | check_fh opens map.tscn on an active run (check_fh.gd:346 and four more); 37 targets name map.tscn/_draw_lattice |
| IR45 · 1110-1111 | name | autoloads (`Run`) do not resolve in a --script SceneTree | instrument-rules.md:1130-1131 | STILL-FALSE | as IR35 (check_ek resolves `Run` under --script) |
| IR46 · 1124 | name | with no redirect | instrument-rules.md:1144 | STILL-FALSE | `SAVE_PATH` is still a const, but `static var save_path := SAVE_PATH` (relics.gd:137) is the redirect gates use |
| IR47 · 1155 | name | a lane row is one fully-built hero measured against three unbuilt ones | instrument-rules.md:1175 | STILL-FALSE | no lanes since FX; run_sim.gd warns DOD_SIM_BUILDS is retired (:229-233) |
| IR48 · 1167-1168 | name | Battered Not Broken removes banked Break and is not booked | instrument-rules.md:1187-1188 | STILL-FALSE | `battered_ranks` declared (unit.gd:511) and read (battle.gd:10163), never written — the node is gone |
| IR49 · 1172-1173 | count | the harness's two standing rules live in `_check`/`_check_range`/`_go` | instrument-rules.md:1192-1193 | STILL-FALSE | test_run_harness.gd:14 — THREE standing rules (rule 3 lives in `_go`) |
| IR50 · 1197–98 | file | `CLAUDE.md` points at baselines.json rather than restating it | instrument-rules.md:1217-1218 | STILL-FALSE | CLAUDE.md:935 restates the harness's *live counts 22/382/8*; state.md:3135/3139 restate rows |
| IR51 · 1216–17 | name | `check_ez` §4's replacement asserts the loadout it builds really meets the condition | instrument-rules.md:1236-1237 | STILL-FALSE | check_ez §4's met and failing arms are gone since FN (check_ez.gd:482-490); payloads land with nothing drafted |
| IR52 · 1218 | count | `check_ez` §4 covers twenty-one payloads | instrument-rules.md:1238 | STILL-FALSE | §4's population is `_ez_ids()+_hf_ids()+_crest_ids()` = 60+15+4 = 79 (check_ez.gd:470) |
| IR53 · 1383–84 | name | That direct sweep misses `_companion_strike`, because its converting read is inside `_comp_d… | instrument-rules.md:1499-1500 | STILL-FALSE | `_companion_strike` (battle.gd:25579) holds the raw read (:25585) and `_bond_mult` itself (:25633) — a direct sweep finds it |
| IR54 · 1395 | count | `second_resource` holds five specs' currencies in one field | instrument-rules.md:1511 | STILL-FALSE | three currencies: Resonance, Mercy, Focus (battle.gd:1322, 1327, 1610) |
| IR55 · 1395–96 | name | Resonance and Faith branches read `second_resource` | instrument-rules.md:1511-1512 | STILL-FALSE | Faith is `faith_stacks` (unit.gd), not `second_resource` |
| IR56 · 1401–02 | file | A target that sets `Run.sim_run = false` writes `user://run_save.bin` | instrument-rules.md:1517-1518 | STILL-FALSE | harness processes write `user://run_save_harness.bin` (run_state.gd:235, `_init` :247-250) |
| IR57 · 1402–03 | count | Twenty-four of those targets delete it | instrument-rules.md:1518-1519 | STILL-FALSE | no target reaches the player's file now (run_state.gd `_init` redirect) |
| IR58 · 1407–10 | count | Of 80 candidates, the 24 named delete the save, 56 leave it identical, none overwrites it | instrument-rules.md:1523-1526 | STILL-FALSE | dated FH census; no target reaches the save now |
| IR59 · 1412 | name | Only `check_fh` protects the save end to end | instrument-rules.md:1528 | STILL-FALSE | check_fh is *A WATCH NOW, NOT A BACKUP* (check_fh.gd:126); the `_init` redirect protects every process |
| IR60 · 1412–14 | name | `check_ct` §2 backs the save up and restores it, with a passing arm | instrument-rules.md:1528-1530 | STILL-FALSE | check_ct *NO LONGER BACKS THE PLAYER'S SAVE UP* (check_ct.gd:159) |
| IR61 · 1414 | name | `check_ct` §3 then spawns a battle that destroys the save after the restore | instrument-rules.md:1530 | STILL-FALSE | no restore, and its battle writes the harness path |
| IR62 · 1419 | count | The number of save-deleting targets is 24 | instrument-rules.md:1535 | STILL-FALSE | dated FH figure; no target deletes the player's save now |
| IR63 · 1424–25 | name | `_ready()` points `save_path` at the harness file for non-player processes | instrument-rules.md:1540-1541 | STILL-FALSE | `_init()` does it (run_state.gd:247-250), not `_ready()` |
| IR64 · 1435–37 | name | `check_fh`'s backup is a file on disk, recovered on the next run, deleted after a restore | instrument-rules.md:1551-1553 | STILL-FALSE | the backup is a member `_save_backup` (check_fh.gd:79, 149, 160), compared only; no file, no recovery |
| IR65 · 1459–60 | name | `test_batch_ah` destroys the player's save and restores nothing | instrument-rules.md:1575-1576 | STILL-FALSE | `new_run` → `clear_save` removes `save_path`, the harness file under a harness (run_state.gd:4420-4428) |
| IR66 · 1465 | name | `check_ct` is the only file that both restores the save and ends with it absent | instrument-rules.md:1581 | STILL-FALSE | check_ct no longer restores (check_ct.gd:159) |
| IR67 · 1484–86 | name | A needle written as a named constant (`doc.contains(S7_OPEN)`) would not be recorded even if… | instrument-rules.md:1600-1602 | STILL-FALSE | build_pin_manifest.py:310 records `non-literal` pins (residency `runtime`, :342); pin-manifest.json holds 120 |
| IR68 · 1520 | name | So a printed count means the target reached its end | instrument-rules.md:1636 | STILL-FALSE | check_de prints count-shaped per-row lines mid-run (check_de.gd:298); run_battery.sh:253's grep would read them |
| IR69 · 1526 | count | Five of them print `NAME: 0 failures`; two are pure reports | instrument-rules.md:1642 | STILL-FALSE | four print `NAME: N failures` (cl_resolver, cm, cn, flow); check_map_screen prints `check_map_screen: OK` (check_map_screen.gd:197) |
| IR70 · 1527–28 | name | The list is not written twice, and `check_de` §2 stops the two drifting | instrument-rules.md:1643-1644 | STILL-FALSE | two copies: run_battery.sh:137 NO_COUNT and baselines.json's null rows; check_de reads no NO_COUNT; its §2 compares baselines with the logs |
| IR74 · 1581 | name | Both fixtures have a `runes` option | instrument-rules.md:1746 | STILL-FALSE | only suite_fixture has `runes` (suite_fixture.gd:119); gate_fixture seats runes through `party` / `party_runes` |
| CR01 · 14–15 | file | A rule about how a batch verifies itself is in `docs/instrument-rules.md` | combat-rules.md:14-15 (text unchanged) | REPAIRED (HY §4, 464bf14 — by the tree, text unchanged) | HX's only evidence was HG §1b and HG §2a standing in CLAUDE.md; HY §4 moved both byte for byte (IR:1889, IR:1906; CLAUDE.md keeps only their index rows :186-187); check_hx.gd:229 `WRITTEN_BACK := {}` — none left |
| CR02 · 19 | file | Every block below is byte-identical to what stood in `CLAUDE.md` | combat-rules.md:19 | STILL-FALSE | edited after the split by HU, HY, HZ, IA, IC, ID, II, IK, IL, IM (`git log 379b6d2.. -- docs/combat-rules.md`); 371 → 468 lines |
| CR03 · 40–41 | name | The clamped call sites are Battle Shout, Stabilize, Eye of the Storm, Blood Debt, Reckless A… | combat-rules.md:40-41 | STILL-FALSE | `_apply_elem_weak` reads `status_power` before writing (battle.gd:15352-15356, *CP §0's clamp*); Shieldwall writes `maxi(status_power, pct)` (:23733) |
| CR04 · 48 | count | Six more banks decrement through the same door | combat-rules.md:48 | STILL-FALSE | REASON CHANGED: HX said a 7th (aper_rhythm); since IG §1 four of the six named (feint_guard :18122, berserk :18139, deadfall :26440, loyalty :17074) and aper_rhythm are display chips — only mirror (:15755) and arrows (:15778) still go through `update_status` |
| CR05 · 85 | name | Every other caller lays the status without `force` | combat-rules.md:85 | STILL-FALSE | three callers forward `force`: `_hold_freeze` (battle.gd:14419), Frostbind's mate (:14954), `_spring_trap` (:26466) |
| CR06 · 93 | name | Spread of Madness filters `not e.is_boss or e.broken` itself | combat-rules.md:93 | STILL-FALSE | Spread of Madness leaps Ruin via `_gain_ruin`, filtering `not e.dead and e != target` (battle.gd:18551); the quoted filter is nowhere in battle.gd |
| CR07 · 103–104 | count | `_enemy_turn` has eight returns | combat-rules.md:103-104 | STILL-FALSE | `_enemy_turn` (battle.gd:8545) has 7 `return` statements |
| CR08 · 127–128 | value | Its first line is `randf_range(0.9, 1.1)`, with a crit rolling inside it | combat-rules.md:127-128 | STILL-FALSE | the crit is rolled at battle.gd:10565, above the strike's `randf_range` damage line (:10610) |
| CR09 · 149 | name | `_book_self_cost` reaches the recap's ledger and nothing else | combat-rules.md:161 | STILL-FALSE | `_book_self_cost` (battle.gd:30940) calls `_bank_party_losses()` (:30954), which writes the save |
| CR10 · 181–182 | count | The total is assembled over twelve statements carrying thirteen terms | combat-rules.md:270-271 | STILL-FALSE | 13 statements, 14 terms (battle.gd:10508-10564; HB's `crit_pity` :10564) |
| CR11 · 204 | count | (Again) the constant prices a total over twelve statements, thirteen terms | combat-rules.md:293 | STILL-FALSE | as CR10 |
| CR12 · 235 | name | Those sites spend it as a Burn magnitude | combat-rules.md:324 | STILL-FALSE | the value is Burn's `power` (maxed, unit.gd add_status) and nothing reads it as a magnitude; and five sites now, not three (IE §3b added two: battle.gd:13484, 20393) |
| CR13 · 253–254 | name | A multi-hit ability is repeated strikes on one target | combat-rules.md:342-343 | STILL-FALSE | Seeking Missiles sends extra missiles at other enemies (battle.gd:9738ff, HF) |
| CR14 · 293–294 | name | Walk-not-grep is the second standing rule below, which DJ earned | combat-rules.md:382-383 | STILL-FALSE | the rule DJ earned (DJ §3) is in instrument-rules.md:1203; the second rule below this DI block is DK §1 (CR:430) |
| CR15 · 304 | name | The line-number rule is this block's neighbouring rule | combat-rules.md:401 | STILL-FALSE | DJ §3 is in instrument-rules.md:1203; this block's neighbours are DI (CR:358) and DK §1 (CR:430) |
| CR16 · 307–308 | name | Every `not h.is_companion` filter in `battle.gd` filters an array that cannot hold one | combat-rules.md:404-405 | STILL-FALSE | Rally's pool is `_hero_side()` filtered `not a.is_companion` (battle.gd:4599, 4615) — that filter removes companions |
| CR17 · 325–329 | count | Seven carry "hero" text: Rallying Cry, War Stomp, Rallying Shout, Devoutness, Last Hope, Cle… | combat-rules.md:422-426 | STILL-FALSE | Tank and Spank, Rallying Cry and Cleansing Waters are absent from talents.gd (FX); 4 of 7 texts remain |
| CR18 · 329–330 | name | The reason is recorded beside each one in the source | combat-rules.md:426-427 | STILL-FALSE | no reason beside Rallying Cry or Cleansing Waters — the nodes are gone |
| CR19 · 338–339 | name | `wd_tank_spank` applies `empower` to a companion cleanly: status, chip, tooltip | combat-rules.md:435-436 | STILL-FALSE | `wd_tank_spank` absent from talents.gd; `tank_spank_ranks` declared (unit.gd:493), read (battle.gd:12941), never written; check_hx.gd:267 names it a live claim in a dead name |
| CR20 · 347–348 | name | Every `is_companion` filter walks `heroes` and removes nothing | combat-rules.md:444-445 | STILL-FALSE | as CR16 (battle.gd:4615) |

## Totals

| population | STILL-FALSE | REPAIRED | MOVED |
|---|---|---|---|
| **HX's 87 mechanical rows** | **85** | **2**: IR06 (IA §5, ae4ee06); CR01 (HY §4, 464bf14, by the tree) | **0** |
| HX's 4 intent rows (outside the 87) | 4 (IR02, IR23, IR28, IR34) | 0 | 0 |
| IQ's two `CLAUDE.md` claims | 2 | 0 | 0 |

**Claims that stand: 85 + 2 = 87, not 86 + 2 = 88.** If you count HX's four intent rows too, 91 stand.

### The row that differs from 88

- **CR01**, `docs/combat-rules.md:14-15`: *A rule about how a batch verifies itself is in `docs/instrument-rules.md`, whatever it is
  about.* HX's only evidence that this was false was the two HG blocks standing in `CLAUDE.md` (HG §1b at CLAUDE.md:991, HG §2a at
  :1008) and in neither reference.
  - **HY §4 moved both blocks byte for byte** into `docs/instrument-rules.md` (now :1889 and :1906; `git log -S` gives 464bf14).
    `CLAUDE.md` keeps only their index rows (:186-187).
  - `check_hx.gd:226-229` says *HG–HJ's two … MOVED … at HY §4 … none is left* and holds `WRITTEN_BACK := {}`.
  - The sentence was never edited. The tree changed underneath it. **HY, HZ and IA all missed this**: IA §5 says *none was
    repaired at HY or HZ*, and `docs/state.md`'s "86" inherits that.
  - Caveat: this rests on HX's own evidence standard. No other `CLAUDE.md` block is sorted as an instrument rule written back.
- IR06 is the IA §5 repair that `docs/state.md` already counts. It is not a new difference.

## IQ's two, re-verified (both STILL-FALSE)

1. **`CLAUDE.md:1975`** (in *THE STARTER RUNG IS A META-PROGRESSION GATE…*, EN §3) says *clearing rung 1 is the only thing in the
   game that opens tier 1 of the talent tree.* At HEAD:
   - `battle.gd:29121` calls `Profile.note_end_boss(Run.difficulty_rung())`, and `profile.gd:390-395` sets `talent_tier` to the rung
     beaten (it only ever raises it).
   - `Talents.tiers_open` reads `TIERS_OPEN [0,1,2,3]`, and `tier_open(tier, d)` is `tier <= tiers_open(d)` (talents.gd:291-296). So
     beating the end boss on rung 2 or 3 opens tier 1 too.
   - `spend_gate_met` returns true for tier ≤ 1 (talents.gd:328-330).
   - The draft offers all three rungs with no lock (`draft_screen.gd:147-173`).
2. **`CLAUDE.md:1799-1800`** (in *A RELIC SETS UP THE RUN…*) says *swept over all 25 read sites of `relic_add` / `relic_dict`.* HEAD
   has **26 call sites**, definitions excluded: battle.gd 12, run_state.gd 9, shop_screen.gd 1, run_sim.gd 4. **22 are in the game
   without the sim.** The block's own list names RunSim's `_price` and `on_battle_end`, so it means to count the sim, and 26 ≠ 25.
   Neither number matches. IQ's reading holds.

## Notes a repair batch should have (not repairs)

- **CR04's reason changed.**
  - HX said there is a 7th bank (`aper_rhythm`). Since IG §1 (29407e8), four of the six named banks are display chips that never
    touch `update_status`: `feint_guard`, `berserk`, `deadfall` and `loyalty`. `aper_rhythm` is a display chip too.
  - Only `mirror` and `arrows` still decrement through the door.
  - So the fix is not to change "six" to "seven". Re-derive the population.
- **CR12's count has grown.** Five sites now spend `CRIT_CHANCE + crit_bonus` as Burn's power (IE §3b added :13484 and :20393).
  Nothing reads that power.
- **Eleven rows are a batch's measured figure kept in the present tense**: IR03, IR04, IR14–IR20, IR58 and IR62. The figures are
  CX's, EA's, EB's, EC's and FH's.
  - Under HY §6's rule (*a live count … points at its instrument, or carries its batch*), the right repair may be to put them in the
    past tense rather than update the number.
  - I did not re-port the literal censuses for IR14-20. The pin population grew from 1,728 to 1,897 pins between HX and HEAD, so
    none of those figures can be right at HEAD.
- **IR01 is borderline.** It is qualified three lines later (IR:13-16), and was already at HW. HX counted it anyway, and I kept HX's
  call.
- **Twins outside the references** (not part of HX's population):
  - `CLAUDE.md:864` holds a scoped version of CR16's sentence (*… on a `heroes` walk*), which is true.
  - `baselines.json`'s `check_cm_live` note repeats IR41 (*the only thing pressing the defensive bar*).
  - `check_fg.gd:23` repeats IR05.
  - HX's 14 stale comments outside the references were not recounted.
- **Working files:**
  - `scratchpad/cc/rows.json`: the appendix parsed into rows.
  - `cc/locate.json`: where each claim's words were found.
  - `cc/verify_head.py`: the code re-checks run against the HEAD snapshots in `cc/head/`.
  - `cc/table.json`: the verdict for each row.
