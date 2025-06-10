extends Area2D
@onready var wheat: Sprite2D = $Wheat
var ready_to_grow: bool = false
@onready var timer: Timer = $Timer
var full_grown: bool :
	get: return wheat.frame == 2


func _ready() -> void:
	pass # Replace with function body.

func timer_start():
	timer.start()


func _process(delta: float) -> void:
	pass

func crop_age():
	if wheat.frame < 2 :
		wheat.frame += 1
		


func _on_timer_timeout() -> void:
	var parent = get_parent().get_parent()
	ready_to_grow = true
	if ready_to_grow:
		parent._updateCrops()
		ready_to_grow = false
		
