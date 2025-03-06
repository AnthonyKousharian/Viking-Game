extends Area2D



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	print("take_damage")
