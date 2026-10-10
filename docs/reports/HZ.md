# BATCH HZ — THE EYES, AND THE RAGE DUMP

**On `class-merge`, from `464bf14` (HY). IMPLEMENT ONLY.** **§0: HY's three rulings are answered** — the vow's carried half is
the dealer's damage on a second body (`_on_vow_share` keeps the frame it found: the Devout's ledger books the raider, a Devout
the share fells is the raider's kill, Penance mirrors on both bodies, a Covenant-bound Devout shares the carried half; the
swing's riders fire once and nothing re-enters), and a bomb naming nobody and Consecrated Ground's reflect being its layer's are
confirmed as built and recorded. **§1: four surfaces show the player what the game already knows** — an enemy's declared attack
in detail on hover (what it does, never whom it is aimed at), a read-only kit preview from every draft and from the Peddler, the
nameplate as a second hit area while targeting, and rune chips that say what is paying now, ARMED or PAYING, the crest's as one
chip. **§2: Boil Over is a Rage dump** — the whole bar, no cost of its own, a floor of 40% of it, 0.8% of Attack a point, priced
against every Rage card on one board: a full bar beats the best ordinary turn and does not beat two, and a floor cast is worse
than an ordinary card. **§3: the Sharpshooter's toast names the pet.** **§4: HY's ten copies are cleared.** **§6: two recons of
HEAD's whole battery — §0.1 alone, then all of HZ's code — and the second found what HZ moved in eleven gates**: the kit
preview's button stopped every road that answers a pick with the first button, the recovery's write moved two counts and two
lists, and a field HZ named threw in a gate; each was repaired to intent and controlled in the direction it changed — and the
subset caught HZ's own new gate setting its own precondition.

**VERDICT: LANDED.** HY's first ruling is built — the vow's carried half is the dealer's damage on a second body, one
line in the damage path, the stop clause not fired — and the other two are confirmed and recorded. **The four surfaces are built,
§1d included** (nothing above it grew), each driven on the real screens with its negative arm; **Boil Over is a Rage dump** whose
shape holds both ways on one board; the Sharpshooter's toast names the pet; HY's ten copies are cleared. HEAD's whole battery read
HZ's code twice, and every gate it moved was repaired to intent and controlled — six of them because a new button stood first on
the pick overlay; fifty-three controls broke their needles. The pre-pass and the acceptance run read `check_de` 577 / 0 / 0, and the
final tree's readers each read their acceptance reading. **Seven rulings owed, none blocking; the first two answer the designer's
own questions with figures.****

## NEEDS A RULING

1. **BOIL OVER'S RATE (§2)** — built at **0.8% of Attack a point of Rage poured out, with a floor of 40% of the bar**, chosen against
   the figures in §2 and carried with them in `docs/state.md` as a tuning handle. **Re-rule the number, the floor, or both**; `check_hz`
   §2 holds the shape the brief set as the pass condition, never the number.
2. **EMPTY PULPIT AND DEAD AIR PAY ONLY AFTER A FALL (§1d)** — the brief expected *never*. Every fight a run opens seats a Cleric and
   a Mage standing, so both open ARMED (HO §3c holds for the opening); **since HP §1 the condition is re-read at every death**, so each
   turns PAYING for the rest of a fight in which its class's hero falls — `check_hz` §1d drives Empty Pulpit across exactly that
   switch. Dirge is the same shape for any hero. The re-cut is the designer's; nothing is authored here.
3. **THE TELEGRAPH'S BAND (§1a)** — shown as the attack's own roll, the line a hero's own card quotes (`_damage_line`), before armor,
   resistance, Block and crit: a band, not a predicted blow, so BL's ruling (*no predicted damage number may ship*) is read as
   standing — the intent block itself computes nothing and `test_batch_bl`'s control holds. **Or** the percentage alone (one line).
4. **THE MIRROR'S ROUNDING ON A SPLIT BLOW (§0.1)** — Penance rounds per body, so a blow whose two parts are both odd mirrors one point
   more than the whole would: **18 → 9 + 9 mirrors 5 + 5 = 10 against 9** (`check_hy`'s A1, blow 3). At power 50 that is every blow of
   4k + 2. Keep it, or price the carried half's mirror as the whole blow's less the kept part's (more than a line).
5. **BOIL OVER'S PERFECT (§2)** — it shortened the recovery, and the recovery is gone, so it has none; the grade's harder Perfect blow
   still lands, as on every strike. `test_batch_cp` names it with the other checked cards that state no Perfect. Author one, or keep.
6. **LIFEWELL UNDER A VOWED GROUND (found at §1d)** — it heals the party off the reflect figure taken before the vow's gate, so a
   reflect the vow silenced still waters the party. Pay it on what landed (one line), or keep.
7. **TITHE'S CHIP (§1d)** — it carries no condition, so it reads PAYING whenever worn and says it pays at each Break. Keep, or show it
   only as it pays.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HY; premise 1 is HY's push hash | **Held**: `git ls-remote origin class-merge` = `464bf14c91f8e8db39045c16af14091176e7f6a3` = local HEAD, read before anything ran; the tree clean but the untracked `save-backups/` |
| 2 | HY's table found five premises wrong, two load-bearing: §1d's pass condition under the prescribed shape, and `take_hit`/`heal_amount` never moved | **Held**: HY's premises 8 (*not as figures*) and 25 (*`take_hit` and `heal_amount` did not move*), with 10, 17 and 9 the others it qualified |
| 3 | §0.1 is the reading under which HY's premise 8 holds: *the mirror's function loses its share term* | **Held, but for a point of rounding**: every arm reads one function now — the mirror on the whole blow, the wire on the whole blow, the reflect unless its layer wears the vow — and the mirror rounds per body (ruling 4) |
| 4 | *Penance's row is the card's own text — 50% of the damage it deals, whoever it hits — and the built reading makes it false* | **Held**: `docs/master.html`'s Penance row; under HY's reading the mirror paid on the Warden's half (HY's 4–6 against 8–11) |
| 5 | *A Devout killed by a blow he absorbed is currently a SUICIDE in the kill record* | **Held at HEAD**: the share's own frame made the Devout the dealer of his own death (`self` true, *themself / Vow of Suffering*); `check_hz` §0a reads the raider now, and HEAD's code reds it (H02) |
| 6 | THE RIDERS — the stop clause: *report whether the swing's own riders fire a second time on the carried half* | **They do not; the change ships.** The riders are applied in `_resolve` off the swing's result, once; the frame change reaches only the frame's readers, and on a hero body those are the vow's gate (returns at once: a hero is not an enemy), the Covenant's share (now shares — accepted), Penance (now mirrors — intended), the rule engines (return at once: a hero body), the death door's hero branch (frame-free) and the taken ledger. Driven: `check_hz` §0c |
| 7 | RE-ENTRANCY — *what stops the vow firing on its own carried half, and does that guard read the frame* | **Two guards, neither reads the frame**: the bill goes through `take_tick_damage`, which has no vow block (the vow's split lives only in `take_hit`), and `_on_vow_share` refuses `devout == ally`. Driven: `check_hz` §0d |
| 8 | *19 → 10 + 9 mirrors 5 + 5 and the whole blow mirrors 10, which agrees; say whether every split does* | **Not every split**: one where both parts are odd mirrors one more (18 → 9 + 9: 10 against 9); asserted per blow as never more than one body's rounding, every such blow printed (ruling 4) |
| 9 | *The Devout's taken ledger books the raider; a Covenant-bound Devout now shares the carried half* | **Held**, driven: `check_hy` §1 (the ledger) and `check_hz` §0b (the bound ally carries part of the carried half, booked to the raider) |
| 10 | *`check_hy` §1's table and §1d's stated function re-tune, the gate green, with a control on the line* | **Held**: 161 → 173 / 0 on HZ's code; C01 (the share borrowing again) reds the lines it aims at; HEAD's code reds them (H01) |
| 11 | §0.2: a bomb names nobody; *naming the thrower needs the ledger moved too* | **Confirmed as built**, recorded beside the frame's rule; the live consequence is in `docs/state.md` (FOUND AT HZ) |
| 12 | §0.3: *the same rule Snare Line's spring, the Deadfall and Burning Ground already follow* | **Held**: each deals under its layer's frame (HY §1b; `_burning_ground_tick` OWN, the Cleric's) |
| 13 | §1a: *report what shows an enemy's queued attack today, and whether its IDENTITY is on screen before it resolves* | **A telegraph exists**: every enemy declares at the battle's start and at the end of each of its turns (`_declare_intent`), shown as an icon and a word on its plate and an icon in the turn bar. **The identity is on screen for most**: the ability's name for a strike, sweep, crush, mend or bolster — **but an affliction shows the status it applies, and a wind-up its turns** (the combat rules' *icon plus the ability's own name* overstated it; repaired). So the hover hangs on the telegraph, and it always names the ability |
| 14 | *The thirteen combat-log literals are already on the standing queue* | **Held**: `docs/state.md`, *THE THIRTEEN COMBAT-LOG LITERALS STAY LITERALS (HL §9)* |
| 15 | §1b: *the single most-named thing in the zone-one list* | **Not checkable in the tree**: the zone-one list is the designer's; the roadmap names the finding (HY's `docs/state.md`) |
| 16 | §1b: *report whether the shop and the draft are one scene or two* | **Two**: the Peddler is its own scene (`shop.tscn`); every draft is an overlay on the map (the party draft, the zone boss's card, a rune cache). **Both take their input as Buttons**, so one component serves both at no cost |
| 17 | §1b: *the `(core)` suffix from HL §2 and HR's nameplate marker* | **Held**: the suffix is in the rune data's names; HR's marker is the map card's *✦ N* |
| 18 | §1c: *HW fitted the selection boxes around the sprites* | **Half**: HW fitted the ENEMIES' zones (`_fit_enemy_target_zones`); a hero's is still the 140×220 box (FOUND AT HW) |
| 19 | §1c: *report what accepts a target today* | **The body's invisible zone** (`BattleUnit._target_btn`, shown only for the pool) and the keyboard (Tab, Space). The plate accepted nothing |
| 20 | §1c: *the designer asked at HR for a kit menu next to the nameplate — so the nameplate is already a click target* | **Half**: HR's nameplate is the MAP card's, whose ✦ marker is a button to the rune panel; **the battle plate had no click target at all**, and *kit menu* names nothing in the tree. So outside targeting a battle plate does nothing, as it did at HY |
| 21 | §1d: *HU built chip tags for statuses, at 2–3 characters* | **Held**: a 12×12 chip for two characters or fewer, 26×12 for more, filled, with its letters |
| 22 | §1d: *HQ moved Dead Air from 50% to 75%* | **Held** (`data/runes.json`: `dmg_bonus` 0.75) |
| 23 | §1d: *the four live crest runes (Tithe, Empty Pulpit, Dead Air, Dirge)* | **Held**; Fellowship is retired; only the last three carry a `condition` |
| 24 | §1d: *Empty Pulpit and Dead Air will read ARMED and never pay — HO's premise 16* | **Half** (ruling 2): ARMED at every fight's opening; PAYING after the class's hero falls, since HP §1's live re-read |
| 25 | §2: the four figures to measure; *the current good case is 84 for 40 Rage* | **Measured** (§2): 100 Rage every lineage (120 with the tier-1 node); about 20 a turn; the census; the best ordinary turn. HW's 84 **held** as HW's figure |
| 26 | §2: *`last_rites` is live (HY premise 21)* | **Held**: the tier-3 node *Pay a Lethal Hit out of Your Resource Pool* writes it; `take_hit` pays below a quarter's health |
| 27 | §3: *owed since HW; report what the toast says today* | **Held**: *"<rune> waits with the <Hunter> — slot it on the hero's rune panel to use it."* (a cache) and *"<rune> drops for the <Hunter> — held, not worn: equip it from the card."* (a drop); neither named the pet |
| 28 | §4: *HY's ten folders, 2,704 KiB* | **Held**: ten, 2,704 KiB, by prefix |
| 29 | §5: *`RUPTURE_BREAK_PER_TICK` stays at 10*; *HX's 87 standing stale claims* | **Held** (`battle.gd`: 10; `docs/state.md`: the 87) |
| 30 | §6: *HY's backup is `../save-backups/HY-20261009-091100`; the designer is playing the first zone — expect them to have moved* | **The backup held; the expectation did not**: all four player files byte-identical to HY's backup — md5, size and modification time — so nothing was played since HY |
| 31 | §6: *HY read 139 in 75 min 43 s* | **Held** (HY's acceptance run) |
| 32 | §6: *`CLAUDE.md` closes HY at 432.51 KiB, 77.49 under 510; `docs/state.md` at 329.52 KiB, 50.48 under 380* | **Held**: 442,894 B and 337,425 B at HEAD |
| 33 | §6: *the chips are 2–3 characters and §1d writes more of them* | **§1d writes no lettered tag**: a rune chip carries the rune glyph alone, so it adds nothing to HU §4's tag walk |

## §0 — HY's THREE RULINGS, ANSWERED

### §0.1 — THE CARRIED HALF IS THE RAIDER'S DAMAGE ON A SECOND BODY (CHANGED)

**One line in the damage path**: `_on_vow_share` no longer saves the frame, sets the Devout's and restores it — it bills the Devout
under the frame it found. Everything else about the share is as it was: the split is `take_hit`'s, the bill goes through
`take_tick_damage`, the ally kindles a Faith, the log line reads as before.

**The two conditions that could have stopped it, measured first, and neither did.**

- **THE RIDERS FIRE ONCE.** A rider of the swing — the status it applies, its lifesteal, its Break, a counter it feeds — is applied
  in `_resolve` off the swing's result, once, and the frame change reaches none of those lines. What it does reach is the frame's
  readers on the Devout's body: the vow's gate (`_deal_gate`) returns at once for a hero body; `_rule_engines_on_damage` returns at once
  for a hero body; the death door's hero branch reads no frame; the taken ledger books the raider (intended); Penance mirrors the
  carried half (intended — the mirror per body); and the Covenant's share shares it (accepted — the brief's *chain of two cards the
  player chose*). **Driven** (`check_hz` §0c): an always-landing status attack, given a lifesteal, on the vowed Warden — the status on the
  Warden and not on the Devout, one lifesteal line, the Devout's Break unmoved.
- **NOTHING RE-ENTERS, AND THE GUARDS READ NO FRAME.** The vow's split lives in `take_hit` alone and the bill goes through
  `take_tick_damage`, which has none; and `_on_vow_share` refuses a Devout carrying his own wound (`devout == ally`). **Driven**
  (`check_hz` §0d): the Devout under a vow of his own carries half the Warden's blow once; struck himself, he keeps the whole.

**What the change does, driven** (`check_hz` §0): a Devout on 1 health felled by the half he carries is recorded as the **Orc Raider's
Slash**, `self` false (§0a — it was *themself / Vow of Suffering* at HEAD); a Devout holding the Oathkeeper core shares the carried
half with his bound ally, each booked to the raider (§0b: the Warden 11, the Devout 6, the bound Pyromancer 5 on one blow).

**`check_hy` §1, RE-TUNED** — the stated function loses the share's term: the raider loses the mirror on what EACH body lost (the whole
blow between them), the wire on the whole blow, and the reflect unless its layer wears the vow; the Devout's carried share is booked to
the raider; §6's census row for `_on_vow_share` is DEALER, beside the Covenant share and One Soul. **The table on HZ's code**:

| arm | blow 1 | blow 2 | blow 3 |
|---|---|---|---|
| A0 — no share, the Devout vowed | 16 + 0 → 20 (8 / 12 / 0) | 22 + 0 → 27 (11 / 16 / 0) | 17 + 0 → 21 (9 / 12 / 0) |
| A1 — the share, the Devout vowed | 8 + 8 → 20 (8 / 12 / 0) | 11 + 10 → 26 (11 / 15 / 0) | 9 + 9 → 23 (10 / 13 / 0) |
| A2 — the share, no vow | 8 + 8 → 22 (8 / 12 / 2) | 10 + 10 → 27 (10 / 15 / 2) | 11 + 10 → 28 (11 / 15 / 2) |
| A3 — no share, no vow | 16 + 0 → 22 (8 / 12 / 2) | 18 + 0 → 24 (9 / 13 / 2) | 19 + 0 → 26 (10 / 14 / 2) |

*The Warden's loss + the Devout's carried share → the raider's loss (Penance's mirror / the Tripwire / the reflect).* **The mirror is the
whole blow's in every arm** — A1's first blow mirrors 8 where HY's mirrored 4. **The rounding of a split, asserted per blow (+12)**: never
more than one body's rounding, and printed where it differs — **A1's third blow: 18 → 9 + 9 mirrors 5 + 5 = 10, the whole blow 9** (ruling
4). The extra mirror's sound draws one roll from the shared dice, so A1's and A2's later blows are not HY's blows; the function is what
the arms compare. **161 → 173 / 0.**

### §0.2 — A BOMB NAMES NOBODY (CONFIRMED AS BUILT)

Recorded beside the frame's rule in `docs/combat-rules.md` — *nobody in the frame and nobody in the ledger, and the two must agree*,
with the reason (naming the thrower hands his own Vow of Silence the party's bombs). **The live consequence is in `docs/state.md`**: a
bomb never marks, never feeds Siphon, is never judged and cannot be a Reaver's killing blow — surface text owed the next time the item
surface is touched, not here.

### §0.3 — CONSECRATED GROUND'S REFLECT IS ITS LAYER'S (CONFIRMED AS BUILT)

Recorded beside the frame's rule — a laid status's damage is its layer's wherever it lands, as Snare Line's spring, the Deadfall and
Burning Ground's tick are — and **the trap is chipped at §1d**: a vowed Cleric carrying Consecrated Ground wears a chip that reads ARMED,
and IN EFFECT while a ground he laid stands (*his vow silences his own ground: it reflects nothing, for anybody standing on it*).

## §1 — THE EYES

**Every surface is driven on the real screen — a real battle, the real map and the real Peddler — with its negative arm**
(`check_hz`, 107 checks). **Nothing above §1d grew**, so §1d was built rather than dropped.

### §1a — THE ENEMY'S DECLARED ATTACK, ON HOVER: THE EFFECT, NEVER THE TARGET

**Measured first**: every enemy declares its next action at the battle's start and at the end of each of its turns, stores it on
`BattleUnit.intent`, and shows it — an icon and a word on its plate, an icon in the turn bar — through every hero turn. **So there is a
next attack to detail, and the hover hangs on the telegraph** rather than on a move list. The plate's intent line takes the mouse
(passing a click on to the plate) and carries the detail as its tooltip; the turn bar's glyph carries the same.

**What it says, read off the declared ability's data** (`battle._intent_hover_text`): its name; its band — `_damage_line`, lifted out of
`_ability_tooltip` unchanged so the hero's own cards and the telegraph read one line; a wind-up's turns; what it applies, for how long
and at what chance; its own description where it has one (the specials); and how many it hits. **It never says whom it is aimed at**,
and the reason is written where a later batch will meet it (the combat rules' intent block, and the function's own header): knowing what
an attack does is what decides whether to pre-empt it; knowing which hero it will hit turns every defensive decision into arithmetic.

**Driven** (`check_hz` §1a): Sundering Strike declared at the Warden reads *Sundering Strike · Damage: 21–26 (Physical) BD: 22 · Applies
Sunder for 2 turns (60% chance) · Hits one hero* — and no hero's name. **Negative arms**: Slash, which applies nothing, prints no effect
line and no empty one; an enemy that declares nothing shows no line and no hover. A pointer pushed onto the line hovers the line. **And a
census over every enemy ability in the data (50)**: each opens on its name, carries the band exactly when it deals damage, the effect
exactly when it applies something, its own description, a reach for a hostile attack — and no hero's name. **An enemy with one attack**:
no kind has exactly one ability (the fewest is two); five carry one attack beside a support, and the census reads each of their
abilities alike.

### §1b — A KIT PREVIEW, FROM THE DRAFT AND THE SHOP

**One component, `scripts/kit_preview.gd`, used by both screens.** The Peddler is its own scene; every draft is a map overlay — the
elite's four-column draft, a zone boss's card, a rune cache — and every one of them takes its input as Buttons, so the same three
buttons (Previous, Next, Close) serve both, at no cost. **From a draft it opens on the hero whose decision it is** (each column, and the
single pick, carries *See the kit*); **from the Peddler it opens on the first hero and walks all four** (*See the heroes' kits*, beside
Leave, which does not move).

**Its three constraints**: **read-only** — it carries no button but Close (and the Peddler's two walking buttons); **an overlay that loses
nothing** — added last, its dim stops every click, and it frees only itself; **IA's layout is not its to draft** — it reads the doors the
hero sheet reads (`Classes.opening_kit`, `Run.seated_ability_names`, `Run.sitting_out_names`, `Run.benched_ability_names`) and shows the
runes in the sheet's own words: the state column (CREST, ENGINE, WORN, held, sits out), the `(core)` suffix the names carry and HR's
*✦ N held, not worn*. **Its text scrolls inside a bounded frame with Close outside it** — GT §1's shape; it lists no buttons, so HU §1's
pager is not its rule.

**Driven** (`check_hz` §1b): **mid-draft** — the Warrior's card staged, his column's button pressed, the preview open on him with his kit
and his core rune as it reads, Close pressed, the overlay still holding the staged card, Confirm pressed, and the card his; **from a rune
cache's pick** — the button, the preview on the Mage, Close, the rune taken and held; **the negative arm** — a hero with no runes at all
and a starting kit: the preview renders his kit and says he holds none, with no held marker; **from the Peddler** — the preview walks all
four and back to the first, Previous from the first reaches the fourth, and a purchase lands after it closes. Seen, too: the screens
were rendered to PNG to check the frame is opaque and the buttons sit where they should.

### §1c — THE NAMEPLATES ARE SELECTABLE

**This is the other half of HW's click-zone finding**: HW fitted the enemies' zones around their sprites; the plate is where a player's
eye already is. **What accepted a target at HY**: the body's invisible zone (`BattleUnit._target_btn`, shown only for the pool), and Tab
and Space. **The plate accepted nothing** — and *a kit menu next to the nameplate* names nothing in the tree: HR's nameplate is the map
card's.

**The arbitration**: `BattleUnit._on_plate_input`, on the plate and on every chip on it (a chip stops the mouse for its tooltip), with
the intent line passing its click to the plate — **a left click pressed and released on the plate while this unit is a target (its zone
is up — `set_targetable` is the one switch) emits the same `clicked` the body does; any other click does exactly what it did: nothing.**
It changes nothing about what is targetable.

**Driven, through the real viewport** (`check_hz` §1c — clicks pushed into the root viewport, so the GUI's own picking and filters
decide where they land): a click on the raider's plate during targeting picks the raider; on a status chip on it; on its intent line; a
hero's plate picks the hero when the party is the pool; a plate outside the pool picks nothing; and **outside targeting, before and after,
the same plate picks nothing and emits no click**, its tooltip unmoved.

### §1d — THE CHIPS: WHAT IS PAYING RIGHT NOW

**Measured first**: HU's chip is a filled 12×12 box (26×12 past two letters) with its tag in 7–8 point type, laid left to right from the
plate's left; the row has no wrap, and **a hero's plate cannot take a second row** (two resource bars put it at 79 of the 82 pixels
between plates). **So the row carries a rune — as a different chip**: a rune's label is far wider than a tag, so the chip carries the rune
mark (HR's *✦*) and its words are its tooltip. **A status is drawn filled, lettered, from the left; a rune outlined, with the mark, from
the right** — and it is not a status: nothing ticks, dispels or counts it (`BattleUnit.set_rune_chips`, `rune_chip`).

**The crest's rune is one chip, on a CREST strip above the party's plates** (`battle._draw_crest_strip`) — never one per hero. **Two
states**: ARMED, dim, and PAYING, bright; the tooltip says which, what it pays and on what condition, **every magnitude read off the
payload** (`_rune_effect_words`), never the rune's authored line. The state is the live door's own (`_live_stamps`), refreshed when the
door opens, at every switch it makes and at every turn's start.

**What gets one**: the crest's rune — Tithe (no condition: PAYING whenever worn), Empty Pulpit, Dead Air, Dirge; a hero's own rune with
a condition (none is authored today); **Last Rites' window** (`BattleUnit.last_rites_window`, the one test `take_hit` now reads too:
PAYING below a quarter's health while the bar holds Rage, ARMED above it, and saying so when a dump has left the bar dry); and **a vowed
Cleric's Consecrated Ground** (§0.3's trap).

**Driven** (`check_hz` §1d): the negative arm — a party wearing nothing that turns on and off draws no rune chip and no strip; Empty
Pulpit and Dirge each one chip on the strip and none on a plate, ARMED, its figure the payload's, then **PAYING the moment a Cleric (any
hero) falls through the damage door**; Tithe PAYING; Last Rites ARMED, PAYING below a quarter, dry after a dump; the vowed Devout's chip
ARMED, then IN EFFECT with his ground laid; and the chip in no status row and on no status.

**THE FINDING THE SURFACE WAS EXPECTED TO PRODUCE** — the brief's *Empty Pulpit and Dead Air will read ARMED and never pay* — **reads
half**: ARMED at the opening of every fight a run plays forward, and PAYING for the rest of a fight in which the Cleric (the Mage) falls,
because HP §1's door re-reads the condition at every death (ruling 2). **And one more the chip survey found**: under a vowed Cleric's
ground the reflect's log line prints before the vow's gate — *reflects N* for a reflect that never landed — and Lifewell heals off that
same figure (FOUND AT HZ; ruling 6).

## §2 — BOIL OVER BECOMES A RAGE DUMP

**The spec, built**: it pours out **the whole bar** into one strike, has **no cost of its own**, and wants **a floor of 40% of the bar**
(`Classes.BOIL_OVER_MIN_BAR`, a fraction of the hero's own maximum, so it scales); it pays **0.8% of Attack a point poured out**
(`BOIL_OVER_PCT_PER_RAGE`). **The Blood Frenzy term and the two-turn recovery are gone.** It is still an ordinary strike keyed on its name
(`Classes.is_rage_dump`), so the whole pipeline reaches it, and it is still one of CM's gated five (a Sloppy loses the cast and keeps the
bar). The bar leaves at the price line, beside every other price, so the band is told before the blow lands and the Berserker's core
multiplies the dump as it multiplies every strike. The card's words are formatted from the two constants (no second copy); its tooltip
quotes the live bar and the floor.

**THE FOUR FIGURES, MEASURED BEFORE THE RATE WAS AUTHORED.**

- **Maximum Rage by lineage**: **100 for every Warrior lineage**; **120** with the tier-1 node that raises the pool. No rune or relic
  writes it.
- **Rage a turn, in real fights**: an instrumented copy ran **20 full sim runs for each Warrior lineage** (Berserker, Warden, Swordmaster),
  the default rung and build: **about 20 a turn, median 15, in every zone and lineage** — a bar of 100 from empty in **about five of his
  turns**, about a fight. Holding 100 or more, the bot's damaging actions dealt a median 35–54% of his Attack.
- **The census of every card that spends Rage** — the kit, the Warrior's draft shelf and the three lineages' boss pools, **each cast once
  on its own fresh deterministic board** (Attack 100, Block and crit zeroed, the dice seeded; a card's buffs never carry into the next):

| card | Rage | dealt | a point | with the core |
|---|---|---|---|---|
| Rampage | 40 | 45 | 1.12 | 52 |
| Execute | 30 | 38 | 1.27 | 43 |
| Wildstrikes | 35 | 38 | 1.09 | 43 |
| Cleave | 25 | 35 | 1.40 | 39 |
| War Stomp | 20 | 33 | 1.65 | 36 |
| Precision Strike | 20 | 33 | 1.65 | 33 |
| Feint | 25 | 32 | 1.28 | 32 |
| Gut Rip | 30 | 30 | 1.00 | 30 |
| Crushing Blow | 20 | 30 | 1.50 | 31 |
| Sever | 25 | 28 | 1.12 | 30 |
| Shield Slam | 25 | 24 | 0.96 | 24 |
| Hack and Slash | 20 | 22 | 1.10 | 23 |
| Blood Debt | 20 | 21 | 1.05 | 22 |
| Lunge | 25 | 21 | 0.84 | 22 |
| Sweeping Strikes | 20 | 21 | 1.05 | 22 |
| Charge | 20 | 17 | 0.85 | 17 |
| Pommel Strike | 20 | 17 | 0.85 | 18 |
| Shatterpoint | 30 | 14 | 0.47 | 16 |
| Overpower | 25 | 10 | 0.40 | 11 |

  *Bloodlust (25 Rage) is the core's own enabler: 19 with it. Twenty-five deal nothing on the board — buffs, guards and stances.*
- **The Warrior's best ordinary turn**: **Rampage, 45 (52 with the core)** on the board; in the sims, the bot's best single action a fight
  ran a median 44–54% of his Attack in the first zone, 67–78% in the second, 78–105% in the third (multi-hit cards and buffs).

**THE NUMBER THAT DECIDES WHETHER IT SHIPS: A FULL BAR READS 63 WITHOUT THE BERSERKER'S CORE AND 88 WITH IT.** The core multiplies the
dump — and its band is filled by the dump's own spend (a hundred points is the whole band), so **88 is its figure at any health**. HW's
good case for the old card, 84 for 40 Rage at half health, is beaten.

**THE SHAPE, WHICH IS THE PASS CONDITION, HOLDS BOTH WAYS**: a full bar beats the best ordinary turn and does not beat two (63 against 45
and 90; 88 against 52 and 104); a cast at the floor is worse than an ordinary card (25 and 29 against Crushing Blow's 30 and 31). **Two
rates were tried before it and failed the shape, and the record says so**: 0.65 with a floor of half the bar (a full bar barely beat
Rampage without the core, and a floor cast tied Crushing Blow with it) and 0.75 (a full bar with the core came to 83, under HW's 84).

**`last_rites`, allowed and visible, not refused**: a dump below a quarter's health empties the bar the node pays from, and the next blow
lands on health — the cast is not refused (`check_hz` §2 drives both), the card says it spends the whole bar, and §1d's chip shows the
protection dry.

**What else read the two-turn recovery's field**: the `boil_over` status is written by nothing now; `unit.frenzy_bonus()` still reads it,
`STATUS_INFO` keeps its row and `check_hw` §1a prints it — kept, the shape `spite_ranks` and `whole_forest` have, and said so at each.

**The rate is recorded in `docs/state.md` with these figures, as a tuning handle, and is the designer's to re-rule** (ruling 1).

## §3 — THE SHARPSHOOTER'S TOAST NAMES THE PET

**What the toast said**: *"Rune of the Sharpshooter (core) waits with the Beastmaster — slot it on the hero's rune panel to use it."* (a
cache's pick), and a dropped one *"… drops for the Beastmaster — held, not worn: equip it from the card."* **Now both add, for a core rune
that dismisses the pet held by a Hunter who fields one**: *"Slotted, it sends the companion away: Summon Companion leaves the kit."* —
read off `Classes.dismisses_pet` and `Classes.PET_CARD`, never typed (`map_screen.pet_clause`). **Driven** (`check_hz` §3): the
Sharpshooter's core taken from a cache by a Hunter on Pack Bond names the card; an ordinary core (the Survivalist's) does not; and a
dropped dismisser's line names it too.

## §4 — HOUSEKEEPING

- **HY's ten folders cleared by prefix (HO §5)**: *Dawn of Decay HY probe, recon, trhead, trnew, ctlA, ctlB, ctlC, subset, prepass and
  final* — ten, **2,704 KiB**, moved to the Trash as *DoD spent user-data folders (Batch HY's 10, cleared at HZ 2026-10-09)*.
  `app_userdata` read **474 folders and 146,704 KiB before and 464 and 144,000 KiB after**, in one command. The live *Dawn of Decay*
  folder, the older copies and `../save-backups/` were not touched.
- **HZ's own folders stay for IA to clear**: **fifteen**, 6,312 KiB — *Dawn of Decay HZ recon, recon2, probe, trhead, trnew, sub1, ctlA,
  ctlB, ctlE, ctlF, ctlG, ctlH, ctlI, prepass and final* (HO §5: the next batch clears them by prefix).

## §5 — DELIBERATELY NOT DONE

- **The three core slots and the per-class bag are IA's**; the preview shows the kit and does not restructure it.
- **The draft flow is IB's**; the Cleric's regen and the Mage's fire are IC's.
- **No conjunction is authored**: `RUPTURE_BREAK_PER_TICK` stays at 10, still unfelt.
- **HX's 87 standing stale claims are not repaired** — a batch of their own. HZ's re-read repaired the claims its own change falsified
  (§6c) and reports the rest.
- **The re-measure does not run** (three batches since HV). Its two readings are in `docs/state.md`'s WHERE block, one line each.
- **A copied Frostbind's refusal is still RULED, NOT BUILT**; **the crest cap stays at one**; **Mana stays**; and every standing item the
  brief listed is unchanged.

## §6 — THE VERIFICATION

### §6a — THE PUSH CHECK AND THE SAVES, BEFORE ANYTHING

**Premise 1**: `git ls-remote origin class-merge` read `464bf14c91f8e8db39045c16af14091176e7f6a3`, local HEAD, before anything ran. **The
saves were backed up first** to `../save-backups/HZ-20261009-163227` and verified by hash: all four player files byte-identical to the
copies — md5, size and modification time — **and to HY's backup**, so nothing was played since HY (the brief expected otherwise). No Godot
was running: the rows of `ps`, read by executable.

### §6b — HEAD's GATES AGAINST THE NEW CODE, BEFORE ANY OF THEM WAS EDITED: TWO RECONS

**§0.1 changes the damage path, so the recon is the whole battery — and §0.4 put §0.1 first, so it ran first, alone.**

**Recon 1 — §0.1 alone.** HEAD's 139 targets, unmodified, against an isolated copy holding HEAD's tree and HZ §0.1's `battle.gd`
(*"Dawn of Decay HZ recon"*, proved equal to the tree, 519 files), predicted before the launch: `check_hy` 161 / 9 — the nine lines a
standalone run of HEAD's gate read at 16:42 — and everything else at HY's acceptance reading. **16:44:01 to 17:59:49 — 75 min 48 s — read
`check_de` 573 / 1 / 0, exactly as predicted**: its one red is `check_hy` going 0 → 9, the nine lines word for word (§1's mirror on the
six share blows — *paid 8, 11, 10* and *8, 10, 11* against the Warden's half — the Devout's ledger in A1 and A2, booked to the Orc
Raider's Slash, and §6's *`_on_vow_share` borrows no frame*); every other target at its HY acceptance reading, `check_cm_live` 13 / 4 and
`check_gj` 70 / 1 with HY's FAIL lines word for word, `test_batch_an` and `test_batch_bk` at HY's own readings, the run harness PASS
22 / 382 / 8; 139 names in `.ran`, each once, in one ascending sequence; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line.
**So §0.1 moved nothing in HEAD's battery but the gate written about the reading it overturned.**

**Recon 2 — all of HZ's game code.** HEAD's 139 targets, unmodified, against an isolated copy holding HZ's six game files and
HEAD's copy of every gate, suite, document, baselines row and the runner (*"Dawn of Decay HZ recon2"*, proved equal to the tree
but for those), the prediction written first. **18:00:15 to 19:15:47 — 75 min 32 s — `check_de` 573 / 15 / 1.** 139 names in
`.ran`, each once; no Parse Error, TIMED OUT or NO VERDICT line; **one SCRIPT ERROR, `check_gw`'s** (below); the run harness PASS
22 / 382 / 8. **Every moved target, with its cause read off its FAIL lines and the code they name:**

| target | HEAD's gate on HZ's code | cause | predicted |
|---|---|---|---|
| `check_parse` | 213 → 214, a notice | `scripts/kit_preview.gd` joins its walk | yes |
| `check_hy` | 161 / 9 | the nine lines recon 1 read, word for word | yes |
| `test_batch_cp` | 586 / 1 | Boil Over joins the checked cards that state no Perfect | yes |
| `test_batch_bo` §5 | 1140 / 1 | the same card, absent from its exemption list | **no** |
| `check_dw` §2 | 35 / 2 | the same population, read through `test_batch_cp`'s list (HEAD's eight) and pinned at eight | **no** |
| `check_di` | 44 / 1 | the status door's call sites, 220 → 219: the recovery's write went with the recovery | **no** |
| `check_gw` | 76 → 69 and a throw | `float()` of an Array in §1b's census: HZ's `var rune_chips` in `unit.gd`, read as a rune's payload field — the `rune_` prefix is that convention's | **no** |
| `check_fe` §2d, `check_fh` §1, `check_fm` §3, `check_gj` §1, `check_gp` §4, `check_hk` §7 | 1 to 5 reds each; `check_gj` 70 → 36, `check_gp` 443 → 403 | **the kit preview's button**: it is a pick overlay's first button, five of the six answer a pick by pressing the first button that is not *Not yet* (four of them copies of one helper), and `check_fm` counts the overlay's buttons exactly — so every road stopped at its first pick | in kind (*may move by a button*), **not in size**: whole roads stopped |
| `test_batch_an`, `test_batch_bk` | 6050 → 6055 and 131 → 130, inside their bands | the dice: on HEAD's own code two traced reps read 6051 and 6053, and 131 and 131; the assertions that move loop over a rolled map's slots and a rolled column | — |

**So HEAD's battery read HZ's code as working, and every red but one is a gate meeting what HZ changed rather than HZ breaking
what a gate protects. The one is HZ's own**: the `rune_chips` field, which nothing read, is removed.

**THE REPAIRS — each to the gate's intent, none by deletion.**
- **`check_di` 220 → 219 and `check_dw` §2 8 → 9**, each with its reason beside the constant (and `check_dw`'s header, and the one
  stale comment under the pin: *the other seven are pool cards*).
- **The kit preview's button is not a choice.** The four copies of the road walker (`check_gj`, `check_gp`, `check_gv`,
  `check_hk`), `check_fe`'s label reader and `check_fh`'s (its walker, and the label list under §3's and §6's floors) pass over it
  **by the meta the game sets on it** (`kit_preview`), never by its words; `check_fm` §3 counts it apart and stays exact — the
  picks, *Not yet* and the preview's one button. **`check_fh`'s two floors were not red and were blind**: a cache that drew no rune
  read one live button, the preview's (D45 and D45h, below). `check_gv`'s copy is edited alike and is not exercised — its road met
  no pick at either reading.
- **And one the subset found, in HZ's own gate**: `check_hz` set the Last Rites node's field by hand on the built Warrior, twice
  (`war.last_rites = 1`), which grew `check_gw` §2's shape from 96 to 98 — a gate arranging its own subject, the one that ceiling
  is for. **The node is seated through the spawn now** (the class tree, the node learned, the battle's own payload door writing the
  field), and §2's arm asserts its premise — the window open on its board — which it never had: with the door broken the arm
  passed on nothing (D43). `check_hz` 105 → 107.

**The subset — the repaired gates on the final code, before the pre-pass.** Thirteen targets in an isolated copy proved equal to
the tree, predicted first: **19:16:27 to 19:27:14, and every reading recon 1's** (HEAD's gates on HEAD's code): `check_di` 44 / 0,
`check_dw` 35 / 0, `check_fe` 79 / 0, `check_fm` 82 / 0, `check_fh` 167 / 0, `check_hk` 168 / 0, `check_gp` 443 / 0 — **both its
roads 32 and 36 battles over 49 maps, recon 1's to the map** — and `check_gj` 70 / 1 with HY's §4 line word for word, beside
`test_batch_cp` 586 / 0, `test_batch_bo` 1140 / 0, `check_hy` 173 / 0 and `check_hz` 105 / 0. **One miss: `check_gw` 76 / 1**, the
shape at 98 (above). After its repair, on the final tree: `check_hz` 107 / 0 and `check_gw` 76 / 0, the shape back at 96 (D00).

### §6c — THE RE-READ (HY §6)

**The population is the names the diff touches**: every function, constant, field, status, file and gate HZ's diff edits —
121 names — matched against the backticked names in both references, 26 pairs; each sentence read against the new tree. **None
stands false by HZ's change**: the claims HZ's change falsified were repaired with it — the combat rules' intent block (*icon
plus the ability's own name*: an affliction shows the status it applies and a wind-up its turns) and the frame block (the vow's
share, by the ruling, with the bomb and the reflect beside it). **One stale count met there, and it is not HZ's**: the
instrument rules' *FIVE sites in `battle.gd` spell `heroes.filter(func(he): return not he.dead and not he.is_companion)` byte for
byte* — **nine**, at HEAD and at HZ, and `check_dm` §1 prints the live figure. Reported, not repaired: HX's 87 are a batch of
their own. The combat rules' header claim is reported beside it (FOUND AT HZ).

### §6d — THE CONTROLS: EVERY ONE BREAKS ITS NEEDLE

**Round one — thirty-eight controls on the tree as it stood at 18:17**, one defect per APFS clone, each patch count-asserted so a
patch that does not land is reported rather than run as a baseline, every FAIL line read. **Each reds at the line it aims at,
and the baseline (C00) is green.** The H rows are HEAD arms — a re-tuned gate read against HEAD's copy of what it re-tuned, or
HEAD's copy of it read against HZ's code — and each reds where the batch says it should. Where a defect breaks more than one arm
the count says so; the line shown is the one aimed at.

| id | the defect planted | read (the line it aims at) |
|---|---|---|
| C00 | baseline: the landed tree, no patch | `check_hy` 173 / 0, green<br>`check_hz` 105 / 0, green<br>`check_hx` 39 / 0, green<br>`test_batch_cp` 586 / 0, green |
| C01 | the vow's share borrows again (HY's shape: the Devout's frame for the bill, put back after) | `check_hy` 173 / 14 — *§1 (A2 the share, no vow) blow 3: the mirror on the bodies is 6 against 11 on the whole blow of 21 — more than one body's rounding* (+13 more)<br>`check_hz` 105 / 3 — *§0b: the Warden lost 11, the Devout 11, his bound Pyromancer 0 — the Covenant did not share the carried half* (+2 more) |
| C02 | the carried half is billed twice (moved again) | `check_hz` 105 / 1 — *§0d: the Warden lost 11 and the Devout 22 of 33 — the carried half moved again or was lost* |
| C03 | the swing's lifesteal fires twice | `check_hz` 105 / 1 — *§0c: the swing's lifesteal fired 2 time(s) — once, on the swing's result* |
| C10 | the hover names whom the attack is aimed at | `check_hz` 105 / 2 — *§1a: the hover names ["Warden"] — it says what the attack does, never whom it is aimed at* (+1 more) |
| C11 | an attack that applies nothing prints an empty effect line | `check_hz` 105 / 2 — *§1a: an attack that applies nothing printed an effect line or an empty one: ["Slash", "Damage: 31–38 (Physical)    BD: 26", "Applies ", "…* (+1 more) |
| C12 | the hover's band is computed a second way | `check_hz` 105 / 2 — *§1a: the hover's band is not the damage line the ability's own data gives: ["Sundering Strike", "Damage: 21–26 (Physical)    BD: 22 ", "A…* (+1 more) |
| C13 | the intent line takes no mouse (no hover) | `check_hz` 105 / 9 — *§1a: the intent line of a declaring enemy carries no hover (filter 2)* (+8 more) |
| C14 | the preview can equip (a button beside Close) | `check_hz` 105 / 1 — *§1b: a preview opened from the draft carries buttons ["✕  Close", "Equip"] — it is read-only and stays on its hero* |
| C15 | closing the preview loses the draft beneath it | `check_hz` 105 / 2 — *§1b: after the preview closed the draft overlay is gone or lost the staged Warcry* (+1 more) |
| C16 | the Peddler's preview stays on one hero | `check_hz` 105 / 2 — *§1b: the Peddler's preview walked ["Berserker 1 — the kit", "Berserker 1 — the kit", "Berserker 1 — the kit", "Berserker 1 — the kit", "B…* (+1 more) |
| C17 | a hero with no runes renders no rune line | `check_hz` 105 / 1 — *§1b: the bare hero's preview did not render his kit and say he holds no runes:* |
| C18 | a plate click picks outside targeting too | `check_hz` 105 / 3 — *§1c: a click on a plate outside the pool picked [@Node2D@1814:<Node2D#223522850668>]* (+2 more) |
| C19 | the plate takes no click | `check_hz` 105 / 3 — *§1c (the plate): a click on the raider's plate during targeting picked []* (+2 more) |
| C20 | a status chip swallows the click | `check_hz` 105 / 1 — *§1c (a chip): a click on the raider's status chip during targeting picked []* |
| C21 | the intent line stops the click | `check_hz` 105 / 2 — *§1c (the intent line): a click on the raider's intent line during targeting picked []* (+1 more) |
| C30 | the crest's chip on every hero's plate | `check_hz` 105 / 2 — *§1d (Dirge): the crest's rune drew 1 chip(s) on the strip and 4 on the plates — one chip, never four* (+1 more) |
| C31 | a chip's figure typed, not read off the payload | `check_hz` 105 / 1 — *§1d (Dirge): the chip's words do not carry the payload's own figure (45%): Dirge (the crest) — ARMED / Pays only while a hero lies fallen…* |
| C32 | a chip ignores the live door (always ARMED) | `check_hz` 105 / 2 — *§1d (Empty Pulpit): with the Devout fallen the chip does not read PAYING* (+1 more) |
| C33 | a chip for a party wearing nothing that turns on and off | `check_hz` 105 / 7 — *§1d: a party wearing nothing that turns on and off drew a rune chip or a crest strip* (+6 more) |
| C34 | a rune chip drawn in the status row | `check_hz` 105 / 6 — *§1d: a rune chip was drawn as a status, in the status row, or written as a status* (+5 more) |
| C35 | Boil Over castable under its floor | `check_hz` 105 / 2 — *§2 (without): the dump is castable on 39 Rage, under its floor of 40* (+1 more) |
| C36 | the old recovery written after the dump | `check_hz` 105 / 2 — *§2 (without): the dump wrote the old recovery status* (+1 more) |
| C37 | the dump keeps the bar | `check_hz` 105 / 5 — *§2 (without): a full bar left 100 Rage and booked 100 spent — the dump pours out all 100* (+4 more) |
| C38 | the rate doubled | `check_hz` 105 / 4 — *§2 (without): a full bar deals 126, more than two of the best ordinary turn (Rampage, 45)* (+3 more) |
| C39 | the rate halved | `check_hz` 105 / 2 — *§2 (without): a full bar deals 32, not more than the best ordinary turn (Rampage, 45)* (+1 more) |
| C40 | the dump refused while Last Rites is live | `check_hz` 105 / 2 — *§2 (without): the dump is refused while Last Rites is live — refusing it removes the decision* (+1 more) |
| C41 | the toast does not name the pet | `check_hz` 105 / 1 — *§3 (the Sharpshooter's core): the toast does not name Summon Companion: Rune of the Sharpshooter (core) waits with the Beastmaster — slot…* |
| C42 | every core rune names the pet | `check_hz` 105 / 1 — *§3 (an ordinary core): an ordinary core's toast names the pet: Rune of the Survivalist (core) waits with the Beastmaster — slot it on the…* |
| C50 | HZ's new CLAUDE.md block left out of check_hx's known population | `check_hx` 39 / 1 — *§1c: 1 block(s) in CLAUDE.md are not in the known population: STANDING RULE — A PREVIEW CHANGES NOTHING, A NAMEPLATE IS A SECOND HIT AREA…* |
| C51 | the combat rules lose the borrow-and-put-back half while the vow's DEALER bullet is written | `check_hy` 173 / 1 — *§7: the combat rules have lost the borrow-and-put-back half* |
| C52 | Boil Over left out of test_batch_cp's named set | `test_batch_cp` 586 / 1 — *the checked-but-Perfectless abilities are exactly the named 8 (got 9: Arcane Explosion, Boil Over, Called Shot, Coup de Grâce, Death Ray,…* |
| C53 | Boil Over left out of test_batch_bo's named exemptions | `test_batch_bo` red — *§5: ...and states a perfect exactly when it runs a check (Boil Over)* |
| H01 | HEAD's battle.gd under the re-tuned check_hy | `check_hy` 173 / 14 — *§1 (A2 the share, no vow) blow 3: the mirror on the bodies is 6 against 11 on the whole blow of 21 — more than one body's rounding* (+13 more) |
| H02 | HEAD's game code under check_hz | `check_hz` 94 / 48 — *§1a: the plain attack's hover is [""]* (+47 more) |
| H03 | HEAD's check_hx over the new documents | `check_hx` 39 / 1 — *§1c: 1 block(s) in CLAUDE.md are not in the known population: STANDING RULE — A PREVIEW CHANGES NOTHING, A NAMEPLATE IS A SECOND HIT AREA…* |
| H04 | HEAD's test_batch_cp over the new code | `test_batch_cp` 586 / 1 — *the checked-but-Perfectless abilities are exactly the named 8 (got 9: Arcane Explosion, Boil Over, Called Shot, Coup de Grâce, Death Ray,…* |
| H05 | HEAD's test_batch_bo over the new code | `test_batch_bo` red — *§5: ...and states a perfect exactly when it runs a check (Boil Over)* |

**Round two — on the final tree** (cloned at 19:28 and synced for the two edits after it: §2's premise at 19:43, the Peddler's
sentence at 19:47; every anchor dry-checked first). It re-runs what HZ's later repairs touched and controls each repair **in
the direction it changed**, two of them two-armed:

| id | the defect planted | read |
|---|---|---|
| D00 | none | `check_hz` 107 / 0 (105 before the premise, the first time), `check_gw` 76 / 0 — the shape at 96 |
| D33, D34, D37, D40 | round one's Last Rites controls, on the gate that seats the node through the spawn | each red at its own line: *a party wearing nothing … drew a rune chip*, *a rune chip was drawn as a status*, *a full bar left 100 Rage*, *the dump is refused while Last Rites is live* |
| D43 | the node's payload no longer writes `last_rites` | `check_hz` 107 / 5: §1d's three Last Rites chip arms, and §2's premise in both rows — *Last Rites is not live on the arm's board (field 0, window false)* |
| D43h | the same, under the pre-repair `check_hz` (the field set by hand) | **105 / 0 — green**: the hand-set hides the broken door, which is the repair's reason |
| D44 | the preview's button loses its meta | `check_fe` §2d (*3 picks are still owed*), `check_fh` §1, `check_gj` §1, `check_hk` §7 and `check_gp` §4 red — each road stops at its first pick again; `check_fm` green, because it counts the button rather than skipping it (D46 and D47 are its controls) |
| D45 | a rune cache draws no rune button — the preview's and *Not yet* only | `check_fh` §3: *the cache drew 0 live buttons a node later — the pick is STRANDED* |
| D45h | the same, under HEAD's `check_fh` | §3's floor **green** on the preview's button alone (the road red for its own reason): HEAD's copy was blind here |
| D46 | a stray button on the pick overlay | `check_fm` §3: *6 buttons against 3 runes on offer plus `Not yet` and the kit preview button* |
| D47 | the pick overlay loses the preview's button | `check_fm` §3: *4 buttons against …* |
| D36 | the recovery's write back after the dump | `check_di`: *the call-site population is 220, not the 219* |
| D52 | Boil Over out of `test_batch_cp`'s list | `check_dw` §2: *the live … population is 9 and … names 8* |
| D01 | none: the retired-word suite over the final documents, before the pre-pass | `test_batch_bx` 159 / 1 — §4b: *master.html says hero or ally everywhere it is prose*. The Peddler's new line read *the purse is the party's*; reworded (*the purse is shared by all four*), it read 159 / 0 |

**D44's `check_fm` is a wrong prediction of mine, recorded as one**: its re-tune counts the preview's button where the other five
skip it, so the meta never reaches it; D46 and D47 move its count both ways. And D33, D34, D37 and D40 ran on the gate at 105,
before §2's premise was written — the premise sits ahead of the arm and reads nothing those four plant.

### §6e — THE PRE-PASS

**The pre-pass — 140 targets in an isolated copy proved equal to the tree** (*"Dawn of Decay HZ prepass"*, 521 files; the
prediction written first): **19:46:36 to 21:04:15 — 77 min 39 s — `check_de` 577 / 0 / 0, exactly as predicted.** 140 names in
`.ran`, each once; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line; the run harness PASS 22 / 382 / 8. **Every target
at recon 1's reading but the three the batch moves**: `check_hy` 173 / 0 (161 / 9 before its re-tune), `check_hz` new at
107 / 0, and `check_parse` 213 → 215 (the two new scripts). `check_gj` 70 / 1 with HY's §4 line word for word, `check_cm_live`
13 / 4 with HY's four, and `test_batch_an` 6050 and `test_batch_bk` 131 — recon 1's own. **The retired-word suite ran alone on
the final documents first** (D01, above) and caught a sentence of HZ's, so the pre-pass met none.

### §6f — THE ACCEPTANCE RUN, IN THE REPOSITORY

**The acceptance run in the repository** — its own runner and the live user folder, the prediction written first: **140
targets, 21:04:35 to 22:22:03 — 77 min 28 s — `check_de` 577 / 0 / 0, as predicted.** 140 names in `.ran`, each once; no Parse
Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line; the run harness PASS 22 / 382 / 8; **every target at its pre-pass reading but
`test_batch_an`, 6050 → 6049, inside its band** (the dice: it moves run to run on HEAD's own code, §6b). **The rows of `ps`**,
read every 15 s by executable: 309 readings, the battery's own Godot and never a game window. **The tree was byte-identical
before and after** (521 files, md5) and **the player's four files untouched** — md5, size and modification time before and
after, and equal to HZ's backup.

**Then the final tree.** `docs/state.md`'s post-run lines were written — the verification and the two readings — swept against
every gate literal (0 lost; 2 gained, neither under an absence assertion that reads that file), and the file's readers with the
document instruments re-run on it in an isolated copy proved equal to the tree, predicted first: **`check_es` 57, `check_fg` 30,
`check_fr` 25, `check_hp` 171, `check_hx` 39, `check_ec` 24, `check_ed` 18 and `check_ff` 68, each with no failure — each its
acceptance reading** (22:23:59 to 22:24:51).

### §6g — THE TWO READINGS AGAINST THE TWO CEILINGS, AND WHAT IS LEFT RUNNING

- **`CLAUDE.md` closes HZ at 445,944 B = 435.49 KiB — 74.51 KiB under its 510 KiB ceiling** (+3,050 B: the new rule block and
  the dump's bullet in BI §1's block): about 9.2 batches at the record — EZ's +8,293 B, still the record; the largest of the ten
  batches HQ–HZ is HS's +7,000 B — and 31 at those ten batches' mean of +2,458 B (23 without HY's −4,790 B move).
- **`docs/state.md` closes HZ at 339,252 B = 331.30 KiB — 48.70 KiB under its 380 KiB ceiling** (+1,827 B, its own post-run lines
  included). **Both readings are in its WHERE block, one line each**, for the re-measure that has not run (§5).
- **Nothing is left running**: the rows of `ps` read after the last run hold no Godot.

### §6h — THE PUSH

Committed to `class-merge` and pushed. `git ls-remote origin class-merge` is read after the push and reported in the hand-back
beside local HEAD — a commit cannot carry its own hash.
