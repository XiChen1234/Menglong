extends Node
class_name InputController

@onready var move_component: MoveComponent = $"../MoveComponent"

var _input_dir: Vector2

func _process(_delta: float) -> void:
	_input_dir = Input.get_vector("left", "right", "up", "down")
	move_component.set_move_dir(_input_dir)
