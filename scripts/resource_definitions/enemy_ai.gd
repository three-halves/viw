@abstract class_name EnemyAi
extends Resource

## Called to initialize each given enemy instance. Should return instance of AI class
## initialized with the desired params.
@abstract func create() -> EnemyAi

## Called each physics step. EnemyInstance should NOT be modified to change the enemy's position.
## Return a Vector2 representing the desired movement on the x and y axis
@abstract func do_movement_step(instance: EnemyInstance, player: Player) -> Vector2

## Called at the beginning of each in-game measure "beat"
@abstract func on_beat(instance: EnemyInstance, player: Player, beat_idx: int) -> void

## Called when this enemy is hit by a player projectile.
@abstract func on_damaged(instance: EnemyInstance, player: Player, damage_amount: int) -> void

## Called when this enemy's health reaches 0, before they are removed from the scene tree.
@abstract func on_death(instance: EnemyInstance, player: Player) -> void

## Called immediately after this enemy enters the scene tree.
@abstract func on_spawn(instance: EnemyInstance, player: Player) -> void
