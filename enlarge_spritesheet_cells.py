#!/usr/bin/env python3

from PIL import Image
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("input")
parser.add_argument("output")
parser.add_argument("--tile-width", type=int, default=64)
parser.add_argument("--tile-height", type=int, default=64)
parser.add_argument("--scale-x", type=float, default=1.5)

args = parser.parse_args()

img = Image.open(args.input).convert("RGBA")

tw = args.tile_width
th = args.tile_height
sx = args.scale_x

cols = img.width // tw
rows = img.height // th

new_tw = int(round(tw * sx))

out = Image.new(
    "RGBA",
    (cols * new_tw, rows * th),
    (0, 0, 0, 0)
)

for row in range(rows):
    for col in range(cols):
        x = col * tw
        y = row * th

        tile = img.crop((x, y, x + tw, y + th))

        tile = tile.resize(
            (new_tw, th),
            Image.Resampling.NEAREST
        )

        out.paste(tile, (col * new_tw, row * th))

out.save(args.output)
print(f"Saved {args.output}")