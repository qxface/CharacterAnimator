class_name CharacterUI
extends Node2D

signal trigger_skill_effect

@export var animated_sprite_2d: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var sprite_2d: Sprite2D

@export var base_scale : int = 1

@onready var _front: Marker2D = $TargetPoints/Front
@onready var _behind: Marker2D = $TargetPoints/Behind
@onready var _head: Marker2D = $TargetPoints/Head
@onready var _hold: Marker2D = $TargetPoints/Hold

var _front_base: Vector2
var _behind_base: Vector2
var _head_base: Vector2
var _z_index: int = 0

var behind: Vector2 : get = _get_behind
var front: Vector2 : get = _get_front
var head: Vector2 : get = _get_head

var animator
var sprite
var tween: Tween
var tween2: Tween

func _ready() -> void:
	_front_base = _front.position
	_behind_base = _behind.position
	_head_base = _head.position

	if animation_player:
		animator = animation_player
	elif animated_sprite_2d:
		animator = animated_sprite_2d
	else:
		push_error("No animation player or animated sprite found")
	
	if sprite_2d:
		sprite = sprite_2d
	elif animated_sprite_2d:
		sprite = animated_sprite_2d
	else:
		push_error("No sprite_2d or animated sprite found")
	
	#scale_sprite(4.0)
	animator.play("idle")

func _draw() -> void:
	pass
	#if Globals.debug:
		#draw_circle(_front.position, 5, Color.RED)
		#draw_circle(_head.position, 5, Color.BLUE)
		#draw_circle(_behind.position, 5, Color.GREEN)

func _get_behind() -> Vector2:
	return global_position + _behind.position

func _get_front() -> Vector2:
	return global_position + _front.position

func _get_head() -> Vector2:
	return global_position + _head.position

func scale_sprite(character_scale: float) -> void:
	sprite.scale = Vector2(character_scale * base_scale * sign(sprite.scale.x), character_scale * base_scale)
	
	_front.position = _front_base * character_scale * base_scale * sign(sprite.scale.x)
	_behind.position = _behind_base * character_scale * base_scale * sign(sprite.scale.x)
	_head.position = _head_base * character_scale * base_scale * sign(sprite.scale.x)
	
	queue_redraw()

func turn_around():
	if sprite.scale.x > 0:
		face_left()
	else:
		face_right()
	await get_tree().process_frame 

func face_left():
	if sprite.scale.x > 0:
		sprite.scale.x = -1 * abs(sprite.scale.x)
		swap_points()

func face_right():
	if sprite.scale.x < 0:
		sprite.scale.x = abs(sprite.scale.x)
		swap_points()

func swap_points():
	_hold.position = _behind.position
	_behind.position = _front.position
	_front.position = _hold.position
	
	await get_tree().process_frame 

func bring_forward() -> void:
	_z_index = z_index
	z_index = 100

func send_back() -> void:
	z_index = _z_index








func animate_once(animation: String) -> void:
	animation_player.play(animation)
	await animation_player.animation_finished
	
func animate_loop(animation: String) -> void:
	animation_player.play(animation)




func _move_line(animation: String, start_pos: Vector2, end_pos: Vector2, duration: float) -> void:
	if tween:
		if tween.is_running():
			return
	tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	animation_player.play(animation)
	tween.tween_property(self, "global_position", end_pos, duration).from(start_pos)
	await tween.finished

func loop_while_moving_line(animation: String, start_pos: Vector2, end_pos: Vector2, speed: float) -> void:
	if tween:
		if tween.is_running():
			return
	speed *= 100
	var distance: float = abs(start_pos.distance_to(end_pos))
	var duration: float = distance / speed
	
	await _move_line(animation, start_pos, end_pos, duration)

func move_while_animating_line(animation: String, start_pos: Vector2, end_pos: Vector2) -> void:
	if tween:
		if tween.is_running():
			return
	var anim: Animation = animation_player.get_animation(animation) as Animation
	var duration: float = anim.length
	
	await _move_line(animation, start_pos, end_pos, duration)
	animation_player.play("idle")



#
#
#func _move_arc(animation1: String, animation2: String, start_pos: Vector2, end_pos: Vector2, height: float, duration: float) -> void:
	#if tween:
		#if tween.is_running():
			#return
	#tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#animation_player.play(animation1)
	#tween.tween_property(self, "global_position:x", end_pos.x, duration).from(start_pos.x)
	#
	#var high_pos : int = min(start_pos.y, end_pos.y) - height
	#var jump_height : int = start_pos.y - height
	#if start_pos.y > end_pos.y:
		#jump_height = end_pos.y - height
	#
	#var tween_y_1 := create_tween().set_trans(Tween.TRANS_SINE)
	##tween_y_1.tween_property(self, "global_position:y", -height, duration * 0.5).as_relative().set_ease(Tween.EASE_OUT)
	#tween_y_1.tween_property(self, "global_position:y", high_pos, duration * 0.5).set_ease(Tween.EASE_OUT).from(start_pos.y)
	#
	#await tween_y_1.finished
	#animation_player.play(animation2)
	#
	#var tween_y_2 := create_tween().set_trans(Tween.TRANS_SINE)
	##tween_y_2.tween_property(self, "global_position:y", height, duration * 0.5).as_relative().set_ease(Tween.EASE_IN)
	#tween_y_2.tween_property(self, "global_position:y", end_pos.y, duration * 0.5).set_ease(Tween.EASE_IN)
#
	#await tween_y_2.finished
#
#func loop_while_moving_arc(animation1: String, animation2: String, start_pos: Vector2, end_pos: Vector2, height: float, speed: float) -> void:
	#if tween:
		#if tween.is_running():
			#return
	#speed *= 100
	#var distance: float = abs(start_pos.distance_to(end_pos))
	#var duration: float = distance / speed
	#
	#await _move_arc(animation1, animation2, start_pos, end_pos, height, duration)
	#animation_player.play("idle")
#
#func move_while_animating_arc(animation: String, start_pos: Vector2, end_pos: Vector2, height: float) -> void:
	#if tween:
		#if tween.is_running():
			#return
#
	#var duration: float = animation_player.get_animation(animation).length
	#
	#await _move_arc(animation, animation, start_pos, end_pos, height, duration)
	#animation_player.play("idle")
#
#
#
#func trigger_skill():
	#trigger_skill_effect.emit()
#
#func get_hit(damage: int, current_vp: int) -> void:
	#if damage > 0 && animator.is_playing():
		#animator.stop()
		#AnimationManager.animation_finished(self)
	#
	#AnimationManager.animation_starting(self)
	#
	##TODO - FALLING TEXT
	#
	#if damage > 0:
		#await animate_once("hit")
	#
	#if current_vp <= 0:
		#await animate_once("die")
	#
	#AnimationManager.animation_finished(self)
