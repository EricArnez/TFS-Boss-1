extends Node2D

onready var player :Character = $Character 
onready var player_spawn_position : Position2D = $Position2DPlayerRespawn
onready var soundPlayer = $SoundPlayer

onready var restart_UI_template = preload("res://UI/Restart_UI/Restart_UI.tscn")
onready var character_template = preload("res://Character/Character.tscn")
onready var wall_template = preload("res://objects/ParedMadera/ParedMaderaOtroColor.tscn")
onready var plataforma_troll_template = preload("res://objects/platforms/automatic/PlatformSleeping.tscn")
onready var pause_template = preload("res://Pause/Pause.tscn")

var all_walls_pos: Array 
var plataforma_troll_pos: Vector2

signal backgroundMusic(value)

var esta_sonando_musica_troll = false
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
	emit_signal("backgroundMusic", 5)
	get_all_walls_positions()
	spawn_player()
	plataforma_troll_pos = $PlatformSleeping.global_position
	#feo hardcodeado, pero el tiempo apura.
	#$Enemies/EnemyFloor.set_target($Character)
	#$Enemies/EnemyFloor2.set_target($Character)
	#$Enemies/EnemyFloor3.set_target($Character)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawn_player():
	#call_deferred("add_child", player)
	player.global_position = player_spawn_position.global_position

func respawn_player():
	if !ya_se_llamo_restart_ui:
		destroy_all_walls()
		destroy_plataforma_troll()
		var pause = pause_template.instance()
		var new_player:Character = character_template.instance()
		
		new_player.global_position = player_spawn_position.global_position
		new_player.connect("die", self,"_on_Character_die")
		new_player.connect("sound", soundPlayer,"_on_Character_sound")
		new_player.add_child(pause)
		#add_child(new_player)
		call_deferred("add_child", new_player)
		#if is_instance_valid($Enemies/EnemyFloor):
			#$Enemies/EnemyFloor.set_target(new_player)
	#		$Enemies/EnemyFloor2.set_target(new_player)
	#		$Enemies/EnemyFloor3.set_target(new_player)
		
		
		#ya se llamo restart ui previene que se llame mas de una vez esto.
		ya_se_llamo_restart_ui = true
		reset_acids()
		reset_walls()
		var new_plataforma_troll = plataforma_troll_template.instance()
		new_plataforma_troll.connect("changeMusic", soundPlayer, "_on_PlatformSleeping_changeMusic")
		new_plataforma_troll.global_position = plataforma_troll_pos
		new_plataforma_troll.connect("changed_music", self, "_on_PlatformSleeping_changed_music")
		call_deferred("add_child", new_plataforma_troll)
		if esta_sonando_musica_troll:
			emit_signal("backgroundMusic", 5)
			esta_sonando_musica_troll = false


func set_ya_se_llamo_restart_ui(boolean):
	ya_se_llamo_restart_ui = boolean


func _on_Checkpoint1_body_entered(body):
	if (body.is_in_group("player")):
		player_spawn_position.global_position = body.global_position

func reset_acids():
	for acid in get_tree().get_nodes_in_group("acid"):
		acid.reset_position()

func get_all_walls_positions():
	for wall in get_tree().get_nodes_in_group("wall"):
		all_walls_pos.append(wall.global_position)

func destroy_all_walls():
	for wall in get_tree().get_nodes_in_group("wall"):
		wall.queue_free()
		
func destroy_plataforma_troll():
	for plat_troll in get_tree().get_nodes_in_group("troll"):
		plat_troll.queue_free()

func reset_walls():
	var index = 1
	for wall_pos in all_walls_pos:
		var new_wall = wall_template.instance()
		new_wall.global_position = wall_pos
		new_wall.connect("detonate", soundPlayer, "_on_ParedMaderaOtroColor" + str(index) + "_detonate")
		call_deferred("add_child", new_wall)
		index += 1
	pass

func _on_Checkpoint2_body_entered(body):
	if (body.is_in_group("player")):
		player_spawn_position.global_position = body.global_position

func _on_resetearAcidos_body_entered(body):
	if (body.is_in_group("player")):
		reset_acids()

func _on_PlatformSleeping_changed_music():
	esta_sonando_musica_troll = true
	
	

