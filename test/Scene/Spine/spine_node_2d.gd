@tool
extends Node2D
class_name SpineNode2D
"""
用于显示Spine的场景组件
"""


## 预设属性
@export var spine_res: SpineSkeletonDataResource
@export var preview_skin: String = "default"
@export var preview_anim: String = "idle"

@onready var spine_sprite: SpineSprite = $SpineSprite
@onready var label: Label = $Label

var skeleton: SpineSkeleton
var anim_state: SpineAnimationState
var current_animation_name: String = ""


func _ready() -> void:
	if not spine_res:
		label.text = "SpineNode2D: spine_res 未设置"
		push_warning("SpineNode2D: spine_res 未设置")
		return
	
	spine_sprite.skeleton_data_res = spine_res
	
	# 便于预览的设置
	if Engine.is_editor_hint():
		label.text = str(spine_res)
		spine_sprite.preview_skin = preview_skin
		spine_sprite.preview_animation = preview_anim
	
	skeleton = spine_sprite.get_skeleton()
	anim_state = spine_sprite.get_animation_state()
	skeleton.set_skin_by_name(preview_skin)
	anim_state.set_animation(preview_anim)
	var window_size: Vector2 = get_viewport().size
	spine_sprite.position = Vector2(window_size.x / 2, window_size.y - 300)


## 设置皮肤
func set_skin(skin_name: String) -> void:
	spine_sprite.get_skeleton().set_skin_by_name(skin_name)
	spine_sprite.get_skeleton().set_slots_to_setup_pose()


## 播放动画
func play_animation(anim_name: String, loop: bool = true, track: int = 0):
	if current_animation_name == anim_name:
		return
	
	current_animation_name = anim_name
	anim_state.set_animation(anim_name, loop, track)
