extends HBoxContainer

@export var player : int
var health : int

func _ready() -> void:
	get_parent().connect("health_depleted", update_hearts)

func update_hearts(_p):
	if player == 1:
		health = get_parent().p1_health
	if player == 2:
		health = get_parent().p2_health
	var hearts = get_children()
	
	for i in range(health):
		hearts[i].update(true)
	
	for i in range(health, hearts.size()):
		hearts[i].update(false) 
