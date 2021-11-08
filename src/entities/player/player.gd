class_name Player
extends KinematicBody2D

signal player_damaged

enum PatchType {
	DOUBLE_JUMP = 0,
	STUN_ARM = 1,
}

enum MoveDirection {
	NONE = 0,
	RIGHT = 1,
	LEFT = -1,
}

enum FacingDirection {
	LEFT = 0,
	RIGHT = 1,
}


const gravity := 1000
const walk_speed := 200
const run_speed := 400
const jump_speed := 400
const acceleration := 0.25
const friction := 0.5
const coyote_time := 0.1

var facing_state: int = FacingDirection.RIGHT
var player_lives := 3
var velocity := Vector2.ZERO
var jump_num := 0
var has_coyote_time := true
var is_vulnerable := true

var patch_state = {
	PatchType.DOUBLE_JUMP: {
		'enabled': false,
		'collected': false
	},
	PatchType.STUN_ARM: {
		'enabled': false,
		'collected': false
	}
}

onready var damage_timer := $DamageTimer
onready var stun_area := $StunArea


func _can_double_jump() -> bool:
	return patch_state[PatchType.DOUBLE_JUMP]['enabled'] and not patch_state[PatchType.STUN_ARM]['enabled']


func _can_high_jump() -> bool:
	return not _can_double_jump() and patch_state[PatchType.STUN_ARM]['enabled']


func _handle_direction_input() -> void:
	var dir = MoveDirection.NONE

	# Disable moving left unless we have double jump
	if Input.is_action_pressed('p_left') and patch_state[PatchType.DOUBLE_JUMP]['enabled']:
		dir += MoveDirection.LEFT
		facing_state = FacingDirection.LEFT
	if Input.is_action_pressed('p_right'):
		dir += MoveDirection.RIGHT
		facing_state = FacingDirection.RIGHT

	if dir != 0:
		var speed: int
		if Input.is_action_pressed('p_run'):
			speed = run_speed
		else:
			speed = walk_speed

		# dampen left/right movement when midair high jump
		if not is_on_floor() and _can_high_jump():
			velocity.x = lerp(velocity.x, dir * (speed * 0.5), acceleration)
		else:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)


func _handle_jump(delta: float) -> void:
	var jump_speed_multiplier := 1
	if _can_high_jump():
		jump_speed_multiplier = 2

	if Input.is_action_just_pressed('p_jump') and has_coyote_time:
		if jump_num == 0:
			velocity.y = -jump_speed * jump_speed_multiplier
			jump_num += 1

	if Input.is_action_just_pressed('p_jump') and not has_coyote_time and not is_on_floor() and _can_double_jump():
		if jump_num == 1:
			velocity.y = -jump_speed * jump_speed_multiplier
			jump_num += 1

	velocity.y += gravity * delta

	if Input.is_action_just_released('p_jump') and velocity.y < 0:
		velocity.y = 0


func _handle_action() -> void:
	if Input.is_action_pressed('p_fire') and patch_state[PatchType.STUN_ARM]['enabled']:
		match facing_state:
			FacingDirection.LEFT:
				stun_area.fire(Vector2(-32, 0), FacingDirection.LEFT)
			FacingDirection.RIGHT:
				stun_area.fire(Vector2(32, 0), FacingDirection.RIGHT)


func _handle_coyote_time() -> void:
	yield(get_tree().create_timer(coyote_time), 'timeout')
	has_coyote_time = false


func _process(_delta: float) -> void:
	_handle_action()


func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_num = 0

	_handle_direction_input()

	if is_on_floor():
		has_coyote_time = true
	else:
		_handle_coyote_time()

	_handle_jump(delta)

	velocity = move_and_slide(velocity, Vector2.UP)


func _on_patch_collected(patch_type: int) -> void:
	match patch_type:
		PatchType.DOUBLE_JUMP:
			patch_state[PatchType.DOUBLE_JUMP]['collected'] = true
			patch_state[PatchType.DOUBLE_JUMP]['enabled'] = true
		PatchType.STUN_ARM:
			patch_state[PatchType.STUN_ARM]['collected'] = true
			patch_state[PatchType.STUN_ARM]['enabled'] = true


func _on_player_hit() -> void:
	if is_vulnerable:
		emit_signal('player_damaged')

		player_lives -= 1
		is_vulnerable = false
		damage_timer.start()

		if player_lives <= 0:
			# TODO: hanlde death/reset of game
			queue_free()


func _on_damage_timer_timeout() -> void:
	is_vulnerable = true


func _on_stun_area_body_entered(body: Node) -> void:
	if body.name.begins_with('Enemy') or body.name.begins_with('enemy'):
		body.queue_free()


func _on_hud_patch_toggled(patch_type: int, enabled: bool) -> void:
	patch_state[patch_type]['enabled'] = enabled
