extends KinematicBody2D

onready var Missile = preload ("res://missile/Missile.tscn")
export var gravity = 10
export var speed = 40
export var radar = 500
const ground = Vector2.DOWN

var velocity = Vector2.ZERO
var direction = 1
var target
var target_in_sight = false
var pos
var isAlive = true
signal sound_missile(value)

######## ENEMIGO ESTA EN CAPA 4 ##########
func _ready():
	$Explosion.disable_damage()
	pos = $Position2D.position

func _physics_process(delta):
	velocity.x = speed * direction
	
	if direction == 1:
		#$AnimatedSprite2.play("walk")
		$AnimatedSprite2.flip_h = false
	else:
		#$AnimatedSprite2.play("walk")
		$AnimatedSprite2.flip_h = true
	
	$AnimatedSprite2.play("walk")
	
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, ground)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if target_in_sight: 
		velocity.x = 0
		if target != null and (target.global_position.x - global_position.x) < 0:
			$AnimatedSprite2.play("idle")
			$AnimatedSprite2.flip_h = true
			
			pos = $Position2D2.position
			$AnimatedSpriteExplosion.position = $Position2D2.position
			$AnimatedSpriteExplosion.flip_h = true
		else:
			$AnimatedSprite2.play("idle")
			$AnimatedSprite2.flip_h = false
			pos = $Position2D.position
			$AnimatedSpriteExplosion.position = $Position2D.position
			$AnimatedSpriteExplosion.flip_h = false

func hitted():
	isAlive = false
	$Explosion.detonate_explosion()
	$AnimatedSprite2.visible = false
	$CollisionShape2D.disabled = true
	$Timer.start()
	isAlive = false

#func set_target(target):
func set_target(targe):
	self.target = targe

func _on_Timer_timeout():
	queue_free()


func _on_ShotTimer_timeout():
	if target != null && (target.get_global_position().distance_to(self.get_global_position()) < radar):
		target_in_sight = true
		speed = 0
		if isAlive:
			shoot()
	else:
		target_in_sight = false
		speed = 30
		velocity.x = speed * direction
			
func shoot():
	if isAlive:
		
		#$AnimatedSpriteExplosion.visible = true
		#$AnimatedSpriteExplosion.play("default")
		yield(get_tree().create_timer(0.5), "timeout")
		var misil = Missile.instance()
		#emit_signal("sound_missile", 2)
		misil.target = target
		misil.position = pos
		add_child(misil)
		$AudioStreamPlayer2D.play()


func _on_AnimatedSpriteExplosion_animation_finished():
	#$AnimatedSpriteExplosion.visible = false
	pass # Replace with function body.
