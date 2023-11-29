extends GraphElement

var data : Dictionary = {}

var type : int = 0


func get_data() -> Dictionary:
	data["type"] = type
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	##TODO setear a nodos
	position_offset = data["position"]
	$%Label.text = data["text"]

func set_text(text:String) -> void:
	_on_line_edit_text_changed(text)

func _on_graph_double_click_detect_double_clicked() -> void:
	$%LineEdit.visible = true
	$%LineEdit.grab_focus()
	$%LineEdit.select_all()
	$%Label.visible = false

func _on_node_deselected() -> void:
	release_focus()
	$%LineEdit.visible = false
	$%Label.visible = true
	$%BorderPanel.visible = false

func _on_node_selected() -> void:
	$%BorderPanel.visible = true

func _on_line_edit_text_changed(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if new_text.is_empty() == true:
		new_text = "Header"
	$%Label.text = new_text
	data["text"] = new_text

func _on_line_edit_text_submitted(_new_text: String) -> void:
	_on_node_deselected()

func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to
