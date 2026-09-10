#!/bin/zsh
# BATCH CP — THE BATTERY, AS A SCRIPT IN THE REPO.
#
# It was reconstructed by hand every batch until now, and CLAUDE.md carries
# three separate scars from that: a flags STRING that zsh would not word-split
# (test_batch_bl silently under-ran), a `grep -E "checks,"` that missed every
# suite printing "N checks / M failures" without a comma, and a `^  FAIL:`
# grep that swallowed the one suite whose failure lines carry no indent.
# All three fixes are baked in here so they cannot be un-learned again.
#
#   ./run_battery.sh            -> every suite + every gate, one line each
#   ./run_battery.sh bo bp      -> only the named suites
#
# THE THROW COUNT IS REPORTED BESIDE THE CHECK COUNT AND IS NOT OPTIONAL:
# CD found seven SCRIPT ERRORs hiding 2,714 assertions behind suites that
# printed zero failures. A suite that throws is not a suite that passed.
cd "$(dirname "$0")"
GODOT=/Applications/Godot.app/Contents/MacOS/Godot
OUT=${DOD_BATTERY_OUT:-/tmp/dod_battery}

# TWO BATTERIES WRITING ONE LOG DIRECTORY IS A SILENT DATA FAULT, AND CP HIT IT.
# Killing a HUNG SUITE's Godot does not kill the battery that spawned it — the
# script simply moves to the next suite — so a second invocation ran alongside
# the first, both writing `$OUT`, and every count became whichever process
# finished last. Nothing errored and the report looked ordinary.
# The lock makes the second invocation refuse instead.
LOCK="$OUT/.battery.lock"
mkdir -p "$OUT"
if ! mkdir "$LOCK" 2>/dev/null; then
  echo "REFUSING: a battery is already writing $OUT (lock: $LOCK)."
  echo "If that is stale, remove it and re-run."
  exit 1
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM

# BATCH DE — WHAT THIS RUN ACTUALLY RAN, WRITTEN DOWN AS IT GOES.
# The count differ is a post-pass over these logs now (`check_de.gd`), and
# THIS SCRIPT DOES NOT CLEAR $OUT BETWEEN RUNS — so a target that failed to
# launch would otherwise be blessed by its PREVIOUS run's log, which is the
# one fault a count-differ must never commit. A name lands here immediately
# before its target is launched, and `run_one` truncates the log at spawn, so
# a log named in the manifest is always this run's. A subset invocation
# (`./run_battery.sh bo bp`) writes a short manifest and the differ says so
# rather than reporting a clean tree.
RAN="$OUT/.ran"
: > "$RAN"

# Suite -> extra flags. zsh does NOT word-split an unquoted string expansion,
# so flags live in an ARRAY and are expanded "${(@)...}" or the flag arrives
# as one token and is rejected.
typeset -A EXTRA
EXTRA[test_batch_bl]="--fixed-fps 12"

SUITES=(
  test_batch_ah test_batch_ah_battle test_batch_ai test_batch_aj test_batch_ak
  test_batch_al test_batch_an test_batch_ar test_batch_as test_batch_at
  test_batch_au test_batch_av test_batch_aw test_batch_ax test_batch_ay
  test_batch_az test_batch_ba test_batch_bb test_batch_bc test_batch_bd
  test_batch_be test_batch_bf test_batch_bg test_batch_bh test_batch_bi
  test_batch_bj test_batch_bk test_batch_bl test_batch_bm test_batch_bn
  test_batch_bo test_batch_bp test_batch_bq test_batch_br test_batch_bs
  test_batch_bt test_batch_bu test_batch_bv test_batch_bw test_batch_bx
  test_batch_cb test_batch_cd test_batch_ce test_batch_cp
  test_runes test_rune_battle
)
GATES=(check_parse check_flow check_map check_cl_resolver check_cl_width
       check_cm check_cm_live check_cn check_co check_cs check_ct check_cy
       check_cz check_da check_di check_dj check_dk check_dl check_dm check_do
       check_dp check_dr check_ds check_du check_dv check_dw check_ea check_eb
       check_ec check_ed check_eg check_eh check_ek check_el check_em
       check_es check_et check_eu check_ev check_ew check_ez check_fd
       check_fe check_ff check_fg check_fh check_fi check_fk check_fm check_fn
       check_fo check_fq check_fr check_fs)

[[ $# -gt 0 ]] && { SUITES=(); for a in "$@"; do SUITES+=("test_batch_$a"); done }

# A WATCHDOG, BECAUSE A HUNG SUITE IS WORSE THAN A FAILING ONE AND BATCH CP
# FOUND ONE. `test_batch_al` stops producing output and sits at ~0% CPU
# forever; run without a bound it takes the whole battery with it, and the
# report never prints — so every count after it is missing rather than wrong,
# which is the one failure mode a count-diffing rule cannot see.
# macOS ships no `timeout`, so this is the watchdog written out: run detached,
# poll, kill on expiry, and REPORT THE TIMEOUT AS ITS OWN OUTCOME rather than
# letting it read as a suite with no count.
TIMEOUT=${DOD_SUITE_TIMEOUT:-240}

# BATCH CQ §1 — A PER-TARGET BOUND, BECAUSE "TIMED OUT" AND "HUNG" ARE NOT THE
# SAME OUTCOME AND THE WATCHDOG COULD NOT TELL THEM APART. `check_map` was
# reported as `*** TIMED OUT after 240s ***` on EVERY run including unmodified
# HEAD, which reads exactly like the four suites that genuinely deadlocked.
# It is not hung: it runs at **99% CPU for about five minutes** and then
# finishes and prints its distributions — it walks 1,500 generated maps across
# four routing policies, and that is simply what that costs. CLAUDE.md's
# hang taxonomy says CHECK CPU FIRST and it is right: ~1-2% is a deadlock or
# the idle throttle, 30-50% with a growing log is TextServer exhaustion, and
# 99% with no output is a gate doing its job slowly. Raising the GLOBAL bound
# would have blunted the watchdog for everything else, so the bound is
# per-target, the same shape `EXTRA` already uses for flags.
typeset -A TMO
TMO[check_map]=600

# BATCH FS §1 — A TRUNCATED TARGET MUST NOT READ LIKE A SILENT ONE.
#
# `--quit-after N` IS FRAMES, NOT SECONDS. FR ran a doc pre-check with
# `--quit-after 900` as a hang guard and three gates — check_cs, check_dk and
# check_dm — printed no summary line at all. The reading was very nearly
# recorded as "these three report no readable count", which is a REAL property
# of seven targets in this battery. They were being cut off mid-run.
#
# THE TWO OUTCOMES ARE INDISTINGUISHABLE FROM THE OUTSIDE, and that was
# measured rather than assumed: a truncated run and a complete one BOTH exit 0
# (FS ran check_cs both ways and diffed the codes), both print a short log, and
# neither says which happened. `checks=?` therefore meant two things, and on the
# class-merge branch — where 52 engine-bound targets go red for eight batches —
# a silent gate would be read as merge breakage rather than as the runner.
#
# THE MECHANISM IS A COMPLETION MARKER, AND IT IS THE ONE THE TABLE ALREADY
# HAD. `baselines.json` has carried an `expect` string per row since DE — a
# line that only a COMPLETE run prints — and it was set on exactly ONE row.
# It is now set on every row that reports no check count, `check_de` §1 asserts
# it, and `check_de` §2 REFUSES a no-count row that carries no marker, so a
# future no-count target cannot join the table silently. The same markers are
# read live here, so this run's own report says which of the two happened
# instead of printing `checks=?` for both.
#
# A COUNT IS ITS OWN MARKER: every counting target in this battery prints its
# tally in its FINAL summary, so a count present means the target reached its
# end. The list below is therefore only the targets that print no count at all,
# and it is DERIVED, not guessed — it is every row in `baselines.json` whose
# `checks` is null, and `check_de` §2 fails if the two populations disagree.
NO_COUNT=(check_cl_resolver check_cl_width check_cm check_cn check_flow
          check_map check_map_screen)

# AND THE FRAME BUDGET IS PER-TARGET RATHER THAN A SHARED LITERAL, WHICH IS THE
# OTHER HALF OF THE SAME FAULT. FR's pre-check cut three gates at a number
# chosen for a fourth. MEASURED AT FS by bisecting each one to +/-14 frames:
# check_cs completes at 1518, check_dk at 3614 and check_dm at 7115, and the
# boundary reproduces (check_cs was run twice on each side of it). So 900 was
# 59%, 25% and 13% of what the three of them actually needed.
#
# `check_ct_map` drives its own stages and quits itself; its budget is a hang
# guard and is the ONLY --quit-after in this battery. It lives here, beside the
# target it belongs to, in the same shape EXTRA and TMO already use.
typeset -A QAF
QAF[check_ct_map]=900

# THE TWO TARGETS THAT ARE SCENES RATHER THAN SCRIPTS. `check_parse` harvests
# every scene path in this file by pattern, so both stay written out in full
# here rather than being assembled from $name — a path this script builds at run
# time is a target that gate cannot see. (And the first draft of this comment
# spelled the pattern out with a placeholder name, which that same gate then
# read as a battery target and reported MISSING. A comment naming the string a
# gate matches is an asserted surface.) Both get the same watchdog and the same
# completion test as everything else now.
typeset -A SCENE
SCENE[check_map_screen]="res://check_map_screen.tscn"
SCENE[check_ct_map]="res://check_ct_map.tscn"
TMO[check_map_screen]=600
TMO[check_ct_map]=600
# BATCH DE — `TMO[test_batch_cd]=2400` IS GONE AND SO IS THE REASON FOR IT.
# DD gave that suite a 2400s bound because its §1 spawned forty-five child
# Godots — it ran the battery inside the battery, about 22 minutes of a run
# that had been 29.6. The differ is a post-pass over this script's own logs
# now (`check_de.gd`, baselines in `baselines.json`), so nothing in SUITES
# spawns a suite and the default 240s bound covers the lot again.

run_one() {
  local name=$1 log="$OUT/$1.log"
  echo "$name" >> "$RAN"
  local -a flags
  flags=(${=EXTRA[$name]})
  # BATCH FS — THE FRAME BUDGET TRAVELS WITH THE TARGET. It used to be an inline
  # literal on one line of this script; a budget written beside one target and
  # applied to another is how FR cut three gates at a number chosen for a fourth.
  [[ -n ${QAF[$name]} ]] && flags+=(--quit-after ${QAF[$name]})
  local limit=${TMO[$name]:-$TIMEOUT}
  # BATCH FS — AND THE TWO SCENE RUNS COME THROUGH HERE NOW. They used to be
  # written out by hand below with no watchdog and no completion test at all,
  # which is why `check_ct_map` — the ONLY target in this battery under a frame
  # budget — was the one target that could be silently truncated. `--script` is
  # the default; a name in SCENE is launched as a scene instead.
  #
  # WRITTEN OUT LONG-HAND, BECAUSE THE SHORT FORM IS THIS FILE'S OLDEST SCAR.
  # `target=(${SCENE[$name]:---script $name.gd})` looks right and is not:
  # **zsh does not word-split an unquoted parameter expansion**, so the whole
  # default arrives as ONE token, Godot never sees a `--script` flag, and the
  # target sits until the watchdog kills it. That is the same fault the flags
  # STRING at the top of this file cost a battery for. It was reintroduced here
  # at FS and caught by FS's own truncation control, which is the only reason
  # this comment is not a third scar.
  local -a target
  if [[ -n ${SCENE[$name]} ]]; then
    target=("${SCENE[$name]}")
  else
    target=(--script "$name.gd")
  fi
  "$GODOT" --headless --path . "${flags[@]}" "${target[@]}" >"$log" 2>&1 &
  local pid=$! waited=0 timedout=0
  while kill -0 $pid 2>/dev/null; do
    if (( waited >= limit )); then
      kill -9 $pid 2>/dev/null; timedout=1; break
    fi
    sleep 2; (( waited += 2 ))
  done
  wait $pid 2>/dev/null
  # A count with no comma is still a count (BQ's lost grep), and a FAIL line
  # with no indent is still a failure (BK's swallowed reason).
  #
  # BATCH CS — AND A COUNT WITH A COLON IS STILL A COUNT. THIS IS THE THIRD TIME
  # THIS GREP HAS BEEN TOO NARROW. SEVEN SUITES READ `checks=?` — ai, bm, bn, bo,
  # bp, bq, br — and BATCH DD re-derived which shape each one prints, because the
  # sentence below has been read as "seven print the colon shape" ever since:
  # SIX print `checks: N   failures: N` (bm..br) and TWO print
  # `BATCH XX: N passed, N FAILED` (ai, an); `[0-9]+ checks` matches
  # neither, so the report showed `checks=? fails=?` for ai, bm, bn, bo, bp, bq
  # and br — **every one of which CLAUDE.md pins with a number.** A count-diffing
  # rule cannot see a regression in a suite whose count reads `?`, which is the
  # same blind spot CP's watchdog exists to close, arriving through the parser
  # instead of through a hang. All three shapes are matched now.
  local checks=$(grep -oE '([0-9]+ (checks|passed))|(checks: *[0-9]+)' "$log" \
    | tail -1 | grep -oE '[0-9]+')
  local fails=$(grep -oiE '([0-9]+ (failures|failed))|((failures|failed): *[0-9]+)' "$log" \
    | tail -1 | grep -oE '[0-9]+')
  local throws=$(grep -cE 'SCRIPT ERROR|Parse Error' "$log")
  local faillines=$(grep -cE '^ *FAIL' "$log")
  # BATCH FS — THE THREE OUTCOMES, AND `checks=?` IS NO LONGER ONE OF THEM.
  # A target is COMPLETE if it printed a count (every counting target prints
  # its tally last) or, for a target that prints none by design, if it printed
  # its own `name:` end marker. Anything else was CUT OFF, and says so.
  local marker=0
  grep -qE "^$name: " "$log" && marker=1
  local by_design=0
  (( ${NO_COUNT[(I)$name]} )) && by_design=1
  if (( timedout )); then
    printf '%-22s *** TIMED OUT after %ss *** (no count; %s log lines)\n' \
      "$name" "$limit" "$(wc -l < "$log" | tr -d ' ')"
  elif [[ -z "$checks" && $marker -eq 0 ]]; then
    # NOT SILENT — INCOMPLETE. It printed no tally and never reached the end
    # marker, so it did not finish. If it was running under a frame budget,
    # that budget is the first thing to raise.
    printf '%-22s *** NO VERDICT — INCOMPLETE: no count and no `%s:` end marker (%s log lines%s) ***\n' \
      "$name" "$name" "$(wc -l < "$log" | tr -d ' ')" \
      "${QAF[$name]:+, --quit-after ${QAF[$name]} FRAMES}"
  elif [[ -z "$checks" ]]; then
    printf '%-22s checks=%-6s fails=%-4s throws=%-3s FAILlines=%-4s %s\n' \
      "$name" "none" "${fails:-none}" "$throws" "$faillines" \
      "$( (( by_design )) && echo 'COMPLETE (prints no count by design)' \
          || echo 'COMPLETE but prints NO COUNT and has no baselines.json row saying so' )"
  else
    printf '%-22s checks=%-6s fails=%-4s throws=%-3s FAILlines=%s\n' \
      "$name" "$checks" "${fails:-?}" "$throws" "$faillines"
  fi
}

echo "=== SUITES ==="
for s in $SUITES; do run_one $s; done
echo "=== GATES ==="
for g in $GATES; do run_one $g; done
echo "=== RUN HARNESS (gates 1/2/3 — live counts 22/166/8) ==="
for n in 1 2 3; do
  echo "harness_$n" >> "$RAN"
  DOD_GATE=$n "$GODOT" --headless --path . --script test_run_harness.gd \
    >"$OUT/harness_$n.log" 2>&1
  # BATCH FS — AND THE HARNESS OWES THE SAME ANSWER. Its verdict grep prints an
  # EMPTY field when the target did not reach its verdict, which read as a gate
  # with nothing to say. An empty verdict is now named as an incomplete run.
  hv=$(grep -oE 'GATE [0-9] (PASS|FAIL)[^)]*\)?' "$OUT/harness_$n.log" | tail -1)
  printf 'GATE %s  %s  throws=%s\n' "$n" \
    "${hv:-*** NO VERDICT — INCOMPLETE: never printed GATE $n PASS/FAIL ***}" \
    "$(grep -cE 'SCRIPT ERROR|Parse Error' "$OUT/harness_$n.log")"
done
echo "=== SCENE RUNS (autoloads do not resolve under --script) ==="
# BATCH CT: the pouch render gate. Measures every drawn button's rect against the
# 1280-wide viewport at 4, 5 and 6 slots — an off-screen button is a DRAW-time
# fact no parse gate and no source read can see, which is exactly how CT's brief
# came to assert that six buttons fit a row that holds five.
#
# BATCH FS — BOTH GO THROUGH `run_one` NOW. Written out by hand these two had no
# watchdog, no `$RAN` line written by the runner, and — for `check_ct_map`, the
# one target in this battery carrying a `--quit-after` — no way at all to tell a
# cut-off run from a finished one. Their scene paths and their budgets are in
# SCENE and QAF above.
for n in check_map_screen check_ct_map; do run_one $n; done
# BATCH DE — THE COUNT DIFFER, AND IT IS A PROPERTY OF THE RUN.
# It reads the logs above and `baselines.json`; it spawns nothing, so the
# nesting DD paid 20 minutes for is now structurally impossible rather than
# merely avoided. Its verdict is echoed here because it is this run's verdict
# — a FALL in a check count or a RISE in a failure count is the thing the
# battery exists to notice, and an aggregate hides both.
echo "=== THE COUNT DIFFER (post-pass over the logs above; spawns nothing) ==="
run_one check_de
grep -E '^(FAIL|NOTICE): ' "$OUT/check_de.log" || true
grep -E '^check_de: ' "$OUT/check_de.log"
echo "=== DONE. Logs in $OUT ==="
