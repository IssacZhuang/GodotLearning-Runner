@tool
extends Sprite2D
class_name AnimSprite2D


@export var playSpeed = 1 
var timer = 0
var maxTime = 256

func _process(delta):
	timer += delta * playSpeed
	if timer > maxTime:
		timer -= maxTime
	frame = int(timer) % (hframes * vframes)
	pass
