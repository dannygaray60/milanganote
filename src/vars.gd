extends Node

var milangas_path : String
var current_milanga_dir : String = ""

var milanga_info : Dictionary = {
	"name":"MyMilanga",
	"scroll_offset": Vector2(0,0),
	"zoom":1
}

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

func get_current_milanga_dir() -> String:
	return "%s/%s" % [milangas_path,current_milanga_dir]
