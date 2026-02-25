extends Node
class_name AnimationComponent

@onready var spine_node_2d: SpineNode2D = $"../SubViewport/SpineNode2D"

## 播放spine基础动画
func play_base(anim_name: String) -> void:
	spine_node_2d.play_animation(anim_name)
