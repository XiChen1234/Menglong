@tool
extends Node2D
class_name SpineNode2D

## 信号
signal animation_started(anim_name: String)
signal animation_finished(anim_name: String)

## 相关预设属性
@export var spine_res: SpineSkeletonDataResource
## 预览相关设置（与实际资源无关，只是为了方便预览）
@export var preview_skin: String = "default"
@export var preview_anim: String = "idle"

@onready var spine_sprite: SpineSprite = $SpineSprite

var skeleton: SpineSkeleton
var animation_state: SpineAnimationState
var current_animation_name: String = ""

func _ready() -> void:
	if not spine_res:
		return
	
	# 绑定相关属性
	spine_sprite.skeleton_data_res = spine_res
	# 预览相关属性
	spine_sprite.preview_skin = preview_skin
	spine_sprite.preview_animation = preview_anim
	# 应用动画与皮肤
	skeleton = spine_sprite.get_skeleton()
	animation_state = spine_sprite.get_animation_state()
	set_skin(preview_skin)
	animation_state.set_animation(preview_anim)
	# 设置spine在窗口中的位置
	var window_size: Vector2 = get_viewport().size
	spine_sprite.position = Vector2(window_size.x / 2, window_size.y - 300)


func set_skin(skin_name: String) -> void:
	if not skeleton:
		return
	
	skeleton.set_skin_by_name(skin_name)
	skeleton.set_slots_to_setup_pose()

func play_animation(anim_name: String, loop: bool = true, track: int = 0):
	if not animation_state:
		return
	
	if current_animation_name == anim_name:
		return
	
	current_animation_name = anim_name
	animation_state.set_animation(anim_name, loop, track)
	
