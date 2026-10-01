class_name Bar
extends Timer

# Giving Bar references to everything is a bit sloppy but im trying to avoid
# going crazy with signals for now
@export var player: Player

# exported for debugging
@export var beats: Array[Beat] = [null, null, null, null]
var levels: Array[int] = [0, 0, 0, 0]
var current_beat_index = 0
@export var visual: BarVisual

func _ready() -> void:
	wait_time = (1.0 / GameSettings.BPM) * 60
	start()
	$Music.play()
	print(wait_time)
	
func set_beat(beat: Beat, index: int) -> void:
	if beat == beats[index]:
		levels[index] = min(levels[index] + 1, 2)
	else:
		beats[index] = beat
		levels[index] = 0
		
	visual._on_loadout_update()
	
func _on_timeout():
	current_beat_index = (current_beat_index + 1) % beats.size()	
	var beat = beats[current_beat_index];
	if beat == null: return;
	if beat.shot_type != null: player.spawn_shot(beat.shot_type, beat.damage_mult, levels[current_beat_index])
	if GameSettings.SIDE_EFFECT_REGISTRY.has(beat.side_effect_id): 
		var side_effect = GameSettings.SIDE_EFFECT_REGISTRY[beat.side_effect_id]
		side_effect.call(player, levels[current_beat_index])
