extends Node

@export var card_scene: PackedScene
@export var all_cards: Array[CardData]

@export_group("Hand Settings")
@export var max_spread: float = 1250.0
@export var max_spacing: float = 550.0
@export var angle_step: float = 2.0
@export var arc_height: float = 25.0

@export var max_energy: int = 3
var current_energy: int = 0

var deck: Array[CardData] = []
var hand: Array[CardData] = []

@onready var hand_container = $Hand

func _ready():
	add_to_group("card_manager")
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

func spawn_card_in_ui(data: CardData):
	if not card_scene: return
	var card_instance = card_scene.instantiate()
	hand_container.add_child(card_instance)
	
	if card_instance.has_method("render_card"):
		card_instance.card_resource = data
		card_instance.render_card()
	
	update_hand_fan()

func deselect_all_cards(except_card: BaseCard):
	for card in hand_container.get_children():
		if card is BaseCard and card != except_card:
			if card.is_selected:
				card.return_to_rest() 

func update_hand_fan():
	var cards = hand_container.get_children()
	var count = cards.size()
	if count == 0: return

	var spacing = min(max_spread / count, max_spacing)
	
	for i in range(count):
		var card = cards[i]
		
		var float_idx = float(i)
		var center_offset = (float_idx - (count - 1) / 2.0)
		
		card.position.x = -center_offset * spacing
		card.rotation_degrees = -center_offset * angle_step
		
		var arc_factor = (center_offset * center_offset) / 25.0
		card.position.y = arc_factor * arc_height
		
		card.z_index = 0
		
		if card is BaseCard:
			card.home_position = card.position
			card.home_rotation = card.rotation_degrees
