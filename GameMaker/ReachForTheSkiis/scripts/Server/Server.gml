function Server() constructor {
	socket = network_create_server(network_socket_tcp, 666, 24);
	listen_server_client = noone;
	log_category = "server";
	clients = [];

	write_buffer = buffer_create(0, buffer_grow, 1);
	event_channels = {};
	
	function add_listen_server_client(_local_client) {
		var _server_client = new ServerClient();
		_server_client.local_client = _local_client;
		
		array_push(clients, _server_client);
		_server_client.enqueue_message("connected", "omg thanks for already being here!");
	}

	function handle_socket_connected(_socket) {
		log(log_category, $"socket {_socket} joins");
		
		var _server_client = new ServerClient();
		_server_client.socket = _socket;
		
		array_push(clients, _server_client);
		_server_client.enqueue_message("connected", "omg thanks for coming!");
		
		global.game_mode.create_remote_player(_server_client);
	}

	function handle_socket_disconnected(_socket) {
		log(log_category, $"socket {_socket} disconnected");
		
		for (var _i = 0; _i < array_length(clients); _i++) {
			if (clients[_i].socket == _socket) {
				array_delete(clients, _i, 1);
				_i--;
			}
		}
	}

	function flush_client_messages() {
		for (var _i = 0; _i < array_length(clients); _i++) {
			clients[_i].flush_message_queue();
		}
	}
	
	
	function broadcast_to_clients(_event_name, _payload) {
		for (var _i = 0; _i < array_length(clients); _i++) {
			clients[_i].enqueue_message(_event_name, _payload);
		}
	}
	
	function process_incoming_message_queue(_message_queue) {
		for (var _i = 0; _i < array_length(_message_queue); _i++) {
			get_channel(_message_queue[_i].event_name).execute(_message_queue[_i].payload);	
		}
	}
	
	function get_channel(_event) {
		if (event_channels[$ _event] == undefined) {
			event_channels[$ _event] = new Delegate();
		}
	
		return event_channels[$ _event];
	}
}

function ServerClient() constructor {
	socket = noone;
	local_client = noone;
	
	message_queue = [];
	write_buffer = buffer_create(0, buffer_grow, 1);

	function enqueue_message(_event, _payload) {
		array_push(message_queue, {
			event_name: _event,
			payload: _payload
		});
	}
	
	function flush_message_queue() {
		if (socket != noone) {
			var _string = json_stringify(message_queue);
	
			buffer_seek(write_buffer, 0, 0);
			buffer_write(write_buffer, buffer_string, _string);
	
			network_send_packet(socket, write_buffer, buffer_tell(write_buffer));
		} else if (local_client != noone) {
			local_client.process_incoming_message_queue(message_queue);
		}
		
		array_resize(message_queue, 0);
	}
}