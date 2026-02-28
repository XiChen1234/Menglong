extends CharacterBody3D
class_name Character

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

var facing: Direction8 = Direction8.DOWN

@onready var state_machine: StateMachine = $StateMachine
@onready var control_component: ControlComponent = $ControlComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var anim_component: AnimComponent = $AnimComponent


func _process(delta: float) -> void:
	control_component.control()
	state_machine.update(delta)
	# 清除攻击意图，避免一直攻击
	control_component.clear_attack_clicked()


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	move_component.move(delta)
