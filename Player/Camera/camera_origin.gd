extends Spatial

export var swivl_speed:float # in rad/s
export var pan_speed:float # in m/s
export var pan_edge_extent:float # px form edge of screen

export var player_path := @""; onready var player := get_node_or_null(player_path) as KinematicBody
export var pivot_path := @""; onready var pivot := get_node_or_null(pivot_path) as Position3D

var camera_hight:float
var pan_vector := Vector2.ZERO

func _ready() -> void:
	camera_hight = translation.y
	reset_camera_position()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func reset_camera_position() -> void:
	pivot.translation = player.translation + camera_hight * Vector3.UP

func _process(delta: float) -> void:
	pivot.translation += Vector3(pan_vector.x, 0, pan_vector.y) * pan_speed * delta
	print(pivot.rotation.y)
	
	pivot.rotate_y(swivl_speed * delta * (Input.get_action_strength("camera_rotate_left") - Input.get_action_strength("camera_rotate_right")))
	
	if Input.is_action_pressed("camera_reset_position"):
		reset_camera_position()
	

func _pan_start_left() -> void:
	pan_vector.x = -1

func _pan_start_right() -> void:
	pan_vector.x = 1
	
func _pan_start_top() -> void:
	pan_vector.y = -1

func _pan_start_bot() -> void:
	pan_vector.y = 1

func _pan_stop_horizontal() -> void:
	pan_vector.x = 0

func _pan_stop_vertical() -> void:
	pan_vector.y = 0
