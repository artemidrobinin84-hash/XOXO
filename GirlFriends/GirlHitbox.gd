extends Node2D

signal hp_changed(current_hp, max_hp)
signal boss_defeated

@export var max_hp: int = 100
var current_hp: int

func _ready():
	current_hp = max_hp
	hp_changed.emit(current_hp, max_hp)

func take_damage(amount: int):
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_hp)
	
	hp_changed.emit(current_hp, max_hp)
	print("Босс получил урон: ", amount, ". Осталось ХП: ", current_hp)
	
	if current_hp <= 0:
		die()

func die():
	boss_defeated.emit() # Этого достаточно, VictoryLayer это услышит
	print("Босс повержен!")
