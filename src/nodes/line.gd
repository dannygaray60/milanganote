extends GraphElement

var grow_exp : int = 10

var data : Dictionary = {}

var type : int = 5

var _size_action : String = "none"

func make_duplicate_stylebox(separator_name:String="HSeparator") -> void:
	var HSep : HSeparator = get_node("%"+separator_name)
	HSep.add_theme_stylebox_override(
		"separator",
		HSep.get_theme_stylebox("separator").duplicate()
	)

func get_data() -> Dictionary:
	data["type"] = type
	data["position"] = position_offset
	return data

func set_data(dataset:Dictionary) -> void:
	make_duplicate_stylebox("HSeparator")
	make_duplicate_stylebox("HSepArr1")
	make_duplicate_stylebox("HSepArr2")
	data = dataset
	## setear a nodos
	$%HSeparator.get_theme_stylebox("separator").grow_begin = data["grow"]
	$%HSeparator.get_theme_stylebox("separator").grow_end = data["grow"]
	$%CtrlArrow.position.x = data["arrow_position"]
	$%HSeparator.rotation_degrees = data["rotation"]
	$%SliderRotate.value = data["rotation"]
	set_arrow(data["is_arrow"])
	set_color(data["color"])
	set_thick(data["width"])

func set_thick(thick:int) -> void:
	data["width"] = thick
	$%HSeparator.get_theme_stylebox("separator").thickness = thick
	$%HSepArr1.get_theme_stylebox("separator").thickness = thick
	$%HSepArr2.get_theme_stylebox("separator").thickness = thick
	
func set_color(clr:String) -> void:
	data["color"] = clr
	$%HSeparator.get_theme_stylebox("separator").color = Color(clr)
	$%HSepArr1.get_theme_stylebox("separator").color = Color(clr)
	$%HSepArr2.get_theme_stylebox("separator").color = Color(clr)
	
func set_arrow(is_arrow:bool=true) -> void:
	data["is_arrow"] = is_arrow
	$%CtrlArrow.visible = is_arrow

func _on_slider_rotate_value_changed(value: float) -> void:
	$%HSeparator.rotation_degrees = value
	data["rotation"] = value


func _on_node_selected() -> void:
	$%BorderPanel.visible = true
	$%SliderRotate.visible = true

func _on_node_deselected() -> void:
	$%BorderPanel.visible = false
	$%SliderRotate.visible = false

func _on_timer_change_size_timeout() -> void:
	if _size_action == "minus":
		$%HSeparator.get_theme_stylebox("separator").grow_begin += grow_exp
		$%HSeparator.get_theme_stylebox("separator").grow_end += grow_exp
		$%CtrlArrow.position.x -= grow_exp
	elif _size_action == "plus":
		$%HSeparator.get_theme_stylebox("separator").grow_begin -= grow_exp
		$%HSeparator.get_theme_stylebox("separator").grow_end -= grow_exp
		$%CtrlArrow.position.x += grow_exp
	data["grow"] = $%HSeparator.get_theme_stylebox("separator").grow_begin
	data["arrow_position"] = $%CtrlArrow.position.x

func _on_btn_plus_button_down() -> void:
	_size_action = "plus"
	$%TimerChangeSize.start()
func _on_btn_minus_button_down() -> void:
	_size_action = "minus"
	$%TimerChangeSize.start()
func _on_btn_size_action_released() -> void:
	_size_action = "none"
	$%TimerChangeSize.stop()

func _on_dragged(_from: Vector2, to: Vector2) -> void:
	data["position"] = to
