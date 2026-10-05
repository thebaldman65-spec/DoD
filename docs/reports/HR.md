# BATCH HR — THE BAG SPLITS, THE NAMEPLATE SPEAKS, AND A CENSUS FOR FIRE AND ICE

**On `class-merge`, from `389291d` (HQ). IMPLEMENT ONLY.** HQ's three rulings are taken (§0): *the hero furthest from
full* in both Break-heal texts — the read site was checked first and it is the share comparison — and **a rune the game
cannot pay is no longer offered**. **The bag splits (§1)**: a class rune and a core rune go to the hero of their class and
are held unworn on him, eight at most; the shared bag holds the Crest's runes, six at most; every door routes the same
way, and a save from HQ's build hands its bag out on load. **The nameplate speaks (§2)**: a count of the runes each hero
holds and does not wear, on his card on the map, and the crest's own count on the bag's row; the drop is named against
its hero. **No Peddler and no Smith in the run's first three nodes (§3)**, measured before and after. **§4 is a census
and builds nothing**: who applies, reads and pays Burn, Chilled and Frozen, on both sides, with the clash measured.

**VERDICT:** **IT SHIPS.** The acceptance run in the repository read `check_de` 545 / 0 / 0 over 132 targets, every target at its
row; the tree was byte-identical after it and the player's four files are byte-identical to the backup taken before
anything was touched. Five rulings are owed below; none blocks the next batch.

## NEEDS A RULING — FIVE; THE FIRST FOUR ARE PLAYER-VISIBLE

1. **THE TWO CAPS, PROPOSED (§1c): EIGHT A HERO, SIX IN THE BAG.** Measured over 150 full runs at the second difficulty
   (two parties, full talents, every run but one completed): a hero is given **5–6 runes a run** (p90 7–8, max 12) —
   drops 2.3–3.0, caches 1.6–1.9, the sim's purchases 0.8–1.7 — plus about one bargain cache. **Eight does not fill from
   what a run hands a hero**: keeping everything and selling nothing, a hero ends a run holding 2–4 unworn (p90 4–6) and
   reaches eight in **1–2% of hero-runs**. **What fills it is buying**: a hero who bought every rune the Peddler offered him
   (4–7 a run, more gold than a run earns) would reach eight in a quarter to a half of runs. **The bag**: four crest runes
   exist and the party holds one of each, so it can hold four at most; six is the pool and two of headroom.
2. **THE GATE'S FIGURE — THREE, AS RULED, AND THE MEASUREMENT SAYS WHAT FAILS THE REASON (§3).** Three moves the first
   trade node a walk meets from node 1 (69% of runs today, where the heroes hold 60 gold and **17%** can pay 150) to node
   4 or later, where **86–89%** can pay 150. **The 11–14% that still cannot are runs whose first three nodes held events**:
   the generator places events after the trade nodes, roomiest column first, so the gated columns take most of a zone's
   events (2.8 of 5), and an event pays no gold. **At node 4 itself only 75–78% can pay 150; with events kept out of the
   three gated columns too, 100% can** — fights and elites only, ≥ 195 gold. **Proposed: keep three, and keep events out
   of the same three columns** (one line in `_assign_node_types`). Four instead reaches 90–94%.
3. **THE BARGAIN'S BOUGHT MERCHANT IS NOT GATED (§3e).** A severity-4 bargain whose reward is *a merchant follows the
   fight* can stand at an elite in column 2 or 3; under the sim's policy it is taken after an elite at node 2 in 8–13% of
   runs and at node 3 in 3–4%. It is not a map node, the player chose it over that bargain's gold, and `run_state`'s own
   record says it survives *because it is BOUGHT rather than rolled* — so it is left. One line gates it if the ruling's
   *neither appears* is meant to cover it.
4. **THE WORDS, PROPOSED (§1d, §2).** The brief's *kit* is not used on screen: the hero card already says **Kit** for the
   ability loadout (*Kit 7/8*, the Kit panel), one button away from the rune slots. A rune a hero has and does not wear is
   **held**: his panel's line *HELD, NOT WORN: 2 of 8*, a row's *(held)*, the marker **✦ 2** on the nameplate with *2
   runes held, not worn*, the full holding's panel *THE CRYOMANCER HOLDS ALL HE CAN — 8 of 8*, the drop's toast *Deep Cold
   drops for the Cryomancer — held, not worn: equip it from the card.*, the victory card *RUNE DROP: Deep Cold, for the
   Cryomancer — held, not worn — equip it from the Cryomancer's card.*, the Peddler's *held by him; equip it on the map* and
   *SELL A RUNE NOBODY WEARS*, and the run summary's *Held, not worn:*. The refusal is *He holds 8 unworn runes, the most
   he can.*
5. **§4 IS THE DESIGNER'S TO DECIDE ON, AND IT PROPOSES NOTHING.** The census answers the brief's seven questions; the
   mechanic, its payout and its scope are rulings it was written for.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HQ | **Held**: HEAD `389291d` = `git ls-remote origin class-merge`, the tree clean but for the untracked `save-backups/` |
| 2 | *"the lowest-health hero"* is wrong; the site pays by SHARE; confirm *furthest from full* | **Held**: `battle._lowest_hp` compares `h.hp / float(h.max_hp)`; driven at `check_hr` §0b — Warrior 100/223 (0.448) is picked over Mage 90/173 (0.520), the hero with fewer points. The amendment is not backwards |
| 3 | *"The refused tail is taken as proposed"* | **Held**: HQ built the words; nothing moved |
| 4 | Withhold the refused entry; `Runes.eligible_ids` asks `Talents.live_refusal` | **Built** (§0c), and the three lists that explain a short offer skip it too |
| 5 | *"A shared bag cannot say whose rune is whose"* | **Half**: the bag's panel, the victory card and the Peddler's rows named a rune's class beside it (HK §2b, HO §1); **no surface put a rune against its hero on the map**, which is what the nameplate does |
| 6 | An ordinary rune went onto the hero unworn until HK pooled every kind (HL §1c) | **Held**, and HL §1c adds the reason this batch answers: *"the map card draws only worn runes, so it showed nowhere on the map"* |
| 7 | HO §1 named the bag's surfaces | **HO's list is eight of twenty-one**; the derived list is §1b |
| 8 | Four crest entries exist | **Held**: Tithe, Dead Air, Dirge, Empty Pulpit live; Fellowship retired |
| 9 | Drops are party-classes-only (HK); the Peddler rolls per hero | **Held**; a save holding a class no hero is cannot be made by play (§1e) |
| 10 | *"this is what HP's ceiling was built for … as HP drove it"* | **HL's**: the ceiling was built and driven at HL §5 (`check_hl` §5). HR's v15 is the first version it guards, and the drive is §1f |
| 11 | The `< 10` floor does not move | **Held** |
| 12 | HQ's backup `../save-backups/HQ-20261001-110254`; expect the files to have moved | **Held**: `profile.json` and `run_save.bin` moved (§6a) |
| 13 | Expect `check_hk`, `check_hl`, `check_ho`, `check_hp`, `check_he`, `check_hf`, `check_fd` and every bag or Peddler tally to move | **Half held**: `check_hk`, `check_hl` and `check_hp` went red, and `check_ho` on one toast HR had reworded and then restored; **`check_he`, `check_hf` and `check_fd` did not move** (258, 314, 58 — none reads a class rune out of the bag). `check_gs`, `check_gt`, `check_fh` and `check_hn` moved as bag readers; nothing foresaw `check_gx` (the marker), `check_go` (the dice), `test_batch_bx` (two of HR's strings) or `check_gp` (green, 474 → 469) — §6b |
| 14 | HQ read 131 targets in 75 min 05 s | Not taken as a runtime; measured (§6) |
| 15 | The generator *drew 16 of 17 columns until GI* | **Held** (`docs/state.md`, *THE END BOSS HAS NO BUTTON — CLOSED AT GI*); a whole run's boards are counted at `check_hr` §3c |
| 16 | HO found Burn reaches heroes from enemy abilities and Chilled from a bargain | **Held and completed** (§4a) |
| 17 | HL §4: nothing reads what was cast last turn | **Held** (HL §4: `last_attack_target` and `overtone_casts` exist, nothing records the last cast) |
| 18 | Fellowship's layer was worth 1.9% of damage taken | **Held** (`CLAUDE.md`, the crest block) |
| 19 | `CLAUDE.md` 414.81 KiB of 470 | **Held** at HQ's close; HR leaves it at 417.56 KiB (+2,818 B) |

## §0 — HQ'S THREE RULINGS

### §0a — *THE HERO FURTHEST FROM FULL*, BOTH TEXTS

> **Breaking Heals a Hero** — *An attack that lands Break heals the hero furthest from full for 20% of it.*
> **Tithe** — *A hero's attack that lands Break heals*
> *the hero furthest from full, for 30% of it.*

**The read site was checked before the words moved.** Both pay in `_resolve`'s strike loop at `_lowest_hp(bc_pool)`, which
compares `hp / max_hp` — the standing hero lowest by share. A Warrior at 100/223 and a Mage at 90/173 are the brief's
pair: the site heals the Warrior (0.448 against 0.520), *the lowest-health hero* reads as the Mage. **The amendment is
right**, with one residue recorded rather than fixed: *furthest from full* can still be read as *the most points missing*,
and that reading parts from the share in some pairs (a Warrior at 150/223 is missing 73, a Mage at 60/100 is missing 40,
and the share picks the Mage). It is far closer than *lowest-health*, and nothing narrower is short.

**Re-broken under the 44-character ceiling**: Tithe's text is hand-broken (its tooltip does not wrap) at 38 and 43
characters. The talent's carries no break, as no talent's does: the talent screen shows it in a 320-pixel label that
wraps. `master.html`'s two copies carry the words; `check_hp` §4 holds both texts, the old reading gone from both and
from the document, and the share comparison at the site.

### §0b — THE REFUSED TAIL

Taken as proposed; the words HQ built stand (*it cannot work as written, so it pays nothing this fight*).

### §0c — A RUNE THE GAME CANNOT PAY IS NOT OFFERED

`Runes.is_refused(entry)` asks `Talents.live_refusal` of the entry as it stands, and **`eligible_ids` skips it** — and so
do `locked_by_kit`, `locked_by_engine` and `locked_by_pet`, the three lists the offer sites read to say why an offer is
short, so a refused rune is never named as one that waits on a card. `_load` still reports and keeps the entry (a save may
hold one), and **the roll call's tail stays as the net for a rune already worn** when a build began refusing it (HQ
§1.5's save route). Driven at `check_hr` §0a over a party-scoped refused fixture and its payable twin, the pool narrowed
to the two: the drop handed the payable one 120 times of 120; the Peddler, a cache and the event verb each the payable
one; no list named a refused one, and the payable twin waiting on a card it lacks is named. `check_hp` §1c, which
asserted the route as it stood, is inverted with its own twin.

## §1 — THE BAG IS FOR THE CREST; A CLASS RUNE LIVES WITH ITS HERO

### §1a — THE ROUTING (`Run.hold_rune`)

| scope | where it lands |
|---|---|
| `party` (crest) | the crest, when the pick asked and the crest is free; otherwise **the bag** (HO §1, unchanged) |
| a class's | **worn**, when asked and one of his three slots is free; otherwise **held unworn by the hero of its class** (`Run.hold_on_hero`) — in his `runes` with `equipped` false |
| core | **slotted**, when asked and a core slot is free; otherwise **held unworn by him** — in his `engines` with `equipped` false. Class selection still slots the one taken (`Run.awaken`) |
| a rune no hero here can wear | **the bag, kept** (`Run.bag_strays`) — reachable only through a save (§1e) |

**Whose:** the member the rune was rolled for when he can wear it (a cache, the event verb, the Peddler's row), else the
first hero in party order who can wear it and has room, else the first who can wear it (`Run.holder_index`) — so a full
holding queues against a named hero. **A real party is one hero of each class, so this is always *the hero of its
class***; a fixture seating two Warriors hands the first with room. **This is the shape every rune had before HK** — the
hero's own lists, `equipped` false — so the readers that never stopped asking `equipped` (the spawn, the hero sheet, the
sitting-out door) read it as they always did, and `Run.party_rune_names`, `Runes.owned_names` and `eligible_ids`'s
held-engine exclusion see a held rune with no change.

### §1b — EVERY SURFACE THAT READ THE BAG, AND WHAT EACH BECAME (derived, not HO's eight)

Derived by every reader of `rune_bag`, `BAG_CAP`, `bag_full`, `pending_rune_drops`, the bag rows and the bag's strings in
`scripts/`, then each one read.

| # | surface | at HQ | since HR |
|---|---|---|---|
| 1 | `Run.hold_rune` | worn, or into the bag | worn, or held by its hero; a crest rune the crest or the bag (§1a) |
| 2 | `Run.drop_after_fight` | into the bag | routed as 1; returns `{rune, where, hero}` and records it for the map (`Run.last_drop`) |
| 3 | `Run.buy_rune` (the Peddler's Buy) | into the bag; refused on a full bag | routed as 1 onto the hero the row was rolled for; refused while **that** holding is full (`Run.buy_refusal`, its sentence) |
| 4 | the event verb (`events.gd`) | worn or into the bag; its line said so | worn or held by the taker; the line says *held, not worn* |
| 5 | a cache's pick (`map_screen._pick_rune`) | worn or into the bag, toasted | worn or held; *Deep Cold waits with the Cryomancer — …* (HL §1's ruled words, the place in them his) |
| 6 | the victory card's drop line | *for the Mage — into the bag.* | *for the Cryomancer — held, not worn — equip it from the Cryomancer's card.*; a crest rune *into the bag.* |
| 7 | the hero's rune panel | what he wears, then the bag's runes he may wear | what he wears and what he holds, each held row with a Drop that asks twice; the line *HELD, NOT WORN: n of 8* |
| 8 | the empty rune slot's tooltip | *…from the bag (n there for the Warrior)* | *…of the runes he holds (n)* |
| 9 | the swap chooser | *— back into the bag* | *— kept, unworn*; the crest's *— back into the bag* |
| 10 | the map's bag row | *Rune bag n/20 (+n waiting)* | *Rune bag n/6 ✦ n (+n waiting)* — the crest's marker (§2b) |
| 11 | the bag panel | every rune nobody wears, *for* its class | the crest's slot and the bag: crest runes, and a stray marked *no hero here is a Mage* |
| 12 | the full-bag panel (`_check_rune_drops`) | the twenty | **the holding the rune is bound for** — his eight, or the bag (§1d) |
| 13 | `Run.settle_pending_drops` | the bag's room | each waiting rune asks its own holding's room |
| 14 | `Run.take_pending_drop` / `decline_pending_drop` | the bag's index | the holding's index (`held_rows` or the bag) |
| 15 | the Peddler's header and rows | *into the bag: n/20*; *into the bag; equip it on the map* | *each to the hero it is for*; *held by him; equip it on the map*, a crest rune *into the bag*; a full holding's row says whose |
| 16 | the Peddler's Sell rows | *SELL FROM THE BAG* | *SELL A RUNE NOBODY WEARS*: each hero's held runes, named *held by Warrior 1*, then the bag's |
| 17 | `Run.rune_choice`, `generate_rune`, `peddler_rune`, `grant_rune`, the drop's roll | exclude `party_rune_names` | unchanged: the list holds every hero's runes worn or held |
| 18 | the run summary (HP §6) | *Runes:* every rune on his list; *The bag:* | *Runes:* the worn; **new** *Held, not worn:*; *The bag:* the crest's |
| 19 | the hero sheet | a rune not worn read *pouch* | *held* |
| 20 | the save (`save_run`, `load_run`, `_bag_the_unworn`) | v14; unworn runes into the bag on load | v15; **`_hand_out_the_bag`** gives a v14 bag's class runes to their heroes; `_bag_the_unworn` deleted (it would undo it) |
| 21 | the sim (`RunSim._sim_take_drop`) | worn if a slot is free, left in the bag, declined on a full bag | the same on a hero's holding |

And the words a player reads outside the screens: the map's node tooltips (*Win it and a rune drops for one of the heroes*;
the Peddler's), the framing card, `data/glossary.json` (*runes*, *node_types*, *merchant*, *blacksmith*) and `master.html`.

### §1c — THE CAPS, AND THE SUPPLY THAT WAS MEASURED AGAINST THEM

**`Run.HERO_HOLD_CAP` = 8** unworn a hero, ordinary and core counted together; the three slots, the two core slots and
the crest count in neither cap. **`Run.BAG_CAP` = 6**. Both bind at intake only.

**The supply, measured** — the sim with an instrument patch in isolated copies, every rune landing tagged by source and the
heroes' holdings read after each; the second difficulty; party A Berserker, Cryomancer, Inquisitor, Beastmaster; party B
Swordmaster, Pyromancer, Holy, Sharpshooter (HQ's two). **Full talents, because an untalented party at this rung dies in
the second zone** (depth 26 and 14 of 49 over 50 runs each, one completion) and was given 1–3 runes a hero; *a full run*
needs a party that finishes one.

| | A (75 runs, 74 won) | B (75 runs, 75 won) |
|---|---|---|
| runes given a hero a run (Warrior / Mage / Cleric / Hunter) | 6.0 / 6.2 / 5.2 / 5.7 | 6.3 / 5.3 / 5.4 / 4.7 |
| of them: drops · caches · the sim's purchases | 2.4–3.0 · 1.8–1.9 · 0.9–1.7 | 2.3–2.9 · 1.6–1.8 · 0.8–1.6 |
| bargain caches a run (the sim never answers one) | 0.8–1.05 | 0.85–1.15 |
| the Peddler's offers a hero sees a run | 4.3–6.0 | 4.6–7.0 |
| most held unworn at once, the sim's policy | mean 1.8–2.5, max 6 | mean 1.5–2.7, max 8 (once) |
| held at the end, keeping everything (bargain caches taken, nothing sold) | mean 2.3–3.4, p90 4–6, max 8; **≥ 8 in 3 of 300 hero-runs** | mean 2.0–3.7, p90 4–6, max 11; **≥ 8 in 1 of 300** |
| …and buying every offer as well (unaffordable: ~22 offers × 150g) | ≥ 8 in 17–42 of 75 runs a hero | ≥ 8 in 25–44 |

**So eight does not fill from what a run gives a hero; buying fills it**, and buying everything costs more gold than a run
earns. **Eight is a holding a player reaches by choice**, and the panel answers him when he does.

**The bag**: the party holds at most one of each crest rune, so a bag can hold four today, three with the crest worn. Six
is the four and two of headroom; it binds only once seven crest runes exist.

### §1d — A FULL HOLDING: PER HERO, ON HK'S PANEL

**Per hero, and HK's panel is the shape.** A rune bound for a hero holding eight waits on `pending_rune_drops`, and the map
opens the panel beside **his eight** (`Run.pending_holder` names the holding): *THE CRYOMANCER HOLDS ALL HE CAN — 8 of 8*,
the drop with its rule, his eight each with **Drop this**, and **Leave it behind** below the scroller. A crest rune waits
beside the bag's six the same way. **Why per hero rather than a refusal on his own panel**: a drop is not something the
player started, so it cannot be refused (HK's ruling: never lost silently); the choice is one hero's, and a shared panel
would make the Warrior's drop cost the Mage a rune. **A purchase is the other wall** — the player started it — so the
Peddler greys **that hero's** Buy and his row says why; the other heroes' Buys stay live. An unequip into a full holding is
refused with its sentence and a swap goes through, HK's two walls on the new holding.

### §1e — THE SAVE MIGRATES

**`Run.SAVE_VERSION` 14 → 15.** The keys are v14's; what they mean moved, which is why the version moves: a v14 build
reading a v15 save would find runes unworn on a hero and its `_bag_the_unworn` would move them back into a bag of twenty.
**HL's ceiling refuses it** (§1f). **The floor at `< 10` did not move.**

**On load, `_hand_out_the_bag`** gives every class and core rune in a v14 bag to the hero of its class, unworn, in the bag's
order; a crest rune stays; nothing worn moves; **a hero may open over his eight** — nothing is dropped, sold or refused,
and the cap binds at intake (HK's rule for the bag, on his holding). A v15 save's bag holds crest runes and any stray, so
the hand-out moves nothing on it (a stray is said again on each load); a v13 save never had a bag, and its unworn runes load where its heroes held them.

**A RUNE WHOSE CLASS IS NOT IN THE PARTY: KEPT, IN THE BAG, AND SAID.** Play cannot make one — the drop rolls the party's
classes and the Peddler rolls per hero — but a hand-edited save, or a party whose shape changed, could. It is not
destroyed: it stays in the bag (`Run.bag_strays`), where it can be sold or dropped, its row says *no hero here is a
Hunter*, and the map says so once on arrival: *Keen Focus stays in the bag: no hero here is a Hunter to hold it. Sell it
or drop it.* (`Run.load_notes`). Driven at `check_hr` §1e with a party of two Warriors, a Mage and a Cleric.

### §1f — DRIVEN ON THE DESIGNER'S OWN SAVE, BOTH WAYS

**The save is real**: the designer's run, written by HQ's build on 2026-10-05 at 10:13 (v14, the third rung, the first zone at
`slot_idx` 10): the bag held **Clarity and Overtone — the Mage's — and Tithe**, the crest wore Dirge.

- **HR's build opened it through the main menu's real Continue** (an isolated copy whose harness save was that file): it
  landed on the map; **the Mage holds Clarity and Overtone, unworn, in the bag's order**; the bag holds Tithe alone; the
  crest still wears Dirge; the other three hold nothing new and wear what they wore; the Mage's nameplate reads **✦ 2** and
  the bag's row **Rune bag 1/6 ✦ 1**; no rune was kept for want of a hero; and the save was written back **as version 15**
  (md5 `96744c61…`, 45,248 B). 9 checks, 0 failures.
- **HQ's own build (a copy of HEAD `389291d`, `SAVE_VERSION` 14) was handed that v15 file**: it refused it and named version
  15; **the file was byte-identical** — md5, size and mtime — after the refused load, after `save_run`, after `clear_save`,
  after a New Game, and after the main menu opened over it, with Continue dark and the banner saying why. 8 checks, 0
  failures.

## §2 — THE NAMEPLATE SAYS A RUNE IS WAITING

### §2a — WHAT SHIPPED

- **A marker on each hero's nameplate on the map**: **✦ N**, the count of runes he holds and does not wear — both kinds,
  `Run.held_count` — drawn between his name and the upgrades badge, and only while N is at least one. **It is read off
  his holding every time the map is drawn**, never set by an event and never cleared by a menu: equip, sell or drop the
  last one and it is gone; open his panel and close it, and it is still there. It is a button: it opens his rune panel,
  where he equips them. Its tooltip: *2 runes held, not worn. Click to equip them from the Cryomancer's rune panel.*
- **The crest's own marker** on the bag's row: **✦ N**, the crest runes waiting in the bag (a stray is not counted —
  nobody can wear it).
- **The drop names its hero**, twice: the victory card (*RUNE DROP: Deep Cold, for the Cryomancer — held, not worn — equip
  it from the Cryomancer's card.*) and a toast as the map opens (*Deep Cold drops for the Cryomancer — held, not worn:
  equip it from the card.*), by the name on the card whose marker moved (`Run.nameplate`). `Run.last_drop` carries the
  drop to the map and is read once. A toast now outlives a redraw of the map, which the arrival chain (the draft, the
  pouch's offer, a full holding's panel) can do under it.

### §2b — WHAT THE DROP DOES WHEN IT ROLLS A CREST RUNE

It goes into the bag (or waits, if the bag is full), the **bag's** marker counts it, **no hero's marker moves**, the
victory card says *RUNE DROP: Tithe, for the crest — into the bag.*, and the toast *Tithe drops for the crest — it waits in
the bag.*

### §2c — DRIVEN ON THE REAL MAP SCREEN (`check_hr` §2)

A fresh run with every crest rune held in the bag first (so the drop is a hero's — the bag's marker reads the four, and no
nameplate is marked); **a real normal fight pressed from the real map** and won on autoplay with the enemy's attacks off;
its drop held by one hero alone; the victory card naming the drop and that hero's nameplate; **Continue back to the map**,
the toast naming the drop and the hero; **the marker on that hero's nameplate, ✦ 1, and on no other**; the bag's marker
unmoved; the marker pressed — his panel opens on the rune; closed and redrawn, the marker still ✦ 1; **pressed again, the
rune's own Equip pressed, the rune worn, the marker gone** and no nameplate marked. Three held read ✦ 3 on another hero.
**Then a crest drop**, every other rune the heroes could be dropped held on them first: the drop goes into the bag, the
card and the toast say it is the crest's, the bag's marker reads one, and every nameplate's marker reads what it read.

## §3 — THE PEDDLER AND THE SMITH ARE GATED, AND THE GATE IS MEASURED

### §3a — THE REASON, MEASURED BEFORE THE GATE

A probe over generated maps at the second difficulty, no battles: the victory branch pays a fight's or an elite's gold
whatever the fight, so each node is resolved by its gold doors — `award_gold`, the bargain taken (the sim's policy:
the severest while healthy) and its reward, the event under the sim's policy (the first choice whose requirement
passes) — and **a trade node spends nothing**, so what is read is what reaches the player. A run opens with **60 gold**; a
fight pays 45–60, an elite and its bargain 80–100 and up to 220; **a rune is 150g and the smith's every pairing is 150g in
the first zone** (`BLACKSMITH_PRICES[0]`), the cheapest Peddler supply a Health or Mana Potion at 30g.

**On HQ's generator** (a copy of HEAD, 3,000 maps, an unsteered walk):

| node | gold held: mean (median) | can pay 150 | the node is a Peddler / a Smith |
|---|---|---|---|
| 1 | 60 (60) | 0% | **34.2% / 32.9%** |
| 2 | 77 (60) | 0% | 26.6% / 9.8% |
| 3 | 142 (115) | 33% | 32.7% / 21.8% |
| 4 | 175 (156) | 55% | 23.8% / 12.2% |
| 5 | 228 (200) | 76% | 15.9% / 18.0% |
| 6 | 271 (228) | 86% | 7.8% / 13.1% |

**A trade node stood at node 1 in two maps of three** (column 1 is always three wide, and the trade nodes are placed
roomiest column first), where the heroes hold 60: a potion, and nothing else. **A route that ranks the smith first — every
policy the sim has — met one at node 1 in every run.** Reading the first trade node a walk enters: **at node 1 in 69% of
unsteered runs, where 17% can pay 150; 0% on the sim's routes.**

### §3b — WHAT SHIPPED

`Run.SHOP_GATE_NODES` = 3 and `Run.shop_gated(column)`: in the first zone, no merchant and no blacksmith in columns 1–3 —
the run's first three nodes; **no other zone is touched**. The zone still deals all six smiths and five merchants, into the
eleven columns left (§3d).

### §3c — DOES THREE SATISFY THE REASON?

**The first trade node a walk enters, and the gold the heroes hold there** — 1,000 maps a figure, an unsteered walk and the
sim's greediest; *declined* takes back out every gold the events moved (the sim's event policy pays gold where it can):

| gate | first trade node at | can pay 150 there: unsteered (events played / declined) | greedy |
|---|---|---|---|
| none (HQ) | node 1 in 69% | **17% / 17%** | 0% / 0% |
| 2 | node 3 in 55% | 75% / 71% | 52% / 46% |
| **3 (ruled)** | node 4 in 43%, 5 in 30% | **86% / 89%** | 76% / 72% |
| 4 | node 5 in 50% | 90% / 94% | 85% / 85% |
| 5 | node 6 in 51%; none by node 7 in 23% | 96% / 97% | 90% / 91% |

**Three moves the reason from almost never satisfied to mostly.** What is left is at node 4: **where the first trade node
is node 4, 75% can pay 150 (78% declining events)**, and at node 5 93–97%. **The cause is what fills the gated columns**:
the generator places events after the trade nodes, roomiest column first, and with the trade nodes kept out, columns 1–3
are the roomiest left — **2.8 of the zone's 5 events land in them** (`check_hr` §3: over 80 first-zone boards, those
columns held 390 fights, 231 events and 77 elites). An event pays no gold, so a run whose first three nodes held two of
them reaches node 4 with 105–120.

**The measurement is the argument — and it argues for the events, not the number**: with events kept out of the gated
columns as well (a variant, measured the same way), **100% can pay 150 at node 4**, and 99.7–100% at the first trade node
overall. A fourth gated node reaches 90–94%. **Built: three, as ruled. Proposed: three, with the events kept out of the
same columns** (NEEDS A RULING 2).

### §3d — WHAT THE GENERATOR DOES WITH THE CONSTRAINT

- **No zone's shape can fail it.** A first-zone board keeps eleven columns for six smiths and five merchants, one of each a
  column; at the narrowest — every column two wide, an elite in six of them — eleven columns hold 16 free positions after
  the elites, for eleven placements in distinct columns, and the roomiest-first order never paints itself into a corner.
  **Over 240 boards a zone (`check_hr` §3a, at HR's 80 a zone in the battery), no board ran short of a kind** —
  six elites, six smiths, five merchants and five events every time — and `test_batch_bk` §2's *exactly six/five a zone*
  reads 130 / 0 over its thousand maps.
- **What it substitutes**: events (most of the zone's) and fights; an elite still stands in column 2 or 3 on nearly every
  board, as before.
- **The first zone does not run short of node kinds.** Later zones are unchanged: across 160 later-zone boards trade nodes
  stand in their first three columns as before.
- **A whole run's boards**: sixteen, sixteen and seventeen columns (`check_hr` §3c).

### §3e — THE BARGAIN'S BOUGHT MERCHANT

A severity-4 bargain may pay *a merchant follows the fight* instead of 220 gold, and an elite can stand in column 2 or 3.
Under the sim's bargain policy the merchant is bought after an elite at **node 2 in 8.4% of unsteered runs and node 3 in
2.6%** (12.5% and 4.2% on the greedy route). It is not a map node; the player chose it over the bargain's gold; and
`run_state`'s record says it survives *because it is BOUGHT rather than rolled*. **Left as it is** (NEEDS A RULING 3).

## §4 — THE CENSUS: BURN AND CHILLED, AND WHAT A CANCELLATION WOULD TOUCH

**Nothing was authored or built.** The mechanic as the designer described it, so the census is aimed at it: *applying
Burn to a target carrying Chilled, or Chilled to one carrying Burn, consumes both — the standing status removed, the
arriving one not landing — and the clash pays something, so the player does it on purpose: chill, then burn.* **It is the
combo family reached without HL §4's machinery**: HL recorded that cards wanting to follow each other with no turn between
need something that reads what was cast last turn, and nothing does; **this reads a status on the target, which the game
reads everywhere** — `has_status`, the status door, a dozen readers below.

The census read every spelling of the ids across `scripts/`, `data/` and the documents (a read-only pass), and its load-
bearing claims were checked again at the code: the enemy table (only two kinds lay Burn; none lays Chilled or Frozen),
`unit.add_status`'s re-application branches, `DOT_STATUSES`, the merged Mage pool and the engine gates, Choking Smoke's
shelf. **The ids**: `burn` and `chilled` and `frozen` (all in `DEBUFF_IDS`); the families around them — `slow_burn`,
`emberkeep`, `immolate` on the fire side, `frostbite`, `rime`, `rimeguard`, `frostbind` on the ice side. There is no status
called *freeze*, *frost*, *chill*, *ignite* or *wet*. The Cryomancer's engine id is `permafrost`; its player-facing name is
**Glacial Hold**.

### §4a — WHO APPLIES THEM

**Hero → enemy, live.**

| | the Mage | another class |
|---|---|---|
| **Burn** | Flamewave (Overburn's enabler: 2, 3 Perfect; +2/+3 on an enemy already burning), Fireball (3 a hit), Firestorm (6–8 bolts, 2 each), Ember Debt (12), Detonation's Perfect (2), Immolate (3 on a non-hero that strikes him), Pyre Wake (1-turn fires from consumed Burn), Firedraw (moves Burn); Emberkeep doubles every hero's Burn for 4 turns; Backdraft and Stoke lengthen it; runes Ember Leap, Chain Fire | **the Hunter**: *Choking Smoke* (Survivalist shelf, any Hunter — Burn 2 on every enemy); *Downwind* (+ the Carrion rune) copies any hero's Burn or Chilled to another enemy; **the Cleric**: Unburden with the *Returned Burden* rune casts what it lifts off a hero back onto an enemy — a hero's Burn or Chilled included |
| **Chilled** | Razor Ice (Glacial Hold's enabler, 3 stacks), Frostbolt (1), Blizzard (1–2 on every enemy), Killing Frost (+2/+3 on the chilled), Hoarfrost Armor (2 on a striker), Glacial Prison (1, then a freeze), Frostbind (copies Chilled between two), Rime (echoes each stack); Rimebinding, Deep Winter and Cryoclasm for a Glacial Hold holder; runes Glass Prison, Second Winter | Downwind and Returned Burden, as above — copies only |
| **Frozen** | a fourth stack of Chilled freezes (a hold, with Glacial Hold slotted); Glacial Prison | only where a copy carries a body to four stacks |

**A Warrior applies none of the three.** No talent, relic, item, event effect or companion applies any of them (relics
*Emberheart* and *Frostbound Sigil* scale a hit's type, never a status). Retired and dormant sources — the Cinder Trail and
Long Burn runes, Aftershock, Wildfire Spread, Chain Ignition, Backblast, the winter talents — are listed in the census with
the reason each is not live.

**Enemy → hero, live.** **Burn**: the Ashblade's *Flame Lick* (Burn 2 at 60%, the Scarlands only) and the Ash-Wrought
Tyrant's *Immolating Wave* (Burn 2 at 80% on every hero struck, the Scarlands' boss). **Chilled: no enemy.** The only
Chilled a hero ever carries is the **Hoarfrost bargain** (severity 1, *everyone begins the fight Chilled*: 1 stack for 3
turns on every hero and every enemy, before an elite or a mini-boss). **Frozen on a hero is unreachable**: it needs four
stacks, a hero gets one, and a hold excludes heroes. **HO's finding confirmed and completed.**

### §4b — A MAGE MECHANIC OR A PARTY MECHANIC

**The engines that read the two are the Mage's; the statuses are not.** One Mage can hold fire and ice cards together: the
merged pool (`Classes.draft_pool("mage")`, 51 cards) offers **every fire card to any Mage — Overburn gates none** (it has no
`ENGINE_READ` row) — and nine of the fourteen ice cards; **five are offered only with Glacial Hold slotted** (Winter's Toll,
Rimebinding, Cryoclasm, Shatter, Deep Winter). A Mage may slot both engines (two core slots, nothing forbids the pair) and
opens with both enablers. **And it is already a party combo**: a Hunter's Choking Smoke burns what a Mage chilled, Downwind
carries a Mage's Chilled or Burn to other bodies (keeping its applier, so a copied Glacial Hold chill is permanent), a
Cleric's Returned Burden casts a hero's statuses back, and under the Hoarfrost bargain every enemy opens chilled for
anyone's Burn. **Measured** (§4f): in party A the Beastmaster's Choking Smoke was 6 of the 81 burns that landed on a
chilled enemy; a Warrior has no Burn source at all.

### §4c — WHAT READS EACH ONE (the cost side)

**Burn**: its own tick (6% of the applier's Attack, fire resist applies; the tick reaches every damage-taken reader);
**Overburn** (+2% damage per burn-turn on the field, to +40%, and the Mana refund for consumed turns, with the Pyre Debt
and Ember Leap runes); **Detonation**, **Wildfire**, **Cinderfall**, **Funeral Pyre**, **Pyre Wake** and **Firedraw**, which
consume or move it; Pyroblast (×1.5 on a burning target), Stoke, Backdraft, Flamewave, Emberkeep; the usability gates of
five fire cards; the hero bot's Mage rotation; a held body's Burn counts for Overburn and is skimmed by Wildfire and
Cinderfall. **Chilled**: speed (×0.75 at one stack, ×0.5 at two or more); the bearer's damage ×0.85 at three or more;
the fourth stack's freeze or hold; Glacial Hold's permanence; **Ice Lance** (+5% a stack), Cold Snap and Killing Cold
(runes), Killing Frost, Rimebinding, Deep Winter, Cryoclasm, Glacial Prison and Glass Prison; the Hunter's **Snare Line**
(a chilled target's snare stuns two turns, not one); the Ritual Chanter's cleanse. **Frozen**: the turn loop and the hold
(off the timeline), +15% from hero strikes on a held body, Ice Lance (always crits, releases), Cold Iron (×2), Shatter and
Winter's Toll, the release door. **Shared**: `DEBUFF_IDS` membership makes all three refused by Hallowed, copied by
Downwind, cleansable, refreshed by Loaded Shot and counted by **every breadth reader** — the Trapper engine (+8% a
distinct status), Hunt, Thick Hide, Salve, Cull, Harvest, the Iron Will talent and Sanctity's events — so Burn and Chilled
standing together count as two afflictions. **A cancellation starves every reader of the status it eats**, Fellowship's
precedent: the cleansing layer it would have deleted was worth 1.9% of damage taken, and for that it made Unburden, the
Returned Burden rune, two talents, the Medic core rune and four cards redundant (`CLAUDE.md`, the crest block).

### §4d — CAN THEY COEXIST TODAY?

**Yes: nothing removes one when the other lands.** `unit.add_status` resolves each id on its own, and `_apply_status` has
no cross-status removal; the only cross-status write is a freeze rewriting the Chilled pile. **What already relies on
their standing together**: Firedraw's deep draw (9 turns, not 6, from a burning enemy carrying another spec's debuff —
Chilled qualifies, and the code's comment names the Cryomancer's chill as the case); every breadth reader above; Burn on a
held body (it neither ticks nor counts down while held, still counts for Overburn, and Detonation, Pyroblast and Stoke get
the hold window on it); Burn on a Frostbind pair (each tick mirrors 40% to the partner); and every Hoarfrost fight. **No
card applies both, and no enemy has both.**

### §4e — IS THERE A PRECEDENT FOR ONE STATUS REMOVING ANOTHER?

**No — this would be the first.** The generic removals take *a* debuff or all of them (`dispel_one_debuff`,
`purge_debuffs`, the Cleansing Draught's `_cleansable_debuffs`); casts consume their own status (Detonation and the fire
cards consume Burn; Ice Lance, Shatter and Cryoclasm take Frozen). **The nearest shapes**: a standing status that refuses
specific arriving ids (Ironclad refuses Stunned, Frozen and Dazed; Hallowed refuses every debuff) — refusal on landing
without being consumed; a freeze rewriting the Chilled pile (and *a Freeze no longer wipes the Chilled pile*, Batch O, so a
freeze once removed it); Frozen or Stunned cancelling an enemy's wind-up. **No status removes a different, specific status
when it lands.**

### §4f — WHAT EACH IS WORTH, AND WHAT A CLASH WOULD EAT

**Static.** **Burn** ticks at the start of the bearer's turn for 6% of the applier's Attack (both modifiers dormant or
retired), N turns giving N ticks; fire resist applies, armor, crit and Break do not; **re-applied, its turns ADD** and the
tick is the newest applier's; authored durations 1–3 (12 for Ember Debt), doubled by Emberkeep. **Chilled** slows (×0.75
at one stack, ×0.5 from two) and, at three or more, cuts the bearer's blows by 15%; no damage of its own; **re-applied,
it adds a stack (cap four) and SETS the clock** to the new application's turns — 3 for most sources, permanent from a
Glacial Hold holder. **Frozen** costs one turn (an ordinary freeze; Burn still ticks) or holds the body off the timeline
(Glacial Hold: +15% from hero strikes, Shatter pays by turns held).

**Measured — what a second application meets.** The same instrumented lanes as §1c logged every Burn landing on a chilled
body and every Chilled or Frozen landing on a burning one, with the standing status as it stood (150 full runs, about
2,000 fights a party):

| | party A (Cryomancer) | party B (Pyromancer) |
|---|---|---|
| clashes a fight | 0.63 (1,278) | 0.44 (877) |
| **Chilled arriving on a burning enemy** | 1,068: the Burn had **2.45 turns left** (median 2) at **9.5** a tick | 575: **1.96 turns** (median 1) at **8.8** |
| Frozen arriving on a burning enemy | 129: 2.75 turns left | 184: 2.22 turns left |
| **Burn arriving on a chilled enemy** | 81: the pile **permanent** (Glacial Hold) at **2.9 stacks**; the Burn arriving 2.2 turns at 9.7 | 118: the pile 1.7 turns left at 1.5 stacks; the Burn 2.3 turns at 8.8 |
| who | the Cryomancer (75 of the burns: drafted fire cards), the Beastmaster (6: Choking Smoke) | the Pyromancer (117), the Sharpshooter (1) |

**So, as a figure a clash can be priced against**: Chilled landing on Burn would eat about **two turns of Burn, ~18–23
damage**, plus the arriving Chilled's three turns of slow; Burn landing on Chilled would eat a pile worth its slow (and
at three stacks a 15% damage cut) — **permanent under Glacial Hold** — plus the arriving Burn's **~20 damage**. **The
order the sim measures is fire then ice** (the bot casts the Mage's fire cards before his ice cards), so *chill then burn*
is the rarer clash in the logs; a player doing it on purpose changes that mix, not the figures. **No hero-side clash
was seen** in 300 runs: it needs the Hoarfrost bargain in a Scarlands fight with an Ashblade (§4g).

### §4g — WOULD IT HURT THE PLAYER?

**Under a symmetric reading, yes, narrowly.** An enemy burning a chilled hero needs **a Scarlands elite or mini-boss fight
taken under the Hoarfrost bargain, an Ashblade in the warband** (a skirmisher the elite themes draw), and Flame Lick landing
inside the chill's three turns. **Never with the Tyrant** (a boss takes no bargain, and the third rung's fixed modifier is
severity 3 or more). **The order on a hero is always Chilled first, Burn second** — no enemy chills. A companion can carry
both, but its Burn never ticks. **What it would touch on the hero side**: the chilled hero's slow, a 2-turn Burn at 6% of
an Ashblade's Attack, the Iron Will count, what the cleanses would otherwise take (Field Medic, Unburden and Returned
Burden, Dispel, Field Dressing, the Cleansing Draught, the Field Kit engine), Sanctity's events, and the Burn tick's
damage-door effects (Leech pays it in Mana, Covenant splits it, it can cross the Mercy window, Blood Frenzy reads it). **The
party's own mirror is every Hoarfrost fight**: all enemies open chilled.

### §4h — WHERE THE DOCUMENTS DISAGREE WITH THE CODE (found by the census, not fixed)

`master.html` pays Shatter *per stack of Chilled* (the code pays per turn held, capped at 12, as the card says); gives the
hold window *+15% from all sources* (the code: hero strikes only, as the glossary says); has Firedraw take *what is there or
4* (the code always takes 6); has Emberkeep double *every Burn he applies* in one row and *any hero's* in another (the code:
any hero's) and says it makes Flamewave lay 4 on everyone (Flamewave on a burning body skips the doubling); says only the
Tyrant's frost weakness is set (many kinds carry fire and frost weaknesses); and names four Overburn refund consumers
(the code pays six). `CLAUDE.md`'s DR §1 block lists Burn and Chilled among statuses exclusive to a class (they have Hunter
and Cleric appliers); its recast block says a re-application resolves as `max()` (Burn adds and Chilled resets).
`docs/combat-rules.md` calls Burn's stored crit snapshot *a BURN MAGNITUDE* (nothing reads it). Code comments: *no Mage
holds both spec pools* (two in `battle.gd`), Immolate *reads Overburn* (`classes.gd`), *Hoarfrost plus an enemy chill can
reach* a hero (no enemy chills), *burn = Pyromancer* (the tick credits the first hero named Pyromancer whoever applied
it), Phoenix Rebirth citing Overburn's deleted drain. **Queued in `docs/state.md`.**

## §5 — DELIBERATELY NOT DONE

- **The opposed-status mechanic is not built** (§4): no status, no payout, no card, no text.
- **The Skirmisher and the Tracker are still ruled and not built**, with Volley's and Ambusher's core slots and both new
  names owed — authored in conversation.
- **Channel's tempo payout is not built.**
- **Whether a fallen hero stays down between fights is still open**; *The Cairn of the Fallen* and a map Revive Potion
  wait on it.
- **Tithe's read site is not widened**; the talent rebalance stays owed. §0 changed what both texts SAY about the site,
  never what it pays.
- **No rune is authored**, and the crest is still one slot (`Run.PARTY_RUNE_SLOTS`).
- **`heroes_class_count` still reads a named class** — no OR, no list.
- **`CLAUDE.md` is not split**; the shape recon stays queued and is the nearest owed instrument work (§8).

## §6 — THE VERIFICATION

### §6a — THE SAVES, BEFORE ANYTHING

Backed up first and verified by hash: `../save-backups/HR-20261005-102217`, the four files byte-identical to the live
ones at 10:22:17. **Against HQ's backup (`../save-backups/HQ-20261001-110254`)**: `relics.json` and `settings.cfg` are
identical; **`profile.json` moved** (09:16 on 5 October: `runs_started` rose by twelve across eight keys — `arcanist`
+2, `cleric` +3, `warrior` +2, and one each on `hunter`, `mystic`, `pyromancer`, `sharpshooter` and `warden` — one more
*Collector's Grave* and one more *Cursed Idol* seen, and some figures written as integers where floats stood);
**`run_save.bin` moved** (10:13 on 5 October): a v14 run at the third rung, in the first zone at `slot_idx` 10 (node 2),
nine wins, 863 gold, **debug used**, a bag of three — *Clarity* and *Overtone* (the Mage's) and *Tithe* (the crest's) —
with *Dirge* worn in the crest, and every hero wearing one rune and his core runes. No Godot process was running.

### §6b — HEAD'S GATES AGAINST THE NEW GAME, BEFORE ANY GATE WAS EDITED

**The prediction was stamped first** (11:17:22), and the recon launched behind it: an isolated copy of HEAD — its gates,
runner, baselines, manifest and documents — with HR's game files laid over it, its user data seeded from the backup. **HEAD's copies of the gates most likely to move were also run against the new game before any gate was edited**
(11:34–11:36, `check_hk` first; the first re-point is at 11:38). **131 targets in 79 min 40 s** (11:17:22 → 12:37:02,
beside the supply lanes for its first half); `check_de` 541 / 20 / 1 notice.

| target | HEAD's copy on HR's game | why |
|---|---|---|
| `check_hk` | 149 / 57, one throw | HK's own gate reads the bag's model throughout — its drop into the bag, its twenty, its purchase into the bag, its v13 migration into the bag (the throw is §2 indexing a bag of six as one of twenty) |
| `check_gt` | 3237 / 154 | §1: a held row now reads *(held)* beside its Drop, so the rule-drawn-whole reading found no row it recognised, and its longest case was a full bag of twenty; an unslotted engine and a purchase were looked for in the bag |
| `check_gs` | 824 / 50 | §4: the full-bag panel, filled with engine runes in a bag of twenty, and the sale rows, read off the bag |
| `check_gx` | 1366 / 43 | **not predicted.** 42 at §3: HR's nameplate marker is a button bound to the same rune panel, and the slot sweep counted it — four slot buttons with the engine out (its rune held, so the marker drawn), three with it in. **One at §4 was a real defect, already fixed in the tree**: the recon's game was copied at 11:17, before HR narrowed a held row's label by its Drop (11:48), so held rows ran 74 px past the panel and Close widened with them (1028, and 1036 once the worst case scrolled). On the finished tree Close is 1000 px in every arm, and the worst case scrolls by 25 px with the scrollbar inside the panel's width (962 of 1000) — GT §1's rule holds |
| `check_hl` | 168 / 12, one throw | §5 pinned `SAVE_VERSION == 14` and stamped a v15 file as *newer*, which this build now loads; §1a/§1c read a cache's core rune and a bought rune in the bag |
| `check_hp` | 168 / 3 | ruling 1's words; ruling 3 inverts §1c |
| `check_fh` | 167 / 2 | §3's purchase arm, a coin flip on HR's game (§6c) |
| `check_hn` | 74 / 2 | §2a looked for the renamed rune in the bag |
| `check_ho` | 176 / 1 | §1d: the crest drop's toast — HR had reworded HO's line; it is restored, so the game changed and not the gate |
| `test_batch_bx` | 159 / 1 | **not predicted**: two of HR's new strings said *party* (§4b); both reworded in the game |
| `check_go` | 401 / 1 | **not predicted**: §12's live stretch with no lineage — the Reaver never fired in 6000 frames (§6c) |
| `check_gj` | 70 / 1 | the sanctioned red, its figures moved: card +174 against a purse of +194 (HP's +175 / 195) |
| `check_cm_live` | 13 / 4 | the sanctioned red, unmoved |
| `test_batch_bk` | TIMED OUT at 240 s | the recon ran beside the supply lanes; stopped, and run alone it read 130 / 0 in 142 s |

**Predicted and did not move**: `check_fd` (58 / 0), `check_he` (258 / 0), `check_hf` (314 / 0), `check_gv` (1057 / 0),
`check_gp` (469 / 0), `check_ea` (236 / 0), `check_ed` (18 / 0), `test_batch_an` (6051, inside its band),
`test_batch_bl` (88) and `test_batch_bm` (773) — none of them reads a class rune out of the bag, and nothing pins the
version. The run harness read PASS 22 / 382 / 8, `check_ct_map` 83 / 0, `check_map_screen` complete, and **every target
not in the table read its recorded row** — `check_de` named no other. **One green target moved: `check_gp` fell 474 →
469**, attributed in §6c.

### §6c — WHAT WAS RE-POINTED, AND WHY

**Every edit below came after HEAD's own copy was run against the new game** (§6b), and each carries its reason at the
place in the gate, marked *BATCH HR*. **Each is a re-point to the gate's intent — the bag and the holdings moved under
it — and no arm was deleted.**

- **`check_hk`** (HK's own gate; HEAD's copy read 149 / 57 and one throw, 146 in an unseeded copy): §1 — a drop is
  held where its kind lands (a class or core rune on the hero of its class, a crest rune in the crest or the bag),
  read by `_row_held` and `_unworn` rather than the bag's size; §1h — an engine unslotted is held on him, so it goes
  back into its slot from his own rows; **§2 rewritten for the holdings**: a full holding queues a rune for that
  hero's panel (`_fill_holding` fills one from his class's data entries, which `eligible_ids` could not reach eight
  from), the panel offers his eight, dropping one takes the waiting rune, declining leaves it, an unequip into a full
  holding is refused and a swap is not, the bag holds crest runes only; §3 — a purchase lands on the hero, the sale
  rows list his held runes, and a full holding greys his Buy with the sentence; §5 — a v13 save keeps every rune on
  its hero, rune for rune over the saved party; §6 — the bot declines a rune for a full holding; §7 — the road
  pre-fills each hero to seven so a drop meets a full holding, tracks the most any hero held, and sells through the
  screen's own `_sale_rows`. **167 checks.**
- **`check_hl`** (HEAD's copy read 168 / 12 and one throw): §1a and §1c — a cache's core rune and a bought rune are
  held unworn on their hero (`_hr_unworn`), and the hero's nameplate counts the bought rune; §2e — the rune's place
  searched across the bag and the holdings; **§5 pinned the save version as a literal** (`SAVE_VERSION == 14`, and a
  stamped 15 for *newer*), which `docs/instrument-rules.md` forbids (BK §6): newer is `SAVE_VERSION + 1` and the
  version is asserted at or above HL's. **169 checks.**
- **`check_hn`** (HEAD's copy read 74 / 2): §2a — the rune's place searched across the holdings. **74 checks.**
- **`check_hp`** (HEAD's copy read 168 / 3): §4 — the two texts' words (`TITHE_WORDS`, `TALENT_WORDS`), the old
  reading (`READING_WAS`) gone from both and from the document, and a new arm: the shared site compares share; §1c —
  HQ asserted a refused entry IS offered, the route as it stood; ruling 3 inverts it, and a payable twin keeps it from
  passing on an empty pool. **171 checks.**
- **`check_fh`** (HEAD's copy read 167 / 2 in the recon, and 167 / 2 on two other lines in an unseeded copy): **§3's
  purchase arm was a coin flip on HR's game** — it buys the Peddler's first offer, and HK's arm asked the bag for it:
  green whenever the roll put a crest rune first (*Dead Air*, in the unseeded copy), red whenever it put a class rune
  first (the recon). Each kind is now asked its own question — a crest rune into the bag, a class rune held unworn by
  the hero it was offered to — the kind bought is printed, and **the arm buys a class rune through that row's own Buy
  whenever the counter holds one**, since a crest rune's purchase cannot show a class rune sent the wrong way (control
  R39 read the re-pointed arm green on a crest draw; against the arm as it ships, R39 reads it red on both lines).
  §3's cache arm asks where each kind lands (the full-holding panel is the full-bag panel's successor); §9b — **a
  latent coin flip since HP**: with four crest runes in the pool a seeded draw could put the crest's rune where the
  arm wanted a hero's, and HR's shifted draw surfaced it; the arm now holds the crest runes first and prints its
  grants. **167 checks.**
- **`check_gt`** (HEAD's copy read 3237 / 154): §1 — a rune offered on the pouch is seated unworn on its hero, a held
  row reads *(held)*, the toggle arm reads an engine taken off from his engines rather than the bag; §2 — a purchase
  is held on its hero; §3 — a dropped engine is held; the longest pouch is a full holding of eight held rows, two
  buttons a row. **3477 checks.**
- **`check_gs`** (HEAD's copy read 824 / 50): §4 — the full panel is reached through a full holding; the sale rows
  read *(held by …)*. **824 checks.**
- **`check_gx`** (HEAD's copy read 1366 / 43): §3's slot sweep found a seat's rune slots by the door they open, and
  HR's nameplate marker opens the same door — it is left out by its `held_marker` meta, and a paired arm asks for the
  marker itself: ✦ 1 with the engine out (its rune held unworn), none with it in, for every gated rune. **1367
  checks.**
- **`check_go`** (HEAD's copy read 401 / 1): **§12 was a coin flip HR's dice lost.** Its live stretch keeps one foe
  fragile (60 health) so kills are on the table; the bots strike the foe lowest by SHARE (`_lowest_hp`), and the two
  deep foes, reset to full below half, sit between half and full — so at 60 of 60 the fragile one was nobody's mark
  once the deep two were touched. It fell once, to the opening volley, while every foe was at full and the ties went
  to the first in the list. **The Reaver is paid only for its holder's own kill**, so it fired only if the Warrior
  landed that one: HEAD's dice gave it to him (the Reaver *fells* at the log's 23rd line), HR's to the Cleric (a Smite
  after a Quick Shot, the 14th), and in 6000 frames the Raider died once. **Attributed**: on HR's tree with the shop
  gate set to zero, HEAD's stretch reads green with HEAD's timings to the frame. **Repaired by construction, not by
  waiting**: the fragile foe stands at 29 of 60, under half, so it is the lowest share whenever it stands and every
  hero's kill comes round. Green on HR's tree (the Reaver at 40 frames, all eight within 480) and on HEAD's (within
  260); **with the Reaver's read cut, both of its stretches read silent** (and §2's Reaver arms, ten lines). **401
  checks.**
- **`check_gp`** — untouched, and its count moved **474 → 469**, attributed by an ok() trace in three seeded copies:
  HEAD's tree read 474; HR's tree with the shop gate set to zero read 474 **message for message HEAD's, in order**;
  HR's tree read 469, every difference in §4's dice-driven families (the per-class fallback offers and *the
  engine-less X was OFFERED Y*: 50 out, 45 in). The gate's seeded road walks a run, and HR §3 changed the run's first
  board.
- **`run_battery.sh`** runs `check_hr`, after `check_hp`.

### §6d — THE CONTROLS

**Forty-two controls, one defect each, in isolated copies of the finished tree** (a scratch runner: each control's patch
applied to a fresh APFS clone, its gates run, the FAIL text read — never the count). **Every one went red on the arm it
aimed at.** R20's want named §3b's first press and the arm reddened on its second; R06, R22, R25 and R42 also threw in
later sections of a gate the defect had already reddened. Two controls found more than they aimed at, and both findings
are repaired: **R30** (the gate at twelve nodes, which only moves the dice) drew a crest rune through `check_hr` §1d's
event verb — a coin flip in HR's own gate, now constructed (§6c's rule); against the fixed gate, the gate at twelve and at
zero redden §3 alone. **R39** (a purchase into the bag) left `check_fh` green on a crest draw; the arm now buys a class rune
through its own row, and R39 reds it on both lines.

| | the defect | red (failures) | the first line it printed |
|---|---|---|---|
| R01 | eligible_ids offers a refused entry again | `check_hr` 5, `check_hp` 1 | §0a: `eligible_ids` offers the refused entry to ["warrior", "mage", "cleric", "hunter"] |
| R02 | the short-offer lists name a refused entry | `check_hr` 1 | §0a: a list that says why an offer is short names a refused entry for ["warrior", "mage", "cleric", "hunter"] |
| R03 | the talent back to the lowest-health hero | `check_hr` 1, `check_hp` 2 | §0b: the talent's words or Tithe's do not say *the hero furthest from full* (A hero's attack that lands Break heals t… |
| R04 | Tithe back to whoever among the four is lowest | `check_hr` 1, `check_hp` 2 | §0b: the talent's words or Tithe's do not say *the hero furthest from full* (A hero's attack that lands Break heals w… |
| R05 | the Break-heal site picks by points, not share | `check_hr` 2, `check_hp` 1 | §0b: the site picked Cryomancer, not the Warrior at 100/223 — it is not the share comparison the words say |
| R06 | a class rune not worn goes into the bag (HK) | `check_hr` 22 (2 throws), `check_hk` 11 (2 throws) | §1a: a Mage rune handed over in the Warrior's name went bag — not held by the Mage |
| R07 | a rune is held by whoever it was handed to, class or not | `check_hr` 1 | §1a: a Mage rune handed over in the Warrior's name went held — not held by the Mage |
| R08 | a hero holds nine | `check_hr` 10, `check_hk` 2 | §1: a hero holds 9 unworn — PROPOSED at HR §1 as 8 |
| R09 | the held count counts what he wears | `check_hr` 15 | §1b: eight Mage runes, six ordinary and two core, held 7 (count 8) |
| R10 | a full holding takes the rune anyway | `check_hr` 9, `check_hk` 14 | §1b: the ninth Mage rune was not queued for the Mage's panel |
| R11 | an unequip asks the bag, not his holding (HK) | `check_hr` 1, `check_hk` 2 | §1c: an unequip into a full holding was not refused with its sentence () |
| R12 | a swap asks for a bag row (HK) | `check_hr` 1, `check_hk` 1 | §1c: a swap on a full holding did not put Chain Fire on and keep Long Fuse held |
| R13 | the Peddler sells into a full holding | `check_hr` 1 | §1d: a purchase for a full holding was not refused before the gold moved (Cleric holds 8 unworn runes, the most he |
| R14 | a held rune sells for nothing | `check_hr` 1 | §1d: selling a held rune did not pay and take it from him |
| R15 | the event line does not say the rune is held | `check_hr` 1 | §1d: the event verb with every slot full did not leave the rune held on its taker (RUNE: Unravel (Pyromancer)) |
| R16 | the load does not hand the bag out | `check_hr` 6 | §1e: the Mage was not handed his two runes in the bag's order and his core rune ([]) |
| R17 | a rune with no hero here is destroyed on load | `check_hr` 3 | §1e: the bag after the load holds ["Tithe"] — want the crest rune and the Hunter's |
| R18 | the save version not bumped | `check_hr` 1 | §1e: the save is written as version 14 — the bag's meaning moved and the version did not |
| R19 | his panel says nothing of what he holds | `check_hr` 1 | §1f: the Mage's panel does not say what he holds |
| R20 | the Sell rows leave out the heroes' held runes | `check_hr` 1, `check_hk` 4 | §1f: the Sell rows do not list the Mage's held runes under his name |
| R21 | the run summary has no held line | `check_hr` 1 | §1f: the run summary has no line for the runes a hero holds unworn |
| R22 | the nameplate marker is never drawn | `check_hr` 2 (1 throw), `check_hl` 1 | §2: the Beastmaster's nameplate does not mark one rune waiting (<no marker>) |
| R23 | the marker counts slotted core runes too | `check_hr` 7 | §2: a nameplate shows a marker before anything is held |
| R24 | the map does not announce the drop | `check_hr` 2 | §2: the map's toast does not name the drop and the Beastmaster |
| R25 | the drop is not recorded for the map | `check_hr` 5 (1 throw) | §1d: the drop landed held on hero 3, not held by the Hunter and recorded for the map |
| R26 | the bag row carries no crest marker | `check_hr` 3 | §2: the bag's row does not mark the 4 crest runes in it |
| R27 | the gate is gone | `check_hr` 2 | §3a: 381 Peddlers or Smiths stood in zone 1's first 3 columns |
| R28 | the gate on every zone | `check_hr` 1 | §3a: no zone after the first put a Peddler or a Smith in its first 3 columns in 160 boards — the gate is the run's, n… |
| R29 | the gate at two nodes | `check_hr` 1 | §3: the gate is 2 nodes — ruled at three, measured at HR §3 |
| R30 | a gate that starves the zone | `check_hr` 3 | §1d: the event verb with every slot full did not leave the rune held on its taker (RUNE: Dirge (the crest) — into the… |
| R31 | the bag holds twenty again | `check_hr` 1, `check_hk` 1 | §1: the bag holds 20 — PROPOSED at HR §1 as 6 (four crest runes and two of headroom) |
| R32 | a waiting rune settles only into the bag | `check_hr` 2 | §1b: with a place free the waiting rune did not go straight in |
| R33 | the panel answers a hero's rune out of the bag | `check_hr` 2, `check_hk` 4 | §1b: taking the waiting rune did not drop Ashfall of his for it |
| R34 | the full panel lists the bag for a hero's rune | `check_hk` 10 | §2b: the panel offers 2 runes to drop, not his eight |
| R35 | the victory card names the class, not the hero | `check_hr` 1 | §2: the victory card does not name the drop and the Beastmaster |
| R36 | a core rune is held on his ordinary list | `check_hr` 2 | §1a: a core rune not asked for went held — not held unworn on his core list |
| R37 | the Peddler's Buy stays live on a full holding | `check_hk` 2 | §3c: on the Warrior's full holding his Buy is live, or its tooltip does not say why |
| R38 | an unslotted engine goes to the bag (HK) | `check_gt` 8, `check_hk` 7 | §1: Unequip did not move the engine's slot (slotted false, held false, the Sharpshooter's true) |
| R39 | a purchase goes into the bag whatever its kind (HK) | `check_hr` 1, `check_hl` 4, `check_gt` 12, `check_fh` 0, `check_hk` 2 | §1d: a rune bought for the Cleric is not held by him, or the price did not move |
| R40 | the rename on load skips what the heroes hold | `check_hn` 2, `check_hl` 1 | §2a: a saved rune named 'Fourth Stack' loaded as 'Rune of the Fourth Stack', not 'Forbearance' |
| R41 | the nameplate marker is never drawn (check_gx paired arm) | `check_gx` 1 | §3: the nameplate counted the held engine rune (✦ 1) for 0 of the gated with the engine out, and drew no marker for 4… |
| R42 | the marker carries no held_marker meta (the slot sweep keys on it) | `check_gx` 43, `check_hr` 2 (1 throw) | §3 ambush (engine out): 4 rune slot buttons — 3 expected |

**The repairs that are not HR's own arms were controlled where they were made** (§6c): `check_go` §12 with the Reaver's
read cut (both Reaver stretches silent, and §2's ten Reaver lines); `check_gx` §3 by R41 and R42 above; `check_fh` §3 by
R39; `check_hn` and `check_hl` §2e by R40. **Every attribution was a stub arm** — the shop gate at zero — and read HEAD's
trace or HEAD's stretch exactly.

### §6e — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass.** The prediction was stamped first (13:20:10): every target at its row in `baselines.json` as HR wrote
it, the two sanctioned reds at theirs (`check_cm_live` 13 / 4, `check_gj` 70 / 1 at +174 against +194), the run harness
PASS 22 / 382 / 8, and `check_de` 545 / 0 / 0 — HQ's 541 and four for `check_hr`'s row. Then an isolated copy of the
finished tree, **proved equal to it** (504 files hashed; the one difference its project name, which isolates its user
data), seeded from the backup and run alone: **132 targets in 75 min 05 s (13:20:34 → 14:35:39); `check_de` 545 / 0 /
0, every target at its predicted row** — `check_hr` 100, `check_hk` 167, `check_hl` 169, `check_hn` 74, `check_hp` 171,
`check_gx` 1367, `check_go` 401, `check_gp` 469, `check_gt` 3477, `check_gs` 824, `check_fh` 167, `check_ho` 176,
`check_parse` 206, `test_batch_bk` 131, `test_batch_an` 6055 inside its band — and no Parse Error, SCRIPT ERROR, TIMED
OUT or NO VERDICT line in any of the 132 logs.

**The acceptance run in the repository**, the tree frozen first (504 files hashed, absolute paths) and the player's
four files hashed beside it: **132 targets in 75 min 03 s (14:37:45 → 15:52:48); `check_de` 545 / 0 / 0.** Every target
read its row and its pre-pass reading but `test_batch_an`'s seeded count (6053 where the pre-pass read 6055, both inside
its band); the two sanctioned reds at their counts (`check_gj` at +174 / +194); the run harness PASS 22 / 382 / 8; no
Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any of the 132 logs. **The tree was byte-identical after it**
(504 files: md5, size and mtime), and **the player's four files are byte-identical — hash, size and mtime — to the 10:22
backup.** The pin manifest was regenerated between the two runs for six line references that the last two gate edits
moved (no pin added, removed or re-resided), and the changelog, `docs/state.md` and this report gained the pre-pass's
figures; the acceptance run read all of it. **After it, `docs/state.md` and this report gained the acceptance's
figures** — `docs/state.md` is read by `check_es` §4 and `check_hp` §5, and its three pins in the manifest are positive —
so the document instruments were run again over the final tree in an isolated copy: `check_es` 57, `check_hp` 171,
`check_ec` 24, `check_ed` 18, `check_fg` 22, `check_fr` 25 and `check_ff` 68, each 0 failures — what the battery read.

## §7 — FOUND AND NOT FIXED

- **The documents disagree with the code on fire and ice in sixteen places** — ten in the documents, six in code
  comments (§4h). None is on a card. Each is a sweep for the batch that touches its subject.
- **The sim never answers a bargain's rune cache**, so every supply figure it prints omits 0.8–1.15 runes a hero a run
  (§1c counts them separately).
- **The bot casts the Mage's fire cards before his ice cards**, so the sim's clashes are mostly ice landing on fire (§4f).
- **A stray rune cannot be made by play**: every roll is the party's classes. The path that keeps one and says so is
  driven only by a constructed save (`check_hr` §1e).
- **`check_hl` §5 pinned the save version as a literal** (`SAVE_VERSION == 14`, and a stamped 15 for *newer*), which
  `docs/instrument-rules.md` forbids (*A SUITE MUST NOT PIN THE SAVE VERSION LITERAL*, BK §6): the bump took it red. It
  is re-pointed (§6c) — newer is `SAVE_VERSION + 1`, and the version is asserted at or above the one HL built.
- **`check_fh` §9b had a latent coin flip since HP**: with four crest runes in the pool, a seeded draw could put the
  crest's rune where the arm expected a hero's. HR's seed shift surfaced it; the arm now holds the crest runes first.

## §8 — HOUSEKEEPING AND THE RULES FILE

- **HQ's eight isolated copies are in the Trash**, selected by the *"Dawn of Decay HQ "* prefix, under *"DoD spent
  user-data folders (Batch HQ's eight, cleared at HR 2026-10-05)"*: 8 folders, 1,880 KiB (HQ recorded 1,924 KiB, before
  its last runs settled). `app_userdata` went from 491 folders and 145,028 KiB to 483 and 143,148 KiB, HR's own copies in
  both readings; the older folders, the live *Dawn of Decay* folder and `../save-backups/` were not touched.
- **HR's own copies**: 53 folders, 11,152 KiB, every one named *"Dawn of Decay HR …"*: the recon, the pre-pass, the subset lanes, the
  control lanes and their base, the supply and gate-measurement lanes, the migration and ceiling drives, and the
  attribution and repair probes. They are HS's to clear, by the *"Dawn of Decay HR "* prefix.
- **`CLAUDE.md`**: 427,586 B = 417.56 KiB, **52.44 KiB under its 470 KiB ceiling** (+2,818 B at HR: the drop-and-bag block
  rewritten, the shop-gate block, the refused-rune bullet, the stale bag lines swept, two index rows). About 6.5 batches at
  the record (EZ's +8,293 B), 6.8 at HP's +7,935 B, 19.1 at HR's own. Not split (§5); the shape recon is the nearest owed
  instrument work.
- **Two new instrument rules** (`docs/instrument-rules.md`, indexed in `CLAUDE.md`): *A TIMED SCREEN ELEMENT IS READ AT
  TIME SCALE ONE* — `Gate.frames` steps at a hundred times the clock, so the map's toast, which fades in 1.9 seconds of
  game time, is gone two frames after it appears and an arm reading it reads nothing; `check_hr` reads its toasts at
  scale one. And *AN ARM THAT READS WHAT THE DICE DEALT IS A COIN FLIP THE NEXT BATCH CAN LOSE* — §6c's three: attribute
  the move with a stub arm, construct the state the arm asks about, and prove the repair by breaking what it reads.
