extends Area2D



func _ready() -> void:
	monitoring = false
	$AttackCollisionShape2D.disabled = true


func _process(delta: float) -> void:
	if monitoring and get_parent().attack_direction == "Left":
		$AttackCollisionShape2D.disabled = false
		
