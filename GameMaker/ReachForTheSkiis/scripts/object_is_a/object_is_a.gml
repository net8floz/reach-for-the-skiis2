function object_is_a(_inst, _object_index){
	return _inst.object_index == _object_index || object_is_ancestor(_inst.object_index, _object_index);
}