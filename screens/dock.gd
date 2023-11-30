extends Control

##TODO añadir un nodo de Todo's (?)

var CurrentNodeSelected : Object
var json_path : String

func _ready() -> void:
	
	hide_toolbars()
	
	get_viewport().files_dropped.connect(on_files_dropped)
	
	json_path = "%s/%s/data.json" % [
		Vars.milangas_path,Vars.current_milanga_dir
	]
	
	## cargar data
	var milanga_data = Milangadata.load_data(json_path)
	
	## si no existe json, crearlo
	if milanga_data is int and milanga_data == ERR_FILE_NOT_FOUND:
		Milangadata.save_data(json_path,$GraphEdit)
		milanga_data = Milangadata.load_data(json_path)
	
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

func hide_toolbars() -> void:
	for n in $%CtrlToolbar.get_children():
		n.visible = false

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
		
		## si el archivo ya existe añadir un numero al nombre de archivo
		if FileAccess.file_exists(destination_path) == true:
			destination_path = "%s/%s/%s_%d.%s" % [
				Vars.milangas_path,
				Vars.current_milanga_dir, 
				files[0].get_file().get_slice(".",0),
				int(Time.get_unix_time_from_system()),
				files[0].get_extension()
			]
		
		var node_data:Dictionary = {}
		
		node_data = {
			"position": _get_mouse_pos(),
			"filename": destination_path.get_file(),
			"size_rect" : Vector2(300,300)
		}
		
		## copiar archivo
		DirAccess.copy_absolute(
			files[0], destination_path
		)
		
		$%ContextMenu.add_node(
			2, node_data
		)

func _get_mouse_pos() -> Vector2:
	return get_viewport().get_mouse_position()

func _on_context_menu_visibility_changed() -> void:
	$%BlackRect.visible = $ContextMenu.visible
	release_focus()

func _on_graph_edit_node_selected(node: Node) -> void:
	CurrentNodeSelected = node
	## al seleccionar un nodo, se muestra un toolbar con opciones extras, como cambiar los ajsutes del texto del nodo por ejemplo
	##dependiendo del type
	
	##BUG el contenedor padre de header no se achica si el texto se reduce en longitud (aunque se arregla en reinicio)
	##BUG al cambiar el size y luego seleccionar otro header, ese header recibe el size...
	
	match CurrentNodeSelected.type:
		0,1:
			$%HBxHeader.get_node("SpinBox").value = CurrentNodeSelected.data["size"]
			$%HBxHeader.get_node("ColorPickerButton").color = Color(CurrentNodeSelected.data["color"])
			$%HBxHeader.visible = true
		5:
			$%HBxLine.get_node("SpinBox").value = CurrentNodeSelected.data["width"]
			$%HBxLine.get_node("ChckBxArrow").button_pressed = CurrentNodeSelected.data["is_arrow"]
			$%HBxLine.get_node("ColorPickerButton").color = CurrentNodeSelected.data["color"]
			
			$%HBxLine.visible = true
			

func _on_graph_edit_node_deselected(node: Node) -> void:
	if CurrentNodeSelected == node:
		CurrentNodeSelected = null
		hide_toolbars()

## header y text
func _on_spin_box_header_fontsize_value_changed(value: float) -> void:
	if CurrentNodeSelected != null:
		CurrentNodeSelected.set_font_size(int(value))
func _on_color_picker_button_header_font_color_changed(color: Color) -> void:
	if CurrentNodeSelected != null:
		CurrentNodeSelected.set_font_color(color.to_html(false))

## line
func _on_spin_box_line_thick_value_changed(value: float) -> void:
	if CurrentNodeSelected != null:
		CurrentNodeSelected.set_thick(int(value))
func _on_chck_bx_line_arrow_toggled(toggled_on: bool) -> void:
	if CurrentNodeSelected != null:
		CurrentNodeSelected.set_arrow(toggled_on)
func _on_color_picker_button_line_color_changed(color: Color) -> void:
	if CurrentNodeSelected != null:
		CurrentNodeSelected.set_color(color.to_html(false))
