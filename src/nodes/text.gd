extends GraphElement

var data : Dictionary = {}

var type : int = 1

func get_data() -> Dictionary:
	data["type"] = type
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	##TODO setear a nodos
	position_offset = data["position"]
	$%TextEdit.text = data["text"]
	_on_text_edit_text_changed()
	size = data["size_rect"]

func _on_graph_double_click_detect_double_clicked() -> void:
	$%TextEdit.visible = true
	$%RichTextLabel.visible = false

func _on_node_selected() -> void:
	$%BorderPanel.visible = true

func _on_node_deselected() -> void:
	release_focus()
	$%TextEdit.visible = false
	$%RichTextLabel.visible = true
	$%BorderPanel.visible = false


func _on_text_edit_text_changed() -> void:
	var new_text : String = $%TextEdit.text
	new_text = new_text.strip_edges()
	if new_text.is_empty() == true:
		new_text = "Example text..."
	$%RichTextLabel.text = $%TextEdit.text
	data["text"] = new_text

func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to



func _on_resize_request(new_minsize: Vector2) -> void:
	data["size_rect"] = new_minsize
