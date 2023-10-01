# shadplay

## Our [bevy-shader-cheatsheet](bevy-shaders-cheatsheet.md#Contents)

Shadplay is a simple app designed to allow easy and fast prototyping and work on `wgsl` code specifically for how you'd want to do that with Bevy.
The idea is to give one the minimal ammount of bevy boilerplate etc possible to get started writing glsl asap, and provide a library of examples showing how some things are done, can be done etc.

A secondary goal is to flesh out a relatively comprehensive 'port' of existing cool shader work from places like shadertoy etc -- because there's a few 'gotchas' around the differences in `glsl` and `wgsl` syntax, their respective builtins.

A tertiary goal is to surface the builtins/existing library code that Bevy's codebase provides.

---
### Why?
>I have found, and continue to find the shader-universe impenetrable, however: I'd rather attempt to write up and document the content I *wish* I'd been able to find in my first google search, than complain.

---
## Features
- A large collection of example shaders illustrating creative and educational uses. `assets/shaders/yourshadergoeshere.wgsl` specifically focusing on `wgsl`.
- Live preview of shader code on Bevy mesh geometry.
- Automatic recompilation and update of shaders upon saving changes in your editor.
- Quick iteration and experimentation with `wgsl` shader code.
- Transparent background, with always-on-top (so you can have it ontop of your editor)
- Screenshot the shader you're working on with <SPACEBAR>, this will also version the shader (at `assets/shaders/myshader.wgsl`) for you i.e:
```shell
 screenshots
└──  01-10-23
    └──  09-23-29
        ├──  screeenshot.png // Your screenshot
        └──  screeenshot.wgsl// The shader at `assets/shaders/myshader.wgsl`
```

---

To run shadplay, you'll need the following:

- Rust (stable) - Make sure you have Rust installed on your system. You can find installation instructions at [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install).
  _We assume you can follow their instructions to clear that hurdle_

### Installation

```shell
 $ git clone https://github.com/alphastrata/shadplay.git
 $ cd shadplay
 $ cargo run --release
```

- Then edit the `myshader.wgsl` file in real time.

---
## Keybindings:
The app has some simple hotkeys:

| Hotkey | Action               |
|--------|----------------------|
| q      | Quit                 |
| s      | Change Shape in 3D   |
| t      | Switch to 2D/ShaderToy Mode|
| h      | Switch to 3D         |
| l      | Window-Level         |
| d      | Toggle Decorations   |
| t      | Toggle Transparency (returning to fully transparent is not supported)|
| r      | Toggle Rotating shape|
| spacebar      | Takes a screenshot && versions the current `myshader.wgsl`| 


---
## Resources:
- [Fantastic implementations of some sdf composed shapes](https://gist.github.com/munrocket/f247155fc22ecb8edf974d905c677de1)
- [Shadertoy](https://www.shadertoy.com/)
- [Shaded by embark](https://github.com/EmbarkStudios/shaded)
- [pcf swap by DGriffin91](https://github.com/DGriffin91/bevy_mod_standard_material/tree/pcf)

---
## Contributing:
Welcome.
- open a PR.

---
## TODO:
- [] drag n drop obj/stl/gltf opening?
- [] clever snap camera
- [] material swap to ours system (drag n drop a shader onto the window)
- [] hotkey menu display (egui? eframe?)
- [] More shader examples (the entirety of shadertoy ported!)
- [] demo images (of all shaders in the library)
- [] left/right arrows to swap between shaders from the assets' dir
- [] buttons to spin/swap the geomerty your shader is currently being applied to.
- [] after supporting drag-n-drop shader applied to mesh -- need to support the screenshotter versioning their shaders too as it does for the defaults.
