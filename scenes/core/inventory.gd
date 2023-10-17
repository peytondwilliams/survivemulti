extends Control

const INVENTORY_ITEM = preload("res://scenes/core/inventory_item.tscn")
@onready var items_node = $Items

var center_point = Vector2.ZERO
var central_force_pow = 1.5
var central_force_div_scale = 100
var seperation_force_pow = 2
var seperation_force_scale = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_pos = Vector2.ZERO
	for i in range(10):
		var new_item = INVENTORY_ITEM.instantiate()
		new_item.position = spawn_pos
		spawn_pos += Vector2(10, pow(2, i))
		items_node.add_child(new_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var items = items_node.get_children()
	
	for item in items:
		var new_force := Vector2.ZERO
		
		#investigate if central force should be static
		var central_force_normal = (center_point - item.position).normalized()
		var central_force_mag_scaled = pow((center_point - item.position).length(), central_force_pow) / central_force_div_scale
		var central_force = central_force_normal * central_force_mag_scaled
		
		var seperation_force := Vector2.ZERO
		for item_j in items:
			if item_j == item:
				continue
			
			var seperation_force_normal = (item_j.position - item.position).normalized()
			var div_val = (item_j.position - item.position).length() + 0.01
			var seperation_force_mag_scaled = (1 / pow(div_val, seperation_force_pow)) * seperation_force_scale
			seperation_force += seperation_force_normal * seperation_force_mag_scaled
			
		print("central", central_force)
		print("seperation", seperation_force)
		seperation_force *= -1
		item.boid_force = (central_force + seperation_force) / 10
		

		#apply forces
		
