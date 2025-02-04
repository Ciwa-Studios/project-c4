extends VBoxContainer

@export var player : int
var energy : int

func _ready() -> void:
	update_energy()
	get_parent().get_parent().connect("energy_changed", update_energy)

func update_energy():
	if player == 1:
		energy = get_parent().get_parent().p1_energy
	if player == 2:
		energy = get_parent().get_parent().p2_energy
	var hearts = get_children()
	
	for i in range(hearts.size() - energy, hearts.size()):
		hearts[i].update(true)
	
	for i in range(hearts.size() - energy):
		hearts[i].update(false) 
