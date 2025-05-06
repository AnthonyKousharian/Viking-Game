extends Node2D

@onready var main_scene: Node2D = $"."
@onready var in_game_menu = preload("res://Scenes/in_game_menu.tscn")

const SHOP_UI = preload("res://Scenes/ShopUI.tscn")

@onready var menuInstance = in_game_menu.instantiate()
@onready var shopUInstance = SHOP_UI.instantiate()
@onready var ui: Control = $UI
@onready var player_inventory: Control = $Player/UI/PlayerInventory

func _ready() -> void:

	
	#makes all children pausable so pausing actually works
	var childrenArray = get_children()
	for child in childrenArray:
			child.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	ui.process_mode = Node.PROCESS_MODE_ALWAYS
	
	ui.add_child(menuInstance)
	menuInstance.visible = false
	
	main_scene.add_child(shopUInstance)
	shopUInstance.visible = false
	shopUInstance.process_mode = Node.PROCESS_MODE_ALWAYS
	
	player_inventory.process_mode = Node.PROCESS_MODE_ALWAYS
	
	shopUInstance.item_bought.connect(player_inventory._on_item_bought)
	
	#makes main code not pausable so that the pausing code can run
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Open Menu") and not get_tree().paused:
		menuInstance.visible = true
		get_tree().paused = true
		
	else: if Input.is_action_just_pressed("Open Menu"):
		get_tree().paused = false
		menuInstance.visible = false
		
	if Input.is_action_just_pressed("Open Shop") and not get_tree().paused:
		shopUInstance.visible = true
		get_tree().paused = true
	
	else: if Input.is_action_just_pressed("Open Shop"):
		shopUInstance.visible = false
		get_tree().paused = false
	
	pass
