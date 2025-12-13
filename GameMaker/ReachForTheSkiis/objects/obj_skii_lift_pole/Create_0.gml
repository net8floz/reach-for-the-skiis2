next_pole = noone;
previous_pole = noone;
south_entrance = noone;
north_entrance = noone;

line_anchor_south = 0;
line_anchor_north = sprite_width;

handle_awake = function() {
	with (instance_create_depth(x + line_anchor_south,y, 0, obj_skii_lift_chair)) {
		current_state = EChairState.HeadedSouth;	
	}
	
	with (instance_create_depth(x + line_anchor_north,y, 0, obj_skii_lift_chair)) {
		current_state = EChairState.HeadedNorth;	
	}
}