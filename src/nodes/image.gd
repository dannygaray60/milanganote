extends GraphElement

var data : Dictionary = {}

var type : int = 2

var image_file : String

func get_data() -> Dictionary:
	data["type"] = type
	data["position"] = position_offset
	return data

func set_data(dataset:Dictionary) -> void:
	data = dataset
	## setear a nodos
	#title = data["filename"]
	$%TextureRect.texture = create_texture_from(
		Vars.get_opened_milanga_dir()+"/%s" % [
			data["filename"]
		]
	)
	size = data["size_rect"]

func delete_image() -> void:
	var path : String = Vars.get_opened_milanga_dir()+"/%s" % [
		data["filename"]
	]
	if FileAccess.file_exists(path) == true:
		OS.move_to_trash(path)

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


func _on_graph_double_click_detect_double_clicked() -> void:
	OS.shell_open(
		Vars.get_opened_milanga_dir()+"/%s" % [
			data["filename"]
		]
	)


func _on_node_selected() -> void:
	$%BorderPanel.visible = true


func _on_node_deselected() -> void:
	$%BorderPanel.visible = false
