extends Node

onready var interval = $Interval
var degradation:float = 1
export var next_scene : PackedScene

func _ready():
	set_process(false)

func _process(delta):
	interval.text.set("custom_colors/font_color", Color(1, 1, 1, degradation))
	degradation -= 2 * delta 
	if degradation < -0.5:
		get_tree().change_scene_to(next_scene)
		
func _on_Interval_bajarTexto():
	interval.tween.interpolate_property(interval.text, "rect_position", interval.text.get_rect().position, interval.position2D.global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	interval.tween.start()

func _on_Interval_borrarTexto():
	set_process(true)
