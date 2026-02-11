@tool
@icon("res://Assets/icons/map_node.svg")
class_name MapNode extends Control

const SCALE_FACTOR:float = 20

#variables
@export_file("*tscn") var linked_scene:String:set = _on_scene_set
@export_tool_button("Update") var update_node_action = update_node

@onready var label: Label = $Label
@onready var transition_blocks: Control = %TransitionBlocks


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		label.queue_free()
		#create/display transition blocks
		#if scene has been discovered
	pass

func _on_scene_set(value:String)->void:
	if linked_scene != value:
		linked_scene = value
		if Engine.is_editor_hint():
			update_node()
	pass

func update_node()->void:
	print("Update Node")
	pass
