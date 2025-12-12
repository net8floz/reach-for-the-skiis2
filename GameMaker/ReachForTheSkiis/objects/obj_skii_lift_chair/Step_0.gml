accepting_passengers = false;

switch (current_state) {
	case EChairState.HeadedNorth:
	case EChairState.HeadedSouth:
		var _target_x = next_pole.x + (current_state == EChairState.HeadedNorth ? next_pole.line_anchor_north : next_pole.line_anchor_south);
		var _target_y = next_pole.y;
		var _dx = _target_x - x;
		var _dy = _target_y - y;
		var _a = point_direction(0, 0, _dx, _dy);
		
		image_index = current_state == EChairState.HeadedNorth 
			? IMAGE_INDEX_NORTH 
			: IMAGE_INDEX_SOUTH;
		
		x += lengthdir_x(spd, _a);
		y += lengthdir_y(spd, _a);
		
		if (_dx * _dx + _dy * _dy < 2) {
			x = _target_x;
			y = _target_y;
			
			if (current_state == EChairState.HeadedNorth) {
				if (instance_exists(next_pole.north_entrance)) {
					entrance = next_pole.north_entrance;
					current_state = EChairState.HeadedToNorthEntrance;
					exit;
				} else if (instance_exists(next_pole.next_pole)) {
					next_pole = next_pole.next_pole;
					exit;
				}
			} else if (current_state == EChairState.HeadedSouth) {
				if (instance_exists(next_pole.south_entrance)) {
					entrance = next_pole.south_entrance;
					current_state = EChairState.HeadedToSouthEntrance;
					exit;
				} else if (instance_exists(next_pole.previous_pole)) {
					next_pole = next_pole.previous_pole;
					exit;
				}
			}
		}
		
		break;
	case EChairState.HeadedToSouthEntrance:
	case EChairState.HeadedToNorthEntrance:
		var _target_x = entrance.x + (current_state == EChairState.HeadedToNorthEntrance ? next_pole.line_anchor_north : next_pole.line_anchor_south);
		var _target_y = entrance.y + (current_state == EChairState.HeadedToNorthEntrance ? 10 : 0);
		
		var _dx = _target_x - x;
		var _dy = _target_y - y;
		var _a = point_direction(0, 0, _dx, _dy);
		
		x += lengthdir_x(spd, _a);
		y += lengthdir_y(spd, _a);
		
		if (_dx * _dx + _dy * _dy < 2) {
			x = _target_x;
			y = _target_y;
			
			if (current_state == EChairState.HeadedToNorthEntrance) {
				current_state = EChairState.FollowingNorthEntrance;
			} else {
				current_state = EChairState.FollowingSouthEntrance;
			}
			exit;
		}
		break;
	case EChairState.FollowingSouthEntrance:
	case EChairState.FollowingNorthEntrance:
		
		var _x_dir = 1;
		var _y_position = entrance.y;
		var _curve_height = 15;
		
		if (current_state == EChairState.FollowingNorthEntrance) {
			_x_dir = -1;
			_y_position = entrance.y + 10;
			_curve_height = 9;
		}
		
		x += spd * 0.7 * _x_dir;
		
		var _t = clamp((x - entrance.x) / entrance.sprite_width, 0, 1);
		var _w = sin(_t * pi);	

		if (_w > 0.5) {
			accepting_passengers = true;
			// near the curve apex
			image_index = current_state == EChairState.FollowingSouthEntrance
				? IMAGE_INDEX_EAST
				: IMAGE_INDEX_WEST;
		} else {
			if (_t > 0.5) {
				// finishing the curve 
				image_index = IMAGE_INDEX_NORTH;
			} else {
				// starting the curve
				image_index = IMAGE_INDEX_SOUTH;
			}
		}
		
		// _x_dir happens to be the right direction for y also
		y = _y_position + _w * _curve_height * _x_dir;
		
		var _arrived_at_destination = current_state == EChairState.FollowingSouthEntrance
			? x >= entrance.x + entrance.sprite_width
			: x <= entrance.x;
		
		if (_arrived_at_destination) {
			x = current_state == EChairState.FollowingSouthEntrance
				? entrance.x + entrance.sprite_width
				: entrance.x;
			
			y = _y_position;
			
			current_state = current_state == EChairState.FollowingSouthEntrance
				? EChairState.HeadedNorth
				: EChairState.HeadedSouth
				
			next_pole = entrance.next_pole;
			entrance = noone;
			exit;
		}
		
		break;
}

depth = -9999;