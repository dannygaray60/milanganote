extends GraphElement

var data : Dictionary = {}

var type : int = 4

func get_data() -> Dictionary:
	data["type"] = type
	data["position"] = position_offset
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	## setear a nodos
	_on_color_picker_color_changed(Color(data["color"]))

func _on_color_picker_color_changed(clr: Color) -> void:
	$%ColorRect.color = clr
	$%ColorPicker.color = clr
	$%LineEdit.text = "#"+clr.to_html(false)
	data["color"] = $%LineEdit.text

func _on_line_edit_focus_entered() -> void:
	$%LineEdit.select_all()


func _on_btn_copy_hex_pressed() -> void:
	DisplayServer.clipboard_set($%LineEdit.text)


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_html_color():
		_on_color_picker_color_changed(Color(new_text))
		_on_graph_double_click_detect_double_clicked()


func _on_graph_double_click_detect_double_clicked() -> void:
	$%ColorPicker.visible = true

func _on_node_deselected() -> void:
	$%ColorPicker.visible = false
	$%BorderPanel.visible = false
	size = custom_minimum_size

func _on_node_selected() -> void:
	$%BorderPanel.visible = true


func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to


func _on_line_edit_focus_exited() -> void:
	if $%ColorPicker.visible == true:
		_on_node_deselected()
