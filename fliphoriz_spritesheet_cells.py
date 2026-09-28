#!/usr/bin/env python3

from PIL import Image, ImageOps
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("input")
parser.add_argument("output")
parser.add_argument("--tile-width", type=int, default=64)
parser.add_argument("--tile-height", type=int, default=64)

args = parser.parse_args()

img = Image.open(args.input).convert("RGBA")

tw = args.tile_width
th = args.tile_height

cols = img.width // tw
rows = img.height // th

# Same size as the original spritesheet
out = Image.new(
    "RGBA",
    (cols * tw, rows * th),
    (0, 0, 0, 0)
)

for row in range(rows):
    for col in range(cols):
        x = col * tw
        y = row * th

        # Extract one frame
        tile = img.crop((x, y, x + tw, y + th))

        # Flip THIS frame horizontally
        tile = ImageOps.mirror(tile)

        # Put it back in the same position
        out.paste(tile, (x, y))

out.save(args.output)
print(f"Saved {args.output}")