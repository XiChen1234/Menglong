extends Node
class_name StateMachine

signal state_change(old_state: State, new_state: State)

@export var init_state: NodePath

var character: Character
var current_state: State
var state_map: Dictionary = {}

var _is_changing: bool = false

func _ready() -> void:
	character = get_parent()
	# 注册状态
	for child in get_children():
		if child is State:
			state_map[child.name] = child
			child.character = self.character
			child.state_machine = self
	
	# 进入初始状态
	if not init_state:
		push_error("StateMachine: 未设置初始状态")
		return
	
	var node = get_node_or_null(init_state)
	if not node:
		push_error("StateMachine: 初始状态未找到，%s" % init_state)


func start() -> void: 
	if not init_state:
		push_error("StateMachine: 未设置初始状态")
		return
	
	var node = get_node_or_null(init_state)
	if not node:
		push_error("StateMachine: 初始状态未找到，%s" % init_state)
		return
	
	current_state = node
	current_state.enter()


## 状态切换
func change_state(state_name: String) -> void:
	if _is_changing:
		return
	
	if not state_map.has(state_name):
		push_error("StateMachine: 状态 %s 未找到" % state_name)
		return
	
	if current_state and state_name == current_state.name:
		return
	
	_is_changing = true
	var old_state: State = current_state
	if current_state:
		current_state.exit()
	current_state = state_map[state_name]
	current_state.enter()
	emit_signal("state_change", old_state, current_state)
	_is_changing = false


func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
