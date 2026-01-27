class_name PlayerStateJump extends PlayerState


#region state references
@export var jump_velocity:float = 450
@export_range(0,1) var decelerate_on_jump_release = 0.5

#endregion


# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	player.anim_player.play("Jump")
	player.velocity.y = -jump_velocity
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(event:InputEvent) -> PlayerState:
	if event.is_action_released( "jump" ):
		player.velocity.y = decelerate_on_jump_release
		return fall
	return next_state


#What happens each process tick
func process(_delta:float) -> PlayerState:

	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.walk_speed
	return next_state
