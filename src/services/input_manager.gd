class_name InputManager
extends Node


func _ready() -> void:
	# Keep global inputs listening while game is paused
	pause_mode = Node.PAUSE_MODE_PROCESS


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('g_quit'):
		get_tree().quit()
