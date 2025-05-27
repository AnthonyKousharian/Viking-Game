extends CharacterBody2D

@export var speed: float = 100.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = null

var health: int = 3


var knockback_velocity := Vector2.ZERO
var knockback_time := 0.2 
var knockback_timer := 0.0
var is_knocked_back := false


func _ready():
	player = get_tree().get_first_node_in_group("player")
	nav_agent.path_desired_distance = 4.0  
	nav_agent.target_desired_distance = 8.0  

func _physics_process(delta):
	if is_knocked_back:
		velocity = knockback_velocity
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
			velocity = Vector2.ZERO
	elif player:
		nav_agent.target_position = player.global_position

		if nav_agent.is_navigation_finished():
			return 

		var next_path_position = nav_agent.get_next_path_position()  
		var direction = (next_path_position - global_position).normalized()
		velocity = direction * speed
	move_and_slide()
	
func take_damage(from_direction := Vector2.ZERO):
	health -= 1
	print("Enemy took damage! Remaining HP:", health)
	knockback(from_direction)
	if health <= 0:
		die()

func die():
	print("Enemy died!")
	queue_free()
	
	
func knockback(from_velocity: Vector2):
	knockback_velocity = from_velocity.normalized() * 300 
	knockback_timer = knockback_time
	is_knocked_back = true
	print("Enemy knockback direction:", from_velocity)
