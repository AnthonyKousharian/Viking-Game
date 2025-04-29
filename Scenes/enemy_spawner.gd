extends Node

@export var enemy_scene: PackedScene
@export var spawn_zone: Node2D
@export var waves: Array = [
	{"count": 3},
	{"count": 5},
	{"count": 7}
]

var current_wave :=0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WaveButton.text = "Start Wave"
	$WaveButton.pressed.connect(_on_wave_button_pressed)
	

func _on_wave_button_pressed():
	if current_wave >= waves.size():
		$WaveButton.text = "All waves completed"
		$WaveButton.disabled = true
		return
		
	spawn_wave(waves[current_wave]["count"])
	current_wave +=1
	$WaveButton.text = "Next Wave"
	
func spawn_wave(count: int):
	for i in count:
			var enemy = enemy_scene.instantiate()
			enemy.position = spawn_zone.global_position + Vector2(randf_range(-50,50), randf_range(-50,50))
			get_tree().current_scene.add_child(enemy)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
