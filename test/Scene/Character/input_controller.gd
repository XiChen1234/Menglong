extends ControlComponent
class_name InputController


func control() -> void:
	var move_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	_set_move_input(move_dir)
