extends PanelContainer
class_name BaseCard

@export var card_resource: CardData 

# Обновленные пути согласно скриншоту image_7bf337.png
@onready var title_label = $Background/Content/TitleLabel
@onready var desc_label = $Background/Content/Description
@onready var icon_texture = $Background/Content/CardIcon

# Пути к статам теперь включают промежуточные узлы (Damage, Shield, Heal, Cost)
@onready var cost_label = $Background/Content/Cost/CostLabel
@onready var damage_label = $Background/Content/Damage/DamageLabel
@onready var shield_label = $Background/Content/Shield/ShieldLabel
@onready var heal_label = $Background/Content/Heal/HealLabel

# Переменные для хранения места в веере
var home_position: Vector2
var home_rotation: float

func _ready():
	# Pivot Offset должен быть настроен в редакторе (X: центр, Y: низ)
	if card_resource:
		render_card()

func render_card():
	if not card_resource:
		return
	
	# Используем .title, так как в ресурсе поле называется именно так
	title_label.text = card_resource.title 
	desc_label.text = card_resource.description
	icon_texture.texture = card_resource.icon
	
	# Стоимость (убедись, что в CardData поле называется cost)
	cost_label.text = str(card_resource.cost)
	
	# Статы (всегда отображаем, даже если 0)
	damage_label.text = str(card_resource.damage)
	heal_label.text = str(card_resource.heal)
	shield_label.text = str(card_resource.shield)
	
	# Включаем видимость контейнеров
	$Background/Content/Damage.visible = true
	$Background/Content/Shield.visible = true
	$Background/Content/Heal.visible = true

# --- Визуальные эффекты при наведении ---

func _on_mouse_entered():
	# Выводим карту на передний план
	z_index = 100 
	
	var tween = create_tween().set_parallel(true)
	# Увеличиваем масштаб для читаемости
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_QUAD)
	# Сбрасываем наклон в 0, чтобы текст был горизонтальным
	tween.tween_property(self, "rotation_degrees", 0, 0.15)
	# Приподнимаем карту вверх над веером
	tween.tween_property(self, "position", home_position + Vector2(0, -60), 0.15)

func _on_mouse_exited():
	# Возвращаем слой согласно порядку в руке
	z_index = get_index() 
	
	var tween = create_tween().set_parallel(true)
	# Возвращаем масштаб к исходному
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)
	# Возвращаем наклон веера
	tween.tween_property(self, "rotation_degrees", home_rotation, 0.15)
	# Возвращаем на "домашнюю" позицию в дуге
	tween.tween_property(self, "position", home_position, 0.15)
