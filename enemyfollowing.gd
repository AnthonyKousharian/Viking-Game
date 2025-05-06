extends CharacterBody2D

@export var speed: float = 100.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	nav_agent.path_desired_distance = 4.0  
	nav_agent.target_desired_distance = 8.0  

func _physics_process(delta):
	if player:
		nav_agent.target_position = player.global_position  

	if nav_agent.is_navigation_finished():
		return  

	var next_path_position = nav_agent.get_next_path_position()  
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
