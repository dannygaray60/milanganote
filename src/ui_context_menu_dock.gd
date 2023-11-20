extends PanelContainer

@export var GraphEditNode : GraphEdit

var NodeHeader = preload("res://src/nodes/header.tscn")
var NodeText = preload("res://src/nodes/text.tscn")
var NodeImage = preload("res://src/nodes/image.tscn")
var NodeURL = preload("res://src/nodes/url.tscn")

func _ready() -> void:
	visible = false
	

func add_node(
	type:int,data:Dictionary,
	position_origin:Vector2=position
) -> void:
	
	var NodeObj : Object
	
	match type:
		## header
		0:
			NodeObj = NodeHeader.instantiate()
			if data.is_empty() == false:
				NodeObj.set_text(data["text"])
		
		1:
			NodeObj = NodeText.instantiate()
		
		2:
			NodeObj = NodeImage.instantiate()
			if data.is_empty() == false:
				NodeObj.image_file = data["image_file"]

		3:
			NodeObj = NodeURL.instantiate()
	
	## TODO con zoom diferente de 1, hay desfasimiento de la posicion a la real
	NodeObj.position_offset = position_origin + GraphEditNode.scroll_offset / GraphEditNode.zoom
	
	GraphEditNode.add_child(NodeObj)
	
	NodeObj.connect(
		"raise_request",
		Callable(get_parent(),"_on_raise_node").bind(NodeObj.name)
	)
	NodeObj.connect(
		"node_deselected",
		Callable(get_parent(),"_on_deselected_node").bind(NodeObj.name)
	)

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
