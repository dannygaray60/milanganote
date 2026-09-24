extends Node

func load_data(json_path:String) -> Variant:
	if FileAccess.file_exists(json_path) == false:
		return ERR_FILE_NOT_FOUND

	var result = _read_json_file(json_path)
	if result != null:
		return result

	push_warning(
		"MilangaNote: %s no se pudo leer o no es un JSON válido, intentando recuperar el respaldo..." % json_path
	)

	var backup_path : String = json_path + ".bak"
	if FileAccess.file_exists(backup_path):
		result = _read_json_file(backup_path)
		if result != null:
			push_warning("MilangaNote: se recuperó el respaldo (%s) correctamente." % backup_path)
			return result

	push_warning("MilangaNote: no se encontró ningún respaldo válido, se inicia con datos vacíos.")
	return {
		"data": {"scroll_offset": "(0, 0)", "zoom": 1.0},
		"nodes": {}
	}


## Lee y parsea un archivo JSON completo. Devuelve null si el archivo no se
## pudo abrir, o si su contenido no es JSON válido / no es un Dictionary.
func _read_json_file(path:String) -> Variant:
	var FileJson := FileAccess.open(path, FileAccess.READ)
	if FileJson == null:
		return null

	var json_string : String = FileJson.get_as_text()
	FileJson.close()

	var json := JSON.new()
	var error : Error = json.parse(json_string)

	if error != OK:
		push_warning(
			"MilangaNote: error al parsear %s -> %s (línea %d)" % [
				path, json.get_error_message(), json.get_error_line()
			]
		)
		return null

	if json.data is Dictionary == false:
		return null

	return json.data


func save_data(json_path:String,GraphEd:GraphEdit) -> int:

	var milanga_nodes : Dictionary = {}

	Vars.milanga_info["scroll_offset"] = GraphEd.scroll_offset
	Vars.milanga_info["zoom"] = GraphEd.zoom
	
	for n in GraphEd.get_children():
		if n is GraphNode or n is GraphElement:
			milanga_nodes[n.name] = n.get_data()

	## "\t" embellece el JSON con tabulaciones en vez de guardarlo en una sola línea
	var json_string : String = JSON.stringify(
		{
			"data":Vars.milanga_info,
			"nodes":milanga_nodes
		},
		"\t"
	)

	## 1) escribir primero en un archivo temporal
	var tmp_path : String = json_path + ".tmp"
	var FileJson := FileAccess.open(tmp_path, FileAccess.WRITE)

	if FileJson == null:
		var err : Error = FileAccess.get_open_error()
		push_warning("MilangaNote: no se pudo abrir %s para guardar (error %d)" % [tmp_path, err])
		return err

	FileJson.store_string(json_string)
	FileJson.close()

	## 2) verificar que lo escrito es JSON válido antes de tocar el archivo real
	if _read_json_file(tmp_path) == null:
		push_warning(
			"MilangaNote: los datos generados no son un JSON válido, se cancela el guardado para no corromper %s" % json_path
		)
		DirAccess.remove_absolute(tmp_path)
		return ERR_INVALID_DATA

	## 3) respaldar el archivo anterior (si existe) antes de reemplazarlo
	if FileAccess.file_exists(json_path):
		DirAccess.copy_absolute(json_path, json_path + ".bak")

	## 4) reemplazar el archivo real por el temporal ya verificado
	##    (se usa copy + remove en vez de rename_absolute, que en algunas
	##    plataformas como Android no es confiable)
	var copy_err : Error = DirAccess.copy_absolute(tmp_path, json_path)
	DirAccess.remove_absolute(tmp_path)

	return copy_err
