extends Control

func open_milanga(milanga_name:String) -> void:
	Vars.current_milanga_dir = milanga_name
	Vars.milanga_info["data"]["name"] = milanga_name
	get_tree().change_scene_to_file("res://screens/dock.tscn")

func _on_btn_create_milanga_pressed() -> void:
	$%WindowNewMilanga.popup_centered()

func _on_window_new_milanga_close_requested() -> void:
	$WindowBlackRect.visible = false
	$%WindowNewMilanga.hide()
func _on_window_new_milanga_about_to_popup() -> void:
	$WindowBlackRect.visible = true

func _on_btn_milanga_create_pressed() -> void:
	DirAccess.make_dir_absolute(
		Vars.milangas_path + "/" + $%LnEditMilangaName.text
	)
	open_milanga(
		$%LnEditMilangaName.text
	)
	



