function generate_scene_replication_id(_inst) {
	with _inst 
		return $"{object_get_name(object_index)}{xstart}{ystart}";
}