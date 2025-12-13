
handle_awake = function() {
	var _south_entrance = instance_place(x, y, obj_skii_lift_south_entrance);
	var _north_entrance = instance_place(x, y, obj_skii_lift_north_entrance);

	if (instance_exists(_south_entrance)) {
		var _pole = instance_place(x, y, obj_skii_lift_pole);
	
		if (instance_exists(_pole)) {
			_pole.south_entrance = _south_entrance;
			_south_entrance.next_pole = _pole;
		}
	}

	if (instance_exists(_north_entrance)) {
		var _pole = instance_place(x, y, obj_skii_lift_pole);
	
		if (instance_exists(_pole)) {
			_pole.north_entrance = _north_entrance;
			_north_entrance.next_pole = _pole;
		}
	}

	var _poles = instance_place_array(x, y, obj_skii_lift_pole);

	if (array_length(_poles) == 2) {
		if (_poles[0].y > _poles[1].y) {
			_poles = [_poles[1], _poles[0]];	
		}
	
		_poles[0].previous_pole = _poles[1];
		_poles[1].next_pole = _poles[0];
		_poles[1].next_pole = _poles[0];

		instance_create_depth(x, y, depth, obj_skii_lift_chair);
	
	}
	
	obj_ticker.add_timer(4, false, method(id, function() { instance_destroy(id); }));
}
