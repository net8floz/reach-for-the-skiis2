if (live_call()) return live_result;

// ---- Locals ----

// Physics
min_speed = 1;
max_speed = 5;
max_speed_z = 3;
speed_x = 0;
speed_y = 0;
speed_z = 0;
z = 0;
ground_friction = 0.5; // amount of friction applied by basic ground. ( as opposed to, like, friction on ice tiles or something else that doesn't exist yet )
ground_slope = 0; // % of how much slope the player is on. Higher slope means higher friction.


// Sprite
image_speed = 0;
facing_direction = 0

// ---- Network ----
replication = new ObjectReplication();

server_x = x;
server_y = y;
server_z = z;

replication.add_variable("x", method(id, function() { return round(x); }), method(id, function(_x) { 
	server_x = _x;
}));

replication.add_variable("y", method(id, function() { return round(y); }), method(id, function(_y) { 
	server_y = _y;
}));

replication.add_variable("z", method(id, function() { return round(z); }), method(id, function(_z) { 
	server_z = _z;
}));

replication.add_variable("facing_direction", method(id, function() { return facing_direction; }), method(id, function(_facing_direction) {
	if (replication.replicated_proxy) {
		facing_direction = _facing_direction;
	}
}));