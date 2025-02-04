extends Label

var turn : int

func _ready() -> void:
	get_parent().connect("turn_changed", turn_changed)

func turn_changed():
	turn = get_parent().turn
	text = "Turn " + str(turn)
	
	if turn % 2 == 1:
		add_theme_color_override("font_color", Color(0.31, 0.561, 0.729))
		add_theme_color_override("font_shadow_color", Color(0.235, 0.369, 0.545))
	else:
		add_theme_color_override("font_color",  Color(0.647, 0.188, 0.188))
		add_theme_color_override("font_shadow_color", Color(0.459, 0.141, 0.22))
