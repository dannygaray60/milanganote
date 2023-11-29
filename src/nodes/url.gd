extends GraphElement

var data : Dictionary = {}

var type : int = 3

func get_data() -> Dictionary:
	data["type"] = type
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	##TODO setear a nodos
	position_offset = data["position"]
	_on_line_edit_text_changed(data["url"])
	$%LineEdit.text = data["url"]

func _on_line_edit_text_changed(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if new_text.is_empty() == false:
		$%BtnGo.visible = true
	else:
		$%BtnGo.visible = false
	data["url"] = new_text

func _on_node_selected() -> void:
	$%BorderPanel.visible = true
func _on_node_deselected() -> void:
	release_focus()
	$%BorderPanel.visible = false


func _on_btn_go_pressed() -> void:
	var uri : String = $%LineEdit.text
	OS.shell_open(uri)


func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to
