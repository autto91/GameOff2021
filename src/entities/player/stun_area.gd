class_name StunArea
extends Area2D

enum FireDirection {
	LEFT = 0,
	RIGHT = 1,
}

var is_firing := false

onready var timer := $FireTimer
onready var sprite := $Sprite


func fire(offset = Vector2.ZERO, direction = 0):
	if not is_firing:
		if direction == 1:
			sprite.flip_h = true

		is_firing = true
		position += offset
		sprite.visible = true
		pause_mode = Node.PAUSE_MODE_PROCESS
		timer.start()


func _ready() -> void:
	sprite.visible = false
	pause_mode = Node.PAUSE_MODE_STOP


func _on_timer_timeout() -> void:
	is_firing = false
	sprite.visible = false
	sprite.flip_h = false
	position = Vector2.ZERO
	pause_mode = Node.PAUSE_MODE_STOP
