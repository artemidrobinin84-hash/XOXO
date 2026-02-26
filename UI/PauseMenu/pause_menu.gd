class_name PauseMenu
extends CanvasLayer


func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_PAUSED:
			show()
		Node.NOTIFICATION_UNPAUSED:
			hide()
