extends PanelContainer

@export var GraphEditNode : GraphEdit

var NodeHeader = preload("res://src/nodes/header.tscn")
var NodeText = preload("res://src/nodes/text.tscn")
var NodeImage = preload("res://src/nodes/image.tscn")
var NodeURL = preload("res://src/nodes/url.tscn")
var NodeColor = preload("res://src/nodes/color_ref.tscn")
var NodeLine = preload("res://src/nodes/line.tscn")

var nodes_count : int = 0

func _ready() -> void:
	visible = false
	

func add_node(
	type:int,data:Dictionary,
	position_origin:Vector2=position
) -> void:
	
	nodes_count += 1
	
	var NodeObj : Object
	
	match type:
		## header
		0:
			NodeObj = NodeHeader.instantiate()
			if data.is_empty() == true:
				data = {
					"position":position_origin,
					"text": "Header",
					"size": 45,
					"color": "#ffffff"
				}
		## text
		1:
			NodeObj = NodeText.instantiate()
			if data.is_empty() == true:
				data = {
					"position":position_origin,
					"text": "Example text...",
					"size": 26,
					"color": "#ffffff",
					"size_rect" : Vector2(240,170)
				}
			if data["size_rect"] is String:
				data["size_rect"] = string_to_vector2(data["size_rect"])
		2:
			NodeObj = NodeImage.instantiate()
			if data["size_rect"] is String:
				data["size_rect"] = string_to_vector2(data["size_rect"])
		3:
			NodeObj = NodeURL.instantiate()
			if data.is_empty() == true:
				data = {
					"position":position_origin,
					"url": "",
					"size": 10,
					"color": "#ffffff",
					"arrow":false
				}
		4:
			NodeObj = NodeColor.instantiate()
			if data.is_empty() == true:
				data = {
					"position":position_origin,
					"color": "#ffffff",
				}
		5:
			NodeObj = NodeLine.instantiate()
			if data.is_empty() == true:
				data = {
					"position":position_origin,
					"is_arrow": true,
					"arrow_position": -85,
					"color": "#ffffff",
					"grow":81,
					"width": 4,
					"rotation":0
				}

	data["type"] = type
	
	if data.has("position") == true:
		## convertir position string a vector2
		if data["position"] is String:
			data["position"] = string_to_vector2(data["position"])
		position_origin = data["position"]
	

	## ajustar posicion dentro del graphedit
	NodeObj.position_offset = (position_origin + GraphEditNode.scroll_offset) / GraphEditNode.zoom
	
	NodeObj.set_data(data)
	
	GraphEditNode.add_child(NodeObj)
	
	## DEPRECATED señales ya no son necesarias ya que graphedit los tiene
	#NodeObj.connect(
		#"raise_request",
		#Callable(get_parent(),"_on_raise_node").bind(NodeObj.name)
	#)
	#NodeObj.connect(
		#"node_deselected",
		#Callable(get_parent(),"_on_deselected_node").bind(NodeObj.name)
	#)

func string_to_vector2(strng:String) -> Vector2:
	var vect : Vector2
	var arr : PackedStringArray
	strng = strng.replace("(","")
	strng = strng.replace(")","")
	arr = strng.split(",")
	vect = Vector2(
		float(arr[0].strip_edges()),
		float(arr[1].strip_edges())
	)
	return vect

func _on_button_pressed() -> void:
	release_focus()


func _on_visibility_changed() -> void:
	if visible == true:
		grab_focus()
		
		if get_parent().CurrentNodeSelected != null:
			$%BtnDel.visible = true
			if get_parent().CurrentNodeSelected.type == 2:
				$%ChkDelFile.visible = true
			else:
				$%ChkDelFile.visible = false
		else:
			$%BtnDel.visible = false

func _on_focus_exited() -> void:
	visible = false


func _on_btn_delete_pressed() -> void:
	if (
		$%ChkDelFile.button_pressed == true
		and get_parent().CurrentNodeSelected.type==2
	):
		get_parent().CurrentNodeSelected.delete_image()
	get_parent().CurrentNodeSelected.queue_free()
	get_parent().hide_toolbars()
	release_focus()


func _on_btn_save_pressed() -> void:
	Milangadata.save_data(
		Vars.get_current_milanga_dir() + "/data.json", GraphEditNode
	)


func _on_btn_close_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/start_menu.tscn")


func _on_btn_help_pressed() -> void:
	OS.shell_open(
		"https://github.com/dannygaray60/milanganote"
	)
