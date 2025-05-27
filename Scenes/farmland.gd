extends Node2D


@onready var canvas_layer = $CanvasLayer
@onready var canvas_modulate = $DayNightCycle
@onready var ui = $CanvasLayer/DayNightCycleUI



func _ready() -> void:
	canvas_layer.visible = true
	canvas_modulate.time_tick.connect(ui.set_daytime)
	
