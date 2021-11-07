class_name StunArea
extends Area2D

enum FireDirection {
	LEFT = 0,
	RIGHT = 1,
}

var is_firing := false

onready var timer := $FireTimer


func fire(offset = Vector2.ZERO):
	if not is_firing:
		is_firing = true
		position += offset
		pause_mode = Node.PAUSE_MODE_PROCESS
		timer.start()


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_STOP


func _on_timer_timeout() -> void:
	is_firing = false
	position = Vector2.ZERO
	pause_mode = Node.PAUSE_MODE_STOP
