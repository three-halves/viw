class_name WaveHandler
extends Node2D

@export var player: Player
@export var enemy_instance_scene: PackedScene
@export var item_pickup_scene: PackedScene
@export var bar: Bar
@export var wave_timer_progress: ProgressBar

@export var retry_menu: Control

var wave_num: int = 0

func create_enemy_instance(e: Enemy, x: int, y: int):
	var inst: EnemyInstance = enemy_instance_scene.instantiate()
	inst.setup(e, player, self)
	inst.position = Vector2(x, y)
	get_parent().add_child.call_deferred(inst)
	

func _ready() -> void:
	wave_num = 0
	retry_menu.hide()
	_on_wave_timer_timeout()
	
func _process(delta):
	wave_timer_progress.value = $WaveTimer.time_left
	
func _physics_process(delta):
	if randf() < 0.005 && wave_num > 1:
		create_enemy_at_random_pos("basic")
	if randf() < 0.005:
		create_enemy_at_random_pos("asteroid")
	if randf() < 0.0025 && wave_num > 4:
		create_enemy_at_random_pos("shooter")

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
	var spawn_pos: Vector2 = Vector2(cos(angle) * dist + player.position.x, sin(angle) * dist + player.position.y)
		
	create_enemy_instance(GameSettings.ENEMY_REGISTRY[enemy], spawn_pos.x, spawn_pos.y)


func _on_wave_timer_timeout():
	wave_timer_progress.get_node("Label").text = "Wave " + str(wave_num)
	wave_num += 1
	if wave_num == 1: 
		$WaveTimer.wait_time = 30.0
		for i in 15:
			if randf() <= 0.9: create_enemy_at_random_pos("asteroid")
			else: create_enemy_at_random_pos("asteroid2")
		return
	if wave_num == 2:
		$WaveTimer.wait_time = 25.0
	# spawn enemies
	var n = 10 + wave_num * 2
	for i in n:
		if randf() <= 0.95: create_enemy_at_random_pos("asteroid")
		else: create_enemy_at_random_pos("asteroid2")
		if randf() <= 0.1: create_enemy_at_random_pos("basic")
		
	if wave_num > 3:
		for i in n:
			if randf() <= 0.25: create_enemy_at_random_pos("shooter")
		
		
		
