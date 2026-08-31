#!/usr/bin/env python3
"""BATCH ED — THE SOURCE-PIN MANIFEST, DERIVED.

915 assertions pin a literal into a `.gd` source file; the four tracked
documents carry 196.  The document instruments have been watching the smaller
half by 4.7x, and a comment-only edit to `.gd` source changes a haystack
NEITHER of them reads — which is how EB reworded one sentence in `battle.gd`,
read green on both document sweeps and on a comment-stripped diff, and took
`test_batch_bl` red in the battery three hours later.

THIS FILE DERIVES THE MANIFEST.  `check_ed.gd` ENFORCES IT.  The split is
deliberate and it is the whole reason the manifest cannot go stale:

  * ATTRIBUTION needs holder propagation — a suite reads `battle.gd` in `_run()`
    and asserts on it 536 lines later inside a helper it passed the holder to —
    so working out WHICH file a literal is pinned into is a real analysis and it
    lives here, in one place, re-runnable.
  * ENFORCEMENT needs neither.  The gate re-reads every named haystack and asks
    whether the literal still resolves the way the manifest says, and separately
    demands that every literal written into a locator call in the tree HAS an
    entry.  Both halves are simple enough not to drift.

A MANIFEST THAT ONLY DESCRIBES THE DAY IT WAS WRITTEN IS THE FOURTH INSTANCE OF
THE COMMENT-OUTLIVING-ITS-SUBJECT SHAPE THIS PROJECT HAS PAID FOR.  What stops
this one is that nothing reads it as a description: `check_ed` re-derives both
halves every battery, so an entry that stops being true is RED and a pin that
arrives without an entry is RED.

  RESIDENCY, which is the field the batch after this one will care about:
    code    — the literal survives comment-stripping.  A rewording cannot move it.
    comment — it resolves ONLY inside a comment.  THESE ARE THE FRAGILE ONES.
    absent  — a negative pin, correctly not resolving.
    slice   — the haystack is a derived slice or a stripped copy; the whole-file
              question is not the one the suite asks, so it is recorded and NOT
              verified.  The gate reports how many it does not verify.
    runtime — composed at runtime; there is no static literal to pin.

  usage:  python3 build_pin_manifest.py           # rewrite pin-manifest.json
          python3 build_pin_manifest.py --check   # exit 1 if it would change
"""
import re, os, glob, json, sys

CALLS = r'(?:contains|containsn|begins_with|ends_with|count|find|rfind|findn)'
RES = re.compile(r'"(res://[^"]*)"')
FMT = re.compile(r'%[-0-9.]*[dsfxv%]')
DOCS = {"CLAUDE.md", "docs/master.html", "docs/changelog.html", "docs/design-notes.md"}

# THE GATE IS NOT A SUBJECT OF ITS OWN SWEEP.  `check_ed` holds the manifest's
# own vocabulary and every literal it names; leaving it in would have the
# instrument enumerate itself and grow the population on every run.
SELF = {"check_ed.gd"}


def strip_comments(src):
    out = []
    for line in src.split("\n"):
        res, i, q = [], 0, None
        while i < len(line):
            c = line[i]
            if q:
                res.append(c)
                if c == "\\" and i + 1 < len(line):
                    res.append(line[i + 1]); i += 1
                elif c == q:
                    q = None
            else:
                if c == "#":
                    break
                res.append(c)
                if c in "\"'":
                    q = c
            i += 1
        out.append("".join(res))
    return "\n".join(out)


# GDScript STRING LITERALS COME IN BOTH QUOTES, AND MASKING ONLY ONE IS A
# SILENT STATEMENT-MERGER. `rs.find('party.append({"key": key')` holds an
# unbalanced `(` and `{` inside a SINGLE-quoted string; masking only double
# quotes left them counted, depth never returned to zero, and the remaining
# sixty lines of that function joined into ONE statement — so every assertion
# after it fell inside the previous match window and twelve pins vanished.
# Comments are stripped before this runs, so an apostrophe in prose cannot
# reach here and open a spurious string.
_STR = r'"(?:[^"\\]|\\.)*"|\'(?:[^\'\\]|\\.)*\''


def _mask(s):
    return re.sub(_STR, '""', s)


def statements(src):
    stmts, buf, depth = [], "", 0
    for line in src.split("\n"):
        s = line.rstrip()
        cont = s.endswith("\\")
        if cont:
            s = s[:-1]
        buf += s + " "
        m = _mask(s)
        depth += m.count("(") + m.count("[") + m.count("{")
        depth -= m.count(")") + m.count("]") + m.count("}")
        depth = max(depth, 0)
        if cont or depth > 0:
            continue
        if buf.strip():
            stmts.append(buf)
        buf, depth = "", 0
    if buf.strip():
        stmts.append(buf)
    return stmts


_ESC = {"n": "\n", "t": "\t", "r": "\r", '"': '"', "'": "'", "\\": "\\", "0": "\0"}


def unescape(l):
    """ONE LEFT-TO-RIGHT PASS.  A chain of `replace`s runs `\\n` before `\\\\`, so
    a literal written `\\\\n` — the two raw characters a `.gd` description holds —
    comes out as a backslash and a real newline and matches nothing."""
    out, i = [], 0
    while i < len(l):
        if l[i] == "\\" and i + 1 < len(l):
            out.append(_ESC.get(l[i + 1], "\\" + l[i + 1])); i += 2
        else:
            out.append(l[i]); i += 1
    return "".join(out)


def negated(stmt, pos):
    """`not` may sit behind a RECEIVER, not only behind whitespace."""
    return bool(re.search(r'\bnot\s+[\w.\s]*$', stmt[:pos]))


def polarity(stmt, start, after):
    """A pin is written NEGATIVE in four shapes and only one uses the word `not`:
    `not src.contains(X)`, `src.count(X) == 0`, `src.find(X) < 0`, and an
    expectation argument `_check(..., src.contains(X), false)`.  Reading the last
    three as POSITIVE reports a deliberately-absent literal as a broken pin,
    which is how a clean tree grows a list of phantom defects."""
    if negated(stmt, start):
        return True
    tail = stmt[after:after + 40]
    if re.match(r'\s*\)?\s*(?:==\s*0|<\s*0|<=\s*-\s*1|==\s*-\s*1)', tail):
        return True
    if re.search(r',\s*false\s*\)\s*$', stmt.strip()):
        return True
    return False


def scan_file(path):
    """Every pin in one suite, with the file each is pinned INTO."""
    src = strip_comments(open(path, encoding="utf-8").read())
    lines = src.split("\n")
    fstart = [i for i, l in enumerate(lines) if l.startswith("func ")]
    regions = []
    if fstart and fstart[0] > 0:
        regions.append(("<class>", (), 0, fstart[0]))
    for n, a in enumerate(fstart):
        b = fstart[n + 1] if n + 1 < len(fstart) else len(lines)
        m = re.match(r'func\s+(\w+)\s*\(([^)]*)\)', lines[a])
        ps = []
        if m:
            for p in m.group(2).split(","):
                p = p.strip()
                if p:
                    ps.append(re.split(r'[:=]', p)[0].strip())
        regions.append((m.group(1) if m else "?", tuple(ps), a, b))
    text = {r: "\n".join(lines[r[2]:r[3]]) for r in regions}

    # HOLDERS ARE BOUND FROM STATEMENTS, NOT FROM LINES. `test_batch_cb` writes
    #     var src := _strip_comments(
    #             FileAccess.get_file_as_string("res://scripts/battle.gd"))
    # and a line-bounded `[^\n]*` never reaches the path, so `src` bound to
    # nothing and every pin in that function was invisible. Statements join the
    # continuation; the binding is read off the joined form.
    hold = {r: {} for r in regions}
    for r in regions:
        for st in statements(text[r]):
            for m in re.finditer(r'var\s+(\w+)\s*:?=\s*(.*)$', st):
                hit = RES.search(m.group(2))
                if hit:
                    hold[r][m.group(1)] = (
                        hit.group(1),
                        "stripped" if re.search(r'_code_of|_code_only|_strip|_nocomment',
                                                m.group(2)) else "read")
    for _ in range(4):
        for r in regions:
            for m in re.finditer(r'var\s+(\w+)\s*:?=\s*([^\n]*)', text[r]):
                name, tail = m.group(1), m.group(2)
                if name in hold[r]:
                    continue
                b = re.match(r'\s*(\w+)\s*\.\s*(?:substr|replace|split|to_lower|strip_edges)', tail)
                if b and b.group(1) in hold[r]:
                    hold[r][name] = (hold[r][b.group(1)][0], "derived")
            for m in re.finditer(r'^\s*(\w+)\s*\+=', text[r], re.M):
                nm = m.group(1)
                if nm in hold[r]:
                    hold[r][nm] = (hold[r][nm][0], "composed")
                else:
                    hit2 = None
                    for mm in re.finditer(r'^\s*' + re.escape(nm) + r'\s*\+=\s*([^\n]*)',
                                          text[r], re.M):
                        hit2 = RES.search(mm.group(1)) or hit2
                    if hit2:
                        hold[r][nm] = (hit2.group(1), "composed")
            for m in re.finditer(r'^\s*(\w+)\s*=\s*(\w+)\s*\.\s*'
                                 r'(?:substr|replace|split|to_lower|strip_edges)', text[r], re.M):
                if m.group(1) not in hold[r] and m.group(2) in hold[r]:
                    hold[r][m.group(1)] = (hold[r][m.group(2)][0], "derived")

    byname = {}
    for r in regions:
        byname.setdefault(r[0], []).append(r)
    for _ in range(6):
        grew = False
        for r in regions:
            for m in re.finditer(r'\b(\w+)\s*\(([^()]*)\)', text[r]):
                if m.group(1) not in byname:
                    continue
                args = [a.strip() for a in m.group(2).split(",")] if m.group(2).strip() else []
                for tgt in byname[m.group(1)]:
                    for i, a in enumerate(args):
                        if i < len(tgt[1]) and a in hold[r] and tgt[1][i] not in hold[tgt]:
                            hold[tgt][tgt[1][i]] = (hold[r][a][0], "param")
                            grew = True
        if not grew:
            break

    loops = {}
    for r in regions:
        loops[r] = {}
        for m in re.finditer(r'for\s+(\w+)\s+in\s+(\[[^\]]*\])', text[r], re.S):
            lits = [a or b for a, b in re.findall(
                r'"((?:[^"\\]|\\.)*)"|\'((?:[^\'\\]|\\.)*)\'', m.group(2))]
            lits = [x for x in lits if x]
            if lits:
                loops[r][m.group(1)] = lits

    pins = []
    stmt_id = 0
    for r in regions:
        for st in statements(text[r]):
            stmt_id += 1
            # AN ALTERNATION'S MEMBERS ARE NOT INDIVIDUALLY OWED. EC §1 ruled a
            # statement is a DISJUNCTION OF CONJUNCTIONS: in
            # `ok(src.contains(A) or src.contains(B), ...)` a member that does
            # not resolve is correct as long as a sibling does. Verifying each
            # member alone reds two live checks on this tree — `test_batch_bt`'s
            # `SYNERGY, ` and `test_batch_ay`'s Delirium control — so members
            # carry a GROUP and the group is what must hold.
            is_alt = re.search(r'\)\s+or\s+', _mask(st)) is not None
            for name, (respath, how) in hold[r].items():
                # THE ARGUMENT IS CAPTURED AS A TOKEN, NOT AS A 600-CHARACTER
                # WINDOW. A greedy tail makes `finditer` step over everything it
                # swallowed, so the SECOND member of
                # `ok(src.contains(A) and src.contains(B), ...)` fell inside the
                # first match and was never seen — eighty pins invisible, and
                # the same conjunction blindness EC §1 closed in the document
                # sweep, still open here.
                pat = (r'\b' + re.escape(name) + r'\b((?:\s*\.\s*\w+\s*\([^()]*\))*)'
                       r'\s*\.\s*(' + CALLS + r')\s*\(\s*(' + _STR + r'|[A-Za-z_]\w*)')
                for m in re.finditer(pat, st, re.S):
                    call, arg = m.group(2), m.group(3).strip()
                    hw = "slice" if re.search(
                        r'\.\s*(?:substr|replace|split|strip_edges)\s*\(', m.group(1)) else how
                    lm = re.match(_STR, arg)
                    if lm:
                        lit = unescape(lm.group(0)[1:-1])
                        after = m.start(3) + len(lm.group(0))
                        if FMT.search(lit):
                            # A FORMAT TEMPLATE IS NOT A NEEDLE, BUT IT IS STILL
                            # A PIN. `'"%s": [' % id` resolves to a different
                            # string on every iteration, so there is nothing to
                            # verify — DROPPING it, rather than recording it as
                            # runtime, lost seventeen pins from the population
                            # the manifest is measured against.
                            # THE TEMPLATE TEXT IS STILL RECORDED. `check_ed`'s
                            # completeness scan reads literals out of the source
                            # and asks the manifest about them; a template held
                            # only as an expression is a literal the gate can
                            # see and the manifest cannot answer for, and 113 of
                            # those would have reddened the gate on day one.
                            pins.append(dict(s=os.path.basename(path), fn=r[0],
                                             h=respath, how=hw, call=call,
                                             neg=polarity(st, m.start(), after),
                                             n=lit, expr=arg[:120],
                                             kind="format", g=stmt_id, alt=is_alt))
                            continue
                        neg = polarity(st, m.start(), after)
                        composed = bool(re.match(r'\s*\+', st[after:after + 6]) or
                                        re.search(r'\+\s*$', st[:m.start(3)]))
                        pins.append(dict(s=os.path.basename(path), fn=r[0], h=respath,
                                         how=hw, call=call, neg=neg, n=lit,
                                         kind="composed" if composed else "literal", g=stmt_id, alt=is_alt))
                    elif arg in loops[r]:
                        neg = polarity(st, m.start(), m.start(3) + len(arg))
                        for lit in loops[r][arg]:
                            lit = unescape(lit)
                            if FMT.search(lit):
                                continue
                            pins.append(dict(s=os.path.basename(path), fn=r[0], h=respath,
                                             how=hw, call=call, neg=neg, n=lit,
                                             kind="loop-list", g=stmt_id, alt=is_alt))
                    elif arg:
                        neg = polarity(st, m.start(), m.start(3) + len(arg))
                        pins.append(dict(s=os.path.basename(path), fn=r[0], h=respath,
                                         how=hw, call=call, neg=neg, n=None,
                                         expr=arg, kind="non-literal", g=stmt_id, alt=is_alt))
            # INLINE, WITH NO HOLDER AT ALL — `_src("res://x").contains("lit")`.
            # SIX OF THE `const CLASS_POOLS` ABSENCE PINS ARE WRITTEN THIS WAY,
            # one in each of six suites, and a holder-only sweep sees none of
            # them: there is no `var` to bind. Leaving this path out cost the
            # first build of this manifest eighteen static needles.
            for m in re.finditer(r'(?:get_file_as_string|_src|_read)\s*\(\s*"(res://[^"]*)"\s*\)'
                                 r'((?:\s*\.\s*\w+\s*\([^()]*\))*)\s*\.\s*(' + CALLS +
                                 r')\s*\(\s*"((?:[^"\\]|\\.)*)"', st):
                lit = unescape(m.group(4))
                if FMT.search(lit):
                    continue
                pins.append(dict(s=os.path.basename(path), fn=r[0], h=m.group(1),
                                 how="inline", call=m.group(3),
                                 neg=polarity(st, m.start(), m.end()),
                                 n=lit, kind="literal", g=stmt_id, alt=is_alt))
    return pins


def residency(pin, raw, stripped):
    """WHERE a literal actually lives, re-derived rather than declared.

    THE HOLDER'S SCOPE AND THE LITERAL'S RESIDENCY ARE TWO QUESTIONS AND AN
    EARLIER BUILD OF THIS ANSWERED ONLY THE FIRST.  Bailing out to "slice" for
    every derived holder under-reported comment-residency by eighteen — and
    comment-residency is the whole reason the manifest exists.  So scope is a
    SEPARATE field (`how`) and residency is always decided by asking the file.
    """
    # A COMPOSED NEEDLE IS A PREFIX, NOT A NEEDLE. `not bsrc.contains("." + dead)`
    # yields the literal `.` — testing THAT against the file asks a question no
    # suite asked, and it is what put two junk entries in the first build of
    # this manifest. Composed and non-literal alike have no static needle.
    if pin["n"] is None or pin["kind"] in ("non-literal", "composed", "format"):
        return "runtime"
    lit = pin["n"]
    if pin["neg"]:
        # PRESENT, yet asserted ABSENT: the suite's real haystack is NARROWER
        # than the file — a comment-stripped copy, a `substr` slice, or one
        # string segment of one line. The negative holds there and this sweep
        # cannot see there, so it is recorded, counted and NOT verified.
        return "absent" if lit not in raw else "narrow"
    if lit in stripped:
        return "code"
    if lit in raw:
        return "comment"
    # An alternation member that does not resolve is answered by its GROUP,
    # asserted below rather than here.
    return "alt-sibling" if pin.get("alt") else "unresolved"


def main():
    files = sorted(f for f in glob.glob("*.gd")
                   if os.path.basename(f).startswith(("check_", "test_"))
                   and os.path.basename(f) not in SELF)
    raws, strips = {}, {}

    def load(respath):
        p = respath.replace("res://", "")
        if p not in raws:
            # a `res://scripts/` DIRECTORY path is a holder for a walk, not a
            # file to read — it carries no literal and must not crash the sweep
            if os.path.isfile(p):
                raws[p] = open(p, encoding="utf-8", errors="replace").read()
                strips[p] = strip_comments(raws[p]) if p.endswith(".gd") else raws[p]
            else:
                raws[p] = strips[p] = None
        return raws[p], strips[p]

    out, counts, seen = [], {}, set()
    for f in files:
        for pin in scan_file(f):
            # THE SAME CLAIM WRITTEN TWICE IS ONE CLAIM. De-dup on what the pin
            # ASSERTS — file, haystack, call, polarity, needle, kind — and not
            # on where it sits, so a suite asserting one thing in two functions
            # does not inflate the population it is measured by.
            # A NON-LITERAL PIN IS IDENTIFIED BY ITS EXPRESSION, NOT BY THE
            # NULL NEEDLE IT HAS. Keying every one of them on `None` collapsed
            # fifty-six distinct claims into one and under-counted the
            # population by that much.
            key = (pin["s"], pin["h"], pin["call"], pin["neg"],
                   pin["n"] if pin["n"] is not None else pin.get("expr"),
                   pin["kind"])
            if key in seen:
                continue
            seen.add(key)
            hp = pin["h"].replace("res://", "")
            raw, stripped = load(pin["h"])
            pin["res"] = "missing-file" if raw is None else residency(pin, raw, stripped)
            rec = dict(s=pin["s"], fn=pin["fn"], h=hp, n=pin["n"],
                       p="-" if pin["neg"] else "+", r=pin["res"], k=pin["kind"],
                       how=pin["how"], g="%s#%d" % (pin["s"], pin["g"]))
            if pin.get("alt"):
                rec["alt"] = True
            if pin["n"] is None and pin.get("expr"):
                rec["expr"] = pin["expr"]
            out.append(rec)
            fam = ("document" if hp in DOCS else
                   "source" if hp.endswith(".gd") else "other")
            counts[fam] = counts.get(fam, 0) + 1

    out.sort(key=lambda r: (r["s"], r["fn"], r["n"] or "", r["h"]))
    src = [r for r in out if r["h"].endswith(".gd")]
    byres = {}
    for r in src:
        byres[r["r"]] = byres.get(r["r"], 0) + 1
    doc = {
        "note": ("Every literal a suite pins into a file, with the file it lives in. "
                 "DERIVED by build_pin_manifest.py; ENFORCED by check_ed.gd every battery. "
                 "Do not hand-edit: re-run the generator."),
        "generated_by": "build_pin_manifest.py",
        "counts": dict(total=len(out), **counts),
        "source_residency": byres,
        "pins": out,
    }
    js = json.dumps(doc, ensure_ascii=False, indent=1) + "\n"
    if "--check" in sys.argv:
        cur = open("pin-manifest.json", encoding="utf-8").read() if os.path.exists("pin-manifest.json") else ""
        if cur != js:
            print("pin-manifest.json is STALE — re-run build_pin_manifest.py")
            sys.exit(1)
        print("pin-manifest.json is current (%d pins)" % len(out))
        return
    open("pin-manifest.json", "w", encoding="utf-8").write(js)
    print("pin-manifest.json: %d pins  (%s)" % (len(out), counts))
    print("source residency:  %s" % byres)


if __name__ == "__main__":
    main()
