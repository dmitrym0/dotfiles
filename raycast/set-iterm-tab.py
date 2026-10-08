#!/usr/bin/python3
# @raycast.schemaVersion 1
# @raycast.title Set iTerm Tab
# @raycast.mode silent
# @raycast.icon 🎨
# @raycast.packageName iTerm
# @raycast.argument1 { "type": "text", "placeholder": "Tab name" }
# @raycast.argument2 { "type": "dropdown", "placeholder": "Color", "data": [{"title":"Red","value":"red"},{"title":"Orange","value":"orange"},{"title":"Yellow","value":"yellow"},{"title":"Green","value":"green"},{"title":"Teal","value":"teal"},{"title":"Blue","value":"blue"},{"title":"Purple","value":"purple"},{"title":"Pink","value":"pink"},{"title":"Gray","value":"gray"}] }
#
# Sets the focused iTerm session's name + tab color via the Python API.
# Works even when the pane is running a foreground app (no tty needed).
# Prereqs: iTerm > Settings > General > Magic > Enable Python API; `pip3 install iterm2`.
import sys, iterm2

PALETTE = {
    "red": (215, 58, 74), "orange": (219, 109, 30), "yellow": (201, 159, 0),
    "green": (53, 159, 70), "teal": (0, 150, 136), "blue": (41, 121, 215),
    "purple": (137, 87, 215), "pink": (201, 71, 140), "gray": (120, 120, 120),
}

async def main(connection):
    name, color = sys.argv[1], PALETTE[sys.argv[2]]
    app = await iterm2.async_get_app(connection)
    session = app.current_terminal_window.current_tab.current_session
    change = iterm2.LocalWriteOnlyProfile()
    change.set_title_components([iterm2.TitleComponents.SESSION_NAME])  # name only, no dir/tty
    change.set_tab_color(iterm2.Color(*color))
    change.set_use_tab_color(True)
    await session.async_set_profile_properties(change)
    await session.async_set_name(name)
    print(f"{name} → {sys.argv[2]}")

iterm2.run_until_complete(main)
