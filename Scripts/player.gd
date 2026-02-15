class_name Player extends CharacterBody2D

#region // @onready variables

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var platform_shapec: ShapeCast2D = $PlatformShapeCast
@onready var crouch_rayc1: RayCast2D = $CrouchRaycast1
@onready var crouch_rayc2: RayCast2D = $CrouchRaycast2

#endregion

#region // @export  variables
#Walk/Run speed
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export var max_fall_velocity:float = 600
#Dash variables
@export var dash_speed  = 1000.0
@export var dash_max_distance = 200
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

#endregion

#region // State Machine Variables

var states:Array[ PlayerState ]
var current_state:PlayerState:
	get:return states.front()
var previous_state:PlayerState:
	get:return states[ 1 ]

#endregion

#region // Player stats

var hp:float = 20 : 
	set(value):
		hp = clampf(value, 0, max_hp)
		Messages.player_health_changed.emit(hp,max_hp)
		
var max_hp:float = 20 :
	set(value):
		max_hp = value
		Messages.player_health_changed.emit(hp,max_hp)
		
var dash:bool = false
var double_jump:bool = false
var ground_slam:bool = false
var slide:bool = false

#endregion

#region // Standard Variables

#Dash variables
var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

#Wall slide variables
const gravity: = 980
var gravity_multiplier:float = 1.0
const GRAVITY_WALL = 100
var is_wall_sliding = false

var direction:Vector2 = Vector2.ZERO

#endregion


func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") !=self:
		self.queue_free()
	initialize_states()
	self.call_deferred("reparent", get_tree().root)
	Messages.player_healed.connect(on_player_healed)
	Messages.back_to_title_screen.connect(queue_free)
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self)
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu:PauseMenu = load("res://PauseMenu/pause_menu.tscn").instantiate()
		add_child(pause_menu)
		return
	
	
	#Temp DEBUG
	if OS.is_debug_build():
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_MINUS:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp -= 10
				else:
					hp -= 2
			elif event.keycode == KEY_EQUAL:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp += 10
				else:
					hp += 2
	#End DEBUG
	
	change_state( current_state.handle_input( event ) )
	pass 


func _process(_delta: float) -> void:
	update_direction()
	change_state( current_state.process( _delta))
	pass

func _physics_process(_delta: float) -> void:

	# Gravity Logic
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000, max_fall_velocity)

	#Dash Activation
	#dash(_delta)
	move_and_slide()
	change_state( current_state.physics_process( _delta))



#State Functions
func initialize_states() -> void:
	states = []
	#gather all the states
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	#initialize all states
	for state in states:
		state.init()
	
	#set our first state
	current_state.enter()
	$Label.text = current_state.name
	pass

func change_state(new_state:PlayerState) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize( 3 )
	pass

func update_direction() -> void:
	var prev_direction:Vector2=direction
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("jump", "crouch")
	direction = Vector2(x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x <0:
			sprite.flip_h = true
			sprite.position.x = -5
		elif direction.x > 0:
			sprite.flip_h = false
			sprite.position.x = 5
	pass

#Ability Logic
#func dash(delta):
		##Dash Activation
	#if Input.is_action_just_pressed("dash") and direction.x and not is_dashing and dash_timer <= 0:
		#is_dashing = true
		#dash_start_position = position.x
		#dash_direction = direction
		#dash_timer = dash_cooldown
		#
	##Performs actual dash
	#if is_dashing:
		#var current_distance = abs(position.x - dash_start_position)
		#if current_distance >= dash_max_distance or is_on_wall():
			#is_dashing = false
			#anim_player.play("Falling")
		#else:
			#anim_player.play("Dash")
			#velocity.x = dash_direction.x * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			#velocity.y = 0
				#
	##Reduces the Dash Timer
	#if dash_timer > 0:
		#dash_timer -= delta

func on_player_healed(amount:float)->void:
	hp += amount
	print("Player healed for: ", amount)
	
	#audio/visual
	pass
