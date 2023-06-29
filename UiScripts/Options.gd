extends VBoxContainer

onready var pointerKeybindsL = $Keybinds/PointerL
onready var pointerReturnL = $Return/PointerL

func _ready():
	$Return.grab_focus()

func _on_Keybinds_mouse_entered():
	$ButtonFocused.play()
	pointerKeybindsL.visible = true
func _on_Keybinds_mouse_exited():
	pointerKeybindsL.visible = false
func _on_Keybinds_focus_entered():
	$ButtonFocused.play()
	pointerKeybindsL.visible = true
func _on_Keybinds_focus_exited():
	pointerKeybindsL.visible = false

func _on_Return_mouse_entered():
	$ButtonFocused.play()
	pointerReturnL.visible = true
func _on_Return_mouse_exited():
	pointerReturnL.visible = false
func _on_Return_focus_entered():
	$ButtonFocused.play()
	pointerReturnL.visible = true
func _on_Return_focus_exited():
	pointerReturnL.visible = false
