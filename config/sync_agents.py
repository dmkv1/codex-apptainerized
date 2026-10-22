"""Installs the lab AGENTS.md, or refreshes its managed block while keeping the user's notes."""
import os
import re
import sys

src, dst = sys.argv[1], sys.argv[2]
template = open(src).read()

if not os.path.exists(dst):
    open(dst, "w").write(template)
    sys.exit(0)

block = re.compile(r"<!-- BEGIN lab defaults.*?<!-- END lab defaults -->", re.S)
current = open(dst).read()
# A file without the markers is fully user-managed and left as is
if block.search(current):
    managed = block.search(template).group(0)
    updated = block.sub(lambda _: managed, current, count=1)
    if updated != current:
        open(dst, "w").write(updated)
