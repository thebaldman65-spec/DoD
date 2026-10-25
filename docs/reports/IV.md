# Batch IV — the sim's own figures, and the last of the plumbing

**On `class-merge`, after IU (`91ce490`). IMPLEMENT ONLY.** `git ls-remote origin class-merge` read `91ce490`, IU's push and local
HEAD, before anything ran (2026-10-24 23:0x). **The designer's files were backed up first** (`../save-backups/IV-20261024-230637`,
23:06:37, byte-identical to IU's backup by `diff -r`) and read only through copies: `run_save.bin` (55,264 B, md5 `fcb20c91…`) and the
clean readout `run-20261018-194229.jsonl` (24,340 B, md5 `610bcd8c…`) at the open — **the readout still the one run; no newer file
has appeared** — and the same md5s at the close (2026-10-25 08:40:00) — `run_save.bin` `fcb20c91…`, the profile, the relics and the settings, and all three readout files (the clean run `610bcd8c…`, IH's first, `latest.txt`), each equal to the open's backup and read through a copy; **no newer readout file** at the close (§11).

**What shipped.** The sim answers what a player answers, through his doors and in his order: both rune caches — the bargain's, which
it had never answered, and the elite's — through `Run.take_rune_pick`, the door the hero's screen commits through, after the draft;
the merchant's two buys ask the counter's door before the gold moves (§1). The paired drive against the unchanged tree read every
figure a default sim took: the rune supply moved — about one rune more a hero a run, almost all held unworn — and the bargain ladder's 26 did not, its order holding under a shift of zero; eleven recorded figures are marked SUPERSEDED-PENDING, seven of them the supply and the merchant's buys (§1c). Every environment read in the game's scripts is a row of `check_iv` §2, and the
five sim-family reads a player's run could reach are gated (§2). The four other repairs are built and the divergence census holds
**RULE 0**, a ceiling (§3). Three claims are repaired in the ledger in place and GK's three names are reported for the ruling (§4).
The index question is closed in HN's block by its derivation and the pilot ended; the 188 cheap gates are a standing list under two
ceilings (§5); the index has nine population rows, derived (§6). **No player-facing word moved**, no data file and no save version
moved.

**VERDICT: GREEN**

---

## §0 — THE BRIEF's PREMISES, VERIFIED (CLAUDE.md: verify the brief against the repo)

| # | the brief says | verdict |
|---|---|---|
| 1 | `git ls-remote origin class-merge` reads IU's push and local HEAD | **True** — `91ce490` both, before anything ran. |
| 2 | §0.1: 817 rules, HELD 299 / PARTLY 229 / NONE 284; 112 of 120 blocks hold one no gate fully holds | **True** — recounted off `docs/reports/IU-rules-census.tsv`: 817 rows (and 5 NO-RULE), 120 blocks, 112 with a NONE or PARTLY row. |
| 3 | §0.2: IR01 is false as written and true as qualified three lines later | **True** — the instrument rules' opening tiebreak says *in `CLAUDE.md`*; GR §2's paragraph below it adds `docs/combat-rules.md`. |
| 4 | §0.2: IR09/IR50 — both files restate a few counts; HY §6 already permits *a live count points at its instrument, or carries its batch* | **True** — HY §6's block is headed *A LIVE COUNT IN A REFERENCE POINTS AT THE INSTRUMENT THAT PRINTS IT, OR CARRIES ITS BATCH*; `docs/state.md`'s THE REST names two sanctioned reds' failures, each with its batch. |
| 5 | §0.2: GK's names have stood since GK | **True** — `CLAUDE.md`'s ledger block, *(names PROPOSED at GK)*, wrapped across lines 2689–2690; ISN04 and ISF12 STAND on it. |
| 6 | §0.3: the ten bot defects cluster into five repairs | **True** — the census's ten RULE rows (DV05, 06, 07, 11, 24, 25, 26, 27, 29, 32), and DV01/DV02 already repaired at IU. |
| 7 | §0.4: the strike-loop rule and `check_ft` §6c contradict | **True** — S3-009 (NONE; its cheap column: *a ruling is owed before any gate*). **The code decided**: every enemy blow that would bypass the loop is routed through it (Blood Tribute and the wind-up's landing resolve as plain attack copies), so `note_blow_met` has one call, and the gate described the code (§0.4 below). |
| 8 | §1a: `run_sim` queues the bargain's pick and never reads `rune_candidates` | **True** at HEAD — `claim_reward()` queues it (`run_state.gd`), and no line of `run_sim.gd` reads the queue. |
| 9 | §1a: 0.8 to 1.15 runes a hero a run, missing since HR | **True as HR measured it** (HR's report §1c: bargain caches a run, 0.8–1.05 and 0.85–1.15, its two parties at Warden). **IV's drive measured more on its parties**: the bargain's caches pay 1.06–1.48 runes a hero a run on the default build on IV's side, and a hero ends a run holding +1.00 to +1.36 more (§1c). |
| 10 | §1b: Health's stack cap is 6; a party holding six with a hurt hero pays 30g for no potion, in every default run | **The mechanism is true, the frequency is not** — `ITEM_CAP` 6, `ITEM_PRICES["health"]` 30, HEAD's `_shop_visit` spent before `add_item` with its result unread, once a hero below half a visit. **Not "in every default run"**: HEAD's sim bought 0.00 potions a run at Wanderer and Warden on the default build, 0.70 at Ruin (§1c). |
| 11 | §1b: the comment at `run_sim.gd:584-590` is false | **True** — HEAD's 583–588: *the gold is spent either way because the sim's policy already decided to spend it* — true of the bot alone. Gone. |
| 12 | §1a: DV28, the bot's cache policy: an ordinary rune first | **True** — `_pick_rune_candidate`; POLICY, its reason in `run_sim.gd`'s header. |
| 13 | §1a: the real game rolls the draft, queues the cache for the map, and holds a core rune unworn | **True** — `battle._check_end` rolls every living hero's draft before the elite's cache; `map_screen._confirm_hero_draft` answers the draft, then the rune; HL §1 holds a core rune unworn. |
| 14 | §2: `DOD_SIM_RUNES` is not gated on `sim_run`; `DOD_SIM_GRANT_ALL` is not either, and arms the player's debug toggle | **True** — `runes_mode()` read the environment bare; `battle._ready` set `Run.debug_grant_all` on the bare variable. `rich` and `power` were gated (`if not sim_run`). |
| 15 | §3: `_resolve` asks no door | **True** — `battle._resolve` pays and resolves; `_ability_usable` is asked by the button, the drafted hook and the kit branch, never by `_autoplay_pick`'s rotation arms. |
| 16 | §5: 188 cheap, 76 of them NONE | **True** — the census's NONE and PARTLY rows whose cheap column begins *YES*. |
| 17 | §5: IT broke HO §0, a NONE rule, 162 times | **True of IT** — HO §0 had no gate when IT wrote 162 breaches; `check_it` §2c made it PARTLY, and IU's census rows it so. Written as *162 times while no gate held it*. |
| 18 | §6: IU's close-read found *the claims* and *every rule* are populations | **True** — IU's report §8: *the brief's the claims and every rule are populations, not subjects*. |
| 19 | §9: IU's `check_gp` 439 → 440 is the model of an attributed road | **True** — IU §11, attributed by HEAD's run beside IU's. |
| 20 | the two readings: `CLAUDE.md` 474.77 KiB, 35.23 under; `docs/state.md` 318.63, 61.37 under | **True** — 486,160 B and 326,275 B at HEAD. |

## §0 — THE RULINGS, AND WHERE EACH IS WRITTEN

`check_iv` §0 pins each by its own words, in the file whose subject it binds, every needle on one line:
- **§0.1** — *THIS FILE TAKES NO INDEX, AND NOTHING IS STRUCK FROM IT*: `CLAUDE.md`, in its ceiling block (*THIS FILE IS MEASURED IN KiB …*),
  on the sentence that said the block index is decided at the re-measure. *AND IT ENDED AFTER THREE REPORTS (IS, IT, IU)*: `docs/state.md`'s index section. *A BATCH's WORK CHANGES WHAT THE
  FILE SAYS IS TRUE …*: `docs/instrument-rules.md`, a block of its own — THE CLOSE-READ.
- **§0.4** — *A RULE AND ITS OWN GATE ARE TWO DESCRIPTIONS OF ONE BEHAVIOUR …*: `docs/instrument-rules.md`, a block of its own, with
  S3-009 as its first instance; the census row re-read in place (HELD, `check_ft` §6c).
- **§1a** — *THE BOT ANSWERS WHAT A PLAYER ANSWERS, THROUGH THE SAME DOOR AND IN THE SAME ORDER*: `CLAUDE.md`, in IL §3's bot block
  beside IU §0.2's *may not play by different rules*. **§1c** — *A KNOWN-MOVED FIGURE LEFT UNMARKED IS THE STALE CLAIM …*:
  `docs/instrument-rules.md`, under IP §2's fidelity block.
- **§2** — *A SIM-FAMILY FLAG IS READ BY A SIM ONLY*: `CLAUDE.md`, in the harness flags' block. **§3** — *THE DIVERGENCE CENSUS's RULE
  COUNT IS A CEILING OF ZERO*: `docs/instrument-rules.md`, in `check_gw`'s ceiling block beside IU §5's MISSES — the third instrument
  of the shape, one practice. **§5**'s standing list: the same block, and `docs/state.md`'s block of its own. **§6** — *A TRIGGER
  NAMES A SUBJECT …*: `docs/state.md`'s index section, above the rows.

---

## §1 — THE TWO THAT MOVE EVERY RECORDED FIGURE

### §1a — THE BARGAIN's RUNE CACHE (DV26), AND THE ORDER (DV27)

**The door moved out of the screen.** A cache's answer lived in `map_screen._take_rune_pick`, which the sim cannot reach. It is
`Run.take_rune_pick(member, rune_name)` now — the rune by its name out of `rune_choice`'s live list (FD §1), the head triple spent, a
core rune **held unworn** and any other worn while a slot it fits is free (`hold_rune` decides by kind, HK §2), the owed pick paid —
and `Run.spend_rune_pick` lets a cache go only while `rune_choice` hands over nothing (FM §3). **The screen answers through both** and
builds only its toast from what the door returns; its words are the lines they were.

**The sim answers through the same two**, in the player's order (`RunSim.on_battle_end`, `battle._check_end`'s victory branch line
for line): the heal, the relics' victory hooks and the bargain's reward (which queues its cache on a hero); at an elite every living
hero's draft is **rolled** (`_roll_draft`), then the elite's cache is rolled and queued; then the merchant a bargain bought; then,
where the map's arrival answers them, the drafts (`_award_draft`) and then every cache the fight queued (`_answer_rune_picks`). **The
choice is DV28's policy, unchanged** (an ordinary rune first, else the first); a core rune the door holds unworn is then slotted from
the panel's own door (`engine_rows`, `engine_toggle_refusal`, `toggle_engine`) while an engine slot is free — GK's policy, taken
**after** the draft instead of before it, so the draft is drawn with the engines the player would hold. A rune the door queues for
the panel at a full holding is let go there, by identity — the bot's stated policy for a drop that meets a full holding.

**The report says it**: a new line, *Bargain caches … taken … worn … caches let go*, and *Acquired per hero per run* counts the
bargain's runes.

### §1b — THE MERCHANT's DOORS (DV24, DV25)

**The potion** asks `item_full` and `needs_slot` before the gold moves, as `shop_screen._buy_item` does; a refusal costs nothing and
is counted (*the door refused*, on the report's shop line). **The rune counter** asks `Run.buy_refusal` of every offer before the
best is bought, every pass, because a buy can fill the holding the next offer is bound for; a refusal is counted (*the door (a full
holding)*). **The comment that said the gold is spent either way is gone.**

### §1c — WHAT MOVED, MEASURED, AND WHO RE-TAKES IT

**Derived first, as IU §4 did, and the effect expected large.** What IV's code changes in a sim run, by mechanism: (a) **the
bargain's cache is answered** — a rune a hero for every bargain that pays one, which the sim never took (supply; then power, where
a slot or an engine slot is free); (b) **the elite's cache is answered after the draft** — the draft rolled without an engine the
player would not hold yet (the draft's offer; then power); (c) **the merchant asks its doors** — no gold for a potion at the cap or
a rune with no room (gold; then what it buys); (d) **the rotation re-asks the door and the fallback body is written back** (DV05,
DV11) — the bot's play in every fight; (e) the boss pick's cap (DV29) and the environment gates — latent in a sim run, no figure.
**So the figures to read are the brief's whole list**: every figure a default sim took — the dry shares (IE §1b, untalented and
default), the Hourglass readings (IF §0.1b untalented, IG §4c default, the bars IF read), Sanctity's figures (IO §3, on IG's
population: the Cleric awakened as the Hierophant), completion and depth (GJ's untalented count, IO §3's), the rune-supply
figures (HR §1c; the run report's acquisition line), and the bargain ladder's 26 (IP §1b's 23 grade readings, IP's three rung
means).

**THE DRIVE, ON ITS OWN, BEFORE ANY DOCUMENT MOVED** (23:39 → 02:43, then a follow-up 02:45 → 02:58): HEAD (`91ce490`) against IV's
code in two lanes, **the same probe applied byte for byte to both** (`iv_probe.py`: each run seeded `block × 100003 + i`, the dry
reading per Mana turn, a fight's end before any victory heal, the Sanctity ledger, the party's runes at the run's end, IN's forced
arm rebuilt; `iv_probe2.py`: the door's lengthened applications, and the Cleric awakened as the Hierophant). **33 arms, 20 runs a
party on IG's three parties, 60 runs a side each**: the natural default build at Wanderer, Warden and Ruin (D1–D3), untalented at
each (U1–U3), the Hourglass held untalented (H1) and default (H2), IG's Hierophant population default and untalented (HS_D, HS_U),
and the 23 forced arms with their baseline, on Ruin, the default build (F_*). **The probe consumes no randomness and the drive is
deterministic**: one party re-driven with the second probe reproduced its first drive's 9,641 (HEAD) and 10,155 (IV) probe lines
byte for byte. **The kept table**: `docs/reports/IV-drive.tsv`, 820 rows — every arm's every figure, HEAD ± se, IV ± se, d, |d|/se,
the verdict (a cut inside two standard errors is a tie), the record it reads against, and its mark.

**WHAT MOVED: THE SUPPLY, BY MECHANISM, AND LITTLE ELSE.** The bargain's caches pay **1.06–1.48 runes a hero a run** on the default
build on IV's side (HR measured the omission at 0.8–1.15 on its two parties at Warden), and a hero ends a run holding **+1.36 runes
at Wanderer, +1.31 at Warden, +1.00 at Ruin** — almost all of it **held unworn** (+0.89 to +1.28): the bot's three slots were
already full by the run's end, so worn rose **+0.032 ± 0.004** a hero and core runes slotted **+0.085 ± 0.011** (pooled over 34
arms), and the merchant sold **0.58 ± 0.10 fewer runes a run** (the run report's line, 30 party blocks paired by seed, |d|/se
5.7; merchants walked tie, −0.13 ± 0.07) because the cache's runes fill the slots first. **The power barely moved**:
health at a fight's end pooled over every arm **+0.0006 ± 0.0016**, depth and completion tie in every natural arm — **except the
weakest population**, IG's Hierophant party untalented, where runs completed **25% → 50%** (15 → 30 of 60, |d|/se 2.90, Fisher's
exact p ≈ 0.008) and depth +3.5 of 49: there the runes the sim now takes buy completion.

| the recorded figure (its record) | arm | HEAD | IV | d | \|d\|/se | |
|---|---|---|---|---|---|---|
| runes a hero holds at a run's end — HR §1c (default, Wanderer) | D1 | 7.21 ± 0.09 | 8.57 ± 0.11 | +1.36 | 9.41 | **MOVES** |
| — at Warden | D2 | 7.33 ± 0.08 | 8.64 ± 0.10 | +1.31 | 10.04 | **MOVES** |
| — at Ruin | D3 | 7.34 ± 0.09 | 8.34 ± 0.11 | +1.00 | 7.16 | **MOVES** |
| held unworn — HR §1c (Wanderer) | D1 | 1.65 ± 0.07 | 2.92 ± 0.10 | +1.28 | 11.01 | **MOVES** |
| — Warden | D2 | 1.70 ± 0.07 | 2.88 ± 0.09 | +1.17 | 10.55 | **MOVES** |
| — Ruin | D3 | 1.81 ± 0.07 | 2.70 ± 0.09 | +0.89 | 7.75 | **MOVES** |
| rung mean, health at a bargain fight's end — IP's cut 0.956 (Wanderer) | D1 | 0.947 ± 0.005 | 0.953 ± 0.004 | +0.006 | 0.93 | **tie** |
| — 0.908 (Warden) | D2 | 0.908 ± 0.007 | 0.901 ± 0.009 | -0.007 | 0.64 | **tie** |
| — 0.687 (Ruin) | D3 | 0.714 ± 0.011 | 0.706 ± 0.011 | -0.008 | 0.52 | **tie** |
| dry share, the Cleric — IE §1b 4.1% (default) | D1 | 4.71 ± 0.63 | 5.14 ± 0.69 | +0.43 | 0.46 | **tie** |
| — the Mage 4.5% | D1 | 3.74 ± 0.80 | 4.58 ± 0.98 | +0.84 | 0.67 | **tie** |
| — the Hunter 3.9% | D1 | 6.42 ± 0.71 | 6.60 ± 0.69 | +0.18 | 0.18 | **tie** |
| — untalented, the Cleric 26.8% | U1 | 33.03 ± 1.64 | 33.95 ± 1.43 | +0.92 | 0.42 | **tie** |
| — the Mage 18.3% | U1 | 24.85 ± 2.79 | 20.99 ± 2.79 | -3.86 | 0.98 | **tie** |
| — the Hunter 33.8% | U1 | 40.30 ± 1.45 | 36.92 ± 1.48 | -3.38 | 1.63 | **tie** |
| — untalented, the Hourglass, the Cleric 11.5% (IF §0.1b) | H1 | 15.18 ± 0.90 | 16.23 ± 1.03 | +1.06 | 0.77 | **tie** |
| — the Mage 16.4% | H1 | 14.85 ± 2.35 | 15.55 ± 2.52 | +0.71 | 0.21 | **tie** |
| — the Hunter 20.9% | H1 | 22.96 ± 1.20 | 24.56 ± 1.26 | +1.60 | 0.92 | **tie** |
| — default, the Hourglass, the Cleric 0.7% (IG §4c) | H2 | 0.62 ± 0.17 | 0.99 ± 0.20 | +0.37 | 1.40 | **tie** |
| — the Mage 2.9% | H2 | 2.08 ± 0.45 | 3.20 ± 0.73 | +1.12 | 1.30 | **tie** |
| — the Hunter 0.3% | H2 | 0.43 ± 0.13 | 0.87 ± 0.21 | +0.44 | 1.79 | **tie** |
| opens a fight full — the Cleric 39.2% (IG §4c) | H2 | 75.27 ± 2.03 | 73.96 ± 2.02 | -1.31 | 0.46 | **tie** |
| — the Mage 42.5% | H2 | 82.88 ± 2.16 | 79.29 ± 2.50 | -3.59 | 1.09 | **tie** |
| — the Hunter 35.6% | H2 | 74.43 ± 1.74 | 71.56 ± 1.93 | -2.87 | 1.10 | **tie** |
| the bar at a turn's start — the Cleric 91 of 120 (IF §0.1b) | H2 | 109.24 ± 1.09 | 107.03 ± 1.28 | -2.21 | 1.31 | **tie** |
| — the Mage 97 | H2 | 111.46 ± 1.09 | 109.80 ± 1.39 | -1.66 | 0.94 | **tie** |
| — the Hunter 95 | H2 | 108.99 ± 0.81 | 105.91 ± 1.16 | -3.08 | 2.18 | **MOVES** |
| Sanctity — untalented, a normal fight 2.56 steps (IO §3) | HS_U | 2.371 ± 0.081 | 2.465 ± 0.069 | +0.094 | 0.88 | **tie** |
| — at 14, 2.37 | HS_U | 2.191 ± 0.080 | 2.305 ± 0.068 | +0.114 | 1.09 | **tie** |
| — default, 2.46 | HS_D | 2.430 ± 0.049 | 2.447 ± 0.062 | +0.016 | 0.21 | **tie** |
| — untalented, a boss 3.95 | HS_U | 3.939 ± 0.094 | 3.739 ± 0.096 | -0.200 | 1.50 | **tie** |
| — a boss at the cap 38.9% | HS_U | 34.60 ± 4.77 | 33.47 ± 4.19 | -1.13 | 0.18 | **tie** |
| — the door lengthened, untalented 5.12 a fight | HS_U | 3.13 ± 0.30 | 4.19 ± 0.54 | +1.06 | 1.71 | **tie** |
| — default 5.03 | HS_D | 4.56 ± 0.72 | 5.15 ± 0.75 | +0.59 | 0.57 | **tie** |
| runs completed, untalented, IG's Hierophant population — IO §3 70 of 180 | HS_U | 25.00 ± 5.64 | 50.00 ± 6.51 | +25.00 | 2.90 | **MOVES** |
| runs completed, untalented, rung 1 (GJ §1b) | U1 | 60.00 ± 6.38 | 66.67 ± 6.14 | +6.67 | 0.75 | **tie** |
| — rung 2 | U2 | 1.67 ± 1.67 | 3.33 ± 2.34 | +1.67 | 0.58 | **tie** |
| — rung 3 | U3 | 0.00 ± 0.00 | 0.00 ± 0.00 | +0.00 | nan | **—** |
| depth of 49, untalented, rung 1 | U1 | 44.45 ± 1.06 | 44.27 ± 1.25 | -0.18 | 0.11 | **tie** |
| — rung 2 | U2 | 23.35 ± 1.54 | 22.10 ± 1.47 | -1.25 | 0.59 | **tie** |
| — rung 3 | U3 | 11.72 ± 0.82 | 11.33 ± 0.81 | -0.38 | 0.33 | **tie** |
| runs completed under Tinderbox — IP §1b 59 of 60 | F_tinderbox | 93.33 ± 3.25 | 100.00 ± 0.00 | +6.67 | 2.05 | **MOVES** |
| — under Miasma, 51 of 60 | F_miasma | 93.33 ± 3.25 | 100.00 ± 0.00 | +6.67 | 2.05 | **MOVES** |

**READ AGAINST CHANCE**: of 97 recorded readings, the seven of supply and the merchant's buys move by mechanism; of the other
90, **four** read past two standard errors where chance gives **4.1** — the Hierophant completion above, two runs-completed columns at the boundary (Tinderbox
and Miasma, 56 → 60 of 60: 2.05 SE by the normal reading, which overstates there — Fisher's exact p ≈ 0.12 each), and the Hunter's
bar with the relic (−3.1 of 120, 2.18 SE; the Cleric and the Mage tie). **All eleven are marked SUPERSEDED-PENDING by the rule** (EQ's 6.98 runes bought among them, which the close-read found
unmarked — §11), each with what it is, in `docs/state.md`'s new block *WHAT IV's DRIVE MOVED* beside the ladder, with pointers at the two places the file
quotes a moved figure (EQ's 6.98 bought and 3.44 acquired, IF's 91 / 97 / 95). **The batch that owes every re-take is the one that authors the
deck's middle**, which measures anyway. **Moved and recorded nowhere**: worn and slotted above, and a boss's Sanctity steps past two standard errors in 6 of 34 arms,
both ways (pooled +0.011 ± 0.018). **What the drive could not read**: FOUND AT IF's Rupture rate (3.2% of a Cryomancer's turns,
IF §2's own arm) — the probe books no cast, and DV05's re-ask can move it, so the re-take reads it — BOIL OVER'S RATE's HZ
figures (Rage a turn, the bot's damage at a full bar; the probe reads Mana bars only), and Carried, with measurements attached's
readings, each of a retired configuration. **And HEAD against the record, beyond the ladder**: the HEAD
arm reads the mana figures' levels far from their records (opens full 75 / 83 / 74% against IG §4c's 39 / 43 / 36; the bars about
110 of 120 against IF's 91 / 97 / 95; untalented dry 33 / 25 / 40 against IE's 27 / 18 / 34) — its readings are rebuilt from the
reports' descriptions on IG's three parties, not the original probes, so the A/B delta is IV's effect and no record's level is
re-read here (said in the drive's block, where the re-take reads it).

### THE LADDER — DOES THE GRADES' ORDER HOLD UNDER A UNIFORM SHIFT? **YES, AND THERE IS NO SHIFT**

| modifier (IP §1b) | HEAD | IV | d | \|d\|/se | IP's figure |
|---|---|---|---|---|---|
| Hoarfrost | 0.954 ± 0.004 | 0.953 ± 0.005 | -0.001 | 0.09 | 0.963 |
| Dull Edge | 0.942 ± 0.007 | 0.955 ± 0.004 | +0.013 | 1.61 | 0.957 |
| Frenzied | 0.947 ± 0.004 | 0.950 ± 0.005 | +0.002 | 0.34 | 0.954 |
| Tinderbox | 0.944 ± 0.005 | 0.949 ± 0.005 | +0.004 | 0.60 | 0.951 |
| Warded | 0.948 ± 0.005 | 0.942 ± 0.006 | -0.006 | 0.77 | 0.949 |
| Parched | 0.950 ± 0.004 | 0.940 ± 0.006 | -0.009 | 1.21 | 0.948 |
| Slick Footing | 0.947 ± 0.005 | 0.948 ± 0.005 | +0.001 | 0.19 | 0.945 |
| Muffled | 0.948 ± 0.005 | 0.947 ± 0.004 | -0.001 | 0.11 | 0.941 |
| Encumbered | 0.951 ± 0.005 | 0.944 ± 0.006 | -0.007 | 0.93 | 0.941 |
| Bloodletting | 0.935 ± 0.006 | 0.950 ± 0.005 | +0.014 | 1.73 | 0.938 |
| Fleeting | 0.945 ± 0.006 | 0.943 ± 0.006 | -0.002 | 0.27 | 0.931 |
| Brittle | 0.925 ± 0.007 | 0.911 ± 0.008 | -0.015 | 1.41 | 0.921 |
| the Long Silence | 0.928 ± 0.006 | 0.923 ± 0.006 | -0.005 | 0.62 | 0.910 |
| Feverish | 0.920 ± 0.006 | 0.920 ± 0.007 | -0.000 | 0.02 | 0.910 |
| the Thin Veil | 0.895 ± 0.010 | 0.896 ± 0.008 | +0.001 | 0.06 | 0.908 |
| Deadened | 0.901 ± 0.006 | 0.892 ± 0.009 | -0.009 | 0.82 | 0.899 |
| Rot | 0.915 ± 0.006 | 0.910 ± 0.007 | -0.005 | 0.54 | 0.899 |
| Thin Air | 0.921 ± 0.008 | 0.921 ± 0.007 | +0.000 | 0.04 | 0.897 |
| Miasma | 0.894 ± 0.008 | 0.890 ± 0.008 | -0.004 | 0.36 | 0.875 |
| Overgrown | 0.815 ± 0.013 | 0.839 ± 0.011 | +0.024 | 1.43 | 0.857 |
| Mirrorbound | 0.703 ± 0.015 | 0.687 ± 0.016 | -0.016 | 0.72 | 0.706 |
| Wasting | 0.664 ± 0.016 | 0.681 ± 0.016 | +0.018 | 0.80 | 0.684 |
| Bloodless | 0.722 ± 0.014 | 0.732 ± 0.013 | +0.010 | 0.50 | 0.640 |


```
uniform shift -0.0004 ± 0.0018 (inverse-variance mean of 23); chi-square about it 16.1 on 22 df (p ≈ 0.81)
largest residuals: bloodletting +0.0145 (1.8 SE), dulledge +0.0136 (1.7 SE), overgrown +0.0243 (1.5 SE), brittle -0.0142 (-1.4 SE)
Spearman's rho, HEAD's sort against IV's: 0.844
40 pairs flip order; 0 flip past two SE on both trees
  flip dulledge     over hoarfrost     HEAD 1.4 SE apart, IV 0.3 SE apart
  flip muffled      over encumbered    HEAD 0.5 SE apart, IV 0.4 SE apart
  flip frenzied     over encumbered    HEAD 0.5 SE apart, IV 0.8 SE apart
  flip slick        over encumbered    HEAD 0.6 SE apart, IV 0.6 SE apart
  flip tinderbox    over encumbered    HEAD 0.9 SE apart, IV 0.6 SE apart
  flip dulledge     over encumbered    HEAD 1.0 SE apart, IV 1.6 SE apart
  flip bloodletting over encumbered    HEAD 2.0 SE apart, IV 0.8 SE apart
  flip warded       over parched       HEAD 0.2 SE apart, IV 0.2 SE apart
  flip muffled      over parched       HEAD 0.3 SE apart, IV 0.9 SE apart
  flip frenzied     over parched       HEAD 0.4 SE apart, IV 1.1 SE apart
  flip slick        over parched       HEAD 0.4 SE apart, IV 1.0 SE apart
  flip fleeting     over parched       HEAD 0.6 SE apart, IV 0.3 SE apart
  flip tinderbox    over parched       HEAD 0.8 SE apart, IV 1.0 SE apart
  flip dulledge     over parched       HEAD 0.9 SE apart, IV 2.0 SE apart
  flip bloodletting over parched       HEAD 1.9 SE apart, IV 1.1 SE apart
  flip muffled      over warded        HEAD 0.1 SE apart, IV 0.7 SE apart
  flip frenzied     over warded        HEAD 0.1 SE apart, IV 1.0 SE apart
  flip slick        over warded        HEAD 0.2 SE apart, IV 0.8 SE apart
  flip fleeting     over warded        HEAD 0.4 SE apart, IV 0.1 SE apart
  flip tinderbox    over warded        HEAD 0.5 SE apart, IV 0.8 SE apart
  flip dulledge     over warded        HEAD 0.7 SE apart, IV 1.8 SE apart
  flip bloodletting over warded        HEAD 1.6 SE apart, IV 1.0 SE apart
  flip frenzied     over muffled       HEAD 0.0 SE apart, IV 0.4 SE apart
  flip slick        over muffled       HEAD 0.1 SE apart, IV 0.2 SE apart
  flip tinderbox    over muffled       HEAD 0.5 SE apart, IV 0.2 SE apart
  flip dulledge     over muffled       HEAD 0.7 SE apart, IV 1.4 SE apart
  flip bloodletting over muffled       HEAD 1.6 SE apart, IV 0.4 SE apart
  flip dulledge     over frenzied      HEAD 0.7 SE apart, IV 0.8 SE apart
  flip bloodletting over frenzied      HEAD 1.6 SE apart, IV 0.0 SE apart
  flip tinderbox    over slick         HEAD 0.3 SE apart, IV 0.1 SE apart
  flip dulledge     over slick         HEAD 0.6 SE apart, IV 1.1 SE apart
  flip bloodletting over slick         HEAD 1.4 SE apart, IV 0.2 SE apart
  flip tinderbox    over fleeting      HEAD 0.1 SE apart, IV 0.8 SE apart
  flip dulledge     over fleeting      HEAD 0.3 SE apart, IV 1.8 SE apart
  flip bloodletting over fleeting      HEAD 1.1 SE apart, IV 0.9 SE apart
  flip dulledge     over tinderbox     HEAD 0.3 SE apart, IV 1.0 SE apart
  flip bloodletting over tinderbox     HEAD 1.2 SE apart, IV 0.1 SE apart
  flip thinair      over brittle       HEAD 0.5 SE apart, IV 1.0 SE apart
  flip feverish     over brittle       HEAD 0.6 SE apart, IV 0.9 SE apart
  flip thin_veil    over deadened      HEAD 0.5 SE apart, IV 0.3 SE apart
grades on IV's sort, IP's counts: 10 of 23 differ from IP's: {'bloodletting': (2, 1), 'brittle': (2, 3), 'deadened': (3, 4), 'long_silence': (3, 2), 'parched': (1, 2), 'rot': (4, 3), 'slick': (2, 1), 'thin_veil': (3, 4), 'thinair': (4, 3), 'warded': (1, 2)}
grades on HEAD's own sort (this drive's A), IP's counts: 10 differ from IP's: {'brittle': (2, 3), 'deadened': (3, 4), 'dulledge': (1, 2), 'encumbered': (2, 1), 'long_silence': (3, 2), 'muffled': (2, 1), 'rot': (4, 3), 'thin_veil': (3, 4), 'thinair': (4, 3), 'tinderbox': (1, 2)}
the cliff, Overgrown | Mirrorbound: HEAD 0.112, IV 0.152
```

**Read plainly**: **every one of the 26 ties** — the 23 grade readings and the three rung means (Wanderer +0.006, Warden −0.007,
Ruin −0.008). **The one uniform shift that best explains the 23 is −0.0004 ± 0.0018, and the residuals about it are noise** (χ²
16.1 on 22 degrees of freedom, p ≈ 0.81); Spearman's ρ between the two sorts is 0.844, and the 40 pairs that swap order all swap
inside a cluster — none is two standard errors apart on both trees. **Re-cut at IP's fixed counts, IV's sort grades 10 of 23
differently from IP — and HEAD's own sort on this drive grades 10 differently too**: a cut that falls in a cluster moves on a second
reading, which is IQ §0.2's point measured again, not a move. **So the batch that authors the deck's middle re-reads the bands; it
owes no re-grade for IV's repair.** The baseline arm (no modifier) ties as well (health at a fight's end +0.0001).

**WHAT THE DRIVE CANNOT SETTLE — HEAD AGAINST THE RECORD.** This drive's HEAD arm reads 17 of IP's 23 within two standard errors and
six outside: **Bloodless +0.082** (0.722 against 0.640), **Overgrown −0.042**, Thin Air +0.024, the Long Silence +0.018, Rot +0.016,
Miasma +0.019. The forced arm is IN's probe rebuilt from its description (IN's file is not kept), and HEAD is IU's game, four batches
after IP's measurement — so the drive measures what IV's repair moved on its own instrument, which is nothing, and cannot say whether
the record or the instrument drifted. **Named beside the grade table**, so the re-take is taken on the record's own instrument.

**AND ONE PREMISE, CORRECTED.** The potion bought at the cap is not *in every default run*: HEAD's sim bought **0.00 potions a run**
at Wanderer and Warden on the default build (60 runs each) and 0.70 at Ruin; the door's mechanism is as the brief says, and it
rarely meets the sim. The rune counter's refusal for want of room read 0.00 a run in every arm — the holding never filled.

---

## §2 — EVERY ENVIRONMENT READ, ONE ROW EACH (DV32)

**The sweep, read-only, before any edit**: every `OS.get_environment` and `has_environment` call in `scripts/*.gd`, comment-stripped,
keyed by file, function and variable — 58 at HEAD and at IV alike (`battle.gd` 31, `run_sim.gd` 21, `run_state.gd` 6; every call names its variable as a literal). **Five sim-family reads reached a
player's run, not two**: beside DV32's `DOD_SIM_RUNES` (`runes_mode`) and `DOD_SIM_GRANT_ALL` (`battle._ready`, the debug grant),
`DOD_SIM_RELICS` (`battle._ready`, guarded by `not run_sim` alone — **a player's fight is not a run sim either, so an export replaced
his drafted relics at every battle's open**), and `DOD_SIM_ENEMIES` / `DOD_SIM_THEME` (`_spawn_units`, read above the encounter's own
warband — **a forced lineup replaced every fight of a real run**). `DOD_SIM_DEBUG` echoed the combat log; `DOD_SIM_SPECS` was read in a
run and never used.

**Gated**: `DOD_SIM_RUNES` on `sim_run` (as `rich` and `power` beside it); `DOD_SIM_GRANT_ALL`, `DOD_SIM_RELICS` and `DOD_SIM_DEBUG` on
`sim`; the lineup and theme on `sim or not Run.active` (a sim, or a bot battle outside a run); `DOD_SIM_SPECS` read only outside a run.
**`check_iv` §2 holds the table**: 30 rows keyed `file|function|VARIABLE`, each with its read count and its sort — SWITCH (the sim's own
three), GATED (with the guard that must stand in its function's body), SIMPATH (a report reached only from the sim's end of count),
NONSIM (with its reason: `DOD_AUTOPLAY`, `DOD_ENEMIES_OFF`, `DOD_READOUT`, `DOD_DEBUG`, `DOD_ZONE_ROTATION`) — and `run_sim.gd`'s 21
reads as one block, the sim's path, entered only through the battle's run-sim branch. **A read nobody sorted reds**, and so does a
row whose read is gone, a read count that moved, a sim-family read behind no guard, and **a call whose variable is not a literal**
(no row could key it — the controls found this hole, §11). **And it is driven**: a player's run with six arms exported plays the game
it drafted (no grant, his relics, the encounter's warband, the full rune pool), and the positive arm — the same flag under the sim —
reaches the family. **`DOD_ZONE_ROTATION`** is a real run's switch read with no gate and inert today (FOUND AT IV): a latent arm reds
the day a slot pool holds two zones.

---

## §3 — THE FOUR REMAINING REPAIRS, AND THE CEILING AT ZERO

| the repair | the rows | the code | driven by |
|---|---|---|---|
| the strike loop writes its fallback bodies back | DV11 | `battle._resolve`'s choose-two/three fallback assigns `second_target` / `third_target` | `check_iv` §3: a Survivalist's Shrapnel Charge with no chosen second body poisons both it struck |
| the zone boss's pick asks the cap | DV29 | `RunSim._award_trophies` asks `ability_slots_full`; at the cap it benches the oldest carried card (`unequip_earned_ability`), else refuses — as `map_screen._pick_ability` asks a bench | `check_iv` §3: every hero at the cap, no kit past it |
| `_autoplay_pick` re-asks `_ability_usable` of its pick | DV05, DV06, DV07 | a rotation pick the door refuses falls back to the basic on the lowest broken, else lowest, foe — as an arm that found nothing does, so the kit card and the drafted hook are still asked | `check_iv` §3: Guard Change under Formless (refused) and without it (cast) |

**THE CEILING.** The census of record (`docs/reports/IU-bot-divergence.tsv`) amended in place: the ten closed, each *REPAIRED AT IV*
with its section, and DV01/DV02 (IU's) re-sorted CLOSED — **RULE 0, POLICY 14, MODEL 5, CLOSED 14**. `check_iv` §3b holds RULE ≤ 0
and every IV row closed with its batch named; **no POLICY row was changed**. Written beside `check_gw`'s hand-sets and IU §5's MISSES
in `docs/instrument-rules.md` — one practice, a count of a known defect's shape that fails only when it grows.

### §0.4 — THE CODE DECIDED S3-009

`CLAUDE.md`'s Momentum paragraph said a new blow path that bypasses the strike loop owes `note_blow_met` a call of its own; `check_ft`
§6c holds the call at one site. **Read in the code**: `battle._resolve`'s strike loop calls `note_blow_met` above the Block roll, and
the two enemy blows that would bypass it — Blood Tribute and the wind-up's landing — each resolve as a plain attack copy through the
loop (the Hysteria pattern). **The gate describes the code**, so the paragraph is rewritten — *a new blow path reaches the door by
passing that loop … never by a second call* — and S3-009 is re-read HELD in place. The census reads HELD 300, PARTLY 229, NONE 283
since; the standing list did not move (S3-009 was not cheap).

---

## §4 — THE THREE CLAIMS, AND WHAT THE OTHER TWO NEED

**Repaired, in the ledger of record in place** (`docs/reports/IU-claims.tsv`, each row's `stands`, `gone`, `note` and `tree` amended):
**IR01** — the qualification folded into its sentence (*… in `CLAUDE.md` — or, where it is about how a fight resolves and nothing else,
in `docs/combat-rules.md`*), and GR §2's paragraph now records the fold. **IR09** — the sentence is HY §6's rule (*a count restated
anywhere else points at it, or carries the batch that measured it*), and the two sanctioned-red counts that carry their batches stand.
**IR50** — the same rule in the second-copy bullet, one edit with IR09. `check_iv` §4 holds each: REPAIRED with IV in its tree, its
false words gone from the instrument rules and its true ones present, and **only ISF12 and ISN04 standing**.

### THE THREE SPINES — WHAT THE RULING NEEDS, AND NOTHING MORE (read-only)

Read on HEAD `91ce490` before any edit; line numbers are HEAD's. The full sweep is kept: **`docs/reports/IV-spines.tsv`** — 171 rows,
one a spine a line, every text file under the repo but `.git`, `.godot`, `save-backups/` and `DoD-archive/` (14 more lines there, all
in `state-archive.md`). **The `(core)` suffix is part of the authored name** (`data/runes.json`, since HL §2), not added by a screen.

| | **Warrior — Momentum** | **Mage — Channel** | **Cleric — Sanctity** |
|---|---|---|---|
| **what it does** | A Warrior who holds it books an *exchange* for every span between two of his turns in which he both dealt damage and was reached by the fight (he lost health, or a blow met him — blocked, parried or absorbed included); each exchange adds a step, up to 8, taking 4% off the delay of every turn he schedules after it that battle (−32% at 8). | A Mage who holds it gains a step for every 42 Mana he spends in a battle (every cast but a counter books at least 10), and each step, up to 6, adds +3% to the damage of his non-physical attacks (+18% at 6). | Every 13 status changes anywhere on the field in a battle — a status arriving on a body that did not carry it, or taken off by a cleanse, consumer or purge, never by its clock, once per body, status and turn — adds a step, up to 5, and each step adds 1 turn to every timed status the Cleric who holds it applies (+5 at 5). |
| **the rune's name** | *Rune of the Vanguard (core)* (`engine_momentum`) | *Rune of the Invoker (core)* (`engine_channel`) | *Rune of the Hierophant (core)* (`engine_sanctity`) |
| **the engine's name** (the ★ chip, the rule text's opening word) | *Momentum* | *Channel* | *Sanctity* |
| **where a player reads the name** | `data/runes.json:1012`; `docs/master.html:1382` | `data/runes.json:1036`; `docs/master.html:1388` | `data/runes.json:1060`; `docs/master.html:1394` and `:3463` (*a Hierophant's Sanctity*) |
| **the surfaces that show it** | the class-selection card's title (`spec_choice_screen.gd:134`), the rune panel, pouch, Peddler, cache, drop and kit preview (the instance's name, refreshed by id on load), the readout's `core` field | the same | the same |
| **record rows** (by name / by id) | 29 / 4 — `CLAUDE.md` 2, `docs/state.md` 3, changelog 1, kit-recon 6, reports 16, gates 1 | 31 / 4 | 92 / 4 — the bare noun *a Hierophant* carries most (84 rows): reports 47, gates 12, changelog 7, kit-recon 5, rule files 6, state 4, design notes 3, script comments 6, `baselines.json` 2 |

**No game script string names one of the three** — every `scripts/` hit is a comment. **No collision**: the three nouns occur in no
ability, status, relic, node, rune, enemy, item, zone, glossary entry or event; the near-misses bite only a substring matcher —
*Vanguard* contains *Guard* (Guard Change, Covering Guard, Feigned Guard, Mirror Guard, High and Open Guard, Waiting Guard, Honor
Guard), *Invoker* shares a root with the Mage's *Evocation*, *Hierophant* none. **Where *PROPOSED at GK* stands**: `CLAUDE.md:2688–2690`
(wrapped), `docs/state.md`'s RULINGS OWED, `docs/kit-recon.html:17`, and the ledger's ISN04 and ISF12 rows — **which `check_iu` §1
reads: it reds when a STANDS row's words leave their file**, so the parenthetical is held by a gate until the ruling moves the two rows.

---

## §5 — THE INDEX QUESTION, RECORDED AS CLOSED

**Where it was queued**: HN's shape-recon block in `docs/state.md` carries the close — *CLOSED AT IV §0.1 (the designer's): `CLAUDE.md`
IS NOT INDEXED, AND NOTHING IS STRUCK FROM IT* — with the derivation, not the conclusion alone: IU §2's 817 rules, HELD 299, PARTLY 229,
NONE 284, 112 of 120 blocks, and the census's own rule (*a rule with a gate is a reference and can be routed around; a rule with none
must be read, so its block is core*) that makes those numbers an answer: *AN INDEX WHOSE CORE IS 112 OF 120 BLOCKS ROUTES AROUND
NOTHING*. Its heading says it closed. `CLAUDE.md`'s ceiling block says so in one sentence, where it said the block index waited on the re-measure. **The pilot section** says the pilot ended
after three reports and why; its heading keeps *THE INDEX PILOT IS IS's* (`check_ir` §0 pins it). **The close-read is renamed and
kept** in the instrument rules (THE CLOSE-READ), and the index's fourth condition points there. **The standing list**:
`docs/state.md` gains *THE RULES A GATE COULD CHEAPLY HOLD* (188, 76 NONE), and `check_iv` §5 holds both counts as ceilings; IV moved
neither. **Nothing was struck from `CLAUDE.md`.**

## §6 — THE INDEX's POPULATION ROWS

**Derived from the last ten briefs (IL–IU), read-only, before any edit** — `docs/reports/IV-populations.tsv` keeps it, its method
in its own header: 208 subjects, each sorted THING (one named subject or an enumerated set) or KIND (a population asked to be derived,
swept, censused or disposed of as a whole); a kind gets a row when more than one brief asks for it. **Nine**:

| kind | briefs | | kind | briefs |
|---|---|---|---|---|
| the claims | 10 | | the latent shapes | 4 |
| the figures behind doors | 10 | | the save's keys | 3 — **added** |
| the closed matter | 8 — **added** | | the target picks | 2 — **added** |
| the positional picks | 7 | | the sim's recorded figures | 2 — **added** |
| the bot's divergences | 4 | | | |

**Against the six the brief expected**: five confirmed; **the rules dropped** — *every standing rule* is IU §2's subject alone, every
other brief makes or cites a rule as a THING; and four added. **The derivation is right**, as the brief said it would be. Each row names
its member blocks below the fence (the core, read whole, holds others, named in prose), its records outside the file and at least
three triggers; its stamp is the md5 of its members' texts in order, so a member's change reds it (`check_iv` §6; `index_stamp.py`
re-stamps it). **Three memberships moved at IV**: *the bot's divergences* lost FOUND AT IU and FOUND AT HR (their members archived,
built); *the latent shapes* gained FOUND AT IV (`DOD_ZONE_ROTATION`); *the sim's recorded figures* gained WHAT IV's DRIVE MOVED
(the marks) and Carried from the code (EQ's two marked prints, which the close-read found the row did not name) —
`IV-populations.tsv`'s `members_at_iv` column.

---

## §7 — HOUSEKEEPING

- **THE MOVE IS NOT ATTEMPTED** (IB §4). `./lane.sh spent` prints the one command; 604 user-data folders at the open and at the close (every lane reused a name; 271,288 → 272,400 KiB), the strays the two known (`IT const probe`, `[unnamed project]`).
- **`lane.sh` for every launch** — the drive's two lanes, the work, docs, probe, control and trace lanes, the recons; the acceptance
  ran in the repository as the live project, through `./run_battery.sh`, as every acceptance does.
- **The designer's files** — backed up first, read only through copies; md5s at the open and the close above.
- **The close's timestamp** — 2026-10-25 08:40:00.

## §8 — WHAT IS DELIBERATELY NOT DONE

- **No figure is re-taken** (§1c): the drive measured, the marks record, and the batch that authors the deck's middle re-takes.
- **`CLAUDE.md` is not indexed and nothing is struck from it**; §5 records the close.
- **The 188 cheap gates are not built**, and the 76 NONE rules among them are a standing list.
- **The 438 pins stay pinned; the thirteen standing positional picks stay** under IU's ceiling; `check_it` §2c's arm is not widened;
  `check_hn` §2a's worn arm stands; the Chilled row keeps its *4*; the latent floor shapes and the Cryomancer's route stay.
- **The ally pools are not widened** (DV03), and **no POLICY row of the divergence census is changed** — DV28's cache policy included.
- **Nothing of the deck's middle, and no modifier is authored.**
- **GK's three names are not ruled or proposed** — reported (§4).
- Standing and unchanged: no crest rune re-cut or authored, the crest cap at one; the vow, the recoil floor and Anointing untouched;
  the third slot ungated; the art not commissioned; a copied Frostbind's refusal RULED, NOT BUILT; Mana stays; a meter is not a
  conjunction half; Marrowfire's re-cut and `CONJUNCTIONS` holding Rupture alone; Contagion's and Reckoning's re-cuts; the
  Occultist's Break card; the Skirmisher and the Tracker; Channel's tempo payout; the fallen-hero ruling and its seven things;
  Rupture's shape.

## FOUND AT IV AND NOT FIXED

- **TWO GODOT PROCESSES IN ONE LANE SHARE ITS `user://`, AND A GATE THAT WRITES THE HARNESS SAVE RACES THE OTHER.** `check_ho` on
  IV's work lane read 179 / 2 beside three gates launched into the same lane (§4d: *hollow_chalice is not a retired rune the save
  brought back worn*), 179 / 1 beside `check_fh` alone (§2c: *the save the fall wrote did not load*), and 179 / 0 alone; `check_fh`
  168 / 0 each time. `lane.sh` launches into a lane already running a process and says nothing. Only a batch's own subset runs meet it
  — the battery is sequential.
- **`DOD_ZONE_ROTATION` CHANGES A REAL RUN's ZONE DRAW WITH NO GATE, AND TODAY CHANGES NOTHING** — every slot pool holds one zone;
  `check_iv` §2 reds the day one holds two.

## NEEDS A RULING

1. **GK's three spine-rune names** — confirm or rename each (§4 holds what the ruling needs); the parenthetical in `CLAUDE.md` and the
   ledger's two STANDS rows go with it.
2. **One process a lane** — a lock in `lane.sh`, or the rule written beside IQ §7's lane block.
3. **Whose switch `DOD_ZONE_ROTATION` is** — a play switch the readout names, or a sim's — before a pool holds two.

## §9 — THE ROUTING, A STEP WITH A WRITTEN OUTPUT

**Written first** (23:16, before any edit; `docs/reports/IV-routing.md`): the brief's thirteen subjects, the 35 rows whose triggers
name them (each trigger verbatim), the 15-block core — and **§6's population rows were not yet available to it**, which the record
says. **At the close**: the 50 blocks opened whole (135,555 B of HEAD's 326,275), the ones IV needed, and **the close-read** — a
reader over the 85 blocks IV did not open, whole (147,295 B; the table kept in IV's work folder, `route/close_read.tsv`): **8 bore,
one of them stale; 3 ROUTED, 5 NOT ROUTED**, every unrouted row given the trigger the reader found missing. **The stale one was the
working read's own miss**: §1c's figure sweep met EQ's sentence by grep and marked its 3.44 acquired, and left the 6.98 bought
beside it — a sentence met in part is not a sentence read. It is measured (−0.58 ± 0.10 a run) and marked. **Two that bore stand by
design**: FOUND AT IN's `_take_offer` comment (DV30, a POLICY row the brief does not change, cites it) and FOUND AT GR's ways-of-working
header (its own recorded item, not IR01's sentence). **The upkeep**: 28 of the index's 147 entries, 24 by hand (IU: 30 of 135, 27).

## §11 — VERIFICATION

**WHAT WENT IN BEFORE WHICH RUN.** **The routing, written, first** (23:16); **§4's spine read and §2's sweep of every environment
read, read-only** (23:2x–23:4x); **the code** — §1's two repairs, §2's gates, §3's four — **and its parse** (`check_parse` 238 / 0, no
`Parse Error` in stderr); **§1c's drive against the unchanged tree, on its own** (23:39 → 02:58), before any document moved; **the
literal sweep over the code before recon 1's prediction** (`check_ed` named, the manifest's floor in it); **recon 1** (02:5x → 04:28);
**then every document**, built as scratch copies by script (`edits/`, one replay from HEAD: `rebuild_final.sh`), swept, and **landed
behind a hash guard** (`land_repo.py`: every repository copy HEAD's byte for byte before, every landed md5 the lane's after);
`check_iv` into the battery, the baselines rows, the manifest regenerated; **the pre-run, the close-read and the positional re-run,
recon 2, the controls, the `ok()` traces, the acceptance.**

**THE PUSH CHECK.** `git ls-remote origin class-merge` read `91ce490`, IU's push and local HEAD, before anything ran; the close's push is the batch's last act — `git ls-remote origin class-merge` is read after it and reported with the commit, since it cannot stand in the file it pushes.

**THE LITERAL SWEEPS** (IU's tool: every string literal the instruments hold, ≥ 4 characters, counted raw and flattened in each
edited file on both trees). **Over the code, before recon 1's prediction**: 470 rows over the eight edited files — 8 LOST, 56 GAINED,
410 MOVED; every LOST and GAINED literal walked to its holders not already pre-run, and every negative needle among them read
(`test_batch_bi` counts `m += 1` in `battle.gd`'s `_faith_stack_mult`; `check_gm` reads `battle.gd`'s `["equipped"] =`): none a red.
**Over the documents, before recon 2**: 25,411 instrument literals over ten edited files — 20 LOST, 43 GAINED; none a document pin.
**Two needle hazards caught in IV's own drafts before anything landed**: six of `check_iv`'s document needles wrapped across a line
(the manifest resolves raw lines) — each re-wrapped onto one; and `check_ir` §0 pins `docs/state.md`'s *THE INDEX PILOT IS IS's*,
which the renamed index heading keeps.

**THE PREDICTION, AND RECON 1 — the battery on IV's code with HEAD's documents** (lanes/work, 161 targets, 02:5x → 04:28).
**Predicted**: `check_parse` 238 (237, `check_iv.gd` on disk), `check_fm` 84 (83, §1d's leaked arm), `check_ed` 18 / 2 (the stale
`check_fe` entry and the unrecorded pins, until the manifest's regeneration), the manifest's floor 1,987 held, `check_ec` 24 / 0,
`check_ho` 179 / 0 alone, every live drive at its baseline (no battery target drives RunSim's victory, merchant or walk — only the
drive and `check_iv` reach §1a and §1b; DV05's re-ask and DV11's write-back reach every bot battle), the sanctioned reds as HEAD's.
**Read**: every predicted line; **no seeded road re-selected** (`check_de` named nothing else); and one line the prediction missed —
**`check_ec` 31 / 8**: §2, the manifest's document half, read `check_iv`'s seven document needles against HEAD's documents, which do
not hold them yet — IU's recon-1 miss exactly, and mine for the same reason: the pre-check of `check_ec` was taken before the gate's
last edits and not re-taken. Cleared when the documents landed (24 / 0 — the rise was a failing check a missing needle, not a
population move).

**THE PRE-RUN** (the final tree, rebuilt from HEAD by script; 70 targets on two lanes, one process a lane, then 71 again on the
closed tree): every target at the final baselines. **Found by it and repaired before recon 2**: `check_fg` 35 → 39 — §4b asserts
each fenced-structure claim four ways, and IV's is the second (its row moved); `check_ec`'s provisional row withdrawn (above).

**RECON 2 — the final tree, frozen** (05:23:14 → 06:49:39, 162 targets): **exactly as predicted.** The only reds are the two sanctioned (`check_cm_live` 13 / 5, `check_gj` 70 / 1); `check_iv` 115 / 0, `check_parse` 238, `check_fm` 84, `check_fg` 39, `check_ec` 24 / 0, `check_ed` 18 / 0, `check_iu` 185 / 0; **`check_de` 665 / 0 with 0 notices**; the harness 22 / 382 / 8. The md5 freeze of 539 files, the lane's and the repository's, the same after as before.

**THE POSITIONAL AND SUPERLATIVE RE-RUN** (IT's census re-derived on IV's final tree by a reader; the kept table is in IV's work
folder, `route/positional_iv.tsv`): **489 reads — 98 unchanged by construction** (the gate and every file it reads byte-identical),
**391 re-derived: 157 SAME, 234 LINE-SHIFT, 0 ELSEWHERE. 0 went from ASKS to MISSES**, and none from MISSES to ASKS: the 13 standing
MISSES still miss, IU's seven repairs still ask. Windows that grew onto IV's text without moving their verdict: `CLAUDE.md`'s
instrument index (+2 rows) and ceiling block (§0.1's sentence), `run_sim.on_battle_end` (§1a's lines), `battle._resolve` (§3's
write-back) under `check_ic`, `ij`, `ik`, `im`, `io` and `ir`, `_spawn_units` (§2's gates), the state file's index span. **IV's edits
moved no read off its subject.** (The reader read the tree before the close's last state-file lines — the readings, the fenced claim,
six triggers, one member; the gates that read those windows are green on the closed tree.)

**THE MANIFEST AND `check_ed`.** 1,987 → **2,040** (`check_iv`'s holders and `check_fe`'s re-point); the floor re-recorded, no fall;
its ten unresolved pins exactly HEAD's ten — none of IV's. `check_ed` 18 / 0.

**THE CONTROLS** — one fresh clone of the final tree each (`tools/ctl.py`: the anchor asserted once before the edit, three lanes, one
process a lane), read by their FAIL text:

| | the break | the arm that red, in its own words |
|---|---|---|
| C01 | the cache left unanswered | 115 / 3 — *§1a: THE DRIVE — the sim's victory left 2 rune picks owed and answered 0 of the 2 its bargain and its elite queued: a run's rune supply is short of the player's*; *§1a: THE ORDER — the sim's victory does not claim, roll the draft, roll the cache, answer the draft and then the cache (937, 1437, 1560, 2310, -1)* |
| C02 | the cache answered, but before the draft | 115 / 1 — *§1a: THE ORDER — the sim's victory does not claim, roll the draft, roll the cache, answer the draft and then the cache (937, 1437, 1560, 2346, 2287)* |
| C03 | the potion bought at the stack cap | 115 / 1 — *§1b: THE GOLD MOVED WHERE THE DOOR REFUSES — a potion bought at its stack cap of 6 cost 30 gold and landed nothing* |
| C04 | the rune bought where the counter refuses (a full holding) | 115 / 2 — *§1b: THE GOLD MOVED WHERE THE DOOR REFUSES — a rune bought for a hero holding 8 unworn, the bag full, cost 150 gold*; *§1b: the counter's refusal for want of room was not booked as the door's* |
| C05 | DOD_SIM_GRANT_ALL ungated again | 115 / 2 — *§2: 1 sim-family reads stand behind no guard — a sim's arm leaks into a player's game: ["battle.gd\|_ready\|DOD_SIM_GRANT_ALL — its guard `if sim and OS.get_environment(\"D*; *§2: DRIVEN — `DOD_SIM_GRANT_ALL=1` armed a player's debug grant* |
| C06 | a third environment read added, ungated | 115 / 1 — *§2: 1 environment reads nobody sorted — a new arm, read with no row: ["battle.gd\|_ready\|DOD_SIM_C06 ×1"]* |
| C07 | the fallback bodies left local | 115 / 1 — *§3: DV11 — the bot's Shrapnel Charge poisoned 1 of the two bodies it struck: the fallback body was not written back* |
| C08 | the rotation's door re-ask removed | 115 / 1 — *§3: DV05 — under Formless the rotation still cast Guard Change, where the player's button is dark: the rotation's pick does not ask the door* |
| C09 | the boss pick's cap check removed | 115 / 1 — *§3: DV29 — the zone boss's pick took a hero past the cap: ["warrior 8 of 7", "mage 8 of 7", "cleric 8 of 7", "hunter 8 of 7"]* |
| C10 | a RULE row left unrepaired and unnamed (DV24) | 115 / 2 — *§3b: THE CEILING AT ZERO — 1 rows sort the bot playing by a different rule, and a RULE row is repaired in the batch that finds it, never recorded: ["DV24"]*; *§3b: 9 of the ten IV repaired are closed in the census with IV named* |
| C11 | a moved figure left unmarked | 115 / 2 — *§1c: 6 recorded figures the drive shows moved stand unmarked in docs/state.md — a known-moved figure is SUPERSEDED-PENDING with its delta and the batch that owes the re-t*; *§6: 1 population rows are broken: ["the sim\'s recorded figures\'s member block changed and its row was not re-read (stamp 0aeda8, members 77d68b)"]* |
| C12 | a population row deleted (the target picks) | 115 / 2 — *§6: 1 kinds the derivation gave a row have none in the index — a brief about the kind matches no trigger: ["the target picks"]*; *§6: the index carries 8 population rows against the derivation's 9* |
| H01 | HEAD's code under the final gate (four counters and two refusing doors stubbed, nothing else) | 115 / 23 — §1a (10), §1b (4), §2 (6), §3 (3); the first *§1a: `Run.take_rune_pick` is not the door — it does not answer out of `rune_choice` and hold a core rune unworn through `hold_rune`* |
| H02 | HEAD's documents under the final gate | 101 / 28 — res:// (2), §0.1 (3), §0.4 (1), §1a (1), §1c (3), §2 (1), §3 (1), §3b (2), §4 (10), §5 (2), §6 (2); the first *§0.1: CLAUDE.md does not say it takes no index — the derivation closed the question* |
| R01 | a re-tune: the cache's rune policy at its source (a core rune first) | 115 / 0 — **green, as wanted**: §1a and §1b read the door, not the choice |

**THE CONTROLS FOUND THREE HOLES IN `check_iv` ON THEIR TRIAL RUN, EACH REPAIRED BEFORE THE OFFICIAL ONE**: §2's population pattern
could not see a variable name with a digit (C06 did not bite) — widened, and a shape arm added (every environment call names a
literal); §1b's rune arm read the draw order the sections above it left (C01, R01 and two more red it where the base did not: the
Peddler can roll a crest rune, which a full holding does not refuse) — the negative arm fills the bag too; and four compound
messages printed one sentence for two conditions — each prints both halves now.

**THE `ok()` TRACES** (IV's work folder, `oktrace/`: every assertion printed, HEAD's tree against the final). `check_fm` 83 → 84 =
*§1d: `DOD_SIM_RUNES=stats` reached a draw with no sim running* (the leaked arm); its three other pairs are the same arms naming a
different hero — the extra draw moves the stream after it. `check_parse` 237 → 238 — its own counter, traced by printing every path
its walk verifies: 233 → 234, the one more `res://check_iv.gd`. `check_fg` 35 → 39 — §4b's four checks for IV's claim. `check_de`
661 → 665 — a target's four assertions for `check_iv`.

**THE ACCEPTANCE** — the repository, as the live project, through `./run_battery.sh` (07:13:08 → 08:39:19, 162 targets): **exactly as predicted.** The only reds are the two sanctioned (`check_cm_live` 13 / 5, `check_gj` 70 / 1); `check_iv` 115 / 0, `check_parse` 238, `check_fm` 84, `check_fg` 39, `check_ec` 24 / 0, `check_ed` 18 / 0, `check_iu` 185 / 0; **`check_de` 665 / 0 with 0 notices**; the harness 22 / 382 / 8. The repository's md5s the same after as before; the designer's files the same after as before. **This report's close fields were filled after it** — the acceptance read it with its placeholders; `check_iv` §4 is the one reader of this file (the three spine names), and it read 115 / 0 on the frozen tree with the filled file in place.

**THE TWO READINGS** (IQ's method on both files: the net, what was cut to the archive, fenced structure stated apart).
`CLAUDE.md` **488,395 B = 476.95 KiB, 33.05 KiB under its 510** — +2,235 B, nothing cut: the bot's door and RULE 0 +627, the
sim-family flag rule +708, the index question's close +427, the strike loop's sentence +225, the instrument index's two rows +170,
the cache door's re-read +78. `docs/state.md` **344,016 B = 335.95 KiB, 44.05 KiB under its 380** — +17,741 B net, **10,159 B of it
fenced structure** (the nine population rows and the pilot's close, inside the index's fence) **and +7,582 B outside it**, under ES's
+13,700 record — the preamble claims the fenced part and `check_fg` §4b holds it; the archive took 4,705 B, the closed items word for
word with the cut's heading.

**HOUSEKEEPING.** The user-data folders: 604 at the open and at the close (every lane reused a name) — 272,400 KiB at the close; the strays
are the two known (`IT const probe`, `[unnamed project]`). `./lane.sh spent` prints the one clearing command; **the move is not
attempted.**
