# Design Notes

Why things are the way they are. master.html holds current truth,
changelog.html holds what changed, this holds *why*. Newest first.
Not exported to docx.

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
