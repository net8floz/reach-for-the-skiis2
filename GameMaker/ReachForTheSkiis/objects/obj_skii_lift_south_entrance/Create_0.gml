if (live_call()) { return live_result; }

next_pole = noone;

points = [];
chairs = [];

line_offset_south_x = 0;
line_offset_north_x = sprite_width;
line_z = sprite_height;

chair_interpolation_percent = 0;

handle_awake = function() {

	var _poles = []
	
	with (obj_skii_lift_pole) {
		array_push(_poles, [id, y]);	
	}
	
	array_sort(_poles, function(_a, _b) {
		return _b[1] - _a[1];
	});
	
	next_pole = _poles[0][0];
	next_pole.south_entrance = id;
	
	for (var _i = 1; _i < array_length(_poles); _i++) {
		_poles[_i - 1][0].next_pole = _poles[_i][0];
		_poles[_i][0].previous_pole = _poles[_i -1][0];
	}
	
	var _last = _poles[array_length(_poles) - 1][0];
	

	var _north_entrance = instance_nearest(_last.x, _last.y, obj_skii_lift_north_entrance);
	if (instance_exists(_north_entrance)) {
		_last.north_entrance = _north_entrance;
		_north_entrance.next_pole = _last;
	}	

	static IMAGE_INDEX_SOUTH = 0;
	static IMAGE_INDEX_NORTH = 1;
	static IMAGE_INDEX_EAST = 2;
	static IMAGE_INDEX_WEST = 3;
	
	var _point_sep = 10;
	var _current = id;
	var _headed_north = true;

	push_point = function(_point) {
		
		if (_point.is_entrance == false) {
			if (array_length(points) > 0) {
				var _last_point = points[array_length(points) - 1];
				var _point_sep = 10;
			
				
				if (_last_point.z == _point.z) {
					if (point_distance(_last_point.x, _last_point.y, _point.x, _point.y) < _point_sep / 2) {
						return;	
					}
				}
			}
		}
		
		array_push(points, _point);
	}
	
	build_points_to_target = method(id, function(_x, _y, _z, _target_x, _target_y, _target_z, _image_index, _point_sep, _is_entrance) {

		var _total_dist_x = _target_x - _x;
		var _total_dist_y = _target_y - _y;
		var _total_dist_squared = _total_dist_x * _total_dist_x + _total_dist_y * _total_dist_y;
		var _next_z = _target_z;
		
		while (_x != _target_x || _y != _target_y) {
			var _dx = _target_x - _x;
			var _dy = _target_y - _y;
			var _dist_squared = _dx * _dx + _dy * _dy;
		
			if (_dist_squared <= _point_sep * _point_sep) {
				_x = _target_x;
				_y = _target_y;
			} else {
				var _a = point_direction(_x, _y, _target_x, _target_y);
				_x += lengthdir_x(_point_sep, _a);
				_y += lengthdir_y(_point_sep, _a);
				
				_dx = _x - _target_x;
				_dy = _y - _target_y;
				_dist_squared = _dx * _dx + _dy * _dy;

				var _t = 1 - (sqrt(_dist_squared) / sqrt(_total_dist_squared))

				var ease_power = 2
				var curve_a = 3
				var curve_b = 2

				var _c = power(_t, ease_power) * (curve_a - curve_b * _t)
				_next_z = lerp(_z, _target_z, _c)
				push_point({
					x: _x,
					y: _y,
					z: _next_z,
					image_index: _image_index,
					is_entrance: _is_entrance
				});
			
			}
			

		}
	});
	
	while (instance_exists(_current)) {
		

		if (_current.object_index == obj_skii_lift_pole) {
			
			var _target;
			
			if (_headed_north) {
				_target = _current.next_pole;
				if (_target == noone) {
					_target = _current.north_entrance;	
				}
			} else {
				_target = _current.previous_pole;	
				
				if (_target == noone) {
					_target = _current.south_entrance;
				}
			}
			
			assert(instance_exists(_target));


			if (instance_exists(_target)) {
				var _target_x = _target.x + (_headed_north ? _target.line_offset_north_x : _target.line_offset_south_x);
				var _target_y = _target.y;
				var _target_z = _target.line_z;
				
				build_points_to_target(
					_current.x + (_headed_north ? _target.line_offset_north_x : _target.line_offset_south_x), 
					_current.y, 
					_current.line_z, 
					_target_x, 
					_target_y, 
					_target_z, 
					_headed_north ? IMAGE_INDEX_NORTH : IMAGE_INDEX_SOUTH, 
					_point_sep,
					false);
				
				_current = _target;
			} else {
				_current = noone;	
			}
			
		} else if ((_current.object_index == obj_skii_lift_south_entrance && _headed_north) || _current.object_index == obj_skii_lift_north_entrance && !_headed_north) {
			
				var _target_x = _current.next_pole.x + (_headed_north ? _current.next_pole.line_offset_north_x : _current.next_pole.line_offset_south_x);
				var _target_y = _current.next_pole.y;
				var _target_z = _current.next_pole.line_z;
				
				build_points_to_target(
					_current.x + (_headed_north ? _current.line_offset_north_x : _current.line_offset_south_x), 
					_current.y, 
					_current.line_z, 
					_target_x, 
					_target_y, 
					_target_z, 
					_headed_north ? IMAGE_INDEX_NORTH : IMAGE_INDEX_SOUTH, 
					_point_sep,
					false);
				
				
				_current = _current.next_pole;
			
		} else if ((_current.object_index == obj_skii_lift_south_entrance && !_headed_north) || _current.object_index == obj_skii_lift_north_entrance && _headed_north) {
			var _target_x = _current.x + (!_headed_north ? _current.line_offset_north_x : _current.line_offset_south_x);
			var _target_y = _current.y;
			var _target_z = _current.line_z;
			var _curve_height = _headed_north ? -5 : 12;
			var _dir_x = _headed_north ? -1 : 1;
				
				
			var _x = _current.x +  (_headed_north ? _current.line_offset_north_x : _current.line_offset_south_x);
			var _y = _current.y;
				
			while (_x != _target_x || _y != _target_y) {
				_x += _dir_x * (_point_sep * 0.7) / 2;
				
				var _arrived = _headed_north ? _x <= _target_x : _x >= _target_x;
				
				var _image_index = _headed_north ? IMAGE_INDEX_NORTH : IMAGE_INDEX_SOUTH;
				
				if (_arrived) {
					_x = _target_x;
					_y = _target_y;
				} else {
					
					var _t = clamp((_x - _current.x) / _current.line_offset_north_x, 0, 1);
					var _w = sin(_t * pi);	
					
					if (_w > 0.5) {
						// near the curve apex
						_image_index = !_headed_north
							? IMAGE_INDEX_EAST
							: IMAGE_INDEX_WEST;
					} else {
						if (_t > 0.5) {
							// finishing the curve 
							_image_index = IMAGE_INDEX_NORTH;
						} else {
							// starting the curve
							_image_index = IMAGE_INDEX_SOUTH;
						}
					}
					
					_y = _target_y + _w * _curve_height;
				}
					
				push_point({
					x: _x,
					y: _y,
					z: _target_z,
					image_index: _image_index,
					is_entrance: true
				});
			}
			
			_headed_north = !_headed_north;
			
			if (_headed_north) {
				// have reached the end
				_current = noone;
			}
		}
	}
	
	
	for (var _i = 0, _iterated_point = 0; _i < array_length(points); _i++) {
		if (points[_i].is_entrance) {
			continue;	
		}
		
		var _point = points[_i];
		
		static _points_per_chair = 12;
		if (_iterated_point % _points_per_chair == 0) {
			var _chair = instance_create_depth(_point.x, _point.y, 0, obj_skii_lift_chair);
			_chair.system = id;
			_chair.z = _point.z;
			_chair.next_point_index = _i;
			_chair.last_point_index = _i - 1;
			
			if (_chair.last_point_index < 0) {
				_chair.last_point_index = array_length(points) - 1;	
			}
			
			array_push(chairs, _chair);
		}
		
		_iterated_point++;
	}
}


