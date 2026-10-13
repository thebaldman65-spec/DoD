# BATCH ID — ONE SURFACE, AND THE GLYPHS

**On `class-merge`, from `db68ab7` (IC). IMPLEMENT ONLY.** **§0: IC's five rulings are answered** — the first built here (§3),
the vow confirmed as it is with what to watch recorded, the recoil floor kept with its meaning written down, the silenced hit's
mark and stillness confirmed with the shake's reason generalised, and ABILITIES ruled to hold both kinds of card. **§1: the pick
overlay is retired** — its census re-read at the deletion — **and every pick a hero is owed is a section of his own screen**:
ABILITIES holds the draft's offer and the zone boss's side by side, each labelled with its door; UPGRADES names the card and what
the upgrade does to it; RUNES is unchanged; one Confirm commits all four, the cap counted across the two ability offers. **§1b
measured the longest screen before the sections were written.** **§2: the words** — a title that never misnames its screen, an
owed line that is one sentence, a counter to four in words. **§3: ↑ names an upgrade on all four surfaces, the class passive's chip
is deleted, a rare relic says RARE, and every ◆ left in the game is a pick's badge** — the sweep kept. **§4: three false lines made
true** — the vow's chip, Mirrorbound's card, the Kit button. **The verification**: one recon of HEAD's battery against all of ID's code, predicted first (it missed three reds, and the literal sweep run after named all three); `check_gp`'s −16 attributed to the deleted chip's dice by an ok() trace and a stub; thirty controls, each in its own clone; the 59 document readers on the final documents; then the pre-pass and the acceptance side by side, each `check_de` 593 / 0 / 0 as predicted — 144 targets, 80 min 57 s.

**VERDICT: GREEN.** The fold, the words, the glyphs and the three false lines are built (§1–§4), none dropped; every re-pointed gate holds its row but `check_gp`, moved by the deleted chip's dice and attributed; thirty controls bite; the pre-pass and the acceptance run both closed `check_de` 593 / 0 / 0 as predicted, the tree byte-identical and the player's files untouched. Four rulings are owed and none blocks.

## NEEDS A RULING

1. **✦ CARRIES FOUR MEANINGS, AND IC's RULE SAYS ONE (§3, FOUND AT ID).** IC §0.4 recorded *✦ counts what is held and unworn*. In
   the game ✦ also marks a WORN rune or a CARRIED card on three panels (the loadout panel's carried rows, the crest bag's worn
   crest rune, the hero sheet's worn rune state), a rune's chip in battle (`RUNE_CHIP_TAG`), and the Empower toggle's button. None
   of them is a pick, so ◆'s rule holds; whether ✦ keeps its other meanings, takes its one, or the worn marks take letters is the
   designer's. The sweep that found them is §3's, kept.
2. **THE CLASS PASSIVE's CHIP WAS A STATUS, AND DELETING IT MOVED THE HIEROPHANT's SANCTITY (§3c).** It was laid through
   `add_status`, which books a Sanctity event and floats a label for every status that lands — so every battle opened with four
   Sanctity events and four dice spent on a chip, before ID. The deletion (ruled) takes both away: a Hierophant's steps arrive four
   events later each battle, and every seeded die moved (attributed in §7). **The engine chips (★) are laid the same way and still
   book**, one per engine a hero holds. Count a display chip as a status landing (keep the engine chips' events, the class chip's
   gone), or rule that a chip is not a status (lay the engine chips as the rune chips are drawn, and the Sanctity rate is owed a
   re-measure)?
3. **AN OFFER THAT COMES BACK EMPTY STILL STRANDS ITS PICK (§1a).** A zone boss's offer every card of which is already owned, or an
   upgrade offer with nothing left, stays owed with nothing to press — the overlay did the same (its *Not yet* was the only button),
   so ID keeps it, and the screen now says so (*nothing to take now — the pick stays owed*). FM §3 spent the rune cache's in the
   same shape (*Let it go*). Spend it, or keep it owed?
4. **THE TITLE FOR AN UPGRADE AND A RUNE TOGETHER (§2).** The rule — *THE DRAFT whenever an ability is on it, THE CACHE for a rune
   alone* — leaves two screens unnamed: an upgrade alone reads **THE UPGRADE** and an upgrade with a rune **THE UPGRADE AND THE
   CACHE**, each naming exactly what is on it (`check_id` §2 walks all fifteen combinations). Confirm, or name them.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §7: IC's push hash is `git ls-remote origin class-merge` | **Held**: `db68ab75…` on the remote and at local HEAD, read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | §7: IC's backup `../save-backups/IC-20261012-171924`; the four player files byte-identical since before HW; `run_save.bin` last written 2026-10-08 09:23 | **Held**: backed up to `../save-backups/ID-20261012-213521`, all four byte-identical to IC's by md5; `run_save.bin` 42,200 B last written 2026-10-08 09:23. **Re-read at the close**: all four byte-identical to the backup (§7h). |
| 3 | The header: six of IC's premises recorded wrong (13, 11, 5, 8, 20, 14) | **Held**, as IC's report states them |
| 4 | §0.1: ◆ marks seven things and one is a waiting decision | **Held**: the four pick badges' one meaning, and six others — the battle button, the sheet chip, the Blacksmith's offer, the class passive's chip, the relic shelf's *◆ RARE*, the picker's *Name ◆* |
| 5 | §0.1: report where a class passive is readable outside its chip | **On the hero sheet** (*Class: <name> — <text>*, `party_screen`) **and the class-selection card** (*Class Passive — <name>: …*); **not in the kit preview**. The sheet is one of the brief's two homes, so the chip is deleted (§3c) |
| 6 | §0.1: report what the picker's row fits | **The word fits**: the widest rare row, *[ON]  Martyr's Knucklebone  RARE*, is 262 px of the 305-px button at its default size; no other mark is needed |
| 7 | §0.5: one hero can owe four picks at once; report the most a hero can owe | **Held, and four is the screen's ceiling, not the queue's**: one screen holds the head of each of the four kinds (`Run.PICK_KINDS`), so its counter counts to four. A hero can OWE more — three zone-boss picks and three upgrades a run at most (three zone bosses, three mini-bosses), a draft per elite and per drafting event, a cache per elite looted and per bargain — and each further one of a kind reopens his screen after the Confirm |
| 8 | §0.6: IA counted 43 and IC re-derived 46 / 55 | **Held** (IC §2); the rule is written (§0.6) |
| 9 | §1: the overlay's whole census is the boss's ability and the upgrade (IC premise 4); confirm it again at the deletion | **Held at the deletion**: `_open_pick_overlay` routed a draft and a rune to the hero's screen and drew its three-choice overlay for `ability` and `upgrade` alone; the kinds a pick can be are four (`Run.PICK_KINDS`); nothing outside `map_screen.gd` opened it but gates (§1a) |
| 10 | §1c: the overlay going, `Gate.pick_choices` loses its only caller | **False**: the bench step's overlay (z 64) still marks its choices with `_pick_button`'s `choice` meta, and `Gate.answer_hero_draft` (and `check_fh`) read them through `pick_choices` |
| 11 | §1c: the walkers that pressed `pick_choices[0]` — `check_gj`, `check_hk`, `check_gp`, `check_gv`, `check_fh` — and `check_fe` | **Held, and the population is larger**: **eighteen gates and suites read the overlay** — seven of the brief's eight (`check_hz`, its eighth, held no overlay arm: premise 13) and eleven it did not name: `check_fd`, `check_gs`, `check_he`, `check_hl`, `check_ho`, `check_ib`, `check_ic`, `check_map_screen`, `test_batch_ah_battle`, `test_batch_bo` and `test_batch_bx`; each is in §1a's table, and each was re-pointed to the question it asked |
| 12 | §1c: `check_fm` counts the screen's buttons exactly and gains two sections' worth | **Half**: it counts a rune-alone screen's buttons exactly (`c2.size() + 3`), which the fold does not change; it opened the cache through the overlay's door and was re-pointed at `_open_hero_draft` |
| 13 | §1c: `check_hz`'s longest-and-emptiest arms are the overlay's | **False**: `check_hz` holds no overlay arm — its §1b drives the kit preview from the hero's screen; the overlay's longest and emptiest were `check_fm` §3's and `check_fe` §2d's (IB §6a), both re-pointed |
| 14 | §1b: the longest screen is one hero owing four at the cap with a bench step | **Held, measured**: four columns, 1,220 px of 1,280; every panel inside the screen and above the Confirm (§1b) |
| 15 | §0.5 / §2: a draft is labelled *from the elite* | **Half**: two events grant a draft too (the `ability_draft` verb), so the label reads a recorded door (`Run.pick_source`) — *from the elite*, *from an event*, or both doors where a pick predates the record |
| 16 | §2: ABILITIES, RUNES and UPGRADES are the house words | **Held**: *ABILITY UPGRADE* on the victory card (and the retired overlay's heading), *Ability upgrades* on the map corner's tooltip, *Three ability upgrades on the counter* on the Blacksmith's node |
| 17 | §3: IC swept ↑ and found it drawn nowhere | **Held at IC**; drawn at ID on the four upgrade surfaces and nowhere else (§3a) |
| 18 | §4: the vow has a chip | **Half**: it had one only for a Cleric carrying Consecrated Ground (HY's ruling 3); widened to everything the vow silences that he holds |
| 19 | §4: Mirrorbound says *a quarter of the damage you deal* while billing 1 for no damage | **Held, and it was false two more ways**: the bargain stamps every unit on both sides, and only an attack that reaches the strike loop recoils (a single-target miss pays nothing; a `special` never recoils) |
| 20 | §4: the Kit button runs past the card | **Held, measured**: x 304–344 against the card's right edge at 308 (IA's reading); *Kit 10/10* needs 51 px and the rune row leaves 8 |
| 21 | §6: IC closed at `CLAUDE.md` 445.51 KiB (64.49 under, 8.0 at the record) and `docs/state.md` 338.75 KiB (41.25 under, 7.2–7.6) | **Held**: 456,207 B and 346,878 B at HEAD |
| 22 | §6: the claims stand at 86 | **Held** |
| 23 | §6: nothing has been played for seven batches | **Held**: HW through IC all ran on files last written 2026-10-08 09:23; **ID makes eight** |
| 24 | §7: IC read 143 in 80 min 27 s | **Held** (IC §6f) |
| 25 | §0.7 / §7: nothing in this batch is in the damage path | **False, by one deletion**: the class passive's chip was a status, so it booked a Sanctity event and floated a label (one `randf_range`) on every hero at every spawn — its deletion takes four events and four dice from every battle's opening (ruling 2, §7) |
| 26 | §5: `app_userdata` 516 folders, 166,140 KiB; spent prefixes 501, 160,412 KiB; IC's thirteen 5,192 KiB | **Held**: 516 folders before ID's first copy (526 now, with ID's ten); the spent prefixes 501 folders and 160,412 KiB, unchanged; IC's thirteen read **5,196 KiB**, four more than IC wrote — and no file in any of them is newer than ID's start, so the four are not ID's (§5) |

## §0 — IC's FIVE RULINGS, ANSWERED

- **§0.1 — MOVE THEM ALL. BUILT (§3).** ↑ on the three upgrade surfaces, and ↑ *names an upgrade wherever one appears* — the
  Blacksmith's offer is not a holding; the class passive's chip measured (premise 5) and deleted; RARE in words on the shelf and
  the picker (the picker's row fits it, premise 6). Asserted: every ◆ in the game's code is a pick's badge (`check_id` §3a).
- **§0.2 — THE VOW STAYS AS IT IS. RECORDED.** The trade and the asymmetry are written where a later batch meets them
  (`docs/state.md`'s watch list carries *the vow improves as the run goes on*, with its unbuilt lever — a cost that scales). The
  Occultist's trap is §4's: the vow's chip names his draught and Suffering's heal. Nothing re-priced.
- **§0.3 — KEEP THE FLOOR. RECORDED, AND §4 READ THE CARD.** *The floor is the bargain's, not the blow's — it bills for taking the
  action, not for landing it* is written into `docs/combat-rules.md`'s frame block, beside the reason no exception list is written;
  Mirrorbound's card said the opposite and says the floor now (§4).
- **§0.4 — BOTH CONFIRMED, THE SHAKE's REASON RECORDED** in the same block: *the shake is damage's; a blow that lands no damage does
  not shake, even a crit*. No code moved.
- **§0.5 — ABILITIES HOLDS BOTH. BUILT (§1), AND THE COUNTER COUNTS TO FOUR (§2)**; four is the screen's ceiling (premise 7).
- **§0.6 — A CENSUS A LATER BATCH WILL BE PRICED AGAINST IS KEPT. RECORDED** in `docs/instrument-rules.md` with its row in
  `CLAUDE.md`'s index; ID's two are §1's census at the deletion (§1a) and §3's sweep (§3a), each with its rule, command and output.
- **§0.7 — THE ORDER**: §1 and §2 together, then §3, then §4 — all four built; none dropped.

## §1 — THE FOLD: ONE SCREEN, AND THE PICK OVERLAY RETIRES

### §1a — THE CENSUS AT THE DELETION, AND THE SECTIONS

**The census, re-read before the deletion** (§0.6's rule: kept here). *Rule*: every caller of `_open_pick_overlay`, every
binding to it, every source needle naming it or its words, in the game's scripts and every gate and suite, and what it drew for
each kind of pick. *Commands*: `grep -rn '_open_pick_overlay\|pick_choices\|_pick_ability\|_pick_upgrade\|_finish_take\|_open_drop_overlay' --include='*.gd' .`; and
the literal sweep (`litsweep_id.py`, every gate literal ≥ 4 characters present in HEAD's game scripts and gone from ID's).
*Output*: in the game, the overlay was opened by the card's CHOOSE and by the arrival walk, routed a draft and a rune to the hero's
screen (since IB §2), and drew its three choices for `ability` and `upgrade` and nothing else — **IC's premise 4 held**. Its
readers: eighteen, and each was re-pointed to the question it asked rather than deleted.

| Reader | What it read of the overlay | Re-pointed to |
|---|---|---|
| `check_gj`, `check_hk`, `check_gp`, `check_gv` (and its §2c), `check_fh` | **the road walkers**: a boss's or a mini-boss's pick answered with `pick_choices[0]` on the overlay at z 60, reached by the arrival or the card's CHOOSE (`_open_pick_overlay`'s binding) | the hero's own screen, its boss and upgrade sections answered by `Gate.answer_hero_draft`; the CHOOSE found by `_open_hero_draft`'s binding; a screen that cannot confirm recorded and its picks cleared (`Gate.clear_picks`). `check_fh` keeps its own draft half, to read each card's tag line, and calls `Gate.answer_boss_and_upgrade` for the rest |
| `check_fe` | §2: two source needles in the overlay's held-back loop (`var ab_live: Array = Run.ability_choice(member)`, `for pool_name in ab_live:`); §2d: the overlay's boss offer with nothing to take (`_open_pick_overlay(2)`, *Not yet*), its buttons read by `_button_labels` | §2: the column builder's one offer line, which draws the boss's offer through the same door; §2d: the hero's screen's boss column with nothing to take, the Confirm reading *Nothing to choose yet* and the pick still owed; `_button_labels` deleted with its only use |
| `check_fm` | §3: the cache opened through `_open_pick_overlay`, which routed it to the hero's screen | `_open_hero_draft`, the same screen, the same count |
| `check_fd` | §1: a cache answered through the overlay's door | `_open_hero_draft` |
| `check_gs` | §4: a core rune's offer surface opened through the overlay's door | `_open_hero_draft` |
| `check_he` | §4: the zone boss's held-back line on the overlay; §6: a cache through its door | §4: the hero's screen's boss column, the same card, the same words; §6: `_open_hero_draft` |
| `check_hl`, `check_ho` | the CHOOSE found by `_open_pick_overlay`'s binding | by `_open_hero_draft`'s |
| `check_ib` | §1b–§1d: the boss's and the upgrade's overlay (*NEW ABILITY*, *ABILITY UPGRADE*, *Not yet*); §1g: the CHOOSE's binding; the header and the census keys | the sections, told apart by the metas and bindings the game sets (the draft's Decline, the boss's offer column, the UPGRADES panel, the rune's binding) and never by words; the screen's Later; `_open_hero_draft`'s binding; the arrival order asserted on what each screen holds (`3:draft`, `0:upgrade`, `1:boss`, `2:rune`) |
| `check_ic` | §3a: an upgrade dismissed on the overlay's *Not yet*; the CHOOSE's binding | the screen's Later (`_close_hero_draft`); `_open_hero_draft`'s binding |
| `check_map_screen` | case 3: the overlay's node count for an upgrade owed | the hero's screen's |
| `test_batch_ah_battle` | the overlay's *NEW ABILITY* heading after the CHOOSE | the boss column's *from the zone boss* |
| `test_batch_bo` | three source needles: the boss pick's bench line, `func _open_pick_overlay(` counted once, and the routing line | the boss's bench at the screen (`_open_drop_overlay.bind(idx, "draft" if is_draft else "ability", …)`), the overlay ABSENT, the CHOOSE's binding |
| `test_batch_bx` | two source needles from the deleted routing (`if kind == "draft" or kind == "rune":` … and `if not has_card and not has_rune:`) | the CHOOSE's binding and the screen's own four-way guard |

**Found by the recon, not by the grep**: `test_batch_bx`'s two needles and `test_batch_bo`'s third name no function; the literal sweep
listed them, and the recon's prediction, written off a function-name grep, had them green.

**The sections** (`map_screen._open_hero_draft`): one column an offer, left to right in the order the Confirm commits them.

- **ABILITIES** — the draft's offer (BX's column: its cards, tag lines, descriptions and computed blocks, what it holds back and
  why, its bench step, Decline) **and the zone boss's offer**, drawn through the same builder (`_offer_card`), each column headed
  by its door: *from the elite* or *from an event* (`Run.pick_source`, the source kept with the pick's serial by
  `Run.note_pick_earned`; *from an elite or an event* where the record cannot say) and *from the zone boss*. The section's head and
  its slot ledger span both. The boss's offer has no Decline — a zone-boss award always pays (EA §1).
- **UPGRADES** — the mini-boss's offer (`Run.upgrade_choice`, FE §2's door), each choice named *card: upgrade*, its sentence
  (`Run.upgrade_desc`) and **what it does to that card** (`Run.upgrade_preview`: the card's computed block with every upgrade he
  already holds on it, then with this one, each moved figure *old → new* — *Damage: 26% → 39%*, *Cooldown: 2 turns → none*;
  nothing for Piercing or Certain, whose figures the block does not print). **That is what the section must show** (the brief's
  question): which card, what the upgrade does, and what it does to the card.
- **RUNES** — unchanged.
- **One Confirm commits all four** (`_confirm_hero_draft`), each through the door it always used: `Run.take_draft_ability` /
  `Run.decline_draft`, `_pick_ability`, `_pick_upgrade`, `_take_rune_pick` / `_spend_rune_pick` — the two that the overlay
  committed with now return a refusal string, as `take_draft_ability` does, and no longer redraw the map themselves.
- **The cap across two offers** (`_bench_needed`): the draft's card takes a free slot first, the boss's then needs a bench if none
  is left, both ask one at the cap; a card one offer benches is not in the other's bench step (`_open_drop_overlay`'s `exclude`);
  a card in both offers is drawn in the second dead (*— chosen from the elite*). Each bench is read before anything commits.
- **A section he cannot answer now does not hold the Confirm**: a boss offer whose every card waits on an engine says so in the
  overlay's own words (*The offer holds 3 more that wait on … being equipped. Equip it and they return.*) and *nothing to take now —
  the pick stays owed*; alone, the Confirm reads *Nothing to choose yet*. An offer with nothing left at all strands its pick, as the
  overlay did (ruling 3).
- **Later leaves every pick on the screen owed**; the CHOOSE reopens it; the arrival walk opens the screen for a hero's oldest pick
  and dismisses all of his picks with it (`_arrival_dismissed`).

Driven (`check_id` §1a): each kind alone opens the hero's screen with its section and no other overlay, Later keeps it, CHOOSE
reopens it; the three doors' labels; four owed — one ABILITIES section with both offers, the boss's cards with their computed
blocks; the UPGRADES section's names, sentences and figures; one Confirm at the cap with both benches; the cap across offers at
one free slot and none; a held-back offer; a card in both offers.

### §1b — THE LONGEST SCREEN, MEASURED BEFORE THE SECTIONS WERE WRITTEN

**Before**: HEAD's renderers, every card each can draw, on a probe (`probes/measure_1b.gd`): a draft column's longest three cards
run 763–896 px and a boss triple 358–763 px against the column's 388-px scroller — so a column already scrolled at three cards,
and two offers stacked in one column would have been ~1,700 px in 388. **So ABILITIES is one column an offer, side by side under one
head**, and the widest screen is four columns. **After** (`check_id` §1b, the Cleric at the cap, both cards staged so both bench
steps draw): every case inside the screen and above the Confirm, the lowest panel ending at y 640 with the Confirm at 652. Each column's
text sits in a 388-px scroller; a column's text height is what it holds, so the bar shows where it outgrows that.

| Owed (one hero, the Cleric) | Width (of 1,280) | ABILITIES' columns | UPGRADES | RUNES |
|---|---|---|---|---|
| one: an upgrade | 296 | — | 215 | — |
| one: the draft | 296 | 535 | — | — |
| two: the draft and the boss | 604 | 554 · 535 | — | — |
| three: + the upgrade | 912 | 630 · 535 | 215 | — |
| four: + the rune | 1,220 | 573 · 535 | 215 | 351 |
| one at the cap, its bench | 296 | 554 | — | — |
| two at the cap, both benches | 604 | 592 · 535 | — | — |
| three at the cap, both benches | 912 | 573 · 535 | 215 | — |
| **four at the cap, both benches** | **1,220** | **611 · 535** | **215** | **351** |

Each figure is a column's text height in px against its 388-px scroller (`check_id` §1b prints them). **Four kinds is three
sections, because the draft and the boss share ABILITIES.** The text heights follow the cards each case draws (the gate seeds
once and walks the cases in order, so no two rows hold the same cards); the widths and the bottom edge do not move.

**IT SCROLLS — GT §1's RULE**: every column's text in its own bounded scroller, Godot's bar drawn exactly when its content outgrows
it (asserted for every scroller of every case), the Confirm and Later outside every scroller. **One panel outgrew what it declared**:
the draft's offer with its bench step and Decline under the section's head measured 544 against the panel's 540, so the panels
declare 548 (`DRAFT_COL_H`); the lowest now ends at y 640, the Confirm at 652.

### §1c — THE WALKERS: ONE HELPER, GROWN

`Gate.answer_hero_draft` answers every section by binding — the draft's first card (or Decline) and its bench, **the boss's first
card and its bench** (`_stage_boss`; `_open_drop_overlay` bound with `"ability"`), **the first upgrade** (`_stage_upgrade`), the
rune — then the Confirm. The boss-and-upgrade step is its own helper (`Gate.answer_boss_and_upgrade`), so `check_fh`, which keeps
its own draft half to read each card's tag line, calls it rather than writing a second. A screen a walker cannot confirm, or a
CHOOSE that opens nothing, is recorded and its picks cleared through one helper (`Gate.clear_picks`), as the overlay's *no live
choice* branch did in each walker. **The census, by shape** (`report` prints it beside every walker's verdict): `check_id` §1c, the longest and the emptiest by design — 4 screens: *draft + boss + upgrade + rune* 2, *rune* 1, *boss* 1; *at the cap, a card benched* 2, *at the cap, both offers benched* 1, *an empty cache let go* 1, *NOT CONFIRMED* 1 (the boss offer held back whole) — and §2 met all fifteen combinations once each. The roads: `check_gp` 100 screens (*draft* 36, *draft + rune* 16, *upgrade* 21, *boss* 24, *upgrade + rune* 3; *at the cap, a card benched* 19), `check_gv` 186 (*draft* 60, *draft + rune* 28, *upgrade* 45, *boss* 48, *upgrade + rune* 3, *rune* 2; benched 23), `check_gj` 44 (*draft* 18, *draft + rune* 6, *upgrade* 12, *boss* 8), `check_hk` 44 (*draft* 15, *draft + rune* 9, *upgrade* 12, *boss* 8), `check_ib` 17 (*draft* 9, *upgrade* 2, *boss* 1, *rune* 3, *draft + rune* 2; benched 1; *an empty cache let go* 1); `check_fh`, with its own draft half, answered 52 draft screens and through the boss-and-upgrade helper 12 ability picks and 12 upgrades, with 7 runes and 11 benches. **No road met the draft and the boss's offer on one screen** — an elite and a zone boss are never one fight, and a road answers each screen before the next — so the cap across two offers is driven in `check_id` alone.

## §2 — THE WORDS

- **The title** (`_screen_name`): *THE DRAFT — <hero>* whenever an ability is on the screen; *THE CACHE*, *THE UPGRADE*, *THE
  UPGRADE AND THE CACHE* otherwise (ruling 4). Driven for all fifteen combinations (`check_id` §2): it never misnames its screen.
- **The owed line** (`_owed_line`): what he is owed, one sentence, then *Decide, then confirm.* — *A new ability.* / *Two new
  abilities.* / *An ability upgrade.* / *A rune from the cache.* / … / *Two new abilities, an ability upgrade and a rune from the
  cache. Decide, then confirm.* A list joined as a sentence joins one, no colon, no line break.
- **The counter** (`_confirm_text`): *One / Two / Three / Four choices still to make*, no parenthesis; decided, the Confirm says the
  title's noun — *Confirm the draft*, *Confirm the upgrade and the cache* — so it cannot misname the screen either; nothing to take,
  *Nothing to choose yet*.
- **The heads**: ABILITIES, UPGRADES, RUNES (premise 16); *lets the cache go* unchanged.

## §3 — THE GLYPHS

### §3a — THE SWEEP, KEPT (§0.6)

*Rule*: every ◆ (U+25C6), ↑ (U+2191) and ✦ (U+2726) in every tracked text file — scripts, gates, suites, documents, data, the
glossary (`data/glossary.json`) and the archive — line by line, each hit classed *code* (a `.gd`, outside a comment), *comment*,
*data* or *document*. *Command*: `python3 tools/glyph_sweep.py <repo> > glyph_sweep_id.out` (in this batch's scratchpad,
`19684d29-326a-45ee-b419-a75795d765d0/scratchpad/`). *Output* (the game's scripts; the full per-file table is in the scratchpad):
By file, the game's scripts (no data file, and not the glossary, carries any of the three):

```
scripts/battle.gd                                code:arrow=1,star=2 comment:arrow=2,diamond=3
scripts/blacksmith_screen.gd                     code:arrow=1 comment:arrow=2,diamond=2
scripts/draft_screen.gd                          comment:diamond=1
scripts/kit_preview.gd                           code:star=1 comment:star=1
scripts/map_screen.gd                            code:arrow=1,diamond=4,star=5 comment:arrow=1,diamond=1,star=3
scripts/party_screen.gd                          code:arrow=1,star=1 comment:arrow=2
scripts/relics_screen.gd                         comment:diamond=1
scripts/run_state.gd                             comment:arrow=3
```

Every line of the game's code that draws one — **◆ four times, each a pending pick's badge (`map_screen.gd` 910–916); ↑ four times, one on each upgrade surface (the battle button, the sheet's chip, the Blacksmith's offer, the map's corner); ✦ the rest** — the worn and carried marks, the held count, the rune chip and the Empower toggle, ruling 1:

```
scripts/battle.gd:6195: emp_btn.text = "✦ Empower (C)"
scripts/battle.gd:7737: btn.text = "↑ " + btn.text
scripts/battle.gd:27839: const RUNE_CHIP_TAG := "✦"
scripts/blacksmith_screen.gd:121: upgrade.text = "↑ %s" % Run.upgrade_name(String(pairing["id"]))
scripts/kit_preview.gd:210: _line("   ✦ %d held, not worn — equipped from the %s's rune panel on the map." % [
scripts/map_screen.gd:754: mark.text = "✦ %d" % waiting
scripts/map_screen.gd:896: up_badge.text = "↑%d" % ups.size()
scripts/map_screen.gd:910: badges.append("◆ %d ability" % owed_abs)
scripts/map_screen.gd:912: badges.append("◆ %d draft" % owed_draft)
scripts/map_screen.gd:914: badges.append("◆ %d upgrade" % owed_ups)
scripts/map_screen.gd:916: badges.append("◆ %d rune" % owed_runes)
scripts/map_screen.gd:3106: lbl.text = "%s%s%s" % ["✦ " if is_on else "", aname,
scripts/map_screen.gd:3116: lbl.text = "✦ %s — %s" % [aname, Run.sits_out_note(aname,
scripts/map_screen.gd:3257: "  ✦ %d" % crest_waiting if crest_waiting > 0 else "",
scripts/map_screen.gd:3366: plbl.text = "%s%s — %s%s" % ["✦ " if p_on else "", String(pr.get("name", "")),
scripts/party_screen.gd:380: chip_label.text = "%s%s%s" % ["↑ " if not ups.is_empty() else "",
scripts/party_screen.gd:542: var equip_tag := "✦ " if is_on else ""
```

The whole tree, by class: arrow/code=13, arrow/comment=11, arrow/document=29, diamond/code=18, diamond/comment=13, diamond/document=68, star/code=39, star/comment=13, star/document=75 (the documents and the gates carry the rest; the per-file table is `glyph_sweep_id.out` in the scratchpad).

**The sweep's gate side found one stale reader**: `check_gt` §3 trimmed *◆ * off the hero sheet's chips before reading a card's
name, and an upgraded card's chip leads with ↑ now — so its negative arm (*not also shown as a seated card*) would have passed for
an upgraded card by construction. No card in its fixture carries an upgrade, so no reading moved; it trims ↑ now. The map's ◆
badges and ↑ corners are unchanged, so `check_ib` and `check_ic`, which read them, read what they read.

**Asserted at the end** (`check_id` §3a, comments stripped): every ◆ in the game's code is a pending pick's badge — four lines, one a
kind — ↑ is drawn once on each of the four upgrade surfaces and nowhere else, and no data file carries either.

### §3b — EACH SURFACE APART, AND ITS ROOM

Driven (`check_id` §3b): the Cleric's upgraded Smite reads *↑ [Q] Smite* on its battle button (its face 70 px in 84) and a Warrior
holding no upgrade draws no mark; the hero sheet's chip *↑ Smite* (48 px of its 195); the Blacksmith's every offer *↑ <upgrade>*;
the map — ↑2 in a corner, *◆ 1 upgrade* on a card, *✦ 1* on a nameplate, and no label carrying two of the three. The corner's room
is IC's measurement (40 px; ↑12, the widest a run reaches, 22).

### §3c — THE CLASS PASSIVE's CHIP, AND THE RELIC's WORD

The chip is deleted (`battle._spawn_units`): no hero carries `class_passive` and no chip reads ◆; the passive reads on the hero
sheet (*Class: … — …*) and the class-selection card. **It was a status** (ruling 2): its four Sanctity events and four floats a spawn
went with it. A rare relic reads *<name>  RARE* on the shelf and in the picker; a common one carries no tag.

## §4 — THREE LINES THAT WERE FALSE

- **THE VOW's CHIP** (`battle._refresh_rune_chips`): on a vowed Cleric who holds something the vow silences, one chip, its words
  *Vow of Silence — ARMED / IN EFFECT · His heals are 50% stronger, and every blow he lands deals nothing, so it silences his own
  ground, which reflects nothing for anybody standing on it; the Ruin his blows would drink off a Ruined enemy; and Suffering's
  heal.* — each clause only while he holds what pays it (Consecrated Ground, a living Old Gods holder, Suffering), the heal figure
  read off his `rune_vow_of_silence`; IN EFFECT while his ground is laid or a Ruined enemy stands. Driven (`check_id` §4a): the vowed
  Occultist's chip names all three with the payload's figure, follows the field when it moves, turns IN EFFECT on a Ruined raider;
  no chip on an unvowed Occultist, none on a vowed Holy who holds none of the three.
- **MIRRORBOUND's CARD** (`Run.MODIFIERS`): *An attack that does not miss sends a quarter of the damage it deals back on its
  attacker — at least 1, even when it deals none. On both sides.* — the floor, both sides, and attacks only (premise 19), no
  pronoun. Driven (`check_id` §4b) on a real board under the bargain: every hero and enemy stamped 0.25; a vowed Smite that dealt
  nothing paid 1; an unvowed one that dealt 19 paid 5.
- **THE KIT BUTTON** (`map_screen._draw_hero_card`): at the card's bottom-right, on the CHOOSE row (`KIT_BTN_W` 56), CHOOSE and the
  core-rune line narrowed beside it; driven at *Kit 10/10* inside its card, clear of both.

## §5 — HOUSEKEEPING

**THE MOVE WAS NOT ATTEMPTED** (IB §4, ruled). **The count and the disk, by prefix, read at the close**: `app_userdata` holds
**526 folders and 175,188 KiB**. The spent prefixes — every *Dawn of Decay* copy from FX to IC and the five *DoD …* copies — are
**514 folders, 165,608 KiB**: the 501 IC counted (160,412 KiB, unchanged) and **IC's own thirteen, 5,196 KiB** (IC wrote 5,192 at its
close; no file in any of them is newer than ID's start at 21:30, so the four are not ID's). The three patterns below were tested
against every folder name, and the command's own globs expanded in zsh without moving anything: they match those 514 and nothing
else. **ONE command clears every spent prefix at once**, IC's thirteen included, leaving the live *Dawn of Decay* folder, ID's own
and `[unnamed project]`:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IC)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay I"[A-C]" "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IC)/"
```

**IB's caution, kept**: zsh aborts the whole command on a pattern that matches nothing, so a prefix already cleared is dropped from
the paste first. **ID's own folders** are named *Dawn of Decay ID …* and stay for IE: ten, 9,080 KiB — *ctlA*, *ctlB*, *docsubA*,
*docsubB*, *final*, *prepass*, *recon*, *stubgp*, *trA*, *trB*. The live *Dawn of Decay* folder, `../save-backups/` and `[unnamed
project]` are untouched; the live folder holds the gates' scratch files as every battery leaves them (ID's probes left
`id_probe_profile.json` and `id_probe_relics.json` there), and the player's four files in it are byte-identical to the backup.

## §6 — WHAT IS DELIBERATELY NOT DONE

- **THE CLERIC's REGEN AND THE MAGE's FIRE ARE IE's, AND THAT IS FINAL.** ID was the batch that was supposed to be them, and is not;
  the roadmap says so.
- **IC's REMAINDER IS IF's**: the damage-over-time tick's line, Blight the Well's line and credit, the bleedout burst's float and
  line, and the two frames that name the wrong dealer — Blight the Well's on the Old Gods' holder (so a vowed Cleric who drafts it
  without the engine is not silenced at all) and Umbral Sigil's echo on the striker — a live hole in the vow IC repaired. A tick
  credited by name is IF's too.
- **The vow is not re-priced; the recoil floor is not exempted; Anointing is not changed.** No crest rune re-cut or authored; the
  crest cap stays at one; Boil Over's rate not re-ruled, its Perfect not authored, the rising-rate lever not built; the third slot
  not gated behind a rung. `RUPTURE_BREAK_PER_TICK` stays at 10, still unfelt — **and nothing has been played for eight batches.**
- **The re-measure does not run; it is IG.** Its two readings at ID's close: `CLAUDE.md` 459,773 B = 449.00 KiB, **61.00 KiB under 510** — 7.5 batches at EZ's record (62,467 ÷ 8,293), 17.5 at ID's own +3,566; `docs/state.md` 347,830 B = 339.68 KiB, **40.32 KiB under 380** — 7.0 batches at IA's +5,860 (41,290 ÷ 5,860), 7.5 at HO–HW's +5,528 mean (+952 B at ID: IC's closed entries went to the archive). **`docs/state.md` still binds**: 7.0 to 7.5 batches at its own rates against `CLAUDE.md`'s 7.5 at the record — the two run out within half a batch of each other.
- **The claims stand at 86** and are IH's.
- Standing and unchanged: a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire
  becomes Sunder + Burn and Contagion and Reckoning owe re-cuts; the Occultist's Break card is CE §3's ask; the Skirmisher and the
  Tracker ruled into ordinary runes and unbuilt, Volley and Ambusher owed their core slots and names; Channel's tempo payout; whether
  a fallen hero stays down between fights; Tithe's read site and its talent rebalance; a bomb's surface text; the block index.

## §7 — THE VERIFICATION

### §7a — THE PUSH CHECK AND THE SAVES, BEFORE ANYTHING

`git ls-remote origin class-merge` read `db68ab75…`, local HEAD the same, before anything ran. The four player files were backed up to
`../save-backups/ID-20261012-213521` and verified by md5 against the live files and IC's backup — byte-identical, `run_save.bin`
42,200 B last written 2026-10-08 09:23. Re-read at the close, all four are byte-identical to it (§7h).

### §7b — THE RECON: HEAD's WHOLE BATTERY AGAINST ALL OF ID's GAME CODE, PREDICTED FIRST

HEAD's every gate, suite, document, baselines row and the runner, unedited, against **all eight of ID's game files**, in an isolated
copy md5-frozen at launch (its own user folder, *Dawn of Decay ID recon*, seeded from the backup), from 21:58:49. **The prediction was
written before the launch** and named two causes: the deleted overlay (the gates that call it, find it by binding, or pin its
source) and the class passive's chip, which was a status — so every seeded battle opens four dice shorter. **It ran 21:58:49 to 23:28:09 (89 min 20 s), HEAD's 143 targets (its runner, so no `check_id`), and closed `check_de` 589 / 31 / 1 notice.** The
copy was byte-identical before and after (526 files). **One gap, reported rather than re-run**: the recon's `battle.gd` is one
character behind the final — the vow chip's join of two clauses became *A; and B* at 22:07, nine minutes after the launch — and
no HEAD gate reads a two-clause vow chip; every gate ID did not change runs against the final code in the acceptance anyway.

| The prediction | What HEAD's battery read on ID's code |
|---|---|
| **Cause 1, a call to the deleted function** — `check_fe`, `check_fm`, `check_fd`, `check_gs`, `check_he`, `check_map_screen`, `test_batch_ah_battle`: *no verdict, the coroutine ends and the process idles to its watchdog* | **All seven red or short — and six of the seven printed a verdict**: `check_fe` 62 / 2, `check_fm` 77 / 0, `check_fd` 50 / 0, `check_gs` 696 / 0, `check_he` 250 / 0, `test_batch_ah_battle` 68 / 0, each with one or two throws and checks missing. **The shape was wrong**: a missing method throws inside the arm's coroutine and returns to its caller, so the gate goes on and reads SHORT. Only `check_map_screen`, which calls it from `_process` every frame, gave no verdict: it timed out at 600 s after 21,891 throws |
| **Cause 1, found by binding** — `check_ib`, `check_ic`; `test_batch_bo`'s two source needles | `check_ib` 117 / 14, `check_ic` 132 / 3; **`test_batch_bo` read three** — the third, the routing line, the prediction did not name |
| **The road walkers** — `check_gj`, `check_hk`, `check_gp`, `check_gv`, `check_fh`: red or incomplete at the first zone boss or mini-boss | `check_gj` 70 / 2 (its sanctioned red at *+173 / 193*, and its road stalled at zone 1 slot 8), `check_hk` 168 / 1, `check_gp` 467 / 2 (the one notice: it ROSE — a stalled road walks a different run), `check_gv` 1043 / 4, `check_fh` 160 / 1 with 186 throws |
| **Cause 2, the dice** — `test_batch_an` and `test_batch_bk` inside their bands; the harness, `check_cm_live` and the Sanctity readers at their rows | **All held**: `test_batch_an` 6051 (6044–6066), `test_batch_bk` 131 (129–131), the harness 22 / 382 / 8, `check_cm_live` 13 / 4, `check_ft` 147, `check_hs` 83, `check_ht` 77 |
| **Predicted green** — `check_hz`, `check_hy`, `check_hf`, `check_ia`, `check_hl`, `check_ho`, `check_gt`, `check_gx`, `check_hc`, `check_ea`, `check_eh`, every document instrument | **All green at their rows** |
| — | **MISSED, three**: `test_batch_bx` 163 / 2 (two source needles from the deleted routing), `test_batch_bo`'s third needle, and `check_ed` 18 / 1 — HEAD's manifest pins the deleted lines as code. **The prediction was written off a function-name grep; the literal sweep, run after, listed all three** — so from here the sweep runs before the prediction (the rule is a memory now, and IB's *a predicted red is still repaired line by line* is why each was re-pointed alone) |

### §7c — WHAT MOVED THE COUNTS, ATTRIBUTED BY TRACE AND STUB

**Every re-pointed gate holds its row but one, and the one is the dice.** `check_gp` reads 442 where its row read 458. Three traced
copies (every `ok()` printed), run side by side: HEAD's gate on HEAD's tree **458**; ID's gate on ID's tree **442**; ID's gate on
ID's code with HEAD's three spawn lines put back — the chip, its float and its Sanctity event — **458, its trace identical to HEAD's
message for message and in order**. ID against the stub differs only in §4's *the engine-less X was OFFERED Y* (51 cards where 67)
and the one total line: the no-engine road met 30 battles where it met 34. **So the fold moved nothing on that road; the chip's dice
moved all of it.** `check_gj`'s sanctioned §4 red reads *+179 / 199* where IC's read *+157 / 177*; the same stub read IC's figures
exactly. **Nothing else moved by the dice**: the recon (§7b) read `test_batch_an` and `test_batch_bk` inside their bands and the harness, `check_cm_live` and the three Sanctity readers at their rows — HEAD's gates, unedited, on ID's code — so `check_gp` is the one row ID moves for them. **The Hierophant's Sanctity is the cost the gates do not see**: four events fewer at every opening (ruling 2).

### §7d — EVERY RE-POINTED GATE ALONE ON THE FINAL TREE

Each in the repository, alone, stderr grepped for `Parse Error` (none): `check_fd` 60 / 0; `check_fe` 79 / 0; `check_fh` 168 / 0; `check_fm` 83 / 0; `check_gj` 70 / 1 (its sanctioned red); `check_gp` **442** / 0 (its row moved from 458, §7c); `check_gs` 824 / 0; `check_gt` 6813 / 0; `check_gv` 1057 / 0; `check_he` 258 / 0; `check_hk` 168 / 0; `check_hl` 169 / 0; `check_ho` 176 / 0; `check_ib` 119 / 0; `check_ic` 132 / 0; `check_map_screen` OK; `test_batch_ah_battle` 71 / 0; `test_batch_bo` 1140 / 0; `test_batch_bx` 163 / 0; and the new `check_id` 209 / 0 — **every one at its row**. And the walkers of the gate files, alone against the new gate: `check_parse` 219 / 0 (one more target), `check_ed` 18 / 0 (the manifest rebuilt, 1,768 pins), `check_gw` 76 / 0, `check_da` 41 / 0, `check_ea` 396 / 0, `check_ec` 24 / 0, `check_ek` 47 / 0, `check_es` 57 / 0, `check_ff` 68 / 0, `test_batch_cd` 92 / 0, `check_hx` 39 / 0. **The longest and the emptiest are
re-pointed with them** — `check_fm` §3 counts the longest cache screen's buttons exactly and `check_fe` §2d drives the emptiest boss
offer, each on the hero's screen; `check_id` §1b and §1c drive the longest screen (four kinds at the cap with both benches) and the
emptiest (an upgrade with nothing left) through the walkers' helper. **Every negative is paired with a positive**: no script names
the overlay, beside the CHOOSE opening the screen; no ◆ off a badge, beside the four badges drawn; no chip on an unvowed or an
unholding Cleric, beside the vowed Occultist's; no section where nothing is owed, beside each section where its kind is.

**Two things the new gate tripped before the battery, both repaired in the gate, neither by a raised ceiling**: `check_ed` read one
pin the manifest could not record — a needle carrying `%s`, which the builder skips as a format — so the needle lost its format
tokens; and `check_gw` §2 read 99 hand-sets against its ceiling of 96 — `check_id` moved the vow's figure on the unit and unvowed a
Cleric by hand, three sites — so the figure is seated through the rune's own payload (an instance carrying 0.7, never authored) and
the unvowed arm is the Warden's own blow on the same board. Both read green at their rows after.

### §7e — THIRTY CONTROLS, EACH IN ITS OWN CLONE

One APFS clone of the final tree per control, every patch count-asserted, two lanes with their own user folders (*Dawn of Decay ID
ctlA*, *ctlB*), every FAIL line kept. **Every planted defect reds at the arm it aims at; the baseline is green; HEAD's game code
under ID's gates (H01) reds every one of them; HEAD's helper under `check_id` (H02) reds every section it cannot answer.** One
control found a hole and the hole was closed: C25 (the boss's commit door benching below the cap and never refusing) read
`test_batch_bo`'s source needle red and `check_id` green — the screen never reaches that door unbenched at the cap — so `check_id`
§1a drives the door alone now (+3), and C25 was re-run on the final gate. `check_id` moved twice while the lanes ran — §4's arms re-seated (the vow's figure through the payload, the unvowed arm
the Warden's) and the commit-door arm added — so the controls those arms read were re-run on the final copy (C00, C19, C20,
C21, C25); the rest read arms neither change touched, and a count of 205 or 206 in the table is the gate before its last three
checks.

| # | The defect planted | What read it |
|---|---|---|
| C00 | baseline: the final tree, no patch | `check_id` 209 / 0<br>`check_ib` 119 / 0<br>`test_batch_bo` 1140 / 0<br>`test_batch_bx` 163 / 0<br>`check_fe` 79 / 0 |
| C01 | the CHOOSE opens an overlay again (bound to a second surface, not the hero's screen) | `check_id` 205 / 9 — *§1a: the card's CHOOSE does not open the hero's own screen*<br>`test_batch_bo` 1140 / 1 — *§3: ...and the draft has exactly one renderer, which CHOOSE routes to*<br>`test_batch_bx` 163 / 1 — *§2: the card's CHOOSE button opens the hero's own screen, for a draft and a rune cache alike*<br>`check_ib` 118 / 4 — *§1d: the dismissed draft is not marked on the Mage's card* |
| C02 | the zone boss's cards drawn as the overlay drew them: no computed block | `check_id` 206 / 1 — *§1a: the boss's first card is not drawn with its computed block, as a draft's card is* |
| C03 | an event's draft labelled as the elite's | `check_id` 206 / 1 — *§1a: a event draft is not labelled 'from an event' (["THE DRAFT — Berserker", "A new ability. Decide, then con* |
| C04 | the cap across offers forgets the draft's take | `check_id` 206 / 1 — *§1a: with one slot free and the draft's card staged, the boss's card does not ask the bench* |
| C05 | the boss's bench step offers the card the draft's benches | `check_id` 206 / 4 — *§1a: one Confirm did not commit all four (owed [0, 1, 0, 0], { "hero": 2, "card": "Bewitch", "bench": "Second * |
| C06 | a card staged in one offer is pressable in the other | `check_id` 206 / 1 — *§1a: the boss's copy of Battle Shout is pressable while the draft's is staged* |
| C07 | a boss offer with nothing to take holds the Confirm | `check_id` 206 / 3 — *§1a: a screen with nothing to take shows 'One choice still to make'* |
| C08 | the title says THE DRAFT whatever is on the screen | `check_id` 206 / 4 — *§2 ["upgrade"]: the title reads 'THE DRAFT — Holy'* |
| C09 | the owed line as a list, not a sentence | `check_id` 206 / 15 — *§2 ["draft"]: the owed line reads 'A new ability:* |
| C10 | the counter in figures, with a parenthesis | `check_id` 206 / 15 — *§2 ["draft"]: the counter reads '(1) choice still to make'* |
| C11 | the Confirm says the draft on every screen | `check_id` 206 / 1 — *§2: an upgrade-and-cache screen's Confirm reads 'Confirm the draft'* |
| C12 | the upgrade's figures not shown on its card | `check_id` 206 / 1 — *§1a: the UPGRADES section does not show what Honed and Quickened do to Bloodlust ('Damage: 26% → 39%', 'Cooldo* |
| C13 | the battle button's upgrade reads ◆ again | `check_id` 206 / 3 — *§3a: ◆ is drawn for something that is not a pick's badge: ["battle.gd: btn.text = \"◆ \" + btn.text"]* |
| C14 | the hero sheet's chip reads ◆ again | `check_id` 205 / 3 — *§3a: ◆ is drawn for something that is not a pick's badge: ["party_screen.gd: chip_label.text = \"%s%s%s\" % [\*<br>`check_gt` 6813 / 0 |
| C15 | the Blacksmith's offer reads ◆ again | `check_id` 206 / 3 — *§3a: ◆ is drawn for something that is not a pick's badge: ["blacksmith_screen.gd: upgrade.text = \"◆ %s\" % Ru* |
| C16 | the class passive's chip laid again | `check_id` 206 / 2 — *§3a: ◆ is drawn for something that is not a pick's badge: ["battle.gd: u.add_status(\"class_passive\", Classes* |
| C17 | the relic shelf's rare tag reads ◆ RARE again | `check_id` 206 / 2 — *§3a: ◆ is drawn for something that is not a pick's badge: ["relics_screen.gd: var tier_tag := \"  ◆ RARE\" if * |
| C18 | the relic picker's rare tag reads ◆ again | `check_id` 206 / 2 — *§3a: ◆ is drawn for something that is not a pick's badge: ["draft_screen.gd: var tier_tag := \" ◆\" if String(* |
| C19 | the vow's chip does not name the Ruin draught | `check_id` 206 / 1 — *§4a: the vowed Occultist's chip does not name his ground, his draught and Suffering's heal with his payload's * |
| C20 | the vow's heal figure written as a literal | `check_id` 206 / 1 — *§4a: the vowed Occultist's chip does not name his ground, his draught and Suffering's heal with his payload's * |
| C21 | Mirrorbound's card as it read before ID | `check_id` 206 / 1 — *§4b: the card does not say the quarter, the floor, both sides and the miss, without a pronoun: 'A quarter of t* |
| C22 | the Kit button back after the rune slots | `check_id` 206 / 4 — *§4c: card 0's Kit button [P: (304.0, 146.0), S: (56.0, 30.0)] runs past its card [P: (8.0, 84.0), S: (300.0, 1* |
| C23 | the walkers' helper skips the zone boss's offer | `check_id` 205 / 13 — *§1a: one Confirm did not commit all four (owed [1, 1, 1, 1], { "hero": 2, "card": "Bewitch", "bench": "Second *<br>`check_ib` 119 / 3 — *§1c: the screens came ["3:draft", "0:upgrade", "1:boss", "1:boss", "1:boss", "1:boss", "1:boss", "1:boss"], no* |
| C24 | the hero's panels declare 540 again | `check_id` 206 / 4 — *§1b (one at the cap, its bench): a panel runs off the screen or past the Confirm, or outgrew what it declares * |
| C25 | the boss's commit door benches below the cap and never refuses | `test_batch_bo` 1140 / 1 — *§3: a boss pick at the cap opens the same drop step*<br>`check_id` 209 / 3 — *§1a: at the cap the boss's commit door took Firestorm with no bench ('', owed 0)* |
| C26 | the screen's open guard asks only the draft and the rune | `test_batch_bx` 163 / 1 — *§2: ...and never with nothing to offer*<br>`check_id` 146 / 15 — *§1a (boss): the arrival did not open the Cleric's screen with its section alone (screen false, section false, * |
| C27 | the zone boss's offer drawn off the stored triple, not ability_choice | `check_fe` 79 / 3 — *§2: the zone boss's offer no longer takes its list from `ability_choice`*<br>`check_id` 206 / 2 — *§1a: the held-back offer does not say what it waits on and that the pick stays owed (["THE DRAFT — Holy", "A n* |
| H01 | HEAD's game code under ID's gates | `check_id` 139 / 61 — *§1a: the game's scripts still name the retired overlay: ["map_screen.gd: _open_pick_overlay", "map_screen.gd: *<br>`check_ib` 116 / 13 — *§1b (ability): the arrival did not open the Mage's pick on its screen ({  })*<br>`test_batch_bo` 1140 / 3 — *§3: a boss pick at the cap opens the same drop step*<br>`test_batch_bx` 163 / 2 — *§2: the card's CHOOSE button opens the hero's own screen, for a draft and a rune cache alike*<br>`check_fe` 74 / 8 — *§2: the zone boss's offer no longer takes its list from `ability_choice`* |
| H02 | HEAD's gate_fixture under check_id (the helper without the boss and the upgrade) | `check_id` 206 / 16 — *§1a: one Confirm did not commit all four (owed [1, 1, 1, 1], { "hero": 2, "card": "Bewitch", "bench": "Second * |

### §7f — THE SWEEPS, AND THE CLAIMS RE-READ

- **The literal sweep, game code** (`tools/litsweep_id.py`): every gate and suite literal of four or more characters present in HEAD's
  eight game files and gone from ID's, and every shorter one at its own length by count. Its LOST list named every source needle the
  recon then found red (`check_fe`'s two, `test_batch_bo`'s three, `test_batch_bx`'s two) and the rest are words a gate reads
  elsewhere; its short flips are the glyphs (◆ off, ↑ on) and IDs' own.
- **The literal sweep, documents** (`tools/litsweep_docs.py`, raw and whitespace-collapsed, every length): 16 lost, 87 gained, 12
  short flips across the nine edited files, each cross-checked against the manifest's document pins and the four gates that open
  `docs/state.md`. **One pinned needle moved**: `test_batch_bx` §5's *four columns* GAINED in `docs/master.html` — an alternative
  the arm already met with *one screen*, still present — so it flips nothing.
- **The reference claims re-read (HY §6)** over every name the diff touches, in both references: 31 sentences in
  `docs/instrument-rules.md` and 8 in `docs/combat-rules.md` carry one. **Two were false and are repaired**: the walkers' helper
  bullet (*a pick overlay's choice carries a `choice` meta*, and a walker reads past *Not yet* — the overlay is gone, and the bench
  step's choice carries the meta) and `check_map_screen`'s *opens both overlays* — it opens the
  hero's screen, the rune panel, the loadout panel and the bench step. The rest read true against the new tree.
- **The glyph sweep** is §3a's, kept.

### §7g — THE PRE-PASS AND THE ACCEPTANCE RUN

**The 59 document readers first** — every target that opens a document, derived off the runner's list (the rest name one only in a
comment): on the final documents in two isolated clones (*docsubA*, *docsubB*), each proved equal to the tree, every one at its row
and none with an error. **Then the pre-pass and the acceptance, side by side, predicted before either launched**: `check_de` 593 / 0 /
0 — +4 a target, as at IB and IC — every target at its row, `check_id` 209, `check_parse` 219, `check_gp` 442, `check_ed` 18 on 1,768
pins, the sanctioned reds as recorded.

**The pre-pass**: an APFS clone proved equal to the tree (527 files, the project name aside), its own user folder seeded from the
backup, 144 targets, 23:42:18 to 01:03:13 — **`check_de` 593 / 0 / 0**. **The acceptance in the repository**: 144 targets, 23:42:18 to
01:03:15 — **80 min 57 s** — **`check_de` 593 / 0 / 0, as predicted**: `check_id` 209 / 0, `check_gp` 442 / 0, `check_parse` 219 / 0,
`check_ed` 18 / 0, `check_gw` 76 / 0, `check_gj` 70 / 1 (its sanctioned §4 at *+179 / 199*), `check_cm_live` 13 / 4 (sanctioned), the
harness 22 / 382 / 8, `test_batch_an` 6050 and `test_batch_bk` 131 inside their bands (the pre-pass 6056 and 131), `check_map_screen`
complete. **`ps` read by rows every 15 s**: 324 readings and 623 Godot rows across the two batteries, every one `--headless` and no
game window — 306 readings saw two, 11 saw one, 7 saw none (between targets). **The tree was byte-identical before and after** (527
files, tracked and untracked), and **the player's four files were untouched**.

### §7h — THE CLOSE

**The post-run lines** — `docs/state.md`'s instruments and verification lines and its two readings — were written after the run, at a
fixed point (the file states its own size: 347,830 B). **Their needle proof**: every gate literal, against the copy the battery read and
the final file — one flip, the three-character *-20* (the backup folder's date), which only `check_go` carries, and `check_go` does not
open the file. **The four gates that open `docs/state.md` and the two manifest instruments, re-run on the final tree in an isolated copy**
(*Dawn of Decay ID final*): `check_es` 57 / 0, `check_fg` 30 / 0, `check_hp` 171 / 0, `check_hx` 39 / 0, `check_ec` 24 / 0, `check_ed`
18 / 0 — each at its acceptance reading. **The player's four files, re-read at the close**: byte-identical to
`../save-backups/ID-20261012-213521` by md5, `run_save.bin` 42,200 B last written 2026-10-08 09:23 — **nothing has been played for
eight batches**. **This report was written last**, out of the scratchpad, with no template token left. The push and its `ls-remote`
check follow the commit that carries it.
