extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal backgroundMusic(value)

onready var soundPlayer = $SoundPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Character.set_timer(30)
	$Character.connect("sound", soundPlayer, "_on_Character_sound")
	emit_signal("backgroundMusic", 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
