# Design Notes

Why things are the way they are. master.html holds current truth,
changelog.html holds what changed, this holds *why*. Newest first.
Not exported to docx.

## Blood Price (Batch B) — 2026-07-27

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
