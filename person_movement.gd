extends KinematicBody2D

const max_health = 3

export (float) var speed = 250
export (float) var frictional_damping = 0.3
var velocity = Vector2()
var accel = Vector2()
var facing_down = true
var facing_right = true
var idle = true
var hit_force = 8 # amount of force applied when hit
var invincibility_time = 1.5
var invincibility_clock

func _ready():
	global.lives = max_health
	$"../canvas/hud".set_health(global.lives)
	invincibility_clock = invincibility_time

func get_hit(hitter_pos):
	if invincibility_clock < invincibility_time:
		return
	
	if global.lives == 0: # 0 lives left
		get_tree().change_scene("deathscreen.tscn")
	invincibility_clock = 0
	var push_force = (hitter_pos - position).normalized() * -hit_force
	accel += push_force
	global.lives -= 1
	$"../canvas/hud".set_health(global.lives)
	$Camera2D.shake(0.4, 18, 19)

func _physics_process(delta):
	accel = Vector2()
	idle = true
	if Input.is_action_pressed("player_up"):
		accel.y -= 1
		facing_down = false
		idle = false
	if Input.is_action_pressed("player_down"):
		accel.y += 1
		facing_down = true
		idle = false
	if Input.is_action_pressed("player_left"):
		accel.x -= 1
		facing_right = false
		idle = false
	if Input.is_action_pressed("player_right"):
		accel.x += 1
		facing_right = true
		idle = false
	accel = accel.normalized() * frictional_damping
	
	if invincibility_clock > invincibility_time:
		for body in $hitarea.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				if !body.dead:
					get_hit(body.position)
					break
				
	invincibility_clock += delta
	
	velocity += accel * speed
	velocity *= 0.8
	velocity = move_and_slide(velocity)
	
	if idle:
		if facing_down:
			$AnimatedSprite.animation = "idle_down"
		else:
			$AnimatedSprite.animation = "idle_up"
	else:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = !facing_right
		
	$stunnedsprite.visible = invincibility_clock <= invincibility_time
	var tile_pos = $"../TileMap".world_to_map(position) / 8
	tile_pos.x = floor(tile_pos.x)
	tile_pos.y = floor(tile_pos.y)
	var tile_id = $"../TileMap".get_cellv(tile_pos)
	
	if tile_id == 24:
		$"../".nextlevel()
