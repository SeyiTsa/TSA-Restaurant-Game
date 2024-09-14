extends CharacterBody2D

var direction : Vector2
var speed : int = 200
var sprint_speed : int = 300
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	
	direction = Input.get_vector("left","right","up","down").normalized()
	
	if direction:
		velocity = velocity.move_toward(direction * get_speed(), delta * get_acceleration())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * get_acceleration())
	move_and_slide()
	var input_vector : Vector2
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	match input_vector:
		Vector2(1, 0):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("Walk Side")
		Vector2(-1, 0):
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("Walk Side")
		Vector2(0, 1):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("Walk Front")
		Vector2(0, -1):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("Walk Back")
		Vector2(1, -1):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("Walk Side")
		Vector2(-1, -1):
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("Walk Side")
		Vector2(1, 1):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("Walk Side")
		Vector2(-1, 1):
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("Walk Side")
		Vector2(0, 0):
			animated_sprite_2d.stop()
func get_speed() -> int:
	if Input.is_action_pressed("sprint"):
		return sprint_speed
	return speed
	
func get_acceleration() -> int:
	return 3200
