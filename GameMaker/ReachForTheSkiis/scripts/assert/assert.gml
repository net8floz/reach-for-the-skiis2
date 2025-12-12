function assert(_condition, _msg = undefined) {
	if (!_condition) {
		throw _msg || debug_get_callstack(1);
	}
}