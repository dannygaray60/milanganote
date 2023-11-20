extends GraphNode

##TODO al hacer doble click abrir imagen en pantalla completa

var type : int = 2

var image_file : String

func _ready() -> void:
	title = image_file
	$TextureRect.texture = create_texture_from(
		"%s/%s/%s" % [
			Vars.milangas_path,
			Vars.current_milanga_dir, 
			image_file
		]
	)

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
