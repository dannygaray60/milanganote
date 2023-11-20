extends GraphElement

var type : int = 3

func _on_line_edit_text_changed(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if new_text.is_empty() == false:
		$%BtnGo.visible = true
	else:
		$%BtnGo.visible = false


func _on_node_selected() -> void:
	$%BorderPanel.visible = true
func _on_node_deselected() -> void:
	release_focus()
	$%BorderPanel.visible = false


func _on_btn_go_pressed() -> void:
	var uri : String = $%LineEdit.text
	OS.shell_open(uri)
