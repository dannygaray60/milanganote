extends Control

##TODO al seleccionar un nodo, se muestra un toolbar con opciones extras, como cambiar los ajsutes del texto del nodo por ejemplo

var CurrentNodeSelected : Object
var json_path : String

func _ready() -> void:
	
	get_viewport().files_dropped.connect(on_files_dropped)
	
	json_path = "%s/%s/data.json" % [
		Vars.milangas_path,Vars.current_milanga_dir
	]
	
	## cargar data
	var milanga_data = Milangadata.load_data(json_path)
	
	## si no existe json, crearlo
	if milanga_data is int and milanga_data == ERR_FILE_NOT_FOUND:
		Milangadata.save_data(json_path,$GraphEdit)
	
	## recorrer nodos
	if milanga_data.has("nodes"):
		for n in milanga_data["nodes"]:
			var n_data : Dictionary = milanga_data["nodes"][n]
			$%ContextMenu.add_node(
				int(n_data["type"]), n_data
			)
	
	$GraphEdit.zoom = milanga_data["data"]["zoom"]
	$GraphEdit.scroll_offset = $%ContextMenu.string_to_vector2(
		milanga_data["data"]["scroll_offset"]
	) 

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_mouse_right"):
		$%ContextMenu.visible = true
		$%ContextMenu.position = _get_mouse_pos()


func on_files_dropped(files:PackedStringArray) -> void:

	if files.size() != 1:
		return
	
	if files[0].get_extension().to_lower() in [
		"jpg","jpeg","png"
	]:
		
		var destination_path : String = "%s/%s/%s" % [
			Vars.milangas_path,
			Vars.current_milanga_dir, 
			files[0].get_file()
		]
		
		var node_data:Dictionary = {}
		
		node_data = {
			"position": _get_mouse_pos(),
			"filename": destination_path.get_file(),
			"size_rect" : Vector2(56,56)
		}
		
		## TODO si el archivo existe, no reemplazarlo, sino darle un numero consecutivo
		## copiar archivo
		DirAccess.copy_absolute(
			files[0], destination_path
		)
		
		$%ContextMenu.add_node(
			2, node_data
		)

func _get_mouse_pos() -> Vector2:
	return get_viewport().get_mouse_position()

func _on_raise_node(node_name:String) -> void:
	CurrentNodeSelected = $GraphEdit.get_node(node_name)

func _on_deselected_node(node_name:String) -> void:
	if CurrentNodeSelected == $GraphEdit.get_node(node_name):
		CurrentNodeSelected = null

func _on_context_menu_visibility_changed() -> void:
	$%BlackRect.visible = $ContextMenu.visible
	release_focus()
