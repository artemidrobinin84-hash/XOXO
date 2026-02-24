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

func _ready():
	# Устанавливаем центр вращения/масштаба в середину карты
	pivot_offset = size / 2
	if card_resource:
		render_card()

func render_card():
	if not card_resource:
		return
	
	# Используем .title, так как на скриншоте ошибки видно, что card_name не найден
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
	var tween = create_tween()
	# Используем set_trans для более мягкой анимации
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_QUAD)
	z_index = 10

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD)
	z_index = 0
