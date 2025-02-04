extends Node2D

@onready var pieceTypeAnimations = $PieceType
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $sprite
@onready var placeCircle = preload("res://Game/VFX/place_circle_vfx.tscn")
@onready var deathParticles = preload("res://Game/VFX/death_particles.tscn")

var type = "normal"
var pos : Vector2
var chains_timer := 3

func _ready() -> void:
	get_parent().connect("turn_changed", turn_changed)
	add_child(placeCircle.instantiate())

func _process(_delta: float) -> void:
	if type:
		pieceTypeAnimations.play(type)

func change_type(new_type):
	type = new_type

func turn_changed():
	if type == "chains":
		chains_timer -= 1
		sprite.frame_coords.x += 1
		if chains_timer == 0:
			get_parent().destroy_piece(pos)
			queue_free()

func death():
	var particles = deathParticles.instantiate()
	particles.position = position
	get_parent().add_child(particles)
	name = "dead"
	sprite.modulate = Color(1.5, 1.5, 1.5)
	await  get_tree().create_timer(0.05).timeout
	queue_free()
