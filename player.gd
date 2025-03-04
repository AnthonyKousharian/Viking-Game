extends CharacterBody2D
@onready var sprite_2d = $PlayerSprite

#speed should be slow and painful so it feels nice to upgrade
#TODO: change speed to 175 once done with testing
const SPEED = 300.0

var attack_direction = "Right"


func _physics_process(delta: float) -> void:
	if((velocity.x > 1 || velocity.x < -1 || velocity.y > 1) && !velocity.y < -1):
		sprite_2d.animation = "walk"
	elif(velocity.y < -1):
		sprite_2d.animation = "back"
	else:
		sprite_2d.animation = "default"
	
	
	# To Stay looking left or right
	if Input.is_action_just_pressed('Left'):
		sprite_2d.flip_h = true
	if Input.is_action_just_pressed('Right'):
		sprite_2d.flip_h = false	
	

	# Handle up and down.
	var ydirection = Input.get_axis("Up", "Down")
	if ydirection:
		velocity.y = ydirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, 80)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 80)
	move_and_slide()
	
	# Directional Attacking
	if Input.is_action_just_pressed('Attack Left'):
		$AttackArea2D.monitoring = true
		attack_direction = "Left"
	elif Input.is_action_just_pressed('Attack Right'):
		$AttackArea2D.monitoring = true
		attack_direction = "Right"
	elif Input.is_action_just_pressed('Attack Up'):
		$AttackArea2D.monitoring = true
		attack_direction = "Up"
	elif Input.is_action_just_pressed('Attack Down'):
		$AttackArea2D.monitoring = true
		attack_direction = "Down"
