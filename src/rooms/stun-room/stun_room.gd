class_name StunRoom
extends Node2D

export (NodePath) var player_ref
export (NodePath) var hud_ref

onready var signal_manager := $'/root/signal_manager'
onready var patch_group := $Patches
onready var enemy_group := $Enemies
onready var player: Player = get_node(player_ref)
onready var hud: GameHud = get_node(hud_ref)


func _ready() -> void:
	assert(player_ref != '', 'ERROR: {0} does not have a valid player reference'.format([name]))
	assert(hud_ref != '', 'ERROR: {0} does not have a valid GameHUD reference'.format([name]))

	signal_manager.connect_enemy_signals(player, enemy_group)
	signal_manager.connect_patch_signals(player, hud, patch_group)
