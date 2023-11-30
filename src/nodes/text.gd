extends GraphElement

var data : Dictionary = {}

var type : int = 1

func get_data() -> Dictionary:
	data["type"] = type
	data["position"] = position_offset
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	## setear a nodos
	$%TextEdit.text = data["text"]
	_on_text_edit_text_changed()
	size = data["size_rect"]
	set_font_size(data["size"])
	set_font_color(data["color"])

func set_font_size(siz:int) -> void:
	$%RichTextLabel.add_theme_font_size_override("normal_font_size",siz)
	$%TextEdit.add_theme_font_size_override("font_size",siz)
	data["size"] = siz
func set_font_color(clr:String) -> void:
	$%RichTextLabel.add_theme_color_override("default_color",Color(clr))
	#$%TextEdit.add_theme_color_override("font_color",Color(clr))
	data["color"] = clr

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
