extends Area2D
@onready var wheat: Sprite2D = $Wheat
var full_grown: bool :
	get: return wheat.frame == 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func crop_age():
	if wheat.frame < 2:
		wheat.frame += 1
