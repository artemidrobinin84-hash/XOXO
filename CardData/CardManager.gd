extends Node

@export var card_scene: PackedScene
@export var all_cards: Array[CardData]

@export var max_energy: int = 3
var current_energy: int = 0

var deck: Array[CardData] = []
var hand: Array[CardData] = []

@onready var hand_container = $Hand

func _ready():
	# Если ты сменил тип Hand на Control, сбрось его позицию в центр низа
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
	if not card_scene: 
		print("Ошибка: Забудь перетащить CardUI.tscn в инспектор CardManager!")
		return
		
	var card_instance = card_scene.instantiate()
	hand_container.add_child(card_instance)
	
	if card_instance.has_method("render_card"):
		card_instance.card_resource = data
		card_instance.render_card()
	
	# После добавления каждой карты пересчитываем веер
	update_hand_fan()

func update_hand_fan():
	var cards = hand_container.get_children()
	var count = cards.size()
	if count == 0: return

	# Настройки веера (можно тоже вынести в @export)
	var spread_angle = 30.0   # Общий наклон крайних карт
	var arc_height = 25.0     # Высота изгиба
	var x_spacing = 70.0      # Расстояние между картами
	
	for i in range(count):
		var card = cards[i]
		
		# Вычисляем смещение от -1.0 (лево) до 1.0 (право)
		var offset = 1.0
		if count > 1:
			offset = (float(i) / (count - 1)) * 2.0 - 1.0
		card.rotation_degrees = -offset * (spread_angle / 2.0)
		card.position.x = -offset * (x_spacing * (count / 2.0))
		card.position.y = abs(offset) * arc_height
		card.z_index = i
		
