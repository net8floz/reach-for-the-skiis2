if (live_call()) return live_result;

on_screen = true;

x = lerp(last_x, next_x, system.chair_interpolation_percent);
y = lerp(last_y, next_y, system.chair_interpolation_percent);
z = lerp(last_z, next_z, system.chair_interpolation_percent);

y -= z;

if (on_screen) {
visual_x += (x-visual_x) * 0.1;
visual_y += (y-visual_y) * 0.1;
} else {
	visual_x = x;
	visual_y = y;
}

var IMAGE_INDEX_EAST = 2;
var IMAGE_INDEX_WEST = 3;
	
accepting_passengers = image_index == IMAGE_INDEX_EAST || image_index == IMAGE_INDEX_WEST;

depth = calculate_instance_scene_depth(id);