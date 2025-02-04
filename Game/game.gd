extends Node2D

const COLUMNS = 10 # no. of columns in the grid
const ROWS = 10 # no. of rows in the grid

@warning_ignore("unused_signal")
signal health_depleted(player)
@warning_ignore("unused_signal")
signal energy_changed
@warning_ignore("unused_signal")
signal turn_changed
@warning_ignore("unused_signal")
signal action_changed
@warning_ignore("unused_signal")
signal skill1_used(player)
@warning_ignore("unused_signal")
signal skill2_used(player)

@onready var grid = $Grid
@onready var camera = $Camera2D
@onready var P1_piece = preload("res://Game/Pieces/P1 pieces/p1_normal_piece.tscn")
@onready var P2_piece = preload("res://Game/Pieces/P2 pieces/p2_normal_piece.tscn")
@onready var N_piece = preload("res://Game/Pieces/Neutral pieces/neutral_piece.tscn")

var database : SQLite
var turn : int = 1# increments after each turn
var player_turn : int = 1 # switches between 1 and 2 representing each player
var piece_type : String # changes the piece type to be placed this turn
var turn_action : String = "place" # determines what occurs during the turn

#p1 variables:
var p1_character : String = "test"
var p1_health : int = 3
var p1_energy : int = 0
var p1_max_energy : int = 10
var p1_skill1 : String 
var p1_skill2 : String

#p2 variables:
var p2_character : String = "test"
var p2_health : int = 3
var p2_energy : int = 0
var p2_max_energy : int = 10
var p2_skill1 : String
var p2_skill2 : String

var crosshair_pos : Vector2
var board_dic = {}


func _ready() -> void:
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()

	p1_skill1 = database.select_rows("characters", "name = '" + p1_character + "'", ["skill1"])[0]["skill1"]
	p1_skill2 = database.select_rows("characters", "name = '" + p1_character + "'", ["skill2"])[0]["skill2"]
	
	p2_skill1 = database.select_rows("characters", "name = '" + p2_character + "'", ["skill1"])[0]["skill1"]
	p2_skill2 = database.select_rows("characters", "name = '" + p2_character + "'", ["skill2"])[0]["skill2"]
	
	for c in COLUMNS:
		for r in ROWS:
			board_dic[str(Vector2(c,r))] = {
				"piece" : 0,
				"type" : "normal" 
			}
	
	spawn_character(p1_character, 1)
	spawn_character(p2_character, 2)

func spawn_character(character, player):
	var character_sprite
	match character:
		"pharoh":
			pass
		
		"angel":
			character_sprite = preload("res://Game/Characters/Angel/angel.tscn").instantiate()
			character_sprite.player = player
			if player == 1:
				character_sprite.position = Vector2(78 , 96)
			else:
				character_sprite.position = Vector2(404 , 96)
				character_sprite.scale.x = -1
			add_child(character_sprite)
		
		"samurai":
			character_sprite = preload("res://Game/Characters/Samurai/samurai.tscn").instantiate()
			character_sprite.player = player
			if player == 1:
				character_sprite.position = Vector2(96, 139)
			else:
				character_sprite.position = Vector2(396 , 139)
				character_sprite.scale.x = -1
			add_child(character_sprite)
		
		"human":
			character_sprite = preload("res://Game/Characters/Human/human.tscn").instantiate()
			character_sprite.player = player
			if player == 1:
				character_sprite.position = Vector2(96, 139)
			else:
				character_sprite.position = Vector2(396 , 139)
				character_sprite.scale.x = -1
			add_child(character_sprite)

func skip_turn():
	turn += 1
	backpack_randomiser = randi_range(1,3)
	player_turn = turn % 2
	piece_type = "normal"
	turn_action = "place"
	emit_signal("turn_changed")
	emit_signal("action_changed")
	await get_tree().create_timer(0.1).timeout
	winning_move()
	
	if p1_energy < p1_max_energy:
		p1_energy += 1
		emit_signal("energy_changed")
	if p2_energy < p2_max_energy:
		p2_energy += 1
		emit_signal("energy_changed")
	
	if slash_cooldown > 0:
		slash_cooldown -= 1
	if slash_cooldown == 0:
		p1_max_energy = 10
		p2_max_energy = 10
	

# Basic mechanics
func place_piece(player : int, pos : Vector2, type = "normal"): # places a piece in a location 
	if !check_for_piece(pos):
		board_dic[str(pos)]["piece"] = player
		board_dic[str(pos)]["type"] = type
		var new_piece
		if player == 1:
			new_piece = P1_piece.instantiate()
			#if p1_energy < 10:
				#p1_energy += 1
				#emit_signal("energy_changed")
		elif player == 2:
			new_piece = P2_piece.instantiate()
			#if p2_energy < 10:
				#p2_energy += 1
				#emit_signal("energy_changed")
		elif player == 3:
			new_piece = N_piece.instantiate()
		new_piece.position = Vector2(150,44) + to_global(grid.map_to_local(pos))
		new_piece.z_index = pos.y
		new_piece.type = type
		new_piece.pos = pos
		new_piece.name = str(pos.x) + str(pos.y)
		add_child(new_piece)
func check_for_piece(pos): # checks if a piece exists in a specific location
	if pos.x > -1 and pos.x < COLUMNS and pos.y > -1 and pos.y < ROWS:
		if board_dic[str(pos)]["piece"] == 0:
			return false
		else:
			return true
func move_piece(pos, target): # moves a piece from one location to another
	if target.x < COLUMNS and target.y < ROWS:
		if check_for_piece(pos) and !check_for_piece(target) and self.has_node(str(pos.x) + str(pos.y)) and board_dic[str(pos)]["type"] != "brick":
			var temp = board_dic[str(pos)].duplicate()
			board_dic[str(pos)]["piece"] = 0
			board_dic[str(target)] = temp
			var temp_piece = self.get_node(str(pos.x) + str(pos.y))
			var target_pos = temp_piece.position - ((pos - target) * 18)
			for i in 5:
				await get_tree().create_timer(0.02).timeout
				temp_piece.position = lerp(temp_piece.position , target_pos , 0.7)
			temp_piece.position = target_pos
			temp_piece.name = str(target.x) + str(target.y)
			winning_move()
func destroy_piece(pos): # destroys a piece in a designated location
	if check_for_piece(pos) and self.has_node(str(pos.x) + str(pos.y)):
		if board_dic[str(pos)]["type"] == "brick":
			change_piece_type(pos, "sand")
			return
		board_dic[str(pos)]["piece"] = 0 
		board_dic[str(pos)]["type"] = "normal"
		self.get_node(str(pos.x) + str(pos.y)).death()
func change_piece_type(pos : Vector2, type : String):
	if check_for_piece(pos):
		board_dic[str(pos)]["type"] = type
		if get_node(str(pos.x) + str(pos.y)):
			get_node(str(pos.x) + str(pos.y)).change_type(type)

# Visual effects
func frameFreeze(timeScale = 0.05, duration = 1.0):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0

# Checks for 4 in a rows
func check_horizontal(p):
	for c in COLUMNS - 3:
		for r in ROWS:
			if board_dic[str(Vector2(c,r))]["piece"] == p and board_dic[str(Vector2(c + 1,r))]["piece"] == p and board_dic[str(Vector2(c + 2,r))]["piece"] == p  and board_dic[str(Vector2(c + 3,r))]["piece"] == p:
				destroy_piece(Vector2(c,r))
				destroy_piece(Vector2(c+1,r))
				destroy_piece(Vector2(c+2,r))
				destroy_piece(Vector2(c+3,r))
				return true
func check_vertical(p):
	for c in COLUMNS:
		for r in ROWS - 3:
			if board_dic[str(Vector2(c,r))]["piece"] == p and board_dic[str(Vector2(c,r + 1))]["piece"] == p and board_dic[str(Vector2(c,r + 2))]["piece"] == p  and board_dic[str(Vector2(c,r + 3))]["piece"] == p:
				destroy_piece(Vector2(c,r))
				destroy_piece(Vector2(c,r + 1))
				destroy_piece(Vector2(c,r + 2))
				destroy_piece(Vector2(c,r + 3))
				return true
func check_negative_diagnal(p):
	for c in COLUMNS - 3:
		for r in ROWS - 3:
			if board_dic[str(Vector2(c,r))]["piece"] == p and board_dic[str(Vector2(c + 1,r + 1))]["piece"] == p and board_dic[str(Vector2(c + 2,r + 2))]["piece"] == p  and board_dic[str(Vector2(c + 3,r + 3))]["piece"] == p:
				destroy_piece(Vector2(c,r))
				destroy_piece(Vector2(c + 1,r + 1))
				destroy_piece(Vector2(c + 2,r + 2))
				destroy_piece(Vector2(c + 3,r + 3))
				return true
func check_posotive_diagnal(p):
	for c in COLUMNS - 3:
		for r in range(3, ROWS):
			if board_dic[str(Vector2(c,r))]["piece"] == p and board_dic[str(Vector2(c + 1,r - 1))]["piece"] == p and board_dic[str(Vector2(c + 2,r - 2))]["piece"] == p  and board_dic[str(Vector2(c + 3,r - 3))]["piece"] == p:
				destroy_piece(Vector2(c,r))
				destroy_piece(Vector2(c + 1,r - 1))
				destroy_piece(Vector2(c + 2,r - 2))
				destroy_piece(Vector2(c + 3,r - 3))
				return true
func winning_move():
	for p in range(1,3):
		if check_horizontal(p) or check_vertical(p) or check_negative_diagnal(p) or check_posotive_diagnal(p):
			camera.shake_camera()
			frameFreeze(0.05, 0.1)
			if p == 1:
				deplete_health(2)
				p1_energy += 1
				emit_signal("energy_changed")
			else:
				deplete_health(1)
				p2_energy += 1
				emit_signal("energy_changed")

# Managing stats
func deplete_health(player): # removes health from designated player
	if player == 1:
		p1_health -= 1
		emit_signal("health_depleted", player)
		if p1_health == 0:
			await get_tree().create_timer(2).timeout
			get_tree().reload_current_scene()
	if player == 2:
		p2_health -= 1
		emit_signal("health_depleted", player)
		if p2_health == 0:
			await get_tree().create_timer(2).timeout
			get_tree().reload_current_scene()
func deplete_energy(amount : int, player = player_turn):
	if player == 1:
		p1_energy -= amount
	if player == 2:
		p2_energy -= amount
	emit_signal("energy_changed")

# Skills
var slash_cooldown = 0
func sword_slash(_cost, energy): # destroys all the pieces in a row
	emit_signal("skill2_used", player_turn)
	for c in COLUMNS - 1:
		destroy_piece(Vector2(c, crosshair_pos.y))
	camera.shake_camera()  
	deplete_energy(3)
	if energy < 6:
		skip_turn()
	var vfx = preload("res://Game/VFX/sword_slash_vfx.tscn")
	var new_vfx = vfx.instantiate()
	new_vfx.position = Vector2(240, 50 + (crosshair_pos.y * 18))
	if player_turn == 1:
		p1_max_energy -= 2
		slash_cooldown += 2
	if player_turn == 2:
		p2_max_energy -= 2
		slash_cooldown += 2
		new_vfx.scale.x = -1
	add_child(new_vfx)
	
	#skip_turn()
func sand(cost): # places a sand piece (affected by gravity)
	if check_for_piece(crosshair_pos):
		change_piece_type(crosshair_pos, "sand")
		deplete_energy(cost)
		emit_signal("skill1_used", player_turn)
		skip_turn()
	else:
		piece_type = "sand"
		deplete_energy(cost)
		emit_signal("skill1_used", player_turn)
func brick(cost): # places a brick piece (unaffected by physics, produces sand on death)
	if check_for_piece(crosshair_pos):
		change_piece_type(crosshair_pos, "brick")
		deplete_energy(cost)
		skip_turn()
	else:
		piece_type = "brick"
		deplete_energy(cost)
func star(cost): # destroys pieces in a + sign and places neutral piece at crosshair
	if check_for_piece(crosshair_pos):
		emit_signal("skill1_used", player_turn)
		await get_tree().create_timer(0.1).timeout
		deplete_energy(cost)
		camera.shake_camera()
		var vfx = preload("res://Game/Characters/Angel/angel_star.tscn")
		var new_vfx = vfx.instantiate()
		new_vfx.position = Vector2(159, 50) + crosshair_pos * 18
		add_child(new_vfx)
		destroy_piece(crosshair_pos)
		destroy_piece(crosshair_pos + Vector2(1, 0))
		destroy_piece(crosshair_pos + Vector2(-1, 0))
		destroy_piece(crosshair_pos + Vector2(0, 1))
		destroy_piece(crosshair_pos + Vector2(0, -1))
		await  get_tree().create_timer(0.2).timeout
		place_piece(3, crosshair_pos)
		skip_turn()
func sword(cost): # destroys pieces in a column and replaces with neutral blocks lasting 3 turns
	emit_signal("skill2_used", player_turn)
	await get_tree().create_timer(1.1).timeout
	camera.shake_camera(2,1.5)
	var vfx = preload("res://Game/Characters/Angel/angel_sword.tscn")
	var new_vfx = vfx.instantiate()
	new_vfx.position.x = 159 + (crosshair_pos.x * 18)
	add_child(new_vfx)
	deplete_energy(cost)
	skip_turn()
	for r in ROWS:
		destroy_piece(Vector2(crosshair_pos.x, r))
		await get_tree().create_timer(0.02).timeout
		place_piece(3, Vector2(crosshair_pos.x, r), "chains")
func cat_net(cost): # destroys piece at crosshair and limmits crosshair movement
	deplete_energy(cost)
	emit_signal("skill1_used", player_turn)
	destroy_piece(crosshair_pos)
	await get_tree().create_timer(0.1).timeout
	skip_turn()
	get_node("Crosshair").lock_crosshair()
func cat_net_counter(cost):
	if player_turn == 1:
		deplete_energy(cost, 2)
		emit_signal("skill1_used", 2)
	if player_turn == 2:
		deplete_energy(cost, 1)
		emit_signal("skill1_used", 1)
	destroy_piece(crosshair_pos)
	await get_tree().create_timer(0.1).timeout
	get_node("Crosshair").lock_crosshair()
func pyramid(cost): # replaces all pieces with sand pieces
	for c in COLUMNS:
		for r in ROWS:
			if board_dic[str(Vector2(c,r))]["type"] != "brick":
				change_piece_type(Vector2(c,r), "sand" )
	deplete_energy(cost)
	skip_turn()
func hack(cost): # replaces a piece with ur own
	if check_for_piece(crosshair_pos):
		var temp_type = board_dic[str(crosshair_pos)]["type"]
		destroy_piece(crosshair_pos)
		place_piece(player_turn, crosshair_pos, temp_type)
		deplete_energy(cost)
		skip_turn()

var backpack_randomiser
func backpack(cost):
	if backpack_randomiser == 1:
		bomb(cost)
	if backpack_randomiser == 2:
		stun_grenade(cost)
	if backpack_randomiser == 3:
		uzi(cost)
func bomb(cost):
	destroy_piece(crosshair_pos)
	destroy_piece(crosshair_pos + Vector2(1, 0))
	destroy_piece(crosshair_pos + Vector2(-1, 0))
	destroy_piece(crosshair_pos + Vector2(0, 1))
	destroy_piece(crosshair_pos + Vector2(0, -1))
	destroy_piece(crosshair_pos + Vector2(1, 1))
	destroy_piece(crosshair_pos + Vector2(-1, 1))
	destroy_piece(crosshair_pos + Vector2(1, -1))
	destroy_piece(crosshair_pos + Vector2(-1, -1))
	deplete_energy(cost)
	emit_signal("skill1_used", player_turn)
	skip_turn()
func stun_grenade(cost):
	for c in range(crosshair_pos.x - 1, crosshair_pos.x + 2):
		for r in range(crosshair_pos.y - 1, crosshair_pos.y + 2):
			if check_for_piece(Vector2(c,r)):
				if board_dic[str(Vector2(c,r))]["piece"] != player_turn:
					destroy_piece(Vector2(c,r))
					place_piece(3, Vector2(c,r))
	deplete_energy(cost)
	emit_signal("skill1_used", player_turn)
	skip_turn()
func uzi(cost):
	for c in range(crosshair_pos.x - 1, crosshair_pos.x + 2):
		for r in range(crosshair_pos.y - 1, crosshair_pos.y + 2):
			if check_for_piece(Vector2(c,r)):
				if board_dic[str(Vector2(c,r))]["piece"] != player_turn:
					destroy_piece(Vector2(c,r))
	deplete_energy(cost)
	emit_signal("skill1_used", player_turn)
	skip_turn()


func anvil(cost):
	if !check_for_piece(crosshair_pos):
		destroy_piece(Vector2(crosshair_pos.x, ROWS - 1))
		for i in range(ROWS - 1, crosshair_pos.y, -1):
			move_piece(Vector2(crosshair_pos.x, i), Vector2(crosshair_pos.x, i + 1))
		place_piece(player_turn, crosshair_pos, "sand")
		deplete_energy(cost)
		emit_signal("skill1_used", player_turn)
		skip_turn()
func blitz(cost):
	for c in COLUMNS:
		for r in ROWS:
			if check_for_piece(Vector2(c,r)):
				destroy_piece(Vector2(c,r))
				break
	deplete_energy(cost)
	emit_signal("skill2_used", player_turn)
	skip_turn()

func use_skill(skill, energy):
	var cost = database.select_rows("skills", "skill = '" + skill + "'", ["cost"])[0]["cost"]
	match skill:
		"sand":
			sand(cost)
			return
		
		"anvil":
			anvil(cost)
			return
		"sword_slash":
			sword_slash(cost, energy)
			return
		
		"star":
			star(cost)
			return
		
		"hack":
			hack(cost)
			return
		
		"bomb":
			bomb(cost)
			return
		"cat_net":
			cat_net(cost)
			return
		
		"brick":
			brick(cost)
			return
		
		"pyramid":
			pyramid(cost)
			return
		
		"blitz":
			blitz(cost)
			return
		
		"sword":
			sword(cost)
			return
		
		"stun":
			stun_grenade(cost)
			return
		
		"backpack":
			backpack(cost)
			return
func can_use_skill(skill, energy):
	var cost = database.select_rows("skills", "skill = '" + skill + "'", ["cost"])[0]["cost"]
	if energy >= cost:
		return true
func use_counter_skill(skill,energy):
	var cost = database.select_rows("skills", "skill = '" + skill + "'", ["cost"])[0]["cost"]
	match skill:
		"cat_net":
			cat_net_counter(cost)
func can_use_counter_skill(skill):
	match skill:
		"cat_net":
			return true

func _process(_delta: float) -> void:
	crosshair_pos =  $Crosshair.pos.round()
	
	for c in COLUMNS:
		for r in ROWS - 1:
			if board_dic[str(Vector2(c,r))]["type"] == "sand":
				var temp = r
				for n in range(r + 1 ,ROWS):
					if check_for_piece(Vector2(c , n)):
						temp = n - 1
						break
					else:
						temp += 1
				move_piece(Vector2(c,r), Vector2(c,temp))
	
	
	if player_turn == 1:
		if Input.is_action_just_pressed("p1_place"):
			if turn_action == "place" and !check_for_piece(crosshair_pos):
				place_piece(1, crosshair_pos, piece_type)
				skip_turn()
			if turn_action == p1_skill1:
				use_skill(p1_skill1, p1_energy)
			if turn_action == p1_skill2:
				use_skill(p1_skill2, p1_energy)
		
		if Input.is_action_just_pressed("p1_skill1"):
			if turn_action != p1_skill1 and can_use_skill(p1_skill1, p1_energy):
				turn_action = p1_skill1  
			else: 
				turn_action = "place"
			emit_signal("action_changed")
		if Input.is_action_just_pressed("p1_skill2"):
			if turn_action != p1_skill2 and can_use_skill(p1_skill2, p1_energy):
				turn_action = p1_skill2  
			else: 
				turn_action = "place"
			emit_signal("action_changed")
		
		if Input.is_action_just_pressed("p2_skill1"):
			if can_use_skill(p2_skill1, p2_energy) and can_use_counter_skill(p2_skill1):
				use_counter_skill(p2_skill1, p2_energy)
	else:
		if Input.is_action_just_pressed("p2_place"):
			if turn_action == "place" and !check_for_piece(crosshair_pos):
				place_piece(2, crosshair_pos, piece_type)
				skip_turn()
			if turn_action == p2_skill1:
				use_skill(p2_skill1, p2_energy)
			if turn_action == p2_skill2:
				use_skill(p2_skill2, p2_energy)
		
		if Input.is_action_just_pressed("p2_skill1"):
			if turn_action != p2_skill1 and can_use_skill(p2_skill1, p2_energy):
				turn_action = p2_skill1  
			else: 
				turn_action = "place"
			emit_signal("action_changed")
		if Input.is_action_just_pressed("p2_skill2"):
			if turn_action != p2_skill2 and can_use_skill(p2_skill2, p2_energy):
				turn_action = p2_skill2  
			else: 
				turn_action = "place"
			emit_signal("action_changed")
		
		if Input.is_action_just_pressed("p1_skill1"):
			if can_use_skill(p1_skill1, p1_energy) and can_use_counter_skill(p1_skill1):
				use_counter_skill(p1_skill1, p1_energy)
