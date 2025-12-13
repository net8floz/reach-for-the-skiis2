if (live_call()) return live_result;

if (!on_screen) {
	exit;
}

draw_sprite(sprite_index, image_index, visual_x, visual_y);
