# BATCH HW — FOUR PLAYTEST DEFECTS, THE MERCHANT'S PLACE, AND THE SIX CARD-VERSUS-CODE ITEMS

**On `class-merge`, from `7e8cd10` (HV). IMPLEMENT ONLY.** **§0: HT's rulings 2 and 7 are taken** — the rite ranks a body
carrying a chill by its chill (the presence rule), and the words are accepted as built — and **the process rule is recorded in
`docs/ways-of-working.md`: every ruling lands in the next brief's §0.** **§1: four defects from the playtest, each cause reported
before any fix.** Boil Over pays what its card says, and its words are what is wrong; the Sharpshooter's core dismisses the pet
the moment it is slotted, and one taken after class selection waits unworn (HL §1's rule) — **neither changes code; both are
rulings**. A crest rune is now never in a hero's own pick of three, the drop, the Peddler and the event verb still offering one;
and an enemy's click zone is its own body, so no two meet. **§2: the merchant is an easy fight's reward** — severity 1 pays its
gold or the merchant, severity 4 its gold or a rune. **§3: the six, as ruled** — Mark of the Hunt resets, Charge Dazes 2 turns
(3 on a Perfect), Blood Debt pays on the killing bleedout, Counter Time and Snare Line say one turn, and **Thin Blood's price is
charged at last — at the status door, because `_apply_poison` alone missed the barb itself and Explosive Shot.** **§4** is HX's;
**§5** records the later batches by ruling, and that Mana stays.

**VERDICT: SHIPPED.** The pre-pass — 137 targets in 75 min 17 s, an isolated copy proved equal to the tree at its launch —
read `check_de` 565 / 0 / 0, every target at its predicted reading. **The acceptance run in the repository** — 137 targets, 15:07:09 to
16:22:22, `ps` read by rows every 15 s with no game window in 299 readings — read `check_de` 565 / 0 / 0: every target at its
pre-pass reading but two counts that move with a draw inside their bands. The tree was byte-identical before and after (513
files) and the player's four files were untouched; the final tree's readers of `docs/state.md` and the document instruments read
their rows. No Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any log. Twenty-two controls: every one red on the
line it aimed at, both re-tunes green; HEAD's game under the new gates red at every behaviour HW changed. **No save version
moved. Six rulings are owed — the first two are playtest defects whose cause is not the code.**

## NEEDS A RULING

1. **BOIL OVER'S WORDS (§1a).** The card pays what it says — 30% of Attack plus 2% a point of the live Blood Frenzy bonus — and
   only the Berserker's core carries that bonus, while GP §2 offers the card to every Warrior as one that half-works (21 against
   84 on one blow). Its opening *Spend the rage itself* reads as the Warrior's Rage. **The words** (one shape: *Cash the frenzy:
   strike for 30% of Attack plus 2% more for every POINT of a live Blood Frenzy bonus*), **or the card** (it spends Rage for
   damage — a new magnitude), **or the offer** (the Berserker's core alone).
2. **THE SHARPSHOOTER'S CORE TAKEN AFTER CLASS SELECTION (§1b).** Class selection slots the core it deals; a core taken later waits
   unworn until slotted on the hero's panel (HL §1: one pick is never two things), and the toast says so. Slotted, the pet card
   leaves at once. **Keep it**, or **slot a core rune on the pick while a core slot is free** (the Sharpshooter's takes a card away
   rather than adding one — not the case HL §1 refused), or **name the pet in the toast**.
3. **THE MERCHANT'S READING (§2).** Built as: an easy fight is a severity-1 bargain, the merchant beside its 40 gold, rolled like
   every reward. **Priced and not taken**: the merchant REPLACES the 40 gold (a gated severity-1 option would then have nothing
   left and is owed a fallback); it pays the mild slot at any severity up to the rung's floor; or a plain fight node pays it (a
   rolled merchant behind a fight — the second economy BK deleted).
4. **COUNTER TIME BESIDE POMMEL STRIKE (§3d).** At one turn it is Pommel Strike's stun without the blow; its edge is that it cannot
   miss, be parried or be blocked, and it can lay a second stun in a window. Whether it wants more is the designer's — the
   second turn back is the stun-length system, ruled out of this batch.
5. **THE WORDS, PROPOSED**: Charge's *DAZED for 2 turns* (Perfect: *Dazed for 3 turns*); Counter Time's *loses its next turn*,
   card and log line; Snare Line's card without its chilled clause (its log line is gone with it); the glossary's Runes, Peddler
   and Severity entries; `master.html`'s rows, the partner-spec table now *EIGHT CARDS*.
6. **WHICH DRAFT IS *THE CLASS RUNE DRAFT* (§1c).** Read as a hero's own pick of three — the elite's rune cache and the
   bargain's rune, one hero's *RUNE, choose one* on his card — because the game has no other rune draft a hero answers himself.
   The brief also says *the caches are right*; if that meant the elite's cache should keep offering crest runes, the scope comes
   off the cache and the bargain's rune (one roll, `Run.roll_rune_candidates`) and the defect has no other door to close.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HV — HV's push confirmed here | **Held**: `git ls-remote origin class-merge` read `7e8cd10bc6162dfccb25eb0a512890bd2ddb6cd6`, local HEAD, before anything was edited; the tree clean but the untracked `save-backups/` |
| 2 | *"`BATCH_HX.md` is written and unrun; HW runs first … the roadmap says why it is second rather than seventh"* | **Half**: `~/Downloads/ROADMAP.md` (8 October 11:09) says it, **with the letters the other way round** — its #1 *HX* is this brief's content and its #2 *HW* (the trim and the checks) is this brief's HX. The brief governs: this batch is HW (`docs/state.md`'s *Next letter: HW*), the trim is HX. `BATCH_HX.md` is not in `~/Downloads`, so its §4 is unread here |
| 3 | No save version moves | **Held**: `SAVE_VERSION` 15 before and after; nothing HW changed rides the save in a new shape (§6a) |
| 4 | §0: HT's rulings 2 and 7 were confirmed in chat and HV still lists them as owed | **Held** (HV's NEEDS A RULING, last line; `docs/state.md`'s HT section) |
| 5 | §1: HL §1a — the enabler machinery named as the cause, *zero pairs over 4,077 takes* | **Held** (HL's premise 7 and §1a) |
| 6 | §1a: *"Boil Over does not consume Rage for extra damage"* | **The code pays the card's own text** (§1a, driven); the cause is the text's first clause and the offer to every Warrior |
| 7 | §1b: HT §2b records that Lethal Aim dismisses the pet and every status it lays | **Held** (HT §2b's Hunter row) |
| 8 | §1b: *"the second selection does not honour it"* | **Not in the code**: a later core is held unworn until slotted (HL §1); slotted, the kit loses the pet at once (§1b, driven both ways) |
| 9 | §1c: *"HO §1 ruled … every roll offers a crest rune, so the drop, the Peddler and the caches are right. A class rune draft is not a roll"* | **Half**: HO §1 FOUND every roll offering one — the elite's cache and the bargain's rune among them (its own table) — and `CLAUDE.md` records it. **In the code the class rune draft IS a roll**: the one a hero answers on his own card (`Run.roll_rune_candidates`, the elite's cache and the bargain's rune). So the scope is that roll's, by name. *The caches are right* cannot mean the elite's rune cache without contradicting the same sentence's ruling, so it is read as the routes that are not a hero's own draft — the drop, the Peddler and the event verb (Echo of the Warden, the one event that grants a rune) — which keep offering crest runes; the reading is ruling 6 |
| 10 | §1d: the boxes overlap on mouseover; nameplate selection is not built here | **Held, measured** (§1d) |
| 11 | §2: *"HV §0c gated it out of the run's first three nodes … HV §0c found it already pays its gold or a rune"* | **The section is HS §0c**, not HV's (HV §0 is a table of HU's rulings); held in substance |
| 12 | §3: all six are ruled and `docs/state.md` holds each one word from built (HT ruling 5, HU §5) | **Held** |
| 13 | §3: the six causes | **Five held, each at its line; Thin Blood's half so** — the zero tick is read as the legacy 3 at `_dot_pass`, **and the plain barb and Explosive Shot never reach `_apply_poison` at all**, so the rune's own payout bit in full (§3e) |
| 14 | §5: *"two has been the designed number since GK"* | **Held** (`Run.ENGINE_SLOTS` 2, GK's charter) |
| 15 | §5: *"the block index waits on HW's re-measure"* | **The roadmap's words, its letters**: the re-measure is the trim batch's — HX here (premise 2) |
| 16 | §6: HV's backup is the last; *"the designer has played a whole zone since"* | **Held** (§6a): `profile.json` and `run_save.bin` moved, a zone cleared and three runs started |
| 17 | §6: seventeen gates red at HV and six at HT on the designer's own game | **Held** (HV §6e, HT §5f) |
| 18 | §6: HV read 136 targets in 74 min 45 s | **Held** (HV's pre-pass); not taken as a runtime |
| 19 | §6: clear HV's copies by its prefix | **Held**: eight folders, 3,920 KiB — HV's own count (§7) |

## §0 — TWO RULINGS THAT GOT LOST, TAKEN

| HT's ruling | answered in HW's brief | what HW did |
|---|---|---|
| 2. the rite's rank | **confirmed as built**: a body carrying a chill ranks by its chill | Nothing moved. **The reason is recorded where the rule lives** (`CLAUDE.md`'s conjunction block, the rite's sub-bullet): it is the presence rule again — the rite reads the chill, so it ranks by the chill. The other reading, a composition ranked by its own shorter clock, is recorded as rejected |
| 7. the words | **accepted as proposed** | Nothing moved. **The PROPOSED marker stood in one place**, `docs/state.md`'s HT section, and is struck there; no code comment, gate message or document carried it |

**The process rule** — *every ruling lands in the next brief's §0, whether or not it changes code* — **is written into
`docs/ways-of-working.md`**, under its own heading after *DESIGN IS SETTLED BEFORE A BRIEF EXISTS*. The brief's file list did not
name that file; `CLAUDE.md`'s own routing does (*how a batch COMES TO EXIST* → `docs/ways-of-working.md`), because the rule binds
the conversation that writes a brief rather than the batch that runs one. `check_fr` reads the file every battery (its size, its
second-copy and its history rules), and `check_hw` §5 holds the heading's words.

## §1 — FOUR DEFECTS FROM THE PLAYTEST, THE CAUSE FIRST

### §1a — BOIL OVER: THE CODE PAYS THE CARD; THE WORDS ARE WHAT IS WRONG

**The card**: *Spend the rage itself: strike for 30% of Attack plus 2% more for every POINT of your live Blood Frenzy bonus.
For 2 turns afterwards you receive only the FLOOR, not the live bonus — the floor itself is untouched.*

**What the code pays** (`battle.gd`, the strike's raw-damage block and the recovery after the loop): 30% of Attack through the
whole pipeline; **plus `BOIL_OVER_PER_POINT` (2)% of Attack a point of `frenzy_bonus()` — only while the Berserker's core
(`bloodrage`) is held**; and the two-turn recovery, again only with it. Its 40 Rage is booked to Blood Frenzy's second term
BEFORE the strike (`note_resource_spent` at the top of `_resolve`), so for a Berserker the Rage the card costs does feed the bonus
the card cashes. **Driven** (`check_hw` §1a, printed): a Warrior at half health, a full bar — **with the Berserker's core the blow
took 84; without it, 21**, no recovery chip. GP §2 offers the card to every Warrior as HALF-WORKS (*22 against 89*, its own
figure).

**The cause of *"does not consume Rage for extra damage"***: the designer's Warriors have run on the Vanguard's core (Momentum)
in every save this batch has seen, and on that hero Boil Over is a 30% strike that spends 40 Rage — while its first words say it
spends the rage. **The code is what the card's sentence after the colon says; the text's opening is what misleads.** By the
brief's fork (CQ §6), **nothing changed**: the words, or the card, or the offer, are the designer's (ruling 1).

### §1b — THE SHARPSHOOTER'S CORE: SLOTTED, IT DISMISSES THE PET AT ONCE; TAKEN LATER, IT WAITS UNWORN

**What the first selection does that the later one does not**: class selection (`Run.awaken`) **SLOTS** the core rune it deals —
`member["engines"] = [rune]`, `equipped` true — and sets the lineage. **A core rune taken later** — an elite's cache, a bargain's
rune, a drop — is **HELD unworn on the hero** (HL §1, ruled: *one pick is never two things*; `map_screen._pick_rune` does not ask
for a core rune to be worn), and the map toasts *"… waits with the Hunter — slot it on the hero's rune panel to use it."* Until it
is slotted the hero holds no dismisser, so his kit keeps Summon Companion.

**Driven both ways.** Probe and gate (`check_hw` §1b, printed): a Hunter on Pack Bond takes the Sharpshooter's core through the
pick's own door (`hold_rune`, unworn) — kit *Quick Shot, Powershot, Snare Trap, Summon Companion*; slotted through
`Run.toggle_engine` — kit *Quick Shot, Powershot, Snare Trap*, and a real battle entered after it seats no Summon Companion and no
beast. Every route was asked: the Sharpshooter alone (class selection), beside Pack Bond, in Pack Bond's place, beside a spine —
each slotted arm drops the pet card; only the unworn arm keeps it. The battle spawn, the hero sheet and the map's kit panel all
read `Runes.held_engines` (the slotted set).

**So nothing changed**: the behaviour is HL §1's ruling, and slotting a core on the pick — or naming the pet in the toast — is the
designer's (ruling 2).

### §1c — A CREST RUNE IN THE CLASS RUNE DRAFT: SCOPED

**Which door it reads.** The one rune draft a hero answers on his own card is the pick of three `Run.roll_rune_candidates` rolls —
the elite's rune cache and the bargain's rune reward. It draws through `generate_rune` → `Runes.generate` → `Runes.eligible_ids`,
whose `_scope_ok` passes the crest's `party` scope for every hero (HK §4; HO §1's table names this roll). **So a crest rune
could fill a third of a Mage's cache.**

**What changed** (`run_state.gd`): the roll leaves every crest rune out **by name** (`Run.crest_rune_names`, read off the scope,
so a crest rune authored later is left out by doing nothing) — the channel `peddler_rune` already uses for the core runes, so
nothing else about the draw moves; **the answer** (`Run.rune_choice`) repairs a queued triple holding one, as it repairs a retired
or owned candidate (the scope never moves, so the repair is written back) and tops up from the class alone; and **the bargain's
choice of hero** (`claim_reward`) asks the same scoped pool, so it pays a hero with a class rune left rather than one with only
the crest's. **Not scoped**: the drop (`roll_fight_drop`), the Peddler (`peddler_rune`), the event verb (`grant_rune`) — each still
hands a crest rune over.

**Driven** (`check_hw` §1c): the pool parked to Tithe, Dirge and one Mage rune — the Mage's pick offers the Mage rune alone; a
queued triple of all three answers and stores the Mage rune alone; **the drop over the same pool still deals Tithe and Dirge**
(about two drops in three of 60, unseeded); with the Mage rune parked too, the Peddler offers a crest rune and the event verb grants one, while the Mage's
pick is empty; the bargain pays the Warrior, the one hero with a class rune left, twelve claims in twelve.

### §1d — THE ENEMY SELECTION BOXES: THE GEOMETRY, THEN THE FIX

**The geometry, measured** (a probe of the real spawn's units):

| | |
|---|---|
| **the box** | every unit's `_target_btn`: **140 x 220**, at (−70, −110) from its origin — one size for every body (`unit._build_target_zone`) |
| **the sprites** | frames of 100 px at scales 2.9–4.6 (290–459 px on screen); **the idle body's opaque pixels are 66–105 px wide and 52–82 tall** — a raider 73 x 57, a behemoth 92 x 72, the Hollow Crown 105 x 82 — sitting left of the origin (flipped), centred a little below it |
| **the spacing** (`ENEMY_LAYOUTS`) | neighbours **80 apart across** (two staggered columns) and **45–70 apart down**; same-column neighbours 95–140 apart |
| **the overlap** | in every layout of two or more: two enemies overlap 80 x 90; four, diagonal neighbours **60 x 150** and same-column ones 140 x 80; six, up to 60 x 175. The bodies of four raiders do not touch (7 px apart) while their boxes overlap |

So a hover lit whichever box was drawn last over the cursor, not the body under it.

**The fix** (`battle._fit_enemy_target_zones`, called once the warband stands): each enemy's zone is its idle body
(`unit.idle_body_rect`, the frame's opaque pixels at its scale, flipped as the sprite is) grown by `TARGET_ZONE_MARGIN` (8 px);
where two still meet, the overlap is split down its middle across its thinner side. A zone only ever shrinks, so no later split
re-opens an earlier one. **Enemies only**: they are placed once and never move home; a hero's zone and a companion's are
unchanged and overlap the same way (`HERO_SLOTS` 80 across, 75 down) — queued, not reported in play. **Nameplate selection is
not built (§5).**

**Driven** (`check_hw` §1d): fifteen warbands — layouts 2 to 6, each with the smallest bodies, the largest (the three bosses,
the behemoth, the chief, the bog troll) and a mixed set — **no two zones meet and every zone covers its own body's middle**; the
zones as built overlap in the layout of four (6 faults, the negative the fit answers); and a real spawn of six fits each zone to
about 83 x 74.

## §2 — THE MERCHANT IS AN EASY FIGHT'S REWARD (ruled)

**Built** (`Run.REWARDS`): severity 1 pays **40 gold or a merchant**; severity 4 pays **220 gold or a rune**; 2 and 3 unchanged.
**What severity 4 offers in its place: nothing new** — it already paid its gold or a rune wherever the merchant was gated (HS
§0c), so the list needed only the merchant taken out.

**Whether the gate still reaches it: yes.** HS §0c's gate drops the `shop` reward from whatever severity's list where
`shop_gated` holds (zone 1, columns 1–3), so it reads the merchant in severity 1's list as it read it in 4's. **On the new route a
gated severity-1 option pays its 40 gold.**

**What it does to how often a merchant is offered** (4,000 offers a rung at an open column, HEAD's table against HW's):

| rung | offers carrying a merchant, HEAD | HW | in the first three nodes |
|---|---|---|---|
| Wanderer | 31.1% (severity 4) | **24.7%** (severity 1) | 0 → 0 |
| Warden | 56.2% | **18.8%** | 0 → 0 |
| Ruin | 19.6% | **38.8%** | 0 → 0 |

On the designer's rung a merchant is now offered about one bargain in five, where it was more than half; on Ruin, where every
card is drawn from the whole table, it is twice as common. **The reading of *an easy fight* is the batch's** (ruling 3 prices the
others). `master.html` §3a's table and §3b, the glossary's Peddler and Severity entries, `CLAUDE.md`'s gate bullet and five code
comments say severity 1 now.

## §3 — THE SIX CARD-VERSUS-CODE ITEMS, AS RULED

| item | ruled | built | magnitude moved |
|---|---|---|---|
| **Mark of the Hunt's reset** | code toward card | the read moved from `_on_enemy_death` (every caller reaches it after `_die()` has cleared the body) into `_on_unit_died`, which `_die()` calls BEFORE the clear — where the engine marks are already read for the same reason — so every death of the marked enemy resets the card, whatever dealt it | **none** — a dead read made live |
| **Charge's Daze** | code toward card | `applies_status` dazed **1 → 2** turns; the Perfect's *2* → **3**, implemented (`perfect_id` `status_one_more`: one turn more on a Perfect, beside `status_plus`); card *DAZED for 2 turns*, Perfect *Dazed for 3 turns* | **Daze 1 → 2, Perfect (none) → 3** |
| **Blood Debt's killing bleedout** | code toward card | the mark is read before the bleedout's `take_hit` (`debt_mark`), so the bleedout that kills its bearer pays the heal | **none** — the payout (25% of maximum health) reaches one more bleedout |
| **Counter Time's two turns** | card toward code | card *loses its next turn*; its log line the same | **none** — `COUNTER_TIME_TURNS` stays 2 |
| **Snare Line's chilled stun** | card toward code | the card's three lines on a Chilled body cut; the log line that named two turns gone; the clause kept, said to pay nothing | **none** — `SNARE_LINE_COLD_STUN` stays 2 |
| **Thin Blood** | a straight bug | the price laid at the status door every Poison passes, the entry stamped `zero_tick`, read as zero by `_dot_pass` | **none** the rune names — his Poison deals nothing, as the card says |

### §3a–§3c, DRIVEN BOTH WAYS (`check_hw`)
- **Mark of the Hunt**: marked through the card, the marked enemy killed through the damage door — the cooldown is gone and the
  log says *the hunt is rewarded*; an unmarked enemy killed first left it standing.
- **Charge**: a Good Charge lays 2, a Perfect 3; after the bearer's own turn starts (its tick) it is still Dazed and its miss reads
  0.25 against the base 0.05 — the one turn it laid before covered none of its attacks, as a status ticks at its bearer's turn start
  (`CLAUDE.md`'s *A DURATION IS STATED AS APPLIED*).
- **Blood Debt**: a bleedout that kills its marked bearer heals the Berserker 44 (25% of 175) and says so; one that does not kill
  pays the same; a killing bleedout on an unmarked body pays nothing.

### §3d — COUNTER TIME AND SNARE LINE: WHY THE WORDS MOVED AND NOT THE CODE
**The premise, checked at the turn loop**: a stunned unit's turn removes `stunned` whole (`u.remove_status("stunned")`) and
skips — so a stun laid for 2 costs exactly one turn, as one laid for 1 does. Snare Line's chilled clause re-lays the stun at 2 on
a body the spring has just stunned for 1: the same one turn. **Both cards said what no stun in the game does.** `CLAUDE.md`'s
duration rule gains the bullet *A STUN COSTS ONE TURN, WHATEVER IT IS LAID FOR*; a sweep of every card, rune, talent, glossary
entry and log line found no other text stating a stun longer than one turn (Ironclad's *cannot be Stunned for 4 turns* is an
immunity's length). `check_dr`'s Counter Time arm still pins the stun laid at 2, its reason re-worded.

**And what it costs Counter Time**: at one turn it is Pommel Strike's stun without the blow (ruling 4).

### §3e — THIN BLOOD: THE PRICE WAS MISSED TWICE
**The brief's cause, held**: `_apply_poison` set the tick to 0, and `_dot_pass` read a zero tick as *no tick set* and dealt the
legacy `DOT_STATUSES` 3 a stack. **And a second cause, found at the line**: the rune's own payout — Trapper's barb, certain with the
rune — lays its Poison with `_apply_status` and `_dot_tick`, **never through `_apply_poison`**, and so does Explosive Shot
(`applies_status`). So the barb the rune buys bit at 3% of his Attack, price or no price.

**The fix, in one place each**: `battle._thin_blood_price(src)` is the one answer (the rune worn and Trapper equipped — GW §3's
gate); the status door lays every Poison from such a source at zero and stamps the entry `zero_tick`; `_dot_pass` falls back to
the legacy figure only when the zero is not meant. **No other writer moves**: only the price stamps a zero, so every other zero
tick — a Poison or a Burn a gate lays with no tick to dress a board, or Chain Ignition's split of a dead body's Burn, which
carries that body's tick — still reads the legacy figure (`check_hw` §3e asserts the fallback). A census of every
`_apply_status` that can lay either found every live card route passing a tick of at least 1.

**Driven**: with the rune and Trapper equipped, a tick of his Poison costs **0** laid by `_apply_poison`, by the barb and by
Explosive Shot; with no rune, or with Trapper merely owned, **3** each.

## §4 — THE ATTRIBUTION FRAME IS HX's

Not touched. `docs/state.md`'s HV entry says HX §4 drives it.

## §5 — DELIBERATELY NOT DONE, AND WHEN IT IS

Recorded in `docs/state.md` as the brief gives it, with the roadmap's order: **HX** (the trim and the checks — the roadmap's #2,
lettered HW there) and then the ceiling, with the block index waiting on HX's re-measure; **HY — the eyes**; **HZ — the bag and the slots** (three core slots, RULED, NOT BUILT);
**IA — the draft flow**; **IB — resources and fire**. **MANA STAYS (ruled)**, and Channel's tempo payout is alive and owed.
Unchanged: one conjunction, Rupture at 10, a meter is not a half, Marrowfire's re-cut, the Occultist's Break card, the Skirmisher
and the Tracker, a fallen hero between fights, Tithe's read site. **`CLAUDE.md` is not split and its ceiling did not move** (§7).

## §6 — THE VERIFICATION

### §6a — THE SAVES, BEFORE ANYTHING
Backed up first and verified by hash: **`../save-backups/HW-20261008-112149`**, the four files byte-identical to the live ones at
11:21:49. **Against HV's backup (`../save-backups/HV-20261007-091415`), two moved and two did not**: `relics.json` (30 August)
and `settings.cfg` (21 August) are byte-identical; **`profile.json` and `run_save.bin` moved**. What moved, read off the files:
the profile counts **one more zone cleared (13 → 14)** and one more Withered Warden killed (13 → 14), **three runs started**
(twelve heroes — two parties of a Warrior, an Arcanist, a Cleric and a Beastmaster, one of a Warden, a Mage, a Holy cleric and a
Hunter) and a talent point banked to each class; the run save, decoded, is **a fresh run with no debug touch, on the Warden road,
at zone 1's first node with one fight won** — 117 gold, the Hunter holding Bared Fang unworn, the Cleric on the Oathkeeper's
core. The game's own log puts a windowed session's start at 09:20:53 on 8 October, and the files' last writes at 09:21:40
(`profile.json`) and 09:23:44 (`run_save.bin`). **No Godot was running when the batch began** (the rows of `ps`). **No save
version moved**: `SAVE_VERSION` is 15 before and after.

### §6b — HEAD'S GATES AGAINST THE NEW GAME, BEFORE ANY GATE WAS EDITED
**The recon**: HEAD's (`7e8cd10`) gates, suites, runner, baselines, pin manifest and documents — every one HEAD's own copy, from a
snapshot taken before anything was edited — with HW's five game scripts laid over, in an isolated copy (`config/name` *"Dawn of
Decay HW recon"*, user data seeded from HW's backup). Its prediction was written at 11:55 and the run launched at 11:55:27.
**136 targets, 11:55:27 to 13:10:30 — 75 min 3 s — read `check_de` 561 / 7.** Against HV's pre-pass, target by target:

| target | HV's pre-pass | the recon | why |
|---|---|---|---|
| `test_batch_an` | 6051 / 0 | 6050 / 3 | **predicted**: its reward table held the merchant in severity 4's list (the count is unseeded, in its band) |
| `check_ho` | 176 / 0 | 176 / 7 | **predicted**: §1d drove a crest rune through a hero's cache onto the real overlay |
| `test_runes` | 7706 / 0 | 7706 / 1 | its crest arm held that the crest's runes reach a hero's cache |
| `check_fd` | 58 / 0 | 58 / 1 | its §1d asked that a crest rune be among 400 cache first-picks |
| `check_hr` | 100 / 0 | 100 / 1 | §0a asks the cache door with two crest-scoped fixtures |
| `test_batch_bw` | 512 / 0 | 512 / 3 | its source arm anchored on `victim.has_status("blood_debt")`, the read HW moved — **a single-quoted needle my first literal sweep could not see** |
| `check_gp` | 454 / 0 | **443 / 0** | §4's seeded whole run took another road: one check a card offered, 63 cards → 52 (attributed in §6c) |
| `check_de` | 561 / 0 | 561 / 7 | the seven above |

**The four I had not predicted** were each a gate asking a hero's cache for a crest rune, or a literal my sweep missed; I had
named the family (*gates that park the rune pool so a crest rune fills a hero's triple*) as unknown, and the recon is what
answered it. `check_cm_live` 13 / 4 read HV's FAIL lines word for word; **`check_gj` 70 / 1 read its sanctioned defect with
other figures** — *the card says +157 gold and the purse moved 177* where HV read +169 / 189: the Tollkeeper's Bell's +20 beside
a card that omits it, as GN sanctioned, on a seeded road whose draws HW moved (§6c). No Parse Error, SCRIPT ERROR, TIMED OUT or
NO VERDICT line in any of the 136 logs; the manifest 136 names, each once. **After the recon's snapshot two things changed
that it could not read**: `_fit_enemy_target_zones` takes the units it fits (the spawn passes its warband — the same call), and
the glossary's three entries; the pre-pass reads both.

**Before the recon, the needles**: `check_di`'s tripwire — no `_apply_status` call site added or removed (220 on both trees,
comment-stripped; one `_log` call fewer, Snare Line's); and the literal sweep (§6c's last bullet), which the recon showed to be
one quote style short.

### §6c — WHAT WAS RE-POINTED, AND WHAT IS NEW
Every re-point keeps its count; each is repaired to its intent with the reason in the file.
- **`test_batch_an`** — the reward table's five arms assert the ruling (severity 1 pays its gold or a merchant, severity 4 its
  gold or a rune) where they asserted the merchant in severity 4's list.
- **`check_ho`** — §1d asked a crest rune through one hero's triple onto the real overlay; it now asks the same overlay the
  ruled question (the roll offers the class rune alone; a triple queued with two crest runes beside it shows and hands over the
  class rune alone; nothing fills the crest or the bag). 176, unmoved.
- **`test_batch_bw`** — the Blood Debt source arm anchored on `victim.has_status("blood_debt")`, the read HW moved above the
  bleedout's hit; it anchors on the payout's own read now. 512, unmoved.
- **`test_runes`** — its crest arm held that the crest's runes reach a hero's cache; it holds them at zero while the file holds
  live ones. 7706, unmoved.
- **`check_dr`** — Counter Time's pin on the stun laid at 2 stands; its reason (*the card promises*) is re-worded. 84, unmoved.
- **`check_fd`** — §1d asked that a crest rune be among 400 cache first-picks (HO's route); it holds that count at zero over a pool
  whose live crest runes every other roll still deals. 58, unmoved.
- **`check_hr`** — §0a asks every door with a refused and a payable crest-scoped twin; the cache can no longer reach either, so its
  door is asked with the same pair scoped to the hero's class, laid for that arm alone. 100, unmoved.
- **`check_gp` — 454 → 443, THE GATE UNTOUCHED, ITS ROW MOVED AND ATTRIBUTED BY AN `ok()` TRACE** (HO's to HS's method). Six
  traced runs in isolated copies: HEAD's gate on HEAD's tree (454); on HW's tree with every gameplay change stubbed — the reward
  table, the crest scope of a hero's pick and the six card-versus-code items (454, **message for message HEAD's, in order**: the
  zone fit, the texts and the log lines move nothing); the six alone stubbed (443, **message for message HW's**: the six move
  nothing on this road); the reward table alone stubbed (458); the crest scope alone (468); and HW's tree (443). Every difference
  is in §4's dice-driven family — *the engine-less X was OFFERED Y*, 33 out and 22 in, and two messages that print a count. The
  gate's seeded road walks two whole runs, and HW changed the bargains the bot is offered and the runes a hero's cache deals.
  **`check_gj`'s sanctioned red, the same way**: on HW's tree with every gameplay change stubbed it reads HV's *+169 gold … 189*;
  on HW's own, *+157 … 177* — the Bell's +20 beside a card that omits it either way.
- **`check_hw` — new, 65 checks, one property an arm** (§1c, §1d, §2, §3a–§3e, §5, §9); §1a and §1b printed as records, never
  asserted, both owed a ruling.
- **`run_battery.sh`** — `check_hw` joins GATES (137 targets). **`baselines.json`** — `check_hw` new (65 / 0), `check_parse`
  210 → 211, `check_gp` 454 → 443 (below), and notes on `test_batch_an`, `check_ho` and `check_gj`; it round-trips byte for byte
  at indent 1. **`pin-manifest.json`** — regenerated after the last gate edit: **1,714 pins, HEAD's 1,711 and
  three more** — `check_hw` §5's needles, two in `CLAUDE.md` and one in `docs/ways-of-working.md`, each resolved in its text; none
  removed, and the eleven unresolved are HEAD's eleven.
- **The documents**: `CLAUDE.md` (the rite's rank confirmed; the crest never in a hero's own pick; the merchant's severity; Thin
  Blood's price at the door; a stun costs one turn), `docs/ways-of-working.md` (the process rule), `master.html` (the stamp, the
  bargain table and §3b, Charge, Counter Time, Blood Debt, the crest paragraph, the partner-spec table at eight),
  `data/glossary.json` (Runes, the Peddler, Severity), `docs/design-notes.md`, the changelog and `docs/state.md`.
- **The literal sweeps.** A sweep of every gate literal of four or more characters, **single- and double-quoted**, over HEAD's
  and HW's copies of every edited file: LOST — `test_batch_bw`'s anchor (re-pointed), HW's own absence needle, and the
  lowercase *chilled* in `master.html`, which no reader of that file asks for. **My first sweep read double-quoted literals
  only and missed `test_batch_bw`'s single-quoted anchor; the recon found it** — the single-quote hole a find-anchor census
  first fell into at EY. And every ABSENCE needle a gate holds (372) was checked against the edited files: none is newly present.

### §6d — THE CONTROLS
**Twenty-two controls, each in its own clone of the finished tree** — `config/name` renamed, user data seeded from HW's backup,
every anchor dry-checked against the tree before arming (22 of 22 landed) — **each one defect, read by its FAIL text, never its
count.** Two lanes.

| control | the defect | reads | the FAIL text names |
|---|---|---|---|
| C00 | none — the baseline | `check_hw` 65 / 0 | — |
| C01 | a hero's pick no longer leaves the crest out (the roll's exclusion empty) | `check_hw` 65 / 3; `test_runes` 7706 / 1; `check_ho` 176 / 1 | the Mage's pick offered *dirge, long_fuse, tithe*; not the class rune alone; the empty pool's pick not empty; 120 crest candidates in `test_runes`; `check_ho` §1d's roll |
| C02 | **the scope reaches the DROP** (the crest left out of its pool) | `check_hw` 65 / 1; `check_ho` 176 / 4 | **the drop no longer offers a crest rune** (60 of 60 the class rune) — the positive arm biting; `check_ho` §1a's pin and three §1b arms |
| C03 | the answer no longer repairs a queued crest rune | `check_hw` 65 / 2; `check_ho` 176 / 2 | the queued triple's answer holds the crest's; the repair not written back; the overlay shows them |
| C04 | the bargain asks who it can pay off the unscoped pool | `check_hw` 65 / 1 | the bargain picked a hero it could not pay — *nothing left* 8 times of 12 |
| C05 | the spawn no longer fits the warband's zones | `check_hw` 65 / 1 | the real spawn's zones overlap (60 x 170 …); the sweep, which calls the fit itself, green |
| C06 | the fit no longer splits a meeting | `check_hw` 65 / 2 | 37 zone faults in the sweep; the real spawn's 9 x 23 overlaps — the margin alone |
| C07 | HEAD's reward table | `check_hw` 65 / 4; `test_batch_an` 6051 / 4 | the table arms, and a merchant beside a modifier above severity 1; `test_batch_an`'s four re-pointed arms |
| C08 | the gate no longer holds the merchant out of the first three nodes | `check_hw` 65 / 1; `check_hs` 83 / 1 | 721 merchants in the first three nodes; `check_hs` §0b |
| C09 | Mark of the Hunt's reset read no longer runs before the clear | `check_hw` 65 / 2 | the marked enemy died and the card did not reset (4 left); not in the log |
| C10 | Charge's Daze back to one turn | `check_hw` 65 / 4 | the card's turns; a Good Charge laid 1 and, after the bearer's turn started, covered nothing (miss 0.05); a Perfect laid 2, want 3 |
| C11 | Charge's Perfect clause gone | `check_hw` 65 / 1 | a Perfect Charge laid 2, want 3 — the Good arm green |
| C12 | Blood Debt's mark read after the bleedout's hit again | `check_hw` 65 / 1 | the killing bleedout paid the debt nothing — the non-killing arm green |
| C13 | Counter Time's card promises two turns again | `check_hw` 65 / 1 | the card does not say one turn |
| C14 | **a magnitude moves with the words** (`COUNTER_TIME_TURNS` 2 → 1) | `check_hw` 65 / 2 | a magnitude moved; the stun not laid as before |
| C15 | `_dot_pass` ignores `zero_tick` | `check_hw` 65 / 3 | all three priced routes bite (3) |
| C16 | the price no longer charged at the door | `check_hw` 65 / 3 | the barb and Explosive Shot bite, and `_apply_poison`'s unstamped zero reads the legacy 3 |
| C17 | the fallback removed: a tick never given reads zero too | `check_hw` 65 / 1 | **a Poison laid with no tick deals nothing** — the positive arm biting |
| C18 | `CLAUDE.md` loses the rite's confirmation | `check_hw` 65 / 1 | §5's needle |
| C19 | **a re-tune**: the zone margin 8 → 4 | 65 / 0 — **green, as a re-tune must be** | — |
| C20 | **a re-tune**: Mark of the Hunt's cooldown 3 → 4 | 65 / 0 — **green** | — |
| H01 | HW's gates against HEAD's game (HEAD's five scripts and glossary laid over) | `check_hw` 60 / 25, **one throw**; `test_batch_an` 6050 / 4; `check_ho` 176 / 3; `test_batch_bw` 512 / 3; `test_runes` 7706 / 1 | every changed behaviour: §1c's five, §2's four, §3a's two, §3b's six, §3c's one, §3d's three, §3e's three; §1d THROWS where HEAD has no fit (*Nonexistent function `_fit_enemy_target_zones`*), losing its five arms |

**Every needle a control aimed at broke, and both re-tunes stayed green.** C02 and C17 are the positive arms biting — the scope
that must not reach the drop, and the fallback that must survive the price; C11 and C12 each break one arm of a pair and leave
its twin green, so the pair reads apart.

### §6e — THE PRE-PASS AND THE ACCEPTANCE RUN
**The pre-pass** — the tree's own runner in an isolated copy (`config/name` *"Dawn of Decay HW prepass"*, user data seeded from
HW's backup), proved equal to the tree file by file before the launch (513 files, tracked and untracked, every one identical
but `project.godot`'s renamed line). Predicted before it and launched at 13:49:44: **137 targets, 13:49:44 to 15:05:01 — 75 min
17 s — read `check_de` 565 / 0 / 0, exactly as predicted.** Against HV's pre-pass, target by target, **six moved: the four this
batch moves** — `check_hw` new at 65 / 0, `check_parse` 210 → 211, `check_gp` 454 → 443 (§6c), `check_de` 561 → 565 — **and two
counts that move with a draw inside their bands** (`test_batch_an` 6052; `test_batch_bk` 130 against [129, 131]). Every other
target read HV's reading. `check_cm_live` 13 / 4 with HV's FAIL lines word for word, and `check_gj` 70 / 1 reading *the card says
+157 gold and the purse moved 177* (§6c); the run harness PASS 22 / 382 / 8; no Parse Error, SCRIPT ERROR, TIMED OUT or NO
VERDICT line in any of the 137 logs; the manifest 137 names, each once — HV's 136 and `check_hw`. **None of the risks the
prediction named arrived**: the changelog's readers (`check_fg` 22, `check_dv` 84) and the document instruments over the
regenerated manifest (`check_ec` 24, `check_ed` 18, `check_ff` 68) read their HV readings, as did the twenty-four targets that
read the glossary, `test_batch_an`'s draw aside; and `check_fg` §2 read `CLAUDE.md` at 445,442 B.

**One file changed after the pre-pass's copy was taken, and the acceptance run is what read it**: `docs/state.md` at 13:51:32 —
ruling 6 and its heading's count (FIVE → SIX). Before the acceptance run it was swept against every gate literal (19,431, single-
and double-quoted), wrapped and unwrapped: nothing lost and nothing gained; its two readers read none of the edited lines
(`check_es` §4's census window opens on *2+ threshold*; `check_hp` §5 asks three words, all still there).

**The acceptance run in the repository** — the repo's own runner and the live user folder, predicted before it and launched at
15:07:09, the tree frozen before it (513 files; `.git`, `.godot` and `save-backups` aside) with the player's four files hashed
beside it, and `ps` read by rows every 15 s — **137 targets, 15:07:09 to 16:22:22 — 75 min 13 s — read `check_de` 565 / 0 / 0, as
predicted.** **The watcher's 299 readings found no Godot without `--headless`**: the designer's game was not opened, and the
shape that red seventeen gates at HV and six at HT did not arrive. Every target read its pre-pass reading but the two counts that
move with a draw, inside their bands (`test_batch_an` 6053 in [6044, 6066]; `test_batch_bk` 131 in [129, 131]); `check_cm_live`
13 / 4 and `check_gj` 70 / 1 with the pre-pass's FAIL lines word for word; the run harness PASS 22 / 382 / 8; no Parse Error,
SCRIPT ERROR, TIMED OUT or NO VERDICT line in any of the 137 logs; the manifest 137 names, each once. **The tree was
byte-identical before and after (513 files), and the player's four files were untouched** — the same hash, size and modification
time before and after, and identical to HW's backup — so nothing was restored over them and no gate wrote them, not even with
the same bytes.

**Then the final tree.** `docs/state.md`'s verification lines and its `CLAUDE.md` line were written after the acceptance run:
the only change to the tree since its freeze, beside this report, which no gate opens. The literal sweep across that edit
(19,431 gate literals, wrapped and unwrapped) lost nothing and gained nothing. **Every target that names `docs/state.md`, with
the document instruments, re-read the final tree in an isolated copy** (*"Dawn of Decay HW final"*, proved equal to the tree;
16:25:34 to 16:28:30, predicted before it): `test_batch_aj` 213, `as` 273, `at` 359, `aw` 212, `check_dm` 93, `check_ec` 24,
`check_ed` 18, `check_ek` 47, `check_es` 57, `check_ff` 68, `check_fg` 22, `check_fr` 25 and `check_hp` 171 — each its
acceptance reading, 0 failures, no throw.

## §7 — HOUSEKEEPING

- **HV's eight isolated copies** — **in the Trash**, selected by the *"Dawn of Decay HV "* prefix, under *"DoD spent user-data
  folders (Batch HV's eight, cleared at HW 2026-10-08)"*: **8 folders, 3,920 KiB** — HV's own count. `app_userdata` went from 487
  folders and 153,144 KiB to 479 and 149,224 KiB; the older folders, the live *Dawn of Decay* folder and `../save-backups/` were
  not touched.
- **HW's own copies**: **18 folders, 6,720 KiB** — the three probes (*probe*, *headprobe*, *decode*), the recon, the two pre-checks
  (*pre1*, *pre2*), the two control lanes (*ctlA*, *ctlB*), the eight trace copies that attributed `check_gp` and `check_gj`
  (*gptr_…*), the pre-pass and the final tree's re-read (*final*); the acceptance run used the live folder and made none — HX
  clears them by the *"Dawn of Decay HW "* prefix (HO §5).
- **This report stayed in the scratchpad until its verdict was written**, and was grepped for the token marker (the double at-sign)
  before it landed; `docs/state.md` was held to the same grep.
- **`CLAUDE.md` IS NOT SPLIT AND ITS CEILING DID NOT MOVE. At close it is 445,442 B = 435.00 KiB** — +1,426 B at HW — **with 35.00
  KiB under 470: about 4.3 batches at the record (EZ's +8,293 B) and 7.9 at the nine-batch mean (+4,545 B, HN–HV).**
