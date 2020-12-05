extends Node2D

export var next_scene : PackedScene

onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var animatedSprite : AnimatedSprite = $AnimatedSprite
var already_entered = false


func _ready():
	animatedSprite.play("default")
	pass 

func teleport():
	if isLastLevel():
		get_tree().change_scene("res://Levels/Animation Win/AnimationWin.tscn")
	else:
		already_entered = true
		anim_player.play("fade_in")
		$Timer.start()

func _on_Exit_body_entered(body):
	if body.is_in_group("player") and !already_entered:
		teleport()
		
func isLastLevel():
	return get_parent().get_name() == "Stage4" or get_parent().get_name() == "StageAcido"

func _on_Timer_timeout():
	get_tree().change_scene_to(next_scene)
