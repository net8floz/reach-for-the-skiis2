if (live_call()) return live_result;

with ( GROUND ) {
	other.ground_friction = ground_friction;
	other.ground_slope = ground_slope;
}

// - Get input state
var _allow_input = replication.controlled_proxy && window_has_focus();

if ( _allow_input )
{
	key_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
	key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
	key_up = keyboard_check(ord("W")) || keyboard_check(vk_up);
	key_down = keyboard_check(ord("S")) || keyboard_check(vk_down);
	key_shift = keyboard_check(vk_lshift) || keyboard_check(vk_rshift);
	key_space = keyboard_check(vk_space);
	
	move_x = ( key_right - key_left );
	move_y = ( key_down - key_up );
}

// - Process Playerstate
if (replication.controlled_proxy) {
	
	// -- PHYSICS --
	var _leaning_for_full_speed = (key_down);
	var _travelling_up = move_y < 0;
	var _max_speed = max_speed + (image_index == 0) + (image_index <= 1)/2 - _travelling_up + ground_slope;
	
	if ( move_x != 0 ) {
		speed_x = lerp(speed_x, _max_speed*move_x, 0.1 + _leaning_for_full_speed*0.03);
	}
	
	if ( move_y != 0 ) {
		speed_y = lerp(speed_y, _max_speed*move_y, 0.06 + _leaning_for_full_speed*0.03);
	}
	
	
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
	var _friction = ground_friction * _on_ground * 0.1;
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
if ( move_x != 0 || move_y != 0 )
	facing_direction = floor(point_direction(x, y, x+move_x, y+move_y) / ( 360 / 16 ));
	
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
if ( _on_ground && (y != yprevious || x != xprevious) )
{
	layer_sprite_create("Tracks", bbox_left, bbox_bottom, spr_particle_track);
	layer_sprite_create("Tracks", bbox_right, bbox_bottom, spr_particle_track);
}
	
// player in the air
if (z > 0) {
	image_xscale = 1;
	image_index = 3;
}
