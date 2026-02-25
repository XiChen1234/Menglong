extends CharacterBody3D
class_name Character

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var move_component: MoveComponent = $MoveComponent


func _ready() -> void:
	state_machine.call_deferred("start")


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
