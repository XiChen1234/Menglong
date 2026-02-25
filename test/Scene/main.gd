extends Node3D

@onready var player: Character = $Player
@onready var camera_3d: Camera3D = $Camera3D

var offset: Vector3 = Vector3(0, 2, 5)

func _process(_delta: float) -> void:
	camera_3d.position = player.position + offset
