extends Node

const COLUMNS = 10 #columns in the grid
const ROWS = 10 #rows in the grid

#Signals for calling functions from other scenes
signal destroy_counter(t) 
signal place_counter(pos)
signal game_over()
signal hurt(p)
signal turn_change()
signal skill_1()
#signal skill_2()

var play = false
var turn = 0 #game turn
var piece = 1 #player piece
var counter = 0 #counter type, 0=normal, 1=sand
var target_counter = 0

var game_over = true #game_over state
var winner = null #winner

var crosshair = Vector2(4,4) #crosshair position
var target_pos = Vector2(4,4) #target position for functions

#p1 variables:
var p1_health = 3
var p1_char = 1
var p1_s1 = 2 #p1 skill 1
var p1_s2 = 3 #p1 skill 2
var p1_max_cooldown_s1 = 6
var p1_max_cooldown_s2 = 17
var p1_cooldown_s1 = 6
var p1_cooldown_s2 = 17

#p2 variables:
var p2_health = 3
var p2_char = 0
var p2_s1 = 0 #p2 skill 1
var p2_s2 = 1 #p2 skill 2
var p2_max_cooldown_s1 = 5
var p2_max_cooldown_s2 = 15
var p2_cooldown_s1 = 5
var p2_cooldown_s2 = 15

var skill_used = false

var row = 4 
var col = 4

var board = [ #gameboard as array
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0], 
	[0,0,0,0,0,0,0,0,0,0],]

var positions = [] #array of placed counters
var positions_pieces = [] #array of the piece of placed counters
var positions_types = [] #array of the type of placed counters

func skip_turn():
	target_counter = 0
	skill_used = false
	turn += 1
	turn %= 2
	piece = turn + 1
	p1_cooldown_s1 = p1_cooldown_s1 - 1 if p1_cooldown_s1 >0 else 0
	p1_cooldown_s2 = p1_cooldown_s2 - 1 if p1_cooldown_s2 >0 else 0
	p2_cooldown_s1 = p2_cooldown_s1 - 1 if p2_cooldown_s1 >0 else 0
	p2_cooldown_s2 = p2_cooldown_s2 - 1 if p2_cooldown_s2 >0 else 0
	winning_move()
	emit_signal("turn_change")

func place_counter(r=row , c=col, p=piece, t = 0): 
	#r is the row, c is the column, p is the piece, t is the type of counter
	print(counter)
	counter = t
	if board[r][c] == 0:
		board[r][c] = p
		positions.append(Vector2(c, r))
		positions_pieces.append(p)
		positions_types.append(t)
		emit_signal("place_counter")
		winning_move()
		skip_turn()
	else:
		emit_signal("place_counter")
		print("INVALID")
	counter = 0
func place_counter_no_skip(r=row , c=col, p=piece, t = 0): 
	#r is the row, c is the column, p is the piece, t is the type of counter
	counter = t
	if board[r][c] == 0:
		board[r][c] = p
		positions.append(Vector2(c, r))
		positions_pieces.append(p)
		positions_types.append(t)
		emit_signal("place_counter")
		winning_move()
	else:
		emit_signal("place_counter")
		print("INVALID")
func check_for_counter(r, c):
	if board[r][c] != 0:
		return true
	else:
		return false
func destroy_block(t = Vector2(col, row)):
	target_pos = t
	for i in len(positions):
		if positions[i] == Vector2(t.x, t.y):
			board[t.y][t.x] = 0
			positions.remove(i)
			positions_pieces.remove(i)
			positions_types.remove(i)
			emit_signal("destroy_counter", t)
			break

#winning states:
func check_horizontal():
	var target_piece
	for c in COLUMNS - 3:
		for r in ROWS:
			for i in len(positions):
				if Vector2(c,r) == positions[i]:
					target_piece = positions_pieces[i]
					if board[r][c] == target_piece and board[r][c + 1] == target_piece and board[r][c+2] == target_piece and board[r][c+3] == target_piece:
						destroy_block(Vector2(c,r))
						destroy_block(Vector2(c+1,r))
						destroy_block(Vector2(c+2,r))
						destroy_block(Vector2(c+3,r))
						deplete_health(target_piece)
						return true
func check_vertical():
	var target_piece
	for c in COLUMNS:
		for r in ROWS - 3:
			for i in len(positions):
				if Vector2(c,r) == positions[i]:
					target_piece = positions_pieces[i]
					if board[r][c] == piece and board[r+1][c] == piece and board[r+2][c] == piece and board[r+3][c] == piece:
						destroy_block(Vector2(c,r))
						destroy_block(Vector2(c,r+1))
						destroy_block(Vector2(c,r+2))
						destroy_block(Vector2(c,r+3))
						deplete_health(target_piece)
						return true
func check_positive_diagnol():
	var target_piece
	for c in COLUMNS - 3:
		for r in range(3, ROWS):
			for i in len(positions):
				if Vector2(c,r) == positions[i]:
					target_piece = positions_pieces[i]
					if board[r][c] == piece and board[r-1][c+1] == piece and board[r-2][c+2] == piece and board[r-3][c+3] == piece:
						destroy_block(Vector2(c,r))
						destroy_block(Vector2(c+1,r-1))
						destroy_block(Vector2(c+2,r-2))
						destroy_block(Vector2(c+3,r-3))
						deplete_health(target_piece)
						return true
func check_negative_diagnol():
	var target_piece
	for c in COLUMNS - 3:
		for r in ROWS - 3:
			for i in len(positions):
				if Vector2(c,r) == positions[i]:
					target_piece = positions_pieces[i]
					if board[r][c] == piece and board[r+1][c+1] == piece and board[r+2][c+2] == piece and board[r+3][c+3] == piece:
						destroy_block(Vector2(c,r))
						destroy_block(Vector2(c+1,r+1))
						destroy_block(Vector2(c+2,r+2))
						destroy_block(Vector2(c+3,r+3))
						deplete_health(target_piece)
						return true
func winning_move():
	if check_horizontal() or check_vertical() or check_positive_diagnol() or check_negative_diagnol():
		return true
	else:
		return false

func deplete_health(target_piece):
	if target_piece == 1:
		if p2_health == 1:
			p2_health = 0
			winner = target_piece
			game_over = true
			emit_signal("game_over")
		else:
			p2_health -= 1
			emit_signal("hurt", target_piece)
	if target_piece == 2:
		if p1_health == 1:
			p1_health = 0
			winner = target_piece
			game_over = true
			emit_signal("game_over")
		else:
			p1_health -= 1
			emit_signal("hurt", target_piece)

func reset():
	for r in ROWS:
		for c in COLUMNS:
			destroy_block(Vector2(c,r))
	p1_health = 3
	p2_health = 3
	turn = 0 
	piece = 1 
	counter = 0 
	target_counter = 0
	crosshair = Vector2(4,4) 
	target_pos = Vector2(4,4)
	row = 4
	col = 4
	game_over = false

func _ready():
	CharacterManager.manage()

#1st Skills:
func laser():
	for c in COLUMNS:
		if check_for_counter(row, c):
			skill_used = true
			print(check_for_counter(row, c))
			destroy_block(Vector2(c, crosshair.y))
		if c == COLUMNS-1 and skill_used ==true:
			if turn == 0:
				p1_cooldown_s1 = p1_max_cooldown_s1
			else:
				p2_cooldown_s1 = p2_max_cooldown_s1
			emit_signal("skill_1")
			skip_turn()
func sand():
	var target_r = ROWS - 1
	if!check_for_counter(row, col):
		for r in range(row ,ROWS):
			if check_for_counter(r, col):
				target_r = r-1
				break
		counter = 1
		if turn == 0:
			p1_cooldown_s1 = p1_max_cooldown_s1
		else:
			p2_cooldown_s1 = p2_max_cooldown_s1
		place_counter_no_skip(target_r, col, piece, 1)
	else:
		for x in range(len(positions)):
			if positions[x] == Vector2(col, row) and positions_pieces[x] == turn + 1:
				destroy_block()
				place_counter_no_skip(row, col, piece, 1)
				if turn == 0:
					p1_cooldown_s1 = p1_max_cooldown_s1
				else:
					p2_cooldown_s1 = p2_max_cooldown_s1
	skip_turn()
func hacking():
	if check_for_counter(row, col):
		if turn == 0:
			p1_cooldown_s1 = p1_max_cooldown_s1
		else:
			p2_cooldown_s1 = p2_max_cooldown_s1
		destroy_block()
		place_counter()
func bricks():
	if !check_for_counter(row,col):
		if turn == 0:
			p1_cooldown_s1 = p1_max_cooldown_s1
		else:
			p2_cooldown_s1 = p2_max_cooldown_s1
		place_counter(row, col, 1, 2)
func anvil():
	if !check_for_counter(row, col):
		place_counter_no_skip(row, col, piece, 1)
		for x in range(row + 1, ROWS):
			destroy_block(Vector2(col, x))
		if turn == 0:
			p1_cooldown_s1 = p1_max_cooldown_s1
		else:
			p2_cooldown_s1 = p2_max_cooldown_s1
		skip_turn()
	pass

#2nd Skills:
func blitz():
	for c in COLUMNS:
		for r in ROWS:
			if check_for_counter(r, c):
				skill_used = true
				destroy_block(Vector2(c, r))
				break
			if c == COLUMNS-1 and skill_used ==true:
				if turn == 0:
					p1_cooldown_s2 = p1_max_cooldown_s2
				else:
					p2_cooldown_s2 = p2_max_cooldown_s2
				skip_turn()
func pyramid():
	var prev_positions_pieces = positions_pieces.duplicate()
	var prev_positions = positions.duplicate()
	var prev_positions_types = positions_types.duplicate()
	var target_r = ROWS - 1
	for c in COLUMNS:
		for r in ROWS:
			target_r = ROWS -1
			for n in len(prev_positions):
				if prev_positions[n] == Vector2(c,ROWS - r - 1) and prev_positions_types[n] != 2:
					# warning-ignore:shadowed_variable
					for row in range(prev_positions[n].y + 1 ,ROWS):
						if check_for_counter(row,c):
								target_r = row - 1
								print(target_r)
								break
					destroy_block(Vector2(c,ROWS - r - 1))
					counter = 1
					place_counter_no_skip(target_r, c, prev_positions_pieces[n], 1)
					winning_move()
	if turn == 0:
		p1_cooldown_s2 = p1_max_cooldown_s2
	else:
		p2_cooldown_s2 = p2_max_cooldown_s2
	skip_turn()

func Fire_wall():
	if turn == 0:
		p2_cooldown_s1 += 5
		p2_cooldown_s2 += 5
		p1_cooldown_s2 = p1_max_cooldown_s2
	if turn == 1:
		p1_cooldown_s1 += 5
		p1_cooldown_s2 += 5
		p2_cooldown_s2 = p2_max_cooldown_s2
	skip_turn()

#counter skills:
func sand_counter():
	target_counter = 1
	if turn == 1:
		p1_cooldown_s1 = p1_max_cooldown_s1
	else:
		p2_cooldown_s1 = p2_max_cooldown_s1

func _physics_process(_delta):
#	if Input.is_action_pressed("reset"):
#		reset()
	
	if game_over == false:
#		if Input.is_action_just_pressed("test"): #test
#			destroy_block()
#			skip_turn()
			
		if turn == 0: #P1's turn
			if Input.is_action_just_pressed("p1enter"): #placing counter
				place_counter(row, col, piece,target_counter)
			
			if Input.is_action_just_pressed("p1skill1") and p1_cooldown_s1 == 0: #P1 Skill 1:
				
				if p1_s1 == 0:
					laser()
				
				if p1_s1 == 2:
					sand()
				
				if p1_s1 == 4:
					bricks()
				
				if p1_s1 == 6:
					hacking()
				
				if p1_s1 == 8:
					anvil()
				
				
				print("power1")
			
			if Input.is_action_just_pressed("p1skill2") and p1_cooldown_s2 == 0: #P1 Skill 2:
				
				if p1_s2 == 1: 
					blitz()
				
				if p1_s2 == 3:
					pyramid()
				
				if p1_s2 == 7:
					Fire_wall()
				
				print("power2")
			
			if Input.is_action_just_pressed("p2skill1") and p2_cooldown_s1 == 0: #P1 Skill 1 counters:
				
				if p2_s1 == 2:
					sand_counter()
			
		if turn == 1: #P2's turn
			if Input.is_action_just_pressed("p2enter"): #placing counter
				place_counter(row, col, piece, target_counter)
			
			if Input.is_action_just_pressed("p2skill1") and p2_cooldown_s1 == 0: #P2 Skill 1
				
				if p2_s1 == 0: 
					laser()
				
				if p2_s1 == 2:
					sand()
				
				if p2_s1 == 4:
					bricks()
				
				if p2_s1 == 6:
					hacking()
				
				if p1_s1 == 8:
					anvil()
				
				print("P2 power1")
			
			if Input.is_action_just_pressed("p2skill2") and p2_cooldown_s2 == 0: #P2 skill 2
				
				if p2_s2 == 1: #Blitz
					blitz()
				
				if p2_s2 == 3: #Pyrimid
					pyramid()
				
				if p2_s2 == 7:
					Fire_wall()
				
				print("P2 power2")
			
			if Input.is_action_just_pressed("p1skill1") and p1_cooldown_s1 == 0: #P1 Skill 1 counters:
					if p1_s1 == 2:
						sand_counter()
