extends Node

export var speed: float
export var gravity: float
	
func _process(delta: float) -> void:
	_move_relative_to_camera(Vector3(
		Input.get_action_strength('up') - Input.get_action_strength('down'), 0,
		Input.get_action_strength('left') - Input.get_action_strength('right')
	))
	
func _move_relative_to_camera(movement: Vector3) -> void:
	var camera_rotation: float = $'../SpringArm'.rotation.y
	
	var facing_vector := Vector3(-sin(camera_rotation), 0, -cos(camera_rotation))
	var cross_vector := facing_vector.cross(Vector3(0, -1, 0))
	
	movement = movement.normalized()
	
	owner.move_and_slide(
		# poruszanie się w poziomie
		((movement.x) * facing_vector +
		(movement.z) * cross_vector) * speed
		# grawitacja
		+ Vector3(0, -gravity, 0),
		# żeby się nie ślizgał xd
		Vector3(0,1,0), true
	)
