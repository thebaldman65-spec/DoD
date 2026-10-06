# BATCH HT — TWO RULINGS, AND THE CENSUS THAT OPENS THE REST OF THE LADDER

**On `class-merge`, from `c7ac608` (HS). IMPLEMENT ONLY.** HS's six rulings are taken (§1): four confirm what was built and
move nothing but the record, and **two move code** — **an enemy mender's Cleansing Rite reads the chill INSIDE a Rupture**,
thawing it a stack at a time as it thaws any chill, so a Rupture is never lifted by it; and **on screen a conjunction's tier
is its DEGREE** (*Rupture is a second-degree affliction*), with every identifier unmoved. **§2 is the batch: a census of every
status a hero can lay on an enemy**, HR §4a's five columns for each, and the structural question the next design pass waits
on — **whether a meter state can be a conjunction's half**. It proposes nothing. **§3** records the two replaced names and
corrects `master.html`'s seven fire-and-ice sentences, with every copy of them found off the document.

**VERDICT: SHIPPED — and the acceptance run's six reds were the designer's own game, saving mid-run.** The pre-pass — 134
targets in 74 min 4 s, an isolated copy proved equal to the tree — read `check_de` 553 / 0 / 0, every target at its predicted
row. The acceptance run in the repository — 134 targets in 74 min 6 s, the tree frozen and byte-identical after it (508 files) —
read `check_de` 553 / 6: the designer launched the game at 13:14:11, and its saves landed inside six gates' windows, each read by
that gate's player-file arm and by nothing else; every other target read its row and its pre-pass reading. Re-run, three read
their rows in the repository and three in a proved copy (§5f). No Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any
log. Forty-four controls, every one red on the line it aimed at. Seven rulings are owed; the first is two standing rules broken,
driven.

## NEEDS A RULING

1. **DOWNWIND BREAKS TWO STANDING RULES, DRIVEN (§2f): IT COPIES A GLACIAL HOLD AS AN UNMANAGED PERMANENT FREEZE, AND IT
   FORWARDS `force` PAST AN UNBROKEN BOSS.** A Cryomancer's hold beside a Hunter's Downwind locks a SECOND enemy for the whole
   fight — not a hold, so no limit, no charge, no release (every enemy, with the Carrion rune) — and a Perfect Pommel Strike's
   copy stuns an unbroken boss. Both favour the player; neither is fixed here, because the fix is what Downwind carries, and a
   card's payload is the designer's. **The shapes, priced and not chosen**: Downwind leaves Frozen alone, or copies it as an
   ordinary timed freeze (`_freeze_turns`'s one turn); and the copy drops `force`, as every caller but Pommel Strike's Perfect
   already does. Each is one condition at the copy (`battle._apply_status`, the Downwind block).
2. **THE RITE'S RANK (§1b), AS BUILT: A CANDIDATE CARRYING A CHILL RANKS BY ITS CHILL**, so a Glacial Hold's permanent chill is
   the rite's first pick inside a Rupture as it is bare. The other reading ranks a composition by its own clock (the shorter
   ingredient's) and lets a longer debuff beside it take the rite instead. Confirm, or choose the other.
3. **CONTAGION IS THE RESERVED CONTAGION SPACE'S OWN WORD (§3a).** The mechanism (Poison + Bleed, nothing spreads) is outside BA
   §1's reservation; the name is inside it, and BA retired *Virulence* for being a pathogen term. Keep it, or rename.
4. **MARROWFIRE NEAR-MISSES FOUR NAMES (§3a)** — *Fire*, *Chain Fire*, *Arrow Shot*, *Poison Arrow*, by containment. Ship it as
   a named near-miss (HP's *Dead Air* beside *Deadfall* is the precedent), or rename.
5. **FIVE CARDS AND A RUNE PROMISE WHAT THE CODE DOES NOT PAY (§2f)** — Mark of the Hunt's reset, Counter Time's two turns,
   Snare Line's two-turn chilled stun, Charge's Daze and its Perfect, Blood Debt's killing bleedout, Thin Blood's silent poison.
   Each is a repair batch's; **which way each goes — the code toward the card, or the card toward the code — is a magnitude, and
   the designer's** (CQ §6).
6. **THE CENSUS (§2) IS THE DESIGNER'S TO DECIDE ON, AND IT PROPOSES NOTHING**: the second conjunction, its halves and its class
   pair; and whether a meter state may be a half — §2e prices it (Broken for Marrowfire and Reckoning; Bleed, a meter too, for
   Contagion), and lists what a Warrior lays instead.
7. **THE WORDS, PROPOSED**: the chip's *(second degree)*, the forming line's *— second degree,*, the glossary's *SECOND-DEGREE* /
   *THIRD-DEGREE* and *a second-degree Conjunction*, `master.html`'s *Rupture is a second-degree affliction*; the rite's *thaws
   one stack of the Chilled inside Orc Raider's Rupture* and *thaws the last stack of …*, the end line's *a cleanse: its Chilled
   is lifted*; the Glacial Hold rule's *+15% damage from every hero's strike*.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HS | **Held**: HEAD `c7ac608` = `git ls-remote origin class-merge`, the tree clean but the untracked `save-backups/` |
| 2 | *"The designer is playing Rupture — hash against HS's and report what moved"* | **Nothing had moved at 08:10**: the player's four files were byte-identical — md5, size and mtime — to HS's backup (and so to HR's): `profile.json` 09:16:35 and `run_save.bin` 10:13:06 on 5 October, before HS shipped (§5a). **It became so at 13:14**, mid-acceptance: the designer's game wrote `profile.json` and `run_save.bin` (§5f) |
| 3 | §1.1: *"62% of the bot's Ruptures died with the body before ticking"* | **Not so — two figures in one.** Re-read off HS's own sim logs: 62% (73 of 117, the Pyromancer party — the one whose Ruptures made the 872 Break) is the share that **died with the body**; the share that died **before ticking** is 17% (20 of 117; 65 of the 104 that can be followed one to one ticked exactly once). The Cryomancer party: 38 of 40 died with the body, 29 of them before a tick. The ruling's conclusion stands either way — the comment beside the constant states both |
| 4 | §1.1: a Rupture lives one to three ticks, 10–30 Break against 100 | **Held as HS's read of play**; the bot's Ruptures live fewer (party B: 0 ticks 18, 1 tick 65, 2 ticks 17, 3 or more 4) |
| 5 | §1.2: one composition clock would have reset a Rupture to permanent | **Held** (HS ruling 2's own case) |
| 6 | §1.4: *"every reader that asks for `chilled` finds it inside a composition, across the 99 call sites HS derived"* | **Held by construction** — the seven doors read `_find_status`. Re-counted at HT a different way (every literal `burn` / `chilled` argument to a door and every `set_chilled_stacks` call outside the doors' own bodies): 107 calls in `battle.gd` and `unit.gd`, 20 of them writes; HS's 99 counted card arms as functions and is quoted as HS's |
| 7 | §1.4: the rite goes through *"the generic cleanse door (`dispel_one_debuff` / `_cleansable_debuffs`)"* | **Half**: it takes its candidates from `_cleansable_debuffs` and strips with `remove_status(pick.id)`; it never calls `dispel_one_debuff`. Its chill rule tested the pick's own id |
| 8 | §1.4: `set_chilled_stacks` already finds an ingredient | **Held** (`_find_status`, HS §2d) |
| 9 | §1.5: a Scarlands elite under Hoarfrost with an Ashblade, none in 300 runs | **Held** (HR §4g) |
| 10 | §1.6: the surfaces are the chip's tooltip, both glossary entries, the log's *forms* line, `master.html`'s conjunction rows | **Held, and the list is whole** — derived over every literal of the composition machinery, the glossary and the document (§1c) |
| 11 | §1.6: the BR §1 sweep over HS's 1,026 names | **Held**: 1,026 names in fourteen populations, re-read at HT |
| 12 | §1.6: the HL §2 split — player-facing text moves, the code does not | **Held** (HL §2: *core rune* on screen, `engine` in code) |
| 13 | §2: Burn, Chilled and Frozen are HR §4a/§4c/§4f's | **Held** — three of the population (§2) |
| 14 | §2: four statuses have `add_status` branches of their own (HS §1b) | **Held**, and the census names every bespoke rule beside them (§2) |
| 15 | §2: *"Broken is a meter state with no entry, no clock and no `src`"* | **Half**: it HAS an entry — `take_hit` writes Broken's chip with `add_status`, a turn count of 1 that `tick_statuses` never moves, removed only by `recover_from_break` — and it has no clock and no `src`, because it is written around the status door (§2, driven at `check_ht` §4) |
| 16 | §2: *"the Warrior has no half of anything"* | **Not so**: a Warrior holding no engine lays Sunder, Stunned and Mocked from his own kit (driven at `check_ht` §4), and more from his pools (§2) |
| 17 | §3: *Blight* is a live status id (chip `Bl`) | **Held** (`blight`, Blight the Well's *Blighted*) |
| 18 | §3: *Breach* near-misses the BREAK tag and the Break nodes by stem | **Held, and wider**: five near-misses (§3a) |
| 19 | §3: `master.html`'s seven (HR §4h) | **Held, all seven**, each checked at the code (§3b) |
| 20 | §3: HS §1b found the recast claim in four copies | **Held** (the rules file, the glossary, `master.html`, a `battle.gd` comment) |
| 21 | §4: `CLAUDE.md` 424.40 KiB of 470, about 5.6 batches at the record | **Held** at HS's close (§6) |
| 22 | §5: HS's backup `../save-backups/HS-20261005-202947`; nothing had moved since HR's | **Held** |
| 23 | §5: two gates read red at HS on the dice alone (`check_fo`, `check_hk`) | **Held** (HS §8b) |
| 24 | §5: clear HS's seventeen copies | **Held**: seventeen, 8,724 KiB (§6) |
| 25 | §5: HS read 133 targets in 73 min 46 s | **Held** (HS's acceptance run); not taken as a runtime |

## §1 — HS'S SIX RULINGS

### §1a — RULINGS 1, 2, 3 AND 5: CONFIRMED, AND THE RECORD SAYS WHY

- **1 — `RUPTURE_BREAK_PER_TICK` STAYS AT 10.** The watch condition is written beside the constant (`battle.gd`): a Rupture
  lives one to three ticks, so it pays one to three times the figure — 10–30 Break at HT's confirmation, against a meter of
  100, about one strike's worth for two heroes' turns. **The sim's 872 Break is not a guide**, and the comment says why in
  measured terms: the bot makes Ruptures by accident, and most die with the body (the premise table corrects the brief's
  figure: 62% is the share that died with the body, not the share that died before ticking). `CLAUDE.md`'s PROPOSED marker on
  the figure comes off; `check_hs` §3a still pins it in one place.
- **2 — PER-INGREDIENT CLOCKS, CONFIRMED.** `CLAUDE.md`'s conjunction block and `docs/design-notes.md` record that **the brief's
  own reading was the defect and the build was right**: one composition clock running the ingredient's rule would have let a
  Glacial Hold's permanent chill, re-applied, reset a Rupture to permanent — FC's shape (Shared Ruin's chain) — so a later
  reader does not take the difference for drift.
- **3 — THE SURVIVOR, CONFIRMED.** Nothing changes; recorded beside the clock bullet.
- **5 — SYMMETRIC, CONFIRMED.** Recorded with its reason: nearly unreachable today (a Scarlands elite under Hoarfrost with an
  Ashblade, none in 300 runs, HR §4g), so it costs the player almost nothing now, and the day an enemy is given a chill it is
  already built.

### §1b — RULING 4: THE RITE AT THE CHILL DOOR, BUILT

**What it was.** The Ritual Chanter's rite (`battle._resolve_special`, `"cleanse_allies"`) picks each ally's longest-lasting
cleansable debuff from `_cleansable_debuffs` — the top level, a composition one candidate — and ran Batch V's rule only when
the pick's own id was `chilled`. A Rupture's id is `rupture`, so it fell to `remove_status(pick.id)` and left whole: the Burn
and every stack of the chill.

**What it is.** One read now looks inside: `battle._rite_chill(entry)` is the entry when it is Chilled, the Chilled inside it
when it is a composition carrying one, else nothing. **A candidate that carries a chill is ranked and thawed by its chill,
through the chill door** (`set_chilled_stacks`, which already finds an ingredient):

| the pick | before HT | since HT |
|---|---|---|
| a bare Chilled x2+ | one stack off | **unchanged** — one stack off |
| a bare Chilled x1 | stripped | **unchanged** — stripped (its one stack is the pile) |
| a Rupture, its Chilled x2+ | **lifted whole** (Burn and chill) | **one stack off the chill inside; the Rupture and its Burn stand** |
| a Rupture, its Chilled x1 | **lifted whole** | **the chill's last stack goes; the Rupture ends by it, the Burn stands alone with its turns** |
| a Rupture whose chill is a Glacial Hold's (permanent) | ranked by the Rupture's clock — the Burn's | **ranked by the chill (permanent, first), as a bare permanent chill is** |
| anything else | stripped | unchanged |

The end of a Rupture by the rite logs as a cleanse — `→ Rupture ends on Orc Raider — a cleanse: its Chilled is lifted; Burn
stands alone (3 turns)` — through `remove_status`'s new optional `why` (default `"a consumer"`; the rite is its one other
caller), and the rite's own line names the chill inside: `→ Cleansing Rite thaws one stack of the Chilled inside Orc Raider's
Rupture (x1 remains)`. **A generic cleanse — Dispel One, a purge, the Cleansing Draught — still takes a Rupture whole** (HS
§2f), and `check_ht` §1 drives that negative beside the positive arms.

**The reasoning, recorded where the rule lives** (`CLAUDE.md`, the `battle.gd` branch, `docs/design-notes.md`): letting the rite
take a Rupture whole would overturn Batch V for precisely the targets a player spent two turns assembling — one enemy ability
deleting the best play in the game.

**One reading was this batch's call, and it is priced so it can be flipped (NEEDS A RULING).** "Exactly as on a bare chill" is
read as rank AND thaw: a candidate carrying a chill ranks by the chill's own clock (`battle._rite_turns_left`). The other
reading ranks a composition by its own clock, the shorter ingredient's: it is the smaller change, and it differs only where the
chill outlasts the Burn — chiefly a Glacial Hold's permanent chill, which would rank by the Burn beside it and could lose the
rite's pick to a longer debuff (an Exposed of 4 against a Burn of 3, driven at `check_ht` §1), so the rite would strip that
debuff where a bare permanent chill would have lost a stack.

**Does any other ability reach a status through a generic cleanse door where it means a specific id?** Derived over every
caller of the four doors — `dispel_one_debuff` (On the Mend, Cleansing Waters, the *Cleanse Debuffs Each Turn* talent and the
Field Medic crest field, the Rune of the Medic's mend, Dispel's hero half three times, Field Dressing), `purge_debuffs` /
`purge_debuffs_taken` (Unburden with Returned Burden, Cull, Harvest, the Empowered heal, the Empowered Divine Plea),
`_cleansable_debuffs` (the rite and the warband's trigger for it, the Cleansing Draught and its button's greying, two
hero-bot predicates) and `_dispellable_buffs` (Dispel's enemy half,
which takes only what is not in `DEBUFF_IDS`): **only the rite reads a specific id after the door.** Its `chilled` read is the
one this ruling fixed. **Its second is the same shape and harmless today**: a stripped `ruin` also takes `ruin_primed` — correct
while Ruin is no composition's ingredient, and the batch that authors Reckoning (Ruin + Broken) owes it the lookup, as HS
§2 found `log_bleed_chip` and `set_ruin_stacks` owe it for Contagion and Reckoning. Returned Burden reads each entry's id
after the purge, over the flattened ingredients (HS §2f), so it casts a Burn and a Chilled, never a bare composed id.

### §1c — RULING 6: DEGREE ON SCREEN, TIER IN THE CODE, BUILT

**Every surface, derived rather than taken from the brief's list** — every literal of the composition machinery, the glossary,
`master.html` and the screens' readers of a composition's words:

| surface | before | since HT |
|---|---|---|
| the chip's tooltip (`BattleUnit._resync_composition`) | *Burn + Chilled, joined (tier 2).* | *Burn + Chilled, joined (second degree).* |
| the log's forming line (`battle._conjoin`) | *— tier 2, 2 turns (the Burn's, the shorter)* | *— second degree, 2 turns (the Burn's, the shorter)* |
| the glossary's *Conjunctions* | *TIER TWO … TIER THREE, and each tier is stronger* | *SECOND-DEGREE … THIRD-DEGREE, and each degree is stronger* |
| the glossary's *Rupture* | *a Conjunction of tier two* | *a second-degree Conjunction* |
| `master.html` §4.6's Rupture row | *(a conjunction, tier 2; chip Ru)* | *(a second-degree conjunction; chip Ru)* |
| `master.html`'s CONJUNCTIONS block | *tier 2 / tier 3*, *counts a tier-2 as two*, *its tier* | *second-degree / third-degree … Rupture is a second-degree affliction*, *counts a second-degree one as two*, *its degree* |

The brief's list was right and whole: no other screen, label or log line names a conjunction's tier. **The ordinal comes off
the tier at render time** (`BattleUnit.tier_ordinal`: first, second, third), so it cannot drift from the recipe. **The
identifiers are unmoved** — `tier_of`, `composition_turns`, every variable — HL §2's split, and `check_ht` §2 asserts both
halves: no player surface says tier of a conjunction, and no code token names a degree.

**Where *degree* collides — the BR §1 sweep over `check_hp` §2f's fourteen populations, 1,026 names** (HS's figure, re-read):
**no name in the game is *degree* or near it.** The one other use in the tree is `master.html`'s map-generation section,
*Measured out-degree: 59% one …* — a graph term in a document no player reads — reported, not changed.

## §2 — THE CENSUS: EVERY STATUS A HERO CAN LAY ON AN ENEMY

**AUTHOR NOTHING, BUILD NOTHING, MEASURE.** Every claim below was read at its code line — the work was split four ways by
status family and each family's load-bearing claims were checked again at the code before they were written here (§5b says
which); two of them, both Downwind's, were driven. **It proposes nothing.**

### §2a — THE POPULATION, DERIVED

**Every status a hero can lay on an enemy**, taken from every `_apply_status` call in `battle.gd` (211 literal sites over 137
ids, and the nine variable-id routes), every direct `add_status` write, the data's `applies_status` (15 cards) and the meters
that keep a chip — each site read for whether its target can be an enemy and its source a hero, his card, rune, item,
companion or engine. **Forty-four statuses, today.**

- **Burn, Chilled and Frozen are three of them** — HR §4a, §4c and §4f, not redone (their rows are HR's).
- **Three more have hero-side appliers that are all DORMANT** — the fields that would lay them are written by no talent node
  and no live rune: **Caught Fast** (`caught_fast`), **Decay** (`emp_hex_ranks`, `torment_ranks`) and **Melted Armor**
  (`melt_ranks`). They are listed (§2c) and not counted.
- **Rupture is formed, not laid** (HS) — a conjunction of two of the forty-four.
- **Out of the population, each for a stated reason**: High Guard (laid on whoever parries — and its field has no writer), Ward
  (a heal's Perfect that no card carries), Roar (on the bear), and the ally-side statuses (Sanctified, Covering Guard, Vespers,
  Vigil, Zeal, Vow, Rite of Return, Unburdened, Renewal, Immolate, Shielded, Charging).
- **No status reaches an enemy ONLY through a carrier.** Downwind, Returned Burden, Frostbind's mate and Rime's echo carry what a
  hero already lays; what only a carrier makes is a STATE (§2f), not an id.
- **Not every class reaches every status** — the by-class table is the column the design needs most:

### §2b — BY CLASS: WHAT EACH HERO CAN LAY ON AN ENEMY

*No engine* is the kit, the basic, the merged draft pool and his lineages' boss pools; *with an engine* names the core rune. Any
hero can use the **Cursed Visage** (Hexed), and a Hunter's **Downwind** copies any hero's affliction onto a second enemy.

| class | with no engine | only with an engine |
|---|---|---|
| **Warrior** | **Sunder** (Crushing Blow — kit), **Stunned** (Pommel Strike — kit; Counter Time), **Mocked** (Mocking Blow — kit; Eye of the Storm, Vendetta), **Dazed** (Sweeping Strikes; Charge's is inert), **Bleed** (Wildstrikes, Hack and Slash, Rampage, Gut Rip), **Feinted**, **Blood Debt**, **Vendetta** | **Cripple** and **Exposed** (Lunge, by guard — the Stances) |
| **Mage** | **Burn**, **Chilled** and an ordinary **Frozen** (HR §4a), **Elemental Weakness** (Magic Burst — kit), **Arcane Echo**, **Frostbind**, **Frostbite** and **Rime** (Rime), **Slow Burn** | **Unmaking** (Resonance); the Glacial **Hold** and Razor Ice (Glacial Hold); Burn's engine readers (Overburn) |
| **Cleric** | **Psychosis** (Mind Flay), **Bewitched**, **Mass Hysteria**, **Umbral Sigil**, **Breaking Darkness**, **Penance**, **Blighted**, **Cripple** (Shadowrend); Suffering and Covenant of Ash land and pay nothing; Dazed and Sunder through the bewitched and the hysteric's own blows; Returned Burden sends an enemy's statuses back | **Ruin** and its primer, **Exposed** (Hex of Ruin) — Old Gods; **Judged** — the Arbiter |
| **Hunter** | **Poison** (Snare Trap — kit; Explosive Shot, Loaded Shot, Stalking Horse), **Snared** and **Stunned** (Snare Trap — kit; Snare Line, Deadfall, Aper), **Snare Line**, **Hunter's Mark**, **Marked** (its companion half), **Mocked**, **Dazed**, **Exposed** and **Blind** through the pet (Ursus, Aguila), **Bleed** (Canis; Kill Command, Savage Sweep), **Cripple**, **Slowed**, **Heads Down**, **Blind** (Choking Smoke), **Burn** (Choking Smoke) | **Quarry** and **Reacquire**, Called Shot's Sunder and Exposed, Pinning Shot's Daze — Lethal Aim (which dismisses the pet and every status it lays); the barb's, Venom Coating's and Shrapnel Charge's Poison, Hamstring's Slow and Exposed, the Second Barb — Trapper; **Tracked** — the Tracker; Marked's hunter half — Pack Bond |

### §2c — THE TABLE: FIVE COLUMNS, EVERY STATUS

HR's five columns. *Generic* readers — what a status in `DEBUFF_IDS` feeds just by standing — are the same for every one and
are not repeated per row: the breadth count (`_status_count` → the Trapper engine's +8% a distinct affliction, Hunt, Thick
Hide, Cull and Harvest, Salve's field walk), Loaded Shot's refresh to full, Firedraw's other-spec test, Downwind, the Rune of
the Medic's mend, Sanctity's events, and the enemy mender's rite (which ranks a battle-long status 999 and takes it first);
a Mage's Dispel never takes one. **A mark** (`DISPEL_NEVER`, not in `DEBUFF_IDS`) feeds none of those: no breadth, no cleanse,
no carrier — only Sanctity sees it.

| status (chip) | who lays it on an enemy, by class | what reads it | re-application | duration · what it does | `DEBUFF_IDS` |
|---|---|---|---|---|---|
| **Sunder** (D) | **Warrior**: Crushing Blow (kit); the Rending Blows rune deepens it on a Crushing Blow to depth 3. **Hunter with Lethal Aim**: Called Shot. **Cleric**: Mass Hysteria's strike (the hysteric's own blow carries it — an enemy source). Enemies lay it on heroes (Raider, Ash Tyrant, Hollow Crown) | `effective_armor`: −35% armor a depth (`SUNDER_STEP`), every armor read; Rending Blows; the bots | default — a plain Sunder never lowers a deepened one; Rending Blows raises the depth | 3 turns (Called Shot 2) | yes |
| **Stunned** (St) | **Warrior**: Pommel Strike (kit — a Perfect passes `force` past an unbroken boss), Counter Time (draft, Defensive guard). **Hunter**: Snare Trap's spring (kit), Snare Line's spring (draft), Deadfall (Survivalist's boss pool), Aper every third strike (the Tusk and Bristle rune) | the turn loop: the bearer loses its next turn, a wind-up is cancelled, its intent discarded; the Opportunist rune (Powershot ×2); Counter Time's recast gate | default — moot: **the turn loop strips it whole at the first lost turn**, so every stun costs exactly one turn whatever its count | 1 (Counter Time 2, Snare Line's on a chilled body 2 — both pay one) | yes — **boss-immune until Broken**; Ironclad refuses it (hero-side) |
| **Dazed** (Dz) | **Warrior**: Charge (draft — 1 turn, so inert), Sweeping Strikes (Swordmaster's boss pool). **Hunter**: Aguila's arrival dive, Stalking Horse (draft); with **Lethal Aim**, Pinning Shot's Daze half; with **Trapper**, the Second Barb. **Cleric**: Bewitch's charmed strike (no source). Enemies: Withered Warden, Hollow Crown | `_miss_chance`: +20% miss on the bearer's single-target and per-strike attacks (area attacks never roll) | default | 1–3 turns — N turns cover N−1 of the bearer's own attacks | yes; Ironclad refuses it (hero-side) |
| **Mocked** (M!) | **Warrior**: Mocking Blow (kit), Eye of the Storm, Vendetta (draft — battle-long). **Hunter**: Ursus's Guardian's Roar (the pet), Bestial Wrath (Beastmaster's boss pool) | the enemy AI at declaration: its target is narrowed to the taunter and it takes no support action; the Goading Roar rune (−25% from a bound enemy); Eye of the Storm's cut | default — **its power is the taunter's seat, so the higher seat wins**, a companion taunt (100+) beats every hero's, and a timed taunt meeting Vendetta's battle-long one leaves it timed | 2–5 turns; Vendetta battle-long | yes |
| **Bleed** (Bl&lt;n&gt;) | **a buildup METER, not a door status**. **Warrior**: Wildstrikes, Hack and Slash (+ the Butcher's Bill rune), Rampage, Gut Rip (draft; Rampage also the Berserker's boss pool). **Hunter**: Canis's strikes and Bloodhowl (the pet), Kill Command, Savage Sweep (draft), Bestial Wrath (boss). **Every class, both sides**: the Bloodletting bargain | the bleedout at 100 (20% of maximum health, no armor), Blood Debt's mark, the Slaughterhouse rune (Blood Frenzy), Battle Shout's bonus, Gut Rip's consumption; the breadth readers count its chip | **no clock and no re-application rule**: every builder ADDS, 100 bursts and resets, overflow is lost | none — a meter | yes (its chip) |
| **Cripple** (C) | **Cleric**: Shadowrend (draft). **Hunter**: Shrapnel Charge, Bola, Stalking Horse (draft), Hamstring (Survivalist's boss pool). **Warrior with the Stances**: Lunge from the Defensive guard. Enemies: Wolfrider, Grave Totem | the strike loop: the bearer's blows ×0.75; a crippled companion's too | default | 2–4 turns | yes |
| **Exposed** (E) | **Cleric with Old Gods**: Hex of Ruin (its enabler). **Hunter**: Aguila's strikes (the pet), Stalking Horse; with **Trapper**, Hamstring's half; with **Lethal Aim**, Called Shot. **Warrior with the Stances**: Lunge from the Aggressive guard. Enemies: Hexer | the strike loop only: +15% damage taken (companions, traps, ticks and self-computing cards never read it) | default | 2–4 turns | yes |
| **Slowed** (Sl) | **Hunter**: Bola, Stalking Horse (draft), Pinning Shot (Sharpshooter's boss pool); with **Trapper**, Hamstring's and Shrapnel Charge's Perfect halves. Enemies: Bog Troll | `effective_speed` ×0.75 — every later gap | default | 3–4 turns | yes |
| **Snared** (Sn) | **Hunter**: Snare Trap (kit) — one standing trap at a time | the turn loop: it springs at the bearer's next turn start — a Stun and Poison 4 | default | until it springs | yes — the rite takes it first (battle-long) |
| **Heads Down** (HD) | **Hunter**: Heads Down (draft) | `_intent_ability_usable`: the bearer is held to its basic attack | default | 3 turns (4 Perfect) | yes |
| **Blind** (Bd) | **Hunter**: Choking Smoke (draft — every enemy), Kill Command (Aguila's), Stalking Horse, the Second Barb; Bestial Wrath's eagle (boss) | `_miss_chance`: +50% miss on the bearer's single-target and per-strike attacks | default | 2–3 turns | yes |
| **Caught Fast** (Cf) | **no live applier** — the trap rider's `caught_fast` field has no writer | `heal_amount`: it cannot be healed | default | — | yes |
| **Poison** (P) | **Hunter**: Snare Trap (kit — its spring lays it a turn later), Explosive Shot (Survivalist's boss pool), Loaded Shot's Perfect, Stalking Horse (draft); with **Trapper**: the barb when he is struck, Venom Coating, Shrapnel Charge's poison, the Second Barb rune. **Cleric**: Returned Burden re-casts an enemy's poison lifted off an ally. Long Poison (rune) makes it permanent on the `_apply_poison` routes; Thin Blood (rune, Trapper) zeroes its tick. Enemies lay it on heroes (Archer, Behemoth, Withered Warden, Hollow Crown) | the DoT pass (a tick × stacks × nature resist; its first tick skipped); the breadth readers; Salve; the cleanses; Loaded Shot's refresh to full; Downwind; the Rune of the Medic's mend; the hero-side cleanses and Iron Will when it is a hero's | **its own branch**: +1 stack, the clock SET to the new application's turns (it can shorten, and it can end a permanent one), the tick replaced only by a larger one | 2–5 turns by applier, N turns giving N−1 ticks; a tick is 3% of the applier's Attack a stack | yes |
| **Quarry** (Qy) | **Hunter with Lethal Aim**: Quarry's Mark | the Sharpshooter's Focus: a consecutive attack on the marked enemy doubles the Focus gain | none in practice — each cast clears it everywhere and lays one | battle-long | no (a mark; `DISPEL_NEVER`) |
| **Snare Line** (SL) | **Hunter**: Snare Line (draft) — every enemy | the turn loop: it springs at the bearer's next turn start — 20% of the Hunter's Attack in nature and a Stun (two turns on a chilled bearer) | default | 2 turns, spent by its spring | no (a mark) |
| **Marked** (Mk, Mark of the Hunt) | **Hunter**: Mark of the Hunt (the Beastmaster's boss pool); its hunter half pays only with **Pack Bond** (HF §7) | the strike loop (+25% from the marking hunter, Pack Bond only, and +3% max resource a strike), the companion's blow (+25%, +3% Mana); the cooldown reset on the bearer's death — **dead code** (§2f) | default | 7 turns | no (a mark) |
| **Hunter's Mark** (HM) | **Hunter**: Hunter's Mark (draft) — one at a time | `_party_mark_mult`: +15% from every hero's strike and every companion's blow | default | 6 turns | no (a mark) |
| **Reacquire** (Rq) | **Hunter with Lethal Aim**: Reacquire | the Focus meter: leaving the mark banks it, coming back restores it | none in practice | battle-long; +25 Focus a cast | no (a mark) |
| **Tracked** (Tr) | **Hunter with the Tracker engine** (`quarry_hunt`): laid on the first enemy he damages, moved on its death | `_quarry_mult`: +25% from every hero's strike and every companion's blow | default | battle-long | no (a mark) |
| **Judged** (Jd) | **Cleric with the Arbiter engine** (`judgment`): as Tracked | every damage event a hero-side dealer lands on it heals every living ally 5% of it | default | battle-long | no (a mark) |
| **Covenant of Ash** (CA) | **Cleric**: Covenant of Ash (draft) — pays nothing without an **Old Gods** holder | `_gain_ruin`: every Ruin stack on another enemy lands on the bearer too | none in practice (one at a time) | battle-long; 2 Ruin on the cast | no (a mark) |
| **Feinted** (Fn) | **Warrior**: Feint (draft), from the Aggressive guard (so on alternate casts) | the enemy's turn: its next declared attack on a hero is turned on a fellow, and the mark is spent | default | until spent | no (a mark) |
| **Blood Debt** (BD!) | **Warrior**: Blood Debt (draft) | each bleedout of the bearer heals the hero who laid it 25% (35% Perfect) of his maximum — **not the bleedout that kills it** (§2f) | default, plus a clamp: never written down | battle-long | no (a mark) |
| **Vendetta** (Vd) | **Warrior**: Vendetta (draft), with its taunt (Mocked) | the strike loop: the sworn hero takes 30% less from the bearer | default | battle-long | no (a mark) |
| **Elemental Weakness** (EW) | **Mage**: Magic Burst (kit); the Unravel rune spreads it to every other enemy | the strike loop alone: −15 points of every non-physical resistance; the Seeking Missiles rune; the bot | `_apply_elem_weak`: never written down | 3 turns | yes |
| **Hexed** (Hx) | **Any hero**: the Cursed Visage (item) — every enemy | the strike loop: the bearer's blows ×0.85 | default | battle-long | yes |
| **Arcane Echo** (AE) | **Mage**: Arcane Echo (draft) — one at a time | every landed strike-loop hit echoes 30% onto it (arcane resist, no Break) | default | 3 turns (4 Perfect) | no (a mark) |
| **Unmaking** (Um) | **Mage with Resonance**: Unmaking | `heal_amount`: it cannot be healed | default | 3 turns (4 Perfect) | yes |
| **Ruin** (R1…) | **Cleric with Old Gods** — every Ruin write needs a living holder: the Old Gods mark on his data-status cards (Hex of Ruin, Mind Flay, Shadowrend), Bewitch, Blight the Well, Covenant of Ash, Suffering's drip, Anointing's (any hero's hits), Transference, the Open Wound, Shared Ruin and Wide Rite runes; **Hunter**: Downwind carries it | +2% damage taken a stack, the heroes' leech (capped 40%, Standing Mark +20), the primer every 10th stack (8 with Deepening Hex), Requiem, Transference, the Open Wound's wear, the button gates, the bots; the rite (it takes the primer too) | **its own branch**: +1 stack, permanence kept; `set_ruin_stacks` writes around the door | battle-long | yes |
| **Ruin (primed)** (R!) | the Old Gods engine's arming, off any Ruin that crosses the threshold through `_gain_ruin` | the detonation at the bearer's next turn start (90% of the Occultist's Attack in shadow, the heroes healed 25% of his maximum), Shared Ruin | never re-applied while it stands | until it detonates | no (`DISPEL_NEVER`) |
| **Psychosis** (Py) | **Cleric**: Mind Flay (draft, the Occultist's boss pool) | the enemy's turn: half its turns hijacked (a heal or ward for the heroes, or a blow on a fellow); the bot | default | 3 turns (4 Perfect) | yes — **boss-immune until Broken** |
| **Bewitched** (Bw) | **Cleric**: Bewitch (draft) | the enemy's turn: it strikes a fellow (Dazed 2 and a Ruin on a survivor) | default | 3 turns | yes — **boss-immune until Broken** |
| **Mass Hysteria** (MH) | **Cleric**: Mass Hysteria (draft, the Occultist's boss pool) — every enemy | the enemy's next turn: one blow on a fellow at double Break, Sunder 3 | default (a recast gate) | until the bearer acts | yes — **boss-immune until Broken** |
| **Umbral Sigil** (US) | **Cleric**: Umbral Sigil (the Occultist's boss pool) | the strike loop: damage the bearer takes echoes 50% onto every other enemy | default (a recast gate) | 4 turns | yes |
| **Breaking Darkness** (Dk!) | **Cleric**: Breaking Darkness (draft) | `take_hit`: +25% to every source of Break on the bearer — Rupture's included | default | 3 turns (4 Perfect) | yes |
| **Penance** (Pn) | **Cleric**: Penance (draft) | the damage door: the bearer takes 50% of the health it takes from anyone, as shadow | default (a recast gate) | 4 turns | yes |
| **Suffering** (Sf) | **Cleric**: Suffering (draft) — pays nothing without **Old Gods** | its turn-start drip of 2–3 Ruin (+1 if cast on a Broken body) | default | 4 turns | yes |
| **Blighted** (Bl) | **Cleric**: Blight the Well (draft) | `heal_amount`: a heal on the bearer becomes that much damage | default | 6 turns | yes |
| **Frostbind** (Fb) | **Mage**: Frostbind (draft) — two bodies | a Chilled landing on either lands on the other; 40% of the health one loses is dealt to the other; a held pair is one hold cell | default; a recast re-points the bond | 4 turns | yes |
| **Frostbite** (Fb) | **Mage**: Rime (draft, the Cryomancer's boss pool) | `heal_amount`: healing received ×0.5 | default | 2 turns | yes |
| **Rime** (Ri) | **Mage**: Rime | every Chilled taking hold on the bearer echoes a 3-turn Chilled onto another enemy | default | 4 turns | no (`DISPEL_NEVER`; its tag is DEBUFF) |
| **Slow Burn** (SB) | **Mage**: Slow Burn (draft) — every enemy | `tick_statuses`: the bearer's Burn does not count down (the Burn inside a Rupture too) | default | 4 turns | yes |
| **Burn** · **Chilled** · **Frozen** | HR §4a | HR §4c | **Burn and Chilled have their own branches** (§2d); Frozen through `_hold_freeze` | HR §4f | yes |
| **Decay** (Dc) — dormant | the Empowered Hex and Lingering Torment fields — no writer | the turn start: 10 Break | default | — | yes |
| **Melted Armor** — dormant | a Burn-tick rider, `melt_ranks` — no writer | the `melted` FIELD (−armor); the chip is display | — | — | yes |

### §2d — EVERY STATUS WITH A RULE OF ITS OWN WHEN IT LANDS AGAIN

A conjunction's half runs its own rule (HS §2g), so this is the list a half must be checked against. **The DEFAULT** —
`unit.add_status`'s `max()` of turns and of power — is every status not named here.

| status | its rule | where |
|---|---|---|
| **Burn** | its turns ADD; the tick is the newest applier's | `add_status` |
| **Chilled** | +1 stack (cap four; the Deep Cold rune lifts it) and the clock RESET; four stacks freeze | `add_status`; `_apply_status`'s freeze; `set_chilled_stacks` writes around the door |
| **Poison** | +1 stack and the clock SET to the new application's turns — so it can SHORTEN, and a positive application ends a permanent one; the tick replaced only by a larger one | `add_status`; `_apply_poison` stamps sticky and full on its own routes |
| **Ruin** | +1 stack, permanence kept; the primer arms only inside `_gain_ruin`'s one-stack loop | `add_status`; `_gain_ruin`; `set_ruin_stacks` writes around the door |
| **Elemental Weakness** | never written down: the larger power and turns stand | `_apply_elem_weak` |
| **Sunder** | default, but its power is a DEPTH, and Rending Blows raises it through `update_status` | `add_status`; the Crushing Blow rider |
| **Mocked** | default, but its power is the TAUNTER'S SEAT — the higher seat wins, a companion's beats a hero's, and a timed taunt makes Vendetta's battle-long one timed | `add_status` |
| **Stunned** | default, but the turn loop removes it whole at the first lost turn, so its length never matters | the turn loop |
| **Blood Debt** | default, plus a clamp: never written down | the Blood Debt rider |
| **Frostbind** | default; a recast re-points the bond, and an old partner's bond can be left one-way | the Frostbind arm |
| **Frozen** | a Glacial Hold holder's freeze is a HOLD — off the timeline, registered in `_holds`, one at a time | `_hold_freeze` |
| **Bleed** | a meter: every builder adds, 100 bursts and resets, overflow lost | `add_bleed` |
| **Broken** | a meter state: never re-applied while it stands (§2e) | `take_hit` |
| **Ruin (primed)** · **Hysteria** · **Snared** · **Feinted** | never re-laid while one stands, or spent by what reads it | their readers |

### §2e — THE STRUCTURAL QUESTION: CAN A METER STATE BE A COMPOSITION HALF?

**What Broken is, at the code** (driven at `check_ht` §4). A Break is a FIELD STATE: `unit.take_hit` sets `broken`,
`broken_pending` and `pressure = stability`, and **then writes a chip** — `add_status("broken", "BROKEN", "B", …, 1, …)`,
straight into `statuses`, around the status door. So the brief's *"no entry"* is half right: **Broken has an entry, and the
entry is a display of three fields.** Its turn count is 1 and nothing moves it (`tick_statuses` skips the id; the expiry
filter keeps it). It ends at the bearer's next turn — the turn it loses — when the turn loop calls `recover_from_break()`
(pressure back to 0, or 50 under Guard Breaker; `remove_status("broken")`), or one turn later for each `broken_extra_turns`
Overpower adds; a companion recovers in its own tick. It has no `src`: no applier is ever stamped on it, because no hero
applies it — a blow's Break, a tick's Break (Decay, Rupture's rider) or a card's (Breaking Darkness amplifies the take)
fills a meter, and the meter breaks.

**Who reads it, and how.** **Every one of the chip's thirteen readers is an EXCLUSION** — the three cleanse doors
(`dispel_one_debuff`, `purge_debuffs_taken`, `_cleansable_debuffs`), the breadth count (`_status_count`), Harvest and its
yield, Loaded Shot, Firedraw's other-spec test, Downwind and the Rune of the Medic's predicate, the clock (twice), the chip's
tooltip (no turns shown) — and the recovery's `remove_status` is the one write. **The game reads the FLAG, not the chip**:
`u.broken` is read at 36 lines of `battle.gd` (the −30% armor and +25% crit taken, Execute and Kill What Is Down, Sever,
the Rupture tick's no-Break line, the boss immunity that lifts once a boss is Broken) and `broken_pending` costs
the turn. **One generic reader does not exclude it**: `count_debuffs`, the talent *Mitigation per Debuff You Carry*'s count
(`tn_iron_will`, live) — a Broken hero carrying the node takes 12% less damage for being Broken, where the breadth count
excludes Broken by rule. Reported (§2f), not changed: it is a magnitude.

**What it would cost for `CONJUNCTIONS` to accept Broken as a half** — Marrowfire (Broken + Burn) and Reckoning (Ruin +
Broken) as designed. Each item is a cost the table's present machinery charges; none is a proposal.

1. **The door.** `_conjoin` runs inside `_apply_status` alone (HS §2b), and Broken is written in `unit.take_hit`, which the
   battle cannot see. A conjunction with a Broken half needs the meter to call back into the battle at the break (`died_cb`'s
   shape — a `broke_cb`), so the door is two doors.
2. **Who made it.** A composition carries `src_name` — whoever's arrival made it (the forming line names them, and Rupture's
   Break is credited to them). A Break has no applier: the battle knows the striker of a blow through the attribution frame,
   a tick's Break through its own `src_name`, and `take_hit` knows neither. Crediting a Marrowfire needs the breaker read off
   the frame at the callback.
3. **The clock — what *the shorter* means when one half has none.** `composition_turns` would read Broken's frozen 1 as a
   one-turn clock that never counts down: the chip would say *1 turn* for as long as it stood, and the clock could never end
   it (an ingredient ends by the clock only when its turns reach 0). **So the composition's real end is the recovery, which is
   a REMOVAL, not a clock** — three readings, each a ruling: (a) Broken's window is the clock (one lost turn, plus Overpower's):
   then the shorter is almost always Broken's, and every Marrowfire is a one-turn window that the Burn ticks into at most once
   — the DoT pass runs at the turn start, before the lost turn's recovery; (b) Broken counts as endless, as a permanent chill
   does, and the Burn's clock governs — but the recovery still dissolves it first; (c) the composition's clock is the
   ingredient that HAS one, and Broken's end is treated as a consumer. All three end it at the same moment in play; they
   differ in what the chip says and in what *the shorter* means on screen.
4. **What `_dissolve` does when the Break bar refills.** `recover_from_break()` → `remove_status("broken")` →
   `composition_of("broken")` finds it → `_dissolve(…, ["broken"], "a consumer")`: the Burn stands alone with its turns, which
   is the survivor rule working — **but the line reads *Marrowfire ends on X — a consumer: its BROKEN is consumed* (the chip's
   all-caps label, and a cause that is false: nothing consumed it, the meter refilled)**, and a Sanctity removal event is booked
   (as the recovery books one today). A fourth cause (*the meter refilled*) and a label off `STATUS_INFO` rather than the chip.
5. **The cleanses would desync the state from its chip.** A composition with a Broken half is one `DEBUFF_IDS` entry with its
   own id, so every top-level guard — `id != "broken"` in Dispel One, the purge and `_cleansable_debuffs` — lets it through:
   **Dispel One, a purge or the rite would lift the chip while `broken`, `broken_pending` and the pressure stay** — a body still
   Broken with no chip — and **Returned Burden would cast the Broken ingredient onto an enemy through `_apply_status`, a chip
   with no meter state behind it.** The guards must read through a composition (HS's `_is_sticky` shape: a composition holding
   Broken refuses a cleanse whole) or a cleanse must split it.
6. **Re-application has nothing to run.** Broken is never re-applied while it stands (`take_hit` adds no Break to a Broken
   body), so a Broken half has no branch of its own (§2d); Overpower's extension is a field, not a write the door could see.
7. **The readers would not see it differently.** Presence gives `has_status("broken")` the chip inside — but the game reads
   the flag, so presence buys nothing for the 36 flag reads and costs nothing either; the thirteen exclusions would each need
   to read through a composition to go on excluding.
8. **It is symmetric.** Heroes Break too, so the rule (one body) makes a hero Marrowfire under any enemy Burn — the Ashblade's
   and the Tyrant's — reachable far more often than a hero Rupture, because no Hoarfrost bargain is needed.

**And Broken is not the only meter a designed conjunction names: Bleed is one too.** Its chip is written by
`unit.log_bleed_chip` straight into `statuses` — turns −1, no `src` — around the door, and no builder sends Bleed through
`_apply_status` (Returned Burden's comment says why it cannot: the door's table has no bleed). So **Contagion (Poison + Bleed)
meets items 1, 2 and 5 as Marrowfire does** — and item 5's desync is already live for Bleed alone: a purge takes its chip and
leaves its meter (§2f). Its clock question is simpler: the meter has none, so *the shorter* is always the Poison's, and a
bleedout — which empties the meter and calls `remove_status("bleed")` — would end a Contagion as *a consumer*. **Of the four
designed conjunctions, three have a meter half; Seize (Chilled + Cripple) alone is two statuses the door can see.**

**The alternative, asked plainly: which statuses a WARRIOR can lay that could be a half instead.** **The answer is not
none.** A Warrior holding no engine lays three from his own kit — **Sunder** (Crushing Blow), **Stunned** (Pommel Strike) and
**Mocked** (Mocking Blow; a taunt, its power a hero's seat, not a magnitude) — driven at `check_ht` §4, and more from his
pool and his lineages' boss pools (the by-class table, §2b). **The Warrior's seat at the conjunction table is a status, and
Broken is not the only currency he has**; Broken is the one every class can fill and only a meter can hold.

**The answers, and nothing proposed.** A meter state CAN be made a half — the costs are the eight above, of which 1, 2, 4 and 5
are machinery and 3 is a ruling — or a Warrior's half can be one of the statuses he already lays. The second conjunction,
its halves and its class pair are the designer's.

### §2f — WHAT THE CENSUS FOUND, AND DID NOT FIX

**None of it is touched here** — §2 builds nothing — and each item is routed to `docs/state.md`'s queue. **The two Downwind
items break standing rules and are the ones NEEDS A RULING asks about.**

**Driven (`downwind.out`, an isolated copy):**
- **DOWNWIND COPIES A GLACIAL HOLD AS AN UNMANAGED, PERMANENT FREEZE.** `_hold_freeze` lays the hold's Frozen through the status
  door with the Cryomancer as its source, and Downwind copies any hero's affliction: a real hold on one Raider put a battle-long
  Frozen on the second — **not in `_holds`, still on the timeline, still frozen after five ticks**, with no limit, no charge and
  no release (Ice Lance and Shatter release holds; this is not one). With the Carrion rune, every other enemy. **It breaks *he
  holds ONE enemy*.** Only an enemy mender's rite or death ends it.
- **DOWNWIND FORWARDS `force`, SO A PERFECT POMMEL STRIKE'S COPY STUNS AN UNBROKEN BOSS.** The copy reuses the original's
  arguments; with `force` the boss took the Stun, without it the boss resisted. **It breaks *hard control lands on a boss only
  once it is Broken*** beyond the one card the rule sanctions.

**Read at the code (each verified at its line):**
- **Card text the code does not pay.** Mark of the Hunt's *the cooldown resets if the marked enemy dies* — its one read runs
  after `_die()` has cleared the body, so it never fires. Counter Time's *loses its next TWO turns* and Snare Line's chilled
  *two-turn* stun — the turn loop removes a stun whole at the first lost turn, so each costs one. Charge's *DAZED for a turn* — a
  one-turn Daze ticks out before the bearer acts — and its Perfect, *Dazed for 2 turns*, is implemented nowhere. Blood Debt's
  *every time it bleeds out* — the bleedout that kills the bearer pays nothing. Thin Blood's price, *his Poison deals no damage* —
  a zero tick reads as "no tick set" in the DoT pass and deals the legacy 3 a stack. Pinning Shot, Called Shot, Hamstring and
  Shrapnel Charge pay part of their text only to an engine holder (GM §1's open shape, already queued).
- **Rules that meet badly.** A re-applied Poison SETS its clock (it can shorten, and a timed one ends a permanent Long Poison).
  A fresh Poison skips its first tick, so N turns deal N−1 ticks. A purge takes Bleed's chip and leaves its meter, so Cull and
  Harvest are paid for a bleed that stays. Downwind copies Ruin a stack at a time without arming, so a copy that lands a body on
  a multiple of the threshold skips that detonation; a primed body emptied of Ruin still detonates in full. Downwind's other bare
  copies: a partner-less Frostbind, a poison missing `_apply_poison`'s stamps, a second permanent taunt off Vendetta, a second
  spring off Snare Trap. The talent *Mitigation per Debuff You Carry* counts Broken (§2e). Frostbind finds its partner by name,
  so two same-named enemies can bind wrongly. Two chips share a tag twice over: **Fb** (Frostbind, Frostbite) and **Bl**
  (Blighted, Bleed's *Bl&lt;n&gt;*).
- **Text that has gone stale** (no number moved): Ruin's row and chip (*does not wear off*, *every 10th stack*) are false under
  the Open Wound and Deepening Hex runes; the primer's *when this unit next acts* (it is the next turn start); Poison's *3 nature
  damage per stack* (3% of the applier's Attack) and *new stacks refresh the timer* (they set it); Rime's *every stack* (every
  application); `VENDETTA_CUT` (20%) is read by nothing — Vendetta is always 30%, as its card says; comments that rely on the
  dormant Whole Room, call Bewitch's Daze the Occultist's, describe Lingering Torment as live, or name deleted talent nodes.
- **Dormant appliers** (a field no talent node and no live rune writes), kept on ET's contract: Caught Fast, Decay, Melted
  Armor, The Whole Room, Ruined Mind, Umbral Mirror, Exposed Nerve, Judgement, Vengeful Guardian, Ricochet, Provoke, Quick
  Rigging, Coated Blades, Hemorrhage, Lunge's both wounds, Icy Resolve, Delirium, Spread of Madness, Unraveling, and the poison
  family (Perfected Toxin, Slow Acting, Distillate, Potent Toxins, Cocktail). **Dead code**, kept: the *Shrapnel* and *Poisoned
  Arrow* name branches (no card has either name), the `rampage` special arm and its row, the `sunder` Perfect arm, the companions'
  `boosted` arms, `_spring_trap`'s `force_stun` argument.

## §3 — TWO NAMES RECORDED, AND `master.html`'S STALE ROWS

### §3a — CONTAGION AND MARROWFIRE, SWEPT

Replaced in the record (`docs/state.md`'s designed list, `CLAUDE.md`'s conjunction block, the `battle.gd` comment above
`CONJUNCTIONS`), **not built**: `CONJUNCTIONS` keeps its one row and no status carries either id (`check_ht` §3).

| name | was | exact | near-misses (BR §1, 1,026 names in 14 populations) |
|---|---|---|---|
| **Contagion** (Poison + Bleed) | *Blight* — the live `blight` status | none | **none in the names — but it meets a standing rule** (below) |
| **Marrowfire** (Broken + Burn) | *Breach* — near the BREAK tag and the Break nodes | none | **four, by containment**: the glossary's term *Fire* and the rune *Chain Fire* (the word *fire*), and the enemy abilities *Arrow Shot* and *Poison Arrow* (*arrow* sits inside *marrowfire*) |

**Contagion collides with `CLAUDE.md`'s THE CONTAGION SPACE IS RESERVED (Batch BA §1)**: nothing self-propagating may be
authored into an existing spec until the disease-and-virality spec is built, and BA re-specced four nodes off it — one of them
*the NAME Virulence (a pathogen term)*. *Contagion* is that rule's own word. A Poison + Bleed conjunction does not spread, so
the mechanism is outside the reservation; **the name is inside it** — reported, not renamed (NEEDS A RULING).

For the record, *Breach* near-missed five, not two: the BREAK tag, *We Do Not Break*, *You Break Harder*, the glossary's
*Pressure & Break*, and — by the word *each* inside it — the talent *Cleanse Debuffs Each Turn*.

### §3b — `master.html`'S SEVEN, EACH CHECKED AT THE CODE, AND EVERY COPY

| # | `master.html` said | the code | copies found off the document, and what happened to each |
|---|---|---|---|
| 1 | Shatter pays *10% of Attack per stack of Chilled* | per turn held, `clampi(hold_turns, 1, SHATTER_TURN_CAP)` (12) — as its card says | none |
| 2 | the hold window: *+15% damage from all sources* | `_hold_window_mult()` is read once, in the hero strike loop: a companion's blow, a tick, a trap and a self-computing card never see it (the glossary had it right) | **the Glacial Hold rule text** (`SPEC_INFO["cryomancer"].passive_desc` — the core rune's words on class selection, the pouch and the sheet): *from all sources* → *from every hero's strike*, nine lines kept; **three `battle.gd` comments** (the strike-loop site, the engine header, `HOLD_WINDOW`'s); `test_batch_as`'s message (*from all sources*) re-worded; `docs/spec-recon.html` (two) and `docs/talent-audit.html` (one) are records and are not edited |
| 3 | Firedraw takes *what is there or 4* | always `FIREDRAW_TAKE_PERFECT` (6), +3 off another spec's debuff; `FIREDRAW_TAKE` (4) is read by nothing — queued as dead since DH | none (the dead constant is the sentence's source) |
| 4 | Emberkeep doubles *every Burn he applies* (one row) | any hero's (`_emberkeep_holder()`, DH §2) — the card and the other row say so | none |
| 5 | under Emberkeep *Flamewave lays 4 turns on everyone* | a burning body is lengthened through `update_status`, which the window never doubles: 4 on an enemy not yet alight, +2 on one already burning | **`classes.gd`'s Emberkeep SYNERGY comment** said the same, corrected |
| 6 | *only the Tyrant's frost weakness is set* | 20 of the 21 enemy kinds are soft to at least one damage type (frost five, fire three, and shadow, holy, nature, arcane, physical); only the Orc Raider is soft to none | none — the hook's line now says weaknesses are assigned and names the roster |
| 7 | four Overburn refund consumers (*Detonation, Wildfire, Cinderfall and Ember Debt*) | six `_overburn_refund` callers — those four, Funeral Pyre and Pyre Wake | **the glossary's *Overburn*** (player-facing) said four; corrected to six |

**The rite's own sweep through the same document** (EH §2's rule, for the mechanism §1b changed): the Rupture row, the
conjunction block's cleanse sentence and the Ritual Chanter's roster row now say the rite thaws the chill inside a stack at a
time, and the Cleansing Draught's row, which called the rite *a Cleric's Cleansing Rite*, says *an enemy mender's*: no Cleric
card has ever carried that name (`git log -S` over `classes.gd`) — the Draught takes the rite's own set
(`_cleansable_debuffs`), the warband's Ritual Chanter's — and the code comment at the Draught that said the same is corrected.

**Found in passing and not edited**: the item table carries two change-history words — *Unchanged.* on the Revive and Defense
Potions — where the document shows only what is in the game. One-word deletions for the batch that touches the items.

## §4 — DELIBERATELY NOT DONE

- **No conjunction is authored**; `CONJUNCTIONS` keeps its one row. **`RUPTURE_BREAK_PER_TICK` does not move.**
- **The tier-3 rule has no first use**, and **the draft label still waits on the second and third conjunctions.**
- **No composition half is built from a meter state** — §2 prices it and builds nothing.
- **The Skirmisher and the Tracker** are still ruled and unbuilt, with Volley's and Ambusher's core slots and both names owed.
- **Channel's tempo payout. Whether a fallen hero stays down between fights. Tithe's read site, and the talent rebalance it
  owes.** No rune is authored; the crest stays at one slot.
- **`CLAUDE.md` is not split** (§6 has the figure).

## §5 — THE VERIFICATION

### §5a — THE SAVES, BEFORE ANYTHING
Backed up first and verified by hash: `../save-backups/HT-20261006-081045`, the four files byte-identical to the live ones at
08:10:45. **Against HS's backup (`../save-backups/HS-20261005-202947`) nothing moved** — `profile.json` (09:16:35 on 5
October), `run_save.bin` (10:13:06), `relics.json` (30 August) and `settings.cfg` (21 August), md5, size and mtime all equal —
**so the brief's *the designer is playing Rupture* was not so on this machine**: both files that move were last written on the
morning of 5 October, before HS shipped. No Godot process was running.

### §5b — HEAD'S GATES AGAINST THE NEW GAME, BEFORE ANY GATE WAS EDITED
**The recon**: HEAD's suites, gates, runner, count table, pin manifest and documents, with HT's four game files laid over
(`scripts/unit.gd`, `scripts/battle.gd`, `scripts/classes.gd`, `data/glossary.json`), in an isolated copy seeded from HT's
backup, the prediction stamped before the launch. **A first launch (08:30:28) was stopped at 08:39 to take the §3 game edits** —
the Glacial Hold rule text, the glossary's Overburn and three comments — so that the recon read the whole game; its 24 complete
targets read their rows. **The second: 133 targets, 08:40:08 to 09:54:05, 73 min 57 s**, and it read `check_de` **549 / 1**,
as predicted:

| target | read | what it was | disposition |
|---|---|---|---|
| `check_hs` | 83 / 2 | §3b *the chip does not carry … its tier* and §5 *the forming line does not say … its tier* — **predicted**: §1.6's ruling arriving | re-pointed to *degree* (§5c) |
| `check_cm_live` | 13 / 4 | the bar on the enemy's attack and the brace | **sanctioned**: the four FAIL lines word for word HS's |
| `check_gj` | 70 / 1 | §4: *the card says +169 gold and the purse moved 189* | **sanctioned**: HS's figures exactly |
| `check_de` | 549 / 1 | `check_hs`'s row | — |

Nothing else moved: `check_gp` 454, `check_parse` 207, `test_batch_ce` 930, `test_batch_an` 6055 (inside its band, unseeded),
`check_ed` 18 and `check_ec` 24 on HEAD's documents, the run harness PASS 22 / 382 / 8, and no Parse Error or SCRIPT ERROR in any
log. **HS's two coin flips read green — `check_fo` 90 / 0 and `check_hk` 168 / 0 — so neither was touched, and the stub the
brief asks for before touching one was not owed**: HT moved no map rule and no draw, so the dice those arms are dealt did not
move.

**The recon held HEAD's documents, so it could not see HT's edits to them** (HL's lesson): `master.html`, `CLAUDE.md` and
`design-notes.md` were edited after the copy was taken, and two comments in `battle.gd` (comments only, proved by a stripped
diff). **The 46 targets that read one of those three documents were run again on the finished tree** (§5e).

**A PLAIN `kill` DOES NOT STOP THE BATTERY.** The first launch's stop sent TERM to the runner. Its `trap 'rmdir "$LOCK"' EXIT
INT TERM` ran — removing the lock — and the loop went on: the Godot then running (`test_batch_bi`) died and was logged *NO
VERDICT — INCOMPLETE*, and the next target (`test_batch_bj`) launched and finished (70 / 0) before `kill -9` on the shell, then
its Godot, stopped it. With its lock gone a second battery could have started writing the same `$OUT` — CP's data fault. An
`exit` in the INT/TERM trap closes it; not taken (outside the brief), queued.

### §5c — WHAT WAS RE-POINTED, AND WHY
Every repair is written at its site with its reason:

- **`check_hs` §3b and §5**: `desc.contains("tier 2")` → `"(second degree)"`, and the forming line's *— tier 2, 2 turns* →
  *— second degree, 2 turns* — §1.6's ruling, the two arms the recon read red.
- **`check_hs` §3a**: the pin's name and message, PROPOSED → CONFIRMED (§1.1; the constant is `RUPTURE_BREAK_CONFIRMED`). The
  pin, 10, did not move, and the arm was green before and after: a name that said *proposed* about a confirmed figure is the
  ruling's record going stale, the shape HS §1 corrected in the rules file.
- **`test_batch_as`**: one message, *from all sources* → *from a hero's strike* (§3's correction; the assertion did not move).
- **`run_battery.sh`**: `check_ht` joins GATES — 134 targets.
- **`baselines.json`** (indent 1): `check_parse` 207 → **208** (one more target), `check_ht` **77**, new; notes on `check_hs` and
  `test_batch_as`, whose counts did not move.
- **The pin manifest**, regenerated after every gate edit: 1,701 pins (1,296 source, 108 other, 297 document), its one unresolved
  residency HEAD's own; `check_ed` 18 / 0 and `check_ec` 24 / 0 against it.

**The new gate, `check_ht` — 77, one property an arm.** §1 drives the rite both ways: a bare chill x2 → x1 and logged, a bare x1
stripped; a Rupture x2 → a Rupture x1, its Burn unchanged, the thaw logged inside it; at the last stack the Burn alone with one
Sanctity event and *a cleanse: its Chilled is lifted*; a permanent chill inside ranks first over Exposed 4; at both, no line saying
the Rupture was stripped whole — **and the negatives: Dispel One and a purge still take a Rupture whole.** §2 the degree: the chip
(*second degree*, 44 characters a line), the forming line, `tier_ordinal`, both glossary entries, `master.html`'s row and block
(the ruling's own *second-degree affliction*), each saying *degree* and, apart, never *tier*; **a sweep over every literal of the
composition machinery — 30 functions, 2,251 literals — for the old word** (`test_batch_bx` §4b's shape); `tier_of` declared and
read, and no code token naming a degree. §3 each of the seven sentences, its old words gone and its new words there as two arms,
and the code fact beside each (`SHATTER_TURN_CAP` and its twelve, the hold window's one read, Firedraw's take and its six,
Emberkeep's holder, Flamewave's branch, the roster's one weakless kind, the six refund callers), and `CONJUNCTIONS`' one row with
no designed conjunction's id on a status. §4 Broken's entry (one turn, no `src`, unmoved by the clock, the recovery ending the
Break and taking the chip, no conjunction half — and none of Bleed either) and the Warrior's engine-less kit. §5 the watch
condition and *is not a guide* beside the constant. §9 the player's files.

### §5d — THE CONTROLS
**Forty-four controls on `check_ht` (and `check_hs` where the defect reaches it), one defect each, each in a fresh clone of the finished tree with a user-data folder of its own, every anchor dry-checked before the run, read by FAIL text and never by the count: every one printed every line it aimed at, and none threw** (round three, two lanes, 10:30:29 to 10:38:58 — 8 min 29 s; 14–43 s a gate).

| # | the defect | fails | the FAIL line it was aimed at |
|---|---|---|---|
| T01 | the rite lifts a Rupture whole again (it reads no chill inside a composition) | ht 9 | §1: the rite on a Rupture left [] x0 — want the Rupture standing, its chill one stack less (+1 more it aimed at) |
| T02 | the rite takes a bare chill's whole pile (Batch V broken) | ht 5 | §1: the rite on a bare chill x2 left [] x0 — want one stack off, never the pile |
| T03 | the rite ranks a Rupture by its own clock (the other reading) | ht 1 | §1: the rite took ["rupture"] — a permanent chill inside a Rupture must rank first, as it does bare |
| T04 | at the chill's last stack the rite lifts the Rupture whole (Burn and all) | ht 3 | §1: the rite on a Rupture's last chill stack left [] — want the Burn standing alone with its 3 turns |
| T05 | the rite's end of a Rupture logs as a consumer (the why dropped) | ht 1 | §1: the end of a Rupture by the rite was not logged as a cleanse taking its Chilled |
| T06 | a generic cleanse (Dispel One) no longer takes a Rupture whole | ht 1 | §1: Dispel One took '' and left ["rupture"] — a generic cleanse takes a Rupture whole |
| T07 | the chip says tier again | ht 3 + hs 1 | §2: the chip's words do not say its degree: Burn + Chilled, joined (tier second). / Each Burn tick also deals 10 Break damage. / Burn: 3… (+3 more it aimed at) |
| T08 | the forming line says tier again | ht 3 + hs 1 | §2: the forming line does not say its degree: → Rupture forms on Orc Raider: Survivalist's Chilled lands on its Burn — tier second, 3 tur… (+2 more it aimed at) |
| T09 | the glossary's Conjunctions says TIER again | ht 1 | §2: the glossary's conjunctions still says tier |
| T10 | master.html's Rupture row says tier again | ht 2 | §2: master.html's Rupture row does not say its degree (+1 more it aimed at) |
| T11 | a literal of the machinery the driven arms never print says tier (the Break tick's line) | ht 1 | §2: a literal of the composition machinery still says tier (1: _dot_tick_rider: → %s's %s ticks — the Break: +%d Break damage () |
| T12 | a code token names a degree (an identifier moved) | ht 1 | §2: a code token names a degree — the identifiers keep tier: ["unit.gd (1)"] |
| T13 | tier_of renamed (the identifier the ruling keeps) | ht 1 | §2: `tier_of` was renamed or is no longer read — the code's word does not move |
| T14 | master.html's Shatter pays per stack again | ht 2 | §3: master.html's Shatter still pays per stack (+1 more it aimed at) |
| T15 | the Glacial Hold rule text says all sources again | ht 2 | §3: the Glacial Hold rule text still says all sources (+1 more it aimed at) |
| T16 | master.html's Firedraw takes what is there or 4 again | ht 2 | §3: master.html's Firedraw still takes what is there or 4 (+1 more it aimed at) |
| T17 | master.html's Emberkeep doubles only his own Burn again | ht 2 | §3: master.html's Emberkeep row still doubles only the Burn he applies (+1 more it aimed at) |
| T18 | master.html's Flamewave lays 4 on everyone again | ht 2 | §3: master.html still has Flamewave lay 4 on everyone under Emberkeep (+1 more it aimed at) |
| T19 | master.html says only the Tyrant's frost weakness is set again | ht 2 | §3: master.html still says only the Tyrant's frost weakness is set (+1 more it aimed at) |
| T20 | the glossary's Overburn names four refund consumers again | ht 1 | §3: the glossary's Overburn does not name the six refund consumers |
| T21 | a second read of the hold window outside the strike loop | ht 1 | §3: `_hold_window_mult` is read at 2 sites — the window's one read is the strike loop's |
| T22 | a second conjunction is built (Contagion) | ht 2 | §3: `CONJUNCTIONS` holds ["rupture", "contagion"] — the next conjunction is the designer's, and none is built (+1 more it aimed at) |
| T23 | Broken's chip counts down with the clock | ht 1 | §4: Broken's turn count moved with the clock — it is the meter's, ended by the recovery |
| T24 | the Warrior's Crushing Blow lays no Sunder | ht 1 | §4: a Warrior holding no engine did not lay Sunder, Stunned and Mocked from his own kit: { "Crushing Blow": false, "Pommel Strike": true,… |
| T25 | the watch condition beside the constant is deleted | ht 1 | §5: the watch condition is not recorded beside RUPTURE_BREAK_PER_TICK |
| T26 | the chip keeps its degree and gains a tier word (the negative half alone) | ht 4 | §2: the chip's words still say a tier: Burn + Chilled, joined (second degree; a tier). / Each Burn tick also deals 10 Break damage. / Bur… |
| T27 | the chip drops its degree and says no tier (the positive half alone) | ht 1 + hs 1 | §2: the chip's words do not say its degree: Burn + Chilled, joined (second). / Each Burn tick also deals 10 Break damage. / Burn: 3 turns… (+1 more it aimed at) |
| T28 | the forming line drops its degree and says no tier (the positive half alone) | ht 1 + hs 1 | §2: the forming line does not say its degree: → Rupture forms on Orc Raider: Survivalist's Chilled lands on its Burn — second, 3 turns (e… (+1 more it aimed at) |
| T29 | the glossary's Rupture entry drops its degree (the positive half alone) | ht 1 | §2: the glossary's status_rupture does not say degree |
| T30 | the glossary's Conjunctions keeps its degree and gains a tier word (the negative half alone) | ht 1 | §2: the glossary's conjunctions still says tier |
| T31 | master.html's Rupture row drops its degree (the positive half alone) | ht 1 | §2: master.html's Rupture row does not say its degree |
| T32 | master.html's conjunction block loses the ruling's words (the positive half alone) | ht 1 | §2: master.html's conjunction block does not say Rupture is a second-degree affliction |
| T33 | master.html's conjunction block keeps the ruling's words and gains a tier word (the negative half alone) | ht 1 | §2: master.html's conjunction block still says tier |
| T34 | master.html's hold window says all sources again | ht 2 | §3: master.html's hold window still says all sources (+1 more it aimed at) |
| T35 | master.html names four refund consumers again | ht 2 | §3: master.html does not name the six refund consumers (+1 more it aimed at) |
| T36 | Shatter's cap moves off the document's twelve (11) | ht 1 | §3: SHATTER_TURN_CAP is 11 — the document says at most twelve |
| T37 | Firedraw takes the dead FIREDRAW_TAKE (4) instead of FIREDRAW_TAKE_PERFECT | ht 1 | §3: Firedraw no longer takes FIREDRAW_TAKE_PERFECT |
| T38 | the Orc Raider is given a weakness (the roster moves under the document) | ht 1 | §3: the roster's kinds with no weakness are [] — the document names the Orc Raider alone |
| T39 | a designed conjunction's id is given a status row with no conjunction row | ht 1 | §3: a status carries a designed, unbuilt conjunction's id: ["contagion"] |
| T40 | the recovery leaves Broken's chip on | ht 1 | §4: the recovery did not take Broken's chip off |
| T41 | the recovery leaves the body Broken | ht 1 | §4: the recovery did not end the Break |
| T42 | the record beside the constant calls the sim's Break a guide (the second needle alone) | ht 1 | §5: the record beside RUPTURE_BREAK_PER_TICK no longer says the sim's Break is not a guide |
| T43 | the rite thaws the chill inside and also logs the Rupture stripped whole (the negative half alone) | ht 1 | §1: the rite logged the Rupture stripped whole |
| T44 | the glossary's Conjunctions loses every degree word and says no tier (the positive half alone) | ht 1 | §2: the glossary's conjunctions does not say degree |

**What the first two rounds found.** **Round one** — twenty-five controls on the gate as first written (09:59:36 to
10:04:57, two lanes) — went red on every arm it aimed at, **and its FAIL text showed the gate could not say which of two
defects it had seen.** Six §2 checks read *says degree AND never tier* under one message; eleven §3 arms joined two or three
claims — the old words gone and the new words there, a code needle and its figure, the table's one row and no status carrying a
designed id; and §1's thaw, §4's recovery and §5's record joined two each. A control swapping one word for the other broke both
halves at once, so a chip that lost *degree* and a chip that gained *tier* printed the same line. **And §1's negative asked that
the log not say *lifted whole* — a phrase the rite never prints, so it could not fail**: the rite strips a status whole with
*Cleansing Rite strips X from Y*, and the negative reads that now, at the thaw and at the last stack. Every joined arm was split
to one property (22 checks more), two arms were added — that last-stack negative, and Bleed beside Broken in §4 (§2e) — and the
gate read 77 / 0.

**Round two** — forty-three controls on the split gate, eighteen of them new and each breaking one half alone (10:19:50 to
10:28:25) — printed every expected line but two, and the FAIL text said why. **T18 found a defect in the gate**: with the old
Flamewave sentence put back, the arm asking for the new one stayed green, because *not yet alight* stands in Slow Burn's row
too; it reads the sentence's own words now (*lays 4 turns instead of 2 on every enemy not yet alight*, found once in the
document), the one positive needle of the seven that had a second copy. **T09's was my expectation, not the gate**: its injection
left one *degree* in the Conjunctions entry, so only the tier half could red — and T44 now breaks that entry's degree half alone.
**And one more expectation of mine was wrong**: T04's injection keeps the last-stack thaw line, so the new last-stack negative
is not its arm — T01's is, and T01 reds it.

**Round three** — all forty-four, on a fresh copy of the finished tree — is the table above.

### §5e — THE DOCUMENT READERS, RE-RUN ON THE FINISHED TREE
**46 targets — every suite and gate that opens `master.html`, `CLAUDE.md` or `design-notes.md` — 10:04:00 to 10:20:37**, in an
isolated copy of the tree as it stood at 10:03, after every edit to the three documents but `design-notes.md`'s Bleed sentence:
**every one at its row** (`check_ht` at 53, the gate before its split), no failure, no throw, and no Parse Error or SCRIPT ERROR
in any log. What was written after the copy — the Bleed sentence, `docs/state.md`, the changelog entry, this report and the split
gate — is the pre-pass's to read.

### §5f — THE PRE-PASS AND THE ACCEPTANCE RUN
**The pre-pass**: the finished tree in an isolated copy, **proved equal to the tree file by file** (508 files: 507
byte-identical and `project.godot` differing on its `config/name` line alone; the runner the tree's own, differing on its `cd`
line alone), its user data seeded from HT's backup, the prediction stamped at 10:39:57 and the run launched at once — **134
targets, 10:39:57 to 11:54:01, 74 min 4 s**. It read `check_de` **553 / 0 / 0**, every one of the 133 rows at its predicted
reading: `check_ht` 77, `check_hs` 83, `check_hk` 168, `check_fo` 90, `check_hr` 100, `check_gp` 454, `check_parse` 208,
`test_batch_ce` 930, `test_batch_as` 273, `check_da` 41, `check_gw` 76, `check_ek` 47, `check_ed` 18, `check_ec` 24, `check_fx`
496, `check_gv` 1057, `test_batch_an` 6052 (inside its band, unseeded; the recon read 6055); `check_cm_live` 13 / 4 and
`check_gj` 70 / 1 with the recon's FAIL lines word for word; the run harness PASS 22 / 382 / 8; and no Parse Error, SCRIPT
ERROR, TIMED OUT or NO VERDICT line in any of the 134 logs. Against the recon only the predicted rows moved: `check_parse` 207 →
208, `check_hs` 2 → 0 failures, `check_de` 549 / 1 → 553 / 0, and `check_ht` new.

**Between the two runs** only the documents moved: the changelog's verification paragraph and this report. The pin manifest was regenerated after the paragraph and came back byte-identical, and the eighteen targets that read the changelog — `check_fg`, `check_dv`, `check_ec`, `check_ed` and the fourteen suites that follow its archive pointer — read their pre-pass rows, no failure and no throw (11:56:01 to 12:03:33), in an isolated copy proved equal to the tree.

**The acceptance run in the repository**: the repo's own runner, the live user folder, the tree and the player's four files
hashed before and after (absolute paths), the prediction stamped at 12:04:02 — **134 targets, 12:04:02 to 13:18:08, 74 min 6
s**. **The tree was byte-identical after it** (508 files — hash, size and mtime). It read `check_de` **553 / 6**, and the six
were not the tree's:

| target | read | its red arm | window | the game |
|---|---|---|---|---|
| `check_hk` | 168 / 0 | — | 13:13:06–13:14:05 | not yet running |
| `check_hl` | 169 / 2 | §9: `run_save.bin` and `profile.json` *changed under this gate* | 13:14:05–13:14:59 | launched 13:14:11; `profile.json` 13:14:23 |
| `check_hn` | 74 / 1 | §9: `run_save.bin` *changed under this gate* | 13:14:59–13:15:14 | a save |
| `check_ho` | 176 / 1 | §9: the same | 13:15:14–13:15:47 | a save at 13:15:40 |
| `check_hp` | 171 / 1 | §7: the same | 13:15:47–13:16:15 | a save |
| `check_hr` | 100 / 1 | §9: `run_save.bin` *was rewritten* | 13:16:15–13:16:58 | a save |
| `check_hs` | 83 / 1 | §9: the same | 13:16:58–13:17:41 | relaunched 13:17:09; the last save 13:17:31 |
| `check_ht` | 77 / 0 | — | 13:17:41–13:17:57 | no save |

**THE DESIGNER WAS PLAYING.** At 13:14:11 a Godot process with neither `--headless` nor `--script` — `Godot --path
/Users/zipples/Documents/DoD/game`, `CLAUDE.md`'s playtest line — started from the designer's own login shell, not the
battery's; it closed, and started again at 13:17:09 and at 13:20:57. The player's files moved with it: `profile.json` at 13:14:23
(a new run — `runs_started` +1 for the Cryomancer, the Hunter, the Devout and the Swordmaster, three of the counts now written as
integers) and `run_save.bin` from then on (45,232 → 40,184 B). **No target can have written them**: `Run.save_path_is_harness`
sends every headless, `--script` or non-main-scene process to the harness save, every gate that saves points `Profile.save_path`
at a scratch file, and `check_hr` asserts its own save path is not the player's before it writes one — and the gate before the
first save and the gate after the last read green. Every other target read its row and its pre-pass reading but
`test_batch_an`'s unseeded count (6051, inside its band; 6052 in the pre-pass); `check_cm_live` 13 / 4 and `check_gj` 70 / 1
with the pre-pass's FAIL lines word for word; the run harness PASS 22 / 382 / 8; and no Parse Error, SCRIPT ERROR, TIMED OUT or
NO VERDICT line in any of the 134 logs. **The player's files were not put back to the backup**: they are the designer's play.
`relics.json` and `settings.cfg` are byte-identical to `../save-backups/HT-20261006-081045`; `profile.json` and `run_save.bin`
moved by that play alone.

**The six, re-run.** In the repository with the game closed and the tree frozen (the `ps` rows read empty first; 13:19:28 to
13:23:05; the tree byte-identical after, 508 files), `check_hl` 169 / 0, `check_hn` 74 / 0 and `check_ho` 176 / 0 read their
rows; then the designer launched the game again at 13:20:57, and `check_hp`, `check_hr` and `check_hs` read the same one arm red
as their windows took its saves (the last at 13:22:47). Those three ran again in an isolated copy proved equal to the tree, whose
user folder no game shares (13:24:02 to 13:25:57): `check_hp` 171 / 0, `check_hr` 100 / 0 and `check_hs` 83 / 0, as the pre-pass
read them. Nothing of the battery's was left running: the `ps` rows were read after the controls and after each run, and the only
Godot left was the designer's.

**Found by it, and queued**: `run_battery.sh` does not ask whether the game is open, and a player-file arm cannot tell a gate's
write from the player's — a runner that refuses to start, or says so, while a non-headless Godot holds the project closes it.

**After it**, only `docs/state.md`'s verification lines and this report moved. The pin manifest was regenerated and came back byte-identical, and every gate that opens `docs/state.md` — `check_es`, `check_hp` and `check_fr` — with `check_ed` and `check_ec` read their rows (57, 171, 25, 18, 24, no failure; 13:27:43 to 13:28:25) in an isolated copy proved equal to the final tree but for this report's count of copies, written after it.

## §6 — HOUSEKEEPING AND THE RULES FILE

- **HS's seventeen isolated copies are in the Trash**, selected by the *"Dawn of Decay HS "* prefix, under *"DoD spent
  user-data folders (Batch HS's seventeen, cleared at HT 2026-10-06)"*: 17 folders, 8,724 KiB (HS recorded 8,724).
  `app_userdata` went from 479 folders and 151,316 KiB to 462 and 142,592 KiB; the older folders, the live *Dawn of Decay*
  folder and `../save-backups/` were not touched.
- **HT's own copies: 15 user-data folders, 2,404 KiB**, every one named *"Dawn of Decay HT …"* — the probe copy, the two recons,
  the two pre-check subsets (the document readers and the gates' own source), three rounds of controls in two lanes, the
  pre-pass, the two needle proofs and the three-gate re-run. `app_userdata` holds 477 folders and 144,984 KiB at the close. They
  are HU's to clear by that prefix (HO §5's rule).
- **`CLAUDE.md` is 437,200 B = 426.95 KiB, 43.05 KiB under its 470 KiB ceiling** — +2,614 B at HT (HS left it at 434,586 B =
  424.40 KiB): the conjunction block's degree bullet and its rite sub-bullet, the four confirmations written into their bullets,
  and the designed list's two names and the census. **About 5.3 batches at the record (EZ's +8,293 B)**, 5.6 at HP's +7,935 B,
  6.3 at HS's +7,000 B and 16.9 at HT's own rate. **It is not split** (§4), and the shape recon stays owed before the file
  arrives there.
