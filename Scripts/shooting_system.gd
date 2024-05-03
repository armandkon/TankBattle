extends Marker2D

class_name ShootingSystem

signal shot(ammo_in_magazine: int)
signal gun_reload(ammo_in_magazine: int, ammo_left: int)
signal ammo_added(total_ammo: int)

#@export var max_ammo = 10000
#@export var total_ammo = 10000
@export var magazine_size = 10

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")

var ammo_in_magazine = 0
var shoot_events
var isReloading = false

var crosshair_texture = preload("res://Sunny Land Collection Files/Packs/crosshair_white-export.png")
#var crosshair_texture = preload("res://Sunny Land Collection Files/Packs/crosshair_white.png")
#var crosshair_texture = preload("res://Sunny Land Collection Files/Packs/crosshair.png")

func _ready():
	Input.set_custom_mouse_cursor(crosshair_texture)
	ammo_in_magazine = magazine_size

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		if(!isReloading):
			shoot()
		else:
			print("Reloading, cant't shoot")
	if Input.is_action_just_pressed("reload"):
		if(!isReloading):
			reload()
		else:
			print("Already reloading, cant' reload")

func shoot():
		
	if $"../MultiplayerSynchronizer".get_multiplayer_authority() == multiplayer.get_unique_id():
		if ammo_in_magazine == 0:
			return
		ammo_in_magazine -= 1
		
# VERY IMPORTANT!
# should pass local_mouse_position as get_global_mouse_position() in fire() of the player
# shooting the bullet, else player 2 sees the bullet being shot from player 1 to the point
# player 2's cursor shows, even though it is located in player 1's screen
		var local_mouse_position = get_global_mouse_position()
		fire.rpc(local_mouse_position)
		
@rpc("any_peer", "call_local")		
func fire(local_mouse_position):
	var bullet = bullet_scene.instantiate() as Bullet
	
	bullet.bulletOwner = owner
	#print(bullet.bulletOwner)
	bullet.damage = owner.damage_per_bullet	
	
	var move_direction = (local_mouse_position - global_position).normalized()
	bullet.global_position = global_position
	bullet.move_direction = move_direction
	bullet.rotation = move_direction.angle()
	get_tree().root.add_child(bullet)
	shot.emit(ammo_in_magazine)	
		
func reload():	
	
	#if total_ammo <= 0:
		#print("Not enough ammo")
		#return
	
	isReloading = true
	$Timer.start()

func _on_timer_timeout():
	
	if(ammo_in_magazine < magazine_size):
		ammo_in_magazine += 1
		gun_reload.emit(ammo_in_magazine, 50) 
	
	if(ammo_in_magazine == magazine_size):
		isReloading = false
		$Timer.stop()
	
	#if(total_ammo > 0 && ammo_in_magazine < magazine_size):
		#total_ammo -= 1
		#ammo_in_magazine +=1
		#gun_reload.emit(ammo_in_magazine, total_ammo) 
	#
	#if ammo_in_magazine == magazine_size || total_ammo == 0 :
		#isReloading = false	
		#$Timer.stop()
	
#func on_ammo_pickup():
	#var ammo_to_add = max_ammo - total_ammo if total_ammo + magazine_size > max_ammo else magazine_size
	#total_ammo += ammo_to_add
	#ammo_added.emit(total_ammo)
