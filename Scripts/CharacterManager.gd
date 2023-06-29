extends Node

var p1_char
var p2_char

func manage():
	p1_char = Global.p1_char
	p2_char = Global.p2_char
	#Player1 variables:
	if p1_char == 0: #Robot
		Global.p1_s1 = 0 #p1 skill 1
		Global.p1_s2 = 1 #p1 skill 2
		Global.p1_max_cooldown_s1 = 5
		Global.p1_max_cooldown_s2 = 15
	if p1_char == 1: #Pharoah
		Global.p1_s1 = 2 #p1 skill 1
		Global.p1_s2 = 3 #p1 skill 2
		Global.p1_max_cooldown_s1 = 6
		Global.p1_max_cooldown_s2 = 17
	#Player2 Variables:
	if p2_char == 0: #Robot
		Global.p2_s1 = 0 #p1 skill 1
		Global.p2_s2 = 1 #p1 skill 2
		Global.p2_max_cooldown_s1 = 5
		Global.p1_max_cooldown_s2 = 15
	if p2_char == 1: #Pharoah
		Global.p2_s1 = 2 #p1 skill 1
		Global.p2_s2 = 3 #p1 skill 2
		Global.p2_max_cooldown_s1 = 6
		Global.p2_max_cooldown_s2 = 17
	
	Global.p1_cooldown_s1 = Global.p1_max_cooldown_s1
	Global.p1_cooldown_s2 = Global.p1_max_cooldown_s2
	Global.p2_cooldown_s1 = Global.p2_max_cooldown_s1
	Global.p2_cooldown_s2 = Global.p2_max_cooldown_s2
