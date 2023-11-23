extends Character
class_name Player


const FLOATY_GRAVITY_WEIGHT = 0.015


var controllable = true
var drama_interface: AreaDramaInterface = null


func _physics_process(delta):
	if controllable:
		_input_process()
	super._physics_process(delta)


func _input_process():
	dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sfx.play()
		velocity += Vector2(0, -1 * JUMP_SPEED)
	
	if Input.is_action_pressed("jump"):
		effective_gravity = FLOATY_GRAVITY_WEIGHT
	else:
		effective_gravity = GRAVITY_WEIGHT
	
	if Input.is_action_just_pressed("talk") and drama_interface != null:
		take_control()
		var drama_interface_ref = drama_interface
		await move_h(drama_interface.standing_pos[0] - position[0])
		queue_flip_h = drama_interface_ref.look_left
		
		drama_interface_ref.drama_player.connect_display(drama_display)
		await drama_interface_ref.play_drama()
		drama_interface_ref.drama_player.disconnect_display(drama_display)
		
		if drama_interface != null:
			drama_interface.display_trigger()
		
		return_control()


func take_control():
	controllable = false
	dir = Vector2(0, 0)
	effective_gravity = GRAVITY_WEIGHT


func return_control():
	controllable = true


func enter_cutscene_area(area):
	drama_interface = area.get_parent()
	drama_interface.display_trigger()


func exit_cutscene_area(area):
	if drama_interface != null:
		if controllable:
			drama_interface.hide_trigger()
		drama_interface = null
