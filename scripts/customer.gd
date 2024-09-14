extends Interactable
class_name Customer

@onready var interact_area: Area2D = $"Interact Area"
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var customer_interactions : Array = ["Follow", "Seat", "Order", "Serve"]
var SPEED : int = 150
var should_navigate : bool = false
var seat : Chair
var customer : Customer

func _ready() -> void:
	customer = self
	interact_area.area_entered.connect(on_area_entered)
	interact_area.area_exited.connect(on_area_exited)
	interaction_array.append_array(customer_interactions)
	current_interaction = interaction_array[0]
	nav.target_desired_distance = 100
	

func _physics_process(delta: float) -> void:
	navigate()
	
	
	match current_interaction:
		"Follow":
			if velocity.x < 0:
				sprite_2d.flip_h = true
			elif velocity.x > 0:
				sprite_2d.flip_h = false
				
			if player:
				nav.target_position = player.global_position
		"Seat":
			if seat:
				if velocity.x < 0:
					sprite_2d.flip_h = true
				elif velocity.x > 0:
					sprite_2d.flip_h = false
				nav.target_position = seat.customer_marker.global_position
	if InteractionManager.current_customer:
		can_be_selected = false
	else:
		if !should_navigate:
			can_be_selected = true
			
	if is_selected() and Input.is_action_just_pressed("ui_accept"):
		match current_interaction:
			"Follow":
					match InteractionManager.current_customer:
						customer:
							can_be_selected = false
							should_navigate = true
							InteractionManager.customer_currently_following = true
							if InteractionManager.current_customer == self:
								InteractionManager.current_customer = null
							else:
								InteractionManager.current_customer = self
						null:
							can_be_selected = false
							should_navigate = true
							InteractionManager.customer_currently_following = true
							if InteractionManager.current_customer == self:
								InteractionManager.current_customer = null
							else:
								InteractionManager.current_customer = self
	elif !is_selected() and Input.is_action_just_pressed("ui_accept") and InteractionManager.current_customer == self and is_player_in_area():
		match current_interaction:
			"Follow":
				can_be_selected = true
				InteractionManager.current_customer = null
				should_navigate = false
				InteractionManager.customer_currently_following = false
func navigate():
	if should_navigate:
		sprite_2d.play("Walk")
		var dir = to_local(nav.get_next_path_position()).normalized()
		if !nav.is_navigation_finished():
			velocity = dir * SPEED
			move_and_slide()
		else:
			sprite_2d.stop()
			velocity = Vector2.ZERO
			match current_interaction:
				"Seat":
					z_index = 0
					if !get_parent() is Chair:
						reparent(seat)
					sprite_2d.play("Sit")
					global_position = seat.customer_marker.global_position
					if seat.scale.x == -1:
						sprite_2d.flip_h = true
					else:
						sprite_2d.flip_h = false
