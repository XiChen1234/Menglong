@tool
extends Node2D
class_name SpineNode2D

## 相关预设属性
@export var spine_res: SpineSkeletonDataResource
## 预览相关设置
@export var preview_skin: String = "default"
@export var preview_anim: String = "idle"

@onready var spine_sprite: SpineSprite = $SpineSprite

var skeleton: SpineSkeleton
var animation_state: SpineAnimationState

func _ready() -> void:
	# 绑定相关属性
	spine_sprite.skeleton_data_res = spine_res
	print(spine_res.get_animations())
	spine_sprite.preview_skin = preview_skin
	spine_sprite.preview_animation = preview_anim
	# 应用动画与皮肤
	skeleton = spine_sprite.get_skeleton()
	animation_state = spine_sprite.get_animation_state()
	skeleton.set_skin_by_name(preview_skin)
	animation_state.set_animation(preview_anim)
	# 设置spine在窗口中的位置
	var window_size: Vector2 = get_viewport().size
	spine_sprite.position = Vector2(window_size.x / 2, window_size.y - 300)


func set_skin(skin_name: String) -> void:
	skeleton.set_skin_by_name(skin_name)


func set_anim(anim_name: String) -> void:
	animation_state.set_animation(anim_name)
