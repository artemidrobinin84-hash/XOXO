extends Node2D

@onready var boss_hitbox = $GirlHitbox
@onready var spine_sprite = $GirlSprite
@onready var health_bar = $CanvasLayer2/ProgressBar
@onready var victory_screen = $CanvasLayer2/VictoryScreen

var current_skin = ""

func _ready():
	if victory_screen:
		victory_screen.hide()
	
	await get_tree().process_frame 
	
	var animation_state = spine_sprite.get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)
	
	if boss_hitbox:
		boss_hitbox.hp_changed.connect(_on_boss_hp_changed)
		boss_hitbox.boss_defeated.connect(_on_boss_defeated)
		_on_boss_hp_changed(boss_hitbox.current_hp, boss_hitbox.max_hp)

func _on_boss_hp_changed(current, max_hp_val):
	if health_bar:
		health_bar.max_value = max_hp_val
		health_bar.value = current
		if health_bar.has_node("ProgressLabel"):
			health_bar.get_node("ProgressLabel").text = str(current) + " / " + str(max_hp_val)
	
	if spine_sprite and spine_sprite.has_method("update_skin_by_hp"):
		spine_sprite.update_skin_by_hp(current)

func _update_boss_skin(hp_value: float):
	var target_skin = ""
	if hp_value >= 67: target_skin = "level1"
	elif hp_value >= 34: target_skin = "level2"
	else: target_skin = "level3"
	
	if current_skin == target_skin: return
	
	var skeleton = spine_sprite.get_skeleton()
	if skeleton:
		skeleton.set_skin_by_name(target_skin)
		skeleton.set_to_setup_pose()
		current_skin = target_skin

func _on_boss_defeated():
	if victory_screen:
		victory_screen.show()
	print("Уровень пройден!")
#fdsfsd
func _on_next_level_pressed():
	get_tree().change_scene_to_file("res://lvl/lvl2.tscn")

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")
