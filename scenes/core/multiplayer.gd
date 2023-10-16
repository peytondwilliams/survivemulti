extends Node

const PORT = 4433

@onready var player_scn = preload("res://scenes/core/player.tscn")

var spawn_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Start paused.
	#get_tree().paused = true
	# You can save bandwidth by disabling server relay and peer notifications.
	#multiplayer.server_relay = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	print("click host")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(spawn_player)
	spawn_player(1)
	start_game()


func _on_connect_button_pressed():
	print("click connect")
	var ip_str : String = $UI/HBoxContainer/IPInput.text
	if ip_str == "":
		OS.alert("Need a remote to connect to.")
		return	
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_str, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
		
	multiplayer.multiplayer_peer = peer
	start_game()
		
		
func start_game():
	# Hide the UI and unpause to start the game.
	$UI.hide()
	#get_tree().paused = false
	#spawn_player.rpc_id(1, multiplayer.get_unique_id())
	
	
func spawn_player(new_id: int):
	var new_player = player_scn.instantiate()
	new_player.player_multi_id = new_id
	new_player._position = spawn_pos
	spawn_pos += Vector2(20, 20)
	$Level/Players.add_child(new_player, true)
	
