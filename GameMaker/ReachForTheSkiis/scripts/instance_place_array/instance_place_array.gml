function instance_place_array(_x, _y, _obj, _ordered = false) {
	static _list = ds_list_create();
	ds_list_clear(_list);
	instance_place_list(_x, _y, _obj, _list, _ordered);
	
	var _ret = []
	for (var _i = 0; _i < ds_list_size(_list); _i++) { 
		array_push(_ret, _list[| _i]);
	}
	return _ret;
}