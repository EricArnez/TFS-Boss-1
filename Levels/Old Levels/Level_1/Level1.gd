extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal backgroundMusic(value)

onready var soundPlayer = $SoundPlayer

export var next_scene : PackedScene
export var current_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Character.set_timer(20)
	$Character.connect("sound", soundPlayer, "_on_Character_sound")
	emit_signal("backgroundMusic", 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
