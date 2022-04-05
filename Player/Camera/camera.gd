extends Spatial

export var swivl_speed:float # in rad/s , maybe camero should swivil in steps, like zoom
export var pan_speed:float # in m/s
export var zoom_step:float # in %/wheel tick

export var close_point:Vector2
export var far_point:Vector2

export var offset_curve:Curve
export var rotation_curve:Curve

export var player_path := @""; onready var player := get_node_or_null(player_path) as KinematicBody
export var camera_path := @""; onready var camera := get_node_or_null(camera_path) as Camera
export var raycast_path := @""; onready var raycast := get_node_or_null(raycast_path) as RayCast

const raycast_lenght:float = 100.0

var zoom:float = 0.5 # close - 0, far - 1

var position_2d:Vector2	
var swivl_direction:float

func _ready() -> void:
	swivl_speed = deg2rad(swivl_speed)
	reset_translation()
	recalculate_postition()
	recalculate_rotation()

func reset_translation():
	translation = player.translation

func recalculate_postition() -> void:
	position_2d = (far_point.linear_interpolate(close_point, zoom) - (close_point - far_point).tangent().normalized() *
		offset_curve.interpolate(zoom))
	camera.translation = Vector3(position_2d.x, position_2d.y, 0)
	
func recalculate_rotation() -> void:
	camera.rotation_degrees.x = -rotation_curve.interpolate(zoom)

func _process(delta) -> void:
	rotate_y(swivl_speed * delta * (Input.get_action_strength("camera_swivl_right") - Input.get_action_strength("camera_swivl_left")))
	if Input.is_action_pressed("camera_reset_position"):
		reset_translation()

func try_interact(screen_position:Vector2) -> void:
	raycast.cast_to = camera.project_ray_normal(screen_position) * raycast_lenght
	var collider = raycast.get_collider()
	print("try")
	if is_instance_valid(collider):
		print("valid") # kamera jest obrócona, może to to
		Utils.get_component(collider, InteractionHandler)._on_intaraction()
	
func _input(event) -> void: # tu może lepiej dać _unhandeled_input()
	if not event.is_action_type():
		return
	
	if event.is_action_pressed("zoom_in") or event.is_action_pressed("zoom_out"):
		zoom += (Input.get_action_strength("zoom_in") - Input.get_action_strength("zoom_out")) * zoom_step
		zoom = clamp(zoom, 0, 1)
		recalculate_rotation()
		recalculate_postition()
		return
	
	if event.is_action_pressed("interact"): # tu zakładam że została użyta myszka, do zmiany ewentualnie
		try_interact(event.position)

	





	


		
		
		
		
		
		
# func _input(event): # tu może lepiej dać _unhandeled_input()
# 	if event is InputEventMouseButton:
# 		if event.pressed == true:
# 			match event.button_index:
# 				BUTTON_WHEEL_UP:
# 					zoom += zoom_step
# 				BUTTON_WHEEL_DOWN:
# 					zoom -= zoom_step
# 			zoom = clamp(zoom, 0, 1)
# 	elif event is InputEventKey


# export var pan_edge_extent:float # px form edge of screen

# export var pivot_path := @""; onready var pivot := get_node_or_null(pivot_path) as Position3D

# var camera_hight:float
# var pan_vector := Vector2.ZERO

# func _ready() -> void:
# 	camera_hight = translation.y
# 	reset_camera_position()
# 	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

# func reset_camera_position() -> void:
# 	pivot.translation = player.translation + camera_hight * Vector3.UP

# func _process(delta: float) -> void:
# 	pivot.translation += Vector3(pan_vector.x, 0, pan_vector.y) * pan_speed * delta
# 	print(pivot.rotation.y)
	
# 	pivot.rotate_y(swivl_speed * delta * (Input.get_action_strength("camera_rotate_left") - Input.get_action_strength("camera_rotate_right")))
	
# 	if Input.is_action_pressed("camera_reset_position"):
# 		reset_camera_position()
	

# func _pan_start_left() -> void:
# 	pan_vector.x = -1

# func _pan_start_right() -> void:
# 	pan_vector.x = 1
	
# func _pan_start_top() -> void:
# 	pan_vector.y = -1

# func _pan_start_bot() -> void:
# 	pan_vector.y = 1

# func _pan_stop_horizontal() -> void:
# 	pan_vector.x = 0

# func _pan_stop_vertical() -> void:
# 	pan_vector.y = 0
