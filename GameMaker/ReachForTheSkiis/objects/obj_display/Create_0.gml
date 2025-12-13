var _window_size = {
	x: 1920 / 2,
	y: 1080 / 2
};

var _total_windows = MultiClientGetNumberOfClients();
var _total_width = _window_size.x * _total_windows;

window_set_size(_window_size.x, _window_size.y);
window_id = max(0, MultiClientGetID());

window_set_rectangle(
	(display_get_width() - _total_width) / 2 + window_id * _window_size.x,
	(display_get_height() - _window_size.y) / 2,
	_window_size.x,
	_window_size.y
);

display_set_gui_size(_window_size.x, _window_size.y);

function update_window_caption() {
	var _window_id = obj_display.window_id;
	var _is_server = false;
	var _is_client = false;
	
	with (obj_network_session) {
		_is_server = is_struct(server);
		_is_client = is_struct(client);
	}
	
	var _network_string = _is_server ? "Server" : "Client";

	window_set_caption($"[ReachForTheSkiis][{_window_id}][{_network_string}]");	
}

update_window_caption();