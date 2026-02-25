extends CharacterBody3D
class_name Character

@onready var state_machine: StateMachine = $StateMachine
@onready var move_component: MoveComponent = $MoveComponent
@onready var anim_component: AnimComponent = $AnimComponent


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
