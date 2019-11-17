extends Node2D

var shown = false

func _ready():
	pass
	
func _process(delta):
	var tile_pos = $TileMap.world_to_map($person.position) / 8
	tile_pos.x = floor(tile_pos.x)
	tile_pos.y = floor(tile_pos.y)
	
	if !shown:
		var complete = true
		
		for N in get_children():
			if N.is_in_group("enemies"):
				complete = false
				break
		
		if complete:
			$TileMap.set_cell(13, 6, 24)
			shown = true
			
func nextlevel():
	get_tree().change_scene("res://level3.tscn")