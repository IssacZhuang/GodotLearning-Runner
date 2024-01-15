extends Node2D
class_name  Player

@export var speed = 10

func _ready():

	pass

func _process(delta):
	position += Vector2(speed * delta, 0)
	pass
