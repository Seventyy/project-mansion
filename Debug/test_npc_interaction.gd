extends InteractionHandler

func _on_intaraction() -> void:
	add_child(Dialogic.start("/Debug/DebugBasicInteraction"))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
