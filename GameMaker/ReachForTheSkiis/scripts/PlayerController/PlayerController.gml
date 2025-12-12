function PlayerController() constructor{
	log_category = "player_controller";
	avatar = noone;
	
	replication = new ObjectReplication(self);
}