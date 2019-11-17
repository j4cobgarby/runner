extends Control

func _ready():
	pass

func _input(ev):
	if ev is InputEventKey:
		get_tree().change_scene("mainmenu.tscn")