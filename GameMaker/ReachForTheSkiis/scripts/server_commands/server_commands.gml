function start_listen_server() {
	var _server = instance_create_depth(0, 0, 0, obj_server_runner).server;	
	var _client = instance_create_depth(0, 0, 0, obj_client_runner).client;
	
	_server.add_listen_server_client(_client);
	_client.connect_listen_server(_server);
	
	global.world.server = _server;
	global.world.register_client(_client);
	
	global.game_mode = new GameMode();
	global.game_mode.create_local_player(_client);
}

function start_client(url) {
	var _client = instance_create_depth(0, 0, 0, obj_client_runner).client;
	global.world.register_client(_client);
	_client.connect("localhost");
}	