extends Node2D

@export var player : int
@export var skill : int

@onready var animationPlayer = $AnimationPlayer

var energy : int
var skill_name : String
var color 
var player_turn
var turn_action


func _ready() -> void:
	
	if player == 1:
		color = Color(0.31, 0.561, 0.729)
	else:
		color = Color(0.647, 0.188, 0.188)
	$Node2D/ColorRect.color = color
	
	await get_tree().create_timer(0.2).timeout
	if player == 1:
		if skill == 1:
			skill_name = get_parent().p1_skill1
		if skill == 2:
			skill_name = get_parent().p1_skill2
	if player == 2:
		if skill == 1:
			skill_name = get_parent().p2_skill1
		if skill == 2:
			skill_name = get_parent().p2_skill2
	
	energy = get_parent().database.select_rows("skills", "skill = '" + skill_name + "'", ["cost"])[0]["cost"]
	$IconChooser.play(skill_name)
	
	

func _physics_process(_delta: float) -> void:
	turn_action = get_parent().turn_action
	player_turn = get_parent().player_turn
	
	if $VBoxContainer.get_child_count() < energy:
		create_energy()
	
	
#
	if turn_action == skill_name and player_turn == player:
		animationPlayer.play("Selected")
		#if animationPlayer.current_animation != "selected":
			#animationPlayer.play("Selected")
	elif turn_action != skill_name:
		if player == 1:
			if skill == 1 and Input.is_action_just_pressed("p1_skill1"):
				animationPlayer.play("Unselectable")
			if skill == 2 and Input.is_action_just_pressed("p1_skill2"):
				animationPlayer.play("Unselectable")
		if player == 2:
			if skill == 1 and Input.is_action_just_pressed("p2_skill1"):
				animationPlayer.play("Unselectable")
			if skill == 2 and Input.is_action_just_pressed("p2_skill2"):
				animationPlayer.play("Unselectable")
	else:
		animationPlayer.queue("RESET")

func create_energy():
	var new_energy = ColorRect.new()
	new_energy.custom_minimum_size.y = 1
	new_energy.color = color
	$VBoxContainer.add_child(new_energy)
	
	
