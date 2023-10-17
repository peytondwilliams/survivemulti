extends Area2D

@onready var interact_text := "pickup wood"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


@rpc("any_peer", "call_local", "reliable")
func rec_interact():
	var picker_upper = multiplayer.get_remote_sender_id()
	#update inventory for picker_upper
	pickup.rpc()
	
func interact():
	rec_interact.rpc_id(1)

@rpc("authority", "call_local", "reliable")
func pickup():
	queue_free()
