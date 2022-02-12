extends Node

const MIN_V_ANGLE := deg2rad(-10)
const MAX_V_ANGLE := deg2rad(80)

export var spring_arm_path := @""; onready var spring_arm := get_node_or_null(spring_arm_path) as SpringArm

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var arm_rotation: Vector3 = spring_arm.rotation
		spring_arm.rotation.y = wrapf(arm_rotation.y - event.relative.x / 200, 0, TAU)
		spring_arm.rotation.x = clamp(
			arm_rotation.x - event.relative.y / 300,
			-MAX_V_ANGLE, -MIN_V_ANGLE
		)
