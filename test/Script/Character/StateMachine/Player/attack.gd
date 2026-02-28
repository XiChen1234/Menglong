extends State
class_name Attack


func enter() -> void:
	print("Enter Attack")
	character.anim_component.play_trigger("attack_charge_wait")


func update(_delta: float) -> void:
	print("Update Attack")


func exit() -> void:
	print("Exit Attack")
