function Client() constructor {
socket = network_create_socket(network_socket_tcp);
	log_category = "client";

	listen_server = noone;

	event_channels = {};
	
	message_queue = [];
	write_buffer = buffer_create(0, buffer_grow, 1);
	
	function connect(url = "localhost") { 
		log(log_category, "client attempting to connect to server:");
		network_connect(socket, url, 666);
	}

	function connect_listen_server(_server) {
		listen_server = _server;	
	}

	function handle_http_connected() {
		log(log_category, "client connected");
	}

	function handle_http_disconnected() {
		log(log_category, "client disconnected");	
	}

	function get_channel(_event) {
		if (event_channels[$ _event] == undefined) {
			var _self = self;
			event_channels[$ _event] = new ClientNetworkDelegate(method({ client: _self, event: _event}, function(_payload) {
				client.send_to_server(event, _payload);
			}));	
		}
	
		return event_channels[$ _event];
	}
	
	function send_to_server(_event, _payload) {
		array_push(message_queue, [_event, _payload]);
	}
	
	function flush_message_queue() {
		if (socket != noone) {
			var _string = json_stringify(message_queue);
	
			buffer_seek(write_buffer, 0, 0);
			buffer_write(write_buffer, buffer_string, _string);
	
			network_send_packet(socket, write_buffer, buffer_tell(write_buffer));
		} else if (listen_server != noone) {
			listen_server.process_incoming_message_queue(message_queue);
		}
		
		array_resize(message_queue, 0);
	}
	
	function process_incoming_message_queue(_message_queue) {
		for (var _i = 0; _i < array_length(_message_queue); _i++) {
			get_channel(_message_queue[_i].event_name).receive(_message_queue[_i].payload);	
		}
	}
}