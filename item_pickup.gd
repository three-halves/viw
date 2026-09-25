class_name ItemPickup
extends Area2D

var beat: Beat
var bar: Bar

func setup(_beat: Beat, _bar: Bar) -> void:
	beat = _beat
	bar = _bar
	$Sprite2D.texture = beat.icon



func _on_body_entered(body):
	var player: Player = body as Player
	
	if player:
		bar.set_beat(beat, bar.current_beat_index)
		bar.visual.pickup_sounds.stream = beat.pickup_sfx
		bar.visual.pickup_sounds.play()
		queue_free()
