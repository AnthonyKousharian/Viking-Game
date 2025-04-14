extends CharacterBody2D

@onready var sprite_2d = $PlayerSprite
@onready var attack_timer: Timer = %AttackTimer
@onready var attack_cooldown_timer: Timer = $AttackArea2D/AttackCooldownTimer  
@onready var attack_sprite_2d: AnimatedSprite2D = $AttackArea2D/Sprite2D
@onready var attack_area_2d: Area2D = $AttackArea2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#speed should be slow and painful so it feels nice to upgrade
#TODO: change speed to 175 once done with testing

@export var knockbackPower: int = 1000

var SPEED = 300.0

var playerRagDoll: bool = false

var currentHealth: int = 300
var invincibility: bool = false
var hearts_list: Array[TextureRect]




func _ready() -> void:
	var hearts_parent = $UI/HBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)
var attack_direction = "Right"


func _physics_process(delta: float) -> void:
	if !playerRagDoll:
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
		
	if invincibility: 
		$CollisionShape2D.disabled = true
		$Hitbox/CollisionShape2D.disabled = true
		
	move_and_slide()
	
	#Dodge
	if Input.is_action_just_pressed('Dodge'):
		invincibility = true
		SPEED = 1000
	if Input.is_action_just_released('Dodge'):
		invincibility = false
		SPEED = 300
	
	# Directional Attacking
	# the speed of the attack animation is relative to attack timer, so that the quicker you can attack
	# the quicker the animation is
	attack_timer.wait_time = 1
	attack_sprite_2d.speed_scale = 1/attack_timer.wait_time
	
	if Input.is_action_just_pressed('Attack Left') and not $AttackArea2D.monitoring:
		attack_area_2d.monitoring = true
		#attack_direction = "Left"
		attack_area_2d.position.x = -100
		attack_sprite_2d.rotation_degrees = 180
		attack_sprite_2d.play("default")
		attack_timer.start()
	elif Input.is_action_just_pressed('Attack Right') and not $AttackArea2D.monitoring:
		attack_area_2d.monitoring = true
		#attack_direction = "Right"
		attack_area_2d.position.x = 100
		attack_sprite_2d.rotation_degrees = 0
		attack_sprite_2d.play("default")
		attack_timer.start()
	elif Input.is_action_just_pressed('Attack Up') and not $AttackArea2D.monitoring:
		attack_area_2d.monitoring = true
		#attack_direction = "Up"
		attack_area_2d.position.y = -100
		attack_sprite_2d.rotation_degrees = -90
		attack_sprite_2d.play("default")
		attack_timer.start()
	elif Input.is_action_just_pressed('Attack Down') and not $AttackArea2D.monitoring:
		attack_area_2d.monitoring = true
		#attack_direction = "Down"
		attack_area_2d.position.y = 100
		attack_sprite_2d.play("default")
		attack_sprite_2d.rotation_degrees = 90
		attack_timer.start()
	else:
		await attack_sprite_2d.animation_finished
		await attack_timer.timeout
		attack_area_2d.monitoring = false
		attack_area_2d.position.x = 0
		attack_area_2d.position.y = 0



func _on_hitbox_body_entered(body):
	if body.is_in_group("enemies") and !invincibility:
		currentHealth-=1
		$Knockback.one_shot = true
		$Knockback.start()
		sprite_2d.play("hurt")
		playerRagDoll = true
		knockback(body.get_parent().get_node(body.get_path()).velocity)
		update_heart_display()
		$PlayerSprite.play("hurt")
		print(currentHealth)
		$Invincibility.one_shot = true
		$Invincibility.start()
		invincibility = true
	if currentHealth <= 0:
		get_tree().change_scene_to_file("res://end_screen.tscn")
		


func _on_invincibile_timeout():
	invincibility = false
	$CollisionShape2D.disabled = false
	$Hitbox/CollisionShape2D.disabled = false
	print("I frame end")
	$Invincibility.is_stopped()
	
func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < currentHealth	
		
func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity).normalized() * knockbackPower
	velocity = knockbackDirection
	


func _on_knockback_timeout():
	playerRagDoll = false
	$Knockback.is_stopped()
