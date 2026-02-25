extends PanelContainer
class_name BaseCard

@export var card_resource: CardData 

@onready var title_label = $Background/Content/TitleLabel
@onready var desc_label = $Background/Content/Description
@onready var icon_texture = $Background/Content/CardIcon
@onready var cost_label = $Background/Content/Cost/CostLabel
@onready var damage_label = $Background/Content/Damage/DamageLabel
@onready var shield_label = $Background/Content/Shield/ShieldLabel
@onready var heal_label = $Background/Content/Heal/HealLabel

var home_position: Vector2
var home_rotation: float
var is_selected: bool = false
var active_tween: Tween

func _ready():
	if card_resource:
		render_card()

func render_card():
	if not card_resource: return
	title_label.text = card_resource.title
	desc_label.text = card_resource.description
	icon_texture.texture = card_resource.icon
	cost_label.text = str(card_resource.cost)
	damage_label.text = str(card_resource.damage)
	shield_label.text = str(card_resource.shield)
	heal_label.text = str(card_resource.heal)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if !is_selected:
			get_tree().call_group("card_manager", "deselect_all_cards", self)
		toggle_select()

func toggle_select():
	is_selected = !is_selected
	
	if active_tween: active_tween.kill() 
	active_tween = create_tween().set_parallel(true)
	
	if is_selected:
		z_index = 200
		active_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_BACK)
		active_tween.tween_property(self, "position", home_position + Vector2(0, -180), 0.2)
		active_tween.tween_property(self, "rotation_degrees", -3.0, 0.2) # Наклон влево при выборе
	else:
		return_to_rest()

func _on_mouse_entered():
	if is_selected: return
	
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	
	z_index = 100
	active_tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_QUAD)
	active_tween.tween_property(self, "rotation_degrees", 0, 0.2)
	active_tween.tween_property(self, "position", home_position + Vector2(0, -60), 0.2)

func _on_mouse_exited():
	if is_selected: return
	return_to_rest()

func return_to_rest():
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	
	active_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	active_tween.tween_property(self, "rotation_degrees", home_rotation, 0.2)
	active_tween.tween_property(self, "position", home_position, 0.2)
	
	active_tween.chain().tween_callback(func():
		z_index = 0
	)
