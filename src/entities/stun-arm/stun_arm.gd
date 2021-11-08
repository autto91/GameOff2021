class_name StunArm
extends Area2D

enum FireDirection {
	LEFT = 0,
	RIGHT = 1,
}

var is_firing := false

onready var coll_shape := $CollisionShape2D
onready var sprite := $Sprite
onready var fire_timer := $FireTimer


func fire(direction: int, pos = Vector2.ZERO) -> void:
	if not is_firing:
		match direction:
			FireDirection.LEFT:
				sprite.flip_h = false
			FireDirection.RIGHT:
				sprite.flip_h = true

		is_firing = true
		position = pos
		_toggle_enabled()
		fire_timer.start()


func _toggle_enabled() -> void:
	sprite.visible = true
	coll_shape.disabled = false


func _toggle_disabled() -> void:
	sprite.visible = false
	coll_shape.disabled = true


func _ready() -> void:
	_toggle_disabled()


func _on_fire_timeout() -> void:
	_toggle_disabled()
	is_firing = false
