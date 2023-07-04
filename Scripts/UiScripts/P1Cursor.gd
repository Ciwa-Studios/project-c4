extends Sprite

var characters = []

onready var confirm = get_parent().get_node("GridContainer/Confirm")
onready var deny = get_parent().get_node("GridContainer/Deny")
onready var p1Label = get_parent().get_node("P1")
onready var p2Label = get_parent().get_node("P2")

onready var p1Pharaoh = get_parent().get_node("P1/Pharaoh")
onready var p1Robot = get_parent().get_node("P1/Robot")
onready var p2Pharaoh = get_parent().get_node("P2/Pharaoh")
onready var p2Robot = get_parent().get_node("P2/Robot")

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
				p1Label.text = "Pharaoh"
				p1Robot.visible = false
				p1Pharaoh.visible = true
			elif texture == player2Text:
				p2Label.text = "Pharaoh"
				p2Robot.visible = false
				p2Pharaoh.visible = true
		elif currentSelected == 0: #Robot
			if texture == player1Text:
				p1Label.text = "Robot"
				p1Robot.visible = true
				p1Pharaoh.visible = false
			elif texture == player2Text:
				p2Label.text = "Robot"
				p2Robot.visible = true
				p2Pharaoh.visible = false
		elif currentSelected == 4: #random
			if texture == player1Text:
				p1Label.text = "Random"
				p1Robot.visible = false
				p1Pharaoh.visible = false
			elif texture == player2Text:
				p2Label.text = "Random"
				p2Robot.visible = false
				p2Pharaoh.visible = false
		else:
			if texture == player1Text:
				p1Label.text = "Locked"
				p1Robot.visible = false
				p1Pharaoh.visible = false
			elif texture == player2Text:
				p2Label.text = "Locked" 
				p2Robot.visible = false
				p2Pharaoh.visible = false

		if (Input.is_action_just_pressed(accept)):
			if texture == player1Text:
				if currentSelected == 0 or currentSelected == 1: #robot
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
				if currentSelected == 0 or currentSelected == 1:
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
	
