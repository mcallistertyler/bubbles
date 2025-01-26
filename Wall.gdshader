shader_type canvas_item;

uniform vec4 background_color: source_color = vec4(0.3, 0.2, 0.8, 1.0); // Background color
uniform vec3 bubble_color: source_color = vec3(0.0, 0.5, 1.0); // Color of the bubbles
uniform float bubble_opacity: hint_range(0.0, 1.0) = 0.5;    // Opacity of the bubbles
uniform float bubble_speed: hint_range(0.0, 1.0) = 0.1;      // Speed of bubble motion
uniform int bubble_count: hint_range(1, 1000) = 20;            // Number of bubbles

float get_particle_x(int i) {
    return (sin(float(i)) * 0.5) * (sin(float(i) * 6.0) + 0.5) * 1.75 + 0.5;
}

void vertex() {
}

void fragment() {
    // Start with the specified background color
    vec4 col = background_color;
    
    // BUBBLES
    for (int i = 1; i <= bubble_count; i++) {
        float particle_x = get_particle_x(i);
        float time_offset = get_particle_x(i + 2) * 40.0;
        float speed_offset = get_particle_x(i + 3) * bubble_speed;
        float scale_factor = get_particle_x(i + 5) * 0.01;
        
        // Generate a particle position that animates upward
        vec2 particle = vec2(particle_x, (fract((TIME + time_offset) * (-0.06 * speed_offset)) * 2.0) - 0.5);
        
        // Generate circles based on length from point in UV
        float circle = step(length(UV - particle), 0.04 - scale_factor);
        float inner_circle = step(length(UV - particle), (0.04 - scale_factor) - (2.0 * SCREEN_PIXEL_SIZE.y));
        
        // Create bubble with simple opacity
        vec4 bubble_col = vec4(bubble_color, bubble_opacity);
        
        // Add bubbles to the final color
        col.rgb = mix(col.rgb, bubble_col.rgb, circle - inner_circle * 0.7);
        col.a = max(col.a, (circle - inner_circle * 0.7) * bubble_col.a);
    }
    
    COLOR = col;
}