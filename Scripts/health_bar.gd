#TODO: integrate this into player or global scene 
extends HBoxContainer
@onready var heartContainer = preload("res://Scenes/UI Stuff/heart_gui.tscn") 

func setMaxHP(max: int):
	for i in range(max):
		var heart = heartContainer.instantiate()
		add_child(heart)

func updateHP(currentHP: int):
	var hearts = get_children()
	
	for i in range(currentHP): 
		hearts[i].update(true)
		
	for i in range(currentHP, hearts.size()):
		hearts[i].update(false)
