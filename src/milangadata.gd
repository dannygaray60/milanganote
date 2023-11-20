extends Node

func load_data(json_path:String) -> int:
	if FileAccess.file_exists(json_path) == false:
		return ERR_FILE_NOT_FOUND
	else:
		var FileJson := FileAccess.open(
			json_path, FileAccess.READ
		)
		var json_string : String = FileJson.get_line()
		
		FileJson.close()
		
		Vars.milanga_data = JSON.parse_string(json_string)
		
		return OK

func save_data(json_path:String) -> int:
	
	var FileJson := FileAccess.open(
		json_path, FileAccess.WRITE
	)
	
	var json_data : String = JSON.stringify(
		Vars.milanga_data
	)
	
	FileJson.store_line(json_data)
	
	FileJson.close()
	
	return OK
