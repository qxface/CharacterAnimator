class_name Skill
extends Resource

@export var skill_name: String = "Skill"

var actor_ui: CharacterUI
var target_ui: CharacterUI

var home_base: Vector2i

func perform_skill() -> void:
	# v- This is copied directly from world.rogue_attack() which runs perfectly
	var home_base: Vector2 = actor_ui.position
	var target_pos: Vector2 = target_ui.front
	
	await actor_ui.loop_while_moving_line("walk", home_base, target_pos, 12.0)
	
	await actor_ui.animate_once("attack_heavy")
	target_ui.animate_once("hit")
	
	actor_ui.turn_around()
	
	await actor_ui.loop_while_moving_line("walk",actor_ui.global_position, home_base, 8.0)
	
	actor_ui.animate_loop("idle")
	
	actor_ui.turn_around()
	# ^- That all came directly from world.rogue_attack()
