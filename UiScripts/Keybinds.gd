extends HBoxContainer

onready var button = $UI/Back
onready var backPointerL = $UI/Back/PointerL
onready var buttonFocused = $ButtonFocused

func _on_Back_mouse_entered():
	if button.disabled == false:
		backPointerL.visible = true
		buttonFocused.play()

func _on_Back_mouse_exited():
	backPointerL.visible = false


func _on_Back_focus_entered():
	if button.disabled == false:
		backPointerL.visible = true
		buttonFocused.play()


func _on_Back_focus_exited():
	backPointerL.visible = false
