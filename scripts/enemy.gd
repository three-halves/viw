class_name Enemy
extends Object

var health = 10
var speed: int = 16
var drop_chance: float = 0.1
var scale_range: Vector2 = Vector2(1.0, 1.0)
var on_hit: Callable
var on_death: Callable
var on_spawn: Callable
var on_beat: Callable
# used for collision and visual
var shape: PackedVector2Array
var do_ai_movement: Callable

var drop_pool: Array[Beat]
