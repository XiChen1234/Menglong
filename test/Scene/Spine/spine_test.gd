extends SpineSprite

func _ready():
	# 骨骼数据
	var data = get_skeleton().get_data()

	# 创建一个空皮肤
	var custom_skin = new_skin("custom-skin")

	# 获取基础皮肤（假设Goat是基础骨骼皮肤）
	var skin_base = data.find_skin("Lamb")
	custom_skin.add_skin(skin_base)
	custom_skin.add_skin(data.find_skin("Weapons/Fervor"))

	# 设置皮肤
	get_skeleton().set_skin(custom_skin)

	# 打印每个附件的槽位和名称，便于调试
	for el in custom_skin.get_attachments():
		var entry: SpineSkinEntry = el
		print(str(entry.get_slot_index()) + " " + entry.get_name())
	
	# 播放动画
	get_animation_state().set_animation("attack-combo1", false, 0)
	get_animation_state().add_animation("attack-combo2", false, 0)
	get_animation_state().add_animation("attack-combo3", false, 0)
	get_animation_state().add_animation("attack-combo1", false, 0)
	get_animation_state().add_animation("attack-combo2", false, 0)
	get_animation_state().add_animation("attack-combo3", false, 0)
	get_animation_state().add_animation("attack-combo1", false, 0)
	get_animation_state().add_animation("attack-combo2", false, 0)
	get_animation_state().add_animation("attack-combo3", false, 0)
