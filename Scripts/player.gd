extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var crouch_rayc1: RayCast2D = $CrouchRaycast1
@onready var crouch_rayc2: RayCast2D = $CrouchRaycast2

@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.1

@export var jump_force = -400
@export_range(0,1) var decelerate_on_jump_release = 0.5
var can_coyote_jump = false
var jump_buffered = false

@export var dash_speed  = 1000.0
@export var dash_max_distance = 200
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

const GRAVITY_NORMAL: = 14.5
const GRAVITY_WALL = 8.5
var is_wall_sliding = false

var is_crouching = false
var stuck_under_object = false
var standing_cshape = preload("res://resrouces/Knight_Standing_Collision_Shape.tres")
var crouching_cshape = preload("res://resrouces/Knight_Crouching_Collision_Shape.tres")


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x !=0 and (can_coyote_jump == false):
		velocity.y = GRAVITY_WALL
	else:
		velocity.y += GRAVITY_NORMAL

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump()

	#Variable Jump.
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release

	#walk/run speed
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		
	#Wall slide
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			anim_player.play("Wall Slide")
			is_wall_sliding = true
		if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
			is_wall_sliding = false
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += (GRAVITY_WALL * delta)
		velocity.y = min(velocity.y,GRAVITY_WALL)
		
	# Flip Sprite
	if direction != 0:
		switch_direction(direction)
	
	#Crouch logic
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if above_head_clear():
			stand()
		else:
			if stuck_under_object != true:
				stuck_under_object = true
	
	if stuck_under_object and above_head_clear():
		stand()
		stuck_under_object = false
	
	#play Animations 
	update_animation(direction)
	
	#Dash Activation
	dash(direction, delta)

		#Coyote Timer
	var was_on_floor = is_on_floor()

	move_and_slide()
	
	#start of fall
	if was_on_floor and !is_on_floor() and velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	#touched ground
	if !was_on_floor and is_on_floor():
		if jump_buffered:
			jump_buffered = true
			jump()
			
	

func above_head_clear() -> bool:
	var result = !crouch_rayc1.is_colliding() and !crouch_rayc2.is_colliding()
	return result
	
func jump():
	if is_on_floor() or is_on_wall() or can_coyote_jump:
		velocity.y = jump_force
		if can_coyote_jump:
			can_coyote_jump = false
	else:
		if !jump_buffered:
			jump_buffered = true
			jump_buffer_timer.start()
	
func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false

func update_animation(direction):
	if is_on_floor() and !is_wall_sliding:
		if direction == 0:
			if is_crouching:
				anim_player.play("Crouch")
			else:
				anim_player.play("Idle")
		else:
			if is_crouching:
				anim_player.play("Crouch Walk")
			else:
				anim_player.play("Run")
	else:
		if is_crouching == false:
			if !is_wall_sliding and velocity.y < 0:
				anim_player.play("Jump")
			elif !is_wall_sliding and velocity.y > 0:
				anim_player.play("Falling")
		else:
			anim_player.play("Crouch")

func dash(direction, delta):
		#Dash Activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0 and not is_crouching:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		
	#Performs actual dash
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			anim_player.play("Dash")
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
				
	#Reduces the Dash Timer
	if dash_timer > 0:
		dash_timer -= delta

func switch_direction(direction):
	sprite.flip_h = (direction == -1)
	sprite.position.x = direction * 4

func crouch():
	if is_crouching:
		return
	is_crouching = true
	collision_shape.shape = crouching_cshape
	collision_shape.position.y = -12


func stand():
	if is_crouching == false:
		return
	is_crouching = false
	collision_shape.shape = standing_cshape
	collision_shape.position.y = -18
