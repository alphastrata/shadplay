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

## Resources:

- Fantastic implementations of some sdf composed shapes https://gist.github.com/munrocket/f247155fc22ecb8edf974d905c677de1
- Shadertoy
- Shaded by embark
- pcf swap by DGriffin91 https://github.com/DGriffin91/bevy_mod_standard_material/tree/pcf

## Contributing:
Welcome.
- open a PR.

---
## TODO:
- [] drag n drop obj/stl/gltf opening?
- [] clever snap camera
- [] material swap to ours system
- [] hotkey menu display
- [] More shader examples
- [] drag n drop shadering ( swap existing MyShader with one that someone drops on.)
- [] demo images (of all shaders in the library)
- [] left/right arrows to swap between shaders from the assets' dir
- [] buttons to spin/swap the geomerty your shader is currently being applied to.
- [] 2D and 3D Modes
