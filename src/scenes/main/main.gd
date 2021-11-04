class_name Main
extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('m_start'):
		var _scene = get_tree().change_scene("res://levels/Debug.tscn")
