class_name PlayerStateDeath extends PlayerState

const DEATH_AUDIO = preload("uid://cwe3kr24it6ic")




#what happens when we enter State.
func enter() -> void:
	#play animation
	player.anim_player.play("Death")
	Audio.play_spatial_sound(DEATH_AUDIO, player.global_position)
	Audio.play_music(null)
	await player.anim_player.animation_finished
	PlayerHud.show_game_over()
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	return null


#What happens each process tick
func process(_delta:float) -> PlayerState:

	return null


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = 0
	return null
