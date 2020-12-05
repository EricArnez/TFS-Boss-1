extends "res://Character/Motion.gd"

#signal saliDeAcaLoco()

var speed:float = 1500.0
var velocity:Vector2
var direction:Vector2
onready var lighting: Line2D = get_parent().get_parent().get_node("Line2DLighting")

export(float) var base_max_horizontal_speed = 400.0

var coll:CollisionShape2D
export(float) var air_acceleration = 1000.0
export(float) var air_deceleration = 2000.0
export(float) var air_steering_power = 50.0

export(float) var gravity = 1600.0

var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()

var vertical_speed = 0.0
var height = 0.0

var hookPosition:Vector2
var enemy
var left_shot
var animated
var target

#func initialize(direction, speed, velocity, enemy):
func initialize(directio, speed, velocit, enem):
	self.direction = directio
	horizontal_speed = speed
	max_horizontal_speed = speed if speed > 0.0 else base_max_horizontal_speed
	self.hookPosition = enem.get_global_position()
	self.enemy = enem
	
func exit():
	pass

func handle_input(_event):
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		target = event.global_position

func enter():
	horizontal_velocity = enter_velocity
	vertical_speed = 800.0
	animated = get_parent().get_parent().get_node("BodyPivot/AnimatedSprite3")

func update(delta):
	speed = 1500
	velocity = self.direction * speed
	velocity.y += gravity * delta
	#screen shake
	#shake(duration, frequency, amplitude)
	owner.get_node("Camera2D").shake(0.02, 100, 2)
	lighting.set_default_color(ColorN("gold",1))
	lighting.width = 10
	lighting.visible = true
	left_shot = get_viewport().size.x / 2 < target.x
	if left_shot:
		animated.flip_h = false
		animated.play("tackle")
	else:
		animated.flip_h = true
		animated.play("tackle")
	#animated.play("tackle")
	var collider_data = owner.move_and_collide(velocity * delta)
	
	
	if collider_data:
		if collider_data.collider.is_in_group("enemy"):
			owner.get_node("Camera2D").shake(0.5, 100, 10)
			collider_data.collider.hitted()
			emit_signal("finished", "jump") 
		else:
			emit_signal("finished", "idle")
		
		lighting.set_default_color(owner.default_aim_color)
		lighting.width = 4
		lighting.visible = false
	owner.hitted_enemy = false
	
	
