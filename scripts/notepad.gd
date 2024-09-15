extends PanelContainer

var state : String
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("RESET")

func _on_mouse_entered() -> void:
	if state != "Up":
		anim.play("pop up")
		state = "Up"
 


func _on_mouse_exited() -> void:
	if state != "Down":
		anim.play("down")
		state = "Down"
