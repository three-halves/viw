extends Node

var BPM: int = 160

var SIDE_EFFECT_REGISTRY: Dictionary[String, Callable] = {
	"dash":
		func(player: Player, level: int) -> void:
			player.velocity *= 2.5 + (0.5 * level)
			if (level == 2): player.itime = 1.0 / BPM * 60
}

var ENEMY_REGISTRY: Dictionary[String, Enemy] = {}
func _ready() -> void:
	var e: Enemy = Enemy.new()
	e.health = 1
	e.speed = 1
	e.shape = [
		Vector2(-16, -16),
		Vector2(16, -16),
		Vector2(16, 16),
		Vector2(-16, 16)
		]
	e.scale_range = Vector2(5.0, 10.0)
	e.do_ai_movement = func(state: Dictionary[String, float], inst: EnemyInstance, player: Player) -> Vector2:
		var dir = state["dir"]
		return Vector2(cos(dir), sin(dir))
	e.drop_pool = [preload("res://resources/shot/basic_beat.tres")]
	e.on_spawn = func(state: Dictionary[String, float], inst: EnemyInstance) -> void:
		state["dir"] = randf_range(0, 360)
	e.drop_chance = 0.3
	ENEMY_REGISTRY["asteroid"] = e
	
	e = Enemy.new()
	e.health = 1
	e.speed = 1
	e.shape = [
		Vector2(0, -24),
		Vector2(24, 0),
		Vector2(0, 24),
		Vector2(-24, 0)
		]
	e.scale_range = Vector2(5.0, 10.0)
	e.do_ai_movement = func(state: Dictionary[String, float], inst: EnemyInstance, player: Player) -> Vector2:
		var dir = state["dir"]
		return Vector2(cos(dir), sin(dir))
	e.drop_pool = [preload("res://resources/shot/dash_beat.tres")]
	e.on_spawn = func(state: Dictionary[String, float], inst: EnemyInstance) -> void:
		state["dir"] = randf_range(0, 360)
	e.drop_chance = 1.0
	ENEMY_REGISTRY["asteroid2"] = e
	
	
	e = Enemy.new()
	e.health = 1.5
	e.speed = 7
	e.shape = [
		Vector2(0, -8),
		Vector2(-16, 28),
		Vector2(0, 2),
		Vector2(16, 28)
		]
	e.scale_range = Vector2(3.0, 5.0)
	e.on_spawn = func(state: Dictionary[String, float], inst: EnemyInstance) -> void:
		state["vel"] = 0
		state["dir"] = 0
	e.do_ai_movement = func(state: Dictionary[String, float], inst: EnemyInstance, player: Player) -> Vector2:
		state["vel"] = (state["vel"] + e.speed) * 0.99
		state["dir"] += inst.get_angle_to(player.position) * 0.04
		inst.rotation = state["dir"]
		return Vector2(cos(inst.rotation), sin(inst.rotation)) * state["vel"]
	e.on_beat = func(state: Dictionary, inst: EnemyInstance, beat_idx: int) -> void:
		if randf() > 0.9:
			state["vel"] = 1500
			state["dir"] += (randi_range(0, 1) * 2 - 1) * 90
	e.drop_pool = [preload("res://resources/shot/triple_shot_beat.tres"), preload("res://resources/shot/side_beat.tres")]
	e.drop_chance = 0.25

	ENEMY_REGISTRY["basic"] = e
	
	
	e = Enemy.new()
	e.health = 1.75
	e.speed = 5
	e.shape = [
		Vector2(0, -8),
		Vector2(-20, 28),
		Vector2(-4, 8),
		Vector2(4, 8),
		Vector2(20, 28)
		]
	e.scale_range = Vector2(3.0, 5.0)
	e.on_spawn = func(state: Dictionary[String, float], inst: EnemyInstance) -> void:
		state["vel"] = 0
		state["dir"] = 0
		state["targ_x"] = randf_range(400, 600) * randi_range(0, 1) * 2 - 1
		state["targ_y"] = randf_range(400, 600) * randi_range(0, 1) * 2 - 1
		state["beat_count"] = 0.0
	e.do_ai_movement = func(state: Dictionary[String, float], inst: EnemyInstance, player: Player) -> Vector2:
		state["vel"] = (state["vel"] + e.speed) * 0.99
		state["dir"] = inst.rotation + inst.get_angle_to(Vector2(state["targ_x"], state["targ_y"]) + player.position)
		inst.look_at(player.position)
		return Vector2(cos(state["dir"]), sin(state["dir"])) * state["vel"]
	e.on_beat = func(state: Dictionary, inst: EnemyInstance, beat_idx: int) -> void:
		if beat_idx == 3:
			inst.spawn_shot(preload("res://resources/shot/enemy_basic_beat.tres").shot_type, 1.0, 1)
			
			
	e.drop_pool = [preload("res://resources/shot/circle_beat.tres"), preload("res://resources/shot/basic_beat.tres")]
	e.drop_chance = 0.35

	ENEMY_REGISTRY["shooter"] = e
