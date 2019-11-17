extends Node2D

var velocity = Vector2(2, 0)
var ttl = 10
var lifetime = 0

func _ready():
	pass

func _process(delta):
	lifetime += delta
	if lifetime >= ttl:
		queue_free()
	position += velocity
	
func get_area():
	return $hitarea