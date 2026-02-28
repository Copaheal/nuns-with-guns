class_name PlayerStateDeath extends PlayerState


@export var move_speed:float = 100
@export var invulnerable_duration:float = 0.5
var time:float = 0.0
var dir:float = 1.0
@onready var damage_area: DamageArea = %DamageArea
@onready var hurt_audio: AudioStreamPlayer2D = $"../../HurtAudio"



# What happens when state is initialized.
func init() -> void:
	damage_area.damage_taken.connect(_on_damage_taken)
	pass


#what happens when we enter State.
func enter() -> void:
	#play animation
	player.anim_player.play("Death")
	time = player.anim_player.current_animation_length
	damage_area.make_invulnerable(invulnerable_duration)
	Audio.play_spatial_sound(Audio.sfx_death_audio, player.global_position)
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	return null


#What happens each process tick
func process(_delta:float) -> PlayerState:
	time -= _delta
	if time <= 0:
		move_speed = 0
		get_tree().paused = true
		return null
	return null


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = move_speed * dir
	return null

func _on_damage_taken(attack_area:AttackArea)->void:
	if player.hp <= 0:
		player.change_state(self)
		if attack_area.global_position.x < player.global_position.x:
			dir = 1.0
		else:
			dir = -1.0
	pass
