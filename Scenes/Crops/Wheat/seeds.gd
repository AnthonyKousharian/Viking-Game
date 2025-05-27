extends Area2D
@onready var ageing_component: AgeingComponent = $AgeingComponent

func age() -> void:
	ageing_component.current_stage += 1.0
