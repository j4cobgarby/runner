extends Node2D

var tex_closed = preload("res://exit.png")
var tex_open = preload("res://staircase.png")

func _ready():
	$sprite.set_texture(tex_closed)
