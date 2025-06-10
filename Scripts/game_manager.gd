#TODO: Issue - different plots will automaticly use different crop seeds(?) 
#TODO: Issue - How to implement upgradable farm plots 
extends Node
#Crop resorces 
@onready var seeds = preload("res://Scenes/Crops/Wheat/WheatCrop2.tscn")
@onready var ground: TileMapLayer = $"../Ground"
@onready var player: CharacterBody2D = $"../Player"
@onready var crops: Node = $"../Crops"
@onready var seed_manager: Node = $"../SeedManager"
@onready var sell_bin: Area2D = $"../Interactables/SellBin"
@onready var main: Node2D = get_parent()#acceses player inventory and farmland

const WHEAT_SEEDS = preload("res://Resources/ShopItems/WheatSeeds.tres")
const WHEAT = preload("res://Resources/ShopItems/Wheat.tres")
#Healthbar UI
#TODO: put the camra into main scene and 
@onready var health_bar = "res://Scenes/UI Stuff/health_bar.tscn"
signal on_money_changed(amount:int)

#TODO: create more of a visual tell when placing seeds 
#TODO: fix draw placement of crops (coords of player should be at feet?)
#TODO: placement is finicky, add leniency/larger planting hitbox
func place_seeds():
	#coords is getting player position translating them to tilemap
	var coords = ground.local_to_map(ground.to_local(player.global_position))#tile coords
	var local_coords = ground.map_to_local(coords)#tilemap position using gridsnap
	#check player pos. and current ground if it's plantable 
	var data = ground.get_cell_tile_data(coords)#tile data at the prev. coords
<<<<<<< Updated upstream
	if data and data.get_custom_data("is_plot") and !data.get_custom_data("has_plant") and get_parent()._takeInventoryItem(WHEAT_SEEDS,1):
=======
	if data and data.get_custom_data("is_plot") and !data.get_custom_data("has_plant") and get_parent()._takeInventoryItem(WHEAT_SEEDS, 1):
>>>>>>> Stashed changes
		
		#instatiate wheat seeds
		var seedsinstance = seeds.instantiate()
		#move seeds to proper tile 
		crops.add_child(seedsinstance)
		seedsinstance.position = local_coords
		seed_manager.register(coords, seedsinstance)
		#kinda messy code(?)
		if  !data.get_custom_data("is_watered"):
			ground.set_cell(coords, 0, Vector2i(4,4))#makes ground unplantable(dry tile)
		if data.get_custom_data("is_watered"):
			ground.set_cell(coords, 0, Vector2i(4,3))#makes ground unplantable(wet tile)
			seed_manager.start_timer(coords)
			



func water_tile():
	var coords = ground.local_to_map(ground.to_local(player.global_position))
	var local_coords = ground.map_to_local(coords)
	var data = ground.get_cell_tile_data(coords)
	if data and data.get_custom_data("is_plot") and !data.get_custom_data("is_watered"):
		if !data.get_custom_data("has_plant"):
			ground.set_cell(coords, 0, Vector2i(0,3))
			#if data.get_custom_data("has_plant"):
			#seed_manager.seed_dict(coords)
		if data.get_custom_data("has_plant"):
			ground.set_cell(coords, 0, Vector2i(4,3))
			seed_manager.start_timer(coords)


func water_refill():
	pass

func harvest_crops():
	var coords = ground.local_to_map(ground.to_local(player.global_position))
	var local_coords = ground.map_to_local(coords)

	#check player pos. and current ground if it's unharvestable 
	var data = ground.get_cell_tile_data(coords)
	if data and data.get_custom_data("is_plot") and data.get_custom_data("has_plant"):
		if seed_manager.full_grown_harvest(coords):
<<<<<<< Updated upstream
			#TODO:update player enventory and add a wheat item 
			if !data.get_custom_data("is_watered"):
				ground.set_cell(coords, 5, Vector2i(0,4))#makes ground unplantable(dry tile)
=======
			
			if  !data.get_custom_data("is_watered"):
				ground.set_cell(coords, 0, Vector2i(0,4))#makes ground unplantable(dry tile)
>>>>>>> Stashed changes
			if data.get_custom_data("is_watered"):
				ground.set_cell(coords, 0, Vector2i(0,3))#makes ground unplantable(wet  tile)
			
			
			pass

func sell_items():
	var amount = sell_bin.sell_crops()
	on_money_changed.emit(amount)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	#TODO interact can be held down to place seeds
	if Input.is_action_just_pressed('Interact'):
		place_seeds()
		harvest_crops()
		sell_items()
		
		
	if Input.is_action_just_pressed('Water'):
		water_tile()
