extends State
class_name Attack

var _anim_finished: bool = false


func enter() -> void:
	_anim_finished = false
	character.anim_component.play_trigger("attack-combo1")
	character.anim_component.connect("animation_finished", _on_animation_finished)


func exit() -> void:
	character.control_component.clear_attack_clicked()
	if character.anim_component.is_connected("animation_finished", _on_animation_finished):
		character.anim_component.disconnect("animation_finished", _on_animation_finished)


func _on_animation_finished(anim_name: String) -> void:
	_anim_finished = true
	if anim_name == "attack-combo1":
		state_machine.change_state("Idle")
