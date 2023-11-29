extends Node

func load_data(json_path:String) -> Variant:
	if FileAccess.file_exists(json_path) == false:
		return ERR_FILE_NOT_FOUND
	else:
		var FileJson := FileAccess.open(
			json_path, FileAccess.READ
		)
		var json_string : String = FileJson.get_line()
		
		FileJson.close()
		
		return JSON.parse_string(json_string)

func save_data(json_path:String,GraphEd:GraphEdit) -> int:

	var milanga_nodes : Dictionary = {}

	Vars.milanga_info["scroll_offset"] = GraphEd.scroll_offset
	Vars.milanga_info["zoom"] = GraphEd.zoom
	
	for n in GraphEd.get_children():
		if n is GraphNode or n is GraphElement:
			milanga_nodes[n.name] = n.get_data()
	
	var FileJson := FileAccess.open(
		json_path, FileAccess.WRITE
	)
	
	var json_data : String = JSON.stringify(
		{
			"data":Vars.milanga_info,
			"nodes":milanga_nodes
		}
	)
	
	FileJson.store_line(json_data)
	
	FileJson.close()
	
	return OK
