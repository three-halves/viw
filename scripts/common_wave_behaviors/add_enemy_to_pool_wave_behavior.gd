class_name AddEnemyToPoolWaveBehavior
extends WaveBehavior

@export var enemy_name: String
@export var spawn_bias: float = 1.0

func apply_behavior(handler: WaveHandler) -> void:
	handler.add_pool_entry(enemy_name, spawn_bias)
	
func revert_behavior(handler: WaveHandler) -> void:
	handler.remove_pool_entry(enemy_name)
