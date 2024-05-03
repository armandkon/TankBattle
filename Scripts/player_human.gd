extends CharacterBody2D

class_name Player_Human

@onready var health_system = $HealthSystem as HealthSystem
@onready var shooting_system = $ShootingSystem as ShootingSystem

@export var damage_per_bullet = 5
@export var speed = 200
@export var rotation_speed = 20

var movement_direction: Vector2 =  Vector2.ZERO
var angle
var syncPos = Vector2(0, 0)
var syncRot = 0

func _ready():
	health_system.died.connect(on_died)
	
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():		
		$CanvasLayer.visible = true
		shooting_system.shot.connect(on_shot)	
	else:
		$CanvasLayer.visible = false
	
		#shooting_system.gun_reload.connect(on_gun_reload)
		#shooting_system.ammo_added.connect(on_ammo_added)

func _physics_process(delta):
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		
		velocity = movement_direction * speed	
		if angle:
			global_rotation = lerp_angle(global_rotation, angle, delta * rotation_speed)
		
		syncPos = global_position
		syncRot = rotation_degrees
		
		move_and_slide()
	else:
		global_position = global_position.lerp(syncPos, 0.5)
		rotation_degrees = lerpf(rotation_degrees, syncRot, 0.5)
		
func _input(event):
	
	if Input.is_action_pressed("move_down"):
		movement_direction = Vector2.DOWN
	elif Input.is_action_pressed("move_up"):
		movement_direction = Vector2.UP
	elif Input.is_action_pressed("move_right"):
		movement_direction = Vector2.RIGHT
	elif Input.is_action_pressed("move_left"):
		movement_direction = Vector2.LEFT
	else:
		movement_direction = Vector2.ZERO
	
	angle = (get_global_mouse_position() - global_position).angle()
	
func take_damage(damage: int):
	health_system.take_damage(damage)
	print(health_system.current_health)

func on_died():
	queue_free()

func on_shot(ammo_in_magazine: int):
	#print("ammo: ",ammo_in_magazine)
	#print("Shot!")
	pass

#func on_shot(ammo_in_magazine: int):
	#player_ui.bullet_shot(ammo_in_magazine)

#func on_gun_reload(ammo_in_magazine: int, ammo_left: int):
	#player_ui.gun_reloaded(ammo_in_magazine, ammo_left)

func on_ammo_pickup():
	shooting_system.on_ammo_pickup()

#func on_ammo_added(total_ammo: int):
	#player_ui.set_ammo_left(total_ammo)

func on_health_pickup(health_to_restore: int):
	health_system.current_health += health_to_restore
	#player_ui.life_bar.value += health_to_restore
