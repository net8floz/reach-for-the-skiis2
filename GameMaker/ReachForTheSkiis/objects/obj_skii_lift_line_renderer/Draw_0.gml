if (live_call()) { return live_result; }

draw_set_color(c_black);
draw_set_alpha(0.4);

with (obj_skii_lift_pole) {
	if (instance_exists(next_pole)) {
		other.draw_lines_from_to(id, next_pole);
	}
	
	if (instance_exists(north_entrance)) {
		other.draw_lines_from_to(id, north_entrance);
	}
	
	if (instance_exists(south_entrance)) {
		other.draw_lines_from_to(id, south_entrance);
	}
}

draw_set_alpha(1);
draw_set_color(c_white);