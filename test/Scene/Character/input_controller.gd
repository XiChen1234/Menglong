extends Node
class_name InputController

@onready var move_component: MoveComponent = $"../MoveComponent"

func _process(_delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	move_component.set_move_dir(input_dir) 
