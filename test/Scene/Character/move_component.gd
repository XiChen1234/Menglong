extends Node
class_name MoveComponent

@export var move_speed: float = 5

@onready var character: Character = $".."

var _move_dir: Vector3 = Vector3.ZERO
var _is_moving: bool = false


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_movement()
	character.move_and_slide()


func apply_gravity(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta


func apply_movement() -> void:
	character.velocity.x = _move_dir.x * move_speed
	character.velocity.z = _move_dir.z * move_speed
	_is_moving = _move_dir.length_squared() > 0.0001 # 平方


## 提供设置输入方向的接口
func set_move_dir(dir: Vector2) -> void:
	_move_dir = Vector3(dir.x, 0, dir.y)


## 提供获取输入方向的接口
func get_move_dir() -> Vector3:
	return _move_dir


## 提供获取是否移动的接口
func get_is_moving() -> bool:
	return _is_moving
