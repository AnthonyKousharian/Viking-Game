extends Control

@onready var hot_bar_container: HBoxContainer = $HotBarHContainer
@onready var description_label: Label = $DescriptionLabel
@onready var hot_bar_panel: Panel = $HotbarPanel
@onready var hot_bar_item_h_container: HBoxContainer = $HotBarItemHContainer

const WHEAT_SEEDS = preload("res://Resources/ShopItems/WheatSeeds.tres")
const HP_RUNE = preload("res://Resources/ShopItems/HPRune.tres")
const SPD_RUNE = preload("res://Resources/ShopItems/SPDRune.tres")
const WHEAT = preload("res://Resources/ShopItems/Wheat.tres")

signal stat_upgrade(statUp: Resource,amount: int)

var amount_of_items = 6
var hot_bar_dictionary = {}

func _ready() -> void:

	hot_bar_panel.size.x = 100 * amount_of_items
	
	for i in range(0,amount_of_items):
		var slot_texture: TextureRect = TextureRect.new()
		slot_texture.texture = load("res://Sprites/UIsprites/Paper_Ui(Small).png")
		slot_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		slot_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		hot_bar_container.add_child(slot_texture)
	pass


func _process(delta: float) -> void:
	pass

func updateInventory():
	for item in hot_bar_dictionary:
		hot_bar_item_h_container.get_node(item.itemName).text = item.itemName + "\n" + str(hot_bar_dictionary.get(item))
		if hot_bar_dictionary[item] == 0:
			hot_bar_dictionary.erase(item)
			hot_bar_item_h_container.get_node(item.itemName).queue_free()

func _on_item_button_entered(item_button: Button, item: Resource) -> void:
	description_label.text = item.itemDescription + "\n"

func _on_item_bought(item: Resource, num: int):
	var isStat = false
	var newItem = item
	var wheatChance = 0
	
	if item.itemName == "Health Rune" or item.itemName == "Speed Rune" or item.itemName == "Attack Speed Rune" or item.itemName == "Farming Rune":
		stat_upgrade.emit(item,num)
		isStat = true
	
	wheatChance = randi_range(get_parent().get_parent().yieldMultiplier, 10)
	if hot_bar_dictionary.has(newItem) and not isStat:
		if newItem == WHEAT and wheatChance == 10:
			hot_bar_dictionary[newItem] += 2
		else:
			hot_bar_dictionary[newItem] += num

		hot_bar_item_h_container.get_node(newItem.itemName).text = newItem.itemName + "\n" + str(hot_bar_dictionary.get(newItem))

	else: if not isStat:
		hot_bar_dictionary[newItem] = 1
		var item_button = Button.new()
		item_button.name = newItem.itemName
		item_button.text = newItem.itemName + "\n" + str(hot_bar_dictionary.get(newItem))
		hot_bar_item_h_container.add_child(item_button)
		item_button.mouse_entered.connect(_on_item_button_entered.bind(item_button,newItem))

	print(newItem)
	print(num)
