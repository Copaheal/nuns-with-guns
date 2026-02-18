@icon("res://Assets/icons/state.svg")
class_name PlayerState extends Node

var player:Player
var next_state:PlayerState

#region state references
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var attack: PlayerStateAttack = %Attack



#endregion


# What happens when state is initialized.
func init() -> void:
	pass


#what happens when we enter State.
func enter() -> void:
	pass


#What happens when we exit state.
func exit() -> void:
	pass


#What happens when an input is pressed/released
func handle_input(_event:InputEvent) -> PlayerState:
	
	return next_state


#What happens each process tick
func process(_delta:float) -> PlayerState:
	
	return next_state


#What happens each physics_process tick
func physics_process(_delta:float) -> PlayerState:
	return next_state
