next_pole = noone;

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
}
