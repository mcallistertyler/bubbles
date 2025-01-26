shader_type canvas_item;

uniform vec4 circle_color: source_color = vec4(0.3, 0.5, 1.0, 0.7); // Blue with 0.7 opacity
uniform vec3 outline_color: source_color = vec3(1.0, 1.0, 1.0); // White outline
uniform float outline_width: hint_range(0.0, 10.0) = 2.0; // Outline thickness in pixels

void fragment() {
    // Get the center of the UV coordinates
    vec2 center = vec2(0.5, 0.5);
    float dist = length(UV - center);

    // Convert outline width from pixels to UV space
    float outline_thickness = outline_width * SCREEN_PIXEL_SIZE.x;

    // Draw the circle (inner radius is now affected by outline width)
    float inner_radius = 0.45;
    float circle = step(dist, inner_radius - outline_thickness);

    // Draw the outline (using the pixel-adjusted thickness)
    float outline = step(dist, inner_radius) - step(dist, inner_radius - outline_thickness);

    // Combine them
    vec4 final_color = vec4(0.0);
    final_color += circle_color * circle;
    final_color += vec4(outline_color, 1.0) * outline;

    COLOR = final_color;
}