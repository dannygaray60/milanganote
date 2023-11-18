extends Control


var milangas_path : String

func _ready() -> void:
	milangas_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/MilangasNotas"

	get_viewport().files_dropped.connect(on_files_dropped)
	
	#var FileJson := FileAccess.open(
		#milangas_path + "/example.json", FileAccess.READ_WRITE
	#)
	#var json_parsed : Dictionary = JSON.parse_string(FileJson.get_as_text())
	
	#json_parsed["glossary"]["title"] = "texto cambiado yaay!"
	
	#json_parsed = {
		#"prubea":21321,"otraprueba":"fsdfdsfds","otracosa":34343
	#}
	#
	#FileJson.store_line(
		#JSON.stringify(json_parsed)
	#)
	#FileJson.close()
	

func on_files_dropped(files:PackedStringArray) -> void:
	if files.size() != 1:
		return
	
	##TODO con zoom diferente de 1, hay desfasimiento de la posicion a la real
	var mouse_position_on_graph : Vector2 = get_viewport().get_mouse_position() + $GraphEdit.scroll_offset / $GraphEdit.zoom
	var NewGraphEdit := GraphNode.new()
	var NewTexureRect := TextureRect.new()
	
	NewGraphEdit.resizable = true
	NewGraphEdit.position_offset = mouse_position_on_graph
	
	##TODO la textura no cambia de tamaño correctamente
	#NewTexureRect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	NewTexureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	##TODO si el archivo existe, no reemplazarlo, sino darle un numero consecutivo

	DirAccess.copy_absolute(
		files[0], milangas_path + "/" +files[0].get_file()
	)
	
	NewTexureRect.texture = get_texture_from_path(
		milangas_path + "/" +files[0].get_file()
	)
	
	NewGraphEdit.add_child(
		NewTexureRect
	)
	
	$GraphEdit.add_child(
		NewGraphEdit
	)

#retorna una textura a partir de p (path) o retorna textura si p es textura
func get_texture_from_path(p):
	if p == null:
		return
	if typeof(p) == TYPE_STRING:
		p = create_texture_from(p)
	return p

func create_texture_from(filepath) -> Texture:

	if FileAccess.file_exists(filepath) == false:
		print_debug("Error loading image, doesn't exists.")
		return null
#	print("creando textura de %s"%filepath)
	var img = Image.new()
	var err = img.load(filepath)
	if err!=0:
		print("Error loading image: "+filepath)
		return null

	#print_debug("Textura creada para: "+filepath)
	return ImageTexture.create_from_image(img)
