extends Label

func _ready() -> void:
	Signals.connect("print_quote", self, "_on_quote_recived")

func _on_quote_recived(quote:String) -> void:
	text = quote
