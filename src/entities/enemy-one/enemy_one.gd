class_name EnemyOne
extends KinematicBody2D

signal hit_player

export (float) var edge_timeout := 0.5
export (int) var speed := 50

enum MoveDirection {
	LEFT = 1,
	RIGHT = -1,
}

const gravity := 1000
const acceleration := 0.25

var velocity = Vector2.ZERO
var direction: int

onready var right_edge := $RightEdge
onready var left_edge := $LeftEdge
onready var animated_sprite := $AnimatedSprite
onready var stun_timer := $StunTimer

var left_edge_elapsed := 0.0
var right_edge_elapsed := 0.0

var left_edge_flipped := false
var right_edge_flipped := false
var is_stunned := false


func stun() -> void:
	is_stunned = true
	animated_sprite.play('hurt')
	stun_timer.start()


func _ready() -> void:
	randomize()
	var move_left := true
	if randi() % 2:
		move_left = false

	if move_left:
		direction = MoveDirection.LEFT
	else:
		direction = MoveDirection.RIGHT

	animated_sprite.play('walk')


func _process(delta: float) -> void:
	# Handle Delayed trigger without pausing the node process
	if left_edge_flipped:
		left_edge_elapsed += delta
		if left_edge_elapsed > edge_timeout:
			left_edge_elapsed = 0
			left_edge.position.x *= -1
			left_edge_flipped = false

	if right_edge_flipped:
		right_edge_elapsed += delta
		if right_edge_elapsed > edge_timeout:
			right_edge_elapsed = 0
			right_edge.position.x *= -1
			right_edge_flipped = false

	if direction == MoveDirection.LEFT:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false



func _physics_process(delta: float) -> void:
	if not is_stunned:
		if is_on_floor():
			velocity.x = lerp(velocity.x, direction * speed, acceleration)

		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_wall():
		direction *= -1
	elif is_on_floor() and not left_edge.is_colliding():
		direction *= -1
		left_edge.position.x *= -1
		left_edge_flipped = true
	elif is_on_floor() and not right_edge.is_colliding():
		direction *= -1
		right_edge.position.x *= -1
		right_edge_flipped = true


func _on_attack_area_entered(body: Node) -> void:
	if body.name == 'Player' and not is_stunned:
		emit_signal('hit_player')


func _on_stun_timeout() -> void:
	is_stunned = false
	animated_sprite.play('walk')
