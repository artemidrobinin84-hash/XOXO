extends Node2D

signal hp_changed(current_hp, max_hp)
signal player_hp_changed(current, max_val)
signal cringe_changed(current, max_val)
signal boss_defeated
signal boss_win
@export var max_hp: int = 100
var current_hp: int

var current_player_hp: int = 100
var max_player_hp: int = 100
var current_cringe: int = 0
const MAX_CRINGE: int = 10

func _ready():
	add_to_group("enemy")
	add_to_group("player")
	
	current_hp = max_hp
	
	hp_changed.emit(current_hp, max_hp)
	player_hp_changed.emit(current_player_hp, max_player_hp)
	cringe_changed.emit(current_cringe, MAX_CRINGE)


func take_damage(amount: int):
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_hp)
	
	hp_changed.emit(current_hp, max_hp)
	
	if current_hp <= 0:
		die()

func add_cringe(amount: int):
	current_cringe += amount
	current_cringe = clampi(current_cringe, 0, MAX_CRINGE)
	cringe_changed.emit(current_cringe, MAX_CRINGE)
	
	if current_cringe >= MAX_CRINGE:
		lose_game("Слишком кринжово!")

func heal(amount: int):
	current_player_hp = clampi(current_player_hp + amount, 0, max_player_hp)
	player_hp_changed.emit(current_player_hp, max_player_hp)

func win():
	boss_win.emit()
	print("Лох!")

func die():
	boss_defeated.emit()
	print("Победа!")

func lose_game(reason: String):
	print(reason)
