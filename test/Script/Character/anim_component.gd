extends Node
class_name AnimComponent

signal animation_finished(anim_name: String)

@onready var spine_node_2d: SpineNode2D = $"../SubViewport/SpineNode2D"


func _ready() -> void:
	spine_node_2d.connect("animation_finished", _on_animtion_finished)


## 动画播放完成时回调
func _on_animtion_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)


## 播放spine基础动画
func play_base(anim_name: String) -> void:
	spine_node_2d.play_animation(anim_name)


## 播放spine触发动画
func play_trigger(anim_name: String) -> void:
	spine_node_2d.play_animation(anim_name, false)


## 左右反转
## - target: 反转的目标状态
func reverse(target: bool) -> void:
	spine_node_2d.reverse_animation(target)
