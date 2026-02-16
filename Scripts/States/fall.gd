class_name PlayerStateFall extends PlayerState


#region state references
@export var coyote_time:float = 0.2
@export var fall_gravity_multiplier:float = 1.165
@export var jump_buffer_time :float = 0.125

var coyote_timer:float = 0
var buffer_timer:float = 0

#endregion


# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	#play animation
	player.anim_player.play("Falling")
	player.anim_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	#set coyote timer
	if player.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time
	pass


#What happens when we exit state.
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			return jump
		else:
			buffer_timer = jump_buffer_time
		
	return next_state


#What happens each process tick
func process(delta:float) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	set_jump_frame()
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	if player.is_on_floor():
		VisualEffects.land_dust(player.global_position)
		Audio.play_spatial_sound(Audio.sfx_land_audio,player.global_position)
		if buffer_timer > 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.walk_speed
	return next_state

func set_jump_frame() -> void:
	var frame:float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.anim_player.seek(frame, true) 
	pass
