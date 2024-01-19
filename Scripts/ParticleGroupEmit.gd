extends Node2D
class_name ParticleGroupEmit

# GPU particles array
var  particles : Array[GPUParticles2D]

func _ready():
	# Get all particles
	for child in get_children():
		if child is GPUParticles2D:
			particles.append(child)
	
	
	
	pass
	
func Emit():
	#play 
	for p in particles:
		p.emitting = true
	pass
