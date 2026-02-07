@icon("res://Assets/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D



func _ready() -> void:
	visible = false
	await get_tree().process_frame
	#Check to see if already have player
	if get_tree().get_first_node_in_group("Player"):
		#We have a player!
		print("We have a player")
		return
		
	print("No player found")
	#Instantiate new instance of player scene
	var player:Player = load("uid://ddyfrooekrk0h").instantiate()
	get_tree().root.add_child(player)
	#Position Player Scene
	player.global_position = self.global_position
	
	pass
