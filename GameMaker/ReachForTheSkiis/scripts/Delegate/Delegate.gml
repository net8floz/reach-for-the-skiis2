function Delegate() constructor{
	targets = [];
	handle_id = 0;
	
	function execute(_args = undefined) {
		for (var _i = 0; _i < array_length(targets); _i++) {
			targets[_i][0](_args);	
		}
	}
	
	function on(fn) {
		var _handle = handle_id;
		handle_id++;
		array_push(targets,	[fn, _handle]);
		return _handle;
	}
	
	function off(_handle) {
		for (var _i = 0; _i < array_length(targets); _i++) {
			if (targets[_i][1] == _handle) {
				array_delete(targets, _i, 1);
				_i--;
			}
		}
	}
}

function ClientNetworkDelegate(_on_send) constructor{
	targets = [];
	handle_id = 0;
	on_send = _on_send;
	
	function receive(_args = undefined) {
		for (var _i = 0; _i < array_length(targets); _i++) {
			targets[_i][0](_args);	
		}
	}
	
	function send(_args = undefined) {
		on_send(_args);
	}
	
	function on(fn) {
		var _handle = handle_id;
		handle_id++;
		array_push(targets,	[fn, _handle]);
		return _handle;
	}
	
	function off(_handle) {
		for (var _i = 0; _i < array_length(targets); _i++) {
			if (targets[_i][1] == _handle) {
				array_delete(targets, _i, 1);
				_i--;
			}
		}
	}
}
