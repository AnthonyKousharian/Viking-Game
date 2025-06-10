extends Area2D
@onready var rock: AnimatedSprite2D = $Rock
const WHEAT = preload("res://Resources/ShopItems/Wheat.tres")
var in_area: bool = false



func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		rock.play("glow_start", 1.0, false)
		in_area = true
	


func _on_body_exited(body: Node2D) -> void:
	if(body.name == "Player"):
		rock.play("glow_start", -1.0, true)
		in_area = false
	
func sell_crops() -> int:
	#funky code, gets the main scene to grab a function
	var main = get_parent().get_parent()
	var player_wheat = main._hasInventoryItem(WHEAT)
	print(str(player_wheat))
	if player_wheat > 0 && in_area:
		rock.play("light_flash", .75, false)
		main._takeInventoryItem(WHEAT, main._hasInventoryItem(WHEAT))
		var total = player_wheat * WHEAT.itemPrice
		return total#add this to 
	else:
		return 0
