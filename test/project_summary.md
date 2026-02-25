# Project File Summary

## Directory Structure

```
Scene/
+-- Character
|   +-- StateMachine
|   |   +-- Player
|   |   |   +-- idle.gd
|   |   |   +-- idle.gd.uid
|   |   +-- state.gd
|   |   +-- state.gd.uid
|   |   +-- state_machine.gd
|   |   +-- state_machine.gd.uid
|   +-- animation_component.gd
|   +-- animation_component.gd.uid
|   +-- character.gd
|   +-- character.gd.uid
|   +-- character.tscn
|   +-- enemy.gd
|   +-- enemy.gd.uid
|   +-- enemy.tscn
|   +-- input_controller.gd
|   +-- input_controller.gd.uid
|   +-- move_component.gd
|   +-- move_component.gd.uid
|   +-- player.gd
|   +-- player.gd.uid
|   +-- player.tscn
|   +-- run.gd
|   +-- run.gd.uid
+-- Ground
|   +-- ground.tscn
+-- Spine
|   +-- spine_node_2d.gd
|   +-- spine_node_2d.gd.uid
|   +-- spine_node_2d.tscn
+-- main.gd
+-- main.gd.uid
+-- main.tscn
```

## File Contents

============Character/StateMachine/Player/idle.gd============
extends State
class_name Idle


## 进入状态触发一次
func enter() -> void:
	character.animation_component.play_base("idle")


## process触发
func update(_delta: float) -> void:
	pass


## physics process触发
func physics_update(_delta: float) -> void:
	if character.move_component.is_moving:
		state_machine.change_state("Run")

## 退出状态触发一次
func exit() -> void:
	pass

============Character/StateMachine/Player/idle.gd.uid============
uid://dt433iy71hdwr

============Character/StateMachine/state.gd============
extends Node
class_name State

var character: Character
var state_machine: StateMachine

## 进入状态触发一次
func enter() -> void:
	pass


## process触发
func update(_delta: float) -> void:
	pass


## physics process触发
func physics_update(_delta: float) -> void:
	pass


## 退出状态触发一次
func exit() -> void:
	pass

============Character/StateMachine/state.gd.uid============
uid://bcfqwxdv3bf63

============Character/StateMachine/state_machine.gd============
extends Node
class_name StateMachine

signal state_change(old_state: State, new_state: State)

@export var init_state: NodePath

var character: Character
var current_state: State
var state_map: Dictionary = {}

var _is_changing: bool = false

func _ready() -> void:
	character = get_parent()
	# 注册状态
	for child in get_children():
		if child is State:
			state_map[child.name] = child
			child.character = self.character
			child.state_machine = self
	
	# 进入初始状态
	if not init_state:
		push_error("StateMachine: 未设置初始状态")
		return
	
	var node = get_node_or_null(init_state)
	if not node:
		push_error("StateMachine: 初始状态未找到，%s" % init_state)


func start() -> void: 
	if not init_state:
		push_error("StateMachine: 未设置初始状态")
		return
	
	var node = get_node_or_null(init_state)
	if not node:
		push_error("StateMachine: 初始状态未找到，%s" % init_state)
		return
	
	current_state = node
	current_state.enter()


## 状态切换
func change_state(state_name: String) -> void:
	if _is_changing:
		return
	
	if not state_map.has(state_name):
		push_error("StateMachine: 状态 %s 未找到" % state_name)
		return
	
	if current_state and state_name == current_state.name:
		return
	
	_is_changing = true
	var old_state: State = current_state
	if current_state:
		current_state.exit()
	current_state = state_map[state_name]
	current_state.enter()
	emit_signal("state_change", old_state, current_state)
	_is_changing = false


func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

============Character/StateMachine/state_machine.gd.uid============
uid://cnq3s26k2fr64

============Character/animation_component.gd============
extends Node
class_name AnimationComponent

@onready var spine_node_2d: SpineNode2D = $"../SubViewport/SpineNode2D"

## 播放spine基础动画
func play_base(anim_name: String) -> void:
	spine_node_2d.play_animation(anim_name)

============Character/animation_component.gd.uid============
uid://bahyh5ng5aald

============Character/character.gd============
extends CharacterBody3D
class_name Character

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var move_component: MoveComponent = $MoveComponent


func _ready() -> void:
	state_machine.call_deferred("start")


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

============Character/character.gd.uid============
uid://n6qoynjefoao

============Character/character.tscn============
[gd_scene load_steps=8 format=3 uid="uid://xpti54aiyuuh"]

[ext_resource type="PackedScene" uid="uid://c6rt2pcvesc8j" path="res://Scene/Spine/spine_node_2d.tscn" id="1_2qbhs"]
[ext_resource type="Script" uid="uid://n6qoynjefoao" path="res://Scene/Character/character.gd" id="1_23n3f"]
[ext_resource type="Script" uid="uid://cnq3s26k2fr64" path="res://Scene/Character/StateMachine/state_machine.gd" id="3_23n3f"]
[ext_resource type="Script" uid="uid://bahyh5ng5aald" path="res://Scene/Character/animation_component.gd" id="4_hcypm"]
[ext_resource type="Script" uid="uid://bdl3k1gle3tx7" path="res://Scene/Character/move_component.gd" id="5_xss0k"]

[sub_resource type="CapsuleShape3D" id="CapsuleShape3D_ur5ca"]
radius = 0.001

[sub_resource type="ViewportTexture" id="ViewportTexture_xss0k"]
viewport_path = NodePath("SubViewport")

[node name="Character" type="CharacterBody3D"]
script = ExtResource("1_23n3f")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("CapsuleShape3D_ur5ca")

[node name="Sprite3D" type="Sprite3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.4442109, 0)
alpha_cut = 1
texture = SubResource("ViewportTexture_xss0k")

[node name="SubViewport" type="SubViewport" parent="."]
transparent_bg = true
size = Vector2i(1920, 1080)

[node name="SpineNode2D" parent="SubViewport" instance=ExtResource("1_2qbhs")]

[node name="StateMachine" type="Node" parent="."]
script = ExtResource("3_23n3f")

[node name="AnimationComponent" type="Node" parent="."]
script = ExtResource("4_hcypm")

[node name="MoveComponent" type="Node" parent="."]
script = ExtResource("5_xss0k")

============Character/enemy.gd============
extends Character
class_name Enemy


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

============Character/enemy.gd.uid============
uid://cqww1h7nxcixe

============Character/enemy.tscn============
[gd_scene load_steps=6 format=3 uid="uid://dn8xtk7rlgrlp"]

[ext_resource type="PackedScene" uid="uid://xpti54aiyuuh" path="res://Scene/Character/character.tscn" id="1_skcs8"]
[ext_resource type="Script" uid="uid://cqww1h7nxcixe" path="res://Scene/Character/enemy.gd" id="2_ioyso"]
[ext_resource type="Script" uid="uid://bcfqwxdv3bf63" path="res://Scene/Character/StateMachine/state.gd" id="3_fdced"]
[ext_resource type="SpineSkeletonDataResource" uid="uid://m1w8oieiw6os" path="res://Resource/Spine/enemy.tres" id="4_j5gbm"]

[sub_resource type="ViewportTexture" id="ViewportTexture_fdced"]
viewport_path = NodePath("SubViewport")

[node name="Enemy" instance=ExtResource("1_skcs8")]
script = ExtResource("2_ioyso")

[node name="Sprite3D" parent="." index="1"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 7.042, 0)
texture = SubResource("ViewportTexture_fdced")

[node name="SubViewport" parent="." index="2"]
size = Vector2i(1920, 2160)

[node name="SpineNode2D" parent="SubViewport" index="0"]
spine_res = ExtResource("4_j5gbm")

[node name="StateMachine" parent="." index="3"]
init_state = NodePath("State")

[node name="State" type="Node" parent="StateMachine" index="0"]
script = ExtResource("3_fdced")
metadata/_custom_type_script = "uid://bcfqwxdv3bf63"

============Character/input_controller.gd============
extends Node
class_name InputController

@onready var move_component: MoveComponent = $"../MoveComponent"

func _process(_delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	move_component.set_move_dir(input_dir) 

============Character/input_controller.gd.uid============
uid://ckbpg2erxphsp

============Character/move_component.gd============
extends Node
class_name MoveComponent

@export var move_speed: float = 5

@onready var character: Character = $".."

var move_dir: Vector3 = Vector3.ZERO
var is_moving: bool = false


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_movement()
	character.move_and_slide()
	is_moving = move_dir.length() > 0.01


func apply_gravity(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta


func apply_movement() -> void:
	character.velocity.x = move_dir.x * move_speed
	character.velocity.z = move_dir.z * move_speed


## 提供设置输入方向的接口
func set_move_dir(dir: Vector2) -> void:
	move_dir = Vector3(dir.x, 0, dir.y)

============Character/move_component.gd.uid============
uid://bdl3k1gle3tx7

============Character/player.gd============
extends Character
class_name Player

============Character/player.gd.uid============
uid://d4gafasus4jj5

============Character/player.tscn============
[gd_scene load_steps=8 format=3 uid="uid://fda5bb2orhpk"]

[ext_resource type="PackedScene" uid="uid://xpti54aiyuuh" path="res://Scene/Character/character.tscn" id="1_5trst"]
[ext_resource type="SpineSkeletonDataResource" uid="uid://dqe3juv1jqdov" path="res://Resource/Spine/player-main.tres" id="2_087al"]
[ext_resource type="Script" uid="uid://d4gafasus4jj5" path="res://Scene/Character/player.gd" id="2_vmgdj"]
[ext_resource type="Script" uid="uid://bqr6wqeirfd01" path="res://Scene/Character/run.gd" id="4_0ov3f"]
[ext_resource type="Script" uid="uid://ckbpg2erxphsp" path="res://Scene/Character/input_controller.gd" id="4_g5did"]
[ext_resource type="Script" uid="uid://dt433iy71hdwr" path="res://Scene/Character/StateMachine/Player/idle.gd" id="4_mckv8"]

[sub_resource type="ViewportTexture" id="ViewportTexture_mckv8"]
viewport_path = NodePath("SubViewport")

[node name="Player" instance=ExtResource("1_5trst")]
script = ExtResource("2_vmgdj")

[node name="Sprite3D" parent="." index="1"]
texture = SubResource("ViewportTexture_mckv8")

[node name="SpineNode2D" parent="SubViewport" index="0"]
spine_res = ExtResource("2_087al")
preview_skin = "Goat"

[node name="StateMachine" parent="." index="3"]
init_state = NodePath("Idle")

[node name="Idle" type="Node" parent="StateMachine" index="0"]
script = ExtResource("4_mckv8")
metadata/_custom_type_script = "uid://bcfqwxdv3bf63"

[node name="Run" type="Node" parent="StateMachine" index="1"]
script = ExtResource("4_0ov3f")
metadata/_custom_type_script = "uid://bcfqwxdv3bf63"

[node name="InputController" type="Node" parent="." index="6"]
script = ExtResource("4_g5did")

============Character/run.gd============
extends State
class_name Run


## 进入状态触发一次
func enter() -> void:
	character.animation_component.play_base("run")


## process触发
func update(_delta: float) -> void:
	pass


## physics process触发
func physics_update(_delta: float) -> void:
	if not character.move_component.is_moving:
		state_machine.change_state("Idle")


## 退出状态触发一次
func exit() -> void:
	pass

============Character/run.gd.uid============
uid://bqr6wqeirfd01

============Ground/ground.tscn============
[gd_scene load_steps=11 format=3 uid="uid://df7hgwc5msryc"]

[ext_resource type="Texture2D" uid="uid://dr3dxte8q32ra" path="res://Asserts/Ground/BuildingGrassFill.png" id="1_4ca6b"]
[ext_resource type="Texture2D" uid="uid://bcymkk7i8a7xi" path="res://Asserts/Ground/BuildingGrassFill_Dark.png" id="2_n7ph5"]
[ext_resource type="Texture2D" uid="uid://dvkd7ukkmthn7" path="res://Asserts/Ground/CaveGrassTexture.png" id="3_tmo08"]

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_n7ph5"]
albedo_texture = ExtResource("1_4ca6b")

[sub_resource type="PlaneMesh" id="PlaneMesh_3sh07"]
material = SubResource("StandardMaterial3D_n7ph5")
size = Vector2(1, 1)

[sub_resource type="BoxShape3D" id="BoxShape3D_4ca6b"]
size = Vector3(1, 0.1, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_tmo08"]
albedo_texture = ExtResource("2_n7ph5")

[sub_resource type="PlaneMesh" id="PlaneMesh_h1r0y"]
material = SubResource("StandardMaterial3D_tmo08")
size = Vector2(1, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_wljyq"]
albedo_texture = ExtResource("3_tmo08")

[sub_resource type="PlaneMesh" id="PlaneMesh_2ijaa"]
material = SubResource("StandardMaterial3D_wljyq")
size = Vector2(1, 1)

[node name="Ground" type="Node3D"]

[node name="MeshInstance3D" type="MeshInstance3D" parent="."]
mesh = SubResource("PlaneMesh_3sh07")

[node name="StaticBody3D" type="StaticBody3D" parent="MeshInstance3D"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="MeshInstance3D/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.05, 0)
shape = SubResource("BoxShape3D_4ca6b")

[node name="MeshInstance3D2" type="MeshInstance3D" parent="."]
mesh = SubResource("PlaneMesh_h1r0y")

[node name="StaticBody3D" type="StaticBody3D" parent="MeshInstance3D2"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="MeshInstance3D2/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.05, 0)
shape = SubResource("BoxShape3D_4ca6b")

[node name="MeshInstance3D3" type="MeshInstance3D" parent="."]
mesh = SubResource("PlaneMesh_2ijaa")

[node name="StaticBody3D" type="StaticBody3D" parent="MeshInstance3D3"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="MeshInstance3D3/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.05, 0)
shape = SubResource("BoxShape3D_4ca6b")

============Spine/spine_node_2d.gd============
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
	

============Spine/spine_node_2d.gd.uid============
uid://cg2lkjh32m0b0

============Spine/spine_node_2d.tscn============
[gd_scene load_steps=3 format=3 uid="uid://c6rt2pcvesc8j"]

[ext_resource type="Script" uid="uid://cg2lkjh32m0b0" path="res://Scene/Spine/spine_node_2d.gd" id="1_nlyop"]
[ext_resource type="SpineSkeletonDataResource" uid="uid://dqe3juv1jqdov" path="res://Resource/Spine/player-main.tres" id="2_ama7o"]

[node name="SpineNode2D" type="Node2D"]
script = ExtResource("1_nlyop")

[node name="SpineSprite" type="SpineSprite" parent="."]
skeleton_data_res = ExtResource("2_ama7o")
preview_skin = "Goat"
preview_animation = "run"
preview_frame = false
preview_time = 0.0

============main.gd============
extends Node3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var player: Player = $Player

var offset: Vector3 = Vector3(0, 2, 5)

func _process(_delta: float) -> void:
	camera_3d.position = player.position + offset

============main.gd.uid============
uid://c0av88dqxa17p

============main.tscn============
[gd_scene load_steps=8 format=3 uid="uid://cunyjxaand5rp"]

[ext_resource type="Script" uid="uid://c0av88dqxa17p" path="res://Scene/main.gd" id="1_2wwxx"]
[ext_resource type="MeshLibrary" uid="uid://c53m7083rrxag" path="res://Resource/ground_meshlib.tres" id="1_f6udf"]
[ext_resource type="PackedScene" uid="uid://fda5bb2orhpk" path="res://Scene/Character/player.tscn" id="2_r34rm"]
[ext_resource type="PackedScene" uid="uid://dn8xtk7rlgrlp" path="res://Scene/Character/enemy.tscn" id="3_2wwxx"]

[sub_resource type="ProceduralSkyMaterial" id="ProceduralSkyMaterial_f6udf"]
sky_horizon_color = Color(0.66224277, 0.6717428, 0.6867428, 1)
ground_horizon_color = Color(0.66224277, 0.6717428, 0.6867428, 1)

[sub_resource type="Sky" id="Sky_sblpm"]
sky_material = SubResource("ProceduralSkyMaterial_f6udf")

[sub_resource type="Environment" id="Environment_r34rm"]
background_mode = 2
sky = SubResource("Sky_sblpm")
tonemap_mode = 2

[node name="Main" type="Node3D"]
script = ExtResource("1_2wwxx")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("Environment_r34rm")

[node name="GroundMap" type="GridMap" parent="."]
mesh_library = ExtResource("1_f6udf")
cell_size = Vector3(1, 1, 1)
cell_center_y = false
data = {
"cells": PackedInt32Array(0, 0, 1, 0, 65535, 0, 65535, 65535, 1, 65535, 0, 2, 0, 65534, 0, 1, 65534, 0, 1, 65535, 0, 2, 65535, 0, 2, 65534, 0, 2, 65533, 0, 1, 65533, 0, 0, 65533, 0, 0, 65532, 0, 1, 65532, 0, 2, 65532, 0, 3, 65532, 0, 3, 65533, 0, 3, 65534, 0, 3, 65535, 0, 3, 0, 1, 0, 1, 1, 0, 2, 1, 0, 3, 1, 1, 0, 1, 1, 1, 1, 1, 2, 1, 1, 3, 1, 2, 0, 1, 2, 1, 1, 2, 2, 1, 2, 3, 1, 3, 1, 1, 3, 2, 1, 3, 3, 1, 65532, 65532, 1, 65532, 65533, 1, 65532, 65534, 1, 65532, 65535, 1, 65533, 65532, 1, 65533, 65533, 1, 65533, 65534, 1, 65533, 65535, 1, 65534, 65532, 1, 65534, 65533, 1, 65534, 65534, 1, 65534, 65535, 1, 65535, 65532, 1, 65535, 65533, 1, 65535, 65534, 1, 65532, 0, 2, 65532, 1, 2, 65532, 2, 2, 65532, 3, 2, 65533, 0, 2, 65533, 1, 2, 65533, 2, 2, 65533, 3, 2, 65534, 0, 2, 65534, 1, 2, 65534, 2, 2, 65534, 3, 2, 65535, 1, 2, 65535, 2, 2, 65535, 3, 2, 0, 65528, 1, 0, 65529, 1, 0, 65530, 1, 0, 65531, 1, 1, 65528, 1, 1, 65529, 1, 1, 65530, 1, 1, 65531, 1, 2, 65528, 1, 2, 65529, 1, 2, 65530, 1, 2, 65531, 1, 3, 65528, 1, 3, 65529, 1, 3, 65530, 1, 3, 65531, 1, 4, 65528, 1, 4, 65529, 1, 4, 65530, 1, 4, 65531, 1, 5, 65528, 1, 5, 65529, 1, 5, 65530, 1, 5, 65531, 1, 6, 65528, 1, 6, 65529, 1, 6, 65530, 1, 6, 65531, 1, 7, 65528, 1, 7, 65529, 1, 7, 65530, 1, 7, 65531, 1, 4, 65532, 1, 4, 65533, 1, 4, 65534, 1, 4, 65535, 1, 5, 65532, 1, 5, 65533, 1, 5, 65534, 1, 5, 65535, 1, 6, 65532, 1, 6, 65533, 1, 6, 65534, 1, 6, 65535, 1, 7, 65532, 1, 7, 65533, 1, 7, 65534, 1, 7, 65535, 1, 65528, 0, 1, 65528, 1, 1, 65528, 2, 1, 65528, 3, 1, 65528, 4, 1, 65528, 5, 1, 65528, 6, 1, 65528, 7, 1, 65529, 0, 1, 65529, 1, 1, 65529, 2, 1, 65529, 3, 1, 65529, 4, 1, 65529, 5, 1, 65529, 6, 1, 65529, 7, 1, 65530, 0, 1, 65530, 1, 1, 65530, 2, 1, 65530, 3, 1, 65530, 4, 1, 65530, 5, 1, 65530, 6, 1, 65530, 7, 1, 65531, 0, 1, 65531, 1, 1, 65531, 2, 1, 65531, 3, 1, 65531, 4, 1, 65531, 5, 1, 65531, 6, 1, 65531, 7, 1, 65532, 4, 1, 65532, 5, 1, 65532, 6, 1, 65532, 7, 1, 65533, 4, 1, 65533, 5, 1, 65533, 6, 1, 65533, 7, 1, 65534, 4, 1, 65534, 5, 1, 65534, 6, 1, 65534, 7, 1, 65535, 4, 1, 65535, 5, 1, 65535, 6, 1, 65535, 7, 1, 0, 4, 0, 0, 5, 0, 0, 6, 0, 0, 7, 0, 1, 4, 0, 1, 5, 0, 1, 6, 0, 1, 7, 0, 2, 4, 0, 2, 5, 0, 2, 6, 0, 2, 7, 0, 3, 4, 0, 3, 5, 0, 3, 6, 0, 3, 7, 0, 4, 4, 0, 4, 5, 0, 4, 6, 0, 4, 7, 0, 5, 4, 0, 5, 5, 0, 5, 6, 0, 5, 7, 0, 6, 4, 0, 6, 5, 0, 6, 6, 0, 6, 7, 0, 7, 4, 0, 7, 5, 0, 7, 6, 0, 7, 7, 0, 4, 0, 0, 4, 1, 0, 4, 2, 0, 4, 3, 0, 5, 0, 0, 5, 1, 0, 5, 2, 0, 5, 3, 0, 6, 0, 0, 6, 1, 0, 6, 2, 0, 6, 3, 0, 7, 0, 0, 7, 1, 0, 7, 2, 0, 7, 3, 0, 65528, 65528, 2, 65528, 65529, 2, 65528, 65530, 2, 65528, 65531, 2, 65528, 65532, 2, 65528, 65533, 2, 65528, 65534, 2, 65528, 65535, 2, 65529, 65528, 2, 65529, 65529, 2, 65529, 65530, 2, 65529, 65531, 2, 65529, 65532, 2, 65529, 65533, 2, 65529, 65534, 2, 65529, 65535, 2, 65530, 65528, 2, 65530, 65529, 2, 65530, 65530, 2, 65530, 65531, 2, 65530, 65532, 2, 65530, 65533, 2, 65530, 65534, 2, 65530, 65535, 2, 65531, 65528, 2, 65531, 65529, 2, 65531, 65530, 2, 65531, 65531, 2, 65531, 65532, 2, 65531, 65533, 2, 65531, 65534, 2, 65531, 65535, 2, 65532, 65528, 2, 65532, 65529, 2, 65532, 65530, 2, 65532, 65531, 2, 65533, 65528, 2, 65533, 65529, 2, 65533, 65530, 2, 65533, 65531, 2, 65534, 65528, 2, 65534, 65529, 2, 65534, 65530, 2, 65534, 65531, 2, 65535, 65528, 2, 65535, 65529, 2, 65535, 65530, 2, 65535, 65531, 2)
}

[node name="Camera3D" type="Camera3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 5)

[node name="Enemy" parent="." instance=ExtResource("3_2wwxx")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 5.9952307, 7.5089626, 0)

[node name="Player" parent="." instance=ExtResource("2_r34rm")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.1314783, 0)
