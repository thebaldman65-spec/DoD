# Design Notes

Why things are the way they are. master.html holds current truth,
changelog.html holds what changed, this holds *why*. Newest first.
Not exported to docx.

## A rule that matches source text can only see one shape of violation (Batch DW) — 2026-08-29

`check_da` §3 was authored at Batch DA to catch a gate that hand-rolls the ability corpus instead of
calling `Classes.ability_corpus()`. `test_batch_cp._corpus()` is a hand-rolled ability corpus. The
two existed side by side for their whole lives and the gate read **37/0** on every battery run in
between. DV found the walk by accident, while auditing something else.

DV's diagnosis was that the fingerprint had two holes — the wrong **population** (it swept
`check_*.gd` only) and the wrong **calling convention** (it matched the pool accessors where that
walk read the constants). Both were real. **But there was a third, and it was the one that mattered
most: the fingerprint assumed that a corpus walk touches the draft pools at all.**

> `check_cl_resolver._every_ability()` is a corpus walk **in a gate** — inside the population
> `check_da` had been sweeping since DA — and it reads only `Classes.kit()` and
> `Classes.spec_abilities()`. **It reached 43 of 227.** No widening of the population would ever
> have found it, because it was never outside the population.

**The lesson is not "widen the fingerprint".** It is that a fingerprint encodes a guess about what
the violation looks like, and the guess is invisible from inside the rule. Patching the two holes
you were told about leaves the third. The way to find it is to go back to what the rule is *about* —
"is this function answering the question `ability_corpus()` exists to answer?" — and re-derive the
fingerprint from that.

**And the sharpness of a fingerprint is measurable: count the exemptions it needs.** The obvious
widening — union every mark, sweep every file — accuses **sixteen** files. Sixteen exemptions is not
a rule; it is a rule with a list of the places it has agreed not to look, and **an exemption granted
to a genuine violation is worse than the violation it covers**, because the violation is at least
visible. Sharpening the question until the catches are real took it to three catches and one
exemption:

> A function that **RETURNS** a collection built out of two or more of the game's ability-source
> families is answering *"what abilities exist?"*. A function that reads a pool and **asserts** on
> it returns void, and is not.

The return type is doing the discriminating, and that is not a trick — it is the actual difference
between enumerating and asserting.

**Two smaller things fall out of it, both about how this failure hides.** First, the cost was never
a red: a fingerprint with a hole does not fail slowly or loudly, it **passes**, and seventeen quiet
readings of 37/0 said nothing at all. Proved on demand — with the smallest walk restored, moving the
family threshold from `2` to `3` returns the gate to a clean 39/0 with a 43-of-227 walk sitting in
the tree.

Second, **a green equality over a short walk reads exactly like a green equality.** `test_batch_cp`
§3 pinned its literal-digit population as `== ["Shatter"]` and the real figure is eight; the
biconditional beside it pinned six where the truth is eight. Neither was a lie and neither could
have known. The repair is not just repointing the walk — it is that `check_dw` now **re-derives both
populations live and asserts the suite's named table equals them**, because a named population is
only useful for as long as it is still the real one.

## A dead player card and a dead enemy debuff are not the same defect (Batch DU) — 2026-08-29

DK found Empower attaching perfectly to a companion, hanging a chip, and moving no number. It ruled
the CARD's text narrow rather than teaching `_companion_hit` to read it, and the reason it gave was
right: **widening a damage loop moves a balance number, which is the designer's call and not a
repair.** DT then measured seven more statuses doing exactly the same thing, all at ratio 1.0000.

**DU widened the loop for two of them, and the difference is not size and not confidence.**

> A player effect that lands and pays nothing **costs the player a card**.
> An ENEMY effect that lands and pays nothing **costs the player nothing** — it is a malus they are
> escaping while the chip says otherwise.

The first is a dead card, and narrowing the words fixes it honestly. The second is an exploit, and
narrowing the words does not fix anything at all: you would be writing down that the enemy's debuff
is not supposed to work. **Two enemy abilities land Cripple, an enemy aims at the whole hero side
including the companion, and a crippled companion bit at full strength.** That is the whole
argument, and it is why the same evidence produced opposite decisions two batches apart.

**The corollary is the part worth keeping.** The test is not "does this effect reach the loop" — it
is **who is being paid when it fails**. Applied to the other 76 misses the answer comes back the
other way at once: they are terms a companion cannot receive at all, and a general widening would
hang visible chips on it that change nothing. **A promise that reads as working is worse than a
promise that is visibly absent**, which is the same reason DK's ruling was correct on its own case.

## An enumeration everything is built on is worth more than the thing it enumerates (Batch DU) — 2026-08-29

DA §3 ruled that `Classes.ability_corpus()` is the one authorized walk and made a gate fingerprint
anything hand-rolled. That was the right ruling and it had an unbudgeted cost nobody priced:
**every criterion in the project now inherits whatever that one walk cannot see.**

What it could not see was four live basic attacks. `apply_kit_overrides` replaces `abilities[0]`
for the four mage specs at spawn; none of the four replacements sits in a pool, so the walk read
the class kit unoverridden and came back holding **Magic Bolt, which is nobody's live basic
attack.** Nothing was wrong at runtime. Fifteen gates were quietly measuring a corpus with a hole
in it, and the recorded figure the hole produced — *"twelve cooldown-zero abilities in the
protected cores"* — is twelve INSTANCES and seven distinct names.

**The result of re-running every criterion through the fixed walk is that almost nothing moved, and
that is the finding rather than an anticlimax.** The four are basic attacks: they run a timing bar
(correctly), they are not pure buffs, they are not shields, and they carry no cooldown. **The value
was never going to be in what the correction changed** — it is that the sweeps can now be believed,
and that the one thing that DID surface was a text-standard overrun no width sweep had ever been
able to reach.

**And the lesson generalises past this walk.** A shared enumeration is a single point of
correctness for everything downstream of it, so the cost of a blind spot in it is not one defect —
it is one defect times the number of consumers, **all of which report green.** The place to look
for the next one is the same place this was: a piece of state built at RUNTIME that the authored
data does not carry.

## A price paid in tempo is still a price (Batch DT) — 2026-08-29

Pyroblast is the last cooldown-zero card in the draft, and the obvious move is to do to it what DR
did to Lunge: 0 → 3, on the reasoning that **at the end of a talent lane the price was the node,
and in a pool there is no price.** The provenance is identical — both were talent grants DO moved
wholesale into `SPEC_DRAFT_POOLS`, and both walked in still carrying the cooldown a gated lane-end
ability never needed.

**The reasoning does not transfer, and the measurement is what says so.** Lunge cost 25 mana of a
100 bar at 3.5 delay: ordinary on both axes, so "in a pool there is no price" was literally true of
it. Pyroblast costs **45 mana at 6.0 delay**, and derived across the whole 223-ability corpus those
are not ordinary numbers — **6.0 is the longest delay in the project, with nothing above it**, and
**45 is the second-highest cost in the game.** The only ability that costs more is Death Ray at 55,
and Death Ray carries a cooldown of 3. So the two heaviest casts in the game sit side by side and
exactly one of them is repeatable.

**A cooldown is not the only rate limiter, and this project has three.** Mana gates how many casts
a bar buys — two, here, with ten to spare. Delay gates how soon the caster acts again, and
cooldowns tick *in the unit's own turns*, so a 6.0-delay cast has already spent three basic
attacks' worth of tempo before any cooldown would begin counting. What a cooldown of 3 would add on
top is three further turns of his own between casts, each of them a real action he would rather
have spent on Pyroblast — call it halving its frequency, on a card whose whole identity is the one
enormous slow blow.

**The general form, and the reason this is a note rather than a ruling:** *repeatable* and *unpriced*
are not the same property, and DQ's finding measured the first. A card can be the only repeatable
thing in the draft and still be the most expensive thing in the draft. **Whether the delay and the
mana are the right two prices, or whether a third is owed, is a design question about how much a
Pyromancer should be able to lean on one button — and that is the designer's call, not a batch's.**
The options and the full derivation are in `docs/reports/DT.md` §2. Nothing was authored.

## The second damage path reads none of the first one's multipliers, and the list is long (Batch DT) — 2026-08-29

DK found that Empower attaches to a companion perfectly and pays it nothing, because a beast's
blows resolve through `_companion_hit` and that function reads none of the hero strike loop's
multiplier block. It ruled Empower to *text* rather than teaching the read, precisely because
teaching it would have been a magnitude change on beast damage.

**Empower was not the only term, and it was not close.** The attacker-side block runs 84
`raw`-mutation sites. `_companion_hit` reads **three** of them.

What makes the list less alarming than the count is that most of the misses are unreachable **by
shape rather than by oversight**, and the shape is in the signature: `_companion_hit` takes a
*float*, not an `Ability`. Every term keyed on a card — a `display_name`, a `dmg_type`, a
`special`, the grade multiplier — cannot apply to a blow that has no card behind it. A beast also
carries no `passive_id` and no talent ranks at all, which removes most of the rest.

**What is left is the honest finding: a small set of terms a beast can genuinely wear today, all of
which pay nothing.** Two of them arrive through doors nobody was watching — an enemy's Cripple,
because enemies target `_hero_side()` and that holds the beast; and Chilled, because the Hoarfrost
battle modifier stamps a summoned companion on purpose. **A Crippled beast bites at full strength.**
Measured at ratio 1.0000 over 40 seeded blows, which is DK's number exactly.

**These are DK's ruling repeating, not a bug found.** Whether a beast *should* feel a Cripple is a
design question with a real answer either way — a companion is an extension of the hunter's action,
and a malus that lands on it and does nothing is a promise the chip makes and the arithmetic
refuses. **Reported and not fixed, because every one of them is a magnitude change on beast damage
and that is new play.** The full enumeration is in `docs/reports/DT.md` §4.

## An absence is a measurement, and nobody measures the thing they already believe (Batch DS) — 2026-08-29

DR's brief was wrong about an axis being *exclusive*. DS's brief was wrong about one being
*missing* — and the second mistake is the more dangerous of the two, because an exclusivity claim
invites you to go looking for a second owner while an absence claim invites you to go build the
thing.

The sentence was *"the Hunter class has no Break generation anywhere, and a bear breaking armour is
the most natural source in the game."* The second clause is good design; the first is false by a
distance. **Twelve of the thirty Hunter draft cards generate Break.** The Beastmaster's own Unleash
lands it behind the companion's strike, and the Sharpshooter's Fault Line is a *dedicated* Break
card that the draft audit scores as one of his five distinct decisions. Had the card been authored
as briefed, it would have been a second copy of a clause already sitting in its own pool — the
thing BD §4 forbids — and it would have been authored on the strength of a sentence nobody checked.

**What made it invisible is that the field is not called what the mechanic is called.** `pressure`
IS Break. A card generates Break without its description ever using the word: Twin Hunt says
nothing about it and carries 12, Calibrating Shot says nothing and carries 8. So a careful reading
of all thirty *descriptions* — which is what a brief is written from — returns the wrong answer
confidently. The only reading that works is a sweep of the data.

**And the diagnosis underneath the wrong remedy was right, which is what makes this worth
recording rather than just correcting.** Nine effect axes were genuinely absent from all
twenty-four Hunter spec cards: HEAL, SHIELD, all three MIT- axes, AMP-TEAM, RESOURCE, STRIP, DOT,
METER-MOVE. The brief named three of them and then spent its sixth card on the one axis the class
was already well supplied with. **A correct diagnosis does not make the prescription correct** —
which is DI's lesson from the other direction, where the finding was right and the fix would have
opened a second hole.

The rule that came out of it is a mirror of DR's and lives beside it: *before declaring an axis
absent from a class, derive it — from the data, not from the prose.* The two together are one
rule with two faces. **An axis claim in either direction is a population question, and a
population question is answered by counting.**

## A single implementation reads like a single owner, and is not one (Batch DR) — 2026-08-28

The brief for this batch said cooldown manipulation belonged to the Swordmaster, and gave a good
reason: *"Answering Steel and Battle Poise are the only cards in the game that do it, both through
`_tick_cooldowns`, which BQ made the one implementation."* Both halves of that sentence are true.
The conclusion does not follow, and it took thirty seconds of `grep` to find out — `_tick_cooldowns`
has seven callers, one of them a Mage class-wide draft card whose own comment names tempo as its
axis, and another the Devout's protected core.

**The mistake is worth naming because it is structural rather than careless.** BQ's consolidation
is exactly the right engineering: four hand-written copies of "walk the dictionary and decrement"
became one function, and every later effect that wanted the behaviour reached for it. That is what
made the axis *legible* — and legibility is what made it look owned. **A one-door helper collects
its callers from everywhere, so the door being singular says nothing at all about who walks
through it.** The rule now in `CLAUDE.md` is one line: before declaring an axis exclusive, derive
the population that touches it. Not the implementations — the callers.

**The distinction the batch actually needed was a different one, and separating it is what made
the rest of the work decidable.** Two things were both being called "axis": the spec's own
currency (stances, Loyalty, Faith, Burn — exclusive by construction, one per spec) and the effect
type (area damage, control, mitigation, Break — shared, deliberately). Once those are two words,
the Swordmaster's problem states itself. His engine is as strong as any in the game and his pool
made four decisions across ten cards, because *depth of engine is not breadth of pool*, and a draft
offer only ever asks about the second. **Adding area damage to a Swordmaster does not make him less
of a Swordmaster; the stance still gates everything.** That sentence is the whole licence for §4,
and without the engine/axis split it reads like dilution.

## A suspension is a promise with an expiry date nobody wrote down (Batch DR) — 2026-08-28

`classes.gd` has carried, for several batches, a comment suspending the standing rule that no
ability may be a strictly better version of another in the same pool. It was honest work: it named
the dominated card, named the domination, and gave two specific reasons the exception was
acceptable — the two cards were acquired through different channels, and the weaker one had a
Perfect the stronger could not buy.

Both reasons were then removed by batches that had no cause to look at that card. DO made the
stronger card draftable, which killed the channel argument. CR took the Perfect off, and a suite
now asserts its absence. Neither batch was wrong on its own terms. **Nothing pointed back at the
comment, so it stood — and it stood as a live decision rather than as a defect, which is exactly
the problem.** An undocumented exception gets found by the next audit. A documented one gets
believed.

**The shape to sweep for is "strictly worse, but acceptable because X and Y".** It is the same
species as a stale denominator, and the same species as `_hold_freeze`'s header, which this batch
found three hundred lines away while removing the card: it said three callers when a later batch
had made it four, and named an argument no caller had passed in two batches. Neither was findable
from the other. **The repair is not to update the justification. It is to notice that when the
reasons are dead the exception is dead**, and this batch deleted both the comment and the card.

**And there is a trap inside the trap, which a negative control caught.** The batch's own prose
records the retirement, and prose recording a removal necessarily *names the thing removed* — so an
absence check reads the record as the removal not having happened. The gate strips comments before
it looks, and the control was run from both sides: the name put back as a comment leaves it green,
the same name put back in code turns it red. **A gate that cannot tell a record from a relapse is
not a gate.**

## A gate that buys nothing is a domination waiting to be measured (Batch DR) — 2026-08-28

Battle Poise required the Defensive guard. Answering Steel required nothing, cost less, lasted
half again as long, paid the same cooldown tick from the same constant, and added two clauses
Battle Poise had not got. The audit called it a subset and it was right, but the interesting part
is not the arithmetic — it is that the two cards were authored deliberately as *stacking partners*,
and the comment saying so is still true. A single parry held under both does take two turns off
everything he holds.

**The author asked whether the two combine and never asked which of the two you take.** Those are
different questions, and a three-card offer only ever asks the second. The stacking argument only
starts paying after the domination has already decided the pick.

**The repair was not a retune, because the defect was not a number.** The stance requirement was
pure cost with nothing bought by it — and a requirement that buys nothing is a domination waiting
for someone to measure it, whatever the numbers happen to be that week. So the guard buys
something: once a turn, a parry lets him change stance without spending an action, which is a
clause Answering Steel structurally cannot have, because it has no requirement to reward.

**Three things about the implementation are worth keeping.** It is the pivot and not the ability —
Guard Change's own Break damage, and the talent that turns that into forty points against every
enemy, stay on the card they are printed on, or a Defensive build parrying twice a turn lands
eighty free Break across the field every turn and the clause is a different card entirely. It asks
the existing door rather than deciding for itself, so Formless refusing the pivot and the
cooldown being respected are the same one call rather than two rules that will eventually
disagree. And it is not free of consequence: the pivot throws away Discipline's accumulation, like
every other call to the one pivot, so a Discipline build wants it refused and gets that by not
holding the card. **Written down at the site, because the batch that discovers it by accident will
read it as a bug.**

## Closing a bet can open one, and the ledger has to say so (Batch DO) — 2026-08-27

The charter is one sentence and it reads as an obvious tidy-up: a talent may not grant an ability,
and may not depend on one the hero might never receive. Talents are chosen before the run knowing
nothing. Twenty-two nodes broke it. Move their cards into the draft, re-author the cells to modify
something the hero owns in every run, and the layer is clean.

It is clean. `check_do` §1 reads 324 nodes, 0 granting, 0 naming a drawn ability. But the thing
worth writing down is what the move did on its way there, because it was not visible from the
brief and it will happen again to whoever takes the Occultist's Madness lane next.

**A dependency's category is not a property of the node. It is a property of where the thing it
names lives.** `oc_permanent` says *"Psychosis, Bewitchment and Hysteria the Occultist applies
never expire."* Before this batch that was a **tree-internal** dependency — Psychosis came from
`oc_mind_flay`, three rows up in its own lane, and Hysteria from `oc_hysteria` at the top of it.
The charter permits that explicitly, and for a good reason: a cross-row dependency bets on a node
the player **chooses**, not on a card they are **dealt**. Two nodes in one lane arguing with each
other is a build.

Moving Mind Flay and Mass Hysteria into the draft did not touch `oc_permanent`. It did not touch
`oc_spread`, `oc_whispers` or `oc_delirium` either. All four went from permitted to forbidden
without a character of their text changing, because **the only two appliers of Psychosis and
Hysteria in the entire game stopped being reachable without a draw.** Six node/status pairs, made
by an edit somewhere else.

That is the shape: **a charter violation can be created by fixing a different one**, and the
instrument that finds ability-name bets cannot see it, because these nodes name a *status*, not an
ability. `sm_precision` is the same species and the brief had already found it by reading — and
it, too, got worse rather than better here. It read Dazed, Crippled and Exposed; the Swordmaster
guarantees none of the three, and the last non-drawn source of the other two was `sm_lunge`, which
left the tree **in this batch**. The brief's guess that "cutting Dazed may be the whole repair" was
right when it was written and wrong by the time the repair was made.

**So the rule is: after moving anything out of a tree, re-run the sweep, and sweep for statuses as
well as for names.** `check_do` §4 does it on every battery and prints the whole list rather than
asserting a number, because the number is the thing that moves.

The second note is smaller and is about restraint. The brief said *"report the list; rule on
nothing"* for the status sweep, and six of the twelve pairs are this batch's own fault. The
temptation to fix what you just broke is strong and it is usually right. It is not right here:
re-pointing four Madness-lane nodes off Psychosis and onto Bewitchment is a re-author of a lane's
whole subject, and that is a design decision with a designer attached to it. **A cost you created
and named is a decision waiting to be made. A cost you created and quietly repaired is a decision
you made on someone else's behalf.** The six are in the open queue, labelled as DO's.

## A check that cannot fail is not a check you still have (Batch DG) — 2026-08-22

Two of the ten reds DG closed were the game being wrong, and both were one word of prose. The other
eight were not about the game at all. They were checks that had lost their subject.

That is the distinction this batch turned out to be about, and it cuts two ways that look opposite
and are the same thing.

**Six of them could not pass.** They pinned a list in `CLAUDE.md` that CW's split removed — and the
rule that list described had been retired to a bare `pass` by Batch AI, long before. So the six had
no true answer available to them. They were deleted. That breaks a standing rule this project takes
seriously, "never delete an assertion", and the reason it survives the exception is that the rule
was written to stop a *live* question being silenced. A question about something that does not
exist is not a live question. It cannot pass, it cannot fail in a way that means anything, and there
is nothing to repoint it at. Keeping it red is not evidence of anything; it is a red that the next
real red gets to hide behind — which is precisely what DF spent a whole batch undoing.

**And one of them could not fail.** `test_batch_cd` sliced `CLAUDE.md` from an anchor and stopped at
the next standing heading, searching for three hashes in a file that uses two. The search failed
every time it ran, the guard fell through, and the slice quietly ran to end of file — twice the
intended reach. Every assertion under it went on passing, because the sentence it was looking for
happened to live inside the true block as well. Nothing was ever red. The check had stopped asking
its question and the only symptom was silence.

Those two are the same defect wearing opposite colours: **an assertion whose outcome no longer
depends on the thing it was written to watch.** One announces itself constantly and means nothing;
the other says nothing and means nothing. The second is worse, and it was found in the suite whose
entire job is finding checks that cannot fail — which is the real lesson, because it means the
hygiene suite had no hygiene check pointed at itself.

The repair is the general answer rather than the specific one: the guard now asserts that it
*resolved*. A fall-through is only silent while nothing asks. That is one extra check, and it makes
an anchor that stops matching a red instead of a quiet widening — which is the only reason anyone
would ever find out.

There is a smaller note underneath all of it about counting. One `CLAUDE.md` block stated the
draft's size twice, forty-nine lines apart, with different answers, and had done for many batches.
Grepping for other copies found three more, one of them in the header of the very file the count is
derived from. **A number written into prose is a number nobody re-derives.** The project already
knew this — "a second copy of a number is this project's oldest recurring defect" is written into
`baselines.json` itself — and it still had five live copies of one figure. Knowing the rule and
holding the copies are apparently not the same skill.

## A red that sits among stale reds is invisible (Batch DF) — 2026-08-22

Forty-seven assertions had been failing for five batches. Every batch since DB knew the number,
carried it in `docs/state.md`, and moved on — correctly, each time: DD and DE were consolidation
batches and the standing instruction was that each of the 47 needed a ruling on what it should ask
INSTEAD. Nobody was being careless. The pile was deliberate.

**The pile was also the hiding place.** Sorting it turned up one assertion that was not stale at
all: `test_batch_bj` §2 asserts that Consecrated Ground's card reads "kindled 1 Faith", and the card
reads "kindled 2" against a constant that pays 1. The check was right. It had been right, and red,
and saying so, since Batch DA — through DB, DC, DD and DE.

The mechanism is worth naming because it is not a mistake anyone made. **A failing check
communicates by failing.** That is its entire vocabulary. Put it in a set of 47 other failing checks
that are all known to be stale, and the signal it emits is identical to the noise around it — so the
one honest red in the pile is not merely overlooked, it is *unable to speak*. The batch that
declared the other 46 stale did not need to be wrong about any of them for this to happen. It only
needed to be right about them collectively and never ask individually.

`baselines.json` was DE's answer to a near neighbour of this: a red suite at its recorded count is
not news, and a red suite that MOVES is. That closes the case where a NEW failure arrives underneath
an old one. It does not close this one, because here nothing moved — the count was 1 at DA and 1 at
DE, faithfully recorded, correct in every document, and wrong about what it meant.

**What actually closes it is the sort.** Not the repair — the sort. Bucketing all 47 before touching
any of them is what forced the question "is this one stale?" to be asked forty-seven separate times
instead of once, and the answer differed on two of them. The brief that commissioned this batch said
so in advance and was right: *if a failure's bucket is not obvious, it is bucket 2 or 3, and the cost
of misfiling a WRONG as a STALE is that a real bug gets a green check written over it.* Had the 37
been repaired without sorting, `bj` would have been repaired too — its assertion rewritten to match
the card — and the game would have gone on paying half what it promises, with a green check over it
and the evidence gone.

There is a second-order lesson about *why* the Consecrated Ground defect existed at all, and it is
the more transferable half. CZ raised `FAITH_PER_GROUND_TURN` from 1 to 2 and moved the card's text
with it, correctly, in the same commit. DA reverted the constant and did not move the text back.
**A revert is not the inverse of a change** — a change is written by someone thinking about the
number, and a revert is written by someone thinking about the constant. DC later swept exactly this
defect, found the Devout's `passive_desc` and the `faith` status chip, fixed both, and did not reach
the ability's own card. All three sweeps were competent. None of them was a grep for the *number*,
which is the only search that finds prose: the card says "2 Faith" and never says
`FAITH_PER_GROUND_TURN`.

The same shape appears one layer out in DC's threshold sweep. DC moved `FAITH_RELEASE` 5 → 3 and
repaired 23 assertions across five suites, thoroughly and with the counts published either side.
Eight more sat in `bu` and `ce` the whole time, and they were unreachable by any search DC could
have run: they read `w.faith_peak == 5` and `1 + ELEVATION_STACKS_TEST`. **They are arithmetic
about the threshold rather than references to it.** A constant's blast radius is every assertion
that pins a consequence of it, and the only reliable way to enumerate that radius is to change the
constant and let the failures name themselves — which is what a battery is for, and why an
implement-only batch defers the finding rather than avoiding it.

## An instrument's scope is part of its reading (Batch DD) — 2026-08-21

`test_batch_cd` is the only thing in the project that compares a check count to what it should be.
It exists because two suites once printed counts wrong by 125 and 2,434 checks and nobody saw it
for twelve batches. It is, in other words, the instrument built for the project's signature
failure — and from CD until DD its table held **five suites out of forty-five**.

Nothing about that was hidden. The five were written out in a const at the top of the file, in
alphabetical order, with a comment explaining the floor. Anybody could read it. What nobody did was
ask what the five were a sample *of*.

The cost came due at DC. Five suites were repaired — every Faith threshold assertion in `be`
through `bi`, twenty-three of them — and `cd` did not move by one line. That is not a bug in `cd`;
it is `cd` correctly reporting on the five suites it watches, none of which was one of the five that
changed. But the sentence it produced in the report — *the count-differ is unchanged* — reads
exactly like the sentence a differ over the whole tree would have produced. **A green instrument
over a ninth of the tree is indistinguishable, in prose, from a green instrument over the tree.**

The generalisable part is not "widen the table". It is that **a verification result carries a scope
that the result itself does not state**, and prose drops it every time. "Every count is identical"
means every count *the thing that measured it was looking at*. "Zero throws" means zero throws *in
the 45 things the battery runs*, which is not the 47 files that exist. "The gates all pass" meant,
for ten of the nineteen, that nobody could see their check counts at all.

So the rule this batch is written against: **when a verification says nothing moved, the next
question is what it was watching** — and the answer belongs beside the result, not in the reader's
head. `cd`'s table is forty-five rows now and says in its own comment that they are not the
battery's forty-five: a suite cannot drive itself, so `cd` is missing, and `test_batch_cp` is
present because the battery's own array misses it. Saying "all 45" without saying which 45 is how a
gap survives a headline.

## The noise was the width of the question (Batch DD) — 2026-08-21

`CLAUDE.md` has said for several batches that a bare `<` between two damage rolls is a coin flip
with good odds, and that the fix is to assert a ratio with a margin. `test_batch_at`'s flaky check
*was* a ratio with a margin. So was the second flaky check in the same suite that nobody had
recorded until seeding the first one exposed it.

The arithmetic is what makes it interesting. The first line of the strike block is
`randf_range(0.9, 1.1)`. One blow therefore carries ±10%; a **ratio of two blows carries up to
22%**. The Cannon check's band is 1.35–1.85 around a passive that pays 1.54 — ±20%. The band was
*narrower than the noise it was written to tolerate*, and it failed in two runs of five while its
check count never moved by one, which is exactly the shape a count-diffing rule misreads as a
regression.

The tempting fix is to open the band. It is the wrong one, and the reason is worth writing down:
**the band is not a tolerance, it is the question**. It exists to separate 1.54 — the passive alone
— from 2.46, the passive times the ability term that Batch AU removed. Open it far enough to
swallow ±22% and it stops telling those two apart, at which point the check passes forever and
means nothing. **A margin wide enough to absorb the noise is a margin wide enough to absorb the
bug.**

The fix that keeps the question is to remove the noise instead: seed the same value immediately
before *each blow of the compared pair*, so both draw the identical variance and the only thing
left between them is the eight stacks under test. That is the AK/AL/AR discipline — force
determinism rather than retry until it passes — applied one level down, to the pair rather than to
the suite. And where a check averages a *loop* of pairs, the seed varies per iteration, because
seeding the whole loop to one value would collapse ten measurements into the same measurement ten
times: the averaging is doing real work and pinning it away would be another way of narrowing what
the check asks.

## A passive paid in what the party is trying to prevent will fight every batch that helps (Batch CZ) — 2026-08-21

Blood Frenzy pays the Berserker for health he has already lost. That reads as a clean risk-reward
design and it is one — right up until you notice what it does to the rest of the project. **Every
improvement to party survivability weakens him.** Better healing, better mitigation, better play:
each of them takes away the thing his passive is paid in. CY did not set out to nerf the Berserker;
it made buffs cheaper to hold, the party held more of them, he took less damage, and his own band
got *shallower* in a batch that was aimed at helping him.

**That is not a tuning problem and it does not have a tuning fix.** Any number you pick is a number
the next batch's mitigation buff will erode. The fix has to be structural, and the shape of it is:
give the passive a second term that reads something the party cannot take away.

**Rage spent is that term, and the reason it is the right one is not that it was available — it is
that he controls it.** Every other candidate was some version of "the fight went badly", which is
the same failure one door along. His pool already moves Rage constantly (Blood Offering, Reckless
Abandon, Unslaked, Boil Over), so his own cards start feeding his own passive, which is a coupling
the spec has never had. He spends the resource anyway; now the spending is worth something twice.

**The half of the design that took the most thought was refusing to raise his ceiling.** The
obvious version adds the Rage term on top and the band gets deeper — and that changes what the spec
IS, because "he fights better hurt" stops being the whole story if he can reach the same numbers
without being hurt at all. So the two terms are summed and then clamped at the twentieth step,
which is exactly where the missing-health term already topped out. **The second term makes the band
arrive sooner and can never make it bigger.** A Berserker at death's door gets nothing from it,
which is the correct answer: at that point the identity term is already paying in full.

**The general rule, because this will recur: a passive paid in damage taken inverts against every
improvement to party survivability, so it needs a second term the hero controls.** Faith is the
same family from the other side — it is paid in absorbs, which also require the party to be under
pressure — and it needed the same kind of help for a related reason.

## What a meter measures is not always what the report says it measures (Batch CZ) — 2026-08-21

Four batches have now quoted "Faith reaches a third of the 5 a release needs, so the average fight
ends without a release ever firing." The first half is a real measurement. **The second half is not
what that number says, and nobody noticed for two batches because the two readings agree about
whether the situation is bad.**

The arrival row samples the Devout's own meter. **His Faith holds at the threshold and never
releases, by rule, and has since Batch BH.** So the row has never been able to say anything about
release frequency — it measures how full one non-releasing meter gets. The number that answers the
actual question was printed four lines below it the whole time: `releases/battle`, which read 0.51
to 1.49 on unmodified HEAD. Releases were firing, roughly one a battle.

**The instrument was not wrong. The sentence attached to it was.** That distinction matters because
the repair is different in each case: a wrong instrument gets rebuilt, a wrong sentence gets
rewritten, and rebuilding an instrument mid-comparison throws away every figure you wanted to
compare against. So the row keeps its meaning, the caveat is written beside it in the code, and
both numbers get reported from here rather than one standing in for the other.

**The generalisation worth keeping: when a measurement and its interpretation agree about the
VERDICT, nothing forces anyone to check whether they agree about the SUBJECT.** Faith was
genuinely under-arriving and a release genuinely was too rare, so every consequence drawn from the
mis-reading happened to be sound. It would have kept being sound until somebody tried to fix the
number rather than the mechanism — which is what this batch was, and is why it surfaced here.

## Shortening a bar and filling it faster are different fixes, and the difference is the held half (Batch CZ) — 2026-08-21

Faith's threshold moved from 5 to 3 and both its builders rose. Either change alone would have
raised the release count; the reason both were needed is that they do different things to the
*other* half of the meter.

Faith pays mitigation and damage on the highest count held this battle, and the count caps at the
threshold. **So lowering the threshold lowers the held ceiling too** — the deepest benefit an ally
can carry fell from five stacks to three, which is a real cost paid by every ally at once. Raising
the builders is what buys some of that back: a shorter bar filled faster reaches its (lower) peak
more reliably, so more allies spend more of the fight at the top of it rather than partway up.

**The lane trades depth of hold for frequency of release, deliberately**, and that is a design
statement rather than a tuning outcome. It is worth writing down because the reverse trade is
always available and looks equally reasonable on paper — a taller bar filled slower would make each
stack matter more and each release rarer, which is what the lane already had and what four batches
of measurement said was not working.

**The thing that nearly went wrong: at three Faith per absorbed hit against a threshold of three,
one absorbed hit is a whole release.** A shielded ally never *holds* Faith at all — he fills and
pays out on the same blow. Nothing is lost mechanically, because the peak keeps paying, but the
card stops being a ramp and becomes a per-hit heal, and that is a different card wearing the same
text. It shipped because the brief named both builders, and it is flagged in the code beside the
constant with the measured alternative one character away. **A magnitude that changes what a card
IS should never be a silent consequence of a threshold moving somewhere else.**

## A literal that used to be safe becomes a trap the moment the thing it guards moves (Batch CZ) — 2026-08-21

CY capped pure buffs at 1.0. `up_speed`'s floor was a literal `1.0`. The upgrade was live on
fifty-two abilities the day before and bought nothing at all the day after, and **nothing anywhere
said so** — not a test, not a warning, not a log line. `maxf(1.0 * 0.75, 1.0)` is a perfectly
healthy-looking expression.

CR's rule covers half of this already: *a change to a value is not finished when every site that
computes it is updated; it is finished when every site that QUOTES it is updated.* The other half
is the one this found: **a floor is a quoting site even when it quotes a number nobody thought of
as related.** The floor was not written against the buff cap — the buff cap did not exist when the
floor was written. It became a quote of it retroactively, by collision.

The repair is the same discipline CY used one rung up: write the floor against the cap
(`BUFF_DELAY_CAP * 0.5`) so the ladder moves as one thing. **The more useful half of the repair is
the assertion**, which is general rather than a list: Swift must change the delay of every ability
`upgrade_fits` says it fits. That is true today and stays true whatever a later batch authors,
where a list of fifty-two names would have rotted immediately.

**And `upgrade_fits` had a comment explaining why it never asked.** "Swift is the one that fits
everything — every ability has a delay." True for eight batches, false overnight, and the comment
is what stopped anyone looking. **A justification for not checking something is a thing to re-read
whenever the thing it talks about changes**, and nothing in a diff points at it.

## A shield is setup and a heal is a response, which is why only one of them gets cheaper (Batch CZ) — 2026-08-21

CY capped pure buffs and left six shields and fifteen heals alone, reporting both as rulings owed.
The two look adjacent and they are not, and the line between them is worth stating because it will
be asked again about the next category.

**A shield is played before the blow. A heal answers one that has already landed.** That is the
whole distinction and it decides the tempo question by itself: setup has to be bought speculatively,
out of a fight that lasts three to five turns per hero, and if it costs a full swing it never
returns its price. A heal's turn has already been earned by the thing it is answering — the damage
happened, somebody has to fix it, and no player is weighing "is this worth a turn" the way they
weigh a pre-emptive buff.

**The mechanical criterion that separated them at CY is still correct and is not what decided
this.** A shield is a consumable absorb pool; percentage mitigation for N turns is not one. That
answers *what kind of thing is this*, which is a different question from *what should it cost in
tempo*, and conflating the two is why the shields sat unruled for a batch. So they are capped as
their own population rather than folded into `PURE_BUFFS`: CY's table stays checkable as the thing
CY derived, and there is exactly one function that unions the two for the cap to ask.

**The half that makes it a rule rather than a preference is that the negative half is asserted.**
A gate that only checks "the shields are cheap" would pass just as happily on a build where every
heal in the game had been halved too.

## The cost of a turn is only knowable once you know how many there are (Batch CY) — 2026-08-21

This batch had a rule to apply and a measurement to take, and the measurement is the part worth
keeping. **A fight in this game lasts three to five turns per hero.** Nothing in the project said
so. The sim has printed "Avg rounds/battle" since long before the class draft and it divides hero
actions by three, so it has been describing a three-hero party for as long as the party has had
four members — reading a third high, in a line nobody had reason to distrust.

**Every price in an initiative system is a fraction of a number that was never written down.** A
2.5-delay buff is expensive or cheap depending entirely on whether the fight is four turns or
twelve, and every one of the fifty-two was priced without that denominator being available to the
person pricing it. That is not a mistake anybody made; it is a measurement nobody had. The
generalisable version: **a cost expressed in turns is meaningless until the length of a fight is a
published figure**, and the same is true of durations, cooldowns and every ramp threshold in the
game.

The second finding is the one that changes what should happen next, and it is the one the brief did
not ask for. The four ramp meters were measured against the number each spec is *built* around —
Focus converts at 100, Faith releases at 5, Pack Bond reads ×2 at 5 Loyalty, Blood Frenzy's band
tops out at +40 points. **Two of the four over-shoot and two land at about a third.** Loyalty
reaches 400% of its reference and Focus 131% of its conversion point; Blood Frenzy reaches 31% of
its band and Faith 1.6 of the 5 a release needs.

The split is not random and it is not about tempo. **Loyalty and Focus tick on a timer** — a stack
per hunter turn per beast, Focus on every shot — so they arrive whether or not the fight
cooperates. **Blood Frenzy and Faith are conditional**: one pays for health already lost, the other
for absorbs and consecrated ground. A conditional meter in a four-round fight does not get four
chances, it gets however many chances the fight happens to offer, and the answer measured here is
"about one and a half".

So **the cap is the right fix for the tempo problem and is not, on its own, the fix for the ramp
problem.** Halving a setup cost gives a Devout half a turn back; it does not give him the three and
a half Faith he is short. The reserved option — starting a fight with meter on the clock — was
offered and not taken, and this measurement is the argument that it will be needed. **A rule aimed
at four things where two of them were never broken is worth noticing before the next batch aims a
second rule at the same four.**

The smaller lesson is about corpus enumeration. The Batch CL walk has been copied into three gates
and it misses five abilities, because it enumerates *pools* and a talent can grant an ability that
lives in no pool. One of the five is a pure buff. **A derived population is only as complete as the
enumeration under it, and an enumeration that has been copied three times has been reviewed
zero times** — each copy inherits the gap and adds confidence to it.

## Two words, and a number nobody could disagree with (Batch CV) — 2026-08-20

CU's audit produced fifty-odd findings and CV moved fifty-two node texts, and the interesting
thing is how few *decisions* that took. Six nodes were individually wrong and all six were
settled the same way — the code is right, the text is behind — which is not a judgement call at
all once you have both numbers side by side. Everything else came out of two conventions, and a
convention is the cheapest thing a corpus of 324 hand-written strings can be given.

The first is that a duration is stated as applied. This had been genuinely ambiguous: `4` passed
to `_apply_status` is four calendar turns and three of the bearer's own actions, and both
readings were in the trees, `cr_rime` using both in a single sentence. The argument that settles
it is not about which is more accurate — it is that **the chip is on screen**. It counts down the
raw value, so a node saying 3 while the chip shows 4 contradicts something the player is looking
at right now. The acting-turn reading is a translation, and a translation of your own code is a
second copy that will drift. That is the same reasoning CL used to ban authored parentheticals
and the same reasoning behind `_faith_stack_mult` being one function: **one number, one owner.**

The second is that HERO and ALLY are different words. This one is worth dwelling on because the
sweep found nearly twice what the brief expected — 28 nodes, not 16 — and the extra twelve are
not obscure. They were missed because "does this read site skip companions?" has three different
answers depending on *where* the skip lives. Twenty-three are an explicit
`not h.is_companion` in a `battle.gd` filter, which any grep finds. Two more are the Cleric's
Mercy generator, where the exclusion is in `unit.gd`'s `below_half_cb` gate — a *trigger* that
companions never fire rather than a filter that removes them. Three more are Faith, where
`_gain_faith` refuses companions outright, so a beast cannot hold the stack the node is written
around and the promise is vacuous rather than short. **One question, three mechanisms, and only
the first is greppable.** That is the general shape of why mechanical sweeps under-count, and it
is worth remembering the next time one comes back clean.

The corrections also run the other way, which is the part that makes the vocabulary real rather
than decorative. Four nodes said "party" while their read sites genuinely included companions,
and they now say *ally*. Two words that only ever narrow are one word with extra steps.

Two things were deliberately left alone, and both are the same rule: **a node whose behaviour
looks wrong rather than undocumented goes to the designer.** `sv_hitrun` promises Elusive
"whenever you apply a status" and `_hit_and_run` is called from four sites — narrowing the text
and widening the code are both design answers, and picking one silently is authoring. Battle
Shout is stranger: its loop has no companion filter, so companions *do* hear it, while its own
read-site comment and its chip legend both say they do not. The code and its documentation
disagree about intent, and there is no version of "fix the text" that is not also a ruling on
what the card is for.

The last thing worth recording is that two suites were **pinning the defect**. CQ's finding was
that seventeen suites asserted pre-CN magnitudes — a suite lagging the code. `test_batch_ak`
asserted High Guard's tooltip says "2 turns" and `test_batch_aw` asserted Stalwart renders 50,
and in both cases the code had never agreed. That is the same fault from the other direction: an
assertion written from the text rather than from the read site turns a documentation bug into a
regression test for it. **A check should read the thing that computes, not the thing that
describes.**

## The errors clustered, and the cluster was the finding (Batch CU) — 2026-08-20

The talent audit had been owed since CJ and was framed by its own record as ninety-two separate
problems: ninety-two nodes state a number their payload cannot produce, so ninety-two read sites
have to be opened one at a time. That framing was right about the method and wrong about the
shape of the answer. Almost all ninety-two are correct — the flag payload is an idiom, not a
fault, and the magnitude at the read site matches the text. Six are wrong, and four of the six
were broken by one event.

That event was Batch CN taking the skill-check bar off a hundred and thirteen abilities. When an
ability loses its bar its perfect becomes unreachable, and CQ's fold audit dealt with the
consequence *for the abilities* — the perfect's number became the base, and CQ recorded every
row. What nobody swept was everything else that had quoted those numbers. A talent node that
says "up from the base 30%" is a second copy of a number it does not own, and Divine Shield's
base had moved to 35% in CQ's own table while the talent quoting it stayed at 30. Four more nodes
still advertise a "Perfect:" clause on an ability that has had no bar for two batches.

The general rule this batch is worth stating for: **a change to a value is not finished when
every site that computes it is updated; it is finished when every site that quotes it is
updated.** The quoting sites are in a different file, are prose rather than code, and no test
touches them. CN's change was correct, CQ's accounting of it was thorough, and the aftershock
still landed three batches later in a population neither of them was looking at.

The second finding has the same shape from the other direction. Sixteen nodes promise "every
ally" or "the whole party" and every one of their read sites skips companions. Sixteen
consistent exclusions is not sixteen oversights; it is a house rule that was never written down,
and it was found by asking one mechanical question of all three hundred and twenty-four nodes at
once rather than by reading them. That is the cheap way to close the rest of this audit: the
line-by-line read reached sixty-eight of the three hundred and twenty-four and produced roughly
one finding per ten nodes, which is honest about how much is still unread, and the sweep reached
all of them in one pass.

Nothing was fixed, and that is the point rather than a limitation. CQ examined a hundred and five
changes and altered exactly one, because talent and ability values reach the designer as options.
Six magnitudes corrected on this batch's own judgement would have repeated the fault the batch
was sent to find, and would have destroyed the evidence: after the fix nobody can tell whether
the text or the code was the thing that was right. The one carve-out taken was the brief's own —
a node that cannot be audited without running it may be run — and it earned itself immediately.
No amount of reading `talents.gd` can show that a node's "Perfect:" clause is dead, because the
claim is in the node and the refutation is in `Ability.runs_skill_check()`. `check_cu.gd` asks
the live objects, and four of the six bucket-1 items came out of that one question.

## A ruling stated as a rule, applied to a list (Batch CR) — 2026-08-19

CQ's census found the fold and handed it over. CR is the designer's answer, and the answer has the
same shape as the thing it corrects.

§3 states a rule and states it carefully: **`duration > cooldown`, not `duration >= cooldown`** — a
buff whose duration equals its cooldown still spends an action and its resource every cycle, which
is a real cost, and only slack on top makes the decision disappear. That refinement is right, and it
is a genuine improvement on CQ's `>=` classification. It then names three abilities to revert.

Applied as written, the rule catches thirteen. CQ's own published table is what shows it: its
twenty-two "`>= cd` (already)" rows are not twenty-two abilities that were already permanent — that
label meant the pre-fold value was already at *or* past the cooldown, and for seventeen of them it
was exactly *at* it. Under `>`, "at" is the tradeoff the ruling wants to keep, and the fold pushed
all seventeen past it. Ten of those are self or party buffs, which is §3's own declared scope, and
three of the ten are the three that got reverted.

**So the accepted bucket in §4 is defined by one test and the revert in §3 by a different one, and
the rows fall through the gap.** §4 accepts "the 22 durations already at or past their cooldown
before CN" — that sentence is CQ's `>=` reading, and it swallows the exact rows §3's `>` reading
would revert. Only five of the twenty-two were genuinely past their cooldown before the fold.

The generalisable bit is not "the brief was wrong". It is that **a rule and a list are different
artefacts, and shipping both invites the reader to assume they agree.** The list is what gets
applied; the rule is what gets remembered and cited later. When they disagree, the disagreement is
invisible for exactly as long as nobody recomputes the rule — which, on this project, has been about
one batch. CQ's fold looked local 105 times; this ruling looks complete once. Both need the same
defence: compute the aggregate, put it beside the list, and let the person whose call it is see the
difference before it is spent.

Three of the seven cards this batch touched also make the smaller point that **an orphaned Perfect
is not one question but two.** CN's criterion answered "does this ability still grade?" correctly
every time. It did not answer "and what becomes of the bonus?", and folding was assumed to be the
answer because it is the answer that preserves the most. For Bewitch it granted a free extra enemy
attack that nothing gates; for Flash Freeze and Snare Trap it deleted boss immunity to hard control
across the whole game, because "only on a Perfect" was the gate and the gate was the bar. Neither
is visible as a magnitude. The fix for the second was not to restore the old condition — it is no
longer expressible — but to move the gate onto Broken, a mechanic that already exists and that the
Occultist's whole lane already depends on. **That is better than what it replaced: a bypass earned
through play rather than through timing.**

## A mechanical consequence is still a decision (Batch CQ) — 2026-08-18

CN removed the timing bar from 113 abilities on a criterion that was right, and that left 105
Perfect bonuses with nothing to fire them. Folding each one into its base effect is the obvious
answer, it is what CN did, and at every single one of the 105 sites it is defensible: the bonus
existed, the player can no longer earn it, and deleting it outright would quietly nerf 105 cards.

**The trouble is that the same argument is available 105 times, and nobody ever has to think about
the total.** Each fold is a two-token edit — `X if is_perfect else Y` becomes `X` — and reads as
tidying up after a decision already taken. Nothing in the diff says "this card is now 50% stronger
for the rest of the run". Reviewing the fold card by card, which is the natural way to review it,
is the one way to guarantee you never see the size of it.

What the census showed once it was taken: **40 of the 57 duration folds now meet or exceed the
ability's own cooldown, 18 of them pushed over the line by the fold itself.** A buff whose duration
reaches its cooldown is not a longer buff, it is a *permanent* one — the cooldown has stopped being
a constraint and has become a formality. That is a change in kind, not degree, and it is invisible
in a diff of magnitudes because the magnitude that moved (3 to 4) says nothing about the number it
has to be compared against (a cooldown declared 200 lines away in another file).

The generalisable bit: **the batch that performs a sweeping mechanical change is the one least able
to judge it, because a sweep is exactly the shape that makes each instance look local.** The defence
is not more care per site — care per site is what produced this — it is to compute the aggregate and
put it in front of the person whose call it is. Report all 105, revert only where the fold overwrote
a decision that was actually made (Elevation, where the designer had picked 2 over 3 with a raised
cost eight batches earlier), and leave the rest alone. A batch that "corrects" 105 magnitudes on its
own judgment has repeated the fault it was sent to find.

There is a smaller version of the same lesson in the two abilities whose folded Perfect had never
been implemented at all. Mana Shield promised a cheaper initiative cost and Mass Hysteria a shorter
cooldown; neither handler had ever contained an `is_perfect` branch. **Reading the read site rather
than the tooltip is what separated a real magnitude change from a deleted lie**, and it is why the
audit is worth more than the diff that motivated it — the diff would have shown 105 identical-looking
edits and the read sites showed 103 changes and 2 corrections.

## A guard that names the bots is not a guard against their absence (Batch CQ §1) — 2026-08-18

Four suites hung for five batches, and the reason is a sentence that reads as obviously complete:
`if sim or autoplay`. Those are the two bots. Everything that is not a bot is a player, so the
`else` branch can safely wait for a key press.

Except a hand-driven test suite is neither. It sets `Run.active`, clears `sim`, `autoplay` and
`sim_run` — **deliberately**, because it wants the real battle path rather than the simulated one —
and then it is a third thing the dichotomy never contemplated: a caller that is not a bot and has no
hands. The await it reaches can never complete, and the failure presents as a process sitting at 0%
CPU with its output buffer unflushed, which looks far more like an environment problem than a logic
one.

Two things made it durable. The first is that the previous batch found a *different* await with the
same shape (the orientation cards), fixed it, saw the suites still hang, and correctly reverted —
a right diagnosis of a real defect that happened not to be *this* defect, which is one of the more
expensive things that can happen to an investigation. The second is that the codebase had already
answered the question in a third place: `check_cm_live.gd` set two Profile flags by hand to dodge
the cards. **A workaround in one file is the shape of a bug nobody has named yet** — it is what
knowledge of a trap looks like before someone writes the guard.

The fix is one predicate, `_nobody_can_press()`, read by all three sites, and its third term is
`DisplayServer.get_name() == "headless"`. That term is the honest one: it asks whether there is a
surface to draw on and a device to press with, which is the question the await actually depends on,
rather than enumerating the callers who happen not to have one.

## The brief's own examples failed its own scope limit (Batch CO) — 2026-08-18

The batch named five cards as cases of the bug and then, one section later, set a scope limit that
excludes four of them. That is not a contradiction in the brief; it is the brief being honest that
**a list of symptoms is not a list of things to fix.** Funeral Pyre, Stabilize, Battle Shout and
Reckless Abandon all genuinely lose a snapshot to `max()` — and all four also hand the player
something else on the way through: Mana back from the Burn, Mana and a heal from the vented
Resonance, five Rage, the whole Rage bar spent on a multiplier. Refuse any of them and you have
deleted a resource conversion the player deliberately chose.

The generalisable bit: **when a rule and its motivating examples disagree, the examples are
usually the thing that was observed and the rule is the thing that was reasoned.** The examples got
onto the list because someone noticed the waste, which is a real observation about a real card. The
scope limit got written because someone then asked what refusing would cost, which is a different
question, and only the second question is answerable per card. Deriving the set from the second
question and letting four of the five headline cards fall out of it felt wrong for about ten
minutes and is obviously right afterwards.

**The trap CN warned about was here, twice, and the second one was not the one CN named.** The
first is the known one: `damage: 0` says nothing, because half the corpus works inside a `special`
handler. The second is that `power` is not always a magnitude. Mark of the Hunt, Snare Line, Eye
of the Storm and Vendetta store `heroes.find(attacker)` in the status power — the field is an owner
index there, not a number that can be larger or smaller in any meaningful sense. A rule that
compares "the power the cast would produce" against "the power already held" is arithmetic on a
slot number for those four, and would have refused Mark of the Hunt for hero 0 while allowing it
for hero 2. **A shared field with two meanings is a trap that only springs for the batch that
first tries to reason about the field generically**, and there is no way to find it except by
reading every site.

**The sharpest thing found, and it is recorded rather than fixed.** `add_status` maxes power;
`update_status` *assigns* it. Battle Shout, Stabilize and Eye of the Storm call the second one
with a computed value right after the first, so on those three cards a weaker recast does not
merely fail to improve — it drags the standing buff *down*. That is worse than the bug the batch
was written to fix, and all three are outside the batch's scope because their payload is more than
the status. Widening the scope to reach them would have meant refusing casts that convert
resources, which is the exact failure the scope limit exists to prevent. **Two true things can
both be true and still not belong in the same batch**; the note is here so the next author does
not have to rediscover it from the symptom.

**On reconciling BM's fix rather than assuming it.** The brief said to read `_grant_divine_shield`
before touching it because it "may refuse, refresh, or replace". It does none of those: Layered
Faith pre-adds the standing pool so the max lands on the sum, which makes the recast **additive**.
The general rule therefore never fires on it, the two compose with no special case, and the
bespoke path stays. The instructive part is that the reconciliation ran the *other* way too — the
gate has to read Layered Faith when it computes the power, or the general rule would have refused
casts for the one build that had already solved the problem. **A bespoke fix you are generalising
is also a constraint on the generalisation**, not just a candidate for deletion.

The one that *was* deletable turned up on the way past: Batch BV had already written this exact
rule for Bloodbond alone, as a hand-rolled `has_status` check in the same function. Battle-long,
fixed share, so the general rule refuses it in precisely the same cases. Two rules on one status
is how a status ends up behaving differently from every other for reasons nobody can reconstruct,
so it went.

## The criterion that could not be read off the fields (Batch CN) — 2026-08-18

The brief said the criterion was mechanical rather than categorical, and it was right about the
principle and wrong about where to look. "No damage and no Break damage" run against the ability's
own fields catches 137 of 211 cards — and among them Feint, Guard Change, Kill Command, Savage
Sweep, Precision Strike, Harvest and Call the Wilds, every one of which hits somebody hard.
`damage: 0, pressure: 0` is simply what an ability looks like when its work happens inside a
`special` handler, and roughly half the corpus is built that way. **A mechanical criterion is only
as good as the thing it is mechanically reading**, and the readable surface here was three fields
that stopped describing the game some time around the fortieth card.

The fix was to read what actually resolves — walk the handler's call graph down to its damage and
healing leaves — which is more work and is still mechanical, still checkable, still not a judgment
per card. The general shape: **when a data-level test disagrees with the design intent, the usual
fault is that the data stopped being where the behaviour lives.** Worth asking of any rule the
project writes against `Ability`'s fields.

**One thing the criterion could not decide, and it is the interesting one.** Heals keep their
check because the grade multiplies a heal — but Renewal heals through a status it applies, so at
cast time nothing is healed and no mechanical read can tell it from a buff. Heal, sitting beside
it in the same kit, would have kept its bar while Renewal lost one. That list is authored rather
than derived, and the boundary is honest: "is this ability a heal" turns out to be a question
about the card rather than about the code, and pretending otherwise would have produced a
defensible rule and an incoherent kit.

**And one place obeying the criterion would have deleted a feature in silence.** Reckless Abandon
spends the whole Rage bar for a three-turn multiplier: no damage, no Break damage, caught cleanly.
It is also one of Batch CM's five gated abilities, where a Sloppy loses the cast outright — the
largest thing a grade moves anywhere in the game. **An ability whose Sloppy loses the cast cannot
lose the check that produces the Sloppy.** The criterion was extended rather than excepted, but
the lesson is about the shape of the work: a rule applied across a corpus will meet a case the
rule's author had not met yet, and the batch after the one that introduced it is exactly when that
happens.

## The feature that was already built (Batch CM) — 2026-08-17

Two features landed here and neither needed a mechanism. The gate — a Sloppy check loses the cast
— reads like it wants a refund path: five abilities, each spending something different, one of
them spending a resource that belongs to the *enemy*. Writing "give it back" for Requiem, Unleash
and Boil Over would have meant inventing three answers to a question nobody had asked, because
none of the three takes anything from the caster at all. **The Cancel button had already answered
it.** Cancelling returns to the action bar with nothing spent, *after* a target has been chosen,
which means consumption has always happened downstream of the grade. A gated failure is that same
path with the turn spent instead of returned. The whole implementation is declining to enter the
function where everything is taken.

**The general shape is worth keeping: before building a mechanism for "undo", check whether the
thing was ever done.** The ordering that made this free was not designed for it — it was designed
for a cancel button — and it has been sitting there since long before anyone wanted a gate.

**On what the gate is actually spending.** It costs the turn, and *only* the turn, which sounds
mild until you look at where these abilities sit on the timeline. Death Ray costs 5.0 initiative.
Losing it is not losing a cast, it is losing a cast plus the five ticks of everyone else's turns
that were the price of taking it. **The punishment did not have to be invented either; it is the
initiative system charging its ordinary fee for nothing in return.**

**On the defensive check, and the one number the batch was really for.** The design question was
never whether mitigation on a timing bar is good — it plainly is, and Sloppy being identical to
Good makes it strictly free to attempt. The question was pacing, and pacing is not answerable from
a chair. So it shipped uncapped and measured: **the party's presses go up about a third, but the
Warden's own roughly double**, because the bar lands on the unit already being attacked most. That
distinction is the whole finding. A per-party number would have looked fine and hidden the fact
that one player is now pressing space twice as often as they were, on turns that are not theirs.
**A cap is now a decision about a measurement rather than a guess, which is what "uncapped for the
first pass" was for.**

**And one narrowing worth remembering.** Counters raise no bar. The letter of the brief said every
qualifying incoming attack, and a counter is one — but the offensive bar has never run for a
counter either, and the symmetry is the better rule: **a bar belongs to an action somebody chose to
be in.** Reported rather than assumed, because it is a designer's call and it is one condition.

## The rule that outlived its own deletion (Batch CL) — 2026-08-17

CL's §1 removed the two-tier arithmetic split by removing its premise. The tiers existed because
mid-combat surfaces could not show arithmetic, so formulas were allowed on the draft screen and
banned everywhere else; once a percentage is followed by its computed value, nobody is doing
arithmetic anywhere and the formula can stay visible on every surface. **The brief was explicit
that the standard should be REWRITTEN rather than appended to**, citing BY's "quote only gates 1
and 3", which survived twelve batches because it was left sitting under the rule that replaced
it. CL did rewrite `text-standard.html` §1 — and left the same rule standing in `CLAUDE.md`,
where it survived three more batches until CN went looking for it. **The instruction was
followed on the document it named and not on the copy nobody thought of as a copy.** The general
version: a rule that lives in two places is not superseded until both are edited, and the file
you are editing is never the one that will bite you.

**The other thing CL got right and filed wrong.** §1 predicted the parenthetical would push
hand-wrapped lines past the 44-character ceiling, and told the batch to ship, measure, then fix
only what overflowed rather than pre-emptively rewrapping 936 lines — this project has twice set
a number it had not measured. The measurement came back **zero lines pushed over**, which is the
best possible answer and the reason no rewrap happened. It went into `text-standard.html` §4.8,
where it reads as a note about the standard rather than as the report a batch owed. **A report
filed next to the rule it validates is invisible to anyone asking what the batch did** — the
finding was not missing, it was misfiled, which is harder to notice than missing.

**And the report CL did not produce at all is the one worth having.** §5 asked what a second cast
does, per ability, from the code. Reading the code turns up a single root: `add_status` resolves a
reapplied status as `max(old, new)` on both duration and power. For a constant power that is a
fine answer. For a power that is a **snapshot of live state** it means the cost is paid and the
effect discarded — Stabilize spends the Resonance and keeps the older mitigation, Funeral Pyre
eats the Burn and keeps the older shield. **The tell that this was never a decision is that Batch
BM already found it**, wrote it down in `_grant_divine_shield`, and fixed it for Divine Shield
alone while the Layered Faith talent is held. **A default that one batch had to override at one
call site is a default, not an answer** — and the remaining sites are a design question rather
than a bug to be swept, which is why §5 said report and not fix.

## An audit is a claim, and a claim can be wrong (Batch CK) — 2026-08-17

CJ's report named the draft card's missing numbers as its largest bucket-2 finding and ended the
item with an instruction: render the same computed block the blacksmith card already builds. CK's
brief carried that sentence forward verbatim. **The blacksmith card builds no computed block.** It
renders an upgrade description and an ability description and no computed values at all — thirty
seconds of reading proves it, and neither the audit nor the brief that quoted the audit had spent
those thirty seconds.

**Nothing bad happened, and that is the interesting part.** The instruction's *intent* — one
implementation, not a second copy — was correct, load-bearing, and the whole reason the item
existed. It was carried out. What was wrong was a factual claim inside the instruction, and the
claim was wrong in a direction that made the work look *easier* than it was: "reuse that" instead
of "write the shared one that ought to exist and point two screens at it". **An audit's findings
get re-read and re-quoted for batches afterwards; its incidental assertions travel with them and
nobody re-checks those.** The finding was right. The pointer inside it was decoration, and
decoration is what gets copied.

The practical rule this suggests: **when an audit item ends with "do X, reusing Y", the reuse
target is a claim about the code and wants verifying before the batch starts, not after.** CK's
audit section says so about its own findings — it states, in a coverage block, which of its claims
were traced to a read-site and which were read for sense. That distinction is the useful thing to
inherit from this, more than any single finding.

**A second note, on what "the computed block" turned out to cost.** The reason the draft card shows
a scaling percentage rather than a damage range is not a compromise about the standard — the draft
screen is explicitly allowed arithmetic. It is that **a hero's live Attack is built by a sixty-line
prologue that exists in three copies and in none of them on the map screen.** Building a fourth
would have been a much worse duplication than the one the batch was sent to prevent, so the shared
builder takes an Attack figure as an argument and prints a range when it is given one. **The
interesting decision was not what to show; it was where to put the seam so the better version costs
one argument later instead of a rewrite.**

**And a third, on a fault the batch was not looking for.** Five suites each asserted a hardcoded
master.html batch stamp, so each needed hand-bumping every batch to keep passing — and CJ's
re-stamp turned all five red at once, where they sat unnoticed. CD established that a check which
can only pass has stopped asking its question. **This is the mirror: a check that can only pass for
one batch, which fails so routinely that its failure stops carrying information.** Both ends of
that spectrum are the same fault, which is that the check's truth is maintained by hand rather than
derived. Neither is visible from the pass/fail line; both are visible the moment you ask what would
have to change for this check to be wrong.

## The card and the document were never the same sentence (Batch CJ) — 2026-08-17

The text standard exists because of one measurement, and it was not the one the batch set out
to take. **Of the 120 draft ability rows in master.html, zero carry the string the code hands
the player.** Not "most have drifted" — none were ever the same. Two people-shaped efforts wrote
two descriptions of every ability, and the reason nobody noticed is that **they agree on all the
numbers**. The drift is entirely in the prose, which is the kind that no consistency check
catches and no bug report describes.

That matters more than it first looks, because **the brief for this batch quoted the document as
if it were the card.** The calibration example for "here is the fluff problem" was Blood
Offering's master.html row — three sentences, the third explaining why the number was chosen.
The card the player actually reads is two sentences and does not lecture. Had the rewrite passes
been calibrated against the document, they would have been aimed at prose no player has seen,
and they would have over-corrected text already most of the way to the target.

**The general lesson is about which copy a standard is allowed to be calibrated from.** A design
document that paraphrases rather than quotes is not a second copy of the text — it is a
*description* of the text, and it drifts in the one direction documents always drift: longer, and
toward explaining the decision. The standing rule that the code's field is authoritative already
said which copy wins a disagreement. What it did not say, and now does, is that **the document
cannot be used to judge how the game reads**, because it is not written in the game's voice and
never was.

The second thing worth recording is **why the "no literal `\n`" rule shipped with an exception
instead of whole.** Written as briefed, it would have been correct about `passive_desc` and
destructive everywhere else: nothing in the project overrides `make_custom_tooltip`, so Godot's
default tooltip does not autowrap, and the hand-wrapping that looks like sloppy authoring is the
only thing keeping a 322-character description from rendering as one line two thousand pixels
wide. The measurement changed the rule rather than the rule surviving the measurement — and the
44-character ceiling it produced turned out to be **exactly the discipline the ability corpus was
already keeping, 936 lines out of 936**. A standard that had been guessed instead of measured
would have picked a rounder number and quietly invalidated every card in the game.

## Two answers to one cruelty, and the discipline of not merging them (Batch CI) — 2026-08-16

The Warrior nine close the draft, and the pair worth recording is **Anvil and Recompense** —
two Warden cards written to fight each other on purpose.

Heavy Plating climbs +8% Block per unblocked hit and a *successful block throws the whole climb
away*. That sawtooth is the passive's central cruelty: the ramp exists as bad-luck protection,
and the passive taxes him for the one outcome the ramp is meant to buy. Anvil refuses the reset.
Recompense is *paid by* it. Held together, the second gets nothing while the first is up.

The tempting move is to smooth that over — let Recompense pay a little anyway, or have Anvil
leave one reset through. **Both would be worse, and the reason generalises past these two cards.**
A player holding both is not being punished by a bug; they are holding two answers to a question
that only has one answer at a time, which is a legitimate thing for a card pool to contain and a
genuinely interesting thing to discover. What makes it safe is that it is *legible*: both card
descriptions say it outright rather than leaving it to be found. **A hidden anti-synergy is a
trap; a stated one is a build decision.** Batch BW made the same call with Reckless Abandon
against Bloodwake and it has read well since.

There is an implementation lesson underneath it that is worth more than the pair. The
non-interaction is not coded anywhere — there is no clause saying "if Anvil, skip Recompense".
Anvil suppresses the reset, and Recompense hangs off the reset, so *with no reset there is
nothing to pay for*. The rule falls out of where the two things sit relative to each other. Every
time this project has instead written the interaction down as its own condition, that condition
has eventually gone stale; the ordering cannot, because it is the same line of code doing both
jobs.

**And the batch's own driver proved the point by catching the one place the ordering broke.** The
Anvil guard was spliced in *above* the original unconditional reset rather than replacing it, so
the climb reset anyway while the log announced that it had held — a card doing nothing and saying
it worked. Every live smoke passed it, because a smoke reads the log. Only a check that asserted
the *state afterwards* could see it.

## A payout that costs nothing is not a trade (Batch CG) — 2026-08-16

Two of this batch's seven changes are the same correction made twice, and the shape is worth
keeping separately from either card.

**Jubilee spent all of the Devout's Faith and left his high-water mark standing.** That reads
generous and was, on inspection, hollow: since Batch BI the peak is the thing his stacks are
actually paying him for, so a spend that emptied the count and kept the peak cost him *nothing he
was using*. The card was a free heal with a three-stack entry fee. Making the peak fall with the
count is what turns it into a decision — burst sustain bought with permanent mitigation — and it
is the second card in a row whose repair was to give it a price rather than to change its
numbers.

**Elevation was the same fault from the other side.** It wrote the peak and never the count, so
the party was paid all fight for Faith it never carried, nobody was ever walked toward a release,
and the card could not interact with the release engine it sat next to. Handing over real stacks
costs it the "free" property and buys it every consequence of a Faith gain for nothing — the
release, the heal, Binding Oath, Communion — because it now goes through the one door instead of
around it.

**The general rule: an ability that writes a DERIVED quantity instead of the real one is usually
avoiding a cost, and the cost is usually what would have made it interesting.** BI built
`faith_peak` precisely so that held value and spend frequency could stop fighting, and the first
two cards to touch it both reached for the derived half because it had no downside attached. That
is not an argument against derived quantities; it is an argument for asking, of any card that
names one, what the card would look like if it had to use the meter itself.

**One deliberate exception is recorded with it, so it does not read as a reversal.** BI's rule is
that a RELEASE must not silently cost held value — that the meter emptying must not delete the
mitigation. Blessing of the Faithful lowers the peak anyway, and that is legitimate because the
surrender is *named on the card* and paid once by a deliberate cast, not levied on every release
in the fight. The distinction that matters is not whether a peak can fall; it is whether the
player chose it.

**And a smaller one, about deleting a card rather than retiring it.** Observance is gone entirely
— function, status, constant — rather than left dormant behind a flag. The reason is the one this
file keeps recording under other names: a half-removed rule is an invitation, and the next author
to find `_observance_pay` returning false would reasonably conclude it was waiting for something.

## An `elif` is a rule until something makes the pair reachable (Batch CE) — 2026-08-16

Observance is a card that lets an Empowered cast keep its perfect bonus for a second Mercy. The
brief called the forfeit "a permanent standing tax", which is true of the rule and turned out to
be much smaller than it reads. Three of Holy's five Empowerable casts had written their two
outcomes as `if empowered ... elif is_perfect` — and that `elif` was never a decision. It was an
accident of the fact that `_resolve_special` zeroes `is_perfect` the moment a cast is Empowered,
so the two could not both be true and nobody had to choose. Splitting them is a behavioural no-op
against every board state that exists today, and it is the only reason the new card fires at all.

**The transferable half is that unreachable code shapes itself around what is currently
impossible, and a new card is exactly the thing that makes it possible.** Nothing was broken. No
test could have caught it, because there was no wrong behaviour to catch — right up until the
moment the card shipped, when the same three `elif`s would have made it silently inert. The
failure mode is a card that does nothing and reads fine on its tooltip, which is the fault this
project keeps meeting under different names.

**The Hymn is why the order matters and not just the split.** Its Empowered share is 35% and its
perfect 25%, so two independent `if`s written the wrong way round would have handed the
*smaller* number to the cast that had just paid a second Mercy for the privilege. The card would
have been a downgrade you paid for. That is pinned in the suite rather than trusted, because the
correct order is invisible from either line on its own.

**And the honest accounting was worth more than the card.** Writing down what Observance is
actually worth — three of five casts, and nothing on the two whose Empowered branch already
supersedes their perfect — is a smaller claim than the brief's and a more useful one. A tax you
can name the size of is a tax somebody can decide about.

## A count is the instrument; a clean line is not evidence (Batch CD) — 2026-08-16

Batch CA found the run harness printing `GATE 2 PASS` on zero assertions and wrote the rule: a
gate reports its check count, not a verdict. It applied that rule to the harness and stopped
there. The suites were left alone, and five of them were doing the same thing — aborting a
function partway on a dead call and printing a clean count on the way out. Closing them put 2,711
assertions back into the battery.

**Why it survived twelve batches is the part worth keeping.** Every one of these was *recorded*.
CLAUDE.md named `ah` and `an` from Batch BO onward, `bb` from BZ, `bj` from BX, `runes` from BK.
Each was correctly diagnosed, correctly attributed, and correctly declared not that batch's
thread — and each of those judgements was locally right. What none of them did was put a number on
it. "Silently under-testing" is a sentence you can read past for a year; "2,644 checks are not
running" is not. **The report that names a fault without sizing it is the one that gets deferred
forever.**

**The second lesson is about who owns hygiene.** The reason every batch deferred these is that
each throw belonged to some *other* batch's subject — BM's talent economy, AN's opening rune, BZ's
archive split. That reasoning is sound for a content batch and fatal in aggregate: a fault that is
nobody's subject is nobody's job. The answer is not to make content batches fix things outside
their scope. It is that hygiene needs its own batch occasionally, which is what this was.

**And a note on tombstones.** Two of this batch's own source-level sweeps failed against correct
code, because every repair here deliberately *names* the thing it deleted — in a comment saying
why it went, and in an assertion pinning it absent. A naive grep flags exactly the files that are
right, and the obvious way to make it pass is to delete the line that tells the next author not to
bring the call back. Batch BS learned this once; this batch learned it twice in one sitting, from
the code side and the documentation side. **A project that writes tombstones needs sweeps that can
tell a tombstone from a body.**

## Splitting beats moving when something else reads the file (Batch BZ) — 2026-08-15

BY measured the sync and named the changelog as the archive candidate, which was
right, and recommended moving the whole file out, which was not quite. The file
has a reader: `build_docs.py` finds it by relative path. Move it and the script
breaks until someone updates the path — and the fix is worse than it sounds,
because it points a repo script at a folder outside the repo.

The split costs almost nothing and avoids all of that. The live file stays
exactly where it is, so nothing that reads it notices; only the old entries
leave. It gives up about 60 KB of the 780 KB saving and keeps ten batches of
recent context in the sync, which is the half anyone actually reads.

**The general shape: when a file is too big and something reads it, ask whether
the reader needs all of it. Usually it needs the recent end, and then the answer
is a cut rather than a move.** The same cut will be owed again in ten batches or
so, and it is cheap to repeat.

The thing that needed care was not the cut, it was proving it. Two files that
sum to the right number of bytes are consistent with one entry duplicated and
another dropped. So the check is on the entries themselves — every heading
extracted from all three files, the two halves proved disjoint and their union
proved equal to the original, and the bodies re-concatenated compared byte for
byte. **A split that loses one entry of 118 looks exactly like a split that
didn't.**

The uncomfortable half is §1's risk and it is worth stating in the notes as
well as the guide: the saving comes from putting text somewhere GitHub is not.
That is fine for frozen history *provided the machine is backed up*, and this
machine currently is not. The history archived today survives in the repo's
pushed git history regardless, so nothing is at risk yet — but the folder needs
a backup before it holds anything that isn't already in a commit.

## A card type that says NO is a different design from one that says INSTEAD (Batch BW) — 2026-08-14

Batch BP gave the Swordmaster two stance cards and a rule for them: each branch
buys what the guard he is *arriving* in wants, so a switch is never a tax. That
rule is about generosity — whichever guard you are in, the card has something
for you, and it hands you the thing you will want next.

BW's two gated cards are the opposite gesture and they are better for it. Sever
does not do something smaller in the Defensive guard; it is simply not there.
The button is dark. And that turns out to matter more than any number on the
card, because **a stance you can be locked out of is a stance you have to
think about**, where a stance that merely changes what you get is one you can
drift through. For most of this project the Swordmaster's toggle has been a
pair of passive modifiers with a free button to flip them, and a player could
play him competently without ever forming an opinion about which guard they
wanted to be in.

The interesting consequence is that the gate created a problem worth solving,
and Feigned Guard is the solution rather than a third card. Once two of his
abilities can refuse him, "I am in the wrong guard" becomes a real and
frequent complaint — and the answer is not to soften the gates, it is to sell
him a way to lie about which guard he is in. That is a much better card than
anything that could have existed before the gates did. It is only worth a slot
because being locked out is worth avoiding.

**This is why the gate-satisfying clause had to live at the door and not at
resolution.** The two implementations look identical in a tooltip and one of
them is a minor damage modifier while the other is the whole card. If Feigned
Guard only changed which *branch* an ability took, it would do nothing for
Sever and Battle Poise — the cards a build actually wants it for — and it
would have shipped feeling weak for a reason nobody could see from the text.

The Warden's three came out of a plainer observation: he had two defensive
cards and no offense at all, so the question was not "what else can he protect"
but "what can he do with what he has already stacked". His maximum health is
the biggest number in the party and nothing read it. Block is his signature
stat and it paid him alone. Both of those are stats a player has been growing
all run and being handed nothing for — and turning an accumulated stat into a
new verb is a much cheaper way to make a spec feel deeper than adding a
mechanic to it.

The Berserker's is the oldest complaint in the file. His passive rewards being
nearly dead and his kit gave him no way to survive there, so the whole spec
read as a dare rather than a plan. Blood Debt does not heal him; it makes his
*own engine* pay him, which is the difference between a sustain card and a
sustain build. And Berserk is the same idea pointed the other way: its
drawback drives him into the band his passive pays for, so the card that looks
like a risk is actually the most direct way to switch him on.

## A punishing passive grows its own lane of antidotes (Batch BS) — 2026-08-14

The Pyromancer's INFERNO lane had eight nodes and one subject. Fire Walker
reduced Overburn's Mana drain, Invigorating Ashes offset it, Immolate doubled
it, Kiln-Forged floored it, Ash Lung paid him for outrunning it, Cauterise
billed it to health, Forge Body threw the paid bill at an enemy. Seven of
eight. The eighth, Heat Shimmer, raised the cap on the bonus the drain was the
price of — so it was not an exception, it was the same term seen from the
other side.

Batch BH found this shape in the Devout's Faith lane, where every node
multiplied one number. **This is its mirror: every node divided one.** And the
mirror is the worse of the two, because the term here was a *punishment*. A
lane of multipliers is at least a lane about your power. A lane of antidotes
is a payment plan, and the reason it never reads as one is that it looks
extraordinarily full. Eight distinct effects. Eight distinct-sounding
tooltips. Eight rows of real decisions, every one of them answering the same
question: *how are you paying the bill?*

**The test is not whether a lane's nodes differ in EFFECT but whether they
differ in SUBJECT.** That distinction is the whole finding, and it is cheap to
apply — you can run it on a tree before anybody plays it, without a sim, by
listing what each node reads. Eight nodes that reduce, offset, floor, double
and redirect one number are eight verbs and one noun. The verbs are what make
it look like a lane; the noun is what makes it one node with eight prices.

There is a second-order trap in it worth naming, because it is what kept this
lane alive for so long. A punishing passive doesn't just *attract* mitigation
nodes — it **justifies** them. Every one of those eight was defensible on its
own terms, and each one made the spec more playable than it was without it. The
lane was doing real work. That is exactly why nobody looked at the column and
asked what it was made of: it passed the only test anyone thought to run, which
is "does this node help?"

The repair was not to re-price anything. It was to delete the term, and then
ask what the column should have been about all along.

## The comment was right. Nobody had read it next to the constraint (Batch BN) — 2026-08-13

The Cryomancer's release has carried this comment since Batch AS:

> Honed Shards LAST, because it can re-freeze the enemy it just thawed.

That sentence is accurate. It was written by someone who had understood the
behaviour completely, and it describes the near half of a crash that then sat
in the game for six batches. The stacks a release leaves are one, Honed Shards
adds three, and four is the number that flash-freezes — so every release
re-freezes its own target, and the comment says so.

What nobody traced is the sentence one function away. A Thaw-lane Cryomancer
holds **one** enemy, and freezing a second evicts the first — which is a
release. Put the two together and a self-re-trigger becomes a two-body cycle:
freeze B, evict A, A's release re-freezes A, which evicts B, whose release
re-freezes B, until the engine's stack limit. Neither site is wrong. Neither
site can be *read* wrong. The bug lives in the sentence nobody wrote, which is
the one that names them both.

**A known local behaviour plus a known local constraint can be a bug that
neither of them is.** That is the transferable part, and it is uncomfortable
because the usual defences do not apply. This was not undocumented — the
comment is *the* documentation. It was not unreviewed. It was not a magnitude
anybody had to guess at. Every one of this project's habits for catching
mistakes — read the site, state the rule beside the code, name the field once —
operates *within* a site, and this fault had no site.

What found it was a sweep: four hundred battles at a budget high enough to put
two enemies in a prison at once, run for a different reason entirely (Batch BF
was measuring difficulty). It cost twenty-three stack overflows and a megabyte
of backtrace to notice. That is the second half of the lesson, and it is the
cheerful half — **instruments find the faults that reading cannot**, because an
instrument does not have to know which two sites to hold in mind at once. The
project already believed this about balance. It is just as true about control
flow, and the same argument says the fix should be a re-entrancy guard rather
than a smaller number: the cycle is a control-flow fault, and cutting Honed
Shards to three-minus-one to dodge a threshold would have nerfed a node to
work around a `while` loop.

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

## Batch BO — the ability draft, and tranche 1

**The cap exists to make the draft a decision rather than an accumulation.** Without it, an
elite that always offers an ability is just a slow drip of strictly-more, and by zone 3 every
hero is holding everything their spec can hold. Seven slots turns each offer into a question:
is this better than the worst thing I already have? The number is deliberately just above what
a run can currently fill, so the cap only starts biting on a route that hunted elites — which
is the same axis the map's risk already runs on.

**The protected core is the half of the cap that keeps it honest.** A cap with nothing
protected would eventually let a player trade away the ability their passive is built on, and
that failure would be silent: nothing crashes, the spec just quietly stops working and reads as
badly balanced. The reason the minimum is decided per spec rather than by a rule is that the
passives genuinely differ in what they read — Overburn needs a Burn applier *and* a spender,
Blood Frenzy reads nothing but a health bar — and a rule general enough to cover both would
either over-protect the Berserker or under-protect the Pyromancer.

**Declining had to be free, and that is a statement about how a build should end.** The
alternative — take one or lose the offer — makes a finished kit worse the longer a run goes on,
because eventually every card on offer is worse than everything you hold and the game is asking
you to make yourself weaker. A settled build is a legitimate end state, and the no-return rule
is what stops "no thank you" from being asked again three fights later.

**Class-wide abilities are weaker on purpose, and it is the interesting half of the design.**
An ability that feeds no passive is unconditional, and unconditional is worth more than it
looks in the fights where your engine is not running — the first two turns, the fight after
your beast died, the boss that resists your status. If they were priced at spec strength they
would be the safe default in every draft and the spec pools would stop mattering. Slightly
weaker but always-on gives them a role instead of a rank.

**On authoring machinery before content.** The order was not a preference. The schema decides
what an ability has to carry, and eighteen abilities authored before the pools, the cap and the
protected cores existed would have been authored twice — once against a guess and once against
the real shape. The same argument applies to the ninety-six: the tranches exist so the shape can
be wrong early and cheaply.

**On shipping two cards whose stated reason turned out to be false.** Call the Wilds was
specified around a Loyalty loss that does not exist, and Called Volley around a Focus clear that
area attacks have never caused. Both still ship, because both name a real axis and the axis
survives the correction — rotation *is* taxed, just by a cooldown rather than by the meter, and
Focus surviving a volley *is* worth a card even when it is a guarantee rather than a
distinction. What changes is that the reason in the file is now the true one. A design note
built on a premise nobody re-read is how a system acquires numbers nobody can defend.

---

## Batch BP — the Warrior draft pools

**On paying a named debt rather than a discovered one.** BO shipped eighteen abilities and wrote
three empty arrays into the pool table with a comment saying why. That is a small thing that did
a lot of work: the gap was visible in the data, not just in a changelog, so it could not quietly
become permanent. A batch that had padded the Warrior pools with hurried content to avoid an
awkward empty array would have spent the good version of these six.

**The arriving-stance principle is the only genuinely new idea in the batch, and it came out of
a mechanical problem.** An ability that switches your stance is, on its face, a tax: you cast it,
you get a thing, and then you are somewhere you did not ask to be. The fix is not to make the
switch optional — that deletes the interesting part — it is to make the switch *the point*, by
having each branch pay out in the currency of the stance it leaves you in. The Aggressive branch
buying defence reads backwards for about two seconds and then reads obviously right. Which is
exactly why it is written down as a rule: the intuitive authoring produces the inverted card, and
the inverted card still looks fine on the tooltip.

**On bypassing armor instead of penetrating it.** Armor penetration in this game is a fraction
*of* the target's armor, so a clause promising "+50% armor penetration" does nothing at all
against an unarmoured enemy — and most enemies are lightly armoured. The upgrade pool already had
a rule against exactly this shape (an upgrade must be able to change the ability it is paired
with), and the same reasoning applies to a card's own text. A bypass is a smaller-sounding
promise that is always true, which is worth more than a bigger-sounding one that is sometimes a
no-op.

**Covering Guard is the batch's best card because it takes a stat somewhere it has never been.**
The Warden's Block is the only effect in the game that stops a blow *entirely* — no reduction,
no redirect, nothing on the other side of it — and until now it only ever protected the body it
belonged to. Lending the roll rather than the body keeps that property intact: nothing moves to
him, so it is not Interpose with extra steps and it is not a taunt. Reading it live rather than
snapshotting it is what makes it a build rather than a button: a Shieldwall raised after the ward
deepens the ward.

**Eye of the Storm ships flagged, and the flag is the honest part.** Two turns in which the party
takes nothing is a large effect and nobody should pretend otherwise. What makes it worth shipping
untuned is that its own scaling is the tension: it is best exactly when the situation is worst,
and worst against the small heavy-hitting fields where a Warden is already comfortable. That
shape is more likely to be right than any number we could pick for it in advance, so the number
waits for play.

**A negative control found a fault in this batch's own code, which is the entire reason to run
them.** Eye of the Storm's mitigation was written three times in six lines — the apply, the chip
text and the chip's power — and the last write silently won. A wrong figure in the first two
would have been unobservable. The repair is a local, and the general rule is the one this project
keeps re-learning in new places: a number written twice is a number that will eventually
disagree with itself, and the test that catches it is the one that deliberately breaks the first
copy.

## Batch BQ — the Mage and Cleric class pools

**The seam was the thing worth fixing, not the pools.** BO built a draft that draws roughly one
card in four from a class-wide pool, and then shipped with every class-wide pool empty. That is
not a missing feature, it is a quarter of every offer being dead — a hero was shown three cards
and only ever really offered two-and-a-bit. Filling half the seam is worth more than it sounds
because the half that was empty was *structurally* empty rather than thin: no amount of good luck
would have found a class card.

**The rule that makes class abilities interesting is that they are worse.** It reads backwards
and it is the whole design. A class card feeds no passive: a barrier does nothing for Overburn, a
heal does nothing for Ruin. If it were as strong as a spec card it would be the safe pick in
every build and every Mage would end up holding the same six. Slightly weaker but always-on makes
it the card you take when your spec's engine is not online yet — which is a real role and one no
spec card can fill, *because a spine that provided its own answer would stop being a spine*. The
Pyromancer having no defence is not an oversight AR left behind; it is what he is.

**And that rule cuts the other way too, which is what Chastise found.** Checking that a class
card is weaker than the *spec abilities* is not enough — it also has to beat doing nothing, and
"doing nothing" in this game means casting the free core attack. Chastise loses to Smite on
damage, costs Mana and a cooldown Smite does not, and wins only 4 Break. There is no board state
on which pressing it beats simply attacking. It ships as written because the numbers are the
brief's, but the lesson generalises past this card: **the floor for a class ability is the free
basic, not the spec kit.**

**Undying Vigil is the deliberate exception and the pool needs one.** Five of the six Cleric
cards are unconditional floors; one of them gets *better* the more spec-specific the build is —
Holy's big heals fork, the Devout's shield-conversion trickles outward, the Occultist's lifesteal
spreads. A pool where every card is a floor teaches the player that class cards are filler. One
card that rewards a real build is what stops that.

**Mirror Image and Magic Barrier exist to not dominate each other.** Two defensive cards in one
six-card pool is one too many unless each answers something the other cannot, so the images are
spent only by single-target attacks and the barrier eats a share of everything. The AoE clause is
not a balance patch bolted on afterwards; it is the reason there are two cards.

**Dispel's enemy half is nearly decorative and saying so is the deliverable.** Exactly one
beneficial status exists on the enemy side of this game, from two of nineteen kinds. The card
ships whole because the ally half stands on its own and because authoring enemy buffs is a
content decision rather than a repair — but a card whose text promises a symmetry the game does
not have is worth flagging before somebody balances around it.

**The exclusion list turned out to be the hard part of Dispel, and it is the interesting kind of
bug.** "Strip beneficial effects from an enemy" derived as "anything that is not a debuff" is
correct, obvious, and would have stripped the party's own marks — Covenant of Ash, Quarry's Mark,
the snare line, a Feint — because a *mark is deliberately not a debuff*. The rule that reads
cleanly at one site is wrong because of a decision made at a completely different one, and the
only defence is writing the exclusions down with their reasons attached.

## Batch BR — the Hunter and Warrior class pools

**The seam is closed, and the debt that remains is a different debt.** Batch BO opened a
one-in-four class card that rolled into an empty pool for every hero in the game; BQ filled half
of it; this fills the rest. What is left owed is not the seam but the *depth* — spec pools are
still two deep — and that distinction is worth keeping visible, because "the draft is finished"
and "the draft works for everybody" are different sentences and only the second one is now true.

**Iron Will's Break half had three plausible implementations and only one of them is the
ability.** "The meter cannot fill", "Broken is refused" and "the meter caps at 99" all read
identically in a short test: he does not break. They are three different cards. The first throws
the pressure away, so the enemy's work is erased; the second lets the meter sit full, so he breaks
on the very next point and the trance bought a turn rather than a window; only the third leaves
him at 99 — pressure counted, refused, and *deferred onto the turn he stops being immune*. That is
what makes it a delay rather than a negation, and it is the more interesting object: the cost
arrives, it just arrives later, and the player can see it coming.

**A card that reads damage taken is a different card from one that reads missing health, and the
second one is what you write by accident.** Battle Trance needs an accumulator; a share of current
missing health needs nothing at all. The lazy version is a plain low-health heal that pays most to
whoever is already losing; the real one pays most to whoever is being hammered *right now*, which
is a Warrior who committed rather than a Warrior who is dying. The accumulator is the whole design
and it costs one field.

**Hits, not casts, is a rule about what makes a build.** A charge bank that spends one per cast is
a flat bonus. A charge bank that spends one per hit means a multi-hit kit and a charge bank are
worth seeking out *together*, and that is the difference between a card and a combination. It is
also the kind of rule that has to be set once and applied everywhere, because the answer would
otherwise be decided by whichever loop each effect happened to be written inside.

**Two of the twelve collide with talent node names and both ship anyway.** A node's name is not an
ability name and nothing resolves it, so the collision is a label problem rather than a break —
but Iron Will collides with a live status label as well, in the same class, on a spec that can hold
both. The answer was to give the ability its own status id so nothing can overwrite anything, and
then to say so loudly rather than quietly picking a different word. Renaming is one string and it
is the designer's call; discovering the collision a year later is not.

**Warcry is bigger than the spec card it sits beside, and the term that saves it is the one nobody
would think to check.** On its headline number a class card beats a Berserker spec card, which is
exactly what the "weaker than spec" rule exists to prevent. What keeps the ceiling right is Battle
Shout's bleed scaling — a term Warcry has no version of — so in the build the spec card belongs to
it runs well past the class card. The lesson is BQ's own, arriving from the other side: compare
against what the ability actually does in its own build, not against the number on its card.

## Batch BT — tranche 2, the Mage nine

**The question a pool asks changes when it stops being empty.** At two cards a spec, the only
useful question was what *gap* an ability filled — the pool was so thin that anything coherent was
an improvement. At five, that question stops discriminating: five cards that each fill a different
gap are still five cards nobody plans a run around. So the rule from this tranche on is that every
ability names what it *builds with* — a talent node, another card, a capstone — and the line ships
beside the definition and in the table a player reads. It is not documentation of the design; it
is the design's own acceptance test. A card that cannot name what it is played beside has not been
designed yet.

**Slow Burn and Stoke are a deliberate two-card combo, and shipping a known-strong pairing on
purpose is different from shipping one by accident.** The Pyromancer's spine is deferred damage:
he is weak until he cashes in, and every payoff he owns reads a bank that shrinks under him while
he does nothing about it. Stalling the field and then doubling one stack is exactly the play that
spine should be able to reach — and it costs two cards, two casts and two turns, which is a real
price. The reason to say so out loud is that the next reader will find it and assume it was
missed. It was not.

**A card can be strictly worse than a talent node on every number and still be worth shipping, as
long as the reason is the acquisition channel and not an oversight.** Flash Freeze loses to Glacial
Prison on cost, initiative and cooldown. What it has is that a Winter or a Thaw Cryomancer can
actually get it: the node lives in one lane of one tree and has to be bought, and two thirds of his
builds will never see it. That is a real distinction — but it is only real if it is stated, because
the failure mode is a later batch reading the two side by side and "fixing" the card by making it
cheaper, which would make the node pointless instead. The perfect is what keeps the card from being
dominated outright, and it buys the one thing no node can: the boss exception.

**Correcting a brief's premise toward the code is worth more than implementing it as written.** The
brief said the Arcanist has no Resonance consumer at all and that Arcane Bolt would be the sole
exception to "nothing removes Resonance". Stabilize has been that exception since Batch AT, and it
is recorded as one. What was actually true — that his *draft pool* had no spender — is a smaller
claim, and it turned out to be the more useful one, because it forced the question of how the two
spenders differ. Stabilize vents to a floor and is a way out; Arcane Bolt halves and is a change of
slope. Two spenders with the same shape would have been one card with two prices.

**A one-tab indentation error made an effect fire only for players holding an unrelated ability.**
Arcane Echo's per-hit hook landed inside the Arcane Arrows block instead of beside it, so it
worked exactly as designed for anyone carrying five arrow charges and did nothing for everyone
else. Nothing crashed; the log simply never printed. It was caught because the suite drove the echo
directly rather than asserting that the cast returned — which is the whole argument for building a
check that a broken implementation still fails, restated in a new place.

**Watching a smoke run is a different instrument from running a suite, and it found three lies the
suite could not.** A perfect Flash Freeze announced that it had taken an unbroken boss when the
target was a raider; Inner Arcane reported the Resonance it asked for rather than what landed, so a
hero who cannot hold the meter read "+2 (now 0)"; Stoke printed "1 turns". None of the three is a
mechanical fault and no test would have been written for any of them. They are all cases of the
log describing a bigger or different event than the one that happened, which is the class of defect
that teaches a player the wrong rule.

## Batch BU — tranche 2, the Cleric nine

**The first two cards whose value is measured on somebody else's sheet.** Every draft ability
before these paid off on the sheet of the hero who cast it. Recant hands an ally back 30% of their
maximum resource and Anointing makes every ally's attacks apply Ruin — so both are worth a
different amount in every party, and the question they ask a player is about the *party* rather
than about the hero holding the card. That is a genuinely new axis for the draft and it is why
they lead the changelog entry. It also means neither can be balanced by looking at one hero's
numbers, which is worth remembering the first time somebody wants to tune them.

**Three of the brief's premises were stale, and all three were found the same way: by reading the
site before writing against it.** This keeps happening (AR, AX, BD, AY, BS, BT and now BU), and
the pattern is always that a claim was true when someone wrote it down and a later batch moved the
ground under it. Two of the three here were harmless once caught — nothing was the first thing to
restore an ally's resource, and Focus is a second resource rather than a third primary one. The
third was not: Ordination's lowest-Faith targeting was justified by an Apostle release loop that
Batch BG made impossible two batches ago. **The rule was right and the reason was wrong**, which
is the most dangerous shape a stale premise can take — a later batch reading only the reason would
conclude the rule no longer applies and "improve" the targeting into a player-chosen click. The
correction is therefore recorded as *new reasons for the same rule* rather than as a footnote.

**A temporary maximum-health change is the one leak this project has already paid for twice.**
`rot` was authored, implemented and dropped in Batch AQ because a mid-battle `max_hp` change
follows the party out of the fight through the victory sync, and Batch W's ~127,000 max-HP runaway
is the same fault at scale. Fortified Spirit is a third instance, and the interesting thing is that
the *right* fix was the smaller one: because the effect is explicitly temporary, there was nothing
to preserve, so a forced unwind beat adding a fourth sign to arithmetic that already carries three.
The general shape — **when a leak guard is expensive, ask first whether the thing being guarded
needs to survive at all** — is worth having.

**The clamp is the ability.** Fortified Spirit's decay would be invisible without one line that
pulls current health down under the shrinking maximum, and without it the card would be three free
turns of a bigger bar. It is a good example of a mechanic whose *interesting* half is a single
consequence rather than the headline number: an ally kept topped up pays for the loan, an ally
sitting at half does not, and that asymmetry is the whole decision the card asks a healer to make.

**"Landed" is not one thing, and the healing ledger had to pick.** `heal_amount` returns what a
heal was worth after multipliers, which is what this project has called "landed" since Batch BC —
but it includes the part that spilled off a full health bar. Reprisal needed the other reading, or
Sanctum's overheal spill would have been paid for twice: once as the overheal it came from and
again as the heal it becomes. The cost of getting it right was threading the recipient through
thirty-four credit sites, which felt disproportionate for one clause of one card and was not: the
alternative was an accumulator that silently over-counted in exactly the builds the card is
designed for.

## Batch BV — tranche 2, the Hunter nine

**An extra turn is the first mechanic in this game with no precedent to lean on, and the risk it
carries is not a balance risk.** Every other card in the draft can be wrong by a number; Preparation
can be wrong by an infinite loop. That changes what "decided" has to mean — the no-chain refusal is
not a nicety attached after the fact, it is the thing that makes the ability a mechanic at all, and
it belongs in the same breath as the effect rather than in a tuning pass. The other two rules fell
out easily once the first was fixed: the extra turn is a *whole* turn because that is what the
initiative loop already does with a unit it picks, and making it a partial turn would have meant
authoring an exception to a system that has none.

**The delay is what makes it a card rather than a bigger number.** "Take two turns now" is a
damage multiplier wearing a costume. "Take a turn after your next one" asks a question — what do
you spend the turn in between on? — and for a spec whose every status costs a whole cast, that
question is the entire subject of the ability. The counter armed at 2 rather than a bool is the
cheapest possible way to say it exactly, and it is a small reminder that the shape of the state is
usually the shape of the rule.

**A guard with no duration is a different design object from a guard with one, and the difference
is where the waste goes.** Bloodbond has no timer, so it is never spent on a turn where nothing
threatened the companion — which sounds like pure upside until you notice that it also means the
hunter can never be *sure* it is still there to sell. The cost had to go somewhere, and putting it
in the payment (half the blow, and it can kill him) rather than in a clock is what keeps it a
decision. A protective ability that cannot cost anything is a stat, not a choice.

**Reading a number "before" or "after" the blow that changes it is a design decision disguised as
an implementation detail.** Calibrating Shot's promise is "a fresh enemy pays nothing", and measured
after its own shot that sentence is false by a few Focus every cast — small enough that nobody would
ever file it, large enough that the card's stated identity would be a lie. The general point is that
a snapshot is worth taking whenever the ability's own effect moves the quantity it is paid on, and
the tell is a description containing an absolute like "nothing".

**Two readings of one sentence differed by a third of a card.** Ghostpack says "every companion he
has summoned this battle... including ones no longer standing", and the tempting implementation —
only the absent ones, so nothing double-dips with the beast already striking — makes the ability get
*smaller* the moment a beast arrives. A Pack build fielding two would be paid less than one fielding
none, which inverts the card's whole reason to exist. Where two readings are both defensible, the
one to take is the one whose magnitude curve points the same way as the build it is for.

**The most useful thing this batch produced is not a card.** It is the rule that an *ordered* action
goes to one companion while the passive strike-alongside goes to all of them. The Pack capstone had
been silently doubling anything that named the beast, and the reason nobody had noticed is that
until now only one ability named it. Writing two more forced the question, and the answer is worth
more than either card: it means the next Beastmaster ability has a rule to be authored against
instead of a precedent to be inherited from whichever line of code it happens to resemble.

## Batch BX — every hero drafts after an elite

**Reach and pacing are separate problems, and BO solved the wrong one.** BO's own objection to
offering a draft to all four heroes was that it would hand out ~26 picks a run — but that objection
is really about *the number of screens*, not the number of cards. Four sequential offers after every
elite would be tedious; four columns on one screen is a single decision that happens to have four
parts. The fix for "too slow" was a layout, and shrinking the reach to one hero at random was paying
for it with the feature.

**A screen that resolves as one action is a different screen, not the same screen with a button on
the end.** Once the promise is "reconsider the Devout before the Warden locks", every choice has to
be *staged* rather than committed, which means the screen holds state the run does not yet know
about. That is the whole implementation cost, and it is worth it for one reason: a player comparing
four columns is doing something a player answering four questions in a row cannot do.

**The rules had to stay in `run_state.gd` for the screen to be cheap.** The cap, the drop, the
no-return ledger and the fill-short rule were already there and already tested, so the second layout
cost a layout and nothing else. The tell that this went right is the drop step: the party screen and
the boss pick share one function and differ by a single Callable — one stages, one commits.

**A conditional instruction whose condition is false is not an instruction.** The brief said to add
a 1 HP post-battle revive *if none existed*. One existed, at 20% of maximum. Following the letter
would have cut a shipped number by 95% as a side effect of a rename-scale batch, and nobody would
have asked why. The cheap habit that catches this is reading the site before writing against it.

**Renaming prose is not a find-and-replace, and the failure is silent.** `\n` inside a GDScript
string is two characters, so the `n` makes "this\nbeast's gift" have no word boundary before the
word — a word-boundary regex skips exactly the hand-wrapped tooltips that matter most, and reports
nothing. A rename script that quietly does 90% of the job is indistinguishable from one that worked;
the only thing that found it was re-running the survey afterwards and expecting zero.

**A word that appears in both the code and the fiction should be renamed in one of them at a time.**
Doing prose and identifiers together would have produced a diff nobody could review, and the two
have completely different failure modes: a missed prose rename reads as a typo, a missed code rename
is a bug. Splitting them means the second half can be declined forever without leaving anything
half-done.

**Two copies of a rule disagree eventually, and "eventually" was two batches.** BV wrote the
ordered-action rule and applied it to the card it was authoring; the older card kept reading list
order, and BW saw it and correctly left it alone. Neither batch was wrong. What was wrong was that
the rule lived in a loop rather than in a function — so applying it to a second card meant copying
it, and copying it is what let the first card keep the old answer.


**A test that reports a verdict is only auditable by reading it; a test that reports a quantity is
auditable at a glance.** The two earlier hollow-verification cases were caught because a *figure*
looked wrong — a count that did not move, a rate that read zero. Nothing looks wrong about the word
`PASS`. That is the whole reason GATE 2 survived twelve batches of being quoted as evidence while
running no assertions at all: it printed a word, and a word has no shape to be wrong. So the repair
worth keeping is not the re-point, it is that gates now count. `GATE 2 PASS (165 checks)` carries
its own audit; a gate that runs nothing prints `(0 checks)` and is visibly broken to anyone
glancing at the line, which is the only kind of checking that actually happens every time.

**The corollary is that "zero" has to be loud rather than quiet.** An empty gate reporting zero is
only useful if somebody reads it, and the honest way to make sure somebody does is to fail. This is
the one place where silence is the failure mode — a gate with nothing in it is not neutral, it is a
gate that has stopped asking its question, and it should be as loud as a gate whose question got
the wrong answer.

**Making a failure legible and making it impossible are different jobs, and it is easy to stop
after the first.** Printing the check count fixes the audit — a reader who glances at
`GATE 3 PASS (2 checks)` and knows it should say 8 will catch it. But that reader has to exist, and
has to know the number, and has to be looking; the whole reason the original defect lasted twelve
batches is that nobody was doing any of those things. The count is worth having anyway, because it
is what makes the failure *explicable* once found. What actually closes the hole is the gate
asserting that it reached its own last line, because that needs no reader at all.

**A rule that only covers the case you happened to hit is a rule with a soft edge.** The reported
bug was a dead call at the top of a function, so the obvious rules — count the checks, fail on zero
— both key on the count being zero. Move the same dead call ten lines down and every one of them
passes again. The question worth asking of any structural fix is not "does this catch the bug I
found" but "what is the smallest change to the bug that gets past it", and here the answer was
moving one line.

## Batch CB — a conservative transfer hides its own bug

**The thing worth keeping from this batch is not a card, it is a shape: an ability that MOVES a
quantity from A to B cannot be tested by looking at the total.** Firedraw draws Burn off every
enemy except its target and deposits it on that target. The rule that matters is that it never
draws from the target itself — and every obvious assertion about that rule passes whether the code
follows it or not, because the transfer is conservative. Take four turns off the target and give
them straight back and the target is exactly where it started. The bug and the fix are
indistinguishable by arithmetic.

What made it testable was an unrelated card. Emberkeep doubles Burn at application, so under its
window the deposit is worth twice what was drawn — and suddenly drawing four extra turns from the
target is worth eight, and the two readings differ by four. **The general lesson is that a
conservation law is the enemy of a test, and the way past it is to find the thing in the system
that breaks the conservation and measure there.** It is the same move as measuring a mitigation
term at an amplified magnitude (Batch BS) — not because the shipped number is wrong, but because
the shipped number sits where the signal and the noise overlap.

**A second one, smaller and more embarrassing: the card whose text was false by one line looked
like it worked.** Frostbind promises that a bound pair reaching the freeze threshold freezes
together. It did not — the second freeze pushed the hold count past its limit and evicted the
first, so the pair took turns being held. Nothing crashed, nothing logged, and a smoke test showed
a frozen enemy and a bound pair, which is what the card promises if you are not counting. The
check that caught it asserts BOTH partners are frozen at once, and it only exists because the
brief happened to spell out the consequence ("which is how a one-hold Cryomancer comes to hold
two") rather than only the mechanic. **A design note that states the OUTCOME as well as the rule
is worth more than one that states the rule twice**, because the outcome is what a test can be
written against.

**And a note on stale premises, which this project keeps meeting.** Four things were named for
verification and two of them did not hold — including a name the brief believed had been freed two
batches earlier and which was, in fact, still attached to a live talent-granted ability. The
instruction to verify rather than assume paid for itself twice in one batch. What is worth
recording is that the failed premise was not careless: it was a reasonable inference from a real
change (BS did rename a node to dodge that exact collision — just a different node). **The most
dangerous premise is the one that is nearly true.**


## Batch CH — why three of the nine names moved, and what a name sweep is actually for

The brief for the Hunter nine predicted a crowded vocabulary and asked for the standing name sweep
to be run "anyway", with the instruction to treat a near-miss as a hit. That framing turned out to
be too generous to itself: the sweep did not return near-misses, it returned a live ability.

**HARVEST was already in the Survivalist's boss pool, and had been since Batch 33** — not a similar
name, the same name, on the same spec, resolving through the same keyed resolver. And the mechanic
matched too. The interesting question is why a brief written with real care could specify a card
that already existed. The answer is that the brief was reasoning from the SHAPE OF THE POOL rather
than from the pool: the Survivalist's draft pool has no spender, and "he needs a spender" is a true
observation about the DRAFT pool that is false about the spec, because his spender lives in the
boss pool instead. **A gap in one acquisition channel reads exactly like a gap in the design.**

That generalises past this batch. The project now has two ability pools per spec with different
acquisition channels, and the temptation each tranche is to audit the one being filled. The check
that would have caught this is cheap and is not the name sweep: *before authoring, list what the
spec can already have from every channel, not just the one you are adding to.*

**KINDRED and TRIPLE TAP are the ordinary case and are worth recording only for the rule they
confirm.** Both were flagged by the sweep working exactly as designed, and both moved rather than
shipping-and-being-flagged, on Batch BW's Vendetta precedent: when a name collides with something
whose id is save-bearing, the unshipped side is the side that moves. That rule is cheap to follow
and it keeps being right.

**The half of this worth carrying is about what a rename does NOT fix.** Renaming Harvest to Cull
would have satisfied the resolver and left two abilities doing the same thing in the same spec —
the Deadfall/Snare Trap failure, which took fourteen batches to notice and which this batch's own
brief cited as the thing to avoid. **A name collision is usually a symptom; the duplicate mechanic
underneath it is the fault.** Unleash is the same story without the name: it collided with nothing
and duplicated Primal Surge outright. So the sweep that matters is not the one over names, it is
the one over what the spec can already do — and the name sweep is valuable mostly because it is the
thing that makes you look.

**A smaller note, on tests finding this batch's own faults.** Re-running the older suites was not a
formality: `test_batch_bo` walks every draft entry and asserts each carries a perfect, which caught
Reacquire shipping with an empty one, and fixing that surfaced Drumfire promising a fourth arrow
while carrying the flag that suppresses it. Neither would have failed a parse, a smoke or a live
battle. **The suites that pay for themselves are the ones that assert a PROPERTY of every entry
rather than facts about particular entries** — a per-entry loop written three tranches ago is what
caught a card authored today.

## Batch CP — the clamp, and why the verification was the larger half

§0 is three lines in three places, and it is the smallest part of the batch. The reason it needed
doing is that CO's refusal was scoped correctly and therefore could not reach these three: an
ability that also converts a resource must still cast when its buff would not improve, so the
refusal stops at the door and the downgrade happens inside. Separating "this cast is pointless"
from "this cast is harmful" is what let both rules be right — CO refuses the first, CP clamps the
second, and neither had to widen into the other.

The census matters more than the clamp. The obvious tidy-up here is to clamp `update_status`
itself, once, and be done; the census exists to say why that would be a bug rather than a
simplification. Two sites read the standing power, subtract one, and write it back — they are
countdowns wearing the same function — and a global max would make Held Breath and Hunter's
Instinct unspendable forever, silently. That is the shape of nearly every fault this project keeps
finding: not a wrong number, but a right number read by something that wanted a different question
answered.

The rest of the batch is about instruments, and the finding is uncomfortable in a useful way. The
battery had not been run since CE. In that gap CN folded 105 orphaned Perfect bonuses into base
effects — a good change, deliberately made, well documented — and roughly seventy assertions across
seventeen suites have been asserting the pre-fold numbers ever since. Nothing failed loudly,
because nothing ran. CD had already built the one instrument that can see another suite failing,
and it did see it; what was missing was anybody running the battery CD lives in. The lesson is not
"write better tests", it is that a test suite is a claim about the present tense, and a batch that
ships without running them is a batch that has stopped making that claim.

Two of the four instrument faults were the harness rather than the code, and both were mine to
create. A hung suite takes the whole battery with it, so the counts after it go missing rather than
wrong — and a count-diffing rule cannot see a count that was never printed. Worse, killing the hung
suite's Godot does not kill the battery that spawned it, so a second invocation ran alongside the
first into one log directory and every number became whichever process finished last. Nothing
errored. That is the same failure as a check that can only pass, arriving through the reporting
layer instead of the assertion layer, and it is why the watchdog and the lock are in the script
rather than in a note.

The hint deadlock is recorded as a near miss worth keeping. Both orientation cards await a signal
only a real player emits, behind a guard that every hand-driven suite satisfies; CM answered that
trap by setting two Profile flags inside the one file it had just written, which fixed CM's own gate
and left four older suites to hang. A flag somebody has to remember to set is not a guard. The fix
was written and then reverted, because it did not unhang the four suites it was aimed at, and
shipping a product change that does not fix what it aimed at — in a batch whose §0 is the only
sanctioned code change — is the scope creep that makes a later failure impossible to attribute.
Reverting it cost nothing and keeps the batch readable.

Finally, two of the brief's own numbers were wrong and both corrections came from measuring rather
than arguing. The literal-digit rule is at 89 sites, not two hundred, and most of them are prose
that was never a resolved value — so CL's decision to report rather than assert was right, and the
honest form is a baseline that catches the next one instead of a gate that fails against correct
text today. And the Perfect biconditional is not a biconditional: the half that is project law
holds at zero violations, and the converse has been false since long before the batch that
supposedly caused it. Naming the five exceptions is worth more than enforcing a rule the corpus
never followed.

## Batch CS — a sequence that grows without getting harder

The Sharpshooter's basic attack is the action he presses more than any other, and it is now the
only ability in the game that runs more than one timing window. Everything difficult about this
batch follows from that one sentence: a mechanic that scales with a meter, attached to the button
a player hits most, is exactly where a scaling difficulty curve does the most damage.

The cap at four presses is the whole design, not a rounding. Focus has no ceiling by deliberate
choice — the spec's identity is that patience keeps paying — so "one press per 50 Focus" with no
cap makes 400 Focus a nine-press sequence with a tightening window. That is not a hard ability;
it is an ability a player without the reflexes cannot use at all, on the attack they press most,
and losing access to your basic attack because you played your class well is the failure that
sank timed hits in Legend of Dragoon and Mother 3. The cap is recorded in three places with its
reason attached, because a later batch reading "four" without the reason will read it as
arbitrary and raise it.

The harder half was §4: each press must be narrower than the one before, and the whole sequence
must be about as hard to land at four presses as at one. Those pull in opposite directions, and
the resolution is that the OPENING window widens as the count rises. What made that a real
decision rather than a slider is that **nothing in the project can measure it.** The bot never
runs the bar — it rolls a grade off fixed probabilities — so no sim, no battery run and no
telemetry can tell whether a four-press sequence is actually as achievable as a one-press cast.
The number had to come from a model, so the model is written down: difficulty is time inside the
window, which is the standing rule the profiles were already authored to; a player's timing error
is roughly Gaussian; a press's risk is that Gaussian's tail outside the window and a sequence's
risk is the sum of its presses'. Under it, holding the total risk flat costs a 1.86x opening
window at four presses rather than the 4x a naive reading suggests, because the tail is steep.
The gate re-derives the table from the constants rather than trusting it, so a hand-edited row
cannot pass silently — but the assumption underneath is a guess about human reflexes, and it is
flagged as one.

The Perfect window deliberately does not widen with the press count, and that is where §3 and §4
would have quietly contradicted each other. §3 says damage resolves off the first press so that
deep Focus makes him ramp faster rather than hit harder per swing. §4 says the opening window
widens with the count. Apply the widening to the Perfect window too and the first press — the one
that sets the damage — becomes easier to Perfect the deeper his meter runs, which is precisely
the damage increase §3 exists to prevent. Only the Good window widens, because "landing the
sequence" is defined in terms of Good or better, and that is what the constant-difficulty rule is
about.

Partial credit replaced the worst-grade combine rather than joining it. CN shipped multi-press as
a parameter with a placeholder rule — the set is worth its weakest press — and labelled it as a
placeholder. Leaving both reachable would have been two answers to "what is a sequence worth",
which is the shape of the `no_skill_check` scar: the flag and the criterion disagreed silently and
a test passed by reading the wrong oracle. The combine and its ordering table are deleted.

Two things in the brief did not match the repo and are reported rather than silently obeyed. The
brief describes the full-sequence bonus as "the Perfect bonus, +20 Focus"; Quick Shot's actual
Perfect bonus is +10 Mana, and +20 Focus belongs to Aimed Shot. Since Quick Shot is a protected
core the Beastmaster and the Survivalist also carry, changing its Perfect bonus would have
changed two other specs' basics, so the +20 was implemented as a named full-sequence bonus and
Quick Shot's own Perfect was left alone. And the brief's flagged sentence — that a full four-press
sequence should be worth meaningfully more than four single presses — only holds if the bonus is
read against per-press Focus rather than against four separate one-press casts. Both readings are
in the changelog for the designer to rule on.

The gate is live because it has to be. The bot cannot press a bar, so partial credit, the
tapering windows and the tell are exercised nowhere in the existing battery; `check_cs.gd` spawns
a real battle, drives the Sharpshooter's bar by hand at every press count the design allows, and
measures what the sequence actually paid. It was then broken on purpose five ways — the cap
raised, the per-press figure moved, partial credit removed, the Perfect window widened with the
count, the widening table flattened — and it caught four. The fifth, moving the per-press Focus
figure, passed clean, because every payout assertion was written in terms of the constant and so
followed it. That gap is the reason the payout numbers are now pinned to the values the
documentation quotes: a figure flagged as the designer's to move is exactly the figure that must
not move without the documents that quote it moving too.


## Batch CW — why the project guide got split in two

The knowledge sync had a ceiling and `CLAUDE.md` was eating it, but the size was the symptom.
The real problem was that one file was answering two different questions — "what rule binds me"
and "what happened here" — and the second kind of content grows without limit while the first
does not. A block per batch since the beginning meant sixty narratives around twenty rules, and
the rules lost.

The test that decided every line: does it tell a future session what to do or not do? Everything
else had somewhere better to be. What happened is the changelog's job and always was. What is
true right now needed a home that could not grow, which is why `state.md` is rewritten rather
than appended to — an append-only "current state" file becomes a second changelog within a dozen
batches, and then nobody trusts either.

The part worth defending is the gathering. A rule stated inside a story about the batch that
learned it reads as history, so it gets skimmed, and then it gets rediscovered the expensive way.
The `inquisitor` pool key is the sharpest example in the project: writing `devout` raises nothing
and resolves nothing, so the batch that gets it wrong ships cards no hero can be offered and
finds out later. That is not a fact about a batch, it is a landmine with a note beside it, and
the note belongs where someone will read it before stepping.

Writing the stamp-gate rule proved the point against itself. The first version was wrong — a grep
matched comments rather than assertions and reported half the real count — and it was only caught
by going and reading the suites. A rule asserted from a document about the code is exactly the
thing that rots; the fix was to check, and then to write the grep into the rule so the next
session checks too.

Reports moving into the repo is the same instinct applied to the other direction of the relay.
The reports were being retyped by hand between two instances, and a hand copy that drops something
is invisible — CL's overflow measurement was reported missing while sitting in the file it was
supposed to be missing from. A committed file cannot be mistyped in transit.


---

## Batch CX — the cut, and three rulings

Three of the four items this batch carried were one-line design decisions with real code behind
them, and the fourth was a decision not to spend a week. What is worth writing down is what the
work turned up on the way to doing it.

**The cut was never really about size.** 494 KB against a 400 KB threshold is a number, and moving
23 entries out is mechanical. The part that mattered is that eleven suites asserted their own
changelog entry against the live file, and **eight of them would have gone on passing after the
entry left** — a bare `contains("Batch BS")` is satisfied by any later entry that mentions BS in
prose, and later entries mention each other constantly. So the cut would have looked completely
clean: green suites, correct counts, and eight checks quietly asking nothing.

That has now happened three times here. BZ caused it in `test_batch_bb` and left it; CD found the
same shape in `test_batch_bo` two batches later and repaired one of them. The lesson is not
"anchor on the heading" — that was already written down. The lesson is that **the batch that moves
the entries is the only batch that cheaply knows which suites care**, and leaving the re-point for
later converts a mechanical edit into an archaeology problem.

**The verification found its own bug, which is the argument for writing verification you do not
believe you need.** Batch BF's `<h2>` wraps across two lines, so a line-anchored extractor counted
107 headings where the archive holds 108. Nothing about the split was wrong; the *checker* was.
It surfaced only because two different counting methods disagreed by one — and one is precisely
the error the byte-for-byte rule exists to catch. A checker that agrees with itself proves
nothing. The second script this batch ran re-derived everything from untouched backups rather than
from the splitter's own variables, which is the only version of that check with any independence
in it.

**Regalia is a good example of a bug that reads like a design question.** The state file described
it as one: wire it in, re-point it, or retire it. But the useful observation is that *re-pointing
alone would have changed nothing*, because the chooser names its candidates as literal strings and
Regalia was not in the list. An ability can be perfectly well-formed — correct payload, correct
target field, a description, an animation — and be unreachable because one function somewhere
enumerates six names and it is not among them. The data says nothing is wrong. Nothing throws.
It simply never happens.

And the two smaller faults underneath it were the same fault at different layers. The description
named `shield_charges` while the payload was `enemy_shield`; the log line named "Shielding" while
the ability was Regalia; and `battle.gd`'s comment counted two live shield sources when only one
had ever fired. **Three separate places asserting something the code did not do, none of them
checkable, all of them confident.** The comment is the one worth flagging — CU exists because a
comment is not evidence, and here was a comment that had been wrong since the day it was written
and would have stayed wrong forever, because nothing that could contradict it ever ran.

**The rename is the least interesting item and produced the most useful tool.** Sweeping a
candidate name against 700 abilities, nodes, statuses and runes is cheap once written, and it
rejected three of four candidates — including "Skullsplitter", which passes a word-level sweep
because it is one word and fails a human one because it reads identically to Skull Crack in a
combat log. The rule already said to treat a near-miss as a hit. What it did not say, and what
this batch learned, is that **the sweep has to be run against the components as well as the whole
string**, or a compound word walks straight through it.

**The thing this batch did not do is the one worth defending.** Per-hero relics is a good ruling
and the reason given for it is right — party-wide, a bar-swapping relic changes all four bars and
is a blunt object; per-hero it becomes a choice about which hero gambles. But it is a save-format
change with 25 read sites, four signature changes, two acquisition surfaces and thirteen relic
descriptions worded party-wide. The brief said to report the scope and stop
if it is large, and the value of actually stopping is that the four genuinely ambiguous
hooks — the victory heals, the rest heal, the resource floor — got reported as questions instead of
being answered by whichever way the implementation happened to fall. **A guess buried in a diff is
much harder to revisit than a question in a report.**

**And the suites found something nobody was looking for.** CW's `CLAUDE.md` split dropped every
batch narrative, and seven suites assert against text that went with it — ten red assertions and
an eleventh in the count-differ that notices them, sitting there for four batches because CT
through CW were all implement-only and no battery has run since CS. Two of the ten pass by
accident, matching a passing mention inside a surviving rule
rather than the block they were written for, which is the same "stopped asking its question"
pattern as the changelog case, arriving through a different door. That is the real cost of the
implement-only convention: not that things break, but that **the interval between breaking and
noticing is now measured in batches**, and the batch that finds it is never the batch that can
best decide what to do about it.


## Batch DA — the honest half of a two-part change, and the first copy-propagated defect

Two corrections, and they are opposite shapes. One is a magnitude going back; one is a refusal
going in. What connects them is that both were made possible by the *previous* batch reporting
something against its own interest.

**CZ discredited the measurement CZ was sized against, and shipped anyway.** That is the thing
worth writing down. Its §2 found that CY's Faith arrival row samples the Devout's own meter — the
one that holds and never releases by rule — so the "1.6 of the 5 a release needs" that motivated
the whole change had never been a measure of release frequency at all. The batch wrote that finding
up clearly, printed the row that *does* answer the question (0.81 releases a battle), and then kept
the magnitudes it had already sized against the bad number. Not dishonestly: it re-measured
afterwards and reported four combinations, one of which was the one this batch has now reverted to.

The general lesson is not "re-measure". It is that **a batch that discredits its own instrument has
acquired an obligation it cannot discharge in the same batch**, because everything it has already
built is sized against the discredited figure and unpicking that is a second batch's worth of work.
The right move is what CZ actually did — ship, flag hard, name the one-character alternative — and
the failure mode to avoid is the quieter one where the finding goes in the report and the
magnitudes never get revisited because the report reads as though the matter was settled.

**The half that survived and the half that did not split along a clean line, and it is not "how
big".** The threshold was sized against *structure*: a bar of five in a fight lasting three to five
turns per hero is too long, and that argument does not depend on the arrival figure at all.
The builders were sized against the *number*. So one stayed and both went back, and the
re-measurement confirms the split was real — the threshold alone still roughly triples releases at
every rung. **When an instrument turns out to be wrong, sort the decisions by what they were
actually resting on, not by how confident they felt.**

**The second reason the builders went back is the one that would have decided it even if the
numbers had been fine.** Three per absorb against a threshold of three means one absorbed hit is a
whole release, so a shielded ally never *holds* Faith — and Conviction pays on the high-water mark.
The mechanic did not get weaker; it stopped existing for allies. **A magnitude that changes what a
card IS is not a tuning change**, and it should never arrive as a consequence of a threshold moving
somewhere else. That is a different kind of reviewable event from "this number is too high", and
the two want different scrutiny.

**Glacial Prison is a small refusal with one interesting property.** Every other member of CO's set
calls `_apply_status` unconditionally and relies on `add_status`'s `max()` to discard a weaker
value; the gate's job there is to predict the max. Glacial Prison **guards its own write** — it
never calls the function at all on a Chilled target — so the prediction table has to mirror the
*guard*, not the value. Mirroring the value would make the gate propose a write the handler will
never perform, read it as an improvement, and stop refusing: CR §3's defect approached from the
opposite side.

**And it exposed how narrow this class of refusal really is.** The rule darkens a *button*, and a
button serves every legal target, so a picked-target card can only ever be refused when *no* enemy
would improve. On Glacial Prison one unfrozen enemy keeps it lit. That is not a flaw — Rime and
Bola have had the same scope since CO — but it is worth being explicit that **"refuse a cast that
would do nothing" and "refuse a cast onto this target that would do nothing" are different
features**, and only the first one exists. Building the second means a per-pick affordance, which
means a second decision site, which is the thing CO exists to prevent.

**The copied-helper rule is the first genuinely new failure mode this project has recorded in a
while.** Everything in the traps list is drift: one authority, edited, a stale copy left behind.
This is propagation — five gates carrying one enumeration hole because four copied the fifth's
walk rather than deriving one. The asymmetry is what makes it worth its own rule: **drift leaves
one wrong copy and a chance that a diff notices; a copy leaves N wrong copies, all born wrong, none
of them compared against anything.** Fixing the origin leaves four.

The sweep for others found the battle fixture `_spawn` in seven gates as four divergent bodies, and
the divergence has already cost twice — once when a copied `_report` drifted into two output
formats and the battery's grep silently missed one of them, and once when CQ removed two
`Profile.set_flag` lines from one copy on purpose and left them standing in two others with nothing
reporting the split. **Neither was found by a test. Both were found by someone reading two files
side by side**, which is the strongest argument for the rule: this defect class has no detector,
so it needs a habit instead.

## Batch DB — what a copied helper actually costs, and the shape that would not compile

DA named the failure mode and refused to fix it in the same batch, which was right: **a shared
fixture serving four legitimately different needs is a design problem, and getting it wrong breaks
seven gates at once.** This is the note on what the fix turned out to be, and on the two things
that were only visible from inside it.

### The divergence was worse than the census said, in a direction nobody would guess

DA reported `_spawn` as **seven copies, four bodies**, and that was exact. What it got wrong was
the *flag* half: it recorded CQ's removal as leaving the two `Profile.set_flag` lines standing in
**two** other copies. They were standing in **five**. The census counted bodies correctly and
described the divergence from memory, and the memory was wrong — **which is the copied-helper
failure arriving one level up, in the prose about the copies.**

### The interesting part is that the flags were dead, and had been for four batches

CQ removed them from `check_cm_live` because `battle._nobody_can_press()` had just made them
unnecessary. It is the same reason in the other five, and it was already true when CQ wrote it —
`_nobody_can_press()` is `sim or autoplay or headless`, and a gate is always headless. **So five
gates spent four batches executing two lines that could not affect any check they ran.**

They were not, however, inert. `Profile.set_flag` calls `_save()`. **The five gates were writing
the player's `profile.json` on every run** — a side effect nobody asked for, in a file no gate
reads, two hundred lines away from `check_ct` asserting that it leaves the player's save exactly
as it found it. **A dead line and a harmless line are not the same thing**, and the only way to
tell them apart is to follow the call rather than read the name.

### The shape that would not compile, and why that matters more than the fixture

The obvious consolidation is a base class: `extends GateBase`, every gate inherits `ok`, `_report`
and `_spawn`, **and not one of the several hundred `ok(...)` call sites moves.** It is the right
design and it does not work — **a `--script` SceneTree target cannot resolve its own base class**,
in either spelling, with the class cache present and correct.

**The way it fails is the point.** It prints `Parse Error: Could not find base class` on stderr,
runs **not one line** of the gate, and **exits 0**. A runner that trusts the exit code sees a pass.
A runner that greps for a check count sees nothing and prints `checks=?` — which four gates were
*already* printing for unrelated reasons, so it would not even have looked new. **The project has
been recording this fault since CP under `load()` returning a broken script; it is the same fault,
and the exit code is simply where it surfaces when the broken thing is the entry point.**

The fixture is a `preload`ed `RefCounted` instead, and it carries no `class_name` — that
registration lives in a gitignored cache only the editor regenerates, so a `class_name` here would
resolve on this machine and fail on a fresh clone. **Preloading by path needs no cache and cannot
rot.**

### A rule whose mechanism is right and whose list is wrong

CT's rule — *a `--script` harness can only compile files that name no autoload* — is correct and
was load-bearing here. Its written form lists "`Run`, `Profile`, `Talents`, `Classes` or `Relics`".
**`project.godot` registers three autoloads: `Run`, `Settings` and `Music`.** The other four are
`class_name` script classes, safe at compile time, and the gates have been naming `Talents` since
before the rule was written. **A rule that over-reaches gets quietly disbelieved**, which is worse
than one that is narrow and exact — the fixture needed to name `Talents`, and a literal reading of
the rule says it may not.

### What the battery cost, and why it is the batch's real finding

Five implement-only batches banked **72 failing assertions across 26 suites**, zero throws. Almost
none of them is a bug in the game: they are suites asserting a Faith threshold of 5 against a game
that releases at 3, and initiative literals that CY moved. **The stale-assertion bill is not paid
by the batch that runs the battery; it is paid by the batch that repairs them**, and DB deliberately
did not, because §0 bound it to changing no behaviour and a repair pass is a ruling per assertion.

---

## Batch DC — the Faith threshold assertions

### Why these came out ahead of the consolidation

Twenty-three of DB's seventy-two failures were one cause, and **none of them needed a ruling**.
CZ moved `FAITH_RELEASE` to 3, the code has been right ever since, and the assertions were simply
behind. The other forty-nine each need a decision about what the check should ask *instead*, which
is a different kind of work and a different kind of risk. **Taking the free ones first shrinks the
pile that needs judgement without spending any judgement**, and it leaves a known red rather than
a green that blesses an unreviewed value.

### Repairing to intent, when intent and the code agree anyway

Every one of the twenty-three was repointed to 3 because that is what the designer ruled — not
because that is what `battle.gd` currently does. Here the two agree, so the distinction bought
nothing on the day. It is still the right habit: the one time it matters is the time the code is
wrong, and you cannot tell which time that is while you are repairing. **CQ §3 learned this on a
talent that had been changed by accident, and re-pointing the assertion at the accident would have
made the accident permanent.**

The corollary is the reason the check counts are published beside the failure counts. A repair
that leaves the count alone is a repoint; a repair that lowers it is a deletion wearing a repair's
clothes. **Publishing both numbers makes the difference impossible to hide, including from
yourself** — which matters most when the temptation is strongest, at the end of a long pass with
one stubborn check left.

### The half of "stale" that was not stale

`test_batch_bi` asks that the Devout's passive block say his shield pays **2 Faith an absorbed
hit**. It was red, and every other red in that suite was an assertion that had fallen behind the
code. This one was the opposite: **the assertion was right and the game's own text was wrong.**

DA rolled the builders back from CZ's tripled rates and rolled back the constants only. The
Devout's passive description and his in-battle status chip both went on promising three. What
makes it worth writing down is *why it survived four batches*: the master document already said
two, so a reader comparing the docs to the game would have caught it in a second — but nothing
compares them automatically, and the suite that asks the question directly was already failing for
an unrelated reason. **A red check does not announce a second, different problem hiding underneath
it.** That is an argument for keeping the red pile small, and it is the second argument for doing
this batch before the consolidation rather than after.

### A moved threshold moves the instrument, not only the number

The repair that did not work first time is the one worth keeping. `be` measures how often
Communion advances an ally, by parking one at the top of the eligible band and counting fires. The
band moved from four down to two with the threshold, the literal was repointed — and the row still
read zero percent, next to a measurement of the same node at 29.8%.

At four-of-five, an advance left the ally at five and his stack count rose, so counting stacks
detected the fire. At **two-of-three, an advance takes him TO the threshold, which releases and
resets him to zero** — so counting stacks reads every fire as a miss. The detector had to become
the release counter.

**A threshold does not only invalidate the numbers an assertion pins; it can invalidate the way
the assertion looks at all.** The uncomfortable part is that `bf` already knew this — BF moved the
same band once before and left a comment saying the release counter is the only honest witness
there. The comment was in the right file, attached to the right function, and the repair was made
without reading it. Notes only work where somebody looks; **the ones that survive are the ones
attached to the thing that fails, and even then only if the reader is looking for a reason rather
than a value.**

### Batch DE — an instrument that got more expensive exactly as it got more useful

CD's count-differ watched five suites. DD widened it to forty-five, which was plainly the right
direction, and the battery went from 29.6 minutes to about fifty. Nothing was implemented badly.
The suite answered its question by running the suites, so **widening the coverage nine-fold
widened the cost nine-fold**, and the only lever anyone had left was to watch less.

That is worth naming as a shape rather than as an incident. **A test that spawns tests squares the
work when you widen it.** The tell is not slowness — slowness is ordinary — it is that the price
tracks the coverage one-for-one, so every improvement to the instrument argues against itself.
Once the cost curve looks like that, the fix is never a faster implementation.

The question that dissolved it was not "how do we make this cheaper" but **"what does this suite do
that the runner cannot?"** For the differ half the answer was *nothing*, and it had been nothing
all along: `run_battery.sh` was already spawning every target, already capturing stderr, already
running the same two greps. `test_batch_cd` was re-doing the run in order to look at it. The
comparison — the one thing the runner genuinely did not do — is about four hundred lines of
GDScript over files that already exist on disk.

**Redundancy is hard to see when the duplicate is in a different language.** The grep is in bash in
one file and a `RegEx` in GDScript in the other; the spawn is `"$GODOT" ... &` in one and
`OS.execute` in the other. Nothing greps as a duplicate. The comment at the top of `cd` explained
at length *why* a suite must run the suites to see a throw, and the explanation was correct and
the conclusion did not follow, because the runner was already doing the running.

Two smaller things fell out of it, neither of them planned.

**The asymmetry was already there.** The brief asked that a falling count be an error and a rising
one a notice. Writing it, it turned out to be the rule `an`'s band already carried — floor tight,
ceiling generous, "the floor is the half that catches a real fault". A convention for how to WRITE
a band and a rule for how to READ one are the same rule, and it had been sitting in a comment
being applied by hand.

**And one open question closed itself.** `state.md` carried an observation nobody could settle: the
battery read `an` at 6053 and `cd`'s sweep read 6055, and whether the two-check gap was draft
randomness or a difference between launching from the shell and launching with `OS.execute` needed
a deliberate experiment. There is one launcher now. The question is not answered; it is gone, which
is the better outcome and was not the reason for the change.

The part that should stay uncomfortable: **the failure baselines are worth more than the check
counts, and the check counts are what the brief was about.** With 47 known failures across 20
suites a 48th is invisible, and that is not a hypothetical — `bi` was right and the game was wrong
for four batches, hidden behind a suite that was already red for an unrelated reason. Baselining
the failure count per suite was three fields in a JSON file and one comparison. It closes a hole
that four batches walked past, and it arrived as a §3.

And it proved the point on itself within the hour. `test_batch_bo` has been recorded in every
document as `1025 /0–1 (the known flake)`. It is not: its floor of 1 is a stale documentation
assertion from CW's split, and the flake is a *second* failure that would read 2. **The band
admitted the observed value, so nothing ever contradicted the label** — DD read `bo` at 1, recorded
0, and reasoned that the flake had not appeared that run. The arithmetic worked either way, and
nobody looked at which check was red, because **a suite already excused by a known cause does not
invite the question.**

That is the failure mode the §3 field was built for, arriving from an unexpected direction. The
danger is not only that a NEW red hides behind an old one; it is that a *plausible reason* attached
to a red stops anyone reading it. **`bi` hid behind an unrelated failure for four batches. `bo` hid
behind an explanation.** The second is harder to see, because it does not look like an
unanswered question — it looks like a settled one.


---

## BATCH DH — WHAT A CROSS-SPEC CLAUSE IS ACTUALLY FOR, AND THE THREE THINGS THE BRIEF HAD WRONG

The gap the batch closed is easy to state and was invisible for the whole life of the draft: **all
120 abilities were authored inside their own spec**, one pool at a time, so no card ever referred
to another spec's vocabulary. Nothing was broken by that. It just meant the draft screen asked
"what does this hero want?" and never "what does this *party* want?", which is the more interesting
question and the one a four-of-twelve spec selection was built to pose.

Two cards already crossed the line by accident. Fault Line gives the Sharpshooter Break, and
Breaking Darkness amplifies every source of Break; Downwind copies whatever debuff an ally applied.
Neither was authored as a coupling — they are couplings because their authors reached for general
vocabulary instead of spec-local vocabulary. **That is the whole technique, and it costs nothing:
write the clause against the game's shared nouns rather than against the spec's own.**

**The rule that matters most is the one about naming, and it is not documentation.** A coupling the
player cannot see on the draft card is not a coupling, because the draft is where the decision
happens and the decision is made under time pressure against two other cards. Breaking Darkness is
the proof: DH changed nothing mechanical about it. It amplified allies' Break the day it shipped.
The clause is four lines of card text naming Fault Line and Turn the Blade, and it converts a
combo people found by accident into one they can draft toward. **Discoverability was the whole
deliverable and it was worth a slot in the batch.**

### The three claims that did not survive contact with the repo

The brief was careful and specific, and three of its load-bearing statements were wrong. All three
were wrong in the same direction — **they described the game as of a mental model, not as of the
code** — and each would have produced a different kind of damage.

**"Canis's strikes apply Bleed."** Asked for as new work. `Summon Canis` has read *"attacks with
you for 20% of your Attack, building 20 Bleed"* since the Beastmaster shipped, its arrival lays
Bloodhowl's 15 on every enemy, and its Loyalty gift is +2 Bleed a stack. Writing this would have
been **BD's Deadfall/Snare Trap duplication exactly** — the fault the brief's own §0 warned about,
reproduced in the same batch that warned about it. The tell was cheap: the clause named a card, and
nobody read that card's text. **The roster BR §1 tells you to sweep includes what the cards already
say they do.**

**"Battle Shout already reads enemy Bleed."** Battle Shout reads `bleed_buildup`, an integer meter
on the unit that bleeds out at 100. There is no `bleed` row in `STATUS_INFO` at all — it was
deleted at BJ §1 as unreachable, and the chip a player sees is *synthesized* from the meter in
`unit.gd`. An implementation that took the brief at its word would have called
`_apply_status(_, "bleed", …)` and indexed a table with no such key. **The distinction between a
meter and a status is invisible in prose and total in code.**

**"If statuses do not currently carry a source, say so and report the cost."** They have carried
one since Batch W — `_apply_status` stamps `src_name` so that later mitigation can credit its
caster. The brief had budgeted this clause as possibly-too-expensive-to-build and had given it
permission to wait; it cost a read. **The interesting half is that the brief was right to ask.**
The infrastructure exists but is *partial*: 53 of 204 single-line call sites pass `src`, so a
status applied by one of the other 151 reads as unattributed and Harvest pays it the base rate.
That is the safe direction — a missed bonus rather than a false one — but it is a real
under-payment, and it is the kind of fact that only appears if you measure the call sites instead
of confirming the field exists. **"Does the data exist" and "is the data populated" are two
questions and the second one is the one that bites.**

### The coupling that is worth more than the other eight

Shared Grief reads how many allies stand below half health, and it is the only clause in the batch
that couples two *engines* rather than two vocabularies.

Mercy accrues on the **crossing** below half — `_check_below_half` fires once, gated on
`was_above`. A hero who drops below half pays Holy one stack and then, for as long as they stay
there, pays her nothing at all. Meanwhile the Berserker's entire Blood Frenzy band **lives** below
half on purpose: Blood Offering exists to buy the band deliberately, and the spec is built to sit
in it. So the party composition that keeps a hero parked in Holy's generator is precisely the one
her generator cannot see, because it measures a transition and he is a steady state.

**The two specs are inverted from each other and that is what makes them fuel.** She is starved
when the party is healthy; he is strongest when it is not. One clause reading a *level* rather than
an *edge* converts his standing state into her resource. Nothing else in the batch has that
property — the other eight couple a status one spec applies to a status another spec reads, which
is useful and mechanical. This one couples two design intentions that were authored years apart and
never told about each other.

**The general form is worth keeping: when a meter pays on a transition, ask which spec parks in the
state it transitions into.** That spec is a partner nobody has written down.

## BATCH DI — A CLAUSE THAT LOOKS LIKE IT WORKS

DH shipped a good rule and half a mechanism, and the half that was missing could not be seen from
anywhere. Harvest pays the Survivalist more for a wound an ally opened than for one he opened
himself. The clause is four lines, it reads a field that has existed since Batch W, and it is
correct. It was also, in practice, paying almost nothing — because only a quarter of the code that
applies a status was telling the status who applied it.

**The interesting property is not the bug. It is that the bug had no symptom.** An unstamped status
and a status the Survivalist laid himself are the same value to that loop: both are skipped, both
pay the base rate. There is no log line, no warning, no visible difference between "the party
opened seven wounds and you were paid for one" and "you opened them yourself". A player would have
read the card, watched the number, and concluded the bonus was small. **The mechanism degrades into
a plausible design.** That is a much worse failure mode than a crash, and it is the one this
project keeps finding: BA's Harvest over-count, the Stalking Horse species, the vacuous assertions
in `as`/`at`/`aw`. A thing that is wrong loudly gets fixed in the batch that ships it.

**So the general rule is about ORDER, not about `src`.** When a clause starts reading a field it
did not previously read, the batch that writes the clause owes a count of how many writers actually
write that field. Not a survey of the field's existence — DH's comment correctly noted that
`src_name` had been stamped since Batch W, and that was true and useless. The question is never
"does this field exist"; it is "what fraction of the paths that should write it do". DH asked the
first question and got a reassuring answer.

**The second lesson is about how the coverage figure itself rotted.** The recorded number was 53
of 204. It had been quoted into `docs/state.md`, into DH's own source comment, and into this
batch's brief, and it was wrong — the true figure was 63, because 25 of the calls wrap across lines
and a single-line grep cannot see them. Nobody introduced an error; the measurement was simply
never re-derived, and a measurement that is easy to take badly will be taken badly and then
propagated. `check_di` §1 balances parentheses instead, and it skips the two *comments* that name
the function — which is the same fault one layer down, and would have made the new number wrong by
two.

**And the third is about what "the party" means.** DH's comment states that `heroes` carries the
companions. It does not, and the belief is not silly: `_living_hero_with` filters
`not h.is_companion` as though it might, four sites write `heroes + companions` because the union
is real, and `_hero_side()` exists solely to build it. A codebase that has *three* idioms for "the
party" will eventually have a walk that picks the wrong one, and the walk that picked wrong here is
the one deciding whether Aguila's Exposed counts as the party's work. **DI did not fix it**, because
fixing it moves a magnitude and this batch forbade itself that; it asserted it instead. An assertion
is how a belief stops being a belief.

## BATCH DJ — THE FIX THE LAST BATCH RECOMMENDED WAS THE WRONG ONE

DI ended by naming the thing it would not do and writing down how to do it: *"the fix is one word in
DH's loop (`heroes` → `_hero_side()`)"*. It was right that the batch should stop, right about why,
and **wrong about the word** — and the way it was wrong is the whole lesson of this batch.

`_hero_side()` is the union of the *living*. Harvest's loop is deliberately not: DH's own comment,
three lines above the line DI was proposing to change, says *"a hero who has since DIED still opened
the wound, so neither is filtered on `dead`"*. Taking the recommendation would have closed the
companion gap and opened a fresh one **in the same loop, in the same shape, in the same batch** —
a wound opened by a fallen hero would have dropped from paying 1.5 to paying 1.0, measured here at
**0.6664**. The second defect would have been introduced by the fix for the first, and it would have
been just as invisible, because the same thing is true of both: nothing logs it, nothing tests it,
and the number it produces is a perfectly ordinary number.

**A recommendation from the batch that found the bug is not evidence, and it is the most persuasive
kind of non-evidence there is.** It arrives with the finding, in the same voice, from the process
that was demonstrably paying attention. DI's report was careful, correct about the diagnosis, and
correct to refuse the fix. It still got the fix wrong, in one word, in a place where being wrong
costs nothing visible. The only reason DJ did not simply apply it is that the union had to be
*written out* to be typed at all, and typing it out is what made the `dead` question appear.

**That is the argument for spelling a thing rather than calling a helper.** `heroes + companions` is
uglier than `_hero_side()` and it is four characters longer. It also states, at the site, the two
decisions the site is actually making — which collections, and whether the dead count — where the
helper states one of them and hides the other behind a name that does not mention it. **The helper
is not wrong. It answers a different question, and its name does not say which.** A codebase with
three idioms for "the party" does not need a fourth; it needs the three to be distinguishable at the
point of use, and `_hero_side()` is only distinguishable if you go and read it.

**The second thing this batch found is what an `is_companion` filter is worth.** CV §4 recorded that
23 nodes are *"shorted by an explicit `is_companion` filter"*, and the sweep behind that number was
real — all 23 filters exist, exactly where it said. Every one of them filters `heroes`, which cannot
contain a companion. **They remove nothing.** They are, all 23, the author writing down an intention
against an array that had already satisfied it.

This is a nicer kind of wrong than it looks. The filters are *evidence of intent* — someone thought
about companions at that site and decided against them — and that is genuinely useful when you are
trying to sort a deliberate exclusion from an accident. What they are not is a mechanism, and the
consequence runs the other way and bites: **a site with no such filter is not thereby including
companions.** CV read the presence of the filter as the exclusion and, reasonably, read its absence
as inclusion — which is how four node texts came to be moved *to* "ally" on the strength of read
sites that reach no companion, and how `wd_tank_spank` came to be cited in the rule file as the
proof that the distinction works.

**None of those four were reverted here.** Reverting the text is one ruling; fixing the code is the
opposite one; and a sweep is not entitled to make either. What a sweep is entitled to do is put the
eleven sites in a table, say which each one *looks* like and why, and pin every one of them so the
table cannot rot — which is what `check_dj` §5 does. **A finding that is only prose has a half-life.**
DI's own §3 is the proof: it recorded the companion gap accurately, in three documents, and it also
recorded the fix, and one batch later the accurate part was still accurate and the fix was still
wrong, and nothing in the repository could tell the difference between them.

---

## Batch DK — the widening that did not land, and why it is the one worth writing down

DJ put eleven ally-worded effects in a table and ruled on none of them, because sorting a deliberate
exclusion from an accident is a designer's question. DK is the answer, and the answer was four and
seven. That part is bookkeeping. **The part worth recording is the one the brief got wrong.**

The brief listed five to widen and said of them: *"Empowerment, healing received, Break reduction,
healing and cleansing are all things a beast can plainly receive. Nothing in the code ever said it
shouldn't."* Four of those five are exactly right. The fifth is Tank and Spank, and the code did say
it shouldn't — in a comment, in the same function, a hundred and eighty lines below the line that
reads the status: *"a beast's blows go through `_companion_hit`, which never reads this block, so the
companions are correctly untouched."*

**Empower applies to a companion perfectly cleanly.** The status attaches. The chip renders. The
tooltip is correct. Forty seeded blows with it standing dealt exactly the same damage as forty
without it — not approximately, exactly, because the beast's damage path never asks. Widening that
loop would have produced a card that says "ally", a collection that contains the beast, a status that
lands on it, a visible chip, and no change to any number in the game.

**That is worse than leaving the word narrow**, and the reason is not subtle: a narrow word is
honest and a chip that does nothing is a lie the player can see. Somebody would have drafted around
it.

So the rule DK earns is not about companions at all. It is that **a widening is finished when the
effect arrives, not when the collection widens** — walk the chain from the loop to the number that
moves, and measure it on a live body. There are three places a widening dies and only the first is
the collection: the loop is narrow; a filter downstream removes it; or the read site below never runs
for that body. CV believed the second was the mechanism. DJ proved it never was — all 23
`is_companion` filters walk `heroes` and remove nothing. **DK found the third, which is the one no
source grep can see**, because there is nothing at the site to grep: the absence is a hundred and
eighty lines away, in a function with a different name.

**The second thing worth recording is what the ruling cost the rule file.** `CLAUDE.md` cited
`wd_tank_spank` as the worked example of why hero and ally are worth distinguishing. It was the
example precisely because it reads so cleanly — a party buff, an obvious beneficiary, a word that
tells you which. It was also, for the whole time it was cited, false. The distinction is still worth
having; this was never the proof of it, and a rule whose worked example is wrong is a rule people
half-remember. The example is Hold the Line now, and it is the example because it can be *measured*:
a summoned bear banks 20 Break from a blow that used to cost it 40.

**And the negative control is the whole of why any of this is believable.** Four effects paid four
units instead of five for the life of the project, and nothing anywhere said so — not a log, not a
suite, not a battery. A check written after the fix passes on the fixed tree, which is no evidence at
all. So `check_dk` empties `companions` for the length of one arm — precisely the collection these
sites walked before this batch — and asserts the beast gets nothing: Sanctuary heals it 0, Hold the
Line leaves it the full 40. **The control is what makes the measurement a measurement rather than a
description**, and on a failure this quiet it is not optional.

The last thing is small and is the kind of thing that comes back. Rallying Shout was grouped with the
two pure resource refuels, on the reasoning that a beast has no resource bar. True — and the card
also sheds 30 Pressure from *"the whole party"*, which a beast can plainly receive. Only the
ally-worded clause moved, because "party" is not one of the two words the sweep was about, and a
batch that quietly rules on a third word is a batch nobody can audit. **It is recorded as owed,
which is the honest place for it.**

---

## BATCH DL — THE CLAUSE IS THE UNIT, AND A WORD THAT MEANS EITHER IS A WORD NO SWEEP CAN CHECK

DK's last note ends with "it is recorded as owed, which is the honest place for it." This batch is
that debt paid, and paying it turned out to say something larger than the card.

**The interesting thing is not that Rallying Shout was wrong. It is that it was wrong in a place two
consecutive sweeps were standing in.** DJ §2 swept every broad ally-worded text in the project and
found eleven. DK §2 ruled on all eleven. Rallying Shout was *in both passes* — it was named, read,
and ruled — and the clause that was actually broken was never looked at. Not overlooked: **not
visible**. Both sweeps were sweeping for the word *ally*, and the broken clause said "the whole
party", which is neither of the two words. It was the half of the card nothing in the project was
searching for.

**So the failure was not a missed site. It was a unit-of-analysis error.** A sweep that iterates
abilities finds the ability, reads it, sees an ally-worded clause, rules on that clause, and moves
on satisfied — and the card is now half-ruled, in a way that looks exactly like a card that has been
ruled. The gate that pinned it made this worse rather than better: `check_dk`'s entry for Rallying
Shout pinned the PRESSURE loop as evidence the card was correctly narrow, while the ruling it was
recording was about the RESOURCE loop. **A pin on the wrong clause of a two-clause card is a pin
that certifies the thing you did not check.**

**The rule that falls out is one line: read a card clause by clause.** It is in `CLAUDE.md` now, and
the survey that came with it found six more cards with two clauses of different shape under one
word — Bulwark of Fortitude carries three shapes in a single sentence. None were ruled on. Naming
them is the work; ruling on six cards in a batch scoped to one is how a sweep becomes a rewrite.

**The second half of the batch is a vocabulary retirement, and it is instrumental rather than
tidy.** "Party" reads as either *hero* or *ally*. That is not a style complaint: it is precisely why
this clause survived. A word that means either cannot be swept for, cannot be checked, and cannot be
wrong in a way anybody notices — a text saying "the whole party" is *unfalsifiable* against its read
site, because whichever collection the code walks, the word was arguably right. **Retiring it is
what converts a judgment call into a check.** Every use is now *hero* or *ally* (or *warband*, where
the group is the enemy side), and `test_batch_bx` §4b keeps it retired in the same place and by the
same construction §4 already keeps "beast" retired.

**The check was shown to bite before it was trusted, on three surfaces**, because an instrument
added without a control is an instrument nobody has tested — and the previous retired word's check
had already earned that discipline by catching seven live uses in DK before its battery.

**And a smaller thing worth keeping, because it is the second time this shape has appeared in three
batches.** DK recorded the reason for the resource clause as *"a companion is built with no
`resource_name` and `max_resource` 0"*. The first half is true. **The second is not** —
`max_resource` is `unit.gd`'s default 100 on a companion, never overridden at the summon. Nothing
depended on it being 0, so nothing failed, and the sentence sat there reading as an explanation. It
would have become load-bearing the first time somebody widened that loop "because a beast's bar is
zero anyway". **A reason recorded beside a decision is a good practice that creates a new place to
be wrong**, and the fix is the same one the project already applies to numbers: derive it, do not
recall it. Rallying Shout's resource loop now carries the `resource_name` guard the other two
refuels already had, so the reason is true *at the site* rather than only in a comment.

**One admitted asymmetry.** §2 corrected four false *ally* words it did not strictly own — three
battle-log lines and Consecrated Ground's Faith clause — because each sat in the same card or one
screen away from a text §2 was moving, and leaving them would have made those cards newly
misleading rather than merely imprecise. Texts with a false *ally* and no "party" anywhere near them
were reported instead. **That line is arbitrary in the small and defensible in the large**: the
batch's remit was one word, and every departure from it is named.

---

## Batch DM — a batch that widened nothing, and why that is the measurement

DL listed six more cards carrying clauses of two different shapes under one word and ruled on none
of them. DM read all six clause by clause: **sixteen clauses, fourteen of which carry a collection,
and all fourteen collections were already correct.** Bulwark of Fortitude's four, Consecrated
Ground's three, Divine Wrath's two, Battle Shout's group clause, Hold the Line's two group clauses,
Sacred Resolve's two — every one of them says what its read site walks.

**That is a finding, not an absence of one.** A thread that has run nine batches, each finding the
next thing, has no way to end except by someone doing the work and reporting that the work came
back clean. The alternative is abandonment, which reads identically from outside and leaves the
next author to start again from the same suspicion. **A batch that widens nothing has still
measured something, and the measurement is what closes the thread.**

**What was actually wrong was a scope this thread had no word for.** Battle Shout and Hold the Line
each hand five Rage to the *caster* — one body, which is neither the four nor the five. The whole
vocabulary the thread built (hero, ally, and no third word) is about groups, and a payload that
reaches exactly one unit sits underneath it. Battle Shout's card put that payload inside "A roar
every hero answers:", so the group clause's colon-list promised four heroes something one unit
gets. **Nothing in nine batches of sweeping for *hero* and *ally* could have caught that**, because
neither word was wrong; the card had a clause with no word at all.

The fix is the most reassuring kind available: **Hold the Line already worded the identical payload
correctly**, one tree over, as its own sentence — "Refunds 5 Rage." So the correction was to copy
the sibling card rather than to invent a phrasing, and the wording is one the project had already
chosen and lived with. It is also worth noting where the fact *was* recorded correctly:
`check_co` and `check_cy` have both carried "hands the caster +5 Rage" since CO. **Two gates knew.
The card was the only surface that disagreed** — which is the inverse of the usual failure, where
the code is right and every document is stale.

**The other correction is the one that should be uncomfortable.** DL fixed Consecrated Ground's
Faith clause on the card and left four prose copies of the same clause saying *ally* — three in
`master.html`, one in the glossary — for a payload `_gain_faith` refuses outright. This is the
DA/DC/DG shape for the third time: **one surface of a clause gets fixed, the batch feels finished,
and the rest are carried.** The rule the project already has ("sweep the number, not the field")
turns out to need its twin: **when a clause moves, sweep the clause across every surface, not the
card across one.** The instrument that found these was the literal sweep run before and after, and
it found them because it pairs every suite needle against every document — the same instrument
that then caught a claim in this batch's own gate.

**Which is the last thing worth recording, because it happened to this batch and not to a previous
one.** `check_dm` §1 asserts that Bulwark and Consecrated Ground share their walk byte for byte,
and it asserted the count was **two**, because two is how many of them the batch was looking at.
**There are five.** The gate failed on its first run, on its own author's unverified number — the
count-in-a-brief fault landing inside the instrument written to prevent it. The assertion is now
the property the reasoning actually rests on (the walk is *not* unique, so the anchor must be the
clause) and the live count is printed rather than written down. **A number you did not derive is a
number you are quoting**, wherever you happen to be writing it.

**And a seventh family was found and deliberately not swept.** Both *upgraded* cards drop "Refunds
5 Rage" while the code still pays it, and the pool-pick Battle Shout shows the node's numbers
because there is one `description` in the project for three magnitudes. Neither is a clause that
mis-says; both are clauses that under-say. **Adding a clause to a card is authoring, and correcting
a wrong word is repair** — so both are reported and neither is taken. The thread ends here on
purpose: nine batches of "and then we found the next thing" is long enough that the discipline
worth keeping is the one that says where to stop.

---

## BATCH DP — WHEN A RULING MAKES THE DEFECT

DO settled the talent charter and implemented it, and in doing so it broke four cells that were
correct the day before. Mind Flay and Mass Hysteria are the only appliers of Psychosis and Hysteria
in the game; DO moved both into the draft; four Occultist Madness nodes that had been reading a
**tree-internal** dependency — which the charter explicitly permits, because a cross-row condition
bets on a node the player *chooses* rather than a card they are *dealt* — were reading a **drawn**
one by the time the batch ended. Nobody made a mistake. **A ruling can manufacture a defect, and
the batch that makes the ruling is the one that owes the report.** DO reported it and left it
unruled, which is the whole reason this batch had somewhere to start.

**The instrument could not have found this, and that is the more useful half.** DN's pass matched
ability NAMES against node text, and every one of these four cells names no ability whatsoever.
`sm_precision` was the same shape and was found by a person reading. A status has appliers the way
an ability has a source, but the node reads the *status*, so a name-matching sweep looks straight
through it. **The ability rule and the status rule were always one rule; only the instrument made
them look like two.**

**Four cells re-pointed onto one currency is how you flatten a lane, so the brief asked for the
difference and it was worth asking for.** Madness was authored as a theme — enemies turned on each
other — and "stacks of Ruin" four times would be one idea with four price tags. The four read an
application, that application's magnitude, an event, and a depth threshold; and **none of them
reads a detonation**, because three cells in the Ruin lane already do. The constraint that produced
that spread was not aesthetic: every one of those quantities was *already spoken for* somewhere,
and finding the four unclaimed ones is most of the design work.

**Two of the four turned out not to need code at all, and one of those was invisible from the
text.** `oc_delirium`'s card named Psychotic and Hysterical enemies; its read site names no status
and never has — it fires on any enemy strikes-a-fellow, which the code's own comment explains is
madness-driven by construction. **The bet was three words of prose over a correct implementation.**
The repair was to make the text say what the code does, in the words the node one row down already
uses for the same trigger. It was deliberately *not* narrowed to "Bewitched", which would have been
the obvious minimal edit: that would under-state the payload the moment Mind Flay is drafted, and
an absent clause does not mis-say, so no test in the project would ever catch it. **The cheapest
correct edit and the smallest edit were not the same edit.**

**The cost nobody had written down was a rune.** The Rune of the Whispering Dark writes
`spread_ranks` and `spread_ruin` — the two fields Spread of Madness owns — and sells both clauses
on its card. Re-pointing the node onto a fresh field name would have left two of that rune's four
clauses paying nothing, silently, for a 100g purchase. The fix was not to notice it in review; the
fix was to keep both fields and re-point their *meaning*, which cost one line of card text and no
payload edit. **The general property is asserted now** — every stat field any rune writes has a
live read site — because the next batch to re-point a node will not remember this one. That is the
same lesson as "cutting a clause means cutting its payload term", read backwards: **a field is a
contract with everything that writes it, not just with the node that named it.**

**And the boss-immunity exception is where to put a thing, not what to put there.** The obvious
implementation splices a condition into the `if` that refuses the status. Two suites pin that `if`
line as a literal, on purpose, because the boss rule is exactly the kind of promise a later batch
dissolves by widening one condition — so the obvious implementation would have moved the needle out
from under both tests while looking like a clean one-line change. Nested inside the refusal, both
literals survive and the exception reads better besides. **When a test pins a line, the line is
load-bearing prose as well as code.**

---

## Batch DV — why a lost feature is not dead code, and why a list can be a no-op

**The brief made a deletion conditional on its own provenance, and that condition is the whole
value of the section.** `CLASS_POOLS` presents as textbook dead code: 61 authored entries no run
can reach, with the file's own comment saying nothing reads them. The standing rule is that dead
code is deleted rather than zeroed, and applying it here would have been defensible and wrong.
**What separates the two cases is not visible in the structure — it is visible in what happened to
its READER.** Batch AH built an award that drew one card from the spec pool and two from the class
pool; Batch AN §4 re-pointed the award and deleted `roll_ability_offer` outright. So the pools are
not scaffolding that was never wired, they are **the surviving half of a feature that was
deliberately switched off**, and `test_batch_an` asserting the function *absent* is what makes that
checkable rather than remembered.

**The second reason not to delete is one the brief did not anticipate, and it only appears if you
ask what is reachable ONLY through the dead structure.** Of the 61 names, 27 are some spec's opening
kit and 27 sit in a live pool — but **seven are reachable nowhere else in the game**. Rallying
Shout, Mana Shield, Arcane Surge, Reality Fracture, Dawnbreak, Sanctuary and Divine Wrath are all
authored, all resolve, and all have handlers, chips and glossary prose; the dead pool is the only
list in the project that names them. Deleting the container would have deleted the record of the
contents, and nothing would have reported it. **A census of a dead structure should count what dies
with it, not only what it holds.**

**§3 is the other half of the same lesson, one layer down: a membership list is only a door where
the machinery behind it reaches the member's shape.** The brief said `ashes` joins `RECAST_GATED`,
which is the right instinct and the wrong mechanism — that system reasons about status writes, and
`ashes` writes an integer field. Driven live on an armed Mage, `_recast_targets` returns an empty
array and `_recast_refused` returns **false** with the phoenix fully armed. **The change would have
been a string in a table and nothing else**, and its one visible effect would have been `check_co`
listing the card as never exercised — which reads like coverage rather than like a no-op. The
honest place was a bespoke condition in `_ability_usable`, beside the ones Overcharge and
Preparation already use, which is the same door rather than a second path.

**And the exactness of that condition is not pedantry — the negative control shows it changing the
answer.** CO §1's rule is that refusing a cast which would have done something is strictly worse
than the waste being fixed. Written `ashes_return > 0` the refusal is one character shorter and
refuses a genuine 25→40 improvement; written `>= ASHES_RETURN_PERFECT` it does not. The two forms
agree in every state the game can currently produce, because `ASHES_RETURN` has no caller — **so
the difference between them is invisible today and the cheap version rots the day that changes.**

**What the bot knew that the door did not is a source worth mining and a source worth distrusting.**
The autoplay heuristic has refused an armed phoenix since BB, so the bot has been playing better
than the player was permitted to, and `check_co` could never have found it — it saturates the
members of the list, which measures the list rather than the candidates for it. Comparing the two
lists across the whole population turned up two more abilities whose entire payload is a status and
which are not gated (Mark of the Hunt, Intercession) and one narrow case under a talent (Deadfall
under Deadfall Network). **It also turned up four guards that look identical and are not**: the bot
refuses Hold Breath on a standing trance, but the handler also pays 40 Focus, so promoting that
guard into a refusal would have been the strictly-worse bug arriving through the fix for the first
one. **The bot tells you where to look; only the handler tells you what the condition is.**

**§4 is procedure rather than design, and the one thing worth recording is what the verification is
for.** The rule forbids asserting file sizes, and the reason is precise: sizes agreeing is entirely
consistent with a duplicated entry and a dropped one. So the assertion that matters is that the two
halves rejoin **byte-identical to the original**, checked by a second script reading untouched
backups rather than by the splitter checking its own arithmetic. The cut cost nothing beyond that,
and **the reason it cost nothing is CX's work rather than this batch's**: all fourteen
changelog-reading suites already anchor on their own `<h2>` heading and follow the archive path out
of the live file's own header, so a cut that moves eighteen entries re-points none of them.

**§5 is the one that changes what to distrust.** DU taught the corpus walk to apply the kit
overrides, and fifteen gates inherited the fix by doing nothing — but `test_batch_cp` carries its
own hand-rolled walk, so its literal-digit rule still cannot see any of the four abilities DU made
visible, nor the twelve spec-kit abilities that were never in a pool. It pins its population as
exactly `["Shatter"]`; run over the real corpus the answer is eight. **Nothing went red, because a
green equality over a short walk reads exactly like a green equality over the right one.** The rule
against hand-rolled walks exists and is enforced — it just sweeps gates, and matches the accessors
where this walk reads the constants. **An enforcement rule has a scope, and the scope is part of
the rule; the place a defect survives is the place nobody thought to point the instrument.**
