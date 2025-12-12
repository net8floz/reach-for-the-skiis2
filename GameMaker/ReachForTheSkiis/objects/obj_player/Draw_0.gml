if (live_call()) return live_result;

draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

if (replication.controlled_proxy) {
	draw_set_color(c_fuchsia);
	draw_set_alpha(0.1);

	var _segments = 16;
	for (var _i = 0; _i < 360; _i+= (360/_segments)) {
		draw_line(x, y, x + lengthdir_x(1000, _i), y + lengthdir_y(1000, _i)); 	
	}

	var _dist_from_mouse = point_distance(x, y, mouse_x, mouse_y);
	var _speed_mod = clamp(_dist_from_mouse / 300, 0, 1);

	draw_set_alpha(0.8)
	var _color = merge_colour(c_red, c_green, _speed_mod)
	draw_set_color(_color);
	//draw_line(x, y, mouse_x, mouse_y);

	draw_set_alpha(1);
}

if (z > 0) {
	draw_set_color(c_black);
	draw_set_alpha(0.2);
	var _size_min = 0;
	var _size_max = 6;
	
	var _t = clamp(z/50, 0, 1);
	
	draw_circle(x, y + 12, lerp(_size_min, _size_max, _t), false);	
	draw_set_alpha(1);
}


// DEBUG
draw_text(x, y + 10, string(ground_friction));
draw_text(x, y + 20, string(speed_y));
draw_text(x, y + 30, string(speed_x));