extends Node
var seed_dict: Dictionary = {}
var age_on_press:float = 1.0
@onready var ground: TileMapLayer = $"../Ground"

const WHEAT = preload("res://Resources/ShopItems/Wheat.tres")
const WHEAT_SEEDS = preload("res://Resources/ShopItems/WheatSeeds.tres")

signal item_bought(item:Resource,amount_of_item:int)

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
	#registers in game manager to keep track of crops
func register(location: Vector2i, plant: Node) -> bool:
	if seed_dict.has(location): return false
	seed_dict[location] = plant
	return true
	
func unregister(location: Vector2i) -> void:
	seed_dict.erase(location)
	
func start_timer(location: Vector2i):
	var tile_data = ground.get_cell_tile_data(location)
	if tile_data.get_custom_data("is_watered"):
		seed_dict[location].timer_start()
	if  !tile_data.get_custom_data("is_watered"):
		pass
		

func update() -> void:
	for location in seed_dict:
		var tile_data = ground.get_cell_tile_data(location) # gets the tile
		if tile_data.get_custom_data("is_watered") && seed_dict[location].ready_to_grow == true :
			seed_dict[location].crop_age()
			ground.set_cell(location, 0, Vector2i(4,4))
			
func updateOne(location: Vector2i):
	var tile_data = ground.get_cell_tile_data(location) # gets the tile
	if tile_data.get_custom_data("is_watered"):
		seed_dict[location].crop_age()
		ground.set_cell(location, 0, Vector2i(4,4))

#TODO: update so that you can upgrade the chance 
#chance to drop seeds when harvesting crops
func seedDropChance():
	var seed_chance: int = (randi() % 2 + 1)# prints and int between 1-2
	if seed_chance == 1:
		item_bought.emit(WHEAT_SEEDS,1)

#checks if crop age is fully grown and harvests if it is
func full_grown_harvest(location: Vector2i) -> bool: 
	if location in seed_dict and seed_dict[location].full_grown:
		seed_dict[location].queue_free()
		unregister(location)
		item_bought.emit(WHEAT,1)
		seedDropChance()
		return true
	else:
		return false 
	
