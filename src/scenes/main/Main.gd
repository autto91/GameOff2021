class_name Main
extends Node


func _ready() -> void:
	yield(get_tree().create_timer(2.0), 'timeout')
	var _scene := get_tree().change_scene("res://levels/Debug.tscn")
