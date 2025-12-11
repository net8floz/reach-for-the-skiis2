room_goto(rm_world);

global.ticker.add_timer(1, false, method(id, function(){
	start_listen_server();
}));