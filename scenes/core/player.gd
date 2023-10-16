extends CharacterBody2D

const SPEED = 50.0
const ACCEL = 3.0

# Set by the authority, synchronized on spawn.
@export var player_multi_id := 1 :
	set(id):
		player_multi_id = id
		# Give authority over the player input to the appropriate peer.
		# $PlayerInput.set_multiplayer_authority(id)

@export var _position := Vector2.ZERO
@export var _velocity := Vector2.ZERO

func _ready():
	if player_multi_id == multiplayer.get_unique_id():
		$Camera2D.enabled = true

func _physics_process(delta):
	
	if player_multi_id != multiplayer.get_unique_id():
		position = position.move_toward(_position, delta * SPEED * ACCEL * 2)
		velocity = velocity.move_toward(_velocity, delta * SPEED * ACCEL * 4)
		move_and_slide()
		return

	var direction = Input.get_vector("action_left", "action_right", "action_up", "action_down")
	if direction:
		velocity = velocity.move_toward(direction * SPEED, delta * SPEED * ACCEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * SPEED * ACCEL * 2)

	move_and_slide()
	rec_pos_vel.rpc_id(1, position, velocity)

@rpc("any_peer", "call_local", "unreliable_ordered")
func rec_pos_vel(new_position: Vector2, new_velocity: Vector2):
	_position = new_position
	_velocity = new_velocity
