class_name PlayerStateRun extends PlayerState

#region // State References

#endregion

# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	#play animation
	player.anim_player.play("Run")
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("jump"):
		return jump
	if _event.is_action_pressed("crouch"):
		return crouch_walk
	return next_state


#What happens each process tick
func process(_delta:float) -> PlayerState:
	if player.direction.x ==0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = player.direction.x * player.walk_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
