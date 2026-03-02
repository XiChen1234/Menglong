extends State
class_name ComboAttack

# 连击动画序列
const COMBO_ANIMATIONS = ["attack-combo1", "attack-combo2", "attack-combo3"]
# 连击输入判定窗口时间（秒）
const COMBO_INPUT_WINDOW = 0.3
# 输入缓冲时间（秒）
const INPUT_BUFFER_TIME = 0.2

var _combo_count: int = 0
var _anim_finished: bool = false
var _input_buffer_timer: float = 0.0
var _combo_window_timer: float = 0.0
var _has_input_buffer: bool = false

func enter() -> void:
	# 重置连击状态
	_combo_count = 0
	_anim_finished = false
	_input_buffer_timer = 0.0
	_combo_window_timer = 0.0
	_has_input_buffer = false
	
	# 播放第一个连击动画
	_play_combo_animation()
	
	# 连接动画结束信号
	character.anim_component.connect("animation_finished", _on_animation_finished)

func exit() -> void:
	# 清除攻击输入
	character.control_component.clear_attack_clicked()
	
	# 断开动画结束信号
	if character.anim_component.is_connected("animation_finished", _on_animation_finished):
		character.anim_component.disconnect("animation_finished", _on_animation_finished)

func update(delta: float) -> void:
	# 检查输入缓冲
	if _has_input_buffer:
		_input_buffer_timer -= delta
		if _input_buffer_timer <= 0:
			_has_input_buffer = false
	
	# 检查连击窗口
	if _anim_finished:
		_combo_window_timer -= delta
		if _combo_window_timer <= 0:
			# 连击窗口结束，回到 idle 状态
			state_machine.change_state("Idle")
			return
	
	# 检查移动输入（中断连击）
	if character.control_component.get_is_moving():
		state_machine.change_state("Run")
		return
	
	# 检查攻击输入
	if character.control_component.get_attack_clicked():
		_handle_attack_input()

func _handle_attack_input() -> void:
	# 清除攻击输入
	character.control_component.clear_attack_clicked()
	
	if _anim_finished:
		# 当前动画已结束，在连击窗口内
		_next_combo()
	else:
		# 当前动画未结束，设置输入缓冲
		_has_input_buffer = true
		_input_buffer_timer = INPUT_BUFFER_TIME

func _on_animation_finished(anim_name: String) -> void:
	_anim_finished = true
	
	# 启动连击窗口计时器
	_combo_window_timer = COMBO_INPUT_WINDOW
	
	# 检查是否有输入缓冲
	if _has_input_buffer:
		_next_combo()
		_has_input_buffer = false

func _play_combo_animation() -> void:
	# 播放当前连击动画
	var anim_name = COMBO_ANIMATIONS[_combo_count]
	character.anim_component.play_trigger(anim_name)
	_anim_finished = false
	
	# 更新连击计数显示
	if character.has_node("ComboDisplay"):
		var combo_display = character.get_node("ComboDisplay")
		combo_display.update_combo(_combo_count + 1)

func _next_combo() -> void:
	# 增加连击计数
	_combo_count += 1
	
	# 检查是否到达连击上限
	if _combo_count >= COMBO_ANIMATIONS.size():
		# 连击结束，回到 idle 状态
		state_machine.change_state("Idle")
		return
	
	# 播放下一个连击动画
	_play_combo_animation()

func get_combo_count() -> int:
	return _combo_count + 1  # 返回当前连击次数（从1开始）
