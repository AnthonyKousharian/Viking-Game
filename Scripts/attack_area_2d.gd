extends Area2D



func _ready() -> void:
	$".".monitoring = false
	pass




func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("take_damage"):
		var direction = body.global_position - global_position
		body.take_damage(direction)
