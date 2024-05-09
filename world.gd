class_name World
extends Node2D

#@onready var rogue_ui: CharacterUI = %RogueUI
#@onready var huntress_ui: CharacterUI = %HuntressUI
@onready var character_uis: Node2D = %CharacterUIs
@onready var rogue_ui: CharacterUI = %RogueUI
@onready var huntress_ui: CharacterUI = %HuntressUI




@onready var marker_start: Marker2D = $MarkerStart
@onready var marker_end: Marker2D = $MarkerEnd

@onready var markers: Node2D = $Markers
@onready var marker_lt: Marker2D = %MarkerLT
@onready var marker_lb: Marker2D = %MarkerLB
@onready var marker_rt: Marker2D = %MarkerRT
@onready var marker_rb: Marker2D = %MarkerRB


func _ready() -> void:
	#moves the sprites to proper initial positions and scales them up
	rogue_ui.scale_sprite(4)
	rogue_ui.global_position = marker_lt.position
	
	huntress_ui.scale_sprite(4)
	huntress_ui.turn_around()
	huntress_ui.global_position = marker_rt.position







func _input(event):
	if event.is_pressed() and not event.is_echo():
		if Input.is_key_pressed(KEY_Q):
			#this will try to animate an attack using a skill resource
			skill_attack()
		elif Input.is_key_pressed(KEY_W):
			#this animates an attack straight from World
			rogue_attack()




func rogue_attack() -> void:
	#I set these vars so the variable names are the same in the skill.gd
	var actor_ui = rogue_ui
	var target_ui = huntress_ui
	
	
	# v- From here on, this is copied directly into skill.perform_skill()
	var home_base: Vector2 = actor_ui.position
	var target_pos: Vector2 = target_ui.front
	
	await actor_ui.loop_while_moving_line("walk", home_base, target_pos, 12.0)
	
	await actor_ui.animate_once("attack_heavy")
	target_ui.animate_once("hit")
	
	actor_ui.turn_around()
	
	await actor_ui.loop_while_moving_line("walk",actor_ui.global_position, home_base, 8.0)
	
	actor_ui.animate_loop("idle")
	
	actor_ui.turn_around()
	# ^- All of that was copied directly into perform_skill()





func skill_attack() -> void:
	var new_skill: Skill = preload("res://skill/skill.gd").new() as Skill
	
	#I'm manually setting the vars in skill.gd
	new_skill.actor_ui = rogue_ui
	new_skill.target_ui = huntress_ui
	
	new_skill.perform_skill()
