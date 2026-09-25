class_name BulletInstance
extends StaticBody2D
@export var sprite: Sprite2D


var bullet_type: BulletType
var setup_done: bool = false;
var movement_per_frame: Vector2
var lifetime: float
var damage: int = 0

func setup(_bullet_type: BulletType, angle: float, _damage: int, level: int) -> void:
	bullet_type = _bullet_type
	sprite.texture = bullet_type.sprite
	sprite.scale.x = 32.0 / sprite.texture.get_size().x
	sprite.scale.y = 32.0 / sprite.texture.get_size().y
	scale = bullet_type.scale * (1.0 + level * 0.25)
	movement_per_frame = Vector2(cos(angle), sin(angle)) * bullet_type.speed * (1.0 + level * 0.25);
	rotation = angle
	constant_linear_velocity = movement_per_frame
	lifetime = bullet_type.lifetime
	setup_done = true
	damage = _damage * (1.0 + level * 0.5)
	
func _physics_process(delta: float):
	if !setup_done: return;
	
	lifetime -= delta
	rotation += delta * damage * bullet_type.spin_speed
	if lifetime <= 0:
		queue_free()	
	var collision = move_and_collide(movement_per_frame)
	if collision:
		var _player = collision.get_collider() as Player
		if _player:
				print("hit player")
				if (_player.itime <= 0): 
					_player.take_damage()
				queue_free()
	
