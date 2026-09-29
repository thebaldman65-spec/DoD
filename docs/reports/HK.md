# BATCH HK — RUNES DROP, AND THERE IS A BAG

**On `class-merge`, from `a3a90fd` (HJ). IMPLEMENT ONLY. The first batch after the merge closed, and the first
authored from a playthrough.** A rune now drops after every normal fight, at random, into a **bag of twenty** the
heroes share (§1, §2); the Peddler sells runes at **150g** and **buys them back for a third** (§3); and a third rune
scope, **`party`**, is built with its own slot and **no rune in it** (§4) — the slot is called **the Crest** on every
screen, because *party* is retired from player-facing text (NEEDS A RULING 1). **No rune was authored, retuned or
re-scoped**: the one magnitude that moved is the ruled price, on the ninety-nine live entries and nothing else. A
new gate, `check_hk`, drives all of it, **a whole run on the real screens among it** (§7). The saves were backed up and
verified by hash first; a save written by HEAD's own code, with runes worn and unworn, was opened in this build
through the real Continue and lost nothing (§2d). **The battery reads green**: the pre-pass and the acceptance run each
read `check_de` **525 / 0 / 0**, the prediction exactly, with the two sanctioned reds at their counts and not one file
moved under the acceptance run (§7g).

## NEEDS A RULING — FOUR, AND NOTHING WAITS ON THEM

1. **THE CREST — THE SCREEN WORD FOR THE PARTY SLOT (PROPOSED).** The ruled scope keeps its name, `party`, in the code
   and the data; every screen says **Crest** ("Crest: — empty —" on the map, "THE CREST — 0 of 1 filled" in the bag, a
   crest rune "for the crest"). The reason is a standing rule, not taste: **"party" is retired from every string a
   player reads** (DM §3, kept by `test_batch_bx` §4b), because it reads as either the four heroes or heroes and
   companions, and a crest rune reaches the four. The word was swept against the game's text and meets nothing (0
   hits in `scripts/`, `data/` or `master.html`); *Banner* and *Standard* were rejected — both are live words already.
   Confirm it, or name it.
2. **DOES AN ELITE, A MINI-BOSS OR A BOSS DROP A RUNE TOO? THIS BATCH SAYS NO (the brief's own question, §1b).** The
   ruling names normal fights, and each of the three already pays spoils of its own — **the elite already pays a rune**,
   its cache — so the drop is on the `fight` node alone. If the designer wants them to drop as well, it is one line and
   it changes what each is worth.
3. **AN OLDER BUILD OPENING A v14 SAVE LOSES THE BAG (§2c).** The bag, the crest and the waiting drops are three new
   run-level keys; an HJ build reading this save ignores them, and **its next save writes them away**. `run_state.gd`'s
   own v13 note says the first change an older build could misread destructively is the one that owes a ceiling — this
   is that change — but the brief ruled *follow the existing refusal path, invent none*, and a ceiling in this build
   could only ever refuse a LATER build's save. **So: play HK saves in HK builds.** Whether the run save should carry a
   ceiling from here on (the shape `Profile` has) is the designer's.
4. **WHAT THE FIRST CREST RUNES ARE MEANT TO READ.** §4 is the census the brief asked for. In one line: **a crest rune can
   today put a stat or a card on every hero as a fight begins, or feed the two best-holder stamps, and nothing else**;
   everything that would make it a *party*
   effect rather than four copies of a hero effect — the purse, the pouch, a victory, the companions, a condition on
   who is in the party, a trigger when any hero acts — needs new machinery first, and §4b lists which.

---

## §0 — THE BRIEF'S PREMISES, CHECKED

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`"* | **HELD** | HEAD `a3a90fd` = `origin/class-merge` = `git ls-remote origin class-merge` before anything moved; the tree clean but for the untracked `save-backups/` |
| 2 | *"HJ closed the merge — all 130 assertions dispositioned, FP's six stages done"* | **HELD** | HJ §4a (68 repaired or re-pointed, 35 folded, 27 retired) and §4b |
| 3 | *"found one layer still reads a spec: the per-lineage stat block, deliberately left"* | **HELD, WITH ITS SIBLING** | HJ §4c names two lineage layers still standing: the per-lineage stat block (`Classes.apply_spec_stats`) **and the zone-boss pools**, which stay lineage-keyed by GP's ruling. The stat block is the one no ruling covers; both are untouched here |
| 4 | *"One rune after every normal fight. Random. Not a choice."* | **BUILT** | §1 |
| 5 | *"A party is one hero of each today"* | **HELD** | `Run.new_run`'s default and the draft seat one of each class; a fixture can seat two of one (`check_hk` §1f does, to hold the rule *if parties ever vary*) |
| 6 | *"those three already award relics, ability picks, slots and gold"* | **TRUE OF THE THREE TOGETHER, NOT OF EACH** | a **zone boss** pays gold, a relic unlock, a talent point per class (to the profile), a slot and an ability pick; an **elite** pays gold (80–100), a consumable, a draft to every living hero **and a rune cache** — a rune already; a **mini-boss** pays gold (80–100) and an upgrade pick. Only the boss awards a relic or a slot (§1b) |
| 7 | *"Twenty runes, shared across the party. Equipping is still capped per hero — three ordinary slots, two engine slots, and one party slot per §4"* | **HELD, AND READ AS ONE PARTY SLOT FOR THE PARTY** | `rune_slots()` is a flat 3 and `ENGINE_SLOTS` 2 (unchanged); §4 says the party slot *does NOT take a hero's* and *which one the party carries is an identity*, so it is **one slot for the whole party**, not one a hero (§4a) |
| 8 | *"follow `run_state.gd`'s existing refusal path"* | **FOLLOWED** | the one refusal is `save_version < 10`; v11, v12 and v13 each moved the version for new run-level state and stayed tolerant, and v14 does the same (§2c). No refusal was added |
| 9 | *"A rune costs 150g"* | **RULED AND BUILT; IT WAS 100g** | EZ §0's flat 100 on every live rune; the ninety-nine live entries read 150 now (§3a) |
| 10 | *"Selling one returns 50g"* | **BUILT; NOTHING SOLD A RUNE BEFORE** | the Peddler sold items back at two fifths and runes not at all; `Run.RUNE_SELL_FRACTION` is a third (§3b) |
| 11 | *"He sells runes and items both"* | **HELD** | and since HK he buys runes too |
| 12 | *"GV gates a rune from being offered without its engine, and that gate still applies at his door"* | **HELD, AND DRIVEN BOTH WAYS** | his roll is `Run.generate_rune` → `Runes.eligible_ids` → `Runes.offerable`; `check_hk` §3e holds it at his counter and §1h at the drop, and control C13 (the gate removed) reds both |
| 13 | *"Nothing in this game reads the party as a whole — every rune, card, node and engine reads one hero"* | **HELD AT TURN TIME; NOT AT THE SPAWN, AND NOT FOR RELICS** | two talent fields are read across every hero and the best holder's figure stamped on all (Devoutness, Last Hope), two engines wire every hero when any hero holds them (Conviction's absorbs, the Mercy engine's Intercession), and every relic hook is party-wide by construction. §4a is the census |
| 14 | *"GK built the engine slots and GO filled them nine batches later"* | **FOUR BATCHES LATER** | GK, GL, GM, GN, GO: GO is the fourth batch after GK. What GO added was **nine** engines (the rule engines, to make six a class) — the two nines look to have merged |
| 15 | *"The rune-offer gates will move — `check_gv`, `check_hc`, `check_he` all read what a hero is offered"* | **HALF: TWO DID NOT MOVE** | HEAD's `check_gv` (1037 / 0) and `check_hc` (74 / 0) read green and unmoved on HK's code — what a hero is offered did not change. `check_he` moved (249 / 3), and not for what it reads: its stand-in member met a party holding runes (§7b) |
| 16 | *"The battery runs about 71 minutes"* | **HELD** | the recon 71 min 20 s, the pre-pass 72 min 23 s, the acceptance run 72 min 27 s — 127 targets now, `check_hk`'s minute among them (§7g) |
| 17 | *"`docs/state.md` rewritten … and the stamp"* | **DONE** | `master.html`'s *Last updated* is HK's, and `state.md`'s *Last rewritten* |

---

## §1 — A RUNE DROPS AFTER EVERY NORMAL FIGHT

### §1a — WHAT SHIPPED

- **ONE RUNE AFTER EVERY NORMAL FIGHT WON, RANDOM, INTO THE BAG.** `battle._check_end`'s victory branch calls the one
  door, `Run.drop_after_fight`, under `node_type == "fight"`, and the victory card names the drop — *"RUNE DROP: Deep
  Cold, for the Mage — into the bag."* — or says the bag is full and the map holds it, or that nothing was left.
- **THE DRAW (`Run.roll_fight_drop`) IS THE UNION OF WHAT EVERY HERO COULD BE OFFERED, LESS WHAT THE PARTY HOLDS, AND ONE
  IS PICKED FLAT.** Each hero's `Runes.eligible_ids` — so GV's engine gate, a rune's required card and HB's pet gate
  hold at the drop exactly as at the Peddler, a cache, the bargain and the event verb — deduped by id. **Its class is
  therefore always one the party holds**, and a party of two Warriors, a Mage and a Cleric is never dropped a Hunter
  rune (`check_hk` §1f).
- **FLAT OVER RUNES, NOT A CLASS FIRST — THE IMPLEMENTATION CALL, STATED.** A class-first draw gives each class a
  quarter of the drops whatever its pool holds; flat, a class with more runes it can use is dropped more of them.
  **The reason for flat is the crest**: *they drop from the same source as any other rune*, and a class-first draw
  with the crest as a fifth bucket would hand one crest rune a fifth of every drop. Flat, it is one entry among the
  rest. Class-first is one function if the designer prefers even shares.
- **RUNES OFF (`DOD_SIM_RUNES=off`) DROPS NOTHING AND SAYS NOTHING**, the silence every rune door keeps there; the
  `stats` arm drops a stat stick, as its roll does.

### §1b — WHAT AN ELITE, A MINI-BOSS AND A BOSS DROP (the brief asked; nothing was extended)

| encounter | what it pays, before and after HK | a rune drop? |
|---|---|---|
| **normal fight** | gold (45–60) **+ one rune into the bag (new)** | **yes** |
| **elite** | gold (80–100), a consumable (+ the Gravelight Lantern's), a draft offer to every living hero, **and a rune cache** (three candidates, one chosen, for a random hero) | **no** — it already pays a rune |
| **mini-boss** | gold (80–100) and an ability-upgrade pick for every hero | **no** |
| **zone boss** | gold (110–130), a relic unlock, a talent point per class (to the profile), a slot and an ability pick for every hero | **no** |
| **end boss** | gold, a relic, and the talent tier it opens | **no** |

**Why none of them**: the ruling rules *normal fights*, and the brief said to report rather than extend. Each of the
four pays its own spoils already, the elite a rune among them. `check_hk` §1b–§1d fight all three on the real battle
scene and assert **no drop, and the spoils they do pay** (the cache, the upgrade picks, the ability picks) — an
absence paired with the positive arm that the victory branch ran and paid.

---

## §2 — THE BAG HOLDS TWENTY

### §2a — WHAT SHIPPED

- **`Run.rune_bag`: every rune the heroes hold and nobody wears, shared, `BAG_CAP` = 20.** A hero's `runes` are the
  ordinary runes he WEARS (three), his `engines` the engine runes he has SLOTTED (two), and the crest's rune is
  `Run.party_runes` (one). **A worn rune is not counted against the twenty, and that is structural**: four heroes'
  three and two, and the crest's one, are twenty-one slots — a bag that counted what it lent out could never be worn
  full.
- **EQUIP FROM THE BAG, UNEQUIP BACK INTO IT.** Each hero's rune panel on the map lists what he wears and then the bag's
  runes he may wear, each with Equip or Unequip; `Run.toggle_rune`, `toggle_engine` and `toggle_party_rune` are the
  doors. **With every slot full, a bag rune shows Swap**: a chooser asks which worn rune it replaces, and the two
  change places — one rune each way, so the bag's count does not move and a swap works on a full bag.
- **A FULL BAG REFUSES AN UNEQUIP** (the button disabled, with its sentence), because a bag that let one more in
  whenever a rune came off a hero would not be a bag of twenty. The swap is the way through; so is a drop or a sale.
- **THE MAP'S NEW ROW, UNDER THE POUCH**: *"Rune bag 3/20"* (with *"(+1 waiting)"* when a drop waits) and *"Crest: —
  empty —"*. Either opens the bag's panel: the crest's slot, then every rune in the bag with the hero it is for and a
  **Drop** that asks twice — a drop from the bag is for good.
- **ENGINE RUNES TOO.** An unslotted engine rune goes into the bag (GK kept it on the hero, unslotted), and the bag's
  engine runes of his class appear in his panel's engine rows. **The charter's *dropped and swapped, including to
  nothing* stands**: unslotting is refused only while the bag is full, and the bag can now let an engine rune go for
  good — sold or dropped — the first way one leaves the heroes' hands.

### §2b — THE FULL-BAG PANEL (the brief: *report what the panel shows*)

A drop that lands on a full bag — or a cache's or an event's rune that no slot can take — **waits on
`Run.pending_rune_drops`** and the map opens a panel over the board the next time it is on screen (chained after the
pouch's own swap offer, so two overlays never open at once):

- **the title**: *"THE BAG IS FULL — 20 of 20"*;
- **the drop**: *"A rune has dropped: Deep Cold, for the Mage."* and its rule text, in the bag's own words;
- **the ask**: *"To take it, drop one of the twenty. Or leave it behind."*;
- **the twenty**, in one scroller, each row *"Drop this"* beside the rune's name, whose rune it is and its rule —
  pressing one drops that rune for good and puts the new one in its place;
- **below the scroller, where no text can move it** (GT §1): *"Leave Deep Cold behind"* — **declining the drop itself,
  always allowed**, as ruled.

One drop at a time, re-opened for the next. A rune the bag has room for by the time the panel would open — a sale or a
drop on the way — goes straight in. **A waiting rune is still the party's** (`Run.party_rune_names` lists it), so
nothing offers it twice while it waits; declined, it is gone and can be offered again later.

### §2c — WHERE THE BAG LIVES IN THE SAVE, AND THE VERSION

- **Three run-level keys in `user://run_save.bin`**: `rune_bag`, `crest` (the crest's worn runes — `Run.party_runes`,
  saved under its screen word because *party* is retired from every string a sweep reads) and `pending_rune_drops`.
- **IT MOVES THE VERSION, v13 → v14, TOLERANTLY, AND THE REFUSAL THRESHOLD DOES NOT MOVE.** That is the existing path:
  v11 (the pouch's offers), v12 (the slot ladder) and v13 (the step in flight) each moved the version for new run-level
  state and none raised the `< 10` refusal; the member-dict keys that rode the party (GK's engines, GH's losses) moved
  none. The bag is run-level, so it moves one. **A v13 save is not refused**: it loads with the three keys empty and the
  migration below runs.
- **THE HAZARD IN THE OTHER DIRECTION (NEEDS A RULING 3)**: an older build reading a v14 save ignores the three keys, and
  its next save drops the bag. No ceiling was invented.

### §2d — WHAT HAPPENS TO RUNES A HERO ALREADY WEARS (the migration)

- **WHAT HE WEARS HE GOES ON WEARING, IN THE SAME SLOTS, AND WHAT HE HELD UNWORN MOVES INTO THE BAG.** `Run._bag_the_unworn`
  runs on every load (a no-op on a save the bag wrote): an unequipped rune in a hero's `runes` and an unslotted engine
  rune in his `engines` go into the bag, in the order he held them; nothing equipped is touched. **The bag may open
  past twenty — nothing is dropped, sold or refused — and the cap binds at intake from then on**: the next drop waits.
- **DRIVEN, ON A SAVE HEAD WROTE.** An isolated copy of HEAD (`a3a90fd`, proved byte for byte: 438 tracked files, none
  differing) loaded the designer's own save and handed runes out **through HEAD's own doors** — the Warrior wearing Long
  Watch and Last Word with Whetstone unworn in his pouch, the Mage slotting a second engine (the Rune of the Pyromancer)
  and unslotting it, the Cleric an unanswered cache, the Hunter wearing Keen Focus — and **HEAD's `save_run` wrote it
  (v13)**. This build opened that file **through the main menu's real Continue**: 11 checks, 0 failures — the Warrior
  wears Long Watch and Last Word, in order; the bag holds Whetstone and the Rune of the Pyromancer, in the order held;
  the Mage keeps his one slotted engine; the Hunter still wears Keen Focus; the Cleric's cache is still owed; the map's
  row reads 2/20; the Warrior's panel equips Whetstone out of the bag; and the save is written back with the bag.
- **AND THE DESIGNER'S OWN SAVE, UNMODIFIED** (a copy, in an isolated copy of the tree): Continue lands on the map with
  an empty bag and an empty crest and every hero's engine still slotted; the next normal fight on that road dropped a
  rune into the bag (*Deep Cold, for the Mage* on the first reading and *Grudge, for the Warrior* on the final code's —
  the drop is random), and the map read 1/20 — 11 checks, 0 failures, both times. The save holds no ordinary rune today,
  so nothing moved on it.
- **`check_hk` §5 ASKS IT EVERY BATTERY** on a v13-shaped save it builds: worn runes kept in order, the unworn and the
  unslotted engine first in the bag in held order, the whole multiset of runes conserved, and the bag opening past
  twenty with the next drop waiting.

---

## §3 — THE PEDDLER BUYS AND SELLS

### §3a — WHAT HE OFFERS NOW, AND WHAT CHANGED

| | before HK | since HK |
|---|---|---|
| **supplies** | eight item types, bought and sold (two fifths back) | unchanged |
| **the rune offer** | one rune for every hero, rolled for him through the gates (GV's engine gate among them) | **the same roll, never a rune the party already holds** — in the bag, on any hero, in the crest, or waiting on the panel — **and never one already on the counter for another hero** (so a crest rune, which rolls for every hero, is offered once) |
| **the price** | 100g, the flat EZ price | **150g**, flat (the data's `price` on the 99 live entries; the retired keep theirs) |
| **where a bought rune goes** | an ordinary rune into that hero's pouch, unequipped; an engine rune slotted if a slot was free | **into the bag**, every kind — equipping is a separate act, on the map |
| **a full bag** | — | **every Buy greyed, and the rune column says so** (*"The bag is full at 20. Sell a rune from it, on the left, to buy one."*); selling one makes room |
| **selling a rune** | nothing sold a rune | **SELL FROM THE BAG**, in the left column under the supplies (empty since FD §1): one row per rune in the bag, each *"Sell +50g"*, two presses — a third of what he would charge for it |

- **CAN HE SELL A RUNE THE PARTY ALREADY HOLDS? NO.** Every roll excludes `Run.party_rune_names`; `check_hk` §3d holds
  every rune the Warrior could be offered but one, and his offer is that one — hold it too, and the column says the
  Peddler has nothing for him, with the reason.
- **WORN RUNES ARE NOT SOLD FROM THE COUNTER**: a rune is sold from the bag, and unequipping it on the map puts it there.
- **THE DISCOUNT CUTS BOTH HALVES.** `Run.rune_price` and `Run.rune_sell_value` read the one price
  (`Runes.price_of`, live off the data by id, so a rune bought at 100g before this batch sells at today's 150/3) with
  the Peddler's Lodestone on both: 120g and 40g under it, never an arbitrage.

### §3b — GV'S GATE AT HIS DOOR, DRIVEN

`check_hk` §3e unslots the Mage's engine and holds every rune he could be offered that does not read it: the Peddler
has **nothing** for him. Slot it back and **his offer is one of that engine's rows**. The drop is asked the same way at
§1h, and control C13 — the gate removed at `Runes.offerable`, its one door — reds exactly those two arms.

---

## §4 — PARTY RUNES: THE MACHINERY, AND NO CONTENT

### §4a — WHAT IS BUILT

- **THE SCOPE: `party`**, a third band beside `universal` and `class:<key>` in `Runes._scope_ok`, which passes it for
  every hero because it names no class; a `spec:` entry is still refused. `Runes.is_party_rune`, `Runes.wearable_by`
  (a hero can never wear one in his own slots) and `Runes.rune_class` (empty for a crest rune) are the doors.
- **THE SLOT: `Run.party_runes`, capped by `Run.PARTY_RUNE_SLOTS` = 1** — the one constant every reader asks
  (`check_hk` §4 asserts every comparison of the slot's size in the game reads it, and that there are some). **It takes
  no hero's slot.** Raising the cap is one edit.
- **THE DROP, THE PEDDLER, THE BAG**: a crest rune is in every hero's eligible set, so the drop's union holds it once and
  the Peddler offers it to one hero at a visit; it sits in the bag like any other rune and is equipped into the crest
  from the bag's panel (Swap when the crest is filled).
- **THE EFFECT: ITS PAYLOAD ON EVERY HERO AT THE SPAWN.** The battle applies a worn crest rune's payload to each of the
  four through `Talents.apply_payload` — where every rune's payload is applied — and names it once in the opening
  roll call (*"Rune: the crest: <name>"*); the hero sheet mirrors it, so the sheet's numbers are the fight's. **Hero, not
  ally**: it is stamped where the four are built, before any companion exists.
- **THE DISPLAY**: the map's *"Crest: — empty —"* button, the bag panel's *"THE CREST — 0 of 1 filled"* with *"No crest rune
  held. A rune in the crest is worn by every hero at once."*, and a worn crest rune on the hero sheet under the state
  *CREST*.
- **AUTHORED: NONE.** `data/runes.json` holds no `party` entry (`check_hk` §4 asserts it), and every door above is driven
  in `check_hk` §4 over two crest runes the gate builds and puts into `Runes`' loaded table for that section only —
  never into the file: in every hero's scope and eligible set and in none of their own slots; the drop's union holding
  them once; the Peddler offering each to one hero; one crest slot, the second refused and the swap going through; the
  map's button and the bag's section naming the worn one; **+7 maximum health on all four heroes at the spawn, against
  a control spawn without it**; the roll call naming it once; and the save carrying it.

### §4b — WHAT A PARTY RUNE COULD READ TODAY, AND WHAT IT COULD NOT (the census the design pass is built on)

**What a crest rune IS, mechanically, since HK: a rune payload applied to every hero at the battle spawn.** The payload
vocabulary is `Talents.apply_payload`'s — `stat` (a number on a hero's fields), `ability` (a named card's fields),
`grant_ability` / `new_ability` (a card added), and a `condition` (`has_node`, `owns_ability`, both read off that one
hero). So:

**AVAILABLE AT A PARTY LEVEL TODAY — and what a crest rune can use of each:**

| what reads more than one hero | where | can a crest rune use it? |
|---|---|---|
| **a stat on every hero** | the spawn, per hero, through `apply_payload` (HK) | **yes — the one thing it does today**: any field a rune's `stat` can write, on all four |
| **a card added to every hero** | `new_ability` / `grant_ability` through the same door | **yes, in principle** — every hero would get the card for the fight; it lands on the battle's copy, never the member's, so the slot ladder never sees it (EA's rule) |
| **a named card changed** | `ability` payloads | **effectively no** — no card is shared across classes, so a class-neutral rune naming one reaches only the hero who holds it |
| **the best holder's figure, stamped on every hero** | `_spawn_units`: Devoutness (`devoutness_ranks` + `rune_devoutness_ranks`) and Last Hope (`last_hope_pct` + `rune_last_hope_pct`) take the highest hero's value and stamp it on all four | **yes, and it is the one party-wide door a rune already feeds** — a crest rune writing `rune_devoutness_ranks` or `rune_last_hope_pct` lands on every hero and the stamp reads it once; stacking with a hero who has the node is the max, not a sum |
| **"any hero holds it" wiring** | `_spawn_units`: Conviction's absorb callbacks and the Mercy engine's Intercession are wired on every hero when any hero holds the engine | **no** — keyed to an engine, which a crest rune does not hold |
| **every relic hook** (`relics.gd`'s vocabulary: the opening purse and pouch, spawn stats, victory heal / Mana / gold, gold found, shop prices, elite loot) | `Run.relic_add` / `relic_dict`, which sum over `active_relics` only | **no** — a crest rune's payload goes to a hero's fields, never to a hook; reaching one needs a second reader of that hook |
| **card effects that reach every hero** (Battle Shout, the Defense Potion, Consecration and the rest) | the battle's collections (`heroes`, `_hero_side()`), always from one caster | **no** — they are cast, not worn |
| **the event conditions and targets** | `events.gd`: the `party` target, `spec_in_party`, `fallen_hero` | **no** — events read them; no payload can |
| **run-level state**: gold, the pouch, the bag, wins, zone, rung, the map, the ledger | `Run` | **no** — nothing reads run state into a payload |

**WHAT A CREST RUNE COULD NOT REACH WITHOUT NEW MACHINERY** — each a door that does not exist yet:

1. **ANY RELIC-SHAPED EFFECT** — the purse, the pouch, a victory's heal or gold, gold found, shop prices, elite loot.
   *Needs*: `Run.relic_add` (or a sibling) to also read worn crest runes' hooks. **A new reader of a hook is a bigger
   decision than a new relic** (EN §4) — every hook was built to be read at one site.
2. **THE COMPANIONS.** The spawn stamp runs before a companion exists; `_do_summon` hands a companion a few of its
   hunter's fields and no rune's but the Shared Hide's (GW §1). *Needs*: a crossing at `_do_summon`.
3. **A CONDITION ON WHO IS IN THE PARTY** — "if a Cleric stands", "with all four alive". `condition_met` reads one hero's
   nodes and owned cards. *Needs*: a party-level condition the spawn can evaluate.
4. **A TRIGGER WHEN ANY HERO ACTS** — "when any hero lands a critical, every hero …". Every read site in a fight reads
   one unit; there is no party event. *Needs*: a door at the strike loop or the damage door that reads the crest.
5. **A SHARED METER** — a pool the party builds together. None exists at any layer.
6. **THE MAP AND THE REWARDS** — the route, the drop, a cache, the bag itself. Nothing reads a rune outside a fight.
7. **THE ENEMY SIDE** — an aura on the warband. `relics.gd` lists enemy-side auras among its *NEEDS PLUMBING*.
8. **A CARD EVERY CLASS HOLDS** — there is none, so an `ability` payload cannot be class-neutral.

**So the honest summary for the design pass**: the first crest runes can be *stat on every hero* runes, or *a card for
every hero* runes, or feed the two best-holder stamps, with no new code. **Anything that reads the party as a party —
its money, its composition, its companions, its shared moments — is new machinery**, and each of the eight above is a
door to build before a rune that uses it is authored.

---

## §5 — WHAT WAS DELIBERATELY NOT DONE

- **No party rune is authored** (ruled), and none is in the data; §4's two are fixture-only.
- **No rune is retuned or re-scoped.** The price moved by ruling, as a data edit on the ninety-nine live entries'
  `price` and nothing else (every other field byte-unchanged, proved); the retired keep their authored prices.
- **The defects found in play are not touched** — Fireball dragging Razor Ice, core runes at the store, a bought rune not
  appearing, Seasoned Fighter with no stance change, Hunter's Preparation demanding a target — **and one of them is
  touched by this batch's path, so it is named**: *a bought rune not appearing*. HEAD put a bought ordinary rune into the
  hero's pouch unequipped, where the map card (which draws only worn runes) never showed it; **since HK a bought rune goes
  into the bag and the map's bag row counts it**. Whether that is the defect the designer met is theirs to say; nothing was
  changed to address it.
- **The Core Rune rename and the ruled magnitudes** ride with the defects' batch.
- **The per-lineage stat block stays** (HJ's finding), and so do the lineage-keyed zone-boss pools.
- **Elites, mini-bosses and bosses drop no rune** (§1b; NEEDS A RULING 2).
- **No save ceiling** (NEEDS A RULING 3).
- **The sim bot never swaps, drops or sells** — it wears a drop while a slot it fits is free and lets it go on a full bag
  (its policy, stated in `run_sim.gd`'s header); no battery target measures the sim's economy, so no baseline moves for it.
- **The `.docx` exports are not rebuilt** (ruled at FG).

## §6 — FOUND AND NOT FIXED

- **THE POUCH'S SCROLLER IS 25 PIXELS SHORTER, AND A FULL BAG SCROLLS IT.** The bag's line above the scroller (*"THE BAG:
  3 of 20, held for every hero…"*) takes 583 px down to 558; the longest configuration GT sized for — a class's six, two
  slotted and four in the bag — lists at 411 px, so 147 px are left. **What no longer fits is new**: a bag holding twenty
  of one class's runes puts up to twenty-five rows on his pouch — `check_gt` §1's new arm lays twenty-four, and they
  read 873–935 px — and it scrolls, with Close where it always is. That is GT's rule's second half — *only where the longest genuinely cannot fit, scroll the
  text and pin the button* — and not a defect; recorded because the pouch was sized never to scroll until now.
- **THE PEDDLER'S LEFT COLUMN IS FULL AGAIN.** FD §1 left it empty from 452 to Leave; the bag's sale rows fill it (a
  scroller from 476 to the rune column's foot). HEAD's `check_gt` located the rune column as the LAST scroller the
  Peddler drew, which is the sale column now — found by the recon, re-pointed (§7b, §7c).
- **FOUR GATES MEASURED A STAND-IN MEMBER BESIDE A PARTY THAT HELD RUNES** (§7c). Not a defect in the game — the party-wide
  exclusion is the ruling working — but the shape will meet the next gate that rolls for a member outside the party.
- **THE `price` FIELD OF A RETIRED RUNE IS HISTORY THAT NOW SELLS.** A saved run can still hold a retired rune, and the
  Peddler buys it back at a third of its authored price (75, 100, 120, 160 or 50g) — the one place a retired price is
  read. Not a defect; named so it is not found later as one.
- **`Run.grant_rune` STILL RETURNS A RUNE IT DOES NOT PUT DOWN.** Its two callers put it down at `Run.hold_rune`, which
  sends what is not worn to the bag since HK; the shape is the one `docs/state.md` has carried since FH, unchanged.
- **FIFTY-ONE ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named *"Dawn of Decay HK
  …"*: *head*, *work*, *recon* and *prepass*; *trace head*, *trace new*, *trace nodrop* and *trace final*; fourteen
  *ctl C…* (the first round) and twenty-nine *ctl2 …* (the second round, and the three re-runs). Each was renamed so its
  `user://` could not reach the player's saves; they hold nothing a player needs and can be deleted. This batch's
  backup is `../save-backups/HK-20260928-170304`.

---

## §7 — VERIFICATION

### §7a — THE PLAYER'S FILES, FIRST

Backed up to `../save-backups/HK-20260928-170304` at 17:03, before anything ran, and verified by md5 byte-identical to
the live folder: `profile.json` `2892470f…`, `relics.json` `fdc12ffa…`, `run_save.bin` `fa85daa9…`, `settings.cfg`
`0c1b39c3…`. **Two moved since HJ's backup** (`profile.json` and `run_save.bin`, written 16:22–16:24 today, before this
session began — the designer played: zone 1, the first fight won, each hero's one engine slotted), so HK's backup is the
reference. **After the recon, the controls, the traces, the drives, the pre-pass and the acceptance run — which plays in
the live game's own `user://` — the four live files are byte-identical to it**: md5 read again after the acceptance run,
the same four hashes.

### §7b — HEAD's UNMODIFIED GATES AGAINST THE NEW CODE

**The whole battery, HEAD's every gate, suite and fixture (`a3a90fd`) against HK's game edits, in an isolated copy
("Dawn of Decay HK recon"), before any gate was touched.** The prediction was written at 19:14:10 and the run launched
at 19:14:46; it finished at 20:26:06 — **71.3 minutes**, 126 targets in one ascending sequence, no duplicate, no
`Parse Error`. Every red was read by its FAIL text:

| target | HEAD's gate on HK's code | why | predicted? |
|---|---|---|---|
| `check_ez` | 129 / 16 | §0: the flat price pinned at 100 — the equality and HF's fifteen | yes |
| `check_fk` | 65 / 2 | §1: the flat 100, live runes and engine runes | yes |
| `check_fn` | 81 / 1 | §1a: the eight at the flat 100 | yes |
| `check_fo` | 90 / 2 | §1b, §2c: Deepening Hex and the Shared Mark at 100 | yes |
| `check_go` | 401 / 9 | §0: the nine rule engines at the flat 100 | yes |
| `check_hf` | 306 / 27 | fifteen at the flat 100, and **twelve** *"a mage/cleric/hunter holding no engine was never offered X at one of the doors"* — **a phantom member measured beside a party that holds runes**: since HK every roll excludes what the PARTY holds, and §3 rolls for a member outside the party after an arm that left three seats holding every rune they could be offered | the price, yes; the twelve, no |
| `check_he` | 249 / 3 | §1: the same shape — the Peddler and a cache measured for a phantom Hunter after the Mage's arm left the Hunter's seat holding Long Poison (*"Peddler 0, cache 0, bargain 84"*), and two cache answers withholding the Warrior's runes a stale party held | the gate, yes; the cause, no |
| `check_fd` | 52 / 1 | §1a: the Peddler's pinned call moved (`Run.generate_rune(member, on_counter)`) | no |
| `check_fh` | 164 / 2 | §3: a rune bought goes into the bag, and the gate asked the hero's pouch to grow | yes |
| `check_fm` | 82 / 2 | §1a: **a real defect in HK's code** — the drop's `stats` branch reached the generated family itself, a second reach FM §1 forbids (*"built at run_state.gd, run_state.gd"*); fixed in the code, through `generate_rune`. §4: a phantom member beside a party holding runes, as above | yes, the Peddler; the defect, no |
| `check_gs` | 749 / 1 | §4: the surfaces that show a rune's text pinned at six; HK has thirteen | no |
| `check_gt` | 3186 / 67, **1 throw** | four causes: **the Peddler's new sale column is a second scroller**, and HEAD's locator kept the LAST one drawn — it measured the sale rows as the rune column (12 *"Buy N cannot be scrolled wholly into view"*, Godot's *"Must be an ancestor of the control"* under each, and *"the offers stack 37 px in a 156 px column"*, which is the empty bag's sentence); a purchase lands in the bag (12); an unslotted engine goes to the bag, so §1's toggle pressed row 0 twice and indexed an empty list (the throw, and 2); and §3's fixture starts a new run, which emptied the bag the dropped engine was in (41) | the pouch and the bag, yes; the scroller, no |
| `test_batch_bj` | 70 / 1 | §2: the glossary's runes entry lost *"three slots per hero"* in HK's rewrite | no |
| `check_gp` | **444 / 0, FELL from 446** | the road's per-card arm counts the cards the seeded road shows the party, and **the drop spends the dice after every normal fight** — traced below | no |

**Sanctioned and inside their bands:** `check_cm_live` 13 / 4 (unchanged) and `check_gj` 70 / 1 — the Tollkeeper's Bell's
twenty gold, unchanged, now read as *"+173 gold and the purse moved 193"* (HJ: +167 / 187), because HK's road is a
different road. **Green and unmoved, which the brief expected to move: `check_gv` 1037 / 0 and `check_hc` 74 / 0** — what a
hero is offered did not change; `check_he`'s three were the stale party, not the offer gate. The harness read 22 / 382 / 8,
the map scenes read as they do, and `check_de` 521 / 16 named exactly the targets above.

**`check_gp`'s two, TRACED.** HEAD's `check_gp` was run with every `ok()` printed, on HEAD's tree and on HK's code:
**the only messages that differ are the road's per-card family** (*"the engine-less X was OFFERED Y"*: 29 went, 27 came);
every fixed-population arm reads the same. The road itself differs: 34 battles to 29 (no engine) and 30 (two engines),
and the two-engine party shown 42 cards where it was shown 81. **Then the drop was stubbed out in a third copy — `drop_after_fight`
returning nothing, its dice unspent — and HEAD's `check_gp` read 446 / 0 with a trace byte-identical to HEAD-on-HEAD**:
34 battles, 81 cards. The move is the drop's and nothing else's; the row moves with it (§7c).

### §7c — WHAT MOVED IN THE GATES, AND WHY

Every re-point is to intent, with its reason written at the site; nothing was deleted or loosened.

| target | row before | after | what changed in the gate | why |
|---|---|---|---|---|
| `check_ez` | 129 / 0 | 129 / 0 | §0's equality and HF's fifteen read 150 | the ruled price |
| `check_fk` | 65 / 0 | 65 / 0 | 150, three places, and the text | the price |
| `check_fn` | 81 / 0 | 81 / 0 | the flat price per entry: 150 live, the retired Wide Watch's authored 100 | the price moved on live runes only |
| `check_fo` | 90 / 0 | 90 / 0 | §1b, §2c read 150; §2a's retired Wide Watch stays 100 | the price |
| `check_go` | 401 / 0 | 401 / 0 | 150 | the price |
| `check_hf` | 306 / 0 | 306 / 0 | 150; §3 seats a fresh party before each class's Peddler and cache tallies, and before the Hunter's arms | the price; **a roll refuses what the party holds** |
| `check_he` | 249 / 0 | 249 / 0 | §1 seats a fresh party before every arm's tallies and every cache answer | a roll refuses what the party holds |
| `check_fm` | 82 / 0 | 82 / 0 | §4 seats a fresh party first | the same |
| `check_fh` | 164 / 0 | 164 / 0 | §3 asks the bag for the bought rune, and the hero's lists for NOT growing | a purchase goes into the bag |
| `check_fd` | 52 / 0 | **53 / 0** | `OFFER_SITES` is a list of pairs (`battle.gd` holds two sites now): the Peddler's call as it is, and **the drop as the fifth door**, drawn 60 times in §1b (+1, *the drop door rolled*) | a new offer site |
| `check_gs` | 749 / 0 | **824 / 0** | §4's equality 6 → 13; §4b drives the bag's panel, the full-bag panel and the Peddler's sale rows with all twenty-four engine runes (+72, and +3 for the three tallies) | seven new surfaces show a rune's text, each through the door |
| `check_gt` | 3187 / 0 | **3479 / 0** | the column is **the scroller that holds the Buy buttons**; a purchase is asked of the bag; §1's configurations hold the runes where the game holds them — two slotted, the rest in the bag, and the ordinary rune his class's longest, in the bag (its row is read now: +264); the toggle's row is read off `Run.engine_rows`; §3's `_bar` keeps the bag across its fixture; and **a new arm, a full bag of his class's runes, three worn and two slotted** — the list scrolls, Close does not move, the last row's button scrolls into view, no row for a rune he may not wear (+28) | the bag |
| `check_gp` | 446 / 0 | **444 / 0** | nothing; the row moves | the drop's dice (§7b, traced) |
| `check_da` | 41 / 0 | 41 / 0 | nothing — `check_hk` first entered the battle scene by hand, which §3 refuses (DB §1: 42 / 2 on the first run), so the fixture carries the door now, `Gate.enter_battle` | the new gate |
| `check_parse` | 200 / 0 | **201 / 0** | nothing | `check_hk` joined GATES |
| `check_de` | 521 | **525** | nothing | `check_hk`'s row, +4 |
| `test_batch_bj` | 70 / 0 | 70 / 0 | nothing | the glossary's runes entry says *three slots per hero* again |
| **`check_hk`** | — | **140 / 0, NEW** | §0–§8 (§7d) | — |

**The fixture gained two things, both additive**: `Gate.spawn`'s `party_runes` option (the crest's worn runes, stamped
in `party`'s window) and `Gate.enter_battle`, the battle scene for the run in hand — `spawn` starts a new run, which is
wrong for a check about what a victory does to the run's bag.

**THE SHAPE FOUR GATES MET, NAMED SO THE NEXT GATE MEETS IT ONCE: a member built outside the party is measured beside the
party.** Since HK every roll excludes `Run.party_rune_names` — the bag, the crest, a waiting drop and every hero's worn
runes — where HEAD excluded only the member's own. `check_hf` §3, `check_he` §1 and `check_fm` §4 each roll for a
stand-in member after an earlier arm left the run's party holding runes, and were refused them; `check_gt` §3's fixture
threw the bag away between the drop and the save. Each now starts from a fresh party where it measures one.

### §7d — `check_hk`, AND EVERY ARM SHOWN TO BITE

**`check_hk` is 140 checks, 0 failures, about a minute**: §0 the player's files and the scratch paths; §1 the drop (a
normal fight drops one and the card names it; an elite, a mini-boss and a boss drop none and pay their own spoils; the
one call site; only classes the party holds, with two Warriors seated; never a held rune; GV's gate at the drop, both
ways); §2 the bag (twenty; the twenty-first waits; the full-bag panel through its own buttons, a drop and a decline; a
worn rune not counted; a full bag refusing an unequip, and the swap; an engine unslotted into the bag; the bag's
two-press Drop); §3 the Peddler (150 and 50, and 120 and 40 under the discount; a purchase into the bag through the
button; the two-press sale; a full bag greying every Buy and saying so, and one sale bringing them back; never a held
rune; GV's gate at his counter, both ways); §4 the crest (none authored; one slot, read off the constant; two fixture
crest runes through every door, +7 maximum health on all four against a control spawn, named once, saved); §5 the save
(v14's keys, the round trip, the `< 10` refusal where it was, a v13-shaped save migrated and the next drop waiting); §6
the sim (the one site, the bot's policy, a decline on a full bag); **§7 the whole run on the real screens**, from the map
to the end boss's door (on the last reading: 37 battles, 23 normal fights, every normal fight's card naming a drop and no
other card, the bag at twenty, the full-bag panel taken once and left six times, a sale and a purchase at the first
merchant, two runes equipped from the bag and one put back); §8 the player's files as they were.

**Every control is one defect in its own isolated copy of the final tree, predicted in writing before it ran
(`PREDICTION.md`, `PREDICTION2.md` in the scratchpad), and read by its FAIL text.** The first round (C) ran on `check_hk`
at 135 checks; all fourteen were run again on the final 140, and those are the readings below.

| ctl | the defect | what went red |
|---|---|---|
| C1 | the drop fires after an elite too | `check_hk` §1b *an elite won dropped a rune*, §1e the call site, §7 *3 elite, mini-boss or boss cards named a rune drop* |
| C2 | the bag has no cap | 13: §2a *the twenty-first drop went 'bag'*, §2b/§2c the panel never met, §5, §6, §7 *the bag reached 26* |
| C3 | rolls stop excluding what the party holds | §3d the Warrior offered a held rune, §3e, §4c *the counter held 0 crest runes* |
| C4 | the drop ignores GV's gate | §1g, §1h *the gate did not hold*, §4b |
| C5 | the migration drops unworn runes | §5 *34 before, 6 after*, the bag opening at 0 |
| C6 | the crest's payload never reaches the spawn | §4f *did not reach every hero's maximum health* |
| C7 | a purchase put down unworn on the hero | **nothing — the injection makes no defect**: `hold_rune` sends an unworn rune to the bag either way. Replaced by C7b |
| C7b | a purchase WORN on the hero | §3a *not in the bag … went onto the hero*, §3b |
| C8 | the sale is two fifths | §3 *sells for 60g*, the discount pair, §3b, §3c |
| C9 | an unequip into a full bag | §2e *a full bag did not refuse the Unequip* |
| C10 | the sim never takes the drop | §6 *RunSim's victory walk does not take the normal fight's drop* |
| C11 | the full-bag panel never opens on its own | §2b, §2c |
| C12 | a worn rune counts against the twenty | §2d *the bag took 17 before a wait*, §2f–§2h, §6, §7 |
| C13 | GV's gate removed at its one door | §1h at the drop and §3e at the Peddler — exactly those two |
| **G1** | the Peddler's Buy buttons drawn outside the rune column | `check_gt` §2 *no rune scroller* in all three deals (the locator finds no scroller holding a Buy — it does not fall back to the sale column); `check_hk` green, as predicted-maybe |
| **G2** | a purchase worn on the hero (C7b's) | `check_gt` §2 twelve *did not put it in the bag (bag [], on him [...])*; `check_fh` §3 *the bag did not grow by it alone*; `check_hk` §3a |
| **G3** | an unequip leaves the rune on the hero, HEAD's shape | `check_gt` §1 *Unequip did not move the engine's slot (in the bag false)* and §3 *dropping the engine lost the rune (bag [])* ×6; `check_hk` 10 |
| **G4** | the pouch lists bag runes he may not wear | `check_gt` §1's full-bag arm, all four classes: *his pouch lists 1 rune(s) he may not wear*, *25 row buttons for 24 rows*. **On its first reading it bit two classes of four** — the arm's bag held another class's rune only where his own class ran short — so the arm was changed to hold one in every class, and re-run: eight |
| **G5** | the save writes an empty bag | `check_gt` §3 *the save did not carry the dropped rune*, six engines and what follows; `check_hk` §5 *did not round-trip* |
| **G6** | Long Poison gated on Trapper again | `check_he` §0, §1 *never offered long_poison (0, 0, 0)*, the cache holding it back, §2 |
| **G7** | Clarity gated on Overburn | `check_hf` §0 *an engine row*, §3 *never offered clarity at one of the doors* and the spawn counts |
| **G8** | the bag's sale rows read `desc` around the door | **first reading: `check_gs` §4's count alone (*12 times*), and §4b GREEN** — a freshly built engine rune's `desc` IS its rule (`Runes._engine_fields`), so a read around the door shows the right words on a fresh build and a drive of fresh builds cannot see it. The three new drives now carry the entry's placeholder on the instance — the stale instance the door exists for — and the re-run read 26: the count, the sale rows' twenty-four, and the tally |
| **G9** | the drop goes around `Run.drop_after_fight` | `check_fd` §1a *an offer site stopped calling the door it is pinned on — battle.gd: Run.drop_after_fight()*; `check_hk` green (behaviour identical, as predicted-maybe) |
| **G10** | Deepening Hex back at 100g | `check_ez` §0, `check_fk` §1, `check_fn` §1a, `check_fo` §1b — **and the first reading printed three of those as *"every rune is 100g flat"*, *"not flat 100g"*, *"left the flat 100g"***: the assertions had moved to 150 and their messages had not. Corrected and re-run; `check_hf` green (Deepening Hex is not one of its fifteen — the prediction was wrong to name it) |
| **G11** | the `stats` drop reaches the generated family itself | `check_fm` §1a *a second reach into it exists* — the defect HEAD's `check_fm` found in HK's own code (§7b) |
| **G12** | an elite cache offers two | `check_fm` §3 and §4 *the wrong number of candidates* |

**What the controls changed**: G4 and G8 each found an arm of this batch's that could not see its defect everywhere, and
G10 found three messages that would have named the wrong price; all three were repaired and their controls re-run.

### §7e — THE DRIVES

Every drive ran in an isolated copy whose `user://` was a copy of the player's folder, and each was run again on the
final code before the pre-pass:

| drive | what it did | reading |
|---|---|---|
| **the full run** (`check_hk` §7, every battery) | a whole run from the map to the end boss's door on the real screens: drops, the bag filling to twenty, the full-bag panel met and answered both ways, a sale and a purchase at the first merchant, runes equipped from the bag and one put back | 37 battles, 23 normal fights, 140 / 0 |
| **the migration** (§2d) | a save written by HEAD's own code, with runes worn, unworn, an engine unslotted and a cache queued, opened through the main menu's Continue | 11 / 0, first and final code |
| **the designer's save** (§2d) | the player's own save, unmodified (a copy), opened through Continue and one normal fight fought on it | 11 / 0, first and final code |
| **the doors** | a scratch probe over `Run`'s new doors — hold, bag, toggle, swap, drop, sell, buy, take, decline, the crest — without a screen | 100 / 0 (the first reading's one red was the price, read at 100 before the data edit had reached that copy) |
| **the screens** | a scratch probe opening the bag's panel, the full-bag panel, the swap chooser and the Peddler's sale column and pressing their buttons | 22 / 0 |

### §7f — THE DOCUMENTS, AND THE LITERAL SWEEP

**Written before the verification run**, because suites read them: `docs/changelog.html` (HK's entry at the top),
`CLAUDE.md`, `docs/master.html` (the stamp, and every section that describes a rune's arrival, the price, the save, the
map's cards and the Peddler), `docs/design-notes.md` (HK's entry at the top), `data/glossary.json` (the Runes, Peddler
and Map Nodes entries, and the runes entry's short line) and `baselines.json` (the rows above, written by script — the
file re-dumps byte for byte at `indent=1`). `docs/state.md` is rewritten and this report written after, as both may be.

- **`CLAUDE.md` is 397,845 B = 388.52 KiB, +8,085 B on HEAD** — two new standing blocks (the drop and the bag; the party
  scope and its screen word), the price rule re-ruled at 150 with the sale beside it, and nine amendments (the save
  version in the architecture line and in the VERSIONS bullet, the pouch's engine rows, the scope bands, the engine
  rune's cost, the retired-word identifiers, and three other mentions of the price). **Under EZ's +8,293 B**, so the ceiling block's record still stands; `check_fg` §2
  reads 21.48 KiB of headroom under 410. The first draft was +8,451 B, over the record, and was tightened.
- **THE LITERAL SWEEP.** Every string literal of four characters or more in the 131 root `.gd` files — gates, suites,
  fixtures, the readers — searched in HEAD's copy and the working copy of each edited document, raw and
  whitespace-flattened, each needle attributed to the readers that carry it. **Every LOST needle's reader was checked for
  whether it opens that document**: `docs/state.md`'s five belong to gates that never open it (a print in `check_fh`, a
  word in `check_de`'s comment, three incidental paths and words); `docs/master.html`'s `untested` is a dictionary key in
  `check_co`. **Two real hits, both found and repaired before the recon**: `test_batch_bj` pins the glossary's *three
  slots per hero*, which the rewrite had dropped, and `check_fd` pins the Peddler's call, which HK changed (a source
  needle). The tool's own control breaks one needle a reader holds and reads it LOST.
- **"PARTY" IS RETIRED FROM PLAYER-FACING TEXT, AND HK'S TEXT OBEYS IT** — the screens say *Crest*, the save key is
  `crest`, and `test_batch_bx` §4b reads 159 / 0 over the new strings.

### §7g — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass** — the full battery in an isolated copy of the tree (*"Dawn of Decay HK prepass"*, with `.git` and
`DoD-archive`; proved before the run — the 441 files git tracks or holds untracked, each byte-identical but
`project.godot`, by its rename — and after it, when it held the same 493 files as the repository), its `user://` seeded
from the backup: **21:01:48 to 22:14:11, 72 min 23 s.** 127 of 127 launched, one sequence with no duplicate, and none
of the 127 logs holds a `Parse Error` or a `SCRIPT ERROR` (grepped per log); every target on its row — `check_hk` 140,
`check_gt` 3479, `check_gs` 824, `check_fd` 53, `check_parse` 201, `check_gp` 444 in 226.5 s of its 240 — the
sanctioned reds at their counts with the same text as the recon (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *"+173
gold and the purse moved 193"*), the harness 22 / 382 / 8. **`check_de` read 525 checks / 0 failures / 0 notices — the
prediction exactly**, written at 21:01:18, thirty seconds before the launch.

**What moved between the pre-pass's copy and the final tree, and the proof it moved nothing a target reads.** Six
documents: `CLAUDE.md` (the crest block's sentence on what reads the party whole, corrected to the census, and a
pronoun), the changelog (the checks paragraph, and the same overclaim cut), the design notes (the overclaim, and a
pronoun), `master.html` (the Shop line's history note replaced by the present fact), `docs/state.md` and this report.
Every string literal of the 131 root `.gd` files was searched in the copies the pre-pass read and in the final ones,
raw and whitespace-flattened: **LOST 0** but one in `state.md` (*" — it scrolls"*, which belongs to `check_gt` and
`check_gx` — neither opens it), and **GAINED 1** (*"two engines"* in `CLAUDE.md`, a road's label in `check_gp` and
`check_gv`).

**The acceptance run, in the repository, frozen**: every file on disk under the repo but `.git/`, `.godot/` and the
untracked `save-backups/`, on absolute paths — this report among them — and the player's four live files, hashed
before and after: **497 hashes, and NOT ONE MOVED.** **22:14:54 to 23:27:21, 72 min 27 s**; the prediction was written
at 22:14:46, eight seconds before the launch. 127 of 127 launched, **the same sequence as the pre-pass**, no duplicate, and none of
the 127 logs holds a `Parse Error` or a `SCRIPT ERROR`; every target on its row, `check_gp` 444 in 226.5 s again; the
sanctioned reds at their counts with the same text; the harness PASS at 22 / 382 / 8. **`check_de` read 525 checks / 0
failures / 0 notices — the prediction exactly.** The edits after the after-hash are this report's run figures and
`docs/state.md`'s verification line.

**The two post-run edits, proved against what reads them.** No target opens `docs/reports/`. `docs/state.md` has one
reader, `check_es`: every string literal of every root `.gd` (15,685) was searched in the `state.md` the acceptance run
read — its hash is in the after-freeze — and in the edited one, raw and whitespace-flattened: **0 LOST, 0 GAINED**, and
`check_es`'s own window census, reproduced, reads two windows and the same four pairs in both. `check_es` then read
**57 / 0** on the final tree in an isolated copy (proved: 493 files, only `project.godot` differing), printing two
windows and four figures for `state.md`, with `check_ed` 18 / 0 and `check_ec` 24 / 0.

---

## §8 — WHAT MOVED

- **The game, eight scripts**: `run_state.gd` (the bag, the crest, the drop, the Peddler's two halves, the rows and
  their doors, v14 and the migration), `runes.gd` (the party scope, the held list every roll takes), `battle.gd` (the
  drop at a normal fight's victory; the crest's payload at the spawn), `map_screen.gd` (the rune panel over the bag, the
  bag row, the bag's panel, the full-bag panel, the swap chooser), `shop_screen.gd` (150g, purchases into the bag, the
  sale column), `party_screen.gd` (the crest on the hero sheet), `events.gd` (the grant's line), `run_sim.gd` (the sim
  takes the drop).
- **The data**: `data/runes.json` — **the ninety-nine live entries' `price`, 100 → 150, and nothing else** (every
  other field of all 166 entries byte-unchanged, and no retired price moved); `data/glossary.json` — the runes,
  merchant and node-types entries, and the runes entry's short line.
- **The save**: v13 → **v14**, tolerant; three run-level keys; the `< 10` refusal unmoved.
- **The instruments**: `check_hk` new (140); thirteen gates re-pointed (§7c); `gate_fixture.gd` (`party_runes`,
  `enter_battle`); `run_battery.sh` (`check_hk` in GATES); `baselines.json` (five rows moved, one new, one note);
  `pin-manifest.json` 1519 → **1534** pins (+15, every one `check_hk`'s; the other diffs are line numbers).
- **The documents**: `CLAUDE.md` (397,845 B, +8,085), `docs/master.html` (the stamp and the rune sections),
  `docs/changelog.html`, `docs/design-notes.md`, `docs/state.md` (rewritten), this report. **The `.docx` exports are not
  rebuilt** (FG's ruling).
- **Not moved**: no rune authored, retuned or re-scoped; no card, engine, node, relic or enemy; no refusal path; the
  per-lineage stat block and the lineage-keyed boss pools (HJ's layer).
