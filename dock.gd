extends GraphEdit

func _drop_data(at_position: Vector2, data: Variant) -> void:
	print(data)

func _ready():
	get_viewport().files_dropped.connect(on_files_dropped)

func on_files_dropped(files):
	print(files)
