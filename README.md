# shadplay

TODO:

- [] drag n drop obj/stl/gltf opening?
- [] clever snap camera
- [] material swap to ours system
- [] hotkey menu display
- [] More shader examples
- [] drag n drop shadering ( swap existing MyShader with one that someone drops on.)
- [] demo images (of all shaders in the library)
- [] left/right arrows to swap between shaders from the assets' dir

Shadplay is a simple, (WIP) application that provides a window where shader code is applied to Bevy mesh geometry. The primary goal of shadplay is to allow users to see immediate changes to their shader code. This is achieved by leveraging Bevy's file-watcher system, which automatically recompiles and updates the shader on the mesh whenever the user saves their changes in their editor of choice. shadplay is designed to provide the lowest barrier to entry for individuals who want to learn or practice using WGSL (WebGPU Shading Language) for the purposes of doing work in Bevy.

## Features

- Live preview of shader code on Bevy mesh geometry.
- Automatic recompilation and update of shaders upon saving changes in your editor.
- Quick iteration and experimentation with WGSL shader code.
- Transparent background, with always-on-top (so you can have it ontop of your editor)
- buttons to spin/swap the geomerty your shader is currently being applied to.
- 2D and 3D Modes

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
