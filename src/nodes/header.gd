extends GraphElement

var data : Dictionary = {}

var type : int = 0


func get_data() -> Dictionary:
	data["type"] = type
	data["position"] = position_offset
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	## setear a nodos
	$%Label.text = data["text"]
	$%LineEdit.text = data["text"]
	set_font_size(data["size"])
	set_font_color(data["color"])

func set_font_size(siz:int) -> void:
	$%Label.add_theme_font_size_override("font_size",siz)
	$%LineEdit.add_theme_font_size_override("font_size",siz)
	data["size"] = siz
func set_font_color(clr:String) -> void:
	$%Label.add_theme_color_override("font_color",Color(clr))
	$%LineEdit.add_theme_color_override("font_color",Color(clr))
	data["color"] = clr

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
	$%BorderPanel.size = size

func _on_line_edit_text_submitted(_new_text: String) -> void:
	_on_node_deselected()

func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to
