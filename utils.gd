extends Reference

class_name Utils

static func get_component(parent: Node, type) -> Node:
	# returns first child node of a given type
	for i in parent.get_children():
		if i is type:
			return i
	return null

static func get_components(parent: Node, type) -> Array:
	# returns all child nodes of a given type
	var result := []
	for i in parent.get_children():
		if i is type:
			result.append(i)
	return result

static func get_child_or_null(parent: Node, index: int) -> Node:
	# similar to built-in Node.get_node_or_null()
	return parent.get_child(index) if parent.get_child_count() > index else null

static func connect_weak(
	source: Object,
	signal_name: String,
	target: Object,
	method_name: String,
	binds := [],
	flags := 0) -> void:
	# similar to Object.connenct(),
	# but doesn't produce errors if connection is invalid
	if source.has_signal(signal_name):
		if not source.is_connected(signal_name, target, method_name):
			source.connect(signal_name, target, method_name, binds, flags)

static func disconnect_weak(
	source: Object,
	signal_name: String,
	target: Object,
	method_name: String) -> void:
	# similar to Object.disconnect(),
	# but doesn't produce errors if connection is invalid
	if source.has_signal(signal_name):
		if source.is_connected(signal_name, target, method_name):
			source.disconnect(signal_name, target, method_name)

static func randi_range(min_value: int, max_value: int) -> int:
	# similar to RandomNumberGenerator.randi_range(), but uses default RNG
	return randi() % (max_value - min_value + 1) + min_value

static func get_random_index(
		array: Array,
		rng: RandomNumberGenerator = null) -> int:
	# returns an index of random element in array
	if is_instance_valid(rng):
		return rng.randi_range(0, array.size() - 1)
	return randi_range(0, array.size() - 1)

static func get_random_element(
		array: Array,
		rng: RandomNumberGenerator = null): # -> Variant
	# returns a random element from an array
	# useful when you want to get a random element
	# without shuffling the whole array
	if is_instance_valid(rng):
		return array[get_random_index(array, rng)]
	return array[get_random_index(array, rng)]

static func filter_array_by_type(array: Array, type) -> Array:
	# filters an array and returns only elements of chosen type
	var result := []
	for i in array:
		if i is type:
			result.append(i)
	return result

static func randi_range_vec2(
		_range: Vector2,
		rng: RandomNumberGenerator = null) -> int:
	# returns a random int between _range.x and _range.y
	if is_instance_valid(rng):
		return rng.randi_range(int(_range.x), int(_range.y))
	return randi_range(int(_range.x), int(_range.y))

static func randf_range_vec2(
		_range: Vector2,
		rng: RandomNumberGenerator = null) -> float:
	# returns a random float between _range.x and _range.y
	if is_instance_valid(rng):
		return rng.randf_range(_range.x, _range.y)
	return rand_range(_range.x, _range.y)

static func is_index_valid(array: Array, index: int) -> bool:
	# returns true if index is inside an array, otherwise false
	if index >= 0 and index < array.size():
		return true
	return false

static func search_custom(array: Array, comparator: FuncRef, args := []): # -> Variant
	# searches an array for a value based on a custom function
	# custom function receives a currently considered value and 
	# the value which is the best pick at the moment
	# custom function should return:
	# - true if a value is closer to searched one than the best pick
	# - false otherwise
	# optionally you can pass an array of additional arguments
	#
	# example:
	# func custom_comparator(value: int, best: int, args := []) -> bool:
	# 	# this function searches for a biggest integer
	# 	if value > best:
	# 		return true
	#	return false
	if array.empty() or not comparator.is_valid():
		return null
	var best = array[0]
	for element in array.slice(1, array.size() - 1):
		if comparator.call_func(element, best, args):
			best = element
	return best

static func get_collision_mask_bits(area: Area2D, count := 20) -> Array:
	# returns collision mask bits where every bit is an array's element
	# useful for debugging
	var bits := []
	for i in range(count):
		bits.append(area.get_collision_mask_bit(i))
	return bits

static func get_collision_layer_bits(area: Area2D, count := 20) -> Array:
	# returns collision layer bits where every bit is an array's element
	# useful for debugging
	var bits := []
	for i in range(count):
		bits.append(area.get_collision_layer_bit(i))
	return bits

static func dump(elements: Array) -> void:
	# prints all elements as one joined string without any separators
	# useful for printing collision bits
	var string := ""
	for element in elements:
		string += str(element)
	print(string)
