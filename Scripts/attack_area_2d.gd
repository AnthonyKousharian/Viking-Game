extends Area2D



func _ready() -> void:
	$".".monitoring = false
	pass




func _on_body_entered(body: CharacterBody2D) -> void:
	print("take_damage")
