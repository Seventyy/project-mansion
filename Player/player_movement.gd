extends Node

export var speed: float
export var gravity: float

#export var spring_arm_path := @""; onready var spring_arm := get_node_or_null(spring_arm_path) as SpringArm
	
func _process(delta: float) -> void:
	# to jest mocno zjebane, ale nada się do testów, bo tylko do tego jest potrzebne
	_move_relative_to_camera(Vector3(
		Input.get_action_strength('right') - Input.get_action_strength('left'), 0,
		Input.get_action_strength('down') - Input.get_action_strength('up')
	))


func _move_relative_to_camera(movement: Vector3) -> void:
	#var camera_rotation: float = spring_arm.rotation.y
	
	#var facing_vector := Vector3.FORWARD.rotated(Vector3.UP, camera_rotation)
	#var cross_vector := facing_vector.cross(Vector3.DOWN)
	
	movement = movement.normalized()
	
	owner.move_and_slide(
		# poruszanie się w poziomie
		#((movement.x) * facing_vector +
		#(movement.z) * cross_vector) * speed
		movement * speed
		# grawitacja
		+ Vector3.DOWN * gravity,
		# żeby się nie ślizgał xd
		Vector3.UP, true
	)
