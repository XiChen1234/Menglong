extends Node
class_name MoveComponent

@export var speed: float = 5

var character: Character
var _move_dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	character = get_parent()


## 对外提供移动接口
func move(dir: Vector2, delta: float) -> void:
	_move_dir = dir
	_apply_gravity(delta)
	_apply_movement()


## 对外提供停止接口
func stop() -> void:
	character.velocity.x = 0
	character.velocity.z = 0


"""应用重力"""
func _apply_gravity(delta) -> void:
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta


"""应用移动"""
func _apply_movement() -> void:
	character.velocity.x = _move_dir.x * speed
	character.velocity.z = _move_dir.y * speed


## 通过输入方向设置移动方向
func set_move_dir(dir: Vector2) -> void:
	_move_dir = dir


## 获取移动方向方向的接口
func get_move_dir() -> Vector2:
	return _move_dir


## 获取是否移动的接口
func get_is_moving() -> bool:
	return _move_dir.length_squared() > 0.0001
