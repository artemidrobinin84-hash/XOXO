extends Node

@export var card_scene: PackedScene
@export var all_cards: Array[CardData]

@export_group("Hand Settings")
@export var max_spread: float = 550.0
@export var max_spacing: float = 95.0
@export var angle_step: float = 3.0
@export var arc_height: float = 25.0

@export_group("Gameplay Settings")
@export var max_energy: int = 8
var current_energy: int = 0
var max_hand_size: int = 5

@export_group("Energy Visuals")
# Пути взяты из твоего FileSystem на скриншоте
@export var star_full_texture: Texture2D = preload("res://CardData/ImgCard/CostStar.png")
@export var star_empty_texture: Texture2D = preload("res://CardData/ImgCard/CostStarNo.png")

var deck: Array[CardData] = []

@onready var deck_label = get_node_or_null("../../Deck/DeckLabel")
@onready var energy_label = get_node_or_null("../../CostLabel") 
@onready var turn_manager = get_node_or_null("../../TurnManager")
@onready var hand_container = $Hand
@onready var energy_container = get_node_or_null("../../EnergyContainer")

func _ready():
	add_to_group("card_manager")
	deck = all_cards.duplicate()
	deck.shuffle()
	
	current_energy = max_energy
	update_energy_ui()
	update_deck_label() 
	replenish_hand()
	
	if turn_manager:
		turn_manager.player_turn_started.connect(_on_player_turn_started)

func update_deck_label():
	if deck_label:
		deck_label.text = "X" + str(deck.size())
	var deck_node = get_node_or_null("../../Deck")
	if deck_node:
		if deck_node.has_node("DeckCard"):
			deck_node.get_node("DeckCard").visible = deck.size() >= 4
		if deck_node.has_node("DeckCard2"):
			deck_node.get_node("DeckCard2").visible = deck.size() >= 3
		if deck_node.has_node("DeckCard3"):
			deck_node.get_node("DeckCard3").visible = deck.size() >= 2
		if deck_node.has_node("DeckCard4"):
			deck_node.get_node("DeckCard4").visible = deck.size() >= 1

func _on_player_turn_started():
	current_energy = max_energy
	update_energy_ui()
	replenish_hand()

func update_energy_ui():
	# Текстовый вариант (если остался)
	if energy_label:
		energy_label.text = "Energy: " + str(current_energy) + " / " + str(max_energy)
	
	# Визуальный вариант со звездами
	_update_energy_stars()

func _update_energy_stars():
	if not energy_container: 
		return
	
	# Очищаем старые звезды
	for child in energy_container.get_children():
		child.queue_free()
	
	# Создаем новые звезды
	for i in range(max_energy):
		var star_rect = TextureRect.new()
		
		if i < current_energy:
			star_rect.texture = star_full_texture
		else:
			star_rect.texture = star_empty_texture
			
		star_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		# Установи небольшой размер, если звезды слишком большие
		star_rect.custom_minimum_size = Vector2(40, 40) 
		
		energy_container.add_child(star_rect)

func use_energy(amount: int):
	current_energy -= amount
	update_energy_ui()

func replenish_hand():
	var current_count = hand_container.get_child_count()
	var need = max_hand_size - current_count
	
	if need <= 0: return

	for i in range(need):
		if hand_container.get_child_count() >= max_hand_size:
			break
			
		if deck.size() > 0:
			var data = deck.pop_front()
			spawn_card_in_ui(data)
			update_deck_label()
			update_hand_fan()
			await get_tree().create_timer(0.1).timeout

func spawn_card_in_ui(data: CardData):
	if not card_scene: return
	var card_instance = card_scene.instantiate()
	hand_container.add_child(card_instance)
	hand_container.move_child(card_instance, 0)
	card_instance.card_resource = data
	if card_instance.has_method("render_card"):
		card_instance.render_card()

func can_interact_with_cards() -> bool:
	if not turn_manager: return true 
	return turn_manager.current_turn == turn_manager.Turn.PLAYER

func can_afford_card(cost: int) -> bool:
	return can_interact_with_cards() and current_energy >= cost

func update_hand_fan():
	var cards = hand_container.get_children()
	var total_cards = cards.size()
	if total_cards == 0: return
	
	var spacing = min(max_spread / total_cards, max_spacing)
	
	for i in range(total_cards):
		var card = cards[i]
		if not card.has_method("set"): continue 
		
		var raw_offset = (float(i) - (total_cards - 1) / 2.0)
		var offset = -raw_offset
		
		var target_pos = Vector2(offset * spacing, (offset * offset / 10.0) * arc_height)
		var target_rot = offset * angle_step
		
		if "home_position" in card:
			card.home_position = target_pos
		if "home_rotation" in card:
			card.home_rotation = target_rot
		
		card.z_index = 0
		if "home_z_index" in card:
			card.home_z_index = 0 

		if ("is_dragging" in card and not card.is_dragging) and ("is_selected" in card and not card.is_selected):
			var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(card, "position", target_pos, 0.4)
			tween.tween_property(card, "rotation_degrees", target_rot, 0.4)
			tween.tween_property(card, "scale", Vector2(1, 1), 0.4)
			tween.tween_property(card, "modulate:a", 1.0, 0.2)
