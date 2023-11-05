#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::forward_io::VertexOutput
//
// Two simple voronoi shaders from https://www.youtube.com/watch?v=l-07BXzNdPw&t=19s&ab_channel=TheArtofCode
// Ported here to wgsl, I've tried to use the same varnames etc so you can benefit from Martien's fantastic videos.
//

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // just comment in/out the one you want to see and save this file!

    return non_simple(in);
    // return simple_non_uniform(in);
}

fn non_simple(in: VertexOutput) -> vec4<f32>{
    var uv: vec2<f32> = in.uv;
    var m = 0.;
    let t = globals.time / 10.0;

    var min_dist = 100.0;
    var col = vec3(0.0);
    var d = 0.;

    uv *= 5.0;
    let gv = fract(uv);
    let id = floor(uv);
    var cell_id = vec2(0.);

    for (var i = -1.; i<1.; i+=1.){
        for (var j = -1.; j<1.; j+=1.){
            var offset = vec2(i,j);
            let n = N22(id + offset);
            var p = sin(n*t * 3.0);

            // Use Euclidian distance:
            let ed = length(gv - p);

            // //Using Manhattan distance:
            p -= gv;
            var md = length(gv - p);
            md = abs(p.x)+abs(p.y);

            // // Interprolate between the euc and manha:
            d = mix(ed, md, sin(t *.2));
            
            if d < min_dist{
                min_dist = d;
                offset = offset + id;
                cell_id = offset;
            }
        }
    }
    col = vec3(min_dist);

    return vec4(col, 1.0);
}

fn simple_non_uniform(in: VertexOutput) -> vec4<f32> {
    let uv: vec2<f32> = in.uv;

    var m = 0.;
    let t = globals.time / 10.0;
    var min_dist = 100.;
    var cell_idx = 0;

    for (var i = 0; i < 200; i += 1) {
        let n = N22(vec2(f32(i)));
        let p = sin(n*t*3.0);
        let d = length(uv - p);

        if d < min_dist {
            min_dist = d;
            cell_idx = i;
        }
    }

    var col = vec3(f32(cell_idx)/200.0);
    return vec4(col, 1.0);
}
    

// Noise: two in -> two out in range [0..1]
fn N22(pp: vec2<f32>)->vec2<f32>{
    var a = fract(pp.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a, a + 34.45);
    return fract(vec2(a.x*a.y, a.y*a.z));
}
