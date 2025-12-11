client = new Client();

client.get_channel("connected").on(function(_msg){
	log("obj_client_runner", $"received message from server: '{_msg}'");
});