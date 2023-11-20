extends Node

signal double_clicked

## Nodo para detectar doble click en nodos parent que sean graph...
## hay que conectar raise_request a _on_raise

func _on_raise() -> void:
	if $Timer.is_stopped() == false:
		emit_signal("double_clicked")
	$Timer.start()
