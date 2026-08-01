# Design Notes

Why things are the way they are. master.html holds current truth,
changelog.html holds what changed, this holds *why*. Newest first.
Not exported to docx.

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
