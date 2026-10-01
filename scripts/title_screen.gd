extends Control

func _ready():
	Engine.time_scale = 1.0

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_button_pressed():
	get_tree().quit() # Replace with function body.
