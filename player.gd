extends CharacterBody2D

@onready var sprite_2d = $PlayerSprite
@onready var attack_timer: Timer = %AttackTimer
@onready var attack_cooldown_timer: Timer = $AttackArea2D/AttackCooldownTimer
@onready var attack_sprite_2d: Sprite2D = $AttackArea2D/Sprite2D
@onready var attack_area_2d: Area2D = $AttackArea2D

#speed should be slow and painful so it feels nice to upgrade
#TODO: change speed to 175 once done with testing
const SPEED = 300.0

var attack_direction = "Right"
var currentHealth: int = 10
var invincibility: bool = false


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
		
	if invincibility: 
		$CollisionShape2D.disabled = true
		$Hitbox/CollisionShape2D.disabled = true
		
	move_and_slide()
	
	# Directional Attacking
	
	if Input.is_action_just_pressed('Attack Left') and not $AttackArea2D.monitoring \
	and attack_cooldown_timer.is_stopped():
		attack_area_2d.monitoring = true
		#attack_direction = "Left"
		attack_area_2d.position.x = -100
		attack_sprite_2d.visible = true
		attack_timer.start()
		attack_cooldown_timer.start()
	elif Input.is_action_just_pressed('Attack Right') and not $AttackArea2D.monitoring \
	and attack_cooldown_timer.is_stopped():
		attack_area_2d.monitoring = true
		#attack_direction = "Right"
		attack_area_2d.position.x = 100
		attack_sprite_2d.visible = true
		attack_timer.start()
		attack_cooldown_timer.start()
	elif Input.is_action_just_pressed('Attack Up') and not $AttackArea2D.monitoring \
	and attack_cooldown_timer.is_stopped():
		attack_area_2d.monitoring = true
		#attack_direction = "Up"
		attack_area_2d.position.y = -100
		attack_sprite_2d.visible = true
		attack_timer.start()
		attack_cooldown_timer.start()
	elif Input.is_action_just_pressed('Attack Down') and not $AttackArea2D.monitoring \
	and attack_cooldown_timer.is_stopped():
		attack_area_2d.monitoring = true
		#attack_direction = "Down"
		attack_area_2d.position.y = 100
		attack_sprite_2d.visible = true
		attack_timer.start()
		attack_cooldown_timer.start()
	else:
		await attack_timer.timeout
		attack_sprite_2d.visible = false
		attack_area_2d.monitoring = false
		attack_area_2d.position.x = 0
		attack_area_2d.position.y = 0



func _on_hitbox_body_entered(body):
	if body.is_in_group("enemies") and !invincibility:
		currentHealth-=1
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
