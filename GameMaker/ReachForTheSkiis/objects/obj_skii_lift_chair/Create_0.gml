enum EChairState {
	HeadedToSouthEntrance,
	HeadedToNorthEntrance,
	FollowingSouthEntrance,
	HeadedNorth,
	HeadedSouth,
	FollowingNorthEntrance
}

current_state = EChairState.HeadedNorth;
next_pole = noone;
entrance = noone;
spd = 1;
image_speed = 0;

IMAGE_INDEX_SOUTH = 0;
IMAGE_INDEX_NORTH = 1;
IMAGE_INDEX_EAST = 2;
IMAGE_INDEX_WEST = 3;

passengers = [];
accepting_passengers = false;


var _linker = instance_place(x, y, obj_skii_lift_linker);

if (instance_exists(_linker)) {
	with (_linker) {
		var _poles = instance_place_array(x, y, obj_skii_lift_pole);
		if (array_length(_poles) == 2) {
			if (_poles[0].y > _poles[1].y) {
				_poles = [_poles[1], _poles[0]];	
			}
			
			
			other.next_pole = other.current_state == EChairState.HeadedNorth ? _poles[0] : _poles[1];
			other.x = other.next_pole.x + (other.current_state == EChairState.HeadedNorth ? other.next_pole.line_anchor_north : other.next_pole.line_anchor_south);
			other.y = other.next_pole.y;
		}
	}
}