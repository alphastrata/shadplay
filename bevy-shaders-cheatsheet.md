# Bevy-Shader-Cheatsheet.

I've found the whole 'shader-land' story around Bevy to be pretty impenetrable, this is a small attempt to collect some of my notes -- made public in the hope it will alleviate the potential suffering of others.

______________________________________________________________________

## Contents:

- ### [noise](#noise)
- ### [resolution](#resolution)
- ### [sdf-shapes](#sdf-shapes)
- ### [time](#time)
- ### [uvs](#uvs)
- ### [uuid-generation](#uuid-generation)
- ### [get data into your shader from bevy](#get-data-into-your-shader)
- ### [smoothstep](#smoothstep)
- ### [step](#step)
- ### [glow](#glow)
- ### [glsl syntax differences](#syntax-diffs)
- ### [importable from bevy](#importable)

______________________________________________________________________

# uvs:

```rust
// 'uv's are in the MeshVertexOutput
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

@fragment
fn fragment(in: MeshVertexOutput) -> vec4<f32> {
	// usually you'll see them used in your fragment shaders thusly:
	let uv = in.uv;
  let normalised_uv = (in.uv.xy * 2.0) - 1.0; // If you want 0,0 to be at the 'center' of your Mesh's geometry.

	return vec4f(uv.x, uv.y, 0.0, 1.0);
}
```

______________________________________________________________________

# resolution:

You'll usually need this when you go to say, draw a `sdCircle` or other `sdf` shape and suddenly realise that it's squashed because the aspect ratio of the window is _not_ being accounted for.

- Most of what you need is in [View](https://github.com/bevyengine/bevy/blob/154a49044514fb21b0f83f4f077d76380e12a8a8/crates/bevy_render/src/view/view.wgsl#L19)
- Don't forget the `@group(0) @binding(0) var<uniform> view: View;` to make the uniform availble.

```rust
#import bevy_render::view View

@group(0) @binding(0) var<uniform> view: View;

@fragment
fn fragment(in: MeshVertexOutput) -> vec4<f32> {
  	// example, shader-toyesk normalise and account for aspect ratio:
    var uv = (in.uv.xy * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(PI / -2.0); // Our uvs are by default a -1,-1 in uppermost left cnr, this rotates you around.

    // your code here.
  

}
```

- [Dunno what `uniform`s are?](https://thebookofshaders.com/03/)

______________________________________________________________________

# time:

```rust
#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

const TAU:f32 =  6.28318530718;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;
    var col = vec3f(0.);

    let distance_to_center = vec2(0.25) - uv;
    let angle = atan2(distance_to_center.y, distance_to_center.x);
    let radius = length(distance_to_center) * 2.0;

    col = hsv_to_srgb(vec3f((angle / TAU) + globals.time / 3.0, radius, 1.0));
    return vec4f(col, 1.0);
}

// From the bevy source code
fn hsv_to_srgb(c: vec3<f32>) -> vec3<f32> {
    let K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3(0.0), vec3(1.0)), c.y);
}
```

> NOTE: if you're in 2d, the globals is in a diff spot: `#import bevy_sprite::mesh2d_view_bindings   globals`

______________________________________________________________________

# sdf-shapes

- [munrocket's 3d](https://gist.github.com/munrocket/f247155fc22ecb8edf974d905c677de1)
- [munrocket's 2d](https://gist.github.com/munrocket/30e645d584b5300ee69295e54674b3e4)

______________________________________________________________________

# noise

- [munrocket's noise](https://gist.github.com/munrocket/236ed5ba7e409b8bdf1ff6eca5dcdc39)

______________________________________________________________________

# uuid-generation:

- you need `uuid`s for the ECS, whenever you're deriving `TypeUuid` on stuff you plan on putting in there (which we do plan on doing)

```rust
#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "c74e039a-3df7-4f71-bd1d-7fe4b25a2230"]
struct MyShader{}
```

Here's an [online-generator](https://www.uuidgenerator.net/), that I use a bit.
_if you're feeling lazy here's 25 generated earlier_

```shell
f6395028-088c-4d0c-bf79-9bb238b79768
83db0271-2867-4477-9cad-afd89bd93abc
688566d8-3ca3-4401-80bf-19db02f7ab8c
42ecf202-ab31-47d0-99e8-62cc59489b29
4b919679-6311-4cc9-a374-131500abc512
ff12d937-9a01-4abe-91cf-13457d33df80
21f7e8f1-c950-409b-a2eb-8457e10d0070
f5f0c9a4-9834-4edf-ae47-071a40f9eafd
2ba4a8b0-d4b4-4f00-a6a0-389afc4014ce
c6d009c9-c5f2-41c9-8068-b6f68fd06969
6907e7a9-6a12-444d-9923-e347f609ca95
c8b1af9a-b54c-42e2-b479-f52e0ed6f4da
87b235fb-4451-4de5-a843-e7782292b9b3
d4e7bf47-b6d3-4ff9-86ce-874b7d32743e
8efd22a3-17b2-43de-bac1-a064142c96ae
2a144e21-4e01-42d7-a2e8-5078793fb16c
29746aa9-e63e-424c-a951-ef14b0466946
ed5396f9-26cc-4f40-9123-2b302d729ecf
c1887ade-4669-4c96-ac08-2a1eb2ebfb33
14d87951-1436-4055-8130-df22881a6774
2b72b9be-4d3f-4f21-bf4f-589032bb43d5
1f74affc-1fd3-49e5-944d-969f4d253e64
cca52d9e-2bd4-4fc0-b058-7bd3ddd1aba5
6feca34e-6fa7-4fa4-a7c8-d914382108ba
fd9ec163-e144-478d-a085-702d028f1149
```

or, you can use [`quiddy`](https://github.com/alphastrata/quuidy):

```shell
cargo install quuidy
quuidy -n 10
```

______________________________________________________________________

# get-data-into-your-shader

If none of that makes sense: I wrote a [blog-post](https://jeremyfwebb.ninja/src/blog_posts/wgsl_basics), on this.
Take this shader code [dotted-line-shader](https://github.com/alphastrata/shadplay/blob/develop/assets/shaders/dotted_line.wgsl)
Then use this [rust-binding-code](https://github.com/alphastrata/shadplay/blob/develop/src/shader_utils.rs). (copied below for the lazy)

```rust
// in src/YOURMODULE.rs
#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "c74e039a-3df7-4f71-bd1d-7fe4b25a2230"]
struct DottedLineShader {
    #[uniform(0)]
    uniforms: Holder, //RGBA
}

/// Simplified holding struct to make passing across uniform(n) simpler.
#[derive(ShaderType, Default, Clone, Debug)]
struct Holder {
    tint: Color,
    /// How wide do you want the line as a % of its availablu uv space: 0.5 would be 50% of the surface of the geometry
    line_width: f32,
    /// How many segments (transparent 'cuts') do you want?
    segments: f32,
    /// How fast do you want the animation to be? set 0.0 to disable.
    phase: f32,
    /// How far spaced apart do you want these lines?
    line_spacing: f32,
}

impl Material for DottedLineShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/dotted_line.wgsl".into()
    }
}
```

In your `main.rs`:

```rust
app.add_plugins(MaterialPlugin::<YOURMODULEPATH::DottedLineShader>::default());
```

______________________________________________________________________

# [smoothstep](https://en.wikipedia.org/wiki/Smoothstep)

smoothstep interpolates between two 'edges', `leftedge`, sometimes called `edge0` and `rightedge`, sometimes called `edge1`, for a given `x`.
i.e make the shape of the _below_ graph, where all values are clamped between those two edges.
So if your `x` is \<= to leftedge smoothstep returns you a 0.
if your `x` is >= to the rightedge, smoothstep retuns you a 1.

![smoostep](https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Smoothstep_and_Smootherstep.svg/220px-Smoothstep_and_Smootherstep.svg.png)

> _It's usually assumed x is a real number (i.e a float)._
> It's commonly used to create smooth transitions and animations, such as in fading effects, transitions between colors, or smoothly moving objects from one position to another.

The smoothstep function takes three parameters:

```
    LeftEdge: The lower edge of the range.
    RightEdge: The upper edge of the range.
    x: The input value that you want to interpolate between those above Edges.
```

- [lil-book-of-shaders](https://thebookofshaders.com/glossary/?search=smoothstep)'s explination

______________________________________________________________________

# step

`fn step(limit, value)` any `value` under the `limit` will return a `0.0`, anything above `value` a `1.0`;
available on `f32, vecN<T>` i.e all `vec2/3/4` types with any `isize/usize/f32` etc.

> can be useful to replace `if` statements, because a numerical solve is (rumoured to be) superiour in performance to a branch:

```rust
// From the dotted_line.wgsl mentioned elsewhere in this guide.
    // draw x line
    if abs(uv.x) < 0.025{
        uv += t * 0.5;
        // segment the line, only tint the areas we want
        var uv_segmented: vec2<f32> = fract(uv * 3.0) * 0.05;
        let step_y: f32 = step(0.025, abs(uv_segmented.y)); // you can read this as `if (abs(uv_segmented.y) > 0.025)/*...*/ ``
        col += vec4f(0.23, 0.88, 0.238, 1.0)* step_y;
    }
```

[code](https://github.com/alphastrata/shadplay/blob/develop/assets/shaders/dotted_line.wgsl)

______________________________________________________________________

# syntax diffs

> NOTE: this is not an exhaustive list!

- `glsl` has `mod` but in `wgsl` you need to use `%`
- bindings in `glsl` by default are mutable, not so in `wgsl`, use `var` for mutable `let` for immutable.
- in `glsl` you'll see the `in` keyword, which do to a similar thing with pointers in wgsl:

```rust
fn testing (uv: ptr<function, vec2<f32>>) {
    (*uv).x = 4.0;
}
```

which you cal call like this `testing(&uv)`.

______________________________________________________________________

# importable

> TODO
