extends Node

@onready var tile_map =  get_node("../Stage%d/TileMap" % Global.current_Stage)
@onready var Player = get_node("../Stage%d/Player" % Global.current_Stage)
@onready var Stage1 = get_node("../Stage%d" % Global.current_Stage)

@onready var c_tile  : Vector2i = Vector2i(0,0)
@onready var c_tile_data : TileData
@onready var i_tile : Vector2i
@onready var i_tile_data : TileData

func _ready() :
	if (Global.current_Stage == 0 ) :
		$Stage0theme.play()

func _process(_void):
	
	if Input.is_action_just_pressed("Up") :
		Info_tiles(Vector2i (0, -1))
		
	elif Input.is_action_just_pressed("Down") :
		Info_tiles(Vector2i (0, 1))
		
	elif Input.is_action_just_pressed("Left") :
		Info_tiles(Vector2i (-1, 0))
		
	elif Input.is_action_just_pressed("Right") :
		Info_tiles(Vector2i (1, 0))
		
	#elif Input.is_action_just_pressed("Menu") :
		#get_tree().change_scene_to_file("res://Menus/Menu.tscn")
	
# 
func Info_tiles(direction : Vector2i):
	
	# Where the player is
	c_tile = tile_map.local_to_map(Player.global_position)
	c_tile_data = tile_map.get_cell_tile_data(0,c_tile)
	
	# Where the player wants to go
	i_tile = Vector2i(c_tile.x + direction.x, c_tile.y + direction.y)
	
	# Data of the inputed tile 
	i_tile_data = tile_map.get_cell_tile_data(0,i_tile)
	
	# Can the player go to the inputed tile
	if i_tile_data.get_custom_data("Walkable") == false :
		i_tile = c_tile
		i_tile_data = c_tile_data
		print ("You can't go there")
		return
	
	# If the player can go to the tile, then update the tile according to its type
	i_UpdateTile (i_tile, i_tile_data)
	
	# Move the player and update monsters positions
	Player.move_and_animate(direction, i_tile)
	
	# Then update the current tile
	c_UpdateTile(c_tile, i_tile, c_tile_data)
	
	

# Function that updates the tile the entity is on according to its nature
func c_UpdateTile (tile : Vector2i, next_tile : Vector2i, data : TileData) :

	if (next_tile != tile) :
		
		# the tile is a pressed button
		if data.get_custom_data("is_pressed_button") :
			
			# if the player is not going to the button tile
			if (i_tile != tile) :
				tile_map.set_cell(0, tile, 2, Vector2i(0,0))
				tile_map.set_cell(0, Global.stair_coords, 13, Vector2i(0,0))
				
			# if the player is going to the button tile
			if (i_tile == tile) :
				get_node("../Stage%d/ButtonSound" % Global.current_Stage).play()
				tile_map.set_cell(0, Global.stair_coords, 0, Vector2i(0,0))

		# The tile is made of glass
		if data.get_custom_data("is_glass") :
			tile_map.set_cell(0, tile, 9, Vector2i(0,0))
	

# Function that updates the tile to which the entity is moving according to its nature
func i_UpdateTile (tile : Vector2i, data : TileData) :
	
	
	if (Global.current_Stage == 5) :
		Global.stair_coords = Vector2i(6,1)
	if (Global.current_Stage == 6) :
		Global.stair_coords = Vector2i(8,1)
		
		
	# The tile is a button
	if data.get_custom_data("is_button") :
		tile_map.set_cell(0, tile, 3, Vector2i(0,0))
		get_node("../Stage%d/ButtonSound" % Global.current_Stage).play()
		tile_map.set_cell(0, Global.stair_coords, 0, Vector2i(0,0))
		
		
	#The tile is a stair
	if data.get_custom_data("is_stair") :
		Global.has_Player_finished_current_stage = true
		$StageCompleted.play()
		set_process(false)
		# Cette ligne ne sert à rien
		#set_process_input(false)
		Global.current_Stage = Global.current_Stage + 1
		var Next_stage =load("res://Stages/Stage%d.tscn" % Global.current_Stage)
		SceneTransition.change_scene_to(Next_stage)
		
	# The tile is glass
	if data.get_custom_data("is_glass") :
		get_node("../Stage%d/GlassSound" % Global.current_Stage).play()
