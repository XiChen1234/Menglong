extends State
class_name Run

## 方向动画名称字典
const DIRECTION_ANIM_MAP: Dictionary= {
	Character.Direction8.RIGHT: { name="run-horizontal", flip=true },
	Character.Direction8.RIGHT_DOWN: { name="run", flip=true },
	Character.Direction8.DOWN: { name="run-down", flip=false },
	Character.Direction8.LEFT_DOWN: { name="run", flip=false },
	Character.Direction8.LEFT: { name="run-horizontal", flip=false },
	Character.Direction8.LEFT_UP: { name="run-up-diagonal", flip=false },
	Character.Direction8.UP: { name="run-up", flip=false },
	Character.Direction8.RIGHT_UP: { name="run-up-diagonal", flip=true },
}

## 玩家想要Run的方向向量
var _current_dir: Vector2 = Vector2.ZERO


func enter() -> void:
	_update_direction()


func update(_delta: float) -> void:
	if character.control_component.get_attack_clicked():
		character.move_component.stop()
		state_machine.change_state("Attack")
		return
	
	if not character.control_component.get_is_moving():
		state_machine.change_state("Idle")
		return


func physics_update(_delta: float) -> void:
	_current_dir = character.control_component.get_move_dir()
	# 动画更新
	_update_direction()
	# 物理移动
	character.move_component.set_move_dir(_current_dir)


"""
更新玩家移动方向
"""
func _update_direction() -> void:
	var new_dir8: Character.Direction8 = vector_to_dir8(_current_dir)
	character.facing = new_dir8
	_play_direction_anim(new_dir8)


"""播放方向动画"""
func _play_direction_anim(dir8: Character.Direction8) -> void:
	var anim_info = DIRECTION_ANIM_MAP[dir8]
	character.anim_component.play_base(anim_info.name)
	character.anim_component.reverse(anim_info.flip)


## 向量转8方向
static func vector_to_dir8(dir: Vector2) -> Character.Direction8:
	var angle: float = atan2(dir.y, dir.x)    
	if angle < 0:
		angle += 2 * PI
		
	# 将角度映射到8方向索引
	var index: int = int(round(angle / (PI/4))) % 8
	return index as Character.Direction8
