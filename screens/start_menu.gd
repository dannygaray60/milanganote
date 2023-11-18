extends Control

var milangas_path : String

func _ready() -> void:
	milangas_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/MilangasNotas"
	_check_milangas_dir()
	
	
func _check_milangas_dir() -> void:
	var dir_exists : bool = DirAccess.dir_exists_absolute(
		milangas_path
	)
	if dir_exists == false:
		var err : int = DirAccess.make_dir_absolute(
			milangas_path
		)
		if err != OK:
			print_debug("Error making dir %d"%[err])
	

func _on_btn_create_milanga_pressed() -> void:
	$%WindowNewMilanga.show()


func _on_window_new_milanga_close_requested() -> void:
	$%WindowNewMilanga.hide()


func _on_btn_milanga_create_pressed() -> void:
	DirAccess.make_dir_absolute(
		milangas_path + "/" + $%LnEditMilangaName.text
	)
