# Space Adventure (working title)

A Space Quest–style comedy adventure with Monkey Island–style controls. Read `docs/DECISIONS.md`
before changing anything that touches a decision.

## Stack
- **Godot 4.7.2** (stable). **Popochiu 2.2.1** in `addons/popochiu/` (MIT). Don't edit the addon;
  game code lives in `game/`.
- 320×200 game resolution, pixel-art filtering, 9-verb GUI template copied into `game/gui/`.

## Layout
- `game/rooms/<room>/` room scene, script, state, and its props, hotspots, walkable areas, markers.
- `game/characters/`, `game/inventory_items/`, `game/dialogs/` one folder per object.
- `game/popochiu_globals.gd` is the `Globals` autoload: `die()` (silly deaths) and `approach()`.
- `game/death/death_screen.gd` the death screen.
- `game/gui/gui_commands.gd` default joke lines for verbs with no special handler.
- `game/art/` all art. Every file there is a placeholder until D8 is decided.
- `tools/` dev-only: placeholder art script, test driver, tests.

## Writing object behaviour
- Each verb calls `on_<verb>()` on the clicked object: `on_look_at`, `on_open`, `on_pick_up`,
  `on_push`, `on_pull`, `on_close`, `on_talk_to`, `on_use`, `on_give`.
- Using an inventory item on something calls `_on_item_used(item)`.
- Start actions with `await Globals.approach()` (walk there and face it). For Look at, only face.
- Keep `_on_click()` / `_on_right_click()` calling `E.command_fallback()`.
- Save puzzle progress in the room's `*_state.gd` (it is saved with the game).

## Deaths
Call `Globals.die(title, joke, safe_position)` **before** changing any game state in that action,
so "Try again" is a clean rewind. Record `safe_position` before Dex walks anywhere.

## Creating new rooms, characters, items without the editor UI
Popochiu builds objects through its editor plugin. `addons/bootstrap/` runs Popochiu's own
factories headless (`BOOTSTRAP_STEP=1..4 godot --headless --editor --path .`). Steps 1–4 are the
ones used for room one; copy the pattern for new content. They do nothing without the env var.
Note: shapes for clickable areas must be written into the room `.tscn` (`interaction_polygon`);
setting them through the editor API alone does not stick.

## Testing (Claude can run these itself)
- Screenshot: `DEV_DRIVER=shot DEV_SHOT_DIR=/tmp/shots xvfb-run -a godot --rendering-driver opengl3 --path .`
- Full playthrough with real clicks:
  `DEV_DRIVER=res://tools/tests/playthrough.gd DEV_SHOT_DIR=/tmp/shots xvfb-run -a godot --rendering-driver opengl3 --path .`
  Prints `PASS`/`FAIL` lines and `RESULT PASS`. Run it after every change to room one.
- `tools/dev_driver.gd` is an autoload that does nothing unless `DEV_DRIVER` is set.

## Rules
- Plain language in anything the owner reads. Mark guesses as guesses.
- Placeholders are placeholders: don't present invented names or story as decided (see D7).
