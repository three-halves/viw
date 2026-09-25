class_name EnemyInstance
extends StaticBody2D

@export var collision_polygon: CollisionPolygon2D
@export var visual_polygon: PolygonVisual

@export var bullet_instance: PackedScene

var enemy: Enemy
var player: Player
var wave_handler: WaveHandler
var health: int = 0
var _scale: float = 1.0
var time_since_hit: float = 0.0

var instance_state: Dictionary[String, float]

func setup(e: Enemy, p: Player, w: WaveHandler) -> void:
	enemy = e
	player = p
	wave_handler = w
	time_since_hit = 999

	_scale = randf_range(e.scale_range.x, e.scale_range.y)
	health = e.health * _scale
	#scale = Vector2(_scale, _scale)
	if e.on_beat: wave_handler.bar.timeout.connect(func(): e.on_beat.call(instance_state, self, wave_handler.bar.current_beat_index))
	
func _ready():
	var _shape: PackedVector2Array
	for v in enemy.shape:
		_shape.append(v * _scale)
	collision_polygon.polygon = _shape
	visual_polygon.overwrite_polygon(_shape)
	enemy.on_spawn.call(instance_state, self)
	
func _process(delta):
	time_since_hit += delta
	visual_polygon.color.r = 0.75 - time_since_hit * 3.0
	
func _physics_process(delta: float):
	var wish_dir = enemy.do_ai_movement.call(instance_state, self, player)
	var collision = move_and_collide(wish_dir * delta)
	if collision:
		var bullet: BulletInstance = collision.get_collider() as BulletInstance
		var _player: Player = collision.get_collider() as Player
		if bullet:
			health -= bullet.damage
			time_since_hit = 0.0
			$AudioStreamPlayer2D.play()
			if health <= 0:
				try_drop()
				if enemy.on_death: enemy.on_death.call()
				queue_free()
			bullet.queue_free()
			
		if _player:
			print("hit player")
			if (player.itime <= 0): 
				player.take_damage()
				player.velocity += wish_dir * delta * 2
				queue_free()
			
func try_drop():
	if randf() > enemy.drop_chance: return
	
	var drop = enemy.drop_pool[randi_range(0, enemy.drop_pool.size()-1)]
	wave_handler.spawn_pickup(drop, position.x, position.y)
	
func spawn_shot(shot: ShotType, damage_mult: float, level: int) -> void:
#	TODO make (bullet, size, damage) its own type instead of 3 arrays
	for i in shot.bullets.size():
		var inst: BulletInstance = bullet_instance.instantiate()
		inst.setup(shot.bullets[i], rotation + deg_to_rad(shot.angle_offsets[i]), shot.base_damages[i] * damage_mult, level)
		inst.position = position
		get_parent().add_child(inst)
	
	
	
