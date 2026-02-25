extends Node
class_name State

var character: Character
var state_machine: StateMachine

## 进入状态触发一次
func enter() -> void:
	pass


## process触发
func update(_delta: float) -> void:
	pass


## physics process触发
func physics_update(_delta: float) -> void:
	pass


## 退出状态触发一次
func exit() -> void:
	pass
