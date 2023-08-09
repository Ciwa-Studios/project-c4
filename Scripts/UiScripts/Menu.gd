extends VBoxContainer

onready var buttonFocusedSound = $ButtonFocused
onready var pointerPlayL = $Play/PointerL
onready var pointerCharactersL = $Characters/PointerL
onready var pointerOptionsL = $Options/PointerL
onready var pointerQuitL = $Quit/PointerL

func _on_Play_focus_entered():
	pointerPlayL.visible = true
	buttonFocusedSound.play()
func _on_Play_focus_exited():
	pointerPlayL.visible = false

func _on_Characters_focus_entered():
	pointerCharactersL.visible = true
	buttonFocusedSound.play()
func _on_Characters_focus_exited():
	pointerCharactersL.visible = false

func _on_Options_focus_entered():
	pointerOptionsL.visible = true
	buttonFocusedSound.play()
func _on_Options_focus_exited():
	pointerOptionsL.visible = false

func _on_Quit_focus_entered():
	pointerQuitL.visible = true
	buttonFocusedSound.play()
func _on_Quit_focus_exited():
	pointerQuitL.visible = false