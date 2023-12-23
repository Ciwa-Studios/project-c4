extends Sprite

var characters = []

onready var confirm = get_parent().get_node("GridContainer/Confirm")
onready var deny = get_parent().get_node("GridContainer/Deny")
onready var p1Label = get_parent().get_node("P1")
onready var p2Label = get_parent().get_node("P2")
onready var move = get_parent().get_node("Move")

onready var transition = get_parent().get_node("CanvasLayer/Transition")
onready var canvasLayer = $"../CanvasLayer"

var rng = RandomNumberGenerator.new()

var turnLeft
var turnRight
var turnUp
var turnDown
var accept
var currentSelected = 0
var currentColumnSpot = 0
var currentRowSpot = 0

export (Texture) var player1Text
export (Texture) var player2Text
export (int) var amountOfRows = 2
export (Vector2) var portraitOffset

onready var gridContainer = get_parent().get_node("GridContainer")

func _ready():
	canvasLayer.visible = false
	for nameOfCharacter in get_tree().get_nodes_in_group("Characters"):
		characters.append(nameOfCharacter)
	texture = player1Text
	
func _process(_delta):
	if Global.play == true:
		if texture == player1Text:
			accept = "p1enter"
			turnRight = "p1right"
			turnLeft = "p1left"
			turnUp = "p1up"
			turnDown = "p1down"
		elif texture == player2Text:
			accept = "p2enter"
			turnRight = "p2right"
			turnLeft = "p2left"
			turnUp = "p2up"
			turnDown = "p2down"
		
		if(Input.is_action_just_pressed(turnRight)):
			move.play()
			currentSelected += 1
			currentColumnSpot += 1
			
			# If the cursor goes past the total amount of columns reset to the first item in the column and go 1 row down
			if(currentColumnSpot > gridContainer.columns - 1 && currentSelected < characters.size() - 1):
				position.x -= (currentColumnSpot - 1) * portraitOffset.x
				position.y += portraitOffset.y
				
				currentColumnSpot = 0
				currentRowSpot += 1
			# If the cursor goes past the total amount of columns and amount of characters, reset to the first item in the whole roster 
			elif(currentColumnSpot > gridContainer.columns -1 && currentSelected > characters.size() - 1):
				position.x -= (currentColumnSpot - 1) * portraitOffset.x
				position.y -= currentRowSpot * portraitOffset.y
				
				currentColumnSpot = 0;
				currentRowSpot = 0;
				currentSelected = 0;
			else:
				position.x += portraitOffset.x   # Move to the new position based on the offset
		elif(Input.is_action_just_pressed(turnLeft)):
			move.play()
			currentSelected -= 1
			currentColumnSpot -= 1
			
			# If the cursor goes past the 0 amount on a column position reset to the first item in the column and go 1 row up
			if(currentColumnSpot < 0 && currentSelected > 0):
				position.x += (gridContainer.columns - 1) * portraitOffset.x
				position.y -= portraitOffset.y
				
				currentColumnSpot = gridContainer.columns - 1
				currentRowSpot -= 1
			# If the cursor goes past the 0 amount on a column position and 0 amount of characters, reset to the last item in the whole roster 
			elif(currentColumnSpot < 0 && currentSelected < 0):
				position.x += (gridContainer.columns - 1) * portraitOffset.x
				position.y += (amountOfRows - 1) * portraitOffset.y
				
				currentColumnSpot = gridContainer.columns - 1
				currentRowSpot = amountOfRows - 1
				currentSelected = characters.size() - 1
			else:
				position.x -= portraitOffset.x # Move to the new position based on the offset
		if(Input.is_action_just_pressed(turnDown)):
			move.play()
			currentSelected += 3
			currentRowSpot += 1
			
			print(currentRowSpot)
			if currentRowSpot > ((characters.size() - 1) / (gridContainer.columns -1)) - 2:
				position.y -= (currentRowSpot - 1) * portraitOffset.y
				
				currentRowSpot = 0
				currentSelected = 0;
			else:
				position.y += portraitOffset.y
				
		elif(Input.is_action_just_pressed(turnUp)):
			move.play()
			currentSelected -= 3
			currentRowSpot -= 1
			
			print(currentRowSpot)
			if currentRowSpot < 0:
				position.y -= (currentRowSpot - 1) * portraitOffset.y
				
				currentRowSpot = ((characters.size() - 1) / (gridContainer.columns -1)) - 2;
				print(currentRowSpot)
				currentSelected += characters.size();
			else:
				position.y -= portraitOffset.y
			

		if currentSelected == 1: #Pharaoh
			if texture == player1Text:
				$"../P1/Character Sprites".animation.play("11")
				p1Label.text = "Pharaoh"
			elif texture == player2Text:
				$"../P2/Character Sprites2".animation.play("11")
				p2Label.text = "Pharaoh"
		elif currentSelected == 0: #Robot
			if texture == player1Text:
				$"../P1/Character Sprites".animation.play("01")
				p1Label.text = "Robot"
			elif texture == player2Text:
				$"../P2/Character Sprites2".animation.play("01")
				p2Label.text = "Robot"
		elif currentSelected == 3: #Hacker
			if texture == player1Text:
				$"../P1/Character Sprites".animation.play("31")
				p1Label.text = "Hacker"
			elif texture == player2Text:
				$"../P2/Character Sprites2".animation.play("31")
				p2Label.text = "Hacker"
		elif currentSelected == 4: #random
			if texture == player1Text:
				p1Label.text = "Random"
			elif texture == player2Text:
				p2Label.text = "Random"
		else:
			if texture == player1Text:
				p1Label.text = "Locked"
			elif texture == player2Text:
				p2Label.text = "Locked" 

		if (Input.is_action_just_pressed(accept)):
			if texture == player1Text:
				if currentSelected == 0 or currentSelected == 1 or currentSelected == 3 or currentSelected == 5: 
					Global.p1_char = currentSelected
					var sprite = Sprite.new()
					sprite.texture = texture
					get_parent().add_child(sprite)
					sprite.position = Vector2(position.x, position.y)
					texture = player2Text
					confirm.play()
				elif currentSelected == 4: #random
					Global.p1_char = rng.randi_range(0, 1) #currentSelected
					var sprite = Sprite.new()
					sprite.texture = texture
					get_parent().add_child(sprite)
					sprite.position = Vector2(position.x, position.y)
					texture = player2Text
					confirm.play()
				else:
					print("Work in progress character")
					deny.play()

			elif texture == player2Text:
				if currentSelected == 0 or currentSelected == 1 or currentSelected == 3 or currentSelected == 5:
					Global.p2_char = currentSelected
					CharacterManager.manage()
					transition.play("Start")
					var sprite = Sprite.new()
					sprite.texture = texture
					get_parent().add_child(sprite)
					sprite.position = Vector2(position.x, position.y)
					confirm.play()
					texture = null
				elif currentSelected == 4: #random
					print("Player 2 has chosen a character: " + str(currentSelected)) 
					Global.p2_char = rng.randi_range(0, 1) #currentSelected
					CharacterManager.manage()
					transition.play("Start")
					var sprite = Sprite.new()
					sprite.texture = texture
					get_parent().add_child(sprite)
					sprite.position = Vector2(position.x, position.y)
					confirm.play()
					texture = null
				else:
					print("Work in progress character")
					deny.play()

func start_game():
# warning-ignore:return_value_discarded
	Global.reset()
	get_tree().change_scene("res://Scenes/Main.tscn")
	print(Global.board)
	
