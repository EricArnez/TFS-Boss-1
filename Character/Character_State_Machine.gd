extends "res://Character/State_Machine.gd"

signal sound(value)

func _ready():
	owner = get_parent()
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"lighting": $Lighting,
		"impulse": $Impulse,
		"attack": $Attack,
		"tackle": $Tackle
	}
	
	for state in states_map.values():
		state.owner = owner

func _change_state(state_name):
	if not _active:
		return
	if state_name == "jump":
		states_stack.push_front(states_map[state_name])
		$Jump.initialize(350, Vector2(350,0))
	if state_name == "jump" and current_state == $Move:
		$Jump.initialize($Move.speed, $Move.velocity)
	if state_name == "impulse"  and current_state == $Lighting:
		$Impulse.initialize(current_state.direction , current_state.velocity, current_state.hookPosition)	
		
	._change_state(state_name)
	
		
	
func _unhandled_input(event):
	## el lighting deberia interrumpir estados
	if Input.is_action_just_pressed("lighting"):# or Input.is_pressed"lighting") :
		emit_signal("sound", 2)
		current_state.owner.shoot_lighting()
	## el ataque tambien
#	Por el momento quitamos al laser
	if Input.is_action_just_pressed("attack"):# or Input.is_pressed"lighting") :
		current_state.owner.shoot_attack()
	if Input.is_action_just_pressed("tackle"):# or Input.is_pressed"lighting") :
		current_state.owner.tackle()
	current_state.handle_input(event)

func changeToLighting(attraction_direction, hook):
	$Lighting.initialize(attraction_direction, $Move.speed, $Move.velocity, hook)
	._change_state("lighting")
	
func changeToAttack(enemy):
	$Attack.initialize(enemy)
	._change_state("attack")

func changeToTackle(attraction_direction, enemy):
	$Tackle.initialize(attraction_direction, $Move.speed, $Move.velocity, enemy)
	._change_state("tackle")
