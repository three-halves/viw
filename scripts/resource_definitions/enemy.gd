class_name Enemy
extends Resource

@export var health: float = 10
@export var drop_chance: float = 0.1
@export var scale_range: Vector2 = Vector2(1.0, 1.0)
@export var ai_type: EnemyAi
# used for collision and visual
@export var shape: PackedVector2Array

@export var drop_pool: Array[Beat]
