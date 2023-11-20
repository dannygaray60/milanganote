extends Node

var Cnf := ConfigFile.new()
var cnf_path : String = "user://settings.ini"

func _ready() -> void:
	var err := Cnf.load(cnf_path)
	
	if err == ERR_FILE_NOT_FOUND:
		Cnf.save(cnf_path)
	
	Cnf.load(cnf_path)
	
	if Cnf.has_section_key("main","milangas_path") == false:
		Cnf.set_value(
			"main","milangas_path",
			OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/MilangasNotas"
		)
	
	Cnf.save(cnf_path)
