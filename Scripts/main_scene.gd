extends Node2D

@onready var main_scene: Node2D = $"."
@onready var in_game_menu = preload("res://Scenes/in_game_menu.tscn")
@onready var menuInstance = in_game_menu.instantiate()
@onready var ui: Control = $UI
@onready var fps_counter: Label = $Player/FPSCounter

func _ready() -> void:
	
	#makes all children pausable so pausing actually works
	var childrenArray = get_children()
	for child in childrenArray:
			child.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	ui.process_mode = Node.PROCESS_MODE_ALWAYS
	
	ui.add_child(menuInstance)
	menuInstance.visible = false
	
	#makes main code not pausable so that the pausing code can run
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Open Menu") and not get_tree().paused:
		menuInstance.visible = true
		get_tree().paused = true
		process_mode = Node.PROCESS_MODE_ALWAYS
	else: if Input.is_action_just_pressed("Open Menu"):
		get_tree().paused = false
		menuInstance.visible = false
		
	fps_counter.text = str(Engine.get_frames_per_second())
	pass
