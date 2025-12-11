///@description Finalize Playerstate

// - land on ground
if (z <= 0) {
	speed_z = 0;	
	z = 0;
}

// - player in air
else if (z > 0) {
	image_xscale = 1;
	image_index = 3;
}