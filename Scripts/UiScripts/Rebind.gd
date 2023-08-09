extends Button

onready var back = get_parent().get_parent().get_parent().get_node("UI/Back")
export(String) var action 

func _ready():
	assert(InputMap.has_action(action))
	set_process_unhandled_key_input(false)
	display_current_key()

func _toggled(button_pressed):
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		back.disabled = true
		text = "... Key"
		print("buttons pressed")
		release_focus()
	else:
		print("else is true")
		display_current_key()


func _unhandled_key_input(event):
	remap_action_to(event)
	pressed = false


func remap_action_to(event):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)

func display_current_key():
	back.disabled = false
	var current_key = InputMap.get_action_list(action)[0].as_text()
	text = "%s" % current_key
