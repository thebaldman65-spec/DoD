#!/usr/bin/env python3
"""THE CLAUDE.md CITATION CENSUS — committed at Batch EF §1.

WHY THIS FILE EXISTS.  EC measured it, ED re-derived it and EE rebuilt it, and
three batches quoted "33.3% of `CLAUDE.md` is neither asserted nor quoted" off an
instrument that lived in a scratchpad.  **A number quoted from one document into
another stops being a measurement** (DJ §3) — and a number whose script was never
committed was never one to begin with.  This is EE's rebuild, committed, with its
definitions stated HERE rather than in the head of whoever last ran it.

    python3 claude_md_census.py                       # the working tree
    python3 claude_md_census.py --rev 0b1c9e2         # any commit, read through git
    python3 claude_md_census.py --sweep 14,18,22,26   # the quotation length swept
    python3 claude_md_census.py --exclude docs/state.md --list neither

THE DEFINITIONS.  Every one of them is a choice, and a census whose definitions
live only in the head of whoever ran it is the same defect as one with no script.

  THE SYNC SET       Every TRACKED file outside `assets/` whose extension is one
                     of `.gd .md .json .html .sh .py`.  That is the definition —
                     recovered by search, because nothing in the repo stated it —
                     which reproduces both of ED's file counts and both of its
                     byte totals: 164 files / 7.23 MiB at EC, 168 / 7.60 at ED.

  A BLOCK            The preamble, then one block per level-2 or level-3 markdown
                     heading.  Blocks PARTITION the file: every character is in
                     exactly one, which is asserted on every run.  The count is a
                     property of the tree — 94 at EC, 96 at ED, 97 at EE.

  ASSERTED           A block holding the located occurrence of a literal that a
                     suite or gate pins POSITIVELY into `CLAUDE.md`.  The needles
                     come from `pin-manifest.json` when it exists (ED §2's
                     manifest, the one authority), and from this file's own
                     extractor when it does not — see --needles.  A needle is
                     located by first occurrence, case-sensitively, falling back
                     to case-blind because two alternation siblings and one
                     `to_lower()` holder are written in the file's other case.
                     **A needle that resolves nowhere locates nothing** and is
                     reported rather than dropped silently.

  QUOTED             A block sharing a WINDOW-word normalised span with some
                     other file in the sync set.  Normalisation drops markdown
                     emphasis and collapses whitespace, so a quotation survives
                     rewrapping and re-emphasis but not rewording.  WINDOW is the
                     one free parameter and there is no principled value for it,
                     so it is SWEPT rather than chosen; 22 is EE's reading.

  NEITHER            The rest.  **NEVER-QUOTED IS NOT DEAD** — nobody quotes the
                     rule they are obeying, so a well-obeyed rule and a dead one
                     produce identical evidence here.  ED read all 43 and retired
                     none.  Do not prune this file by this number.

  THE CORPUS         `docs/state.md` is EXCLUDED by default (EE §2): it is
                     rewritten every batch, so a block's category would otherwise
                     depend on what the last rewrite happened to say, and one
                     block changed category between EC and ED with nobody
                     touching it.  `--exclude` takes more; `--no-exclude` takes
                     none, which is what reproduces the pre-EE readings.

THE DISCREPANCY THIS SCRIPT DOES NOT HIDE.  ED reported **24** blocks asserted
where this reads **22**, and the two are not measured on the same footing: ED's
figure is EC's tree (94 blocks) read with ED's own needle extractor, because
`pin-manifest.json` did not exist yet; this script's default at ED's tree (96
blocks) reads the manifest.  `--needles extractor` and `--rev` reproduce either
side, so the difference is inspectable rather than argued about.  Everything else
agrees exactly: the segmentation, the sync set, and the 57 distinct needles.
"""
import argparse, collections, os, re, subprocess, sys

SYNC_EXT = (".gd", ".md", ".json", ".html", ".sh", ".py")
GUIDE = "CLAUDE.md"


# ── the tree, either the working copy or any commit ─────────────────────────
class Tree:
	def __init__(self, root=".", rev=None):
		self.root, self.rev = root, rev

	def _git(self, *args):
		r = subprocess.run(["git", "-C", self.root] + list(args),
		                   capture_output=True, text=True)
		return r.stdout if r.returncode == 0 else ""

	def files(self):
		if self.rev:
			names = self._git("ls-tree", "-r", "--name-only", self.rev).split("\n")
		else:
			names = self._git("ls-files").split("\n")
		if not any(names):			# not a repo: fall back to a walk
			names = []
			for dp, dn, fn in os.walk(self.root):
				dn[:] = [d for d in dn if d not in (".git", ".godot", "assets")]
				for f in fn:
					names.append(os.path.relpath(os.path.join(dp, f), self.root))
		return sorted(n for n in names
		              if n and not n.startswith("assets/") and n.endswith(SYNC_EXT))

	def read(self, path):
		if self.rev:
			return self._git("show", "%s:%s" % (self.rev, path))
		p = os.path.join(self.root, path)
		if not os.path.isfile(p):
			return ""
		return open(p, encoding="utf-8", errors="replace").read()


# ── the segmentation, asserted to partition the file ────────────────────────
def blocks_of(text):
	lines = text.split("\n")
	idx = [i for i, l in enumerate(lines) if re.match(r"^#{2,3} ", l)]
	cuts = [0] + idx + [len(lines)]
	out, pos = [], 0
	for a, b in zip(cuts, cuts[1:]):
		body = "\n".join(lines[a:b]) + ("\n" if b < len(lines) else "")
		head = lines[a].strip() if re.match(r"^#{2,3} ", lines[a]) else "(preamble)"
		out.append({"head": head, "chars": len(body), "start": pos, "end": pos + len(body)})
		pos += len(body)
	assert pos == len(text), "the segmentation is not a partition"
	return out


EMPH = re.compile(r"[*`>#\[\]|]")
WORD = re.compile(r"\S+")


def norm(s):
	return re.sub(r"\s+", " ", EMPH.sub(" ", s)).strip()


def grams(s, w):
	t = WORD.findall(s)
	return {" ".join(t[i:i + w]) for i in range(len(t) - w + 1)}


# ── the needles ─────────────────────────────────────────────────────────────
def needles_from_manifest(tree):
	import json
	raw = tree.read("pin-manifest.json")
	if not raw:
		return None
	pins = json.loads(raw)["pins"]
	return sorted({p["n"] for p in pins
	               if p["h"] == GUIDE and p["p"] == "+" and p["n"]})


def needles_from_source(tree):
	"""THE FALLBACK, for a tree with no manifest. Every literal tested against a
	holder ASSIGNED from `res://CLAUDE.md` — the variable, not the literal, which
	is DZ §3's lesson: a needle can sit three hundred lines below its read."""
	out = set()
	for f in tree.files():
		if "/" in f or not f.endswith(".gd"):
			continue
		src = tree.read(f)
		holders = set(re.findall(
			r"var\s+([A-Za-z_]\w*)\s*:?=[^\n]*res://CLAUDE\.md", src))
		for h in holders:
			for m in re.finditer(
					re.escape(h) + r"(?:\.to_lower\(\))?\.(?:contains|containsn|find|rfind|"
					r"begins_with|ends_with|count)\(\s*(\"(?:[^\"\\]|\\.)*\")", src):
				lit = m.group(1)[1:-1].replace('\\"', '"').replace("\\n", "\n")
				if lit:
					out.add(lit)
	return sorted(out)


def main():
	ap = argparse.ArgumentParser()
	ap.add_argument("--root", default=".")
	ap.add_argument("--rev", default=None, help="any commit-ish; read through git")
	ap.add_argument("--window", type=int, default=22, help="quotation length in words")
	ap.add_argument("--sweep", default=None, help="comma-separated windows to sweep")
	ap.add_argument("--needles", choices=("manifest", "extractor"), default="manifest")
	ap.add_argument("--exclude", action="append", default=None,
	                help="drop a file from the QUOTING corpus (repeatable)")
	ap.add_argument("--no-exclude", action="store_true",
	                help="quote against every sync file, including docs/state.md")
	ap.add_argument("--list", dest="listcat",
	                choices=("asserted", "quoted", "neither"), default=None)
	args = ap.parse_args()

	tree = Tree(args.root, args.rev)
	guide = tree.read(GUIDE)
	if not guide:
		sys.exit("no %s at %s" % (GUIDE, args.rev or "the working tree"))
	blks = blocks_of(guide)
	files = tree.files()

	excl = set() if args.no_exclude else set(args.exclude or ["docs/state.md"])

	needles = None
	if args.needles == "manifest":
		needles = needles_from_manifest(tree)
		if needles is None:
			print("no pin-manifest.json here — falling back to the source extractor")
	if needles is None:
		needles = needles_from_source(tree)

	gl = guide.lower()
	asserted, located, lost = set(), 0, []
	for n in needles:
		at = guide.find(n)
		if at < 0:
			at = gl.find(n.lower())
		if at < 0:
			lost.append(n)
			continue
		located += 1
		for j, b in enumerate(blks):
			if b["start"] <= at < b["end"]:
				asserted.add(j)
				break

	corpus = [f for f in files if f != GUIDE and f not in excl]
	texts = {f: norm(tree.read(f)) for f in corpus}
	total = sum(b["chars"] for b in blks)
	windows = [int(x) for x in args.sweep.split(",")] if args.sweep else [args.window]

	sync_bytes = sum(len(tree.read(f).encode("utf-8")) for f in files)
	print("rev=%s  files=%d  sync=%d B = %.4f MiB"
	      % (args.rev or "working tree", len(files), sync_bytes, sync_bytes / 1048576.0))
	print("%s: %d B = %.2f KiB  blocks=%d  chars=%d  needles=%d located=%d unlocated=%d"
	      % (GUIDE, len(guide.encode("utf-8")), len(guide.encode("utf-8")) / 1024.0,
	         len(blks), total, len(needles), located, len(lost)))
	print("needles=%s  excluded from the quoting corpus: %s"
	      % (args.needles, ", ".join(sorted(excl)) or "nothing"))
	print("%4s | %8s %8s %8s | %9s %7s" % ("win", "asserted", "quoted", "neither",
	                                       "chars n", "share"))
	last = None
	for w in windows:
		index = collections.defaultdict(set)
		for f, c in texts.items():
			for g in grams(c, w):
				index[g].add(f)
		cat, quoters = {}, {}
		for j, b in enumerate(blks):
			if j in asserted:
				cat[j] = "asserted"
				continue
			hits = grams(norm(guide[b["start"]:b["end"]]), w) & index.keys()
			if hits:
				cat[j] = "quoted"
				quoters[j] = sorted({f for h in hits for f in index[h]})
			else:
				cat[j] = "neither"
		t = collections.Counter(cat.values())
		ch = collections.Counter()
		for j, b in enumerate(blks):
			ch[cat[j]] += b["chars"]
		print("%4d | %8d %8d %8d | %9d %6.1f%%"
		      % (w, t["asserted"], t["quoted"], t["neither"],
		         ch["neither"], 100.0 * ch["neither"] / total))
		last = (cat, quoters)
	if lost:
		print("\n%d needles resolve nowhere in %s and locate no block:" % (len(lost), GUIDE))
		for n in lost:
			print("   %r" % n[:70])
	if args.listcat and last:
		cat, quoters = last
		print("\n--- %s, at window %d ---" % (args.listcat, windows[-1]))
		for j, b in enumerate(blks):
			if cat[j] == args.listcat:
				print("  [%2d] %6d  %s  %s"
				      % (j, b["chars"], b["head"][:76],
				         ",".join(quoters.get(j, []))[:60]))


if __name__ == "__main__":
	main()
