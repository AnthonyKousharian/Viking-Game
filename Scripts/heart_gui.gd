extends Panel
@onready var heart: Sprite2D = %Heart

#update this to have 3 frames 
func update(whole : bool):
	if whole: heart.frame = 0
	else: heart.frame = 1
