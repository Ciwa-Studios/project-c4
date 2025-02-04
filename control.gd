extends Control

@onready var p1_crosshair = $p1Crosshair
@onready var p2_crosshair = $p2Crosshair

@export var lower_bound : int
@export var upper_bound : int

var p1_pos : int
var p2_pos : int
var p1_locked := false
var p2_locked := false

func _ready() -> void:
	p1_pos = lower_bound
	p2_pos = lower_bound

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("p1_right") and p1_pos < upper_bound and !p1_locked:
		p1_pos += 1
	if Input.is_action_just_pressed("p1_left") and p1_pos > lower_bound and !p1_locked:
		p1_pos -= 1
	if Input.is_action_just_pressed("p1_place"):
		p1_locked = true
	if Input.is_action_just_pressed("p1_skill1"):
		p1_pos = randi_range(lower_bound, upper_bound)
	
	
	if Input.is_action_just_pressed("p2_right") and p2_pos < upper_bound and !p2_locked:
		p2_pos += 1
	if Input.is_action_just_pressed("p2_left") and p2_pos > lower_bound and !p2_locked:
		p2_pos -= 1
	if Input.is_action_just_pressed("p2_place"):
		p2_locked = true
	if Input.is_action_just_pressed("p2_skill1"):
		p2_pos = randi_range(lower_bound, upper_bound)
	
	choose_character(p1_pos, 1)
	choose_character(p2_pos, 2)
	
	if p1_locked and p2_locked:
		var game_scene = preload("res://Game/game.tscn")
		var new_scene = game_scene.instantiate()
		new_scene.p1_character = match_character(p1_pos)
		new_scene.p2_character = match_character(p2_pos)
		get_parent().add_child(new_scene)
		queue_free()
	
	p1_crosshair.position.x = 114 + 42 * p1_pos
	p2_crosshair.position.x = 114 + 42 * p2_pos

func choose_character(index, player):
	var label_text
	var image
	match index:
		1:
			image = 1
			label_text = "Angel"
		2:
			image = 0
			label_text = "Samurai"
		3:
			image = 1
			label_text = "Human"
	
	if player == 1:
		$CharacterSprites/Sprite2D.frame = image
		$MarginContainer/VBoxContainer/HBoxContainer/p1CharLabel.text = label_text
	if player == 2:
		$CharacterSprites/Sprite2D2.frame = image
		$MarginContainer/VBoxContainer/HBoxContainer/p2CharLabel.text = label_text

func match_character(index):
	match index:
		0:
			return "pharoh"
		1:
			return "angel"
		2:
			return "samurai"
		3:
			return "human"
