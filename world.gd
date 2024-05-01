extends Node2D

@export var PlayerScene : PackedScene
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
		
	print("World is ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
