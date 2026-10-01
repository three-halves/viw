class_name WaveHandler
extends Node2D

@export var player: Player
@export var enemy_instance_scene: PackedScene
@export var item_pickup_scene: PackedScene
@export var bar: Bar
@export var wave_timer_progress: ProgressBar

@export var retry_menu: Control

var wave_num: int = 0

class PoolEntry:
	var bias: float
	var enemy_name: String

var enemy_pool_entries: Array[PoolEntry] = []

var current_pool: Dictionary[float, String] = {}
# keeping track of max value instead of normalizing all values
# to prevent floating point issues w/ high number of entries
var max_pool_value: float = 0.0

var behaviors: Dictionary = {
	
}

func add_behavior(b: WaveBehavior):
	if behaviors.has(b.wave_range.x):
		behaviors[b.wave_range.x].append(func(): b.apply_behavior(self))
	else:
		behaviors[b.wave_range.x] = [(func(): b.apply_behavior(self))]
		
	if behaviors.has(b.wave_range.y):
		behaviors[b.wave_range.y].append(func(): b.revert_behavior(self))
	else:
		behaviors[b.wave_range.y] = [(func(): b.revert_behavior(self))]

func create_enemy_instance(e: Enemy, x: int, y: int):
	var inst: EnemyInstance = enemy_instance_scene.instantiate()
	inst.setup(e, player, self)
	inst.position = Vector2(x, y)
	get_parent().add_child.call_deferred(inst)
	
# TODO implement this
func update_current_pool() -> void:
	current_pool = {}
	var place: float = 0
	for entry in enemy_pool_entries:
		if entry.bias == 0: continue
		current_pool[place] = entry.enemy_name
		place += entry.bias
		
	max_pool_value = place
	
func add_pool_entry(enemy_name: String, bias: float) -> void:
	var e = PoolEntry.new()
	e.bias = bias
	e.enemy_name = enemy_name
	enemy_pool_entries.append(e)
	update_current_pool()
	
func remove_pool_entry(enemy_name: String) -> void:
	for e in enemy_pool_entries:
		if e.enemy_name == enemy_name:
			enemy_pool_entries.erase(e)
			update_current_pool()
			return

func _ready() -> void:
	wave_num = 0
	retry_menu.hide()
	for b: WaveBehavior in ContentRegistry.WAVE_BEHAVIOR_REGISTRY:
		add_behavior(b)
	_on_wave_timer_timeout()
	
func _process(delta):
	wave_timer_progress.value = $WaveTimer.time_left

func spawn_pickup(beat: Beat, x: float, y: float):
	var inst: ItemPickup = item_pickup_scene.instantiate()
	print(bar)
	inst.setup(beat, bar)
	inst.position = Vector2(x, y)
	get_parent().add_child.call_deferred(inst)
	
func handle_lose():
	await get_tree().create_timer(0.5).timeout
	retry_menu.show()
	Engine.time_scale = 0.0


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	
func create_enemy_at_random_pos(enemy: String):
	# random angle and distance from player
	var angle: float = randf() * 360
	var dist: float = randf_range(1000, 3500)
	var spawn_pos: Vector2 = Vector2(
		cos(angle) * dist + player.position.x, 
		sin(angle) * dist + player.position.y
		)
		
	create_enemy_instance(ContentRegistry.ENEMY_REGISTRY[enemy], spawn_pos.x, spawn_pos.y)

func get_random_enemy() -> String:
	var x: float = randf() * max_pool_value
	var keys: Array[float] = current_pool.keys()
	keys.sort()
	
	# linear search of enemy pool
	var last_candidate = keys[0]
	var candidate = keys[0]
	for i in range(1, keys.size()):
		candidate = keys[i]
		if candidate > x:
			return current_pool[last_candidate]
			
		last_candidate = keys[i]
			
	return current_pool[last_candidate]

func _on_wave_timer_timeout():
	# update wave num
	# TODO separate visual component from logical component
	wave_timer_progress.get_node("Label").text = "Wave " + str(wave_num)
	wave_num += 1
	
	# apply behaviors
	if behaviors.has(wave_num):
		for c: Callable in behaviors[wave_num]:
			c.call()
	
	# spawn enemies
	var n = 10 + wave_num * 2
	for i in n:
		var enemy_string: String = get_random_enemy()
		create_enemy_at_random_pos(enemy_string)
		
		
		
		
