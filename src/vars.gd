extends Node

var milangas_path : String
var current_milanga_dir : String = "Testeo de Proyecto"

var milanga_data : Dictionary

func _ready() -> void:
	## establecer milangas_path si no hay config establecida antes
	milangas_path = Config.Cnf.get_value("main","milangas_path")
	check_milangas_dir()
	
func check_milangas_dir() -> void:
	var dir_exists : bool = DirAccess.dir_exists_absolute(
		milangas_path
	)
	if dir_exists == false:
		var err : int = DirAccess.make_dir_absolute(
			milangas_path
		)
		if err != OK:
			print_debug("Error making dir %d"%[err])
	
