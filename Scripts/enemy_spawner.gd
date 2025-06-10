extends Node

@export var enemy_scene: PackedScene
@export var spawn_zone: Node2D
@export var wave_counts: Array[int] = [2, 3, 5]  # Number of enemies to spawn per wave

var current_wave := 0

func spawn_wave():
	if current_wave >= wave_counts.size():
		print("No more waves for this spawner")
		return

	var count = wave_counts[current_wave]
	
	for i in count:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_zone.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		get_tree().current_scene.add_child(enemy)
	
	current_wave += 1
