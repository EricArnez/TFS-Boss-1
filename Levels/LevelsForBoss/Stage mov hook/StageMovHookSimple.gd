extends Node2D

onready var player :Character = $Character 
onready var player_spawn_position : Position2D = $Position2DPlayerRespawn
onready var soundPlayer = $SoundPlayer

onready var restart_UI_template = preload("res://UI/Restart_UI/Restart_UI.tscn")
onready var character_template = preload("res://Character/Character.tscn")
onready var wall_template = preload("res://objects/ParedMadera/ParedMaderaOtroColor.tscn")
onready var enemy_template = preload("res://Enemies/enemy ground/Enemy.tscn")
onready var platform_template = preload("res://objects/platforms/falling/PlatformFalling.tscn")
onready var movHook_simple_template = preload("res://objects/hook/HookMovSimple.tscn")
onready var pause_template = preload("res://Pause/Pause.tscn")

var all_walls_pos: Array 
var all_enemies_pos: Array 
var all_platforms_pos: Array
var all_movhook_simple_pos: Array

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
	emit_signal("backgroundMusic", 4)
	get_all_walls_positions()
	get_all_enemies_positions()
	get_all_platforms_positions()
	get_all_movhook_simple_positions()
	spawn_player()
	give_target_to_all_enemies()
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
		destroy_all_enemies()
		destroy_all_platforms()
		destroy_all_mov_hook_simples()
		var pause = pause_template.instance()
		var new_player:Character = character_template.instance()
		
		new_player.global_position = player_spawn_position.global_position
		new_player.connect("die", self,"_on_Character_die")
		new_player.connect("sound", soundPlayer,"_on_Character_sound")
		new_player.add_child(pause)
		#add_child(new_player)
		player = new_player
		call_deferred("add_child", new_player)
		#if is_instance_valid($Enemies/EnemyFloor):
			#$Enemies/EnemyFloor.set_target(new_player)
	#		$Enemies/EnemyFloor2.set_target(new_player)
	#		$Enemies/EnemyFloor3.set_target(new_player)
		
		
		#ya se llamo restart ui previene que se llame mas de una vez esto.
		ya_se_llamo_restart_ui = true
		reset_acids()
		reset_walls()
		reset_enemies()
		reset_platforms()
		reset_movhook_simples()


func set_ya_se_llamo_restart_ui(boolean):
	ya_se_llamo_restart_ui = boolean


func _on_Checkpoint1_body_entered(body):
	if (body.is_in_group("player")):
		player_spawn_position.position = body.position
		reset_acids()
	pass # Replace with function body.

func give_target_to_all_enemies():
	for enemy in get_tree().get_nodes_in_group("enemyfloor"):
		enemy.set_target(player)
	pass
	

func reset_acids():
	for acid in get_tree().get_nodes_in_group("acid"):
		acid.reset_position()
	pass
	
func get_all_walls_positions():
	for wall in get_tree().get_nodes_in_group("wall"):
		all_walls_pos.append(wall.global_position)

func get_all_movhook_simple_positions():
	for movhooksimple in get_tree().get_nodes_in_group("movhooksimple"):
		all_movhook_simple_pos.append(movhooksimple.global_position)

func get_all_platforms_positions():
	for platform in get_tree().get_nodes_in_group("platform"):
		all_platforms_pos.append(platform.global_position)
	pass

func get_all_enemies_positions():
	for enemy in get_tree().get_nodes_in_group("enemyfloor"):
		all_enemies_pos.append(enemy.global_position)

func destroy_all_enemies():
	for enemy in get_tree().get_nodes_in_group("enemyfloor"):
		enemy.queue_free()

func destroy_all_mov_hook_simples():
	for movhooksimple in get_tree().get_nodes_in_group("movhooksimple"):
		movhooksimple.queue_free()

func destroy_all_walls():
	for wall in get_tree().get_nodes_in_group("wall"):
		wall.queue_free()

func destroy_all_platforms():
	for platform in get_tree().get_nodes_in_group("platform"):
		platform.queue_free()

func reset_walls():
	var index = 1
	for wall_pos in all_walls_pos:
		var new_wall = wall_template.instance()
		new_wall.global_position = wall_pos
		new_wall.connect("detonate", soundPlayer, "_on_ParedMaderaOtroColor" + str(index) + "_detonate")
		call_deferred("add_child", new_wall)
		index += 1
	pass

func reset_platforms():
	for platform_pos in all_platforms_pos:
		var new_platform = platform_template.instance()
		new_platform.global_position = platform_pos
		call_deferred("add_child", new_platform)

func reset_movhook_simples():
	for hookmovsimple_pos in all_movhook_simple_pos:
		var new_hookmovsimple = movHook_simple_template.instance()
		new_hookmovsimple.global_position = hookmovsimple_pos
		new_hookmovsimple.speed = 222
		call_deferred("add_child", new_hookmovsimple)

func reset_enemies():
	for enemy_pos in all_enemies_pos:
		var new_enemy = enemy_template.instance()
		new_enemy.global_position = enemy_pos 
		new_enemy.set_target(player)
		call_deferred("add_child", new_enemy)
	pass
	

func _on_Checkpoint2_body_entered(body):
	if (body.is_in_group("player")):
		player_spawn_position.position = body.position
	pass # Replace with function body.

