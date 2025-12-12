function ObjectReplication(_inst) constructor {
	network_id = noone;
	network_owner_id = noone;
	replicated_proxy = false;
	controlled_proxy = false;
	scene_network_id = "";
	
	if (!is_struct(_inst)) {
		with _inst other.scene_network_id = $"{object_get_name(object_index)}{xstart}{ystart}";
	}
	
	getters = [];
	setters = {};
	last_state = {};
	last_diff = {};
	last_diff_has_size = false;
	
	function add_variable(_name, _getter, _setter) {
		array_push(getters, [_name, _getter]);
		setters[$ _name] = _setter;
	}
	
	function update_controlled_variables() { 
		var _new_state = {};
		
		for (var _i = 0; _i < array_length(getters); _i++) {
			var _var_name = getters[_i][0];
			_new_state[$ _var_name] = getters[_i][1]();
			if (_new_state[$ _var_name] != last_state[$ _var_name]) {
				last_diff[$ _var_name] = _new_state[$ _var_name];
				last_diff_has_size = true;
			}
		}
		
		last_state = _new_state;
	}
	
	function update_replicated_variables(_key_value_pairs) {
		var _names = variable_struct_get_names(_key_value_pairs);
		for (var _i = 0; _i < array_length(_names); _i++) {
			var _name = _names[_i];
			setters[$ _name](_key_value_pairs[$ _name]);
		}
	}
	
	function calculate_current_state() {
		var _new_state = {};
		
		for (var _i = 0; _i < array_length(getters); _i++) {
			var _var_name = getters[_i][0];
			_new_state[$ _var_name] = getters[_i][1]();
		}		
		
		return _new_state;
	}
	
	function clear_diff() {
		if (last_diff_has_size) {
			var _ret = last_diff;
			last_diff = {};
			last_diff_has_size = false;
			return _ret;
		} else {
			return undefined;	
		}
	}
}