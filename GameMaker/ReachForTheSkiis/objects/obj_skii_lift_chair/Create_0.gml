enum EChairState {
	HeadedToSouthEntrance,
	HeadedToNorthEntrance,
	FollowingSouthEntrance,
	HeadedNorth,
	HeadedSouth,
	FollowingNorthEntrance
}

current_state = EChairState.HeadedNorth;
next_pole = noone;
entrance = noone;
spd = 2;
image_speed = 0;

pole_height = sprite_get_height(spr_liftpole);
entrance_height = 0;

IMAGE_INDEX_SOUTH = 0;
IMAGE_INDEX_NORTH = 1;
IMAGE_INDEX_EAST = 2;
IMAGE_INDEX_WEST = 3;

passengers = [];
accepting_passengers = false;

z = 0;

replication = new ObjectReplication(id);

server_x = undefined;
server_y = undefined;
server_z = undefined;

replication.add_variable("x", method(id, function() { return round(x); }), method(id, function(_x) { 
	if (server_x == undefined) {
		x = _x;
	}
	server_x = _x;
	
	var _dx = server_x - x;
	x += _dx * 0.5;
}));

replication.add_variable("y", method(id, function() { return round(y); }), method(id, function(_y) { 
	if (server_y == undefined) {
		y = _y;	
	}
	server_y = _y;
	
	var _dy = server_y - y;
	y += _dy * 0.5;
}));

replication.add_variable("z", method(id, function() { return round(z); }), method(id, function(_z) { 
	if (server_z == undefined) {
		z = _z;	
	}
	server_z = _z;
	
	var _dz = server_z - z;
	z += _dz * 0.5;
}));


target_x = x;
target_y = y;
target_z = z;
last_target_x = x;
last_target_y = y;
last_target_z = z;

shadow = instance_create_depth(x, y, depth, obj_skii_lift_chair_shadow);
shadow.chair = id;

handle_awake = function() {
	var _linker = instance_nearest(x, y, obj_skii_lift_linker);

	with (_linker) {
		var _poles = instance_place_array(x, y, obj_skii_lift_pole);
		if (array_length(_poles) == 2) {
			if (_poles[0].y > _poles[1].y) {
				_poles = [_poles[1], _poles[0]];	
			}
			
			other.next_pole = other.current_state == EChairState.HeadedNorth ? _poles[0] : _poles[1];
			other.x = other.next_pole.x + (other.current_state == EChairState.HeadedNorth ? other.next_pole.line_anchor_north : other.next_pole.line_anchor_south);
			other.y = other.next_pole.y;
		}
	}
}