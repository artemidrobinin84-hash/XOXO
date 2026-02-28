extends SpineSprite

@onready var health_bar = get_node("../ProgressBar/XOXOProgressBar")
@onready var phase_sound = $PhaseSound
var current_skin = ""

func _ready():
	var animation_state = get_animation_state()
	if animation_state:
		animation_state.set_animation("idle", true, 0)
	
	if health_bar:
		_update_visuals(health_bar.value)

func _process(_delta):
	if health_bar:
		_update_visuals(health_bar.value)

func _update_visuals(hp_value: float):
	var target_skin = ""
	
	if hp_value >= 67:
		target_skin = "level1"
	elif hp_value >= 34:
		target_skin = "level2"
	else:
		target_skin = "level3"
	
	if current_skin == target_skin:
		return
		
	var skeleton = get_skeleton()
	if skeleton:
		skeleton.set_skin_by_name(target_skin)
		skeleton.set_to_setup_pose()
		if current_skin != "" and phase_sound:
			print("Смена фазы: играю звук")
			phase_sound.play()
		
		current_skin = target_skin
		print("Фаза изменена на: ", target_skin)
