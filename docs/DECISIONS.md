# Decisions

✅ = decided by the owner. ❓ = open: ask the owner before building anything that depends on it.
When a decision changes, edit its row here in the same commit as the code change.

| # | Decision | Status | Notes |
|---|---|---|---|
| D1 | **Art style:** chunky low-resolution pixel art, like Monkey Island 1–2. | ✅ 2026-11-25 | Game runs at 320×200, scaled up 4× with sharp pixels. |
| D2 | **Interface:** big action buttons, Monkey Island style (9 verbs + inventory panel). | ✅ 2026-11-25 | Popochiu's built-in "9 Verbs" template. |
| D3 | **Deaths:** the player can die, Space Quest style, with silly death screens. | ✅ 2026-11-25 | "Try again" rewinds to just before the fatal action (see `Globals.die`). |
| D4 | **Start small:** build one room first, then grow. | ✅ 2026-11-25 | Room one ("Galley") is built. |
| D5 | **Separate from the RPG:** own repository, own docs. | ✅ 2026-11-25 | Nothing shared with `ember-crown`. |
| D6 | **Engine:** Godot 4.7.2 + Popochiu 2.2.1. | ✅ 2026-11-25 | Owner said yes to setting this up. |
| D7 | Game title, hero name, ship name, story. | ❓ | Everything in room one ("Dex", the Snack-O-Tron, "Third-Class Snack Restocker") is a placeholder Claude wrote. |
| D8 | Where final art comes from (artist, AI sprite tool, asset packs, mix). | ❓ | All current art is placeholder, drawn by `tools/make_placeholder_art.py`. |
| D9 | Where it runs: desktop download, web browser, or both. | ❓ | Web export not tested yet. |
| D10 | Replace the Monkey Island-style font before any public release. | ❓ | `monkeyisland_1991.ttf` ships with Popochiu but has no license and an anonymous author. OK for private use. |
| D11 | Whether to reuse story or jokes from the owner's existing browser space game. | ❓ | Asked on 2026-11-25; no answer yet. |
