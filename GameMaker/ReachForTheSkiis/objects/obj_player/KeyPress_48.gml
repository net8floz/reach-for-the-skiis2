if (replication.controlled_proxy) {
	if (instance_exists(obj_freecam)) {
		owning_controller = obj_freecam.owning_controller;
		owning_controller.avatar = id;
		instance_destroy(obj_freecam);
	} else {
		with (owning_controller) {
			avatar = instance_create_depth(other.x, other.y, 0, obj_freecam);
			avatar.owning_controller = self;
		}

		owning_controller = noone;
	}
}