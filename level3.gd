extends Node2D

var end_shown = false
var slime2_summoned = false
var door1_opened = false
var door2_opened = false
var door3_opened = false 

onready var slime_scene = preload("res://slime.tscn")

func _ready():
	pass
	
func _process(delta):
	var tile_pos = $TileMap.world_to_map($person.position) / 8
	tile_pos.x = floor(tile_pos.x)
	tile_pos.y = floor(tile_pos.y)
	
	if has_node("slime1"):
		if $slime1.dead and !slime2_summoned:
			var new_slime = slime_scene.instance()
			add_child(new_slime)
			new_slime.position = Vector2(254, 792)
			new_slime.set_name("slime2")
			slime2_summoned = true
			
	if has_node("slime2"):
		if $slime2.dead and !door1_opened:
			door1_opened = true
			$TileMap.set_cell(7, 8, 7)
			
	if has_node("slime4"):
		if $slime4.dead and !door2_opened:
			door2_opened = true
			$TileMap.set_cell(11, 3, 7)
	
	for N in get_children():
		if N.is_in_group("bullet_emitters"):
			for bullet in N.get_children():
				if bullet.get_area().overlaps_body($person):
					$person.get_hit(bullet.position)
					bullet.queue_free()
				for N2 in get_children():
					if N2.is_in_group("enemies"):
						if bullet.get_area().overlaps_body(N2):
							print("HIT")
							N2.die()
							bullet.queue_free()
	
	if !end_shown:
		var complete = true
		
		for N in get_children():
			if N.is_in_group("enemies"):
				complete = false
				break
		
		if complete:
			$TileMap.set_cell(12, 8, 24)
			end_shown = true
			
func nextlevel():
	get_tree().change_scene("res://mainmenu.tscn")