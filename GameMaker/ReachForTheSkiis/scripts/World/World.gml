function World() constructor {
	network_id_counter = 0;
	objects = [];
	
	client = noone;
	server = noone;
	
	function spawn_replicated_object(_data) {
		var _inst = noone;
			
		if (_data.struct_name != undefined) {
			static _replicated_struct_map = {
				PlayerController: function() { return new PlayerController(); }
			}
				
			_inst = _replicated_struct_map[$ _data.struct_name]();
		} else {
			_inst = instance_create_depth(0, 0, 0, _data.object_index);	
		}
			
		_inst.network_id = _data.network_id;
		_inst.replicated_proxy = true;
		_inst.replication.update_replicated_variables(_data.state);	
	}
	
	function register_client(_client) {
		client = _client;
		
		client.get_channel("world-replication-spawn").on(method(self, function(_data) {
			if (is_struct(server)) {
				// world is server and thus has already spawned the item
				return;	
			}
			
			spawn_replicated_object(_data);
		}));
		
		client.get_channel("world-replication-sync").on(method(self, function(_objects) {
			for (var _i = 0; _i < array_length(_objects); _i++) {
				spawn_replicated_object(_objects[_i]);
			}
		}));
	}
	
	function register_network_object(_instance) {
		_instance.network_id = network_id_counter;
		network_id_counter++;
		
		array_push(objects, _instance);
		
		server.broadcast_to_clients("world-replication-spawn", {
			struct_name: is_struct(_instance) ? instanceof(_instance) : undefined,
			object_index: is_struct(_instance) ? undefined : _instance.object_index,
			network_id: _instance.network_id,
			state: _instance.replication.calculate_current_state()
		});
	}
	
	function send_client_entire_world_state(_client) {
		var _object_datas = [];
		
		for (var _i = 0; _i < array_length(objects); _i++) {
			var _instance = objects[_i];
			var _data = {
				struct_name: is_struct(_instance) ? instanceof(_instance) : undefined,
				object_index: is_struct(_instance) ? undefined : _instance.object_index,
				network_id: _instance.network_id,
				state: _instance.replication.calculate_current_state()
			};
			array_push(_object_datas, _data);
		}
		
		_client.enqueue_message("world-replication-sync", _object_datas);
	}
	
	tick = function() {
		//for (var _i = 0; _i < array_length(objects); _i++) {
		//	var _inst = objects[_i];
			
		//	if (_inst.controlled_proxy && !is_struct(client.listen_server)) {
		//		var _diff = _inst.replication.clear_diff();
		//		if (is_struct(_diff)) {
		//			client.get_channel("world-replication-update").send({
		//				network_id: _inst.network_id,
		//				updated_state: _diff
		//			});
		//		}
		//	}
		//}
	}
}