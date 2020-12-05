extends KinematicBody2D

signal changeMusic(value)
signal changed_music

export var speed = 45
export var move_direction = Vector2(0,-1)
var can_move = false


func _physics_process(delta):
	if can_move:
		position += move_direction * speed * delta

func set_can_move(boolean):
	can_move=boolean

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and !can_move:
		can_move= true
		
		emit_signal("changeMusic", 2)
		emit_signal("changed_music")
	pass # Replace with function body.
