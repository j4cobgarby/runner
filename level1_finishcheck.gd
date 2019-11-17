extends Node2D

var shown = false

func _ready():
	pass
	
func _process(delta):
	if !shown:
		var complete = true
		
		for N in get_children():
			if N.is_in_group("enemies"):
				complete = false
				break
		
		if complete:
			$TileMap.set_cell(8, 1, 24)
			shown = true
			
func nextlevel():
	get_tree().change_scene("res://level2.tscn")