extends PanelContainer

@export var GraphEditNode : GraphEdit

var NodeHeader = preload("res://src/nodes/header.tscn")
var NodeText = preload("res://src/nodes/text.tscn")
var NodeImage = preload("res://src/nodes/image.tscn")
var NodeURL = preload("res://src/nodes/url.tscn")

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
					"size": 20,
					"color": "#ffffff"
				}
		## text
		1:
			NodeObj = NodeText.instantiate()
			if data.is_empty() == true:
				data = {
					"position":position_origin,
					"text": "Example text...",
					"size": 10,
					"color": "#ffffff",
					"size_rect" : Vector2(151,80)
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
				}

	data["type"] = type
	
	## TODO con zoom diferente de 1, hay desfasimiento de la posicion a la real
	NodeObj.position_offset = position_origin + GraphEditNode.scroll_offset / GraphEditNode.zoom
	
	GraphEditNode.add_child(NodeObj)
	
	if data.has("position") == true:
		
		## convertir position string a vector2
		if data["position"] is String:
			data["position"] = string_to_vector2(data["position"])
		
		position_origin = data["position"]
	
	else:
		data["position"] = position_origin
	
	NodeObj.set_data(data)
	
	NodeObj.connect(
		"raise_request",
		Callable(get_parent(),"_on_raise_node").bind(NodeObj.name)
	)
	NodeObj.connect(
		"node_deselected",
		Callable(get_parent(),"_on_deselected_node").bind(NodeObj.name)
	)

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
		else:
			$%BtnDel.visible = false

func _on_focus_exited() -> void:
	visible = false


func _on_btn_delete_pressed() -> void:
	get_parent().CurrentNodeSelected.queue_free()
	release_focus()


func _on_btn_save_pressed() -> void:
	Milangadata.save_data(
		Vars.get_current_milanga_dir() + "/data.json", GraphEditNode
	)
