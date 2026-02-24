extends Node

@export var card_scene: PackedScene
@export var all_cards: Array[CardData]

@export var max_energy: int = 3
var current_energy: int = 0

var deck: Array[CardData] = []
var hand: Array[CardData] = []

@onready var hand_container = $Hand

func _ready():
	deck = all_cards.duplicate()
	deck.shuffle()
	draw_cards(5)
	current_energy = max_energy

func draw_cards(amount: int):
	for i in range(amount):
		if deck.size() > 0:
			var card_data = deck.pop_front()
			hand.append(card_data)
			spawn_card_in_ui(card_data)
		else:
			print("Колода пуста!")

func spawn_card_in_ui(data: CardData):
	var card_instance = card_scene.instantiate()
	hand_container.add_child(card_instance)
	
	if card_instance.has_method("render_card"):
		card_instance.card_resource = data
		card_instance.render_card()
