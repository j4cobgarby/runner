extends KinematicBody2D

var aim = "idle" # What the slime's goal is
var state = "still" # What it's actually doing (e.g. still, jumping, ..)
var target_position = Vector2() # Where it wants to go
var jumped_from = Vector2() # where it jumped from
var time_since_last_jump
var time_spent_jumping
var m
var dmg = 1
var dead = false

const jump_cooldown = 2 # minimum time between jumps
const target_distance = 20 # distance where slime is "at" target
const max_jump_distance = 200
const jump_speed = 300

func _init():
	randomize()
	time_since_last_jump = rand_range(0, jump_cooldown)
	add_to_group("enemies")

func die():
	$sprite.animation = "melt"
	dead = true
	$"../canvas/hud".add_score(300)

func _physics_process(delta):
	if !get_parent().has_node("person"):
		print("No `person` node!!")
		return
	
	$"shadow".visible = state == "jumping"
	
	if dead && $sprite.frame == 5:
		queue_free()
	
	if !dead:
		if state == "still":
			# first, check if dead
			var tile_pos = $"../TileMap".world_to_map(position) / 8
			tile_pos.x = floor(tile_pos.x)
			tile_pos.y = floor(tile_pos.y)
			var tile_id = $"../TileMap".get_cellv(tile_pos)
			
			if tile_id == 5:
				print("DIE!")
				die()
	
		# Only update target position if currently on ground (not jumping)
		# also if the cooldown has expired, otherwise there's no point
		if state == "still" and time_since_last_jump >= jump_cooldown:
			target_position = position + (($"../person".position - position).normalized() * max_jump_distance)
			m = ((position.distance_to(target_position))/jump_speed)/2 # m is the radius of the circle
			state = "jumping"
			time_since_last_jump = 0
			time_spent_jumping = 0
			
		if state == "jumping":
			var dist_to = position.distance_to(target_position)
			
			move_and_slide((target_position - position).normalized() * jump_speed)
			
			var x = time_since_last_jump
			$"sprite".position.y = -pow(m*m - pow(x-m, 2), 0.5) * 150
			
			if time_spent_jumping > m*2:
				state = "still"
				$"sprite".position.y = 0
			time_spent_jumping += delta
		time_since_last_jump += delta