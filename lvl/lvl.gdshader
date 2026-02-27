shader_type canvas_item;

uniform float intensity : hint_range(0.0, 3.0) = 1.0;
uniform float softness : hint_range(0.0, 1.0) = 0.45;

void fragment() {
    // Проверь, чтобы тут было именно 0.5 (центр UV)
    float dist = distance(UV, vec2(0.5));
    float vignette = smoothstep(0.5, 0.5 - softness, dist * intensity);
    
    // Рисуем абсолютно черный цвет с маской прозрачности
    COLOR = vec4(0.0, 0.0, 0.0, 1.0 - vignette);
}