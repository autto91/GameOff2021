class_name GameHud
extends Control

onready var pip_one := $HealthMeter/Pips/PipOne
onready var pip_two := $HealthMeter/Pips/PipTwo
onready var pip_three := $HealthMeter/Pips/PipThree


func _on_player_damaged() -> void:
	if pip_three.visible:
		pip_three.visible = false
	elif pip_two.visible:
		pip_two.visible = false
	elif pip_one.visible:
		pip_one.visible = false
