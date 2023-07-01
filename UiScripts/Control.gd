extends Control

#menu
onready var return3 = $Play/CanvasLayer
onready var play = $Menu/Play
onready var characters = $Menu/Characters
onready var options = $Menu/Options
onready var quit = $Menu/Quit

#fighters

#options
var master_bus = AudioServer.get_bus_index("Master")
var volume_db = AudioServer.set_bus_volume_db(master_bus, 0)
onready var _master = $Options/Master
onready var music = $Options/Music
onready var soundfx = $Options/SoundFX
onready var fullscreen = $Options/HBoxContainer/Fullscreen
onready var resolution = $Options/Resolution
onready var keybinds = $Options/Keybinds
onready var _return = $Options/Return

onready var buttonPressed = $Menu/ButtonPressed
onready var animationPlayer = $AnimationPlayer

func _ready():
	print("Master volume is ", volume_db)
	OS.center_window()
	resolution.add_item("1280 * 720")
	play.grab_focus()
	
#func _process(_delta):
#	if $MainMenu.finished():
#		$MainMenu.play()

func _on_Play_button_up():
	buttonPressed.play()
	animationPlayer.play("FadeOutMenu_ToPlay")


func _on_Characters_button_up():
	buttonPressed.play()
	animationPlayer.play("FadeOutMenu_ToFighters")


func _on_Options_button_up():
	buttonPressed.play()
	animationPlayer.play("FadeOutMenu_ToOptions")
	play.release_focus()
	characters.release_focus()
	options.release_focus()
	quit.release_focus()


func _on_Quit_button_up():
	buttonPressed.play()
	get_tree().quit()


func _on_Keybinds_button_up():
	buttonPressed.play()
	animationPlayer.play("FadeOutOptions_ToKeybinds")

func _on_Return_button_up():
	buttonPressed.play()
	#play.grab_focus()
	animationPlayer.play("FadeOutOptions_ToMenu")


func _init_Play_UI():
	
	animationPlayer.play("FadeInPlay")
	Global.play = true
	$Play.visible = true
	$Title.visible = false
	$Menu.visible = false
	$Patch.visible = false
	$Links.visible = false

func _init_Menu_UI():
# called when "FadeOutOptions_ToMenu" animation is finished
	print("Called Menu UI")
	
	animationPlayer.play("FadeInMenu")
	return3.visible = false
	$Characters.visible = false
	$Fighters.visible = false
	$Stage.visible = false
	$Title.visible = true
	$Settings.visible = false
	$Menu.visible = true
	$Patch.visible = true
	$Links.visible = true
	$Options.visible = false
	play.grab_focus()

func _init_Fighters_UI():
# called when "FadeOutMenu_ToFighters" animation is finished

	print("Called Fighters UI")
	animationPlayer.play("FadeInFighters")
	$Fighters/Return2.grab_focus()
	$Characters.visible = true
	$Fighters.visible = true
	$Stage.visible = true
	$Title.visible = false
	$Menu.visible = false
	$Patch.visible = false
	$Links.visible = false

func _init_Options_UI():
# called when "FadeOutMenu_ToOptions" animation is finished
	print("Called Options UI")
	
	animationPlayer.play("FadeInOptions")
	$Title.visible = false
	$Settings.visible = true
	$Menu.visible = false
	$Keybinds.visible = false
	$KeybindsPanel.visible = false
	$Patch.visible = false
	$Links.visible = false
	$Options.visible = true
	_return.grab_focus()
	
func _init_Keybinds_UI():
# called when "FadeOutOptions_ToKeybinds" animation is finished
	print("Called Keybinds UI")
	
	animationPlayer.play("FadeInKeybinds")
	$Settings.visible = false
	$Options.visible = false
	$KeybindsPanel.visible = true
	$Keybinds.visible = true
	$Keybinds/UI/Back.grab_focus()
	
func _on_Back_button_up():
	buttonPressed.play()
	animationPlayer.play("FadeOutKeybinds_ToOptions")


func _on_Fullscreen_toggled(button_pressed):
	if button_pressed == true:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	


func _on_Resolution_item_selected(index):
	if index == 0:
		OS.window_size = Vector2(1280, 720)
		OS.center_window()
		print("index(0)")


func _on_Vsync_toggled(button_pressed):
	if button_pressed == true:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false

func _on_Return2_button_up():
	buttonPressed.play()
	animationPlayer.play("FadeOutFighters_ToMenu")

func _on_Master_value_changed(value):
	print("Master volume is ", volume_db)
	volume_db = AudioServer.set_bus_volume_db(master_bus, value)
