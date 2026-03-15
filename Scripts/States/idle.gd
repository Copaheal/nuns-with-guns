class_name PlayerStateIdle extends PlayerState

# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	player.anim_player.play("Idle")
	player.jump_count = 0
	player.dash_count = 0
	player.slide_count = 0
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_slide():
		return slide
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
	if player.direction.x !=0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
