extends SpineSprite

@onready var health_bar = get_node("../ProgressBar/XOXOProgressBar")
@onready var phase_sound = $Phase_Sound
@onready var boss_hitbox = get_node("../GirlHitbox")
var current_skin = ""

func _ready():
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)
	
	if not self.animation_completed.is_connected(_on_spine_animation_completed):
		self.animation_completed.connect(_on_spine_animation_completed)
	
	await get_tree().process_frame
	if health_bar:
		_update_visuals(health_bar.value)

func _process(_delta):
	if health_bar and get_skeleton():
		_update_visuals(health_bar.value)

func _update_visuals(hp_value: float):
	var target_skin = ""
	if hp_value >= 10: target_skin = "level1"
	elif hp_value >= 5: target_skin = "level2"
	else: target_skin = "level3"
	
	if current_skin == target_skin: return
		
	var skeleton = get_skeleton()
	if skeleton:
		skeleton.set_skin_by_name(target_skin)
		skeleton.set_to_setup_pose()
		if current_skin != "" and phase_sound:
			phase_sound.play()
		current_skin = target_skin

func perform_enemy_attack():
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.clear_tracks()
		var skeleton = get_skeleton()
		if skeleton:
			skeleton.set_to_setup_pose()

		animation_state.set_animation("attack", false, 0)
		
	if boss_hitbox:
		boss_hitbox.deal_damage_to_player(randi_range(10, 30))
		
func _on_spine_animation_completed(_sprite, _track_entry, _track_index):
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)
