function GameMode() constructor {
	server = noone;
	log_category = "GameMode";
	player_controllers = [];

	create_local_player = function(_local_client) {
		log(log_category, "creating local player");
		var _pc = new PlayerController();
		
		array_push(player_controllers, _pc);
		
		global.world.local_player_controller = _pc;
		global.world.register_network_object(_pc);
		
		handle_player_joined(_pc);
		
		return _pc;
	}
	
	create_remote_player = function(_remote_client) {
		log(log_category, "creating remote player");
		var _pc = new PlayerController();
		_pc.replicated_proxy = true; 
		
		array_push(player_controllers, _pc);
		
		global.world.register_network_object(_pc);	
		global.world.send_assign_player_controller(_remote_client, _pc.replication.network_id);
		global.world.send_world_replication_sync(_remote_client);
		
		handle_player_joined(_pc);
		
		
		
		return _pc;
	}
	
	handle_player_joined = function(_player_controller) {
		log(log_category, "creating avatar for player");
		var _sx = 0;
		var _sy = 0;
		
		with (obj_player_spawn_location) {
			_sx = x;
			_sy = y;
		}
		
		var _avatar = instance_create_depth(_sx, _sy, 0, obj_player);
		_avatar.replication.network_owner_id = _player_controller.replication.network_id;
		_player_controller.avatar = _avatar;
		_avatar.owning_controller = _player_controller;
		
		global.world.register_network_object(_avatar);
	}
}	