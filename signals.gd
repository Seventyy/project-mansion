extends Node

signal print_quote(quote); func print_quote(quote: String) -> void: emit_signal("print_quote", quote)
