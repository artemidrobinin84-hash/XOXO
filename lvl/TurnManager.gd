extends Node

signal player_turn_started
signal enemy_turn_started

enum Turn { PLAYER, ENEMY }
var current_turn = Turn.PLAYER
@onready var Card_sound = $"../Card"
func _ready():
	await get_tree().process_frame
	start_player_turn()

func start_player_turn():
	current_turn = Turn.PLAYER
	emit_signal("player_turn_started")

func end_player_turn():
	if current_turn != Turn.PLAYER: return
	current_turn = Turn.ENEMY
	emit_signal("enemy_turn_started")
	
	await get_tree().create_timer(1.5).timeout
	Card_sound.play()
	start_player_turn()

func _on_turn_button_pressed() -> void:
	print("Кнопка нажата! Завершаю ход игрока...")
	end_player_turn()
