#define_import_path shaders::myshadertools

fn rgb2hsb(c: vec3<f32>) -> vec3<f32> {
    let K: vec4<f32> = vec4<f32>(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    let p: vec4<f32> = mix(vec4<f32>(c.b, c.g, K.wz), vec4<f32>(c.g, c.b, K.xy), step(c.b, c.g));
    let q: vec4<f32> = mix(vec4<f32>(p.xyw, c.r), vec4<f32>(c.r, p.yzx), step(p.x, c.r));
    let d: f32 = q.x - min(q.w, q.y);
    let e: f32 = 1.0e-10;
    return vec3<f32>(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

fn hsb2rgb(c: vec3<f32>) -> vec3<f32> {
    let rgb: vec3<f32> = clamp(abs(mod(c.x * 6.0 + vec3<f32>(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    let rgb: vec3<f32> = rgb * rgb * (3.0 - 2.0 * rgb);
    return c.z * mix(vec3<f32>(1.0), rgb, c.y);
}
