@tool
extends Node2D
class_name SpineNode2D
"""
用于显示Spine的场景组件
"""

signal animation_finished(anim_name: String)

## 预设属性
@export var spine_res: SpineSkeletonDataResource
@export var preview_skin: String = "default"
@export var preview_anim: String = "idle"
@export_multiline var description: String = ""

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
	skeleton.set_skin_by_name(preview_skin)
	
	anim_state = spine_sprite.get_animation_state()
	
	var window_size: Vector2 = get_viewport().size
	spine_sprite.position = Vector2(window_size.x / 2, window_size.y - 300)


## 设置皮肤
func set_skin(skin_name: String) -> void:
	spine_sprite.get_skeleton().set_skin_by_name(skin_name)
	spine_sprite.get_skeleton().set_slots_to_setup_pose()


## 播放动画
func play_animation(anim_name: String, loop: bool = true, track: int = 0):
	if current_animation_name == anim_name and loop:
		return
	
	current_animation_name = anim_name
	anim_state.set_animation(anim_name, loop, track)


## 反转动画
## - targte: 反转后的目标状态
func reverse_animation(target: bool) -> void:
	if target:
		spine_sprite.scale.x = -1
	else:
		spine_sprite.scale.x = 1


## 触发动画播放结束
func _on_spine_sprite_animation_completed(
		_spine_sprite: SpineSprite, 
		_animation_state: SpineAnimationState, 
		track_entry: SpineTrackEntry
		) -> void:
	# 排除循环动画
	if track_entry.get_loop():
		return
	
	var anim_name: String = track_entry.get_animation().get_name()
	#print(anim_name)
	self.emit_signal("animation_finished", anim_name)
