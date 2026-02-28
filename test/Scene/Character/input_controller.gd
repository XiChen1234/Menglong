extends ControlComponent
class_name InputController


func control() -> void:
	# 移动输入
	var move_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	set_move_input(move_dir)
	
	# 攻击输入
	if Input.is_action_just_pressed("attack"):
		set_attack_clicked(true)
