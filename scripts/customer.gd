extends Interactable
class_name Customer

@onready var interact_area: Area2D = $"Interact Area"
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree

var customer_interactions : Array = ["Follow", "Seat", "Order", "Serve"]
var SPEED : int = 150
var should_navigate : bool = false
var seat : Chair
var customer : Customer
var is_sitting : bool

func _ready() -> void:
	customer = self
	interact_area.area_entered.connect(on_area_entered)
	interact_area.area_exited.connect(on_area_exited)
	interaction_array.append_array(customer_interactions)
	current_interaction = interaction_array[0]
	nav.target_desired_distance = 60
	

func _physics_process(delta: float) -> void:
	navigate()
	
	
	match current_interaction:
		"Follow":
			if velocity.x < 0:
				sprite_2d.flip_h = true
			elif velocity.x > 0:
				sprite_2d.flip_h = false
			else:
				if player:
					if player.global_position.x > global_position.x:
						sprite_2d.flip_h = false
					elif player.global_position.x < global_position.x:
						sprite_2d.flip_h = true
				
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
		var dir = to_local(nav.get_next_path_position()).normalized()
		update_animation_parameters(dir)
		if !nav.is_navigation_finished():
			velocity = dir * SPEED
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			match current_interaction:
				"Seat":
					z_index = 0
					if !get_parent() is Chair:
						reparent(seat)
					global_position = seat.customer_marker.global_position
					is_sitting = true
					update_animation_parameters(Vector2.ZERO)
					if seat.scale.x == -1:
						sprite_2d.flip_h = true
					else:
						sprite_2d.flip_h = false
	else:
		var dir = to_local(nav.get_next_path_position()).normalized()
		update_animation_parameters(dir)
func update_animation_parameters(anim_dir : Vector2):
	var direction = round(anim_dir)
	if is_sitting == false:
		animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	else:
		animation_tree.set("parameters/conditions/idle", false)
	animation_tree.set("parameters/conditions/is_moving", velocity != Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_sitting", is_sitting)
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction
	animation_tree["parameters/Sit/blend_position"] = direction


	
