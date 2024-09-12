extends CharacterBody2D

var direction : Vector2
var speed : int = 300
var sprint_speed : int = 400
func _process(delta: float) -> void:
	
	direction = Input.get_vector("left","right","up","down").normalized()
	
	if direction:
		velocity = velocity.move_toward(direction * get_speed(), delta * get_acceleration())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * get_acceleration())
	move_and_slide()

func get_speed() -> int:
	if Input.is_action_just_pressed("ui_accept"):
		return sprint_speed
	return speed
	
func get_acceleration() -> int:
	return 3200
