depth = -9999;



draw_lines_from_to = function(_inst1, _inst2) {
	static draw_lines = function(_x1, _y1, _x2, _y2) {
		var _thick = 5;
		var dx = _x2 - _x1;
		var dy = _y2 - _y1;
		var length = sqrt(dx*dx + dy*dy);
		var px = -dy / length;
		var py = dx / length;

		for (var _i = 0; _i < _thick; _i++) {
			var offset = _i - floor(_thick / 2);
			var ox = px * offset;
			var oy = py * offset;

			draw_line(
			    _x1 + ox,
			    _y1 + oy,
			    _x2 + ox,
			    _y2 + oy
			);
		}
	}

	draw_lines(
		_inst1.x + _inst1.line_offset_south_x, 
		_inst1.y - _inst1.line_z, 
		_inst2.x + _inst2.line_offset_south_x, 
		_inst2.y - _inst2.line_z);
		
	draw_lines(
		_inst1.x + _inst1.line_offset_north_x, 
		_inst1.y - _inst1.line_z, 
		_inst2.x + _inst2.line_offset_north_x, 
		_inst2.y - _inst2.line_z);
			
}