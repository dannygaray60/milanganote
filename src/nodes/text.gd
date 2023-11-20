extends GraphElement

var type : int = 1

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



