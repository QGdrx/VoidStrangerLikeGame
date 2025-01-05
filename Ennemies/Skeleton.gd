extends Node2D

@onready var Mecanics = get_node("../../Stage%d" % Global.current_Stage)
@onready var tile_map = $"../TileMap"
@onready var anim = $AnimationSkeleton
@onready var sprite = $SpriteSkeleton
var Movement : Vector2i 

var Gap : int = 0;
var Coord_stocked : Vector2i = Vector2i(0,0)


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
	


# Revoir cette fonction car elle ne fonctionne pas comme prévue au niveau de quand le joueur décède
func can_I_move(direction : Vector2i) :

	# Where the Skeleton is
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	
	# Where the Player wants to go
	var Player_target_tile : Vector2i = Vector2i(Mecanics.c_tile.x + direction.x, Mecanics.c_tile.y + direction.y)
	
	# Can the player go there
	if Mecanics.i_tile_data.get_custom_data("Walkable") == false :
		return
	
	# Where the Skeleton wants to go
	var target_tile : Vector2i = current_tile
	var Skeleton_dir : Vector2i

	if (Gap != 0) :
		if (current_tile.x == Coord_stocked.x) :
			if (Gap > 0) :
				target_tile = target_tile + Vector2i (0, -1)
				Skeleton_dir = Vector2i (0, -1)
				Gap = Gap -1
			else :
				target_tile = target_tile + Vector2i (0, 1)
				Skeleton_dir = Vector2i (0, 1)
				Gap = Gap +1
			
			if (target_tile == Player_target_tile) :
					set_process(false)
					Player.player_death()
					return
			if (Player_target_tile == current_tile):
					Player.global_position = tile_map.map_to_local(Player_target_tile + Skeleton_dir)
					set_process(false)
					Player.player_death()
					return
		elif (current_tile.y == Coord_stocked.y) :
			if (Gap > 0) :
				target_tile = target_tile + Vector2i (-1, 0)
				Skeleton_dir = Vector2i (-1, 0)
				Gap = Gap -1
			else :
				target_tile = target_tile + Vector2i (1, 0)
				Skeleton_dir = Vector2i (1, 0)
				Gap = Gap +1

			if (target_tile == Player_target_tile) :
				set_process(false)
				Player.player_death()
				return
			if (Player_target_tile == current_tile):
				Player.global_position = tile_map.map_to_local(Player_target_tile + Skeleton_dir)
				set_process(false)
				Player.player_death()
				return
	else :
		Coord_stocked = Player_target_tile
		if (current_tile.x == Coord_stocked.x) :
			Gap = current_tile.y - Coord_stocked.y
			if (Gap > 0) :
				target_tile = target_tile + Vector2i (0, -1)
				Skeleton_dir = Vector2i (0, -1)
				Gap = Gap -1
			else :
				target_tile = target_tile + Vector2i (0, 1)
				Skeleton_dir = Vector2i (0, 1)
				Gap = Gap +1
		if (target_tile == Player_target_tile) :
			set_process(false)
			Player.player_death()
			return
		if (Player_target_tile == current_tile):
			Player.global_position = tile_map.map_to_local(Player_target_tile + Skeleton_dir)
			set_process(false)
			Player.player_death()
			return
					
		elif (current_tile.y == Coord_stocked.y) :
			Gap = current_tile.x - Coord_stocked.x
			if (Gap > 0) :
				target_tile = target_tile + Vector2i (-1, 0)
				Skeleton_dir = Vector2i (-1, 0)
				Gap = Gap -1
			else :
				target_tile = target_tile + Vector2i (1, 0)
				Skeleton_dir = Vector2i (1, 0)
				Gap = Gap +1
		if (target_tile == Player_target_tile) :
			set_process(false)
			Player.player_death()
			return
		if (Player_target_tile == current_tile):
			Player.global_position = tile_map.map_to_local(Player_target_tile + Vector2i (-1, 0))
			set_process(false)
			Player.player_death()
			return
	
	# Can the Skeleton go there
	var target_tile_data : TileData = tile_map.get_cell_tile_data(0, target_tile)
	if target_tile_data.get_custom_data("Walkable") == false :
		Gap = 0
		return
		
	Mecanics.i_UpdateTile (target_tile, target_tile_data)
	if (Global.has_Player_finished_current_stage == true) :
		set_process(false)
		return
	move_and_animate(target_tile, Skeleton_dir)
	Mecanics.c_UpdateTile(current_tile, target_tile, tile_map.get_cell_tile_data(0,current_tile))
	

#func set_player_for_death(skeleton_current_tile : Vector2i, skeleton_next_tile : Vector2i, Player_target_tile : Vector2i, direction : Vector2i) :
	






func move_and_animate (tile : Vector2i, _direction : Vector2i) :
	
	global_position = tile_map.map_to_local(tile)
	#if (direction == Vector2i (0, -1)) :
		#anim.play("Back")
	#if (direction == Vector2i (0, 1)) :
		#anim.play("Front")
	#if (direction == Vector2i (-1, 0)) :
		#anim.play("Left")
	#if (direction == Vector2i (1, 0)) :
		#anim.play("Right")
	#
