class_name GameHud
extends Control

signal patch_toggled(patch_type, enabled)

export (Texture) var patch_pip_default: Texture
export (Texture) var patch_pip_active: Texture
export (Texture) var patch_pip_selected: Texture

enum PatchType {
	DOUBLE_JUMP = 0,
	STUN_ARM = 1,
}

onready var select_timer := $SelectTimer
onready var wait_timer := $WaitTimer

onready var health_pip_one := $HealthMeter/Pips/PipOne
onready var health_pip_two := $HealthMeter/Pips/PipTwo
onready var health_pip_three := $HealthMeter/Pips/PipThree

onready var double_jump_pip := $Patches/HBoxContainer/DoubleJumpPip
onready var stun_arm_pip := $Patches/HBoxContainer/StunArmPip

onready var win_label := $WinLabel

var patch_last_selected: int = PatchType.DOUBLE_JUMP

var patch_state = {
	PatchType.DOUBLE_JUMP: {
		'collected': false,
		'enabled': false,
		'selected': false
	},
	PatchType.STUN_ARM: {
		'collected': false,
		'enabled': false,
		'selected': false
	}
}


func toggle_win() -> void:
	win_label.visible = true
	get_tree().paused = true


func _deselect_patch_texture(patch_pip: TextureRect, patch_type: int) -> void:
	patch_pip.texture = patch_pip_default if not patch_state[patch_type]['enabled'] else patch_pip_active


func _toggle_selected() -> void:
	patch_state[patch_last_selected]['enabled'] = !patch_state[patch_last_selected]['enabled']

	match patch_last_selected:
		PatchType.DOUBLE_JUMP:
			_deselect_patch_texture(double_jump_pip, patch_last_selected)
		PatchType.STUN_ARM:
			_deselect_patch_texture(stun_arm_pip, patch_last_selected)

	emit_signal('patch_toggled', patch_last_selected, patch_state[patch_last_selected]['enabled'])


func _tick_selected() -> void:
	if patch_last_selected >= 1:
		patch_last_selected = 0
	else:
		patch_last_selected += 1

	if patch_last_selected == PatchType.DOUBLE_JUMP and patch_state[PatchType.DOUBLE_JUMP]['collected']:
		patch_state[PatchType.DOUBLE_JUMP]['selected'] = true
		double_jump_pip.texture = patch_pip_selected

		patch_state[PatchType.STUN_ARM]['selected'] = false
		_deselect_patch_texture(stun_arm_pip, PatchType.STUN_ARM)
	elif patch_last_selected == PatchType.STUN_ARM and patch_state[PatchType.STUN_ARM]['collected']:
		patch_state[PatchType.STUN_ARM]['selected'] = true
		stun_arm_pip.texture = patch_pip_selected

		patch_state[PatchType.DOUBLE_JUMP]['selected'] = false
		_deselect_patch_texture(double_jump_pip, PatchType.DOUBLE_JUMP)


func _ready() -> void:
	win_label.visible = false

	double_jump_pip.texture = patch_pip_default
	double_jump_pip.visible = false

	stun_arm_pip.texture = patch_pip_default
	stun_arm_pip.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('h_patch_cycle'):
		wait_timer.start()
		_tick_selected()
	if event.is_action_pressed('h_patch_select'):
		_toggle_selected()


func _on_player_damaged() -> void:
	if health_pip_three.visible:
		health_pip_three.visible = false
	elif health_pip_two.visible:
		health_pip_two.visible = false
	elif health_pip_one.visible:
		health_pip_one.visible = false


func _on_patch_collected(patch_type: int) -> void:
	match patch_type:
		PatchType.DOUBLE_JUMP:
			patch_state[PatchType.DOUBLE_JUMP]['collected'] = true
			patch_state[PatchType.DOUBLE_JUMP]['enabled'] = true

			double_jump_pip.texture = patch_pip_active
			double_jump_pip.visible = true

		PatchType.STUN_ARM:
			patch_state[PatchType.STUN_ARM]['collected'] = true
			patch_state[PatchType.STUN_ARM]['enabled'] = true

			stun_arm_pip.texture = patch_pip_active
			stun_arm_pip.visible = true


func _on_select_timeout() -> void:
	match patch_last_selected:
		PatchType.DOUBLE_JUMP:
			_deselect_patch_texture(double_jump_pip, patch_last_selected)
		PatchType.STUN_ARM:
			_deselect_patch_texture(stun_arm_pip, patch_last_selected)


func _on_timeout() -> void:
	select_timer.start()
