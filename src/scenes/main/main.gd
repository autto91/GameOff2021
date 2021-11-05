class_name Main
extends Node

onready var title_menu := $TitleMenu


func _on_menu_option_selected(menu_option: int) -> void:
	match menu_option:
		title_menu.MenuSelect.LEVEL_DEBUG:
			get_tree().change_scene("res://levels/debug/Debug.tscn")

		title_menu.MenuSelect.LEVEL_ONE:
			get_tree().change_scene("res://levels/level-one/LevelOne.tscn")

		title_menu.MenuSelect.QUIT:
			get_tree().quit()
