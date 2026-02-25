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
var is_dragging: bool = false
var drag_offset: Vector2
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

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_selected and not is_dragging:
			return_to_rest()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			accept_event() 
			if not is_selected:
				deselect_others()
				toggle_select()
			else:
				start_drag()
		elif is_dragging:
			stop_drag()

func deselect_others():
	var card_manager = get_parent()
	if card_manager:
		for child in card_manager.get_children():
			if child is BaseCard and child != self:
				if child.is_selected:
					child.return_to_rest()

func start_drag():
	is_dragging = true
	drag_offset = get_global_mouse_position() - global_position
	z_index = 500
	if active_tween: active_tween.kill()

func stop_drag():
	is_dragging = false
	check_drop_zone()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset

func check_drop_zone():
	var targets = get_tree().get_nodes_in_group("enemy")
	var hit = false
	var mouse_pos = get_global_mouse_position()
	
	for target in targets:
		if target is Area2D:
			for child in target.get_children():
				if child is CollisionShape2D and child.shape is RectangleShape2D:
					var rect = child.shape.get_rect()
					var local_mouse_pos = child.to_local(mouse_pos)
					if rect.has_point(local_mouse_pos):
						hit = true
						break
		if hit: break
			
	if hit:
		play_card_animation()
	else:
		return_to_rest()

func play_card_animation():
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	active_tween.tween_property(self, "modulate:a", 0.0, 0.3)
	active_tween.tween_property(self, "scale", Vector2(0.3, 0.3), 0.3)
	active_tween.chain().tween_callback(func():
		get_tree().call_group("card_manager", "draw_card")
		queue_free()
	)

func toggle_select():
	is_selected = true
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	z_index = 200
	active_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_BACK)
	active_tween.tween_property(self, "position", home_position + Vector2(0, -180), 0.2)
	active_tween.tween_property(self, "rotation_degrees", -3.0, 0.2)

func _on_mouse_entered():
	if is_selected or is_dragging: return
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	z_index = 100
	active_tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_QUAD)
	active_tween.tween_property(self, "rotation_degrees", 0, 0.2)
	active_tween.tween_property(self, "position", home_position + Vector2(0, -60), 0.2)

func _on_mouse_exited():
	if is_selected or is_dragging: return
	return_to_rest()

func return_to_rest():
	is_selected = false
	is_dragging = false
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	active_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	active_tween.tween_property(self, "rotation_degrees", home_rotation, 0.2)
	active_tween.tween_property(self, "position", home_position, 0.2)
	active_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	active_tween.chain().tween_callback(func(): z_index = 0)
