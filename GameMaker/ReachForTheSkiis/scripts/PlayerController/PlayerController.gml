function PlayerController() constructor{
	log_category = "player_controller";
	avatar = noone;
	
	controlled_proxy = false;
	replicated_proxy = false;
	
	replication = new ReplicatedVariableSet();
}