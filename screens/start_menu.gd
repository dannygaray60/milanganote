extends Control

func _ready() -> void:
	load_milangas_buttons()

func load_milangas_buttons() -> void:
	for n in $%HFlowCMilangas.get_children():
		n.queue_free()
	## cargar accesos directos a milangas creadas para abrirlas
	for dir in DirAccess.get_directories_at(Vars.milangas_path):
		if FileAccess.file_exists(Vars.milangas_path+"/"+dir+"/data.json"):
			var Btn := Button.new()
			Btn.text = dir
			Btn.add_theme_font_size_override("font_size",30)
			Btn.pressed.connect(open_milanga.bind(dir))
			Btn.focus_mode = Control.FOCUS_NONE
			$%HFlowCMilangas.add_child(Btn)

func open_milanga(milanga_name:String) -> void:
	milanga_name = milanga_name.strip_edges()
	if (
		milanga_name.is_empty() == false
		and milanga_name.is_valid_filename()
	):
		Vars.current_milanga_dir = milanga_name
		Vars.milanga_info["name"] = milanga_name
		get_tree().change_scene_to_file("res://screens/dock.tscn")

func _on_btn_create_milanga_pressed() -> void:
	$%WindowNewMilanga.popup_centered()
	$%LnEditMilangaName.grab_focus()

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

func _on_btn_repo_pressed() -> void:
	OS.shell_open(
		"https://github.com/dannygaray60/milanganote"
	)


func _on_btn_open_dir_milangas_pressed() -> void:
	OS.shell_open(
		Vars.milangas_path
	)


func _on_btn_open_dir_pressed() -> void:
	OS.shell_open(
		OS.get_user_data_dir()
	)


func _on_btn_reload_pressed() -> void:
	load_milangas_buttons()
