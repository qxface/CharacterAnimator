#Flurry
extends Skill

func perform_skill() -> void:
	super()
	print("Now do some flurry specific things")
	
	#var target_ui : CharacterUI = target_array[0].character_ui as CharacterUI
	
	var home_base: Vector2 = actor_ui.position
	var target_pos: Vector2 = target_ui.front
	
	await actor_ui.loop_while_moving_line("walk", home_base, target_pos, 12.0)
	
	await actor_ui.animate_once("attack_heavy")
	target_ui.animate_once("hit")
	
	actor_ui.turn_around()
	
	await actor_ui.loop_while_moving_line("walk",actor_ui.global_position, home_base, 8.0)
	
	actor_ui.animate_loop("idle")
	
	actor_ui.turn_around()
	

