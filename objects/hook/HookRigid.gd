extends RigidBody2D

#mask 1 y 2
#layer 1 y 2
	
	
## cuiidado al usar esto que puede romperse :V actualizar el inpulso primero.

func glow_on():
	$Light2D.set_process(true)
	$Light2D.visible = true
	
func glow_off():
	$Light2D.visible = false
	$Light2D.set_process(false)


func _on_Hook_area_entered(area):
	#aca se produciria el efecto
	pass 
