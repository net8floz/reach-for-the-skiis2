///@description Process Playerstate

if (live_call()) return live_result;

// - Get input state
var _allow_input = replication.controlled_proxy && window_has_focus() && mouse_check_button(mb_left);

if (_allow_input) {
	var _ax = x - mouse_x;
	var _ay = y - mouse_y;
	var _mouse_direction = point_direction(x, y, mouse_x, mouse_y);
	facing_direction =  floor(_mouse_direction / (360 / 16))
}

// - Process input state
var _leaning_in_for_full_speed = false;
switch(facing_direction) {
	case 4:
	case 5:
	case 6:
	case 7:
	case 8:
		// all the way left
		image_xscale = -1;
		image_index = 2; 
		break;
	case 9:
	case 10:
		// sort of left
		image_xscale = -1;
		image_index = 1;
		break;
	case 0:
	case 1:
	case 2:
	case 3:
	case 15:
		// all the way right
		image_xscale = 1;
		image_index = 2;
		break;
	case 13:
	case 14:
		// sort of right
		image_xscale = 1;
		image_index = 1;
		break;
	case 11:
	case 12:
		// straight down
		image_xscale = 1;
		image_index = 0;
		_leaning_in_for_full_speed = true;
	break;
}

// - Process Playerstate
if (replication.controlled_proxy) {
	// -- PHYSICS --
	
	// - calculate speed to apply based on player's mouse input.
	var _dist_from_mouse = _allow_input ? point_distance(x, y, mouse_x, mouse_y) : 0;
	var _speed_mod = clamp(_dist_from_mouse / 300, 0, 1);

	var _applied_speed = _allow_input ? lerp(min_speed, max_speed, _speed_mod) : 0;

	// - Modify Speed
	// -- reduce speed when traveling up
	var _travelling_up = mouse_y - y < 0;
	if (_travelling_up) {
		_applied_speed /= 2;	
	}

	// -- increase speed when traveling straight down
	//if (_leaning_in_for_full_speed) {
	//	_applied_speed *= 1.6;	
	//}
	
	// PROCESS SPEED
	
	// - X/Y Speed
	// -- add x/y speed in the direction of mouse.
	var _mouse_x = window_has_focus() ? mouse_x : x;
	var _mouse_y = window_has_focus() ? mouse_y : y;
	var _mouse_direction = point_direction(x, y, _mouse_x, _mouse_y);
	
	speed_x += lengthdir_x(_applied_speed, _mouse_direction) * 1.5; // 150% extra horizontal speed
	speed_y += lengthdir_y(_applied_speed, _mouse_direction);
	
	// -- clamp speed
	speed_x = clamp(speed_x, -max_speed, max_speed);
	speed_y = clamp(speed_y, -max_speed, max_speed);
	
	// -- apply speed.
	x += speed_x;
	y += speed_y;
	
	// -- apply friction ( after calculation )
	var _on_ground = ( z == 0 );
	var _friction = ground_friction * _on_ground * ( 1 - ground_slope );
	speed_x = lerp(speed_x, 0, _friction);
	speed_y = lerp(speed_y, 0, _friction);
	
	if (z <= 0) {
		if (keyboard_check(vk_space) && window_has_focus()) {
			speed_z = 3;
		}
	}

	// - Z Speed
	// -- jump if grounded
	if (z <= 0) {
		if (keyboard_check(vk_space) && window_has_focus()) {
			speed_z = 3;
		}
	}
	
	// -- process z speed.
	z += speed_z;
	speed_z -= 0.1;
	
	
	// CONTROL CAMERA
	var _camera = view_camera[0];
	camera_set_view_pos(_camera, x - camera_get_view_width(_camera) / 2, y - camera_get_view_height(_camera) / 2 + 100);
	
} else if (replication.replicated_proxy) {
	x += (server_x - x) * 0.8;
	if (abs(server_x - x) < 1) {
		x = server_x;
	}
	
	y += (server_y - y) * 0.8;
	if (abs(server_y - y) < 1) {
		y = server_y;
	}
	
	z += (server_z - z) * 0.8;
	if (abs(server_z - z) < 1) {
		z = server_z;
	}
}