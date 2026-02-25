# Project File Summary

## Directory Structure

```
Scene/
+-- Character
|   +-- character.gd
|   +-- character.gd.uid
|   +-- character.tscn
|   +-- enemy.tscn
|   +-- player.gd
|   +-- player.gd.uid
|   +-- player.tscn
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

============Character/character.gd============
extends CharacterBody3D
class_name Character

@onready var state_machine: StateMachine = $StateMachine
@onready var move_component: MoveComponent = $MoveComponent
@onready var anim_component: AnimComponent = $AnimComponent


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	state_machine.update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

============Character/character.gd.uid============
uid://bcn08xi7wriis

============Character/character.tscn============
[gd_scene load_steps=8 format=3 uid="uid://dtbhawbfjoqjq"]

[ext_resource type="PackedScene" uid="uid://co7cninpw3g85" path="res://Scene/Spine/spine_node_2d.tscn" id="1_2qbhs"]
[ext_resource type="Script" uid="uid://bcn08xi7wriis" path="res://Scene/Character/character.gd" id="1_hcypm"]
[ext_resource type="Script" uid="uid://bgylhuiymwybl" path="res://Script/Character/move_component.gd" id="2_aijn6"]
[ext_resource type="Script" uid="uid://5kb7ij7cis4c" path="res://Script/Character/anim_component.gd" id="3_23n3f"]
[ext_resource type="Script" uid="uid://m01jme0vunim" path="res://Script/Character/StateMachine/state_machine.gd" id="4_hcypm"]

[sub_resource type="CylinderShape3D" id="CylinderShape3D_ur5ca"]
radius = 0.001

[sub_resource type="ViewportTexture" id="ViewportTexture_2qbhs"]
viewport_path = NodePath("SubViewport")

[node name="Character" type="CharacterBody3D"]
script = ExtResource("1_hcypm")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("CylinderShape3D_ur5ca")

[node name="Sprite3D" type="Sprite3D" parent="."]
alpha_cut = 1
texture = SubResource("ViewportTexture_2qbhs")

[node name="SubViewport" type="SubViewport" parent="."]
transparent_bg = true
size = Vector2i(1920, 1080)

[node name="SpineNode2D" parent="SubViewport" instance=ExtResource("1_2qbhs")]

[node name="StateMachine" type="Node" parent="."]
script = ExtResource("4_hcypm")

[node name="MoveComponent" type="Node" parent="."]
script = ExtResource("2_aijn6")

[node name="AnimComponent" type="Node" parent="."]
script = ExtResource("3_23n3f")

============Character/enemy.tscn============
[gd_scene load_steps=3 format=3 uid="uid://c5dus6ncn37r8"]

[ext_resource type="PackedScene" uid="uid://dtbhawbfjoqjq" path="res://Scene/Character/character.tscn" id="1_skcs8"]

[sub_resource type="ViewportTexture" id="ViewportTexture_ioyso"]
viewport_path = NodePath("SubViewport")

[node name="Enemy" instance=ExtResource("1_skcs8")]

[node name="Sprite3D" parent="." index="1"]
texture = SubResource("ViewportTexture_ioyso")

============Character/player.gd============
extends Character
class_name Player

@onready var input_controller: InputController = $InputController

============Character/player.gd.uid============
uid://bll1ubsthjhie

============Character/player.tscn============
[gd_scene load_steps=8 format=3 uid="uid://cnbp6cul124j0"]

[ext_resource type="PackedScene" uid="uid://dtbhawbfjoqjq" path="res://Scene/Character/character.tscn" id="1_5trst"]
[ext_resource type="Script" uid="uid://bll1ubsthjhie" path="res://Scene/Character/player.gd" id="2_0ov3f"]
[ext_resource type="SpineSkeletonDataResource" uid="uid://bjetm36xytvps" path="res://Resource/player-main.tres" id="2_087al"]
[ext_resource type="Script" uid="uid://1e01oufwne1g" path="res://Script/Character/StateMachine/Player/idle.gd" id="3_g5did"]
[ext_resource type="Script" uid="uid://bj8gp3252qjur" path="res://Script/Character/input_controller.gd" id="3_vmgdj"]
[ext_resource type="Script" uid="uid://dfsaakm37d54h" path="res://Script/Character/StateMachine/Player/run.gd" id="4_g5did"]

[sub_resource type="ViewportTexture" id="ViewportTexture_087al"]
viewport_path = NodePath("SubViewport")

[node name="Player" instance=ExtResource("1_5trst")]
script = ExtResource("2_0ov3f")

[node name="Sprite3D" parent="." index="1"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.445, 0)
texture = SubResource("ViewportTexture_087al")

[node name="SpineNode2D" parent="SubViewport" index="0"]
spine_res = ExtResource("2_087al")
preview_skin = "Goat"

[node name="StateMachine" parent="." index="3"]
init_state = NodePath("Idle")

[node name="Idle" type="Node" parent="StateMachine" index="0"]
script = ExtResource("3_g5did")
metadata/_custom_type_script = "uid://fk0n85bvuoc"

[node name="Run" type="Node" parent="StateMachine" index="1"]
script = ExtResource("4_g5did")
metadata/_custom_type_script = "uid://fk0n85bvuoc"

[node name="InputController" type="Node" parent="." index="6"]
script = ExtResource("3_vmgdj")

============Ground/ground.tscn============
[gd_scene load_steps=11 format=3 uid="uid://djfk0f4eju0xj"]

[ext_resource type="Texture2D" uid="uid://dr3dxte8q32ra" path="res://Asserts/Ground/BuildingGrassFill.png" id="1_4ca6b"]
[ext_resource type="Texture2D" uid="uid://dvkd7ukkmthn7" path="res://Asserts/Ground/CaveGrassTexture.png" id="2_n7ph5"]
[ext_resource type="Texture2D" uid="uid://bcymkk7i8a7xi" path="res://Asserts/Ground/BuildingGrassFill_Dark.png" id="3_tmo08"]

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_4ca6b"]
albedo_texture = ExtResource("3_tmo08")

[sub_resource type="PlaneMesh" id="PlaneMesh_3sh07"]
material = SubResource("StandardMaterial3D_4ca6b")
size = Vector2(1, 1)

[sub_resource type="BoxShape3D" id="BoxShape3D_4ca6b"]
size = Vector3(1, 0.1, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_n7ph5"]
albedo_texture = ExtResource("2_n7ph5")

[sub_resource type="PlaneMesh" id="PlaneMesh_tmo08"]
material = SubResource("StandardMaterial3D_n7ph5")
size = Vector2(1, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_tmo08"]
albedo_texture = ExtResource("1_4ca6b")

[sub_resource type="PlaneMesh" id="PlaneMesh_h1r0y"]
material = SubResource("StandardMaterial3D_tmo08")
size = Vector2(1, 1)

[node name="Ground" type="Node3D"]

[node name="MeshInstance3D" type="MeshInstance3D" parent="."]
mesh = SubResource("PlaneMesh_3sh07")

[node name="StaticBody3D" type="StaticBody3D" parent="MeshInstance3D"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="MeshInstance3D/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.05, 0)
shape = SubResource("BoxShape3D_4ca6b")

[node name="MeshInstance3D2" type="MeshInstance3D" parent="."]
mesh = SubResource("PlaneMesh_tmo08")

[node name="StaticBody3D" type="StaticBody3D" parent="MeshInstance3D2"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="MeshInstance3D2/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.05, 0)
shape = SubResource("BoxShape3D_4ca6b")

[node name="MeshInstance3D3" type="MeshInstance3D" parent="."]
mesh = SubResource("PlaneMesh_h1r0y")

[node name="StaticBody3D" type="StaticBody3D" parent="MeshInstance3D3"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="MeshInstance3D3/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.05, 0)
shape = SubResource("BoxShape3D_4ca6b")

============Spine/spine_node_2d.gd============
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

============Spine/spine_node_2d.gd.uid============
uid://b803dwrmwg6cg

============Spine/spine_node_2d.tscn============
[gd_scene load_steps=2 format=3 uid="uid://co7cninpw3g85"]

[ext_resource type="Script" uid="uid://b803dwrmwg6cg" path="res://Scene/Spine/spine_node_2d.gd" id="1_kssk3"]

[node name="SpineNode2D" type="Node2D"]
script = ExtResource("1_kssk3")

[node name="SpineSprite" type="SpineSprite" parent="."]
position = Vector2(873, 689)

[node name="Label" type="Label" parent="."]
offset_right = 40.0
offset_bottom = 23.0
text = "SpineNode2D: spine_res 未设置"

============main.gd============
extends Node3D

@onready var player: Character = $Player
@onready var camera_3d: Camera3D = $Camera3D

var offset: Vector3 = Vector3(0, 2, 5)

func _process(_delta: float) -> void:
	camera_3d.position = player.position + offset

============main.gd.uid============
uid://d0g4d6b5b1bui

============main.tscn============
[gd_scene load_steps=8 format=3 uid="uid://45dbngedah4m"]

[ext_resource type="MeshLibrary" uid="uid://d1bdtffhkjf5t" path="res://Resource/ground_mesh_lib.tres" id="1_f6udf"]
[ext_resource type="Script" uid="uid://d0g4d6b5b1bui" path="res://Scene/main.gd" id="1_r34rm"]
[ext_resource type="PackedScene" uid="uid://cnbp6cul124j0" path="res://Scene/Character/player.tscn" id="2_sblpm"]

[sub_resource type="ProceduralSkyMaterial" id="ProceduralSkyMaterial_rlixt"]
sky_horizon_color = Color(0.66224277, 0.6717428, 0.6867428, 1)
ground_horizon_color = Color(0.66224277, 0.6717428, 0.6867428, 1)

[sub_resource type="Sky" id="Sky_f6udf"]
sky_material = SubResource("ProceduralSkyMaterial_rlixt")

[sub_resource type="Environment" id="Environment_sblpm"]
background_mode = 2
sky = SubResource("Sky_f6udf")
tonemap_mode = 2

[sub_resource type="BoxShape3D" id="BoxShape3D_r34rm"]
size = Vector3(1, 6.4141846, 17.642578)

[node name="Main" type="Node3D"]
script = ExtResource("1_r34rm")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("Environment_sblpm")

[node name="GridMap" type="GridMap" parent="."]
mesh_library = ExtResource("1_f6udf")
cell_size = Vector3(1, 1, 1)
cell_center_y = false
data = {
"cells": PackedInt32Array(0, 0, 1, 0, 65535, 0, 65535, 65535, 2, 65535, 0, 0, 65534, 0, 0, 65533, 0, 0, 65532, 0, 0, 65532, 1, 0, 65532, 2, 0, 65532, 3, 0, 65533, 3, 0, 65534, 3, 0, 65535, 3, 0, 65535, 2, 0, 65535, 1, 0, 65533, 1, 0, 65533, 2, 0, 65534, 2, 0, 65534, 1, 0, 0, 1, 1, 0, 2, 1, 0, 3, 1, 1, 3, 1, 2, 3, 1, 3, 3, 1, 3, 2, 1, 3, 1, 1, 3, 0, 1, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1, 2, 1, 2, 2, 1, 2, 1, 1, 1, 65535, 0, 2, 65535, 0, 3, 65535, 0, 65534, 65535, 2, 65533, 65535, 2, 65532, 65535, 2, 65532, 65534, 2, 65532, 65533, 2, 65532, 65532, 2, 65533, 65532, 2, 65534, 65532, 2, 65535, 65532, 2, 65535, 65533, 2, 65535, 65534, 2, 65534, 65534, 2, 65533, 65534, 2, 65533, 65533, 2, 65534, 65533, 2, 0, 65532, 0, 0, 65533, 0, 0, 65534, 0, 1, 65534, 0, 3, 65534, 0, 3, 65533, 0, 2, 65533, 0, 1, 65533, 0, 2, 65534, 0, 2, 65532, 0, 1, 65532, 0, 3, 65532, 0, 65528, 0, 2, 65528, 1, 2, 65528, 2, 2, 65528, 3, 2, 65528, 4, 2, 65528, 5, 2, 65528, 6, 2, 65528, 7, 2, 65529, 0, 2, 65529, 1, 2, 65529, 2, 2, 65529, 3, 2, 65529, 4, 2, 65529, 5, 2, 65529, 6, 2, 65529, 7, 2, 65530, 0, 2, 65530, 1, 2, 65530, 2, 2, 65530, 3, 2, 65530, 4, 2, 65530, 5, 2, 65530, 6, 2, 65530, 7, 2, 65531, 0, 2, 65531, 1, 2, 65531, 2, 2, 65531, 3, 2, 65531, 4, 2, 65531, 5, 2, 65531, 6, 2, 65531, 7, 2, 65532, 4, 2, 65532, 5, 2, 65532, 6, 2, 65532, 7, 2, 65533, 4, 2, 65533, 5, 2, 65533, 6, 2, 65533, 7, 2, 65534, 4, 2, 65534, 5, 2, 65534, 6, 2, 65534, 7, 2, 65535, 4, 2, 65535, 5, 2, 65535, 6, 2, 65535, 7, 2, 0, 65528, 2, 0, 65529, 2, 0, 65530, 2, 0, 65531, 2, 1, 65528, 2, 1, 65529, 2, 1, 65530, 2, 1, 65531, 2, 2, 65528, 2, 2, 65529, 2, 2, 65530, 2, 2, 65531, 2, 3, 65528, 2, 3, 65529, 2, 3, 65530, 2, 3, 65531, 2, 4, 65528, 2, 4, 65529, 2, 4, 65530, 2, 4, 65531, 2, 5, 65528, 2, 5, 65529, 2, 5, 65530, 2, 5, 65531, 2, 6, 65528, 2, 6, 65529, 2, 6, 65530, 2, 6, 65531, 2, 7, 65528, 2, 7, 65529, 2, 7, 65530, 2, 7, 65531, 2, 4, 65532, 2, 4, 65533, 2, 4, 65534, 2, 4, 65535, 2, 5, 65532, 2, 5, 65533, 2, 5, 65534, 2, 5, 65535, 2, 6, 65532, 2, 6, 65533, 2, 6, 65534, 2, 6, 65535, 2, 7, 65532, 2, 7, 65533, 2, 7, 65534, 2, 7, 65535, 2, 4, 0, 0, 4, 1, 0, 4, 2, 0, 4, 3, 0, 4, 4, 0, 4, 5, 0, 4, 6, 0, 4, 7, 0, 5, 0, 0, 5, 1, 0, 5, 2, 0, 5, 3, 0, 5, 4, 0, 5, 5, 0, 5, 6, 0, 5, 7, 0, 6, 0, 0, 6, 1, 0, 6, 2, 0, 6, 3, 0, 6, 4, 0, 6, 5, 0, 6, 6, 0, 6, 7, 0, 7, 0, 0, 7, 1, 0, 7, 2, 0, 7, 3, 0, 7, 4, 0, 7, 5, 0, 7, 6, 0, 7, 7, 0, 0, 4, 0, 0, 5, 0, 0, 6, 0, 0, 7, 0, 1, 4, 0, 1, 5, 0, 1, 6, 0, 1, 7, 0, 2, 4, 0, 2, 5, 0, 2, 6, 0, 2, 7, 0, 3, 4, 0, 3, 5, 0, 3, 6, 0, 3, 7, 0, 65528, 65528, 0, 65528, 65529, 0, 65528, 65530, 0, 65528, 65531, 0, 65528, 65532, 0, 65528, 65533, 0, 65528, 65534, 0, 65528, 65535, 0, 65529, 65528, 0, 65529, 65529, 0, 65529, 65530, 0, 65529, 65531, 0, 65529, 65532, 0, 65529, 65533, 0, 65529, 65534, 0, 65529, 65535, 0, 65530, 65528, 0, 65530, 65529, 0, 65530, 65530, 0, 65530, 65531, 0, 65530, 65532, 0, 65530, 65533, 0, 65530, 65534, 0, 65530, 65535, 0, 65531, 65528, 0, 65531, 65529, 0, 65531, 65530, 0, 65531, 65531, 0, 65531, 65532, 0, 65531, 65533, 0, 65531, 65534, 0, 65531, 65535, 0, 65532, 65528, 0, 65532, 65529, 0, 65532, 65530, 0, 65532, 65531, 0, 65533, 65528, 0, 65533, 65529, 0, 65533, 65530, 0, 65533, 65531, 0, 65534, 65528, 0, 65534, 65529, 0, 65534, 65530, 0, 65534, 65531, 0, 65535, 65528, 0, 65535, 65529, 0, 65535, 65530, 0, 65535, 65531, 0)
}

[node name="StaticBody3D" type="StaticBody3D" parent="GridMap"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="GridMap/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 7.5376863, 2.7070923, 0.58496094)
shape = SubResource("BoxShape3D_r34rm")

[node name="CollisionShape3D2" type="CollisionShape3D" parent="GridMap/StaticBody3D"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -8.570794, 2.7070923, 0.58496094)
shape = SubResource("BoxShape3D_r34rm")

[node name="CollisionShape3D3" type="CollisionShape3D" parent="GridMap/StaticBody3D"]
transform = Transform3D(-4.371139e-08, 0, 1, 0, 1, 0, -1, 0, -4.371139e-08, -0.17919636, 2.7070923, -8.177031)
shape = SubResource("BoxShape3D_r34rm")

[node name="CollisionShape3D4" type="CollisionShape3D" parent="GridMap/StaticBody3D"]
transform = Transform3D(-4.371139e-08, 0, 1, 0, 1, 0, -1, 0, -4.371139e-08, 0.44523716, 2.7070923, 7.584961)
shape = SubResource("BoxShape3D_r34rm")

[node name="Player" parent="." instance=ExtResource("2_sblpm")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)

[node name="Camera3D" type="Camera3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 5)
