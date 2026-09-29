# BATCH HL — WHAT THE PLAYTHROUGH FOUND, AND THE PARTY CONDITION

**On `class-merge`, from `c2d8e5a` (HK). IMPLEMENT ONLY.** The designer played the merged game and found five
defects; all five are diagnosed, fixed and driven both ways (§1). With them: engine runes are **core runes** on every
screen (§2), four magnitudes moved by ruling (§3), the rule the playthrough earned is recorded (§4), the run save has a
**ceiling** (§5), and a rune's condition can read **who is in the party** — its own section and list, §6. **No rune was
authored.** The letter **HM** was folded in here and is spent (§0). A new gate, `check_hl`, drives all of it.

**VERDICT: DONE, AND PUSHED.** All five defects are fixed and driven both ways, each shown red on HEAD's game; the four magnitudes, the rename, the ceiling and the condition are built and driven; no rune was authored. **The acceptance run in the repository read `check_de` 529 / 0 / 0 over 128 targets in 73 min 21 s**, the pre-pass exactly, with only the two sanctioned reds, the tree byte-identical after it and the player's files untouched. Twenty-five controls, each one defect in its own copy, bit every re-pointed pin. **Seven rulings are owed, and nothing waits on them.**

## NEEDS A RULING — SEVEN, AND NOTHING WAITS ON THEM

1. **WHICH STANCE SWAP TRAVELS WITH THE STANCES — GUARD CHANGE IS PROPOSED (§1d).** The Rune of the Swordmaster brings
   Guard Change again: it is the one *unconditional* swap (Precision Strike, Feint and Wheeling Cut cost Rage, sit on
   3–4-turn cooldowns and switch as a side effect). The charter makes *which card travels* a ruling. One consequence to
   confirm with it: **Battle Poise's free pivot needs Guard Change carried, so every Stances holder now has it** — the
   clause fires for him from the first fight where it waited on a draft before.
2. **THE STANCES' +30% / −15% WAS READ AS THE TWO HEADLINE NUMBERS (§3b).** The Aggressive guard's damage dealt goes
   +15% → **+30%**; the Defensive guard's damage taken stays **−15%** (it already was); both downsides stay 10%. The
   other reading — every stance's upside 30% and downside 15% (Aggressive +30% dealt / +15% taken; Defensive −30% taken /
   −15% dealt) — is one constant each way and would also halve what the Bared Guard's price takes back. **And Formless
   followed**: it is defined as *both stances' upsides*, so its damage term is 1.30 now (its card says +30%).
3. **FAITH AT EIGHT MOVES THE HELD HALF TOO (§3d).** The count caps at the threshold and Faith pays on the peak, so an
   ally's held benefit — and the Devout's own, whose count never releases — can now climb to 8 stacks where 3 was the
   ceiling: **16% mitigation and +12% damage at the top (6% and +4.5% before)**. The ruling spoke to frequency. Confirm
   the depth moves with it, or rule the cap apart from the threshold (one constant).
4. **THE FOURTH STACK RUNE'S WORDS (§3d).** Its text said *"Allies hold FOUR stacks of Faith before releasing instead of
   three"*, false at eight. It reads **"Allies hold one more stack of Faith before releasing."** (PROPOSED, no magnitude
   moved) — and its **name** no longer describes it. Both are the designer's.
5. **A CORE RUNE TAKEN FROM A CACHE GOES TO THE BAG (§1a) — THE IMPLEMENTATION CALL, STATED.** It is the one mechanism in
   the game by which a single pick hands over a card beside the thing picked. Slotting it on the pick again is one line.
6. **THE WORDS, ALL PROPOSED (§1, §2, §6):** the counter's *"the runes left for that class are core runes, which are
   found in play and never sold"*; the cache's toast *"… goes into the bag — slot it on the hero's rune panel to use it."*;
   the pouch's *"CORE RUNES — n of 2 slots filled"* and *"No core rune held. Core runes come with the other runes."*;
   the map card's *"core runes: …"*; the hero sheet's *"Core rune: none held."*; the roll call's *"its condition does
   not hold for these heroes, so it pays nothing this fight"* — and the five condition keys' names (§6), each
   `heroes_…`, because the retired word is swept out of every literal in the game's scripts (`test_batch_bx` §4b).
7. **A CONDITION KEY COUNTS THE HEROES STANDING WHEN THE FIGHT OPENS (§6).** *"While a Cleric stands"* is false of a Cleric
   lying on the field (a quit fight brings a fallen hero back down, GH), so every key counts the standing. The roster
   reading — a member counts however hurt — is one line.

---

## §0 — THE BRIEF'S PREMISES, CHECKED; THE ORDER; THE LETTER HM

| # | premise | verdict | what the record says |
|---|---|---|---|
| 1 | *"On `class-merge`. Run after HK"* | **HELD** | HEAD `c2d8e5a` (HK) = `origin/class-merge` = `git ls-remote origin class-merge` before anything moved; the tree clean but the untracked `save-backups/` |
| 2 | *"The designer played the merged game for the first time since GK"* | **NOT CHECKABLE, AND WHAT IS ON DISK IS ONE RUN** | the save (v13, zone 1, one fight won) holds a Swordmaster, a **Cryomancer**, a Cleric on the Rune of the Oathkeeper and a Sharpshooter, with nothing earned; the profile's four integer `runs_started` keys (written in the last process that saved it) are that party. The Fireball draft and the Peddler purchase were in an earlier session; the live `user://logs` hold HK's acceptance battery only |
| 3 | *"None was visible to 126 battery targets"* | **HELD** | HK's recon ran 126 targets, its pre-pass and acceptance 127; no target drove a player's pick, a cache pick of a core rune, the Stances' swap from a fresh kit, or a self-cast through the player's turn |
| 4 | *"HK found `check_gp` moved by two because the drop spends the dice"* | **HELD** | HK §7b, traced and stubbed |
| 5 | *"`Run.grant_rune` returning a rune it does not put down … is the first place to look"* | **ON THE QUEUE, NOT THE CAUSE** | the Peddler never called it; its two callers (the event verb and the sim's rich arm) put what it returns down at `hold_rune` (§1c) |
| 6 | *"GS moved 29 cards from engines back into the pools"* | **HELD** | GS §1's 29 |
| 7 | *"a card that arrives with another is the enabler machinery firing where it should not"* | **FALSE FOR EVERY DRAFT** | zero pairs over 4,077 takes on HK's code and on HJ's, and a live Mage bar under all six Mage engines: Fireball arrives alone. The enabler fires exactly with its engine; the route that hands over two things is a **core rune slotted on arrival** (§1a) |
| 8 | *"Core runes were offered at the Peddler … report whether HK already closed it"* | **HELD, AND HK DID NOT CLOSE IT** | HK's counter rolls through `generate_rune` → `eligible_ids`, which admits every engine rune the hero does not hold: HEAD's own screen showed 14 core runes in 32 offers (`check_hl` §1b's HEAD arm) |
| 9 | *"A rune bought at the Peddler never appeared … With HK's bag this may be a different defect"* | **TWO DIFFERENT THINGS, DRIVEN BOTH** | at the time (HJ): an ordinary rune went onto the hero unworn, which nothing on the map draws, and a core rune was slotted silently; since HK: into the bag, which the counter says and the map counts (§1c) |
| 10 | *"Guard Change may have been trimmed away from the engine that needs it"* | **HELD** | GS §1 set the Stances' enablers to `[]` (*"a stance swap is a card, not the engine"*) and put Guard Change on the Swordmaster's shelf |
| 11 | *"Hunter's Preparation asks for a target"* | **HELD, AND NINE MORE DID** | §1e |
| 12 | *"GK built it as all prevented damage"* (the Bastion) | **GO, NOT GK** | the Bastion is one of GO's nine rule engines; GK built the engine slots |
| 13 | *"The Swordmaster's stances go to +30% / −15%, from the current values"* | **AMBIGUOUS; READ AS THE HEADLINE PAIR** | they were Aggressive +15% dealt / +10% taken, Defensive 15% less taken / −10% dealt (§3b; NEEDS A RULING 2) |
| 14 | *"Mercy is uncapped, and 5% a stack without one is immunity"* | **FALSE** | the bar caps at five — `second_max = 5 + mercy_cap_bonus`, and nothing writes the bonus — so the cut tops out at **25%** (§3c) |
| 15 | *"Two faith per absorb releasing at three is a heal every other absorbed hit; at eight it is roughly every fourth"* | **HELD, DRIVEN** | 2, 4 → release on the second absorb at three; 2, 4, 6 → release on the fourth at eight (`check_hl` §3d) |
| 16 | *"Record it in `CLAUDE.md` beside the Core Rune charter"* | **DONE** | the charter's heading still says *ENGINE RUNE CHARTER* (identifiers keep *engine*); the new block sits directly under it |
| 17 | *"Nothing in the game reads what was cast last turn — the nearest are `last_attack_target` and Overtone's cast count"* | **HELD** | both exist (`BattleUnit.last_attack_target`, `overtone_casts`), and no field records the previous cast |
| 18 | *"HK's census lists eight doors and none of them is built"* | **HELD AT THE BRIEF; HALF OF ONE BUILT BY §6** | recorded in `CLAUDE.md` beside the rule, not inside the designer's quote |
| 19 | *"HK moved the save to v14 … an older build reading it … writes them away"* | **HELD** | HK §2c; the v13 note is in `save_run`'s own comment block |
| 20 | *"Build it on `Profile`'s shape, which FQ authored for exactly this"* | **HELD, BUILT** | §5 |
| 21 | *"the `b722cc4` tag"* | **A COMMIT, NOT A TAG** | `b722cc4` is `main`'s head (*"Batch GI (main, documentation only)"*); the repository has no tags |
| 22 | *"Confirm the `< 10` floor does not move"* | **HELD** | `if save_version < 10:` untouched — three gates pin it as that literal |
| 23 | *"`Talents.condition_met` reads ONE hero"* | **HELD** | `has_node` and `owns_ability`, off the ctx's one member |
| 24 | *"HK's `check_hk` §1f already seats two Warriors"* | **HELD** | and §6 seats two Warriors through the fixture's battle door |
| 25 | *"GK built the engine slots and GO filled them four batches later"* | **HELD** | HK's correction of the earlier brief |
| 26 | *"It reads 388.52 KiB against 410. HK spent 8,085 B"* | **HELD** | 397,845 B at HEAD |
| 27 | *"GY's estimate of 24 to 31 batches is wrong by an order of magnitude"* | **WRONG BY A THIRD, AND THE ORDER OF MAGNITUDE IS WHAT IS LEFT** | §7 |
| 28 | *"Record one line in `CLAUDE.md` beside CC's and CF's"* | **THEY ARE NOT IN `CLAUDE.md`** | CD §3 and CG §0, in the changelog archive (§0 above) |
| 29 | *"HK found two files had moved since HJ's backup"* | **HELD; NONE MOVED SINCE HK's** | all four live files byte-identical to HK's backup at 10:25 today |
| 30 | *"HL alone was priced at about 71 minutes and HM at about 72 at 127 targets"* | **MEASURED** | §10 |


**THE ORDER WAS KEPT.** §1's five were diagnosed, fixed and driven (`check_hl` §1, 102 checks, and every defect shown
red on HEAD's game code) before §2–§5 were written; §6 last. **§6 WAS NOT DROPPED**: §1 did not grow — Fireball dragging
Razor Ice is not the enabler machinery misfiring (§1a found **zero** pairs over every card, every class and every set of
engines, on HK's code and on HJ's), so FZ's stop clause did not apply.

**THE LETTER HM IS SPENT.** A batch document **HM** (the party condition and the run-save ceiling) was folded in here
rather than run. **CC's and CF's records are not in `CLAUDE.md`** — they are a § of the next batch's changelog entry (CD
§3, CG §0, in `DoD-archive/changelog-archive.html`), and `CLAUDE.md`'s own rule keeps history out of it. So HM is recorded
**both ways**: a § in HL's changelog entry, as CC and CF were, and one **rule-shaped** line in `CLAUDE.md`'s report block
(*a letter whose brief was authored and never run is spent, and the next batch says so in its changelog entry*), naming
all four, so the gap between HL and HN is not read as a lost batch.

---

## §1 — THE FIVE DEFECTS

### §1a — "DRAFTING FIREBALL ALSO GRANTED RAZOR ICE"

**THE CAUSE, REPORTED BEFORE THE FIX: NO DRAFT HANDS OVER TWO CARDS.** A probe took every card a hero of each class can
earn — his class's draft pool and his lineage's zone-boss pool — one at a time, under every set of engines he can slot
(none, each of six, every pair: 22 sets a class), and read his kit through all three doors that read it (the opening kit,
what the next fight seats, and `Runes.kit_names`): **4,077 takes, zero extra cards, on HK's code and on HJ's (`a3a90fd`,
the build the designer played).** Live, a Mage's battle bar under each of the six Mage engines and none, with and
without Fireball, gains **exactly Fireball**; Razor Ice is on the bar with the Rune of the Cryomancer, with Fireball or
without it. **It is not the enabler machinery misfiring across GS's 29, and not a pair: there is no family and no pair.**

**WHAT CAN PUT A SECOND CARD IN A KIT FROM ONE CHOICE IS A CORE RUNE.** Each brings the ability its rule cannot run
without — the Rune of the Cryomancer brings Razor Ice — and **three doors slotted one the moment it arrived**: on HJ's
build the Peddler's purchase (`hold_rune` slotted an engine rune while a slot was free — driven on HJ's own Peddler: the
Rune of the Cryomancer bought for an Overburn Mage landed `engines(equipped=true)`, and nothing on the map named it), and
on both builds the elite's cache and the bargain (`map_screen._pick_rune` → `hold_rune`, GK's *"slotted whatever the
caller asked"*). An elite pays the draft **and** the cache at one victory, so a Mage could draft Fireball and take the
Rune of the Cryomancer on the same screen flow and meet Razor Ice at the next fight. **Which of these the designer met
cannot be read off disk** (premise 2): the last party's Mage held the Rune of the Cryomancer from class selection, so in
that run Razor Ice was his from the first fight — and the map's Kit panel lists it under *ENABLER* without naming whose.

**THE FIX.** `Run.hold_rune` slots an engine rune **only when its caller asks**, the rule ordinary and crest runes
already had; the player's cache and bargain answer **never asks for one** — a core rune taken there goes into the bag,
with a toast that says to slot it on the hero's panel, and its card joins the kit only when he does. The sim's policy
still asks, so the bot slots one while a slot is free exactly as before (its counter unchanged). With §1b the Peddler sells
none, and since HK a purchase goes to the bag anyway. Class selection still slots the one taken; its card already says
*"Also opens with: Razor Ice"*.

**DRIVEN BOTH WAYS (`check_hl` §1a).** The sweep (4,055 takes now — Guard Change left the Warrior's pool, one card under
each of his 22 sets) and its positive arm (the read sees Razor Ice arrive with Permafrost); Fireball drafted **through the
real party draft screen** under Overburn, Permafrost and none, and the fight's bar gaining exactly it; the Rune of the
Cryomancer taken **through the real cache overlay**: in the bag, no card in the kit — then slotted through the hero's
panel, and Razor Ice arrives; and an ordinary rune from a cache still worn at the pick. **On HEAD's code**: *"the core rune
taken from the cache went onto the Mage (engines [overburn, permafrost], bag [])"*, *"put a card in the kit: [Razor
Ice]"*.

### §1b — "CORE RUNES WERE OFFERED AT THE PEDDLER"

**HK DID NOT CLOSE IT.** His counter rolls `generate_rune` → `Runes.generate` → `eligible_ids`, and `eligible_ids` admits
every engine rune of the hero's class he does not hold, because GK's charter mixes the second engine into the ordinary
pool. HEAD's own screen showed **14 core runes in 32 offers**; at the roll, 88 of 200.

**THE FIX: `Run.peddler_rune`**, the counter's own roll: `generate_rune` with every engine rune's name added to
`exclude_names` — the channel the counter already used for a rune on offer to another hero — so nothing else about the
roll moves. Caches, bargains and drops still carry core runes (*"found in play"*). **And when core runes are all that is
left**, the counter's sentence would have said the hero *"already carries every rune written for that class"* — false;
`Run.peddler_withholds_only_core` gives it its own clause (NEEDS A RULING 6).

**DRIVEN (`check_hl` §1b):** 200 counter rolls, 0 core; 200 cache rolls, 88 core (the positive arm); eight Peddler
screens, 32 offers, 0 core; and the only-core sentence on the real screen. HEAD: *"the Peddler's screen showed 14 core
runes in 32 offers"*.

### §1c — "A RUNE BOUGHT AT THE PEDDLER NEVER APPEARED"

**AT THE TIME (HJ, driven on HJ's own Peddler):** an ordinary rune bought (Pyre Debt, 100g) went into the hero's pouch
**unequipped** — `runes(equipped=false)` — and **the map card draws only worn runes**, so it showed nowhere on the map
until the pouch was opened; a core rune bought was **slotted** at once, which the map card shows only as an engine title,
never as the rune bought. Gold spent, nothing visible: both are *"never appeared"*.

**SINCE HK:** a purchase goes into the bag, every offer row says *"— into the bag; equip it on the map"*, the map's bag
row counts it, and the hero's rune panel lists it with Equip. **No code change was owed for it here**; §1b removes the
core-rune half. **`Run.grant_rune` is not on this path** (premise 5).

**DRIVEN (`check_hl` §1c):** bought through the real Buy button; in the bag; *"Rune bag  1/20"* on the map; Equip on the
hero's panel puts it on him.

### §1d — "SEASONED FIGHTER GAVE NO WAY TO CHANGE STANCE"

**WHAT CHANGES A STANCE TODAY (HEAD):** Guard Change (the unconditional swap); Precision Strike, Feint and Wheeling Cut
(readers that switch after they resolve); and Battle Poise's free pivot, which needs Guard Change carried. **Every one of
them drafted since GS §1**, which set the Stances' enablers to `[]` on the test *"does the engine pay without the card"* —
Aggressive pays from the first blow. So a Swordmaster opened with **no way to change stance** until a swap was drafted, and
HD §1's ruled row kept Guard Change off every other Warrior's offer.

**THE FIX: GUARD CHANGE TRAVELS WITH THE STANCES** (`PROTECTED_CORES["swordmaster"]`, `slots` 1, PROPOSED — NEEDS A RULING
1); it leaves the Swordmaster's shelf (an enabler is in no pool: the Warrior pool is 42) and its `ENGINE_READ` row is
**deleted, not zeroed** — there is no offer left to gate, and HD's ruling holds by construction. The class-selection card
reads *"Also opens with: Guard Change"*. **An old save whose Swordmaster drafted Guard Change** carries it twice — the kit's
copy and his earned one — and pays a slot for the earned copy until he benches it; no such save exists on disk. **And
one consequence, found while re-pointing the gates**: Battle Poise and Counter Time need Defensive, and a Warrior without the Stances
reached it through a drafted Guard Change — which no pool holds now. They still need no seat row, because Precision
Strike, Feint and Wheeling Cut switch the guard and every Warrior can draft them; `CLAUDE.md`'s example and `check_gt`
§3's route name Precision Strike now.

**DRIVEN (`check_hl` §1d):** the Stances' enablers are Guard Change and it is in no pool; a Warrior with the Stances
unslotted does not hold it; **in a live fight** the Swordmaster's turn casts it through the player's own turn, with no
target asked, and the stance reads *aggressive* before and *defensive* after. HEAD: *"opens without Guard Change"*.

### §1e — "HUNTER'S PREPARATION ASKS FOR A TARGET"

**WHAT IT TARGETS AND WHY:** an enemy, and it never reads it. Preparation carries no `target`, so it defaults to ENEMY;
its `special` was missing from `_player_turn`'s no-target list, so the ordinary picker opened; and its handler writes only
the caster (`prep_pending`, 15 Mana). **The sweep**: of `_resolve_special`'s 168 arms, 97 read no `target`; 15 of those
were missing from the list; 5 are area or damaging (auto-targeted); **ten asked for an enemy they never use** —
Preparation, Salve and Thick Hide (Survivalist), Dug In (Sharpshooter), Bloodbond, Savage Sweep, Ghostpack, Bear the Brunt
and Bring It Down (Beastmaster), and Sanctuary (the Holy's boss pool). **All ten are on the list.**

**DRIVEN (`check_hl` §1e):** the population **derived** off `battle.gd` every battery (comments stripped, strings masked,
90 cards of the shape, none off the list, Reprisal as the positive arm that a target-reading card is not required); and in
three live fights, each of the ten cast **through the player's own turn** — its bar pressed where it has one, a companion
standing for the companion cards — with no picker opened and its own log line written. HEAD: *"a card that reads no target
still asks for one: [Sanctuary, Bloodbond, Savage Sweep, Ghostpack, Bear the Brunt, Bring It Down, Dug In, Preparation,
Thick Hide, Salve]"* and each *"asked for a target"*.


---

## §2 — ENGINE RUNES BECOME CORE RUNES

**THE NAME.** All 24 engine runes carry **`(core)`** after their name in `data/runes.json` (*Rune of the Warden (core)*);
nothing else in any entry moved. **A save holding a rune under its old name loads with today's**: `Run._refresh_rune_names`
runs on every load and gives every rune whose id is an authored entry that entry's name — worn, slotted, in the bag, in the
crest, waiting on the panel, and in a queued cache — because every roll excludes by NAME, and an old-named rune in the bag
would not have kept its renamed entry from being rolled again. A rune the data does not hold keeps its own.

**THE PREFIX.** *"Engine: "* stood in front of the rule on two surfaces and is gone from both: the class-selection card now
reads **"Momentum: a turn that deals damage and is met by the fight — …"** (the rule text is the engine's, unchanged, GS's
ruling), and the hero sheet's engine line reads the rule alone. Every other surface already showed the rule with nothing in
front of it.

**THE WORDING AFTER (every player-facing string that said *engine rune*; PROPOSED, NEEDS A RULING 6):**

| surface | before | after |
|---|---|---|
| class selection, subtitle | Take one of three engine runes — a second can join it later… | Take one of three **core runes** — … |
| class selection, card | Engine: Momentum: a turn that… | Momentum: a turn that… |
| class selection, kit heading | With no engine, the Warrior opens every fight with these… | With no **core rune**, the Warrior opens… |
| class selection, note | Figures are for the Warrior with no engine: … | …with no **core rune**: … |
| rune pouch, header | ENGINES — 1 of 2 slots filled | **CORE RUNES** — 1 of 2 slots filled |
| rune pouch, empty | No engine rune held. Engine runes come with the other runes. | No **core rune** held. **Core runes** come with the other runes. |
| rune pouch, swap tooltip | Both engine slots are filled. Swap this engine rune… | Both **core slots**… this **core rune**… |
| map card, engine line | engines: Swordmaster — click the card for the sheet | **core runes**: Swordmaster — … |
| hero sheet, rule line | Engine: Seasoned Fighter: fights in one of two stances… | Seasoned Fighter: fights in one of two stances… |
| hero sheet, none | Engine: none held. | **Core rune**: none held. |
| hero sheet, rune header | RUNES (0/3 equipped, 1/2 engines — swap them on the map) | …1/2 **core** — … |
| a refusal | Both engine slots are filled. | Both **core slots** are filled. |
| three fallbacks | engine rune it needs · the engine rune they read · engine rune that dismisses it | **core rune** … (each) |
| glossary | ENGINE RUNES are the other kind… engine slots… | **CORE RUNES** are the other kind, and each wears (core) after its name… **core slots**… |

**THE 44-CHARACTER BREAK MOVED.** *"Rune of the Sharpshooter (core) is not equipped."* is 48 characters, over the ceiling
the sits-out tooltip is hand-broken to, so the name takes a line of its own in both notes (the card's and the rune's) —
GT's shared clause *"Sits out of every fight while the"* unchanged. **And the battle log's roll call quoted a note's first
two lines**, which were its first sentence until then: it quotes the **first sentence** now (`Run.note_first_sentence`), so
the log still reads *"… Rune of the Beastmaster (core) is not equipped."* (and a dismisser's note now ends its sentence
where it used to stop at *"is equipped,"*).

**AND THE COMBAT LOG, FOUND WHILE RE-POINTING THE GATES.** Thirteen log lines name a rule engine's rune by a literal copy
of its old name — *"Rune of the Weaver: the Fireball repeats for 12"*, twelve in `battle.gd` and one in `unit.gd` — and
the roll call two lines above them names the same rune off the data, with *(core)*. They wear *(core)* now, and
`check_go` §11's nine live needles with them. A literal is still a second copy of a name; reading it off the data at each
line is the durable form, left because thirteen format strings were the larger risk this late (§9).

**THE CODE KEPT ITS NAMES**, as ruled: `ENGINE_READ`, `has_engine`, `engines`, `engine_rows`, `Runes.is_engine_rune` and
the rest. Three **ability descriptions** use *engine* as a word for the rule (a Cleric card's *"the engine is not ready"*,
Downwind's and Shrapnel Charge's) — card text, not the rune's name; left as authored and listed in §9.

**DRIVEN (`check_hl` §2):** 24 of 24 named (core) and no ordinary rune so named; every core rune's shown text is its engine's
rule with no prefix; the class-selection screen (three cards named (core), no *"Engine:"*, *"Take one of three core runes"*)
and the hero sheet through their own scenes; **no string literal in `scripts/` says *engine rune*, *engine slot*, *Engine:*
or *ENGINES*** (20,770 literals read, 15 say *core rune*); every hand-broken note line under 44 over every live rune and
every sits-out card under three engine sets (1,740 lines), and every gated rune's first sentence naming its core rune and
ending *"is not equipped."* (42); and a save holding the old name loading with today's.


---

## §3 — THE FOUR MAGNITUDES

### §3a — THE BASTION BANKS ONLY WHAT IS BLOCKED, PARRIED OR ABSORBED

**WHAT IT WAS (GO, not GK — premise 12):** every cut between the blow and the body — the block, the parry, a barrier's
absorb, **armor and resistance**, and every other delta booked through `_prev` while the strike loop named its victim (a
stance, Faith, a status). **NOW:** the block roll (the nominal blow), the parry cut and a barrier's absorb, at their own
sites; `_prev` banks nothing and the armor line banks nothing. The rule text says so, re-broken under 44:
*"Bastion: damage the Warrior blocks, parries, or absorbs with a barrier is banked, with no limit. Armor and other
mitigation bank nothing, and a miss banks nothing. …"*. **Driven (`check_hl` §3a)**, one seeded 400-Attack blow each: armor
alone banked **0** (HEAD banks its cut); a block banked **136**; a parry **104.8**; a barrier's absorb banked.

### §3b — THE STANCES

**WHAT THEY WERE:** AGGRESSIVE **+15% damage dealt, +10% damage taken**; DEFENSIVE **15% less damage taken, −10% damage
dealt**. **NOW (the headline reading, NEEDS A RULING 2):** Aggressive **+30%** dealt; the rest unchanged. One constant,
`BattleUnit.SEASONED_AGG_DEALT` (0.30), read by the strike loop, the chip and — through its own literal, asserted equal —
Formless, whose card says *"both stances' upsides"* and reads **+30%** now. The Naked Blade doubles the upside it always
doubled (0.30 → 0.60), and the Whetstone grows it as before. **Driven:** the Swordmaster's seeded blow against the same blow
with the engine out, **×1.300**; Defensive still takes ×0.85.

### §3c — MERCY: 5% LESS DAMAGE TAKEN A STACK, AND THE CAP

**THE CAP IS FIVE, NOT NONE (premise 14).** Mercy's bar is `second_max = 5 + mercy_cap_bonus` and nothing writes the bonus
(no rune, no node), so **the cut tops out at 25%** — no immunity. It is read among the strike loop's defender terms, beside
the stance's, off the bar the engine installs: no engine, no term. **A rune or node that ever raises Mercy's cap raises the
cut with it**, and the floor in the line (`maxf(…, 0.0)`) is for that day. **Driven:** the Holy's seeded blow at 0, 3 and 5
stacks: 118, 100 and 88 taken (**×0.847, ×0.746**); with the engine out, five stacks cut nothing.

### §3d — FAITH RELEASES AT EIGHT

`battle.FAITH_RELEASE` 3 → **8**; the Faith chip reads the constant, and the four places that spoke the number follow
(the Devout's rule text, the `faith` status text, the glossary, `master.html`). **Driven:** an ally at two a hit reads
2, 4, 6, 0 — the fourth absorb releases, where the second did at three — and the Devout's own count holds at 8.

**WHAT MOVES WITH IT, REPORTED RATHER THAN SILENT (CZ §2's rule; NEEDS A RULING 3).** The count caps at the threshold and
Faith pays on the PEAK, so:

| | at three | at eight |
|---|---|---|
| absorbed hits to a release (2 a hit) | 2 | 4 |
| the deepest an ally can HOLD | 2 | 7 |
| the peak an ally can reach (at the release) | 3 | 8 |
| mitigation paid at the top | 6% | **16%** |
| damage paid at the top | +4.5% | **+12%** |
| the Devout's own count, which never releases | 3 | **8** |

**And a dormant consequence**: Communion's chance is 15% × stacks (`communion_ranks`, which nothing writes since FX), so the
top of its band at eight is 105% — the certainty BF repriced it away from at three. It pays nothing today. **Elevation's 2
and Blessing of the Faithful's 3** are card figures and did not move; each is a smaller share of the bar now. **The Fourth
Stack rune** reads *"one more stack"* (NEEDS A RULING 4).


---

## §4 — THE RULE THE PLAYTHROUGH EARNED

Recorded in `CLAUDE.md` **directly under the charter** as **STANDING RULE — A CORE RUNE IS A DIRECTIONAL FOR ABILITY
DRAFTING (Batch HL §4, the designer's)**: the rule and its test quoted as written, the crest half quoted as written, and
two bullets beside the quotes — **Ambusher's sharpest direction (cards that follow each other with no turn between) is
unbuilt** and needs new machinery and a recon (premise 17 checked: `last_attack_target` and `overtone_casts` exist, nothing
records the last cast); and **of HK's eight crest doors, half of one is built by §6**. The census sentence *"none of them
is built"* is kept out of the quote because §6 made it false in the same batch, and `CLAUDE.md` states what the game is.


---

## §5 — THE RUN SAVE GETS A CEILING

**BUILT ON `Profile`'s SHAPE.** `Run.SAVE_VERSION` (14) is the ceiling and the one constant `save_run` writes (it wrote the
literal 14). A save above it is **refused and kept**:
- `load_run` refuses it and records the refusal (`save_refused`, `save_refused_version`) — it does not load it;
- **`save_run` is a no-op** while a newer save is on disk — checked BEFORE the file is opened, since opening for writing
  truncates it;
- **`clear_save` is a no-op** too — a wipe, a forfeit, the end of a run, and **a New Game**, since `new_run` clears through
  it, would otherwise delete the file;
- the **main menu** says so, beside `Profile`'s banner, in its words (*"… NOTHING HAS BEEN CHANGED OR DELETED. The file is
  left exactly as it was, and this session will not write to it — a run started here is not saved. The file is: …"*), and
  **Continue is dark**. New Game stays live: a run started there is simply not saved while the newer save is kept.

The ceiling reads the file's version off the disk at every write rather than caching an answer that could be stale.

**IT DOES NOT FIX THE CURRENT HAZARD.** An HJ or HK build has no ceiling to refuse with: **an older build opening a save
this build wrote ignores what it does not know and writes it away on its next save**. The ceiling protects from the NEXT
version bump onward. **Until then, do not open a `class-merge` save in an older build — `main` (`b722cc4`) included.**

**THE FLOOR DID NOT MOVE**: `if save_version < 10:` is untouched (three gates pin it as that literal); a v9 save is still
refused **and cleared**. `MIN_SAVE_VERSION` (10) exists only for the refusal's sentence.

**DRIVEN (`check_hl` §5), a v15-shaped save** — this build's own save stamped version 15, with a key this build does not
know: `load_run` refuses it and names version 15; **the file is byte-identical** after the refusal, after `save_run`, after
`clear_save`, after `new_run`, and after the main menu opened over it (Continue disabled, the banner present). The positive
arms: a v14 save loads, saves over and clears; a v9 save is refused and cleared, and is not mistaken for a newer build's.
The harness file is put back as the gate found it.


---

## §6 — A CONDITION ON WHO IS IN THE PARTY

**BUILT AT THE SPAWN, AND EVALUATED ONCE.** `Talents.condition_met` — the one read site of a payload's `condition` —
answers five keys that read the four heroes, through `ctx.party`, which the battle spawn and the hero sheet hand it for
every worn rune and for the crest (`Talents.party_condition_met`). **Every key counts the heroes STANDING when the fight
opens** (NEEDS A RULING 7):

| key | holds when |
|---|---|
| `heroes_include_class: "<class>"` | at least one hero of that class stands |
| `heroes_lack_class: "<class>"` | none stands |
| `heroes_class_count: {class, min, max}` | the number of that class standing is within the bounds — **two of one class** is `min 2, max 2` |
| `heroes_hold_core: "<engine>"` | a standing hero has that core rune slotted |
| `heroes_all_standing: true` | every hero stands as the fight opens |

A payload whose condition does not hold is **not stamped at all** — `apply_payload`'s existing refusal, so a false
condition costs nothing and pays nothing — and **the battle log's opening roll call says so**, GX's rule for a worn rune
that pays nothing: *"… — its condition does not hold for these heroes, so it pays nothing this fight"*. A key with no
party in the ctx reads **false**, the header's safe direction. **The keys say *heroes***: the retired word is swept out
of every string literal in the game's scripts (`test_batch_bx` §4b), and it caught the first draft's keys and tail.

**ONCE OR CONTINUOUSLY — WHAT EACH COSTS, AND WHICH WAS BUILT.**

- **ONCE, AT THE SPAWN — BUILT.** One ctx key at the two places a payload is stamped on a hero (the spawn and the hero
  sheet, which must agree), one function, the roll-call tail: no new door. **It stays true for the whole fight for four
  of the five keys by construction**: who is in the party and which core runes they have slotted cannot change inside a
  fight (nothing in `battle.gd` writes an engine's slot, GM §2). **`heroes_all_standing` is the one that can go stale**:
  it is true of the opening, and a hero who falls at turn three leaves it paid.
- **CONTINUOUSLY — NOT BUILT, AND IT IS A PROJECT.** Every rune payload is a **stamp**: `apply_payload` writes into the
  spawn's `cfg` before the unit exists, and nothing undoes a payload mid-fight. A condition re-read as heroes fall needs
  (a) a door where the party's state changes — a death (`unit._die()`, GO's door), a revive (`BattleUnit.revive()`, two
  callers) and a quit fight's fallen laid down (GH) — and (b) a **reversible** stamp: a record of what each conditional
  payload wrote, taken back when the condition turns false and put back when it turns true. That is well defined only
  for additive stat fields: a maximum moving mid-fight has its own rules (the Devout's growth loan, GH's bank), a
  multiplier or a max-merged field does not subtract, and a card a payload adds cannot leave a fight it opened with
  (GM §2). So the continuous half is a new payload kind restricted to additive stats, a re-evaluation at three doors, and
  a tell that it switched — **a batch of its own**, with the designer's ruling on which keys may be continuous first.

**DRIVEN (`check_hl` §6), WITH FIXTURE RUNES ONLY** — nothing is authored, and the gate asserts `data/runes.json` holds
no crest entry. A fixture crest rune (+9 maximum health on every hero) carrying each condition, spawned into a real
battle through the fixture's battle door, against the same party without it, **both ways**:

| condition | the party that holds it | the party that does not |
|---|---|---|
| a class is present (a Cleric) | Warrior, Mage, Cleric, Hunter — paid on 4 of 4 | Warrior, Mage, two Hunters — paid on 0, told |
| a class is absent (no Mage) | Warrior, **two Clerics**, Hunter — paid on 4 | the four — paid on 0, told |
| two of a class (two Warriors) | **two Warriors**, Cleric, Hunter — paid on 4 | one Warrior — paid on 0, told |
| a core rune held by anyone (Pack Bond) | the Hunter on Pack Bond — paid on 4 | the Hunter on Lethal Aim — paid on 0, told |
| all four stand as the fight opens | all standing — paid on 4 | the Mage fallen — paid on 0, told |
| a class present who has fallen is not present | the Mage standing — paid on 4 | the Mage fallen — paid on 0, told |

**And a hero rune's condition, the same way**: a fixture rune the Mage wears (+7 maximum health), with *a Cleric is
present* — paid on the Mage alone and on no other hero when it holds; on nobody, and told, when it does not. Beside them:
a key with no party reads false, an empty condition reads true, both screens hand the party, and both fixtures leave the
loaded table as the gate found it.

**THE LIST — WHAT A CREST RUNE CAN BE AUTHORED AGAINST NOW, WITH NO NEW CODE:**
1. a stat on every hero (HK);
2. a card for every hero, on the battle's copy (HK's census, *in principle* — it has never been driven with a card);
3. the two best-holder stamps, Devoutness and Last Hope (HK's census);
4. **any of the above, conditioned on who the heroes are as the fight opens** — a class present, absent or counted, a
   core rune one of them carries, all four standing (HL §6);
5. and a HERO rune may carry the same condition (HL §6): *this rune pays while a Cleric is beside him*.

**THE LIST — THE DOORS STILL MISSING (HK §4b's eight, re-read after §6):**
1. **ANY RELIC-SHAPED EFFECT** — the purse, the pouch, a victory's heal or gold, gold found, shop prices, elite loot: a
   second reader of a relic hook (EN §4 calls that a bigger decision than a relic).
2. **THE COMPANIONS** — the stamp runs before a companion exists; a crossing at `_do_summon`.
3. **THE CONDITION AS A FIGHT RUNS** — HALF of HK's door 3 is built above; the continuous half is not.
4. **A TRIGGER WHEN ANY HERO ACTS** — the party's moments together: a door at the strike loop or the damage door that
   reads the crest.
5. **A SHARED METER** — a pool the four build together; none exists at any layer.
6. **THE MAP AND THE REWARDS** — nothing reads a rune outside a fight.
7. **THE ENEMY SIDE** — an aura on the warband (`relics.gd` lists enemy-side auras under *NEEDS PLUMBING*).
8. **A CARD EVERY CLASS HOLDS** — there is none, so an `ability` payload cannot be class-neutral.

---

## §7 — `CLAUDE.md` HAS ABOUT TWO BATCHES LEFT

**THE FIGURE: `CLAUDE.md` IS 403,114 B = 393.67 KiB, WITH 16.33 KiB UNDER ITS 410 KiB CEILING** (HK left
397,845 B = 388.52 KiB; HL's +5,269 B are the new rule block beside the charter, the Stances' enabler and the
second-engine bullets under the charter, the Bastion, Faith at eight and the arriving-stance bullets amended, the core-rune
name bullet, the run-save ceiling in VERSIONS, the no-target door, the crest census half-door and the one spent-letter
line — under EZ's +8,293 B, so the ceiling block's record still stands).

**RE-DERIVED AT HK's RATE, AS THE BRIEF ASKS: 2.07 BATCHES.** At the record (EZ's +8,293 B) it is 2.02; at the
mean of the fourteen batches since GX — GY's +6,130, GZ's +13, HA's +594, HB's +7,109, HC's +6,055, HD's +3,652, HE's
+4,383, HF's +6,209, HG's +2,896, HH's +2,071, HI's +3,524, HJ's +2,418, HK's +8,085 and HL's +5,269, 4,172 B a
batch — it is 4.01; at HL's own, 3.17.

**GY's ESTIMATE WAS WRONG BY A THIRD, AND WHAT IS LEFT IS AN ORDER OF MAGNITUDE BELOW IT (premise 27).** GY read 73.37
KiB of headroom off GX's 344,706 B and gave it *about 24 batches* at +3,086 B a batch. The thirteen batches GY–HK grew
the file by 53,139 B — **4,088 B a batch, 1.32× GY's rate** — so the same headroom lasts about **18**, not 24: the rate was
a third low, and nothing else in the arithmetic moved. The order of magnitude the brief names is the remainder: fourteen
batches of the eighteen are spent, and **what is left is about two at HK's rate**, against GY's *24 to 31*.

**WHAT THE FOLD SAVED, IN BYTES — AND WHERE IT SAVED NOTHING.** Folding HM into HL means one batch's fixed costs were paid
once instead of twice. Measured against HK, the last batch that paid them:

| cost a batch pays once | HK's figure | saved by the fold |
|---|---|---|
| `CLAUDE.md` | — | **0 B.** A batch has no fixed cost in `CLAUDE.md`: every byte there is a rule, and HM's rules (the ceiling in VERSIONS, the condition's half-door) were written once whichever letter carried them. **And the fold COST 234 B**: the spent-letter line in the report block, which names HM |
| the changelog entry's header, lead and *checks that moved* paragraph | 69 + 377 + 1,430 B | **≈ 1.9 KB** |
| `docs/state.md`'s per-batch pair (rulings owed; found and not fixed) | 2,424 B at HK | **≈ 2.4 KB** |
| the report's scaffolding (the premise table's frame, the verification section, the rulings heading, what moved) | a large share of HK.md's 56,378 B | **≈ 20 KB**, the biggest single saving, and in a file no gate opens |
| the `master.html` stamp | 102 B | **0 B net** — a stamp is replaced, never added |
| the verification (recon, pre-pass, acceptance) | 71 + 72 + 72 min at 127 targets | **≈ 3.6 hours of battery** |

**So the fold's saving is in time and in the records that grow per batch; in the one file with a ceiling it saved
nothing and cost a line.** The ceiling is spent by rules, and HM's rules had to be written.

**THE NEXT MOVE — THE DESIGNER'S, AND NOT TAKEN HERE (the brief: no split, no ceiling moved).** At about two batches the
file reaches its ceiling before the batch after next. The procedure has two moves left and both are rulings (the ceiling
block): **re-derive the ceiling a third time** — the file's own reading on the day plus ten of EZ's +8,293 B, which at
today's size is 393.67 + 80.99 = 474.65 KiB, stated as **470** and rounded down — or **take a subject seam that batches read often** (rune law is the one that would come
away cleanly, and GY ruled it the worst candidate on GR's own test). **The third option GY weighed and rejected — splitting
the reasoning out — stays rejected.** A batch that finds the file within one record batch of the ceiling should raise the
ruling before it writes, not after.

---

## §8 — WHAT WAS DELIBERATELY NOT DONE

The brief's own list, each held:

- **Volley, Ambusher and Channel's tempo payout are not built** — they ship in their own batch. Ambusher's unbuilt
  direction is recorded beside the new rule (§4), because no field records what was cast last.
- **No rune of any kind is authored** — crest, class or core. §6's two runes are fixtures of `check_hl`, built into the
  loaded table and erased from it, never written to `data/runes.json`; the gate asserts the file holds no crest entry.
- **HK's doors #1, #2 and #4–#8 are not built**, and door #3's continuous half is not (§6).
- **The crest cap stays at one** (`Run.PARTY_RUNE_SLOTS`).
- **Elites, mini-bosses and bosses still drop no rune** (HK's ruling 2, confirmed in the brief).
- **The Crest keeps its name** (HK's ruling 1, confirmed) — and §6's keys and roll-call words obey the rule that
  confirmed it.
- **The Sharpshooter is unchanged**; the multi-press stays on his basic.
- **The per-lineage stat block stays.**

And three of this batch's own:

- **No magnitude moved beyond the four ruled** (§3). Formless's damage term followed the Aggressive guard because it is
  defined as *both stances' upsides* (NEEDS A RULING 2 names it); Elevation's 2 and Blessing of the Faithful's 3 did not
  move, and each is a smaller share of the bar at eight (§3d).
- **`CLAUDE.md` was not split and its ceiling was not moved** (§7).
- **The `< 10` refusal did not move**, and `Profile` was not touched (§5).

## §9 — FOUND AND NOT FIXED

- **THREE CARD TEXTS USE *ENGINE* AS A WORD FOR A RULE**, not as the rune's name, and are left as authored (card text is
  the designer's, and §2's ruling was about the rune): a Cleric damage card's *"For the turns when nobody needs mending
  and the engine is not ready"* (`classes.gd:3891`), Downwind's *"His engine, fed by every hero"* (`:5624`) and
  Shrapnel Charge's *"the engine of the hunt"* (`:6944`). A player who reads *core rune* on every screen meets *engine*
  on three cards.
- **TWO COMMENTS IN ORDINATION'S HANDLER SAY FIVE** (`battle.gd:23240`, `:23245` — *"`faith_stacks` caps at five"*, *"his
  own Faith holds at five"*): the cap is the threshold, three from CZ to HL and eight now. Stale since CZ, not moved
  here; comments are asserted surfaces, and a sweep that edits them owes a literal sweep.
- **AN OLD SAVE WHOSE SWORDMASTER DRAFTED GUARD CHANGE HOLDS IT TWICE** — the kit's copy (the enabler) and his earned one
  — and pays a slot for the earned copy until he benches it. No such save is on disk (the designer's Swordmaster has
  earned nothing).
- **`heroes_all_standing` GOES STALE INSIDE A FIGHT, BY DESIGN** (§6): true of the opening, paid to the end.
- **COMMUNION AT EIGHT IS A CERTAINTY AT THE TOP OF ITS BAND** (15% a stack at seven), on a node nothing writes since FX.
  `test_batch_be` §6 asserts the dormancy and prints the top, so the day a writer arrives it reds with the reason.
- **THIRTEEN COMBAT-LOG LINES HOLD A LITERAL COPY OF A CORE RUNE'S NAME** (`battle.gd`'s rule-engine lines and `unit.gd`'s
  Leech line): they wear *(core)* since §2, and they will go stale again the day a name moves. Reading the name off the
  data at each line is the durable form.
- **THE ENGINE RUNES' UNREAD `desc` PLACEHOLDERS STILL SAY *ENGINE*** (*"A Warrior engine."*): GS §3 ruled them unread,
  and `check_gs` sweeps for a surface that shows one. §2 moved names, not data a player never sees.
- **THIRTY-SIX ISOLATED COPIES LEFT USER-DATA FOLDERS** under Godot's `app_userdata`, every one named *"Dawn of Decay HL …"*:
  the working and probe copies (**"work"**, **"probe"**, **"probehj"** — HJ's build, checked out in its own copy — and **"ctlhead"**, HEAD's game with the new gate), the reconnaissance battery (**"recon"**), the twenty-five controls (**"ctl K1"** to **"ctl K25"**), the ok() traces (**"trace_head"**, **"trace_hl"**, **"tH0"**, **"tH1"**, **"tN"**) and the pre-pass (**"prepass"**). **There are 461 such folders now**, counting every folder there but the live game's own. They hold nothing a player needs and can be deleted. This batch's backup is
  `../save-backups/HL-20260929-102530`.

---

## §10 — VERIFICATION

**THE PLAYER'S SAVES, FIRST.** Backed up to `../save-backups/HL-20260929-102530` before anything ran, and verified by
hash: all four live files byte-identical to the backup — and to HK's backup, so nothing moved since HK (premise 29):
`profile.json` `2892470f…`, `relics.json` `fdc12ffa…`, `run_save.bin` `fa85daa9…`, `settings.cfg` `0c1b39c3…`. Every
isolated copy renamed `config/name` before it ran, so its `user://` was its own.

**THE RECON — HEAD's UNMODIFIED GATES AGAINST HL's GAME CODE, BEFORE ANY GATE WAS EDITED.** A copy holding HEAD's suites,
gates and fixtures with HL's `scripts/` and `data/` (check_hl removed), **127 targets** targets in **72 min 16 s** (11:40:17 to 12:52:33, beside the other work of this batch). The
prediction was written before the launch (`PREDICTION_RECON.md` in the batch's scratchpad) and is read against it here:

| | targets | what they read |
|---|---|---|
| **PREDICTED RED, AND RED** | `check_fd`, `check_gq`, `check_gx`, `check_go`, `check_gs`, `check_gt`, `check_gu`, `check_he`, `check_hf`, `check_hk`, `check_hc`, `test_batch_cd`, `test_batch_be`–`bi`, `test_batch_bo`, `bp`, `bw` | each for the cause written against it — the Peddler's pin, *Engine:*, the roll call's first sentence, the Bastion, Guard Change travelling, the Faith mirror (`check_gt`'s reds were §3's drive, not §2 as predicted) |
| **PREDICTED GREEN, AND RED — THE PREDICTION'S MISSES** | `check_da`, `test_batch_ce`, `test_batch_bk`, `test_batch_bm` | `check_da` pins `FAITH_RELEASE == 3` outright (the prediction read only its relation arm); `ce` mirrors the threshold as `be`–`bi` do; `bk` and `bm` parse the literal after `"version": `, which is `SAVE_VERSION` now — the prediction checked only the `< 10` floor they also read |
| **NOT PREDICTED, AND RED** | `test_batch_aw`, `ay`, `bc`, `bu`, `bl`, `ak`, `bx`; `check_dv`, `check_eh`, `check_hd`, `check_gv` | a literal gain of 5 driving a release (`aw`, `ay`, `bc`); the threshold mirror (`bu`); the version literal (`bl`); Guard Change as a drafted, ruled card (`ak`, `dv`, `eh`, `hd`); **`bx` caught a real defect in the first draft** — the condition keys and the roll-call tail said the retired word *party*, fixed in the game; `gv`'s Fourth Stack drive, two *(core)* needles and the Warrior's no-engine floor (Open Line needs Guard Change) |
| **RED ONLY BECAUSE THE RECON'S COPY PREDATES THE DOCUMENT EDITS** | `test_batch_bq`, `br`, `bt`, `bv`, `cb`, `cp`; `check_do` | `master.html`'s draft counts and `suite_fixture`'s floor, both written after the copy was taken; green on the final tree |
| **PREDICTED RED, AND GREEN** | `check_fk`, `check_gm`, the Holy's and the Swordmaster's damage suites | nothing pins the Fourth Stack's old words or the stance's 15%; `check_gm` read green — and **fell two checks**, which the differ caught (below) |
| **THE TWO SANCTIONED REDS** | `check_cm_live` 13 / 4, `check_gj` 70 / 1 | unchanged in count; `check_gj`'s figures moved (the card +151 against a purse of +171 — the gap still the Tollkeeper's Bell's 20 gold) |

**HK's SHAPE — A MEMBER BUILT OUTSIDE THE PARTY, MEASURED BESIDE IT — WAS WATCHED FOR IN EVERY RED, AND MET ONCE**:
`check_hk` §3d held back the last rune a Warrior is eligible for and asked the Peddler to offer it, and on HL's code that
rune was a core rune, which the Peddler no longer sells. It is the new exclusion meeting a population computed without
it, not a stand-in beside a stocked party; the arm now computes the Peddler's own population, and K2 shows it bites.

**THE CHECKS THAT MOVED, AND WHY** — every red read by its FAIL text, re-pointed to its intent with the reason at the
site, and re-run green in an isolated copy:

| target | red on HL's code (the recon) | re-pointed to | count |
|---|---|---|---|
| `test_batch_be`, `bf`, `bg`, `bh`, `bi`, `bu`, `ce` | the mirrored `RELEASE := 3`; rates and drives keyed on it | `RELEASE := 8` (one line each); Communion measured at two where the top of the band is now a certainty on a dormant node (`be` §6 asserts the dormancy and prints the top); Ordination's and Elevation's arms read either outcome off the threshold | unchanged, but `ce` 903 → 930 — the game: its enabler arms meet Guard Change in 28 pools, and one pool card fewer |
| `test_batch_aw`, `ay`, `bc` | a literal gain of 5 drove a release (the threshold before CZ) | the gain is the live threshold, read off `battle.gd` — these only DRIVE a release | unchanged |
| `check_da` | §1 pinned `FAITH_RELEASE == 3`; the live arm drove two absorbs | the pin reads 8 (ruled); the release takes `ceil(threshold / per-absorb)` absorbs | unchanged |
| `test_batch_bk`, `bl`, `bm` | parsed the literal after `"version": `, which is `SAVE_VERSION` now | read the constant's declaration, and assert the save writes it | unchanged |
| `suite_fixture.gd` (the twelve draft suites' shared floor) | the Warrior's pool 42 against a floor of 43 | the floor 42, with its reason (the bare half did not move) | unchanged |
| `test_batch_cd` | the Swordmaster's shelf 13 and the draft 178 against 14 and 179 | `PER_SPEC_DEPTH` 13, `SPEC_TARGET` 158, `DRAFT_TARGET` 178; `classes.gd`'s header | unchanged |
| `test_batch_ak`, `bo`, `bp` | Guard Change drafted, and the Stances' enablers `[]` | Guard Change is the Stances' enabler, in no pool; Lunge the one stance piece a row gates | `ak` unchanged; `bo` 1142 → 1140 and `bp` 430 → 431 — the game: a drafted card's five arms go and an enabler's three come (`bo`), one more enabler checked against the pools (`bp`) |
| `test_batch_bx` | §4b: the first draft's `party_…` keys and the roll-call tail said the retired word | **not re-pointed — the GAME was fixed**: the keys are `heroes_…` and the tail says *these heroes* | unchanged |
| `check_do`, `test_batch_bu`/`bv`/`bw`/`cb`/`br`/`bq`/`bt`/`cp` | `master.html`'s draft counts and the pool floor (the recon's copy predates both edits) | nothing to re-point: green on the final tree | unchanged |
| `check_dv` | §5: ten cards outside every pool and kit, not nine | 10 — Guard Change is an enabler again | unchanged |
| `check_eh` | §3: seven named enablers across seven lineages, not six | 7 across 7 | unchanged |
| `check_fd` | §1a: the Peddler's pinned call | `Run.peddler_rune(member, on_counter)` | unchanged |
| `check_go` | §0 the nine rule-engine rune names; §3 armor, parry and barrier banked every cut | names wear *(core)*; armor cuts and banks nothing, the parry banks what it turned, the barrier what it ate of the blow past the armor | unchanged (401) |
| `check_gq` | §1: 490 — every card "Engine: …" | the card opens with the rule, and no *Engine:* before it | 5018 → 5038 — the game: the Swordmaster's card says *Also opens with: Guard Change*, two more questions in each of ten deals |
| `check_gs` | §0 the minimum table, the enabler bar entries; §1 thirty returning cards | the Stances bring Guard Change (six carrying engines, six bar entries); twenty-nine returning; §2's ruled branch asserted empty (+1) | 824 → 820: −6 the game (Guard Change left the returning cards), +2 the edit |
| `check_gt` | §3: 143 — the drive's `hold_rune` no longer slots a core rune unasked | the drive asks for the slot, as class selection does; the guard route opens Battle Poise with Precision Strike (+1: the route's card is draftable and ungated) | 3479 → 3477: −3 the game (Guard Change left the census), +1 the edit |
| `check_gu` | §1, §2: Guard Change drafted from the Warrior pool, and its below-row | the Stances' enabler in no pool; its below-row deleted (an enabler is a comparator, not an earnable card), its price still asserted | 321 → 316: −2 the game (no longer an earnable card), −3 the deleted row |
| `check_gx` | §3c the roll call's tail, read as the note's first two lines; §5 the fallback said *engine rune* | §3c the roll call quotes the note's first sentence; §5 the fallback says *core rune* | 1320 → 1362 — the game: one more note line on each of 42 gated runes, each checked under 44 |
| `check_hc` | §6: the dismisser's name without *(core)*, the card's *engines:* line, the roll call's two lines | §6 the first sentence; the dismisser's name wears *(core)* | unchanged (74) |
| `check_hd` | §0, §1: Guard Change as a ruled, drafted stance piece | one stance piece gated (Lunge); Guard Change asserted offered by no roll and held by every Stances holder | 31 → 35 — the edit: nine Guard Change offer arms out, thirteen travelling arms in |
| `check_he` | §0 the ruled rows; §3 the dismisser's name; §4 the Swordmaster's rune name; §5 Guard Change as the held card | the ruled rows are Lunge and Venom Coating; §5's held card is Lunge; the dismisser's name wears *(core)* | unchanged (249) |
| `check_hf` | §0 the ruled rows; §5 the dismisser's name | the ruled rows; the dismisser's name | unchanged (306) |
| `check_hk` | §3d kept back a core rune (`engine_redoubt`), which the Peddler no longer sells | §3d: the Peddler's population is the ordinary eligible runes | unchanged (140) |
| `check_gv` | §1 the Fourth Stack drive gained 5, which reaches neither threshold; §2c two names without *(core)*; §3 a Warrior with no engine offered 8 at the ceiling against a floor of 9 | §1 the drive gains one past the live threshold; §2c the names wear *(core)*; §3 `RUNE_FLOOR`'s Warrior ceiling 9 → 8, with its reason — Open Line needs Guard Change, which no Warrior without the Stances can hold now (HD §3's rule: the batch that thins a no-engine half moves its row and says why) | unchanged (1037) |
| `check_gw` | not in the recon (it ran without `check_hl`); on the final tree §2 read **96 hand-set sites against a ceiling of 90** — `check_hl` joined its population with six | the ceiling **96**, the reason at the site: `check_hl` §3 empties a hero's `engines` on the live unit for each magnitude's engine-out control and puts it back; every positive arm's engine is seated by the real spawn, so a broken seat reds the ratio arms — only the counterfactual is hand-set, the one way to ask a read site whether it refuses without its engine on the same body | unchanged (76) |
| `check_gp` | green, 441 against its row's 444 | **no edit** — attributed by an `ok()` trace: all three are Guard Change's deleted row (§2b two, §2e one); §4's run identical | 444 → 441 |

**AND ELEVEN TARGETS COUNT DIFFERENTLY BECAUSE THE GAME CHANGED — THE DIFFER CAUGHT EVERY ONE, AND EACH WAS TRACED CHECK BY CHECK** (an `ok()` print in three copies: HEAD's target on HEAD's tree, HEAD's target on HL's game, this batch's target on HL's game; digits normalised, message multisets diffed):

| target | recorded → read | why, from the trace |
|---|---|---|
| `check_gp` | 444 → 441 | Guard Change's deleted `ENGINE_READ` row: §2b's two offer arms and §2e's ruled arm; §4's whole run reads message for message the same |
| `check_gm` | 150 → 148 | §2's two arms for Guard Change as a ruled row — castable bare, on the bar with the engine |
| `test_batch_ah` | 6189 → 6185 | one card fewer in the Warrior pool, across the four per-card arms that walk the pools |
| `test_batch_cb` | 2062 → 2061 | *appears in exactly one spec draft pool*, asked of one card fewer |
| `test_runes` | 7370 → 7373 | a Swordmaster holds Guard Change from his kit, so Open Line — which requires it — joins his grants, each asked three things |
| `check_eh`, `check_gq`, `check_gx`, `test_batch_bo`, `bp`, `ce` | as in the table above | re-pointed one for one; the counts moved with the game, not with the edit |

**THE CONTROLS — ONE DEFECT EACH, IN ITS OWN COPY OF THE FINAL TREE, READ BY FAIL TEXT** (predicted before any ran):

| ctl | the defect | target | checks / failures | the first FAIL line |
|---|---|---|---|---|
| K1 | `hold_rune` slots a core rune whatever was asked (GK's shape) | `check_hl` | 168 / 3 | §1a: the core rune taken from the cache went onto the Mage (engines ["overburn", "permafrost"], bag []) |
| K2 | the Peddler rolls through `generate_rune` again | `check_hl` | 168 / 4 | §1b: the Peddler's screen showed 14 core runes in 32 offers |
| K2 | the Peddler rolls through `generate_rune` again | `check_fd` | 53 / 1 | §1a: an offer site stopped calling the door it is pinned on — ["scripts/shop_screen.gd: Run.peddler_rune(member, on_counter)"] |
| K2 | the Peddler rolls through `generate_rune` again | `check_hk` | 140 / 1 | §3d: with every rune of his held, the Warrior was still offered one — or the column did not say why |
| K3 | the Stances bring nothing (enablers `[]`) | `check_hl` | 168 / 5 | §1d: a Warrior holding the Stances opens without Guard Change: ["Strike", "Crushing Blow", "Pommel Strike", "Mocking Blow"] |
| K3 | the Stances bring nothing (enablers `[]`) | `check_eh` | 229 / 1 | §3: 6 named enablers across 6 lineages, not the seven across seven HL left the table holding |
| K4 | Preparation off the no-target list | `check_hl` | 168 / 4 | §1e: a card that reads no target still asks for one: ["Preparation"] |
| K5 | the Rune of the Medic named without *(core)* | `check_hl` | 168 / 1 | §2a: 23 of 24 engine runes are named (core) |
| K5 | the Rune of the Medic named without *(core)* | `check_go` | 401 / 1 | §0: field_kit's rune is the Rune of the Medic (core) (Rune of the Medic) |
| K6 | *Engine:* back on the class-selection card | `check_hl` | 168 / 2 | §2b: the class-selection card still reads "Engine:" (["Engine: Blood Frenzy: +2% damage for every 5% of health missing. Half the highest bonus reached |
| K6 | *Engine:* back on the class-selection card | `check_gq` | 5378 / 660 | §1: warrior ["engine_berserker", "engine_warden", "engine_swordmaster"] — engine_berserker's card opens with its engine rule, with no "Engine:" before |
| K7 | the rune note's name back beside *is not equipped.* | `check_hl` | 168 / 1 | §2d: note lines over 44: ["deepening_hex: \"Rune of the Occultist (core) is not equipped.\" (45)", "deepening_hex: \"Rune of the Occultist (core) is n |
| K8 | `load_run` no longer refreshes rune names | `check_hl` | 168 / 1 | §2e: a saved core rune named 'Rune of the Pyromancer' loaded as 'Rune of the Pyromancer', not today's 'Rune of the Pyromancer (core)' |
| K9 | the Bastion banks armor and resistance again | `check_hl` | 168 / 1 | §3a: armor cut a blow of 99 and the bank read 33.0 — armor still banks |
| K9 | the Bastion banks armor and resistance again | `check_go` | 401 / 6 | §3 (alone): armor cuts the blow and banks nothing — 108 landed of the 145 blow, 37.0 banked |
| K10 | Aggressive back to +15% | `check_hl` | 168 / 3 | §3b: the Aggressive upside reads 0.15 |
| K11 | Mercy's damage-taken term removed | `check_hl` | 168 / 1 | §3c: three stacks took x1.000 and five x1.000 — not 5% a stack |
| K12 | `FAITH_RELEASE` back to 3 | `check_hl` | 168 / 3 | §3d: Faith releases at 3, or an absorb meets it |
| K12 | `FAITH_RELEASE` back to 3 | `check_da` | 41 / 1 | FAITH_RELEASE is 3, want 8 — ruled at HL §3 (CZ's 3 until then) |
| K12 | `FAITH_RELEASE` back to 3 | `test_batch_be` | 27 / 3 | §6: an ally at TWO stacks advances 30% of the time (read 0.0%) |
| K13 | `save_run` ignores the ceiling | `check_hl` | 168 / 5 | §5a: save_run wrote over the v15 save |
| K14 | `clear_save` ignores the ceiling | `check_hl` | 168 / 4 | §5a: clear_save deleted the v15 save |
| K15 | `load_run` ignores the ceiling | `check_hl` | 168 / 1 | §5a: this build loaded a v15 save, or did not say it refused it |
| K16 | the spawn stops handing the four to the condition | `check_hl` | 168 / 7 | §6 a class is present: the party that satisfies it was paid on 0 of 4 heroes (told true) |
| K17 | `heroes_all_standing` ignored | `check_hl` | 168 / 1 | §6 all four stand as the fight opens: the party that does not was paid on 4 heroes, or the log did not say why |
| K18 | the keys count the fallen | `check_hl` | 168 / 2 | §6 all four stand as the fight opens: the party that does not was paid on 4 heroes, or the log did not say why |
| K19 | the roll call never says a condition fails | `check_hl` | 168 / 6 | §6 a class is present: the party that does not was paid on 0 heroes, or the log did not say why |
| K20 | the counter's only-core sentence removed | `check_hl` | 168 / 1 | §1b: the counter did not say why it has nothing for the Warrior |
| K21 | the cache pick asks for a core rune to be slotted again | `check_hl` | 168 / 3 | §1a: the core rune taken from the cache went onto the Mage (engines ["overburn", "permafrost"], bag []) |
| K22 | Guard Change back on the Swordmaster's shelf | `check_hl` | 168 / 1 | §1d: Guard Change travels and is still in a pool — an enabler sits in none |
| K22 | Guard Change back on the Swordmaster's shelf | `check_dv` | 84 / 1 | §5: 9 abilities sit outside every pool and every class kit, not the 10 on record — re-derive it (Bloodlust, Divine Shield, Flamewave, Hex of Ruin, Raz |
| K22 | Guard Change back on the Swordmaster's shelf | `test_batch_cd` | 92 / 5 | swordmaster drafts 14 (want 13) |
| K22 | Guard Change back on the Swordmaster's shelf | `check_gs` | 820 / 2 | §1: Guard Change (the swordmaster's) has 2 homes among enabler, kit, shelf and the pet's calls — one |
| K22 | Guard Change back on the Swordmaster's shelf | `check_gu` | 318 / 2 | §1: Guard Change is not the Stances' enabler, defined by the Swordmaster and in no pool (HL §1) |
| K23 | the note's fallback says *engine rune* again | `check_gx` | 1362 / 1 | §5: the note's fallback clause is unreachable |
| K24 | the roll call quotes a note's first two lines again | `check_gx` | 1362 / 1 | §3c engine out: the roll call's tail is not the note's first sentence (Occultist: Deepening Hex — Sits out of every fight while the Rune of the Occult |
| K24 | the roll call quotes a note's first two lines again | `check_hc` | 74 / 1 | §6 (Lethal Aim in): the roll call said it 0 times |
| K24 | the roll call quotes a note's first two lines again | `check_hl` | 168 / 0 | **GREEN** |
| K25 | Guard Change's ruled row put back | `check_hd` | 35 / 2 | §0: the rows ruled at HD §1 are ["Guard Change", "Lunge"] — the ruling named two, and HL §1 deleted Guard Change's when it began travelling |
| K25 | Guard Change's ruled row put back | `check_he` | 249 / 1 | §0: the ruled card rows are ["Guard Change", "Lunge", "Venom Coating"] — HD ruled two, HF §7 one (HE §2's was undone), and HL §1 deleted Guard Change' |
| K25 | Guard Change's ruled row put back | `check_hf` | 306 / 1 | §0: the ruled card rows are ["Guard Change", "Lunge", "Venom Coating"] — HD's Lunge (HL §1 deleted Guard Change's) and HF's one |

**Every control bites on every target it was run against but one, and the one is the prediction's error, not the
check's**: K24 (the roll call quoting a note's first two lines) read green on `check_hl`, because §2d asks the note's
first sentence through `Run.note_first_sentence` itself and never through a live roll call — the live witnesses are
`check_gx` §3c and `check_hc` §6, and both went red. **Two bit harder than predicted**: K6 on `check_gq` read 660, the
third re-pointed arm (what a card lists) red on 180 cards as well; and K2 on `check_hk` §3d, predicted as a maybe, read
red. **Every re-pointed pin was run against its defect** — the Peddler's call (K2), the enablers (K3), the rune names (K5),
the prefix (K6), the Bastion (K9), the threshold (K12), Guard Change back on the shelf (K22), the fallback (K23), the
first sentence (K24) and the ruled rows (K25) — so no re-point is a check that stopped asking. The predictions are in the
batch's scratchpad (`PREDICTION_CONTROLS_HL.md`), written before each control ran, misses recorded beneath them.

**THE PRE-PASS** (an isolated copy of the final tree, prediction first): **Isolated copy "Dawn of Decay HL prepass", proved byte-identical to the repository (443 files hashed against the
tree, `project.godot` aside, at launch); prediction written before the launch (`PREDICTION_PREPASS.md`).** **128
targets in 73 min 36 s** (13:17:11 to 14:30:47). **`check_de` 529 checks / 0 failures / 0 notices — the prediction
exactly, 529 included**: every row this batch moved or added read at its value. The two sanctioned reds at their
counts: `check_cm_live` 13 / 4 and `check_gj` 70 / 1 (*+151 against +171*, the Tollkeeper's Bell's 20 gold). The three
harness gates PASS (22 / 382 / 8); `check_parse` 202 with **0 `Parse Error` lines on its stderr**; `check_hl` 168 / 0;
`check_gw` 76 / 0 at 96 sites against its ceiling of 96; `check_gp` 441 / 0 in **225.1 s against its 240 s watchdog**;
`test_batch_bk` 130 (its band [128, 130]); `test_batch_an` 6049 (its band [6047, 6066]).

**THE ACCEPTANCE RUN, IN THE REPOSITORY, THE TREE FROZEN**: **In the repository, the tree frozen: every tracked and untracked (non-ignored) file hashed before and after — 443 files, `save-backups/` aside — and the player's four files hashed before and after; prediction written before the launch (`PREDICTION_ACCEPT.md`).** **128 targets in 73 min 21 s** (14:31:18 to 15:44:39). **`check_de` 529 / 0 / 0**, the pre-pass exactly; the same two sanctioned reds at their counts (`check_cm_live` 13 / 4; `check_gj` 70 / 1, *+151 against +171*); the harness 22 / 382 / 8 PASS; `check_parse` 202 with **0 `Parse Error` lines**; `check_gp` 441 in **225.3 s**; `test_batch_an` 6054 and `test_batch_bk` 130, inside their bands. **The tree read byte-identical after the run (443 files), and the player's four files byte-identical to the backup** — `profile.json` `2892470f…`, `relics.json` `fdc12ffa…`, `run_save.bin` `fa85daa9…`, `settings.cfg` `0c1b39c3…`. The tree it read differs from the pre-pass copy by one reworded sentence in HL's own changelog entry, which no gate pins.

**THE PUSH**: **Committed on `class-merge` by name (never `git add -A`: `save-backups/` stays untracked) and pushed to `origin/class-merge`; `git ls-remote origin class-merge` is compared with local HEAD after the push.** A commit cannot carry its own hash, so the confirmation — the two hashes side by side — is in the batch's closing message, as HK's was. After the verification runs, only this report and `docs/state.md`'s verification line were written; `check_es` — the one gate that opens `docs/state.md` — reads only its *2+ threshold* windows, and the line written adds none.

## §11 — WHAT MOVED

**THE GAME (twelve scripts).** `run_state.gd` (`hold_rune`'s ask, `peddler_rune`, `peddler_withholds_only_core`, the
notes re-broken, `note_first_sentence`, `_refresh_rune_names`, the ceiling: `SAVE_VERSION`, `run_save_newer`, the
refusal); `battle.gd` (the no-target list, the Bastion's three sites, the stance constant's reader, Mercy's term, Faith at
eight, the roll call's first sentence and its condition tail, the four handed to a condition, the rule engines' log lines);
`classes.gd` (the Stances' enabler, the shelf, the deleted row, the rule texts); `talents.gd` (the five `heroes_…` keys);
`map_screen.gd`, `shop_screen.gd`, `party_screen.gd`, `spec_choice_screen.gd`, `main_menu.gd`, `runes.gd`, `unit.gd`
(the words, the cache's bag, the counter, the menu's banner, the stance constant); `run_sim.gd` (the bot asks for a core
rune's slot as it always did).

**THE DATA.** `data/runes.json`: the twenty-four core runes' names and the Fourth Stack's words — nothing else in any
entry. `data/glossary.json`: seven entries (the runes, the slots, the lanes, the protected core, the stance, Faith,
Mercy).

**THE INSTRUMENTS.** `check_hl` (new, 168); thirty-four targets re-pointed (§10) — seventeen gates, `check_gw`'s ceiling among them, and seventeen suites — and `suite_fixture.gd`'s floor;
`run_battery.sh`'s GATES ends with `check_hl`; eighteen `baselines.json` rows (seventeen moved, one new), each with its
reason; `pin-manifest.json` rebuilt, 1534 → 1544.

**THE DOCUMENTS.** `CLAUDE.md` (+5,269 B: §7); `docs/master.html` (the stamp, every core rune's name, the stances, Faith,
Mercy, the Bastion, the Peddler, the ceiling, the crest's condition, the draft's counts and the Stances' enabler);
`docs/changelog.html`; `docs/design-notes.md`; `docs/state.md` (rewritten); this report.
