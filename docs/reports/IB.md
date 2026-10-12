# BATCH IB — THE DRAFT APPEARS, AND EACH HERO DRAFTS ALONE

**On `class-merge`, from `ae4ee06` (IA). IMPLEMENT ONLY.** **§0: IA's five rulings are answered** — two moved a line (an empty core
slot reads *— empty —*; the event verb's core rune stays held, its fallback recorded as an unauthored source of core runes) and three
are confirmations with their reasons written where a later batch will meet them (the panel keeps GT §1's scroll, the two rules told
apart; the save version stays, the principle beside HL §5's ceiling; the family is IC's, its scope set). **§1: every pick a hero is
owed opens by itself when the party arrives at the map** — the draft already did (BX); the zone boss's ability, the mini-boss's upgrade
and the rune cache now do too, one after another in the order earned; a holding never does; dismissing loses nothing and is once an
arrival. **§2: each hero drafts alone** — his card and his rune cache on one screen of his own, a section each only while owed, one
Confirm; a layout, no reward moved. **§3: the one string. §4: the clearing step is a report and a command.** **§6: one recon of HEAD's
whole battery against all of IB's game code, predicted first** — 141 targets, `check_de` 581 / 30, every red in a gate the prediction named (fifteen of the seventeen named; `check_fe` and `test_batch_ah_battle` read green, the possible `check_hk` red), nothing unnamed moved, each repaired to intent and every moved count attributed by trace; thirty-seven controls; **the acceptance run in the repository read `check_de` 585 / 0 / 0 across 142 targets.**

**VERDICT: LANDED.** IA's five rulings are answered — two moved a line (the empty slot's words; the event verb's held core rune, its
fallback recorded as an unauthored source of core runes) and three are confirmed with their reasons where a later batch meets them.
**§1 and §2 shipped as one change**: every pick a hero is owed opens itself on arrival, in the order earned; a holding never does;
dismissing loses nothing and is once an arrival; and each hero drafts alone on one screen, a section a pick, with no reward moved —
the four columns were already four picks. **The brief's premise that the two sections are never owed together was false** — the rune
cache is an elite's spoils, so the looter owes both after every elite — which is why the one screen matters. The road walkers answer
by the game's marks through one helper and print what they met. Four rulings are owed and none blocks. The pre-pass and the
acceptance run read `check_de` 585 / 0 / 0; the player's files are untouched; nothing has been played for four batches.

## NEEDS A RULING

1. **THE BOSS'S ABILITY AND THE UPGRADE KEEP THE PICK OVERLAY (§2).** A hero's own screen holds his draft and his rune cache — the
   designer's two words, *rune or ability draft* — and the zone boss's card and the mini-boss's upgrade open on the pick overlay, in
   the same order-earned walk. Folding them in is a section each and a staged choice each; it was not asked. Fold them, or keep two
   surfaces.
2. **THE WORDS ON THE HERO'S SCREEN (§2), PROPOSED.** Title *THE DRAFT — <hero>*; a line saying what he is owed (*A new ability and a
   rune from the cache. Decide both, then confirm.* / *A new ability. Choose one or decline, then confirm.* / *A rune from the cache.
   Choose one, then confirm.*); the section heads ABILITIES and RUNES; *N choice(s) still to make* on the Confirm until it is live;
   *lets the cache go* for an empty cache let go. Confirm, or word them.
3. **A RETURN FROM THE HERO SHEET OPENS NOTHING (§1).** Until IB the four-column draft reopened every time the player came back from a
   hero's sheet, because the map's `_ready` opened it on every entry. The brief's *once per arrival* makes that a re-show; now a pick
   dismissed on an arrival waits on its card's CHOOSE until the party next arrives, and a load is an arrival. Confirm.
4. **THE ◆ MARKS A PICK AND A HOLDING (§1d).** A pending pick is the card's border, a `◆ 1 upgrade`-shaped badge under the slots and
   its CHOOSE button — its own mark, never HR's ✦ — but the upgrades a hero already HOLDS read `◆3` at the card's top-right corner, the
   same glyph for a holding. Nothing is mistaken for ✦; the ◆ names both. Keep, or give held upgrades another mark.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief's premise | Read against the tree |
|---|---|---|
| 1 | §6b: IA's push hash is `git ls-remote origin class-merge` | **Held**: `ae4ee063…` on the remote and at local HEAD, read before anything ran |
| 2 | §6b: the four player files byte-identical since HY; `run_save.bin` and `profile.json` last written 2026-10-08 | **Held**: backed up to `../save-backups/IB-20261012-103914`, all four byte-identical to IA's backup and to the live files, still 2026-10-08. Re-read at the close: **unchanged** — all four byte-identical to the backup, `run_save.bin` and `profile.json` still last written 2026-10-08: nothing has been played for four batches |
| 3 | §0.1: the panel spans y 24 to 696 of 720 (`POUCH_RECT`) | **Held**: `Rect2(140, 24, 1000, 672)` |
| 4 | §0.1: HEAD's panel already scrolled at its own holding cap for three classes of four | **Held** (IA §3d: 574–634 px in 558) |
| 5 | §0.1: 815 px against a 583 px scroller is 1.4 screens | **Held, measured on the real panel** (`check_ib` §4): the Cleric with every core slot empty and the holding full, 815 px in 583 — 1.40 |
| 6 | §0.3/§3: `check_ia` asserts the empty slot's text in §2a, §2b and §3a | **Half right**: the needle stands in §2b, §3a, §3b and §3c; §2a reads the CORE head and never the row (§3) |
| 7 | §0.4: the event verb prefers an ordinary rune and falls back on the whole roll once his ordinary pool is spent | **Held** (`Run.grant_rune`); recorded, not changed |
| 8 | §1: *a waiting draft appears at the map* is the thing to build | **Already true of the draft** — BX's party screen opened from the map's `_ready` on every entry, a return from the hero sheet included — **and false of the other three picks** (the zone boss's ability, the upgrade, the rune cache), which waited on the card's CHOOSE (§1's census) |
| 9 | §1b: every pick already carries *Not yet* | **Held in substance**: the pick overlay's button is *Not yet*; the draft screen's was, and is, *Later* |
| 10 | §1d: HR's ✦ N counts held runes; give a pending pick a mark of its own if it has none | **It had one** — the card's border, a `◆ N kind` badge and CHOOSE — kept, and driven apart from ✦ (`check_ib` §1g). **Its ◆ is also the glyph of the upgrades a hero holds** (ruling 4) |
| 11 | §2a: the four columns are one card per hero — four picks, staged per column, one Confirm | **Held — the stop clause did not fire**: each hero is awarded his own draft, holds his own offer queue and no-return ledger, and BX's Confirm took each column through its own `Run.take_draft_ability` (§2a) |
| 12 | §2a: each column carries its own *See the kit* | **Held** (HEAD's `_draft_column`) |
| 13 | §2b: *they may never both be populated — an ability draft is a battle reward and a rune cache is a map node* | **False: a rune cache is not a map node.** It is an elite's spoils (one hero, the looter) and a bargain's reward — so the elite's looter carries a draft and a rune pick out of every elite, and both sections populated is the ordinary case (§2b) |
| 14 | §2d: HW scoped the crest rune out of a hero's pick | **Held**: `roll_rune_candidates` leaves the crest's runes out and `rune_choice` repairs a queued one away; the new screen draws `rune_choice` (`check_ib` §2d) |
| 15 | §4: HZ's fifteen, 6,312 KiB; IA's fourteen, 5,200 KiB; `app_userdata` 491 folders and 154,124 KiB at IA's close | **HZ's held** (fifteen, 6,312 KiB). **IA's fourteen read 5,172 KiB at IB** (each folder measured; IA wrote 5,200). **491 is consistent**: 496 at IB's start is 491 and IB's five |
| 16 | §5: 86 claims stand | **Held** (`docs/state.md`; IA §5 retired the first of HX's 87) |
| 17 | §6a: five of six road walkers answer a pick by pressing the first button that is not *Not yet*, and `check_fm` counts the overlay's buttons exactly | **Held** (HZ's table; `check_fm` §3) |
| 18 | §6a: every walker that reaches the map after a fight stops at a draft it did not expect — `check_gj`, `check_gp`, `check_gv`, `check_hk`, `check_fe`, `check_fh`, `check_fm` | **Six of seven**: HEAD's copies of those six read red on IB's code (§6's recon). **`check_fe` read green** — it walks no road: it opens the pick overlay itself for the zone boss's ability and the upgrade, which stayed on that overlay, and its one source needle (`Run.rune_choice` in the map) survived into `_take_rune_pick` |
| 19 | §6a: `check_gp`'s 32 and 36 battles over 49 maps; `check_gv`'s 1057 | **Held, read on IB's tree**: the re-pointed `check_gp` reads 32 and 36 battles over 49 maps, both roads stopping at zone 3 slot 17 (HEAD's own copy, on IB's code, stopped both at zone 1 slot 2 — §6b). `check_gv` 1057 **held** (its row) |
| 20 | §6b: IB changes no damage path, so one recon is the shape | **Held**: `battle.gd`'s two lines route the elite's rune cache through `Run.queue_rune_pick`; no damage, status or turn path moves |
| 21 | §6b: IA read 141 targets in 77 min 45 s | **Held** (IA §8) |
| 22 | Ceilings: `CLAUDE.md` 439.02 KiB, 70.98 under — about 8.8 batches at EZ's record and 20 at IA's +3,610 B | **Held**: 72,684 B ÷ 8,293 = 8.8; ÷ 3,610 = 20.1 |
| 23 | Ceilings: `docs/state.md` 337.02 KiB, 42.98 under; IA +5,860 B above HO–HW's +5,528 mean; **about 7.8 batches** | **The figures hold; the 7.8 does not**: 44,011 B ÷ 5,860 = **7.5** at IA's rate and ÷ 5,528 = **8.0** at HO–HW's mean (the nine deltas re-measured off `git show`: 9,278, 2,924, 2,327, 4,424, 4,701, 6,877, 7,227, 4,586, 7,412). **The conclusion holds either way: `docs/state.md` binds** |

## §0 — IA's FIVE RULINGS, ANSWERED

**Two moved a line; three are confirmations, each reason written where a later batch will meet it** — HW's rule: a ruling lands
whether it moves a line or not.

- **§0.1 — THE PANEL KEEPS GT §1's SCROLL. CONFIRMED, AND THE TWO RULES ARE TOLD APART** in `CLAUDE.md`'s GT §1 block: HU §1 governs a
  bar of peers under time pressure, GT §1 a sectioned document read between fights, and the panel's three sections are its
  navigation. **What the scroller shows today, measured** (`check_ib` §4, on the real panel): Godot's own vertical bar — an 8 px grabber
  on a faint track at the panel's right edge — drawn exactly when the content outgrows the scroller and never otherwise: at the
  configuration that scrolls most, the Cleric with every core slot empty and the holding full, **815 px of content in a 583 px scroller
  (1.40 screens), the bar drawn 8 px wide**; on a bare panel, **308 px, no bar**. Rendered windowed and read: the bar is visible, and the
  last row stands cut at the scroller's foot, which says *more below* as well. **It shows something, so nothing was added**; the brief's
  instruction was conditional on it showing nothing. IA's figures reproduce exactly (704–815 px with every slot empty across the four
  classes; the Cleric and the Hunter at 815). Where it scrolls is `check_gt` §1's, and *sanctioned, not a layout defect* is written beside
  GT §1 so no later batch re-finds it.
- **§0.2 — THE SAVE VERSION STAYS. CONFIRMED.** The principle is beside HL §5's ceiling in `CLAUDE.md`'s VERSIONS bullet (*a bump is for a
  key an older build would write away, not for a value it would read generously*, with the refusal's cost); the asymmetry is on
  `docs/state.md`'s save line: an IA save opened in HZ's build reads *3 of 2 slots filled*, seats three engines, refuses a fourth and
  round-trips whole — not a defect, not refused. **IB moved no version either**: its one new save content, the pick order, rides the
  members, which an older build reads past and writes back.
- **§0.3 — THE EMPTY SLOT READS *— empty —*. BUILT (§3).** HN §2.6's line is unchanged and still follows the slots only where he holds no
  core rune at all.
- **§0.4 — THE EVENT VERB's CORE RUNE IS HELD. CONFIRMED, AND THE FAUCET RECORDED**: `CLAUDE.md`'s engine charter bullet names the event
  verb an unauthored source of core runes once a hero's ordinary pool is spent, the fallback kept; `docs/state.md`'s TO WATCH IN PLAY
  carries the thing to watch — whether an ordinary pool runs dry in a run played forward. Nothing changed.
- **§0.5 — THE FAMILY IS IC's. CONFIRMED, ITS SCOPE SET** on the roadmap: §1 the five readers of the strike loop, §2 the 43 door calls,
  droppable. Not touched here.
- **§0.6 — THE ORDER.** §1 is the finding and §2 the presentation, and both landed; **they were built as one change** because §2's
  per-hero screen replaced the draft unit §1's walk opens — the walk was written over units of a hero and a kind from the start, so it
  stands without §2 (the four-column screen was one unit) and §2 swapped the unit. Nothing was dropped and no letter is spent.

## §1 — A WAITING PICK APPEARS AT THE MAP

**THE CENSUS, MEASURED FIRST — every pending decision a hero can carry out of a fight or an event, what holds it while it waits,
what clears it, and whether HEAD opened it on arrival:**

| decision | earned at | held on | cleared by | opened on arrival at HEAD |
|---|---|---|---|---|
| **the draft** | every elite (every living hero), the event verb `ability_draft` | `draft_picks_owed` + `draft_candidates` | `Run.take_draft_ability` / `Run.decline_draft` | **yes** — BX's party screen, from `_ready` on every map entry |
| **the zone boss's ability** | every zone boss (every hero) | `bm_picks_owed` + `bm_candidates` | `_pick_ability` | no — the card's CHOOSE |
| **the mini-boss's upgrade** | the mini-boss (every hero) | `up_picks_owed` + `up_candidates` | `_pick_upgrade` | no — the card's CHOOSE |
| **the rune cache** | every elite (one hero: the looter), the bargain's *rune* reward | `rune_picks_owed` + `rune_candidates` | `_pick_rune` / `_dismiss_rune_pick` (HEAD) | no — the card's CHOOSE |
| **a pouch swap** | a drop, an elite's spoils, a relic, an event with no slot | `Run.pending_item_offers` | take or leave | **yes** — chained after the draft (not after its *Later*) |
| **a rune on a full holding** | any grant through `Run.hold_rune` | `Run.pending_rune_drops` | drop one or leave it | **yes** — chained after the pouch |
| *(a bargain)* | before an elite or a mini-boss | `encounter_offer` | its own screen, before the fight | n/a — never carried to the map |
| *(a held rune, unworn)* | a drop, a cache, a purchase | the hero's `runes` / `engines`, `equipped` false | equipping | no, and **never** (§1a's ruling) |

**So the brief's *a waiting draft appears at the map* was already true of the draft, and false of the other three picks** — which is
the shape of the designer's complaint: *a rune or ability draft*, the cache and the boss's card, waited behind a button.

**WHAT WAS BUILT.** `map_screen._begin_arrival`, from `_ready`, walks `Run.pending_picks()` — every owed pick as a token `{hero,
kind}`, oldest first — and opens each on its screen: a draft or a rune cache on the hero's draft screen (§2), a boss's ability or an
upgrade on the pick overlay (`_open_pick_overlay` with the kind named); when the walk is done, the pouch's swap offers and the full
holdings, as the screen always chained them. Each step is `_arrival_next`, called (deferred) as the previous screen resolves or is
dismissed.

- **§1a — AN UNMADE PICK, NEVER AN UNEQUIPPED HOLDING.** `Run.pending_picks` reads the four pick counters and nothing else. Driven
  (`check_ib` §1a): four heroes each holding two runes unworn and owing nothing — the arrival opens nothing, and four ✦ marks are drawn;
  a draft owed beside the same holding opens.
- **§1b — THE THREE RULES.** **Dismissible, losing nothing**: *Later* (the hero's screen) and *Not yet* (the overlay) leave the pick owed,
  its offer stored and its card marked; `_arrival_dismissed` takes that hero's other picks of the same screen out of this arrival, so the
  screen does not come straight back (a modal loop). Driven (`check_ib` §1d): the first of two dismissed and the second taken, nothing
  reopened, the dismissed draft still owed with its offer unchanged and its no-return ledger unwritten, and made later from the card's
  CHOOSE. **Once per arrival**: an arrival is any entry into the map but two — **a return from the hero sheet or the talents**, which set
  `Run.map_reentry` as they return (`party_screen._on_back`, `talents_screen._on_back`); the map reads and clears it. A load is an
  arrival. Driven (`check_ib` §1e): back from the sheet through its own button, nothing opens; the next arrival opens the dismissed pick.
  **Never over a choice already made — WHERE IT IS HOOKED**: in `_ready`, after `_draw_screen()` and the drop's toast, and only when the
  framing card is not up; every step waits while any overlay is open (`_modal_open`: the pick overlay, the hero's screen, the bench step,
  the potion picker, the swap and full-holding panels, the swap chooser, the framing card and the kit preview). A node press changes the
  scene, and a scene that is gone opens nothing; the walk runs before any press can land, because `_ready` returns before input is
  processed. Driven (`check_ib` §1f): the source order, the walk asked to go on while a screen is up (nothing opens over it), and a pick
  owed under the first-run framing card (nothing opens over it).
- **§1c — THE ORDER WHEN SEVERAL ARE WAITING: WHAT WAS BUILT.** Each pick is stamped with a serial as it is earned — `Run.note_pick_earned`,
  called at every award door before its counter rises (`award_draft_pick`, `award_ability_pick`, `award_upgrade_pick`, and
  `Run.queue_rune_pick`, which the elite's spoils and the bargain's reward now both go through) — kept per kind on the member
  (`pick_serials`). The counters stay the truth of what is owed: a pick is answered oldest first, so `pending_picks` keeps the newest
  `owed` serials of each kind, and an owed pick with no serial (a save from before IB, a fixture that sets a counter by hand) takes serial
  0 and sorts first, in the party's order. Ties break by hero, then kind. **Within one fight the award order is the party's**, so the
  serial matters across arrivals — a pick deferred earlier comes before a newer one. Driven (`check_ib` §1c) with the order earned
  deliberately not the party's: the Hunter's draft, the Warrior's upgrade, the Mage's ability, the Cleric's rune — appeared in exactly
  that order. And the save: the order survives a save and a load; a save with no order opens every pick still owed, in the party's order
  (§1h). **One hero's screen holds his draft and his rune together**, so a looter's rune answers at his draft's place in the walk.
- **§1d — THE DEFERRED PICK KEEPS ITS MARKER, AND IT IS ITS OWN.** A pending pick already had a mark of its own at HEAD and keeps it: the
  card's border (purple for a rune, gold for the rest), a badge naming it (*◆ 1 draft*, *◆ 1 rune*) under the rune slots, and the CHOOSE
  button. HR's ✦ N counts runes held unworn, on the nameplate. **They read apart** — a different glyph, a different place, and words on
  the pick's badge — and `check_ib` §1g drives the three cases: a holding alone shows ✦ and no CHOOSE, a pick alone the badge and CHOOSE
  and no ✦, both each its own. **One overlap reported, not changed: the ◆ is also the glyph of the upgrades a hero holds** (*◆3* at the
  card's corner) — ruling 4.

## §2 — EACH HERO DRAFTS ALONE

- **§2a — THE PREMISE HOLDS: THE FOUR COLUMNS WERE FOUR PICKS.** Each hero is awarded his own draft (`award_draft_pick` per member), holds
  his own offer queue and no-return ledger, and BX's Confirm took each column through its own `Run.take_draft_ability`. So the split is
  presentation; no reward moved. Driven (`check_ib` §2a): four drafts, four screens, each drawing exactly his own offer and no other
  hero's card.
- **§2b — ONE SCREEN SHAPE, AND THE BRIEF'S PREMISE WAS HALF WRONG IN THE USEFUL DIRECTION.** *They may never both be populated — an
  ability draft is a battle reward and a rune cache is a map node*: **a rune cache is not a map node.** It is an elite's spoils (the looter
  is one random hero who can receive a rune) and a bargain's reward — so **the elite's looter carries a draft pick and a rune pick out of
  every elite**, and both sections populated is the ordinary case for one hero in four after every elite. A bargain's rune comes alone.
  The screen (`map_screen._open_hero_draft`, z 62, its hero on the `hero_draft` meta): a title naming him, a line saying what he is owed,
  *See the kit*, an **ABILITIES** section (BX's column, his alone: the cards, their tag lines, descriptions and computed blocks, what is
  held back and why, the bench step at the cap, Decline) **only while a draft is owed**, a **RUNES** section (the cache's offer re-asked
  through `Run.rune_choice`, each rune's text, what waits on an engine or the pet, an empty cache's *Let it go*) **only while a rune pick
  is owed**, one **Confirm** — live once every section on the screen is decided — and **Later**. The Confirm commits the card through
  `Run.take_draft_ability` / `Run.decline_draft` and the rune through `_take_rune_pick` / `_spend_rune_pick` (HEAD's `_pick_rune` and
  `_dismiss_rune_pick`, lifted out: the rune overlay's branch is deleted, so the hero's screen is the one surface for a rune pick).
  Driven (`check_ib` §2b): the looter's two sections, the Confirm dead with the card decided and the rune not, both committed by one press;
  a card alone and a rune alone; Later leaving both owed and the screen shut; an empty cache let go; at the cap, the bench step naming
  carried cards and never the protected core, the benched card kept.
- **§2c — THE KIT PREVIEW STAYS A BUTTON AND OPENS ON HIM.** The screen knows its hero, so *See the kit* opens the preview on him with no
  walking (`setup(idx, false)`); the Peddler's walking arms are untouched — `kit_preview.gd` and `shop_screen.gd` did not change, and
  `check_hz` §1b's Peddler arm reads as it did. Driven (`check_ib` §2c): the preview on the Hunter, not walking, and closing it leaves the
  staged card. The kit is not inlined.
- **§2d — THE CREST STAYS OUT.** HW's scope holds on the new screen: the RUNES section draws `Run.rune_choice`, which repairs a crest rune
  out of a queued triple (a pre-HW save's), and a hero's answer leaves the crest's bag and its slot as they were. Driven (`check_ib` §2d,
  and `check_ho` §1d on the same screen).
- **§2e — IT FITS.** Two sections of BX's column width side by side, inside the screen and above the Confirm; the Confirm and Later outside
  any scroller (`check_ib` §2e). Rendered windowed and read: both sections, the bench step at the cap, a rune-only screen.

## §3 — THE ONE STRING

The empty core slot's row reads *— empty —* (`map_screen._open_rune_panel`), the comment above it carrying the ruling. HN §2.6's line is
unchanged and conditioned as it was. **`check_ia` re-tuned on one constant** (`EMPTY_SLOT`) — **the brief's *§2a, §2b and §3a* is half
right: the needle stands in §2b, §3a, §3b and §3c; §2a reads the CORE head and never the row** — and the control on the line (C40, below)
reds `check_ia` at those arms and `check_ib` §5, while the re-tune leaves the gate green at its count (82).

## §4 — HOUSEKEEPING: THE CLEARING STEP IS A REPORT AND A COMMAND

**THE MOVE WAS NOT ATTEMPTED** (IB §4, ruled). **The count and the disk, by prefix, read at the close**: `app_userdata` holds **503 folders and 165,456 KiB**. HZ's fifteen (6,312 KiB) and IA's fourteen (5,172 KiB, each folder
measured; IA wrote 5,200) stand; the spent prefixes together — every *Dawn of Decay* copy from FX to IA and the five *DoD …* copies —
are **489 folders, 153,604 KiB**, every one matched by the command's three patterns, tested against every folder name. The live *Dawn of
Decay* folder, `../save-backups/` and `[unnamed project]` are untouched. **ONE command clears every spent prefix at once** — every *Dawn of
Decay* copy from FX to IA, and the five *DoD …* copies — leaving the live folder and IB's own:

```
mkdir -p "$HOME/.Trash/DoD spent user-data folders (FX to IA)" && cd "$HOME/Library/Application Support/Godot/app_userdata" && mv "Dawn of Decay "[F-H]?" "* "Dawn of Decay IA "* "DoD "* "$HOME/.Trash/DoD spent user-data folders (FX to IA)/"
```

**IB's own folders** are named *Dawn of Decay IB …* and stay for IC: twelve, 11,312 KiB — *ctlA*, *ctlB*, *ctlC*, *prepass*, *probe*, *recon*, *tracehead*, *traceheadseed*, *tracenew*,
*tracenewseed*, *walk*, *work*. **One caution for the paste**: zsh aborts a whole command on a pattern that matches nothing, so a
prefix already cleared is dropped from it first. The retirement is written into the rule's own block in
`docs/instrument-rules.md` and beside HO §5's item in `docs/state.md`, so no later batch reinstates the step.

## §5 — WHAT IS DELIBERATELY NOT DONE

- **The silenced-figure family is IC's**, its scope set (§0.5): the five strike-loop readers first, the 43 door calls second and droppable.
  Not touched.
- **The Cleric's regen and the Mage's fire are ID's.**
- **The claims are IE's: 86 stand.** IB repaired only what its own change made false (§6, the re-read).
- **No crest rune is re-cut or authored; the crest cap stays at one. Boil Over's rate is not re-ruled**, its Perfect not authored, the
  rising-rate lever not built. **The third slot is not gated behind a rung.**
- **The panel is not paged** (§0.1). **The save version does not move** (§0.2). **The event verb's fallback is not changed** (§0.4).
- **No conjunction is authored**: `RUPTURE_BREAK_PER_TICK` stays at 10, still unfelt — and nothing has been played for four batches now
  (§6).
- **The re-measure does not run** — five batches since HV. Its two readings are §6's last two lines.
- **The boss's ability and the upgrade are not folded into the hero's screen** (ruling 1), and **HEAD's pouch-offer tail** — a swap offer
  that finds room ends the arrival's tail without opening the next — is reported (FOUND AT IB), not moved.
- Standing and unchanged: a copied Frostbind's refusal is RULED, NOT BUILT; Mana stays; a meter is not a conjunction half; Marrowfire
  becomes Sunder + Burn and Contagion and Reckoning owe re-cuts; the Occultist's Break card is CE §3's ask; the Skirmisher and the Tracker
  are ruled into ordinary runes and unbuilt, with Volley and Ambusher owed their core slots and both owed names; Channel's tempo payout is
  owed; whether a fallen hero stays down between fights is owed and prices three crest runes; Tithe's read site and its talent rebalance;
  a bomb's surface text; the block index.

## §6 — THE VERIFICATION

### §6a — THE ROAD WALKERS, PLANNED BEFORE THE SCREENS AND RE-POINTED BY THE GAME's OWN MARKS

**The plan was written before a screen was** (it is the last block of the batch's plan): the game marks its choices, and every
walker answers through one helper. **The marks**: every button `_pick_button` draws carries a `choice` meta naming the handler it
calls and its bound arguments; the hero's draft screen carries its hero on a `hero_draft` meta and every control on it is bound —
a card to `_stage_draft`, Decline to `_stage_draft_decline`, a rune or an empty cache's *Let it go* to `_stage_draft_rune`, the
bench step to `_open_drop_overlay`, Confirm to `_confirm_hero_draft`, Later to `_close_hero_draft`. **The helpers**
(`gate_fixture.gd`): `Gate.bound_buttons` and `Gate.bound_args` (IA's binding-and-index method), `Gate.pick_choices` (the buttons
an overlay marks as choices — so the kit preview's button and *Not yet* are never pressed, by construction rather than by a
skip-list of words), `Gate.hero_draft`, and **`Gate.answer_hero_draft`, the one answer to a hero's screen**: the first card or
Decline, at the cap the bench step and its first choice, the first rune or the empty cache's *Let it go*, and Confirm — every
press by binding. **No walker reads a word to answer a pick.**

**What each walker does when a draft appears, re-pointed:**

| walker | a hero's draft screen (a draft, a rune cache, or both) | a pick overlay (the boss's ability, an upgrade) |
|---|---|---|
| `check_gj` | `answer_hero_draft`, **declining** the card — as its road always declined — and taking the first rune, as it always took one off the card's overlay | the overlay the arrival put up, or the card's CHOOSE, then `pick_choices[0]`; frees only its own overlay |
| `check_hk` | the same as `check_gj` | the same |
| `check_gp` | records the offer, then `answer_hero_draft` **taking** — the first card the screen draws is the first `Run.draft_choice` holds (the door it answered through before), and at the cap the bench step's first choice is the first earned card he carries | the same as `check_gj` |
| `check_gv` | records the cache's offer, then `answer_hero_draft` **taking** | the same |
| `check_fh` | its own `_answer_the_draft`, per hero: the card pressed by binding and **its tag line read off the screen**, at the cap the bench step's first choice, the rune by binding; an empty offer declined on the screen | `pick_choices[0]` |

Each walker answers the hero's screen wherever it finds one up (`Gate.hero_draft`), as it answered the party screen. **What each road records is its own**, as HZ
left it.

**THE LONGEST AND THE EMPTIEST (IA's standing rule).** The longest screen a walk now opens is **the elite's looter at the cap**:
both sections, the card staged into the bench step, the bench step's overlay over it, then the rune; the emptiest is **a rune
alone with an empty cache**: the RUNES head, the sentence saying why, and *Let it go*. A road deals what it deals, so **both are
constructed and driven through the walkers' own helper** (`check_ib` §6a): the looter at the cap answered taking (the card taken,
a carried card benched and kept, the rune held) and declining (the ledger written, nothing benched), and the empty cache let go.
**And each walker now prints what its road met** — the helper counts every screen it answers by shape, beside the verdict:
`check_gj` answered 28 screens — 7 with both sections, 21 a card alone; `check_hk` 30 — 9 both, 19 a card alone, 2 a rune alone; `check_gp` 55 — 18 both, 34 a card alone, 3 a rune alone, and **19 at the cap with a card benched**; `check_gv` 109 — 37 both, 63 a card alone, 9 a rune alone, **35 at the cap**; and `check_fh`'s own tally, 36 screens with every card's tag line read off the screen, **19 at the cap with a bench pressed**, and 9 rune picks. **No road met an empty cache** — a road takes one rune a cache and never spends a hero's pool — so the emptiest screen is `check_ib` §6a's alone; and `check_gj` and `check_hk` decline every card, as they always did, so they never reach the bench step: the longest screen they meet is both sections.

**The pick overlay's longest and emptiest** are HZ's and unchanged: three choices, *Not yet* and the kit preview; and an empty boss
offer, which draws its sentence and no choice (`check_fe` §2d drives the boss's pick three times through the screen).

### §6b — THE RECON: HEAD's WHOLE BATTERY AGAINST ALL OF IB's GAME CODE, PREDICTED FIRST

**One recon, because IB moves no damage path** (the brief's shape, premise 20): HEAD's every gate, suite, document, baselines row
and the runner — 141 targets, IA's acceptance population — against IB's five game files, `map_screen.gd`, `run_state.gd`,
`battle.gd`, `party_screen.gd` and `talents_screen.gd`, md5-frozen in the prediction. **The prediction was written before the
launch**: seventeen gates named red, each with its cause, ten named possible, everything else unmoved.

**It ran 141 targets, 10:59:29 to 12:23:45** (84 min 16 s, in an isolated copy beside two other runs), and **`check_de` read 581 / 30:
every one of the thirty in a target the prediction named, and nothing unnamed moved.**

| | predicted | read |
|---|---|---|
| **red, as predicted (15 of the 17 named)** | `test_batch_bx`, `test_batch_bo`, `check_map_screen`, `check_ed`, `check_fh`, `check_he`, `check_gj`, `check_gp`, `check_gv`, `check_fd`, `check_fm`, `check_hz`, `check_ho`, `check_hl`, `check_ia` | all fifteen red, each at the cause written beside it: the party screen's functions gone (`test_batch_bx` 126 / 6 and a throw; `test_batch_bo` 1140 / 1; `check_map_screen` a throw every frame, no verdict at its 600 s bound; `check_he` 246 / 1 and a throw), nine manifest pins broken (`check_ed` 18 / 1), `_pick_rune` gone (`check_fd` 54 and a throw), the rune pick no longer on the overlay (`check_fm` 82 / 5, `check_hz` 106 / 5, `check_ho` 176 / 4, `check_hl` 169 / 5), the road walkers stopped at the hero's screen (`check_fh` 118 / 3 and 397 throws, `check_gj` 36 / 6 and 888, `check_gp` 403 / 2 — both roads at zone 1 slot 2, `check_gv` 1048 / 6), and the old empty-slot words (`check_ia` 82 / 4) |
| **predicted red, read green (2)** | `check_fe`; `test_batch_ah_battle` | **`check_fe` 79 / 0**: it walks no road — it opens the overlay itself for the boss's ability and the upgrade, which stayed there, and its source needle (`Run.rune_choice` in the map) survived into `_take_rune_pick`. **`test_batch_ah_battle` 71 / 0**: its scratch profile has not seen the first-run card, and the arrival waits behind that card. Both predictions were wrong; both gates stand unmodified |
| **possible, read red (1)** | `check_hk` — red only if its road met an elite's looter or a boss pick | **168 / 4 and 885 throws**: its road met the looter's screen at its first elite and stopped after four battles |
| **possible, read green (9)** | `check_gs`, `check_gf`, `check_hr`, `check_hn`, `check_hc`, `check_gx`, `check_hf`, `check_gt`, `check_hx` §1d | all green at their rows |
| **unmoved** | everything else — the harness 22 / 382 / 8, `check_cm_live` 13 / 4, `check_parse` 216 | as predicted |

**What the recon proves is that nothing outside the draft, the cache and the empty slot noticed IB**: the battle, the sim, every rune
and card gate, the save's own gates (`check_gf`, `check_hr`) and every document instrument read IB's game code at
their rows before any instrument was touched.

### §6c — THE RE-POINTS, EACH TO INTENT, AND EVERY MOVED COUNT ATTRIBUTED BY AN `ok()` TRACE

**Every gate HEAD's battery read red on IB's code was re-pointed to what it asks, and every moved count is attributed by an `ok()`
trace** — HEAD's copy on HEAD's tree against the new copy on the new tree, each pair in matching copies (both seeded from the backup, or
both fresh), the message multisets diffed with every digit masked:

| gate | HEAD on IB's code | now | what was re-pointed, and the trace |
|---|---|---|---|
| `check_ib` | — | **119 / 0, new** | §1–§2, §4, §5, §6a, §9 (above); 107 at its first standalone reading, §6a's twelve added before the battery |
| `check_parse` | 216 / 0 | **217 / 0** | one more battery target, `check_ib` |
| `check_fd` | 54 / 0, a throw | **60 / 0 (+2)** | §1e answers the cache on the hero's screen by its bindings: a drawn rune button (+1) and a Confirm committing it (+1), where `_pick_rune` did both |
| `check_fm` | 82 / 5 | **83 / 0 (+1)** | §3's exact count is the runes, the kit preview, the Confirm and Later (was the runes, *Not yet* and the kit preview); an empty cache let go then draws its Confirm (+1); the arrival's screen is the hero's own |
| `check_fh` | 118 / 3, 397 throws | **168 / 0 (+1)** | the road answers each hero's screen by binding, its tag line read off the screen; §3's cache arm asserts the rune staged and the Mage's screen confirming it (+1); §3(c)'s doors name `queue_rune_pick` |
| `test_batch_bx` | 126 / 6, a throw | **163 / 0 (+4)** | the source pins name `_open_hero_draft`, `_begin_arrival` and `_arrival_next`; *opens on him* (+4, one a hero) and *his Confirm commits his decision alone* (+1); *FOUR columns* gone (−1); the count-keeping empty `ok()` and its `checks -= 1` gone together (0) |
| `test_batch_bo` | 1140 / 1 | 1140 / 0 | §3's one renderer is `_open_hero_draft` |
| `check_ia` | 82 / 4 | 82 / 0 | `EMPTY_SLOT` is *— empty —* (§3) |
| `check_he` | 246 / 1, a throw | 258 / 0 | its draft arms open the hero's own screen; §6 finds it by `Gate.hero_draft` |
| `check_hz` | 106 / 5 | 107 / 0 | the cache's kit button and pick on the hero's screen, pressed by binding |
| `check_ho` | 176 / 4 | 176 / 0 | §1d's cache answered on the hero's screen |
| `check_hl` | 169 / 5 | 169 / 0 | §1a's core rune taken on the hero's screen |
| `check_map_screen` | no verdict: a throw every frame, cut off at 600 s | `check_map_screen: OK` | each owed hero's screen opened in turn, its tag lines read off it |
| `check_gj` | 36 / 6, 888 throws | 70 / 1 (its sanctioned §4 red) | §6a |
| `check_hk` | 168 / 4, 885 throws | 168 / 0 | §6a |
| `check_gp` | 403 / 2 | 443 / 0 | §6a; 32 and 36 battles over 49 maps, as at HEAD |
| `check_gv` | 1048 / 6 | 1057 / 0 | §6a, and §2c's cache drive on the Occultist's own screen |
| `check_ed` | 18 / 1 | 18 / 0 | the nine broken pins re-pointed with their gates; the manifest rebuilt (1,742 pins) |
| `check_hx` | 39 / 0 | 39 / 0 | the new `CLAUDE.md` block named in `KNOWN_BLOCKS` (§1c) |

**Two findings about this batch's own instruments, reported because each is the kind the next batch repeats.**

- **MY FIRST RE-POINT OF `check_gv` MISSED §2c.** HEAD's copy read four reds at §2c on IB's code — a cache answered on the old pick
  overlay, driven directly rather than met on a road — and the recon table had them, predicted, beside the road's two. I re-pointed
  the roads and read the gate's §2c lines as the roads' symptoms; **the re-pointed gate, run alone on the final tree, read 1048 / 4**,
  the same four, and §2c was then re-pointed to the Occultist's own screen (1057 / 0). **A predicted red is still a red to repair
  line by line**: a recon that matches its prediction says the cause was understood, not that the repair reached every line it named.
- **AND ONE RE-TUNE WAS TAKEN BACK.** I predicted `test_batch_ah_battle` red — the arrival would open the first hero's boss pick and
  the suite would open a second, doubling its count — and scoped its count to one overlay before the recon. **HEAD's copy read 71 / 0
  on IB's code**: the suite runs on a scratch profile with the first-run card unseen, and the arrival waits behind that card (§1f), so
  it never opens there. HEAD's copy was restored; control C71 still reds it through the overlay it reads.

### §6d — THE CONTROLS

**Thirty-seven controls, one defect per APFS clone of the final tree, each patch count-asserted** (a patch that does not land is
reported, never run as a baseline), one user-data folder per lane, every FAIL line kept and read. **A control must break the needle
it aims at**: each row names the arm that went red, by its FAIL text.

| control | the defect | what went red, by its FAIL text | bit |
|---|---|---|---|
| C00 | baseline: the final tree, no patch | `check_ib` 119 / 0<br>`check_ia` 82 / 0<br>`test_batch_bx` 163 / 0<br>`test_batch_bo` 1140 / 0<br>`check_fm` 83 / 0<br>`check_fd` 60 / 0<br>`check_he` 258 / 0<br>`check_hz` 107 / 0<br>`check_ho` 176 / 0<br>`check_hl` 169 / 0<br>`test_batch_ah_battle` test_batch_ah_battle: 71 checks, 0 failures<br>`check_map_screen` check_map_screen: OK | — the baseline: every gate at its row |
| C01 | a holding opens a screen on arrival (the rune panel of the first hero holding one) | `check_ib` 119 / 8: *§1a: a HOLDING opened a screen on arrival (1 open) — the reminder became a nag* | yes |
| C02 | the arrival opens the draft group only, never the boss's ability or the upgrade | `check_ib` 117 / 8: *§1b (ability): the arrival did not open the Mage's pick on its screen ({  })* | yes |
| C03 | the order is the party's (the serial ignored) | `check_ib` 119 / 4: *§1c: the premise — the picks were not earned in the order constructed: ["0:upgrade", "1:ability", "2:rune", "3:draft"]* | yes |
| C04 | Later writes the no-return ledger (a dismissal declines) | `check_ib` 111 / 4 (1 script errors): *§1d: the dismissed draft is no longer owed (0)* | yes |
| C05 | a dismissal leaves the hero's other picks in the walk (his screen comes straight back) | `check_ib` 119 / 1: *§2b: Later on a hero owing a card and a rune brought his screen straight back — a modal loop* | yes |
| C06 | a return from the sheet is an arrival | `check_ib` 119 / 1: *§1e: a return from the sheet opened the dismissed draft again — it is not an arrival* | yes |
| C07 | the walk opens over an open overlay (no modal guard) | `check_ib` 119 / 2: *§1f: the walk opened a screen over one already up (1 up)* | yes |
| C08 | the arrival runs under the framing card | `check_ib` 119 / 1: *§1f: the arrival no longer waits on the framing card* | yes |
| C09 | the card draws no CHOOSE bound to its pick | `check_ib` 118 / 4: *§1d: the dismissed draft is not marked on the Mage's card* | yes |
| C10 | the upgrade's award stops stamping the order | `check_ib` 119 / 3: *§1c: the premise — the picks were not earned in the order constructed: ["0:upgrade", "3:draft", "1:ability", "2:rune"]* | yes |
| C11 | a load drops the order the members carried | `check_ib` 119 / 1: *§1h: the order did not survive the save (["3:draft", "0:upgrade"] → ["0:upgrade", "3:draft"])* | yes |
| C20 | every hero's screen draws the first hero's offer | `check_ib` 104 / 6 (1 script errors): *§1d: the second was not taken ({ "hero": 2, "card": "", "bench": "", "declined": true, "rune": "", "let_go": false, "confirmed": true })* | yes |
| C21 | the RUNES section drawn with no rune owed | `check_ib` 119 / 2: *§1b (draft): the screen is not his ABILITIES section alone* | yes |
| C22 | the Confirm goes live with the rune undecided | `check_ib` 119 / 1: *§2b: the Confirm went live with the card decided and the rune not* | yes |
| C24 | the RUNES section draws the stored triple, not the re-asked offer | `check_ib` 119 / 1: *§2d: the hero's screen drew ["Tithe", "Long Fuse"] — a crest rune in his pick, or not his class rune*<br>`check_ho` 176 / 2: *§1d: the Mage's cache shows a crest rune, or not the class rune left (Long Fuse)*<br>`check_fd` 57 / 3 (1 script errors): *§1e: the overlay OFFERED a rune the hero is wearing — ["Heavy Bolts", "Rune of the Deep Sight", "Keen Focus"]*<br>`check_gv` 1058 / 6: *§2c: the overlay drew Wide Rite as a button with the Old Gods unequipped* | yes |
| C25 | the kit preview walks the four | `check_ib` 119 / 1: *§2c: the preview did not open on the Hunter, or it walks*<br>`check_hz` 107 / 1: *§1b: a preview opened from the draft carries buttons ["◀ Previous", "Next ▶", "✕  Close"] — it is read-only and stays on its hero* | yes |
| C26 | the Confirm inside a scroller | `check_ib` 119 / 1: *§2e: _confirm_hero_draft is missing or inside a scroller, where text can carry it off* | yes |
| C27 | an empty cache draws no Let it go | `check_ib` 119 / 4: *§2b: an empty cache does not say why, or offers no way to let it go*<br>`check_fm` 83 / 6: *§3: the overlay offers no way to spend a pick that cannot be answered — the run carries it forever* | yes |
| C30 | the rune panel's scroller never draws its bar | `check_ib` 119 / 1: *§4: at its longest (815 px in 583) the panel scrolls and shows no bar* | yes |
| C40 | the empty core slot's old words back | `check_ib` 119 / 2: *§5: a hero holding no core rune drew 0 `— empty —` rows of 3, or the old words*<br>`check_ia` 82 / 4: *§2b: the loaded save's panel reads 'CORE — 2 of 3 slots' with 0 empty core slots — three slots, the third empty* | yes |
| C50 | the pick overlay marks no choice | `check_ib` 117 / 13: *§1b (ability): the arrival did not open the Mage's pick on its screen ({  })*<br>`check_gj` 70 / 2: *§1: a screen on the road could not be answered by a press — ["hero 0 owed a pick at zone 1 slot 8 and no live choice could be pressed", "hero 1 owed a*<br>`check_gp` 446 / 2: *§4 [no engine]: a screen could not be answered — ["hero 0 owed a pick at zone 1 slot 8 and no live choice could be pressed", "hero 1 owed a pick at zo*<br>`check_gv` 1057 / 4: *§4 [["berserker", "arcanist", "occultist", "sharpshooter"]]: the road stopped — hero 3 owed a pick at zone 3 slot 16 and nothing could be pressed*<br>`check_hk` 168 / 1: *§7: a screen on the road could not be answered — ["hero 0 owed a pick and no live choice could be pressed", "hero 1 owed a pick and no live choice cou*<br>`check_fh` 168 / 1: *§10: 35 screens drew a button the drive could not press — ["upgrade overlay hero 0: [\"Mocking Blow: Swift\", \"Crushing Blow: Piercing\", \"Mocking B* | yes |
| C51 | the hero screen's Confirm is a closure, not bound to `_confirm_hero_draft` | `check_ib` 121 / 19: *§1c: the screens came ["3:draft", "3:draft", "3:draft", "3:draft", "3:draft", "3:draft", "3:draft", "3:draft"], not in the order earned (the fourth he*<br>`check_gj` 36 / 6: *§1: the road stopped — the step cap of 900 ran out at zone 1 slot 5*<br>`check_gp` 403 / 4: *§4 [no engine]: a screen could not be answered — ["the draft screen at zone 1 slot 2 would not confirm", "the draft screen at zone 1 slot 2 would not *<br>`check_gv` 1057 / 7: *§2c: pressing Deepening Hex handed over []*<br>`check_hk` 168 / 4: *§7: the road stopped — short of the end boss*<br>`check_fh` 168 / 7: *§1: the drive walked only 2 encounters — a zone is 16, so the road stopped* | yes |
| C52 | the walkers' helper presses no bench step at the cap | `check_ib` 119 / 3: *§6a: the helper did not answer the longest screen (take true): { "hero": 0, "card": "Warcry", "bench": "", "declined": false, "rune": "Rune of the Rea* | yes |
| C53 | the helper's census never counts an empty cache let go | `check_ib` 119 / 1: *§6a: the helper's census did not count the longest and the emptiest: { "screens": 14, "a card alone": 9, "a rune alone": 3, "both sections": 2, "at th* | yes |
| C60 | staging a card takes it | `test_batch_bx` 163 / 5: *§2: the screen commits through the run's two doors and no others* | yes |
| C61 | one hero's Confirm commits every hero's staged card | `test_batch_bx` 163 / 2: *§2: the screen commits through the run's two doors and no others* | yes |
| C62 | a second draft renderer beside the hero's | `test_batch_bo` 1140 / 1: *§3: ...and the draft has exactly one renderer, which CHOOSE routes to*<br>`test_batch_bx` 163 / 1: *§2: exactly one draft screen — the hero's own — and no party-wide one beside it* | yes |
| C64 | one more button on the hero's screen | `check_fm` 83 / 1: *§3: the control screen drew 7 buttons against 3 runes on offer plus the kit preview, the Confirm and Later* | yes |
| C66 | the hero's screen carries no kit button | `check_ib` 119 / 2: *§2c: the Hunter's screen carries no kit button on him*<br>`check_hz` 102 / 3: *§1b: the Warrior's draft column carries no kit button* | yes |
| C67 | a confirmed pick puts up no toast | `check_hz` 107 / 3: *§3 (the Sharpshooter's core): the pick put up no waiting toast (``)* | yes |
| C68 | the cache slots a core rune it hands over | `check_hl` 169 / 3: *§1a: the core rune taken from the cache was slotted on the Mage, or is not held by him (engines ["overburn", "permafrost"], held [])* | yes |
| C69 | the ABILITIES section draws the stored triple, held cards as buttons | `check_he` 258 / 2: *§5 (the Stances out): the column draws a Lunge button and names the engine — unslotted, the card is held back and the sentence names the rune that bri* | yes |
| C70 | the ABILITIES section draws no tag line | `check_map_screen` check_map_screen: TAG MISMATCH — the draft card drew no tag line | yes |
| C71 | nothing opens for a boss's ability | `test_batch_ah_battle` test_batch_ah_battle: 71 checks, 2 failures: *the overlay names the pick*<br>`check_ib` 118 / 3: *§1b (ability): the arrival did not open the Mage's pick on its screen ({  })* | yes |
| H01 | HEAD's five game files under check_ib (the feature absent) | `check_ib` 47 / 21 (10 script errors): *§1d: the first earned (the Mage's) did not open first ({  })* | yes |
| H03 | HEAD's map_screen.gd and run_state.gd under the re-tuned draft and cache gates | `test_batch_bx` 126 / 6 (1 script errors): *§2: exactly one draft screen — the hero's own — and no party-wide one beside it*<br>`test_batch_bo` 1140 / 1: *§3: ...and the draft has exactly one renderer, which CHOOSE routes to*<br>`check_fm` 70 / 1: *§3: the pick did not open on arrival, on the hero's own screen*<br>`check_fd` 57 / 3 (1 script errors): *§1e: the hero's draft screen drew no rune button to press*<br>`check_he` 246 / 1 (1 script errors): *§6: a cache's buttons read [] — each should be the rune's name and nothing else*<br>`check_hz` 106 / 5: *§1b: the rune cache's pick carries no kit button*<br>`check_ho` 176 / 4: *§1d: the Mage's cache shows a crest rune, or not the class rune left (Long Fuse)*<br>`check_hl` 169 / 5: *§1a: the cache drew no button for Rune of the Cryomancer (core)*<br>`test_batch_ah_battle` test_batch_ah_battle: 71 checks, 0 failures | yes |

**Thirty-four defects, every one red at the arm it aims at, and every patch landed.** C00 is the final tree with no patch, every gate at its row. **The two HEAD arms are the repairs' other half**: H01 puts HEAD's five game files under `check_ib` — 47 / 21 with ten script errors, the feature absent — and H03 puts HEAD's map and run state under every re-tuned draft and cache gate, each red where it is green on IB's code (`test_batch_ah_battle`, never re-tuned, green under both). **C52 and C53 are the helper's own controls**: no bench step pressed at the cap reds §6a's longest screen, and a census that never counts an empty cache reds §6a's census arm. **C24 reds `check_gv` §2c as well**, the re-point found late (§6c): its screen draws the stored triple's withheld rows as buttons.

### §6e — THE SWEEPS

- **The literal sweep, before the battery.** Every gate's string literals — HEAD's copies and the new ones, 19,358 of four
  characters or more — against every document and every edited source, HEAD against the tree, re-run on the final documents
  before the battery: **48 lost and 125 gained.** Every lost literal is a name IB retired from a source it re-tuned (`_draft_columns`, `_open_party_draft`,
  `_pick_rune`, …, each in the HEAD copy of a gate now re-pointed), a word that left `map_screen.gd` with the deleted rune overlay
  and party screen and that no gate reads there, or a sentence of the rewritten `docs/state.md`, which four gates open and none of
  them for these; every gained literal is a name IB introduced, read by the gate written for it, or a common word with no reader in
  that file. The readers of every document IB edited ran on the tree (§6f).
- **Strings under four characters, swept at their own length** (the brief): the gates' 330 literals shorter than four characters,
  counted in every document and edited source at HEAD and now — **twelve flipped between absent and present**, and none is a needle
  in the file it moved in: `◆ ` (`check_gt` trims a label's text), `Sip`+`hon` and `-20` (`check_go`'s split engine word and a float
  label, both read off the game's screens), `BX` and `BS` (stamp comparisons), `IES` (`check_es` builds `RARITIES` from it),
  `  [` (`check_gv` slices a button's text at it and `check_he` asserts it absent from an offer's button — the band left
  `map_screen.gd` with the rune overlay), `AMP` (`check_el` reads `master.html` §6c alone; `run_state.gd` gained the word
  *stamped*), and `tag`, ` id`, `6` (population rows and node text, never `gate_fixture.gd`'s source).
- **HY's re-read** — the names IB's diff touches (128, the batch's own list), matched against every name the two references and
  the combat file backtick: **one claim IB's change falsified, repaired**: `CLAUDE.md`'s GV block said *the overlay says what waits
  and on which rune* — the hero's draft screen says it since IB §2. The rest hold: `_pick_button` renders a description alone and the
  rune cache's offer on the hero's screen the same way (CK §1, already re-pointed); `member["rune_candidates"]` rides the save (FD
  §1); the shop and the forge roll in their own `_ready` (FE §2, GF); `claim_reward` marks the resolution (GF);
  `map_screen._check_rune_drops` is chained after the pouch's swap offers (HK) — on the arrival's tail now, still after them; travel
  is still not gated on `bm_picks_owed` or `up_picks_owed` and nothing forces the answer (FE §2) — the arrival opens it and *Not yet*
  leaves it; and CK's 388 px draft-column viewport is still the ABILITIES section's. **No live count was written into a reference.**

### §6f — THE RUNS

- **The saves first**: backed up to `../save-backups/IB-20261012-103914` and verified by hash before anything ran — the four player
  files byte-identical to IA's backup and still last written 2026-10-08.
- **The recon** (§6b): 141 targets, 10:59:29 to 12:23:45, `check_de` 581 / 30, every red named in the prediction.
- **The document readers**: the 83 targets that open a document IB edited, as a subset battery generated from the live runner, on a
  copy synced to the tree after the documents were written: 81 of 81 readers green at their rows (`check_ib` read its pre-§6a 107;
  the harness needs its gate variable, which only the full runner sets, and read green in both full runs) — and every one of them
  again in the pre-pass, on the final documents.
- **The road walkers alone** on the final tree, each in a seeded copy: `check_hk` 168 / 0 (58 s), `check_gj` 70 / 1, its sanctioned
  line (44 s), `check_gp` 443 / 0 (231 s), `check_fh` 168 / 0 (85 s), and `check_gv` 1057 / 0 (596 s) once §2c was re-pointed (§6c).
- **The controls** (§6d): thirty-seven, in three lanes, every defect red at its line.
- **The pre-pass**: 142 targets in an isolated copy proved equal to the tree (473 files, the project name aside), seeded from the
  backup, 12:39:20 to 13:57:51 (78 min 31 s, beside the control lanes) — **`check_de` 585 / 0 / 0**, every target at its row.
  Two gates' failure messages were re-worded after it launched (eight strings in `check_fd` §1e and `check_gv` §2c, *overlay* to
  *screen*, no arm and no line moved, the manifest byte-identical); `check_fd` was re-run alone at 60 / 0.
- **The acceptance run in the repository**: 142 targets, 13:58:25 to 15:16:42 (**78 min 17 s**; IA read 141 in 77 min 45 s), `ps` read by rows
  every 15 s — 312 readings, 305 Godot rows, every one `--headless`, no game window — **`check_de` 585 / 0 / 0**, as predicted. The
  tree was byte-identical before and after (603 files, tracked and untracked) and the player's four files untouched.
- **Then the final tree**: the post-run lines in `docs/state.md` written after the run, at a fixed point (the file states its own size),
  swept against all 19,649 gate literals at every length — one presence flip, `-20`, a float label `check_go` reads off the game's
  screen — and the four gates that open that file with the two manifest instruments re-run on it in an isolated copy, each at its
  acceptance reading (`check_es` 57, `check_fg` 30, `check_hp` 171, `check_hx` 39, `check_ec` 24, `check_ed` 18).
- **And one comment, corrected after the run.** The comment I wrote above the arrival's hook in the map's `_ready` said the picks
  *chain off* the framing card; nothing opens when that card is dismissed — the walk simply never starts under it, and the two cannot
  meet in play. The comment now says so. **Proved comments-only** by a comment-stripped diff (identical), swept against all 19,649 gate
  literals (no presence flip), the pin manifest rebuilt byte-identical, and the **41 gates that read the map's source or walk every game script re-run on it** in two synced copies, every one at its
  acceptance reading (`check_ib` 119, `test_batch_bx` 163, `check_fh` 168, `check_hk` 168 and `check_parse` 217 among them).

### §6g — THE TWO READINGS, AND WHAT IS LEFT RUNNING

- **`CLAUDE.md` closes IB at 454,754 B = 444.10 KiB — 65.90 KiB under its 510 KiB ceiling** (+5,200 B at IB: the new standing
  block and §0's recorded reasons): 67,486 B ÷ 8,293 (EZ's record) = **8.1 batches**; ÷ 5,200 (IB's own) = **13.0**.
- **`docs/state.md` closes IB at 344,874 B = 336.79 KiB — 43.21 KiB under its 380 KiB ceiling** (−238 B at IB, its post-run lines
  included: IA's closed entries went to the archive): 44,246 B ÷ 5,860 (IA's) = **7.6 batches**; ÷ 5,528 (HO–HW's mean) = **8.0**.
- **So `docs/state.md` still binds, by a hair at the record**: 7.6 to 8.0 batches against `CLAUDE.md`'s 8.1 at its worst rate and 13.0 at
  IB's. IB's own delta on that file is not a rate — a rewrite that archives is not growth — so the two rates read are IA's and the mean.

**Nothing is left running**: the rows of `ps` read after the last run hold no Godot. **IB's own copies stay for IC** (§4).

### §6h — THE PUSH

Committed to `class-merge` by name — `save-backups/` left untracked — and pushed. `git ls-remote origin class-merge` is read after the
push and reported in the hand-back beside local HEAD: a commit cannot carry its own hash.
