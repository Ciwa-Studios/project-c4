extends Node2D

onready var particle  = $Particles2D

func _ready():
	particle.emitting = true
	particle.position -= Vector2(8, 8)
	var time = (particle.lifetime * 2) / particle.speed_scale
# warning-ignore:return_value_discarded
	get_tree().create_timer(time).connect("timeout", self, "queue_free")
