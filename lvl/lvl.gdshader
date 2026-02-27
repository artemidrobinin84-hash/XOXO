shader_type canvas_item;

uniform float intensity : hint_range(0.0, 2.0) = 0.5;
uniform float softness : hint_range(0.0, 2.0) = 1.0;
uniform float inner_brightness : hint_range(0.0, 1.0) = 0.0;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    
    vec2 position = (UV - vec2(0.5)) * 2.0;
    float dist = length(position);
    
    float mask = smoothstep(0.4, 1.5 - softness, dist) * intensity;
    
    vec3 final_color = mix(vec3(1.0 + inner_brightness), vignette_color.rgb, mask);
    
    COLOR = vec4(vignette_color.rgb, mask);
}