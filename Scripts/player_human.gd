extends CharacterBody2D

class_name Player_Human

@onready var health_system = $HealthSystem as HealthSystem
@onready var shooting_system = $ShootingSystem as ShootingSystem

@export var damage_per_bullet = 5

@export var player_ui: PlayerUI
@export var speed = 200
@export var rotation_speed = 5

var movement_direction: Vector2 =  Vector2.ZERO
var angle

func _ready():
	player_ui.set_life_bar_max_value(health_system.base_health)
	player_ui.set_max_ammo(shooting_system.magazine_size)
	player_ui.set_ammo_left(shooting_system.max_ammo)
	
	shooting_system.shot.connect(on_shot)
	shooting_system.gun_reload.connect(on_gun_reload)
	shooting_system.ammo_added.connect(on_ammo_added)

func _physics_process(delta):
	velocity = movement_direction * speed
	move_and_slide()
	
	if angle:
		global_rotation = lerp_angle(global_rotation, angle, delta * rotation_speed)
	
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
	player_ui.update_life_bar_value(health_system.current_health)

func on_shot(ammo_in_magazine: int):
	player_ui.bullet_shot(ammo_in_magazine)

func on_gun_reload(ammo_in_magazine: int, ammo_left: int):
	player_ui.gun_reloaded(ammo_in_magazine, ammo_left)

func on_ammo_pickup():
	shooting_system.on_ammo_pickup()

func on_ammo_added(total_ammo: int):
	player_ui.set_ammo_left(total_ammo)

func on_health_pickup(health_to_restore: int):
	health_system.current_health += health_to_restore
	player_ui.life_bar.value += health_to_restore
