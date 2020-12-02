extends Node

onready var interval = $Interval
export var next_scene : PackedScene
var degradation:float = 1

func _ready():
	set_process(false)
	pass

func _process(delta):
	interval.text.set("custom_colors/font_color", Color(1, 1, 1, degradation))
	degradation -= 0.1

func _on_Interval_bajarTexto():
	interval.tween.interpolate_property(interval.text, "rect_position", interval.text.get_rect().position, interval.position2D.global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	interval.tween.start()

func _on_Interval_borrarTexto():
	set_process(true)
	get_tree().change_scene_to(next_scene)
