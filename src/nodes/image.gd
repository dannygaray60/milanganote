extends GraphNode

##TODO al hacer doble click abrir imagen en pantalla completa

var data : Dictionary = {}

var type : int = 2

var image_file : String

func get_data() -> Dictionary:
	data["type"] = type
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	##TODO setear a nodos
	position_offset = data["position"]
	title = data["filename"]
	$TextureRect.texture = create_texture_from(
		"%s/%s/%s" % [
			Vars.milangas_path,
			Vars.current_milanga_dir, 
			data["filename"]
		]
	)
	size = data["size_rect"]

func create_texture_from(filepath:String) -> Texture:

	if FileAccess.file_exists(filepath) == false:
		print_debug("Error loading image, doesn't exists.")
		return null
#	print("creando textura de %s"%filepath)
	var img = Image.new()
	var err = img.load(filepath)
	if err!=0:
		print_debug("Error loading image: "+filepath)
		return null

	#print_debug("Textura creada para: "+filepath)
	return ImageTexture.create_from_image(img)

func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to

func _on_resize_request(new_minsize: Vector2) -> void:
	data["size_rect"] = new_minsize
