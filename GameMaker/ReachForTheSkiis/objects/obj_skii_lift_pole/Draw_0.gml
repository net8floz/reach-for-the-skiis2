draw_self();

draw_set_color(c_black);

if (next_pole != noone) {
	for (var _i = 0; _i < 4; _i++) {
		draw_line(x + _i, y + _i, next_pole.x + _i, next_pole.y + _i);
	}
	
	for (var _i = 0; _i < 4; _i++) {
		draw_line(x + _i + sprite_width, y + _i, next_pole.x + _i + sprite_width, next_pole.y + _i);
	}
}


if (instance_exists(south_entrance)) {
	for (var _i = 0; _i < 4; _i++) {
		draw_line(x + _i, y + _i, south_entrance.x + _i, south_entrance.y + _i);
	}
	
	for (var _i = 0; _i < 4; _i++) {
		draw_line(x + _i + sprite_width, y + _i, south_entrance.x + _i + sprite_width, south_entrance.y + _i);
	}	
}