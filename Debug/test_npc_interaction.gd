extends InteractionHandler

func _on_intaraction() -> void:
	add_child(Dialogic.start("/Debug/DebugBasicInteraction"))
