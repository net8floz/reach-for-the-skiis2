function point_distance_squared(_x, _y, _x2, _y2) {
	var _dx = _x2 - _x;
	var _dy = _y2 - _y;
	return _dx * _dx + _dy * _dy;
}

function nearly_equals(_x, _y, _tolerance = 0.01) {
	return abs(_y - _x) <= _tolerance;	
}