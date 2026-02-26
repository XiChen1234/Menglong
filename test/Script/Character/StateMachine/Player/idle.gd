extends State
class_name Idle

## 方向动画名称字典
const DIRECTION_ANIM_MAP: Dictionary= {
	Character.Direction8.RIGHT: "idle",
	Character.Direction8.RIGHT_DOWN: "idle",
	Character.Direction8.DOWN: "idle",
	Character.Direction8.LEFT_DOWN: "idle",
	Character.Direction8.LEFT: "idle",
	Character.Direction8.LEFT_UP: "idle-up",
	Character.Direction8.UP: "idle-up",
	Character.Direction8.RIGHT_UP: "idle-up",
}


func enter() -> void:
	character.move_component.stop()
	var anim_name: String = DIRECTION_ANIM_MAP[character.facing]
	character.anim_component.play_base(anim_name)


func update(_delta: float) -> void:
	if character.control_component.get_is_moving():
		state_machine.change_state("Run")
