var _list = ds_list_create();
instance_place_list(x, y, obj_skii_lift_pole, _list, false);

var _poles = [];
for (var _i = 0; _i < ds_list_size(_list); _i++) {
	if (_i == 2) {
		break;	
	}
	
	array_push(_poles, _list[| _i]);
}

ds_list_destroy(_list);

if (array_length(_poles) == 2) {
	if (_poles[0].y < _poles[1].y) {
		_poles = [_poles[1], _poles[0]];	
	}
	
	_poles[0].next_pole = _poles[1];
	_poles[1].previous_pole = _poles[0];
}

instance_destroy();