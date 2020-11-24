extends Node

onready var fxPlayer = $FxPlayer
onready var bgPlayer = $BgPlayer
onready var music = load("res://sounds/BackgroundMusic.ogg")
onready var explosion = load("res://sounds/Explosion.ogg")
onready var grappHook = load("res://sounds/GrapplingHook.ogg")
onready var tackle = load("res://sounds/Tackle.ogg")
onready var missile_explosion = load("res://sounds/explosion_missile.ogg")
onready var missile = load("res://sounds/missile.ogg")

var bgSoundsMap = {}
var fxSoundsMap = {}

func _ready():
	fxSoundsMap[0] = null
	fxSoundsMap[1] = explosion
	fxSoundsMap[2] = grappHook
	fxSoundsMap[3] = tackle
	fxSoundsMap[4] = missile_explosion
	fxSoundsMap[5] = missile
	
	bgSoundsMap[0] = null
	bgSoundsMap[1] = music

func _on_Stage1_backgroundMusic(value):
	bgPlayer.stream = bgSoundsMap[value]
	bgPlayer.play()

func _on_Character_sound(value):
	fxPlayer.stream = fxSoundsMap[value]
	fxPlayer.play()

func _on_Level1_backgroundMusic(value):
	bgPlayer.stream = bgSoundsMap[value]
	bgPlayer.play()


func _on_Level2_backgroundMusic(value):
	bgPlayer.stream = bgSoundsMap[value]
	bgPlayer.play()

func _on_Level3_backgroundMusic(value):
	bgPlayer.stream = bgSoundsMap[value]
	bgPlayer.play()

func _on_EnemyFloor_sound_missile(value):
	fxPlayer.stream = fxSoundsMap[value]
	fxPlayer.play()
