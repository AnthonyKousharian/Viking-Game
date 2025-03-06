extends Area2D



func _ready() -> void:
	$Sprite2D.visible = false
	$".".monitoring = false
	pass


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	print("take_damage")
