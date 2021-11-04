class_name Player
extends KinematicBody2D

enum PatchType {
	DOUBLE_JUMP = 0,
}

enum MoveDirection {
	NONE = 0,
	RIGHT = 1,
	LEFT = -1,
}


const gravity := 1000
const walk_speed := 200
const run_speed := 400
const jump_speed := 400
const acceleration := 0.25
const friction := 0.5
const coyote_time := 0.1

var velocity := Vector2.ZERO
var jump_num := 0
var has_coyote_time := true

var patch_state = {
	PatchType.DOUBLE_JUMP: {
		'enabled': false
	}
}


func _handle_direction_input() -> void:
	var dir = MoveDirection.NONE

	if Input.is_action_pressed('p_left'):
		dir += MoveDirection.LEFT
	if Input.is_action_pressed('p_right'):
		dir += MoveDirection.RIGHT

	if dir != 0:
		var speed: int
		if Input.is_action_pressed('p_run'):
			speed = run_speed
		else:
			speed = walk_speed

		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)


func _handle_jump(delta: float) -> void:
	if Input.is_action_just_pressed('p_jump') and has_coyote_time:
		if jump_num == 0:
			velocity.y = -jump_speed
			jump_num += 1

	if Input.is_action_just_pressed('p_jump') and not has_coyote_time and not is_on_floor() and patch_state[PatchType.DOUBLE_JUMP]['enabled']:
		if jump_num == 1:
			velocity.y = -jump_speed
			jump_num += 1

	velocity.y += gravity * delta

	if Input.is_action_just_released('p_jump') and velocity.y < 0:
		velocity.y = 0


func _handle_coyote_time() -> void:
	yield(get_tree().create_timer(coyote_time), 'timeout')
	has_coyote_time = false


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
			patch_state[PatchType.DOUBLE_JUMP]['enabled'] = true
