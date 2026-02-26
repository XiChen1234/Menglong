extends State
class_name Run

## 八方向枚举
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

## 方向动画名称字典
const DIRECTION_ANIM_MAP: Dictionary= {
	Direction8.RIGHT: { name="run-horizontal", flip=true },
	Direction8.RIGHT_DOWN: { name="run", flip=true },
	Direction8.DOWN: { name="run-down", flip=false },
	Direction8.LEFT_DOWN: { name="run", flip=false },
	Direction8.LEFT: { name="run-horizontal", flip=false },
	Direction8.LEFT_UP: { name="run-up-diagonal", flip=false },
	Direction8.UP: { name="run-up", flip=false },
	Direction8.RIGHT_UP: { name="run-up-diagonal", flip=true },
}

var _current_dir8: Direction8 = Direction8.DOWN


func enter() -> void:
	print("Enter Run")
	# 强制更新方向并播放动画，确保从Idle状态切换回来时能正确显示Run动画
	var move_dir: Vector2 = character.control_component.get_move_dir()
	var new_dir8: Direction8 = vector_to_dir8(move_dir)
	_current_dir8 = new_dir8
	_play_direction_anim(new_dir8)


func update(_delta: float) -> void:
	if not character.control_component.get_is_moving():
		state_machine.change_state("Idle")


func physics_update(_delta: float) -> void:
	var move_dir: Vector2 = character.control_component.get_move_dir()
	# 动画更新
	_update_direction(move_dir)
	# 物理移动
	character.move_component.move(move_dir, _delta)


func exit() -> void:
	print("Exit Run")


"""
更新玩家移动方向
"""
func _update_direction(move_dir: Vector2) -> void:
	
	var new_dir8: Direction8 = vector_to_dir8(move_dir)
	if new_dir8 == _current_dir8:
		return # 方向没变，不重复播放
	
	_current_dir8 = new_dir8
	
	_play_direction_anim(new_dir8)


"""播放方向动画"""
func _play_direction_anim(dir8: Direction8) -> void:
	var anim_info = DIRECTION_ANIM_MAP[dir8]
	character.anim_component.play_base(anim_info.name)
	character.anim_component.reverse(anim_info.flip)


## 向量转8方向
static func vector_to_dir8(dir: Vector2) -> Direction8:
	var angle: float = atan2(dir.y, dir.x)    
	if angle < 0:
		angle += 2 * PI
		
	# 将角度映射到8方向索引
	var index: int = int(round(angle / (PI/4))) % 8
	return index as Direction8
