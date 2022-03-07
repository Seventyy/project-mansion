extends Node

class_name InteractionManager

export var camera_path :=  @""; onready  var camera :=  get_node(camera_path) as Camera

onready var raycast:RayCast = camera.get_child(0)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and is_instance_valid(raycast.get_collider()):
		Utils.get_component(raycast.get_collider(), InteractionHandler)._on_intaraction()
