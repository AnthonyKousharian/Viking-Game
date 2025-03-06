extends Area2D

var playerScene = load("res://Scenes/player.tscn")
var playerNode = playerScene.get_node($Player)


func _ready() -> void:
	playerNode.add_child(self)



func _process(delta: float) -> void:
	pass
