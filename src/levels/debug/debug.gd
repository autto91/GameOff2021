class_name Debug
extends Node

onready var player := $Player
onready var enemy_group := $Enemies


func _connect_enemy_hit_signals() -> void:
	var enemies := enemy_group.get_children()
	for enemy in enemies:
		enemy.connect('hit_player', player, '_on_player_hit')


func _ready() -> void:
	_connect_enemy_hit_signals()
