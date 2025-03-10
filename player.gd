extends CharacterBody2D
@onready var sprite_2d = $PlayerSprite


#speed should be slow and painful so it feels nice to upgrade
#TODO: change speed to 175 once done with testing
const SPEED = 300.0

var currentHealth: int = 4
var invincibility: bool = false
var hearts_list: Array[TextureRect]


func _ready() -> void:
	var hearts_parent = $UI/HBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)


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



func _on_hitbox_body_entered(body):
	if body.is_in_group("enemies") and !invincibility:
		currentHealth-=1
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
