#### fragment

# Thoughts:

I wasn't able to get the colour, or the rotation/direction of the rays correct.

![photo](screenshot.png)

# code:

```rust
@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var fragColor: vec4<f32> = vec4<f32>(0.0080);
    var uv = (in.uv.xy * 2.0)- 1.0;
    uv.y -= 0.55; // To keep the logo centered.

    let resolution = view.viewport.zw;
    let scalefac = vec2f(resolution.x, resolution.y);

     // Loop for REP iterations
    for (var count: i32 = 0; count < 2; count = count + 1) {
         // Calculate uv coordinates
        uv *= 1.4;
        uv.x += hash(uv.xy + globals.time + f32(count)) / 512.0;
        uv.y += hash(uv.yx + globals.time + f32(count)) / 512.0;


        // Calculate the direction # I was unable to work out how to do this well, due to not being able to swizzle.
        var dir: vec3<f32> = normalize(vec3<f32>(
            uv.xy * 0.33,
            2.0 + sin(globals.time) * 0.01
        ));

        let scale_factor = vec2f((resolution.x / resolution.y), 1.0);

        // Calculate rotations
        var stash = rot(dir.xz, d2r(80.0)); //xz
        dir.z = stash.y;
        stash = rot(dir.xy, d2r(92.0)); //xy
        dir.x = stash.y;

         // Initialize variables
        var pos: vec3<f32> = vec3<f32>(
            -0.1 + sin(globals.time * 0.3) * 0.1,
            2.0 + cos(globals.time * 0.4) * 0.1,
            -3.5
        );
        var col: vec3<f32> = vec3<f32>(0.0);
        var t: f32 = 0.0;
        var M: f32 = 1.002;
        var bsh: f32 = 0.01;
        var dens: f32 = 0.0;

         // First loop, controls the intensity of the backlighting
        for (var i: i32 = 0; i < REP * 24; i = i + 1) {
            var temp: f32 = map1(pos + dir * t, 0.6);
            if temp < 0.2 {
                col += WBCOL * 0.005 * dens;
            }
            t += bsh * M;
            bsh *= M;
            dens += 0.025;
        }

        t = 0.0;
        var y: f32 = 0.0;
        // Second loop, draws the windows...
        for (var i: i32 = 0; i < REP * 50; i = i + 1) {
            var temp: f32 = map2(pos + dir * t);
            if temp < 0.1 {
                col += WBCOL2 * 0.005;
            }
            t += temp;
            y = y + 1.0;
        }

        col += ((0.0 + uv.x) * WBCOL2) + (y / (25.0 * 50.0));
        // col += gennoise(vec2<f32>(dir.xz), globals.time) * 0.5;
        // Tint it blue:
        col *= 1.0 - uv.y * 0.28;
        col *= vec3<f32>(0.25);
        // get brigther toward the center
        col = pow(col, vec3<f32>(0.717));

         // Add the result to fragColor
        fragColor = fragColor + vec4<f32>(col, 1.0 / t);
    }

    // Divide fragColor by 2.0
    fragColor = fragColor / 2.0;
    fragColor.b += 0.7;

    return fragColor;
}

fn d2r(x: f32) -> f32 {
    return x * PI / 180.0;
}

// Generates noise based on a 2D vector 'p'
fn gennoise(_p: vec2f, iTime: f32) -> f32 {
    var p = _p;
    var d: f32 = 0.5;
    var h: mat2x2f = mat2x2f(
        vec2f(1.6, 1.2),
        vec2f(-1.2, 1.6)
    );

    var color: f32 = 0.0;
    for (var i: i32 = 0; i < 2; i = i + 1) {
        color = color + d * noise(p * 5.0 + iTime);
        p = p * h;
        d = d / 2.0;
    }
    return color;
}

// Computes a hash for a 2D vector
fn hash(p: vec2f) -> f32 {
    var h: f32 = dot(p, vec2(127.1, 311.7));
    return fract(sin(h) * 458.325421) * 2.0 - 1.0;
}

// Computes Perlin noise for a 2D vector
fn noise(p: vec2f) -> f32 {
    let i: vec2f = floor(p);
    var f: vec2f = fract(p);

    f = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), f.x),
        mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
        f.y
    );
}

// Rotates a 2D vector by an angle
fn rot(_p: vec2f, a: f32) -> vec2f {
    var p = _p;
    return vec2f(
        p.x * cos(a) - p.y * sin(a),
        p.x * sin(a) + p.y * cos(a)
    );
}

// Computes the normalized absolute distance to a rectangular box
fn recta(_p: vec3f, F: vec3f, o: vec3f) -> f32 {
    var p = _p;
    var R: f32 = 0.0001;
    p += o;
    var absP: vec3f = abs(p);
    var maxAbs = max(absP - F, vec3f(0.0));
    return length(maxAbs) - R;
}


// Computes the normalized absolute distance to a box
fn by(_p: vec3f, F: f32, o: vec3f) -> f32 {
    var p = _p;
    p += o;
    var R: f32 = 0.0001;
    var m: vec2f = p.xy % vec2f(3.0);
    var maxAbs = max(abs(m) - F, vec2f(0.0));
    return length(maxAbs) - R;
}

// Computes a mapping function
fn map1(p: vec3f, scale: f32) -> f32 {
    var G: f32 = 0.50;
    var F: f32 = 0.50 * scale;
    var t: f32 = nac(p, vec2f(F, F), vec3f(G, G, 0.0));
    t = min(t, nac(p, vec2f(F, F), vec3f(G, -G, 0.0)));
    t = min(t, nac(p, vec2f(F, F), vec3f(-G, G, 0.0)));
    t = min(t, nac(p, vec2f(F, F), vec3f(-G, -G, 0.0)));
    return t;
}

// Computes the second mapping function
fn map2(p: vec3f) -> f32 {
    var t: f32 = map1(p, 0.9);
    t = max(t, recta(p, vec3f(1.0, 1.0, 0.02), vec3f(0.0, 0.0, 0.0)));
    return t;
}

// Computes the normalized absolute distance to a box
// defined by its half extents 'F' and an offset 'o'
// from a point 'p'
fn nac(_p: vec3f, F: vec2f, o: vec3f) -> f32 {
    var p = _p;
    p += o;
    var R: f32 = 0.0001;
    var maxAbs = max(abs(p.xy) - F, vec2f(0.0));
    return length(maxAbs) - R;
}

```
