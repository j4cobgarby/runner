extends Control

func _ready():
	global.score = 0
	$"container1/score".text = "SCORE - " + str(global.score)
	
func set_health(health):
	$"container1/life".text = "LIVES - " + str(health)
	
func add_score(inc):
	global.score += inc
	$"container1/score".text = "SCORE - " + str(global.score)