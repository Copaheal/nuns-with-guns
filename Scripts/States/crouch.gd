class_name PlayerStateCrouch extends PlayerState

#region // State Variables

@export var deceleration_rate:float = 10

#endregion


# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	#play animation
	player.anim_player.play("Crouch")
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.collision_crouch.position.y = -13
	pass


#What happens when we exit state.
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if player.platform_rayc1.is_colliding() or player.platform_rayc2.is_colliding() == true:
			player.position.y += 4
			return fall
		return jump
	return next_state


#What happens each process tick
func process(_delta:float) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	if player.is_on_floor() == false:
		return fall
	return next_state
