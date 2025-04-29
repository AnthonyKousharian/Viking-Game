extends CharacterBody2D

@export var speed: float = 100.0
@onready var player: Node2D = null

func _ready():
	# Find the player node in the scene (assuming the player is named "Player")
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
