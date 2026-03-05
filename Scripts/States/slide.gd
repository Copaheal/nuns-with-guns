class_name PlayerStateSlide extends PlayerState

const SLIDE_AUDIO = preload("uid://fa1aegl0l1ww")

@export var duration:float = 0.25
@export var speed:float = 300.0
@export var effect_delay:float = 0.05

var dir:float = 1.0
var time:float = 0.0
var effect_time:float = 0.0

@onready var damage_area: DamageArea = %DamageArea



# What happens when state is initialized.
func init() -> void:
	
	pass


#what happens when we enter State.
func enter() -> void:

	player.anim_player.play("Slide")
	time = duration
	effect_time = 0.0
	get_slide_direction()
	damage_area.make_invulnerable(duration)
	Audio.play_spatial_sound(SLIDE_AUDIO, player.global_position)
	
	player.gravity_multiplier = 0.0
	player.velocity.y = 0
	player.slide_count += 1
	player.collision_crouch.disabled = false
	player.collision_stand.disabled = true
	
	player.sprite.tween_color(duration)
	
	pass


#What happens when we exit state.
func exit() -> void:
	player.gravity_multiplier = 1.0
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	
	return null


#What happens each process tick
func process(_delta:float) -> PlayerState:
	time -= _delta
	if time <= 0:
		return idle
	
	effect_time -= _delta
	if effect_time < 0:
		effect_time = effect_delay
		player.sprite.ghost()
	
	return null


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = (speed * (time / duration) + speed) * dir
	return null

func get_slide_direction()->void:
	dir = 1.0
	if player.sprite.flip_h == true:
		dir = -1.0
	pass
