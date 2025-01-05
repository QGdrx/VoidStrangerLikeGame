extends Node2D

@onready var tile_map = $"../TileMap"
@onready var anim = $AnimationPlayer
@onready var sprite = $SpritePlayer
@onready var Mecanics = get_node("../../Stage%d" % Global.current_Stage)

func move_and_animate(direction : Vector2i, tile : Vector2i) :
	
	global_position = tile_map.map_to_local(tile)
	
	
	if (direction == Vector2i (0, -1)) :
		anim.play("Idle_up")
		sprite.flip_h = false
		
	elif (direction == Vector2i (0, 1)) :
		anim.play("Idle_down")
		sprite.flip_h = false
		
	elif (direction == Vector2i (-1, 0)) :
		anim.play("Idle_right")
		sprite.flip_h = true
		
	elif (direction == Vector2i (1, 0)) :
		anim.play("Idle_right")
		sprite.flip_h = false


func player_death () :
	Mecanics.set_process(false)
	$Death.play()
	anim.play("Death")
	await anim.animation_finished
	var current_stage =load("res://Stages/Stage%d.tscn" % Global.current_Stage)
	SceneTransition.change_scene_to(current_stage)
