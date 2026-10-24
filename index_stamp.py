#!/usr/bin/env python3
"""THE INDEX's STAMPS (IT §5) — every entry of `docs/state.md`'s index carries the stamp of the block it names: `#` and the
first six hex digits of the md5 of the block's text (its heading line through the line before the next `## `/`### `
heading, read below the index's closing fence; whitespace runs collapsed to one space, the ends stripped). `check_it` §5
reds on an entry whose block changed under it — A BATCH THAT AMENDS A BLOCK AMENDS ITS INDEX ROW IN THE SAME BATCH.

    python3 index_stamp.py docs/state.md            # list the entries whose stamp is missing or stale
    python3 index_stamp.py docs/state.md --write    # (re)stamp them, after re-reading each row against its block

The stamp proves a row was touched when its block changed; that the row's label and triggers were re-read is the batch's."""
import hashlib, re, sys

FENCE_OPEN = '<!-- INDEX:BEGIN ('
FENCE_CLOSE = '<!-- INDEX:END -->'
WS = re.compile(r'[ \t\r\n]+')


def blocks(st):
    body = st[st.index('\n', st.index(FENCE_CLOSE)) + 1:]
    out, cur, buf = {}, None, []
    for line in body.split('\n'):
        if line.startswith('## ') or line.startswith('### '):
            if cur is not None:
                out[cur] = '\n'.join(buf)
            h = line.strip()
            at = h.find(' — ')
            cur, buf = (h[:at] if at > 0 else h).strip(), [line]
        elif cur is not None:
            buf.append(line)
    if cur is not None:
        out[cur] = '\n'.join(buf)
    return out


def stamp(text):
    return hashlib.md5(WS.sub(' ', text).strip().encode('utf-8')).hexdigest()[:6]


def entry_key(line):  # gate_fixture.index_entry_key, the same reading
    if not line.startswith('- '):
        return ''
    a = line.find('`` #')
    if a < 0:
        return ''
    b = line.find(' ``', a + 3)
    return line[a + 3:b].strip() if b > a else ''


def main():
    path = sys.argv[1]
    st = open(path, encoding='utf-8').read()
    a, b = st.index(FENCE_OPEN), st.index(FENCE_CLOSE)
    bl = blocks(st)
    idx = st[a:b].split('\n')
    stale, n = [], 0
    for k, line in enumerate(idx):
        key = entry_key(line)
        if not key:
            continue
        n += 1
        close = line.find(' ``', line.find('`` #') + 3)
        head, rest = line[:close + 3], line[close + 3:]
        old = re.match(r' `#[0-9a-f]{6}`', rest)
        tail = rest[old.end():] if old else rest
        if key not in bl:
            stale.append(('NO BLOCK', key))
            continue
        want = ' `#%s`' % stamp(bl[key])
        if (old.group(0) if old else None) != want:
            stale.append(('STALE' if old else 'UNSTAMPED', key))
            idx[k] = head + want + tail
    if '--write' in sys.argv:
        open(path, 'w', encoding='utf-8').write(st[:a] + '\n'.join(idx) + st[b:])
    print('%d entries; %d %s' % (n, len(stale), 'stamped' if '--write' in sys.argv else 'missing or stale'))
    for s in stale:
        print('  %s: %s' % s)
    return 0


if __name__ == '__main__':
    sys.exit(main())
