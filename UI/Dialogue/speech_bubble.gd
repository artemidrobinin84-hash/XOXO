extends Node2D

func set_text(new_text):
	print("alo")
	$NinePatchRect/Label.text = new_text
	#scale = Vector2.ZERO # Начинаем с нулевого размера
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position:y", position.y - 50, 0.3)
	await get_tree().create_timer(2.0).timeout
	queue_free()
