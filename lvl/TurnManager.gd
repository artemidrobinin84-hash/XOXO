extends Node

signal player_turn_started
signal enemy_turn_started

enum Turn { PLAYER, ENEMY }
var current_turn = Turn.PLAYER

@onready var card_sound = $"../Card"
@onready var boss = $"../GirlSprite" # Ссылка на спрайт с анимациями и логикой урона

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
	
	# --- ЛОГИКА АТАКИ ВРАГА ---
	if boss and boss.has_method("perform_enemy_attack"):
		boss.perform_enemy_attack()
	
	# Задержка перед возвратом хода игроку, чтобы анимация успела проиграться
	await get_tree().create_timer(2.0).timeout 
	
	if card_sound:
		card_sound.play()
	start_player_turn()

func _on_turn_button_pressed() -> void:
	print("Кнопка нажата! Завершаю ход игрока...")
	$"../CringeLayer/Click".play()
	end_player_turn()
