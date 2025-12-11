///@description Prepare Playerstate

// Get ground variables
with ( instance_place(x, y, GROUND) )
{
	other.ground_friction = ground_friction;
}
