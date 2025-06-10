extends CanvasLayer

@onready var v_box_container: VBoxContainer = $"VBoxContainer"
@onready var description_label: Label = $"DescriptionLabel"
@onready var texture_rect: TextureRect = $"TextureRect"


const BOAT_PART = preload("res://Resources/ShopItems/BoatPart.tres")
const WHEAT_SEEDS = preload("res://Resources/ShopItems/WheatSeeds.tres")
const HP_RUNE = preload("res://Resources/ShopItems/HPRune.tres")
const SPD_RUNE = preload("res://Resources/ShopItems/SPDRune.tres")
const AS_RUNE = preload("res://Resources/ShopItems/ASRune.tres")
const F_RUNE = preload("res://Resources/ShopItems/FRune.tres")


signal item_bought(item:Resource,amount_of_item:int) 
var amount_of_items = 6
var items_array = []


func _ready() -> void:
	v_box_container.visible = false
	
	items_array.resize(amount_of_items)
	items_array[0] = BOAT_PART
	items_array[1] = WHEAT_SEEDS
	items_array[2] = HP_RUNE
	items_array[3] = SPD_RUNE
	items_array[4] = AS_RUNE
	items_array[5] = F_RUNE
	
	for item in items_array:
		var item_button = Button.new()
		item_button.text = item.itemName
		v_box_container.add_child(item_button)
		item_button.mouse_entered.connect(_on_item_button_entered.bind(item_button,item))
		item_button.pressed.connect(_on_item_button_pressed.bind(item_button,item))
	
	
func _process(delta: float) -> void:
	pass

func _on_item_button_entered(item_button: Button, item: Resource) -> void:
	description_label.text = item.itemDescription + "\nPrice: $" + str(item.itemPrice) +"\nOwned:" + str(get_parent()._hasInventoryItem(item))

func _on_item_button_pressed(item_button: Button, item: Resource) -> void:
	if Input.is_action_pressed("Dodge"):
		item.itemStock = item.itemStock - 10
		item_bought.emit(item, 10)

	else:
		item.itemStock = item.itemStock - 1
		item_bought.emit(item, 1)

	if item.itemStock == 0:
		item_button.text = "SOLD OUT"
		item_button.disabled = true

	_on_item_button_entered(item_button,item)
	
func _on_shop_button_pressed() -> void:
	v_box_container.visible = !v_box_container.visible
