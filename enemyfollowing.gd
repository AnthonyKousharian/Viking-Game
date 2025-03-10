extends CharacterBody2D

@export var speed: float = 100.0
@onready var player: Node2D = null
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# Find the player node in the scene (assuming the player is named "Player")
	player = get_tree().get_first_node_in_group("player")
	nav_agent.path_desired_distance = 4.0  # How close it should get before stopping
	nav_agent.target_desired_distance = 8.0

func _process(delta):
	if player:
		nav_agent.target_position = player.global_position  # Set target to player position

	if nav_agent.is_navigation_finished():
		return  # Stop if the path is complete

	var next_path_position = nav_agent.get_next_path_position()  # Get next step in path
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
