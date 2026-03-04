class_name PlayerStateJump extends PlayerState


#region state references
@export var jump_velocity:float = 450
@export_range(0,1) var decelerate_on_jump_release = 0.5

@onready var jump_audio: AudioStreamPlayer2D = %JumpAudio

#endregion


# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	if player.is_on_floor():
		VisualEffects.jump_dust(player.global_position)
	else:
		VisualEffects.hit_dust(player.global_position)
	player.anim_player.play("Jump")
	player.anim_player.pause()
	
	do_jump()
	
	#check if buffer jump
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y = decelerate_on_jump_release
		player.change_state(fall)
		pass
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(event:InputEvent) -> PlayerState:
	if event.is_action_pressed("attack"):
		return attack
	if event.is_action_released( "jump" ):
		return fall
	return next_state


#What happens each process tick
func process(_delta:float) -> PlayerState:
	set_jump_frame()
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.walk_speed
	return next_state

func do_jump()->void:
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	player.jump_count += 1
	player.velocity.y = -jump_velocity
	jump_audio.play()
	pass


func set_jump_frame() -> void:
	var frame:float = remap(player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5)
	player.anim_player.seek(frame, true) 
	pass
	
	
