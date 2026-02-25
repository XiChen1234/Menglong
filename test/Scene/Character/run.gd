extends State
class_name Run


## 八方向枚举
enum Direction8 {
	UP,
	UP_RIGHT,
	RIGHT,
	DOWN_RIGHT,
	DOWN,
	DOWN_LEFT,
	LEFT,
	UP_LEFT
}


## 动画映射
const RUN_ANIM_MAP := {
	Direction8.DOWN: "run-down",
	Direction8.DOWN_LEFT: "run",
	Direction8.LEFT: "run-horizontal",
	Direction8.UP_LEFT: "run-up-diagonal",
	Direction8.UP: "run-up",
	Direction8.UP_RIGHT: "run-up-diagonal",
	Direction8.RIGHT: "run-horizontal",
	Direction8.DOWN_RIGHT: "run"
}

@onready var sprite_3d: Sprite3D = $"../../Sprite3D"

var last_dir: Direction8 = Direction8.DOWN


func enter() -> void:
	update_direction(true) # 进入奔跑状态强制打断动画


func physics_update(_delta: float) -> void:
	if not character.move_component.get_is_moving():
		state_machine.change_state("Idle")
		return
	
	update_direction(false)


## 更新方向，参数代表是否需要强制刷新
func update_direction(force: bool) -> void:
	
	pass
