class_name BarVisual
extends Control
@export var audio_stream: AudioStreamPlayer
@export var shot_images: Array[TextureRect]
@export var upgrade_images: Array[TextureRect]
@export var possible_upgrade_images: Array[Texture]
@export var bar: Bar
@export var beat_indicator: TextureRect
@export var pickup_sounds: AudioStreamPlayer

func _ready():
	_on_loadout_update()

func _on_bar_timeout() -> void:
	audio_stream.play()
	var p: Vector2 = shot_images[bar.current_beat_index].position
	beat_indicator.position = Vector2(p.x, p.y + 64)
	audio_stream.stream = bar.beats[bar.current_beat_index].shot_type.sfx
	audio_stream.play()
	
func _on_loadout_update() -> void:
	for i: int in bar.beats.size():
		shot_images[i].texture = bar.beats[i].icon
		upgrade_images[i].texture = possible_upgrade_images[bar.levels[i]]


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
