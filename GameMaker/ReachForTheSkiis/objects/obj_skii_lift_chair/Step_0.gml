switch (current_state) {
	case EChairState.HeadedNorth:
		
		var _dx = next_pole.x - x;
		var _dy = next_pole.y - y;
		var _a = point_direction(0, 0, _dx, _dy);
		
		x += lengthdir_x(spd, _a);
		y += lengthdir_y(spd, _a);
		
		if (_dx * _dx + _dy * _dy < 2) {
			x = next_pole.x;
			y = next_pole.y;
			
			if (instance_exists(next_pole.next_pole)) {
				next_pole = next_pole.next_pole;
			}
		}
		
		
		
		break;
}