extends MarginContainer

onready var buttonFocused = get_parent().get_node("ButtonFocused")
onready var buttonPressed = get_parent().get_node("ButtonPressed")
onready var pointerPharaoh = $TextureRect/Pharaoh
onready var pointerRobot = $TextureRect/Robot
onready var pharaoh = $TextureRect/Pharaoh
onready var robot = $TextureRect/Robot


func _on_Pharaoh_button_up():
	buttonPressed.play()
	pointerRobot.visible = false
	pointerPharaoh.visible = true
	pharaoh.visible = true
	robot.visible = false


func _on_Robot_button_up():
	buttonPressed.play()
	pointerPharaoh.visible = false
	pointerRobot.visible = true
	robot.visible = true
	pharaoh.visible = false

func _on_Pharaoh_focus_entered():
	buttonFocused.play()
func _on_Robot_focus_entered():
	buttonFocused.play()
func _on_Return2_focus_entered():
	buttonFocused.play()
