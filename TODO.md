- CLAP args so they can track their own shader from a Path, NOTE this will require a world.insert_resource, you won't be able to use the existing method.

- 2D 3D mode.

- UI:
  | Button | Description | Notes |
  |-------------|--------------------------|---------------|
  | toggle_framerate | Toggles the display of the framerate in the UI | bevy+bevyUI|
  | next_shape | Switches to the next shape in the rendering | Event, Component, system, buvyUI |
  | spin_shape | Toggles the spinning of the current shape | system, event |
  | decorations |Window topbar min/max/close | window.decorations, system, Event |
  | transparent_bg | Transparent background toggle | window.decorations, system, Event|
  | fallthrough | Enables fallthrough behavior for the shapes |window.decorations, system, Event |
