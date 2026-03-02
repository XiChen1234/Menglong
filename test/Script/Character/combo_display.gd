extends Node
class_name ComboDisplay

@onready var label: Label = $Label

var _combo_count: int = 0
var _display_timer: float = 0.0
var _is_visible: bool = false

# 连击显示持续时间（秒）
const DISPLAY_DURATION = 1.0

func _ready() -> void:
	# 初始化标签
	label.text = ""
	label.visible = false

func _process(delta: float) -> void:
	if _is_visible:
		_display_timer -= delta
		if _display_timer <= 0:
			# 隐藏连击显示
			_hide_combo()

func update_combo(count: int) -> void:
	_combo_count = count
	
	# 更新标签文本
	label.text = str(count) + " Combo!"
	
	# 显示连击计数
	_show_combo()

func _show_combo() -> void:
	# 显示标签
	label.visible = true
	_is_visible = true
	
	# 重置显示计时器
	_display_timer = DISPLAY_DURATION

func _hide_combo() -> void:
	# 隐藏标签
	label.visible = false
	_is_visible = false
	_combo_count = 0