extends StaticBody2D

const WOOD = preload("res://scenes/loot/wood.tscn")

@export var health := 3
@export var can_interact := true
@export var interact_text := "chop"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
@rpc("any_peer", "call_local", "reliable")
func rec_interact():
	chop.rpc()
	
func interact():
	rec_interact.rpc_id(1)

@rpc("authority", "call_local", "reliable")
func chop():
	health -= 1
	if health <= 0:
		can_interact = false
		$AnimationPlayer.play("fall")
		
func die():
	if multiplayer.get_unique_id() == 1:
		var item = WOOD.instantiate()
		item.position = position
		get_parent().add_child(item, true)
	queue_free()
