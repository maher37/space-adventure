"""Draws the PLACEHOLDER pixel art for the first room.

Run:  python3 tools/make_placeholder_art.py
Every file this writes is meant to be replaced by real art later. Keep the same file names and
sizes and the game will pick the new art up without code changes.
"""
import math
import os
import random

from PIL import Image, ImageDraw

ROOT = os.path.join(os.path.dirname(__file__), "..", "game", "art")
random.seed(7)

# A small fixed palette keeps the chunky retro look.
P = {
    "space": (10, 8, 28), "star": (240, 240, 200), "star2": (140, 150, 220),
    "wall_d": (34, 44, 70), "wall": (52, 66, 102), "wall_l": (78, 96, 140), "rivet": (112, 130, 170),
    "trim": (186, 120, 44), "trim_d": (120, 70, 30),
    "floor_d": (40, 36, 46), "floor": (66, 60, 74), "floor_l": (92, 86, 102),
    "red": (214, 40, 48), "red_d": (130, 20, 30), "yellow": (240, 200, 60), "black": (12, 10, 16),
    "white": (236, 236, 236), "grey": (130, 130, 140), "grey_d": (80, 80, 92),
    "couch": (120, 60, 120), "couch_d": (80, 36, 84), "couch_l": (158, 92, 156),
    "green": (70, 200, 110), "cyan": (90, 220, 230), "glass": (40, 80, 110),
    "skin": (236, 180, 140), "skin_d": (196, 132, 100), "suit": (232, 120, 40), "suit_d": (170, 76, 26),
    "hair": (90, 52, 30), "boot": (40, 36, 50), "coin": (250, 210, 70), "coin_d": (190, 140, 30),
}


def save(img, *parts):
    path = os.path.join(ROOT, *parts)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)
    print("wrote", os.path.relpath(path, os.path.join(ROOT, "..", "..")))


def rect(d, x0, y0, x1, y1, c):
    d.rectangle([x0, y0, x1, y1], fill=P[c] if isinstance(c, str) else c)


def background():
    w, h = 320, 200
    img = Image.new("RGB", (w, h), P["black"])
    d = ImageDraw.Draw(img)
    # Wall panels.
    rect(d, 0, 0, w - 1, 104, "wall")
    for x in range(0, w, 40):
        rect(d, x, 8, x + 1, 100, "wall_d")
        rect(d, x + 2, 8, x + 2, 100, "wall_l")
    for x in range(6, w, 20):
        d.point((x, 12), fill=P["rivet"]); d.point((x, 96), fill=P["rivet"])
    rect(d, 0, 0, w - 1, 6, "wall_d")
    rect(d, 0, 101, w - 1, 104, "trim")
    rect(d, 0, 104, w - 1, 105, "trim_d")
    # Hazard stripe along the ceiling.
    for x in range(0, w, 8):
        d.polygon([(x, 0), (x + 4, 0), (x + 8, 6), (x + 4, 6)], fill=P["yellow"])
    # Floor plates with simple perspective lines.
    rect(d, 0, 106, w - 1, 150, "floor")
    for y in (114, 124, 136):
        rect(d, 0, y, w - 1, y, "floor_d")
    for i in range(-8, 18):
        x_top = i * 24
        x_bot = 160 + (x_top - 160) * 1.6
        d.line([(x_top, 106), (x_bot, 150)], fill=P["floor_d"])
    rect(d, 0, 106, w - 1, 106, "floor_l")
    rect(d, 0, 151, w - 1, h - 1, "black")

    # Porthole window with stars.
    cx, cy, r = 160, 40, 22
    d.ellipse([cx - r - 4, cy - r - 4, cx + r + 4, cy + r + 4], fill=P["grey_d"])
    d.ellipse([cx - r - 2, cy - r - 2, cx + r + 2, cy + r + 2], fill=P["grey"])
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=P["space"])
    for _ in range(26):
        a = random.random() * math.tau
        rr = random.random() * (r - 2)
        d.point((cx + int(math.cos(a) * rr), cy + int(math.sin(a) * rr)),
                fill=P["star"] if random.random() < 0.6 else P["star2"])
    # A small ringed planet in the window.
    d.ellipse([cx + 4, cy - 12, cx + 14, cy - 2], fill=(200, 110, 80))
    d.line([(cx + 1, cy - 5), (cx + 17, cy - 9)], fill=P["yellow"])
    for a in range(0, 360, 45):
        x = cx + int(math.cos(math.radians(a)) * (r + 3))
        y = cy + int(math.sin(math.radians(a)) * (r + 3))
        d.point((x, y), fill=P["rivet"])

    # Bridge door (left): sliding door with a keycard reader.
    rect(d, 30, 26, 86, 101, "grey_d")
    rect(d, 34, 30, 82, 101, "grey")
    rect(d, 57, 30, 59, 101, "grey_d")
    rect(d, 40, 40, 52, 48, "glass"); rect(d, 64, 40, 76, 48, "glass")
    for y in range(60, 100, 6):
        rect(d, 36, y, 55, y, "grey_d"); rect(d, 61, y, 80, y, "grey_d")
    rect(d, 34, 22, 82, 25, "trim")
    d.text((42, 14), "BRIDGE", fill=P["white"])
    rect(d, 89, 56, 95, 68, "black")       # Card reader.
    rect(d, 90, 57, 94, 59, "red")
    rect(d, 91, 62, 93, 66, "grey_d")

    # Couch (centre).
    rect(d, 136, 70, 214, 84, "couch_d")
    rect(d, 138, 72, 212, 82, "couch")
    rect(d, 132, 80, 218, 101, "couch_d")
    rect(d, 134, 84, 216, 96, "couch")
    rect(d, 140, 85, 173, 92, "couch_l"); rect(d, 177, 85, 210, 92, "couch_l")
    rect(d, 132, 80, 138, 101, "couch_d"); rect(d, 212, 80, 218, 101, "couch_d")
    rect(d, 134, 99, 137, 103, "black"); rect(d, 213, 99, 216, 103, "black")
    # A sad patch on one cushion.
    rect(d, 192, 87, 197, 90, (190, 150, 70))

    # Airlock (right) with the big red button.
    rect(d, 250, 18, 312, 101, "grey_d")
    d.ellipse([254, 22, 308, 76], fill=P["grey"])
    rect(d, 254, 49, 308, 101, "grey")
    d.ellipse([262, 30, 300, 68], fill=P["grey_d"])
    rect(d, 262, 49, 300, 101, "grey_d")
    for y in range(52, 100, 8):
        d.polygon([(262, y), (270, y), (274, y + 4), (266, y + 4)], fill=P["yellow"])
        d.polygon([(292, y), (300, y), (296, y + 4), (288, y + 4)], fill=P["yellow"])
    rect(d, 276, 40, 286, 48, "glass")
    d.text((262, 8), "AIRLOCK", fill=P["yellow"])
    # The button and its sign.
    rect(d, 226, 46, 246, 70, "black")
    rect(d, 228, 48, 244, 68, "grey_d")
    d.ellipse([230, 52, 242, 64], fill=P["red_d"])
    d.ellipse([231, 52, 241, 61], fill=P["red"])
    d.point((234, 54), fill=P["white"])
    rect(d, 220, 74, 252, 86, "yellow")
    d.text((221, 75), "DON'T", fill=P["black"])

    # Little wall poster for flavour.
    rect(d, 196, 18, 216, 44, "white")
    rect(d, 198, 20, 214, 32, "cyan")
    d.ellipse([202, 22, 210, 30], fill=P["yellow"])
    rect(d, 199, 35, 213, 35, "black")
    rect(d, 199, 38, 210, 38, "black")
    save(img, "rooms", "galley", "background.png")


def vending_machine():
    w, h = 34, 64
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    rect(d, 0, 0, w - 1, h - 1, "black")
    rect(d, 1, 1, w - 2, h - 2, "red_d")
    rect(d, 2, 2, w - 3, h - 3, "red")
    rect(d, 4, 4, 22, 46, "glass")
    colours = ["yellow", "green", "cyan", "white", "coin", "couch_l"]
    for row in range(4):
        for col in range(3):
            c = colours[(row * 3 + col) % len(colours)]
            rect(d, 6 + col * 6, 7 + row * 10, 9 + col * 6, 12 + row * 10, c)
            rect(d, 5, 13 + row * 10, 21, 13 + row * 10, "grey")
    rect(d, 25, 6, 30, 10, "black")      # Display.
    rect(d, 26, 7, 29, 9, "green")
    for i in range(3):
        rect(d, 25, 14 + i * 5, 30, 17 + i * 5, "grey")
    rect(d, 26, 32, 29, 38, "black")     # Coin slot.
    rect(d, 4, 50, 29, 58, "black")      # Tray.
    rect(d, 6, 52, 27, 56, "grey_d")
    d.text((4, 0), "", fill=P["white"])
    save(img, "rooms", "galley", "vending_machine.png")


def coin(size=8, name=("rooms", "galley", "space_nickel.png")):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([0, 0, size - 1, size - 1], fill=P["coin_d"])
    d.ellipse([0, 0, size - 2, size - 2], fill=P["coin"])
    d.point((size // 3, size // 3), fill=P["white"])
    save(img, *name)


def inventory_icons():
    # Inventory slots in the 9-verb panel are about 40x24 game pixels.
    img = Image.new("RGBA", (24, 20), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([4, 2, 19, 17], fill=P["coin_d"])
    d.ellipse([4, 2, 18, 16], fill=P["coin"])
    d.ellipse([7, 5, 15, 13], outline=P["coin_d"])
    d.point((8, 6), fill=P["white"])
    save(img, "inventory", "space_nickel.png")

    img = Image.new("RGBA", (24, 20), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    rect(d, 2, 4, 21, 15, "white")
    rect(d, 3, 5, 20, 14, "cyan")
    rect(d, 4, 7, 9, 12, "skin")          # Tiny photo.
    rect(d, 11, 7, 19, 7, "black")
    rect(d, 11, 10, 17, 10, "black")
    rect(d, 2, 13, 21, 15, "yellow")
    save(img, "inventory", "keycard.png")


def dex_sheet():
    """Dex: 16x32 frames. Rows: right, down, up. Columns: idle, walk1-4, talk1-2."""
    fw, fh = 16, 32
    cols, rows = 7, 3
    img = Image.new("RGBA", (fw * cols, fh * rows), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    def body(ox, oy, facing, leg_phase, mouth_open):
        # Legs.
        swing = [0, 2, 0, -2][leg_phase] if leg_phase >= 0 else 0
        if facing == "r":
            rect(d, ox + 6 + swing, oy + 22, ox + 8 + swing, oy + 29, "suit_d")
            rect(d, ox + 7 - swing, oy + 22, ox + 9 - swing, oy + 29, "suit")
            rect(d, ox + 6 + swing, oy + 29, ox + 10 + swing, oy + 31, "boot")
            rect(d, ox + 7 - swing, oy + 29, ox + 11 - swing, oy + 31, "boot")
        else:
            lift = [0, 1, 0, -1][leg_phase] if leg_phase >= 0 else 0
            rect(d, ox + 5, oy + 22, ox + 7, oy + 29 - max(lift, 0), "suit_d")
            rect(d, ox + 9, oy + 22, ox + 11, oy + 29 - max(-lift, 0), "suit_d")
            rect(d, ox + 4, oy + 29 - max(lift, 0), ox + 7, oy + 31 - max(lift, 0), "boot")
            rect(d, ox + 9, oy + 29 - max(-lift, 0), ox + 12, oy + 31 - max(-lift, 0), "boot")
        # Torso (orange jumpsuit) with a name patch.
        rect(d, ox + 4, oy + 12, ox + 11, oy + 22, "suit")
        rect(d, ox + 4, oy + 21, ox + 11, oy + 22, "suit_d")
        if facing != "u":
            rect(d, ox + 5, oy + 14, ox + 7, oy + 15, "white")
        # Arms.
        arm = [0, -1, 0, 1][leg_phase] if leg_phase >= 0 else 0
        if facing == "r":
            rect(d, ox + 7 + arm, oy + 13, ox + 9 + arm, oy + 20, "suit_d")
            rect(d, ox + 7 + arm, oy + 20, ox + 9 + arm, oy + 21, "skin")
        else:
            rect(d, ox + 2, oy + 13, ox + 3, oy + 20 + arm, "suit_d")
            rect(d, ox + 12, oy + 13, ox + 13, oy + 20 - arm, "suit_d")
            rect(d, ox + 2, oy + 20 + arm, ox + 3, oy + 21 + arm, "skin")
            rect(d, ox + 12, oy + 20 - arm, ox + 13, oy + 21 - arm, "skin")
        # Head.
        rect(d, ox + 4, oy + 3, ox + 11, oy + 11, "skin")
        rect(d, ox + 4, oy + 11, ox + 11, oy + 11, "skin_d")
        rect(d, ox + 3, oy + 1, ox + 12, oy + 4, "hair")   # Messy hair.
        d.point((ox + 12, oy + 0), fill=P["hair"]); d.point((ox + 6, oy + 0), fill=P["hair"])
        if facing == "r":
            rect(d, ox + 11, oy + 6, ox + 13, oy + 8, "skin_d")  # Big nose.
            d.point((ox + 9, oy + 5), fill=P["black"])
            rect(d, ox + 8, oy + 9, ox + 10, oy + 9 + (1 if mouth_open else 0), "black")
            rect(d, ox + 3, oy + 4, ox + 5, oy + 8, "hair")
        elif facing == "d":
            d.point((ox + 6, oy + 6), fill=P["black"]); d.point((ox + 9, oy + 6), fill=P["black"])
            rect(d, ox + 7, oy + 7, ox + 8, oy + 8, "skin_d")
            rect(d, ox + 6, oy + 9, ox + 9, oy + 9 + (1 if mouth_open else 0), "black")
        else:
            rect(d, ox + 4, oy + 3, ox + 11, oy + 10, "hair")

    for r, facing in enumerate(["r", "d", "u"]):
        oy = r * fh
        body(0, oy, facing, -1, False)                    # Idle.
        for i in range(4):
            body(fw * (1 + i), oy, facing, i, False)      # Walk.
        body(fw * 5, oy, facing, -1, True)                # Talk open.
        body(fw * 6, oy, facing, -1, False)               # Talk closed.
    save(img, "characters", "dex", "dex_sheet.png")


def death_art():
    """Dex tumbling through space, for the death screen."""
    img = Image.new("RGB", (320, 200), P["space"])
    d = ImageDraw.Draw(img)
    for _ in range(140):
        d.point((random.randrange(320), random.randrange(200)),
                fill=P["star"] if random.random() < 0.5 else P["star2"])
    # The ship, shrinking into the distance.
    rect(d, 236, 30, 290, 42, "grey")
    rect(d, 246, 26, 270, 30, "grey_d")
    rect(d, 290, 33, 296, 39, "red")
    rect(d, 228, 34, 236, 38, "cyan")
    save(img, "ui", "death_space.png")


if __name__ == "__main__":
    background()
    vending_machine()
    coin()
    inventory_icons()
    dex_sheet()
    death_art()
