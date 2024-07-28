extends Node2D

@export var PlayerScene : PackedScene
#@export var AIPlayerScene: PackedScene
#@onready var ai_spawn_location = $AISpawnLocation

#@export var PlayerUIScene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		#var currentPlayerUI = PlayerUIScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		#add_child(currentPlayerUI)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		
		index += 1
	
	# Replace with the correct path if AISPawnLocation is nested
	
	#if ai_spawn_location:
		#var ai_player = AIPlayerScene.instantiate()
		#add_child(ai_player)
		#ai_player.global_position = ai_spawn_location.global_position
	#else:
		#print("AISPawnLocation node not found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
