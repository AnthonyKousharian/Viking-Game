class_name AgeingComponent
extends Node
#traks an objects age and can replace target scene
#into a new secene after reaching an age threshold



signal age_changed(new_stage: float, last_stage: float)
signal age_end_reached(new_scene : Node2D)

#when set, is the scene that will be replaced by next_stage
@export var target: Node2D
@export var current_stage: float = 0.0:
	set(value):
		if current_stage != value:
			var last_stage = current_stage
			current_stage=value
			emit_signal("age_changed", current_stage, last_stage)
			
			if current_stage >= stage_end && age_limit_reached != true:
				var new_scene : Node2D
				
				if next_stage != null:
					new_scene = _create_next_scene()
					
				emit_signal("age_end_reached", new_scene)
				age_limit_reached = true
				target.queue_free()
				return new_scene

@export var stage_end: float = 1.0
@export var next_stage: PackedScene
var age_limit_reached: bool = false
static var group_name = "AgeingPart"

func _ready():
	if(target ==null):
		target = get_parent()
		
	add_to_group(group_name)

func _create_next_scene() -> Node2D:
	var instance: Node2D = next_stage.instantiate()
	target.get_parent().add_child(instance)
	instance.global_transform = target.global_transform
	return instance
