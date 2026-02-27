extends TextureProgressBar

@onready var progress_label = $ProgressLabel 
# Находим узел, у которого есть сигнал hp_changed
@onready var boss = get_tree().get_first_node_in_group("enemy")

func _ready():
	if boss:
		boss.hp_changed.connect(_on_boss_hp_changed)
		# Используем ПРАВИЛЬНЫЕ имена переменных из вашего скрипта:
		# current_hp и max_hp вместо hp и max_hp_val
		_on_boss_hp_changed(boss.current_hp, boss.max_hp) 

func _on_boss_hp_changed(current, max_hp_val):
	max_value = max_hp_val
	value = current
	
	if progress_label:
		progress_label.text = str(current) + " / " + str(max_hp_val)
