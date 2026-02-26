extends ProgressBar

@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	if boss:
		boss.hp_changed.connect(_on_boss_hp_changed)

func _on_boss_hp_changed(current, max_hp_val):
	max_value = max_hp_val
	value = current
