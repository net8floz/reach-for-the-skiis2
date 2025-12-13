if (live_call()) { return live_result; }

var _chair_tick_rate = 10;
chair_interpolation_percent = (global.ticker.ticker % _chair_tick_rate) / _chair_tick_rate;

if (global.ticker.ticker % _chair_tick_rate == 0) {
	for (var _i = 0; _i < array_length(chairs); _i++) {
		var _chair = chairs[_i];

		_chair.next_point_index += 1;
		_chair.last_point_index += 1;
			
		if (_chair.next_point_index >= array_length(points)) {
			_chair.next_point_index = 0;	
		}
			
		if (_chair.last_point_index >= array_length(points)) {
			_chair.last_point_index = 0;	
		}
		
		_chair.last_x = points[_chair.last_point_index].x;
		_chair.last_y = points[_chair.last_point_index].y;
		_chair.last_z = points[_chair.last_point_index].z;
		
		_chair.next_x = points[_chair.next_point_index].x;
		_chair.next_y = points[_chair.next_point_index].y;
		_chair.next_z = points[_chair.next_point_index].z;
		
		_chair.image_index = points[_chair.next_point_index].image_index;
	}
}