extends RigidBody2D

var boid_force = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	state.set_constant_force(boid_force)
