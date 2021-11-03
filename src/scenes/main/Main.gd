class_name Main
extends Node


func _ready() -> void:
	yield(get_tree().create_timer(0.5), 'timeout')
	var _scene := get_tree().change_scene("res://levels/Debug.tscn")
