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

var inventory := {}

@onready var interact_area := $InteractArea
@onready var interact_label := $CanvasLayer/UI/RichTextLabel
@onready var camera_2d = $Camera2D


func _ready():
	if player_multi_id == multiplayer.get_unique_id():
		camera_2d.enabled = true


func _physics_process(delta):
	
	if player_multi_id != multiplayer.get_unique_id():
		position = position.move_toward(_position, delta * SPEED * ACCEL * 2)
		velocity = velocity.move_toward(_velocity, delta * SPEED * ACCEL * 4)
		move_and_slide()
		return
		
	if interact_area.has_overlapping_areas():
		var nearby_area : CollisionObject2D = null
		for area : CollisionObject2D in interact_area.get_overlapping_areas():
			if area.is_in_group("interactable"):
				nearby_area = area
				break
		
		if nearby_area != null:
			interact_label.text = nearby_area.interact_text
			if Input.is_action_just_pressed("action_interact"):
				nearby_area.interact()
		else:
			interact_label.text = ""		
		
	elif interact_area.has_overlapping_bodies():
		var interact_body : CollisionObject2D = null
		for body : CollisionObject2D in interact_area.get_overlapping_bodies():
			if body.is_in_group("interactable"):
				interact_body = body
				break
		
		if interact_body != null:
			interact_label.text = interact_body.interact_text
			if Input.is_action_just_pressed("action_interact"):
				interact_body.interact()
		else:
			interact_label.text = ""
			
	movement(delta)


func movement(delta):
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
