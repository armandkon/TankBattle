extends Area2D

class_name Bullet
var speed = 600
var move_direction: Vector2 = Vector2.ZERO
var damage
var bulletOwner = null

func _ready():
	move_direction = Vector2(1,0).rotated(rotation)

func _process(delta):
	global_position += move_direction * delta * speed


func _on_body_entered(body):
	
	if body != bulletOwner:
		if body is Player_Human:
			body.take_damage(damage)
		queue_free()
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
