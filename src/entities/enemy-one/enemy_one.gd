class_name EnemyOne
extends KinematicBody2D

const gravity := 1000

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
