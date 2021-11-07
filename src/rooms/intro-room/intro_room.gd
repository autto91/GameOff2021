class_name IntroRoom
extends Node2D


export (NodePath) var player_ref

onready var signal_manager := $'/root/signal_manager'
onready var patch_group := $Patches
onready var player: Player = get_node(player_ref)


func _ready() -> void:
	assert(player_ref != '', 'ERROR: {0} does not have a valid player reference'.format([name]))
	signal_manager.connect_patch_signals(player, patch_group)
