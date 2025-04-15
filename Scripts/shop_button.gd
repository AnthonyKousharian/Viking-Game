extends Button

@onready var v_box_container: VBoxContainer = $"../VBoxContainer"
@onready var description_label: Label = $"../DescriptionLabel"


const BOAT_PART = preload("res://Resources/ShopItems/BoatPart.tres")
const WHEAT_SEEDS = preload("res://Resources/ShopItems/WheatSeeds.tres")
const HP_RUNE = preload("res://Resources/ShopItems/HPRune.tres")

var amount_of_items = 3
var items_array = []


func _ready() -> void:
	v_box_container.visible = false
	
	items_array.resize(amount_of_items)
	items_array[0] = BOAT_PART;
	items_array[1] = WHEAT_SEEDS;
	items_array[2] = HP_RUNE;
	
	for item in items_array:
		var item_button = Button.new()
		item_button.text = item.itemName
		v_box_container.add_child(item_button)
		item_button.mouse_entered.connect(_on_item_button_entered.bind(item_button,item))
		item_button.pressed.connect(_on_item_button_pressed.bind(item_button,item))

func _process(delta: float) -> void:
	pass

func _on_item_button_entered(item_button: Button, item: Resource) -> void:
	description_label.text = item.itemDescription + "\n" + "Price: $" + str(item.itemPrice)

func _on_item_button_pressed(item_button: Button, item: Resource) -> void:
	if Input.is_action_pressed("Dodge"):
		item.itemStock = item.itemStock - 10
	else:
		item.itemStock = item.itemStock - 1
	if item.itemStock == 0:
		item_button.text = "SOLD OUT"
		item_button.disabled = true

func _on_shop_button_pressed() -> void:
	v_box_container.visible = true
