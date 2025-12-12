draw_self();

if (next_pole != noone) {
	for (var _i = 0; _i < 4; _i++) {
		draw_line(x + _i, y + _i, next_pole.x + _i, next_pole.y + _i);
	}
	
	for (var _i = 0; _i < 4; _i++) {
		draw_line(x + _i + sprite_width, y + _i, next_pole.x + _i + sprite_width, next_pole.y + _i);
	}
}