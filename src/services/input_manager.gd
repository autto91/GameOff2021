class_name InputManager
extends Node

const Test := 'hello'

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('g_quit'):
		get_tree().quit()
