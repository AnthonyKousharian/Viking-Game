extends Area2D
@onready var boat_sprite: AnimatedSprite2D = $BoatSprite
@onready var pre_event_prep: Timer = $PreEventPrep
@onready var boat_part_counter: Label = $BoatPartCounter

var playerNearby: bool = false
var partsNeeded: int = 5
var partsGot: int = 0

func _ready() -> void:
	boat_part_counter.text = str(partsGot) + "/" + str(partsNeeded) 



func _process(delta: float) -> void:
	pass

func boatPartUpdate():
	#check for  boatparts 
	boat_part_counter.text = str(partsGot) + "/" + str(partsNeeded) 
	

#30 second timer before true events starts
func eventStart():
	if partsNeeded <= partsGot:
		pre_event_prep.start
		boat_part_counter.hide()

#actual event starts
func _on_pre_event_prep_timeout() -> void:
	pass
