extends Node
class_name ControlComponent
"""
控制中心组件
用于表达角色对自身行为的控制意图
- 玩家：输入
- 敌人：ai
"""

## 移动方向
var _move_dir: Vector2 = Vector2.ZERO


## 输入决策，子类需要继承重写
func control() -> void:
	pass


## 获取移动方向
func get_move_dir() -> Vector2:
	return _move_dir


## 设置移动方向
func set_move_dir(dir: Vector2) -> void:
	_move_dir = dir


## 获取移动状态
func get_is_moving() -> bool:
	return _move_dir.length_squared() > 0.0001
