extends PanelContainer
class_name BaseCard

# ... (все ваши @export и @onready переменные остаются без изменений) ...
@export var card_resource: CardData 

@onready var title_label = $Background/Content/TitleLabel
@onready var desc_label = $Background/Content/Description
@onready var icon_texture = $Background/Content/CardIcon
@onready var cost_label = $Background/Content/Cost/CostLabel
@onready var damage_label = $Background/Content/Damage/DamageLabel
@onready var shield_label = $Background/Content/Shield/ShieldLabel
@onready var heal_label = $Background/Content/Heal/HealLabel

var home_position: Vector2
var home_z_index: int = 0
var home_rotation: float
var is_selected: bool = false
var is_dragging: bool = false
var drag_offset: Vector2
var active_tween: Tween

func _ready():
	if card_resource:
		render_card()

# --- НОВЫЙ МЕТОД ДЛЯ КЛИКА ПО ЭКРАНУ ---
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_selected and not is_dragging:
			# Проверяем, попал ли клик мимо этой карты
			var mouse_pos = get_global_mouse_position()
			if not get_global_rect().has_point(mouse_pos):
				return_to_rest()

func _gui_input(event):
	if not can_interact(): return 

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			accept_event()
			if not is_selected:
				is_selected = true 
				deselect_others()
				toggle_select()
			else:
				# Если уже выбрана, разрешаем начать драг
				start_drag()
		elif is_dragging:
			stop_drag()

	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if is_selected and not is_dragging:
			if event.relative.length() > 1.0:
				start_drag()

func toggle_select():
	is_selected = true
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	z_index = 600
	active_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2)
	active_tween.tween_property(self, "position", home_position + Vector2(0, -180), 0.2)
	active_tween.tween_property(self, "rotation_degrees", 0.0, 0.2)

func start_drag():
	if not is_dragging:
		is_dragging = true
		is_selected = true
		drag_offset = get_global_mouse_position() - global_position
		if active_tween: active_tween.kill()
		z_index = 1000 

func stop_drag():
	is_dragging = false
	check_drop_zone()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset

func return_to_rest():
	if is_dragging: return
	
	is_selected = false
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	active_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	active_tween.tween_property(self, "position", home_position, 0.2)
	active_tween.tween_property(self, "rotation_degrees", home_rotation, 0.2)
	active_tween.chain().tween_callback(func(): z_index = home_z_index)

func deselect_others():
	var parent = get_parent()
	if parent:
		for child in parent.get_children():
			if child is BaseCard and child != self:
				child.return_to_rest()

func check_drop_zone():
	var targets = get_tree().get_nodes_in_group("enemy")
	var hit_target = null
	var mouse_pos = get_global_mouse_position()
	for target in targets:
		if target is Area2D:
			for child in target.get_children():
				if child is CollisionShape2D:
					if child.shape.get_rect().has_point(child.to_local(mouse_pos)):
						hit_target = target
						break
		if hit_target: break
	if hit_target:
		var manager = get_tree().get_first_node_in_group("card_manager")
		if manager and manager.can_afford_card(card_resource.cost):
			manager.use_energy(card_resource.cost)
			if hit_target.has_method("take_damage"): hit_target.take_damage(card_resource.damage)
			play_card_animation()
		else: return_to_rest()
	else: return_to_rest()

func play_card_animation():
	if active_tween: active_tween.kill()
	active_tween = create_tween().set_parallel(true)
	active_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	active_tween.tween_property(self, "scale", Vector2(0.2, 0.2), 0.2)
	active_tween.chain().tween_callback(func():
		var manager = get_tree().get_first_node_in_group("card_manager")
		if manager: manager.update_hand_fan()
		queue_free()
	)

func render_card():
	if not card_resource: return
	title_label.text = card_resource.title
	desc_label.text = card_resource.description
	icon_texture.texture = card_resource.icon
	cost_label.text = str(card_resource.cost)
	damage_label.text = str(card_resource.damage)
	shield_label.text = str(card_resource.shield)
	heal_label.text = str(card_resource.heal)

func can_interact() -> bool:
	var manager = get_tree().get_first_node_in_group("card_manager")
	return manager.can_interact_with_cards() if manager else true
