# BATCH HU — THE BAR PAGES, DOWNWIND IS BOUNDED, AND DID HT ACTUALLY LAND

**On `class-merge`, from `7e20de7` (HT). IMPLEMENT ONLY.** **§0 first: HT landed** — the remote matches its commit, its
game work is in the tree and drives green, its acceptance run happened and read clean on everything the tree could answer for,
and **the committed `docs/reports/HT.md` carries no unfilled token**: the three the brief names stood in the DRAFT in the
working tree for the whole acceptance run and were filled before the commit. **§1: the battle's Abilities list PAGES** (ruled:
a pager, not a slider) — a page is the rows the hotkeys reach, the pager exists only when the list overflows, and a card on page
two is cast through the real turn; **in normal play no bar overflows a page** (the widest is thirteen entries), so only the debug
menu's unlock-all pages today. **§2: every route a chill or a burn takes reaches `_conjoin`** — HS §2b and HT §2d are about two
different operations and both hold; every card in the game was cast on a burning and a chilled board, every carrier and rider
driven, and every one that laid the other half formed its Rupture. **§3: Downwind is bounded** (ruled) — a copied hold is an
ordinary timed freeze and the copy drops `force`; the other five bare copies are classed, not fixed. **§4: fourteen chips
re-tagged** — the designer's two pairs and eleven more shared tags the sweep found — **and Broken is no longer a debuff
*Mitigation per Debuff You Carry* counts** (ruled): 12 points of damage taken whenever its holder is Broken. **§5** records what
is ruled and not built.

**VERDICT: SHIPPED.** The pre-pass — 135 targets in 74 min 38 s, an isolated copy proved equal to the tree — read `check_de`
557 / 0 / 0, every target at its predicted reading. **The acceptance run in the repository** — 135 targets in 74 min 26 s, the
tree frozen and byte-identical after it (509 files), the player's four files untouched, and no game window open through it —
**read `check_de` 557 / 0 / 0**, every target at its pre-pass reading but `test_batch_an`'s unseeded count. No Parse Error, SCRIPT
ERROR, TIMED OUT or NO VERDICT line in any log of either run. Twenty-three controls and a baseline: every control red on the line
it aimed at, the re-tune green; HEAD's game under the new gate red at exactly the four things HU changed and green on §2. **Four
rulings are owed, all player-visible.**

## NEEDS A RULING

1. **THE FOURTEEN NEW CHIP TAGS, PROPOSED (§4a).** Frostbind *Bn*, Blighted *Bg*, Cripple *Cr*, Faith *Fa* with its count, Blood
   Price *Pr*, Covering Guard *Cv*, Caught Fast *Ct*, Retaliation *Rt*, Rallied *Rl*, Spirit Bond *Si*, Scent of Blood *So*,
   Unslaked *Uk*, Anvil *Av*, Deathwish *Dh*. The rarer status of each colliding pair moved, so the chips a player reads most
   stay as learned. Any of them can be re-picked: `check_hu` §4a holds the property — no two statuses share a tag, a counter's
   letters included — and not the letters.
2. **THE PAGER, AS BUILT (§1c).** Its words — *◂ Prev*, *1 of 3*, *Next ▸* — its page — the seventeen rows the hotkeys reach
   — and its memory: the list reopens on the page that hero last showed, for the rest of the fight. Confirm, or reopen every
   list on page one. A key that turns pages is not built.
3. **DOWNWIND'S OTHER FIVE BARE COPIES (§3c).** Three are the hold's shape and fixable at the copy the way §3 fixed it — a
   partner-less Frostbind (an inert chip that still counts for every breadth reader), a poison without `_apply_poison`'s stamps
   (a cleansable copy of an uncleansable poison), and a Ruin stack copied without `_gain_ruin`'s arming (a skipped detonation).
   Two are the card's own business — Vendetta's second permanent taunt, and Snare Trap's second spring, which also takes one of
   the Hunter's trap slots. Which to fix, and whether those two cards should be carried at all.
4. **THE NINE CASE-ONLY NEAR-MISSES (§4a).** *BB*/*Bb*, *BL*/*Bl*, *BW*/*Bw*, *DI*/*Di*, *DW*/*Dw*, *FG*/*Fg*, *SH*/*Sh*,
   *SL*/*Sl*, *TH*/*Th* — two statuses whose tags differ only in case. Snare Line's *SL* beside Slowed's *Sl* is the sharpest:
   both a Hunter's, both on an enemy. Whether a case-only difference is a collision; if it is, nine more move.

**Still owed from HT: its rulings 2 (the rite's rank) and 7 (the words)**, and the six card-versus-code items, each recorded
one word from built in `docs/state.md`.

## THE BRIEF'S PREMISES, CHECKED

| # | The brief says | In the repo |
|---|---|---|
| 1 | On `class-merge`, after HT | **Held**: HEAD `7e20de7` = `git ls-remote origin class-merge`; the tree clean but the untracked `save-backups/` |
| 2 | §0: *"`docs/reports/HT.md` carries"* three tokens — VERDICT, ACCEPT_DETAIL and HT_COPIES, each between double at-signs — *"each unsubstituted"* | **Not so of the committed file** — `git show 7e20de7:docs/reports/HT.md` holds no token marker at all, and that commit is the remote's. **So of the draft**: the working-tree copy held exactly those three from 12:03:48 to 13:27:25, the whole acceptance run, and was filled before the 13:29:16 commit (§0) |
| 3 | §0: the pre-pass reads clean, 553 / 0 / 0 over 134 targets, 508 files proved equal | **Held** (HT §5f, and its logs) |
| 4 | §0: *"there is no acceptance run, no verdict and no `git ls-remote` confirmation"* | **Not so**: the acceptance run ran 12:04:02–13:18:08 and read 553 / 6, each red the designer's game saving mid-run, each re-run clean; the verdict is in the committed report; the `ls-remote` line was in HT's closing message — a report cannot carry its own push (§0) |
| 5 | §1: unlock-all fills the bar past what it can show, and a card off the end cannot be reached | **Held, measured**: the designer's own Arcanist under unlock-all — 57 entries, 37 rows above the screen's top, 20 with neither a key nor a place on the screen (§1a) |
| 6 | §1: *"HO §3d found a crest-granted card sits outside the slot count"* | **Held as a fact about the door; the finding is HN §3d's** (HO §3d is the crest runes' names and shape — the *no Warrior* / *no Hunter* ruling among them) |
| 7 | §1: *"it is reachable without the debug menu, which is why it is a defect"* | **Not so today**: no live crest rune grants a card (HO §6), and the widest bar in play is thirteen entries against a page of eighteen (the basic and seventeen rows) (§1b). The pager is built as ruled, and `check_hu` §1a reds the day a hero can hold more than a page in play |
| 8 | §1: *"report what the keyboard does with it"* | **Q–G and ⇧Q–⇧G cast slots 1–18 by kit order on any page; no key turns a page** (§1c) |
| 9 | §2: HS §2b's sentence, quoted | **Held, word for word** (HS §2b) — and its parenthetical is one call short: there are two variable-id `add_status` calls (§2a) |
| 10 | §2: HT §2d's sentence, quoted | **Held, word for word** (HT §2d's table, Chilled's row) |
| 11 | §2: *"both cannot be true"* | **Not so**: both are true — HS's is about a status arriving, HT's about a standing pile's stacks rewritten; `set_chilled_stacks` returns on a body with no chill (§2a). **Neither report was wrong** |
| 12 | §2: the designer *"reported not seeing the composition"* | **Consistent with the save**: its party opens with no card that lays a Chill, and under unlock-all every one sat in the rows nothing could reach (§2d) |
| 13 | §3a: a copied hold is battle-long, outside `_holds`, on the timeline, with no limit, charge or release; with Carrion, every other enemy | **Held**, driven on HEAD's game under `check_hu` (control H01): *turns −1, held false* |
| 14 | §3a: *"`_freeze_turns`'s ordinary freeze"* | **Held**: `_freeze_turns` gives a freeze that is not a hold one turn; that length is `ORDINARY_FREEZE_TURNS` now, read by both |
| 15 | §3b: *"every caller but Pommel Strike's own Perfect already drops it"* | **Held**: at HEAD one call ORIGINATES it — Pommel Strike's Perfect, on its own target (`docs/combat-rules.md`'s *exactly one caller*) — and three THREAD it: `_hold_freeze`'s own call (no caller passes it true), Frostbind's mate (a Chill, which the boss gate never refuses) and Downwind's carry, the one that could take it to a second body |
| 16 | §3: Downwind's other bare copies, as HT §2f lists them | **Held, all five**, each read at its code (§3c) |
| 17 | §4: *Fb* is Frostbind's and Frostbite's; *Bl* is Blighted's and Bleed's *Bl<n>* | **Held** — and eleven more shared tags (§4a) |
| 18 | §4: not *BD* (CG §3), not *Ru* (HS §3b) | **Held**; no re-tag took either |
| 19 | §4: `count_debuffs` counts Broken where the breadth count excludes it, so a Broken hero takes 12% less | **Held, driven**: a seeded blow, 21 with the node against 24 without (§4b) |
| 20 | §5: HT §2e priced a meter half at eight costs, item 5 the decider | **Held** (HT §2e) |
| 21 | §5: *"Marrowfire … three of its four are* arrow *inside M-arrow-fire"* | **Not so — two of four**: HT §3a's four are *Fire* and *Chain Fire* (the word *fire*) and *Arrow Shot* and *Poison Arrow* (*arrow*). The ruling stands either way |
| 22 | §5: `CLAUDE.md` 426.95 KiB of 470, about 5.3 batches at the record | **Held** at HT's close (437,200 B; EZ's +8,293 B) |
| 23 | §6: HT's backup is the last; the designer has played since | **Held**: `profile.json` and `run_save.bin` moved after HT's backup, by the designer's play (§6a) |
| 24 | §6: *"HS had two [coin flips] and HT had its own; each was proved to be the dice by a stub"* | **Half**: HS's two were stubbed (HS §8b); **HT had none of its own** — HS's two read green at HT and no stub was owed (HT §5b) |
| 25 | §6: HT's copies — *"the count is one of the unsubstituted tokens, so derive it"* | **Derived**: 15 folders, 2,404 KiB, read off the folders; HT's committed report says the same (§7) |
| 26 | §6: HT's pre-pass read 134 targets in 74 min 4 s | **Held** (HT §5f); not taken as a runtime |

## §0 — DID HT LAND? YES, AND THE REPORT THAT SHIPPED SAYS SO

**Answered before anything was edited** (13:42–13:47).

| the brief asks | what was found |
|---|---|
| `git ls-remote origin class-merge` against local HEAD | **`7e20de74b4d185e8b6063ea0893bac5f22663b76` both** — HT's commit, `7e20de7` (13:29:16), on the remote. HT's own closing message reported the same line at 13:30 |
| Is HT's work in the tree? | **Yes, every named part.** The rite at the chill door: `battle._rite_chill` (`battle.gd:8378` at HEAD) and its two lines, *thaws one stack of the … inside …* and *thaws the last stack of …*. *Degree* on screen: `BattleUnit.tier_ordinal` (`unit.gd:3079`), the chip's *(second degree)*, both glossary entries, `master.html`'s Rupture row and conjunction block. `master.html`'s seven corrections and the two recorded names (*Contagion*, *Marrowfire* — `CLAUDE.md`, `docs/state.md`, `docs/design-notes.md`, the comment above `CONJUNCTIONS`). **Driven, not read**: HT's own gate, `check_ht`, run standalone on the tree at 13:46 — **77 / 0**, its §1 the rite both ways, §2 the degree on every surface, §3 the seven sentences each held to its code fact |
| Did an acceptance run happen? | **Yes — 12:04:02 to 13:18:08, 134 targets, 74 min 6 s, `check_de` 553 / 6**, and its logs survive (HT's scratchpad; copied into HU's, `ht_logs/`). The six reds were each gate's player-file arm — `check_hl` 169 / 2, `check_hn` 74 / 1, `check_ho` 176 / 1, `check_hp` 171 / 1, `check_hr` 100 / 1, `check_hs` 83 / 1 — because the designer's own game (launched 13:14:11 from the designer's shell) saved into the live folder inside their windows; the freeze after the run reads the tree byte-identical (508 files) and `profile.json` and `run_save.bin` changed. **Re-run**: `check_hl`, `check_hn` and `check_ho` read 169 / 0, 74 / 0 and 176 / 0 in the repository at 13:19–13:23; the game was relaunched at 13:20:57 and its saves hit the other three again, so `check_hp`, `check_hr` and `check_hs` were run in a proved copy at 13:24–13:26: 171 / 0, 100 / 0, 83 / 0. **So HT's acceptance run read clean on everything the tree could answer for**; HU's own acceptance run re-reads all six in the repository (§6) |
| The three tokens | **The committed `docs/reports/HT.md` carries none** — `git show 7e20de7:docs/reports/HT.md` holds no token marker, its hash equals the working copy's, and the remote's commit is that commit. **The three were real, in the DRAFT**: from HT's own session record, the report was first written at 08:55:12 with its verdict as a token; the copies' count became a token at 10:21:49; at 11:55:38 the pre-pass paragraph went in with the acceptance paragraph as a token; and **from 12:03:48 to 13:27:25 the draft in the working tree held exactly VERDICT, ACCEPT_DETAIL and HT_COPIES beside a finished pre-pass paragraph — which is what the brief describes, and that window IS the acceptance run.** They were filled at 13:27:25 (the verdict and the acceptance paragraph) and 13:28:46 (the copies), before the 13:29:16 commit. **Nothing was filled at HU because nothing was empty**: each filled value was checked against the record it states — the verdict and the acceptance paragraph against `accept_run.log` and the re-run logs (every figure holds), and *15 user-data folders, 2,404 KiB* against the folders themselves (15, 2,404 KiB, read at HU). **`docs/reports/HT.md` is not edited.** The one line a report cannot carry is its own push (`git ls-remote` after the commit the report is in); HT's closing message carried it, and this report carries it for HT |

**THE STANDING RULE, RECORDED** (`CLAUDE.md`, the report block): *a report does not ship with an unsubstituted template token —
grep the finished report for the token marker, the double at-sign, before it is written out; the verdict is what the next batch is built on, and a report without
one has not reported.* **HU added one clause, marked as its own**: the draft stays in the scratchpad until its verdict is in.
Nothing in the tree reads `docs/reports/`, so landing a draft early buys nothing, and a draft in the tree is read as the report —
which is exactly what happened to HT's. This report was kept in the scratchpad until its verdict was written, and was grepped for
the marker before it landed.

## §1 — THE BATTLE BAR PAGES

### §1a — WHAT OVERFLOWED, MEASURED

**The Abilities list is a popup that opens upward from its button** (`battle._open_ability_popup`): the button's top sits at
y 674, the list 6 px above it, and each row is 30 px with 4 between — **34 px a row, 34·rows + 4 for the whole list**. **Nineteen
rows fit under the top of the 720-px screen.** Nothing scrolled and nothing clamped: a list taller than that simply opened above
the screen's top edge.

| hero, under the debug menu's unlock-all | menu entries | list rows | rows above the screen | unreachable (no key, off the screen) |
|---|---|---|---|---|
| a Warden (Heavy Plating) | 49 | 48 | 29 (the list's top at y −968) | 12 |
| a Pyromancer holding Overburn and Glacial Hold | 58 | 57 | 38 | **21 — Fireball, Pyroblast, Detonation, Wildfire, Frostbolt, Blizzard, Glacial Prison, Frostbind, Rime, Cryoclasm, Shatter, Killing Frost, Hoarfrost Armor, Ice Lance …** |
| **the designer's own Arcanist** (Resonance alone, as the designer's save holds him) | 57 | 56 | 37 | **20 — every ice card, Fireball and Firestorm** |

**The keys reached the top of the list and the eye reached the bottom, and the middle belonged to neither**: Q–G and ⇧Q–⇧G name
slots 1–18 (Q the basic's), and the rows past the eighteenth slot that also sat above the screen could not be pressed at all.

### §1b — THE REAL CEILING: THE PAGER IS NOT REACHED IN PLAY TODAY

**The brief's premise — *"reachable without the debug menu … a crest-granted card sits outside the slot count"* — is a fact about
the door, not about the game.** The finding is HN §3d's (HO §3d is the crest runes' names and shape): a crest rune that grants a card puts it on every
bar outside the slot count. **No live crest rune grants a card** (`data/runes.json`'s five crest runes: Tithe, Fellowship —
retired —, Empty Pulpit, Dead Air and Dirge; HO §6: *no card-granting crest rune*).

**The widest bar a hero can raise in normal play, derived over every class, every lineage and every pair of its core runes (264
shapes, `check_hu` §1a), is THIRTEEN entries**: the basic, three kit cards, two core runes' enablers and seven earned cards at the
ladder's last rung — a Berserker holding Bloodrage and the Swordmaster's engine, a Mage holding Overburn and Glacial Hold, a Cleric
holding Conviction and the Old Gods (`master.html` already said thirteen). **Against twenty the bar shows** (the basic and nineteen
rows) **and eighteen the keys reach.** Built on the real scene (`check_hu` §1b): thirteen entries, no pager, every row on the screen
and every row keyed. **So the debug toggle is the only thing that pages today**; a card-granting crest rune would be the first thing
in play that could, at six cards or more. `check_hu` §1a says so the day it happens — it reds rather than letting the pager go live
in play unremarked (control C17, a ladder rung of sixteen, reads it).

### §1c — WHAT SHIPPED

**`battle.BAR_PAGE_ROWS`: a page is the rows the hotkeys reach** — every key but the basic's, then the same keys shifted — so
**page one is exactly the keyboard's page**, and a page with its pager row (18 × 34 + 4 = 616 px) clears the screen's top by 52 px.
**The pager row** (`_bar_pager`) sits under the page's last card: **◂ Prev**, the marker **1 of 3**, **Next ▸**; each end's arrow
is dark rather than wrapping, so the marker always says which way the rest lies. **It is built only when the list overflows a page**
— below that the list is built byte for byte as before. **A card keeps its place**: entry *k* is always row (*k*−1) mod 17 of page
⌊(*k*−1)/17⌋. **The list reopens on the page that hero last showed** (`_bar_page`, kept for the fight), so a designer working page
two finds it there next turn. **Turning a page rebuilds the bar through `_show_actions`** — the one builder — so a card on page two
is the same button through the same `_ability_popup_button` as on page one.

**The keyboard, reported as the brief asks:** Q–G and ⇧Q–⇧G cast slots 1–18 by kit order **whatever page is showing**, and **no key
turns a page** (`check_hu` §1f: with page two showing, W handed over its own slot's Crushing Blow and the list stayed on page two).
Tab opens and closes the list; after a card is chosen Tab cycles targets and Space or Enter confirms; X cancels. **The rows past
the eighteenth slot carry no key, on any page** — they are reached by the pager and the mouse. A key that turns pages is not built
(the brief did not ask for one).

**Rendered** (a windowed probe in the isolated copy, the designer's own party under unlock-all): page one of four shows the
Arcanist's seventeen keyed cards, *◂ Prev · 1 of 4 · Next ▸* under them; page two shows Pyroblast, Firestorm, Phoenix Rebirth,
Fireball, Detonation … Frostbind, Rime, Glacial Prison, unkeyed. The pictures were shown to the designer with this batch.

### §1d — DRIVEN ON THE REAL SCENE (`check_hu` §1)

- **Below a page, no pager**: an ordinary bar (three rows) and the widest normal bar (thirteen entries) build none.
- **Under unlock-all, the pages** (a Survivalist, 51 entries, 50 rows, 3 pages): the marker *1 of 3*, the previous arrow dark and the
  next live on page one; every page's rows are exactly the entries that belong there, in order, and every row of a full page is on
  the screen; the pages together hold every row once; *3 of 3* on the last, its next arrow dark; turned back to page one, the same
  cards in the same places; **rebuilt after turning to page two, it opens on page two.**
- **A card on page two is CAST through the real turn** — the turn parked on its pick, the row's own press, the target picked, **the
  skill-check bar opened for it**, a centred press (`_grade_skill_check`, the same call Space makes), the cast resolved and its
  cooldown started: the Survivalist's Crossfire. **The control**: a page-one card on the next turn the same way — the Pyromancer's
  Magic Burst.
- **The cooldown wash reads the same**: Crossfire on page two sits dark with *(CD 5)*; a page-one card put on the same cooldown reads
  the same. **The refusal tooltip reads the same**: Covering Guard on page two, its recast saturated, is dark and its tooltip ends with
  the refusal note `_recast_refusal_note` writes for page one.

## §2 — EVERY ROUTE A CHILL OR A BURN TAKES REACHES `_conjoin`

### §2a — THE TWO REPORTS DO NOT DISAGREE

**HS §2b:** *"Burn and Chilled reach a body only through `_apply_status` (the one variable-id `add_status` call), so no direct write
bypasses it."* **HT §2d** (the re-application table, Chilled's row): *"`set_chilled_stacks` writes around the door."* **Both are
true, because they are about two different operations.** HS's sentence is about a status ARRIVING on a body; HT's is about the stack
count of a chill ALREADY standing being rewritten without running `add_status`'s re-application rule (+1 stack, the clock reset).
`set_chilled_stacks` (`unit.gd`) starts `var s := _find_status("chilled"); if s.is_empty(): return` — **it cannot lay a chill on a
body that has none**, so it can never be the second half of a meeting the door did not see; on a Rupture's chill it rewrites the
pile inside and the Rupture stands (`check_hu` §2c drives both). **Neither report was wrong about the route. HS's parenthetical
misses one call**: there are TWO `add_status` calls with a variable id — the status door's and the engine chip's
(`u.add_status(u.engine_chip_id(…))`, whose id is always `spec_passive…`, never a status a conjunction is made of) — and its
conclusion stands.

### §2b — EVERY ROUTE, DERIVED

**Every write of a status into a body, in the two scripts that can write one** (comments stripped): `add_status` is called with a
literal id 35 times — **never `burn` or `chilled`** — and with a variable id twice (above); a body's status list is written directly
four times — the door's own append, `log_bleed_chip`'s Bleed append, `compose`'s insert and `_dissolve`'s survivor — none of them a
Burn or a Chill arriving. **So every Burn and every Chill that takes hold is `_apply_status`'s add, and the door calls `_conjoin`
right after it, before any return** (`check_hu` §2a holds all three facts).

**The calls that lay one, by route — thirty-nine `_apply_status` calls name `burn`, `chilled` or a variable id** (derived call by
call by a grep of `battle.gd` and `unit.gd`, comments stripped, and re-derivable the same way; the routes, grouped):

| route | sites | `_conjoin` runs |
|---|---|---|
| a card's own handler (Ember Debt, Rimebinding, Choking Smoke, Killing Frost, Firedraw, Pyre Wake, Deep Winter, Wildfire, Glacial Prison ×2, Cryoclasm) | 11 | yes — through the door |
| a card's data rider (`applies_status`: Fireball, Frostbolt, Flamewave, Firestorm, the enemy kinds' Flame Lick and Immolating Wave) | 2 (variable id) | yes |
| a strike-loop rider (Immolate's Burn on a striker, Hoarfrost Armor's Chill on a striker, Aftershock, Cinder Ember, Flamewave's targets and the chill riders, and a Perfect's Burn through `_apply_perfect_bonus`) | 9 | yes |
| a freeze's riders (Bitter Cold's roll-out, a release's chill-back) | 2 | yes |
| the carriers — **Downwind's copy** (variable id), **Frostbind's mate**, **Rime's echo**, **Returned Burden's cast-back** (variable id) | 4 | yes — each re-enters the door, so its own body's partner is met there |
| a rune's and a dormant node's route (Ember Leap's half in `_overburn_refund`, Backblast) | 2 | yes |
| the run's modifier (the Hoarfrost bargain's opening chill, no applier) and two talent routes in the turn loop | 4 | yes |
| other variable-id routes — Lunge's guard status, the Second Barb's and Stalking Horse's lists (Poison, Cripple, Slow, Exposed, Daze, Blind), the engine marks (Tracked, Judged), Shieldwall's — none can carry a Burn or a Chill | 5 | — |
| **`set_chilled_stacks`** (a freeze's rewrite, the rite's thaw, Cryoclasm's move) | 6 | **not an arrival** — it rewrites a pile that stands |

### §2c — DRIVEN: EVERY CARD, EVERY CARRIER

**Every card in the game that a class's pools, kit, enablers or lineage tables name** (`check_hu` §2b walks
`Classes.ability_corpus()` and casts each as the class that owns it) **was cast for real — `battle._resolve` — on a board where every enemy carried a Burn, and again where every enemy carried a Chill: 408 casts the
usability door allowed.** A cast that landed a Chill on a burning body: **Razor Ice, Blizzard, Glacial Prison and Frostbolt.** A
cast that landed a Burn on a chilled one: **Flamewave, Firestorm, Ember Debt, Fireball and Choking Smoke.** **Every one formed its
Rupture on every body it reached; no cast landed the other status and formed none.** The cards that read as fire or frost and lay
neither — Slow Burn, Rime (Frostbite and Rime), Frostbind (a bond), Emberkeep, Immolate and Hoarfrost Armor (statuses on a HERO,
which burn or chill whoever strikes him), Pyroblast, Ice Lance, Shatter, Cold Iron, Winter's Toll, Detonation and the other
consumers — form nothing by casting, because they lay neither half.

**The carriers and riders, driven one by one** (`check_hu` §2c), each landing its status on a body carrying the other, **each forming
a Rupture there with its line in the log**: Downwind's carry of a Burn; Frostbind's mate copy of a Chill; Rime's echo; Returned
Burden casting a Warden's Chill back onto the burning enemy that laid it; Hoarfrost Armor chilling a burning striker; Immolate
burning a chilled striker; and an enemy's Burn on a hero the Hoarfrost bargain chilled.

**Asked for: *name every card whose chill or burn does NOT compose, and drive one of them.* There is none to name** — every card
whose cast lays a Chill or a Burn composed, in a real fight. **Driven instead, as the nearest thing**: Rime, the frost card that
lays no Chill — cast on a burning enemy it lays Rime and Frostbite, and no Rupture forms and no forming line is written. **And
HEAD's game, driven the same way under `check_hu` (control H01), formed every one too**: no route bypassed the door before HU
either, so nothing in §2 needed closing.

### §2d — WHY THE DESIGNER SAW NONE: MOST LIKELY THE BAR

**The designer's save** (read from a copy, in an isolated folder): a debug-touched run at the first node of zone one — **an Arcanist
holding Resonance alone**, a spine Warrior on Momentum, a spine Cleric on Sanctity and a Beastmaster on Pack Bond. **Nobody in that
party opens with a card that lays a Chill**: Razor Ice and Flamewave are the Cryomancer's and the Pyromancer's enablers, and travel
with their engines. **Under unlock-all, the Arcanist's Glacial Prison (row 31), Frostbolt (34) and Blizzard (35) — every card that
lays a Chill — sat above the screen and past every key**, with Fireball (20) and Firestorm (18) beside them; of the Mage's Burns only
Ember Debt (⇧Q) could be cast. **Without a Chill there is no Rupture to see.** The pager puts all of them on pages two and three.
Which cards the designer actually tried is not recorded anywhere this batch can read, so this is the likeliest cause, not a proven
one.

## §3 — DOWNWIND IS BOUNDED

### §3a — A COPIED HOLD IS AN ORDINARY TIMED FREEZE (ruled)

`battle._apply_status`'s Downwind block lays its copy with **`ORDINARY_FREEZE_TURNS`** where the original is Frozen — the one length
`_freeze_turns` gives a freeze that is not a hold, authored once and read by both. **Chosen over leaving Frozen alone**, because the
card promises every affliction an ally applies; **a bounded freeze does not impersonate the engine's hold**, which stays Glacial
Hold's (`_hold_freeze`: one enemy, a charge, a release). The carry's line says *— an ordinary freeze, never a hold*.

**Driven both ways** (`check_hu` §3a), a Cryomancer's real hold (`_hold_freeze`) beside a Hunter's Downwind: **the hold holds its
own enemy** — in `_holds`, off the timeline, battle-long — and the copy is Frozen for the ordinary length, not in `_holds`, still on
the timeline; **an ordinary freeze's length later the copy has thawed and the hold still holds.** With the Carrion rune, every other
enemy, each the same. On HEAD's game (control H01) the copy read *turns −1, held false* and outlived the turn.

### §3b — THE COPY DROPS `force` (ruled)

The copy calls `_apply_status` without the original's last argument. **Every caller but Pommel Strike's own Perfect already lays a
status without it**, so the copy carrying it was the anomaly — and with it a Perfect Pommel Strike's copy stunned a SECOND, unbroken
boss. **Driven** (`check_hu` §3b): two bosses, a Perfect Pommel Strike on the first — **it still stuns its own unbroken target**;
the copy onto the second is refused (*resists the Stunned (boss — Break them first)*); and **the control: the same copy onto a Broken
boss lands**, so the carry still carries the stun. On HEAD's game the copy stunned the unbroken boss. **`docs/combat-rules.md`'s rule**
(*`force` has exactly one caller now and it is Pommel Strike*) sanctions one card's override on its own target; the copy took it to
a second body, which the rule never did, and the rule carries a bullet saying so now.

### §3c — DOWNWIND'S OTHER BARE COPIES, CLASSED (not fixed)

**The two fixed copies had one shape between them: the copy re-enters the status door with the ORIGINAL's arguments, and so carries
something that belonged to the original's own route** — the hold's battle-long length, which `_hold_freeze` manages and the copy
does not; and the override, which belongs to the one card that bought it, aimed at its own target. Read at the code, the other five:

| copy | what happens | shape |
|---|---|---|
| **a partner-less Frostbind** | the Frostbind arm stamps each end's `partner` AFTER `_apply_status` returns; the copy is a `frostbind` chip with no partner, so `_frostbind_partner` reads nothing — an inert chip that still counts for every breadth reader (and the copy can even land on the second end before its own application) | **the hold's**: the copy skips the route that gives the status its meaning |
| **a poison missing `_apply_poison`'s stamps** | `_apply_poison` lays the stack through the door and THEN stamps `sticky` (Slow Acting, Perfected Toxin) and `full` on it; the copy carries the turns and the tick but not the stamps — a cleansable copy of an uncleansable poison | **the hold's**, in the player's disfavour |
| **a Ruin copied a stack at a time without arming** | `_gain_ruin` lays each stack through the door and arms the primer when one lands on a multiple of the threshold, stamps Weight of Ruin and mirrors to a Covenant bearer; the copy is the door's stack alone — a copy that lands a body on the threshold skips the detonation | **the hold's**, in the player's disfavour |
| **a second permanent taunt off Vendetta** | Vendetta lays Mocked at −1 turns with the Warden's seat as its power (the mark itself is not an affliction and is not carried); the copy locks a SECOND enemy onto the Warden for the fight | **the card's own business**: *"this locks ONE thing forever"* is Vendetta's design, not a standing rule; whether Downwind carries it is a question about the card |
| **a second spring off Snare Trap** | the copy is a second armed snare with the Hunter's seat as its power — it springs a stun and Poison 4, and because it carries his seat it COUNTS against his trap slots (`trap_count`), so his next Snare Trap can be refused while it stands | **the card's own business**: one standing trap per slot is the card's and the talent's rule |

**Not fixed, as the brief says**; the three of the hold's shape would each be one condition at the copy (route the carry through the
original's own route, or leave it alone), and NEEDS A RULING 3 asks which.

## §4 — CHIPS AND BROKEN

### §4a — THE SWEEP: EVERY TAG, EVERY COUNTER, EVERY HAND-WRITTEN CHIP

**The population** (`check_hu` §4a, re-derived by a script first): every `STATUS_INFO` tag (161 rows) and every chip the code
writes by hand — a literal short handed to `add_status` or `update_status` with a literal id, a counter's (`P%d`, `C%d`, `R%d`,
`Bl%d`, `F%d`, `L%d` …) or a fixed one's (Anointed's `An`, which lives in no table row) — **reduced to its letters** (digits and the
counter's placeholder out), so Bleed's `Bl37` meets Blighted's `Bl` — **165 tags over 162 statuses, thirty of them writing a chip by hand** (`check_hu` §4a
prints both). A chip that leads with a sign (`+12%`) is a value, not a tag.
**Thirteen tags were shared** — the two the brief named and **eleven more**:

| tag | statuses | moved | why that one |
|---|---|---|---|
| `Fb` | Frostbite, Frostbind | **Frostbind → `Bn`** | both draft cards; Frostbite keeps the plain reading (frost-*bite*), and Frostbind's own float text says BOUND |
| `Bl` | Blighted, Bleed's `Bl<n>` | **Blighted → `Bg`** | Bleed is far more common and its letters are in `master.html` (*Bl##*) |
| `C` | Cripple, Chilled's `C<n>` | **Cripple → `Cr`** | Chilled is the Mage's core status and its count is in `master.html` (*"C2"*) |
| `F` | Burn, Faith's `F<n>` | **Faith → `Fa<n>`** | Burn is on every fire fight; Faith on the heroes the Devout's Faith reaches; a burning one showed `F` beside `F3` |
| `BP` | Battle Poise, Blood Price | **Blood Price → `Pr`** | a lineage's boss card against a class-wide draft card |
| `CG` | Consecrated Ground, Covering Guard | **Covering Guard → `Cv`** | Consecrated Ground stamps every hero standing in it |
| `Cf` | Caught Fast, Crossfire | **Caught Fast → `Ct`** | Caught Fast has no live applier |
| `R!` | Ruin (primed), Retaliation | **Retaliation → `Rt`** | `R!` is Ruin's family (`R1`…`R!`) |
| `R+` | Renewal, Rallied | **Rallied → `Rl`** | Renewal is a draft card; Rallied a talent's |
| `SB` | Slow Burn, Spirit Bond, Scent of Blood | **Spirit Bond → `Si`, Scent of Blood → `So`** | Slow Burn is the draft card on enemies; Scent of Blood's tag never shows (its chip is a `+N%` value) |
| `Un` | Unity, Unslaked | **Unslaked → `Uk`** | Unity reads naturally (*Un*-ity) |
| `An` | Anvil, Anointed | **Anvil → `Av`** | Anointed's is hand-written; *An-vil* reads as `Av` as well |
| `DW` | Divine Wrath, Deathwish | **Deathwish → `Dh`** | Deathwish's tag never shows (its chip is a `+N%` value) |

**Fourteen re-tagged in all**; none took `BD` (Break damage's shorthand) or `Ru` (Rupture's). **Eleven of the fourteen are met in
play; Caught Fast, Scent of Blood and Deathwish are not** (no live applier; two chips that show a value) and moved so that the
property is the table's, not the screen's today. **The rule a future batch meets** (`CLAUDE.md`, the text standard's list): a
status's chip tag is its own, a counter's letters included. **Near-misses that differ only in case, reported and not moved**
(NEEDS A RULING 4): `BB`/`Bb`, `BL`/`Bl`, `BW`/`Bw`, `DI`/`Di`, `DW`/`Dw`, `FG`/`Fg`, `SH`/`Sh`, `SL`/`Sl`, `TH`/`Th`; no new
tag made one. **And two value chips read alike by design**: Shieldwall's and Bulwark Line's *+N% Block*.

**What it touched**: fourteen `STATUS_INFO` rows and three hand-written shorts in `battle.gd` (Faith's counter at its two writes,
Unslaked's and Anvil's `update_status`), and **one suite**: HEAD's `test_batch_bg` pinned Faith's chip text — `F0` and `F%d` — and
went red in the recon (§6b); re-pointed to `Fa0` and `Fa%d`, the question unchanged. **No document names any of the fourteen**
(`master.html` names Bleed's `Bl##`, Chilled's `"C2"`, `Ir` and `Ru`, all unmoved).

### §4b — BROKEN IS NOT A DEBUFF *MITIGATION PER DEBUFF YOU CARRY* COUNTS (ruled)

`BattleUnit.count_debuffs` skips `broken` now, as `battle._status_count` (the breadth count) always has. **The magnitude that moves,
driven** (`check_hu` §4b, a raider's basic on a Warden holding `tn_iron_will`, the roll seeded; HEAD from control H01):

| the Warden carries | with the node, HEAD | with the node, HU | without the node |
|---|---|---|---|
| Broken alone | **21** (−12%: Broken counted) | **24** | 24 |
| Broken and Dazed | **18** (−24%: two counted) | **21** (−12%: the Dazed) | 24 |

**One debuff's step, 12 percentage points of damage taken, whenever the hero holding the node is Broken**; the chip reads *−0%*
for Broken alone. **A second reader of the same count moves with it**: the Holy bot's choice to Empower Divine Plea asks
`count_debuffs() > 0` of its weakest ally, so it no longer empowers a plea for an ally whose only affliction is Broken (a purge
never lifts Broken; the empowered plea's Hallowed would still have refused new debuffs). Reported; the bot is the sim's.

## §5 — RECORDED, NOT BUILT

- **No conjunction is authored**; `CONJUNCTIONS` keeps its one row and `RUPTURE_BREAK_PER_TICK` stays at 10.
- **A meter state is not a conjunction half** — ruled and recorded (`CLAUDE.md`'s conjunction block; `docs/state.md`'s designed
  four): HT §2e's item 5 decides it. **The Warrior's half is a status he already lays** — Sunder, Stunned or Mocked, all from his
  kit — and **Marrowfire becomes Sunder + Burn pending the design pass**; Contagion and Reckoning each owe a re-cut.
- **The Occultist's hole is not a conjunction problem**: Madness is boss-gated on Broken and nothing live in his pool grinds the
  meter, so no conjunction can open it while meters are not halves; it is CE §3's original ask — a Break card in his pool — owed on
  its own (`docs/state.md`).
- **No targeted debug card pick** — recorded as available if paging fifty cards proves worse than the overflow did.
- **The six card-versus-code items are not built**; each is one word from built in `docs/state.md` — *code* for Mark of the Hunt's
  reset, Charge's Daze and Blood Debt's killing bleedout; *card* for Counter Time and Snare Line (a stun's LENGTH would touch every
  stun in the game); and **Thin Blood as a straight bug**: a zero tick reads as *no tick set* in `battle._dot_pass` and falls back
  to the legacy 3 a stack, so the rune's price is never charged (re-read at its line at HU).
- **The Contagion name waits on the re-cut; Marrowfire ships as a named near-miss when it ships.**
- **The Skirmisher and the Tracker** are still ruled and unbuilt, with Volley's and Ambusher's core slots and both names owed.
- **Channel's tempo payout; whether a fallen hero stays down between fights; Tithe's read site and the talent rebalance it owes.** No
  rune is authored; the crest stays at one slot.
- **`CLAUDE.md` is not split** (§7 has the figure).

## §6 — THE VERIFICATION

### §6a — THE SAVES, BEFORE ANYTHING
Backed up first and verified by hash: **`../save-backups/HU-20261006-134615`**, the four files byte-identical to the live ones at
13:46:15. **Against HT's backup (`../save-backups/HT-20261006-081045`) two moved, by the designer's play**: `profile.json` (1,097 →
1,099 B, written 13:29:50 — `runs_started` +1 on the Arcanist, the Beastmaster, the Cleric, the Holy, the Hunter, the Inquisitor, the
Sharpshooter, the Swordmaster, the Warden and the Warrior, +2 on the Cryomancer, three counts re-written between integer and float)
and `run_save.bin` (45,232 → 39,892 B, 13:31:25); `relics.json` (30 August) and `settings.cfg` (21 August) are byte-identical. **The
save is a debug-touched run** (`debug_used` true) at the first node of zone one — an Arcanist on Resonance alone, a spine Warrior on
Momentum, a spine Cleric on Sanctity, a Beastmaster on Pack Bond, nothing earned; read from a copy in an isolated folder, never the
player's. Not a defect. No Godot was running when the batch began.

### §6b — HEAD'S GATES AGAINST THE NEW GAME, BEFORE ANY GATE WAS EDITED

**The recon**: HEAD's (`7e20de7`) gates, suites, runner, baselines, pin manifest and documents, with HU's two game files laid
over — `scripts/battle.gd` and `scripts/unit.gd` — in an isolated copy (`config/name` *"Dawn of Decay HU recon"*, user data
seeded from HU's backup). **134 targets, 14:18:12 to 15:32:31 — 74 min 19 s.** Its prediction was written and stamped before
the launch.

| target | read | the FAIL line | |
|---|---|---|---|
| **`test_batch_bg`** | **41 / 2** | §2/BI: *...showing a count of zero (got "Fa0")*; §2: *...and the visible text is still the stack count* | **not predicted** — HU's re-tag arriving: HEAD's suite pinned Faith's chip as `F0` and `F%d` |
| `check_cm_live` | 13 / 4 | *the bar appeared on the enemy's attack* and its three | **sanctioned**: HT's FAIL lines word for word |
| `check_gj` | 70 / 1 | §4: *the card says +169 gold and the purse moved 189* | **sanctioned**: HT's figures exactly |
| `check_de` | 553 / 1 | *test_batch_bg went REDDER: 2 failures, recorded 0* | — |

**Every other target read HT's pre-pass reading, line for line**, but `test_batch_an`'s unseeded count (6049, inside its band
of 6044–6066): `check_gp` 454, `check_gv` 1057, `check_fx` 496, `test_batch_ce` 930, `check_parse` 208, `check_ed` 18 and
`check_ec` 24 on HEAD's documents and manifest, the run harness PASS 22 / 382 / 8, and no Parse Error, SCRIPT ERROR, TIMED OUT
or NO VERDICT line in any log. **The arms the prediction named as reading what moved all read green** — `check_ct` 114 (Hexed's
chip is not Cripple's), `check_hs` 83 (Rupture's chip its own), `test_batch_ax` 223 (the override's two declarations and
`_hold_freeze`'s threaded call), `check_di` 44 (no `_apply_status` call site added or removed), `check_fx` 496 (Iron Will's arm
lays Dazed and Cripple) — **and the one risk it named, a layout arm measuring a nameplate's chip row now that Faith's counter is
three characters, did not arrive.** **HS's two coin flips read green — `check_fo` 90 / 0 and `check_hk` 168 / 0 — so neither was
touched, and the stub the brief asks for before touching one was not owed**: HU moved no map rule and no draw.

**Why the literal sweep missed `test_batch_bg`, and what changed for it.** Before the recon, every string literal of four or more
characters in every gate and suite was swept against HEAD's and HU's `battle.gd` and `unit.gd`: zero lost. **A chip tag is two or
three characters, so a floor of 4 is blind to every one by construction** — `"F0"` is two. Recorded in
`docs/instrument-rules.md` (EB §2's block): *a string shorter than the floor is swept at its own length — when a batch changes a
tag, a counter's format or any literal under the floor, it greps the tree for the old string and the new at their own length,
and reads every hit.* Done for the fourteen after the recon: the thirteen old tags and the fourteen new, quoted at their own
length, over every gate, suite and fixture, and as whole tokens over `master.html`, the glossary, the text standard and the text
audit. **`test_batch_bg`'s two arms are the only reader of a moved tag.** Six fixture lines in four suites and gates write a chip by
hand for a status that kept its tag (Frostbite's *Fb*, Chilled's *C* twice, Burn's *F*, Consecrated Ground's *CG* twice), and `check_ft` writes Blind as *Bl*
on a fixture of its own — a chip only that gate reads; the game's Blind is *Bd*. No document names any of the fourteen.

### §6c — WHAT WAS RE-POINTED, AND WHAT IS NEW

- **`test_batch_bg` — two arms re-pointed, the question unchanged** (`_live_release_still_consumes`, `_live_the_chip_states_the_doubled_numbers`):
  `"F0"` → `"Fa0"` and `"F%d"` → `"Fa%d"`, each with its reason at the site. The chip still shows the stack count; it shows it
  after its own letters. **Its row keeps 41 / 0** and carries a note; HEAD's copy read 41 / 2 on HU's game at exactly those two
  arms, and control C12 (Faith's counter back to `F<n>`) takes the re-pointed copy back to 41 / 2.
- **`check_hu` — new, 103 checks, one property an arm**: §0 the floor (the gate fixture, the save path); §1 the pager (a–f); §2
  every route (a–c); §3 Downwind (a–b); §4 the tags and Broken (a–b); §5 the meter-state ruling in `CLAUDE.md`; §9 the player's
  files. Standalone on the landed tree: **103 / 0**, its stream carrying no error line.
- **`run_battery.sh`** — `check_hu` joins GATES. **`baselines.json`** — `check_hu`'s row (103 / 0, new), `check_parse` 208 → 209
  (§A counts every target the runner names), and `test_batch_bg`'s note: 18 lines added, 4 changed, 134 rows; the file
  round-trips byte for byte at indent 1. **`pin-manifest.json`** regenerated: 1,710 pins, +9 (all `check_hu`'s), none removed;
  `check_ed` 18 / 0 and `check_ec` 24 / 0 on it standalone.
- **The document readers.** HU's documents were edited after the recon copy was taken, so its readings of them are HEAD's. The
  literal sweep over the five edited documents, HEAD against HU: **zero lost** in `CLAUDE.md`, `master.html`, `design-notes.md`,
  `combat-rules.md` and `instrument-rules.md`, and every gained literal checked against the gates that hold it (none is an
  absence needle a reader of those files asks). The instruments that read the documents and the gates' own source were run
  standalone in the renamed probe copy carrying the landed edits, before the WHERE block and the changelog entry landed —
  `check_ed`, `check_ec`, `check_da`, `check_dw`, `check_ea`, `check_ek`, `check_es`, `check_ff`, `check_gw`, `check_parse`,
  `check_fr`, `check_dj`, `check_hp`, `check_fg` and `test_batch_cd` — each at its row, `check_ed` once the manifest was
  regenerated (it read 18 / 1 against HEAD's); **the pre-pass read every target on the finished tree.**

### §6d — THE CONTROLS
**Twenty-three controls and a baseline, read by their FAIL text, in fresh APFS clones of the finished tree** (`ctl.py`; one defect each, its anchor
count-asserted before the run; a lane's own user folder, seeded from HU's backup). **Round one** (14:46–14:56) ran on the gate before
its last two edits and found them: **the tag walk missed Anointed's `An`** — HEAD's game under the gate (H01) listed twelve shared
tags where the sweep had found thirteen, because a chip handed to `add_status` as a literal lives in no table row and the gate
walked counters only; the walk now reads every literal chip `add_status` and `update_status` write — and **one FAIL line contradicted
itself** (C22: *"the pages hold 50 rows, the list 50 — a card is missing or shown twice"*, where the counts matched and the names
did not); it names the first row that differs now. A third edit came from the gate's own design rather than a control: the thaw arm
ticked one turn, which would have pinned the freeze's length rather than the rule — it reads `ORDINARY_FREEZE_TURNS` now, and C16
proves a re-tune leaves the gate green. **Round two** (15:00–15:09), every control on the final gate:

| control | the defect, one each | `check_hu` | the line it aimed at, read |
|---|---|---|---|
| C00 | none — the baseline every control is read against | 103 / 0 (`test_batch_bg` 41 / 0) | — |
| C01 | the pager is never built | 103 / 8 | §1c: *the marker reads '', want '1 of 3'*, both arrows, every page |
| C02 | a page is one row more than the keys reach | 103 / 2 | §1a: *a page holds 18 rows, the keys reach 17* |
| C03 | the pager is built on a list that fits | 103 / 2 | §1b: *an ordinary bar (3 rows) built a pager*; *the widest normal bar (13 entries) built a pager* |
| C04 | the page is not kept between builds | 103 / 5 | §1c: *rebuilt after turning to page two, the list reads '1 of 3'* |
| C05 | a page starts one row early (pages overlap) | 103 / 2 | §1c: *page 2 shows ["Bear the Brunt", …], its entries are ["Bring It Down", …]* |
| C06 | a copied freeze keeps the hold's length | 103 / 4 | §3a, with Carrion and without: *a copied freeze is not an ordinary timed one … (turns -1, held false …)*; *outlived a turn* |
| C07 | the copy forwards the boss override again | 103 / 2 | §3b: *Downwind's copy stunned an unbroken boss*; *the copy's refusal is not in the log* |
| C08 | the carry's line drops *an ordinary freeze* | 103 / 2 | §3a: *the carry's line does not say the freeze is an ordinary one*, both arms |
| C09 | *Mitigation per Debuff You Carry* counts Broken again | 103 / 6 | §4b: *a Broken Warden … counts 1*; *the chip reads '-12%'*; *21 with it, 24 without* |
| C10 | Frostbind wears *Fb* again | 103 / 2 | §4a: *Fb: frostbite, frostbind* |
| C11 | Cripple wears *C* again — Chilled's counter letters | 103 / 1 | §4a: *C: chilled, cripple* |
| C12 | Faith's counter reads *F*&lt;n&gt; again — Burn's letter | 103 / 1, **and `test_batch_bg` 41 / 2** | §4a: *F: burn, faith*; `test_batch_bg`: *got "F0"* |
| C13 | Downwind lays its copy around the status door | 103 / 5 | §2a: *the add_status calls with a variable id are ["id", "id", …]*; §2c: *Downwind's carry of a Burn — no Rupture*, and §3b |
| C14 | the status door never asks for a conjunction | 103 / 18 | §2a: *does not ask `_conjoin`*; §2b: *formed Ruptures off 0 chilling and 0 burning cards*; every §2c carrier and rider |
| C15 | `set_chilled_stacks` lays a Chill on a body that has none | 103 / 2 | §2a: *3 appends and 2 inserts*; §2c: *laid a Chill on a body that carried none* |
| C16 | **a RE-TUNE, which must stay green**: the ordinary freeze lasts two turns | **103 / 0** | — the thaw arm reads `ORDINARY_FREEZE_TURNS`, not a length |
| C17 | the slot ladder's last rung grows past one page | 103 / 2 | §1a: *in normal play a hero raises a 19-entry menu … the pager is live without the debug menu*; §1b |
| C18 | Anvil wears *An* again — Anointed's hand-written chip | 103 / 1 | §4a: *An: anvil, anointed* |
| C19 | a paged card loses its cooldown count | 103 / 1 | §1e: *Crossfire on page two, cooling 5, reads 'Crossfire 25 Mana'* |
| C20 | a paged card loses its refusal tooltip | 103 / 1 | §1e: *Covering Guard on page 2, refused, reads dark … tooltip …* (the refusal note gone) |
| C21 | a hotkey reaches the shown page, not its slot | 103 / 1 | §1f: *with page two showing, key W handed over ["Wildstrikes"] — want its own slot's Crushing Blow* |
| C22 | a paged card's button is never bound | **88** / 3 | §1c: *page 2 shows ["", "", ""]*; §1d: *no hero's page two held a damaging card the door lets him cast* — the cast's own arms could not run, so the count fell |
| C23 | a hand-written chip takes another status's tag (Anointed writes *Av*) | 103 / 1 | §4a: *Av: anvil, anointed* |

**HEAD's game under the new gate (H01)** — `check_hu` against HEAD's `battle.gd` and `unit.gd`, given only the two constants'
names so it would compile — **102 / 25 and one SCRIPT ERROR**, red at exactly the four things HU changed: §1c (no pager — *the
marker reads ''*, *31 rows of a full page sit above the screen*), §3a (the copies *turns -1, held false*, outliving the turn),
§3b (*Downwind's copy stunned an unbroken boss*), §4a (all thirteen shared tags, Anointed's *An* among them) and §4b (the Broken
Warden counting 1, *-12%*, the blow 21 against 24). **§2 read green on HEAD**: no route bypassed the door before HU either,
which is §2's answer. Run at 14:46 with round one's gate (which listed twelve tags) and again at 18:07 with the final one.
**The throw is the gate's, reported rather than repaired**: §1f's last arm casts the battle node's `_bar_page` to a
Dictionary (`check_hu.gd:521`), and HEAD's node has no such variable, so on a game without the pager that one arm throws where
it should fail — 102 checks where the tree reads 103. On HU's game it cannot happen, and a regression that removed the variable
would still read red, loudly: a SCRIPT ERROR beside the count, and a count fall that `check_de` reds. The one-line repair (read
the member, then assert it is a Dictionary) is queued in `docs/state.md` rather than made after the acceptance run.

### §6e — THE PRE-PASS AND THE ACCEPTANCE RUN

**The pre-pass**: the finished tree's own runner and gates in an isolated copy — an APFS clone with `.git` and `.godot`,
`save-backups/` left out, `config/name` *"Dawn of Decay HU prepass"*, user data seeded from HU's backup — **proved equal to the
tree before it ran**: 509 rows of the tree's freeze, 508 byte-identical in the copy and the 509th `project.godot` (the rename),
none missing and none extra; and after it, no file in the copy newer than its start. **135 targets, 15:36:01 to 16:50:39 —
74 min 38 s — read `check_de` 557 / 0 / 0**, every target at the reading its prediction (written and stamped before the
launch) named: `check_hu` 103 / 0, `test_batch_bg` 41 / 0, `check_parse` 209 / 0, and every other target at its recon reading
but `test_batch_an`'s unseeded count (6052, inside its band); the two sanctioned reds at their counts with HT's FAIL lines word
for word; the run harness PASS 22 / 382 / 8; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any log. **The one
risk the prediction named — a reader of the changelog or of `docs/state.md` that the standalone sweeps had not run, both having
landed after them — did not arrive.**

**The acceptance run in the repository**: the repo's own runner with the live user folder, its prediction written and stamped
before the launch. The tree — every file but `.git`, `.godot` and `save-backups/`, 509 — and the player's four files were frozen by
md5, size and mtime before and after, at absolute paths, and the tree before it was byte-identical to the pre-pass copy's source
(0 of 509 differ). **135 targets, 16:51:35 to 18:06:01 — 74 min 26 s — read `check_de` 557 / 0 / 0**: every target at its
pre-pass reading but `test_batch_an`'s unseeded count (6055, inside its band); the two sanctioned reds at their counts with HT's
FAIL lines word for word; the run harness PASS 22 / 382 / 8; no Parse Error, SCRIPT ERROR, TIMED OUT or NO VERDICT line in any
log. **The tree was byte-identical after it (509 files: hash, size and mtime), and the player's four files byte-identical before
it, after it and to HU's backup.** `ps` was read every fifteen seconds through the run for a Godot that was not headless — the
designer's game, whose saves landed inside six gates' windows at HT — and none appeared, so the risk the prediction named did not
arrive.

**What moved after it, and the proof.** Two files: `docs/state.md` — the WHERE block's verification lines, and one queue line
for §6d's throw — and this report. `docs/state.md`'s two readers and the document instruments were run on the final tree after
the edit, in the repository: `check_es` 57 / 0, `check_hp` 171 / 0 (its player-file arm green), `check_ec` 24 / 0, `check_ed`
18 / 0, `check_fg` 22 / 0 and `check_fr` 25 / 0 — each its row, and each stream carrying no error line. The report is read by
nothing in the tree.

## §7 — HOUSEKEEPING

- **HT's fifteen isolated copies are in the Trash**, selected by the *"Dawn of Decay HT "* prefix, under *"DoD spent user-data
  folders (Batch HT's fifteen, cleared at HU 2026-10-06)"*: **15 folders, 2,404 KiB** — the count HT's own report gave (the brief
  called it a token; it was filled). `app_userdata` went from **482 folders and 145,740 KiB to 467 and 143,336 KiB**; the older
  folders, the live *Dawn of Decay* folder and `../save-backups/` were not touched.
- **HU's OWN COPIES are six user-data folders, 1,076 KiB**, every one named *"Dawn of Decay HU …"* — the probe, the recon, the
  three control lanes (*ctlA*, *ctlA2*, *ctlB*) and the pre-pass; the acceptance run used the live folder, wrote only the gates' own scratch files
  there (each gate's `*_profile.json` and its kind), and left the player's four files byte-identical.
  `app_userdata` reads 468 folders and 143,672 KiB at close. **HV clears them by that prefix** (HO §5), and `docs/state.md`'s
  queue says so.
- **`CLAUDE.md` IS NOT SPLIT. At close it is 442,887 B = 432.51 KiB** — +5,687 B at HU, measured after the batch's own writing
  (HT left it at 437,200 B = 426.95 KiB) — **with 37.49 KiB under its 470 KiB ceiling: about 4.6 batches at the record (EZ's
  +8,293 B)**, 4.8 at HP's +7,935 B, 5.5 at HS's +7,000 B and 6.8 at HU's own rate. HU's growth is not a new record. The brief's
  *about 5.3 batches* was HT's figure at HT's close and held there. **The shape recon is owed before the file arrives**; the
  arithmetic is not the answer next time (HN §1).
