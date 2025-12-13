if (live_call()) return live_result;
accepting_passengers = false;

switch (current_state) {
	case EChairState.HeadedNorth:
	case EChairState.HeadedSouth:
		target_x = next_pole.x + (current_state == EChairState.HeadedNorth ? next_pole.line_anchor_north : next_pole.line_anchor_south);
		target_y = next_pole.y + pole_height;
		target_z = pole_height;
		
		var _dx = target_x - x;
		var _dy = target_y - y;
		var _dist_squared = _dx * _dx + _dy * _dy;
		var _a = point_direction(0, 0, _dx, _dy);
		
		image_index = current_state == EChairState.HeadedNorth 
			? IMAGE_INDEX_NORTH 
			: IMAGE_INDEX_SOUTH;
		
		x += lengthdir_x(spd, _a);
		y += lengthdir_y(spd, _a);
		
		if (_dist_squared <= spd * spd) {
			x = target_x;
			y = target_y;
			last_target_x = target_x;
			last_target_y = target_y;
			last_target_z = target_z;
			
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
		target_x = entrance.x + (current_state == EChairState.HeadedToNorthEntrance ? next_pole.line_anchor_north : next_pole.line_anchor_south);
		target_y = entrance.y + (current_state == EChairState.HeadedToNorthEntrance ? 10 : 0);
		target_z = entrance_height;

		var _dx = target_x - x;
		var _dy = target_y - y;
		var _dist_squared = _dx * _dx + _dy * _dy;
		var _a = point_direction(0, 0, _dx, _dy);
		
		x += lengthdir_x(spd, _a);
		y += lengthdir_y(spd, _a);
		
		if (_dist_squared <= spd * spd) {
			x = target_x;
			y = target_y;
			last_target_x = x;
			last_target_y = y;
			last_target_z = target_z;
			
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
		z = entrance_height;
		
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
		
		target_x = x;
		target_y = y;
		target_z = z;
		last_target_x = x;
		last_target_y = y;
		last_target_z = z;
		
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

if (z != target_z) {
	var _total_distance = point_distance(target_x, target_y, last_target_x, last_target_y);
	var _current_distance = point_distance(x, y, target_x, target_y);
		
	if (_total_distance == 0) {
		z = target_z;
	} else {
		z = lerp(target_z, last_target_z, _current_distance / _total_distance);
	}
}
		
depth = -9999;