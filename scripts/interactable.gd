extends CharacterBody2D
class_name Interactable

@export var interaction_array : Array = []

var player_in_area : bool
var selected : bool
var current_interaction : String
var player : CharacterBody2D
var can_be_selected : bool = true
func on_area_entered(area):
	if can_be_selected:
		if area.is_in_group("player interact"):
			player_in_area = true
			if !InteractionManager.interaction_list.has(self):
				InteractionManager.interaction_list.append(self)
				player = area.get_parent()
	else:
		if area.is_in_group("player interact"):
			player_in_area = true
			if InteractionManager.interaction_list.has(self):
				InteractionManager.interaction_list.erase(self)

func on_area_exited(area):
	if area.is_in_group("player interact"):
		player_in_area = false
		if InteractionManager.interaction_list.has(self):
			InteractionManager.interaction_list.erase(self)
	
func is_selected() -> bool:
	if !InteractionManager.interaction_list.has(self):
		selected = false
	else:
		var index = InteractionManager.interaction_list.find(self)
		if index == 0 and can_be_selected:
			selected = true
		else:
			selected = false
	return selected
func is_player_in_area() -> bool:
	return player_in_area
