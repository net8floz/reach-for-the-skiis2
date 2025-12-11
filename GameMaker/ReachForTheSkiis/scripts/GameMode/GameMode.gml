function GameMode() constructor {
	server = noone;
	log_category = "GameMode";
	player_controllers = [];

	create_local_player = function(_local_client) {
		log(log_category, "creating local player");
		var _pc = new PlayerController();
		_pc.controlled_proxy = true;
		
		array_push(player_controllers, _pc);
		
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
		
		handle_player_joined(_pc);
		
		global.world.send_client_entire_world_state(_remote_client);
		
		
		return _pc;
	}
	
	handle_player_joined = function(_player_controller) {
		log(log_category, "creating avatar for player");
		var _avatar = instance_create_depth(0, 0, 0, obj_player);
		_avatar.controlled_proxy = _player_controller.controlled_proxy;
		_avatar.replicated_proxy = _player_controller.replicated_proxy;
		
		
		_player_controller.avatar = _avatar;
		_avatar.owning_controller = _player_controller;
		
		global.world.register_network_object(_avatar);
	}
}