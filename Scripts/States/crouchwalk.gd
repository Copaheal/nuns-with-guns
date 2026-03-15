class_name PlayerStateCrouchWalk extends PlayerState

var on_floor:bool = true

@export var jump_velocity:float = 400

@onready var crouch_ray_up: RayCast2D = %CrouchRayUp
@onready var crouch_ray_down: RayCast2D = %CrouchRayDown
@onready var jump_audio: AudioStreamPlayer2D = %JumpAudio
@onready var land_audio: AudioStreamPlayer2D = %LandAudio


# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	player.slide_count = 0
	player.anim_player.play("CrouchWalk")
	
	player.collision_stand.disabled = true
	player.collision_crouch.disabled =  false
	player.collision_crouch.position.y = -13
	player.dastand.disabled = true
	player.dacrouch.disabled = false
	
	#Visual
	#Audio
	pass


#What happens when we exit state.
func exit() -> void:
	player.anim_player.speed_scale = 1
	player.collision_stand.disabled =  false
	player.collision_crouch.disabled = true
	player.dastand.disabled =  false
	player.dacrouch.disabled = true
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_slide():
		return slide
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("jump"):
		if player.is_on_floor():
			if Input.is_action_pressed("down"):
				player.platform_shapec.force_shapecast_update()
				if player.platform_shapec.is_colliding():
					player.position.y += 4
					return fall
			player.velocity.y -= jump_velocity
			jump_audio.play()
			VisualEffects.jump_dust(player.global_position)
	if _event.is_action_released("crouch") or _event.is_action_pressed("crouch"):
		if _can_stand():
			if player.is_on_floor():
				return idle
			return fall
	return null


#What happens each process tick
func process(_delta:float) -> PlayerState:
	if player.direction.x == 0:
		player.anim_player.speed_scale = 0
	else:
		player.anim_player.speed_scale = 1
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = player.direction.x * player.walk_speed
	
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			VisualEffects.land_dust(player.global_position)
			land_audio.play()
	return next_state

func _can_stand()->bool:
	crouch_ray_up.force_raycast_update()
	crouch_ray_down.force_raycast_update()
	if crouch_ray_down.is_colliding() and crouch_ray_up.is_colliding():
		return false
	return true
