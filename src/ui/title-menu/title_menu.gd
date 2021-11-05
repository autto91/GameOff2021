class_name TitleMenu
extends Control

signal menu_selected(menu_option)

enum MenuSelect {
	LEVEL_DEBUG,
	LEVEL_ONE,
	QUIT,
}


func _ready() -> void:
	$CenterContainer/VBoxContainer/Play.grab_focus()


func _on_level_debug_pressed() -> void:
	emit_signal('menu_selected', MenuSelect.LEVEL_DEBUG)


func _on_level_one_pressed() -> void:
	emit_signal('menu_selected', MenuSelect.LEVEL_ONE)


func _on_quit_pressed() -> void:
	emit_signal('menu_selected', MenuSelect.QUIT)
