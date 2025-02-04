extends Node2D

func _ready() -> void:
	get_parent().connect("turn_changed", turn_changed)

func turn_changed():
	queue_free()
