class_name JumpRoom
extends Node2D

export (NodePath) var player_ref

onready var signal_manager := $'/root/signal_manager'
onready var enemy_group := $Enemies
onready var player: Player = get_node(player_ref)


func _ready() -> void:
	assert(player_ref != '', 'ERROR: {0} does not have a valid player reference'.format([name]))

	signal_manager.connect_enemy_signals(player, enemy_group)
