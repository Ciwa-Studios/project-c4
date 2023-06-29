extends MarginContainer

onready var buttonFocused = $ButtonFocused
onready var pointerPharaoh = $TextureRect/Pharaoh
onready var pointerRobot = $TextureRect/Robot
onready var pharaoh = $TextureRect/Pharaoh
onready var robot = $TextureRect/Robot


func _on_Pharaoh_button_up():
	$ButtonPressed.play()
	pointerRobot.visible = false
	pointerPharaoh.visible = true
	pharaoh.visible = true
	robot.visible = false


func _on_Robot_button_up():
	$ButtonPressed.play()
	pointerPharaoh.visible = false
	pointerRobot.visible = true
	robot.visible = true
	pharaoh.visible = false
