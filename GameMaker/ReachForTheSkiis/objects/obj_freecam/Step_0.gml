if (is_struct(owning_controller)) {
	var _dx = 
		(keyboard_check(vk_right) + keyboard_check(ord("D"))) 
		- (keyboard_check(ord("A")) + keyboard_check(vk_left));
		
	var _dy = 
		(keyboard_check(vk_down) + keyboard_check(ord("S"))) 
		- (keyboard_check(ord("W")) + keyboard_check(vk_up));
		
	var _a = point_direction(0, 0, _dx, _dy);
	
	if (_dx * _dx + _dy * _dy > 0) {
		x += lengthdir_x(move_speed / camera_zoom, _a);
		y += lengthdir_y(move_speed / camera_zoom, _a);
	}
	
	camera_zoom -= mouse_wheel_down() * 0.1;
	camera_zoom += mouse_wheel_up() * 0.1;
	
	camera_zoom = clamp(camera_zoom, 0.1, 10);

	
	var _camera = view_camera[0];
	camera_set_view_size(_camera, 640 / camera_zoom, 360 / camera_zoom);
	camera_set_view_pos(_camera, x - camera_get_view_width(_camera) / 2, y - camera_get_view_height(_camera) / 2 + 100);
}