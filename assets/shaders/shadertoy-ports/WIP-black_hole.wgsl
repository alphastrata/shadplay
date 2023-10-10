#import bevy_pbr::mesh_vertex_output      MeshVertexOutput
#import bevy_pbr::utils                   PI
#import bevy_sprite::mesh2d_view_bindings globals 
#import bevy_render::view                 View

#import shadplay::shader_utils::common    rotate2D

@group(0) @binding(0) var<uniform> view: View;

@group(1) @binding(0) var texture: texture_2d<f32>;
@group(1) @binding(1) var texture_sampler: sampler;

const SPEED:f32 = 0.25;
const CAM_DISTANCE: f32 = -2.;

const DISK_ROTATION_SPEED: f32 = 3.0;
const DISK_TEXTURE_LAYERS: f32 = 12.0;
const BLACK_HOLE_SIZE:f32 = 0.3; //QUESTION: % of screen occupied???

const ANTI_ALIASING: i32 = 2;


// Porting https://www.shadertoy.com/view/tsBXW3 by set111:https://www.shadertoy.com/user/set111
@fragment
fn fragment(
    in: MeshVertexOutput
) -> @location(0) vec4<f32> {
    let t = globals.time * SPEED;
    let resolution = view.viewport.zw;

    var texture_uvs = in.uv;
    // texture_uvs *= rotate2D(1.0 + t); // Play with this to rotate the stars in the background.

    let tex: vec4f = textureSample(texture, texture_sampler, texture_uvs); // Shadertoy's ones don't seem to be affected by uvs modified in the scope of the functions that folk are writing so we take the uvs early do get around that.

    var uv = (in.uv * 2.0) - 1.0;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(PI / -2.0);
    var col = vec3f(0.0);
    // col.b = value_noise(uv, t); // Test the noise!

    // background
    let ray = vec3f(0.0);
    let bg = background(ray, tex);

    // disk 
    let zero_position = vec3f(0.0);
    let disk = raymarch_disk(ray, zero_position);


    // return bg;
    // return tex;
    return disk;
}


fn blackhole(uv: vec2f, iResolution: vec2f) -> vec4f {
    var colOut = vec4(0.0);

    var fragCoordRot = vec2f(0.0);
    fragCoordRot.x = fragCoord.x * 0.985 + fragCoord.y * 0.174;
    fragCoordRot.y = fragCoord.y * 0.985 - fragCoord.x * 0.174;
    fragCoordRot += vec2(-0.06, 0.12) * iResolution.xy;

    for (var j: i32 = 0; j < AA; j++) {
        for (var i: i32 = 0; i < AA; i++) {
        //setting up camera
            var ray: vec3f = normalize(vec3((fragCoordRot - iResolution.xy * .5 + vec2(i, j) / (float(AA))) / iResolution.x, 1));
            var pos: vec3f = vec3(0., 0.05, -(20. * iMouse.xy / iResolution.y - 10.0) * (20. * iMouse.xy / iResolution.y - 10.0) * .05);
            var angle: vec2f = vec2(iTime * 0.1, .2);

            angle.y = (2. * iMouse.y / iResolution.y) * 3.14 + 0.1 + 3.14;
            let dist: f32 = length(pos);
            rotate3D(pos, angle);

            angle.xy -= min(.3 / dist, 3.14) * vec2(1, 0.5);
            rotate(ray, angle);

            var col: vec4f = vec4(0.);
            var glow: vec4f = vec4(0.);
            var outCol: vec4f = vec4(100.);

            for (var disks: i32 = 0; disks < 20; disks++) //steps {

            for (var h: i32 = 0; h < 6; h++) { 
            //reduces tests for exit conditions (to minimise branching) 
                var dotpos: f32 = dot(pos, pos);
                var invDist: f32 = inversesqrt(dotpos); // 1/distance to BH
                var centDist: f32 = dotpos * invDist; 	// distance to BH
                var stepDist: f32 = 0.92 * abs(pos.y / (ray.y));  //conservative distance to disk (y==0)   
                var farLimit: f32 = centDist * 0.5; //limit step size far from to BH
                var closeLimit: f32 = centDist * 0.1 + 0.05 * centDist * centDist * (1. / BLACK_HOLE_SIZE); //limit step size closse to BH
                stepDist = min(stepDist, min(farLimit, closeLimit));

                var invDistSqr: f32 = invDist * invDist;
                var bendForce: f32 = stepDist * invDistSqr * BLACK_HOLE_SIZE * 0.625;  //bending force
                ray = normalize(ray - (bendForce * invDist) * pos);  //bend ray towards BH
                pos += stepDist * ray;

                glow += vec4(1.2, 1.1, 1, 1.0) * (0.01 * stepDist * invDistSqr * invDistSqr * clamp(centDist * (2.) - 1.2, 0., 1.)); //adds fairly cheap glow
            }

            var dist2: f32 = length(pos);

            if dist2 < BLACK_HOLE_SIZE * 0.1 { 
                //ray sucked in to BH 
                outCol = vec4(col.rgb * col.a + glow.rgb * (1. - col.a), 1.) ;
                        break;
            } else if dist2 > BLACK_HOLE_SIZE * 1000. { 
            // ray escaped
                var bg = background(ray, t);
                outCol = vec4f(col.rgb * col.a + bg.rgb * (1. - col.a) + glow.rgb * (1. - col.a), 1.);       
                        break;
            } else if abs(pos.y) <= BLACK_HOLE_SIZE * 0.002 { 
                        //ray hit accretion disk 
                var diskCol = raymarchDisk(ray, pos);   //render disk
                pos.y = 0.;
                pos += abs(BLACK_HOLE_SIZE * 0.001 / ray.y) * ray;
                col = vec4(diskCol.rgb * (1. - col.a) + col.rgb, col.a + diskCol.a * (1. - col.a));
            }
        }
   
            //if the ray never escaped or got sucked in
        if outCol.r == 100.0 {
            outCol = vec4(col.rgb + glow.rgb * (col.a + glow.a), 1.);

            col = outCol;
            col.rgb = pow(col.rgb, vec3(0.6));

            colOut += col / float(AA * AA);
        }
    }
    return colOut;
}



fn raymarch_disk(ray,:, vec3f, zero_position, : vec3f) -> vec4f {
    let t = globals.time * SPEED; // we don't have constant iTime and I like to control the speed of animations from const.

    // Probably the disk and its sizing?
    var position = zero_position;
    let len_pos: f32 = length(position.xz);
    let dist: f32 = min(1., len_pos * (1. / BLACK_HOLE_SIZE) * 0.5) * BLACK_HOLE_SIZE * 0.4 * (1. / BLACK_HOLE_SIZE) / (abs(ray.y)); //TODO break this up.

    position += dist * DISK_TEXTURE_LAYERS * ray * 0.5; // why 0.5

    //???
    var delta_pos = vec2f(0.0);
    delta_pos.x = -zero_position.z * 0.01 + zero_position.x;
    delta_pos.y = -zero_position.x * 0.01 + zero_position.z; // What happens wit h bigger values than 0.01 does this turn us around or something?
    delta_pos = normalize(delta_pos - zero_position.xz); // why xz?


    // Does what?
    var parallel: f32 = dot(ray.xz, delta_pos); // what does the dot do again?
    parallel /= sqrt(len_pos);
    parallel *= 0.5;
    var red_shift = parallel + 0.3;
    red_shift *= red_shift;
    red_shift = clamp(red_shift, 0.0, 1.0);

    var dis_mix = clamp((len_pos - BLACK_HOLE_SIZE * 2.0) * (1.0 / BLACK_HOLE_SIZE) * 0.25, 0.0, 1.0); // TODO: break this up.

    var inside_col: vec3f = mix(vec3f(1.0, 0.8, 0.0), vec3(1.6, 2.4, 4.0), red_shift);
    inside_col *= mix(vec3(0.4, 0.2, 0.1), vec3(1.6, 2.4, 4.0), red_shift);
    inside_col *= 1.25;
    red_shift += 0.12;
    red_shift *= red_shift;

    var out = vec4(0.0); // Initialise blanks to draw into.
    var o_rgb = vec3f(0.0);

    for (var i: f32 = 0.0; i < DISK_TEXTURE_LAYERS; i += 1.0) {
        //
        position -= dist * ray;

        var intensity: f32 = clamp(1.0 - abs((i - 0.8) * (1. / DISK_TEXTURE_LAYERS) * 2.0), 0.0, 1.0); // TODO: wtf these numbers do?
        var length_pos_local = length(position.xz);
        var dist_mult = 1.0;

        dist_mult *= clamp((length_pos_local - DISK_TEXTURE_LAYERS * 0.75) * (1.0 / DISK_TEXTURE_LAYERS) * 1.5, 0.0, 1.); // TODO: wtf these numbers do?
        dist_mult *= clamp((DISK_TEXTURE_LAYERS * 10. - length_pos_local) * (1.0 / DISK_TEXTURE_LAYERS) * 0.20, 0.0, 1.);  // TODO: wtf these numbers do?
        dist_mult *= dist_mult;

        let u = length_pos_local + t * DISK_TEXTURE_LAYERS * 0.3 + intensity * DISK_TEXTURE_LAYERS * 0.2;

        // -sin + cos, and sin cos is usually a rotation...
        let rot = t * (DISK_ROTATION_SPEED % 8192.0); //QUESTION: suspicious power of 2...
        let x: f32 = -position.z * sin(rot) + position.x * cos(rot);
        let y: f32 = position.x * sin(rot) + position.z * cos(rot);
        let xy = vec2f(x, y);


        let x_ab = abs(xy.x / (xy.y)); // That's slick.
        let angle = 0.02 * atan(x);

        let f = 70.0; // TODO: why? const?
        let lhs: vec2f = vec2f(angle, (u * (1.0 / BLACK_HOLE_SIZE) * 0.05));
        var noise: f32 = value_noise(lhs, f);
        noise = noise * 0.66 + 0.33 * value_noise(lhs, f * 2.); //QUESTION: this lhs was hard-coded in -- perhaps for good reason?


        let extra_width: f32 = noise * 1.0 * (1.0 - clamp(i * (1.0 / DISK_TEXTURE_LAYERS) * 2.0 - 1.0, 0.0, 1.0)); // TODO: (1.0/BLABLACK_HOLE_SIZE is used so many times we should just do it once...)

        // let lhs_clamp: f32 = noise * (intensity + extra_width) * ((1.0 / BLACK_HOLE_SIZE) * 10.0 + 0.01) * dist * dist_mult;
        let alpha: f32 = clamp(noise * (intensity + extra_width) * ((1.0 / BLACK_HOLE_SIZE) * 10.0 + 0.01) * dist * dist_mult, 0.0, 1.0);
        var col = 2.0 * mix(vec3(0.3, 0.2, 0.15) * inside_col, inside_col, min(1., intensity * 2.));
        out = clamp(vec4(col * alpha + out.rgb * (1. - alpha), out.a * (1. - alpha) + alpha), vec4(0.), vec4(1.));

        length_pos_local *= (1.0 / BLACK_HOLE_SIZE);

        o_rgb += red_shift * (intensity * 1.0 + 0.5) * (1.0 / DISK_TEXTURE_LAYERS) * 100.0 * dist_mult / (length_pos_local * length_pos_local);
    }

    o_rgb.r = clamp(o_rgb.r - 0.005, 0.0, 1.0);
    o_rgb.g = clamp(o_rgb.g - 0.005, 0.0, 1.0);
    o_rgb.b = clamp(o_rgb.b - 0.005, 0.0, 1.0);
    return vec4f(o_rgb, out.a);

    // return vec4f(1.0, 1.0, 1.0, 0.0); // no disk 
}


// Here's a breakdown of what the function does:
// 1. `vector.yz = cos(angle.y)*vector.yz + sin(angle.y)*vec2(-1,1)*vector.zy;`: This line rotates the vector around the y-axis. The `cos(angle.y)*vector.yz` term preserves the part of the vector that's aligned with the y-axis, while the `sin(angle.y)*vec2(-1,1)*vector.zy` term adds in the part of the vector that's perpendicular to the y-axis.
// 2. `vector.xz = cos(angle.x)*vector.xz + sin(angle.x)*vec2(-1,1)*vector.zx;`: This line rotates the vector around the x-axis in a similar way.
// The function modifies the input vector in place, meaning that after calling this function, the original vector will have been rotated by the specified angles.
// Please note that this function assumes that your vector components are arranged in a certain way (x, y, z). If your components are arranged differently, you may need to adjust which components are being rotated.
fn rotate3D(vector,:, vec3<f32, >, angle, : vec2<, f32>) -> vec3<f32> {
    var temp_yz = cos(angle.y) * vector.yz + sin(angle.y) * vec2<f32>(-1.0, 1.0) * vector.zy;
    var temp_xz = cos(angle.x) * vector.xz + sin(angle.x) * vec2<f32>(-1.0, 1.0) * vector.zx;
    return vec3<f32>(temp_xz.x, temp_yz.x, temp_yz.y);
}

fn background(ray,:, vec3f, texture, : vec4f) -> vec4f {
    var uv = ray.xy;
    if abs(ray.x) > 0.5 {
        uv.x = ray.z;
    } else if abs(ray.y) > 0.5 {
        uv.y = ray.z;
    }


    //
    var brightness = value_noise(uv * 3.0, 100.); // (dodgy stars), according to the comments in shadertoy
    var colour = value_noise(uv * 2.0, 20.); // why 20.?
    brightness = pow(brightness, 256.0); // why 256? const?
    brightness = brightness * 100.0; // *= 100.0 ??
    brightness = clamp(brightness, 0.0, 1.0);  // does what?


    var stars: vec3f = brightness * mix(vec3f(1.0, 0.6, 0.2), vec3f(0.2, 0.6, 1.0), colour); // what happens when you mess with these vec3's values?

    // var nebulae = textuxe(iChannel10, (uv*1.5)); // We have no textures so... have a think on that one.. (the shadertoy kid is using a galazy img.)
    var nebulae = texture.xyz;
    let nebulae_alpha = texture.a; // Keep this as we cannot swizzle with it
    nebulae += (nebulae.xxx + nebulae.yyy + nebulae.zzz);
    nebulae *= 0.25;

    // nebulae *= nebulae; //TODO loop, more pure math by multiplying a const?
    nebulae *= nebulae;
    nebulae *= nebulae;
    nebulae *= nebulae; // Yep.. they do it 4 times, which basically makes it darker


    nebulae += stars;


    return vec4f(nebulae, 1.0);
}

// Creates a pretty even noise (I have no idea how...)
fn value_noise(p,:, vec2f, f, : f32) -> f32 {
    let b1: f32 = hash21(floor(p * f + vec2(0.0, 0.)));
    let br: f32 = hash21(floor(p * f + vec2(1.0, 0.)));
    let t1: f32 = hash21(floor(p * f + vec2(0.0, 1.)));
    let tr: f32 = hash21(floor(p * f + vec2(1.0, 1.)));

    var fr = fract(p * f);
    fr = (3.0 - 2.0 * fr) * fr * fr;
    let b = mix(b1, br, fr.x);
    let t = mix(t1, tr, fr.x);

    return mix(b, t, fr.y);
}

// Hash 2 into 1
fn hash21(x,:, vec2f) -> f32 {
    return (hash(x.x + hash(x.y)));
}
// Hash 1 into 1
fn hash(x,:, f32) -> f32 {
    return fract(sin(x) * 152754.742);
}
