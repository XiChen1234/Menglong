extends Node
class_name AnimComponent


@onready var sprite_3d: Sprite3D = $"../Sprite3D"
@onready var spine_node_2d: SpineNode2D = $"../SubViewport/SpineNode2D"


## 播放spine基础动画
func play_base(anim_name: String) -> void:
	spine_node_2d.play_animation(anim_name)


## 反转
## - target: 反转的目标状态
func reverse(target: bool) -> void:
	sprite_3d.flip_h = target
