function World() constructor {
	network_id_counter = 0;
	objects = [];
	objects_lookup = {};
	
	client = noone;
	server = noone;
	local_player_controller = noone;
	
	scene_is_awake = false;
	
	function spawn_replicated_object(_data) {
		assert(objects_lookup[$ _data.network_id] == undefined);
					
		var _inst = noone;
			
		if (_data.struct_name != undefined) {
			static _replicated_struct_map = {
				PlayerController: function() { return new PlayerController(); }
			}
				
			_inst = _replicated_struct_map[$ _data.struct_name]();
		} else {
			_inst = instance_create_depth(_data.state.x, _data.state.y, 0, _data.object_index);	
		}
			
		_inst.replication.network_id = _data.network_id;
		_inst.replication.network_owner_id = _data.network_owner_id;
		_inst.replication.update_replicated_variables(_data.state);		
		_inst.replication.replicated_proxy = true;
		
		if (is_struct(local_player_controller)) {
			if (local_player_controller.replication.network_id == _inst.replication.network_owner_id) {
				_inst.replication.replicated_proxy = false;
				_inst.replication.controlled_proxy = true;
				_inst.owning_controller = local_player_controller;
			}
		}
		
		objects_lookup[$ _inst.replication.network_id] = _inst;
		array_push(objects, _inst);
	}
	
	function register_server(_server) {
		server = _server;
		
		server.get_channel("world-replication-push-up").on(method(self, function(_client, _data) {
			var _inst = objects_lookup[$ _data.network_id];
			
			if (is_struct(_inst) || instance_exists(_inst)) {
				_inst.replication.update_replicated_variables(_data.state);	
			}
		}));
		
		with (all) {
			if (variable_instance_exists(id, "replication")) {
				if (other.objects_lookup[$ id.replication.network_id] == undefined) {
					// must assume that this is a scene placed item
					other.register_network_object(id, true);
				}
			}
		}
		
		assert(!scene_is_awake);
		awaken_world();
		
	}
	
	function awaken_world() {
		scene_is_awake = true;
		
		while(true) {
			var _no_change = true;
			
			with (all) {
				if (variable_instance_exists(id, "handle_awake")) {
					if (variable_instance_exists(id, "did_handle_awake")) {
						if (id.did_handle_awake) {
							continue;	
						}
					}
					
					handle_awake();
					did_handle_awake = true;
					_no_change = false;
				}
			}
			
			if (_no_change) {
				break;	
			}
		}
			
	}
	
	function register_client(_client) {
		client = _client;
		
		client.get_channel("assign-player-controller").on(method(self, function(_network_id) {
			var _inst = objects_lookup[$ _network_id];
	
			_inst.replication.network_id = _network_id;
			_inst.replication.owner_network_id = _network_id;
			_inst.replication.replicated_proxy = false;
			_inst.replication.controlled_proxy = true;
			
			local_player_controller = _inst;
		}));
		
		client.get_channel("world-replication-sync").on(method(self, function(_objects_datas) {
			if (is_struct(server)) {
				// world is server and thus has already spawned the item
				return;	
			}
			
			for (var _i = 0; _i < array_length(_objects_datas); _i++) {
				var _inst_data = _objects_datas[_i];
				var _existing_instance = objects_lookup[$ _inst_data.network_id];
				if (is_struct(_existing_instance) || instance_exists(_existing_instance)) {
					
					if (_inst_data.alive) {
						_existing_instance.replication.update_replicated_variables(_inst_data.state);	
					} else {
						// to do: destroy network object
					}
				} else if (_inst_data.alive) {
					spawn_replicated_object(_inst_data);	
				}
			}
		}));
		
		
		with (all) {
			if (variable_instance_exists(id, "replication")) {
				if (other.objects_lookup[$ id.replication.network_id] == undefined) {
					// must assume that this is a scene placed item
					
					other.register_network_object(id, true);
				}
			}
		}
		
		if (!scene_is_awake) {
			awaken_world();	
		}
	}
	
	function register_network_object(_instance, _use_scene_id) {
		
		if (is_struct(server)) {
			assert(objects_lookup[$ _instance.replication.network_id] == undefined);
			
			if (_use_scene_id) {
				_instance.replication.network_id = _instance.replication.scene_network_id;
				_instance.replication.replicated_proxy = false;
				_instance.replication.controlled_proxy = true;
			} else {
				_instance.replication.network_id = network_id_counter;
				network_id_counter++;
			}
		
			objects_lookup[$ _instance.replication.network_id] = _instance;
			array_push(objects, _instance);
		
			_instance.replication.replicated_proxy = true;
						
			if (is_struct(local_player_controller)) {
				if (local_player_controller.replication.network_id == _instance.replication.network_owner_id) {
					_instance.replication.replicated_proxy = false;
					_instance.replication.controlled_proxy = true;
				}
			}
		
			server.broadcast_to_clients("world-replication-sync", [{
				struct_name: is_struct(_instance) ? instanceof(_instance) : undefined,
				object_index: is_struct(_instance) ? undefined : _instance.object_index,
				network_id: _instance.replication.network_id,
				network_owner_id: _instance.replication.network_owner_id,
				alive: true,
				state: _instance.replication.calculate_current_state()
			}]);
		} else if (is_struct(client)) {
			assert(_use_scene_id);
			
			if (objects_lookup[$ _instance.replication.network_id] == undefined) {
				_instance.replication.network_id = _instance.replication.scene_network_id;
				_instance.replication.replicated_proxy = true;
				_instance.replication.controlled_proxy = false;
				
				objects_lookup[$ _instance.replication.network_id] = _instance;
				
				array_push(objects, _instance);
			}
		}
	}	
	
	function send_assign_player_controller(_client, _network_id) {
		_client.enqueue_message("assign-player-controller", _network_id);
	}
	
	function send_world_replication_sync(_client) {
		var _object_datas = [];
		
		for (var _i = 0; _i < array_length(objects); _i++) {
			var _instance = objects[_i];
			var _data = {
				struct_name: is_struct(_instance) ? instanceof(_instance) : undefined,
				object_index: is_struct(_instance) ? undefined : _instance.object_index,
				network_id: _instance.replication.network_id,
				network_owner_id: _instance.replication.network_owner_id,
				alive: true,
				state: _instance.replication.calculate_current_state()
			};
			array_push(_object_datas, _data);
		}
		
		_client.enqueue_message("world-replication-sync", _object_datas);
	}
	
	tick = function() {
		if (is_struct(server)) {
			var _updates = [];
				
			for (var _i = 0; _i < array_length(objects); _i++) {
				var _instance = objects[_i];
	
				// todo - only send minimum state required for update instead of all current 
				// calculated state
				var _data = {
					struct_name: is_struct(_instance) ? instanceof(_instance) : undefined,
					object_index: is_struct(_instance) ? undefined : _instance.object_index,
					network_id: _instance.replication.network_id,
					network_owner_id: _instance.replication.network_owner_id,
					alive: true,
					state: _instance.replication.calculate_current_state()
				};
			
				array_push(_updates, _data);
			}
				
			server.broadcast_to_clients("world-replication-sync", _updates);
				
		} else if(is_struct(client)) {
			for (var _i = 0; _i < array_length(objects); _i++) {
				var _inst = objects[_i];
				if (_inst.replication.controlled_proxy) {
					_inst.replication.update_controlled_variables();
					var _diff = _inst.replication.clear_diff();
					if (is_struct(_diff)) {
						client.get_channel("world-replication-push-up").send({
							network_id: _inst.replication.network_id,
							state: _diff
						});
					}
				}
			}
		}
	}
}