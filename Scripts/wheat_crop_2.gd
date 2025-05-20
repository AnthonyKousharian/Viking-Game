extends Area2D
@onready var wheat: Sprite2D = $Wheat
var ready_to_grow: bool = false
var full_grown: bool :
	get: return wheat.frame == 2


func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	pass

func crop_age():
	if wheat.frame < 2 and ready_to_grow:
		wheat.frame += 1
		

#TODO: currenlty ages without water, needs to age using seedManager.update()
#BUG: If planted in rapid scucession the crop grows from other timers. or a trick of the light?
func _on_timer_timeout() -> void:
	ready_to_grow = true#once crop grows set this back to false 
	crop_age()#should emit a signal(?)
	ready_to_grow = false #may need to place this elsewhere
#on signal received: run update in seed manager to check for crops 
