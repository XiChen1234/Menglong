extends State
class_name Idle


func enter() -> void:
	character.move_component.stop()
	character.anim_component.play_base("idle")


func update(_delta: float) -> void:
	if character.control_component.get_is_moving():
		state_machine.change_state("Run")
