# Design Notes

Why things are the way they are. master.html holds current truth,
changelog.html holds what changed, this holds *why*. Newest first.
Not exported to docx.

## Twelve spines were authored around denial, and none of them could be seen working (Batch BL) — 2026-08-12

Enemy intent is not a new mechanic. It adds no ability, no status, no number.
It moves *when* an existing function runs and then draws the result. That is
why it was worth more than a new mechanic would have been.

Count what this game already spent on denial. The Cryomancer's whole spec is
taking an enemy off the timeline. The Warden's Threat lane is a bid to be
attacked instead of someone else. The Sharpshooter waits. Break exists so that
a party can spend three turns buying one turn where an enemy does nothing.
Stun, Freeze, Hysteria, Bewitch, Psychosis — five separate systems whose payoff
is that an enemy's turn does not happen. Twelve spines, and the payoff of every
one of them was **an event with no visible content**: something that was going
to occur did not, and the player was never told what it was.

A player who cannot see what they prevented cannot tell prevention from luck.
That is the whole argument. Freezing an Ash Hurler mid-charge always read as a
win, because Batch V made the wind-up *say its name* — the chip, the log line,
the CHARGE LOST float. Freezing an Orc Brute a turn before its Overhead Crush
read as nothing at all, and it was worth about the same. One of those two was
legible and the other was not, and the difference was a label rather than a
rule.

The re-validation rules follow from the same idea rather than from
engineering. A dead target re-targets *within the same ability* because the
player planned against the ability, not the victim — the plan should survive
the kill. An unusable ability falls back to the basic attack **and says so**,
because a silent substitution is the intent system lying, which is worse than
not having one. And a denied turn discards the declaration rather than banking
it: banking would mean that stunning an enemy delayed its blow instead of
deleting it, which would take the payoff back out of the twelve spines this was
built to pay.

The number was dropped, and that is a design decision rather than a
compromise. A damage preview computed a second way is a tooltip with a shorter
fuse — Batch BJ's audit found thirty-eight tooltips that had drifted from their
code, and a number rendered every turn beside the thing it describes would
drift faster and more visibly than any of them. The damage path here cannot be
asked twice for the same answer; it rolls variance and a critical on the way
through. So the intent says *what*, not *how much*. "The Brute is about to
Crush" is most of the planning value of "the Brute is about to Crush you for
41", and it is the half that cannot become a lie.

The recap is the same instinct pointed at the other end of a run. A wipe
already reported *that* you died and *who* fell. What it could not say was what
hit last and what you were standing on when it did. "I was at 40 and it hit for
52" is a sentence a player can act on; "the party has fallen" is not.

## What was under the four accidents (Batch BJ) — 2026-08-11

Four lying tooltips were found by accident in twenty batches — Measured Rage,
Wildfire, Quick Rigging, Swift — every one discovered because a batch happened
to reprice the node next door. The systematic pass found thirty-eight more.

The number matters less than its shape. Only two were the Quick Rigging class —
a promise with no implementation anywhere (Reality Fracture's perfect, and
Unbroken Watch's +2 that was really a +1). The other thirty-six were all the
same species of rot: text written against a game that later batches replaced,
in places no batch had a reason to reread. Three Beastmaster tooltips still
described the baselines their own re-author deleted ("rather than halving it" —
nothing halves). Eleven glossary entries taught systems that were gone —
talent-price curves, rests, growing rune slots, maps you route through. The
worst offenders were not the newest text but the most *settled*: Consecrated
Ground's tooltip never mentioned the Faith drip that is two thirds of what the
lane generates, because the drip was added to the ability two batches after the
tooltip was written and nothing forced the two together.

The lesson is the same one the victory sync taught this batch from the code
side: two copies of one truth drift, and the copy nobody rereads is the one
that lies. Where a number lives in a payload and a desc renders it, the pair
stays honest; where prose restates a mechanic, the prose quietly expires. The
audit is the correction, not the cure — the cure is fewer places where truth
is restated rather than rendered.

## Adding an axis is not the same as adding a choice (Batch BI) — 2026-08-10

This one is about me rather than about the Devout.

BG and BH diagnosed a compounding lane correctly and fixed it by giving the
lane a second axis: Apostle, then Fervor, then Binding Oath all moved off
release FREQUENCY and onto what a HELD stack is worth. The diagnosis was right
and the direction was right. **The second axis was still wrong, because both
axes read one meter, and they wanted opposite things from it.** A release wants
the meter empty. Held value wants it full. Every release therefore paid for
itself by destroying the other half's subject, and the lane's "two choices"
were one choice with two prices facing in opposite directions.

**That is the same fault BC diagnosed, arrived at from the opposite side.** BC
found nodes that all pushed one number the same way and called it one node with
eight prices. This was nodes pushing one number *against each other*, and the
symptom was different — not compounding but cancellation, a leave-one-out grid
that came back flat because every node's contribution was being eaten by its
neighbour's. **Direction is not the test. Sharing the number is the test.** Two
effects that read the same term are one effect with two prices, whichever way
they push it.

**The number that made it visible:** BH's grid moved by at most one point in
any cell, and an ungeared Devout beside the same three built allies read 11%
against the full eight-node lane's 13%. Both readings look like "the lane is
fine, just small". Neither is a magnitude problem, and four batches of
re-pricing would not have found it, because re-pricing an antagonistic pair
moves the balance between two halves that still cancel.

**The repair was to stop sharing the number**, not to raise either half: the
held value reads a *second* quantity derived from the meter — the highest count
held this battle — which rises when the count rises and does not fall when a
release empties it. The release engine and the held engine now read two numbers
that never fight, and both can be tuned without paying the other.

**The general rule: before adding a second axis to a lane, check what the new
axis READS. If it reads the same state the first axis mutates, it is not a
second axis — it is a second price on the first one, and whether it compounds
or cancels is just a matter of sign.**

**And a smaller one, worth keeping:** the flat grid was the evidence, and it was
nearly discarded as "the lane is just small". A leave-one-out grid that comes
back flat on a lane that *does* something is a finding, not a null result.

## The lane was one node with eight prices, and taking the prices off cost most of the lane (Batch BH) — 2026-08-10

BG moved the capstone off the frequency axis and wrote down why: a lane where
every node multiplies the same term is indistinguishable from a single
expensive node. BH finished the job in the lane body — Fervor and Binding Oath
went onto axes the lane had never had — and the result is worth recording
because it is the part nobody predicted.

**The row did not settle below its siblings. It fell to a third of them.**
Four batches of tuning had moved it between 80% and 33%; taking the structure
apart moved it to roughly where his weakest lane sits. That is not a mistake in
the re-spec and it was not corrected, because it is the honest measurement of
something the tuning had been hiding: **most of what the lane was worth was the
compounding, not the nodes.** Three multipliers on one term do not add up, they
multiply, and four batches of shaving one of them at a time could never have
revealed how much of the total was the product rather than the parts. The only
way to find out was to take all three off at once and look.

**The thing to hold onto is what that says about the four tuning batches.** None
of them was wrong about its own number. AW and AY halved a growth clause worth
4% and measured a row that did not move. BE and BF took Communion from 40 to 15
and then conditioned it, and both landed exactly where they aimed. Every one of
those measurements was correct, and the sum of them still did not tell anybody
what the lane was worth, because a lane whose nodes multiply cannot be
understood one node at a time. **A leave-one-out grid on a compounding lane
under-reports every node in it**, which is why BC's grid read Binding Oath at
one point and BH's re-spec of that same node moved the row by eleven.

**The rule this leaves, and it is worth having beyond the Devout:** if
withholding any single node moves a lane's headline by more than about fifteen
points, the lane is not a set of choices, it is one choice with several prices,
and no amount of re-pricing will make it behave. That is a test you can run on a
tree before anybody plays it.

**It comes with a caveat that only shows up once you pass it.** The re-specced
lane passes easily — nothing in it moves the headline by more than a point,
against Communion's thirty-three before. But an ungeared Devout standing beside
the same three built allies reads 11%, and the full eight-node lane reads 13. The
whole lane is worth two points, and nothing inside a two-point lane could move a
headline by fifteen however badly it were designed. **A lane that does nothing
passes the shape test perfectly.** So the grid has to be read against the lane's
own distance from the ungeared floor, and a lane can fail in two directions: one
node worth everything, or eight nodes worth nothing.

**And the smell did not go away, it moved.** BF found Apostle inverted — taking
the capstone lowered the engine it sat on. BG fixed that, and BH's own
leave-one-out promptly found the same inversion one row down, on the node it had
just re-specced. Two different nodes, two batches apart, the same sign error, and
in both cases the cause was that the node changed the state of a system that
feeds itself. That is not a coincidence about the Devout; it is what happens
whenever a node's payoff and its own supply are wired to the same meter. The
next lane built on a self-feeding resource should be read for that before it is
priced.

## A lane where every node acts on one term is one node with eight prices (Batch BG) — 2026-08-09

Four batches went at the Devout's Faith row. It is worth writing down what
each of them was actually doing, because read in order they are not four
attempts at a number — they are a slow discovery that the number was never
the fault.

**AW and AY aimed at a term worth 4% of the row.** Both went for Conviction's
growth clause, the one that raises the Devout's maximum health on every
release. AY halved it with real precision and measured the growth halve
exactly. The row did not move. It could not have: the growth is 4.3% of the
lane's healing, and halving 4.3% of something buys you two points. Neither
batch had any way to know that, because nothing printed the parts.

**BC found the term worth 60% of it, by decomposing rather than guessing.**
It shipped no gameplay change at all. It broke the aggregate into releases,
healing per release, and healing by source, and the answer fell out
immediately: the row was large because it *released a great many times*, not
because each release paid much. A frequency problem. Two batches had been
aiming at a magnitude.

**BE and BF fixed the frequency and BF broke a capstone doing it.** Communion
went 40 → 15, then stopped rolling for allies already at five. Both landed.
And Apostle — which had been worth +7 points, then +10 — came out at **−8**.
Taking the capstone now *lowered* the engine it sat on top of, because parking
allies at five made them invisible to the node that spreads Faith.

That is the fact worth keeping, and it is not about the Devout.

**Apostle multiplied release frequency. So did Communion. So did Fervor,
Sacred Covenant, Blessed are the Faithful and Binding Oath.** Every one of the
eight nodes in that lane acted on the same term. A lane like that is not a
lane — it is one node with eight prices. And when a repair batch finally taxes
the shared term, every node in the lane moves at once, in the same direction,
by an amount nobody chose. The capstone's sign did not flip because BF made a
mistake. It flipped because a capstone that multiplies the thing you are
taming is *guaranteed* to invert when you tame it, at any price you put on it.

**Which is why this batch did not re-price it.** Re-pricing a node that is on
the wrong axis moves it along the wrong axis. Conviction has two halves — what
a stack does *while held*, and what happens when five of them *release* — and
all eight nodes were on the release half. The held half had never been touched
by anything, which made it simultaneously the one axis available and the one
axis that could carry a capstone. Apostle now doubles what a held stack is
worth. The test of whether that was the right change rather than a smaller
version of the wrong one is not the magnitude: it is that the two nodes now
*want the same thing*. Communion pays for allies below five; Apostle pays for
allies carrying stacks. Both push toward the 1–4 band. The smell BF recorded
is not reduced, it is inverted.

**The fault was structural long before any number was wrong, and it was
legible from the tree the day the tree was written.** Nobody needed a sim to
see that eight nodes all read the same clause. What was needed was for someone
to ask what each node acts *on* rather than what each node is *worth* — and
four batches of number-tuning is what it cost not to ask.

## A zero is evidence about the instrument (Batch BF) — 2026-08-09

A metric that pools three quantities and silently omits a fourth will be
trusted exactly as much as one that does not. That is the whole of it, and
this project spent fourteen batches proving it.

The contribution share has been damage plus healing plus damage-prevented,
over the party's total of the same three, since Batch W. Nothing about that
is wrong; it is a perfectly good measure of the thing it measures. What was
wrong is that nobody printed the omission next to it, so the number got read
as "how much of the party's work this hero did" — including, at least once,
in this project's own notes. Break points were in neither the numerator nor
the denominator, dealt or prevented, while `BD/b` sat printed in its own
column right beside the share, which made the omission look deliberate and
handled rather than deliberate and unhandled.

The cost was not theoretical. The Warden's entire Threat lane pays in Break;
Batch AL measured that lane taking his Break per battle from 104 to 320 and
the party's Breaks per battle from 1.02 to 2.35, and not one point of it
reached a contribution number. The Occultist's Broken Will and Entropy exist
to grind a boss's meter. Batch BD gave a single deadfall 270 Break points.
Every one of those builds was measured, repeatedly, by an instrument that
could not see its output.

**And here is the part worth keeping, because it is the only reason any of
it was found: an effect measuring exactly nothing is evidence about the
instrument at least as often as it is evidence about the effect.** Batch BC
ran a leave-one-out grid over the Devout's Faith lane and read −Devoutness
at 80% — the same as the full lane. A node that removes 20% of the party's
incoming Break damage moved the headline by zero. Zero is a suspicious
number. A node can be weak, and a weak node reads as 1% or 2%; a node that
reads as *exactly* the control is usually not being measured at all. That
one zero is what opened the whole question, and it opened it fourteen
batches later than it should have because a small number and no number look
identical in a report that prints neither.

So the fix is not really the two new columns. The fix is that the table now
says what it is — `d+h+p%`, and a line under it stating outright that it is
not a share of the party's work — and that every effect which refuses Break
books through one door with its name attached, so a seventh one added later
either appears in the audit line or does not exist. The columns are what you
do after you have admitted the omission. Printing the admission is the part
that generalises.

## An aggregate is not a diagnosis (Batch BC) — 2026-08-09

Three batches in a row looked at one number — the Devout's FAITH row at
78%, then 80%, then 76% contribution — and two of them tried to move it.
Neither did. This batch did not try to move it at all; it printed what the
number is made of, and the answer took about four minutes of measurement
once the instrument existed.

The reason the two attempts missed is not that they were badly aimed. It is
that there was nothing to aim *with*. A contribution share is
damage + healing + prevented over the party's total, and every one of those
is itself a sum of a dozen effects. AX aimed at Fervor and found the
instruction was already shipped — a no-op, discovered only after the fact.
AY aimed at Apostle's growth clause, halved it precisely, and watched the
growth halve and the row not move. AY even wrote down why that might be
("the growth was never the whole of the FAITH row") and reported the next
lever without taking it. That was the right call, and it is also the moment
the batch should have stopped guessing and started decomposing. It took one
more batch to do it.

The decomposition says the growth clause AY halved was worth about 4% of
the row's healing. Halving 4% of something cannot move it, and no amount of
care in the aiming would have changed that. **The next lever the roadmap
names is another growth lever, and it is worth about 1.4%.** That is the
kind of thing an aggregate hides and a decomposition cannot.

What the row is actually made of is *frequency*. The lane's per-release
payout roughly triples against an unbuilt Devout; the number of releases
goes up twenty-four-fold. Three of the eight nodes multiply frequency and
one multiplies magnitude, and the three frequency nodes own the row between
them. That is not visible from the node text — every one of the eight reads
like a reasonable support talent — and it is not visible from the total.
It is only visible when you take the nodes away one at a time.

Leave-one-out is a blunt instrument and that is the point. It does not
explain anything; it just refuses to be fooled about which term is
load-bearing, which is the exact thing two batches got wrong.

**The second finding is the one worth remembering longer**, because it is
not about the Devout at all. Every lane row this project has ever reported
— the Warden's Threat at 30%, Holy's Radiance at 50%, the Devout's Faith at
80% — was measured with one hero fully built and three unbuilt, because the
force-learn flag takes node ids and node ids are spec-scoped. Nothing is
broken; the harness always built whichever heroes were named, and only one
was ever named. But a share is a ratio, and a ratio against three unbuilt
heroes is not the same question as a ratio against three built ones. Those
rows still mean something — they are honest A/B comparisons of one spec's
lanes against each other, which is what they were mostly used for — but
they are not "this is how much of a real party's work this hero does", and
that is how at least one of them got read.

The lesson generalises past this instrument: a measurement whose
denominator you did not choose deliberately is a measurement you do not
fully own. Writing the flag string was a mechanical step, and the
mechanical step decided the denominator.

Three heals were also found crediting nobody at all — Blessed Barrier's
conversion, Afterglow's mend, Healing Pulse's drip — plus the Devout
capstone's tick and Devoutness's entire effect. Two of those are the
biggest single heal in their own lane. This is why the fix is *one* booking
function rather than five call sites: the terms and the total now come from
the same place, so a heal added later either says which term it is or
doesn't compile into the ledger at all. The old shape let a site produce
healing and simply forget to mention it, five separate times, over five
separate batches, with nothing anywhere reading zero.

## Six things left for later, and later is now (Batch BB) — 2026-08-09

Every item in this batch was found by an earlier batch, recorded, and put down
on purpose. That is a good habit and it accumulates a debt; six is about where
the debt starts costing more than the discipline saves.

Two of them were the same kind of mistake, which is worth naming. The Pack's
swap rule and Creeping Death's refresh both read correctly at the moment they
were written and stopped being true when something *else* changed. AY removed
Loyalty's ceiling and changed the swap to take the older beast in the same
batch, and the second change quietly undid the first: a meter that can reach
fifty is a meter worth protecting, and "replaces the older" throws away the
deepest thing the spec can build. BA wrote Creeping Death as a refresh and
Perfected Toxin as permanence, in the same tree, in the same batch — and a
poison with no clock has nothing to refresh. Neither was careless. Both are
what happens when a mechanic is checked against the design it was written for
rather than against the design it now sits inside.

So the repairs are shaped to survive the next such change. The swap rule is one
function that the summon and the bot both read, rather than the same
`beasts[0]` written twice. Creeping Death's two halves read the stamp the
poison already carries instead of a constant of their own, so whichever way a
future batch moves durations, the node follows.

The governor on the stack clause is the interesting part. Refreshing three
times is refreshing once, so the original never needed to care how many
statuses a single cast landed — and BA later made a single cast land three.
Adding a stack does not have that property. The fix is not to govern the node;
it is to govern the half that needs it and to say in the code why the other
half must not get one, because the tidy-looking change is to apply the same
limit to both and that would be a silent nerf to the clause BA shipped.

Rot came back because AW had already built its pattern for the opposite sign.
That is the whole story: AQ dropped it needing "one field added back at the
victory sync", AW needed one field *subtracted* at the same sync for
Conviction's growth, and once that existed Rot was an afternoon. What the batch
had to do carefully was the third field. Three numbers meeting at one line with
different signs is exactly the shape that produces a five-figure runaway, and
two of them cancel arithmetically in a fight that carries both — so the test
that matters uses deliberately different magnitudes, and the ordering is stated
at both syncs rather than inferred from the arithmetic.

Ashes of Al'ar is the one design call, and it cost more than it looked like it
would. The brief called it one array entry; the ability had never existed as an
ability, only as a passive guard behind a talent, and the class pool it was
told to join has not been read by anything since AN retired the class draw. So
the honest version is a wrapper with new numbers and an entry in each Mage spec
pool. The Pyromancer keeps his hole — no defence in kit or tree, which is what
AR built the spec around — and buying the escape hatch back now costs a boss
pick and a turn. That is a worse deal than having it, which is the point.

## Denial you have to decide (Batch AS) — 2026-08-07

The Cryomancer's problem was that his control kept happening TO him. Four
stacks of setup bought a single skipped turn, the freeze fired whenever the
fourth stack happened to land rather than when he wanted it, and the pile
immediately dropped to one so the next one cost the same again. A spec whose
archetype is Control was spending its whole turn economy on a mechanic it did
not choose the timing of.

So the hold became indefinite and the release became a named act. That is one
change, not two: the moment nothing thaws a freeze by accident, "when does
this enemy act again" stops being a timer and becomes a question the player
answers. It is why the release had to be a specific spell rather than "any
single-target hit from him" — the physical version reads better in a sentence
but makes his own Blizzard a liability, and a player who cannot predict when
their lockdown breaks does not have a lockdown.

The +15% window is what stops the whole thing being a solo trick. Denial on
its own is invisible to the other three heroes; a target that is both helpless
and softer is something the party plays around. It also gives the release a
real cost — you are closing a window as well as freeing an enemy — which is
the only reason Ice Lance's always-crit clause has ever meant anything.

The boss carve-out is not balance, it is a refusal. "This enemy never acts
again" is a fantasy right up to the point where the enemy is the thing you
have to kill to end the fight, and then it is a softlock. Same reasoning
retired the enemy Cleansing Rite as an answer to a hold, in the other
direction: a battle-long freeze reads as the longest-remaining debuff, so
menders would have stripped it first every single time and the indefinite
prison would have been worth less than the one-turn freeze it replaced. The
hold LIMIT is the price instead — one enemy, and every extra costs a node.

SHATTERPOINT had to go because a control spec whose payoff lane is burst is a
damage spec wearing a coat. Four crit dials in a row is not a lane, it is a
stat block with names on it. Thaw asks what you spend the window on, which is
a different question from Deep Freeze's "how much do you deny" and Winter's
"how much time do you buy" — and the kit smoke came back with the three lanes
genuinely separated: Deep Freeze's damage share does not move at all while the
party's Break output nearly triples. That is the shape the spec is supposed to
have.

## A reward that caps and a cost that does not (Batch AR) — 2026-08-07

The Pyromancer's loop was already build-and-spend, and two things quietly
defused it. His fire is free, so the bank filled itself. And the old
passive paid him for *having* lit enemies, so his damage arrived whether
or not he ever pulled the trigger — Detonation was a bonus rather than a
decision. Both are one problem wearing two faces: **nothing in the spec
ever charged him for the fire he was already being paid for.**

Overburn charges him. The interesting part is not the drain, it is the
shape of the pair: **the reward caps at +40% and the cost keeps climbing
forever.** Under 20 burn-turns the two move together and the spec plays
like it always did. Past 20 the bonus stops and the bill does not, so the
field he built to be strong is the field that bankrupts him — and the only
way out is to *spend* it, which is exactly the button the old design made
optional. The refund is what turns that from a trap into an engine:
consuming a six-turn Burn returns six Mana **and** drops the recurring
drain by six a turn, so cashing in is the answer to every problem he has.

Two things follow from that shape and were decided by it. The drain sits
on **Mana, not health**, because a health cost is a clock you carry into
the next fight and this has to be a decision you make inside one — which
is why Cauterise, the one node that moves it back onto health, is an
opt-in and reads as the sharpest thing in the tree. And the spec keeps
**no defensive option anywhere**, in kit or tree, because an escape hatch
is the single change that would undo the whole batch: the moment there is
a button that says "survive the mistake", over-lighting the field stops
being a mistake.

The 6% global Burn tick was left alone on the same reasoning. A proposal
came in to weaken tick damage so unspent fuel was wasted — but that is the
same idea aimed at a shared constant. Overburn already makes unspent fire
cost something, and it does it where only the Pyromancer feels it.

## A node that modifies an ability you may never draw (Batch AL) — 2026-08-06

**Batch AH created a class of dead talent quietly, and the Warden had two
of them.** When abilities became earnable rather than opening kit, every
node whose whole content was "ability X does more" stopped being a node
and became a lottery ticket on X. Rallying Stomp modified War Stomp;
Bulwark Line modified Interpose; AH moved both abilities into the spec
pool. Neither node broke, logged, or crashed — it simply bought nothing,
which is the same failure shape as Measured Rage's inert payload in Batch
AJ, arriving through a different door.

The fix is not to un-trim the kit. It is to notice **what the node was
actually for** and move that to a trigger he always has. Rallying Cry
still refuels the party; it just does it at his turn instead of on a
button he may not own. Bulwark Line still throws cover over the line; it
just rides Shieldwall, which has been base kit since Batch G. The earned
ability then becomes a *bonus* on a node that already works — which is
strictly better content than a node that is either great or worthless
depending on a draw.

**The general rule this leaves behind:** a talent may READ an earnable
ability, but it must not DEPEND on one. Anything else prices a node
against a probability instead of against the two doors it closes.

## Chance is only tension if you can plan around it (Batch AL) — 2026-08-06

Tank and Spank was a 15% chance to Empower an ally whenever Mocking Blow
landed. Mocking Blow is free and on the Warden's rotation constantly, so
the roll happened several times a battle and its outcome never changed a
decision — you could not hold the taunt for it, spend around it, or notice
when it failed. That is not variance, it is noise: the node's real value
was its average, and the player experienced the average as "something
occasionally happens".

Made certain, the same node becomes a plan: taunt, then the Empowered ally
swings. Randomness earns its place on a rare, expensive, or optional
trigger — where the roll is an event. On a free button pressed every other
turn it just blurs the number.

## Splitting an exclusive pair can be better than keeping it (Batch AL) — 2026-08-06

Spite and Bruising Guard were an exclusive fork: turn the punishment you
soak into damage, or into Break. It reads like a real choice, but both
halves answered the same question ("what does being hit pay?") with the
same trigger, so the decision was really "which number do you prefer" —
and one of them was always better for the party you happened to have.

Split across rows 5 and 6 both are reachable, and the cross-row rider
turns the second pick into something neither half was alone: one
continuous Break engine, where the reflect he was already taking now also
feeds the meter his blocks are chipping. The lesson is that an exclusive
pair is only interesting when the two options **ask different questions**.
When they ask the same one, separating them and paying for the
combination is the better content.

## A talent re-tune can silently re-tune a rune (Batch AL) — 2026-08-06

Two Warden runes added a RANK to a talent counter. That was fine while a
rank meant 6% — the rune read "+6% damage against his taunted mark" and
paid exactly that. Re-pricing the node to 25% would have made the same
untouched rune pay 25%, four times its own description, with nothing in
the diff to show for it.

This is worth naming because it is invisible from both ends. Reading
runes.json, nothing changed. Reading talents.gd, nothing mentions runes.
The coupling only exists in a battle.gd read site that multiplies a
counter by a constant, and it will happen again to any rune that shares a
counter with a node.

**The rule: a rune and a talent may share a read site, but not a
magnitude.** Batch AK hit this from the other side with the Rune of the
Still Wrist, where a `max()` would have left the rune inert when worn
alone; the same shape, the same answer — give the rune its own term and
add them.

## Rows should ask a question (Batch AJ) — 2026-08-06

**A row is a question and a lane is an answer.** Batch AI cut the old
tiers into exclusive rows mechanically — by position, not by meaning — and
the Berserker came out of it with rows that had nothing to decide in them.
The clearest case: Deafening Cry (which shortened Battle Shout's cooldown)
landed in the same row as Battle Shout itself. Two exclusive nodes where
one exists only to modify the other is not a choice; it is one live option
and one dead one, and the dead one is dead in a way the player only
discovers after spending the point. Re-themeing the rows — the opening,
the wound, what the wound pays, the edge, what compounds, refusal, the
finish — is what made the re-pricing coherent, because you cannot ask "is
this worth closing two doors for" until you know what the other two doors
are for.

**Cross-row conditions are how a tree rewards a plan without adding
nodes.** Three of them here, and each one exists because the pair is more
interesting than either half: Savagery makes Crushing Blows count faster,
Unstoppable stops Scar Tissue's floor falling at all, and Measured Rage
*cancels* Reckless Fury's risk rather than subtracting from it. That last
one is the shape worth keeping — two nodes for consequence-free damage, or
one node and eat the risk. It is a real decision at the point of purchase
and it costs no new content.

**Cancel, do not subtract.** Measured Rage and Reckless Fury both write
the same damage-taken field, so the obvious implementation is arithmetic:
-20% plus +15% lands on -5%. That is fragile in a way that is easy to
miss — it silently depends on both magnitudes staying where they are, and
a later re-tune of either one breaks a promise the tooltip is still
making. A flag that zeroes the term outright says what the design means
and survives any future number.

**A capstone needs a ceiling before an upgrade path can buy anything.**
Rampage's kill-recast chained for as long as the kills kept coming. The
upgrade path in this batch — "may chain twice per turn" — is meaningless
against an unbounded base, so the cap came first. Worth remembering when
the remaining trees land: an upgrade is only a reward if the base has an
edge to push out.

**The inert-node lesson.** Measured Rage has been doing nothing since
Batch AI, because the read site was guarded `> 0.0` and the node's whole
payload is a negative number. Nothing crashed, nothing logged, and the
tooltip kept promising 8% — the failure mode CLAUDE.md already warns about
for typo'd stat fields, arriving through a different door. The batch's
test spawns a live Berserker and reads the reduction off him rather than
trusting the payload, which is the only version of that check that would
have caught it.

## A node is a row now (Batch AK) — 2026-08-06

**The re-author is not a tuning pass, it is a re-pricing after a structural
change.** Batch AI made the rows mutually exclusive: a node is no longer
one of three ranks you might buy on the way to something else, it is the
whole row, and the two beside it are shut for good. AI said so and said
the numbers would be wrong until the class batches landed — rank-1 values
sitting where a full row's worth of power belongs, about a third of what
the slot is worth. So the question for each of the Swordmaster's 24 nodes
was not "is this a good number" but "is this worth closing two doors
for", and the answer was consistently no by a factor of three or four.
That is where 3% → 12% and 15 Rage → 45 Rage come from; they are one
decision applied 24 times, not 24 decisions.

**Point a node at what the hero is guaranteed, not at what he might
draw.** Sunder Guard read "Shatterpoint +8 Break damage" — and the kit
correction in the same batch made Shatterpoint earnable, so the node could
be bought by a hero who never sees the ability it modifies. A node that
might do nothing is worse than a weak node, because the player cannot
price it at purchase. Re-pointing it at Guard Change fixes that (he always
has Guard Change now), and keeping the Shatterpoint clause as a *bonus*
rather than the payload costs nothing: a lucky draw makes a good node
better instead of making a dead node live.

**Two nodes that do the same thing to the same target are not a choice,
they are an arithmetic problem.** Punishment and Off Balance were an
exclusive pair in one lane — pile it into Overpower, or spread it across
the kit. The row re-cut put them in different rows, so both are reachable,
and "+60% vs Broken" plus "+20% vs Broken" is just +92% vs Broken with
extra steps. Widening what counts as a window instead — Exposed and
Crippled join Broken — keeps the second pick meaningful without touching
the first number. The general shape: when a re-structure makes two
exclusive options simultaneous, change what the second one *does*, not how
much it does.

**A trigger that fires on the skill check is worth more than the same
number sitting on a sheet.** Swordsmanship was a flat parry bonus he owned
from purchase. As a spike on a perfect Guard Change it is the same
expected value only if he keeps hitting the check, which makes the button
press worth caring about — and the Swordmaster is the spec whose whole
identity is choosing when to pivot. The magnitude went up to pay for the
variance.

**One answer, one counter.** Riposte and Opportunist both ended up
answering a parry with a free Overpower, from two different lanes, both
reachable. Letting them stack would have paid a parry build twice for
buying the same idea twice, and a parry build already has High Guard,
Deflection and Untouchable pulling in the same direction. The rule is that
a parry fires one counter; what Opportunist still owns alone is the whiff.

**Grant-or-upgrade is what an ability in two places has to do.** Lunge and
Execute sit in the spec pool and in the tree. Before, drawing one from the
pool made the node worthless and vice versa — a dead pick either way,
decided by an order the player does not control. Upgrading the copy he has
turns the collision into a reward for it. The check for "does he already
have it" has to be the abilities list rather than `owns_ability`, because
a learned node's own grant is in `ability_names()` — the question is not
"can he cast it" but "could he cast it before this tree ran", and only the
kit that was assembled first can answer that.

**A rune pointing at a deleted mechanic is a bug, not a tuning question.**
The Rune of the Still Wrist promised to deepen "a perfect Pommel Strike's
parry blessing" — which Batch AH removed when it converted that perfect to
the boss Stun. Nothing failed; the rune just quietly did nothing, and the
shop kept charging 100 gold for it. The magnitude question the designer
closed in Batch AF is about how strong runes are, and this was never that.
It also decided the shape of the new field: additive, because the talent
and the rune both pay into it and a max() would have re-created the same
silent nothing.

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

## The duplicate rune triple — retry-and-hope is not a dedupe

The pick-of-3 rune offer could show the same rune twice, about one triple in
a hundred. The mechanism is worth writing down because the shape recurs.

The roller drew each candidate independently and, on a collision, rerolled
up to four times — then appended the result **unchecked**. Two independent
ways to lose. Every reroll could collide, which on a small per-rarity pool
is not remote. And the check sat at the *top* of the retry loop, so the
final reroll was never tested at all: four checks covering five draws, the
fifth appended blind. Either alone would have been enough.

The deeper problem is that rejection sampling was being used as a
correctness mechanism. It is a fine way to make something *likely*; it
cannot make something *guaranteed*, because the failure branch always
exists and someone has to decide what happens there. Here the failure branch
had quietly been decided as "ship the duplicate."

The fix was to stop sampling and start excluding: the names already in the
triple ride the same channel the owned pouch already used, so the pool a
candidate is drawn from does not contain its siblings. A rune already in the
offer is exactly as unavailable as one already worn — the same question, so
the same answer. That makes the duplicate unreachable rather than unlikely,
and it deleted the retry loop rather than tuning its bound.

The test story is the interesting half. Batch AF had frozen a **verbatim
copy of the old loop** as a reference and asserted the default path matched
it on a shared seed. The intent was right — prove the new `guarantee_spec`
parameter changed nothing for existing callers — but the implementation
pinned the bug in place: any correct fix to the roller necessarily broke it,
because the reference *was* the defect. A frozen transcription is a sharp
instrument for "did this change by accident" and a trap for "should this
change on purpose"; it needs to move when the thing it mirrors is
deliberately corrected, and the commit that moves it is the one that has to
justify why. What was genuinely missing was simpler: the default path had no
distinctness assertion of its own. Only the guaranteed path checked, which
is why this showed up as an intermittent failure on one spec instead of a
flat statement that the roller was wrong.

## Batch AN — the map scaffold (2026-08-07)

**Placeholders on purpose, and it matters that they are labelled.** The six
modifiers and the four ability upgrades in this batch exist so a 36-encounter
run is playable end to end before 66 pieces of new content are authored
against it. The alternative — author the content first, then find out the
pacing was wrong — is how a design ends up with twenty modifiers nobody wants
to take. Every placeholder is built out of a hook that already existed, which
is also what kept the batch's blast radius small: six modifiers cost four new
fields on `BattleUnit` and one stamp function.

**Severity is flat, and that is a design position rather than a
simplification.** A severity that read party composition would tax every
build for being good at something: bring a Cryomancer and Tinderbox gets
cheaper for you, so a composition-aware rating would pay you less for it. The
batch's own phrasing settles it — a modifier that happens to be cheap for
your build is a good deal you *earned by building that way*. Flat severity
also makes authoring a modifier a one-number job, which is the property that
makes twenty of them tractable.

**The severity-1-or-2 floor is guaranteed by construction, not by rejection.**
Rolling three and re-rolling until one is mild works until the table's shape
changes and the retry budget quietly starts failing. Drawing the first option
out of the low pool and the other two out of everything cannot fail on an
unlucky table, and the test samples 2,000 offers rather than trusting the
argument.

**The reward pays on victory because the modifier is a price.** Paying up
front would let a player bank a severity-4 rune and then lose the fight it
was supposed to cost them, and "a merchant follows the fight" cannot resolve
before the fight it follows. That one reward settled the whole question.

**Two purses became one by arithmetic, not by decision.** Batch AI split
elite points into a flex purse because 8 points against an 8-node tree left
no slack: a normal point had to be *barred* from second nodes or the tree
could be climbed faster than the schedule intended. At 12 points against 8
rows the structure does the barring on its own — rows are mutually exclusive
and there are only eight, so anything past the eighth has nowhere to go but a
second node in a row already picked. The flex purse survives in the data
because deleting it would strand old saves and close the door on a relic that
wants to grant flexibility without granting climb, but nothing feeds it now.
`Talents.purse_for` is the single place that answers "which wallet pays",
which is what keeps the greying, the tooltip and the spend from disagreeing —
the failure shape that hid Measured Rage for two batches was two read sites
answering one question.

**The awakening's talent point was kept, and the arithmetic is off by one
because of it.** §8 says 12 per run and a surplus of 4; the real totals are
13 and 5. The section enumerates *slot types* and the awakening is not a
slot, so removing it would have been a design change the batch never asked
for — and a real one: the first talent pick would slide from "the moment you
choose a spec" out to encounter 3. Kept, flagged, and pinned by a test that
asserts 13 explicitly, so if the designer decides §8's arithmetic is exact
the check is the thing that says so.

**Pre-v7 saves are refused rather than migrated.** A saved party standing at
tier 7, column 2 has no honest position on a line with no columns, and the
board it describes has rest nodes and a mini-boss row this build cannot
render. Batch AI made the same call about ranked talent purchases: a wipe
that says so beats a migration that invents state.

**The route-agency figure is kept at a permanent 0%.** A line has no route
decision, so the honest report of it is zero — but a *missing* figure reads
as a broken instrument, and the next person to run the sim would spend an
afternoon finding out it was deleted on purpose. Deleting a metric and
reporting a metric as zero say different things; this is the second one.

**Deleted, not left unreachable.** Nine constants and eight functions went
out of `run_state.gd`, and a test pins each of them ABSENT. The reason is the
edge-column adjacency bug this batch also deleted: it survived three batches
because the code that produced it still resolved, still ran, and disagreed
with its own comment. A constant that still compiles is a constant a later
batch reads by accident.

## Batch AO — the direction, the toll booth, and the switch (2026-08-07)

**Right-to-left was flagged, shipped, and read wrong.** AN said in its own
comment that horizontal run-maps conventionally read left to right and that
an English-reading player may parse the boss end as the start — then chose
the unconventional direction and shipped it behind a compass label. Playing
it settled the question the reasoning could not. Worth keeping is the shape
of the fix: the label went out with the direction, because a caption
explaining which way to read a line is a cost the line should not need. If a
layout needs a legend, the legend is not the deliverable — the layout is
wrong.

**A choice offered ten times a zone is a toll booth, not a decision.** The
offer was not weak, it was constant: eight plain fights plus two elites meant
the bargain screen sat between the player and every battle, so the interesting
question ("what will I accept for this?") flattened into a tax with three
tickets. Cutting it to four a zone — the elites and the mini-boss — costs
nothing about the mechanic and restores the thing that made it a decision,
which is that it does not always happen.

**The mini-boss gets a modifier deliberately, and the floor is what makes it
fair.** Every enemy in a mini-boss warband already carries 1.5× max HP, so a
severity-4 pick there is the sharpest gamble in the run. That is the point.
It only works because the severity-1-or-2 floor is guaranteed by construction:
without a survivable option the gamble would be a trap, and the floor is what
converts "the game punished me" into "I chose that".

**The gold moved because the price did.** Eight bargains a zone disappeared,
and a bargain paid for itself. Plain-fight gold rose 25–35 → 45–60,
deliberately below the old bargain payout — a fight that no longer charges a
modifier should not pay what a fight that did paid. The number is one line in
one place, which is the only reason it belongs in a batch that is otherwise
not doing balance work.

**Kill All Enemies is a switch, not a hit, and that costs something.** Routing
it through `take_hit` would have been fewer lines and would have fired
on-hit procs, overkill transfers and floating numbers on a kill nobody dealt
— a debug tool that quietly runs game logic is a debug tool that lies about
what it tested. Setting HP to zero and calling `_die()` skips all of it, and
the accepted cost is that on-death procs reading a killing blow (Seeding
Embers and friends) will not fire. Everything *after* the kills is the real
victory path on purpose: gold, points, the heal, the bargain's reward, the
spoils, the summary. The switch exists to reach that path, not to replace it.

## Batch AP — the mini-boss reward becomes real

**The bug was not in the upgrade, it was in the gap between the pick and the
fight.** Every visible part of the mini-boss reward worked: the offer rolled,
the card rendered, the pick resolved, the choice saved. Nothing read it at
spawn. That is the worst shape a bug can take, because the player has no way
to tell — the prize looks exactly like a prize right up until it silently
does nothing three times a run. It survived a whole batch because "placeholder
pool" and "unwired" were recorded in the same sentence, and the first one made
the second sound intentional.

**Two of the four descriptions were wrong, and only wiring them proved it.**
Text written for something nothing reads is text nobody has to check against a
field. "Effortless: costs no resource" is fine until you ask which resource,
and the Holy Cleric has two — one of them her entire identity. "Swift: +2
initiative speed" names a stat that does not exist and implies an arithmetic
the roster cannot survive: delays run 1.5–4.0, so subtracting 2 takes most
abilities to nearly nothing. Both read as authored numbers. Neither had ever
been arithmetic.

**Upgrades apply last because talents overwrite, and overwriting is silent.**
Several talents *set* an ability's field rather than adding to it — the node
that upgrades Lunge sets its cost to 15 — so an upgrade applied before the
tree does not conflict, it simply disappears. There is no error and no log
line; the ability just costs what the talent says. Ordering is the whole fix,
and it is the same ordering lesson Batch AH learned from the other side.

**An offer that can pair a reward with nothing is worse than a smaller
offer.** Honed on Heal, Effortless on a free ability, Quickened on something
with no cooldown — each of those is a pick that reads as a choice and is not
one. Dropping an upgrade with nothing to land on can leave two options instead
of three, and two real choices beat three where one is a decoy.

**The stale note is the same failure as the stale prize.** The `treasure`/Loot
node type had been carried as outstanding for six batches. It had been deleted
five batches ago, with the map generator it belonged to. A list of open
problems that nobody re-reads against the code becomes a list of problems that
are not open, and it costs exactly as much attention as a real one.

---

## Batch AQ — the pool at nineteen, and the prize you could not see

**A pool weighted evenly would have deepened the half nobody repeats.** Every
offer's first card is drawn from the mild pool. That means the safe slot on
every bargain, all run, is served by the low end alone — so the low end is
what a player actually meets over and over, and the harsh end rotates on its
own. Authoring six/six/four/three rather than five/five/five/five is not a
softening; it is putting the depth where the repetition is.

**Filling the other two slots from the harsh pool is what stops a bigger pool
being a blander one.** With nineteen modifiers and twelve of them mild, the
old "draw from everything left" fill put two cheap options on 86% of offers.
Three cheap options paying three cheap rewards is not a decision, it is a
formality with pips on it. One safe and two gambles is the same card every
time and a different question every time.

**Rot died at a line nobody would have looked at.** The risk that was flagged
in advance was arithmetic: what happens to the effects that read maximum
health as a percentage. Those were all fine, because they were all ratios. The
kill was a bookkeeping line — the battle writes the unit's max HP back onto
the party member on victory — so a modifier scoped to one fight would have
followed the party out of it and taken half their health for the rest of the
run. The lesson is not "check percentages"; it is that a modifier which edits
a stat has to be checked against every line that *copies* that stat out of the
battle, not just the lines that read it inside.

**The companion bug was invisible because there were only six modifiers.**
Four of the six wrote a field the beast never read, and the two that mattered
happened to ride the hunter's own stats. Nineteen modifiers would have made it
obvious within a run, which is the useful thing about scale: it does not
create the bug, it stops the bug being deniable.

**Twelve prizes a run, none of them visible while standing still.** A reward
you can only see by hovering the thing it changed, during the fight, is a
reward the player learns to stop looking for. The runes on the map card had
had this treatment since the card existed; upgrades getting nothing beside
them was not a design decision, it was an omission that read as one.

## Batch AT — the Arcanist: escalation

**A slope and a curve are different fantasies, and only one of them is a ramp.**
The Arcanist had always been described as the ramp spec, and he had never been
one: one stack per cast to a cap of five, +15% each, is not
nothing-early-everything-late — it is slightly-weak-for-four-turns. The fix was
not bigger numbers, it was a different *shape*. N(N+1)/2 means every stack is
worth more than the last, so the same spec that is genuinely feeble at five
stacks is frightening at twelve. That is why the batch tabulated the numbers
rather than describing them: a compounding figure nobody has written down is a
figure nobody can plan against, and a player who cannot plan against it
experiences it as randomness.

**Removing the escape hatch was the load-bearing change, not the passive.** A
ramp with a free vent button is not a ramp — every turn asks "should I cash out",
and the answer is usually yes, because the downside is immediate and the upside
is speculative. Stabilize did not need nerfing; it needed to stop being a
default. Making it earnable turns the same button from a tax on the fantasy into
a deliberate confession that you do not want the fantasy today.

**The trap this batch is really about: two multipliers that each look reasonable.**
+7.5% damage per stack on Arcane Cannon was fine against a linear passive and
catastrophic against a compounding one, because it turns a curve into a curve
squared. Nothing about the ability's own text changes when the passive changes,
which is exactly why it survives a rewrite. The general rule worth keeping: when
a passive's scaling shape changes, audit every ability that reads the same
resource — not for whether the number is still balanced, but for whether it is
still the same *kind* of number.

**And the measured surprise, which the node text actively hides: under a
compounding curve, build rate beats per-stack value quadratically.** The lane
selling "each stack worth more" lost to the lane selling "more stacks", by a
lot, because the payout is quadratic in the count and only linear in the step.
Both lanes read as symmetrical trade-offs; the mathematics is not symmetrical at
all. A tuning pass that priced these two lanes by how their text reads would get
it backwards.

**Shatter: the difference between a state and a charge.** It never fired because
it and Ice Lance answered the same question — "spend the hold" — and one was
cheaper. Scaling it on *stacks held* could never fix that, because an indefinite
hold pins every prison at the same stack count, so the two abilities were reading
a constant. Scaling on *turns held* gives the hold a second dimension the Lance
cannot reach, and it converts a binary the player has no opinion about into a
decision they have to make every turn. The tension it creates — the party's
damage window is also Shatter's fuse, and cashing the window kills the fuse — is
the good kind, and resolving it would have thrown away the reason to fix it.

## Batch AU — four things from the AT playtest

**A rule that runs one direction is not a rule, it is half a rule.** Talents
already refused to grant an ability a boss had handed over; nothing handled the
reverse, so earning Magi's Wrath quietly deleted a third of a capstone shelf. The
tempting fix — filter the boss pool — is the wrong one, and it is worth writing
down why: the spec pools and the trees deliberately OVERLAP, so anything that
filters tree abilities out of pools empties pools across the whole roster. The
overlap is a feature (a player can earn a piece early or buy it late), which
means the collision has to be handled where it happens rather than prevented.

**The generic fallback is deliberate reuse, and reuse is the whole argument for
it.** Four ability upgrades already exist, are already eligibility-filtered, and
already show a ◆ on three surfaces. Pointing a new rule at machinery a player has
already been taught costs one function and teaches nothing new; authoring a
fifteenth bespoke "if you already own this" effect per node would cost twelve
batches and a legibility problem. The general shape: when a new rule needs an
effect, look first for an effect the player can already read.

**Two steps, and the second one is not where it is for convenience.** The
decision "this node collided" belongs at the grant site; the resolution belongs
last, after every talent and rune that might `set` the same field. Batch AP
learned that ordering the hard way and it holds here unchanged — an upgrade
applied in the middle of the talent pass is an upgrade something later overwrites
without an error.

**Exclusivity was legible in the rules and invisible on the screen.** Three
sibling nodes drawn as three squares read as three independent purchases no
matter what the tooltip says, because the layout is the first thing the eye
believes. The band fixes the reading, the hover dim fixes the moment of choosing,
and the lock fixes the aftermath — and none of the three substitutes for the
others. The row-8 case is the sharpest version: a rule a player only discovers by
losing two capstones is a rule the interface never stated.

**The capstones were crossed, and the arithmetic says which way round they go.**
Doubling the damage step is what "each stack is worth more" means, so it belongs
in the lane that sells that; build rate belongs in the lane that sells stacks.
What makes the swap interesting rather than cosmetic is that the two are NOT
equivalent: under a triangular curve the payout is quadratic in the count and
linear in the step, so a build-rate capstone has to be deliberately restrained to
stay in the same weight class as a step capstone. Singularity's +2 per crit looks
timid beside "the step DOUBLES" and measures out at 1.74x against 2.00x. The
lesson is the one AT already recorded, arriving through a design door instead of
a measurement one: price build rate as the expensive thing.

**A debug toggle that shows you too much is not a generous debug toggle.** The
grant-all aid existed to review one spec's kit and was handing the reviewer three
specs' kits, which makes the thing it exists for harder rather than easier. The
class pool had to go, and the honest way to ship that is to name what it costs
(a class-pool ability is no longer covered) rather than to add a second toggle
that restores the confusion behind a checkbox.


**Read the right instrument or the hero looks broken.** The Holy Cleric's damage
share sits at 3-4% and moves in the wrong direction as she gets stronger: the
full Radiance build reads 1%. Contribution reads 29% -> 50% over the same change.
Any batch that tunes her against damage share will nerf the thing it meant to
buy, and the reason is structural rather than incidental — she attacks at 50, so
the number is measuring an activity she barely performs. Naming the instrument
before the measurement is the cheap half of that; the expensive half is that a
spec whose contribution lives in a different column needs its own reading habit,
and the two Cleric batches after this one inherit it.

**A magnitude priced as rank 1 of three is not a decision when it is a whole
row.** Her tree was already purpose-designed, so nothing about its SHAPE was
wrong — the numbers were simply left at the values they had when a node was one
third of a purchase. A 5% dispel chance and a threshold moved from 50% to 53%
are not weak choices, they are non-choices: nobody weighs them against the two
options they close. The Mage trees needed roughly 3x; this one needed 4-5x, and
the difference is worth remembering because "the tree is fine, it is just the
numbers" was true here and the numbers were nearly an order of magnitude out.

**The cost belongs where the effect lands, not where the button is pressed.**
Intercession pays its Mercy when a blow is actually refused. Charging on cast
would have made it an expensive gamble on the future; charging on trigger makes
it a promise she has to be able to keep, and "she is holding nothing" becomes a
real failure state rather than a greyed-out button. It also produced the nicest
accident in the batch: a hero falling from full health crosses the Mercy window
on the way down, so their own fall earns the stack their rescue spends.

**Say what a capstone must NOT do, in the payload rather than the prose.**
Serenity makes Resurrection free and near-instant, and the one thing it must not
touch is the health the ally comes back at — that is Empower's entire payload,
and a capstone quietly doing Empower's job for free is how a resource stops
mattering. Writing it as an ability payload rather than a stat means no field in
it *could* reach the return health; the prohibition is a property of the data
rather than a note somebody has to keep obeying.

## Batch AW — the Devout: investment

**The kit was already investment-shaped; what was missing was the other half of
investment.** Divine Shield, Afterglow, Healing Pulse, Purity's shield and the
Faith release all pay out percentages of *his* maximum health — he was already
lending out his own bulk. What he never did was collect: the returns went to
everyone else and he took a sip of Mana. Adding one clause (every Faith release
raises his maximum by 3% of base, and heals him for it) made the whole kit
escalate without building anything, because every one of those payouts already
reads the number that now grows.

**Escalation off other people's survival is a different spec from escalation off
your own casting.** The Arcanist's curve is self-driven — he presses buttons and
gets bigger. The Devout's is not: it only moves when a shield he gave somebody
else absorbs a blow, or when the party stands on his ground. That is the whole
reason the same mechanical shape reads as a support rather than as a second
Arcanist, and it is why the clause is worth more than the number in it.

**Linear on base, compounding through the kit.** 3% of base rather than 3% of
current is the load-bearing decision. The loop still compounds — a bigger
maximum makes a bigger shield, which absorbs more, which builds more Faith — but
it compounds through mechanisms a player can see and interact with. A clause
compounding against *itself* would be an exponential nobody could read off the
tooltip, and Apostle (which turns releases into a stream) would have made it
unbounded rather than merely large.

**A one-fight change that survives the fight is the failure mode to design
against, and it does not crash.** The battle-end sync writes each unit's
`max_hp` back onto the party member; anything that moves the maximum mid-battle
walks out of the battle unless something subtracts it. That is what killed `rot`
in Batch AQ, and it is invisible — no error, no log line, just a hero who is
quietly larger every fight. The pattern that works is a named field that
accumulates exactly what was lent and a subtraction at the sync. The test worth
writing is not "does the growth happen" but "is it gone afterwards".

**A lane named after the leftovers is a lane with no question in it.** Zeal's
old thesis was "everything else he casts" — the same fault Holy's Sanctuary had.
Re-aimed as "invest shallowly in everyone", it sits against Bulwark's "invest
deeply in one ally" and Faith's "invest in what the returns pay", and the three
become three answers to one question instead of two answers and a bin.

**Moving an effect down into the base kit is often worth more than repricing it.**
Fervor was a row-6 node fixing a problem the passive had from turn one: Faith had
a single source on a 2-turn cooldown, so a party-wide system delivered to one
ally at a time. No magnitude on that node could fix it, because the fix was
needed by players who had not bought it. Putting the drip in Consecrated Ground
and letting the node deepen it costs a node's worth of power and buys the passive
its stated identity.


## Batch AX — the Occultist: corruption

**A resource that resets is not a resource — it is a cooldown wearing a
counter's clothes.** Ruin climbed to five and then cleared, so the number on the
chip was never a record of anything; it was a timer. Removing the cap and the
clear costs nothing structurally and changes what the spec is *about*: his power
stops being something he does each turn and becomes something that has been done
to the enemy. The one design fact worth carrying forward is that the fantasy was
already in the fiction and only the mechanic disagreed with it.

**Moving a threshold out is a bigger nerf than it looks, and the honest thing is
to name the loss rather than hide it inside a buff.** Ten stacks at ~1.5 a turn
is about seven turns, and a trash fight ends in seven or eight — so pushing the
detonation from the 5th stack to the 10th very nearly removes his signature
payoff from most of the fights he is in. Making him the boss specialist by
construction is a real design position, but it is one that a bigger blast and a
persisting mark can easily paper over in a changelog. The batch shipped an
instrument for exactly that number, split trash vs boss, and named the fallback
variant (*first detonation at 5, every 10 after*) without shipping it.

**When you uncap one number, every effect that reads it needs deciding
separately — and "cap them all" is as lazy as "cap none".** Two effects read
Ruin per stack. The damage amplification is *supposed* to run away: that is the
payoff of a long boss fight, and Deeper Hex at twenty stacks doubling incoming
damage is the design working. The lifesteal is not, because per-stack lifesteal
against an unbounded number lets the party heal more than it deals, which is not
"strong" but "the fight cannot end". One got a ceiling and one deliberately did
not, and the reason lives beside each.

**A gate is not a hole when the player can see the key.** Every Madness effect
is refused by a boss until it is Broken, which reads as "this lane does nothing
in the fights that matter" — right up until you notice the same tree sells you
two nodes whose whole job is grinding Break. The fix was never mechanical. It
was that the plan existed and was invisible, so it got stated in the lane text,
the glossary and the tooltips, and the mechanic was left exactly alone.

**A unit change is not a magnitude change, and the difference matters most for
things you are not allowed to retune.** Rune magnitude has been closed since
Batch AF, so a rune re-pointed onto a re-priced counter must still pay what it
paid. That works right up until the *unit* moves: the Hollow Chalice bought "5%
more from a flat lifesteal", and after this batch there is no flat lifesteal for
that sentence to mean anything against. There is no faithful number, only a
faithful *relationship* — one node's worth of each dial, which is what it always
was. Reporting that is the whole job; quietly picking a number and calling it
unchanged is how a closed question gets reopened by accident.

**A stale premise in a brief is worth more as a finding than as a change.**
§7 asked for a Fervor cut whose stated end state — the ground paying 2 a turn
with the node learned — was already what shipped in Batch AW. The two readings
that *would* have been real changes each broke something the brief said to keep:
one leaves a node doing nothing, the other reverts AW's decision to put the drip
in the base kit. The measured overshoot it was aimed at is still there, and
saying so plainly is more useful than shipping a guess that makes the number
move for reasons nobody chose.

---

## Batch AY — the Beastmaster

**A resource with a ceiling is a node question; a resource without one is an
identity.** Loyalty capped at 5 and doubled the boon there, so "how devoted is
this beast" had exactly two answers and *raising the ceiling* was three separate
nodes' job. Making the boon a continuous curve did not add power so much as move
where the interesting decision lives: it is no longer "have I hit five yet", it
is "is this partnership worth keeping alive". That is the same beast, the same
numbers at five stacks, and a completely different question.

**Uncapping a meter is not a local change — it is a licence for every read site
to go somewhere it has never been.** Savage Presence reads `1 − 0.10 × boon` on
damage taken, which was fine forever at a maximum boon of ×3 and starts *healing
the hunter off enemy attacks* somewhere past ×10. The instinct is to cap the
curve; the right move is to bound the *mitigation*, because the curve is the
thing the batch is about and the multiplier crossing zero is an absurdity rather
than a balance point. Whenever a ceiling comes off, the work is finding every
place that quietly relied on it.

**The rule that stops being enforceable is worse than the rule that was never
written.** "One beast per fight" and "two beasts at once" were assumed to be
mutually exclusive because they sit in a tree with exclusive rows — but a
capstone shelf has no lane-purity requirement, so nothing barred the pair.
Building a picker-level exclusion for it would have been a new subsystem for one
case; resolving it where the number is actually read costs two lines and cannot
be bypassed. The part that matters is that *both node descriptions say so*: an
invisible resolution is just a different silent contradiction.

**A default that is only ever right by coincidence will fail the moment
something upstream moves.** The Pack replaced whichever beast held less Loyalty,
which read as sensible for as long as Loyalty had a ceiling everyone reached.
Uncapped, the newest arrival always holds the least — so the rule would have
evicted the beast the player just called, every time, and made rotation
impossible inside the capstone whose lane is named for rotation. Nothing about
that rule changed; the world around it did.

**Halving a multiplier tells you what fraction of a number the multiplier was
responsible for.** Apostle's growth was cut in half and the growth halved
exactly — but the FAITH row's contribution barely moved. That is worth more than
the fix: it says the growth was never the load-bearing part of that row, and the
next lever aimed at it should be expected to under-deliver too. A change that
lands precisely and moves the headline number very little is evidence about the
system, not a failure.

## Batch AZ — the Sharpshooter: patience

**A resource with no ceiling still needs somewhere for its payoff to go, and the
honest answer is not always "more of the same".** Focus bought critical chance,
and chance cannot pass 100% — so removing the cap on the meter would have
produced a number that stopped mattering long before it stopped growing. The
split at 100 exists because the meter and its payoff are different questions:
the meter is patience, and patience can be unbounded, but *what it buys* has to
change when the first thing it bought runs out of room.

**A fixed threshold beat the clever one.** "Convert once crit chance actually
reaches 100%" reads better in a sentence and is worse in every other way: a
built marksman crosses 100% chance at very low Focus, which makes the chance
half of his own passive vestigial and makes the conversion point depend on which
*other* nodes he happened to take. Three talents exist to buy reliable crits
while Focus is shallow; a self-adjusting threshold would have quietly deleted the
job all three do. The fixed number is also the only version that fits in a
tooltip — *the first hundred is your aim, everything past it is your force*.

**A spec's own lane is the last place its central decision should be for sale.**
Unwavering halved the Focus lost on a switch, in the lane named for the meter,
in a spec whose entire subject is not looking away. That is the same shape as
Flame Shield in the commitment spec and Stabilize in the escalation spec: an
escape hatch sold from inside the thing it escapes. The fix is not to price the
hatch higher — it is to point the node the other way, and to leave the real
opt-out (Spray of Arrows) somewhere it costs something the spine actually wants.

**Rewriting a node as an increment rather than an assignment is what lets two
nodes coexist.** Consistent Aim *set* the critical multiplier to 1.5, which was
coherent only while it was exclusive with the node that raised it — and the row
restructure had quietly dissolved that exclusivity two batches earlier, leaving
two live nodes contradicting each other. Written as −0.5 it composes with
whatever else is on the field. A "set" is a claim about the whole system; an
"add" is a claim only about itself, and only the second kind survives the system
changing around it.

**Reading Focus as a quantity is not the same as reading it as a fraction, and
uncapping the meter separates the two.** Most of the tree reads a *share* of the
meter and was untouched by the change. Two clauses read the raw count — a
per-point damage term and a "you are at maximum" gate — and both would have
broken silently in opposite directions: one scaling to absurdity, the other
naming a maximum that no longer existed. Uncapping a resource is not one edit;
it is an audit of everyone who was quietly relying on the ceiling.

## Batch BA — the Survivalist: attrition through craft

**A lane can be pointed at the opposite of the passive it feeds, and the numbers
will look fine the whole time.** His passive pays for the *count* of different
statuses on a target; his Venom lane built deeper poison. A poison build earned
+8% where a five-affliction build earned +40%, and no individual node was wrong —
each one made poison better. The fault was only visible from the spine. Hanging a
*different* affliction off each Venom node cost nothing in engine work and turned
the lane from a competitor for his own passive into a feeder of it.

**Reserving design space is a rule, not a set of edits.** Four nodes had drifted
into a future spec's fantasy — spreading rot, corpse transmission, field-wide
infection. Removing the four is the easy half; the half that lasts is writing down
*what is reserved and why*, because the next batch that adds "it also spreads to
another enemy" will do it innocently, and the idea will have been spent twice
before anyone notices. The line drawn here is worth keeping: poison is craft — a
hunter who knows which plant does what — and contagion is a plague that no longer
needs him.

**A ceiling is not automatically a fault.** Five specs in a row had theirs
removed, and it would have been easy to make it six. But his ceiling is the number
of distinct debuffs that exist, which is a design constant rather than a dial —
there was nothing to take off, only something to *say*, so the reason now lives in
the documentation where a later batch will read it before reaching for the same
lever.

**Instrument the thing the spine is about, not the thing that is easy to
measure.** Damage share moves for a dozen reasons. The average count of statuses
on a target when he strikes it moves for exactly one, and it is literally his
damage multiplier. It immediately paid for itself: the Guerilla lane reads the
higher damage share off the *lower* breadth, because its nodes multiply a count
they do not create — which the damage column alone would have read as the better
lane.

**A test that cannot fail is worse than no test, and only a negative control
finds one.** The check for "the capstone no longer infects the whole field at
battle start" read the board twenty frames after spawn, and the battle's opening
sits behind a real six-tenths-of-a-second timer. Reinstating the retired behaviour
sailed straight past it. The two source greps beside it fired, which is exactly
how a hole like this stays hidden — the control still trips, just not for the
reason you think.

## Batch BE — Communion, and the loop nobody had traced

**Two reasonable nodes can be one engine, and neither of them looks like the
problem on its own.** Communion's chance reads *the recipient's current Faith
stacks*, which is a perfectly sensible way to write "fervour spreads fastest
among the fervent" — the more of the gift someone already holds, the more
readily it takes. Apostle parks allies at 5 instead of resetting them, which is
a perfectly sensible capstone: the faithful stay faithful. Put them in the same
lane and the second one pins the first one's input at maximum forever, so a
chance written as a chance is a certainty in the only build that takes both.
Neither node was ever unreasonable. The *interaction* had simply never been
looked at, and looking at it required tracing what reads what rather than
reading either node's text.

**That is the third mechanism in this one row that only became visible when
somebody traced the reads.** The first was five effects crediting nobody at all;
the second was Communion's saturation point sitting at three stacks with two
separate nodes parking allies above it. All three were legible from the code and
invisible from the design. A row that has produced three of these is telling you
something about the method, not about the Devout: *a support's numbers are
composed of other numbers, and the composition is where the surprises live.*

**A frequency problem does not respond to a magnitude fix, and the reverse.**
Two prior batches aimed at the payout — one halved the growth clause with real
precision — and the row did not move, because the growth is 4% of it. The lever
that moved it is the one that changes how *often* the loop fires. Worth stating
plainly because the next repair will be tempted by whichever number is easiest
to reach.

**Reprice the input, not the output, when the output is a loop.** Dropping the
chance from 40% to 15% is a small edit with a non-linear effect: at 40 an ally
holding three stacks advanced with certainty, so a release *deterministically*
produced further releases and the chain sustained itself. At 15 nothing is ever
guaranteed, so the same chain decays. The interesting part is that the fix is
not "40 is too big" — it is "any value at which three stacks reaches 100% turns
a probability into a rule", and the design question is where that threshold sits
rather than how large the number is.

**Ship the number that was asked for; measure the interaction you are worried
about; take neither of the levers you thought of while worrying.** The concern
about Apostle was real and the re-measure confirms it, but a second change
shipped on the same batch as the first makes both unmeasurable — and the last
two attempts at this row were both shipped without a number in hand and both
missed.

## Batch BD — Deadfall becomes a placed hazard

**Two abilities can be the same ability and nobody notices for fourteen batches,
because nobody reads two tooltips side by side.** Deadfall and Snare Trap shared
a cost, an initiative, a cooldown, a trap cap and a one-turn stun springing at
the victim's turn start. The single distinction was that Deadfall does not let
you pick your victim — and its Perfect handed that back. Each of those numbers
was set in a different batch, by someone looking at that number, and every one
of them was defensible on its own. Convergence is not a decision anybody makes;
it is what happens when a spec pool grows without anything comparing its entries
to the kit they sit beside.

**The drawback was the design all along, and it was being apologised for.** The
whole re-spec turns on refusing to give the player a say in who the trap takes.
A snare catches one animal you chose; a deadfall sits in the trail and takes
whoever walks it. Once that is the *point*, the perfect cannot be "you name the
victim" — so the clause had to be deleted rather than reworded, because it is
precisely the sort of thing that survives a rewrite intact.

**Persistence is priced in slots, not in numbers.** Three springs at 20% is 60%
where one spring was 35%, which is barely a change in damage; what it actually
buys is three turns of denial spread across a fight, and what it actually costs
is a trap slot held for as long as the trap has charges. That cost is the
interesting part of the design, because it is the thing most likely to feel bad
— so it ships instrumented, at the gate that says no, rather than argued about.
A design decision with a counter attached to it is a decision the next batch can
actually make.

**A field that keeps its name and changes its unit is the most dangerous edit in
the file.** `deadfall_armed` counted armed traps and now counts charges. Nothing
crashes; the trap cap simply starts reading a three-charge trap as three traps
and quietly eats the talent node whose whole job is to grant more slots. There
is no compiler for this class of mistake, only the discipline of walking every
read site and saying out loud what the number now means.

**Three nodes tripled in value without being touched.** Bone Breaker pays 90
Break per spring, so a full deadfall is 270 — likely the most Break any single
cast in the game produces. Nothing about the node changed. Whenever an ability
gains repetitions, everything hanging off it multiplies, and the honest move is
to go and measure what those things now add up to rather than to notice it later
in a balance pass.

## Batch BK — the branching map, and what AN actually deleted

**Read the deletion note before rebuilding the thing it deleted, and then say
what it says rather than what it is convenient for it to have said.** This
batch's own brief asserted that Batch AN removed the old branching map for being
decorative, and that AN's forks "reconverged immediately, which is why it
measured 0% choice". Neither claim survives AN's entry. AN deleted the generator
as part of a *scaffold* batch — it wanted a playable end-to-end run to feel the
pacing before 66 pieces of content were authored against it — and the specific
thing it called out as needing deletion rather than repair was the edge-column
adjacency rule, whose comment said 70% and whose code did 53%, a disagreement
that survived three batches because the code still resolved. The 0%-choice
figure is not a measurement of the old map at all: it is AN's *line*, and AN
deliberately kept the metric reporting a permanent zero rather than deleting it,
on the grounds that a missing figure reads as a broken instrument. The old map
was never measured on this axis. Building on a premise that the previous author
never held is how a rebuild gets the same result twice, so the premise has to be
checked at the source and not in the brief.

**What the old map really guaranteed is the thing worth not rebuilding.** AN's
deletion list names `_ensure_key_route`, `_route_satisfied` and
`_guarantee_inbound` — a forward-DP check that every route reached the node
types it was supposed to reach. That is the opposite of this batch's rule, which
is that **nothing is guaranteed on a route**: route past every blacksmith and you
get no blacksmith. A guaranteed route makes every fork a detour, because whatever
you skip is waiting on the other branch. It is not that the old forks reconverged
too quickly; it is that a guarantee makes reconvergence *irrelevant*.

**A fork is only a decision if it changes what is reachable.** That sentence is
the whole batch. The mechanism that delivers it is not a rule but a shape: edges
reach the same row or an adjacent one, they never cross, and most nodes have one
exit. Nothing is sealed and nothing is announced — but a step down a row leaves
the corridor above unreachable for a measured 2.23 columns, because no edge
climbs back fast enough. The three rules that produce that number are each one
line long, and none of them mentions commitment.

**Constrain the draw; do not roll and re-roll.** Every legal edge assignment for
a column is enumerated and one is drawn weighted, and assignments that would
strand a column at a single node are simply never in the bag. Every elite spread
is generated through the standard non-adjacent-subset bijection, so an illegal
one cannot be *named*, let alone rejected. This is Batch AN's own severity-floor
argument reused: rejection sampling works until the table's shape changes and the
retry budget quietly starts failing, and the failure is invisible because the
rejected rolls leave no trace. The generator has no retry loop anywhere in it.

**Two weights are the entire feel of the map, and they should be two numbers
rather than a paragraph of special cases.** `FULL_COVER_WEIGHT` favours a step
that strands no row; `BRANCH_WEIGHT` favours a step with more edges. Everything a
designer would want to tune — how often a column is narrow, how many forks a run
offers, how deep foreclosure runs — moves with those two, and each was set by
generating a few thousand maps and reading the distribution rather than by
argument. Raising either one flattens foreclosure; that trade is the design
surface, and it is legible because it is two constants.

**A sink that shares a list with an award needs a flag, and the flag needs
exactly one reader.** The blacksmith writes bought upgrades into the same
`member["upgrades"]` list the mini-boss award writes, deliberately — one list is
what makes a bought upgrade land, wear its ◆ and hover exactly like an awarded
one. But `has_upgrade` reads that list to enforce AP's once-per-run rule on the
*mini-boss pick pool*, so without a `bought` flag, buying Honed in zone 1 would
silently delete Honed from that hero's mini-boss offers for the rest of the run.
That is a purchase eating out of the award economy, and it is precisely the kind
of coupling that ships unnoticed because nothing breaks. The flag is read in one
function and nowhere else; everything else in the project treats the two kinds of
entry as identical, which is the point of reusing the list.

**Untelegraphed is a design position, not laziness about icons.** The three event
kinds share one icon and one colour. A node visibly marked as a bane is not a
gamble, it is a wall with extra steps: the player routes around it and the node
has cost them nothing but a pixel. The cost of the position is that a bane must
be genuinely mild — it may take a resource and never a run — which is why the
negative control that matters is driving every bane against a party at 1 HP
rather than reading the JSON and agreeing with it.

**A structural change makes every derived constant a variable, and the honest
move is to say which.** AN's line held exactly two elites a zone, so talent
points per run were arithmetic: 12, 13 with the awakening, against a tree of 8.
On a branching map elites are routed *toward*, so the total is a function of the
route — a floor of 7 and a measured spread of two and a half points between the
greedy and cautious policies. Several documents stated the old number as a fact
about the game rather than as a consequence of the board. Every one of them had
to be found and re-derived, and a cautious route can now finish a run without a
complete tree, which is the elite economy working rather than a bug.

**The brief's arithmetic was wrong and the code should not repeat it.** §1 says
16 slots × 3 zones = 49 encounters. It is 48, by the same construction that made
the old number 36 (3 × 12) — the third zone's boss is the end boss, not a
fourteenth thing after it. Off-by-one in a headline figure propagates into every
document that quotes it, so it is corrected at the constant and the correction is
written down where the next reader will hit it.

---

## Batch BM — talents become meta progression (2026-08-12)

**Vertical meta progression is the thing this genre's audience is most hostile to, and it
works anyway when a difficulty ladder absorbs it.** Hades is the proof: nobody argues the
Mirror of Night ruined it, because the Heat system rose to meet it. A meta layer without a
ladder is not progression, it is the game slowly becoming easier until it stops asking
anything — which is precisely what §5 exists to prevent, and why the ladder shipped in the
same batch rather than in the next one. Shipping the tree alone would have been the version
that earns the hostility.

**The load-bearing decision is that unlocking a cell buys an OPTION, not a NODE.** Every
obvious way to build this collapses into a tree you fill in: buy the node, own the node, and
by the endgame every hero wears all twenty-seven. That version throws away twenty batches of
work — AJ through BA priced every row against the two doors it closes, and a tree with no
closed doors has no prices in it. Keeping the equip step separate means the row stays a
three-way argument forever. What the meta layer buys is not power, it is **which arguments
you are allowed to have**: a row where you own one cell has no decision in it, and a row where
you own three is the decision the spec batches designed. That is why filling a tree makes your
choices better rather than making them for you, and it is the one rule in the design a later
batch could delete without anything breaking, which is why it is stated three times in the
code and pinned by a negative control.

**The end boss is the load-bearing piece nobody would have asked for.** The tree needed a
gate that was not "play more" — a completion counter would have made rows arrive on a
schedule rather than on a demonstration. Tying rows to *beating a fixed boss at a stated
difficulty* means the player has proved they can use what they already have before being given
more, and it makes the difficulty choice at the draft the most consequential decision in the
run instead of a testing affordance. It also gives the ladder somewhere to put its teeth: one
encounter that is FIXED, so it can be learned, and that gains mechanics rather than only
numbers as the rungs climb.

**On reporting a gate number rather than fixing it.** Difficulty 1 with an untalented party
measures 12% completions. It would have been easy — and wrong — to move rung 1's multiplier
until that read like a number a first run should have. This batch created that baseline, and
the batch that creates a baseline must not correct against it; four consecutive Devout batches
went wrong exactly that way. The number is the deliverable. The lever is one float.
