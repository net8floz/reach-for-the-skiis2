if (live_call()) return live_result;

with ( instance_position(x, y, GROUND) ) {
	other.ground_friction = ground_friction;
	other.ground_slope = ground_slope;
	other.ground_can_walk = can_walk_on;
}

// - Get input state
var _allow_input = is_struct(owning_controller) && replication.controlled_proxy && window_has_focus();

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

// - Ski to Walk
if ( ground_can_walk && state == STATE.ski && speed_xy == 0 )
{
	state = STATE.walk;
}
else if ( ground_can_walk == false )
	state = STATE.ski;

// SPRITE
if ( state == STATE.walk )
{
	sprite_index = spr_player_walk;
	image_index += speed_x/10;
	if ( speed_x != 0 ) image_xscale = sign(speed_x);
}
else if ( state == STATE.ski )
{
	sprite_index = spr_player;
	
	image_angle = lerp(image_angle, 0, 0.2);
	
	if ( move_x != 0 || move_y != 0 )
		facing_direction = floor(point_direction(x, y, x+move_x, y+move_y) / ( 360 / 16 ));
	
	var _medium_speed = 5;
	var _high_speed = 9;
	
	switch(facing_direction) {
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
			// all the way left
			image_xscale = -1;
			image_index = 2; 
			max_speed = 0;
			move_direction_target = 180;
			break;
		case 9:
		case 10:
			// sort of left
			image_xscale = -1;
			image_index = 1;
			max_speed = _medium_speed;
			move_direction_target = 225;
			break;
		case 0:
		case 1:
		case 2:
		case 3:
		case 15:
			// all the way right
			image_xscale = 1;
			image_index = 2;
			max_speed = 0;
			move_direction_target = 360;
			break;
		case 13:
		case 14:
			// sort of right
			image_xscale = 1;
			image_index = 1;
			max_speed = _medium_speed;
			move_direction_target = 315;
			break;
		case 11:
		case 12:
			// straight down
			image_xscale = 1;
			image_index = 0;
			max_speed = _high_speed;
			move_direction_target = 270;
			//_leaning_in_for_full_speed = true;
		break;
	}
}
else if ( state == STATE.wipeout )
{
	sprite_index = spr_player;
	image_index = 3;
	image_angle += -4*sign(speed_x) + 1;
}
else if ( state == STATE.burried )
{
	sprite_index = spr_player_burried;
	speed_xy = approach(speed_xy, 0, 0.5);
	speed_x = approach(speed_xy, 0, 0.5);
	speed_y = approach(speed_xy, 0, 0.5);
}

// - Process Playerstate
if (replication.controlled_proxy) {
	if ( state != STATE.walk )
	{
		// -- PHYSICS --
		var _leaning_for_full_speed = (key_down);
		var _travelling_up = move_y < 0;
	
		move_direction = lerp(move_direction, move_direction_target, 0.2);
		move_direction = approach(move_direction, move_direction_target, 0.01);

		if ( z == 0 )
		{
			speed_xy = lerp(speed_xy, max_speed-ground_friction, 0.005);
			speed_xy = approach(speed_xy, max_speed-ground_friction, 0.02);
			speed_xy = max(0, speed_xy);
		
			speed_x = lengthdir_x(speed_xy, move_direction);
			speed_y = lengthdir_y(speed_xy, move_direction);
		}

		// - ski jump
		if (z <= 0 && state != STATE.wipeout) {
			if (keyboard_check(vk_space) && window_has_focus()) {
				speed_z = 1+abs(speed_xy)/3;
				if ( state == STATE.burried ) state = STATE.ski;
			}
		}
	
		// - wipeout
		if ( state == STATE.ski && place_meeting(x + speed_x, y + speed_y, OBSTA ) ) {
			state = STATE.wipeout;
			speed_x *=  0.6;
			speed_y *= -0.7;
			speed_z = 2 + max( 3, abs(speed_y)/1.25);
			speed_y -= 1;
		}
	}
	else
	{
		speed_x = approach(speed_x, speed_walk*move_x, 0.45);
		speed_y = approach(speed_y, speed_walk*move_y, 0.45);

		// - jump
		if ( z <= 0 ) {
			if (keyboard_check(vk_space) && window_has_focus()) {
				speed_z = 2;
			}
		}
	}
	
	x += speed_x;
	y += speed_y;
	z += speed_z;
	
	if (z <= 0) {
		speed_z = 0;	
		z = 0;

		if ( state != STATE.walk )
		{
			speed_x = approach(speed_x, 0, ground_friction);
			speed_y = approach(speed_y, 0, ground_friction);
		}
		else if ( state == STATE.walk )
		{
			speed_x = approach(speed_x, 0, 0.1);
			speed_y = approach(speed_y, 0, 0.1);
		}
		
		if ( state == STATE.wipeout ) state = STATE.burried;
	}
	else speed_z -= 0.1;


	// CONTROL CAMERA
	if (is_struct(owning_controller)) {
		var _camera = view_camera[0];
		camera_set_view_pos(_camera, x - camera_get_view_width(_camera) / 2, y - z - camera_get_view_height(_camera) / 2 + 100);
	}
	
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
