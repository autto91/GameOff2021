class_name SignalManager
extends Node


static func connect_enemy_signals(player: Player, enemy_group: Node2D) -> void:
	var enemies := enemy_group.get_children()
	for enemy in enemies:
		enemy.connect('hit_player', player, '_on_player_hit')


static func connect_patch_signals(player: Player, hud: GameHud, patch_group: Node2D) -> void:
	var patches := patch_group.get_children()
	for patch in patches:
		patch.connect('patch_collected', player, '_on_patch_collected')
		patch.connect('patch_collected', hud, '_on_patch_collected')
