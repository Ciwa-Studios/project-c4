class_name crosshair
extends Node2D

@onready var animationPlayer = $AnimationPlayer

@export var move_speed : float

var pos : Vector2
var local_pos : Vector2
var player_turn : int
var turn_action : String
var lower_bound := Vector2.ZERO
var upper_bound := Vector2(9,9)
var actual_x
var actual_y
var locked : bool = false

func _ready() -> void:
	get_parent().connect("turn_changed", turn_changed)
	get_parent().connect("action_changed", change_animation)
	position = Vector2(159,53)

func _process(delta: float) -> void:
	player_turn = get_parent().player_turn
	if player_turn == 1:
		if Input.is_action_just_pressed("p1_right") and pos.x < upper_bound.x:
			pos += Vector2(1, 0) 
		if Input.is_action_just_pressed("p1_left") and pos.x > lower_bound.x:
			pos += Vector2(-1,0)
		if Input.is_action_just_pressed("p1_up") and pos.y > lower_bound.y:
			pos += Vector2(0,-1)
		if Input.is_action_just_pressed("p1_down") and pos.y < upper_bound.y:
			pos += Vector2(0,1)
		if Input.is_action_just_released("p1_move"):
			pos = pos.round()
	else:
		if Input.is_action_just_pressed("p2_right") and pos.x < upper_bound.x:
			pos += Vector2(1, 0) 
		if Input.is_action_just_pressed("p2_left") and pos.x > lower_bound.x:
			pos += Vector2(-1,0)
		if Input.is_action_just_pressed("p2_up") and pos.y > lower_bound.y:
			pos += Vector2(0,-1)
		if Input.is_action_just_pressed("p2_down") and pos.y < upper_bound.y:
			pos += Vector2(0,1)
		if Input.is_action_just_released("p2_move"):
			pos = pos.round()
	local_pos = Vector2(159,53) + (pos * 18)
	position = position.move_toward(local_pos, move_speed * delta)
	
	if turn_action == "star":
		$StarCrosshair/CrosshairBotLeft.show()
		$StarCrosshair/CrosshairBotRight.show()
		$StarCrosshair/CrosshairTopLeft.show()
		$StarCrosshair/CrosshairTopRight.show()
		$StarCrosshair/CrosshairBotLeft2.show()
		$StarCrosshair/CrosshairBotRight2.show()
		$StarCrosshair/CrosshairTopLeft2.show()
		$StarCrosshair/CrosshairTopRight2.show()
		$StarCrosshair/CrosshairBotLefeEdge.hide() 
		$StarCrosshair/CrosshairBotRightEdge.hide()
		$StarCrosshair/CrosshairTopLeftEdge.hide()
		$StarCrosshair/CrosshairTopRightEdge.hide()
		if pos.x == 0:
			$StarCrosshair/CrosshairBotLeft2.hide() 
			$StarCrosshair/CrosshairTopLeft2.hide()
			if pos.y == 0:
				$StarCrosshair/CrosshairTopLeftEdge.show()
			if pos.y == 9:
				$StarCrosshair/CrosshairBotLefeEdge.show()
		if pos.x == 9:
			$StarCrosshair/CrosshairBotRight2.hide()
			$StarCrosshair/CrosshairTopRight2.hide()
			if pos.y == 0:
				$StarCrosshair/CrosshairTopRightEdge.show()
			if pos.y == 9:
				$StarCrosshair/CrosshairBotRightEdge.show()
		if pos.y == 0:
			$StarCrosshair/CrosshairTopLeft.hide()
			$StarCrosshair/CrosshairTopRight.hide()
		if pos.y == 9:
			$StarCrosshair/CrosshairBotLeft.hide()
			$StarCrosshair/CrosshairBotRight.hide()
		

func change_animation():
	turn_action = get_parent().turn_action
	pos.x = actual_x if actual_x else pos.x
	actual_x = null
	pos.y = actual_y if actual_y else pos.y
	actual_y = null
	position = Vector2(159,53) + (pos * 18)
	if !locked:
		lower_bound = Vector2.ZERO
		upper_bound = Vector2(9,9)
	match turn_action:
		"place":
			animationPlayer.play("place")
		"star":
			animationPlayer.play("star")
		"cat_net":
			animationPlayer.play("3x3")
			if !locked:
				lower_bound = Vector2(1,1)
				upper_bound = Vector2(8,8)
		"sword":
			actual_y = pos.y
			pos.y = 5
			position = Vector2(159,53) + (pos * 18)
			animationPlayer.play("column")
			lower_bound.y = pos.y
			upper_bound.y = pos.y
		"sword_slash":
			actual_x = pos.x
			pos.x = 4
			position = Vector2(159,53) + (pos * 18)
			animationPlayer.play("row")
			lower_bound.x = pos.x
			upper_bound.x = pos.x
		"backpack":
			animationPlayer.play("3x3")
			if !locked:
				lower_bound = Vector2(1,1)
				upper_bound = Vector2(8,8)

func lock_crosshair():
	locked = true
	lower_bound = pos + Vector2(-1, -1)
	upper_bound = pos + Vector2(1, 1)
	if lower_bound.x < 0:
		lower_bound.x += 1
	if lower_bound.y < 0:
		lower_bound.y += 1
	if upper_bound.x > 9:
		upper_bound.x -= 1
	if upper_bound.y > 9:
		upper_bound.y -= 1
	var vfx = preload("res://Game/VFX/cat_net_vfx.tscn")
	var new_vfx = vfx.instantiate()
	new_vfx.position = position
	get_parent().add_child(new_vfx)

func turn_changed():
	locked = false
	lower_bound = Vector2.ZERO
	upper_bound = Vector2(9,9)
