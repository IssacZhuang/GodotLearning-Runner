extends Node2D
class_name Game

#scene object
@export var player: Player
@export var camera: Node2D

#prefab
@export var bomb: PackedScene
@export var explosion : PackedScene

#player config
@export var playerInitialSpeed: float = 30
@export var playerSpeedAcceleration: float = 2
@export var playerJumpHeight: float = 10
@export var playerJumpDuration: float = 0.5

#camera shake config
@export var shakeSpring: float = 918
@export var shakeDamp: float = 16
@export var shakeMultiplier: float = 4

#bomb config
@export var BombSpawnOffset: float = 1000
@export var BombMinSpawnDistance: float = 40
@export var BombMaxSpawnDistance: float = 160
@export var BombHitRange: float = 32

#camera
var shakeVelocity: float
var shakeDisplacement: float
var shakeDirection: Vector3
var initialCameraHeight: float

#player state
var playerJumpTime: float
var playerSpeed: float

#bomb state
var bombNextSpawnPosition: float
var bombs: Array[Node2D]
var bombsPendingRemove: Array[Node2D]

#explosion instance
var explosionInt: ParticleGroupEmit

#game state
var timer: float
var isPlaying: bool

#tool
var random: RandomNumberGenerator

#lifecycle

func _ready():
	random = RandomNumberGenerator.new()
	initialCameraHeight= camera.position.y
	
	explosionInt = explosion.instantiate() as ParticleGroupEmit
	player.add_child(explosionInt)
	StartGame()
	pass
	

func _physics_process(delta):
	timer += delta
	
	UpdateCamera(delta)
	if !isPlaying:
		return
	
	UpdatePlayer(delta)
	UpdateBomb(delta)
	pass

func _unhandled_key_input(event):
	if event is InputEventKey:
		if !event.pressed:
			return
		if event.keycode == KEY_SPACE:
			PlayerJump()
		#debug spawn bomb
		if event.keycode == KEY_DOWN:
			SpawnBomb()
		if event.keycode == KEY_UP:
			ShakeCamera(50)

#action

func StartGame():
	timer = 0
	isPlaying = true
	player.state = player.PlayerState.Running
	playerSpeed = playerInitialSpeed
	playerJumpTime = -playerJumpDuration
	
func GameOver():
	player.state = player.PlayerState.Down
	player.position.y = 0
	ShakeCamera(50)
	explosionInt.Emit()
	isPlaying = false
	

func PlayerJump():
	print("player jump")
	if timer - playerJumpTime <= playerJumpDuration:
		return
	playerJumpTime = timer
	pass

func ShakeCamera(amount):
	shakeVelocity = amount
	shakeDirection = Vector3(randf(), randf(),randf()).normalized()
	pass

func SpawnBomb():
	print("bomb spawned")
	var spawnPosition = player.position.x + BombSpawnOffset
	var instance = bomb.instantiate() as Node2D
	instance.position.x = spawnPosition
	bombs.push_back(instance)
	add_child(instance)
	
#update 
	
func UpdateCamera(delta: float):
	#process shake
	var force = -shakeSpring*shakeDisplacement + shakeDamp*shakeVelocity
	shakeVelocity -= force*delta
	shakeDisplacement -= shakeVelocity*delta
	var shake = shakeDisplacement*shakeMultiplier*shakeDirection
	camera.position.y = initialCameraHeight + shake.y
	
	#follow player
	camera.position.x = player.position.x + shake.x
	pass

func UpdatePlayer(delta: float):
	#process jump
	var tJump = (timer - playerJumpTime)/playerJumpDuration
	tJump = clamp(tJump,0,1)
	player.position.y = -playerJumpHeight*tJump*(1-tJump)
	
	#move forward
	player.position.x += playerSpeed*delta
	playerSpeed += playerSpeedAcceleration*delta
	pass

func UpdateBomb(delta: float):
	if player.position.x >= bombNextSpawnPosition:
		SpawnBomb()
		bombNextSpawnPosition += random.randf_range(BombMinSpawnDistance, BombMaxSpawnDistance)
	
	for bombInt in bombs:
		if bombInt.position.x < player.position.x - BombSpawnOffset:
			bombsPendingRemove.push_back(bombInt)
			continue
			
		if bombInt.position.distance_to(player.position) <= BombHitRange:
			bombsPendingRemove.push_back(bombInt)
			GameOver()
			continue
			
	for bombInt in bombsPendingRemove:
		print("bomb cleared")
		bombs.erase(bombInt)
		remove_child(bombInt)
		
	bombsPendingRemove.clear()
	pass

