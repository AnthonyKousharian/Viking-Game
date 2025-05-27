extends Node

@export var spawners: Array[Node]

@onready var wave_button: Button = $"../WaveButton"

func _ready():
	wave_button.text = "Start Wave"
	wave_button.pressed.connect(_on_wave_button_pressed)

func _on_wave_button_pressed():
	for spawner in spawners:
		spawner.spawn_wave()
