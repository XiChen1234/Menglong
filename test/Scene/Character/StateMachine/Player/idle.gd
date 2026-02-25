extends State
class_name Idle


## 进入状态触发一次
func enter() -> void:
	character.animation_component.play_base("idle")


## process触发
func update(_delta: float) -> void:
	pass


## physics process触发
func physics_update(_delta: float) -> void:
	if character.move_component.get_is_moving():
		state_machine.change_state("Run")

## 退出状态触发一次
func exit() -> void:
	pass
