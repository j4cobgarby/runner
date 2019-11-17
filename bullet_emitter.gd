extends Node2D

export (float) var shot_cooldown = 3
export (float) var bullet_ttl = 5
export (Vector2) var bullet_vel = Vector2(2, 0)

onready var bullet_scene = preload("res://bullet.tscn")

var time_since_shot

func _ready():
	time_since_shot = 0
	add_to_group("bullet_emitters")
	
func _process(delta):
	time_since_shot += delta
	
	if time_since_shot >= shot_cooldown:
		var new_child = bullet_scene.instance()
		new_child.velocity = bullet_vel
		new_child.ttl = bullet_ttl
		add_child(new_child)
		time_since_shot = 0
