extends Control

##TODO al seleccionar un nodo, se muestra un toolbar con opciones extras, como cambiar los ajsutes del texto del nodo por ejemplo

var CurrentNodeSelected : Object
var json_path : String

func _ready() -> void:
	
	get_viewport().files_dropped.connect(on_files_dropped)
	
	json_path = "%s/%s/data.json" % [
		Vars.milangas_path,Vars.current_milanga_dir
	]
	
	## si no existe json, crearlo
	if Milangadata.load_data(json_path) == ERR_FILE_NOT_FOUND:
		Milangadata.save_data(json_path)
	
	## cargar data
	Milangadata.load_data(json_path)

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
		
		var node_data:Dictionary
		node_data["image_file"] = destination_path.get_file()
		
		## TODO si el archivo existe, no reemplazarlo, sino darle un numero consecutivo
		## copiar archivo
		DirAccess.copy_absolute(
			files[0], destination_path
		)
		
		$%ContextMenu.add_node(
			2, node_data, _get_mouse_pos()
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
