enum EChairState {
	FollowingSouthEntrance,
	HeadedNorth,
	HeadedSouth,
	FollowingNorthEntrance
}

current_state = EChairState.HeadedNorth;
next_pole = noone;
previous_pole = noone;
entrance = noone;
spd = 0.5;


var _linker = instance_place(x, y, obj_skii_lift_linker);

if (instance_exists(_linker)) {
	var _x = 0;	
	
	with (_linker) {
		var _poles = instance_place_array(x, y, obj_skii_lift_pole);
		if (array_length(_poles) == 2) {
			if (_poles[0].y > _poles[1].y) {
				_poles = [_poles[1], _poles[0]];	
			}
			other.next_pole = _poles[0];
			other.previous_pole = _poles[1];
		}
	}
}