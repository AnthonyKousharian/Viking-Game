extends Button
@export var age_on_press:float = 1.0
@onready var seed_manager: Node = $"../SeedManager"


func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed():
	#seed_manager.update()
	seed_manager.update()
	
