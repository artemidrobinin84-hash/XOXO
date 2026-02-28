extends CanvasLayer

@onready var xoxo_bar = $XOXOProgressBar
@onready var hp_bar = $HPProgressBar
@onready var cringe_bar = $CringeProgressBar
@onready var common_manager = get_tree().get_first_node_in_group("enemy")

func _ready():
	if common_manager:
		if common_manager.has_signal("hp_changed"):
			common_manager.hp_changed.connect(_update_xoxo)
		
		if common_manager.has_signal("player_hp_changed"):
			common_manager.player_hp_changed.connect(_update_hp)
			
		if common_manager.has_signal("cringe_changed"):
			common_manager.cringe_changed.connect(_update_cringe)
		
		_update_xoxo(common_manager.current_hp, common_manager.max_hp)
		_update_hp(common_manager.current_player_hp, common_manager.max_player_hp)
		_update_cringe(common_manager.current_cringe, 10)

func _update_xoxo(current, max_val):
	xoxo_bar.max_value = max_val
	xoxo_bar.value = current
	xoxo_bar.get_node("ProgressLabel").text = str(current) + " / " + str(max_val)

func _update_hp(current, max_val):
	hp_bar.max_value = max_val
	hp_bar.value = current
	hp_bar.get_node("ProgressLabel").text = str(current) + " / " + str(max_val)

func _update_cringe(current, max_val):
	cringe_bar.max_value = max_val
	cringe_bar.value = current
	cringe_bar.get_node("ProgressLabel").text = str(current) + " / " + str(max_val)
