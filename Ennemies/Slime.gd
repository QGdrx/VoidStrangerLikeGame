extends Node2D

@onready var Mecanics = get_node("../../Stage%d" % Global.current_Stage)
@onready var tile_map = $"../TileMap"
@onready var anim = $AnimationSlime
@onready var sprite = $SpriteSlime
var Movement : Vector2i 

@onready var Player = get_node("../Player")


# But de la fonction : indiquer quel est le mouvement réalisé par le joueur
func _process (_void): 
	
	if Input.is_action_just_pressed("Up"):
		Movement = Vector2i (0, -1)
		can_I_move(Movement)
		
	elif Input.is_action_just_pressed("Down"):
		Movement  = Vector2i (0, 1)
		can_I_move(Movement)

	elif Input.is_action_just_pressed("Left"):
		Movement = Vector2i (-1, 0)
		can_I_move(Movement)
		
	elif Input.is_action_just_pressed("Right"):
		Movement = Vector2i (1, 0)
		can_I_move(Movement)
		



func can_I_move(direction : Vector2i) :

	# Where the Slime is
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	
	# Where the Player wants to go
	var Player_target_tile : Vector2i = Vector2i(Mecanics.c_tile.x + direction.x, Mecanics.c_tile.y + direction.y)
	
	# Can the Player go there
	if Mecanics.i_tile_data.get_custom_data("Walkable") == false :
		return
	
	# Where the Slime wants to go
	var target_tile : Vector2i = current_tile
	var Slime_dir : Vector2i
	
	if (current_tile.x == Player_target_tile.x) :
		if (current_tile.y > Player_target_tile.y) :
			if (current_tile.y - 1 == Player_target_tile.y) :
				Slime_dir = Vector2i (0, -1)
				move_and_animate(target_tile, Slime_dir)
				set_process(false)
				Player.player_death()
				return
			target_tile = current_tile + Vector2i (0, -1)
			Slime_dir = Vector2i (0, -1)
		else :
			## rajouter une option quand le joueur va sur la case du slime, sinon le slime descent
			# ça marche mais le joueur fais quand même son action puis l'animation de mort
			if (current_tile.y == Player_target_tile.y) :
				Slime_dir = Vector2i (0, 1)
				move_and_animate(target_tile, Slime_dir)
				set_process(false)
				Player.player_death()
				return
				
			if (current_tile.y + 1 == Player_target_tile.y) :
				Slime_dir = Vector2i (0, 1)
				move_and_animate(target_tile, Slime_dir)
				set_process(false)
				Player.player_death()
				return
			target_tile = current_tile + Vector2i (0, 1)
			Slime_dir = Vector2i (0, 1)
	elif (current_tile.y == Player_target_tile.y) :
		if (current_tile.x > Player_target_tile.x) :
			if (current_tile.x - 1 == Player_target_tile.x) :
				Slime_dir = Vector2i (-1, 0)
				move_and_animate(target_tile, Slime_dir)
				set_process(false)
				Player.player_death()
				return
			target_tile = current_tile + Vector2i (-1, 0)
			Slime_dir = Vector2i (-1, 0)
		else :
			if (current_tile.x + 1 == Player_target_tile.x) :
				Slime_dir = Vector2i (1, 0)
				move_and_animate(target_tile, Slime_dir)
				set_process(false)
				Player.player_death()
				return
			target_tile = current_tile + Vector2i (1, 0)
			Slime_dir = Vector2i (1, 0)
	
	
	# Can the Slime go there
	var target_tile_data : TileData = tile_map.get_cell_tile_data(0, target_tile)
	if target_tile_data.get_custom_data("Walkable") == false :
		return
	
	Mecanics.i_UpdateTile (target_tile, target_tile_data)
	if (Global.has_Player_finished_current_stage == true) :
		set_process(false)
		return
	move_and_animate(target_tile, Slime_dir)
	Mecanics.c_UpdateTile(current_tile, target_tile, tile_map.get_cell_tile_data(0,current_tile))
	

func move_and_animate (tile : Vector2i, direction : Vector2i) :
	
	global_position = tile_map.map_to_local(tile)
	if (direction == Vector2i (0, -1)) :
		anim.play("Back")
	if (direction == Vector2i (0, 1)) :
		anim.play("Front")
	if (direction == Vector2i (-1, 0)) :
		anim.play("Left")
	if (direction == Vector2i (1, 0)) :
		anim.play("Right")
	
