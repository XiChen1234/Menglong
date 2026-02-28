extends Node
class_name ControlComponent
"""
控制中心组件
用于表达角色对自身行为的控制意图
- 玩家：输入
- 敌人：ai
"""

## 移动输入
var _move_input: Vector2 = Vector2.ZERO


## 输入决策，子类需要继承重写，实现具体的输入决策
func control() -> void:
	pass


#region 移动部分
## 获取输入的移动方向
func get_move_dir() -> Vector2:
	return _move_input


## 设置移动方向
func set_move_input(dir: Vector2) -> void:
	_move_input = dir


## 获取移动状态
func get_is_moving() -> bool:
	return _move_input.length_squared() > 0.0001

#endregion
