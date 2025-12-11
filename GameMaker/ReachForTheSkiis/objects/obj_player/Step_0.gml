if (live_call()) return live_result;

if (controlled_proxy) {
	var _ax = x - mouse_x;
	var _ay = y - mouse_y;
	var _mouse_direction = point_direction(x, y, mouse_x, mouse_y);
	facing_direction =  floor(_mouse_direction / (360 / 16))
}

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

if (controlled_proxy) {

	min_speed = 1;
	max_speed = 3;

	var _dist_from_mouse = point_distance(x, y, mouse_x, mouse_y);
	var _speed_mod = clamp(_dist_from_mouse / 300, 0, 1);

	var _applied_speed = lerp(min_speed, max_speed, _speed_mod);

	var _travelling_up = mouse_y - y < 0;
	if (_travelling_up) {
		_applied_speed /= 2;	
	}

	//if (_leaning_in_for_full_speed) {
	//	_applied_speed *= 1.6;	
	//}

	var _mouse_direction = point_direction(x, y, mouse_x, mouse_y);
	x += lengthdir_x(_applied_speed, _mouse_direction) * 1.5;
	y += lengthdir_y(_applied_speed, _mouse_direction);

	z += velocity_z;
	velocity_z -= 0.1;

	if (z <= 0) {
		velocity_z = 0;	
		z = 0;
	}

	if (z > 0) {
		image_xscale = 1;
		image_index = 3;
	}


	if (z <= 0) {
		if (mouse_check_button_pressed(mb_left)) {
			velocity_z = 3;
		}
	}

	var _camera = view_camera[0];
	camera_set_view_pos(_camera, x - camera_get_view_width(_camera) / 2, y - camera_get_view_height(_camera) / 2 + 100);
}