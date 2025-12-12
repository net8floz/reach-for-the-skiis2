var _south_entrance = instance_place(x, y, obj_skii_lift_south_entrance);

if (instance_exists(_south_entrance)) {
	var _pole = instance_place(x, y, obj_skii_lift_pole);
	
	if (instance_exists(_pole)) {
		_pole.south_entrance = _south_entrance;
		_south_entrance.pole = _pole;
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
}
