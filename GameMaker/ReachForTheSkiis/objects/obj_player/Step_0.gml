if (live_call()) return live_result;

// - Get input state
var _allow_input = replication.controlled_proxy && window_has_focus() && mouse_check_button(mb_left);

// - Process Playerstate
if (replication.controlled_proxy) {
	
	// -- PHYSICS --
	var _leaning_for_full_speed = image_index==12;
	var _travelling_up = mouse_y - y < 0;
	
	var _mouse_direction = point_direction(x, y, mouse_x, mouse_y);
	var _dist_from_mouse = _allow_input ? point_distance(x, y, mouse_x, mouse_y) : 0;
	var _speed_mod = clamp(_dist_from_mouse / 300, 0, 1);

	speed_x += lengthdir_x(_speed_mod, _mouse_direction);
	speed_y += lengthdir_y(_speed_mod, _mouse_direction);

	speed_x = clamp(speed_x, -max_speed, max_speed);
	speed_y = clamp(speed_y, -max_speed, max_speed);
	
	facing_direction = floor(point_direction(x, y, x + speed_x, y + speed_y) / ( 360 / 16 ));
	
	if (z <= 0) {
		if (keyboard_check(vk_space) && window_has_focus()) {
			speed_z = 3;
		}
	}
	
	x += speed_x;
	y += speed_y;
	z += speed_z;
	
	if (z <= 0) {
		speed_z = 0;	
		z = 0;
	}

	var _on_ground = ( z == 0 );
	var _friction = ground_friction * _on_ground;
	speed_x = approach(speed_x, 0, _friction);
	speed_y = approach(speed_y, 0, _friction);
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

// SPRITE
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
		//_leaning_in_for_full_speed = true;
	break;
}
	
// -- create a track in the snow.
var _on_ground = ( z == 0 );
if ( _on_ground )
{
	layer_sprite_create("Tracks", bbox_left, bbox_bottom, spr_particle_track);
	layer_sprite_create("Tracks", bbox_right, bbox_bottom, spr_particle_track);
}
	
// player in the air
if (z > 0) {
	image_xscale = 1;
	image_index = 3;
}

