extends State
class_name Attack

const COMBO_ANIMATIONS: Array[String] = [
	"attack-combo1",
	"attack-combo2",
	"attack-combo3",
]

## 连击输入窗口
@export var combo_input_window: float = 0.3
## 连击缓冲时长
@export var INPUT_BUFFER_TIME: float = 0.2

var _anim_finished: bool = false


func enter() -> void:
	_anim_finished = false
	character.anim_component.play_trigger("attack-combo1")
	character.anim_component.connect("animation_finished", _on_animation_finished)


func update(_delta: float) -> void:
	pass


func exit() -> void:
	character.control_component.clear_attack_clicked()
	if character.anim_component.is_connected("animation_finished", _on_animation_finished):
		character.anim_component.disconnect("animation_finished", _on_animation_finished)


func _on_animation_finished(anim_name: String) -> void:
	_anim_finished = true
	if anim_name == "attack-combo1":
		state_machine.change_state("Idle")
