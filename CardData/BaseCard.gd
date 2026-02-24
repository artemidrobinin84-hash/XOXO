extends PanelContainer
class_name BaseCard

@export var card_resource: CardData 

@onready var title_label = $Background/Content/TitleLabel
@onready var desc_label = $Background/Content/Description
@onready var icon_texture = $Background/Content/CardIcon
@onready var cost_label = $Background/Content/CostBadge/CostLabel
@onready var damage_label = $Background/Content/DamageIcon/DamageLabel

func _ready():
	if card_resource:
		render_card()

func render_card():
	title_label.text = card_resource.title
	desc_label.text = card_resource.description
	icon_texture.texture = card_resource.icon
	cost_label.text = str(card_resource.cost)
	
	if card_resource.damage > 0:
		damage_label.text = str(card_resource.damage)
		damage_label.get_parent().visible = true
	else:
		damage_label.get_parent().visible = false
