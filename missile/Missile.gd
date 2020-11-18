extends Area2D

export var speed = 350
export var steer_force = 50.0


var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

var target


func start(_transform, _target):
	global_transform = _transform
	velocity = transform.x * speed
	target = _target
	
func _physics_process(delta):
	if target == null:
		queue_free()
	else :
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
		position += velocity * delta



func seek():
	var steer = Vector2.ZERO
	var desired = (target.global_position - global_position).normalized() * speed
	steer = (desired - velocity).normalized() * steer_force
	return steer
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#

#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#
func _on_Missile_body_entered(body):
	queue_free()
	if body.is_in_group("player"):
		body.die()


func _on_Lifetime_timeout():
	queue_free()