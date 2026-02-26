extends CharacterBody3D
class_name Character

@onready var state_machine: StateMachine = $StateMachine
@onready var control_component: ControlComponent = $ControlComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var anim_component: AnimComponent = $AnimComponent


func _process(delta: float) -> void:
	control_component.control()
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	move_component.move(delta)
