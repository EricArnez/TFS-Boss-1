extends KinematicBody2D
#El nodo Raycast esta em la mascara de colision 1 y 2
#para que detecte a los hooks


class_name Character
onready var timer:=$LevelTimer
onready var raycast2d:= $RayCast2DLighting
onready var lighting:= $Line2DLighting
onready var body:= $BodyPivot
onready var csm:= $Character_State_Machine
onready var itimer:= $ImpulseTimer

var last_hook_hitted = null
var hitted_hook = false
var default_aim_color = null
var hitted_enemy = false
var hitCount = 0

signal direction_changed(new_direction)
signal hit(value)
signal sound(value)

signal die(pos)

var look_direction = Vector2.RIGHT setget set_look_direction

######### CHARACTER ESTA EN CAPA 3 ###########
######### VER RAYCAST2D COLLISION PARA AGREGAR COLISIONES ##########

func _ready():
	#$DeathSprite.visible = false
	lighting.visible = false
	default_aim_color = lighting.get_default_color()
	lighting.set_default_color(default_aim_color)
	#get_parent().set_ya_se_llamo_restart_ui(false)#parche horrible por checkpoint
	
	
func set_timer(seconds):
	timer.value = seconds

func _process(delta):
	raycast2d.global_position = body.get_global_position()
	lighting.points[0] = body.position
	
	
func _physics_process(delta):
	if raycast2d.is_colliding():
		lighting.set_point_position(1, transform.xform_inv(raycast2d.get_collision_point()))
		
	else:
		lighting.set_point_position(1, transform.xform_inv(get_global_mouse_position()))
	if hitted_hook:
		lighting.set_point_position(1, transform.xform_inv(last_hook_hitted.get_global_position()))
		lighting.set_default_color(ColorN("darkturquoise",1))

func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)

func shoot_lighting():
	raycast2d.force_raycast_update()
	if raycast2d.is_colliding():
		if raycast2d.get_collider().is_in_group("hook") and !hitted_hook:
			hitCount += 1
			emit_signal("sound", 2)
			emit_signal("hit", hitCount, $HitPositionLeft.position)
			last_hook_hitted = raycast2d.get_collider()
			hitted_hook = true
			var attraction_direction = (raycast2d.get_collider().get_global_position() - body.get_global_position()).normalized()
			#var hookPosition = raycast2d.get_collider().get_global_position() #raycast2d.get_collider().get_global_position()
			var hook = raycast2d.get_collider() #raycast2d.get_collider().get_global_position()
			
			csm.changeToLighting(attraction_direction, hook)

		if !raycast2d.get_collider().is_in_group("hook"):
			missed_shoot_start()
	else:
		missed_shoot_start()
	pass



func tackle():
	raycast2d.force_raycast_update()
	if raycast2d.is_colliding():
		if raycast2d.get_collider().is_in_group("enemy") and !hitted_enemy:
			hitCount += 1
			emit_signal("hit", hitCount, $HitPositionLeft.position)
			last_hook_hitted = raycast2d.get_collider()
			
			var attraction_direction = (raycast2d.get_collider().get_global_position() - body.get_global_position()).normalized()
			var enemy = raycast2d.get_collider()
			#resetHitCount()
			emit_signal("sound", 3)
			#emit_signal("hit", hitCount, $HitPositionRight.position) 
			hitted_enemy = true
			csm.changeToTackle(attraction_direction, enemy)
		if !raycast2d.get_collider().is_in_group("enemy"):
			missed_tackle_start()
	else:
		missed_tackle_start()

func shoot_attack():
	raycast2d.force_raycast_update()
	if hitCount >= 3:
		if raycast2d.is_colliding():
			if raycast2d.get_collider().is_in_group("enemy"):
				hitted_hook = false
				#resetHitCount()
				emit_signal("sound", 2)
				#emit_signal("hit", hitCount, $HitPositionRight.position) 
				csm.changeToAttack(raycast2d.get_collider())
				#csm.changeToAttack(raycast2d.get_collider().get_global_position())
				#raycast2d.get_collider().hitted()
			else:
				missed_attack_start()


func clear_hits():
	resetHitCount()
	emit_signal("hit", hitCount, $HitPositionRight.position) 


func missed_shoot_start():
	emit_signal("sound", 2)
	lighting.set_default_color(default_aim_color)
	lighting.visible = true
	lighting.set_default_color(default_aim_color)
	$ShootTimer.start()
	hitted_hook = false

func missed_attack_start():
	emit_signal("sound", 2)
	lighting.set_default_color(ColorN("salmon",1))
	lighting.visible = true
	lighting.set_default_color(ColorN("salmon",1))
	$ShootTimer.start()

func missed_tackle_start():
	emit_signal("sound", 3)
	lighting.set_default_color(ColorN("goldenrod",1))
	lighting.visible = true
	lighting.set_default_color(ColorN("goldenrod",1))
	$ShootTimer.start()
	hitted_enemy = false

func got_hit():
	die() #no creo que este bueno lo de un hit y moris si agregamos un boss

func die():
	
	$Camera2D.clear_current()
	emit_signal("sound", 1)
	emit_signal("die", self.position)
	queue_free()
	#$CollisionShape2D.queue_free()
#	$BodyPivot/AnimatedSprite3.visible = false
#	$DeathSprite.visible = true
#	$DeathSprite.play("dead")
	#csm.changeToDie()
	#get_viewport()._unhandled_input()
	#$AnimationPlayer.play("fade_in")
	#aca habria que agregar alguna animacion o algo
	
	#aca habria que agregar alguna animacion o algo
	

func _on_LevelTimer_timeOut():
	# probablemente terminemos sacando la mecanica de morir por tiempo por default
	#die()
	pass
	
func _on_ShootTimer_timeout():
	lighting.visible = false
	lighting.set_default_color(default_aim_color)
	lighting.width = 4

func resetHitCount():
	hitCount = 0
	
func increase_hit_count():
	hitCount+=1

func get_hit_count():
	return hitCount
	
func play_atraction_sound():
	emit_signal("sound", 2)

func show_hit_count(): 
	emit_signal("hit", hitCount, $HitPositionLeft.position)
#
#
#func _on_AnimatedSprite_animation_finished():
#	queue_free()
#	pass # Replace with function body.

