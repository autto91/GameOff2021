class_name JumpRoom
extends Node2D

export (NodePath) var player_ref

onready var signal_manager := $'/root/signal_manager'
onready var patch_group := $Patches
onready var enemy_group := $Enemies
onready var player: Player = get_node(player_ref)


func _ready() -> void:
	signal_manager.connect_enemy_signals(player, enemy_group)
	signal_manager.connect_patch_signals(player, patch_group)
