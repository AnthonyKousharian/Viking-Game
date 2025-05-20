extends Area2D
@onready var rock: AnimatedSprite2D = $Rock




func _process(delta: float) -> void:
	pass

#TODO put player on another collison layer and check for it
func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		rock.play("glow_start", 1.0, false)
	


func _on_body_exited(body: Node2D) -> void:
	if(body.name == "Player"):
		rock.play("glow_start", -1.0, true)
	
