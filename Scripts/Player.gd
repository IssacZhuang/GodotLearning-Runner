@tool
extends Node2D
class_name  Player

enum PlayerState {
	Running,
	Down
}

@export var speed = 10
@export var state: PlayerState :
	set(value):
		state = value
		_setState()

@export var stateRunning: Node2D
@export var stateDown: Node2D

func _ready():
	
	pass


func _setState():
	match state:
		PlayerState.Running:
		#not null
			if stateRunning != null:
				stateRunning.show()
				stateDown.hide()
			
		PlayerState.Down:
			if stateDown != null:
				stateDown.show()
				stateRunning.hide()
		_:
			pass
