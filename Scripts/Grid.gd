extends TileMap
# Collection of functions to work with a Grid. Stores all its children in the grid array

enum {EMPTY, CROSSHAIR, OBSTACLE, COLLECTIBLE} 

var COLUMNS = Global.COLUMNS #Assigns global constant COLUMNS
var ROWS = Global.ROWS #Assigns global constant ROWS
var crosshair_pos

var tile_size = get_cell_size() #16by16
var half_tile_size = tile_size / 2 #8by8
var grid_size = Vector2(COLUMNS, ROWS) #vector2 containing COLOUMNS by ROWS

var grid = [] #Creates grid array


onready var place = $Place
onready var Crosshair = preload("res://Scenes/Crosshair.tscn") #Preloads crosshair scene
onready var P1Counter = preload("res://Scenes/Counters/P1Counter.tscn") #Preloads p1Counter scene
onready var P2Counter = preload("res://Scenes/Counters/P2Counter.tscn") #Preloads p2Counter scene
onready var NeutralCounter = preload("res://Scenes/Counters/NeutralCounter.tscn")
onready var laser = preload("res://Scenes/Effects/Laser.tscn")
onready var blitz = preload("res://Scenes/Effects/Blitz.tscn")
onready var sword = preload("res://Scenes/Effects/Sword.tscn")
onready var star = preload("res://Scenes/Effects/Star.tscn")

#Global Variables
const Crosshair_STARTPOS = Vector2(4,4) #Assigns the starting point for the crosshair 
var target_pos
var positions
var board


func _ready():
	Global.connect("game_over", self, "reset")
# warning-ignore:return_value_discarded
	Global.connect("destroy_counter", self, "destory_child_pos")
# warning-ignore:return_value_discarded
	Global.connect("place_counter", self, "place_item")
# warning-ignore:return_value_discarded
	Global.connect("skill_1", self, "skill_1_effects")
	Global.connect("skill_2", self, "skill_2_effects")
	grid = []
	for x in range(grid_size.x):
		grid.append([])
		for _y in range(grid_size.y):
			grid[x].append(EMPTY)
	# Crosshair
	var new_Crosshair = Crosshair.instance()
	new_Crosshair.position = map_to_world(Crosshair_STARTPOS) + half_tile_size
#	grid[Crosshair_STARTPOS.x][Crosshair_STARTPOS.y] = CROSSHAIR
	add_child(new_Crosshair)

func _physics_process(_delta):
	target_pos = Global.target_pos
	crosshair_pos = Global.crosshair
	board = Global.board
	positions = Global.positions
	

func destory_child_pos(t):
	grid[t.x][t.y] = EMPTY
	if self.has_node(str(t.x) + str(t.y)):
		self.get_node(str(t.x) + str(t.y)).death()
	place_item()

func place_item():
	for pos in positions:
		var new_counter
		
		if !self.has_node(str(pos.x) + str(pos.y)):
			if board[pos.y][pos.x] == 1:
				new_counter = P1Counter.instance()
				new_counter.position = map_to_world(pos) + half_tile_size
				new_counter.z_index = pos.y
				new_counter.name = str(pos.x) + str(pos.y)
				grid[pos.x][pos.y] = OBSTACLE
				add_child(new_counter)
			elif board[pos.y][pos.x] == 2: 
				new_counter = P2Counter.instance()
				new_counter.position = map_to_world(pos) + half_tile_size
				new_counter.z_index = pos.y
				new_counter.name = str(pos.x) + str(pos.y)
				grid[pos.x][pos.y] = OBSTACLE
				add_child(new_counter)
			elif board[pos.y][pos.x] == 3: 
				new_counter = NeutralCounter.instance()
				new_counter.position = map_to_world(pos) + half_tile_size
				new_counter.z_index = pos.y
				new_counter.name = str(pos.x) + str(pos.y)
				grid[pos.x][pos.y] = OBSTACLE
				add_child(new_counter)
			place.play()

# Check if cell at direction is vacant
func is_cell_vacant(this_grid_pos=Vector2(), direction=Vector2()):
	var target_grid_pos = world_to_map(this_grid_pos) + direction

	# Check if target cell is within the grid
	if target_grid_pos.x < grid_size.x and target_grid_pos.x >= 0:
		if target_grid_pos.y < grid_size.y and target_grid_pos.y >= 0:
			# If within grid return true if target cell is empty
			return true #if grid[target_grid_pos.x][target_grid_pos.y] == EMPTY else false
	return false


# Remove node from current cell, add it to the new cell,
# returns the new world target position
func update_child_pos(this_world_pos, direction, _type):

	var this_grid_pos = world_to_map(this_world_pos)
	var new_grid_pos = this_grid_pos + direction

	var new_world_pos = map_to_world(new_grid_pos) + half_tile_size
	return new_world_pos

func skill_1_effects():
	if (Global.p1_s1 == 0 and Global.turn == 0) or Global.p2_s1 == 0 and Global.turn == 1:
		var new_effect = laser.instance()
		new_effect.position = map_to_world(Global.crosshair) + half_tile_size
		new_effect.position.x = 0
		add_child(new_effect)
	if Global.p1_s1 == 10 and Global.turn == 0 or Global.p2_s1 == 10 and Global.turn == 1:
		var new_effect = star.instance()
		new_effect.position = map_to_world(Global.crosshair) + half_tile_size
		add_child(new_effect)
	pass

func skill_2_effects():
	if Global.p1_s2 == 1 and Global.turn == 0 or Global.p2_s2 == 1 and Global.turn == 1:
		var new_effect = blitz.instance()
		new_effect.position = Vector2.ZERO
		add_child(new_effect)
	if Global.p1_s2 == 11 and Global.turn == 0 or Global.p2_s2 == 11 and Global.turn == 1:
		var new_effect = sword.instance()
		new_effect.position = map_to_world(Global.crosshair) + half_tile_size
		new_effect.position.y = 0
		add_child(new_effect)

func reset():
	self.get_node("Crosshair").queue_free()
	
