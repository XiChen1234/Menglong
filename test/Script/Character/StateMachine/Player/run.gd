extends State
class_name Run

enum Direction8 {
	RIGHT, 
	RIGHT_DOWN,
	DOWN,
	LEFT_DOWN,
	LEFT,
	LEFT_UP,
	UP,
	RIGHT_UP
}

const DIRECTION_NAME_MAP: Dictionary = {
	Direction8.RIGHT: ["run-horizontal", true],
	Direction8.RIGHT_DOWN: ["run", true],
	Direction8.DOWN: ["run-down", false],
	Direction8.LEFT_DOWN: ["run", false],
	Direction8.LEFT: ["run-horizontal", false],
	Direction8.LEFT_UP: ["run-up-diagonal", false],
	Direction8.UP: ["run-up", false],
	Direction8.RIGHT_UP: ["run-up-diagonal", true],
}


func enter() -> void:
	character.anim_component.play_base("run")
	_update_direction()


func update(_delta: float) -> void:
	if not character.move_component.get_is_moving():
		state_machine.change_state("Idle")
		return
	
	_update_direction()


"""
更新玩家移动方向
- focus: 是否强行打断动画
"""
func _update_direction() -> void:
	var move_dir: Vector2 = character.move_component.get_move_dir()
	if move_dir == Vector2.ZERO:
		return
	
	# 计算角度并映射到0~2PI
	var angle = atan2(move_dir.y, move_dir.x)    
	if angle < 0:
		angle += 2 * PI
		
	# 将角度映射到8方向索引
	var index = int(round(angle / (PI/4))) % 8

	var anim_info = DIRECTION_NAME_MAP[index]
	var anim_name: String = anim_info[0]
	var flip_h: bool = anim_info[1]
	
	character.anim_component.play_base(anim_name)
	character.anim_component.reverse(flip_h)
