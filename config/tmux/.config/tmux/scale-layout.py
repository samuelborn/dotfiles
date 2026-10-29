#!/usr/bin/env python3
"""Keep pane size ratios when a tmux window is resized.

tmux spreads a size change evenly over the panes, so ratios drift. Run on the
window-layout-changed and window-resized hooks with the window id:

- Same size as last seen: the user changed the layout; remember it as the reference.
- Other size: the window was resized; scale the reference to the new size and apply it.
"""

import re
import subprocess
import sys


def tmux(*args):
    return subprocess.run(["tmux", *args], capture_output=True, text=True).stdout.rstrip("\n")


def parse(s, i=0):
    """Parse one layout cell at s[i:]; returns (cell, next index)."""
    m = re.compile(r"(\d+)x(\d+),(\d+),(\d+)").match(s, i)
    cell = {"w": int(m[1]), "h": int(m[2])}
    i = m.end()
    if s[i] == ",":  # leaf: ",<pane id>"
        m = re.compile(r",(\d+)").match(s, i)
        cell["pane"] = m[1]
        return cell, m.end()
    cell["split"] = s[i]  # "{" left-right, "[" top-bottom
    close = "}" if s[i] == "{" else "]"
    cell["kids"] = []
    i += 1
    while True:
        kid, i = parse(s, i)
        cell["kids"].append(kid)
        if s[i] == close:
            return cell, i + 1
        i += 1  # ","


def panes(cell):
    if "pane" in cell:
        return {cell["pane"]}
    return set().union(*(panes(k) for k in cell["kids"]))


def min_size(cell, axis):
    """Smallest size along axis ("w"/"h") the cell can have: 1 per pane plus borders."""
    if "pane" in cell:
        return 1
    sizes = [min_size(k, axis) for k in cell["kids"]]
    along = (cell["split"] == "{") == (axis == "w")
    return sum(sizes) + len(sizes) - 1 if along else max(sizes)


def scale(cell, w, h):
    """Resize cell to w x h, splitting space between children by their old ratio."""
    if "pane" not in cell:
        axis = "w" if cell["split"] == "{" else "h"
        kids = cell["kids"]
        new_total = (w if axis == "w" else h) - (len(kids) - 1)  # minus borders
        old_total = sum(k[axis] for k in kids)
        mins = [min_size(k, axis) for k in kids]
        # Cumulative rounding so the sizes add up exactly
        sizes, acc, prev = [], 0, 0
        for k in kids:
            acc += k[axis]
            end = round(acc * new_total / old_total)
            sizes.append(end - prev)
            prev = end
        # Grow panes below their minimum, taking the space from the largest
        for n, m in enumerate(mins):
            while sizes[n] < m:
                big = max(range(len(sizes)), key=lambda j: sizes[j] - mins[j])
                if sizes[big] <= mins[big]:
                    break
                sizes[big] -= 1
                sizes[n] += 1
        for k, size in zip(kids, sizes):
            scale(k, size if axis == "w" else w, size if axis == "h" else h)
    cell["w"], cell["h"] = w, h


def dump(cell, x=0, y=0):
    out = f"{cell['w']}x{cell['h']},{x},{y}"
    if "pane" in cell:
        return out + "," + cell["pane"]
    parts = []
    for k in cell["kids"]:
        parts.append(dump(k, x, y))
        if cell["split"] == "{":
            x += k["w"] + 1
        else:
            y += k["h"] + 1
    close = "}" if cell["split"] == "{" else "]"
    return out + cell["split"] + ",".join(parts) + close


def checksum(body):
    csum = 0
    for c in body.encode():
        csum = ((csum >> 1) + ((csum & 1) << 15) + c) & 0xFFFF
    return f"{csum:04x},{body}"


def body(layout):
    return layout.split(",", 1)[1]


def size(layout):
    return re.match(r"(\d+x\d+)", body(layout))[1]


def main():
    win = sys.argv[1]
    current, zoomed, ref, last = tmux(
        "display", "-p", "-t", win,
        "#{window_layout}\t#{window_zoomed_flag}\t#{@layout_ref}\t#{@layout_last}",
    ).split("\t")
    if zoomed == "1":
        return
    if not ref or not last or size(current) == size(last):
        if current != last:
            tmux("set", "-w", "-t", win, "@layout_ref", current)
            tmux("set", "-w", "-t", win, "@layout_last", current)
        return
    root, _ = parse(body(ref))
    w, h = map(int, size(current).split("x"))
    # Skip if the panes changed without a layout event, or the window is too small
    if (
        panes(root) != panes(parse(body(current))[0])
        or w < min_size(root, "w")
        or h < min_size(root, "h")
    ):
        tmux("set", "-w", "-t", win, "@layout_ref", current)
        tmux("set", "-w", "-t", win, "@layout_last", current)
        return
    scale(root, w, h)
    new = checksum(dump(root))
    tmux("set", "-w", "-t", win, "@layout_last", new)
    if body(new) != body(current):
        tmux("select-layout", "-t", win, new)


if __name__ == "__main__":
    main()
