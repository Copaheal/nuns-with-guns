class_name PauseMenu extends CanvasLayer

#region // @onready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system_menu_button: Button = %SystemMenuButton

@onready var system: Control = %System
@onready var back_to_map_button: Button = %BackToMapButton
@onready var back_to_title_button: Button = %BackToTitleButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

var player:Player


func _ready() -> void:
	#grab player
	#show map
	show_pause_screen()
	system_menu_button.pressed.connect(show_system_menu)
	#audio setup
	setup_system_menu()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_menu_button.grab_focus()
	pass


func show_pause_screen()->void:
	pause_screen.visible = true
	system.visible = false
	pass

func show_system_menu()->void:
	pause_screen.visible = false
	system.visible = true
	back_to_map_button.grab_focus()
	pass

func setup_system_menu()->void:
	#set up sliders
	back_to_map_button.pressed.connect(show_pause_screen)
	back_to_title_button.pressed.connect(_on_back_to_title_pressed)
	pass

func _on_back_to_title_pressed()->void:
	#free player
	SceneManager.transition_scene("res://TitleScreen/TitleScreen.tscn", "", Vector2.ZERO, "up")
	get_tree().paused = false
	queue_free()
	pass
