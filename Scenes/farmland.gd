extends Node2D


@onready var canvas_layer = $CanvasLayer
@onready var canvas_modulate = $DayNightCycle
@onready var UI = $CanvasLayer/DayNightCycleUI
@onready var main_scene: Node2D = $"."
@onready var in_game_menu = preload("res://Scenes/in_game_menu.tscn")

const SHOP_UI = preload("res://Scenes/ShopUI.tscn")
const PLAYER_INVENTORY = preload("res://Scenes/player_inventory.tscn")

const BOAT_PART = preload("res://Resources/ShopItems/BoatPart.tres")

@onready var player_inventory = PLAYER_INVENTORY.instantiate()
@onready var menuInstance = in_game_menu.instantiate()
@onready var shopUInstance = SHOP_UI.instantiate()
@onready var ui: Control = $UI
@onready var seed_manager: Node = $SeedManager
@onready var partsLabel = $"Area2D/Boat Parts"

var inBoatArea: bool = false
var parts: int = 0

func _ready() -> void:
	canvas_layer.visible = true
	canvas_modulate.time_tick.connect(UI.set_daytime)
	
	
	#makes all children pausable so pausing actually works
	var childrenArray = get_children()
	for child in childrenArray:
			child.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	ui.process_mode = Node.PROCESS_MODE_ALWAYS
	
	$Player/UI.add_child(player_inventory)

	ui.add_child(menuInstance)
	menuInstance.visible = false
	
	main_scene.add_child(shopUInstance)
	shopUInstance.visible = false
	shopUInstance.process_mode = Node.PROCESS_MODE_ALWAYS
	
	player_inventory.process_mode = Node.PROCESS_MODE_ALWAYS
	
	shopUInstance.item_bought.connect(player_inventory._on_item_bought)
	seed_manager.item_bought.connect(player_inventory._on_item_bought)
	
	#makes main code not pausable so that the pausing code can run
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func _takeInventoryItem(item: Resource):
	if player_inventory.hot_bar_dictionary.has(item):
		player_inventory.hot_bar_dictionary[item] -= 1
		player_inventory.updateInventory()
		return true
	return false

func _process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("Open Menu") and not get_tree().paused:
		menuInstance.visible = true
		get_tree().paused = true
		
	else: if Input.is_action_just_pressed("Open Menu") and  not shopUInstance.visible:
		get_tree().paused = false
		menuInstance.visible = false
		
	if Input.is_action_just_pressed("Open Shop") and not get_tree().paused:
		shopUInstance.visible = true
		get_tree().paused = true
	
	else: if Input.is_action_just_pressed("Open Shop") and not menuInstance.visible:
		shopUInstance.visible = false
		get_tree().paused = false
	
	if Input.is_action_just_pressed("Interact") and player_inventory.hot_bar_dictionary.has(BOAT_PART):
		_takeInventoryItem(BOAT_PART)
		parts+=1
		partsLabel.text = "Parts: " + str(parts) + "/5"
		
		if parts >= 5:
			get_tree().change_scene_to_file("res://win_screen.tscn")
	
	
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		inBoatArea = true
		
	
func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		inBoatArea = false
		
