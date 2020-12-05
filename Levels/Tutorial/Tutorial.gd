extends Node2D

onready var player :Character = $Character 
onready var player_spawn_position : Position2D = $Position2DPlayerRespawn
onready var soundPlayer = $SoundPlayer

onready var restart_UI_template = preload("res://UI/Restart_UI/Restart_UI.tscn")
onready var character_template = preload("res://Character/Character.tscn")

signal backgroundMusic(value)


var ya_se_llamo_restart_ui = false
#parche horrible para que funcione el checkpoint. por alguna razon se llama
# 2 veces al restart ui

func _on_Character_die(cameraDir):
	var restart_UI:Node2D = restart_UI_template.instance()
	restart_UI.global_position = cameraDir
	restart_UI.get_child(3).connect("timeOutRestart", self, "_on_Restart_UI_timeOutRestart")
	get_parent().add_child(restart_UI)
	ya_se_llamo_restart_ui = false

func _on_Restart_UI_timeOutRestart():
	respawn_player()
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	#queda mejor sin musica el tutorial. lo separa del juego.
	#emit_signal("backgroundMusic", 1)
	spawn_player()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawn_player():
	player.global_position = player_spawn_position.global_position
	

func respawn_player():
	if !ya_se_llamo_restart_ui:
		var new_player:Character = character_template.instance()
		
		new_player.global_position = player_spawn_position.global_position
		new_player.connect("die", self,"_on_Character_die")
		new_player.connect("sound", soundPlayer,"_on_Character_sound")
		add_child(new_player)
		#if is_instance_valid($EnemyFloor):
		#	$EnemyFloor.set_target(new_player)
		#	$EnemyFloor.connect("sound_missile", soundPlayer,"_on_EnemyFloor_sound_missile")
		
		
		#ya se llamo restart ui previene que se llame mas de una vez esto.
		ya_se_llamo_restart_ui = true


func set_ya_se_llamo_restart_ui(boolean):
	ya_se_llamo_restart_ui = boolean


func _on_Checkpoint1_body_entered(body):
	if (body.is_in_group("player")):
		player_spawn_position.position = body.position
	pass # Replace with function body.


func _on_Checkpoint2_body_entered(body):
	if (body.is_in_group("player")):
		player_spawn_position.position = body.position
	pass # Replace with function body.
