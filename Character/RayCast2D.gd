extends RayCast2D

onready var camera: Camera2D = get_parent().get_node("Camera2D")



func _physics_process(delta):
	var mouse_pos := get_global_mouse_position()
	var angle_from_mouse_to_player := mouse_pos.angle_to_point(global_position)
	limit_raycast_lenght()
	rotation = (angle_from_mouse_to_player - (PI/2))
	
	
func limit_raycast_lenght():
	cast_to = Vector2(0.0, 700.0) #deberia ser hasta el limite de la camara
