extends Node

const MIN_V_ANGLE := deg2rad(-10)
const MAX_V_ANGLE := deg2rad(80)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var arm_rotation: Vector3 = $'../SpringArm'.rotation
		$'../SpringArm'.rotation.y = wrapf(arm_rotation.y - event.relative.x / 200, 0, TAU)
		$'../SpringArm'.rotation.x = clamp(
			arm_rotation.x - event.relative.y / 300,
			-MAX_V_ANGLE, -MIN_V_ANGLE
		)
