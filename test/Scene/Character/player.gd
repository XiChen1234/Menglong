extends Character
class_name Player

# ==============================
# 枚举
# ==============================

enum State {
	NONE,
	IDLE,
	RUN,
	ATTACK,
}

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

# ==============================
# 常量
# ==============================

const MAX_COMBO: int = 3
const COMBO_WINDOW: float = 0.45
const INPUT_EPSILON: float = 0.0001

const RUN_DIR_ANIM_MAP := {
	Direction8.RIGHT: { name="run-horizontal", flip=true },
	Direction8.RIGHT_DOWN: { name="run", flip=true },
	Direction8.DOWN: { name="run-down", flip=false },
	Direction8.LEFT_DOWN: { name="run", flip=false },
	Direction8.LEFT: { name="run-horizontal", flip=false },
	Direction8.LEFT_UP: { name="run-up-diagonal", flip=false },
	Direction8.UP: { name="run-up", flip=false },
	Direction8.RIGHT_UP: { name="run-up-diagonal", flip=true },
}

const IDLE_DIR_ANIM_MAP := {
	Direction8.RIGHT: "idle",
	Direction8.RIGHT_DOWN: "idle",
	Direction8.DOWN: "idle",
	Direction8.LEFT_DOWN: "idle",
	Direction8.LEFT: "idle",
	Direction8.LEFT_UP: "idle-up",
	Direction8.UP: "idle-up",
	Direction8.RIGHT_UP: "idle-up",
}

# ==============================
# 导出
# ==============================

@export var init_state: State = State.IDLE
@export var move_speed: float = 5

# ==============================
# 状态变量
# ==============================

var active_state: State = State.NONE
var _input_vector: Vector2 = Vector2.ZERO
var _move_vector: Vector2 = Vector2.ZERO
var _current_dir: Direction8 = Direction8.DOWN

var _attack_facing: bool = false
var _combo_index: int = 0
var _combo_buffered: bool = false

# ==============================
# 节点引用
# ==============================

@onready var spine_node_2d: SpineNode2D = $SubViewport/SpineNode2D
@onready var combo_timer: Timer = $ComboTimer

# ==============================
# 生命周期
# ==============================

func _ready() -> void:
	switch_state(init_state)

func _physics_process(delta: float) -> void:
	_update_input()
	_update_state(delta)
	move_and_slide()

# ==============================
# 状态系统
# ==============================

func switch_state(state: State) -> void:
	if active_state == state:
		return
	
	exit_state(active_state)
	active_state = state
	enter_state(active_state)

func enter_state(state: State) -> void:
	match state:
		State.IDLE:
			_enter_idle()
		State.RUN:
			_enter_run()
		State.ATTACK:
			_enter_attack()

func exit_state(state: State) -> void:
	if state == State.ATTACK:
		combo_timer.stop()

func _update_state(_delta: float) -> void:
	match active_state:
		State.IDLE:
			_update_idle()
		State.RUN:
			_update_run()
		State.ATTACK:
			_update_attack()

# ==============================
# 输入
# ==============================

func _update_input() -> void:
	_input_vector = Input.get_vector("left", "right", "up", "down")
	_move_vector = _input_vector.normalized()

func _has_movement_input() -> bool:
	return _move_vector.length_squared() > INPUT_EPSILON

# ==============================
# IDLE
# ==============================

func _enter_idle() -> void:
	velocity.x = 0
	velocity.z = 0
	_update_idle_dir()

func _update_idle() -> void:
	if _try_attack():
		return
	
	if _has_movement_input():
		switch_state(State.RUN)

# ==============================
# RUN
# ==============================

func _enter_run() -> void:
	_update_run_dir()

func _update_run() -> void:
	if _try_attack():
		return
	
	if not _has_movement_input():
		switch_state(State.IDLE)
		return
	
	_update_run_dir()
	velocity.x = _move_vector.x * move_speed
	velocity.z = _move_vector.y * move_speed

# ==============================
# ATTACK
# ==============================

func _enter_attack() -> void:
	velocity.x = 0
	velocity.z = 0
	
	_combo_index = 1
	_combo_buffered = false
	
	_init_attack_facing()
	_play_combo_animation()
	combo_timer.start(COMBO_WINDOW)

func _update_attack() -> void:
	# 攻击期间允许输入缓冲，但不主动切状态
	if Input.is_action_just_pressed("attack") and _combo_index < MAX_COMBO:
		_combo_buffered = true

func _init_attack_facing() -> void:
	if _has_movement_input():
		_attack_facing = _move_vector.x >= 0
	else:
		_attack_facing = _current_dir in [
			Direction8.RIGHT,
			Direction8.RIGHT_DOWN,
			Direction8.RIGHT_UP
		]

# ==============================
# Combo
# ==============================

func _on_combo_timer_timeout() -> void:
	if active_state != State.ATTACK:
		return
	
	if _combo_buffered and _combo_index < MAX_COMBO:
		_combo_index += 1
		_combo_buffered = false
		
		# 连段时允许根据当前输入重新锁方向
		if _has_movement_input():
			_attack_facing = _move_vector.x >= 0
		
		_play_combo_animation()
		combo_timer.start(COMBO_WINDOW)
	else:
		_end_attack()

func _end_attack() -> void:
	_combo_index = 0
	_combo_buffered = false
	
	if _has_movement_input():
		switch_state(State.RUN)
	else:
		switch_state(State.IDLE)

# ==============================
# 动画
# ==============================

func _update_idle_dir() -> void:
	var anim_name: String = IDLE_DIR_ANIM_MAP[_current_dir]
	spine_node_2d.play_animation(anim_name)

func _update_run_dir() -> void:
	_current_dir = _vector_to_dir8(_move_vector)
	var data = RUN_DIR_ANIM_MAP[_current_dir]
	spine_node_2d.play_animation(data.name)
	spine_node_2d.reverse_animation(data.flip)

func _play_combo_animation() -> void:
	var anim_name = "attack-combo%d" % _combo_index
	spine_node_2d.play_animation(anim_name, false)
	spine_node_2d.reverse_animation(_attack_facing)

# ==============================
# 工具
# ==============================

func _vector_to_dir8(vector: Vector2) -> Direction8:
	var angle: float = atan2(vector.y, vector.x)
	if angle < 0:
		angle += 2 * PI
	
	var index: int = int(round(angle / (PI / 4))) % 8
	return index as Direction8

func _try_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		switch_state(State.ATTACK)
		return true
	return false
