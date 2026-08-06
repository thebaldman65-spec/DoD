# Design Notes

Why things are the way they are. master.html holds current truth,
changelog.html holds what changed, this holds *why*. Newest first.
Not exported to docx.

## Three to start, six to earn (Batch AH) — 2026-08-05

**A kit that is complete on turn one has nothing to say for the rest of
the run.** Every spec shipped with its whole identity already in hand;
the only things that changed across a run were numbers — talent ranks,
rune payloads, tier scaling. Progression you can *read on the action bar*
is a different kind of thing from progression you read on a stat sheet,
and this batch buys it with content that already existed. Nothing new was
written: everything earnable is either an ability trimmed out of an
opening kit, an ability a talent already grants, an ability a sibling spec
already starts with, or a vaulted one whose machinery never left the code.

**Two pools, because "any ability" and "your spec's abilities" are both
wrong.** A pool of only your spec's leftovers makes six awards feel like
a checklist — you know the whole list by award two, and by award four you
are taking what is left. A pool of everything makes an awakening
meaningless. One spec draw and two class draws keeps the spec's identity
the *reliable* part of the offer and puts the surprise in the other two:
a Cryomancer who earns Flamewave is still a Cryomancer, but he is one who
now has an answer to a frost-resistant band.

**The curation rule is the whole design of the class pool.** An ability
that arrives dead is worse than no offer at all, because the player spent
a real choice on it and only finds out two fights later. So the test is
not "is this thematically close" but "does this FUNCTION for a sibling" —
and applying it strictly is what makes the pool trustworthy. Arcane
Cannon is the clearest case: handed to a Pyromancer it deals 40% of
Attack, zero Break damage, and recoils 15% of what it dealt. It is not a
weaker version of the Arcanist's nuke, it is strictly worse than his
basic attack. The line I settled on and applied uniformly: an ability
belongs to the class pool when its PRIMARY effect resolves without the
spec-only mechanic; riders and perfect bonuses that quietly no-op are
worth a note, not an exclusion. That keeps Hold Breath (a guaranteed
armour-ignoring crit, with a dead Focus rider) and drops Coup de Grâce
(which spends Focus and does nothing else).

**Guard Change is the honest cost of following an instruction.** The
batch named the Swordmaster's three keepers, and the arithmetic put Guard
Change in the pool — which means until he earns it back, he cannot swap
stance, half of Seasoned Fighter is inert, and four of his talent nodes
sell him something he cannot use. I shipped it as written and flagged it,
rather than quietly substituting Sweeping Strikes back in, because the
designer named those three explicitly and a silent reinterpretation is
the worse failure. It is a one-line fix if he disagrees.

**The mini-boss is a floor, not a spike.** The reason it takes the whole
row is that an *avoidable* guaranteed fight is a contradiction: routing
around it is exactly what a player optimising the map would do, and then
the zone's progression beat only lands for players who were not paying
attention. Giving it a boss's health rather than a boss's damage was the
other half of that: it should be the fight that tests whether your kit
can sustain, not the one that decides the run on a bad initiative roll.
The measured consequence is that it is *not* a spike — it is a long
fight, and that is what "between an elite and a boss" turned out to mean
mechanically.

**Paying for it out of the fight cards was the conservative choice on
purpose.** The row could have been taken out of the deck proportionally,
which would have cost roughly half a rest and half a shop per zone. Every
run-economy number this project has measured since Batch T — gold earned
and unspent, rests offered versus taken, shops walked past, rune
acquisition — is anchored to 5/5/3. Changing a structural thing and an
economic thing in the same batch means the next measurement cannot tell
you which one moved. So the mini-boss is paid for entirely in fights, and
the economy dials are byte-identical.

**Reliability perfects, continued.** Batch AG converted Wildstrikes and
wrote down why: on a wide, swingy ability, magnitude on top of variance
is just more variance, while removing the roll is something the player
can feel and plan around. This batch applies that to seven more, and the
useful discovery is that the rule *finds bugs*. Triple Shot had
`multi_hits: 2` and an empty `perfect_text`, which meant it fired two
arrows and a Perfect silently added a third that no tooltip mentioned —
an ability called Triple Shot, firing two. Nobody would have found that
by reading the file; the rule found it by asking "what magnitude does this
Perfect add, and can it go?"

**One escape from the boss immunity, spelled out at the call site.** Two
of the eight perfects buy their way past a rule the whole game leans on
(bosses shrug off Stun until Broken). The tempting implementation is a
name check inside `_apply_status` — and it would have been three lines
shorter. An explicit `force` argument costs a parameter and puts the
exception where a reader can see what bought it, which matters more for a
rule that is load-bearing for boss design than for one that is not.

## The opening pick offers a rune for your spec (Batch AF) — 2026-08-04

**The lever was never weak; the thing it was allowed to offer was.**
Batch AE shipped the starting rune and measured it delivering 0.49 spec
runes per hero against the 1.18 projected. The obvious reading — the
lever is too small, make it bigger — was the wrong one, and AE's own
diagnosis said so: the ordinary roller put a spec-scoped rune among the
three only 36–42% of the time, and the sim's policy took one at exactly
that rate. The policy already preferred a spec candidate. It was taking
one *whenever there was one*. The ceiling was the roller's hit rate, and
no amount of magnitude on the entries would have moved a number that was
really about how often they were on the table.

That is worth writing down because three batches went the other way.
AA, AB and AD all asked whether the authored pool was strong enough, and
AD's honest answer — power and dilution are two factors of one product,
each masking the other — still framed the fix as a magnitude question.
Raising an offer rate beat three batches of arguing about magnitudes,
and it cost one opt-in parameter.

**Guarantee, not weight.** A weighting would have nudged a probability
and left the outcome mushy — sometimes your spec rune is there, usually
it is, and the player never quite learns what to expect. A guarantee
makes the opening pick a reliable *question*: do I take the rune written
for my spec, or the generic one that is stronger right now? That
question is worth putting in front of a player in their first ten
minutes, and it can only be asked if it is always on the table. The same
reasoning is why the guarantee is one candidate and not two — a triple
of spec runes is not a question, it is a menu.

**Opt-in and defaulted off, because the roller is shared.** The elite
cache calls the same function, and a guarantee that leaked into it would
have been invisible until a Matrix row drifted several batches from now.
The parameter defaults to off and exactly one caller arms it; the test
asserts that by seeding the RNG and replaying the pre-AF loop against
the default path, because "it looks the same" proves nothing about a
random roll.

**The fallback is silent on purpose.** If a hero's spec has no eligible
entry — an unmet `requires_ability`, a spec whose set is exhausted — the
pick falls back to an ordinary roll of three. No error, no empty slot,
no half-filled triple. A guarantee that announces its own failure to the
player is worse than one that quietly degrades to the thing that came
before it, and the sim reports the fallback count so the failure is
visible to the designer instead.

## The tester's workbench (Batch AC) — 2026-08-04

**A debug tool that can reach a shop makes some summaries lies, and the
summary is the alpha's feedback channel.** That is the whole reason the
honesty flag shipped in the same batch as the capability rather than
after it. Batch Z built the run summary specifically so a tester can
paste a wipe report straight back as feedback — depth, build, damage
split, economy, what killed them. It is telemetry-grade data with no
telemetry to build, and its entire value rests on the reader being able
to trust that the numbers describe a real run. The moment a tool exists
that pours +200 gold into a run or teleports the party into a shop, some
fraction of those reports describe something else, and nothing on the
page would say so. A designer reading twenty pasted summaries has no way
to tell the three poisoned ones apart.

The flag costs one boolean and two lines of code, and it is written at
the top of each debug dispatch rather than on each item — seven write
sites would eventually become six, and the one that got forgotten would
be the one a tester used. Once set it never clears, including when a
check item is unchecked, because "I turned it off again" is not the same
claim as "this run was clean". A tool whose safety depends on the tester
remembering to be careful is not safe.

**Why free travel books its tally and a summoned node does not.** These
look like the same feature and they are opposites. Free travel puts the
party somewhere the map would not have let them go — but once there,
they really fought that fight, at that tier, and really spent that gold.
Suppressing the record would produce a run whose ledger disagrees with
its own history, which is a worse lie than the one the flag exists to
prevent. A summoned node is the reverse: the party never went anywhere,
the board is untouched, and the fight happened in a kind of parenthesis.
Booking it would silently inflate the economy line of a report someone
is going to read as data. The rule that falls out is simple — *record
what happened to the party, not what the tester conjured* — and it is
also why dying in a summoned fight ends the run but does not count as a
cycle lost.

**The event picker is the item that justifies the batch.** The other
tools save time; this one enables something that was previously
impossible. Events draw at the door, filter by requirement, and never
repeat within a run, so a designer could not choose which event to look
at, could not see one twice, and after three visits a zone had none left
to give. Authoring an event and then being unable to look at it is a
content pipeline with no feedback loop in it. Making
requirement-*failing* events selectable is the same argument pushed one
step: the branches a designer most needs to see are the ones the game
normally hides, and the event screen's own guards still run, so nothing
is being faked — only reached.

And once any event is addressable by id, a headless test can walk all of
them. That fell out of the picker for free and is the first real
coverage the events vocabulary has ever had; it is worth noticing that
the *testability* was a consequence of the *tooling*, not a separate
piece of work. Data-driven systems trade a compile-time error for a
silent one, and the price of that trade is a sweep that exercises every
row of the data.

## Hunter rune sets and a Shieldwall rework (Batch AB) — 2026-08-03

**Shieldwall and Interpose were one verb pointed in two directions.**
Both granted `shield_charges`; both fully negated the next attacks; one
aimed at the Warden and one at everyone else. Two abilities, one idea —
and the self-directed half was strictly the stronger of the two, because
a charge spent on the Warden is spent on the unit the enemies are
already taunted onto. A kit that spends two of its five slots saying the
same word twice has one fewer thing to say. Interpose keeps the
guarantee, because covering the *line* is the thing only a tank can do
and it has no substitute. Shieldwall gives the guarantee up and becomes
a stance: +25% Block chance, two turns. He guarantees safety for the
party and gambles for himself.

**Why the gamble is not simply a smaller guarantee.** Tenacity and Rally
feed on Heavy Plating blocks specifically, and Shieldwall's charges
never triggered them — a charge *bypasses* the block roll rather than
winning it, so the Warden's two payoff talents sat idle through exactly
the turns he was most protected. Moving the bonus into the roll changes
what a block IS: every block Shieldwall buys is a Heavy Plating block,
so it grows his max HP and rallies the party's healing. He trades hard
denial for an engine. That is the whole ability, and it is why the trade
is written into the ability description rather than left for a player to
discover — a trade nobody can see is not a trade, it is a nerf with
extra words.

There is a second-order effect worth stating because it is a real cost,
not a bonus: Heavy Plating's climbing bonus resets on any Block, so more
blocks mean a higher floor and a shorter climb. His mitigation gets less
spiky and more even. Whether that is better is a playtest question, not
a sim question.

**A note on what the measurement can and cannot say.** The Warden-party
rows below show damage-prevented attributed to him falling by roughly a
third — which is exactly what trading three guaranteed blocks for a 25%
chance should do, and it is the honest headline. What those rows CANNOT
show is the other half of the trade, because a standalone sim spends no
talent points: Tenacity and Rally are not in the party at all, so the
engine the ability now feeds is switched off in the very measurement
used to price it. The number is real and it is also only half the
ledger. The other half is measured in `test_shieldwall.gd`, where the
stance is isolated and its blocks are shown to drive Tenacity directly.

**The fossil.** The `raw *= 0.75` branch was Shieldwall v1 — a
party-wide percentage ward Batch G replaced and Batch Z later found
still sitting in the damage path. Deleting it is hygiene, not a change:
no ability, enemy or rune carried the specials that applied it. Worth
recording *why* it survived two batches — it read like a plausible
mistuned version of a live ability rather than the corpse of a dead one,
which is the general shape of the risk. A vault comment that names what
was vaulted (this one did) is what made the call decidable.

**Zero new machinery for twelve runes.** The Hunter sets add no cfg
fields at all — the budget was four, Batch AA spent one for
twenty-four, this one spends none. Every entry rides a talent counter
that already has a read site. That is not thrift for its own sake: a
rune whose effect flows through an existing talent's code path is a rune
that cannot silently do nothing, because the talent proves the path
works.

**The traps this class posed, and what was done about each.** The
Beastmaster's numbers land on up to three bodies — companions inherit
his armor at summon and per-beast terms count twice under The Pack — so
his scarred rune puts its *cost* on armor (-8%) and its upside on Quick
Shot, which is his own body only. The multiplication is named in the
rune's own text ("every beast he calls wears his plate") rather than
left as a hidden tax. The same property has been true of the class-wide
Wolf's Hunger rune since Batch X and was never written down; it is
written down now. No Hunter rune carries a healing term, deliberately:
Ancient Pact makes `no_heals` reject all healing, so a healing-flavoured
Beastmaster rune is a dead rune for anyone deep in Devotion — the same
silent dud as an unowned ability name, reached through a talent instead
of a kit. The Survivalist's meter lives on the *enemy* as Poison stacks,
so his runes write enemy-side effects and were not forced into the
second-resource mould the other eleven specs share.

**Two Sharpshooter runes deliberately write Focus ceilings.** Batch AA
moved the ceiling derivations below the rune-apply block specifically
because "the Hunter batch would have hit this on Focus", and then had
nothing in the pool that actually wrote one. Deep Sight (cap 150) and
the Long Draw (opens at 60) are the first runes to exercise that fix for
real, which is why `test_runes.gd` now also asserts the pool CONTAINS
such a rune: an ordering assertion guarding a road nothing drives on
proves nothing.

**Two known partial overlaps, stated rather than hidden.** The Deep
Bond's ceiling term does nothing for a Beastmaster who took Lone Bond
(cap 8) or Wild Rotation (cap 2), because those talents *replace* the
ceiling rather than add to it; the Deep Sight's cap does nothing for a
Sharpshooter running Spray of Arrows (cap 50), for the same reason. In
both cases the rune's other term still applies, so neither is a silent
dud — it is the ordinary case of a rune being worth less to a build that
already went that way, which is the per-lane rule working. It is written
down here so a later batch does not rediscover it as a bug.

**No epic in the Hunter twelve, on purpose.** Rarity means kind here,
not magnitude: epic is reserved for granting an ability, changing a
damage type, or inverting a rule. Nothing in these sets does any of
those, so calling one epic would have been a price tag pretending to be
a category. Five of the nine existing spec sets have no epic either.

## Mage and Cleric rune sets, and a forfeit (Batch AA) — 2026-08-03

**Why one rune per lane is a mechanism and not a hope.** Batch X built
the rune system and left the obvious question open: what stops an
authored pool from becoming twelve slightly different damage stat
sticks? The answer is the authoring rule, not the machinery. Each spec
gets exactly one rune per talent lane plus one that pays for splashing
out of a lane, and each lane rune writes that lane's *own* counters. A
Pyromancer who has sunk his points into Detonation and finds the
Kindling rune is being handed the top of a road he did not take — the
rune is worth taking precisely because it is off-build, and it is worth
*less* to the player already deep in Kindling, who has the talent
version. That asymmetry is what makes a rune a build decision rather
than a power increment: the same rune has different value to two heroes
of the same spec, decided by where their points went. The splash rune is
the counterweight — one term from each lane, so the player who wants
breadth can buy breadth instead of being forced sideways. Without the
per-lane rule the pool converges on "whatever is numerically largest"
and every hero of a spec ends the run with the same three runes, which
is the outcome the whole system exists to avoid.

**Why the counters are stacked and not duplicated.** A rune writing
`entropy_ranks` gives the Occultist the Entropy talent's effect at one
rank, and stacks with the talent if he owns it. That was Batch X's
design and it is the reason this batch needed only ONE new cfg field for
twenty-four runes: the lanes are already a vocabulary of small, read
effects, and a rune is a way to buy one word of it out of order. The
alternative — bespoke rune-only fields — would have meant twenty-four
new read sites in battle.gd, twenty-four chances for a silent dud, and a
second parallel effect vocabulary that drifts away from the first.

**Why the mage sets trade in element and the cleric sets trade in
direction.** The Pyromancer and Cryomancer are deliberate mirror images,
each armoured in his own element and soft to the opposite, so their
interesting runes are the ones that push on that identity rather than
adding damage: the White Flame thins the *resistance* his fire meets
(the one place the mirror actually bites) and charges him max health for
it. The Cleric's three specs are three answers to the same problem —
Holy restores, the Devout prevents, the Occultist siphons — so every
cleric splash rune carries a healing-flavoured term, letting each of the
three reach a little way toward *restoring* without becoming the
healer. Reaching toward a neighbour is the interesting direction; being
able to replace a neighbour is not.

**What the measurement actually said, and why it does not mean the
entries are weak.** Twenty-four runes moved nothing beyond noise —
completions, damage shares and contribution shares all land where the
control put them, and Holy in particular reproduces her Batch W numbers
almost exactly. The tempting conclusion is that the entries are
underpowered and the next lever is bigger numbers. The measurement does
not support that, because it cannot: the party buys about 2.4 runes a
run and picks a few from elite caches, spread across four heroes, and
this batch roughly *tripled* the mage and cleric spec pools. Deepening a
pool without changing how many draws a hero gets makes each individual
entry rarer, not stronger — a given Holy now carries one or two of her
four. If rune power is ever the thing to move, the honest first question
is whether heroes see enough runes for authored power to be legible at
all; raising numbers to compensate for a draw rate would be tuning the
wrong dial and would land badly the day the draw rate changes.

**Why the Arcanist and Occultist scars are not paid in blood.** Both
already bill their own health as a resource — Resonance charges +5%
damage taken per stack and Arcane Cannon recoils 15%; the Occultist's
Leech lane and the Pact of Flesh / Dark Barter choice are literally his
body traded for the party's. A scarred rune that adds damage taken
*compounds* with a cost the spec is already paying, and at the wrong
number it converts a ramp into a coin flip. So the Arcanist's scar is
paid in Mana (his cooldown relief comes with a regeneration cut, and his
recoil relief drains the same pool) and the Occultist's is paid in heals
*received* — the chalice fills for everyone but him. The rule
generalises: a scar should cost a resource the spec is not already
mortgaging, or it stops being a trade and becomes a multiplier on an
existing risk.

**Why Holy's runes will look like they did nothing.** She was measured at
28% contribution off a 5% damage share. Any rune that improves her
improves a number the damage line cannot see, so the temptation is to
hand her damage instead, which would make her a worse Holy. Her set
buys healing throughput, an extra Mercy in hand, and — the epic —
Resurrection without the Mercy-lane investment. Judge them on the
contribution table. This is the same denominator lesson that made the
Sharpshooter's "38%" a stale artefact.

**Why an alpha needs an exit from a state the designer has deliberately
not fixed.** The endless-battle stalemate is a balance question, and it
is open on purpose. But "open" and "unescapable" are different things.
The guard that handles it is sims-only; a human who hits it — about one
in three testers doing five runs — can only force-quit, which costs the
run and arrives back as "the game froze" rather than as an opinion.
Forfeit does not resolve the stalemate and must never be described as if
it did; it converts an unrecoverable state into a recorded one. Ending
the run exactly as a wipe does is what makes it free of balance
consequence: forfeiting is strictly worse than winning, so there is
nothing to exploit and no number to tune. The reason picker is most of
the value — a forfeit with "this fight will not end" attached is a bug
report, and a forfeit with "not enjoying it" attached is the single most
useful sentence an alpha can produce. And the forfeit books its own
Profile bucket rather than a wipe, because the moment testers start
using the exit, a chronicle that folds the two together stops being able
to answer how often the party actually died.

## The map node economy (Batch Y) — 2026-08-03

**Why the map came before more tuning:** the map was documented as a
route-planning surface, but two generation rules made that aspirational.
The 70% adjacent-link roll left most nodes reaching one or two nodes —
measured, **53% of nodes reached exactly one** (worse than the 30% the
rule implies, because edge columns could roll an out-of-range neighbour
and end up with nothing). And the 30-card deal was blind to position:
nothing guaranteed a rest in the back half, a shop before the boss, or
an elite anywhere near your path. Measured before the change: **1.58
reachable nodes per step and a real choice on 34% of steps**. A map
that offers one reachable node most of the time is a corridor with
decoration — the player is walking, not routing, and every system that
assumes routing (rest economy, elite snowballing, shop timing) quietly
under-delivers. That was Batch U's rest finding in different clothes:
the deck said 5 rests per zone, the walk could reach about half.

**Why constraints on the deal rather than a smarter deck:** the deck
composition (17/5/5/3) is a tuned quantity; what failed was *placement*.
Constraining the deal (no three-of-a-kind tier, recovery spread across
both halves, a shop in the boss run-up, an elite floor) keeps the
composition intact and only removes the degenerate arrangements. The
route guarantee — one walkable route touching two rests, a shop, and an
elite — is checked with a graph walk at generation, because nodes
merely existing is a suggestion, not a plan.

**Why this is an alpha batch, not a balance batch:** the target is a
rough playable alpha — a build a human can sit with for a couple of
hours and form an honest opinion about whether the game is fun.
Legibility and agency are the deliverables; wider reachability makes
the game easier as a side effect (more rests and shops get taken), and
that is *reported, not compensated for* — Batch T still owns the
difficulty numbers and the designer closed difficulty pending human
playtesters. Same logic for the **Wanderer** road: at current numbers
almost no runs see zone 3, so almost no honest feedback about a third
of the game exists. Wanderer is one multiplier folded into the zone
ladder (one number, one read site, trivially removable), labelled a
testing affordance everywhere it appears, and defaulted off in every
sim so no baseline row can be contaminated.

**Why the tooltips say what the event does not:** rests and shops now
state exactly what they do (the rest quotes its real heal percentage,
relics included) because a tester's first read of the screen should be
"these are my options." The event stays "???" on purpose — but the
tooltip *says* it is unknown instead of staying blank, because "the
designers didn't write this" and "this is a mystery" read identically
as silence.

## Runes become a build system (Batch X) — 2026-08-02

**Why an authored pool and not a bigger generator:** relics got a
19-hook vocabulary and 25 authored entries; events got 12 verbs and 16
authored entries; runes had six stat templates and a rarity multiplier.
The design work simply never happened there. Generated numbers can make
a hero bigger; only authored trade-offs make two runs *different* — the
same precedent that carried relics and events. The batch was cheap for
one reason: `Talents.apply_payload` already had every branch the system
needs, so authoring became a JSON edit, not new machinery.

**Why rarity means kind rather than magnitude:** ×1/×2/×3 on a stat
stick is one decision repeated three times at three prices. Common =
stat, Rare = alters your abilities, Epic = changes a rule gives each
tier its own *question*, and the zone-slot weight shift (60/30/10 →
25/45/30) means the answers get more interesting exactly as the run
deepens.

**Why slots grow with the run:** every prior batch measured the same
wall — zone 1 roughly right, runs die in zones 2–3 against a ×2.2 base
multiplier, with no in-run power source that keeps pace with depth.
Nodes are +2% linear, talents are bounded by the tree, relics never
grow. A third and fourth rune slot is depth-scaling power that is also
a *decision* each time, and it rode ahead of the pool so the two levers
could be measured apart.

**Why one rune per talent lane plus a splash-payer:** the lanes already
exist and are already named on the party screen, so hanging runes on
them makes build variety structural rather than hoped-for — the
Berserker who finds the Bloodletting rune plays a different run from
the one who finds the Fury rune, and both are legible.

**Why scarred is a flag, not a rarity:** a downside is a modifier on a
promise, not a tier of power. Pricing scarred *below* clean makes the
trade visible in the shop before the tooltip is ever read.

**Why the elite drop became a pick of 3:** elites are the reward the
map is supposed to be routed toward, and a random rune on a random hero
was the least agency in the game. The candidates roll at drop time and
are stored, so save-scumming a screen open rerolls nothing.

## Closing the difficulty gap (Batch T) — 2026-08-01

**Why the curve had to move and not the heroes:** across a zone, enemy
power grew ~3.5x — budget 4.5 → 11 average compounded with tier scaling
— against the party's ~1.12x from node scaling. The counterweight the
economy assumed (roughly 35 talent points a run) was gated behind
surviving long enough to earn it, and runs died at tier 5 holding 2.8
points per hero. That is a feedback loop, not an offset: attrition
throttled the very income meant to answer the enemy curve, which is why
small hero-side nudges could never move it and the batch attacked the
enemy curve first. The proof is in the income column — untouched by any
stage, it rose 3.8 → 9.3 points per hero per run purely because the
party lived longer, and those points are what carried runs deeper still.

**Why the ladder is a ramp:** two discontinuities over eleven tiers put
40 of 50 wipes on the first step. A player reads a difficulty cliff as
their own failure; a slope they read as the game escalating. The boss
node keeps its old band on purpose — the step INTO the boss chamber is
the one place a cliff is the message.

**Why the first fight no longer starts hurt:** the awakening raised the
ceiling but not the water line — a promotion that arrived pre-wounded.
Correctness, not tuning; it shipped first and measured separately so
the tuning stages sat on an honest baseline.

**What was deliberately left:** tiers 1–2 read above the 1.0–1.3 band
(gentle onboarding vs the metric's letter) and tiers 9–10 below it; the
skipped talent-income stage is the record that the mid-band no longer
needed it. Where the difficulty line belongs — the floor bot reaches
the zone-1 boss in 40% of runs, clears the game in 4% — is the
designer's taste question, not a solved equation.

## Swordmaster stances (Batch D) — 2026-07-28

**Why the passive had to change:** the old Seasoned Fighter was a
stance switch the player couldn't switch — HP decided which side was
live, so it was a consolation prize: healthy, have damage; hurt, have
armour. Nothing to build around, no skill expression. A master of
technique who cannot choose his own guard is backwards; the fantasy IS
the choice of guard.

**Why each stance carries a downside** (+10% taken / −10% dealt): if
Aggressive were strictly free damage, Defensive would be the only
"decision" and only when dying — the old passive with extra steps. The
downsides make the swap a trade at every health total.

**Why Guard Change isn't a free action:** actions that don't consume a
turn need engine support that doesn't exist, and a full-turn swap is
too dear in a 7–9 round fight. So the swap does double duty — stance,
15 BD, 15 Rage — at 1.5 initiative. If playtesting still finds it too
expensive, the fallback is building true free actions (flagged, not
guessed at).

**Why the BD auto-targets the highest Break meter:** the ability takes
no target so autoplay can never hang on a picker (the sim-hang rule),
and thematically the swordsman presses the opening he already made.
Un-Broken only — BD on a Broken enemy is a dead stat.

**Why he gets a 12% parry BASE:** seven tree nodes touch parry off a
5% base, so their payoffs almost never fired — over-invested,
under-rewarded. Raising the base makes every parry node and both
counter-attack payoffs live without touching them (that's Batch E's
job). Stat identity mirrors the Warden: one Block-stat character, one
parry-stat character.

**Why 165 HP / 22% armor:** between the Berserker (175/15, glass
brawler) and the Warden-to-come — the technician reads as the middle
warrior at a glance.

**Why the ability exists:** Blood Frenzy rewards being low, but nothing
in the kit let him *choose* to go low — enemies decided when he got
strong. Blood Price is the throttle. Costing **current** (not max)
health makes it cheap as an opener and a real gamble when low: the
same button reads differently at 175 HP and at 50.

**Why it can never kill him:** a self-execute button on the party's
aggro magnet is a trap for new players and a degenerate bot line in
sims. The 1-HP floor keeps the gamble in damage-taken space, where the
Frenzy floor already banks it.

**Why Wildstrikes' perfect moved to bleed:** a bleed spec's perfect
should pay in bleed. The +50% BD ride came free from the generic aoe
perfect rule, not from a design decision.

**Sim note for the next conversation:** hero deaths/battle rose 0.34 →
0.42 with the rotation casting Blood Price 1.7×/battle. Self-inflicted
damage on the aggro magnet was the predicted cost; whether 0.42 is
acceptable is a designer call, not a code fix.

## Berserker rework — 2026-07-27

**The core problem:** Blood Frenzy read his own HP, Bleed read enemy
meters, Rage read neither — three systems that never talked to each
other. And nothing in the kit let him choose to go low, so enemies
decided when he got strong. A Ramp archetype with no player-controlled
ramp is a passenger.

**Blood Frenzy floor (half the peak, never falls):** fixes two faults at
once. Bloodlust healed missing HP, which deleted the passive it was
meant to support — the kit fought itself. And "Ramp" didn't ramp:
missing-HP scaling doesn't compound over a fight. The floor makes each
dive ratchet permanently, so healing banks the gain instead of erasing it.

**Armour 25%→15%, HP 154→175:** effective HP is 154/0.75 = 205 versus
175/0.85 = 206. Survivability unchanged within 0.3%; what changes is
texture — bigger visible pool, chunkier hits, more Frenzy runway, more
Rage from being hit.

**Frost −0.15, not the standard −0.25:** a hero eats far more attacks
per fight than any single enemy, so a full-strength vulnerability
compounds much harder on him.

**Bleedout resets the bleed meter,** which deletes the scaling that
Crushing Blows and Battle Shout both read — the payoff punished the
setup. The Bloodletting lane is being split into "keep wounds open"
versus "burst them" so the reset becomes a choice rather than a bug.

**Berserker lanes (Batch C):** Bloodletting now pays at the burst four
ways — heal, Rage, transfer, and a permanent damage ramp — so the
meter reset the previous note flagged becomes a choice rather than a
loss. No node was deleted in the re-spec: ids are save-keys, and a
re-spec that renames beats a refund that orphans. The dull dials went
first because two were literal duplicates of neighbouring nodes
(Gushing/Savagery, Feast/Bloodcraze), and a duplicate is a wasted
decision. Scent of Blood is the one node that compounds over a fight —
a "Ramp" archetype was strangely missing one. Scar Tissue deepens the
Batch A floor rather than adding a new number: talents near a passive
should make the passive read better, not longer. Undying Rage reuses
Hold the Line's death-refusal instead of a second code path — one
rule, two doors. Measured Rage moved beside Reckless Fury because an
exclusive pair split across lanes reads as a bug: the player must see
both doors in one column.

**Swordmaster (Batch E) — one loop, not three hobbies:** the kit held
parry, stun, and Break as parallel interests until the boss
stun-immunity rule turned them into one machine — Break is the key,
stun is the door, the Broken window is the room. Everything now serves
that loop: Pommel's stun went from a coin flip to a promise (priced in
Rage and cooldown, not odds), Shatterpoint is the moment he chooses to
turn the key, and its free Overpower drives through the door the
instant it opens. Overpower used to peak just before the Break and
fall off a cliff when the meter reset; the hold-them-Broken rider
makes it good on both sides of the Break, so a one-turn window becomes
a window worth building toward. Lunge reads the stance instead of a
health threshold Batch D made vestigial — the player picks the wound,
and Guard Change gets a second reason to exist. Execute answers to the
loop too: a capstone should pay off the spec's own setup, not stay a
generic low-HP snipe.

**Swordmaster tree (Batch F) — the engine finally got a lane:** Duelist
and Poise were the same lane twice — six nodes all answering "what
happens when I'm hit" split across two columns — while not one node in
all 24 touched Break, the spec's entire engine since Batch E. A tree
should mirror the kit's verbs, so all parry consolidated into Poise
(where High Guard already lived) and Duelist became Breaker: fill the
meter, then live inside the window. The stance exclusive died in
Batch D for the same reason the new one lives in Breaker: exclusives
are only interesting when both doors are real builds of the SAME plan,
and Punishment ↔ Off Balance is exactly that fork — pile the Broken
payoff into one button, or spread it across the kit. Deflection is the
tree's most important single node: parry was melee-only, so a 12%-base
stat with six feeding nodes did nothing in half the game's fights —
one rank turns a dead cluster into a build. Bracing rekeys Defensive
stance from "takes less" to "cannot be moved," which is what raising a
guard means. Tempo pays the player for pressing Guard Change, the
button the whole spec turns on; the bot now pivots on cooldown when
healthy for the same reason. Guard Breaker is the Breaker thesis
stated as a win condition: the meter half-refills on recovery, so the
guard never truly returns.

**Warden kit (Batch G) — reliability is the tank's agency:** Block was
his identity and he had no say in it: a flat 20% roll, with four
talents paying off on Block — heals, max-HP banking, party healing,
stuns — that a bad streak could simply switch off. That was the same
fault the other two Warriors had, and it lands hardest on a tank,
because the tank fantasy isn't gambling: the party needs to KNOW he
will hold. The pity ramp (+8% per unblocked hit, reset on any Block)
deliberately doesn't let him choose the moment — that would undercut
Shieldwall, which IS the chosen moment — it guarantees the moment
arrives on a dependable cadence, roughly every third attack, that a
party can be built around. The chip shows the live total because a
promise only reads as a promise if the player can watch it being
kept. Shieldwall graduated to the base kit for the same reason: a
spec's one point of control over its signature mechanic cannot live
behind a talent wall. Interpose adds the verb every tank kit in the
genre is measured by — take the hit FOR someone — and rides the
existing Shieldwall-charge machinery, so the purest tank moment costs
no new systems. War Stomp's perfect finally got a payload because the
ability's real cargo was always the party refuel, not a 75-Attack
character's damage. The stat block (200 HP / 32% armor / Con 130 /
fire+frost plate with an arcane hole) makes the three Warriors
unmistakable at a glance — the Berserker is the pool, the Swordmaster
the blade, the Warden the wall — and the arcane hole keeps the wall
honest: enemy casters have a real line on him.

**Warden tree (Batch H) — a tank can't spend damage:** half the
converted tree was damage nodes on a 75-Attack character. Iron Will's
old payoff — +45% of a number that small — was about fourteen damage
at full investment: mathematically a bonus, experientially a shrug.
Every offensive payload was therefore converted into a currency a
tank actually banks — mitigation (Iron Will now takes 4%/rank LESS
per debuff, so being covered in filth is armor, same name, same
fantasy, working direction), Break pressure (Bruising Guard turns
the most-attacked character into a quiet Break engine for the whole
party), threat (Provoke widens the taunt; Grudge aims his remaining
damage at whoever he holds), and party protection (Shared Vigil pays
the party for keeping HIM healthy, which makes healing the tank feel
like healing everyone — the right incentive loop; Steadfast is the
lane's thesis in one node: he eats what would have killed you).
Battered Not Broken exists because a Broken unit cannot Block at all
— Broken doesn't just hurt this spec, it switches its identity off —
so blocking now works to hold that fate off, and the Immovable
capstone removes it outright (precedent: the Devout's Bulwark of
Fortitude). Vengeful Guardian is once per TURN, not per block: at his
block rate against a full field, per-block would be a free rotation.
The Spite ↔ Bruising Guard exclusive is in-lane where a fork reads
as a choice; the old cross-lane pair read as a bug and is gone.

**Cleric stat blocks (Batch I) — max HP is an output stat:** for every
Cleric spec, maximum health sets output, not just survivability,
because the whole class heals in percentages of the caster's own
maximum — Heal 40%, Renewal 15%/tick, Divine Shield 30%, Afterglow,
Healing Pulse, the Faith release, the Ruin detonation, Dark Pact's
regrowth. So the pools were set tall (150/175/155 against a 121 class
base) and the armour spread carries the identity instead: the Devout
wears 18% as the armoured shrine, the Holy 10% as cloth, the
Occultist 8% because he already pays for power in blood. The Devout
is the tallest BY DESIGN — his bulk is the party's bulk. The
Occultist's planned −20% holy weakness died in the roster audit:
nothing in any warband deals holy damage, and a vulnerability that
never bites is flavour text wearing a stat's clothes. Fire replaced
it — the only swap that keeps every entry in his resist block live
somewhere in the run (shadow vs hexers, nature vs both forests, fire
vs the burn zone) — and it reads right: the cleansing flame is what
corruption should fear.

**Holy lanes (Batch J) — the tree finally touches Empower:** six of
twenty-four nodes were "deepen another node," and two of the three
capstones were +2 ranks of something already owned — a capstone should
be a new way to win, not a bigger number on a thing you have. And
nothing anywhere touched Empower, the ✦ spend-a-stack-forgo-the-perfect
toggle that is the most interesting decision in her kit (the same shape
as the Swordmaster's Break having no lane before Batch F). So Mercy
became the lane that runs the economy end to end: Zealous Light fixes
the cold open (she started every fight at zero — Hymn uncastable on
turn one, the held-stack bonus nonexistent), Ardor turns Empower from a
surcharge into a rhythm (bank to the threshold, spend freely above it —
holding was already rewarded, so the threshold is a live choice, not
bookkeeping), and Avatar of Mercy makes the engine unconditional. The
Radiance fork asks one question — what happens to healing that would
have been wasted? — and answers it twice: Cascade pays crit investment,
Overflow pays raw output. In-lane, where a fork reads as a choice; the
old cross-lane Zealous ↔ Serenity pair read as a bug and is gone.
Serenity itself became the safety net's signature (a guaranteed
once-per-battle save beats a passive -8%), checked AFTER a unit's own
death-refusals so the Berserker's rage still gets its moment. Living
Sanctum echoes single-ally healing only — Hymn already IS the party,
and an echo that echoed itself would be a balance loop, not a fantasy.

**Devout lanes (Batch K) — Faith gets its second source:** Conviction
described a party-wide system that had exactly one single-target
source on a 2-turn cooldown — Divine Shield's absorbs — so most of
the party sat at zero Faith for most of every fight, and Blessing of
Zeal doubled a gain its target never had (the bot shielding the
weakest while kindling the hardest hitter meant the two abilities
never even met). Fervor is the batch: Faith drips off Consecrated
Ground, party-wide, riding a base-kit cast rather than a talent — the
passive finally behaves like its own description, and the ground is
worth casting for more than its mitigation. The lanes reorganize
around subjects instead of accidents: Bulwark owns the shield (Faith
comes FROM it — a shield lane and a Faith lane were one idea split in
half), Faith owns the stacks, Zeal owns everything else he casts. The
Stalwart ↔ Bastion fork moved in-lane and asks the shield lane's only
real question — bigger, or more often? — and "more often" doubles as
the second fix for the one-source drought. Cleansing Waters and
Healing Pulse key off either banner now because three nodes riding a
node inside their own lane meant skipping Sacred Resolve killed
nearly half of Zeal. Purity exists because doubled Faith gain should
carry a Faith source with it; its shield goes through the same grant
path as every other so the divine flag (the Faith trigger) can never
be forgotten. Apostle parks the party at maximum Conviction and turns
every absorb into a heal — the win condition the Faith lane was
pointing at all along — and Judgement gives a support spec a seat in
a damage party by paying out the one currency he never touches:
Break pressure, straight into the Swordmaster's loop.

**Occultist lanes (Batch L) — three good ideas, one loop:** the
07-24 rework left him the most mechanically complete spec in the game
— Ruin, Psychosis, Decay, Bewitch and Hysteria all interlock — but the
three lanes never fed one another: Madness turned enemies on their
fellows, Ruin built toward detonation, Leech converted suffering into
health, and nothing converted madness into Ruin or either into
healing. Delirium and Cackling Mirror are the batch: a maddened enemy
striking its fellow now marks the victim with Ruin and pours a share
of the wound into the party, so the tree's flashiest moment (an enemy
turning) advances the meter AND the health bars — three lanes running
one loop. Entropy exists because he is a Pressure spec and the mark
should grind on its own — and because a Ruin engine that emits Break
damage buys him a seat next to the Swordmaster the way Judgement did
for the Devout. Whispers is a reliability fix disguised as a dial: at
50%, half of every Psychosis was a wasted turn and the lane felt like
a coin, not a plan. The exclusive moved in-lane (Pact of Flesh ↔ Dark
Barter) onto the one ability where he trades his body for the party's
— pay less, or get more — because a fork should be a question about
ONE thing. Avatar of Ruin is the natural end state of a lane built on
filling a meter (the maxed target becomes a recurring bomb, kept safe
by construction: seeded Ruin only primes, and primes only fire at
their bearer's own turn). Soul Glut makes the "lesser healer" real
through his own mechanic rather than borrowed Holy tools — every
hero's strike into a Ruined enemy is party sustain — keeping the
healing philosophies distinct: Holy restores, the Devout prevents,
the Occultist siphons.

**Mage stat blocks (Batch M) — the Arcanist carries the most health
in the class because his health bar is a resource, not a buffer:**
Resonance bills him +5% damage taken per stack (25% at 5, and
Overcharge pushes the cap to 8) and Arcane Cannon recoils a flat 15%
of the damage it deals back onto him — he pays for his own power in
health, the way the Devout's party pays in shields. So he gets the
biggest pool of the three (155) and the least armour (6%), with a
physical vulnerability because raw energy in robes stops nothing
that closes the distance. The Pyromancer and Cryomancer take no such
penalty — they are symmetrical glass cannons (135 / 8%), built as
mirror images: each armoured in his own element, soft to his
opposite, so it reads instantly on the warband resist card and a
fire warband asks the party a genuinely different question than a
frost one. The Cryomancer's 36% damage share was deliberately NOT
touched — that is the difficulty pass's job, where it can be
measured, not a change to smuggle inside a stat block.

**Pyromancer burn engine (Batch N) — the kit could not reach its own
passive:** Flamewave extended Burn without ever applying it (the
spec's only AoE could not start a fire) and Wildfire's spread was
strict-Adjacent, so corpses choked it — which left single-target
Fireball as the only reliable igniter and made Inferno Master's
five-burning-enemy cap physically unreachable. One clause fixes the
spec: Flamewave now ignites (2 turns to every enemy) and the whole
loop exists — Kindling builds the fire, Inferno profits while it
burns, Detonation cashes it in. Detonation stays a single-target
nuke on purpose: which enemy to cash in is the decision the player
makes, and hitting the whole field is a talent build (Chain
Reaction, Cataclysm), not a baseline. Wildfire keeps its identity
against Flamewave by scaling: Flamewave is a flat 2 turns to
everyone, Wildfire copies HALF of one stacked burn to everyone —
stack one target tall, then spread, is the combo the bot rarely
finds but a player will. The 50% sim damage share is flagged, not
tuned: this batch's brief was making the loop exist; the number is
the difficulty pass's dial.

**Cryomancer (Batch O) — Permafrost now means what its name says:**
his own win condition needed 4 Chilled stacks on one target while his
main applier hit 2 random enemies, every reapplication reset a shared
3-turn clock so whole piles evaporated at once, and the freeze wiped
the stacks — the payoff destroyed the engine, the same fault the
Berserker's bleedout and the Pyromancer's detonation had. Permafrost
is ground that doesn't thaw, so the fix starts at the root: stacks he
applies never expire, which turns Blizzard's field-wide 1-2 stacks
from evaporation into preparation and makes every Frostbolt progress
that keeps. Razor Ice concentrates (three shards, one chosen target)
because Control means choosing WHO freezes; the freeze leaves 1 stack
(all 4 under Absolute Zero) so Hypothermia and Hungering Cold keep
ticking through the payoff; and a boss that resists the freeze keeps
sitting on its stacks, which converts the old wasted-freeze-on-boss
into a held threat that springs the moment it Breaks. The Frostbite
clause left the passive because −50% healing is dead weight against
the many warbands with no healer — Rime keeps it where it is chosen.
The 46% sim damage share (36% before) is recorded, not tuned: this
batch's brief was making the cold hold; the number is the difficulty
pass's dial.

**Arcanist (Batch P) — a ramp that doesn't flatline:** Resonance
built +1 per cast, capped at 5, and persisted all battle, so a Ramp
spec reached its ceiling around turn five of a 7-9 round fight and
then every further cast wasted its own mechanic — Backlash Ward paid
exactly once because it fired only on the TRANSITION to max, and the
one talent that fixed it (Unlimited Power) shouldn't be the price of a
spec not wasting its resource. Now every gain at the cap restores 15
Mana: the ramp keeps paying in a different currency once it can't pay
in stacks, and it fuels exactly the Cannon and Wrath casts a maxed
Arcanist wants to make. Stabilize was the other half of the problem —
his only risk lever consumed ALL stacks, taking him from +75% damage
to zero in one cast, which is why the bot only pulled it as a panic
button. It vents only the stacks above 2 now (the Berserker's Frenzy
floor, the Pyromancer's ember, the Cryomancer's remainder: spending
shouldn't delete the engine), a deliberate trade — the emergency
full-vent got weaker in exchange for venting often. The tree's new
exclusive is the sharpest fork the spec can offer: Arcane Ward (run
permanently hot, the penalty barely bites) against Still Mind (vent
constantly, venting costs almost nothing) — never stabilise, or
stabilise all the time. Suppressing Fire and Temporal Rift moved to
Overload because a Barrage ramp and a crit echo were never Control.

**Hunter close-out (Batch Q) — a visible node the player can never buy
is worse than no node:** the Beastmaster shipped three capstones and
one of them didn't exist, so take-one-of-three was really
take-one-of-two — every run that pushed 8 points into the Pack lane
hit a "Coming soon" wall at the payoff. The Pack now does what its
node always promised: two beasts at once, both striking, each with
its own meter and boon, a third call replacing the lower Loyalty.
The companion plumbing became an array with the single beast as a
one-element case precisely so no code path forks — the alternative
(a second named slot) would have meant two branches through every
companion site forever. Kill Command orders BOTH beasts because a
capstone should make the spec's signature button better, not pose a
bookkeeping question. The stat blocks close the last class without
them: the Beastmaster wears less armour than the Survivalist despite
similar Constitution because companions inherit it — his armour is
worn by up to three bodies. The Sharpshooter stays the flagged damage
outlier on purpose; with the win rate saturated at 100%, tuning him
now would be tuning blind. That's the difficulty pass's job.

**Fix the instrument (Batch R) — the 100% win rate was two hundred
copies of one easy fight:** every balance number the project has
collected came from `./sim.sh`, and `./sim.sh` never varied the
encounter. The hypothesis going in blamed the DOD_SIM_BUDGET default
of 6; the truth was one step worse — that default only applies when a
theme is forced, and the plain sim ignores the budget system entirely,
spawning the same hardcoded raider/chief/archer/archer lineup (power
7, unscaled, pre-dating the theme system) for every single battle. So
two hundred battles measured one easy early-game fight two hundred
times, with nothing varying but dice. A 100% win rate against that
lineup is correct and meaningless, and the ~85% target had no
encounter attached to it. The sweep exists so a win rate is always a
curve across the budget ladder, never a single saturated point — and
the first honest curve shows the game already gets harder with budget
alone, before enemy tier scaling (+4%/+5% per tier, which the sweep
deliberately excludes) is even in the picture. The companion finding:
heroes grow +2% per win while zone-1 warbands grow ~3.5x across the
ladder — the gap is meant to be closed by talents, trophies, and
relics, and whether it IS closed is now a measurable question instead
of a guess.

**Measure a real run (Batch S) — two instruments the tuning list was
waiting on:** damage share had only ever been measured against one
field size — the fixed four-enemy lineup, and then the sweep's pooled
report — while the flagged outlier (the Cryomancer at 45%) is an AoE
control spec whose share against a six-body Swarm and a two-body
elite band are different questions with different answers. The sweep
now breaks out damage share, average enemy count, and enemies still
standing at round 3 PER BUDGET, because field size is the confound
that makes the Cryomancer question answerable: a share that climbs
with enemy count is an AoE problem, a flat one is a numbers problem,
and those are different batches. And no tool had ever simulated the
progression that is supposed to close the enemy scaling gap — Batch R
measured warbands growing ~3.5x across a zone against the party's
x1.12 from node scaling, and the entire counterweight (roughly 35
talent points, trophies, relics, elite runes) had never once been in
a simulated fight. The run harness plays whole runs with progression
on both sides and measures the two power curves instead of modelling
them. Its bot is dumb on purpose — every choice is a fixed policy
printed in the report header, because a clever bot makes numbers
unattributable; shops buy nothing in v1 so the result reads as a
floor on real play, not an estimate of it. Whether progression closes
the gap is the central balance question of the game, and it now has a
measuring stick.

2026-08-01 — Batch U: an honest floor. The wipe cluster every tuning
decision leaned on was measured by a bot that walked past every rest
node into fights at 45% health — five of thirty map nodes are rests
and the old route policy treated them as a last resort behind combat,
so some unknown share of the tiers-4-7 cluster was a routing artefact
rather than a difficulty fact, and the two questions could not be
separated until the harness could play cautiously. The fix is three
route policies, deliberately dumb and one axis apart: greedy keeps
the old floor byte for byte so every prior number stays comparable,
default rests below 65% average party HP, cautious below 80%. One
number is a point; three are a band, and real play sits somewhere
inside it. The same batch retires the two loudest exclusions — shops
now buy (heal-first, then the priciest offer that fits, never dipping
below a 40-gold reserve so the next heal is always reachable; runes
only onto a free slot because the sim cannot visit a party screen)
and heroes drink a carried Health Potion when a turn opens below 35%
health. Both policies are conservative on purpose: they establish
that gold and items MATTER without making the bot clever enough to be
unattributable, and both flag off (DOD_SIM_SHOPS/DOD_SIM_ITEMS) to
reproduce the old floor. Nothing was tuned in this batch by design —
Batch T owns the numbers; this batch tells us what T's numbers mean.

## 2026-08-01 — Batch V: enemies that ask questions

Sixteen enemy kinds shared three special behaviours between them
(a shield, two heals), so fights had no decisions in them while the
heroes had nothing but: Burn into Detonation, Chilled into Freeze,
Ruin into detonation, Break into stuns — engines idling against stat
blocks. The rule for every new kind: pose a question a specific hero
spec is the answer to. Not a counter — a question; the player should
feel a reason to have BROUGHT someone. The Ritual Chanter asks "do
you commit to stacking?" (its cleanse strips the longest-lasting
debuff — one Chilled stack at a time, never the pile, or the answer
stops being a question and becomes a wall). The Ash Hurler asks "can
you interrupt it?" — the game's first telegraphed mechanic, and its
Constitution 90 IS the design: Breaking the wind-up is the
Swordmaster's whole loop given a reason to exist. The Bloodcaller
asks "what order do you kill in?" with no right answer — AoE feeds
it, focus leaves the warband standing. The Grave Totem asks "did you
bring the right damage type?" — trivially Broken, physically
resistant, and 50% soft to fire and holy, a resist puzzle whose
answer is party composition. The same batch caps mender-tagged kinds
at two per warband, counted by tag rather than by claiming pool: the
generator could previously roll three or four healers (2,007 such
warbands existed), and two heals plus a cleanse is a wall, which is
the one thing a question must never be.

## 2026-08-01 — Batch W: the outlier pass measures before it designs

Every simulation in this project had run the same four specs —
berserker, cryomancer, inquisitor, beastmaster, the default in
sim.sh, the sweep, and the run harness — so eight of the twelve
specs had NEVER appeared in a damage-share report. The number we
kept citing as the game's worst outlier (Sharpshooter 38%) predated
half the roster's rework and came from a party we no longer test:
we were tuning against a fossil. Rotation (DOD_SIM_ROTATE=1) exists
so a claim about a spec must come with a sample count attached.

Second, three specs were invisible rather than weak: damage share
was the only per-hero metric, so the Devout's 3–5% was an artefact
of asking a Warder how much damage he does. His work — barrier
absorbs, Faith mitigation, Break pressure — happened off the books.
The contribution metrics (healing done, damage prevented, Break
damage, statuses applied) are not balance targets; they exist so
"is this spec doing anything?" has an answer before anyone reaches
for a number to change. Base armor and resists are deliberately NOT
counted as prevention: a stat block is not a contribution, and if
they were counted every frontliner would read as a guardian angel.

Third, the Cryomancer: his share FELL as fields widened (48% at
budget 3 → 40% at 12), which acquits his AoE — an AoE outlier
climbs with field size. The culprit is concentrated single-target
burst, and the mechanism is Batch O's Ice Lance clause (+10% of
Attack per Chilled stack) sitting on top of permanent stacks and an
auto-crit. Halving the clause to +5% keeps its purpose (a reason to
lance outside the Frozen window) and removes the excess. Permafrost
permanence and Razor Ice's three shards stay: they fixed a real
structural fault, and reverting them would reintroduce it. One
change at a time; the freeze-remainder knob (Batch O's declared
lever) stays in reserve, measured before touched.

The rotation's first outing found three latent harness/kit faults that
eight-never-simulated specs had been hiding: _log building a UI text
buffer in headless sims until the TextServer RID pool blew (a 13-minute
sweep became 3 hours and 500 MB), a run harness that printed nothing
until the very end so slow was indistinguishable from stuck, and — the
real one — the Warden's Endurance stacking armor with no cap. That last
is a genuine softlock: armor grows each unhealed turn, which makes him
unkillable, which makes the fight longer, which grows armor. Measured at
+97,521%. It is a design fix, not a harness fix, so it is reported and
left for the designer; the sims get a counted, loss-scored stalemate
guard so the instrument can never wedge on a kit bug again. The general
lesson is the batch's own: an instrument that has only ever pointed at
the same four subjects is not measuring the game, it is measuring the
four subjects — and everything it never pointed at accumulates faults in
the dark.

## 2026-08-02 — the difficulty question, closed

Batches V and W both ended by handing the same question back to the
designer: the mender cap moved the wipe median more than a tier, and
Batch V's own rule says a move that size is a decision, not a side
effect. The answer is that the current difficulty stands — good for now,
and fine-tuning it needs many human playtesters rather than another sim
pass. That is the right call for a reason the sims themselves keep
demonstrating: the bot is a floor, not a player. It never retreats, never
optimises a build, never plays around a telegraph, and Batch W showed it
cannot even be trusted to represent the roster evenly unless explicitly
told to rotate. A floor tells you where the game is unplayable; only
humans tell you where it is fun. Further difficulty work waits on them.

## 2026-08-02 — the Warden softlock, and a lying chip

The first diagnosis was wrong and the correction is the interesting part.
Endurance was reporting +97,521% armor, so Endurance looked like the
runaway. But effective_armor() has always ended in minf(a, 0.85): that
number never touched the damage path. The chip was lying, not driving —
and a lying readout is a good way to send an investigator at the wrong
subsystem, which is exactly what it did.

The real loop is Tenacity feeding Unkillable. Tenacity grants +5 max HP
per Heavy Plating block with no bound, and Unkillable mends a PERCENTAGE
of max HP per block. Each block therefore enlarges the pool the next
block heals from — a percentage heal reading off a quantity that the same
trigger inflates. Max HP reached ~127,000 and each block mended 7,607.
At the armor clamp he takes 15% of incoming damage and out-heals it
forever, so the fight cannot end.

The general shape worth remembering: a percentage effect should never
read off a value that its own trigger grows without bound. Capping
Endurance at +75% was still right — a readout must never advertise what
the damage path cannot grant — but it fixes the display, not the loop.

The fix chosen was the Unkillable side rather than a cap on Tenacity:
Unkillable now mends off base max HP, so Tenacity keeps its full
identity (+5 max HP per block, unbounded, battle-long) while the
compounding link is simply cut. Cutting a bad dependency beats capping a
good effect — the cap would have bounded the symptom and left the same
trap in place for the next talent that reads max HP off a block trigger.

Then the fix was measured, and the stalemate rate did not move (5 → 6 per
50 runs). So that diagnosis was wrong too. The debug log of an actual
stalled battle settles it: one surviving Warden, three dead teammates,
against five enemies including two healers and a shieldmaster — 92
heal/shield events while he lands 17-damage strikes. He cannot die and
cannot kill. The runaway armor and the runaway mend were both things
that HAPPEN during a battle that lasts thirty thousand turns, not things
that cause one. Two diagnoses in a row mistook a symptom for a mechanism
because each was found by reading the log for the most alarming number
rather than asking what the log said about who was still standing.

The real question this raises is a design one: the game has no way to
resolve a fight neither side can finish. A durable low-damage survivor
against a healing warband is a legitimate board state, reachable in real
play, and today it simply never ends.

## 2026-08-03 — Batch Z: an alpha exists to answer one question

An alpha is not a small version of the game. It is an instrument for
answering a single question — *is this fun?* — and every property it has
should be judged by whether it sharpens or blunts that answer.

Judged that way, the build had two holes that had nothing to do with
content. At the front, a tester met an initiative timeline, a timing
check on every action, Pressure and Break, seven damage schools with
resists and vulnerabilities, a bleed meter that pops at 100, five
different spec resources, lane-gated talents on a rising cost curve,
runes with scopes and scars, boss trophies, and relics — with no
explanation anywhere. The tooltips are good, but every one of them
explains a *number*: this warband resists nature, this talent gives 4%
per rank. None of them explains a *system*. A tester who does not know
what Pressure does is not playing the game that was built, and their
feedback describes their confusion instead of the design. That is not a
tester failing; that is the instrument returning noise.

At the back, twenty minutes of play ended in two lines of text and a
button. No depth reached, no cause of death, no record of the build that
had just been assembled and lost. Both of the things a run ought to
produce were being thrown away: the player's sense of closure, and the
designer's data. A tester playing five runs in a session got five voids.

So this batch built the shell rather than more content — a glossary, two
orientation cards, and a real run summary. The glossary is deliberately
data-only (`glossary.json`, the same pattern as enemies and events), and
its authoring rule is the load-bearing part: **entries are written from
the code, never from the master document**. Batch Y is why. There, a
documented 70%-adjacent-link rule turned out to produce 53% single-link
nodes in practice, because the rule as written and the rule as
implemented had drifted apart. A glossary written from the doc would
teach a tester the intent and then let them be confidently wrong about
the game in front of them — which is worse than teaching them nothing,
because uncertainty at least prompts a question. Writing all sixty-six
entries from the read sites also served as an audit: this time the
document held up, and the corrections it did need were small (a relic
line saying "six damage schools" where the game has seven non-physical
plus physical, a shop-node count off by one, two stale lines in
CLAUDE.md). That the audit came back nearly clean is worth recording;
the discipline is working.

The one-time pointer at the skill check is the highest-value item in the
batch, and it is worth being explicit about why. The design's premise is
that the player's execution matters as much as their build. A tester who
never notices there is a timing window on every action experiences a
game where their choices are only half-connected to outcomes — and will
report, accurately from where they sit, that it feels shallow. That is a
review of the onboarding masquerading as a review of the combat system.
One card, shown once, removes an entire category of false feedback.

The run summary's Copy button deserves its own line. It is four lines of
code and it converts every wipe into a structured report a tester can
paste back — the run's depth, the party's build, the damage split, the
economy, and what killed them. That is telemetry-grade feedback with no
telemetry to build, no consent question, and no infrastructure. When the
cheap version of a thing gets 80% of the value, build the cheap version.

Two implementation choices were made against the tempting alternative,
both for the same reason. The summary needed run state that
`clear_save()` destroys, and the obvious fix — clear the save *after*
showing the summary — would have opened a window where a dead run is
still resumable. A missing summary is a disappointment; a resurrectable
corpse is a corrupt save. So the summary takes a snapshot first and the
save logic was not touched. Likewise, the per-run damage ledger had to
live outside the battle scene, because that scene reloads between
fights; it went onto `Run`, and it writes only in real play so the
simulation harness's own statistics path stays the single source of
truth for balance numbers. In both cases the rule is the same: when a
new feature wants to reach into load-bearing machinery, give the feature
its own path instead.

## Batch AD — the instrument was the finding

Two batches in a row concluded that the authored rune pool "does not move
completions beyond noise". Both were right about the number and wrong to
draw a conclusion from it, and the reason is worth recording because it
will happen again in some other system.

Completions sat at 2–12% on samples of fifty runs. That is one to six
runs. The smallest difference two fifty-run rows can actually distinguish,
at that rate, is something like fifteen percentage points — so a genuine
and large improvement would have been reported as noise in exactly the
same words. The measurement was not wrong; it was incapable, and nobody
had ever written down what it was capable of. The proof turned up for
free while setting the batch's control: the same commit, on the same
flags, measured three separate times, returned four per cent, ten per
cent and eight per cent. Nothing had changed at all.

The fix was not a bigger experiment. It was a better metric. Depth
reached — how far up the ladder a run actually got, averaged over runs —
gives every single run a vote instead of asking each one a yes/no
question about a rare event. It resolves a real difference at a quarter
of the sample size, and it turned a question two batches could not answer
into one that a single afternoon of rows answered decisively. Completions
was never the thing anyone cared about; it was just the number that was
easy to print.

There is a second lesson underneath the first, and it is the sharper one.
The batch existed to separate two hypotheses — the runes are too weak, or
the runes never arrive — on the assumption that one of them was right.
Neither was. Raising acquisition alone moved nothing. Raising power alone
moved nothing. Doing both together moved the primary metric by ten tiers
and completions from eight per cent to sixty-one. The two candidate
causes were never alternatives; they were two factors of one product,
both near zero, each perfectly masking the other. Any experiment that
varied one at a time — which is every experiment run on this system so
far, including the careful ones — was guaranteed to report "no effect"
no matter which explanation was true.

So the habit worth keeping is not "measure before you change things",
which this project already does. It is: when two explanations are offered
for one null result, check whether they multiply before assuming they
compete. And write down what your instrument can see *before* you ask it
a question, because an instrument that cannot resolve the answer will
still cheerfully print one.

## Batch AE — the lever went on, the magnitude did not

Batch AD found a system worth ten tiers of depth that was switched off, and
it deliberately did not choose which switch to throw. The designer chose:
one starting rune, dealt at the awakening, where a run can still be saved
by it and where a player will see it in the first ten minutes. That part is
straightforward and it shipped.

The interesting part is the half that did not ship.

AD had measured a dose-response for rune magnitude and found it "detectable
at ×1.5, unambiguous by ×2". Those numbers were measured with acquisition
held at the `rich` arm — four slots open from tier one and a free rune at
every zone half-mark, about three times what one starting rune delivers.
A dose-response curve cannot be read across acquisition levels, so the
whole sweep was re-run at the level this batch actually ships. That much
was planned.

What was not planned is that the re-run split. On the fixed party the
answer was clean: ×2.5 moved depth by +3.86 tiers against a resolvable
difference of 2.74, and ×1.5 and ×2 did not clear. On the rotated party —
all twelve specs, the arm that exists because a fixed party can only ever
roll sixteen of the forty-eight spec runes — the same ×2.5 moved depth by
+1.94 against a resolvable 2.52. Not a reversal. Not noise either. Just
short, on an instrument that had been deliberately powered up until it
could have seen the fixed-party result and then did not see it.

The rule for what to do had been written down before any row was read, and
it said stop. So the batch stopped, and `runes.json` is byte-unchanged for
the second batch running.

That is worth recording because the temptation to do otherwise was
specific and strong. A perfectly respectable statistician would point out
that both arms are individually significant at the five per cent level,
that they are not distinguishable from one another, and that combining
them gives +2.82 tiers with an interval nowhere near zero. All of that is
true and all of it is in the changelog. It is also an analysis chosen after
seeing the numbers, and choosing the analysis after seeing the numbers is
exactly how batches AA and AB produced two "no effect" verdicts that could
not have detected an effect. The threshold was set in advance precisely so
that it could be inconvenient later. Being overruled is the designer's
privilege; being quietly relaxed by the person who set it is not.

Three things fell out of preparing the pass that never ran, and they are
the batch's real gift to whoever runs it next. Five rune fields are read as
booleans — `if deep_focus > 0` and a hard-coded 150 — so scaling them is a
no-op in the data and would have been a lie in the tooltip; AD's own ×3,
×6 and ×10 arms never actually multiplied them. Rounding collapses the
sweep from five doses to three, because more than half the pool's benefit
terms are a bare `1` that rounds to `2` at both ×1.5 and ×2. And a
proportional cost on three runes that write `healing_received_mult` would
have summed past the floor `heal_amount` clamps at, silently converting
"heals are weaker" into "you cannot be healed at all" — a rule change
wearing a magnitude change's clothes, which is the single most expensive
kind of mistake a data pass can make, because nothing crashes.

The habit worth keeping: when a result holds in one arm and not the other,
the useful question is not "which arm do I believe" but "was the second arm
capable of seeing it". If it was not, buy more samples. If it was, you have
a finding about generality, not about magnitude — and a magnitude pass
authored on the strength of one party composition would have been tuned to
that party.


## Batch AG — what a Perfect should buy

Four of the seven changes in this batch are the same idea wearing different
clothes: an ability was charging for something it was not really selling.

Wildstrikes is the clearest case. It had no `bleed_chance` at all, which
meant the field defaulted to 1.0 and nobody noticed, because "35 Bleed on
every enemy, every time" reads like a designed number rather than a missing
one. Its Perfect then sold +50% on top of a guarantee — a magnitude bonus
on an ability whose whole problem was that it never missed. Moving the
reliability to 50% and making the Perfect *buy the guarantee back* costs
the ability nothing on paper and changes what the skill check feels like
entirely. A wide, swingy sweep should reward hitting the timing with
certainty, not with more of what it was already certain to do.

Inferno Master had a subtler version of the same fault. Counting burning
enemies rewards the Pyromancer for the one thing his kit does almost for
free — Flamewave puts a fire on everyone — and pays him nothing for the
thing his talent lanes actually spend points on, which is making each of
those fires deeper. Accelerant, Conflagration, Explosive Force and Cinder
Trail all grow Burn *turns*, and the passive was blind to every one of
them. Counting turns instead makes the lane's own investments legible in
the number on the chip. Pyromaniac raising the cap along with the step is
part of that: a node that deepens a rate against a fixed ceiling is a node
that stops working the moment you buy the third rank.

The consumption-ordering fix is the one that was a plain bug rather than a
design fault, and it is worth naming because it is the kind that never
crashes. Detonation stripped its target's Burn before the passive block
ran, so the cast that spent the field was paid on the ashes. Nobody would
have reported it — the damage number was always plausible.

Wildfire's rework is a scope decision more than a power one. Copying one
target's Burn to everyone at half duration is a *setup* tool, and the
Pyromancer's problem was never setup; Flamewave is setup. Worse, it worked
against Detonation, since diluting the deepest fire on the board is the
exact opposite of what the payoff ability wants. Two abilities that both
cash in a burning field should ask different questions of it, and now they
do: one deep fire, or a wide one.

Battle Shout is the odd one out, and the fault there was naming. A shout
is a thing other people hear. Making it party-wide and giving it a flat +8%
floor turns it from a solo cooldown that happened to be loud into the
warcry it was always described as — and the flat term matters more than the
scaling one, because the old version was worth almost nothing in the
opening turns when a berserker most wants to spend Rage.

On the initiative sweep: the rule as written ("a `special`, no damage, no
healing, no enemy target") catches more than the intent behind it, and the
section title — *self-buff* initiative costs — is what settled the
borderline cases. Deadfall, Snare Trap and Mass Hysteria all satisfy the
letter of the rule and are all pointed squarely at the enemy team; the
Summons satisfy it too, but a summon fields a unit rather than buffing
anyone, and Aguila takes an enemy target, so applying the rule literally
would have made two of the three cheaper and left the eagle behind. Where
a mechanical rule and its stated purpose disagree, the purpose is the
better guide — and the disagreements are worth reporting rather than
silently resolving, because the designer is the one who gets to overrule
either.

The Lone Bond bug is a reminder about shared bookkeeping. `kinds_summoned`
was written for Feral Momentum and Menagerie, which want to know "has this
kind ever been on the field". Lone Bond then borrowed it to answer a
different question — "have you spent your one summon" — and the two
questions agreed right up until Call of the Wild wrote all three kinds
without summoning anything. Two questions sharing one variable is fine
until an ability makes them disagree; the fix is a second variable, not a
cleverer read of the first.

## Batch AI — eight decisions, not an income curve

The old tree asked "how many nodes can I afford". The escalating ceil(N/3)
price curve, the multi-rank nodes and the ~35 points a run all pointed the
same way: talents were a budget you filled, and the interesting question was
allocation. Row exclusivity replaces that with a different question
entirely — "which eight" — and the numbers now enforce it. A run pays
exactly as many points as a complete tree costs, so no build is ever short
of points and no build ever has spare ones. Nothing is bought. Eight things
are *chosen*, and each choice visibly costs the two it was chosen over.

That is why the greyed siblings matter more than they look. A node the
player can no longer take is not clutter to hide; it is the price of the
node they did take, and the only place that price is ever shown. The same
reasoning runs forward: a node not yet taken names the two doors it would
close, so the cost is legible *before* the click as well as after.

The elite purse (§6 of the brief, taken rather than cut) is the one crack,
and its shape was the interesting call. Elite points could have been ordinary
points that simply arrive faster — but that would put elite-hunting back into
the income game the batch just left, and would break the guarantee that a run
buys exactly one tree. Restricting them to a *second node in a row already
picked* keeps the row count fixed at eight and makes the reward legible as
something else: not "climb faster" but "widen a choice I already made". The
third node in the row stays shut, so even a lucky run never gets a whole row
for free.

Two implementation notes worth keeping. First, `owns_ability` could not read
`Run.owned_ability_names` from a static in a `class_name` script — GDScript
does not resolve autoload identifiers there, the same constraint that already
made RunSim take Run injected. The fix was to move the implementation to
`Talents.ability_names` and have Run forward to it, which is better than what
the brief asked for: the two are now literally the same function rather than
two lists that agree today. Second, a payload whose `condition` is evaluated
with no context is inert rather than unconditional. Both directions are
defensible; inert was chosen because an effect that silently fails to appear
is a bug someone will notice, and one that silently applies everywhere is not.

The tree ships structurally correct and numerically weak, and that was the
instruction rather than an oversight. Rows are lopsided because the 21
existing nodes per spec were authored to *stack* within a lane — Savagery and
Hemorrhage were designed to be taken together and now sit as alternatives —
and single-rank values are the old rank-1 values, roughly a third of their
intended power. Tuning any of it now would be tuning content that four
batches are about to delete.

The size of the drop was worth measuring anyway, and one number in it is
more interesting than the rest. Thirty runs each side, same flags: depth
17.10±1.55 → 13.40±0.86, wipe median z2 t7.5 → z1 t11.0. Runs die a full
zone earlier, which is the expected shape. But **ratio@z1t8 — the measured
party-vs-warband power — barely moved, 0.97 → 0.98.** The party's raw stat
ratio is nearly unchanged; what vanished was conditional and proc power,
the armor pen per 20 bloodloss and the +3% per bled-out enemy that extra
ranks were buying. That is a useful thing to know before authoring 252
nodes: the ranks were never carrying the stat line, so a row that competes
on flat stats will feel much heavier than its numbers suggest next to one
that competes on conditions.

It also means the completion rate is the wrong instrument here. It reads 0%
on both sides and cannot tell them apart; depth and wipe median can. When
the class batches land, those two are the pair to watch.
