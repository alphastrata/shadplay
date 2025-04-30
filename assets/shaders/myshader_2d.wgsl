/// ***************************** ///
/// Port of https://www.shadertoy.com/view/M32GW3
// void mainImage( out vec4 o, vec2 u ){
//     float t = iTime , z;
//     vec2  R = iResolution.xy,
//           p = 2.* ( u+u - R ) / R.x ;                     // centered coords
//     p /= .2 + .3* sqrt( z = max( 1.-dot(p,p), 0.) ),      // sphere. z = depth
//     p.y += fract( ceil( p.x = p.x/.9 + t ) / 2. ) + t*.2, // hexa: offset odd rows
//     p = abs( fract(p) - .5 ),                             // tiling + symmetries
//     o =   vec4(2,3,5,1)/20. * z                           // pseudo-shading
//         / ( .1 + abs( max( p, p.x*1.5 ) + p - 1. ).y );   // pattern: draw 2 lines
// }
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

// ======== CONTROL PARAMS ========
const ANIMATION_SPEED: f32 = 1.0;
const HEXAGON_STRETCH: f32 = 0.9;
const EDGE_ANGLE: f32 = 1.5;

// ======== EFFECT TOGGLES ========
// Uncomment these to disable certain effects
// #define DISABLE_SPHERE_DISTORTION
// #define DISABLE_HEX_OFFSET
// #define DISABLE_TILING
// #define DISABLE_SYMMETRY
// #define DISABLE_ANIMATION

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // 1. BASE COORDINATE SYSTEM =================================
    var position = 2.0 * (in.uv - 0.5) * vec2(view.viewport.z / view.viewport.w, 1.0);
    
    // 2. SPHERICAL DISTORTION =================================
    #ifndef DISABLE_SPHERE_DISTORTION
        let depth_factor = max(1.0 - dot(position, position), 0.0);
        position /= 0.2 + 0.3 * sqrt(depth_factor);
    #else
        let depth_factor = 1.0;
    #endif

    // 3. HEXAGON GRID STRUCTURE ===============================
    #ifdef DISABLE_ANIMATION
        let current_time = 0.0;
    #else
        let current_time = globals.time * ANIMATION_SPEED;
    #endif
    
    position.x = position.x / HEXAGON_STRETCH + current_time;
    
    #ifndef DISABLE_HEX_OFFSET
        let column_number = ceil(position.x);
        position.y += fract(column_number * 0.5) + current_time * 0.2;
    #endif

    // 4. TILING AND SYMMETRY =================================
    #ifdef DISABLE_TILING
        let pattern_coord = position;
    #else
        let pattern_coord = fract(position);
    #endif
    
    #ifdef DISABLE_SYMMETRY
        let symmetrical_coord = pattern_coord;
    #else
        let symmetrical_coord = abs(pattern_coord - 0.5);
    #endif

    // 5. HEXAGON SHAPE DEFINITION ============================
    let hex_edge = max(symmetrical_coord, symmetrical_coord.xx * vec2(EDGE_ANGLE, 0.0));
    let hexagon_edges = hex_edge.x + hex_edge.y - 1.0;
    let pattern_value = 0.1 + abs(hexagon_edges);

    // 6. FINAL COLOR OUTPUT ==================================
    let base_color = vec3f(2.0, 3.0, 5.0) / 20.0;
    return vec4f(
        base_color * depth_factor / pattern_value,
        1.0
    );
}